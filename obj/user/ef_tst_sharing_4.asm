
obj/user/ef_tst_sharing_4:     file format elf32-i386


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
  800031:	e8 53 06 00 00       	call   800689 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
// Test the free of shared variables (create_shared_memory)
#include <inc/lib.h>

void
_main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	53                   	push   %ebx
  80003c:	83 ec 64             	sub    $0x64,%esp
	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
#if USE_KHEAP
	{
		if (LIST_SIZE(&(myEnv->page_WS_list)) >= myEnv->page_WS_max_size)
  80003f:	a1 20 60 80 00       	mov    0x806020,%eax
  800044:	8b 90 94 00 00 00    	mov    0x94(%eax),%edx
  80004a:	a1 20 60 80 00       	mov    0x806020,%eax
  80004f:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  800055:	39 c2                	cmp    %eax,%edx
  800057:	72 14                	jb     80006d <_main+0x35>
			panic("Please increase the WS size");
  800059:	83 ec 04             	sub    $0x4,%esp
  80005c:	68 e0 46 80 00       	push   $0x8046e0
  800061:	6a 0b                	push   $0xb
  800063:	68 fc 46 80 00       	push   $0x8046fc
  800068:	e8 d5 07 00 00       	call   800842 <_panic>
#else
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif
	/*=================================================*/

	uint32 pagealloc_start = USER_HEAP_START + DYN_ALLOC_MAX_SIZE + PAGE_SIZE; //UHS + 32MB + 4KB
  80006d:	c7 45 f4 00 10 00 82 	movl   $0x82001000,-0xc(%ebp)
	uint32 *x, *y, *z ;
	int freeFrames, diff, expected;

	cprintf("************************************************\n");
  800074:	83 ec 0c             	sub    $0xc,%esp
  800077:	68 14 47 80 00       	push   $0x804714
  80007c:	e8 8f 0a 00 00       	call   800b10 <cprintf>
  800081:	83 c4 10             	add    $0x10,%esp
	cprintf("MAKE SURE to have a FRESH RUN for this test\n(i.e. don't run any program/test before it)\n");
  800084:	83 ec 0c             	sub    $0xc,%esp
  800087:	68 48 47 80 00       	push   $0x804748
  80008c:	e8 7f 0a 00 00       	call   800b10 <cprintf>
  800091:	83 c4 10             	add    $0x10,%esp
	cprintf("************************************************\n\n\n");
  800094:	83 ec 0c             	sub    $0xc,%esp
  800097:	68 a4 47 80 00       	push   $0x8047a4
  80009c:	e8 6f 0a 00 00       	call   800b10 <cprintf>
  8000a1:	83 c4 10             	add    $0x10,%esp

	int Mega = 1024*1024;
  8000a4:	c7 45 f0 00 00 10 00 	movl   $0x100000,-0x10(%ebp)
	int kilo = 1024;
  8000ab:	c7 45 ec 00 04 00 00 	movl   $0x400,-0x14(%ebp)
	int envID = sys_getenvid();
  8000b2:	e8 74 35 00 00       	call   80362b <sys_getenvid>
  8000b7:	89 45 e8             	mov    %eax,-0x18(%ebp)
	cprintf("STEP A: checking free of a shared object ... [25%]\n");
  8000ba:	83 ec 0c             	sub    $0xc,%esp
  8000bd:	68 d8 47 80 00       	push   $0x8047d8
  8000c2:	e8 49 0a 00 00       	call   800b10 <cprintf>
  8000c7:	83 c4 10             	add    $0x10,%esp
	{
		freeFrames = sys_calculate_free_frames() ;
  8000ca:	e8 ac 33 00 00       	call   80347b <sys_calculate_free_frames>
  8000cf:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		x = smalloc("x", PAGE_SIZE, 1);
  8000d2:	83 ec 04             	sub    $0x4,%esp
  8000d5:	6a 01                	push   $0x1
  8000d7:	68 00 10 00 00       	push   $0x1000
  8000dc:	68 0c 48 80 00       	push   $0x80480c
  8000e1:	e8 d1 26 00 00       	call   8027b7 <smalloc>
  8000e6:	83 c4 10             	add    $0x10,%esp
  8000e9:	89 45 e0             	mov    %eax,-0x20(%ebp)
		if (x != (uint32*)pagealloc_start)
  8000ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8000ef:	39 45 e0             	cmp    %eax,-0x20(%ebp)
  8000f2:	74 14                	je     800108 <_main+0xd0>
		{panic("Returned address is not correct. check the setting of it and/or the updating of the shared_mem_free_address");}
  8000f4:	83 ec 04             	sub    $0x4,%esp
  8000f7:	68 10 48 80 00       	push   $0x804810
  8000fc:	6a 22                	push   $0x22
  8000fe:	68 fc 46 80 00       	push   $0x8046fc
  800103:	e8 3a 07 00 00       	call   800842 <_panic>
		expected = 1+1 ; /*1page +1table*/
  800108:	c7 45 dc 02 00 00 00 	movl   $0x2,-0x24(%ebp)

		/*extra 1 page & 1 table for kernel sbrk (at max) due to sharedObject & frameStorage*/
		/*extra 1 page & 1 table for user sbrk (at max) if creating special DS to manage USER PAGE ALLOC */
		int upperLimit = expected +1+1 +1+1 ;
  80010f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800112:	83 c0 04             	add    $0x4,%eax
  800115:	89 45 d8             	mov    %eax,-0x28(%ebp)
		diff = (freeFrames - sys_calculate_free_frames());
  800118:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  80011b:	e8 5b 33 00 00       	call   80347b <sys_calculate_free_frames>
  800120:	29 c3                	sub    %eax,%ebx
  800122:	89 d8                	mov    %ebx,%eax
  800124:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		if (diff < expected || diff > upperLimit)
  800127:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80012a:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  80012d:	7c 08                	jl     800137 <_main+0xff>
  80012f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800132:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  800135:	7e 24                	jle    80015b <_main+0x123>
			{panic("Wrong allocation (current=%d, expected=%d): make sure that you allocate the required space in the user environment and add its frames to frames_storage", freeFrames - sys_calculate_free_frames(), expected);}
  800137:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  80013a:	e8 3c 33 00 00       	call   80347b <sys_calculate_free_frames>
  80013f:	29 c3                	sub    %eax,%ebx
  800141:	89 d8                	mov    %ebx,%eax
  800143:	83 ec 0c             	sub    $0xc,%esp
  800146:	ff 75 dc             	pushl  -0x24(%ebp)
  800149:	50                   	push   %eax
  80014a:	68 7c 48 80 00       	push   $0x80487c
  80014f:	6a 2a                	push   $0x2a
  800151:	68 fc 46 80 00       	push   $0x8046fc
  800156:	e8 e7 06 00 00       	call   800842 <_panic>

		sfree(x);
  80015b:	83 ec 0c             	sub    $0xc,%esp
  80015e:	ff 75 e0             	pushl  -0x20(%ebp)
  800161:	e8 d9 31 00 00       	call   80333f <sfree>
  800166:	83 c4 10             	add    $0x10,%esp

		int diff2 = (freeFrames - sys_calculate_free_frames());
  800169:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  80016c:	e8 0a 33 00 00       	call   80347b <sys_calculate_free_frames>
  800171:	29 c3                	sub    %eax,%ebx
  800173:	89 d8                	mov    %ebx,%eax
  800175:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (diff2 !=  (diff - expected))
  800178:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80017b:	2b 45 dc             	sub    -0x24(%ebp),%eax
  80017e:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  800181:	74 24                	je     8001a7 <_main+0x16f>
		{panic("Wrong free: revise your freeSharedObject logic. Expected = %d, Actual = %d", expected, (freeFrames - sys_calculate_free_frames()));}
  800183:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  800186:	e8 f0 32 00 00       	call   80347b <sys_calculate_free_frames>
  80018b:	29 c3                	sub    %eax,%ebx
  80018d:	89 d8                	mov    %ebx,%eax
  80018f:	83 ec 0c             	sub    $0xc,%esp
  800192:	50                   	push   %eax
  800193:	ff 75 dc             	pushl  -0x24(%ebp)
  800196:	68 14 49 80 00       	push   $0x804914
  80019b:	6a 30                	push   $0x30
  80019d:	68 fc 46 80 00       	push   $0x8046fc
  8001a2:	e8 9b 06 00 00       	call   800842 <_panic>
	}
	cprintf("Step A completed!!\n\n\n");
  8001a7:	83 ec 0c             	sub    $0xc,%esp
  8001aa:	68 5f 49 80 00       	push   $0x80495f
  8001af:	e8 5c 09 00 00       	call   800b10 <cprintf>
  8001b4:	83 c4 10             	add    $0x10,%esp

	cprintf("STEP B: checking free of 2 shared objects ... [25%]\n");
  8001b7:	83 ec 0c             	sub    $0xc,%esp
  8001ba:	68 78 49 80 00       	push   $0x804978
  8001bf:	e8 4c 09 00 00       	call   800b10 <cprintf>
  8001c4:	83 c4 10             	add    $0x10,%esp
	{
		uint32 *x, *z ;
		freeFrames = sys_calculate_free_frames() ;
  8001c7:	e8 af 32 00 00       	call   80347b <sys_calculate_free_frames>
  8001cc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		z = smalloc("z", PAGE_SIZE, 1);
  8001cf:	83 ec 04             	sub    $0x4,%esp
  8001d2:	6a 01                	push   $0x1
  8001d4:	68 00 10 00 00       	push   $0x1000
  8001d9:	68 ad 49 80 00       	push   $0x8049ad
  8001de:	e8 d4 25 00 00       	call   8027b7 <smalloc>
  8001e3:	83 c4 10             	add    $0x10,%esp
  8001e6:	89 45 cc             	mov    %eax,-0x34(%ebp)
		x = smalloc("x", PAGE_SIZE, 1);
  8001e9:	83 ec 04             	sub    $0x4,%esp
  8001ec:	6a 01                	push   $0x1
  8001ee:	68 00 10 00 00       	push   $0x1000
  8001f3:	68 0c 48 80 00       	push   $0x80480c
  8001f8:	e8 ba 25 00 00       	call   8027b7 <smalloc>
  8001fd:	83 c4 10             	add    $0x10,%esp
  800200:	89 45 c8             	mov    %eax,-0x38(%ebp)

		if(x == NULL)
  800203:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800207:	75 14                	jne    80021d <_main+0x1e5>
		{panic("Wrong free: make sure that you free the shared object by calling free_share_object()");}
  800209:	83 ec 04             	sub    $0x4,%esp
  80020c:	68 b0 49 80 00       	push   $0x8049b0
  800211:	6a 3c                	push   $0x3c
  800213:	68 fc 46 80 00       	push   $0x8046fc
  800218:	e8 25 06 00 00       	call   800842 <_panic>

		expected = 2+1 ; /*2pages +1table*/
  80021d:	c7 45 dc 03 00 00 00 	movl   $0x3,-0x24(%ebp)
		/*extra 1 page for kernel sbrk (at max) due to sharedObject & frameStorage of the 2nd object "x"*/
		/*if creating special DS to manage USER PAGE ALLOC, the prev. created page from STEP A is sufficient */
		int upperLimit = expected +1 ;
  800224:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800227:	40                   	inc    %eax
  800228:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		diff = (freeFrames - sys_calculate_free_frames());
  80022b:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  80022e:	e8 48 32 00 00       	call   80347b <sys_calculate_free_frames>
  800233:	29 c3                	sub    %eax,%ebx
  800235:	89 d8                	mov    %ebx,%eax
  800237:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		if (diff < expected || diff > upperLimit)
  80023a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80023d:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800240:	7c 08                	jl     80024a <_main+0x212>
  800242:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800245:	3b 45 c4             	cmp    -0x3c(%ebp),%eax
  800248:	7e 14                	jle    80025e <_main+0x226>
			{panic("Wrong previous free: make sure that you correctly free shared object before (Step A)");}
  80024a:	83 ec 04             	sub    $0x4,%esp
  80024d:	68 08 4a 80 00       	push   $0x804a08
  800252:	6a 44                	push   $0x44
  800254:	68 fc 46 80 00       	push   $0x8046fc
  800259:	e8 e4 05 00 00       	call   800842 <_panic>

		sfree(z);
  80025e:	83 ec 0c             	sub    $0xc,%esp
  800261:	ff 75 cc             	pushl  -0x34(%ebp)
  800264:	e8 d6 30 00 00       	call   80333f <sfree>
  800269:	83 c4 10             	add    $0x10,%esp

		int diff2 = (freeFrames - sys_calculate_free_frames());
  80026c:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  80026f:	e8 07 32 00 00       	call   80347b <sys_calculate_free_frames>
  800274:	29 c3                	sub    %eax,%ebx
  800276:	89 d8                	mov    %ebx,%eax
  800278:	89 45 c0             	mov    %eax,-0x40(%ebp)
		if (diff2 != (diff - 1 /*1 page*/))
  80027b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80027e:	48                   	dec    %eax
  80027f:	3b 45 c0             	cmp    -0x40(%ebp),%eax
  800282:	74 24                	je     8002a8 <_main+0x270>
		{panic("Wrong free: revise your freeSharedObject logic. Expected = %d, Actual = %d", expected, (freeFrames - sys_calculate_free_frames()));}
  800284:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  800287:	e8 ef 31 00 00       	call   80347b <sys_calculate_free_frames>
  80028c:	29 c3                	sub    %eax,%ebx
  80028e:	89 d8                	mov    %ebx,%eax
  800290:	83 ec 0c             	sub    $0xc,%esp
  800293:	50                   	push   %eax
  800294:	ff 75 dc             	pushl  -0x24(%ebp)
  800297:	68 14 49 80 00       	push   $0x804914
  80029c:	6a 4a                	push   $0x4a
  80029e:	68 fc 46 80 00       	push   $0x8046fc
  8002a3:	e8 9a 05 00 00       	call   800842 <_panic>

		sfree(x);
  8002a8:	83 ec 0c             	sub    $0xc,%esp
  8002ab:	ff 75 c8             	pushl  -0x38(%ebp)
  8002ae:	e8 8c 30 00 00       	call   80333f <sfree>
  8002b3:	83 c4 10             	add    $0x10,%esp

		expected = 0;
  8002b6:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
		int diff3 = (freeFrames - sys_calculate_free_frames());
  8002bd:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  8002c0:	e8 b6 31 00 00       	call   80347b <sys_calculate_free_frames>
  8002c5:	29 c3                	sub    %eax,%ebx
  8002c7:	89 d8                	mov    %ebx,%eax
  8002c9:	89 45 bc             	mov    %eax,-0x44(%ebp)
		if (diff3 != (diff2 - (1+1) /*1 page + 1 table*/))
  8002cc:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8002cf:	83 e8 02             	sub    $0x2,%eax
  8002d2:	3b 45 bc             	cmp    -0x44(%ebp),%eax
  8002d5:	74 24                	je     8002fb <_main+0x2c3>
		{panic("Wrong free: revise your freeSharedObject logic. Expected = %d, Actual = %d", expected, (freeFrames - sys_calculate_free_frames()));}
  8002d7:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  8002da:	e8 9c 31 00 00       	call   80347b <sys_calculate_free_frames>
  8002df:	29 c3                	sub    %eax,%ebx
  8002e1:	89 d8                	mov    %ebx,%eax
  8002e3:	83 ec 0c             	sub    $0xc,%esp
  8002e6:	50                   	push   %eax
  8002e7:	ff 75 dc             	pushl  -0x24(%ebp)
  8002ea:	68 14 49 80 00       	push   $0x804914
  8002ef:	6a 51                	push   $0x51
  8002f1:	68 fc 46 80 00       	push   $0x8046fc
  8002f6:	e8 47 05 00 00       	call   800842 <_panic>

	}
	cprintf("Step B completed!!\n\n\n");
  8002fb:	83 ec 0c             	sub    $0xc,%esp
  8002fe:	68 5d 4a 80 00       	push   $0x804a5d
  800303:	e8 08 08 00 00       	call   800b10 <cprintf>
  800308:	83 c4 10             	add    $0x10,%esp

	cprintf("STEP C: checking range of loop during free... [50%]\n");
  80030b:	83 ec 0c             	sub    $0xc,%esp
  80030e:	68 74 4a 80 00       	push   $0x804a74
  800313:	e8 f8 07 00 00       	call   800b10 <cprintf>
  800318:	83 c4 10             	add    $0x10,%esp
	{
		uint32 *w, *u;
		int freeFrames = sys_calculate_free_frames() ;
  80031b:	e8 5b 31 00 00       	call   80347b <sys_calculate_free_frames>
  800320:	89 45 b8             	mov    %eax,-0x48(%ebp)
		w = smalloc("w", 3 * PAGE_SIZE+1, 1);
  800323:	83 ec 04             	sub    $0x4,%esp
  800326:	6a 01                	push   $0x1
  800328:	68 01 30 00 00       	push   $0x3001
  80032d:	68 a9 4a 80 00       	push   $0x804aa9
  800332:	e8 80 24 00 00       	call   8027b7 <smalloc>
  800337:	83 c4 10             	add    $0x10,%esp
  80033a:	89 45 b4             	mov    %eax,-0x4c(%ebp)
		u = smalloc("u", PAGE_SIZE, 1);
  80033d:	83 ec 04             	sub    $0x4,%esp
  800340:	6a 01                	push   $0x1
  800342:	68 00 10 00 00       	push   $0x1000
  800347:	68 ab 4a 80 00       	push   $0x804aab
  80034c:	e8 66 24 00 00       	call   8027b7 <smalloc>
  800351:	83 c4 10             	add    $0x10,%esp
  800354:	89 45 b0             	mov    %eax,-0x50(%ebp)
		expected = 5+1 ; /*5pages +1table*/
  800357:	c7 45 dc 06 00 00 00 	movl   $0x6,-0x24(%ebp)
		diff = (freeFrames - sys_calculate_free_frames());
  80035e:	8b 5d b8             	mov    -0x48(%ebp),%ebx
  800361:	e8 15 31 00 00       	call   80347b <sys_calculate_free_frames>
  800366:	29 c3                	sub    %eax,%ebx
  800368:	89 d8                	mov    %ebx,%eax
  80036a:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		if (diff != expected)
  80036d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800370:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800373:	74 24                	je     800399 <_main+0x361>
			{panic("Wrong allocation (current=%d, expected=%d): make sure that you allocate the required space in the user environment and add its frames to frames_storage", freeFrames - sys_calculate_free_frames(), expected);}
  800375:	8b 5d b8             	mov    -0x48(%ebp),%ebx
  800378:	e8 fe 30 00 00       	call   80347b <sys_calculate_free_frames>
  80037d:	29 c3                	sub    %eax,%ebx
  80037f:	89 d8                	mov    %ebx,%eax
  800381:	83 ec 0c             	sub    $0xc,%esp
  800384:	ff 75 dc             	pushl  -0x24(%ebp)
  800387:	50                   	push   %eax
  800388:	68 7c 48 80 00       	push   $0x80487c
  80038d:	6a 5f                	push   $0x5f
  80038f:	68 fc 46 80 00       	push   $0x8046fc
  800394:	e8 a9 04 00 00       	call   800842 <_panic>

		sfree(w);
  800399:	83 ec 0c             	sub    $0xc,%esp
  80039c:	ff 75 b4             	pushl  -0x4c(%ebp)
  80039f:	e8 9b 2f 00 00       	call   80333f <sfree>
  8003a4:	83 c4 10             	add    $0x10,%esp

		expected = 1+1 ; /*1page +1table*/
  8003a7:	c7 45 dc 02 00 00 00 	movl   $0x2,-0x24(%ebp)
		diff = (freeFrames - sys_calculate_free_frames());
  8003ae:	8b 5d b8             	mov    -0x48(%ebp),%ebx
  8003b1:	e8 c5 30 00 00       	call   80347b <sys_calculate_free_frames>
  8003b6:	29 c3                	sub    %eax,%ebx
  8003b8:	89 d8                	mov    %ebx,%eax
  8003ba:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		if (diff != expected) {panic("Wrong free: revise your freeSharedObject logic. Expected = %d, Actual = %d", expected, (freeFrames - sys_calculate_free_frames()));}
  8003bd:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8003c0:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8003c3:	74 24                	je     8003e9 <_main+0x3b1>
  8003c5:	8b 5d b8             	mov    -0x48(%ebp),%ebx
  8003c8:	e8 ae 30 00 00       	call   80347b <sys_calculate_free_frames>
  8003cd:	29 c3                	sub    %eax,%ebx
  8003cf:	89 d8                	mov    %ebx,%eax
  8003d1:	83 ec 0c             	sub    $0xc,%esp
  8003d4:	50                   	push   %eax
  8003d5:	ff 75 dc             	pushl  -0x24(%ebp)
  8003d8:	68 14 49 80 00       	push   $0x804914
  8003dd:	6a 65                	push   $0x65
  8003df:	68 fc 46 80 00       	push   $0x8046fc
  8003e4:	e8 59 04 00 00       	call   800842 <_panic>

		uint32 *o;

		o = smalloc("o", 2 * PAGE_SIZE-1,1);
  8003e9:	83 ec 04             	sub    $0x4,%esp
  8003ec:	6a 01                	push   $0x1
  8003ee:	68 ff 1f 00 00       	push   $0x1fff
  8003f3:	68 ad 4a 80 00       	push   $0x804aad
  8003f8:	e8 ba 23 00 00       	call   8027b7 <smalloc>
  8003fd:	83 c4 10             	add    $0x10,%esp
  800400:	89 45 ac             	mov    %eax,-0x54(%ebp)

		expected = 3+1 ; /*3pages +1table*/
  800403:	c7 45 dc 04 00 00 00 	movl   $0x4,-0x24(%ebp)
		diff = (freeFrames - sys_calculate_free_frames());
  80040a:	8b 5d b8             	mov    -0x48(%ebp),%ebx
  80040d:	e8 69 30 00 00       	call   80347b <sys_calculate_free_frames>
  800412:	29 c3                	sub    %eax,%ebx
  800414:	89 d8                	mov    %ebx,%eax
  800416:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		if (diff != expected /*Exact! since it's not expected that to invloke sbrk due to the prev. sfree*/)
  800419:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80041c:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  80041f:	74 24                	je     800445 <_main+0x40d>
			{panic("Wrong allocation (current=%d, expected=%d): make sure that you allocate the required space in the user environment and add its frames to frames_storage", freeFrames - sys_calculate_free_frames(), expected);}
  800421:	8b 5d b8             	mov    -0x48(%ebp),%ebx
  800424:	e8 52 30 00 00       	call   80347b <sys_calculate_free_frames>
  800429:	29 c3                	sub    %eax,%ebx
  80042b:	89 d8                	mov    %ebx,%eax
  80042d:	83 ec 0c             	sub    $0xc,%esp
  800430:	ff 75 dc             	pushl  -0x24(%ebp)
  800433:	50                   	push   %eax
  800434:	68 7c 48 80 00       	push   $0x80487c
  800439:	6a 6e                	push   $0x6e
  80043b:	68 fc 46 80 00       	push   $0x8046fc
  800440:	e8 fd 03 00 00       	call   800842 <_panic>

		sfree(o);
  800445:	83 ec 0c             	sub    $0xc,%esp
  800448:	ff 75 ac             	pushl  -0x54(%ebp)
  80044b:	e8 ef 2e 00 00       	call   80333f <sfree>
  800450:	83 c4 10             	add    $0x10,%esp

		expected = 1+1 ; /*1page +1table*/
  800453:	c7 45 dc 02 00 00 00 	movl   $0x2,-0x24(%ebp)
		diff = (freeFrames - sys_calculate_free_frames());
  80045a:	8b 5d b8             	mov    -0x48(%ebp),%ebx
  80045d:	e8 19 30 00 00       	call   80347b <sys_calculate_free_frames>
  800462:	29 c3                	sub    %eax,%ebx
  800464:	89 d8                	mov    %ebx,%eax
  800466:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		if (diff != expected) {panic("Wrong free: revise your freeSharedObject logic. Expected = %d, Actual = %d", expected, (freeFrames - sys_calculate_free_frames()));}
  800469:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80046c:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  80046f:	74 24                	je     800495 <_main+0x45d>
  800471:	8b 5d b8             	mov    -0x48(%ebp),%ebx
  800474:	e8 02 30 00 00       	call   80347b <sys_calculate_free_frames>
  800479:	29 c3                	sub    %eax,%ebx
  80047b:	89 d8                	mov    %ebx,%eax
  80047d:	83 ec 0c             	sub    $0xc,%esp
  800480:	50                   	push   %eax
  800481:	ff 75 dc             	pushl  -0x24(%ebp)
  800484:	68 14 49 80 00       	push   $0x804914
  800489:	6a 74                	push   $0x74
  80048b:	68 fc 46 80 00       	push   $0x8046fc
  800490:	e8 ad 03 00 00       	call   800842 <_panic>

		sfree(u);
  800495:	83 ec 0c             	sub    $0xc,%esp
  800498:	ff 75 b0             	pushl  -0x50(%ebp)
  80049b:	e8 9f 2e 00 00       	call   80333f <sfree>
  8004a0:	83 c4 10             	add    $0x10,%esp

		expected = 0;
  8004a3:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
		diff = (freeFrames - sys_calculate_free_frames());
  8004aa:	8b 5d b8             	mov    -0x48(%ebp),%ebx
  8004ad:	e8 c9 2f 00 00       	call   80347b <sys_calculate_free_frames>
  8004b2:	29 c3                	sub    %eax,%ebx
  8004b4:	89 d8                	mov    %ebx,%eax
  8004b6:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		if (diff != expected) {panic("Wrong free: revise your freeSharedObject logic. Expected = %d, Actual = %d", expected, (freeFrames - sys_calculate_free_frames()));}
  8004b9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8004bc:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8004bf:	74 24                	je     8004e5 <_main+0x4ad>
  8004c1:	8b 5d b8             	mov    -0x48(%ebp),%ebx
  8004c4:	e8 b2 2f 00 00       	call   80347b <sys_calculate_free_frames>
  8004c9:	29 c3                	sub    %eax,%ebx
  8004cb:	89 d8                	mov    %ebx,%eax
  8004cd:	83 ec 0c             	sub    $0xc,%esp
  8004d0:	50                   	push   %eax
  8004d1:	ff 75 dc             	pushl  -0x24(%ebp)
  8004d4:	68 14 49 80 00       	push   $0x804914
  8004d9:	6a 7a                	push   $0x7a
  8004db:	68 fc 46 80 00       	push   $0x8046fc
  8004e0:	e8 5d 03 00 00       	call   800842 <_panic>

		//Checking boundaries of page tables
		freeFrames = sys_calculate_free_frames() ;
  8004e5:	e8 91 2f 00 00       	call   80347b <sys_calculate_free_frames>
  8004ea:	89 45 b8             	mov    %eax,-0x48(%ebp)
		w = smalloc("w", 3 * Mega - 1*kilo, 1);
  8004ed:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8004f0:	89 c2                	mov    %eax,%edx
  8004f2:	01 d2                	add    %edx,%edx
  8004f4:	01 d0                	add    %edx,%eax
  8004f6:	2b 45 ec             	sub    -0x14(%ebp),%eax
  8004f9:	83 ec 04             	sub    $0x4,%esp
  8004fc:	6a 01                	push   $0x1
  8004fe:	50                   	push   %eax
  8004ff:	68 a9 4a 80 00       	push   $0x804aa9
  800504:	e8 ae 22 00 00       	call   8027b7 <smalloc>
  800509:	83 c4 10             	add    $0x10,%esp
  80050c:	89 45 b4             	mov    %eax,-0x4c(%ebp)
		u = smalloc("u", 7 * Mega - 1*kilo, 1);
  80050f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800512:	89 d0                	mov    %edx,%eax
  800514:	01 c0                	add    %eax,%eax
  800516:	01 d0                	add    %edx,%eax
  800518:	01 c0                	add    %eax,%eax
  80051a:	01 d0                	add    %edx,%eax
  80051c:	2b 45 ec             	sub    -0x14(%ebp),%eax
  80051f:	83 ec 04             	sub    $0x4,%esp
  800522:	6a 01                	push   $0x1
  800524:	50                   	push   %eax
  800525:	68 ab 4a 80 00       	push   $0x804aab
  80052a:	e8 88 22 00 00       	call   8027b7 <smalloc>
  80052f:	83 c4 10             	add    $0x10,%esp
  800532:	89 45 b0             	mov    %eax,-0x50(%ebp)
		o = smalloc("o", 2 * Mega + 1*kilo, 1);
  800535:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800538:	01 c0                	add    %eax,%eax
  80053a:	89 c2                	mov    %eax,%edx
  80053c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80053f:	01 d0                	add    %edx,%eax
  800541:	83 ec 04             	sub    $0x4,%esp
  800544:	6a 01                	push   $0x1
  800546:	50                   	push   %eax
  800547:	68 ad 4a 80 00       	push   $0x804aad
  80054c:	e8 66 22 00 00       	call   8027b7 <smalloc>
  800551:	83 c4 10             	add    $0x10,%esp
  800554:	89 45 ac             	mov    %eax,-0x54(%ebp)

		expected = 3073+4+4 ; /*3073pages +4tables +4pages for framesStorage by Kernel Page Allocator since it exceed 2KB size*/
  800557:	c7 45 dc 09 0c 00 00 	movl   $0xc09,-0x24(%ebp)
		diff = (freeFrames - sys_calculate_free_frames());
  80055e:	8b 5d b8             	mov    -0x48(%ebp),%ebx
  800561:	e8 15 2f 00 00       	call   80347b <sys_calculate_free_frames>
  800566:	29 c3                	sub    %eax,%ebx
  800568:	89 d8                	mov    %ebx,%eax
  80056a:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		if (diff < expected || diff > expected +1+1 /*extra 1 page & 1 table for sbrk (at max)*/)
  80056d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800570:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800573:	7c 0b                	jl     800580 <_main+0x548>
  800575:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800578:	83 c0 02             	add    $0x2,%eax
  80057b:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  80057e:	7d 27                	jge    8005a7 <_main+0x56f>
			{panic("Wrong allocation (current=%d, expected=%d): make sure that you allocate the required space in the user environment and add its frames to frames_storage", freeFrames - sys_calculate_free_frames(), expected);}
  800580:	8b 5d b8             	mov    -0x48(%ebp),%ebx
  800583:	e8 f3 2e 00 00       	call   80347b <sys_calculate_free_frames>
  800588:	29 c3                	sub    %eax,%ebx
  80058a:	89 d8                	mov    %ebx,%eax
  80058c:	83 ec 0c             	sub    $0xc,%esp
  80058f:	ff 75 dc             	pushl  -0x24(%ebp)
  800592:	50                   	push   %eax
  800593:	68 7c 48 80 00       	push   $0x80487c
  800598:	68 85 00 00 00       	push   $0x85
  80059d:	68 fc 46 80 00       	push   $0x8046fc
  8005a2:	e8 9b 02 00 00       	call   800842 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  8005a7:	e8 cf 2e 00 00       	call   80347b <sys_calculate_free_frames>
  8005ac:	89 45 b8             	mov    %eax,-0x48(%ebp)

		sfree(o);
  8005af:	83 ec 0c             	sub    $0xc,%esp
  8005b2:	ff 75 ac             	pushl  -0x54(%ebp)
  8005b5:	e8 85 2d 00 00       	call   80333f <sfree>
  8005ba:	83 c4 10             	add    $0x10,%esp
//		if ((freeFrames - sys_calculate_free_frames()) !=  2560+3+5) {panic("Wrong free: check your logic");

		sfree(w);
  8005bd:	83 ec 0c             	sub    $0xc,%esp
  8005c0:	ff 75 b4             	pushl  -0x4c(%ebp)
  8005c3:	e8 77 2d 00 00       	call   80333f <sfree>
  8005c8:	83 c4 10             	add    $0x10,%esp
//		if ((freeFrames - sys_calculate_free_frames()) !=  1792+3+3) {panic("Wrong free: check your logic");

		sfree(u);
  8005cb:	83 ec 0c             	sub    $0xc,%esp
  8005ce:	ff 75 b0             	pushl  -0x50(%ebp)
  8005d1:	e8 69 2d 00 00       	call   80333f <sfree>
  8005d6:	83 c4 10             	add    $0x10,%esp

		expected = 3073+4+4;
  8005d9:	c7 45 dc 09 0c 00 00 	movl   $0xc09,-0x24(%ebp)
		diff = (sys_calculate_free_frames() - freeFrames);
  8005e0:	e8 96 2e 00 00       	call   80347b <sys_calculate_free_frames>
  8005e5:	89 c2                	mov    %eax,%edx
  8005e7:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8005ea:	29 c2                	sub    %eax,%edx
  8005ec:	89 d0                	mov    %edx,%eax
  8005ee:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		if (diff != expected) {panic("Wrong free: revise your freeSharedObject logic. Expected = %d, Actual = %d", expected, (freeFrames - sys_calculate_free_frames()));}
  8005f1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8005f4:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8005f7:	74 27                	je     800620 <_main+0x5e8>
  8005f9:	8b 5d b8             	mov    -0x48(%ebp),%ebx
  8005fc:	e8 7a 2e 00 00       	call   80347b <sys_calculate_free_frames>
  800601:	29 c3                	sub    %eax,%ebx
  800603:	89 d8                	mov    %ebx,%eax
  800605:	83 ec 0c             	sub    $0xc,%esp
  800608:	50                   	push   %eax
  800609:	ff 75 dc             	pushl  -0x24(%ebp)
  80060c:	68 14 49 80 00       	push   $0x804914
  800611:	68 93 00 00 00       	push   $0x93
  800616:	68 fc 46 80 00       	push   $0x8046fc
  80061b:	e8 22 02 00 00       	call   800842 <_panic>
	}
	cprintf("Step C completed!!\n\n\n");
  800620:	83 ec 0c             	sub    $0xc,%esp
  800623:	68 af 4a 80 00       	push   $0x804aaf
  800628:	e8 e3 04 00 00       	call   800b10 <cprintf>
  80062d:	83 c4 10             	add    $0x10,%esp

	cprintf("Test of freeSharedObjects [4] is finished!!\n\n\n");
  800630:	83 ec 0c             	sub    $0xc,%esp
  800633:	68 c8 4a 80 00       	push   $0x804ac8
  800638:	e8 d3 04 00 00       	call   800b10 <cprintf>
  80063d:	83 c4 10             	add    $0x10,%esp

	int32 parentenvID = sys_getparentenvid();
  800640:	e8 18 30 00 00       	call   80365d <sys_getparentenvid>
  800645:	89 45 a8             	mov    %eax,-0x58(%ebp)
	if(parentenvID > 0)
  800648:	83 7d a8 00          	cmpl   $0x0,-0x58(%ebp)
  80064c:	7e 35                	jle    800683 <_main+0x64b>
	{
		//Get the check-finishing counter
		int *finishedCount = NULL;
  80064e:	c7 45 a4 00 00 00 00 	movl   $0x0,-0x5c(%ebp)
		finishedCount = sget(parentenvID, "finishedCount") ;
  800655:	83 ec 08             	sub    $0x8,%esp
  800658:	68 f7 4a 80 00       	push   $0x804af7
  80065d:	ff 75 a8             	pushl  -0x58(%ebp)
  800660:	e8 f9 26 00 00       	call   802d5e <sget>
  800665:	83 c4 10             	add    $0x10,%esp
  800668:	89 45 a4             	mov    %eax,-0x5c(%ebp)

		//Critical section to protect the shared variable
		sys_lock_cons();
  80066b:	e8 5b 2d 00 00       	call   8033cb <sys_lock_cons>
		{
			(*finishedCount)++ ;
  800670:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  800673:	8b 00                	mov    (%eax),%eax
  800675:	8d 50 01             	lea    0x1(%eax),%edx
  800678:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  80067b:	89 10                	mov    %edx,(%eax)
		}
		sys_unlock_cons();
  80067d:	e8 63 2d 00 00       	call   8033e5 <sys_unlock_cons>
	}
	return;
  800682:	90                   	nop
  800683:	90                   	nop
}
  800684:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800687:	c9                   	leave  
  800688:	c3                   	ret    

00800689 <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  800689:	55                   	push   %ebp
  80068a:	89 e5                	mov    %esp,%ebp
  80068c:	57                   	push   %edi
  80068d:	56                   	push   %esi
  80068e:	53                   	push   %ebx
  80068f:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  800692:	e8 ad 2f 00 00       	call   803644 <sys_getenvindex>
  800697:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  80069a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80069d:	89 d0                	mov    %edx,%eax
  80069f:	c1 e0 02             	shl    $0x2,%eax
  8006a2:	01 d0                	add    %edx,%eax
  8006a4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8006ab:	01 d0                	add    %edx,%eax
  8006ad:	89 c2                	mov    %eax,%edx
  8006af:	c1 e2 04             	shl    $0x4,%edx
  8006b2:	29 c2                	sub    %eax,%edx
  8006b4:	8d 04 95 00 00 00 00 	lea    0x0(,%edx,4),%eax
  8006bb:	89 c2                	mov    %eax,%edx
  8006bd:	8d 82 00 00 c0 ee    	lea    -0x11400000(%edx),%eax
  8006c3:	a3 20 60 80 00       	mov    %eax,0x806020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8006c8:	a1 20 60 80 00       	mov    0x806020,%eax
  8006cd:	8a 40 20             	mov    0x20(%eax),%al
  8006d0:	84 c0                	test   %al,%al
  8006d2:	74 0d                	je     8006e1 <libmain+0x58>
		binaryname = myEnv->prog_name;
  8006d4:	a1 20 60 80 00       	mov    0x806020,%eax
  8006d9:	83 c0 20             	add    $0x20,%eax
  8006dc:	a3 04 60 80 00       	mov    %eax,0x806004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8006e1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8006e5:	7e 0a                	jle    8006f1 <libmain+0x68>
		binaryname = argv[0];
  8006e7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006ea:	8b 00                	mov    (%eax),%eax
  8006ec:	a3 04 60 80 00       	mov    %eax,0x806004

	// call user main routine
	_main(argc, argv);
  8006f1:	83 ec 08             	sub    $0x8,%esp
  8006f4:	ff 75 0c             	pushl  0xc(%ebp)
  8006f7:	ff 75 08             	pushl  0x8(%ebp)
  8006fa:	e8 39 f9 ff ff       	call   800038 <_main>
  8006ff:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  800702:	a1 00 60 80 00       	mov    0x806000,%eax
  800707:	85 c0                	test   %eax,%eax
  800709:	0f 84 01 01 00 00    	je     800810 <libmain+0x187>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  80070f:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  800715:	bb 00 4c 80 00       	mov    $0x804c00,%ebx
  80071a:	ba 0e 00 00 00       	mov    $0xe,%edx
  80071f:	89 c7                	mov    %eax,%edi
  800721:	89 de                	mov    %ebx,%esi
  800723:	89 d1                	mov    %edx,%ecx
  800725:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  800727:	8d 55 8a             	lea    -0x76(%ebp),%edx
  80072a:	b9 56 00 00 00       	mov    $0x56,%ecx
  80072f:	b0 00                	mov    $0x0,%al
  800731:	89 d7                	mov    %edx,%edi
  800733:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  800735:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  80073c:	8d 45 e0             	lea    -0x20(%ebp),%eax
  80073f:	83 ec 08             	sub    $0x8,%esp
  800742:	50                   	push   %eax
  800743:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  800749:	50                   	push   %eax
  80074a:	e8 2b 31 00 00       	call   80387a <sys_utilities>
  80074f:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  800752:	e8 74 2c 00 00       	call   8033cb <sys_lock_cons>
		{
			cprintf("**************************************\n");
  800757:	83 ec 0c             	sub    $0xc,%esp
  80075a:	68 20 4b 80 00       	push   $0x804b20
  80075f:	e8 ac 03 00 00       	call   800b10 <cprintf>
  800764:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  800767:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80076a:	85 c0                	test   %eax,%eax
  80076c:	74 18                	je     800786 <libmain+0xfd>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  80076e:	e8 25 31 00 00       	call   803898 <sys_get_optimal_num_faults>
  800773:	83 ec 08             	sub    $0x8,%esp
  800776:	50                   	push   %eax
  800777:	68 48 4b 80 00       	push   $0x804b48
  80077c:	e8 8f 03 00 00       	call   800b10 <cprintf>
  800781:	83 c4 10             	add    $0x10,%esp
  800784:	eb 59                	jmp    8007df <libmain+0x156>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800786:	a1 20 60 80 00       	mov    0x806020,%eax
  80078b:	8b 90 bc 05 00 00    	mov    0x5bc(%eax),%edx
  800791:	a1 20 60 80 00       	mov    0x806020,%eax
  800796:	8b 80 ac 05 00 00    	mov    0x5ac(%eax),%eax
  80079c:	83 ec 04             	sub    $0x4,%esp
  80079f:	52                   	push   %edx
  8007a0:	50                   	push   %eax
  8007a1:	68 6c 4b 80 00       	push   $0x804b6c
  8007a6:	e8 65 03 00 00       	call   800b10 <cprintf>
  8007ab:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8007ae:	a1 20 60 80 00       	mov    0x806020,%eax
  8007b3:	8b 88 d0 05 00 00    	mov    0x5d0(%eax),%ecx
  8007b9:	a1 20 60 80 00       	mov    0x806020,%eax
  8007be:	8b 90 cc 05 00 00    	mov    0x5cc(%eax),%edx
  8007c4:	a1 20 60 80 00       	mov    0x806020,%eax
  8007c9:	8b 80 c8 05 00 00    	mov    0x5c8(%eax),%eax
  8007cf:	51                   	push   %ecx
  8007d0:	52                   	push   %edx
  8007d1:	50                   	push   %eax
  8007d2:	68 94 4b 80 00       	push   $0x804b94
  8007d7:	e8 34 03 00 00       	call   800b10 <cprintf>
  8007dc:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8007df:	a1 20 60 80 00       	mov    0x806020,%eax
  8007e4:	8b 80 d4 05 00 00    	mov    0x5d4(%eax),%eax
  8007ea:	83 ec 08             	sub    $0x8,%esp
  8007ed:	50                   	push   %eax
  8007ee:	68 ec 4b 80 00       	push   $0x804bec
  8007f3:	e8 18 03 00 00       	call   800b10 <cprintf>
  8007f8:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  8007fb:	83 ec 0c             	sub    $0xc,%esp
  8007fe:	68 20 4b 80 00       	push   $0x804b20
  800803:	e8 08 03 00 00       	call   800b10 <cprintf>
  800808:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  80080b:	e8 d5 2b 00 00       	call   8033e5 <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  800810:	e8 1f 00 00 00       	call   800834 <exit>
}
  800815:	90                   	nop
  800816:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800819:	5b                   	pop    %ebx
  80081a:	5e                   	pop    %esi
  80081b:	5f                   	pop    %edi
  80081c:	5d                   	pop    %ebp
  80081d:	c3                   	ret    

0080081e <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  80081e:	55                   	push   %ebp
  80081f:	89 e5                	mov    %esp,%ebp
  800821:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800824:	83 ec 0c             	sub    $0xc,%esp
  800827:	6a 00                	push   $0x0
  800829:	e8 e2 2d 00 00       	call   803610 <sys_destroy_env>
  80082e:	83 c4 10             	add    $0x10,%esp
}
  800831:	90                   	nop
  800832:	c9                   	leave  
  800833:	c3                   	ret    

00800834 <exit>:

void
exit(void)
{
  800834:	55                   	push   %ebp
  800835:	89 e5                	mov    %esp,%ebp
  800837:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  80083a:	e8 37 2e 00 00       	call   803676 <sys_exit_env>
}
  80083f:	90                   	nop
  800840:	c9                   	leave  
  800841:	c3                   	ret    

00800842 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800842:	55                   	push   %ebp
  800843:	89 e5                	mov    %esp,%ebp
  800845:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800848:	8d 45 10             	lea    0x10(%ebp),%eax
  80084b:	83 c0 04             	add    $0x4,%eax
  80084e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800851:	a1 18 e1 81 00       	mov    0x81e118,%eax
  800856:	85 c0                	test   %eax,%eax
  800858:	74 16                	je     800870 <_panic+0x2e>
		cprintf("%s: ", argv0);
  80085a:	a1 18 e1 81 00       	mov    0x81e118,%eax
  80085f:	83 ec 08             	sub    $0x8,%esp
  800862:	50                   	push   %eax
  800863:	68 64 4c 80 00       	push   $0x804c64
  800868:	e8 a3 02 00 00       	call   800b10 <cprintf>
  80086d:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  800870:	a1 04 60 80 00       	mov    0x806004,%eax
  800875:	83 ec 0c             	sub    $0xc,%esp
  800878:	ff 75 0c             	pushl  0xc(%ebp)
  80087b:	ff 75 08             	pushl  0x8(%ebp)
  80087e:	50                   	push   %eax
  80087f:	68 6c 4c 80 00       	push   $0x804c6c
  800884:	6a 74                	push   $0x74
  800886:	e8 b2 02 00 00       	call   800b3d <cprintf_colored>
  80088b:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  80088e:	8b 45 10             	mov    0x10(%ebp),%eax
  800891:	83 ec 08             	sub    $0x8,%esp
  800894:	ff 75 f4             	pushl  -0xc(%ebp)
  800897:	50                   	push   %eax
  800898:	e8 04 02 00 00       	call   800aa1 <vcprintf>
  80089d:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8008a0:	83 ec 08             	sub    $0x8,%esp
  8008a3:	6a 00                	push   $0x0
  8008a5:	68 94 4c 80 00       	push   $0x804c94
  8008aa:	e8 f2 01 00 00       	call   800aa1 <vcprintf>
  8008af:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8008b2:	e8 7d ff ff ff       	call   800834 <exit>

	// should not return here
	while (1) ;
  8008b7:	eb fe                	jmp    8008b7 <_panic+0x75>

008008b9 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8008b9:	55                   	push   %ebp
  8008ba:	89 e5                	mov    %esp,%ebp
  8008bc:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8008bf:	a1 20 60 80 00       	mov    0x806020,%eax
  8008c4:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8008ca:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008cd:	39 c2                	cmp    %eax,%edx
  8008cf:	74 14                	je     8008e5 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8008d1:	83 ec 04             	sub    $0x4,%esp
  8008d4:	68 98 4c 80 00       	push   $0x804c98
  8008d9:	6a 26                	push   $0x26
  8008db:	68 e4 4c 80 00       	push   $0x804ce4
  8008e0:	e8 5d ff ff ff       	call   800842 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8008e5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8008ec:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8008f3:	e9 c5 00 00 00       	jmp    8009bd <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  8008f8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8008fb:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800902:	8b 45 08             	mov    0x8(%ebp),%eax
  800905:	01 d0                	add    %edx,%eax
  800907:	8b 00                	mov    (%eax),%eax
  800909:	85 c0                	test   %eax,%eax
  80090b:	75 08                	jne    800915 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  80090d:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800910:	e9 a5 00 00 00       	jmp    8009ba <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  800915:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80091c:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800923:	eb 69                	jmp    80098e <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800925:	a1 20 60 80 00       	mov    0x806020,%eax
  80092a:	8b 88 a4 05 00 00    	mov    0x5a4(%eax),%ecx
  800930:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800933:	89 d0                	mov    %edx,%eax
  800935:	01 c0                	add    %eax,%eax
  800937:	01 d0                	add    %edx,%eax
  800939:	c1 e0 03             	shl    $0x3,%eax
  80093c:	01 c8                	add    %ecx,%eax
  80093e:	8a 40 04             	mov    0x4(%eax),%al
  800941:	84 c0                	test   %al,%al
  800943:	75 46                	jne    80098b <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800945:	a1 20 60 80 00       	mov    0x806020,%eax
  80094a:	8b 88 a4 05 00 00    	mov    0x5a4(%eax),%ecx
  800950:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800953:	89 d0                	mov    %edx,%eax
  800955:	01 c0                	add    %eax,%eax
  800957:	01 d0                	add    %edx,%eax
  800959:	c1 e0 03             	shl    $0x3,%eax
  80095c:	01 c8                	add    %ecx,%eax
  80095e:	8b 00                	mov    (%eax),%eax
  800960:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800963:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800966:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80096b:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  80096d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800970:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800977:	8b 45 08             	mov    0x8(%ebp),%eax
  80097a:	01 c8                	add    %ecx,%eax
  80097c:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80097e:	39 c2                	cmp    %eax,%edx
  800980:	75 09                	jne    80098b <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  800982:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800989:	eb 15                	jmp    8009a0 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80098b:	ff 45 e8             	incl   -0x18(%ebp)
  80098e:	a1 20 60 80 00       	mov    0x806020,%eax
  800993:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800999:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80099c:	39 c2                	cmp    %eax,%edx
  80099e:	77 85                	ja     800925 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8009a0:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8009a4:	75 14                	jne    8009ba <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  8009a6:	83 ec 04             	sub    $0x4,%esp
  8009a9:	68 f0 4c 80 00       	push   $0x804cf0
  8009ae:	6a 3a                	push   $0x3a
  8009b0:	68 e4 4c 80 00       	push   $0x804ce4
  8009b5:	e8 88 fe ff ff       	call   800842 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8009ba:	ff 45 f0             	incl   -0x10(%ebp)
  8009bd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009c0:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8009c3:	0f 8c 2f ff ff ff    	jl     8008f8 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8009c9:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8009d0:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8009d7:	eb 26                	jmp    8009ff <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  8009d9:	a1 20 60 80 00       	mov    0x806020,%eax
  8009de:	8b 88 a4 05 00 00    	mov    0x5a4(%eax),%ecx
  8009e4:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8009e7:	89 d0                	mov    %edx,%eax
  8009e9:	01 c0                	add    %eax,%eax
  8009eb:	01 d0                	add    %edx,%eax
  8009ed:	c1 e0 03             	shl    $0x3,%eax
  8009f0:	01 c8                	add    %ecx,%eax
  8009f2:	8a 40 04             	mov    0x4(%eax),%al
  8009f5:	3c 01                	cmp    $0x1,%al
  8009f7:	75 03                	jne    8009fc <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  8009f9:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8009fc:	ff 45 e0             	incl   -0x20(%ebp)
  8009ff:	a1 20 60 80 00       	mov    0x806020,%eax
  800a04:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800a0a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800a0d:	39 c2                	cmp    %eax,%edx
  800a0f:	77 c8                	ja     8009d9 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800a11:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800a14:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800a17:	74 14                	je     800a2d <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  800a19:	83 ec 04             	sub    $0x4,%esp
  800a1c:	68 44 4d 80 00       	push   $0x804d44
  800a21:	6a 44                	push   $0x44
  800a23:	68 e4 4c 80 00       	push   $0x804ce4
  800a28:	e8 15 fe ff ff       	call   800842 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800a2d:	90                   	nop
  800a2e:	c9                   	leave  
  800a2f:	c3                   	ret    

00800a30 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  800a30:	55                   	push   %ebp
  800a31:	89 e5                	mov    %esp,%ebp
  800a33:	53                   	push   %ebx
  800a34:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  800a37:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a3a:	8b 00                	mov    (%eax),%eax
  800a3c:	8d 48 01             	lea    0x1(%eax),%ecx
  800a3f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a42:	89 0a                	mov    %ecx,(%edx)
  800a44:	8b 55 08             	mov    0x8(%ebp),%edx
  800a47:	88 d1                	mov    %dl,%cl
  800a49:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a4c:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800a50:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a53:	8b 00                	mov    (%eax),%eax
  800a55:	3d ff 00 00 00       	cmp    $0xff,%eax
  800a5a:	75 30                	jne    800a8c <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  800a5c:	8b 15 1c e1 81 00    	mov    0x81e11c,%edx
  800a62:	a0 44 60 80 00       	mov    0x806044,%al
  800a67:	0f b6 c0             	movzbl %al,%eax
  800a6a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800a6d:	8b 09                	mov    (%ecx),%ecx
  800a6f:	89 cb                	mov    %ecx,%ebx
  800a71:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800a74:	83 c1 08             	add    $0x8,%ecx
  800a77:	52                   	push   %edx
  800a78:	50                   	push   %eax
  800a79:	53                   	push   %ebx
  800a7a:	51                   	push   %ecx
  800a7b:	e8 07 29 00 00       	call   803387 <sys_cputs>
  800a80:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800a83:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a86:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800a8c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a8f:	8b 40 04             	mov    0x4(%eax),%eax
  800a92:	8d 50 01             	lea    0x1(%eax),%edx
  800a95:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a98:	89 50 04             	mov    %edx,0x4(%eax)
}
  800a9b:	90                   	nop
  800a9c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800a9f:	c9                   	leave  
  800aa0:	c3                   	ret    

00800aa1 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800aa1:	55                   	push   %ebp
  800aa2:	89 e5                	mov    %esp,%ebp
  800aa4:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800aaa:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800ab1:	00 00 00 
	b.cnt = 0;
  800ab4:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800abb:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800abe:	ff 75 0c             	pushl  0xc(%ebp)
  800ac1:	ff 75 08             	pushl  0x8(%ebp)
  800ac4:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800aca:	50                   	push   %eax
  800acb:	68 30 0a 80 00       	push   $0x800a30
  800ad0:	e8 5a 02 00 00       	call   800d2f <vprintfmt>
  800ad5:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  800ad8:	8b 15 1c e1 81 00    	mov    0x81e11c,%edx
  800ade:	a0 44 60 80 00       	mov    0x806044,%al
  800ae3:	0f b6 c0             	movzbl %al,%eax
  800ae6:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  800aec:	52                   	push   %edx
  800aed:	50                   	push   %eax
  800aee:	51                   	push   %ecx
  800aef:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800af5:	83 c0 08             	add    $0x8,%eax
  800af8:	50                   	push   %eax
  800af9:	e8 89 28 00 00       	call   803387 <sys_cputs>
  800afe:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800b01:	c6 05 44 60 80 00 00 	movb   $0x0,0x806044
	return b.cnt;
  800b08:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800b0e:	c9                   	leave  
  800b0f:	c3                   	ret    

00800b10 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  800b10:	55                   	push   %ebp
  800b11:	89 e5                	mov    %esp,%ebp
  800b13:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800b16:	c6 05 44 60 80 00 01 	movb   $0x1,0x806044
	va_start(ap, fmt);
  800b1d:	8d 45 0c             	lea    0xc(%ebp),%eax
  800b20:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800b23:	8b 45 08             	mov    0x8(%ebp),%eax
  800b26:	83 ec 08             	sub    $0x8,%esp
  800b29:	ff 75 f4             	pushl  -0xc(%ebp)
  800b2c:	50                   	push   %eax
  800b2d:	e8 6f ff ff ff       	call   800aa1 <vcprintf>
  800b32:	83 c4 10             	add    $0x10,%esp
  800b35:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800b38:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800b3b:	c9                   	leave  
  800b3c:	c3                   	ret    

00800b3d <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  800b3d:	55                   	push   %ebp
  800b3e:	89 e5                	mov    %esp,%ebp
  800b40:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800b43:	c6 05 44 60 80 00 01 	movb   $0x1,0x806044
	curTextClr = (textClr << 8) ; //set text color by the given value
  800b4a:	8b 45 08             	mov    0x8(%ebp),%eax
  800b4d:	c1 e0 08             	shl    $0x8,%eax
  800b50:	a3 1c e1 81 00       	mov    %eax,0x81e11c
	va_start(ap, fmt);
  800b55:	8d 45 0c             	lea    0xc(%ebp),%eax
  800b58:	83 c0 04             	add    $0x4,%eax
  800b5b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800b5e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b61:	83 ec 08             	sub    $0x8,%esp
  800b64:	ff 75 f4             	pushl  -0xc(%ebp)
  800b67:	50                   	push   %eax
  800b68:	e8 34 ff ff ff       	call   800aa1 <vcprintf>
  800b6d:	83 c4 10             	add    $0x10,%esp
  800b70:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  800b73:	c7 05 1c e1 81 00 00 	movl   $0x700,0x81e11c
  800b7a:	07 00 00 

	return cnt;
  800b7d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800b80:	c9                   	leave  
  800b81:	c3                   	ret    

00800b82 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  800b82:	55                   	push   %ebp
  800b83:	89 e5                	mov    %esp,%ebp
  800b85:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  800b88:	e8 3e 28 00 00       	call   8033cb <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  800b8d:	8d 45 0c             	lea    0xc(%ebp),%eax
  800b90:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  800b93:	8b 45 08             	mov    0x8(%ebp),%eax
  800b96:	83 ec 08             	sub    $0x8,%esp
  800b99:	ff 75 f4             	pushl  -0xc(%ebp)
  800b9c:	50                   	push   %eax
  800b9d:	e8 ff fe ff ff       	call   800aa1 <vcprintf>
  800ba2:	83 c4 10             	add    $0x10,%esp
  800ba5:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  800ba8:	e8 38 28 00 00       	call   8033e5 <sys_unlock_cons>
	return cnt;
  800bad:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800bb0:	c9                   	leave  
  800bb1:	c3                   	ret    

00800bb2 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800bb2:	55                   	push   %ebp
  800bb3:	89 e5                	mov    %esp,%ebp
  800bb5:	53                   	push   %ebx
  800bb6:	83 ec 14             	sub    $0x14,%esp
  800bb9:	8b 45 10             	mov    0x10(%ebp),%eax
  800bbc:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bbf:	8b 45 14             	mov    0x14(%ebp),%eax
  800bc2:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800bc5:	8b 45 18             	mov    0x18(%ebp),%eax
  800bc8:	ba 00 00 00 00       	mov    $0x0,%edx
  800bcd:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800bd0:	77 55                	ja     800c27 <printnum+0x75>
  800bd2:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800bd5:	72 05                	jb     800bdc <printnum+0x2a>
  800bd7:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800bda:	77 4b                	ja     800c27 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800bdc:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800bdf:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800be2:	8b 45 18             	mov    0x18(%ebp),%eax
  800be5:	ba 00 00 00 00       	mov    $0x0,%edx
  800bea:	52                   	push   %edx
  800beb:	50                   	push   %eax
  800bec:	ff 75 f4             	pushl  -0xc(%ebp)
  800bef:	ff 75 f0             	pushl  -0x10(%ebp)
  800bf2:	e8 81 38 00 00       	call   804478 <__udivdi3>
  800bf7:	83 c4 10             	add    $0x10,%esp
  800bfa:	83 ec 04             	sub    $0x4,%esp
  800bfd:	ff 75 20             	pushl  0x20(%ebp)
  800c00:	53                   	push   %ebx
  800c01:	ff 75 18             	pushl  0x18(%ebp)
  800c04:	52                   	push   %edx
  800c05:	50                   	push   %eax
  800c06:	ff 75 0c             	pushl  0xc(%ebp)
  800c09:	ff 75 08             	pushl  0x8(%ebp)
  800c0c:	e8 a1 ff ff ff       	call   800bb2 <printnum>
  800c11:	83 c4 20             	add    $0x20,%esp
  800c14:	eb 1a                	jmp    800c30 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800c16:	83 ec 08             	sub    $0x8,%esp
  800c19:	ff 75 0c             	pushl  0xc(%ebp)
  800c1c:	ff 75 20             	pushl  0x20(%ebp)
  800c1f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c22:	ff d0                	call   *%eax
  800c24:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800c27:	ff 4d 1c             	decl   0x1c(%ebp)
  800c2a:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800c2e:	7f e6                	jg     800c16 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800c30:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800c33:	bb 00 00 00 00       	mov    $0x0,%ebx
  800c38:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c3b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800c3e:	53                   	push   %ebx
  800c3f:	51                   	push   %ecx
  800c40:	52                   	push   %edx
  800c41:	50                   	push   %eax
  800c42:	e8 41 39 00 00       	call   804588 <__umoddi3>
  800c47:	83 c4 10             	add    $0x10,%esp
  800c4a:	05 b4 4f 80 00       	add    $0x804fb4,%eax
  800c4f:	8a 00                	mov    (%eax),%al
  800c51:	0f be c0             	movsbl %al,%eax
  800c54:	83 ec 08             	sub    $0x8,%esp
  800c57:	ff 75 0c             	pushl  0xc(%ebp)
  800c5a:	50                   	push   %eax
  800c5b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c5e:	ff d0                	call   *%eax
  800c60:	83 c4 10             	add    $0x10,%esp
}
  800c63:	90                   	nop
  800c64:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800c67:	c9                   	leave  
  800c68:	c3                   	ret    

00800c69 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800c69:	55                   	push   %ebp
  800c6a:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800c6c:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800c70:	7e 1c                	jle    800c8e <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800c72:	8b 45 08             	mov    0x8(%ebp),%eax
  800c75:	8b 00                	mov    (%eax),%eax
  800c77:	8d 50 08             	lea    0x8(%eax),%edx
  800c7a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c7d:	89 10                	mov    %edx,(%eax)
  800c7f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c82:	8b 00                	mov    (%eax),%eax
  800c84:	83 e8 08             	sub    $0x8,%eax
  800c87:	8b 50 04             	mov    0x4(%eax),%edx
  800c8a:	8b 00                	mov    (%eax),%eax
  800c8c:	eb 40                	jmp    800cce <getuint+0x65>
	else if (lflag)
  800c8e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c92:	74 1e                	je     800cb2 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800c94:	8b 45 08             	mov    0x8(%ebp),%eax
  800c97:	8b 00                	mov    (%eax),%eax
  800c99:	8d 50 04             	lea    0x4(%eax),%edx
  800c9c:	8b 45 08             	mov    0x8(%ebp),%eax
  800c9f:	89 10                	mov    %edx,(%eax)
  800ca1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ca4:	8b 00                	mov    (%eax),%eax
  800ca6:	83 e8 04             	sub    $0x4,%eax
  800ca9:	8b 00                	mov    (%eax),%eax
  800cab:	ba 00 00 00 00       	mov    $0x0,%edx
  800cb0:	eb 1c                	jmp    800cce <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800cb2:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb5:	8b 00                	mov    (%eax),%eax
  800cb7:	8d 50 04             	lea    0x4(%eax),%edx
  800cba:	8b 45 08             	mov    0x8(%ebp),%eax
  800cbd:	89 10                	mov    %edx,(%eax)
  800cbf:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc2:	8b 00                	mov    (%eax),%eax
  800cc4:	83 e8 04             	sub    $0x4,%eax
  800cc7:	8b 00                	mov    (%eax),%eax
  800cc9:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800cce:	5d                   	pop    %ebp
  800ccf:	c3                   	ret    

00800cd0 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800cd0:	55                   	push   %ebp
  800cd1:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800cd3:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800cd7:	7e 1c                	jle    800cf5 <getint+0x25>
		return va_arg(*ap, long long);
  800cd9:	8b 45 08             	mov    0x8(%ebp),%eax
  800cdc:	8b 00                	mov    (%eax),%eax
  800cde:	8d 50 08             	lea    0x8(%eax),%edx
  800ce1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce4:	89 10                	mov    %edx,(%eax)
  800ce6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce9:	8b 00                	mov    (%eax),%eax
  800ceb:	83 e8 08             	sub    $0x8,%eax
  800cee:	8b 50 04             	mov    0x4(%eax),%edx
  800cf1:	8b 00                	mov    (%eax),%eax
  800cf3:	eb 38                	jmp    800d2d <getint+0x5d>
	else if (lflag)
  800cf5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800cf9:	74 1a                	je     800d15 <getint+0x45>
		return va_arg(*ap, long);
  800cfb:	8b 45 08             	mov    0x8(%ebp),%eax
  800cfe:	8b 00                	mov    (%eax),%eax
  800d00:	8d 50 04             	lea    0x4(%eax),%edx
  800d03:	8b 45 08             	mov    0x8(%ebp),%eax
  800d06:	89 10                	mov    %edx,(%eax)
  800d08:	8b 45 08             	mov    0x8(%ebp),%eax
  800d0b:	8b 00                	mov    (%eax),%eax
  800d0d:	83 e8 04             	sub    $0x4,%eax
  800d10:	8b 00                	mov    (%eax),%eax
  800d12:	99                   	cltd   
  800d13:	eb 18                	jmp    800d2d <getint+0x5d>
	else
		return va_arg(*ap, int);
  800d15:	8b 45 08             	mov    0x8(%ebp),%eax
  800d18:	8b 00                	mov    (%eax),%eax
  800d1a:	8d 50 04             	lea    0x4(%eax),%edx
  800d1d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d20:	89 10                	mov    %edx,(%eax)
  800d22:	8b 45 08             	mov    0x8(%ebp),%eax
  800d25:	8b 00                	mov    (%eax),%eax
  800d27:	83 e8 04             	sub    $0x4,%eax
  800d2a:	8b 00                	mov    (%eax),%eax
  800d2c:	99                   	cltd   
}
  800d2d:	5d                   	pop    %ebp
  800d2e:	c3                   	ret    

00800d2f <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800d2f:	55                   	push   %ebp
  800d30:	89 e5                	mov    %esp,%ebp
  800d32:	56                   	push   %esi
  800d33:	53                   	push   %ebx
  800d34:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800d37:	eb 17                	jmp    800d50 <vprintfmt+0x21>
			if (ch == '\0')
  800d39:	85 db                	test   %ebx,%ebx
  800d3b:	0f 84 c1 03 00 00    	je     801102 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  800d41:	83 ec 08             	sub    $0x8,%esp
  800d44:	ff 75 0c             	pushl  0xc(%ebp)
  800d47:	53                   	push   %ebx
  800d48:	8b 45 08             	mov    0x8(%ebp),%eax
  800d4b:	ff d0                	call   *%eax
  800d4d:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800d50:	8b 45 10             	mov    0x10(%ebp),%eax
  800d53:	8d 50 01             	lea    0x1(%eax),%edx
  800d56:	89 55 10             	mov    %edx,0x10(%ebp)
  800d59:	8a 00                	mov    (%eax),%al
  800d5b:	0f b6 d8             	movzbl %al,%ebx
  800d5e:	83 fb 25             	cmp    $0x25,%ebx
  800d61:	75 d6                	jne    800d39 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800d63:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800d67:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800d6e:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800d75:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800d7c:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800d83:	8b 45 10             	mov    0x10(%ebp),%eax
  800d86:	8d 50 01             	lea    0x1(%eax),%edx
  800d89:	89 55 10             	mov    %edx,0x10(%ebp)
  800d8c:	8a 00                	mov    (%eax),%al
  800d8e:	0f b6 d8             	movzbl %al,%ebx
  800d91:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800d94:	83 f8 5b             	cmp    $0x5b,%eax
  800d97:	0f 87 3d 03 00 00    	ja     8010da <vprintfmt+0x3ab>
  800d9d:	8b 04 85 d8 4f 80 00 	mov    0x804fd8(,%eax,4),%eax
  800da4:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800da6:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800daa:	eb d7                	jmp    800d83 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800dac:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800db0:	eb d1                	jmp    800d83 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800db2:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800db9:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800dbc:	89 d0                	mov    %edx,%eax
  800dbe:	c1 e0 02             	shl    $0x2,%eax
  800dc1:	01 d0                	add    %edx,%eax
  800dc3:	01 c0                	add    %eax,%eax
  800dc5:	01 d8                	add    %ebx,%eax
  800dc7:	83 e8 30             	sub    $0x30,%eax
  800dca:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800dcd:	8b 45 10             	mov    0x10(%ebp),%eax
  800dd0:	8a 00                	mov    (%eax),%al
  800dd2:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800dd5:	83 fb 2f             	cmp    $0x2f,%ebx
  800dd8:	7e 3e                	jle    800e18 <vprintfmt+0xe9>
  800dda:	83 fb 39             	cmp    $0x39,%ebx
  800ddd:	7f 39                	jg     800e18 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800ddf:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800de2:	eb d5                	jmp    800db9 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800de4:	8b 45 14             	mov    0x14(%ebp),%eax
  800de7:	83 c0 04             	add    $0x4,%eax
  800dea:	89 45 14             	mov    %eax,0x14(%ebp)
  800ded:	8b 45 14             	mov    0x14(%ebp),%eax
  800df0:	83 e8 04             	sub    $0x4,%eax
  800df3:	8b 00                	mov    (%eax),%eax
  800df5:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800df8:	eb 1f                	jmp    800e19 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800dfa:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800dfe:	79 83                	jns    800d83 <vprintfmt+0x54>
				width = 0;
  800e00:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800e07:	e9 77 ff ff ff       	jmp    800d83 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800e0c:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800e13:	e9 6b ff ff ff       	jmp    800d83 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800e18:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800e19:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800e1d:	0f 89 60 ff ff ff    	jns    800d83 <vprintfmt+0x54>
				width = precision, precision = -1;
  800e23:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800e26:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800e29:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800e30:	e9 4e ff ff ff       	jmp    800d83 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800e35:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800e38:	e9 46 ff ff ff       	jmp    800d83 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800e3d:	8b 45 14             	mov    0x14(%ebp),%eax
  800e40:	83 c0 04             	add    $0x4,%eax
  800e43:	89 45 14             	mov    %eax,0x14(%ebp)
  800e46:	8b 45 14             	mov    0x14(%ebp),%eax
  800e49:	83 e8 04             	sub    $0x4,%eax
  800e4c:	8b 00                	mov    (%eax),%eax
  800e4e:	83 ec 08             	sub    $0x8,%esp
  800e51:	ff 75 0c             	pushl  0xc(%ebp)
  800e54:	50                   	push   %eax
  800e55:	8b 45 08             	mov    0x8(%ebp),%eax
  800e58:	ff d0                	call   *%eax
  800e5a:	83 c4 10             	add    $0x10,%esp
			break;
  800e5d:	e9 9b 02 00 00       	jmp    8010fd <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800e62:	8b 45 14             	mov    0x14(%ebp),%eax
  800e65:	83 c0 04             	add    $0x4,%eax
  800e68:	89 45 14             	mov    %eax,0x14(%ebp)
  800e6b:	8b 45 14             	mov    0x14(%ebp),%eax
  800e6e:	83 e8 04             	sub    $0x4,%eax
  800e71:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800e73:	85 db                	test   %ebx,%ebx
  800e75:	79 02                	jns    800e79 <vprintfmt+0x14a>
				err = -err;
  800e77:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800e79:	83 fb 64             	cmp    $0x64,%ebx
  800e7c:	7f 0b                	jg     800e89 <vprintfmt+0x15a>
  800e7e:	8b 34 9d 20 4e 80 00 	mov    0x804e20(,%ebx,4),%esi
  800e85:	85 f6                	test   %esi,%esi
  800e87:	75 19                	jne    800ea2 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800e89:	53                   	push   %ebx
  800e8a:	68 c5 4f 80 00       	push   $0x804fc5
  800e8f:	ff 75 0c             	pushl  0xc(%ebp)
  800e92:	ff 75 08             	pushl  0x8(%ebp)
  800e95:	e8 70 02 00 00       	call   80110a <printfmt>
  800e9a:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800e9d:	e9 5b 02 00 00       	jmp    8010fd <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800ea2:	56                   	push   %esi
  800ea3:	68 ce 4f 80 00       	push   $0x804fce
  800ea8:	ff 75 0c             	pushl  0xc(%ebp)
  800eab:	ff 75 08             	pushl  0x8(%ebp)
  800eae:	e8 57 02 00 00       	call   80110a <printfmt>
  800eb3:	83 c4 10             	add    $0x10,%esp
			break;
  800eb6:	e9 42 02 00 00       	jmp    8010fd <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800ebb:	8b 45 14             	mov    0x14(%ebp),%eax
  800ebe:	83 c0 04             	add    $0x4,%eax
  800ec1:	89 45 14             	mov    %eax,0x14(%ebp)
  800ec4:	8b 45 14             	mov    0x14(%ebp),%eax
  800ec7:	83 e8 04             	sub    $0x4,%eax
  800eca:	8b 30                	mov    (%eax),%esi
  800ecc:	85 f6                	test   %esi,%esi
  800ece:	75 05                	jne    800ed5 <vprintfmt+0x1a6>
				p = "(null)";
  800ed0:	be d1 4f 80 00       	mov    $0x804fd1,%esi
			if (width > 0 && padc != '-')
  800ed5:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800ed9:	7e 6d                	jle    800f48 <vprintfmt+0x219>
  800edb:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800edf:	74 67                	je     800f48 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800ee1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800ee4:	83 ec 08             	sub    $0x8,%esp
  800ee7:	50                   	push   %eax
  800ee8:	56                   	push   %esi
  800ee9:	e8 1e 03 00 00       	call   80120c <strnlen>
  800eee:	83 c4 10             	add    $0x10,%esp
  800ef1:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800ef4:	eb 16                	jmp    800f0c <vprintfmt+0x1dd>
					putch(padc, putdat);
  800ef6:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800efa:	83 ec 08             	sub    $0x8,%esp
  800efd:	ff 75 0c             	pushl  0xc(%ebp)
  800f00:	50                   	push   %eax
  800f01:	8b 45 08             	mov    0x8(%ebp),%eax
  800f04:	ff d0                	call   *%eax
  800f06:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800f09:	ff 4d e4             	decl   -0x1c(%ebp)
  800f0c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800f10:	7f e4                	jg     800ef6 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800f12:	eb 34                	jmp    800f48 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800f14:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800f18:	74 1c                	je     800f36 <vprintfmt+0x207>
  800f1a:	83 fb 1f             	cmp    $0x1f,%ebx
  800f1d:	7e 05                	jle    800f24 <vprintfmt+0x1f5>
  800f1f:	83 fb 7e             	cmp    $0x7e,%ebx
  800f22:	7e 12                	jle    800f36 <vprintfmt+0x207>
					putch('?', putdat);
  800f24:	83 ec 08             	sub    $0x8,%esp
  800f27:	ff 75 0c             	pushl  0xc(%ebp)
  800f2a:	6a 3f                	push   $0x3f
  800f2c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f2f:	ff d0                	call   *%eax
  800f31:	83 c4 10             	add    $0x10,%esp
  800f34:	eb 0f                	jmp    800f45 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800f36:	83 ec 08             	sub    $0x8,%esp
  800f39:	ff 75 0c             	pushl  0xc(%ebp)
  800f3c:	53                   	push   %ebx
  800f3d:	8b 45 08             	mov    0x8(%ebp),%eax
  800f40:	ff d0                	call   *%eax
  800f42:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800f45:	ff 4d e4             	decl   -0x1c(%ebp)
  800f48:	89 f0                	mov    %esi,%eax
  800f4a:	8d 70 01             	lea    0x1(%eax),%esi
  800f4d:	8a 00                	mov    (%eax),%al
  800f4f:	0f be d8             	movsbl %al,%ebx
  800f52:	85 db                	test   %ebx,%ebx
  800f54:	74 24                	je     800f7a <vprintfmt+0x24b>
  800f56:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800f5a:	78 b8                	js     800f14 <vprintfmt+0x1e5>
  800f5c:	ff 4d e0             	decl   -0x20(%ebp)
  800f5f:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800f63:	79 af                	jns    800f14 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800f65:	eb 13                	jmp    800f7a <vprintfmt+0x24b>
				putch(' ', putdat);
  800f67:	83 ec 08             	sub    $0x8,%esp
  800f6a:	ff 75 0c             	pushl  0xc(%ebp)
  800f6d:	6a 20                	push   $0x20
  800f6f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f72:	ff d0                	call   *%eax
  800f74:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800f77:	ff 4d e4             	decl   -0x1c(%ebp)
  800f7a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800f7e:	7f e7                	jg     800f67 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800f80:	e9 78 01 00 00       	jmp    8010fd <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800f85:	83 ec 08             	sub    $0x8,%esp
  800f88:	ff 75 e8             	pushl  -0x18(%ebp)
  800f8b:	8d 45 14             	lea    0x14(%ebp),%eax
  800f8e:	50                   	push   %eax
  800f8f:	e8 3c fd ff ff       	call   800cd0 <getint>
  800f94:	83 c4 10             	add    $0x10,%esp
  800f97:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f9a:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800f9d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800fa0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800fa3:	85 d2                	test   %edx,%edx
  800fa5:	79 23                	jns    800fca <vprintfmt+0x29b>
				putch('-', putdat);
  800fa7:	83 ec 08             	sub    $0x8,%esp
  800faa:	ff 75 0c             	pushl  0xc(%ebp)
  800fad:	6a 2d                	push   $0x2d
  800faf:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb2:	ff d0                	call   *%eax
  800fb4:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800fb7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800fba:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800fbd:	f7 d8                	neg    %eax
  800fbf:	83 d2 00             	adc    $0x0,%edx
  800fc2:	f7 da                	neg    %edx
  800fc4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800fc7:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800fca:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800fd1:	e9 bc 00 00 00       	jmp    801092 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800fd6:	83 ec 08             	sub    $0x8,%esp
  800fd9:	ff 75 e8             	pushl  -0x18(%ebp)
  800fdc:	8d 45 14             	lea    0x14(%ebp),%eax
  800fdf:	50                   	push   %eax
  800fe0:	e8 84 fc ff ff       	call   800c69 <getuint>
  800fe5:	83 c4 10             	add    $0x10,%esp
  800fe8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800feb:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800fee:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800ff5:	e9 98 00 00 00       	jmp    801092 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800ffa:	83 ec 08             	sub    $0x8,%esp
  800ffd:	ff 75 0c             	pushl  0xc(%ebp)
  801000:	6a 58                	push   $0x58
  801002:	8b 45 08             	mov    0x8(%ebp),%eax
  801005:	ff d0                	call   *%eax
  801007:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  80100a:	83 ec 08             	sub    $0x8,%esp
  80100d:	ff 75 0c             	pushl  0xc(%ebp)
  801010:	6a 58                	push   $0x58
  801012:	8b 45 08             	mov    0x8(%ebp),%eax
  801015:	ff d0                	call   *%eax
  801017:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  80101a:	83 ec 08             	sub    $0x8,%esp
  80101d:	ff 75 0c             	pushl  0xc(%ebp)
  801020:	6a 58                	push   $0x58
  801022:	8b 45 08             	mov    0x8(%ebp),%eax
  801025:	ff d0                	call   *%eax
  801027:	83 c4 10             	add    $0x10,%esp
			break;
  80102a:	e9 ce 00 00 00       	jmp    8010fd <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  80102f:	83 ec 08             	sub    $0x8,%esp
  801032:	ff 75 0c             	pushl  0xc(%ebp)
  801035:	6a 30                	push   $0x30
  801037:	8b 45 08             	mov    0x8(%ebp),%eax
  80103a:	ff d0                	call   *%eax
  80103c:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  80103f:	83 ec 08             	sub    $0x8,%esp
  801042:	ff 75 0c             	pushl  0xc(%ebp)
  801045:	6a 78                	push   $0x78
  801047:	8b 45 08             	mov    0x8(%ebp),%eax
  80104a:	ff d0                	call   *%eax
  80104c:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  80104f:	8b 45 14             	mov    0x14(%ebp),%eax
  801052:	83 c0 04             	add    $0x4,%eax
  801055:	89 45 14             	mov    %eax,0x14(%ebp)
  801058:	8b 45 14             	mov    0x14(%ebp),%eax
  80105b:	83 e8 04             	sub    $0x4,%eax
  80105e:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801060:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801063:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  80106a:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  801071:	eb 1f                	jmp    801092 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  801073:	83 ec 08             	sub    $0x8,%esp
  801076:	ff 75 e8             	pushl  -0x18(%ebp)
  801079:	8d 45 14             	lea    0x14(%ebp),%eax
  80107c:	50                   	push   %eax
  80107d:	e8 e7 fb ff ff       	call   800c69 <getuint>
  801082:	83 c4 10             	add    $0x10,%esp
  801085:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801088:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  80108b:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  801092:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  801096:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801099:	83 ec 04             	sub    $0x4,%esp
  80109c:	52                   	push   %edx
  80109d:	ff 75 e4             	pushl  -0x1c(%ebp)
  8010a0:	50                   	push   %eax
  8010a1:	ff 75 f4             	pushl  -0xc(%ebp)
  8010a4:	ff 75 f0             	pushl  -0x10(%ebp)
  8010a7:	ff 75 0c             	pushl  0xc(%ebp)
  8010aa:	ff 75 08             	pushl  0x8(%ebp)
  8010ad:	e8 00 fb ff ff       	call   800bb2 <printnum>
  8010b2:	83 c4 20             	add    $0x20,%esp
			break;
  8010b5:	eb 46                	jmp    8010fd <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8010b7:	83 ec 08             	sub    $0x8,%esp
  8010ba:	ff 75 0c             	pushl  0xc(%ebp)
  8010bd:	53                   	push   %ebx
  8010be:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c1:	ff d0                	call   *%eax
  8010c3:	83 c4 10             	add    $0x10,%esp
			break;
  8010c6:	eb 35                	jmp    8010fd <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  8010c8:	c6 05 44 60 80 00 00 	movb   $0x0,0x806044
			break;
  8010cf:	eb 2c                	jmp    8010fd <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  8010d1:	c6 05 44 60 80 00 01 	movb   $0x1,0x806044
			break;
  8010d8:	eb 23                	jmp    8010fd <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8010da:	83 ec 08             	sub    $0x8,%esp
  8010dd:	ff 75 0c             	pushl  0xc(%ebp)
  8010e0:	6a 25                	push   $0x25
  8010e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8010e5:	ff d0                	call   *%eax
  8010e7:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  8010ea:	ff 4d 10             	decl   0x10(%ebp)
  8010ed:	eb 03                	jmp    8010f2 <vprintfmt+0x3c3>
  8010ef:	ff 4d 10             	decl   0x10(%ebp)
  8010f2:	8b 45 10             	mov    0x10(%ebp),%eax
  8010f5:	48                   	dec    %eax
  8010f6:	8a 00                	mov    (%eax),%al
  8010f8:	3c 25                	cmp    $0x25,%al
  8010fa:	75 f3                	jne    8010ef <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  8010fc:	90                   	nop
		}
	}
  8010fd:	e9 35 fc ff ff       	jmp    800d37 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  801102:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  801103:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801106:	5b                   	pop    %ebx
  801107:	5e                   	pop    %esi
  801108:	5d                   	pop    %ebp
  801109:	c3                   	ret    

0080110a <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  80110a:	55                   	push   %ebp
  80110b:	89 e5                	mov    %esp,%ebp
  80110d:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  801110:	8d 45 10             	lea    0x10(%ebp),%eax
  801113:	83 c0 04             	add    $0x4,%eax
  801116:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  801119:	8b 45 10             	mov    0x10(%ebp),%eax
  80111c:	ff 75 f4             	pushl  -0xc(%ebp)
  80111f:	50                   	push   %eax
  801120:	ff 75 0c             	pushl  0xc(%ebp)
  801123:	ff 75 08             	pushl  0x8(%ebp)
  801126:	e8 04 fc ff ff       	call   800d2f <vprintfmt>
  80112b:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  80112e:	90                   	nop
  80112f:	c9                   	leave  
  801130:	c3                   	ret    

00801131 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801131:	55                   	push   %ebp
  801132:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  801134:	8b 45 0c             	mov    0xc(%ebp),%eax
  801137:	8b 40 08             	mov    0x8(%eax),%eax
  80113a:	8d 50 01             	lea    0x1(%eax),%edx
  80113d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801140:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  801143:	8b 45 0c             	mov    0xc(%ebp),%eax
  801146:	8b 10                	mov    (%eax),%edx
  801148:	8b 45 0c             	mov    0xc(%ebp),%eax
  80114b:	8b 40 04             	mov    0x4(%eax),%eax
  80114e:	39 c2                	cmp    %eax,%edx
  801150:	73 12                	jae    801164 <sprintputch+0x33>
		*b->buf++ = ch;
  801152:	8b 45 0c             	mov    0xc(%ebp),%eax
  801155:	8b 00                	mov    (%eax),%eax
  801157:	8d 48 01             	lea    0x1(%eax),%ecx
  80115a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80115d:	89 0a                	mov    %ecx,(%edx)
  80115f:	8b 55 08             	mov    0x8(%ebp),%edx
  801162:	88 10                	mov    %dl,(%eax)
}
  801164:	90                   	nop
  801165:	5d                   	pop    %ebp
  801166:	c3                   	ret    

00801167 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801167:	55                   	push   %ebp
  801168:	89 e5                	mov    %esp,%ebp
  80116a:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  80116d:	8b 45 08             	mov    0x8(%ebp),%eax
  801170:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801173:	8b 45 0c             	mov    0xc(%ebp),%eax
  801176:	8d 50 ff             	lea    -0x1(%eax),%edx
  801179:	8b 45 08             	mov    0x8(%ebp),%eax
  80117c:	01 d0                	add    %edx,%eax
  80117e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801181:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  801188:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80118c:	74 06                	je     801194 <vsnprintf+0x2d>
  80118e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801192:	7f 07                	jg     80119b <vsnprintf+0x34>
		return -E_INVAL;
  801194:	b8 03 00 00 00       	mov    $0x3,%eax
  801199:	eb 20                	jmp    8011bb <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80119b:	ff 75 14             	pushl  0x14(%ebp)
  80119e:	ff 75 10             	pushl  0x10(%ebp)
  8011a1:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8011a4:	50                   	push   %eax
  8011a5:	68 31 11 80 00       	push   $0x801131
  8011aa:	e8 80 fb ff ff       	call   800d2f <vprintfmt>
  8011af:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  8011b2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8011b5:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8011b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8011bb:	c9                   	leave  
  8011bc:	c3                   	ret    

008011bd <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8011bd:	55                   	push   %ebp
  8011be:	89 e5                	mov    %esp,%ebp
  8011c0:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8011c3:	8d 45 10             	lea    0x10(%ebp),%eax
  8011c6:	83 c0 04             	add    $0x4,%eax
  8011c9:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  8011cc:	8b 45 10             	mov    0x10(%ebp),%eax
  8011cf:	ff 75 f4             	pushl  -0xc(%ebp)
  8011d2:	50                   	push   %eax
  8011d3:	ff 75 0c             	pushl  0xc(%ebp)
  8011d6:	ff 75 08             	pushl  0x8(%ebp)
  8011d9:	e8 89 ff ff ff       	call   801167 <vsnprintf>
  8011de:	83 c4 10             	add    $0x10,%esp
  8011e1:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  8011e4:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8011e7:	c9                   	leave  
  8011e8:	c3                   	ret    

008011e9 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  8011e9:	55                   	push   %ebp
  8011ea:	89 e5                	mov    %esp,%ebp
  8011ec:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  8011ef:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8011f6:	eb 06                	jmp    8011fe <strlen+0x15>
		n++;
  8011f8:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8011fb:	ff 45 08             	incl   0x8(%ebp)
  8011fe:	8b 45 08             	mov    0x8(%ebp),%eax
  801201:	8a 00                	mov    (%eax),%al
  801203:	84 c0                	test   %al,%al
  801205:	75 f1                	jne    8011f8 <strlen+0xf>
		n++;
	return n;
  801207:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80120a:	c9                   	leave  
  80120b:	c3                   	ret    

0080120c <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  80120c:	55                   	push   %ebp
  80120d:	89 e5                	mov    %esp,%ebp
  80120f:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801212:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801219:	eb 09                	jmp    801224 <strnlen+0x18>
		n++;
  80121b:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80121e:	ff 45 08             	incl   0x8(%ebp)
  801221:	ff 4d 0c             	decl   0xc(%ebp)
  801224:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801228:	74 09                	je     801233 <strnlen+0x27>
  80122a:	8b 45 08             	mov    0x8(%ebp),%eax
  80122d:	8a 00                	mov    (%eax),%al
  80122f:	84 c0                	test   %al,%al
  801231:	75 e8                	jne    80121b <strnlen+0xf>
		n++;
	return n;
  801233:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801236:	c9                   	leave  
  801237:	c3                   	ret    

00801238 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801238:	55                   	push   %ebp
  801239:	89 e5                	mov    %esp,%ebp
  80123b:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  80123e:	8b 45 08             	mov    0x8(%ebp),%eax
  801241:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  801244:	90                   	nop
  801245:	8b 45 08             	mov    0x8(%ebp),%eax
  801248:	8d 50 01             	lea    0x1(%eax),%edx
  80124b:	89 55 08             	mov    %edx,0x8(%ebp)
  80124e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801251:	8d 4a 01             	lea    0x1(%edx),%ecx
  801254:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801257:	8a 12                	mov    (%edx),%dl
  801259:	88 10                	mov    %dl,(%eax)
  80125b:	8a 00                	mov    (%eax),%al
  80125d:	84 c0                	test   %al,%al
  80125f:	75 e4                	jne    801245 <strcpy+0xd>
		/* do nothing */;
	return ret;
  801261:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801264:	c9                   	leave  
  801265:	c3                   	ret    

00801266 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  801266:	55                   	push   %ebp
  801267:	89 e5                	mov    %esp,%ebp
  801269:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  80126c:	8b 45 08             	mov    0x8(%ebp),%eax
  80126f:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  801272:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801279:	eb 1f                	jmp    80129a <strncpy+0x34>
		*dst++ = *src;
  80127b:	8b 45 08             	mov    0x8(%ebp),%eax
  80127e:	8d 50 01             	lea    0x1(%eax),%edx
  801281:	89 55 08             	mov    %edx,0x8(%ebp)
  801284:	8b 55 0c             	mov    0xc(%ebp),%edx
  801287:	8a 12                	mov    (%edx),%dl
  801289:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  80128b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80128e:	8a 00                	mov    (%eax),%al
  801290:	84 c0                	test   %al,%al
  801292:	74 03                	je     801297 <strncpy+0x31>
			src++;
  801294:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801297:	ff 45 fc             	incl   -0x4(%ebp)
  80129a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80129d:	3b 45 10             	cmp    0x10(%ebp),%eax
  8012a0:	72 d9                	jb     80127b <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8012a2:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8012a5:	c9                   	leave  
  8012a6:	c3                   	ret    

008012a7 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  8012a7:	55                   	push   %ebp
  8012a8:	89 e5                	mov    %esp,%ebp
  8012aa:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  8012ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8012b0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  8012b3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8012b7:	74 30                	je     8012e9 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  8012b9:	eb 16                	jmp    8012d1 <strlcpy+0x2a>
			*dst++ = *src++;
  8012bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8012be:	8d 50 01             	lea    0x1(%eax),%edx
  8012c1:	89 55 08             	mov    %edx,0x8(%ebp)
  8012c4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012c7:	8d 4a 01             	lea    0x1(%edx),%ecx
  8012ca:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8012cd:	8a 12                	mov    (%edx),%dl
  8012cf:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8012d1:	ff 4d 10             	decl   0x10(%ebp)
  8012d4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8012d8:	74 09                	je     8012e3 <strlcpy+0x3c>
  8012da:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012dd:	8a 00                	mov    (%eax),%al
  8012df:	84 c0                	test   %al,%al
  8012e1:	75 d8                	jne    8012bb <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  8012e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8012e6:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8012e9:	8b 55 08             	mov    0x8(%ebp),%edx
  8012ec:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012ef:	29 c2                	sub    %eax,%edx
  8012f1:	89 d0                	mov    %edx,%eax
}
  8012f3:	c9                   	leave  
  8012f4:	c3                   	ret    

008012f5 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8012f5:	55                   	push   %ebp
  8012f6:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  8012f8:	eb 06                	jmp    801300 <strcmp+0xb>
		p++, q++;
  8012fa:	ff 45 08             	incl   0x8(%ebp)
  8012fd:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801300:	8b 45 08             	mov    0x8(%ebp),%eax
  801303:	8a 00                	mov    (%eax),%al
  801305:	84 c0                	test   %al,%al
  801307:	74 0e                	je     801317 <strcmp+0x22>
  801309:	8b 45 08             	mov    0x8(%ebp),%eax
  80130c:	8a 10                	mov    (%eax),%dl
  80130e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801311:	8a 00                	mov    (%eax),%al
  801313:	38 c2                	cmp    %al,%dl
  801315:	74 e3                	je     8012fa <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801317:	8b 45 08             	mov    0x8(%ebp),%eax
  80131a:	8a 00                	mov    (%eax),%al
  80131c:	0f b6 d0             	movzbl %al,%edx
  80131f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801322:	8a 00                	mov    (%eax),%al
  801324:	0f b6 c0             	movzbl %al,%eax
  801327:	29 c2                	sub    %eax,%edx
  801329:	89 d0                	mov    %edx,%eax
}
  80132b:	5d                   	pop    %ebp
  80132c:	c3                   	ret    

0080132d <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  80132d:	55                   	push   %ebp
  80132e:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  801330:	eb 09                	jmp    80133b <strncmp+0xe>
		n--, p++, q++;
  801332:	ff 4d 10             	decl   0x10(%ebp)
  801335:	ff 45 08             	incl   0x8(%ebp)
  801338:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  80133b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80133f:	74 17                	je     801358 <strncmp+0x2b>
  801341:	8b 45 08             	mov    0x8(%ebp),%eax
  801344:	8a 00                	mov    (%eax),%al
  801346:	84 c0                	test   %al,%al
  801348:	74 0e                	je     801358 <strncmp+0x2b>
  80134a:	8b 45 08             	mov    0x8(%ebp),%eax
  80134d:	8a 10                	mov    (%eax),%dl
  80134f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801352:	8a 00                	mov    (%eax),%al
  801354:	38 c2                	cmp    %al,%dl
  801356:	74 da                	je     801332 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  801358:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80135c:	75 07                	jne    801365 <strncmp+0x38>
		return 0;
  80135e:	b8 00 00 00 00       	mov    $0x0,%eax
  801363:	eb 14                	jmp    801379 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801365:	8b 45 08             	mov    0x8(%ebp),%eax
  801368:	8a 00                	mov    (%eax),%al
  80136a:	0f b6 d0             	movzbl %al,%edx
  80136d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801370:	8a 00                	mov    (%eax),%al
  801372:	0f b6 c0             	movzbl %al,%eax
  801375:	29 c2                	sub    %eax,%edx
  801377:	89 d0                	mov    %edx,%eax
}
  801379:	5d                   	pop    %ebp
  80137a:	c3                   	ret    

0080137b <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80137b:	55                   	push   %ebp
  80137c:	89 e5                	mov    %esp,%ebp
  80137e:	83 ec 04             	sub    $0x4,%esp
  801381:	8b 45 0c             	mov    0xc(%ebp),%eax
  801384:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801387:	eb 12                	jmp    80139b <strchr+0x20>
		if (*s == c)
  801389:	8b 45 08             	mov    0x8(%ebp),%eax
  80138c:	8a 00                	mov    (%eax),%al
  80138e:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801391:	75 05                	jne    801398 <strchr+0x1d>
			return (char *) s;
  801393:	8b 45 08             	mov    0x8(%ebp),%eax
  801396:	eb 11                	jmp    8013a9 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801398:	ff 45 08             	incl   0x8(%ebp)
  80139b:	8b 45 08             	mov    0x8(%ebp),%eax
  80139e:	8a 00                	mov    (%eax),%al
  8013a0:	84 c0                	test   %al,%al
  8013a2:	75 e5                	jne    801389 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  8013a4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8013a9:	c9                   	leave  
  8013aa:	c3                   	ret    

008013ab <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8013ab:	55                   	push   %ebp
  8013ac:	89 e5                	mov    %esp,%ebp
  8013ae:	83 ec 04             	sub    $0x4,%esp
  8013b1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013b4:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8013b7:	eb 0d                	jmp    8013c6 <strfind+0x1b>
		if (*s == c)
  8013b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8013bc:	8a 00                	mov    (%eax),%al
  8013be:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8013c1:	74 0e                	je     8013d1 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8013c3:	ff 45 08             	incl   0x8(%ebp)
  8013c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8013c9:	8a 00                	mov    (%eax),%al
  8013cb:	84 c0                	test   %al,%al
  8013cd:	75 ea                	jne    8013b9 <strfind+0xe>
  8013cf:	eb 01                	jmp    8013d2 <strfind+0x27>
		if (*s == c)
			break;
  8013d1:	90                   	nop
	return (char *) s;
  8013d2:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8013d5:	c9                   	leave  
  8013d6:	c3                   	ret    

008013d7 <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  8013d7:	55                   	push   %ebp
  8013d8:	89 e5                	mov    %esp,%ebp
  8013da:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  8013dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8013e0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  8013e3:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  8013e7:	76 63                	jbe    80144c <memset+0x75>
		uint64 data_block = c;
  8013e9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013ec:	99                   	cltd   
  8013ed:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8013f0:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  8013f3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013f6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8013f9:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  8013fd:	c1 e0 08             	shl    $0x8,%eax
  801400:	09 45 f0             	or     %eax,-0x10(%ebp)
  801403:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  801406:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801409:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80140c:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  801410:	c1 e0 10             	shl    $0x10,%eax
  801413:	09 45 f0             	or     %eax,-0x10(%ebp)
  801416:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  801419:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80141c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80141f:	89 c2                	mov    %eax,%edx
  801421:	b8 00 00 00 00       	mov    $0x0,%eax
  801426:	09 45 f0             	or     %eax,-0x10(%ebp)
  801429:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  80142c:	eb 18                	jmp    801446 <memset+0x6f>
			*p64++ = data_block, n -= 8;
  80142e:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801431:	8d 41 08             	lea    0x8(%ecx),%eax
  801434:	89 45 fc             	mov    %eax,-0x4(%ebp)
  801437:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80143a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80143d:	89 01                	mov    %eax,(%ecx)
  80143f:	89 51 04             	mov    %edx,0x4(%ecx)
  801442:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  801446:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  80144a:	77 e2                	ja     80142e <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  80144c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801450:	74 23                	je     801475 <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  801452:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801455:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  801458:	eb 0e                	jmp    801468 <memset+0x91>
			*p8++ = (uint8)c;
  80145a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80145d:	8d 50 01             	lea    0x1(%eax),%edx
  801460:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801463:	8b 55 0c             	mov    0xc(%ebp),%edx
  801466:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  801468:	8b 45 10             	mov    0x10(%ebp),%eax
  80146b:	8d 50 ff             	lea    -0x1(%eax),%edx
  80146e:	89 55 10             	mov    %edx,0x10(%ebp)
  801471:	85 c0                	test   %eax,%eax
  801473:	75 e5                	jne    80145a <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  801475:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801478:	c9                   	leave  
  801479:	c3                   	ret    

0080147a <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  80147a:	55                   	push   %ebp
  80147b:	89 e5                	mov    %esp,%ebp
  80147d:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  801480:	8b 45 0c             	mov    0xc(%ebp),%eax
  801483:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  801486:	8b 45 08             	mov    0x8(%ebp),%eax
  801489:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  80148c:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801490:	76 24                	jbe    8014b6 <memcpy+0x3c>
		while(n >= 8){
  801492:	eb 1c                	jmp    8014b0 <memcpy+0x36>
			*d64 = *s64;
  801494:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801497:	8b 50 04             	mov    0x4(%eax),%edx
  80149a:	8b 00                	mov    (%eax),%eax
  80149c:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  80149f:	89 01                	mov    %eax,(%ecx)
  8014a1:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  8014a4:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  8014a8:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  8014ac:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  8014b0:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  8014b4:	77 de                	ja     801494 <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  8014b6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8014ba:	74 31                	je     8014ed <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  8014bc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8014bf:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  8014c2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8014c5:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  8014c8:	eb 16                	jmp    8014e0 <memcpy+0x66>
			*d8++ = *s8++;
  8014ca:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014cd:	8d 50 01             	lea    0x1(%eax),%edx
  8014d0:	89 55 f0             	mov    %edx,-0x10(%ebp)
  8014d3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8014d6:	8d 4a 01             	lea    0x1(%edx),%ecx
  8014d9:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  8014dc:	8a 12                	mov    (%edx),%dl
  8014de:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  8014e0:	8b 45 10             	mov    0x10(%ebp),%eax
  8014e3:	8d 50 ff             	lea    -0x1(%eax),%edx
  8014e6:	89 55 10             	mov    %edx,0x10(%ebp)
  8014e9:	85 c0                	test   %eax,%eax
  8014eb:	75 dd                	jne    8014ca <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  8014ed:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8014f0:	c9                   	leave  
  8014f1:	c3                   	ret    

008014f2 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  8014f2:	55                   	push   %ebp
  8014f3:	89 e5                	mov    %esp,%ebp
  8014f5:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8014f8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014fb:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8014fe:	8b 45 08             	mov    0x8(%ebp),%eax
  801501:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801504:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801507:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80150a:	73 50                	jae    80155c <memmove+0x6a>
  80150c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80150f:	8b 45 10             	mov    0x10(%ebp),%eax
  801512:	01 d0                	add    %edx,%eax
  801514:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801517:	76 43                	jbe    80155c <memmove+0x6a>
		s += n;
  801519:	8b 45 10             	mov    0x10(%ebp),%eax
  80151c:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  80151f:	8b 45 10             	mov    0x10(%ebp),%eax
  801522:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  801525:	eb 10                	jmp    801537 <memmove+0x45>
			*--d = *--s;
  801527:	ff 4d f8             	decl   -0x8(%ebp)
  80152a:	ff 4d fc             	decl   -0x4(%ebp)
  80152d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801530:	8a 10                	mov    (%eax),%dl
  801532:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801535:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  801537:	8b 45 10             	mov    0x10(%ebp),%eax
  80153a:	8d 50 ff             	lea    -0x1(%eax),%edx
  80153d:	89 55 10             	mov    %edx,0x10(%ebp)
  801540:	85 c0                	test   %eax,%eax
  801542:	75 e3                	jne    801527 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801544:	eb 23                	jmp    801569 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  801546:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801549:	8d 50 01             	lea    0x1(%eax),%edx
  80154c:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80154f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801552:	8d 4a 01             	lea    0x1(%edx),%ecx
  801555:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801558:	8a 12                	mov    (%edx),%dl
  80155a:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  80155c:	8b 45 10             	mov    0x10(%ebp),%eax
  80155f:	8d 50 ff             	lea    -0x1(%eax),%edx
  801562:	89 55 10             	mov    %edx,0x10(%ebp)
  801565:	85 c0                	test   %eax,%eax
  801567:	75 dd                	jne    801546 <memmove+0x54>
			*d++ = *s++;

	return dst;
  801569:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80156c:	c9                   	leave  
  80156d:	c3                   	ret    

0080156e <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  80156e:	55                   	push   %ebp
  80156f:	89 e5                	mov    %esp,%ebp
  801571:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  801574:	8b 45 08             	mov    0x8(%ebp),%eax
  801577:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  80157a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80157d:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  801580:	eb 2a                	jmp    8015ac <memcmp+0x3e>
		if (*s1 != *s2)
  801582:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801585:	8a 10                	mov    (%eax),%dl
  801587:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80158a:	8a 00                	mov    (%eax),%al
  80158c:	38 c2                	cmp    %al,%dl
  80158e:	74 16                	je     8015a6 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801590:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801593:	8a 00                	mov    (%eax),%al
  801595:	0f b6 d0             	movzbl %al,%edx
  801598:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80159b:	8a 00                	mov    (%eax),%al
  80159d:	0f b6 c0             	movzbl %al,%eax
  8015a0:	29 c2                	sub    %eax,%edx
  8015a2:	89 d0                	mov    %edx,%eax
  8015a4:	eb 18                	jmp    8015be <memcmp+0x50>
		s1++, s2++;
  8015a6:	ff 45 fc             	incl   -0x4(%ebp)
  8015a9:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  8015ac:	8b 45 10             	mov    0x10(%ebp),%eax
  8015af:	8d 50 ff             	lea    -0x1(%eax),%edx
  8015b2:	89 55 10             	mov    %edx,0x10(%ebp)
  8015b5:	85 c0                	test   %eax,%eax
  8015b7:	75 c9                	jne    801582 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8015b9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8015be:	c9                   	leave  
  8015bf:	c3                   	ret    

008015c0 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  8015c0:	55                   	push   %ebp
  8015c1:	89 e5                	mov    %esp,%ebp
  8015c3:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  8015c6:	8b 55 08             	mov    0x8(%ebp),%edx
  8015c9:	8b 45 10             	mov    0x10(%ebp),%eax
  8015cc:	01 d0                	add    %edx,%eax
  8015ce:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  8015d1:	eb 15                	jmp    8015e8 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  8015d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8015d6:	8a 00                	mov    (%eax),%al
  8015d8:	0f b6 d0             	movzbl %al,%edx
  8015db:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015de:	0f b6 c0             	movzbl %al,%eax
  8015e1:	39 c2                	cmp    %eax,%edx
  8015e3:	74 0d                	je     8015f2 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8015e5:	ff 45 08             	incl   0x8(%ebp)
  8015e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8015eb:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8015ee:	72 e3                	jb     8015d3 <memfind+0x13>
  8015f0:	eb 01                	jmp    8015f3 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  8015f2:	90                   	nop
	return (void *) s;
  8015f3:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8015f6:	c9                   	leave  
  8015f7:	c3                   	ret    

008015f8 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8015f8:	55                   	push   %ebp
  8015f9:	89 e5                	mov    %esp,%ebp
  8015fb:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  8015fe:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801605:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80160c:	eb 03                	jmp    801611 <strtol+0x19>
		s++;
  80160e:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801611:	8b 45 08             	mov    0x8(%ebp),%eax
  801614:	8a 00                	mov    (%eax),%al
  801616:	3c 20                	cmp    $0x20,%al
  801618:	74 f4                	je     80160e <strtol+0x16>
  80161a:	8b 45 08             	mov    0x8(%ebp),%eax
  80161d:	8a 00                	mov    (%eax),%al
  80161f:	3c 09                	cmp    $0x9,%al
  801621:	74 eb                	je     80160e <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801623:	8b 45 08             	mov    0x8(%ebp),%eax
  801626:	8a 00                	mov    (%eax),%al
  801628:	3c 2b                	cmp    $0x2b,%al
  80162a:	75 05                	jne    801631 <strtol+0x39>
		s++;
  80162c:	ff 45 08             	incl   0x8(%ebp)
  80162f:	eb 13                	jmp    801644 <strtol+0x4c>
	else if (*s == '-')
  801631:	8b 45 08             	mov    0x8(%ebp),%eax
  801634:	8a 00                	mov    (%eax),%al
  801636:	3c 2d                	cmp    $0x2d,%al
  801638:	75 0a                	jne    801644 <strtol+0x4c>
		s++, neg = 1;
  80163a:	ff 45 08             	incl   0x8(%ebp)
  80163d:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801644:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801648:	74 06                	je     801650 <strtol+0x58>
  80164a:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  80164e:	75 20                	jne    801670 <strtol+0x78>
  801650:	8b 45 08             	mov    0x8(%ebp),%eax
  801653:	8a 00                	mov    (%eax),%al
  801655:	3c 30                	cmp    $0x30,%al
  801657:	75 17                	jne    801670 <strtol+0x78>
  801659:	8b 45 08             	mov    0x8(%ebp),%eax
  80165c:	40                   	inc    %eax
  80165d:	8a 00                	mov    (%eax),%al
  80165f:	3c 78                	cmp    $0x78,%al
  801661:	75 0d                	jne    801670 <strtol+0x78>
		s += 2, base = 16;
  801663:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801667:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  80166e:	eb 28                	jmp    801698 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801670:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801674:	75 15                	jne    80168b <strtol+0x93>
  801676:	8b 45 08             	mov    0x8(%ebp),%eax
  801679:	8a 00                	mov    (%eax),%al
  80167b:	3c 30                	cmp    $0x30,%al
  80167d:	75 0c                	jne    80168b <strtol+0x93>
		s++, base = 8;
  80167f:	ff 45 08             	incl   0x8(%ebp)
  801682:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801689:	eb 0d                	jmp    801698 <strtol+0xa0>
	else if (base == 0)
  80168b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80168f:	75 07                	jne    801698 <strtol+0xa0>
		base = 10;
  801691:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801698:	8b 45 08             	mov    0x8(%ebp),%eax
  80169b:	8a 00                	mov    (%eax),%al
  80169d:	3c 2f                	cmp    $0x2f,%al
  80169f:	7e 19                	jle    8016ba <strtol+0xc2>
  8016a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8016a4:	8a 00                	mov    (%eax),%al
  8016a6:	3c 39                	cmp    $0x39,%al
  8016a8:	7f 10                	jg     8016ba <strtol+0xc2>
			dig = *s - '0';
  8016aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8016ad:	8a 00                	mov    (%eax),%al
  8016af:	0f be c0             	movsbl %al,%eax
  8016b2:	83 e8 30             	sub    $0x30,%eax
  8016b5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8016b8:	eb 42                	jmp    8016fc <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  8016ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8016bd:	8a 00                	mov    (%eax),%al
  8016bf:	3c 60                	cmp    $0x60,%al
  8016c1:	7e 19                	jle    8016dc <strtol+0xe4>
  8016c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8016c6:	8a 00                	mov    (%eax),%al
  8016c8:	3c 7a                	cmp    $0x7a,%al
  8016ca:	7f 10                	jg     8016dc <strtol+0xe4>
			dig = *s - 'a' + 10;
  8016cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8016cf:	8a 00                	mov    (%eax),%al
  8016d1:	0f be c0             	movsbl %al,%eax
  8016d4:	83 e8 57             	sub    $0x57,%eax
  8016d7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8016da:	eb 20                	jmp    8016fc <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  8016dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8016df:	8a 00                	mov    (%eax),%al
  8016e1:	3c 40                	cmp    $0x40,%al
  8016e3:	7e 39                	jle    80171e <strtol+0x126>
  8016e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8016e8:	8a 00                	mov    (%eax),%al
  8016ea:	3c 5a                	cmp    $0x5a,%al
  8016ec:	7f 30                	jg     80171e <strtol+0x126>
			dig = *s - 'A' + 10;
  8016ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8016f1:	8a 00                	mov    (%eax),%al
  8016f3:	0f be c0             	movsbl %al,%eax
  8016f6:	83 e8 37             	sub    $0x37,%eax
  8016f9:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  8016fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016ff:	3b 45 10             	cmp    0x10(%ebp),%eax
  801702:	7d 19                	jge    80171d <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801704:	ff 45 08             	incl   0x8(%ebp)
  801707:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80170a:	0f af 45 10          	imul   0x10(%ebp),%eax
  80170e:	89 c2                	mov    %eax,%edx
  801710:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801713:	01 d0                	add    %edx,%eax
  801715:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801718:	e9 7b ff ff ff       	jmp    801698 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  80171d:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  80171e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801722:	74 08                	je     80172c <strtol+0x134>
		*endptr = (char *) s;
  801724:	8b 45 0c             	mov    0xc(%ebp),%eax
  801727:	8b 55 08             	mov    0x8(%ebp),%edx
  80172a:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  80172c:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801730:	74 07                	je     801739 <strtol+0x141>
  801732:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801735:	f7 d8                	neg    %eax
  801737:	eb 03                	jmp    80173c <strtol+0x144>
  801739:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80173c:	c9                   	leave  
  80173d:	c3                   	ret    

0080173e <ltostr>:

void
ltostr(long value, char *str)
{
  80173e:	55                   	push   %ebp
  80173f:	89 e5                	mov    %esp,%ebp
  801741:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801744:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  80174b:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801752:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801756:	79 13                	jns    80176b <ltostr+0x2d>
	{
		neg = 1;
  801758:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  80175f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801762:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801765:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801768:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  80176b:	8b 45 08             	mov    0x8(%ebp),%eax
  80176e:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801773:	99                   	cltd   
  801774:	f7 f9                	idiv   %ecx
  801776:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801779:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80177c:	8d 50 01             	lea    0x1(%eax),%edx
  80177f:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801782:	89 c2                	mov    %eax,%edx
  801784:	8b 45 0c             	mov    0xc(%ebp),%eax
  801787:	01 d0                	add    %edx,%eax
  801789:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80178c:	83 c2 30             	add    $0x30,%edx
  80178f:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801791:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801794:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801799:	f7 e9                	imul   %ecx
  80179b:	c1 fa 02             	sar    $0x2,%edx
  80179e:	89 c8                	mov    %ecx,%eax
  8017a0:	c1 f8 1f             	sar    $0x1f,%eax
  8017a3:	29 c2                	sub    %eax,%edx
  8017a5:	89 d0                	mov    %edx,%eax
  8017a7:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  8017aa:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8017ae:	75 bb                	jne    80176b <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8017b0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8017b7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8017ba:	48                   	dec    %eax
  8017bb:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8017be:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8017c2:	74 3d                	je     801801 <ltostr+0xc3>
		start = 1 ;
  8017c4:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8017cb:	eb 34                	jmp    801801 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  8017cd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8017d0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017d3:	01 d0                	add    %edx,%eax
  8017d5:	8a 00                	mov    (%eax),%al
  8017d7:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8017da:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8017dd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017e0:	01 c2                	add    %eax,%edx
  8017e2:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8017e5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017e8:	01 c8                	add    %ecx,%eax
  8017ea:	8a 00                	mov    (%eax),%al
  8017ec:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8017ee:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8017f1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017f4:	01 c2                	add    %eax,%edx
  8017f6:	8a 45 eb             	mov    -0x15(%ebp),%al
  8017f9:	88 02                	mov    %al,(%edx)
		start++ ;
  8017fb:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8017fe:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801801:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801804:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801807:	7c c4                	jl     8017cd <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801809:	8b 55 f8             	mov    -0x8(%ebp),%edx
  80180c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80180f:	01 d0                	add    %edx,%eax
  801811:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801814:	90                   	nop
  801815:	c9                   	leave  
  801816:	c3                   	ret    

00801817 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801817:	55                   	push   %ebp
  801818:	89 e5                	mov    %esp,%ebp
  80181a:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  80181d:	ff 75 08             	pushl  0x8(%ebp)
  801820:	e8 c4 f9 ff ff       	call   8011e9 <strlen>
  801825:	83 c4 04             	add    $0x4,%esp
  801828:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  80182b:	ff 75 0c             	pushl  0xc(%ebp)
  80182e:	e8 b6 f9 ff ff       	call   8011e9 <strlen>
  801833:	83 c4 04             	add    $0x4,%esp
  801836:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801839:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801840:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801847:	eb 17                	jmp    801860 <strcconcat+0x49>
		final[s] = str1[s] ;
  801849:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80184c:	8b 45 10             	mov    0x10(%ebp),%eax
  80184f:	01 c2                	add    %eax,%edx
  801851:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801854:	8b 45 08             	mov    0x8(%ebp),%eax
  801857:	01 c8                	add    %ecx,%eax
  801859:	8a 00                	mov    (%eax),%al
  80185b:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  80185d:	ff 45 fc             	incl   -0x4(%ebp)
  801860:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801863:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801866:	7c e1                	jl     801849 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801868:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  80186f:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801876:	eb 1f                	jmp    801897 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801878:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80187b:	8d 50 01             	lea    0x1(%eax),%edx
  80187e:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801881:	89 c2                	mov    %eax,%edx
  801883:	8b 45 10             	mov    0x10(%ebp),%eax
  801886:	01 c2                	add    %eax,%edx
  801888:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  80188b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80188e:	01 c8                	add    %ecx,%eax
  801890:	8a 00                	mov    (%eax),%al
  801892:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801894:	ff 45 f8             	incl   -0x8(%ebp)
  801897:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80189a:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80189d:	7c d9                	jl     801878 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  80189f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8018a2:	8b 45 10             	mov    0x10(%ebp),%eax
  8018a5:	01 d0                	add    %edx,%eax
  8018a7:	c6 00 00             	movb   $0x0,(%eax)
}
  8018aa:	90                   	nop
  8018ab:	c9                   	leave  
  8018ac:	c3                   	ret    

008018ad <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8018ad:	55                   	push   %ebp
  8018ae:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8018b0:	8b 45 14             	mov    0x14(%ebp),%eax
  8018b3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8018b9:	8b 45 14             	mov    0x14(%ebp),%eax
  8018bc:	8b 00                	mov    (%eax),%eax
  8018be:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8018c5:	8b 45 10             	mov    0x10(%ebp),%eax
  8018c8:	01 d0                	add    %edx,%eax
  8018ca:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8018d0:	eb 0c                	jmp    8018de <strsplit+0x31>
			*string++ = 0;
  8018d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8018d5:	8d 50 01             	lea    0x1(%eax),%edx
  8018d8:	89 55 08             	mov    %edx,0x8(%ebp)
  8018db:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8018de:	8b 45 08             	mov    0x8(%ebp),%eax
  8018e1:	8a 00                	mov    (%eax),%al
  8018e3:	84 c0                	test   %al,%al
  8018e5:	74 18                	je     8018ff <strsplit+0x52>
  8018e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8018ea:	8a 00                	mov    (%eax),%al
  8018ec:	0f be c0             	movsbl %al,%eax
  8018ef:	50                   	push   %eax
  8018f0:	ff 75 0c             	pushl  0xc(%ebp)
  8018f3:	e8 83 fa ff ff       	call   80137b <strchr>
  8018f8:	83 c4 08             	add    $0x8,%esp
  8018fb:	85 c0                	test   %eax,%eax
  8018fd:	75 d3                	jne    8018d2 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8018ff:	8b 45 08             	mov    0x8(%ebp),%eax
  801902:	8a 00                	mov    (%eax),%al
  801904:	84 c0                	test   %al,%al
  801906:	74 5a                	je     801962 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801908:	8b 45 14             	mov    0x14(%ebp),%eax
  80190b:	8b 00                	mov    (%eax),%eax
  80190d:	83 f8 0f             	cmp    $0xf,%eax
  801910:	75 07                	jne    801919 <strsplit+0x6c>
		{
			return 0;
  801912:	b8 00 00 00 00       	mov    $0x0,%eax
  801917:	eb 66                	jmp    80197f <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801919:	8b 45 14             	mov    0x14(%ebp),%eax
  80191c:	8b 00                	mov    (%eax),%eax
  80191e:	8d 48 01             	lea    0x1(%eax),%ecx
  801921:	8b 55 14             	mov    0x14(%ebp),%edx
  801924:	89 0a                	mov    %ecx,(%edx)
  801926:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80192d:	8b 45 10             	mov    0x10(%ebp),%eax
  801930:	01 c2                	add    %eax,%edx
  801932:	8b 45 08             	mov    0x8(%ebp),%eax
  801935:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801937:	eb 03                	jmp    80193c <strsplit+0x8f>
			string++;
  801939:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  80193c:	8b 45 08             	mov    0x8(%ebp),%eax
  80193f:	8a 00                	mov    (%eax),%al
  801941:	84 c0                	test   %al,%al
  801943:	74 8b                	je     8018d0 <strsplit+0x23>
  801945:	8b 45 08             	mov    0x8(%ebp),%eax
  801948:	8a 00                	mov    (%eax),%al
  80194a:	0f be c0             	movsbl %al,%eax
  80194d:	50                   	push   %eax
  80194e:	ff 75 0c             	pushl  0xc(%ebp)
  801951:	e8 25 fa ff ff       	call   80137b <strchr>
  801956:	83 c4 08             	add    $0x8,%esp
  801959:	85 c0                	test   %eax,%eax
  80195b:	74 dc                	je     801939 <strsplit+0x8c>
			string++;
	}
  80195d:	e9 6e ff ff ff       	jmp    8018d0 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801962:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801963:	8b 45 14             	mov    0x14(%ebp),%eax
  801966:	8b 00                	mov    (%eax),%eax
  801968:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80196f:	8b 45 10             	mov    0x10(%ebp),%eax
  801972:	01 d0                	add    %edx,%eax
  801974:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  80197a:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80197f:	c9                   	leave  
  801980:	c3                   	ret    

00801981 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  801981:	55                   	push   %ebp
  801982:	89 e5                	mov    %esp,%ebp
  801984:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  801987:	8b 45 08             	mov    0x8(%ebp),%eax
  80198a:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  80198d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801994:	eb 4a                	jmp    8019e0 <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  801996:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801999:	8b 45 08             	mov    0x8(%ebp),%eax
  80199c:	01 c2                	add    %eax,%edx
  80199e:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8019a1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019a4:	01 c8                	add    %ecx,%eax
  8019a6:	8a 00                	mov    (%eax),%al
  8019a8:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  8019aa:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8019ad:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019b0:	01 d0                	add    %edx,%eax
  8019b2:	8a 00                	mov    (%eax),%al
  8019b4:	3c 40                	cmp    $0x40,%al
  8019b6:	7e 25                	jle    8019dd <str2lower+0x5c>
  8019b8:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8019bb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019be:	01 d0                	add    %edx,%eax
  8019c0:	8a 00                	mov    (%eax),%al
  8019c2:	3c 5a                	cmp    $0x5a,%al
  8019c4:	7f 17                	jg     8019dd <str2lower+0x5c>
		{
			dst[i] += 32 ;
  8019c6:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8019c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8019cc:	01 d0                	add    %edx,%eax
  8019ce:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8019d1:	8b 55 08             	mov    0x8(%ebp),%edx
  8019d4:	01 ca                	add    %ecx,%edx
  8019d6:	8a 12                	mov    (%edx),%dl
  8019d8:	83 c2 20             	add    $0x20,%edx
  8019db:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  8019dd:	ff 45 fc             	incl   -0x4(%ebp)
  8019e0:	ff 75 0c             	pushl  0xc(%ebp)
  8019e3:	e8 01 f8 ff ff       	call   8011e9 <strlen>
  8019e8:	83 c4 04             	add    $0x4,%esp
  8019eb:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8019ee:	7f a6                	jg     801996 <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  8019f0:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8019f3:	c9                   	leave  
  8019f4:	c3                   	ret    

008019f5 <uheap_init>:
//==============================================
// [1] INITIALIZE USER HEAP:
//==============================================
int __firstTimeFlag = 1;
void uheap_init()
{
  8019f5:	55                   	push   %ebp
  8019f6:	89 e5                	mov    %esp,%ebp
  8019f8:	83 ec 08             	sub    $0x8,%esp
	if(__firstTimeFlag)
  8019fb:	a1 08 60 80 00       	mov    0x806008,%eax
  801a00:	85 c0                	test   %eax,%eax
  801a02:	0f 84 95 00 00 00    	je     801a9d <uheap_init+0xa8>
	{
		initialize_dynamic_allocator(USER_HEAP_START, USER_HEAP_START + DYN_ALLOC_MAX_SIZE);
  801a08:	83 ec 08             	sub    $0x8,%esp
  801a0b:	68 00 00 00 82       	push   $0x82000000
  801a10:	68 00 00 00 80       	push   $0x80000000
  801a15:	e8 59 1f 00 00       	call   803973 <initialize_dynamic_allocator>
  801a1a:	83 c4 10             	add    $0x10,%esp
		uheapPlaceStrategy = sys_get_uheap_strategy();
  801a1d:	e8 93 1d 00 00       	call   8037b5 <sys_get_uheap_strategy>
  801a22:	a3 60 e0 81 00       	mov    %eax,0x81e060
		uheapPageAllocStart = dynAllocEnd + PAGE_SIZE;
  801a27:	a1 40 60 80 00       	mov    0x806040,%eax
  801a2c:	05 00 10 00 00       	add    $0x1000,%eax
  801a31:	a3 10 e1 81 00       	mov    %eax,0x81e110
		uheapPageAllocBreak = uheapPageAllocStart;
  801a36:	a1 10 e1 81 00       	mov    0x81e110,%eax
  801a3b:	a3 68 e0 81 00       	mov    %eax,0x81e068
		init_uspinlock(&ulock,"malloc",1);
  801a40:	83 ec 04             	sub    $0x4,%esp
  801a43:	6a 01                	push   $0x1
  801a45:	68 48 51 80 00       	push   $0x805148
  801a4a:	68 40 e1 81 00       	push   $0x81e140
  801a4f:	e8 1a 29 00 00       	call   80436e <init_uspinlock>
  801a54:	83 c4 10             	add    $0x10,%esp
		LIST_INIT(&u_freelist);
  801a57:	c7 05 20 e1 81 00 00 	movl   $0x0,0x81e120
  801a5e:	00 00 00 
  801a61:	c7 05 24 e1 81 00 00 	movl   $0x0,0x81e124
  801a68:	00 00 00 
  801a6b:	c7 05 2c e1 81 00 00 	movl   $0x0,0x81e12c
  801a72:	00 00 00 
		LIST_INIT(&u_allocatedlist);
  801a75:	c7 05 30 e1 81 00 00 	movl   $0x0,0x81e130
  801a7c:	00 00 00 
  801a7f:	c7 05 34 e1 81 00 00 	movl   $0x0,0x81e134
  801a86:	00 00 00 
  801a89:	c7 05 3c e1 81 00 00 	movl   $0x0,0x81e13c
  801a90:	00 00 00 
		__firstTimeFlag = 0;
  801a93:	c7 05 08 60 80 00 00 	movl   $0x0,0x806008
  801a9a:	00 00 00 
	}
}
  801a9d:	90                   	nop
  801a9e:	c9                   	leave  
  801a9f:	c3                   	ret    

00801aa0 <get_page>:

//==============================================
// [2] GET A PAGE FROM THE KERNEL FOR DA:
//==============================================
int get_page(void* va)
{
  801aa0:	55                   	push   %ebp
  801aa1:	89 e5                	mov    %esp,%ebp
  801aa3:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_allocate_page(ROUNDDOWN(va, PAGE_SIZE), PERM_USER|PERM_WRITEABLE|PERM_UHPAGE);
  801aa6:	8b 45 08             	mov    0x8(%ebp),%eax
  801aa9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801aac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801aaf:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801ab4:	83 ec 08             	sub    $0x8,%esp
  801ab7:	68 06 04 00 00       	push   $0x406
  801abc:	50                   	push   %eax
  801abd:	e8 3d 19 00 00       	call   8033ff <__sys_allocate_page>
  801ac2:	83 c4 10             	add    $0x10,%esp
  801ac5:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  801ac8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801acc:	79 14                	jns    801ae2 <get_page+0x42>
		panic("get_page() in user: failed to allocate page from the kernel");
  801ace:	83 ec 04             	sub    $0x4,%esp
  801ad1:	68 50 51 80 00       	push   $0x805150
  801ad6:	6a 2d                	push   $0x2d
  801ad8:	68 8c 51 80 00       	push   $0x80518c
  801add:	e8 60 ed ff ff       	call   800842 <_panic>
	return 0;
  801ae2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ae7:	c9                   	leave  
  801ae8:	c3                   	ret    

00801ae9 <return_page>:

//==============================================
// [3] RETURN A PAGE FROM THE DA TO KERNEL:
//==============================================
void return_page(void* va)
{
  801ae9:	55                   	push   %ebp
  801aea:	89 e5                	mov    %esp,%ebp
  801aec:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_unmap_frame(ROUNDDOWN((uint32)va, PAGE_SIZE));
  801aef:	8b 45 08             	mov    0x8(%ebp),%eax
  801af2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801af5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801af8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801afd:	83 ec 0c             	sub    $0xc,%esp
  801b00:	50                   	push   %eax
  801b01:	e8 40 19 00 00       	call   803446 <__sys_unmap_frame>
  801b06:	83 c4 10             	add    $0x10,%esp
  801b09:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  801b0c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801b10:	79 14                	jns    801b26 <return_page+0x3d>
		panic("return_page() in user: failed to return a page to the kernel");
  801b12:	83 ec 04             	sub    $0x4,%esp
  801b15:	68 98 51 80 00       	push   $0x805198
  801b1a:	6a 38                	push   $0x38
  801b1c:	68 8c 51 80 00       	push   $0x80518c
  801b21:	e8 1c ed ff ff       	call   800842 <_panic>
}
  801b26:	90                   	nop
  801b27:	c9                   	leave  
  801b28:	c3                   	ret    

00801b29 <malloc>:

//=================================
// [1] ALLOCATE SPACE IN USER HEAP:
//=================================
void* malloc(uint32 size)
{
  801b29:	55                   	push   %ebp
  801b2a:	89 e5                	mov    %esp,%ebp
  801b2c:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  801b2f:	e8 c1 fe ff ff       	call   8019f5 <uheap_init>
	if (size == 0) return NULL ;
  801b34:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801b38:	75 0a                	jne    801b44 <malloc+0x1b>
  801b3a:	b8 00 00 00 00       	mov    $0x0,%eax
  801b3f:	e9 e1 04 00 00       	jmp    802025 <malloc+0x4fc>
	//==============================================================

	acquire_uspinlock(&ulock);
  801b44:	83 ec 0c             	sub    $0xc,%esp
  801b47:	68 40 e1 81 00       	push   $0x81e140
  801b4c:	e8 6c 28 00 00       	call   8043bd <acquire_uspinlock>
  801b51:	83 c4 10             	add    $0x10,%esp
	if(size <  DYN_ALLOC_MAX_BLOCK_SIZE){
  801b54:	81 7d 08 ff 07 00 00 	cmpl   $0x7ff,0x8(%ebp)
  801b5b:	77 23                	ja     801b80 <malloc+0x57>
		release_uspinlock(&ulock);
  801b5d:	83 ec 0c             	sub    $0xc,%esp
  801b60:	68 40 e1 81 00       	push   $0x81e140
  801b65:	e8 ab 28 00 00       	call   804415 <release_uspinlock>
  801b6a:	83 c4 10             	add    $0x10,%esp
		return alloc_block(size);
  801b6d:	83 ec 0c             	sub    $0xc,%esp
  801b70:	ff 75 08             	pushl  0x8(%ebp)
  801b73:	e8 dd 1f 00 00       	call   803b55 <alloc_block>
  801b78:	83 c4 10             	add    $0x10,%esp
  801b7b:	e9 a5 04 00 00       	jmp    802025 <malloc+0x4fc>
	}

	struct UserHeapStruct* allocblock= (struct UserHeapStruct*) alloc_block(sizeof(struct UserHeapStruct));
  801b80:	83 ec 0c             	sub    $0xc,%esp
  801b83:	6a 10                	push   $0x10
  801b85:	e8 cb 1f 00 00       	call   803b55 <alloc_block>
  801b8a:	83 c4 10             	add    $0x10,%esp
  801b8d:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (allocblock == NULL){
  801b90:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801b94:	75 0a                	jne    801ba0 <malloc+0x77>
			return NULL;
  801b96:	b8 00 00 00 00       	mov    $0x0,%eax
  801b9b:	e9 85 04 00 00       	jmp    802025 <malloc+0x4fc>
	}

	size = ROUNDUP(size,PAGE_SIZE);
  801ba0:	c7 45 e8 00 10 00 00 	movl   $0x1000,-0x18(%ebp)
  801ba7:	8b 55 08             	mov    0x8(%ebp),%edx
  801baa:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801bad:	01 d0                	add    %edx,%eax
  801baf:	48                   	dec    %eax
  801bb0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801bb3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801bb6:	ba 00 00 00 00       	mov    $0x0,%edx
  801bbb:	f7 75 e8             	divl   -0x18(%ebp)
  801bbe:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801bc1:	29 d0                	sub    %edx,%eax
  801bc3:	89 45 08             	mov    %eax,0x8(%ebp)
	struct UserHeapStruct* lastfreeelement = LIST_LAST(&u_freelist);
  801bc6:	a1 24 e1 81 00       	mov    0x81e124,%eax
  801bcb:	89 45 e0             	mov    %eax,-0x20(%ebp)

	if(LIST_SIZE(&u_freelist)==0 || size>lastfreeelement->size){
  801bce:	a1 2c e1 81 00       	mov    0x81e12c,%eax
  801bd3:	85 c0                	test   %eax,%eax
  801bd5:	74 0f                	je     801be6 <malloc+0xbd>
  801bd7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801bda:	8b 40 04             	mov    0x4(%eax),%eax
  801bdd:	3b 45 08             	cmp    0x8(%ebp),%eax
  801be0:	0f 83 ea 00 00 00    	jae    801cd0 <malloc+0x1a7>
			if(uheapPageAllocBreak < USER_HEAP_MAX - size){
  801be6:	b8 00 00 00 a0       	mov    $0xa0000000,%eax
  801beb:	2b 45 08             	sub    0x8(%ebp),%eax
  801bee:	89 c2                	mov    %eax,%edx
  801bf0:	a1 68 e0 81 00       	mov    0x81e068,%eax
  801bf5:	39 c2                	cmp    %eax,%edx
  801bf7:	0f 86 b9 00 00 00    	jbe    801cb6 <malloc+0x18d>
					uint32 requestedblockva = uheapPageAllocBreak;
  801bfd:	a1 68 e0 81 00       	mov    0x81e068,%eax
  801c02:	89 45 dc             	mov    %eax,-0x24(%ebp)
					uheapPageAllocBreak+=size;
  801c05:	8b 15 68 e0 81 00    	mov    0x81e068,%edx
  801c0b:	8b 45 08             	mov    0x8(%ebp),%eax
  801c0e:	01 d0                	add    %edx,%eax
  801c10:	a3 68 e0 81 00       	mov    %eax,0x81e068
					allocblock->startva = requestedblockva;
  801c15:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801c18:	8b 55 dc             	mov    -0x24(%ebp),%edx
  801c1b:	89 10                	mov    %edx,(%eax)
					allocblock->size = size;
  801c1d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801c20:	8b 55 08             	mov    0x8(%ebp),%edx
  801c23:	89 50 04             	mov    %edx,0x4(%eax)

					LIST_INSERT_TAIL(&u_allocatedlist, allocblock);
  801c26:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801c2a:	75 14                	jne    801c40 <malloc+0x117>
  801c2c:	83 ec 04             	sub    $0x4,%esp
  801c2f:	68 d8 51 80 00       	push   $0x8051d8
  801c34:	6a 60                	push   $0x60
  801c36:	68 8c 51 80 00       	push   $0x80518c
  801c3b:	e8 02 ec ff ff       	call   800842 <_panic>
  801c40:	8b 15 34 e1 81 00    	mov    0x81e134,%edx
  801c46:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801c49:	89 50 0c             	mov    %edx,0xc(%eax)
  801c4c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801c4f:	8b 40 0c             	mov    0xc(%eax),%eax
  801c52:	85 c0                	test   %eax,%eax
  801c54:	74 0d                	je     801c63 <malloc+0x13a>
  801c56:	a1 34 e1 81 00       	mov    0x81e134,%eax
  801c5b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801c5e:	89 50 08             	mov    %edx,0x8(%eax)
  801c61:	eb 08                	jmp    801c6b <malloc+0x142>
  801c63:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801c66:	a3 30 e1 81 00       	mov    %eax,0x81e130
  801c6b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801c6e:	a3 34 e1 81 00       	mov    %eax,0x81e134
  801c73:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801c76:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  801c7d:	a1 3c e1 81 00       	mov    0x81e13c,%eax
  801c82:	40                   	inc    %eax
  801c83:	a3 3c e1 81 00       	mov    %eax,0x81e13c


					sys_allocate_user_mem(allocblock->startva ,size);
  801c88:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801c8b:	8b 00                	mov    (%eax),%eax
  801c8d:	83 ec 08             	sub    $0x8,%esp
  801c90:	ff 75 08             	pushl  0x8(%ebp)
  801c93:	50                   	push   %eax
  801c94:	e8 34 1c 00 00       	call   8038cd <sys_allocate_user_mem>
  801c99:	83 c4 10             	add    $0x10,%esp
					release_uspinlock(&ulock);
  801c9c:	83 ec 0c             	sub    $0xc,%esp
  801c9f:	68 40 e1 81 00       	push   $0x81e140
  801ca4:	e8 6c 27 00 00       	call   804415 <release_uspinlock>
  801ca9:	83 c4 10             	add    $0x10,%esp
					return (void*)allocblock->startva;
  801cac:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801caf:	8b 00                	mov    (%eax),%eax
  801cb1:	e9 6f 03 00 00       	jmp    802025 <malloc+0x4fc>
			}else{
					release_uspinlock(&ulock);
  801cb6:	83 ec 0c             	sub    $0xc,%esp
  801cb9:	68 40 e1 81 00       	push   $0x81e140
  801cbe:	e8 52 27 00 00       	call   804415 <release_uspinlock>
  801cc3:	83 c4 10             	add    $0x10,%esp
					return NULL;
  801cc6:	b8 00 00 00 00       	mov    $0x0,%eax
  801ccb:	e9 55 03 00 00       	jmp    802025 <malloc+0x4fc>
				}
	}else{
		//custom fit
		struct UserHeapStruct* currentfreeelement = LIST_FIRST(&u_freelist);
  801cd0:	a1 20 e1 81 00       	mov    0x81e120,%eax
  801cd5:	89 45 f4             	mov    %eax,-0xc(%ebp)
		//worst fit
		while(currentfreeelement != NULL){
  801cd8:	e9 39 03 00 00       	jmp    802016 <malloc+0x4ed>
			if(size<currentfreeelement->size){
  801cdd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ce0:	8b 40 04             	mov    0x4(%eax),%eax
  801ce3:	3b 45 08             	cmp    0x8(%ebp),%eax
  801ce6:	0f 86 e7 01 00 00    	jbe    801ed3 <malloc+0x3aa>
				allocblock->startva = lastfreeelement->startva;
  801cec:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801cef:	8b 10                	mov    (%eax),%edx
  801cf1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801cf4:	89 10                	mov    %edx,(%eax)
                allocblock->size = size;
  801cf6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801cf9:	8b 55 08             	mov    0x8(%ebp),%edx
  801cfc:	89 50 04             	mov    %edx,0x4(%eax)
                LIST_INSERT_TAIL(&u_allocatedlist,allocblock);
  801cff:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801d03:	75 14                	jne    801d19 <malloc+0x1f0>
  801d05:	83 ec 04             	sub    $0x4,%esp
  801d08:	68 d8 51 80 00       	push   $0x8051d8
  801d0d:	6a 72                	push   $0x72
  801d0f:	68 8c 51 80 00       	push   $0x80518c
  801d14:	e8 29 eb ff ff       	call   800842 <_panic>
  801d19:	8b 15 34 e1 81 00    	mov    0x81e134,%edx
  801d1f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801d22:	89 50 0c             	mov    %edx,0xc(%eax)
  801d25:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801d28:	8b 40 0c             	mov    0xc(%eax),%eax
  801d2b:	85 c0                	test   %eax,%eax
  801d2d:	74 0d                	je     801d3c <malloc+0x213>
  801d2f:	a1 34 e1 81 00       	mov    0x81e134,%eax
  801d34:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801d37:	89 50 08             	mov    %edx,0x8(%eax)
  801d3a:	eb 08                	jmp    801d44 <malloc+0x21b>
  801d3c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801d3f:	a3 30 e1 81 00       	mov    %eax,0x81e130
  801d44:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801d47:	a3 34 e1 81 00       	mov    %eax,0x81e134
  801d4c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801d4f:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  801d56:	a1 3c e1 81 00       	mov    0x81e13c,%eax
  801d5b:	40                   	inc    %eax
  801d5c:	a3 3c e1 81 00       	mov    %eax,0x81e13c
                lastfreeelement->startva += size;
  801d61:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801d64:	8b 10                	mov    (%eax),%edx
  801d66:	8b 45 08             	mov    0x8(%ebp),%eax
  801d69:	01 c2                	add    %eax,%edx
  801d6b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801d6e:	89 10                	mov    %edx,(%eax)
                lastfreeelement->size -= size;
  801d70:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801d73:	8b 40 04             	mov    0x4(%eax),%eax
  801d76:	2b 45 08             	sub    0x8(%ebp),%eax
  801d79:	89 c2                	mov    %eax,%edx
  801d7b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801d7e:	89 50 04             	mov    %edx,0x4(%eax)
                struct UserHeapStruct* currentfree2 = LIST_FIRST(&u_freelist);
  801d81:	a1 20 e1 81 00       	mov    0x81e120,%eax
  801d86:	89 45 f0             	mov    %eax,-0x10(%ebp)
                //check order of last element

                while (currentfree2 != NULL){
  801d89:	e9 0d 01 00 00       	jmp    801e9b <malloc+0x372>
                	if(lastfreeelement->size <currentfree2->size){
  801d8e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801d91:	8b 50 04             	mov    0x4(%eax),%edx
  801d94:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d97:	8b 40 04             	mov    0x4(%eax),%eax
  801d9a:	39 c2                	cmp    %eax,%edx
  801d9c:	0f 83 f0 00 00 00    	jae    801e92 <malloc+0x369>
                		LIST_REMOVE(&u_freelist ,lastfreeelement);
  801da2:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801da6:	75 14                	jne    801dbc <malloc+0x293>
  801da8:	83 ec 04             	sub    $0x4,%esp
  801dab:	68 fb 51 80 00       	push   $0x8051fb
  801db0:	6a 7a                	push   $0x7a
  801db2:	68 8c 51 80 00       	push   $0x80518c
  801db7:	e8 86 ea ff ff       	call   800842 <_panic>
  801dbc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801dbf:	8b 40 08             	mov    0x8(%eax),%eax
  801dc2:	85 c0                	test   %eax,%eax
  801dc4:	74 11                	je     801dd7 <malloc+0x2ae>
  801dc6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801dc9:	8b 40 08             	mov    0x8(%eax),%eax
  801dcc:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801dcf:	8b 52 0c             	mov    0xc(%edx),%edx
  801dd2:	89 50 0c             	mov    %edx,0xc(%eax)
  801dd5:	eb 0b                	jmp    801de2 <malloc+0x2b9>
  801dd7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801dda:	8b 40 0c             	mov    0xc(%eax),%eax
  801ddd:	a3 24 e1 81 00       	mov    %eax,0x81e124
  801de2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801de5:	8b 40 0c             	mov    0xc(%eax),%eax
  801de8:	85 c0                	test   %eax,%eax
  801dea:	74 11                	je     801dfd <malloc+0x2d4>
  801dec:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801def:	8b 40 0c             	mov    0xc(%eax),%eax
  801df2:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801df5:	8b 52 08             	mov    0x8(%edx),%edx
  801df8:	89 50 08             	mov    %edx,0x8(%eax)
  801dfb:	eb 0b                	jmp    801e08 <malloc+0x2df>
  801dfd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801e00:	8b 40 08             	mov    0x8(%eax),%eax
  801e03:	a3 20 e1 81 00       	mov    %eax,0x81e120
  801e08:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801e0b:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  801e12:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801e15:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  801e1c:	a1 2c e1 81 00       	mov    0x81e12c,%eax
  801e21:	48                   	dec    %eax
  801e22:	a3 2c e1 81 00       	mov    %eax,0x81e12c
                		LIST_INSERT_BEFORE(&u_freelist ,currentfree2 ,lastfreeelement);
  801e27:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801e2b:	74 06                	je     801e33 <malloc+0x30a>
  801e2d:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801e31:	75 14                	jne    801e47 <malloc+0x31e>
  801e33:	83 ec 04             	sub    $0x4,%esp
  801e36:	68 1c 52 80 00       	push   $0x80521c
  801e3b:	6a 7b                	push   $0x7b
  801e3d:	68 8c 51 80 00       	push   $0x80518c
  801e42:	e8 fb e9 ff ff       	call   800842 <_panic>
  801e47:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e4a:	8b 50 0c             	mov    0xc(%eax),%edx
  801e4d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801e50:	89 50 0c             	mov    %edx,0xc(%eax)
  801e53:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801e56:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801e59:	89 50 08             	mov    %edx,0x8(%eax)
  801e5c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e5f:	8b 40 0c             	mov    0xc(%eax),%eax
  801e62:	85 c0                	test   %eax,%eax
  801e64:	74 0e                	je     801e74 <malloc+0x34b>
  801e66:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e69:	8b 40 0c             	mov    0xc(%eax),%eax
  801e6c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801e6f:	89 50 08             	mov    %edx,0x8(%eax)
  801e72:	eb 08                	jmp    801e7c <malloc+0x353>
  801e74:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801e77:	a3 20 e1 81 00       	mov    %eax,0x81e120
  801e7c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e7f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801e82:	89 50 0c             	mov    %edx,0xc(%eax)
  801e85:	a1 2c e1 81 00       	mov    0x81e12c,%eax
  801e8a:	40                   	inc    %eax
  801e8b:	a3 2c e1 81 00       	mov    %eax,0x81e12c
                		break;
  801e90:	eb 13                	jmp    801ea5 <malloc+0x37c>
                	}
                	currentfree2 = currentfree2->prev_next_info.le_next;
  801e92:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e95:	8b 40 08             	mov    0x8(%eax),%eax
  801e98:	89 45 f0             	mov    %eax,-0x10(%ebp)
                lastfreeelement->startva += size;
                lastfreeelement->size -= size;
                struct UserHeapStruct* currentfree2 = LIST_FIRST(&u_freelist);
                //check order of last element

                while (currentfree2 != NULL){
  801e9b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801e9f:	0f 85 e9 fe ff ff    	jne    801d8e <malloc+0x265>
                	}
                	currentfree2 = currentfree2->prev_next_info.le_next;
                }


                sys_allocate_user_mem(allocblock->startva ,size);
  801ea5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801ea8:	8b 00                	mov    (%eax),%eax
  801eaa:	83 ec 08             	sub    $0x8,%esp
  801ead:	ff 75 08             	pushl  0x8(%ebp)
  801eb0:	50                   	push   %eax
  801eb1:	e8 17 1a 00 00       	call   8038cd <sys_allocate_user_mem>
  801eb6:	83 c4 10             	add    $0x10,%esp
                release_uspinlock(&ulock);
  801eb9:	83 ec 0c             	sub    $0xc,%esp
  801ebc:	68 40 e1 81 00       	push   $0x81e140
  801ec1:	e8 4f 25 00 00       	call   804415 <release_uspinlock>
  801ec6:	83 c4 10             	add    $0x10,%esp
                return (void*)allocblock->startva;
  801ec9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801ecc:	8b 00                	mov    (%eax),%eax
  801ece:	e9 52 01 00 00       	jmp    802025 <malloc+0x4fc>
                //exact fit
			}else if(size == currentfreeelement->size){
  801ed3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ed6:	8b 40 04             	mov    0x4(%eax),%eax
  801ed9:	3b 45 08             	cmp    0x8(%ebp),%eax
  801edc:	0f 85 2b 01 00 00    	jne    80200d <malloc+0x4e4>
				allocblock->startva = currentfreeelement->startva;
  801ee2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ee5:	8b 10                	mov    (%eax),%edx
  801ee7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801eea:	89 10                	mov    %edx,(%eax)
				allocblock->size = size;
  801eec:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801eef:	8b 55 08             	mov    0x8(%ebp),%edx
  801ef2:	89 50 04             	mov    %edx,0x4(%eax)
				LIST_INSERT_TAIL(&u_allocatedlist ,allocblock);
  801ef5:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801ef9:	75 17                	jne    801f12 <malloc+0x3e9>
  801efb:	83 ec 04             	sub    $0x4,%esp
  801efe:	68 d8 51 80 00       	push   $0x8051d8
  801f03:	68 89 00 00 00       	push   $0x89
  801f08:	68 8c 51 80 00       	push   $0x80518c
  801f0d:	e8 30 e9 ff ff       	call   800842 <_panic>
  801f12:	8b 15 34 e1 81 00    	mov    0x81e134,%edx
  801f18:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f1b:	89 50 0c             	mov    %edx,0xc(%eax)
  801f1e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f21:	8b 40 0c             	mov    0xc(%eax),%eax
  801f24:	85 c0                	test   %eax,%eax
  801f26:	74 0d                	je     801f35 <malloc+0x40c>
  801f28:	a1 34 e1 81 00       	mov    0x81e134,%eax
  801f2d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801f30:	89 50 08             	mov    %edx,0x8(%eax)
  801f33:	eb 08                	jmp    801f3d <malloc+0x414>
  801f35:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f38:	a3 30 e1 81 00       	mov    %eax,0x81e130
  801f3d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f40:	a3 34 e1 81 00       	mov    %eax,0x81e134
  801f45:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f48:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  801f4f:	a1 3c e1 81 00       	mov    0x81e13c,%eax
  801f54:	40                   	inc    %eax
  801f55:	a3 3c e1 81 00       	mov    %eax,0x81e13c
				LIST_REMOVE(&u_freelist ,currentfreeelement);
  801f5a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f5e:	75 17                	jne    801f77 <malloc+0x44e>
  801f60:	83 ec 04             	sub    $0x4,%esp
  801f63:	68 fb 51 80 00       	push   $0x8051fb
  801f68:	68 8a 00 00 00       	push   $0x8a
  801f6d:	68 8c 51 80 00       	push   $0x80518c
  801f72:	e8 cb e8 ff ff       	call   800842 <_panic>
  801f77:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f7a:	8b 40 08             	mov    0x8(%eax),%eax
  801f7d:	85 c0                	test   %eax,%eax
  801f7f:	74 11                	je     801f92 <malloc+0x469>
  801f81:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f84:	8b 40 08             	mov    0x8(%eax),%eax
  801f87:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f8a:	8b 52 0c             	mov    0xc(%edx),%edx
  801f8d:	89 50 0c             	mov    %edx,0xc(%eax)
  801f90:	eb 0b                	jmp    801f9d <malloc+0x474>
  801f92:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f95:	8b 40 0c             	mov    0xc(%eax),%eax
  801f98:	a3 24 e1 81 00       	mov    %eax,0x81e124
  801f9d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fa0:	8b 40 0c             	mov    0xc(%eax),%eax
  801fa3:	85 c0                	test   %eax,%eax
  801fa5:	74 11                	je     801fb8 <malloc+0x48f>
  801fa7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801faa:	8b 40 0c             	mov    0xc(%eax),%eax
  801fad:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801fb0:	8b 52 08             	mov    0x8(%edx),%edx
  801fb3:	89 50 08             	mov    %edx,0x8(%eax)
  801fb6:	eb 0b                	jmp    801fc3 <malloc+0x49a>
  801fb8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fbb:	8b 40 08             	mov    0x8(%eax),%eax
  801fbe:	a3 20 e1 81 00       	mov    %eax,0x81e120
  801fc3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fc6:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  801fcd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fd0:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  801fd7:	a1 2c e1 81 00       	mov    0x81e12c,%eax
  801fdc:	48                   	dec    %eax
  801fdd:	a3 2c e1 81 00       	mov    %eax,0x81e12c
				sys_allocate_user_mem(allocblock->startva ,size);
  801fe2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801fe5:	8b 00                	mov    (%eax),%eax
  801fe7:	83 ec 08             	sub    $0x8,%esp
  801fea:	ff 75 08             	pushl  0x8(%ebp)
  801fed:	50                   	push   %eax
  801fee:	e8 da 18 00 00       	call   8038cd <sys_allocate_user_mem>
  801ff3:	83 c4 10             	add    $0x10,%esp
				release_uspinlock(&ulock);
  801ff6:	83 ec 0c             	sub    $0xc,%esp
  801ff9:	68 40 e1 81 00       	push   $0x81e140
  801ffe:	e8 12 24 00 00       	call   804415 <release_uspinlock>
  802003:	83 c4 10             	add    $0x10,%esp
				return (void*)allocblock->startva;
  802006:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802009:	8b 00                	mov    (%eax),%eax
  80200b:	eb 18                	jmp    802025 <malloc+0x4fc>
			}
			currentfreeelement = currentfreeelement->prev_next_info.le_next;
  80200d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802010:	8b 40 08             	mov    0x8(%eax),%eax
  802013:	89 45 f4             	mov    %eax,-0xc(%ebp)
				}
	}else{
		//custom fit
		struct UserHeapStruct* currentfreeelement = LIST_FIRST(&u_freelist);
		//worst fit
		while(currentfreeelement != NULL){
  802016:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80201a:	0f 85 bd fc ff ff    	jne    801cdd <malloc+0x1b4>
				return (void*)allocblock->startva;
			}
			currentfreeelement = currentfreeelement->prev_next_info.le_next;
		}
	}
	 return NULL;
  802020:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802025:	c9                   	leave  
  802026:	c3                   	ret    

00802027 <free>:

//=================================
// [2] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
  802027:	55                   	push   %ebp
  802028:	89 e5                	mov    %esp,%ebp
  80202a:	83 ec 38             	sub    $0x38,%esp
	uint32  VA = ROUNDDOWN(((uint32 ) virtual_address), PAGE_SIZE);
  80202d:	8b 45 08             	mov    0x8(%ebp),%eax
  802030:	89 45 dc             	mov    %eax,-0x24(%ebp)
  802033:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802036:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80203b:	89 45 d8             	mov    %eax,-0x28(%ebp)


		uheap_init();
  80203e:	e8 b2 f9 ff ff       	call   8019f5 <uheap_init>
		acquire_uspinlock(&ulock);
  802043:	83 ec 0c             	sub    $0xc,%esp
  802046:	68 40 e1 81 00       	push   $0x81e140
  80204b:	e8 6d 23 00 00       	call   8043bd <acquire_uspinlock>
  802050:	83 c4 10             	add    $0x10,%esp
		if (VA < uheapPageAllocStart){
  802053:	a1 10 e1 81 00       	mov    0x81e110,%eax
  802058:	39 45 d8             	cmp    %eax,-0x28(%ebp)
  80205b:	73 23                	jae    802080 <free+0x59>
			free_block(virtual_address);
  80205d:	83 ec 0c             	sub    $0xc,%esp
  802060:	ff 75 08             	pushl  0x8(%ebp)
  802063:	e8 89 1f 00 00       	call   803ff1 <free_block>
  802068:	83 c4 10             	add    $0x10,%esp
			release_uspinlock(&ulock);
  80206b:	83 ec 0c             	sub    $0xc,%esp
  80206e:	68 40 e1 81 00       	push   $0x81e140
  802073:	e8 9d 23 00 00       	call   804415 <release_uspinlock>
  802078:	83 c4 10             	add    $0x10,%esp
			return;
  80207b:	e9 35 07 00 00       	jmp    8027b5 <free+0x78e>
		}
		if (VA >= uheapPageAllocBreak){
  802080:	a1 68 e0 81 00       	mov    0x81e068,%eax
  802085:	39 45 d8             	cmp    %eax,-0x28(%ebp)
  802088:	72 30                	jb     8020ba <free+0x93>
			cprintf("%d\n %d\n", VA, uheapPageAllocBreak);
  80208a:	a1 68 e0 81 00       	mov    0x81e068,%eax
  80208f:	83 ec 04             	sub    $0x4,%esp
  802092:	50                   	push   %eax
  802093:	ff 75 d8             	pushl  -0x28(%ebp)
  802096:	68 51 52 80 00       	push   $0x805251
  80209b:	e8 70 ea ff ff       	call   800b10 <cprintf>
  8020a0:	83 c4 10             	add    $0x10,%esp

			panic("freeing from restricted area");
  8020a3:	83 ec 04             	sub    $0x4,%esp
  8020a6:	68 59 52 80 00       	push   $0x805259
  8020ab:	68 a7 00 00 00       	push   $0xa7
  8020b0:	68 8c 51 80 00       	push   $0x80518c
  8020b5:	e8 88 e7 ff ff       	call   800842 <_panic>
			release_uspinlock(&ulock);
			return;
		}

		struct UserHeapStruct* newfree = (struct UserHeapStruct*) alloc_block(sizeof(struct UserHeapStruct));
  8020ba:	83 ec 0c             	sub    $0xc,%esp
  8020bd:	6a 10                	push   $0x10
  8020bf:	e8 91 1a 00 00       	call   803b55 <alloc_block>
  8020c4:	83 c4 10             	add    $0x10,%esp
  8020c7:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		struct UserHeapStruct* MergedBlock  = ( struct UserHeapStruct*)alloc_block(sizeof(struct UserHeapStruct));
  8020ca:	83 ec 0c             	sub    $0xc,%esp
  8020cd:	6a 10                	push   $0x10
  8020cf:	e8 81 1a 00 00       	call   803b55 <alloc_block>
  8020d4:	83 c4 10             	add    $0x10,%esp
  8020d7:	89 45 d0             	mov    %eax,-0x30(%ebp)

		struct UserHeapStruct* ToBefreed = LIST_FIRST(&u_allocatedlist);
  8020da:	a1 30 e1 81 00       	mov    0x81e130,%eax
  8020df:	89 45 f4             	mov    %eax,-0xc(%ebp)
		bool foundVA = 0;
  8020e2:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

		//find the allocated block
		while(ToBefreed !=NULL ){
  8020e9:	eb 1c                	jmp    802107 <free+0xe0>

			if (VA ==ToBefreed->startva ){
  8020eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020ee:	8b 00                	mov    (%eax),%eax
  8020f0:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  8020f3:	75 09                	jne    8020fe <free+0xd7>
				foundVA = 1;
  8020f5:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
				break;
  8020fc:	eb 0f                	jmp    80210d <free+0xe6>
			}
				ToBefreed = ToBefreed->prev_next_info.le_next;
  8020fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802101:	8b 40 08             	mov    0x8(%eax),%eax
  802104:	89 45 f4             	mov    %eax,-0xc(%ebp)

		struct UserHeapStruct* ToBefreed = LIST_FIRST(&u_allocatedlist);
		bool foundVA = 0;

		//find the allocated block
		while(ToBefreed !=NULL ){
  802107:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80210b:	75 de                	jne    8020eb <free+0xc4>
			}
				ToBefreed = ToBefreed->prev_next_info.le_next;
		}


		if(!foundVA){
  80210d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802111:	75 17                	jne    80212a <free+0x103>
				panic("INVALID ADDRESS!");
  802113:	83 ec 04             	sub    $0x4,%esp
  802116:	68 76 52 80 00       	push   $0x805276
  80211b:	68 be 00 00 00       	push   $0xbe
  802120:	68 8c 51 80 00       	push   $0x80518c
  802125:	e8 18 e7 ff ff       	call   800842 <_panic>
				release_uspinlock(&ulock);
				return;
			}


		newfree->startva = ToBefreed->startva;
  80212a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80212d:	8b 10                	mov    (%eax),%edx
  80212f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802132:	89 10                	mov    %edx,(%eax)
		newfree->size = ToBefreed->size;
  802134:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802137:	8b 50 04             	mov    0x4(%eax),%edx
  80213a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80213d:	89 50 04             	mov    %edx,0x4(%eax)

		//remove allocated block from alloclist
		LIST_REMOVE(&u_allocatedlist, ToBefreed);
  802140:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802144:	75 17                	jne    80215d <free+0x136>
  802146:	83 ec 04             	sub    $0x4,%esp
  802149:	68 fb 51 80 00       	push   $0x8051fb
  80214e:	68 c8 00 00 00       	push   $0xc8
  802153:	68 8c 51 80 00       	push   $0x80518c
  802158:	e8 e5 e6 ff ff       	call   800842 <_panic>
  80215d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802160:	8b 40 08             	mov    0x8(%eax),%eax
  802163:	85 c0                	test   %eax,%eax
  802165:	74 11                	je     802178 <free+0x151>
  802167:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80216a:	8b 40 08             	mov    0x8(%eax),%eax
  80216d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802170:	8b 52 0c             	mov    0xc(%edx),%edx
  802173:	89 50 0c             	mov    %edx,0xc(%eax)
  802176:	eb 0b                	jmp    802183 <free+0x15c>
  802178:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80217b:	8b 40 0c             	mov    0xc(%eax),%eax
  80217e:	a3 34 e1 81 00       	mov    %eax,0x81e134
  802183:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802186:	8b 40 0c             	mov    0xc(%eax),%eax
  802189:	85 c0                	test   %eax,%eax
  80218b:	74 11                	je     80219e <free+0x177>
  80218d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802190:	8b 40 0c             	mov    0xc(%eax),%eax
  802193:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802196:	8b 52 08             	mov    0x8(%edx),%edx
  802199:	89 50 08             	mov    %edx,0x8(%eax)
  80219c:	eb 0b                	jmp    8021a9 <free+0x182>
  80219e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021a1:	8b 40 08             	mov    0x8(%eax),%eax
  8021a4:	a3 30 e1 81 00       	mov    %eax,0x81e130
  8021a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021ac:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  8021b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021b6:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  8021bd:	a1 3c e1 81 00       	mov    0x81e13c,%eax
  8021c2:	48                   	dec    %eax
  8021c3:	a3 3c e1 81 00       	mov    %eax,0x81e13c

		sys_free_user_mem(ToBefreed->startva, ToBefreed->size);
  8021c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021cb:	8b 50 04             	mov    0x4(%eax),%edx
  8021ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021d1:	8b 00                	mov    (%eax),%eax
  8021d3:	83 ec 08             	sub    $0x8,%esp
  8021d6:	52                   	push   %edx
  8021d7:	50                   	push   %eax
  8021d8:	e8 d4 16 00 00       	call   8038b1 <sys_free_user_mem>
  8021dd:	83 c4 10             	add    $0x10,%esp




		if(LIST_SIZE(&u_freelist) == 0){
  8021e0:	a1 2c e1 81 00       	mov    0x81e12c,%eax
  8021e5:	85 c0                	test   %eax,%eax
  8021e7:	75 7a                	jne    802263 <free+0x23c>
			LIST_INSERT_HEAD(&u_freelist,newfree);
  8021e9:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8021ed:	75 17                	jne    802206 <free+0x1df>
  8021ef:	83 ec 04             	sub    $0x4,%esp
  8021f2:	68 88 52 80 00       	push   $0x805288
  8021f7:	68 d0 00 00 00       	push   $0xd0
  8021fc:	68 8c 51 80 00       	push   $0x80518c
  802201:	e8 3c e6 ff ff       	call   800842 <_panic>
  802206:	8b 15 20 e1 81 00    	mov    0x81e120,%edx
  80220c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80220f:	89 50 08             	mov    %edx,0x8(%eax)
  802212:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802215:	8b 40 08             	mov    0x8(%eax),%eax
  802218:	85 c0                	test   %eax,%eax
  80221a:	74 0d                	je     802229 <free+0x202>
  80221c:	a1 20 e1 81 00       	mov    0x81e120,%eax
  802221:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802224:	89 50 0c             	mov    %edx,0xc(%eax)
  802227:	eb 08                	jmp    802231 <free+0x20a>
  802229:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80222c:	a3 24 e1 81 00       	mov    %eax,0x81e124
  802231:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802234:	a3 20 e1 81 00       	mov    %eax,0x81e120
  802239:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80223c:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  802243:	a1 2c e1 81 00       	mov    0x81e12c,%eax
  802248:	40                   	inc    %eax
  802249:	a3 2c e1 81 00       	mov    %eax,0x81e12c
			release_uspinlock(&ulock);
  80224e:	83 ec 0c             	sub    $0xc,%esp
  802251:	68 40 e1 81 00       	push   $0x81e140
  802256:	e8 ba 21 00 00       	call   804415 <release_uspinlock>
  80225b:	83 c4 10             	add    $0x10,%esp
			return;
  80225e:	e9 52 05 00 00       	jmp    8027b5 <free+0x78e>
		}


		struct UserHeapStruct* ToBeMerged = LIST_FIRST(&u_freelist);
  802263:	a1 20 e1 81 00       	mov    0x81e120,%eax
  802268:	89 45 ec             	mov    %eax,-0x14(%ebp)
		// merge with prev if possible
		bool mergeprev = 0;
  80226b:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		bool mergenext = 0;
  802272:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
		while(ToBeMerged != NULL){
  802279:	e9 d2 00 00 00       	jmp    802350 <free+0x329>
			if((ToBeMerged->startva +ToBeMerged->size) == newfree->startva){
  80227e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802281:	8b 10                	mov    (%eax),%edx
  802283:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802286:	8b 40 04             	mov    0x4(%eax),%eax
  802289:	01 c2                	add    %eax,%edx
  80228b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80228e:	8b 00                	mov    (%eax),%eax
  802290:	39 c2                	cmp    %eax,%edx
  802292:	0f 85 af 00 00 00    	jne    802347 <free+0x320>

				MergedBlock->startva = ToBeMerged->startva;
  802298:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80229b:	8b 10                	mov    (%eax),%edx
  80229d:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8022a0:	89 10                	mov    %edx,(%eax)
				MergedBlock->size = ToBeMerged->size + newfree->size;
  8022a2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8022a5:	8b 50 04             	mov    0x4(%eax),%edx
  8022a8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8022ab:	8b 40 04             	mov    0x4(%eax),%eax
  8022ae:	01 c2                	add    %eax,%edx
  8022b0:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8022b3:	89 50 04             	mov    %edx,0x4(%eax)
				LIST_REMOVE(&u_freelist, ToBeMerged);
  8022b6:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8022ba:	75 17                	jne    8022d3 <free+0x2ac>
  8022bc:	83 ec 04             	sub    $0x4,%esp
  8022bf:	68 fb 51 80 00       	push   $0x8051fb
  8022c4:	68 df 00 00 00       	push   $0xdf
  8022c9:	68 8c 51 80 00       	push   $0x80518c
  8022ce:	e8 6f e5 ff ff       	call   800842 <_panic>
  8022d3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8022d6:	8b 40 08             	mov    0x8(%eax),%eax
  8022d9:	85 c0                	test   %eax,%eax
  8022db:	74 11                	je     8022ee <free+0x2c7>
  8022dd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8022e0:	8b 40 08             	mov    0x8(%eax),%eax
  8022e3:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8022e6:	8b 52 0c             	mov    0xc(%edx),%edx
  8022e9:	89 50 0c             	mov    %edx,0xc(%eax)
  8022ec:	eb 0b                	jmp    8022f9 <free+0x2d2>
  8022ee:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8022f1:	8b 40 0c             	mov    0xc(%eax),%eax
  8022f4:	a3 24 e1 81 00       	mov    %eax,0x81e124
  8022f9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8022fc:	8b 40 0c             	mov    0xc(%eax),%eax
  8022ff:	85 c0                	test   %eax,%eax
  802301:	74 11                	je     802314 <free+0x2ed>
  802303:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802306:	8b 40 0c             	mov    0xc(%eax),%eax
  802309:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80230c:	8b 52 08             	mov    0x8(%edx),%edx
  80230f:	89 50 08             	mov    %edx,0x8(%eax)
  802312:	eb 0b                	jmp    80231f <free+0x2f8>
  802314:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802317:	8b 40 08             	mov    0x8(%eax),%eax
  80231a:	a3 20 e1 81 00       	mov    %eax,0x81e120
  80231f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802322:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802329:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80232c:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  802333:	a1 2c e1 81 00       	mov    0x81e12c,%eax
  802338:	48                   	dec    %eax
  802339:	a3 2c e1 81 00       	mov    %eax,0x81e12c
				mergeprev = 1;
  80233e:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
				break;
  802345:	eb 13                	jmp    80235a <free+0x333>
			}
				ToBeMerged = ToBeMerged->prev_next_info.le_next;
  802347:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80234a:	8b 40 08             	mov    0x8(%eax),%eax
  80234d:	89 45 ec             	mov    %eax,-0x14(%ebp)

		struct UserHeapStruct* ToBeMerged = LIST_FIRST(&u_freelist);
		// merge with prev if possible
		bool mergeprev = 0;
		bool mergenext = 0;
		while(ToBeMerged != NULL){
  802350:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802354:	0f 85 24 ff ff ff    	jne    80227e <free+0x257>
//									uheapPageAllocBreak = newfree->startva;
//						}
//					}


		if ( newfree ->startva + newfree->size == uheapPageAllocBreak){
  80235a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80235d:	8b 10                	mov    (%eax),%edx
  80235f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802362:	8b 40 04             	mov    0x4(%eax),%eax
  802365:	01 c2                	add    %eax,%edx
  802367:	a1 68 e0 81 00       	mov    0x81e068,%eax
  80236c:	39 c2                	cmp    %eax,%edx
  80236e:	75 44                	jne    8023b4 <free+0x38d>

			if(mergeprev){
  802370:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802374:	74 1f                	je     802395 <free+0x36e>
				uheapPageAllocBreak = MergedBlock->startva;
  802376:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802379:	8b 00                	mov    (%eax),%eax
  80237b:	a3 68 e0 81 00       	mov    %eax,0x81e068
				release_uspinlock(&ulock);
  802380:	83 ec 0c             	sub    $0xc,%esp
  802383:	68 40 e1 81 00       	push   $0x81e140
  802388:	e8 88 20 00 00       	call   804415 <release_uspinlock>
  80238d:	83 c4 10             	add    $0x10,%esp
				return;
  802390:	e9 20 04 00 00       	jmp    8027b5 <free+0x78e>

			}else{
				uheapPageAllocBreak = newfree->startva;
  802395:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802398:	8b 00                	mov    (%eax),%eax
  80239a:	a3 68 e0 81 00       	mov    %eax,0x81e068
				release_uspinlock(&ulock);
  80239f:	83 ec 0c             	sub    $0xc,%esp
  8023a2:	68 40 e1 81 00       	push   $0x81e140
  8023a7:	e8 69 20 00 00       	call   804415 <release_uspinlock>
  8023ac:	83 c4 10             	add    $0x10,%esp
				return;
  8023af:	e9 01 04 00 00       	jmp    8027b5 <free+0x78e>

		}


		//check if block is merged with prev ,and find possible merge with next
		ToBeMerged = LIST_FIRST(&u_freelist);
  8023b4:	a1 20 e1 81 00       	mov    0x81e120,%eax
  8023b9:	89 45 ec             	mov    %eax,-0x14(%ebp)
		while(ToBeMerged != NULL){
  8023bc:	e9 7d 01 00 00       	jmp    80253e <free+0x517>
			if ((newfree->startva + newfree->size) == ToBeMerged->startva ){
  8023c1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8023c4:	8b 10                	mov    (%eax),%edx
  8023c6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8023c9:	8b 40 04             	mov    0x4(%eax),%eax
  8023cc:	01 c2                	add    %eax,%edx
  8023ce:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8023d1:	8b 00                	mov    (%eax),%eax
  8023d3:	39 c2                	cmp    %eax,%edx
  8023d5:	0f 85 5a 01 00 00    	jne    802535 <free+0x50e>
				if (mergeprev){
  8023db:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8023df:	0f 84 a1 00 00 00    	je     802486 <free+0x45f>
					MergedBlock->size += ToBeMerged->size;
  8023e5:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8023e8:	8b 50 04             	mov    0x4(%eax),%edx
  8023eb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8023ee:	8b 40 04             	mov    0x4(%eax),%eax
  8023f1:	01 c2                	add    %eax,%edx
  8023f3:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8023f6:	89 50 04             	mov    %edx,0x4(%eax)
					LIST_REMOVE(&u_freelist, ToBeMerged);
  8023f9:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8023fd:	75 17                	jne    802416 <free+0x3ef>
  8023ff:	83 ec 04             	sub    $0x4,%esp
  802402:	68 fb 51 80 00       	push   $0x8051fb
  802407:	68 0a 01 00 00       	push   $0x10a
  80240c:	68 8c 51 80 00       	push   $0x80518c
  802411:	e8 2c e4 ff ff       	call   800842 <_panic>
  802416:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802419:	8b 40 08             	mov    0x8(%eax),%eax
  80241c:	85 c0                	test   %eax,%eax
  80241e:	74 11                	je     802431 <free+0x40a>
  802420:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802423:	8b 40 08             	mov    0x8(%eax),%eax
  802426:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802429:	8b 52 0c             	mov    0xc(%edx),%edx
  80242c:	89 50 0c             	mov    %edx,0xc(%eax)
  80242f:	eb 0b                	jmp    80243c <free+0x415>
  802431:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802434:	8b 40 0c             	mov    0xc(%eax),%eax
  802437:	a3 24 e1 81 00       	mov    %eax,0x81e124
  80243c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80243f:	8b 40 0c             	mov    0xc(%eax),%eax
  802442:	85 c0                	test   %eax,%eax
  802444:	74 11                	je     802457 <free+0x430>
  802446:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802449:	8b 40 0c             	mov    0xc(%eax),%eax
  80244c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80244f:	8b 52 08             	mov    0x8(%edx),%edx
  802452:	89 50 08             	mov    %edx,0x8(%eax)
  802455:	eb 0b                	jmp    802462 <free+0x43b>
  802457:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80245a:	8b 40 08             	mov    0x8(%eax),%eax
  80245d:	a3 20 e1 81 00       	mov    %eax,0x81e120
  802462:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802465:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  80246c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80246f:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  802476:	a1 2c e1 81 00       	mov    0x81e12c,%eax
  80247b:	48                   	dec    %eax
  80247c:	a3 2c e1 81 00       	mov    %eax,0x81e12c
					break;
  802481:	e9 c2 00 00 00       	jmp    802548 <free+0x521>
		//if not merged find possible merge with next
				}else{
					MergedBlock->startva = newfree->startva;
  802486:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802489:	8b 10                	mov    (%eax),%edx
  80248b:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80248e:	89 10                	mov    %edx,(%eax)
					MergedBlock->size  = newfree->size + ToBeMerged->size;
  802490:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802493:	8b 50 04             	mov    0x4(%eax),%edx
  802496:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802499:	8b 40 04             	mov    0x4(%eax),%eax
  80249c:	01 c2                	add    %eax,%edx
  80249e:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8024a1:	89 50 04             	mov    %edx,0x4(%eax)
					LIST_REMOVE(&u_freelist, ToBeMerged);
  8024a4:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8024a8:	75 17                	jne    8024c1 <free+0x49a>
  8024aa:	83 ec 04             	sub    $0x4,%esp
  8024ad:	68 fb 51 80 00       	push   $0x8051fb
  8024b2:	68 10 01 00 00       	push   $0x110
  8024b7:	68 8c 51 80 00       	push   $0x80518c
  8024bc:	e8 81 e3 ff ff       	call   800842 <_panic>
  8024c1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8024c4:	8b 40 08             	mov    0x8(%eax),%eax
  8024c7:	85 c0                	test   %eax,%eax
  8024c9:	74 11                	je     8024dc <free+0x4b5>
  8024cb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8024ce:	8b 40 08             	mov    0x8(%eax),%eax
  8024d1:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8024d4:	8b 52 0c             	mov    0xc(%edx),%edx
  8024d7:	89 50 0c             	mov    %edx,0xc(%eax)
  8024da:	eb 0b                	jmp    8024e7 <free+0x4c0>
  8024dc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8024df:	8b 40 0c             	mov    0xc(%eax),%eax
  8024e2:	a3 24 e1 81 00       	mov    %eax,0x81e124
  8024e7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8024ea:	8b 40 0c             	mov    0xc(%eax),%eax
  8024ed:	85 c0                	test   %eax,%eax
  8024ef:	74 11                	je     802502 <free+0x4db>
  8024f1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8024f4:	8b 40 0c             	mov    0xc(%eax),%eax
  8024f7:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8024fa:	8b 52 08             	mov    0x8(%edx),%edx
  8024fd:	89 50 08             	mov    %edx,0x8(%eax)
  802500:	eb 0b                	jmp    80250d <free+0x4e6>
  802502:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802505:	8b 40 08             	mov    0x8(%eax),%eax
  802508:	a3 20 e1 81 00       	mov    %eax,0x81e120
  80250d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802510:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802517:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80251a:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  802521:	a1 2c e1 81 00       	mov    0x81e12c,%eax
  802526:	48                   	dec    %eax
  802527:	a3 2c e1 81 00       	mov    %eax,0x81e12c
					mergenext = 1;
  80252c:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
					break;
  802533:	eb 13                	jmp    802548 <free+0x521>
				}
			}
			ToBeMerged = ToBeMerged->prev_next_info.le_next;
  802535:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802538:	8b 40 08             	mov    0x8(%eax),%eax
  80253b:	89 45 ec             	mov    %eax,-0x14(%ebp)
		}


		//check if block is merged with prev ,and find possible merge with next
		ToBeMerged = LIST_FIRST(&u_freelist);
		while(ToBeMerged != NULL){
  80253e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802542:	0f 85 79 fe ff ff    	jne    8023c1 <free+0x39a>




			// insertion
			struct UserHeapStruct* currentfree = LIST_FIRST(&u_freelist);
  802548:	a1 20 e1 81 00       	mov    0x81e120,%eax
  80254d:	89 45 e0             	mov    %eax,-0x20(%ebp)

			if(mergeprev || mergenext){
  802550:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802554:	0f 85 ad 00 00 00    	jne    802607 <free+0x5e0>
  80255a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80255e:	0f 84 c3 01 00 00    	je     802727 <free+0x700>
				while(currentfree != NULL){
  802564:	e9 9e 00 00 00       	jmp    802607 <free+0x5e0>
					if(MergedBlock->size < currentfree->size){
  802569:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80256c:	8b 50 04             	mov    0x4(%eax),%edx
  80256f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802572:	8b 40 04             	mov    0x4(%eax),%eax
  802575:	39 c2                	cmp    %eax,%edx
  802577:	0f 83 81 00 00 00    	jae    8025fe <free+0x5d7>

							LIST_INSERT_BEFORE(&u_freelist,currentfree,MergedBlock);
  80257d:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802581:	74 06                	je     802589 <free+0x562>
  802583:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  802587:	75 17                	jne    8025a0 <free+0x579>
  802589:	83 ec 04             	sub    $0x4,%esp
  80258c:	68 1c 52 80 00       	push   $0x80521c
  802591:	68 23 01 00 00       	push   $0x123
  802596:	68 8c 51 80 00       	push   $0x80518c
  80259b:	e8 a2 e2 ff ff       	call   800842 <_panic>
  8025a0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8025a3:	8b 50 0c             	mov    0xc(%eax),%edx
  8025a6:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8025a9:	89 50 0c             	mov    %edx,0xc(%eax)
  8025ac:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8025af:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8025b2:	89 50 08             	mov    %edx,0x8(%eax)
  8025b5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8025b8:	8b 40 0c             	mov    0xc(%eax),%eax
  8025bb:	85 c0                	test   %eax,%eax
  8025bd:	74 0e                	je     8025cd <free+0x5a6>
  8025bf:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8025c2:	8b 40 0c             	mov    0xc(%eax),%eax
  8025c5:	8b 55 d0             	mov    -0x30(%ebp),%edx
  8025c8:	89 50 08             	mov    %edx,0x8(%eax)
  8025cb:	eb 08                	jmp    8025d5 <free+0x5ae>
  8025cd:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8025d0:	a3 20 e1 81 00       	mov    %eax,0x81e120
  8025d5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8025d8:	8b 55 d0             	mov    -0x30(%ebp),%edx
  8025db:	89 50 0c             	mov    %edx,0xc(%eax)
  8025de:	a1 2c e1 81 00       	mov    0x81e12c,%eax
  8025e3:	40                   	inc    %eax
  8025e4:	a3 2c e1 81 00       	mov    %eax,0x81e12c
							release_uspinlock(&ulock);
  8025e9:	83 ec 0c             	sub    $0xc,%esp
  8025ec:	68 40 e1 81 00       	push   $0x81e140
  8025f1:	e8 1f 1e 00 00       	call   804415 <release_uspinlock>
  8025f6:	83 c4 10             	add    $0x10,%esp
							return;
  8025f9:	e9 b7 01 00 00       	jmp    8027b5 <free+0x78e>
					}
							currentfree = currentfree->prev_next_info.le_next;
  8025fe:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802601:	8b 40 08             	mov    0x8(%eax),%eax
  802604:	89 45 e0             	mov    %eax,-0x20(%ebp)

			// insertion
			struct UserHeapStruct* currentfree = LIST_FIRST(&u_freelist);

			if(mergeprev || mergenext){
				while(currentfree != NULL){
  802607:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80260b:	0f 85 58 ff ff ff    	jne    802569 <free+0x542>
							release_uspinlock(&ulock);
							return;
					}
							currentfree = currentfree->prev_next_info.le_next;
				}
				free_block(newfree);
  802611:	83 ec 0c             	sub    $0xc,%esp
  802614:	ff 75 d4             	pushl  -0x2c(%ebp)
  802617:	e8 d5 19 00 00       	call   803ff1 <free_block>
  80261c:	83 c4 10             	add    $0x10,%esp
				LIST_INSERT_TAIL(&u_freelist,MergedBlock);
  80261f:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  802623:	75 17                	jne    80263c <free+0x615>
  802625:	83 ec 04             	sub    $0x4,%esp
  802628:	68 d8 51 80 00       	push   $0x8051d8
  80262d:	68 2a 01 00 00       	push   $0x12a
  802632:	68 8c 51 80 00       	push   $0x80518c
  802637:	e8 06 e2 ff ff       	call   800842 <_panic>
  80263c:	8b 15 24 e1 81 00    	mov    0x81e124,%edx
  802642:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802645:	89 50 0c             	mov    %edx,0xc(%eax)
  802648:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80264b:	8b 40 0c             	mov    0xc(%eax),%eax
  80264e:	85 c0                	test   %eax,%eax
  802650:	74 0d                	je     80265f <free+0x638>
  802652:	a1 24 e1 81 00       	mov    0x81e124,%eax
  802657:	8b 55 d0             	mov    -0x30(%ebp),%edx
  80265a:	89 50 08             	mov    %edx,0x8(%eax)
  80265d:	eb 08                	jmp    802667 <free+0x640>
  80265f:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802662:	a3 20 e1 81 00       	mov    %eax,0x81e120
  802667:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80266a:	a3 24 e1 81 00       	mov    %eax,0x81e124
  80266f:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802672:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802679:	a1 2c e1 81 00       	mov    0x81e12c,%eax
  80267e:	40                   	inc    %eax
  80267f:	a3 2c e1 81 00       	mov    %eax,0x81e12c
  802684:	e9 1b 01 00 00       	jmp    8027a4 <free+0x77d>

			}else{
				while(currentfree != NULL){
					if(newfree->size < currentfree->size){
  802689:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80268c:	8b 50 04             	mov    0x4(%eax),%edx
  80268f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802692:	8b 40 04             	mov    0x4(%eax),%eax
  802695:	39 c2                	cmp    %eax,%edx
  802697:	0f 83 81 00 00 00    	jae    80271e <free+0x6f7>

							LIST_INSERT_BEFORE(&u_freelist,currentfree,newfree);
  80269d:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8026a1:	74 06                	je     8026a9 <free+0x682>
  8026a3:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8026a7:	75 17                	jne    8026c0 <free+0x699>
  8026a9:	83 ec 04             	sub    $0x4,%esp
  8026ac:	68 1c 52 80 00       	push   $0x80521c
  8026b1:	68 30 01 00 00       	push   $0x130
  8026b6:	68 8c 51 80 00       	push   $0x80518c
  8026bb:	e8 82 e1 ff ff       	call   800842 <_panic>
  8026c0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8026c3:	8b 50 0c             	mov    0xc(%eax),%edx
  8026c6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8026c9:	89 50 0c             	mov    %edx,0xc(%eax)
  8026cc:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8026cf:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8026d2:	89 50 08             	mov    %edx,0x8(%eax)
  8026d5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8026d8:	8b 40 0c             	mov    0xc(%eax),%eax
  8026db:	85 c0                	test   %eax,%eax
  8026dd:	74 0e                	je     8026ed <free+0x6c6>
  8026df:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8026e2:	8b 40 0c             	mov    0xc(%eax),%eax
  8026e5:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8026e8:	89 50 08             	mov    %edx,0x8(%eax)
  8026eb:	eb 08                	jmp    8026f5 <free+0x6ce>
  8026ed:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8026f0:	a3 20 e1 81 00       	mov    %eax,0x81e120
  8026f5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8026f8:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8026fb:	89 50 0c             	mov    %edx,0xc(%eax)
  8026fe:	a1 2c e1 81 00       	mov    0x81e12c,%eax
  802703:	40                   	inc    %eax
  802704:	a3 2c e1 81 00       	mov    %eax,0x81e12c
							release_uspinlock(&ulock);
  802709:	83 ec 0c             	sub    $0xc,%esp
  80270c:	68 40 e1 81 00       	push   $0x81e140
  802711:	e8 ff 1c 00 00       	call   804415 <release_uspinlock>
  802716:	83 c4 10             	add    $0x10,%esp
							return;
  802719:	e9 97 00 00 00       	jmp    8027b5 <free+0x78e>
					}
							currentfree = currentfree->prev_next_info.le_next;
  80271e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802721:	8b 40 08             	mov    0x8(%eax),%eax
  802724:	89 45 e0             	mov    %eax,-0x20(%ebp)
				}
				free_block(newfree);
				LIST_INSERT_TAIL(&u_freelist,MergedBlock);

			}else{
				while(currentfree != NULL){
  802727:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80272b:	0f 85 58 ff ff ff    	jne    802689 <free+0x662>
							release_uspinlock(&ulock);
							return;
					}
							currentfree = currentfree->prev_next_info.le_next;
				}
				free_block(MergedBlock);
  802731:	83 ec 0c             	sub    $0xc,%esp
  802734:	ff 75 d0             	pushl  -0x30(%ebp)
  802737:	e8 b5 18 00 00       	call   803ff1 <free_block>
  80273c:	83 c4 10             	add    $0x10,%esp
				LIST_INSERT_TAIL(&u_freelist,newfree);
  80273f:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  802743:	75 17                	jne    80275c <free+0x735>
  802745:	83 ec 04             	sub    $0x4,%esp
  802748:	68 d8 51 80 00       	push   $0x8051d8
  80274d:	68 37 01 00 00       	push   $0x137
  802752:	68 8c 51 80 00       	push   $0x80518c
  802757:	e8 e6 e0 ff ff       	call   800842 <_panic>
  80275c:	8b 15 24 e1 81 00    	mov    0x81e124,%edx
  802762:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802765:	89 50 0c             	mov    %edx,0xc(%eax)
  802768:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80276b:	8b 40 0c             	mov    0xc(%eax),%eax
  80276e:	85 c0                	test   %eax,%eax
  802770:	74 0d                	je     80277f <free+0x758>
  802772:	a1 24 e1 81 00       	mov    0x81e124,%eax
  802777:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80277a:	89 50 08             	mov    %edx,0x8(%eax)
  80277d:	eb 08                	jmp    802787 <free+0x760>
  80277f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802782:	a3 20 e1 81 00       	mov    %eax,0x81e120
  802787:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80278a:	a3 24 e1 81 00       	mov    %eax,0x81e124
  80278f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802792:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802799:	a1 2c e1 81 00       	mov    0x81e12c,%eax
  80279e:	40                   	inc    %eax
  80279f:	a3 2c e1 81 00       	mov    %eax,0x81e12c
			}
		release_uspinlock(&ulock);
  8027a4:	83 ec 0c             	sub    $0xc,%esp
  8027a7:	68 40 e1 81 00       	push   $0x81e140
  8027ac:	e8 64 1c 00 00       	call   804415 <release_uspinlock>
  8027b1:	83 c4 10             	add    $0x10,%esp
		return;
  8027b4:	90                   	nop
}
  8027b5:	c9                   	leave  
  8027b6:	c3                   	ret    

008027b7 <smalloc>:

//=================================
// [3] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  8027b7:	55                   	push   %ebp
  8027b8:	89 e5                	mov    %esp,%ebp
  8027ba:	83 ec 48             	sub    $0x48,%esp
  8027bd:	8b 45 10             	mov    0x10(%ebp),%eax
  8027c0:	88 45 c4             	mov    %al,-0x3c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  8027c3:	e8 2d f2 ff ff       	call   8019f5 <uheap_init>
	if (size == 0) return NULL;
  8027c8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8027cc:	75 0a                	jne    8027d8 <smalloc+0x21>
  8027ce:	b8 00 00 00 00       	mov    $0x0,%eax
  8027d3:	e9 84 05 00 00       	jmp    802d5c <smalloc+0x5a5>
	//==============================================================
	acquire_uspinlock(&ulock);
  8027d8:	83 ec 0c             	sub    $0xc,%esp
  8027db:	68 40 e1 81 00       	push   $0x81e140
  8027e0:	e8 d8 1b 00 00       	call   8043bd <acquire_uspinlock>
  8027e5:	83 c4 10             	add    $0x10,%esp

	struct UserHeapStruct* allocblock = (struct UserHeapStruct*) alloc_block(sizeof(struct UserHeapStruct));
  8027e8:	83 ec 0c             	sub    $0xc,%esp
  8027eb:	6a 10                	push   $0x10
  8027ed:	e8 63 13 00 00       	call   803b55 <alloc_block>
  8027f2:	83 c4 10             	add    $0x10,%esp
  8027f5:	89 45 ec             	mov    %eax,-0x14(%ebp)
	if (allocblock == NULL){
  8027f8:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8027fc:	75 0a                	jne    802808 <smalloc+0x51>
				return NULL;
  8027fe:	b8 00 00 00 00       	mov    $0x0,%eax
  802803:	e9 54 05 00 00       	jmp    802d5c <smalloc+0x5a5>
	}
		size = ROUNDUP(size,PAGE_SIZE);
  802808:	c7 45 e8 00 10 00 00 	movl   $0x1000,-0x18(%ebp)
  80280f:	8b 55 0c             	mov    0xc(%ebp),%edx
  802812:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802815:	01 d0                	add    %edx,%eax
  802817:	48                   	dec    %eax
  802818:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80281b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80281e:	ba 00 00 00 00       	mov    $0x0,%edx
  802823:	f7 75 e8             	divl   -0x18(%ebp)
  802826:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802829:	29 d0                	sub    %edx,%eax
  80282b:	89 45 0c             	mov    %eax,0xc(%ebp)
		struct UserHeapStruct* lastfreeelement = LIST_LAST(&u_freelist);
  80282e:	a1 24 e1 81 00       	mov    0x81e124,%eax
  802833:	89 45 e0             	mov    %eax,-0x20(%ebp)

		if(LIST_SIZE(&u_freelist)==0 || size>lastfreeelement->size){
  802836:	a1 2c e1 81 00       	mov    0x81e12c,%eax
  80283b:	85 c0                	test   %eax,%eax
  80283d:	74 0f                	je     80284e <smalloc+0x97>
  80283f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802842:	8b 40 04             	mov    0x4(%eax),%eax
  802845:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802848:	0f 83 25 01 00 00    	jae    802973 <smalloc+0x1bc>
				if(uheapPageAllocBreak <= USER_HEAP_MAX - size){
  80284e:	b8 00 00 00 a0       	mov    $0xa0000000,%eax
  802853:	2b 45 0c             	sub    0xc(%ebp),%eax
  802856:	89 c2                	mov    %eax,%edx
  802858:	a1 68 e0 81 00       	mov    0x81e068,%eax
  80285d:	39 c2                	cmp    %eax,%edx
  80285f:	0f 82 f4 00 00 00    	jb     802959 <smalloc+0x1a2>
						uint32 requestedblockva = uheapPageAllocBreak;
  802865:	a1 68 e0 81 00       	mov    0x81e068,%eax
  80286a:	89 45 d4             	mov    %eax,-0x2c(%ebp)
						uheapPageAllocBreak+=size;
  80286d:	8b 15 68 e0 81 00    	mov    0x81e068,%edx
  802873:	8b 45 0c             	mov    0xc(%ebp),%eax
  802876:	01 d0                	add    %edx,%eax
  802878:	a3 68 e0 81 00       	mov    %eax,0x81e068
						allocblock->startva = requestedblockva;
  80287d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802880:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802883:	89 10                	mov    %edx,(%eax)
						allocblock->size = size;
  802885:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802888:	8b 55 0c             	mov    0xc(%ebp),%edx
  80288b:	89 50 04             	mov    %edx,0x4(%eax)

						LIST_INSERT_TAIL(&u_allocatedlist, allocblock);
  80288e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802892:	75 17                	jne    8028ab <smalloc+0xf4>
  802894:	83 ec 04             	sub    $0x4,%esp
  802897:	68 d8 51 80 00       	push   $0x8051d8
  80289c:	68 57 01 00 00       	push   $0x157
  8028a1:	68 8c 51 80 00       	push   $0x80518c
  8028a6:	e8 97 df ff ff       	call   800842 <_panic>
  8028ab:	8b 15 34 e1 81 00    	mov    0x81e134,%edx
  8028b1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028b4:	89 50 0c             	mov    %edx,0xc(%eax)
  8028b7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028ba:	8b 40 0c             	mov    0xc(%eax),%eax
  8028bd:	85 c0                	test   %eax,%eax
  8028bf:	74 0d                	je     8028ce <smalloc+0x117>
  8028c1:	a1 34 e1 81 00       	mov    0x81e134,%eax
  8028c6:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8028c9:	89 50 08             	mov    %edx,0x8(%eax)
  8028cc:	eb 08                	jmp    8028d6 <smalloc+0x11f>
  8028ce:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028d1:	a3 30 e1 81 00       	mov    %eax,0x81e130
  8028d6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028d9:	a3 34 e1 81 00       	mov    %eax,0x81e134
  8028de:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028e1:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  8028e8:	a1 3c e1 81 00       	mov    0x81e13c,%eax
  8028ed:	40                   	inc    %eax
  8028ee:	a3 3c e1 81 00       	mov    %eax,0x81e13c


						int result = sys_create_shared_object(sharedVarName ,size ,isWritable ,(void*)allocblock->startva);
  8028f3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028f6:	8b 00                	mov    (%eax),%eax
  8028f8:	89 c2                	mov    %eax,%edx
  8028fa:	0f b6 45 c4          	movzbl -0x3c(%ebp),%eax
  8028fe:	52                   	push   %edx
  8028ff:	50                   	push   %eax
  802900:	ff 75 0c             	pushl  0xc(%ebp)
  802903:	ff 75 08             	pushl  0x8(%ebp)
  802906:	e8 48 0c 00 00       	call   803553 <sys_create_shared_object>
  80290b:	83 c4 10             	add    $0x10,%esp
  80290e:	89 45 d0             	mov    %eax,-0x30(%ebp)

						if(result <0){
  802911:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  802915:	79 28                	jns    80293f <smalloc+0x188>
							free_block(allocblock);
  802917:	83 ec 0c             	sub    $0xc,%esp
  80291a:	ff 75 ec             	pushl  -0x14(%ebp)
  80291d:	e8 cf 16 00 00       	call   803ff1 <free_block>
  802922:	83 c4 10             	add    $0x10,%esp
							release_uspinlock(&ulock);
  802925:	83 ec 0c             	sub    $0xc,%esp
  802928:	68 40 e1 81 00       	push   $0x81e140
  80292d:	e8 e3 1a 00 00       	call   804415 <release_uspinlock>
  802932:	83 c4 10             	add    $0x10,%esp
							return NULL;
  802935:	b8 00 00 00 00       	mov    $0x0,%eax
  80293a:	e9 1d 04 00 00       	jmp    802d5c <smalloc+0x5a5>
						}
						release_uspinlock(&ulock);
  80293f:	83 ec 0c             	sub    $0xc,%esp
  802942:	68 40 e1 81 00       	push   $0x81e140
  802947:	e8 c9 1a 00 00       	call   804415 <release_uspinlock>
  80294c:	83 c4 10             	add    $0x10,%esp
						return (void*)allocblock -> startva;
  80294f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802952:	8b 00                	mov    (%eax),%eax
  802954:	e9 03 04 00 00       	jmp    802d5c <smalloc+0x5a5>
				}else{
						release_uspinlock(&ulock);
  802959:	83 ec 0c             	sub    $0xc,%esp
  80295c:	68 40 e1 81 00       	push   $0x81e140
  802961:	e8 af 1a 00 00       	call   804415 <release_uspinlock>
  802966:	83 c4 10             	add    $0x10,%esp
						return NULL;
  802969:	b8 00 00 00 00       	mov    $0x0,%eax
  80296e:	e9 e9 03 00 00       	jmp    802d5c <smalloc+0x5a5>
					 }
		}else{
			//custom fit
			struct UserHeapStruct* currentfreeelement = LIST_FIRST(&u_freelist);
  802973:	a1 20 e1 81 00       	mov    0x81e120,%eax
  802978:	89 45 f4             	mov    %eax,-0xc(%ebp)
			//worst fit
			while(currentfreeelement != NULL){
  80297b:	e9 af 03 00 00       	jmp    802d2f <smalloc+0x578>
				if(size<currentfreeelement->size){
  802980:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802983:	8b 40 04             	mov    0x4(%eax),%eax
  802986:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802989:	0f 86 28 02 00 00    	jbe    802bb7 <smalloc+0x400>
					allocblock->startva = lastfreeelement->startva;
  80298f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802992:	8b 10                	mov    (%eax),%edx
  802994:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802997:	89 10                	mov    %edx,(%eax)
	                allocblock->size = size;
  802999:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80299c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80299f:	89 50 04             	mov    %edx,0x4(%eax)
	                LIST_INSERT_TAIL(&u_allocatedlist,allocblock);
  8029a2:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8029a6:	75 17                	jne    8029bf <smalloc+0x208>
  8029a8:	83 ec 04             	sub    $0x4,%esp
  8029ab:	68 d8 51 80 00       	push   $0x8051d8
  8029b0:	68 6f 01 00 00       	push   $0x16f
  8029b5:	68 8c 51 80 00       	push   $0x80518c
  8029ba:	e8 83 de ff ff       	call   800842 <_panic>
  8029bf:	8b 15 34 e1 81 00    	mov    0x81e134,%edx
  8029c5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029c8:	89 50 0c             	mov    %edx,0xc(%eax)
  8029cb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029ce:	8b 40 0c             	mov    0xc(%eax),%eax
  8029d1:	85 c0                	test   %eax,%eax
  8029d3:	74 0d                	je     8029e2 <smalloc+0x22b>
  8029d5:	a1 34 e1 81 00       	mov    0x81e134,%eax
  8029da:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8029dd:	89 50 08             	mov    %edx,0x8(%eax)
  8029e0:	eb 08                	jmp    8029ea <smalloc+0x233>
  8029e2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029e5:	a3 30 e1 81 00       	mov    %eax,0x81e130
  8029ea:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029ed:	a3 34 e1 81 00       	mov    %eax,0x81e134
  8029f2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029f5:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  8029fc:	a1 3c e1 81 00       	mov    0x81e13c,%eax
  802a01:	40                   	inc    %eax
  802a02:	a3 3c e1 81 00       	mov    %eax,0x81e13c
	                lastfreeelement->startva += size;
  802a07:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802a0a:	8b 10                	mov    (%eax),%edx
  802a0c:	8b 45 0c             	mov    0xc(%ebp),%eax
  802a0f:	01 c2                	add    %eax,%edx
  802a11:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802a14:	89 10                	mov    %edx,(%eax)
	                lastfreeelement->size -= size;
  802a16:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802a19:	8b 40 04             	mov    0x4(%eax),%eax
  802a1c:	2b 45 0c             	sub    0xc(%ebp),%eax
  802a1f:	89 c2                	mov    %eax,%edx
  802a21:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802a24:	89 50 04             	mov    %edx,0x4(%eax)
	                struct UserHeapStruct* currentfree2 = LIST_FIRST(&u_freelist);
  802a27:	a1 20 e1 81 00       	mov    0x81e120,%eax
  802a2c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	                //check order of last element

	                while (currentfree2 != NULL){
  802a2f:	e9 13 01 00 00       	jmp    802b47 <smalloc+0x390>
	                	if(lastfreeelement->size <currentfree2->size){
  802a34:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802a37:	8b 50 04             	mov    0x4(%eax),%edx
  802a3a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a3d:	8b 40 04             	mov    0x4(%eax),%eax
  802a40:	39 c2                	cmp    %eax,%edx
  802a42:	0f 83 f6 00 00 00    	jae    802b3e <smalloc+0x387>
	                		LIST_REMOVE(&u_freelist ,lastfreeelement);
  802a48:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802a4c:	75 17                	jne    802a65 <smalloc+0x2ae>
  802a4e:	83 ec 04             	sub    $0x4,%esp
  802a51:	68 fb 51 80 00       	push   $0x8051fb
  802a56:	68 77 01 00 00       	push   $0x177
  802a5b:	68 8c 51 80 00       	push   $0x80518c
  802a60:	e8 dd dd ff ff       	call   800842 <_panic>
  802a65:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802a68:	8b 40 08             	mov    0x8(%eax),%eax
  802a6b:	85 c0                	test   %eax,%eax
  802a6d:	74 11                	je     802a80 <smalloc+0x2c9>
  802a6f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802a72:	8b 40 08             	mov    0x8(%eax),%eax
  802a75:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802a78:	8b 52 0c             	mov    0xc(%edx),%edx
  802a7b:	89 50 0c             	mov    %edx,0xc(%eax)
  802a7e:	eb 0b                	jmp    802a8b <smalloc+0x2d4>
  802a80:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802a83:	8b 40 0c             	mov    0xc(%eax),%eax
  802a86:	a3 24 e1 81 00       	mov    %eax,0x81e124
  802a8b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802a8e:	8b 40 0c             	mov    0xc(%eax),%eax
  802a91:	85 c0                	test   %eax,%eax
  802a93:	74 11                	je     802aa6 <smalloc+0x2ef>
  802a95:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802a98:	8b 40 0c             	mov    0xc(%eax),%eax
  802a9b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802a9e:	8b 52 08             	mov    0x8(%edx),%edx
  802aa1:	89 50 08             	mov    %edx,0x8(%eax)
  802aa4:	eb 0b                	jmp    802ab1 <smalloc+0x2fa>
  802aa6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802aa9:	8b 40 08             	mov    0x8(%eax),%eax
  802aac:	a3 20 e1 81 00       	mov    %eax,0x81e120
  802ab1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802ab4:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802abb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802abe:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  802ac5:	a1 2c e1 81 00       	mov    0x81e12c,%eax
  802aca:	48                   	dec    %eax
  802acb:	a3 2c e1 81 00       	mov    %eax,0x81e12c
	                		LIST_INSERT_BEFORE(&u_freelist ,currentfree2 ,lastfreeelement);
  802ad0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802ad4:	74 06                	je     802adc <smalloc+0x325>
  802ad6:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802ada:	75 17                	jne    802af3 <smalloc+0x33c>
  802adc:	83 ec 04             	sub    $0x4,%esp
  802adf:	68 1c 52 80 00       	push   $0x80521c
  802ae4:	68 78 01 00 00       	push   $0x178
  802ae9:	68 8c 51 80 00       	push   $0x80518c
  802aee:	e8 4f dd ff ff       	call   800842 <_panic>
  802af3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802af6:	8b 50 0c             	mov    0xc(%eax),%edx
  802af9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802afc:	89 50 0c             	mov    %edx,0xc(%eax)
  802aff:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802b02:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802b05:	89 50 08             	mov    %edx,0x8(%eax)
  802b08:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b0b:	8b 40 0c             	mov    0xc(%eax),%eax
  802b0e:	85 c0                	test   %eax,%eax
  802b10:	74 0e                	je     802b20 <smalloc+0x369>
  802b12:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b15:	8b 40 0c             	mov    0xc(%eax),%eax
  802b18:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802b1b:	89 50 08             	mov    %edx,0x8(%eax)
  802b1e:	eb 08                	jmp    802b28 <smalloc+0x371>
  802b20:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802b23:	a3 20 e1 81 00       	mov    %eax,0x81e120
  802b28:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b2b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802b2e:	89 50 0c             	mov    %edx,0xc(%eax)
  802b31:	a1 2c e1 81 00       	mov    0x81e12c,%eax
  802b36:	40                   	inc    %eax
  802b37:	a3 2c e1 81 00       	mov    %eax,0x81e12c
	                		break;
  802b3c:	eb 13                	jmp    802b51 <smalloc+0x39a>
	                	}
	                	currentfree2 = currentfree2->prev_next_info.le_next;
  802b3e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b41:	8b 40 08             	mov    0x8(%eax),%eax
  802b44:	89 45 f0             	mov    %eax,-0x10(%ebp)
	                lastfreeelement->startva += size;
	                lastfreeelement->size -= size;
	                struct UserHeapStruct* currentfree2 = LIST_FIRST(&u_freelist);
	                //check order of last element

	                while (currentfree2 != NULL){
  802b47:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802b4b:	0f 85 e3 fe ff ff    	jne    802a34 <smalloc+0x27d>
	                	}
	                	currentfree2 = currentfree2->prev_next_info.le_next;
	                }


	                int result = sys_create_shared_object(sharedVarName ,size ,isWritable ,(void*)allocblock->startva);
  802b51:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b54:	8b 00                	mov    (%eax),%eax
  802b56:	89 c2                	mov    %eax,%edx
  802b58:	0f b6 45 c4          	movzbl -0x3c(%ebp),%eax
  802b5c:	52                   	push   %edx
  802b5d:	50                   	push   %eax
  802b5e:	ff 75 0c             	pushl  0xc(%ebp)
  802b61:	ff 75 08             	pushl  0x8(%ebp)
  802b64:	e8 ea 09 00 00       	call   803553 <sys_create_shared_object>
  802b69:	83 c4 10             	add    $0x10,%esp
  802b6c:	89 45 d8             	mov    %eax,-0x28(%ebp)

	                if(result <0){
  802b6f:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  802b73:	79 28                	jns    802b9d <smalloc+0x3e6>
	                	free_block(allocblock);
  802b75:	83 ec 0c             	sub    $0xc,%esp
  802b78:	ff 75 ec             	pushl  -0x14(%ebp)
  802b7b:	e8 71 14 00 00       	call   803ff1 <free_block>
  802b80:	83 c4 10             	add    $0x10,%esp
	                	release_uspinlock(&ulock);
  802b83:	83 ec 0c             	sub    $0xc,%esp
  802b86:	68 40 e1 81 00       	push   $0x81e140
  802b8b:	e8 85 18 00 00       	call   804415 <release_uspinlock>
  802b90:	83 c4 10             	add    $0x10,%esp
	                	return NULL;
  802b93:	b8 00 00 00 00       	mov    $0x0,%eax
  802b98:	e9 bf 01 00 00       	jmp    802d5c <smalloc+0x5a5>
	                }
	                release_uspinlock(&ulock);
  802b9d:	83 ec 0c             	sub    $0xc,%esp
  802ba0:	68 40 e1 81 00       	push   $0x81e140
  802ba5:	e8 6b 18 00 00       	call   804415 <release_uspinlock>
  802baa:	83 c4 10             	add    $0x10,%esp
	                return (void*)allocblock->startva;
  802bad:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bb0:	8b 00                	mov    (%eax),%eax
  802bb2:	e9 a5 01 00 00       	jmp    802d5c <smalloc+0x5a5>
	                //exact fit
				}else if(size == currentfreeelement->size){
  802bb7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bba:	8b 40 04             	mov    0x4(%eax),%eax
  802bbd:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802bc0:	0f 85 60 01 00 00    	jne    802d26 <smalloc+0x56f>
					allocblock->startva = currentfreeelement->startva;
  802bc6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bc9:	8b 10                	mov    (%eax),%edx
  802bcb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bce:	89 10                	mov    %edx,(%eax)
					allocblock->size = size;
  802bd0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bd3:	8b 55 0c             	mov    0xc(%ebp),%edx
  802bd6:	89 50 04             	mov    %edx,0x4(%eax)
					LIST_INSERT_TAIL(&u_allocatedlist ,allocblock);
  802bd9:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802bdd:	75 17                	jne    802bf6 <smalloc+0x43f>
  802bdf:	83 ec 04             	sub    $0x4,%esp
  802be2:	68 d8 51 80 00       	push   $0x8051d8
  802be7:	68 8c 01 00 00       	push   $0x18c
  802bec:	68 8c 51 80 00       	push   $0x80518c
  802bf1:	e8 4c dc ff ff       	call   800842 <_panic>
  802bf6:	8b 15 34 e1 81 00    	mov    0x81e134,%edx
  802bfc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bff:	89 50 0c             	mov    %edx,0xc(%eax)
  802c02:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c05:	8b 40 0c             	mov    0xc(%eax),%eax
  802c08:	85 c0                	test   %eax,%eax
  802c0a:	74 0d                	je     802c19 <smalloc+0x462>
  802c0c:	a1 34 e1 81 00       	mov    0x81e134,%eax
  802c11:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802c14:	89 50 08             	mov    %edx,0x8(%eax)
  802c17:	eb 08                	jmp    802c21 <smalloc+0x46a>
  802c19:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c1c:	a3 30 e1 81 00       	mov    %eax,0x81e130
  802c21:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c24:	a3 34 e1 81 00       	mov    %eax,0x81e134
  802c29:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c2c:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802c33:	a1 3c e1 81 00       	mov    0x81e13c,%eax
  802c38:	40                   	inc    %eax
  802c39:	a3 3c e1 81 00       	mov    %eax,0x81e13c
					LIST_REMOVE(&u_freelist ,currentfreeelement);
  802c3e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c42:	75 17                	jne    802c5b <smalloc+0x4a4>
  802c44:	83 ec 04             	sub    $0x4,%esp
  802c47:	68 fb 51 80 00       	push   $0x8051fb
  802c4c:	68 8d 01 00 00       	push   $0x18d
  802c51:	68 8c 51 80 00       	push   $0x80518c
  802c56:	e8 e7 db ff ff       	call   800842 <_panic>
  802c5b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c5e:	8b 40 08             	mov    0x8(%eax),%eax
  802c61:	85 c0                	test   %eax,%eax
  802c63:	74 11                	je     802c76 <smalloc+0x4bf>
  802c65:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c68:	8b 40 08             	mov    0x8(%eax),%eax
  802c6b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c6e:	8b 52 0c             	mov    0xc(%edx),%edx
  802c71:	89 50 0c             	mov    %edx,0xc(%eax)
  802c74:	eb 0b                	jmp    802c81 <smalloc+0x4ca>
  802c76:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c79:	8b 40 0c             	mov    0xc(%eax),%eax
  802c7c:	a3 24 e1 81 00       	mov    %eax,0x81e124
  802c81:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c84:	8b 40 0c             	mov    0xc(%eax),%eax
  802c87:	85 c0                	test   %eax,%eax
  802c89:	74 11                	je     802c9c <smalloc+0x4e5>
  802c8b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c8e:	8b 40 0c             	mov    0xc(%eax),%eax
  802c91:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c94:	8b 52 08             	mov    0x8(%edx),%edx
  802c97:	89 50 08             	mov    %edx,0x8(%eax)
  802c9a:	eb 0b                	jmp    802ca7 <smalloc+0x4f0>
  802c9c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c9f:	8b 40 08             	mov    0x8(%eax),%eax
  802ca2:	a3 20 e1 81 00       	mov    %eax,0x81e120
  802ca7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802caa:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802cb1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cb4:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  802cbb:	a1 2c e1 81 00       	mov    0x81e12c,%eax
  802cc0:	48                   	dec    %eax
  802cc1:	a3 2c e1 81 00       	mov    %eax,0x81e12c
					int result = sys_create_shared_object(sharedVarName ,size ,isWritable ,(void*)allocblock->startva);
  802cc6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cc9:	8b 00                	mov    (%eax),%eax
  802ccb:	89 c2                	mov    %eax,%edx
  802ccd:	0f b6 45 c4          	movzbl -0x3c(%ebp),%eax
  802cd1:	52                   	push   %edx
  802cd2:	50                   	push   %eax
  802cd3:	ff 75 0c             	pushl  0xc(%ebp)
  802cd6:	ff 75 08             	pushl  0x8(%ebp)
  802cd9:	e8 75 08 00 00       	call   803553 <sys_create_shared_object>
  802cde:	83 c4 10             	add    $0x10,%esp
  802ce1:	89 45 dc             	mov    %eax,-0x24(%ebp)

					if(result <0){
  802ce4:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802ce8:	79 25                	jns    802d0f <smalloc+0x558>
						free_block(allocblock);
  802cea:	83 ec 0c             	sub    $0xc,%esp
  802ced:	ff 75 ec             	pushl  -0x14(%ebp)
  802cf0:	e8 fc 12 00 00       	call   803ff1 <free_block>
  802cf5:	83 c4 10             	add    $0x10,%esp
						release_uspinlock(&ulock);
  802cf8:	83 ec 0c             	sub    $0xc,%esp
  802cfb:	68 40 e1 81 00       	push   $0x81e140
  802d00:	e8 10 17 00 00       	call   804415 <release_uspinlock>
  802d05:	83 c4 10             	add    $0x10,%esp
						return NULL;
  802d08:	b8 00 00 00 00       	mov    $0x0,%eax
  802d0d:	eb 4d                	jmp    802d5c <smalloc+0x5a5>
					}
					release_uspinlock(&ulock);
  802d0f:	83 ec 0c             	sub    $0xc,%esp
  802d12:	68 40 e1 81 00       	push   $0x81e140
  802d17:	e8 f9 16 00 00       	call   804415 <release_uspinlock>
  802d1c:	83 c4 10             	add    $0x10,%esp
					return (void*)allocblock->startva;
  802d1f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d22:	8b 00                	mov    (%eax),%eax
  802d24:	eb 36                	jmp    802d5c <smalloc+0x5a5>
				}
				currentfreeelement = currentfreeelement->prev_next_info.le_next;
  802d26:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d29:	8b 40 08             	mov    0x8(%eax),%eax
  802d2c:	89 45 f4             	mov    %eax,-0xc(%ebp)
					 }
		}else{
			//custom fit
			struct UserHeapStruct* currentfreeelement = LIST_FIRST(&u_freelist);
			//worst fit
			while(currentfreeelement != NULL){
  802d2f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d33:	0f 85 47 fc ff ff    	jne    802980 <smalloc+0x1c9>
					return (void*)allocblock->startva;
				}
				currentfreeelement = currentfreeelement->prev_next_info.le_next;
			}
		}
		free_block(allocblock);
  802d39:	83 ec 0c             	sub    $0xc,%esp
  802d3c:	ff 75 ec             	pushl  -0x14(%ebp)
  802d3f:	e8 ad 12 00 00       	call   803ff1 <free_block>
  802d44:	83 c4 10             	add    $0x10,%esp
		release_uspinlock(&ulock);
  802d47:	83 ec 0c             	sub    $0xc,%esp
  802d4a:	68 40 e1 81 00       	push   $0x81e140
  802d4f:	e8 c1 16 00 00       	call   804415 <release_uspinlock>
  802d54:	83 c4 10             	add    $0x10,%esp
		return NULL;
  802d57:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802d5c:	c9                   	leave  
  802d5d:	c3                   	ret    

00802d5e <sget>:

//========================================
// [4] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  802d5e:	55                   	push   %ebp
  802d5f:	89 e5                	mov    %esp,%ebp
  802d61:	83 ec 38             	sub    $0x38,%esp


	 //==============================================================
	 // DON'T CHANGE THIS CODE
	    uheap_init();
  802d64:	e8 8c ec ff ff       	call   8019f5 <uheap_init>
	 //==============================================================
	 // Get size of the shared variable from kernel
	acquire_uspinlock(&ulock);
  802d69:	83 ec 0c             	sub    $0xc,%esp
  802d6c:	68 40 e1 81 00       	push   $0x81e140
  802d71:	e8 47 16 00 00       	call   8043bd <acquire_uspinlock>
  802d76:	83 c4 10             	add    $0x10,%esp


	int size = sys_size_of_shared_object(ownerEnvID ,sharedVarName);
  802d79:	83 ec 08             	sub    $0x8,%esp
  802d7c:	ff 75 0c             	pushl  0xc(%ebp)
  802d7f:	ff 75 08             	pushl  0x8(%ebp)
  802d82:	e8 f6 07 00 00       	call   80357d <sys_size_of_shared_object>
  802d87:	83 c4 10             	add    $0x10,%esp
  802d8a:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if ( size < 0 ){
  802d8d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802d91:	79 1a                	jns    802dad <sget+0x4f>
			release_uspinlock(&ulock);
  802d93:	83 ec 0c             	sub    $0xc,%esp
  802d96:	68 40 e1 81 00       	push   $0x81e140
  802d9b:	e8 75 16 00 00       	call   804415 <release_uspinlock>
  802da0:	83 c4 10             	add    $0x10,%esp
			return NULL;
  802da3:	b8 00 00 00 00       	mov    $0x0,%eax
  802da8:	e9 6e 05 00 00       	jmp    80331b <sget+0x5bd>
		}
		size = ROUNDUP(size,PAGE_SIZE);
  802dad:	c7 45 e8 00 10 00 00 	movl   $0x1000,-0x18(%ebp)
  802db4:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802db7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802dba:	01 d0                	add    %edx,%eax
  802dbc:	48                   	dec    %eax
  802dbd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  802dc0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802dc3:	ba 00 00 00 00       	mov    $0x0,%edx
  802dc8:	f7 75 e8             	divl   -0x18(%ebp)
  802dcb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802dce:	29 d0                	sub    %edx,%eax
  802dd0:	89 45 ec             	mov    %eax,-0x14(%ebp)

		struct UserHeapStruct* allocblock = (struct UserHeapStruct*) alloc_block(sizeof(struct UserHeapStruct));
  802dd3:	83 ec 0c             	sub    $0xc,%esp
  802dd6:	6a 10                	push   $0x10
  802dd8:	e8 78 0d 00 00       	call   803b55 <alloc_block>
  802ddd:	83 c4 10             	add    $0x10,%esp
  802de0:	89 45 e0             	mov    %eax,-0x20(%ebp)

		if (allocblock == NULL){
  802de3:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802de7:	75 0a                	jne    802df3 <sget+0x95>
			return NULL;
  802de9:	b8 00 00 00 00       	mov    $0x0,%eax
  802dee:	e9 28 05 00 00       	jmp    80331b <sget+0x5bd>
		}
		struct UserHeapStruct* lastfreeelement = LIST_LAST(&u_freelist);
  802df3:	a1 24 e1 81 00       	mov    0x81e124,%eax
  802df8:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if(LIST_SIZE(&u_freelist)==0 || size>lastfreeelement->size){
  802dfb:	a1 2c e1 81 00       	mov    0x81e12c,%eax
  802e00:	85 c0                	test   %eax,%eax
  802e02:	74 11                	je     802e15 <sget+0xb7>
  802e04:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802e07:	8b 50 04             	mov    0x4(%eax),%edx
  802e0a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e0d:	39 c2                	cmp    %eax,%edx
  802e0f:	0f 83 21 01 00 00    	jae    802f36 <sget+0x1d8>
				if(uheapPageAllocBreak <= USER_HEAP_MAX - size){
  802e15:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e18:	ba 00 00 00 a0       	mov    $0xa0000000,%edx
  802e1d:	29 c2                	sub    %eax,%edx
  802e1f:	a1 68 e0 81 00       	mov    0x81e068,%eax
  802e24:	39 c2                	cmp    %eax,%edx
  802e26:	0f 82 f0 00 00 00    	jb     802f1c <sget+0x1be>

						uint32 requestedblockva = uheapPageAllocBreak;
  802e2c:	a1 68 e0 81 00       	mov    0x81e068,%eax
  802e31:	89 45 d0             	mov    %eax,-0x30(%ebp)
						uheapPageAllocBreak+=size;
  802e34:	8b 15 68 e0 81 00    	mov    0x81e068,%edx
  802e3a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e3d:	01 d0                	add    %edx,%eax
  802e3f:	a3 68 e0 81 00       	mov    %eax,0x81e068
						allocblock->startva = requestedblockva;
  802e44:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802e47:	8b 55 d0             	mov    -0x30(%ebp),%edx
  802e4a:	89 10                	mov    %edx,(%eax)
						allocblock->size = size;
  802e4c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802e4f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802e52:	89 50 04             	mov    %edx,0x4(%eax)

						LIST_INSERT_TAIL(&u_allocatedlist, allocblock);
  802e55:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802e59:	75 17                	jne    802e72 <sget+0x114>
  802e5b:	83 ec 04             	sub    $0x4,%esp
  802e5e:	68 d8 51 80 00       	push   $0x8051d8
  802e63:	68 c8 01 00 00       	push   $0x1c8
  802e68:	68 8c 51 80 00       	push   $0x80518c
  802e6d:	e8 d0 d9 ff ff       	call   800842 <_panic>
  802e72:	8b 15 34 e1 81 00    	mov    0x81e134,%edx
  802e78:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802e7b:	89 50 0c             	mov    %edx,0xc(%eax)
  802e7e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802e81:	8b 40 0c             	mov    0xc(%eax),%eax
  802e84:	85 c0                	test   %eax,%eax
  802e86:	74 0d                	je     802e95 <sget+0x137>
  802e88:	a1 34 e1 81 00       	mov    0x81e134,%eax
  802e8d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802e90:	89 50 08             	mov    %edx,0x8(%eax)
  802e93:	eb 08                	jmp    802e9d <sget+0x13f>
  802e95:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802e98:	a3 30 e1 81 00       	mov    %eax,0x81e130
  802e9d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802ea0:	a3 34 e1 81 00       	mov    %eax,0x81e134
  802ea5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802ea8:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802eaf:	a1 3c e1 81 00       	mov    0x81e13c,%eax
  802eb4:	40                   	inc    %eax
  802eb5:	a3 3c e1 81 00       	mov    %eax,0x81e13c


						int result = sys_get_shared_object(ownerEnvID ,sharedVarName ,(void*)allocblock->startva);
  802eba:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802ebd:	8b 00                	mov    (%eax),%eax
  802ebf:	83 ec 04             	sub    $0x4,%esp
  802ec2:	50                   	push   %eax
  802ec3:	ff 75 0c             	pushl  0xc(%ebp)
  802ec6:	ff 75 08             	pushl  0x8(%ebp)
  802ec9:	e8 cc 06 00 00       	call   80359a <sys_get_shared_object>
  802ece:	83 c4 10             	add    $0x10,%esp
  802ed1:	89 45 cc             	mov    %eax,-0x34(%ebp)

						if(result <0){
  802ed4:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802ed8:	79 28                	jns    802f02 <sget+0x1a4>
							free_block(allocblock);
  802eda:	83 ec 0c             	sub    $0xc,%esp
  802edd:	ff 75 e0             	pushl  -0x20(%ebp)
  802ee0:	e8 0c 11 00 00       	call   803ff1 <free_block>
  802ee5:	83 c4 10             	add    $0x10,%esp
							release_uspinlock(&ulock);
  802ee8:	83 ec 0c             	sub    $0xc,%esp
  802eeb:	68 40 e1 81 00       	push   $0x81e140
  802ef0:	e8 20 15 00 00       	call   804415 <release_uspinlock>
  802ef5:	83 c4 10             	add    $0x10,%esp
							return NULL;
  802ef8:	b8 00 00 00 00       	mov    $0x0,%eax
  802efd:	e9 19 04 00 00       	jmp    80331b <sget+0x5bd>
						}
						release_uspinlock(&ulock);
  802f02:	83 ec 0c             	sub    $0xc,%esp
  802f05:	68 40 e1 81 00       	push   $0x81e140
  802f0a:	e8 06 15 00 00       	call   804415 <release_uspinlock>
  802f0f:	83 c4 10             	add    $0x10,%esp
						return (void*)allocblock -> startva;
  802f12:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802f15:	8b 00                	mov    (%eax),%eax
  802f17:	e9 ff 03 00 00       	jmp    80331b <sget+0x5bd>
				}else{
						release_uspinlock(&ulock);
  802f1c:	83 ec 0c             	sub    $0xc,%esp
  802f1f:	68 40 e1 81 00       	push   $0x81e140
  802f24:	e8 ec 14 00 00       	call   804415 <release_uspinlock>
  802f29:	83 c4 10             	add    $0x10,%esp
						return NULL;
  802f2c:	b8 00 00 00 00       	mov    $0x0,%eax
  802f31:	e9 e5 03 00 00       	jmp    80331b <sget+0x5bd>
					 }
		}else{
			//custom fit
			struct UserHeapStruct* currentfreeelement = LIST_FIRST(&u_freelist);
  802f36:	a1 20 e1 81 00       	mov    0x81e120,%eax
  802f3b:	89 45 f4             	mov    %eax,-0xc(%ebp)
			//worst fit
			while(currentfreeelement != NULL){
  802f3e:	e9 ab 03 00 00       	jmp    8032ee <sget+0x590>
				if(size<currentfreeelement->size){
  802f43:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f46:	8b 50 04             	mov    0x4(%eax),%edx
  802f49:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f4c:	39 c2                	cmp    %eax,%edx
  802f4e:	0f 86 24 02 00 00    	jbe    803178 <sget+0x41a>
					allocblock->startva = lastfreeelement->startva;
  802f54:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802f57:	8b 10                	mov    (%eax),%edx
  802f59:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802f5c:	89 10                	mov    %edx,(%eax)
					allocblock->size = size;
  802f5e:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802f61:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802f64:	89 50 04             	mov    %edx,0x4(%eax)
					LIST_INSERT_TAIL(&u_allocatedlist,allocblock);
  802f67:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802f6b:	75 17                	jne    802f84 <sget+0x226>
  802f6d:	83 ec 04             	sub    $0x4,%esp
  802f70:	68 d8 51 80 00       	push   $0x8051d8
  802f75:	68 e0 01 00 00       	push   $0x1e0
  802f7a:	68 8c 51 80 00       	push   $0x80518c
  802f7f:	e8 be d8 ff ff       	call   800842 <_panic>
  802f84:	8b 15 34 e1 81 00    	mov    0x81e134,%edx
  802f8a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802f8d:	89 50 0c             	mov    %edx,0xc(%eax)
  802f90:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802f93:	8b 40 0c             	mov    0xc(%eax),%eax
  802f96:	85 c0                	test   %eax,%eax
  802f98:	74 0d                	je     802fa7 <sget+0x249>
  802f9a:	a1 34 e1 81 00       	mov    0x81e134,%eax
  802f9f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802fa2:	89 50 08             	mov    %edx,0x8(%eax)
  802fa5:	eb 08                	jmp    802faf <sget+0x251>
  802fa7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802faa:	a3 30 e1 81 00       	mov    %eax,0x81e130
  802faf:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802fb2:	a3 34 e1 81 00       	mov    %eax,0x81e134
  802fb7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802fba:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802fc1:	a1 3c e1 81 00       	mov    0x81e13c,%eax
  802fc6:	40                   	inc    %eax
  802fc7:	a3 3c e1 81 00       	mov    %eax,0x81e13c
					lastfreeelement->startva += size;
  802fcc:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802fcf:	8b 10                	mov    (%eax),%edx
  802fd1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802fd4:	01 c2                	add    %eax,%edx
  802fd6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802fd9:	89 10                	mov    %edx,(%eax)
					lastfreeelement->size -= size;
  802fdb:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802fde:	8b 50 04             	mov    0x4(%eax),%edx
  802fe1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802fe4:	29 c2                	sub    %eax,%edx
  802fe6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802fe9:	89 50 04             	mov    %edx,0x4(%eax)
					struct UserHeapStruct* currentfree2 = LIST_FIRST(&u_freelist);
  802fec:	a1 20 e1 81 00       	mov    0x81e120,%eax
  802ff1:	89 45 f0             	mov    %eax,-0x10(%ebp)
					//check order of last element

					while (currentfree2 != NULL){
  802ff4:	e9 13 01 00 00       	jmp    80310c <sget+0x3ae>
						if(lastfreeelement->size <currentfree2->size){
  802ff9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802ffc:	8b 50 04             	mov    0x4(%eax),%edx
  802fff:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803002:	8b 40 04             	mov    0x4(%eax),%eax
  803005:	39 c2                	cmp    %eax,%edx
  803007:	0f 83 f6 00 00 00    	jae    803103 <sget+0x3a5>
							LIST_REMOVE(&u_freelist ,lastfreeelement);
  80300d:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803011:	75 17                	jne    80302a <sget+0x2cc>
  803013:	83 ec 04             	sub    $0x4,%esp
  803016:	68 fb 51 80 00       	push   $0x8051fb
  80301b:	68 e8 01 00 00       	push   $0x1e8
  803020:	68 8c 51 80 00       	push   $0x80518c
  803025:	e8 18 d8 ff ff       	call   800842 <_panic>
  80302a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80302d:	8b 40 08             	mov    0x8(%eax),%eax
  803030:	85 c0                	test   %eax,%eax
  803032:	74 11                	je     803045 <sget+0x2e7>
  803034:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803037:	8b 40 08             	mov    0x8(%eax),%eax
  80303a:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80303d:	8b 52 0c             	mov    0xc(%edx),%edx
  803040:	89 50 0c             	mov    %edx,0xc(%eax)
  803043:	eb 0b                	jmp    803050 <sget+0x2f2>
  803045:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803048:	8b 40 0c             	mov    0xc(%eax),%eax
  80304b:	a3 24 e1 81 00       	mov    %eax,0x81e124
  803050:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803053:	8b 40 0c             	mov    0xc(%eax),%eax
  803056:	85 c0                	test   %eax,%eax
  803058:	74 11                	je     80306b <sget+0x30d>
  80305a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80305d:	8b 40 0c             	mov    0xc(%eax),%eax
  803060:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803063:	8b 52 08             	mov    0x8(%edx),%edx
  803066:	89 50 08             	mov    %edx,0x8(%eax)
  803069:	eb 0b                	jmp    803076 <sget+0x318>
  80306b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80306e:	8b 40 08             	mov    0x8(%eax),%eax
  803071:	a3 20 e1 81 00       	mov    %eax,0x81e120
  803076:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803079:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  803080:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803083:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  80308a:	a1 2c e1 81 00       	mov    0x81e12c,%eax
  80308f:	48                   	dec    %eax
  803090:	a3 2c e1 81 00       	mov    %eax,0x81e12c
							LIST_INSERT_BEFORE(&u_freelist ,currentfree2 ,lastfreeelement);
  803095:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803099:	74 06                	je     8030a1 <sget+0x343>
  80309b:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80309f:	75 17                	jne    8030b8 <sget+0x35a>
  8030a1:	83 ec 04             	sub    $0x4,%esp
  8030a4:	68 1c 52 80 00       	push   $0x80521c
  8030a9:	68 e9 01 00 00       	push   $0x1e9
  8030ae:	68 8c 51 80 00       	push   $0x80518c
  8030b3:	e8 8a d7 ff ff       	call   800842 <_panic>
  8030b8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030bb:	8b 50 0c             	mov    0xc(%eax),%edx
  8030be:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8030c1:	89 50 0c             	mov    %edx,0xc(%eax)
  8030c4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8030c7:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8030ca:	89 50 08             	mov    %edx,0x8(%eax)
  8030cd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030d0:	8b 40 0c             	mov    0xc(%eax),%eax
  8030d3:	85 c0                	test   %eax,%eax
  8030d5:	74 0e                	je     8030e5 <sget+0x387>
  8030d7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030da:	8b 40 0c             	mov    0xc(%eax),%eax
  8030dd:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8030e0:	89 50 08             	mov    %edx,0x8(%eax)
  8030e3:	eb 08                	jmp    8030ed <sget+0x38f>
  8030e5:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8030e8:	a3 20 e1 81 00       	mov    %eax,0x81e120
  8030ed:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030f0:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8030f3:	89 50 0c             	mov    %edx,0xc(%eax)
  8030f6:	a1 2c e1 81 00       	mov    0x81e12c,%eax
  8030fb:	40                   	inc    %eax
  8030fc:	a3 2c e1 81 00       	mov    %eax,0x81e12c
							break;
  803101:	eb 13                	jmp    803116 <sget+0x3b8>
						}
						currentfree2 = currentfree2->prev_next_info.le_next;
  803103:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803106:	8b 40 08             	mov    0x8(%eax),%eax
  803109:	89 45 f0             	mov    %eax,-0x10(%ebp)
					lastfreeelement->startva += size;
					lastfreeelement->size -= size;
					struct UserHeapStruct* currentfree2 = LIST_FIRST(&u_freelist);
					//check order of last element

					while (currentfree2 != NULL){
  80310c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803110:	0f 85 e3 fe ff ff    	jne    802ff9 <sget+0x29b>
						}
						currentfree2 = currentfree2->prev_next_info.le_next;
					}


					int result = sys_get_shared_object(ownerEnvID ,sharedVarName ,(void*)allocblock->startva);
  803116:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803119:	8b 00                	mov    (%eax),%eax
  80311b:	83 ec 04             	sub    $0x4,%esp
  80311e:	50                   	push   %eax
  80311f:	ff 75 0c             	pushl  0xc(%ebp)
  803122:	ff 75 08             	pushl  0x8(%ebp)
  803125:	e8 70 04 00 00       	call   80359a <sys_get_shared_object>
  80312a:	83 c4 10             	add    $0x10,%esp
  80312d:	89 45 d4             	mov    %eax,-0x2c(%ebp)

					if(result <0){
  803130:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803134:	79 28                	jns    80315e <sget+0x400>
						free_block(allocblock);
  803136:	83 ec 0c             	sub    $0xc,%esp
  803139:	ff 75 e0             	pushl  -0x20(%ebp)
  80313c:	e8 b0 0e 00 00       	call   803ff1 <free_block>
  803141:	83 c4 10             	add    $0x10,%esp
						release_uspinlock(&ulock);
  803144:	83 ec 0c             	sub    $0xc,%esp
  803147:	68 40 e1 81 00       	push   $0x81e140
  80314c:	e8 c4 12 00 00       	call   804415 <release_uspinlock>
  803151:	83 c4 10             	add    $0x10,%esp
						return NULL;
  803154:	b8 00 00 00 00       	mov    $0x0,%eax
  803159:	e9 bd 01 00 00       	jmp    80331b <sget+0x5bd>
					}
					release_uspinlock(&ulock);
  80315e:	83 ec 0c             	sub    $0xc,%esp
  803161:	68 40 e1 81 00       	push   $0x81e140
  803166:	e8 aa 12 00 00       	call   804415 <release_uspinlock>
  80316b:	83 c4 10             	add    $0x10,%esp
					return (void*)allocblock->startva;
  80316e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803171:	8b 00                	mov    (%eax),%eax
  803173:	e9 a3 01 00 00       	jmp    80331b <sget+0x5bd>
					//exact fit
				}else if(size == currentfreeelement->size){
  803178:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80317b:	8b 50 04             	mov    0x4(%eax),%edx
  80317e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803181:	39 c2                	cmp    %eax,%edx
  803183:	0f 85 5c 01 00 00    	jne    8032e5 <sget+0x587>

					allocblock->startva = currentfreeelement->startva;
  803189:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80318c:	8b 10                	mov    (%eax),%edx
  80318e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803191:	89 10                	mov    %edx,(%eax)
					allocblock->size = size;
  803193:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803196:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803199:	89 50 04             	mov    %edx,0x4(%eax)
					LIST_INSERT_TAIL(&u_allocatedlist ,allocblock);
  80319c:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8031a0:	75 17                	jne    8031b9 <sget+0x45b>
  8031a2:	83 ec 04             	sub    $0x4,%esp
  8031a5:	68 d8 51 80 00       	push   $0x8051d8
  8031aa:	68 fe 01 00 00       	push   $0x1fe
  8031af:	68 8c 51 80 00       	push   $0x80518c
  8031b4:	e8 89 d6 ff ff       	call   800842 <_panic>
  8031b9:	8b 15 34 e1 81 00    	mov    0x81e134,%edx
  8031bf:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8031c2:	89 50 0c             	mov    %edx,0xc(%eax)
  8031c5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8031c8:	8b 40 0c             	mov    0xc(%eax),%eax
  8031cb:	85 c0                	test   %eax,%eax
  8031cd:	74 0d                	je     8031dc <sget+0x47e>
  8031cf:	a1 34 e1 81 00       	mov    0x81e134,%eax
  8031d4:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8031d7:	89 50 08             	mov    %edx,0x8(%eax)
  8031da:	eb 08                	jmp    8031e4 <sget+0x486>
  8031dc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8031df:	a3 30 e1 81 00       	mov    %eax,0x81e130
  8031e4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8031e7:	a3 34 e1 81 00       	mov    %eax,0x81e134
  8031ec:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8031ef:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  8031f6:	a1 3c e1 81 00       	mov    0x81e13c,%eax
  8031fb:	40                   	inc    %eax
  8031fc:	a3 3c e1 81 00       	mov    %eax,0x81e13c
					LIST_REMOVE(&u_freelist ,currentfreeelement);
  803201:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803205:	75 17                	jne    80321e <sget+0x4c0>
  803207:	83 ec 04             	sub    $0x4,%esp
  80320a:	68 fb 51 80 00       	push   $0x8051fb
  80320f:	68 ff 01 00 00       	push   $0x1ff
  803214:	68 8c 51 80 00       	push   $0x80518c
  803219:	e8 24 d6 ff ff       	call   800842 <_panic>
  80321e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803221:	8b 40 08             	mov    0x8(%eax),%eax
  803224:	85 c0                	test   %eax,%eax
  803226:	74 11                	je     803239 <sget+0x4db>
  803228:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80322b:	8b 40 08             	mov    0x8(%eax),%eax
  80322e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803231:	8b 52 0c             	mov    0xc(%edx),%edx
  803234:	89 50 0c             	mov    %edx,0xc(%eax)
  803237:	eb 0b                	jmp    803244 <sget+0x4e6>
  803239:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80323c:	8b 40 0c             	mov    0xc(%eax),%eax
  80323f:	a3 24 e1 81 00       	mov    %eax,0x81e124
  803244:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803247:	8b 40 0c             	mov    0xc(%eax),%eax
  80324a:	85 c0                	test   %eax,%eax
  80324c:	74 11                	je     80325f <sget+0x501>
  80324e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803251:	8b 40 0c             	mov    0xc(%eax),%eax
  803254:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803257:	8b 52 08             	mov    0x8(%edx),%edx
  80325a:	89 50 08             	mov    %edx,0x8(%eax)
  80325d:	eb 0b                	jmp    80326a <sget+0x50c>
  80325f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803262:	8b 40 08             	mov    0x8(%eax),%eax
  803265:	a3 20 e1 81 00       	mov    %eax,0x81e120
  80326a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80326d:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  803274:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803277:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  80327e:	a1 2c e1 81 00       	mov    0x81e12c,%eax
  803283:	48                   	dec    %eax
  803284:	a3 2c e1 81 00       	mov    %eax,0x81e12c

					int result = sys_get_shared_object(ownerEnvID ,sharedVarName ,(void*)allocblock->startva);
  803289:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80328c:	8b 00                	mov    (%eax),%eax
  80328e:	83 ec 04             	sub    $0x4,%esp
  803291:	50                   	push   %eax
  803292:	ff 75 0c             	pushl  0xc(%ebp)
  803295:	ff 75 08             	pushl  0x8(%ebp)
  803298:	e8 fd 02 00 00       	call   80359a <sys_get_shared_object>
  80329d:	83 c4 10             	add    $0x10,%esp
  8032a0:	89 45 d8             	mov    %eax,-0x28(%ebp)
					if(result <0){
  8032a3:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8032a7:	79 25                	jns    8032ce <sget+0x570>
						free_block(allocblock);
  8032a9:	83 ec 0c             	sub    $0xc,%esp
  8032ac:	ff 75 e0             	pushl  -0x20(%ebp)
  8032af:	e8 3d 0d 00 00       	call   803ff1 <free_block>
  8032b4:	83 c4 10             	add    $0x10,%esp
						release_uspinlock(&ulock);
  8032b7:	83 ec 0c             	sub    $0xc,%esp
  8032ba:	68 40 e1 81 00       	push   $0x81e140
  8032bf:	e8 51 11 00 00       	call   804415 <release_uspinlock>
  8032c4:	83 c4 10             	add    $0x10,%esp
						return NULL;
  8032c7:	b8 00 00 00 00       	mov    $0x0,%eax
  8032cc:	eb 4d                	jmp    80331b <sget+0x5bd>
					}

					release_uspinlock(&ulock);
  8032ce:	83 ec 0c             	sub    $0xc,%esp
  8032d1:	68 40 e1 81 00       	push   $0x81e140
  8032d6:	e8 3a 11 00 00       	call   804415 <release_uspinlock>
  8032db:	83 c4 10             	add    $0x10,%esp
					return (void*)allocblock->startva;
  8032de:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8032e1:	8b 00                	mov    (%eax),%eax
  8032e3:	eb 36                	jmp    80331b <sget+0x5bd>
				}
				currentfreeelement = currentfreeelement->prev_next_info.le_next;
  8032e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032e8:	8b 40 08             	mov    0x8(%eax),%eax
  8032eb:	89 45 f4             	mov    %eax,-0xc(%ebp)
					 }
		}else{
			//custom fit
			struct UserHeapStruct* currentfreeelement = LIST_FIRST(&u_freelist);
			//worst fit
			while(currentfreeelement != NULL){
  8032ee:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8032f2:	0f 85 4b fc ff ff    	jne    802f43 <sget+0x1e5>
					return (void*)allocblock->startva;
				}
				currentfreeelement = currentfreeelement->prev_next_info.le_next;
			}
		}
		free_block(allocblock);
  8032f8:	83 ec 0c             	sub    $0xc,%esp
  8032fb:	ff 75 e0             	pushl  -0x20(%ebp)
  8032fe:	e8 ee 0c 00 00       	call   803ff1 <free_block>
  803303:	83 c4 10             	add    $0x10,%esp
		release_uspinlock(&ulock);
  803306:	83 ec 0c             	sub    $0xc,%esp
  803309:	68 40 e1 81 00       	push   $0x81e140
  80330e:	e8 02 11 00 00       	call   804415 <release_uspinlock>
  803313:	83 c4 10             	add    $0x10,%esp
		return NULL;
  803316:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80331b:	c9                   	leave  
  80331c:	c3                   	ret    

0080331d <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  80331d:	55                   	push   %ebp
  80331e:	89 e5                	mov    %esp,%ebp
  803320:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  803323:	e8 cd e6 ff ff       	call   8019f5 <uheap_init>
	//==============================================================
	panic("realloc() is not implemented yet...!!");
  803328:	83 ec 04             	sub    $0x4,%esp
  80332b:	68 ac 52 80 00       	push   $0x8052ac
  803330:	68 2d 02 00 00       	push   $0x22d
  803335:	68 8c 51 80 00       	push   $0x80518c
  80333a:	e8 03 d5 ff ff       	call   800842 <_panic>

0080333f <sfree>:
//
//	use sys_delete_shared_object(...); which switches to the kernel mode,
//	calls delete_shared_object(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the delete_shared_object() function is empty, make sure to implement it.
void sfree(void* virtual_address)
{
  80333f:	55                   	push   %ebp
  803340:	89 e5                	mov    %esp,%ebp
  803342:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.BONUS#5] EXIT #2 - sfree
	//Your code is here
	//Comment the following line
	panic("sfree() is not implemented yet...!!");
  803345:	83 ec 04             	sub    $0x4,%esp
  803348:	68 d4 52 80 00       	push   $0x8052d4
  80334d:	68 40 02 00 00       	push   $0x240
  803352:	68 8c 51 80 00       	push   $0x80518c
  803357:	e8 e6 d4 ff ff       	call   800842 <_panic>

0080335c <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  80335c:	55                   	push   %ebp
  80335d:	89 e5                	mov    %esp,%ebp
  80335f:	57                   	push   %edi
  803360:	56                   	push   %esi
  803361:	53                   	push   %ebx
  803362:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  803365:	8b 45 08             	mov    0x8(%ebp),%eax
  803368:	8b 55 0c             	mov    0xc(%ebp),%edx
  80336b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80336e:	8b 5d 14             	mov    0x14(%ebp),%ebx
  803371:	8b 7d 18             	mov    0x18(%ebp),%edi
  803374:	8b 75 1c             	mov    0x1c(%ebp),%esi
  803377:	cd 30                	int    $0x30
  803379:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  80337c:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80337f:	83 c4 10             	add    $0x10,%esp
  803382:	5b                   	pop    %ebx
  803383:	5e                   	pop    %esi
  803384:	5f                   	pop    %edi
  803385:	5d                   	pop    %ebp
  803386:	c3                   	ret    

00803387 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  803387:	55                   	push   %ebp
  803388:	89 e5                	mov    %esp,%ebp
  80338a:	83 ec 04             	sub    $0x4,%esp
  80338d:	8b 45 10             	mov    0x10(%ebp),%eax
  803390:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  803393:	8b 4d 14             	mov    0x14(%ebp),%ecx
  803396:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80339a:	8b 45 08             	mov    0x8(%ebp),%eax
  80339d:	6a 00                	push   $0x0
  80339f:	51                   	push   %ecx
  8033a0:	52                   	push   %edx
  8033a1:	ff 75 0c             	pushl  0xc(%ebp)
  8033a4:	50                   	push   %eax
  8033a5:	6a 00                	push   $0x0
  8033a7:	e8 b0 ff ff ff       	call   80335c <syscall>
  8033ac:	83 c4 18             	add    $0x18,%esp
}
  8033af:	90                   	nop
  8033b0:	c9                   	leave  
  8033b1:	c3                   	ret    

008033b2 <sys_cgetc>:

int
sys_cgetc(void)
{
  8033b2:	55                   	push   %ebp
  8033b3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8033b5:	6a 00                	push   $0x0
  8033b7:	6a 00                	push   $0x0
  8033b9:	6a 00                	push   $0x0
  8033bb:	6a 00                	push   $0x0
  8033bd:	6a 00                	push   $0x0
  8033bf:	6a 02                	push   $0x2
  8033c1:	e8 96 ff ff ff       	call   80335c <syscall>
  8033c6:	83 c4 18             	add    $0x18,%esp
}
  8033c9:	c9                   	leave  
  8033ca:	c3                   	ret    

008033cb <sys_lock_cons>:

void sys_lock_cons(void)
{
  8033cb:	55                   	push   %ebp
  8033cc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  8033ce:	6a 00                	push   $0x0
  8033d0:	6a 00                	push   $0x0
  8033d2:	6a 00                	push   $0x0
  8033d4:	6a 00                	push   $0x0
  8033d6:	6a 00                	push   $0x0
  8033d8:	6a 03                	push   $0x3
  8033da:	e8 7d ff ff ff       	call   80335c <syscall>
  8033df:	83 c4 18             	add    $0x18,%esp
}
  8033e2:	90                   	nop
  8033e3:	c9                   	leave  
  8033e4:	c3                   	ret    

008033e5 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  8033e5:	55                   	push   %ebp
  8033e6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  8033e8:	6a 00                	push   $0x0
  8033ea:	6a 00                	push   $0x0
  8033ec:	6a 00                	push   $0x0
  8033ee:	6a 00                	push   $0x0
  8033f0:	6a 00                	push   $0x0
  8033f2:	6a 04                	push   $0x4
  8033f4:	e8 63 ff ff ff       	call   80335c <syscall>
  8033f9:	83 c4 18             	add    $0x18,%esp
}
  8033fc:	90                   	nop
  8033fd:	c9                   	leave  
  8033fe:	c3                   	ret    

008033ff <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8033ff:	55                   	push   %ebp
  803400:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  803402:	8b 55 0c             	mov    0xc(%ebp),%edx
  803405:	8b 45 08             	mov    0x8(%ebp),%eax
  803408:	6a 00                	push   $0x0
  80340a:	6a 00                	push   $0x0
  80340c:	6a 00                	push   $0x0
  80340e:	52                   	push   %edx
  80340f:	50                   	push   %eax
  803410:	6a 08                	push   $0x8
  803412:	e8 45 ff ff ff       	call   80335c <syscall>
  803417:	83 c4 18             	add    $0x18,%esp
}
  80341a:	c9                   	leave  
  80341b:	c3                   	ret    

0080341c <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  80341c:	55                   	push   %ebp
  80341d:	89 e5                	mov    %esp,%ebp
  80341f:	56                   	push   %esi
  803420:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  803421:	8b 75 18             	mov    0x18(%ebp),%esi
  803424:	8b 5d 14             	mov    0x14(%ebp),%ebx
  803427:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80342a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80342d:	8b 45 08             	mov    0x8(%ebp),%eax
  803430:	56                   	push   %esi
  803431:	53                   	push   %ebx
  803432:	51                   	push   %ecx
  803433:	52                   	push   %edx
  803434:	50                   	push   %eax
  803435:	6a 09                	push   $0x9
  803437:	e8 20 ff ff ff       	call   80335c <syscall>
  80343c:	83 c4 18             	add    $0x18,%esp
}
  80343f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  803442:	5b                   	pop    %ebx
  803443:	5e                   	pop    %esi
  803444:	5d                   	pop    %ebp
  803445:	c3                   	ret    

00803446 <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  803446:	55                   	push   %ebp
  803447:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  803449:	6a 00                	push   $0x0
  80344b:	6a 00                	push   $0x0
  80344d:	6a 00                	push   $0x0
  80344f:	6a 00                	push   $0x0
  803451:	ff 75 08             	pushl  0x8(%ebp)
  803454:	6a 0a                	push   $0xa
  803456:	e8 01 ff ff ff       	call   80335c <syscall>
  80345b:	83 c4 18             	add    $0x18,%esp
}
  80345e:	c9                   	leave  
  80345f:	c3                   	ret    

00803460 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  803460:	55                   	push   %ebp
  803461:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  803463:	6a 00                	push   $0x0
  803465:	6a 00                	push   $0x0
  803467:	6a 00                	push   $0x0
  803469:	ff 75 0c             	pushl  0xc(%ebp)
  80346c:	ff 75 08             	pushl  0x8(%ebp)
  80346f:	6a 0b                	push   $0xb
  803471:	e8 e6 fe ff ff       	call   80335c <syscall>
  803476:	83 c4 18             	add    $0x18,%esp
}
  803479:	c9                   	leave  
  80347a:	c3                   	ret    

0080347b <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  80347b:	55                   	push   %ebp
  80347c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  80347e:	6a 00                	push   $0x0
  803480:	6a 00                	push   $0x0
  803482:	6a 00                	push   $0x0
  803484:	6a 00                	push   $0x0
  803486:	6a 00                	push   $0x0
  803488:	6a 0c                	push   $0xc
  80348a:	e8 cd fe ff ff       	call   80335c <syscall>
  80348f:	83 c4 18             	add    $0x18,%esp
}
  803492:	c9                   	leave  
  803493:	c3                   	ret    

00803494 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  803494:	55                   	push   %ebp
  803495:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  803497:	6a 00                	push   $0x0
  803499:	6a 00                	push   $0x0
  80349b:	6a 00                	push   $0x0
  80349d:	6a 00                	push   $0x0
  80349f:	6a 00                	push   $0x0
  8034a1:	6a 0d                	push   $0xd
  8034a3:	e8 b4 fe ff ff       	call   80335c <syscall>
  8034a8:	83 c4 18             	add    $0x18,%esp
}
  8034ab:	c9                   	leave  
  8034ac:	c3                   	ret    

008034ad <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8034ad:	55                   	push   %ebp
  8034ae:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8034b0:	6a 00                	push   $0x0
  8034b2:	6a 00                	push   $0x0
  8034b4:	6a 00                	push   $0x0
  8034b6:	6a 00                	push   $0x0
  8034b8:	6a 00                	push   $0x0
  8034ba:	6a 0e                	push   $0xe
  8034bc:	e8 9b fe ff ff       	call   80335c <syscall>
  8034c1:	83 c4 18             	add    $0x18,%esp
}
  8034c4:	c9                   	leave  
  8034c5:	c3                   	ret    

008034c6 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8034c6:	55                   	push   %ebp
  8034c7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8034c9:	6a 00                	push   $0x0
  8034cb:	6a 00                	push   $0x0
  8034cd:	6a 00                	push   $0x0
  8034cf:	6a 00                	push   $0x0
  8034d1:	6a 00                	push   $0x0
  8034d3:	6a 0f                	push   $0xf
  8034d5:	e8 82 fe ff ff       	call   80335c <syscall>
  8034da:	83 c4 18             	add    $0x18,%esp
}
  8034dd:	c9                   	leave  
  8034de:	c3                   	ret    

008034df <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8034df:	55                   	push   %ebp
  8034e0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8034e2:	6a 00                	push   $0x0
  8034e4:	6a 00                	push   $0x0
  8034e6:	6a 00                	push   $0x0
  8034e8:	6a 00                	push   $0x0
  8034ea:	ff 75 08             	pushl  0x8(%ebp)
  8034ed:	6a 10                	push   $0x10
  8034ef:	e8 68 fe ff ff       	call   80335c <syscall>
  8034f4:	83 c4 18             	add    $0x18,%esp
}
  8034f7:	c9                   	leave  
  8034f8:	c3                   	ret    

008034f9 <sys_scarce_memory>:

void sys_scarce_memory()
{
  8034f9:	55                   	push   %ebp
  8034fa:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8034fc:	6a 00                	push   $0x0
  8034fe:	6a 00                	push   $0x0
  803500:	6a 00                	push   $0x0
  803502:	6a 00                	push   $0x0
  803504:	6a 00                	push   $0x0
  803506:	6a 11                	push   $0x11
  803508:	e8 4f fe ff ff       	call   80335c <syscall>
  80350d:	83 c4 18             	add    $0x18,%esp
}
  803510:	90                   	nop
  803511:	c9                   	leave  
  803512:	c3                   	ret    

00803513 <sys_cputc>:

void
sys_cputc(const char c)
{
  803513:	55                   	push   %ebp
  803514:	89 e5                	mov    %esp,%ebp
  803516:	83 ec 04             	sub    $0x4,%esp
  803519:	8b 45 08             	mov    0x8(%ebp),%eax
  80351c:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  80351f:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  803523:	6a 00                	push   $0x0
  803525:	6a 00                	push   $0x0
  803527:	6a 00                	push   $0x0
  803529:	6a 00                	push   $0x0
  80352b:	50                   	push   %eax
  80352c:	6a 01                	push   $0x1
  80352e:	e8 29 fe ff ff       	call   80335c <syscall>
  803533:	83 c4 18             	add    $0x18,%esp
}
  803536:	90                   	nop
  803537:	c9                   	leave  
  803538:	c3                   	ret    

00803539 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  803539:	55                   	push   %ebp
  80353a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  80353c:	6a 00                	push   $0x0
  80353e:	6a 00                	push   $0x0
  803540:	6a 00                	push   $0x0
  803542:	6a 00                	push   $0x0
  803544:	6a 00                	push   $0x0
  803546:	6a 14                	push   $0x14
  803548:	e8 0f fe ff ff       	call   80335c <syscall>
  80354d:	83 c4 18             	add    $0x18,%esp
}
  803550:	90                   	nop
  803551:	c9                   	leave  
  803552:	c3                   	ret    

00803553 <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  803553:	55                   	push   %ebp
  803554:	89 e5                	mov    %esp,%ebp
  803556:	83 ec 04             	sub    $0x4,%esp
  803559:	8b 45 10             	mov    0x10(%ebp),%eax
  80355c:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  80355f:	8b 4d 14             	mov    0x14(%ebp),%ecx
  803562:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  803566:	8b 45 08             	mov    0x8(%ebp),%eax
  803569:	6a 00                	push   $0x0
  80356b:	51                   	push   %ecx
  80356c:	52                   	push   %edx
  80356d:	ff 75 0c             	pushl  0xc(%ebp)
  803570:	50                   	push   %eax
  803571:	6a 15                	push   $0x15
  803573:	e8 e4 fd ff ff       	call   80335c <syscall>
  803578:	83 c4 18             	add    $0x18,%esp
}
  80357b:	c9                   	leave  
  80357c:	c3                   	ret    

0080357d <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  80357d:	55                   	push   %ebp
  80357e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  803580:	8b 55 0c             	mov    0xc(%ebp),%edx
  803583:	8b 45 08             	mov    0x8(%ebp),%eax
  803586:	6a 00                	push   $0x0
  803588:	6a 00                	push   $0x0
  80358a:	6a 00                	push   $0x0
  80358c:	52                   	push   %edx
  80358d:	50                   	push   %eax
  80358e:	6a 16                	push   $0x16
  803590:	e8 c7 fd ff ff       	call   80335c <syscall>
  803595:	83 c4 18             	add    $0x18,%esp
}
  803598:	c9                   	leave  
  803599:	c3                   	ret    

0080359a <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  80359a:	55                   	push   %ebp
  80359b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  80359d:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8035a0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8035a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8035a6:	6a 00                	push   $0x0
  8035a8:	6a 00                	push   $0x0
  8035aa:	51                   	push   %ecx
  8035ab:	52                   	push   %edx
  8035ac:	50                   	push   %eax
  8035ad:	6a 17                	push   $0x17
  8035af:	e8 a8 fd ff ff       	call   80335c <syscall>
  8035b4:	83 c4 18             	add    $0x18,%esp
}
  8035b7:	c9                   	leave  
  8035b8:	c3                   	ret    

008035b9 <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  8035b9:	55                   	push   %ebp
  8035ba:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8035bc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8035bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8035c2:	6a 00                	push   $0x0
  8035c4:	6a 00                	push   $0x0
  8035c6:	6a 00                	push   $0x0
  8035c8:	52                   	push   %edx
  8035c9:	50                   	push   %eax
  8035ca:	6a 18                	push   $0x18
  8035cc:	e8 8b fd ff ff       	call   80335c <syscall>
  8035d1:	83 c4 18             	add    $0x18,%esp
}
  8035d4:	c9                   	leave  
  8035d5:	c3                   	ret    

008035d6 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8035d6:	55                   	push   %ebp
  8035d7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8035d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8035dc:	6a 00                	push   $0x0
  8035de:	ff 75 14             	pushl  0x14(%ebp)
  8035e1:	ff 75 10             	pushl  0x10(%ebp)
  8035e4:	ff 75 0c             	pushl  0xc(%ebp)
  8035e7:	50                   	push   %eax
  8035e8:	6a 19                	push   $0x19
  8035ea:	e8 6d fd ff ff       	call   80335c <syscall>
  8035ef:	83 c4 18             	add    $0x18,%esp
}
  8035f2:	c9                   	leave  
  8035f3:	c3                   	ret    

008035f4 <sys_run_env>:

void sys_run_env(int32 envId)
{
  8035f4:	55                   	push   %ebp
  8035f5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8035f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8035fa:	6a 00                	push   $0x0
  8035fc:	6a 00                	push   $0x0
  8035fe:	6a 00                	push   $0x0
  803600:	6a 00                	push   $0x0
  803602:	50                   	push   %eax
  803603:	6a 1a                	push   $0x1a
  803605:	e8 52 fd ff ff       	call   80335c <syscall>
  80360a:	83 c4 18             	add    $0x18,%esp
}
  80360d:	90                   	nop
  80360e:	c9                   	leave  
  80360f:	c3                   	ret    

00803610 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  803610:	55                   	push   %ebp
  803611:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  803613:	8b 45 08             	mov    0x8(%ebp),%eax
  803616:	6a 00                	push   $0x0
  803618:	6a 00                	push   $0x0
  80361a:	6a 00                	push   $0x0
  80361c:	6a 00                	push   $0x0
  80361e:	50                   	push   %eax
  80361f:	6a 1b                	push   $0x1b
  803621:	e8 36 fd ff ff       	call   80335c <syscall>
  803626:	83 c4 18             	add    $0x18,%esp
}
  803629:	c9                   	leave  
  80362a:	c3                   	ret    

0080362b <sys_getenvid>:

int32 sys_getenvid(void)
{
  80362b:	55                   	push   %ebp
  80362c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  80362e:	6a 00                	push   $0x0
  803630:	6a 00                	push   $0x0
  803632:	6a 00                	push   $0x0
  803634:	6a 00                	push   $0x0
  803636:	6a 00                	push   $0x0
  803638:	6a 05                	push   $0x5
  80363a:	e8 1d fd ff ff       	call   80335c <syscall>
  80363f:	83 c4 18             	add    $0x18,%esp
}
  803642:	c9                   	leave  
  803643:	c3                   	ret    

00803644 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  803644:	55                   	push   %ebp
  803645:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  803647:	6a 00                	push   $0x0
  803649:	6a 00                	push   $0x0
  80364b:	6a 00                	push   $0x0
  80364d:	6a 00                	push   $0x0
  80364f:	6a 00                	push   $0x0
  803651:	6a 06                	push   $0x6
  803653:	e8 04 fd ff ff       	call   80335c <syscall>
  803658:	83 c4 18             	add    $0x18,%esp
}
  80365b:	c9                   	leave  
  80365c:	c3                   	ret    

0080365d <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  80365d:	55                   	push   %ebp
  80365e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  803660:	6a 00                	push   $0x0
  803662:	6a 00                	push   $0x0
  803664:	6a 00                	push   $0x0
  803666:	6a 00                	push   $0x0
  803668:	6a 00                	push   $0x0
  80366a:	6a 07                	push   $0x7
  80366c:	e8 eb fc ff ff       	call   80335c <syscall>
  803671:	83 c4 18             	add    $0x18,%esp
}
  803674:	c9                   	leave  
  803675:	c3                   	ret    

00803676 <sys_exit_env>:


void sys_exit_env(void)
{
  803676:	55                   	push   %ebp
  803677:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  803679:	6a 00                	push   $0x0
  80367b:	6a 00                	push   $0x0
  80367d:	6a 00                	push   $0x0
  80367f:	6a 00                	push   $0x0
  803681:	6a 00                	push   $0x0
  803683:	6a 1c                	push   $0x1c
  803685:	e8 d2 fc ff ff       	call   80335c <syscall>
  80368a:	83 c4 18             	add    $0x18,%esp
}
  80368d:	90                   	nop
  80368e:	c9                   	leave  
  80368f:	c3                   	ret    

00803690 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  803690:	55                   	push   %ebp
  803691:	89 e5                	mov    %esp,%ebp
  803693:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  803696:	8d 45 f8             	lea    -0x8(%ebp),%eax
  803699:	8d 50 04             	lea    0x4(%eax),%edx
  80369c:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80369f:	6a 00                	push   $0x0
  8036a1:	6a 00                	push   $0x0
  8036a3:	6a 00                	push   $0x0
  8036a5:	52                   	push   %edx
  8036a6:	50                   	push   %eax
  8036a7:	6a 1d                	push   $0x1d
  8036a9:	e8 ae fc ff ff       	call   80335c <syscall>
  8036ae:	83 c4 18             	add    $0x18,%esp
	return result;
  8036b1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8036b4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8036b7:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8036ba:	89 01                	mov    %eax,(%ecx)
  8036bc:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8036bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8036c2:	c9                   	leave  
  8036c3:	c2 04 00             	ret    $0x4

008036c6 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8036c6:	55                   	push   %ebp
  8036c7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8036c9:	6a 00                	push   $0x0
  8036cb:	6a 00                	push   $0x0
  8036cd:	ff 75 10             	pushl  0x10(%ebp)
  8036d0:	ff 75 0c             	pushl  0xc(%ebp)
  8036d3:	ff 75 08             	pushl  0x8(%ebp)
  8036d6:	6a 13                	push   $0x13
  8036d8:	e8 7f fc ff ff       	call   80335c <syscall>
  8036dd:	83 c4 18             	add    $0x18,%esp
	return ;
  8036e0:	90                   	nop
}
  8036e1:	c9                   	leave  
  8036e2:	c3                   	ret    

008036e3 <sys_rcr2>:
uint32 sys_rcr2()
{
  8036e3:	55                   	push   %ebp
  8036e4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8036e6:	6a 00                	push   $0x0
  8036e8:	6a 00                	push   $0x0
  8036ea:	6a 00                	push   $0x0
  8036ec:	6a 00                	push   $0x0
  8036ee:	6a 00                	push   $0x0
  8036f0:	6a 1e                	push   $0x1e
  8036f2:	e8 65 fc ff ff       	call   80335c <syscall>
  8036f7:	83 c4 18             	add    $0x18,%esp
}
  8036fa:	c9                   	leave  
  8036fb:	c3                   	ret    

008036fc <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  8036fc:	55                   	push   %ebp
  8036fd:	89 e5                	mov    %esp,%ebp
  8036ff:	83 ec 04             	sub    $0x4,%esp
  803702:	8b 45 08             	mov    0x8(%ebp),%eax
  803705:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  803708:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  80370c:	6a 00                	push   $0x0
  80370e:	6a 00                	push   $0x0
  803710:	6a 00                	push   $0x0
  803712:	6a 00                	push   $0x0
  803714:	50                   	push   %eax
  803715:	6a 1f                	push   $0x1f
  803717:	e8 40 fc ff ff       	call   80335c <syscall>
  80371c:	83 c4 18             	add    $0x18,%esp
	return ;
  80371f:	90                   	nop
}
  803720:	c9                   	leave  
  803721:	c3                   	ret    

00803722 <rsttst>:
void rsttst()
{
  803722:	55                   	push   %ebp
  803723:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  803725:	6a 00                	push   $0x0
  803727:	6a 00                	push   $0x0
  803729:	6a 00                	push   $0x0
  80372b:	6a 00                	push   $0x0
  80372d:	6a 00                	push   $0x0
  80372f:	6a 21                	push   $0x21
  803731:	e8 26 fc ff ff       	call   80335c <syscall>
  803736:	83 c4 18             	add    $0x18,%esp
	return ;
  803739:	90                   	nop
}
  80373a:	c9                   	leave  
  80373b:	c3                   	ret    

0080373c <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  80373c:	55                   	push   %ebp
  80373d:	89 e5                	mov    %esp,%ebp
  80373f:	83 ec 04             	sub    $0x4,%esp
  803742:	8b 45 14             	mov    0x14(%ebp),%eax
  803745:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  803748:	8b 55 18             	mov    0x18(%ebp),%edx
  80374b:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80374f:	52                   	push   %edx
  803750:	50                   	push   %eax
  803751:	ff 75 10             	pushl  0x10(%ebp)
  803754:	ff 75 0c             	pushl  0xc(%ebp)
  803757:	ff 75 08             	pushl  0x8(%ebp)
  80375a:	6a 20                	push   $0x20
  80375c:	e8 fb fb ff ff       	call   80335c <syscall>
  803761:	83 c4 18             	add    $0x18,%esp
	return ;
  803764:	90                   	nop
}
  803765:	c9                   	leave  
  803766:	c3                   	ret    

00803767 <chktst>:
void chktst(uint32 n)
{
  803767:	55                   	push   %ebp
  803768:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  80376a:	6a 00                	push   $0x0
  80376c:	6a 00                	push   $0x0
  80376e:	6a 00                	push   $0x0
  803770:	6a 00                	push   $0x0
  803772:	ff 75 08             	pushl  0x8(%ebp)
  803775:	6a 22                	push   $0x22
  803777:	e8 e0 fb ff ff       	call   80335c <syscall>
  80377c:	83 c4 18             	add    $0x18,%esp
	return ;
  80377f:	90                   	nop
}
  803780:	c9                   	leave  
  803781:	c3                   	ret    

00803782 <inctst>:

void inctst()
{
  803782:	55                   	push   %ebp
  803783:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  803785:	6a 00                	push   $0x0
  803787:	6a 00                	push   $0x0
  803789:	6a 00                	push   $0x0
  80378b:	6a 00                	push   $0x0
  80378d:	6a 00                	push   $0x0
  80378f:	6a 23                	push   $0x23
  803791:	e8 c6 fb ff ff       	call   80335c <syscall>
  803796:	83 c4 18             	add    $0x18,%esp
	return ;
  803799:	90                   	nop
}
  80379a:	c9                   	leave  
  80379b:	c3                   	ret    

0080379c <gettst>:
uint32 gettst()
{
  80379c:	55                   	push   %ebp
  80379d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  80379f:	6a 00                	push   $0x0
  8037a1:	6a 00                	push   $0x0
  8037a3:	6a 00                	push   $0x0
  8037a5:	6a 00                	push   $0x0
  8037a7:	6a 00                	push   $0x0
  8037a9:	6a 24                	push   $0x24
  8037ab:	e8 ac fb ff ff       	call   80335c <syscall>
  8037b0:	83 c4 18             	add    $0x18,%esp
}
  8037b3:	c9                   	leave  
  8037b4:	c3                   	ret    

008037b5 <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  8037b5:	55                   	push   %ebp
  8037b6:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8037b8:	6a 00                	push   $0x0
  8037ba:	6a 00                	push   $0x0
  8037bc:	6a 00                	push   $0x0
  8037be:	6a 00                	push   $0x0
  8037c0:	6a 00                	push   $0x0
  8037c2:	6a 25                	push   $0x25
  8037c4:	e8 93 fb ff ff       	call   80335c <syscall>
  8037c9:	83 c4 18             	add    $0x18,%esp
  8037cc:	a3 60 e0 81 00       	mov    %eax,0x81e060
	return uheapPlaceStrategy ;
  8037d1:	a1 60 e0 81 00       	mov    0x81e060,%eax
}
  8037d6:	c9                   	leave  
  8037d7:	c3                   	ret    

008037d8 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  8037d8:	55                   	push   %ebp
  8037d9:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  8037db:	8b 45 08             	mov    0x8(%ebp),%eax
  8037de:	a3 60 e0 81 00       	mov    %eax,0x81e060
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  8037e3:	6a 00                	push   $0x0
  8037e5:	6a 00                	push   $0x0
  8037e7:	6a 00                	push   $0x0
  8037e9:	6a 00                	push   $0x0
  8037eb:	ff 75 08             	pushl  0x8(%ebp)
  8037ee:	6a 26                	push   $0x26
  8037f0:	e8 67 fb ff ff       	call   80335c <syscall>
  8037f5:	83 c4 18             	add    $0x18,%esp
	return ;
  8037f8:	90                   	nop
}
  8037f9:	c9                   	leave  
  8037fa:	c3                   	ret    

008037fb <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  8037fb:	55                   	push   %ebp
  8037fc:	89 e5                	mov    %esp,%ebp
  8037fe:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  8037ff:	8b 5d 14             	mov    0x14(%ebp),%ebx
  803802:	8b 4d 10             	mov    0x10(%ebp),%ecx
  803805:	8b 55 0c             	mov    0xc(%ebp),%edx
  803808:	8b 45 08             	mov    0x8(%ebp),%eax
  80380b:	6a 00                	push   $0x0
  80380d:	53                   	push   %ebx
  80380e:	51                   	push   %ecx
  80380f:	52                   	push   %edx
  803810:	50                   	push   %eax
  803811:	6a 27                	push   $0x27
  803813:	e8 44 fb ff ff       	call   80335c <syscall>
  803818:	83 c4 18             	add    $0x18,%esp
}
  80381b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80381e:	c9                   	leave  
  80381f:	c3                   	ret    

00803820 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  803820:	55                   	push   %ebp
  803821:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  803823:	8b 55 0c             	mov    0xc(%ebp),%edx
  803826:	8b 45 08             	mov    0x8(%ebp),%eax
  803829:	6a 00                	push   $0x0
  80382b:	6a 00                	push   $0x0
  80382d:	6a 00                	push   $0x0
  80382f:	52                   	push   %edx
  803830:	50                   	push   %eax
  803831:	6a 28                	push   $0x28
  803833:	e8 24 fb ff ff       	call   80335c <syscall>
  803838:	83 c4 18             	add    $0x18,%esp
}
  80383b:	c9                   	leave  
  80383c:	c3                   	ret    

0080383d <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  80383d:	55                   	push   %ebp
  80383e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  803840:	8b 4d 14             	mov    0x14(%ebp),%ecx
  803843:	8b 55 0c             	mov    0xc(%ebp),%edx
  803846:	8b 45 08             	mov    0x8(%ebp),%eax
  803849:	6a 00                	push   $0x0
  80384b:	51                   	push   %ecx
  80384c:	ff 75 10             	pushl  0x10(%ebp)
  80384f:	52                   	push   %edx
  803850:	50                   	push   %eax
  803851:	6a 29                	push   $0x29
  803853:	e8 04 fb ff ff       	call   80335c <syscall>
  803858:	83 c4 18             	add    $0x18,%esp
}
  80385b:	c9                   	leave  
  80385c:	c3                   	ret    

0080385d <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  80385d:	55                   	push   %ebp
  80385e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  803860:	6a 00                	push   $0x0
  803862:	6a 00                	push   $0x0
  803864:	ff 75 10             	pushl  0x10(%ebp)
  803867:	ff 75 0c             	pushl  0xc(%ebp)
  80386a:	ff 75 08             	pushl  0x8(%ebp)
  80386d:	6a 12                	push   $0x12
  80386f:	e8 e8 fa ff ff       	call   80335c <syscall>
  803874:	83 c4 18             	add    $0x18,%esp
	return ;
  803877:	90                   	nop
}
  803878:	c9                   	leave  
  803879:	c3                   	ret    

0080387a <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  80387a:	55                   	push   %ebp
  80387b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  80387d:	8b 55 0c             	mov    0xc(%ebp),%edx
  803880:	8b 45 08             	mov    0x8(%ebp),%eax
  803883:	6a 00                	push   $0x0
  803885:	6a 00                	push   $0x0
  803887:	6a 00                	push   $0x0
  803889:	52                   	push   %edx
  80388a:	50                   	push   %eax
  80388b:	6a 2a                	push   $0x2a
  80388d:	e8 ca fa ff ff       	call   80335c <syscall>
  803892:	83 c4 18             	add    $0x18,%esp
	return;
  803895:	90                   	nop
}
  803896:	c9                   	leave  
  803897:	c3                   	ret    

00803898 <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  803898:	55                   	push   %ebp
  803899:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  80389b:	6a 00                	push   $0x0
  80389d:	6a 00                	push   $0x0
  80389f:	6a 00                	push   $0x0
  8038a1:	6a 00                	push   $0x0
  8038a3:	6a 00                	push   $0x0
  8038a5:	6a 2b                	push   $0x2b
  8038a7:	e8 b0 fa ff ff       	call   80335c <syscall>
  8038ac:	83 c4 18             	add    $0x18,%esp
}
  8038af:	c9                   	leave  
  8038b0:	c3                   	ret    

008038b1 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8038b1:	55                   	push   %ebp
  8038b2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  8038b4:	6a 00                	push   $0x0
  8038b6:	6a 00                	push   $0x0
  8038b8:	6a 00                	push   $0x0
  8038ba:	ff 75 0c             	pushl  0xc(%ebp)
  8038bd:	ff 75 08             	pushl  0x8(%ebp)
  8038c0:	6a 2d                	push   $0x2d
  8038c2:	e8 95 fa ff ff       	call   80335c <syscall>
  8038c7:	83 c4 18             	add    $0x18,%esp
	return;
  8038ca:	90                   	nop
}
  8038cb:	c9                   	leave  
  8038cc:	c3                   	ret    

008038cd <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8038cd:	55                   	push   %ebp
  8038ce:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  8038d0:	6a 00                	push   $0x0
  8038d2:	6a 00                	push   $0x0
  8038d4:	6a 00                	push   $0x0
  8038d6:	ff 75 0c             	pushl  0xc(%ebp)
  8038d9:	ff 75 08             	pushl  0x8(%ebp)
  8038dc:	6a 2c                	push   $0x2c
  8038de:	e8 79 fa ff ff       	call   80335c <syscall>
  8038e3:	83 c4 18             	add    $0x18,%esp
	return ;
  8038e6:	90                   	nop
}
  8038e7:	c9                   	leave  
  8038e8:	c3                   	ret    

008038e9 <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  8038e9:	55                   	push   %ebp
  8038ea:	89 e5                	mov    %esp,%ebp
	//TODO: [PROJECT'25.IM#4] CPU SCHEDULING - #1 System Calls - Add suitable code here
	//Your code is here
	//Comment the following line
	//panic("sys_env_set_priority() is not implemented yet...!!");
	syscall(SYS_env_set_priority, envID, priority, 0, 0, 0);
  8038ec:	8b 55 0c             	mov    0xc(%ebp),%edx
  8038ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8038f2:	6a 00                	push   $0x0
  8038f4:	6a 00                	push   $0x0
  8038f6:	6a 00                	push   $0x0
  8038f8:	52                   	push   %edx
  8038f9:	50                   	push   %eax
  8038fa:	6a 2e                	push   $0x2e
  8038fc:	e8 5b fa ff ff       	call   80335c <syscall>
  803901:	83 c4 18             	add    $0x18,%esp
	    return;
  803904:	90                   	nop
}
  803905:	c9                   	leave  
  803906:	c3                   	ret    

00803907 <to_page_va>:
//==================================================================================//
//==================================
// [1] GET PAGE VA:
//==================================
__inline__ uint32 to_page_va(struct PageInfoElement *ptrPageInfo)
{
  803907:	55                   	push   %ebp
  803908:	89 e5                	mov    %esp,%ebp
  80390a:	83 ec 10             	sub    $0x10,%esp
	//Get start VA of the page from the corresponding Page Info pointer
	int idxInPageInfoArr = (ptrPageInfo - pageBlockInfoArr);
  80390d:	8b 45 08             	mov    0x8(%ebp),%eax
  803910:	ba 60 60 80 00       	mov    $0x806060,%edx
  803915:	29 d0                	sub    %edx,%eax
  803917:	c1 f8 02             	sar    $0x2,%eax
  80391a:	89 c2                	mov    %eax,%edx
  80391c:	89 d0                	mov    %edx,%eax
  80391e:	c1 e0 02             	shl    $0x2,%eax
  803921:	01 d0                	add    %edx,%eax
  803923:	c1 e0 02             	shl    $0x2,%eax
  803926:	01 d0                	add    %edx,%eax
  803928:	c1 e0 02             	shl    $0x2,%eax
  80392b:	01 d0                	add    %edx,%eax
  80392d:	89 c1                	mov    %eax,%ecx
  80392f:	c1 e1 08             	shl    $0x8,%ecx
  803932:	01 c8                	add    %ecx,%eax
  803934:	89 c1                	mov    %eax,%ecx
  803936:	c1 e1 10             	shl    $0x10,%ecx
  803939:	01 c8                	add    %ecx,%eax
  80393b:	01 c0                	add    %eax,%eax
  80393d:	01 d0                	add    %edx,%eax
  80393f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return dynAllocStart + (idxInPageInfoArr << PGSHIFT);
  803942:	8b 45 fc             	mov    -0x4(%ebp),%eax
  803945:	c1 e0 0c             	shl    $0xc,%eax
  803948:	89 c2                	mov    %eax,%edx
  80394a:	a1 64 e0 81 00       	mov    0x81e064,%eax
  80394f:	01 d0                	add    %edx,%eax
}
  803951:	c9                   	leave  
  803952:	c3                   	ret    

00803953 <log2>:

//==================================================================================//
//============================ REQUIRED FUNCTIONS ==================================//
//==================================================================================//
__inline__ int log2(uint32 n)
	{
  803953:	55                   	push   %ebp
  803954:	89 e5                	mov    %esp,%ebp
  803956:	83 ec 10             	sub    $0x10,%esp
		int result = 0;
  803959:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
		while( n > 1){
  803960:	eb 06                	jmp    803968 <log2+0x15>
			n >>=1;
  803962:	d1 6d 08             	shrl   0x8(%ebp)
			result++;
  803965:	ff 45 fc             	incl   -0x4(%ebp)
//============================ REQUIRED FUNCTIONS ==================================//
//==================================================================================//
__inline__ int log2(uint32 n)
	{
		int result = 0;
		while( n > 1){
  803968:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
  80396c:	77 f4                	ja     803962 <log2+0xf>
			n >>=1;
			result++;
		}
		return result;
  80396e:	8b 45 fc             	mov    -0x4(%ebp),%eax
	}
  803971:	c9                   	leave  
  803972:	c3                   	ret    

00803973 <initialize_dynamic_allocator>:
//==================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================
bool is_initialized = 0;
void initialize_dynamic_allocator(uint32 daStart, uint32 daEnd)
{
  803973:	55                   	push   %ebp
  803974:	89 e5                	mov    %esp,%ebp
  803976:	83 ec 18             	sub    $0x18,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(daEnd <= daStart + DYN_ALLOC_MAX_SIZE);
  803979:	8b 45 08             	mov    0x8(%ebp),%eax
  80397c:	05 00 00 00 02       	add    $0x2000000,%eax
  803981:	3b 45 0c             	cmp    0xc(%ebp),%eax
  803984:	73 16                	jae    80399c <initialize_dynamic_allocator+0x29>
  803986:	68 f8 52 80 00       	push   $0x8052f8
  80398b:	68 1e 53 80 00       	push   $0x80531e
  803990:	6a 2d                	push   $0x2d
  803992:	68 33 53 80 00       	push   $0x805333
  803997:	e8 a6 ce ff ff       	call   800842 <_panic>
		is_initialized = 1;
  80399c:	c7 05 24 60 80 00 01 	movl   $0x1,0x806024
  8039a3:	00 00 00 
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #1 initialize_dynamic_allocator
	//Your code is here


	dynAllocStart = daStart;
  8039a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8039a9:	a3 64 e0 81 00       	mov    %eax,0x81e064
	dynAllocEnd= daEnd;
  8039ae:	8b 45 0c             	mov    0xc(%ebp),%eax
  8039b1:	a3 40 60 80 00       	mov    %eax,0x806040
	int numOfPages = (dynAllocEnd - dynAllocStart)/PAGE_SIZE;
  8039b6:	8b 15 40 60 80 00    	mov    0x806040,%edx
  8039bc:	a1 64 e0 81 00       	mov    0x81e064,%eax
  8039c1:	29 c2                	sub    %eax,%edx
  8039c3:	89 d0                	mov    %edx,%eax
  8039c5:	c1 e8 0c             	shr    $0xc,%eax
  8039c8:	89 45 e8             	mov    %eax,-0x18(%ebp)


	for(int i=0; i< numOfPages; i++){
  8039cb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8039d2:	eb 2f                	jmp    803a03 <initialize_dynamic_allocator+0x90>
	    pageBlockInfoArr[i].block_size=0;
  8039d4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8039d7:	89 d0                	mov    %edx,%eax
  8039d9:	01 c0                	add    %eax,%eax
  8039db:	01 d0                	add    %edx,%eax
  8039dd:	c1 e0 02             	shl    $0x2,%eax
  8039e0:	05 68 60 80 00       	add    $0x806068,%eax
  8039e5:	66 c7 00 00 00       	movw   $0x0,(%eax)
	    pageBlockInfoArr[i].num_of_free_blocks=0;
  8039ea:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8039ed:	89 d0                	mov    %edx,%eax
  8039ef:	01 c0                	add    %eax,%eax
  8039f1:	01 d0                	add    %edx,%eax
  8039f3:	c1 e0 02             	shl    $0x2,%eax
  8039f6:	05 6a 60 80 00       	add    $0x80606a,%eax
  8039fb:	66 c7 00 00 00       	movw   $0x0,(%eax)
	dynAllocStart = daStart;
	dynAllocEnd= daEnd;
	int numOfPages = (dynAllocEnd - dynAllocStart)/PAGE_SIZE;


	for(int i=0; i< numOfPages; i++){
  803a00:	ff 45 f4             	incl   -0xc(%ebp)
  803a03:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a06:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803a09:	7c c9                	jl     8039d4 <initialize_dynamic_allocator+0x61>
	    pageBlockInfoArr[i].block_size=0;
	    pageBlockInfoArr[i].num_of_free_blocks=0;
	}


	LIST_INIT(&freePagesList);
  803a0b:	c7 05 48 60 80 00 00 	movl   $0x0,0x806048
  803a12:	00 00 00 
  803a15:	c7 05 4c 60 80 00 00 	movl   $0x0,0x80604c
  803a1c:	00 00 00 
  803a1f:	c7 05 54 60 80 00 00 	movl   $0x0,0x806054
  803a26:	00 00 00 
	for(int i=0; i<numOfPages; i++){
  803a29:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  803a30:	e9 9c 00 00 00       	jmp    803ad1 <initialize_dynamic_allocator+0x15e>
		LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
  803a35:	8b 15 4c 60 80 00    	mov    0x80604c,%edx
  803a3b:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  803a3e:	89 c8                	mov    %ecx,%eax
  803a40:	01 c0                	add    %eax,%eax
  803a42:	01 c8                	add    %ecx,%eax
  803a44:	c1 e0 02             	shl    $0x2,%eax
  803a47:	05 64 60 80 00       	add    $0x806064,%eax
  803a4c:	89 10                	mov    %edx,(%eax)
  803a4e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803a51:	89 d0                	mov    %edx,%eax
  803a53:	01 c0                	add    %eax,%eax
  803a55:	01 d0                	add    %edx,%eax
  803a57:	c1 e0 02             	shl    $0x2,%eax
  803a5a:	05 64 60 80 00       	add    $0x806064,%eax
  803a5f:	8b 00                	mov    (%eax),%eax
  803a61:	85 c0                	test   %eax,%eax
  803a63:	74 1b                	je     803a80 <initialize_dynamic_allocator+0x10d>
  803a65:	8b 15 4c 60 80 00    	mov    0x80604c,%edx
  803a6b:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  803a6e:	89 c8                	mov    %ecx,%eax
  803a70:	01 c0                	add    %eax,%eax
  803a72:	01 c8                	add    %ecx,%eax
  803a74:	c1 e0 02             	shl    $0x2,%eax
  803a77:	05 60 60 80 00       	add    $0x806060,%eax
  803a7c:	89 02                	mov    %eax,(%edx)
  803a7e:	eb 16                	jmp    803a96 <initialize_dynamic_allocator+0x123>
  803a80:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803a83:	89 d0                	mov    %edx,%eax
  803a85:	01 c0                	add    %eax,%eax
  803a87:	01 d0                	add    %edx,%eax
  803a89:	c1 e0 02             	shl    $0x2,%eax
  803a8c:	05 60 60 80 00       	add    $0x806060,%eax
  803a91:	a3 48 60 80 00       	mov    %eax,0x806048
  803a96:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803a99:	89 d0                	mov    %edx,%eax
  803a9b:	01 c0                	add    %eax,%eax
  803a9d:	01 d0                	add    %edx,%eax
  803a9f:	c1 e0 02             	shl    $0x2,%eax
  803aa2:	05 60 60 80 00       	add    $0x806060,%eax
  803aa7:	a3 4c 60 80 00       	mov    %eax,0x80604c
  803aac:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803aaf:	89 d0                	mov    %edx,%eax
  803ab1:	01 c0                	add    %eax,%eax
  803ab3:	01 d0                	add    %edx,%eax
  803ab5:	c1 e0 02             	shl    $0x2,%eax
  803ab8:	05 60 60 80 00       	add    $0x806060,%eax
  803abd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803ac3:	a1 54 60 80 00       	mov    0x806054,%eax
  803ac8:	40                   	inc    %eax
  803ac9:	a3 54 60 80 00       	mov    %eax,0x806054
	    pageBlockInfoArr[i].num_of_free_blocks=0;
	}


	LIST_INIT(&freePagesList);
	for(int i=0; i<numOfPages; i++){
  803ace:	ff 45 f0             	incl   -0x10(%ebp)
  803ad1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803ad4:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803ad7:	0f 8c 58 ff ff ff    	jl     803a35 <initialize_dynamic_allocator+0xc2>
		LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
	}



	for (int i = 0; i < LOG2_MAX_SIZE - LOG2_MIN_SIZE + 1; i++) {
  803add:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  803ae4:	eb 36                	jmp    803b1c <initialize_dynamic_allocator+0x1a9>
	    LIST_INIT(&freeBlockLists[i]);
  803ae6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803ae9:	c1 e0 04             	shl    $0x4,%eax
  803aec:	05 80 e0 81 00       	add    $0x81e080,%eax
  803af1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803af7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803afa:	c1 e0 04             	shl    $0x4,%eax
  803afd:	05 84 e0 81 00       	add    $0x81e084,%eax
  803b02:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803b08:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803b0b:	c1 e0 04             	shl    $0x4,%eax
  803b0e:	05 8c e0 81 00       	add    $0x81e08c,%eax
  803b13:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
	}



	for (int i = 0; i < LOG2_MAX_SIZE - LOG2_MIN_SIZE + 1; i++) {
  803b19:	ff 45 ec             	incl   -0x14(%ebp)
  803b1c:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  803b20:	7e c4                	jle    803ae6 <initialize_dynamic_allocator+0x173>


	//Comment the following line
	//panic("initialize_dynamic_allocator() Not implemented yet");

}
  803b22:	90                   	nop
  803b23:	c9                   	leave  
  803b24:	c3                   	ret    

00803b25 <get_block_size>:
// [2] GET BLOCK SIZE:
//===========================


__inline__ uint32 get_block_size(void *va)
{
  803b25:	55                   	push   %ebp
  803b26:	89 e5                	mov    %esp,%ebp
  803b28:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #2 get_block_size
	//Your code is here

	uint32 page_index = ((uint32)va - dynAllocStart)/ PAGE_SIZE;
  803b2b:	8b 55 08             	mov    0x8(%ebp),%edx
  803b2e:	a1 64 e0 81 00       	mov    0x81e064,%eax
  803b33:	29 c2                	sub    %eax,%edx
  803b35:	89 d0                	mov    %edx,%eax
  803b37:	c1 e8 0c             	shr    $0xc,%eax
  803b3a:	89 45 fc             	mov    %eax,-0x4(%ebp)
    return pageBlockInfoArr[page_index].block_size;
  803b3d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  803b40:	89 d0                	mov    %edx,%eax
  803b42:	01 c0                	add    %eax,%eax
  803b44:	01 d0                	add    %edx,%eax
  803b46:	c1 e0 02             	shl    $0x2,%eax
  803b49:	05 68 60 80 00       	add    $0x806068,%eax
  803b4e:	8b 00                	mov    (%eax),%eax
  803b50:	0f b7 c0             	movzwl %ax,%eax
	//Comment the following line
	//panic("get_block_size() Not implemented yet");
}
  803b53:	c9                   	leave  
  803b54:	c3                   	ret    

00803b55 <alloc_block>:

//===========================
// 3) ALLOCATE BLOCK:
//===========================
void *alloc_block(uint32 size)
{
  803b55:	55                   	push   %ebp
  803b56:	89 e5                	mov    %esp,%ebp
  803b58:	83 ec 48             	sub    $0x48,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(size <= DYN_ALLOC_MAX_BLOCK_SIZE);
  803b5b:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  803b62:	76 16                	jbe    803b7a <alloc_block+0x25>
  803b64:	68 4c 53 80 00       	push   $0x80534c
  803b69:	68 1e 53 80 00       	push   $0x80531e
  803b6e:	6a 6c                	push   $0x6c
  803b70:	68 33 53 80 00       	push   $0x805333
  803b75:	e8 c8 cc ff ff       	call   800842 <_panic>
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #3 alloc_block
	//Your code is here


	if(size == 0){
  803b7a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803b7e:	75 0a                	jne    803b8a <alloc_block+0x35>
		return NULL;
  803b80:	b8 00 00 00 00       	mov    $0x0,%eax
  803b85:	e9 65 04 00 00       	jmp    803fef <alloc_block+0x49a>
	}
	else if(size<=8){
  803b8a:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  803b8e:	77 09                	ja     803b99 <alloc_block+0x44>
		size=8;
  803b90:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
  803b97:	eb 1f                	jmp    803bb8 <alloc_block+0x63>
	}
	else{
		uint32 reqsize=8;
  803b99:	c7 45 f4 08 00 00 00 	movl   $0x8,-0xc(%ebp)
		while(reqsize < size){
  803ba0:	eb 08                	jmp    803baa <alloc_block+0x55>
			reqsize*=2;
  803ba2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ba5:	01 c0                	add    %eax,%eax
  803ba7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	else if(size<=8){
		size=8;
	}
	else{
		uint32 reqsize=8;
		while(reqsize < size){
  803baa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803bad:	3b 45 08             	cmp    0x8(%ebp),%eax
  803bb0:	72 f0                	jb     803ba2 <alloc_block+0x4d>
			reqsize*=2;
		}
		size= reqsize;
  803bb2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803bb5:	89 45 08             	mov    %eax,0x8(%ebp)
	}

	int list_index = log2(size)- LOG2_MIN_SIZE;
  803bb8:	83 ec 0c             	sub    $0xc,%esp
  803bbb:	ff 75 08             	pushl  0x8(%ebp)
  803bbe:	e8 90 fd ff ff       	call   803953 <log2>
  803bc3:	83 c4 10             	add    $0x10,%esp
  803bc6:	83 e8 03             	sub    $0x3,%eax
  803bc9:	89 45 e8             	mov    %eax,-0x18(%ebp)

	if(!LIST_EMPTY(&freeBlockLists[list_index])){
  803bcc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803bcf:	c1 e0 04             	shl    $0x4,%eax
  803bd2:	05 80 e0 81 00       	add    $0x81e080,%eax
  803bd7:	8b 00                	mov    (%eax),%eax
  803bd9:	85 c0                	test   %eax,%eax
  803bdb:	0f 84 fb 00 00 00    	je     803cdc <alloc_block+0x187>
		struct BlockElement *block = LIST_FIRST(&freeBlockLists[list_index]);
  803be1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803be4:	c1 e0 04             	shl    $0x4,%eax
  803be7:	05 80 e0 81 00       	add    $0x81e080,%eax
  803bec:	8b 00                	mov    (%eax),%eax
  803bee:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		LIST_REMOVE(&freeBlockLists[list_index], block);
  803bf1:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803bf5:	75 17                	jne    803c0e <alloc_block+0xb9>
  803bf7:	83 ec 04             	sub    $0x4,%esp
  803bfa:	68 6d 53 80 00       	push   $0x80536d
  803bff:	68 86 00 00 00       	push   $0x86
  803c04:	68 33 53 80 00       	push   $0x805333
  803c09:	e8 34 cc ff ff       	call   800842 <_panic>
  803c0e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803c11:	8b 00                	mov    (%eax),%eax
  803c13:	85 c0                	test   %eax,%eax
  803c15:	74 10                	je     803c27 <alloc_block+0xd2>
  803c17:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803c1a:	8b 00                	mov    (%eax),%eax
  803c1c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803c1f:	8b 52 04             	mov    0x4(%edx),%edx
  803c22:	89 50 04             	mov    %edx,0x4(%eax)
  803c25:	eb 14                	jmp    803c3b <alloc_block+0xe6>
  803c27:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803c2a:	8b 40 04             	mov    0x4(%eax),%eax
  803c2d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803c30:	c1 e2 04             	shl    $0x4,%edx
  803c33:	81 c2 84 e0 81 00    	add    $0x81e084,%edx
  803c39:	89 02                	mov    %eax,(%edx)
  803c3b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803c3e:	8b 40 04             	mov    0x4(%eax),%eax
  803c41:	85 c0                	test   %eax,%eax
  803c43:	74 0f                	je     803c54 <alloc_block+0xff>
  803c45:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803c48:	8b 40 04             	mov    0x4(%eax),%eax
  803c4b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803c4e:	8b 12                	mov    (%edx),%edx
  803c50:	89 10                	mov    %edx,(%eax)
  803c52:	eb 13                	jmp    803c67 <alloc_block+0x112>
  803c54:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803c57:	8b 00                	mov    (%eax),%eax
  803c59:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803c5c:	c1 e2 04             	shl    $0x4,%edx
  803c5f:	81 c2 80 e0 81 00    	add    $0x81e080,%edx
  803c65:	89 02                	mov    %eax,(%edx)
  803c67:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803c6a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803c70:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803c73:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803c7a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803c7d:	c1 e0 04             	shl    $0x4,%eax
  803c80:	05 8c e0 81 00       	add    $0x81e08c,%eax
  803c85:	8b 00                	mov    (%eax),%eax
  803c87:	8d 50 ff             	lea    -0x1(%eax),%edx
  803c8a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803c8d:	c1 e0 04             	shl    $0x4,%eax
  803c90:	05 8c e0 81 00       	add    $0x81e08c,%eax
  803c95:	89 10                	mov    %edx,(%eax)
		uint32 page_index = ((uint32)block - dynAllocStart)/ PAGE_SIZE;
  803c97:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803c9a:	a1 64 e0 81 00       	mov    0x81e064,%eax
  803c9f:	29 c2                	sub    %eax,%edx
  803ca1:	89 d0                	mov    %edx,%eax
  803ca3:	c1 e8 0c             	shr    $0xc,%eax
  803ca6:	89 45 e0             	mov    %eax,-0x20(%ebp)
		pageBlockInfoArr[page_index].num_of_free_blocks--;
  803ca9:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803cac:	89 d0                	mov    %edx,%eax
  803cae:	01 c0                	add    %eax,%eax
  803cb0:	01 d0                	add    %edx,%eax
  803cb2:	c1 e0 02             	shl    $0x2,%eax
  803cb5:	05 6a 60 80 00       	add    $0x80606a,%eax
  803cba:	66 8b 00             	mov    (%eax),%ax
  803cbd:	8d 50 ff             	lea    -0x1(%eax),%edx
  803cc0:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  803cc3:	89 c8                	mov    %ecx,%eax
  803cc5:	01 c0                	add    %eax,%eax
  803cc7:	01 c8                	add    %ecx,%eax
  803cc9:	c1 e0 02             	shl    $0x2,%eax
  803ccc:	05 6a 60 80 00       	add    $0x80606a,%eax
  803cd1:	66 89 10             	mov    %dx,(%eax)
		return (void*)block;
  803cd4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803cd7:	e9 13 03 00 00       	jmp    803fef <alloc_block+0x49a>
	}

	if(!LIST_EMPTY(&freePagesList)){
  803cdc:	a1 48 60 80 00       	mov    0x806048,%eax
  803ce1:	85 c0                	test   %eax,%eax
  803ce3:	0f 84 c9 01 00 00    	je     803eb2 <alloc_block+0x35d>

		struct PageInfoElement *page_info = LIST_FIRST(&freePagesList);
  803ce9:	a1 48 60 80 00       	mov    0x806048,%eax
  803cee:	89 45 dc             	mov    %eax,-0x24(%ebp)
		LIST_REMOVE(&freePagesList, page_info);
  803cf1:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803cf5:	75 17                	jne    803d0e <alloc_block+0x1b9>
  803cf7:	83 ec 04             	sub    $0x4,%esp
  803cfa:	68 6d 53 80 00       	push   $0x80536d
  803cff:	68 8f 00 00 00       	push   $0x8f
  803d04:	68 33 53 80 00       	push   $0x805333
  803d09:	e8 34 cb ff ff       	call   800842 <_panic>
  803d0e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803d11:	8b 00                	mov    (%eax),%eax
  803d13:	85 c0                	test   %eax,%eax
  803d15:	74 10                	je     803d27 <alloc_block+0x1d2>
  803d17:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803d1a:	8b 00                	mov    (%eax),%eax
  803d1c:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803d1f:	8b 52 04             	mov    0x4(%edx),%edx
  803d22:	89 50 04             	mov    %edx,0x4(%eax)
  803d25:	eb 0b                	jmp    803d32 <alloc_block+0x1dd>
  803d27:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803d2a:	8b 40 04             	mov    0x4(%eax),%eax
  803d2d:	a3 4c 60 80 00       	mov    %eax,0x80604c
  803d32:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803d35:	8b 40 04             	mov    0x4(%eax),%eax
  803d38:	85 c0                	test   %eax,%eax
  803d3a:	74 0f                	je     803d4b <alloc_block+0x1f6>
  803d3c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803d3f:	8b 40 04             	mov    0x4(%eax),%eax
  803d42:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803d45:	8b 12                	mov    (%edx),%edx
  803d47:	89 10                	mov    %edx,(%eax)
  803d49:	eb 0a                	jmp    803d55 <alloc_block+0x200>
  803d4b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803d4e:	8b 00                	mov    (%eax),%eax
  803d50:	a3 48 60 80 00       	mov    %eax,0x806048
  803d55:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803d58:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803d5e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803d61:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803d68:	a1 54 60 80 00       	mov    0x806054,%eax
  803d6d:	48                   	dec    %eax
  803d6e:	a3 54 60 80 00       	mov    %eax,0x806054
		uint32 page_va = to_page_va(page_info);
  803d73:	83 ec 0c             	sub    $0xc,%esp
  803d76:	ff 75 dc             	pushl  -0x24(%ebp)
  803d79:	e8 89 fb ff ff       	call   803907 <to_page_va>
  803d7e:	83 c4 10             	add    $0x10,%esp
  803d81:	89 45 d8             	mov    %eax,-0x28(%ebp)

		uint32 page_index = (page_va - dynAllocStart)/ PAGE_SIZE;
  803d84:	a1 64 e0 81 00       	mov    0x81e064,%eax
  803d89:	8b 55 d8             	mov    -0x28(%ebp),%edx
  803d8c:	29 c2                	sub    %eax,%edx
  803d8e:	89 d0                	mov    %edx,%eax
  803d90:	c1 e8 0c             	shr    $0xc,%eax
  803d93:	89 45 d4             	mov    %eax,-0x2c(%ebp)

		get_page((void*)page_va);
  803d96:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803d99:	83 ec 0c             	sub    $0xc,%esp
  803d9c:	50                   	push   %eax
  803d9d:	e8 fe dc ff ff       	call   801aa0 <get_page>
  803da2:	83 c4 10             	add    $0x10,%esp


		pageBlockInfoArr[page_index].block_size = size;
  803da5:	8b 45 08             	mov    0x8(%ebp),%eax
  803da8:	89 c2                	mov    %eax,%edx
  803daa:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  803dad:	89 c8                	mov    %ecx,%eax
  803daf:	01 c0                	add    %eax,%eax
  803db1:	01 c8                	add    %ecx,%eax
  803db3:	c1 e0 02             	shl    $0x2,%eax
  803db6:	05 68 60 80 00       	add    $0x806068,%eax
  803dbb:	66 89 10             	mov    %dx,(%eax)
		int num_blocks = PAGE_SIZE / size ;
  803dbe:	b8 00 10 00 00       	mov    $0x1000,%eax
  803dc3:	ba 00 00 00 00       	mov    $0x0,%edx
  803dc8:	f7 75 08             	divl   0x8(%ebp)
  803dcb:	89 45 d0             	mov    %eax,-0x30(%ebp)
		pageBlockInfoArr[page_index].num_of_free_blocks= num_blocks - 1 ;
  803dce:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803dd1:	8d 50 ff             	lea    -0x1(%eax),%edx
  803dd4:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  803dd7:	89 c8                	mov    %ecx,%eax
  803dd9:	01 c0                	add    %eax,%eax
  803ddb:	01 c8                	add    %ecx,%eax
  803ddd:	c1 e0 02             	shl    $0x2,%eax
  803de0:	05 6a 60 80 00       	add    $0x80606a,%eax
  803de5:	66 89 10             	mov    %dx,(%eax)

		for(int i=1; i< num_blocks; i++){
  803de8:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
  803def:	e9 aa 00 00 00       	jmp    803e9e <alloc_block+0x349>
			struct BlockElement *new_block = (struct BlockElement*)(page_va + i *size);
  803df4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803df7:	0f af 45 08          	imul   0x8(%ebp),%eax
  803dfb:	89 c2                	mov    %eax,%edx
  803dfd:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803e00:	01 d0                	add    %edx,%eax
  803e02:	89 45 cc             	mov    %eax,-0x34(%ebp)
			LIST_INSERT_TAIL(&freeBlockLists[list_index], new_block);
  803e05:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  803e09:	75 17                	jne    803e22 <alloc_block+0x2cd>
  803e0b:	83 ec 04             	sub    $0x4,%esp
  803e0e:	68 8c 53 80 00       	push   $0x80538c
  803e13:	68 9d 00 00 00       	push   $0x9d
  803e18:	68 33 53 80 00       	push   $0x805333
  803e1d:	e8 20 ca ff ff       	call   800842 <_panic>
  803e22:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803e25:	c1 e0 04             	shl    $0x4,%eax
  803e28:	05 84 e0 81 00       	add    $0x81e084,%eax
  803e2d:	8b 10                	mov    (%eax),%edx
  803e2f:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803e32:	89 50 04             	mov    %edx,0x4(%eax)
  803e35:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803e38:	8b 40 04             	mov    0x4(%eax),%eax
  803e3b:	85 c0                	test   %eax,%eax
  803e3d:	74 14                	je     803e53 <alloc_block+0x2fe>
  803e3f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803e42:	c1 e0 04             	shl    $0x4,%eax
  803e45:	05 84 e0 81 00       	add    $0x81e084,%eax
  803e4a:	8b 00                	mov    (%eax),%eax
  803e4c:	8b 55 cc             	mov    -0x34(%ebp),%edx
  803e4f:	89 10                	mov    %edx,(%eax)
  803e51:	eb 11                	jmp    803e64 <alloc_block+0x30f>
  803e53:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803e56:	c1 e0 04             	shl    $0x4,%eax
  803e59:	8d 90 80 e0 81 00    	lea    0x81e080(%eax),%edx
  803e5f:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803e62:	89 02                	mov    %eax,(%edx)
  803e64:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803e67:	c1 e0 04             	shl    $0x4,%eax
  803e6a:	8d 90 84 e0 81 00    	lea    0x81e084(%eax),%edx
  803e70:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803e73:	89 02                	mov    %eax,(%edx)
  803e75:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803e78:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803e7e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803e81:	c1 e0 04             	shl    $0x4,%eax
  803e84:	05 8c e0 81 00       	add    $0x81e08c,%eax
  803e89:	8b 00                	mov    (%eax),%eax
  803e8b:	8d 50 01             	lea    0x1(%eax),%edx
  803e8e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803e91:	c1 e0 04             	shl    $0x4,%eax
  803e94:	05 8c e0 81 00       	add    $0x81e08c,%eax
  803e99:	89 10                	mov    %edx,(%eax)

		pageBlockInfoArr[page_index].block_size = size;
		int num_blocks = PAGE_SIZE / size ;
		pageBlockInfoArr[page_index].num_of_free_blocks= num_blocks - 1 ;

		for(int i=1; i< num_blocks; i++){
  803e9b:	ff 45 f0             	incl   -0x10(%ebp)
  803e9e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803ea1:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  803ea4:	0f 8c 4a ff ff ff    	jl     803df4 <alloc_block+0x29f>
			struct BlockElement *new_block = (struct BlockElement*)(page_va + i *size);
			LIST_INSERT_TAIL(&freeBlockLists[list_index], new_block);
		}
		return(void*)page_va;
  803eaa:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803ead:	e9 3d 01 00 00       	jmp    803fef <alloc_block+0x49a>
	}


	for(int i =list_index+1; i<= LOG2_MAX_SIZE - LOG2_MIN_SIZE; i++){
  803eb2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803eb5:	40                   	inc    %eax
  803eb6:	89 45 ec             	mov    %eax,-0x14(%ebp)
  803eb9:	e9 10 01 00 00       	jmp    803fce <alloc_block+0x479>

		if(!LIST_EMPTY(&freeBlockLists[i])){
  803ebe:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803ec1:	c1 e0 04             	shl    $0x4,%eax
  803ec4:	05 80 e0 81 00       	add    $0x81e080,%eax
  803ec9:	8b 00                	mov    (%eax),%eax
  803ecb:	85 c0                	test   %eax,%eax
  803ecd:	0f 84 f8 00 00 00    	je     803fcb <alloc_block+0x476>

			struct BlockElement *block = LIST_FIRST(&freeBlockLists[i]);
  803ed3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803ed6:	c1 e0 04             	shl    $0x4,%eax
  803ed9:	05 80 e0 81 00       	add    $0x81e080,%eax
  803ede:	8b 00                	mov    (%eax),%eax
  803ee0:	89 45 c8             	mov    %eax,-0x38(%ebp)
			LIST_REMOVE( &freeBlockLists[i], block);
  803ee3:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  803ee7:	75 17                	jne    803f00 <alloc_block+0x3ab>
  803ee9:	83 ec 04             	sub    $0x4,%esp
  803eec:	68 6d 53 80 00       	push   $0x80536d
  803ef1:	68 a8 00 00 00       	push   $0xa8
  803ef6:	68 33 53 80 00       	push   $0x805333
  803efb:	e8 42 c9 ff ff       	call   800842 <_panic>
  803f00:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803f03:	8b 00                	mov    (%eax),%eax
  803f05:	85 c0                	test   %eax,%eax
  803f07:	74 10                	je     803f19 <alloc_block+0x3c4>
  803f09:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803f0c:	8b 00                	mov    (%eax),%eax
  803f0e:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803f11:	8b 52 04             	mov    0x4(%edx),%edx
  803f14:	89 50 04             	mov    %edx,0x4(%eax)
  803f17:	eb 14                	jmp    803f2d <alloc_block+0x3d8>
  803f19:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803f1c:	8b 40 04             	mov    0x4(%eax),%eax
  803f1f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803f22:	c1 e2 04             	shl    $0x4,%edx
  803f25:	81 c2 84 e0 81 00    	add    $0x81e084,%edx
  803f2b:	89 02                	mov    %eax,(%edx)
  803f2d:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803f30:	8b 40 04             	mov    0x4(%eax),%eax
  803f33:	85 c0                	test   %eax,%eax
  803f35:	74 0f                	je     803f46 <alloc_block+0x3f1>
  803f37:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803f3a:	8b 40 04             	mov    0x4(%eax),%eax
  803f3d:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803f40:	8b 12                	mov    (%edx),%edx
  803f42:	89 10                	mov    %edx,(%eax)
  803f44:	eb 13                	jmp    803f59 <alloc_block+0x404>
  803f46:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803f49:	8b 00                	mov    (%eax),%eax
  803f4b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803f4e:	c1 e2 04             	shl    $0x4,%edx
  803f51:	81 c2 80 e0 81 00    	add    $0x81e080,%edx
  803f57:	89 02                	mov    %eax,(%edx)
  803f59:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803f5c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803f62:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803f65:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803f6c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803f6f:	c1 e0 04             	shl    $0x4,%eax
  803f72:	05 8c e0 81 00       	add    $0x81e08c,%eax
  803f77:	8b 00                	mov    (%eax),%eax
  803f79:	8d 50 ff             	lea    -0x1(%eax),%edx
  803f7c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803f7f:	c1 e0 04             	shl    $0x4,%eax
  803f82:	05 8c e0 81 00       	add    $0x81e08c,%eax
  803f87:	89 10                	mov    %edx,(%eax)

			uint32 page_index = ((uint32)block - dynAllocStart)/ PAGE_SIZE;
  803f89:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803f8c:	a1 64 e0 81 00       	mov    0x81e064,%eax
  803f91:	29 c2                	sub    %eax,%edx
  803f93:	89 d0                	mov    %edx,%eax
  803f95:	c1 e8 0c             	shr    $0xc,%eax
  803f98:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			pageBlockInfoArr[page_index].num_of_free_blocks-- ;
  803f9b:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  803f9e:	89 d0                	mov    %edx,%eax
  803fa0:	01 c0                	add    %eax,%eax
  803fa2:	01 d0                	add    %edx,%eax
  803fa4:	c1 e0 02             	shl    $0x2,%eax
  803fa7:	05 6a 60 80 00       	add    $0x80606a,%eax
  803fac:	66 8b 00             	mov    (%eax),%ax
  803faf:	8d 50 ff             	lea    -0x1(%eax),%edx
  803fb2:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  803fb5:	89 c8                	mov    %ecx,%eax
  803fb7:	01 c0                	add    %eax,%eax
  803fb9:	01 c8                	add    %ecx,%eax
  803fbb:	c1 e0 02             	shl    $0x2,%eax
  803fbe:	05 6a 60 80 00       	add    $0x80606a,%eax
  803fc3:	66 89 10             	mov    %dx,(%eax)

			return (void*)block;
  803fc6:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803fc9:	eb 24                	jmp    803fef <alloc_block+0x49a>
		}
		return(void*)page_va;
	}


	for(int i =list_index+1; i<= LOG2_MAX_SIZE - LOG2_MIN_SIZE; i++){
  803fcb:	ff 45 ec             	incl   -0x14(%ebp)
  803fce:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  803fd2:	0f 8e e6 fe ff ff    	jle    803ebe <alloc_block+0x369>

			return (void*)block;
		}
	}

	panic("alloc_block: out of memory! ");
  803fd8:	83 ec 04             	sub    $0x4,%esp
  803fdb:	68 af 53 80 00       	push   $0x8053af
  803fe0:	68 b1 00 00 00       	push   $0xb1
  803fe5:	68 33 53 80 00       	push   $0x805333
  803fea:	e8 53 c8 ff ff       	call   800842 <_panic>

	//Comment the following line
	//panic("alloc_block() Not implemented yet");

	//TODO: [PROJECT'25.BONUS#1] DYNAMIC ALLOCATOR - block if no free block
}
  803fef:	c9                   	leave  
  803ff0:	c3                   	ret    

00803ff1 <free_block>:

//===========================
// [4] FREE BLOCK:
//===========================
void free_block(void *va)
{
  803ff1:	55                   	push   %ebp
  803ff2:	89 e5                	mov    %esp,%ebp
  803ff4:	83 ec 38             	sub    $0x38,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert((uint32)va >= dynAllocStart && (uint32)va < dynAllocEnd);
  803ff7:	8b 55 08             	mov    0x8(%ebp),%edx
  803ffa:	a1 64 e0 81 00       	mov    0x81e064,%eax
  803fff:	39 c2                	cmp    %eax,%edx
  804001:	72 0c                	jb     80400f <free_block+0x1e>
  804003:	8b 55 08             	mov    0x8(%ebp),%edx
  804006:	a1 40 60 80 00       	mov    0x806040,%eax
  80400b:	39 c2                	cmp    %eax,%edx
  80400d:	72 19                	jb     804028 <free_block+0x37>
  80400f:	68 cc 53 80 00       	push   $0x8053cc
  804014:	68 1e 53 80 00       	push   $0x80531e
  804019:	68 c3 00 00 00       	push   $0xc3
  80401e:	68 33 53 80 00       	push   $0x805333
  804023:	e8 1a c8 ff ff       	call   800842 <_panic>
	//==================================================================================

	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #4 free_block
	//Your code is here

	uint32 page_index=((uint32)va - dynAllocStart)/ PAGE_SIZE;
  804028:	8b 55 08             	mov    0x8(%ebp),%edx
  80402b:	a1 64 e0 81 00       	mov    0x81e064,%eax
  804030:	29 c2                	sub    %eax,%edx
  804032:	89 d0                	mov    %edx,%eax
  804034:	c1 e8 0c             	shr    $0xc,%eax
  804037:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 block_size = pageBlockInfoArr[page_index].block_size;
  80403a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80403d:	89 d0                	mov    %edx,%eax
  80403f:	01 c0                	add    %eax,%eax
  804041:	01 d0                	add    %edx,%eax
  804043:	c1 e0 02             	shl    $0x2,%eax
  804046:	05 68 60 80 00       	add    $0x806068,%eax
  80404b:	8b 00                	mov    (%eax),%eax
  80404d:	0f b7 c0             	movzwl %ax,%eax
  804050:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if(block_size == 0){
  804053:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  804057:	75 17                	jne    804070 <free_block+0x7f>
		panic("page is empty(already not allocated)");
  804059:	83 ec 04             	sub    $0x4,%esp
  80405c:	68 04 54 80 00       	push   $0x805404
  804061:	68 cf 00 00 00       	push   $0xcf
  804066:	68 33 53 80 00       	push   $0x805333
  80406b:	e8 d2 c7 ff ff       	call   800842 <_panic>
	}

	int list_index = log2(block_size) - LOG2_MIN_SIZE;
  804070:	83 ec 0c             	sub    $0xc,%esp
  804073:	ff 75 ec             	pushl  -0x14(%ebp)
  804076:	e8 d8 f8 ff ff       	call   803953 <log2>
  80407b:	83 c4 10             	add    $0x10,%esp
  80407e:	83 e8 03             	sub    $0x3,%eax
  804081:	89 45 e8             	mov    %eax,-0x18(%ebp)
	// mn va l block "elta7weel mn virtual l phy hna"
	struct BlockElement *block = (struct BlockElement *)va;
  804084:	8b 45 08             	mov    0x8(%ebp),%eax
  804087:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	LIST_INSERT_TAIL(&freeBlockLists[list_index], block);
  80408a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80408e:	75 17                	jne    8040a7 <free_block+0xb6>
  804090:	83 ec 04             	sub    $0x4,%esp
  804093:	68 8c 53 80 00       	push   $0x80538c
  804098:	68 d5 00 00 00       	push   $0xd5
  80409d:	68 33 53 80 00       	push   $0x805333
  8040a2:	e8 9b c7 ff ff       	call   800842 <_panic>
  8040a7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8040aa:	c1 e0 04             	shl    $0x4,%eax
  8040ad:	05 84 e0 81 00       	add    $0x81e084,%eax
  8040b2:	8b 10                	mov    (%eax),%edx
  8040b4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8040b7:	89 50 04             	mov    %edx,0x4(%eax)
  8040ba:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8040bd:	8b 40 04             	mov    0x4(%eax),%eax
  8040c0:	85 c0                	test   %eax,%eax
  8040c2:	74 14                	je     8040d8 <free_block+0xe7>
  8040c4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8040c7:	c1 e0 04             	shl    $0x4,%eax
  8040ca:	05 84 e0 81 00       	add    $0x81e084,%eax
  8040cf:	8b 00                	mov    (%eax),%eax
  8040d1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8040d4:	89 10                	mov    %edx,(%eax)
  8040d6:	eb 11                	jmp    8040e9 <free_block+0xf8>
  8040d8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8040db:	c1 e0 04             	shl    $0x4,%eax
  8040de:	8d 90 80 e0 81 00    	lea    0x81e080(%eax),%edx
  8040e4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8040e7:	89 02                	mov    %eax,(%edx)
  8040e9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8040ec:	c1 e0 04             	shl    $0x4,%eax
  8040ef:	8d 90 84 e0 81 00    	lea    0x81e084(%eax),%edx
  8040f5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8040f8:	89 02                	mov    %eax,(%edx)
  8040fa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8040fd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  804103:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804106:	c1 e0 04             	shl    $0x4,%eax
  804109:	05 8c e0 81 00       	add    $0x81e08c,%eax
  80410e:	8b 00                	mov    (%eax),%eax
  804110:	8d 50 01             	lea    0x1(%eax),%edx
  804113:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804116:	c1 e0 04             	shl    $0x4,%eax
  804119:	05 8c e0 81 00       	add    $0x81e08c,%eax
  80411e:	89 10                	mov    %edx,(%eax)
	// b3d ma wdytha fy el freeBlockLists hzwed elfree elly fy el array 1
	pageBlockInfoArr[page_index].num_of_free_blocks++;
  804120:	8b 55 f0             	mov    -0x10(%ebp),%edx
  804123:	89 d0                	mov    %edx,%eax
  804125:	01 c0                	add    %eax,%eax
  804127:	01 d0                	add    %edx,%eax
  804129:	c1 e0 02             	shl    $0x2,%eax
  80412c:	05 6a 60 80 00       	add    $0x80606a,%eax
  804131:	66 8b 00             	mov    (%eax),%ax
  804134:	8d 50 01             	lea    0x1(%eax),%edx
  804137:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80413a:	89 c8                	mov    %ecx,%eax
  80413c:	01 c0                	add    %eax,%eax
  80413e:	01 c8                	add    %ecx,%eax
  804140:	c1 e0 02             	shl    $0x2,%eax
  804143:	05 6a 60 80 00       	add    $0x80606a,%eax
  804148:	66 89 10             	mov    %dx,(%eax)
	int blocks_number = PAGE_SIZE / block_size;
  80414b:	b8 00 10 00 00       	mov    $0x1000,%eax
  804150:	ba 00 00 00 00       	mov    $0x0,%edx
  804155:	f7 75 ec             	divl   -0x14(%ebp)
  804158:	89 45 e0             	mov    %eax,-0x20(%ebp)
	if(pageBlockInfoArr[page_index].num_of_free_blocks == blocks_number){
  80415b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80415e:	89 d0                	mov    %edx,%eax
  804160:	01 c0                	add    %eax,%eax
  804162:	01 d0                	add    %edx,%eax
  804164:	c1 e0 02             	shl    $0x2,%eax
  804167:	05 6a 60 80 00       	add    $0x80606a,%eax
  80416c:	66 8b 00             	mov    (%eax),%ax
  80416f:	0f b7 c0             	movzwl %ax,%eax
  804172:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  804175:	0f 85 d3 01 00 00    	jne    80434e <free_block+0x35d>
		struct BlockElement *itr = LIST_FIRST(&freeBlockLists[list_index]);
  80417b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80417e:	c1 e0 04             	shl    $0x4,%eax
  804181:	05 80 e0 81 00       	add    $0x81e080,%eax
  804186:	8b 00                	mov    (%eax),%eax
  804188:	89 45 f4             	mov    %eax,-0xc(%ebp)
		while(itr != NULL){
  80418b:	e9 f1 00 00 00       	jmp    804281 <free_block+0x290>
			//lw ms7to el pointer mydy34 ->
			struct BlockElement *next = LIST_NEXT(itr);
  804190:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804193:	8b 00                	mov    (%eax),%eax
  804195:	89 45 dc             	mov    %eax,-0x24(%ebp)
			uint32 page_beginning_address= dynAllocStart + page_index * PAGE_SIZE;
  804198:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80419b:	c1 e0 0c             	shl    $0xc,%eax
  80419e:	89 c2                	mov    %eax,%edx
  8041a0:	a1 64 e0 81 00       	mov    0x81e064,%eax
  8041a5:	01 d0                	add    %edx,%eax
  8041a7:	89 45 d8             	mov    %eax,-0x28(%ebp)
			uint32 page_end_address = dynAllocStart + (page_index +1 )* PAGE_SIZE;
  8041aa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8041ad:	40                   	inc    %eax
  8041ae:	c1 e0 0c             	shl    $0xc,%eax
  8041b1:	89 c2                	mov    %eax,%edx
  8041b3:	a1 64 e0 81 00       	mov    0x81e064,%eax
  8041b8:	01 d0                	add    %edx,%eax
  8041ba:	89 45 d4             	mov    %eax,-0x2c(%ebp)

			if((uint32)itr >= page_beginning_address && (uint32)itr < page_end_address){
  8041bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8041c0:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  8041c3:	0f 82 b8 00 00 00    	jb     804281 <free_block+0x290>
  8041c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8041cc:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8041cf:	0f 83 ac 00 00 00    	jae    804281 <free_block+0x290>
				LIST_REMOVE(&freeBlockLists[list_index], itr);
  8041d5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8041d9:	75 17                	jne    8041f2 <free_block+0x201>
  8041db:	83 ec 04             	sub    $0x4,%esp
  8041de:	68 6d 53 80 00       	push   $0x80536d
  8041e3:	68 e2 00 00 00       	push   $0xe2
  8041e8:	68 33 53 80 00       	push   $0x805333
  8041ed:	e8 50 c6 ff ff       	call   800842 <_panic>
  8041f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8041f5:	8b 00                	mov    (%eax),%eax
  8041f7:	85 c0                	test   %eax,%eax
  8041f9:	74 10                	je     80420b <free_block+0x21a>
  8041fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8041fe:	8b 00                	mov    (%eax),%eax
  804200:	8b 55 f4             	mov    -0xc(%ebp),%edx
  804203:	8b 52 04             	mov    0x4(%edx),%edx
  804206:	89 50 04             	mov    %edx,0x4(%eax)
  804209:	eb 14                	jmp    80421f <free_block+0x22e>
  80420b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80420e:	8b 40 04             	mov    0x4(%eax),%eax
  804211:	8b 55 e8             	mov    -0x18(%ebp),%edx
  804214:	c1 e2 04             	shl    $0x4,%edx
  804217:	81 c2 84 e0 81 00    	add    $0x81e084,%edx
  80421d:	89 02                	mov    %eax,(%edx)
  80421f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804222:	8b 40 04             	mov    0x4(%eax),%eax
  804225:	85 c0                	test   %eax,%eax
  804227:	74 0f                	je     804238 <free_block+0x247>
  804229:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80422c:	8b 40 04             	mov    0x4(%eax),%eax
  80422f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  804232:	8b 12                	mov    (%edx),%edx
  804234:	89 10                	mov    %edx,(%eax)
  804236:	eb 13                	jmp    80424b <free_block+0x25a>
  804238:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80423b:	8b 00                	mov    (%eax),%eax
  80423d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  804240:	c1 e2 04             	shl    $0x4,%edx
  804243:	81 c2 80 e0 81 00    	add    $0x81e080,%edx
  804249:	89 02                	mov    %eax,(%edx)
  80424b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80424e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  804254:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804257:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80425e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804261:	c1 e0 04             	shl    $0x4,%eax
  804264:	05 8c e0 81 00       	add    $0x81e08c,%eax
  804269:	8b 00                	mov    (%eax),%eax
  80426b:	8d 50 ff             	lea    -0x1(%eax),%edx
  80426e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804271:	c1 e0 04             	shl    $0x4,%eax
  804274:	05 8c e0 81 00       	add    $0x81e08c,%eax
  804279:	89 10                	mov    %edx,(%eax)
				//y5o4 3la elly b3do
				itr = next;
  80427b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80427e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// b3d ma wdytha fy el freeBlockLists hzwed elfree elly fy el array 1
	pageBlockInfoArr[page_index].num_of_free_blocks++;
	int blocks_number = PAGE_SIZE / block_size;
	if(pageBlockInfoArr[page_index].num_of_free_blocks == blocks_number){
		struct BlockElement *itr = LIST_FIRST(&freeBlockLists[list_index]);
		while(itr != NULL){
  804281:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  804285:	0f 85 05 ff ff ff    	jne    804190 <free_block+0x19f>
				LIST_REMOVE(&freeBlockLists[list_index], itr);
				//y5o4 3la elly b3do
				itr = next;
			}
		}
		pageBlockInfoArr[page_index].block_size=0;
  80428b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80428e:	89 d0                	mov    %edx,%eax
  804290:	01 c0                	add    %eax,%eax
  804292:	01 d0                	add    %edx,%eax
  804294:	c1 e0 02             	shl    $0x2,%eax
  804297:	05 68 60 80 00       	add    $0x806068,%eax
  80429c:	66 c7 00 00 00       	movw   $0x0,(%eax)
		pageBlockInfoArr[page_index].num_of_free_blocks=0;
  8042a1:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8042a4:	89 d0                	mov    %edx,%eax
  8042a6:	01 c0                	add    %eax,%eax
  8042a8:	01 d0                	add    %edx,%eax
  8042aa:	c1 e0 02             	shl    $0x2,%eax
  8042ad:	05 6a 60 80 00       	add    $0x80606a,%eax
  8042b2:	66 c7 00 00 00       	movw   $0x0,(%eax)

		struct PageInfoElement *page_info = &pageBlockInfoArr[page_index];
  8042b7:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8042ba:	89 d0                	mov    %edx,%eax
  8042bc:	01 c0                	add    %eax,%eax
  8042be:	01 d0                	add    %edx,%eax
  8042c0:	c1 e0 02             	shl    $0x2,%eax
  8042c3:	05 60 60 80 00       	add    $0x806060,%eax
  8042c8:	89 45 d0             	mov    %eax,-0x30(%ebp)
		LIST_INSERT_TAIL(&freePagesList, page_info);
  8042cb:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  8042cf:	75 17                	jne    8042e8 <free_block+0x2f7>
  8042d1:	83 ec 04             	sub    $0x4,%esp
  8042d4:	68 8c 53 80 00       	push   $0x80538c
  8042d9:	68 eb 00 00 00       	push   $0xeb
  8042de:	68 33 53 80 00       	push   $0x805333
  8042e3:	e8 5a c5 ff ff       	call   800842 <_panic>
  8042e8:	8b 15 4c 60 80 00    	mov    0x80604c,%edx
  8042ee:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8042f1:	89 50 04             	mov    %edx,0x4(%eax)
  8042f4:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8042f7:	8b 40 04             	mov    0x4(%eax),%eax
  8042fa:	85 c0                	test   %eax,%eax
  8042fc:	74 0c                	je     80430a <free_block+0x319>
  8042fe:	a1 4c 60 80 00       	mov    0x80604c,%eax
  804303:	8b 55 d0             	mov    -0x30(%ebp),%edx
  804306:	89 10                	mov    %edx,(%eax)
  804308:	eb 08                	jmp    804312 <free_block+0x321>
  80430a:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80430d:	a3 48 60 80 00       	mov    %eax,0x806048
  804312:	8b 45 d0             	mov    -0x30(%ebp),%eax
  804315:	a3 4c 60 80 00       	mov    %eax,0x80604c
  80431a:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80431d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  804323:	a1 54 60 80 00       	mov    0x806054,%eax
  804328:	40                   	inc    %eax
  804329:	a3 54 60 80 00       	mov    %eax,0x806054
		uint32 page_va = to_page_va(page_info);
  80432e:	83 ec 0c             	sub    $0xc,%esp
  804331:	ff 75 d0             	pushl  -0x30(%ebp)
  804334:	e8 ce f5 ff ff       	call   803907 <to_page_va>
  804339:	83 c4 10             	add    $0x10,%esp
  80433c:	89 45 cc             	mov    %eax,-0x34(%ebp)
		return_page((void *)page_va);
  80433f:	8b 45 cc             	mov    -0x34(%ebp),%eax
  804342:	83 ec 0c             	sub    $0xc,%esp
  804345:	50                   	push   %eax
  804346:	e8 9e d7 ff ff       	call   801ae9 <return_page>
  80434b:	83 c4 10             	add    $0x10,%esp
	}


	//Comment the following line
	//panic("free_block() Not implemented yet");
}
  80434e:	90                   	nop
  80434f:	c9                   	leave  
  804350:	c3                   	ret    

00804351 <realloc_block>:

//===========================
// [1] REALLOCATE BLOCK:
//===========================
void *realloc_block(void* va, uint32 new_size)
{
  804351:	55                   	push   %ebp
  804352:	89 e5                	mov    %esp,%ebp
  804354:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.BONUS#2] KERNEL REALLOC - realloc_block
	//Your code is here
	//Comment the following line
	panic("realloc_block() Not implemented yet");
  804357:	83 ec 04             	sub    $0x4,%esp
  80435a:	68 2c 54 80 00       	push   $0x80542c
  80435f:	68 01 01 00 00       	push   $0x101
  804364:	68 33 53 80 00       	push   $0x805333
  804369:	e8 d4 c4 ff ff       	call   800842 <_panic>

0080436e <init_uspinlock>:
#include "inc/uspinlock.h"

extern volatile struct Env *myEnv;

void init_uspinlock(struct uspinlock *lk, char *name, bool isOpened)
{
  80436e:	55                   	push   %ebp
  80436f:	89 e5                	mov    %esp,%ebp
  804371:	83 ec 08             	sub    $0x8,%esp
	assert(isOpened == 0 || isOpened == 1);
  804374:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  804378:	74 1c                	je     804396 <init_uspinlock+0x28>
  80437a:	83 7d 10 01          	cmpl   $0x1,0x10(%ebp)
  80437e:	74 16                	je     804396 <init_uspinlock+0x28>
  804380:	68 50 54 80 00       	push   $0x805450
  804385:	68 6f 54 80 00       	push   $0x80546f
  80438a:	6a 10                	push   $0x10
  80438c:	68 84 54 80 00       	push   $0x805484
  804391:	e8 ac c4 ff ff       	call   800842 <_panic>
	strcpy(lk->name, name);
  804396:	8b 45 08             	mov    0x8(%ebp),%eax
  804399:	83 c0 04             	add    $0x4,%eax
  80439c:	83 ec 08             	sub    $0x8,%esp
  80439f:	ff 75 0c             	pushl  0xc(%ebp)
  8043a2:	50                   	push   %eax
  8043a3:	e8 90 ce ff ff       	call   801238 <strcpy>
  8043a8:	83 c4 10             	add    $0x10,%esp
	lk->locked = (1 - isOpened);
  8043ab:	b8 01 00 00 00       	mov    $0x1,%eax
  8043b0:	2b 45 10             	sub    0x10(%ebp),%eax
  8043b3:	89 c2                	mov    %eax,%edx
  8043b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8043b8:	89 10                	mov    %edx,(%eax)
}
  8043ba:	90                   	nop
  8043bb:	c9                   	leave  
  8043bc:	c3                   	ret    

008043bd <acquire_uspinlock>:
// Acquire the lock.
// Loops (spins) until the lock is acquired.
// Holding a lock for a long time may cause
// other CPUs to waste time spinning to acquire it.
void acquire_uspinlock(struct uspinlock *lk)
{
  8043bd:	55                   	push   %ebp
  8043be:	89 e5                	mov    %esp,%ebp
  8043c0:	83 ec 18             	sub    $0x18,%esp
	// The xchg is atomic.
	while(xchg(&lk->locked, 1) != 0) ;
  8043c3:	90                   	nop
  8043c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8043c7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8043ca:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
xchg(volatile uint32 *addr, uint32 newval)
{
  uint32 result;

  // The + in "+m" denotes a read-modify-write operand.
  __asm __volatile("lock; xchgl %0, %1" :
  8043d1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8043d4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8043d7:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  8043da:	f0 87 02             	lock xchg %eax,(%edx)
  8043dd:	89 45 ec             	mov    %eax,-0x14(%ebp)
               "+m" (*addr), "=a" (result) :
               "1" (newval) :
               "cc");
  return result;
  8043e0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8043e3:	85 c0                	test   %eax,%eax
  8043e5:	75 dd                	jne    8043c4 <acquire_uspinlock+0x7>

	cprintf("[%d: %s] ACQUIRED spinlock [%s]\n", myEnv->env_id, myEnv->prog_name, lk->name);
  8043e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8043ea:	8d 48 04             	lea    0x4(%eax),%ecx
  8043ed:	a1 20 60 80 00       	mov    0x806020,%eax
  8043f2:	8d 50 20             	lea    0x20(%eax),%edx
  8043f5:	a1 20 60 80 00       	mov    0x806020,%eax
  8043fa:	8b 40 10             	mov    0x10(%eax),%eax
  8043fd:	51                   	push   %ecx
  8043fe:	52                   	push   %edx
  8043ff:	50                   	push   %eax
  804400:	68 94 54 80 00       	push   $0x805494
  804405:	e8 06 c7 ff ff       	call   800b10 <cprintf>
  80440a:	83 c4 10             	add    $0x10,%esp

	// Tell the C compiler and the processor to not move loads or stores
	// past this point, to ensure that the critical section's memory
	// references happen after the lock is acquired.
	__sync_synchronize();
  80440d:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
}
  804412:	90                   	nop
  804413:	c9                   	leave  
  804414:	c3                   	ret    

00804415 <release_uspinlock>:

// Release the lock.
void release_uspinlock(struct uspinlock *lk)
{
  804415:	55                   	push   %ebp
  804416:	89 e5                	mov    %esp,%ebp
  804418:	83 ec 08             	sub    $0x8,%esp
	if(!(lk->locked))
  80441b:	8b 45 08             	mov    0x8(%ebp),%eax
  80441e:	8b 00                	mov    (%eax),%eax
  804420:	85 c0                	test   %eax,%eax
  804422:	75 18                	jne    80443c <release_uspinlock+0x27>
	{
		panic("release: lock \"%s\" is not held!", lk->name);
  804424:	8b 45 08             	mov    0x8(%ebp),%eax
  804427:	83 c0 04             	add    $0x4,%eax
  80442a:	50                   	push   %eax
  80442b:	68 b8 54 80 00       	push   $0x8054b8
  804430:	6a 2b                	push   $0x2b
  804432:	68 84 54 80 00       	push   $0x805484
  804437:	e8 06 c4 ff ff       	call   800842 <_panic>
	// Tell the C compiler and the processor to not move loads or stores
	// past this point, to ensure that all the stores in the critical
	// section are visible to other cores before the lock is released.
	// Both the C compiler and the hardware may re-order loads and
	// stores; __sync_synchronize() tells them both not to.
	__sync_synchronize();
  80443c:	f0 83 0c 24 00       	lock orl $0x0,(%esp)

	// Release the lock, equivalent to lk->locked = 0.
	// This code can't use a C assignment, since it might
	// not be atomic. A real OS would use C atomics here.
	asm volatile("movl $0, %0" : "+m" (lk->locked) : );
  804441:	8b 45 08             	mov    0x8(%ebp),%eax
  804444:	8b 55 08             	mov    0x8(%ebp),%edx
  804447:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	cprintf("[%d: %s] RELEASED spinlock [%s]\n", myEnv->env_id, myEnv->prog_name, lk->name);
  80444d:	8b 45 08             	mov    0x8(%ebp),%eax
  804450:	8d 48 04             	lea    0x4(%eax),%ecx
  804453:	a1 20 60 80 00       	mov    0x806020,%eax
  804458:	8d 50 20             	lea    0x20(%eax),%edx
  80445b:	a1 20 60 80 00       	mov    0x806020,%eax
  804460:	8b 40 10             	mov    0x10(%eax),%eax
  804463:	51                   	push   %ecx
  804464:	52                   	push   %edx
  804465:	50                   	push   %eax
  804466:	68 d8 54 80 00       	push   $0x8054d8
  80446b:	e8 a0 c6 ff ff       	call   800b10 <cprintf>
  804470:	83 c4 10             	add    $0x10,%esp
}
  804473:	90                   	nop
  804474:	c9                   	leave  
  804475:	c3                   	ret    
  804476:	66 90                	xchg   %ax,%ax

00804478 <__udivdi3>:
  804478:	55                   	push   %ebp
  804479:	57                   	push   %edi
  80447a:	56                   	push   %esi
  80447b:	53                   	push   %ebx
  80447c:	83 ec 1c             	sub    $0x1c,%esp
  80447f:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  804483:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  804487:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80448b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80448f:	89 ca                	mov    %ecx,%edx
  804491:	89 f8                	mov    %edi,%eax
  804493:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  804497:	85 f6                	test   %esi,%esi
  804499:	75 2d                	jne    8044c8 <__udivdi3+0x50>
  80449b:	39 cf                	cmp    %ecx,%edi
  80449d:	77 65                	ja     804504 <__udivdi3+0x8c>
  80449f:	89 fd                	mov    %edi,%ebp
  8044a1:	85 ff                	test   %edi,%edi
  8044a3:	75 0b                	jne    8044b0 <__udivdi3+0x38>
  8044a5:	b8 01 00 00 00       	mov    $0x1,%eax
  8044aa:	31 d2                	xor    %edx,%edx
  8044ac:	f7 f7                	div    %edi
  8044ae:	89 c5                	mov    %eax,%ebp
  8044b0:	31 d2                	xor    %edx,%edx
  8044b2:	89 c8                	mov    %ecx,%eax
  8044b4:	f7 f5                	div    %ebp
  8044b6:	89 c1                	mov    %eax,%ecx
  8044b8:	89 d8                	mov    %ebx,%eax
  8044ba:	f7 f5                	div    %ebp
  8044bc:	89 cf                	mov    %ecx,%edi
  8044be:	89 fa                	mov    %edi,%edx
  8044c0:	83 c4 1c             	add    $0x1c,%esp
  8044c3:	5b                   	pop    %ebx
  8044c4:	5e                   	pop    %esi
  8044c5:	5f                   	pop    %edi
  8044c6:	5d                   	pop    %ebp
  8044c7:	c3                   	ret    
  8044c8:	39 ce                	cmp    %ecx,%esi
  8044ca:	77 28                	ja     8044f4 <__udivdi3+0x7c>
  8044cc:	0f bd fe             	bsr    %esi,%edi
  8044cf:	83 f7 1f             	xor    $0x1f,%edi
  8044d2:	75 40                	jne    804514 <__udivdi3+0x9c>
  8044d4:	39 ce                	cmp    %ecx,%esi
  8044d6:	72 0a                	jb     8044e2 <__udivdi3+0x6a>
  8044d8:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8044dc:	0f 87 9e 00 00 00    	ja     804580 <__udivdi3+0x108>
  8044e2:	b8 01 00 00 00       	mov    $0x1,%eax
  8044e7:	89 fa                	mov    %edi,%edx
  8044e9:	83 c4 1c             	add    $0x1c,%esp
  8044ec:	5b                   	pop    %ebx
  8044ed:	5e                   	pop    %esi
  8044ee:	5f                   	pop    %edi
  8044ef:	5d                   	pop    %ebp
  8044f0:	c3                   	ret    
  8044f1:	8d 76 00             	lea    0x0(%esi),%esi
  8044f4:	31 ff                	xor    %edi,%edi
  8044f6:	31 c0                	xor    %eax,%eax
  8044f8:	89 fa                	mov    %edi,%edx
  8044fa:	83 c4 1c             	add    $0x1c,%esp
  8044fd:	5b                   	pop    %ebx
  8044fe:	5e                   	pop    %esi
  8044ff:	5f                   	pop    %edi
  804500:	5d                   	pop    %ebp
  804501:	c3                   	ret    
  804502:	66 90                	xchg   %ax,%ax
  804504:	89 d8                	mov    %ebx,%eax
  804506:	f7 f7                	div    %edi
  804508:	31 ff                	xor    %edi,%edi
  80450a:	89 fa                	mov    %edi,%edx
  80450c:	83 c4 1c             	add    $0x1c,%esp
  80450f:	5b                   	pop    %ebx
  804510:	5e                   	pop    %esi
  804511:	5f                   	pop    %edi
  804512:	5d                   	pop    %ebp
  804513:	c3                   	ret    
  804514:	bd 20 00 00 00       	mov    $0x20,%ebp
  804519:	89 eb                	mov    %ebp,%ebx
  80451b:	29 fb                	sub    %edi,%ebx
  80451d:	89 f9                	mov    %edi,%ecx
  80451f:	d3 e6                	shl    %cl,%esi
  804521:	89 c5                	mov    %eax,%ebp
  804523:	88 d9                	mov    %bl,%cl
  804525:	d3 ed                	shr    %cl,%ebp
  804527:	89 e9                	mov    %ebp,%ecx
  804529:	09 f1                	or     %esi,%ecx
  80452b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80452f:	89 f9                	mov    %edi,%ecx
  804531:	d3 e0                	shl    %cl,%eax
  804533:	89 c5                	mov    %eax,%ebp
  804535:	89 d6                	mov    %edx,%esi
  804537:	88 d9                	mov    %bl,%cl
  804539:	d3 ee                	shr    %cl,%esi
  80453b:	89 f9                	mov    %edi,%ecx
  80453d:	d3 e2                	shl    %cl,%edx
  80453f:	8b 44 24 08          	mov    0x8(%esp),%eax
  804543:	88 d9                	mov    %bl,%cl
  804545:	d3 e8                	shr    %cl,%eax
  804547:	09 c2                	or     %eax,%edx
  804549:	89 d0                	mov    %edx,%eax
  80454b:	89 f2                	mov    %esi,%edx
  80454d:	f7 74 24 0c          	divl   0xc(%esp)
  804551:	89 d6                	mov    %edx,%esi
  804553:	89 c3                	mov    %eax,%ebx
  804555:	f7 e5                	mul    %ebp
  804557:	39 d6                	cmp    %edx,%esi
  804559:	72 19                	jb     804574 <__udivdi3+0xfc>
  80455b:	74 0b                	je     804568 <__udivdi3+0xf0>
  80455d:	89 d8                	mov    %ebx,%eax
  80455f:	31 ff                	xor    %edi,%edi
  804561:	e9 58 ff ff ff       	jmp    8044be <__udivdi3+0x46>
  804566:	66 90                	xchg   %ax,%ax
  804568:	8b 54 24 08          	mov    0x8(%esp),%edx
  80456c:	89 f9                	mov    %edi,%ecx
  80456e:	d3 e2                	shl    %cl,%edx
  804570:	39 c2                	cmp    %eax,%edx
  804572:	73 e9                	jae    80455d <__udivdi3+0xe5>
  804574:	8d 43 ff             	lea    -0x1(%ebx),%eax
  804577:	31 ff                	xor    %edi,%edi
  804579:	e9 40 ff ff ff       	jmp    8044be <__udivdi3+0x46>
  80457e:	66 90                	xchg   %ax,%ax
  804580:	31 c0                	xor    %eax,%eax
  804582:	e9 37 ff ff ff       	jmp    8044be <__udivdi3+0x46>
  804587:	90                   	nop

00804588 <__umoddi3>:
  804588:	55                   	push   %ebp
  804589:	57                   	push   %edi
  80458a:	56                   	push   %esi
  80458b:	53                   	push   %ebx
  80458c:	83 ec 1c             	sub    $0x1c,%esp
  80458f:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  804593:	8b 74 24 34          	mov    0x34(%esp),%esi
  804597:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80459b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80459f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8045a3:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8045a7:	89 f3                	mov    %esi,%ebx
  8045a9:	89 fa                	mov    %edi,%edx
  8045ab:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8045af:	89 34 24             	mov    %esi,(%esp)
  8045b2:	85 c0                	test   %eax,%eax
  8045b4:	75 1a                	jne    8045d0 <__umoddi3+0x48>
  8045b6:	39 f7                	cmp    %esi,%edi
  8045b8:	0f 86 a2 00 00 00    	jbe    804660 <__umoddi3+0xd8>
  8045be:	89 c8                	mov    %ecx,%eax
  8045c0:	89 f2                	mov    %esi,%edx
  8045c2:	f7 f7                	div    %edi
  8045c4:	89 d0                	mov    %edx,%eax
  8045c6:	31 d2                	xor    %edx,%edx
  8045c8:	83 c4 1c             	add    $0x1c,%esp
  8045cb:	5b                   	pop    %ebx
  8045cc:	5e                   	pop    %esi
  8045cd:	5f                   	pop    %edi
  8045ce:	5d                   	pop    %ebp
  8045cf:	c3                   	ret    
  8045d0:	39 f0                	cmp    %esi,%eax
  8045d2:	0f 87 ac 00 00 00    	ja     804684 <__umoddi3+0xfc>
  8045d8:	0f bd e8             	bsr    %eax,%ebp
  8045db:	83 f5 1f             	xor    $0x1f,%ebp
  8045de:	0f 84 ac 00 00 00    	je     804690 <__umoddi3+0x108>
  8045e4:	bf 20 00 00 00       	mov    $0x20,%edi
  8045e9:	29 ef                	sub    %ebp,%edi
  8045eb:	89 fe                	mov    %edi,%esi
  8045ed:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8045f1:	89 e9                	mov    %ebp,%ecx
  8045f3:	d3 e0                	shl    %cl,%eax
  8045f5:	89 d7                	mov    %edx,%edi
  8045f7:	89 f1                	mov    %esi,%ecx
  8045f9:	d3 ef                	shr    %cl,%edi
  8045fb:	09 c7                	or     %eax,%edi
  8045fd:	89 e9                	mov    %ebp,%ecx
  8045ff:	d3 e2                	shl    %cl,%edx
  804601:	89 14 24             	mov    %edx,(%esp)
  804604:	89 d8                	mov    %ebx,%eax
  804606:	d3 e0                	shl    %cl,%eax
  804608:	89 c2                	mov    %eax,%edx
  80460a:	8b 44 24 08          	mov    0x8(%esp),%eax
  80460e:	d3 e0                	shl    %cl,%eax
  804610:	89 44 24 04          	mov    %eax,0x4(%esp)
  804614:	8b 44 24 08          	mov    0x8(%esp),%eax
  804618:	89 f1                	mov    %esi,%ecx
  80461a:	d3 e8                	shr    %cl,%eax
  80461c:	09 d0                	or     %edx,%eax
  80461e:	d3 eb                	shr    %cl,%ebx
  804620:	89 da                	mov    %ebx,%edx
  804622:	f7 f7                	div    %edi
  804624:	89 d3                	mov    %edx,%ebx
  804626:	f7 24 24             	mull   (%esp)
  804629:	89 c6                	mov    %eax,%esi
  80462b:	89 d1                	mov    %edx,%ecx
  80462d:	39 d3                	cmp    %edx,%ebx
  80462f:	0f 82 87 00 00 00    	jb     8046bc <__umoddi3+0x134>
  804635:	0f 84 91 00 00 00    	je     8046cc <__umoddi3+0x144>
  80463b:	8b 54 24 04          	mov    0x4(%esp),%edx
  80463f:	29 f2                	sub    %esi,%edx
  804641:	19 cb                	sbb    %ecx,%ebx
  804643:	89 d8                	mov    %ebx,%eax
  804645:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  804649:	d3 e0                	shl    %cl,%eax
  80464b:	89 e9                	mov    %ebp,%ecx
  80464d:	d3 ea                	shr    %cl,%edx
  80464f:	09 d0                	or     %edx,%eax
  804651:	89 e9                	mov    %ebp,%ecx
  804653:	d3 eb                	shr    %cl,%ebx
  804655:	89 da                	mov    %ebx,%edx
  804657:	83 c4 1c             	add    $0x1c,%esp
  80465a:	5b                   	pop    %ebx
  80465b:	5e                   	pop    %esi
  80465c:	5f                   	pop    %edi
  80465d:	5d                   	pop    %ebp
  80465e:	c3                   	ret    
  80465f:	90                   	nop
  804660:	89 fd                	mov    %edi,%ebp
  804662:	85 ff                	test   %edi,%edi
  804664:	75 0b                	jne    804671 <__umoddi3+0xe9>
  804666:	b8 01 00 00 00       	mov    $0x1,%eax
  80466b:	31 d2                	xor    %edx,%edx
  80466d:	f7 f7                	div    %edi
  80466f:	89 c5                	mov    %eax,%ebp
  804671:	89 f0                	mov    %esi,%eax
  804673:	31 d2                	xor    %edx,%edx
  804675:	f7 f5                	div    %ebp
  804677:	89 c8                	mov    %ecx,%eax
  804679:	f7 f5                	div    %ebp
  80467b:	89 d0                	mov    %edx,%eax
  80467d:	e9 44 ff ff ff       	jmp    8045c6 <__umoddi3+0x3e>
  804682:	66 90                	xchg   %ax,%ax
  804684:	89 c8                	mov    %ecx,%eax
  804686:	89 f2                	mov    %esi,%edx
  804688:	83 c4 1c             	add    $0x1c,%esp
  80468b:	5b                   	pop    %ebx
  80468c:	5e                   	pop    %esi
  80468d:	5f                   	pop    %edi
  80468e:	5d                   	pop    %ebp
  80468f:	c3                   	ret    
  804690:	3b 04 24             	cmp    (%esp),%eax
  804693:	72 06                	jb     80469b <__umoddi3+0x113>
  804695:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  804699:	77 0f                	ja     8046aa <__umoddi3+0x122>
  80469b:	89 f2                	mov    %esi,%edx
  80469d:	29 f9                	sub    %edi,%ecx
  80469f:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8046a3:	89 14 24             	mov    %edx,(%esp)
  8046a6:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8046aa:	8b 44 24 04          	mov    0x4(%esp),%eax
  8046ae:	8b 14 24             	mov    (%esp),%edx
  8046b1:	83 c4 1c             	add    $0x1c,%esp
  8046b4:	5b                   	pop    %ebx
  8046b5:	5e                   	pop    %esi
  8046b6:	5f                   	pop    %edi
  8046b7:	5d                   	pop    %ebp
  8046b8:	c3                   	ret    
  8046b9:	8d 76 00             	lea    0x0(%esi),%esi
  8046bc:	2b 04 24             	sub    (%esp),%eax
  8046bf:	19 fa                	sbb    %edi,%edx
  8046c1:	89 d1                	mov    %edx,%ecx
  8046c3:	89 c6                	mov    %eax,%esi
  8046c5:	e9 71 ff ff ff       	jmp    80463b <__umoddi3+0xb3>
  8046ca:	66 90                	xchg   %ax,%ax
  8046cc:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8046d0:	72 ea                	jb     8046bc <__umoddi3+0x134>
  8046d2:	89 d9                	mov    %ebx,%ecx
  8046d4:	e9 62 ff ff ff       	jmp    80463b <__umoddi3+0xb3>
