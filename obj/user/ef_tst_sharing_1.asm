
obj/user/ef_tst_sharing_1:     file format elf32-i386


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
  800031:	e8 73 03 00 00       	call   8003a9 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
// Test the creation of shared variables (create_shared_memory)
#include <inc/lib.h>

void
_main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	53                   	push   %ebx
  80003c:	83 ec 34             	sub    $0x34,%esp
//#endif
//	/*=================================================*/

	uint32 *x, *y, *z ;
	uint32 expected ;
	uint32 pagealloc_start = USER_HEAP_START + DYN_ALLOC_MAX_SIZE + PAGE_SIZE; //UHS + 32MB + 4KB
  80003f:	c7 45 f0 00 10 00 82 	movl   $0x82001000,-0x10(%ebp)

	cprintf("STEP A: checking the creation of shared variables...\n");
  800046:	83 ec 0c             	sub    $0xc,%esp
  800049:	68 00 44 80 00       	push   $0x804400
  80004e:	e8 dd 07 00 00       	call   800830 <cprintf>
  800053:	83 c4 10             	add    $0x10,%esp
	{
		int freeFrames = sys_calculate_free_frames() ;
  800056:	e8 40 31 00 00       	call   80319b <sys_calculate_free_frames>
  80005b:	89 45 ec             	mov    %eax,-0x14(%ebp)
		x = smalloc("x", PAGE_SIZE, 1);
  80005e:	83 ec 04             	sub    $0x4,%esp
  800061:	6a 01                	push   $0x1
  800063:	68 00 10 00 00       	push   $0x1000
  800068:	68 36 44 80 00       	push   $0x804436
  80006d:	e8 65 24 00 00       	call   8024d7 <smalloc>
  800072:	83 c4 10             	add    $0x10,%esp
  800075:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if (x != (uint32*)pagealloc_start) {panic("Returned address is not correct. check the setting of it and/or the updating of the shared_mem_free_address");}
  800078:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80007b:	39 45 e8             	cmp    %eax,-0x18(%ebp)
  80007e:	74 14                	je     800094 <_main+0x5c>
  800080:	83 ec 04             	sub    $0x4,%esp
  800083:	68 38 44 80 00       	push   $0x804438
  800088:	6a 1a                	push   $0x1a
  80008a:	68 a4 44 80 00       	push   $0x8044a4
  80008f:	e8 ce 04 00 00       	call   800562 <_panic>
		expected = 1+1 ; /*1page +1table*/
  800094:	c7 45 e4 02 00 00 00 	movl   $0x2,-0x1c(%ebp)
		int diff = (freeFrames - sys_calculate_free_frames());
  80009b:	8b 5d ec             	mov    -0x14(%ebp),%ebx
  80009e:	e8 f8 30 00 00       	call   80319b <sys_calculate_free_frames>
  8000a3:	29 c3                	sub    %eax,%ebx
  8000a5:	89 d8                	mov    %ebx,%eax
  8000a7:	89 45 e0             	mov    %eax,-0x20(%ebp)
		if (diff < expected || diff > expected +1+1 /*extra 1 page & 1 table for sbrk (at max)*/) {panic("Wrong allocation (current=%d, expected=%d): make sure that you allocate the required space in the user environment and add its frames to frames_storage", freeFrames - sys_calculate_free_frames(), expected);}
  8000aa:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8000ad:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8000b0:	72 0d                	jb     8000bf <_main+0x87>
  8000b2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8000b5:	8d 50 02             	lea    0x2(%eax),%edx
  8000b8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8000bb:	39 c2                	cmp    %eax,%edx
  8000bd:	73 24                	jae    8000e3 <_main+0xab>
  8000bf:	8b 5d ec             	mov    -0x14(%ebp),%ebx
  8000c2:	e8 d4 30 00 00       	call   80319b <sys_calculate_free_frames>
  8000c7:	29 c3                	sub    %eax,%ebx
  8000c9:	89 d8                	mov    %ebx,%eax
  8000cb:	83 ec 0c             	sub    $0xc,%esp
  8000ce:	ff 75 e4             	pushl  -0x1c(%ebp)
  8000d1:	50                   	push   %eax
  8000d2:	68 bc 44 80 00       	push   $0x8044bc
  8000d7:	6a 1d                	push   $0x1d
  8000d9:	68 a4 44 80 00       	push   $0x8044a4
  8000de:	e8 7f 04 00 00       	call   800562 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  8000e3:	e8 b3 30 00 00       	call   80319b <sys_calculate_free_frames>
  8000e8:	89 45 ec             	mov    %eax,-0x14(%ebp)
		z = smalloc("z", PAGE_SIZE + 4, 1);
  8000eb:	83 ec 04             	sub    $0x4,%esp
  8000ee:	6a 01                	push   $0x1
  8000f0:	68 04 10 00 00       	push   $0x1004
  8000f5:	68 54 45 80 00       	push   $0x804554
  8000fa:	e8 d8 23 00 00       	call   8024d7 <smalloc>
  8000ff:	83 c4 10             	add    $0x10,%esp
  800102:	89 45 dc             	mov    %eax,-0x24(%ebp)
		if (z != (uint32*)(pagealloc_start + 1 * PAGE_SIZE)) {panic("Returned address is not correct. check the setting of it and/or the updating of the shared_mem_free_address");}
  800105:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800108:	05 00 10 00 00       	add    $0x1000,%eax
  80010d:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800110:	74 14                	je     800126 <_main+0xee>
  800112:	83 ec 04             	sub    $0x4,%esp
  800115:	68 38 44 80 00       	push   $0x804438
  80011a:	6a 21                	push   $0x21
  80011c:	68 a4 44 80 00       	push   $0x8044a4
  800121:	e8 3c 04 00 00       	call   800562 <_panic>
		expected = 2 ; /*2pages*/
  800126:	c7 45 e4 02 00 00 00 	movl   $0x2,-0x1c(%ebp)
		diff = (freeFrames - sys_calculate_free_frames());
  80012d:	8b 5d ec             	mov    -0x14(%ebp),%ebx
  800130:	e8 66 30 00 00       	call   80319b <sys_calculate_free_frames>
  800135:	29 c3                	sub    %eax,%ebx
  800137:	89 d8                	mov    %ebx,%eax
  800139:	89 45 e0             	mov    %eax,-0x20(%ebp)
		if (diff < expected || diff > expected +1+1 /*extra 1 page & 1 table for sbrk (at max)*/) {panic("Wrong allocation (current=%d, expected=%d): make sure that you allocate the required space in the user environment and add its frames to frames_storage", freeFrames - sys_calculate_free_frames(), expected);}
  80013c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80013f:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800142:	72 0d                	jb     800151 <_main+0x119>
  800144:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800147:	8d 50 02             	lea    0x2(%eax),%edx
  80014a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80014d:	39 c2                	cmp    %eax,%edx
  80014f:	73 24                	jae    800175 <_main+0x13d>
  800151:	8b 5d ec             	mov    -0x14(%ebp),%ebx
  800154:	e8 42 30 00 00       	call   80319b <sys_calculate_free_frames>
  800159:	29 c3                	sub    %eax,%ebx
  80015b:	89 d8                	mov    %ebx,%eax
  80015d:	83 ec 0c             	sub    $0xc,%esp
  800160:	ff 75 e4             	pushl  -0x1c(%ebp)
  800163:	50                   	push   %eax
  800164:	68 bc 44 80 00       	push   $0x8044bc
  800169:	6a 24                	push   $0x24
  80016b:	68 a4 44 80 00       	push   $0x8044a4
  800170:	e8 ed 03 00 00       	call   800562 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  800175:	e8 21 30 00 00       	call   80319b <sys_calculate_free_frames>
  80017a:	89 45 ec             	mov    %eax,-0x14(%ebp)
		y = smalloc("y", 4, 1);
  80017d:	83 ec 04             	sub    $0x4,%esp
  800180:	6a 01                	push   $0x1
  800182:	6a 04                	push   $0x4
  800184:	68 56 45 80 00       	push   $0x804556
  800189:	e8 49 23 00 00       	call   8024d7 <smalloc>
  80018e:	83 c4 10             	add    $0x10,%esp
  800191:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if (y != (uint32*)(pagealloc_start + 3 * PAGE_SIZE)) {panic("Returned address is not correct. check the setting of it and/or the updating of the shared_mem_free_address");}
  800194:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800197:	05 00 30 00 00       	add    $0x3000,%eax
  80019c:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  80019f:	74 14                	je     8001b5 <_main+0x17d>
  8001a1:	83 ec 04             	sub    $0x4,%esp
  8001a4:	68 38 44 80 00       	push   $0x804438
  8001a9:	6a 28                	push   $0x28
  8001ab:	68 a4 44 80 00       	push   $0x8044a4
  8001b0:	e8 ad 03 00 00       	call   800562 <_panic>
		expected = 1 ; /*1page*/
  8001b5:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
		diff = (freeFrames - sys_calculate_free_frames());
  8001bc:	8b 5d ec             	mov    -0x14(%ebp),%ebx
  8001bf:	e8 d7 2f 00 00       	call   80319b <sys_calculate_free_frames>
  8001c4:	29 c3                	sub    %eax,%ebx
  8001c6:	89 d8                	mov    %ebx,%eax
  8001c8:	89 45 e0             	mov    %eax,-0x20(%ebp)
		if (diff < expected || diff > expected +1+1 /*extra 1 page & 1 table for sbrk (at max)*/) {panic("Wrong allocation (current=%d, expected=%d): make sure that you allocate the required space in the user environment and add its frames to frames_storage", freeFrames - sys_calculate_free_frames(), expected);}
  8001cb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8001ce:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8001d1:	72 0d                	jb     8001e0 <_main+0x1a8>
  8001d3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8001d6:	8d 50 02             	lea    0x2(%eax),%edx
  8001d9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8001dc:	39 c2                	cmp    %eax,%edx
  8001de:	73 24                	jae    800204 <_main+0x1cc>
  8001e0:	8b 5d ec             	mov    -0x14(%ebp),%ebx
  8001e3:	e8 b3 2f 00 00       	call   80319b <sys_calculate_free_frames>
  8001e8:	29 c3                	sub    %eax,%ebx
  8001ea:	89 d8                	mov    %ebx,%eax
  8001ec:	83 ec 0c             	sub    $0xc,%esp
  8001ef:	ff 75 e4             	pushl  -0x1c(%ebp)
  8001f2:	50                   	push   %eax
  8001f3:	68 bc 44 80 00       	push   $0x8044bc
  8001f8:	6a 2b                	push   $0x2b
  8001fa:	68 a4 44 80 00       	push   $0x8044a4
  8001ff:	e8 5e 03 00 00       	call   800562 <_panic>
	}
	cprintf("Step A is finished!!\n\n\n");
  800204:	83 ec 0c             	sub    $0xc,%esp
  800207:	68 58 45 80 00       	push   $0x804558
  80020c:	e8 1f 06 00 00       	call   800830 <cprintf>
  800211:	83 c4 10             	add    $0x10,%esp


	cprintf("STEP B: checking reading & writing... \n");
  800214:	83 ec 0c             	sub    $0xc,%esp
  800217:	68 70 45 80 00       	push   $0x804570
  80021c:	e8 0f 06 00 00       	call   800830 <cprintf>
  800221:	83 c4 10             	add    $0x10,%esp
	{
		int i=0;
  800224:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
		for(;i<PAGE_SIZE/4;i++)
  80022b:	eb 2d                	jmp    80025a <_main+0x222>
		{
			x[i] = -1;
  80022d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800230:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800237:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80023a:	01 d0                	add    %edx,%eax
  80023c:	c7 00 ff ff ff ff    	movl   $0xffffffff,(%eax)
			y[i] = -1;
  800242:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800245:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80024c:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80024f:	01 d0                	add    %edx,%eax
  800251:	c7 00 ff ff ff ff    	movl   $0xffffffff,(%eax)


	cprintf("STEP B: checking reading & writing... \n");
	{
		int i=0;
		for(;i<PAGE_SIZE/4;i++)
  800257:	ff 45 f4             	incl   -0xc(%ebp)
  80025a:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%ebp)
  800261:	7e ca                	jle    80022d <_main+0x1f5>
		{
			x[i] = -1;
			y[i] = -1;
		}

		i=0;
  800263:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
		for(;i<2*PAGE_SIZE/4;i++)
  80026a:	eb 18                	jmp    800284 <_main+0x24c>
		{
			z[i] = -1;
  80026c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80026f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800276:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800279:	01 d0                	add    %edx,%eax
  80027b:	c7 00 ff ff ff ff    	movl   $0xffffffff,(%eax)
			x[i] = -1;
			y[i] = -1;
		}

		i=0;
		for(;i<2*PAGE_SIZE/4;i++)
  800281:	ff 45 f4             	incl   -0xc(%ebp)
  800284:	81 7d f4 ff 07 00 00 	cmpl   $0x7ff,-0xc(%ebp)
  80028b:	7e df                	jle    80026c <_main+0x234>
		{
			z[i] = -1;
		}

		if( x[0] !=  -1)  					panic("Reading/Writing of shared object is failed");
  80028d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800290:	8b 00                	mov    (%eax),%eax
  800292:	83 f8 ff             	cmp    $0xffffffff,%eax
  800295:	74 14                	je     8002ab <_main+0x273>
  800297:	83 ec 04             	sub    $0x4,%esp
  80029a:	68 98 45 80 00       	push   $0x804598
  80029f:	6a 3f                	push   $0x3f
  8002a1:	68 a4 44 80 00       	push   $0x8044a4
  8002a6:	e8 b7 02 00 00       	call   800562 <_panic>
		if( x[PAGE_SIZE/4 - 1] !=  -1)  	panic("Reading/Writing of shared object is failed");
  8002ab:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8002ae:	05 fc 0f 00 00       	add    $0xffc,%eax
  8002b3:	8b 00                	mov    (%eax),%eax
  8002b5:	83 f8 ff             	cmp    $0xffffffff,%eax
  8002b8:	74 14                	je     8002ce <_main+0x296>
  8002ba:	83 ec 04             	sub    $0x4,%esp
  8002bd:	68 98 45 80 00       	push   $0x804598
  8002c2:	6a 40                	push   $0x40
  8002c4:	68 a4 44 80 00       	push   $0x8044a4
  8002c9:	e8 94 02 00 00       	call   800562 <_panic>

		if( y[0] !=  -1)  					panic("Reading/Writing of shared object is failed");
  8002ce:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8002d1:	8b 00                	mov    (%eax),%eax
  8002d3:	83 f8 ff             	cmp    $0xffffffff,%eax
  8002d6:	74 14                	je     8002ec <_main+0x2b4>
  8002d8:	83 ec 04             	sub    $0x4,%esp
  8002db:	68 98 45 80 00       	push   $0x804598
  8002e0:	6a 42                	push   $0x42
  8002e2:	68 a4 44 80 00       	push   $0x8044a4
  8002e7:	e8 76 02 00 00       	call   800562 <_panic>
		if( y[PAGE_SIZE/4 - 1] !=  -1)  	panic("Reading/Writing of shared object is failed");
  8002ec:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8002ef:	05 fc 0f 00 00       	add    $0xffc,%eax
  8002f4:	8b 00                	mov    (%eax),%eax
  8002f6:	83 f8 ff             	cmp    $0xffffffff,%eax
  8002f9:	74 14                	je     80030f <_main+0x2d7>
  8002fb:	83 ec 04             	sub    $0x4,%esp
  8002fe:	68 98 45 80 00       	push   $0x804598
  800303:	6a 43                	push   $0x43
  800305:	68 a4 44 80 00       	push   $0x8044a4
  80030a:	e8 53 02 00 00       	call   800562 <_panic>

		if( z[0] !=  -1)  					panic("Reading/Writing of shared object is failed");
  80030f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800312:	8b 00                	mov    (%eax),%eax
  800314:	83 f8 ff             	cmp    $0xffffffff,%eax
  800317:	74 14                	je     80032d <_main+0x2f5>
  800319:	83 ec 04             	sub    $0x4,%esp
  80031c:	68 98 45 80 00       	push   $0x804598
  800321:	6a 45                	push   $0x45
  800323:	68 a4 44 80 00       	push   $0x8044a4
  800328:	e8 35 02 00 00       	call   800562 <_panic>
		if( z[2*PAGE_SIZE/4 - 1] !=  -1)  	panic("Reading/Writing of shared object is failed");
  80032d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800330:	05 fc 1f 00 00       	add    $0x1ffc,%eax
  800335:	8b 00                	mov    (%eax),%eax
  800337:	83 f8 ff             	cmp    $0xffffffff,%eax
  80033a:	74 14                	je     800350 <_main+0x318>
  80033c:	83 ec 04             	sub    $0x4,%esp
  80033f:	68 98 45 80 00       	push   $0x804598
  800344:	6a 46                	push   $0x46
  800346:	68 a4 44 80 00       	push   $0x8044a4
  80034b:	e8 12 02 00 00       	call   800562 <_panic>
	}

	cprintf("test sharing 1 [Create] is finished!!\n\n\n");
  800350:	83 ec 0c             	sub    $0xc,%esp
  800353:	68 c4 45 80 00       	push   $0x8045c4
  800358:	e8 d3 04 00 00       	call   800830 <cprintf>
  80035d:	83 c4 10             	add    $0x10,%esp

	int32 parentenvID = sys_getparentenvid();
  800360:	e8 18 30 00 00       	call   80337d <sys_getparentenvid>
  800365:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	if(parentenvID > 0)
  800368:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80036c:	7e 35                	jle    8003a3 <_main+0x36b>
	{
		//Get the check-finishing counter
		int *finishedCount = NULL;
  80036e:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
		finishedCount = sget(parentenvID, "finishedCount") ;
  800375:	83 ec 08             	sub    $0x8,%esp
  800378:	68 ed 45 80 00       	push   $0x8045ed
  80037d:	ff 75 d4             	pushl  -0x2c(%ebp)
  800380:	e8 f9 26 00 00       	call   802a7e <sget>
  800385:	83 c4 10             	add    $0x10,%esp
  800388:	89 45 d0             	mov    %eax,-0x30(%ebp)
		sys_lock_cons();
  80038b:	e8 5b 2d 00 00       	call   8030eb <sys_lock_cons>
		{
			(*finishedCount)++ ;
  800390:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800393:	8b 00                	mov    (%eax),%eax
  800395:	8d 50 01             	lea    0x1(%eax),%edx
  800398:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80039b:	89 10                	mov    %edx,(%eax)
		}
		sys_unlock_cons();
  80039d:	e8 63 2d 00 00       	call   803105 <sys_unlock_cons>
	}

	return;
  8003a2:	90                   	nop
  8003a3:	90                   	nop
}
  8003a4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8003a7:	c9                   	leave  
  8003a8:	c3                   	ret    

008003a9 <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  8003a9:	55                   	push   %ebp
  8003aa:	89 e5                	mov    %esp,%ebp
  8003ac:	57                   	push   %edi
  8003ad:	56                   	push   %esi
  8003ae:	53                   	push   %ebx
  8003af:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  8003b2:	e8 ad 2f 00 00       	call   803364 <sys_getenvindex>
  8003b7:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  8003ba:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8003bd:	89 d0                	mov    %edx,%eax
  8003bf:	c1 e0 02             	shl    $0x2,%eax
  8003c2:	01 d0                	add    %edx,%eax
  8003c4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003cb:	01 d0                	add    %edx,%eax
  8003cd:	89 c2                	mov    %eax,%edx
  8003cf:	c1 e2 04             	shl    $0x4,%edx
  8003d2:	29 c2                	sub    %eax,%edx
  8003d4:	8d 04 95 00 00 00 00 	lea    0x0(,%edx,4),%eax
  8003db:	89 c2                	mov    %eax,%edx
  8003dd:	8d 82 00 00 c0 ee    	lea    -0x11400000(%edx),%eax
  8003e3:	a3 20 50 80 00       	mov    %eax,0x805020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8003e8:	a1 20 50 80 00       	mov    0x805020,%eax
  8003ed:	8a 40 20             	mov    0x20(%eax),%al
  8003f0:	84 c0                	test   %al,%al
  8003f2:	74 0d                	je     800401 <libmain+0x58>
		binaryname = myEnv->prog_name;
  8003f4:	a1 20 50 80 00       	mov    0x805020,%eax
  8003f9:	83 c0 20             	add    $0x20,%eax
  8003fc:	a3 04 50 80 00       	mov    %eax,0x805004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800401:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800405:	7e 0a                	jle    800411 <libmain+0x68>
		binaryname = argv[0];
  800407:	8b 45 0c             	mov    0xc(%ebp),%eax
  80040a:	8b 00                	mov    (%eax),%eax
  80040c:	a3 04 50 80 00       	mov    %eax,0x805004

	// call user main routine
	_main(argc, argv);
  800411:	83 ec 08             	sub    $0x8,%esp
  800414:	ff 75 0c             	pushl  0xc(%ebp)
  800417:	ff 75 08             	pushl  0x8(%ebp)
  80041a:	e8 19 fc ff ff       	call   800038 <_main>
  80041f:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  800422:	a1 00 50 80 00       	mov    0x805000,%eax
  800427:	85 c0                	test   %eax,%eax
  800429:	0f 84 01 01 00 00    	je     800530 <libmain+0x187>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  80042f:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  800435:	bb f4 46 80 00       	mov    $0x8046f4,%ebx
  80043a:	ba 0e 00 00 00       	mov    $0xe,%edx
  80043f:	89 c7                	mov    %eax,%edi
  800441:	89 de                	mov    %ebx,%esi
  800443:	89 d1                	mov    %edx,%ecx
  800445:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  800447:	8d 55 8a             	lea    -0x76(%ebp),%edx
  80044a:	b9 56 00 00 00       	mov    $0x56,%ecx
  80044f:	b0 00                	mov    $0x0,%al
  800451:	89 d7                	mov    %edx,%edi
  800453:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  800455:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  80045c:	8d 45 e0             	lea    -0x20(%ebp),%eax
  80045f:	83 ec 08             	sub    $0x8,%esp
  800462:	50                   	push   %eax
  800463:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  800469:	50                   	push   %eax
  80046a:	e8 2b 31 00 00       	call   80359a <sys_utilities>
  80046f:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  800472:	e8 74 2c 00 00       	call   8030eb <sys_lock_cons>
		{
			cprintf("**************************************\n");
  800477:	83 ec 0c             	sub    $0xc,%esp
  80047a:	68 14 46 80 00       	push   $0x804614
  80047f:	e8 ac 03 00 00       	call   800830 <cprintf>
  800484:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  800487:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80048a:	85 c0                	test   %eax,%eax
  80048c:	74 18                	je     8004a6 <libmain+0xfd>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  80048e:	e8 25 31 00 00       	call   8035b8 <sys_get_optimal_num_faults>
  800493:	83 ec 08             	sub    $0x8,%esp
  800496:	50                   	push   %eax
  800497:	68 3c 46 80 00       	push   $0x80463c
  80049c:	e8 8f 03 00 00       	call   800830 <cprintf>
  8004a1:	83 c4 10             	add    $0x10,%esp
  8004a4:	eb 59                	jmp    8004ff <libmain+0x156>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8004a6:	a1 20 50 80 00       	mov    0x805020,%eax
  8004ab:	8b 90 bc 05 00 00    	mov    0x5bc(%eax),%edx
  8004b1:	a1 20 50 80 00       	mov    0x805020,%eax
  8004b6:	8b 80 ac 05 00 00    	mov    0x5ac(%eax),%eax
  8004bc:	83 ec 04             	sub    $0x4,%esp
  8004bf:	52                   	push   %edx
  8004c0:	50                   	push   %eax
  8004c1:	68 60 46 80 00       	push   $0x804660
  8004c6:	e8 65 03 00 00       	call   800830 <cprintf>
  8004cb:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8004ce:	a1 20 50 80 00       	mov    0x805020,%eax
  8004d3:	8b 88 d0 05 00 00    	mov    0x5d0(%eax),%ecx
  8004d9:	a1 20 50 80 00       	mov    0x805020,%eax
  8004de:	8b 90 cc 05 00 00    	mov    0x5cc(%eax),%edx
  8004e4:	a1 20 50 80 00       	mov    0x805020,%eax
  8004e9:	8b 80 c8 05 00 00    	mov    0x5c8(%eax),%eax
  8004ef:	51                   	push   %ecx
  8004f0:	52                   	push   %edx
  8004f1:	50                   	push   %eax
  8004f2:	68 88 46 80 00       	push   $0x804688
  8004f7:	e8 34 03 00 00       	call   800830 <cprintf>
  8004fc:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8004ff:	a1 20 50 80 00       	mov    0x805020,%eax
  800504:	8b 80 d4 05 00 00    	mov    0x5d4(%eax),%eax
  80050a:	83 ec 08             	sub    $0x8,%esp
  80050d:	50                   	push   %eax
  80050e:	68 e0 46 80 00       	push   $0x8046e0
  800513:	e8 18 03 00 00       	call   800830 <cprintf>
  800518:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  80051b:	83 ec 0c             	sub    $0xc,%esp
  80051e:	68 14 46 80 00       	push   $0x804614
  800523:	e8 08 03 00 00       	call   800830 <cprintf>
  800528:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  80052b:	e8 d5 2b 00 00       	call   803105 <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  800530:	e8 1f 00 00 00       	call   800554 <exit>
}
  800535:	90                   	nop
  800536:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800539:	5b                   	pop    %ebx
  80053a:	5e                   	pop    %esi
  80053b:	5f                   	pop    %edi
  80053c:	5d                   	pop    %ebp
  80053d:	c3                   	ret    

0080053e <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  80053e:	55                   	push   %ebp
  80053f:	89 e5                	mov    %esp,%ebp
  800541:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800544:	83 ec 0c             	sub    $0xc,%esp
  800547:	6a 00                	push   $0x0
  800549:	e8 e2 2d 00 00       	call   803330 <sys_destroy_env>
  80054e:	83 c4 10             	add    $0x10,%esp
}
  800551:	90                   	nop
  800552:	c9                   	leave  
  800553:	c3                   	ret    

00800554 <exit>:

void
exit(void)
{
  800554:	55                   	push   %ebp
  800555:	89 e5                	mov    %esp,%ebp
  800557:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  80055a:	e8 37 2e 00 00       	call   803396 <sys_exit_env>
}
  80055f:	90                   	nop
  800560:	c9                   	leave  
  800561:	c3                   	ret    

00800562 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800562:	55                   	push   %ebp
  800563:	89 e5                	mov    %esp,%ebp
  800565:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800568:	8d 45 10             	lea    0x10(%ebp),%eax
  80056b:	83 c0 04             	add    $0x4,%eax
  80056e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800571:	a1 18 d1 81 00       	mov    0x81d118,%eax
  800576:	85 c0                	test   %eax,%eax
  800578:	74 16                	je     800590 <_panic+0x2e>
		cprintf("%s: ", argv0);
  80057a:	a1 18 d1 81 00       	mov    0x81d118,%eax
  80057f:	83 ec 08             	sub    $0x8,%esp
  800582:	50                   	push   %eax
  800583:	68 58 47 80 00       	push   $0x804758
  800588:	e8 a3 02 00 00       	call   800830 <cprintf>
  80058d:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  800590:	a1 04 50 80 00       	mov    0x805004,%eax
  800595:	83 ec 0c             	sub    $0xc,%esp
  800598:	ff 75 0c             	pushl  0xc(%ebp)
  80059b:	ff 75 08             	pushl  0x8(%ebp)
  80059e:	50                   	push   %eax
  80059f:	68 60 47 80 00       	push   $0x804760
  8005a4:	6a 74                	push   $0x74
  8005a6:	e8 b2 02 00 00       	call   80085d <cprintf_colored>
  8005ab:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  8005ae:	8b 45 10             	mov    0x10(%ebp),%eax
  8005b1:	83 ec 08             	sub    $0x8,%esp
  8005b4:	ff 75 f4             	pushl  -0xc(%ebp)
  8005b7:	50                   	push   %eax
  8005b8:	e8 04 02 00 00       	call   8007c1 <vcprintf>
  8005bd:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8005c0:	83 ec 08             	sub    $0x8,%esp
  8005c3:	6a 00                	push   $0x0
  8005c5:	68 88 47 80 00       	push   $0x804788
  8005ca:	e8 f2 01 00 00       	call   8007c1 <vcprintf>
  8005cf:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8005d2:	e8 7d ff ff ff       	call   800554 <exit>

	// should not return here
	while (1) ;
  8005d7:	eb fe                	jmp    8005d7 <_panic+0x75>

008005d9 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8005d9:	55                   	push   %ebp
  8005da:	89 e5                	mov    %esp,%ebp
  8005dc:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8005df:	a1 20 50 80 00       	mov    0x805020,%eax
  8005e4:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8005ea:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005ed:	39 c2                	cmp    %eax,%edx
  8005ef:	74 14                	je     800605 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8005f1:	83 ec 04             	sub    $0x4,%esp
  8005f4:	68 8c 47 80 00       	push   $0x80478c
  8005f9:	6a 26                	push   $0x26
  8005fb:	68 d8 47 80 00       	push   $0x8047d8
  800600:	e8 5d ff ff ff       	call   800562 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800605:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  80060c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800613:	e9 c5 00 00 00       	jmp    8006dd <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  800618:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80061b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800622:	8b 45 08             	mov    0x8(%ebp),%eax
  800625:	01 d0                	add    %edx,%eax
  800627:	8b 00                	mov    (%eax),%eax
  800629:	85 c0                	test   %eax,%eax
  80062b:	75 08                	jne    800635 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  80062d:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800630:	e9 a5 00 00 00       	jmp    8006da <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  800635:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80063c:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800643:	eb 69                	jmp    8006ae <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800645:	a1 20 50 80 00       	mov    0x805020,%eax
  80064a:	8b 88 a4 05 00 00    	mov    0x5a4(%eax),%ecx
  800650:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800653:	89 d0                	mov    %edx,%eax
  800655:	01 c0                	add    %eax,%eax
  800657:	01 d0                	add    %edx,%eax
  800659:	c1 e0 03             	shl    $0x3,%eax
  80065c:	01 c8                	add    %ecx,%eax
  80065e:	8a 40 04             	mov    0x4(%eax),%al
  800661:	84 c0                	test   %al,%al
  800663:	75 46                	jne    8006ab <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800665:	a1 20 50 80 00       	mov    0x805020,%eax
  80066a:	8b 88 a4 05 00 00    	mov    0x5a4(%eax),%ecx
  800670:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800673:	89 d0                	mov    %edx,%eax
  800675:	01 c0                	add    %eax,%eax
  800677:	01 d0                	add    %edx,%eax
  800679:	c1 e0 03             	shl    $0x3,%eax
  80067c:	01 c8                	add    %ecx,%eax
  80067e:	8b 00                	mov    (%eax),%eax
  800680:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800683:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800686:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80068b:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  80068d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800690:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800697:	8b 45 08             	mov    0x8(%ebp),%eax
  80069a:	01 c8                	add    %ecx,%eax
  80069c:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80069e:	39 c2                	cmp    %eax,%edx
  8006a0:	75 09                	jne    8006ab <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  8006a2:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8006a9:	eb 15                	jmp    8006c0 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8006ab:	ff 45 e8             	incl   -0x18(%ebp)
  8006ae:	a1 20 50 80 00       	mov    0x805020,%eax
  8006b3:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8006b9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8006bc:	39 c2                	cmp    %eax,%edx
  8006be:	77 85                	ja     800645 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8006c0:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8006c4:	75 14                	jne    8006da <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  8006c6:	83 ec 04             	sub    $0x4,%esp
  8006c9:	68 e4 47 80 00       	push   $0x8047e4
  8006ce:	6a 3a                	push   $0x3a
  8006d0:	68 d8 47 80 00       	push   $0x8047d8
  8006d5:	e8 88 fe ff ff       	call   800562 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8006da:	ff 45 f0             	incl   -0x10(%ebp)
  8006dd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8006e0:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8006e3:	0f 8c 2f ff ff ff    	jl     800618 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8006e9:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8006f0:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8006f7:	eb 26                	jmp    80071f <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  8006f9:	a1 20 50 80 00       	mov    0x805020,%eax
  8006fe:	8b 88 a4 05 00 00    	mov    0x5a4(%eax),%ecx
  800704:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800707:	89 d0                	mov    %edx,%eax
  800709:	01 c0                	add    %eax,%eax
  80070b:	01 d0                	add    %edx,%eax
  80070d:	c1 e0 03             	shl    $0x3,%eax
  800710:	01 c8                	add    %ecx,%eax
  800712:	8a 40 04             	mov    0x4(%eax),%al
  800715:	3c 01                	cmp    $0x1,%al
  800717:	75 03                	jne    80071c <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  800719:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80071c:	ff 45 e0             	incl   -0x20(%ebp)
  80071f:	a1 20 50 80 00       	mov    0x805020,%eax
  800724:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  80072a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80072d:	39 c2                	cmp    %eax,%edx
  80072f:	77 c8                	ja     8006f9 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800731:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800734:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800737:	74 14                	je     80074d <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  800739:	83 ec 04             	sub    $0x4,%esp
  80073c:	68 38 48 80 00       	push   $0x804838
  800741:	6a 44                	push   $0x44
  800743:	68 d8 47 80 00       	push   $0x8047d8
  800748:	e8 15 fe ff ff       	call   800562 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  80074d:	90                   	nop
  80074e:	c9                   	leave  
  80074f:	c3                   	ret    

00800750 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  800750:	55                   	push   %ebp
  800751:	89 e5                	mov    %esp,%ebp
  800753:	53                   	push   %ebx
  800754:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  800757:	8b 45 0c             	mov    0xc(%ebp),%eax
  80075a:	8b 00                	mov    (%eax),%eax
  80075c:	8d 48 01             	lea    0x1(%eax),%ecx
  80075f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800762:	89 0a                	mov    %ecx,(%edx)
  800764:	8b 55 08             	mov    0x8(%ebp),%edx
  800767:	88 d1                	mov    %dl,%cl
  800769:	8b 55 0c             	mov    0xc(%ebp),%edx
  80076c:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800770:	8b 45 0c             	mov    0xc(%ebp),%eax
  800773:	8b 00                	mov    (%eax),%eax
  800775:	3d ff 00 00 00       	cmp    $0xff,%eax
  80077a:	75 30                	jne    8007ac <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  80077c:	8b 15 1c d1 81 00    	mov    0x81d11c,%edx
  800782:	a0 44 50 80 00       	mov    0x805044,%al
  800787:	0f b6 c0             	movzbl %al,%eax
  80078a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80078d:	8b 09                	mov    (%ecx),%ecx
  80078f:	89 cb                	mov    %ecx,%ebx
  800791:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800794:	83 c1 08             	add    $0x8,%ecx
  800797:	52                   	push   %edx
  800798:	50                   	push   %eax
  800799:	53                   	push   %ebx
  80079a:	51                   	push   %ecx
  80079b:	e8 07 29 00 00       	call   8030a7 <sys_cputs>
  8007a0:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8007a3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007a6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8007ac:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007af:	8b 40 04             	mov    0x4(%eax),%eax
  8007b2:	8d 50 01             	lea    0x1(%eax),%edx
  8007b5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007b8:	89 50 04             	mov    %edx,0x4(%eax)
}
  8007bb:	90                   	nop
  8007bc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8007bf:	c9                   	leave  
  8007c0:	c3                   	ret    

008007c1 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8007c1:	55                   	push   %ebp
  8007c2:	89 e5                	mov    %esp,%ebp
  8007c4:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8007ca:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8007d1:	00 00 00 
	b.cnt = 0;
  8007d4:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8007db:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8007de:	ff 75 0c             	pushl  0xc(%ebp)
  8007e1:	ff 75 08             	pushl  0x8(%ebp)
  8007e4:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8007ea:	50                   	push   %eax
  8007eb:	68 50 07 80 00       	push   $0x800750
  8007f0:	e8 5a 02 00 00       	call   800a4f <vprintfmt>
  8007f5:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  8007f8:	8b 15 1c d1 81 00    	mov    0x81d11c,%edx
  8007fe:	a0 44 50 80 00       	mov    0x805044,%al
  800803:	0f b6 c0             	movzbl %al,%eax
  800806:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  80080c:	52                   	push   %edx
  80080d:	50                   	push   %eax
  80080e:	51                   	push   %ecx
  80080f:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800815:	83 c0 08             	add    $0x8,%eax
  800818:	50                   	push   %eax
  800819:	e8 89 28 00 00       	call   8030a7 <sys_cputs>
  80081e:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800821:	c6 05 44 50 80 00 00 	movb   $0x0,0x805044
	return b.cnt;
  800828:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  80082e:	c9                   	leave  
  80082f:	c3                   	ret    

00800830 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  800830:	55                   	push   %ebp
  800831:	89 e5                	mov    %esp,%ebp
  800833:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800836:	c6 05 44 50 80 00 01 	movb   $0x1,0x805044
	va_start(ap, fmt);
  80083d:	8d 45 0c             	lea    0xc(%ebp),%eax
  800840:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800843:	8b 45 08             	mov    0x8(%ebp),%eax
  800846:	83 ec 08             	sub    $0x8,%esp
  800849:	ff 75 f4             	pushl  -0xc(%ebp)
  80084c:	50                   	push   %eax
  80084d:	e8 6f ff ff ff       	call   8007c1 <vcprintf>
  800852:	83 c4 10             	add    $0x10,%esp
  800855:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800858:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80085b:	c9                   	leave  
  80085c:	c3                   	ret    

0080085d <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  80085d:	55                   	push   %ebp
  80085e:	89 e5                	mov    %esp,%ebp
  800860:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800863:	c6 05 44 50 80 00 01 	movb   $0x1,0x805044
	curTextClr = (textClr << 8) ; //set text color by the given value
  80086a:	8b 45 08             	mov    0x8(%ebp),%eax
  80086d:	c1 e0 08             	shl    $0x8,%eax
  800870:	a3 1c d1 81 00       	mov    %eax,0x81d11c
	va_start(ap, fmt);
  800875:	8d 45 0c             	lea    0xc(%ebp),%eax
  800878:	83 c0 04             	add    $0x4,%eax
  80087b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80087e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800881:	83 ec 08             	sub    $0x8,%esp
  800884:	ff 75 f4             	pushl  -0xc(%ebp)
  800887:	50                   	push   %eax
  800888:	e8 34 ff ff ff       	call   8007c1 <vcprintf>
  80088d:	83 c4 10             	add    $0x10,%esp
  800890:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  800893:	c7 05 1c d1 81 00 00 	movl   $0x700,0x81d11c
  80089a:	07 00 00 

	return cnt;
  80089d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8008a0:	c9                   	leave  
  8008a1:	c3                   	ret    

008008a2 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  8008a2:	55                   	push   %ebp
  8008a3:	89 e5                	mov    %esp,%ebp
  8008a5:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  8008a8:	e8 3e 28 00 00       	call   8030eb <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  8008ad:	8d 45 0c             	lea    0xc(%ebp),%eax
  8008b0:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  8008b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8008b6:	83 ec 08             	sub    $0x8,%esp
  8008b9:	ff 75 f4             	pushl  -0xc(%ebp)
  8008bc:	50                   	push   %eax
  8008bd:	e8 ff fe ff ff       	call   8007c1 <vcprintf>
  8008c2:	83 c4 10             	add    $0x10,%esp
  8008c5:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  8008c8:	e8 38 28 00 00       	call   803105 <sys_unlock_cons>
	return cnt;
  8008cd:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8008d0:	c9                   	leave  
  8008d1:	c3                   	ret    

008008d2 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8008d2:	55                   	push   %ebp
  8008d3:	89 e5                	mov    %esp,%ebp
  8008d5:	53                   	push   %ebx
  8008d6:	83 ec 14             	sub    $0x14,%esp
  8008d9:	8b 45 10             	mov    0x10(%ebp),%eax
  8008dc:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8008df:	8b 45 14             	mov    0x14(%ebp),%eax
  8008e2:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8008e5:	8b 45 18             	mov    0x18(%ebp),%eax
  8008e8:	ba 00 00 00 00       	mov    $0x0,%edx
  8008ed:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8008f0:	77 55                	ja     800947 <printnum+0x75>
  8008f2:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8008f5:	72 05                	jb     8008fc <printnum+0x2a>
  8008f7:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8008fa:	77 4b                	ja     800947 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8008fc:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8008ff:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800902:	8b 45 18             	mov    0x18(%ebp),%eax
  800905:	ba 00 00 00 00       	mov    $0x0,%edx
  80090a:	52                   	push   %edx
  80090b:	50                   	push   %eax
  80090c:	ff 75 f4             	pushl  -0xc(%ebp)
  80090f:	ff 75 f0             	pushl  -0x10(%ebp)
  800912:	e8 81 38 00 00       	call   804198 <__udivdi3>
  800917:	83 c4 10             	add    $0x10,%esp
  80091a:	83 ec 04             	sub    $0x4,%esp
  80091d:	ff 75 20             	pushl  0x20(%ebp)
  800920:	53                   	push   %ebx
  800921:	ff 75 18             	pushl  0x18(%ebp)
  800924:	52                   	push   %edx
  800925:	50                   	push   %eax
  800926:	ff 75 0c             	pushl  0xc(%ebp)
  800929:	ff 75 08             	pushl  0x8(%ebp)
  80092c:	e8 a1 ff ff ff       	call   8008d2 <printnum>
  800931:	83 c4 20             	add    $0x20,%esp
  800934:	eb 1a                	jmp    800950 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800936:	83 ec 08             	sub    $0x8,%esp
  800939:	ff 75 0c             	pushl  0xc(%ebp)
  80093c:	ff 75 20             	pushl  0x20(%ebp)
  80093f:	8b 45 08             	mov    0x8(%ebp),%eax
  800942:	ff d0                	call   *%eax
  800944:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800947:	ff 4d 1c             	decl   0x1c(%ebp)
  80094a:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  80094e:	7f e6                	jg     800936 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800950:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800953:	bb 00 00 00 00       	mov    $0x0,%ebx
  800958:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80095b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80095e:	53                   	push   %ebx
  80095f:	51                   	push   %ecx
  800960:	52                   	push   %edx
  800961:	50                   	push   %eax
  800962:	e8 41 39 00 00       	call   8042a8 <__umoddi3>
  800967:	83 c4 10             	add    $0x10,%esp
  80096a:	05 b4 4a 80 00       	add    $0x804ab4,%eax
  80096f:	8a 00                	mov    (%eax),%al
  800971:	0f be c0             	movsbl %al,%eax
  800974:	83 ec 08             	sub    $0x8,%esp
  800977:	ff 75 0c             	pushl  0xc(%ebp)
  80097a:	50                   	push   %eax
  80097b:	8b 45 08             	mov    0x8(%ebp),%eax
  80097e:	ff d0                	call   *%eax
  800980:	83 c4 10             	add    $0x10,%esp
}
  800983:	90                   	nop
  800984:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800987:	c9                   	leave  
  800988:	c3                   	ret    

00800989 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800989:	55                   	push   %ebp
  80098a:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80098c:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800990:	7e 1c                	jle    8009ae <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800992:	8b 45 08             	mov    0x8(%ebp),%eax
  800995:	8b 00                	mov    (%eax),%eax
  800997:	8d 50 08             	lea    0x8(%eax),%edx
  80099a:	8b 45 08             	mov    0x8(%ebp),%eax
  80099d:	89 10                	mov    %edx,(%eax)
  80099f:	8b 45 08             	mov    0x8(%ebp),%eax
  8009a2:	8b 00                	mov    (%eax),%eax
  8009a4:	83 e8 08             	sub    $0x8,%eax
  8009a7:	8b 50 04             	mov    0x4(%eax),%edx
  8009aa:	8b 00                	mov    (%eax),%eax
  8009ac:	eb 40                	jmp    8009ee <getuint+0x65>
	else if (lflag)
  8009ae:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8009b2:	74 1e                	je     8009d2 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8009b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8009b7:	8b 00                	mov    (%eax),%eax
  8009b9:	8d 50 04             	lea    0x4(%eax),%edx
  8009bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8009bf:	89 10                	mov    %edx,(%eax)
  8009c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8009c4:	8b 00                	mov    (%eax),%eax
  8009c6:	83 e8 04             	sub    $0x4,%eax
  8009c9:	8b 00                	mov    (%eax),%eax
  8009cb:	ba 00 00 00 00       	mov    $0x0,%edx
  8009d0:	eb 1c                	jmp    8009ee <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8009d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8009d5:	8b 00                	mov    (%eax),%eax
  8009d7:	8d 50 04             	lea    0x4(%eax),%edx
  8009da:	8b 45 08             	mov    0x8(%ebp),%eax
  8009dd:	89 10                	mov    %edx,(%eax)
  8009df:	8b 45 08             	mov    0x8(%ebp),%eax
  8009e2:	8b 00                	mov    (%eax),%eax
  8009e4:	83 e8 04             	sub    $0x4,%eax
  8009e7:	8b 00                	mov    (%eax),%eax
  8009e9:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8009ee:	5d                   	pop    %ebp
  8009ef:	c3                   	ret    

008009f0 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8009f0:	55                   	push   %ebp
  8009f1:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8009f3:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8009f7:	7e 1c                	jle    800a15 <getint+0x25>
		return va_arg(*ap, long long);
  8009f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8009fc:	8b 00                	mov    (%eax),%eax
  8009fe:	8d 50 08             	lea    0x8(%eax),%edx
  800a01:	8b 45 08             	mov    0x8(%ebp),%eax
  800a04:	89 10                	mov    %edx,(%eax)
  800a06:	8b 45 08             	mov    0x8(%ebp),%eax
  800a09:	8b 00                	mov    (%eax),%eax
  800a0b:	83 e8 08             	sub    $0x8,%eax
  800a0e:	8b 50 04             	mov    0x4(%eax),%edx
  800a11:	8b 00                	mov    (%eax),%eax
  800a13:	eb 38                	jmp    800a4d <getint+0x5d>
	else if (lflag)
  800a15:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800a19:	74 1a                	je     800a35 <getint+0x45>
		return va_arg(*ap, long);
  800a1b:	8b 45 08             	mov    0x8(%ebp),%eax
  800a1e:	8b 00                	mov    (%eax),%eax
  800a20:	8d 50 04             	lea    0x4(%eax),%edx
  800a23:	8b 45 08             	mov    0x8(%ebp),%eax
  800a26:	89 10                	mov    %edx,(%eax)
  800a28:	8b 45 08             	mov    0x8(%ebp),%eax
  800a2b:	8b 00                	mov    (%eax),%eax
  800a2d:	83 e8 04             	sub    $0x4,%eax
  800a30:	8b 00                	mov    (%eax),%eax
  800a32:	99                   	cltd   
  800a33:	eb 18                	jmp    800a4d <getint+0x5d>
	else
		return va_arg(*ap, int);
  800a35:	8b 45 08             	mov    0x8(%ebp),%eax
  800a38:	8b 00                	mov    (%eax),%eax
  800a3a:	8d 50 04             	lea    0x4(%eax),%edx
  800a3d:	8b 45 08             	mov    0x8(%ebp),%eax
  800a40:	89 10                	mov    %edx,(%eax)
  800a42:	8b 45 08             	mov    0x8(%ebp),%eax
  800a45:	8b 00                	mov    (%eax),%eax
  800a47:	83 e8 04             	sub    $0x4,%eax
  800a4a:	8b 00                	mov    (%eax),%eax
  800a4c:	99                   	cltd   
}
  800a4d:	5d                   	pop    %ebp
  800a4e:	c3                   	ret    

00800a4f <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800a4f:	55                   	push   %ebp
  800a50:	89 e5                	mov    %esp,%ebp
  800a52:	56                   	push   %esi
  800a53:	53                   	push   %ebx
  800a54:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800a57:	eb 17                	jmp    800a70 <vprintfmt+0x21>
			if (ch == '\0')
  800a59:	85 db                	test   %ebx,%ebx
  800a5b:	0f 84 c1 03 00 00    	je     800e22 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  800a61:	83 ec 08             	sub    $0x8,%esp
  800a64:	ff 75 0c             	pushl  0xc(%ebp)
  800a67:	53                   	push   %ebx
  800a68:	8b 45 08             	mov    0x8(%ebp),%eax
  800a6b:	ff d0                	call   *%eax
  800a6d:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800a70:	8b 45 10             	mov    0x10(%ebp),%eax
  800a73:	8d 50 01             	lea    0x1(%eax),%edx
  800a76:	89 55 10             	mov    %edx,0x10(%ebp)
  800a79:	8a 00                	mov    (%eax),%al
  800a7b:	0f b6 d8             	movzbl %al,%ebx
  800a7e:	83 fb 25             	cmp    $0x25,%ebx
  800a81:	75 d6                	jne    800a59 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800a83:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800a87:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800a8e:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800a95:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800a9c:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800aa3:	8b 45 10             	mov    0x10(%ebp),%eax
  800aa6:	8d 50 01             	lea    0x1(%eax),%edx
  800aa9:	89 55 10             	mov    %edx,0x10(%ebp)
  800aac:	8a 00                	mov    (%eax),%al
  800aae:	0f b6 d8             	movzbl %al,%ebx
  800ab1:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800ab4:	83 f8 5b             	cmp    $0x5b,%eax
  800ab7:	0f 87 3d 03 00 00    	ja     800dfa <vprintfmt+0x3ab>
  800abd:	8b 04 85 d8 4a 80 00 	mov    0x804ad8(,%eax,4),%eax
  800ac4:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800ac6:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800aca:	eb d7                	jmp    800aa3 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800acc:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800ad0:	eb d1                	jmp    800aa3 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800ad2:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800ad9:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800adc:	89 d0                	mov    %edx,%eax
  800ade:	c1 e0 02             	shl    $0x2,%eax
  800ae1:	01 d0                	add    %edx,%eax
  800ae3:	01 c0                	add    %eax,%eax
  800ae5:	01 d8                	add    %ebx,%eax
  800ae7:	83 e8 30             	sub    $0x30,%eax
  800aea:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800aed:	8b 45 10             	mov    0x10(%ebp),%eax
  800af0:	8a 00                	mov    (%eax),%al
  800af2:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800af5:	83 fb 2f             	cmp    $0x2f,%ebx
  800af8:	7e 3e                	jle    800b38 <vprintfmt+0xe9>
  800afa:	83 fb 39             	cmp    $0x39,%ebx
  800afd:	7f 39                	jg     800b38 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800aff:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800b02:	eb d5                	jmp    800ad9 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800b04:	8b 45 14             	mov    0x14(%ebp),%eax
  800b07:	83 c0 04             	add    $0x4,%eax
  800b0a:	89 45 14             	mov    %eax,0x14(%ebp)
  800b0d:	8b 45 14             	mov    0x14(%ebp),%eax
  800b10:	83 e8 04             	sub    $0x4,%eax
  800b13:	8b 00                	mov    (%eax),%eax
  800b15:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800b18:	eb 1f                	jmp    800b39 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800b1a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b1e:	79 83                	jns    800aa3 <vprintfmt+0x54>
				width = 0;
  800b20:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800b27:	e9 77 ff ff ff       	jmp    800aa3 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800b2c:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800b33:	e9 6b ff ff ff       	jmp    800aa3 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800b38:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800b39:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b3d:	0f 89 60 ff ff ff    	jns    800aa3 <vprintfmt+0x54>
				width = precision, precision = -1;
  800b43:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800b46:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800b49:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800b50:	e9 4e ff ff ff       	jmp    800aa3 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800b55:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800b58:	e9 46 ff ff ff       	jmp    800aa3 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800b5d:	8b 45 14             	mov    0x14(%ebp),%eax
  800b60:	83 c0 04             	add    $0x4,%eax
  800b63:	89 45 14             	mov    %eax,0x14(%ebp)
  800b66:	8b 45 14             	mov    0x14(%ebp),%eax
  800b69:	83 e8 04             	sub    $0x4,%eax
  800b6c:	8b 00                	mov    (%eax),%eax
  800b6e:	83 ec 08             	sub    $0x8,%esp
  800b71:	ff 75 0c             	pushl  0xc(%ebp)
  800b74:	50                   	push   %eax
  800b75:	8b 45 08             	mov    0x8(%ebp),%eax
  800b78:	ff d0                	call   *%eax
  800b7a:	83 c4 10             	add    $0x10,%esp
			break;
  800b7d:	e9 9b 02 00 00       	jmp    800e1d <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800b82:	8b 45 14             	mov    0x14(%ebp),%eax
  800b85:	83 c0 04             	add    $0x4,%eax
  800b88:	89 45 14             	mov    %eax,0x14(%ebp)
  800b8b:	8b 45 14             	mov    0x14(%ebp),%eax
  800b8e:	83 e8 04             	sub    $0x4,%eax
  800b91:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800b93:	85 db                	test   %ebx,%ebx
  800b95:	79 02                	jns    800b99 <vprintfmt+0x14a>
				err = -err;
  800b97:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800b99:	83 fb 64             	cmp    $0x64,%ebx
  800b9c:	7f 0b                	jg     800ba9 <vprintfmt+0x15a>
  800b9e:	8b 34 9d 20 49 80 00 	mov    0x804920(,%ebx,4),%esi
  800ba5:	85 f6                	test   %esi,%esi
  800ba7:	75 19                	jne    800bc2 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800ba9:	53                   	push   %ebx
  800baa:	68 c5 4a 80 00       	push   $0x804ac5
  800baf:	ff 75 0c             	pushl  0xc(%ebp)
  800bb2:	ff 75 08             	pushl  0x8(%ebp)
  800bb5:	e8 70 02 00 00       	call   800e2a <printfmt>
  800bba:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800bbd:	e9 5b 02 00 00       	jmp    800e1d <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800bc2:	56                   	push   %esi
  800bc3:	68 ce 4a 80 00       	push   $0x804ace
  800bc8:	ff 75 0c             	pushl  0xc(%ebp)
  800bcb:	ff 75 08             	pushl  0x8(%ebp)
  800bce:	e8 57 02 00 00       	call   800e2a <printfmt>
  800bd3:	83 c4 10             	add    $0x10,%esp
			break;
  800bd6:	e9 42 02 00 00       	jmp    800e1d <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800bdb:	8b 45 14             	mov    0x14(%ebp),%eax
  800bde:	83 c0 04             	add    $0x4,%eax
  800be1:	89 45 14             	mov    %eax,0x14(%ebp)
  800be4:	8b 45 14             	mov    0x14(%ebp),%eax
  800be7:	83 e8 04             	sub    $0x4,%eax
  800bea:	8b 30                	mov    (%eax),%esi
  800bec:	85 f6                	test   %esi,%esi
  800bee:	75 05                	jne    800bf5 <vprintfmt+0x1a6>
				p = "(null)";
  800bf0:	be d1 4a 80 00       	mov    $0x804ad1,%esi
			if (width > 0 && padc != '-')
  800bf5:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800bf9:	7e 6d                	jle    800c68 <vprintfmt+0x219>
  800bfb:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800bff:	74 67                	je     800c68 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800c01:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800c04:	83 ec 08             	sub    $0x8,%esp
  800c07:	50                   	push   %eax
  800c08:	56                   	push   %esi
  800c09:	e8 1e 03 00 00       	call   800f2c <strnlen>
  800c0e:	83 c4 10             	add    $0x10,%esp
  800c11:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800c14:	eb 16                	jmp    800c2c <vprintfmt+0x1dd>
					putch(padc, putdat);
  800c16:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800c1a:	83 ec 08             	sub    $0x8,%esp
  800c1d:	ff 75 0c             	pushl  0xc(%ebp)
  800c20:	50                   	push   %eax
  800c21:	8b 45 08             	mov    0x8(%ebp),%eax
  800c24:	ff d0                	call   *%eax
  800c26:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800c29:	ff 4d e4             	decl   -0x1c(%ebp)
  800c2c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800c30:	7f e4                	jg     800c16 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800c32:	eb 34                	jmp    800c68 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800c34:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800c38:	74 1c                	je     800c56 <vprintfmt+0x207>
  800c3a:	83 fb 1f             	cmp    $0x1f,%ebx
  800c3d:	7e 05                	jle    800c44 <vprintfmt+0x1f5>
  800c3f:	83 fb 7e             	cmp    $0x7e,%ebx
  800c42:	7e 12                	jle    800c56 <vprintfmt+0x207>
					putch('?', putdat);
  800c44:	83 ec 08             	sub    $0x8,%esp
  800c47:	ff 75 0c             	pushl  0xc(%ebp)
  800c4a:	6a 3f                	push   $0x3f
  800c4c:	8b 45 08             	mov    0x8(%ebp),%eax
  800c4f:	ff d0                	call   *%eax
  800c51:	83 c4 10             	add    $0x10,%esp
  800c54:	eb 0f                	jmp    800c65 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800c56:	83 ec 08             	sub    $0x8,%esp
  800c59:	ff 75 0c             	pushl  0xc(%ebp)
  800c5c:	53                   	push   %ebx
  800c5d:	8b 45 08             	mov    0x8(%ebp),%eax
  800c60:	ff d0                	call   *%eax
  800c62:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800c65:	ff 4d e4             	decl   -0x1c(%ebp)
  800c68:	89 f0                	mov    %esi,%eax
  800c6a:	8d 70 01             	lea    0x1(%eax),%esi
  800c6d:	8a 00                	mov    (%eax),%al
  800c6f:	0f be d8             	movsbl %al,%ebx
  800c72:	85 db                	test   %ebx,%ebx
  800c74:	74 24                	je     800c9a <vprintfmt+0x24b>
  800c76:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800c7a:	78 b8                	js     800c34 <vprintfmt+0x1e5>
  800c7c:	ff 4d e0             	decl   -0x20(%ebp)
  800c7f:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800c83:	79 af                	jns    800c34 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800c85:	eb 13                	jmp    800c9a <vprintfmt+0x24b>
				putch(' ', putdat);
  800c87:	83 ec 08             	sub    $0x8,%esp
  800c8a:	ff 75 0c             	pushl  0xc(%ebp)
  800c8d:	6a 20                	push   $0x20
  800c8f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c92:	ff d0                	call   *%eax
  800c94:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800c97:	ff 4d e4             	decl   -0x1c(%ebp)
  800c9a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800c9e:	7f e7                	jg     800c87 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800ca0:	e9 78 01 00 00       	jmp    800e1d <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800ca5:	83 ec 08             	sub    $0x8,%esp
  800ca8:	ff 75 e8             	pushl  -0x18(%ebp)
  800cab:	8d 45 14             	lea    0x14(%ebp),%eax
  800cae:	50                   	push   %eax
  800caf:	e8 3c fd ff ff       	call   8009f0 <getint>
  800cb4:	83 c4 10             	add    $0x10,%esp
  800cb7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800cba:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800cbd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800cc0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800cc3:	85 d2                	test   %edx,%edx
  800cc5:	79 23                	jns    800cea <vprintfmt+0x29b>
				putch('-', putdat);
  800cc7:	83 ec 08             	sub    $0x8,%esp
  800cca:	ff 75 0c             	pushl  0xc(%ebp)
  800ccd:	6a 2d                	push   $0x2d
  800ccf:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd2:	ff d0                	call   *%eax
  800cd4:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800cd7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800cda:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800cdd:	f7 d8                	neg    %eax
  800cdf:	83 d2 00             	adc    $0x0,%edx
  800ce2:	f7 da                	neg    %edx
  800ce4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ce7:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800cea:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800cf1:	e9 bc 00 00 00       	jmp    800db2 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800cf6:	83 ec 08             	sub    $0x8,%esp
  800cf9:	ff 75 e8             	pushl  -0x18(%ebp)
  800cfc:	8d 45 14             	lea    0x14(%ebp),%eax
  800cff:	50                   	push   %eax
  800d00:	e8 84 fc ff ff       	call   800989 <getuint>
  800d05:	83 c4 10             	add    $0x10,%esp
  800d08:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800d0b:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800d0e:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800d15:	e9 98 00 00 00       	jmp    800db2 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800d1a:	83 ec 08             	sub    $0x8,%esp
  800d1d:	ff 75 0c             	pushl  0xc(%ebp)
  800d20:	6a 58                	push   $0x58
  800d22:	8b 45 08             	mov    0x8(%ebp),%eax
  800d25:	ff d0                	call   *%eax
  800d27:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800d2a:	83 ec 08             	sub    $0x8,%esp
  800d2d:	ff 75 0c             	pushl  0xc(%ebp)
  800d30:	6a 58                	push   $0x58
  800d32:	8b 45 08             	mov    0x8(%ebp),%eax
  800d35:	ff d0                	call   *%eax
  800d37:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800d3a:	83 ec 08             	sub    $0x8,%esp
  800d3d:	ff 75 0c             	pushl  0xc(%ebp)
  800d40:	6a 58                	push   $0x58
  800d42:	8b 45 08             	mov    0x8(%ebp),%eax
  800d45:	ff d0                	call   *%eax
  800d47:	83 c4 10             	add    $0x10,%esp
			break;
  800d4a:	e9 ce 00 00 00       	jmp    800e1d <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800d4f:	83 ec 08             	sub    $0x8,%esp
  800d52:	ff 75 0c             	pushl  0xc(%ebp)
  800d55:	6a 30                	push   $0x30
  800d57:	8b 45 08             	mov    0x8(%ebp),%eax
  800d5a:	ff d0                	call   *%eax
  800d5c:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800d5f:	83 ec 08             	sub    $0x8,%esp
  800d62:	ff 75 0c             	pushl  0xc(%ebp)
  800d65:	6a 78                	push   $0x78
  800d67:	8b 45 08             	mov    0x8(%ebp),%eax
  800d6a:	ff d0                	call   *%eax
  800d6c:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800d6f:	8b 45 14             	mov    0x14(%ebp),%eax
  800d72:	83 c0 04             	add    $0x4,%eax
  800d75:	89 45 14             	mov    %eax,0x14(%ebp)
  800d78:	8b 45 14             	mov    0x14(%ebp),%eax
  800d7b:	83 e8 04             	sub    $0x4,%eax
  800d7e:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800d80:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800d83:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800d8a:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800d91:	eb 1f                	jmp    800db2 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800d93:	83 ec 08             	sub    $0x8,%esp
  800d96:	ff 75 e8             	pushl  -0x18(%ebp)
  800d99:	8d 45 14             	lea    0x14(%ebp),%eax
  800d9c:	50                   	push   %eax
  800d9d:	e8 e7 fb ff ff       	call   800989 <getuint>
  800da2:	83 c4 10             	add    $0x10,%esp
  800da5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800da8:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800dab:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800db2:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800db6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800db9:	83 ec 04             	sub    $0x4,%esp
  800dbc:	52                   	push   %edx
  800dbd:	ff 75 e4             	pushl  -0x1c(%ebp)
  800dc0:	50                   	push   %eax
  800dc1:	ff 75 f4             	pushl  -0xc(%ebp)
  800dc4:	ff 75 f0             	pushl  -0x10(%ebp)
  800dc7:	ff 75 0c             	pushl  0xc(%ebp)
  800dca:	ff 75 08             	pushl  0x8(%ebp)
  800dcd:	e8 00 fb ff ff       	call   8008d2 <printnum>
  800dd2:	83 c4 20             	add    $0x20,%esp
			break;
  800dd5:	eb 46                	jmp    800e1d <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800dd7:	83 ec 08             	sub    $0x8,%esp
  800dda:	ff 75 0c             	pushl  0xc(%ebp)
  800ddd:	53                   	push   %ebx
  800dde:	8b 45 08             	mov    0x8(%ebp),%eax
  800de1:	ff d0                	call   *%eax
  800de3:	83 c4 10             	add    $0x10,%esp
			break;
  800de6:	eb 35                	jmp    800e1d <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800de8:	c6 05 44 50 80 00 00 	movb   $0x0,0x805044
			break;
  800def:	eb 2c                	jmp    800e1d <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800df1:	c6 05 44 50 80 00 01 	movb   $0x1,0x805044
			break;
  800df8:	eb 23                	jmp    800e1d <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800dfa:	83 ec 08             	sub    $0x8,%esp
  800dfd:	ff 75 0c             	pushl  0xc(%ebp)
  800e00:	6a 25                	push   $0x25
  800e02:	8b 45 08             	mov    0x8(%ebp),%eax
  800e05:	ff d0                	call   *%eax
  800e07:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800e0a:	ff 4d 10             	decl   0x10(%ebp)
  800e0d:	eb 03                	jmp    800e12 <vprintfmt+0x3c3>
  800e0f:	ff 4d 10             	decl   0x10(%ebp)
  800e12:	8b 45 10             	mov    0x10(%ebp),%eax
  800e15:	48                   	dec    %eax
  800e16:	8a 00                	mov    (%eax),%al
  800e18:	3c 25                	cmp    $0x25,%al
  800e1a:	75 f3                	jne    800e0f <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800e1c:	90                   	nop
		}
	}
  800e1d:	e9 35 fc ff ff       	jmp    800a57 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800e22:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800e23:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800e26:	5b                   	pop    %ebx
  800e27:	5e                   	pop    %esi
  800e28:	5d                   	pop    %ebp
  800e29:	c3                   	ret    

00800e2a <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800e2a:	55                   	push   %ebp
  800e2b:	89 e5                	mov    %esp,%ebp
  800e2d:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800e30:	8d 45 10             	lea    0x10(%ebp),%eax
  800e33:	83 c0 04             	add    $0x4,%eax
  800e36:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800e39:	8b 45 10             	mov    0x10(%ebp),%eax
  800e3c:	ff 75 f4             	pushl  -0xc(%ebp)
  800e3f:	50                   	push   %eax
  800e40:	ff 75 0c             	pushl  0xc(%ebp)
  800e43:	ff 75 08             	pushl  0x8(%ebp)
  800e46:	e8 04 fc ff ff       	call   800a4f <vprintfmt>
  800e4b:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800e4e:	90                   	nop
  800e4f:	c9                   	leave  
  800e50:	c3                   	ret    

00800e51 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800e51:	55                   	push   %ebp
  800e52:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800e54:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e57:	8b 40 08             	mov    0x8(%eax),%eax
  800e5a:	8d 50 01             	lea    0x1(%eax),%edx
  800e5d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e60:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800e63:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e66:	8b 10                	mov    (%eax),%edx
  800e68:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e6b:	8b 40 04             	mov    0x4(%eax),%eax
  800e6e:	39 c2                	cmp    %eax,%edx
  800e70:	73 12                	jae    800e84 <sprintputch+0x33>
		*b->buf++ = ch;
  800e72:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e75:	8b 00                	mov    (%eax),%eax
  800e77:	8d 48 01             	lea    0x1(%eax),%ecx
  800e7a:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e7d:	89 0a                	mov    %ecx,(%edx)
  800e7f:	8b 55 08             	mov    0x8(%ebp),%edx
  800e82:	88 10                	mov    %dl,(%eax)
}
  800e84:	90                   	nop
  800e85:	5d                   	pop    %ebp
  800e86:	c3                   	ret    

00800e87 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800e87:	55                   	push   %ebp
  800e88:	89 e5                	mov    %esp,%ebp
  800e8a:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800e8d:	8b 45 08             	mov    0x8(%ebp),%eax
  800e90:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800e93:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e96:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e99:	8b 45 08             	mov    0x8(%ebp),%eax
  800e9c:	01 d0                	add    %edx,%eax
  800e9e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ea1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800ea8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800eac:	74 06                	je     800eb4 <vsnprintf+0x2d>
  800eae:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800eb2:	7f 07                	jg     800ebb <vsnprintf+0x34>
		return -E_INVAL;
  800eb4:	b8 03 00 00 00       	mov    $0x3,%eax
  800eb9:	eb 20                	jmp    800edb <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800ebb:	ff 75 14             	pushl  0x14(%ebp)
  800ebe:	ff 75 10             	pushl  0x10(%ebp)
  800ec1:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800ec4:	50                   	push   %eax
  800ec5:	68 51 0e 80 00       	push   $0x800e51
  800eca:	e8 80 fb ff ff       	call   800a4f <vprintfmt>
  800ecf:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800ed2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800ed5:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800ed8:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800edb:	c9                   	leave  
  800edc:	c3                   	ret    

00800edd <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800edd:	55                   	push   %ebp
  800ede:	89 e5                	mov    %esp,%ebp
  800ee0:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800ee3:	8d 45 10             	lea    0x10(%ebp),%eax
  800ee6:	83 c0 04             	add    $0x4,%eax
  800ee9:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800eec:	8b 45 10             	mov    0x10(%ebp),%eax
  800eef:	ff 75 f4             	pushl  -0xc(%ebp)
  800ef2:	50                   	push   %eax
  800ef3:	ff 75 0c             	pushl  0xc(%ebp)
  800ef6:	ff 75 08             	pushl  0x8(%ebp)
  800ef9:	e8 89 ff ff ff       	call   800e87 <vsnprintf>
  800efe:	83 c4 10             	add    $0x10,%esp
  800f01:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800f04:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800f07:	c9                   	leave  
  800f08:	c3                   	ret    

00800f09 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800f09:	55                   	push   %ebp
  800f0a:	89 e5                	mov    %esp,%ebp
  800f0c:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800f0f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800f16:	eb 06                	jmp    800f1e <strlen+0x15>
		n++;
  800f18:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800f1b:	ff 45 08             	incl   0x8(%ebp)
  800f1e:	8b 45 08             	mov    0x8(%ebp),%eax
  800f21:	8a 00                	mov    (%eax),%al
  800f23:	84 c0                	test   %al,%al
  800f25:	75 f1                	jne    800f18 <strlen+0xf>
		n++;
	return n;
  800f27:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800f2a:	c9                   	leave  
  800f2b:	c3                   	ret    

00800f2c <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800f2c:	55                   	push   %ebp
  800f2d:	89 e5                	mov    %esp,%ebp
  800f2f:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800f32:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800f39:	eb 09                	jmp    800f44 <strnlen+0x18>
		n++;
  800f3b:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800f3e:	ff 45 08             	incl   0x8(%ebp)
  800f41:	ff 4d 0c             	decl   0xc(%ebp)
  800f44:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800f48:	74 09                	je     800f53 <strnlen+0x27>
  800f4a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f4d:	8a 00                	mov    (%eax),%al
  800f4f:	84 c0                	test   %al,%al
  800f51:	75 e8                	jne    800f3b <strnlen+0xf>
		n++;
	return n;
  800f53:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800f56:	c9                   	leave  
  800f57:	c3                   	ret    

00800f58 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800f58:	55                   	push   %ebp
  800f59:	89 e5                	mov    %esp,%ebp
  800f5b:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800f5e:	8b 45 08             	mov    0x8(%ebp),%eax
  800f61:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800f64:	90                   	nop
  800f65:	8b 45 08             	mov    0x8(%ebp),%eax
  800f68:	8d 50 01             	lea    0x1(%eax),%edx
  800f6b:	89 55 08             	mov    %edx,0x8(%ebp)
  800f6e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f71:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f74:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800f77:	8a 12                	mov    (%edx),%dl
  800f79:	88 10                	mov    %dl,(%eax)
  800f7b:	8a 00                	mov    (%eax),%al
  800f7d:	84 c0                	test   %al,%al
  800f7f:	75 e4                	jne    800f65 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800f81:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800f84:	c9                   	leave  
  800f85:	c3                   	ret    

00800f86 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800f86:	55                   	push   %ebp
  800f87:	89 e5                	mov    %esp,%ebp
  800f89:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800f8c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f8f:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800f92:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800f99:	eb 1f                	jmp    800fba <strncpy+0x34>
		*dst++ = *src;
  800f9b:	8b 45 08             	mov    0x8(%ebp),%eax
  800f9e:	8d 50 01             	lea    0x1(%eax),%edx
  800fa1:	89 55 08             	mov    %edx,0x8(%ebp)
  800fa4:	8b 55 0c             	mov    0xc(%ebp),%edx
  800fa7:	8a 12                	mov    (%edx),%dl
  800fa9:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800fab:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fae:	8a 00                	mov    (%eax),%al
  800fb0:	84 c0                	test   %al,%al
  800fb2:	74 03                	je     800fb7 <strncpy+0x31>
			src++;
  800fb4:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800fb7:	ff 45 fc             	incl   -0x4(%ebp)
  800fba:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fbd:	3b 45 10             	cmp    0x10(%ebp),%eax
  800fc0:	72 d9                	jb     800f9b <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800fc2:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800fc5:	c9                   	leave  
  800fc6:	c3                   	ret    

00800fc7 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800fc7:	55                   	push   %ebp
  800fc8:	89 e5                	mov    %esp,%ebp
  800fca:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800fcd:	8b 45 08             	mov    0x8(%ebp),%eax
  800fd0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800fd3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fd7:	74 30                	je     801009 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800fd9:	eb 16                	jmp    800ff1 <strlcpy+0x2a>
			*dst++ = *src++;
  800fdb:	8b 45 08             	mov    0x8(%ebp),%eax
  800fde:	8d 50 01             	lea    0x1(%eax),%edx
  800fe1:	89 55 08             	mov    %edx,0x8(%ebp)
  800fe4:	8b 55 0c             	mov    0xc(%ebp),%edx
  800fe7:	8d 4a 01             	lea    0x1(%edx),%ecx
  800fea:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800fed:	8a 12                	mov    (%edx),%dl
  800fef:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800ff1:	ff 4d 10             	decl   0x10(%ebp)
  800ff4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ff8:	74 09                	je     801003 <strlcpy+0x3c>
  800ffa:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ffd:	8a 00                	mov    (%eax),%al
  800fff:	84 c0                	test   %al,%al
  801001:	75 d8                	jne    800fdb <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  801003:	8b 45 08             	mov    0x8(%ebp),%eax
  801006:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  801009:	8b 55 08             	mov    0x8(%ebp),%edx
  80100c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80100f:	29 c2                	sub    %eax,%edx
  801011:	89 d0                	mov    %edx,%eax
}
  801013:	c9                   	leave  
  801014:	c3                   	ret    

00801015 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801015:	55                   	push   %ebp
  801016:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  801018:	eb 06                	jmp    801020 <strcmp+0xb>
		p++, q++;
  80101a:	ff 45 08             	incl   0x8(%ebp)
  80101d:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801020:	8b 45 08             	mov    0x8(%ebp),%eax
  801023:	8a 00                	mov    (%eax),%al
  801025:	84 c0                	test   %al,%al
  801027:	74 0e                	je     801037 <strcmp+0x22>
  801029:	8b 45 08             	mov    0x8(%ebp),%eax
  80102c:	8a 10                	mov    (%eax),%dl
  80102e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801031:	8a 00                	mov    (%eax),%al
  801033:	38 c2                	cmp    %al,%dl
  801035:	74 e3                	je     80101a <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801037:	8b 45 08             	mov    0x8(%ebp),%eax
  80103a:	8a 00                	mov    (%eax),%al
  80103c:	0f b6 d0             	movzbl %al,%edx
  80103f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801042:	8a 00                	mov    (%eax),%al
  801044:	0f b6 c0             	movzbl %al,%eax
  801047:	29 c2                	sub    %eax,%edx
  801049:	89 d0                	mov    %edx,%eax
}
  80104b:	5d                   	pop    %ebp
  80104c:	c3                   	ret    

0080104d <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  80104d:	55                   	push   %ebp
  80104e:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  801050:	eb 09                	jmp    80105b <strncmp+0xe>
		n--, p++, q++;
  801052:	ff 4d 10             	decl   0x10(%ebp)
  801055:	ff 45 08             	incl   0x8(%ebp)
  801058:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  80105b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80105f:	74 17                	je     801078 <strncmp+0x2b>
  801061:	8b 45 08             	mov    0x8(%ebp),%eax
  801064:	8a 00                	mov    (%eax),%al
  801066:	84 c0                	test   %al,%al
  801068:	74 0e                	je     801078 <strncmp+0x2b>
  80106a:	8b 45 08             	mov    0x8(%ebp),%eax
  80106d:	8a 10                	mov    (%eax),%dl
  80106f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801072:	8a 00                	mov    (%eax),%al
  801074:	38 c2                	cmp    %al,%dl
  801076:	74 da                	je     801052 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  801078:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80107c:	75 07                	jne    801085 <strncmp+0x38>
		return 0;
  80107e:	b8 00 00 00 00       	mov    $0x0,%eax
  801083:	eb 14                	jmp    801099 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801085:	8b 45 08             	mov    0x8(%ebp),%eax
  801088:	8a 00                	mov    (%eax),%al
  80108a:	0f b6 d0             	movzbl %al,%edx
  80108d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801090:	8a 00                	mov    (%eax),%al
  801092:	0f b6 c0             	movzbl %al,%eax
  801095:	29 c2                	sub    %eax,%edx
  801097:	89 d0                	mov    %edx,%eax
}
  801099:	5d                   	pop    %ebp
  80109a:	c3                   	ret    

0080109b <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80109b:	55                   	push   %ebp
  80109c:	89 e5                	mov    %esp,%ebp
  80109e:	83 ec 04             	sub    $0x4,%esp
  8010a1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010a4:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8010a7:	eb 12                	jmp    8010bb <strchr+0x20>
		if (*s == c)
  8010a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ac:	8a 00                	mov    (%eax),%al
  8010ae:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8010b1:	75 05                	jne    8010b8 <strchr+0x1d>
			return (char *) s;
  8010b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b6:	eb 11                	jmp    8010c9 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8010b8:	ff 45 08             	incl   0x8(%ebp)
  8010bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8010be:	8a 00                	mov    (%eax),%al
  8010c0:	84 c0                	test   %al,%al
  8010c2:	75 e5                	jne    8010a9 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  8010c4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8010c9:	c9                   	leave  
  8010ca:	c3                   	ret    

008010cb <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8010cb:	55                   	push   %ebp
  8010cc:	89 e5                	mov    %esp,%ebp
  8010ce:	83 ec 04             	sub    $0x4,%esp
  8010d1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010d4:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8010d7:	eb 0d                	jmp    8010e6 <strfind+0x1b>
		if (*s == c)
  8010d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8010dc:	8a 00                	mov    (%eax),%al
  8010de:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8010e1:	74 0e                	je     8010f1 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8010e3:	ff 45 08             	incl   0x8(%ebp)
  8010e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8010e9:	8a 00                	mov    (%eax),%al
  8010eb:	84 c0                	test   %al,%al
  8010ed:	75 ea                	jne    8010d9 <strfind+0xe>
  8010ef:	eb 01                	jmp    8010f2 <strfind+0x27>
		if (*s == c)
			break;
  8010f1:	90                   	nop
	return (char *) s;
  8010f2:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8010f5:	c9                   	leave  
  8010f6:	c3                   	ret    

008010f7 <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  8010f7:	55                   	push   %ebp
  8010f8:	89 e5                	mov    %esp,%ebp
  8010fa:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  8010fd:	8b 45 08             	mov    0x8(%ebp),%eax
  801100:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  801103:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801107:	76 63                	jbe    80116c <memset+0x75>
		uint64 data_block = c;
  801109:	8b 45 0c             	mov    0xc(%ebp),%eax
  80110c:	99                   	cltd   
  80110d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801110:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  801113:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801116:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801119:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  80111d:	c1 e0 08             	shl    $0x8,%eax
  801120:	09 45 f0             	or     %eax,-0x10(%ebp)
  801123:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  801126:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801129:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80112c:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  801130:	c1 e0 10             	shl    $0x10,%eax
  801133:	09 45 f0             	or     %eax,-0x10(%ebp)
  801136:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  801139:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80113c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80113f:	89 c2                	mov    %eax,%edx
  801141:	b8 00 00 00 00       	mov    $0x0,%eax
  801146:	09 45 f0             	or     %eax,-0x10(%ebp)
  801149:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  80114c:	eb 18                	jmp    801166 <memset+0x6f>
			*p64++ = data_block, n -= 8;
  80114e:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801151:	8d 41 08             	lea    0x8(%ecx),%eax
  801154:	89 45 fc             	mov    %eax,-0x4(%ebp)
  801157:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80115a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80115d:	89 01                	mov    %eax,(%ecx)
  80115f:	89 51 04             	mov    %edx,0x4(%ecx)
  801162:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  801166:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  80116a:	77 e2                	ja     80114e <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  80116c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801170:	74 23                	je     801195 <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  801172:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801175:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  801178:	eb 0e                	jmp    801188 <memset+0x91>
			*p8++ = (uint8)c;
  80117a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80117d:	8d 50 01             	lea    0x1(%eax),%edx
  801180:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801183:	8b 55 0c             	mov    0xc(%ebp),%edx
  801186:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  801188:	8b 45 10             	mov    0x10(%ebp),%eax
  80118b:	8d 50 ff             	lea    -0x1(%eax),%edx
  80118e:	89 55 10             	mov    %edx,0x10(%ebp)
  801191:	85 c0                	test   %eax,%eax
  801193:	75 e5                	jne    80117a <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  801195:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801198:	c9                   	leave  
  801199:	c3                   	ret    

0080119a <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  80119a:	55                   	push   %ebp
  80119b:	89 e5                	mov    %esp,%ebp
  80119d:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  8011a0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011a3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  8011a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8011a9:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  8011ac:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  8011b0:	76 24                	jbe    8011d6 <memcpy+0x3c>
		while(n >= 8){
  8011b2:	eb 1c                	jmp    8011d0 <memcpy+0x36>
			*d64 = *s64;
  8011b4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011b7:	8b 50 04             	mov    0x4(%eax),%edx
  8011ba:	8b 00                	mov    (%eax),%eax
  8011bc:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8011bf:	89 01                	mov    %eax,(%ecx)
  8011c1:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  8011c4:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  8011c8:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  8011cc:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  8011d0:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  8011d4:	77 de                	ja     8011b4 <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  8011d6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8011da:	74 31                	je     80120d <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  8011dc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011df:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  8011e2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011e5:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  8011e8:	eb 16                	jmp    801200 <memcpy+0x66>
			*d8++ = *s8++;
  8011ea:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8011ed:	8d 50 01             	lea    0x1(%eax),%edx
  8011f0:	89 55 f0             	mov    %edx,-0x10(%ebp)
  8011f3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8011f6:	8d 4a 01             	lea    0x1(%edx),%ecx
  8011f9:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  8011fc:	8a 12                	mov    (%edx),%dl
  8011fe:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  801200:	8b 45 10             	mov    0x10(%ebp),%eax
  801203:	8d 50 ff             	lea    -0x1(%eax),%edx
  801206:	89 55 10             	mov    %edx,0x10(%ebp)
  801209:	85 c0                	test   %eax,%eax
  80120b:	75 dd                	jne    8011ea <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  80120d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801210:	c9                   	leave  
  801211:	c3                   	ret    

00801212 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801212:	55                   	push   %ebp
  801213:	89 e5                	mov    %esp,%ebp
  801215:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801218:	8b 45 0c             	mov    0xc(%ebp),%eax
  80121b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  80121e:	8b 45 08             	mov    0x8(%ebp),%eax
  801221:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801224:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801227:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80122a:	73 50                	jae    80127c <memmove+0x6a>
  80122c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80122f:	8b 45 10             	mov    0x10(%ebp),%eax
  801232:	01 d0                	add    %edx,%eax
  801234:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801237:	76 43                	jbe    80127c <memmove+0x6a>
		s += n;
  801239:	8b 45 10             	mov    0x10(%ebp),%eax
  80123c:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  80123f:	8b 45 10             	mov    0x10(%ebp),%eax
  801242:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  801245:	eb 10                	jmp    801257 <memmove+0x45>
			*--d = *--s;
  801247:	ff 4d f8             	decl   -0x8(%ebp)
  80124a:	ff 4d fc             	decl   -0x4(%ebp)
  80124d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801250:	8a 10                	mov    (%eax),%dl
  801252:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801255:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  801257:	8b 45 10             	mov    0x10(%ebp),%eax
  80125a:	8d 50 ff             	lea    -0x1(%eax),%edx
  80125d:	89 55 10             	mov    %edx,0x10(%ebp)
  801260:	85 c0                	test   %eax,%eax
  801262:	75 e3                	jne    801247 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801264:	eb 23                	jmp    801289 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  801266:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801269:	8d 50 01             	lea    0x1(%eax),%edx
  80126c:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80126f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801272:	8d 4a 01             	lea    0x1(%edx),%ecx
  801275:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801278:	8a 12                	mov    (%edx),%dl
  80127a:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  80127c:	8b 45 10             	mov    0x10(%ebp),%eax
  80127f:	8d 50 ff             	lea    -0x1(%eax),%edx
  801282:	89 55 10             	mov    %edx,0x10(%ebp)
  801285:	85 c0                	test   %eax,%eax
  801287:	75 dd                	jne    801266 <memmove+0x54>
			*d++ = *s++;

	return dst;
  801289:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80128c:	c9                   	leave  
  80128d:	c3                   	ret    

0080128e <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  80128e:	55                   	push   %ebp
  80128f:	89 e5                	mov    %esp,%ebp
  801291:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  801294:	8b 45 08             	mov    0x8(%ebp),%eax
  801297:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  80129a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80129d:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8012a0:	eb 2a                	jmp    8012cc <memcmp+0x3e>
		if (*s1 != *s2)
  8012a2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012a5:	8a 10                	mov    (%eax),%dl
  8012a7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012aa:	8a 00                	mov    (%eax),%al
  8012ac:	38 c2                	cmp    %al,%dl
  8012ae:	74 16                	je     8012c6 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  8012b0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012b3:	8a 00                	mov    (%eax),%al
  8012b5:	0f b6 d0             	movzbl %al,%edx
  8012b8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012bb:	8a 00                	mov    (%eax),%al
  8012bd:	0f b6 c0             	movzbl %al,%eax
  8012c0:	29 c2                	sub    %eax,%edx
  8012c2:	89 d0                	mov    %edx,%eax
  8012c4:	eb 18                	jmp    8012de <memcmp+0x50>
		s1++, s2++;
  8012c6:	ff 45 fc             	incl   -0x4(%ebp)
  8012c9:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  8012cc:	8b 45 10             	mov    0x10(%ebp),%eax
  8012cf:	8d 50 ff             	lea    -0x1(%eax),%edx
  8012d2:	89 55 10             	mov    %edx,0x10(%ebp)
  8012d5:	85 c0                	test   %eax,%eax
  8012d7:	75 c9                	jne    8012a2 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8012d9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8012de:	c9                   	leave  
  8012df:	c3                   	ret    

008012e0 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  8012e0:	55                   	push   %ebp
  8012e1:	89 e5                	mov    %esp,%ebp
  8012e3:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  8012e6:	8b 55 08             	mov    0x8(%ebp),%edx
  8012e9:	8b 45 10             	mov    0x10(%ebp),%eax
  8012ec:	01 d0                	add    %edx,%eax
  8012ee:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  8012f1:	eb 15                	jmp    801308 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  8012f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8012f6:	8a 00                	mov    (%eax),%al
  8012f8:	0f b6 d0             	movzbl %al,%edx
  8012fb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012fe:	0f b6 c0             	movzbl %al,%eax
  801301:	39 c2                	cmp    %eax,%edx
  801303:	74 0d                	je     801312 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801305:	ff 45 08             	incl   0x8(%ebp)
  801308:	8b 45 08             	mov    0x8(%ebp),%eax
  80130b:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80130e:	72 e3                	jb     8012f3 <memfind+0x13>
  801310:	eb 01                	jmp    801313 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801312:	90                   	nop
	return (void *) s;
  801313:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801316:	c9                   	leave  
  801317:	c3                   	ret    

00801318 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801318:	55                   	push   %ebp
  801319:	89 e5                	mov    %esp,%ebp
  80131b:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  80131e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801325:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80132c:	eb 03                	jmp    801331 <strtol+0x19>
		s++;
  80132e:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801331:	8b 45 08             	mov    0x8(%ebp),%eax
  801334:	8a 00                	mov    (%eax),%al
  801336:	3c 20                	cmp    $0x20,%al
  801338:	74 f4                	je     80132e <strtol+0x16>
  80133a:	8b 45 08             	mov    0x8(%ebp),%eax
  80133d:	8a 00                	mov    (%eax),%al
  80133f:	3c 09                	cmp    $0x9,%al
  801341:	74 eb                	je     80132e <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801343:	8b 45 08             	mov    0x8(%ebp),%eax
  801346:	8a 00                	mov    (%eax),%al
  801348:	3c 2b                	cmp    $0x2b,%al
  80134a:	75 05                	jne    801351 <strtol+0x39>
		s++;
  80134c:	ff 45 08             	incl   0x8(%ebp)
  80134f:	eb 13                	jmp    801364 <strtol+0x4c>
	else if (*s == '-')
  801351:	8b 45 08             	mov    0x8(%ebp),%eax
  801354:	8a 00                	mov    (%eax),%al
  801356:	3c 2d                	cmp    $0x2d,%al
  801358:	75 0a                	jne    801364 <strtol+0x4c>
		s++, neg = 1;
  80135a:	ff 45 08             	incl   0x8(%ebp)
  80135d:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801364:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801368:	74 06                	je     801370 <strtol+0x58>
  80136a:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  80136e:	75 20                	jne    801390 <strtol+0x78>
  801370:	8b 45 08             	mov    0x8(%ebp),%eax
  801373:	8a 00                	mov    (%eax),%al
  801375:	3c 30                	cmp    $0x30,%al
  801377:	75 17                	jne    801390 <strtol+0x78>
  801379:	8b 45 08             	mov    0x8(%ebp),%eax
  80137c:	40                   	inc    %eax
  80137d:	8a 00                	mov    (%eax),%al
  80137f:	3c 78                	cmp    $0x78,%al
  801381:	75 0d                	jne    801390 <strtol+0x78>
		s += 2, base = 16;
  801383:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801387:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  80138e:	eb 28                	jmp    8013b8 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801390:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801394:	75 15                	jne    8013ab <strtol+0x93>
  801396:	8b 45 08             	mov    0x8(%ebp),%eax
  801399:	8a 00                	mov    (%eax),%al
  80139b:	3c 30                	cmp    $0x30,%al
  80139d:	75 0c                	jne    8013ab <strtol+0x93>
		s++, base = 8;
  80139f:	ff 45 08             	incl   0x8(%ebp)
  8013a2:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8013a9:	eb 0d                	jmp    8013b8 <strtol+0xa0>
	else if (base == 0)
  8013ab:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8013af:	75 07                	jne    8013b8 <strtol+0xa0>
		base = 10;
  8013b1:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8013b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8013bb:	8a 00                	mov    (%eax),%al
  8013bd:	3c 2f                	cmp    $0x2f,%al
  8013bf:	7e 19                	jle    8013da <strtol+0xc2>
  8013c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8013c4:	8a 00                	mov    (%eax),%al
  8013c6:	3c 39                	cmp    $0x39,%al
  8013c8:	7f 10                	jg     8013da <strtol+0xc2>
			dig = *s - '0';
  8013ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8013cd:	8a 00                	mov    (%eax),%al
  8013cf:	0f be c0             	movsbl %al,%eax
  8013d2:	83 e8 30             	sub    $0x30,%eax
  8013d5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8013d8:	eb 42                	jmp    80141c <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  8013da:	8b 45 08             	mov    0x8(%ebp),%eax
  8013dd:	8a 00                	mov    (%eax),%al
  8013df:	3c 60                	cmp    $0x60,%al
  8013e1:	7e 19                	jle    8013fc <strtol+0xe4>
  8013e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8013e6:	8a 00                	mov    (%eax),%al
  8013e8:	3c 7a                	cmp    $0x7a,%al
  8013ea:	7f 10                	jg     8013fc <strtol+0xe4>
			dig = *s - 'a' + 10;
  8013ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8013ef:	8a 00                	mov    (%eax),%al
  8013f1:	0f be c0             	movsbl %al,%eax
  8013f4:	83 e8 57             	sub    $0x57,%eax
  8013f7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8013fa:	eb 20                	jmp    80141c <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  8013fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8013ff:	8a 00                	mov    (%eax),%al
  801401:	3c 40                	cmp    $0x40,%al
  801403:	7e 39                	jle    80143e <strtol+0x126>
  801405:	8b 45 08             	mov    0x8(%ebp),%eax
  801408:	8a 00                	mov    (%eax),%al
  80140a:	3c 5a                	cmp    $0x5a,%al
  80140c:	7f 30                	jg     80143e <strtol+0x126>
			dig = *s - 'A' + 10;
  80140e:	8b 45 08             	mov    0x8(%ebp),%eax
  801411:	8a 00                	mov    (%eax),%al
  801413:	0f be c0             	movsbl %al,%eax
  801416:	83 e8 37             	sub    $0x37,%eax
  801419:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  80141c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80141f:	3b 45 10             	cmp    0x10(%ebp),%eax
  801422:	7d 19                	jge    80143d <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801424:	ff 45 08             	incl   0x8(%ebp)
  801427:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80142a:	0f af 45 10          	imul   0x10(%ebp),%eax
  80142e:	89 c2                	mov    %eax,%edx
  801430:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801433:	01 d0                	add    %edx,%eax
  801435:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801438:	e9 7b ff ff ff       	jmp    8013b8 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  80143d:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  80143e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801442:	74 08                	je     80144c <strtol+0x134>
		*endptr = (char *) s;
  801444:	8b 45 0c             	mov    0xc(%ebp),%eax
  801447:	8b 55 08             	mov    0x8(%ebp),%edx
  80144a:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  80144c:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801450:	74 07                	je     801459 <strtol+0x141>
  801452:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801455:	f7 d8                	neg    %eax
  801457:	eb 03                	jmp    80145c <strtol+0x144>
  801459:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80145c:	c9                   	leave  
  80145d:	c3                   	ret    

0080145e <ltostr>:

void
ltostr(long value, char *str)
{
  80145e:	55                   	push   %ebp
  80145f:	89 e5                	mov    %esp,%ebp
  801461:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801464:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  80146b:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801472:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801476:	79 13                	jns    80148b <ltostr+0x2d>
	{
		neg = 1;
  801478:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  80147f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801482:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801485:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801488:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  80148b:	8b 45 08             	mov    0x8(%ebp),%eax
  80148e:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801493:	99                   	cltd   
  801494:	f7 f9                	idiv   %ecx
  801496:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801499:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80149c:	8d 50 01             	lea    0x1(%eax),%edx
  80149f:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8014a2:	89 c2                	mov    %eax,%edx
  8014a4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014a7:	01 d0                	add    %edx,%eax
  8014a9:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8014ac:	83 c2 30             	add    $0x30,%edx
  8014af:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8014b1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8014b4:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8014b9:	f7 e9                	imul   %ecx
  8014bb:	c1 fa 02             	sar    $0x2,%edx
  8014be:	89 c8                	mov    %ecx,%eax
  8014c0:	c1 f8 1f             	sar    $0x1f,%eax
  8014c3:	29 c2                	sub    %eax,%edx
  8014c5:	89 d0                	mov    %edx,%eax
  8014c7:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  8014ca:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8014ce:	75 bb                	jne    80148b <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8014d0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8014d7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8014da:	48                   	dec    %eax
  8014db:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8014de:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8014e2:	74 3d                	je     801521 <ltostr+0xc3>
		start = 1 ;
  8014e4:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8014eb:	eb 34                	jmp    801521 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  8014ed:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8014f0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014f3:	01 d0                	add    %edx,%eax
  8014f5:	8a 00                	mov    (%eax),%al
  8014f7:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8014fa:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8014fd:	8b 45 0c             	mov    0xc(%ebp),%eax
  801500:	01 c2                	add    %eax,%edx
  801502:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801505:	8b 45 0c             	mov    0xc(%ebp),%eax
  801508:	01 c8                	add    %ecx,%eax
  80150a:	8a 00                	mov    (%eax),%al
  80150c:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  80150e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801511:	8b 45 0c             	mov    0xc(%ebp),%eax
  801514:	01 c2                	add    %eax,%edx
  801516:	8a 45 eb             	mov    -0x15(%ebp),%al
  801519:	88 02                	mov    %al,(%edx)
		start++ ;
  80151b:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  80151e:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801521:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801524:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801527:	7c c4                	jl     8014ed <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801529:	8b 55 f8             	mov    -0x8(%ebp),%edx
  80152c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80152f:	01 d0                	add    %edx,%eax
  801531:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801534:	90                   	nop
  801535:	c9                   	leave  
  801536:	c3                   	ret    

00801537 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801537:	55                   	push   %ebp
  801538:	89 e5                	mov    %esp,%ebp
  80153a:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  80153d:	ff 75 08             	pushl  0x8(%ebp)
  801540:	e8 c4 f9 ff ff       	call   800f09 <strlen>
  801545:	83 c4 04             	add    $0x4,%esp
  801548:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  80154b:	ff 75 0c             	pushl  0xc(%ebp)
  80154e:	e8 b6 f9 ff ff       	call   800f09 <strlen>
  801553:	83 c4 04             	add    $0x4,%esp
  801556:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801559:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801560:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801567:	eb 17                	jmp    801580 <strcconcat+0x49>
		final[s] = str1[s] ;
  801569:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80156c:	8b 45 10             	mov    0x10(%ebp),%eax
  80156f:	01 c2                	add    %eax,%edx
  801571:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801574:	8b 45 08             	mov    0x8(%ebp),%eax
  801577:	01 c8                	add    %ecx,%eax
  801579:	8a 00                	mov    (%eax),%al
  80157b:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  80157d:	ff 45 fc             	incl   -0x4(%ebp)
  801580:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801583:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801586:	7c e1                	jl     801569 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801588:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  80158f:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801596:	eb 1f                	jmp    8015b7 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801598:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80159b:	8d 50 01             	lea    0x1(%eax),%edx
  80159e:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8015a1:	89 c2                	mov    %eax,%edx
  8015a3:	8b 45 10             	mov    0x10(%ebp),%eax
  8015a6:	01 c2                	add    %eax,%edx
  8015a8:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8015ab:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015ae:	01 c8                	add    %ecx,%eax
  8015b0:	8a 00                	mov    (%eax),%al
  8015b2:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8015b4:	ff 45 f8             	incl   -0x8(%ebp)
  8015b7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8015ba:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8015bd:	7c d9                	jl     801598 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8015bf:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8015c2:	8b 45 10             	mov    0x10(%ebp),%eax
  8015c5:	01 d0                	add    %edx,%eax
  8015c7:	c6 00 00             	movb   $0x0,(%eax)
}
  8015ca:	90                   	nop
  8015cb:	c9                   	leave  
  8015cc:	c3                   	ret    

008015cd <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8015cd:	55                   	push   %ebp
  8015ce:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8015d0:	8b 45 14             	mov    0x14(%ebp),%eax
  8015d3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8015d9:	8b 45 14             	mov    0x14(%ebp),%eax
  8015dc:	8b 00                	mov    (%eax),%eax
  8015de:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8015e5:	8b 45 10             	mov    0x10(%ebp),%eax
  8015e8:	01 d0                	add    %edx,%eax
  8015ea:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8015f0:	eb 0c                	jmp    8015fe <strsplit+0x31>
			*string++ = 0;
  8015f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8015f5:	8d 50 01             	lea    0x1(%eax),%edx
  8015f8:	89 55 08             	mov    %edx,0x8(%ebp)
  8015fb:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8015fe:	8b 45 08             	mov    0x8(%ebp),%eax
  801601:	8a 00                	mov    (%eax),%al
  801603:	84 c0                	test   %al,%al
  801605:	74 18                	je     80161f <strsplit+0x52>
  801607:	8b 45 08             	mov    0x8(%ebp),%eax
  80160a:	8a 00                	mov    (%eax),%al
  80160c:	0f be c0             	movsbl %al,%eax
  80160f:	50                   	push   %eax
  801610:	ff 75 0c             	pushl  0xc(%ebp)
  801613:	e8 83 fa ff ff       	call   80109b <strchr>
  801618:	83 c4 08             	add    $0x8,%esp
  80161b:	85 c0                	test   %eax,%eax
  80161d:	75 d3                	jne    8015f2 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  80161f:	8b 45 08             	mov    0x8(%ebp),%eax
  801622:	8a 00                	mov    (%eax),%al
  801624:	84 c0                	test   %al,%al
  801626:	74 5a                	je     801682 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801628:	8b 45 14             	mov    0x14(%ebp),%eax
  80162b:	8b 00                	mov    (%eax),%eax
  80162d:	83 f8 0f             	cmp    $0xf,%eax
  801630:	75 07                	jne    801639 <strsplit+0x6c>
		{
			return 0;
  801632:	b8 00 00 00 00       	mov    $0x0,%eax
  801637:	eb 66                	jmp    80169f <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801639:	8b 45 14             	mov    0x14(%ebp),%eax
  80163c:	8b 00                	mov    (%eax),%eax
  80163e:	8d 48 01             	lea    0x1(%eax),%ecx
  801641:	8b 55 14             	mov    0x14(%ebp),%edx
  801644:	89 0a                	mov    %ecx,(%edx)
  801646:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80164d:	8b 45 10             	mov    0x10(%ebp),%eax
  801650:	01 c2                	add    %eax,%edx
  801652:	8b 45 08             	mov    0x8(%ebp),%eax
  801655:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801657:	eb 03                	jmp    80165c <strsplit+0x8f>
			string++;
  801659:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  80165c:	8b 45 08             	mov    0x8(%ebp),%eax
  80165f:	8a 00                	mov    (%eax),%al
  801661:	84 c0                	test   %al,%al
  801663:	74 8b                	je     8015f0 <strsplit+0x23>
  801665:	8b 45 08             	mov    0x8(%ebp),%eax
  801668:	8a 00                	mov    (%eax),%al
  80166a:	0f be c0             	movsbl %al,%eax
  80166d:	50                   	push   %eax
  80166e:	ff 75 0c             	pushl  0xc(%ebp)
  801671:	e8 25 fa ff ff       	call   80109b <strchr>
  801676:	83 c4 08             	add    $0x8,%esp
  801679:	85 c0                	test   %eax,%eax
  80167b:	74 dc                	je     801659 <strsplit+0x8c>
			string++;
	}
  80167d:	e9 6e ff ff ff       	jmp    8015f0 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801682:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801683:	8b 45 14             	mov    0x14(%ebp),%eax
  801686:	8b 00                	mov    (%eax),%eax
  801688:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80168f:	8b 45 10             	mov    0x10(%ebp),%eax
  801692:	01 d0                	add    %edx,%eax
  801694:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  80169a:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80169f:	c9                   	leave  
  8016a0:	c3                   	ret    

008016a1 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  8016a1:	55                   	push   %ebp
  8016a2:	89 e5                	mov    %esp,%ebp
  8016a4:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  8016a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8016aa:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  8016ad:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8016b4:	eb 4a                	jmp    801700 <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  8016b6:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8016b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8016bc:	01 c2                	add    %eax,%edx
  8016be:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8016c1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016c4:	01 c8                	add    %ecx,%eax
  8016c6:	8a 00                	mov    (%eax),%al
  8016c8:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  8016ca:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8016cd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016d0:	01 d0                	add    %edx,%eax
  8016d2:	8a 00                	mov    (%eax),%al
  8016d4:	3c 40                	cmp    $0x40,%al
  8016d6:	7e 25                	jle    8016fd <str2lower+0x5c>
  8016d8:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8016db:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016de:	01 d0                	add    %edx,%eax
  8016e0:	8a 00                	mov    (%eax),%al
  8016e2:	3c 5a                	cmp    $0x5a,%al
  8016e4:	7f 17                	jg     8016fd <str2lower+0x5c>
		{
			dst[i] += 32 ;
  8016e6:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8016e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8016ec:	01 d0                	add    %edx,%eax
  8016ee:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8016f1:	8b 55 08             	mov    0x8(%ebp),%edx
  8016f4:	01 ca                	add    %ecx,%edx
  8016f6:	8a 12                	mov    (%edx),%dl
  8016f8:	83 c2 20             	add    $0x20,%edx
  8016fb:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  8016fd:	ff 45 fc             	incl   -0x4(%ebp)
  801700:	ff 75 0c             	pushl  0xc(%ebp)
  801703:	e8 01 f8 ff ff       	call   800f09 <strlen>
  801708:	83 c4 04             	add    $0x4,%esp
  80170b:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80170e:	7f a6                	jg     8016b6 <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  801710:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801713:	c9                   	leave  
  801714:	c3                   	ret    

00801715 <uheap_init>:
//==============================================
// [1] INITIALIZE USER HEAP:
//==============================================
int __firstTimeFlag = 1;
void uheap_init()
{
  801715:	55                   	push   %ebp
  801716:	89 e5                	mov    %esp,%ebp
  801718:	83 ec 08             	sub    $0x8,%esp
	if(__firstTimeFlag)
  80171b:	a1 08 50 80 00       	mov    0x805008,%eax
  801720:	85 c0                	test   %eax,%eax
  801722:	0f 84 95 00 00 00    	je     8017bd <uheap_init+0xa8>
	{
		initialize_dynamic_allocator(USER_HEAP_START, USER_HEAP_START + DYN_ALLOC_MAX_SIZE);
  801728:	83 ec 08             	sub    $0x8,%esp
  80172b:	68 00 00 00 82       	push   $0x82000000
  801730:	68 00 00 00 80       	push   $0x80000000
  801735:	e8 59 1f 00 00       	call   803693 <initialize_dynamic_allocator>
  80173a:	83 c4 10             	add    $0x10,%esp
		uheapPlaceStrategy = sys_get_uheap_strategy();
  80173d:	e8 93 1d 00 00       	call   8034d5 <sys_get_uheap_strategy>
  801742:	a3 60 d0 81 00       	mov    %eax,0x81d060
		uheapPageAllocStart = dynAllocEnd + PAGE_SIZE;
  801747:	a1 40 50 80 00       	mov    0x805040,%eax
  80174c:	05 00 10 00 00       	add    $0x1000,%eax
  801751:	a3 10 d1 81 00       	mov    %eax,0x81d110
		uheapPageAllocBreak = uheapPageAllocStart;
  801756:	a1 10 d1 81 00       	mov    0x81d110,%eax
  80175b:	a3 68 d0 81 00       	mov    %eax,0x81d068
		init_uspinlock(&ulock,"malloc",1);
  801760:	83 ec 04             	sub    $0x4,%esp
  801763:	6a 01                	push   $0x1
  801765:	68 48 4c 80 00       	push   $0x804c48
  80176a:	68 40 d1 81 00       	push   $0x81d140
  80176f:	e8 1a 29 00 00       	call   80408e <init_uspinlock>
  801774:	83 c4 10             	add    $0x10,%esp
		LIST_INIT(&u_freelist);
  801777:	c7 05 20 d1 81 00 00 	movl   $0x0,0x81d120
  80177e:	00 00 00 
  801781:	c7 05 24 d1 81 00 00 	movl   $0x0,0x81d124
  801788:	00 00 00 
  80178b:	c7 05 2c d1 81 00 00 	movl   $0x0,0x81d12c
  801792:	00 00 00 
		LIST_INIT(&u_allocatedlist);
  801795:	c7 05 30 d1 81 00 00 	movl   $0x0,0x81d130
  80179c:	00 00 00 
  80179f:	c7 05 34 d1 81 00 00 	movl   $0x0,0x81d134
  8017a6:	00 00 00 
  8017a9:	c7 05 3c d1 81 00 00 	movl   $0x0,0x81d13c
  8017b0:	00 00 00 
		__firstTimeFlag = 0;
  8017b3:	c7 05 08 50 80 00 00 	movl   $0x0,0x805008
  8017ba:	00 00 00 
	}
}
  8017bd:	90                   	nop
  8017be:	c9                   	leave  
  8017bf:	c3                   	ret    

008017c0 <get_page>:

//==============================================
// [2] GET A PAGE FROM THE KERNEL FOR DA:
//==============================================
int get_page(void* va)
{
  8017c0:	55                   	push   %ebp
  8017c1:	89 e5                	mov    %esp,%ebp
  8017c3:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_allocate_page(ROUNDDOWN(va, PAGE_SIZE), PERM_USER|PERM_WRITEABLE|PERM_UHPAGE);
  8017c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8017c9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8017cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017cf:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8017d4:	83 ec 08             	sub    $0x8,%esp
  8017d7:	68 06 04 00 00       	push   $0x406
  8017dc:	50                   	push   %eax
  8017dd:	e8 3d 19 00 00       	call   80311f <__sys_allocate_page>
  8017e2:	83 c4 10             	add    $0x10,%esp
  8017e5:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  8017e8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8017ec:	79 14                	jns    801802 <get_page+0x42>
		panic("get_page() in user: failed to allocate page from the kernel");
  8017ee:	83 ec 04             	sub    $0x4,%esp
  8017f1:	68 50 4c 80 00       	push   $0x804c50
  8017f6:	6a 2d                	push   $0x2d
  8017f8:	68 8c 4c 80 00       	push   $0x804c8c
  8017fd:	e8 60 ed ff ff       	call   800562 <_panic>
	return 0;
  801802:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801807:	c9                   	leave  
  801808:	c3                   	ret    

00801809 <return_page>:

//==============================================
// [3] RETURN A PAGE FROM THE DA TO KERNEL:
//==============================================
void return_page(void* va)
{
  801809:	55                   	push   %ebp
  80180a:	89 e5                	mov    %esp,%ebp
  80180c:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_unmap_frame(ROUNDDOWN((uint32)va, PAGE_SIZE));
  80180f:	8b 45 08             	mov    0x8(%ebp),%eax
  801812:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801815:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801818:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80181d:	83 ec 0c             	sub    $0xc,%esp
  801820:	50                   	push   %eax
  801821:	e8 40 19 00 00       	call   803166 <__sys_unmap_frame>
  801826:	83 c4 10             	add    $0x10,%esp
  801829:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  80182c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801830:	79 14                	jns    801846 <return_page+0x3d>
		panic("return_page() in user: failed to return a page to the kernel");
  801832:	83 ec 04             	sub    $0x4,%esp
  801835:	68 98 4c 80 00       	push   $0x804c98
  80183a:	6a 38                	push   $0x38
  80183c:	68 8c 4c 80 00       	push   $0x804c8c
  801841:	e8 1c ed ff ff       	call   800562 <_panic>
}
  801846:	90                   	nop
  801847:	c9                   	leave  
  801848:	c3                   	ret    

00801849 <malloc>:

//=================================
// [1] ALLOCATE SPACE IN USER HEAP:
//=================================
void* malloc(uint32 size)
{
  801849:	55                   	push   %ebp
  80184a:	89 e5                	mov    %esp,%ebp
  80184c:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  80184f:	e8 c1 fe ff ff       	call   801715 <uheap_init>
	if (size == 0) return NULL ;
  801854:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801858:	75 0a                	jne    801864 <malloc+0x1b>
  80185a:	b8 00 00 00 00       	mov    $0x0,%eax
  80185f:	e9 e1 04 00 00       	jmp    801d45 <malloc+0x4fc>
	//==============================================================

	acquire_uspinlock(&ulock);
  801864:	83 ec 0c             	sub    $0xc,%esp
  801867:	68 40 d1 81 00       	push   $0x81d140
  80186c:	e8 6c 28 00 00       	call   8040dd <acquire_uspinlock>
  801871:	83 c4 10             	add    $0x10,%esp
	if(size <  DYN_ALLOC_MAX_BLOCK_SIZE){
  801874:	81 7d 08 ff 07 00 00 	cmpl   $0x7ff,0x8(%ebp)
  80187b:	77 23                	ja     8018a0 <malloc+0x57>
		release_uspinlock(&ulock);
  80187d:	83 ec 0c             	sub    $0xc,%esp
  801880:	68 40 d1 81 00       	push   $0x81d140
  801885:	e8 ab 28 00 00       	call   804135 <release_uspinlock>
  80188a:	83 c4 10             	add    $0x10,%esp
		return alloc_block(size);
  80188d:	83 ec 0c             	sub    $0xc,%esp
  801890:	ff 75 08             	pushl  0x8(%ebp)
  801893:	e8 dd 1f 00 00       	call   803875 <alloc_block>
  801898:	83 c4 10             	add    $0x10,%esp
  80189b:	e9 a5 04 00 00       	jmp    801d45 <malloc+0x4fc>
	}

	struct UserHeapStruct* allocblock= (struct UserHeapStruct*) alloc_block(sizeof(struct UserHeapStruct));
  8018a0:	83 ec 0c             	sub    $0xc,%esp
  8018a3:	6a 10                	push   $0x10
  8018a5:	e8 cb 1f 00 00       	call   803875 <alloc_block>
  8018aa:	83 c4 10             	add    $0x10,%esp
  8018ad:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (allocblock == NULL){
  8018b0:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8018b4:	75 0a                	jne    8018c0 <malloc+0x77>
			return NULL;
  8018b6:	b8 00 00 00 00       	mov    $0x0,%eax
  8018bb:	e9 85 04 00 00       	jmp    801d45 <malloc+0x4fc>
	}

	size = ROUNDUP(size,PAGE_SIZE);
  8018c0:	c7 45 e8 00 10 00 00 	movl   $0x1000,-0x18(%ebp)
  8018c7:	8b 55 08             	mov    0x8(%ebp),%edx
  8018ca:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8018cd:	01 d0                	add    %edx,%eax
  8018cf:	48                   	dec    %eax
  8018d0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8018d3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8018d6:	ba 00 00 00 00       	mov    $0x0,%edx
  8018db:	f7 75 e8             	divl   -0x18(%ebp)
  8018de:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8018e1:	29 d0                	sub    %edx,%eax
  8018e3:	89 45 08             	mov    %eax,0x8(%ebp)
	struct UserHeapStruct* lastfreeelement = LIST_LAST(&u_freelist);
  8018e6:	a1 24 d1 81 00       	mov    0x81d124,%eax
  8018eb:	89 45 e0             	mov    %eax,-0x20(%ebp)

	if(LIST_SIZE(&u_freelist)==0 || size>lastfreeelement->size){
  8018ee:	a1 2c d1 81 00       	mov    0x81d12c,%eax
  8018f3:	85 c0                	test   %eax,%eax
  8018f5:	74 0f                	je     801906 <malloc+0xbd>
  8018f7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8018fa:	8b 40 04             	mov    0x4(%eax),%eax
  8018fd:	3b 45 08             	cmp    0x8(%ebp),%eax
  801900:	0f 83 ea 00 00 00    	jae    8019f0 <malloc+0x1a7>
			if(uheapPageAllocBreak < USER_HEAP_MAX - size){
  801906:	b8 00 00 00 a0       	mov    $0xa0000000,%eax
  80190b:	2b 45 08             	sub    0x8(%ebp),%eax
  80190e:	89 c2                	mov    %eax,%edx
  801910:	a1 68 d0 81 00       	mov    0x81d068,%eax
  801915:	39 c2                	cmp    %eax,%edx
  801917:	0f 86 b9 00 00 00    	jbe    8019d6 <malloc+0x18d>
					uint32 requestedblockva = uheapPageAllocBreak;
  80191d:	a1 68 d0 81 00       	mov    0x81d068,%eax
  801922:	89 45 dc             	mov    %eax,-0x24(%ebp)
					uheapPageAllocBreak+=size;
  801925:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  80192b:	8b 45 08             	mov    0x8(%ebp),%eax
  80192e:	01 d0                	add    %edx,%eax
  801930:	a3 68 d0 81 00       	mov    %eax,0x81d068
					allocblock->startva = requestedblockva;
  801935:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801938:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80193b:	89 10                	mov    %edx,(%eax)
					allocblock->size = size;
  80193d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801940:	8b 55 08             	mov    0x8(%ebp),%edx
  801943:	89 50 04             	mov    %edx,0x4(%eax)

					LIST_INSERT_TAIL(&u_allocatedlist, allocblock);
  801946:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80194a:	75 14                	jne    801960 <malloc+0x117>
  80194c:	83 ec 04             	sub    $0x4,%esp
  80194f:	68 d8 4c 80 00       	push   $0x804cd8
  801954:	6a 60                	push   $0x60
  801956:	68 8c 4c 80 00       	push   $0x804c8c
  80195b:	e8 02 ec ff ff       	call   800562 <_panic>
  801960:	8b 15 34 d1 81 00    	mov    0x81d134,%edx
  801966:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801969:	89 50 0c             	mov    %edx,0xc(%eax)
  80196c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80196f:	8b 40 0c             	mov    0xc(%eax),%eax
  801972:	85 c0                	test   %eax,%eax
  801974:	74 0d                	je     801983 <malloc+0x13a>
  801976:	a1 34 d1 81 00       	mov    0x81d134,%eax
  80197b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80197e:	89 50 08             	mov    %edx,0x8(%eax)
  801981:	eb 08                	jmp    80198b <malloc+0x142>
  801983:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801986:	a3 30 d1 81 00       	mov    %eax,0x81d130
  80198b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80198e:	a3 34 d1 81 00       	mov    %eax,0x81d134
  801993:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801996:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  80199d:	a1 3c d1 81 00       	mov    0x81d13c,%eax
  8019a2:	40                   	inc    %eax
  8019a3:	a3 3c d1 81 00       	mov    %eax,0x81d13c


					sys_allocate_user_mem(allocblock->startva ,size);
  8019a8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8019ab:	8b 00                	mov    (%eax),%eax
  8019ad:	83 ec 08             	sub    $0x8,%esp
  8019b0:	ff 75 08             	pushl  0x8(%ebp)
  8019b3:	50                   	push   %eax
  8019b4:	e8 34 1c 00 00       	call   8035ed <sys_allocate_user_mem>
  8019b9:	83 c4 10             	add    $0x10,%esp
					release_uspinlock(&ulock);
  8019bc:	83 ec 0c             	sub    $0xc,%esp
  8019bf:	68 40 d1 81 00       	push   $0x81d140
  8019c4:	e8 6c 27 00 00       	call   804135 <release_uspinlock>
  8019c9:	83 c4 10             	add    $0x10,%esp
					return (void*)allocblock->startva;
  8019cc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8019cf:	8b 00                	mov    (%eax),%eax
  8019d1:	e9 6f 03 00 00       	jmp    801d45 <malloc+0x4fc>
			}else{
					release_uspinlock(&ulock);
  8019d6:	83 ec 0c             	sub    $0xc,%esp
  8019d9:	68 40 d1 81 00       	push   $0x81d140
  8019de:	e8 52 27 00 00       	call   804135 <release_uspinlock>
  8019e3:	83 c4 10             	add    $0x10,%esp
					return NULL;
  8019e6:	b8 00 00 00 00       	mov    $0x0,%eax
  8019eb:	e9 55 03 00 00       	jmp    801d45 <malloc+0x4fc>
				}
	}else{
		//custom fit
		struct UserHeapStruct* currentfreeelement = LIST_FIRST(&u_freelist);
  8019f0:	a1 20 d1 81 00       	mov    0x81d120,%eax
  8019f5:	89 45 f4             	mov    %eax,-0xc(%ebp)
		//worst fit
		while(currentfreeelement != NULL){
  8019f8:	e9 39 03 00 00       	jmp    801d36 <malloc+0x4ed>
			if(size<currentfreeelement->size){
  8019fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a00:	8b 40 04             	mov    0x4(%eax),%eax
  801a03:	3b 45 08             	cmp    0x8(%ebp),%eax
  801a06:	0f 86 e7 01 00 00    	jbe    801bf3 <malloc+0x3aa>
				allocblock->startva = lastfreeelement->startva;
  801a0c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801a0f:	8b 10                	mov    (%eax),%edx
  801a11:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801a14:	89 10                	mov    %edx,(%eax)
                allocblock->size = size;
  801a16:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801a19:	8b 55 08             	mov    0x8(%ebp),%edx
  801a1c:	89 50 04             	mov    %edx,0x4(%eax)
                LIST_INSERT_TAIL(&u_allocatedlist,allocblock);
  801a1f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801a23:	75 14                	jne    801a39 <malloc+0x1f0>
  801a25:	83 ec 04             	sub    $0x4,%esp
  801a28:	68 d8 4c 80 00       	push   $0x804cd8
  801a2d:	6a 72                	push   $0x72
  801a2f:	68 8c 4c 80 00       	push   $0x804c8c
  801a34:	e8 29 eb ff ff       	call   800562 <_panic>
  801a39:	8b 15 34 d1 81 00    	mov    0x81d134,%edx
  801a3f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801a42:	89 50 0c             	mov    %edx,0xc(%eax)
  801a45:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801a48:	8b 40 0c             	mov    0xc(%eax),%eax
  801a4b:	85 c0                	test   %eax,%eax
  801a4d:	74 0d                	je     801a5c <malloc+0x213>
  801a4f:	a1 34 d1 81 00       	mov    0x81d134,%eax
  801a54:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801a57:	89 50 08             	mov    %edx,0x8(%eax)
  801a5a:	eb 08                	jmp    801a64 <malloc+0x21b>
  801a5c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801a5f:	a3 30 d1 81 00       	mov    %eax,0x81d130
  801a64:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801a67:	a3 34 d1 81 00       	mov    %eax,0x81d134
  801a6c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801a6f:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  801a76:	a1 3c d1 81 00       	mov    0x81d13c,%eax
  801a7b:	40                   	inc    %eax
  801a7c:	a3 3c d1 81 00       	mov    %eax,0x81d13c
                lastfreeelement->startva += size;
  801a81:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801a84:	8b 10                	mov    (%eax),%edx
  801a86:	8b 45 08             	mov    0x8(%ebp),%eax
  801a89:	01 c2                	add    %eax,%edx
  801a8b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801a8e:	89 10                	mov    %edx,(%eax)
                lastfreeelement->size -= size;
  801a90:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801a93:	8b 40 04             	mov    0x4(%eax),%eax
  801a96:	2b 45 08             	sub    0x8(%ebp),%eax
  801a99:	89 c2                	mov    %eax,%edx
  801a9b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801a9e:	89 50 04             	mov    %edx,0x4(%eax)
                struct UserHeapStruct* currentfree2 = LIST_FIRST(&u_freelist);
  801aa1:	a1 20 d1 81 00       	mov    0x81d120,%eax
  801aa6:	89 45 f0             	mov    %eax,-0x10(%ebp)
                //check order of last element

                while (currentfree2 != NULL){
  801aa9:	e9 0d 01 00 00       	jmp    801bbb <malloc+0x372>
                	if(lastfreeelement->size <currentfree2->size){
  801aae:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801ab1:	8b 50 04             	mov    0x4(%eax),%edx
  801ab4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ab7:	8b 40 04             	mov    0x4(%eax),%eax
  801aba:	39 c2                	cmp    %eax,%edx
  801abc:	0f 83 f0 00 00 00    	jae    801bb2 <malloc+0x369>
                		LIST_REMOVE(&u_freelist ,lastfreeelement);
  801ac2:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801ac6:	75 14                	jne    801adc <malloc+0x293>
  801ac8:	83 ec 04             	sub    $0x4,%esp
  801acb:	68 fb 4c 80 00       	push   $0x804cfb
  801ad0:	6a 7a                	push   $0x7a
  801ad2:	68 8c 4c 80 00       	push   $0x804c8c
  801ad7:	e8 86 ea ff ff       	call   800562 <_panic>
  801adc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801adf:	8b 40 08             	mov    0x8(%eax),%eax
  801ae2:	85 c0                	test   %eax,%eax
  801ae4:	74 11                	je     801af7 <malloc+0x2ae>
  801ae6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801ae9:	8b 40 08             	mov    0x8(%eax),%eax
  801aec:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801aef:	8b 52 0c             	mov    0xc(%edx),%edx
  801af2:	89 50 0c             	mov    %edx,0xc(%eax)
  801af5:	eb 0b                	jmp    801b02 <malloc+0x2b9>
  801af7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801afa:	8b 40 0c             	mov    0xc(%eax),%eax
  801afd:	a3 24 d1 81 00       	mov    %eax,0x81d124
  801b02:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801b05:	8b 40 0c             	mov    0xc(%eax),%eax
  801b08:	85 c0                	test   %eax,%eax
  801b0a:	74 11                	je     801b1d <malloc+0x2d4>
  801b0c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801b0f:	8b 40 0c             	mov    0xc(%eax),%eax
  801b12:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801b15:	8b 52 08             	mov    0x8(%edx),%edx
  801b18:	89 50 08             	mov    %edx,0x8(%eax)
  801b1b:	eb 0b                	jmp    801b28 <malloc+0x2df>
  801b1d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801b20:	8b 40 08             	mov    0x8(%eax),%eax
  801b23:	a3 20 d1 81 00       	mov    %eax,0x81d120
  801b28:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801b2b:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  801b32:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801b35:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  801b3c:	a1 2c d1 81 00       	mov    0x81d12c,%eax
  801b41:	48                   	dec    %eax
  801b42:	a3 2c d1 81 00       	mov    %eax,0x81d12c
                		LIST_INSERT_BEFORE(&u_freelist ,currentfree2 ,lastfreeelement);
  801b47:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801b4b:	74 06                	je     801b53 <malloc+0x30a>
  801b4d:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801b51:	75 14                	jne    801b67 <malloc+0x31e>
  801b53:	83 ec 04             	sub    $0x4,%esp
  801b56:	68 1c 4d 80 00       	push   $0x804d1c
  801b5b:	6a 7b                	push   $0x7b
  801b5d:	68 8c 4c 80 00       	push   $0x804c8c
  801b62:	e8 fb e9 ff ff       	call   800562 <_panic>
  801b67:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b6a:	8b 50 0c             	mov    0xc(%eax),%edx
  801b6d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801b70:	89 50 0c             	mov    %edx,0xc(%eax)
  801b73:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801b76:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801b79:	89 50 08             	mov    %edx,0x8(%eax)
  801b7c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b7f:	8b 40 0c             	mov    0xc(%eax),%eax
  801b82:	85 c0                	test   %eax,%eax
  801b84:	74 0e                	je     801b94 <malloc+0x34b>
  801b86:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b89:	8b 40 0c             	mov    0xc(%eax),%eax
  801b8c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801b8f:	89 50 08             	mov    %edx,0x8(%eax)
  801b92:	eb 08                	jmp    801b9c <malloc+0x353>
  801b94:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801b97:	a3 20 d1 81 00       	mov    %eax,0x81d120
  801b9c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b9f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801ba2:	89 50 0c             	mov    %edx,0xc(%eax)
  801ba5:	a1 2c d1 81 00       	mov    0x81d12c,%eax
  801baa:	40                   	inc    %eax
  801bab:	a3 2c d1 81 00       	mov    %eax,0x81d12c
                		break;
  801bb0:	eb 13                	jmp    801bc5 <malloc+0x37c>
                	}
                	currentfree2 = currentfree2->prev_next_info.le_next;
  801bb2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801bb5:	8b 40 08             	mov    0x8(%eax),%eax
  801bb8:	89 45 f0             	mov    %eax,-0x10(%ebp)
                lastfreeelement->startva += size;
                lastfreeelement->size -= size;
                struct UserHeapStruct* currentfree2 = LIST_FIRST(&u_freelist);
                //check order of last element

                while (currentfree2 != NULL){
  801bbb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801bbf:	0f 85 e9 fe ff ff    	jne    801aae <malloc+0x265>
                	}
                	currentfree2 = currentfree2->prev_next_info.le_next;
                }


                sys_allocate_user_mem(allocblock->startva ,size);
  801bc5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801bc8:	8b 00                	mov    (%eax),%eax
  801bca:	83 ec 08             	sub    $0x8,%esp
  801bcd:	ff 75 08             	pushl  0x8(%ebp)
  801bd0:	50                   	push   %eax
  801bd1:	e8 17 1a 00 00       	call   8035ed <sys_allocate_user_mem>
  801bd6:	83 c4 10             	add    $0x10,%esp
                release_uspinlock(&ulock);
  801bd9:	83 ec 0c             	sub    $0xc,%esp
  801bdc:	68 40 d1 81 00       	push   $0x81d140
  801be1:	e8 4f 25 00 00       	call   804135 <release_uspinlock>
  801be6:	83 c4 10             	add    $0x10,%esp
                return (void*)allocblock->startva;
  801be9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801bec:	8b 00                	mov    (%eax),%eax
  801bee:	e9 52 01 00 00       	jmp    801d45 <malloc+0x4fc>
                //exact fit
			}else if(size == currentfreeelement->size){
  801bf3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bf6:	8b 40 04             	mov    0x4(%eax),%eax
  801bf9:	3b 45 08             	cmp    0x8(%ebp),%eax
  801bfc:	0f 85 2b 01 00 00    	jne    801d2d <malloc+0x4e4>
				allocblock->startva = currentfreeelement->startva;
  801c02:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c05:	8b 10                	mov    (%eax),%edx
  801c07:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801c0a:	89 10                	mov    %edx,(%eax)
				allocblock->size = size;
  801c0c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801c0f:	8b 55 08             	mov    0x8(%ebp),%edx
  801c12:	89 50 04             	mov    %edx,0x4(%eax)
				LIST_INSERT_TAIL(&u_allocatedlist ,allocblock);
  801c15:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801c19:	75 17                	jne    801c32 <malloc+0x3e9>
  801c1b:	83 ec 04             	sub    $0x4,%esp
  801c1e:	68 d8 4c 80 00       	push   $0x804cd8
  801c23:	68 89 00 00 00       	push   $0x89
  801c28:	68 8c 4c 80 00       	push   $0x804c8c
  801c2d:	e8 30 e9 ff ff       	call   800562 <_panic>
  801c32:	8b 15 34 d1 81 00    	mov    0x81d134,%edx
  801c38:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801c3b:	89 50 0c             	mov    %edx,0xc(%eax)
  801c3e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801c41:	8b 40 0c             	mov    0xc(%eax),%eax
  801c44:	85 c0                	test   %eax,%eax
  801c46:	74 0d                	je     801c55 <malloc+0x40c>
  801c48:	a1 34 d1 81 00       	mov    0x81d134,%eax
  801c4d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801c50:	89 50 08             	mov    %edx,0x8(%eax)
  801c53:	eb 08                	jmp    801c5d <malloc+0x414>
  801c55:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801c58:	a3 30 d1 81 00       	mov    %eax,0x81d130
  801c5d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801c60:	a3 34 d1 81 00       	mov    %eax,0x81d134
  801c65:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801c68:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  801c6f:	a1 3c d1 81 00       	mov    0x81d13c,%eax
  801c74:	40                   	inc    %eax
  801c75:	a3 3c d1 81 00       	mov    %eax,0x81d13c
				LIST_REMOVE(&u_freelist ,currentfreeelement);
  801c7a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801c7e:	75 17                	jne    801c97 <malloc+0x44e>
  801c80:	83 ec 04             	sub    $0x4,%esp
  801c83:	68 fb 4c 80 00       	push   $0x804cfb
  801c88:	68 8a 00 00 00       	push   $0x8a
  801c8d:	68 8c 4c 80 00       	push   $0x804c8c
  801c92:	e8 cb e8 ff ff       	call   800562 <_panic>
  801c97:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c9a:	8b 40 08             	mov    0x8(%eax),%eax
  801c9d:	85 c0                	test   %eax,%eax
  801c9f:	74 11                	je     801cb2 <malloc+0x469>
  801ca1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ca4:	8b 40 08             	mov    0x8(%eax),%eax
  801ca7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801caa:	8b 52 0c             	mov    0xc(%edx),%edx
  801cad:	89 50 0c             	mov    %edx,0xc(%eax)
  801cb0:	eb 0b                	jmp    801cbd <malloc+0x474>
  801cb2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cb5:	8b 40 0c             	mov    0xc(%eax),%eax
  801cb8:	a3 24 d1 81 00       	mov    %eax,0x81d124
  801cbd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cc0:	8b 40 0c             	mov    0xc(%eax),%eax
  801cc3:	85 c0                	test   %eax,%eax
  801cc5:	74 11                	je     801cd8 <malloc+0x48f>
  801cc7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cca:	8b 40 0c             	mov    0xc(%eax),%eax
  801ccd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801cd0:	8b 52 08             	mov    0x8(%edx),%edx
  801cd3:	89 50 08             	mov    %edx,0x8(%eax)
  801cd6:	eb 0b                	jmp    801ce3 <malloc+0x49a>
  801cd8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cdb:	8b 40 08             	mov    0x8(%eax),%eax
  801cde:	a3 20 d1 81 00       	mov    %eax,0x81d120
  801ce3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ce6:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  801ced:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cf0:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  801cf7:	a1 2c d1 81 00       	mov    0x81d12c,%eax
  801cfc:	48                   	dec    %eax
  801cfd:	a3 2c d1 81 00       	mov    %eax,0x81d12c
				sys_allocate_user_mem(allocblock->startva ,size);
  801d02:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801d05:	8b 00                	mov    (%eax),%eax
  801d07:	83 ec 08             	sub    $0x8,%esp
  801d0a:	ff 75 08             	pushl  0x8(%ebp)
  801d0d:	50                   	push   %eax
  801d0e:	e8 da 18 00 00       	call   8035ed <sys_allocate_user_mem>
  801d13:	83 c4 10             	add    $0x10,%esp
				release_uspinlock(&ulock);
  801d16:	83 ec 0c             	sub    $0xc,%esp
  801d19:	68 40 d1 81 00       	push   $0x81d140
  801d1e:	e8 12 24 00 00       	call   804135 <release_uspinlock>
  801d23:	83 c4 10             	add    $0x10,%esp
				return (void*)allocblock->startva;
  801d26:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801d29:	8b 00                	mov    (%eax),%eax
  801d2b:	eb 18                	jmp    801d45 <malloc+0x4fc>
			}
			currentfreeelement = currentfreeelement->prev_next_info.le_next;
  801d2d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d30:	8b 40 08             	mov    0x8(%eax),%eax
  801d33:	89 45 f4             	mov    %eax,-0xc(%ebp)
				}
	}else{
		//custom fit
		struct UserHeapStruct* currentfreeelement = LIST_FIRST(&u_freelist);
		//worst fit
		while(currentfreeelement != NULL){
  801d36:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801d3a:	0f 85 bd fc ff ff    	jne    8019fd <malloc+0x1b4>
				return (void*)allocblock->startva;
			}
			currentfreeelement = currentfreeelement->prev_next_info.le_next;
		}
	}
	 return NULL;
  801d40:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d45:	c9                   	leave  
  801d46:	c3                   	ret    

00801d47 <free>:

//=================================
// [2] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
  801d47:	55                   	push   %ebp
  801d48:	89 e5                	mov    %esp,%ebp
  801d4a:	83 ec 38             	sub    $0x38,%esp
	uint32  VA = ROUNDDOWN(((uint32 ) virtual_address), PAGE_SIZE);
  801d4d:	8b 45 08             	mov    0x8(%ebp),%eax
  801d50:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801d53:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801d56:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801d5b:	89 45 d8             	mov    %eax,-0x28(%ebp)


		uheap_init();
  801d5e:	e8 b2 f9 ff ff       	call   801715 <uheap_init>
		acquire_uspinlock(&ulock);
  801d63:	83 ec 0c             	sub    $0xc,%esp
  801d66:	68 40 d1 81 00       	push   $0x81d140
  801d6b:	e8 6d 23 00 00       	call   8040dd <acquire_uspinlock>
  801d70:	83 c4 10             	add    $0x10,%esp
		if (VA < uheapPageAllocStart){
  801d73:	a1 10 d1 81 00       	mov    0x81d110,%eax
  801d78:	39 45 d8             	cmp    %eax,-0x28(%ebp)
  801d7b:	73 23                	jae    801da0 <free+0x59>
			free_block(virtual_address);
  801d7d:	83 ec 0c             	sub    $0xc,%esp
  801d80:	ff 75 08             	pushl  0x8(%ebp)
  801d83:	e8 89 1f 00 00       	call   803d11 <free_block>
  801d88:	83 c4 10             	add    $0x10,%esp
			release_uspinlock(&ulock);
  801d8b:	83 ec 0c             	sub    $0xc,%esp
  801d8e:	68 40 d1 81 00       	push   $0x81d140
  801d93:	e8 9d 23 00 00       	call   804135 <release_uspinlock>
  801d98:	83 c4 10             	add    $0x10,%esp
			return;
  801d9b:	e9 35 07 00 00       	jmp    8024d5 <free+0x78e>
		}
		if (VA >= uheapPageAllocBreak){
  801da0:	a1 68 d0 81 00       	mov    0x81d068,%eax
  801da5:	39 45 d8             	cmp    %eax,-0x28(%ebp)
  801da8:	72 30                	jb     801dda <free+0x93>
			cprintf("%d\n %d\n", VA, uheapPageAllocBreak);
  801daa:	a1 68 d0 81 00       	mov    0x81d068,%eax
  801daf:	83 ec 04             	sub    $0x4,%esp
  801db2:	50                   	push   %eax
  801db3:	ff 75 d8             	pushl  -0x28(%ebp)
  801db6:	68 51 4d 80 00       	push   $0x804d51
  801dbb:	e8 70 ea ff ff       	call   800830 <cprintf>
  801dc0:	83 c4 10             	add    $0x10,%esp

			panic("freeing from restricted area");
  801dc3:	83 ec 04             	sub    $0x4,%esp
  801dc6:	68 59 4d 80 00       	push   $0x804d59
  801dcb:	68 a7 00 00 00       	push   $0xa7
  801dd0:	68 8c 4c 80 00       	push   $0x804c8c
  801dd5:	e8 88 e7 ff ff       	call   800562 <_panic>
			release_uspinlock(&ulock);
			return;
		}

		struct UserHeapStruct* newfree = (struct UserHeapStruct*) alloc_block(sizeof(struct UserHeapStruct));
  801dda:	83 ec 0c             	sub    $0xc,%esp
  801ddd:	6a 10                	push   $0x10
  801ddf:	e8 91 1a 00 00       	call   803875 <alloc_block>
  801de4:	83 c4 10             	add    $0x10,%esp
  801de7:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		struct UserHeapStruct* MergedBlock  = ( struct UserHeapStruct*)alloc_block(sizeof(struct UserHeapStruct));
  801dea:	83 ec 0c             	sub    $0xc,%esp
  801ded:	6a 10                	push   $0x10
  801def:	e8 81 1a 00 00       	call   803875 <alloc_block>
  801df4:	83 c4 10             	add    $0x10,%esp
  801df7:	89 45 d0             	mov    %eax,-0x30(%ebp)

		struct UserHeapStruct* ToBefreed = LIST_FIRST(&u_allocatedlist);
  801dfa:	a1 30 d1 81 00       	mov    0x81d130,%eax
  801dff:	89 45 f4             	mov    %eax,-0xc(%ebp)
		bool foundVA = 0;
  801e02:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

		//find the allocated block
		while(ToBefreed !=NULL ){
  801e09:	eb 1c                	jmp    801e27 <free+0xe0>

			if (VA ==ToBefreed->startva ){
  801e0b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e0e:	8b 00                	mov    (%eax),%eax
  801e10:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  801e13:	75 09                	jne    801e1e <free+0xd7>
				foundVA = 1;
  801e15:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
				break;
  801e1c:	eb 0f                	jmp    801e2d <free+0xe6>
			}
				ToBefreed = ToBefreed->prev_next_info.le_next;
  801e1e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e21:	8b 40 08             	mov    0x8(%eax),%eax
  801e24:	89 45 f4             	mov    %eax,-0xc(%ebp)

		struct UserHeapStruct* ToBefreed = LIST_FIRST(&u_allocatedlist);
		bool foundVA = 0;

		//find the allocated block
		while(ToBefreed !=NULL ){
  801e27:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801e2b:	75 de                	jne    801e0b <free+0xc4>
			}
				ToBefreed = ToBefreed->prev_next_info.le_next;
		}


		if(!foundVA){
  801e2d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801e31:	75 17                	jne    801e4a <free+0x103>
				panic("INVALID ADDRESS!");
  801e33:	83 ec 04             	sub    $0x4,%esp
  801e36:	68 76 4d 80 00       	push   $0x804d76
  801e3b:	68 be 00 00 00       	push   $0xbe
  801e40:	68 8c 4c 80 00       	push   $0x804c8c
  801e45:	e8 18 e7 ff ff       	call   800562 <_panic>
				release_uspinlock(&ulock);
				return;
			}


		newfree->startva = ToBefreed->startva;
  801e4a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e4d:	8b 10                	mov    (%eax),%edx
  801e4f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801e52:	89 10                	mov    %edx,(%eax)
		newfree->size = ToBefreed->size;
  801e54:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e57:	8b 50 04             	mov    0x4(%eax),%edx
  801e5a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801e5d:	89 50 04             	mov    %edx,0x4(%eax)

		//remove allocated block from alloclist
		LIST_REMOVE(&u_allocatedlist, ToBefreed);
  801e60:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801e64:	75 17                	jne    801e7d <free+0x136>
  801e66:	83 ec 04             	sub    $0x4,%esp
  801e69:	68 fb 4c 80 00       	push   $0x804cfb
  801e6e:	68 c8 00 00 00       	push   $0xc8
  801e73:	68 8c 4c 80 00       	push   $0x804c8c
  801e78:	e8 e5 e6 ff ff       	call   800562 <_panic>
  801e7d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e80:	8b 40 08             	mov    0x8(%eax),%eax
  801e83:	85 c0                	test   %eax,%eax
  801e85:	74 11                	je     801e98 <free+0x151>
  801e87:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e8a:	8b 40 08             	mov    0x8(%eax),%eax
  801e8d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e90:	8b 52 0c             	mov    0xc(%edx),%edx
  801e93:	89 50 0c             	mov    %edx,0xc(%eax)
  801e96:	eb 0b                	jmp    801ea3 <free+0x15c>
  801e98:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e9b:	8b 40 0c             	mov    0xc(%eax),%eax
  801e9e:	a3 34 d1 81 00       	mov    %eax,0x81d134
  801ea3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ea6:	8b 40 0c             	mov    0xc(%eax),%eax
  801ea9:	85 c0                	test   %eax,%eax
  801eab:	74 11                	je     801ebe <free+0x177>
  801ead:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801eb0:	8b 40 0c             	mov    0xc(%eax),%eax
  801eb3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801eb6:	8b 52 08             	mov    0x8(%edx),%edx
  801eb9:	89 50 08             	mov    %edx,0x8(%eax)
  801ebc:	eb 0b                	jmp    801ec9 <free+0x182>
  801ebe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ec1:	8b 40 08             	mov    0x8(%eax),%eax
  801ec4:	a3 30 d1 81 00       	mov    %eax,0x81d130
  801ec9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ecc:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  801ed3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ed6:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  801edd:	a1 3c d1 81 00       	mov    0x81d13c,%eax
  801ee2:	48                   	dec    %eax
  801ee3:	a3 3c d1 81 00       	mov    %eax,0x81d13c

		sys_free_user_mem(ToBefreed->startva, ToBefreed->size);
  801ee8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801eeb:	8b 50 04             	mov    0x4(%eax),%edx
  801eee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ef1:	8b 00                	mov    (%eax),%eax
  801ef3:	83 ec 08             	sub    $0x8,%esp
  801ef6:	52                   	push   %edx
  801ef7:	50                   	push   %eax
  801ef8:	e8 d4 16 00 00       	call   8035d1 <sys_free_user_mem>
  801efd:	83 c4 10             	add    $0x10,%esp




		if(LIST_SIZE(&u_freelist) == 0){
  801f00:	a1 2c d1 81 00       	mov    0x81d12c,%eax
  801f05:	85 c0                	test   %eax,%eax
  801f07:	75 7a                	jne    801f83 <free+0x23c>
			LIST_INSERT_HEAD(&u_freelist,newfree);
  801f09:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  801f0d:	75 17                	jne    801f26 <free+0x1df>
  801f0f:	83 ec 04             	sub    $0x4,%esp
  801f12:	68 88 4d 80 00       	push   $0x804d88
  801f17:	68 d0 00 00 00       	push   $0xd0
  801f1c:	68 8c 4c 80 00       	push   $0x804c8c
  801f21:	e8 3c e6 ff ff       	call   800562 <_panic>
  801f26:	8b 15 20 d1 81 00    	mov    0x81d120,%edx
  801f2c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801f2f:	89 50 08             	mov    %edx,0x8(%eax)
  801f32:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801f35:	8b 40 08             	mov    0x8(%eax),%eax
  801f38:	85 c0                	test   %eax,%eax
  801f3a:	74 0d                	je     801f49 <free+0x202>
  801f3c:	a1 20 d1 81 00       	mov    0x81d120,%eax
  801f41:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  801f44:	89 50 0c             	mov    %edx,0xc(%eax)
  801f47:	eb 08                	jmp    801f51 <free+0x20a>
  801f49:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801f4c:	a3 24 d1 81 00       	mov    %eax,0x81d124
  801f51:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801f54:	a3 20 d1 81 00       	mov    %eax,0x81d120
  801f59:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801f5c:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  801f63:	a1 2c d1 81 00       	mov    0x81d12c,%eax
  801f68:	40                   	inc    %eax
  801f69:	a3 2c d1 81 00       	mov    %eax,0x81d12c
			release_uspinlock(&ulock);
  801f6e:	83 ec 0c             	sub    $0xc,%esp
  801f71:	68 40 d1 81 00       	push   $0x81d140
  801f76:	e8 ba 21 00 00       	call   804135 <release_uspinlock>
  801f7b:	83 c4 10             	add    $0x10,%esp
			return;
  801f7e:	e9 52 05 00 00       	jmp    8024d5 <free+0x78e>
		}


		struct UserHeapStruct* ToBeMerged = LIST_FIRST(&u_freelist);
  801f83:	a1 20 d1 81 00       	mov    0x81d120,%eax
  801f88:	89 45 ec             	mov    %eax,-0x14(%ebp)
		// merge with prev if possible
		bool mergeprev = 0;
  801f8b:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		bool mergenext = 0;
  801f92:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
		while(ToBeMerged != NULL){
  801f99:	e9 d2 00 00 00       	jmp    802070 <free+0x329>
			if((ToBeMerged->startva +ToBeMerged->size) == newfree->startva){
  801f9e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801fa1:	8b 10                	mov    (%eax),%edx
  801fa3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801fa6:	8b 40 04             	mov    0x4(%eax),%eax
  801fa9:	01 c2                	add    %eax,%edx
  801fab:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801fae:	8b 00                	mov    (%eax),%eax
  801fb0:	39 c2                	cmp    %eax,%edx
  801fb2:	0f 85 af 00 00 00    	jne    802067 <free+0x320>

				MergedBlock->startva = ToBeMerged->startva;
  801fb8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801fbb:	8b 10                	mov    (%eax),%edx
  801fbd:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801fc0:	89 10                	mov    %edx,(%eax)
				MergedBlock->size = ToBeMerged->size + newfree->size;
  801fc2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801fc5:	8b 50 04             	mov    0x4(%eax),%edx
  801fc8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801fcb:	8b 40 04             	mov    0x4(%eax),%eax
  801fce:	01 c2                	add    %eax,%edx
  801fd0:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801fd3:	89 50 04             	mov    %edx,0x4(%eax)
				LIST_REMOVE(&u_freelist, ToBeMerged);
  801fd6:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801fda:	75 17                	jne    801ff3 <free+0x2ac>
  801fdc:	83 ec 04             	sub    $0x4,%esp
  801fdf:	68 fb 4c 80 00       	push   $0x804cfb
  801fe4:	68 df 00 00 00       	push   $0xdf
  801fe9:	68 8c 4c 80 00       	push   $0x804c8c
  801fee:	e8 6f e5 ff ff       	call   800562 <_panic>
  801ff3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801ff6:	8b 40 08             	mov    0x8(%eax),%eax
  801ff9:	85 c0                	test   %eax,%eax
  801ffb:	74 11                	je     80200e <free+0x2c7>
  801ffd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802000:	8b 40 08             	mov    0x8(%eax),%eax
  802003:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802006:	8b 52 0c             	mov    0xc(%edx),%edx
  802009:	89 50 0c             	mov    %edx,0xc(%eax)
  80200c:	eb 0b                	jmp    802019 <free+0x2d2>
  80200e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802011:	8b 40 0c             	mov    0xc(%eax),%eax
  802014:	a3 24 d1 81 00       	mov    %eax,0x81d124
  802019:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80201c:	8b 40 0c             	mov    0xc(%eax),%eax
  80201f:	85 c0                	test   %eax,%eax
  802021:	74 11                	je     802034 <free+0x2ed>
  802023:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802026:	8b 40 0c             	mov    0xc(%eax),%eax
  802029:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80202c:	8b 52 08             	mov    0x8(%edx),%edx
  80202f:	89 50 08             	mov    %edx,0x8(%eax)
  802032:	eb 0b                	jmp    80203f <free+0x2f8>
  802034:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802037:	8b 40 08             	mov    0x8(%eax),%eax
  80203a:	a3 20 d1 81 00       	mov    %eax,0x81d120
  80203f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802042:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802049:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80204c:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  802053:	a1 2c d1 81 00       	mov    0x81d12c,%eax
  802058:	48                   	dec    %eax
  802059:	a3 2c d1 81 00       	mov    %eax,0x81d12c
				mergeprev = 1;
  80205e:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
				break;
  802065:	eb 13                	jmp    80207a <free+0x333>
			}
				ToBeMerged = ToBeMerged->prev_next_info.le_next;
  802067:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80206a:	8b 40 08             	mov    0x8(%eax),%eax
  80206d:	89 45 ec             	mov    %eax,-0x14(%ebp)

		struct UserHeapStruct* ToBeMerged = LIST_FIRST(&u_freelist);
		// merge with prev if possible
		bool mergeprev = 0;
		bool mergenext = 0;
		while(ToBeMerged != NULL){
  802070:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802074:	0f 85 24 ff ff ff    	jne    801f9e <free+0x257>
//									uheapPageAllocBreak = newfree->startva;
//						}
//					}


		if ( newfree ->startva + newfree->size == uheapPageAllocBreak){
  80207a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80207d:	8b 10                	mov    (%eax),%edx
  80207f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802082:	8b 40 04             	mov    0x4(%eax),%eax
  802085:	01 c2                	add    %eax,%edx
  802087:	a1 68 d0 81 00       	mov    0x81d068,%eax
  80208c:	39 c2                	cmp    %eax,%edx
  80208e:	75 44                	jne    8020d4 <free+0x38d>

			if(mergeprev){
  802090:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802094:	74 1f                	je     8020b5 <free+0x36e>
				uheapPageAllocBreak = MergedBlock->startva;
  802096:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802099:	8b 00                	mov    (%eax),%eax
  80209b:	a3 68 d0 81 00       	mov    %eax,0x81d068
				release_uspinlock(&ulock);
  8020a0:	83 ec 0c             	sub    $0xc,%esp
  8020a3:	68 40 d1 81 00       	push   $0x81d140
  8020a8:	e8 88 20 00 00       	call   804135 <release_uspinlock>
  8020ad:	83 c4 10             	add    $0x10,%esp
				return;
  8020b0:	e9 20 04 00 00       	jmp    8024d5 <free+0x78e>

			}else{
				uheapPageAllocBreak = newfree->startva;
  8020b5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8020b8:	8b 00                	mov    (%eax),%eax
  8020ba:	a3 68 d0 81 00       	mov    %eax,0x81d068
				release_uspinlock(&ulock);
  8020bf:	83 ec 0c             	sub    $0xc,%esp
  8020c2:	68 40 d1 81 00       	push   $0x81d140
  8020c7:	e8 69 20 00 00       	call   804135 <release_uspinlock>
  8020cc:	83 c4 10             	add    $0x10,%esp
				return;
  8020cf:	e9 01 04 00 00       	jmp    8024d5 <free+0x78e>

		}


		//check if block is merged with prev ,and find possible merge with next
		ToBeMerged = LIST_FIRST(&u_freelist);
  8020d4:	a1 20 d1 81 00       	mov    0x81d120,%eax
  8020d9:	89 45 ec             	mov    %eax,-0x14(%ebp)
		while(ToBeMerged != NULL){
  8020dc:	e9 7d 01 00 00       	jmp    80225e <free+0x517>
			if ((newfree->startva + newfree->size) == ToBeMerged->startva ){
  8020e1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8020e4:	8b 10                	mov    (%eax),%edx
  8020e6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8020e9:	8b 40 04             	mov    0x4(%eax),%eax
  8020ec:	01 c2                	add    %eax,%edx
  8020ee:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8020f1:	8b 00                	mov    (%eax),%eax
  8020f3:	39 c2                	cmp    %eax,%edx
  8020f5:	0f 85 5a 01 00 00    	jne    802255 <free+0x50e>
				if (mergeprev){
  8020fb:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8020ff:	0f 84 a1 00 00 00    	je     8021a6 <free+0x45f>
					MergedBlock->size += ToBeMerged->size;
  802105:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802108:	8b 50 04             	mov    0x4(%eax),%edx
  80210b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80210e:	8b 40 04             	mov    0x4(%eax),%eax
  802111:	01 c2                	add    %eax,%edx
  802113:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802116:	89 50 04             	mov    %edx,0x4(%eax)
					LIST_REMOVE(&u_freelist, ToBeMerged);
  802119:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80211d:	75 17                	jne    802136 <free+0x3ef>
  80211f:	83 ec 04             	sub    $0x4,%esp
  802122:	68 fb 4c 80 00       	push   $0x804cfb
  802127:	68 0a 01 00 00       	push   $0x10a
  80212c:	68 8c 4c 80 00       	push   $0x804c8c
  802131:	e8 2c e4 ff ff       	call   800562 <_panic>
  802136:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802139:	8b 40 08             	mov    0x8(%eax),%eax
  80213c:	85 c0                	test   %eax,%eax
  80213e:	74 11                	je     802151 <free+0x40a>
  802140:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802143:	8b 40 08             	mov    0x8(%eax),%eax
  802146:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802149:	8b 52 0c             	mov    0xc(%edx),%edx
  80214c:	89 50 0c             	mov    %edx,0xc(%eax)
  80214f:	eb 0b                	jmp    80215c <free+0x415>
  802151:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802154:	8b 40 0c             	mov    0xc(%eax),%eax
  802157:	a3 24 d1 81 00       	mov    %eax,0x81d124
  80215c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80215f:	8b 40 0c             	mov    0xc(%eax),%eax
  802162:	85 c0                	test   %eax,%eax
  802164:	74 11                	je     802177 <free+0x430>
  802166:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802169:	8b 40 0c             	mov    0xc(%eax),%eax
  80216c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80216f:	8b 52 08             	mov    0x8(%edx),%edx
  802172:	89 50 08             	mov    %edx,0x8(%eax)
  802175:	eb 0b                	jmp    802182 <free+0x43b>
  802177:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80217a:	8b 40 08             	mov    0x8(%eax),%eax
  80217d:	a3 20 d1 81 00       	mov    %eax,0x81d120
  802182:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802185:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  80218c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80218f:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  802196:	a1 2c d1 81 00       	mov    0x81d12c,%eax
  80219b:	48                   	dec    %eax
  80219c:	a3 2c d1 81 00       	mov    %eax,0x81d12c
					break;
  8021a1:	e9 c2 00 00 00       	jmp    802268 <free+0x521>
		//if not merged find possible merge with next
				}else{
					MergedBlock->startva = newfree->startva;
  8021a6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8021a9:	8b 10                	mov    (%eax),%edx
  8021ab:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8021ae:	89 10                	mov    %edx,(%eax)
					MergedBlock->size  = newfree->size + ToBeMerged->size;
  8021b0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8021b3:	8b 50 04             	mov    0x4(%eax),%edx
  8021b6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8021b9:	8b 40 04             	mov    0x4(%eax),%eax
  8021bc:	01 c2                	add    %eax,%edx
  8021be:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8021c1:	89 50 04             	mov    %edx,0x4(%eax)
					LIST_REMOVE(&u_freelist, ToBeMerged);
  8021c4:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8021c8:	75 17                	jne    8021e1 <free+0x49a>
  8021ca:	83 ec 04             	sub    $0x4,%esp
  8021cd:	68 fb 4c 80 00       	push   $0x804cfb
  8021d2:	68 10 01 00 00       	push   $0x110
  8021d7:	68 8c 4c 80 00       	push   $0x804c8c
  8021dc:	e8 81 e3 ff ff       	call   800562 <_panic>
  8021e1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8021e4:	8b 40 08             	mov    0x8(%eax),%eax
  8021e7:	85 c0                	test   %eax,%eax
  8021e9:	74 11                	je     8021fc <free+0x4b5>
  8021eb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8021ee:	8b 40 08             	mov    0x8(%eax),%eax
  8021f1:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8021f4:	8b 52 0c             	mov    0xc(%edx),%edx
  8021f7:	89 50 0c             	mov    %edx,0xc(%eax)
  8021fa:	eb 0b                	jmp    802207 <free+0x4c0>
  8021fc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8021ff:	8b 40 0c             	mov    0xc(%eax),%eax
  802202:	a3 24 d1 81 00       	mov    %eax,0x81d124
  802207:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80220a:	8b 40 0c             	mov    0xc(%eax),%eax
  80220d:	85 c0                	test   %eax,%eax
  80220f:	74 11                	je     802222 <free+0x4db>
  802211:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802214:	8b 40 0c             	mov    0xc(%eax),%eax
  802217:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80221a:	8b 52 08             	mov    0x8(%edx),%edx
  80221d:	89 50 08             	mov    %edx,0x8(%eax)
  802220:	eb 0b                	jmp    80222d <free+0x4e6>
  802222:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802225:	8b 40 08             	mov    0x8(%eax),%eax
  802228:	a3 20 d1 81 00       	mov    %eax,0x81d120
  80222d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802230:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802237:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80223a:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  802241:	a1 2c d1 81 00       	mov    0x81d12c,%eax
  802246:	48                   	dec    %eax
  802247:	a3 2c d1 81 00       	mov    %eax,0x81d12c
					mergenext = 1;
  80224c:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
					break;
  802253:	eb 13                	jmp    802268 <free+0x521>
				}
			}
			ToBeMerged = ToBeMerged->prev_next_info.le_next;
  802255:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802258:	8b 40 08             	mov    0x8(%eax),%eax
  80225b:	89 45 ec             	mov    %eax,-0x14(%ebp)
		}


		//check if block is merged with prev ,and find possible merge with next
		ToBeMerged = LIST_FIRST(&u_freelist);
		while(ToBeMerged != NULL){
  80225e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802262:	0f 85 79 fe ff ff    	jne    8020e1 <free+0x39a>




			// insertion
			struct UserHeapStruct* currentfree = LIST_FIRST(&u_freelist);
  802268:	a1 20 d1 81 00       	mov    0x81d120,%eax
  80226d:	89 45 e0             	mov    %eax,-0x20(%ebp)

			if(mergeprev || mergenext){
  802270:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802274:	0f 85 ad 00 00 00    	jne    802327 <free+0x5e0>
  80227a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80227e:	0f 84 c3 01 00 00    	je     802447 <free+0x700>
				while(currentfree != NULL){
  802284:	e9 9e 00 00 00       	jmp    802327 <free+0x5e0>
					if(MergedBlock->size < currentfree->size){
  802289:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80228c:	8b 50 04             	mov    0x4(%eax),%edx
  80228f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802292:	8b 40 04             	mov    0x4(%eax),%eax
  802295:	39 c2                	cmp    %eax,%edx
  802297:	0f 83 81 00 00 00    	jae    80231e <free+0x5d7>

							LIST_INSERT_BEFORE(&u_freelist,currentfree,MergedBlock);
  80229d:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8022a1:	74 06                	je     8022a9 <free+0x562>
  8022a3:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  8022a7:	75 17                	jne    8022c0 <free+0x579>
  8022a9:	83 ec 04             	sub    $0x4,%esp
  8022ac:	68 1c 4d 80 00       	push   $0x804d1c
  8022b1:	68 23 01 00 00       	push   $0x123
  8022b6:	68 8c 4c 80 00       	push   $0x804c8c
  8022bb:	e8 a2 e2 ff ff       	call   800562 <_panic>
  8022c0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8022c3:	8b 50 0c             	mov    0xc(%eax),%edx
  8022c6:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8022c9:	89 50 0c             	mov    %edx,0xc(%eax)
  8022cc:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8022cf:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8022d2:	89 50 08             	mov    %edx,0x8(%eax)
  8022d5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8022d8:	8b 40 0c             	mov    0xc(%eax),%eax
  8022db:	85 c0                	test   %eax,%eax
  8022dd:	74 0e                	je     8022ed <free+0x5a6>
  8022df:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8022e2:	8b 40 0c             	mov    0xc(%eax),%eax
  8022e5:	8b 55 d0             	mov    -0x30(%ebp),%edx
  8022e8:	89 50 08             	mov    %edx,0x8(%eax)
  8022eb:	eb 08                	jmp    8022f5 <free+0x5ae>
  8022ed:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8022f0:	a3 20 d1 81 00       	mov    %eax,0x81d120
  8022f5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8022f8:	8b 55 d0             	mov    -0x30(%ebp),%edx
  8022fb:	89 50 0c             	mov    %edx,0xc(%eax)
  8022fe:	a1 2c d1 81 00       	mov    0x81d12c,%eax
  802303:	40                   	inc    %eax
  802304:	a3 2c d1 81 00       	mov    %eax,0x81d12c
							release_uspinlock(&ulock);
  802309:	83 ec 0c             	sub    $0xc,%esp
  80230c:	68 40 d1 81 00       	push   $0x81d140
  802311:	e8 1f 1e 00 00       	call   804135 <release_uspinlock>
  802316:	83 c4 10             	add    $0x10,%esp
							return;
  802319:	e9 b7 01 00 00       	jmp    8024d5 <free+0x78e>
					}
							currentfree = currentfree->prev_next_info.le_next;
  80231e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802321:	8b 40 08             	mov    0x8(%eax),%eax
  802324:	89 45 e0             	mov    %eax,-0x20(%ebp)

			// insertion
			struct UserHeapStruct* currentfree = LIST_FIRST(&u_freelist);

			if(mergeprev || mergenext){
				while(currentfree != NULL){
  802327:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80232b:	0f 85 58 ff ff ff    	jne    802289 <free+0x542>
							release_uspinlock(&ulock);
							return;
					}
							currentfree = currentfree->prev_next_info.le_next;
				}
				free_block(newfree);
  802331:	83 ec 0c             	sub    $0xc,%esp
  802334:	ff 75 d4             	pushl  -0x2c(%ebp)
  802337:	e8 d5 19 00 00       	call   803d11 <free_block>
  80233c:	83 c4 10             	add    $0x10,%esp
				LIST_INSERT_TAIL(&u_freelist,MergedBlock);
  80233f:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  802343:	75 17                	jne    80235c <free+0x615>
  802345:	83 ec 04             	sub    $0x4,%esp
  802348:	68 d8 4c 80 00       	push   $0x804cd8
  80234d:	68 2a 01 00 00       	push   $0x12a
  802352:	68 8c 4c 80 00       	push   $0x804c8c
  802357:	e8 06 e2 ff ff       	call   800562 <_panic>
  80235c:	8b 15 24 d1 81 00    	mov    0x81d124,%edx
  802362:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802365:	89 50 0c             	mov    %edx,0xc(%eax)
  802368:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80236b:	8b 40 0c             	mov    0xc(%eax),%eax
  80236e:	85 c0                	test   %eax,%eax
  802370:	74 0d                	je     80237f <free+0x638>
  802372:	a1 24 d1 81 00       	mov    0x81d124,%eax
  802377:	8b 55 d0             	mov    -0x30(%ebp),%edx
  80237a:	89 50 08             	mov    %edx,0x8(%eax)
  80237d:	eb 08                	jmp    802387 <free+0x640>
  80237f:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802382:	a3 20 d1 81 00       	mov    %eax,0x81d120
  802387:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80238a:	a3 24 d1 81 00       	mov    %eax,0x81d124
  80238f:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802392:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802399:	a1 2c d1 81 00       	mov    0x81d12c,%eax
  80239e:	40                   	inc    %eax
  80239f:	a3 2c d1 81 00       	mov    %eax,0x81d12c
  8023a4:	e9 1b 01 00 00       	jmp    8024c4 <free+0x77d>

			}else{
				while(currentfree != NULL){
					if(newfree->size < currentfree->size){
  8023a9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8023ac:	8b 50 04             	mov    0x4(%eax),%edx
  8023af:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8023b2:	8b 40 04             	mov    0x4(%eax),%eax
  8023b5:	39 c2                	cmp    %eax,%edx
  8023b7:	0f 83 81 00 00 00    	jae    80243e <free+0x6f7>

							LIST_INSERT_BEFORE(&u_freelist,currentfree,newfree);
  8023bd:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8023c1:	74 06                	je     8023c9 <free+0x682>
  8023c3:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8023c7:	75 17                	jne    8023e0 <free+0x699>
  8023c9:	83 ec 04             	sub    $0x4,%esp
  8023cc:	68 1c 4d 80 00       	push   $0x804d1c
  8023d1:	68 30 01 00 00       	push   $0x130
  8023d6:	68 8c 4c 80 00       	push   $0x804c8c
  8023db:	e8 82 e1 ff ff       	call   800562 <_panic>
  8023e0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8023e3:	8b 50 0c             	mov    0xc(%eax),%edx
  8023e6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8023e9:	89 50 0c             	mov    %edx,0xc(%eax)
  8023ec:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8023ef:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8023f2:	89 50 08             	mov    %edx,0x8(%eax)
  8023f5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8023f8:	8b 40 0c             	mov    0xc(%eax),%eax
  8023fb:	85 c0                	test   %eax,%eax
  8023fd:	74 0e                	je     80240d <free+0x6c6>
  8023ff:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802402:	8b 40 0c             	mov    0xc(%eax),%eax
  802405:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802408:	89 50 08             	mov    %edx,0x8(%eax)
  80240b:	eb 08                	jmp    802415 <free+0x6ce>
  80240d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802410:	a3 20 d1 81 00       	mov    %eax,0x81d120
  802415:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802418:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80241b:	89 50 0c             	mov    %edx,0xc(%eax)
  80241e:	a1 2c d1 81 00       	mov    0x81d12c,%eax
  802423:	40                   	inc    %eax
  802424:	a3 2c d1 81 00       	mov    %eax,0x81d12c
							release_uspinlock(&ulock);
  802429:	83 ec 0c             	sub    $0xc,%esp
  80242c:	68 40 d1 81 00       	push   $0x81d140
  802431:	e8 ff 1c 00 00       	call   804135 <release_uspinlock>
  802436:	83 c4 10             	add    $0x10,%esp
							return;
  802439:	e9 97 00 00 00       	jmp    8024d5 <free+0x78e>
					}
							currentfree = currentfree->prev_next_info.le_next;
  80243e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802441:	8b 40 08             	mov    0x8(%eax),%eax
  802444:	89 45 e0             	mov    %eax,-0x20(%ebp)
				}
				free_block(newfree);
				LIST_INSERT_TAIL(&u_freelist,MergedBlock);

			}else{
				while(currentfree != NULL){
  802447:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80244b:	0f 85 58 ff ff ff    	jne    8023a9 <free+0x662>
							release_uspinlock(&ulock);
							return;
					}
							currentfree = currentfree->prev_next_info.le_next;
				}
				free_block(MergedBlock);
  802451:	83 ec 0c             	sub    $0xc,%esp
  802454:	ff 75 d0             	pushl  -0x30(%ebp)
  802457:	e8 b5 18 00 00       	call   803d11 <free_block>
  80245c:	83 c4 10             	add    $0x10,%esp
				LIST_INSERT_TAIL(&u_freelist,newfree);
  80245f:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  802463:	75 17                	jne    80247c <free+0x735>
  802465:	83 ec 04             	sub    $0x4,%esp
  802468:	68 d8 4c 80 00       	push   $0x804cd8
  80246d:	68 37 01 00 00       	push   $0x137
  802472:	68 8c 4c 80 00       	push   $0x804c8c
  802477:	e8 e6 e0 ff ff       	call   800562 <_panic>
  80247c:	8b 15 24 d1 81 00    	mov    0x81d124,%edx
  802482:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802485:	89 50 0c             	mov    %edx,0xc(%eax)
  802488:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80248b:	8b 40 0c             	mov    0xc(%eax),%eax
  80248e:	85 c0                	test   %eax,%eax
  802490:	74 0d                	je     80249f <free+0x758>
  802492:	a1 24 d1 81 00       	mov    0x81d124,%eax
  802497:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80249a:	89 50 08             	mov    %edx,0x8(%eax)
  80249d:	eb 08                	jmp    8024a7 <free+0x760>
  80249f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8024a2:	a3 20 d1 81 00       	mov    %eax,0x81d120
  8024a7:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8024aa:	a3 24 d1 81 00       	mov    %eax,0x81d124
  8024af:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8024b2:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  8024b9:	a1 2c d1 81 00       	mov    0x81d12c,%eax
  8024be:	40                   	inc    %eax
  8024bf:	a3 2c d1 81 00       	mov    %eax,0x81d12c
			}
		release_uspinlock(&ulock);
  8024c4:	83 ec 0c             	sub    $0xc,%esp
  8024c7:	68 40 d1 81 00       	push   $0x81d140
  8024cc:	e8 64 1c 00 00       	call   804135 <release_uspinlock>
  8024d1:	83 c4 10             	add    $0x10,%esp
		return;
  8024d4:	90                   	nop
}
  8024d5:	c9                   	leave  
  8024d6:	c3                   	ret    

008024d7 <smalloc>:

//=================================
// [3] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  8024d7:	55                   	push   %ebp
  8024d8:	89 e5                	mov    %esp,%ebp
  8024da:	83 ec 48             	sub    $0x48,%esp
  8024dd:	8b 45 10             	mov    0x10(%ebp),%eax
  8024e0:	88 45 c4             	mov    %al,-0x3c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  8024e3:	e8 2d f2 ff ff       	call   801715 <uheap_init>
	if (size == 0) return NULL;
  8024e8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8024ec:	75 0a                	jne    8024f8 <smalloc+0x21>
  8024ee:	b8 00 00 00 00       	mov    $0x0,%eax
  8024f3:	e9 84 05 00 00       	jmp    802a7c <smalloc+0x5a5>
	//==============================================================
	acquire_uspinlock(&ulock);
  8024f8:	83 ec 0c             	sub    $0xc,%esp
  8024fb:	68 40 d1 81 00       	push   $0x81d140
  802500:	e8 d8 1b 00 00       	call   8040dd <acquire_uspinlock>
  802505:	83 c4 10             	add    $0x10,%esp

	struct UserHeapStruct* allocblock = (struct UserHeapStruct*) alloc_block(sizeof(struct UserHeapStruct));
  802508:	83 ec 0c             	sub    $0xc,%esp
  80250b:	6a 10                	push   $0x10
  80250d:	e8 63 13 00 00       	call   803875 <alloc_block>
  802512:	83 c4 10             	add    $0x10,%esp
  802515:	89 45 ec             	mov    %eax,-0x14(%ebp)
	if (allocblock == NULL){
  802518:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80251c:	75 0a                	jne    802528 <smalloc+0x51>
				return NULL;
  80251e:	b8 00 00 00 00       	mov    $0x0,%eax
  802523:	e9 54 05 00 00       	jmp    802a7c <smalloc+0x5a5>
	}
		size = ROUNDUP(size,PAGE_SIZE);
  802528:	c7 45 e8 00 10 00 00 	movl   $0x1000,-0x18(%ebp)
  80252f:	8b 55 0c             	mov    0xc(%ebp),%edx
  802532:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802535:	01 d0                	add    %edx,%eax
  802537:	48                   	dec    %eax
  802538:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80253b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80253e:	ba 00 00 00 00       	mov    $0x0,%edx
  802543:	f7 75 e8             	divl   -0x18(%ebp)
  802546:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802549:	29 d0                	sub    %edx,%eax
  80254b:	89 45 0c             	mov    %eax,0xc(%ebp)
		struct UserHeapStruct* lastfreeelement = LIST_LAST(&u_freelist);
  80254e:	a1 24 d1 81 00       	mov    0x81d124,%eax
  802553:	89 45 e0             	mov    %eax,-0x20(%ebp)

		if(LIST_SIZE(&u_freelist)==0 || size>lastfreeelement->size){
  802556:	a1 2c d1 81 00       	mov    0x81d12c,%eax
  80255b:	85 c0                	test   %eax,%eax
  80255d:	74 0f                	je     80256e <smalloc+0x97>
  80255f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802562:	8b 40 04             	mov    0x4(%eax),%eax
  802565:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802568:	0f 83 25 01 00 00    	jae    802693 <smalloc+0x1bc>
				if(uheapPageAllocBreak <= USER_HEAP_MAX - size){
  80256e:	b8 00 00 00 a0       	mov    $0xa0000000,%eax
  802573:	2b 45 0c             	sub    0xc(%ebp),%eax
  802576:	89 c2                	mov    %eax,%edx
  802578:	a1 68 d0 81 00       	mov    0x81d068,%eax
  80257d:	39 c2                	cmp    %eax,%edx
  80257f:	0f 82 f4 00 00 00    	jb     802679 <smalloc+0x1a2>
						uint32 requestedblockva = uheapPageAllocBreak;
  802585:	a1 68 d0 81 00       	mov    0x81d068,%eax
  80258a:	89 45 d4             	mov    %eax,-0x2c(%ebp)
						uheapPageAllocBreak+=size;
  80258d:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  802593:	8b 45 0c             	mov    0xc(%ebp),%eax
  802596:	01 d0                	add    %edx,%eax
  802598:	a3 68 d0 81 00       	mov    %eax,0x81d068
						allocblock->startva = requestedblockva;
  80259d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025a0:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8025a3:	89 10                	mov    %edx,(%eax)
						allocblock->size = size;
  8025a5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025a8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8025ab:	89 50 04             	mov    %edx,0x4(%eax)

						LIST_INSERT_TAIL(&u_allocatedlist, allocblock);
  8025ae:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8025b2:	75 17                	jne    8025cb <smalloc+0xf4>
  8025b4:	83 ec 04             	sub    $0x4,%esp
  8025b7:	68 d8 4c 80 00       	push   $0x804cd8
  8025bc:	68 57 01 00 00       	push   $0x157
  8025c1:	68 8c 4c 80 00       	push   $0x804c8c
  8025c6:	e8 97 df ff ff       	call   800562 <_panic>
  8025cb:	8b 15 34 d1 81 00    	mov    0x81d134,%edx
  8025d1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025d4:	89 50 0c             	mov    %edx,0xc(%eax)
  8025d7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025da:	8b 40 0c             	mov    0xc(%eax),%eax
  8025dd:	85 c0                	test   %eax,%eax
  8025df:	74 0d                	je     8025ee <smalloc+0x117>
  8025e1:	a1 34 d1 81 00       	mov    0x81d134,%eax
  8025e6:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8025e9:	89 50 08             	mov    %edx,0x8(%eax)
  8025ec:	eb 08                	jmp    8025f6 <smalloc+0x11f>
  8025ee:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025f1:	a3 30 d1 81 00       	mov    %eax,0x81d130
  8025f6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025f9:	a3 34 d1 81 00       	mov    %eax,0x81d134
  8025fe:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802601:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802608:	a1 3c d1 81 00       	mov    0x81d13c,%eax
  80260d:	40                   	inc    %eax
  80260e:	a3 3c d1 81 00       	mov    %eax,0x81d13c


						int result = sys_create_shared_object(sharedVarName ,size ,isWritable ,(void*)allocblock->startva);
  802613:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802616:	8b 00                	mov    (%eax),%eax
  802618:	89 c2                	mov    %eax,%edx
  80261a:	0f b6 45 c4          	movzbl -0x3c(%ebp),%eax
  80261e:	52                   	push   %edx
  80261f:	50                   	push   %eax
  802620:	ff 75 0c             	pushl  0xc(%ebp)
  802623:	ff 75 08             	pushl  0x8(%ebp)
  802626:	e8 48 0c 00 00       	call   803273 <sys_create_shared_object>
  80262b:	83 c4 10             	add    $0x10,%esp
  80262e:	89 45 d0             	mov    %eax,-0x30(%ebp)

						if(result <0){
  802631:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  802635:	79 28                	jns    80265f <smalloc+0x188>
							free_block(allocblock);
  802637:	83 ec 0c             	sub    $0xc,%esp
  80263a:	ff 75 ec             	pushl  -0x14(%ebp)
  80263d:	e8 cf 16 00 00       	call   803d11 <free_block>
  802642:	83 c4 10             	add    $0x10,%esp
							release_uspinlock(&ulock);
  802645:	83 ec 0c             	sub    $0xc,%esp
  802648:	68 40 d1 81 00       	push   $0x81d140
  80264d:	e8 e3 1a 00 00       	call   804135 <release_uspinlock>
  802652:	83 c4 10             	add    $0x10,%esp
							return NULL;
  802655:	b8 00 00 00 00       	mov    $0x0,%eax
  80265a:	e9 1d 04 00 00       	jmp    802a7c <smalloc+0x5a5>
						}
						release_uspinlock(&ulock);
  80265f:	83 ec 0c             	sub    $0xc,%esp
  802662:	68 40 d1 81 00       	push   $0x81d140
  802667:	e8 c9 1a 00 00       	call   804135 <release_uspinlock>
  80266c:	83 c4 10             	add    $0x10,%esp
						return (void*)allocblock -> startva;
  80266f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802672:	8b 00                	mov    (%eax),%eax
  802674:	e9 03 04 00 00       	jmp    802a7c <smalloc+0x5a5>
				}else{
						release_uspinlock(&ulock);
  802679:	83 ec 0c             	sub    $0xc,%esp
  80267c:	68 40 d1 81 00       	push   $0x81d140
  802681:	e8 af 1a 00 00       	call   804135 <release_uspinlock>
  802686:	83 c4 10             	add    $0x10,%esp
						return NULL;
  802689:	b8 00 00 00 00       	mov    $0x0,%eax
  80268e:	e9 e9 03 00 00       	jmp    802a7c <smalloc+0x5a5>
					 }
		}else{
			//custom fit
			struct UserHeapStruct* currentfreeelement = LIST_FIRST(&u_freelist);
  802693:	a1 20 d1 81 00       	mov    0x81d120,%eax
  802698:	89 45 f4             	mov    %eax,-0xc(%ebp)
			//worst fit
			while(currentfreeelement != NULL){
  80269b:	e9 af 03 00 00       	jmp    802a4f <smalloc+0x578>
				if(size<currentfreeelement->size){
  8026a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026a3:	8b 40 04             	mov    0x4(%eax),%eax
  8026a6:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8026a9:	0f 86 28 02 00 00    	jbe    8028d7 <smalloc+0x400>
					allocblock->startva = lastfreeelement->startva;
  8026af:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8026b2:	8b 10                	mov    (%eax),%edx
  8026b4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026b7:	89 10                	mov    %edx,(%eax)
	                allocblock->size = size;
  8026b9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026bc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8026bf:	89 50 04             	mov    %edx,0x4(%eax)
	                LIST_INSERT_TAIL(&u_allocatedlist,allocblock);
  8026c2:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8026c6:	75 17                	jne    8026df <smalloc+0x208>
  8026c8:	83 ec 04             	sub    $0x4,%esp
  8026cb:	68 d8 4c 80 00       	push   $0x804cd8
  8026d0:	68 6f 01 00 00       	push   $0x16f
  8026d5:	68 8c 4c 80 00       	push   $0x804c8c
  8026da:	e8 83 de ff ff       	call   800562 <_panic>
  8026df:	8b 15 34 d1 81 00    	mov    0x81d134,%edx
  8026e5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026e8:	89 50 0c             	mov    %edx,0xc(%eax)
  8026eb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026ee:	8b 40 0c             	mov    0xc(%eax),%eax
  8026f1:	85 c0                	test   %eax,%eax
  8026f3:	74 0d                	je     802702 <smalloc+0x22b>
  8026f5:	a1 34 d1 81 00       	mov    0x81d134,%eax
  8026fa:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8026fd:	89 50 08             	mov    %edx,0x8(%eax)
  802700:	eb 08                	jmp    80270a <smalloc+0x233>
  802702:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802705:	a3 30 d1 81 00       	mov    %eax,0x81d130
  80270a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80270d:	a3 34 d1 81 00       	mov    %eax,0x81d134
  802712:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802715:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  80271c:	a1 3c d1 81 00       	mov    0x81d13c,%eax
  802721:	40                   	inc    %eax
  802722:	a3 3c d1 81 00       	mov    %eax,0x81d13c
	                lastfreeelement->startva += size;
  802727:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80272a:	8b 10                	mov    (%eax),%edx
  80272c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80272f:	01 c2                	add    %eax,%edx
  802731:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802734:	89 10                	mov    %edx,(%eax)
	                lastfreeelement->size -= size;
  802736:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802739:	8b 40 04             	mov    0x4(%eax),%eax
  80273c:	2b 45 0c             	sub    0xc(%ebp),%eax
  80273f:	89 c2                	mov    %eax,%edx
  802741:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802744:	89 50 04             	mov    %edx,0x4(%eax)
	                struct UserHeapStruct* currentfree2 = LIST_FIRST(&u_freelist);
  802747:	a1 20 d1 81 00       	mov    0x81d120,%eax
  80274c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	                //check order of last element

	                while (currentfree2 != NULL){
  80274f:	e9 13 01 00 00       	jmp    802867 <smalloc+0x390>
	                	if(lastfreeelement->size <currentfree2->size){
  802754:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802757:	8b 50 04             	mov    0x4(%eax),%edx
  80275a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80275d:	8b 40 04             	mov    0x4(%eax),%eax
  802760:	39 c2                	cmp    %eax,%edx
  802762:	0f 83 f6 00 00 00    	jae    80285e <smalloc+0x387>
	                		LIST_REMOVE(&u_freelist ,lastfreeelement);
  802768:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80276c:	75 17                	jne    802785 <smalloc+0x2ae>
  80276e:	83 ec 04             	sub    $0x4,%esp
  802771:	68 fb 4c 80 00       	push   $0x804cfb
  802776:	68 77 01 00 00       	push   $0x177
  80277b:	68 8c 4c 80 00       	push   $0x804c8c
  802780:	e8 dd dd ff ff       	call   800562 <_panic>
  802785:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802788:	8b 40 08             	mov    0x8(%eax),%eax
  80278b:	85 c0                	test   %eax,%eax
  80278d:	74 11                	je     8027a0 <smalloc+0x2c9>
  80278f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802792:	8b 40 08             	mov    0x8(%eax),%eax
  802795:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802798:	8b 52 0c             	mov    0xc(%edx),%edx
  80279b:	89 50 0c             	mov    %edx,0xc(%eax)
  80279e:	eb 0b                	jmp    8027ab <smalloc+0x2d4>
  8027a0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8027a3:	8b 40 0c             	mov    0xc(%eax),%eax
  8027a6:	a3 24 d1 81 00       	mov    %eax,0x81d124
  8027ab:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8027ae:	8b 40 0c             	mov    0xc(%eax),%eax
  8027b1:	85 c0                	test   %eax,%eax
  8027b3:	74 11                	je     8027c6 <smalloc+0x2ef>
  8027b5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8027b8:	8b 40 0c             	mov    0xc(%eax),%eax
  8027bb:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8027be:	8b 52 08             	mov    0x8(%edx),%edx
  8027c1:	89 50 08             	mov    %edx,0x8(%eax)
  8027c4:	eb 0b                	jmp    8027d1 <smalloc+0x2fa>
  8027c6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8027c9:	8b 40 08             	mov    0x8(%eax),%eax
  8027cc:	a3 20 d1 81 00       	mov    %eax,0x81d120
  8027d1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8027d4:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  8027db:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8027de:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  8027e5:	a1 2c d1 81 00       	mov    0x81d12c,%eax
  8027ea:	48                   	dec    %eax
  8027eb:	a3 2c d1 81 00       	mov    %eax,0x81d12c
	                		LIST_INSERT_BEFORE(&u_freelist ,currentfree2 ,lastfreeelement);
  8027f0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8027f4:	74 06                	je     8027fc <smalloc+0x325>
  8027f6:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8027fa:	75 17                	jne    802813 <smalloc+0x33c>
  8027fc:	83 ec 04             	sub    $0x4,%esp
  8027ff:	68 1c 4d 80 00       	push   $0x804d1c
  802804:	68 78 01 00 00       	push   $0x178
  802809:	68 8c 4c 80 00       	push   $0x804c8c
  80280e:	e8 4f dd ff ff       	call   800562 <_panic>
  802813:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802816:	8b 50 0c             	mov    0xc(%eax),%edx
  802819:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80281c:	89 50 0c             	mov    %edx,0xc(%eax)
  80281f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802822:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802825:	89 50 08             	mov    %edx,0x8(%eax)
  802828:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80282b:	8b 40 0c             	mov    0xc(%eax),%eax
  80282e:	85 c0                	test   %eax,%eax
  802830:	74 0e                	je     802840 <smalloc+0x369>
  802832:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802835:	8b 40 0c             	mov    0xc(%eax),%eax
  802838:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80283b:	89 50 08             	mov    %edx,0x8(%eax)
  80283e:	eb 08                	jmp    802848 <smalloc+0x371>
  802840:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802843:	a3 20 d1 81 00       	mov    %eax,0x81d120
  802848:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80284b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80284e:	89 50 0c             	mov    %edx,0xc(%eax)
  802851:	a1 2c d1 81 00       	mov    0x81d12c,%eax
  802856:	40                   	inc    %eax
  802857:	a3 2c d1 81 00       	mov    %eax,0x81d12c
	                		break;
  80285c:	eb 13                	jmp    802871 <smalloc+0x39a>
	                	}
	                	currentfree2 = currentfree2->prev_next_info.le_next;
  80285e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802861:	8b 40 08             	mov    0x8(%eax),%eax
  802864:	89 45 f0             	mov    %eax,-0x10(%ebp)
	                lastfreeelement->startva += size;
	                lastfreeelement->size -= size;
	                struct UserHeapStruct* currentfree2 = LIST_FIRST(&u_freelist);
	                //check order of last element

	                while (currentfree2 != NULL){
  802867:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80286b:	0f 85 e3 fe ff ff    	jne    802754 <smalloc+0x27d>
	                	}
	                	currentfree2 = currentfree2->prev_next_info.le_next;
	                }


	                int result = sys_create_shared_object(sharedVarName ,size ,isWritable ,(void*)allocblock->startva);
  802871:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802874:	8b 00                	mov    (%eax),%eax
  802876:	89 c2                	mov    %eax,%edx
  802878:	0f b6 45 c4          	movzbl -0x3c(%ebp),%eax
  80287c:	52                   	push   %edx
  80287d:	50                   	push   %eax
  80287e:	ff 75 0c             	pushl  0xc(%ebp)
  802881:	ff 75 08             	pushl  0x8(%ebp)
  802884:	e8 ea 09 00 00       	call   803273 <sys_create_shared_object>
  802889:	83 c4 10             	add    $0x10,%esp
  80288c:	89 45 d8             	mov    %eax,-0x28(%ebp)

	                if(result <0){
  80288f:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  802893:	79 28                	jns    8028bd <smalloc+0x3e6>
	                	free_block(allocblock);
  802895:	83 ec 0c             	sub    $0xc,%esp
  802898:	ff 75 ec             	pushl  -0x14(%ebp)
  80289b:	e8 71 14 00 00       	call   803d11 <free_block>
  8028a0:	83 c4 10             	add    $0x10,%esp
	                	release_uspinlock(&ulock);
  8028a3:	83 ec 0c             	sub    $0xc,%esp
  8028a6:	68 40 d1 81 00       	push   $0x81d140
  8028ab:	e8 85 18 00 00       	call   804135 <release_uspinlock>
  8028b0:	83 c4 10             	add    $0x10,%esp
	                	return NULL;
  8028b3:	b8 00 00 00 00       	mov    $0x0,%eax
  8028b8:	e9 bf 01 00 00       	jmp    802a7c <smalloc+0x5a5>
	                }
	                release_uspinlock(&ulock);
  8028bd:	83 ec 0c             	sub    $0xc,%esp
  8028c0:	68 40 d1 81 00       	push   $0x81d140
  8028c5:	e8 6b 18 00 00       	call   804135 <release_uspinlock>
  8028ca:	83 c4 10             	add    $0x10,%esp
	                return (void*)allocblock->startva;
  8028cd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028d0:	8b 00                	mov    (%eax),%eax
  8028d2:	e9 a5 01 00 00       	jmp    802a7c <smalloc+0x5a5>
	                //exact fit
				}else if(size == currentfreeelement->size){
  8028d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028da:	8b 40 04             	mov    0x4(%eax),%eax
  8028dd:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8028e0:	0f 85 60 01 00 00    	jne    802a46 <smalloc+0x56f>
					allocblock->startva = currentfreeelement->startva;
  8028e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028e9:	8b 10                	mov    (%eax),%edx
  8028eb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028ee:	89 10                	mov    %edx,(%eax)
					allocblock->size = size;
  8028f0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028f3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8028f6:	89 50 04             	mov    %edx,0x4(%eax)
					LIST_INSERT_TAIL(&u_allocatedlist ,allocblock);
  8028f9:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8028fd:	75 17                	jne    802916 <smalloc+0x43f>
  8028ff:	83 ec 04             	sub    $0x4,%esp
  802902:	68 d8 4c 80 00       	push   $0x804cd8
  802907:	68 8c 01 00 00       	push   $0x18c
  80290c:	68 8c 4c 80 00       	push   $0x804c8c
  802911:	e8 4c dc ff ff       	call   800562 <_panic>
  802916:	8b 15 34 d1 81 00    	mov    0x81d134,%edx
  80291c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80291f:	89 50 0c             	mov    %edx,0xc(%eax)
  802922:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802925:	8b 40 0c             	mov    0xc(%eax),%eax
  802928:	85 c0                	test   %eax,%eax
  80292a:	74 0d                	je     802939 <smalloc+0x462>
  80292c:	a1 34 d1 81 00       	mov    0x81d134,%eax
  802931:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802934:	89 50 08             	mov    %edx,0x8(%eax)
  802937:	eb 08                	jmp    802941 <smalloc+0x46a>
  802939:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80293c:	a3 30 d1 81 00       	mov    %eax,0x81d130
  802941:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802944:	a3 34 d1 81 00       	mov    %eax,0x81d134
  802949:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80294c:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802953:	a1 3c d1 81 00       	mov    0x81d13c,%eax
  802958:	40                   	inc    %eax
  802959:	a3 3c d1 81 00       	mov    %eax,0x81d13c
					LIST_REMOVE(&u_freelist ,currentfreeelement);
  80295e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802962:	75 17                	jne    80297b <smalloc+0x4a4>
  802964:	83 ec 04             	sub    $0x4,%esp
  802967:	68 fb 4c 80 00       	push   $0x804cfb
  80296c:	68 8d 01 00 00       	push   $0x18d
  802971:	68 8c 4c 80 00       	push   $0x804c8c
  802976:	e8 e7 db ff ff       	call   800562 <_panic>
  80297b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80297e:	8b 40 08             	mov    0x8(%eax),%eax
  802981:	85 c0                	test   %eax,%eax
  802983:	74 11                	je     802996 <smalloc+0x4bf>
  802985:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802988:	8b 40 08             	mov    0x8(%eax),%eax
  80298b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80298e:	8b 52 0c             	mov    0xc(%edx),%edx
  802991:	89 50 0c             	mov    %edx,0xc(%eax)
  802994:	eb 0b                	jmp    8029a1 <smalloc+0x4ca>
  802996:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802999:	8b 40 0c             	mov    0xc(%eax),%eax
  80299c:	a3 24 d1 81 00       	mov    %eax,0x81d124
  8029a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029a4:	8b 40 0c             	mov    0xc(%eax),%eax
  8029a7:	85 c0                	test   %eax,%eax
  8029a9:	74 11                	je     8029bc <smalloc+0x4e5>
  8029ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029ae:	8b 40 0c             	mov    0xc(%eax),%eax
  8029b1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8029b4:	8b 52 08             	mov    0x8(%edx),%edx
  8029b7:	89 50 08             	mov    %edx,0x8(%eax)
  8029ba:	eb 0b                	jmp    8029c7 <smalloc+0x4f0>
  8029bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029bf:	8b 40 08             	mov    0x8(%eax),%eax
  8029c2:	a3 20 d1 81 00       	mov    %eax,0x81d120
  8029c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029ca:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  8029d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029d4:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  8029db:	a1 2c d1 81 00       	mov    0x81d12c,%eax
  8029e0:	48                   	dec    %eax
  8029e1:	a3 2c d1 81 00       	mov    %eax,0x81d12c
					int result = sys_create_shared_object(sharedVarName ,size ,isWritable ,(void*)allocblock->startva);
  8029e6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029e9:	8b 00                	mov    (%eax),%eax
  8029eb:	89 c2                	mov    %eax,%edx
  8029ed:	0f b6 45 c4          	movzbl -0x3c(%ebp),%eax
  8029f1:	52                   	push   %edx
  8029f2:	50                   	push   %eax
  8029f3:	ff 75 0c             	pushl  0xc(%ebp)
  8029f6:	ff 75 08             	pushl  0x8(%ebp)
  8029f9:	e8 75 08 00 00       	call   803273 <sys_create_shared_object>
  8029fe:	83 c4 10             	add    $0x10,%esp
  802a01:	89 45 dc             	mov    %eax,-0x24(%ebp)

					if(result <0){
  802a04:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802a08:	79 25                	jns    802a2f <smalloc+0x558>
						free_block(allocblock);
  802a0a:	83 ec 0c             	sub    $0xc,%esp
  802a0d:	ff 75 ec             	pushl  -0x14(%ebp)
  802a10:	e8 fc 12 00 00       	call   803d11 <free_block>
  802a15:	83 c4 10             	add    $0x10,%esp
						release_uspinlock(&ulock);
  802a18:	83 ec 0c             	sub    $0xc,%esp
  802a1b:	68 40 d1 81 00       	push   $0x81d140
  802a20:	e8 10 17 00 00       	call   804135 <release_uspinlock>
  802a25:	83 c4 10             	add    $0x10,%esp
						return NULL;
  802a28:	b8 00 00 00 00       	mov    $0x0,%eax
  802a2d:	eb 4d                	jmp    802a7c <smalloc+0x5a5>
					}
					release_uspinlock(&ulock);
  802a2f:	83 ec 0c             	sub    $0xc,%esp
  802a32:	68 40 d1 81 00       	push   $0x81d140
  802a37:	e8 f9 16 00 00       	call   804135 <release_uspinlock>
  802a3c:	83 c4 10             	add    $0x10,%esp
					return (void*)allocblock->startva;
  802a3f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a42:	8b 00                	mov    (%eax),%eax
  802a44:	eb 36                	jmp    802a7c <smalloc+0x5a5>
				}
				currentfreeelement = currentfreeelement->prev_next_info.le_next;
  802a46:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a49:	8b 40 08             	mov    0x8(%eax),%eax
  802a4c:	89 45 f4             	mov    %eax,-0xc(%ebp)
					 }
		}else{
			//custom fit
			struct UserHeapStruct* currentfreeelement = LIST_FIRST(&u_freelist);
			//worst fit
			while(currentfreeelement != NULL){
  802a4f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a53:	0f 85 47 fc ff ff    	jne    8026a0 <smalloc+0x1c9>
					return (void*)allocblock->startva;
				}
				currentfreeelement = currentfreeelement->prev_next_info.le_next;
			}
		}
		free_block(allocblock);
  802a59:	83 ec 0c             	sub    $0xc,%esp
  802a5c:	ff 75 ec             	pushl  -0x14(%ebp)
  802a5f:	e8 ad 12 00 00       	call   803d11 <free_block>
  802a64:	83 c4 10             	add    $0x10,%esp
		release_uspinlock(&ulock);
  802a67:	83 ec 0c             	sub    $0xc,%esp
  802a6a:	68 40 d1 81 00       	push   $0x81d140
  802a6f:	e8 c1 16 00 00       	call   804135 <release_uspinlock>
  802a74:	83 c4 10             	add    $0x10,%esp
		return NULL;
  802a77:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802a7c:	c9                   	leave  
  802a7d:	c3                   	ret    

00802a7e <sget>:

//========================================
// [4] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  802a7e:	55                   	push   %ebp
  802a7f:	89 e5                	mov    %esp,%ebp
  802a81:	83 ec 38             	sub    $0x38,%esp


	 //==============================================================
	 // DON'T CHANGE THIS CODE
	    uheap_init();
  802a84:	e8 8c ec ff ff       	call   801715 <uheap_init>
	 //==============================================================
	 // Get size of the shared variable from kernel
	acquire_uspinlock(&ulock);
  802a89:	83 ec 0c             	sub    $0xc,%esp
  802a8c:	68 40 d1 81 00       	push   $0x81d140
  802a91:	e8 47 16 00 00       	call   8040dd <acquire_uspinlock>
  802a96:	83 c4 10             	add    $0x10,%esp


	int size = sys_size_of_shared_object(ownerEnvID ,sharedVarName);
  802a99:	83 ec 08             	sub    $0x8,%esp
  802a9c:	ff 75 0c             	pushl  0xc(%ebp)
  802a9f:	ff 75 08             	pushl  0x8(%ebp)
  802aa2:	e8 f6 07 00 00       	call   80329d <sys_size_of_shared_object>
  802aa7:	83 c4 10             	add    $0x10,%esp
  802aaa:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if ( size < 0 ){
  802aad:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802ab1:	79 1a                	jns    802acd <sget+0x4f>
			release_uspinlock(&ulock);
  802ab3:	83 ec 0c             	sub    $0xc,%esp
  802ab6:	68 40 d1 81 00       	push   $0x81d140
  802abb:	e8 75 16 00 00       	call   804135 <release_uspinlock>
  802ac0:	83 c4 10             	add    $0x10,%esp
			return NULL;
  802ac3:	b8 00 00 00 00       	mov    $0x0,%eax
  802ac8:	e9 6e 05 00 00       	jmp    80303b <sget+0x5bd>
		}
		size = ROUNDUP(size,PAGE_SIZE);
  802acd:	c7 45 e8 00 10 00 00 	movl   $0x1000,-0x18(%ebp)
  802ad4:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802ad7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ada:	01 d0                	add    %edx,%eax
  802adc:	48                   	dec    %eax
  802add:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  802ae0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802ae3:	ba 00 00 00 00       	mov    $0x0,%edx
  802ae8:	f7 75 e8             	divl   -0x18(%ebp)
  802aeb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802aee:	29 d0                	sub    %edx,%eax
  802af0:	89 45 ec             	mov    %eax,-0x14(%ebp)

		struct UserHeapStruct* allocblock = (struct UserHeapStruct*) alloc_block(sizeof(struct UserHeapStruct));
  802af3:	83 ec 0c             	sub    $0xc,%esp
  802af6:	6a 10                	push   $0x10
  802af8:	e8 78 0d 00 00       	call   803875 <alloc_block>
  802afd:	83 c4 10             	add    $0x10,%esp
  802b00:	89 45 e0             	mov    %eax,-0x20(%ebp)

		if (allocblock == NULL){
  802b03:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802b07:	75 0a                	jne    802b13 <sget+0x95>
			return NULL;
  802b09:	b8 00 00 00 00       	mov    $0x0,%eax
  802b0e:	e9 28 05 00 00       	jmp    80303b <sget+0x5bd>
		}
		struct UserHeapStruct* lastfreeelement = LIST_LAST(&u_freelist);
  802b13:	a1 24 d1 81 00       	mov    0x81d124,%eax
  802b18:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if(LIST_SIZE(&u_freelist)==0 || size>lastfreeelement->size){
  802b1b:	a1 2c d1 81 00       	mov    0x81d12c,%eax
  802b20:	85 c0                	test   %eax,%eax
  802b22:	74 11                	je     802b35 <sget+0xb7>
  802b24:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802b27:	8b 50 04             	mov    0x4(%eax),%edx
  802b2a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b2d:	39 c2                	cmp    %eax,%edx
  802b2f:	0f 83 21 01 00 00    	jae    802c56 <sget+0x1d8>
				if(uheapPageAllocBreak <= USER_HEAP_MAX - size){
  802b35:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b38:	ba 00 00 00 a0       	mov    $0xa0000000,%edx
  802b3d:	29 c2                	sub    %eax,%edx
  802b3f:	a1 68 d0 81 00       	mov    0x81d068,%eax
  802b44:	39 c2                	cmp    %eax,%edx
  802b46:	0f 82 f0 00 00 00    	jb     802c3c <sget+0x1be>

						uint32 requestedblockva = uheapPageAllocBreak;
  802b4c:	a1 68 d0 81 00       	mov    0x81d068,%eax
  802b51:	89 45 d0             	mov    %eax,-0x30(%ebp)
						uheapPageAllocBreak+=size;
  802b54:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  802b5a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b5d:	01 d0                	add    %edx,%eax
  802b5f:	a3 68 d0 81 00       	mov    %eax,0x81d068
						allocblock->startva = requestedblockva;
  802b64:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802b67:	8b 55 d0             	mov    -0x30(%ebp),%edx
  802b6a:	89 10                	mov    %edx,(%eax)
						allocblock->size = size;
  802b6c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802b6f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802b72:	89 50 04             	mov    %edx,0x4(%eax)

						LIST_INSERT_TAIL(&u_allocatedlist, allocblock);
  802b75:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802b79:	75 17                	jne    802b92 <sget+0x114>
  802b7b:	83 ec 04             	sub    $0x4,%esp
  802b7e:	68 d8 4c 80 00       	push   $0x804cd8
  802b83:	68 c8 01 00 00       	push   $0x1c8
  802b88:	68 8c 4c 80 00       	push   $0x804c8c
  802b8d:	e8 d0 d9 ff ff       	call   800562 <_panic>
  802b92:	8b 15 34 d1 81 00    	mov    0x81d134,%edx
  802b98:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802b9b:	89 50 0c             	mov    %edx,0xc(%eax)
  802b9e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802ba1:	8b 40 0c             	mov    0xc(%eax),%eax
  802ba4:	85 c0                	test   %eax,%eax
  802ba6:	74 0d                	je     802bb5 <sget+0x137>
  802ba8:	a1 34 d1 81 00       	mov    0x81d134,%eax
  802bad:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802bb0:	89 50 08             	mov    %edx,0x8(%eax)
  802bb3:	eb 08                	jmp    802bbd <sget+0x13f>
  802bb5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802bb8:	a3 30 d1 81 00       	mov    %eax,0x81d130
  802bbd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802bc0:	a3 34 d1 81 00       	mov    %eax,0x81d134
  802bc5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802bc8:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802bcf:	a1 3c d1 81 00       	mov    0x81d13c,%eax
  802bd4:	40                   	inc    %eax
  802bd5:	a3 3c d1 81 00       	mov    %eax,0x81d13c


						int result = sys_get_shared_object(ownerEnvID ,sharedVarName ,(void*)allocblock->startva);
  802bda:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802bdd:	8b 00                	mov    (%eax),%eax
  802bdf:	83 ec 04             	sub    $0x4,%esp
  802be2:	50                   	push   %eax
  802be3:	ff 75 0c             	pushl  0xc(%ebp)
  802be6:	ff 75 08             	pushl  0x8(%ebp)
  802be9:	e8 cc 06 00 00       	call   8032ba <sys_get_shared_object>
  802bee:	83 c4 10             	add    $0x10,%esp
  802bf1:	89 45 cc             	mov    %eax,-0x34(%ebp)

						if(result <0){
  802bf4:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802bf8:	79 28                	jns    802c22 <sget+0x1a4>
							free_block(allocblock);
  802bfa:	83 ec 0c             	sub    $0xc,%esp
  802bfd:	ff 75 e0             	pushl  -0x20(%ebp)
  802c00:	e8 0c 11 00 00       	call   803d11 <free_block>
  802c05:	83 c4 10             	add    $0x10,%esp
							release_uspinlock(&ulock);
  802c08:	83 ec 0c             	sub    $0xc,%esp
  802c0b:	68 40 d1 81 00       	push   $0x81d140
  802c10:	e8 20 15 00 00       	call   804135 <release_uspinlock>
  802c15:	83 c4 10             	add    $0x10,%esp
							return NULL;
  802c18:	b8 00 00 00 00       	mov    $0x0,%eax
  802c1d:	e9 19 04 00 00       	jmp    80303b <sget+0x5bd>
						}
						release_uspinlock(&ulock);
  802c22:	83 ec 0c             	sub    $0xc,%esp
  802c25:	68 40 d1 81 00       	push   $0x81d140
  802c2a:	e8 06 15 00 00       	call   804135 <release_uspinlock>
  802c2f:	83 c4 10             	add    $0x10,%esp
						return (void*)allocblock -> startva;
  802c32:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802c35:	8b 00                	mov    (%eax),%eax
  802c37:	e9 ff 03 00 00       	jmp    80303b <sget+0x5bd>
				}else{
						release_uspinlock(&ulock);
  802c3c:	83 ec 0c             	sub    $0xc,%esp
  802c3f:	68 40 d1 81 00       	push   $0x81d140
  802c44:	e8 ec 14 00 00       	call   804135 <release_uspinlock>
  802c49:	83 c4 10             	add    $0x10,%esp
						return NULL;
  802c4c:	b8 00 00 00 00       	mov    $0x0,%eax
  802c51:	e9 e5 03 00 00       	jmp    80303b <sget+0x5bd>
					 }
		}else{
			//custom fit
			struct UserHeapStruct* currentfreeelement = LIST_FIRST(&u_freelist);
  802c56:	a1 20 d1 81 00       	mov    0x81d120,%eax
  802c5b:	89 45 f4             	mov    %eax,-0xc(%ebp)
			//worst fit
			while(currentfreeelement != NULL){
  802c5e:	e9 ab 03 00 00       	jmp    80300e <sget+0x590>
				if(size<currentfreeelement->size){
  802c63:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c66:	8b 50 04             	mov    0x4(%eax),%edx
  802c69:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c6c:	39 c2                	cmp    %eax,%edx
  802c6e:	0f 86 24 02 00 00    	jbe    802e98 <sget+0x41a>
					allocblock->startva = lastfreeelement->startva;
  802c74:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802c77:	8b 10                	mov    (%eax),%edx
  802c79:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802c7c:	89 10                	mov    %edx,(%eax)
					allocblock->size = size;
  802c7e:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802c81:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802c84:	89 50 04             	mov    %edx,0x4(%eax)
					LIST_INSERT_TAIL(&u_allocatedlist,allocblock);
  802c87:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802c8b:	75 17                	jne    802ca4 <sget+0x226>
  802c8d:	83 ec 04             	sub    $0x4,%esp
  802c90:	68 d8 4c 80 00       	push   $0x804cd8
  802c95:	68 e0 01 00 00       	push   $0x1e0
  802c9a:	68 8c 4c 80 00       	push   $0x804c8c
  802c9f:	e8 be d8 ff ff       	call   800562 <_panic>
  802ca4:	8b 15 34 d1 81 00    	mov    0x81d134,%edx
  802caa:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802cad:	89 50 0c             	mov    %edx,0xc(%eax)
  802cb0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802cb3:	8b 40 0c             	mov    0xc(%eax),%eax
  802cb6:	85 c0                	test   %eax,%eax
  802cb8:	74 0d                	je     802cc7 <sget+0x249>
  802cba:	a1 34 d1 81 00       	mov    0x81d134,%eax
  802cbf:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802cc2:	89 50 08             	mov    %edx,0x8(%eax)
  802cc5:	eb 08                	jmp    802ccf <sget+0x251>
  802cc7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802cca:	a3 30 d1 81 00       	mov    %eax,0x81d130
  802ccf:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802cd2:	a3 34 d1 81 00       	mov    %eax,0x81d134
  802cd7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802cda:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802ce1:	a1 3c d1 81 00       	mov    0x81d13c,%eax
  802ce6:	40                   	inc    %eax
  802ce7:	a3 3c d1 81 00       	mov    %eax,0x81d13c
					lastfreeelement->startva += size;
  802cec:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802cef:	8b 10                	mov    (%eax),%edx
  802cf1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cf4:	01 c2                	add    %eax,%edx
  802cf6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802cf9:	89 10                	mov    %edx,(%eax)
					lastfreeelement->size -= size;
  802cfb:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802cfe:	8b 50 04             	mov    0x4(%eax),%edx
  802d01:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d04:	29 c2                	sub    %eax,%edx
  802d06:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802d09:	89 50 04             	mov    %edx,0x4(%eax)
					struct UserHeapStruct* currentfree2 = LIST_FIRST(&u_freelist);
  802d0c:	a1 20 d1 81 00       	mov    0x81d120,%eax
  802d11:	89 45 f0             	mov    %eax,-0x10(%ebp)
					//check order of last element

					while (currentfree2 != NULL){
  802d14:	e9 13 01 00 00       	jmp    802e2c <sget+0x3ae>
						if(lastfreeelement->size <currentfree2->size){
  802d19:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802d1c:	8b 50 04             	mov    0x4(%eax),%edx
  802d1f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d22:	8b 40 04             	mov    0x4(%eax),%eax
  802d25:	39 c2                	cmp    %eax,%edx
  802d27:	0f 83 f6 00 00 00    	jae    802e23 <sget+0x3a5>
							LIST_REMOVE(&u_freelist ,lastfreeelement);
  802d2d:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802d31:	75 17                	jne    802d4a <sget+0x2cc>
  802d33:	83 ec 04             	sub    $0x4,%esp
  802d36:	68 fb 4c 80 00       	push   $0x804cfb
  802d3b:	68 e8 01 00 00       	push   $0x1e8
  802d40:	68 8c 4c 80 00       	push   $0x804c8c
  802d45:	e8 18 d8 ff ff       	call   800562 <_panic>
  802d4a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802d4d:	8b 40 08             	mov    0x8(%eax),%eax
  802d50:	85 c0                	test   %eax,%eax
  802d52:	74 11                	je     802d65 <sget+0x2e7>
  802d54:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802d57:	8b 40 08             	mov    0x8(%eax),%eax
  802d5a:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802d5d:	8b 52 0c             	mov    0xc(%edx),%edx
  802d60:	89 50 0c             	mov    %edx,0xc(%eax)
  802d63:	eb 0b                	jmp    802d70 <sget+0x2f2>
  802d65:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802d68:	8b 40 0c             	mov    0xc(%eax),%eax
  802d6b:	a3 24 d1 81 00       	mov    %eax,0x81d124
  802d70:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802d73:	8b 40 0c             	mov    0xc(%eax),%eax
  802d76:	85 c0                	test   %eax,%eax
  802d78:	74 11                	je     802d8b <sget+0x30d>
  802d7a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802d7d:	8b 40 0c             	mov    0xc(%eax),%eax
  802d80:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802d83:	8b 52 08             	mov    0x8(%edx),%edx
  802d86:	89 50 08             	mov    %edx,0x8(%eax)
  802d89:	eb 0b                	jmp    802d96 <sget+0x318>
  802d8b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802d8e:	8b 40 08             	mov    0x8(%eax),%eax
  802d91:	a3 20 d1 81 00       	mov    %eax,0x81d120
  802d96:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802d99:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802da0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802da3:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  802daa:	a1 2c d1 81 00       	mov    0x81d12c,%eax
  802daf:	48                   	dec    %eax
  802db0:	a3 2c d1 81 00       	mov    %eax,0x81d12c
							LIST_INSERT_BEFORE(&u_freelist ,currentfree2 ,lastfreeelement);
  802db5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802db9:	74 06                	je     802dc1 <sget+0x343>
  802dbb:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802dbf:	75 17                	jne    802dd8 <sget+0x35a>
  802dc1:	83 ec 04             	sub    $0x4,%esp
  802dc4:	68 1c 4d 80 00       	push   $0x804d1c
  802dc9:	68 e9 01 00 00       	push   $0x1e9
  802dce:	68 8c 4c 80 00       	push   $0x804c8c
  802dd3:	e8 8a d7 ff ff       	call   800562 <_panic>
  802dd8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ddb:	8b 50 0c             	mov    0xc(%eax),%edx
  802dde:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802de1:	89 50 0c             	mov    %edx,0xc(%eax)
  802de4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802de7:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802dea:	89 50 08             	mov    %edx,0x8(%eax)
  802ded:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802df0:	8b 40 0c             	mov    0xc(%eax),%eax
  802df3:	85 c0                	test   %eax,%eax
  802df5:	74 0e                	je     802e05 <sget+0x387>
  802df7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dfa:	8b 40 0c             	mov    0xc(%eax),%eax
  802dfd:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802e00:	89 50 08             	mov    %edx,0x8(%eax)
  802e03:	eb 08                	jmp    802e0d <sget+0x38f>
  802e05:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802e08:	a3 20 d1 81 00       	mov    %eax,0x81d120
  802e0d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e10:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802e13:	89 50 0c             	mov    %edx,0xc(%eax)
  802e16:	a1 2c d1 81 00       	mov    0x81d12c,%eax
  802e1b:	40                   	inc    %eax
  802e1c:	a3 2c d1 81 00       	mov    %eax,0x81d12c
							break;
  802e21:	eb 13                	jmp    802e36 <sget+0x3b8>
						}
						currentfree2 = currentfree2->prev_next_info.le_next;
  802e23:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e26:	8b 40 08             	mov    0x8(%eax),%eax
  802e29:	89 45 f0             	mov    %eax,-0x10(%ebp)
					lastfreeelement->startva += size;
					lastfreeelement->size -= size;
					struct UserHeapStruct* currentfree2 = LIST_FIRST(&u_freelist);
					//check order of last element

					while (currentfree2 != NULL){
  802e2c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802e30:	0f 85 e3 fe ff ff    	jne    802d19 <sget+0x29b>
						}
						currentfree2 = currentfree2->prev_next_info.le_next;
					}


					int result = sys_get_shared_object(ownerEnvID ,sharedVarName ,(void*)allocblock->startva);
  802e36:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802e39:	8b 00                	mov    (%eax),%eax
  802e3b:	83 ec 04             	sub    $0x4,%esp
  802e3e:	50                   	push   %eax
  802e3f:	ff 75 0c             	pushl  0xc(%ebp)
  802e42:	ff 75 08             	pushl  0x8(%ebp)
  802e45:	e8 70 04 00 00       	call   8032ba <sys_get_shared_object>
  802e4a:	83 c4 10             	add    $0x10,%esp
  802e4d:	89 45 d4             	mov    %eax,-0x2c(%ebp)

					if(result <0){
  802e50:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  802e54:	79 28                	jns    802e7e <sget+0x400>
						free_block(allocblock);
  802e56:	83 ec 0c             	sub    $0xc,%esp
  802e59:	ff 75 e0             	pushl  -0x20(%ebp)
  802e5c:	e8 b0 0e 00 00       	call   803d11 <free_block>
  802e61:	83 c4 10             	add    $0x10,%esp
						release_uspinlock(&ulock);
  802e64:	83 ec 0c             	sub    $0xc,%esp
  802e67:	68 40 d1 81 00       	push   $0x81d140
  802e6c:	e8 c4 12 00 00       	call   804135 <release_uspinlock>
  802e71:	83 c4 10             	add    $0x10,%esp
						return NULL;
  802e74:	b8 00 00 00 00       	mov    $0x0,%eax
  802e79:	e9 bd 01 00 00       	jmp    80303b <sget+0x5bd>
					}
					release_uspinlock(&ulock);
  802e7e:	83 ec 0c             	sub    $0xc,%esp
  802e81:	68 40 d1 81 00       	push   $0x81d140
  802e86:	e8 aa 12 00 00       	call   804135 <release_uspinlock>
  802e8b:	83 c4 10             	add    $0x10,%esp
					return (void*)allocblock->startva;
  802e8e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802e91:	8b 00                	mov    (%eax),%eax
  802e93:	e9 a3 01 00 00       	jmp    80303b <sget+0x5bd>
					//exact fit
				}else if(size == currentfreeelement->size){
  802e98:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e9b:	8b 50 04             	mov    0x4(%eax),%edx
  802e9e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ea1:	39 c2                	cmp    %eax,%edx
  802ea3:	0f 85 5c 01 00 00    	jne    803005 <sget+0x587>

					allocblock->startva = currentfreeelement->startva;
  802ea9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eac:	8b 10                	mov    (%eax),%edx
  802eae:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802eb1:	89 10                	mov    %edx,(%eax)
					allocblock->size = size;
  802eb3:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802eb6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802eb9:	89 50 04             	mov    %edx,0x4(%eax)
					LIST_INSERT_TAIL(&u_allocatedlist ,allocblock);
  802ebc:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802ec0:	75 17                	jne    802ed9 <sget+0x45b>
  802ec2:	83 ec 04             	sub    $0x4,%esp
  802ec5:	68 d8 4c 80 00       	push   $0x804cd8
  802eca:	68 fe 01 00 00       	push   $0x1fe
  802ecf:	68 8c 4c 80 00       	push   $0x804c8c
  802ed4:	e8 89 d6 ff ff       	call   800562 <_panic>
  802ed9:	8b 15 34 d1 81 00    	mov    0x81d134,%edx
  802edf:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802ee2:	89 50 0c             	mov    %edx,0xc(%eax)
  802ee5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802ee8:	8b 40 0c             	mov    0xc(%eax),%eax
  802eeb:	85 c0                	test   %eax,%eax
  802eed:	74 0d                	je     802efc <sget+0x47e>
  802eef:	a1 34 d1 81 00       	mov    0x81d134,%eax
  802ef4:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802ef7:	89 50 08             	mov    %edx,0x8(%eax)
  802efa:	eb 08                	jmp    802f04 <sget+0x486>
  802efc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802eff:	a3 30 d1 81 00       	mov    %eax,0x81d130
  802f04:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802f07:	a3 34 d1 81 00       	mov    %eax,0x81d134
  802f0c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802f0f:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802f16:	a1 3c d1 81 00       	mov    0x81d13c,%eax
  802f1b:	40                   	inc    %eax
  802f1c:	a3 3c d1 81 00       	mov    %eax,0x81d13c
					LIST_REMOVE(&u_freelist ,currentfreeelement);
  802f21:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f25:	75 17                	jne    802f3e <sget+0x4c0>
  802f27:	83 ec 04             	sub    $0x4,%esp
  802f2a:	68 fb 4c 80 00       	push   $0x804cfb
  802f2f:	68 ff 01 00 00       	push   $0x1ff
  802f34:	68 8c 4c 80 00       	push   $0x804c8c
  802f39:	e8 24 d6 ff ff       	call   800562 <_panic>
  802f3e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f41:	8b 40 08             	mov    0x8(%eax),%eax
  802f44:	85 c0                	test   %eax,%eax
  802f46:	74 11                	je     802f59 <sget+0x4db>
  802f48:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f4b:	8b 40 08             	mov    0x8(%eax),%eax
  802f4e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802f51:	8b 52 0c             	mov    0xc(%edx),%edx
  802f54:	89 50 0c             	mov    %edx,0xc(%eax)
  802f57:	eb 0b                	jmp    802f64 <sget+0x4e6>
  802f59:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f5c:	8b 40 0c             	mov    0xc(%eax),%eax
  802f5f:	a3 24 d1 81 00       	mov    %eax,0x81d124
  802f64:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f67:	8b 40 0c             	mov    0xc(%eax),%eax
  802f6a:	85 c0                	test   %eax,%eax
  802f6c:	74 11                	je     802f7f <sget+0x501>
  802f6e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f71:	8b 40 0c             	mov    0xc(%eax),%eax
  802f74:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802f77:	8b 52 08             	mov    0x8(%edx),%edx
  802f7a:	89 50 08             	mov    %edx,0x8(%eax)
  802f7d:	eb 0b                	jmp    802f8a <sget+0x50c>
  802f7f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f82:	8b 40 08             	mov    0x8(%eax),%eax
  802f85:	a3 20 d1 81 00       	mov    %eax,0x81d120
  802f8a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f8d:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802f94:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f97:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  802f9e:	a1 2c d1 81 00       	mov    0x81d12c,%eax
  802fa3:	48                   	dec    %eax
  802fa4:	a3 2c d1 81 00       	mov    %eax,0x81d12c

					int result = sys_get_shared_object(ownerEnvID ,sharedVarName ,(void*)allocblock->startva);
  802fa9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802fac:	8b 00                	mov    (%eax),%eax
  802fae:	83 ec 04             	sub    $0x4,%esp
  802fb1:	50                   	push   %eax
  802fb2:	ff 75 0c             	pushl  0xc(%ebp)
  802fb5:	ff 75 08             	pushl  0x8(%ebp)
  802fb8:	e8 fd 02 00 00       	call   8032ba <sys_get_shared_object>
  802fbd:	83 c4 10             	add    $0x10,%esp
  802fc0:	89 45 d8             	mov    %eax,-0x28(%ebp)
					if(result <0){
  802fc3:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  802fc7:	79 25                	jns    802fee <sget+0x570>
						free_block(allocblock);
  802fc9:	83 ec 0c             	sub    $0xc,%esp
  802fcc:	ff 75 e0             	pushl  -0x20(%ebp)
  802fcf:	e8 3d 0d 00 00       	call   803d11 <free_block>
  802fd4:	83 c4 10             	add    $0x10,%esp
						release_uspinlock(&ulock);
  802fd7:	83 ec 0c             	sub    $0xc,%esp
  802fda:	68 40 d1 81 00       	push   $0x81d140
  802fdf:	e8 51 11 00 00       	call   804135 <release_uspinlock>
  802fe4:	83 c4 10             	add    $0x10,%esp
						return NULL;
  802fe7:	b8 00 00 00 00       	mov    $0x0,%eax
  802fec:	eb 4d                	jmp    80303b <sget+0x5bd>
					}

					release_uspinlock(&ulock);
  802fee:	83 ec 0c             	sub    $0xc,%esp
  802ff1:	68 40 d1 81 00       	push   $0x81d140
  802ff6:	e8 3a 11 00 00       	call   804135 <release_uspinlock>
  802ffb:	83 c4 10             	add    $0x10,%esp
					return (void*)allocblock->startva;
  802ffe:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803001:	8b 00                	mov    (%eax),%eax
  803003:	eb 36                	jmp    80303b <sget+0x5bd>
				}
				currentfreeelement = currentfreeelement->prev_next_info.le_next;
  803005:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803008:	8b 40 08             	mov    0x8(%eax),%eax
  80300b:	89 45 f4             	mov    %eax,-0xc(%ebp)
					 }
		}else{
			//custom fit
			struct UserHeapStruct* currentfreeelement = LIST_FIRST(&u_freelist);
			//worst fit
			while(currentfreeelement != NULL){
  80300e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803012:	0f 85 4b fc ff ff    	jne    802c63 <sget+0x1e5>
					return (void*)allocblock->startva;
				}
				currentfreeelement = currentfreeelement->prev_next_info.le_next;
			}
		}
		free_block(allocblock);
  803018:	83 ec 0c             	sub    $0xc,%esp
  80301b:	ff 75 e0             	pushl  -0x20(%ebp)
  80301e:	e8 ee 0c 00 00       	call   803d11 <free_block>
  803023:	83 c4 10             	add    $0x10,%esp
		release_uspinlock(&ulock);
  803026:	83 ec 0c             	sub    $0xc,%esp
  803029:	68 40 d1 81 00       	push   $0x81d140
  80302e:	e8 02 11 00 00       	call   804135 <release_uspinlock>
  803033:	83 c4 10             	add    $0x10,%esp
		return NULL;
  803036:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80303b:	c9                   	leave  
  80303c:	c3                   	ret    

0080303d <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  80303d:	55                   	push   %ebp
  80303e:	89 e5                	mov    %esp,%ebp
  803040:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  803043:	e8 cd e6 ff ff       	call   801715 <uheap_init>
	//==============================================================
	panic("realloc() is not implemented yet...!!");
  803048:	83 ec 04             	sub    $0x4,%esp
  80304b:	68 ac 4d 80 00       	push   $0x804dac
  803050:	68 2d 02 00 00       	push   $0x22d
  803055:	68 8c 4c 80 00       	push   $0x804c8c
  80305a:	e8 03 d5 ff ff       	call   800562 <_panic>

0080305f <sfree>:
//
//	use sys_delete_shared_object(...); which switches to the kernel mode,
//	calls delete_shared_object(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the delete_shared_object() function is empty, make sure to implement it.
void sfree(void* virtual_address)
{
  80305f:	55                   	push   %ebp
  803060:	89 e5                	mov    %esp,%ebp
  803062:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.BONUS#5] EXIT #2 - sfree
	//Your code is here
	//Comment the following line
	panic("sfree() is not implemented yet...!!");
  803065:	83 ec 04             	sub    $0x4,%esp
  803068:	68 d4 4d 80 00       	push   $0x804dd4
  80306d:	68 40 02 00 00       	push   $0x240
  803072:	68 8c 4c 80 00       	push   $0x804c8c
  803077:	e8 e6 d4 ff ff       	call   800562 <_panic>

0080307c <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  80307c:	55                   	push   %ebp
  80307d:	89 e5                	mov    %esp,%ebp
  80307f:	57                   	push   %edi
  803080:	56                   	push   %esi
  803081:	53                   	push   %ebx
  803082:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  803085:	8b 45 08             	mov    0x8(%ebp),%eax
  803088:	8b 55 0c             	mov    0xc(%ebp),%edx
  80308b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80308e:	8b 5d 14             	mov    0x14(%ebp),%ebx
  803091:	8b 7d 18             	mov    0x18(%ebp),%edi
  803094:	8b 75 1c             	mov    0x1c(%ebp),%esi
  803097:	cd 30                	int    $0x30
  803099:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  80309c:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80309f:	83 c4 10             	add    $0x10,%esp
  8030a2:	5b                   	pop    %ebx
  8030a3:	5e                   	pop    %esi
  8030a4:	5f                   	pop    %edi
  8030a5:	5d                   	pop    %ebp
  8030a6:	c3                   	ret    

008030a7 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  8030a7:	55                   	push   %ebp
  8030a8:	89 e5                	mov    %esp,%ebp
  8030aa:	83 ec 04             	sub    $0x4,%esp
  8030ad:	8b 45 10             	mov    0x10(%ebp),%eax
  8030b0:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  8030b3:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8030b6:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8030ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8030bd:	6a 00                	push   $0x0
  8030bf:	51                   	push   %ecx
  8030c0:	52                   	push   %edx
  8030c1:	ff 75 0c             	pushl  0xc(%ebp)
  8030c4:	50                   	push   %eax
  8030c5:	6a 00                	push   $0x0
  8030c7:	e8 b0 ff ff ff       	call   80307c <syscall>
  8030cc:	83 c4 18             	add    $0x18,%esp
}
  8030cf:	90                   	nop
  8030d0:	c9                   	leave  
  8030d1:	c3                   	ret    

008030d2 <sys_cgetc>:

int
sys_cgetc(void)
{
  8030d2:	55                   	push   %ebp
  8030d3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8030d5:	6a 00                	push   $0x0
  8030d7:	6a 00                	push   $0x0
  8030d9:	6a 00                	push   $0x0
  8030db:	6a 00                	push   $0x0
  8030dd:	6a 00                	push   $0x0
  8030df:	6a 02                	push   $0x2
  8030e1:	e8 96 ff ff ff       	call   80307c <syscall>
  8030e6:	83 c4 18             	add    $0x18,%esp
}
  8030e9:	c9                   	leave  
  8030ea:	c3                   	ret    

008030eb <sys_lock_cons>:

void sys_lock_cons(void)
{
  8030eb:	55                   	push   %ebp
  8030ec:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  8030ee:	6a 00                	push   $0x0
  8030f0:	6a 00                	push   $0x0
  8030f2:	6a 00                	push   $0x0
  8030f4:	6a 00                	push   $0x0
  8030f6:	6a 00                	push   $0x0
  8030f8:	6a 03                	push   $0x3
  8030fa:	e8 7d ff ff ff       	call   80307c <syscall>
  8030ff:	83 c4 18             	add    $0x18,%esp
}
  803102:	90                   	nop
  803103:	c9                   	leave  
  803104:	c3                   	ret    

00803105 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  803105:	55                   	push   %ebp
  803106:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  803108:	6a 00                	push   $0x0
  80310a:	6a 00                	push   $0x0
  80310c:	6a 00                	push   $0x0
  80310e:	6a 00                	push   $0x0
  803110:	6a 00                	push   $0x0
  803112:	6a 04                	push   $0x4
  803114:	e8 63 ff ff ff       	call   80307c <syscall>
  803119:	83 c4 18             	add    $0x18,%esp
}
  80311c:	90                   	nop
  80311d:	c9                   	leave  
  80311e:	c3                   	ret    

0080311f <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  80311f:	55                   	push   %ebp
  803120:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  803122:	8b 55 0c             	mov    0xc(%ebp),%edx
  803125:	8b 45 08             	mov    0x8(%ebp),%eax
  803128:	6a 00                	push   $0x0
  80312a:	6a 00                	push   $0x0
  80312c:	6a 00                	push   $0x0
  80312e:	52                   	push   %edx
  80312f:	50                   	push   %eax
  803130:	6a 08                	push   $0x8
  803132:	e8 45 ff ff ff       	call   80307c <syscall>
  803137:	83 c4 18             	add    $0x18,%esp
}
  80313a:	c9                   	leave  
  80313b:	c3                   	ret    

0080313c <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  80313c:	55                   	push   %ebp
  80313d:	89 e5                	mov    %esp,%ebp
  80313f:	56                   	push   %esi
  803140:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  803141:	8b 75 18             	mov    0x18(%ebp),%esi
  803144:	8b 5d 14             	mov    0x14(%ebp),%ebx
  803147:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80314a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80314d:	8b 45 08             	mov    0x8(%ebp),%eax
  803150:	56                   	push   %esi
  803151:	53                   	push   %ebx
  803152:	51                   	push   %ecx
  803153:	52                   	push   %edx
  803154:	50                   	push   %eax
  803155:	6a 09                	push   $0x9
  803157:	e8 20 ff ff ff       	call   80307c <syscall>
  80315c:	83 c4 18             	add    $0x18,%esp
}
  80315f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  803162:	5b                   	pop    %ebx
  803163:	5e                   	pop    %esi
  803164:	5d                   	pop    %ebp
  803165:	c3                   	ret    

00803166 <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  803166:	55                   	push   %ebp
  803167:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  803169:	6a 00                	push   $0x0
  80316b:	6a 00                	push   $0x0
  80316d:	6a 00                	push   $0x0
  80316f:	6a 00                	push   $0x0
  803171:	ff 75 08             	pushl  0x8(%ebp)
  803174:	6a 0a                	push   $0xa
  803176:	e8 01 ff ff ff       	call   80307c <syscall>
  80317b:	83 c4 18             	add    $0x18,%esp
}
  80317e:	c9                   	leave  
  80317f:	c3                   	ret    

00803180 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  803180:	55                   	push   %ebp
  803181:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  803183:	6a 00                	push   $0x0
  803185:	6a 00                	push   $0x0
  803187:	6a 00                	push   $0x0
  803189:	ff 75 0c             	pushl  0xc(%ebp)
  80318c:	ff 75 08             	pushl  0x8(%ebp)
  80318f:	6a 0b                	push   $0xb
  803191:	e8 e6 fe ff ff       	call   80307c <syscall>
  803196:	83 c4 18             	add    $0x18,%esp
}
  803199:	c9                   	leave  
  80319a:	c3                   	ret    

0080319b <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  80319b:	55                   	push   %ebp
  80319c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  80319e:	6a 00                	push   $0x0
  8031a0:	6a 00                	push   $0x0
  8031a2:	6a 00                	push   $0x0
  8031a4:	6a 00                	push   $0x0
  8031a6:	6a 00                	push   $0x0
  8031a8:	6a 0c                	push   $0xc
  8031aa:	e8 cd fe ff ff       	call   80307c <syscall>
  8031af:	83 c4 18             	add    $0x18,%esp
}
  8031b2:	c9                   	leave  
  8031b3:	c3                   	ret    

008031b4 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8031b4:	55                   	push   %ebp
  8031b5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8031b7:	6a 00                	push   $0x0
  8031b9:	6a 00                	push   $0x0
  8031bb:	6a 00                	push   $0x0
  8031bd:	6a 00                	push   $0x0
  8031bf:	6a 00                	push   $0x0
  8031c1:	6a 0d                	push   $0xd
  8031c3:	e8 b4 fe ff ff       	call   80307c <syscall>
  8031c8:	83 c4 18             	add    $0x18,%esp
}
  8031cb:	c9                   	leave  
  8031cc:	c3                   	ret    

008031cd <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8031cd:	55                   	push   %ebp
  8031ce:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8031d0:	6a 00                	push   $0x0
  8031d2:	6a 00                	push   $0x0
  8031d4:	6a 00                	push   $0x0
  8031d6:	6a 00                	push   $0x0
  8031d8:	6a 00                	push   $0x0
  8031da:	6a 0e                	push   $0xe
  8031dc:	e8 9b fe ff ff       	call   80307c <syscall>
  8031e1:	83 c4 18             	add    $0x18,%esp
}
  8031e4:	c9                   	leave  
  8031e5:	c3                   	ret    

008031e6 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8031e6:	55                   	push   %ebp
  8031e7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8031e9:	6a 00                	push   $0x0
  8031eb:	6a 00                	push   $0x0
  8031ed:	6a 00                	push   $0x0
  8031ef:	6a 00                	push   $0x0
  8031f1:	6a 00                	push   $0x0
  8031f3:	6a 0f                	push   $0xf
  8031f5:	e8 82 fe ff ff       	call   80307c <syscall>
  8031fa:	83 c4 18             	add    $0x18,%esp
}
  8031fd:	c9                   	leave  
  8031fe:	c3                   	ret    

008031ff <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8031ff:	55                   	push   %ebp
  803200:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  803202:	6a 00                	push   $0x0
  803204:	6a 00                	push   $0x0
  803206:	6a 00                	push   $0x0
  803208:	6a 00                	push   $0x0
  80320a:	ff 75 08             	pushl  0x8(%ebp)
  80320d:	6a 10                	push   $0x10
  80320f:	e8 68 fe ff ff       	call   80307c <syscall>
  803214:	83 c4 18             	add    $0x18,%esp
}
  803217:	c9                   	leave  
  803218:	c3                   	ret    

00803219 <sys_scarce_memory>:

void sys_scarce_memory()
{
  803219:	55                   	push   %ebp
  80321a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  80321c:	6a 00                	push   $0x0
  80321e:	6a 00                	push   $0x0
  803220:	6a 00                	push   $0x0
  803222:	6a 00                	push   $0x0
  803224:	6a 00                	push   $0x0
  803226:	6a 11                	push   $0x11
  803228:	e8 4f fe ff ff       	call   80307c <syscall>
  80322d:	83 c4 18             	add    $0x18,%esp
}
  803230:	90                   	nop
  803231:	c9                   	leave  
  803232:	c3                   	ret    

00803233 <sys_cputc>:

void
sys_cputc(const char c)
{
  803233:	55                   	push   %ebp
  803234:	89 e5                	mov    %esp,%ebp
  803236:	83 ec 04             	sub    $0x4,%esp
  803239:	8b 45 08             	mov    0x8(%ebp),%eax
  80323c:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  80323f:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  803243:	6a 00                	push   $0x0
  803245:	6a 00                	push   $0x0
  803247:	6a 00                	push   $0x0
  803249:	6a 00                	push   $0x0
  80324b:	50                   	push   %eax
  80324c:	6a 01                	push   $0x1
  80324e:	e8 29 fe ff ff       	call   80307c <syscall>
  803253:	83 c4 18             	add    $0x18,%esp
}
  803256:	90                   	nop
  803257:	c9                   	leave  
  803258:	c3                   	ret    

00803259 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  803259:	55                   	push   %ebp
  80325a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  80325c:	6a 00                	push   $0x0
  80325e:	6a 00                	push   $0x0
  803260:	6a 00                	push   $0x0
  803262:	6a 00                	push   $0x0
  803264:	6a 00                	push   $0x0
  803266:	6a 14                	push   $0x14
  803268:	e8 0f fe ff ff       	call   80307c <syscall>
  80326d:	83 c4 18             	add    $0x18,%esp
}
  803270:	90                   	nop
  803271:	c9                   	leave  
  803272:	c3                   	ret    

00803273 <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  803273:	55                   	push   %ebp
  803274:	89 e5                	mov    %esp,%ebp
  803276:	83 ec 04             	sub    $0x4,%esp
  803279:	8b 45 10             	mov    0x10(%ebp),%eax
  80327c:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  80327f:	8b 4d 14             	mov    0x14(%ebp),%ecx
  803282:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  803286:	8b 45 08             	mov    0x8(%ebp),%eax
  803289:	6a 00                	push   $0x0
  80328b:	51                   	push   %ecx
  80328c:	52                   	push   %edx
  80328d:	ff 75 0c             	pushl  0xc(%ebp)
  803290:	50                   	push   %eax
  803291:	6a 15                	push   $0x15
  803293:	e8 e4 fd ff ff       	call   80307c <syscall>
  803298:	83 c4 18             	add    $0x18,%esp
}
  80329b:	c9                   	leave  
  80329c:	c3                   	ret    

0080329d <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  80329d:	55                   	push   %ebp
  80329e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8032a0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8032a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8032a6:	6a 00                	push   $0x0
  8032a8:	6a 00                	push   $0x0
  8032aa:	6a 00                	push   $0x0
  8032ac:	52                   	push   %edx
  8032ad:	50                   	push   %eax
  8032ae:	6a 16                	push   $0x16
  8032b0:	e8 c7 fd ff ff       	call   80307c <syscall>
  8032b5:	83 c4 18             	add    $0x18,%esp
}
  8032b8:	c9                   	leave  
  8032b9:	c3                   	ret    

008032ba <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  8032ba:	55                   	push   %ebp
  8032bb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8032bd:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8032c0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8032c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8032c6:	6a 00                	push   $0x0
  8032c8:	6a 00                	push   $0x0
  8032ca:	51                   	push   %ecx
  8032cb:	52                   	push   %edx
  8032cc:	50                   	push   %eax
  8032cd:	6a 17                	push   $0x17
  8032cf:	e8 a8 fd ff ff       	call   80307c <syscall>
  8032d4:	83 c4 18             	add    $0x18,%esp
}
  8032d7:	c9                   	leave  
  8032d8:	c3                   	ret    

008032d9 <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  8032d9:	55                   	push   %ebp
  8032da:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8032dc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8032df:	8b 45 08             	mov    0x8(%ebp),%eax
  8032e2:	6a 00                	push   $0x0
  8032e4:	6a 00                	push   $0x0
  8032e6:	6a 00                	push   $0x0
  8032e8:	52                   	push   %edx
  8032e9:	50                   	push   %eax
  8032ea:	6a 18                	push   $0x18
  8032ec:	e8 8b fd ff ff       	call   80307c <syscall>
  8032f1:	83 c4 18             	add    $0x18,%esp
}
  8032f4:	c9                   	leave  
  8032f5:	c3                   	ret    

008032f6 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8032f6:	55                   	push   %ebp
  8032f7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8032f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8032fc:	6a 00                	push   $0x0
  8032fe:	ff 75 14             	pushl  0x14(%ebp)
  803301:	ff 75 10             	pushl  0x10(%ebp)
  803304:	ff 75 0c             	pushl  0xc(%ebp)
  803307:	50                   	push   %eax
  803308:	6a 19                	push   $0x19
  80330a:	e8 6d fd ff ff       	call   80307c <syscall>
  80330f:	83 c4 18             	add    $0x18,%esp
}
  803312:	c9                   	leave  
  803313:	c3                   	ret    

00803314 <sys_run_env>:

void sys_run_env(int32 envId)
{
  803314:	55                   	push   %ebp
  803315:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  803317:	8b 45 08             	mov    0x8(%ebp),%eax
  80331a:	6a 00                	push   $0x0
  80331c:	6a 00                	push   $0x0
  80331e:	6a 00                	push   $0x0
  803320:	6a 00                	push   $0x0
  803322:	50                   	push   %eax
  803323:	6a 1a                	push   $0x1a
  803325:	e8 52 fd ff ff       	call   80307c <syscall>
  80332a:	83 c4 18             	add    $0x18,%esp
}
  80332d:	90                   	nop
  80332e:	c9                   	leave  
  80332f:	c3                   	ret    

00803330 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  803330:	55                   	push   %ebp
  803331:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  803333:	8b 45 08             	mov    0x8(%ebp),%eax
  803336:	6a 00                	push   $0x0
  803338:	6a 00                	push   $0x0
  80333a:	6a 00                	push   $0x0
  80333c:	6a 00                	push   $0x0
  80333e:	50                   	push   %eax
  80333f:	6a 1b                	push   $0x1b
  803341:	e8 36 fd ff ff       	call   80307c <syscall>
  803346:	83 c4 18             	add    $0x18,%esp
}
  803349:	c9                   	leave  
  80334a:	c3                   	ret    

0080334b <sys_getenvid>:

int32 sys_getenvid(void)
{
  80334b:	55                   	push   %ebp
  80334c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  80334e:	6a 00                	push   $0x0
  803350:	6a 00                	push   $0x0
  803352:	6a 00                	push   $0x0
  803354:	6a 00                	push   $0x0
  803356:	6a 00                	push   $0x0
  803358:	6a 05                	push   $0x5
  80335a:	e8 1d fd ff ff       	call   80307c <syscall>
  80335f:	83 c4 18             	add    $0x18,%esp
}
  803362:	c9                   	leave  
  803363:	c3                   	ret    

00803364 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  803364:	55                   	push   %ebp
  803365:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  803367:	6a 00                	push   $0x0
  803369:	6a 00                	push   $0x0
  80336b:	6a 00                	push   $0x0
  80336d:	6a 00                	push   $0x0
  80336f:	6a 00                	push   $0x0
  803371:	6a 06                	push   $0x6
  803373:	e8 04 fd ff ff       	call   80307c <syscall>
  803378:	83 c4 18             	add    $0x18,%esp
}
  80337b:	c9                   	leave  
  80337c:	c3                   	ret    

0080337d <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  80337d:	55                   	push   %ebp
  80337e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  803380:	6a 00                	push   $0x0
  803382:	6a 00                	push   $0x0
  803384:	6a 00                	push   $0x0
  803386:	6a 00                	push   $0x0
  803388:	6a 00                	push   $0x0
  80338a:	6a 07                	push   $0x7
  80338c:	e8 eb fc ff ff       	call   80307c <syscall>
  803391:	83 c4 18             	add    $0x18,%esp
}
  803394:	c9                   	leave  
  803395:	c3                   	ret    

00803396 <sys_exit_env>:


void sys_exit_env(void)
{
  803396:	55                   	push   %ebp
  803397:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  803399:	6a 00                	push   $0x0
  80339b:	6a 00                	push   $0x0
  80339d:	6a 00                	push   $0x0
  80339f:	6a 00                	push   $0x0
  8033a1:	6a 00                	push   $0x0
  8033a3:	6a 1c                	push   $0x1c
  8033a5:	e8 d2 fc ff ff       	call   80307c <syscall>
  8033aa:	83 c4 18             	add    $0x18,%esp
}
  8033ad:	90                   	nop
  8033ae:	c9                   	leave  
  8033af:	c3                   	ret    

008033b0 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  8033b0:	55                   	push   %ebp
  8033b1:	89 e5                	mov    %esp,%ebp
  8033b3:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8033b6:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8033b9:	8d 50 04             	lea    0x4(%eax),%edx
  8033bc:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8033bf:	6a 00                	push   $0x0
  8033c1:	6a 00                	push   $0x0
  8033c3:	6a 00                	push   $0x0
  8033c5:	52                   	push   %edx
  8033c6:	50                   	push   %eax
  8033c7:	6a 1d                	push   $0x1d
  8033c9:	e8 ae fc ff ff       	call   80307c <syscall>
  8033ce:	83 c4 18             	add    $0x18,%esp
	return result;
  8033d1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8033d4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8033d7:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8033da:	89 01                	mov    %eax,(%ecx)
  8033dc:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8033df:	8b 45 08             	mov    0x8(%ebp),%eax
  8033e2:	c9                   	leave  
  8033e3:	c2 04 00             	ret    $0x4

008033e6 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8033e6:	55                   	push   %ebp
  8033e7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8033e9:	6a 00                	push   $0x0
  8033eb:	6a 00                	push   $0x0
  8033ed:	ff 75 10             	pushl  0x10(%ebp)
  8033f0:	ff 75 0c             	pushl  0xc(%ebp)
  8033f3:	ff 75 08             	pushl  0x8(%ebp)
  8033f6:	6a 13                	push   $0x13
  8033f8:	e8 7f fc ff ff       	call   80307c <syscall>
  8033fd:	83 c4 18             	add    $0x18,%esp
	return ;
  803400:	90                   	nop
}
  803401:	c9                   	leave  
  803402:	c3                   	ret    

00803403 <sys_rcr2>:
uint32 sys_rcr2()
{
  803403:	55                   	push   %ebp
  803404:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  803406:	6a 00                	push   $0x0
  803408:	6a 00                	push   $0x0
  80340a:	6a 00                	push   $0x0
  80340c:	6a 00                	push   $0x0
  80340e:	6a 00                	push   $0x0
  803410:	6a 1e                	push   $0x1e
  803412:	e8 65 fc ff ff       	call   80307c <syscall>
  803417:	83 c4 18             	add    $0x18,%esp
}
  80341a:	c9                   	leave  
  80341b:	c3                   	ret    

0080341c <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  80341c:	55                   	push   %ebp
  80341d:	89 e5                	mov    %esp,%ebp
  80341f:	83 ec 04             	sub    $0x4,%esp
  803422:	8b 45 08             	mov    0x8(%ebp),%eax
  803425:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  803428:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  80342c:	6a 00                	push   $0x0
  80342e:	6a 00                	push   $0x0
  803430:	6a 00                	push   $0x0
  803432:	6a 00                	push   $0x0
  803434:	50                   	push   %eax
  803435:	6a 1f                	push   $0x1f
  803437:	e8 40 fc ff ff       	call   80307c <syscall>
  80343c:	83 c4 18             	add    $0x18,%esp
	return ;
  80343f:	90                   	nop
}
  803440:	c9                   	leave  
  803441:	c3                   	ret    

00803442 <rsttst>:
void rsttst()
{
  803442:	55                   	push   %ebp
  803443:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  803445:	6a 00                	push   $0x0
  803447:	6a 00                	push   $0x0
  803449:	6a 00                	push   $0x0
  80344b:	6a 00                	push   $0x0
  80344d:	6a 00                	push   $0x0
  80344f:	6a 21                	push   $0x21
  803451:	e8 26 fc ff ff       	call   80307c <syscall>
  803456:	83 c4 18             	add    $0x18,%esp
	return ;
  803459:	90                   	nop
}
  80345a:	c9                   	leave  
  80345b:	c3                   	ret    

0080345c <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  80345c:	55                   	push   %ebp
  80345d:	89 e5                	mov    %esp,%ebp
  80345f:	83 ec 04             	sub    $0x4,%esp
  803462:	8b 45 14             	mov    0x14(%ebp),%eax
  803465:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  803468:	8b 55 18             	mov    0x18(%ebp),%edx
  80346b:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80346f:	52                   	push   %edx
  803470:	50                   	push   %eax
  803471:	ff 75 10             	pushl  0x10(%ebp)
  803474:	ff 75 0c             	pushl  0xc(%ebp)
  803477:	ff 75 08             	pushl  0x8(%ebp)
  80347a:	6a 20                	push   $0x20
  80347c:	e8 fb fb ff ff       	call   80307c <syscall>
  803481:	83 c4 18             	add    $0x18,%esp
	return ;
  803484:	90                   	nop
}
  803485:	c9                   	leave  
  803486:	c3                   	ret    

00803487 <chktst>:
void chktst(uint32 n)
{
  803487:	55                   	push   %ebp
  803488:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  80348a:	6a 00                	push   $0x0
  80348c:	6a 00                	push   $0x0
  80348e:	6a 00                	push   $0x0
  803490:	6a 00                	push   $0x0
  803492:	ff 75 08             	pushl  0x8(%ebp)
  803495:	6a 22                	push   $0x22
  803497:	e8 e0 fb ff ff       	call   80307c <syscall>
  80349c:	83 c4 18             	add    $0x18,%esp
	return ;
  80349f:	90                   	nop
}
  8034a0:	c9                   	leave  
  8034a1:	c3                   	ret    

008034a2 <inctst>:

void inctst()
{
  8034a2:	55                   	push   %ebp
  8034a3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8034a5:	6a 00                	push   $0x0
  8034a7:	6a 00                	push   $0x0
  8034a9:	6a 00                	push   $0x0
  8034ab:	6a 00                	push   $0x0
  8034ad:	6a 00                	push   $0x0
  8034af:	6a 23                	push   $0x23
  8034b1:	e8 c6 fb ff ff       	call   80307c <syscall>
  8034b6:	83 c4 18             	add    $0x18,%esp
	return ;
  8034b9:	90                   	nop
}
  8034ba:	c9                   	leave  
  8034bb:	c3                   	ret    

008034bc <gettst>:
uint32 gettst()
{
  8034bc:	55                   	push   %ebp
  8034bd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8034bf:	6a 00                	push   $0x0
  8034c1:	6a 00                	push   $0x0
  8034c3:	6a 00                	push   $0x0
  8034c5:	6a 00                	push   $0x0
  8034c7:	6a 00                	push   $0x0
  8034c9:	6a 24                	push   $0x24
  8034cb:	e8 ac fb ff ff       	call   80307c <syscall>
  8034d0:	83 c4 18             	add    $0x18,%esp
}
  8034d3:	c9                   	leave  
  8034d4:	c3                   	ret    

008034d5 <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  8034d5:	55                   	push   %ebp
  8034d6:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8034d8:	6a 00                	push   $0x0
  8034da:	6a 00                	push   $0x0
  8034dc:	6a 00                	push   $0x0
  8034de:	6a 00                	push   $0x0
  8034e0:	6a 00                	push   $0x0
  8034e2:	6a 25                	push   $0x25
  8034e4:	e8 93 fb ff ff       	call   80307c <syscall>
  8034e9:	83 c4 18             	add    $0x18,%esp
  8034ec:	a3 60 d0 81 00       	mov    %eax,0x81d060
	return uheapPlaceStrategy ;
  8034f1:	a1 60 d0 81 00       	mov    0x81d060,%eax
}
  8034f6:	c9                   	leave  
  8034f7:	c3                   	ret    

008034f8 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  8034f8:	55                   	push   %ebp
  8034f9:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  8034fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8034fe:	a3 60 d0 81 00       	mov    %eax,0x81d060
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  803503:	6a 00                	push   $0x0
  803505:	6a 00                	push   $0x0
  803507:	6a 00                	push   $0x0
  803509:	6a 00                	push   $0x0
  80350b:	ff 75 08             	pushl  0x8(%ebp)
  80350e:	6a 26                	push   $0x26
  803510:	e8 67 fb ff ff       	call   80307c <syscall>
  803515:	83 c4 18             	add    $0x18,%esp
	return ;
  803518:	90                   	nop
}
  803519:	c9                   	leave  
  80351a:	c3                   	ret    

0080351b <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  80351b:	55                   	push   %ebp
  80351c:	89 e5                	mov    %esp,%ebp
  80351e:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  80351f:	8b 5d 14             	mov    0x14(%ebp),%ebx
  803522:	8b 4d 10             	mov    0x10(%ebp),%ecx
  803525:	8b 55 0c             	mov    0xc(%ebp),%edx
  803528:	8b 45 08             	mov    0x8(%ebp),%eax
  80352b:	6a 00                	push   $0x0
  80352d:	53                   	push   %ebx
  80352e:	51                   	push   %ecx
  80352f:	52                   	push   %edx
  803530:	50                   	push   %eax
  803531:	6a 27                	push   $0x27
  803533:	e8 44 fb ff ff       	call   80307c <syscall>
  803538:	83 c4 18             	add    $0x18,%esp
}
  80353b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80353e:	c9                   	leave  
  80353f:	c3                   	ret    

00803540 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  803540:	55                   	push   %ebp
  803541:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  803543:	8b 55 0c             	mov    0xc(%ebp),%edx
  803546:	8b 45 08             	mov    0x8(%ebp),%eax
  803549:	6a 00                	push   $0x0
  80354b:	6a 00                	push   $0x0
  80354d:	6a 00                	push   $0x0
  80354f:	52                   	push   %edx
  803550:	50                   	push   %eax
  803551:	6a 28                	push   $0x28
  803553:	e8 24 fb ff ff       	call   80307c <syscall>
  803558:	83 c4 18             	add    $0x18,%esp
}
  80355b:	c9                   	leave  
  80355c:	c3                   	ret    

0080355d <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  80355d:	55                   	push   %ebp
  80355e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  803560:	8b 4d 14             	mov    0x14(%ebp),%ecx
  803563:	8b 55 0c             	mov    0xc(%ebp),%edx
  803566:	8b 45 08             	mov    0x8(%ebp),%eax
  803569:	6a 00                	push   $0x0
  80356b:	51                   	push   %ecx
  80356c:	ff 75 10             	pushl  0x10(%ebp)
  80356f:	52                   	push   %edx
  803570:	50                   	push   %eax
  803571:	6a 29                	push   $0x29
  803573:	e8 04 fb ff ff       	call   80307c <syscall>
  803578:	83 c4 18             	add    $0x18,%esp
}
  80357b:	c9                   	leave  
  80357c:	c3                   	ret    

0080357d <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  80357d:	55                   	push   %ebp
  80357e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  803580:	6a 00                	push   $0x0
  803582:	6a 00                	push   $0x0
  803584:	ff 75 10             	pushl  0x10(%ebp)
  803587:	ff 75 0c             	pushl  0xc(%ebp)
  80358a:	ff 75 08             	pushl  0x8(%ebp)
  80358d:	6a 12                	push   $0x12
  80358f:	e8 e8 fa ff ff       	call   80307c <syscall>
  803594:	83 c4 18             	add    $0x18,%esp
	return ;
  803597:	90                   	nop
}
  803598:	c9                   	leave  
  803599:	c3                   	ret    

0080359a <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  80359a:	55                   	push   %ebp
  80359b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  80359d:	8b 55 0c             	mov    0xc(%ebp),%edx
  8035a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8035a3:	6a 00                	push   $0x0
  8035a5:	6a 00                	push   $0x0
  8035a7:	6a 00                	push   $0x0
  8035a9:	52                   	push   %edx
  8035aa:	50                   	push   %eax
  8035ab:	6a 2a                	push   $0x2a
  8035ad:	e8 ca fa ff ff       	call   80307c <syscall>
  8035b2:	83 c4 18             	add    $0x18,%esp
	return;
  8035b5:	90                   	nop
}
  8035b6:	c9                   	leave  
  8035b7:	c3                   	ret    

008035b8 <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  8035b8:	55                   	push   %ebp
  8035b9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  8035bb:	6a 00                	push   $0x0
  8035bd:	6a 00                	push   $0x0
  8035bf:	6a 00                	push   $0x0
  8035c1:	6a 00                	push   $0x0
  8035c3:	6a 00                	push   $0x0
  8035c5:	6a 2b                	push   $0x2b
  8035c7:	e8 b0 fa ff ff       	call   80307c <syscall>
  8035cc:	83 c4 18             	add    $0x18,%esp
}
  8035cf:	c9                   	leave  
  8035d0:	c3                   	ret    

008035d1 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8035d1:	55                   	push   %ebp
  8035d2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  8035d4:	6a 00                	push   $0x0
  8035d6:	6a 00                	push   $0x0
  8035d8:	6a 00                	push   $0x0
  8035da:	ff 75 0c             	pushl  0xc(%ebp)
  8035dd:	ff 75 08             	pushl  0x8(%ebp)
  8035e0:	6a 2d                	push   $0x2d
  8035e2:	e8 95 fa ff ff       	call   80307c <syscall>
  8035e7:	83 c4 18             	add    $0x18,%esp
	return;
  8035ea:	90                   	nop
}
  8035eb:	c9                   	leave  
  8035ec:	c3                   	ret    

008035ed <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8035ed:	55                   	push   %ebp
  8035ee:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  8035f0:	6a 00                	push   $0x0
  8035f2:	6a 00                	push   $0x0
  8035f4:	6a 00                	push   $0x0
  8035f6:	ff 75 0c             	pushl  0xc(%ebp)
  8035f9:	ff 75 08             	pushl  0x8(%ebp)
  8035fc:	6a 2c                	push   $0x2c
  8035fe:	e8 79 fa ff ff       	call   80307c <syscall>
  803603:	83 c4 18             	add    $0x18,%esp
	return ;
  803606:	90                   	nop
}
  803607:	c9                   	leave  
  803608:	c3                   	ret    

00803609 <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  803609:	55                   	push   %ebp
  80360a:	89 e5                	mov    %esp,%ebp
	//TODO: [PROJECT'25.IM#4] CPU SCHEDULING - #1 System Calls - Add suitable code here
	//Your code is here
	//Comment the following line
	//panic("sys_env_set_priority() is not implemented yet...!!");
	syscall(SYS_env_set_priority, envID, priority, 0, 0, 0);
  80360c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80360f:	8b 45 08             	mov    0x8(%ebp),%eax
  803612:	6a 00                	push   $0x0
  803614:	6a 00                	push   $0x0
  803616:	6a 00                	push   $0x0
  803618:	52                   	push   %edx
  803619:	50                   	push   %eax
  80361a:	6a 2e                	push   $0x2e
  80361c:	e8 5b fa ff ff       	call   80307c <syscall>
  803621:	83 c4 18             	add    $0x18,%esp
	    return;
  803624:	90                   	nop
}
  803625:	c9                   	leave  
  803626:	c3                   	ret    

00803627 <to_page_va>:
//==================================================================================//
//==================================
// [1] GET PAGE VA:
//==================================
__inline__ uint32 to_page_va(struct PageInfoElement *ptrPageInfo)
{
  803627:	55                   	push   %ebp
  803628:	89 e5                	mov    %esp,%ebp
  80362a:	83 ec 10             	sub    $0x10,%esp
	//Get start VA of the page from the corresponding Page Info pointer
	int idxInPageInfoArr = (ptrPageInfo - pageBlockInfoArr);
  80362d:	8b 45 08             	mov    0x8(%ebp),%eax
  803630:	ba 60 50 80 00       	mov    $0x805060,%edx
  803635:	29 d0                	sub    %edx,%eax
  803637:	c1 f8 02             	sar    $0x2,%eax
  80363a:	89 c2                	mov    %eax,%edx
  80363c:	89 d0                	mov    %edx,%eax
  80363e:	c1 e0 02             	shl    $0x2,%eax
  803641:	01 d0                	add    %edx,%eax
  803643:	c1 e0 02             	shl    $0x2,%eax
  803646:	01 d0                	add    %edx,%eax
  803648:	c1 e0 02             	shl    $0x2,%eax
  80364b:	01 d0                	add    %edx,%eax
  80364d:	89 c1                	mov    %eax,%ecx
  80364f:	c1 e1 08             	shl    $0x8,%ecx
  803652:	01 c8                	add    %ecx,%eax
  803654:	89 c1                	mov    %eax,%ecx
  803656:	c1 e1 10             	shl    $0x10,%ecx
  803659:	01 c8                	add    %ecx,%eax
  80365b:	01 c0                	add    %eax,%eax
  80365d:	01 d0                	add    %edx,%eax
  80365f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return dynAllocStart + (idxInPageInfoArr << PGSHIFT);
  803662:	8b 45 fc             	mov    -0x4(%ebp),%eax
  803665:	c1 e0 0c             	shl    $0xc,%eax
  803668:	89 c2                	mov    %eax,%edx
  80366a:	a1 64 d0 81 00       	mov    0x81d064,%eax
  80366f:	01 d0                	add    %edx,%eax
}
  803671:	c9                   	leave  
  803672:	c3                   	ret    

00803673 <log2>:

//==================================================================================//
//============================ REQUIRED FUNCTIONS ==================================//
//==================================================================================//
__inline__ int log2(uint32 n)
	{
  803673:	55                   	push   %ebp
  803674:	89 e5                	mov    %esp,%ebp
  803676:	83 ec 10             	sub    $0x10,%esp
		int result = 0;
  803679:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
		while( n > 1){
  803680:	eb 06                	jmp    803688 <log2+0x15>
			n >>=1;
  803682:	d1 6d 08             	shrl   0x8(%ebp)
			result++;
  803685:	ff 45 fc             	incl   -0x4(%ebp)
//============================ REQUIRED FUNCTIONS ==================================//
//==================================================================================//
__inline__ int log2(uint32 n)
	{
		int result = 0;
		while( n > 1){
  803688:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
  80368c:	77 f4                	ja     803682 <log2+0xf>
			n >>=1;
			result++;
		}
		return result;
  80368e:	8b 45 fc             	mov    -0x4(%ebp),%eax
	}
  803691:	c9                   	leave  
  803692:	c3                   	ret    

00803693 <initialize_dynamic_allocator>:
//==================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================
bool is_initialized = 0;
void initialize_dynamic_allocator(uint32 daStart, uint32 daEnd)
{
  803693:	55                   	push   %ebp
  803694:	89 e5                	mov    %esp,%ebp
  803696:	83 ec 18             	sub    $0x18,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(daEnd <= daStart + DYN_ALLOC_MAX_SIZE);
  803699:	8b 45 08             	mov    0x8(%ebp),%eax
  80369c:	05 00 00 00 02       	add    $0x2000000,%eax
  8036a1:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8036a4:	73 16                	jae    8036bc <initialize_dynamic_allocator+0x29>
  8036a6:	68 f8 4d 80 00       	push   $0x804df8
  8036ab:	68 1e 4e 80 00       	push   $0x804e1e
  8036b0:	6a 2d                	push   $0x2d
  8036b2:	68 33 4e 80 00       	push   $0x804e33
  8036b7:	e8 a6 ce ff ff       	call   800562 <_panic>
		is_initialized = 1;
  8036bc:	c7 05 24 50 80 00 01 	movl   $0x1,0x805024
  8036c3:	00 00 00 
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #1 initialize_dynamic_allocator
	//Your code is here


	dynAllocStart = daStart;
  8036c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8036c9:	a3 64 d0 81 00       	mov    %eax,0x81d064
	dynAllocEnd= daEnd;
  8036ce:	8b 45 0c             	mov    0xc(%ebp),%eax
  8036d1:	a3 40 50 80 00       	mov    %eax,0x805040
	int numOfPages = (dynAllocEnd - dynAllocStart)/PAGE_SIZE;
  8036d6:	8b 15 40 50 80 00    	mov    0x805040,%edx
  8036dc:	a1 64 d0 81 00       	mov    0x81d064,%eax
  8036e1:	29 c2                	sub    %eax,%edx
  8036e3:	89 d0                	mov    %edx,%eax
  8036e5:	c1 e8 0c             	shr    $0xc,%eax
  8036e8:	89 45 e8             	mov    %eax,-0x18(%ebp)


	for(int i=0; i< numOfPages; i++){
  8036eb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8036f2:	eb 2f                	jmp    803723 <initialize_dynamic_allocator+0x90>
	    pageBlockInfoArr[i].block_size=0;
  8036f4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8036f7:	89 d0                	mov    %edx,%eax
  8036f9:	01 c0                	add    %eax,%eax
  8036fb:	01 d0                	add    %edx,%eax
  8036fd:	c1 e0 02             	shl    $0x2,%eax
  803700:	05 68 50 80 00       	add    $0x805068,%eax
  803705:	66 c7 00 00 00       	movw   $0x0,(%eax)
	    pageBlockInfoArr[i].num_of_free_blocks=0;
  80370a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80370d:	89 d0                	mov    %edx,%eax
  80370f:	01 c0                	add    %eax,%eax
  803711:	01 d0                	add    %edx,%eax
  803713:	c1 e0 02             	shl    $0x2,%eax
  803716:	05 6a 50 80 00       	add    $0x80506a,%eax
  80371b:	66 c7 00 00 00       	movw   $0x0,(%eax)
	dynAllocStart = daStart;
	dynAllocEnd= daEnd;
	int numOfPages = (dynAllocEnd - dynAllocStart)/PAGE_SIZE;


	for(int i=0; i< numOfPages; i++){
  803720:	ff 45 f4             	incl   -0xc(%ebp)
  803723:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803726:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803729:	7c c9                	jl     8036f4 <initialize_dynamic_allocator+0x61>
	    pageBlockInfoArr[i].block_size=0;
	    pageBlockInfoArr[i].num_of_free_blocks=0;
	}


	LIST_INIT(&freePagesList);
  80372b:	c7 05 48 50 80 00 00 	movl   $0x0,0x805048
  803732:	00 00 00 
  803735:	c7 05 4c 50 80 00 00 	movl   $0x0,0x80504c
  80373c:	00 00 00 
  80373f:	c7 05 54 50 80 00 00 	movl   $0x0,0x805054
  803746:	00 00 00 
	for(int i=0; i<numOfPages; i++){
  803749:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  803750:	e9 9c 00 00 00       	jmp    8037f1 <initialize_dynamic_allocator+0x15e>
		LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
  803755:	8b 15 4c 50 80 00    	mov    0x80504c,%edx
  80375b:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80375e:	89 c8                	mov    %ecx,%eax
  803760:	01 c0                	add    %eax,%eax
  803762:	01 c8                	add    %ecx,%eax
  803764:	c1 e0 02             	shl    $0x2,%eax
  803767:	05 64 50 80 00       	add    $0x805064,%eax
  80376c:	89 10                	mov    %edx,(%eax)
  80376e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803771:	89 d0                	mov    %edx,%eax
  803773:	01 c0                	add    %eax,%eax
  803775:	01 d0                	add    %edx,%eax
  803777:	c1 e0 02             	shl    $0x2,%eax
  80377a:	05 64 50 80 00       	add    $0x805064,%eax
  80377f:	8b 00                	mov    (%eax),%eax
  803781:	85 c0                	test   %eax,%eax
  803783:	74 1b                	je     8037a0 <initialize_dynamic_allocator+0x10d>
  803785:	8b 15 4c 50 80 00    	mov    0x80504c,%edx
  80378b:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80378e:	89 c8                	mov    %ecx,%eax
  803790:	01 c0                	add    %eax,%eax
  803792:	01 c8                	add    %ecx,%eax
  803794:	c1 e0 02             	shl    $0x2,%eax
  803797:	05 60 50 80 00       	add    $0x805060,%eax
  80379c:	89 02                	mov    %eax,(%edx)
  80379e:	eb 16                	jmp    8037b6 <initialize_dynamic_allocator+0x123>
  8037a0:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8037a3:	89 d0                	mov    %edx,%eax
  8037a5:	01 c0                	add    %eax,%eax
  8037a7:	01 d0                	add    %edx,%eax
  8037a9:	c1 e0 02             	shl    $0x2,%eax
  8037ac:	05 60 50 80 00       	add    $0x805060,%eax
  8037b1:	a3 48 50 80 00       	mov    %eax,0x805048
  8037b6:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8037b9:	89 d0                	mov    %edx,%eax
  8037bb:	01 c0                	add    %eax,%eax
  8037bd:	01 d0                	add    %edx,%eax
  8037bf:	c1 e0 02             	shl    $0x2,%eax
  8037c2:	05 60 50 80 00       	add    $0x805060,%eax
  8037c7:	a3 4c 50 80 00       	mov    %eax,0x80504c
  8037cc:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8037cf:	89 d0                	mov    %edx,%eax
  8037d1:	01 c0                	add    %eax,%eax
  8037d3:	01 d0                	add    %edx,%eax
  8037d5:	c1 e0 02             	shl    $0x2,%eax
  8037d8:	05 60 50 80 00       	add    $0x805060,%eax
  8037dd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8037e3:	a1 54 50 80 00       	mov    0x805054,%eax
  8037e8:	40                   	inc    %eax
  8037e9:	a3 54 50 80 00       	mov    %eax,0x805054
	    pageBlockInfoArr[i].num_of_free_blocks=0;
	}


	LIST_INIT(&freePagesList);
	for(int i=0; i<numOfPages; i++){
  8037ee:	ff 45 f0             	incl   -0x10(%ebp)
  8037f1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8037f4:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8037f7:	0f 8c 58 ff ff ff    	jl     803755 <initialize_dynamic_allocator+0xc2>
		LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
	}



	for (int i = 0; i < LOG2_MAX_SIZE - LOG2_MIN_SIZE + 1; i++) {
  8037fd:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  803804:	eb 36                	jmp    80383c <initialize_dynamic_allocator+0x1a9>
	    LIST_INIT(&freeBlockLists[i]);
  803806:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803809:	c1 e0 04             	shl    $0x4,%eax
  80380c:	05 80 d0 81 00       	add    $0x81d080,%eax
  803811:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803817:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80381a:	c1 e0 04             	shl    $0x4,%eax
  80381d:	05 84 d0 81 00       	add    $0x81d084,%eax
  803822:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803828:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80382b:	c1 e0 04             	shl    $0x4,%eax
  80382e:	05 8c d0 81 00       	add    $0x81d08c,%eax
  803833:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
	}



	for (int i = 0; i < LOG2_MAX_SIZE - LOG2_MIN_SIZE + 1; i++) {
  803839:	ff 45 ec             	incl   -0x14(%ebp)
  80383c:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  803840:	7e c4                	jle    803806 <initialize_dynamic_allocator+0x173>


	//Comment the following line
	//panic("initialize_dynamic_allocator() Not implemented yet");

}
  803842:	90                   	nop
  803843:	c9                   	leave  
  803844:	c3                   	ret    

00803845 <get_block_size>:
// [2] GET BLOCK SIZE:
//===========================


__inline__ uint32 get_block_size(void *va)
{
  803845:	55                   	push   %ebp
  803846:	89 e5                	mov    %esp,%ebp
  803848:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #2 get_block_size
	//Your code is here

	uint32 page_index = ((uint32)va - dynAllocStart)/ PAGE_SIZE;
  80384b:	8b 55 08             	mov    0x8(%ebp),%edx
  80384e:	a1 64 d0 81 00       	mov    0x81d064,%eax
  803853:	29 c2                	sub    %eax,%edx
  803855:	89 d0                	mov    %edx,%eax
  803857:	c1 e8 0c             	shr    $0xc,%eax
  80385a:	89 45 fc             	mov    %eax,-0x4(%ebp)
    return pageBlockInfoArr[page_index].block_size;
  80385d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  803860:	89 d0                	mov    %edx,%eax
  803862:	01 c0                	add    %eax,%eax
  803864:	01 d0                	add    %edx,%eax
  803866:	c1 e0 02             	shl    $0x2,%eax
  803869:	05 68 50 80 00       	add    $0x805068,%eax
  80386e:	8b 00                	mov    (%eax),%eax
  803870:	0f b7 c0             	movzwl %ax,%eax
	//Comment the following line
	//panic("get_block_size() Not implemented yet");
}
  803873:	c9                   	leave  
  803874:	c3                   	ret    

00803875 <alloc_block>:

//===========================
// 3) ALLOCATE BLOCK:
//===========================
void *alloc_block(uint32 size)
{
  803875:	55                   	push   %ebp
  803876:	89 e5                	mov    %esp,%ebp
  803878:	83 ec 48             	sub    $0x48,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(size <= DYN_ALLOC_MAX_BLOCK_SIZE);
  80387b:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  803882:	76 16                	jbe    80389a <alloc_block+0x25>
  803884:	68 4c 4e 80 00       	push   $0x804e4c
  803889:	68 1e 4e 80 00       	push   $0x804e1e
  80388e:	6a 6c                	push   $0x6c
  803890:	68 33 4e 80 00       	push   $0x804e33
  803895:	e8 c8 cc ff ff       	call   800562 <_panic>
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #3 alloc_block
	//Your code is here


	if(size == 0){
  80389a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80389e:	75 0a                	jne    8038aa <alloc_block+0x35>
		return NULL;
  8038a0:	b8 00 00 00 00       	mov    $0x0,%eax
  8038a5:	e9 65 04 00 00       	jmp    803d0f <alloc_block+0x49a>
	}
	else if(size<=8){
  8038aa:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  8038ae:	77 09                	ja     8038b9 <alloc_block+0x44>
		size=8;
  8038b0:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
  8038b7:	eb 1f                	jmp    8038d8 <alloc_block+0x63>
	}
	else{
		uint32 reqsize=8;
  8038b9:	c7 45 f4 08 00 00 00 	movl   $0x8,-0xc(%ebp)
		while(reqsize < size){
  8038c0:	eb 08                	jmp    8038ca <alloc_block+0x55>
			reqsize*=2;
  8038c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8038c5:	01 c0                	add    %eax,%eax
  8038c7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	else if(size<=8){
		size=8;
	}
	else{
		uint32 reqsize=8;
		while(reqsize < size){
  8038ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8038cd:	3b 45 08             	cmp    0x8(%ebp),%eax
  8038d0:	72 f0                	jb     8038c2 <alloc_block+0x4d>
			reqsize*=2;
		}
		size= reqsize;
  8038d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8038d5:	89 45 08             	mov    %eax,0x8(%ebp)
	}

	int list_index = log2(size)- LOG2_MIN_SIZE;
  8038d8:	83 ec 0c             	sub    $0xc,%esp
  8038db:	ff 75 08             	pushl  0x8(%ebp)
  8038de:	e8 90 fd ff ff       	call   803673 <log2>
  8038e3:	83 c4 10             	add    $0x10,%esp
  8038e6:	83 e8 03             	sub    $0x3,%eax
  8038e9:	89 45 e8             	mov    %eax,-0x18(%ebp)

	if(!LIST_EMPTY(&freeBlockLists[list_index])){
  8038ec:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8038ef:	c1 e0 04             	shl    $0x4,%eax
  8038f2:	05 80 d0 81 00       	add    $0x81d080,%eax
  8038f7:	8b 00                	mov    (%eax),%eax
  8038f9:	85 c0                	test   %eax,%eax
  8038fb:	0f 84 fb 00 00 00    	je     8039fc <alloc_block+0x187>
		struct BlockElement *block = LIST_FIRST(&freeBlockLists[list_index]);
  803901:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803904:	c1 e0 04             	shl    $0x4,%eax
  803907:	05 80 d0 81 00       	add    $0x81d080,%eax
  80390c:	8b 00                	mov    (%eax),%eax
  80390e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		LIST_REMOVE(&freeBlockLists[list_index], block);
  803911:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803915:	75 17                	jne    80392e <alloc_block+0xb9>
  803917:	83 ec 04             	sub    $0x4,%esp
  80391a:	68 6d 4e 80 00       	push   $0x804e6d
  80391f:	68 86 00 00 00       	push   $0x86
  803924:	68 33 4e 80 00       	push   $0x804e33
  803929:	e8 34 cc ff ff       	call   800562 <_panic>
  80392e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803931:	8b 00                	mov    (%eax),%eax
  803933:	85 c0                	test   %eax,%eax
  803935:	74 10                	je     803947 <alloc_block+0xd2>
  803937:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80393a:	8b 00                	mov    (%eax),%eax
  80393c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80393f:	8b 52 04             	mov    0x4(%edx),%edx
  803942:	89 50 04             	mov    %edx,0x4(%eax)
  803945:	eb 14                	jmp    80395b <alloc_block+0xe6>
  803947:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80394a:	8b 40 04             	mov    0x4(%eax),%eax
  80394d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803950:	c1 e2 04             	shl    $0x4,%edx
  803953:	81 c2 84 d0 81 00    	add    $0x81d084,%edx
  803959:	89 02                	mov    %eax,(%edx)
  80395b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80395e:	8b 40 04             	mov    0x4(%eax),%eax
  803961:	85 c0                	test   %eax,%eax
  803963:	74 0f                	je     803974 <alloc_block+0xff>
  803965:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803968:	8b 40 04             	mov    0x4(%eax),%eax
  80396b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80396e:	8b 12                	mov    (%edx),%edx
  803970:	89 10                	mov    %edx,(%eax)
  803972:	eb 13                	jmp    803987 <alloc_block+0x112>
  803974:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803977:	8b 00                	mov    (%eax),%eax
  803979:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80397c:	c1 e2 04             	shl    $0x4,%edx
  80397f:	81 c2 80 d0 81 00    	add    $0x81d080,%edx
  803985:	89 02                	mov    %eax,(%edx)
  803987:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80398a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803990:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803993:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80399a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80399d:	c1 e0 04             	shl    $0x4,%eax
  8039a0:	05 8c d0 81 00       	add    $0x81d08c,%eax
  8039a5:	8b 00                	mov    (%eax),%eax
  8039a7:	8d 50 ff             	lea    -0x1(%eax),%edx
  8039aa:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8039ad:	c1 e0 04             	shl    $0x4,%eax
  8039b0:	05 8c d0 81 00       	add    $0x81d08c,%eax
  8039b5:	89 10                	mov    %edx,(%eax)
		uint32 page_index = ((uint32)block - dynAllocStart)/ PAGE_SIZE;
  8039b7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8039ba:	a1 64 d0 81 00       	mov    0x81d064,%eax
  8039bf:	29 c2                	sub    %eax,%edx
  8039c1:	89 d0                	mov    %edx,%eax
  8039c3:	c1 e8 0c             	shr    $0xc,%eax
  8039c6:	89 45 e0             	mov    %eax,-0x20(%ebp)
		pageBlockInfoArr[page_index].num_of_free_blocks--;
  8039c9:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8039cc:	89 d0                	mov    %edx,%eax
  8039ce:	01 c0                	add    %eax,%eax
  8039d0:	01 d0                	add    %edx,%eax
  8039d2:	c1 e0 02             	shl    $0x2,%eax
  8039d5:	05 6a 50 80 00       	add    $0x80506a,%eax
  8039da:	66 8b 00             	mov    (%eax),%ax
  8039dd:	8d 50 ff             	lea    -0x1(%eax),%edx
  8039e0:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8039e3:	89 c8                	mov    %ecx,%eax
  8039e5:	01 c0                	add    %eax,%eax
  8039e7:	01 c8                	add    %ecx,%eax
  8039e9:	c1 e0 02             	shl    $0x2,%eax
  8039ec:	05 6a 50 80 00       	add    $0x80506a,%eax
  8039f1:	66 89 10             	mov    %dx,(%eax)
		return (void*)block;
  8039f4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8039f7:	e9 13 03 00 00       	jmp    803d0f <alloc_block+0x49a>
	}

	if(!LIST_EMPTY(&freePagesList)){
  8039fc:	a1 48 50 80 00       	mov    0x805048,%eax
  803a01:	85 c0                	test   %eax,%eax
  803a03:	0f 84 c9 01 00 00    	je     803bd2 <alloc_block+0x35d>

		struct PageInfoElement *page_info = LIST_FIRST(&freePagesList);
  803a09:	a1 48 50 80 00       	mov    0x805048,%eax
  803a0e:	89 45 dc             	mov    %eax,-0x24(%ebp)
		LIST_REMOVE(&freePagesList, page_info);
  803a11:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803a15:	75 17                	jne    803a2e <alloc_block+0x1b9>
  803a17:	83 ec 04             	sub    $0x4,%esp
  803a1a:	68 6d 4e 80 00       	push   $0x804e6d
  803a1f:	68 8f 00 00 00       	push   $0x8f
  803a24:	68 33 4e 80 00       	push   $0x804e33
  803a29:	e8 34 cb ff ff       	call   800562 <_panic>
  803a2e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803a31:	8b 00                	mov    (%eax),%eax
  803a33:	85 c0                	test   %eax,%eax
  803a35:	74 10                	je     803a47 <alloc_block+0x1d2>
  803a37:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803a3a:	8b 00                	mov    (%eax),%eax
  803a3c:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803a3f:	8b 52 04             	mov    0x4(%edx),%edx
  803a42:	89 50 04             	mov    %edx,0x4(%eax)
  803a45:	eb 0b                	jmp    803a52 <alloc_block+0x1dd>
  803a47:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803a4a:	8b 40 04             	mov    0x4(%eax),%eax
  803a4d:	a3 4c 50 80 00       	mov    %eax,0x80504c
  803a52:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803a55:	8b 40 04             	mov    0x4(%eax),%eax
  803a58:	85 c0                	test   %eax,%eax
  803a5a:	74 0f                	je     803a6b <alloc_block+0x1f6>
  803a5c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803a5f:	8b 40 04             	mov    0x4(%eax),%eax
  803a62:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803a65:	8b 12                	mov    (%edx),%edx
  803a67:	89 10                	mov    %edx,(%eax)
  803a69:	eb 0a                	jmp    803a75 <alloc_block+0x200>
  803a6b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803a6e:	8b 00                	mov    (%eax),%eax
  803a70:	a3 48 50 80 00       	mov    %eax,0x805048
  803a75:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803a78:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803a7e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803a81:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803a88:	a1 54 50 80 00       	mov    0x805054,%eax
  803a8d:	48                   	dec    %eax
  803a8e:	a3 54 50 80 00       	mov    %eax,0x805054
		uint32 page_va = to_page_va(page_info);
  803a93:	83 ec 0c             	sub    $0xc,%esp
  803a96:	ff 75 dc             	pushl  -0x24(%ebp)
  803a99:	e8 89 fb ff ff       	call   803627 <to_page_va>
  803a9e:	83 c4 10             	add    $0x10,%esp
  803aa1:	89 45 d8             	mov    %eax,-0x28(%ebp)

		uint32 page_index = (page_va - dynAllocStart)/ PAGE_SIZE;
  803aa4:	a1 64 d0 81 00       	mov    0x81d064,%eax
  803aa9:	8b 55 d8             	mov    -0x28(%ebp),%edx
  803aac:	29 c2                	sub    %eax,%edx
  803aae:	89 d0                	mov    %edx,%eax
  803ab0:	c1 e8 0c             	shr    $0xc,%eax
  803ab3:	89 45 d4             	mov    %eax,-0x2c(%ebp)

		get_page((void*)page_va);
  803ab6:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803ab9:	83 ec 0c             	sub    $0xc,%esp
  803abc:	50                   	push   %eax
  803abd:	e8 fe dc ff ff       	call   8017c0 <get_page>
  803ac2:	83 c4 10             	add    $0x10,%esp


		pageBlockInfoArr[page_index].block_size = size;
  803ac5:	8b 45 08             	mov    0x8(%ebp),%eax
  803ac8:	89 c2                	mov    %eax,%edx
  803aca:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  803acd:	89 c8                	mov    %ecx,%eax
  803acf:	01 c0                	add    %eax,%eax
  803ad1:	01 c8                	add    %ecx,%eax
  803ad3:	c1 e0 02             	shl    $0x2,%eax
  803ad6:	05 68 50 80 00       	add    $0x805068,%eax
  803adb:	66 89 10             	mov    %dx,(%eax)
		int num_blocks = PAGE_SIZE / size ;
  803ade:	b8 00 10 00 00       	mov    $0x1000,%eax
  803ae3:	ba 00 00 00 00       	mov    $0x0,%edx
  803ae8:	f7 75 08             	divl   0x8(%ebp)
  803aeb:	89 45 d0             	mov    %eax,-0x30(%ebp)
		pageBlockInfoArr[page_index].num_of_free_blocks= num_blocks - 1 ;
  803aee:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803af1:	8d 50 ff             	lea    -0x1(%eax),%edx
  803af4:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  803af7:	89 c8                	mov    %ecx,%eax
  803af9:	01 c0                	add    %eax,%eax
  803afb:	01 c8                	add    %ecx,%eax
  803afd:	c1 e0 02             	shl    $0x2,%eax
  803b00:	05 6a 50 80 00       	add    $0x80506a,%eax
  803b05:	66 89 10             	mov    %dx,(%eax)

		for(int i=1; i< num_blocks; i++){
  803b08:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
  803b0f:	e9 aa 00 00 00       	jmp    803bbe <alloc_block+0x349>
			struct BlockElement *new_block = (struct BlockElement*)(page_va + i *size);
  803b14:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803b17:	0f af 45 08          	imul   0x8(%ebp),%eax
  803b1b:	89 c2                	mov    %eax,%edx
  803b1d:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803b20:	01 d0                	add    %edx,%eax
  803b22:	89 45 cc             	mov    %eax,-0x34(%ebp)
			LIST_INSERT_TAIL(&freeBlockLists[list_index], new_block);
  803b25:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  803b29:	75 17                	jne    803b42 <alloc_block+0x2cd>
  803b2b:	83 ec 04             	sub    $0x4,%esp
  803b2e:	68 8c 4e 80 00       	push   $0x804e8c
  803b33:	68 9d 00 00 00       	push   $0x9d
  803b38:	68 33 4e 80 00       	push   $0x804e33
  803b3d:	e8 20 ca ff ff       	call   800562 <_panic>
  803b42:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803b45:	c1 e0 04             	shl    $0x4,%eax
  803b48:	05 84 d0 81 00       	add    $0x81d084,%eax
  803b4d:	8b 10                	mov    (%eax),%edx
  803b4f:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803b52:	89 50 04             	mov    %edx,0x4(%eax)
  803b55:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803b58:	8b 40 04             	mov    0x4(%eax),%eax
  803b5b:	85 c0                	test   %eax,%eax
  803b5d:	74 14                	je     803b73 <alloc_block+0x2fe>
  803b5f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803b62:	c1 e0 04             	shl    $0x4,%eax
  803b65:	05 84 d0 81 00       	add    $0x81d084,%eax
  803b6a:	8b 00                	mov    (%eax),%eax
  803b6c:	8b 55 cc             	mov    -0x34(%ebp),%edx
  803b6f:	89 10                	mov    %edx,(%eax)
  803b71:	eb 11                	jmp    803b84 <alloc_block+0x30f>
  803b73:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803b76:	c1 e0 04             	shl    $0x4,%eax
  803b79:	8d 90 80 d0 81 00    	lea    0x81d080(%eax),%edx
  803b7f:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803b82:	89 02                	mov    %eax,(%edx)
  803b84:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803b87:	c1 e0 04             	shl    $0x4,%eax
  803b8a:	8d 90 84 d0 81 00    	lea    0x81d084(%eax),%edx
  803b90:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803b93:	89 02                	mov    %eax,(%edx)
  803b95:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803b98:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803b9e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803ba1:	c1 e0 04             	shl    $0x4,%eax
  803ba4:	05 8c d0 81 00       	add    $0x81d08c,%eax
  803ba9:	8b 00                	mov    (%eax),%eax
  803bab:	8d 50 01             	lea    0x1(%eax),%edx
  803bae:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803bb1:	c1 e0 04             	shl    $0x4,%eax
  803bb4:	05 8c d0 81 00       	add    $0x81d08c,%eax
  803bb9:	89 10                	mov    %edx,(%eax)

		pageBlockInfoArr[page_index].block_size = size;
		int num_blocks = PAGE_SIZE / size ;
		pageBlockInfoArr[page_index].num_of_free_blocks= num_blocks - 1 ;

		for(int i=1; i< num_blocks; i++){
  803bbb:	ff 45 f0             	incl   -0x10(%ebp)
  803bbe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803bc1:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  803bc4:	0f 8c 4a ff ff ff    	jl     803b14 <alloc_block+0x29f>
			struct BlockElement *new_block = (struct BlockElement*)(page_va + i *size);
			LIST_INSERT_TAIL(&freeBlockLists[list_index], new_block);
		}
		return(void*)page_va;
  803bca:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803bcd:	e9 3d 01 00 00       	jmp    803d0f <alloc_block+0x49a>
	}


	for(int i =list_index+1; i<= LOG2_MAX_SIZE - LOG2_MIN_SIZE; i++){
  803bd2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803bd5:	40                   	inc    %eax
  803bd6:	89 45 ec             	mov    %eax,-0x14(%ebp)
  803bd9:	e9 10 01 00 00       	jmp    803cee <alloc_block+0x479>

		if(!LIST_EMPTY(&freeBlockLists[i])){
  803bde:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803be1:	c1 e0 04             	shl    $0x4,%eax
  803be4:	05 80 d0 81 00       	add    $0x81d080,%eax
  803be9:	8b 00                	mov    (%eax),%eax
  803beb:	85 c0                	test   %eax,%eax
  803bed:	0f 84 f8 00 00 00    	je     803ceb <alloc_block+0x476>

			struct BlockElement *block = LIST_FIRST(&freeBlockLists[i]);
  803bf3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803bf6:	c1 e0 04             	shl    $0x4,%eax
  803bf9:	05 80 d0 81 00       	add    $0x81d080,%eax
  803bfe:	8b 00                	mov    (%eax),%eax
  803c00:	89 45 c8             	mov    %eax,-0x38(%ebp)
			LIST_REMOVE( &freeBlockLists[i], block);
  803c03:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  803c07:	75 17                	jne    803c20 <alloc_block+0x3ab>
  803c09:	83 ec 04             	sub    $0x4,%esp
  803c0c:	68 6d 4e 80 00       	push   $0x804e6d
  803c11:	68 a8 00 00 00       	push   $0xa8
  803c16:	68 33 4e 80 00       	push   $0x804e33
  803c1b:	e8 42 c9 ff ff       	call   800562 <_panic>
  803c20:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803c23:	8b 00                	mov    (%eax),%eax
  803c25:	85 c0                	test   %eax,%eax
  803c27:	74 10                	je     803c39 <alloc_block+0x3c4>
  803c29:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803c2c:	8b 00                	mov    (%eax),%eax
  803c2e:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803c31:	8b 52 04             	mov    0x4(%edx),%edx
  803c34:	89 50 04             	mov    %edx,0x4(%eax)
  803c37:	eb 14                	jmp    803c4d <alloc_block+0x3d8>
  803c39:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803c3c:	8b 40 04             	mov    0x4(%eax),%eax
  803c3f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803c42:	c1 e2 04             	shl    $0x4,%edx
  803c45:	81 c2 84 d0 81 00    	add    $0x81d084,%edx
  803c4b:	89 02                	mov    %eax,(%edx)
  803c4d:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803c50:	8b 40 04             	mov    0x4(%eax),%eax
  803c53:	85 c0                	test   %eax,%eax
  803c55:	74 0f                	je     803c66 <alloc_block+0x3f1>
  803c57:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803c5a:	8b 40 04             	mov    0x4(%eax),%eax
  803c5d:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803c60:	8b 12                	mov    (%edx),%edx
  803c62:	89 10                	mov    %edx,(%eax)
  803c64:	eb 13                	jmp    803c79 <alloc_block+0x404>
  803c66:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803c69:	8b 00                	mov    (%eax),%eax
  803c6b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803c6e:	c1 e2 04             	shl    $0x4,%edx
  803c71:	81 c2 80 d0 81 00    	add    $0x81d080,%edx
  803c77:	89 02                	mov    %eax,(%edx)
  803c79:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803c7c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803c82:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803c85:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803c8c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803c8f:	c1 e0 04             	shl    $0x4,%eax
  803c92:	05 8c d0 81 00       	add    $0x81d08c,%eax
  803c97:	8b 00                	mov    (%eax),%eax
  803c99:	8d 50 ff             	lea    -0x1(%eax),%edx
  803c9c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803c9f:	c1 e0 04             	shl    $0x4,%eax
  803ca2:	05 8c d0 81 00       	add    $0x81d08c,%eax
  803ca7:	89 10                	mov    %edx,(%eax)

			uint32 page_index = ((uint32)block - dynAllocStart)/ PAGE_SIZE;
  803ca9:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803cac:	a1 64 d0 81 00       	mov    0x81d064,%eax
  803cb1:	29 c2                	sub    %eax,%edx
  803cb3:	89 d0                	mov    %edx,%eax
  803cb5:	c1 e8 0c             	shr    $0xc,%eax
  803cb8:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			pageBlockInfoArr[page_index].num_of_free_blocks-- ;
  803cbb:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  803cbe:	89 d0                	mov    %edx,%eax
  803cc0:	01 c0                	add    %eax,%eax
  803cc2:	01 d0                	add    %edx,%eax
  803cc4:	c1 e0 02             	shl    $0x2,%eax
  803cc7:	05 6a 50 80 00       	add    $0x80506a,%eax
  803ccc:	66 8b 00             	mov    (%eax),%ax
  803ccf:	8d 50 ff             	lea    -0x1(%eax),%edx
  803cd2:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  803cd5:	89 c8                	mov    %ecx,%eax
  803cd7:	01 c0                	add    %eax,%eax
  803cd9:	01 c8                	add    %ecx,%eax
  803cdb:	c1 e0 02             	shl    $0x2,%eax
  803cde:	05 6a 50 80 00       	add    $0x80506a,%eax
  803ce3:	66 89 10             	mov    %dx,(%eax)

			return (void*)block;
  803ce6:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803ce9:	eb 24                	jmp    803d0f <alloc_block+0x49a>
		}
		return(void*)page_va;
	}


	for(int i =list_index+1; i<= LOG2_MAX_SIZE - LOG2_MIN_SIZE; i++){
  803ceb:	ff 45 ec             	incl   -0x14(%ebp)
  803cee:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  803cf2:	0f 8e e6 fe ff ff    	jle    803bde <alloc_block+0x369>

			return (void*)block;
		}
	}

	panic("alloc_block: out of memory! ");
  803cf8:	83 ec 04             	sub    $0x4,%esp
  803cfb:	68 af 4e 80 00       	push   $0x804eaf
  803d00:	68 b1 00 00 00       	push   $0xb1
  803d05:	68 33 4e 80 00       	push   $0x804e33
  803d0a:	e8 53 c8 ff ff       	call   800562 <_panic>

	//Comment the following line
	//panic("alloc_block() Not implemented yet");

	//TODO: [PROJECT'25.BONUS#1] DYNAMIC ALLOCATOR - block if no free block
}
  803d0f:	c9                   	leave  
  803d10:	c3                   	ret    

00803d11 <free_block>:

//===========================
// [4] FREE BLOCK:
//===========================
void free_block(void *va)
{
  803d11:	55                   	push   %ebp
  803d12:	89 e5                	mov    %esp,%ebp
  803d14:	83 ec 38             	sub    $0x38,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert((uint32)va >= dynAllocStart && (uint32)va < dynAllocEnd);
  803d17:	8b 55 08             	mov    0x8(%ebp),%edx
  803d1a:	a1 64 d0 81 00       	mov    0x81d064,%eax
  803d1f:	39 c2                	cmp    %eax,%edx
  803d21:	72 0c                	jb     803d2f <free_block+0x1e>
  803d23:	8b 55 08             	mov    0x8(%ebp),%edx
  803d26:	a1 40 50 80 00       	mov    0x805040,%eax
  803d2b:	39 c2                	cmp    %eax,%edx
  803d2d:	72 19                	jb     803d48 <free_block+0x37>
  803d2f:	68 cc 4e 80 00       	push   $0x804ecc
  803d34:	68 1e 4e 80 00       	push   $0x804e1e
  803d39:	68 c3 00 00 00       	push   $0xc3
  803d3e:	68 33 4e 80 00       	push   $0x804e33
  803d43:	e8 1a c8 ff ff       	call   800562 <_panic>
	//==================================================================================

	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #4 free_block
	//Your code is here

	uint32 page_index=((uint32)va - dynAllocStart)/ PAGE_SIZE;
  803d48:	8b 55 08             	mov    0x8(%ebp),%edx
  803d4b:	a1 64 d0 81 00       	mov    0x81d064,%eax
  803d50:	29 c2                	sub    %eax,%edx
  803d52:	89 d0                	mov    %edx,%eax
  803d54:	c1 e8 0c             	shr    $0xc,%eax
  803d57:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 block_size = pageBlockInfoArr[page_index].block_size;
  803d5a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803d5d:	89 d0                	mov    %edx,%eax
  803d5f:	01 c0                	add    %eax,%eax
  803d61:	01 d0                	add    %edx,%eax
  803d63:	c1 e0 02             	shl    $0x2,%eax
  803d66:	05 68 50 80 00       	add    $0x805068,%eax
  803d6b:	8b 00                	mov    (%eax),%eax
  803d6d:	0f b7 c0             	movzwl %ax,%eax
  803d70:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if(block_size == 0){
  803d73:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803d77:	75 17                	jne    803d90 <free_block+0x7f>
		panic("page is empty(already not allocated)");
  803d79:	83 ec 04             	sub    $0x4,%esp
  803d7c:	68 04 4f 80 00       	push   $0x804f04
  803d81:	68 cf 00 00 00       	push   $0xcf
  803d86:	68 33 4e 80 00       	push   $0x804e33
  803d8b:	e8 d2 c7 ff ff       	call   800562 <_panic>
	}

	int list_index = log2(block_size) - LOG2_MIN_SIZE;
  803d90:	83 ec 0c             	sub    $0xc,%esp
  803d93:	ff 75 ec             	pushl  -0x14(%ebp)
  803d96:	e8 d8 f8 ff ff       	call   803673 <log2>
  803d9b:	83 c4 10             	add    $0x10,%esp
  803d9e:	83 e8 03             	sub    $0x3,%eax
  803da1:	89 45 e8             	mov    %eax,-0x18(%ebp)
	// mn va l block "elta7weel mn virtual l phy hna"
	struct BlockElement *block = (struct BlockElement *)va;
  803da4:	8b 45 08             	mov    0x8(%ebp),%eax
  803da7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	LIST_INSERT_TAIL(&freeBlockLists[list_index], block);
  803daa:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803dae:	75 17                	jne    803dc7 <free_block+0xb6>
  803db0:	83 ec 04             	sub    $0x4,%esp
  803db3:	68 8c 4e 80 00       	push   $0x804e8c
  803db8:	68 d5 00 00 00       	push   $0xd5
  803dbd:	68 33 4e 80 00       	push   $0x804e33
  803dc2:	e8 9b c7 ff ff       	call   800562 <_panic>
  803dc7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803dca:	c1 e0 04             	shl    $0x4,%eax
  803dcd:	05 84 d0 81 00       	add    $0x81d084,%eax
  803dd2:	8b 10                	mov    (%eax),%edx
  803dd4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803dd7:	89 50 04             	mov    %edx,0x4(%eax)
  803dda:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803ddd:	8b 40 04             	mov    0x4(%eax),%eax
  803de0:	85 c0                	test   %eax,%eax
  803de2:	74 14                	je     803df8 <free_block+0xe7>
  803de4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803de7:	c1 e0 04             	shl    $0x4,%eax
  803dea:	05 84 d0 81 00       	add    $0x81d084,%eax
  803def:	8b 00                	mov    (%eax),%eax
  803df1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803df4:	89 10                	mov    %edx,(%eax)
  803df6:	eb 11                	jmp    803e09 <free_block+0xf8>
  803df8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803dfb:	c1 e0 04             	shl    $0x4,%eax
  803dfe:	8d 90 80 d0 81 00    	lea    0x81d080(%eax),%edx
  803e04:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803e07:	89 02                	mov    %eax,(%edx)
  803e09:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803e0c:	c1 e0 04             	shl    $0x4,%eax
  803e0f:	8d 90 84 d0 81 00    	lea    0x81d084(%eax),%edx
  803e15:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803e18:	89 02                	mov    %eax,(%edx)
  803e1a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803e1d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803e23:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803e26:	c1 e0 04             	shl    $0x4,%eax
  803e29:	05 8c d0 81 00       	add    $0x81d08c,%eax
  803e2e:	8b 00                	mov    (%eax),%eax
  803e30:	8d 50 01             	lea    0x1(%eax),%edx
  803e33:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803e36:	c1 e0 04             	shl    $0x4,%eax
  803e39:	05 8c d0 81 00       	add    $0x81d08c,%eax
  803e3e:	89 10                	mov    %edx,(%eax)
	// b3d ma wdytha fy el freeBlockLists hzwed elfree elly fy el array 1
	pageBlockInfoArr[page_index].num_of_free_blocks++;
  803e40:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803e43:	89 d0                	mov    %edx,%eax
  803e45:	01 c0                	add    %eax,%eax
  803e47:	01 d0                	add    %edx,%eax
  803e49:	c1 e0 02             	shl    $0x2,%eax
  803e4c:	05 6a 50 80 00       	add    $0x80506a,%eax
  803e51:	66 8b 00             	mov    (%eax),%ax
  803e54:	8d 50 01             	lea    0x1(%eax),%edx
  803e57:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  803e5a:	89 c8                	mov    %ecx,%eax
  803e5c:	01 c0                	add    %eax,%eax
  803e5e:	01 c8                	add    %ecx,%eax
  803e60:	c1 e0 02             	shl    $0x2,%eax
  803e63:	05 6a 50 80 00       	add    $0x80506a,%eax
  803e68:	66 89 10             	mov    %dx,(%eax)
	int blocks_number = PAGE_SIZE / block_size;
  803e6b:	b8 00 10 00 00       	mov    $0x1000,%eax
  803e70:	ba 00 00 00 00       	mov    $0x0,%edx
  803e75:	f7 75 ec             	divl   -0x14(%ebp)
  803e78:	89 45 e0             	mov    %eax,-0x20(%ebp)
	if(pageBlockInfoArr[page_index].num_of_free_blocks == blocks_number){
  803e7b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803e7e:	89 d0                	mov    %edx,%eax
  803e80:	01 c0                	add    %eax,%eax
  803e82:	01 d0                	add    %edx,%eax
  803e84:	c1 e0 02             	shl    $0x2,%eax
  803e87:	05 6a 50 80 00       	add    $0x80506a,%eax
  803e8c:	66 8b 00             	mov    (%eax),%ax
  803e8f:	0f b7 c0             	movzwl %ax,%eax
  803e92:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  803e95:	0f 85 d3 01 00 00    	jne    80406e <free_block+0x35d>
		struct BlockElement *itr = LIST_FIRST(&freeBlockLists[list_index]);
  803e9b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803e9e:	c1 e0 04             	shl    $0x4,%eax
  803ea1:	05 80 d0 81 00       	add    $0x81d080,%eax
  803ea6:	8b 00                	mov    (%eax),%eax
  803ea8:	89 45 f4             	mov    %eax,-0xc(%ebp)
		while(itr != NULL){
  803eab:	e9 f1 00 00 00       	jmp    803fa1 <free_block+0x290>
			//lw ms7to el pointer mydy34 ->
			struct BlockElement *next = LIST_NEXT(itr);
  803eb0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803eb3:	8b 00                	mov    (%eax),%eax
  803eb5:	89 45 dc             	mov    %eax,-0x24(%ebp)
			uint32 page_beginning_address= dynAllocStart + page_index * PAGE_SIZE;
  803eb8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803ebb:	c1 e0 0c             	shl    $0xc,%eax
  803ebe:	89 c2                	mov    %eax,%edx
  803ec0:	a1 64 d0 81 00       	mov    0x81d064,%eax
  803ec5:	01 d0                	add    %edx,%eax
  803ec7:	89 45 d8             	mov    %eax,-0x28(%ebp)
			uint32 page_end_address = dynAllocStart + (page_index +1 )* PAGE_SIZE;
  803eca:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803ecd:	40                   	inc    %eax
  803ece:	c1 e0 0c             	shl    $0xc,%eax
  803ed1:	89 c2                	mov    %eax,%edx
  803ed3:	a1 64 d0 81 00       	mov    0x81d064,%eax
  803ed8:	01 d0                	add    %edx,%eax
  803eda:	89 45 d4             	mov    %eax,-0x2c(%ebp)

			if((uint32)itr >= page_beginning_address && (uint32)itr < page_end_address){
  803edd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ee0:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  803ee3:	0f 82 b8 00 00 00    	jb     803fa1 <free_block+0x290>
  803ee9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803eec:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803eef:	0f 83 ac 00 00 00    	jae    803fa1 <free_block+0x290>
				LIST_REMOVE(&freeBlockLists[list_index], itr);
  803ef5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803ef9:	75 17                	jne    803f12 <free_block+0x201>
  803efb:	83 ec 04             	sub    $0x4,%esp
  803efe:	68 6d 4e 80 00       	push   $0x804e6d
  803f03:	68 e2 00 00 00       	push   $0xe2
  803f08:	68 33 4e 80 00       	push   $0x804e33
  803f0d:	e8 50 c6 ff ff       	call   800562 <_panic>
  803f12:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803f15:	8b 00                	mov    (%eax),%eax
  803f17:	85 c0                	test   %eax,%eax
  803f19:	74 10                	je     803f2b <free_block+0x21a>
  803f1b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803f1e:	8b 00                	mov    (%eax),%eax
  803f20:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803f23:	8b 52 04             	mov    0x4(%edx),%edx
  803f26:	89 50 04             	mov    %edx,0x4(%eax)
  803f29:	eb 14                	jmp    803f3f <free_block+0x22e>
  803f2b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803f2e:	8b 40 04             	mov    0x4(%eax),%eax
  803f31:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803f34:	c1 e2 04             	shl    $0x4,%edx
  803f37:	81 c2 84 d0 81 00    	add    $0x81d084,%edx
  803f3d:	89 02                	mov    %eax,(%edx)
  803f3f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803f42:	8b 40 04             	mov    0x4(%eax),%eax
  803f45:	85 c0                	test   %eax,%eax
  803f47:	74 0f                	je     803f58 <free_block+0x247>
  803f49:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803f4c:	8b 40 04             	mov    0x4(%eax),%eax
  803f4f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803f52:	8b 12                	mov    (%edx),%edx
  803f54:	89 10                	mov    %edx,(%eax)
  803f56:	eb 13                	jmp    803f6b <free_block+0x25a>
  803f58:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803f5b:	8b 00                	mov    (%eax),%eax
  803f5d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803f60:	c1 e2 04             	shl    $0x4,%edx
  803f63:	81 c2 80 d0 81 00    	add    $0x81d080,%edx
  803f69:	89 02                	mov    %eax,(%edx)
  803f6b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803f6e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803f74:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803f77:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803f7e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803f81:	c1 e0 04             	shl    $0x4,%eax
  803f84:	05 8c d0 81 00       	add    $0x81d08c,%eax
  803f89:	8b 00                	mov    (%eax),%eax
  803f8b:	8d 50 ff             	lea    -0x1(%eax),%edx
  803f8e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803f91:	c1 e0 04             	shl    $0x4,%eax
  803f94:	05 8c d0 81 00       	add    $0x81d08c,%eax
  803f99:	89 10                	mov    %edx,(%eax)
				//y5o4 3la elly b3do
				itr = next;
  803f9b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803f9e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// b3d ma wdytha fy el freeBlockLists hzwed elfree elly fy el array 1
	pageBlockInfoArr[page_index].num_of_free_blocks++;
	int blocks_number = PAGE_SIZE / block_size;
	if(pageBlockInfoArr[page_index].num_of_free_blocks == blocks_number){
		struct BlockElement *itr = LIST_FIRST(&freeBlockLists[list_index]);
		while(itr != NULL){
  803fa1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803fa5:	0f 85 05 ff ff ff    	jne    803eb0 <free_block+0x19f>
				LIST_REMOVE(&freeBlockLists[list_index], itr);
				//y5o4 3la elly b3do
				itr = next;
			}
		}
		pageBlockInfoArr[page_index].block_size=0;
  803fab:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803fae:	89 d0                	mov    %edx,%eax
  803fb0:	01 c0                	add    %eax,%eax
  803fb2:	01 d0                	add    %edx,%eax
  803fb4:	c1 e0 02             	shl    $0x2,%eax
  803fb7:	05 68 50 80 00       	add    $0x805068,%eax
  803fbc:	66 c7 00 00 00       	movw   $0x0,(%eax)
		pageBlockInfoArr[page_index].num_of_free_blocks=0;
  803fc1:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803fc4:	89 d0                	mov    %edx,%eax
  803fc6:	01 c0                	add    %eax,%eax
  803fc8:	01 d0                	add    %edx,%eax
  803fca:	c1 e0 02             	shl    $0x2,%eax
  803fcd:	05 6a 50 80 00       	add    $0x80506a,%eax
  803fd2:	66 c7 00 00 00       	movw   $0x0,(%eax)

		struct PageInfoElement *page_info = &pageBlockInfoArr[page_index];
  803fd7:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803fda:	89 d0                	mov    %edx,%eax
  803fdc:	01 c0                	add    %eax,%eax
  803fde:	01 d0                	add    %edx,%eax
  803fe0:	c1 e0 02             	shl    $0x2,%eax
  803fe3:	05 60 50 80 00       	add    $0x805060,%eax
  803fe8:	89 45 d0             	mov    %eax,-0x30(%ebp)
		LIST_INSERT_TAIL(&freePagesList, page_info);
  803feb:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  803fef:	75 17                	jne    804008 <free_block+0x2f7>
  803ff1:	83 ec 04             	sub    $0x4,%esp
  803ff4:	68 8c 4e 80 00       	push   $0x804e8c
  803ff9:	68 eb 00 00 00       	push   $0xeb
  803ffe:	68 33 4e 80 00       	push   $0x804e33
  804003:	e8 5a c5 ff ff       	call   800562 <_panic>
  804008:	8b 15 4c 50 80 00    	mov    0x80504c,%edx
  80400e:	8b 45 d0             	mov    -0x30(%ebp),%eax
  804011:	89 50 04             	mov    %edx,0x4(%eax)
  804014:	8b 45 d0             	mov    -0x30(%ebp),%eax
  804017:	8b 40 04             	mov    0x4(%eax),%eax
  80401a:	85 c0                	test   %eax,%eax
  80401c:	74 0c                	je     80402a <free_block+0x319>
  80401e:	a1 4c 50 80 00       	mov    0x80504c,%eax
  804023:	8b 55 d0             	mov    -0x30(%ebp),%edx
  804026:	89 10                	mov    %edx,(%eax)
  804028:	eb 08                	jmp    804032 <free_block+0x321>
  80402a:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80402d:	a3 48 50 80 00       	mov    %eax,0x805048
  804032:	8b 45 d0             	mov    -0x30(%ebp),%eax
  804035:	a3 4c 50 80 00       	mov    %eax,0x80504c
  80403a:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80403d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  804043:	a1 54 50 80 00       	mov    0x805054,%eax
  804048:	40                   	inc    %eax
  804049:	a3 54 50 80 00       	mov    %eax,0x805054
		uint32 page_va = to_page_va(page_info);
  80404e:	83 ec 0c             	sub    $0xc,%esp
  804051:	ff 75 d0             	pushl  -0x30(%ebp)
  804054:	e8 ce f5 ff ff       	call   803627 <to_page_va>
  804059:	83 c4 10             	add    $0x10,%esp
  80405c:	89 45 cc             	mov    %eax,-0x34(%ebp)
		return_page((void *)page_va);
  80405f:	8b 45 cc             	mov    -0x34(%ebp),%eax
  804062:	83 ec 0c             	sub    $0xc,%esp
  804065:	50                   	push   %eax
  804066:	e8 9e d7 ff ff       	call   801809 <return_page>
  80406b:	83 c4 10             	add    $0x10,%esp
	}


	//Comment the following line
	//panic("free_block() Not implemented yet");
}
  80406e:	90                   	nop
  80406f:	c9                   	leave  
  804070:	c3                   	ret    

00804071 <realloc_block>:

//===========================
// [1] REALLOCATE BLOCK:
//===========================
void *realloc_block(void* va, uint32 new_size)
{
  804071:	55                   	push   %ebp
  804072:	89 e5                	mov    %esp,%ebp
  804074:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.BONUS#2] KERNEL REALLOC - realloc_block
	//Your code is here
	//Comment the following line
	panic("realloc_block() Not implemented yet");
  804077:	83 ec 04             	sub    $0x4,%esp
  80407a:	68 2c 4f 80 00       	push   $0x804f2c
  80407f:	68 01 01 00 00       	push   $0x101
  804084:	68 33 4e 80 00       	push   $0x804e33
  804089:	e8 d4 c4 ff ff       	call   800562 <_panic>

0080408e <init_uspinlock>:
#include "inc/uspinlock.h"

extern volatile struct Env *myEnv;

void init_uspinlock(struct uspinlock *lk, char *name, bool isOpened)
{
  80408e:	55                   	push   %ebp
  80408f:	89 e5                	mov    %esp,%ebp
  804091:	83 ec 08             	sub    $0x8,%esp
	assert(isOpened == 0 || isOpened == 1);
  804094:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  804098:	74 1c                	je     8040b6 <init_uspinlock+0x28>
  80409a:	83 7d 10 01          	cmpl   $0x1,0x10(%ebp)
  80409e:	74 16                	je     8040b6 <init_uspinlock+0x28>
  8040a0:	68 50 4f 80 00       	push   $0x804f50
  8040a5:	68 6f 4f 80 00       	push   $0x804f6f
  8040aa:	6a 10                	push   $0x10
  8040ac:	68 84 4f 80 00       	push   $0x804f84
  8040b1:	e8 ac c4 ff ff       	call   800562 <_panic>
	strcpy(lk->name, name);
  8040b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8040b9:	83 c0 04             	add    $0x4,%eax
  8040bc:	83 ec 08             	sub    $0x8,%esp
  8040bf:	ff 75 0c             	pushl  0xc(%ebp)
  8040c2:	50                   	push   %eax
  8040c3:	e8 90 ce ff ff       	call   800f58 <strcpy>
  8040c8:	83 c4 10             	add    $0x10,%esp
	lk->locked = (1 - isOpened);
  8040cb:	b8 01 00 00 00       	mov    $0x1,%eax
  8040d0:	2b 45 10             	sub    0x10(%ebp),%eax
  8040d3:	89 c2                	mov    %eax,%edx
  8040d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8040d8:	89 10                	mov    %edx,(%eax)
}
  8040da:	90                   	nop
  8040db:	c9                   	leave  
  8040dc:	c3                   	ret    

008040dd <acquire_uspinlock>:
// Acquire the lock.
// Loops (spins) until the lock is acquired.
// Holding a lock for a long time may cause
// other CPUs to waste time spinning to acquire it.
void acquire_uspinlock(struct uspinlock *lk)
{
  8040dd:	55                   	push   %ebp
  8040de:	89 e5                	mov    %esp,%ebp
  8040e0:	83 ec 18             	sub    $0x18,%esp
	// The xchg is atomic.
	while(xchg(&lk->locked, 1) != 0) ;
  8040e3:	90                   	nop
  8040e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8040e7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8040ea:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
xchg(volatile uint32 *addr, uint32 newval)
{
  uint32 result;

  // The + in "+m" denotes a read-modify-write operand.
  __asm __volatile("lock; xchgl %0, %1" :
  8040f1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8040f4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8040f7:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  8040fa:	f0 87 02             	lock xchg %eax,(%edx)
  8040fd:	89 45 ec             	mov    %eax,-0x14(%ebp)
               "+m" (*addr), "=a" (result) :
               "1" (newval) :
               "cc");
  return result;
  804100:	8b 45 ec             	mov    -0x14(%ebp),%eax
  804103:	85 c0                	test   %eax,%eax
  804105:	75 dd                	jne    8040e4 <acquire_uspinlock+0x7>

	cprintf("[%d: %s] ACQUIRED spinlock [%s]\n", myEnv->env_id, myEnv->prog_name, lk->name);
  804107:	8b 45 08             	mov    0x8(%ebp),%eax
  80410a:	8d 48 04             	lea    0x4(%eax),%ecx
  80410d:	a1 20 50 80 00       	mov    0x805020,%eax
  804112:	8d 50 20             	lea    0x20(%eax),%edx
  804115:	a1 20 50 80 00       	mov    0x805020,%eax
  80411a:	8b 40 10             	mov    0x10(%eax),%eax
  80411d:	51                   	push   %ecx
  80411e:	52                   	push   %edx
  80411f:	50                   	push   %eax
  804120:	68 94 4f 80 00       	push   $0x804f94
  804125:	e8 06 c7 ff ff       	call   800830 <cprintf>
  80412a:	83 c4 10             	add    $0x10,%esp

	// Tell the C compiler and the processor to not move loads or stores
	// past this point, to ensure that the critical section's memory
	// references happen after the lock is acquired.
	__sync_synchronize();
  80412d:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
}
  804132:	90                   	nop
  804133:	c9                   	leave  
  804134:	c3                   	ret    

00804135 <release_uspinlock>:

// Release the lock.
void release_uspinlock(struct uspinlock *lk)
{
  804135:	55                   	push   %ebp
  804136:	89 e5                	mov    %esp,%ebp
  804138:	83 ec 08             	sub    $0x8,%esp
	if(!(lk->locked))
  80413b:	8b 45 08             	mov    0x8(%ebp),%eax
  80413e:	8b 00                	mov    (%eax),%eax
  804140:	85 c0                	test   %eax,%eax
  804142:	75 18                	jne    80415c <release_uspinlock+0x27>
	{
		panic("release: lock \"%s\" is not held!", lk->name);
  804144:	8b 45 08             	mov    0x8(%ebp),%eax
  804147:	83 c0 04             	add    $0x4,%eax
  80414a:	50                   	push   %eax
  80414b:	68 b8 4f 80 00       	push   $0x804fb8
  804150:	6a 2b                	push   $0x2b
  804152:	68 84 4f 80 00       	push   $0x804f84
  804157:	e8 06 c4 ff ff       	call   800562 <_panic>
	// Tell the C compiler and the processor to not move loads or stores
	// past this point, to ensure that all the stores in the critical
	// section are visible to other cores before the lock is released.
	// Both the C compiler and the hardware may re-order loads and
	// stores; __sync_synchronize() tells them both not to.
	__sync_synchronize();
  80415c:	f0 83 0c 24 00       	lock orl $0x0,(%esp)

	// Release the lock, equivalent to lk->locked = 0.
	// This code can't use a C assignment, since it might
	// not be atomic. A real OS would use C atomics here.
	asm volatile("movl $0, %0" : "+m" (lk->locked) : );
  804161:	8b 45 08             	mov    0x8(%ebp),%eax
  804164:	8b 55 08             	mov    0x8(%ebp),%edx
  804167:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	cprintf("[%d: %s] RELEASED spinlock [%s]\n", myEnv->env_id, myEnv->prog_name, lk->name);
  80416d:	8b 45 08             	mov    0x8(%ebp),%eax
  804170:	8d 48 04             	lea    0x4(%eax),%ecx
  804173:	a1 20 50 80 00       	mov    0x805020,%eax
  804178:	8d 50 20             	lea    0x20(%eax),%edx
  80417b:	a1 20 50 80 00       	mov    0x805020,%eax
  804180:	8b 40 10             	mov    0x10(%eax),%eax
  804183:	51                   	push   %ecx
  804184:	52                   	push   %edx
  804185:	50                   	push   %eax
  804186:	68 d8 4f 80 00       	push   $0x804fd8
  80418b:	e8 a0 c6 ff ff       	call   800830 <cprintf>
  804190:	83 c4 10             	add    $0x10,%esp
}
  804193:	90                   	nop
  804194:	c9                   	leave  
  804195:	c3                   	ret    
  804196:	66 90                	xchg   %ax,%ax

00804198 <__udivdi3>:
  804198:	55                   	push   %ebp
  804199:	57                   	push   %edi
  80419a:	56                   	push   %esi
  80419b:	53                   	push   %ebx
  80419c:	83 ec 1c             	sub    $0x1c,%esp
  80419f:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8041a3:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8041a7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8041ab:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8041af:	89 ca                	mov    %ecx,%edx
  8041b1:	89 f8                	mov    %edi,%eax
  8041b3:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8041b7:	85 f6                	test   %esi,%esi
  8041b9:	75 2d                	jne    8041e8 <__udivdi3+0x50>
  8041bb:	39 cf                	cmp    %ecx,%edi
  8041bd:	77 65                	ja     804224 <__udivdi3+0x8c>
  8041bf:	89 fd                	mov    %edi,%ebp
  8041c1:	85 ff                	test   %edi,%edi
  8041c3:	75 0b                	jne    8041d0 <__udivdi3+0x38>
  8041c5:	b8 01 00 00 00       	mov    $0x1,%eax
  8041ca:	31 d2                	xor    %edx,%edx
  8041cc:	f7 f7                	div    %edi
  8041ce:	89 c5                	mov    %eax,%ebp
  8041d0:	31 d2                	xor    %edx,%edx
  8041d2:	89 c8                	mov    %ecx,%eax
  8041d4:	f7 f5                	div    %ebp
  8041d6:	89 c1                	mov    %eax,%ecx
  8041d8:	89 d8                	mov    %ebx,%eax
  8041da:	f7 f5                	div    %ebp
  8041dc:	89 cf                	mov    %ecx,%edi
  8041de:	89 fa                	mov    %edi,%edx
  8041e0:	83 c4 1c             	add    $0x1c,%esp
  8041e3:	5b                   	pop    %ebx
  8041e4:	5e                   	pop    %esi
  8041e5:	5f                   	pop    %edi
  8041e6:	5d                   	pop    %ebp
  8041e7:	c3                   	ret    
  8041e8:	39 ce                	cmp    %ecx,%esi
  8041ea:	77 28                	ja     804214 <__udivdi3+0x7c>
  8041ec:	0f bd fe             	bsr    %esi,%edi
  8041ef:	83 f7 1f             	xor    $0x1f,%edi
  8041f2:	75 40                	jne    804234 <__udivdi3+0x9c>
  8041f4:	39 ce                	cmp    %ecx,%esi
  8041f6:	72 0a                	jb     804202 <__udivdi3+0x6a>
  8041f8:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8041fc:	0f 87 9e 00 00 00    	ja     8042a0 <__udivdi3+0x108>
  804202:	b8 01 00 00 00       	mov    $0x1,%eax
  804207:	89 fa                	mov    %edi,%edx
  804209:	83 c4 1c             	add    $0x1c,%esp
  80420c:	5b                   	pop    %ebx
  80420d:	5e                   	pop    %esi
  80420e:	5f                   	pop    %edi
  80420f:	5d                   	pop    %ebp
  804210:	c3                   	ret    
  804211:	8d 76 00             	lea    0x0(%esi),%esi
  804214:	31 ff                	xor    %edi,%edi
  804216:	31 c0                	xor    %eax,%eax
  804218:	89 fa                	mov    %edi,%edx
  80421a:	83 c4 1c             	add    $0x1c,%esp
  80421d:	5b                   	pop    %ebx
  80421e:	5e                   	pop    %esi
  80421f:	5f                   	pop    %edi
  804220:	5d                   	pop    %ebp
  804221:	c3                   	ret    
  804222:	66 90                	xchg   %ax,%ax
  804224:	89 d8                	mov    %ebx,%eax
  804226:	f7 f7                	div    %edi
  804228:	31 ff                	xor    %edi,%edi
  80422a:	89 fa                	mov    %edi,%edx
  80422c:	83 c4 1c             	add    $0x1c,%esp
  80422f:	5b                   	pop    %ebx
  804230:	5e                   	pop    %esi
  804231:	5f                   	pop    %edi
  804232:	5d                   	pop    %ebp
  804233:	c3                   	ret    
  804234:	bd 20 00 00 00       	mov    $0x20,%ebp
  804239:	89 eb                	mov    %ebp,%ebx
  80423b:	29 fb                	sub    %edi,%ebx
  80423d:	89 f9                	mov    %edi,%ecx
  80423f:	d3 e6                	shl    %cl,%esi
  804241:	89 c5                	mov    %eax,%ebp
  804243:	88 d9                	mov    %bl,%cl
  804245:	d3 ed                	shr    %cl,%ebp
  804247:	89 e9                	mov    %ebp,%ecx
  804249:	09 f1                	or     %esi,%ecx
  80424b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80424f:	89 f9                	mov    %edi,%ecx
  804251:	d3 e0                	shl    %cl,%eax
  804253:	89 c5                	mov    %eax,%ebp
  804255:	89 d6                	mov    %edx,%esi
  804257:	88 d9                	mov    %bl,%cl
  804259:	d3 ee                	shr    %cl,%esi
  80425b:	89 f9                	mov    %edi,%ecx
  80425d:	d3 e2                	shl    %cl,%edx
  80425f:	8b 44 24 08          	mov    0x8(%esp),%eax
  804263:	88 d9                	mov    %bl,%cl
  804265:	d3 e8                	shr    %cl,%eax
  804267:	09 c2                	or     %eax,%edx
  804269:	89 d0                	mov    %edx,%eax
  80426b:	89 f2                	mov    %esi,%edx
  80426d:	f7 74 24 0c          	divl   0xc(%esp)
  804271:	89 d6                	mov    %edx,%esi
  804273:	89 c3                	mov    %eax,%ebx
  804275:	f7 e5                	mul    %ebp
  804277:	39 d6                	cmp    %edx,%esi
  804279:	72 19                	jb     804294 <__udivdi3+0xfc>
  80427b:	74 0b                	je     804288 <__udivdi3+0xf0>
  80427d:	89 d8                	mov    %ebx,%eax
  80427f:	31 ff                	xor    %edi,%edi
  804281:	e9 58 ff ff ff       	jmp    8041de <__udivdi3+0x46>
  804286:	66 90                	xchg   %ax,%ax
  804288:	8b 54 24 08          	mov    0x8(%esp),%edx
  80428c:	89 f9                	mov    %edi,%ecx
  80428e:	d3 e2                	shl    %cl,%edx
  804290:	39 c2                	cmp    %eax,%edx
  804292:	73 e9                	jae    80427d <__udivdi3+0xe5>
  804294:	8d 43 ff             	lea    -0x1(%ebx),%eax
  804297:	31 ff                	xor    %edi,%edi
  804299:	e9 40 ff ff ff       	jmp    8041de <__udivdi3+0x46>
  80429e:	66 90                	xchg   %ax,%ax
  8042a0:	31 c0                	xor    %eax,%eax
  8042a2:	e9 37 ff ff ff       	jmp    8041de <__udivdi3+0x46>
  8042a7:	90                   	nop

008042a8 <__umoddi3>:
  8042a8:	55                   	push   %ebp
  8042a9:	57                   	push   %edi
  8042aa:	56                   	push   %esi
  8042ab:	53                   	push   %ebx
  8042ac:	83 ec 1c             	sub    $0x1c,%esp
  8042af:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8042b3:	8b 74 24 34          	mov    0x34(%esp),%esi
  8042b7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8042bb:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8042bf:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8042c3:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8042c7:	89 f3                	mov    %esi,%ebx
  8042c9:	89 fa                	mov    %edi,%edx
  8042cb:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8042cf:	89 34 24             	mov    %esi,(%esp)
  8042d2:	85 c0                	test   %eax,%eax
  8042d4:	75 1a                	jne    8042f0 <__umoddi3+0x48>
  8042d6:	39 f7                	cmp    %esi,%edi
  8042d8:	0f 86 a2 00 00 00    	jbe    804380 <__umoddi3+0xd8>
  8042de:	89 c8                	mov    %ecx,%eax
  8042e0:	89 f2                	mov    %esi,%edx
  8042e2:	f7 f7                	div    %edi
  8042e4:	89 d0                	mov    %edx,%eax
  8042e6:	31 d2                	xor    %edx,%edx
  8042e8:	83 c4 1c             	add    $0x1c,%esp
  8042eb:	5b                   	pop    %ebx
  8042ec:	5e                   	pop    %esi
  8042ed:	5f                   	pop    %edi
  8042ee:	5d                   	pop    %ebp
  8042ef:	c3                   	ret    
  8042f0:	39 f0                	cmp    %esi,%eax
  8042f2:	0f 87 ac 00 00 00    	ja     8043a4 <__umoddi3+0xfc>
  8042f8:	0f bd e8             	bsr    %eax,%ebp
  8042fb:	83 f5 1f             	xor    $0x1f,%ebp
  8042fe:	0f 84 ac 00 00 00    	je     8043b0 <__umoddi3+0x108>
  804304:	bf 20 00 00 00       	mov    $0x20,%edi
  804309:	29 ef                	sub    %ebp,%edi
  80430b:	89 fe                	mov    %edi,%esi
  80430d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  804311:	89 e9                	mov    %ebp,%ecx
  804313:	d3 e0                	shl    %cl,%eax
  804315:	89 d7                	mov    %edx,%edi
  804317:	89 f1                	mov    %esi,%ecx
  804319:	d3 ef                	shr    %cl,%edi
  80431b:	09 c7                	or     %eax,%edi
  80431d:	89 e9                	mov    %ebp,%ecx
  80431f:	d3 e2                	shl    %cl,%edx
  804321:	89 14 24             	mov    %edx,(%esp)
  804324:	89 d8                	mov    %ebx,%eax
  804326:	d3 e0                	shl    %cl,%eax
  804328:	89 c2                	mov    %eax,%edx
  80432a:	8b 44 24 08          	mov    0x8(%esp),%eax
  80432e:	d3 e0                	shl    %cl,%eax
  804330:	89 44 24 04          	mov    %eax,0x4(%esp)
  804334:	8b 44 24 08          	mov    0x8(%esp),%eax
  804338:	89 f1                	mov    %esi,%ecx
  80433a:	d3 e8                	shr    %cl,%eax
  80433c:	09 d0                	or     %edx,%eax
  80433e:	d3 eb                	shr    %cl,%ebx
  804340:	89 da                	mov    %ebx,%edx
  804342:	f7 f7                	div    %edi
  804344:	89 d3                	mov    %edx,%ebx
  804346:	f7 24 24             	mull   (%esp)
  804349:	89 c6                	mov    %eax,%esi
  80434b:	89 d1                	mov    %edx,%ecx
  80434d:	39 d3                	cmp    %edx,%ebx
  80434f:	0f 82 87 00 00 00    	jb     8043dc <__umoddi3+0x134>
  804355:	0f 84 91 00 00 00    	je     8043ec <__umoddi3+0x144>
  80435b:	8b 54 24 04          	mov    0x4(%esp),%edx
  80435f:	29 f2                	sub    %esi,%edx
  804361:	19 cb                	sbb    %ecx,%ebx
  804363:	89 d8                	mov    %ebx,%eax
  804365:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  804369:	d3 e0                	shl    %cl,%eax
  80436b:	89 e9                	mov    %ebp,%ecx
  80436d:	d3 ea                	shr    %cl,%edx
  80436f:	09 d0                	or     %edx,%eax
  804371:	89 e9                	mov    %ebp,%ecx
  804373:	d3 eb                	shr    %cl,%ebx
  804375:	89 da                	mov    %ebx,%edx
  804377:	83 c4 1c             	add    $0x1c,%esp
  80437a:	5b                   	pop    %ebx
  80437b:	5e                   	pop    %esi
  80437c:	5f                   	pop    %edi
  80437d:	5d                   	pop    %ebp
  80437e:	c3                   	ret    
  80437f:	90                   	nop
  804380:	89 fd                	mov    %edi,%ebp
  804382:	85 ff                	test   %edi,%edi
  804384:	75 0b                	jne    804391 <__umoddi3+0xe9>
  804386:	b8 01 00 00 00       	mov    $0x1,%eax
  80438b:	31 d2                	xor    %edx,%edx
  80438d:	f7 f7                	div    %edi
  80438f:	89 c5                	mov    %eax,%ebp
  804391:	89 f0                	mov    %esi,%eax
  804393:	31 d2                	xor    %edx,%edx
  804395:	f7 f5                	div    %ebp
  804397:	89 c8                	mov    %ecx,%eax
  804399:	f7 f5                	div    %ebp
  80439b:	89 d0                	mov    %edx,%eax
  80439d:	e9 44 ff ff ff       	jmp    8042e6 <__umoddi3+0x3e>
  8043a2:	66 90                	xchg   %ax,%ax
  8043a4:	89 c8                	mov    %ecx,%eax
  8043a6:	89 f2                	mov    %esi,%edx
  8043a8:	83 c4 1c             	add    $0x1c,%esp
  8043ab:	5b                   	pop    %ebx
  8043ac:	5e                   	pop    %esi
  8043ad:	5f                   	pop    %edi
  8043ae:	5d                   	pop    %ebp
  8043af:	c3                   	ret    
  8043b0:	3b 04 24             	cmp    (%esp),%eax
  8043b3:	72 06                	jb     8043bb <__umoddi3+0x113>
  8043b5:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8043b9:	77 0f                	ja     8043ca <__umoddi3+0x122>
  8043bb:	89 f2                	mov    %esi,%edx
  8043bd:	29 f9                	sub    %edi,%ecx
  8043bf:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8043c3:	89 14 24             	mov    %edx,(%esp)
  8043c6:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8043ca:	8b 44 24 04          	mov    0x4(%esp),%eax
  8043ce:	8b 14 24             	mov    (%esp),%edx
  8043d1:	83 c4 1c             	add    $0x1c,%esp
  8043d4:	5b                   	pop    %ebx
  8043d5:	5e                   	pop    %esi
  8043d6:	5f                   	pop    %edi
  8043d7:	5d                   	pop    %ebp
  8043d8:	c3                   	ret    
  8043d9:	8d 76 00             	lea    0x0(%esi),%esi
  8043dc:	2b 04 24             	sub    (%esp),%eax
  8043df:	19 fa                	sbb    %edi,%edx
  8043e1:	89 d1                	mov    %edx,%ecx
  8043e3:	89 c6                	mov    %eax,%esi
  8043e5:	e9 71 ff ff ff       	jmp    80435b <__umoddi3+0xb3>
  8043ea:	66 90                	xchg   %ax,%ax
  8043ec:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8043f0:	72 ea                	jb     8043dc <__umoddi3+0x134>
  8043f2:	89 d9                	mov    %ebx,%ecx
  8043f4:	e9 62 ff ff ff       	jmp    80435b <__umoddi3+0xb3>
