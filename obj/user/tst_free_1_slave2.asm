
obj/user/tst_free_1_slave2:     file format elf32-i386


Disassembly of section .text:

00800020 <_start>:
// starts us running when we are initially loaded into a new environment.
.text
.globl _start
_start:
	// See if we were started with arguments on the stack
	mov $0, %eax
  800020:	b8 00 00 00 00       	mov    $0x0,%eax
	cmpl $USTACKTOP, %esp
  800025:	81 fc 00 e0 bf ee    	cmp    $0xeebfe000,%esp
	jne args_exist
  80002b:	75 04                	jne    800031 <args_exist>

	// If not, push dummy argc/argv arguments.
	// This happens when we are loaded by the kernel,
	// because the kernel does not know about passing arguments.
	pushl $0
  80002d:	6a 00                	push   $0x0
	pushl $0
  80002f:	6a 00                	push   $0x0

00800031 <args_exist>:

args_exist:
	call libmain
  800031:	e8 ad 02 00 00       	call   8002e3 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
#include <inc/lib.h>


void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	57                   	push   %edi
  80003c:	53                   	push   %ebx
  80003d:	81 ec b0 00 00 00    	sub    $0xb0,%esp
#if USE_KHEAP

	//cprintf("1\n");
	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
	{
		if (LIST_SIZE(&(myEnv->page_WS_list)) >= myEnv->page_WS_max_size)
  800043:	a1 20 50 80 00       	mov    0x805020,%eax
  800048:	8b 90 94 00 00 00    	mov    0x94(%eax),%edx
  80004e:	a1 20 50 80 00       	mov    0x805020,%eax
  800053:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  800059:	39 c2                	cmp    %eax,%edx
  80005b:	72 14                	jb     800071 <_main+0x39>
			panic("Please increase the WS size");
  80005d:	83 ec 04             	sub    $0x4,%esp
  800060:	68 40 43 80 00       	push   $0x804340
  800065:	6a 12                	push   $0x12
  800067:	68 5c 43 80 00       	push   $0x80435c
  80006c:	e8 2b 04 00 00       	call   80049c <_panic>
	}
	//	/*Dummy malloc to enforce the UHEAP initializations*/
	//	malloc(0);
	/*=================================================*/
#endif
	uint32 pagealloc_start = USER_HEAP_START + DYN_ALLOC_MAX_SIZE + PAGE_SIZE; //UHS + 32MB + 4KB
  800071:	c7 45 f4 00 10 00 82 	movl   $0x82001000,-0xc(%ebp)


	int Mega = 1024*1024;
  800078:	c7 45 f0 00 00 10 00 	movl   $0x100000,-0x10(%ebp)
	int kilo = 1024;
  80007f:	c7 45 ec 00 04 00 00 	movl   $0x400,-0x14(%ebp)
	char minByte = 1<<7;
  800086:	c6 45 eb 80          	movb   $0x80,-0x15(%ebp)
	char maxByte = 0x7F;
  80008a:	c6 45 ea 7f          	movb   $0x7f,-0x16(%ebp)
	short minShort = 1<<15 ;
  80008e:	66 c7 45 e8 00 80    	movw   $0x8000,-0x18(%ebp)
	short maxShort = 0x7FFF;
  800094:	66 c7 45 e6 ff 7f    	movw   $0x7fff,-0x1a(%ebp)
	int minInt = 1<<31 ;
  80009a:	c7 45 e0 00 00 00 80 	movl   $0x80000000,-0x20(%ebp)
	int maxInt = 0x7FFFFFFF;
  8000a1:	c7 45 dc ff ff ff 7f 	movl   $0x7fffffff,-0x24(%ebp)
	char *byteArr ;
	int lastIndexOfByte;

	int freeFrames, usedDiskPages, chk;
	int expectedNumOfFrames, actualNumOfFrames;
	void* ptr_allocations[20] = {0};
  8000a8:	8d 95 60 ff ff ff    	lea    -0xa0(%ebp),%edx
  8000ae:	b9 14 00 00 00       	mov    $0x14,%ecx
  8000b3:	b8 00 00 00 00       	mov    $0x0,%eax
  8000b8:	89 d7                	mov    %edx,%edi
  8000ba:	f3 ab                	rep stos %eax,%es:(%edi)
	//ALLOCATE ONE SPACE
	{
		//2 MB
		{
			freeFrames = sys_calculate_free_frames() ;
  8000bc:	e8 14 30 00 00       	call   8030d5 <sys_calculate_free_frames>
  8000c1:	89 45 d8             	mov    %eax,-0x28(%ebp)
			usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8000c4:	e8 57 30 00 00       	call   803120 <sys_pf_calculate_allocated_pages>
  8000c9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			ptr_allocations[0] = malloc(2*Mega-kilo);
  8000cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8000cf:	01 c0                	add    %eax,%eax
  8000d1:	2b 45 ec             	sub    -0x14(%ebp),%eax
  8000d4:	83 ec 0c             	sub    $0xc,%esp
  8000d7:	50                   	push   %eax
  8000d8:	e8 a6 16 00 00       	call   801783 <malloc>
  8000dd:	83 c4 10             	add    $0x10,%esp
  8000e0:	89 85 60 ff ff ff    	mov    %eax,-0xa0(%ebp)
			if ((uint32) ptr_allocations[0] != (pagealloc_start)) panic("Wrong start address for the allocated space... ");
  8000e6:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
  8000ec:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8000ef:	74 14                	je     800105 <_main+0xcd>
  8000f1:	83 ec 04             	sub    $0x4,%esp
  8000f4:	68 78 43 80 00       	push   $0x804378
  8000f9:	6a 31                	push   $0x31
  8000fb:	68 5c 43 80 00       	push   $0x80435c
  800100:	e8 97 03 00 00       	call   80049c <_panic>
			if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  800105:	e8 16 30 00 00       	call   803120 <sys_pf_calculate_allocated_pages>
  80010a:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  80010d:	74 14                	je     800123 <_main+0xeb>
  80010f:	83 ec 04             	sub    $0x4,%esp
  800112:	68 a8 43 80 00       	push   $0x8043a8
  800117:	6a 32                	push   $0x32
  800119:	68 5c 43 80 00       	push   $0x80435c
  80011e:	e8 79 03 00 00       	call   80049c <_panic>

			freeFrames = sys_calculate_free_frames() ;
  800123:	e8 ad 2f 00 00       	call   8030d5 <sys_calculate_free_frames>
  800128:	89 45 d8             	mov    %eax,-0x28(%ebp)
			lastIndexOfByte = (2*Mega-kilo)/sizeof(char) - 1;
  80012b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80012e:	01 c0                	add    %eax,%eax
  800130:	2b 45 ec             	sub    -0x14(%ebp),%eax
  800133:	48                   	dec    %eax
  800134:	89 45 d0             	mov    %eax,-0x30(%ebp)
			byteArr = (char *) ptr_allocations[0];
  800137:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
  80013d:	89 45 cc             	mov    %eax,-0x34(%ebp)
			byteArr[0] = minByte ;
  800140:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800143:	8a 55 eb             	mov    -0x15(%ebp),%dl
  800146:	88 10                	mov    %dl,(%eax)
			byteArr[lastIndexOfByte] = maxByte ;
  800148:	8b 55 d0             	mov    -0x30(%ebp),%edx
  80014b:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80014e:	01 c2                	add    %eax,%edx
  800150:	8a 45 ea             	mov    -0x16(%ebp),%al
  800153:	88 02                	mov    %al,(%edx)
			expectedNumOfFrames = 2 /*+1 table already created in malloc due to marking the allocated pages*/ ;
  800155:	c7 45 c8 02 00 00 00 	movl   $0x2,-0x38(%ebp)
			actualNumOfFrames = (freeFrames - sys_calculate_free_frames()) ;
  80015c:	8b 5d d8             	mov    -0x28(%ebp),%ebx
  80015f:	e8 71 2f 00 00       	call   8030d5 <sys_calculate_free_frames>
  800164:	29 c3                	sub    %eax,%ebx
  800166:	89 d8                	mov    %ebx,%eax
  800168:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			if (actualNumOfFrames < expectedNumOfFrames)
  80016b:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80016e:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  800171:	7d 1a                	jge    80018d <_main+0x155>
				panic("Wrong fault handler: pages are not loaded successfully into memory/WS. Expected diff in frames at least = %d, actual = %d\n", expectedNumOfFrames, actualNumOfFrames);
  800173:	83 ec 0c             	sub    $0xc,%esp
  800176:	ff 75 c4             	pushl  -0x3c(%ebp)
  800179:	ff 75 c8             	pushl  -0x38(%ebp)
  80017c:	68 d8 43 80 00       	push   $0x8043d8
  800181:	6a 3c                	push   $0x3c
  800183:	68 5c 43 80 00       	push   $0x80435c
  800188:	e8 0f 03 00 00       	call   80049c <_panic>

			uint32 expectedVAs[2] = { ROUNDDOWN((uint32)(&(byteArr[0])), PAGE_SIZE), ROUNDDOWN((uint32)(&(byteArr[lastIndexOfByte])), PAGE_SIZE)} ;
  80018d:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800190:	89 45 c0             	mov    %eax,-0x40(%ebp)
  800193:	8b 45 c0             	mov    -0x40(%ebp),%eax
  800196:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80019b:	89 85 58 ff ff ff    	mov    %eax,-0xa8(%ebp)
  8001a1:	8b 55 d0             	mov    -0x30(%ebp),%edx
  8001a4:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8001a7:	01 d0                	add    %edx,%eax
  8001a9:	89 45 bc             	mov    %eax,-0x44(%ebp)
  8001ac:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8001af:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8001b4:	89 85 5c ff ff ff    	mov    %eax,-0xa4(%ebp)
			chk = sys_check_WS_list(expectedVAs, 2, 0, 2);
  8001ba:	6a 02                	push   $0x2
  8001bc:	6a 00                	push   $0x0
  8001be:	6a 02                	push   $0x2
  8001c0:	8d 85 58 ff ff ff    	lea    -0xa8(%ebp),%eax
  8001c6:	50                   	push   %eax
  8001c7:	e8 cb 32 00 00       	call   803497 <sys_check_WS_list>
  8001cc:	83 c4 10             	add    $0x10,%esp
  8001cf:	89 45 b8             	mov    %eax,-0x48(%ebp)
			if (chk != 1) panic("malloc: page is not added to WS");
  8001d2:	83 7d b8 01          	cmpl   $0x1,-0x48(%ebp)
  8001d6:	74 14                	je     8001ec <_main+0x1b4>
  8001d8:	83 ec 04             	sub    $0x4,%esp
  8001db:	68 54 44 80 00       	push   $0x804454
  8001e0:	6a 40                	push   $0x40
  8001e2:	68 5c 43 80 00       	push   $0x80435c
  8001e7:	e8 b0 02 00 00       	call   80049c <_panic>

	//FREE IT
	{
		//Free 1st 2 MB
		{
			freeFrames = sys_calculate_free_frames() ;
  8001ec:	e8 e4 2e 00 00       	call   8030d5 <sys_calculate_free_frames>
  8001f1:	89 45 d8             	mov    %eax,-0x28(%ebp)
			usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8001f4:	e8 27 2f 00 00       	call   803120 <sys_pf_calculate_allocated_pages>
  8001f9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			free(ptr_allocations[0]);
  8001fc:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
  800202:	83 ec 0c             	sub    $0xc,%esp
  800205:	50                   	push   %eax
  800206:	e8 76 1a 00 00       	call   801c81 <free>
  80020b:	83 c4 10             	add    $0x10,%esp

			if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 0) panic("Wrong free: Extra or less pages are removed from PageFile");
  80020e:	e8 0d 2f 00 00       	call   803120 <sys_pf_calculate_allocated_pages>
  800213:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  800216:	74 14                	je     80022c <_main+0x1f4>
  800218:	83 ec 04             	sub    $0x4,%esp
  80021b:	68 74 44 80 00       	push   $0x804474
  800220:	6a 4d                	push   $0x4d
  800222:	68 5c 43 80 00       	push   $0x80435c
  800227:	e8 70 02 00 00       	call   80049c <_panic>
			if ((sys_calculate_free_frames() - freeFrames) != 2 ) panic("Wrong free: WS pages in memory and/or page tables are not freed correctly");
  80022c:	e8 a4 2e 00 00       	call   8030d5 <sys_calculate_free_frames>
  800231:	89 c2                	mov    %eax,%edx
  800233:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800236:	29 c2                	sub    %eax,%edx
  800238:	89 d0                	mov    %edx,%eax
  80023a:	83 f8 02             	cmp    $0x2,%eax
  80023d:	74 14                	je     800253 <_main+0x21b>
  80023f:	83 ec 04             	sub    $0x4,%esp
  800242:	68 b0 44 80 00       	push   $0x8044b0
  800247:	6a 4e                	push   $0x4e
  800249:	68 5c 43 80 00       	push   $0x80435c
  80024e:	e8 49 02 00 00       	call   80049c <_panic>
			uint32 notExpectedVAs[2] = { ROUNDDOWN((uint32)(&(byteArr[0])), PAGE_SIZE), ROUNDDOWN((uint32)(&(byteArr[lastIndexOfByte])), PAGE_SIZE)} ;
  800253:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800256:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  800259:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  80025c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800261:	89 85 50 ff ff ff    	mov    %eax,-0xb0(%ebp)
  800267:	8b 55 d0             	mov    -0x30(%ebp),%edx
  80026a:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80026d:	01 d0                	add    %edx,%eax
  80026f:	89 45 b0             	mov    %eax,-0x50(%ebp)
  800272:	8b 45 b0             	mov    -0x50(%ebp),%eax
  800275:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80027a:	89 85 54 ff ff ff    	mov    %eax,-0xac(%ebp)
			chk = sys_check_WS_list(notExpectedVAs, 2, 0, 3);
  800280:	6a 03                	push   $0x3
  800282:	6a 00                	push   $0x0
  800284:	6a 02                	push   $0x2
  800286:	8d 85 50 ff ff ff    	lea    -0xb0(%ebp),%eax
  80028c:	50                   	push   %eax
  80028d:	e8 05 32 00 00       	call   803497 <sys_check_WS_list>
  800292:	83 c4 10             	add    $0x10,%esp
  800295:	89 45 b8             	mov    %eax,-0x48(%ebp)
			if (chk != 1) panic("free: page is not removed from WS");
  800298:	83 7d b8 01          	cmpl   $0x1,-0x48(%ebp)
  80029c:	74 14                	je     8002b2 <_main+0x27a>
  80029e:	83 ec 04             	sub    $0x4,%esp
  8002a1:	68 fc 44 80 00       	push   $0x8044fc
  8002a6:	6a 51                	push   $0x51
  8002a8:	68 5c 43 80 00       	push   $0x80435c
  8002ad:	e8 ea 01 00 00       	call   80049c <_panic>
		}
	}

	inctst(); //to ensure that it reached here
  8002b2:	e8 25 31 00 00       	call   8033dc <inctst>

	//wait until receiving a signal from the master
	while (gettst() != 3) ;
  8002b7:	90                   	nop
  8002b8:	e8 39 31 00 00       	call   8033f6 <gettst>
  8002bd:	83 f8 03             	cmp    $0x3,%eax
  8002c0:	75 f6                	jne    8002b8 <_main+0x280>

	//Test accessing a freed area (processes should be killed by the validation of the fault handler)
	{
		byteArr[0] = minByte ;
  8002c2:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8002c5:	8a 55 eb             	mov    -0x15(%ebp),%dl
  8002c8:	88 10                	mov    %dl,(%eax)
		inctst();
  8002ca:	e8 0d 31 00 00       	call   8033dc <inctst>
		panic("tst_free_1_slave1 failed: The env must be killed and shouldn't return here.");
  8002cf:	83 ec 04             	sub    $0x4,%esp
  8002d2:	68 20 45 80 00       	push   $0x804520
  8002d7:	6a 5e                	push   $0x5e
  8002d9:	68 5c 43 80 00       	push   $0x80435c
  8002de:	e8 b9 01 00 00       	call   80049c <_panic>

008002e3 <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  8002e3:	55                   	push   %ebp
  8002e4:	89 e5                	mov    %esp,%ebp
  8002e6:	57                   	push   %edi
  8002e7:	56                   	push   %esi
  8002e8:	53                   	push   %ebx
  8002e9:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  8002ec:	e8 ad 2f 00 00       	call   80329e <sys_getenvindex>
  8002f1:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  8002f4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8002f7:	89 d0                	mov    %edx,%eax
  8002f9:	c1 e0 02             	shl    $0x2,%eax
  8002fc:	01 d0                	add    %edx,%eax
  8002fe:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800305:	01 d0                	add    %edx,%eax
  800307:	89 c2                	mov    %eax,%edx
  800309:	c1 e2 04             	shl    $0x4,%edx
  80030c:	29 c2                	sub    %eax,%edx
  80030e:	8d 04 95 00 00 00 00 	lea    0x0(,%edx,4),%eax
  800315:	89 c2                	mov    %eax,%edx
  800317:	8d 82 00 00 c0 ee    	lea    -0x11400000(%edx),%eax
  80031d:	a3 20 50 80 00       	mov    %eax,0x805020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800322:	a1 20 50 80 00       	mov    0x805020,%eax
  800327:	8a 40 20             	mov    0x20(%eax),%al
  80032a:	84 c0                	test   %al,%al
  80032c:	74 0d                	je     80033b <libmain+0x58>
		binaryname = myEnv->prog_name;
  80032e:	a1 20 50 80 00       	mov    0x805020,%eax
  800333:	83 c0 20             	add    $0x20,%eax
  800336:	a3 04 50 80 00       	mov    %eax,0x805004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80033b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80033f:	7e 0a                	jle    80034b <libmain+0x68>
		binaryname = argv[0];
  800341:	8b 45 0c             	mov    0xc(%ebp),%eax
  800344:	8b 00                	mov    (%eax),%eax
  800346:	a3 04 50 80 00       	mov    %eax,0x805004

	// call user main routine
	_main(argc, argv);
  80034b:	83 ec 08             	sub    $0x8,%esp
  80034e:	ff 75 0c             	pushl  0xc(%ebp)
  800351:	ff 75 08             	pushl  0x8(%ebp)
  800354:	e8 df fc ff ff       	call   800038 <_main>
  800359:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  80035c:	a1 00 50 80 00       	mov    0x805000,%eax
  800361:	85 c0                	test   %eax,%eax
  800363:	0f 84 01 01 00 00    	je     80046a <libmain+0x187>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  800369:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  80036f:	bb 64 46 80 00       	mov    $0x804664,%ebx
  800374:	ba 0e 00 00 00       	mov    $0xe,%edx
  800379:	89 c7                	mov    %eax,%edi
  80037b:	89 de                	mov    %ebx,%esi
  80037d:	89 d1                	mov    %edx,%ecx
  80037f:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  800381:	8d 55 8a             	lea    -0x76(%ebp),%edx
  800384:	b9 56 00 00 00       	mov    $0x56,%ecx
  800389:	b0 00                	mov    $0x0,%al
  80038b:	89 d7                	mov    %edx,%edi
  80038d:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  80038f:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  800396:	8d 45 e0             	lea    -0x20(%ebp),%eax
  800399:	83 ec 08             	sub    $0x8,%esp
  80039c:	50                   	push   %eax
  80039d:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  8003a3:	50                   	push   %eax
  8003a4:	e8 2b 31 00 00       	call   8034d4 <sys_utilities>
  8003a9:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  8003ac:	e8 74 2c 00 00       	call   803025 <sys_lock_cons>
		{
			cprintf("**************************************\n");
  8003b1:	83 ec 0c             	sub    $0xc,%esp
  8003b4:	68 84 45 80 00       	push   $0x804584
  8003b9:	e8 ac 03 00 00       	call   80076a <cprintf>
  8003be:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  8003c1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8003c4:	85 c0                	test   %eax,%eax
  8003c6:	74 18                	je     8003e0 <libmain+0xfd>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  8003c8:	e8 25 31 00 00       	call   8034f2 <sys_get_optimal_num_faults>
  8003cd:	83 ec 08             	sub    $0x8,%esp
  8003d0:	50                   	push   %eax
  8003d1:	68 ac 45 80 00       	push   $0x8045ac
  8003d6:	e8 8f 03 00 00       	call   80076a <cprintf>
  8003db:	83 c4 10             	add    $0x10,%esp
  8003de:	eb 59                	jmp    800439 <libmain+0x156>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8003e0:	a1 20 50 80 00       	mov    0x805020,%eax
  8003e5:	8b 90 bc 05 00 00    	mov    0x5bc(%eax),%edx
  8003eb:	a1 20 50 80 00       	mov    0x805020,%eax
  8003f0:	8b 80 ac 05 00 00    	mov    0x5ac(%eax),%eax
  8003f6:	83 ec 04             	sub    $0x4,%esp
  8003f9:	52                   	push   %edx
  8003fa:	50                   	push   %eax
  8003fb:	68 d0 45 80 00       	push   $0x8045d0
  800400:	e8 65 03 00 00       	call   80076a <cprintf>
  800405:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800408:	a1 20 50 80 00       	mov    0x805020,%eax
  80040d:	8b 88 d0 05 00 00    	mov    0x5d0(%eax),%ecx
  800413:	a1 20 50 80 00       	mov    0x805020,%eax
  800418:	8b 90 cc 05 00 00    	mov    0x5cc(%eax),%edx
  80041e:	a1 20 50 80 00       	mov    0x805020,%eax
  800423:	8b 80 c8 05 00 00    	mov    0x5c8(%eax),%eax
  800429:	51                   	push   %ecx
  80042a:	52                   	push   %edx
  80042b:	50                   	push   %eax
  80042c:	68 f8 45 80 00       	push   $0x8045f8
  800431:	e8 34 03 00 00       	call   80076a <cprintf>
  800436:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800439:	a1 20 50 80 00       	mov    0x805020,%eax
  80043e:	8b 80 d4 05 00 00    	mov    0x5d4(%eax),%eax
  800444:	83 ec 08             	sub    $0x8,%esp
  800447:	50                   	push   %eax
  800448:	68 50 46 80 00       	push   $0x804650
  80044d:	e8 18 03 00 00       	call   80076a <cprintf>
  800452:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  800455:	83 ec 0c             	sub    $0xc,%esp
  800458:	68 84 45 80 00       	push   $0x804584
  80045d:	e8 08 03 00 00       	call   80076a <cprintf>
  800462:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  800465:	e8 d5 2b 00 00       	call   80303f <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  80046a:	e8 1f 00 00 00       	call   80048e <exit>
}
  80046f:	90                   	nop
  800470:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800473:	5b                   	pop    %ebx
  800474:	5e                   	pop    %esi
  800475:	5f                   	pop    %edi
  800476:	5d                   	pop    %ebp
  800477:	c3                   	ret    

00800478 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800478:	55                   	push   %ebp
  800479:	89 e5                	mov    %esp,%ebp
  80047b:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  80047e:	83 ec 0c             	sub    $0xc,%esp
  800481:	6a 00                	push   $0x0
  800483:	e8 e2 2d 00 00       	call   80326a <sys_destroy_env>
  800488:	83 c4 10             	add    $0x10,%esp
}
  80048b:	90                   	nop
  80048c:	c9                   	leave  
  80048d:	c3                   	ret    

0080048e <exit>:

void
exit(void)
{
  80048e:	55                   	push   %ebp
  80048f:	89 e5                	mov    %esp,%ebp
  800491:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800494:	e8 37 2e 00 00       	call   8032d0 <sys_exit_env>
}
  800499:	90                   	nop
  80049a:	c9                   	leave  
  80049b:	c3                   	ret    

0080049c <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  80049c:	55                   	push   %ebp
  80049d:	89 e5                	mov    %esp,%ebp
  80049f:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8004a2:	8d 45 10             	lea    0x10(%ebp),%eax
  8004a5:	83 c0 04             	add    $0x4,%eax
  8004a8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8004ab:	a1 18 d1 81 00       	mov    0x81d118,%eax
  8004b0:	85 c0                	test   %eax,%eax
  8004b2:	74 16                	je     8004ca <_panic+0x2e>
		cprintf("%s: ", argv0);
  8004b4:	a1 18 d1 81 00       	mov    0x81d118,%eax
  8004b9:	83 ec 08             	sub    $0x8,%esp
  8004bc:	50                   	push   %eax
  8004bd:	68 c8 46 80 00       	push   $0x8046c8
  8004c2:	e8 a3 02 00 00       	call   80076a <cprintf>
  8004c7:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  8004ca:	a1 04 50 80 00       	mov    0x805004,%eax
  8004cf:	83 ec 0c             	sub    $0xc,%esp
  8004d2:	ff 75 0c             	pushl  0xc(%ebp)
  8004d5:	ff 75 08             	pushl  0x8(%ebp)
  8004d8:	50                   	push   %eax
  8004d9:	68 d0 46 80 00       	push   $0x8046d0
  8004de:	6a 74                	push   $0x74
  8004e0:	e8 b2 02 00 00       	call   800797 <cprintf_colored>
  8004e5:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  8004e8:	8b 45 10             	mov    0x10(%ebp),%eax
  8004eb:	83 ec 08             	sub    $0x8,%esp
  8004ee:	ff 75 f4             	pushl  -0xc(%ebp)
  8004f1:	50                   	push   %eax
  8004f2:	e8 04 02 00 00       	call   8006fb <vcprintf>
  8004f7:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8004fa:	83 ec 08             	sub    $0x8,%esp
  8004fd:	6a 00                	push   $0x0
  8004ff:	68 f8 46 80 00       	push   $0x8046f8
  800504:	e8 f2 01 00 00       	call   8006fb <vcprintf>
  800509:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  80050c:	e8 7d ff ff ff       	call   80048e <exit>

	// should not return here
	while (1) ;
  800511:	eb fe                	jmp    800511 <_panic+0x75>

00800513 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800513:	55                   	push   %ebp
  800514:	89 e5                	mov    %esp,%ebp
  800516:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800519:	a1 20 50 80 00       	mov    0x805020,%eax
  80051e:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800524:	8b 45 0c             	mov    0xc(%ebp),%eax
  800527:	39 c2                	cmp    %eax,%edx
  800529:	74 14                	je     80053f <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  80052b:	83 ec 04             	sub    $0x4,%esp
  80052e:	68 fc 46 80 00       	push   $0x8046fc
  800533:	6a 26                	push   $0x26
  800535:	68 48 47 80 00       	push   $0x804748
  80053a:	e8 5d ff ff ff       	call   80049c <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  80053f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800546:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80054d:	e9 c5 00 00 00       	jmp    800617 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  800552:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800555:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80055c:	8b 45 08             	mov    0x8(%ebp),%eax
  80055f:	01 d0                	add    %edx,%eax
  800561:	8b 00                	mov    (%eax),%eax
  800563:	85 c0                	test   %eax,%eax
  800565:	75 08                	jne    80056f <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  800567:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  80056a:	e9 a5 00 00 00       	jmp    800614 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  80056f:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800576:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  80057d:	eb 69                	jmp    8005e8 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  80057f:	a1 20 50 80 00       	mov    0x805020,%eax
  800584:	8b 88 a4 05 00 00    	mov    0x5a4(%eax),%ecx
  80058a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80058d:	89 d0                	mov    %edx,%eax
  80058f:	01 c0                	add    %eax,%eax
  800591:	01 d0                	add    %edx,%eax
  800593:	c1 e0 03             	shl    $0x3,%eax
  800596:	01 c8                	add    %ecx,%eax
  800598:	8a 40 04             	mov    0x4(%eax),%al
  80059b:	84 c0                	test   %al,%al
  80059d:	75 46                	jne    8005e5 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80059f:	a1 20 50 80 00       	mov    0x805020,%eax
  8005a4:	8b 88 a4 05 00 00    	mov    0x5a4(%eax),%ecx
  8005aa:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8005ad:	89 d0                	mov    %edx,%eax
  8005af:	01 c0                	add    %eax,%eax
  8005b1:	01 d0                	add    %edx,%eax
  8005b3:	c1 e0 03             	shl    $0x3,%eax
  8005b6:	01 c8                	add    %ecx,%eax
  8005b8:	8b 00                	mov    (%eax),%eax
  8005ba:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8005bd:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8005c0:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8005c5:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8005c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8005ca:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8005d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8005d4:	01 c8                	add    %ecx,%eax
  8005d6:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8005d8:	39 c2                	cmp    %eax,%edx
  8005da:	75 09                	jne    8005e5 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  8005dc:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8005e3:	eb 15                	jmp    8005fa <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8005e5:	ff 45 e8             	incl   -0x18(%ebp)
  8005e8:	a1 20 50 80 00       	mov    0x805020,%eax
  8005ed:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8005f3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8005f6:	39 c2                	cmp    %eax,%edx
  8005f8:	77 85                	ja     80057f <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8005fa:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8005fe:	75 14                	jne    800614 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  800600:	83 ec 04             	sub    $0x4,%esp
  800603:	68 54 47 80 00       	push   $0x804754
  800608:	6a 3a                	push   $0x3a
  80060a:	68 48 47 80 00       	push   $0x804748
  80060f:	e8 88 fe ff ff       	call   80049c <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800614:	ff 45 f0             	incl   -0x10(%ebp)
  800617:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80061a:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80061d:	0f 8c 2f ff ff ff    	jl     800552 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800623:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80062a:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800631:	eb 26                	jmp    800659 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800633:	a1 20 50 80 00       	mov    0x805020,%eax
  800638:	8b 88 a4 05 00 00    	mov    0x5a4(%eax),%ecx
  80063e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800641:	89 d0                	mov    %edx,%eax
  800643:	01 c0                	add    %eax,%eax
  800645:	01 d0                	add    %edx,%eax
  800647:	c1 e0 03             	shl    $0x3,%eax
  80064a:	01 c8                	add    %ecx,%eax
  80064c:	8a 40 04             	mov    0x4(%eax),%al
  80064f:	3c 01                	cmp    $0x1,%al
  800651:	75 03                	jne    800656 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  800653:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800656:	ff 45 e0             	incl   -0x20(%ebp)
  800659:	a1 20 50 80 00       	mov    0x805020,%eax
  80065e:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800664:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800667:	39 c2                	cmp    %eax,%edx
  800669:	77 c8                	ja     800633 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  80066b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80066e:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800671:	74 14                	je     800687 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  800673:	83 ec 04             	sub    $0x4,%esp
  800676:	68 a8 47 80 00       	push   $0x8047a8
  80067b:	6a 44                	push   $0x44
  80067d:	68 48 47 80 00       	push   $0x804748
  800682:	e8 15 fe ff ff       	call   80049c <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800687:	90                   	nop
  800688:	c9                   	leave  
  800689:	c3                   	ret    

0080068a <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  80068a:	55                   	push   %ebp
  80068b:	89 e5                	mov    %esp,%ebp
  80068d:	53                   	push   %ebx
  80068e:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  800691:	8b 45 0c             	mov    0xc(%ebp),%eax
  800694:	8b 00                	mov    (%eax),%eax
  800696:	8d 48 01             	lea    0x1(%eax),%ecx
  800699:	8b 55 0c             	mov    0xc(%ebp),%edx
  80069c:	89 0a                	mov    %ecx,(%edx)
  80069e:	8b 55 08             	mov    0x8(%ebp),%edx
  8006a1:	88 d1                	mov    %dl,%cl
  8006a3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8006a6:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8006aa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006ad:	8b 00                	mov    (%eax),%eax
  8006af:	3d ff 00 00 00       	cmp    $0xff,%eax
  8006b4:	75 30                	jne    8006e6 <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  8006b6:	8b 15 1c d1 81 00    	mov    0x81d11c,%edx
  8006bc:	a0 44 50 80 00       	mov    0x805044,%al
  8006c1:	0f b6 c0             	movzbl %al,%eax
  8006c4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8006c7:	8b 09                	mov    (%ecx),%ecx
  8006c9:	89 cb                	mov    %ecx,%ebx
  8006cb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8006ce:	83 c1 08             	add    $0x8,%ecx
  8006d1:	52                   	push   %edx
  8006d2:	50                   	push   %eax
  8006d3:	53                   	push   %ebx
  8006d4:	51                   	push   %ecx
  8006d5:	e8 07 29 00 00       	call   802fe1 <sys_cputs>
  8006da:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8006dd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006e0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8006e6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006e9:	8b 40 04             	mov    0x4(%eax),%eax
  8006ec:	8d 50 01             	lea    0x1(%eax),%edx
  8006ef:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006f2:	89 50 04             	mov    %edx,0x4(%eax)
}
  8006f5:	90                   	nop
  8006f6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8006f9:	c9                   	leave  
  8006fa:	c3                   	ret    

008006fb <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8006fb:	55                   	push   %ebp
  8006fc:	89 e5                	mov    %esp,%ebp
  8006fe:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800704:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80070b:	00 00 00 
	b.cnt = 0;
  80070e:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800715:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800718:	ff 75 0c             	pushl  0xc(%ebp)
  80071b:	ff 75 08             	pushl  0x8(%ebp)
  80071e:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800724:	50                   	push   %eax
  800725:	68 8a 06 80 00       	push   $0x80068a
  80072a:	e8 5a 02 00 00       	call   800989 <vprintfmt>
  80072f:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  800732:	8b 15 1c d1 81 00    	mov    0x81d11c,%edx
  800738:	a0 44 50 80 00       	mov    0x805044,%al
  80073d:	0f b6 c0             	movzbl %al,%eax
  800740:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  800746:	52                   	push   %edx
  800747:	50                   	push   %eax
  800748:	51                   	push   %ecx
  800749:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80074f:	83 c0 08             	add    $0x8,%eax
  800752:	50                   	push   %eax
  800753:	e8 89 28 00 00       	call   802fe1 <sys_cputs>
  800758:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  80075b:	c6 05 44 50 80 00 00 	movb   $0x0,0x805044
	return b.cnt;
  800762:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800768:	c9                   	leave  
  800769:	c3                   	ret    

0080076a <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  80076a:	55                   	push   %ebp
  80076b:	89 e5                	mov    %esp,%ebp
  80076d:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800770:	c6 05 44 50 80 00 01 	movb   $0x1,0x805044
	va_start(ap, fmt);
  800777:	8d 45 0c             	lea    0xc(%ebp),%eax
  80077a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80077d:	8b 45 08             	mov    0x8(%ebp),%eax
  800780:	83 ec 08             	sub    $0x8,%esp
  800783:	ff 75 f4             	pushl  -0xc(%ebp)
  800786:	50                   	push   %eax
  800787:	e8 6f ff ff ff       	call   8006fb <vcprintf>
  80078c:	83 c4 10             	add    $0x10,%esp
  80078f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800792:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800795:	c9                   	leave  
  800796:	c3                   	ret    

00800797 <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  800797:	55                   	push   %ebp
  800798:	89 e5                	mov    %esp,%ebp
  80079a:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  80079d:	c6 05 44 50 80 00 01 	movb   $0x1,0x805044
	curTextClr = (textClr << 8) ; //set text color by the given value
  8007a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8007a7:	c1 e0 08             	shl    $0x8,%eax
  8007aa:	a3 1c d1 81 00       	mov    %eax,0x81d11c
	va_start(ap, fmt);
  8007af:	8d 45 0c             	lea    0xc(%ebp),%eax
  8007b2:	83 c0 04             	add    $0x4,%eax
  8007b5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8007b8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007bb:	83 ec 08             	sub    $0x8,%esp
  8007be:	ff 75 f4             	pushl  -0xc(%ebp)
  8007c1:	50                   	push   %eax
  8007c2:	e8 34 ff ff ff       	call   8006fb <vcprintf>
  8007c7:	83 c4 10             	add    $0x10,%esp
  8007ca:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  8007cd:	c7 05 1c d1 81 00 00 	movl   $0x700,0x81d11c
  8007d4:	07 00 00 

	return cnt;
  8007d7:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8007da:	c9                   	leave  
  8007db:	c3                   	ret    

008007dc <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  8007dc:	55                   	push   %ebp
  8007dd:	89 e5                	mov    %esp,%ebp
  8007df:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  8007e2:	e8 3e 28 00 00       	call   803025 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  8007e7:	8d 45 0c             	lea    0xc(%ebp),%eax
  8007ea:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  8007ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8007f0:	83 ec 08             	sub    $0x8,%esp
  8007f3:	ff 75 f4             	pushl  -0xc(%ebp)
  8007f6:	50                   	push   %eax
  8007f7:	e8 ff fe ff ff       	call   8006fb <vcprintf>
  8007fc:	83 c4 10             	add    $0x10,%esp
  8007ff:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  800802:	e8 38 28 00 00       	call   80303f <sys_unlock_cons>
	return cnt;
  800807:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80080a:	c9                   	leave  
  80080b:	c3                   	ret    

0080080c <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80080c:	55                   	push   %ebp
  80080d:	89 e5                	mov    %esp,%ebp
  80080f:	53                   	push   %ebx
  800810:	83 ec 14             	sub    $0x14,%esp
  800813:	8b 45 10             	mov    0x10(%ebp),%eax
  800816:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800819:	8b 45 14             	mov    0x14(%ebp),%eax
  80081c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80081f:	8b 45 18             	mov    0x18(%ebp),%eax
  800822:	ba 00 00 00 00       	mov    $0x0,%edx
  800827:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80082a:	77 55                	ja     800881 <printnum+0x75>
  80082c:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80082f:	72 05                	jb     800836 <printnum+0x2a>
  800831:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800834:	77 4b                	ja     800881 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800836:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800839:	8d 58 ff             	lea    -0x1(%eax),%ebx
  80083c:	8b 45 18             	mov    0x18(%ebp),%eax
  80083f:	ba 00 00 00 00       	mov    $0x0,%edx
  800844:	52                   	push   %edx
  800845:	50                   	push   %eax
  800846:	ff 75 f4             	pushl  -0xc(%ebp)
  800849:	ff 75 f0             	pushl  -0x10(%ebp)
  80084c:	e8 7f 38 00 00       	call   8040d0 <__udivdi3>
  800851:	83 c4 10             	add    $0x10,%esp
  800854:	83 ec 04             	sub    $0x4,%esp
  800857:	ff 75 20             	pushl  0x20(%ebp)
  80085a:	53                   	push   %ebx
  80085b:	ff 75 18             	pushl  0x18(%ebp)
  80085e:	52                   	push   %edx
  80085f:	50                   	push   %eax
  800860:	ff 75 0c             	pushl  0xc(%ebp)
  800863:	ff 75 08             	pushl  0x8(%ebp)
  800866:	e8 a1 ff ff ff       	call   80080c <printnum>
  80086b:	83 c4 20             	add    $0x20,%esp
  80086e:	eb 1a                	jmp    80088a <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800870:	83 ec 08             	sub    $0x8,%esp
  800873:	ff 75 0c             	pushl  0xc(%ebp)
  800876:	ff 75 20             	pushl  0x20(%ebp)
  800879:	8b 45 08             	mov    0x8(%ebp),%eax
  80087c:	ff d0                	call   *%eax
  80087e:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800881:	ff 4d 1c             	decl   0x1c(%ebp)
  800884:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800888:	7f e6                	jg     800870 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80088a:	8b 4d 18             	mov    0x18(%ebp),%ecx
  80088d:	bb 00 00 00 00       	mov    $0x0,%ebx
  800892:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800895:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800898:	53                   	push   %ebx
  800899:	51                   	push   %ecx
  80089a:	52                   	push   %edx
  80089b:	50                   	push   %eax
  80089c:	e8 3f 39 00 00       	call   8041e0 <__umoddi3>
  8008a1:	83 c4 10             	add    $0x10,%esp
  8008a4:	05 14 4a 80 00       	add    $0x804a14,%eax
  8008a9:	8a 00                	mov    (%eax),%al
  8008ab:	0f be c0             	movsbl %al,%eax
  8008ae:	83 ec 08             	sub    $0x8,%esp
  8008b1:	ff 75 0c             	pushl  0xc(%ebp)
  8008b4:	50                   	push   %eax
  8008b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8008b8:	ff d0                	call   *%eax
  8008ba:	83 c4 10             	add    $0x10,%esp
}
  8008bd:	90                   	nop
  8008be:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8008c1:	c9                   	leave  
  8008c2:	c3                   	ret    

008008c3 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8008c3:	55                   	push   %ebp
  8008c4:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8008c6:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8008ca:	7e 1c                	jle    8008e8 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8008cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8008cf:	8b 00                	mov    (%eax),%eax
  8008d1:	8d 50 08             	lea    0x8(%eax),%edx
  8008d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8008d7:	89 10                	mov    %edx,(%eax)
  8008d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8008dc:	8b 00                	mov    (%eax),%eax
  8008de:	83 e8 08             	sub    $0x8,%eax
  8008e1:	8b 50 04             	mov    0x4(%eax),%edx
  8008e4:	8b 00                	mov    (%eax),%eax
  8008e6:	eb 40                	jmp    800928 <getuint+0x65>
	else if (lflag)
  8008e8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8008ec:	74 1e                	je     80090c <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8008ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8008f1:	8b 00                	mov    (%eax),%eax
  8008f3:	8d 50 04             	lea    0x4(%eax),%edx
  8008f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8008f9:	89 10                	mov    %edx,(%eax)
  8008fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8008fe:	8b 00                	mov    (%eax),%eax
  800900:	83 e8 04             	sub    $0x4,%eax
  800903:	8b 00                	mov    (%eax),%eax
  800905:	ba 00 00 00 00       	mov    $0x0,%edx
  80090a:	eb 1c                	jmp    800928 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  80090c:	8b 45 08             	mov    0x8(%ebp),%eax
  80090f:	8b 00                	mov    (%eax),%eax
  800911:	8d 50 04             	lea    0x4(%eax),%edx
  800914:	8b 45 08             	mov    0x8(%ebp),%eax
  800917:	89 10                	mov    %edx,(%eax)
  800919:	8b 45 08             	mov    0x8(%ebp),%eax
  80091c:	8b 00                	mov    (%eax),%eax
  80091e:	83 e8 04             	sub    $0x4,%eax
  800921:	8b 00                	mov    (%eax),%eax
  800923:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800928:	5d                   	pop    %ebp
  800929:	c3                   	ret    

0080092a <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  80092a:	55                   	push   %ebp
  80092b:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80092d:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800931:	7e 1c                	jle    80094f <getint+0x25>
		return va_arg(*ap, long long);
  800933:	8b 45 08             	mov    0x8(%ebp),%eax
  800936:	8b 00                	mov    (%eax),%eax
  800938:	8d 50 08             	lea    0x8(%eax),%edx
  80093b:	8b 45 08             	mov    0x8(%ebp),%eax
  80093e:	89 10                	mov    %edx,(%eax)
  800940:	8b 45 08             	mov    0x8(%ebp),%eax
  800943:	8b 00                	mov    (%eax),%eax
  800945:	83 e8 08             	sub    $0x8,%eax
  800948:	8b 50 04             	mov    0x4(%eax),%edx
  80094b:	8b 00                	mov    (%eax),%eax
  80094d:	eb 38                	jmp    800987 <getint+0x5d>
	else if (lflag)
  80094f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800953:	74 1a                	je     80096f <getint+0x45>
		return va_arg(*ap, long);
  800955:	8b 45 08             	mov    0x8(%ebp),%eax
  800958:	8b 00                	mov    (%eax),%eax
  80095a:	8d 50 04             	lea    0x4(%eax),%edx
  80095d:	8b 45 08             	mov    0x8(%ebp),%eax
  800960:	89 10                	mov    %edx,(%eax)
  800962:	8b 45 08             	mov    0x8(%ebp),%eax
  800965:	8b 00                	mov    (%eax),%eax
  800967:	83 e8 04             	sub    $0x4,%eax
  80096a:	8b 00                	mov    (%eax),%eax
  80096c:	99                   	cltd   
  80096d:	eb 18                	jmp    800987 <getint+0x5d>
	else
		return va_arg(*ap, int);
  80096f:	8b 45 08             	mov    0x8(%ebp),%eax
  800972:	8b 00                	mov    (%eax),%eax
  800974:	8d 50 04             	lea    0x4(%eax),%edx
  800977:	8b 45 08             	mov    0x8(%ebp),%eax
  80097a:	89 10                	mov    %edx,(%eax)
  80097c:	8b 45 08             	mov    0x8(%ebp),%eax
  80097f:	8b 00                	mov    (%eax),%eax
  800981:	83 e8 04             	sub    $0x4,%eax
  800984:	8b 00                	mov    (%eax),%eax
  800986:	99                   	cltd   
}
  800987:	5d                   	pop    %ebp
  800988:	c3                   	ret    

00800989 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800989:	55                   	push   %ebp
  80098a:	89 e5                	mov    %esp,%ebp
  80098c:	56                   	push   %esi
  80098d:	53                   	push   %ebx
  80098e:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800991:	eb 17                	jmp    8009aa <vprintfmt+0x21>
			if (ch == '\0')
  800993:	85 db                	test   %ebx,%ebx
  800995:	0f 84 c1 03 00 00    	je     800d5c <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  80099b:	83 ec 08             	sub    $0x8,%esp
  80099e:	ff 75 0c             	pushl  0xc(%ebp)
  8009a1:	53                   	push   %ebx
  8009a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8009a5:	ff d0                	call   *%eax
  8009a7:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8009aa:	8b 45 10             	mov    0x10(%ebp),%eax
  8009ad:	8d 50 01             	lea    0x1(%eax),%edx
  8009b0:	89 55 10             	mov    %edx,0x10(%ebp)
  8009b3:	8a 00                	mov    (%eax),%al
  8009b5:	0f b6 d8             	movzbl %al,%ebx
  8009b8:	83 fb 25             	cmp    $0x25,%ebx
  8009bb:	75 d6                	jne    800993 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8009bd:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  8009c1:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  8009c8:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8009cf:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8009d6:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8009dd:	8b 45 10             	mov    0x10(%ebp),%eax
  8009e0:	8d 50 01             	lea    0x1(%eax),%edx
  8009e3:	89 55 10             	mov    %edx,0x10(%ebp)
  8009e6:	8a 00                	mov    (%eax),%al
  8009e8:	0f b6 d8             	movzbl %al,%ebx
  8009eb:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8009ee:	83 f8 5b             	cmp    $0x5b,%eax
  8009f1:	0f 87 3d 03 00 00    	ja     800d34 <vprintfmt+0x3ab>
  8009f7:	8b 04 85 38 4a 80 00 	mov    0x804a38(,%eax,4),%eax
  8009fe:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800a00:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800a04:	eb d7                	jmp    8009dd <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800a06:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800a0a:	eb d1                	jmp    8009dd <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800a0c:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800a13:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800a16:	89 d0                	mov    %edx,%eax
  800a18:	c1 e0 02             	shl    $0x2,%eax
  800a1b:	01 d0                	add    %edx,%eax
  800a1d:	01 c0                	add    %eax,%eax
  800a1f:	01 d8                	add    %ebx,%eax
  800a21:	83 e8 30             	sub    $0x30,%eax
  800a24:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800a27:	8b 45 10             	mov    0x10(%ebp),%eax
  800a2a:	8a 00                	mov    (%eax),%al
  800a2c:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800a2f:	83 fb 2f             	cmp    $0x2f,%ebx
  800a32:	7e 3e                	jle    800a72 <vprintfmt+0xe9>
  800a34:	83 fb 39             	cmp    $0x39,%ebx
  800a37:	7f 39                	jg     800a72 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800a39:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800a3c:	eb d5                	jmp    800a13 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800a3e:	8b 45 14             	mov    0x14(%ebp),%eax
  800a41:	83 c0 04             	add    $0x4,%eax
  800a44:	89 45 14             	mov    %eax,0x14(%ebp)
  800a47:	8b 45 14             	mov    0x14(%ebp),%eax
  800a4a:	83 e8 04             	sub    $0x4,%eax
  800a4d:	8b 00                	mov    (%eax),%eax
  800a4f:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800a52:	eb 1f                	jmp    800a73 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800a54:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a58:	79 83                	jns    8009dd <vprintfmt+0x54>
				width = 0;
  800a5a:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800a61:	e9 77 ff ff ff       	jmp    8009dd <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800a66:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800a6d:	e9 6b ff ff ff       	jmp    8009dd <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800a72:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800a73:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a77:	0f 89 60 ff ff ff    	jns    8009dd <vprintfmt+0x54>
				width = precision, precision = -1;
  800a7d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800a80:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800a83:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800a8a:	e9 4e ff ff ff       	jmp    8009dd <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800a8f:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800a92:	e9 46 ff ff ff       	jmp    8009dd <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800a97:	8b 45 14             	mov    0x14(%ebp),%eax
  800a9a:	83 c0 04             	add    $0x4,%eax
  800a9d:	89 45 14             	mov    %eax,0x14(%ebp)
  800aa0:	8b 45 14             	mov    0x14(%ebp),%eax
  800aa3:	83 e8 04             	sub    $0x4,%eax
  800aa6:	8b 00                	mov    (%eax),%eax
  800aa8:	83 ec 08             	sub    $0x8,%esp
  800aab:	ff 75 0c             	pushl  0xc(%ebp)
  800aae:	50                   	push   %eax
  800aaf:	8b 45 08             	mov    0x8(%ebp),%eax
  800ab2:	ff d0                	call   *%eax
  800ab4:	83 c4 10             	add    $0x10,%esp
			break;
  800ab7:	e9 9b 02 00 00       	jmp    800d57 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800abc:	8b 45 14             	mov    0x14(%ebp),%eax
  800abf:	83 c0 04             	add    $0x4,%eax
  800ac2:	89 45 14             	mov    %eax,0x14(%ebp)
  800ac5:	8b 45 14             	mov    0x14(%ebp),%eax
  800ac8:	83 e8 04             	sub    $0x4,%eax
  800acb:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800acd:	85 db                	test   %ebx,%ebx
  800acf:	79 02                	jns    800ad3 <vprintfmt+0x14a>
				err = -err;
  800ad1:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800ad3:	83 fb 64             	cmp    $0x64,%ebx
  800ad6:	7f 0b                	jg     800ae3 <vprintfmt+0x15a>
  800ad8:	8b 34 9d 80 48 80 00 	mov    0x804880(,%ebx,4),%esi
  800adf:	85 f6                	test   %esi,%esi
  800ae1:	75 19                	jne    800afc <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800ae3:	53                   	push   %ebx
  800ae4:	68 25 4a 80 00       	push   $0x804a25
  800ae9:	ff 75 0c             	pushl  0xc(%ebp)
  800aec:	ff 75 08             	pushl  0x8(%ebp)
  800aef:	e8 70 02 00 00       	call   800d64 <printfmt>
  800af4:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800af7:	e9 5b 02 00 00       	jmp    800d57 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800afc:	56                   	push   %esi
  800afd:	68 2e 4a 80 00       	push   $0x804a2e
  800b02:	ff 75 0c             	pushl  0xc(%ebp)
  800b05:	ff 75 08             	pushl  0x8(%ebp)
  800b08:	e8 57 02 00 00       	call   800d64 <printfmt>
  800b0d:	83 c4 10             	add    $0x10,%esp
			break;
  800b10:	e9 42 02 00 00       	jmp    800d57 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800b15:	8b 45 14             	mov    0x14(%ebp),%eax
  800b18:	83 c0 04             	add    $0x4,%eax
  800b1b:	89 45 14             	mov    %eax,0x14(%ebp)
  800b1e:	8b 45 14             	mov    0x14(%ebp),%eax
  800b21:	83 e8 04             	sub    $0x4,%eax
  800b24:	8b 30                	mov    (%eax),%esi
  800b26:	85 f6                	test   %esi,%esi
  800b28:	75 05                	jne    800b2f <vprintfmt+0x1a6>
				p = "(null)";
  800b2a:	be 31 4a 80 00       	mov    $0x804a31,%esi
			if (width > 0 && padc != '-')
  800b2f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b33:	7e 6d                	jle    800ba2 <vprintfmt+0x219>
  800b35:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800b39:	74 67                	je     800ba2 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800b3b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800b3e:	83 ec 08             	sub    $0x8,%esp
  800b41:	50                   	push   %eax
  800b42:	56                   	push   %esi
  800b43:	e8 1e 03 00 00       	call   800e66 <strnlen>
  800b48:	83 c4 10             	add    $0x10,%esp
  800b4b:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800b4e:	eb 16                	jmp    800b66 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800b50:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800b54:	83 ec 08             	sub    $0x8,%esp
  800b57:	ff 75 0c             	pushl  0xc(%ebp)
  800b5a:	50                   	push   %eax
  800b5b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b5e:	ff d0                	call   *%eax
  800b60:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800b63:	ff 4d e4             	decl   -0x1c(%ebp)
  800b66:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b6a:	7f e4                	jg     800b50 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b6c:	eb 34                	jmp    800ba2 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800b6e:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800b72:	74 1c                	je     800b90 <vprintfmt+0x207>
  800b74:	83 fb 1f             	cmp    $0x1f,%ebx
  800b77:	7e 05                	jle    800b7e <vprintfmt+0x1f5>
  800b79:	83 fb 7e             	cmp    $0x7e,%ebx
  800b7c:	7e 12                	jle    800b90 <vprintfmt+0x207>
					putch('?', putdat);
  800b7e:	83 ec 08             	sub    $0x8,%esp
  800b81:	ff 75 0c             	pushl  0xc(%ebp)
  800b84:	6a 3f                	push   $0x3f
  800b86:	8b 45 08             	mov    0x8(%ebp),%eax
  800b89:	ff d0                	call   *%eax
  800b8b:	83 c4 10             	add    $0x10,%esp
  800b8e:	eb 0f                	jmp    800b9f <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800b90:	83 ec 08             	sub    $0x8,%esp
  800b93:	ff 75 0c             	pushl  0xc(%ebp)
  800b96:	53                   	push   %ebx
  800b97:	8b 45 08             	mov    0x8(%ebp),%eax
  800b9a:	ff d0                	call   *%eax
  800b9c:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b9f:	ff 4d e4             	decl   -0x1c(%ebp)
  800ba2:	89 f0                	mov    %esi,%eax
  800ba4:	8d 70 01             	lea    0x1(%eax),%esi
  800ba7:	8a 00                	mov    (%eax),%al
  800ba9:	0f be d8             	movsbl %al,%ebx
  800bac:	85 db                	test   %ebx,%ebx
  800bae:	74 24                	je     800bd4 <vprintfmt+0x24b>
  800bb0:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800bb4:	78 b8                	js     800b6e <vprintfmt+0x1e5>
  800bb6:	ff 4d e0             	decl   -0x20(%ebp)
  800bb9:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800bbd:	79 af                	jns    800b6e <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800bbf:	eb 13                	jmp    800bd4 <vprintfmt+0x24b>
				putch(' ', putdat);
  800bc1:	83 ec 08             	sub    $0x8,%esp
  800bc4:	ff 75 0c             	pushl  0xc(%ebp)
  800bc7:	6a 20                	push   $0x20
  800bc9:	8b 45 08             	mov    0x8(%ebp),%eax
  800bcc:	ff d0                	call   *%eax
  800bce:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800bd1:	ff 4d e4             	decl   -0x1c(%ebp)
  800bd4:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800bd8:	7f e7                	jg     800bc1 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800bda:	e9 78 01 00 00       	jmp    800d57 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800bdf:	83 ec 08             	sub    $0x8,%esp
  800be2:	ff 75 e8             	pushl  -0x18(%ebp)
  800be5:	8d 45 14             	lea    0x14(%ebp),%eax
  800be8:	50                   	push   %eax
  800be9:	e8 3c fd ff ff       	call   80092a <getint>
  800bee:	83 c4 10             	add    $0x10,%esp
  800bf1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bf4:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800bf7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800bfa:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800bfd:	85 d2                	test   %edx,%edx
  800bff:	79 23                	jns    800c24 <vprintfmt+0x29b>
				putch('-', putdat);
  800c01:	83 ec 08             	sub    $0x8,%esp
  800c04:	ff 75 0c             	pushl  0xc(%ebp)
  800c07:	6a 2d                	push   $0x2d
  800c09:	8b 45 08             	mov    0x8(%ebp),%eax
  800c0c:	ff d0                	call   *%eax
  800c0e:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800c11:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c14:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800c17:	f7 d8                	neg    %eax
  800c19:	83 d2 00             	adc    $0x0,%edx
  800c1c:	f7 da                	neg    %edx
  800c1e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c21:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800c24:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800c2b:	e9 bc 00 00 00       	jmp    800cec <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800c30:	83 ec 08             	sub    $0x8,%esp
  800c33:	ff 75 e8             	pushl  -0x18(%ebp)
  800c36:	8d 45 14             	lea    0x14(%ebp),%eax
  800c39:	50                   	push   %eax
  800c3a:	e8 84 fc ff ff       	call   8008c3 <getuint>
  800c3f:	83 c4 10             	add    $0x10,%esp
  800c42:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c45:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800c48:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800c4f:	e9 98 00 00 00       	jmp    800cec <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800c54:	83 ec 08             	sub    $0x8,%esp
  800c57:	ff 75 0c             	pushl  0xc(%ebp)
  800c5a:	6a 58                	push   $0x58
  800c5c:	8b 45 08             	mov    0x8(%ebp),%eax
  800c5f:	ff d0                	call   *%eax
  800c61:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800c64:	83 ec 08             	sub    $0x8,%esp
  800c67:	ff 75 0c             	pushl  0xc(%ebp)
  800c6a:	6a 58                	push   $0x58
  800c6c:	8b 45 08             	mov    0x8(%ebp),%eax
  800c6f:	ff d0                	call   *%eax
  800c71:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800c74:	83 ec 08             	sub    $0x8,%esp
  800c77:	ff 75 0c             	pushl  0xc(%ebp)
  800c7a:	6a 58                	push   $0x58
  800c7c:	8b 45 08             	mov    0x8(%ebp),%eax
  800c7f:	ff d0                	call   *%eax
  800c81:	83 c4 10             	add    $0x10,%esp
			break;
  800c84:	e9 ce 00 00 00       	jmp    800d57 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800c89:	83 ec 08             	sub    $0x8,%esp
  800c8c:	ff 75 0c             	pushl  0xc(%ebp)
  800c8f:	6a 30                	push   $0x30
  800c91:	8b 45 08             	mov    0x8(%ebp),%eax
  800c94:	ff d0                	call   *%eax
  800c96:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800c99:	83 ec 08             	sub    $0x8,%esp
  800c9c:	ff 75 0c             	pushl  0xc(%ebp)
  800c9f:	6a 78                	push   $0x78
  800ca1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ca4:	ff d0                	call   *%eax
  800ca6:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800ca9:	8b 45 14             	mov    0x14(%ebp),%eax
  800cac:	83 c0 04             	add    $0x4,%eax
  800caf:	89 45 14             	mov    %eax,0x14(%ebp)
  800cb2:	8b 45 14             	mov    0x14(%ebp),%eax
  800cb5:	83 e8 04             	sub    $0x4,%eax
  800cb8:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800cba:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800cbd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800cc4:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800ccb:	eb 1f                	jmp    800cec <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800ccd:	83 ec 08             	sub    $0x8,%esp
  800cd0:	ff 75 e8             	pushl  -0x18(%ebp)
  800cd3:	8d 45 14             	lea    0x14(%ebp),%eax
  800cd6:	50                   	push   %eax
  800cd7:	e8 e7 fb ff ff       	call   8008c3 <getuint>
  800cdc:	83 c4 10             	add    $0x10,%esp
  800cdf:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ce2:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800ce5:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800cec:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800cf0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800cf3:	83 ec 04             	sub    $0x4,%esp
  800cf6:	52                   	push   %edx
  800cf7:	ff 75 e4             	pushl  -0x1c(%ebp)
  800cfa:	50                   	push   %eax
  800cfb:	ff 75 f4             	pushl  -0xc(%ebp)
  800cfe:	ff 75 f0             	pushl  -0x10(%ebp)
  800d01:	ff 75 0c             	pushl  0xc(%ebp)
  800d04:	ff 75 08             	pushl  0x8(%ebp)
  800d07:	e8 00 fb ff ff       	call   80080c <printnum>
  800d0c:	83 c4 20             	add    $0x20,%esp
			break;
  800d0f:	eb 46                	jmp    800d57 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800d11:	83 ec 08             	sub    $0x8,%esp
  800d14:	ff 75 0c             	pushl  0xc(%ebp)
  800d17:	53                   	push   %ebx
  800d18:	8b 45 08             	mov    0x8(%ebp),%eax
  800d1b:	ff d0                	call   *%eax
  800d1d:	83 c4 10             	add    $0x10,%esp
			break;
  800d20:	eb 35                	jmp    800d57 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800d22:	c6 05 44 50 80 00 00 	movb   $0x0,0x805044
			break;
  800d29:	eb 2c                	jmp    800d57 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800d2b:	c6 05 44 50 80 00 01 	movb   $0x1,0x805044
			break;
  800d32:	eb 23                	jmp    800d57 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800d34:	83 ec 08             	sub    $0x8,%esp
  800d37:	ff 75 0c             	pushl  0xc(%ebp)
  800d3a:	6a 25                	push   $0x25
  800d3c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d3f:	ff d0                	call   *%eax
  800d41:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800d44:	ff 4d 10             	decl   0x10(%ebp)
  800d47:	eb 03                	jmp    800d4c <vprintfmt+0x3c3>
  800d49:	ff 4d 10             	decl   0x10(%ebp)
  800d4c:	8b 45 10             	mov    0x10(%ebp),%eax
  800d4f:	48                   	dec    %eax
  800d50:	8a 00                	mov    (%eax),%al
  800d52:	3c 25                	cmp    $0x25,%al
  800d54:	75 f3                	jne    800d49 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800d56:	90                   	nop
		}
	}
  800d57:	e9 35 fc ff ff       	jmp    800991 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800d5c:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800d5d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800d60:	5b                   	pop    %ebx
  800d61:	5e                   	pop    %esi
  800d62:	5d                   	pop    %ebp
  800d63:	c3                   	ret    

00800d64 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800d64:	55                   	push   %ebp
  800d65:	89 e5                	mov    %esp,%ebp
  800d67:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800d6a:	8d 45 10             	lea    0x10(%ebp),%eax
  800d6d:	83 c0 04             	add    $0x4,%eax
  800d70:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800d73:	8b 45 10             	mov    0x10(%ebp),%eax
  800d76:	ff 75 f4             	pushl  -0xc(%ebp)
  800d79:	50                   	push   %eax
  800d7a:	ff 75 0c             	pushl  0xc(%ebp)
  800d7d:	ff 75 08             	pushl  0x8(%ebp)
  800d80:	e8 04 fc ff ff       	call   800989 <vprintfmt>
  800d85:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800d88:	90                   	nop
  800d89:	c9                   	leave  
  800d8a:	c3                   	ret    

00800d8b <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800d8b:	55                   	push   %ebp
  800d8c:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800d8e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d91:	8b 40 08             	mov    0x8(%eax),%eax
  800d94:	8d 50 01             	lea    0x1(%eax),%edx
  800d97:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d9a:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800d9d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800da0:	8b 10                	mov    (%eax),%edx
  800da2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800da5:	8b 40 04             	mov    0x4(%eax),%eax
  800da8:	39 c2                	cmp    %eax,%edx
  800daa:	73 12                	jae    800dbe <sprintputch+0x33>
		*b->buf++ = ch;
  800dac:	8b 45 0c             	mov    0xc(%ebp),%eax
  800daf:	8b 00                	mov    (%eax),%eax
  800db1:	8d 48 01             	lea    0x1(%eax),%ecx
  800db4:	8b 55 0c             	mov    0xc(%ebp),%edx
  800db7:	89 0a                	mov    %ecx,(%edx)
  800db9:	8b 55 08             	mov    0x8(%ebp),%edx
  800dbc:	88 10                	mov    %dl,(%eax)
}
  800dbe:	90                   	nop
  800dbf:	5d                   	pop    %ebp
  800dc0:	c3                   	ret    

00800dc1 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800dc1:	55                   	push   %ebp
  800dc2:	89 e5                	mov    %esp,%ebp
  800dc4:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800dc7:	8b 45 08             	mov    0x8(%ebp),%eax
  800dca:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800dcd:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dd0:	8d 50 ff             	lea    -0x1(%eax),%edx
  800dd3:	8b 45 08             	mov    0x8(%ebp),%eax
  800dd6:	01 d0                	add    %edx,%eax
  800dd8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ddb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800de2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800de6:	74 06                	je     800dee <vsnprintf+0x2d>
  800de8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800dec:	7f 07                	jg     800df5 <vsnprintf+0x34>
		return -E_INVAL;
  800dee:	b8 03 00 00 00       	mov    $0x3,%eax
  800df3:	eb 20                	jmp    800e15 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800df5:	ff 75 14             	pushl  0x14(%ebp)
  800df8:	ff 75 10             	pushl  0x10(%ebp)
  800dfb:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800dfe:	50                   	push   %eax
  800dff:	68 8b 0d 80 00       	push   $0x800d8b
  800e04:	e8 80 fb ff ff       	call   800989 <vprintfmt>
  800e09:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800e0c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800e0f:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800e12:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800e15:	c9                   	leave  
  800e16:	c3                   	ret    

00800e17 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800e17:	55                   	push   %ebp
  800e18:	89 e5                	mov    %esp,%ebp
  800e1a:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800e1d:	8d 45 10             	lea    0x10(%ebp),%eax
  800e20:	83 c0 04             	add    $0x4,%eax
  800e23:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800e26:	8b 45 10             	mov    0x10(%ebp),%eax
  800e29:	ff 75 f4             	pushl  -0xc(%ebp)
  800e2c:	50                   	push   %eax
  800e2d:	ff 75 0c             	pushl  0xc(%ebp)
  800e30:	ff 75 08             	pushl  0x8(%ebp)
  800e33:	e8 89 ff ff ff       	call   800dc1 <vsnprintf>
  800e38:	83 c4 10             	add    $0x10,%esp
  800e3b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800e3e:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800e41:	c9                   	leave  
  800e42:	c3                   	ret    

00800e43 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800e43:	55                   	push   %ebp
  800e44:	89 e5                	mov    %esp,%ebp
  800e46:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800e49:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800e50:	eb 06                	jmp    800e58 <strlen+0x15>
		n++;
  800e52:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800e55:	ff 45 08             	incl   0x8(%ebp)
  800e58:	8b 45 08             	mov    0x8(%ebp),%eax
  800e5b:	8a 00                	mov    (%eax),%al
  800e5d:	84 c0                	test   %al,%al
  800e5f:	75 f1                	jne    800e52 <strlen+0xf>
		n++;
	return n;
  800e61:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e64:	c9                   	leave  
  800e65:	c3                   	ret    

00800e66 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800e66:	55                   	push   %ebp
  800e67:	89 e5                	mov    %esp,%ebp
  800e69:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800e6c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800e73:	eb 09                	jmp    800e7e <strnlen+0x18>
		n++;
  800e75:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800e78:	ff 45 08             	incl   0x8(%ebp)
  800e7b:	ff 4d 0c             	decl   0xc(%ebp)
  800e7e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e82:	74 09                	je     800e8d <strnlen+0x27>
  800e84:	8b 45 08             	mov    0x8(%ebp),%eax
  800e87:	8a 00                	mov    (%eax),%al
  800e89:	84 c0                	test   %al,%al
  800e8b:	75 e8                	jne    800e75 <strnlen+0xf>
		n++;
	return n;
  800e8d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e90:	c9                   	leave  
  800e91:	c3                   	ret    

00800e92 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800e92:	55                   	push   %ebp
  800e93:	89 e5                	mov    %esp,%ebp
  800e95:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800e98:	8b 45 08             	mov    0x8(%ebp),%eax
  800e9b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800e9e:	90                   	nop
  800e9f:	8b 45 08             	mov    0x8(%ebp),%eax
  800ea2:	8d 50 01             	lea    0x1(%eax),%edx
  800ea5:	89 55 08             	mov    %edx,0x8(%ebp)
  800ea8:	8b 55 0c             	mov    0xc(%ebp),%edx
  800eab:	8d 4a 01             	lea    0x1(%edx),%ecx
  800eae:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800eb1:	8a 12                	mov    (%edx),%dl
  800eb3:	88 10                	mov    %dl,(%eax)
  800eb5:	8a 00                	mov    (%eax),%al
  800eb7:	84 c0                	test   %al,%al
  800eb9:	75 e4                	jne    800e9f <strcpy+0xd>
		/* do nothing */;
	return ret;
  800ebb:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800ebe:	c9                   	leave  
  800ebf:	c3                   	ret    

00800ec0 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800ec0:	55                   	push   %ebp
  800ec1:	89 e5                	mov    %esp,%ebp
  800ec3:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800ec6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ec9:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800ecc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800ed3:	eb 1f                	jmp    800ef4 <strncpy+0x34>
		*dst++ = *src;
  800ed5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ed8:	8d 50 01             	lea    0x1(%eax),%edx
  800edb:	89 55 08             	mov    %edx,0x8(%ebp)
  800ede:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ee1:	8a 12                	mov    (%edx),%dl
  800ee3:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800ee5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ee8:	8a 00                	mov    (%eax),%al
  800eea:	84 c0                	test   %al,%al
  800eec:	74 03                	je     800ef1 <strncpy+0x31>
			src++;
  800eee:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800ef1:	ff 45 fc             	incl   -0x4(%ebp)
  800ef4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ef7:	3b 45 10             	cmp    0x10(%ebp),%eax
  800efa:	72 d9                	jb     800ed5 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800efc:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800eff:	c9                   	leave  
  800f00:	c3                   	ret    

00800f01 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800f01:	55                   	push   %ebp
  800f02:	89 e5                	mov    %esp,%ebp
  800f04:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800f07:	8b 45 08             	mov    0x8(%ebp),%eax
  800f0a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800f0d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f11:	74 30                	je     800f43 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800f13:	eb 16                	jmp    800f2b <strlcpy+0x2a>
			*dst++ = *src++;
  800f15:	8b 45 08             	mov    0x8(%ebp),%eax
  800f18:	8d 50 01             	lea    0x1(%eax),%edx
  800f1b:	89 55 08             	mov    %edx,0x8(%ebp)
  800f1e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f21:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f24:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800f27:	8a 12                	mov    (%edx),%dl
  800f29:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800f2b:	ff 4d 10             	decl   0x10(%ebp)
  800f2e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f32:	74 09                	je     800f3d <strlcpy+0x3c>
  800f34:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f37:	8a 00                	mov    (%eax),%al
  800f39:	84 c0                	test   %al,%al
  800f3b:	75 d8                	jne    800f15 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800f3d:	8b 45 08             	mov    0x8(%ebp),%eax
  800f40:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800f43:	8b 55 08             	mov    0x8(%ebp),%edx
  800f46:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f49:	29 c2                	sub    %eax,%edx
  800f4b:	89 d0                	mov    %edx,%eax
}
  800f4d:	c9                   	leave  
  800f4e:	c3                   	ret    

00800f4f <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800f4f:	55                   	push   %ebp
  800f50:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800f52:	eb 06                	jmp    800f5a <strcmp+0xb>
		p++, q++;
  800f54:	ff 45 08             	incl   0x8(%ebp)
  800f57:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800f5a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f5d:	8a 00                	mov    (%eax),%al
  800f5f:	84 c0                	test   %al,%al
  800f61:	74 0e                	je     800f71 <strcmp+0x22>
  800f63:	8b 45 08             	mov    0x8(%ebp),%eax
  800f66:	8a 10                	mov    (%eax),%dl
  800f68:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f6b:	8a 00                	mov    (%eax),%al
  800f6d:	38 c2                	cmp    %al,%dl
  800f6f:	74 e3                	je     800f54 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800f71:	8b 45 08             	mov    0x8(%ebp),%eax
  800f74:	8a 00                	mov    (%eax),%al
  800f76:	0f b6 d0             	movzbl %al,%edx
  800f79:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f7c:	8a 00                	mov    (%eax),%al
  800f7e:	0f b6 c0             	movzbl %al,%eax
  800f81:	29 c2                	sub    %eax,%edx
  800f83:	89 d0                	mov    %edx,%eax
}
  800f85:	5d                   	pop    %ebp
  800f86:	c3                   	ret    

00800f87 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800f87:	55                   	push   %ebp
  800f88:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800f8a:	eb 09                	jmp    800f95 <strncmp+0xe>
		n--, p++, q++;
  800f8c:	ff 4d 10             	decl   0x10(%ebp)
  800f8f:	ff 45 08             	incl   0x8(%ebp)
  800f92:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800f95:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f99:	74 17                	je     800fb2 <strncmp+0x2b>
  800f9b:	8b 45 08             	mov    0x8(%ebp),%eax
  800f9e:	8a 00                	mov    (%eax),%al
  800fa0:	84 c0                	test   %al,%al
  800fa2:	74 0e                	je     800fb2 <strncmp+0x2b>
  800fa4:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa7:	8a 10                	mov    (%eax),%dl
  800fa9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fac:	8a 00                	mov    (%eax),%al
  800fae:	38 c2                	cmp    %al,%dl
  800fb0:	74 da                	je     800f8c <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800fb2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fb6:	75 07                	jne    800fbf <strncmp+0x38>
		return 0;
  800fb8:	b8 00 00 00 00       	mov    $0x0,%eax
  800fbd:	eb 14                	jmp    800fd3 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800fbf:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc2:	8a 00                	mov    (%eax),%al
  800fc4:	0f b6 d0             	movzbl %al,%edx
  800fc7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fca:	8a 00                	mov    (%eax),%al
  800fcc:	0f b6 c0             	movzbl %al,%eax
  800fcf:	29 c2                	sub    %eax,%edx
  800fd1:	89 d0                	mov    %edx,%eax
}
  800fd3:	5d                   	pop    %ebp
  800fd4:	c3                   	ret    

00800fd5 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800fd5:	55                   	push   %ebp
  800fd6:	89 e5                	mov    %esp,%ebp
  800fd8:	83 ec 04             	sub    $0x4,%esp
  800fdb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fde:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800fe1:	eb 12                	jmp    800ff5 <strchr+0x20>
		if (*s == c)
  800fe3:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe6:	8a 00                	mov    (%eax),%al
  800fe8:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800feb:	75 05                	jne    800ff2 <strchr+0x1d>
			return (char *) s;
  800fed:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff0:	eb 11                	jmp    801003 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800ff2:	ff 45 08             	incl   0x8(%ebp)
  800ff5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff8:	8a 00                	mov    (%eax),%al
  800ffa:	84 c0                	test   %al,%al
  800ffc:	75 e5                	jne    800fe3 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800ffe:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801003:	c9                   	leave  
  801004:	c3                   	ret    

00801005 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801005:	55                   	push   %ebp
  801006:	89 e5                	mov    %esp,%ebp
  801008:	83 ec 04             	sub    $0x4,%esp
  80100b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80100e:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801011:	eb 0d                	jmp    801020 <strfind+0x1b>
		if (*s == c)
  801013:	8b 45 08             	mov    0x8(%ebp),%eax
  801016:	8a 00                	mov    (%eax),%al
  801018:	3a 45 fc             	cmp    -0x4(%ebp),%al
  80101b:	74 0e                	je     80102b <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  80101d:	ff 45 08             	incl   0x8(%ebp)
  801020:	8b 45 08             	mov    0x8(%ebp),%eax
  801023:	8a 00                	mov    (%eax),%al
  801025:	84 c0                	test   %al,%al
  801027:	75 ea                	jne    801013 <strfind+0xe>
  801029:	eb 01                	jmp    80102c <strfind+0x27>
		if (*s == c)
			break;
  80102b:	90                   	nop
	return (char *) s;
  80102c:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80102f:	c9                   	leave  
  801030:	c3                   	ret    

00801031 <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  801031:	55                   	push   %ebp
  801032:	89 e5                	mov    %esp,%ebp
  801034:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  801037:	8b 45 08             	mov    0x8(%ebp),%eax
  80103a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  80103d:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801041:	76 63                	jbe    8010a6 <memset+0x75>
		uint64 data_block = c;
  801043:	8b 45 0c             	mov    0xc(%ebp),%eax
  801046:	99                   	cltd   
  801047:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80104a:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  80104d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801050:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801053:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  801057:	c1 e0 08             	shl    $0x8,%eax
  80105a:	09 45 f0             	or     %eax,-0x10(%ebp)
  80105d:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  801060:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801063:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801066:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  80106a:	c1 e0 10             	shl    $0x10,%eax
  80106d:	09 45 f0             	or     %eax,-0x10(%ebp)
  801070:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  801073:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801076:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801079:	89 c2                	mov    %eax,%edx
  80107b:	b8 00 00 00 00       	mov    $0x0,%eax
  801080:	09 45 f0             	or     %eax,-0x10(%ebp)
  801083:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  801086:	eb 18                	jmp    8010a0 <memset+0x6f>
			*p64++ = data_block, n -= 8;
  801088:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80108b:	8d 41 08             	lea    0x8(%ecx),%eax
  80108e:	89 45 fc             	mov    %eax,-0x4(%ebp)
  801091:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801094:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801097:	89 01                	mov    %eax,(%ecx)
  801099:	89 51 04             	mov    %edx,0x4(%ecx)
  80109c:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  8010a0:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  8010a4:	77 e2                	ja     801088 <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  8010a6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010aa:	74 23                	je     8010cf <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  8010ac:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010af:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  8010b2:	eb 0e                	jmp    8010c2 <memset+0x91>
			*p8++ = (uint8)c;
  8010b4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010b7:	8d 50 01             	lea    0x1(%eax),%edx
  8010ba:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8010bd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010c0:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  8010c2:	8b 45 10             	mov    0x10(%ebp),%eax
  8010c5:	8d 50 ff             	lea    -0x1(%eax),%edx
  8010c8:	89 55 10             	mov    %edx,0x10(%ebp)
  8010cb:	85 c0                	test   %eax,%eax
  8010cd:	75 e5                	jne    8010b4 <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  8010cf:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8010d2:	c9                   	leave  
  8010d3:	c3                   	ret    

008010d4 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  8010d4:	55                   	push   %ebp
  8010d5:	89 e5                	mov    %esp,%ebp
  8010d7:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  8010da:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010dd:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  8010e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8010e3:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  8010e6:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  8010ea:	76 24                	jbe    801110 <memcpy+0x3c>
		while(n >= 8){
  8010ec:	eb 1c                	jmp    80110a <memcpy+0x36>
			*d64 = *s64;
  8010ee:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010f1:	8b 50 04             	mov    0x4(%eax),%edx
  8010f4:	8b 00                	mov    (%eax),%eax
  8010f6:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8010f9:	89 01                	mov    %eax,(%ecx)
  8010fb:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  8010fe:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  801102:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  801106:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  80110a:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  80110e:	77 de                	ja     8010ee <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  801110:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801114:	74 31                	je     801147 <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  801116:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801119:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  80111c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80111f:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  801122:	eb 16                	jmp    80113a <memcpy+0x66>
			*d8++ = *s8++;
  801124:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801127:	8d 50 01             	lea    0x1(%eax),%edx
  80112a:	89 55 f0             	mov    %edx,-0x10(%ebp)
  80112d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801130:	8d 4a 01             	lea    0x1(%edx),%ecx
  801133:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  801136:	8a 12                	mov    (%edx),%dl
  801138:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  80113a:	8b 45 10             	mov    0x10(%ebp),%eax
  80113d:	8d 50 ff             	lea    -0x1(%eax),%edx
  801140:	89 55 10             	mov    %edx,0x10(%ebp)
  801143:	85 c0                	test   %eax,%eax
  801145:	75 dd                	jne    801124 <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  801147:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80114a:	c9                   	leave  
  80114b:	c3                   	ret    

0080114c <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  80114c:	55                   	push   %ebp
  80114d:	89 e5                	mov    %esp,%ebp
  80114f:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801152:	8b 45 0c             	mov    0xc(%ebp),%eax
  801155:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801158:	8b 45 08             	mov    0x8(%ebp),%eax
  80115b:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  80115e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801161:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801164:	73 50                	jae    8011b6 <memmove+0x6a>
  801166:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801169:	8b 45 10             	mov    0x10(%ebp),%eax
  80116c:	01 d0                	add    %edx,%eax
  80116e:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801171:	76 43                	jbe    8011b6 <memmove+0x6a>
		s += n;
  801173:	8b 45 10             	mov    0x10(%ebp),%eax
  801176:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801179:	8b 45 10             	mov    0x10(%ebp),%eax
  80117c:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  80117f:	eb 10                	jmp    801191 <memmove+0x45>
			*--d = *--s;
  801181:	ff 4d f8             	decl   -0x8(%ebp)
  801184:	ff 4d fc             	decl   -0x4(%ebp)
  801187:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80118a:	8a 10                	mov    (%eax),%dl
  80118c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80118f:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  801191:	8b 45 10             	mov    0x10(%ebp),%eax
  801194:	8d 50 ff             	lea    -0x1(%eax),%edx
  801197:	89 55 10             	mov    %edx,0x10(%ebp)
  80119a:	85 c0                	test   %eax,%eax
  80119c:	75 e3                	jne    801181 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  80119e:	eb 23                	jmp    8011c3 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  8011a0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011a3:	8d 50 01             	lea    0x1(%eax),%edx
  8011a6:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8011a9:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8011ac:	8d 4a 01             	lea    0x1(%edx),%ecx
  8011af:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8011b2:	8a 12                	mov    (%edx),%dl
  8011b4:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  8011b6:	8b 45 10             	mov    0x10(%ebp),%eax
  8011b9:	8d 50 ff             	lea    -0x1(%eax),%edx
  8011bc:	89 55 10             	mov    %edx,0x10(%ebp)
  8011bf:	85 c0                	test   %eax,%eax
  8011c1:	75 dd                	jne    8011a0 <memmove+0x54>
			*d++ = *s++;

	return dst;
  8011c3:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8011c6:	c9                   	leave  
  8011c7:	c3                   	ret    

008011c8 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8011c8:	55                   	push   %ebp
  8011c9:	89 e5                	mov    %esp,%ebp
  8011cb:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  8011ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8011d1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  8011d4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011d7:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8011da:	eb 2a                	jmp    801206 <memcmp+0x3e>
		if (*s1 != *s2)
  8011dc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011df:	8a 10                	mov    (%eax),%dl
  8011e1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011e4:	8a 00                	mov    (%eax),%al
  8011e6:	38 c2                	cmp    %al,%dl
  8011e8:	74 16                	je     801200 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  8011ea:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011ed:	8a 00                	mov    (%eax),%al
  8011ef:	0f b6 d0             	movzbl %al,%edx
  8011f2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011f5:	8a 00                	mov    (%eax),%al
  8011f7:	0f b6 c0             	movzbl %al,%eax
  8011fa:	29 c2                	sub    %eax,%edx
  8011fc:	89 d0                	mov    %edx,%eax
  8011fe:	eb 18                	jmp    801218 <memcmp+0x50>
		s1++, s2++;
  801200:	ff 45 fc             	incl   -0x4(%ebp)
  801203:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801206:	8b 45 10             	mov    0x10(%ebp),%eax
  801209:	8d 50 ff             	lea    -0x1(%eax),%edx
  80120c:	89 55 10             	mov    %edx,0x10(%ebp)
  80120f:	85 c0                	test   %eax,%eax
  801211:	75 c9                	jne    8011dc <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801213:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801218:	c9                   	leave  
  801219:	c3                   	ret    

0080121a <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  80121a:	55                   	push   %ebp
  80121b:	89 e5                	mov    %esp,%ebp
  80121d:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801220:	8b 55 08             	mov    0x8(%ebp),%edx
  801223:	8b 45 10             	mov    0x10(%ebp),%eax
  801226:	01 d0                	add    %edx,%eax
  801228:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  80122b:	eb 15                	jmp    801242 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  80122d:	8b 45 08             	mov    0x8(%ebp),%eax
  801230:	8a 00                	mov    (%eax),%al
  801232:	0f b6 d0             	movzbl %al,%edx
  801235:	8b 45 0c             	mov    0xc(%ebp),%eax
  801238:	0f b6 c0             	movzbl %al,%eax
  80123b:	39 c2                	cmp    %eax,%edx
  80123d:	74 0d                	je     80124c <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80123f:	ff 45 08             	incl   0x8(%ebp)
  801242:	8b 45 08             	mov    0x8(%ebp),%eax
  801245:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801248:	72 e3                	jb     80122d <memfind+0x13>
  80124a:	eb 01                	jmp    80124d <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  80124c:	90                   	nop
	return (void *) s;
  80124d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801250:	c9                   	leave  
  801251:	c3                   	ret    

00801252 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801252:	55                   	push   %ebp
  801253:	89 e5                	mov    %esp,%ebp
  801255:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801258:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  80125f:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801266:	eb 03                	jmp    80126b <strtol+0x19>
		s++;
  801268:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80126b:	8b 45 08             	mov    0x8(%ebp),%eax
  80126e:	8a 00                	mov    (%eax),%al
  801270:	3c 20                	cmp    $0x20,%al
  801272:	74 f4                	je     801268 <strtol+0x16>
  801274:	8b 45 08             	mov    0x8(%ebp),%eax
  801277:	8a 00                	mov    (%eax),%al
  801279:	3c 09                	cmp    $0x9,%al
  80127b:	74 eb                	je     801268 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  80127d:	8b 45 08             	mov    0x8(%ebp),%eax
  801280:	8a 00                	mov    (%eax),%al
  801282:	3c 2b                	cmp    $0x2b,%al
  801284:	75 05                	jne    80128b <strtol+0x39>
		s++;
  801286:	ff 45 08             	incl   0x8(%ebp)
  801289:	eb 13                	jmp    80129e <strtol+0x4c>
	else if (*s == '-')
  80128b:	8b 45 08             	mov    0x8(%ebp),%eax
  80128e:	8a 00                	mov    (%eax),%al
  801290:	3c 2d                	cmp    $0x2d,%al
  801292:	75 0a                	jne    80129e <strtol+0x4c>
		s++, neg = 1;
  801294:	ff 45 08             	incl   0x8(%ebp)
  801297:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80129e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8012a2:	74 06                	je     8012aa <strtol+0x58>
  8012a4:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8012a8:	75 20                	jne    8012ca <strtol+0x78>
  8012aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8012ad:	8a 00                	mov    (%eax),%al
  8012af:	3c 30                	cmp    $0x30,%al
  8012b1:	75 17                	jne    8012ca <strtol+0x78>
  8012b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8012b6:	40                   	inc    %eax
  8012b7:	8a 00                	mov    (%eax),%al
  8012b9:	3c 78                	cmp    $0x78,%al
  8012bb:	75 0d                	jne    8012ca <strtol+0x78>
		s += 2, base = 16;
  8012bd:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8012c1:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8012c8:	eb 28                	jmp    8012f2 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8012ca:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8012ce:	75 15                	jne    8012e5 <strtol+0x93>
  8012d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8012d3:	8a 00                	mov    (%eax),%al
  8012d5:	3c 30                	cmp    $0x30,%al
  8012d7:	75 0c                	jne    8012e5 <strtol+0x93>
		s++, base = 8;
  8012d9:	ff 45 08             	incl   0x8(%ebp)
  8012dc:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8012e3:	eb 0d                	jmp    8012f2 <strtol+0xa0>
	else if (base == 0)
  8012e5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8012e9:	75 07                	jne    8012f2 <strtol+0xa0>
		base = 10;
  8012eb:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8012f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8012f5:	8a 00                	mov    (%eax),%al
  8012f7:	3c 2f                	cmp    $0x2f,%al
  8012f9:	7e 19                	jle    801314 <strtol+0xc2>
  8012fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8012fe:	8a 00                	mov    (%eax),%al
  801300:	3c 39                	cmp    $0x39,%al
  801302:	7f 10                	jg     801314 <strtol+0xc2>
			dig = *s - '0';
  801304:	8b 45 08             	mov    0x8(%ebp),%eax
  801307:	8a 00                	mov    (%eax),%al
  801309:	0f be c0             	movsbl %al,%eax
  80130c:	83 e8 30             	sub    $0x30,%eax
  80130f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801312:	eb 42                	jmp    801356 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801314:	8b 45 08             	mov    0x8(%ebp),%eax
  801317:	8a 00                	mov    (%eax),%al
  801319:	3c 60                	cmp    $0x60,%al
  80131b:	7e 19                	jle    801336 <strtol+0xe4>
  80131d:	8b 45 08             	mov    0x8(%ebp),%eax
  801320:	8a 00                	mov    (%eax),%al
  801322:	3c 7a                	cmp    $0x7a,%al
  801324:	7f 10                	jg     801336 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801326:	8b 45 08             	mov    0x8(%ebp),%eax
  801329:	8a 00                	mov    (%eax),%al
  80132b:	0f be c0             	movsbl %al,%eax
  80132e:	83 e8 57             	sub    $0x57,%eax
  801331:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801334:	eb 20                	jmp    801356 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801336:	8b 45 08             	mov    0x8(%ebp),%eax
  801339:	8a 00                	mov    (%eax),%al
  80133b:	3c 40                	cmp    $0x40,%al
  80133d:	7e 39                	jle    801378 <strtol+0x126>
  80133f:	8b 45 08             	mov    0x8(%ebp),%eax
  801342:	8a 00                	mov    (%eax),%al
  801344:	3c 5a                	cmp    $0x5a,%al
  801346:	7f 30                	jg     801378 <strtol+0x126>
			dig = *s - 'A' + 10;
  801348:	8b 45 08             	mov    0x8(%ebp),%eax
  80134b:	8a 00                	mov    (%eax),%al
  80134d:	0f be c0             	movsbl %al,%eax
  801350:	83 e8 37             	sub    $0x37,%eax
  801353:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801356:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801359:	3b 45 10             	cmp    0x10(%ebp),%eax
  80135c:	7d 19                	jge    801377 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  80135e:	ff 45 08             	incl   0x8(%ebp)
  801361:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801364:	0f af 45 10          	imul   0x10(%ebp),%eax
  801368:	89 c2                	mov    %eax,%edx
  80136a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80136d:	01 d0                	add    %edx,%eax
  80136f:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801372:	e9 7b ff ff ff       	jmp    8012f2 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801377:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801378:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80137c:	74 08                	je     801386 <strtol+0x134>
		*endptr = (char *) s;
  80137e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801381:	8b 55 08             	mov    0x8(%ebp),%edx
  801384:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801386:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80138a:	74 07                	je     801393 <strtol+0x141>
  80138c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80138f:	f7 d8                	neg    %eax
  801391:	eb 03                	jmp    801396 <strtol+0x144>
  801393:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801396:	c9                   	leave  
  801397:	c3                   	ret    

00801398 <ltostr>:

void
ltostr(long value, char *str)
{
  801398:	55                   	push   %ebp
  801399:	89 e5                	mov    %esp,%ebp
  80139b:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  80139e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8013a5:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8013ac:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8013b0:	79 13                	jns    8013c5 <ltostr+0x2d>
	{
		neg = 1;
  8013b2:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8013b9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013bc:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8013bf:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8013c2:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8013c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8013c8:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8013cd:	99                   	cltd   
  8013ce:	f7 f9                	idiv   %ecx
  8013d0:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8013d3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8013d6:	8d 50 01             	lea    0x1(%eax),%edx
  8013d9:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8013dc:	89 c2                	mov    %eax,%edx
  8013de:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013e1:	01 d0                	add    %edx,%eax
  8013e3:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8013e6:	83 c2 30             	add    $0x30,%edx
  8013e9:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8013eb:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8013ee:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8013f3:	f7 e9                	imul   %ecx
  8013f5:	c1 fa 02             	sar    $0x2,%edx
  8013f8:	89 c8                	mov    %ecx,%eax
  8013fa:	c1 f8 1f             	sar    $0x1f,%eax
  8013fd:	29 c2                	sub    %eax,%edx
  8013ff:	89 d0                	mov    %edx,%eax
  801401:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  801404:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801408:	75 bb                	jne    8013c5 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  80140a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801411:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801414:	48                   	dec    %eax
  801415:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801418:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80141c:	74 3d                	je     80145b <ltostr+0xc3>
		start = 1 ;
  80141e:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801425:	eb 34                	jmp    80145b <ltostr+0xc3>
	{
		char tmp = str[start] ;
  801427:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80142a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80142d:	01 d0                	add    %edx,%eax
  80142f:	8a 00                	mov    (%eax),%al
  801431:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801434:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801437:	8b 45 0c             	mov    0xc(%ebp),%eax
  80143a:	01 c2                	add    %eax,%edx
  80143c:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80143f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801442:	01 c8                	add    %ecx,%eax
  801444:	8a 00                	mov    (%eax),%al
  801446:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801448:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80144b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80144e:	01 c2                	add    %eax,%edx
  801450:	8a 45 eb             	mov    -0x15(%ebp),%al
  801453:	88 02                	mov    %al,(%edx)
		start++ ;
  801455:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801458:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  80145b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80145e:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801461:	7c c4                	jl     801427 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801463:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801466:	8b 45 0c             	mov    0xc(%ebp),%eax
  801469:	01 d0                	add    %edx,%eax
  80146b:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  80146e:	90                   	nop
  80146f:	c9                   	leave  
  801470:	c3                   	ret    

00801471 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801471:	55                   	push   %ebp
  801472:	89 e5                	mov    %esp,%ebp
  801474:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801477:	ff 75 08             	pushl  0x8(%ebp)
  80147a:	e8 c4 f9 ff ff       	call   800e43 <strlen>
  80147f:	83 c4 04             	add    $0x4,%esp
  801482:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801485:	ff 75 0c             	pushl  0xc(%ebp)
  801488:	e8 b6 f9 ff ff       	call   800e43 <strlen>
  80148d:	83 c4 04             	add    $0x4,%esp
  801490:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801493:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  80149a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8014a1:	eb 17                	jmp    8014ba <strcconcat+0x49>
		final[s] = str1[s] ;
  8014a3:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8014a6:	8b 45 10             	mov    0x10(%ebp),%eax
  8014a9:	01 c2                	add    %eax,%edx
  8014ab:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8014ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8014b1:	01 c8                	add    %ecx,%eax
  8014b3:	8a 00                	mov    (%eax),%al
  8014b5:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8014b7:	ff 45 fc             	incl   -0x4(%ebp)
  8014ba:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8014bd:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8014c0:	7c e1                	jl     8014a3 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8014c2:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8014c9:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8014d0:	eb 1f                	jmp    8014f1 <strcconcat+0x80>
		final[s++] = str2[i] ;
  8014d2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8014d5:	8d 50 01             	lea    0x1(%eax),%edx
  8014d8:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8014db:	89 c2                	mov    %eax,%edx
  8014dd:	8b 45 10             	mov    0x10(%ebp),%eax
  8014e0:	01 c2                	add    %eax,%edx
  8014e2:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8014e5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014e8:	01 c8                	add    %ecx,%eax
  8014ea:	8a 00                	mov    (%eax),%al
  8014ec:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8014ee:	ff 45 f8             	incl   -0x8(%ebp)
  8014f1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8014f4:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8014f7:	7c d9                	jl     8014d2 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8014f9:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8014fc:	8b 45 10             	mov    0x10(%ebp),%eax
  8014ff:	01 d0                	add    %edx,%eax
  801501:	c6 00 00             	movb   $0x0,(%eax)
}
  801504:	90                   	nop
  801505:	c9                   	leave  
  801506:	c3                   	ret    

00801507 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801507:	55                   	push   %ebp
  801508:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  80150a:	8b 45 14             	mov    0x14(%ebp),%eax
  80150d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801513:	8b 45 14             	mov    0x14(%ebp),%eax
  801516:	8b 00                	mov    (%eax),%eax
  801518:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80151f:	8b 45 10             	mov    0x10(%ebp),%eax
  801522:	01 d0                	add    %edx,%eax
  801524:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80152a:	eb 0c                	jmp    801538 <strsplit+0x31>
			*string++ = 0;
  80152c:	8b 45 08             	mov    0x8(%ebp),%eax
  80152f:	8d 50 01             	lea    0x1(%eax),%edx
  801532:	89 55 08             	mov    %edx,0x8(%ebp)
  801535:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801538:	8b 45 08             	mov    0x8(%ebp),%eax
  80153b:	8a 00                	mov    (%eax),%al
  80153d:	84 c0                	test   %al,%al
  80153f:	74 18                	je     801559 <strsplit+0x52>
  801541:	8b 45 08             	mov    0x8(%ebp),%eax
  801544:	8a 00                	mov    (%eax),%al
  801546:	0f be c0             	movsbl %al,%eax
  801549:	50                   	push   %eax
  80154a:	ff 75 0c             	pushl  0xc(%ebp)
  80154d:	e8 83 fa ff ff       	call   800fd5 <strchr>
  801552:	83 c4 08             	add    $0x8,%esp
  801555:	85 c0                	test   %eax,%eax
  801557:	75 d3                	jne    80152c <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801559:	8b 45 08             	mov    0x8(%ebp),%eax
  80155c:	8a 00                	mov    (%eax),%al
  80155e:	84 c0                	test   %al,%al
  801560:	74 5a                	je     8015bc <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801562:	8b 45 14             	mov    0x14(%ebp),%eax
  801565:	8b 00                	mov    (%eax),%eax
  801567:	83 f8 0f             	cmp    $0xf,%eax
  80156a:	75 07                	jne    801573 <strsplit+0x6c>
		{
			return 0;
  80156c:	b8 00 00 00 00       	mov    $0x0,%eax
  801571:	eb 66                	jmp    8015d9 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801573:	8b 45 14             	mov    0x14(%ebp),%eax
  801576:	8b 00                	mov    (%eax),%eax
  801578:	8d 48 01             	lea    0x1(%eax),%ecx
  80157b:	8b 55 14             	mov    0x14(%ebp),%edx
  80157e:	89 0a                	mov    %ecx,(%edx)
  801580:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801587:	8b 45 10             	mov    0x10(%ebp),%eax
  80158a:	01 c2                	add    %eax,%edx
  80158c:	8b 45 08             	mov    0x8(%ebp),%eax
  80158f:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801591:	eb 03                	jmp    801596 <strsplit+0x8f>
			string++;
  801593:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801596:	8b 45 08             	mov    0x8(%ebp),%eax
  801599:	8a 00                	mov    (%eax),%al
  80159b:	84 c0                	test   %al,%al
  80159d:	74 8b                	je     80152a <strsplit+0x23>
  80159f:	8b 45 08             	mov    0x8(%ebp),%eax
  8015a2:	8a 00                	mov    (%eax),%al
  8015a4:	0f be c0             	movsbl %al,%eax
  8015a7:	50                   	push   %eax
  8015a8:	ff 75 0c             	pushl  0xc(%ebp)
  8015ab:	e8 25 fa ff ff       	call   800fd5 <strchr>
  8015b0:	83 c4 08             	add    $0x8,%esp
  8015b3:	85 c0                	test   %eax,%eax
  8015b5:	74 dc                	je     801593 <strsplit+0x8c>
			string++;
	}
  8015b7:	e9 6e ff ff ff       	jmp    80152a <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8015bc:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8015bd:	8b 45 14             	mov    0x14(%ebp),%eax
  8015c0:	8b 00                	mov    (%eax),%eax
  8015c2:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8015c9:	8b 45 10             	mov    0x10(%ebp),%eax
  8015cc:	01 d0                	add    %edx,%eax
  8015ce:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8015d4:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8015d9:	c9                   	leave  
  8015da:	c3                   	ret    

008015db <str2lower>:


char* str2lower(char *dst, const char *src)
{
  8015db:	55                   	push   %ebp
  8015dc:	89 e5                	mov    %esp,%ebp
  8015de:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  8015e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8015e4:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  8015e7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8015ee:	eb 4a                	jmp    80163a <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  8015f0:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8015f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8015f6:	01 c2                	add    %eax,%edx
  8015f8:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8015fb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015fe:	01 c8                	add    %ecx,%eax
  801600:	8a 00                	mov    (%eax),%al
  801602:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  801604:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801607:	8b 45 0c             	mov    0xc(%ebp),%eax
  80160a:	01 d0                	add    %edx,%eax
  80160c:	8a 00                	mov    (%eax),%al
  80160e:	3c 40                	cmp    $0x40,%al
  801610:	7e 25                	jle    801637 <str2lower+0x5c>
  801612:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801615:	8b 45 0c             	mov    0xc(%ebp),%eax
  801618:	01 d0                	add    %edx,%eax
  80161a:	8a 00                	mov    (%eax),%al
  80161c:	3c 5a                	cmp    $0x5a,%al
  80161e:	7f 17                	jg     801637 <str2lower+0x5c>
		{
			dst[i] += 32 ;
  801620:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801623:	8b 45 08             	mov    0x8(%ebp),%eax
  801626:	01 d0                	add    %edx,%eax
  801628:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80162b:	8b 55 08             	mov    0x8(%ebp),%edx
  80162e:	01 ca                	add    %ecx,%edx
  801630:	8a 12                	mov    (%edx),%dl
  801632:	83 c2 20             	add    $0x20,%edx
  801635:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  801637:	ff 45 fc             	incl   -0x4(%ebp)
  80163a:	ff 75 0c             	pushl  0xc(%ebp)
  80163d:	e8 01 f8 ff ff       	call   800e43 <strlen>
  801642:	83 c4 04             	add    $0x4,%esp
  801645:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801648:	7f a6                	jg     8015f0 <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  80164a:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80164d:	c9                   	leave  
  80164e:	c3                   	ret    

0080164f <uheap_init>:
//==============================================
// [1] INITIALIZE USER HEAP:
//==============================================
int __firstTimeFlag = 1;
void uheap_init()
{
  80164f:	55                   	push   %ebp
  801650:	89 e5                	mov    %esp,%ebp
  801652:	83 ec 08             	sub    $0x8,%esp
	if(__firstTimeFlag)
  801655:	a1 08 50 80 00       	mov    0x805008,%eax
  80165a:	85 c0                	test   %eax,%eax
  80165c:	0f 84 95 00 00 00    	je     8016f7 <uheap_init+0xa8>
	{
		initialize_dynamic_allocator(USER_HEAP_START, USER_HEAP_START + DYN_ALLOC_MAX_SIZE);
  801662:	83 ec 08             	sub    $0x8,%esp
  801665:	68 00 00 00 82       	push   $0x82000000
  80166a:	68 00 00 00 80       	push   $0x80000000
  80166f:	e8 59 1f 00 00       	call   8035cd <initialize_dynamic_allocator>
  801674:	83 c4 10             	add    $0x10,%esp
		uheapPlaceStrategy = sys_get_uheap_strategy();
  801677:	e8 93 1d 00 00       	call   80340f <sys_get_uheap_strategy>
  80167c:	a3 60 d0 81 00       	mov    %eax,0x81d060
		uheapPageAllocStart = dynAllocEnd + PAGE_SIZE;
  801681:	a1 40 50 80 00       	mov    0x805040,%eax
  801686:	05 00 10 00 00       	add    $0x1000,%eax
  80168b:	a3 10 d1 81 00       	mov    %eax,0x81d110
		uheapPageAllocBreak = uheapPageAllocStart;
  801690:	a1 10 d1 81 00       	mov    0x81d110,%eax
  801695:	a3 68 d0 81 00       	mov    %eax,0x81d068
		init_uspinlock(&ulock,"malloc",1);
  80169a:	83 ec 04             	sub    $0x4,%esp
  80169d:	6a 01                	push   $0x1
  80169f:	68 a8 4b 80 00       	push   $0x804ba8
  8016a4:	68 40 d1 81 00       	push   $0x81d140
  8016a9:	e8 1a 29 00 00       	call   803fc8 <init_uspinlock>
  8016ae:	83 c4 10             	add    $0x10,%esp
		LIST_INIT(&u_freelist);
  8016b1:	c7 05 20 d1 81 00 00 	movl   $0x0,0x81d120
  8016b8:	00 00 00 
  8016bb:	c7 05 24 d1 81 00 00 	movl   $0x0,0x81d124
  8016c2:	00 00 00 
  8016c5:	c7 05 2c d1 81 00 00 	movl   $0x0,0x81d12c
  8016cc:	00 00 00 
		LIST_INIT(&u_allocatedlist);
  8016cf:	c7 05 30 d1 81 00 00 	movl   $0x0,0x81d130
  8016d6:	00 00 00 
  8016d9:	c7 05 34 d1 81 00 00 	movl   $0x0,0x81d134
  8016e0:	00 00 00 
  8016e3:	c7 05 3c d1 81 00 00 	movl   $0x0,0x81d13c
  8016ea:	00 00 00 
		__firstTimeFlag = 0;
  8016ed:	c7 05 08 50 80 00 00 	movl   $0x0,0x805008
  8016f4:	00 00 00 
	}
}
  8016f7:	90                   	nop
  8016f8:	c9                   	leave  
  8016f9:	c3                   	ret    

008016fa <get_page>:

//==============================================
// [2] GET A PAGE FROM THE KERNEL FOR DA:
//==============================================
int get_page(void* va)
{
  8016fa:	55                   	push   %ebp
  8016fb:	89 e5                	mov    %esp,%ebp
  8016fd:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_allocate_page(ROUNDDOWN(va, PAGE_SIZE), PERM_USER|PERM_WRITEABLE|PERM_UHPAGE);
  801700:	8b 45 08             	mov    0x8(%ebp),%eax
  801703:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801706:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801709:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80170e:	83 ec 08             	sub    $0x8,%esp
  801711:	68 06 04 00 00       	push   $0x406
  801716:	50                   	push   %eax
  801717:	e8 3d 19 00 00       	call   803059 <__sys_allocate_page>
  80171c:	83 c4 10             	add    $0x10,%esp
  80171f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  801722:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801726:	79 14                	jns    80173c <get_page+0x42>
		panic("get_page() in user: failed to allocate page from the kernel");
  801728:	83 ec 04             	sub    $0x4,%esp
  80172b:	68 b0 4b 80 00       	push   $0x804bb0
  801730:	6a 2d                	push   $0x2d
  801732:	68 ec 4b 80 00       	push   $0x804bec
  801737:	e8 60 ed ff ff       	call   80049c <_panic>
	return 0;
  80173c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801741:	c9                   	leave  
  801742:	c3                   	ret    

00801743 <return_page>:

//==============================================
// [3] RETURN A PAGE FROM THE DA TO KERNEL:
//==============================================
void return_page(void* va)
{
  801743:	55                   	push   %ebp
  801744:	89 e5                	mov    %esp,%ebp
  801746:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_unmap_frame(ROUNDDOWN((uint32)va, PAGE_SIZE));
  801749:	8b 45 08             	mov    0x8(%ebp),%eax
  80174c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80174f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801752:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801757:	83 ec 0c             	sub    $0xc,%esp
  80175a:	50                   	push   %eax
  80175b:	e8 40 19 00 00       	call   8030a0 <__sys_unmap_frame>
  801760:	83 c4 10             	add    $0x10,%esp
  801763:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  801766:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80176a:	79 14                	jns    801780 <return_page+0x3d>
		panic("return_page() in user: failed to return a page to the kernel");
  80176c:	83 ec 04             	sub    $0x4,%esp
  80176f:	68 f8 4b 80 00       	push   $0x804bf8
  801774:	6a 38                	push   $0x38
  801776:	68 ec 4b 80 00       	push   $0x804bec
  80177b:	e8 1c ed ff ff       	call   80049c <_panic>
}
  801780:	90                   	nop
  801781:	c9                   	leave  
  801782:	c3                   	ret    

00801783 <malloc>:

//=================================
// [1] ALLOCATE SPACE IN USER HEAP:
//=================================
void* malloc(uint32 size)
{
  801783:	55                   	push   %ebp
  801784:	89 e5                	mov    %esp,%ebp
  801786:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  801789:	e8 c1 fe ff ff       	call   80164f <uheap_init>
	if (size == 0) return NULL ;
  80178e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801792:	75 0a                	jne    80179e <malloc+0x1b>
  801794:	b8 00 00 00 00       	mov    $0x0,%eax
  801799:	e9 e1 04 00 00       	jmp    801c7f <malloc+0x4fc>
	//==============================================================

	acquire_uspinlock(&ulock);
  80179e:	83 ec 0c             	sub    $0xc,%esp
  8017a1:	68 40 d1 81 00       	push   $0x81d140
  8017a6:	e8 6c 28 00 00       	call   804017 <acquire_uspinlock>
  8017ab:	83 c4 10             	add    $0x10,%esp
	if(size <  DYN_ALLOC_MAX_BLOCK_SIZE){
  8017ae:	81 7d 08 ff 07 00 00 	cmpl   $0x7ff,0x8(%ebp)
  8017b5:	77 23                	ja     8017da <malloc+0x57>
		release_uspinlock(&ulock);
  8017b7:	83 ec 0c             	sub    $0xc,%esp
  8017ba:	68 40 d1 81 00       	push   $0x81d140
  8017bf:	e8 ab 28 00 00       	call   80406f <release_uspinlock>
  8017c4:	83 c4 10             	add    $0x10,%esp
		return alloc_block(size);
  8017c7:	83 ec 0c             	sub    $0xc,%esp
  8017ca:	ff 75 08             	pushl  0x8(%ebp)
  8017cd:	e8 dd 1f 00 00       	call   8037af <alloc_block>
  8017d2:	83 c4 10             	add    $0x10,%esp
  8017d5:	e9 a5 04 00 00       	jmp    801c7f <malloc+0x4fc>
	}

	struct UserHeapStruct* allocblock= (struct UserHeapStruct*) alloc_block(sizeof(struct UserHeapStruct));
  8017da:	83 ec 0c             	sub    $0xc,%esp
  8017dd:	6a 10                	push   $0x10
  8017df:	e8 cb 1f 00 00       	call   8037af <alloc_block>
  8017e4:	83 c4 10             	add    $0x10,%esp
  8017e7:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (allocblock == NULL){
  8017ea:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8017ee:	75 0a                	jne    8017fa <malloc+0x77>
			return NULL;
  8017f0:	b8 00 00 00 00       	mov    $0x0,%eax
  8017f5:	e9 85 04 00 00       	jmp    801c7f <malloc+0x4fc>
	}

	size = ROUNDUP(size,PAGE_SIZE);
  8017fa:	c7 45 e8 00 10 00 00 	movl   $0x1000,-0x18(%ebp)
  801801:	8b 55 08             	mov    0x8(%ebp),%edx
  801804:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801807:	01 d0                	add    %edx,%eax
  801809:	48                   	dec    %eax
  80180a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80180d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801810:	ba 00 00 00 00       	mov    $0x0,%edx
  801815:	f7 75 e8             	divl   -0x18(%ebp)
  801818:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80181b:	29 d0                	sub    %edx,%eax
  80181d:	89 45 08             	mov    %eax,0x8(%ebp)
	struct UserHeapStruct* lastfreeelement = LIST_LAST(&u_freelist);
  801820:	a1 24 d1 81 00       	mov    0x81d124,%eax
  801825:	89 45 e0             	mov    %eax,-0x20(%ebp)

	if(LIST_SIZE(&u_freelist)==0 || size>lastfreeelement->size){
  801828:	a1 2c d1 81 00       	mov    0x81d12c,%eax
  80182d:	85 c0                	test   %eax,%eax
  80182f:	74 0f                	je     801840 <malloc+0xbd>
  801831:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801834:	8b 40 04             	mov    0x4(%eax),%eax
  801837:	3b 45 08             	cmp    0x8(%ebp),%eax
  80183a:	0f 83 ea 00 00 00    	jae    80192a <malloc+0x1a7>
			if(uheapPageAllocBreak < USER_HEAP_MAX - size){
  801840:	b8 00 00 00 a0       	mov    $0xa0000000,%eax
  801845:	2b 45 08             	sub    0x8(%ebp),%eax
  801848:	89 c2                	mov    %eax,%edx
  80184a:	a1 68 d0 81 00       	mov    0x81d068,%eax
  80184f:	39 c2                	cmp    %eax,%edx
  801851:	0f 86 b9 00 00 00    	jbe    801910 <malloc+0x18d>
					uint32 requestedblockva = uheapPageAllocBreak;
  801857:	a1 68 d0 81 00       	mov    0x81d068,%eax
  80185c:	89 45 dc             	mov    %eax,-0x24(%ebp)
					uheapPageAllocBreak+=size;
  80185f:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  801865:	8b 45 08             	mov    0x8(%ebp),%eax
  801868:	01 d0                	add    %edx,%eax
  80186a:	a3 68 d0 81 00       	mov    %eax,0x81d068
					allocblock->startva = requestedblockva;
  80186f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801872:	8b 55 dc             	mov    -0x24(%ebp),%edx
  801875:	89 10                	mov    %edx,(%eax)
					allocblock->size = size;
  801877:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80187a:	8b 55 08             	mov    0x8(%ebp),%edx
  80187d:	89 50 04             	mov    %edx,0x4(%eax)

					LIST_INSERT_TAIL(&u_allocatedlist, allocblock);
  801880:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801884:	75 14                	jne    80189a <malloc+0x117>
  801886:	83 ec 04             	sub    $0x4,%esp
  801889:	68 38 4c 80 00       	push   $0x804c38
  80188e:	6a 60                	push   $0x60
  801890:	68 ec 4b 80 00       	push   $0x804bec
  801895:	e8 02 ec ff ff       	call   80049c <_panic>
  80189a:	8b 15 34 d1 81 00    	mov    0x81d134,%edx
  8018a0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8018a3:	89 50 0c             	mov    %edx,0xc(%eax)
  8018a6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8018a9:	8b 40 0c             	mov    0xc(%eax),%eax
  8018ac:	85 c0                	test   %eax,%eax
  8018ae:	74 0d                	je     8018bd <malloc+0x13a>
  8018b0:	a1 34 d1 81 00       	mov    0x81d134,%eax
  8018b5:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8018b8:	89 50 08             	mov    %edx,0x8(%eax)
  8018bb:	eb 08                	jmp    8018c5 <malloc+0x142>
  8018bd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8018c0:	a3 30 d1 81 00       	mov    %eax,0x81d130
  8018c5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8018c8:	a3 34 d1 81 00       	mov    %eax,0x81d134
  8018cd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8018d0:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  8018d7:	a1 3c d1 81 00       	mov    0x81d13c,%eax
  8018dc:	40                   	inc    %eax
  8018dd:	a3 3c d1 81 00       	mov    %eax,0x81d13c


					sys_allocate_user_mem(allocblock->startva ,size);
  8018e2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8018e5:	8b 00                	mov    (%eax),%eax
  8018e7:	83 ec 08             	sub    $0x8,%esp
  8018ea:	ff 75 08             	pushl  0x8(%ebp)
  8018ed:	50                   	push   %eax
  8018ee:	e8 34 1c 00 00       	call   803527 <sys_allocate_user_mem>
  8018f3:	83 c4 10             	add    $0x10,%esp
					release_uspinlock(&ulock);
  8018f6:	83 ec 0c             	sub    $0xc,%esp
  8018f9:	68 40 d1 81 00       	push   $0x81d140
  8018fe:	e8 6c 27 00 00       	call   80406f <release_uspinlock>
  801903:	83 c4 10             	add    $0x10,%esp
					return (void*)allocblock->startva;
  801906:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801909:	8b 00                	mov    (%eax),%eax
  80190b:	e9 6f 03 00 00       	jmp    801c7f <malloc+0x4fc>
			}else{
					release_uspinlock(&ulock);
  801910:	83 ec 0c             	sub    $0xc,%esp
  801913:	68 40 d1 81 00       	push   $0x81d140
  801918:	e8 52 27 00 00       	call   80406f <release_uspinlock>
  80191d:	83 c4 10             	add    $0x10,%esp
					return NULL;
  801920:	b8 00 00 00 00       	mov    $0x0,%eax
  801925:	e9 55 03 00 00       	jmp    801c7f <malloc+0x4fc>
				}
	}else{
		//custom fit
		struct UserHeapStruct* currentfreeelement = LIST_FIRST(&u_freelist);
  80192a:	a1 20 d1 81 00       	mov    0x81d120,%eax
  80192f:	89 45 f4             	mov    %eax,-0xc(%ebp)
		//worst fit
		while(currentfreeelement != NULL){
  801932:	e9 39 03 00 00       	jmp    801c70 <malloc+0x4ed>
			if(size<currentfreeelement->size){
  801937:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80193a:	8b 40 04             	mov    0x4(%eax),%eax
  80193d:	3b 45 08             	cmp    0x8(%ebp),%eax
  801940:	0f 86 e7 01 00 00    	jbe    801b2d <malloc+0x3aa>
				allocblock->startva = lastfreeelement->startva;
  801946:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801949:	8b 10                	mov    (%eax),%edx
  80194b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80194e:	89 10                	mov    %edx,(%eax)
                allocblock->size = size;
  801950:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801953:	8b 55 08             	mov    0x8(%ebp),%edx
  801956:	89 50 04             	mov    %edx,0x4(%eax)
                LIST_INSERT_TAIL(&u_allocatedlist,allocblock);
  801959:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80195d:	75 14                	jne    801973 <malloc+0x1f0>
  80195f:	83 ec 04             	sub    $0x4,%esp
  801962:	68 38 4c 80 00       	push   $0x804c38
  801967:	6a 72                	push   $0x72
  801969:	68 ec 4b 80 00       	push   $0x804bec
  80196e:	e8 29 eb ff ff       	call   80049c <_panic>
  801973:	8b 15 34 d1 81 00    	mov    0x81d134,%edx
  801979:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80197c:	89 50 0c             	mov    %edx,0xc(%eax)
  80197f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801982:	8b 40 0c             	mov    0xc(%eax),%eax
  801985:	85 c0                	test   %eax,%eax
  801987:	74 0d                	je     801996 <malloc+0x213>
  801989:	a1 34 d1 81 00       	mov    0x81d134,%eax
  80198e:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801991:	89 50 08             	mov    %edx,0x8(%eax)
  801994:	eb 08                	jmp    80199e <malloc+0x21b>
  801996:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801999:	a3 30 d1 81 00       	mov    %eax,0x81d130
  80199e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8019a1:	a3 34 d1 81 00       	mov    %eax,0x81d134
  8019a6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8019a9:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  8019b0:	a1 3c d1 81 00       	mov    0x81d13c,%eax
  8019b5:	40                   	inc    %eax
  8019b6:	a3 3c d1 81 00       	mov    %eax,0x81d13c
                lastfreeelement->startva += size;
  8019bb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8019be:	8b 10                	mov    (%eax),%edx
  8019c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8019c3:	01 c2                	add    %eax,%edx
  8019c5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8019c8:	89 10                	mov    %edx,(%eax)
                lastfreeelement->size -= size;
  8019ca:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8019cd:	8b 40 04             	mov    0x4(%eax),%eax
  8019d0:	2b 45 08             	sub    0x8(%ebp),%eax
  8019d3:	89 c2                	mov    %eax,%edx
  8019d5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8019d8:	89 50 04             	mov    %edx,0x4(%eax)
                struct UserHeapStruct* currentfree2 = LIST_FIRST(&u_freelist);
  8019db:	a1 20 d1 81 00       	mov    0x81d120,%eax
  8019e0:	89 45 f0             	mov    %eax,-0x10(%ebp)
                //check order of last element

                while (currentfree2 != NULL){
  8019e3:	e9 0d 01 00 00       	jmp    801af5 <malloc+0x372>
                	if(lastfreeelement->size <currentfree2->size){
  8019e8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8019eb:	8b 50 04             	mov    0x4(%eax),%edx
  8019ee:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019f1:	8b 40 04             	mov    0x4(%eax),%eax
  8019f4:	39 c2                	cmp    %eax,%edx
  8019f6:	0f 83 f0 00 00 00    	jae    801aec <malloc+0x369>
                		LIST_REMOVE(&u_freelist ,lastfreeelement);
  8019fc:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801a00:	75 14                	jne    801a16 <malloc+0x293>
  801a02:	83 ec 04             	sub    $0x4,%esp
  801a05:	68 5b 4c 80 00       	push   $0x804c5b
  801a0a:	6a 7a                	push   $0x7a
  801a0c:	68 ec 4b 80 00       	push   $0x804bec
  801a11:	e8 86 ea ff ff       	call   80049c <_panic>
  801a16:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801a19:	8b 40 08             	mov    0x8(%eax),%eax
  801a1c:	85 c0                	test   %eax,%eax
  801a1e:	74 11                	je     801a31 <malloc+0x2ae>
  801a20:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801a23:	8b 40 08             	mov    0x8(%eax),%eax
  801a26:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801a29:	8b 52 0c             	mov    0xc(%edx),%edx
  801a2c:	89 50 0c             	mov    %edx,0xc(%eax)
  801a2f:	eb 0b                	jmp    801a3c <malloc+0x2b9>
  801a31:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801a34:	8b 40 0c             	mov    0xc(%eax),%eax
  801a37:	a3 24 d1 81 00       	mov    %eax,0x81d124
  801a3c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801a3f:	8b 40 0c             	mov    0xc(%eax),%eax
  801a42:	85 c0                	test   %eax,%eax
  801a44:	74 11                	je     801a57 <malloc+0x2d4>
  801a46:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801a49:	8b 40 0c             	mov    0xc(%eax),%eax
  801a4c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801a4f:	8b 52 08             	mov    0x8(%edx),%edx
  801a52:	89 50 08             	mov    %edx,0x8(%eax)
  801a55:	eb 0b                	jmp    801a62 <malloc+0x2df>
  801a57:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801a5a:	8b 40 08             	mov    0x8(%eax),%eax
  801a5d:	a3 20 d1 81 00       	mov    %eax,0x81d120
  801a62:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801a65:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  801a6c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801a6f:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  801a76:	a1 2c d1 81 00       	mov    0x81d12c,%eax
  801a7b:	48                   	dec    %eax
  801a7c:	a3 2c d1 81 00       	mov    %eax,0x81d12c
                		LIST_INSERT_BEFORE(&u_freelist ,currentfree2 ,lastfreeelement);
  801a81:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801a85:	74 06                	je     801a8d <malloc+0x30a>
  801a87:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801a8b:	75 14                	jne    801aa1 <malloc+0x31e>
  801a8d:	83 ec 04             	sub    $0x4,%esp
  801a90:	68 7c 4c 80 00       	push   $0x804c7c
  801a95:	6a 7b                	push   $0x7b
  801a97:	68 ec 4b 80 00       	push   $0x804bec
  801a9c:	e8 fb e9 ff ff       	call   80049c <_panic>
  801aa1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801aa4:	8b 50 0c             	mov    0xc(%eax),%edx
  801aa7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801aaa:	89 50 0c             	mov    %edx,0xc(%eax)
  801aad:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801ab0:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801ab3:	89 50 08             	mov    %edx,0x8(%eax)
  801ab6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ab9:	8b 40 0c             	mov    0xc(%eax),%eax
  801abc:	85 c0                	test   %eax,%eax
  801abe:	74 0e                	je     801ace <malloc+0x34b>
  801ac0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ac3:	8b 40 0c             	mov    0xc(%eax),%eax
  801ac6:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801ac9:	89 50 08             	mov    %edx,0x8(%eax)
  801acc:	eb 08                	jmp    801ad6 <malloc+0x353>
  801ace:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801ad1:	a3 20 d1 81 00       	mov    %eax,0x81d120
  801ad6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ad9:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801adc:	89 50 0c             	mov    %edx,0xc(%eax)
  801adf:	a1 2c d1 81 00       	mov    0x81d12c,%eax
  801ae4:	40                   	inc    %eax
  801ae5:	a3 2c d1 81 00       	mov    %eax,0x81d12c
                		break;
  801aea:	eb 13                	jmp    801aff <malloc+0x37c>
                	}
                	currentfree2 = currentfree2->prev_next_info.le_next;
  801aec:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801aef:	8b 40 08             	mov    0x8(%eax),%eax
  801af2:	89 45 f0             	mov    %eax,-0x10(%ebp)
                lastfreeelement->startva += size;
                lastfreeelement->size -= size;
                struct UserHeapStruct* currentfree2 = LIST_FIRST(&u_freelist);
                //check order of last element

                while (currentfree2 != NULL){
  801af5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801af9:	0f 85 e9 fe ff ff    	jne    8019e8 <malloc+0x265>
                	}
                	currentfree2 = currentfree2->prev_next_info.le_next;
                }


                sys_allocate_user_mem(allocblock->startva ,size);
  801aff:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801b02:	8b 00                	mov    (%eax),%eax
  801b04:	83 ec 08             	sub    $0x8,%esp
  801b07:	ff 75 08             	pushl  0x8(%ebp)
  801b0a:	50                   	push   %eax
  801b0b:	e8 17 1a 00 00       	call   803527 <sys_allocate_user_mem>
  801b10:	83 c4 10             	add    $0x10,%esp
                release_uspinlock(&ulock);
  801b13:	83 ec 0c             	sub    $0xc,%esp
  801b16:	68 40 d1 81 00       	push   $0x81d140
  801b1b:	e8 4f 25 00 00       	call   80406f <release_uspinlock>
  801b20:	83 c4 10             	add    $0x10,%esp
                return (void*)allocblock->startva;
  801b23:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801b26:	8b 00                	mov    (%eax),%eax
  801b28:	e9 52 01 00 00       	jmp    801c7f <malloc+0x4fc>
                //exact fit
			}else if(size == currentfreeelement->size){
  801b2d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b30:	8b 40 04             	mov    0x4(%eax),%eax
  801b33:	3b 45 08             	cmp    0x8(%ebp),%eax
  801b36:	0f 85 2b 01 00 00    	jne    801c67 <malloc+0x4e4>
				allocblock->startva = currentfreeelement->startva;
  801b3c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b3f:	8b 10                	mov    (%eax),%edx
  801b41:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801b44:	89 10                	mov    %edx,(%eax)
				allocblock->size = size;
  801b46:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801b49:	8b 55 08             	mov    0x8(%ebp),%edx
  801b4c:	89 50 04             	mov    %edx,0x4(%eax)
				LIST_INSERT_TAIL(&u_allocatedlist ,allocblock);
  801b4f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801b53:	75 17                	jne    801b6c <malloc+0x3e9>
  801b55:	83 ec 04             	sub    $0x4,%esp
  801b58:	68 38 4c 80 00       	push   $0x804c38
  801b5d:	68 89 00 00 00       	push   $0x89
  801b62:	68 ec 4b 80 00       	push   $0x804bec
  801b67:	e8 30 e9 ff ff       	call   80049c <_panic>
  801b6c:	8b 15 34 d1 81 00    	mov    0x81d134,%edx
  801b72:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801b75:	89 50 0c             	mov    %edx,0xc(%eax)
  801b78:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801b7b:	8b 40 0c             	mov    0xc(%eax),%eax
  801b7e:	85 c0                	test   %eax,%eax
  801b80:	74 0d                	je     801b8f <malloc+0x40c>
  801b82:	a1 34 d1 81 00       	mov    0x81d134,%eax
  801b87:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801b8a:	89 50 08             	mov    %edx,0x8(%eax)
  801b8d:	eb 08                	jmp    801b97 <malloc+0x414>
  801b8f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801b92:	a3 30 d1 81 00       	mov    %eax,0x81d130
  801b97:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801b9a:	a3 34 d1 81 00       	mov    %eax,0x81d134
  801b9f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801ba2:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  801ba9:	a1 3c d1 81 00       	mov    0x81d13c,%eax
  801bae:	40                   	inc    %eax
  801baf:	a3 3c d1 81 00       	mov    %eax,0x81d13c
				LIST_REMOVE(&u_freelist ,currentfreeelement);
  801bb4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801bb8:	75 17                	jne    801bd1 <malloc+0x44e>
  801bba:	83 ec 04             	sub    $0x4,%esp
  801bbd:	68 5b 4c 80 00       	push   $0x804c5b
  801bc2:	68 8a 00 00 00       	push   $0x8a
  801bc7:	68 ec 4b 80 00       	push   $0x804bec
  801bcc:	e8 cb e8 ff ff       	call   80049c <_panic>
  801bd1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bd4:	8b 40 08             	mov    0x8(%eax),%eax
  801bd7:	85 c0                	test   %eax,%eax
  801bd9:	74 11                	je     801bec <malloc+0x469>
  801bdb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bde:	8b 40 08             	mov    0x8(%eax),%eax
  801be1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801be4:	8b 52 0c             	mov    0xc(%edx),%edx
  801be7:	89 50 0c             	mov    %edx,0xc(%eax)
  801bea:	eb 0b                	jmp    801bf7 <malloc+0x474>
  801bec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bef:	8b 40 0c             	mov    0xc(%eax),%eax
  801bf2:	a3 24 d1 81 00       	mov    %eax,0x81d124
  801bf7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bfa:	8b 40 0c             	mov    0xc(%eax),%eax
  801bfd:	85 c0                	test   %eax,%eax
  801bff:	74 11                	je     801c12 <malloc+0x48f>
  801c01:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c04:	8b 40 0c             	mov    0xc(%eax),%eax
  801c07:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801c0a:	8b 52 08             	mov    0x8(%edx),%edx
  801c0d:	89 50 08             	mov    %edx,0x8(%eax)
  801c10:	eb 0b                	jmp    801c1d <malloc+0x49a>
  801c12:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c15:	8b 40 08             	mov    0x8(%eax),%eax
  801c18:	a3 20 d1 81 00       	mov    %eax,0x81d120
  801c1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c20:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  801c27:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c2a:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  801c31:	a1 2c d1 81 00       	mov    0x81d12c,%eax
  801c36:	48                   	dec    %eax
  801c37:	a3 2c d1 81 00       	mov    %eax,0x81d12c
				sys_allocate_user_mem(allocblock->startva ,size);
  801c3c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801c3f:	8b 00                	mov    (%eax),%eax
  801c41:	83 ec 08             	sub    $0x8,%esp
  801c44:	ff 75 08             	pushl  0x8(%ebp)
  801c47:	50                   	push   %eax
  801c48:	e8 da 18 00 00       	call   803527 <sys_allocate_user_mem>
  801c4d:	83 c4 10             	add    $0x10,%esp
				release_uspinlock(&ulock);
  801c50:	83 ec 0c             	sub    $0xc,%esp
  801c53:	68 40 d1 81 00       	push   $0x81d140
  801c58:	e8 12 24 00 00       	call   80406f <release_uspinlock>
  801c5d:	83 c4 10             	add    $0x10,%esp
				return (void*)allocblock->startva;
  801c60:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801c63:	8b 00                	mov    (%eax),%eax
  801c65:	eb 18                	jmp    801c7f <malloc+0x4fc>
			}
			currentfreeelement = currentfreeelement->prev_next_info.le_next;
  801c67:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c6a:	8b 40 08             	mov    0x8(%eax),%eax
  801c6d:	89 45 f4             	mov    %eax,-0xc(%ebp)
				}
	}else{
		//custom fit
		struct UserHeapStruct* currentfreeelement = LIST_FIRST(&u_freelist);
		//worst fit
		while(currentfreeelement != NULL){
  801c70:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801c74:	0f 85 bd fc ff ff    	jne    801937 <malloc+0x1b4>
				return (void*)allocblock->startva;
			}
			currentfreeelement = currentfreeelement->prev_next_info.le_next;
		}
	}
	 return NULL;
  801c7a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c7f:	c9                   	leave  
  801c80:	c3                   	ret    

00801c81 <free>:

//=================================
// [2] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
  801c81:	55                   	push   %ebp
  801c82:	89 e5                	mov    %esp,%ebp
  801c84:	83 ec 38             	sub    $0x38,%esp
	uint32  VA = ROUNDDOWN(((uint32 ) virtual_address), PAGE_SIZE);
  801c87:	8b 45 08             	mov    0x8(%ebp),%eax
  801c8a:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801c8d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801c90:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801c95:	89 45 d8             	mov    %eax,-0x28(%ebp)


		uheap_init();
  801c98:	e8 b2 f9 ff ff       	call   80164f <uheap_init>
		acquire_uspinlock(&ulock);
  801c9d:	83 ec 0c             	sub    $0xc,%esp
  801ca0:	68 40 d1 81 00       	push   $0x81d140
  801ca5:	e8 6d 23 00 00       	call   804017 <acquire_uspinlock>
  801caa:	83 c4 10             	add    $0x10,%esp
		if (VA < uheapPageAllocStart){
  801cad:	a1 10 d1 81 00       	mov    0x81d110,%eax
  801cb2:	39 45 d8             	cmp    %eax,-0x28(%ebp)
  801cb5:	73 23                	jae    801cda <free+0x59>
			free_block(virtual_address);
  801cb7:	83 ec 0c             	sub    $0xc,%esp
  801cba:	ff 75 08             	pushl  0x8(%ebp)
  801cbd:	e8 89 1f 00 00       	call   803c4b <free_block>
  801cc2:	83 c4 10             	add    $0x10,%esp
			release_uspinlock(&ulock);
  801cc5:	83 ec 0c             	sub    $0xc,%esp
  801cc8:	68 40 d1 81 00       	push   $0x81d140
  801ccd:	e8 9d 23 00 00       	call   80406f <release_uspinlock>
  801cd2:	83 c4 10             	add    $0x10,%esp
			return;
  801cd5:	e9 35 07 00 00       	jmp    80240f <free+0x78e>
		}
		if (VA >= uheapPageAllocBreak){
  801cda:	a1 68 d0 81 00       	mov    0x81d068,%eax
  801cdf:	39 45 d8             	cmp    %eax,-0x28(%ebp)
  801ce2:	72 30                	jb     801d14 <free+0x93>
			cprintf("%d\n %d\n", VA, uheapPageAllocBreak);
  801ce4:	a1 68 d0 81 00       	mov    0x81d068,%eax
  801ce9:	83 ec 04             	sub    $0x4,%esp
  801cec:	50                   	push   %eax
  801ced:	ff 75 d8             	pushl  -0x28(%ebp)
  801cf0:	68 b1 4c 80 00       	push   $0x804cb1
  801cf5:	e8 70 ea ff ff       	call   80076a <cprintf>
  801cfa:	83 c4 10             	add    $0x10,%esp

			panic("freeing from restricted area");
  801cfd:	83 ec 04             	sub    $0x4,%esp
  801d00:	68 b9 4c 80 00       	push   $0x804cb9
  801d05:	68 a7 00 00 00       	push   $0xa7
  801d0a:	68 ec 4b 80 00       	push   $0x804bec
  801d0f:	e8 88 e7 ff ff       	call   80049c <_panic>
			release_uspinlock(&ulock);
			return;
		}

		struct UserHeapStruct* newfree = (struct UserHeapStruct*) alloc_block(sizeof(struct UserHeapStruct));
  801d14:	83 ec 0c             	sub    $0xc,%esp
  801d17:	6a 10                	push   $0x10
  801d19:	e8 91 1a 00 00       	call   8037af <alloc_block>
  801d1e:	83 c4 10             	add    $0x10,%esp
  801d21:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		struct UserHeapStruct* MergedBlock  = ( struct UserHeapStruct*)alloc_block(sizeof(struct UserHeapStruct));
  801d24:	83 ec 0c             	sub    $0xc,%esp
  801d27:	6a 10                	push   $0x10
  801d29:	e8 81 1a 00 00       	call   8037af <alloc_block>
  801d2e:	83 c4 10             	add    $0x10,%esp
  801d31:	89 45 d0             	mov    %eax,-0x30(%ebp)

		struct UserHeapStruct* ToBefreed = LIST_FIRST(&u_allocatedlist);
  801d34:	a1 30 d1 81 00       	mov    0x81d130,%eax
  801d39:	89 45 f4             	mov    %eax,-0xc(%ebp)
		bool foundVA = 0;
  801d3c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

		//find the allocated block
		while(ToBefreed !=NULL ){
  801d43:	eb 1c                	jmp    801d61 <free+0xe0>

			if (VA ==ToBefreed->startva ){
  801d45:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d48:	8b 00                	mov    (%eax),%eax
  801d4a:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  801d4d:	75 09                	jne    801d58 <free+0xd7>
				foundVA = 1;
  801d4f:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
				break;
  801d56:	eb 0f                	jmp    801d67 <free+0xe6>
			}
				ToBefreed = ToBefreed->prev_next_info.le_next;
  801d58:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d5b:	8b 40 08             	mov    0x8(%eax),%eax
  801d5e:	89 45 f4             	mov    %eax,-0xc(%ebp)

		struct UserHeapStruct* ToBefreed = LIST_FIRST(&u_allocatedlist);
		bool foundVA = 0;

		//find the allocated block
		while(ToBefreed !=NULL ){
  801d61:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801d65:	75 de                	jne    801d45 <free+0xc4>
			}
				ToBefreed = ToBefreed->prev_next_info.le_next;
		}


		if(!foundVA){
  801d67:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801d6b:	75 17                	jne    801d84 <free+0x103>
				panic("INVALID ADDRESS!");
  801d6d:	83 ec 04             	sub    $0x4,%esp
  801d70:	68 d6 4c 80 00       	push   $0x804cd6
  801d75:	68 be 00 00 00       	push   $0xbe
  801d7a:	68 ec 4b 80 00       	push   $0x804bec
  801d7f:	e8 18 e7 ff ff       	call   80049c <_panic>
				release_uspinlock(&ulock);
				return;
			}


		newfree->startva = ToBefreed->startva;
  801d84:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d87:	8b 10                	mov    (%eax),%edx
  801d89:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801d8c:	89 10                	mov    %edx,(%eax)
		newfree->size = ToBefreed->size;
  801d8e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d91:	8b 50 04             	mov    0x4(%eax),%edx
  801d94:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801d97:	89 50 04             	mov    %edx,0x4(%eax)

		//remove allocated block from alloclist
		LIST_REMOVE(&u_allocatedlist, ToBefreed);
  801d9a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801d9e:	75 17                	jne    801db7 <free+0x136>
  801da0:	83 ec 04             	sub    $0x4,%esp
  801da3:	68 5b 4c 80 00       	push   $0x804c5b
  801da8:	68 c8 00 00 00       	push   $0xc8
  801dad:	68 ec 4b 80 00       	push   $0x804bec
  801db2:	e8 e5 e6 ff ff       	call   80049c <_panic>
  801db7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dba:	8b 40 08             	mov    0x8(%eax),%eax
  801dbd:	85 c0                	test   %eax,%eax
  801dbf:	74 11                	je     801dd2 <free+0x151>
  801dc1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dc4:	8b 40 08             	mov    0x8(%eax),%eax
  801dc7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801dca:	8b 52 0c             	mov    0xc(%edx),%edx
  801dcd:	89 50 0c             	mov    %edx,0xc(%eax)
  801dd0:	eb 0b                	jmp    801ddd <free+0x15c>
  801dd2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dd5:	8b 40 0c             	mov    0xc(%eax),%eax
  801dd8:	a3 34 d1 81 00       	mov    %eax,0x81d134
  801ddd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801de0:	8b 40 0c             	mov    0xc(%eax),%eax
  801de3:	85 c0                	test   %eax,%eax
  801de5:	74 11                	je     801df8 <free+0x177>
  801de7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dea:	8b 40 0c             	mov    0xc(%eax),%eax
  801ded:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801df0:	8b 52 08             	mov    0x8(%edx),%edx
  801df3:	89 50 08             	mov    %edx,0x8(%eax)
  801df6:	eb 0b                	jmp    801e03 <free+0x182>
  801df8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dfb:	8b 40 08             	mov    0x8(%eax),%eax
  801dfe:	a3 30 d1 81 00       	mov    %eax,0x81d130
  801e03:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e06:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  801e0d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e10:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  801e17:	a1 3c d1 81 00       	mov    0x81d13c,%eax
  801e1c:	48                   	dec    %eax
  801e1d:	a3 3c d1 81 00       	mov    %eax,0x81d13c

		sys_free_user_mem(ToBefreed->startva, ToBefreed->size);
  801e22:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e25:	8b 50 04             	mov    0x4(%eax),%edx
  801e28:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e2b:	8b 00                	mov    (%eax),%eax
  801e2d:	83 ec 08             	sub    $0x8,%esp
  801e30:	52                   	push   %edx
  801e31:	50                   	push   %eax
  801e32:	e8 d4 16 00 00       	call   80350b <sys_free_user_mem>
  801e37:	83 c4 10             	add    $0x10,%esp




		if(LIST_SIZE(&u_freelist) == 0){
  801e3a:	a1 2c d1 81 00       	mov    0x81d12c,%eax
  801e3f:	85 c0                	test   %eax,%eax
  801e41:	75 7a                	jne    801ebd <free+0x23c>
			LIST_INSERT_HEAD(&u_freelist,newfree);
  801e43:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  801e47:	75 17                	jne    801e60 <free+0x1df>
  801e49:	83 ec 04             	sub    $0x4,%esp
  801e4c:	68 e8 4c 80 00       	push   $0x804ce8
  801e51:	68 d0 00 00 00       	push   $0xd0
  801e56:	68 ec 4b 80 00       	push   $0x804bec
  801e5b:	e8 3c e6 ff ff       	call   80049c <_panic>
  801e60:	8b 15 20 d1 81 00    	mov    0x81d120,%edx
  801e66:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801e69:	89 50 08             	mov    %edx,0x8(%eax)
  801e6c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801e6f:	8b 40 08             	mov    0x8(%eax),%eax
  801e72:	85 c0                	test   %eax,%eax
  801e74:	74 0d                	je     801e83 <free+0x202>
  801e76:	a1 20 d1 81 00       	mov    0x81d120,%eax
  801e7b:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  801e7e:	89 50 0c             	mov    %edx,0xc(%eax)
  801e81:	eb 08                	jmp    801e8b <free+0x20a>
  801e83:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801e86:	a3 24 d1 81 00       	mov    %eax,0x81d124
  801e8b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801e8e:	a3 20 d1 81 00       	mov    %eax,0x81d120
  801e93:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801e96:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  801e9d:	a1 2c d1 81 00       	mov    0x81d12c,%eax
  801ea2:	40                   	inc    %eax
  801ea3:	a3 2c d1 81 00       	mov    %eax,0x81d12c
			release_uspinlock(&ulock);
  801ea8:	83 ec 0c             	sub    $0xc,%esp
  801eab:	68 40 d1 81 00       	push   $0x81d140
  801eb0:	e8 ba 21 00 00       	call   80406f <release_uspinlock>
  801eb5:	83 c4 10             	add    $0x10,%esp
			return;
  801eb8:	e9 52 05 00 00       	jmp    80240f <free+0x78e>
		}


		struct UserHeapStruct* ToBeMerged = LIST_FIRST(&u_freelist);
  801ebd:	a1 20 d1 81 00       	mov    0x81d120,%eax
  801ec2:	89 45 ec             	mov    %eax,-0x14(%ebp)
		// merge with prev if possible
		bool mergeprev = 0;
  801ec5:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		bool mergenext = 0;
  801ecc:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
		while(ToBeMerged != NULL){
  801ed3:	e9 d2 00 00 00       	jmp    801faa <free+0x329>
			if((ToBeMerged->startva +ToBeMerged->size) == newfree->startva){
  801ed8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801edb:	8b 10                	mov    (%eax),%edx
  801edd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801ee0:	8b 40 04             	mov    0x4(%eax),%eax
  801ee3:	01 c2                	add    %eax,%edx
  801ee5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801ee8:	8b 00                	mov    (%eax),%eax
  801eea:	39 c2                	cmp    %eax,%edx
  801eec:	0f 85 af 00 00 00    	jne    801fa1 <free+0x320>

				MergedBlock->startva = ToBeMerged->startva;
  801ef2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801ef5:	8b 10                	mov    (%eax),%edx
  801ef7:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801efa:	89 10                	mov    %edx,(%eax)
				MergedBlock->size = ToBeMerged->size + newfree->size;
  801efc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801eff:	8b 50 04             	mov    0x4(%eax),%edx
  801f02:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801f05:	8b 40 04             	mov    0x4(%eax),%eax
  801f08:	01 c2                	add    %eax,%edx
  801f0a:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801f0d:	89 50 04             	mov    %edx,0x4(%eax)
				LIST_REMOVE(&u_freelist, ToBeMerged);
  801f10:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801f14:	75 17                	jne    801f2d <free+0x2ac>
  801f16:	83 ec 04             	sub    $0x4,%esp
  801f19:	68 5b 4c 80 00       	push   $0x804c5b
  801f1e:	68 df 00 00 00       	push   $0xdf
  801f23:	68 ec 4b 80 00       	push   $0x804bec
  801f28:	e8 6f e5 ff ff       	call   80049c <_panic>
  801f2d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f30:	8b 40 08             	mov    0x8(%eax),%eax
  801f33:	85 c0                	test   %eax,%eax
  801f35:	74 11                	je     801f48 <free+0x2c7>
  801f37:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f3a:	8b 40 08             	mov    0x8(%eax),%eax
  801f3d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801f40:	8b 52 0c             	mov    0xc(%edx),%edx
  801f43:	89 50 0c             	mov    %edx,0xc(%eax)
  801f46:	eb 0b                	jmp    801f53 <free+0x2d2>
  801f48:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f4b:	8b 40 0c             	mov    0xc(%eax),%eax
  801f4e:	a3 24 d1 81 00       	mov    %eax,0x81d124
  801f53:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f56:	8b 40 0c             	mov    0xc(%eax),%eax
  801f59:	85 c0                	test   %eax,%eax
  801f5b:	74 11                	je     801f6e <free+0x2ed>
  801f5d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f60:	8b 40 0c             	mov    0xc(%eax),%eax
  801f63:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801f66:	8b 52 08             	mov    0x8(%edx),%edx
  801f69:	89 50 08             	mov    %edx,0x8(%eax)
  801f6c:	eb 0b                	jmp    801f79 <free+0x2f8>
  801f6e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f71:	8b 40 08             	mov    0x8(%eax),%eax
  801f74:	a3 20 d1 81 00       	mov    %eax,0x81d120
  801f79:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f7c:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  801f83:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f86:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  801f8d:	a1 2c d1 81 00       	mov    0x81d12c,%eax
  801f92:	48                   	dec    %eax
  801f93:	a3 2c d1 81 00       	mov    %eax,0x81d12c
				mergeprev = 1;
  801f98:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
				break;
  801f9f:	eb 13                	jmp    801fb4 <free+0x333>
			}
				ToBeMerged = ToBeMerged->prev_next_info.le_next;
  801fa1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801fa4:	8b 40 08             	mov    0x8(%eax),%eax
  801fa7:	89 45 ec             	mov    %eax,-0x14(%ebp)

		struct UserHeapStruct* ToBeMerged = LIST_FIRST(&u_freelist);
		// merge with prev if possible
		bool mergeprev = 0;
		bool mergenext = 0;
		while(ToBeMerged != NULL){
  801faa:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801fae:	0f 85 24 ff ff ff    	jne    801ed8 <free+0x257>
//									uheapPageAllocBreak = newfree->startva;
//						}
//					}


		if ( newfree ->startva + newfree->size == uheapPageAllocBreak){
  801fb4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801fb7:	8b 10                	mov    (%eax),%edx
  801fb9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801fbc:	8b 40 04             	mov    0x4(%eax),%eax
  801fbf:	01 c2                	add    %eax,%edx
  801fc1:	a1 68 d0 81 00       	mov    0x81d068,%eax
  801fc6:	39 c2                	cmp    %eax,%edx
  801fc8:	75 44                	jne    80200e <free+0x38d>

			if(mergeprev){
  801fca:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  801fce:	74 1f                	je     801fef <free+0x36e>
				uheapPageAllocBreak = MergedBlock->startva;
  801fd0:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801fd3:	8b 00                	mov    (%eax),%eax
  801fd5:	a3 68 d0 81 00       	mov    %eax,0x81d068
				release_uspinlock(&ulock);
  801fda:	83 ec 0c             	sub    $0xc,%esp
  801fdd:	68 40 d1 81 00       	push   $0x81d140
  801fe2:	e8 88 20 00 00       	call   80406f <release_uspinlock>
  801fe7:	83 c4 10             	add    $0x10,%esp
				return;
  801fea:	e9 20 04 00 00       	jmp    80240f <free+0x78e>

			}else{
				uheapPageAllocBreak = newfree->startva;
  801fef:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801ff2:	8b 00                	mov    (%eax),%eax
  801ff4:	a3 68 d0 81 00       	mov    %eax,0x81d068
				release_uspinlock(&ulock);
  801ff9:	83 ec 0c             	sub    $0xc,%esp
  801ffc:	68 40 d1 81 00       	push   $0x81d140
  802001:	e8 69 20 00 00       	call   80406f <release_uspinlock>
  802006:	83 c4 10             	add    $0x10,%esp
				return;
  802009:	e9 01 04 00 00       	jmp    80240f <free+0x78e>

		}


		//check if block is merged with prev ,and find possible merge with next
		ToBeMerged = LIST_FIRST(&u_freelist);
  80200e:	a1 20 d1 81 00       	mov    0x81d120,%eax
  802013:	89 45 ec             	mov    %eax,-0x14(%ebp)
		while(ToBeMerged != NULL){
  802016:	e9 7d 01 00 00       	jmp    802198 <free+0x517>
			if ((newfree->startva + newfree->size) == ToBeMerged->startva ){
  80201b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80201e:	8b 10                	mov    (%eax),%edx
  802020:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802023:	8b 40 04             	mov    0x4(%eax),%eax
  802026:	01 c2                	add    %eax,%edx
  802028:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80202b:	8b 00                	mov    (%eax),%eax
  80202d:	39 c2                	cmp    %eax,%edx
  80202f:	0f 85 5a 01 00 00    	jne    80218f <free+0x50e>
				if (mergeprev){
  802035:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802039:	0f 84 a1 00 00 00    	je     8020e0 <free+0x45f>
					MergedBlock->size += ToBeMerged->size;
  80203f:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802042:	8b 50 04             	mov    0x4(%eax),%edx
  802045:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802048:	8b 40 04             	mov    0x4(%eax),%eax
  80204b:	01 c2                	add    %eax,%edx
  80204d:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802050:	89 50 04             	mov    %edx,0x4(%eax)
					LIST_REMOVE(&u_freelist, ToBeMerged);
  802053:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802057:	75 17                	jne    802070 <free+0x3ef>
  802059:	83 ec 04             	sub    $0x4,%esp
  80205c:	68 5b 4c 80 00       	push   $0x804c5b
  802061:	68 0a 01 00 00       	push   $0x10a
  802066:	68 ec 4b 80 00       	push   $0x804bec
  80206b:	e8 2c e4 ff ff       	call   80049c <_panic>
  802070:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802073:	8b 40 08             	mov    0x8(%eax),%eax
  802076:	85 c0                	test   %eax,%eax
  802078:	74 11                	je     80208b <free+0x40a>
  80207a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80207d:	8b 40 08             	mov    0x8(%eax),%eax
  802080:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802083:	8b 52 0c             	mov    0xc(%edx),%edx
  802086:	89 50 0c             	mov    %edx,0xc(%eax)
  802089:	eb 0b                	jmp    802096 <free+0x415>
  80208b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80208e:	8b 40 0c             	mov    0xc(%eax),%eax
  802091:	a3 24 d1 81 00       	mov    %eax,0x81d124
  802096:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802099:	8b 40 0c             	mov    0xc(%eax),%eax
  80209c:	85 c0                	test   %eax,%eax
  80209e:	74 11                	je     8020b1 <free+0x430>
  8020a0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8020a3:	8b 40 0c             	mov    0xc(%eax),%eax
  8020a6:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8020a9:	8b 52 08             	mov    0x8(%edx),%edx
  8020ac:	89 50 08             	mov    %edx,0x8(%eax)
  8020af:	eb 0b                	jmp    8020bc <free+0x43b>
  8020b1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8020b4:	8b 40 08             	mov    0x8(%eax),%eax
  8020b7:	a3 20 d1 81 00       	mov    %eax,0x81d120
  8020bc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8020bf:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  8020c6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8020c9:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  8020d0:	a1 2c d1 81 00       	mov    0x81d12c,%eax
  8020d5:	48                   	dec    %eax
  8020d6:	a3 2c d1 81 00       	mov    %eax,0x81d12c
					break;
  8020db:	e9 c2 00 00 00       	jmp    8021a2 <free+0x521>
		//if not merged find possible merge with next
				}else{
					MergedBlock->startva = newfree->startva;
  8020e0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8020e3:	8b 10                	mov    (%eax),%edx
  8020e5:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8020e8:	89 10                	mov    %edx,(%eax)
					MergedBlock->size  = newfree->size + ToBeMerged->size;
  8020ea:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8020ed:	8b 50 04             	mov    0x4(%eax),%edx
  8020f0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8020f3:	8b 40 04             	mov    0x4(%eax),%eax
  8020f6:	01 c2                	add    %eax,%edx
  8020f8:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8020fb:	89 50 04             	mov    %edx,0x4(%eax)
					LIST_REMOVE(&u_freelist, ToBeMerged);
  8020fe:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802102:	75 17                	jne    80211b <free+0x49a>
  802104:	83 ec 04             	sub    $0x4,%esp
  802107:	68 5b 4c 80 00       	push   $0x804c5b
  80210c:	68 10 01 00 00       	push   $0x110
  802111:	68 ec 4b 80 00       	push   $0x804bec
  802116:	e8 81 e3 ff ff       	call   80049c <_panic>
  80211b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80211e:	8b 40 08             	mov    0x8(%eax),%eax
  802121:	85 c0                	test   %eax,%eax
  802123:	74 11                	je     802136 <free+0x4b5>
  802125:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802128:	8b 40 08             	mov    0x8(%eax),%eax
  80212b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80212e:	8b 52 0c             	mov    0xc(%edx),%edx
  802131:	89 50 0c             	mov    %edx,0xc(%eax)
  802134:	eb 0b                	jmp    802141 <free+0x4c0>
  802136:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802139:	8b 40 0c             	mov    0xc(%eax),%eax
  80213c:	a3 24 d1 81 00       	mov    %eax,0x81d124
  802141:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802144:	8b 40 0c             	mov    0xc(%eax),%eax
  802147:	85 c0                	test   %eax,%eax
  802149:	74 11                	je     80215c <free+0x4db>
  80214b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80214e:	8b 40 0c             	mov    0xc(%eax),%eax
  802151:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802154:	8b 52 08             	mov    0x8(%edx),%edx
  802157:	89 50 08             	mov    %edx,0x8(%eax)
  80215a:	eb 0b                	jmp    802167 <free+0x4e6>
  80215c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80215f:	8b 40 08             	mov    0x8(%eax),%eax
  802162:	a3 20 d1 81 00       	mov    %eax,0x81d120
  802167:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80216a:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802171:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802174:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  80217b:	a1 2c d1 81 00       	mov    0x81d12c,%eax
  802180:	48                   	dec    %eax
  802181:	a3 2c d1 81 00       	mov    %eax,0x81d12c
					mergenext = 1;
  802186:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
					break;
  80218d:	eb 13                	jmp    8021a2 <free+0x521>
				}
			}
			ToBeMerged = ToBeMerged->prev_next_info.le_next;
  80218f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802192:	8b 40 08             	mov    0x8(%eax),%eax
  802195:	89 45 ec             	mov    %eax,-0x14(%ebp)
		}


		//check if block is merged with prev ,and find possible merge with next
		ToBeMerged = LIST_FIRST(&u_freelist);
		while(ToBeMerged != NULL){
  802198:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80219c:	0f 85 79 fe ff ff    	jne    80201b <free+0x39a>




			// insertion
			struct UserHeapStruct* currentfree = LIST_FIRST(&u_freelist);
  8021a2:	a1 20 d1 81 00       	mov    0x81d120,%eax
  8021a7:	89 45 e0             	mov    %eax,-0x20(%ebp)

			if(mergeprev || mergenext){
  8021aa:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8021ae:	0f 85 ad 00 00 00    	jne    802261 <free+0x5e0>
  8021b4:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8021b8:	0f 84 c3 01 00 00    	je     802381 <free+0x700>
				while(currentfree != NULL){
  8021be:	e9 9e 00 00 00       	jmp    802261 <free+0x5e0>
					if(MergedBlock->size < currentfree->size){
  8021c3:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8021c6:	8b 50 04             	mov    0x4(%eax),%edx
  8021c9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8021cc:	8b 40 04             	mov    0x4(%eax),%eax
  8021cf:	39 c2                	cmp    %eax,%edx
  8021d1:	0f 83 81 00 00 00    	jae    802258 <free+0x5d7>

							LIST_INSERT_BEFORE(&u_freelist,currentfree,MergedBlock);
  8021d7:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8021db:	74 06                	je     8021e3 <free+0x562>
  8021dd:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  8021e1:	75 17                	jne    8021fa <free+0x579>
  8021e3:	83 ec 04             	sub    $0x4,%esp
  8021e6:	68 7c 4c 80 00       	push   $0x804c7c
  8021eb:	68 23 01 00 00       	push   $0x123
  8021f0:	68 ec 4b 80 00       	push   $0x804bec
  8021f5:	e8 a2 e2 ff ff       	call   80049c <_panic>
  8021fa:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8021fd:	8b 50 0c             	mov    0xc(%eax),%edx
  802200:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802203:	89 50 0c             	mov    %edx,0xc(%eax)
  802206:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802209:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80220c:	89 50 08             	mov    %edx,0x8(%eax)
  80220f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802212:	8b 40 0c             	mov    0xc(%eax),%eax
  802215:	85 c0                	test   %eax,%eax
  802217:	74 0e                	je     802227 <free+0x5a6>
  802219:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80221c:	8b 40 0c             	mov    0xc(%eax),%eax
  80221f:	8b 55 d0             	mov    -0x30(%ebp),%edx
  802222:	89 50 08             	mov    %edx,0x8(%eax)
  802225:	eb 08                	jmp    80222f <free+0x5ae>
  802227:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80222a:	a3 20 d1 81 00       	mov    %eax,0x81d120
  80222f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802232:	8b 55 d0             	mov    -0x30(%ebp),%edx
  802235:	89 50 0c             	mov    %edx,0xc(%eax)
  802238:	a1 2c d1 81 00       	mov    0x81d12c,%eax
  80223d:	40                   	inc    %eax
  80223e:	a3 2c d1 81 00       	mov    %eax,0x81d12c
							release_uspinlock(&ulock);
  802243:	83 ec 0c             	sub    $0xc,%esp
  802246:	68 40 d1 81 00       	push   $0x81d140
  80224b:	e8 1f 1e 00 00       	call   80406f <release_uspinlock>
  802250:	83 c4 10             	add    $0x10,%esp
							return;
  802253:	e9 b7 01 00 00       	jmp    80240f <free+0x78e>
					}
							currentfree = currentfree->prev_next_info.le_next;
  802258:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80225b:	8b 40 08             	mov    0x8(%eax),%eax
  80225e:	89 45 e0             	mov    %eax,-0x20(%ebp)

			// insertion
			struct UserHeapStruct* currentfree = LIST_FIRST(&u_freelist);

			if(mergeprev || mergenext){
				while(currentfree != NULL){
  802261:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802265:	0f 85 58 ff ff ff    	jne    8021c3 <free+0x542>
							release_uspinlock(&ulock);
							return;
					}
							currentfree = currentfree->prev_next_info.le_next;
				}
				free_block(newfree);
  80226b:	83 ec 0c             	sub    $0xc,%esp
  80226e:	ff 75 d4             	pushl  -0x2c(%ebp)
  802271:	e8 d5 19 00 00       	call   803c4b <free_block>
  802276:	83 c4 10             	add    $0x10,%esp
				LIST_INSERT_TAIL(&u_freelist,MergedBlock);
  802279:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  80227d:	75 17                	jne    802296 <free+0x615>
  80227f:	83 ec 04             	sub    $0x4,%esp
  802282:	68 38 4c 80 00       	push   $0x804c38
  802287:	68 2a 01 00 00       	push   $0x12a
  80228c:	68 ec 4b 80 00       	push   $0x804bec
  802291:	e8 06 e2 ff ff       	call   80049c <_panic>
  802296:	8b 15 24 d1 81 00    	mov    0x81d124,%edx
  80229c:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80229f:	89 50 0c             	mov    %edx,0xc(%eax)
  8022a2:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8022a5:	8b 40 0c             	mov    0xc(%eax),%eax
  8022a8:	85 c0                	test   %eax,%eax
  8022aa:	74 0d                	je     8022b9 <free+0x638>
  8022ac:	a1 24 d1 81 00       	mov    0x81d124,%eax
  8022b1:	8b 55 d0             	mov    -0x30(%ebp),%edx
  8022b4:	89 50 08             	mov    %edx,0x8(%eax)
  8022b7:	eb 08                	jmp    8022c1 <free+0x640>
  8022b9:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8022bc:	a3 20 d1 81 00       	mov    %eax,0x81d120
  8022c1:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8022c4:	a3 24 d1 81 00       	mov    %eax,0x81d124
  8022c9:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8022cc:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  8022d3:	a1 2c d1 81 00       	mov    0x81d12c,%eax
  8022d8:	40                   	inc    %eax
  8022d9:	a3 2c d1 81 00       	mov    %eax,0x81d12c
  8022de:	e9 1b 01 00 00       	jmp    8023fe <free+0x77d>

			}else{
				while(currentfree != NULL){
					if(newfree->size < currentfree->size){
  8022e3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8022e6:	8b 50 04             	mov    0x4(%eax),%edx
  8022e9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8022ec:	8b 40 04             	mov    0x4(%eax),%eax
  8022ef:	39 c2                	cmp    %eax,%edx
  8022f1:	0f 83 81 00 00 00    	jae    802378 <free+0x6f7>

							LIST_INSERT_BEFORE(&u_freelist,currentfree,newfree);
  8022f7:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8022fb:	74 06                	je     802303 <free+0x682>
  8022fd:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  802301:	75 17                	jne    80231a <free+0x699>
  802303:	83 ec 04             	sub    $0x4,%esp
  802306:	68 7c 4c 80 00       	push   $0x804c7c
  80230b:	68 30 01 00 00       	push   $0x130
  802310:	68 ec 4b 80 00       	push   $0x804bec
  802315:	e8 82 e1 ff ff       	call   80049c <_panic>
  80231a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80231d:	8b 50 0c             	mov    0xc(%eax),%edx
  802320:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802323:	89 50 0c             	mov    %edx,0xc(%eax)
  802326:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802329:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80232c:	89 50 08             	mov    %edx,0x8(%eax)
  80232f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802332:	8b 40 0c             	mov    0xc(%eax),%eax
  802335:	85 c0                	test   %eax,%eax
  802337:	74 0e                	je     802347 <free+0x6c6>
  802339:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80233c:	8b 40 0c             	mov    0xc(%eax),%eax
  80233f:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802342:	89 50 08             	mov    %edx,0x8(%eax)
  802345:	eb 08                	jmp    80234f <free+0x6ce>
  802347:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80234a:	a3 20 d1 81 00       	mov    %eax,0x81d120
  80234f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802352:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802355:	89 50 0c             	mov    %edx,0xc(%eax)
  802358:	a1 2c d1 81 00       	mov    0x81d12c,%eax
  80235d:	40                   	inc    %eax
  80235e:	a3 2c d1 81 00       	mov    %eax,0x81d12c
							release_uspinlock(&ulock);
  802363:	83 ec 0c             	sub    $0xc,%esp
  802366:	68 40 d1 81 00       	push   $0x81d140
  80236b:	e8 ff 1c 00 00       	call   80406f <release_uspinlock>
  802370:	83 c4 10             	add    $0x10,%esp
							return;
  802373:	e9 97 00 00 00       	jmp    80240f <free+0x78e>
					}
							currentfree = currentfree->prev_next_info.le_next;
  802378:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80237b:	8b 40 08             	mov    0x8(%eax),%eax
  80237e:	89 45 e0             	mov    %eax,-0x20(%ebp)
				}
				free_block(newfree);
				LIST_INSERT_TAIL(&u_freelist,MergedBlock);

			}else{
				while(currentfree != NULL){
  802381:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802385:	0f 85 58 ff ff ff    	jne    8022e3 <free+0x662>
							release_uspinlock(&ulock);
							return;
					}
							currentfree = currentfree->prev_next_info.le_next;
				}
				free_block(MergedBlock);
  80238b:	83 ec 0c             	sub    $0xc,%esp
  80238e:	ff 75 d0             	pushl  -0x30(%ebp)
  802391:	e8 b5 18 00 00       	call   803c4b <free_block>
  802396:	83 c4 10             	add    $0x10,%esp
				LIST_INSERT_TAIL(&u_freelist,newfree);
  802399:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80239d:	75 17                	jne    8023b6 <free+0x735>
  80239f:	83 ec 04             	sub    $0x4,%esp
  8023a2:	68 38 4c 80 00       	push   $0x804c38
  8023a7:	68 37 01 00 00       	push   $0x137
  8023ac:	68 ec 4b 80 00       	push   $0x804bec
  8023b1:	e8 e6 e0 ff ff       	call   80049c <_panic>
  8023b6:	8b 15 24 d1 81 00    	mov    0x81d124,%edx
  8023bc:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8023bf:	89 50 0c             	mov    %edx,0xc(%eax)
  8023c2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8023c5:	8b 40 0c             	mov    0xc(%eax),%eax
  8023c8:	85 c0                	test   %eax,%eax
  8023ca:	74 0d                	je     8023d9 <free+0x758>
  8023cc:	a1 24 d1 81 00       	mov    0x81d124,%eax
  8023d1:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8023d4:	89 50 08             	mov    %edx,0x8(%eax)
  8023d7:	eb 08                	jmp    8023e1 <free+0x760>
  8023d9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8023dc:	a3 20 d1 81 00       	mov    %eax,0x81d120
  8023e1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8023e4:	a3 24 d1 81 00       	mov    %eax,0x81d124
  8023e9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8023ec:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  8023f3:	a1 2c d1 81 00       	mov    0x81d12c,%eax
  8023f8:	40                   	inc    %eax
  8023f9:	a3 2c d1 81 00       	mov    %eax,0x81d12c
			}
		release_uspinlock(&ulock);
  8023fe:	83 ec 0c             	sub    $0xc,%esp
  802401:	68 40 d1 81 00       	push   $0x81d140
  802406:	e8 64 1c 00 00       	call   80406f <release_uspinlock>
  80240b:	83 c4 10             	add    $0x10,%esp
		return;
  80240e:	90                   	nop
}
  80240f:	c9                   	leave  
  802410:	c3                   	ret    

00802411 <smalloc>:

//=================================
// [3] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  802411:	55                   	push   %ebp
  802412:	89 e5                	mov    %esp,%ebp
  802414:	83 ec 48             	sub    $0x48,%esp
  802417:	8b 45 10             	mov    0x10(%ebp),%eax
  80241a:	88 45 c4             	mov    %al,-0x3c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  80241d:	e8 2d f2 ff ff       	call   80164f <uheap_init>
	if (size == 0) return NULL;
  802422:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802426:	75 0a                	jne    802432 <smalloc+0x21>
  802428:	b8 00 00 00 00       	mov    $0x0,%eax
  80242d:	e9 84 05 00 00       	jmp    8029b6 <smalloc+0x5a5>
	//==============================================================
	acquire_uspinlock(&ulock);
  802432:	83 ec 0c             	sub    $0xc,%esp
  802435:	68 40 d1 81 00       	push   $0x81d140
  80243a:	e8 d8 1b 00 00       	call   804017 <acquire_uspinlock>
  80243f:	83 c4 10             	add    $0x10,%esp

	struct UserHeapStruct* allocblock = (struct UserHeapStruct*) alloc_block(sizeof(struct UserHeapStruct));
  802442:	83 ec 0c             	sub    $0xc,%esp
  802445:	6a 10                	push   $0x10
  802447:	e8 63 13 00 00       	call   8037af <alloc_block>
  80244c:	83 c4 10             	add    $0x10,%esp
  80244f:	89 45 ec             	mov    %eax,-0x14(%ebp)
	if (allocblock == NULL){
  802452:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802456:	75 0a                	jne    802462 <smalloc+0x51>
				return NULL;
  802458:	b8 00 00 00 00       	mov    $0x0,%eax
  80245d:	e9 54 05 00 00       	jmp    8029b6 <smalloc+0x5a5>
	}
		size = ROUNDUP(size,PAGE_SIZE);
  802462:	c7 45 e8 00 10 00 00 	movl   $0x1000,-0x18(%ebp)
  802469:	8b 55 0c             	mov    0xc(%ebp),%edx
  80246c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80246f:	01 d0                	add    %edx,%eax
  802471:	48                   	dec    %eax
  802472:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  802475:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802478:	ba 00 00 00 00       	mov    $0x0,%edx
  80247d:	f7 75 e8             	divl   -0x18(%ebp)
  802480:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802483:	29 d0                	sub    %edx,%eax
  802485:	89 45 0c             	mov    %eax,0xc(%ebp)
		struct UserHeapStruct* lastfreeelement = LIST_LAST(&u_freelist);
  802488:	a1 24 d1 81 00       	mov    0x81d124,%eax
  80248d:	89 45 e0             	mov    %eax,-0x20(%ebp)

		if(LIST_SIZE(&u_freelist)==0 || size>lastfreeelement->size){
  802490:	a1 2c d1 81 00       	mov    0x81d12c,%eax
  802495:	85 c0                	test   %eax,%eax
  802497:	74 0f                	je     8024a8 <smalloc+0x97>
  802499:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80249c:	8b 40 04             	mov    0x4(%eax),%eax
  80249f:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8024a2:	0f 83 25 01 00 00    	jae    8025cd <smalloc+0x1bc>
				if(uheapPageAllocBreak <= USER_HEAP_MAX - size){
  8024a8:	b8 00 00 00 a0       	mov    $0xa0000000,%eax
  8024ad:	2b 45 0c             	sub    0xc(%ebp),%eax
  8024b0:	89 c2                	mov    %eax,%edx
  8024b2:	a1 68 d0 81 00       	mov    0x81d068,%eax
  8024b7:	39 c2                	cmp    %eax,%edx
  8024b9:	0f 82 f4 00 00 00    	jb     8025b3 <smalloc+0x1a2>
						uint32 requestedblockva = uheapPageAllocBreak;
  8024bf:	a1 68 d0 81 00       	mov    0x81d068,%eax
  8024c4:	89 45 d4             	mov    %eax,-0x2c(%ebp)
						uheapPageAllocBreak+=size;
  8024c7:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  8024cd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8024d0:	01 d0                	add    %edx,%eax
  8024d2:	a3 68 d0 81 00       	mov    %eax,0x81d068
						allocblock->startva = requestedblockva;
  8024d7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8024da:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8024dd:	89 10                	mov    %edx,(%eax)
						allocblock->size = size;
  8024df:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8024e2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8024e5:	89 50 04             	mov    %edx,0x4(%eax)

						LIST_INSERT_TAIL(&u_allocatedlist, allocblock);
  8024e8:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8024ec:	75 17                	jne    802505 <smalloc+0xf4>
  8024ee:	83 ec 04             	sub    $0x4,%esp
  8024f1:	68 38 4c 80 00       	push   $0x804c38
  8024f6:	68 57 01 00 00       	push   $0x157
  8024fb:	68 ec 4b 80 00       	push   $0x804bec
  802500:	e8 97 df ff ff       	call   80049c <_panic>
  802505:	8b 15 34 d1 81 00    	mov    0x81d134,%edx
  80250b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80250e:	89 50 0c             	mov    %edx,0xc(%eax)
  802511:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802514:	8b 40 0c             	mov    0xc(%eax),%eax
  802517:	85 c0                	test   %eax,%eax
  802519:	74 0d                	je     802528 <smalloc+0x117>
  80251b:	a1 34 d1 81 00       	mov    0x81d134,%eax
  802520:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802523:	89 50 08             	mov    %edx,0x8(%eax)
  802526:	eb 08                	jmp    802530 <smalloc+0x11f>
  802528:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80252b:	a3 30 d1 81 00       	mov    %eax,0x81d130
  802530:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802533:	a3 34 d1 81 00       	mov    %eax,0x81d134
  802538:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80253b:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802542:	a1 3c d1 81 00       	mov    0x81d13c,%eax
  802547:	40                   	inc    %eax
  802548:	a3 3c d1 81 00       	mov    %eax,0x81d13c


						int result = sys_create_shared_object(sharedVarName ,size ,isWritable ,(void*)allocblock->startva);
  80254d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802550:	8b 00                	mov    (%eax),%eax
  802552:	89 c2                	mov    %eax,%edx
  802554:	0f b6 45 c4          	movzbl -0x3c(%ebp),%eax
  802558:	52                   	push   %edx
  802559:	50                   	push   %eax
  80255a:	ff 75 0c             	pushl  0xc(%ebp)
  80255d:	ff 75 08             	pushl  0x8(%ebp)
  802560:	e8 48 0c 00 00       	call   8031ad <sys_create_shared_object>
  802565:	83 c4 10             	add    $0x10,%esp
  802568:	89 45 d0             	mov    %eax,-0x30(%ebp)

						if(result <0){
  80256b:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  80256f:	79 28                	jns    802599 <smalloc+0x188>
							free_block(allocblock);
  802571:	83 ec 0c             	sub    $0xc,%esp
  802574:	ff 75 ec             	pushl  -0x14(%ebp)
  802577:	e8 cf 16 00 00       	call   803c4b <free_block>
  80257c:	83 c4 10             	add    $0x10,%esp
							release_uspinlock(&ulock);
  80257f:	83 ec 0c             	sub    $0xc,%esp
  802582:	68 40 d1 81 00       	push   $0x81d140
  802587:	e8 e3 1a 00 00       	call   80406f <release_uspinlock>
  80258c:	83 c4 10             	add    $0x10,%esp
							return NULL;
  80258f:	b8 00 00 00 00       	mov    $0x0,%eax
  802594:	e9 1d 04 00 00       	jmp    8029b6 <smalloc+0x5a5>
						}
						release_uspinlock(&ulock);
  802599:	83 ec 0c             	sub    $0xc,%esp
  80259c:	68 40 d1 81 00       	push   $0x81d140
  8025a1:	e8 c9 1a 00 00       	call   80406f <release_uspinlock>
  8025a6:	83 c4 10             	add    $0x10,%esp
						return (void*)allocblock -> startva;
  8025a9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025ac:	8b 00                	mov    (%eax),%eax
  8025ae:	e9 03 04 00 00       	jmp    8029b6 <smalloc+0x5a5>
				}else{
						release_uspinlock(&ulock);
  8025b3:	83 ec 0c             	sub    $0xc,%esp
  8025b6:	68 40 d1 81 00       	push   $0x81d140
  8025bb:	e8 af 1a 00 00       	call   80406f <release_uspinlock>
  8025c0:	83 c4 10             	add    $0x10,%esp
						return NULL;
  8025c3:	b8 00 00 00 00       	mov    $0x0,%eax
  8025c8:	e9 e9 03 00 00       	jmp    8029b6 <smalloc+0x5a5>
					 }
		}else{
			//custom fit
			struct UserHeapStruct* currentfreeelement = LIST_FIRST(&u_freelist);
  8025cd:	a1 20 d1 81 00       	mov    0x81d120,%eax
  8025d2:	89 45 f4             	mov    %eax,-0xc(%ebp)
			//worst fit
			while(currentfreeelement != NULL){
  8025d5:	e9 af 03 00 00       	jmp    802989 <smalloc+0x578>
				if(size<currentfreeelement->size){
  8025da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025dd:	8b 40 04             	mov    0x4(%eax),%eax
  8025e0:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8025e3:	0f 86 28 02 00 00    	jbe    802811 <smalloc+0x400>
					allocblock->startva = lastfreeelement->startva;
  8025e9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8025ec:	8b 10                	mov    (%eax),%edx
  8025ee:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025f1:	89 10                	mov    %edx,(%eax)
	                allocblock->size = size;
  8025f3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025f6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8025f9:	89 50 04             	mov    %edx,0x4(%eax)
	                LIST_INSERT_TAIL(&u_allocatedlist,allocblock);
  8025fc:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802600:	75 17                	jne    802619 <smalloc+0x208>
  802602:	83 ec 04             	sub    $0x4,%esp
  802605:	68 38 4c 80 00       	push   $0x804c38
  80260a:	68 6f 01 00 00       	push   $0x16f
  80260f:	68 ec 4b 80 00       	push   $0x804bec
  802614:	e8 83 de ff ff       	call   80049c <_panic>
  802619:	8b 15 34 d1 81 00    	mov    0x81d134,%edx
  80261f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802622:	89 50 0c             	mov    %edx,0xc(%eax)
  802625:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802628:	8b 40 0c             	mov    0xc(%eax),%eax
  80262b:	85 c0                	test   %eax,%eax
  80262d:	74 0d                	je     80263c <smalloc+0x22b>
  80262f:	a1 34 d1 81 00       	mov    0x81d134,%eax
  802634:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802637:	89 50 08             	mov    %edx,0x8(%eax)
  80263a:	eb 08                	jmp    802644 <smalloc+0x233>
  80263c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80263f:	a3 30 d1 81 00       	mov    %eax,0x81d130
  802644:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802647:	a3 34 d1 81 00       	mov    %eax,0x81d134
  80264c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80264f:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802656:	a1 3c d1 81 00       	mov    0x81d13c,%eax
  80265b:	40                   	inc    %eax
  80265c:	a3 3c d1 81 00       	mov    %eax,0x81d13c
	                lastfreeelement->startva += size;
  802661:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802664:	8b 10                	mov    (%eax),%edx
  802666:	8b 45 0c             	mov    0xc(%ebp),%eax
  802669:	01 c2                	add    %eax,%edx
  80266b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80266e:	89 10                	mov    %edx,(%eax)
	                lastfreeelement->size -= size;
  802670:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802673:	8b 40 04             	mov    0x4(%eax),%eax
  802676:	2b 45 0c             	sub    0xc(%ebp),%eax
  802679:	89 c2                	mov    %eax,%edx
  80267b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80267e:	89 50 04             	mov    %edx,0x4(%eax)
	                struct UserHeapStruct* currentfree2 = LIST_FIRST(&u_freelist);
  802681:	a1 20 d1 81 00       	mov    0x81d120,%eax
  802686:	89 45 f0             	mov    %eax,-0x10(%ebp)
	                //check order of last element

	                while (currentfree2 != NULL){
  802689:	e9 13 01 00 00       	jmp    8027a1 <smalloc+0x390>
	                	if(lastfreeelement->size <currentfree2->size){
  80268e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802691:	8b 50 04             	mov    0x4(%eax),%edx
  802694:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802697:	8b 40 04             	mov    0x4(%eax),%eax
  80269a:	39 c2                	cmp    %eax,%edx
  80269c:	0f 83 f6 00 00 00    	jae    802798 <smalloc+0x387>
	                		LIST_REMOVE(&u_freelist ,lastfreeelement);
  8026a2:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8026a6:	75 17                	jne    8026bf <smalloc+0x2ae>
  8026a8:	83 ec 04             	sub    $0x4,%esp
  8026ab:	68 5b 4c 80 00       	push   $0x804c5b
  8026b0:	68 77 01 00 00       	push   $0x177
  8026b5:	68 ec 4b 80 00       	push   $0x804bec
  8026ba:	e8 dd dd ff ff       	call   80049c <_panic>
  8026bf:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8026c2:	8b 40 08             	mov    0x8(%eax),%eax
  8026c5:	85 c0                	test   %eax,%eax
  8026c7:	74 11                	je     8026da <smalloc+0x2c9>
  8026c9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8026cc:	8b 40 08             	mov    0x8(%eax),%eax
  8026cf:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8026d2:	8b 52 0c             	mov    0xc(%edx),%edx
  8026d5:	89 50 0c             	mov    %edx,0xc(%eax)
  8026d8:	eb 0b                	jmp    8026e5 <smalloc+0x2d4>
  8026da:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8026dd:	8b 40 0c             	mov    0xc(%eax),%eax
  8026e0:	a3 24 d1 81 00       	mov    %eax,0x81d124
  8026e5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8026e8:	8b 40 0c             	mov    0xc(%eax),%eax
  8026eb:	85 c0                	test   %eax,%eax
  8026ed:	74 11                	je     802700 <smalloc+0x2ef>
  8026ef:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8026f2:	8b 40 0c             	mov    0xc(%eax),%eax
  8026f5:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8026f8:	8b 52 08             	mov    0x8(%edx),%edx
  8026fb:	89 50 08             	mov    %edx,0x8(%eax)
  8026fe:	eb 0b                	jmp    80270b <smalloc+0x2fa>
  802700:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802703:	8b 40 08             	mov    0x8(%eax),%eax
  802706:	a3 20 d1 81 00       	mov    %eax,0x81d120
  80270b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80270e:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802715:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802718:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  80271f:	a1 2c d1 81 00       	mov    0x81d12c,%eax
  802724:	48                   	dec    %eax
  802725:	a3 2c d1 81 00       	mov    %eax,0x81d12c
	                		LIST_INSERT_BEFORE(&u_freelist ,currentfree2 ,lastfreeelement);
  80272a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80272e:	74 06                	je     802736 <smalloc+0x325>
  802730:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802734:	75 17                	jne    80274d <smalloc+0x33c>
  802736:	83 ec 04             	sub    $0x4,%esp
  802739:	68 7c 4c 80 00       	push   $0x804c7c
  80273e:	68 78 01 00 00       	push   $0x178
  802743:	68 ec 4b 80 00       	push   $0x804bec
  802748:	e8 4f dd ff ff       	call   80049c <_panic>
  80274d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802750:	8b 50 0c             	mov    0xc(%eax),%edx
  802753:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802756:	89 50 0c             	mov    %edx,0xc(%eax)
  802759:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80275c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80275f:	89 50 08             	mov    %edx,0x8(%eax)
  802762:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802765:	8b 40 0c             	mov    0xc(%eax),%eax
  802768:	85 c0                	test   %eax,%eax
  80276a:	74 0e                	je     80277a <smalloc+0x369>
  80276c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80276f:	8b 40 0c             	mov    0xc(%eax),%eax
  802772:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802775:	89 50 08             	mov    %edx,0x8(%eax)
  802778:	eb 08                	jmp    802782 <smalloc+0x371>
  80277a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80277d:	a3 20 d1 81 00       	mov    %eax,0x81d120
  802782:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802785:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802788:	89 50 0c             	mov    %edx,0xc(%eax)
  80278b:	a1 2c d1 81 00       	mov    0x81d12c,%eax
  802790:	40                   	inc    %eax
  802791:	a3 2c d1 81 00       	mov    %eax,0x81d12c
	                		break;
  802796:	eb 13                	jmp    8027ab <smalloc+0x39a>
	                	}
	                	currentfree2 = currentfree2->prev_next_info.le_next;
  802798:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80279b:	8b 40 08             	mov    0x8(%eax),%eax
  80279e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	                lastfreeelement->startva += size;
	                lastfreeelement->size -= size;
	                struct UserHeapStruct* currentfree2 = LIST_FIRST(&u_freelist);
	                //check order of last element

	                while (currentfree2 != NULL){
  8027a1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8027a5:	0f 85 e3 fe ff ff    	jne    80268e <smalloc+0x27d>
	                	}
	                	currentfree2 = currentfree2->prev_next_info.le_next;
	                }


	                int result = sys_create_shared_object(sharedVarName ,size ,isWritable ,(void*)allocblock->startva);
  8027ab:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027ae:	8b 00                	mov    (%eax),%eax
  8027b0:	89 c2                	mov    %eax,%edx
  8027b2:	0f b6 45 c4          	movzbl -0x3c(%ebp),%eax
  8027b6:	52                   	push   %edx
  8027b7:	50                   	push   %eax
  8027b8:	ff 75 0c             	pushl  0xc(%ebp)
  8027bb:	ff 75 08             	pushl  0x8(%ebp)
  8027be:	e8 ea 09 00 00       	call   8031ad <sys_create_shared_object>
  8027c3:	83 c4 10             	add    $0x10,%esp
  8027c6:	89 45 d8             	mov    %eax,-0x28(%ebp)

	                if(result <0){
  8027c9:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8027cd:	79 28                	jns    8027f7 <smalloc+0x3e6>
	                	free_block(allocblock);
  8027cf:	83 ec 0c             	sub    $0xc,%esp
  8027d2:	ff 75 ec             	pushl  -0x14(%ebp)
  8027d5:	e8 71 14 00 00       	call   803c4b <free_block>
  8027da:	83 c4 10             	add    $0x10,%esp
	                	release_uspinlock(&ulock);
  8027dd:	83 ec 0c             	sub    $0xc,%esp
  8027e0:	68 40 d1 81 00       	push   $0x81d140
  8027e5:	e8 85 18 00 00       	call   80406f <release_uspinlock>
  8027ea:	83 c4 10             	add    $0x10,%esp
	                	return NULL;
  8027ed:	b8 00 00 00 00       	mov    $0x0,%eax
  8027f2:	e9 bf 01 00 00       	jmp    8029b6 <smalloc+0x5a5>
	                }
	                release_uspinlock(&ulock);
  8027f7:	83 ec 0c             	sub    $0xc,%esp
  8027fa:	68 40 d1 81 00       	push   $0x81d140
  8027ff:	e8 6b 18 00 00       	call   80406f <release_uspinlock>
  802804:	83 c4 10             	add    $0x10,%esp
	                return (void*)allocblock->startva;
  802807:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80280a:	8b 00                	mov    (%eax),%eax
  80280c:	e9 a5 01 00 00       	jmp    8029b6 <smalloc+0x5a5>
	                //exact fit
				}else if(size == currentfreeelement->size){
  802811:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802814:	8b 40 04             	mov    0x4(%eax),%eax
  802817:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80281a:	0f 85 60 01 00 00    	jne    802980 <smalloc+0x56f>
					allocblock->startva = currentfreeelement->startva;
  802820:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802823:	8b 10                	mov    (%eax),%edx
  802825:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802828:	89 10                	mov    %edx,(%eax)
					allocblock->size = size;
  80282a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80282d:	8b 55 0c             	mov    0xc(%ebp),%edx
  802830:	89 50 04             	mov    %edx,0x4(%eax)
					LIST_INSERT_TAIL(&u_allocatedlist ,allocblock);
  802833:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802837:	75 17                	jne    802850 <smalloc+0x43f>
  802839:	83 ec 04             	sub    $0x4,%esp
  80283c:	68 38 4c 80 00       	push   $0x804c38
  802841:	68 8c 01 00 00       	push   $0x18c
  802846:	68 ec 4b 80 00       	push   $0x804bec
  80284b:	e8 4c dc ff ff       	call   80049c <_panic>
  802850:	8b 15 34 d1 81 00    	mov    0x81d134,%edx
  802856:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802859:	89 50 0c             	mov    %edx,0xc(%eax)
  80285c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80285f:	8b 40 0c             	mov    0xc(%eax),%eax
  802862:	85 c0                	test   %eax,%eax
  802864:	74 0d                	je     802873 <smalloc+0x462>
  802866:	a1 34 d1 81 00       	mov    0x81d134,%eax
  80286b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80286e:	89 50 08             	mov    %edx,0x8(%eax)
  802871:	eb 08                	jmp    80287b <smalloc+0x46a>
  802873:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802876:	a3 30 d1 81 00       	mov    %eax,0x81d130
  80287b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80287e:	a3 34 d1 81 00       	mov    %eax,0x81d134
  802883:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802886:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  80288d:	a1 3c d1 81 00       	mov    0x81d13c,%eax
  802892:	40                   	inc    %eax
  802893:	a3 3c d1 81 00       	mov    %eax,0x81d13c
					LIST_REMOVE(&u_freelist ,currentfreeelement);
  802898:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80289c:	75 17                	jne    8028b5 <smalloc+0x4a4>
  80289e:	83 ec 04             	sub    $0x4,%esp
  8028a1:	68 5b 4c 80 00       	push   $0x804c5b
  8028a6:	68 8d 01 00 00       	push   $0x18d
  8028ab:	68 ec 4b 80 00       	push   $0x804bec
  8028b0:	e8 e7 db ff ff       	call   80049c <_panic>
  8028b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028b8:	8b 40 08             	mov    0x8(%eax),%eax
  8028bb:	85 c0                	test   %eax,%eax
  8028bd:	74 11                	je     8028d0 <smalloc+0x4bf>
  8028bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028c2:	8b 40 08             	mov    0x8(%eax),%eax
  8028c5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028c8:	8b 52 0c             	mov    0xc(%edx),%edx
  8028cb:	89 50 0c             	mov    %edx,0xc(%eax)
  8028ce:	eb 0b                	jmp    8028db <smalloc+0x4ca>
  8028d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028d3:	8b 40 0c             	mov    0xc(%eax),%eax
  8028d6:	a3 24 d1 81 00       	mov    %eax,0x81d124
  8028db:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028de:	8b 40 0c             	mov    0xc(%eax),%eax
  8028e1:	85 c0                	test   %eax,%eax
  8028e3:	74 11                	je     8028f6 <smalloc+0x4e5>
  8028e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028e8:	8b 40 0c             	mov    0xc(%eax),%eax
  8028eb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028ee:	8b 52 08             	mov    0x8(%edx),%edx
  8028f1:	89 50 08             	mov    %edx,0x8(%eax)
  8028f4:	eb 0b                	jmp    802901 <smalloc+0x4f0>
  8028f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028f9:	8b 40 08             	mov    0x8(%eax),%eax
  8028fc:	a3 20 d1 81 00       	mov    %eax,0x81d120
  802901:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802904:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  80290b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80290e:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  802915:	a1 2c d1 81 00       	mov    0x81d12c,%eax
  80291a:	48                   	dec    %eax
  80291b:	a3 2c d1 81 00       	mov    %eax,0x81d12c
					int result = sys_create_shared_object(sharedVarName ,size ,isWritable ,(void*)allocblock->startva);
  802920:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802923:	8b 00                	mov    (%eax),%eax
  802925:	89 c2                	mov    %eax,%edx
  802927:	0f b6 45 c4          	movzbl -0x3c(%ebp),%eax
  80292b:	52                   	push   %edx
  80292c:	50                   	push   %eax
  80292d:	ff 75 0c             	pushl  0xc(%ebp)
  802930:	ff 75 08             	pushl  0x8(%ebp)
  802933:	e8 75 08 00 00       	call   8031ad <sys_create_shared_object>
  802938:	83 c4 10             	add    $0x10,%esp
  80293b:	89 45 dc             	mov    %eax,-0x24(%ebp)

					if(result <0){
  80293e:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802942:	79 25                	jns    802969 <smalloc+0x558>
						free_block(allocblock);
  802944:	83 ec 0c             	sub    $0xc,%esp
  802947:	ff 75 ec             	pushl  -0x14(%ebp)
  80294a:	e8 fc 12 00 00       	call   803c4b <free_block>
  80294f:	83 c4 10             	add    $0x10,%esp
						release_uspinlock(&ulock);
  802952:	83 ec 0c             	sub    $0xc,%esp
  802955:	68 40 d1 81 00       	push   $0x81d140
  80295a:	e8 10 17 00 00       	call   80406f <release_uspinlock>
  80295f:	83 c4 10             	add    $0x10,%esp
						return NULL;
  802962:	b8 00 00 00 00       	mov    $0x0,%eax
  802967:	eb 4d                	jmp    8029b6 <smalloc+0x5a5>
					}
					release_uspinlock(&ulock);
  802969:	83 ec 0c             	sub    $0xc,%esp
  80296c:	68 40 d1 81 00       	push   $0x81d140
  802971:	e8 f9 16 00 00       	call   80406f <release_uspinlock>
  802976:	83 c4 10             	add    $0x10,%esp
					return (void*)allocblock->startva;
  802979:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80297c:	8b 00                	mov    (%eax),%eax
  80297e:	eb 36                	jmp    8029b6 <smalloc+0x5a5>
				}
				currentfreeelement = currentfreeelement->prev_next_info.le_next;
  802980:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802983:	8b 40 08             	mov    0x8(%eax),%eax
  802986:	89 45 f4             	mov    %eax,-0xc(%ebp)
					 }
		}else{
			//custom fit
			struct UserHeapStruct* currentfreeelement = LIST_FIRST(&u_freelist);
			//worst fit
			while(currentfreeelement != NULL){
  802989:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80298d:	0f 85 47 fc ff ff    	jne    8025da <smalloc+0x1c9>
					return (void*)allocblock->startva;
				}
				currentfreeelement = currentfreeelement->prev_next_info.le_next;
			}
		}
		free_block(allocblock);
  802993:	83 ec 0c             	sub    $0xc,%esp
  802996:	ff 75 ec             	pushl  -0x14(%ebp)
  802999:	e8 ad 12 00 00       	call   803c4b <free_block>
  80299e:	83 c4 10             	add    $0x10,%esp
		release_uspinlock(&ulock);
  8029a1:	83 ec 0c             	sub    $0xc,%esp
  8029a4:	68 40 d1 81 00       	push   $0x81d140
  8029a9:	e8 c1 16 00 00       	call   80406f <release_uspinlock>
  8029ae:	83 c4 10             	add    $0x10,%esp
		return NULL;
  8029b1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8029b6:	c9                   	leave  
  8029b7:	c3                   	ret    

008029b8 <sget>:

//========================================
// [4] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8029b8:	55                   	push   %ebp
  8029b9:	89 e5                	mov    %esp,%ebp
  8029bb:	83 ec 38             	sub    $0x38,%esp


	 //==============================================================
	 // DON'T CHANGE THIS CODE
	    uheap_init();
  8029be:	e8 8c ec ff ff       	call   80164f <uheap_init>
	 //==============================================================
	 // Get size of the shared variable from kernel
	acquire_uspinlock(&ulock);
  8029c3:	83 ec 0c             	sub    $0xc,%esp
  8029c6:	68 40 d1 81 00       	push   $0x81d140
  8029cb:	e8 47 16 00 00       	call   804017 <acquire_uspinlock>
  8029d0:	83 c4 10             	add    $0x10,%esp


	int size = sys_size_of_shared_object(ownerEnvID ,sharedVarName);
  8029d3:	83 ec 08             	sub    $0x8,%esp
  8029d6:	ff 75 0c             	pushl  0xc(%ebp)
  8029d9:	ff 75 08             	pushl  0x8(%ebp)
  8029dc:	e8 f6 07 00 00       	call   8031d7 <sys_size_of_shared_object>
  8029e1:	83 c4 10             	add    $0x10,%esp
  8029e4:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if ( size < 0 ){
  8029e7:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8029eb:	79 1a                	jns    802a07 <sget+0x4f>
			release_uspinlock(&ulock);
  8029ed:	83 ec 0c             	sub    $0xc,%esp
  8029f0:	68 40 d1 81 00       	push   $0x81d140
  8029f5:	e8 75 16 00 00       	call   80406f <release_uspinlock>
  8029fa:	83 c4 10             	add    $0x10,%esp
			return NULL;
  8029fd:	b8 00 00 00 00       	mov    $0x0,%eax
  802a02:	e9 6e 05 00 00       	jmp    802f75 <sget+0x5bd>
		}
		size = ROUNDUP(size,PAGE_SIZE);
  802a07:	c7 45 e8 00 10 00 00 	movl   $0x1000,-0x18(%ebp)
  802a0e:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802a11:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a14:	01 d0                	add    %edx,%eax
  802a16:	48                   	dec    %eax
  802a17:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  802a1a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802a1d:	ba 00 00 00 00       	mov    $0x0,%edx
  802a22:	f7 75 e8             	divl   -0x18(%ebp)
  802a25:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802a28:	29 d0                	sub    %edx,%eax
  802a2a:	89 45 ec             	mov    %eax,-0x14(%ebp)

		struct UserHeapStruct* allocblock = (struct UserHeapStruct*) alloc_block(sizeof(struct UserHeapStruct));
  802a2d:	83 ec 0c             	sub    $0xc,%esp
  802a30:	6a 10                	push   $0x10
  802a32:	e8 78 0d 00 00       	call   8037af <alloc_block>
  802a37:	83 c4 10             	add    $0x10,%esp
  802a3a:	89 45 e0             	mov    %eax,-0x20(%ebp)

		if (allocblock == NULL){
  802a3d:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802a41:	75 0a                	jne    802a4d <sget+0x95>
			return NULL;
  802a43:	b8 00 00 00 00       	mov    $0x0,%eax
  802a48:	e9 28 05 00 00       	jmp    802f75 <sget+0x5bd>
		}
		struct UserHeapStruct* lastfreeelement = LIST_LAST(&u_freelist);
  802a4d:	a1 24 d1 81 00       	mov    0x81d124,%eax
  802a52:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if(LIST_SIZE(&u_freelist)==0 || size>lastfreeelement->size){
  802a55:	a1 2c d1 81 00       	mov    0x81d12c,%eax
  802a5a:	85 c0                	test   %eax,%eax
  802a5c:	74 11                	je     802a6f <sget+0xb7>
  802a5e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802a61:	8b 50 04             	mov    0x4(%eax),%edx
  802a64:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a67:	39 c2                	cmp    %eax,%edx
  802a69:	0f 83 21 01 00 00    	jae    802b90 <sget+0x1d8>
				if(uheapPageAllocBreak <= USER_HEAP_MAX - size){
  802a6f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a72:	ba 00 00 00 a0       	mov    $0xa0000000,%edx
  802a77:	29 c2                	sub    %eax,%edx
  802a79:	a1 68 d0 81 00       	mov    0x81d068,%eax
  802a7e:	39 c2                	cmp    %eax,%edx
  802a80:	0f 82 f0 00 00 00    	jb     802b76 <sget+0x1be>

						uint32 requestedblockva = uheapPageAllocBreak;
  802a86:	a1 68 d0 81 00       	mov    0x81d068,%eax
  802a8b:	89 45 d0             	mov    %eax,-0x30(%ebp)
						uheapPageAllocBreak+=size;
  802a8e:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  802a94:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a97:	01 d0                	add    %edx,%eax
  802a99:	a3 68 d0 81 00       	mov    %eax,0x81d068
						allocblock->startva = requestedblockva;
  802a9e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802aa1:	8b 55 d0             	mov    -0x30(%ebp),%edx
  802aa4:	89 10                	mov    %edx,(%eax)
						allocblock->size = size;
  802aa6:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802aa9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802aac:	89 50 04             	mov    %edx,0x4(%eax)

						LIST_INSERT_TAIL(&u_allocatedlist, allocblock);
  802aaf:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802ab3:	75 17                	jne    802acc <sget+0x114>
  802ab5:	83 ec 04             	sub    $0x4,%esp
  802ab8:	68 38 4c 80 00       	push   $0x804c38
  802abd:	68 c8 01 00 00       	push   $0x1c8
  802ac2:	68 ec 4b 80 00       	push   $0x804bec
  802ac7:	e8 d0 d9 ff ff       	call   80049c <_panic>
  802acc:	8b 15 34 d1 81 00    	mov    0x81d134,%edx
  802ad2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802ad5:	89 50 0c             	mov    %edx,0xc(%eax)
  802ad8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802adb:	8b 40 0c             	mov    0xc(%eax),%eax
  802ade:	85 c0                	test   %eax,%eax
  802ae0:	74 0d                	je     802aef <sget+0x137>
  802ae2:	a1 34 d1 81 00       	mov    0x81d134,%eax
  802ae7:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802aea:	89 50 08             	mov    %edx,0x8(%eax)
  802aed:	eb 08                	jmp    802af7 <sget+0x13f>
  802aef:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802af2:	a3 30 d1 81 00       	mov    %eax,0x81d130
  802af7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802afa:	a3 34 d1 81 00       	mov    %eax,0x81d134
  802aff:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802b02:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802b09:	a1 3c d1 81 00       	mov    0x81d13c,%eax
  802b0e:	40                   	inc    %eax
  802b0f:	a3 3c d1 81 00       	mov    %eax,0x81d13c


						int result = sys_get_shared_object(ownerEnvID ,sharedVarName ,(void*)allocblock->startva);
  802b14:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802b17:	8b 00                	mov    (%eax),%eax
  802b19:	83 ec 04             	sub    $0x4,%esp
  802b1c:	50                   	push   %eax
  802b1d:	ff 75 0c             	pushl  0xc(%ebp)
  802b20:	ff 75 08             	pushl  0x8(%ebp)
  802b23:	e8 cc 06 00 00       	call   8031f4 <sys_get_shared_object>
  802b28:	83 c4 10             	add    $0x10,%esp
  802b2b:	89 45 cc             	mov    %eax,-0x34(%ebp)

						if(result <0){
  802b2e:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802b32:	79 28                	jns    802b5c <sget+0x1a4>
							free_block(allocblock);
  802b34:	83 ec 0c             	sub    $0xc,%esp
  802b37:	ff 75 e0             	pushl  -0x20(%ebp)
  802b3a:	e8 0c 11 00 00       	call   803c4b <free_block>
  802b3f:	83 c4 10             	add    $0x10,%esp
							release_uspinlock(&ulock);
  802b42:	83 ec 0c             	sub    $0xc,%esp
  802b45:	68 40 d1 81 00       	push   $0x81d140
  802b4a:	e8 20 15 00 00       	call   80406f <release_uspinlock>
  802b4f:	83 c4 10             	add    $0x10,%esp
							return NULL;
  802b52:	b8 00 00 00 00       	mov    $0x0,%eax
  802b57:	e9 19 04 00 00       	jmp    802f75 <sget+0x5bd>
						}
						release_uspinlock(&ulock);
  802b5c:	83 ec 0c             	sub    $0xc,%esp
  802b5f:	68 40 d1 81 00       	push   $0x81d140
  802b64:	e8 06 15 00 00       	call   80406f <release_uspinlock>
  802b69:	83 c4 10             	add    $0x10,%esp
						return (void*)allocblock -> startva;
  802b6c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802b6f:	8b 00                	mov    (%eax),%eax
  802b71:	e9 ff 03 00 00       	jmp    802f75 <sget+0x5bd>
				}else{
						release_uspinlock(&ulock);
  802b76:	83 ec 0c             	sub    $0xc,%esp
  802b79:	68 40 d1 81 00       	push   $0x81d140
  802b7e:	e8 ec 14 00 00       	call   80406f <release_uspinlock>
  802b83:	83 c4 10             	add    $0x10,%esp
						return NULL;
  802b86:	b8 00 00 00 00       	mov    $0x0,%eax
  802b8b:	e9 e5 03 00 00       	jmp    802f75 <sget+0x5bd>
					 }
		}else{
			//custom fit
			struct UserHeapStruct* currentfreeelement = LIST_FIRST(&u_freelist);
  802b90:	a1 20 d1 81 00       	mov    0x81d120,%eax
  802b95:	89 45 f4             	mov    %eax,-0xc(%ebp)
			//worst fit
			while(currentfreeelement != NULL){
  802b98:	e9 ab 03 00 00       	jmp    802f48 <sget+0x590>
				if(size<currentfreeelement->size){
  802b9d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ba0:	8b 50 04             	mov    0x4(%eax),%edx
  802ba3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ba6:	39 c2                	cmp    %eax,%edx
  802ba8:	0f 86 24 02 00 00    	jbe    802dd2 <sget+0x41a>
					allocblock->startva = lastfreeelement->startva;
  802bae:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802bb1:	8b 10                	mov    (%eax),%edx
  802bb3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802bb6:	89 10                	mov    %edx,(%eax)
					allocblock->size = size;
  802bb8:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802bbb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802bbe:	89 50 04             	mov    %edx,0x4(%eax)
					LIST_INSERT_TAIL(&u_allocatedlist,allocblock);
  802bc1:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802bc5:	75 17                	jne    802bde <sget+0x226>
  802bc7:	83 ec 04             	sub    $0x4,%esp
  802bca:	68 38 4c 80 00       	push   $0x804c38
  802bcf:	68 e0 01 00 00       	push   $0x1e0
  802bd4:	68 ec 4b 80 00       	push   $0x804bec
  802bd9:	e8 be d8 ff ff       	call   80049c <_panic>
  802bde:	8b 15 34 d1 81 00    	mov    0x81d134,%edx
  802be4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802be7:	89 50 0c             	mov    %edx,0xc(%eax)
  802bea:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802bed:	8b 40 0c             	mov    0xc(%eax),%eax
  802bf0:	85 c0                	test   %eax,%eax
  802bf2:	74 0d                	je     802c01 <sget+0x249>
  802bf4:	a1 34 d1 81 00       	mov    0x81d134,%eax
  802bf9:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802bfc:	89 50 08             	mov    %edx,0x8(%eax)
  802bff:	eb 08                	jmp    802c09 <sget+0x251>
  802c01:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802c04:	a3 30 d1 81 00       	mov    %eax,0x81d130
  802c09:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802c0c:	a3 34 d1 81 00       	mov    %eax,0x81d134
  802c11:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802c14:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802c1b:	a1 3c d1 81 00       	mov    0x81d13c,%eax
  802c20:	40                   	inc    %eax
  802c21:	a3 3c d1 81 00       	mov    %eax,0x81d13c
					lastfreeelement->startva += size;
  802c26:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802c29:	8b 10                	mov    (%eax),%edx
  802c2b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c2e:	01 c2                	add    %eax,%edx
  802c30:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802c33:	89 10                	mov    %edx,(%eax)
					lastfreeelement->size -= size;
  802c35:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802c38:	8b 50 04             	mov    0x4(%eax),%edx
  802c3b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c3e:	29 c2                	sub    %eax,%edx
  802c40:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802c43:	89 50 04             	mov    %edx,0x4(%eax)
					struct UserHeapStruct* currentfree2 = LIST_FIRST(&u_freelist);
  802c46:	a1 20 d1 81 00       	mov    0x81d120,%eax
  802c4b:	89 45 f0             	mov    %eax,-0x10(%ebp)
					//check order of last element

					while (currentfree2 != NULL){
  802c4e:	e9 13 01 00 00       	jmp    802d66 <sget+0x3ae>
						if(lastfreeelement->size <currentfree2->size){
  802c53:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802c56:	8b 50 04             	mov    0x4(%eax),%edx
  802c59:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c5c:	8b 40 04             	mov    0x4(%eax),%eax
  802c5f:	39 c2                	cmp    %eax,%edx
  802c61:	0f 83 f6 00 00 00    	jae    802d5d <sget+0x3a5>
							LIST_REMOVE(&u_freelist ,lastfreeelement);
  802c67:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802c6b:	75 17                	jne    802c84 <sget+0x2cc>
  802c6d:	83 ec 04             	sub    $0x4,%esp
  802c70:	68 5b 4c 80 00       	push   $0x804c5b
  802c75:	68 e8 01 00 00       	push   $0x1e8
  802c7a:	68 ec 4b 80 00       	push   $0x804bec
  802c7f:	e8 18 d8 ff ff       	call   80049c <_panic>
  802c84:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802c87:	8b 40 08             	mov    0x8(%eax),%eax
  802c8a:	85 c0                	test   %eax,%eax
  802c8c:	74 11                	je     802c9f <sget+0x2e7>
  802c8e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802c91:	8b 40 08             	mov    0x8(%eax),%eax
  802c94:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802c97:	8b 52 0c             	mov    0xc(%edx),%edx
  802c9a:	89 50 0c             	mov    %edx,0xc(%eax)
  802c9d:	eb 0b                	jmp    802caa <sget+0x2f2>
  802c9f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802ca2:	8b 40 0c             	mov    0xc(%eax),%eax
  802ca5:	a3 24 d1 81 00       	mov    %eax,0x81d124
  802caa:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802cad:	8b 40 0c             	mov    0xc(%eax),%eax
  802cb0:	85 c0                	test   %eax,%eax
  802cb2:	74 11                	je     802cc5 <sget+0x30d>
  802cb4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802cb7:	8b 40 0c             	mov    0xc(%eax),%eax
  802cba:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802cbd:	8b 52 08             	mov    0x8(%edx),%edx
  802cc0:	89 50 08             	mov    %edx,0x8(%eax)
  802cc3:	eb 0b                	jmp    802cd0 <sget+0x318>
  802cc5:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802cc8:	8b 40 08             	mov    0x8(%eax),%eax
  802ccb:	a3 20 d1 81 00       	mov    %eax,0x81d120
  802cd0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802cd3:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802cda:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802cdd:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  802ce4:	a1 2c d1 81 00       	mov    0x81d12c,%eax
  802ce9:	48                   	dec    %eax
  802cea:	a3 2c d1 81 00       	mov    %eax,0x81d12c
							LIST_INSERT_BEFORE(&u_freelist ,currentfree2 ,lastfreeelement);
  802cef:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802cf3:	74 06                	je     802cfb <sget+0x343>
  802cf5:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802cf9:	75 17                	jne    802d12 <sget+0x35a>
  802cfb:	83 ec 04             	sub    $0x4,%esp
  802cfe:	68 7c 4c 80 00       	push   $0x804c7c
  802d03:	68 e9 01 00 00       	push   $0x1e9
  802d08:	68 ec 4b 80 00       	push   $0x804bec
  802d0d:	e8 8a d7 ff ff       	call   80049c <_panic>
  802d12:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d15:	8b 50 0c             	mov    0xc(%eax),%edx
  802d18:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802d1b:	89 50 0c             	mov    %edx,0xc(%eax)
  802d1e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802d21:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802d24:	89 50 08             	mov    %edx,0x8(%eax)
  802d27:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d2a:	8b 40 0c             	mov    0xc(%eax),%eax
  802d2d:	85 c0                	test   %eax,%eax
  802d2f:	74 0e                	je     802d3f <sget+0x387>
  802d31:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d34:	8b 40 0c             	mov    0xc(%eax),%eax
  802d37:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802d3a:	89 50 08             	mov    %edx,0x8(%eax)
  802d3d:	eb 08                	jmp    802d47 <sget+0x38f>
  802d3f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802d42:	a3 20 d1 81 00       	mov    %eax,0x81d120
  802d47:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d4a:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802d4d:	89 50 0c             	mov    %edx,0xc(%eax)
  802d50:	a1 2c d1 81 00       	mov    0x81d12c,%eax
  802d55:	40                   	inc    %eax
  802d56:	a3 2c d1 81 00       	mov    %eax,0x81d12c
							break;
  802d5b:	eb 13                	jmp    802d70 <sget+0x3b8>
						}
						currentfree2 = currentfree2->prev_next_info.le_next;
  802d5d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d60:	8b 40 08             	mov    0x8(%eax),%eax
  802d63:	89 45 f0             	mov    %eax,-0x10(%ebp)
					lastfreeelement->startva += size;
					lastfreeelement->size -= size;
					struct UserHeapStruct* currentfree2 = LIST_FIRST(&u_freelist);
					//check order of last element

					while (currentfree2 != NULL){
  802d66:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802d6a:	0f 85 e3 fe ff ff    	jne    802c53 <sget+0x29b>
						}
						currentfree2 = currentfree2->prev_next_info.le_next;
					}


					int result = sys_get_shared_object(ownerEnvID ,sharedVarName ,(void*)allocblock->startva);
  802d70:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802d73:	8b 00                	mov    (%eax),%eax
  802d75:	83 ec 04             	sub    $0x4,%esp
  802d78:	50                   	push   %eax
  802d79:	ff 75 0c             	pushl  0xc(%ebp)
  802d7c:	ff 75 08             	pushl  0x8(%ebp)
  802d7f:	e8 70 04 00 00       	call   8031f4 <sys_get_shared_object>
  802d84:	83 c4 10             	add    $0x10,%esp
  802d87:	89 45 d4             	mov    %eax,-0x2c(%ebp)

					if(result <0){
  802d8a:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  802d8e:	79 28                	jns    802db8 <sget+0x400>
						free_block(allocblock);
  802d90:	83 ec 0c             	sub    $0xc,%esp
  802d93:	ff 75 e0             	pushl  -0x20(%ebp)
  802d96:	e8 b0 0e 00 00       	call   803c4b <free_block>
  802d9b:	83 c4 10             	add    $0x10,%esp
						release_uspinlock(&ulock);
  802d9e:	83 ec 0c             	sub    $0xc,%esp
  802da1:	68 40 d1 81 00       	push   $0x81d140
  802da6:	e8 c4 12 00 00       	call   80406f <release_uspinlock>
  802dab:	83 c4 10             	add    $0x10,%esp
						return NULL;
  802dae:	b8 00 00 00 00       	mov    $0x0,%eax
  802db3:	e9 bd 01 00 00       	jmp    802f75 <sget+0x5bd>
					}
					release_uspinlock(&ulock);
  802db8:	83 ec 0c             	sub    $0xc,%esp
  802dbb:	68 40 d1 81 00       	push   $0x81d140
  802dc0:	e8 aa 12 00 00       	call   80406f <release_uspinlock>
  802dc5:	83 c4 10             	add    $0x10,%esp
					return (void*)allocblock->startva;
  802dc8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802dcb:	8b 00                	mov    (%eax),%eax
  802dcd:	e9 a3 01 00 00       	jmp    802f75 <sget+0x5bd>
					//exact fit
				}else if(size == currentfreeelement->size){
  802dd2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dd5:	8b 50 04             	mov    0x4(%eax),%edx
  802dd8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ddb:	39 c2                	cmp    %eax,%edx
  802ddd:	0f 85 5c 01 00 00    	jne    802f3f <sget+0x587>

					allocblock->startva = currentfreeelement->startva;
  802de3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802de6:	8b 10                	mov    (%eax),%edx
  802de8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802deb:	89 10                	mov    %edx,(%eax)
					allocblock->size = size;
  802ded:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802df0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802df3:	89 50 04             	mov    %edx,0x4(%eax)
					LIST_INSERT_TAIL(&u_allocatedlist ,allocblock);
  802df6:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802dfa:	75 17                	jne    802e13 <sget+0x45b>
  802dfc:	83 ec 04             	sub    $0x4,%esp
  802dff:	68 38 4c 80 00       	push   $0x804c38
  802e04:	68 fe 01 00 00       	push   $0x1fe
  802e09:	68 ec 4b 80 00       	push   $0x804bec
  802e0e:	e8 89 d6 ff ff       	call   80049c <_panic>
  802e13:	8b 15 34 d1 81 00    	mov    0x81d134,%edx
  802e19:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802e1c:	89 50 0c             	mov    %edx,0xc(%eax)
  802e1f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802e22:	8b 40 0c             	mov    0xc(%eax),%eax
  802e25:	85 c0                	test   %eax,%eax
  802e27:	74 0d                	je     802e36 <sget+0x47e>
  802e29:	a1 34 d1 81 00       	mov    0x81d134,%eax
  802e2e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802e31:	89 50 08             	mov    %edx,0x8(%eax)
  802e34:	eb 08                	jmp    802e3e <sget+0x486>
  802e36:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802e39:	a3 30 d1 81 00       	mov    %eax,0x81d130
  802e3e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802e41:	a3 34 d1 81 00       	mov    %eax,0x81d134
  802e46:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802e49:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802e50:	a1 3c d1 81 00       	mov    0x81d13c,%eax
  802e55:	40                   	inc    %eax
  802e56:	a3 3c d1 81 00       	mov    %eax,0x81d13c
					LIST_REMOVE(&u_freelist ,currentfreeelement);
  802e5b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e5f:	75 17                	jne    802e78 <sget+0x4c0>
  802e61:	83 ec 04             	sub    $0x4,%esp
  802e64:	68 5b 4c 80 00       	push   $0x804c5b
  802e69:	68 ff 01 00 00       	push   $0x1ff
  802e6e:	68 ec 4b 80 00       	push   $0x804bec
  802e73:	e8 24 d6 ff ff       	call   80049c <_panic>
  802e78:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e7b:	8b 40 08             	mov    0x8(%eax),%eax
  802e7e:	85 c0                	test   %eax,%eax
  802e80:	74 11                	je     802e93 <sget+0x4db>
  802e82:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e85:	8b 40 08             	mov    0x8(%eax),%eax
  802e88:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e8b:	8b 52 0c             	mov    0xc(%edx),%edx
  802e8e:	89 50 0c             	mov    %edx,0xc(%eax)
  802e91:	eb 0b                	jmp    802e9e <sget+0x4e6>
  802e93:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e96:	8b 40 0c             	mov    0xc(%eax),%eax
  802e99:	a3 24 d1 81 00       	mov    %eax,0x81d124
  802e9e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ea1:	8b 40 0c             	mov    0xc(%eax),%eax
  802ea4:	85 c0                	test   %eax,%eax
  802ea6:	74 11                	je     802eb9 <sget+0x501>
  802ea8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eab:	8b 40 0c             	mov    0xc(%eax),%eax
  802eae:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802eb1:	8b 52 08             	mov    0x8(%edx),%edx
  802eb4:	89 50 08             	mov    %edx,0x8(%eax)
  802eb7:	eb 0b                	jmp    802ec4 <sget+0x50c>
  802eb9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ebc:	8b 40 08             	mov    0x8(%eax),%eax
  802ebf:	a3 20 d1 81 00       	mov    %eax,0x81d120
  802ec4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ec7:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802ece:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ed1:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  802ed8:	a1 2c d1 81 00       	mov    0x81d12c,%eax
  802edd:	48                   	dec    %eax
  802ede:	a3 2c d1 81 00       	mov    %eax,0x81d12c

					int result = sys_get_shared_object(ownerEnvID ,sharedVarName ,(void*)allocblock->startva);
  802ee3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802ee6:	8b 00                	mov    (%eax),%eax
  802ee8:	83 ec 04             	sub    $0x4,%esp
  802eeb:	50                   	push   %eax
  802eec:	ff 75 0c             	pushl  0xc(%ebp)
  802eef:	ff 75 08             	pushl  0x8(%ebp)
  802ef2:	e8 fd 02 00 00       	call   8031f4 <sys_get_shared_object>
  802ef7:	83 c4 10             	add    $0x10,%esp
  802efa:	89 45 d8             	mov    %eax,-0x28(%ebp)
					if(result <0){
  802efd:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  802f01:	79 25                	jns    802f28 <sget+0x570>
						free_block(allocblock);
  802f03:	83 ec 0c             	sub    $0xc,%esp
  802f06:	ff 75 e0             	pushl  -0x20(%ebp)
  802f09:	e8 3d 0d 00 00       	call   803c4b <free_block>
  802f0e:	83 c4 10             	add    $0x10,%esp
						release_uspinlock(&ulock);
  802f11:	83 ec 0c             	sub    $0xc,%esp
  802f14:	68 40 d1 81 00       	push   $0x81d140
  802f19:	e8 51 11 00 00       	call   80406f <release_uspinlock>
  802f1e:	83 c4 10             	add    $0x10,%esp
						return NULL;
  802f21:	b8 00 00 00 00       	mov    $0x0,%eax
  802f26:	eb 4d                	jmp    802f75 <sget+0x5bd>
					}

					release_uspinlock(&ulock);
  802f28:	83 ec 0c             	sub    $0xc,%esp
  802f2b:	68 40 d1 81 00       	push   $0x81d140
  802f30:	e8 3a 11 00 00       	call   80406f <release_uspinlock>
  802f35:	83 c4 10             	add    $0x10,%esp
					return (void*)allocblock->startva;
  802f38:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802f3b:	8b 00                	mov    (%eax),%eax
  802f3d:	eb 36                	jmp    802f75 <sget+0x5bd>
				}
				currentfreeelement = currentfreeelement->prev_next_info.le_next;
  802f3f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f42:	8b 40 08             	mov    0x8(%eax),%eax
  802f45:	89 45 f4             	mov    %eax,-0xc(%ebp)
					 }
		}else{
			//custom fit
			struct UserHeapStruct* currentfreeelement = LIST_FIRST(&u_freelist);
			//worst fit
			while(currentfreeelement != NULL){
  802f48:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f4c:	0f 85 4b fc ff ff    	jne    802b9d <sget+0x1e5>
					return (void*)allocblock->startva;
				}
				currentfreeelement = currentfreeelement->prev_next_info.le_next;
			}
		}
		free_block(allocblock);
  802f52:	83 ec 0c             	sub    $0xc,%esp
  802f55:	ff 75 e0             	pushl  -0x20(%ebp)
  802f58:	e8 ee 0c 00 00       	call   803c4b <free_block>
  802f5d:	83 c4 10             	add    $0x10,%esp
		release_uspinlock(&ulock);
  802f60:	83 ec 0c             	sub    $0xc,%esp
  802f63:	68 40 d1 81 00       	push   $0x81d140
  802f68:	e8 02 11 00 00       	call   80406f <release_uspinlock>
  802f6d:	83 c4 10             	add    $0x10,%esp
		return NULL;
  802f70:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802f75:	c9                   	leave  
  802f76:	c3                   	ret    

00802f77 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  802f77:	55                   	push   %ebp
  802f78:	89 e5                	mov    %esp,%ebp
  802f7a:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  802f7d:	e8 cd e6 ff ff       	call   80164f <uheap_init>
	//==============================================================
	panic("realloc() is not implemented yet...!!");
  802f82:	83 ec 04             	sub    $0x4,%esp
  802f85:	68 0c 4d 80 00       	push   $0x804d0c
  802f8a:	68 2d 02 00 00       	push   $0x22d
  802f8f:	68 ec 4b 80 00       	push   $0x804bec
  802f94:	e8 03 d5 ff ff       	call   80049c <_panic>

00802f99 <sfree>:
//
//	use sys_delete_shared_object(...); which switches to the kernel mode,
//	calls delete_shared_object(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the delete_shared_object() function is empty, make sure to implement it.
void sfree(void* virtual_address)
{
  802f99:	55                   	push   %ebp
  802f9a:	89 e5                	mov    %esp,%ebp
  802f9c:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.BONUS#5] EXIT #2 - sfree
	//Your code is here
	//Comment the following line
	panic("sfree() is not implemented yet...!!");
  802f9f:	83 ec 04             	sub    $0x4,%esp
  802fa2:	68 34 4d 80 00       	push   $0x804d34
  802fa7:	68 40 02 00 00       	push   $0x240
  802fac:	68 ec 4b 80 00       	push   $0x804bec
  802fb1:	e8 e6 d4 ff ff       	call   80049c <_panic>

00802fb6 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  802fb6:	55                   	push   %ebp
  802fb7:	89 e5                	mov    %esp,%ebp
  802fb9:	57                   	push   %edi
  802fba:	56                   	push   %esi
  802fbb:	53                   	push   %ebx
  802fbc:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  802fbf:	8b 45 08             	mov    0x8(%ebp),%eax
  802fc2:	8b 55 0c             	mov    0xc(%ebp),%edx
  802fc5:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802fc8:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802fcb:	8b 7d 18             	mov    0x18(%ebp),%edi
  802fce:	8b 75 1c             	mov    0x1c(%ebp),%esi
  802fd1:	cd 30                	int    $0x30
  802fd3:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  802fd6:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  802fd9:	83 c4 10             	add    $0x10,%esp
  802fdc:	5b                   	pop    %ebx
  802fdd:	5e                   	pop    %esi
  802fde:	5f                   	pop    %edi
  802fdf:	5d                   	pop    %ebp
  802fe0:	c3                   	ret    

00802fe1 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  802fe1:	55                   	push   %ebp
  802fe2:	89 e5                	mov    %esp,%ebp
  802fe4:	83 ec 04             	sub    $0x4,%esp
  802fe7:	8b 45 10             	mov    0x10(%ebp),%eax
  802fea:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  802fed:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802ff0:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802ff4:	8b 45 08             	mov    0x8(%ebp),%eax
  802ff7:	6a 00                	push   $0x0
  802ff9:	51                   	push   %ecx
  802ffa:	52                   	push   %edx
  802ffb:	ff 75 0c             	pushl  0xc(%ebp)
  802ffe:	50                   	push   %eax
  802fff:	6a 00                	push   $0x0
  803001:	e8 b0 ff ff ff       	call   802fb6 <syscall>
  803006:	83 c4 18             	add    $0x18,%esp
}
  803009:	90                   	nop
  80300a:	c9                   	leave  
  80300b:	c3                   	ret    

0080300c <sys_cgetc>:

int
sys_cgetc(void)
{
  80300c:	55                   	push   %ebp
  80300d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  80300f:	6a 00                	push   $0x0
  803011:	6a 00                	push   $0x0
  803013:	6a 00                	push   $0x0
  803015:	6a 00                	push   $0x0
  803017:	6a 00                	push   $0x0
  803019:	6a 02                	push   $0x2
  80301b:	e8 96 ff ff ff       	call   802fb6 <syscall>
  803020:	83 c4 18             	add    $0x18,%esp
}
  803023:	c9                   	leave  
  803024:	c3                   	ret    

00803025 <sys_lock_cons>:

void sys_lock_cons(void)
{
  803025:	55                   	push   %ebp
  803026:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  803028:	6a 00                	push   $0x0
  80302a:	6a 00                	push   $0x0
  80302c:	6a 00                	push   $0x0
  80302e:	6a 00                	push   $0x0
  803030:	6a 00                	push   $0x0
  803032:	6a 03                	push   $0x3
  803034:	e8 7d ff ff ff       	call   802fb6 <syscall>
  803039:	83 c4 18             	add    $0x18,%esp
}
  80303c:	90                   	nop
  80303d:	c9                   	leave  
  80303e:	c3                   	ret    

0080303f <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  80303f:	55                   	push   %ebp
  803040:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  803042:	6a 00                	push   $0x0
  803044:	6a 00                	push   $0x0
  803046:	6a 00                	push   $0x0
  803048:	6a 00                	push   $0x0
  80304a:	6a 00                	push   $0x0
  80304c:	6a 04                	push   $0x4
  80304e:	e8 63 ff ff ff       	call   802fb6 <syscall>
  803053:	83 c4 18             	add    $0x18,%esp
}
  803056:	90                   	nop
  803057:	c9                   	leave  
  803058:	c3                   	ret    

00803059 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  803059:	55                   	push   %ebp
  80305a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  80305c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80305f:	8b 45 08             	mov    0x8(%ebp),%eax
  803062:	6a 00                	push   $0x0
  803064:	6a 00                	push   $0x0
  803066:	6a 00                	push   $0x0
  803068:	52                   	push   %edx
  803069:	50                   	push   %eax
  80306a:	6a 08                	push   $0x8
  80306c:	e8 45 ff ff ff       	call   802fb6 <syscall>
  803071:	83 c4 18             	add    $0x18,%esp
}
  803074:	c9                   	leave  
  803075:	c3                   	ret    

00803076 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  803076:	55                   	push   %ebp
  803077:	89 e5                	mov    %esp,%ebp
  803079:	56                   	push   %esi
  80307a:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  80307b:	8b 75 18             	mov    0x18(%ebp),%esi
  80307e:	8b 5d 14             	mov    0x14(%ebp),%ebx
  803081:	8b 4d 10             	mov    0x10(%ebp),%ecx
  803084:	8b 55 0c             	mov    0xc(%ebp),%edx
  803087:	8b 45 08             	mov    0x8(%ebp),%eax
  80308a:	56                   	push   %esi
  80308b:	53                   	push   %ebx
  80308c:	51                   	push   %ecx
  80308d:	52                   	push   %edx
  80308e:	50                   	push   %eax
  80308f:	6a 09                	push   $0x9
  803091:	e8 20 ff ff ff       	call   802fb6 <syscall>
  803096:	83 c4 18             	add    $0x18,%esp
}
  803099:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80309c:	5b                   	pop    %ebx
  80309d:	5e                   	pop    %esi
  80309e:	5d                   	pop    %ebp
  80309f:	c3                   	ret    

008030a0 <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  8030a0:	55                   	push   %ebp
  8030a1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  8030a3:	6a 00                	push   $0x0
  8030a5:	6a 00                	push   $0x0
  8030a7:	6a 00                	push   $0x0
  8030a9:	6a 00                	push   $0x0
  8030ab:	ff 75 08             	pushl  0x8(%ebp)
  8030ae:	6a 0a                	push   $0xa
  8030b0:	e8 01 ff ff ff       	call   802fb6 <syscall>
  8030b5:	83 c4 18             	add    $0x18,%esp
}
  8030b8:	c9                   	leave  
  8030b9:	c3                   	ret    

008030ba <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8030ba:	55                   	push   %ebp
  8030bb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8030bd:	6a 00                	push   $0x0
  8030bf:	6a 00                	push   $0x0
  8030c1:	6a 00                	push   $0x0
  8030c3:	ff 75 0c             	pushl  0xc(%ebp)
  8030c6:	ff 75 08             	pushl  0x8(%ebp)
  8030c9:	6a 0b                	push   $0xb
  8030cb:	e8 e6 fe ff ff       	call   802fb6 <syscall>
  8030d0:	83 c4 18             	add    $0x18,%esp
}
  8030d3:	c9                   	leave  
  8030d4:	c3                   	ret    

008030d5 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8030d5:	55                   	push   %ebp
  8030d6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8030d8:	6a 00                	push   $0x0
  8030da:	6a 00                	push   $0x0
  8030dc:	6a 00                	push   $0x0
  8030de:	6a 00                	push   $0x0
  8030e0:	6a 00                	push   $0x0
  8030e2:	6a 0c                	push   $0xc
  8030e4:	e8 cd fe ff ff       	call   802fb6 <syscall>
  8030e9:	83 c4 18             	add    $0x18,%esp
}
  8030ec:	c9                   	leave  
  8030ed:	c3                   	ret    

008030ee <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8030ee:	55                   	push   %ebp
  8030ef:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8030f1:	6a 00                	push   $0x0
  8030f3:	6a 00                	push   $0x0
  8030f5:	6a 00                	push   $0x0
  8030f7:	6a 00                	push   $0x0
  8030f9:	6a 00                	push   $0x0
  8030fb:	6a 0d                	push   $0xd
  8030fd:	e8 b4 fe ff ff       	call   802fb6 <syscall>
  803102:	83 c4 18             	add    $0x18,%esp
}
  803105:	c9                   	leave  
  803106:	c3                   	ret    

00803107 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  803107:	55                   	push   %ebp
  803108:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  80310a:	6a 00                	push   $0x0
  80310c:	6a 00                	push   $0x0
  80310e:	6a 00                	push   $0x0
  803110:	6a 00                	push   $0x0
  803112:	6a 00                	push   $0x0
  803114:	6a 0e                	push   $0xe
  803116:	e8 9b fe ff ff       	call   802fb6 <syscall>
  80311b:	83 c4 18             	add    $0x18,%esp
}
  80311e:	c9                   	leave  
  80311f:	c3                   	ret    

00803120 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  803120:	55                   	push   %ebp
  803121:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  803123:	6a 00                	push   $0x0
  803125:	6a 00                	push   $0x0
  803127:	6a 00                	push   $0x0
  803129:	6a 00                	push   $0x0
  80312b:	6a 00                	push   $0x0
  80312d:	6a 0f                	push   $0xf
  80312f:	e8 82 fe ff ff       	call   802fb6 <syscall>
  803134:	83 c4 18             	add    $0x18,%esp
}
  803137:	c9                   	leave  
  803138:	c3                   	ret    

00803139 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  803139:	55                   	push   %ebp
  80313a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  80313c:	6a 00                	push   $0x0
  80313e:	6a 00                	push   $0x0
  803140:	6a 00                	push   $0x0
  803142:	6a 00                	push   $0x0
  803144:	ff 75 08             	pushl  0x8(%ebp)
  803147:	6a 10                	push   $0x10
  803149:	e8 68 fe ff ff       	call   802fb6 <syscall>
  80314e:	83 c4 18             	add    $0x18,%esp
}
  803151:	c9                   	leave  
  803152:	c3                   	ret    

00803153 <sys_scarce_memory>:

void sys_scarce_memory()
{
  803153:	55                   	push   %ebp
  803154:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  803156:	6a 00                	push   $0x0
  803158:	6a 00                	push   $0x0
  80315a:	6a 00                	push   $0x0
  80315c:	6a 00                	push   $0x0
  80315e:	6a 00                	push   $0x0
  803160:	6a 11                	push   $0x11
  803162:	e8 4f fe ff ff       	call   802fb6 <syscall>
  803167:	83 c4 18             	add    $0x18,%esp
}
  80316a:	90                   	nop
  80316b:	c9                   	leave  
  80316c:	c3                   	ret    

0080316d <sys_cputc>:

void
sys_cputc(const char c)
{
  80316d:	55                   	push   %ebp
  80316e:	89 e5                	mov    %esp,%ebp
  803170:	83 ec 04             	sub    $0x4,%esp
  803173:	8b 45 08             	mov    0x8(%ebp),%eax
  803176:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  803179:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80317d:	6a 00                	push   $0x0
  80317f:	6a 00                	push   $0x0
  803181:	6a 00                	push   $0x0
  803183:	6a 00                	push   $0x0
  803185:	50                   	push   %eax
  803186:	6a 01                	push   $0x1
  803188:	e8 29 fe ff ff       	call   802fb6 <syscall>
  80318d:	83 c4 18             	add    $0x18,%esp
}
  803190:	90                   	nop
  803191:	c9                   	leave  
  803192:	c3                   	ret    

00803193 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  803193:	55                   	push   %ebp
  803194:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  803196:	6a 00                	push   $0x0
  803198:	6a 00                	push   $0x0
  80319a:	6a 00                	push   $0x0
  80319c:	6a 00                	push   $0x0
  80319e:	6a 00                	push   $0x0
  8031a0:	6a 14                	push   $0x14
  8031a2:	e8 0f fe ff ff       	call   802fb6 <syscall>
  8031a7:	83 c4 18             	add    $0x18,%esp
}
  8031aa:	90                   	nop
  8031ab:	c9                   	leave  
  8031ac:	c3                   	ret    

008031ad <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8031ad:	55                   	push   %ebp
  8031ae:	89 e5                	mov    %esp,%ebp
  8031b0:	83 ec 04             	sub    $0x4,%esp
  8031b3:	8b 45 10             	mov    0x10(%ebp),%eax
  8031b6:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8031b9:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8031bc:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8031c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8031c3:	6a 00                	push   $0x0
  8031c5:	51                   	push   %ecx
  8031c6:	52                   	push   %edx
  8031c7:	ff 75 0c             	pushl  0xc(%ebp)
  8031ca:	50                   	push   %eax
  8031cb:	6a 15                	push   $0x15
  8031cd:	e8 e4 fd ff ff       	call   802fb6 <syscall>
  8031d2:	83 c4 18             	add    $0x18,%esp
}
  8031d5:	c9                   	leave  
  8031d6:	c3                   	ret    

008031d7 <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  8031d7:	55                   	push   %ebp
  8031d8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8031da:	8b 55 0c             	mov    0xc(%ebp),%edx
  8031dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8031e0:	6a 00                	push   $0x0
  8031e2:	6a 00                	push   $0x0
  8031e4:	6a 00                	push   $0x0
  8031e6:	52                   	push   %edx
  8031e7:	50                   	push   %eax
  8031e8:	6a 16                	push   $0x16
  8031ea:	e8 c7 fd ff ff       	call   802fb6 <syscall>
  8031ef:	83 c4 18             	add    $0x18,%esp
}
  8031f2:	c9                   	leave  
  8031f3:	c3                   	ret    

008031f4 <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  8031f4:	55                   	push   %ebp
  8031f5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8031f7:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8031fa:	8b 55 0c             	mov    0xc(%ebp),%edx
  8031fd:	8b 45 08             	mov    0x8(%ebp),%eax
  803200:	6a 00                	push   $0x0
  803202:	6a 00                	push   $0x0
  803204:	51                   	push   %ecx
  803205:	52                   	push   %edx
  803206:	50                   	push   %eax
  803207:	6a 17                	push   $0x17
  803209:	e8 a8 fd ff ff       	call   802fb6 <syscall>
  80320e:	83 c4 18             	add    $0x18,%esp
}
  803211:	c9                   	leave  
  803212:	c3                   	ret    

00803213 <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  803213:	55                   	push   %ebp
  803214:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  803216:	8b 55 0c             	mov    0xc(%ebp),%edx
  803219:	8b 45 08             	mov    0x8(%ebp),%eax
  80321c:	6a 00                	push   $0x0
  80321e:	6a 00                	push   $0x0
  803220:	6a 00                	push   $0x0
  803222:	52                   	push   %edx
  803223:	50                   	push   %eax
  803224:	6a 18                	push   $0x18
  803226:	e8 8b fd ff ff       	call   802fb6 <syscall>
  80322b:	83 c4 18             	add    $0x18,%esp
}
  80322e:	c9                   	leave  
  80322f:	c3                   	ret    

00803230 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  803230:	55                   	push   %ebp
  803231:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  803233:	8b 45 08             	mov    0x8(%ebp),%eax
  803236:	6a 00                	push   $0x0
  803238:	ff 75 14             	pushl  0x14(%ebp)
  80323b:	ff 75 10             	pushl  0x10(%ebp)
  80323e:	ff 75 0c             	pushl  0xc(%ebp)
  803241:	50                   	push   %eax
  803242:	6a 19                	push   $0x19
  803244:	e8 6d fd ff ff       	call   802fb6 <syscall>
  803249:	83 c4 18             	add    $0x18,%esp
}
  80324c:	c9                   	leave  
  80324d:	c3                   	ret    

0080324e <sys_run_env>:

void sys_run_env(int32 envId)
{
  80324e:	55                   	push   %ebp
  80324f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  803251:	8b 45 08             	mov    0x8(%ebp),%eax
  803254:	6a 00                	push   $0x0
  803256:	6a 00                	push   $0x0
  803258:	6a 00                	push   $0x0
  80325a:	6a 00                	push   $0x0
  80325c:	50                   	push   %eax
  80325d:	6a 1a                	push   $0x1a
  80325f:	e8 52 fd ff ff       	call   802fb6 <syscall>
  803264:	83 c4 18             	add    $0x18,%esp
}
  803267:	90                   	nop
  803268:	c9                   	leave  
  803269:	c3                   	ret    

0080326a <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  80326a:	55                   	push   %ebp
  80326b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  80326d:	8b 45 08             	mov    0x8(%ebp),%eax
  803270:	6a 00                	push   $0x0
  803272:	6a 00                	push   $0x0
  803274:	6a 00                	push   $0x0
  803276:	6a 00                	push   $0x0
  803278:	50                   	push   %eax
  803279:	6a 1b                	push   $0x1b
  80327b:	e8 36 fd ff ff       	call   802fb6 <syscall>
  803280:	83 c4 18             	add    $0x18,%esp
}
  803283:	c9                   	leave  
  803284:	c3                   	ret    

00803285 <sys_getenvid>:

int32 sys_getenvid(void)
{
  803285:	55                   	push   %ebp
  803286:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  803288:	6a 00                	push   $0x0
  80328a:	6a 00                	push   $0x0
  80328c:	6a 00                	push   $0x0
  80328e:	6a 00                	push   $0x0
  803290:	6a 00                	push   $0x0
  803292:	6a 05                	push   $0x5
  803294:	e8 1d fd ff ff       	call   802fb6 <syscall>
  803299:	83 c4 18             	add    $0x18,%esp
}
  80329c:	c9                   	leave  
  80329d:	c3                   	ret    

0080329e <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  80329e:	55                   	push   %ebp
  80329f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8032a1:	6a 00                	push   $0x0
  8032a3:	6a 00                	push   $0x0
  8032a5:	6a 00                	push   $0x0
  8032a7:	6a 00                	push   $0x0
  8032a9:	6a 00                	push   $0x0
  8032ab:	6a 06                	push   $0x6
  8032ad:	e8 04 fd ff ff       	call   802fb6 <syscall>
  8032b2:	83 c4 18             	add    $0x18,%esp
}
  8032b5:	c9                   	leave  
  8032b6:	c3                   	ret    

008032b7 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8032b7:	55                   	push   %ebp
  8032b8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8032ba:	6a 00                	push   $0x0
  8032bc:	6a 00                	push   $0x0
  8032be:	6a 00                	push   $0x0
  8032c0:	6a 00                	push   $0x0
  8032c2:	6a 00                	push   $0x0
  8032c4:	6a 07                	push   $0x7
  8032c6:	e8 eb fc ff ff       	call   802fb6 <syscall>
  8032cb:	83 c4 18             	add    $0x18,%esp
}
  8032ce:	c9                   	leave  
  8032cf:	c3                   	ret    

008032d0 <sys_exit_env>:


void sys_exit_env(void)
{
  8032d0:	55                   	push   %ebp
  8032d1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  8032d3:	6a 00                	push   $0x0
  8032d5:	6a 00                	push   $0x0
  8032d7:	6a 00                	push   $0x0
  8032d9:	6a 00                	push   $0x0
  8032db:	6a 00                	push   $0x0
  8032dd:	6a 1c                	push   $0x1c
  8032df:	e8 d2 fc ff ff       	call   802fb6 <syscall>
  8032e4:	83 c4 18             	add    $0x18,%esp
}
  8032e7:	90                   	nop
  8032e8:	c9                   	leave  
  8032e9:	c3                   	ret    

008032ea <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  8032ea:	55                   	push   %ebp
  8032eb:	89 e5                	mov    %esp,%ebp
  8032ed:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8032f0:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8032f3:	8d 50 04             	lea    0x4(%eax),%edx
  8032f6:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8032f9:	6a 00                	push   $0x0
  8032fb:	6a 00                	push   $0x0
  8032fd:	6a 00                	push   $0x0
  8032ff:	52                   	push   %edx
  803300:	50                   	push   %eax
  803301:	6a 1d                	push   $0x1d
  803303:	e8 ae fc ff ff       	call   802fb6 <syscall>
  803308:	83 c4 18             	add    $0x18,%esp
	return result;
  80330b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80330e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  803311:	8b 55 fc             	mov    -0x4(%ebp),%edx
  803314:	89 01                	mov    %eax,(%ecx)
  803316:	89 51 04             	mov    %edx,0x4(%ecx)
}
  803319:	8b 45 08             	mov    0x8(%ebp),%eax
  80331c:	c9                   	leave  
  80331d:	c2 04 00             	ret    $0x4

00803320 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  803320:	55                   	push   %ebp
  803321:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  803323:	6a 00                	push   $0x0
  803325:	6a 00                	push   $0x0
  803327:	ff 75 10             	pushl  0x10(%ebp)
  80332a:	ff 75 0c             	pushl  0xc(%ebp)
  80332d:	ff 75 08             	pushl  0x8(%ebp)
  803330:	6a 13                	push   $0x13
  803332:	e8 7f fc ff ff       	call   802fb6 <syscall>
  803337:	83 c4 18             	add    $0x18,%esp
	return ;
  80333a:	90                   	nop
}
  80333b:	c9                   	leave  
  80333c:	c3                   	ret    

0080333d <sys_rcr2>:
uint32 sys_rcr2()
{
  80333d:	55                   	push   %ebp
  80333e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  803340:	6a 00                	push   $0x0
  803342:	6a 00                	push   $0x0
  803344:	6a 00                	push   $0x0
  803346:	6a 00                	push   $0x0
  803348:	6a 00                	push   $0x0
  80334a:	6a 1e                	push   $0x1e
  80334c:	e8 65 fc ff ff       	call   802fb6 <syscall>
  803351:	83 c4 18             	add    $0x18,%esp
}
  803354:	c9                   	leave  
  803355:	c3                   	ret    

00803356 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  803356:	55                   	push   %ebp
  803357:	89 e5                	mov    %esp,%ebp
  803359:	83 ec 04             	sub    $0x4,%esp
  80335c:	8b 45 08             	mov    0x8(%ebp),%eax
  80335f:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  803362:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  803366:	6a 00                	push   $0x0
  803368:	6a 00                	push   $0x0
  80336a:	6a 00                	push   $0x0
  80336c:	6a 00                	push   $0x0
  80336e:	50                   	push   %eax
  80336f:	6a 1f                	push   $0x1f
  803371:	e8 40 fc ff ff       	call   802fb6 <syscall>
  803376:	83 c4 18             	add    $0x18,%esp
	return ;
  803379:	90                   	nop
}
  80337a:	c9                   	leave  
  80337b:	c3                   	ret    

0080337c <rsttst>:
void rsttst()
{
  80337c:	55                   	push   %ebp
  80337d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  80337f:	6a 00                	push   $0x0
  803381:	6a 00                	push   $0x0
  803383:	6a 00                	push   $0x0
  803385:	6a 00                	push   $0x0
  803387:	6a 00                	push   $0x0
  803389:	6a 21                	push   $0x21
  80338b:	e8 26 fc ff ff       	call   802fb6 <syscall>
  803390:	83 c4 18             	add    $0x18,%esp
	return ;
  803393:	90                   	nop
}
  803394:	c9                   	leave  
  803395:	c3                   	ret    

00803396 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  803396:	55                   	push   %ebp
  803397:	89 e5                	mov    %esp,%ebp
  803399:	83 ec 04             	sub    $0x4,%esp
  80339c:	8b 45 14             	mov    0x14(%ebp),%eax
  80339f:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8033a2:	8b 55 18             	mov    0x18(%ebp),%edx
  8033a5:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8033a9:	52                   	push   %edx
  8033aa:	50                   	push   %eax
  8033ab:	ff 75 10             	pushl  0x10(%ebp)
  8033ae:	ff 75 0c             	pushl  0xc(%ebp)
  8033b1:	ff 75 08             	pushl  0x8(%ebp)
  8033b4:	6a 20                	push   $0x20
  8033b6:	e8 fb fb ff ff       	call   802fb6 <syscall>
  8033bb:	83 c4 18             	add    $0x18,%esp
	return ;
  8033be:	90                   	nop
}
  8033bf:	c9                   	leave  
  8033c0:	c3                   	ret    

008033c1 <chktst>:
void chktst(uint32 n)
{
  8033c1:	55                   	push   %ebp
  8033c2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8033c4:	6a 00                	push   $0x0
  8033c6:	6a 00                	push   $0x0
  8033c8:	6a 00                	push   $0x0
  8033ca:	6a 00                	push   $0x0
  8033cc:	ff 75 08             	pushl  0x8(%ebp)
  8033cf:	6a 22                	push   $0x22
  8033d1:	e8 e0 fb ff ff       	call   802fb6 <syscall>
  8033d6:	83 c4 18             	add    $0x18,%esp
	return ;
  8033d9:	90                   	nop
}
  8033da:	c9                   	leave  
  8033db:	c3                   	ret    

008033dc <inctst>:

void inctst()
{
  8033dc:	55                   	push   %ebp
  8033dd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8033df:	6a 00                	push   $0x0
  8033e1:	6a 00                	push   $0x0
  8033e3:	6a 00                	push   $0x0
  8033e5:	6a 00                	push   $0x0
  8033e7:	6a 00                	push   $0x0
  8033e9:	6a 23                	push   $0x23
  8033eb:	e8 c6 fb ff ff       	call   802fb6 <syscall>
  8033f0:	83 c4 18             	add    $0x18,%esp
	return ;
  8033f3:	90                   	nop
}
  8033f4:	c9                   	leave  
  8033f5:	c3                   	ret    

008033f6 <gettst>:
uint32 gettst()
{
  8033f6:	55                   	push   %ebp
  8033f7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8033f9:	6a 00                	push   $0x0
  8033fb:	6a 00                	push   $0x0
  8033fd:	6a 00                	push   $0x0
  8033ff:	6a 00                	push   $0x0
  803401:	6a 00                	push   $0x0
  803403:	6a 24                	push   $0x24
  803405:	e8 ac fb ff ff       	call   802fb6 <syscall>
  80340a:	83 c4 18             	add    $0x18,%esp
}
  80340d:	c9                   	leave  
  80340e:	c3                   	ret    

0080340f <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  80340f:	55                   	push   %ebp
  803410:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  803412:	6a 00                	push   $0x0
  803414:	6a 00                	push   $0x0
  803416:	6a 00                	push   $0x0
  803418:	6a 00                	push   $0x0
  80341a:	6a 00                	push   $0x0
  80341c:	6a 25                	push   $0x25
  80341e:	e8 93 fb ff ff       	call   802fb6 <syscall>
  803423:	83 c4 18             	add    $0x18,%esp
  803426:	a3 60 d0 81 00       	mov    %eax,0x81d060
	return uheapPlaceStrategy ;
  80342b:	a1 60 d0 81 00       	mov    0x81d060,%eax
}
  803430:	c9                   	leave  
  803431:	c3                   	ret    

00803432 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  803432:	55                   	push   %ebp
  803433:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  803435:	8b 45 08             	mov    0x8(%ebp),%eax
  803438:	a3 60 d0 81 00       	mov    %eax,0x81d060
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  80343d:	6a 00                	push   $0x0
  80343f:	6a 00                	push   $0x0
  803441:	6a 00                	push   $0x0
  803443:	6a 00                	push   $0x0
  803445:	ff 75 08             	pushl  0x8(%ebp)
  803448:	6a 26                	push   $0x26
  80344a:	e8 67 fb ff ff       	call   802fb6 <syscall>
  80344f:	83 c4 18             	add    $0x18,%esp
	return ;
  803452:	90                   	nop
}
  803453:	c9                   	leave  
  803454:	c3                   	ret    

00803455 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  803455:	55                   	push   %ebp
  803456:	89 e5                	mov    %esp,%ebp
  803458:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  803459:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80345c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80345f:	8b 55 0c             	mov    0xc(%ebp),%edx
  803462:	8b 45 08             	mov    0x8(%ebp),%eax
  803465:	6a 00                	push   $0x0
  803467:	53                   	push   %ebx
  803468:	51                   	push   %ecx
  803469:	52                   	push   %edx
  80346a:	50                   	push   %eax
  80346b:	6a 27                	push   $0x27
  80346d:	e8 44 fb ff ff       	call   802fb6 <syscall>
  803472:	83 c4 18             	add    $0x18,%esp
}
  803475:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  803478:	c9                   	leave  
  803479:	c3                   	ret    

0080347a <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  80347a:	55                   	push   %ebp
  80347b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  80347d:	8b 55 0c             	mov    0xc(%ebp),%edx
  803480:	8b 45 08             	mov    0x8(%ebp),%eax
  803483:	6a 00                	push   $0x0
  803485:	6a 00                	push   $0x0
  803487:	6a 00                	push   $0x0
  803489:	52                   	push   %edx
  80348a:	50                   	push   %eax
  80348b:	6a 28                	push   $0x28
  80348d:	e8 24 fb ff ff       	call   802fb6 <syscall>
  803492:	83 c4 18             	add    $0x18,%esp
}
  803495:	c9                   	leave  
  803496:	c3                   	ret    

00803497 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  803497:	55                   	push   %ebp
  803498:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  80349a:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80349d:	8b 55 0c             	mov    0xc(%ebp),%edx
  8034a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8034a3:	6a 00                	push   $0x0
  8034a5:	51                   	push   %ecx
  8034a6:	ff 75 10             	pushl  0x10(%ebp)
  8034a9:	52                   	push   %edx
  8034aa:	50                   	push   %eax
  8034ab:	6a 29                	push   $0x29
  8034ad:	e8 04 fb ff ff       	call   802fb6 <syscall>
  8034b2:	83 c4 18             	add    $0x18,%esp
}
  8034b5:	c9                   	leave  
  8034b6:	c3                   	ret    

008034b7 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8034b7:	55                   	push   %ebp
  8034b8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8034ba:	6a 00                	push   $0x0
  8034bc:	6a 00                	push   $0x0
  8034be:	ff 75 10             	pushl  0x10(%ebp)
  8034c1:	ff 75 0c             	pushl  0xc(%ebp)
  8034c4:	ff 75 08             	pushl  0x8(%ebp)
  8034c7:	6a 12                	push   $0x12
  8034c9:	e8 e8 fa ff ff       	call   802fb6 <syscall>
  8034ce:	83 c4 18             	add    $0x18,%esp
	return ;
  8034d1:	90                   	nop
}
  8034d2:	c9                   	leave  
  8034d3:	c3                   	ret    

008034d4 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  8034d4:	55                   	push   %ebp
  8034d5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  8034d7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8034da:	8b 45 08             	mov    0x8(%ebp),%eax
  8034dd:	6a 00                	push   $0x0
  8034df:	6a 00                	push   $0x0
  8034e1:	6a 00                	push   $0x0
  8034e3:	52                   	push   %edx
  8034e4:	50                   	push   %eax
  8034e5:	6a 2a                	push   $0x2a
  8034e7:	e8 ca fa ff ff       	call   802fb6 <syscall>
  8034ec:	83 c4 18             	add    $0x18,%esp
	return;
  8034ef:	90                   	nop
}
  8034f0:	c9                   	leave  
  8034f1:	c3                   	ret    

008034f2 <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  8034f2:	55                   	push   %ebp
  8034f3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  8034f5:	6a 00                	push   $0x0
  8034f7:	6a 00                	push   $0x0
  8034f9:	6a 00                	push   $0x0
  8034fb:	6a 00                	push   $0x0
  8034fd:	6a 00                	push   $0x0
  8034ff:	6a 2b                	push   $0x2b
  803501:	e8 b0 fa ff ff       	call   802fb6 <syscall>
  803506:	83 c4 18             	add    $0x18,%esp
}
  803509:	c9                   	leave  
  80350a:	c3                   	ret    

0080350b <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  80350b:	55                   	push   %ebp
  80350c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  80350e:	6a 00                	push   $0x0
  803510:	6a 00                	push   $0x0
  803512:	6a 00                	push   $0x0
  803514:	ff 75 0c             	pushl  0xc(%ebp)
  803517:	ff 75 08             	pushl  0x8(%ebp)
  80351a:	6a 2d                	push   $0x2d
  80351c:	e8 95 fa ff ff       	call   802fb6 <syscall>
  803521:	83 c4 18             	add    $0x18,%esp
	return;
  803524:	90                   	nop
}
  803525:	c9                   	leave  
  803526:	c3                   	ret    

00803527 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  803527:	55                   	push   %ebp
  803528:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  80352a:	6a 00                	push   $0x0
  80352c:	6a 00                	push   $0x0
  80352e:	6a 00                	push   $0x0
  803530:	ff 75 0c             	pushl  0xc(%ebp)
  803533:	ff 75 08             	pushl  0x8(%ebp)
  803536:	6a 2c                	push   $0x2c
  803538:	e8 79 fa ff ff       	call   802fb6 <syscall>
  80353d:	83 c4 18             	add    $0x18,%esp
	return ;
  803540:	90                   	nop
}
  803541:	c9                   	leave  
  803542:	c3                   	ret    

00803543 <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  803543:	55                   	push   %ebp
  803544:	89 e5                	mov    %esp,%ebp
	//TODO: [PROJECT'25.IM#4] CPU SCHEDULING - #1 System Calls - Add suitable code here
	//Your code is here
	//Comment the following line
	//panic("sys_env_set_priority() is not implemented yet...!!");
	syscall(SYS_env_set_priority, envID, priority, 0, 0, 0);
  803546:	8b 55 0c             	mov    0xc(%ebp),%edx
  803549:	8b 45 08             	mov    0x8(%ebp),%eax
  80354c:	6a 00                	push   $0x0
  80354e:	6a 00                	push   $0x0
  803550:	6a 00                	push   $0x0
  803552:	52                   	push   %edx
  803553:	50                   	push   %eax
  803554:	6a 2e                	push   $0x2e
  803556:	e8 5b fa ff ff       	call   802fb6 <syscall>
  80355b:	83 c4 18             	add    $0x18,%esp
	    return;
  80355e:	90                   	nop
}
  80355f:	c9                   	leave  
  803560:	c3                   	ret    

00803561 <to_page_va>:
//==================================================================================//
//==================================
// [1] GET PAGE VA:
//==================================
__inline__ uint32 to_page_va(struct PageInfoElement *ptrPageInfo)
{
  803561:	55                   	push   %ebp
  803562:	89 e5                	mov    %esp,%ebp
  803564:	83 ec 10             	sub    $0x10,%esp
	//Get start VA of the page from the corresponding Page Info pointer
	int idxInPageInfoArr = (ptrPageInfo - pageBlockInfoArr);
  803567:	8b 45 08             	mov    0x8(%ebp),%eax
  80356a:	ba 60 50 80 00       	mov    $0x805060,%edx
  80356f:	29 d0                	sub    %edx,%eax
  803571:	c1 f8 02             	sar    $0x2,%eax
  803574:	89 c2                	mov    %eax,%edx
  803576:	89 d0                	mov    %edx,%eax
  803578:	c1 e0 02             	shl    $0x2,%eax
  80357b:	01 d0                	add    %edx,%eax
  80357d:	c1 e0 02             	shl    $0x2,%eax
  803580:	01 d0                	add    %edx,%eax
  803582:	c1 e0 02             	shl    $0x2,%eax
  803585:	01 d0                	add    %edx,%eax
  803587:	89 c1                	mov    %eax,%ecx
  803589:	c1 e1 08             	shl    $0x8,%ecx
  80358c:	01 c8                	add    %ecx,%eax
  80358e:	89 c1                	mov    %eax,%ecx
  803590:	c1 e1 10             	shl    $0x10,%ecx
  803593:	01 c8                	add    %ecx,%eax
  803595:	01 c0                	add    %eax,%eax
  803597:	01 d0                	add    %edx,%eax
  803599:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return dynAllocStart + (idxInPageInfoArr << PGSHIFT);
  80359c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80359f:	c1 e0 0c             	shl    $0xc,%eax
  8035a2:	89 c2                	mov    %eax,%edx
  8035a4:	a1 64 d0 81 00       	mov    0x81d064,%eax
  8035a9:	01 d0                	add    %edx,%eax
}
  8035ab:	c9                   	leave  
  8035ac:	c3                   	ret    

008035ad <log2>:

//==================================================================================//
//============================ REQUIRED FUNCTIONS ==================================//
//==================================================================================//
__inline__ int log2(uint32 n)
	{
  8035ad:	55                   	push   %ebp
  8035ae:	89 e5                	mov    %esp,%ebp
  8035b0:	83 ec 10             	sub    $0x10,%esp
		int result = 0;
  8035b3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
		while( n > 1){
  8035ba:	eb 06                	jmp    8035c2 <log2+0x15>
			n >>=1;
  8035bc:	d1 6d 08             	shrl   0x8(%ebp)
			result++;
  8035bf:	ff 45 fc             	incl   -0x4(%ebp)
//============================ REQUIRED FUNCTIONS ==================================//
//==================================================================================//
__inline__ int log2(uint32 n)
	{
		int result = 0;
		while( n > 1){
  8035c2:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
  8035c6:	77 f4                	ja     8035bc <log2+0xf>
			n >>=1;
			result++;
		}
		return result;
  8035c8:	8b 45 fc             	mov    -0x4(%ebp),%eax
	}
  8035cb:	c9                   	leave  
  8035cc:	c3                   	ret    

008035cd <initialize_dynamic_allocator>:
//==================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================
bool is_initialized = 0;
void initialize_dynamic_allocator(uint32 daStart, uint32 daEnd)
{
  8035cd:	55                   	push   %ebp
  8035ce:	89 e5                	mov    %esp,%ebp
  8035d0:	83 ec 18             	sub    $0x18,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(daEnd <= daStart + DYN_ALLOC_MAX_SIZE);
  8035d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8035d6:	05 00 00 00 02       	add    $0x2000000,%eax
  8035db:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8035de:	73 16                	jae    8035f6 <initialize_dynamic_allocator+0x29>
  8035e0:	68 58 4d 80 00       	push   $0x804d58
  8035e5:	68 7e 4d 80 00       	push   $0x804d7e
  8035ea:	6a 2d                	push   $0x2d
  8035ec:	68 93 4d 80 00       	push   $0x804d93
  8035f1:	e8 a6 ce ff ff       	call   80049c <_panic>
		is_initialized = 1;
  8035f6:	c7 05 24 50 80 00 01 	movl   $0x1,0x805024
  8035fd:	00 00 00 
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #1 initialize_dynamic_allocator
	//Your code is here


	dynAllocStart = daStart;
  803600:	8b 45 08             	mov    0x8(%ebp),%eax
  803603:	a3 64 d0 81 00       	mov    %eax,0x81d064
	dynAllocEnd= daEnd;
  803608:	8b 45 0c             	mov    0xc(%ebp),%eax
  80360b:	a3 40 50 80 00       	mov    %eax,0x805040
	int numOfPages = (dynAllocEnd - dynAllocStart)/PAGE_SIZE;
  803610:	8b 15 40 50 80 00    	mov    0x805040,%edx
  803616:	a1 64 d0 81 00       	mov    0x81d064,%eax
  80361b:	29 c2                	sub    %eax,%edx
  80361d:	89 d0                	mov    %edx,%eax
  80361f:	c1 e8 0c             	shr    $0xc,%eax
  803622:	89 45 e8             	mov    %eax,-0x18(%ebp)


	for(int i=0; i< numOfPages; i++){
  803625:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80362c:	eb 2f                	jmp    80365d <initialize_dynamic_allocator+0x90>
	    pageBlockInfoArr[i].block_size=0;
  80362e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803631:	89 d0                	mov    %edx,%eax
  803633:	01 c0                	add    %eax,%eax
  803635:	01 d0                	add    %edx,%eax
  803637:	c1 e0 02             	shl    $0x2,%eax
  80363a:	05 68 50 80 00       	add    $0x805068,%eax
  80363f:	66 c7 00 00 00       	movw   $0x0,(%eax)
	    pageBlockInfoArr[i].num_of_free_blocks=0;
  803644:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803647:	89 d0                	mov    %edx,%eax
  803649:	01 c0                	add    %eax,%eax
  80364b:	01 d0                	add    %edx,%eax
  80364d:	c1 e0 02             	shl    $0x2,%eax
  803650:	05 6a 50 80 00       	add    $0x80506a,%eax
  803655:	66 c7 00 00 00       	movw   $0x0,(%eax)
	dynAllocStart = daStart;
	dynAllocEnd= daEnd;
	int numOfPages = (dynAllocEnd - dynAllocStart)/PAGE_SIZE;


	for(int i=0; i< numOfPages; i++){
  80365a:	ff 45 f4             	incl   -0xc(%ebp)
  80365d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803660:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803663:	7c c9                	jl     80362e <initialize_dynamic_allocator+0x61>
	    pageBlockInfoArr[i].block_size=0;
	    pageBlockInfoArr[i].num_of_free_blocks=0;
	}


	LIST_INIT(&freePagesList);
  803665:	c7 05 48 50 80 00 00 	movl   $0x0,0x805048
  80366c:	00 00 00 
  80366f:	c7 05 4c 50 80 00 00 	movl   $0x0,0x80504c
  803676:	00 00 00 
  803679:	c7 05 54 50 80 00 00 	movl   $0x0,0x805054
  803680:	00 00 00 
	for(int i=0; i<numOfPages; i++){
  803683:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80368a:	e9 9c 00 00 00       	jmp    80372b <initialize_dynamic_allocator+0x15e>
		LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
  80368f:	8b 15 4c 50 80 00    	mov    0x80504c,%edx
  803695:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  803698:	89 c8                	mov    %ecx,%eax
  80369a:	01 c0                	add    %eax,%eax
  80369c:	01 c8                	add    %ecx,%eax
  80369e:	c1 e0 02             	shl    $0x2,%eax
  8036a1:	05 64 50 80 00       	add    $0x805064,%eax
  8036a6:	89 10                	mov    %edx,(%eax)
  8036a8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8036ab:	89 d0                	mov    %edx,%eax
  8036ad:	01 c0                	add    %eax,%eax
  8036af:	01 d0                	add    %edx,%eax
  8036b1:	c1 e0 02             	shl    $0x2,%eax
  8036b4:	05 64 50 80 00       	add    $0x805064,%eax
  8036b9:	8b 00                	mov    (%eax),%eax
  8036bb:	85 c0                	test   %eax,%eax
  8036bd:	74 1b                	je     8036da <initialize_dynamic_allocator+0x10d>
  8036bf:	8b 15 4c 50 80 00    	mov    0x80504c,%edx
  8036c5:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8036c8:	89 c8                	mov    %ecx,%eax
  8036ca:	01 c0                	add    %eax,%eax
  8036cc:	01 c8                	add    %ecx,%eax
  8036ce:	c1 e0 02             	shl    $0x2,%eax
  8036d1:	05 60 50 80 00       	add    $0x805060,%eax
  8036d6:	89 02                	mov    %eax,(%edx)
  8036d8:	eb 16                	jmp    8036f0 <initialize_dynamic_allocator+0x123>
  8036da:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8036dd:	89 d0                	mov    %edx,%eax
  8036df:	01 c0                	add    %eax,%eax
  8036e1:	01 d0                	add    %edx,%eax
  8036e3:	c1 e0 02             	shl    $0x2,%eax
  8036e6:	05 60 50 80 00       	add    $0x805060,%eax
  8036eb:	a3 48 50 80 00       	mov    %eax,0x805048
  8036f0:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8036f3:	89 d0                	mov    %edx,%eax
  8036f5:	01 c0                	add    %eax,%eax
  8036f7:	01 d0                	add    %edx,%eax
  8036f9:	c1 e0 02             	shl    $0x2,%eax
  8036fc:	05 60 50 80 00       	add    $0x805060,%eax
  803701:	a3 4c 50 80 00       	mov    %eax,0x80504c
  803706:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803709:	89 d0                	mov    %edx,%eax
  80370b:	01 c0                	add    %eax,%eax
  80370d:	01 d0                	add    %edx,%eax
  80370f:	c1 e0 02             	shl    $0x2,%eax
  803712:	05 60 50 80 00       	add    $0x805060,%eax
  803717:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80371d:	a1 54 50 80 00       	mov    0x805054,%eax
  803722:	40                   	inc    %eax
  803723:	a3 54 50 80 00       	mov    %eax,0x805054
	    pageBlockInfoArr[i].num_of_free_blocks=0;
	}


	LIST_INIT(&freePagesList);
	for(int i=0; i<numOfPages; i++){
  803728:	ff 45 f0             	incl   -0x10(%ebp)
  80372b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80372e:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803731:	0f 8c 58 ff ff ff    	jl     80368f <initialize_dynamic_allocator+0xc2>
		LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
	}



	for (int i = 0; i < LOG2_MAX_SIZE - LOG2_MIN_SIZE + 1; i++) {
  803737:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  80373e:	eb 36                	jmp    803776 <initialize_dynamic_allocator+0x1a9>
	    LIST_INIT(&freeBlockLists[i]);
  803740:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803743:	c1 e0 04             	shl    $0x4,%eax
  803746:	05 80 d0 81 00       	add    $0x81d080,%eax
  80374b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803751:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803754:	c1 e0 04             	shl    $0x4,%eax
  803757:	05 84 d0 81 00       	add    $0x81d084,%eax
  80375c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803762:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803765:	c1 e0 04             	shl    $0x4,%eax
  803768:	05 8c d0 81 00       	add    $0x81d08c,%eax
  80376d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
	}



	for (int i = 0; i < LOG2_MAX_SIZE - LOG2_MIN_SIZE + 1; i++) {
  803773:	ff 45 ec             	incl   -0x14(%ebp)
  803776:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  80377a:	7e c4                	jle    803740 <initialize_dynamic_allocator+0x173>


	//Comment the following line
	//panic("initialize_dynamic_allocator() Not implemented yet");

}
  80377c:	90                   	nop
  80377d:	c9                   	leave  
  80377e:	c3                   	ret    

0080377f <get_block_size>:
// [2] GET BLOCK SIZE:
//===========================


__inline__ uint32 get_block_size(void *va)
{
  80377f:	55                   	push   %ebp
  803780:	89 e5                	mov    %esp,%ebp
  803782:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #2 get_block_size
	//Your code is here

	uint32 page_index = ((uint32)va - dynAllocStart)/ PAGE_SIZE;
  803785:	8b 55 08             	mov    0x8(%ebp),%edx
  803788:	a1 64 d0 81 00       	mov    0x81d064,%eax
  80378d:	29 c2                	sub    %eax,%edx
  80378f:	89 d0                	mov    %edx,%eax
  803791:	c1 e8 0c             	shr    $0xc,%eax
  803794:	89 45 fc             	mov    %eax,-0x4(%ebp)
    return pageBlockInfoArr[page_index].block_size;
  803797:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80379a:	89 d0                	mov    %edx,%eax
  80379c:	01 c0                	add    %eax,%eax
  80379e:	01 d0                	add    %edx,%eax
  8037a0:	c1 e0 02             	shl    $0x2,%eax
  8037a3:	05 68 50 80 00       	add    $0x805068,%eax
  8037a8:	8b 00                	mov    (%eax),%eax
  8037aa:	0f b7 c0             	movzwl %ax,%eax
	//Comment the following line
	//panic("get_block_size() Not implemented yet");
}
  8037ad:	c9                   	leave  
  8037ae:	c3                   	ret    

008037af <alloc_block>:

//===========================
// 3) ALLOCATE BLOCK:
//===========================
void *alloc_block(uint32 size)
{
  8037af:	55                   	push   %ebp
  8037b0:	89 e5                	mov    %esp,%ebp
  8037b2:	83 ec 48             	sub    $0x48,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(size <= DYN_ALLOC_MAX_BLOCK_SIZE);
  8037b5:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  8037bc:	76 16                	jbe    8037d4 <alloc_block+0x25>
  8037be:	68 ac 4d 80 00       	push   $0x804dac
  8037c3:	68 7e 4d 80 00       	push   $0x804d7e
  8037c8:	6a 6c                	push   $0x6c
  8037ca:	68 93 4d 80 00       	push   $0x804d93
  8037cf:	e8 c8 cc ff ff       	call   80049c <_panic>
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #3 alloc_block
	//Your code is here


	if(size == 0){
  8037d4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8037d8:	75 0a                	jne    8037e4 <alloc_block+0x35>
		return NULL;
  8037da:	b8 00 00 00 00       	mov    $0x0,%eax
  8037df:	e9 65 04 00 00       	jmp    803c49 <alloc_block+0x49a>
	}
	else if(size<=8){
  8037e4:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  8037e8:	77 09                	ja     8037f3 <alloc_block+0x44>
		size=8;
  8037ea:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
  8037f1:	eb 1f                	jmp    803812 <alloc_block+0x63>
	}
	else{
		uint32 reqsize=8;
  8037f3:	c7 45 f4 08 00 00 00 	movl   $0x8,-0xc(%ebp)
		while(reqsize < size){
  8037fa:	eb 08                	jmp    803804 <alloc_block+0x55>
			reqsize*=2;
  8037fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037ff:	01 c0                	add    %eax,%eax
  803801:	89 45 f4             	mov    %eax,-0xc(%ebp)
	else if(size<=8){
		size=8;
	}
	else{
		uint32 reqsize=8;
		while(reqsize < size){
  803804:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803807:	3b 45 08             	cmp    0x8(%ebp),%eax
  80380a:	72 f0                	jb     8037fc <alloc_block+0x4d>
			reqsize*=2;
		}
		size= reqsize;
  80380c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80380f:	89 45 08             	mov    %eax,0x8(%ebp)
	}

	int list_index = log2(size)- LOG2_MIN_SIZE;
  803812:	83 ec 0c             	sub    $0xc,%esp
  803815:	ff 75 08             	pushl  0x8(%ebp)
  803818:	e8 90 fd ff ff       	call   8035ad <log2>
  80381d:	83 c4 10             	add    $0x10,%esp
  803820:	83 e8 03             	sub    $0x3,%eax
  803823:	89 45 e8             	mov    %eax,-0x18(%ebp)

	if(!LIST_EMPTY(&freeBlockLists[list_index])){
  803826:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803829:	c1 e0 04             	shl    $0x4,%eax
  80382c:	05 80 d0 81 00       	add    $0x81d080,%eax
  803831:	8b 00                	mov    (%eax),%eax
  803833:	85 c0                	test   %eax,%eax
  803835:	0f 84 fb 00 00 00    	je     803936 <alloc_block+0x187>
		struct BlockElement *block = LIST_FIRST(&freeBlockLists[list_index]);
  80383b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80383e:	c1 e0 04             	shl    $0x4,%eax
  803841:	05 80 d0 81 00       	add    $0x81d080,%eax
  803846:	8b 00                	mov    (%eax),%eax
  803848:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		LIST_REMOVE(&freeBlockLists[list_index], block);
  80384b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80384f:	75 17                	jne    803868 <alloc_block+0xb9>
  803851:	83 ec 04             	sub    $0x4,%esp
  803854:	68 cd 4d 80 00       	push   $0x804dcd
  803859:	68 86 00 00 00       	push   $0x86
  80385e:	68 93 4d 80 00       	push   $0x804d93
  803863:	e8 34 cc ff ff       	call   80049c <_panic>
  803868:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80386b:	8b 00                	mov    (%eax),%eax
  80386d:	85 c0                	test   %eax,%eax
  80386f:	74 10                	je     803881 <alloc_block+0xd2>
  803871:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803874:	8b 00                	mov    (%eax),%eax
  803876:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803879:	8b 52 04             	mov    0x4(%edx),%edx
  80387c:	89 50 04             	mov    %edx,0x4(%eax)
  80387f:	eb 14                	jmp    803895 <alloc_block+0xe6>
  803881:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803884:	8b 40 04             	mov    0x4(%eax),%eax
  803887:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80388a:	c1 e2 04             	shl    $0x4,%edx
  80388d:	81 c2 84 d0 81 00    	add    $0x81d084,%edx
  803893:	89 02                	mov    %eax,(%edx)
  803895:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803898:	8b 40 04             	mov    0x4(%eax),%eax
  80389b:	85 c0                	test   %eax,%eax
  80389d:	74 0f                	je     8038ae <alloc_block+0xff>
  80389f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038a2:	8b 40 04             	mov    0x4(%eax),%eax
  8038a5:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8038a8:	8b 12                	mov    (%edx),%edx
  8038aa:	89 10                	mov    %edx,(%eax)
  8038ac:	eb 13                	jmp    8038c1 <alloc_block+0x112>
  8038ae:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038b1:	8b 00                	mov    (%eax),%eax
  8038b3:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8038b6:	c1 e2 04             	shl    $0x4,%edx
  8038b9:	81 c2 80 d0 81 00    	add    $0x81d080,%edx
  8038bf:	89 02                	mov    %eax,(%edx)
  8038c1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038c4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8038ca:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038cd:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8038d4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8038d7:	c1 e0 04             	shl    $0x4,%eax
  8038da:	05 8c d0 81 00       	add    $0x81d08c,%eax
  8038df:	8b 00                	mov    (%eax),%eax
  8038e1:	8d 50 ff             	lea    -0x1(%eax),%edx
  8038e4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8038e7:	c1 e0 04             	shl    $0x4,%eax
  8038ea:	05 8c d0 81 00       	add    $0x81d08c,%eax
  8038ef:	89 10                	mov    %edx,(%eax)
		uint32 page_index = ((uint32)block - dynAllocStart)/ PAGE_SIZE;
  8038f1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8038f4:	a1 64 d0 81 00       	mov    0x81d064,%eax
  8038f9:	29 c2                	sub    %eax,%edx
  8038fb:	89 d0                	mov    %edx,%eax
  8038fd:	c1 e8 0c             	shr    $0xc,%eax
  803900:	89 45 e0             	mov    %eax,-0x20(%ebp)
		pageBlockInfoArr[page_index].num_of_free_blocks--;
  803903:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803906:	89 d0                	mov    %edx,%eax
  803908:	01 c0                	add    %eax,%eax
  80390a:	01 d0                	add    %edx,%eax
  80390c:	c1 e0 02             	shl    $0x2,%eax
  80390f:	05 6a 50 80 00       	add    $0x80506a,%eax
  803914:	66 8b 00             	mov    (%eax),%ax
  803917:	8d 50 ff             	lea    -0x1(%eax),%edx
  80391a:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  80391d:	89 c8                	mov    %ecx,%eax
  80391f:	01 c0                	add    %eax,%eax
  803921:	01 c8                	add    %ecx,%eax
  803923:	c1 e0 02             	shl    $0x2,%eax
  803926:	05 6a 50 80 00       	add    $0x80506a,%eax
  80392b:	66 89 10             	mov    %dx,(%eax)
		return (void*)block;
  80392e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803931:	e9 13 03 00 00       	jmp    803c49 <alloc_block+0x49a>
	}

	if(!LIST_EMPTY(&freePagesList)){
  803936:	a1 48 50 80 00       	mov    0x805048,%eax
  80393b:	85 c0                	test   %eax,%eax
  80393d:	0f 84 c9 01 00 00    	je     803b0c <alloc_block+0x35d>

		struct PageInfoElement *page_info = LIST_FIRST(&freePagesList);
  803943:	a1 48 50 80 00       	mov    0x805048,%eax
  803948:	89 45 dc             	mov    %eax,-0x24(%ebp)
		LIST_REMOVE(&freePagesList, page_info);
  80394b:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80394f:	75 17                	jne    803968 <alloc_block+0x1b9>
  803951:	83 ec 04             	sub    $0x4,%esp
  803954:	68 cd 4d 80 00       	push   $0x804dcd
  803959:	68 8f 00 00 00       	push   $0x8f
  80395e:	68 93 4d 80 00       	push   $0x804d93
  803963:	e8 34 cb ff ff       	call   80049c <_panic>
  803968:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80396b:	8b 00                	mov    (%eax),%eax
  80396d:	85 c0                	test   %eax,%eax
  80396f:	74 10                	je     803981 <alloc_block+0x1d2>
  803971:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803974:	8b 00                	mov    (%eax),%eax
  803976:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803979:	8b 52 04             	mov    0x4(%edx),%edx
  80397c:	89 50 04             	mov    %edx,0x4(%eax)
  80397f:	eb 0b                	jmp    80398c <alloc_block+0x1dd>
  803981:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803984:	8b 40 04             	mov    0x4(%eax),%eax
  803987:	a3 4c 50 80 00       	mov    %eax,0x80504c
  80398c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80398f:	8b 40 04             	mov    0x4(%eax),%eax
  803992:	85 c0                	test   %eax,%eax
  803994:	74 0f                	je     8039a5 <alloc_block+0x1f6>
  803996:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803999:	8b 40 04             	mov    0x4(%eax),%eax
  80399c:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80399f:	8b 12                	mov    (%edx),%edx
  8039a1:	89 10                	mov    %edx,(%eax)
  8039a3:	eb 0a                	jmp    8039af <alloc_block+0x200>
  8039a5:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8039a8:	8b 00                	mov    (%eax),%eax
  8039aa:	a3 48 50 80 00       	mov    %eax,0x805048
  8039af:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8039b2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8039b8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8039bb:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8039c2:	a1 54 50 80 00       	mov    0x805054,%eax
  8039c7:	48                   	dec    %eax
  8039c8:	a3 54 50 80 00       	mov    %eax,0x805054
		uint32 page_va = to_page_va(page_info);
  8039cd:	83 ec 0c             	sub    $0xc,%esp
  8039d0:	ff 75 dc             	pushl  -0x24(%ebp)
  8039d3:	e8 89 fb ff ff       	call   803561 <to_page_va>
  8039d8:	83 c4 10             	add    $0x10,%esp
  8039db:	89 45 d8             	mov    %eax,-0x28(%ebp)

		uint32 page_index = (page_va - dynAllocStart)/ PAGE_SIZE;
  8039de:	a1 64 d0 81 00       	mov    0x81d064,%eax
  8039e3:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8039e6:	29 c2                	sub    %eax,%edx
  8039e8:	89 d0                	mov    %edx,%eax
  8039ea:	c1 e8 0c             	shr    $0xc,%eax
  8039ed:	89 45 d4             	mov    %eax,-0x2c(%ebp)

		get_page((void*)page_va);
  8039f0:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8039f3:	83 ec 0c             	sub    $0xc,%esp
  8039f6:	50                   	push   %eax
  8039f7:	e8 fe dc ff ff       	call   8016fa <get_page>
  8039fc:	83 c4 10             	add    $0x10,%esp


		pageBlockInfoArr[page_index].block_size = size;
  8039ff:	8b 45 08             	mov    0x8(%ebp),%eax
  803a02:	89 c2                	mov    %eax,%edx
  803a04:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  803a07:	89 c8                	mov    %ecx,%eax
  803a09:	01 c0                	add    %eax,%eax
  803a0b:	01 c8                	add    %ecx,%eax
  803a0d:	c1 e0 02             	shl    $0x2,%eax
  803a10:	05 68 50 80 00       	add    $0x805068,%eax
  803a15:	66 89 10             	mov    %dx,(%eax)
		int num_blocks = PAGE_SIZE / size ;
  803a18:	b8 00 10 00 00       	mov    $0x1000,%eax
  803a1d:	ba 00 00 00 00       	mov    $0x0,%edx
  803a22:	f7 75 08             	divl   0x8(%ebp)
  803a25:	89 45 d0             	mov    %eax,-0x30(%ebp)
		pageBlockInfoArr[page_index].num_of_free_blocks= num_blocks - 1 ;
  803a28:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803a2b:	8d 50 ff             	lea    -0x1(%eax),%edx
  803a2e:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  803a31:	89 c8                	mov    %ecx,%eax
  803a33:	01 c0                	add    %eax,%eax
  803a35:	01 c8                	add    %ecx,%eax
  803a37:	c1 e0 02             	shl    $0x2,%eax
  803a3a:	05 6a 50 80 00       	add    $0x80506a,%eax
  803a3f:	66 89 10             	mov    %dx,(%eax)

		for(int i=1; i< num_blocks; i++){
  803a42:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
  803a49:	e9 aa 00 00 00       	jmp    803af8 <alloc_block+0x349>
			struct BlockElement *new_block = (struct BlockElement*)(page_va + i *size);
  803a4e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803a51:	0f af 45 08          	imul   0x8(%ebp),%eax
  803a55:	89 c2                	mov    %eax,%edx
  803a57:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803a5a:	01 d0                	add    %edx,%eax
  803a5c:	89 45 cc             	mov    %eax,-0x34(%ebp)
			LIST_INSERT_TAIL(&freeBlockLists[list_index], new_block);
  803a5f:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  803a63:	75 17                	jne    803a7c <alloc_block+0x2cd>
  803a65:	83 ec 04             	sub    $0x4,%esp
  803a68:	68 ec 4d 80 00       	push   $0x804dec
  803a6d:	68 9d 00 00 00       	push   $0x9d
  803a72:	68 93 4d 80 00       	push   $0x804d93
  803a77:	e8 20 ca ff ff       	call   80049c <_panic>
  803a7c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a7f:	c1 e0 04             	shl    $0x4,%eax
  803a82:	05 84 d0 81 00       	add    $0x81d084,%eax
  803a87:	8b 10                	mov    (%eax),%edx
  803a89:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803a8c:	89 50 04             	mov    %edx,0x4(%eax)
  803a8f:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803a92:	8b 40 04             	mov    0x4(%eax),%eax
  803a95:	85 c0                	test   %eax,%eax
  803a97:	74 14                	je     803aad <alloc_block+0x2fe>
  803a99:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a9c:	c1 e0 04             	shl    $0x4,%eax
  803a9f:	05 84 d0 81 00       	add    $0x81d084,%eax
  803aa4:	8b 00                	mov    (%eax),%eax
  803aa6:	8b 55 cc             	mov    -0x34(%ebp),%edx
  803aa9:	89 10                	mov    %edx,(%eax)
  803aab:	eb 11                	jmp    803abe <alloc_block+0x30f>
  803aad:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803ab0:	c1 e0 04             	shl    $0x4,%eax
  803ab3:	8d 90 80 d0 81 00    	lea    0x81d080(%eax),%edx
  803ab9:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803abc:	89 02                	mov    %eax,(%edx)
  803abe:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803ac1:	c1 e0 04             	shl    $0x4,%eax
  803ac4:	8d 90 84 d0 81 00    	lea    0x81d084(%eax),%edx
  803aca:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803acd:	89 02                	mov    %eax,(%edx)
  803acf:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803ad2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803ad8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803adb:	c1 e0 04             	shl    $0x4,%eax
  803ade:	05 8c d0 81 00       	add    $0x81d08c,%eax
  803ae3:	8b 00                	mov    (%eax),%eax
  803ae5:	8d 50 01             	lea    0x1(%eax),%edx
  803ae8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803aeb:	c1 e0 04             	shl    $0x4,%eax
  803aee:	05 8c d0 81 00       	add    $0x81d08c,%eax
  803af3:	89 10                	mov    %edx,(%eax)

		pageBlockInfoArr[page_index].block_size = size;
		int num_blocks = PAGE_SIZE / size ;
		pageBlockInfoArr[page_index].num_of_free_blocks= num_blocks - 1 ;

		for(int i=1; i< num_blocks; i++){
  803af5:	ff 45 f0             	incl   -0x10(%ebp)
  803af8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803afb:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  803afe:	0f 8c 4a ff ff ff    	jl     803a4e <alloc_block+0x29f>
			struct BlockElement *new_block = (struct BlockElement*)(page_va + i *size);
			LIST_INSERT_TAIL(&freeBlockLists[list_index], new_block);
		}
		return(void*)page_va;
  803b04:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803b07:	e9 3d 01 00 00       	jmp    803c49 <alloc_block+0x49a>
	}


	for(int i =list_index+1; i<= LOG2_MAX_SIZE - LOG2_MIN_SIZE; i++){
  803b0c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803b0f:	40                   	inc    %eax
  803b10:	89 45 ec             	mov    %eax,-0x14(%ebp)
  803b13:	e9 10 01 00 00       	jmp    803c28 <alloc_block+0x479>

		if(!LIST_EMPTY(&freeBlockLists[i])){
  803b18:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803b1b:	c1 e0 04             	shl    $0x4,%eax
  803b1e:	05 80 d0 81 00       	add    $0x81d080,%eax
  803b23:	8b 00                	mov    (%eax),%eax
  803b25:	85 c0                	test   %eax,%eax
  803b27:	0f 84 f8 00 00 00    	je     803c25 <alloc_block+0x476>

			struct BlockElement *block = LIST_FIRST(&freeBlockLists[i]);
  803b2d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803b30:	c1 e0 04             	shl    $0x4,%eax
  803b33:	05 80 d0 81 00       	add    $0x81d080,%eax
  803b38:	8b 00                	mov    (%eax),%eax
  803b3a:	89 45 c8             	mov    %eax,-0x38(%ebp)
			LIST_REMOVE( &freeBlockLists[i], block);
  803b3d:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  803b41:	75 17                	jne    803b5a <alloc_block+0x3ab>
  803b43:	83 ec 04             	sub    $0x4,%esp
  803b46:	68 cd 4d 80 00       	push   $0x804dcd
  803b4b:	68 a8 00 00 00       	push   $0xa8
  803b50:	68 93 4d 80 00       	push   $0x804d93
  803b55:	e8 42 c9 ff ff       	call   80049c <_panic>
  803b5a:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803b5d:	8b 00                	mov    (%eax),%eax
  803b5f:	85 c0                	test   %eax,%eax
  803b61:	74 10                	je     803b73 <alloc_block+0x3c4>
  803b63:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803b66:	8b 00                	mov    (%eax),%eax
  803b68:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803b6b:	8b 52 04             	mov    0x4(%edx),%edx
  803b6e:	89 50 04             	mov    %edx,0x4(%eax)
  803b71:	eb 14                	jmp    803b87 <alloc_block+0x3d8>
  803b73:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803b76:	8b 40 04             	mov    0x4(%eax),%eax
  803b79:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803b7c:	c1 e2 04             	shl    $0x4,%edx
  803b7f:	81 c2 84 d0 81 00    	add    $0x81d084,%edx
  803b85:	89 02                	mov    %eax,(%edx)
  803b87:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803b8a:	8b 40 04             	mov    0x4(%eax),%eax
  803b8d:	85 c0                	test   %eax,%eax
  803b8f:	74 0f                	je     803ba0 <alloc_block+0x3f1>
  803b91:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803b94:	8b 40 04             	mov    0x4(%eax),%eax
  803b97:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803b9a:	8b 12                	mov    (%edx),%edx
  803b9c:	89 10                	mov    %edx,(%eax)
  803b9e:	eb 13                	jmp    803bb3 <alloc_block+0x404>
  803ba0:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803ba3:	8b 00                	mov    (%eax),%eax
  803ba5:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803ba8:	c1 e2 04             	shl    $0x4,%edx
  803bab:	81 c2 80 d0 81 00    	add    $0x81d080,%edx
  803bb1:	89 02                	mov    %eax,(%edx)
  803bb3:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803bb6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803bbc:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803bbf:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803bc6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803bc9:	c1 e0 04             	shl    $0x4,%eax
  803bcc:	05 8c d0 81 00       	add    $0x81d08c,%eax
  803bd1:	8b 00                	mov    (%eax),%eax
  803bd3:	8d 50 ff             	lea    -0x1(%eax),%edx
  803bd6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803bd9:	c1 e0 04             	shl    $0x4,%eax
  803bdc:	05 8c d0 81 00       	add    $0x81d08c,%eax
  803be1:	89 10                	mov    %edx,(%eax)

			uint32 page_index = ((uint32)block - dynAllocStart)/ PAGE_SIZE;
  803be3:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803be6:	a1 64 d0 81 00       	mov    0x81d064,%eax
  803beb:	29 c2                	sub    %eax,%edx
  803bed:	89 d0                	mov    %edx,%eax
  803bef:	c1 e8 0c             	shr    $0xc,%eax
  803bf2:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			pageBlockInfoArr[page_index].num_of_free_blocks-- ;
  803bf5:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  803bf8:	89 d0                	mov    %edx,%eax
  803bfa:	01 c0                	add    %eax,%eax
  803bfc:	01 d0                	add    %edx,%eax
  803bfe:	c1 e0 02             	shl    $0x2,%eax
  803c01:	05 6a 50 80 00       	add    $0x80506a,%eax
  803c06:	66 8b 00             	mov    (%eax),%ax
  803c09:	8d 50 ff             	lea    -0x1(%eax),%edx
  803c0c:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  803c0f:	89 c8                	mov    %ecx,%eax
  803c11:	01 c0                	add    %eax,%eax
  803c13:	01 c8                	add    %ecx,%eax
  803c15:	c1 e0 02             	shl    $0x2,%eax
  803c18:	05 6a 50 80 00       	add    $0x80506a,%eax
  803c1d:	66 89 10             	mov    %dx,(%eax)

			return (void*)block;
  803c20:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803c23:	eb 24                	jmp    803c49 <alloc_block+0x49a>
		}
		return(void*)page_va;
	}


	for(int i =list_index+1; i<= LOG2_MAX_SIZE - LOG2_MIN_SIZE; i++){
  803c25:	ff 45 ec             	incl   -0x14(%ebp)
  803c28:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  803c2c:	0f 8e e6 fe ff ff    	jle    803b18 <alloc_block+0x369>

			return (void*)block;
		}
	}

	panic("alloc_block: out of memory! ");
  803c32:	83 ec 04             	sub    $0x4,%esp
  803c35:	68 0f 4e 80 00       	push   $0x804e0f
  803c3a:	68 b1 00 00 00       	push   $0xb1
  803c3f:	68 93 4d 80 00       	push   $0x804d93
  803c44:	e8 53 c8 ff ff       	call   80049c <_panic>

	//Comment the following line
	//panic("alloc_block() Not implemented yet");

	//TODO: [PROJECT'25.BONUS#1] DYNAMIC ALLOCATOR - block if no free block
}
  803c49:	c9                   	leave  
  803c4a:	c3                   	ret    

00803c4b <free_block>:

//===========================
// [4] FREE BLOCK:
//===========================
void free_block(void *va)
{
  803c4b:	55                   	push   %ebp
  803c4c:	89 e5                	mov    %esp,%ebp
  803c4e:	83 ec 38             	sub    $0x38,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert((uint32)va >= dynAllocStart && (uint32)va < dynAllocEnd);
  803c51:	8b 55 08             	mov    0x8(%ebp),%edx
  803c54:	a1 64 d0 81 00       	mov    0x81d064,%eax
  803c59:	39 c2                	cmp    %eax,%edx
  803c5b:	72 0c                	jb     803c69 <free_block+0x1e>
  803c5d:	8b 55 08             	mov    0x8(%ebp),%edx
  803c60:	a1 40 50 80 00       	mov    0x805040,%eax
  803c65:	39 c2                	cmp    %eax,%edx
  803c67:	72 19                	jb     803c82 <free_block+0x37>
  803c69:	68 2c 4e 80 00       	push   $0x804e2c
  803c6e:	68 7e 4d 80 00       	push   $0x804d7e
  803c73:	68 c3 00 00 00       	push   $0xc3
  803c78:	68 93 4d 80 00       	push   $0x804d93
  803c7d:	e8 1a c8 ff ff       	call   80049c <_panic>
	//==================================================================================

	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #4 free_block
	//Your code is here

	uint32 page_index=((uint32)va - dynAllocStart)/ PAGE_SIZE;
  803c82:	8b 55 08             	mov    0x8(%ebp),%edx
  803c85:	a1 64 d0 81 00       	mov    0x81d064,%eax
  803c8a:	29 c2                	sub    %eax,%edx
  803c8c:	89 d0                	mov    %edx,%eax
  803c8e:	c1 e8 0c             	shr    $0xc,%eax
  803c91:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 block_size = pageBlockInfoArr[page_index].block_size;
  803c94:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803c97:	89 d0                	mov    %edx,%eax
  803c99:	01 c0                	add    %eax,%eax
  803c9b:	01 d0                	add    %edx,%eax
  803c9d:	c1 e0 02             	shl    $0x2,%eax
  803ca0:	05 68 50 80 00       	add    $0x805068,%eax
  803ca5:	8b 00                	mov    (%eax),%eax
  803ca7:	0f b7 c0             	movzwl %ax,%eax
  803caa:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if(block_size == 0){
  803cad:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803cb1:	75 17                	jne    803cca <free_block+0x7f>
		panic("page is empty(already not allocated)");
  803cb3:	83 ec 04             	sub    $0x4,%esp
  803cb6:	68 64 4e 80 00       	push   $0x804e64
  803cbb:	68 cf 00 00 00       	push   $0xcf
  803cc0:	68 93 4d 80 00       	push   $0x804d93
  803cc5:	e8 d2 c7 ff ff       	call   80049c <_panic>
	}

	int list_index = log2(block_size) - LOG2_MIN_SIZE;
  803cca:	83 ec 0c             	sub    $0xc,%esp
  803ccd:	ff 75 ec             	pushl  -0x14(%ebp)
  803cd0:	e8 d8 f8 ff ff       	call   8035ad <log2>
  803cd5:	83 c4 10             	add    $0x10,%esp
  803cd8:	83 e8 03             	sub    $0x3,%eax
  803cdb:	89 45 e8             	mov    %eax,-0x18(%ebp)
	// mn va l block "elta7weel mn virtual l phy hna"
	struct BlockElement *block = (struct BlockElement *)va;
  803cde:	8b 45 08             	mov    0x8(%ebp),%eax
  803ce1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	LIST_INSERT_TAIL(&freeBlockLists[list_index], block);
  803ce4:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803ce8:	75 17                	jne    803d01 <free_block+0xb6>
  803cea:	83 ec 04             	sub    $0x4,%esp
  803ced:	68 ec 4d 80 00       	push   $0x804dec
  803cf2:	68 d5 00 00 00       	push   $0xd5
  803cf7:	68 93 4d 80 00       	push   $0x804d93
  803cfc:	e8 9b c7 ff ff       	call   80049c <_panic>
  803d01:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803d04:	c1 e0 04             	shl    $0x4,%eax
  803d07:	05 84 d0 81 00       	add    $0x81d084,%eax
  803d0c:	8b 10                	mov    (%eax),%edx
  803d0e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803d11:	89 50 04             	mov    %edx,0x4(%eax)
  803d14:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803d17:	8b 40 04             	mov    0x4(%eax),%eax
  803d1a:	85 c0                	test   %eax,%eax
  803d1c:	74 14                	je     803d32 <free_block+0xe7>
  803d1e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803d21:	c1 e0 04             	shl    $0x4,%eax
  803d24:	05 84 d0 81 00       	add    $0x81d084,%eax
  803d29:	8b 00                	mov    (%eax),%eax
  803d2b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803d2e:	89 10                	mov    %edx,(%eax)
  803d30:	eb 11                	jmp    803d43 <free_block+0xf8>
  803d32:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803d35:	c1 e0 04             	shl    $0x4,%eax
  803d38:	8d 90 80 d0 81 00    	lea    0x81d080(%eax),%edx
  803d3e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803d41:	89 02                	mov    %eax,(%edx)
  803d43:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803d46:	c1 e0 04             	shl    $0x4,%eax
  803d49:	8d 90 84 d0 81 00    	lea    0x81d084(%eax),%edx
  803d4f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803d52:	89 02                	mov    %eax,(%edx)
  803d54:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803d57:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803d5d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803d60:	c1 e0 04             	shl    $0x4,%eax
  803d63:	05 8c d0 81 00       	add    $0x81d08c,%eax
  803d68:	8b 00                	mov    (%eax),%eax
  803d6a:	8d 50 01             	lea    0x1(%eax),%edx
  803d6d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803d70:	c1 e0 04             	shl    $0x4,%eax
  803d73:	05 8c d0 81 00       	add    $0x81d08c,%eax
  803d78:	89 10                	mov    %edx,(%eax)
	// b3d ma wdytha fy el freeBlockLists hzwed elfree elly fy el array 1
	pageBlockInfoArr[page_index].num_of_free_blocks++;
  803d7a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803d7d:	89 d0                	mov    %edx,%eax
  803d7f:	01 c0                	add    %eax,%eax
  803d81:	01 d0                	add    %edx,%eax
  803d83:	c1 e0 02             	shl    $0x2,%eax
  803d86:	05 6a 50 80 00       	add    $0x80506a,%eax
  803d8b:	66 8b 00             	mov    (%eax),%ax
  803d8e:	8d 50 01             	lea    0x1(%eax),%edx
  803d91:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  803d94:	89 c8                	mov    %ecx,%eax
  803d96:	01 c0                	add    %eax,%eax
  803d98:	01 c8                	add    %ecx,%eax
  803d9a:	c1 e0 02             	shl    $0x2,%eax
  803d9d:	05 6a 50 80 00       	add    $0x80506a,%eax
  803da2:	66 89 10             	mov    %dx,(%eax)
	int blocks_number = PAGE_SIZE / block_size;
  803da5:	b8 00 10 00 00       	mov    $0x1000,%eax
  803daa:	ba 00 00 00 00       	mov    $0x0,%edx
  803daf:	f7 75 ec             	divl   -0x14(%ebp)
  803db2:	89 45 e0             	mov    %eax,-0x20(%ebp)
	if(pageBlockInfoArr[page_index].num_of_free_blocks == blocks_number){
  803db5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803db8:	89 d0                	mov    %edx,%eax
  803dba:	01 c0                	add    %eax,%eax
  803dbc:	01 d0                	add    %edx,%eax
  803dbe:	c1 e0 02             	shl    $0x2,%eax
  803dc1:	05 6a 50 80 00       	add    $0x80506a,%eax
  803dc6:	66 8b 00             	mov    (%eax),%ax
  803dc9:	0f b7 c0             	movzwl %ax,%eax
  803dcc:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  803dcf:	0f 85 d3 01 00 00    	jne    803fa8 <free_block+0x35d>
		struct BlockElement *itr = LIST_FIRST(&freeBlockLists[list_index]);
  803dd5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803dd8:	c1 e0 04             	shl    $0x4,%eax
  803ddb:	05 80 d0 81 00       	add    $0x81d080,%eax
  803de0:	8b 00                	mov    (%eax),%eax
  803de2:	89 45 f4             	mov    %eax,-0xc(%ebp)
		while(itr != NULL){
  803de5:	e9 f1 00 00 00       	jmp    803edb <free_block+0x290>
			//lw ms7to el pointer mydy34 ->
			struct BlockElement *next = LIST_NEXT(itr);
  803dea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ded:	8b 00                	mov    (%eax),%eax
  803def:	89 45 dc             	mov    %eax,-0x24(%ebp)
			uint32 page_beginning_address= dynAllocStart + page_index * PAGE_SIZE;
  803df2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803df5:	c1 e0 0c             	shl    $0xc,%eax
  803df8:	89 c2                	mov    %eax,%edx
  803dfa:	a1 64 d0 81 00       	mov    0x81d064,%eax
  803dff:	01 d0                	add    %edx,%eax
  803e01:	89 45 d8             	mov    %eax,-0x28(%ebp)
			uint32 page_end_address = dynAllocStart + (page_index +1 )* PAGE_SIZE;
  803e04:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803e07:	40                   	inc    %eax
  803e08:	c1 e0 0c             	shl    $0xc,%eax
  803e0b:	89 c2                	mov    %eax,%edx
  803e0d:	a1 64 d0 81 00       	mov    0x81d064,%eax
  803e12:	01 d0                	add    %edx,%eax
  803e14:	89 45 d4             	mov    %eax,-0x2c(%ebp)

			if((uint32)itr >= page_beginning_address && (uint32)itr < page_end_address){
  803e17:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e1a:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  803e1d:	0f 82 b8 00 00 00    	jb     803edb <free_block+0x290>
  803e23:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e26:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803e29:	0f 83 ac 00 00 00    	jae    803edb <free_block+0x290>
				LIST_REMOVE(&freeBlockLists[list_index], itr);
  803e2f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803e33:	75 17                	jne    803e4c <free_block+0x201>
  803e35:	83 ec 04             	sub    $0x4,%esp
  803e38:	68 cd 4d 80 00       	push   $0x804dcd
  803e3d:	68 e2 00 00 00       	push   $0xe2
  803e42:	68 93 4d 80 00       	push   $0x804d93
  803e47:	e8 50 c6 ff ff       	call   80049c <_panic>
  803e4c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e4f:	8b 00                	mov    (%eax),%eax
  803e51:	85 c0                	test   %eax,%eax
  803e53:	74 10                	je     803e65 <free_block+0x21a>
  803e55:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e58:	8b 00                	mov    (%eax),%eax
  803e5a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803e5d:	8b 52 04             	mov    0x4(%edx),%edx
  803e60:	89 50 04             	mov    %edx,0x4(%eax)
  803e63:	eb 14                	jmp    803e79 <free_block+0x22e>
  803e65:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e68:	8b 40 04             	mov    0x4(%eax),%eax
  803e6b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803e6e:	c1 e2 04             	shl    $0x4,%edx
  803e71:	81 c2 84 d0 81 00    	add    $0x81d084,%edx
  803e77:	89 02                	mov    %eax,(%edx)
  803e79:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e7c:	8b 40 04             	mov    0x4(%eax),%eax
  803e7f:	85 c0                	test   %eax,%eax
  803e81:	74 0f                	je     803e92 <free_block+0x247>
  803e83:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e86:	8b 40 04             	mov    0x4(%eax),%eax
  803e89:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803e8c:	8b 12                	mov    (%edx),%edx
  803e8e:	89 10                	mov    %edx,(%eax)
  803e90:	eb 13                	jmp    803ea5 <free_block+0x25a>
  803e92:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e95:	8b 00                	mov    (%eax),%eax
  803e97:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803e9a:	c1 e2 04             	shl    $0x4,%edx
  803e9d:	81 c2 80 d0 81 00    	add    $0x81d080,%edx
  803ea3:	89 02                	mov    %eax,(%edx)
  803ea5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ea8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803eae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803eb1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803eb8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803ebb:	c1 e0 04             	shl    $0x4,%eax
  803ebe:	05 8c d0 81 00       	add    $0x81d08c,%eax
  803ec3:	8b 00                	mov    (%eax),%eax
  803ec5:	8d 50 ff             	lea    -0x1(%eax),%edx
  803ec8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803ecb:	c1 e0 04             	shl    $0x4,%eax
  803ece:	05 8c d0 81 00       	add    $0x81d08c,%eax
  803ed3:	89 10                	mov    %edx,(%eax)
				//y5o4 3la elly b3do
				itr = next;
  803ed5:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803ed8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// b3d ma wdytha fy el freeBlockLists hzwed elfree elly fy el array 1
	pageBlockInfoArr[page_index].num_of_free_blocks++;
	int blocks_number = PAGE_SIZE / block_size;
	if(pageBlockInfoArr[page_index].num_of_free_blocks == blocks_number){
		struct BlockElement *itr = LIST_FIRST(&freeBlockLists[list_index]);
		while(itr != NULL){
  803edb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803edf:	0f 85 05 ff ff ff    	jne    803dea <free_block+0x19f>
				LIST_REMOVE(&freeBlockLists[list_index], itr);
				//y5o4 3la elly b3do
				itr = next;
			}
		}
		pageBlockInfoArr[page_index].block_size=0;
  803ee5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803ee8:	89 d0                	mov    %edx,%eax
  803eea:	01 c0                	add    %eax,%eax
  803eec:	01 d0                	add    %edx,%eax
  803eee:	c1 e0 02             	shl    $0x2,%eax
  803ef1:	05 68 50 80 00       	add    $0x805068,%eax
  803ef6:	66 c7 00 00 00       	movw   $0x0,(%eax)
		pageBlockInfoArr[page_index].num_of_free_blocks=0;
  803efb:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803efe:	89 d0                	mov    %edx,%eax
  803f00:	01 c0                	add    %eax,%eax
  803f02:	01 d0                	add    %edx,%eax
  803f04:	c1 e0 02             	shl    $0x2,%eax
  803f07:	05 6a 50 80 00       	add    $0x80506a,%eax
  803f0c:	66 c7 00 00 00       	movw   $0x0,(%eax)

		struct PageInfoElement *page_info = &pageBlockInfoArr[page_index];
  803f11:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803f14:	89 d0                	mov    %edx,%eax
  803f16:	01 c0                	add    %eax,%eax
  803f18:	01 d0                	add    %edx,%eax
  803f1a:	c1 e0 02             	shl    $0x2,%eax
  803f1d:	05 60 50 80 00       	add    $0x805060,%eax
  803f22:	89 45 d0             	mov    %eax,-0x30(%ebp)
		LIST_INSERT_TAIL(&freePagesList, page_info);
  803f25:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  803f29:	75 17                	jne    803f42 <free_block+0x2f7>
  803f2b:	83 ec 04             	sub    $0x4,%esp
  803f2e:	68 ec 4d 80 00       	push   $0x804dec
  803f33:	68 eb 00 00 00       	push   $0xeb
  803f38:	68 93 4d 80 00       	push   $0x804d93
  803f3d:	e8 5a c5 ff ff       	call   80049c <_panic>
  803f42:	8b 15 4c 50 80 00    	mov    0x80504c,%edx
  803f48:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803f4b:	89 50 04             	mov    %edx,0x4(%eax)
  803f4e:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803f51:	8b 40 04             	mov    0x4(%eax),%eax
  803f54:	85 c0                	test   %eax,%eax
  803f56:	74 0c                	je     803f64 <free_block+0x319>
  803f58:	a1 4c 50 80 00       	mov    0x80504c,%eax
  803f5d:	8b 55 d0             	mov    -0x30(%ebp),%edx
  803f60:	89 10                	mov    %edx,(%eax)
  803f62:	eb 08                	jmp    803f6c <free_block+0x321>
  803f64:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803f67:	a3 48 50 80 00       	mov    %eax,0x805048
  803f6c:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803f6f:	a3 4c 50 80 00       	mov    %eax,0x80504c
  803f74:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803f77:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803f7d:	a1 54 50 80 00       	mov    0x805054,%eax
  803f82:	40                   	inc    %eax
  803f83:	a3 54 50 80 00       	mov    %eax,0x805054
		uint32 page_va = to_page_va(page_info);
  803f88:	83 ec 0c             	sub    $0xc,%esp
  803f8b:	ff 75 d0             	pushl  -0x30(%ebp)
  803f8e:	e8 ce f5 ff ff       	call   803561 <to_page_va>
  803f93:	83 c4 10             	add    $0x10,%esp
  803f96:	89 45 cc             	mov    %eax,-0x34(%ebp)
		return_page((void *)page_va);
  803f99:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803f9c:	83 ec 0c             	sub    $0xc,%esp
  803f9f:	50                   	push   %eax
  803fa0:	e8 9e d7 ff ff       	call   801743 <return_page>
  803fa5:	83 c4 10             	add    $0x10,%esp
	}


	//Comment the following line
	//panic("free_block() Not implemented yet");
}
  803fa8:	90                   	nop
  803fa9:	c9                   	leave  
  803faa:	c3                   	ret    

00803fab <realloc_block>:

//===========================
// [1] REALLOCATE BLOCK:
//===========================
void *realloc_block(void* va, uint32 new_size)
{
  803fab:	55                   	push   %ebp
  803fac:	89 e5                	mov    %esp,%ebp
  803fae:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.BONUS#2] KERNEL REALLOC - realloc_block
	//Your code is here
	//Comment the following line
	panic("realloc_block() Not implemented yet");
  803fb1:	83 ec 04             	sub    $0x4,%esp
  803fb4:	68 8c 4e 80 00       	push   $0x804e8c
  803fb9:	68 01 01 00 00       	push   $0x101
  803fbe:	68 93 4d 80 00       	push   $0x804d93
  803fc3:	e8 d4 c4 ff ff       	call   80049c <_panic>

00803fc8 <init_uspinlock>:
#include "inc/uspinlock.h"

extern volatile struct Env *myEnv;

void init_uspinlock(struct uspinlock *lk, char *name, bool isOpened)
{
  803fc8:	55                   	push   %ebp
  803fc9:	89 e5                	mov    %esp,%ebp
  803fcb:	83 ec 08             	sub    $0x8,%esp
	assert(isOpened == 0 || isOpened == 1);
  803fce:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  803fd2:	74 1c                	je     803ff0 <init_uspinlock+0x28>
  803fd4:	83 7d 10 01          	cmpl   $0x1,0x10(%ebp)
  803fd8:	74 16                	je     803ff0 <init_uspinlock+0x28>
  803fda:	68 b0 4e 80 00       	push   $0x804eb0
  803fdf:	68 cf 4e 80 00       	push   $0x804ecf
  803fe4:	6a 10                	push   $0x10
  803fe6:	68 e4 4e 80 00       	push   $0x804ee4
  803feb:	e8 ac c4 ff ff       	call   80049c <_panic>
	strcpy(lk->name, name);
  803ff0:	8b 45 08             	mov    0x8(%ebp),%eax
  803ff3:	83 c0 04             	add    $0x4,%eax
  803ff6:	83 ec 08             	sub    $0x8,%esp
  803ff9:	ff 75 0c             	pushl  0xc(%ebp)
  803ffc:	50                   	push   %eax
  803ffd:	e8 90 ce ff ff       	call   800e92 <strcpy>
  804002:	83 c4 10             	add    $0x10,%esp
	lk->locked = (1 - isOpened);
  804005:	b8 01 00 00 00       	mov    $0x1,%eax
  80400a:	2b 45 10             	sub    0x10(%ebp),%eax
  80400d:	89 c2                	mov    %eax,%edx
  80400f:	8b 45 08             	mov    0x8(%ebp),%eax
  804012:	89 10                	mov    %edx,(%eax)
}
  804014:	90                   	nop
  804015:	c9                   	leave  
  804016:	c3                   	ret    

00804017 <acquire_uspinlock>:
// Acquire the lock.
// Loops (spins) until the lock is acquired.
// Holding a lock for a long time may cause
// other CPUs to waste time spinning to acquire it.
void acquire_uspinlock(struct uspinlock *lk)
{
  804017:	55                   	push   %ebp
  804018:	89 e5                	mov    %esp,%ebp
  80401a:	83 ec 18             	sub    $0x18,%esp
	// The xchg is atomic.
	while(xchg(&lk->locked, 1) != 0) ;
  80401d:	90                   	nop
  80401e:	8b 45 08             	mov    0x8(%ebp),%eax
  804021:	89 45 f4             	mov    %eax,-0xc(%ebp)
  804024:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
xchg(volatile uint32 *addr, uint32 newval)
{
  uint32 result;

  // The + in "+m" denotes a read-modify-write operand.
  __asm __volatile("lock; xchgl %0, %1" :
  80402b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80402e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804031:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  804034:	f0 87 02             	lock xchg %eax,(%edx)
  804037:	89 45 ec             	mov    %eax,-0x14(%ebp)
               "+m" (*addr), "=a" (result) :
               "1" (newval) :
               "cc");
  return result;
  80403a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80403d:	85 c0                	test   %eax,%eax
  80403f:	75 dd                	jne    80401e <acquire_uspinlock+0x7>

	cprintf("[%d: %s] ACQUIRED spinlock [%s]\n", myEnv->env_id, myEnv->prog_name, lk->name);
  804041:	8b 45 08             	mov    0x8(%ebp),%eax
  804044:	8d 48 04             	lea    0x4(%eax),%ecx
  804047:	a1 20 50 80 00       	mov    0x805020,%eax
  80404c:	8d 50 20             	lea    0x20(%eax),%edx
  80404f:	a1 20 50 80 00       	mov    0x805020,%eax
  804054:	8b 40 10             	mov    0x10(%eax),%eax
  804057:	51                   	push   %ecx
  804058:	52                   	push   %edx
  804059:	50                   	push   %eax
  80405a:	68 f4 4e 80 00       	push   $0x804ef4
  80405f:	e8 06 c7 ff ff       	call   80076a <cprintf>
  804064:	83 c4 10             	add    $0x10,%esp

	// Tell the C compiler and the processor to not move loads or stores
	// past this point, to ensure that the critical section's memory
	// references happen after the lock is acquired.
	__sync_synchronize();
  804067:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
}
  80406c:	90                   	nop
  80406d:	c9                   	leave  
  80406e:	c3                   	ret    

0080406f <release_uspinlock>:

// Release the lock.
void release_uspinlock(struct uspinlock *lk)
{
  80406f:	55                   	push   %ebp
  804070:	89 e5                	mov    %esp,%ebp
  804072:	83 ec 08             	sub    $0x8,%esp
	if(!(lk->locked))
  804075:	8b 45 08             	mov    0x8(%ebp),%eax
  804078:	8b 00                	mov    (%eax),%eax
  80407a:	85 c0                	test   %eax,%eax
  80407c:	75 18                	jne    804096 <release_uspinlock+0x27>
	{
		panic("release: lock \"%s\" is not held!", lk->name);
  80407e:	8b 45 08             	mov    0x8(%ebp),%eax
  804081:	83 c0 04             	add    $0x4,%eax
  804084:	50                   	push   %eax
  804085:	68 18 4f 80 00       	push   $0x804f18
  80408a:	6a 2b                	push   $0x2b
  80408c:	68 e4 4e 80 00       	push   $0x804ee4
  804091:	e8 06 c4 ff ff       	call   80049c <_panic>
	// Tell the C compiler and the processor to not move loads or stores
	// past this point, to ensure that all the stores in the critical
	// section are visible to other cores before the lock is released.
	// Both the C compiler and the hardware may re-order loads and
	// stores; __sync_synchronize() tells them both not to.
	__sync_synchronize();
  804096:	f0 83 0c 24 00       	lock orl $0x0,(%esp)

	// Release the lock, equivalent to lk->locked = 0.
	// This code can't use a C assignment, since it might
	// not be atomic. A real OS would use C atomics here.
	asm volatile("movl $0, %0" : "+m" (lk->locked) : );
  80409b:	8b 45 08             	mov    0x8(%ebp),%eax
  80409e:	8b 55 08             	mov    0x8(%ebp),%edx
  8040a1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	cprintf("[%d: %s] RELEASED spinlock [%s]\n", myEnv->env_id, myEnv->prog_name, lk->name);
  8040a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8040aa:	8d 48 04             	lea    0x4(%eax),%ecx
  8040ad:	a1 20 50 80 00       	mov    0x805020,%eax
  8040b2:	8d 50 20             	lea    0x20(%eax),%edx
  8040b5:	a1 20 50 80 00       	mov    0x805020,%eax
  8040ba:	8b 40 10             	mov    0x10(%eax),%eax
  8040bd:	51                   	push   %ecx
  8040be:	52                   	push   %edx
  8040bf:	50                   	push   %eax
  8040c0:	68 38 4f 80 00       	push   $0x804f38
  8040c5:	e8 a0 c6 ff ff       	call   80076a <cprintf>
  8040ca:	83 c4 10             	add    $0x10,%esp
}
  8040cd:	90                   	nop
  8040ce:	c9                   	leave  
  8040cf:	c3                   	ret    

008040d0 <__udivdi3>:
  8040d0:	55                   	push   %ebp
  8040d1:	57                   	push   %edi
  8040d2:	56                   	push   %esi
  8040d3:	53                   	push   %ebx
  8040d4:	83 ec 1c             	sub    $0x1c,%esp
  8040d7:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8040db:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8040df:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8040e3:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8040e7:	89 ca                	mov    %ecx,%edx
  8040e9:	89 f8                	mov    %edi,%eax
  8040eb:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8040ef:	85 f6                	test   %esi,%esi
  8040f1:	75 2d                	jne    804120 <__udivdi3+0x50>
  8040f3:	39 cf                	cmp    %ecx,%edi
  8040f5:	77 65                	ja     80415c <__udivdi3+0x8c>
  8040f7:	89 fd                	mov    %edi,%ebp
  8040f9:	85 ff                	test   %edi,%edi
  8040fb:	75 0b                	jne    804108 <__udivdi3+0x38>
  8040fd:	b8 01 00 00 00       	mov    $0x1,%eax
  804102:	31 d2                	xor    %edx,%edx
  804104:	f7 f7                	div    %edi
  804106:	89 c5                	mov    %eax,%ebp
  804108:	31 d2                	xor    %edx,%edx
  80410a:	89 c8                	mov    %ecx,%eax
  80410c:	f7 f5                	div    %ebp
  80410e:	89 c1                	mov    %eax,%ecx
  804110:	89 d8                	mov    %ebx,%eax
  804112:	f7 f5                	div    %ebp
  804114:	89 cf                	mov    %ecx,%edi
  804116:	89 fa                	mov    %edi,%edx
  804118:	83 c4 1c             	add    $0x1c,%esp
  80411b:	5b                   	pop    %ebx
  80411c:	5e                   	pop    %esi
  80411d:	5f                   	pop    %edi
  80411e:	5d                   	pop    %ebp
  80411f:	c3                   	ret    
  804120:	39 ce                	cmp    %ecx,%esi
  804122:	77 28                	ja     80414c <__udivdi3+0x7c>
  804124:	0f bd fe             	bsr    %esi,%edi
  804127:	83 f7 1f             	xor    $0x1f,%edi
  80412a:	75 40                	jne    80416c <__udivdi3+0x9c>
  80412c:	39 ce                	cmp    %ecx,%esi
  80412e:	72 0a                	jb     80413a <__udivdi3+0x6a>
  804130:	3b 44 24 08          	cmp    0x8(%esp),%eax
  804134:	0f 87 9e 00 00 00    	ja     8041d8 <__udivdi3+0x108>
  80413a:	b8 01 00 00 00       	mov    $0x1,%eax
  80413f:	89 fa                	mov    %edi,%edx
  804141:	83 c4 1c             	add    $0x1c,%esp
  804144:	5b                   	pop    %ebx
  804145:	5e                   	pop    %esi
  804146:	5f                   	pop    %edi
  804147:	5d                   	pop    %ebp
  804148:	c3                   	ret    
  804149:	8d 76 00             	lea    0x0(%esi),%esi
  80414c:	31 ff                	xor    %edi,%edi
  80414e:	31 c0                	xor    %eax,%eax
  804150:	89 fa                	mov    %edi,%edx
  804152:	83 c4 1c             	add    $0x1c,%esp
  804155:	5b                   	pop    %ebx
  804156:	5e                   	pop    %esi
  804157:	5f                   	pop    %edi
  804158:	5d                   	pop    %ebp
  804159:	c3                   	ret    
  80415a:	66 90                	xchg   %ax,%ax
  80415c:	89 d8                	mov    %ebx,%eax
  80415e:	f7 f7                	div    %edi
  804160:	31 ff                	xor    %edi,%edi
  804162:	89 fa                	mov    %edi,%edx
  804164:	83 c4 1c             	add    $0x1c,%esp
  804167:	5b                   	pop    %ebx
  804168:	5e                   	pop    %esi
  804169:	5f                   	pop    %edi
  80416a:	5d                   	pop    %ebp
  80416b:	c3                   	ret    
  80416c:	bd 20 00 00 00       	mov    $0x20,%ebp
  804171:	89 eb                	mov    %ebp,%ebx
  804173:	29 fb                	sub    %edi,%ebx
  804175:	89 f9                	mov    %edi,%ecx
  804177:	d3 e6                	shl    %cl,%esi
  804179:	89 c5                	mov    %eax,%ebp
  80417b:	88 d9                	mov    %bl,%cl
  80417d:	d3 ed                	shr    %cl,%ebp
  80417f:	89 e9                	mov    %ebp,%ecx
  804181:	09 f1                	or     %esi,%ecx
  804183:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  804187:	89 f9                	mov    %edi,%ecx
  804189:	d3 e0                	shl    %cl,%eax
  80418b:	89 c5                	mov    %eax,%ebp
  80418d:	89 d6                	mov    %edx,%esi
  80418f:	88 d9                	mov    %bl,%cl
  804191:	d3 ee                	shr    %cl,%esi
  804193:	89 f9                	mov    %edi,%ecx
  804195:	d3 e2                	shl    %cl,%edx
  804197:	8b 44 24 08          	mov    0x8(%esp),%eax
  80419b:	88 d9                	mov    %bl,%cl
  80419d:	d3 e8                	shr    %cl,%eax
  80419f:	09 c2                	or     %eax,%edx
  8041a1:	89 d0                	mov    %edx,%eax
  8041a3:	89 f2                	mov    %esi,%edx
  8041a5:	f7 74 24 0c          	divl   0xc(%esp)
  8041a9:	89 d6                	mov    %edx,%esi
  8041ab:	89 c3                	mov    %eax,%ebx
  8041ad:	f7 e5                	mul    %ebp
  8041af:	39 d6                	cmp    %edx,%esi
  8041b1:	72 19                	jb     8041cc <__udivdi3+0xfc>
  8041b3:	74 0b                	je     8041c0 <__udivdi3+0xf0>
  8041b5:	89 d8                	mov    %ebx,%eax
  8041b7:	31 ff                	xor    %edi,%edi
  8041b9:	e9 58 ff ff ff       	jmp    804116 <__udivdi3+0x46>
  8041be:	66 90                	xchg   %ax,%ax
  8041c0:	8b 54 24 08          	mov    0x8(%esp),%edx
  8041c4:	89 f9                	mov    %edi,%ecx
  8041c6:	d3 e2                	shl    %cl,%edx
  8041c8:	39 c2                	cmp    %eax,%edx
  8041ca:	73 e9                	jae    8041b5 <__udivdi3+0xe5>
  8041cc:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8041cf:	31 ff                	xor    %edi,%edi
  8041d1:	e9 40 ff ff ff       	jmp    804116 <__udivdi3+0x46>
  8041d6:	66 90                	xchg   %ax,%ax
  8041d8:	31 c0                	xor    %eax,%eax
  8041da:	e9 37 ff ff ff       	jmp    804116 <__udivdi3+0x46>
  8041df:	90                   	nop

008041e0 <__umoddi3>:
  8041e0:	55                   	push   %ebp
  8041e1:	57                   	push   %edi
  8041e2:	56                   	push   %esi
  8041e3:	53                   	push   %ebx
  8041e4:	83 ec 1c             	sub    $0x1c,%esp
  8041e7:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8041eb:	8b 74 24 34          	mov    0x34(%esp),%esi
  8041ef:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8041f3:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8041f7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8041fb:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8041ff:	89 f3                	mov    %esi,%ebx
  804201:	89 fa                	mov    %edi,%edx
  804203:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  804207:	89 34 24             	mov    %esi,(%esp)
  80420a:	85 c0                	test   %eax,%eax
  80420c:	75 1a                	jne    804228 <__umoddi3+0x48>
  80420e:	39 f7                	cmp    %esi,%edi
  804210:	0f 86 a2 00 00 00    	jbe    8042b8 <__umoddi3+0xd8>
  804216:	89 c8                	mov    %ecx,%eax
  804218:	89 f2                	mov    %esi,%edx
  80421a:	f7 f7                	div    %edi
  80421c:	89 d0                	mov    %edx,%eax
  80421e:	31 d2                	xor    %edx,%edx
  804220:	83 c4 1c             	add    $0x1c,%esp
  804223:	5b                   	pop    %ebx
  804224:	5e                   	pop    %esi
  804225:	5f                   	pop    %edi
  804226:	5d                   	pop    %ebp
  804227:	c3                   	ret    
  804228:	39 f0                	cmp    %esi,%eax
  80422a:	0f 87 ac 00 00 00    	ja     8042dc <__umoddi3+0xfc>
  804230:	0f bd e8             	bsr    %eax,%ebp
  804233:	83 f5 1f             	xor    $0x1f,%ebp
  804236:	0f 84 ac 00 00 00    	je     8042e8 <__umoddi3+0x108>
  80423c:	bf 20 00 00 00       	mov    $0x20,%edi
  804241:	29 ef                	sub    %ebp,%edi
  804243:	89 fe                	mov    %edi,%esi
  804245:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  804249:	89 e9                	mov    %ebp,%ecx
  80424b:	d3 e0                	shl    %cl,%eax
  80424d:	89 d7                	mov    %edx,%edi
  80424f:	89 f1                	mov    %esi,%ecx
  804251:	d3 ef                	shr    %cl,%edi
  804253:	09 c7                	or     %eax,%edi
  804255:	89 e9                	mov    %ebp,%ecx
  804257:	d3 e2                	shl    %cl,%edx
  804259:	89 14 24             	mov    %edx,(%esp)
  80425c:	89 d8                	mov    %ebx,%eax
  80425e:	d3 e0                	shl    %cl,%eax
  804260:	89 c2                	mov    %eax,%edx
  804262:	8b 44 24 08          	mov    0x8(%esp),%eax
  804266:	d3 e0                	shl    %cl,%eax
  804268:	89 44 24 04          	mov    %eax,0x4(%esp)
  80426c:	8b 44 24 08          	mov    0x8(%esp),%eax
  804270:	89 f1                	mov    %esi,%ecx
  804272:	d3 e8                	shr    %cl,%eax
  804274:	09 d0                	or     %edx,%eax
  804276:	d3 eb                	shr    %cl,%ebx
  804278:	89 da                	mov    %ebx,%edx
  80427a:	f7 f7                	div    %edi
  80427c:	89 d3                	mov    %edx,%ebx
  80427e:	f7 24 24             	mull   (%esp)
  804281:	89 c6                	mov    %eax,%esi
  804283:	89 d1                	mov    %edx,%ecx
  804285:	39 d3                	cmp    %edx,%ebx
  804287:	0f 82 87 00 00 00    	jb     804314 <__umoddi3+0x134>
  80428d:	0f 84 91 00 00 00    	je     804324 <__umoddi3+0x144>
  804293:	8b 54 24 04          	mov    0x4(%esp),%edx
  804297:	29 f2                	sub    %esi,%edx
  804299:	19 cb                	sbb    %ecx,%ebx
  80429b:	89 d8                	mov    %ebx,%eax
  80429d:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8042a1:	d3 e0                	shl    %cl,%eax
  8042a3:	89 e9                	mov    %ebp,%ecx
  8042a5:	d3 ea                	shr    %cl,%edx
  8042a7:	09 d0                	or     %edx,%eax
  8042a9:	89 e9                	mov    %ebp,%ecx
  8042ab:	d3 eb                	shr    %cl,%ebx
  8042ad:	89 da                	mov    %ebx,%edx
  8042af:	83 c4 1c             	add    $0x1c,%esp
  8042b2:	5b                   	pop    %ebx
  8042b3:	5e                   	pop    %esi
  8042b4:	5f                   	pop    %edi
  8042b5:	5d                   	pop    %ebp
  8042b6:	c3                   	ret    
  8042b7:	90                   	nop
  8042b8:	89 fd                	mov    %edi,%ebp
  8042ba:	85 ff                	test   %edi,%edi
  8042bc:	75 0b                	jne    8042c9 <__umoddi3+0xe9>
  8042be:	b8 01 00 00 00       	mov    $0x1,%eax
  8042c3:	31 d2                	xor    %edx,%edx
  8042c5:	f7 f7                	div    %edi
  8042c7:	89 c5                	mov    %eax,%ebp
  8042c9:	89 f0                	mov    %esi,%eax
  8042cb:	31 d2                	xor    %edx,%edx
  8042cd:	f7 f5                	div    %ebp
  8042cf:	89 c8                	mov    %ecx,%eax
  8042d1:	f7 f5                	div    %ebp
  8042d3:	89 d0                	mov    %edx,%eax
  8042d5:	e9 44 ff ff ff       	jmp    80421e <__umoddi3+0x3e>
  8042da:	66 90                	xchg   %ax,%ax
  8042dc:	89 c8                	mov    %ecx,%eax
  8042de:	89 f2                	mov    %esi,%edx
  8042e0:	83 c4 1c             	add    $0x1c,%esp
  8042e3:	5b                   	pop    %ebx
  8042e4:	5e                   	pop    %esi
  8042e5:	5f                   	pop    %edi
  8042e6:	5d                   	pop    %ebp
  8042e7:	c3                   	ret    
  8042e8:	3b 04 24             	cmp    (%esp),%eax
  8042eb:	72 06                	jb     8042f3 <__umoddi3+0x113>
  8042ed:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8042f1:	77 0f                	ja     804302 <__umoddi3+0x122>
  8042f3:	89 f2                	mov    %esi,%edx
  8042f5:	29 f9                	sub    %edi,%ecx
  8042f7:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8042fb:	89 14 24             	mov    %edx,(%esp)
  8042fe:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  804302:	8b 44 24 04          	mov    0x4(%esp),%eax
  804306:	8b 14 24             	mov    (%esp),%edx
  804309:	83 c4 1c             	add    $0x1c,%esp
  80430c:	5b                   	pop    %ebx
  80430d:	5e                   	pop    %esi
  80430e:	5f                   	pop    %edi
  80430f:	5d                   	pop    %ebp
  804310:	c3                   	ret    
  804311:	8d 76 00             	lea    0x0(%esi),%esi
  804314:	2b 04 24             	sub    (%esp),%eax
  804317:	19 fa                	sbb    %edi,%edx
  804319:	89 d1                	mov    %edx,%ecx
  80431b:	89 c6                	mov    %eax,%esi
  80431d:	e9 71 ff ff ff       	jmp    804293 <__umoddi3+0xb3>
  804322:	66 90                	xchg   %ax,%ax
  804324:	39 44 24 04          	cmp    %eax,0x4(%esp)
  804328:	72 ea                	jb     804314 <__umoddi3+0x134>
  80432a:	89 d9                	mov    %ebx,%ecx
  80432c:	e9 62 ff ff ff       	jmp    804293 <__umoddi3+0xb3>
