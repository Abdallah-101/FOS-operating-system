#include <inc/lib.h>

struct uspinlock ulock;
struct UserHeapStruct{
	uint32 startva;
	unsigned int size;
	LIST_ENTRY(UserHeapStruct) prev_next_info;
};
LIST_HEAD(ufreelist,UserHeapStruct);
LIST_HEAD(ualloclist,UserHeapStruct);
struct ufreelist u_freelist;
struct ualloclist u_allocatedlist;


//==================================================================================//
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

//==============================================
// [1] INITIALIZE USER HEAP:
//==============================================
int __firstTimeFlag = 1;
void uheap_init()
{
	if(__firstTimeFlag)
	{
		initialize_dynamic_allocator(USER_HEAP_START, USER_HEAP_START + DYN_ALLOC_MAX_SIZE);
		uheapPlaceStrategy = sys_get_uheap_strategy();
		uheapPageAllocStart = dynAllocEnd + PAGE_SIZE;
		uheapPageAllocBreak = uheapPageAllocStart;
		init_uspinlock(&ulock,"malloc",1);
		LIST_INIT(&u_freelist);
		LIST_INIT(&u_allocatedlist);
		__firstTimeFlag = 0;
	}
}

//==============================================
// [2] GET A PAGE FROM THE KERNEL FOR DA:
//==============================================
int get_page(void* va)
{
	int ret = __sys_allocate_page(ROUNDDOWN(va, PAGE_SIZE), PERM_USER|PERM_WRITEABLE|PERM_UHPAGE);
	if (ret < 0)
		panic("get_page() in user: failed to allocate page from the kernel");
	return 0;
}

//==============================================
// [3] RETURN A PAGE FROM THE DA TO KERNEL:
//==============================================
void return_page(void* va)
{
	int ret = __sys_unmap_frame(ROUNDDOWN((uint32)va, PAGE_SIZE));
	if (ret < 0)
		panic("return_page() in user: failed to return a page to the kernel");
}

//==================================================================================//
//============================ REQUIRED FUNCTIONS ==================================//
//==================================================================================//

//=================================
// [1] ALLOCATE SPACE IN USER HEAP:
//=================================
void* malloc(uint32 size)
{
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
	if (size == 0) return NULL ;
	//==============================================================

	acquire_uspinlock(&ulock);
	if(size <  DYN_ALLOC_MAX_BLOCK_SIZE){
		release_uspinlock(&ulock);
		return alloc_block(size);
	}

	struct UserHeapStruct* allocblock= (struct UserHeapStruct*) alloc_block(sizeof(struct UserHeapStruct));

	if (allocblock == NULL){
			return NULL;
	}

	size = ROUNDUP(size,PAGE_SIZE);
	struct UserHeapStruct* lastfreeelement = LIST_LAST(&u_freelist);

	if(LIST_SIZE(&u_freelist)==0 || size>lastfreeelement->size){
			if(uheapPageAllocBreak < USER_HEAP_MAX - size){
					uint32 requestedblockva = uheapPageAllocBreak;
					uheapPageAllocBreak+=size;
					allocblock->startva = requestedblockva;
					allocblock->size = size;

					LIST_INSERT_TAIL(&u_allocatedlist, allocblock);


					sys_allocate_user_mem(allocblock->startva ,size);
					release_uspinlock(&ulock);
					return (void*)allocblock->startva;
			}else{
					release_uspinlock(&ulock);
					return NULL;
				}
	}else{
		//custom fit
		struct UserHeapStruct* currentfreeelement = LIST_FIRST(&u_freelist);
		//worst fit
		while(currentfreeelement != NULL){
			if(size<currentfreeelement->size){
				allocblock->startva = lastfreeelement->startva;
                allocblock->size = size;
                LIST_INSERT_TAIL(&u_allocatedlist,allocblock);
                lastfreeelement->startva += size;
                lastfreeelement->size -= size;
                struct UserHeapStruct* currentfree2 = LIST_FIRST(&u_freelist);
                //check order of last element

                while (currentfree2 != NULL){
                	if(lastfreeelement->size <currentfree2->size){
                		LIST_REMOVE(&u_freelist ,lastfreeelement);
                		LIST_INSERT_BEFORE(&u_freelist ,currentfree2 ,lastfreeelement);
                		break;
                	}
                	currentfree2 = currentfree2->prev_next_info.le_next;
                }


                sys_allocate_user_mem(allocblock->startva ,size);
                release_uspinlock(&ulock);
                return (void*)allocblock->startva;
                //exact fit
			}else if(size == currentfreeelement->size){
				allocblock->startva = currentfreeelement->startva;
				allocblock->size = size;
				LIST_INSERT_TAIL(&u_allocatedlist ,allocblock);
				LIST_REMOVE(&u_freelist ,currentfreeelement);
				sys_allocate_user_mem(allocblock->startva ,size);
				release_uspinlock(&ulock);
				return (void*)allocblock->startva;
			}
			currentfreeelement = currentfreeelement->prev_next_info.le_next;
		}
	}
	 return NULL;
}

//=================================
// [2] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
	uint32  VA = ROUNDDOWN(((uint32 ) virtual_address), PAGE_SIZE);


		uheap_init();
		acquire_uspinlock(&ulock);
		if (VA < uheapPageAllocStart){
			free_block(virtual_address);
			release_uspinlock(&ulock);
			return;
		}
		if (VA >= uheapPageAllocBreak){
			cprintf("%d\n %d\n", VA, uheapPageAllocBreak);

			panic("freeing from restricted area");
			release_uspinlock(&ulock);
			return;
		}

		struct UserHeapStruct* newfree = (struct UserHeapStruct*) alloc_block(sizeof(struct UserHeapStruct));
		struct UserHeapStruct* MergedBlock  = ( struct UserHeapStruct*)alloc_block(sizeof(struct UserHeapStruct));

		struct UserHeapStruct* ToBefreed = LIST_FIRST(&u_allocatedlist);
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
				release_uspinlock(&ulock);
				return;
			}


		newfree->startva = ToBefreed->startva;
		newfree->size = ToBefreed->size;

		//remove allocated block from alloclist
		LIST_REMOVE(&u_allocatedlist, ToBefreed);

		sys_free_user_mem(ToBefreed->startva, ToBefreed->size);




		if(LIST_SIZE(&u_freelist) == 0){
			LIST_INSERT_HEAD(&u_freelist,newfree);
			release_uspinlock(&ulock);
			return;
		}


		struct UserHeapStruct* ToBeMerged = LIST_FIRST(&u_freelist);
		// merge with prev if possible
		bool mergeprev = 0;
		bool mergenext = 0;
		while(ToBeMerged != NULL){
			if((ToBeMerged->startva +ToBeMerged->size) == newfree->startva){

				MergedBlock->startva = ToBeMerged->startva;
				MergedBlock->size = ToBeMerged->size + newfree->size;
				LIST_REMOVE(&u_freelist, ToBeMerged);
				mergeprev = 1;
				break;
			}
				ToBeMerged = ToBeMerged->prev_next_info.le_next;
		}



			//move break
//					if(mergeprev){
//						if (MergedBlock->startva + MergedBlock->size == uheapPageAllocBreak){
//								uheapPageAllocBreak = MergedBlock->startva;
//						}
//					}else{
//						if (newfree->startva +newfree->size == uheapPageAllocBreak){
//									uheapPageAllocBreak = newfree->startva;
//						}
//					}


		if ( newfree ->startva + newfree->size == uheapPageAllocBreak){

			if(mergeprev){
				uheapPageAllocBreak = MergedBlock->startva;
				release_uspinlock(&ulock);
				return;

			}else{
				uheapPageAllocBreak = newfree->startva;
				release_uspinlock(&ulock);
				return;
			}

		}


		//check if block is merged with prev ,and find possible merge with next
		ToBeMerged = LIST_FIRST(&u_freelist);
		while(ToBeMerged != NULL){
			if ((newfree->startva + newfree->size) == ToBeMerged->startva ){
				if (mergeprev){
					MergedBlock->size += ToBeMerged->size;
					LIST_REMOVE(&u_freelist, ToBeMerged);
					break;
		//if not merged find possible merge with next
				}else{
					MergedBlock->startva = newfree->startva;
					MergedBlock->size  = newfree->size + ToBeMerged->size;
					LIST_REMOVE(&u_freelist, ToBeMerged);
					mergenext = 1;
					break;
				}
			}
			ToBeMerged = ToBeMerged->prev_next_info.le_next;
		}





			// insertion
			struct UserHeapStruct* currentfree = LIST_FIRST(&u_freelist);

			if(mergeprev || mergenext){
				while(currentfree != NULL){
					if(MergedBlock->size < currentfree->size){

							LIST_INSERT_BEFORE(&u_freelist,currentfree,MergedBlock);
							release_uspinlock(&ulock);
							return;
					}
							currentfree = currentfree->prev_next_info.le_next;
				}
				free_block(newfree);
				LIST_INSERT_TAIL(&u_freelist,MergedBlock);

			}else{
				while(currentfree != NULL){
					if(newfree->size < currentfree->size){

							LIST_INSERT_BEFORE(&u_freelist,currentfree,newfree);
							release_uspinlock(&ulock);
							return;
					}
							currentfree = currentfree->prev_next_info.le_next;
				}
				free_block(MergedBlock);
				LIST_INSERT_TAIL(&u_freelist,newfree);
			}
		release_uspinlock(&ulock);
		return;
}

//=================================
// [3] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
	if (size == 0) return NULL;
	//==============================================================
	acquire_uspinlock(&ulock);

	struct UserHeapStruct* allocblock = (struct UserHeapStruct*) alloc_block(sizeof(struct UserHeapStruct));
	if (allocblock == NULL){
				return NULL;
	}
		size = ROUNDUP(size,PAGE_SIZE);
		struct UserHeapStruct* lastfreeelement = LIST_LAST(&u_freelist);

		if(LIST_SIZE(&u_freelist)==0 || size>lastfreeelement->size){
				if(uheapPageAllocBreak <= USER_HEAP_MAX - size){
						uint32 requestedblockva = uheapPageAllocBreak;
						uheapPageAllocBreak+=size;
						allocblock->startva = requestedblockva;
						allocblock->size = size;

						LIST_INSERT_TAIL(&u_allocatedlist, allocblock);


						int result = sys_create_shared_object(sharedVarName ,size ,isWritable ,(void*)allocblock->startva);

						if(result <0){
							free_block(allocblock);
							release_uspinlock(&ulock);
							return NULL;
						}
						release_uspinlock(&ulock);
						return (void*)allocblock -> startva;
				}else{
						release_uspinlock(&ulock);
						return NULL;
					 }
		}else{
			//custom fit
			struct UserHeapStruct* currentfreeelement = LIST_FIRST(&u_freelist);
			//worst fit
			while(currentfreeelement != NULL){
				if(size<currentfreeelement->size){
					allocblock->startva = lastfreeelement->startva;
	                allocblock->size = size;
	                LIST_INSERT_TAIL(&u_allocatedlist,allocblock);
	                lastfreeelement->startva += size;
	                lastfreeelement->size -= size;
	                struct UserHeapStruct* currentfree2 = LIST_FIRST(&u_freelist);
	                //check order of last element

	                while (currentfree2 != NULL){
	                	if(lastfreeelement->size <currentfree2->size){
	                		LIST_REMOVE(&u_freelist ,lastfreeelement);
	                		LIST_INSERT_BEFORE(&u_freelist ,currentfree2 ,lastfreeelement);
	                		break;
	                	}
	                	currentfree2 = currentfree2->prev_next_info.le_next;
	                }


	                int result = sys_create_shared_object(sharedVarName ,size ,isWritable ,(void*)allocblock->startva);

	                if(result <0){
	                	free_block(allocblock);
	                	release_uspinlock(&ulock);
	                	return NULL;
	                }
	                release_uspinlock(&ulock);
	                return (void*)allocblock->startva;
	                //exact fit
				}else if(size == currentfreeelement->size){
					allocblock->startva = currentfreeelement->startva;
					allocblock->size = size;
					LIST_INSERT_TAIL(&u_allocatedlist ,allocblock);
					LIST_REMOVE(&u_freelist ,currentfreeelement);
					int result = sys_create_shared_object(sharedVarName ,size ,isWritable ,(void*)allocblock->startva);

					if(result <0){
						free_block(allocblock);
						release_uspinlock(&ulock);
						return NULL;
					}
					release_uspinlock(&ulock);
					return (void*)allocblock->startva;
				}
				currentfreeelement = currentfreeelement->prev_next_info.le_next;
			}
		}
		free_block(allocblock);
		release_uspinlock(&ulock);
		return NULL;
}



//========================================
// [4] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{


	 //==============================================================
	 // DON'T CHANGE THIS CODE
	    uheap_init();
	 //==============================================================
	 // Get size of the shared variable from kernel
	acquire_uspinlock(&ulock);


	int size = sys_size_of_shared_object(ownerEnvID ,sharedVarName);

	if ( size < 0 ){
			release_uspinlock(&ulock);
			return NULL;
		}
		size = ROUNDUP(size,PAGE_SIZE);

		struct UserHeapStruct* allocblock = (struct UserHeapStruct*) alloc_block(sizeof(struct UserHeapStruct));

		if (allocblock == NULL){
			return NULL;
		}
		struct UserHeapStruct* lastfreeelement = LIST_LAST(&u_freelist);

		if(LIST_SIZE(&u_freelist)==0 || size>lastfreeelement->size){
				if(uheapPageAllocBreak <= USER_HEAP_MAX - size){

						uint32 requestedblockva = uheapPageAllocBreak;
						uheapPageAllocBreak+=size;
						allocblock->startva = requestedblockva;
						allocblock->size = size;

						LIST_INSERT_TAIL(&u_allocatedlist, allocblock);


						int result = sys_get_shared_object(ownerEnvID ,sharedVarName ,(void*)allocblock->startva);

						if(result <0){
							free_block(allocblock);
							release_uspinlock(&ulock);
							return NULL;
						}
						release_uspinlock(&ulock);
						return (void*)allocblock -> startva;
				}else{
						release_uspinlock(&ulock);
						return NULL;
					 }
		}else{
			//custom fit
			struct UserHeapStruct* currentfreeelement = LIST_FIRST(&u_freelist);
			//worst fit
			while(currentfreeelement != NULL){
				if(size<currentfreeelement->size){
					allocblock->startva = lastfreeelement->startva;
					allocblock->size = size;
					LIST_INSERT_TAIL(&u_allocatedlist,allocblock);
					lastfreeelement->startva += size;
					lastfreeelement->size -= size;
					struct UserHeapStruct* currentfree2 = LIST_FIRST(&u_freelist);
					//check order of last element

					while (currentfree2 != NULL){
						if(lastfreeelement->size <currentfree2->size){
							LIST_REMOVE(&u_freelist ,lastfreeelement);
							LIST_INSERT_BEFORE(&u_freelist ,currentfree2 ,lastfreeelement);
							break;
						}
						currentfree2 = currentfree2->prev_next_info.le_next;
					}


					int result = sys_get_shared_object(ownerEnvID ,sharedVarName ,(void*)allocblock->startva);

					if(result <0){
						free_block(allocblock);
						release_uspinlock(&ulock);
						return NULL;
					}
					release_uspinlock(&ulock);
					return (void*)allocblock->startva;
					//exact fit
				}else if(size == currentfreeelement->size){

					allocblock->startva = currentfreeelement->startva;
					allocblock->size = size;
					LIST_INSERT_TAIL(&u_allocatedlist ,allocblock);
					LIST_REMOVE(&u_freelist ,currentfreeelement);

					int result = sys_get_shared_object(ownerEnvID ,sharedVarName ,(void*)allocblock->startva);
					if(result <0){
						free_block(allocblock);
						release_uspinlock(&ulock);
						return NULL;
					}

					release_uspinlock(&ulock);
					return (void*)allocblock->startva;
				}
				currentfreeelement = currentfreeelement->prev_next_info.le_next;
			}
		}
		free_block(allocblock);
		release_uspinlock(&ulock);
		return NULL;
}

//==================================================================================//
//============================== BONUS FUNCTIONS ===================================//
//==================================================================================//


//=================================
// REALLOC USER SPACE:
//=================================
//	Attempts to resize the allocated space at "virtual_address" to "new_size" bytes,
//	possibly moving it in the heap.
//	If successful, returns the new virtual_address, in which case the old virtual_address must no longer be accessed.
//	On failure, returns a null pointer, and the old virtual_address remains valid.

//	A call with virtual_address = null is equivalent to malloc().
//	A call with new_size = zero is equivalent to free().

//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
	//==============================================================
	panic("realloc() is not implemented yet...!!");
}


//=================================
// FREE SHARED VARIABLE:
//=================================
//	This function frees the shared variable at the given virtual_address
//	To do this, we need to switch to the kernel, free the pages AND "EMPTY" PAGE TABLES
//	from main memory then switch back to the user again.
//
//	use sys_delete_shared_object(...); which switches to the kernel mode,
//	calls delete_shared_object(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the delete_shared_object() function is empty, make sure to implement it.
void sfree(void* virtual_address)
{
	//TODO: [PROJECT'25.BONUS#5] EXIT #2 - sfree
	//Your code is here
	//Comment the following line
	panic("sfree() is not implemented yet...!!");

	//	1) you should find the ID of the shared variable at the given address
	//	2) you need to call sys_freeSharedObject()
}


//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
