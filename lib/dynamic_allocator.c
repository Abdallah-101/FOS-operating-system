/*
 * dynamic_allocator.c
 *
 *  Created on: Sep 21, 2023
 *      Author: HP
 */
#include <inc/assert.h>
#include <inc/string.h>
#include "../inc/dynamic_allocator.h"
//==================================================================================//
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//
//==================================
// [1] GET PAGE VA:
//==================================
__inline__ uint32 to_page_va(struct PageInfoElement *ptrPageInfo)
{
	//Get start VA of the page from the corresponding Page Info pointer
	int idxInPageInfoArr = (ptrPageInfo - pageBlockInfoArr);
	return dynAllocStart + (idxInPageInfoArr << PGSHIFT);
}

//==================================================================================//
//============================ REQUIRED FUNCTIONS ==================================//
//==================================================================================//
__inline__ int log2(uint32 n)
	{
		int result = 0;
		while( n > 1){
			n >>=1;
			result++;
		}
		return result;
	}
//==================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================
bool is_initialized = 0;
void initialize_dynamic_allocator(uint32 daStart, uint32 daEnd)
{
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(daEnd <= daStart + DYN_ALLOC_MAX_SIZE);
		is_initialized = 1;
	}
	//==================================================================================
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #1 initialize_dynamic_allocator
	//Your code is here


	dynAllocStart = daStart;
	dynAllocEnd= daEnd;
	int numOfPages = (dynAllocEnd - dynAllocStart)/PAGE_SIZE;


	for(int i=0; i< numOfPages; i++){
	    pageBlockInfoArr[i].block_size=0;
	    pageBlockInfoArr[i].num_of_free_blocks=0;
	}


	LIST_INIT(&freePagesList);
	for(int i=0; i<numOfPages; i++){
		LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
	}



	for (int i = 0; i < LOG2_MAX_SIZE - LOG2_MIN_SIZE + 1; i++) {
	    LIST_INIT(&freeBlockLists[i]);
	}



	//Comment the following line
	//panic("initialize_dynamic_allocator() Not implemented yet");

}

//===========================
// [2] GET BLOCK SIZE:
//===========================


__inline__ uint32 get_block_size(void *va)
{
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #2 get_block_size
	//Your code is here

	uint32 page_index = ((uint32)va - dynAllocStart)/ PAGE_SIZE;
    return pageBlockInfoArr[page_index].block_size;
	//Comment the following line
	//panic("get_block_size() Not implemented yet");
}

//===========================
// 3) ALLOCATE BLOCK:
//===========================
void *alloc_block(uint32 size)
{
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(size <= DYN_ALLOC_MAX_BLOCK_SIZE);
	}
	//==================================================================================
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #3 alloc_block
	//Your code is here


	if(size == 0){
		return NULL;
	}
	else if(size<=8){
		size=8;
	}
	else{
		uint32 reqsize=8;
		while(reqsize < size){
			reqsize*=2;
		}
		size= reqsize;
	}

	int list_index = log2(size)- LOG2_MIN_SIZE;

	if(!LIST_EMPTY(&freeBlockLists[list_index])){
		struct BlockElement *block = LIST_FIRST(&freeBlockLists[list_index]);
		LIST_REMOVE(&freeBlockLists[list_index], block);
		uint32 page_index = ((uint32)block - dynAllocStart)/ PAGE_SIZE;
		pageBlockInfoArr[page_index].num_of_free_blocks--;
		return (void*)block;
	}

	if(!LIST_EMPTY(&freePagesList)){

		struct PageInfoElement *page_info = LIST_FIRST(&freePagesList);
		LIST_REMOVE(&freePagesList, page_info);
		uint32 page_va = to_page_va(page_info);

		uint32 page_index = (page_va - dynAllocStart)/ PAGE_SIZE;

		get_page((void*)page_va);


		pageBlockInfoArr[page_index].block_size = size;
		int num_blocks = PAGE_SIZE / size ;
		pageBlockInfoArr[page_index].num_of_free_blocks= num_blocks - 1 ;

		for(int i=1; i< num_blocks; i++){
			struct BlockElement *new_block = (struct BlockElement*)(page_va + i *size);
			LIST_INSERT_TAIL(&freeBlockLists[list_index], new_block);
		}
		return(void*)page_va;
	}


	for(int i =list_index+1; i<= LOG2_MAX_SIZE - LOG2_MIN_SIZE; i++){

		if(!LIST_EMPTY(&freeBlockLists[i])){

			struct BlockElement *block = LIST_FIRST(&freeBlockLists[i]);
			LIST_REMOVE( &freeBlockLists[i], block);

			uint32 page_index = ((uint32)block - dynAllocStart)/ PAGE_SIZE;
			pageBlockInfoArr[page_index].num_of_free_blocks-- ;

			return (void*)block;
		}
	}

	panic("alloc_block: out of memory! ");
	return NULL;

	//Comment the following line
	//panic("alloc_block() Not implemented yet");

	//TODO: [PROJECT'25.BONUS#1] DYNAMIC ALLOCATOR - block if no free block
}

//===========================
// [4] FREE BLOCK:
//===========================
void free_block(void *va)
{
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert((uint32)va >= dynAllocStart && (uint32)va < dynAllocEnd);
	}
	//==================================================================================
	//==================================================================================

	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #4 free_block
	//Your code is here

	uint32 page_index=((uint32)va - dynAllocStart)/ PAGE_SIZE;
	uint32 block_size = pageBlockInfoArr[page_index].block_size;

	if(block_size == 0){
		panic("page is empty(already not allocated)");
	}

	int list_index = log2(block_size) - LOG2_MIN_SIZE;
	// mn va l block "elta7weel mn virtual l phy hna"
	struct BlockElement *block = (struct BlockElement *)va;
	LIST_INSERT_TAIL(&freeBlockLists[list_index], block);
	// b3d ma wdytha fy el freeBlockLists hzwed elfree elly fy el array 1
	pageBlockInfoArr[page_index].num_of_free_blocks++;
	int blocks_number = PAGE_SIZE / block_size;
	if(pageBlockInfoArr[page_index].num_of_free_blocks == blocks_number){
		struct BlockElement *itr = LIST_FIRST(&freeBlockLists[list_index]);
		while(itr != NULL){
			//lw ms7to el pointer mydy34 ->
			struct BlockElement *next = LIST_NEXT(itr);
			uint32 page_beginning_address= dynAllocStart + page_index * PAGE_SIZE;
			uint32 page_end_address = dynAllocStart + (page_index +1 )* PAGE_SIZE;

			if((uint32)itr >= page_beginning_address && (uint32)itr < page_end_address){
				LIST_REMOVE(&freeBlockLists[list_index], itr);
				//y5o4 3la elly b3do
				itr = next;
			}
		}
		pageBlockInfoArr[page_index].block_size=0;
		pageBlockInfoArr[page_index].num_of_free_blocks=0;

		struct PageInfoElement *page_info = &pageBlockInfoArr[page_index];
		LIST_INSERT_TAIL(&freePagesList, page_info);
		uint32 page_va = to_page_va(page_info);
		return_page((void *)page_va);
	}


	//Comment the following line
	//panic("free_block() Not implemented yet");
}

//==================================================================================//
//============================== BONUS FUNCTIONS ===================================//
//==================================================================================//

//===========================
// [1] REALLOCATE BLOCK:
//===========================
void *realloc_block(void* va, uint32 new_size)
{
	//TODO: [PROJECT'25.BONUS#2] KERNEL REALLOC - realloc_block
	//Your code is here
	//Comment the following line
	panic("realloc_block() Not implemented yet");
}
