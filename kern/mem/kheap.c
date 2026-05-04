#include "kheap.h"

#include <inc/memlayout.h>
#include <inc/dynamic_allocator.h>
#include <kern/conc/sleeplock.h>
#include <kern/proc/user_environment.h>
#include <kern/mem/memory_manager.h>
#include "../conc/kspinlock.h"
struct kspinlock klock;
struct freekernelalloc{
	uint32 startva;
	unsigned int size;
	LIST_ENTRY(freekernelalloc) prev_next_info;
};
LIST_HEAD(freelist,freekernelalloc);
LIST_HEAD(alloclist,freekernelalloc);
struct freelist m_freelist;
struct alloclist m_alloclist;


//==================================================================================//
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

//==============================================
// [1] INITIALIZE KERNEL HEAP:
//==============================================
//TODO: [PROJECT'25.GM#2] KERNEL HEAP - #0 kheap_init [GIVEN]
//Remember to initialize locks (if any)
void kheap_init()
{
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		initialize_dynamic_allocator(KERNEL_HEAP_START, KERNEL_HEAP_START + DYN_ALLOC_MAX_SIZE);
		set_kheap_strategy(KHP_PLACE_CUSTOMFIT);
		kheapPageAllocStart = dynAllocEnd + PAGE_SIZE;
		kheapPageAllocBreak = kheapPageAllocStart;
		init_kspinlock(&klock,"kmalloc");
				LIST_INIT(&m_freelist);
				LIST_INIT(&m_alloclist);
	}
	//==================================================================================
	//==================================================================================

}

//==============================================
// [2] GET A PAGE FROM THE KERNEL FOR DA:
//==============================================
int get_page(void* va)
{
	int ret = alloc_page(ptr_page_directory, ROUNDDOWN((uint32)va, PAGE_SIZE), PERM_WRITEABLE, 1);
	if (ret < 0)
		panic("get_page() in kern: failed to allocate page from the kernel");
	return 0;
}

//==============================================
// [3] RETURN A PAGE FROM THE DA TO KERNEL:
//==============================================
void return_page(void* va)
{
	unmap_frame(ptr_page_directory, ROUNDDOWN((uint32)va, PAGE_SIZE));
}

//==================================================================================//
//============================ REQUIRED FUNCTIONS ==================================//
//==================================================================================//
//===================================
// [1] ALLOCATE SPACE IN KERNEL HEAP:
//===================================




void* kmalloc(unsigned int size)
{


	acquire_kspinlock(&klock);
		if(size<=DYN_ALLOC_MAX_BLOCK_SIZE){
			release_kspinlock(&klock);
			return alloc_block(size);
		}
		struct freekernelalloc* allocblock=(struct freekernelalloc*) alloc_block(sizeof(struct freekernelalloc));
		size = ROUNDUP(size,PAGE_SIZE);

		struct freekernelalloc* lastfreeelement = LIST_LAST(&m_freelist);


		// move break
		if(LIST_SIZE(&m_freelist)==0 || size>lastfreeelement->size){
			if(kheapPageAllocBreak <= KERNEL_HEAP_MAX-size){
				uint32 requestedblockva = kheapPageAllocBreak;
				kheapPageAllocBreak+=size;
				allocblock->startva = requestedblockva;
				allocblock->size = size;
				LIST_INSERT_TAIL(&m_alloclist,allocblock);

				int pagecount = size/PAGE_SIZE;
				for(int i=0;i<pagecount;i++){
					void* pageva = (void*)(requestedblockva + i*PAGE_SIZE);
					int ret = get_page(pageva);
				}
				release_kspinlock(&klock);
				return (void*)allocblock->startva;}
			else{
				release_kspinlock(&klock);
				return NULL;
			}

		}else{
			//custom fit
			struct freekernelalloc* currentfreeelement = LIST_FIRST(&m_freelist);
			//worst fit
			while(currentfreeelement != NULL){
				if(size<currentfreeelement->size){
					allocblock->startva = lastfreeelement->startva;
	                allocblock->size = size;
	                LIST_INSERT_TAIL(&m_alloclist,allocblock);
	                lastfreeelement->startva += size;
	                lastfreeelement->size -= size;
	                struct freekernelalloc* currentfree2 = LIST_FIRST(&m_freelist);
	                //check order of last element
	                while (currentfree2 != NULL){
	                	if(lastfreeelement->size <currentfree2->size){
	                		LIST_REMOVE(&m_freelist ,lastfreeelement);
	                		LIST_INSERT_BEFORE(&m_freelist ,currentfree2 ,lastfreeelement);
	                		break;
	                	}
	                	currentfree2 = currentfree2->prev_next_info.le_next;
	                }
	                int pagecount = size/PAGE_SIZE;
	                for(int i=0;i<pagecount;i++){
	                	void* pageva = (void*)((allocblock->startva) + i*PAGE_SIZE);
	                	int ret = get_page(pageva);
	                }
	                release_kspinlock(&klock);
	                return (void*)allocblock->startva;
	          //exact fit
				}else if(size == currentfreeelement->size){
					allocblock->startva = currentfreeelement->startva;
					allocblock->size = size;
					LIST_INSERT_TAIL(&m_alloclist,allocblock);
					LIST_REMOVE(&m_freelist ,currentfreeelement);
					int pagecount = size/PAGE_SIZE;
					for(int i=0;i<pagecount;i++){
						void* pageva = (void*)((allocblock->startva) + i*PAGE_SIZE);
						int ret = get_page(pageva);
					}
					release_kspinlock(&klock);
					return (void*)allocblock->startva;
				}
				currentfreeelement = currentfreeelement->prev_next_info.le_next;
			}
		}
	    return NULL;
		//TODO: [PROJECT'25.BONUS#3] FAST PAGE ALLOCATOR
	}


//=================================
// [2] FREE SPACE FROM KERNEL HEAP:
//=================================
void kfree(void* virtual_address)
{
	uint32  VA = ROUNDDOWN(((uint32 ) virtual_address), PAGE_SIZE);



	acquire_kspinlock(&klock);
	if (VA < kheapPageAllocStart){
		free_block(virtual_address);
		release_kspinlock(&klock);
		return;
	}
	struct freekernelalloc* newfree = (struct freekernelalloc*) alloc_block(sizeof(struct freekernelalloc));
	struct freekernelalloc* MergedBlock  = ( struct freekernelalloc*)alloc_block(sizeof(struct freekernelalloc));
	if (VA > kheapPageAllocBreak){
		panic("freeing from restricted area");
		release_kspinlock(&klock);
		return;
	}

	struct freekernelalloc* ToBefreed = LIST_FIRST(&m_alloclist);
	bool foundVA = 0;

	//find the allocated block
	while(ToBefreed !=NULL ){

		if (VA ==ToBefreed->startva ){
			foundVA = 1;
			break;
		}
			ToBefreed = ToBefreed->prev_next_info.le_next;
	}


	if(!foundVA){
			panic("INVALID ADDRESS!");
			release_kspinlock(&klock);
			return;
		}



	//remove allocated block from alloclist
	LIST_REMOVE(&m_alloclist, ToBefreed);


	//free allocated block
	for(int i=0;i<(ToBefreed->size/PAGE_SIZE);i++){
			void* pageva = (void*)((ToBefreed->startva) + i*PAGE_SIZE);
			return_page(pageva);
	}


	newfree->startva = ToBefreed->startva;
	newfree->size = ToBefreed->size;


	if(LIST_SIZE(&m_freelist) == 0){
		LIST_INSERT_HEAD(&m_freelist,newfree);
		release_kspinlock(&klock);
		return;
	}


	struct freekernelalloc* ToBeMerged = LIST_FIRST(&m_freelist);
	// merge with prev if possible
	bool mergeprev = 0;
	bool mergenext = 0;
	while(ToBeMerged != NULL){
		if((ToBeMerged->startva +ToBeMerged->size) == newfree->startva){

			MergedBlock->startva = ToBeMerged->startva;
			MergedBlock->size = ToBeMerged->size + newfree->size;
			LIST_REMOVE(&m_freelist, ToBeMerged);
			mergeprev = 1;
			break;
		}
			ToBeMerged = ToBeMerged->prev_next_info.le_next;
	}

//	//	move break
//		if(mergeprev){
//			if (MergedBlock->startva + MergedBlock->size == kheapPageAllocBreak){
//					kheapPageAllocBreak = MergedBlock->startva;
//			}
//		}else{
//			if (newfree->startva + newfree->size == kheapPageAllocBreak){
//						kheapPageAllocBreak = newfree->startva;
//			}
//		}


	if ( newfree ->startva + newfree->size == kheapPageAllocBreak){

				if(mergeprev){
					kheapPageAllocBreak = MergedBlock->startva;
					release_kspinlock(&klock);
							return;
				}else{
					kheapPageAllocBreak = newfree->startva;
					release_kspinlock(&klock);
							return;
				}

		}




	//check if block is merged with prev ,and find possible merge with next
	ToBeMerged = LIST_FIRST(&m_freelist);
	while(ToBeMerged != NULL){
		if ((newfree->startva + newfree->size) == ToBeMerged->startva ){
			if (mergeprev){
				MergedBlock->size += ToBeMerged->size;
				LIST_REMOVE(&m_freelist, ToBeMerged);
				break;
	//if not merged find possible merge with next
			}else{
				MergedBlock->startva = newfree->startva;
				MergedBlock->size  = newfree->size + ToBeMerged->size;
				LIST_REMOVE(&m_freelist, ToBeMerged);
				mergenext = 1;
				break;
			}
		}
		ToBeMerged = ToBeMerged->prev_next_info.le_next;
	}








		// insertion
		struct freekernelalloc* currentfree = LIST_FIRST(&m_freelist);

		if(mergeprev || mergenext){
			while(currentfree != NULL){
				if(MergedBlock->size < currentfree->size){

						LIST_INSERT_BEFORE(&m_freelist,currentfree,MergedBlock);
						release_kspinlock(&klock);
						return;
				}
						currentfree = currentfree->prev_next_info.le_next;
			}
			LIST_INSERT_TAIL(&m_freelist,MergedBlock);

		}else{
			while(currentfree != NULL){
				if(newfree->size < currentfree->size){

						LIST_INSERT_BEFORE(&m_freelist,currentfree,newfree);
						release_kspinlock(&klock);
						return;
				}
						currentfree = currentfree->prev_next_info.le_next;
			}
			LIST_INSERT_TAIL(&m_freelist,newfree);
		}
	release_kspinlock(&klock);
	return;

}

//=================================
// [3] FIND VA OF GIVEN PA:
//=================================
unsigned int kheap_virtual_address(unsigned int physical_address)
{

	//panic(" va is not implemented");
//	uint32 Loffset = physical_address&0x0000FFF;
//	struct FrameInfo* ptrtoLframe ;
//	ptrtoLframe = to_frame_info(physical_address);
//
	uint32 offset = physical_address & 0xFFF;            // offset inside page
	    uint32 frame_pa = physical_address & 0xFFFFF000;     // page-aligned physical base

	    struct FrameInfo *f = to_frame_info(frame_pa);
	    if (f == NULL) return 0;                             // safety: no frame info

	    // If no references or mappedpageva cleared, treat as unmapped
	    if (f->references == 0 || f->mappedpageva == 0)
	        return 0;

	    // mappedpageva holds page-aligned virtual address of this frame
	    return f->mappedpageva + offset;
	/*EFFICIENT IMPLEMENTATION ~O(1) IS REQUIRED */
}

//=================================
// [4] FIND PA OF GIVEN VA:
//=================================
unsigned int kheap_physical_address(unsigned int virtual_address)
{
    uint32* Pt = NULL;
    uint32 re = get_page_table(ptr_page_directory , virtual_address , &Pt);
    if(re==TABLE_NOT_EXIST){
        return 0;
    }
    uint32 PtE = Pt[PTX(virtual_address)];
    if((PtE & PERM_PRESENT) != PERM_PRESENT){
        return 0;
    }
    uint32 frameno = PtE & 0xFFFFF000;
    uint32 offset = virtual_address & 0xFFF;
    return frameno + offset;
    //EFFICIENT IMPLEMENTATION ~O(1) IS REQUIRED//
}
//=================================================================================//
//============================== BONUS FUNCTION ===================================//
//=================================================================================//
// krealloc():

//	Attempts to resize the allocated space at "virtual_address" to "new_size" bytes,
//	possibly moving it in the heap.
//	If successful, returns the new virtual_address, in which case the old virtual_address must no longer be accessed.
//	On failure, returns a null pointer, and the old virtual_address remains valid.

//	A call with virtual_address = null is equivalent to kmalloc().
//	A call with new_size = zero is equivalent to kfree().

extern __inline__ uint32 get_block_size(void *va);

void *krealloc(void *virtual_address, uint32 new_size)
{
	//TODO: [PROJECT'25.BONUS#2] KERNEL REALLOC - krealloc
	//Your code is here
	//Comment the following line
	panic("krealloc() is not implemented yet...!!");
}
