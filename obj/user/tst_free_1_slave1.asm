
obj/user/tst_free_1_slave1:     file format elf32-i386


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
  800031:	e8 b7 02 00 00       	call   8002ed <libmain>
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
	 *********************************************************/
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
  800065:	6a 11                	push   $0x11
  800067:	68 5c 43 80 00       	push   $0x80435c
  80006c:	e8 35 04 00 00       	call   8004a6 <_panic>
	//	malloc(0);
	/*=================================================*/
#else
	panic("not handled!");
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
  8000bc:	e8 1e 30 00 00       	call   8030df <sys_calculate_free_frames>
  8000c1:	89 45 d8             	mov    %eax,-0x28(%ebp)
			usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8000c4:	e8 61 30 00 00       	call   80312a <sys_pf_calculate_allocated_pages>
  8000c9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			ptr_allocations[0] = malloc(2*Mega-kilo);
  8000cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8000cf:	01 c0                	add    %eax,%eax
  8000d1:	2b 45 ec             	sub    -0x14(%ebp),%eax
  8000d4:	83 ec 0c             	sub    $0xc,%esp
  8000d7:	50                   	push   %eax
  8000d8:	e8 b0 16 00 00       	call   80178d <malloc>
  8000dd:	83 c4 10             	add    $0x10,%esp
  8000e0:	89 85 60 ff ff ff    	mov    %eax,-0xa0(%ebp)
			if ((uint32) ptr_allocations[0] != (pagealloc_start)) panic("Wrong start address for the allocated space... ");
  8000e6:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
  8000ec:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8000ef:	74 14                	je     800105 <_main+0xcd>
  8000f1:	83 ec 04             	sub    $0x4,%esp
  8000f4:	68 78 43 80 00       	push   $0x804378
  8000f9:	6a 32                	push   $0x32
  8000fb:	68 5c 43 80 00       	push   $0x80435c
  800100:	e8 a1 03 00 00       	call   8004a6 <_panic>
			if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  800105:	e8 20 30 00 00       	call   80312a <sys_pf_calculate_allocated_pages>
  80010a:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  80010d:	74 14                	je     800123 <_main+0xeb>
  80010f:	83 ec 04             	sub    $0x4,%esp
  800112:	68 a8 43 80 00       	push   $0x8043a8
  800117:	6a 33                	push   $0x33
  800119:	68 5c 43 80 00       	push   $0x80435c
  80011e:	e8 83 03 00 00       	call   8004a6 <_panic>

			freeFrames = sys_calculate_free_frames() ;
  800123:	e8 b7 2f 00 00       	call   8030df <sys_calculate_free_frames>
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
  80015f:	e8 7b 2f 00 00       	call   8030df <sys_calculate_free_frames>
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
  800181:	6a 3d                	push   $0x3d
  800183:	68 5c 43 80 00       	push   $0x80435c
  800188:	e8 19 03 00 00       	call   8004a6 <_panic>

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
  8001c7:	e8 d5 32 00 00       	call   8034a1 <sys_check_WS_list>
  8001cc:	83 c4 10             	add    $0x10,%esp
  8001cf:	89 45 b8             	mov    %eax,-0x48(%ebp)
			if (chk != 1) panic("malloc: page is not added to WS");
  8001d2:	83 7d b8 01          	cmpl   $0x1,-0x48(%ebp)
  8001d6:	74 14                	je     8001ec <_main+0x1b4>
  8001d8:	83 ec 04             	sub    $0x4,%esp
  8001db:	68 54 44 80 00       	push   $0x804454
  8001e0:	6a 41                	push   $0x41
  8001e2:	68 5c 43 80 00       	push   $0x80435c
  8001e7:	e8 ba 02 00 00       	call   8004a6 <_panic>

	//FREE IT
	{
		//Free 1st 2 MB
		{
			freeFrames = sys_calculate_free_frames() ;
  8001ec:	e8 ee 2e 00 00       	call   8030df <sys_calculate_free_frames>
  8001f1:	89 45 d8             	mov    %eax,-0x28(%ebp)
			usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8001f4:	e8 31 2f 00 00       	call   80312a <sys_pf_calculate_allocated_pages>
  8001f9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			free(ptr_allocations[0]);
  8001fc:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
  800202:	83 ec 0c             	sub    $0xc,%esp
  800205:	50                   	push   %eax
  800206:	e8 80 1a 00 00       	call   801c8b <free>
  80020b:	83 c4 10             	add    $0x10,%esp

			if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 0) panic("Wrong free: Extra or less pages are removed from PageFile");
  80020e:	e8 17 2f 00 00       	call   80312a <sys_pf_calculate_allocated_pages>
  800213:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  800216:	74 14                	je     80022c <_main+0x1f4>
  800218:	83 ec 04             	sub    $0x4,%esp
  80021b:	68 74 44 80 00       	push   $0x804474
  800220:	6a 4e                	push   $0x4e
  800222:	68 5c 43 80 00       	push   $0x80435c
  800227:	e8 7a 02 00 00       	call   8004a6 <_panic>
			if ((sys_calculate_free_frames() - freeFrames) != 2 ) panic("Wrong free: WS pages in memory and/or page tables are not freed correctly");
  80022c:	e8 ae 2e 00 00       	call   8030df <sys_calculate_free_frames>
  800231:	89 c2                	mov    %eax,%edx
  800233:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800236:	29 c2                	sub    %eax,%edx
  800238:	89 d0                	mov    %edx,%eax
  80023a:	83 f8 02             	cmp    $0x2,%eax
  80023d:	74 14                	je     800253 <_main+0x21b>
  80023f:	83 ec 04             	sub    $0x4,%esp
  800242:	68 b0 44 80 00       	push   $0x8044b0
  800247:	6a 4f                	push   $0x4f
  800249:	68 5c 43 80 00       	push   $0x80435c
  80024e:	e8 53 02 00 00       	call   8004a6 <_panic>
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
  80028d:	e8 0f 32 00 00       	call   8034a1 <sys_check_WS_list>
  800292:	83 c4 10             	add    $0x10,%esp
  800295:	89 45 b8             	mov    %eax,-0x48(%ebp)
			if (chk != 1) panic("free: page is not removed from WS");
  800298:	83 7d b8 01          	cmpl   $0x1,-0x48(%ebp)
  80029c:	74 14                	je     8002b2 <_main+0x27a>
  80029e:	83 ec 04             	sub    $0x4,%esp
  8002a1:	68 fc 44 80 00       	push   $0x8044fc
  8002a6:	6a 52                	push   $0x52
  8002a8:	68 5c 43 80 00       	push   $0x80435c
  8002ad:	e8 f4 01 00 00       	call   8004a6 <_panic>
		}
	}
	inctst(); //to ensure that it reached here
  8002b2:	e8 2f 31 00 00       	call   8033e6 <inctst>

	//wait until receiving a signal from the master
	while (gettst() != 3) ;
  8002b7:	90                   	nop
  8002b8:	e8 43 31 00 00       	call   803400 <gettst>
  8002bd:	83 f8 03             	cmp    $0x3,%eax
  8002c0:	75 f6                	jne    8002b8 <_main+0x280>

	//Test accessing a freed area but NOT ACCESSED Before (processes should be killed by the validation of the fault handler)
	{
		byteArr[8*kilo] = minByte ;
  8002c2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8002c5:	c1 e0 03             	shl    $0x3,%eax
  8002c8:	89 c2                	mov    %eax,%edx
  8002ca:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8002cd:	01 c2                	add    %eax,%edx
  8002cf:	8a 45 eb             	mov    -0x15(%ebp),%al
  8002d2:	88 02                	mov    %al,(%edx)
		inctst();
  8002d4:	e8 0d 31 00 00       	call   8033e6 <inctst>
		panic("tst_free_1_slave2 failed: The env must be killed and shouldn't return here.");
  8002d9:	83 ec 04             	sub    $0x4,%esp
  8002dc:	68 20 45 80 00       	push   $0x804520
  8002e1:	6a 5e                	push   $0x5e
  8002e3:	68 5c 43 80 00       	push   $0x80435c
  8002e8:	e8 b9 01 00 00       	call   8004a6 <_panic>

008002ed <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  8002ed:	55                   	push   %ebp
  8002ee:	89 e5                	mov    %esp,%ebp
  8002f0:	57                   	push   %edi
  8002f1:	56                   	push   %esi
  8002f2:	53                   	push   %ebx
  8002f3:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  8002f6:	e8 ad 2f 00 00       	call   8032a8 <sys_getenvindex>
  8002fb:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  8002fe:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800301:	89 d0                	mov    %edx,%eax
  800303:	c1 e0 02             	shl    $0x2,%eax
  800306:	01 d0                	add    %edx,%eax
  800308:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80030f:	01 d0                	add    %edx,%eax
  800311:	89 c2                	mov    %eax,%edx
  800313:	c1 e2 04             	shl    $0x4,%edx
  800316:	29 c2                	sub    %eax,%edx
  800318:	8d 04 95 00 00 00 00 	lea    0x0(,%edx,4),%eax
  80031f:	89 c2                	mov    %eax,%edx
  800321:	8d 82 00 00 c0 ee    	lea    -0x11400000(%edx),%eax
  800327:	a3 20 50 80 00       	mov    %eax,0x805020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  80032c:	a1 20 50 80 00       	mov    0x805020,%eax
  800331:	8a 40 20             	mov    0x20(%eax),%al
  800334:	84 c0                	test   %al,%al
  800336:	74 0d                	je     800345 <libmain+0x58>
		binaryname = myEnv->prog_name;
  800338:	a1 20 50 80 00       	mov    0x805020,%eax
  80033d:	83 c0 20             	add    $0x20,%eax
  800340:	a3 04 50 80 00       	mov    %eax,0x805004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800345:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800349:	7e 0a                	jle    800355 <libmain+0x68>
		binaryname = argv[0];
  80034b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80034e:	8b 00                	mov    (%eax),%eax
  800350:	a3 04 50 80 00       	mov    %eax,0x805004

	// call user main routine
	_main(argc, argv);
  800355:	83 ec 08             	sub    $0x8,%esp
  800358:	ff 75 0c             	pushl  0xc(%ebp)
  80035b:	ff 75 08             	pushl  0x8(%ebp)
  80035e:	e8 d5 fc ff ff       	call   800038 <_main>
  800363:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  800366:	a1 00 50 80 00       	mov    0x805000,%eax
  80036b:	85 c0                	test   %eax,%eax
  80036d:	0f 84 01 01 00 00    	je     800474 <libmain+0x187>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  800373:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  800379:	bb 64 46 80 00       	mov    $0x804664,%ebx
  80037e:	ba 0e 00 00 00       	mov    $0xe,%edx
  800383:	89 c7                	mov    %eax,%edi
  800385:	89 de                	mov    %ebx,%esi
  800387:	89 d1                	mov    %edx,%ecx
  800389:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  80038b:	8d 55 8a             	lea    -0x76(%ebp),%edx
  80038e:	b9 56 00 00 00       	mov    $0x56,%ecx
  800393:	b0 00                	mov    $0x0,%al
  800395:	89 d7                	mov    %edx,%edi
  800397:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  800399:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  8003a0:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8003a3:	83 ec 08             	sub    $0x8,%esp
  8003a6:	50                   	push   %eax
  8003a7:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  8003ad:	50                   	push   %eax
  8003ae:	e8 2b 31 00 00       	call   8034de <sys_utilities>
  8003b3:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  8003b6:	e8 74 2c 00 00       	call   80302f <sys_lock_cons>
		{
			cprintf("**************************************\n");
  8003bb:	83 ec 0c             	sub    $0xc,%esp
  8003be:	68 84 45 80 00       	push   $0x804584
  8003c3:	e8 ac 03 00 00       	call   800774 <cprintf>
  8003c8:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  8003cb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8003ce:	85 c0                	test   %eax,%eax
  8003d0:	74 18                	je     8003ea <libmain+0xfd>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  8003d2:	e8 25 31 00 00       	call   8034fc <sys_get_optimal_num_faults>
  8003d7:	83 ec 08             	sub    $0x8,%esp
  8003da:	50                   	push   %eax
  8003db:	68 ac 45 80 00       	push   $0x8045ac
  8003e0:	e8 8f 03 00 00       	call   800774 <cprintf>
  8003e5:	83 c4 10             	add    $0x10,%esp
  8003e8:	eb 59                	jmp    800443 <libmain+0x156>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8003ea:	a1 20 50 80 00       	mov    0x805020,%eax
  8003ef:	8b 90 bc 05 00 00    	mov    0x5bc(%eax),%edx
  8003f5:	a1 20 50 80 00       	mov    0x805020,%eax
  8003fa:	8b 80 ac 05 00 00    	mov    0x5ac(%eax),%eax
  800400:	83 ec 04             	sub    $0x4,%esp
  800403:	52                   	push   %edx
  800404:	50                   	push   %eax
  800405:	68 d0 45 80 00       	push   $0x8045d0
  80040a:	e8 65 03 00 00       	call   800774 <cprintf>
  80040f:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800412:	a1 20 50 80 00       	mov    0x805020,%eax
  800417:	8b 88 d0 05 00 00    	mov    0x5d0(%eax),%ecx
  80041d:	a1 20 50 80 00       	mov    0x805020,%eax
  800422:	8b 90 cc 05 00 00    	mov    0x5cc(%eax),%edx
  800428:	a1 20 50 80 00       	mov    0x805020,%eax
  80042d:	8b 80 c8 05 00 00    	mov    0x5c8(%eax),%eax
  800433:	51                   	push   %ecx
  800434:	52                   	push   %edx
  800435:	50                   	push   %eax
  800436:	68 f8 45 80 00       	push   $0x8045f8
  80043b:	e8 34 03 00 00       	call   800774 <cprintf>
  800440:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800443:	a1 20 50 80 00       	mov    0x805020,%eax
  800448:	8b 80 d4 05 00 00    	mov    0x5d4(%eax),%eax
  80044e:	83 ec 08             	sub    $0x8,%esp
  800451:	50                   	push   %eax
  800452:	68 50 46 80 00       	push   $0x804650
  800457:	e8 18 03 00 00       	call   800774 <cprintf>
  80045c:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  80045f:	83 ec 0c             	sub    $0xc,%esp
  800462:	68 84 45 80 00       	push   $0x804584
  800467:	e8 08 03 00 00       	call   800774 <cprintf>
  80046c:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  80046f:	e8 d5 2b 00 00       	call   803049 <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  800474:	e8 1f 00 00 00       	call   800498 <exit>
}
  800479:	90                   	nop
  80047a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80047d:	5b                   	pop    %ebx
  80047e:	5e                   	pop    %esi
  80047f:	5f                   	pop    %edi
  800480:	5d                   	pop    %ebp
  800481:	c3                   	ret    

00800482 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800482:	55                   	push   %ebp
  800483:	89 e5                	mov    %esp,%ebp
  800485:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800488:	83 ec 0c             	sub    $0xc,%esp
  80048b:	6a 00                	push   $0x0
  80048d:	e8 e2 2d 00 00       	call   803274 <sys_destroy_env>
  800492:	83 c4 10             	add    $0x10,%esp
}
  800495:	90                   	nop
  800496:	c9                   	leave  
  800497:	c3                   	ret    

00800498 <exit>:

void
exit(void)
{
  800498:	55                   	push   %ebp
  800499:	89 e5                	mov    %esp,%ebp
  80049b:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  80049e:	e8 37 2e 00 00       	call   8032da <sys_exit_env>
}
  8004a3:	90                   	nop
  8004a4:	c9                   	leave  
  8004a5:	c3                   	ret    

008004a6 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8004a6:	55                   	push   %ebp
  8004a7:	89 e5                	mov    %esp,%ebp
  8004a9:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8004ac:	8d 45 10             	lea    0x10(%ebp),%eax
  8004af:	83 c0 04             	add    $0x4,%eax
  8004b2:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8004b5:	a1 18 d1 81 00       	mov    0x81d118,%eax
  8004ba:	85 c0                	test   %eax,%eax
  8004bc:	74 16                	je     8004d4 <_panic+0x2e>
		cprintf("%s: ", argv0);
  8004be:	a1 18 d1 81 00       	mov    0x81d118,%eax
  8004c3:	83 ec 08             	sub    $0x8,%esp
  8004c6:	50                   	push   %eax
  8004c7:	68 c8 46 80 00       	push   $0x8046c8
  8004cc:	e8 a3 02 00 00       	call   800774 <cprintf>
  8004d1:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  8004d4:	a1 04 50 80 00       	mov    0x805004,%eax
  8004d9:	83 ec 0c             	sub    $0xc,%esp
  8004dc:	ff 75 0c             	pushl  0xc(%ebp)
  8004df:	ff 75 08             	pushl  0x8(%ebp)
  8004e2:	50                   	push   %eax
  8004e3:	68 d0 46 80 00       	push   $0x8046d0
  8004e8:	6a 74                	push   $0x74
  8004ea:	e8 b2 02 00 00       	call   8007a1 <cprintf_colored>
  8004ef:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  8004f2:	8b 45 10             	mov    0x10(%ebp),%eax
  8004f5:	83 ec 08             	sub    $0x8,%esp
  8004f8:	ff 75 f4             	pushl  -0xc(%ebp)
  8004fb:	50                   	push   %eax
  8004fc:	e8 04 02 00 00       	call   800705 <vcprintf>
  800501:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800504:	83 ec 08             	sub    $0x8,%esp
  800507:	6a 00                	push   $0x0
  800509:	68 f8 46 80 00       	push   $0x8046f8
  80050e:	e8 f2 01 00 00       	call   800705 <vcprintf>
  800513:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800516:	e8 7d ff ff ff       	call   800498 <exit>

	// should not return here
	while (1) ;
  80051b:	eb fe                	jmp    80051b <_panic+0x75>

0080051d <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  80051d:	55                   	push   %ebp
  80051e:	89 e5                	mov    %esp,%ebp
  800520:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800523:	a1 20 50 80 00       	mov    0x805020,%eax
  800528:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  80052e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800531:	39 c2                	cmp    %eax,%edx
  800533:	74 14                	je     800549 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800535:	83 ec 04             	sub    $0x4,%esp
  800538:	68 fc 46 80 00       	push   $0x8046fc
  80053d:	6a 26                	push   $0x26
  80053f:	68 48 47 80 00       	push   $0x804748
  800544:	e8 5d ff ff ff       	call   8004a6 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800549:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800550:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800557:	e9 c5 00 00 00       	jmp    800621 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  80055c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80055f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800566:	8b 45 08             	mov    0x8(%ebp),%eax
  800569:	01 d0                	add    %edx,%eax
  80056b:	8b 00                	mov    (%eax),%eax
  80056d:	85 c0                	test   %eax,%eax
  80056f:	75 08                	jne    800579 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  800571:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800574:	e9 a5 00 00 00       	jmp    80061e <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  800579:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800580:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800587:	eb 69                	jmp    8005f2 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800589:	a1 20 50 80 00       	mov    0x805020,%eax
  80058e:	8b 88 a4 05 00 00    	mov    0x5a4(%eax),%ecx
  800594:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800597:	89 d0                	mov    %edx,%eax
  800599:	01 c0                	add    %eax,%eax
  80059b:	01 d0                	add    %edx,%eax
  80059d:	c1 e0 03             	shl    $0x3,%eax
  8005a0:	01 c8                	add    %ecx,%eax
  8005a2:	8a 40 04             	mov    0x4(%eax),%al
  8005a5:	84 c0                	test   %al,%al
  8005a7:	75 46                	jne    8005ef <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8005a9:	a1 20 50 80 00       	mov    0x805020,%eax
  8005ae:	8b 88 a4 05 00 00    	mov    0x5a4(%eax),%ecx
  8005b4:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8005b7:	89 d0                	mov    %edx,%eax
  8005b9:	01 c0                	add    %eax,%eax
  8005bb:	01 d0                	add    %edx,%eax
  8005bd:	c1 e0 03             	shl    $0x3,%eax
  8005c0:	01 c8                	add    %ecx,%eax
  8005c2:	8b 00                	mov    (%eax),%eax
  8005c4:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8005c7:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8005ca:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8005cf:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8005d1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8005d4:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8005db:	8b 45 08             	mov    0x8(%ebp),%eax
  8005de:	01 c8                	add    %ecx,%eax
  8005e0:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8005e2:	39 c2                	cmp    %eax,%edx
  8005e4:	75 09                	jne    8005ef <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  8005e6:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8005ed:	eb 15                	jmp    800604 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8005ef:	ff 45 e8             	incl   -0x18(%ebp)
  8005f2:	a1 20 50 80 00       	mov    0x805020,%eax
  8005f7:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8005fd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800600:	39 c2                	cmp    %eax,%edx
  800602:	77 85                	ja     800589 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800604:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800608:	75 14                	jne    80061e <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  80060a:	83 ec 04             	sub    $0x4,%esp
  80060d:	68 54 47 80 00       	push   $0x804754
  800612:	6a 3a                	push   $0x3a
  800614:	68 48 47 80 00       	push   $0x804748
  800619:	e8 88 fe ff ff       	call   8004a6 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  80061e:	ff 45 f0             	incl   -0x10(%ebp)
  800621:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800624:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800627:	0f 8c 2f ff ff ff    	jl     80055c <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  80062d:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800634:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80063b:	eb 26                	jmp    800663 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  80063d:	a1 20 50 80 00       	mov    0x805020,%eax
  800642:	8b 88 a4 05 00 00    	mov    0x5a4(%eax),%ecx
  800648:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80064b:	89 d0                	mov    %edx,%eax
  80064d:	01 c0                	add    %eax,%eax
  80064f:	01 d0                	add    %edx,%eax
  800651:	c1 e0 03             	shl    $0x3,%eax
  800654:	01 c8                	add    %ecx,%eax
  800656:	8a 40 04             	mov    0x4(%eax),%al
  800659:	3c 01                	cmp    $0x1,%al
  80065b:	75 03                	jne    800660 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  80065d:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800660:	ff 45 e0             	incl   -0x20(%ebp)
  800663:	a1 20 50 80 00       	mov    0x805020,%eax
  800668:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  80066e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800671:	39 c2                	cmp    %eax,%edx
  800673:	77 c8                	ja     80063d <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800675:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800678:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80067b:	74 14                	je     800691 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  80067d:	83 ec 04             	sub    $0x4,%esp
  800680:	68 a8 47 80 00       	push   $0x8047a8
  800685:	6a 44                	push   $0x44
  800687:	68 48 47 80 00       	push   $0x804748
  80068c:	e8 15 fe ff ff       	call   8004a6 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800691:	90                   	nop
  800692:	c9                   	leave  
  800693:	c3                   	ret    

00800694 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  800694:	55                   	push   %ebp
  800695:	89 e5                	mov    %esp,%ebp
  800697:	53                   	push   %ebx
  800698:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  80069b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80069e:	8b 00                	mov    (%eax),%eax
  8006a0:	8d 48 01             	lea    0x1(%eax),%ecx
  8006a3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8006a6:	89 0a                	mov    %ecx,(%edx)
  8006a8:	8b 55 08             	mov    0x8(%ebp),%edx
  8006ab:	88 d1                	mov    %dl,%cl
  8006ad:	8b 55 0c             	mov    0xc(%ebp),%edx
  8006b0:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8006b4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006b7:	8b 00                	mov    (%eax),%eax
  8006b9:	3d ff 00 00 00       	cmp    $0xff,%eax
  8006be:	75 30                	jne    8006f0 <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  8006c0:	8b 15 1c d1 81 00    	mov    0x81d11c,%edx
  8006c6:	a0 44 50 80 00       	mov    0x805044,%al
  8006cb:	0f b6 c0             	movzbl %al,%eax
  8006ce:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8006d1:	8b 09                	mov    (%ecx),%ecx
  8006d3:	89 cb                	mov    %ecx,%ebx
  8006d5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8006d8:	83 c1 08             	add    $0x8,%ecx
  8006db:	52                   	push   %edx
  8006dc:	50                   	push   %eax
  8006dd:	53                   	push   %ebx
  8006de:	51                   	push   %ecx
  8006df:	e8 07 29 00 00       	call   802feb <sys_cputs>
  8006e4:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8006e7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006ea:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8006f0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006f3:	8b 40 04             	mov    0x4(%eax),%eax
  8006f6:	8d 50 01             	lea    0x1(%eax),%edx
  8006f9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006fc:	89 50 04             	mov    %edx,0x4(%eax)
}
  8006ff:	90                   	nop
  800700:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800703:	c9                   	leave  
  800704:	c3                   	ret    

00800705 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800705:	55                   	push   %ebp
  800706:	89 e5                	mov    %esp,%ebp
  800708:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80070e:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800715:	00 00 00 
	b.cnt = 0;
  800718:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80071f:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800722:	ff 75 0c             	pushl  0xc(%ebp)
  800725:	ff 75 08             	pushl  0x8(%ebp)
  800728:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80072e:	50                   	push   %eax
  80072f:	68 94 06 80 00       	push   $0x800694
  800734:	e8 5a 02 00 00       	call   800993 <vprintfmt>
  800739:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  80073c:	8b 15 1c d1 81 00    	mov    0x81d11c,%edx
  800742:	a0 44 50 80 00       	mov    0x805044,%al
  800747:	0f b6 c0             	movzbl %al,%eax
  80074a:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  800750:	52                   	push   %edx
  800751:	50                   	push   %eax
  800752:	51                   	push   %ecx
  800753:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800759:	83 c0 08             	add    $0x8,%eax
  80075c:	50                   	push   %eax
  80075d:	e8 89 28 00 00       	call   802feb <sys_cputs>
  800762:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800765:	c6 05 44 50 80 00 00 	movb   $0x0,0x805044
	return b.cnt;
  80076c:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800772:	c9                   	leave  
  800773:	c3                   	ret    

00800774 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  800774:	55                   	push   %ebp
  800775:	89 e5                	mov    %esp,%ebp
  800777:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  80077a:	c6 05 44 50 80 00 01 	movb   $0x1,0x805044
	va_start(ap, fmt);
  800781:	8d 45 0c             	lea    0xc(%ebp),%eax
  800784:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800787:	8b 45 08             	mov    0x8(%ebp),%eax
  80078a:	83 ec 08             	sub    $0x8,%esp
  80078d:	ff 75 f4             	pushl  -0xc(%ebp)
  800790:	50                   	push   %eax
  800791:	e8 6f ff ff ff       	call   800705 <vcprintf>
  800796:	83 c4 10             	add    $0x10,%esp
  800799:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  80079c:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80079f:	c9                   	leave  
  8007a0:	c3                   	ret    

008007a1 <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  8007a1:	55                   	push   %ebp
  8007a2:	89 e5                	mov    %esp,%ebp
  8007a4:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8007a7:	c6 05 44 50 80 00 01 	movb   $0x1,0x805044
	curTextClr = (textClr << 8) ; //set text color by the given value
  8007ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8007b1:	c1 e0 08             	shl    $0x8,%eax
  8007b4:	a3 1c d1 81 00       	mov    %eax,0x81d11c
	va_start(ap, fmt);
  8007b9:	8d 45 0c             	lea    0xc(%ebp),%eax
  8007bc:	83 c0 04             	add    $0x4,%eax
  8007bf:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8007c2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007c5:	83 ec 08             	sub    $0x8,%esp
  8007c8:	ff 75 f4             	pushl  -0xc(%ebp)
  8007cb:	50                   	push   %eax
  8007cc:	e8 34 ff ff ff       	call   800705 <vcprintf>
  8007d1:	83 c4 10             	add    $0x10,%esp
  8007d4:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  8007d7:	c7 05 1c d1 81 00 00 	movl   $0x700,0x81d11c
  8007de:	07 00 00 

	return cnt;
  8007e1:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8007e4:	c9                   	leave  
  8007e5:	c3                   	ret    

008007e6 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  8007e6:	55                   	push   %ebp
  8007e7:	89 e5                	mov    %esp,%ebp
  8007e9:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  8007ec:	e8 3e 28 00 00       	call   80302f <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  8007f1:	8d 45 0c             	lea    0xc(%ebp),%eax
  8007f4:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  8007f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8007fa:	83 ec 08             	sub    $0x8,%esp
  8007fd:	ff 75 f4             	pushl  -0xc(%ebp)
  800800:	50                   	push   %eax
  800801:	e8 ff fe ff ff       	call   800705 <vcprintf>
  800806:	83 c4 10             	add    $0x10,%esp
  800809:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  80080c:	e8 38 28 00 00       	call   803049 <sys_unlock_cons>
	return cnt;
  800811:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800814:	c9                   	leave  
  800815:	c3                   	ret    

00800816 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800816:	55                   	push   %ebp
  800817:	89 e5                	mov    %esp,%ebp
  800819:	53                   	push   %ebx
  80081a:	83 ec 14             	sub    $0x14,%esp
  80081d:	8b 45 10             	mov    0x10(%ebp),%eax
  800820:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800823:	8b 45 14             	mov    0x14(%ebp),%eax
  800826:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800829:	8b 45 18             	mov    0x18(%ebp),%eax
  80082c:	ba 00 00 00 00       	mov    $0x0,%edx
  800831:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800834:	77 55                	ja     80088b <printnum+0x75>
  800836:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800839:	72 05                	jb     800840 <printnum+0x2a>
  80083b:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80083e:	77 4b                	ja     80088b <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800840:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800843:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800846:	8b 45 18             	mov    0x18(%ebp),%eax
  800849:	ba 00 00 00 00       	mov    $0x0,%edx
  80084e:	52                   	push   %edx
  80084f:	50                   	push   %eax
  800850:	ff 75 f4             	pushl  -0xc(%ebp)
  800853:	ff 75 f0             	pushl  -0x10(%ebp)
  800856:	e8 81 38 00 00       	call   8040dc <__udivdi3>
  80085b:	83 c4 10             	add    $0x10,%esp
  80085e:	83 ec 04             	sub    $0x4,%esp
  800861:	ff 75 20             	pushl  0x20(%ebp)
  800864:	53                   	push   %ebx
  800865:	ff 75 18             	pushl  0x18(%ebp)
  800868:	52                   	push   %edx
  800869:	50                   	push   %eax
  80086a:	ff 75 0c             	pushl  0xc(%ebp)
  80086d:	ff 75 08             	pushl  0x8(%ebp)
  800870:	e8 a1 ff ff ff       	call   800816 <printnum>
  800875:	83 c4 20             	add    $0x20,%esp
  800878:	eb 1a                	jmp    800894 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80087a:	83 ec 08             	sub    $0x8,%esp
  80087d:	ff 75 0c             	pushl  0xc(%ebp)
  800880:	ff 75 20             	pushl  0x20(%ebp)
  800883:	8b 45 08             	mov    0x8(%ebp),%eax
  800886:	ff d0                	call   *%eax
  800888:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80088b:	ff 4d 1c             	decl   0x1c(%ebp)
  80088e:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800892:	7f e6                	jg     80087a <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800894:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800897:	bb 00 00 00 00       	mov    $0x0,%ebx
  80089c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80089f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8008a2:	53                   	push   %ebx
  8008a3:	51                   	push   %ecx
  8008a4:	52                   	push   %edx
  8008a5:	50                   	push   %eax
  8008a6:	e8 41 39 00 00       	call   8041ec <__umoddi3>
  8008ab:	83 c4 10             	add    $0x10,%esp
  8008ae:	05 14 4a 80 00       	add    $0x804a14,%eax
  8008b3:	8a 00                	mov    (%eax),%al
  8008b5:	0f be c0             	movsbl %al,%eax
  8008b8:	83 ec 08             	sub    $0x8,%esp
  8008bb:	ff 75 0c             	pushl  0xc(%ebp)
  8008be:	50                   	push   %eax
  8008bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8008c2:	ff d0                	call   *%eax
  8008c4:	83 c4 10             	add    $0x10,%esp
}
  8008c7:	90                   	nop
  8008c8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8008cb:	c9                   	leave  
  8008cc:	c3                   	ret    

008008cd <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8008cd:	55                   	push   %ebp
  8008ce:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8008d0:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8008d4:	7e 1c                	jle    8008f2 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8008d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8008d9:	8b 00                	mov    (%eax),%eax
  8008db:	8d 50 08             	lea    0x8(%eax),%edx
  8008de:	8b 45 08             	mov    0x8(%ebp),%eax
  8008e1:	89 10                	mov    %edx,(%eax)
  8008e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8008e6:	8b 00                	mov    (%eax),%eax
  8008e8:	83 e8 08             	sub    $0x8,%eax
  8008eb:	8b 50 04             	mov    0x4(%eax),%edx
  8008ee:	8b 00                	mov    (%eax),%eax
  8008f0:	eb 40                	jmp    800932 <getuint+0x65>
	else if (lflag)
  8008f2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8008f6:	74 1e                	je     800916 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8008f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8008fb:	8b 00                	mov    (%eax),%eax
  8008fd:	8d 50 04             	lea    0x4(%eax),%edx
  800900:	8b 45 08             	mov    0x8(%ebp),%eax
  800903:	89 10                	mov    %edx,(%eax)
  800905:	8b 45 08             	mov    0x8(%ebp),%eax
  800908:	8b 00                	mov    (%eax),%eax
  80090a:	83 e8 04             	sub    $0x4,%eax
  80090d:	8b 00                	mov    (%eax),%eax
  80090f:	ba 00 00 00 00       	mov    $0x0,%edx
  800914:	eb 1c                	jmp    800932 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800916:	8b 45 08             	mov    0x8(%ebp),%eax
  800919:	8b 00                	mov    (%eax),%eax
  80091b:	8d 50 04             	lea    0x4(%eax),%edx
  80091e:	8b 45 08             	mov    0x8(%ebp),%eax
  800921:	89 10                	mov    %edx,(%eax)
  800923:	8b 45 08             	mov    0x8(%ebp),%eax
  800926:	8b 00                	mov    (%eax),%eax
  800928:	83 e8 04             	sub    $0x4,%eax
  80092b:	8b 00                	mov    (%eax),%eax
  80092d:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800932:	5d                   	pop    %ebp
  800933:	c3                   	ret    

00800934 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800934:	55                   	push   %ebp
  800935:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800937:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80093b:	7e 1c                	jle    800959 <getint+0x25>
		return va_arg(*ap, long long);
  80093d:	8b 45 08             	mov    0x8(%ebp),%eax
  800940:	8b 00                	mov    (%eax),%eax
  800942:	8d 50 08             	lea    0x8(%eax),%edx
  800945:	8b 45 08             	mov    0x8(%ebp),%eax
  800948:	89 10                	mov    %edx,(%eax)
  80094a:	8b 45 08             	mov    0x8(%ebp),%eax
  80094d:	8b 00                	mov    (%eax),%eax
  80094f:	83 e8 08             	sub    $0x8,%eax
  800952:	8b 50 04             	mov    0x4(%eax),%edx
  800955:	8b 00                	mov    (%eax),%eax
  800957:	eb 38                	jmp    800991 <getint+0x5d>
	else if (lflag)
  800959:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80095d:	74 1a                	je     800979 <getint+0x45>
		return va_arg(*ap, long);
  80095f:	8b 45 08             	mov    0x8(%ebp),%eax
  800962:	8b 00                	mov    (%eax),%eax
  800964:	8d 50 04             	lea    0x4(%eax),%edx
  800967:	8b 45 08             	mov    0x8(%ebp),%eax
  80096a:	89 10                	mov    %edx,(%eax)
  80096c:	8b 45 08             	mov    0x8(%ebp),%eax
  80096f:	8b 00                	mov    (%eax),%eax
  800971:	83 e8 04             	sub    $0x4,%eax
  800974:	8b 00                	mov    (%eax),%eax
  800976:	99                   	cltd   
  800977:	eb 18                	jmp    800991 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800979:	8b 45 08             	mov    0x8(%ebp),%eax
  80097c:	8b 00                	mov    (%eax),%eax
  80097e:	8d 50 04             	lea    0x4(%eax),%edx
  800981:	8b 45 08             	mov    0x8(%ebp),%eax
  800984:	89 10                	mov    %edx,(%eax)
  800986:	8b 45 08             	mov    0x8(%ebp),%eax
  800989:	8b 00                	mov    (%eax),%eax
  80098b:	83 e8 04             	sub    $0x4,%eax
  80098e:	8b 00                	mov    (%eax),%eax
  800990:	99                   	cltd   
}
  800991:	5d                   	pop    %ebp
  800992:	c3                   	ret    

00800993 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800993:	55                   	push   %ebp
  800994:	89 e5                	mov    %esp,%ebp
  800996:	56                   	push   %esi
  800997:	53                   	push   %ebx
  800998:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80099b:	eb 17                	jmp    8009b4 <vprintfmt+0x21>
			if (ch == '\0')
  80099d:	85 db                	test   %ebx,%ebx
  80099f:	0f 84 c1 03 00 00    	je     800d66 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  8009a5:	83 ec 08             	sub    $0x8,%esp
  8009a8:	ff 75 0c             	pushl  0xc(%ebp)
  8009ab:	53                   	push   %ebx
  8009ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8009af:	ff d0                	call   *%eax
  8009b1:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8009b4:	8b 45 10             	mov    0x10(%ebp),%eax
  8009b7:	8d 50 01             	lea    0x1(%eax),%edx
  8009ba:	89 55 10             	mov    %edx,0x10(%ebp)
  8009bd:	8a 00                	mov    (%eax),%al
  8009bf:	0f b6 d8             	movzbl %al,%ebx
  8009c2:	83 fb 25             	cmp    $0x25,%ebx
  8009c5:	75 d6                	jne    80099d <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8009c7:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  8009cb:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  8009d2:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8009d9:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8009e0:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8009e7:	8b 45 10             	mov    0x10(%ebp),%eax
  8009ea:	8d 50 01             	lea    0x1(%eax),%edx
  8009ed:	89 55 10             	mov    %edx,0x10(%ebp)
  8009f0:	8a 00                	mov    (%eax),%al
  8009f2:	0f b6 d8             	movzbl %al,%ebx
  8009f5:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8009f8:	83 f8 5b             	cmp    $0x5b,%eax
  8009fb:	0f 87 3d 03 00 00    	ja     800d3e <vprintfmt+0x3ab>
  800a01:	8b 04 85 38 4a 80 00 	mov    0x804a38(,%eax,4),%eax
  800a08:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800a0a:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800a0e:	eb d7                	jmp    8009e7 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800a10:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800a14:	eb d1                	jmp    8009e7 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800a16:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800a1d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800a20:	89 d0                	mov    %edx,%eax
  800a22:	c1 e0 02             	shl    $0x2,%eax
  800a25:	01 d0                	add    %edx,%eax
  800a27:	01 c0                	add    %eax,%eax
  800a29:	01 d8                	add    %ebx,%eax
  800a2b:	83 e8 30             	sub    $0x30,%eax
  800a2e:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800a31:	8b 45 10             	mov    0x10(%ebp),%eax
  800a34:	8a 00                	mov    (%eax),%al
  800a36:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800a39:	83 fb 2f             	cmp    $0x2f,%ebx
  800a3c:	7e 3e                	jle    800a7c <vprintfmt+0xe9>
  800a3e:	83 fb 39             	cmp    $0x39,%ebx
  800a41:	7f 39                	jg     800a7c <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800a43:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800a46:	eb d5                	jmp    800a1d <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800a48:	8b 45 14             	mov    0x14(%ebp),%eax
  800a4b:	83 c0 04             	add    $0x4,%eax
  800a4e:	89 45 14             	mov    %eax,0x14(%ebp)
  800a51:	8b 45 14             	mov    0x14(%ebp),%eax
  800a54:	83 e8 04             	sub    $0x4,%eax
  800a57:	8b 00                	mov    (%eax),%eax
  800a59:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800a5c:	eb 1f                	jmp    800a7d <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800a5e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a62:	79 83                	jns    8009e7 <vprintfmt+0x54>
				width = 0;
  800a64:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800a6b:	e9 77 ff ff ff       	jmp    8009e7 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800a70:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800a77:	e9 6b ff ff ff       	jmp    8009e7 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800a7c:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800a7d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a81:	0f 89 60 ff ff ff    	jns    8009e7 <vprintfmt+0x54>
				width = precision, precision = -1;
  800a87:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800a8a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800a8d:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800a94:	e9 4e ff ff ff       	jmp    8009e7 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800a99:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800a9c:	e9 46 ff ff ff       	jmp    8009e7 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800aa1:	8b 45 14             	mov    0x14(%ebp),%eax
  800aa4:	83 c0 04             	add    $0x4,%eax
  800aa7:	89 45 14             	mov    %eax,0x14(%ebp)
  800aaa:	8b 45 14             	mov    0x14(%ebp),%eax
  800aad:	83 e8 04             	sub    $0x4,%eax
  800ab0:	8b 00                	mov    (%eax),%eax
  800ab2:	83 ec 08             	sub    $0x8,%esp
  800ab5:	ff 75 0c             	pushl  0xc(%ebp)
  800ab8:	50                   	push   %eax
  800ab9:	8b 45 08             	mov    0x8(%ebp),%eax
  800abc:	ff d0                	call   *%eax
  800abe:	83 c4 10             	add    $0x10,%esp
			break;
  800ac1:	e9 9b 02 00 00       	jmp    800d61 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800ac6:	8b 45 14             	mov    0x14(%ebp),%eax
  800ac9:	83 c0 04             	add    $0x4,%eax
  800acc:	89 45 14             	mov    %eax,0x14(%ebp)
  800acf:	8b 45 14             	mov    0x14(%ebp),%eax
  800ad2:	83 e8 04             	sub    $0x4,%eax
  800ad5:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800ad7:	85 db                	test   %ebx,%ebx
  800ad9:	79 02                	jns    800add <vprintfmt+0x14a>
				err = -err;
  800adb:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800add:	83 fb 64             	cmp    $0x64,%ebx
  800ae0:	7f 0b                	jg     800aed <vprintfmt+0x15a>
  800ae2:	8b 34 9d 80 48 80 00 	mov    0x804880(,%ebx,4),%esi
  800ae9:	85 f6                	test   %esi,%esi
  800aeb:	75 19                	jne    800b06 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800aed:	53                   	push   %ebx
  800aee:	68 25 4a 80 00       	push   $0x804a25
  800af3:	ff 75 0c             	pushl  0xc(%ebp)
  800af6:	ff 75 08             	pushl  0x8(%ebp)
  800af9:	e8 70 02 00 00       	call   800d6e <printfmt>
  800afe:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800b01:	e9 5b 02 00 00       	jmp    800d61 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800b06:	56                   	push   %esi
  800b07:	68 2e 4a 80 00       	push   $0x804a2e
  800b0c:	ff 75 0c             	pushl  0xc(%ebp)
  800b0f:	ff 75 08             	pushl  0x8(%ebp)
  800b12:	e8 57 02 00 00       	call   800d6e <printfmt>
  800b17:	83 c4 10             	add    $0x10,%esp
			break;
  800b1a:	e9 42 02 00 00       	jmp    800d61 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800b1f:	8b 45 14             	mov    0x14(%ebp),%eax
  800b22:	83 c0 04             	add    $0x4,%eax
  800b25:	89 45 14             	mov    %eax,0x14(%ebp)
  800b28:	8b 45 14             	mov    0x14(%ebp),%eax
  800b2b:	83 e8 04             	sub    $0x4,%eax
  800b2e:	8b 30                	mov    (%eax),%esi
  800b30:	85 f6                	test   %esi,%esi
  800b32:	75 05                	jne    800b39 <vprintfmt+0x1a6>
				p = "(null)";
  800b34:	be 31 4a 80 00       	mov    $0x804a31,%esi
			if (width > 0 && padc != '-')
  800b39:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b3d:	7e 6d                	jle    800bac <vprintfmt+0x219>
  800b3f:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800b43:	74 67                	je     800bac <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800b45:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800b48:	83 ec 08             	sub    $0x8,%esp
  800b4b:	50                   	push   %eax
  800b4c:	56                   	push   %esi
  800b4d:	e8 1e 03 00 00       	call   800e70 <strnlen>
  800b52:	83 c4 10             	add    $0x10,%esp
  800b55:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800b58:	eb 16                	jmp    800b70 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800b5a:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800b5e:	83 ec 08             	sub    $0x8,%esp
  800b61:	ff 75 0c             	pushl  0xc(%ebp)
  800b64:	50                   	push   %eax
  800b65:	8b 45 08             	mov    0x8(%ebp),%eax
  800b68:	ff d0                	call   *%eax
  800b6a:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800b6d:	ff 4d e4             	decl   -0x1c(%ebp)
  800b70:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b74:	7f e4                	jg     800b5a <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b76:	eb 34                	jmp    800bac <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800b78:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800b7c:	74 1c                	je     800b9a <vprintfmt+0x207>
  800b7e:	83 fb 1f             	cmp    $0x1f,%ebx
  800b81:	7e 05                	jle    800b88 <vprintfmt+0x1f5>
  800b83:	83 fb 7e             	cmp    $0x7e,%ebx
  800b86:	7e 12                	jle    800b9a <vprintfmt+0x207>
					putch('?', putdat);
  800b88:	83 ec 08             	sub    $0x8,%esp
  800b8b:	ff 75 0c             	pushl  0xc(%ebp)
  800b8e:	6a 3f                	push   $0x3f
  800b90:	8b 45 08             	mov    0x8(%ebp),%eax
  800b93:	ff d0                	call   *%eax
  800b95:	83 c4 10             	add    $0x10,%esp
  800b98:	eb 0f                	jmp    800ba9 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800b9a:	83 ec 08             	sub    $0x8,%esp
  800b9d:	ff 75 0c             	pushl  0xc(%ebp)
  800ba0:	53                   	push   %ebx
  800ba1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ba4:	ff d0                	call   *%eax
  800ba6:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800ba9:	ff 4d e4             	decl   -0x1c(%ebp)
  800bac:	89 f0                	mov    %esi,%eax
  800bae:	8d 70 01             	lea    0x1(%eax),%esi
  800bb1:	8a 00                	mov    (%eax),%al
  800bb3:	0f be d8             	movsbl %al,%ebx
  800bb6:	85 db                	test   %ebx,%ebx
  800bb8:	74 24                	je     800bde <vprintfmt+0x24b>
  800bba:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800bbe:	78 b8                	js     800b78 <vprintfmt+0x1e5>
  800bc0:	ff 4d e0             	decl   -0x20(%ebp)
  800bc3:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800bc7:	79 af                	jns    800b78 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800bc9:	eb 13                	jmp    800bde <vprintfmt+0x24b>
				putch(' ', putdat);
  800bcb:	83 ec 08             	sub    $0x8,%esp
  800bce:	ff 75 0c             	pushl  0xc(%ebp)
  800bd1:	6a 20                	push   $0x20
  800bd3:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd6:	ff d0                	call   *%eax
  800bd8:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800bdb:	ff 4d e4             	decl   -0x1c(%ebp)
  800bde:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800be2:	7f e7                	jg     800bcb <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800be4:	e9 78 01 00 00       	jmp    800d61 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800be9:	83 ec 08             	sub    $0x8,%esp
  800bec:	ff 75 e8             	pushl  -0x18(%ebp)
  800bef:	8d 45 14             	lea    0x14(%ebp),%eax
  800bf2:	50                   	push   %eax
  800bf3:	e8 3c fd ff ff       	call   800934 <getint>
  800bf8:	83 c4 10             	add    $0x10,%esp
  800bfb:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bfe:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800c01:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c04:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800c07:	85 d2                	test   %edx,%edx
  800c09:	79 23                	jns    800c2e <vprintfmt+0x29b>
				putch('-', putdat);
  800c0b:	83 ec 08             	sub    $0x8,%esp
  800c0e:	ff 75 0c             	pushl  0xc(%ebp)
  800c11:	6a 2d                	push   $0x2d
  800c13:	8b 45 08             	mov    0x8(%ebp),%eax
  800c16:	ff d0                	call   *%eax
  800c18:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800c1b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c1e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800c21:	f7 d8                	neg    %eax
  800c23:	83 d2 00             	adc    $0x0,%edx
  800c26:	f7 da                	neg    %edx
  800c28:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c2b:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800c2e:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800c35:	e9 bc 00 00 00       	jmp    800cf6 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800c3a:	83 ec 08             	sub    $0x8,%esp
  800c3d:	ff 75 e8             	pushl  -0x18(%ebp)
  800c40:	8d 45 14             	lea    0x14(%ebp),%eax
  800c43:	50                   	push   %eax
  800c44:	e8 84 fc ff ff       	call   8008cd <getuint>
  800c49:	83 c4 10             	add    $0x10,%esp
  800c4c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c4f:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800c52:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800c59:	e9 98 00 00 00       	jmp    800cf6 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800c5e:	83 ec 08             	sub    $0x8,%esp
  800c61:	ff 75 0c             	pushl  0xc(%ebp)
  800c64:	6a 58                	push   $0x58
  800c66:	8b 45 08             	mov    0x8(%ebp),%eax
  800c69:	ff d0                	call   *%eax
  800c6b:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800c6e:	83 ec 08             	sub    $0x8,%esp
  800c71:	ff 75 0c             	pushl  0xc(%ebp)
  800c74:	6a 58                	push   $0x58
  800c76:	8b 45 08             	mov    0x8(%ebp),%eax
  800c79:	ff d0                	call   *%eax
  800c7b:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800c7e:	83 ec 08             	sub    $0x8,%esp
  800c81:	ff 75 0c             	pushl  0xc(%ebp)
  800c84:	6a 58                	push   $0x58
  800c86:	8b 45 08             	mov    0x8(%ebp),%eax
  800c89:	ff d0                	call   *%eax
  800c8b:	83 c4 10             	add    $0x10,%esp
			break;
  800c8e:	e9 ce 00 00 00       	jmp    800d61 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800c93:	83 ec 08             	sub    $0x8,%esp
  800c96:	ff 75 0c             	pushl  0xc(%ebp)
  800c99:	6a 30                	push   $0x30
  800c9b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c9e:	ff d0                	call   *%eax
  800ca0:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800ca3:	83 ec 08             	sub    $0x8,%esp
  800ca6:	ff 75 0c             	pushl  0xc(%ebp)
  800ca9:	6a 78                	push   $0x78
  800cab:	8b 45 08             	mov    0x8(%ebp),%eax
  800cae:	ff d0                	call   *%eax
  800cb0:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800cb3:	8b 45 14             	mov    0x14(%ebp),%eax
  800cb6:	83 c0 04             	add    $0x4,%eax
  800cb9:	89 45 14             	mov    %eax,0x14(%ebp)
  800cbc:	8b 45 14             	mov    0x14(%ebp),%eax
  800cbf:	83 e8 04             	sub    $0x4,%eax
  800cc2:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800cc4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800cc7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800cce:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800cd5:	eb 1f                	jmp    800cf6 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800cd7:	83 ec 08             	sub    $0x8,%esp
  800cda:	ff 75 e8             	pushl  -0x18(%ebp)
  800cdd:	8d 45 14             	lea    0x14(%ebp),%eax
  800ce0:	50                   	push   %eax
  800ce1:	e8 e7 fb ff ff       	call   8008cd <getuint>
  800ce6:	83 c4 10             	add    $0x10,%esp
  800ce9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800cec:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800cef:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800cf6:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800cfa:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800cfd:	83 ec 04             	sub    $0x4,%esp
  800d00:	52                   	push   %edx
  800d01:	ff 75 e4             	pushl  -0x1c(%ebp)
  800d04:	50                   	push   %eax
  800d05:	ff 75 f4             	pushl  -0xc(%ebp)
  800d08:	ff 75 f0             	pushl  -0x10(%ebp)
  800d0b:	ff 75 0c             	pushl  0xc(%ebp)
  800d0e:	ff 75 08             	pushl  0x8(%ebp)
  800d11:	e8 00 fb ff ff       	call   800816 <printnum>
  800d16:	83 c4 20             	add    $0x20,%esp
			break;
  800d19:	eb 46                	jmp    800d61 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800d1b:	83 ec 08             	sub    $0x8,%esp
  800d1e:	ff 75 0c             	pushl  0xc(%ebp)
  800d21:	53                   	push   %ebx
  800d22:	8b 45 08             	mov    0x8(%ebp),%eax
  800d25:	ff d0                	call   *%eax
  800d27:	83 c4 10             	add    $0x10,%esp
			break;
  800d2a:	eb 35                	jmp    800d61 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800d2c:	c6 05 44 50 80 00 00 	movb   $0x0,0x805044
			break;
  800d33:	eb 2c                	jmp    800d61 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800d35:	c6 05 44 50 80 00 01 	movb   $0x1,0x805044
			break;
  800d3c:	eb 23                	jmp    800d61 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800d3e:	83 ec 08             	sub    $0x8,%esp
  800d41:	ff 75 0c             	pushl  0xc(%ebp)
  800d44:	6a 25                	push   $0x25
  800d46:	8b 45 08             	mov    0x8(%ebp),%eax
  800d49:	ff d0                	call   *%eax
  800d4b:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800d4e:	ff 4d 10             	decl   0x10(%ebp)
  800d51:	eb 03                	jmp    800d56 <vprintfmt+0x3c3>
  800d53:	ff 4d 10             	decl   0x10(%ebp)
  800d56:	8b 45 10             	mov    0x10(%ebp),%eax
  800d59:	48                   	dec    %eax
  800d5a:	8a 00                	mov    (%eax),%al
  800d5c:	3c 25                	cmp    $0x25,%al
  800d5e:	75 f3                	jne    800d53 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800d60:	90                   	nop
		}
	}
  800d61:	e9 35 fc ff ff       	jmp    80099b <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800d66:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800d67:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800d6a:	5b                   	pop    %ebx
  800d6b:	5e                   	pop    %esi
  800d6c:	5d                   	pop    %ebp
  800d6d:	c3                   	ret    

00800d6e <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800d6e:	55                   	push   %ebp
  800d6f:	89 e5                	mov    %esp,%ebp
  800d71:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800d74:	8d 45 10             	lea    0x10(%ebp),%eax
  800d77:	83 c0 04             	add    $0x4,%eax
  800d7a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800d7d:	8b 45 10             	mov    0x10(%ebp),%eax
  800d80:	ff 75 f4             	pushl  -0xc(%ebp)
  800d83:	50                   	push   %eax
  800d84:	ff 75 0c             	pushl  0xc(%ebp)
  800d87:	ff 75 08             	pushl  0x8(%ebp)
  800d8a:	e8 04 fc ff ff       	call   800993 <vprintfmt>
  800d8f:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800d92:	90                   	nop
  800d93:	c9                   	leave  
  800d94:	c3                   	ret    

00800d95 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800d95:	55                   	push   %ebp
  800d96:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800d98:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d9b:	8b 40 08             	mov    0x8(%eax),%eax
  800d9e:	8d 50 01             	lea    0x1(%eax),%edx
  800da1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800da4:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800da7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800daa:	8b 10                	mov    (%eax),%edx
  800dac:	8b 45 0c             	mov    0xc(%ebp),%eax
  800daf:	8b 40 04             	mov    0x4(%eax),%eax
  800db2:	39 c2                	cmp    %eax,%edx
  800db4:	73 12                	jae    800dc8 <sprintputch+0x33>
		*b->buf++ = ch;
  800db6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800db9:	8b 00                	mov    (%eax),%eax
  800dbb:	8d 48 01             	lea    0x1(%eax),%ecx
  800dbe:	8b 55 0c             	mov    0xc(%ebp),%edx
  800dc1:	89 0a                	mov    %ecx,(%edx)
  800dc3:	8b 55 08             	mov    0x8(%ebp),%edx
  800dc6:	88 10                	mov    %dl,(%eax)
}
  800dc8:	90                   	nop
  800dc9:	5d                   	pop    %ebp
  800dca:	c3                   	ret    

00800dcb <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800dcb:	55                   	push   %ebp
  800dcc:	89 e5                	mov    %esp,%ebp
  800dce:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800dd1:	8b 45 08             	mov    0x8(%ebp),%eax
  800dd4:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800dd7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dda:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ddd:	8b 45 08             	mov    0x8(%ebp),%eax
  800de0:	01 d0                	add    %edx,%eax
  800de2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800de5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800dec:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800df0:	74 06                	je     800df8 <vsnprintf+0x2d>
  800df2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800df6:	7f 07                	jg     800dff <vsnprintf+0x34>
		return -E_INVAL;
  800df8:	b8 03 00 00 00       	mov    $0x3,%eax
  800dfd:	eb 20                	jmp    800e1f <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800dff:	ff 75 14             	pushl  0x14(%ebp)
  800e02:	ff 75 10             	pushl  0x10(%ebp)
  800e05:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800e08:	50                   	push   %eax
  800e09:	68 95 0d 80 00       	push   $0x800d95
  800e0e:	e8 80 fb ff ff       	call   800993 <vprintfmt>
  800e13:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800e16:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800e19:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800e1c:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800e1f:	c9                   	leave  
  800e20:	c3                   	ret    

00800e21 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800e21:	55                   	push   %ebp
  800e22:	89 e5                	mov    %esp,%ebp
  800e24:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800e27:	8d 45 10             	lea    0x10(%ebp),%eax
  800e2a:	83 c0 04             	add    $0x4,%eax
  800e2d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800e30:	8b 45 10             	mov    0x10(%ebp),%eax
  800e33:	ff 75 f4             	pushl  -0xc(%ebp)
  800e36:	50                   	push   %eax
  800e37:	ff 75 0c             	pushl  0xc(%ebp)
  800e3a:	ff 75 08             	pushl  0x8(%ebp)
  800e3d:	e8 89 ff ff ff       	call   800dcb <vsnprintf>
  800e42:	83 c4 10             	add    $0x10,%esp
  800e45:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800e48:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800e4b:	c9                   	leave  
  800e4c:	c3                   	ret    

00800e4d <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800e4d:	55                   	push   %ebp
  800e4e:	89 e5                	mov    %esp,%ebp
  800e50:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800e53:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800e5a:	eb 06                	jmp    800e62 <strlen+0x15>
		n++;
  800e5c:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800e5f:	ff 45 08             	incl   0x8(%ebp)
  800e62:	8b 45 08             	mov    0x8(%ebp),%eax
  800e65:	8a 00                	mov    (%eax),%al
  800e67:	84 c0                	test   %al,%al
  800e69:	75 f1                	jne    800e5c <strlen+0xf>
		n++;
	return n;
  800e6b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e6e:	c9                   	leave  
  800e6f:	c3                   	ret    

00800e70 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800e70:	55                   	push   %ebp
  800e71:	89 e5                	mov    %esp,%ebp
  800e73:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800e76:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800e7d:	eb 09                	jmp    800e88 <strnlen+0x18>
		n++;
  800e7f:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800e82:	ff 45 08             	incl   0x8(%ebp)
  800e85:	ff 4d 0c             	decl   0xc(%ebp)
  800e88:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e8c:	74 09                	je     800e97 <strnlen+0x27>
  800e8e:	8b 45 08             	mov    0x8(%ebp),%eax
  800e91:	8a 00                	mov    (%eax),%al
  800e93:	84 c0                	test   %al,%al
  800e95:	75 e8                	jne    800e7f <strnlen+0xf>
		n++;
	return n;
  800e97:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e9a:	c9                   	leave  
  800e9b:	c3                   	ret    

00800e9c <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800e9c:	55                   	push   %ebp
  800e9d:	89 e5                	mov    %esp,%ebp
  800e9f:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800ea2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ea5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800ea8:	90                   	nop
  800ea9:	8b 45 08             	mov    0x8(%ebp),%eax
  800eac:	8d 50 01             	lea    0x1(%eax),%edx
  800eaf:	89 55 08             	mov    %edx,0x8(%ebp)
  800eb2:	8b 55 0c             	mov    0xc(%ebp),%edx
  800eb5:	8d 4a 01             	lea    0x1(%edx),%ecx
  800eb8:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800ebb:	8a 12                	mov    (%edx),%dl
  800ebd:	88 10                	mov    %dl,(%eax)
  800ebf:	8a 00                	mov    (%eax),%al
  800ec1:	84 c0                	test   %al,%al
  800ec3:	75 e4                	jne    800ea9 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800ec5:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800ec8:	c9                   	leave  
  800ec9:	c3                   	ret    

00800eca <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800eca:	55                   	push   %ebp
  800ecb:	89 e5                	mov    %esp,%ebp
  800ecd:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800ed0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ed3:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800ed6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800edd:	eb 1f                	jmp    800efe <strncpy+0x34>
		*dst++ = *src;
  800edf:	8b 45 08             	mov    0x8(%ebp),%eax
  800ee2:	8d 50 01             	lea    0x1(%eax),%edx
  800ee5:	89 55 08             	mov    %edx,0x8(%ebp)
  800ee8:	8b 55 0c             	mov    0xc(%ebp),%edx
  800eeb:	8a 12                	mov    (%edx),%dl
  800eed:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800eef:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ef2:	8a 00                	mov    (%eax),%al
  800ef4:	84 c0                	test   %al,%al
  800ef6:	74 03                	je     800efb <strncpy+0x31>
			src++;
  800ef8:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800efb:	ff 45 fc             	incl   -0x4(%ebp)
  800efe:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f01:	3b 45 10             	cmp    0x10(%ebp),%eax
  800f04:	72 d9                	jb     800edf <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800f06:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800f09:	c9                   	leave  
  800f0a:	c3                   	ret    

00800f0b <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800f0b:	55                   	push   %ebp
  800f0c:	89 e5                	mov    %esp,%ebp
  800f0e:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800f11:	8b 45 08             	mov    0x8(%ebp),%eax
  800f14:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800f17:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f1b:	74 30                	je     800f4d <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800f1d:	eb 16                	jmp    800f35 <strlcpy+0x2a>
			*dst++ = *src++;
  800f1f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f22:	8d 50 01             	lea    0x1(%eax),%edx
  800f25:	89 55 08             	mov    %edx,0x8(%ebp)
  800f28:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f2b:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f2e:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800f31:	8a 12                	mov    (%edx),%dl
  800f33:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800f35:	ff 4d 10             	decl   0x10(%ebp)
  800f38:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f3c:	74 09                	je     800f47 <strlcpy+0x3c>
  800f3e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f41:	8a 00                	mov    (%eax),%al
  800f43:	84 c0                	test   %al,%al
  800f45:	75 d8                	jne    800f1f <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800f47:	8b 45 08             	mov    0x8(%ebp),%eax
  800f4a:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800f4d:	8b 55 08             	mov    0x8(%ebp),%edx
  800f50:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f53:	29 c2                	sub    %eax,%edx
  800f55:	89 d0                	mov    %edx,%eax
}
  800f57:	c9                   	leave  
  800f58:	c3                   	ret    

00800f59 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800f59:	55                   	push   %ebp
  800f5a:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800f5c:	eb 06                	jmp    800f64 <strcmp+0xb>
		p++, q++;
  800f5e:	ff 45 08             	incl   0x8(%ebp)
  800f61:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800f64:	8b 45 08             	mov    0x8(%ebp),%eax
  800f67:	8a 00                	mov    (%eax),%al
  800f69:	84 c0                	test   %al,%al
  800f6b:	74 0e                	je     800f7b <strcmp+0x22>
  800f6d:	8b 45 08             	mov    0x8(%ebp),%eax
  800f70:	8a 10                	mov    (%eax),%dl
  800f72:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f75:	8a 00                	mov    (%eax),%al
  800f77:	38 c2                	cmp    %al,%dl
  800f79:	74 e3                	je     800f5e <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800f7b:	8b 45 08             	mov    0x8(%ebp),%eax
  800f7e:	8a 00                	mov    (%eax),%al
  800f80:	0f b6 d0             	movzbl %al,%edx
  800f83:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f86:	8a 00                	mov    (%eax),%al
  800f88:	0f b6 c0             	movzbl %al,%eax
  800f8b:	29 c2                	sub    %eax,%edx
  800f8d:	89 d0                	mov    %edx,%eax
}
  800f8f:	5d                   	pop    %ebp
  800f90:	c3                   	ret    

00800f91 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800f91:	55                   	push   %ebp
  800f92:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800f94:	eb 09                	jmp    800f9f <strncmp+0xe>
		n--, p++, q++;
  800f96:	ff 4d 10             	decl   0x10(%ebp)
  800f99:	ff 45 08             	incl   0x8(%ebp)
  800f9c:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800f9f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fa3:	74 17                	je     800fbc <strncmp+0x2b>
  800fa5:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa8:	8a 00                	mov    (%eax),%al
  800faa:	84 c0                	test   %al,%al
  800fac:	74 0e                	je     800fbc <strncmp+0x2b>
  800fae:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb1:	8a 10                	mov    (%eax),%dl
  800fb3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fb6:	8a 00                	mov    (%eax),%al
  800fb8:	38 c2                	cmp    %al,%dl
  800fba:	74 da                	je     800f96 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800fbc:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fc0:	75 07                	jne    800fc9 <strncmp+0x38>
		return 0;
  800fc2:	b8 00 00 00 00       	mov    $0x0,%eax
  800fc7:	eb 14                	jmp    800fdd <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800fc9:	8b 45 08             	mov    0x8(%ebp),%eax
  800fcc:	8a 00                	mov    (%eax),%al
  800fce:	0f b6 d0             	movzbl %al,%edx
  800fd1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fd4:	8a 00                	mov    (%eax),%al
  800fd6:	0f b6 c0             	movzbl %al,%eax
  800fd9:	29 c2                	sub    %eax,%edx
  800fdb:	89 d0                	mov    %edx,%eax
}
  800fdd:	5d                   	pop    %ebp
  800fde:	c3                   	ret    

00800fdf <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800fdf:	55                   	push   %ebp
  800fe0:	89 e5                	mov    %esp,%ebp
  800fe2:	83 ec 04             	sub    $0x4,%esp
  800fe5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fe8:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800feb:	eb 12                	jmp    800fff <strchr+0x20>
		if (*s == c)
  800fed:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff0:	8a 00                	mov    (%eax),%al
  800ff2:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800ff5:	75 05                	jne    800ffc <strchr+0x1d>
			return (char *) s;
  800ff7:	8b 45 08             	mov    0x8(%ebp),%eax
  800ffa:	eb 11                	jmp    80100d <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800ffc:	ff 45 08             	incl   0x8(%ebp)
  800fff:	8b 45 08             	mov    0x8(%ebp),%eax
  801002:	8a 00                	mov    (%eax),%al
  801004:	84 c0                	test   %al,%al
  801006:	75 e5                	jne    800fed <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  801008:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80100d:	c9                   	leave  
  80100e:	c3                   	ret    

0080100f <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80100f:	55                   	push   %ebp
  801010:	89 e5                	mov    %esp,%ebp
  801012:	83 ec 04             	sub    $0x4,%esp
  801015:	8b 45 0c             	mov    0xc(%ebp),%eax
  801018:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  80101b:	eb 0d                	jmp    80102a <strfind+0x1b>
		if (*s == c)
  80101d:	8b 45 08             	mov    0x8(%ebp),%eax
  801020:	8a 00                	mov    (%eax),%al
  801022:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801025:	74 0e                	je     801035 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801027:	ff 45 08             	incl   0x8(%ebp)
  80102a:	8b 45 08             	mov    0x8(%ebp),%eax
  80102d:	8a 00                	mov    (%eax),%al
  80102f:	84 c0                	test   %al,%al
  801031:	75 ea                	jne    80101d <strfind+0xe>
  801033:	eb 01                	jmp    801036 <strfind+0x27>
		if (*s == c)
			break;
  801035:	90                   	nop
	return (char *) s;
  801036:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801039:	c9                   	leave  
  80103a:	c3                   	ret    

0080103b <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  80103b:	55                   	push   %ebp
  80103c:	89 e5                	mov    %esp,%ebp
  80103e:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  801041:	8b 45 08             	mov    0x8(%ebp),%eax
  801044:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  801047:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  80104b:	76 63                	jbe    8010b0 <memset+0x75>
		uint64 data_block = c;
  80104d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801050:	99                   	cltd   
  801051:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801054:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  801057:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80105a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80105d:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  801061:	c1 e0 08             	shl    $0x8,%eax
  801064:	09 45 f0             	or     %eax,-0x10(%ebp)
  801067:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  80106a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80106d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801070:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  801074:	c1 e0 10             	shl    $0x10,%eax
  801077:	09 45 f0             	or     %eax,-0x10(%ebp)
  80107a:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  80107d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801080:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801083:	89 c2                	mov    %eax,%edx
  801085:	b8 00 00 00 00       	mov    $0x0,%eax
  80108a:	09 45 f0             	or     %eax,-0x10(%ebp)
  80108d:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  801090:	eb 18                	jmp    8010aa <memset+0x6f>
			*p64++ = data_block, n -= 8;
  801092:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801095:	8d 41 08             	lea    0x8(%ecx),%eax
  801098:	89 45 fc             	mov    %eax,-0x4(%ebp)
  80109b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80109e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8010a1:	89 01                	mov    %eax,(%ecx)
  8010a3:	89 51 04             	mov    %edx,0x4(%ecx)
  8010a6:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  8010aa:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  8010ae:	77 e2                	ja     801092 <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  8010b0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010b4:	74 23                	je     8010d9 <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  8010b6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010b9:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  8010bc:	eb 0e                	jmp    8010cc <memset+0x91>
			*p8++ = (uint8)c;
  8010be:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010c1:	8d 50 01             	lea    0x1(%eax),%edx
  8010c4:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8010c7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010ca:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  8010cc:	8b 45 10             	mov    0x10(%ebp),%eax
  8010cf:	8d 50 ff             	lea    -0x1(%eax),%edx
  8010d2:	89 55 10             	mov    %edx,0x10(%ebp)
  8010d5:	85 c0                	test   %eax,%eax
  8010d7:	75 e5                	jne    8010be <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  8010d9:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8010dc:	c9                   	leave  
  8010dd:	c3                   	ret    

008010de <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  8010de:	55                   	push   %ebp
  8010df:	89 e5                	mov    %esp,%ebp
  8010e1:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  8010e4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010e7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  8010ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ed:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  8010f0:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  8010f4:	76 24                	jbe    80111a <memcpy+0x3c>
		while(n >= 8){
  8010f6:	eb 1c                	jmp    801114 <memcpy+0x36>
			*d64 = *s64;
  8010f8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010fb:	8b 50 04             	mov    0x4(%eax),%edx
  8010fe:	8b 00                	mov    (%eax),%eax
  801100:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801103:	89 01                	mov    %eax,(%ecx)
  801105:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  801108:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  80110c:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  801110:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  801114:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801118:	77 de                	ja     8010f8 <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  80111a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80111e:	74 31                	je     801151 <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  801120:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801123:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  801126:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801129:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  80112c:	eb 16                	jmp    801144 <memcpy+0x66>
			*d8++ = *s8++;
  80112e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801131:	8d 50 01             	lea    0x1(%eax),%edx
  801134:	89 55 f0             	mov    %edx,-0x10(%ebp)
  801137:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80113a:	8d 4a 01             	lea    0x1(%edx),%ecx
  80113d:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  801140:	8a 12                	mov    (%edx),%dl
  801142:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  801144:	8b 45 10             	mov    0x10(%ebp),%eax
  801147:	8d 50 ff             	lea    -0x1(%eax),%edx
  80114a:	89 55 10             	mov    %edx,0x10(%ebp)
  80114d:	85 c0                	test   %eax,%eax
  80114f:	75 dd                	jne    80112e <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  801151:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801154:	c9                   	leave  
  801155:	c3                   	ret    

00801156 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801156:	55                   	push   %ebp
  801157:	89 e5                	mov    %esp,%ebp
  801159:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  80115c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80115f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801162:	8b 45 08             	mov    0x8(%ebp),%eax
  801165:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801168:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80116b:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80116e:	73 50                	jae    8011c0 <memmove+0x6a>
  801170:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801173:	8b 45 10             	mov    0x10(%ebp),%eax
  801176:	01 d0                	add    %edx,%eax
  801178:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80117b:	76 43                	jbe    8011c0 <memmove+0x6a>
		s += n;
  80117d:	8b 45 10             	mov    0x10(%ebp),%eax
  801180:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801183:	8b 45 10             	mov    0x10(%ebp),%eax
  801186:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  801189:	eb 10                	jmp    80119b <memmove+0x45>
			*--d = *--s;
  80118b:	ff 4d f8             	decl   -0x8(%ebp)
  80118e:	ff 4d fc             	decl   -0x4(%ebp)
  801191:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801194:	8a 10                	mov    (%eax),%dl
  801196:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801199:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  80119b:	8b 45 10             	mov    0x10(%ebp),%eax
  80119e:	8d 50 ff             	lea    -0x1(%eax),%edx
  8011a1:	89 55 10             	mov    %edx,0x10(%ebp)
  8011a4:	85 c0                	test   %eax,%eax
  8011a6:	75 e3                	jne    80118b <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8011a8:	eb 23                	jmp    8011cd <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  8011aa:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011ad:	8d 50 01             	lea    0x1(%eax),%edx
  8011b0:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8011b3:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8011b6:	8d 4a 01             	lea    0x1(%edx),%ecx
  8011b9:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8011bc:	8a 12                	mov    (%edx),%dl
  8011be:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  8011c0:	8b 45 10             	mov    0x10(%ebp),%eax
  8011c3:	8d 50 ff             	lea    -0x1(%eax),%edx
  8011c6:	89 55 10             	mov    %edx,0x10(%ebp)
  8011c9:	85 c0                	test   %eax,%eax
  8011cb:	75 dd                	jne    8011aa <memmove+0x54>
			*d++ = *s++;

	return dst;
  8011cd:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8011d0:	c9                   	leave  
  8011d1:	c3                   	ret    

008011d2 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8011d2:	55                   	push   %ebp
  8011d3:	89 e5                	mov    %esp,%ebp
  8011d5:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  8011d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8011db:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  8011de:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011e1:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8011e4:	eb 2a                	jmp    801210 <memcmp+0x3e>
		if (*s1 != *s2)
  8011e6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011e9:	8a 10                	mov    (%eax),%dl
  8011eb:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011ee:	8a 00                	mov    (%eax),%al
  8011f0:	38 c2                	cmp    %al,%dl
  8011f2:	74 16                	je     80120a <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  8011f4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011f7:	8a 00                	mov    (%eax),%al
  8011f9:	0f b6 d0             	movzbl %al,%edx
  8011fc:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011ff:	8a 00                	mov    (%eax),%al
  801201:	0f b6 c0             	movzbl %al,%eax
  801204:	29 c2                	sub    %eax,%edx
  801206:	89 d0                	mov    %edx,%eax
  801208:	eb 18                	jmp    801222 <memcmp+0x50>
		s1++, s2++;
  80120a:	ff 45 fc             	incl   -0x4(%ebp)
  80120d:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801210:	8b 45 10             	mov    0x10(%ebp),%eax
  801213:	8d 50 ff             	lea    -0x1(%eax),%edx
  801216:	89 55 10             	mov    %edx,0x10(%ebp)
  801219:	85 c0                	test   %eax,%eax
  80121b:	75 c9                	jne    8011e6 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  80121d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801222:	c9                   	leave  
  801223:	c3                   	ret    

00801224 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801224:	55                   	push   %ebp
  801225:	89 e5                	mov    %esp,%ebp
  801227:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  80122a:	8b 55 08             	mov    0x8(%ebp),%edx
  80122d:	8b 45 10             	mov    0x10(%ebp),%eax
  801230:	01 d0                	add    %edx,%eax
  801232:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801235:	eb 15                	jmp    80124c <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801237:	8b 45 08             	mov    0x8(%ebp),%eax
  80123a:	8a 00                	mov    (%eax),%al
  80123c:	0f b6 d0             	movzbl %al,%edx
  80123f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801242:	0f b6 c0             	movzbl %al,%eax
  801245:	39 c2                	cmp    %eax,%edx
  801247:	74 0d                	je     801256 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801249:	ff 45 08             	incl   0x8(%ebp)
  80124c:	8b 45 08             	mov    0x8(%ebp),%eax
  80124f:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801252:	72 e3                	jb     801237 <memfind+0x13>
  801254:	eb 01                	jmp    801257 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801256:	90                   	nop
	return (void *) s;
  801257:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80125a:	c9                   	leave  
  80125b:	c3                   	ret    

0080125c <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80125c:	55                   	push   %ebp
  80125d:	89 e5                	mov    %esp,%ebp
  80125f:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801262:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801269:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801270:	eb 03                	jmp    801275 <strtol+0x19>
		s++;
  801272:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801275:	8b 45 08             	mov    0x8(%ebp),%eax
  801278:	8a 00                	mov    (%eax),%al
  80127a:	3c 20                	cmp    $0x20,%al
  80127c:	74 f4                	je     801272 <strtol+0x16>
  80127e:	8b 45 08             	mov    0x8(%ebp),%eax
  801281:	8a 00                	mov    (%eax),%al
  801283:	3c 09                	cmp    $0x9,%al
  801285:	74 eb                	je     801272 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801287:	8b 45 08             	mov    0x8(%ebp),%eax
  80128a:	8a 00                	mov    (%eax),%al
  80128c:	3c 2b                	cmp    $0x2b,%al
  80128e:	75 05                	jne    801295 <strtol+0x39>
		s++;
  801290:	ff 45 08             	incl   0x8(%ebp)
  801293:	eb 13                	jmp    8012a8 <strtol+0x4c>
	else if (*s == '-')
  801295:	8b 45 08             	mov    0x8(%ebp),%eax
  801298:	8a 00                	mov    (%eax),%al
  80129a:	3c 2d                	cmp    $0x2d,%al
  80129c:	75 0a                	jne    8012a8 <strtol+0x4c>
		s++, neg = 1;
  80129e:	ff 45 08             	incl   0x8(%ebp)
  8012a1:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8012a8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8012ac:	74 06                	je     8012b4 <strtol+0x58>
  8012ae:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8012b2:	75 20                	jne    8012d4 <strtol+0x78>
  8012b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8012b7:	8a 00                	mov    (%eax),%al
  8012b9:	3c 30                	cmp    $0x30,%al
  8012bb:	75 17                	jne    8012d4 <strtol+0x78>
  8012bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8012c0:	40                   	inc    %eax
  8012c1:	8a 00                	mov    (%eax),%al
  8012c3:	3c 78                	cmp    $0x78,%al
  8012c5:	75 0d                	jne    8012d4 <strtol+0x78>
		s += 2, base = 16;
  8012c7:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8012cb:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8012d2:	eb 28                	jmp    8012fc <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8012d4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8012d8:	75 15                	jne    8012ef <strtol+0x93>
  8012da:	8b 45 08             	mov    0x8(%ebp),%eax
  8012dd:	8a 00                	mov    (%eax),%al
  8012df:	3c 30                	cmp    $0x30,%al
  8012e1:	75 0c                	jne    8012ef <strtol+0x93>
		s++, base = 8;
  8012e3:	ff 45 08             	incl   0x8(%ebp)
  8012e6:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8012ed:	eb 0d                	jmp    8012fc <strtol+0xa0>
	else if (base == 0)
  8012ef:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8012f3:	75 07                	jne    8012fc <strtol+0xa0>
		base = 10;
  8012f5:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8012fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8012ff:	8a 00                	mov    (%eax),%al
  801301:	3c 2f                	cmp    $0x2f,%al
  801303:	7e 19                	jle    80131e <strtol+0xc2>
  801305:	8b 45 08             	mov    0x8(%ebp),%eax
  801308:	8a 00                	mov    (%eax),%al
  80130a:	3c 39                	cmp    $0x39,%al
  80130c:	7f 10                	jg     80131e <strtol+0xc2>
			dig = *s - '0';
  80130e:	8b 45 08             	mov    0x8(%ebp),%eax
  801311:	8a 00                	mov    (%eax),%al
  801313:	0f be c0             	movsbl %al,%eax
  801316:	83 e8 30             	sub    $0x30,%eax
  801319:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80131c:	eb 42                	jmp    801360 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  80131e:	8b 45 08             	mov    0x8(%ebp),%eax
  801321:	8a 00                	mov    (%eax),%al
  801323:	3c 60                	cmp    $0x60,%al
  801325:	7e 19                	jle    801340 <strtol+0xe4>
  801327:	8b 45 08             	mov    0x8(%ebp),%eax
  80132a:	8a 00                	mov    (%eax),%al
  80132c:	3c 7a                	cmp    $0x7a,%al
  80132e:	7f 10                	jg     801340 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801330:	8b 45 08             	mov    0x8(%ebp),%eax
  801333:	8a 00                	mov    (%eax),%al
  801335:	0f be c0             	movsbl %al,%eax
  801338:	83 e8 57             	sub    $0x57,%eax
  80133b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80133e:	eb 20                	jmp    801360 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801340:	8b 45 08             	mov    0x8(%ebp),%eax
  801343:	8a 00                	mov    (%eax),%al
  801345:	3c 40                	cmp    $0x40,%al
  801347:	7e 39                	jle    801382 <strtol+0x126>
  801349:	8b 45 08             	mov    0x8(%ebp),%eax
  80134c:	8a 00                	mov    (%eax),%al
  80134e:	3c 5a                	cmp    $0x5a,%al
  801350:	7f 30                	jg     801382 <strtol+0x126>
			dig = *s - 'A' + 10;
  801352:	8b 45 08             	mov    0x8(%ebp),%eax
  801355:	8a 00                	mov    (%eax),%al
  801357:	0f be c0             	movsbl %al,%eax
  80135a:	83 e8 37             	sub    $0x37,%eax
  80135d:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801360:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801363:	3b 45 10             	cmp    0x10(%ebp),%eax
  801366:	7d 19                	jge    801381 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801368:	ff 45 08             	incl   0x8(%ebp)
  80136b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80136e:	0f af 45 10          	imul   0x10(%ebp),%eax
  801372:	89 c2                	mov    %eax,%edx
  801374:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801377:	01 d0                	add    %edx,%eax
  801379:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  80137c:	e9 7b ff ff ff       	jmp    8012fc <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801381:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801382:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801386:	74 08                	je     801390 <strtol+0x134>
		*endptr = (char *) s;
  801388:	8b 45 0c             	mov    0xc(%ebp),%eax
  80138b:	8b 55 08             	mov    0x8(%ebp),%edx
  80138e:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801390:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801394:	74 07                	je     80139d <strtol+0x141>
  801396:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801399:	f7 d8                	neg    %eax
  80139b:	eb 03                	jmp    8013a0 <strtol+0x144>
  80139d:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8013a0:	c9                   	leave  
  8013a1:	c3                   	ret    

008013a2 <ltostr>:

void
ltostr(long value, char *str)
{
  8013a2:	55                   	push   %ebp
  8013a3:	89 e5                	mov    %esp,%ebp
  8013a5:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8013a8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8013af:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8013b6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8013ba:	79 13                	jns    8013cf <ltostr+0x2d>
	{
		neg = 1;
  8013bc:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8013c3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013c6:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8013c9:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8013cc:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8013cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8013d2:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8013d7:	99                   	cltd   
  8013d8:	f7 f9                	idiv   %ecx
  8013da:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8013dd:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8013e0:	8d 50 01             	lea    0x1(%eax),%edx
  8013e3:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8013e6:	89 c2                	mov    %eax,%edx
  8013e8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013eb:	01 d0                	add    %edx,%eax
  8013ed:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8013f0:	83 c2 30             	add    $0x30,%edx
  8013f3:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8013f5:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8013f8:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8013fd:	f7 e9                	imul   %ecx
  8013ff:	c1 fa 02             	sar    $0x2,%edx
  801402:	89 c8                	mov    %ecx,%eax
  801404:	c1 f8 1f             	sar    $0x1f,%eax
  801407:	29 c2                	sub    %eax,%edx
  801409:	89 d0                	mov    %edx,%eax
  80140b:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  80140e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801412:	75 bb                	jne    8013cf <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801414:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  80141b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80141e:	48                   	dec    %eax
  80141f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801422:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801426:	74 3d                	je     801465 <ltostr+0xc3>
		start = 1 ;
  801428:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  80142f:	eb 34                	jmp    801465 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  801431:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801434:	8b 45 0c             	mov    0xc(%ebp),%eax
  801437:	01 d0                	add    %edx,%eax
  801439:	8a 00                	mov    (%eax),%al
  80143b:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  80143e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801441:	8b 45 0c             	mov    0xc(%ebp),%eax
  801444:	01 c2                	add    %eax,%edx
  801446:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801449:	8b 45 0c             	mov    0xc(%ebp),%eax
  80144c:	01 c8                	add    %ecx,%eax
  80144e:	8a 00                	mov    (%eax),%al
  801450:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801452:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801455:	8b 45 0c             	mov    0xc(%ebp),%eax
  801458:	01 c2                	add    %eax,%edx
  80145a:	8a 45 eb             	mov    -0x15(%ebp),%al
  80145d:	88 02                	mov    %al,(%edx)
		start++ ;
  80145f:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801462:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801465:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801468:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80146b:	7c c4                	jl     801431 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  80146d:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801470:	8b 45 0c             	mov    0xc(%ebp),%eax
  801473:	01 d0                	add    %edx,%eax
  801475:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801478:	90                   	nop
  801479:	c9                   	leave  
  80147a:	c3                   	ret    

0080147b <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  80147b:	55                   	push   %ebp
  80147c:	89 e5                	mov    %esp,%ebp
  80147e:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801481:	ff 75 08             	pushl  0x8(%ebp)
  801484:	e8 c4 f9 ff ff       	call   800e4d <strlen>
  801489:	83 c4 04             	add    $0x4,%esp
  80148c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  80148f:	ff 75 0c             	pushl  0xc(%ebp)
  801492:	e8 b6 f9 ff ff       	call   800e4d <strlen>
  801497:	83 c4 04             	add    $0x4,%esp
  80149a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  80149d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8014a4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8014ab:	eb 17                	jmp    8014c4 <strcconcat+0x49>
		final[s] = str1[s] ;
  8014ad:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8014b0:	8b 45 10             	mov    0x10(%ebp),%eax
  8014b3:	01 c2                	add    %eax,%edx
  8014b5:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8014b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8014bb:	01 c8                	add    %ecx,%eax
  8014bd:	8a 00                	mov    (%eax),%al
  8014bf:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8014c1:	ff 45 fc             	incl   -0x4(%ebp)
  8014c4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8014c7:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8014ca:	7c e1                	jl     8014ad <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8014cc:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8014d3:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8014da:	eb 1f                	jmp    8014fb <strcconcat+0x80>
		final[s++] = str2[i] ;
  8014dc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8014df:	8d 50 01             	lea    0x1(%eax),%edx
  8014e2:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8014e5:	89 c2                	mov    %eax,%edx
  8014e7:	8b 45 10             	mov    0x10(%ebp),%eax
  8014ea:	01 c2                	add    %eax,%edx
  8014ec:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8014ef:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014f2:	01 c8                	add    %ecx,%eax
  8014f4:	8a 00                	mov    (%eax),%al
  8014f6:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8014f8:	ff 45 f8             	incl   -0x8(%ebp)
  8014fb:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8014fe:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801501:	7c d9                	jl     8014dc <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801503:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801506:	8b 45 10             	mov    0x10(%ebp),%eax
  801509:	01 d0                	add    %edx,%eax
  80150b:	c6 00 00             	movb   $0x0,(%eax)
}
  80150e:	90                   	nop
  80150f:	c9                   	leave  
  801510:	c3                   	ret    

00801511 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801511:	55                   	push   %ebp
  801512:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801514:	8b 45 14             	mov    0x14(%ebp),%eax
  801517:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  80151d:	8b 45 14             	mov    0x14(%ebp),%eax
  801520:	8b 00                	mov    (%eax),%eax
  801522:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801529:	8b 45 10             	mov    0x10(%ebp),%eax
  80152c:	01 d0                	add    %edx,%eax
  80152e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801534:	eb 0c                	jmp    801542 <strsplit+0x31>
			*string++ = 0;
  801536:	8b 45 08             	mov    0x8(%ebp),%eax
  801539:	8d 50 01             	lea    0x1(%eax),%edx
  80153c:	89 55 08             	mov    %edx,0x8(%ebp)
  80153f:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801542:	8b 45 08             	mov    0x8(%ebp),%eax
  801545:	8a 00                	mov    (%eax),%al
  801547:	84 c0                	test   %al,%al
  801549:	74 18                	je     801563 <strsplit+0x52>
  80154b:	8b 45 08             	mov    0x8(%ebp),%eax
  80154e:	8a 00                	mov    (%eax),%al
  801550:	0f be c0             	movsbl %al,%eax
  801553:	50                   	push   %eax
  801554:	ff 75 0c             	pushl  0xc(%ebp)
  801557:	e8 83 fa ff ff       	call   800fdf <strchr>
  80155c:	83 c4 08             	add    $0x8,%esp
  80155f:	85 c0                	test   %eax,%eax
  801561:	75 d3                	jne    801536 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801563:	8b 45 08             	mov    0x8(%ebp),%eax
  801566:	8a 00                	mov    (%eax),%al
  801568:	84 c0                	test   %al,%al
  80156a:	74 5a                	je     8015c6 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  80156c:	8b 45 14             	mov    0x14(%ebp),%eax
  80156f:	8b 00                	mov    (%eax),%eax
  801571:	83 f8 0f             	cmp    $0xf,%eax
  801574:	75 07                	jne    80157d <strsplit+0x6c>
		{
			return 0;
  801576:	b8 00 00 00 00       	mov    $0x0,%eax
  80157b:	eb 66                	jmp    8015e3 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  80157d:	8b 45 14             	mov    0x14(%ebp),%eax
  801580:	8b 00                	mov    (%eax),%eax
  801582:	8d 48 01             	lea    0x1(%eax),%ecx
  801585:	8b 55 14             	mov    0x14(%ebp),%edx
  801588:	89 0a                	mov    %ecx,(%edx)
  80158a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801591:	8b 45 10             	mov    0x10(%ebp),%eax
  801594:	01 c2                	add    %eax,%edx
  801596:	8b 45 08             	mov    0x8(%ebp),%eax
  801599:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  80159b:	eb 03                	jmp    8015a0 <strsplit+0x8f>
			string++;
  80159d:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8015a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8015a3:	8a 00                	mov    (%eax),%al
  8015a5:	84 c0                	test   %al,%al
  8015a7:	74 8b                	je     801534 <strsplit+0x23>
  8015a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8015ac:	8a 00                	mov    (%eax),%al
  8015ae:	0f be c0             	movsbl %al,%eax
  8015b1:	50                   	push   %eax
  8015b2:	ff 75 0c             	pushl  0xc(%ebp)
  8015b5:	e8 25 fa ff ff       	call   800fdf <strchr>
  8015ba:	83 c4 08             	add    $0x8,%esp
  8015bd:	85 c0                	test   %eax,%eax
  8015bf:	74 dc                	je     80159d <strsplit+0x8c>
			string++;
	}
  8015c1:	e9 6e ff ff ff       	jmp    801534 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8015c6:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8015c7:	8b 45 14             	mov    0x14(%ebp),%eax
  8015ca:	8b 00                	mov    (%eax),%eax
  8015cc:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8015d3:	8b 45 10             	mov    0x10(%ebp),%eax
  8015d6:	01 d0                	add    %edx,%eax
  8015d8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8015de:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8015e3:	c9                   	leave  
  8015e4:	c3                   	ret    

008015e5 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  8015e5:	55                   	push   %ebp
  8015e6:	89 e5                	mov    %esp,%ebp
  8015e8:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  8015eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8015ee:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  8015f1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8015f8:	eb 4a                	jmp    801644 <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  8015fa:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8015fd:	8b 45 08             	mov    0x8(%ebp),%eax
  801600:	01 c2                	add    %eax,%edx
  801602:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801605:	8b 45 0c             	mov    0xc(%ebp),%eax
  801608:	01 c8                	add    %ecx,%eax
  80160a:	8a 00                	mov    (%eax),%al
  80160c:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  80160e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801611:	8b 45 0c             	mov    0xc(%ebp),%eax
  801614:	01 d0                	add    %edx,%eax
  801616:	8a 00                	mov    (%eax),%al
  801618:	3c 40                	cmp    $0x40,%al
  80161a:	7e 25                	jle    801641 <str2lower+0x5c>
  80161c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80161f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801622:	01 d0                	add    %edx,%eax
  801624:	8a 00                	mov    (%eax),%al
  801626:	3c 5a                	cmp    $0x5a,%al
  801628:	7f 17                	jg     801641 <str2lower+0x5c>
		{
			dst[i] += 32 ;
  80162a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80162d:	8b 45 08             	mov    0x8(%ebp),%eax
  801630:	01 d0                	add    %edx,%eax
  801632:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801635:	8b 55 08             	mov    0x8(%ebp),%edx
  801638:	01 ca                	add    %ecx,%edx
  80163a:	8a 12                	mov    (%edx),%dl
  80163c:	83 c2 20             	add    $0x20,%edx
  80163f:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  801641:	ff 45 fc             	incl   -0x4(%ebp)
  801644:	ff 75 0c             	pushl  0xc(%ebp)
  801647:	e8 01 f8 ff ff       	call   800e4d <strlen>
  80164c:	83 c4 04             	add    $0x4,%esp
  80164f:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801652:	7f a6                	jg     8015fa <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  801654:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801657:	c9                   	leave  
  801658:	c3                   	ret    

00801659 <uheap_init>:
//==============================================
// [1] INITIALIZE USER HEAP:
//==============================================
int __firstTimeFlag = 1;
void uheap_init()
{
  801659:	55                   	push   %ebp
  80165a:	89 e5                	mov    %esp,%ebp
  80165c:	83 ec 08             	sub    $0x8,%esp
	if(__firstTimeFlag)
  80165f:	a1 08 50 80 00       	mov    0x805008,%eax
  801664:	85 c0                	test   %eax,%eax
  801666:	0f 84 95 00 00 00    	je     801701 <uheap_init+0xa8>
	{
		initialize_dynamic_allocator(USER_HEAP_START, USER_HEAP_START + DYN_ALLOC_MAX_SIZE);
  80166c:	83 ec 08             	sub    $0x8,%esp
  80166f:	68 00 00 00 82       	push   $0x82000000
  801674:	68 00 00 00 80       	push   $0x80000000
  801679:	e8 59 1f 00 00       	call   8035d7 <initialize_dynamic_allocator>
  80167e:	83 c4 10             	add    $0x10,%esp
		uheapPlaceStrategy = sys_get_uheap_strategy();
  801681:	e8 93 1d 00 00       	call   803419 <sys_get_uheap_strategy>
  801686:	a3 60 d0 81 00       	mov    %eax,0x81d060
		uheapPageAllocStart = dynAllocEnd + PAGE_SIZE;
  80168b:	a1 40 50 80 00       	mov    0x805040,%eax
  801690:	05 00 10 00 00       	add    $0x1000,%eax
  801695:	a3 10 d1 81 00       	mov    %eax,0x81d110
		uheapPageAllocBreak = uheapPageAllocStart;
  80169a:	a1 10 d1 81 00       	mov    0x81d110,%eax
  80169f:	a3 68 d0 81 00       	mov    %eax,0x81d068
		init_uspinlock(&ulock,"malloc",1);
  8016a4:	83 ec 04             	sub    $0x4,%esp
  8016a7:	6a 01                	push   $0x1
  8016a9:	68 a8 4b 80 00       	push   $0x804ba8
  8016ae:	68 40 d1 81 00       	push   $0x81d140
  8016b3:	e8 1a 29 00 00       	call   803fd2 <init_uspinlock>
  8016b8:	83 c4 10             	add    $0x10,%esp
		LIST_INIT(&u_freelist);
  8016bb:	c7 05 20 d1 81 00 00 	movl   $0x0,0x81d120
  8016c2:	00 00 00 
  8016c5:	c7 05 24 d1 81 00 00 	movl   $0x0,0x81d124
  8016cc:	00 00 00 
  8016cf:	c7 05 2c d1 81 00 00 	movl   $0x0,0x81d12c
  8016d6:	00 00 00 
		LIST_INIT(&u_allocatedlist);
  8016d9:	c7 05 30 d1 81 00 00 	movl   $0x0,0x81d130
  8016e0:	00 00 00 
  8016e3:	c7 05 34 d1 81 00 00 	movl   $0x0,0x81d134
  8016ea:	00 00 00 
  8016ed:	c7 05 3c d1 81 00 00 	movl   $0x0,0x81d13c
  8016f4:	00 00 00 
		__firstTimeFlag = 0;
  8016f7:	c7 05 08 50 80 00 00 	movl   $0x0,0x805008
  8016fe:	00 00 00 
	}
}
  801701:	90                   	nop
  801702:	c9                   	leave  
  801703:	c3                   	ret    

00801704 <get_page>:

//==============================================
// [2] GET A PAGE FROM THE KERNEL FOR DA:
//==============================================
int get_page(void* va)
{
  801704:	55                   	push   %ebp
  801705:	89 e5                	mov    %esp,%ebp
  801707:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_allocate_page(ROUNDDOWN(va, PAGE_SIZE), PERM_USER|PERM_WRITEABLE|PERM_UHPAGE);
  80170a:	8b 45 08             	mov    0x8(%ebp),%eax
  80170d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801710:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801713:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801718:	83 ec 08             	sub    $0x8,%esp
  80171b:	68 06 04 00 00       	push   $0x406
  801720:	50                   	push   %eax
  801721:	e8 3d 19 00 00       	call   803063 <__sys_allocate_page>
  801726:	83 c4 10             	add    $0x10,%esp
  801729:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  80172c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801730:	79 14                	jns    801746 <get_page+0x42>
		panic("get_page() in user: failed to allocate page from the kernel");
  801732:	83 ec 04             	sub    $0x4,%esp
  801735:	68 b0 4b 80 00       	push   $0x804bb0
  80173a:	6a 2d                	push   $0x2d
  80173c:	68 ec 4b 80 00       	push   $0x804bec
  801741:	e8 60 ed ff ff       	call   8004a6 <_panic>
	return 0;
  801746:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80174b:	c9                   	leave  
  80174c:	c3                   	ret    

0080174d <return_page>:

//==============================================
// [3] RETURN A PAGE FROM THE DA TO KERNEL:
//==============================================
void return_page(void* va)
{
  80174d:	55                   	push   %ebp
  80174e:	89 e5                	mov    %esp,%ebp
  801750:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_unmap_frame(ROUNDDOWN((uint32)va, PAGE_SIZE));
  801753:	8b 45 08             	mov    0x8(%ebp),%eax
  801756:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801759:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80175c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801761:	83 ec 0c             	sub    $0xc,%esp
  801764:	50                   	push   %eax
  801765:	e8 40 19 00 00       	call   8030aa <__sys_unmap_frame>
  80176a:	83 c4 10             	add    $0x10,%esp
  80176d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  801770:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801774:	79 14                	jns    80178a <return_page+0x3d>
		panic("return_page() in user: failed to return a page to the kernel");
  801776:	83 ec 04             	sub    $0x4,%esp
  801779:	68 f8 4b 80 00       	push   $0x804bf8
  80177e:	6a 38                	push   $0x38
  801780:	68 ec 4b 80 00       	push   $0x804bec
  801785:	e8 1c ed ff ff       	call   8004a6 <_panic>
}
  80178a:	90                   	nop
  80178b:	c9                   	leave  
  80178c:	c3                   	ret    

0080178d <malloc>:

//=================================
// [1] ALLOCATE SPACE IN USER HEAP:
//=================================
void* malloc(uint32 size)
{
  80178d:	55                   	push   %ebp
  80178e:	89 e5                	mov    %esp,%ebp
  801790:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  801793:	e8 c1 fe ff ff       	call   801659 <uheap_init>
	if (size == 0) return NULL ;
  801798:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80179c:	75 0a                	jne    8017a8 <malloc+0x1b>
  80179e:	b8 00 00 00 00       	mov    $0x0,%eax
  8017a3:	e9 e1 04 00 00       	jmp    801c89 <malloc+0x4fc>
	//==============================================================

	acquire_uspinlock(&ulock);
  8017a8:	83 ec 0c             	sub    $0xc,%esp
  8017ab:	68 40 d1 81 00       	push   $0x81d140
  8017b0:	e8 6c 28 00 00       	call   804021 <acquire_uspinlock>
  8017b5:	83 c4 10             	add    $0x10,%esp
	if(size <  DYN_ALLOC_MAX_BLOCK_SIZE){
  8017b8:	81 7d 08 ff 07 00 00 	cmpl   $0x7ff,0x8(%ebp)
  8017bf:	77 23                	ja     8017e4 <malloc+0x57>
		release_uspinlock(&ulock);
  8017c1:	83 ec 0c             	sub    $0xc,%esp
  8017c4:	68 40 d1 81 00       	push   $0x81d140
  8017c9:	e8 ab 28 00 00       	call   804079 <release_uspinlock>
  8017ce:	83 c4 10             	add    $0x10,%esp
		return alloc_block(size);
  8017d1:	83 ec 0c             	sub    $0xc,%esp
  8017d4:	ff 75 08             	pushl  0x8(%ebp)
  8017d7:	e8 dd 1f 00 00       	call   8037b9 <alloc_block>
  8017dc:	83 c4 10             	add    $0x10,%esp
  8017df:	e9 a5 04 00 00       	jmp    801c89 <malloc+0x4fc>
	}

	struct UserHeapStruct* allocblock= (struct UserHeapStruct*) alloc_block(sizeof(struct UserHeapStruct));
  8017e4:	83 ec 0c             	sub    $0xc,%esp
  8017e7:	6a 10                	push   $0x10
  8017e9:	e8 cb 1f 00 00       	call   8037b9 <alloc_block>
  8017ee:	83 c4 10             	add    $0x10,%esp
  8017f1:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (allocblock == NULL){
  8017f4:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8017f8:	75 0a                	jne    801804 <malloc+0x77>
			return NULL;
  8017fa:	b8 00 00 00 00       	mov    $0x0,%eax
  8017ff:	e9 85 04 00 00       	jmp    801c89 <malloc+0x4fc>
	}

	size = ROUNDUP(size,PAGE_SIZE);
  801804:	c7 45 e8 00 10 00 00 	movl   $0x1000,-0x18(%ebp)
  80180b:	8b 55 08             	mov    0x8(%ebp),%edx
  80180e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801811:	01 d0                	add    %edx,%eax
  801813:	48                   	dec    %eax
  801814:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801817:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80181a:	ba 00 00 00 00       	mov    $0x0,%edx
  80181f:	f7 75 e8             	divl   -0x18(%ebp)
  801822:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801825:	29 d0                	sub    %edx,%eax
  801827:	89 45 08             	mov    %eax,0x8(%ebp)
	struct UserHeapStruct* lastfreeelement = LIST_LAST(&u_freelist);
  80182a:	a1 24 d1 81 00       	mov    0x81d124,%eax
  80182f:	89 45 e0             	mov    %eax,-0x20(%ebp)

	if(LIST_SIZE(&u_freelist)==0 || size>lastfreeelement->size){
  801832:	a1 2c d1 81 00       	mov    0x81d12c,%eax
  801837:	85 c0                	test   %eax,%eax
  801839:	74 0f                	je     80184a <malloc+0xbd>
  80183b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80183e:	8b 40 04             	mov    0x4(%eax),%eax
  801841:	3b 45 08             	cmp    0x8(%ebp),%eax
  801844:	0f 83 ea 00 00 00    	jae    801934 <malloc+0x1a7>
			if(uheapPageAllocBreak < USER_HEAP_MAX - size){
  80184a:	b8 00 00 00 a0       	mov    $0xa0000000,%eax
  80184f:	2b 45 08             	sub    0x8(%ebp),%eax
  801852:	89 c2                	mov    %eax,%edx
  801854:	a1 68 d0 81 00       	mov    0x81d068,%eax
  801859:	39 c2                	cmp    %eax,%edx
  80185b:	0f 86 b9 00 00 00    	jbe    80191a <malloc+0x18d>
					uint32 requestedblockva = uheapPageAllocBreak;
  801861:	a1 68 d0 81 00       	mov    0x81d068,%eax
  801866:	89 45 dc             	mov    %eax,-0x24(%ebp)
					uheapPageAllocBreak+=size;
  801869:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  80186f:	8b 45 08             	mov    0x8(%ebp),%eax
  801872:	01 d0                	add    %edx,%eax
  801874:	a3 68 d0 81 00       	mov    %eax,0x81d068
					allocblock->startva = requestedblockva;
  801879:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80187c:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80187f:	89 10                	mov    %edx,(%eax)
					allocblock->size = size;
  801881:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801884:	8b 55 08             	mov    0x8(%ebp),%edx
  801887:	89 50 04             	mov    %edx,0x4(%eax)

					LIST_INSERT_TAIL(&u_allocatedlist, allocblock);
  80188a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80188e:	75 14                	jne    8018a4 <malloc+0x117>
  801890:	83 ec 04             	sub    $0x4,%esp
  801893:	68 38 4c 80 00       	push   $0x804c38
  801898:	6a 60                	push   $0x60
  80189a:	68 ec 4b 80 00       	push   $0x804bec
  80189f:	e8 02 ec ff ff       	call   8004a6 <_panic>
  8018a4:	8b 15 34 d1 81 00    	mov    0x81d134,%edx
  8018aa:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8018ad:	89 50 0c             	mov    %edx,0xc(%eax)
  8018b0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8018b3:	8b 40 0c             	mov    0xc(%eax),%eax
  8018b6:	85 c0                	test   %eax,%eax
  8018b8:	74 0d                	je     8018c7 <malloc+0x13a>
  8018ba:	a1 34 d1 81 00       	mov    0x81d134,%eax
  8018bf:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8018c2:	89 50 08             	mov    %edx,0x8(%eax)
  8018c5:	eb 08                	jmp    8018cf <malloc+0x142>
  8018c7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8018ca:	a3 30 d1 81 00       	mov    %eax,0x81d130
  8018cf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8018d2:	a3 34 d1 81 00       	mov    %eax,0x81d134
  8018d7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8018da:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  8018e1:	a1 3c d1 81 00       	mov    0x81d13c,%eax
  8018e6:	40                   	inc    %eax
  8018e7:	a3 3c d1 81 00       	mov    %eax,0x81d13c


					sys_allocate_user_mem(allocblock->startva ,size);
  8018ec:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8018ef:	8b 00                	mov    (%eax),%eax
  8018f1:	83 ec 08             	sub    $0x8,%esp
  8018f4:	ff 75 08             	pushl  0x8(%ebp)
  8018f7:	50                   	push   %eax
  8018f8:	e8 34 1c 00 00       	call   803531 <sys_allocate_user_mem>
  8018fd:	83 c4 10             	add    $0x10,%esp
					release_uspinlock(&ulock);
  801900:	83 ec 0c             	sub    $0xc,%esp
  801903:	68 40 d1 81 00       	push   $0x81d140
  801908:	e8 6c 27 00 00       	call   804079 <release_uspinlock>
  80190d:	83 c4 10             	add    $0x10,%esp
					return (void*)allocblock->startva;
  801910:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801913:	8b 00                	mov    (%eax),%eax
  801915:	e9 6f 03 00 00       	jmp    801c89 <malloc+0x4fc>
			}else{
					release_uspinlock(&ulock);
  80191a:	83 ec 0c             	sub    $0xc,%esp
  80191d:	68 40 d1 81 00       	push   $0x81d140
  801922:	e8 52 27 00 00       	call   804079 <release_uspinlock>
  801927:	83 c4 10             	add    $0x10,%esp
					return NULL;
  80192a:	b8 00 00 00 00       	mov    $0x0,%eax
  80192f:	e9 55 03 00 00       	jmp    801c89 <malloc+0x4fc>
				}
	}else{
		//custom fit
		struct UserHeapStruct* currentfreeelement = LIST_FIRST(&u_freelist);
  801934:	a1 20 d1 81 00       	mov    0x81d120,%eax
  801939:	89 45 f4             	mov    %eax,-0xc(%ebp)
		//worst fit
		while(currentfreeelement != NULL){
  80193c:	e9 39 03 00 00       	jmp    801c7a <malloc+0x4ed>
			if(size<currentfreeelement->size){
  801941:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801944:	8b 40 04             	mov    0x4(%eax),%eax
  801947:	3b 45 08             	cmp    0x8(%ebp),%eax
  80194a:	0f 86 e7 01 00 00    	jbe    801b37 <malloc+0x3aa>
				allocblock->startva = lastfreeelement->startva;
  801950:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801953:	8b 10                	mov    (%eax),%edx
  801955:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801958:	89 10                	mov    %edx,(%eax)
                allocblock->size = size;
  80195a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80195d:	8b 55 08             	mov    0x8(%ebp),%edx
  801960:	89 50 04             	mov    %edx,0x4(%eax)
                LIST_INSERT_TAIL(&u_allocatedlist,allocblock);
  801963:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801967:	75 14                	jne    80197d <malloc+0x1f0>
  801969:	83 ec 04             	sub    $0x4,%esp
  80196c:	68 38 4c 80 00       	push   $0x804c38
  801971:	6a 72                	push   $0x72
  801973:	68 ec 4b 80 00       	push   $0x804bec
  801978:	e8 29 eb ff ff       	call   8004a6 <_panic>
  80197d:	8b 15 34 d1 81 00    	mov    0x81d134,%edx
  801983:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801986:	89 50 0c             	mov    %edx,0xc(%eax)
  801989:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80198c:	8b 40 0c             	mov    0xc(%eax),%eax
  80198f:	85 c0                	test   %eax,%eax
  801991:	74 0d                	je     8019a0 <malloc+0x213>
  801993:	a1 34 d1 81 00       	mov    0x81d134,%eax
  801998:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80199b:	89 50 08             	mov    %edx,0x8(%eax)
  80199e:	eb 08                	jmp    8019a8 <malloc+0x21b>
  8019a0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8019a3:	a3 30 d1 81 00       	mov    %eax,0x81d130
  8019a8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8019ab:	a3 34 d1 81 00       	mov    %eax,0x81d134
  8019b0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8019b3:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  8019ba:	a1 3c d1 81 00       	mov    0x81d13c,%eax
  8019bf:	40                   	inc    %eax
  8019c0:	a3 3c d1 81 00       	mov    %eax,0x81d13c
                lastfreeelement->startva += size;
  8019c5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8019c8:	8b 10                	mov    (%eax),%edx
  8019ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8019cd:	01 c2                	add    %eax,%edx
  8019cf:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8019d2:	89 10                	mov    %edx,(%eax)
                lastfreeelement->size -= size;
  8019d4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8019d7:	8b 40 04             	mov    0x4(%eax),%eax
  8019da:	2b 45 08             	sub    0x8(%ebp),%eax
  8019dd:	89 c2                	mov    %eax,%edx
  8019df:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8019e2:	89 50 04             	mov    %edx,0x4(%eax)
                struct UserHeapStruct* currentfree2 = LIST_FIRST(&u_freelist);
  8019e5:	a1 20 d1 81 00       	mov    0x81d120,%eax
  8019ea:	89 45 f0             	mov    %eax,-0x10(%ebp)
                //check order of last element

                while (currentfree2 != NULL){
  8019ed:	e9 0d 01 00 00       	jmp    801aff <malloc+0x372>
                	if(lastfreeelement->size <currentfree2->size){
  8019f2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8019f5:	8b 50 04             	mov    0x4(%eax),%edx
  8019f8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019fb:	8b 40 04             	mov    0x4(%eax),%eax
  8019fe:	39 c2                	cmp    %eax,%edx
  801a00:	0f 83 f0 00 00 00    	jae    801af6 <malloc+0x369>
                		LIST_REMOVE(&u_freelist ,lastfreeelement);
  801a06:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801a0a:	75 14                	jne    801a20 <malloc+0x293>
  801a0c:	83 ec 04             	sub    $0x4,%esp
  801a0f:	68 5b 4c 80 00       	push   $0x804c5b
  801a14:	6a 7a                	push   $0x7a
  801a16:	68 ec 4b 80 00       	push   $0x804bec
  801a1b:	e8 86 ea ff ff       	call   8004a6 <_panic>
  801a20:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801a23:	8b 40 08             	mov    0x8(%eax),%eax
  801a26:	85 c0                	test   %eax,%eax
  801a28:	74 11                	je     801a3b <malloc+0x2ae>
  801a2a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801a2d:	8b 40 08             	mov    0x8(%eax),%eax
  801a30:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801a33:	8b 52 0c             	mov    0xc(%edx),%edx
  801a36:	89 50 0c             	mov    %edx,0xc(%eax)
  801a39:	eb 0b                	jmp    801a46 <malloc+0x2b9>
  801a3b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801a3e:	8b 40 0c             	mov    0xc(%eax),%eax
  801a41:	a3 24 d1 81 00       	mov    %eax,0x81d124
  801a46:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801a49:	8b 40 0c             	mov    0xc(%eax),%eax
  801a4c:	85 c0                	test   %eax,%eax
  801a4e:	74 11                	je     801a61 <malloc+0x2d4>
  801a50:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801a53:	8b 40 0c             	mov    0xc(%eax),%eax
  801a56:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801a59:	8b 52 08             	mov    0x8(%edx),%edx
  801a5c:	89 50 08             	mov    %edx,0x8(%eax)
  801a5f:	eb 0b                	jmp    801a6c <malloc+0x2df>
  801a61:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801a64:	8b 40 08             	mov    0x8(%eax),%eax
  801a67:	a3 20 d1 81 00       	mov    %eax,0x81d120
  801a6c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801a6f:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  801a76:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801a79:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  801a80:	a1 2c d1 81 00       	mov    0x81d12c,%eax
  801a85:	48                   	dec    %eax
  801a86:	a3 2c d1 81 00       	mov    %eax,0x81d12c
                		LIST_INSERT_BEFORE(&u_freelist ,currentfree2 ,lastfreeelement);
  801a8b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801a8f:	74 06                	je     801a97 <malloc+0x30a>
  801a91:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801a95:	75 14                	jne    801aab <malloc+0x31e>
  801a97:	83 ec 04             	sub    $0x4,%esp
  801a9a:	68 7c 4c 80 00       	push   $0x804c7c
  801a9f:	6a 7b                	push   $0x7b
  801aa1:	68 ec 4b 80 00       	push   $0x804bec
  801aa6:	e8 fb e9 ff ff       	call   8004a6 <_panic>
  801aab:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801aae:	8b 50 0c             	mov    0xc(%eax),%edx
  801ab1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801ab4:	89 50 0c             	mov    %edx,0xc(%eax)
  801ab7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801aba:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801abd:	89 50 08             	mov    %edx,0x8(%eax)
  801ac0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ac3:	8b 40 0c             	mov    0xc(%eax),%eax
  801ac6:	85 c0                	test   %eax,%eax
  801ac8:	74 0e                	je     801ad8 <malloc+0x34b>
  801aca:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801acd:	8b 40 0c             	mov    0xc(%eax),%eax
  801ad0:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801ad3:	89 50 08             	mov    %edx,0x8(%eax)
  801ad6:	eb 08                	jmp    801ae0 <malloc+0x353>
  801ad8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801adb:	a3 20 d1 81 00       	mov    %eax,0x81d120
  801ae0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ae3:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801ae6:	89 50 0c             	mov    %edx,0xc(%eax)
  801ae9:	a1 2c d1 81 00       	mov    0x81d12c,%eax
  801aee:	40                   	inc    %eax
  801aef:	a3 2c d1 81 00       	mov    %eax,0x81d12c
                		break;
  801af4:	eb 13                	jmp    801b09 <malloc+0x37c>
                	}
                	currentfree2 = currentfree2->prev_next_info.le_next;
  801af6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801af9:	8b 40 08             	mov    0x8(%eax),%eax
  801afc:	89 45 f0             	mov    %eax,-0x10(%ebp)
                lastfreeelement->startva += size;
                lastfreeelement->size -= size;
                struct UserHeapStruct* currentfree2 = LIST_FIRST(&u_freelist);
                //check order of last element

                while (currentfree2 != NULL){
  801aff:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801b03:	0f 85 e9 fe ff ff    	jne    8019f2 <malloc+0x265>
                	}
                	currentfree2 = currentfree2->prev_next_info.le_next;
                }


                sys_allocate_user_mem(allocblock->startva ,size);
  801b09:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801b0c:	8b 00                	mov    (%eax),%eax
  801b0e:	83 ec 08             	sub    $0x8,%esp
  801b11:	ff 75 08             	pushl  0x8(%ebp)
  801b14:	50                   	push   %eax
  801b15:	e8 17 1a 00 00       	call   803531 <sys_allocate_user_mem>
  801b1a:	83 c4 10             	add    $0x10,%esp
                release_uspinlock(&ulock);
  801b1d:	83 ec 0c             	sub    $0xc,%esp
  801b20:	68 40 d1 81 00       	push   $0x81d140
  801b25:	e8 4f 25 00 00       	call   804079 <release_uspinlock>
  801b2a:	83 c4 10             	add    $0x10,%esp
                return (void*)allocblock->startva;
  801b2d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801b30:	8b 00                	mov    (%eax),%eax
  801b32:	e9 52 01 00 00       	jmp    801c89 <malloc+0x4fc>
                //exact fit
			}else if(size == currentfreeelement->size){
  801b37:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b3a:	8b 40 04             	mov    0x4(%eax),%eax
  801b3d:	3b 45 08             	cmp    0x8(%ebp),%eax
  801b40:	0f 85 2b 01 00 00    	jne    801c71 <malloc+0x4e4>
				allocblock->startva = currentfreeelement->startva;
  801b46:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b49:	8b 10                	mov    (%eax),%edx
  801b4b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801b4e:	89 10                	mov    %edx,(%eax)
				allocblock->size = size;
  801b50:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801b53:	8b 55 08             	mov    0x8(%ebp),%edx
  801b56:	89 50 04             	mov    %edx,0x4(%eax)
				LIST_INSERT_TAIL(&u_allocatedlist ,allocblock);
  801b59:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801b5d:	75 17                	jne    801b76 <malloc+0x3e9>
  801b5f:	83 ec 04             	sub    $0x4,%esp
  801b62:	68 38 4c 80 00       	push   $0x804c38
  801b67:	68 89 00 00 00       	push   $0x89
  801b6c:	68 ec 4b 80 00       	push   $0x804bec
  801b71:	e8 30 e9 ff ff       	call   8004a6 <_panic>
  801b76:	8b 15 34 d1 81 00    	mov    0x81d134,%edx
  801b7c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801b7f:	89 50 0c             	mov    %edx,0xc(%eax)
  801b82:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801b85:	8b 40 0c             	mov    0xc(%eax),%eax
  801b88:	85 c0                	test   %eax,%eax
  801b8a:	74 0d                	je     801b99 <malloc+0x40c>
  801b8c:	a1 34 d1 81 00       	mov    0x81d134,%eax
  801b91:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801b94:	89 50 08             	mov    %edx,0x8(%eax)
  801b97:	eb 08                	jmp    801ba1 <malloc+0x414>
  801b99:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801b9c:	a3 30 d1 81 00       	mov    %eax,0x81d130
  801ba1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801ba4:	a3 34 d1 81 00       	mov    %eax,0x81d134
  801ba9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801bac:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  801bb3:	a1 3c d1 81 00       	mov    0x81d13c,%eax
  801bb8:	40                   	inc    %eax
  801bb9:	a3 3c d1 81 00       	mov    %eax,0x81d13c
				LIST_REMOVE(&u_freelist ,currentfreeelement);
  801bbe:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801bc2:	75 17                	jne    801bdb <malloc+0x44e>
  801bc4:	83 ec 04             	sub    $0x4,%esp
  801bc7:	68 5b 4c 80 00       	push   $0x804c5b
  801bcc:	68 8a 00 00 00       	push   $0x8a
  801bd1:	68 ec 4b 80 00       	push   $0x804bec
  801bd6:	e8 cb e8 ff ff       	call   8004a6 <_panic>
  801bdb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bde:	8b 40 08             	mov    0x8(%eax),%eax
  801be1:	85 c0                	test   %eax,%eax
  801be3:	74 11                	je     801bf6 <malloc+0x469>
  801be5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801be8:	8b 40 08             	mov    0x8(%eax),%eax
  801beb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801bee:	8b 52 0c             	mov    0xc(%edx),%edx
  801bf1:	89 50 0c             	mov    %edx,0xc(%eax)
  801bf4:	eb 0b                	jmp    801c01 <malloc+0x474>
  801bf6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bf9:	8b 40 0c             	mov    0xc(%eax),%eax
  801bfc:	a3 24 d1 81 00       	mov    %eax,0x81d124
  801c01:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c04:	8b 40 0c             	mov    0xc(%eax),%eax
  801c07:	85 c0                	test   %eax,%eax
  801c09:	74 11                	je     801c1c <malloc+0x48f>
  801c0b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c0e:	8b 40 0c             	mov    0xc(%eax),%eax
  801c11:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801c14:	8b 52 08             	mov    0x8(%edx),%edx
  801c17:	89 50 08             	mov    %edx,0x8(%eax)
  801c1a:	eb 0b                	jmp    801c27 <malloc+0x49a>
  801c1c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c1f:	8b 40 08             	mov    0x8(%eax),%eax
  801c22:	a3 20 d1 81 00       	mov    %eax,0x81d120
  801c27:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c2a:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  801c31:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c34:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  801c3b:	a1 2c d1 81 00       	mov    0x81d12c,%eax
  801c40:	48                   	dec    %eax
  801c41:	a3 2c d1 81 00       	mov    %eax,0x81d12c
				sys_allocate_user_mem(allocblock->startva ,size);
  801c46:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801c49:	8b 00                	mov    (%eax),%eax
  801c4b:	83 ec 08             	sub    $0x8,%esp
  801c4e:	ff 75 08             	pushl  0x8(%ebp)
  801c51:	50                   	push   %eax
  801c52:	e8 da 18 00 00       	call   803531 <sys_allocate_user_mem>
  801c57:	83 c4 10             	add    $0x10,%esp
				release_uspinlock(&ulock);
  801c5a:	83 ec 0c             	sub    $0xc,%esp
  801c5d:	68 40 d1 81 00       	push   $0x81d140
  801c62:	e8 12 24 00 00       	call   804079 <release_uspinlock>
  801c67:	83 c4 10             	add    $0x10,%esp
				return (void*)allocblock->startva;
  801c6a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801c6d:	8b 00                	mov    (%eax),%eax
  801c6f:	eb 18                	jmp    801c89 <malloc+0x4fc>
			}
			currentfreeelement = currentfreeelement->prev_next_info.le_next;
  801c71:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c74:	8b 40 08             	mov    0x8(%eax),%eax
  801c77:	89 45 f4             	mov    %eax,-0xc(%ebp)
				}
	}else{
		//custom fit
		struct UserHeapStruct* currentfreeelement = LIST_FIRST(&u_freelist);
		//worst fit
		while(currentfreeelement != NULL){
  801c7a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801c7e:	0f 85 bd fc ff ff    	jne    801941 <malloc+0x1b4>
				return (void*)allocblock->startva;
			}
			currentfreeelement = currentfreeelement->prev_next_info.le_next;
		}
	}
	 return NULL;
  801c84:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c89:	c9                   	leave  
  801c8a:	c3                   	ret    

00801c8b <free>:

//=================================
// [2] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
  801c8b:	55                   	push   %ebp
  801c8c:	89 e5                	mov    %esp,%ebp
  801c8e:	83 ec 38             	sub    $0x38,%esp
	uint32  VA = ROUNDDOWN(((uint32 ) virtual_address), PAGE_SIZE);
  801c91:	8b 45 08             	mov    0x8(%ebp),%eax
  801c94:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801c97:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801c9a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801c9f:	89 45 d8             	mov    %eax,-0x28(%ebp)


		uheap_init();
  801ca2:	e8 b2 f9 ff ff       	call   801659 <uheap_init>
		acquire_uspinlock(&ulock);
  801ca7:	83 ec 0c             	sub    $0xc,%esp
  801caa:	68 40 d1 81 00       	push   $0x81d140
  801caf:	e8 6d 23 00 00       	call   804021 <acquire_uspinlock>
  801cb4:	83 c4 10             	add    $0x10,%esp
		if (VA < uheapPageAllocStart){
  801cb7:	a1 10 d1 81 00       	mov    0x81d110,%eax
  801cbc:	39 45 d8             	cmp    %eax,-0x28(%ebp)
  801cbf:	73 23                	jae    801ce4 <free+0x59>
			free_block(virtual_address);
  801cc1:	83 ec 0c             	sub    $0xc,%esp
  801cc4:	ff 75 08             	pushl  0x8(%ebp)
  801cc7:	e8 89 1f 00 00       	call   803c55 <free_block>
  801ccc:	83 c4 10             	add    $0x10,%esp
			release_uspinlock(&ulock);
  801ccf:	83 ec 0c             	sub    $0xc,%esp
  801cd2:	68 40 d1 81 00       	push   $0x81d140
  801cd7:	e8 9d 23 00 00       	call   804079 <release_uspinlock>
  801cdc:	83 c4 10             	add    $0x10,%esp
			return;
  801cdf:	e9 35 07 00 00       	jmp    802419 <free+0x78e>
		}
		if (VA >= uheapPageAllocBreak){
  801ce4:	a1 68 d0 81 00       	mov    0x81d068,%eax
  801ce9:	39 45 d8             	cmp    %eax,-0x28(%ebp)
  801cec:	72 30                	jb     801d1e <free+0x93>
			cprintf("%d\n %d\n", VA, uheapPageAllocBreak);
  801cee:	a1 68 d0 81 00       	mov    0x81d068,%eax
  801cf3:	83 ec 04             	sub    $0x4,%esp
  801cf6:	50                   	push   %eax
  801cf7:	ff 75 d8             	pushl  -0x28(%ebp)
  801cfa:	68 b1 4c 80 00       	push   $0x804cb1
  801cff:	e8 70 ea ff ff       	call   800774 <cprintf>
  801d04:	83 c4 10             	add    $0x10,%esp

			panic("freeing from restricted area");
  801d07:	83 ec 04             	sub    $0x4,%esp
  801d0a:	68 b9 4c 80 00       	push   $0x804cb9
  801d0f:	68 a7 00 00 00       	push   $0xa7
  801d14:	68 ec 4b 80 00       	push   $0x804bec
  801d19:	e8 88 e7 ff ff       	call   8004a6 <_panic>
			release_uspinlock(&ulock);
			return;
		}

		struct UserHeapStruct* newfree = (struct UserHeapStruct*) alloc_block(sizeof(struct UserHeapStruct));
  801d1e:	83 ec 0c             	sub    $0xc,%esp
  801d21:	6a 10                	push   $0x10
  801d23:	e8 91 1a 00 00       	call   8037b9 <alloc_block>
  801d28:	83 c4 10             	add    $0x10,%esp
  801d2b:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		struct UserHeapStruct* MergedBlock  = ( struct UserHeapStruct*)alloc_block(sizeof(struct UserHeapStruct));
  801d2e:	83 ec 0c             	sub    $0xc,%esp
  801d31:	6a 10                	push   $0x10
  801d33:	e8 81 1a 00 00       	call   8037b9 <alloc_block>
  801d38:	83 c4 10             	add    $0x10,%esp
  801d3b:	89 45 d0             	mov    %eax,-0x30(%ebp)

		struct UserHeapStruct* ToBefreed = LIST_FIRST(&u_allocatedlist);
  801d3e:	a1 30 d1 81 00       	mov    0x81d130,%eax
  801d43:	89 45 f4             	mov    %eax,-0xc(%ebp)
		bool foundVA = 0;
  801d46:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

		//find the allocated block
		while(ToBefreed !=NULL ){
  801d4d:	eb 1c                	jmp    801d6b <free+0xe0>

			if (VA ==ToBefreed->startva ){
  801d4f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d52:	8b 00                	mov    (%eax),%eax
  801d54:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  801d57:	75 09                	jne    801d62 <free+0xd7>
				foundVA = 1;
  801d59:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
				break;
  801d60:	eb 0f                	jmp    801d71 <free+0xe6>
			}
				ToBefreed = ToBefreed->prev_next_info.le_next;
  801d62:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d65:	8b 40 08             	mov    0x8(%eax),%eax
  801d68:	89 45 f4             	mov    %eax,-0xc(%ebp)

		struct UserHeapStruct* ToBefreed = LIST_FIRST(&u_allocatedlist);
		bool foundVA = 0;

		//find the allocated block
		while(ToBefreed !=NULL ){
  801d6b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801d6f:	75 de                	jne    801d4f <free+0xc4>
			}
				ToBefreed = ToBefreed->prev_next_info.le_next;
		}


		if(!foundVA){
  801d71:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801d75:	75 17                	jne    801d8e <free+0x103>
				panic("INVALID ADDRESS!");
  801d77:	83 ec 04             	sub    $0x4,%esp
  801d7a:	68 d6 4c 80 00       	push   $0x804cd6
  801d7f:	68 be 00 00 00       	push   $0xbe
  801d84:	68 ec 4b 80 00       	push   $0x804bec
  801d89:	e8 18 e7 ff ff       	call   8004a6 <_panic>
				release_uspinlock(&ulock);
				return;
			}


		newfree->startva = ToBefreed->startva;
  801d8e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d91:	8b 10                	mov    (%eax),%edx
  801d93:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801d96:	89 10                	mov    %edx,(%eax)
		newfree->size = ToBefreed->size;
  801d98:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d9b:	8b 50 04             	mov    0x4(%eax),%edx
  801d9e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801da1:	89 50 04             	mov    %edx,0x4(%eax)

		//remove allocated block from alloclist
		LIST_REMOVE(&u_allocatedlist, ToBefreed);
  801da4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801da8:	75 17                	jne    801dc1 <free+0x136>
  801daa:	83 ec 04             	sub    $0x4,%esp
  801dad:	68 5b 4c 80 00       	push   $0x804c5b
  801db2:	68 c8 00 00 00       	push   $0xc8
  801db7:	68 ec 4b 80 00       	push   $0x804bec
  801dbc:	e8 e5 e6 ff ff       	call   8004a6 <_panic>
  801dc1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dc4:	8b 40 08             	mov    0x8(%eax),%eax
  801dc7:	85 c0                	test   %eax,%eax
  801dc9:	74 11                	je     801ddc <free+0x151>
  801dcb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dce:	8b 40 08             	mov    0x8(%eax),%eax
  801dd1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801dd4:	8b 52 0c             	mov    0xc(%edx),%edx
  801dd7:	89 50 0c             	mov    %edx,0xc(%eax)
  801dda:	eb 0b                	jmp    801de7 <free+0x15c>
  801ddc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ddf:	8b 40 0c             	mov    0xc(%eax),%eax
  801de2:	a3 34 d1 81 00       	mov    %eax,0x81d134
  801de7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dea:	8b 40 0c             	mov    0xc(%eax),%eax
  801ded:	85 c0                	test   %eax,%eax
  801def:	74 11                	je     801e02 <free+0x177>
  801df1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801df4:	8b 40 0c             	mov    0xc(%eax),%eax
  801df7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801dfa:	8b 52 08             	mov    0x8(%edx),%edx
  801dfd:	89 50 08             	mov    %edx,0x8(%eax)
  801e00:	eb 0b                	jmp    801e0d <free+0x182>
  801e02:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e05:	8b 40 08             	mov    0x8(%eax),%eax
  801e08:	a3 30 d1 81 00       	mov    %eax,0x81d130
  801e0d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e10:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  801e17:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e1a:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  801e21:	a1 3c d1 81 00       	mov    0x81d13c,%eax
  801e26:	48                   	dec    %eax
  801e27:	a3 3c d1 81 00       	mov    %eax,0x81d13c

		sys_free_user_mem(ToBefreed->startva, ToBefreed->size);
  801e2c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e2f:	8b 50 04             	mov    0x4(%eax),%edx
  801e32:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e35:	8b 00                	mov    (%eax),%eax
  801e37:	83 ec 08             	sub    $0x8,%esp
  801e3a:	52                   	push   %edx
  801e3b:	50                   	push   %eax
  801e3c:	e8 d4 16 00 00       	call   803515 <sys_free_user_mem>
  801e41:	83 c4 10             	add    $0x10,%esp




		if(LIST_SIZE(&u_freelist) == 0){
  801e44:	a1 2c d1 81 00       	mov    0x81d12c,%eax
  801e49:	85 c0                	test   %eax,%eax
  801e4b:	75 7a                	jne    801ec7 <free+0x23c>
			LIST_INSERT_HEAD(&u_freelist,newfree);
  801e4d:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  801e51:	75 17                	jne    801e6a <free+0x1df>
  801e53:	83 ec 04             	sub    $0x4,%esp
  801e56:	68 e8 4c 80 00       	push   $0x804ce8
  801e5b:	68 d0 00 00 00       	push   $0xd0
  801e60:	68 ec 4b 80 00       	push   $0x804bec
  801e65:	e8 3c e6 ff ff       	call   8004a6 <_panic>
  801e6a:	8b 15 20 d1 81 00    	mov    0x81d120,%edx
  801e70:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801e73:	89 50 08             	mov    %edx,0x8(%eax)
  801e76:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801e79:	8b 40 08             	mov    0x8(%eax),%eax
  801e7c:	85 c0                	test   %eax,%eax
  801e7e:	74 0d                	je     801e8d <free+0x202>
  801e80:	a1 20 d1 81 00       	mov    0x81d120,%eax
  801e85:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  801e88:	89 50 0c             	mov    %edx,0xc(%eax)
  801e8b:	eb 08                	jmp    801e95 <free+0x20a>
  801e8d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801e90:	a3 24 d1 81 00       	mov    %eax,0x81d124
  801e95:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801e98:	a3 20 d1 81 00       	mov    %eax,0x81d120
  801e9d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801ea0:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  801ea7:	a1 2c d1 81 00       	mov    0x81d12c,%eax
  801eac:	40                   	inc    %eax
  801ead:	a3 2c d1 81 00       	mov    %eax,0x81d12c
			release_uspinlock(&ulock);
  801eb2:	83 ec 0c             	sub    $0xc,%esp
  801eb5:	68 40 d1 81 00       	push   $0x81d140
  801eba:	e8 ba 21 00 00       	call   804079 <release_uspinlock>
  801ebf:	83 c4 10             	add    $0x10,%esp
			return;
  801ec2:	e9 52 05 00 00       	jmp    802419 <free+0x78e>
		}


		struct UserHeapStruct* ToBeMerged = LIST_FIRST(&u_freelist);
  801ec7:	a1 20 d1 81 00       	mov    0x81d120,%eax
  801ecc:	89 45 ec             	mov    %eax,-0x14(%ebp)
		// merge with prev if possible
		bool mergeprev = 0;
  801ecf:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		bool mergenext = 0;
  801ed6:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
		while(ToBeMerged != NULL){
  801edd:	e9 d2 00 00 00       	jmp    801fb4 <free+0x329>
			if((ToBeMerged->startva +ToBeMerged->size) == newfree->startva){
  801ee2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801ee5:	8b 10                	mov    (%eax),%edx
  801ee7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801eea:	8b 40 04             	mov    0x4(%eax),%eax
  801eed:	01 c2                	add    %eax,%edx
  801eef:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801ef2:	8b 00                	mov    (%eax),%eax
  801ef4:	39 c2                	cmp    %eax,%edx
  801ef6:	0f 85 af 00 00 00    	jne    801fab <free+0x320>

				MergedBlock->startva = ToBeMerged->startva;
  801efc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801eff:	8b 10                	mov    (%eax),%edx
  801f01:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801f04:	89 10                	mov    %edx,(%eax)
				MergedBlock->size = ToBeMerged->size + newfree->size;
  801f06:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f09:	8b 50 04             	mov    0x4(%eax),%edx
  801f0c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801f0f:	8b 40 04             	mov    0x4(%eax),%eax
  801f12:	01 c2                	add    %eax,%edx
  801f14:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801f17:	89 50 04             	mov    %edx,0x4(%eax)
				LIST_REMOVE(&u_freelist, ToBeMerged);
  801f1a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801f1e:	75 17                	jne    801f37 <free+0x2ac>
  801f20:	83 ec 04             	sub    $0x4,%esp
  801f23:	68 5b 4c 80 00       	push   $0x804c5b
  801f28:	68 df 00 00 00       	push   $0xdf
  801f2d:	68 ec 4b 80 00       	push   $0x804bec
  801f32:	e8 6f e5 ff ff       	call   8004a6 <_panic>
  801f37:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f3a:	8b 40 08             	mov    0x8(%eax),%eax
  801f3d:	85 c0                	test   %eax,%eax
  801f3f:	74 11                	je     801f52 <free+0x2c7>
  801f41:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f44:	8b 40 08             	mov    0x8(%eax),%eax
  801f47:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801f4a:	8b 52 0c             	mov    0xc(%edx),%edx
  801f4d:	89 50 0c             	mov    %edx,0xc(%eax)
  801f50:	eb 0b                	jmp    801f5d <free+0x2d2>
  801f52:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f55:	8b 40 0c             	mov    0xc(%eax),%eax
  801f58:	a3 24 d1 81 00       	mov    %eax,0x81d124
  801f5d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f60:	8b 40 0c             	mov    0xc(%eax),%eax
  801f63:	85 c0                	test   %eax,%eax
  801f65:	74 11                	je     801f78 <free+0x2ed>
  801f67:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f6a:	8b 40 0c             	mov    0xc(%eax),%eax
  801f6d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801f70:	8b 52 08             	mov    0x8(%edx),%edx
  801f73:	89 50 08             	mov    %edx,0x8(%eax)
  801f76:	eb 0b                	jmp    801f83 <free+0x2f8>
  801f78:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f7b:	8b 40 08             	mov    0x8(%eax),%eax
  801f7e:	a3 20 d1 81 00       	mov    %eax,0x81d120
  801f83:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f86:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  801f8d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f90:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  801f97:	a1 2c d1 81 00       	mov    0x81d12c,%eax
  801f9c:	48                   	dec    %eax
  801f9d:	a3 2c d1 81 00       	mov    %eax,0x81d12c
				mergeprev = 1;
  801fa2:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
				break;
  801fa9:	eb 13                	jmp    801fbe <free+0x333>
			}
				ToBeMerged = ToBeMerged->prev_next_info.le_next;
  801fab:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801fae:	8b 40 08             	mov    0x8(%eax),%eax
  801fb1:	89 45 ec             	mov    %eax,-0x14(%ebp)

		struct UserHeapStruct* ToBeMerged = LIST_FIRST(&u_freelist);
		// merge with prev if possible
		bool mergeprev = 0;
		bool mergenext = 0;
		while(ToBeMerged != NULL){
  801fb4:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801fb8:	0f 85 24 ff ff ff    	jne    801ee2 <free+0x257>
//									uheapPageAllocBreak = newfree->startva;
//						}
//					}


		if ( newfree ->startva + newfree->size == uheapPageAllocBreak){
  801fbe:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801fc1:	8b 10                	mov    (%eax),%edx
  801fc3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801fc6:	8b 40 04             	mov    0x4(%eax),%eax
  801fc9:	01 c2                	add    %eax,%edx
  801fcb:	a1 68 d0 81 00       	mov    0x81d068,%eax
  801fd0:	39 c2                	cmp    %eax,%edx
  801fd2:	75 44                	jne    802018 <free+0x38d>

			if(mergeprev){
  801fd4:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  801fd8:	74 1f                	je     801ff9 <free+0x36e>
				uheapPageAllocBreak = MergedBlock->startva;
  801fda:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801fdd:	8b 00                	mov    (%eax),%eax
  801fdf:	a3 68 d0 81 00       	mov    %eax,0x81d068
				release_uspinlock(&ulock);
  801fe4:	83 ec 0c             	sub    $0xc,%esp
  801fe7:	68 40 d1 81 00       	push   $0x81d140
  801fec:	e8 88 20 00 00       	call   804079 <release_uspinlock>
  801ff1:	83 c4 10             	add    $0x10,%esp
				return;
  801ff4:	e9 20 04 00 00       	jmp    802419 <free+0x78e>

			}else{
				uheapPageAllocBreak = newfree->startva;
  801ff9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801ffc:	8b 00                	mov    (%eax),%eax
  801ffe:	a3 68 d0 81 00       	mov    %eax,0x81d068
				release_uspinlock(&ulock);
  802003:	83 ec 0c             	sub    $0xc,%esp
  802006:	68 40 d1 81 00       	push   $0x81d140
  80200b:	e8 69 20 00 00       	call   804079 <release_uspinlock>
  802010:	83 c4 10             	add    $0x10,%esp
				return;
  802013:	e9 01 04 00 00       	jmp    802419 <free+0x78e>

		}


		//check if block is merged with prev ,and find possible merge with next
		ToBeMerged = LIST_FIRST(&u_freelist);
  802018:	a1 20 d1 81 00       	mov    0x81d120,%eax
  80201d:	89 45 ec             	mov    %eax,-0x14(%ebp)
		while(ToBeMerged != NULL){
  802020:	e9 7d 01 00 00       	jmp    8021a2 <free+0x517>
			if ((newfree->startva + newfree->size) == ToBeMerged->startva ){
  802025:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802028:	8b 10                	mov    (%eax),%edx
  80202a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80202d:	8b 40 04             	mov    0x4(%eax),%eax
  802030:	01 c2                	add    %eax,%edx
  802032:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802035:	8b 00                	mov    (%eax),%eax
  802037:	39 c2                	cmp    %eax,%edx
  802039:	0f 85 5a 01 00 00    	jne    802199 <free+0x50e>
				if (mergeprev){
  80203f:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802043:	0f 84 a1 00 00 00    	je     8020ea <free+0x45f>
					MergedBlock->size += ToBeMerged->size;
  802049:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80204c:	8b 50 04             	mov    0x4(%eax),%edx
  80204f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802052:	8b 40 04             	mov    0x4(%eax),%eax
  802055:	01 c2                	add    %eax,%edx
  802057:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80205a:	89 50 04             	mov    %edx,0x4(%eax)
					LIST_REMOVE(&u_freelist, ToBeMerged);
  80205d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802061:	75 17                	jne    80207a <free+0x3ef>
  802063:	83 ec 04             	sub    $0x4,%esp
  802066:	68 5b 4c 80 00       	push   $0x804c5b
  80206b:	68 0a 01 00 00       	push   $0x10a
  802070:	68 ec 4b 80 00       	push   $0x804bec
  802075:	e8 2c e4 ff ff       	call   8004a6 <_panic>
  80207a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80207d:	8b 40 08             	mov    0x8(%eax),%eax
  802080:	85 c0                	test   %eax,%eax
  802082:	74 11                	je     802095 <free+0x40a>
  802084:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802087:	8b 40 08             	mov    0x8(%eax),%eax
  80208a:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80208d:	8b 52 0c             	mov    0xc(%edx),%edx
  802090:	89 50 0c             	mov    %edx,0xc(%eax)
  802093:	eb 0b                	jmp    8020a0 <free+0x415>
  802095:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802098:	8b 40 0c             	mov    0xc(%eax),%eax
  80209b:	a3 24 d1 81 00       	mov    %eax,0x81d124
  8020a0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8020a3:	8b 40 0c             	mov    0xc(%eax),%eax
  8020a6:	85 c0                	test   %eax,%eax
  8020a8:	74 11                	je     8020bb <free+0x430>
  8020aa:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8020ad:	8b 40 0c             	mov    0xc(%eax),%eax
  8020b0:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8020b3:	8b 52 08             	mov    0x8(%edx),%edx
  8020b6:	89 50 08             	mov    %edx,0x8(%eax)
  8020b9:	eb 0b                	jmp    8020c6 <free+0x43b>
  8020bb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8020be:	8b 40 08             	mov    0x8(%eax),%eax
  8020c1:	a3 20 d1 81 00       	mov    %eax,0x81d120
  8020c6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8020c9:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  8020d0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8020d3:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  8020da:	a1 2c d1 81 00       	mov    0x81d12c,%eax
  8020df:	48                   	dec    %eax
  8020e0:	a3 2c d1 81 00       	mov    %eax,0x81d12c
					break;
  8020e5:	e9 c2 00 00 00       	jmp    8021ac <free+0x521>
		//if not merged find possible merge with next
				}else{
					MergedBlock->startva = newfree->startva;
  8020ea:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8020ed:	8b 10                	mov    (%eax),%edx
  8020ef:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8020f2:	89 10                	mov    %edx,(%eax)
					MergedBlock->size  = newfree->size + ToBeMerged->size;
  8020f4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8020f7:	8b 50 04             	mov    0x4(%eax),%edx
  8020fa:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8020fd:	8b 40 04             	mov    0x4(%eax),%eax
  802100:	01 c2                	add    %eax,%edx
  802102:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802105:	89 50 04             	mov    %edx,0x4(%eax)
					LIST_REMOVE(&u_freelist, ToBeMerged);
  802108:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80210c:	75 17                	jne    802125 <free+0x49a>
  80210e:	83 ec 04             	sub    $0x4,%esp
  802111:	68 5b 4c 80 00       	push   $0x804c5b
  802116:	68 10 01 00 00       	push   $0x110
  80211b:	68 ec 4b 80 00       	push   $0x804bec
  802120:	e8 81 e3 ff ff       	call   8004a6 <_panic>
  802125:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802128:	8b 40 08             	mov    0x8(%eax),%eax
  80212b:	85 c0                	test   %eax,%eax
  80212d:	74 11                	je     802140 <free+0x4b5>
  80212f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802132:	8b 40 08             	mov    0x8(%eax),%eax
  802135:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802138:	8b 52 0c             	mov    0xc(%edx),%edx
  80213b:	89 50 0c             	mov    %edx,0xc(%eax)
  80213e:	eb 0b                	jmp    80214b <free+0x4c0>
  802140:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802143:	8b 40 0c             	mov    0xc(%eax),%eax
  802146:	a3 24 d1 81 00       	mov    %eax,0x81d124
  80214b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80214e:	8b 40 0c             	mov    0xc(%eax),%eax
  802151:	85 c0                	test   %eax,%eax
  802153:	74 11                	je     802166 <free+0x4db>
  802155:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802158:	8b 40 0c             	mov    0xc(%eax),%eax
  80215b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80215e:	8b 52 08             	mov    0x8(%edx),%edx
  802161:	89 50 08             	mov    %edx,0x8(%eax)
  802164:	eb 0b                	jmp    802171 <free+0x4e6>
  802166:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802169:	8b 40 08             	mov    0x8(%eax),%eax
  80216c:	a3 20 d1 81 00       	mov    %eax,0x81d120
  802171:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802174:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  80217b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80217e:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  802185:	a1 2c d1 81 00       	mov    0x81d12c,%eax
  80218a:	48                   	dec    %eax
  80218b:	a3 2c d1 81 00       	mov    %eax,0x81d12c
					mergenext = 1;
  802190:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
					break;
  802197:	eb 13                	jmp    8021ac <free+0x521>
				}
			}
			ToBeMerged = ToBeMerged->prev_next_info.le_next;
  802199:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80219c:	8b 40 08             	mov    0x8(%eax),%eax
  80219f:	89 45 ec             	mov    %eax,-0x14(%ebp)
		}


		//check if block is merged with prev ,and find possible merge with next
		ToBeMerged = LIST_FIRST(&u_freelist);
		while(ToBeMerged != NULL){
  8021a2:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8021a6:	0f 85 79 fe ff ff    	jne    802025 <free+0x39a>




			// insertion
			struct UserHeapStruct* currentfree = LIST_FIRST(&u_freelist);
  8021ac:	a1 20 d1 81 00       	mov    0x81d120,%eax
  8021b1:	89 45 e0             	mov    %eax,-0x20(%ebp)

			if(mergeprev || mergenext){
  8021b4:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8021b8:	0f 85 ad 00 00 00    	jne    80226b <free+0x5e0>
  8021be:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8021c2:	0f 84 c3 01 00 00    	je     80238b <free+0x700>
				while(currentfree != NULL){
  8021c8:	e9 9e 00 00 00       	jmp    80226b <free+0x5e0>
					if(MergedBlock->size < currentfree->size){
  8021cd:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8021d0:	8b 50 04             	mov    0x4(%eax),%edx
  8021d3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8021d6:	8b 40 04             	mov    0x4(%eax),%eax
  8021d9:	39 c2                	cmp    %eax,%edx
  8021db:	0f 83 81 00 00 00    	jae    802262 <free+0x5d7>

							LIST_INSERT_BEFORE(&u_freelist,currentfree,MergedBlock);
  8021e1:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8021e5:	74 06                	je     8021ed <free+0x562>
  8021e7:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  8021eb:	75 17                	jne    802204 <free+0x579>
  8021ed:	83 ec 04             	sub    $0x4,%esp
  8021f0:	68 7c 4c 80 00       	push   $0x804c7c
  8021f5:	68 23 01 00 00       	push   $0x123
  8021fa:	68 ec 4b 80 00       	push   $0x804bec
  8021ff:	e8 a2 e2 ff ff       	call   8004a6 <_panic>
  802204:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802207:	8b 50 0c             	mov    0xc(%eax),%edx
  80220a:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80220d:	89 50 0c             	mov    %edx,0xc(%eax)
  802210:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802213:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802216:	89 50 08             	mov    %edx,0x8(%eax)
  802219:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80221c:	8b 40 0c             	mov    0xc(%eax),%eax
  80221f:	85 c0                	test   %eax,%eax
  802221:	74 0e                	je     802231 <free+0x5a6>
  802223:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802226:	8b 40 0c             	mov    0xc(%eax),%eax
  802229:	8b 55 d0             	mov    -0x30(%ebp),%edx
  80222c:	89 50 08             	mov    %edx,0x8(%eax)
  80222f:	eb 08                	jmp    802239 <free+0x5ae>
  802231:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802234:	a3 20 d1 81 00       	mov    %eax,0x81d120
  802239:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80223c:	8b 55 d0             	mov    -0x30(%ebp),%edx
  80223f:	89 50 0c             	mov    %edx,0xc(%eax)
  802242:	a1 2c d1 81 00       	mov    0x81d12c,%eax
  802247:	40                   	inc    %eax
  802248:	a3 2c d1 81 00       	mov    %eax,0x81d12c
							release_uspinlock(&ulock);
  80224d:	83 ec 0c             	sub    $0xc,%esp
  802250:	68 40 d1 81 00       	push   $0x81d140
  802255:	e8 1f 1e 00 00       	call   804079 <release_uspinlock>
  80225a:	83 c4 10             	add    $0x10,%esp
							return;
  80225d:	e9 b7 01 00 00       	jmp    802419 <free+0x78e>
					}
							currentfree = currentfree->prev_next_info.le_next;
  802262:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802265:	8b 40 08             	mov    0x8(%eax),%eax
  802268:	89 45 e0             	mov    %eax,-0x20(%ebp)

			// insertion
			struct UserHeapStruct* currentfree = LIST_FIRST(&u_freelist);

			if(mergeprev || mergenext){
				while(currentfree != NULL){
  80226b:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80226f:	0f 85 58 ff ff ff    	jne    8021cd <free+0x542>
							release_uspinlock(&ulock);
							return;
					}
							currentfree = currentfree->prev_next_info.le_next;
				}
				free_block(newfree);
  802275:	83 ec 0c             	sub    $0xc,%esp
  802278:	ff 75 d4             	pushl  -0x2c(%ebp)
  80227b:	e8 d5 19 00 00       	call   803c55 <free_block>
  802280:	83 c4 10             	add    $0x10,%esp
				LIST_INSERT_TAIL(&u_freelist,MergedBlock);
  802283:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  802287:	75 17                	jne    8022a0 <free+0x615>
  802289:	83 ec 04             	sub    $0x4,%esp
  80228c:	68 38 4c 80 00       	push   $0x804c38
  802291:	68 2a 01 00 00       	push   $0x12a
  802296:	68 ec 4b 80 00       	push   $0x804bec
  80229b:	e8 06 e2 ff ff       	call   8004a6 <_panic>
  8022a0:	8b 15 24 d1 81 00    	mov    0x81d124,%edx
  8022a6:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8022a9:	89 50 0c             	mov    %edx,0xc(%eax)
  8022ac:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8022af:	8b 40 0c             	mov    0xc(%eax),%eax
  8022b2:	85 c0                	test   %eax,%eax
  8022b4:	74 0d                	je     8022c3 <free+0x638>
  8022b6:	a1 24 d1 81 00       	mov    0x81d124,%eax
  8022bb:	8b 55 d0             	mov    -0x30(%ebp),%edx
  8022be:	89 50 08             	mov    %edx,0x8(%eax)
  8022c1:	eb 08                	jmp    8022cb <free+0x640>
  8022c3:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8022c6:	a3 20 d1 81 00       	mov    %eax,0x81d120
  8022cb:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8022ce:	a3 24 d1 81 00       	mov    %eax,0x81d124
  8022d3:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8022d6:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  8022dd:	a1 2c d1 81 00       	mov    0x81d12c,%eax
  8022e2:	40                   	inc    %eax
  8022e3:	a3 2c d1 81 00       	mov    %eax,0x81d12c
  8022e8:	e9 1b 01 00 00       	jmp    802408 <free+0x77d>

			}else{
				while(currentfree != NULL){
					if(newfree->size < currentfree->size){
  8022ed:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8022f0:	8b 50 04             	mov    0x4(%eax),%edx
  8022f3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8022f6:	8b 40 04             	mov    0x4(%eax),%eax
  8022f9:	39 c2                	cmp    %eax,%edx
  8022fb:	0f 83 81 00 00 00    	jae    802382 <free+0x6f7>

							LIST_INSERT_BEFORE(&u_freelist,currentfree,newfree);
  802301:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802305:	74 06                	je     80230d <free+0x682>
  802307:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80230b:	75 17                	jne    802324 <free+0x699>
  80230d:	83 ec 04             	sub    $0x4,%esp
  802310:	68 7c 4c 80 00       	push   $0x804c7c
  802315:	68 30 01 00 00       	push   $0x130
  80231a:	68 ec 4b 80 00       	push   $0x804bec
  80231f:	e8 82 e1 ff ff       	call   8004a6 <_panic>
  802324:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802327:	8b 50 0c             	mov    0xc(%eax),%edx
  80232a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80232d:	89 50 0c             	mov    %edx,0xc(%eax)
  802330:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802333:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802336:	89 50 08             	mov    %edx,0x8(%eax)
  802339:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80233c:	8b 40 0c             	mov    0xc(%eax),%eax
  80233f:	85 c0                	test   %eax,%eax
  802341:	74 0e                	je     802351 <free+0x6c6>
  802343:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802346:	8b 40 0c             	mov    0xc(%eax),%eax
  802349:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80234c:	89 50 08             	mov    %edx,0x8(%eax)
  80234f:	eb 08                	jmp    802359 <free+0x6ce>
  802351:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802354:	a3 20 d1 81 00       	mov    %eax,0x81d120
  802359:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80235c:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80235f:	89 50 0c             	mov    %edx,0xc(%eax)
  802362:	a1 2c d1 81 00       	mov    0x81d12c,%eax
  802367:	40                   	inc    %eax
  802368:	a3 2c d1 81 00       	mov    %eax,0x81d12c
							release_uspinlock(&ulock);
  80236d:	83 ec 0c             	sub    $0xc,%esp
  802370:	68 40 d1 81 00       	push   $0x81d140
  802375:	e8 ff 1c 00 00       	call   804079 <release_uspinlock>
  80237a:	83 c4 10             	add    $0x10,%esp
							return;
  80237d:	e9 97 00 00 00       	jmp    802419 <free+0x78e>
					}
							currentfree = currentfree->prev_next_info.le_next;
  802382:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802385:	8b 40 08             	mov    0x8(%eax),%eax
  802388:	89 45 e0             	mov    %eax,-0x20(%ebp)
				}
				free_block(newfree);
				LIST_INSERT_TAIL(&u_freelist,MergedBlock);

			}else{
				while(currentfree != NULL){
  80238b:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80238f:	0f 85 58 ff ff ff    	jne    8022ed <free+0x662>
							release_uspinlock(&ulock);
							return;
					}
							currentfree = currentfree->prev_next_info.le_next;
				}
				free_block(MergedBlock);
  802395:	83 ec 0c             	sub    $0xc,%esp
  802398:	ff 75 d0             	pushl  -0x30(%ebp)
  80239b:	e8 b5 18 00 00       	call   803c55 <free_block>
  8023a0:	83 c4 10             	add    $0x10,%esp
				LIST_INSERT_TAIL(&u_freelist,newfree);
  8023a3:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8023a7:	75 17                	jne    8023c0 <free+0x735>
  8023a9:	83 ec 04             	sub    $0x4,%esp
  8023ac:	68 38 4c 80 00       	push   $0x804c38
  8023b1:	68 37 01 00 00       	push   $0x137
  8023b6:	68 ec 4b 80 00       	push   $0x804bec
  8023bb:	e8 e6 e0 ff ff       	call   8004a6 <_panic>
  8023c0:	8b 15 24 d1 81 00    	mov    0x81d124,%edx
  8023c6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8023c9:	89 50 0c             	mov    %edx,0xc(%eax)
  8023cc:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8023cf:	8b 40 0c             	mov    0xc(%eax),%eax
  8023d2:	85 c0                	test   %eax,%eax
  8023d4:	74 0d                	je     8023e3 <free+0x758>
  8023d6:	a1 24 d1 81 00       	mov    0x81d124,%eax
  8023db:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8023de:	89 50 08             	mov    %edx,0x8(%eax)
  8023e1:	eb 08                	jmp    8023eb <free+0x760>
  8023e3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8023e6:	a3 20 d1 81 00       	mov    %eax,0x81d120
  8023eb:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8023ee:	a3 24 d1 81 00       	mov    %eax,0x81d124
  8023f3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8023f6:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  8023fd:	a1 2c d1 81 00       	mov    0x81d12c,%eax
  802402:	40                   	inc    %eax
  802403:	a3 2c d1 81 00       	mov    %eax,0x81d12c
			}
		release_uspinlock(&ulock);
  802408:	83 ec 0c             	sub    $0xc,%esp
  80240b:	68 40 d1 81 00       	push   $0x81d140
  802410:	e8 64 1c 00 00       	call   804079 <release_uspinlock>
  802415:	83 c4 10             	add    $0x10,%esp
		return;
  802418:	90                   	nop
}
  802419:	c9                   	leave  
  80241a:	c3                   	ret    

0080241b <smalloc>:

//=================================
// [3] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  80241b:	55                   	push   %ebp
  80241c:	89 e5                	mov    %esp,%ebp
  80241e:	83 ec 48             	sub    $0x48,%esp
  802421:	8b 45 10             	mov    0x10(%ebp),%eax
  802424:	88 45 c4             	mov    %al,-0x3c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  802427:	e8 2d f2 ff ff       	call   801659 <uheap_init>
	if (size == 0) return NULL;
  80242c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802430:	75 0a                	jne    80243c <smalloc+0x21>
  802432:	b8 00 00 00 00       	mov    $0x0,%eax
  802437:	e9 84 05 00 00       	jmp    8029c0 <smalloc+0x5a5>
	//==============================================================
	acquire_uspinlock(&ulock);
  80243c:	83 ec 0c             	sub    $0xc,%esp
  80243f:	68 40 d1 81 00       	push   $0x81d140
  802444:	e8 d8 1b 00 00       	call   804021 <acquire_uspinlock>
  802449:	83 c4 10             	add    $0x10,%esp

	struct UserHeapStruct* allocblock = (struct UserHeapStruct*) alloc_block(sizeof(struct UserHeapStruct));
  80244c:	83 ec 0c             	sub    $0xc,%esp
  80244f:	6a 10                	push   $0x10
  802451:	e8 63 13 00 00       	call   8037b9 <alloc_block>
  802456:	83 c4 10             	add    $0x10,%esp
  802459:	89 45 ec             	mov    %eax,-0x14(%ebp)
	if (allocblock == NULL){
  80245c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802460:	75 0a                	jne    80246c <smalloc+0x51>
				return NULL;
  802462:	b8 00 00 00 00       	mov    $0x0,%eax
  802467:	e9 54 05 00 00       	jmp    8029c0 <smalloc+0x5a5>
	}
		size = ROUNDUP(size,PAGE_SIZE);
  80246c:	c7 45 e8 00 10 00 00 	movl   $0x1000,-0x18(%ebp)
  802473:	8b 55 0c             	mov    0xc(%ebp),%edx
  802476:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802479:	01 d0                	add    %edx,%eax
  80247b:	48                   	dec    %eax
  80247c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80247f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802482:	ba 00 00 00 00       	mov    $0x0,%edx
  802487:	f7 75 e8             	divl   -0x18(%ebp)
  80248a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80248d:	29 d0                	sub    %edx,%eax
  80248f:	89 45 0c             	mov    %eax,0xc(%ebp)
		struct UserHeapStruct* lastfreeelement = LIST_LAST(&u_freelist);
  802492:	a1 24 d1 81 00       	mov    0x81d124,%eax
  802497:	89 45 e0             	mov    %eax,-0x20(%ebp)

		if(LIST_SIZE(&u_freelist)==0 || size>lastfreeelement->size){
  80249a:	a1 2c d1 81 00       	mov    0x81d12c,%eax
  80249f:	85 c0                	test   %eax,%eax
  8024a1:	74 0f                	je     8024b2 <smalloc+0x97>
  8024a3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8024a6:	8b 40 04             	mov    0x4(%eax),%eax
  8024a9:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8024ac:	0f 83 25 01 00 00    	jae    8025d7 <smalloc+0x1bc>
				if(uheapPageAllocBreak <= USER_HEAP_MAX - size){
  8024b2:	b8 00 00 00 a0       	mov    $0xa0000000,%eax
  8024b7:	2b 45 0c             	sub    0xc(%ebp),%eax
  8024ba:	89 c2                	mov    %eax,%edx
  8024bc:	a1 68 d0 81 00       	mov    0x81d068,%eax
  8024c1:	39 c2                	cmp    %eax,%edx
  8024c3:	0f 82 f4 00 00 00    	jb     8025bd <smalloc+0x1a2>
						uint32 requestedblockva = uheapPageAllocBreak;
  8024c9:	a1 68 d0 81 00       	mov    0x81d068,%eax
  8024ce:	89 45 d4             	mov    %eax,-0x2c(%ebp)
						uheapPageAllocBreak+=size;
  8024d1:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  8024d7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8024da:	01 d0                	add    %edx,%eax
  8024dc:	a3 68 d0 81 00       	mov    %eax,0x81d068
						allocblock->startva = requestedblockva;
  8024e1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8024e4:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8024e7:	89 10                	mov    %edx,(%eax)
						allocblock->size = size;
  8024e9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8024ec:	8b 55 0c             	mov    0xc(%ebp),%edx
  8024ef:	89 50 04             	mov    %edx,0x4(%eax)

						LIST_INSERT_TAIL(&u_allocatedlist, allocblock);
  8024f2:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8024f6:	75 17                	jne    80250f <smalloc+0xf4>
  8024f8:	83 ec 04             	sub    $0x4,%esp
  8024fb:	68 38 4c 80 00       	push   $0x804c38
  802500:	68 57 01 00 00       	push   $0x157
  802505:	68 ec 4b 80 00       	push   $0x804bec
  80250a:	e8 97 df ff ff       	call   8004a6 <_panic>
  80250f:	8b 15 34 d1 81 00    	mov    0x81d134,%edx
  802515:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802518:	89 50 0c             	mov    %edx,0xc(%eax)
  80251b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80251e:	8b 40 0c             	mov    0xc(%eax),%eax
  802521:	85 c0                	test   %eax,%eax
  802523:	74 0d                	je     802532 <smalloc+0x117>
  802525:	a1 34 d1 81 00       	mov    0x81d134,%eax
  80252a:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80252d:	89 50 08             	mov    %edx,0x8(%eax)
  802530:	eb 08                	jmp    80253a <smalloc+0x11f>
  802532:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802535:	a3 30 d1 81 00       	mov    %eax,0x81d130
  80253a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80253d:	a3 34 d1 81 00       	mov    %eax,0x81d134
  802542:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802545:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  80254c:	a1 3c d1 81 00       	mov    0x81d13c,%eax
  802551:	40                   	inc    %eax
  802552:	a3 3c d1 81 00       	mov    %eax,0x81d13c


						int result = sys_create_shared_object(sharedVarName ,size ,isWritable ,(void*)allocblock->startva);
  802557:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80255a:	8b 00                	mov    (%eax),%eax
  80255c:	89 c2                	mov    %eax,%edx
  80255e:	0f b6 45 c4          	movzbl -0x3c(%ebp),%eax
  802562:	52                   	push   %edx
  802563:	50                   	push   %eax
  802564:	ff 75 0c             	pushl  0xc(%ebp)
  802567:	ff 75 08             	pushl  0x8(%ebp)
  80256a:	e8 48 0c 00 00       	call   8031b7 <sys_create_shared_object>
  80256f:	83 c4 10             	add    $0x10,%esp
  802572:	89 45 d0             	mov    %eax,-0x30(%ebp)

						if(result <0){
  802575:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  802579:	79 28                	jns    8025a3 <smalloc+0x188>
							free_block(allocblock);
  80257b:	83 ec 0c             	sub    $0xc,%esp
  80257e:	ff 75 ec             	pushl  -0x14(%ebp)
  802581:	e8 cf 16 00 00       	call   803c55 <free_block>
  802586:	83 c4 10             	add    $0x10,%esp
							release_uspinlock(&ulock);
  802589:	83 ec 0c             	sub    $0xc,%esp
  80258c:	68 40 d1 81 00       	push   $0x81d140
  802591:	e8 e3 1a 00 00       	call   804079 <release_uspinlock>
  802596:	83 c4 10             	add    $0x10,%esp
							return NULL;
  802599:	b8 00 00 00 00       	mov    $0x0,%eax
  80259e:	e9 1d 04 00 00       	jmp    8029c0 <smalloc+0x5a5>
						}
						release_uspinlock(&ulock);
  8025a3:	83 ec 0c             	sub    $0xc,%esp
  8025a6:	68 40 d1 81 00       	push   $0x81d140
  8025ab:	e8 c9 1a 00 00       	call   804079 <release_uspinlock>
  8025b0:	83 c4 10             	add    $0x10,%esp
						return (void*)allocblock -> startva;
  8025b3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025b6:	8b 00                	mov    (%eax),%eax
  8025b8:	e9 03 04 00 00       	jmp    8029c0 <smalloc+0x5a5>
				}else{
						release_uspinlock(&ulock);
  8025bd:	83 ec 0c             	sub    $0xc,%esp
  8025c0:	68 40 d1 81 00       	push   $0x81d140
  8025c5:	e8 af 1a 00 00       	call   804079 <release_uspinlock>
  8025ca:	83 c4 10             	add    $0x10,%esp
						return NULL;
  8025cd:	b8 00 00 00 00       	mov    $0x0,%eax
  8025d2:	e9 e9 03 00 00       	jmp    8029c0 <smalloc+0x5a5>
					 }
		}else{
			//custom fit
			struct UserHeapStruct* currentfreeelement = LIST_FIRST(&u_freelist);
  8025d7:	a1 20 d1 81 00       	mov    0x81d120,%eax
  8025dc:	89 45 f4             	mov    %eax,-0xc(%ebp)
			//worst fit
			while(currentfreeelement != NULL){
  8025df:	e9 af 03 00 00       	jmp    802993 <smalloc+0x578>
				if(size<currentfreeelement->size){
  8025e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025e7:	8b 40 04             	mov    0x4(%eax),%eax
  8025ea:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8025ed:	0f 86 28 02 00 00    	jbe    80281b <smalloc+0x400>
					allocblock->startva = lastfreeelement->startva;
  8025f3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8025f6:	8b 10                	mov    (%eax),%edx
  8025f8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025fb:	89 10                	mov    %edx,(%eax)
	                allocblock->size = size;
  8025fd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802600:	8b 55 0c             	mov    0xc(%ebp),%edx
  802603:	89 50 04             	mov    %edx,0x4(%eax)
	                LIST_INSERT_TAIL(&u_allocatedlist,allocblock);
  802606:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80260a:	75 17                	jne    802623 <smalloc+0x208>
  80260c:	83 ec 04             	sub    $0x4,%esp
  80260f:	68 38 4c 80 00       	push   $0x804c38
  802614:	68 6f 01 00 00       	push   $0x16f
  802619:	68 ec 4b 80 00       	push   $0x804bec
  80261e:	e8 83 de ff ff       	call   8004a6 <_panic>
  802623:	8b 15 34 d1 81 00    	mov    0x81d134,%edx
  802629:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80262c:	89 50 0c             	mov    %edx,0xc(%eax)
  80262f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802632:	8b 40 0c             	mov    0xc(%eax),%eax
  802635:	85 c0                	test   %eax,%eax
  802637:	74 0d                	je     802646 <smalloc+0x22b>
  802639:	a1 34 d1 81 00       	mov    0x81d134,%eax
  80263e:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802641:	89 50 08             	mov    %edx,0x8(%eax)
  802644:	eb 08                	jmp    80264e <smalloc+0x233>
  802646:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802649:	a3 30 d1 81 00       	mov    %eax,0x81d130
  80264e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802651:	a3 34 d1 81 00       	mov    %eax,0x81d134
  802656:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802659:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802660:	a1 3c d1 81 00       	mov    0x81d13c,%eax
  802665:	40                   	inc    %eax
  802666:	a3 3c d1 81 00       	mov    %eax,0x81d13c
	                lastfreeelement->startva += size;
  80266b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80266e:	8b 10                	mov    (%eax),%edx
  802670:	8b 45 0c             	mov    0xc(%ebp),%eax
  802673:	01 c2                	add    %eax,%edx
  802675:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802678:	89 10                	mov    %edx,(%eax)
	                lastfreeelement->size -= size;
  80267a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80267d:	8b 40 04             	mov    0x4(%eax),%eax
  802680:	2b 45 0c             	sub    0xc(%ebp),%eax
  802683:	89 c2                	mov    %eax,%edx
  802685:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802688:	89 50 04             	mov    %edx,0x4(%eax)
	                struct UserHeapStruct* currentfree2 = LIST_FIRST(&u_freelist);
  80268b:	a1 20 d1 81 00       	mov    0x81d120,%eax
  802690:	89 45 f0             	mov    %eax,-0x10(%ebp)
	                //check order of last element

	                while (currentfree2 != NULL){
  802693:	e9 13 01 00 00       	jmp    8027ab <smalloc+0x390>
	                	if(lastfreeelement->size <currentfree2->size){
  802698:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80269b:	8b 50 04             	mov    0x4(%eax),%edx
  80269e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026a1:	8b 40 04             	mov    0x4(%eax),%eax
  8026a4:	39 c2                	cmp    %eax,%edx
  8026a6:	0f 83 f6 00 00 00    	jae    8027a2 <smalloc+0x387>
	                		LIST_REMOVE(&u_freelist ,lastfreeelement);
  8026ac:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8026b0:	75 17                	jne    8026c9 <smalloc+0x2ae>
  8026b2:	83 ec 04             	sub    $0x4,%esp
  8026b5:	68 5b 4c 80 00       	push   $0x804c5b
  8026ba:	68 77 01 00 00       	push   $0x177
  8026bf:	68 ec 4b 80 00       	push   $0x804bec
  8026c4:	e8 dd dd ff ff       	call   8004a6 <_panic>
  8026c9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8026cc:	8b 40 08             	mov    0x8(%eax),%eax
  8026cf:	85 c0                	test   %eax,%eax
  8026d1:	74 11                	je     8026e4 <smalloc+0x2c9>
  8026d3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8026d6:	8b 40 08             	mov    0x8(%eax),%eax
  8026d9:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8026dc:	8b 52 0c             	mov    0xc(%edx),%edx
  8026df:	89 50 0c             	mov    %edx,0xc(%eax)
  8026e2:	eb 0b                	jmp    8026ef <smalloc+0x2d4>
  8026e4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8026e7:	8b 40 0c             	mov    0xc(%eax),%eax
  8026ea:	a3 24 d1 81 00       	mov    %eax,0x81d124
  8026ef:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8026f2:	8b 40 0c             	mov    0xc(%eax),%eax
  8026f5:	85 c0                	test   %eax,%eax
  8026f7:	74 11                	je     80270a <smalloc+0x2ef>
  8026f9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8026fc:	8b 40 0c             	mov    0xc(%eax),%eax
  8026ff:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802702:	8b 52 08             	mov    0x8(%edx),%edx
  802705:	89 50 08             	mov    %edx,0x8(%eax)
  802708:	eb 0b                	jmp    802715 <smalloc+0x2fa>
  80270a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80270d:	8b 40 08             	mov    0x8(%eax),%eax
  802710:	a3 20 d1 81 00       	mov    %eax,0x81d120
  802715:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802718:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  80271f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802722:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  802729:	a1 2c d1 81 00       	mov    0x81d12c,%eax
  80272e:	48                   	dec    %eax
  80272f:	a3 2c d1 81 00       	mov    %eax,0x81d12c
	                		LIST_INSERT_BEFORE(&u_freelist ,currentfree2 ,lastfreeelement);
  802734:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802738:	74 06                	je     802740 <smalloc+0x325>
  80273a:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80273e:	75 17                	jne    802757 <smalloc+0x33c>
  802740:	83 ec 04             	sub    $0x4,%esp
  802743:	68 7c 4c 80 00       	push   $0x804c7c
  802748:	68 78 01 00 00       	push   $0x178
  80274d:	68 ec 4b 80 00       	push   $0x804bec
  802752:	e8 4f dd ff ff       	call   8004a6 <_panic>
  802757:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80275a:	8b 50 0c             	mov    0xc(%eax),%edx
  80275d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802760:	89 50 0c             	mov    %edx,0xc(%eax)
  802763:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802766:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802769:	89 50 08             	mov    %edx,0x8(%eax)
  80276c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80276f:	8b 40 0c             	mov    0xc(%eax),%eax
  802772:	85 c0                	test   %eax,%eax
  802774:	74 0e                	je     802784 <smalloc+0x369>
  802776:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802779:	8b 40 0c             	mov    0xc(%eax),%eax
  80277c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80277f:	89 50 08             	mov    %edx,0x8(%eax)
  802782:	eb 08                	jmp    80278c <smalloc+0x371>
  802784:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802787:	a3 20 d1 81 00       	mov    %eax,0x81d120
  80278c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80278f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802792:	89 50 0c             	mov    %edx,0xc(%eax)
  802795:	a1 2c d1 81 00       	mov    0x81d12c,%eax
  80279a:	40                   	inc    %eax
  80279b:	a3 2c d1 81 00       	mov    %eax,0x81d12c
	                		break;
  8027a0:	eb 13                	jmp    8027b5 <smalloc+0x39a>
	                	}
	                	currentfree2 = currentfree2->prev_next_info.le_next;
  8027a2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027a5:	8b 40 08             	mov    0x8(%eax),%eax
  8027a8:	89 45 f0             	mov    %eax,-0x10(%ebp)
	                lastfreeelement->startva += size;
	                lastfreeelement->size -= size;
	                struct UserHeapStruct* currentfree2 = LIST_FIRST(&u_freelist);
	                //check order of last element

	                while (currentfree2 != NULL){
  8027ab:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8027af:	0f 85 e3 fe ff ff    	jne    802698 <smalloc+0x27d>
	                	}
	                	currentfree2 = currentfree2->prev_next_info.le_next;
	                }


	                int result = sys_create_shared_object(sharedVarName ,size ,isWritable ,(void*)allocblock->startva);
  8027b5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027b8:	8b 00                	mov    (%eax),%eax
  8027ba:	89 c2                	mov    %eax,%edx
  8027bc:	0f b6 45 c4          	movzbl -0x3c(%ebp),%eax
  8027c0:	52                   	push   %edx
  8027c1:	50                   	push   %eax
  8027c2:	ff 75 0c             	pushl  0xc(%ebp)
  8027c5:	ff 75 08             	pushl  0x8(%ebp)
  8027c8:	e8 ea 09 00 00       	call   8031b7 <sys_create_shared_object>
  8027cd:	83 c4 10             	add    $0x10,%esp
  8027d0:	89 45 d8             	mov    %eax,-0x28(%ebp)

	                if(result <0){
  8027d3:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8027d7:	79 28                	jns    802801 <smalloc+0x3e6>
	                	free_block(allocblock);
  8027d9:	83 ec 0c             	sub    $0xc,%esp
  8027dc:	ff 75 ec             	pushl  -0x14(%ebp)
  8027df:	e8 71 14 00 00       	call   803c55 <free_block>
  8027e4:	83 c4 10             	add    $0x10,%esp
	                	release_uspinlock(&ulock);
  8027e7:	83 ec 0c             	sub    $0xc,%esp
  8027ea:	68 40 d1 81 00       	push   $0x81d140
  8027ef:	e8 85 18 00 00       	call   804079 <release_uspinlock>
  8027f4:	83 c4 10             	add    $0x10,%esp
	                	return NULL;
  8027f7:	b8 00 00 00 00       	mov    $0x0,%eax
  8027fc:	e9 bf 01 00 00       	jmp    8029c0 <smalloc+0x5a5>
	                }
	                release_uspinlock(&ulock);
  802801:	83 ec 0c             	sub    $0xc,%esp
  802804:	68 40 d1 81 00       	push   $0x81d140
  802809:	e8 6b 18 00 00       	call   804079 <release_uspinlock>
  80280e:	83 c4 10             	add    $0x10,%esp
	                return (void*)allocblock->startva;
  802811:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802814:	8b 00                	mov    (%eax),%eax
  802816:	e9 a5 01 00 00       	jmp    8029c0 <smalloc+0x5a5>
	                //exact fit
				}else if(size == currentfreeelement->size){
  80281b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80281e:	8b 40 04             	mov    0x4(%eax),%eax
  802821:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802824:	0f 85 60 01 00 00    	jne    80298a <smalloc+0x56f>
					allocblock->startva = currentfreeelement->startva;
  80282a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80282d:	8b 10                	mov    (%eax),%edx
  80282f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802832:	89 10                	mov    %edx,(%eax)
					allocblock->size = size;
  802834:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802837:	8b 55 0c             	mov    0xc(%ebp),%edx
  80283a:	89 50 04             	mov    %edx,0x4(%eax)
					LIST_INSERT_TAIL(&u_allocatedlist ,allocblock);
  80283d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802841:	75 17                	jne    80285a <smalloc+0x43f>
  802843:	83 ec 04             	sub    $0x4,%esp
  802846:	68 38 4c 80 00       	push   $0x804c38
  80284b:	68 8c 01 00 00       	push   $0x18c
  802850:	68 ec 4b 80 00       	push   $0x804bec
  802855:	e8 4c dc ff ff       	call   8004a6 <_panic>
  80285a:	8b 15 34 d1 81 00    	mov    0x81d134,%edx
  802860:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802863:	89 50 0c             	mov    %edx,0xc(%eax)
  802866:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802869:	8b 40 0c             	mov    0xc(%eax),%eax
  80286c:	85 c0                	test   %eax,%eax
  80286e:	74 0d                	je     80287d <smalloc+0x462>
  802870:	a1 34 d1 81 00       	mov    0x81d134,%eax
  802875:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802878:	89 50 08             	mov    %edx,0x8(%eax)
  80287b:	eb 08                	jmp    802885 <smalloc+0x46a>
  80287d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802880:	a3 30 d1 81 00       	mov    %eax,0x81d130
  802885:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802888:	a3 34 d1 81 00       	mov    %eax,0x81d134
  80288d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802890:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802897:	a1 3c d1 81 00       	mov    0x81d13c,%eax
  80289c:	40                   	inc    %eax
  80289d:	a3 3c d1 81 00       	mov    %eax,0x81d13c
					LIST_REMOVE(&u_freelist ,currentfreeelement);
  8028a2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028a6:	75 17                	jne    8028bf <smalloc+0x4a4>
  8028a8:	83 ec 04             	sub    $0x4,%esp
  8028ab:	68 5b 4c 80 00       	push   $0x804c5b
  8028b0:	68 8d 01 00 00       	push   $0x18d
  8028b5:	68 ec 4b 80 00       	push   $0x804bec
  8028ba:	e8 e7 db ff ff       	call   8004a6 <_panic>
  8028bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028c2:	8b 40 08             	mov    0x8(%eax),%eax
  8028c5:	85 c0                	test   %eax,%eax
  8028c7:	74 11                	je     8028da <smalloc+0x4bf>
  8028c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028cc:	8b 40 08             	mov    0x8(%eax),%eax
  8028cf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028d2:	8b 52 0c             	mov    0xc(%edx),%edx
  8028d5:	89 50 0c             	mov    %edx,0xc(%eax)
  8028d8:	eb 0b                	jmp    8028e5 <smalloc+0x4ca>
  8028da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028dd:	8b 40 0c             	mov    0xc(%eax),%eax
  8028e0:	a3 24 d1 81 00       	mov    %eax,0x81d124
  8028e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028e8:	8b 40 0c             	mov    0xc(%eax),%eax
  8028eb:	85 c0                	test   %eax,%eax
  8028ed:	74 11                	je     802900 <smalloc+0x4e5>
  8028ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028f2:	8b 40 0c             	mov    0xc(%eax),%eax
  8028f5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028f8:	8b 52 08             	mov    0x8(%edx),%edx
  8028fb:	89 50 08             	mov    %edx,0x8(%eax)
  8028fe:	eb 0b                	jmp    80290b <smalloc+0x4f0>
  802900:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802903:	8b 40 08             	mov    0x8(%eax),%eax
  802906:	a3 20 d1 81 00       	mov    %eax,0x81d120
  80290b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80290e:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802915:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802918:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  80291f:	a1 2c d1 81 00       	mov    0x81d12c,%eax
  802924:	48                   	dec    %eax
  802925:	a3 2c d1 81 00       	mov    %eax,0x81d12c
					int result = sys_create_shared_object(sharedVarName ,size ,isWritable ,(void*)allocblock->startva);
  80292a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80292d:	8b 00                	mov    (%eax),%eax
  80292f:	89 c2                	mov    %eax,%edx
  802931:	0f b6 45 c4          	movzbl -0x3c(%ebp),%eax
  802935:	52                   	push   %edx
  802936:	50                   	push   %eax
  802937:	ff 75 0c             	pushl  0xc(%ebp)
  80293a:	ff 75 08             	pushl  0x8(%ebp)
  80293d:	e8 75 08 00 00       	call   8031b7 <sys_create_shared_object>
  802942:	83 c4 10             	add    $0x10,%esp
  802945:	89 45 dc             	mov    %eax,-0x24(%ebp)

					if(result <0){
  802948:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80294c:	79 25                	jns    802973 <smalloc+0x558>
						free_block(allocblock);
  80294e:	83 ec 0c             	sub    $0xc,%esp
  802951:	ff 75 ec             	pushl  -0x14(%ebp)
  802954:	e8 fc 12 00 00       	call   803c55 <free_block>
  802959:	83 c4 10             	add    $0x10,%esp
						release_uspinlock(&ulock);
  80295c:	83 ec 0c             	sub    $0xc,%esp
  80295f:	68 40 d1 81 00       	push   $0x81d140
  802964:	e8 10 17 00 00       	call   804079 <release_uspinlock>
  802969:	83 c4 10             	add    $0x10,%esp
						return NULL;
  80296c:	b8 00 00 00 00       	mov    $0x0,%eax
  802971:	eb 4d                	jmp    8029c0 <smalloc+0x5a5>
					}
					release_uspinlock(&ulock);
  802973:	83 ec 0c             	sub    $0xc,%esp
  802976:	68 40 d1 81 00       	push   $0x81d140
  80297b:	e8 f9 16 00 00       	call   804079 <release_uspinlock>
  802980:	83 c4 10             	add    $0x10,%esp
					return (void*)allocblock->startva;
  802983:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802986:	8b 00                	mov    (%eax),%eax
  802988:	eb 36                	jmp    8029c0 <smalloc+0x5a5>
				}
				currentfreeelement = currentfreeelement->prev_next_info.le_next;
  80298a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80298d:	8b 40 08             	mov    0x8(%eax),%eax
  802990:	89 45 f4             	mov    %eax,-0xc(%ebp)
					 }
		}else{
			//custom fit
			struct UserHeapStruct* currentfreeelement = LIST_FIRST(&u_freelist);
			//worst fit
			while(currentfreeelement != NULL){
  802993:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802997:	0f 85 47 fc ff ff    	jne    8025e4 <smalloc+0x1c9>
					return (void*)allocblock->startva;
				}
				currentfreeelement = currentfreeelement->prev_next_info.le_next;
			}
		}
		free_block(allocblock);
  80299d:	83 ec 0c             	sub    $0xc,%esp
  8029a0:	ff 75 ec             	pushl  -0x14(%ebp)
  8029a3:	e8 ad 12 00 00       	call   803c55 <free_block>
  8029a8:	83 c4 10             	add    $0x10,%esp
		release_uspinlock(&ulock);
  8029ab:	83 ec 0c             	sub    $0xc,%esp
  8029ae:	68 40 d1 81 00       	push   $0x81d140
  8029b3:	e8 c1 16 00 00       	call   804079 <release_uspinlock>
  8029b8:	83 c4 10             	add    $0x10,%esp
		return NULL;
  8029bb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8029c0:	c9                   	leave  
  8029c1:	c3                   	ret    

008029c2 <sget>:

//========================================
// [4] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8029c2:	55                   	push   %ebp
  8029c3:	89 e5                	mov    %esp,%ebp
  8029c5:	83 ec 38             	sub    $0x38,%esp


	 //==============================================================
	 // DON'T CHANGE THIS CODE
	    uheap_init();
  8029c8:	e8 8c ec ff ff       	call   801659 <uheap_init>
	 //==============================================================
	 // Get size of the shared variable from kernel
	acquire_uspinlock(&ulock);
  8029cd:	83 ec 0c             	sub    $0xc,%esp
  8029d0:	68 40 d1 81 00       	push   $0x81d140
  8029d5:	e8 47 16 00 00       	call   804021 <acquire_uspinlock>
  8029da:	83 c4 10             	add    $0x10,%esp


	int size = sys_size_of_shared_object(ownerEnvID ,sharedVarName);
  8029dd:	83 ec 08             	sub    $0x8,%esp
  8029e0:	ff 75 0c             	pushl  0xc(%ebp)
  8029e3:	ff 75 08             	pushl  0x8(%ebp)
  8029e6:	e8 f6 07 00 00       	call   8031e1 <sys_size_of_shared_object>
  8029eb:	83 c4 10             	add    $0x10,%esp
  8029ee:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if ( size < 0 ){
  8029f1:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8029f5:	79 1a                	jns    802a11 <sget+0x4f>
			release_uspinlock(&ulock);
  8029f7:	83 ec 0c             	sub    $0xc,%esp
  8029fa:	68 40 d1 81 00       	push   $0x81d140
  8029ff:	e8 75 16 00 00       	call   804079 <release_uspinlock>
  802a04:	83 c4 10             	add    $0x10,%esp
			return NULL;
  802a07:	b8 00 00 00 00       	mov    $0x0,%eax
  802a0c:	e9 6e 05 00 00       	jmp    802f7f <sget+0x5bd>
		}
		size = ROUNDUP(size,PAGE_SIZE);
  802a11:	c7 45 e8 00 10 00 00 	movl   $0x1000,-0x18(%ebp)
  802a18:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802a1b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a1e:	01 d0                	add    %edx,%eax
  802a20:	48                   	dec    %eax
  802a21:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  802a24:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802a27:	ba 00 00 00 00       	mov    $0x0,%edx
  802a2c:	f7 75 e8             	divl   -0x18(%ebp)
  802a2f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802a32:	29 d0                	sub    %edx,%eax
  802a34:	89 45 ec             	mov    %eax,-0x14(%ebp)

		struct UserHeapStruct* allocblock = (struct UserHeapStruct*) alloc_block(sizeof(struct UserHeapStruct));
  802a37:	83 ec 0c             	sub    $0xc,%esp
  802a3a:	6a 10                	push   $0x10
  802a3c:	e8 78 0d 00 00       	call   8037b9 <alloc_block>
  802a41:	83 c4 10             	add    $0x10,%esp
  802a44:	89 45 e0             	mov    %eax,-0x20(%ebp)

		if (allocblock == NULL){
  802a47:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802a4b:	75 0a                	jne    802a57 <sget+0x95>
			return NULL;
  802a4d:	b8 00 00 00 00       	mov    $0x0,%eax
  802a52:	e9 28 05 00 00       	jmp    802f7f <sget+0x5bd>
		}
		struct UserHeapStruct* lastfreeelement = LIST_LAST(&u_freelist);
  802a57:	a1 24 d1 81 00       	mov    0x81d124,%eax
  802a5c:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if(LIST_SIZE(&u_freelist)==0 || size>lastfreeelement->size){
  802a5f:	a1 2c d1 81 00       	mov    0x81d12c,%eax
  802a64:	85 c0                	test   %eax,%eax
  802a66:	74 11                	je     802a79 <sget+0xb7>
  802a68:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802a6b:	8b 50 04             	mov    0x4(%eax),%edx
  802a6e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a71:	39 c2                	cmp    %eax,%edx
  802a73:	0f 83 21 01 00 00    	jae    802b9a <sget+0x1d8>
				if(uheapPageAllocBreak <= USER_HEAP_MAX - size){
  802a79:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a7c:	ba 00 00 00 a0       	mov    $0xa0000000,%edx
  802a81:	29 c2                	sub    %eax,%edx
  802a83:	a1 68 d0 81 00       	mov    0x81d068,%eax
  802a88:	39 c2                	cmp    %eax,%edx
  802a8a:	0f 82 f0 00 00 00    	jb     802b80 <sget+0x1be>

						uint32 requestedblockva = uheapPageAllocBreak;
  802a90:	a1 68 d0 81 00       	mov    0x81d068,%eax
  802a95:	89 45 d0             	mov    %eax,-0x30(%ebp)
						uheapPageAllocBreak+=size;
  802a98:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  802a9e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802aa1:	01 d0                	add    %edx,%eax
  802aa3:	a3 68 d0 81 00       	mov    %eax,0x81d068
						allocblock->startva = requestedblockva;
  802aa8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802aab:	8b 55 d0             	mov    -0x30(%ebp),%edx
  802aae:	89 10                	mov    %edx,(%eax)
						allocblock->size = size;
  802ab0:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802ab3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802ab6:	89 50 04             	mov    %edx,0x4(%eax)

						LIST_INSERT_TAIL(&u_allocatedlist, allocblock);
  802ab9:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802abd:	75 17                	jne    802ad6 <sget+0x114>
  802abf:	83 ec 04             	sub    $0x4,%esp
  802ac2:	68 38 4c 80 00       	push   $0x804c38
  802ac7:	68 c8 01 00 00       	push   $0x1c8
  802acc:	68 ec 4b 80 00       	push   $0x804bec
  802ad1:	e8 d0 d9 ff ff       	call   8004a6 <_panic>
  802ad6:	8b 15 34 d1 81 00    	mov    0x81d134,%edx
  802adc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802adf:	89 50 0c             	mov    %edx,0xc(%eax)
  802ae2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802ae5:	8b 40 0c             	mov    0xc(%eax),%eax
  802ae8:	85 c0                	test   %eax,%eax
  802aea:	74 0d                	je     802af9 <sget+0x137>
  802aec:	a1 34 d1 81 00       	mov    0x81d134,%eax
  802af1:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802af4:	89 50 08             	mov    %edx,0x8(%eax)
  802af7:	eb 08                	jmp    802b01 <sget+0x13f>
  802af9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802afc:	a3 30 d1 81 00       	mov    %eax,0x81d130
  802b01:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802b04:	a3 34 d1 81 00       	mov    %eax,0x81d134
  802b09:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802b0c:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802b13:	a1 3c d1 81 00       	mov    0x81d13c,%eax
  802b18:	40                   	inc    %eax
  802b19:	a3 3c d1 81 00       	mov    %eax,0x81d13c


						int result = sys_get_shared_object(ownerEnvID ,sharedVarName ,(void*)allocblock->startva);
  802b1e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802b21:	8b 00                	mov    (%eax),%eax
  802b23:	83 ec 04             	sub    $0x4,%esp
  802b26:	50                   	push   %eax
  802b27:	ff 75 0c             	pushl  0xc(%ebp)
  802b2a:	ff 75 08             	pushl  0x8(%ebp)
  802b2d:	e8 cc 06 00 00       	call   8031fe <sys_get_shared_object>
  802b32:	83 c4 10             	add    $0x10,%esp
  802b35:	89 45 cc             	mov    %eax,-0x34(%ebp)

						if(result <0){
  802b38:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802b3c:	79 28                	jns    802b66 <sget+0x1a4>
							free_block(allocblock);
  802b3e:	83 ec 0c             	sub    $0xc,%esp
  802b41:	ff 75 e0             	pushl  -0x20(%ebp)
  802b44:	e8 0c 11 00 00       	call   803c55 <free_block>
  802b49:	83 c4 10             	add    $0x10,%esp
							release_uspinlock(&ulock);
  802b4c:	83 ec 0c             	sub    $0xc,%esp
  802b4f:	68 40 d1 81 00       	push   $0x81d140
  802b54:	e8 20 15 00 00       	call   804079 <release_uspinlock>
  802b59:	83 c4 10             	add    $0x10,%esp
							return NULL;
  802b5c:	b8 00 00 00 00       	mov    $0x0,%eax
  802b61:	e9 19 04 00 00       	jmp    802f7f <sget+0x5bd>
						}
						release_uspinlock(&ulock);
  802b66:	83 ec 0c             	sub    $0xc,%esp
  802b69:	68 40 d1 81 00       	push   $0x81d140
  802b6e:	e8 06 15 00 00       	call   804079 <release_uspinlock>
  802b73:	83 c4 10             	add    $0x10,%esp
						return (void*)allocblock -> startva;
  802b76:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802b79:	8b 00                	mov    (%eax),%eax
  802b7b:	e9 ff 03 00 00       	jmp    802f7f <sget+0x5bd>
				}else{
						release_uspinlock(&ulock);
  802b80:	83 ec 0c             	sub    $0xc,%esp
  802b83:	68 40 d1 81 00       	push   $0x81d140
  802b88:	e8 ec 14 00 00       	call   804079 <release_uspinlock>
  802b8d:	83 c4 10             	add    $0x10,%esp
						return NULL;
  802b90:	b8 00 00 00 00       	mov    $0x0,%eax
  802b95:	e9 e5 03 00 00       	jmp    802f7f <sget+0x5bd>
					 }
		}else{
			//custom fit
			struct UserHeapStruct* currentfreeelement = LIST_FIRST(&u_freelist);
  802b9a:	a1 20 d1 81 00       	mov    0x81d120,%eax
  802b9f:	89 45 f4             	mov    %eax,-0xc(%ebp)
			//worst fit
			while(currentfreeelement != NULL){
  802ba2:	e9 ab 03 00 00       	jmp    802f52 <sget+0x590>
				if(size<currentfreeelement->size){
  802ba7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802baa:	8b 50 04             	mov    0x4(%eax),%edx
  802bad:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bb0:	39 c2                	cmp    %eax,%edx
  802bb2:	0f 86 24 02 00 00    	jbe    802ddc <sget+0x41a>
					allocblock->startva = lastfreeelement->startva;
  802bb8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802bbb:	8b 10                	mov    (%eax),%edx
  802bbd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802bc0:	89 10                	mov    %edx,(%eax)
					allocblock->size = size;
  802bc2:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802bc5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802bc8:	89 50 04             	mov    %edx,0x4(%eax)
					LIST_INSERT_TAIL(&u_allocatedlist,allocblock);
  802bcb:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802bcf:	75 17                	jne    802be8 <sget+0x226>
  802bd1:	83 ec 04             	sub    $0x4,%esp
  802bd4:	68 38 4c 80 00       	push   $0x804c38
  802bd9:	68 e0 01 00 00       	push   $0x1e0
  802bde:	68 ec 4b 80 00       	push   $0x804bec
  802be3:	e8 be d8 ff ff       	call   8004a6 <_panic>
  802be8:	8b 15 34 d1 81 00    	mov    0x81d134,%edx
  802bee:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802bf1:	89 50 0c             	mov    %edx,0xc(%eax)
  802bf4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802bf7:	8b 40 0c             	mov    0xc(%eax),%eax
  802bfa:	85 c0                	test   %eax,%eax
  802bfc:	74 0d                	je     802c0b <sget+0x249>
  802bfe:	a1 34 d1 81 00       	mov    0x81d134,%eax
  802c03:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802c06:	89 50 08             	mov    %edx,0x8(%eax)
  802c09:	eb 08                	jmp    802c13 <sget+0x251>
  802c0b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802c0e:	a3 30 d1 81 00       	mov    %eax,0x81d130
  802c13:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802c16:	a3 34 d1 81 00       	mov    %eax,0x81d134
  802c1b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802c1e:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802c25:	a1 3c d1 81 00       	mov    0x81d13c,%eax
  802c2a:	40                   	inc    %eax
  802c2b:	a3 3c d1 81 00       	mov    %eax,0x81d13c
					lastfreeelement->startva += size;
  802c30:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802c33:	8b 10                	mov    (%eax),%edx
  802c35:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c38:	01 c2                	add    %eax,%edx
  802c3a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802c3d:	89 10                	mov    %edx,(%eax)
					lastfreeelement->size -= size;
  802c3f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802c42:	8b 50 04             	mov    0x4(%eax),%edx
  802c45:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c48:	29 c2                	sub    %eax,%edx
  802c4a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802c4d:	89 50 04             	mov    %edx,0x4(%eax)
					struct UserHeapStruct* currentfree2 = LIST_FIRST(&u_freelist);
  802c50:	a1 20 d1 81 00       	mov    0x81d120,%eax
  802c55:	89 45 f0             	mov    %eax,-0x10(%ebp)
					//check order of last element

					while (currentfree2 != NULL){
  802c58:	e9 13 01 00 00       	jmp    802d70 <sget+0x3ae>
						if(lastfreeelement->size <currentfree2->size){
  802c5d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802c60:	8b 50 04             	mov    0x4(%eax),%edx
  802c63:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c66:	8b 40 04             	mov    0x4(%eax),%eax
  802c69:	39 c2                	cmp    %eax,%edx
  802c6b:	0f 83 f6 00 00 00    	jae    802d67 <sget+0x3a5>
							LIST_REMOVE(&u_freelist ,lastfreeelement);
  802c71:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802c75:	75 17                	jne    802c8e <sget+0x2cc>
  802c77:	83 ec 04             	sub    $0x4,%esp
  802c7a:	68 5b 4c 80 00       	push   $0x804c5b
  802c7f:	68 e8 01 00 00       	push   $0x1e8
  802c84:	68 ec 4b 80 00       	push   $0x804bec
  802c89:	e8 18 d8 ff ff       	call   8004a6 <_panic>
  802c8e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802c91:	8b 40 08             	mov    0x8(%eax),%eax
  802c94:	85 c0                	test   %eax,%eax
  802c96:	74 11                	je     802ca9 <sget+0x2e7>
  802c98:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802c9b:	8b 40 08             	mov    0x8(%eax),%eax
  802c9e:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802ca1:	8b 52 0c             	mov    0xc(%edx),%edx
  802ca4:	89 50 0c             	mov    %edx,0xc(%eax)
  802ca7:	eb 0b                	jmp    802cb4 <sget+0x2f2>
  802ca9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802cac:	8b 40 0c             	mov    0xc(%eax),%eax
  802caf:	a3 24 d1 81 00       	mov    %eax,0x81d124
  802cb4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802cb7:	8b 40 0c             	mov    0xc(%eax),%eax
  802cba:	85 c0                	test   %eax,%eax
  802cbc:	74 11                	je     802ccf <sget+0x30d>
  802cbe:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802cc1:	8b 40 0c             	mov    0xc(%eax),%eax
  802cc4:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802cc7:	8b 52 08             	mov    0x8(%edx),%edx
  802cca:	89 50 08             	mov    %edx,0x8(%eax)
  802ccd:	eb 0b                	jmp    802cda <sget+0x318>
  802ccf:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802cd2:	8b 40 08             	mov    0x8(%eax),%eax
  802cd5:	a3 20 d1 81 00       	mov    %eax,0x81d120
  802cda:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802cdd:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802ce4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802ce7:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  802cee:	a1 2c d1 81 00       	mov    0x81d12c,%eax
  802cf3:	48                   	dec    %eax
  802cf4:	a3 2c d1 81 00       	mov    %eax,0x81d12c
							LIST_INSERT_BEFORE(&u_freelist ,currentfree2 ,lastfreeelement);
  802cf9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802cfd:	74 06                	je     802d05 <sget+0x343>
  802cff:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802d03:	75 17                	jne    802d1c <sget+0x35a>
  802d05:	83 ec 04             	sub    $0x4,%esp
  802d08:	68 7c 4c 80 00       	push   $0x804c7c
  802d0d:	68 e9 01 00 00       	push   $0x1e9
  802d12:	68 ec 4b 80 00       	push   $0x804bec
  802d17:	e8 8a d7 ff ff       	call   8004a6 <_panic>
  802d1c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d1f:	8b 50 0c             	mov    0xc(%eax),%edx
  802d22:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802d25:	89 50 0c             	mov    %edx,0xc(%eax)
  802d28:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802d2b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802d2e:	89 50 08             	mov    %edx,0x8(%eax)
  802d31:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d34:	8b 40 0c             	mov    0xc(%eax),%eax
  802d37:	85 c0                	test   %eax,%eax
  802d39:	74 0e                	je     802d49 <sget+0x387>
  802d3b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d3e:	8b 40 0c             	mov    0xc(%eax),%eax
  802d41:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802d44:	89 50 08             	mov    %edx,0x8(%eax)
  802d47:	eb 08                	jmp    802d51 <sget+0x38f>
  802d49:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802d4c:	a3 20 d1 81 00       	mov    %eax,0x81d120
  802d51:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d54:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802d57:	89 50 0c             	mov    %edx,0xc(%eax)
  802d5a:	a1 2c d1 81 00       	mov    0x81d12c,%eax
  802d5f:	40                   	inc    %eax
  802d60:	a3 2c d1 81 00       	mov    %eax,0x81d12c
							break;
  802d65:	eb 13                	jmp    802d7a <sget+0x3b8>
						}
						currentfree2 = currentfree2->prev_next_info.le_next;
  802d67:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d6a:	8b 40 08             	mov    0x8(%eax),%eax
  802d6d:	89 45 f0             	mov    %eax,-0x10(%ebp)
					lastfreeelement->startva += size;
					lastfreeelement->size -= size;
					struct UserHeapStruct* currentfree2 = LIST_FIRST(&u_freelist);
					//check order of last element

					while (currentfree2 != NULL){
  802d70:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802d74:	0f 85 e3 fe ff ff    	jne    802c5d <sget+0x29b>
						}
						currentfree2 = currentfree2->prev_next_info.le_next;
					}


					int result = sys_get_shared_object(ownerEnvID ,sharedVarName ,(void*)allocblock->startva);
  802d7a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802d7d:	8b 00                	mov    (%eax),%eax
  802d7f:	83 ec 04             	sub    $0x4,%esp
  802d82:	50                   	push   %eax
  802d83:	ff 75 0c             	pushl  0xc(%ebp)
  802d86:	ff 75 08             	pushl  0x8(%ebp)
  802d89:	e8 70 04 00 00       	call   8031fe <sys_get_shared_object>
  802d8e:	83 c4 10             	add    $0x10,%esp
  802d91:	89 45 d4             	mov    %eax,-0x2c(%ebp)

					if(result <0){
  802d94:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  802d98:	79 28                	jns    802dc2 <sget+0x400>
						free_block(allocblock);
  802d9a:	83 ec 0c             	sub    $0xc,%esp
  802d9d:	ff 75 e0             	pushl  -0x20(%ebp)
  802da0:	e8 b0 0e 00 00       	call   803c55 <free_block>
  802da5:	83 c4 10             	add    $0x10,%esp
						release_uspinlock(&ulock);
  802da8:	83 ec 0c             	sub    $0xc,%esp
  802dab:	68 40 d1 81 00       	push   $0x81d140
  802db0:	e8 c4 12 00 00       	call   804079 <release_uspinlock>
  802db5:	83 c4 10             	add    $0x10,%esp
						return NULL;
  802db8:	b8 00 00 00 00       	mov    $0x0,%eax
  802dbd:	e9 bd 01 00 00       	jmp    802f7f <sget+0x5bd>
					}
					release_uspinlock(&ulock);
  802dc2:	83 ec 0c             	sub    $0xc,%esp
  802dc5:	68 40 d1 81 00       	push   $0x81d140
  802dca:	e8 aa 12 00 00       	call   804079 <release_uspinlock>
  802dcf:	83 c4 10             	add    $0x10,%esp
					return (void*)allocblock->startva;
  802dd2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802dd5:	8b 00                	mov    (%eax),%eax
  802dd7:	e9 a3 01 00 00       	jmp    802f7f <sget+0x5bd>
					//exact fit
				}else if(size == currentfreeelement->size){
  802ddc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ddf:	8b 50 04             	mov    0x4(%eax),%edx
  802de2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802de5:	39 c2                	cmp    %eax,%edx
  802de7:	0f 85 5c 01 00 00    	jne    802f49 <sget+0x587>

					allocblock->startva = currentfreeelement->startva;
  802ded:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802df0:	8b 10                	mov    (%eax),%edx
  802df2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802df5:	89 10                	mov    %edx,(%eax)
					allocblock->size = size;
  802df7:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802dfa:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802dfd:	89 50 04             	mov    %edx,0x4(%eax)
					LIST_INSERT_TAIL(&u_allocatedlist ,allocblock);
  802e00:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802e04:	75 17                	jne    802e1d <sget+0x45b>
  802e06:	83 ec 04             	sub    $0x4,%esp
  802e09:	68 38 4c 80 00       	push   $0x804c38
  802e0e:	68 fe 01 00 00       	push   $0x1fe
  802e13:	68 ec 4b 80 00       	push   $0x804bec
  802e18:	e8 89 d6 ff ff       	call   8004a6 <_panic>
  802e1d:	8b 15 34 d1 81 00    	mov    0x81d134,%edx
  802e23:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802e26:	89 50 0c             	mov    %edx,0xc(%eax)
  802e29:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802e2c:	8b 40 0c             	mov    0xc(%eax),%eax
  802e2f:	85 c0                	test   %eax,%eax
  802e31:	74 0d                	je     802e40 <sget+0x47e>
  802e33:	a1 34 d1 81 00       	mov    0x81d134,%eax
  802e38:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802e3b:	89 50 08             	mov    %edx,0x8(%eax)
  802e3e:	eb 08                	jmp    802e48 <sget+0x486>
  802e40:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802e43:	a3 30 d1 81 00       	mov    %eax,0x81d130
  802e48:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802e4b:	a3 34 d1 81 00       	mov    %eax,0x81d134
  802e50:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802e53:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802e5a:	a1 3c d1 81 00       	mov    0x81d13c,%eax
  802e5f:	40                   	inc    %eax
  802e60:	a3 3c d1 81 00       	mov    %eax,0x81d13c
					LIST_REMOVE(&u_freelist ,currentfreeelement);
  802e65:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e69:	75 17                	jne    802e82 <sget+0x4c0>
  802e6b:	83 ec 04             	sub    $0x4,%esp
  802e6e:	68 5b 4c 80 00       	push   $0x804c5b
  802e73:	68 ff 01 00 00       	push   $0x1ff
  802e78:	68 ec 4b 80 00       	push   $0x804bec
  802e7d:	e8 24 d6 ff ff       	call   8004a6 <_panic>
  802e82:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e85:	8b 40 08             	mov    0x8(%eax),%eax
  802e88:	85 c0                	test   %eax,%eax
  802e8a:	74 11                	je     802e9d <sget+0x4db>
  802e8c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e8f:	8b 40 08             	mov    0x8(%eax),%eax
  802e92:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e95:	8b 52 0c             	mov    0xc(%edx),%edx
  802e98:	89 50 0c             	mov    %edx,0xc(%eax)
  802e9b:	eb 0b                	jmp    802ea8 <sget+0x4e6>
  802e9d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ea0:	8b 40 0c             	mov    0xc(%eax),%eax
  802ea3:	a3 24 d1 81 00       	mov    %eax,0x81d124
  802ea8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eab:	8b 40 0c             	mov    0xc(%eax),%eax
  802eae:	85 c0                	test   %eax,%eax
  802eb0:	74 11                	je     802ec3 <sget+0x501>
  802eb2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eb5:	8b 40 0c             	mov    0xc(%eax),%eax
  802eb8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ebb:	8b 52 08             	mov    0x8(%edx),%edx
  802ebe:	89 50 08             	mov    %edx,0x8(%eax)
  802ec1:	eb 0b                	jmp    802ece <sget+0x50c>
  802ec3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ec6:	8b 40 08             	mov    0x8(%eax),%eax
  802ec9:	a3 20 d1 81 00       	mov    %eax,0x81d120
  802ece:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ed1:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802ed8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802edb:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  802ee2:	a1 2c d1 81 00       	mov    0x81d12c,%eax
  802ee7:	48                   	dec    %eax
  802ee8:	a3 2c d1 81 00       	mov    %eax,0x81d12c

					int result = sys_get_shared_object(ownerEnvID ,sharedVarName ,(void*)allocblock->startva);
  802eed:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802ef0:	8b 00                	mov    (%eax),%eax
  802ef2:	83 ec 04             	sub    $0x4,%esp
  802ef5:	50                   	push   %eax
  802ef6:	ff 75 0c             	pushl  0xc(%ebp)
  802ef9:	ff 75 08             	pushl  0x8(%ebp)
  802efc:	e8 fd 02 00 00       	call   8031fe <sys_get_shared_object>
  802f01:	83 c4 10             	add    $0x10,%esp
  802f04:	89 45 d8             	mov    %eax,-0x28(%ebp)
					if(result <0){
  802f07:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  802f0b:	79 25                	jns    802f32 <sget+0x570>
						free_block(allocblock);
  802f0d:	83 ec 0c             	sub    $0xc,%esp
  802f10:	ff 75 e0             	pushl  -0x20(%ebp)
  802f13:	e8 3d 0d 00 00       	call   803c55 <free_block>
  802f18:	83 c4 10             	add    $0x10,%esp
						release_uspinlock(&ulock);
  802f1b:	83 ec 0c             	sub    $0xc,%esp
  802f1e:	68 40 d1 81 00       	push   $0x81d140
  802f23:	e8 51 11 00 00       	call   804079 <release_uspinlock>
  802f28:	83 c4 10             	add    $0x10,%esp
						return NULL;
  802f2b:	b8 00 00 00 00       	mov    $0x0,%eax
  802f30:	eb 4d                	jmp    802f7f <sget+0x5bd>
					}

					release_uspinlock(&ulock);
  802f32:	83 ec 0c             	sub    $0xc,%esp
  802f35:	68 40 d1 81 00       	push   $0x81d140
  802f3a:	e8 3a 11 00 00       	call   804079 <release_uspinlock>
  802f3f:	83 c4 10             	add    $0x10,%esp
					return (void*)allocblock->startva;
  802f42:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802f45:	8b 00                	mov    (%eax),%eax
  802f47:	eb 36                	jmp    802f7f <sget+0x5bd>
				}
				currentfreeelement = currentfreeelement->prev_next_info.le_next;
  802f49:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f4c:	8b 40 08             	mov    0x8(%eax),%eax
  802f4f:	89 45 f4             	mov    %eax,-0xc(%ebp)
					 }
		}else{
			//custom fit
			struct UserHeapStruct* currentfreeelement = LIST_FIRST(&u_freelist);
			//worst fit
			while(currentfreeelement != NULL){
  802f52:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f56:	0f 85 4b fc ff ff    	jne    802ba7 <sget+0x1e5>
					return (void*)allocblock->startva;
				}
				currentfreeelement = currentfreeelement->prev_next_info.le_next;
			}
		}
		free_block(allocblock);
  802f5c:	83 ec 0c             	sub    $0xc,%esp
  802f5f:	ff 75 e0             	pushl  -0x20(%ebp)
  802f62:	e8 ee 0c 00 00       	call   803c55 <free_block>
  802f67:	83 c4 10             	add    $0x10,%esp
		release_uspinlock(&ulock);
  802f6a:	83 ec 0c             	sub    $0xc,%esp
  802f6d:	68 40 d1 81 00       	push   $0x81d140
  802f72:	e8 02 11 00 00       	call   804079 <release_uspinlock>
  802f77:	83 c4 10             	add    $0x10,%esp
		return NULL;
  802f7a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802f7f:	c9                   	leave  
  802f80:	c3                   	ret    

00802f81 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  802f81:	55                   	push   %ebp
  802f82:	89 e5                	mov    %esp,%ebp
  802f84:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  802f87:	e8 cd e6 ff ff       	call   801659 <uheap_init>
	//==============================================================
	panic("realloc() is not implemented yet...!!");
  802f8c:	83 ec 04             	sub    $0x4,%esp
  802f8f:	68 0c 4d 80 00       	push   $0x804d0c
  802f94:	68 2d 02 00 00       	push   $0x22d
  802f99:	68 ec 4b 80 00       	push   $0x804bec
  802f9e:	e8 03 d5 ff ff       	call   8004a6 <_panic>

00802fa3 <sfree>:
//
//	use sys_delete_shared_object(...); which switches to the kernel mode,
//	calls delete_shared_object(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the delete_shared_object() function is empty, make sure to implement it.
void sfree(void* virtual_address)
{
  802fa3:	55                   	push   %ebp
  802fa4:	89 e5                	mov    %esp,%ebp
  802fa6:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.BONUS#5] EXIT #2 - sfree
	//Your code is here
	//Comment the following line
	panic("sfree() is not implemented yet...!!");
  802fa9:	83 ec 04             	sub    $0x4,%esp
  802fac:	68 34 4d 80 00       	push   $0x804d34
  802fb1:	68 40 02 00 00       	push   $0x240
  802fb6:	68 ec 4b 80 00       	push   $0x804bec
  802fbb:	e8 e6 d4 ff ff       	call   8004a6 <_panic>

00802fc0 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  802fc0:	55                   	push   %ebp
  802fc1:	89 e5                	mov    %esp,%ebp
  802fc3:	57                   	push   %edi
  802fc4:	56                   	push   %esi
  802fc5:	53                   	push   %ebx
  802fc6:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  802fc9:	8b 45 08             	mov    0x8(%ebp),%eax
  802fcc:	8b 55 0c             	mov    0xc(%ebp),%edx
  802fcf:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802fd2:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802fd5:	8b 7d 18             	mov    0x18(%ebp),%edi
  802fd8:	8b 75 1c             	mov    0x1c(%ebp),%esi
  802fdb:	cd 30                	int    $0x30
  802fdd:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  802fe0:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  802fe3:	83 c4 10             	add    $0x10,%esp
  802fe6:	5b                   	pop    %ebx
  802fe7:	5e                   	pop    %esi
  802fe8:	5f                   	pop    %edi
  802fe9:	5d                   	pop    %ebp
  802fea:	c3                   	ret    

00802feb <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  802feb:	55                   	push   %ebp
  802fec:	89 e5                	mov    %esp,%ebp
  802fee:	83 ec 04             	sub    $0x4,%esp
  802ff1:	8b 45 10             	mov    0x10(%ebp),%eax
  802ff4:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  802ff7:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802ffa:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802ffe:	8b 45 08             	mov    0x8(%ebp),%eax
  803001:	6a 00                	push   $0x0
  803003:	51                   	push   %ecx
  803004:	52                   	push   %edx
  803005:	ff 75 0c             	pushl  0xc(%ebp)
  803008:	50                   	push   %eax
  803009:	6a 00                	push   $0x0
  80300b:	e8 b0 ff ff ff       	call   802fc0 <syscall>
  803010:	83 c4 18             	add    $0x18,%esp
}
  803013:	90                   	nop
  803014:	c9                   	leave  
  803015:	c3                   	ret    

00803016 <sys_cgetc>:

int
sys_cgetc(void)
{
  803016:	55                   	push   %ebp
  803017:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  803019:	6a 00                	push   $0x0
  80301b:	6a 00                	push   $0x0
  80301d:	6a 00                	push   $0x0
  80301f:	6a 00                	push   $0x0
  803021:	6a 00                	push   $0x0
  803023:	6a 02                	push   $0x2
  803025:	e8 96 ff ff ff       	call   802fc0 <syscall>
  80302a:	83 c4 18             	add    $0x18,%esp
}
  80302d:	c9                   	leave  
  80302e:	c3                   	ret    

0080302f <sys_lock_cons>:

void sys_lock_cons(void)
{
  80302f:	55                   	push   %ebp
  803030:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  803032:	6a 00                	push   $0x0
  803034:	6a 00                	push   $0x0
  803036:	6a 00                	push   $0x0
  803038:	6a 00                	push   $0x0
  80303a:	6a 00                	push   $0x0
  80303c:	6a 03                	push   $0x3
  80303e:	e8 7d ff ff ff       	call   802fc0 <syscall>
  803043:	83 c4 18             	add    $0x18,%esp
}
  803046:	90                   	nop
  803047:	c9                   	leave  
  803048:	c3                   	ret    

00803049 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  803049:	55                   	push   %ebp
  80304a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  80304c:	6a 00                	push   $0x0
  80304e:	6a 00                	push   $0x0
  803050:	6a 00                	push   $0x0
  803052:	6a 00                	push   $0x0
  803054:	6a 00                	push   $0x0
  803056:	6a 04                	push   $0x4
  803058:	e8 63 ff ff ff       	call   802fc0 <syscall>
  80305d:	83 c4 18             	add    $0x18,%esp
}
  803060:	90                   	nop
  803061:	c9                   	leave  
  803062:	c3                   	ret    

00803063 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  803063:	55                   	push   %ebp
  803064:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  803066:	8b 55 0c             	mov    0xc(%ebp),%edx
  803069:	8b 45 08             	mov    0x8(%ebp),%eax
  80306c:	6a 00                	push   $0x0
  80306e:	6a 00                	push   $0x0
  803070:	6a 00                	push   $0x0
  803072:	52                   	push   %edx
  803073:	50                   	push   %eax
  803074:	6a 08                	push   $0x8
  803076:	e8 45 ff ff ff       	call   802fc0 <syscall>
  80307b:	83 c4 18             	add    $0x18,%esp
}
  80307e:	c9                   	leave  
  80307f:	c3                   	ret    

00803080 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  803080:	55                   	push   %ebp
  803081:	89 e5                	mov    %esp,%ebp
  803083:	56                   	push   %esi
  803084:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  803085:	8b 75 18             	mov    0x18(%ebp),%esi
  803088:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80308b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80308e:	8b 55 0c             	mov    0xc(%ebp),%edx
  803091:	8b 45 08             	mov    0x8(%ebp),%eax
  803094:	56                   	push   %esi
  803095:	53                   	push   %ebx
  803096:	51                   	push   %ecx
  803097:	52                   	push   %edx
  803098:	50                   	push   %eax
  803099:	6a 09                	push   $0x9
  80309b:	e8 20 ff ff ff       	call   802fc0 <syscall>
  8030a0:	83 c4 18             	add    $0x18,%esp
}
  8030a3:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8030a6:	5b                   	pop    %ebx
  8030a7:	5e                   	pop    %esi
  8030a8:	5d                   	pop    %ebp
  8030a9:	c3                   	ret    

008030aa <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  8030aa:	55                   	push   %ebp
  8030ab:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  8030ad:	6a 00                	push   $0x0
  8030af:	6a 00                	push   $0x0
  8030b1:	6a 00                	push   $0x0
  8030b3:	6a 00                	push   $0x0
  8030b5:	ff 75 08             	pushl  0x8(%ebp)
  8030b8:	6a 0a                	push   $0xa
  8030ba:	e8 01 ff ff ff       	call   802fc0 <syscall>
  8030bf:	83 c4 18             	add    $0x18,%esp
}
  8030c2:	c9                   	leave  
  8030c3:	c3                   	ret    

008030c4 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8030c4:	55                   	push   %ebp
  8030c5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8030c7:	6a 00                	push   $0x0
  8030c9:	6a 00                	push   $0x0
  8030cb:	6a 00                	push   $0x0
  8030cd:	ff 75 0c             	pushl  0xc(%ebp)
  8030d0:	ff 75 08             	pushl  0x8(%ebp)
  8030d3:	6a 0b                	push   $0xb
  8030d5:	e8 e6 fe ff ff       	call   802fc0 <syscall>
  8030da:	83 c4 18             	add    $0x18,%esp
}
  8030dd:	c9                   	leave  
  8030de:	c3                   	ret    

008030df <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8030df:	55                   	push   %ebp
  8030e0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8030e2:	6a 00                	push   $0x0
  8030e4:	6a 00                	push   $0x0
  8030e6:	6a 00                	push   $0x0
  8030e8:	6a 00                	push   $0x0
  8030ea:	6a 00                	push   $0x0
  8030ec:	6a 0c                	push   $0xc
  8030ee:	e8 cd fe ff ff       	call   802fc0 <syscall>
  8030f3:	83 c4 18             	add    $0x18,%esp
}
  8030f6:	c9                   	leave  
  8030f7:	c3                   	ret    

008030f8 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8030f8:	55                   	push   %ebp
  8030f9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8030fb:	6a 00                	push   $0x0
  8030fd:	6a 00                	push   $0x0
  8030ff:	6a 00                	push   $0x0
  803101:	6a 00                	push   $0x0
  803103:	6a 00                	push   $0x0
  803105:	6a 0d                	push   $0xd
  803107:	e8 b4 fe ff ff       	call   802fc0 <syscall>
  80310c:	83 c4 18             	add    $0x18,%esp
}
  80310f:	c9                   	leave  
  803110:	c3                   	ret    

00803111 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  803111:	55                   	push   %ebp
  803112:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  803114:	6a 00                	push   $0x0
  803116:	6a 00                	push   $0x0
  803118:	6a 00                	push   $0x0
  80311a:	6a 00                	push   $0x0
  80311c:	6a 00                	push   $0x0
  80311e:	6a 0e                	push   $0xe
  803120:	e8 9b fe ff ff       	call   802fc0 <syscall>
  803125:	83 c4 18             	add    $0x18,%esp
}
  803128:	c9                   	leave  
  803129:	c3                   	ret    

0080312a <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  80312a:	55                   	push   %ebp
  80312b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  80312d:	6a 00                	push   $0x0
  80312f:	6a 00                	push   $0x0
  803131:	6a 00                	push   $0x0
  803133:	6a 00                	push   $0x0
  803135:	6a 00                	push   $0x0
  803137:	6a 0f                	push   $0xf
  803139:	e8 82 fe ff ff       	call   802fc0 <syscall>
  80313e:	83 c4 18             	add    $0x18,%esp
}
  803141:	c9                   	leave  
  803142:	c3                   	ret    

00803143 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  803143:	55                   	push   %ebp
  803144:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  803146:	6a 00                	push   $0x0
  803148:	6a 00                	push   $0x0
  80314a:	6a 00                	push   $0x0
  80314c:	6a 00                	push   $0x0
  80314e:	ff 75 08             	pushl  0x8(%ebp)
  803151:	6a 10                	push   $0x10
  803153:	e8 68 fe ff ff       	call   802fc0 <syscall>
  803158:	83 c4 18             	add    $0x18,%esp
}
  80315b:	c9                   	leave  
  80315c:	c3                   	ret    

0080315d <sys_scarce_memory>:

void sys_scarce_memory()
{
  80315d:	55                   	push   %ebp
  80315e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  803160:	6a 00                	push   $0x0
  803162:	6a 00                	push   $0x0
  803164:	6a 00                	push   $0x0
  803166:	6a 00                	push   $0x0
  803168:	6a 00                	push   $0x0
  80316a:	6a 11                	push   $0x11
  80316c:	e8 4f fe ff ff       	call   802fc0 <syscall>
  803171:	83 c4 18             	add    $0x18,%esp
}
  803174:	90                   	nop
  803175:	c9                   	leave  
  803176:	c3                   	ret    

00803177 <sys_cputc>:

void
sys_cputc(const char c)
{
  803177:	55                   	push   %ebp
  803178:	89 e5                	mov    %esp,%ebp
  80317a:	83 ec 04             	sub    $0x4,%esp
  80317d:	8b 45 08             	mov    0x8(%ebp),%eax
  803180:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  803183:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  803187:	6a 00                	push   $0x0
  803189:	6a 00                	push   $0x0
  80318b:	6a 00                	push   $0x0
  80318d:	6a 00                	push   $0x0
  80318f:	50                   	push   %eax
  803190:	6a 01                	push   $0x1
  803192:	e8 29 fe ff ff       	call   802fc0 <syscall>
  803197:	83 c4 18             	add    $0x18,%esp
}
  80319a:	90                   	nop
  80319b:	c9                   	leave  
  80319c:	c3                   	ret    

0080319d <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  80319d:	55                   	push   %ebp
  80319e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8031a0:	6a 00                	push   $0x0
  8031a2:	6a 00                	push   $0x0
  8031a4:	6a 00                	push   $0x0
  8031a6:	6a 00                	push   $0x0
  8031a8:	6a 00                	push   $0x0
  8031aa:	6a 14                	push   $0x14
  8031ac:	e8 0f fe ff ff       	call   802fc0 <syscall>
  8031b1:	83 c4 18             	add    $0x18,%esp
}
  8031b4:	90                   	nop
  8031b5:	c9                   	leave  
  8031b6:	c3                   	ret    

008031b7 <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8031b7:	55                   	push   %ebp
  8031b8:	89 e5                	mov    %esp,%ebp
  8031ba:	83 ec 04             	sub    $0x4,%esp
  8031bd:	8b 45 10             	mov    0x10(%ebp),%eax
  8031c0:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8031c3:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8031c6:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8031ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8031cd:	6a 00                	push   $0x0
  8031cf:	51                   	push   %ecx
  8031d0:	52                   	push   %edx
  8031d1:	ff 75 0c             	pushl  0xc(%ebp)
  8031d4:	50                   	push   %eax
  8031d5:	6a 15                	push   $0x15
  8031d7:	e8 e4 fd ff ff       	call   802fc0 <syscall>
  8031dc:	83 c4 18             	add    $0x18,%esp
}
  8031df:	c9                   	leave  
  8031e0:	c3                   	ret    

008031e1 <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  8031e1:	55                   	push   %ebp
  8031e2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8031e4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8031e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8031ea:	6a 00                	push   $0x0
  8031ec:	6a 00                	push   $0x0
  8031ee:	6a 00                	push   $0x0
  8031f0:	52                   	push   %edx
  8031f1:	50                   	push   %eax
  8031f2:	6a 16                	push   $0x16
  8031f4:	e8 c7 fd ff ff       	call   802fc0 <syscall>
  8031f9:	83 c4 18             	add    $0x18,%esp
}
  8031fc:	c9                   	leave  
  8031fd:	c3                   	ret    

008031fe <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  8031fe:	55                   	push   %ebp
  8031ff:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  803201:	8b 4d 10             	mov    0x10(%ebp),%ecx
  803204:	8b 55 0c             	mov    0xc(%ebp),%edx
  803207:	8b 45 08             	mov    0x8(%ebp),%eax
  80320a:	6a 00                	push   $0x0
  80320c:	6a 00                	push   $0x0
  80320e:	51                   	push   %ecx
  80320f:	52                   	push   %edx
  803210:	50                   	push   %eax
  803211:	6a 17                	push   $0x17
  803213:	e8 a8 fd ff ff       	call   802fc0 <syscall>
  803218:	83 c4 18             	add    $0x18,%esp
}
  80321b:	c9                   	leave  
  80321c:	c3                   	ret    

0080321d <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  80321d:	55                   	push   %ebp
  80321e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  803220:	8b 55 0c             	mov    0xc(%ebp),%edx
  803223:	8b 45 08             	mov    0x8(%ebp),%eax
  803226:	6a 00                	push   $0x0
  803228:	6a 00                	push   $0x0
  80322a:	6a 00                	push   $0x0
  80322c:	52                   	push   %edx
  80322d:	50                   	push   %eax
  80322e:	6a 18                	push   $0x18
  803230:	e8 8b fd ff ff       	call   802fc0 <syscall>
  803235:	83 c4 18             	add    $0x18,%esp
}
  803238:	c9                   	leave  
  803239:	c3                   	ret    

0080323a <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  80323a:	55                   	push   %ebp
  80323b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  80323d:	8b 45 08             	mov    0x8(%ebp),%eax
  803240:	6a 00                	push   $0x0
  803242:	ff 75 14             	pushl  0x14(%ebp)
  803245:	ff 75 10             	pushl  0x10(%ebp)
  803248:	ff 75 0c             	pushl  0xc(%ebp)
  80324b:	50                   	push   %eax
  80324c:	6a 19                	push   $0x19
  80324e:	e8 6d fd ff ff       	call   802fc0 <syscall>
  803253:	83 c4 18             	add    $0x18,%esp
}
  803256:	c9                   	leave  
  803257:	c3                   	ret    

00803258 <sys_run_env>:

void sys_run_env(int32 envId)
{
  803258:	55                   	push   %ebp
  803259:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  80325b:	8b 45 08             	mov    0x8(%ebp),%eax
  80325e:	6a 00                	push   $0x0
  803260:	6a 00                	push   $0x0
  803262:	6a 00                	push   $0x0
  803264:	6a 00                	push   $0x0
  803266:	50                   	push   %eax
  803267:	6a 1a                	push   $0x1a
  803269:	e8 52 fd ff ff       	call   802fc0 <syscall>
  80326e:	83 c4 18             	add    $0x18,%esp
}
  803271:	90                   	nop
  803272:	c9                   	leave  
  803273:	c3                   	ret    

00803274 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  803274:	55                   	push   %ebp
  803275:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  803277:	8b 45 08             	mov    0x8(%ebp),%eax
  80327a:	6a 00                	push   $0x0
  80327c:	6a 00                	push   $0x0
  80327e:	6a 00                	push   $0x0
  803280:	6a 00                	push   $0x0
  803282:	50                   	push   %eax
  803283:	6a 1b                	push   $0x1b
  803285:	e8 36 fd ff ff       	call   802fc0 <syscall>
  80328a:	83 c4 18             	add    $0x18,%esp
}
  80328d:	c9                   	leave  
  80328e:	c3                   	ret    

0080328f <sys_getenvid>:

int32 sys_getenvid(void)
{
  80328f:	55                   	push   %ebp
  803290:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  803292:	6a 00                	push   $0x0
  803294:	6a 00                	push   $0x0
  803296:	6a 00                	push   $0x0
  803298:	6a 00                	push   $0x0
  80329a:	6a 00                	push   $0x0
  80329c:	6a 05                	push   $0x5
  80329e:	e8 1d fd ff ff       	call   802fc0 <syscall>
  8032a3:	83 c4 18             	add    $0x18,%esp
}
  8032a6:	c9                   	leave  
  8032a7:	c3                   	ret    

008032a8 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8032a8:	55                   	push   %ebp
  8032a9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8032ab:	6a 00                	push   $0x0
  8032ad:	6a 00                	push   $0x0
  8032af:	6a 00                	push   $0x0
  8032b1:	6a 00                	push   $0x0
  8032b3:	6a 00                	push   $0x0
  8032b5:	6a 06                	push   $0x6
  8032b7:	e8 04 fd ff ff       	call   802fc0 <syscall>
  8032bc:	83 c4 18             	add    $0x18,%esp
}
  8032bf:	c9                   	leave  
  8032c0:	c3                   	ret    

008032c1 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8032c1:	55                   	push   %ebp
  8032c2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8032c4:	6a 00                	push   $0x0
  8032c6:	6a 00                	push   $0x0
  8032c8:	6a 00                	push   $0x0
  8032ca:	6a 00                	push   $0x0
  8032cc:	6a 00                	push   $0x0
  8032ce:	6a 07                	push   $0x7
  8032d0:	e8 eb fc ff ff       	call   802fc0 <syscall>
  8032d5:	83 c4 18             	add    $0x18,%esp
}
  8032d8:	c9                   	leave  
  8032d9:	c3                   	ret    

008032da <sys_exit_env>:


void sys_exit_env(void)
{
  8032da:	55                   	push   %ebp
  8032db:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  8032dd:	6a 00                	push   $0x0
  8032df:	6a 00                	push   $0x0
  8032e1:	6a 00                	push   $0x0
  8032e3:	6a 00                	push   $0x0
  8032e5:	6a 00                	push   $0x0
  8032e7:	6a 1c                	push   $0x1c
  8032e9:	e8 d2 fc ff ff       	call   802fc0 <syscall>
  8032ee:	83 c4 18             	add    $0x18,%esp
}
  8032f1:	90                   	nop
  8032f2:	c9                   	leave  
  8032f3:	c3                   	ret    

008032f4 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  8032f4:	55                   	push   %ebp
  8032f5:	89 e5                	mov    %esp,%ebp
  8032f7:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8032fa:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8032fd:	8d 50 04             	lea    0x4(%eax),%edx
  803300:	8d 45 f8             	lea    -0x8(%ebp),%eax
  803303:	6a 00                	push   $0x0
  803305:	6a 00                	push   $0x0
  803307:	6a 00                	push   $0x0
  803309:	52                   	push   %edx
  80330a:	50                   	push   %eax
  80330b:	6a 1d                	push   $0x1d
  80330d:	e8 ae fc ff ff       	call   802fc0 <syscall>
  803312:	83 c4 18             	add    $0x18,%esp
	return result;
  803315:	8b 4d 08             	mov    0x8(%ebp),%ecx
  803318:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80331b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80331e:	89 01                	mov    %eax,(%ecx)
  803320:	89 51 04             	mov    %edx,0x4(%ecx)
}
  803323:	8b 45 08             	mov    0x8(%ebp),%eax
  803326:	c9                   	leave  
  803327:	c2 04 00             	ret    $0x4

0080332a <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  80332a:	55                   	push   %ebp
  80332b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  80332d:	6a 00                	push   $0x0
  80332f:	6a 00                	push   $0x0
  803331:	ff 75 10             	pushl  0x10(%ebp)
  803334:	ff 75 0c             	pushl  0xc(%ebp)
  803337:	ff 75 08             	pushl  0x8(%ebp)
  80333a:	6a 13                	push   $0x13
  80333c:	e8 7f fc ff ff       	call   802fc0 <syscall>
  803341:	83 c4 18             	add    $0x18,%esp
	return ;
  803344:	90                   	nop
}
  803345:	c9                   	leave  
  803346:	c3                   	ret    

00803347 <sys_rcr2>:
uint32 sys_rcr2()
{
  803347:	55                   	push   %ebp
  803348:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  80334a:	6a 00                	push   $0x0
  80334c:	6a 00                	push   $0x0
  80334e:	6a 00                	push   $0x0
  803350:	6a 00                	push   $0x0
  803352:	6a 00                	push   $0x0
  803354:	6a 1e                	push   $0x1e
  803356:	e8 65 fc ff ff       	call   802fc0 <syscall>
  80335b:	83 c4 18             	add    $0x18,%esp
}
  80335e:	c9                   	leave  
  80335f:	c3                   	ret    

00803360 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  803360:	55                   	push   %ebp
  803361:	89 e5                	mov    %esp,%ebp
  803363:	83 ec 04             	sub    $0x4,%esp
  803366:	8b 45 08             	mov    0x8(%ebp),%eax
  803369:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  80336c:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  803370:	6a 00                	push   $0x0
  803372:	6a 00                	push   $0x0
  803374:	6a 00                	push   $0x0
  803376:	6a 00                	push   $0x0
  803378:	50                   	push   %eax
  803379:	6a 1f                	push   $0x1f
  80337b:	e8 40 fc ff ff       	call   802fc0 <syscall>
  803380:	83 c4 18             	add    $0x18,%esp
	return ;
  803383:	90                   	nop
}
  803384:	c9                   	leave  
  803385:	c3                   	ret    

00803386 <rsttst>:
void rsttst()
{
  803386:	55                   	push   %ebp
  803387:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  803389:	6a 00                	push   $0x0
  80338b:	6a 00                	push   $0x0
  80338d:	6a 00                	push   $0x0
  80338f:	6a 00                	push   $0x0
  803391:	6a 00                	push   $0x0
  803393:	6a 21                	push   $0x21
  803395:	e8 26 fc ff ff       	call   802fc0 <syscall>
  80339a:	83 c4 18             	add    $0x18,%esp
	return ;
  80339d:	90                   	nop
}
  80339e:	c9                   	leave  
  80339f:	c3                   	ret    

008033a0 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8033a0:	55                   	push   %ebp
  8033a1:	89 e5                	mov    %esp,%ebp
  8033a3:	83 ec 04             	sub    $0x4,%esp
  8033a6:	8b 45 14             	mov    0x14(%ebp),%eax
  8033a9:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8033ac:	8b 55 18             	mov    0x18(%ebp),%edx
  8033af:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8033b3:	52                   	push   %edx
  8033b4:	50                   	push   %eax
  8033b5:	ff 75 10             	pushl  0x10(%ebp)
  8033b8:	ff 75 0c             	pushl  0xc(%ebp)
  8033bb:	ff 75 08             	pushl  0x8(%ebp)
  8033be:	6a 20                	push   $0x20
  8033c0:	e8 fb fb ff ff       	call   802fc0 <syscall>
  8033c5:	83 c4 18             	add    $0x18,%esp
	return ;
  8033c8:	90                   	nop
}
  8033c9:	c9                   	leave  
  8033ca:	c3                   	ret    

008033cb <chktst>:
void chktst(uint32 n)
{
  8033cb:	55                   	push   %ebp
  8033cc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8033ce:	6a 00                	push   $0x0
  8033d0:	6a 00                	push   $0x0
  8033d2:	6a 00                	push   $0x0
  8033d4:	6a 00                	push   $0x0
  8033d6:	ff 75 08             	pushl  0x8(%ebp)
  8033d9:	6a 22                	push   $0x22
  8033db:	e8 e0 fb ff ff       	call   802fc0 <syscall>
  8033e0:	83 c4 18             	add    $0x18,%esp
	return ;
  8033e3:	90                   	nop
}
  8033e4:	c9                   	leave  
  8033e5:	c3                   	ret    

008033e6 <inctst>:

void inctst()
{
  8033e6:	55                   	push   %ebp
  8033e7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8033e9:	6a 00                	push   $0x0
  8033eb:	6a 00                	push   $0x0
  8033ed:	6a 00                	push   $0x0
  8033ef:	6a 00                	push   $0x0
  8033f1:	6a 00                	push   $0x0
  8033f3:	6a 23                	push   $0x23
  8033f5:	e8 c6 fb ff ff       	call   802fc0 <syscall>
  8033fa:	83 c4 18             	add    $0x18,%esp
	return ;
  8033fd:	90                   	nop
}
  8033fe:	c9                   	leave  
  8033ff:	c3                   	ret    

00803400 <gettst>:
uint32 gettst()
{
  803400:	55                   	push   %ebp
  803401:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  803403:	6a 00                	push   $0x0
  803405:	6a 00                	push   $0x0
  803407:	6a 00                	push   $0x0
  803409:	6a 00                	push   $0x0
  80340b:	6a 00                	push   $0x0
  80340d:	6a 24                	push   $0x24
  80340f:	e8 ac fb ff ff       	call   802fc0 <syscall>
  803414:	83 c4 18             	add    $0x18,%esp
}
  803417:	c9                   	leave  
  803418:	c3                   	ret    

00803419 <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  803419:	55                   	push   %ebp
  80341a:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80341c:	6a 00                	push   $0x0
  80341e:	6a 00                	push   $0x0
  803420:	6a 00                	push   $0x0
  803422:	6a 00                	push   $0x0
  803424:	6a 00                	push   $0x0
  803426:	6a 25                	push   $0x25
  803428:	e8 93 fb ff ff       	call   802fc0 <syscall>
  80342d:	83 c4 18             	add    $0x18,%esp
  803430:	a3 60 d0 81 00       	mov    %eax,0x81d060
	return uheapPlaceStrategy ;
  803435:	a1 60 d0 81 00       	mov    0x81d060,%eax
}
  80343a:	c9                   	leave  
  80343b:	c3                   	ret    

0080343c <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  80343c:	55                   	push   %ebp
  80343d:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  80343f:	8b 45 08             	mov    0x8(%ebp),%eax
  803442:	a3 60 d0 81 00       	mov    %eax,0x81d060
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  803447:	6a 00                	push   $0x0
  803449:	6a 00                	push   $0x0
  80344b:	6a 00                	push   $0x0
  80344d:	6a 00                	push   $0x0
  80344f:	ff 75 08             	pushl  0x8(%ebp)
  803452:	6a 26                	push   $0x26
  803454:	e8 67 fb ff ff       	call   802fc0 <syscall>
  803459:	83 c4 18             	add    $0x18,%esp
	return ;
  80345c:	90                   	nop
}
  80345d:	c9                   	leave  
  80345e:	c3                   	ret    

0080345f <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  80345f:	55                   	push   %ebp
  803460:	89 e5                	mov    %esp,%ebp
  803462:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  803463:	8b 5d 14             	mov    0x14(%ebp),%ebx
  803466:	8b 4d 10             	mov    0x10(%ebp),%ecx
  803469:	8b 55 0c             	mov    0xc(%ebp),%edx
  80346c:	8b 45 08             	mov    0x8(%ebp),%eax
  80346f:	6a 00                	push   $0x0
  803471:	53                   	push   %ebx
  803472:	51                   	push   %ecx
  803473:	52                   	push   %edx
  803474:	50                   	push   %eax
  803475:	6a 27                	push   $0x27
  803477:	e8 44 fb ff ff       	call   802fc0 <syscall>
  80347c:	83 c4 18             	add    $0x18,%esp
}
  80347f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  803482:	c9                   	leave  
  803483:	c3                   	ret    

00803484 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  803484:	55                   	push   %ebp
  803485:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  803487:	8b 55 0c             	mov    0xc(%ebp),%edx
  80348a:	8b 45 08             	mov    0x8(%ebp),%eax
  80348d:	6a 00                	push   $0x0
  80348f:	6a 00                	push   $0x0
  803491:	6a 00                	push   $0x0
  803493:	52                   	push   %edx
  803494:	50                   	push   %eax
  803495:	6a 28                	push   $0x28
  803497:	e8 24 fb ff ff       	call   802fc0 <syscall>
  80349c:	83 c4 18             	add    $0x18,%esp
}
  80349f:	c9                   	leave  
  8034a0:	c3                   	ret    

008034a1 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  8034a1:	55                   	push   %ebp
  8034a2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  8034a4:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8034a7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8034aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8034ad:	6a 00                	push   $0x0
  8034af:	51                   	push   %ecx
  8034b0:	ff 75 10             	pushl  0x10(%ebp)
  8034b3:	52                   	push   %edx
  8034b4:	50                   	push   %eax
  8034b5:	6a 29                	push   $0x29
  8034b7:	e8 04 fb ff ff       	call   802fc0 <syscall>
  8034bc:	83 c4 18             	add    $0x18,%esp
}
  8034bf:	c9                   	leave  
  8034c0:	c3                   	ret    

008034c1 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8034c1:	55                   	push   %ebp
  8034c2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8034c4:	6a 00                	push   $0x0
  8034c6:	6a 00                	push   $0x0
  8034c8:	ff 75 10             	pushl  0x10(%ebp)
  8034cb:	ff 75 0c             	pushl  0xc(%ebp)
  8034ce:	ff 75 08             	pushl  0x8(%ebp)
  8034d1:	6a 12                	push   $0x12
  8034d3:	e8 e8 fa ff ff       	call   802fc0 <syscall>
  8034d8:	83 c4 18             	add    $0x18,%esp
	return ;
  8034db:	90                   	nop
}
  8034dc:	c9                   	leave  
  8034dd:	c3                   	ret    

008034de <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  8034de:	55                   	push   %ebp
  8034df:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  8034e1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8034e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8034e7:	6a 00                	push   $0x0
  8034e9:	6a 00                	push   $0x0
  8034eb:	6a 00                	push   $0x0
  8034ed:	52                   	push   %edx
  8034ee:	50                   	push   %eax
  8034ef:	6a 2a                	push   $0x2a
  8034f1:	e8 ca fa ff ff       	call   802fc0 <syscall>
  8034f6:	83 c4 18             	add    $0x18,%esp
	return;
  8034f9:	90                   	nop
}
  8034fa:	c9                   	leave  
  8034fb:	c3                   	ret    

008034fc <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  8034fc:	55                   	push   %ebp
  8034fd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  8034ff:	6a 00                	push   $0x0
  803501:	6a 00                	push   $0x0
  803503:	6a 00                	push   $0x0
  803505:	6a 00                	push   $0x0
  803507:	6a 00                	push   $0x0
  803509:	6a 2b                	push   $0x2b
  80350b:	e8 b0 fa ff ff       	call   802fc0 <syscall>
  803510:	83 c4 18             	add    $0x18,%esp
}
  803513:	c9                   	leave  
  803514:	c3                   	ret    

00803515 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  803515:	55                   	push   %ebp
  803516:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  803518:	6a 00                	push   $0x0
  80351a:	6a 00                	push   $0x0
  80351c:	6a 00                	push   $0x0
  80351e:	ff 75 0c             	pushl  0xc(%ebp)
  803521:	ff 75 08             	pushl  0x8(%ebp)
  803524:	6a 2d                	push   $0x2d
  803526:	e8 95 fa ff ff       	call   802fc0 <syscall>
  80352b:	83 c4 18             	add    $0x18,%esp
	return;
  80352e:	90                   	nop
}
  80352f:	c9                   	leave  
  803530:	c3                   	ret    

00803531 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  803531:	55                   	push   %ebp
  803532:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  803534:	6a 00                	push   $0x0
  803536:	6a 00                	push   $0x0
  803538:	6a 00                	push   $0x0
  80353a:	ff 75 0c             	pushl  0xc(%ebp)
  80353d:	ff 75 08             	pushl  0x8(%ebp)
  803540:	6a 2c                	push   $0x2c
  803542:	e8 79 fa ff ff       	call   802fc0 <syscall>
  803547:	83 c4 18             	add    $0x18,%esp
	return ;
  80354a:	90                   	nop
}
  80354b:	c9                   	leave  
  80354c:	c3                   	ret    

0080354d <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  80354d:	55                   	push   %ebp
  80354e:	89 e5                	mov    %esp,%ebp
	//TODO: [PROJECT'25.IM#4] CPU SCHEDULING - #1 System Calls - Add suitable code here
	//Your code is here
	//Comment the following line
	//panic("sys_env_set_priority() is not implemented yet...!!");
	syscall(SYS_env_set_priority, envID, priority, 0, 0, 0);
  803550:	8b 55 0c             	mov    0xc(%ebp),%edx
  803553:	8b 45 08             	mov    0x8(%ebp),%eax
  803556:	6a 00                	push   $0x0
  803558:	6a 00                	push   $0x0
  80355a:	6a 00                	push   $0x0
  80355c:	52                   	push   %edx
  80355d:	50                   	push   %eax
  80355e:	6a 2e                	push   $0x2e
  803560:	e8 5b fa ff ff       	call   802fc0 <syscall>
  803565:	83 c4 18             	add    $0x18,%esp
	    return;
  803568:	90                   	nop
}
  803569:	c9                   	leave  
  80356a:	c3                   	ret    

0080356b <to_page_va>:
//==================================================================================//
//==================================
// [1] GET PAGE VA:
//==================================
__inline__ uint32 to_page_va(struct PageInfoElement *ptrPageInfo)
{
  80356b:	55                   	push   %ebp
  80356c:	89 e5                	mov    %esp,%ebp
  80356e:	83 ec 10             	sub    $0x10,%esp
	//Get start VA of the page from the corresponding Page Info pointer
	int idxInPageInfoArr = (ptrPageInfo - pageBlockInfoArr);
  803571:	8b 45 08             	mov    0x8(%ebp),%eax
  803574:	ba 60 50 80 00       	mov    $0x805060,%edx
  803579:	29 d0                	sub    %edx,%eax
  80357b:	c1 f8 02             	sar    $0x2,%eax
  80357e:	89 c2                	mov    %eax,%edx
  803580:	89 d0                	mov    %edx,%eax
  803582:	c1 e0 02             	shl    $0x2,%eax
  803585:	01 d0                	add    %edx,%eax
  803587:	c1 e0 02             	shl    $0x2,%eax
  80358a:	01 d0                	add    %edx,%eax
  80358c:	c1 e0 02             	shl    $0x2,%eax
  80358f:	01 d0                	add    %edx,%eax
  803591:	89 c1                	mov    %eax,%ecx
  803593:	c1 e1 08             	shl    $0x8,%ecx
  803596:	01 c8                	add    %ecx,%eax
  803598:	89 c1                	mov    %eax,%ecx
  80359a:	c1 e1 10             	shl    $0x10,%ecx
  80359d:	01 c8                	add    %ecx,%eax
  80359f:	01 c0                	add    %eax,%eax
  8035a1:	01 d0                	add    %edx,%eax
  8035a3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return dynAllocStart + (idxInPageInfoArr << PGSHIFT);
  8035a6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8035a9:	c1 e0 0c             	shl    $0xc,%eax
  8035ac:	89 c2                	mov    %eax,%edx
  8035ae:	a1 64 d0 81 00       	mov    0x81d064,%eax
  8035b3:	01 d0                	add    %edx,%eax
}
  8035b5:	c9                   	leave  
  8035b6:	c3                   	ret    

008035b7 <log2>:

//==================================================================================//
//============================ REQUIRED FUNCTIONS ==================================//
//==================================================================================//
__inline__ int log2(uint32 n)
	{
  8035b7:	55                   	push   %ebp
  8035b8:	89 e5                	mov    %esp,%ebp
  8035ba:	83 ec 10             	sub    $0x10,%esp
		int result = 0;
  8035bd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
		while( n > 1){
  8035c4:	eb 06                	jmp    8035cc <log2+0x15>
			n >>=1;
  8035c6:	d1 6d 08             	shrl   0x8(%ebp)
			result++;
  8035c9:	ff 45 fc             	incl   -0x4(%ebp)
//============================ REQUIRED FUNCTIONS ==================================//
//==================================================================================//
__inline__ int log2(uint32 n)
	{
		int result = 0;
		while( n > 1){
  8035cc:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
  8035d0:	77 f4                	ja     8035c6 <log2+0xf>
			n >>=1;
			result++;
		}
		return result;
  8035d2:	8b 45 fc             	mov    -0x4(%ebp),%eax
	}
  8035d5:	c9                   	leave  
  8035d6:	c3                   	ret    

008035d7 <initialize_dynamic_allocator>:
//==================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================
bool is_initialized = 0;
void initialize_dynamic_allocator(uint32 daStart, uint32 daEnd)
{
  8035d7:	55                   	push   %ebp
  8035d8:	89 e5                	mov    %esp,%ebp
  8035da:	83 ec 18             	sub    $0x18,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(daEnd <= daStart + DYN_ALLOC_MAX_SIZE);
  8035dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8035e0:	05 00 00 00 02       	add    $0x2000000,%eax
  8035e5:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8035e8:	73 16                	jae    803600 <initialize_dynamic_allocator+0x29>
  8035ea:	68 58 4d 80 00       	push   $0x804d58
  8035ef:	68 7e 4d 80 00       	push   $0x804d7e
  8035f4:	6a 2d                	push   $0x2d
  8035f6:	68 93 4d 80 00       	push   $0x804d93
  8035fb:	e8 a6 ce ff ff       	call   8004a6 <_panic>
		is_initialized = 1;
  803600:	c7 05 24 50 80 00 01 	movl   $0x1,0x805024
  803607:	00 00 00 
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #1 initialize_dynamic_allocator
	//Your code is here


	dynAllocStart = daStart;
  80360a:	8b 45 08             	mov    0x8(%ebp),%eax
  80360d:	a3 64 d0 81 00       	mov    %eax,0x81d064
	dynAllocEnd= daEnd;
  803612:	8b 45 0c             	mov    0xc(%ebp),%eax
  803615:	a3 40 50 80 00       	mov    %eax,0x805040
	int numOfPages = (dynAllocEnd - dynAllocStart)/PAGE_SIZE;
  80361a:	8b 15 40 50 80 00    	mov    0x805040,%edx
  803620:	a1 64 d0 81 00       	mov    0x81d064,%eax
  803625:	29 c2                	sub    %eax,%edx
  803627:	89 d0                	mov    %edx,%eax
  803629:	c1 e8 0c             	shr    $0xc,%eax
  80362c:	89 45 e8             	mov    %eax,-0x18(%ebp)


	for(int i=0; i< numOfPages; i++){
  80362f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  803636:	eb 2f                	jmp    803667 <initialize_dynamic_allocator+0x90>
	    pageBlockInfoArr[i].block_size=0;
  803638:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80363b:	89 d0                	mov    %edx,%eax
  80363d:	01 c0                	add    %eax,%eax
  80363f:	01 d0                	add    %edx,%eax
  803641:	c1 e0 02             	shl    $0x2,%eax
  803644:	05 68 50 80 00       	add    $0x805068,%eax
  803649:	66 c7 00 00 00       	movw   $0x0,(%eax)
	    pageBlockInfoArr[i].num_of_free_blocks=0;
  80364e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803651:	89 d0                	mov    %edx,%eax
  803653:	01 c0                	add    %eax,%eax
  803655:	01 d0                	add    %edx,%eax
  803657:	c1 e0 02             	shl    $0x2,%eax
  80365a:	05 6a 50 80 00       	add    $0x80506a,%eax
  80365f:	66 c7 00 00 00       	movw   $0x0,(%eax)
	dynAllocStart = daStart;
	dynAllocEnd= daEnd;
	int numOfPages = (dynAllocEnd - dynAllocStart)/PAGE_SIZE;


	for(int i=0; i< numOfPages; i++){
  803664:	ff 45 f4             	incl   -0xc(%ebp)
  803667:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80366a:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80366d:	7c c9                	jl     803638 <initialize_dynamic_allocator+0x61>
	    pageBlockInfoArr[i].block_size=0;
	    pageBlockInfoArr[i].num_of_free_blocks=0;
	}


	LIST_INIT(&freePagesList);
  80366f:	c7 05 48 50 80 00 00 	movl   $0x0,0x805048
  803676:	00 00 00 
  803679:	c7 05 4c 50 80 00 00 	movl   $0x0,0x80504c
  803680:	00 00 00 
  803683:	c7 05 54 50 80 00 00 	movl   $0x0,0x805054
  80368a:	00 00 00 
	for(int i=0; i<numOfPages; i++){
  80368d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  803694:	e9 9c 00 00 00       	jmp    803735 <initialize_dynamic_allocator+0x15e>
		LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
  803699:	8b 15 4c 50 80 00    	mov    0x80504c,%edx
  80369f:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8036a2:	89 c8                	mov    %ecx,%eax
  8036a4:	01 c0                	add    %eax,%eax
  8036a6:	01 c8                	add    %ecx,%eax
  8036a8:	c1 e0 02             	shl    $0x2,%eax
  8036ab:	05 64 50 80 00       	add    $0x805064,%eax
  8036b0:	89 10                	mov    %edx,(%eax)
  8036b2:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8036b5:	89 d0                	mov    %edx,%eax
  8036b7:	01 c0                	add    %eax,%eax
  8036b9:	01 d0                	add    %edx,%eax
  8036bb:	c1 e0 02             	shl    $0x2,%eax
  8036be:	05 64 50 80 00       	add    $0x805064,%eax
  8036c3:	8b 00                	mov    (%eax),%eax
  8036c5:	85 c0                	test   %eax,%eax
  8036c7:	74 1b                	je     8036e4 <initialize_dynamic_allocator+0x10d>
  8036c9:	8b 15 4c 50 80 00    	mov    0x80504c,%edx
  8036cf:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8036d2:	89 c8                	mov    %ecx,%eax
  8036d4:	01 c0                	add    %eax,%eax
  8036d6:	01 c8                	add    %ecx,%eax
  8036d8:	c1 e0 02             	shl    $0x2,%eax
  8036db:	05 60 50 80 00       	add    $0x805060,%eax
  8036e0:	89 02                	mov    %eax,(%edx)
  8036e2:	eb 16                	jmp    8036fa <initialize_dynamic_allocator+0x123>
  8036e4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8036e7:	89 d0                	mov    %edx,%eax
  8036e9:	01 c0                	add    %eax,%eax
  8036eb:	01 d0                	add    %edx,%eax
  8036ed:	c1 e0 02             	shl    $0x2,%eax
  8036f0:	05 60 50 80 00       	add    $0x805060,%eax
  8036f5:	a3 48 50 80 00       	mov    %eax,0x805048
  8036fa:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8036fd:	89 d0                	mov    %edx,%eax
  8036ff:	01 c0                	add    %eax,%eax
  803701:	01 d0                	add    %edx,%eax
  803703:	c1 e0 02             	shl    $0x2,%eax
  803706:	05 60 50 80 00       	add    $0x805060,%eax
  80370b:	a3 4c 50 80 00       	mov    %eax,0x80504c
  803710:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803713:	89 d0                	mov    %edx,%eax
  803715:	01 c0                	add    %eax,%eax
  803717:	01 d0                	add    %edx,%eax
  803719:	c1 e0 02             	shl    $0x2,%eax
  80371c:	05 60 50 80 00       	add    $0x805060,%eax
  803721:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803727:	a1 54 50 80 00       	mov    0x805054,%eax
  80372c:	40                   	inc    %eax
  80372d:	a3 54 50 80 00       	mov    %eax,0x805054
	    pageBlockInfoArr[i].num_of_free_blocks=0;
	}


	LIST_INIT(&freePagesList);
	for(int i=0; i<numOfPages; i++){
  803732:	ff 45 f0             	incl   -0x10(%ebp)
  803735:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803738:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80373b:	0f 8c 58 ff ff ff    	jl     803699 <initialize_dynamic_allocator+0xc2>
		LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
	}



	for (int i = 0; i < LOG2_MAX_SIZE - LOG2_MIN_SIZE + 1; i++) {
  803741:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  803748:	eb 36                	jmp    803780 <initialize_dynamic_allocator+0x1a9>
	    LIST_INIT(&freeBlockLists[i]);
  80374a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80374d:	c1 e0 04             	shl    $0x4,%eax
  803750:	05 80 d0 81 00       	add    $0x81d080,%eax
  803755:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80375b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80375e:	c1 e0 04             	shl    $0x4,%eax
  803761:	05 84 d0 81 00       	add    $0x81d084,%eax
  803766:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80376c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80376f:	c1 e0 04             	shl    $0x4,%eax
  803772:	05 8c d0 81 00       	add    $0x81d08c,%eax
  803777:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
	}



	for (int i = 0; i < LOG2_MAX_SIZE - LOG2_MIN_SIZE + 1; i++) {
  80377d:	ff 45 ec             	incl   -0x14(%ebp)
  803780:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  803784:	7e c4                	jle    80374a <initialize_dynamic_allocator+0x173>


	//Comment the following line
	//panic("initialize_dynamic_allocator() Not implemented yet");

}
  803786:	90                   	nop
  803787:	c9                   	leave  
  803788:	c3                   	ret    

00803789 <get_block_size>:
// [2] GET BLOCK SIZE:
//===========================


__inline__ uint32 get_block_size(void *va)
{
  803789:	55                   	push   %ebp
  80378a:	89 e5                	mov    %esp,%ebp
  80378c:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #2 get_block_size
	//Your code is here

	uint32 page_index = ((uint32)va - dynAllocStart)/ PAGE_SIZE;
  80378f:	8b 55 08             	mov    0x8(%ebp),%edx
  803792:	a1 64 d0 81 00       	mov    0x81d064,%eax
  803797:	29 c2                	sub    %eax,%edx
  803799:	89 d0                	mov    %edx,%eax
  80379b:	c1 e8 0c             	shr    $0xc,%eax
  80379e:	89 45 fc             	mov    %eax,-0x4(%ebp)
    return pageBlockInfoArr[page_index].block_size;
  8037a1:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8037a4:	89 d0                	mov    %edx,%eax
  8037a6:	01 c0                	add    %eax,%eax
  8037a8:	01 d0                	add    %edx,%eax
  8037aa:	c1 e0 02             	shl    $0x2,%eax
  8037ad:	05 68 50 80 00       	add    $0x805068,%eax
  8037b2:	8b 00                	mov    (%eax),%eax
  8037b4:	0f b7 c0             	movzwl %ax,%eax
	//Comment the following line
	//panic("get_block_size() Not implemented yet");
}
  8037b7:	c9                   	leave  
  8037b8:	c3                   	ret    

008037b9 <alloc_block>:

//===========================
// 3) ALLOCATE BLOCK:
//===========================
void *alloc_block(uint32 size)
{
  8037b9:	55                   	push   %ebp
  8037ba:	89 e5                	mov    %esp,%ebp
  8037bc:	83 ec 48             	sub    $0x48,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(size <= DYN_ALLOC_MAX_BLOCK_SIZE);
  8037bf:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  8037c6:	76 16                	jbe    8037de <alloc_block+0x25>
  8037c8:	68 ac 4d 80 00       	push   $0x804dac
  8037cd:	68 7e 4d 80 00       	push   $0x804d7e
  8037d2:	6a 6c                	push   $0x6c
  8037d4:	68 93 4d 80 00       	push   $0x804d93
  8037d9:	e8 c8 cc ff ff       	call   8004a6 <_panic>
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #3 alloc_block
	//Your code is here


	if(size == 0){
  8037de:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8037e2:	75 0a                	jne    8037ee <alloc_block+0x35>
		return NULL;
  8037e4:	b8 00 00 00 00       	mov    $0x0,%eax
  8037e9:	e9 65 04 00 00       	jmp    803c53 <alloc_block+0x49a>
	}
	else if(size<=8){
  8037ee:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  8037f2:	77 09                	ja     8037fd <alloc_block+0x44>
		size=8;
  8037f4:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
  8037fb:	eb 1f                	jmp    80381c <alloc_block+0x63>
	}
	else{
		uint32 reqsize=8;
  8037fd:	c7 45 f4 08 00 00 00 	movl   $0x8,-0xc(%ebp)
		while(reqsize < size){
  803804:	eb 08                	jmp    80380e <alloc_block+0x55>
			reqsize*=2;
  803806:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803809:	01 c0                	add    %eax,%eax
  80380b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	else if(size<=8){
		size=8;
	}
	else{
		uint32 reqsize=8;
		while(reqsize < size){
  80380e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803811:	3b 45 08             	cmp    0x8(%ebp),%eax
  803814:	72 f0                	jb     803806 <alloc_block+0x4d>
			reqsize*=2;
		}
		size= reqsize;
  803816:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803819:	89 45 08             	mov    %eax,0x8(%ebp)
	}

	int list_index = log2(size)- LOG2_MIN_SIZE;
  80381c:	83 ec 0c             	sub    $0xc,%esp
  80381f:	ff 75 08             	pushl  0x8(%ebp)
  803822:	e8 90 fd ff ff       	call   8035b7 <log2>
  803827:	83 c4 10             	add    $0x10,%esp
  80382a:	83 e8 03             	sub    $0x3,%eax
  80382d:	89 45 e8             	mov    %eax,-0x18(%ebp)

	if(!LIST_EMPTY(&freeBlockLists[list_index])){
  803830:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803833:	c1 e0 04             	shl    $0x4,%eax
  803836:	05 80 d0 81 00       	add    $0x81d080,%eax
  80383b:	8b 00                	mov    (%eax),%eax
  80383d:	85 c0                	test   %eax,%eax
  80383f:	0f 84 fb 00 00 00    	je     803940 <alloc_block+0x187>
		struct BlockElement *block = LIST_FIRST(&freeBlockLists[list_index]);
  803845:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803848:	c1 e0 04             	shl    $0x4,%eax
  80384b:	05 80 d0 81 00       	add    $0x81d080,%eax
  803850:	8b 00                	mov    (%eax),%eax
  803852:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		LIST_REMOVE(&freeBlockLists[list_index], block);
  803855:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803859:	75 17                	jne    803872 <alloc_block+0xb9>
  80385b:	83 ec 04             	sub    $0x4,%esp
  80385e:	68 cd 4d 80 00       	push   $0x804dcd
  803863:	68 86 00 00 00       	push   $0x86
  803868:	68 93 4d 80 00       	push   $0x804d93
  80386d:	e8 34 cc ff ff       	call   8004a6 <_panic>
  803872:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803875:	8b 00                	mov    (%eax),%eax
  803877:	85 c0                	test   %eax,%eax
  803879:	74 10                	je     80388b <alloc_block+0xd2>
  80387b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80387e:	8b 00                	mov    (%eax),%eax
  803880:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803883:	8b 52 04             	mov    0x4(%edx),%edx
  803886:	89 50 04             	mov    %edx,0x4(%eax)
  803889:	eb 14                	jmp    80389f <alloc_block+0xe6>
  80388b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80388e:	8b 40 04             	mov    0x4(%eax),%eax
  803891:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803894:	c1 e2 04             	shl    $0x4,%edx
  803897:	81 c2 84 d0 81 00    	add    $0x81d084,%edx
  80389d:	89 02                	mov    %eax,(%edx)
  80389f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038a2:	8b 40 04             	mov    0x4(%eax),%eax
  8038a5:	85 c0                	test   %eax,%eax
  8038a7:	74 0f                	je     8038b8 <alloc_block+0xff>
  8038a9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038ac:	8b 40 04             	mov    0x4(%eax),%eax
  8038af:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8038b2:	8b 12                	mov    (%edx),%edx
  8038b4:	89 10                	mov    %edx,(%eax)
  8038b6:	eb 13                	jmp    8038cb <alloc_block+0x112>
  8038b8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038bb:	8b 00                	mov    (%eax),%eax
  8038bd:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8038c0:	c1 e2 04             	shl    $0x4,%edx
  8038c3:	81 c2 80 d0 81 00    	add    $0x81d080,%edx
  8038c9:	89 02                	mov    %eax,(%edx)
  8038cb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038ce:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8038d4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038d7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8038de:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8038e1:	c1 e0 04             	shl    $0x4,%eax
  8038e4:	05 8c d0 81 00       	add    $0x81d08c,%eax
  8038e9:	8b 00                	mov    (%eax),%eax
  8038eb:	8d 50 ff             	lea    -0x1(%eax),%edx
  8038ee:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8038f1:	c1 e0 04             	shl    $0x4,%eax
  8038f4:	05 8c d0 81 00       	add    $0x81d08c,%eax
  8038f9:	89 10                	mov    %edx,(%eax)
		uint32 page_index = ((uint32)block - dynAllocStart)/ PAGE_SIZE;
  8038fb:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8038fe:	a1 64 d0 81 00       	mov    0x81d064,%eax
  803903:	29 c2                	sub    %eax,%edx
  803905:	89 d0                	mov    %edx,%eax
  803907:	c1 e8 0c             	shr    $0xc,%eax
  80390a:	89 45 e0             	mov    %eax,-0x20(%ebp)
		pageBlockInfoArr[page_index].num_of_free_blocks--;
  80390d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803910:	89 d0                	mov    %edx,%eax
  803912:	01 c0                	add    %eax,%eax
  803914:	01 d0                	add    %edx,%eax
  803916:	c1 e0 02             	shl    $0x2,%eax
  803919:	05 6a 50 80 00       	add    $0x80506a,%eax
  80391e:	66 8b 00             	mov    (%eax),%ax
  803921:	8d 50 ff             	lea    -0x1(%eax),%edx
  803924:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  803927:	89 c8                	mov    %ecx,%eax
  803929:	01 c0                	add    %eax,%eax
  80392b:	01 c8                	add    %ecx,%eax
  80392d:	c1 e0 02             	shl    $0x2,%eax
  803930:	05 6a 50 80 00       	add    $0x80506a,%eax
  803935:	66 89 10             	mov    %dx,(%eax)
		return (void*)block;
  803938:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80393b:	e9 13 03 00 00       	jmp    803c53 <alloc_block+0x49a>
	}

	if(!LIST_EMPTY(&freePagesList)){
  803940:	a1 48 50 80 00       	mov    0x805048,%eax
  803945:	85 c0                	test   %eax,%eax
  803947:	0f 84 c9 01 00 00    	je     803b16 <alloc_block+0x35d>

		struct PageInfoElement *page_info = LIST_FIRST(&freePagesList);
  80394d:	a1 48 50 80 00       	mov    0x805048,%eax
  803952:	89 45 dc             	mov    %eax,-0x24(%ebp)
		LIST_REMOVE(&freePagesList, page_info);
  803955:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803959:	75 17                	jne    803972 <alloc_block+0x1b9>
  80395b:	83 ec 04             	sub    $0x4,%esp
  80395e:	68 cd 4d 80 00       	push   $0x804dcd
  803963:	68 8f 00 00 00       	push   $0x8f
  803968:	68 93 4d 80 00       	push   $0x804d93
  80396d:	e8 34 cb ff ff       	call   8004a6 <_panic>
  803972:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803975:	8b 00                	mov    (%eax),%eax
  803977:	85 c0                	test   %eax,%eax
  803979:	74 10                	je     80398b <alloc_block+0x1d2>
  80397b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80397e:	8b 00                	mov    (%eax),%eax
  803980:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803983:	8b 52 04             	mov    0x4(%edx),%edx
  803986:	89 50 04             	mov    %edx,0x4(%eax)
  803989:	eb 0b                	jmp    803996 <alloc_block+0x1dd>
  80398b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80398e:	8b 40 04             	mov    0x4(%eax),%eax
  803991:	a3 4c 50 80 00       	mov    %eax,0x80504c
  803996:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803999:	8b 40 04             	mov    0x4(%eax),%eax
  80399c:	85 c0                	test   %eax,%eax
  80399e:	74 0f                	je     8039af <alloc_block+0x1f6>
  8039a0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8039a3:	8b 40 04             	mov    0x4(%eax),%eax
  8039a6:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8039a9:	8b 12                	mov    (%edx),%edx
  8039ab:	89 10                	mov    %edx,(%eax)
  8039ad:	eb 0a                	jmp    8039b9 <alloc_block+0x200>
  8039af:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8039b2:	8b 00                	mov    (%eax),%eax
  8039b4:	a3 48 50 80 00       	mov    %eax,0x805048
  8039b9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8039bc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8039c2:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8039c5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8039cc:	a1 54 50 80 00       	mov    0x805054,%eax
  8039d1:	48                   	dec    %eax
  8039d2:	a3 54 50 80 00       	mov    %eax,0x805054
		uint32 page_va = to_page_va(page_info);
  8039d7:	83 ec 0c             	sub    $0xc,%esp
  8039da:	ff 75 dc             	pushl  -0x24(%ebp)
  8039dd:	e8 89 fb ff ff       	call   80356b <to_page_va>
  8039e2:	83 c4 10             	add    $0x10,%esp
  8039e5:	89 45 d8             	mov    %eax,-0x28(%ebp)

		uint32 page_index = (page_va - dynAllocStart)/ PAGE_SIZE;
  8039e8:	a1 64 d0 81 00       	mov    0x81d064,%eax
  8039ed:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8039f0:	29 c2                	sub    %eax,%edx
  8039f2:	89 d0                	mov    %edx,%eax
  8039f4:	c1 e8 0c             	shr    $0xc,%eax
  8039f7:	89 45 d4             	mov    %eax,-0x2c(%ebp)

		get_page((void*)page_va);
  8039fa:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8039fd:	83 ec 0c             	sub    $0xc,%esp
  803a00:	50                   	push   %eax
  803a01:	e8 fe dc ff ff       	call   801704 <get_page>
  803a06:	83 c4 10             	add    $0x10,%esp


		pageBlockInfoArr[page_index].block_size = size;
  803a09:	8b 45 08             	mov    0x8(%ebp),%eax
  803a0c:	89 c2                	mov    %eax,%edx
  803a0e:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  803a11:	89 c8                	mov    %ecx,%eax
  803a13:	01 c0                	add    %eax,%eax
  803a15:	01 c8                	add    %ecx,%eax
  803a17:	c1 e0 02             	shl    $0x2,%eax
  803a1a:	05 68 50 80 00       	add    $0x805068,%eax
  803a1f:	66 89 10             	mov    %dx,(%eax)
		int num_blocks = PAGE_SIZE / size ;
  803a22:	b8 00 10 00 00       	mov    $0x1000,%eax
  803a27:	ba 00 00 00 00       	mov    $0x0,%edx
  803a2c:	f7 75 08             	divl   0x8(%ebp)
  803a2f:	89 45 d0             	mov    %eax,-0x30(%ebp)
		pageBlockInfoArr[page_index].num_of_free_blocks= num_blocks - 1 ;
  803a32:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803a35:	8d 50 ff             	lea    -0x1(%eax),%edx
  803a38:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  803a3b:	89 c8                	mov    %ecx,%eax
  803a3d:	01 c0                	add    %eax,%eax
  803a3f:	01 c8                	add    %ecx,%eax
  803a41:	c1 e0 02             	shl    $0x2,%eax
  803a44:	05 6a 50 80 00       	add    $0x80506a,%eax
  803a49:	66 89 10             	mov    %dx,(%eax)

		for(int i=1; i< num_blocks; i++){
  803a4c:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
  803a53:	e9 aa 00 00 00       	jmp    803b02 <alloc_block+0x349>
			struct BlockElement *new_block = (struct BlockElement*)(page_va + i *size);
  803a58:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803a5b:	0f af 45 08          	imul   0x8(%ebp),%eax
  803a5f:	89 c2                	mov    %eax,%edx
  803a61:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803a64:	01 d0                	add    %edx,%eax
  803a66:	89 45 cc             	mov    %eax,-0x34(%ebp)
			LIST_INSERT_TAIL(&freeBlockLists[list_index], new_block);
  803a69:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  803a6d:	75 17                	jne    803a86 <alloc_block+0x2cd>
  803a6f:	83 ec 04             	sub    $0x4,%esp
  803a72:	68 ec 4d 80 00       	push   $0x804dec
  803a77:	68 9d 00 00 00       	push   $0x9d
  803a7c:	68 93 4d 80 00       	push   $0x804d93
  803a81:	e8 20 ca ff ff       	call   8004a6 <_panic>
  803a86:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a89:	c1 e0 04             	shl    $0x4,%eax
  803a8c:	05 84 d0 81 00       	add    $0x81d084,%eax
  803a91:	8b 10                	mov    (%eax),%edx
  803a93:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803a96:	89 50 04             	mov    %edx,0x4(%eax)
  803a99:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803a9c:	8b 40 04             	mov    0x4(%eax),%eax
  803a9f:	85 c0                	test   %eax,%eax
  803aa1:	74 14                	je     803ab7 <alloc_block+0x2fe>
  803aa3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803aa6:	c1 e0 04             	shl    $0x4,%eax
  803aa9:	05 84 d0 81 00       	add    $0x81d084,%eax
  803aae:	8b 00                	mov    (%eax),%eax
  803ab0:	8b 55 cc             	mov    -0x34(%ebp),%edx
  803ab3:	89 10                	mov    %edx,(%eax)
  803ab5:	eb 11                	jmp    803ac8 <alloc_block+0x30f>
  803ab7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803aba:	c1 e0 04             	shl    $0x4,%eax
  803abd:	8d 90 80 d0 81 00    	lea    0x81d080(%eax),%edx
  803ac3:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803ac6:	89 02                	mov    %eax,(%edx)
  803ac8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803acb:	c1 e0 04             	shl    $0x4,%eax
  803ace:	8d 90 84 d0 81 00    	lea    0x81d084(%eax),%edx
  803ad4:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803ad7:	89 02                	mov    %eax,(%edx)
  803ad9:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803adc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803ae2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803ae5:	c1 e0 04             	shl    $0x4,%eax
  803ae8:	05 8c d0 81 00       	add    $0x81d08c,%eax
  803aed:	8b 00                	mov    (%eax),%eax
  803aef:	8d 50 01             	lea    0x1(%eax),%edx
  803af2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803af5:	c1 e0 04             	shl    $0x4,%eax
  803af8:	05 8c d0 81 00       	add    $0x81d08c,%eax
  803afd:	89 10                	mov    %edx,(%eax)

		pageBlockInfoArr[page_index].block_size = size;
		int num_blocks = PAGE_SIZE / size ;
		pageBlockInfoArr[page_index].num_of_free_blocks= num_blocks - 1 ;

		for(int i=1; i< num_blocks; i++){
  803aff:	ff 45 f0             	incl   -0x10(%ebp)
  803b02:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803b05:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  803b08:	0f 8c 4a ff ff ff    	jl     803a58 <alloc_block+0x29f>
			struct BlockElement *new_block = (struct BlockElement*)(page_va + i *size);
			LIST_INSERT_TAIL(&freeBlockLists[list_index], new_block);
		}
		return(void*)page_va;
  803b0e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803b11:	e9 3d 01 00 00       	jmp    803c53 <alloc_block+0x49a>
	}


	for(int i =list_index+1; i<= LOG2_MAX_SIZE - LOG2_MIN_SIZE; i++){
  803b16:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803b19:	40                   	inc    %eax
  803b1a:	89 45 ec             	mov    %eax,-0x14(%ebp)
  803b1d:	e9 10 01 00 00       	jmp    803c32 <alloc_block+0x479>

		if(!LIST_EMPTY(&freeBlockLists[i])){
  803b22:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803b25:	c1 e0 04             	shl    $0x4,%eax
  803b28:	05 80 d0 81 00       	add    $0x81d080,%eax
  803b2d:	8b 00                	mov    (%eax),%eax
  803b2f:	85 c0                	test   %eax,%eax
  803b31:	0f 84 f8 00 00 00    	je     803c2f <alloc_block+0x476>

			struct BlockElement *block = LIST_FIRST(&freeBlockLists[i]);
  803b37:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803b3a:	c1 e0 04             	shl    $0x4,%eax
  803b3d:	05 80 d0 81 00       	add    $0x81d080,%eax
  803b42:	8b 00                	mov    (%eax),%eax
  803b44:	89 45 c8             	mov    %eax,-0x38(%ebp)
			LIST_REMOVE( &freeBlockLists[i], block);
  803b47:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  803b4b:	75 17                	jne    803b64 <alloc_block+0x3ab>
  803b4d:	83 ec 04             	sub    $0x4,%esp
  803b50:	68 cd 4d 80 00       	push   $0x804dcd
  803b55:	68 a8 00 00 00       	push   $0xa8
  803b5a:	68 93 4d 80 00       	push   $0x804d93
  803b5f:	e8 42 c9 ff ff       	call   8004a6 <_panic>
  803b64:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803b67:	8b 00                	mov    (%eax),%eax
  803b69:	85 c0                	test   %eax,%eax
  803b6b:	74 10                	je     803b7d <alloc_block+0x3c4>
  803b6d:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803b70:	8b 00                	mov    (%eax),%eax
  803b72:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803b75:	8b 52 04             	mov    0x4(%edx),%edx
  803b78:	89 50 04             	mov    %edx,0x4(%eax)
  803b7b:	eb 14                	jmp    803b91 <alloc_block+0x3d8>
  803b7d:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803b80:	8b 40 04             	mov    0x4(%eax),%eax
  803b83:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803b86:	c1 e2 04             	shl    $0x4,%edx
  803b89:	81 c2 84 d0 81 00    	add    $0x81d084,%edx
  803b8f:	89 02                	mov    %eax,(%edx)
  803b91:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803b94:	8b 40 04             	mov    0x4(%eax),%eax
  803b97:	85 c0                	test   %eax,%eax
  803b99:	74 0f                	je     803baa <alloc_block+0x3f1>
  803b9b:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803b9e:	8b 40 04             	mov    0x4(%eax),%eax
  803ba1:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803ba4:	8b 12                	mov    (%edx),%edx
  803ba6:	89 10                	mov    %edx,(%eax)
  803ba8:	eb 13                	jmp    803bbd <alloc_block+0x404>
  803baa:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803bad:	8b 00                	mov    (%eax),%eax
  803baf:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803bb2:	c1 e2 04             	shl    $0x4,%edx
  803bb5:	81 c2 80 d0 81 00    	add    $0x81d080,%edx
  803bbb:	89 02                	mov    %eax,(%edx)
  803bbd:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803bc0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803bc6:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803bc9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803bd0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803bd3:	c1 e0 04             	shl    $0x4,%eax
  803bd6:	05 8c d0 81 00       	add    $0x81d08c,%eax
  803bdb:	8b 00                	mov    (%eax),%eax
  803bdd:	8d 50 ff             	lea    -0x1(%eax),%edx
  803be0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803be3:	c1 e0 04             	shl    $0x4,%eax
  803be6:	05 8c d0 81 00       	add    $0x81d08c,%eax
  803beb:	89 10                	mov    %edx,(%eax)

			uint32 page_index = ((uint32)block - dynAllocStart)/ PAGE_SIZE;
  803bed:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803bf0:	a1 64 d0 81 00       	mov    0x81d064,%eax
  803bf5:	29 c2                	sub    %eax,%edx
  803bf7:	89 d0                	mov    %edx,%eax
  803bf9:	c1 e8 0c             	shr    $0xc,%eax
  803bfc:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			pageBlockInfoArr[page_index].num_of_free_blocks-- ;
  803bff:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  803c02:	89 d0                	mov    %edx,%eax
  803c04:	01 c0                	add    %eax,%eax
  803c06:	01 d0                	add    %edx,%eax
  803c08:	c1 e0 02             	shl    $0x2,%eax
  803c0b:	05 6a 50 80 00       	add    $0x80506a,%eax
  803c10:	66 8b 00             	mov    (%eax),%ax
  803c13:	8d 50 ff             	lea    -0x1(%eax),%edx
  803c16:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  803c19:	89 c8                	mov    %ecx,%eax
  803c1b:	01 c0                	add    %eax,%eax
  803c1d:	01 c8                	add    %ecx,%eax
  803c1f:	c1 e0 02             	shl    $0x2,%eax
  803c22:	05 6a 50 80 00       	add    $0x80506a,%eax
  803c27:	66 89 10             	mov    %dx,(%eax)

			return (void*)block;
  803c2a:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803c2d:	eb 24                	jmp    803c53 <alloc_block+0x49a>
		}
		return(void*)page_va;
	}


	for(int i =list_index+1; i<= LOG2_MAX_SIZE - LOG2_MIN_SIZE; i++){
  803c2f:	ff 45 ec             	incl   -0x14(%ebp)
  803c32:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  803c36:	0f 8e e6 fe ff ff    	jle    803b22 <alloc_block+0x369>

			return (void*)block;
		}
	}

	panic("alloc_block: out of memory! ");
  803c3c:	83 ec 04             	sub    $0x4,%esp
  803c3f:	68 0f 4e 80 00       	push   $0x804e0f
  803c44:	68 b1 00 00 00       	push   $0xb1
  803c49:	68 93 4d 80 00       	push   $0x804d93
  803c4e:	e8 53 c8 ff ff       	call   8004a6 <_panic>

	//Comment the following line
	//panic("alloc_block() Not implemented yet");

	//TODO: [PROJECT'25.BONUS#1] DYNAMIC ALLOCATOR - block if no free block
}
  803c53:	c9                   	leave  
  803c54:	c3                   	ret    

00803c55 <free_block>:

//===========================
// [4] FREE BLOCK:
//===========================
void free_block(void *va)
{
  803c55:	55                   	push   %ebp
  803c56:	89 e5                	mov    %esp,%ebp
  803c58:	83 ec 38             	sub    $0x38,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert((uint32)va >= dynAllocStart && (uint32)va < dynAllocEnd);
  803c5b:	8b 55 08             	mov    0x8(%ebp),%edx
  803c5e:	a1 64 d0 81 00       	mov    0x81d064,%eax
  803c63:	39 c2                	cmp    %eax,%edx
  803c65:	72 0c                	jb     803c73 <free_block+0x1e>
  803c67:	8b 55 08             	mov    0x8(%ebp),%edx
  803c6a:	a1 40 50 80 00       	mov    0x805040,%eax
  803c6f:	39 c2                	cmp    %eax,%edx
  803c71:	72 19                	jb     803c8c <free_block+0x37>
  803c73:	68 2c 4e 80 00       	push   $0x804e2c
  803c78:	68 7e 4d 80 00       	push   $0x804d7e
  803c7d:	68 c3 00 00 00       	push   $0xc3
  803c82:	68 93 4d 80 00       	push   $0x804d93
  803c87:	e8 1a c8 ff ff       	call   8004a6 <_panic>
	//==================================================================================

	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #4 free_block
	//Your code is here

	uint32 page_index=((uint32)va - dynAllocStart)/ PAGE_SIZE;
  803c8c:	8b 55 08             	mov    0x8(%ebp),%edx
  803c8f:	a1 64 d0 81 00       	mov    0x81d064,%eax
  803c94:	29 c2                	sub    %eax,%edx
  803c96:	89 d0                	mov    %edx,%eax
  803c98:	c1 e8 0c             	shr    $0xc,%eax
  803c9b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 block_size = pageBlockInfoArr[page_index].block_size;
  803c9e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803ca1:	89 d0                	mov    %edx,%eax
  803ca3:	01 c0                	add    %eax,%eax
  803ca5:	01 d0                	add    %edx,%eax
  803ca7:	c1 e0 02             	shl    $0x2,%eax
  803caa:	05 68 50 80 00       	add    $0x805068,%eax
  803caf:	8b 00                	mov    (%eax),%eax
  803cb1:	0f b7 c0             	movzwl %ax,%eax
  803cb4:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if(block_size == 0){
  803cb7:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803cbb:	75 17                	jne    803cd4 <free_block+0x7f>
		panic("page is empty(already not allocated)");
  803cbd:	83 ec 04             	sub    $0x4,%esp
  803cc0:	68 64 4e 80 00       	push   $0x804e64
  803cc5:	68 cf 00 00 00       	push   $0xcf
  803cca:	68 93 4d 80 00       	push   $0x804d93
  803ccf:	e8 d2 c7 ff ff       	call   8004a6 <_panic>
	}

	int list_index = log2(block_size) - LOG2_MIN_SIZE;
  803cd4:	83 ec 0c             	sub    $0xc,%esp
  803cd7:	ff 75 ec             	pushl  -0x14(%ebp)
  803cda:	e8 d8 f8 ff ff       	call   8035b7 <log2>
  803cdf:	83 c4 10             	add    $0x10,%esp
  803ce2:	83 e8 03             	sub    $0x3,%eax
  803ce5:	89 45 e8             	mov    %eax,-0x18(%ebp)
	// mn va l block "elta7weel mn virtual l phy hna"
	struct BlockElement *block = (struct BlockElement *)va;
  803ce8:	8b 45 08             	mov    0x8(%ebp),%eax
  803ceb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	LIST_INSERT_TAIL(&freeBlockLists[list_index], block);
  803cee:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803cf2:	75 17                	jne    803d0b <free_block+0xb6>
  803cf4:	83 ec 04             	sub    $0x4,%esp
  803cf7:	68 ec 4d 80 00       	push   $0x804dec
  803cfc:	68 d5 00 00 00       	push   $0xd5
  803d01:	68 93 4d 80 00       	push   $0x804d93
  803d06:	e8 9b c7 ff ff       	call   8004a6 <_panic>
  803d0b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803d0e:	c1 e0 04             	shl    $0x4,%eax
  803d11:	05 84 d0 81 00       	add    $0x81d084,%eax
  803d16:	8b 10                	mov    (%eax),%edx
  803d18:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803d1b:	89 50 04             	mov    %edx,0x4(%eax)
  803d1e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803d21:	8b 40 04             	mov    0x4(%eax),%eax
  803d24:	85 c0                	test   %eax,%eax
  803d26:	74 14                	je     803d3c <free_block+0xe7>
  803d28:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803d2b:	c1 e0 04             	shl    $0x4,%eax
  803d2e:	05 84 d0 81 00       	add    $0x81d084,%eax
  803d33:	8b 00                	mov    (%eax),%eax
  803d35:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803d38:	89 10                	mov    %edx,(%eax)
  803d3a:	eb 11                	jmp    803d4d <free_block+0xf8>
  803d3c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803d3f:	c1 e0 04             	shl    $0x4,%eax
  803d42:	8d 90 80 d0 81 00    	lea    0x81d080(%eax),%edx
  803d48:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803d4b:	89 02                	mov    %eax,(%edx)
  803d4d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803d50:	c1 e0 04             	shl    $0x4,%eax
  803d53:	8d 90 84 d0 81 00    	lea    0x81d084(%eax),%edx
  803d59:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803d5c:	89 02                	mov    %eax,(%edx)
  803d5e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803d61:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803d67:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803d6a:	c1 e0 04             	shl    $0x4,%eax
  803d6d:	05 8c d0 81 00       	add    $0x81d08c,%eax
  803d72:	8b 00                	mov    (%eax),%eax
  803d74:	8d 50 01             	lea    0x1(%eax),%edx
  803d77:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803d7a:	c1 e0 04             	shl    $0x4,%eax
  803d7d:	05 8c d0 81 00       	add    $0x81d08c,%eax
  803d82:	89 10                	mov    %edx,(%eax)
	// b3d ma wdytha fy el freeBlockLists hzwed elfree elly fy el array 1
	pageBlockInfoArr[page_index].num_of_free_blocks++;
  803d84:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803d87:	89 d0                	mov    %edx,%eax
  803d89:	01 c0                	add    %eax,%eax
  803d8b:	01 d0                	add    %edx,%eax
  803d8d:	c1 e0 02             	shl    $0x2,%eax
  803d90:	05 6a 50 80 00       	add    $0x80506a,%eax
  803d95:	66 8b 00             	mov    (%eax),%ax
  803d98:	8d 50 01             	lea    0x1(%eax),%edx
  803d9b:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  803d9e:	89 c8                	mov    %ecx,%eax
  803da0:	01 c0                	add    %eax,%eax
  803da2:	01 c8                	add    %ecx,%eax
  803da4:	c1 e0 02             	shl    $0x2,%eax
  803da7:	05 6a 50 80 00       	add    $0x80506a,%eax
  803dac:	66 89 10             	mov    %dx,(%eax)
	int blocks_number = PAGE_SIZE / block_size;
  803daf:	b8 00 10 00 00       	mov    $0x1000,%eax
  803db4:	ba 00 00 00 00       	mov    $0x0,%edx
  803db9:	f7 75 ec             	divl   -0x14(%ebp)
  803dbc:	89 45 e0             	mov    %eax,-0x20(%ebp)
	if(pageBlockInfoArr[page_index].num_of_free_blocks == blocks_number){
  803dbf:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803dc2:	89 d0                	mov    %edx,%eax
  803dc4:	01 c0                	add    %eax,%eax
  803dc6:	01 d0                	add    %edx,%eax
  803dc8:	c1 e0 02             	shl    $0x2,%eax
  803dcb:	05 6a 50 80 00       	add    $0x80506a,%eax
  803dd0:	66 8b 00             	mov    (%eax),%ax
  803dd3:	0f b7 c0             	movzwl %ax,%eax
  803dd6:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  803dd9:	0f 85 d3 01 00 00    	jne    803fb2 <free_block+0x35d>
		struct BlockElement *itr = LIST_FIRST(&freeBlockLists[list_index]);
  803ddf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803de2:	c1 e0 04             	shl    $0x4,%eax
  803de5:	05 80 d0 81 00       	add    $0x81d080,%eax
  803dea:	8b 00                	mov    (%eax),%eax
  803dec:	89 45 f4             	mov    %eax,-0xc(%ebp)
		while(itr != NULL){
  803def:	e9 f1 00 00 00       	jmp    803ee5 <free_block+0x290>
			//lw ms7to el pointer mydy34 ->
			struct BlockElement *next = LIST_NEXT(itr);
  803df4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803df7:	8b 00                	mov    (%eax),%eax
  803df9:	89 45 dc             	mov    %eax,-0x24(%ebp)
			uint32 page_beginning_address= dynAllocStart + page_index * PAGE_SIZE;
  803dfc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803dff:	c1 e0 0c             	shl    $0xc,%eax
  803e02:	89 c2                	mov    %eax,%edx
  803e04:	a1 64 d0 81 00       	mov    0x81d064,%eax
  803e09:	01 d0                	add    %edx,%eax
  803e0b:	89 45 d8             	mov    %eax,-0x28(%ebp)
			uint32 page_end_address = dynAllocStart + (page_index +1 )* PAGE_SIZE;
  803e0e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803e11:	40                   	inc    %eax
  803e12:	c1 e0 0c             	shl    $0xc,%eax
  803e15:	89 c2                	mov    %eax,%edx
  803e17:	a1 64 d0 81 00       	mov    0x81d064,%eax
  803e1c:	01 d0                	add    %edx,%eax
  803e1e:	89 45 d4             	mov    %eax,-0x2c(%ebp)

			if((uint32)itr >= page_beginning_address && (uint32)itr < page_end_address){
  803e21:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e24:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  803e27:	0f 82 b8 00 00 00    	jb     803ee5 <free_block+0x290>
  803e2d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e30:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803e33:	0f 83 ac 00 00 00    	jae    803ee5 <free_block+0x290>
				LIST_REMOVE(&freeBlockLists[list_index], itr);
  803e39:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803e3d:	75 17                	jne    803e56 <free_block+0x201>
  803e3f:	83 ec 04             	sub    $0x4,%esp
  803e42:	68 cd 4d 80 00       	push   $0x804dcd
  803e47:	68 e2 00 00 00       	push   $0xe2
  803e4c:	68 93 4d 80 00       	push   $0x804d93
  803e51:	e8 50 c6 ff ff       	call   8004a6 <_panic>
  803e56:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e59:	8b 00                	mov    (%eax),%eax
  803e5b:	85 c0                	test   %eax,%eax
  803e5d:	74 10                	je     803e6f <free_block+0x21a>
  803e5f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e62:	8b 00                	mov    (%eax),%eax
  803e64:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803e67:	8b 52 04             	mov    0x4(%edx),%edx
  803e6a:	89 50 04             	mov    %edx,0x4(%eax)
  803e6d:	eb 14                	jmp    803e83 <free_block+0x22e>
  803e6f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e72:	8b 40 04             	mov    0x4(%eax),%eax
  803e75:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803e78:	c1 e2 04             	shl    $0x4,%edx
  803e7b:	81 c2 84 d0 81 00    	add    $0x81d084,%edx
  803e81:	89 02                	mov    %eax,(%edx)
  803e83:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e86:	8b 40 04             	mov    0x4(%eax),%eax
  803e89:	85 c0                	test   %eax,%eax
  803e8b:	74 0f                	je     803e9c <free_block+0x247>
  803e8d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e90:	8b 40 04             	mov    0x4(%eax),%eax
  803e93:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803e96:	8b 12                	mov    (%edx),%edx
  803e98:	89 10                	mov    %edx,(%eax)
  803e9a:	eb 13                	jmp    803eaf <free_block+0x25a>
  803e9c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e9f:	8b 00                	mov    (%eax),%eax
  803ea1:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803ea4:	c1 e2 04             	shl    $0x4,%edx
  803ea7:	81 c2 80 d0 81 00    	add    $0x81d080,%edx
  803ead:	89 02                	mov    %eax,(%edx)
  803eaf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803eb2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803eb8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ebb:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803ec2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803ec5:	c1 e0 04             	shl    $0x4,%eax
  803ec8:	05 8c d0 81 00       	add    $0x81d08c,%eax
  803ecd:	8b 00                	mov    (%eax),%eax
  803ecf:	8d 50 ff             	lea    -0x1(%eax),%edx
  803ed2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803ed5:	c1 e0 04             	shl    $0x4,%eax
  803ed8:	05 8c d0 81 00       	add    $0x81d08c,%eax
  803edd:	89 10                	mov    %edx,(%eax)
				//y5o4 3la elly b3do
				itr = next;
  803edf:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803ee2:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// b3d ma wdytha fy el freeBlockLists hzwed elfree elly fy el array 1
	pageBlockInfoArr[page_index].num_of_free_blocks++;
	int blocks_number = PAGE_SIZE / block_size;
	if(pageBlockInfoArr[page_index].num_of_free_blocks == blocks_number){
		struct BlockElement *itr = LIST_FIRST(&freeBlockLists[list_index]);
		while(itr != NULL){
  803ee5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803ee9:	0f 85 05 ff ff ff    	jne    803df4 <free_block+0x19f>
				LIST_REMOVE(&freeBlockLists[list_index], itr);
				//y5o4 3la elly b3do
				itr = next;
			}
		}
		pageBlockInfoArr[page_index].block_size=0;
  803eef:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803ef2:	89 d0                	mov    %edx,%eax
  803ef4:	01 c0                	add    %eax,%eax
  803ef6:	01 d0                	add    %edx,%eax
  803ef8:	c1 e0 02             	shl    $0x2,%eax
  803efb:	05 68 50 80 00       	add    $0x805068,%eax
  803f00:	66 c7 00 00 00       	movw   $0x0,(%eax)
		pageBlockInfoArr[page_index].num_of_free_blocks=0;
  803f05:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803f08:	89 d0                	mov    %edx,%eax
  803f0a:	01 c0                	add    %eax,%eax
  803f0c:	01 d0                	add    %edx,%eax
  803f0e:	c1 e0 02             	shl    $0x2,%eax
  803f11:	05 6a 50 80 00       	add    $0x80506a,%eax
  803f16:	66 c7 00 00 00       	movw   $0x0,(%eax)

		struct PageInfoElement *page_info = &pageBlockInfoArr[page_index];
  803f1b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803f1e:	89 d0                	mov    %edx,%eax
  803f20:	01 c0                	add    %eax,%eax
  803f22:	01 d0                	add    %edx,%eax
  803f24:	c1 e0 02             	shl    $0x2,%eax
  803f27:	05 60 50 80 00       	add    $0x805060,%eax
  803f2c:	89 45 d0             	mov    %eax,-0x30(%ebp)
		LIST_INSERT_TAIL(&freePagesList, page_info);
  803f2f:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  803f33:	75 17                	jne    803f4c <free_block+0x2f7>
  803f35:	83 ec 04             	sub    $0x4,%esp
  803f38:	68 ec 4d 80 00       	push   $0x804dec
  803f3d:	68 eb 00 00 00       	push   $0xeb
  803f42:	68 93 4d 80 00       	push   $0x804d93
  803f47:	e8 5a c5 ff ff       	call   8004a6 <_panic>
  803f4c:	8b 15 4c 50 80 00    	mov    0x80504c,%edx
  803f52:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803f55:	89 50 04             	mov    %edx,0x4(%eax)
  803f58:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803f5b:	8b 40 04             	mov    0x4(%eax),%eax
  803f5e:	85 c0                	test   %eax,%eax
  803f60:	74 0c                	je     803f6e <free_block+0x319>
  803f62:	a1 4c 50 80 00       	mov    0x80504c,%eax
  803f67:	8b 55 d0             	mov    -0x30(%ebp),%edx
  803f6a:	89 10                	mov    %edx,(%eax)
  803f6c:	eb 08                	jmp    803f76 <free_block+0x321>
  803f6e:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803f71:	a3 48 50 80 00       	mov    %eax,0x805048
  803f76:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803f79:	a3 4c 50 80 00       	mov    %eax,0x80504c
  803f7e:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803f81:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803f87:	a1 54 50 80 00       	mov    0x805054,%eax
  803f8c:	40                   	inc    %eax
  803f8d:	a3 54 50 80 00       	mov    %eax,0x805054
		uint32 page_va = to_page_va(page_info);
  803f92:	83 ec 0c             	sub    $0xc,%esp
  803f95:	ff 75 d0             	pushl  -0x30(%ebp)
  803f98:	e8 ce f5 ff ff       	call   80356b <to_page_va>
  803f9d:	83 c4 10             	add    $0x10,%esp
  803fa0:	89 45 cc             	mov    %eax,-0x34(%ebp)
		return_page((void *)page_va);
  803fa3:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803fa6:	83 ec 0c             	sub    $0xc,%esp
  803fa9:	50                   	push   %eax
  803faa:	e8 9e d7 ff ff       	call   80174d <return_page>
  803faf:	83 c4 10             	add    $0x10,%esp
	}


	//Comment the following line
	//panic("free_block() Not implemented yet");
}
  803fb2:	90                   	nop
  803fb3:	c9                   	leave  
  803fb4:	c3                   	ret    

00803fb5 <realloc_block>:

//===========================
// [1] REALLOCATE BLOCK:
//===========================
void *realloc_block(void* va, uint32 new_size)
{
  803fb5:	55                   	push   %ebp
  803fb6:	89 e5                	mov    %esp,%ebp
  803fb8:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.BONUS#2] KERNEL REALLOC - realloc_block
	//Your code is here
	//Comment the following line
	panic("realloc_block() Not implemented yet");
  803fbb:	83 ec 04             	sub    $0x4,%esp
  803fbe:	68 8c 4e 80 00       	push   $0x804e8c
  803fc3:	68 01 01 00 00       	push   $0x101
  803fc8:	68 93 4d 80 00       	push   $0x804d93
  803fcd:	e8 d4 c4 ff ff       	call   8004a6 <_panic>

00803fd2 <init_uspinlock>:
#include "inc/uspinlock.h"

extern volatile struct Env *myEnv;

void init_uspinlock(struct uspinlock *lk, char *name, bool isOpened)
{
  803fd2:	55                   	push   %ebp
  803fd3:	89 e5                	mov    %esp,%ebp
  803fd5:	83 ec 08             	sub    $0x8,%esp
	assert(isOpened == 0 || isOpened == 1);
  803fd8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  803fdc:	74 1c                	je     803ffa <init_uspinlock+0x28>
  803fde:	83 7d 10 01          	cmpl   $0x1,0x10(%ebp)
  803fe2:	74 16                	je     803ffa <init_uspinlock+0x28>
  803fe4:	68 b0 4e 80 00       	push   $0x804eb0
  803fe9:	68 cf 4e 80 00       	push   $0x804ecf
  803fee:	6a 10                	push   $0x10
  803ff0:	68 e4 4e 80 00       	push   $0x804ee4
  803ff5:	e8 ac c4 ff ff       	call   8004a6 <_panic>
	strcpy(lk->name, name);
  803ffa:	8b 45 08             	mov    0x8(%ebp),%eax
  803ffd:	83 c0 04             	add    $0x4,%eax
  804000:	83 ec 08             	sub    $0x8,%esp
  804003:	ff 75 0c             	pushl  0xc(%ebp)
  804006:	50                   	push   %eax
  804007:	e8 90 ce ff ff       	call   800e9c <strcpy>
  80400c:	83 c4 10             	add    $0x10,%esp
	lk->locked = (1 - isOpened);
  80400f:	b8 01 00 00 00       	mov    $0x1,%eax
  804014:	2b 45 10             	sub    0x10(%ebp),%eax
  804017:	89 c2                	mov    %eax,%edx
  804019:	8b 45 08             	mov    0x8(%ebp),%eax
  80401c:	89 10                	mov    %edx,(%eax)
}
  80401e:	90                   	nop
  80401f:	c9                   	leave  
  804020:	c3                   	ret    

00804021 <acquire_uspinlock>:
// Acquire the lock.
// Loops (spins) until the lock is acquired.
// Holding a lock for a long time may cause
// other CPUs to waste time spinning to acquire it.
void acquire_uspinlock(struct uspinlock *lk)
{
  804021:	55                   	push   %ebp
  804022:	89 e5                	mov    %esp,%ebp
  804024:	83 ec 18             	sub    $0x18,%esp
	// The xchg is atomic.
	while(xchg(&lk->locked, 1) != 0) ;
  804027:	90                   	nop
  804028:	8b 45 08             	mov    0x8(%ebp),%eax
  80402b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80402e:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
xchg(volatile uint32 *addr, uint32 newval)
{
  uint32 result;

  // The + in "+m" denotes a read-modify-write operand.
  __asm __volatile("lock; xchgl %0, %1" :
  804035:	8b 55 f4             	mov    -0xc(%ebp),%edx
  804038:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80403b:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  80403e:	f0 87 02             	lock xchg %eax,(%edx)
  804041:	89 45 ec             	mov    %eax,-0x14(%ebp)
               "+m" (*addr), "=a" (result) :
               "1" (newval) :
               "cc");
  return result;
  804044:	8b 45 ec             	mov    -0x14(%ebp),%eax
  804047:	85 c0                	test   %eax,%eax
  804049:	75 dd                	jne    804028 <acquire_uspinlock+0x7>

	cprintf("[%d: %s] ACQUIRED spinlock [%s]\n", myEnv->env_id, myEnv->prog_name, lk->name);
  80404b:	8b 45 08             	mov    0x8(%ebp),%eax
  80404e:	8d 48 04             	lea    0x4(%eax),%ecx
  804051:	a1 20 50 80 00       	mov    0x805020,%eax
  804056:	8d 50 20             	lea    0x20(%eax),%edx
  804059:	a1 20 50 80 00       	mov    0x805020,%eax
  80405e:	8b 40 10             	mov    0x10(%eax),%eax
  804061:	51                   	push   %ecx
  804062:	52                   	push   %edx
  804063:	50                   	push   %eax
  804064:	68 f4 4e 80 00       	push   $0x804ef4
  804069:	e8 06 c7 ff ff       	call   800774 <cprintf>
  80406e:	83 c4 10             	add    $0x10,%esp

	// Tell the C compiler and the processor to not move loads or stores
	// past this point, to ensure that the critical section's memory
	// references happen after the lock is acquired.
	__sync_synchronize();
  804071:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
}
  804076:	90                   	nop
  804077:	c9                   	leave  
  804078:	c3                   	ret    

00804079 <release_uspinlock>:

// Release the lock.
void release_uspinlock(struct uspinlock *lk)
{
  804079:	55                   	push   %ebp
  80407a:	89 e5                	mov    %esp,%ebp
  80407c:	83 ec 08             	sub    $0x8,%esp
	if(!(lk->locked))
  80407f:	8b 45 08             	mov    0x8(%ebp),%eax
  804082:	8b 00                	mov    (%eax),%eax
  804084:	85 c0                	test   %eax,%eax
  804086:	75 18                	jne    8040a0 <release_uspinlock+0x27>
	{
		panic("release: lock \"%s\" is not held!", lk->name);
  804088:	8b 45 08             	mov    0x8(%ebp),%eax
  80408b:	83 c0 04             	add    $0x4,%eax
  80408e:	50                   	push   %eax
  80408f:	68 18 4f 80 00       	push   $0x804f18
  804094:	6a 2b                	push   $0x2b
  804096:	68 e4 4e 80 00       	push   $0x804ee4
  80409b:	e8 06 c4 ff ff       	call   8004a6 <_panic>
	// Tell the C compiler and the processor to not move loads or stores
	// past this point, to ensure that all the stores in the critical
	// section are visible to other cores before the lock is released.
	// Both the C compiler and the hardware may re-order loads and
	// stores; __sync_synchronize() tells them both not to.
	__sync_synchronize();
  8040a0:	f0 83 0c 24 00       	lock orl $0x0,(%esp)

	// Release the lock, equivalent to lk->locked = 0.
	// This code can't use a C assignment, since it might
	// not be atomic. A real OS would use C atomics here.
	asm volatile("movl $0, %0" : "+m" (lk->locked) : );
  8040a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8040a8:	8b 55 08             	mov    0x8(%ebp),%edx
  8040ab:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	cprintf("[%d: %s] RELEASED spinlock [%s]\n", myEnv->env_id, myEnv->prog_name, lk->name);
  8040b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8040b4:	8d 48 04             	lea    0x4(%eax),%ecx
  8040b7:	a1 20 50 80 00       	mov    0x805020,%eax
  8040bc:	8d 50 20             	lea    0x20(%eax),%edx
  8040bf:	a1 20 50 80 00       	mov    0x805020,%eax
  8040c4:	8b 40 10             	mov    0x10(%eax),%eax
  8040c7:	51                   	push   %ecx
  8040c8:	52                   	push   %edx
  8040c9:	50                   	push   %eax
  8040ca:	68 38 4f 80 00       	push   $0x804f38
  8040cf:	e8 a0 c6 ff ff       	call   800774 <cprintf>
  8040d4:	83 c4 10             	add    $0x10,%esp
}
  8040d7:	90                   	nop
  8040d8:	c9                   	leave  
  8040d9:	c3                   	ret    
  8040da:	66 90                	xchg   %ax,%ax

008040dc <__udivdi3>:
  8040dc:	55                   	push   %ebp
  8040dd:	57                   	push   %edi
  8040de:	56                   	push   %esi
  8040df:	53                   	push   %ebx
  8040e0:	83 ec 1c             	sub    $0x1c,%esp
  8040e3:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8040e7:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8040eb:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8040ef:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8040f3:	89 ca                	mov    %ecx,%edx
  8040f5:	89 f8                	mov    %edi,%eax
  8040f7:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8040fb:	85 f6                	test   %esi,%esi
  8040fd:	75 2d                	jne    80412c <__udivdi3+0x50>
  8040ff:	39 cf                	cmp    %ecx,%edi
  804101:	77 65                	ja     804168 <__udivdi3+0x8c>
  804103:	89 fd                	mov    %edi,%ebp
  804105:	85 ff                	test   %edi,%edi
  804107:	75 0b                	jne    804114 <__udivdi3+0x38>
  804109:	b8 01 00 00 00       	mov    $0x1,%eax
  80410e:	31 d2                	xor    %edx,%edx
  804110:	f7 f7                	div    %edi
  804112:	89 c5                	mov    %eax,%ebp
  804114:	31 d2                	xor    %edx,%edx
  804116:	89 c8                	mov    %ecx,%eax
  804118:	f7 f5                	div    %ebp
  80411a:	89 c1                	mov    %eax,%ecx
  80411c:	89 d8                	mov    %ebx,%eax
  80411e:	f7 f5                	div    %ebp
  804120:	89 cf                	mov    %ecx,%edi
  804122:	89 fa                	mov    %edi,%edx
  804124:	83 c4 1c             	add    $0x1c,%esp
  804127:	5b                   	pop    %ebx
  804128:	5e                   	pop    %esi
  804129:	5f                   	pop    %edi
  80412a:	5d                   	pop    %ebp
  80412b:	c3                   	ret    
  80412c:	39 ce                	cmp    %ecx,%esi
  80412e:	77 28                	ja     804158 <__udivdi3+0x7c>
  804130:	0f bd fe             	bsr    %esi,%edi
  804133:	83 f7 1f             	xor    $0x1f,%edi
  804136:	75 40                	jne    804178 <__udivdi3+0x9c>
  804138:	39 ce                	cmp    %ecx,%esi
  80413a:	72 0a                	jb     804146 <__udivdi3+0x6a>
  80413c:	3b 44 24 08          	cmp    0x8(%esp),%eax
  804140:	0f 87 9e 00 00 00    	ja     8041e4 <__udivdi3+0x108>
  804146:	b8 01 00 00 00       	mov    $0x1,%eax
  80414b:	89 fa                	mov    %edi,%edx
  80414d:	83 c4 1c             	add    $0x1c,%esp
  804150:	5b                   	pop    %ebx
  804151:	5e                   	pop    %esi
  804152:	5f                   	pop    %edi
  804153:	5d                   	pop    %ebp
  804154:	c3                   	ret    
  804155:	8d 76 00             	lea    0x0(%esi),%esi
  804158:	31 ff                	xor    %edi,%edi
  80415a:	31 c0                	xor    %eax,%eax
  80415c:	89 fa                	mov    %edi,%edx
  80415e:	83 c4 1c             	add    $0x1c,%esp
  804161:	5b                   	pop    %ebx
  804162:	5e                   	pop    %esi
  804163:	5f                   	pop    %edi
  804164:	5d                   	pop    %ebp
  804165:	c3                   	ret    
  804166:	66 90                	xchg   %ax,%ax
  804168:	89 d8                	mov    %ebx,%eax
  80416a:	f7 f7                	div    %edi
  80416c:	31 ff                	xor    %edi,%edi
  80416e:	89 fa                	mov    %edi,%edx
  804170:	83 c4 1c             	add    $0x1c,%esp
  804173:	5b                   	pop    %ebx
  804174:	5e                   	pop    %esi
  804175:	5f                   	pop    %edi
  804176:	5d                   	pop    %ebp
  804177:	c3                   	ret    
  804178:	bd 20 00 00 00       	mov    $0x20,%ebp
  80417d:	89 eb                	mov    %ebp,%ebx
  80417f:	29 fb                	sub    %edi,%ebx
  804181:	89 f9                	mov    %edi,%ecx
  804183:	d3 e6                	shl    %cl,%esi
  804185:	89 c5                	mov    %eax,%ebp
  804187:	88 d9                	mov    %bl,%cl
  804189:	d3 ed                	shr    %cl,%ebp
  80418b:	89 e9                	mov    %ebp,%ecx
  80418d:	09 f1                	or     %esi,%ecx
  80418f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  804193:	89 f9                	mov    %edi,%ecx
  804195:	d3 e0                	shl    %cl,%eax
  804197:	89 c5                	mov    %eax,%ebp
  804199:	89 d6                	mov    %edx,%esi
  80419b:	88 d9                	mov    %bl,%cl
  80419d:	d3 ee                	shr    %cl,%esi
  80419f:	89 f9                	mov    %edi,%ecx
  8041a1:	d3 e2                	shl    %cl,%edx
  8041a3:	8b 44 24 08          	mov    0x8(%esp),%eax
  8041a7:	88 d9                	mov    %bl,%cl
  8041a9:	d3 e8                	shr    %cl,%eax
  8041ab:	09 c2                	or     %eax,%edx
  8041ad:	89 d0                	mov    %edx,%eax
  8041af:	89 f2                	mov    %esi,%edx
  8041b1:	f7 74 24 0c          	divl   0xc(%esp)
  8041b5:	89 d6                	mov    %edx,%esi
  8041b7:	89 c3                	mov    %eax,%ebx
  8041b9:	f7 e5                	mul    %ebp
  8041bb:	39 d6                	cmp    %edx,%esi
  8041bd:	72 19                	jb     8041d8 <__udivdi3+0xfc>
  8041bf:	74 0b                	je     8041cc <__udivdi3+0xf0>
  8041c1:	89 d8                	mov    %ebx,%eax
  8041c3:	31 ff                	xor    %edi,%edi
  8041c5:	e9 58 ff ff ff       	jmp    804122 <__udivdi3+0x46>
  8041ca:	66 90                	xchg   %ax,%ax
  8041cc:	8b 54 24 08          	mov    0x8(%esp),%edx
  8041d0:	89 f9                	mov    %edi,%ecx
  8041d2:	d3 e2                	shl    %cl,%edx
  8041d4:	39 c2                	cmp    %eax,%edx
  8041d6:	73 e9                	jae    8041c1 <__udivdi3+0xe5>
  8041d8:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8041db:	31 ff                	xor    %edi,%edi
  8041dd:	e9 40 ff ff ff       	jmp    804122 <__udivdi3+0x46>
  8041e2:	66 90                	xchg   %ax,%ax
  8041e4:	31 c0                	xor    %eax,%eax
  8041e6:	e9 37 ff ff ff       	jmp    804122 <__udivdi3+0x46>
  8041eb:	90                   	nop

008041ec <__umoddi3>:
  8041ec:	55                   	push   %ebp
  8041ed:	57                   	push   %edi
  8041ee:	56                   	push   %esi
  8041ef:	53                   	push   %ebx
  8041f0:	83 ec 1c             	sub    $0x1c,%esp
  8041f3:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8041f7:	8b 74 24 34          	mov    0x34(%esp),%esi
  8041fb:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8041ff:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  804203:	89 44 24 0c          	mov    %eax,0xc(%esp)
  804207:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80420b:	89 f3                	mov    %esi,%ebx
  80420d:	89 fa                	mov    %edi,%edx
  80420f:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  804213:	89 34 24             	mov    %esi,(%esp)
  804216:	85 c0                	test   %eax,%eax
  804218:	75 1a                	jne    804234 <__umoddi3+0x48>
  80421a:	39 f7                	cmp    %esi,%edi
  80421c:	0f 86 a2 00 00 00    	jbe    8042c4 <__umoddi3+0xd8>
  804222:	89 c8                	mov    %ecx,%eax
  804224:	89 f2                	mov    %esi,%edx
  804226:	f7 f7                	div    %edi
  804228:	89 d0                	mov    %edx,%eax
  80422a:	31 d2                	xor    %edx,%edx
  80422c:	83 c4 1c             	add    $0x1c,%esp
  80422f:	5b                   	pop    %ebx
  804230:	5e                   	pop    %esi
  804231:	5f                   	pop    %edi
  804232:	5d                   	pop    %ebp
  804233:	c3                   	ret    
  804234:	39 f0                	cmp    %esi,%eax
  804236:	0f 87 ac 00 00 00    	ja     8042e8 <__umoddi3+0xfc>
  80423c:	0f bd e8             	bsr    %eax,%ebp
  80423f:	83 f5 1f             	xor    $0x1f,%ebp
  804242:	0f 84 ac 00 00 00    	je     8042f4 <__umoddi3+0x108>
  804248:	bf 20 00 00 00       	mov    $0x20,%edi
  80424d:	29 ef                	sub    %ebp,%edi
  80424f:	89 fe                	mov    %edi,%esi
  804251:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  804255:	89 e9                	mov    %ebp,%ecx
  804257:	d3 e0                	shl    %cl,%eax
  804259:	89 d7                	mov    %edx,%edi
  80425b:	89 f1                	mov    %esi,%ecx
  80425d:	d3 ef                	shr    %cl,%edi
  80425f:	09 c7                	or     %eax,%edi
  804261:	89 e9                	mov    %ebp,%ecx
  804263:	d3 e2                	shl    %cl,%edx
  804265:	89 14 24             	mov    %edx,(%esp)
  804268:	89 d8                	mov    %ebx,%eax
  80426a:	d3 e0                	shl    %cl,%eax
  80426c:	89 c2                	mov    %eax,%edx
  80426e:	8b 44 24 08          	mov    0x8(%esp),%eax
  804272:	d3 e0                	shl    %cl,%eax
  804274:	89 44 24 04          	mov    %eax,0x4(%esp)
  804278:	8b 44 24 08          	mov    0x8(%esp),%eax
  80427c:	89 f1                	mov    %esi,%ecx
  80427e:	d3 e8                	shr    %cl,%eax
  804280:	09 d0                	or     %edx,%eax
  804282:	d3 eb                	shr    %cl,%ebx
  804284:	89 da                	mov    %ebx,%edx
  804286:	f7 f7                	div    %edi
  804288:	89 d3                	mov    %edx,%ebx
  80428a:	f7 24 24             	mull   (%esp)
  80428d:	89 c6                	mov    %eax,%esi
  80428f:	89 d1                	mov    %edx,%ecx
  804291:	39 d3                	cmp    %edx,%ebx
  804293:	0f 82 87 00 00 00    	jb     804320 <__umoddi3+0x134>
  804299:	0f 84 91 00 00 00    	je     804330 <__umoddi3+0x144>
  80429f:	8b 54 24 04          	mov    0x4(%esp),%edx
  8042a3:	29 f2                	sub    %esi,%edx
  8042a5:	19 cb                	sbb    %ecx,%ebx
  8042a7:	89 d8                	mov    %ebx,%eax
  8042a9:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8042ad:	d3 e0                	shl    %cl,%eax
  8042af:	89 e9                	mov    %ebp,%ecx
  8042b1:	d3 ea                	shr    %cl,%edx
  8042b3:	09 d0                	or     %edx,%eax
  8042b5:	89 e9                	mov    %ebp,%ecx
  8042b7:	d3 eb                	shr    %cl,%ebx
  8042b9:	89 da                	mov    %ebx,%edx
  8042bb:	83 c4 1c             	add    $0x1c,%esp
  8042be:	5b                   	pop    %ebx
  8042bf:	5e                   	pop    %esi
  8042c0:	5f                   	pop    %edi
  8042c1:	5d                   	pop    %ebp
  8042c2:	c3                   	ret    
  8042c3:	90                   	nop
  8042c4:	89 fd                	mov    %edi,%ebp
  8042c6:	85 ff                	test   %edi,%edi
  8042c8:	75 0b                	jne    8042d5 <__umoddi3+0xe9>
  8042ca:	b8 01 00 00 00       	mov    $0x1,%eax
  8042cf:	31 d2                	xor    %edx,%edx
  8042d1:	f7 f7                	div    %edi
  8042d3:	89 c5                	mov    %eax,%ebp
  8042d5:	89 f0                	mov    %esi,%eax
  8042d7:	31 d2                	xor    %edx,%edx
  8042d9:	f7 f5                	div    %ebp
  8042db:	89 c8                	mov    %ecx,%eax
  8042dd:	f7 f5                	div    %ebp
  8042df:	89 d0                	mov    %edx,%eax
  8042e1:	e9 44 ff ff ff       	jmp    80422a <__umoddi3+0x3e>
  8042e6:	66 90                	xchg   %ax,%ax
  8042e8:	89 c8                	mov    %ecx,%eax
  8042ea:	89 f2                	mov    %esi,%edx
  8042ec:	83 c4 1c             	add    $0x1c,%esp
  8042ef:	5b                   	pop    %ebx
  8042f0:	5e                   	pop    %esi
  8042f1:	5f                   	pop    %edi
  8042f2:	5d                   	pop    %ebp
  8042f3:	c3                   	ret    
  8042f4:	3b 04 24             	cmp    (%esp),%eax
  8042f7:	72 06                	jb     8042ff <__umoddi3+0x113>
  8042f9:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8042fd:	77 0f                	ja     80430e <__umoddi3+0x122>
  8042ff:	89 f2                	mov    %esi,%edx
  804301:	29 f9                	sub    %edi,%ecx
  804303:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  804307:	89 14 24             	mov    %edx,(%esp)
  80430a:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80430e:	8b 44 24 04          	mov    0x4(%esp),%eax
  804312:	8b 14 24             	mov    (%esp),%edx
  804315:	83 c4 1c             	add    $0x1c,%esp
  804318:	5b                   	pop    %ebx
  804319:	5e                   	pop    %esi
  80431a:	5f                   	pop    %edi
  80431b:	5d                   	pop    %ebp
  80431c:	c3                   	ret    
  80431d:	8d 76 00             	lea    0x0(%esi),%esi
  804320:	2b 04 24             	sub    (%esp),%eax
  804323:	19 fa                	sbb    %edi,%edx
  804325:	89 d1                	mov    %edx,%ecx
  804327:	89 c6                	mov    %eax,%esi
  804329:	e9 71 ff ff ff       	jmp    80429f <__umoddi3+0xb3>
  80432e:	66 90                	xchg   %ax,%ax
  804330:	39 44 24 04          	cmp    %eax,0x4(%esp)
  804334:	72 ea                	jb     804320 <__umoddi3+0x134>
  804336:	89 d9                	mov    %ebx,%ecx
  804338:	e9 62 ff ff ff       	jmp    80429f <__umoddi3+0xb3>
