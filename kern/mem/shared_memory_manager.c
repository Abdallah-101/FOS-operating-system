#include <inc/memlayout.h>
#include "shared_memory_manager.h"

#include <inc/mmu.h>
#include <inc/error.h>
#include <inc/string.h>
#include <inc/assert.h>
#include <inc/queue.h>
#include <inc/environment_definitions.h>

#include <kern/proc/user_environment.h>
#include <kern/trap/syscall.h>
#include "kheap.h"
#include "memory_manager.h"
//struct Share_List shares_list;
struct Share lock;



//==================================================================================//
//============================== GIVEN FUNCTIONS===================================//
//==================================================================================//

//===========================
// [1] INITIALIZE SHARES:
//===========================
//Initialize the list and the corresponding lock
void sharing_init()
{
#if USE_KHEAP
	LIST_INIT(&AllShares.shares_list);
	init_kspinlock(&AllShares.shareslock, "shares lock");
	//init_sleeplock(&AllShares.sharessleeplock, "shares sleep lock");
#else
	panic("not handled when KERN HEAP is disabled");
#endif
}

//=========================
// [2] Find Share Object:
//=========================
//Search for the given shared object in the "shares_list"
//Return:
//	a) if found: ptr to Share object
//	b) else: NULL
struct Share* find_share(int32 ownerID, char* name )
{
#if USE_KHEAP
	struct Share* ret= NULL;
	bool wasHeld= holding_kspinlock(&(AllShares.shareslock));
	if(!wasHeld)
	{
		acquire_kspinlock(&(AllShares.shareslock));
	}
	{
		struct Share* shr;
		LIST_FOREACH(shr, &(AllShares.shares_list))
		{
			//cprintf("shared var name= %s compared with %s\n", name, shr->name);
			if(shr->ownerID== ownerID && strcmp(name, shr->name)==0)
			{
				//cprintf("%s found\n", name);
				ret= shr;
				break;
			}
		}
	}
	if(!wasHeld)
	{
		release_kspinlock(&(AllShares.shareslock));
	}
	return ret;
#else
	panic("not handled when KERN HEAP is disabled");
#endif
}

//==============================
// [3] Get Size of Share Object:
//==============================
int size_of_shared_object(int32 ownerID, char* shareName)
{
	// This function should return the size of the given shared object
	// RETURN:
	//	a) If found, return size of shared object
	//	b) Else, return E_SHARED_MEM_NOT_EXISTS
	//
	struct Share* ptr_share= find_share(ownerID, shareName);
	if(ptr_share== NULL)
		return E_SHARED_MEM_NOT_EXISTS;
	else
		return ptr_share->size;

	return 0;
}
//===========================================================


//==================================================================================//
//============================ REQUIRED FUNCTIONS==================================//
//==================================================================================//

//=====================================
// [1] Alloc & Initialize Share Object:
//=====================================
struct Share* alloc_share(int32 ownerID, char* shareName, uint32 size, uint8 isWritable)
{


    int Noframes = ROUNDUP(size, PAGE_SIZE) / PAGE_SIZE;


    struct Share* sharedobj = (struct Share*) kmalloc(sizeof(struct Share));
    if (sharedobj == NULL) {
    	kfree(sharedobj);
        return NULL;
    }


    sharedobj->references = 1;
    sharedobj->size = ROUNDUP(size ,PAGE_SIZE);
    sharedobj->ownerID = ownerID;
    sharedobj->isWritable = isWritable;


    uint32 va = (uint32)sharedobj;
    sharedobj->ID = (uint32) va & 0x7FFFFFFF;

//    strncpy(sharedobj->name, shareName, sizeof(sharedobj->name) - 1);
//    sharedobj->name[sizeof(sharedobj->name) - 1] = '\0';

    strcpy(sharedobj->name, shareName);


    sharedobj->framesStorage = (struct FrameInfo**) kmalloc(Noframes * sizeof(struct FrameInfo*));
    if (sharedobj->framesStorage == NULL) {
        kfree(sharedobj->framesStorage);
        return NULL;
    }


    for (uint32 i = 0; i < Noframes; i++) {
        sharedobj->framesStorage[i] = NULL;
    }

//    init_kspinlock(&sharedobj->share_lock, "share_lock");

    return sharedobj;
}



//=========================
// [4] Create Share Object:
//=========================
int create_shared_object(int32 ownerID, char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
	acquire_kspinlock(&(AllShares.shareslock));

	struct Share* ret = find_share(ownerID ,shareName);

	if(ret != NULL ){
		release_kspinlock(&(AllShares.shareslock));
		return E_SHARED_MEM_EXISTS;
	}else{
		struct Env* myenv = get_cpu_proc();

		struct Share* newsharedobj = alloc_share(ownerID ,shareName ,size ,isWritable);

		if(newsharedobj == NULL){
			release_kspinlock(&(AllShares.shareslock));
			kfree(newsharedobj);
			return E_NO_SHARE;
		}else{




			size = ROUNDUP(size ,PAGE_SIZE);

			int frameNo = size/PAGE_SIZE;

			struct FrameInfo *ptr_frame_info = NULL;

			 uint32 perm = PERM_PRESENT | PERM_USER | PERM_WRITEABLE;

			for(int i =0 ; i < frameNo; i++){

						allocate_frame(&ptr_frame_info);

						newsharedobj->framesStorage[i] = ptr_frame_info;

						map_frame(myenv->env_page_directory, ptr_frame_info ,(uint32) virtual_address ,perm);

						virtual_address += PAGE_SIZE;
			}


			LIST_INSERT_TAIL(&(AllShares.shares_list) ,newsharedobj);
			release_kspinlock(&(AllShares.shareslock));

			return  newsharedobj->ID;
		}

	}

}

//======================
// [5] Get Share Object:
//======================
int get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
	 struct Env* myenv = get_cpu_proc();
	    if (myenv == NULL) {
	        return E_NO_SHARE;
	    }

	  acquire_kspinlock(&(AllShares.shareslock));

	  struct Share* requiredobj  = find_share (ownerID ,shareName);

	  if(requiredobj == NULL ){
	  		release_kspinlock(&(AllShares.shareslock));
	  		return E_SHARED_MEM_NOT_EXISTS ;
	  	}else{



	  		int frameNo = requiredobj->size/PAGE_SIZE;

	  		uint32 perm = PERM_PRESENT | PERM_USER;
	  		if (requiredobj->isWritable) perm |= PERM_WRITEABLE;

	  		for(int i = 0; i < frameNo;i++){

	  			map_frame(myenv->env_page_directory, requiredobj->framesStorage[i] ,(uint32) virtual_address ,perm);
	  			virtual_address += PAGE_SIZE;
	  		}

	  		requiredobj->references++;
	  		release_kspinlock(&(AllShares.shareslock));
	  		return requiredobj->ID;

	  	}


}







//==================================================================================//
//============================== BONUS FUNCTIONS===================================//
//==================================================================================//
//=========================
// [1] Delete Share Object:
//=========================
//delete the given shared object from the "shares_list"
//it should free its framesStorage and the share object itself
void free_share(struct Share* ptrShare)
{
	//TODO: [PROJECT'25.BONUS#5] EXIT #2 - free_share
	//Your code is here
	//Comment the following line
	panic("free_share() is not implemented yet...!!");
}


//=========================
// [2] Free Share Object:
//=========================
int delete_shared_object(int32 sharedObjectID, void *startVA)
{
	//TODO: [PROJECT'25.BONUS#5] EXIT #2 - delete_shared_object
	//Your code is here
	//Comment the following line
	panic("delete_shared_object() is not implemented yet...!!");

	struct Env* myenv = get_cpu_proc(); //The calling environment

	// This function should free (delete) the shared object from the User Heapof the current environment
	// If this is the last shared env, then the "frames_store" should be cleared and the shared object should be deleted
	// RETURN:
	//	a) 0 if success
	//	b) E_SHARED_MEM_NOT_EXISTS if the shared object is not exists

	// Steps:
	//	1) Get the shared object from the "shares" array (use get_share_object_ID())
	//	2) Unmap it from the current environment "myenv"
	//	3) If one or more table becomes empty, remove it
	//	4) Update references
	//	5) If this is the last share, delete the share object (use free_share())
	//	6) Flush the cache "tlbflush()"

}
