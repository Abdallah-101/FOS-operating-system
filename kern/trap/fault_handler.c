/*
 * fault_handler.c
 *
 *  Created on: Oct 12, 2022
 *      Author: HP
 */

#include "trap.h"
#include <kern/proc/user_environment.h>
#include <kern/cpu/sched.h>
#include <kern/cpu/cpu.h>
#include <kern/disk/pagefile_manager.h>
#include <kern/mem/memory_manager.h>
#include <kern/mem/kheap.h>

//2014 Test Free(): Set it to bypass the PAGE FAULT on an instruction with this length and continue executing the next one
// 0 means don't bypass the PAGE FAULT
uint8 bypassInstrLength = 0;

//===============================
// REPLACEMENT STRATEGIES
//===============================
//2020
void setPageReplacmentAlgorithmLRU(int LRU_TYPE)
{
	assert(LRU_TYPE == PG_REP_LRU_TIME_APPROX || LRU_TYPE == PG_REP_LRU_LISTS_APPROX);
	_PageRepAlgoType = LRU_TYPE ;
}
void setPageReplacmentAlgorithmCLOCK(){_PageRepAlgoType = PG_REP_CLOCK;}
void setPageReplacmentAlgorithmFIFO(){_PageRepAlgoType = PG_REP_FIFO;}
void setPageReplacmentAlgorithmModifiedCLOCK(){_PageRepAlgoType = PG_REP_MODIFIEDCLOCK;}
/*2018*/ void setPageReplacmentAlgorithmDynamicLocal(){_PageRepAlgoType = PG_REP_DYNAMIC_LOCAL;}
/*2021*/ void setPageReplacmentAlgorithmNchanceCLOCK(int PageWSMaxSweeps){_PageRepAlgoType = PG_REP_NchanceCLOCK;  page_WS_max_sweeps = PageWSMaxSweeps;}
/*2024*/ void setFASTNchanceCLOCK(bool fast){ FASTNchanceCLOCK = fast; };
/*2025*/ void setPageReplacmentAlgorithmOPTIMAL(){ _PageRepAlgoType = PG_REP_OPTIMAL; };

//2020
uint32 isPageReplacmentAlgorithmLRU(int LRU_TYPE){return _PageRepAlgoType == LRU_TYPE ? 1 : 0;}
uint32 isPageReplacmentAlgorithmCLOCK(){if(_PageRepAlgoType == PG_REP_CLOCK) return 1; return 0;}
uint32 isPageReplacmentAlgorithmFIFO(){if(_PageRepAlgoType == PG_REP_FIFO) return 1; return 0;}
uint32 isPageReplacmentAlgorithmModifiedCLOCK(){if(_PageRepAlgoType == PG_REP_MODIFIEDCLOCK) return 1; return 0;}
/*2018*/ uint32 isPageReplacmentAlgorithmDynamicLocal(){if(_PageRepAlgoType == PG_REP_DYNAMIC_LOCAL) return 1; return 0;}
/*2021*/ uint32 isPageReplacmentAlgorithmNchanceCLOCK(){if(_PageRepAlgoType == PG_REP_NchanceCLOCK) return 1; return 0;}
/*2021*/ uint32 isPageReplacmentAlgorithmOPTIMAL(){if(_PageRepAlgoType == PG_REP_OPTIMAL) return 1; return 0;}

//===============================
// PAGE BUFFERING
//===============================
void enableModifiedBuffer(uint32 enableIt){_EnableModifiedBuffer = enableIt;}
uint8 isModifiedBufferEnabled(){  return _EnableModifiedBuffer ; }

void enableBuffering(uint32 enableIt){_EnableBuffering = enableIt;}
uint8 isBufferingEnabled(){  return _EnableBuffering ; }

void setModifiedBufferLength(uint32 length) { _ModifiedBufferLength = length;}
uint32 getModifiedBufferLength() { return _ModifiedBufferLength;}

//===============================
// FAULT HANDLERS
//===============================

//==================
// [0] INIT HANDLER:
//==================
void fault_handler_init()
{
	//setPageReplacmentAlgorithmLRU(PG_REP_LRU_TIME_APPROX);
	//setPageReplacmentAlgorithmOPTIMAL();
	setPageReplacmentAlgorithmCLOCK();
	//setPageReplacmentAlgorithmModifiedCLOCK();
	enableBuffering(0);
	enableModifiedBuffer(0) ;
	setModifiedBufferLength(1000);
}
//==================
// [1] MAIN HANDLER:
//==================
/*2022*/
uint32 last_eip = 0;
uint32 before_last_eip = 0;
uint32 last_fault_va = 0;
uint32 before_last_fault_va = 0;
int8 num_repeated_fault  = 0;
extern uint32 sys_calculate_free_frames() ;

struct Env* last_faulted_env = NULL;
void fault_handler(struct Trapframe *tf)
{
	/******************************************************/
	// Read processor's CR2 register to find the faulting address
	uint32 fault_va = rcr2();
	//cprintf("************Faulted VA = %x************\n", fault_va);
	//	print_trapframe(tf);
	/******************************************************/

	//If same fault va for 3 times, then panic
	//UPDATE: 3 FAULTS MUST come from the same environment (or the kernel)
	struct Env* cur_env = get_cpu_proc();
	if (last_fault_va == fault_va && last_faulted_env == cur_env)
	{
		num_repeated_fault++ ;
		if (num_repeated_fault == 3)
		{
			print_trapframe(tf);
			panic("Failed to handle fault! fault @ at va = %x from eip = %x causes va (%x) to be faulted for 3 successive times\n", before_last_fault_va, before_last_eip, fault_va);
		}
	}
	else
	{
		before_last_fault_va = last_fault_va;
		before_last_eip = last_eip;
		num_repeated_fault = 0;
	}
	last_eip = (uint32)tf->tf_eip;
	last_fault_va = fault_va ;
	last_faulted_env = cur_env;
	/******************************************************/
	//2017: Check stack overflow for Kernel
	int userTrap = 0;
	if ((tf->tf_cs & 3) == 3) {
		userTrap = 1;
	}
	if (!userTrap)
	{
		struct cpu* c = mycpu();
		//cprintf("trap from KERNEL\n");
		if (cur_env && fault_va >= (uint32)cur_env->kstack && fault_va < (uint32)cur_env->kstack + PAGE_SIZE)
			panic("User Kernel Stack: overflow exception!");
		else if (fault_va >= (uint32)c->stack && fault_va < (uint32)c->stack + PAGE_SIZE)
			panic("Sched Kernel Stack of CPU #%d: overflow exception!", c - CPUS);
#if USE_KHEAP
		if (fault_va >= KERNEL_HEAP_MAX)
			panic("Kernel: heap overflow exception!");
#endif
	}
	//2017: Check stack underflow for User
	else
	{
		//cprintf("trap from USER\n");
		if (fault_va >= USTACKTOP && fault_va < USER_TOP)
			panic("User: stack underflow exception!");
	}

	//get a pointer to the environment that caused the fault at runtime
	//cprintf("curenv = %x\n", curenv);
	struct Env* faulted_env = cur_env;
	if (faulted_env == NULL)
	{
		cprintf("\nFaulted VA = %x\n", fault_va);
		print_trapframe(tf);
		panic("faulted env == NULL!");
	}
	//check the faulted address, is it a table or not ?
	//If the directory entry of the faulted address is NOT PRESENT then
	if ( (faulted_env->env_page_directory[PDX(fault_va)] & PERM_PRESENT) != PERM_PRESENT)
	{
		faulted_env->tableFaultsCounter ++ ;
		table_fault_handler(faulted_env, fault_va);
	}
	else
	{
		if (userTrap)
		{
			/*============================================================================================*/
			//TODO: [PROJECT'25.GM#3] FAULT HANDLER I - #2 Check for invalid pointers
			//(e.g. pointing to unmarked user heap page, kernel or wrong access rights),
			//your code is here
		    uint32* page_table = NULL;
		    int ret = get_page_table(faulted_env->env_page_directory, fault_va, &page_table);
		    uint32 pte = page_table[PTX(fault_va)];

		    if (fault_va >= USER_LIMIT) {
		        env_exit();
		    }

		    if (fault_va >= USER_HEAP_START && fault_va < USER_HEAP_MAX)
		    {
		        if (ret != TABLE_IN_MEMORY || page_table == NULL) {
		            env_exit();
		        }

		        if ((pte & PERM_UHPAGE) == 0) {
		            env_exit();
		        }
		    }

		    if (ret == TABLE_IN_MEMORY && page_table != NULL)
		    {
				if ((pte & PERM_PRESENT) && !(pte & PERM_WRITEABLE)){
						env_exit();
		        }
		    }

			/*============================================================================================*/
		    }


		/*2022: Check if fault due to Access Rights */
		//cprintf("hello");
		int perms = pt_get_page_permissions(faulted_env->env_page_directory, fault_va);
		if (perms & PERM_PRESENT)
			panic("Page @va=%x is exist! page fault due to violation of ACCESS RIGHTS\n", fault_va) ;

		/*============================================================================================*/


		// we have normal page fault =============================================================
		faulted_env->pageFaultsCounter ++ ;

//				cprintf("[%08s] user PAGE fault va %08x\n", faulted_env->prog_name, fault_va);
//				cprintf("\nPage working set BEFORE fault handler...\n");
//				env_page_ws_print(faulted_env);
		//int ffb = sys_calculate_free_frames();

		if(isBufferingEnabled())
		{
			__page_fault_handler_with_buffering(faulted_env, fault_va);
		}
		else
		{
			page_fault_handler(faulted_env, fault_va);
		}

		//		cprintf("\nPage working set AFTER fault handler...\n");
		//		env_page_ws_print(faulted_env);
		//		int ffa = sys_calculate_free_frames();
		//		cprintf("fault handling @%x: difference in free frames (after - before = %d)\n", fault_va, ffa - ffb);
	}

	/*************************************************************/
	//Refresh the TLB cache
	tlbflush();
	/*************************************************************/
}


//=========================
// [2] TABLE FAULT HANDLER:
//=========================
void table_fault_handler(struct Env * curenv, uint32 fault_va)
{
	//panic("table_fault_handler() is not implemented yet...!!");
	//Check if it's a stack page
	uint32* ptr_table;
#if USE_KHEAP
	{
		ptr_table = create_page_table(curenv->env_page_directory, (uint32)fault_va);
	}
#else
	{
		__static_cpt(curenv->env_page_directory, (uint32)fault_va, &ptr_table);
	}
#endif
}

//=========================
// [3] PAGE FAULT HANDLER:
//=========================
/* Calculate the number of page faults according th the OPTIMAL replacement strategy
 * Given:
 * 	1. Initial Working Set List (that the process started with)
 * 	2. Max Working Set Size
 * 	3. Page References List (contains the stream of referenced VAs till the process finished)
 *
 * 	IMPORTANT: This function SHOULD NOT change any of the given lists
 */
int get_optimal_num_faults(struct WS_List *initWorkingSet, int maxWSSize, struct PageRef_List *pageReferences)
{
	//TODO: [PROJECT'25.IM#1] FAULT HANDLER II - #2 get_optimal_num_faults
	//Your code is here
	//Comment the following line
	//panic("get_optimal_num_faults() is not implemented yet...!!");
	int fcount=0;
	struct WS_List tempWS;
	LIST_INIT(&tempWS);
	struct WorkingSetElement *curr = LIST_FIRST(initWorkingSet);
	//bcopy el prepages
	while(curr!=NULL){
	    struct WorkingSetElement *newEl = kmalloc(sizeof(struct WorkingSetElement));
	    newEl->virtual_address = curr->virtual_address;
		LIST_INSERT_TAIL(&tempWS,newEl);
		curr= curr->prev_next_info.le_next;
	}
	struct PageRefElement *Ref = LIST_FIRST(pageReferences);
	while(Ref!=NULL){
		uint32 pageva = Ref->virtual_address;
		struct WorkingSetElement *curr = LIST_FIRST(&tempWS);
		bool found=0;
        //lw fii el WS
		while(curr!=NULL){
			if(pageva == curr->virtual_address){
				found=1;
				break;
			}
			curr = curr->prev_next_info.le_next;
		}
		//lw laa
		if(!found){
			fcount++;
            // lw fii mkan fii el WS
			if(LIST_SIZE(&tempWS)<maxWSSize){
				struct WorkingSetElement *newEl = kmalloc(sizeof(struct WorkingSetElement));
				newEl->virtual_address = pageva;
				LIST_INSERT_TAIL(&tempWS,newEl);
			}
			// lw ba2a el ws mlyana
			else{
				int maxdis=-1;
				struct WorkingSetElement *vict = NULL;

				struct WorkingSetElement *twscurr = LIST_FIRST(&tempWS);
				while(twscurr!=NULL){
					int dis =0;
					bool foundinF = 0;

					struct PageRefElement *rcurr = Ref->prev_next_info.le_next;
					while(rcurr!=NULL){
						if(rcurr->virtual_address == twscurr->virtual_address){
							foundinF=1;
							break;
						}
						dis++;
						rcurr = rcurr->prev_next_info.le_next;
					}
					if(!foundinF){
						vict = twscurr;
						break;
					}
					if(dis>maxdis){
						maxdis=dis;
						vict = twscurr;
					}
					twscurr = twscurr->prev_next_info.le_next;
				}
				LIST_REMOVE(&tempWS,vict);
				kfree(vict);

				struct WorkingSetElement *newEl = kmalloc(sizeof(struct WorkingSetElement));
				newEl->virtual_address = pageva;
				LIST_INSERT_TAIL(&tempWS,newEl);
			}
		}
		Ref = Ref->prev_next_info.le_next;
	}
    struct WorkingSetElement *curr2 = LIST_FIRST(&tempWS);
    while(curr2 != NULL){
        struct WorkingSetElement *next = curr2->prev_next_info.le_next;
        LIST_REMOVE(&tempWS, curr2);
        kfree(curr2);
        curr2 = next;
    }
    return fcount;

}

void page_fault_handler(struct Env * faulted_env, uint32 fault_va)
{
#if USE_KHEAP
	if (isPageReplacmentAlgorithmOPTIMAL())
		{
	    fault_va = ROUNDDOWN(fault_va, PAGE_SIZE);
	    //cprintf("OPTIMAL: Handling page fault at VA: 0x%08x\n", fault_va);

	    struct PageRefElement *newRef = kmalloc(sizeof(struct PageRefElement));
	    newRef->virtual_address = fault_va;
	    LIST_INSERT_TAIL(&(faulted_env->referenceStreamList), newRef);


	    struct WorkingSetElement *currelement = LIST_FIRST(&(faulted_env->ActiveWSlist));
	    bool found = 0;
	    while(currelement != NULL){
	        if(currelement->virtual_address == fault_va){
	            found = 1;
	            pt_set_page_permissions(faulted_env->env_page_directory, fault_va, PERM_PRESENT, 0);
	            return;
	        }
	        currelement = currelement->prev_next_info.le_next;
	    }



	    if(LIST_SIZE(&(faulted_env->ActiveWSlist)) >= faulted_env->page_WS_max_size){

	        struct WorkingSetElement *curr = LIST_FIRST(&(faulted_env->ActiveWSlist));
	        struct WorkingSetElement *next;
	        while(curr != NULL){
	            next = curr->prev_next_info.le_next;
	            pt_set_page_permissions(faulted_env->env_page_directory, curr->virtual_address, 0, PERM_PRESENT);
	            LIST_REMOVE(&(faulted_env->ActiveWSlist), curr);
	            kfree(curr);
	            curr = next;
	        }
	    }
	    uint32* page_table = NULL;
	    get_page_table(faulted_env->env_page_directory, fault_va, &page_table);
	    uint32 pte = page_table[PTX(fault_va)];

	    if(!(pte & PERM_PRESENT)){
	        if(pte != 0){
	            pt_set_page_permissions(faulted_env->env_page_directory, fault_va, PERM_PRESENT, 0);
	        } else {
	            struct FrameInfo *allocframe;
	            allocate_frame(&allocframe);
	            map_frame(faulted_env->env_page_directory, allocframe, fault_va,PERM_PRESENT|PERM_WRITEABLE|PERM_USER);

	            int ret = pf_read_env_page(faulted_env, (void*)fault_va);
	            if(ret == E_PAGE_NOT_EXIST_IN_PF){
	            }
	        }
	    }

	    struct WorkingSetElement *newEl = kmalloc(sizeof(struct WorkingSetElement));
	    newEl->virtual_address = fault_va;
	    LIST_INSERT_TAIL(&(faulted_env->ActiveWSlist), newEl);
		}
	else
	{
		struct WorkingSetElement *victimWSElement = NULL;
		uint32 wsSize = LIST_SIZE(&(faulted_env->page_WS_list));
		if(wsSize < (faulted_env->page_WS_max_size))
		{
			//TODO: [PROJECT'25.GM#3] FAULT HANDLER I - #3 placement
			//Your code is here
			//Comment the following line
			//panic("page_fault_handler().PLACEMENT is not implemented yet...!!");
			 struct FrameInfo *allocatedframeptr;
					        int alloc = allocate_frame(&allocatedframeptr);
					        if(alloc==0){
					            int setperms=PERM_PRESENT|PERM_WRITEABLE|PERM_USER;
					            if(fault_va >= USER_HEAP_START && fault_va < USER_HEAP_MAX){
					            	setperms|=PERM_UHPAGE;
					            }
					            int ret=map_frame(faulted_env->env_page_directory,allocatedframeptr,fault_va,setperms);
					            int readpagefile = pf_read_env_page(faulted_env,(void*)fault_va);
					            bool valid=0;

					            if (readpagefile==0){
					                valid=1;
					            }
					            else{
					                if((fault_va>=USTACKBOTTOM && fault_va < USTACKTOP)||
					                  (fault_va >= USER_HEAP_START && fault_va < USER_HEAP_MAX))    {
					                    valid=1;
					                }
					                else{
					                    unmap_frame(faulted_env->env_page_directory,fault_va);
					                    env_exit();

					                }

					            }
				                if(valid){
				                 struct  WorkingSetElement *newelement=env_page_ws_list_create_element(faulted_env,fault_va);
				                 LIST_INSERT_TAIL(&(faulted_env->page_WS_list), newelement);
				                 if(wsSize+1 == (faulted_env->page_WS_max_size)){
				                	 faulted_env->page_last_WS_element = LIST_FIRST(&(faulted_env->page_WS_list));

				                 }
				                }
					        }
		}
		else
		{
			if (isPageReplacmentAlgorithmCLOCK())
			{
				//TODO: [PROJECT'25.IM#1] FAULT HANDLER II - #3 Clock Replacement
				//Your code is here
				//Comment the following line
				//panic("page_fault_handler().REPLACEMENT is not implemented yet...!!");
			    fault_va = ROUNDDOWN(fault_va, PAGE_SIZE);
			    struct FrameInfo *allocframe;
			    allocate_frame(&allocframe);
			    map_frame(faulted_env->env_page_directory, allocframe, fault_va,
			              PERM_PRESENT|PERM_WRITEABLE|PERM_USER|PERM_USED);

			    int ret = pf_read_env_page(faulted_env, (void*)fault_va);
			    bool valid = 0;

			    if(ret == 0) {
			        valid = 1;
			    } else {
			        if((fault_va >= USTACKBOTTOM && fault_va < USTACKTOP) ||
			           (fault_va >= USER_HEAP_START && fault_va < USER_HEAP_MAX)) {
			            valid = 1;
			        } else {
			            unmap_frame(faulted_env->env_page_directory, fault_va);
			            env_exit();
			        }
			    }

			    if(valid) {
			        if(faulted_env->page_last_WS_element == NULL) {
			            faulted_env->page_last_WS_element = LIST_FIRST(&(faulted_env->page_WS_list));
			        }


			        while(1) {

			            struct WorkingSetElement *current = LIST_FIRST(&(faulted_env->page_WS_list));

			            uint32 *page_table;
			            get_page_table(faulted_env->env_page_directory,
			                          current->virtual_address,
			                          &page_table);
			            uint32 pte = page_table[PTX(current->virtual_address)];

			            if(!(pte & PERM_USED)) {
			                // l2et el victim ely used bit b 0
			                victimWSElement = current;
			                break;
			            } else {
			                //ml2tsh el victim
			                pt_set_page_permissions(faulted_env->env_page_directory,
			                                       current->virtual_address,
			                                       0, PERM_USED);

			                // bshelo mn el front w b add fii el tail yakhod dor tany
			                LIST_REMOVE(&(faulted_env->page_WS_list), current);
			                LIST_INSERT_TAIL(&(faulted_env->page_WS_list), current);
			            }
			        }

			        uint32 *victpagetable;
			        get_page_table(faulted_env->env_page_directory, victimWSElement->virtual_address, &victpagetable);
			        uint32 victim_pte = victpagetable[PTX(victimWSElement->virtual_address)];

			        if(victim_pte & PERM_MODIFIED) {
			            pf_update_env_page(faulted_env, victimWSElement->virtual_address, to_frame_info(victim_pte));
			        }

			        // bshel el victim mn el list haykon 3la tol fii el head
			        unmap_frame(faulted_env->env_page_directory, victimWSElement->virtual_address);
			        LIST_REMOVE(&(faulted_env->page_WS_list), victimWSElement);
			        kfree(victimWSElement);

			        // badd el new fii el tail
			        struct WorkingSetElement *newEl = env_page_ws_list_create_element(faulted_env, fault_va);
			        LIST_INSERT_TAIL(&(faulted_env->page_WS_list), newEl);

			        // wkda kda el pointer hayshawr 3la el head
			        faulted_env->page_last_WS_element = LIST_FIRST(&(faulted_env->page_WS_list));
			    }

			}
			else if (isPageReplacmentAlgorithmLRU(PG_REP_LRU_TIME_APPROX))
						{
							//TODO: [PROJECT'25.IM#6] FAULT HANDLER II - #2 LRU Aging Replacement
							//Your code is here
							//Comment the following line
							//panic("page_fault_handler().REPLACEMENT is not implemented yet...!!");
							struct WorkingSetElement* thevictim= faulted_env->best_victim_ptr;
							uint32 pte = pt_get_page_permissions(faulted_env->env_page_directory, thevictim->virtual_address);
							uint32 framenum= pte& 0xFFFFF000;
							uint32 vaoffset=thevictim->virtual_address&0x00000FFF;
							uint32 thevictimpa= framenum+vaoffset;
							struct FrameInfo* victimframe=to_frame_info(framenum);
						    uint32 ismodified= pte&PERM_MODIFIED;

							if(ismodified>0){
								int updated=pf_update_env_page(faulted_env, thevictim->virtual_address,victimframe);



							}

							 unmap_frame(faulted_env->env_page_directory,thevictim->virtual_address);
							//LIST_REMOVE(&faulted_env->page_WS_list,thevictim) ;
							//kfree(thevictim);


			                // page_fault_handler(faulted_env, fault_va);

							 //h3ml override 3la al victim bta3y

							 thevictim->virtual_address = ROUNDDOWN(fault_va,PAGE_SIZE);
							 thevictim->sweeps_counter = 0;
							 thevictim->time_stamp = 0x00000000;


							 struct FrameInfo *allocatedframeptr;
							 int alloc = allocate_frame(&allocatedframeptr);
									if(alloc==0){
										int setperms=PERM_PRESENT|PERM_WRITEABLE|PERM_USER;
										if(fault_va >= USER_HEAP_START && fault_va < USER_HEAP_MAX){
											setperms|=PERM_UHPAGE;
												      }
										 int ret=map_frame(faulted_env->env_page_directory,allocatedframeptr,fault_va,setperms);
										 int readpagefile = pf_read_env_page(faulted_env,(void*)fault_va);
										  bool valid=0;

										  if (readpagefile==0){
												  valid=1;
											 }
										 else{
										 if((fault_va>=USTACKBOTTOM && fault_va < USTACKTOP)||
										  (fault_va >= USER_HEAP_START && fault_va < USER_HEAP_MAX))  {
												          valid=1;
									  }
							           else{
											 unmap_frame(faulted_env->env_page_directory,fault_va);
												      env_exit();

												 }

												            }


											                }










						}
			else if (isPageReplacmentAlgorithmModifiedCLOCK())
								{
									//TODO: [PROJECT'25.IM#6] FAULT HANDLER II - #3 Modified Clock Replacement
									//Your code is here
									//Comment the following line
									//panic("page_fault_handler().REPLACEMENT is not implemented yet...!!");
									//uint32 used_bit = pt_get_page_permissions(tobeupdatedproc->env_page_directory, trackedwselement->virtual_address)& PERM_USED;
									struct WorkingSetElement*thevictim=NULL;
									//cprintf("before");
									//env_page_ws_print(faulted_env) ;

									int trial=1;
									bool found=0;
								while(trial<=4){


									uint32 count=0;

									while(count<faulted_env->page_WS_max_size){



									 uint32 perm = pt_get_page_permissions(faulted_env->env_page_directory, faulted_env->page_last_WS_element->virtual_address);
									 uint32 modified_bit =perm&PERM_MODIFIED;
									 uint32 used_bit=perm&PERM_USED;

									 if((trial==1)||(trial==3)){
										 if((!used_bit)&&(!modified_bit)){

																		 thevictim=faulted_env->page_last_WS_element;
																		 if((thevictim->virtual_address>=USTACKBOTTOM && thevictim->virtual_address < USTACKTOP)){
																			 uint32 framenum= perm& 0xFFFFF000;
																			struct FrameInfo* victimframe=to_frame_info(framenum);
																			 int updated=pf_update_env_page(faulted_env,ROUNDDOWN(thevictim->virtual_address,PAGE_SIZE) ,victimframe);

																		}
																		// unmap_frame(faulted_env->env_page_directory,thevictim->virtual_address);
																		//LIST_REMOVE(&faulted_env->page_WS_list,thevictim) ;
																		//kfree(thevictim);

																		 env_page_ws_invalidate(faulted_env,ROUNDDOWN(faulted_env->page_last_WS_element->virtual_address,PAGE_SIZE) );
																		 found=1;




																		 break;


																	 }
										 else{
											 struct WorkingSetElement* current=faulted_env->page_last_WS_element;
											 faulted_env->page_last_WS_element=faulted_env->page_last_WS_element->prev_next_info.le_next;


																		 LIST_REMOVE(&faulted_env->page_WS_list,current) ;
																		 LIST_INSERT_TAIL(&faulted_env->page_WS_list,current);
																		 count+=1;

																	 }
									 }


									 else if((trial==2||trial==4)){
										 if(!used_bit){

																	// unmap_frame(faulted_env->env_page_directory,thevictim->virtual_address);
																	//LIST_REMOVE(&faulted_env->page_WS_list,thevictim) ;
																	//kfree(thevictim);
																	 uint32 framenum= perm& 0xFFFFF000;
																	 struct FrameInfo* victimframe=to_frame_info(framenum);
																	 if(modified_bit>0){
																	 int updated=pf_update_env_page(faulted_env, ROUNDDOWN(faulted_env->page_last_WS_element->virtual_address,PAGE_SIZE) ,victimframe);
																	 }


																	 env_page_ws_invalidate(faulted_env,ROUNDDOWN(faulted_env->page_last_WS_element->virtual_address,PAGE_SIZE) );

																	 found=1;




																	 break;



																 }
										 else{
											 struct WorkingSetElement* current=faulted_env->page_last_WS_element;
										 faulted_env->page_last_WS_element=faulted_env->page_last_WS_element->prev_next_info.le_next;



										 pt_set_page_permissions(faulted_env->env_page_directory, current->virtual_address,0,PERM_USED);

										LIST_REMOVE(&faulted_env->page_WS_list,current) ;
										 LIST_INSERT_TAIL(&faulted_env->page_WS_list,current);
										count+=1;

																	 }
									 }



									}

									if(found==1){



										 struct FrameInfo *allocatedframeptr;
																	int alloc = allocate_frame(&allocatedframeptr);
																	if(alloc==0){
																		int setperms=PERM_PRESENT|PERM_WRITEABLE|PERM_USER;
																		if(fault_va >= USER_HEAP_START && fault_va < USER_HEAP_MAX){
																			setperms|=PERM_UHPAGE;
																		}
																		int ret=map_frame(faulted_env->env_page_directory,allocatedframeptr,ROUNDDOWN(fault_va,PAGE_SIZE),setperms);
																		int readpagefile = pf_read_env_page(faulted_env,(void*)fault_va);
																		bool valid=0;

																		if (readpagefile==0){
																			valid=1;
																		}
																		else{
																			if((fault_va>=USTACKBOTTOM && fault_va < USTACKTOP)||
																			  (fault_va >= USER_HEAP_START && fault_va < USER_HEAP_MAX))    {
																				valid=1;
																			}
																			else{
																				unmap_frame(faulted_env->env_page_directory,fault_va);
																				env_exit();

																			}

																		}
																		if(valid){
																		 struct  WorkingSetElement *newelement=env_page_ws_list_create_element(faulted_env,fault_va);
																		 LIST_INSERT_TAIL(&(faulted_env->page_WS_list), newelement);


																		}
																	}
									 break;

									}

									//cprintf("in trial %d",trial);
									//env_page_ws_print(faulted_env) ;

									trial+=1;






								}
									//cprintf("after");
									//env_page_ws_print(faulted_env) ;

								}
		}
	}
#endif
}

void __page_fault_handler_with_buffering(struct Env * curenv, uint32 fault_va)
{
	panic("this function is not required...!!");
}



