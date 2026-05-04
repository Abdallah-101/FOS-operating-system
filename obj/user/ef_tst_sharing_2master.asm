
obj/user/ef_tst_sharing_2master:     file format elf32-i386


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
  800031:	e8 d5 03 00 00       	call   80040b <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
// Master program: create the shared variables, initialize them and run slaves
#include <inc/lib.h>

void
_main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	57                   	push   %edi
  80003c:	56                   	push   %esi
  80003d:	53                   	push   %ebx
  80003e:	81 ec ac 00 00 00    	sub    $0xac,%esp
//#else
//	panic("make sure to enable the kernel heap: USE_KHEAP=1");
//#endif
//	/*=================================================*/

	uint32 pagealloc_start = USER_HEAP_START + DYN_ALLOC_MAX_SIZE + PAGE_SIZE; //UHS + 32MB + 4KB
  800044:	c7 45 e4 00 10 00 82 	movl   $0x82001000,-0x1c(%ebp)
	uint32 *x, *y, *z ;
	int diff, expected;

	//x: Readonly
	int freeFrames = sys_calculate_free_frames() ;
  80004b:	e8 ad 31 00 00       	call   8031fd <sys_calculate_free_frames>
  800050:	89 45 e0             	mov    %eax,-0x20(%ebp)
	x = smalloc("x", 4, 0);
  800053:	83 ec 04             	sub    $0x4,%esp
  800056:	6a 00                	push   $0x0
  800058:	6a 04                	push   $0x4
  80005a:	68 20 45 80 00       	push   $0x804520
  80005f:	e8 d5 24 00 00       	call   802539 <smalloc>
  800064:	83 c4 10             	add    $0x10,%esp
  800067:	89 45 dc             	mov    %eax,-0x24(%ebp)
	if (x != (uint32*)pagealloc_start) {panic("Create(): Returned address is not correct. make sure that you align the allocation on 4KB boundary");}
  80006a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80006d:	39 45 dc             	cmp    %eax,-0x24(%ebp)
  800070:	74 14                	je     800086 <_main+0x4e>
  800072:	83 ec 04             	sub    $0x4,%esp
  800075:	68 24 45 80 00       	push   $0x804524
  80007a:	6a 1a                	push   $0x1a
  80007c:	68 87 45 80 00       	push   $0x804587
  800081:	e8 3e 05 00 00       	call   8005c4 <_panic>
	expected = 1+1 ; /*1page +1table*/
  800086:	c7 45 d8 02 00 00 00 	movl   $0x2,-0x28(%ebp)
	diff = (freeFrames - sys_calculate_free_frames());
  80008d:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800090:	e8 68 31 00 00       	call   8031fd <sys_calculate_free_frames>
  800095:	29 c3                	sub    %eax,%ebx
  800097:	89 d8                	mov    %ebx,%eax
  800099:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	if (diff < expected || diff > expected +1+1 /*extra 1 page & 1 table for sbrk (at max)*/) {panic("Wrong allocation (current=%d, expected=%d): make sure that you allocate the required space in the user environment and add its frames to frames_storage", freeFrames - sys_calculate_free_frames(), expected);}
  80009c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80009f:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  8000a2:	7c 0b                	jl     8000af <_main+0x77>
  8000a4:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8000a7:	83 c0 02             	add    $0x2,%eax
  8000aa:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8000ad:	7d 24                	jge    8000d3 <_main+0x9b>
  8000af:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  8000b2:	e8 46 31 00 00       	call   8031fd <sys_calculate_free_frames>
  8000b7:	29 c3                	sub    %eax,%ebx
  8000b9:	89 d8                	mov    %ebx,%eax
  8000bb:	83 ec 0c             	sub    $0xc,%esp
  8000be:	ff 75 d8             	pushl  -0x28(%ebp)
  8000c1:	50                   	push   %eax
  8000c2:	68 a8 45 80 00       	push   $0x8045a8
  8000c7:	6a 1d                	push   $0x1d
  8000c9:	68 87 45 80 00       	push   $0x804587
  8000ce:	e8 f1 04 00 00       	call   8005c4 <_panic>

	//y: Readonly
	freeFrames = sys_calculate_free_frames() ;
  8000d3:	e8 25 31 00 00       	call   8031fd <sys_calculate_free_frames>
  8000d8:	89 45 e0             	mov    %eax,-0x20(%ebp)
	y = smalloc("y", 4, 0);
  8000db:	83 ec 04             	sub    $0x4,%esp
  8000de:	6a 00                	push   $0x0
  8000e0:	6a 04                	push   $0x4
  8000e2:	68 40 46 80 00       	push   $0x804640
  8000e7:	e8 4d 24 00 00       	call   802539 <smalloc>
  8000ec:	83 c4 10             	add    $0x10,%esp
  8000ef:	89 45 d0             	mov    %eax,-0x30(%ebp)
	if (y != (uint32*)(pagealloc_start + 1 * PAGE_SIZE)) {panic("Create(): Returned address is not correct. make sure that you align the allocation on 4KB boundary");}
  8000f2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8000f5:	05 00 10 00 00       	add    $0x1000,%eax
  8000fa:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  8000fd:	74 14                	je     800113 <_main+0xdb>
  8000ff:	83 ec 04             	sub    $0x4,%esp
  800102:	68 24 45 80 00       	push   $0x804524
  800107:	6a 22                	push   $0x22
  800109:	68 87 45 80 00       	push   $0x804587
  80010e:	e8 b1 04 00 00       	call   8005c4 <_panic>
	expected = 1 ; /*1page*/
  800113:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
	diff = (freeFrames - sys_calculate_free_frames());
  80011a:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  80011d:	e8 db 30 00 00       	call   8031fd <sys_calculate_free_frames>
  800122:	29 c3                	sub    %eax,%ebx
  800124:	89 d8                	mov    %ebx,%eax
  800126:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	if (diff < expected || diff > expected +1+1 /*extra 1 page & 1 table for sbrk (at max)*/) {panic("Wrong allocation (current=%d, expected=%d): make sure that you allocate the required space in the user environment and add its frames to frames_storage", freeFrames - sys_calculate_free_frames(), expected);}
  800129:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80012c:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  80012f:	7c 0b                	jl     80013c <_main+0x104>
  800131:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800134:	83 c0 02             	add    $0x2,%eax
  800137:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  80013a:	7d 24                	jge    800160 <_main+0x128>
  80013c:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  80013f:	e8 b9 30 00 00       	call   8031fd <sys_calculate_free_frames>
  800144:	29 c3                	sub    %eax,%ebx
  800146:	89 d8                	mov    %ebx,%eax
  800148:	83 ec 0c             	sub    $0xc,%esp
  80014b:	ff 75 d8             	pushl  -0x28(%ebp)
  80014e:	50                   	push   %eax
  80014f:	68 a8 45 80 00       	push   $0x8045a8
  800154:	6a 25                	push   $0x25
  800156:	68 87 45 80 00       	push   $0x804587
  80015b:	e8 64 04 00 00       	call   8005c4 <_panic>

	//z: Writable
	freeFrames = sys_calculate_free_frames() ;
  800160:	e8 98 30 00 00       	call   8031fd <sys_calculate_free_frames>
  800165:	89 45 e0             	mov    %eax,-0x20(%ebp)
	z = smalloc("z", 4, 1);
  800168:	83 ec 04             	sub    $0x4,%esp
  80016b:	6a 01                	push   $0x1
  80016d:	6a 04                	push   $0x4
  80016f:	68 42 46 80 00       	push   $0x804642
  800174:	e8 c0 23 00 00       	call   802539 <smalloc>
  800179:	83 c4 10             	add    $0x10,%esp
  80017c:	89 45 cc             	mov    %eax,-0x34(%ebp)
	if (z != (uint32*)(pagealloc_start + 2 * PAGE_SIZE)) {panic("Create(): Returned address is not correct. make sure that you align the allocation on 4KB boundary");}
  80017f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800182:	05 00 20 00 00       	add    $0x2000,%eax
  800187:	3b 45 cc             	cmp    -0x34(%ebp),%eax
  80018a:	74 14                	je     8001a0 <_main+0x168>
  80018c:	83 ec 04             	sub    $0x4,%esp
  80018f:	68 24 45 80 00       	push   $0x804524
  800194:	6a 2a                	push   $0x2a
  800196:	68 87 45 80 00       	push   $0x804587
  80019b:	e8 24 04 00 00       	call   8005c4 <_panic>
	expected = 1 ; /*1page*/
  8001a0:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
	diff = (freeFrames - sys_calculate_free_frames());
  8001a7:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  8001aa:	e8 4e 30 00 00       	call   8031fd <sys_calculate_free_frames>
  8001af:	29 c3                	sub    %eax,%ebx
  8001b1:	89 d8                	mov    %ebx,%eax
  8001b3:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	if (diff < expected || diff > expected +1+1 /*extra 1 page & 1 table for sbrk (at max)*/) {panic("Wrong allocation (current=%d, expected=%d): make sure that you allocate the required space in the user environment and add its frames to frames_storage", freeFrames - sys_calculate_free_frames(), expected);}
  8001b6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8001b9:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  8001bc:	7c 0b                	jl     8001c9 <_main+0x191>
  8001be:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8001c1:	83 c0 02             	add    $0x2,%eax
  8001c4:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8001c7:	7d 24                	jge    8001ed <_main+0x1b5>
  8001c9:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  8001cc:	e8 2c 30 00 00       	call   8031fd <sys_calculate_free_frames>
  8001d1:	29 c3                	sub    %eax,%ebx
  8001d3:	89 d8                	mov    %ebx,%eax
  8001d5:	83 ec 0c             	sub    $0xc,%esp
  8001d8:	ff 75 d8             	pushl  -0x28(%ebp)
  8001db:	50                   	push   %eax
  8001dc:	68 a8 45 80 00       	push   $0x8045a8
  8001e1:	6a 2d                	push   $0x2d
  8001e3:	68 87 45 80 00       	push   $0x804587
  8001e8:	e8 d7 03 00 00       	call   8005c4 <_panic>

	*x = 10 ;
  8001ed:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8001f0:	c7 00 0a 00 00 00    	movl   $0xa,(%eax)
	*y = 20 ;
  8001f6:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8001f9:	c7 00 14 00 00 00    	movl   $0x14,(%eax)

	int id1, id2, id3;
	id1 = sys_create_env("ef_shr2Slave1", (myEnv->page_WS_max_size),(myEnv->SecondListSize), 50);
  8001ff:	a1 20 60 80 00       	mov    0x806020,%eax
  800204:	8b 80 a0 05 00 00    	mov    0x5a0(%eax),%eax
  80020a:	89 c2                	mov    %eax,%edx
  80020c:	a1 20 60 80 00       	mov    0x806020,%eax
  800211:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  800217:	6a 32                	push   $0x32
  800219:	52                   	push   %edx
  80021a:	50                   	push   %eax
  80021b:	68 44 46 80 00       	push   $0x804644
  800220:	e8 33 31 00 00       	call   803358 <sys_create_env>
  800225:	83 c4 10             	add    $0x10,%esp
  800228:	89 45 c8             	mov    %eax,-0x38(%ebp)
	id2 = sys_create_env("ef_shr2Slave1", (myEnv->page_WS_max_size),(myEnv->SecondListSize), 50);
  80022b:	a1 20 60 80 00       	mov    0x806020,%eax
  800230:	8b 80 a0 05 00 00    	mov    0x5a0(%eax),%eax
  800236:	89 c2                	mov    %eax,%edx
  800238:	a1 20 60 80 00       	mov    0x806020,%eax
  80023d:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  800243:	6a 32                	push   $0x32
  800245:	52                   	push   %edx
  800246:	50                   	push   %eax
  800247:	68 44 46 80 00       	push   $0x804644
  80024c:	e8 07 31 00 00       	call   803358 <sys_create_env>
  800251:	83 c4 10             	add    $0x10,%esp
  800254:	89 45 c4             	mov    %eax,-0x3c(%ebp)
	id3 = sys_create_env("ef_shr2Slave1", (myEnv->page_WS_max_size),(myEnv->SecondListSize), 50);
  800257:	a1 20 60 80 00       	mov    0x806020,%eax
  80025c:	8b 80 a0 05 00 00    	mov    0x5a0(%eax),%eax
  800262:	89 c2                	mov    %eax,%edx
  800264:	a1 20 60 80 00       	mov    0x806020,%eax
  800269:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  80026f:	6a 32                	push   $0x32
  800271:	52                   	push   %edx
  800272:	50                   	push   %eax
  800273:	68 44 46 80 00       	push   $0x804644
  800278:	e8 db 30 00 00       	call   803358 <sys_create_env>
  80027d:	83 c4 10             	add    $0x10,%esp
  800280:	89 45 c0             	mov    %eax,-0x40(%ebp)

	//to check that the slave environments completed successfully
	rsttst();
  800283:	e8 1c 32 00 00       	call   8034a4 <rsttst>

	int* finish_children = smalloc("finish_children", sizeof(int), 1);
  800288:	83 ec 04             	sub    $0x4,%esp
  80028b:	6a 01                	push   $0x1
  80028d:	6a 04                	push   $0x4
  80028f:	68 52 46 80 00       	push   $0x804652
  800294:	e8 a0 22 00 00       	call   802539 <smalloc>
  800299:	83 c4 10             	add    $0x10,%esp
  80029c:	89 45 bc             	mov    %eax,-0x44(%ebp)

	sys_run_env(id1);
  80029f:	83 ec 0c             	sub    $0xc,%esp
  8002a2:	ff 75 c8             	pushl  -0x38(%ebp)
  8002a5:	e8 cc 30 00 00       	call   803376 <sys_run_env>
  8002aa:	83 c4 10             	add    $0x10,%esp
	sys_run_env(id2);
  8002ad:	83 ec 0c             	sub    $0xc,%esp
  8002b0:	ff 75 c4             	pushl  -0x3c(%ebp)
  8002b3:	e8 be 30 00 00       	call   803376 <sys_run_env>
  8002b8:	83 c4 10             	add    $0x10,%esp
	sys_run_env(id3);
  8002bb:	83 ec 0c             	sub    $0xc,%esp
  8002be:	ff 75 c0             	pushl  -0x40(%ebp)
  8002c1:	e8 b0 30 00 00       	call   803376 <sys_run_env>
  8002c6:	83 c4 10             	add    $0x10,%esp

	env_sleep(15000) ;
  8002c9:	83 ec 0c             	sub    $0xc,%esp
  8002cc:	68 98 3a 00 00       	push   $0x3a98
  8002d1:	e8 1a 3e 00 00       	call   8040f0 <env_sleep>
  8002d6:	83 c4 10             	add    $0x10,%esp

	//to ensure that the slave environments completed successfully
	while (gettst()!=3) ; //panic("test failed");
  8002d9:	90                   	nop
  8002da:	e8 3f 32 00 00       	call   80351e <gettst>
  8002df:	83 f8 03             	cmp    $0x3,%eax
  8002e2:	75 f6                	jne    8002da <_main+0x2a2>


	if (*z != 30)
  8002e4:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8002e7:	8b 00                	mov    (%eax),%eax
  8002e9:	83 f8 1e             	cmp    $0x1e,%eax
  8002ec:	74 14                	je     800302 <_main+0x2ca>
		panic("Error!! Please check the creation (or the getting) of shared 2variables!!\n\n\n");
  8002ee:	83 ec 04             	sub    $0x4,%esp
  8002f1:	68 64 46 80 00       	push   $0x804664
  8002f6:	6a 47                	push   $0x47
  8002f8:	68 87 45 80 00       	push   $0x804587
  8002fd:	e8 c2 02 00 00       	call   8005c4 <_panic>
	else
		cprintf("test sharing 2 [Create & Get] is finished. Now, it'll destroy its children...\n\n");
  800302:	83 ec 0c             	sub    $0xc,%esp
  800305:	68 b4 46 80 00       	push   $0x8046b4
  80030a:	e8 83 05 00 00       	call   800892 <cprintf>
  80030f:	83 c4 10             	add    $0x10,%esp


	if (sys_getparentenvid() > 0) {
  800312:	e8 c8 30 00 00       	call   8033df <sys_getparentenvid>
  800317:	85 c0                	test   %eax,%eax
  800319:	0f 8e e3 00 00 00    	jle    800402 <_main+0x3ca>
		//DISABLE the interrupt to ensure the env_free is done as a whole without preemption
		//to avoid context switch (due to clock interrupt) while freeing the env to prevent:
		//	1. context switching to a wrong process specially in the part of temporarily switching the CPU process for freeing shared variables
		//	2. changing the # free frames

		char changeIntCmd[100] = "__changeInterruptStatus__";
  80031f:	8d 85 54 ff ff ff    	lea    -0xac(%ebp),%eax
  800325:	bb ba 47 80 00       	mov    $0x8047ba,%ebx
  80032a:	ba 1a 00 00 00       	mov    $0x1a,%edx
  80032f:	89 c7                	mov    %eax,%edi
  800331:	89 de                	mov    %ebx,%esi
  800333:	89 d1                	mov    %edx,%ecx
  800335:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  800337:	8d 95 6e ff ff ff    	lea    -0x92(%ebp),%edx
  80033d:	b9 4a 00 00 00       	mov    $0x4a,%ecx
  800342:	b0 00                	mov    $0x0,%al
  800344:	89 d7                	mov    %edx,%edi
  800346:	f3 aa                	rep stos %al,%es:(%edi)
		sys_utilities(changeIntCmd, 0);
  800348:	83 ec 08             	sub    $0x8,%esp
  80034b:	6a 00                	push   $0x0
  80034d:	8d 85 54 ff ff ff    	lea    -0xac(%ebp),%eax
  800353:	50                   	push   %eax
  800354:	e8 a3 32 00 00       	call   8035fc <sys_utilities>
  800359:	83 c4 10             	add    $0x10,%esp
		{
			sys_destroy_env(id1);
  80035c:	83 ec 0c             	sub    $0xc,%esp
  80035f:	ff 75 c8             	pushl  -0x38(%ebp)
  800362:	e8 2b 30 00 00       	call   803392 <sys_destroy_env>
  800367:	83 c4 10             	add    $0x10,%esp
			cprintf("[1] *****************************>>>>>>>>>>>>>>>>>>>>>\n");
  80036a:	83 ec 0c             	sub    $0xc,%esp
  80036d:	68 04 47 80 00       	push   $0x804704
  800372:	e8 1b 05 00 00       	call   800892 <cprintf>
  800377:	83 c4 10             	add    $0x10,%esp
			sys_destroy_env(id2);
  80037a:	83 ec 0c             	sub    $0xc,%esp
  80037d:	ff 75 c4             	pushl  -0x3c(%ebp)
  800380:	e8 0d 30 00 00       	call   803392 <sys_destroy_env>
  800385:	83 c4 10             	add    $0x10,%esp
			cprintf("[2] *****************************>>>>>>>>>>>>>>>>>>>>>\n");
  800388:	83 ec 0c             	sub    $0xc,%esp
  80038b:	68 3c 47 80 00       	push   $0x80473c
  800390:	e8 fd 04 00 00       	call   800892 <cprintf>
  800395:	83 c4 10             	add    $0x10,%esp
			sys_destroy_env(id3);
  800398:	83 ec 0c             	sub    $0xc,%esp
  80039b:	ff 75 c0             	pushl  -0x40(%ebp)
  80039e:	e8 ef 2f 00 00       	call   803392 <sys_destroy_env>
  8003a3:	83 c4 10             	add    $0x10,%esp
			cprintf("[3] *****************************>>>>>>>>>>>>>>>>>>>>>\n");
  8003a6:	83 ec 0c             	sub    $0xc,%esp
  8003a9:	68 74 47 80 00       	push   $0x804774
  8003ae:	e8 df 04 00 00       	call   800892 <cprintf>
  8003b3:	83 c4 10             	add    $0x10,%esp
		}
		sys_utilities(changeIntCmd, 1);
  8003b6:	83 ec 08             	sub    $0x8,%esp
  8003b9:	6a 01                	push   $0x1
  8003bb:	8d 85 54 ff ff ff    	lea    -0xac(%ebp),%eax
  8003c1:	50                   	push   %eax
  8003c2:	e8 35 32 00 00       	call   8035fc <sys_utilities>
  8003c7:	83 c4 10             	add    $0x10,%esp

		int *finishedCount = NULL;
  8003ca:	c7 45 b8 00 00 00 00 	movl   $0x0,-0x48(%ebp)
		finishedCount = sget(sys_getparentenvid(), "finishedCount") ;
  8003d1:	e8 09 30 00 00       	call   8033df <sys_getparentenvid>
  8003d6:	83 ec 08             	sub    $0x8,%esp
  8003d9:	68 ac 47 80 00       	push   $0x8047ac
  8003de:	50                   	push   %eax
  8003df:	e8 fc 26 00 00       	call   802ae0 <sget>
  8003e4:	83 c4 10             	add    $0x10,%esp
  8003e7:	89 45 b8             	mov    %eax,-0x48(%ebp)
		sys_lock_cons();
  8003ea:	e8 5e 2d 00 00       	call   80314d <sys_lock_cons>
		{
			(*finishedCount)++ ;
  8003ef:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8003f2:	8b 00                	mov    (%eax),%eax
  8003f4:	8d 50 01             	lea    0x1(%eax),%edx
  8003f7:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8003fa:	89 10                	mov    %edx,(%eax)
		}
		sys_unlock_cons();
  8003fc:	e8 66 2d 00 00       	call   803167 <sys_unlock_cons>
	}
	return;
  800401:	90                   	nop
  800402:	90                   	nop
}
  800403:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800406:	5b                   	pop    %ebx
  800407:	5e                   	pop    %esi
  800408:	5f                   	pop    %edi
  800409:	5d                   	pop    %ebp
  80040a:	c3                   	ret    

0080040b <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  80040b:	55                   	push   %ebp
  80040c:	89 e5                	mov    %esp,%ebp
  80040e:	57                   	push   %edi
  80040f:	56                   	push   %esi
  800410:	53                   	push   %ebx
  800411:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  800414:	e8 ad 2f 00 00       	call   8033c6 <sys_getenvindex>
  800419:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  80041c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80041f:	89 d0                	mov    %edx,%eax
  800421:	c1 e0 02             	shl    $0x2,%eax
  800424:	01 d0                	add    %edx,%eax
  800426:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80042d:	01 d0                	add    %edx,%eax
  80042f:	89 c2                	mov    %eax,%edx
  800431:	c1 e2 04             	shl    $0x4,%edx
  800434:	29 c2                	sub    %eax,%edx
  800436:	8d 04 95 00 00 00 00 	lea    0x0(,%edx,4),%eax
  80043d:	89 c2                	mov    %eax,%edx
  80043f:	8d 82 00 00 c0 ee    	lea    -0x11400000(%edx),%eax
  800445:	a3 20 60 80 00       	mov    %eax,0x806020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  80044a:	a1 20 60 80 00       	mov    0x806020,%eax
  80044f:	8a 40 20             	mov    0x20(%eax),%al
  800452:	84 c0                	test   %al,%al
  800454:	74 0d                	je     800463 <libmain+0x58>
		binaryname = myEnv->prog_name;
  800456:	a1 20 60 80 00       	mov    0x806020,%eax
  80045b:	83 c0 20             	add    $0x20,%eax
  80045e:	a3 04 60 80 00       	mov    %eax,0x806004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800463:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800467:	7e 0a                	jle    800473 <libmain+0x68>
		binaryname = argv[0];
  800469:	8b 45 0c             	mov    0xc(%ebp),%eax
  80046c:	8b 00                	mov    (%eax),%eax
  80046e:	a3 04 60 80 00       	mov    %eax,0x806004

	// call user main routine
	_main(argc, argv);
  800473:	83 ec 08             	sub    $0x8,%esp
  800476:	ff 75 0c             	pushl  0xc(%ebp)
  800479:	ff 75 08             	pushl  0x8(%ebp)
  80047c:	e8 b7 fb ff ff       	call   800038 <_main>
  800481:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  800484:	a1 00 60 80 00       	mov    0x806000,%eax
  800489:	85 c0                	test   %eax,%eax
  80048b:	0f 84 01 01 00 00    	je     800592 <libmain+0x187>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  800491:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  800497:	bb 18 49 80 00       	mov    $0x804918,%ebx
  80049c:	ba 0e 00 00 00       	mov    $0xe,%edx
  8004a1:	89 c7                	mov    %eax,%edi
  8004a3:	89 de                	mov    %ebx,%esi
  8004a5:	89 d1                	mov    %edx,%ecx
  8004a7:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  8004a9:	8d 55 8a             	lea    -0x76(%ebp),%edx
  8004ac:	b9 56 00 00 00       	mov    $0x56,%ecx
  8004b1:	b0 00                	mov    $0x0,%al
  8004b3:	89 d7                	mov    %edx,%edi
  8004b5:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  8004b7:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  8004be:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8004c1:	83 ec 08             	sub    $0x8,%esp
  8004c4:	50                   	push   %eax
  8004c5:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  8004cb:	50                   	push   %eax
  8004cc:	e8 2b 31 00 00       	call   8035fc <sys_utilities>
  8004d1:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  8004d4:	e8 74 2c 00 00       	call   80314d <sys_lock_cons>
		{
			cprintf("**************************************\n");
  8004d9:	83 ec 0c             	sub    $0xc,%esp
  8004dc:	68 38 48 80 00       	push   $0x804838
  8004e1:	e8 ac 03 00 00       	call   800892 <cprintf>
  8004e6:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  8004e9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8004ec:	85 c0                	test   %eax,%eax
  8004ee:	74 18                	je     800508 <libmain+0xfd>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  8004f0:	e8 25 31 00 00       	call   80361a <sys_get_optimal_num_faults>
  8004f5:	83 ec 08             	sub    $0x8,%esp
  8004f8:	50                   	push   %eax
  8004f9:	68 60 48 80 00       	push   $0x804860
  8004fe:	e8 8f 03 00 00       	call   800892 <cprintf>
  800503:	83 c4 10             	add    $0x10,%esp
  800506:	eb 59                	jmp    800561 <libmain+0x156>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800508:	a1 20 60 80 00       	mov    0x806020,%eax
  80050d:	8b 90 bc 05 00 00    	mov    0x5bc(%eax),%edx
  800513:	a1 20 60 80 00       	mov    0x806020,%eax
  800518:	8b 80 ac 05 00 00    	mov    0x5ac(%eax),%eax
  80051e:	83 ec 04             	sub    $0x4,%esp
  800521:	52                   	push   %edx
  800522:	50                   	push   %eax
  800523:	68 84 48 80 00       	push   $0x804884
  800528:	e8 65 03 00 00       	call   800892 <cprintf>
  80052d:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800530:	a1 20 60 80 00       	mov    0x806020,%eax
  800535:	8b 88 d0 05 00 00    	mov    0x5d0(%eax),%ecx
  80053b:	a1 20 60 80 00       	mov    0x806020,%eax
  800540:	8b 90 cc 05 00 00    	mov    0x5cc(%eax),%edx
  800546:	a1 20 60 80 00       	mov    0x806020,%eax
  80054b:	8b 80 c8 05 00 00    	mov    0x5c8(%eax),%eax
  800551:	51                   	push   %ecx
  800552:	52                   	push   %edx
  800553:	50                   	push   %eax
  800554:	68 ac 48 80 00       	push   $0x8048ac
  800559:	e8 34 03 00 00       	call   800892 <cprintf>
  80055e:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800561:	a1 20 60 80 00       	mov    0x806020,%eax
  800566:	8b 80 d4 05 00 00    	mov    0x5d4(%eax),%eax
  80056c:	83 ec 08             	sub    $0x8,%esp
  80056f:	50                   	push   %eax
  800570:	68 04 49 80 00       	push   $0x804904
  800575:	e8 18 03 00 00       	call   800892 <cprintf>
  80057a:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  80057d:	83 ec 0c             	sub    $0xc,%esp
  800580:	68 38 48 80 00       	push   $0x804838
  800585:	e8 08 03 00 00       	call   800892 <cprintf>
  80058a:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  80058d:	e8 d5 2b 00 00       	call   803167 <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  800592:	e8 1f 00 00 00       	call   8005b6 <exit>
}
  800597:	90                   	nop
  800598:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80059b:	5b                   	pop    %ebx
  80059c:	5e                   	pop    %esi
  80059d:	5f                   	pop    %edi
  80059e:	5d                   	pop    %ebp
  80059f:	c3                   	ret    

008005a0 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8005a0:	55                   	push   %ebp
  8005a1:	89 e5                	mov    %esp,%ebp
  8005a3:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8005a6:	83 ec 0c             	sub    $0xc,%esp
  8005a9:	6a 00                	push   $0x0
  8005ab:	e8 e2 2d 00 00       	call   803392 <sys_destroy_env>
  8005b0:	83 c4 10             	add    $0x10,%esp
}
  8005b3:	90                   	nop
  8005b4:	c9                   	leave  
  8005b5:	c3                   	ret    

008005b6 <exit>:

void
exit(void)
{
  8005b6:	55                   	push   %ebp
  8005b7:	89 e5                	mov    %esp,%ebp
  8005b9:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8005bc:	e8 37 2e 00 00       	call   8033f8 <sys_exit_env>
}
  8005c1:	90                   	nop
  8005c2:	c9                   	leave  
  8005c3:	c3                   	ret    

008005c4 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8005c4:	55                   	push   %ebp
  8005c5:	89 e5                	mov    %esp,%ebp
  8005c7:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8005ca:	8d 45 10             	lea    0x10(%ebp),%eax
  8005cd:	83 c0 04             	add    $0x4,%eax
  8005d0:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8005d3:	a1 18 e1 81 00       	mov    0x81e118,%eax
  8005d8:	85 c0                	test   %eax,%eax
  8005da:	74 16                	je     8005f2 <_panic+0x2e>
		cprintf("%s: ", argv0);
  8005dc:	a1 18 e1 81 00       	mov    0x81e118,%eax
  8005e1:	83 ec 08             	sub    $0x8,%esp
  8005e4:	50                   	push   %eax
  8005e5:	68 7c 49 80 00       	push   $0x80497c
  8005ea:	e8 a3 02 00 00       	call   800892 <cprintf>
  8005ef:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  8005f2:	a1 04 60 80 00       	mov    0x806004,%eax
  8005f7:	83 ec 0c             	sub    $0xc,%esp
  8005fa:	ff 75 0c             	pushl  0xc(%ebp)
  8005fd:	ff 75 08             	pushl  0x8(%ebp)
  800600:	50                   	push   %eax
  800601:	68 84 49 80 00       	push   $0x804984
  800606:	6a 74                	push   $0x74
  800608:	e8 b2 02 00 00       	call   8008bf <cprintf_colored>
  80060d:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  800610:	8b 45 10             	mov    0x10(%ebp),%eax
  800613:	83 ec 08             	sub    $0x8,%esp
  800616:	ff 75 f4             	pushl  -0xc(%ebp)
  800619:	50                   	push   %eax
  80061a:	e8 04 02 00 00       	call   800823 <vcprintf>
  80061f:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800622:	83 ec 08             	sub    $0x8,%esp
  800625:	6a 00                	push   $0x0
  800627:	68 ac 49 80 00       	push   $0x8049ac
  80062c:	e8 f2 01 00 00       	call   800823 <vcprintf>
  800631:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800634:	e8 7d ff ff ff       	call   8005b6 <exit>

	// should not return here
	while (1) ;
  800639:	eb fe                	jmp    800639 <_panic+0x75>

0080063b <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  80063b:	55                   	push   %ebp
  80063c:	89 e5                	mov    %esp,%ebp
  80063e:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800641:	a1 20 60 80 00       	mov    0x806020,%eax
  800646:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  80064c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80064f:	39 c2                	cmp    %eax,%edx
  800651:	74 14                	je     800667 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800653:	83 ec 04             	sub    $0x4,%esp
  800656:	68 b0 49 80 00       	push   $0x8049b0
  80065b:	6a 26                	push   $0x26
  80065d:	68 fc 49 80 00       	push   $0x8049fc
  800662:	e8 5d ff ff ff       	call   8005c4 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800667:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  80066e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800675:	e9 c5 00 00 00       	jmp    80073f <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  80067a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80067d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800684:	8b 45 08             	mov    0x8(%ebp),%eax
  800687:	01 d0                	add    %edx,%eax
  800689:	8b 00                	mov    (%eax),%eax
  80068b:	85 c0                	test   %eax,%eax
  80068d:	75 08                	jne    800697 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  80068f:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800692:	e9 a5 00 00 00       	jmp    80073c <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  800697:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80069e:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8006a5:	eb 69                	jmp    800710 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8006a7:	a1 20 60 80 00       	mov    0x806020,%eax
  8006ac:	8b 88 a4 05 00 00    	mov    0x5a4(%eax),%ecx
  8006b2:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8006b5:	89 d0                	mov    %edx,%eax
  8006b7:	01 c0                	add    %eax,%eax
  8006b9:	01 d0                	add    %edx,%eax
  8006bb:	c1 e0 03             	shl    $0x3,%eax
  8006be:	01 c8                	add    %ecx,%eax
  8006c0:	8a 40 04             	mov    0x4(%eax),%al
  8006c3:	84 c0                	test   %al,%al
  8006c5:	75 46                	jne    80070d <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8006c7:	a1 20 60 80 00       	mov    0x806020,%eax
  8006cc:	8b 88 a4 05 00 00    	mov    0x5a4(%eax),%ecx
  8006d2:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8006d5:	89 d0                	mov    %edx,%eax
  8006d7:	01 c0                	add    %eax,%eax
  8006d9:	01 d0                	add    %edx,%eax
  8006db:	c1 e0 03             	shl    $0x3,%eax
  8006de:	01 c8                	add    %ecx,%eax
  8006e0:	8b 00                	mov    (%eax),%eax
  8006e2:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8006e5:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8006e8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8006ed:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8006ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8006f2:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8006f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8006fc:	01 c8                	add    %ecx,%eax
  8006fe:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800700:	39 c2                	cmp    %eax,%edx
  800702:	75 09                	jne    80070d <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  800704:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  80070b:	eb 15                	jmp    800722 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80070d:	ff 45 e8             	incl   -0x18(%ebp)
  800710:	a1 20 60 80 00       	mov    0x806020,%eax
  800715:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  80071b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80071e:	39 c2                	cmp    %eax,%edx
  800720:	77 85                	ja     8006a7 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800722:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800726:	75 14                	jne    80073c <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  800728:	83 ec 04             	sub    $0x4,%esp
  80072b:	68 08 4a 80 00       	push   $0x804a08
  800730:	6a 3a                	push   $0x3a
  800732:	68 fc 49 80 00       	push   $0x8049fc
  800737:	e8 88 fe ff ff       	call   8005c4 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  80073c:	ff 45 f0             	incl   -0x10(%ebp)
  80073f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800742:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800745:	0f 8c 2f ff ff ff    	jl     80067a <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  80074b:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800752:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800759:	eb 26                	jmp    800781 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  80075b:	a1 20 60 80 00       	mov    0x806020,%eax
  800760:	8b 88 a4 05 00 00    	mov    0x5a4(%eax),%ecx
  800766:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800769:	89 d0                	mov    %edx,%eax
  80076b:	01 c0                	add    %eax,%eax
  80076d:	01 d0                	add    %edx,%eax
  80076f:	c1 e0 03             	shl    $0x3,%eax
  800772:	01 c8                	add    %ecx,%eax
  800774:	8a 40 04             	mov    0x4(%eax),%al
  800777:	3c 01                	cmp    $0x1,%al
  800779:	75 03                	jne    80077e <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  80077b:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80077e:	ff 45 e0             	incl   -0x20(%ebp)
  800781:	a1 20 60 80 00       	mov    0x806020,%eax
  800786:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  80078c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80078f:	39 c2                	cmp    %eax,%edx
  800791:	77 c8                	ja     80075b <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800793:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800796:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800799:	74 14                	je     8007af <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  80079b:	83 ec 04             	sub    $0x4,%esp
  80079e:	68 5c 4a 80 00       	push   $0x804a5c
  8007a3:	6a 44                	push   $0x44
  8007a5:	68 fc 49 80 00       	push   $0x8049fc
  8007aa:	e8 15 fe ff ff       	call   8005c4 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8007af:	90                   	nop
  8007b0:	c9                   	leave  
  8007b1:	c3                   	ret    

008007b2 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  8007b2:	55                   	push   %ebp
  8007b3:	89 e5                	mov    %esp,%ebp
  8007b5:	53                   	push   %ebx
  8007b6:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  8007b9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007bc:	8b 00                	mov    (%eax),%eax
  8007be:	8d 48 01             	lea    0x1(%eax),%ecx
  8007c1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8007c4:	89 0a                	mov    %ecx,(%edx)
  8007c6:	8b 55 08             	mov    0x8(%ebp),%edx
  8007c9:	88 d1                	mov    %dl,%cl
  8007cb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8007ce:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8007d2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007d5:	8b 00                	mov    (%eax),%eax
  8007d7:	3d ff 00 00 00       	cmp    $0xff,%eax
  8007dc:	75 30                	jne    80080e <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  8007de:	8b 15 1c e1 81 00    	mov    0x81e11c,%edx
  8007e4:	a0 44 60 80 00       	mov    0x806044,%al
  8007e9:	0f b6 c0             	movzbl %al,%eax
  8007ec:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8007ef:	8b 09                	mov    (%ecx),%ecx
  8007f1:	89 cb                	mov    %ecx,%ebx
  8007f3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8007f6:	83 c1 08             	add    $0x8,%ecx
  8007f9:	52                   	push   %edx
  8007fa:	50                   	push   %eax
  8007fb:	53                   	push   %ebx
  8007fc:	51                   	push   %ecx
  8007fd:	e8 07 29 00 00       	call   803109 <sys_cputs>
  800802:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800805:	8b 45 0c             	mov    0xc(%ebp),%eax
  800808:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  80080e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800811:	8b 40 04             	mov    0x4(%eax),%eax
  800814:	8d 50 01             	lea    0x1(%eax),%edx
  800817:	8b 45 0c             	mov    0xc(%ebp),%eax
  80081a:	89 50 04             	mov    %edx,0x4(%eax)
}
  80081d:	90                   	nop
  80081e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800821:	c9                   	leave  
  800822:	c3                   	ret    

00800823 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800823:	55                   	push   %ebp
  800824:	89 e5                	mov    %esp,%ebp
  800826:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80082c:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800833:	00 00 00 
	b.cnt = 0;
  800836:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80083d:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800840:	ff 75 0c             	pushl  0xc(%ebp)
  800843:	ff 75 08             	pushl  0x8(%ebp)
  800846:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80084c:	50                   	push   %eax
  80084d:	68 b2 07 80 00       	push   $0x8007b2
  800852:	e8 5a 02 00 00       	call   800ab1 <vprintfmt>
  800857:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  80085a:	8b 15 1c e1 81 00    	mov    0x81e11c,%edx
  800860:	a0 44 60 80 00       	mov    0x806044,%al
  800865:	0f b6 c0             	movzbl %al,%eax
  800868:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  80086e:	52                   	push   %edx
  80086f:	50                   	push   %eax
  800870:	51                   	push   %ecx
  800871:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800877:	83 c0 08             	add    $0x8,%eax
  80087a:	50                   	push   %eax
  80087b:	e8 89 28 00 00       	call   803109 <sys_cputs>
  800880:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800883:	c6 05 44 60 80 00 00 	movb   $0x0,0x806044
	return b.cnt;
  80088a:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800890:	c9                   	leave  
  800891:	c3                   	ret    

00800892 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  800892:	55                   	push   %ebp
  800893:	89 e5                	mov    %esp,%ebp
  800895:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800898:	c6 05 44 60 80 00 01 	movb   $0x1,0x806044
	va_start(ap, fmt);
  80089f:	8d 45 0c             	lea    0xc(%ebp),%eax
  8008a2:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8008a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8008a8:	83 ec 08             	sub    $0x8,%esp
  8008ab:	ff 75 f4             	pushl  -0xc(%ebp)
  8008ae:	50                   	push   %eax
  8008af:	e8 6f ff ff ff       	call   800823 <vcprintf>
  8008b4:	83 c4 10             	add    $0x10,%esp
  8008b7:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8008ba:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8008bd:	c9                   	leave  
  8008be:	c3                   	ret    

008008bf <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  8008bf:	55                   	push   %ebp
  8008c0:	89 e5                	mov    %esp,%ebp
  8008c2:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8008c5:	c6 05 44 60 80 00 01 	movb   $0x1,0x806044
	curTextClr = (textClr << 8) ; //set text color by the given value
  8008cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8008cf:	c1 e0 08             	shl    $0x8,%eax
  8008d2:	a3 1c e1 81 00       	mov    %eax,0x81e11c
	va_start(ap, fmt);
  8008d7:	8d 45 0c             	lea    0xc(%ebp),%eax
  8008da:	83 c0 04             	add    $0x4,%eax
  8008dd:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8008e0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008e3:	83 ec 08             	sub    $0x8,%esp
  8008e6:	ff 75 f4             	pushl  -0xc(%ebp)
  8008e9:	50                   	push   %eax
  8008ea:	e8 34 ff ff ff       	call   800823 <vcprintf>
  8008ef:	83 c4 10             	add    $0x10,%esp
  8008f2:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  8008f5:	c7 05 1c e1 81 00 00 	movl   $0x700,0x81e11c
  8008fc:	07 00 00 

	return cnt;
  8008ff:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800902:	c9                   	leave  
  800903:	c3                   	ret    

00800904 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  800904:	55                   	push   %ebp
  800905:	89 e5                	mov    %esp,%ebp
  800907:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  80090a:	e8 3e 28 00 00       	call   80314d <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  80090f:	8d 45 0c             	lea    0xc(%ebp),%eax
  800912:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  800915:	8b 45 08             	mov    0x8(%ebp),%eax
  800918:	83 ec 08             	sub    $0x8,%esp
  80091b:	ff 75 f4             	pushl  -0xc(%ebp)
  80091e:	50                   	push   %eax
  80091f:	e8 ff fe ff ff       	call   800823 <vcprintf>
  800924:	83 c4 10             	add    $0x10,%esp
  800927:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  80092a:	e8 38 28 00 00       	call   803167 <sys_unlock_cons>
	return cnt;
  80092f:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800932:	c9                   	leave  
  800933:	c3                   	ret    

00800934 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800934:	55                   	push   %ebp
  800935:	89 e5                	mov    %esp,%ebp
  800937:	53                   	push   %ebx
  800938:	83 ec 14             	sub    $0x14,%esp
  80093b:	8b 45 10             	mov    0x10(%ebp),%eax
  80093e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800941:	8b 45 14             	mov    0x14(%ebp),%eax
  800944:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800947:	8b 45 18             	mov    0x18(%ebp),%eax
  80094a:	ba 00 00 00 00       	mov    $0x0,%edx
  80094f:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800952:	77 55                	ja     8009a9 <printnum+0x75>
  800954:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800957:	72 05                	jb     80095e <printnum+0x2a>
  800959:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80095c:	77 4b                	ja     8009a9 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80095e:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800961:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800964:	8b 45 18             	mov    0x18(%ebp),%eax
  800967:	ba 00 00 00 00       	mov    $0x0,%edx
  80096c:	52                   	push   %edx
  80096d:	50                   	push   %eax
  80096e:	ff 75 f4             	pushl  -0xc(%ebp)
  800971:	ff 75 f0             	pushl  -0x10(%ebp)
  800974:	e8 3f 39 00 00       	call   8042b8 <__udivdi3>
  800979:	83 c4 10             	add    $0x10,%esp
  80097c:	83 ec 04             	sub    $0x4,%esp
  80097f:	ff 75 20             	pushl  0x20(%ebp)
  800982:	53                   	push   %ebx
  800983:	ff 75 18             	pushl  0x18(%ebp)
  800986:	52                   	push   %edx
  800987:	50                   	push   %eax
  800988:	ff 75 0c             	pushl  0xc(%ebp)
  80098b:	ff 75 08             	pushl  0x8(%ebp)
  80098e:	e8 a1 ff ff ff       	call   800934 <printnum>
  800993:	83 c4 20             	add    $0x20,%esp
  800996:	eb 1a                	jmp    8009b2 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800998:	83 ec 08             	sub    $0x8,%esp
  80099b:	ff 75 0c             	pushl  0xc(%ebp)
  80099e:	ff 75 20             	pushl  0x20(%ebp)
  8009a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8009a4:	ff d0                	call   *%eax
  8009a6:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8009a9:	ff 4d 1c             	decl   0x1c(%ebp)
  8009ac:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  8009b0:	7f e6                	jg     800998 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8009b2:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8009b5:	bb 00 00 00 00       	mov    $0x0,%ebx
  8009ba:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009bd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8009c0:	53                   	push   %ebx
  8009c1:	51                   	push   %ecx
  8009c2:	52                   	push   %edx
  8009c3:	50                   	push   %eax
  8009c4:	e8 ff 39 00 00       	call   8043c8 <__umoddi3>
  8009c9:	83 c4 10             	add    $0x10,%esp
  8009cc:	05 d4 4c 80 00       	add    $0x804cd4,%eax
  8009d1:	8a 00                	mov    (%eax),%al
  8009d3:	0f be c0             	movsbl %al,%eax
  8009d6:	83 ec 08             	sub    $0x8,%esp
  8009d9:	ff 75 0c             	pushl  0xc(%ebp)
  8009dc:	50                   	push   %eax
  8009dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8009e0:	ff d0                	call   *%eax
  8009e2:	83 c4 10             	add    $0x10,%esp
}
  8009e5:	90                   	nop
  8009e6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8009e9:	c9                   	leave  
  8009ea:	c3                   	ret    

008009eb <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8009eb:	55                   	push   %ebp
  8009ec:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8009ee:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8009f2:	7e 1c                	jle    800a10 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8009f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8009f7:	8b 00                	mov    (%eax),%eax
  8009f9:	8d 50 08             	lea    0x8(%eax),%edx
  8009fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ff:	89 10                	mov    %edx,(%eax)
  800a01:	8b 45 08             	mov    0x8(%ebp),%eax
  800a04:	8b 00                	mov    (%eax),%eax
  800a06:	83 e8 08             	sub    $0x8,%eax
  800a09:	8b 50 04             	mov    0x4(%eax),%edx
  800a0c:	8b 00                	mov    (%eax),%eax
  800a0e:	eb 40                	jmp    800a50 <getuint+0x65>
	else if (lflag)
  800a10:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800a14:	74 1e                	je     800a34 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800a16:	8b 45 08             	mov    0x8(%ebp),%eax
  800a19:	8b 00                	mov    (%eax),%eax
  800a1b:	8d 50 04             	lea    0x4(%eax),%edx
  800a1e:	8b 45 08             	mov    0x8(%ebp),%eax
  800a21:	89 10                	mov    %edx,(%eax)
  800a23:	8b 45 08             	mov    0x8(%ebp),%eax
  800a26:	8b 00                	mov    (%eax),%eax
  800a28:	83 e8 04             	sub    $0x4,%eax
  800a2b:	8b 00                	mov    (%eax),%eax
  800a2d:	ba 00 00 00 00       	mov    $0x0,%edx
  800a32:	eb 1c                	jmp    800a50 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800a34:	8b 45 08             	mov    0x8(%ebp),%eax
  800a37:	8b 00                	mov    (%eax),%eax
  800a39:	8d 50 04             	lea    0x4(%eax),%edx
  800a3c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a3f:	89 10                	mov    %edx,(%eax)
  800a41:	8b 45 08             	mov    0x8(%ebp),%eax
  800a44:	8b 00                	mov    (%eax),%eax
  800a46:	83 e8 04             	sub    $0x4,%eax
  800a49:	8b 00                	mov    (%eax),%eax
  800a4b:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800a50:	5d                   	pop    %ebp
  800a51:	c3                   	ret    

00800a52 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800a52:	55                   	push   %ebp
  800a53:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800a55:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800a59:	7e 1c                	jle    800a77 <getint+0x25>
		return va_arg(*ap, long long);
  800a5b:	8b 45 08             	mov    0x8(%ebp),%eax
  800a5e:	8b 00                	mov    (%eax),%eax
  800a60:	8d 50 08             	lea    0x8(%eax),%edx
  800a63:	8b 45 08             	mov    0x8(%ebp),%eax
  800a66:	89 10                	mov    %edx,(%eax)
  800a68:	8b 45 08             	mov    0x8(%ebp),%eax
  800a6b:	8b 00                	mov    (%eax),%eax
  800a6d:	83 e8 08             	sub    $0x8,%eax
  800a70:	8b 50 04             	mov    0x4(%eax),%edx
  800a73:	8b 00                	mov    (%eax),%eax
  800a75:	eb 38                	jmp    800aaf <getint+0x5d>
	else if (lflag)
  800a77:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800a7b:	74 1a                	je     800a97 <getint+0x45>
		return va_arg(*ap, long);
  800a7d:	8b 45 08             	mov    0x8(%ebp),%eax
  800a80:	8b 00                	mov    (%eax),%eax
  800a82:	8d 50 04             	lea    0x4(%eax),%edx
  800a85:	8b 45 08             	mov    0x8(%ebp),%eax
  800a88:	89 10                	mov    %edx,(%eax)
  800a8a:	8b 45 08             	mov    0x8(%ebp),%eax
  800a8d:	8b 00                	mov    (%eax),%eax
  800a8f:	83 e8 04             	sub    $0x4,%eax
  800a92:	8b 00                	mov    (%eax),%eax
  800a94:	99                   	cltd   
  800a95:	eb 18                	jmp    800aaf <getint+0x5d>
	else
		return va_arg(*ap, int);
  800a97:	8b 45 08             	mov    0x8(%ebp),%eax
  800a9a:	8b 00                	mov    (%eax),%eax
  800a9c:	8d 50 04             	lea    0x4(%eax),%edx
  800a9f:	8b 45 08             	mov    0x8(%ebp),%eax
  800aa2:	89 10                	mov    %edx,(%eax)
  800aa4:	8b 45 08             	mov    0x8(%ebp),%eax
  800aa7:	8b 00                	mov    (%eax),%eax
  800aa9:	83 e8 04             	sub    $0x4,%eax
  800aac:	8b 00                	mov    (%eax),%eax
  800aae:	99                   	cltd   
}
  800aaf:	5d                   	pop    %ebp
  800ab0:	c3                   	ret    

00800ab1 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800ab1:	55                   	push   %ebp
  800ab2:	89 e5                	mov    %esp,%ebp
  800ab4:	56                   	push   %esi
  800ab5:	53                   	push   %ebx
  800ab6:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800ab9:	eb 17                	jmp    800ad2 <vprintfmt+0x21>
			if (ch == '\0')
  800abb:	85 db                	test   %ebx,%ebx
  800abd:	0f 84 c1 03 00 00    	je     800e84 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  800ac3:	83 ec 08             	sub    $0x8,%esp
  800ac6:	ff 75 0c             	pushl  0xc(%ebp)
  800ac9:	53                   	push   %ebx
  800aca:	8b 45 08             	mov    0x8(%ebp),%eax
  800acd:	ff d0                	call   *%eax
  800acf:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800ad2:	8b 45 10             	mov    0x10(%ebp),%eax
  800ad5:	8d 50 01             	lea    0x1(%eax),%edx
  800ad8:	89 55 10             	mov    %edx,0x10(%ebp)
  800adb:	8a 00                	mov    (%eax),%al
  800add:	0f b6 d8             	movzbl %al,%ebx
  800ae0:	83 fb 25             	cmp    $0x25,%ebx
  800ae3:	75 d6                	jne    800abb <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800ae5:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800ae9:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800af0:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800af7:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800afe:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800b05:	8b 45 10             	mov    0x10(%ebp),%eax
  800b08:	8d 50 01             	lea    0x1(%eax),%edx
  800b0b:	89 55 10             	mov    %edx,0x10(%ebp)
  800b0e:	8a 00                	mov    (%eax),%al
  800b10:	0f b6 d8             	movzbl %al,%ebx
  800b13:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800b16:	83 f8 5b             	cmp    $0x5b,%eax
  800b19:	0f 87 3d 03 00 00    	ja     800e5c <vprintfmt+0x3ab>
  800b1f:	8b 04 85 f8 4c 80 00 	mov    0x804cf8(,%eax,4),%eax
  800b26:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800b28:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800b2c:	eb d7                	jmp    800b05 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800b2e:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800b32:	eb d1                	jmp    800b05 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800b34:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800b3b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800b3e:	89 d0                	mov    %edx,%eax
  800b40:	c1 e0 02             	shl    $0x2,%eax
  800b43:	01 d0                	add    %edx,%eax
  800b45:	01 c0                	add    %eax,%eax
  800b47:	01 d8                	add    %ebx,%eax
  800b49:	83 e8 30             	sub    $0x30,%eax
  800b4c:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800b4f:	8b 45 10             	mov    0x10(%ebp),%eax
  800b52:	8a 00                	mov    (%eax),%al
  800b54:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800b57:	83 fb 2f             	cmp    $0x2f,%ebx
  800b5a:	7e 3e                	jle    800b9a <vprintfmt+0xe9>
  800b5c:	83 fb 39             	cmp    $0x39,%ebx
  800b5f:	7f 39                	jg     800b9a <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800b61:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800b64:	eb d5                	jmp    800b3b <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800b66:	8b 45 14             	mov    0x14(%ebp),%eax
  800b69:	83 c0 04             	add    $0x4,%eax
  800b6c:	89 45 14             	mov    %eax,0x14(%ebp)
  800b6f:	8b 45 14             	mov    0x14(%ebp),%eax
  800b72:	83 e8 04             	sub    $0x4,%eax
  800b75:	8b 00                	mov    (%eax),%eax
  800b77:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800b7a:	eb 1f                	jmp    800b9b <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800b7c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b80:	79 83                	jns    800b05 <vprintfmt+0x54>
				width = 0;
  800b82:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800b89:	e9 77 ff ff ff       	jmp    800b05 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800b8e:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800b95:	e9 6b ff ff ff       	jmp    800b05 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800b9a:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800b9b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b9f:	0f 89 60 ff ff ff    	jns    800b05 <vprintfmt+0x54>
				width = precision, precision = -1;
  800ba5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800ba8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800bab:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800bb2:	e9 4e ff ff ff       	jmp    800b05 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800bb7:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800bba:	e9 46 ff ff ff       	jmp    800b05 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800bbf:	8b 45 14             	mov    0x14(%ebp),%eax
  800bc2:	83 c0 04             	add    $0x4,%eax
  800bc5:	89 45 14             	mov    %eax,0x14(%ebp)
  800bc8:	8b 45 14             	mov    0x14(%ebp),%eax
  800bcb:	83 e8 04             	sub    $0x4,%eax
  800bce:	8b 00                	mov    (%eax),%eax
  800bd0:	83 ec 08             	sub    $0x8,%esp
  800bd3:	ff 75 0c             	pushl  0xc(%ebp)
  800bd6:	50                   	push   %eax
  800bd7:	8b 45 08             	mov    0x8(%ebp),%eax
  800bda:	ff d0                	call   *%eax
  800bdc:	83 c4 10             	add    $0x10,%esp
			break;
  800bdf:	e9 9b 02 00 00       	jmp    800e7f <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800be4:	8b 45 14             	mov    0x14(%ebp),%eax
  800be7:	83 c0 04             	add    $0x4,%eax
  800bea:	89 45 14             	mov    %eax,0x14(%ebp)
  800bed:	8b 45 14             	mov    0x14(%ebp),%eax
  800bf0:	83 e8 04             	sub    $0x4,%eax
  800bf3:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800bf5:	85 db                	test   %ebx,%ebx
  800bf7:	79 02                	jns    800bfb <vprintfmt+0x14a>
				err = -err;
  800bf9:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800bfb:	83 fb 64             	cmp    $0x64,%ebx
  800bfe:	7f 0b                	jg     800c0b <vprintfmt+0x15a>
  800c00:	8b 34 9d 40 4b 80 00 	mov    0x804b40(,%ebx,4),%esi
  800c07:	85 f6                	test   %esi,%esi
  800c09:	75 19                	jne    800c24 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800c0b:	53                   	push   %ebx
  800c0c:	68 e5 4c 80 00       	push   $0x804ce5
  800c11:	ff 75 0c             	pushl  0xc(%ebp)
  800c14:	ff 75 08             	pushl  0x8(%ebp)
  800c17:	e8 70 02 00 00       	call   800e8c <printfmt>
  800c1c:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800c1f:	e9 5b 02 00 00       	jmp    800e7f <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800c24:	56                   	push   %esi
  800c25:	68 ee 4c 80 00       	push   $0x804cee
  800c2a:	ff 75 0c             	pushl  0xc(%ebp)
  800c2d:	ff 75 08             	pushl  0x8(%ebp)
  800c30:	e8 57 02 00 00       	call   800e8c <printfmt>
  800c35:	83 c4 10             	add    $0x10,%esp
			break;
  800c38:	e9 42 02 00 00       	jmp    800e7f <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800c3d:	8b 45 14             	mov    0x14(%ebp),%eax
  800c40:	83 c0 04             	add    $0x4,%eax
  800c43:	89 45 14             	mov    %eax,0x14(%ebp)
  800c46:	8b 45 14             	mov    0x14(%ebp),%eax
  800c49:	83 e8 04             	sub    $0x4,%eax
  800c4c:	8b 30                	mov    (%eax),%esi
  800c4e:	85 f6                	test   %esi,%esi
  800c50:	75 05                	jne    800c57 <vprintfmt+0x1a6>
				p = "(null)";
  800c52:	be f1 4c 80 00       	mov    $0x804cf1,%esi
			if (width > 0 && padc != '-')
  800c57:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800c5b:	7e 6d                	jle    800cca <vprintfmt+0x219>
  800c5d:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800c61:	74 67                	je     800cca <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800c63:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800c66:	83 ec 08             	sub    $0x8,%esp
  800c69:	50                   	push   %eax
  800c6a:	56                   	push   %esi
  800c6b:	e8 1e 03 00 00       	call   800f8e <strnlen>
  800c70:	83 c4 10             	add    $0x10,%esp
  800c73:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800c76:	eb 16                	jmp    800c8e <vprintfmt+0x1dd>
					putch(padc, putdat);
  800c78:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800c7c:	83 ec 08             	sub    $0x8,%esp
  800c7f:	ff 75 0c             	pushl  0xc(%ebp)
  800c82:	50                   	push   %eax
  800c83:	8b 45 08             	mov    0x8(%ebp),%eax
  800c86:	ff d0                	call   *%eax
  800c88:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800c8b:	ff 4d e4             	decl   -0x1c(%ebp)
  800c8e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800c92:	7f e4                	jg     800c78 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800c94:	eb 34                	jmp    800cca <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800c96:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800c9a:	74 1c                	je     800cb8 <vprintfmt+0x207>
  800c9c:	83 fb 1f             	cmp    $0x1f,%ebx
  800c9f:	7e 05                	jle    800ca6 <vprintfmt+0x1f5>
  800ca1:	83 fb 7e             	cmp    $0x7e,%ebx
  800ca4:	7e 12                	jle    800cb8 <vprintfmt+0x207>
					putch('?', putdat);
  800ca6:	83 ec 08             	sub    $0x8,%esp
  800ca9:	ff 75 0c             	pushl  0xc(%ebp)
  800cac:	6a 3f                	push   $0x3f
  800cae:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb1:	ff d0                	call   *%eax
  800cb3:	83 c4 10             	add    $0x10,%esp
  800cb6:	eb 0f                	jmp    800cc7 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800cb8:	83 ec 08             	sub    $0x8,%esp
  800cbb:	ff 75 0c             	pushl  0xc(%ebp)
  800cbe:	53                   	push   %ebx
  800cbf:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc2:	ff d0                	call   *%eax
  800cc4:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800cc7:	ff 4d e4             	decl   -0x1c(%ebp)
  800cca:	89 f0                	mov    %esi,%eax
  800ccc:	8d 70 01             	lea    0x1(%eax),%esi
  800ccf:	8a 00                	mov    (%eax),%al
  800cd1:	0f be d8             	movsbl %al,%ebx
  800cd4:	85 db                	test   %ebx,%ebx
  800cd6:	74 24                	je     800cfc <vprintfmt+0x24b>
  800cd8:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800cdc:	78 b8                	js     800c96 <vprintfmt+0x1e5>
  800cde:	ff 4d e0             	decl   -0x20(%ebp)
  800ce1:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800ce5:	79 af                	jns    800c96 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800ce7:	eb 13                	jmp    800cfc <vprintfmt+0x24b>
				putch(' ', putdat);
  800ce9:	83 ec 08             	sub    $0x8,%esp
  800cec:	ff 75 0c             	pushl  0xc(%ebp)
  800cef:	6a 20                	push   $0x20
  800cf1:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf4:	ff d0                	call   *%eax
  800cf6:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800cf9:	ff 4d e4             	decl   -0x1c(%ebp)
  800cfc:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800d00:	7f e7                	jg     800ce9 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800d02:	e9 78 01 00 00       	jmp    800e7f <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800d07:	83 ec 08             	sub    $0x8,%esp
  800d0a:	ff 75 e8             	pushl  -0x18(%ebp)
  800d0d:	8d 45 14             	lea    0x14(%ebp),%eax
  800d10:	50                   	push   %eax
  800d11:	e8 3c fd ff ff       	call   800a52 <getint>
  800d16:	83 c4 10             	add    $0x10,%esp
  800d19:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800d1c:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800d1f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800d22:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800d25:	85 d2                	test   %edx,%edx
  800d27:	79 23                	jns    800d4c <vprintfmt+0x29b>
				putch('-', putdat);
  800d29:	83 ec 08             	sub    $0x8,%esp
  800d2c:	ff 75 0c             	pushl  0xc(%ebp)
  800d2f:	6a 2d                	push   $0x2d
  800d31:	8b 45 08             	mov    0x8(%ebp),%eax
  800d34:	ff d0                	call   *%eax
  800d36:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800d39:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800d3c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800d3f:	f7 d8                	neg    %eax
  800d41:	83 d2 00             	adc    $0x0,%edx
  800d44:	f7 da                	neg    %edx
  800d46:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800d49:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800d4c:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800d53:	e9 bc 00 00 00       	jmp    800e14 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800d58:	83 ec 08             	sub    $0x8,%esp
  800d5b:	ff 75 e8             	pushl  -0x18(%ebp)
  800d5e:	8d 45 14             	lea    0x14(%ebp),%eax
  800d61:	50                   	push   %eax
  800d62:	e8 84 fc ff ff       	call   8009eb <getuint>
  800d67:	83 c4 10             	add    $0x10,%esp
  800d6a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800d6d:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800d70:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800d77:	e9 98 00 00 00       	jmp    800e14 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800d7c:	83 ec 08             	sub    $0x8,%esp
  800d7f:	ff 75 0c             	pushl  0xc(%ebp)
  800d82:	6a 58                	push   $0x58
  800d84:	8b 45 08             	mov    0x8(%ebp),%eax
  800d87:	ff d0                	call   *%eax
  800d89:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800d8c:	83 ec 08             	sub    $0x8,%esp
  800d8f:	ff 75 0c             	pushl  0xc(%ebp)
  800d92:	6a 58                	push   $0x58
  800d94:	8b 45 08             	mov    0x8(%ebp),%eax
  800d97:	ff d0                	call   *%eax
  800d99:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800d9c:	83 ec 08             	sub    $0x8,%esp
  800d9f:	ff 75 0c             	pushl  0xc(%ebp)
  800da2:	6a 58                	push   $0x58
  800da4:	8b 45 08             	mov    0x8(%ebp),%eax
  800da7:	ff d0                	call   *%eax
  800da9:	83 c4 10             	add    $0x10,%esp
			break;
  800dac:	e9 ce 00 00 00       	jmp    800e7f <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800db1:	83 ec 08             	sub    $0x8,%esp
  800db4:	ff 75 0c             	pushl  0xc(%ebp)
  800db7:	6a 30                	push   $0x30
  800db9:	8b 45 08             	mov    0x8(%ebp),%eax
  800dbc:	ff d0                	call   *%eax
  800dbe:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800dc1:	83 ec 08             	sub    $0x8,%esp
  800dc4:	ff 75 0c             	pushl  0xc(%ebp)
  800dc7:	6a 78                	push   $0x78
  800dc9:	8b 45 08             	mov    0x8(%ebp),%eax
  800dcc:	ff d0                	call   *%eax
  800dce:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800dd1:	8b 45 14             	mov    0x14(%ebp),%eax
  800dd4:	83 c0 04             	add    $0x4,%eax
  800dd7:	89 45 14             	mov    %eax,0x14(%ebp)
  800dda:	8b 45 14             	mov    0x14(%ebp),%eax
  800ddd:	83 e8 04             	sub    $0x4,%eax
  800de0:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800de2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800de5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800dec:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800df3:	eb 1f                	jmp    800e14 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800df5:	83 ec 08             	sub    $0x8,%esp
  800df8:	ff 75 e8             	pushl  -0x18(%ebp)
  800dfb:	8d 45 14             	lea    0x14(%ebp),%eax
  800dfe:	50                   	push   %eax
  800dff:	e8 e7 fb ff ff       	call   8009eb <getuint>
  800e04:	83 c4 10             	add    $0x10,%esp
  800e07:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e0a:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800e0d:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800e14:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800e18:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800e1b:	83 ec 04             	sub    $0x4,%esp
  800e1e:	52                   	push   %edx
  800e1f:	ff 75 e4             	pushl  -0x1c(%ebp)
  800e22:	50                   	push   %eax
  800e23:	ff 75 f4             	pushl  -0xc(%ebp)
  800e26:	ff 75 f0             	pushl  -0x10(%ebp)
  800e29:	ff 75 0c             	pushl  0xc(%ebp)
  800e2c:	ff 75 08             	pushl  0x8(%ebp)
  800e2f:	e8 00 fb ff ff       	call   800934 <printnum>
  800e34:	83 c4 20             	add    $0x20,%esp
			break;
  800e37:	eb 46                	jmp    800e7f <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800e39:	83 ec 08             	sub    $0x8,%esp
  800e3c:	ff 75 0c             	pushl  0xc(%ebp)
  800e3f:	53                   	push   %ebx
  800e40:	8b 45 08             	mov    0x8(%ebp),%eax
  800e43:	ff d0                	call   *%eax
  800e45:	83 c4 10             	add    $0x10,%esp
			break;
  800e48:	eb 35                	jmp    800e7f <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800e4a:	c6 05 44 60 80 00 00 	movb   $0x0,0x806044
			break;
  800e51:	eb 2c                	jmp    800e7f <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800e53:	c6 05 44 60 80 00 01 	movb   $0x1,0x806044
			break;
  800e5a:	eb 23                	jmp    800e7f <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800e5c:	83 ec 08             	sub    $0x8,%esp
  800e5f:	ff 75 0c             	pushl  0xc(%ebp)
  800e62:	6a 25                	push   $0x25
  800e64:	8b 45 08             	mov    0x8(%ebp),%eax
  800e67:	ff d0                	call   *%eax
  800e69:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800e6c:	ff 4d 10             	decl   0x10(%ebp)
  800e6f:	eb 03                	jmp    800e74 <vprintfmt+0x3c3>
  800e71:	ff 4d 10             	decl   0x10(%ebp)
  800e74:	8b 45 10             	mov    0x10(%ebp),%eax
  800e77:	48                   	dec    %eax
  800e78:	8a 00                	mov    (%eax),%al
  800e7a:	3c 25                	cmp    $0x25,%al
  800e7c:	75 f3                	jne    800e71 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800e7e:	90                   	nop
		}
	}
  800e7f:	e9 35 fc ff ff       	jmp    800ab9 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800e84:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800e85:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800e88:	5b                   	pop    %ebx
  800e89:	5e                   	pop    %esi
  800e8a:	5d                   	pop    %ebp
  800e8b:	c3                   	ret    

00800e8c <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800e8c:	55                   	push   %ebp
  800e8d:	89 e5                	mov    %esp,%ebp
  800e8f:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800e92:	8d 45 10             	lea    0x10(%ebp),%eax
  800e95:	83 c0 04             	add    $0x4,%eax
  800e98:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800e9b:	8b 45 10             	mov    0x10(%ebp),%eax
  800e9e:	ff 75 f4             	pushl  -0xc(%ebp)
  800ea1:	50                   	push   %eax
  800ea2:	ff 75 0c             	pushl  0xc(%ebp)
  800ea5:	ff 75 08             	pushl  0x8(%ebp)
  800ea8:	e8 04 fc ff ff       	call   800ab1 <vprintfmt>
  800ead:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800eb0:	90                   	nop
  800eb1:	c9                   	leave  
  800eb2:	c3                   	ret    

00800eb3 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800eb3:	55                   	push   %ebp
  800eb4:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800eb6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eb9:	8b 40 08             	mov    0x8(%eax),%eax
  800ebc:	8d 50 01             	lea    0x1(%eax),%edx
  800ebf:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ec2:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800ec5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ec8:	8b 10                	mov    (%eax),%edx
  800eca:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ecd:	8b 40 04             	mov    0x4(%eax),%eax
  800ed0:	39 c2                	cmp    %eax,%edx
  800ed2:	73 12                	jae    800ee6 <sprintputch+0x33>
		*b->buf++ = ch;
  800ed4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ed7:	8b 00                	mov    (%eax),%eax
  800ed9:	8d 48 01             	lea    0x1(%eax),%ecx
  800edc:	8b 55 0c             	mov    0xc(%ebp),%edx
  800edf:	89 0a                	mov    %ecx,(%edx)
  800ee1:	8b 55 08             	mov    0x8(%ebp),%edx
  800ee4:	88 10                	mov    %dl,(%eax)
}
  800ee6:	90                   	nop
  800ee7:	5d                   	pop    %ebp
  800ee8:	c3                   	ret    

00800ee9 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800ee9:	55                   	push   %ebp
  800eea:	89 e5                	mov    %esp,%ebp
  800eec:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800eef:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef2:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800ef5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ef8:	8d 50 ff             	lea    -0x1(%eax),%edx
  800efb:	8b 45 08             	mov    0x8(%ebp),%eax
  800efe:	01 d0                	add    %edx,%eax
  800f00:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f03:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800f0a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800f0e:	74 06                	je     800f16 <vsnprintf+0x2d>
  800f10:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800f14:	7f 07                	jg     800f1d <vsnprintf+0x34>
		return -E_INVAL;
  800f16:	b8 03 00 00 00       	mov    $0x3,%eax
  800f1b:	eb 20                	jmp    800f3d <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800f1d:	ff 75 14             	pushl  0x14(%ebp)
  800f20:	ff 75 10             	pushl  0x10(%ebp)
  800f23:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800f26:	50                   	push   %eax
  800f27:	68 b3 0e 80 00       	push   $0x800eb3
  800f2c:	e8 80 fb ff ff       	call   800ab1 <vprintfmt>
  800f31:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800f34:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800f37:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800f3a:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800f3d:	c9                   	leave  
  800f3e:	c3                   	ret    

00800f3f <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800f3f:	55                   	push   %ebp
  800f40:	89 e5                	mov    %esp,%ebp
  800f42:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800f45:	8d 45 10             	lea    0x10(%ebp),%eax
  800f48:	83 c0 04             	add    $0x4,%eax
  800f4b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800f4e:	8b 45 10             	mov    0x10(%ebp),%eax
  800f51:	ff 75 f4             	pushl  -0xc(%ebp)
  800f54:	50                   	push   %eax
  800f55:	ff 75 0c             	pushl  0xc(%ebp)
  800f58:	ff 75 08             	pushl  0x8(%ebp)
  800f5b:	e8 89 ff ff ff       	call   800ee9 <vsnprintf>
  800f60:	83 c4 10             	add    $0x10,%esp
  800f63:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800f66:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800f69:	c9                   	leave  
  800f6a:	c3                   	ret    

00800f6b <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800f6b:	55                   	push   %ebp
  800f6c:	89 e5                	mov    %esp,%ebp
  800f6e:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800f71:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800f78:	eb 06                	jmp    800f80 <strlen+0x15>
		n++;
  800f7a:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800f7d:	ff 45 08             	incl   0x8(%ebp)
  800f80:	8b 45 08             	mov    0x8(%ebp),%eax
  800f83:	8a 00                	mov    (%eax),%al
  800f85:	84 c0                	test   %al,%al
  800f87:	75 f1                	jne    800f7a <strlen+0xf>
		n++;
	return n;
  800f89:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800f8c:	c9                   	leave  
  800f8d:	c3                   	ret    

00800f8e <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800f8e:	55                   	push   %ebp
  800f8f:	89 e5                	mov    %esp,%ebp
  800f91:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800f94:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800f9b:	eb 09                	jmp    800fa6 <strnlen+0x18>
		n++;
  800f9d:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800fa0:	ff 45 08             	incl   0x8(%ebp)
  800fa3:	ff 4d 0c             	decl   0xc(%ebp)
  800fa6:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800faa:	74 09                	je     800fb5 <strnlen+0x27>
  800fac:	8b 45 08             	mov    0x8(%ebp),%eax
  800faf:	8a 00                	mov    (%eax),%al
  800fb1:	84 c0                	test   %al,%al
  800fb3:	75 e8                	jne    800f9d <strnlen+0xf>
		n++;
	return n;
  800fb5:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800fb8:	c9                   	leave  
  800fb9:	c3                   	ret    

00800fba <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800fba:	55                   	push   %ebp
  800fbb:	89 e5                	mov    %esp,%ebp
  800fbd:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800fc0:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800fc6:	90                   	nop
  800fc7:	8b 45 08             	mov    0x8(%ebp),%eax
  800fca:	8d 50 01             	lea    0x1(%eax),%edx
  800fcd:	89 55 08             	mov    %edx,0x8(%ebp)
  800fd0:	8b 55 0c             	mov    0xc(%ebp),%edx
  800fd3:	8d 4a 01             	lea    0x1(%edx),%ecx
  800fd6:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800fd9:	8a 12                	mov    (%edx),%dl
  800fdb:	88 10                	mov    %dl,(%eax)
  800fdd:	8a 00                	mov    (%eax),%al
  800fdf:	84 c0                	test   %al,%al
  800fe1:	75 e4                	jne    800fc7 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800fe3:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800fe6:	c9                   	leave  
  800fe7:	c3                   	ret    

00800fe8 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800fe8:	55                   	push   %ebp
  800fe9:	89 e5                	mov    %esp,%ebp
  800feb:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800fee:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff1:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800ff4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800ffb:	eb 1f                	jmp    80101c <strncpy+0x34>
		*dst++ = *src;
  800ffd:	8b 45 08             	mov    0x8(%ebp),%eax
  801000:	8d 50 01             	lea    0x1(%eax),%edx
  801003:	89 55 08             	mov    %edx,0x8(%ebp)
  801006:	8b 55 0c             	mov    0xc(%ebp),%edx
  801009:	8a 12                	mov    (%edx),%dl
  80100b:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  80100d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801010:	8a 00                	mov    (%eax),%al
  801012:	84 c0                	test   %al,%al
  801014:	74 03                	je     801019 <strncpy+0x31>
			src++;
  801016:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801019:	ff 45 fc             	incl   -0x4(%ebp)
  80101c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80101f:	3b 45 10             	cmp    0x10(%ebp),%eax
  801022:	72 d9                	jb     800ffd <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801024:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801027:	c9                   	leave  
  801028:	c3                   	ret    

00801029 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  801029:	55                   	push   %ebp
  80102a:	89 e5                	mov    %esp,%ebp
  80102c:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  80102f:	8b 45 08             	mov    0x8(%ebp),%eax
  801032:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  801035:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801039:	74 30                	je     80106b <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  80103b:	eb 16                	jmp    801053 <strlcpy+0x2a>
			*dst++ = *src++;
  80103d:	8b 45 08             	mov    0x8(%ebp),%eax
  801040:	8d 50 01             	lea    0x1(%eax),%edx
  801043:	89 55 08             	mov    %edx,0x8(%ebp)
  801046:	8b 55 0c             	mov    0xc(%ebp),%edx
  801049:	8d 4a 01             	lea    0x1(%edx),%ecx
  80104c:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  80104f:	8a 12                	mov    (%edx),%dl
  801051:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801053:	ff 4d 10             	decl   0x10(%ebp)
  801056:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80105a:	74 09                	je     801065 <strlcpy+0x3c>
  80105c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80105f:	8a 00                	mov    (%eax),%al
  801061:	84 c0                	test   %al,%al
  801063:	75 d8                	jne    80103d <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  801065:	8b 45 08             	mov    0x8(%ebp),%eax
  801068:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  80106b:	8b 55 08             	mov    0x8(%ebp),%edx
  80106e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801071:	29 c2                	sub    %eax,%edx
  801073:	89 d0                	mov    %edx,%eax
}
  801075:	c9                   	leave  
  801076:	c3                   	ret    

00801077 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801077:	55                   	push   %ebp
  801078:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  80107a:	eb 06                	jmp    801082 <strcmp+0xb>
		p++, q++;
  80107c:	ff 45 08             	incl   0x8(%ebp)
  80107f:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801082:	8b 45 08             	mov    0x8(%ebp),%eax
  801085:	8a 00                	mov    (%eax),%al
  801087:	84 c0                	test   %al,%al
  801089:	74 0e                	je     801099 <strcmp+0x22>
  80108b:	8b 45 08             	mov    0x8(%ebp),%eax
  80108e:	8a 10                	mov    (%eax),%dl
  801090:	8b 45 0c             	mov    0xc(%ebp),%eax
  801093:	8a 00                	mov    (%eax),%al
  801095:	38 c2                	cmp    %al,%dl
  801097:	74 e3                	je     80107c <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801099:	8b 45 08             	mov    0x8(%ebp),%eax
  80109c:	8a 00                	mov    (%eax),%al
  80109e:	0f b6 d0             	movzbl %al,%edx
  8010a1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010a4:	8a 00                	mov    (%eax),%al
  8010a6:	0f b6 c0             	movzbl %al,%eax
  8010a9:	29 c2                	sub    %eax,%edx
  8010ab:	89 d0                	mov    %edx,%eax
}
  8010ad:	5d                   	pop    %ebp
  8010ae:	c3                   	ret    

008010af <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  8010af:	55                   	push   %ebp
  8010b0:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  8010b2:	eb 09                	jmp    8010bd <strncmp+0xe>
		n--, p++, q++;
  8010b4:	ff 4d 10             	decl   0x10(%ebp)
  8010b7:	ff 45 08             	incl   0x8(%ebp)
  8010ba:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  8010bd:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010c1:	74 17                	je     8010da <strncmp+0x2b>
  8010c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c6:	8a 00                	mov    (%eax),%al
  8010c8:	84 c0                	test   %al,%al
  8010ca:	74 0e                	je     8010da <strncmp+0x2b>
  8010cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8010cf:	8a 10                	mov    (%eax),%dl
  8010d1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010d4:	8a 00                	mov    (%eax),%al
  8010d6:	38 c2                	cmp    %al,%dl
  8010d8:	74 da                	je     8010b4 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  8010da:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010de:	75 07                	jne    8010e7 <strncmp+0x38>
		return 0;
  8010e0:	b8 00 00 00 00       	mov    $0x0,%eax
  8010e5:	eb 14                	jmp    8010fb <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8010e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ea:	8a 00                	mov    (%eax),%al
  8010ec:	0f b6 d0             	movzbl %al,%edx
  8010ef:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010f2:	8a 00                	mov    (%eax),%al
  8010f4:	0f b6 c0             	movzbl %al,%eax
  8010f7:	29 c2                	sub    %eax,%edx
  8010f9:	89 d0                	mov    %edx,%eax
}
  8010fb:	5d                   	pop    %ebp
  8010fc:	c3                   	ret    

008010fd <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8010fd:	55                   	push   %ebp
  8010fe:	89 e5                	mov    %esp,%ebp
  801100:	83 ec 04             	sub    $0x4,%esp
  801103:	8b 45 0c             	mov    0xc(%ebp),%eax
  801106:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801109:	eb 12                	jmp    80111d <strchr+0x20>
		if (*s == c)
  80110b:	8b 45 08             	mov    0x8(%ebp),%eax
  80110e:	8a 00                	mov    (%eax),%al
  801110:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801113:	75 05                	jne    80111a <strchr+0x1d>
			return (char *) s;
  801115:	8b 45 08             	mov    0x8(%ebp),%eax
  801118:	eb 11                	jmp    80112b <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  80111a:	ff 45 08             	incl   0x8(%ebp)
  80111d:	8b 45 08             	mov    0x8(%ebp),%eax
  801120:	8a 00                	mov    (%eax),%al
  801122:	84 c0                	test   %al,%al
  801124:	75 e5                	jne    80110b <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  801126:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80112b:	c9                   	leave  
  80112c:	c3                   	ret    

0080112d <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80112d:	55                   	push   %ebp
  80112e:	89 e5                	mov    %esp,%ebp
  801130:	83 ec 04             	sub    $0x4,%esp
  801133:	8b 45 0c             	mov    0xc(%ebp),%eax
  801136:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801139:	eb 0d                	jmp    801148 <strfind+0x1b>
		if (*s == c)
  80113b:	8b 45 08             	mov    0x8(%ebp),%eax
  80113e:	8a 00                	mov    (%eax),%al
  801140:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801143:	74 0e                	je     801153 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801145:	ff 45 08             	incl   0x8(%ebp)
  801148:	8b 45 08             	mov    0x8(%ebp),%eax
  80114b:	8a 00                	mov    (%eax),%al
  80114d:	84 c0                	test   %al,%al
  80114f:	75 ea                	jne    80113b <strfind+0xe>
  801151:	eb 01                	jmp    801154 <strfind+0x27>
		if (*s == c)
			break;
  801153:	90                   	nop
	return (char *) s;
  801154:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801157:	c9                   	leave  
  801158:	c3                   	ret    

00801159 <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  801159:	55                   	push   %ebp
  80115a:	89 e5                	mov    %esp,%ebp
  80115c:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  80115f:	8b 45 08             	mov    0x8(%ebp),%eax
  801162:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  801165:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801169:	76 63                	jbe    8011ce <memset+0x75>
		uint64 data_block = c;
  80116b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80116e:	99                   	cltd   
  80116f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801172:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  801175:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801178:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80117b:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  80117f:	c1 e0 08             	shl    $0x8,%eax
  801182:	09 45 f0             	or     %eax,-0x10(%ebp)
  801185:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  801188:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80118b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80118e:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  801192:	c1 e0 10             	shl    $0x10,%eax
  801195:	09 45 f0             	or     %eax,-0x10(%ebp)
  801198:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  80119b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80119e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8011a1:	89 c2                	mov    %eax,%edx
  8011a3:	b8 00 00 00 00       	mov    $0x0,%eax
  8011a8:	09 45 f0             	or     %eax,-0x10(%ebp)
  8011ab:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  8011ae:	eb 18                	jmp    8011c8 <memset+0x6f>
			*p64++ = data_block, n -= 8;
  8011b0:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8011b3:	8d 41 08             	lea    0x8(%ecx),%eax
  8011b6:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8011b9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8011bc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8011bf:	89 01                	mov    %eax,(%ecx)
  8011c1:	89 51 04             	mov    %edx,0x4(%ecx)
  8011c4:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  8011c8:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  8011cc:	77 e2                	ja     8011b0 <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  8011ce:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8011d2:	74 23                	je     8011f7 <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  8011d4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011d7:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  8011da:	eb 0e                	jmp    8011ea <memset+0x91>
			*p8++ = (uint8)c;
  8011dc:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011df:	8d 50 01             	lea    0x1(%eax),%edx
  8011e2:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8011e5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8011e8:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  8011ea:	8b 45 10             	mov    0x10(%ebp),%eax
  8011ed:	8d 50 ff             	lea    -0x1(%eax),%edx
  8011f0:	89 55 10             	mov    %edx,0x10(%ebp)
  8011f3:	85 c0                	test   %eax,%eax
  8011f5:	75 e5                	jne    8011dc <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  8011f7:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8011fa:	c9                   	leave  
  8011fb:	c3                   	ret    

008011fc <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  8011fc:	55                   	push   %ebp
  8011fd:	89 e5                	mov    %esp,%ebp
  8011ff:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  801202:	8b 45 0c             	mov    0xc(%ebp),%eax
  801205:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  801208:	8b 45 08             	mov    0x8(%ebp),%eax
  80120b:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  80120e:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801212:	76 24                	jbe    801238 <memcpy+0x3c>
		while(n >= 8){
  801214:	eb 1c                	jmp    801232 <memcpy+0x36>
			*d64 = *s64;
  801216:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801219:	8b 50 04             	mov    0x4(%eax),%edx
  80121c:	8b 00                	mov    (%eax),%eax
  80121e:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801221:	89 01                	mov    %eax,(%ecx)
  801223:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  801226:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  80122a:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  80122e:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  801232:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801236:	77 de                	ja     801216 <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  801238:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80123c:	74 31                	je     80126f <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  80123e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801241:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  801244:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801247:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  80124a:	eb 16                	jmp    801262 <memcpy+0x66>
			*d8++ = *s8++;
  80124c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80124f:	8d 50 01             	lea    0x1(%eax),%edx
  801252:	89 55 f0             	mov    %edx,-0x10(%ebp)
  801255:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801258:	8d 4a 01             	lea    0x1(%edx),%ecx
  80125b:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  80125e:	8a 12                	mov    (%edx),%dl
  801260:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  801262:	8b 45 10             	mov    0x10(%ebp),%eax
  801265:	8d 50 ff             	lea    -0x1(%eax),%edx
  801268:	89 55 10             	mov    %edx,0x10(%ebp)
  80126b:	85 c0                	test   %eax,%eax
  80126d:	75 dd                	jne    80124c <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  80126f:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801272:	c9                   	leave  
  801273:	c3                   	ret    

00801274 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801274:	55                   	push   %ebp
  801275:	89 e5                	mov    %esp,%ebp
  801277:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  80127a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80127d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801280:	8b 45 08             	mov    0x8(%ebp),%eax
  801283:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801286:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801289:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80128c:	73 50                	jae    8012de <memmove+0x6a>
  80128e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801291:	8b 45 10             	mov    0x10(%ebp),%eax
  801294:	01 d0                	add    %edx,%eax
  801296:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801299:	76 43                	jbe    8012de <memmove+0x6a>
		s += n;
  80129b:	8b 45 10             	mov    0x10(%ebp),%eax
  80129e:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  8012a1:	8b 45 10             	mov    0x10(%ebp),%eax
  8012a4:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  8012a7:	eb 10                	jmp    8012b9 <memmove+0x45>
			*--d = *--s;
  8012a9:	ff 4d f8             	decl   -0x8(%ebp)
  8012ac:	ff 4d fc             	decl   -0x4(%ebp)
  8012af:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012b2:	8a 10                	mov    (%eax),%dl
  8012b4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012b7:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  8012b9:	8b 45 10             	mov    0x10(%ebp),%eax
  8012bc:	8d 50 ff             	lea    -0x1(%eax),%edx
  8012bf:	89 55 10             	mov    %edx,0x10(%ebp)
  8012c2:	85 c0                	test   %eax,%eax
  8012c4:	75 e3                	jne    8012a9 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8012c6:	eb 23                	jmp    8012eb <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  8012c8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012cb:	8d 50 01             	lea    0x1(%eax),%edx
  8012ce:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8012d1:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8012d4:	8d 4a 01             	lea    0x1(%edx),%ecx
  8012d7:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8012da:	8a 12                	mov    (%edx),%dl
  8012dc:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  8012de:	8b 45 10             	mov    0x10(%ebp),%eax
  8012e1:	8d 50 ff             	lea    -0x1(%eax),%edx
  8012e4:	89 55 10             	mov    %edx,0x10(%ebp)
  8012e7:	85 c0                	test   %eax,%eax
  8012e9:	75 dd                	jne    8012c8 <memmove+0x54>
			*d++ = *s++;

	return dst;
  8012eb:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8012ee:	c9                   	leave  
  8012ef:	c3                   	ret    

008012f0 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8012f0:	55                   	push   %ebp
  8012f1:	89 e5                	mov    %esp,%ebp
  8012f3:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  8012f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8012f9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  8012fc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012ff:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  801302:	eb 2a                	jmp    80132e <memcmp+0x3e>
		if (*s1 != *s2)
  801304:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801307:	8a 10                	mov    (%eax),%dl
  801309:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80130c:	8a 00                	mov    (%eax),%al
  80130e:	38 c2                	cmp    %al,%dl
  801310:	74 16                	je     801328 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801312:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801315:	8a 00                	mov    (%eax),%al
  801317:	0f b6 d0             	movzbl %al,%edx
  80131a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80131d:	8a 00                	mov    (%eax),%al
  80131f:	0f b6 c0             	movzbl %al,%eax
  801322:	29 c2                	sub    %eax,%edx
  801324:	89 d0                	mov    %edx,%eax
  801326:	eb 18                	jmp    801340 <memcmp+0x50>
		s1++, s2++;
  801328:	ff 45 fc             	incl   -0x4(%ebp)
  80132b:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  80132e:	8b 45 10             	mov    0x10(%ebp),%eax
  801331:	8d 50 ff             	lea    -0x1(%eax),%edx
  801334:	89 55 10             	mov    %edx,0x10(%ebp)
  801337:	85 c0                	test   %eax,%eax
  801339:	75 c9                	jne    801304 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  80133b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801340:	c9                   	leave  
  801341:	c3                   	ret    

00801342 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801342:	55                   	push   %ebp
  801343:	89 e5                	mov    %esp,%ebp
  801345:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801348:	8b 55 08             	mov    0x8(%ebp),%edx
  80134b:	8b 45 10             	mov    0x10(%ebp),%eax
  80134e:	01 d0                	add    %edx,%eax
  801350:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801353:	eb 15                	jmp    80136a <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801355:	8b 45 08             	mov    0x8(%ebp),%eax
  801358:	8a 00                	mov    (%eax),%al
  80135a:	0f b6 d0             	movzbl %al,%edx
  80135d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801360:	0f b6 c0             	movzbl %al,%eax
  801363:	39 c2                	cmp    %eax,%edx
  801365:	74 0d                	je     801374 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801367:	ff 45 08             	incl   0x8(%ebp)
  80136a:	8b 45 08             	mov    0x8(%ebp),%eax
  80136d:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801370:	72 e3                	jb     801355 <memfind+0x13>
  801372:	eb 01                	jmp    801375 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801374:	90                   	nop
	return (void *) s;
  801375:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801378:	c9                   	leave  
  801379:	c3                   	ret    

0080137a <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80137a:	55                   	push   %ebp
  80137b:	89 e5                	mov    %esp,%ebp
  80137d:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801380:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801387:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80138e:	eb 03                	jmp    801393 <strtol+0x19>
		s++;
  801390:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801393:	8b 45 08             	mov    0x8(%ebp),%eax
  801396:	8a 00                	mov    (%eax),%al
  801398:	3c 20                	cmp    $0x20,%al
  80139a:	74 f4                	je     801390 <strtol+0x16>
  80139c:	8b 45 08             	mov    0x8(%ebp),%eax
  80139f:	8a 00                	mov    (%eax),%al
  8013a1:	3c 09                	cmp    $0x9,%al
  8013a3:	74 eb                	je     801390 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  8013a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8013a8:	8a 00                	mov    (%eax),%al
  8013aa:	3c 2b                	cmp    $0x2b,%al
  8013ac:	75 05                	jne    8013b3 <strtol+0x39>
		s++;
  8013ae:	ff 45 08             	incl   0x8(%ebp)
  8013b1:	eb 13                	jmp    8013c6 <strtol+0x4c>
	else if (*s == '-')
  8013b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8013b6:	8a 00                	mov    (%eax),%al
  8013b8:	3c 2d                	cmp    $0x2d,%al
  8013ba:	75 0a                	jne    8013c6 <strtol+0x4c>
		s++, neg = 1;
  8013bc:	ff 45 08             	incl   0x8(%ebp)
  8013bf:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8013c6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8013ca:	74 06                	je     8013d2 <strtol+0x58>
  8013cc:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8013d0:	75 20                	jne    8013f2 <strtol+0x78>
  8013d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8013d5:	8a 00                	mov    (%eax),%al
  8013d7:	3c 30                	cmp    $0x30,%al
  8013d9:	75 17                	jne    8013f2 <strtol+0x78>
  8013db:	8b 45 08             	mov    0x8(%ebp),%eax
  8013de:	40                   	inc    %eax
  8013df:	8a 00                	mov    (%eax),%al
  8013e1:	3c 78                	cmp    $0x78,%al
  8013e3:	75 0d                	jne    8013f2 <strtol+0x78>
		s += 2, base = 16;
  8013e5:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8013e9:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8013f0:	eb 28                	jmp    80141a <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8013f2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8013f6:	75 15                	jne    80140d <strtol+0x93>
  8013f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8013fb:	8a 00                	mov    (%eax),%al
  8013fd:	3c 30                	cmp    $0x30,%al
  8013ff:	75 0c                	jne    80140d <strtol+0x93>
		s++, base = 8;
  801401:	ff 45 08             	incl   0x8(%ebp)
  801404:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  80140b:	eb 0d                	jmp    80141a <strtol+0xa0>
	else if (base == 0)
  80140d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801411:	75 07                	jne    80141a <strtol+0xa0>
		base = 10;
  801413:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  80141a:	8b 45 08             	mov    0x8(%ebp),%eax
  80141d:	8a 00                	mov    (%eax),%al
  80141f:	3c 2f                	cmp    $0x2f,%al
  801421:	7e 19                	jle    80143c <strtol+0xc2>
  801423:	8b 45 08             	mov    0x8(%ebp),%eax
  801426:	8a 00                	mov    (%eax),%al
  801428:	3c 39                	cmp    $0x39,%al
  80142a:	7f 10                	jg     80143c <strtol+0xc2>
			dig = *s - '0';
  80142c:	8b 45 08             	mov    0x8(%ebp),%eax
  80142f:	8a 00                	mov    (%eax),%al
  801431:	0f be c0             	movsbl %al,%eax
  801434:	83 e8 30             	sub    $0x30,%eax
  801437:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80143a:	eb 42                	jmp    80147e <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  80143c:	8b 45 08             	mov    0x8(%ebp),%eax
  80143f:	8a 00                	mov    (%eax),%al
  801441:	3c 60                	cmp    $0x60,%al
  801443:	7e 19                	jle    80145e <strtol+0xe4>
  801445:	8b 45 08             	mov    0x8(%ebp),%eax
  801448:	8a 00                	mov    (%eax),%al
  80144a:	3c 7a                	cmp    $0x7a,%al
  80144c:	7f 10                	jg     80145e <strtol+0xe4>
			dig = *s - 'a' + 10;
  80144e:	8b 45 08             	mov    0x8(%ebp),%eax
  801451:	8a 00                	mov    (%eax),%al
  801453:	0f be c0             	movsbl %al,%eax
  801456:	83 e8 57             	sub    $0x57,%eax
  801459:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80145c:	eb 20                	jmp    80147e <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  80145e:	8b 45 08             	mov    0x8(%ebp),%eax
  801461:	8a 00                	mov    (%eax),%al
  801463:	3c 40                	cmp    $0x40,%al
  801465:	7e 39                	jle    8014a0 <strtol+0x126>
  801467:	8b 45 08             	mov    0x8(%ebp),%eax
  80146a:	8a 00                	mov    (%eax),%al
  80146c:	3c 5a                	cmp    $0x5a,%al
  80146e:	7f 30                	jg     8014a0 <strtol+0x126>
			dig = *s - 'A' + 10;
  801470:	8b 45 08             	mov    0x8(%ebp),%eax
  801473:	8a 00                	mov    (%eax),%al
  801475:	0f be c0             	movsbl %al,%eax
  801478:	83 e8 37             	sub    $0x37,%eax
  80147b:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  80147e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801481:	3b 45 10             	cmp    0x10(%ebp),%eax
  801484:	7d 19                	jge    80149f <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801486:	ff 45 08             	incl   0x8(%ebp)
  801489:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80148c:	0f af 45 10          	imul   0x10(%ebp),%eax
  801490:	89 c2                	mov    %eax,%edx
  801492:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801495:	01 d0                	add    %edx,%eax
  801497:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  80149a:	e9 7b ff ff ff       	jmp    80141a <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  80149f:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8014a0:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8014a4:	74 08                	je     8014ae <strtol+0x134>
		*endptr = (char *) s;
  8014a6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014a9:	8b 55 08             	mov    0x8(%ebp),%edx
  8014ac:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8014ae:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8014b2:	74 07                	je     8014bb <strtol+0x141>
  8014b4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8014b7:	f7 d8                	neg    %eax
  8014b9:	eb 03                	jmp    8014be <strtol+0x144>
  8014bb:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8014be:	c9                   	leave  
  8014bf:	c3                   	ret    

008014c0 <ltostr>:

void
ltostr(long value, char *str)
{
  8014c0:	55                   	push   %ebp
  8014c1:	89 e5                	mov    %esp,%ebp
  8014c3:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8014c6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8014cd:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8014d4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8014d8:	79 13                	jns    8014ed <ltostr+0x2d>
	{
		neg = 1;
  8014da:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8014e1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014e4:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8014e7:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8014ea:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8014ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8014f0:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8014f5:	99                   	cltd   
  8014f6:	f7 f9                	idiv   %ecx
  8014f8:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8014fb:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8014fe:	8d 50 01             	lea    0x1(%eax),%edx
  801501:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801504:	89 c2                	mov    %eax,%edx
  801506:	8b 45 0c             	mov    0xc(%ebp),%eax
  801509:	01 d0                	add    %edx,%eax
  80150b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80150e:	83 c2 30             	add    $0x30,%edx
  801511:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801513:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801516:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80151b:	f7 e9                	imul   %ecx
  80151d:	c1 fa 02             	sar    $0x2,%edx
  801520:	89 c8                	mov    %ecx,%eax
  801522:	c1 f8 1f             	sar    $0x1f,%eax
  801525:	29 c2                	sub    %eax,%edx
  801527:	89 d0                	mov    %edx,%eax
  801529:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  80152c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801530:	75 bb                	jne    8014ed <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801532:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801539:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80153c:	48                   	dec    %eax
  80153d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801540:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801544:	74 3d                	je     801583 <ltostr+0xc3>
		start = 1 ;
  801546:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  80154d:	eb 34                	jmp    801583 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  80154f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801552:	8b 45 0c             	mov    0xc(%ebp),%eax
  801555:	01 d0                	add    %edx,%eax
  801557:	8a 00                	mov    (%eax),%al
  801559:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  80155c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80155f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801562:	01 c2                	add    %eax,%edx
  801564:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801567:	8b 45 0c             	mov    0xc(%ebp),%eax
  80156a:	01 c8                	add    %ecx,%eax
  80156c:	8a 00                	mov    (%eax),%al
  80156e:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801570:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801573:	8b 45 0c             	mov    0xc(%ebp),%eax
  801576:	01 c2                	add    %eax,%edx
  801578:	8a 45 eb             	mov    -0x15(%ebp),%al
  80157b:	88 02                	mov    %al,(%edx)
		start++ ;
  80157d:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801580:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801583:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801586:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801589:	7c c4                	jl     80154f <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  80158b:	8b 55 f8             	mov    -0x8(%ebp),%edx
  80158e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801591:	01 d0                	add    %edx,%eax
  801593:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801596:	90                   	nop
  801597:	c9                   	leave  
  801598:	c3                   	ret    

00801599 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801599:	55                   	push   %ebp
  80159a:	89 e5                	mov    %esp,%ebp
  80159c:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  80159f:	ff 75 08             	pushl  0x8(%ebp)
  8015a2:	e8 c4 f9 ff ff       	call   800f6b <strlen>
  8015a7:	83 c4 04             	add    $0x4,%esp
  8015aa:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8015ad:	ff 75 0c             	pushl  0xc(%ebp)
  8015b0:	e8 b6 f9 ff ff       	call   800f6b <strlen>
  8015b5:	83 c4 04             	add    $0x4,%esp
  8015b8:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8015bb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8015c2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8015c9:	eb 17                	jmp    8015e2 <strcconcat+0x49>
		final[s] = str1[s] ;
  8015cb:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8015ce:	8b 45 10             	mov    0x10(%ebp),%eax
  8015d1:	01 c2                	add    %eax,%edx
  8015d3:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8015d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8015d9:	01 c8                	add    %ecx,%eax
  8015db:	8a 00                	mov    (%eax),%al
  8015dd:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8015df:	ff 45 fc             	incl   -0x4(%ebp)
  8015e2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8015e5:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8015e8:	7c e1                	jl     8015cb <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8015ea:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8015f1:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8015f8:	eb 1f                	jmp    801619 <strcconcat+0x80>
		final[s++] = str2[i] ;
  8015fa:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8015fd:	8d 50 01             	lea    0x1(%eax),%edx
  801600:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801603:	89 c2                	mov    %eax,%edx
  801605:	8b 45 10             	mov    0x10(%ebp),%eax
  801608:	01 c2                	add    %eax,%edx
  80160a:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  80160d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801610:	01 c8                	add    %ecx,%eax
  801612:	8a 00                	mov    (%eax),%al
  801614:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801616:	ff 45 f8             	incl   -0x8(%ebp)
  801619:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80161c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80161f:	7c d9                	jl     8015fa <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801621:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801624:	8b 45 10             	mov    0x10(%ebp),%eax
  801627:	01 d0                	add    %edx,%eax
  801629:	c6 00 00             	movb   $0x0,(%eax)
}
  80162c:	90                   	nop
  80162d:	c9                   	leave  
  80162e:	c3                   	ret    

0080162f <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  80162f:	55                   	push   %ebp
  801630:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801632:	8b 45 14             	mov    0x14(%ebp),%eax
  801635:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  80163b:	8b 45 14             	mov    0x14(%ebp),%eax
  80163e:	8b 00                	mov    (%eax),%eax
  801640:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801647:	8b 45 10             	mov    0x10(%ebp),%eax
  80164a:	01 d0                	add    %edx,%eax
  80164c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801652:	eb 0c                	jmp    801660 <strsplit+0x31>
			*string++ = 0;
  801654:	8b 45 08             	mov    0x8(%ebp),%eax
  801657:	8d 50 01             	lea    0x1(%eax),%edx
  80165a:	89 55 08             	mov    %edx,0x8(%ebp)
  80165d:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801660:	8b 45 08             	mov    0x8(%ebp),%eax
  801663:	8a 00                	mov    (%eax),%al
  801665:	84 c0                	test   %al,%al
  801667:	74 18                	je     801681 <strsplit+0x52>
  801669:	8b 45 08             	mov    0x8(%ebp),%eax
  80166c:	8a 00                	mov    (%eax),%al
  80166e:	0f be c0             	movsbl %al,%eax
  801671:	50                   	push   %eax
  801672:	ff 75 0c             	pushl  0xc(%ebp)
  801675:	e8 83 fa ff ff       	call   8010fd <strchr>
  80167a:	83 c4 08             	add    $0x8,%esp
  80167d:	85 c0                	test   %eax,%eax
  80167f:	75 d3                	jne    801654 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801681:	8b 45 08             	mov    0x8(%ebp),%eax
  801684:	8a 00                	mov    (%eax),%al
  801686:	84 c0                	test   %al,%al
  801688:	74 5a                	je     8016e4 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  80168a:	8b 45 14             	mov    0x14(%ebp),%eax
  80168d:	8b 00                	mov    (%eax),%eax
  80168f:	83 f8 0f             	cmp    $0xf,%eax
  801692:	75 07                	jne    80169b <strsplit+0x6c>
		{
			return 0;
  801694:	b8 00 00 00 00       	mov    $0x0,%eax
  801699:	eb 66                	jmp    801701 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  80169b:	8b 45 14             	mov    0x14(%ebp),%eax
  80169e:	8b 00                	mov    (%eax),%eax
  8016a0:	8d 48 01             	lea    0x1(%eax),%ecx
  8016a3:	8b 55 14             	mov    0x14(%ebp),%edx
  8016a6:	89 0a                	mov    %ecx,(%edx)
  8016a8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8016af:	8b 45 10             	mov    0x10(%ebp),%eax
  8016b2:	01 c2                	add    %eax,%edx
  8016b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8016b7:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8016b9:	eb 03                	jmp    8016be <strsplit+0x8f>
			string++;
  8016bb:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8016be:	8b 45 08             	mov    0x8(%ebp),%eax
  8016c1:	8a 00                	mov    (%eax),%al
  8016c3:	84 c0                	test   %al,%al
  8016c5:	74 8b                	je     801652 <strsplit+0x23>
  8016c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8016ca:	8a 00                	mov    (%eax),%al
  8016cc:	0f be c0             	movsbl %al,%eax
  8016cf:	50                   	push   %eax
  8016d0:	ff 75 0c             	pushl  0xc(%ebp)
  8016d3:	e8 25 fa ff ff       	call   8010fd <strchr>
  8016d8:	83 c4 08             	add    $0x8,%esp
  8016db:	85 c0                	test   %eax,%eax
  8016dd:	74 dc                	je     8016bb <strsplit+0x8c>
			string++;
	}
  8016df:	e9 6e ff ff ff       	jmp    801652 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8016e4:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8016e5:	8b 45 14             	mov    0x14(%ebp),%eax
  8016e8:	8b 00                	mov    (%eax),%eax
  8016ea:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8016f1:	8b 45 10             	mov    0x10(%ebp),%eax
  8016f4:	01 d0                	add    %edx,%eax
  8016f6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8016fc:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801701:	c9                   	leave  
  801702:	c3                   	ret    

00801703 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  801703:	55                   	push   %ebp
  801704:	89 e5                	mov    %esp,%ebp
  801706:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  801709:	8b 45 08             	mov    0x8(%ebp),%eax
  80170c:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  80170f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801716:	eb 4a                	jmp    801762 <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  801718:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80171b:	8b 45 08             	mov    0x8(%ebp),%eax
  80171e:	01 c2                	add    %eax,%edx
  801720:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801723:	8b 45 0c             	mov    0xc(%ebp),%eax
  801726:	01 c8                	add    %ecx,%eax
  801728:	8a 00                	mov    (%eax),%al
  80172a:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  80172c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80172f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801732:	01 d0                	add    %edx,%eax
  801734:	8a 00                	mov    (%eax),%al
  801736:	3c 40                	cmp    $0x40,%al
  801738:	7e 25                	jle    80175f <str2lower+0x5c>
  80173a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80173d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801740:	01 d0                	add    %edx,%eax
  801742:	8a 00                	mov    (%eax),%al
  801744:	3c 5a                	cmp    $0x5a,%al
  801746:	7f 17                	jg     80175f <str2lower+0x5c>
		{
			dst[i] += 32 ;
  801748:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80174b:	8b 45 08             	mov    0x8(%ebp),%eax
  80174e:	01 d0                	add    %edx,%eax
  801750:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801753:	8b 55 08             	mov    0x8(%ebp),%edx
  801756:	01 ca                	add    %ecx,%edx
  801758:	8a 12                	mov    (%edx),%dl
  80175a:	83 c2 20             	add    $0x20,%edx
  80175d:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  80175f:	ff 45 fc             	incl   -0x4(%ebp)
  801762:	ff 75 0c             	pushl  0xc(%ebp)
  801765:	e8 01 f8 ff ff       	call   800f6b <strlen>
  80176a:	83 c4 04             	add    $0x4,%esp
  80176d:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801770:	7f a6                	jg     801718 <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  801772:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801775:	c9                   	leave  
  801776:	c3                   	ret    

00801777 <uheap_init>:
//==============================================
// [1] INITIALIZE USER HEAP:
//==============================================
int __firstTimeFlag = 1;
void uheap_init()
{
  801777:	55                   	push   %ebp
  801778:	89 e5                	mov    %esp,%ebp
  80177a:	83 ec 08             	sub    $0x8,%esp
	if(__firstTimeFlag)
  80177d:	a1 08 60 80 00       	mov    0x806008,%eax
  801782:	85 c0                	test   %eax,%eax
  801784:	0f 84 95 00 00 00    	je     80181f <uheap_init+0xa8>
	{
		initialize_dynamic_allocator(USER_HEAP_START, USER_HEAP_START + DYN_ALLOC_MAX_SIZE);
  80178a:	83 ec 08             	sub    $0x8,%esp
  80178d:	68 00 00 00 82       	push   $0x82000000
  801792:	68 00 00 00 80       	push   $0x80000000
  801797:	e8 59 1f 00 00       	call   8036f5 <initialize_dynamic_allocator>
  80179c:	83 c4 10             	add    $0x10,%esp
		uheapPlaceStrategy = sys_get_uheap_strategy();
  80179f:	e8 93 1d 00 00       	call   803537 <sys_get_uheap_strategy>
  8017a4:	a3 60 e0 81 00       	mov    %eax,0x81e060
		uheapPageAllocStart = dynAllocEnd + PAGE_SIZE;
  8017a9:	a1 40 60 80 00       	mov    0x806040,%eax
  8017ae:	05 00 10 00 00       	add    $0x1000,%eax
  8017b3:	a3 10 e1 81 00       	mov    %eax,0x81e110
		uheapPageAllocBreak = uheapPageAllocStart;
  8017b8:	a1 10 e1 81 00       	mov    0x81e110,%eax
  8017bd:	a3 68 e0 81 00       	mov    %eax,0x81e068
		init_uspinlock(&ulock,"malloc",1);
  8017c2:	83 ec 04             	sub    $0x4,%esp
  8017c5:	6a 01                	push   $0x1
  8017c7:	68 68 4e 80 00       	push   $0x804e68
  8017cc:	68 40 e1 81 00       	push   $0x81e140
  8017d1:	e8 d8 29 00 00       	call   8041ae <init_uspinlock>
  8017d6:	83 c4 10             	add    $0x10,%esp
		LIST_INIT(&u_freelist);
  8017d9:	c7 05 20 e1 81 00 00 	movl   $0x0,0x81e120
  8017e0:	00 00 00 
  8017e3:	c7 05 24 e1 81 00 00 	movl   $0x0,0x81e124
  8017ea:	00 00 00 
  8017ed:	c7 05 2c e1 81 00 00 	movl   $0x0,0x81e12c
  8017f4:	00 00 00 
		LIST_INIT(&u_allocatedlist);
  8017f7:	c7 05 30 e1 81 00 00 	movl   $0x0,0x81e130
  8017fe:	00 00 00 
  801801:	c7 05 34 e1 81 00 00 	movl   $0x0,0x81e134
  801808:	00 00 00 
  80180b:	c7 05 3c e1 81 00 00 	movl   $0x0,0x81e13c
  801812:	00 00 00 
		__firstTimeFlag = 0;
  801815:	c7 05 08 60 80 00 00 	movl   $0x0,0x806008
  80181c:	00 00 00 
	}
}
  80181f:	90                   	nop
  801820:	c9                   	leave  
  801821:	c3                   	ret    

00801822 <get_page>:

//==============================================
// [2] GET A PAGE FROM THE KERNEL FOR DA:
//==============================================
int get_page(void* va)
{
  801822:	55                   	push   %ebp
  801823:	89 e5                	mov    %esp,%ebp
  801825:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_allocate_page(ROUNDDOWN(va, PAGE_SIZE), PERM_USER|PERM_WRITEABLE|PERM_UHPAGE);
  801828:	8b 45 08             	mov    0x8(%ebp),%eax
  80182b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80182e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801831:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801836:	83 ec 08             	sub    $0x8,%esp
  801839:	68 06 04 00 00       	push   $0x406
  80183e:	50                   	push   %eax
  80183f:	e8 3d 19 00 00       	call   803181 <__sys_allocate_page>
  801844:	83 c4 10             	add    $0x10,%esp
  801847:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  80184a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80184e:	79 14                	jns    801864 <get_page+0x42>
		panic("get_page() in user: failed to allocate page from the kernel");
  801850:	83 ec 04             	sub    $0x4,%esp
  801853:	68 70 4e 80 00       	push   $0x804e70
  801858:	6a 2d                	push   $0x2d
  80185a:	68 ac 4e 80 00       	push   $0x804eac
  80185f:	e8 60 ed ff ff       	call   8005c4 <_panic>
	return 0;
  801864:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801869:	c9                   	leave  
  80186a:	c3                   	ret    

0080186b <return_page>:

//==============================================
// [3] RETURN A PAGE FROM THE DA TO KERNEL:
//==============================================
void return_page(void* va)
{
  80186b:	55                   	push   %ebp
  80186c:	89 e5                	mov    %esp,%ebp
  80186e:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_unmap_frame(ROUNDDOWN((uint32)va, PAGE_SIZE));
  801871:	8b 45 08             	mov    0x8(%ebp),%eax
  801874:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801877:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80187a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80187f:	83 ec 0c             	sub    $0xc,%esp
  801882:	50                   	push   %eax
  801883:	e8 40 19 00 00       	call   8031c8 <__sys_unmap_frame>
  801888:	83 c4 10             	add    $0x10,%esp
  80188b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  80188e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801892:	79 14                	jns    8018a8 <return_page+0x3d>
		panic("return_page() in user: failed to return a page to the kernel");
  801894:	83 ec 04             	sub    $0x4,%esp
  801897:	68 b8 4e 80 00       	push   $0x804eb8
  80189c:	6a 38                	push   $0x38
  80189e:	68 ac 4e 80 00       	push   $0x804eac
  8018a3:	e8 1c ed ff ff       	call   8005c4 <_panic>
}
  8018a8:	90                   	nop
  8018a9:	c9                   	leave  
  8018aa:	c3                   	ret    

008018ab <malloc>:

//=================================
// [1] ALLOCATE SPACE IN USER HEAP:
//=================================
void* malloc(uint32 size)
{
  8018ab:	55                   	push   %ebp
  8018ac:	89 e5                	mov    %esp,%ebp
  8018ae:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  8018b1:	e8 c1 fe ff ff       	call   801777 <uheap_init>
	if (size == 0) return NULL ;
  8018b6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8018ba:	75 0a                	jne    8018c6 <malloc+0x1b>
  8018bc:	b8 00 00 00 00       	mov    $0x0,%eax
  8018c1:	e9 e1 04 00 00       	jmp    801da7 <malloc+0x4fc>
	//==============================================================

	acquire_uspinlock(&ulock);
  8018c6:	83 ec 0c             	sub    $0xc,%esp
  8018c9:	68 40 e1 81 00       	push   $0x81e140
  8018ce:	e8 2a 29 00 00       	call   8041fd <acquire_uspinlock>
  8018d3:	83 c4 10             	add    $0x10,%esp
	if(size <  DYN_ALLOC_MAX_BLOCK_SIZE){
  8018d6:	81 7d 08 ff 07 00 00 	cmpl   $0x7ff,0x8(%ebp)
  8018dd:	77 23                	ja     801902 <malloc+0x57>
		release_uspinlock(&ulock);
  8018df:	83 ec 0c             	sub    $0xc,%esp
  8018e2:	68 40 e1 81 00       	push   $0x81e140
  8018e7:	e8 69 29 00 00       	call   804255 <release_uspinlock>
  8018ec:	83 c4 10             	add    $0x10,%esp
		return alloc_block(size);
  8018ef:	83 ec 0c             	sub    $0xc,%esp
  8018f2:	ff 75 08             	pushl  0x8(%ebp)
  8018f5:	e8 dd 1f 00 00       	call   8038d7 <alloc_block>
  8018fa:	83 c4 10             	add    $0x10,%esp
  8018fd:	e9 a5 04 00 00       	jmp    801da7 <malloc+0x4fc>
	}

	struct UserHeapStruct* allocblock= (struct UserHeapStruct*) alloc_block(sizeof(struct UserHeapStruct));
  801902:	83 ec 0c             	sub    $0xc,%esp
  801905:	6a 10                	push   $0x10
  801907:	e8 cb 1f 00 00       	call   8038d7 <alloc_block>
  80190c:	83 c4 10             	add    $0x10,%esp
  80190f:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (allocblock == NULL){
  801912:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801916:	75 0a                	jne    801922 <malloc+0x77>
			return NULL;
  801918:	b8 00 00 00 00       	mov    $0x0,%eax
  80191d:	e9 85 04 00 00       	jmp    801da7 <malloc+0x4fc>
	}

	size = ROUNDUP(size,PAGE_SIZE);
  801922:	c7 45 e8 00 10 00 00 	movl   $0x1000,-0x18(%ebp)
  801929:	8b 55 08             	mov    0x8(%ebp),%edx
  80192c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80192f:	01 d0                	add    %edx,%eax
  801931:	48                   	dec    %eax
  801932:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801935:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801938:	ba 00 00 00 00       	mov    $0x0,%edx
  80193d:	f7 75 e8             	divl   -0x18(%ebp)
  801940:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801943:	29 d0                	sub    %edx,%eax
  801945:	89 45 08             	mov    %eax,0x8(%ebp)
	struct UserHeapStruct* lastfreeelement = LIST_LAST(&u_freelist);
  801948:	a1 24 e1 81 00       	mov    0x81e124,%eax
  80194d:	89 45 e0             	mov    %eax,-0x20(%ebp)

	if(LIST_SIZE(&u_freelist)==0 || size>lastfreeelement->size){
  801950:	a1 2c e1 81 00       	mov    0x81e12c,%eax
  801955:	85 c0                	test   %eax,%eax
  801957:	74 0f                	je     801968 <malloc+0xbd>
  801959:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80195c:	8b 40 04             	mov    0x4(%eax),%eax
  80195f:	3b 45 08             	cmp    0x8(%ebp),%eax
  801962:	0f 83 ea 00 00 00    	jae    801a52 <malloc+0x1a7>
			if(uheapPageAllocBreak < USER_HEAP_MAX - size){
  801968:	b8 00 00 00 a0       	mov    $0xa0000000,%eax
  80196d:	2b 45 08             	sub    0x8(%ebp),%eax
  801970:	89 c2                	mov    %eax,%edx
  801972:	a1 68 e0 81 00       	mov    0x81e068,%eax
  801977:	39 c2                	cmp    %eax,%edx
  801979:	0f 86 b9 00 00 00    	jbe    801a38 <malloc+0x18d>
					uint32 requestedblockva = uheapPageAllocBreak;
  80197f:	a1 68 e0 81 00       	mov    0x81e068,%eax
  801984:	89 45 dc             	mov    %eax,-0x24(%ebp)
					uheapPageAllocBreak+=size;
  801987:	8b 15 68 e0 81 00    	mov    0x81e068,%edx
  80198d:	8b 45 08             	mov    0x8(%ebp),%eax
  801990:	01 d0                	add    %edx,%eax
  801992:	a3 68 e0 81 00       	mov    %eax,0x81e068
					allocblock->startva = requestedblockva;
  801997:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80199a:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80199d:	89 10                	mov    %edx,(%eax)
					allocblock->size = size;
  80199f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8019a2:	8b 55 08             	mov    0x8(%ebp),%edx
  8019a5:	89 50 04             	mov    %edx,0x4(%eax)

					LIST_INSERT_TAIL(&u_allocatedlist, allocblock);
  8019a8:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8019ac:	75 14                	jne    8019c2 <malloc+0x117>
  8019ae:	83 ec 04             	sub    $0x4,%esp
  8019b1:	68 f8 4e 80 00       	push   $0x804ef8
  8019b6:	6a 60                	push   $0x60
  8019b8:	68 ac 4e 80 00       	push   $0x804eac
  8019bd:	e8 02 ec ff ff       	call   8005c4 <_panic>
  8019c2:	8b 15 34 e1 81 00    	mov    0x81e134,%edx
  8019c8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8019cb:	89 50 0c             	mov    %edx,0xc(%eax)
  8019ce:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8019d1:	8b 40 0c             	mov    0xc(%eax),%eax
  8019d4:	85 c0                	test   %eax,%eax
  8019d6:	74 0d                	je     8019e5 <malloc+0x13a>
  8019d8:	a1 34 e1 81 00       	mov    0x81e134,%eax
  8019dd:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8019e0:	89 50 08             	mov    %edx,0x8(%eax)
  8019e3:	eb 08                	jmp    8019ed <malloc+0x142>
  8019e5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8019e8:	a3 30 e1 81 00       	mov    %eax,0x81e130
  8019ed:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8019f0:	a3 34 e1 81 00       	mov    %eax,0x81e134
  8019f5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8019f8:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  8019ff:	a1 3c e1 81 00       	mov    0x81e13c,%eax
  801a04:	40                   	inc    %eax
  801a05:	a3 3c e1 81 00       	mov    %eax,0x81e13c


					sys_allocate_user_mem(allocblock->startva ,size);
  801a0a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801a0d:	8b 00                	mov    (%eax),%eax
  801a0f:	83 ec 08             	sub    $0x8,%esp
  801a12:	ff 75 08             	pushl  0x8(%ebp)
  801a15:	50                   	push   %eax
  801a16:	e8 34 1c 00 00       	call   80364f <sys_allocate_user_mem>
  801a1b:	83 c4 10             	add    $0x10,%esp
					release_uspinlock(&ulock);
  801a1e:	83 ec 0c             	sub    $0xc,%esp
  801a21:	68 40 e1 81 00       	push   $0x81e140
  801a26:	e8 2a 28 00 00       	call   804255 <release_uspinlock>
  801a2b:	83 c4 10             	add    $0x10,%esp
					return (void*)allocblock->startva;
  801a2e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801a31:	8b 00                	mov    (%eax),%eax
  801a33:	e9 6f 03 00 00       	jmp    801da7 <malloc+0x4fc>
			}else{
					release_uspinlock(&ulock);
  801a38:	83 ec 0c             	sub    $0xc,%esp
  801a3b:	68 40 e1 81 00       	push   $0x81e140
  801a40:	e8 10 28 00 00       	call   804255 <release_uspinlock>
  801a45:	83 c4 10             	add    $0x10,%esp
					return NULL;
  801a48:	b8 00 00 00 00       	mov    $0x0,%eax
  801a4d:	e9 55 03 00 00       	jmp    801da7 <malloc+0x4fc>
				}
	}else{
		//custom fit
		struct UserHeapStruct* currentfreeelement = LIST_FIRST(&u_freelist);
  801a52:	a1 20 e1 81 00       	mov    0x81e120,%eax
  801a57:	89 45 f4             	mov    %eax,-0xc(%ebp)
		//worst fit
		while(currentfreeelement != NULL){
  801a5a:	e9 39 03 00 00       	jmp    801d98 <malloc+0x4ed>
			if(size<currentfreeelement->size){
  801a5f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a62:	8b 40 04             	mov    0x4(%eax),%eax
  801a65:	3b 45 08             	cmp    0x8(%ebp),%eax
  801a68:	0f 86 e7 01 00 00    	jbe    801c55 <malloc+0x3aa>
				allocblock->startva = lastfreeelement->startva;
  801a6e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801a71:	8b 10                	mov    (%eax),%edx
  801a73:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801a76:	89 10                	mov    %edx,(%eax)
                allocblock->size = size;
  801a78:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801a7b:	8b 55 08             	mov    0x8(%ebp),%edx
  801a7e:	89 50 04             	mov    %edx,0x4(%eax)
                LIST_INSERT_TAIL(&u_allocatedlist,allocblock);
  801a81:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801a85:	75 14                	jne    801a9b <malloc+0x1f0>
  801a87:	83 ec 04             	sub    $0x4,%esp
  801a8a:	68 f8 4e 80 00       	push   $0x804ef8
  801a8f:	6a 72                	push   $0x72
  801a91:	68 ac 4e 80 00       	push   $0x804eac
  801a96:	e8 29 eb ff ff       	call   8005c4 <_panic>
  801a9b:	8b 15 34 e1 81 00    	mov    0x81e134,%edx
  801aa1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801aa4:	89 50 0c             	mov    %edx,0xc(%eax)
  801aa7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801aaa:	8b 40 0c             	mov    0xc(%eax),%eax
  801aad:	85 c0                	test   %eax,%eax
  801aaf:	74 0d                	je     801abe <malloc+0x213>
  801ab1:	a1 34 e1 81 00       	mov    0x81e134,%eax
  801ab6:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801ab9:	89 50 08             	mov    %edx,0x8(%eax)
  801abc:	eb 08                	jmp    801ac6 <malloc+0x21b>
  801abe:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801ac1:	a3 30 e1 81 00       	mov    %eax,0x81e130
  801ac6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801ac9:	a3 34 e1 81 00       	mov    %eax,0x81e134
  801ace:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801ad1:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  801ad8:	a1 3c e1 81 00       	mov    0x81e13c,%eax
  801add:	40                   	inc    %eax
  801ade:	a3 3c e1 81 00       	mov    %eax,0x81e13c
                lastfreeelement->startva += size;
  801ae3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801ae6:	8b 10                	mov    (%eax),%edx
  801ae8:	8b 45 08             	mov    0x8(%ebp),%eax
  801aeb:	01 c2                	add    %eax,%edx
  801aed:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801af0:	89 10                	mov    %edx,(%eax)
                lastfreeelement->size -= size;
  801af2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801af5:	8b 40 04             	mov    0x4(%eax),%eax
  801af8:	2b 45 08             	sub    0x8(%ebp),%eax
  801afb:	89 c2                	mov    %eax,%edx
  801afd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801b00:	89 50 04             	mov    %edx,0x4(%eax)
                struct UserHeapStruct* currentfree2 = LIST_FIRST(&u_freelist);
  801b03:	a1 20 e1 81 00       	mov    0x81e120,%eax
  801b08:	89 45 f0             	mov    %eax,-0x10(%ebp)
                //check order of last element

                while (currentfree2 != NULL){
  801b0b:	e9 0d 01 00 00       	jmp    801c1d <malloc+0x372>
                	if(lastfreeelement->size <currentfree2->size){
  801b10:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801b13:	8b 50 04             	mov    0x4(%eax),%edx
  801b16:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b19:	8b 40 04             	mov    0x4(%eax),%eax
  801b1c:	39 c2                	cmp    %eax,%edx
  801b1e:	0f 83 f0 00 00 00    	jae    801c14 <malloc+0x369>
                		LIST_REMOVE(&u_freelist ,lastfreeelement);
  801b24:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801b28:	75 14                	jne    801b3e <malloc+0x293>
  801b2a:	83 ec 04             	sub    $0x4,%esp
  801b2d:	68 1b 4f 80 00       	push   $0x804f1b
  801b32:	6a 7a                	push   $0x7a
  801b34:	68 ac 4e 80 00       	push   $0x804eac
  801b39:	e8 86 ea ff ff       	call   8005c4 <_panic>
  801b3e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801b41:	8b 40 08             	mov    0x8(%eax),%eax
  801b44:	85 c0                	test   %eax,%eax
  801b46:	74 11                	je     801b59 <malloc+0x2ae>
  801b48:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801b4b:	8b 40 08             	mov    0x8(%eax),%eax
  801b4e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801b51:	8b 52 0c             	mov    0xc(%edx),%edx
  801b54:	89 50 0c             	mov    %edx,0xc(%eax)
  801b57:	eb 0b                	jmp    801b64 <malloc+0x2b9>
  801b59:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801b5c:	8b 40 0c             	mov    0xc(%eax),%eax
  801b5f:	a3 24 e1 81 00       	mov    %eax,0x81e124
  801b64:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801b67:	8b 40 0c             	mov    0xc(%eax),%eax
  801b6a:	85 c0                	test   %eax,%eax
  801b6c:	74 11                	je     801b7f <malloc+0x2d4>
  801b6e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801b71:	8b 40 0c             	mov    0xc(%eax),%eax
  801b74:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801b77:	8b 52 08             	mov    0x8(%edx),%edx
  801b7a:	89 50 08             	mov    %edx,0x8(%eax)
  801b7d:	eb 0b                	jmp    801b8a <malloc+0x2df>
  801b7f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801b82:	8b 40 08             	mov    0x8(%eax),%eax
  801b85:	a3 20 e1 81 00       	mov    %eax,0x81e120
  801b8a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801b8d:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  801b94:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801b97:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  801b9e:	a1 2c e1 81 00       	mov    0x81e12c,%eax
  801ba3:	48                   	dec    %eax
  801ba4:	a3 2c e1 81 00       	mov    %eax,0x81e12c
                		LIST_INSERT_BEFORE(&u_freelist ,currentfree2 ,lastfreeelement);
  801ba9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801bad:	74 06                	je     801bb5 <malloc+0x30a>
  801baf:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801bb3:	75 14                	jne    801bc9 <malloc+0x31e>
  801bb5:	83 ec 04             	sub    $0x4,%esp
  801bb8:	68 3c 4f 80 00       	push   $0x804f3c
  801bbd:	6a 7b                	push   $0x7b
  801bbf:	68 ac 4e 80 00       	push   $0x804eac
  801bc4:	e8 fb e9 ff ff       	call   8005c4 <_panic>
  801bc9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801bcc:	8b 50 0c             	mov    0xc(%eax),%edx
  801bcf:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801bd2:	89 50 0c             	mov    %edx,0xc(%eax)
  801bd5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801bd8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801bdb:	89 50 08             	mov    %edx,0x8(%eax)
  801bde:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801be1:	8b 40 0c             	mov    0xc(%eax),%eax
  801be4:	85 c0                	test   %eax,%eax
  801be6:	74 0e                	je     801bf6 <malloc+0x34b>
  801be8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801beb:	8b 40 0c             	mov    0xc(%eax),%eax
  801bee:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801bf1:	89 50 08             	mov    %edx,0x8(%eax)
  801bf4:	eb 08                	jmp    801bfe <malloc+0x353>
  801bf6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801bf9:	a3 20 e1 81 00       	mov    %eax,0x81e120
  801bfe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c01:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801c04:	89 50 0c             	mov    %edx,0xc(%eax)
  801c07:	a1 2c e1 81 00       	mov    0x81e12c,%eax
  801c0c:	40                   	inc    %eax
  801c0d:	a3 2c e1 81 00       	mov    %eax,0x81e12c
                		break;
  801c12:	eb 13                	jmp    801c27 <malloc+0x37c>
                	}
                	currentfree2 = currentfree2->prev_next_info.le_next;
  801c14:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c17:	8b 40 08             	mov    0x8(%eax),%eax
  801c1a:	89 45 f0             	mov    %eax,-0x10(%ebp)
                lastfreeelement->startva += size;
                lastfreeelement->size -= size;
                struct UserHeapStruct* currentfree2 = LIST_FIRST(&u_freelist);
                //check order of last element

                while (currentfree2 != NULL){
  801c1d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801c21:	0f 85 e9 fe ff ff    	jne    801b10 <malloc+0x265>
                	}
                	currentfree2 = currentfree2->prev_next_info.le_next;
                }


                sys_allocate_user_mem(allocblock->startva ,size);
  801c27:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801c2a:	8b 00                	mov    (%eax),%eax
  801c2c:	83 ec 08             	sub    $0x8,%esp
  801c2f:	ff 75 08             	pushl  0x8(%ebp)
  801c32:	50                   	push   %eax
  801c33:	e8 17 1a 00 00       	call   80364f <sys_allocate_user_mem>
  801c38:	83 c4 10             	add    $0x10,%esp
                release_uspinlock(&ulock);
  801c3b:	83 ec 0c             	sub    $0xc,%esp
  801c3e:	68 40 e1 81 00       	push   $0x81e140
  801c43:	e8 0d 26 00 00       	call   804255 <release_uspinlock>
  801c48:	83 c4 10             	add    $0x10,%esp
                return (void*)allocblock->startva;
  801c4b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801c4e:	8b 00                	mov    (%eax),%eax
  801c50:	e9 52 01 00 00       	jmp    801da7 <malloc+0x4fc>
                //exact fit
			}else if(size == currentfreeelement->size){
  801c55:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c58:	8b 40 04             	mov    0x4(%eax),%eax
  801c5b:	3b 45 08             	cmp    0x8(%ebp),%eax
  801c5e:	0f 85 2b 01 00 00    	jne    801d8f <malloc+0x4e4>
				allocblock->startva = currentfreeelement->startva;
  801c64:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c67:	8b 10                	mov    (%eax),%edx
  801c69:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801c6c:	89 10                	mov    %edx,(%eax)
				allocblock->size = size;
  801c6e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801c71:	8b 55 08             	mov    0x8(%ebp),%edx
  801c74:	89 50 04             	mov    %edx,0x4(%eax)
				LIST_INSERT_TAIL(&u_allocatedlist ,allocblock);
  801c77:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801c7b:	75 17                	jne    801c94 <malloc+0x3e9>
  801c7d:	83 ec 04             	sub    $0x4,%esp
  801c80:	68 f8 4e 80 00       	push   $0x804ef8
  801c85:	68 89 00 00 00       	push   $0x89
  801c8a:	68 ac 4e 80 00       	push   $0x804eac
  801c8f:	e8 30 e9 ff ff       	call   8005c4 <_panic>
  801c94:	8b 15 34 e1 81 00    	mov    0x81e134,%edx
  801c9a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801c9d:	89 50 0c             	mov    %edx,0xc(%eax)
  801ca0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801ca3:	8b 40 0c             	mov    0xc(%eax),%eax
  801ca6:	85 c0                	test   %eax,%eax
  801ca8:	74 0d                	je     801cb7 <malloc+0x40c>
  801caa:	a1 34 e1 81 00       	mov    0x81e134,%eax
  801caf:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801cb2:	89 50 08             	mov    %edx,0x8(%eax)
  801cb5:	eb 08                	jmp    801cbf <malloc+0x414>
  801cb7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801cba:	a3 30 e1 81 00       	mov    %eax,0x81e130
  801cbf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801cc2:	a3 34 e1 81 00       	mov    %eax,0x81e134
  801cc7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801cca:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  801cd1:	a1 3c e1 81 00       	mov    0x81e13c,%eax
  801cd6:	40                   	inc    %eax
  801cd7:	a3 3c e1 81 00       	mov    %eax,0x81e13c
				LIST_REMOVE(&u_freelist ,currentfreeelement);
  801cdc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801ce0:	75 17                	jne    801cf9 <malloc+0x44e>
  801ce2:	83 ec 04             	sub    $0x4,%esp
  801ce5:	68 1b 4f 80 00       	push   $0x804f1b
  801cea:	68 8a 00 00 00       	push   $0x8a
  801cef:	68 ac 4e 80 00       	push   $0x804eac
  801cf4:	e8 cb e8 ff ff       	call   8005c4 <_panic>
  801cf9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cfc:	8b 40 08             	mov    0x8(%eax),%eax
  801cff:	85 c0                	test   %eax,%eax
  801d01:	74 11                	je     801d14 <malloc+0x469>
  801d03:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d06:	8b 40 08             	mov    0x8(%eax),%eax
  801d09:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801d0c:	8b 52 0c             	mov    0xc(%edx),%edx
  801d0f:	89 50 0c             	mov    %edx,0xc(%eax)
  801d12:	eb 0b                	jmp    801d1f <malloc+0x474>
  801d14:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d17:	8b 40 0c             	mov    0xc(%eax),%eax
  801d1a:	a3 24 e1 81 00       	mov    %eax,0x81e124
  801d1f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d22:	8b 40 0c             	mov    0xc(%eax),%eax
  801d25:	85 c0                	test   %eax,%eax
  801d27:	74 11                	je     801d3a <malloc+0x48f>
  801d29:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d2c:	8b 40 0c             	mov    0xc(%eax),%eax
  801d2f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801d32:	8b 52 08             	mov    0x8(%edx),%edx
  801d35:	89 50 08             	mov    %edx,0x8(%eax)
  801d38:	eb 0b                	jmp    801d45 <malloc+0x49a>
  801d3a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d3d:	8b 40 08             	mov    0x8(%eax),%eax
  801d40:	a3 20 e1 81 00       	mov    %eax,0x81e120
  801d45:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d48:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  801d4f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d52:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  801d59:	a1 2c e1 81 00       	mov    0x81e12c,%eax
  801d5e:	48                   	dec    %eax
  801d5f:	a3 2c e1 81 00       	mov    %eax,0x81e12c
				sys_allocate_user_mem(allocblock->startva ,size);
  801d64:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801d67:	8b 00                	mov    (%eax),%eax
  801d69:	83 ec 08             	sub    $0x8,%esp
  801d6c:	ff 75 08             	pushl  0x8(%ebp)
  801d6f:	50                   	push   %eax
  801d70:	e8 da 18 00 00       	call   80364f <sys_allocate_user_mem>
  801d75:	83 c4 10             	add    $0x10,%esp
				release_uspinlock(&ulock);
  801d78:	83 ec 0c             	sub    $0xc,%esp
  801d7b:	68 40 e1 81 00       	push   $0x81e140
  801d80:	e8 d0 24 00 00       	call   804255 <release_uspinlock>
  801d85:	83 c4 10             	add    $0x10,%esp
				return (void*)allocblock->startva;
  801d88:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801d8b:	8b 00                	mov    (%eax),%eax
  801d8d:	eb 18                	jmp    801da7 <malloc+0x4fc>
			}
			currentfreeelement = currentfreeelement->prev_next_info.le_next;
  801d8f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d92:	8b 40 08             	mov    0x8(%eax),%eax
  801d95:	89 45 f4             	mov    %eax,-0xc(%ebp)
				}
	}else{
		//custom fit
		struct UserHeapStruct* currentfreeelement = LIST_FIRST(&u_freelist);
		//worst fit
		while(currentfreeelement != NULL){
  801d98:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801d9c:	0f 85 bd fc ff ff    	jne    801a5f <malloc+0x1b4>
				return (void*)allocblock->startva;
			}
			currentfreeelement = currentfreeelement->prev_next_info.le_next;
		}
	}
	 return NULL;
  801da2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801da7:	c9                   	leave  
  801da8:	c3                   	ret    

00801da9 <free>:

//=================================
// [2] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
  801da9:	55                   	push   %ebp
  801daa:	89 e5                	mov    %esp,%ebp
  801dac:	83 ec 38             	sub    $0x38,%esp
	uint32  VA = ROUNDDOWN(((uint32 ) virtual_address), PAGE_SIZE);
  801daf:	8b 45 08             	mov    0x8(%ebp),%eax
  801db2:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801db5:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801db8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801dbd:	89 45 d8             	mov    %eax,-0x28(%ebp)


		uheap_init();
  801dc0:	e8 b2 f9 ff ff       	call   801777 <uheap_init>
		acquire_uspinlock(&ulock);
  801dc5:	83 ec 0c             	sub    $0xc,%esp
  801dc8:	68 40 e1 81 00       	push   $0x81e140
  801dcd:	e8 2b 24 00 00       	call   8041fd <acquire_uspinlock>
  801dd2:	83 c4 10             	add    $0x10,%esp
		if (VA < uheapPageAllocStart){
  801dd5:	a1 10 e1 81 00       	mov    0x81e110,%eax
  801dda:	39 45 d8             	cmp    %eax,-0x28(%ebp)
  801ddd:	73 23                	jae    801e02 <free+0x59>
			free_block(virtual_address);
  801ddf:	83 ec 0c             	sub    $0xc,%esp
  801de2:	ff 75 08             	pushl  0x8(%ebp)
  801de5:	e8 89 1f 00 00       	call   803d73 <free_block>
  801dea:	83 c4 10             	add    $0x10,%esp
			release_uspinlock(&ulock);
  801ded:	83 ec 0c             	sub    $0xc,%esp
  801df0:	68 40 e1 81 00       	push   $0x81e140
  801df5:	e8 5b 24 00 00       	call   804255 <release_uspinlock>
  801dfa:	83 c4 10             	add    $0x10,%esp
			return;
  801dfd:	e9 35 07 00 00       	jmp    802537 <free+0x78e>
		}
		if (VA >= uheapPageAllocBreak){
  801e02:	a1 68 e0 81 00       	mov    0x81e068,%eax
  801e07:	39 45 d8             	cmp    %eax,-0x28(%ebp)
  801e0a:	72 30                	jb     801e3c <free+0x93>
			cprintf("%d\n %d\n", VA, uheapPageAllocBreak);
  801e0c:	a1 68 e0 81 00       	mov    0x81e068,%eax
  801e11:	83 ec 04             	sub    $0x4,%esp
  801e14:	50                   	push   %eax
  801e15:	ff 75 d8             	pushl  -0x28(%ebp)
  801e18:	68 71 4f 80 00       	push   $0x804f71
  801e1d:	e8 70 ea ff ff       	call   800892 <cprintf>
  801e22:	83 c4 10             	add    $0x10,%esp

			panic("freeing from restricted area");
  801e25:	83 ec 04             	sub    $0x4,%esp
  801e28:	68 79 4f 80 00       	push   $0x804f79
  801e2d:	68 a7 00 00 00       	push   $0xa7
  801e32:	68 ac 4e 80 00       	push   $0x804eac
  801e37:	e8 88 e7 ff ff       	call   8005c4 <_panic>
			release_uspinlock(&ulock);
			return;
		}

		struct UserHeapStruct* newfree = (struct UserHeapStruct*) alloc_block(sizeof(struct UserHeapStruct));
  801e3c:	83 ec 0c             	sub    $0xc,%esp
  801e3f:	6a 10                	push   $0x10
  801e41:	e8 91 1a 00 00       	call   8038d7 <alloc_block>
  801e46:	83 c4 10             	add    $0x10,%esp
  801e49:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		struct UserHeapStruct* MergedBlock  = ( struct UserHeapStruct*)alloc_block(sizeof(struct UserHeapStruct));
  801e4c:	83 ec 0c             	sub    $0xc,%esp
  801e4f:	6a 10                	push   $0x10
  801e51:	e8 81 1a 00 00       	call   8038d7 <alloc_block>
  801e56:	83 c4 10             	add    $0x10,%esp
  801e59:	89 45 d0             	mov    %eax,-0x30(%ebp)

		struct UserHeapStruct* ToBefreed = LIST_FIRST(&u_allocatedlist);
  801e5c:	a1 30 e1 81 00       	mov    0x81e130,%eax
  801e61:	89 45 f4             	mov    %eax,-0xc(%ebp)
		bool foundVA = 0;
  801e64:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

		//find the allocated block
		while(ToBefreed !=NULL ){
  801e6b:	eb 1c                	jmp    801e89 <free+0xe0>

			if (VA ==ToBefreed->startva ){
  801e6d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e70:	8b 00                	mov    (%eax),%eax
  801e72:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  801e75:	75 09                	jne    801e80 <free+0xd7>
				foundVA = 1;
  801e77:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
				break;
  801e7e:	eb 0f                	jmp    801e8f <free+0xe6>
			}
				ToBefreed = ToBefreed->prev_next_info.le_next;
  801e80:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e83:	8b 40 08             	mov    0x8(%eax),%eax
  801e86:	89 45 f4             	mov    %eax,-0xc(%ebp)

		struct UserHeapStruct* ToBefreed = LIST_FIRST(&u_allocatedlist);
		bool foundVA = 0;

		//find the allocated block
		while(ToBefreed !=NULL ){
  801e89:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801e8d:	75 de                	jne    801e6d <free+0xc4>
			}
				ToBefreed = ToBefreed->prev_next_info.le_next;
		}


		if(!foundVA){
  801e8f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801e93:	75 17                	jne    801eac <free+0x103>
				panic("INVALID ADDRESS!");
  801e95:	83 ec 04             	sub    $0x4,%esp
  801e98:	68 96 4f 80 00       	push   $0x804f96
  801e9d:	68 be 00 00 00       	push   $0xbe
  801ea2:	68 ac 4e 80 00       	push   $0x804eac
  801ea7:	e8 18 e7 ff ff       	call   8005c4 <_panic>
				release_uspinlock(&ulock);
				return;
			}


		newfree->startva = ToBefreed->startva;
  801eac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801eaf:	8b 10                	mov    (%eax),%edx
  801eb1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801eb4:	89 10                	mov    %edx,(%eax)
		newfree->size = ToBefreed->size;
  801eb6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801eb9:	8b 50 04             	mov    0x4(%eax),%edx
  801ebc:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801ebf:	89 50 04             	mov    %edx,0x4(%eax)

		//remove allocated block from alloclist
		LIST_REMOVE(&u_allocatedlist, ToBefreed);
  801ec2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801ec6:	75 17                	jne    801edf <free+0x136>
  801ec8:	83 ec 04             	sub    $0x4,%esp
  801ecb:	68 1b 4f 80 00       	push   $0x804f1b
  801ed0:	68 c8 00 00 00       	push   $0xc8
  801ed5:	68 ac 4e 80 00       	push   $0x804eac
  801eda:	e8 e5 e6 ff ff       	call   8005c4 <_panic>
  801edf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ee2:	8b 40 08             	mov    0x8(%eax),%eax
  801ee5:	85 c0                	test   %eax,%eax
  801ee7:	74 11                	je     801efa <free+0x151>
  801ee9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801eec:	8b 40 08             	mov    0x8(%eax),%eax
  801eef:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ef2:	8b 52 0c             	mov    0xc(%edx),%edx
  801ef5:	89 50 0c             	mov    %edx,0xc(%eax)
  801ef8:	eb 0b                	jmp    801f05 <free+0x15c>
  801efa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801efd:	8b 40 0c             	mov    0xc(%eax),%eax
  801f00:	a3 34 e1 81 00       	mov    %eax,0x81e134
  801f05:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f08:	8b 40 0c             	mov    0xc(%eax),%eax
  801f0b:	85 c0                	test   %eax,%eax
  801f0d:	74 11                	je     801f20 <free+0x177>
  801f0f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f12:	8b 40 0c             	mov    0xc(%eax),%eax
  801f15:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f18:	8b 52 08             	mov    0x8(%edx),%edx
  801f1b:	89 50 08             	mov    %edx,0x8(%eax)
  801f1e:	eb 0b                	jmp    801f2b <free+0x182>
  801f20:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f23:	8b 40 08             	mov    0x8(%eax),%eax
  801f26:	a3 30 e1 81 00       	mov    %eax,0x81e130
  801f2b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f2e:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  801f35:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f38:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  801f3f:	a1 3c e1 81 00       	mov    0x81e13c,%eax
  801f44:	48                   	dec    %eax
  801f45:	a3 3c e1 81 00       	mov    %eax,0x81e13c

		sys_free_user_mem(ToBefreed->startva, ToBefreed->size);
  801f4a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f4d:	8b 50 04             	mov    0x4(%eax),%edx
  801f50:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f53:	8b 00                	mov    (%eax),%eax
  801f55:	83 ec 08             	sub    $0x8,%esp
  801f58:	52                   	push   %edx
  801f59:	50                   	push   %eax
  801f5a:	e8 d4 16 00 00       	call   803633 <sys_free_user_mem>
  801f5f:	83 c4 10             	add    $0x10,%esp




		if(LIST_SIZE(&u_freelist) == 0){
  801f62:	a1 2c e1 81 00       	mov    0x81e12c,%eax
  801f67:	85 c0                	test   %eax,%eax
  801f69:	75 7a                	jne    801fe5 <free+0x23c>
			LIST_INSERT_HEAD(&u_freelist,newfree);
  801f6b:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  801f6f:	75 17                	jne    801f88 <free+0x1df>
  801f71:	83 ec 04             	sub    $0x4,%esp
  801f74:	68 a8 4f 80 00       	push   $0x804fa8
  801f79:	68 d0 00 00 00       	push   $0xd0
  801f7e:	68 ac 4e 80 00       	push   $0x804eac
  801f83:	e8 3c e6 ff ff       	call   8005c4 <_panic>
  801f88:	8b 15 20 e1 81 00    	mov    0x81e120,%edx
  801f8e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801f91:	89 50 08             	mov    %edx,0x8(%eax)
  801f94:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801f97:	8b 40 08             	mov    0x8(%eax),%eax
  801f9a:	85 c0                	test   %eax,%eax
  801f9c:	74 0d                	je     801fab <free+0x202>
  801f9e:	a1 20 e1 81 00       	mov    0x81e120,%eax
  801fa3:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  801fa6:	89 50 0c             	mov    %edx,0xc(%eax)
  801fa9:	eb 08                	jmp    801fb3 <free+0x20a>
  801fab:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801fae:	a3 24 e1 81 00       	mov    %eax,0x81e124
  801fb3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801fb6:	a3 20 e1 81 00       	mov    %eax,0x81e120
  801fbb:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801fbe:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  801fc5:	a1 2c e1 81 00       	mov    0x81e12c,%eax
  801fca:	40                   	inc    %eax
  801fcb:	a3 2c e1 81 00       	mov    %eax,0x81e12c
			release_uspinlock(&ulock);
  801fd0:	83 ec 0c             	sub    $0xc,%esp
  801fd3:	68 40 e1 81 00       	push   $0x81e140
  801fd8:	e8 78 22 00 00       	call   804255 <release_uspinlock>
  801fdd:	83 c4 10             	add    $0x10,%esp
			return;
  801fe0:	e9 52 05 00 00       	jmp    802537 <free+0x78e>
		}


		struct UserHeapStruct* ToBeMerged = LIST_FIRST(&u_freelist);
  801fe5:	a1 20 e1 81 00       	mov    0x81e120,%eax
  801fea:	89 45 ec             	mov    %eax,-0x14(%ebp)
		// merge with prev if possible
		bool mergeprev = 0;
  801fed:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		bool mergenext = 0;
  801ff4:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
		while(ToBeMerged != NULL){
  801ffb:	e9 d2 00 00 00       	jmp    8020d2 <free+0x329>
			if((ToBeMerged->startva +ToBeMerged->size) == newfree->startva){
  802000:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802003:	8b 10                	mov    (%eax),%edx
  802005:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802008:	8b 40 04             	mov    0x4(%eax),%eax
  80200b:	01 c2                	add    %eax,%edx
  80200d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802010:	8b 00                	mov    (%eax),%eax
  802012:	39 c2                	cmp    %eax,%edx
  802014:	0f 85 af 00 00 00    	jne    8020c9 <free+0x320>

				MergedBlock->startva = ToBeMerged->startva;
  80201a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80201d:	8b 10                	mov    (%eax),%edx
  80201f:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802022:	89 10                	mov    %edx,(%eax)
				MergedBlock->size = ToBeMerged->size + newfree->size;
  802024:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802027:	8b 50 04             	mov    0x4(%eax),%edx
  80202a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80202d:	8b 40 04             	mov    0x4(%eax),%eax
  802030:	01 c2                	add    %eax,%edx
  802032:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802035:	89 50 04             	mov    %edx,0x4(%eax)
				LIST_REMOVE(&u_freelist, ToBeMerged);
  802038:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80203c:	75 17                	jne    802055 <free+0x2ac>
  80203e:	83 ec 04             	sub    $0x4,%esp
  802041:	68 1b 4f 80 00       	push   $0x804f1b
  802046:	68 df 00 00 00       	push   $0xdf
  80204b:	68 ac 4e 80 00       	push   $0x804eac
  802050:	e8 6f e5 ff ff       	call   8005c4 <_panic>
  802055:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802058:	8b 40 08             	mov    0x8(%eax),%eax
  80205b:	85 c0                	test   %eax,%eax
  80205d:	74 11                	je     802070 <free+0x2c7>
  80205f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802062:	8b 40 08             	mov    0x8(%eax),%eax
  802065:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802068:	8b 52 0c             	mov    0xc(%edx),%edx
  80206b:	89 50 0c             	mov    %edx,0xc(%eax)
  80206e:	eb 0b                	jmp    80207b <free+0x2d2>
  802070:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802073:	8b 40 0c             	mov    0xc(%eax),%eax
  802076:	a3 24 e1 81 00       	mov    %eax,0x81e124
  80207b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80207e:	8b 40 0c             	mov    0xc(%eax),%eax
  802081:	85 c0                	test   %eax,%eax
  802083:	74 11                	je     802096 <free+0x2ed>
  802085:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802088:	8b 40 0c             	mov    0xc(%eax),%eax
  80208b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80208e:	8b 52 08             	mov    0x8(%edx),%edx
  802091:	89 50 08             	mov    %edx,0x8(%eax)
  802094:	eb 0b                	jmp    8020a1 <free+0x2f8>
  802096:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802099:	8b 40 08             	mov    0x8(%eax),%eax
  80209c:	a3 20 e1 81 00       	mov    %eax,0x81e120
  8020a1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8020a4:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  8020ab:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8020ae:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  8020b5:	a1 2c e1 81 00       	mov    0x81e12c,%eax
  8020ba:	48                   	dec    %eax
  8020bb:	a3 2c e1 81 00       	mov    %eax,0x81e12c
				mergeprev = 1;
  8020c0:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
				break;
  8020c7:	eb 13                	jmp    8020dc <free+0x333>
			}
				ToBeMerged = ToBeMerged->prev_next_info.le_next;
  8020c9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8020cc:	8b 40 08             	mov    0x8(%eax),%eax
  8020cf:	89 45 ec             	mov    %eax,-0x14(%ebp)

		struct UserHeapStruct* ToBeMerged = LIST_FIRST(&u_freelist);
		// merge with prev if possible
		bool mergeprev = 0;
		bool mergenext = 0;
		while(ToBeMerged != NULL){
  8020d2:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8020d6:	0f 85 24 ff ff ff    	jne    802000 <free+0x257>
//									uheapPageAllocBreak = newfree->startva;
//						}
//					}


		if ( newfree ->startva + newfree->size == uheapPageAllocBreak){
  8020dc:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8020df:	8b 10                	mov    (%eax),%edx
  8020e1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8020e4:	8b 40 04             	mov    0x4(%eax),%eax
  8020e7:	01 c2                	add    %eax,%edx
  8020e9:	a1 68 e0 81 00       	mov    0x81e068,%eax
  8020ee:	39 c2                	cmp    %eax,%edx
  8020f0:	75 44                	jne    802136 <free+0x38d>

			if(mergeprev){
  8020f2:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8020f6:	74 1f                	je     802117 <free+0x36e>
				uheapPageAllocBreak = MergedBlock->startva;
  8020f8:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8020fb:	8b 00                	mov    (%eax),%eax
  8020fd:	a3 68 e0 81 00       	mov    %eax,0x81e068
				release_uspinlock(&ulock);
  802102:	83 ec 0c             	sub    $0xc,%esp
  802105:	68 40 e1 81 00       	push   $0x81e140
  80210a:	e8 46 21 00 00       	call   804255 <release_uspinlock>
  80210f:	83 c4 10             	add    $0x10,%esp
				return;
  802112:	e9 20 04 00 00       	jmp    802537 <free+0x78e>

			}else{
				uheapPageAllocBreak = newfree->startva;
  802117:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80211a:	8b 00                	mov    (%eax),%eax
  80211c:	a3 68 e0 81 00       	mov    %eax,0x81e068
				release_uspinlock(&ulock);
  802121:	83 ec 0c             	sub    $0xc,%esp
  802124:	68 40 e1 81 00       	push   $0x81e140
  802129:	e8 27 21 00 00       	call   804255 <release_uspinlock>
  80212e:	83 c4 10             	add    $0x10,%esp
				return;
  802131:	e9 01 04 00 00       	jmp    802537 <free+0x78e>

		}


		//check if block is merged with prev ,and find possible merge with next
		ToBeMerged = LIST_FIRST(&u_freelist);
  802136:	a1 20 e1 81 00       	mov    0x81e120,%eax
  80213b:	89 45 ec             	mov    %eax,-0x14(%ebp)
		while(ToBeMerged != NULL){
  80213e:	e9 7d 01 00 00       	jmp    8022c0 <free+0x517>
			if ((newfree->startva + newfree->size) == ToBeMerged->startva ){
  802143:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802146:	8b 10                	mov    (%eax),%edx
  802148:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80214b:	8b 40 04             	mov    0x4(%eax),%eax
  80214e:	01 c2                	add    %eax,%edx
  802150:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802153:	8b 00                	mov    (%eax),%eax
  802155:	39 c2                	cmp    %eax,%edx
  802157:	0f 85 5a 01 00 00    	jne    8022b7 <free+0x50e>
				if (mergeprev){
  80215d:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802161:	0f 84 a1 00 00 00    	je     802208 <free+0x45f>
					MergedBlock->size += ToBeMerged->size;
  802167:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80216a:	8b 50 04             	mov    0x4(%eax),%edx
  80216d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802170:	8b 40 04             	mov    0x4(%eax),%eax
  802173:	01 c2                	add    %eax,%edx
  802175:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802178:	89 50 04             	mov    %edx,0x4(%eax)
					LIST_REMOVE(&u_freelist, ToBeMerged);
  80217b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80217f:	75 17                	jne    802198 <free+0x3ef>
  802181:	83 ec 04             	sub    $0x4,%esp
  802184:	68 1b 4f 80 00       	push   $0x804f1b
  802189:	68 0a 01 00 00       	push   $0x10a
  80218e:	68 ac 4e 80 00       	push   $0x804eac
  802193:	e8 2c e4 ff ff       	call   8005c4 <_panic>
  802198:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80219b:	8b 40 08             	mov    0x8(%eax),%eax
  80219e:	85 c0                	test   %eax,%eax
  8021a0:	74 11                	je     8021b3 <free+0x40a>
  8021a2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8021a5:	8b 40 08             	mov    0x8(%eax),%eax
  8021a8:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8021ab:	8b 52 0c             	mov    0xc(%edx),%edx
  8021ae:	89 50 0c             	mov    %edx,0xc(%eax)
  8021b1:	eb 0b                	jmp    8021be <free+0x415>
  8021b3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8021b6:	8b 40 0c             	mov    0xc(%eax),%eax
  8021b9:	a3 24 e1 81 00       	mov    %eax,0x81e124
  8021be:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8021c1:	8b 40 0c             	mov    0xc(%eax),%eax
  8021c4:	85 c0                	test   %eax,%eax
  8021c6:	74 11                	je     8021d9 <free+0x430>
  8021c8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8021cb:	8b 40 0c             	mov    0xc(%eax),%eax
  8021ce:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8021d1:	8b 52 08             	mov    0x8(%edx),%edx
  8021d4:	89 50 08             	mov    %edx,0x8(%eax)
  8021d7:	eb 0b                	jmp    8021e4 <free+0x43b>
  8021d9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8021dc:	8b 40 08             	mov    0x8(%eax),%eax
  8021df:	a3 20 e1 81 00       	mov    %eax,0x81e120
  8021e4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8021e7:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  8021ee:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8021f1:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  8021f8:	a1 2c e1 81 00       	mov    0x81e12c,%eax
  8021fd:	48                   	dec    %eax
  8021fe:	a3 2c e1 81 00       	mov    %eax,0x81e12c
					break;
  802203:	e9 c2 00 00 00       	jmp    8022ca <free+0x521>
		//if not merged find possible merge with next
				}else{
					MergedBlock->startva = newfree->startva;
  802208:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80220b:	8b 10                	mov    (%eax),%edx
  80220d:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802210:	89 10                	mov    %edx,(%eax)
					MergedBlock->size  = newfree->size + ToBeMerged->size;
  802212:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802215:	8b 50 04             	mov    0x4(%eax),%edx
  802218:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80221b:	8b 40 04             	mov    0x4(%eax),%eax
  80221e:	01 c2                	add    %eax,%edx
  802220:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802223:	89 50 04             	mov    %edx,0x4(%eax)
					LIST_REMOVE(&u_freelist, ToBeMerged);
  802226:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80222a:	75 17                	jne    802243 <free+0x49a>
  80222c:	83 ec 04             	sub    $0x4,%esp
  80222f:	68 1b 4f 80 00       	push   $0x804f1b
  802234:	68 10 01 00 00       	push   $0x110
  802239:	68 ac 4e 80 00       	push   $0x804eac
  80223e:	e8 81 e3 ff ff       	call   8005c4 <_panic>
  802243:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802246:	8b 40 08             	mov    0x8(%eax),%eax
  802249:	85 c0                	test   %eax,%eax
  80224b:	74 11                	je     80225e <free+0x4b5>
  80224d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802250:	8b 40 08             	mov    0x8(%eax),%eax
  802253:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802256:	8b 52 0c             	mov    0xc(%edx),%edx
  802259:	89 50 0c             	mov    %edx,0xc(%eax)
  80225c:	eb 0b                	jmp    802269 <free+0x4c0>
  80225e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802261:	8b 40 0c             	mov    0xc(%eax),%eax
  802264:	a3 24 e1 81 00       	mov    %eax,0x81e124
  802269:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80226c:	8b 40 0c             	mov    0xc(%eax),%eax
  80226f:	85 c0                	test   %eax,%eax
  802271:	74 11                	je     802284 <free+0x4db>
  802273:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802276:	8b 40 0c             	mov    0xc(%eax),%eax
  802279:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80227c:	8b 52 08             	mov    0x8(%edx),%edx
  80227f:	89 50 08             	mov    %edx,0x8(%eax)
  802282:	eb 0b                	jmp    80228f <free+0x4e6>
  802284:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802287:	8b 40 08             	mov    0x8(%eax),%eax
  80228a:	a3 20 e1 81 00       	mov    %eax,0x81e120
  80228f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802292:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802299:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80229c:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  8022a3:	a1 2c e1 81 00       	mov    0x81e12c,%eax
  8022a8:	48                   	dec    %eax
  8022a9:	a3 2c e1 81 00       	mov    %eax,0x81e12c
					mergenext = 1;
  8022ae:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
					break;
  8022b5:	eb 13                	jmp    8022ca <free+0x521>
				}
			}
			ToBeMerged = ToBeMerged->prev_next_info.le_next;
  8022b7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8022ba:	8b 40 08             	mov    0x8(%eax),%eax
  8022bd:	89 45 ec             	mov    %eax,-0x14(%ebp)
		}


		//check if block is merged with prev ,and find possible merge with next
		ToBeMerged = LIST_FIRST(&u_freelist);
		while(ToBeMerged != NULL){
  8022c0:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8022c4:	0f 85 79 fe ff ff    	jne    802143 <free+0x39a>




			// insertion
			struct UserHeapStruct* currentfree = LIST_FIRST(&u_freelist);
  8022ca:	a1 20 e1 81 00       	mov    0x81e120,%eax
  8022cf:	89 45 e0             	mov    %eax,-0x20(%ebp)

			if(mergeprev || mergenext){
  8022d2:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8022d6:	0f 85 ad 00 00 00    	jne    802389 <free+0x5e0>
  8022dc:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8022e0:	0f 84 c3 01 00 00    	je     8024a9 <free+0x700>
				while(currentfree != NULL){
  8022e6:	e9 9e 00 00 00       	jmp    802389 <free+0x5e0>
					if(MergedBlock->size < currentfree->size){
  8022eb:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8022ee:	8b 50 04             	mov    0x4(%eax),%edx
  8022f1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8022f4:	8b 40 04             	mov    0x4(%eax),%eax
  8022f7:	39 c2                	cmp    %eax,%edx
  8022f9:	0f 83 81 00 00 00    	jae    802380 <free+0x5d7>

							LIST_INSERT_BEFORE(&u_freelist,currentfree,MergedBlock);
  8022ff:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802303:	74 06                	je     80230b <free+0x562>
  802305:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  802309:	75 17                	jne    802322 <free+0x579>
  80230b:	83 ec 04             	sub    $0x4,%esp
  80230e:	68 3c 4f 80 00       	push   $0x804f3c
  802313:	68 23 01 00 00       	push   $0x123
  802318:	68 ac 4e 80 00       	push   $0x804eac
  80231d:	e8 a2 e2 ff ff       	call   8005c4 <_panic>
  802322:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802325:	8b 50 0c             	mov    0xc(%eax),%edx
  802328:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80232b:	89 50 0c             	mov    %edx,0xc(%eax)
  80232e:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802331:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802334:	89 50 08             	mov    %edx,0x8(%eax)
  802337:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80233a:	8b 40 0c             	mov    0xc(%eax),%eax
  80233d:	85 c0                	test   %eax,%eax
  80233f:	74 0e                	je     80234f <free+0x5a6>
  802341:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802344:	8b 40 0c             	mov    0xc(%eax),%eax
  802347:	8b 55 d0             	mov    -0x30(%ebp),%edx
  80234a:	89 50 08             	mov    %edx,0x8(%eax)
  80234d:	eb 08                	jmp    802357 <free+0x5ae>
  80234f:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802352:	a3 20 e1 81 00       	mov    %eax,0x81e120
  802357:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80235a:	8b 55 d0             	mov    -0x30(%ebp),%edx
  80235d:	89 50 0c             	mov    %edx,0xc(%eax)
  802360:	a1 2c e1 81 00       	mov    0x81e12c,%eax
  802365:	40                   	inc    %eax
  802366:	a3 2c e1 81 00       	mov    %eax,0x81e12c
							release_uspinlock(&ulock);
  80236b:	83 ec 0c             	sub    $0xc,%esp
  80236e:	68 40 e1 81 00       	push   $0x81e140
  802373:	e8 dd 1e 00 00       	call   804255 <release_uspinlock>
  802378:	83 c4 10             	add    $0x10,%esp
							return;
  80237b:	e9 b7 01 00 00       	jmp    802537 <free+0x78e>
					}
							currentfree = currentfree->prev_next_info.le_next;
  802380:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802383:	8b 40 08             	mov    0x8(%eax),%eax
  802386:	89 45 e0             	mov    %eax,-0x20(%ebp)

			// insertion
			struct UserHeapStruct* currentfree = LIST_FIRST(&u_freelist);

			if(mergeprev || mergenext){
				while(currentfree != NULL){
  802389:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80238d:	0f 85 58 ff ff ff    	jne    8022eb <free+0x542>
							release_uspinlock(&ulock);
							return;
					}
							currentfree = currentfree->prev_next_info.le_next;
				}
				free_block(newfree);
  802393:	83 ec 0c             	sub    $0xc,%esp
  802396:	ff 75 d4             	pushl  -0x2c(%ebp)
  802399:	e8 d5 19 00 00       	call   803d73 <free_block>
  80239e:	83 c4 10             	add    $0x10,%esp
				LIST_INSERT_TAIL(&u_freelist,MergedBlock);
  8023a1:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  8023a5:	75 17                	jne    8023be <free+0x615>
  8023a7:	83 ec 04             	sub    $0x4,%esp
  8023aa:	68 f8 4e 80 00       	push   $0x804ef8
  8023af:	68 2a 01 00 00       	push   $0x12a
  8023b4:	68 ac 4e 80 00       	push   $0x804eac
  8023b9:	e8 06 e2 ff ff       	call   8005c4 <_panic>
  8023be:	8b 15 24 e1 81 00    	mov    0x81e124,%edx
  8023c4:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8023c7:	89 50 0c             	mov    %edx,0xc(%eax)
  8023ca:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8023cd:	8b 40 0c             	mov    0xc(%eax),%eax
  8023d0:	85 c0                	test   %eax,%eax
  8023d2:	74 0d                	je     8023e1 <free+0x638>
  8023d4:	a1 24 e1 81 00       	mov    0x81e124,%eax
  8023d9:	8b 55 d0             	mov    -0x30(%ebp),%edx
  8023dc:	89 50 08             	mov    %edx,0x8(%eax)
  8023df:	eb 08                	jmp    8023e9 <free+0x640>
  8023e1:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8023e4:	a3 20 e1 81 00       	mov    %eax,0x81e120
  8023e9:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8023ec:	a3 24 e1 81 00       	mov    %eax,0x81e124
  8023f1:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8023f4:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  8023fb:	a1 2c e1 81 00       	mov    0x81e12c,%eax
  802400:	40                   	inc    %eax
  802401:	a3 2c e1 81 00       	mov    %eax,0x81e12c
  802406:	e9 1b 01 00 00       	jmp    802526 <free+0x77d>

			}else{
				while(currentfree != NULL){
					if(newfree->size < currentfree->size){
  80240b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80240e:	8b 50 04             	mov    0x4(%eax),%edx
  802411:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802414:	8b 40 04             	mov    0x4(%eax),%eax
  802417:	39 c2                	cmp    %eax,%edx
  802419:	0f 83 81 00 00 00    	jae    8024a0 <free+0x6f7>

							LIST_INSERT_BEFORE(&u_freelist,currentfree,newfree);
  80241f:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802423:	74 06                	je     80242b <free+0x682>
  802425:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  802429:	75 17                	jne    802442 <free+0x699>
  80242b:	83 ec 04             	sub    $0x4,%esp
  80242e:	68 3c 4f 80 00       	push   $0x804f3c
  802433:	68 30 01 00 00       	push   $0x130
  802438:	68 ac 4e 80 00       	push   $0x804eac
  80243d:	e8 82 e1 ff ff       	call   8005c4 <_panic>
  802442:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802445:	8b 50 0c             	mov    0xc(%eax),%edx
  802448:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80244b:	89 50 0c             	mov    %edx,0xc(%eax)
  80244e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802451:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802454:	89 50 08             	mov    %edx,0x8(%eax)
  802457:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80245a:	8b 40 0c             	mov    0xc(%eax),%eax
  80245d:	85 c0                	test   %eax,%eax
  80245f:	74 0e                	je     80246f <free+0x6c6>
  802461:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802464:	8b 40 0c             	mov    0xc(%eax),%eax
  802467:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80246a:	89 50 08             	mov    %edx,0x8(%eax)
  80246d:	eb 08                	jmp    802477 <free+0x6ce>
  80246f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802472:	a3 20 e1 81 00       	mov    %eax,0x81e120
  802477:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80247a:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80247d:	89 50 0c             	mov    %edx,0xc(%eax)
  802480:	a1 2c e1 81 00       	mov    0x81e12c,%eax
  802485:	40                   	inc    %eax
  802486:	a3 2c e1 81 00       	mov    %eax,0x81e12c
							release_uspinlock(&ulock);
  80248b:	83 ec 0c             	sub    $0xc,%esp
  80248e:	68 40 e1 81 00       	push   $0x81e140
  802493:	e8 bd 1d 00 00       	call   804255 <release_uspinlock>
  802498:	83 c4 10             	add    $0x10,%esp
							return;
  80249b:	e9 97 00 00 00       	jmp    802537 <free+0x78e>
					}
							currentfree = currentfree->prev_next_info.le_next;
  8024a0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8024a3:	8b 40 08             	mov    0x8(%eax),%eax
  8024a6:	89 45 e0             	mov    %eax,-0x20(%ebp)
				}
				free_block(newfree);
				LIST_INSERT_TAIL(&u_freelist,MergedBlock);

			}else{
				while(currentfree != NULL){
  8024a9:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8024ad:	0f 85 58 ff ff ff    	jne    80240b <free+0x662>
							release_uspinlock(&ulock);
							return;
					}
							currentfree = currentfree->prev_next_info.le_next;
				}
				free_block(MergedBlock);
  8024b3:	83 ec 0c             	sub    $0xc,%esp
  8024b6:	ff 75 d0             	pushl  -0x30(%ebp)
  8024b9:	e8 b5 18 00 00       	call   803d73 <free_block>
  8024be:	83 c4 10             	add    $0x10,%esp
				LIST_INSERT_TAIL(&u_freelist,newfree);
  8024c1:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8024c5:	75 17                	jne    8024de <free+0x735>
  8024c7:	83 ec 04             	sub    $0x4,%esp
  8024ca:	68 f8 4e 80 00       	push   $0x804ef8
  8024cf:	68 37 01 00 00       	push   $0x137
  8024d4:	68 ac 4e 80 00       	push   $0x804eac
  8024d9:	e8 e6 e0 ff ff       	call   8005c4 <_panic>
  8024de:	8b 15 24 e1 81 00    	mov    0x81e124,%edx
  8024e4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8024e7:	89 50 0c             	mov    %edx,0xc(%eax)
  8024ea:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8024ed:	8b 40 0c             	mov    0xc(%eax),%eax
  8024f0:	85 c0                	test   %eax,%eax
  8024f2:	74 0d                	je     802501 <free+0x758>
  8024f4:	a1 24 e1 81 00       	mov    0x81e124,%eax
  8024f9:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8024fc:	89 50 08             	mov    %edx,0x8(%eax)
  8024ff:	eb 08                	jmp    802509 <free+0x760>
  802501:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802504:	a3 20 e1 81 00       	mov    %eax,0x81e120
  802509:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80250c:	a3 24 e1 81 00       	mov    %eax,0x81e124
  802511:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802514:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  80251b:	a1 2c e1 81 00       	mov    0x81e12c,%eax
  802520:	40                   	inc    %eax
  802521:	a3 2c e1 81 00       	mov    %eax,0x81e12c
			}
		release_uspinlock(&ulock);
  802526:	83 ec 0c             	sub    $0xc,%esp
  802529:	68 40 e1 81 00       	push   $0x81e140
  80252e:	e8 22 1d 00 00       	call   804255 <release_uspinlock>
  802533:	83 c4 10             	add    $0x10,%esp
		return;
  802536:	90                   	nop
}
  802537:	c9                   	leave  
  802538:	c3                   	ret    

00802539 <smalloc>:

//=================================
// [3] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  802539:	55                   	push   %ebp
  80253a:	89 e5                	mov    %esp,%ebp
  80253c:	83 ec 48             	sub    $0x48,%esp
  80253f:	8b 45 10             	mov    0x10(%ebp),%eax
  802542:	88 45 c4             	mov    %al,-0x3c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  802545:	e8 2d f2 ff ff       	call   801777 <uheap_init>
	if (size == 0) return NULL;
  80254a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80254e:	75 0a                	jne    80255a <smalloc+0x21>
  802550:	b8 00 00 00 00       	mov    $0x0,%eax
  802555:	e9 84 05 00 00       	jmp    802ade <smalloc+0x5a5>
	//==============================================================
	acquire_uspinlock(&ulock);
  80255a:	83 ec 0c             	sub    $0xc,%esp
  80255d:	68 40 e1 81 00       	push   $0x81e140
  802562:	e8 96 1c 00 00       	call   8041fd <acquire_uspinlock>
  802567:	83 c4 10             	add    $0x10,%esp

	struct UserHeapStruct* allocblock = (struct UserHeapStruct*) alloc_block(sizeof(struct UserHeapStruct));
  80256a:	83 ec 0c             	sub    $0xc,%esp
  80256d:	6a 10                	push   $0x10
  80256f:	e8 63 13 00 00       	call   8038d7 <alloc_block>
  802574:	83 c4 10             	add    $0x10,%esp
  802577:	89 45 ec             	mov    %eax,-0x14(%ebp)
	if (allocblock == NULL){
  80257a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80257e:	75 0a                	jne    80258a <smalloc+0x51>
				return NULL;
  802580:	b8 00 00 00 00       	mov    $0x0,%eax
  802585:	e9 54 05 00 00       	jmp    802ade <smalloc+0x5a5>
	}
		size = ROUNDUP(size,PAGE_SIZE);
  80258a:	c7 45 e8 00 10 00 00 	movl   $0x1000,-0x18(%ebp)
  802591:	8b 55 0c             	mov    0xc(%ebp),%edx
  802594:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802597:	01 d0                	add    %edx,%eax
  802599:	48                   	dec    %eax
  80259a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80259d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8025a0:	ba 00 00 00 00       	mov    $0x0,%edx
  8025a5:	f7 75 e8             	divl   -0x18(%ebp)
  8025a8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8025ab:	29 d0                	sub    %edx,%eax
  8025ad:	89 45 0c             	mov    %eax,0xc(%ebp)
		struct UserHeapStruct* lastfreeelement = LIST_LAST(&u_freelist);
  8025b0:	a1 24 e1 81 00       	mov    0x81e124,%eax
  8025b5:	89 45 e0             	mov    %eax,-0x20(%ebp)

		if(LIST_SIZE(&u_freelist)==0 || size>lastfreeelement->size){
  8025b8:	a1 2c e1 81 00       	mov    0x81e12c,%eax
  8025bd:	85 c0                	test   %eax,%eax
  8025bf:	74 0f                	je     8025d0 <smalloc+0x97>
  8025c1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8025c4:	8b 40 04             	mov    0x4(%eax),%eax
  8025c7:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8025ca:	0f 83 25 01 00 00    	jae    8026f5 <smalloc+0x1bc>
				if(uheapPageAllocBreak <= USER_HEAP_MAX - size){
  8025d0:	b8 00 00 00 a0       	mov    $0xa0000000,%eax
  8025d5:	2b 45 0c             	sub    0xc(%ebp),%eax
  8025d8:	89 c2                	mov    %eax,%edx
  8025da:	a1 68 e0 81 00       	mov    0x81e068,%eax
  8025df:	39 c2                	cmp    %eax,%edx
  8025e1:	0f 82 f4 00 00 00    	jb     8026db <smalloc+0x1a2>
						uint32 requestedblockva = uheapPageAllocBreak;
  8025e7:	a1 68 e0 81 00       	mov    0x81e068,%eax
  8025ec:	89 45 d4             	mov    %eax,-0x2c(%ebp)
						uheapPageAllocBreak+=size;
  8025ef:	8b 15 68 e0 81 00    	mov    0x81e068,%edx
  8025f5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8025f8:	01 d0                	add    %edx,%eax
  8025fa:	a3 68 e0 81 00       	mov    %eax,0x81e068
						allocblock->startva = requestedblockva;
  8025ff:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802602:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802605:	89 10                	mov    %edx,(%eax)
						allocblock->size = size;
  802607:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80260a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80260d:	89 50 04             	mov    %edx,0x4(%eax)

						LIST_INSERT_TAIL(&u_allocatedlist, allocblock);
  802610:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802614:	75 17                	jne    80262d <smalloc+0xf4>
  802616:	83 ec 04             	sub    $0x4,%esp
  802619:	68 f8 4e 80 00       	push   $0x804ef8
  80261e:	68 57 01 00 00       	push   $0x157
  802623:	68 ac 4e 80 00       	push   $0x804eac
  802628:	e8 97 df ff ff       	call   8005c4 <_panic>
  80262d:	8b 15 34 e1 81 00    	mov    0x81e134,%edx
  802633:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802636:	89 50 0c             	mov    %edx,0xc(%eax)
  802639:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80263c:	8b 40 0c             	mov    0xc(%eax),%eax
  80263f:	85 c0                	test   %eax,%eax
  802641:	74 0d                	je     802650 <smalloc+0x117>
  802643:	a1 34 e1 81 00       	mov    0x81e134,%eax
  802648:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80264b:	89 50 08             	mov    %edx,0x8(%eax)
  80264e:	eb 08                	jmp    802658 <smalloc+0x11f>
  802650:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802653:	a3 30 e1 81 00       	mov    %eax,0x81e130
  802658:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80265b:	a3 34 e1 81 00       	mov    %eax,0x81e134
  802660:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802663:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  80266a:	a1 3c e1 81 00       	mov    0x81e13c,%eax
  80266f:	40                   	inc    %eax
  802670:	a3 3c e1 81 00       	mov    %eax,0x81e13c


						int result = sys_create_shared_object(sharedVarName ,size ,isWritable ,(void*)allocblock->startva);
  802675:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802678:	8b 00                	mov    (%eax),%eax
  80267a:	89 c2                	mov    %eax,%edx
  80267c:	0f b6 45 c4          	movzbl -0x3c(%ebp),%eax
  802680:	52                   	push   %edx
  802681:	50                   	push   %eax
  802682:	ff 75 0c             	pushl  0xc(%ebp)
  802685:	ff 75 08             	pushl  0x8(%ebp)
  802688:	e8 48 0c 00 00       	call   8032d5 <sys_create_shared_object>
  80268d:	83 c4 10             	add    $0x10,%esp
  802690:	89 45 d0             	mov    %eax,-0x30(%ebp)

						if(result <0){
  802693:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  802697:	79 28                	jns    8026c1 <smalloc+0x188>
							free_block(allocblock);
  802699:	83 ec 0c             	sub    $0xc,%esp
  80269c:	ff 75 ec             	pushl  -0x14(%ebp)
  80269f:	e8 cf 16 00 00       	call   803d73 <free_block>
  8026a4:	83 c4 10             	add    $0x10,%esp
							release_uspinlock(&ulock);
  8026a7:	83 ec 0c             	sub    $0xc,%esp
  8026aa:	68 40 e1 81 00       	push   $0x81e140
  8026af:	e8 a1 1b 00 00       	call   804255 <release_uspinlock>
  8026b4:	83 c4 10             	add    $0x10,%esp
							return NULL;
  8026b7:	b8 00 00 00 00       	mov    $0x0,%eax
  8026bc:	e9 1d 04 00 00       	jmp    802ade <smalloc+0x5a5>
						}
						release_uspinlock(&ulock);
  8026c1:	83 ec 0c             	sub    $0xc,%esp
  8026c4:	68 40 e1 81 00       	push   $0x81e140
  8026c9:	e8 87 1b 00 00       	call   804255 <release_uspinlock>
  8026ce:	83 c4 10             	add    $0x10,%esp
						return (void*)allocblock -> startva;
  8026d1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026d4:	8b 00                	mov    (%eax),%eax
  8026d6:	e9 03 04 00 00       	jmp    802ade <smalloc+0x5a5>
				}else{
						release_uspinlock(&ulock);
  8026db:	83 ec 0c             	sub    $0xc,%esp
  8026de:	68 40 e1 81 00       	push   $0x81e140
  8026e3:	e8 6d 1b 00 00       	call   804255 <release_uspinlock>
  8026e8:	83 c4 10             	add    $0x10,%esp
						return NULL;
  8026eb:	b8 00 00 00 00       	mov    $0x0,%eax
  8026f0:	e9 e9 03 00 00       	jmp    802ade <smalloc+0x5a5>
					 }
		}else{
			//custom fit
			struct UserHeapStruct* currentfreeelement = LIST_FIRST(&u_freelist);
  8026f5:	a1 20 e1 81 00       	mov    0x81e120,%eax
  8026fa:	89 45 f4             	mov    %eax,-0xc(%ebp)
			//worst fit
			while(currentfreeelement != NULL){
  8026fd:	e9 af 03 00 00       	jmp    802ab1 <smalloc+0x578>
				if(size<currentfreeelement->size){
  802702:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802705:	8b 40 04             	mov    0x4(%eax),%eax
  802708:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80270b:	0f 86 28 02 00 00    	jbe    802939 <smalloc+0x400>
					allocblock->startva = lastfreeelement->startva;
  802711:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802714:	8b 10                	mov    (%eax),%edx
  802716:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802719:	89 10                	mov    %edx,(%eax)
	                allocblock->size = size;
  80271b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80271e:	8b 55 0c             	mov    0xc(%ebp),%edx
  802721:	89 50 04             	mov    %edx,0x4(%eax)
	                LIST_INSERT_TAIL(&u_allocatedlist,allocblock);
  802724:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802728:	75 17                	jne    802741 <smalloc+0x208>
  80272a:	83 ec 04             	sub    $0x4,%esp
  80272d:	68 f8 4e 80 00       	push   $0x804ef8
  802732:	68 6f 01 00 00       	push   $0x16f
  802737:	68 ac 4e 80 00       	push   $0x804eac
  80273c:	e8 83 de ff ff       	call   8005c4 <_panic>
  802741:	8b 15 34 e1 81 00    	mov    0x81e134,%edx
  802747:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80274a:	89 50 0c             	mov    %edx,0xc(%eax)
  80274d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802750:	8b 40 0c             	mov    0xc(%eax),%eax
  802753:	85 c0                	test   %eax,%eax
  802755:	74 0d                	je     802764 <smalloc+0x22b>
  802757:	a1 34 e1 81 00       	mov    0x81e134,%eax
  80275c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80275f:	89 50 08             	mov    %edx,0x8(%eax)
  802762:	eb 08                	jmp    80276c <smalloc+0x233>
  802764:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802767:	a3 30 e1 81 00       	mov    %eax,0x81e130
  80276c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80276f:	a3 34 e1 81 00       	mov    %eax,0x81e134
  802774:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802777:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  80277e:	a1 3c e1 81 00       	mov    0x81e13c,%eax
  802783:	40                   	inc    %eax
  802784:	a3 3c e1 81 00       	mov    %eax,0x81e13c
	                lastfreeelement->startva += size;
  802789:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80278c:	8b 10                	mov    (%eax),%edx
  80278e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802791:	01 c2                	add    %eax,%edx
  802793:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802796:	89 10                	mov    %edx,(%eax)
	                lastfreeelement->size -= size;
  802798:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80279b:	8b 40 04             	mov    0x4(%eax),%eax
  80279e:	2b 45 0c             	sub    0xc(%ebp),%eax
  8027a1:	89 c2                	mov    %eax,%edx
  8027a3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8027a6:	89 50 04             	mov    %edx,0x4(%eax)
	                struct UserHeapStruct* currentfree2 = LIST_FIRST(&u_freelist);
  8027a9:	a1 20 e1 81 00       	mov    0x81e120,%eax
  8027ae:	89 45 f0             	mov    %eax,-0x10(%ebp)
	                //check order of last element

	                while (currentfree2 != NULL){
  8027b1:	e9 13 01 00 00       	jmp    8028c9 <smalloc+0x390>
	                	if(lastfreeelement->size <currentfree2->size){
  8027b6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8027b9:	8b 50 04             	mov    0x4(%eax),%edx
  8027bc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027bf:	8b 40 04             	mov    0x4(%eax),%eax
  8027c2:	39 c2                	cmp    %eax,%edx
  8027c4:	0f 83 f6 00 00 00    	jae    8028c0 <smalloc+0x387>
	                		LIST_REMOVE(&u_freelist ,lastfreeelement);
  8027ca:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8027ce:	75 17                	jne    8027e7 <smalloc+0x2ae>
  8027d0:	83 ec 04             	sub    $0x4,%esp
  8027d3:	68 1b 4f 80 00       	push   $0x804f1b
  8027d8:	68 77 01 00 00       	push   $0x177
  8027dd:	68 ac 4e 80 00       	push   $0x804eac
  8027e2:	e8 dd dd ff ff       	call   8005c4 <_panic>
  8027e7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8027ea:	8b 40 08             	mov    0x8(%eax),%eax
  8027ed:	85 c0                	test   %eax,%eax
  8027ef:	74 11                	je     802802 <smalloc+0x2c9>
  8027f1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8027f4:	8b 40 08             	mov    0x8(%eax),%eax
  8027f7:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8027fa:	8b 52 0c             	mov    0xc(%edx),%edx
  8027fd:	89 50 0c             	mov    %edx,0xc(%eax)
  802800:	eb 0b                	jmp    80280d <smalloc+0x2d4>
  802802:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802805:	8b 40 0c             	mov    0xc(%eax),%eax
  802808:	a3 24 e1 81 00       	mov    %eax,0x81e124
  80280d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802810:	8b 40 0c             	mov    0xc(%eax),%eax
  802813:	85 c0                	test   %eax,%eax
  802815:	74 11                	je     802828 <smalloc+0x2ef>
  802817:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80281a:	8b 40 0c             	mov    0xc(%eax),%eax
  80281d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802820:	8b 52 08             	mov    0x8(%edx),%edx
  802823:	89 50 08             	mov    %edx,0x8(%eax)
  802826:	eb 0b                	jmp    802833 <smalloc+0x2fa>
  802828:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80282b:	8b 40 08             	mov    0x8(%eax),%eax
  80282e:	a3 20 e1 81 00       	mov    %eax,0x81e120
  802833:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802836:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  80283d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802840:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  802847:	a1 2c e1 81 00       	mov    0x81e12c,%eax
  80284c:	48                   	dec    %eax
  80284d:	a3 2c e1 81 00       	mov    %eax,0x81e12c
	                		LIST_INSERT_BEFORE(&u_freelist ,currentfree2 ,lastfreeelement);
  802852:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802856:	74 06                	je     80285e <smalloc+0x325>
  802858:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80285c:	75 17                	jne    802875 <smalloc+0x33c>
  80285e:	83 ec 04             	sub    $0x4,%esp
  802861:	68 3c 4f 80 00       	push   $0x804f3c
  802866:	68 78 01 00 00       	push   $0x178
  80286b:	68 ac 4e 80 00       	push   $0x804eac
  802870:	e8 4f dd ff ff       	call   8005c4 <_panic>
  802875:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802878:	8b 50 0c             	mov    0xc(%eax),%edx
  80287b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80287e:	89 50 0c             	mov    %edx,0xc(%eax)
  802881:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802884:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802887:	89 50 08             	mov    %edx,0x8(%eax)
  80288a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80288d:	8b 40 0c             	mov    0xc(%eax),%eax
  802890:	85 c0                	test   %eax,%eax
  802892:	74 0e                	je     8028a2 <smalloc+0x369>
  802894:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802897:	8b 40 0c             	mov    0xc(%eax),%eax
  80289a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80289d:	89 50 08             	mov    %edx,0x8(%eax)
  8028a0:	eb 08                	jmp    8028aa <smalloc+0x371>
  8028a2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8028a5:	a3 20 e1 81 00       	mov    %eax,0x81e120
  8028aa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028ad:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8028b0:	89 50 0c             	mov    %edx,0xc(%eax)
  8028b3:	a1 2c e1 81 00       	mov    0x81e12c,%eax
  8028b8:	40                   	inc    %eax
  8028b9:	a3 2c e1 81 00       	mov    %eax,0x81e12c
	                		break;
  8028be:	eb 13                	jmp    8028d3 <smalloc+0x39a>
	                	}
	                	currentfree2 = currentfree2->prev_next_info.le_next;
  8028c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028c3:	8b 40 08             	mov    0x8(%eax),%eax
  8028c6:	89 45 f0             	mov    %eax,-0x10(%ebp)
	                lastfreeelement->startva += size;
	                lastfreeelement->size -= size;
	                struct UserHeapStruct* currentfree2 = LIST_FIRST(&u_freelist);
	                //check order of last element

	                while (currentfree2 != NULL){
  8028c9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8028cd:	0f 85 e3 fe ff ff    	jne    8027b6 <smalloc+0x27d>
	                	}
	                	currentfree2 = currentfree2->prev_next_info.le_next;
	                }


	                int result = sys_create_shared_object(sharedVarName ,size ,isWritable ,(void*)allocblock->startva);
  8028d3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028d6:	8b 00                	mov    (%eax),%eax
  8028d8:	89 c2                	mov    %eax,%edx
  8028da:	0f b6 45 c4          	movzbl -0x3c(%ebp),%eax
  8028de:	52                   	push   %edx
  8028df:	50                   	push   %eax
  8028e0:	ff 75 0c             	pushl  0xc(%ebp)
  8028e3:	ff 75 08             	pushl  0x8(%ebp)
  8028e6:	e8 ea 09 00 00       	call   8032d5 <sys_create_shared_object>
  8028eb:	83 c4 10             	add    $0x10,%esp
  8028ee:	89 45 d8             	mov    %eax,-0x28(%ebp)

	                if(result <0){
  8028f1:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8028f5:	79 28                	jns    80291f <smalloc+0x3e6>
	                	free_block(allocblock);
  8028f7:	83 ec 0c             	sub    $0xc,%esp
  8028fa:	ff 75 ec             	pushl  -0x14(%ebp)
  8028fd:	e8 71 14 00 00       	call   803d73 <free_block>
  802902:	83 c4 10             	add    $0x10,%esp
	                	release_uspinlock(&ulock);
  802905:	83 ec 0c             	sub    $0xc,%esp
  802908:	68 40 e1 81 00       	push   $0x81e140
  80290d:	e8 43 19 00 00       	call   804255 <release_uspinlock>
  802912:	83 c4 10             	add    $0x10,%esp
	                	return NULL;
  802915:	b8 00 00 00 00       	mov    $0x0,%eax
  80291a:	e9 bf 01 00 00       	jmp    802ade <smalloc+0x5a5>
	                }
	                release_uspinlock(&ulock);
  80291f:	83 ec 0c             	sub    $0xc,%esp
  802922:	68 40 e1 81 00       	push   $0x81e140
  802927:	e8 29 19 00 00       	call   804255 <release_uspinlock>
  80292c:	83 c4 10             	add    $0x10,%esp
	                return (void*)allocblock->startva;
  80292f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802932:	8b 00                	mov    (%eax),%eax
  802934:	e9 a5 01 00 00       	jmp    802ade <smalloc+0x5a5>
	                //exact fit
				}else if(size == currentfreeelement->size){
  802939:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80293c:	8b 40 04             	mov    0x4(%eax),%eax
  80293f:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802942:	0f 85 60 01 00 00    	jne    802aa8 <smalloc+0x56f>
					allocblock->startva = currentfreeelement->startva;
  802948:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80294b:	8b 10                	mov    (%eax),%edx
  80294d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802950:	89 10                	mov    %edx,(%eax)
					allocblock->size = size;
  802952:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802955:	8b 55 0c             	mov    0xc(%ebp),%edx
  802958:	89 50 04             	mov    %edx,0x4(%eax)
					LIST_INSERT_TAIL(&u_allocatedlist ,allocblock);
  80295b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80295f:	75 17                	jne    802978 <smalloc+0x43f>
  802961:	83 ec 04             	sub    $0x4,%esp
  802964:	68 f8 4e 80 00       	push   $0x804ef8
  802969:	68 8c 01 00 00       	push   $0x18c
  80296e:	68 ac 4e 80 00       	push   $0x804eac
  802973:	e8 4c dc ff ff       	call   8005c4 <_panic>
  802978:	8b 15 34 e1 81 00    	mov    0x81e134,%edx
  80297e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802981:	89 50 0c             	mov    %edx,0xc(%eax)
  802984:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802987:	8b 40 0c             	mov    0xc(%eax),%eax
  80298a:	85 c0                	test   %eax,%eax
  80298c:	74 0d                	je     80299b <smalloc+0x462>
  80298e:	a1 34 e1 81 00       	mov    0x81e134,%eax
  802993:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802996:	89 50 08             	mov    %edx,0x8(%eax)
  802999:	eb 08                	jmp    8029a3 <smalloc+0x46a>
  80299b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80299e:	a3 30 e1 81 00       	mov    %eax,0x81e130
  8029a3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029a6:	a3 34 e1 81 00       	mov    %eax,0x81e134
  8029ab:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029ae:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  8029b5:	a1 3c e1 81 00       	mov    0x81e13c,%eax
  8029ba:	40                   	inc    %eax
  8029bb:	a3 3c e1 81 00       	mov    %eax,0x81e13c
					LIST_REMOVE(&u_freelist ,currentfreeelement);
  8029c0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029c4:	75 17                	jne    8029dd <smalloc+0x4a4>
  8029c6:	83 ec 04             	sub    $0x4,%esp
  8029c9:	68 1b 4f 80 00       	push   $0x804f1b
  8029ce:	68 8d 01 00 00       	push   $0x18d
  8029d3:	68 ac 4e 80 00       	push   $0x804eac
  8029d8:	e8 e7 db ff ff       	call   8005c4 <_panic>
  8029dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029e0:	8b 40 08             	mov    0x8(%eax),%eax
  8029e3:	85 c0                	test   %eax,%eax
  8029e5:	74 11                	je     8029f8 <smalloc+0x4bf>
  8029e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029ea:	8b 40 08             	mov    0x8(%eax),%eax
  8029ed:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8029f0:	8b 52 0c             	mov    0xc(%edx),%edx
  8029f3:	89 50 0c             	mov    %edx,0xc(%eax)
  8029f6:	eb 0b                	jmp    802a03 <smalloc+0x4ca>
  8029f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029fb:	8b 40 0c             	mov    0xc(%eax),%eax
  8029fe:	a3 24 e1 81 00       	mov    %eax,0x81e124
  802a03:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a06:	8b 40 0c             	mov    0xc(%eax),%eax
  802a09:	85 c0                	test   %eax,%eax
  802a0b:	74 11                	je     802a1e <smalloc+0x4e5>
  802a0d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a10:	8b 40 0c             	mov    0xc(%eax),%eax
  802a13:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a16:	8b 52 08             	mov    0x8(%edx),%edx
  802a19:	89 50 08             	mov    %edx,0x8(%eax)
  802a1c:	eb 0b                	jmp    802a29 <smalloc+0x4f0>
  802a1e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a21:	8b 40 08             	mov    0x8(%eax),%eax
  802a24:	a3 20 e1 81 00       	mov    %eax,0x81e120
  802a29:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a2c:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802a33:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a36:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  802a3d:	a1 2c e1 81 00       	mov    0x81e12c,%eax
  802a42:	48                   	dec    %eax
  802a43:	a3 2c e1 81 00       	mov    %eax,0x81e12c
					int result = sys_create_shared_object(sharedVarName ,size ,isWritable ,(void*)allocblock->startva);
  802a48:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a4b:	8b 00                	mov    (%eax),%eax
  802a4d:	89 c2                	mov    %eax,%edx
  802a4f:	0f b6 45 c4          	movzbl -0x3c(%ebp),%eax
  802a53:	52                   	push   %edx
  802a54:	50                   	push   %eax
  802a55:	ff 75 0c             	pushl  0xc(%ebp)
  802a58:	ff 75 08             	pushl  0x8(%ebp)
  802a5b:	e8 75 08 00 00       	call   8032d5 <sys_create_shared_object>
  802a60:	83 c4 10             	add    $0x10,%esp
  802a63:	89 45 dc             	mov    %eax,-0x24(%ebp)

					if(result <0){
  802a66:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802a6a:	79 25                	jns    802a91 <smalloc+0x558>
						free_block(allocblock);
  802a6c:	83 ec 0c             	sub    $0xc,%esp
  802a6f:	ff 75 ec             	pushl  -0x14(%ebp)
  802a72:	e8 fc 12 00 00       	call   803d73 <free_block>
  802a77:	83 c4 10             	add    $0x10,%esp
						release_uspinlock(&ulock);
  802a7a:	83 ec 0c             	sub    $0xc,%esp
  802a7d:	68 40 e1 81 00       	push   $0x81e140
  802a82:	e8 ce 17 00 00       	call   804255 <release_uspinlock>
  802a87:	83 c4 10             	add    $0x10,%esp
						return NULL;
  802a8a:	b8 00 00 00 00       	mov    $0x0,%eax
  802a8f:	eb 4d                	jmp    802ade <smalloc+0x5a5>
					}
					release_uspinlock(&ulock);
  802a91:	83 ec 0c             	sub    $0xc,%esp
  802a94:	68 40 e1 81 00       	push   $0x81e140
  802a99:	e8 b7 17 00 00       	call   804255 <release_uspinlock>
  802a9e:	83 c4 10             	add    $0x10,%esp
					return (void*)allocblock->startva;
  802aa1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802aa4:	8b 00                	mov    (%eax),%eax
  802aa6:	eb 36                	jmp    802ade <smalloc+0x5a5>
				}
				currentfreeelement = currentfreeelement->prev_next_info.le_next;
  802aa8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aab:	8b 40 08             	mov    0x8(%eax),%eax
  802aae:	89 45 f4             	mov    %eax,-0xc(%ebp)
					 }
		}else{
			//custom fit
			struct UserHeapStruct* currentfreeelement = LIST_FIRST(&u_freelist);
			//worst fit
			while(currentfreeelement != NULL){
  802ab1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ab5:	0f 85 47 fc ff ff    	jne    802702 <smalloc+0x1c9>
					return (void*)allocblock->startva;
				}
				currentfreeelement = currentfreeelement->prev_next_info.le_next;
			}
		}
		free_block(allocblock);
  802abb:	83 ec 0c             	sub    $0xc,%esp
  802abe:	ff 75 ec             	pushl  -0x14(%ebp)
  802ac1:	e8 ad 12 00 00       	call   803d73 <free_block>
  802ac6:	83 c4 10             	add    $0x10,%esp
		release_uspinlock(&ulock);
  802ac9:	83 ec 0c             	sub    $0xc,%esp
  802acc:	68 40 e1 81 00       	push   $0x81e140
  802ad1:	e8 7f 17 00 00       	call   804255 <release_uspinlock>
  802ad6:	83 c4 10             	add    $0x10,%esp
		return NULL;
  802ad9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802ade:	c9                   	leave  
  802adf:	c3                   	ret    

00802ae0 <sget>:

//========================================
// [4] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  802ae0:	55                   	push   %ebp
  802ae1:	89 e5                	mov    %esp,%ebp
  802ae3:	83 ec 38             	sub    $0x38,%esp


	 //==============================================================
	 // DON'T CHANGE THIS CODE
	    uheap_init();
  802ae6:	e8 8c ec ff ff       	call   801777 <uheap_init>
	 //==============================================================
	 // Get size of the shared variable from kernel
	acquire_uspinlock(&ulock);
  802aeb:	83 ec 0c             	sub    $0xc,%esp
  802aee:	68 40 e1 81 00       	push   $0x81e140
  802af3:	e8 05 17 00 00       	call   8041fd <acquire_uspinlock>
  802af8:	83 c4 10             	add    $0x10,%esp


	int size = sys_size_of_shared_object(ownerEnvID ,sharedVarName);
  802afb:	83 ec 08             	sub    $0x8,%esp
  802afe:	ff 75 0c             	pushl  0xc(%ebp)
  802b01:	ff 75 08             	pushl  0x8(%ebp)
  802b04:	e8 f6 07 00 00       	call   8032ff <sys_size_of_shared_object>
  802b09:	83 c4 10             	add    $0x10,%esp
  802b0c:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if ( size < 0 ){
  802b0f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802b13:	79 1a                	jns    802b2f <sget+0x4f>
			release_uspinlock(&ulock);
  802b15:	83 ec 0c             	sub    $0xc,%esp
  802b18:	68 40 e1 81 00       	push   $0x81e140
  802b1d:	e8 33 17 00 00       	call   804255 <release_uspinlock>
  802b22:	83 c4 10             	add    $0x10,%esp
			return NULL;
  802b25:	b8 00 00 00 00       	mov    $0x0,%eax
  802b2a:	e9 6e 05 00 00       	jmp    80309d <sget+0x5bd>
		}
		size = ROUNDUP(size,PAGE_SIZE);
  802b2f:	c7 45 e8 00 10 00 00 	movl   $0x1000,-0x18(%ebp)
  802b36:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802b39:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b3c:	01 d0                	add    %edx,%eax
  802b3e:	48                   	dec    %eax
  802b3f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  802b42:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802b45:	ba 00 00 00 00       	mov    $0x0,%edx
  802b4a:	f7 75 e8             	divl   -0x18(%ebp)
  802b4d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802b50:	29 d0                	sub    %edx,%eax
  802b52:	89 45 ec             	mov    %eax,-0x14(%ebp)

		struct UserHeapStruct* allocblock = (struct UserHeapStruct*) alloc_block(sizeof(struct UserHeapStruct));
  802b55:	83 ec 0c             	sub    $0xc,%esp
  802b58:	6a 10                	push   $0x10
  802b5a:	e8 78 0d 00 00       	call   8038d7 <alloc_block>
  802b5f:	83 c4 10             	add    $0x10,%esp
  802b62:	89 45 e0             	mov    %eax,-0x20(%ebp)

		if (allocblock == NULL){
  802b65:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802b69:	75 0a                	jne    802b75 <sget+0x95>
			return NULL;
  802b6b:	b8 00 00 00 00       	mov    $0x0,%eax
  802b70:	e9 28 05 00 00       	jmp    80309d <sget+0x5bd>
		}
		struct UserHeapStruct* lastfreeelement = LIST_LAST(&u_freelist);
  802b75:	a1 24 e1 81 00       	mov    0x81e124,%eax
  802b7a:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if(LIST_SIZE(&u_freelist)==0 || size>lastfreeelement->size){
  802b7d:	a1 2c e1 81 00       	mov    0x81e12c,%eax
  802b82:	85 c0                	test   %eax,%eax
  802b84:	74 11                	je     802b97 <sget+0xb7>
  802b86:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802b89:	8b 50 04             	mov    0x4(%eax),%edx
  802b8c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b8f:	39 c2                	cmp    %eax,%edx
  802b91:	0f 83 21 01 00 00    	jae    802cb8 <sget+0x1d8>
				if(uheapPageAllocBreak <= USER_HEAP_MAX - size){
  802b97:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b9a:	ba 00 00 00 a0       	mov    $0xa0000000,%edx
  802b9f:	29 c2                	sub    %eax,%edx
  802ba1:	a1 68 e0 81 00       	mov    0x81e068,%eax
  802ba6:	39 c2                	cmp    %eax,%edx
  802ba8:	0f 82 f0 00 00 00    	jb     802c9e <sget+0x1be>

						uint32 requestedblockva = uheapPageAllocBreak;
  802bae:	a1 68 e0 81 00       	mov    0x81e068,%eax
  802bb3:	89 45 d0             	mov    %eax,-0x30(%ebp)
						uheapPageAllocBreak+=size;
  802bb6:	8b 15 68 e0 81 00    	mov    0x81e068,%edx
  802bbc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bbf:	01 d0                	add    %edx,%eax
  802bc1:	a3 68 e0 81 00       	mov    %eax,0x81e068
						allocblock->startva = requestedblockva;
  802bc6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802bc9:	8b 55 d0             	mov    -0x30(%ebp),%edx
  802bcc:	89 10                	mov    %edx,(%eax)
						allocblock->size = size;
  802bce:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802bd1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802bd4:	89 50 04             	mov    %edx,0x4(%eax)

						LIST_INSERT_TAIL(&u_allocatedlist, allocblock);
  802bd7:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802bdb:	75 17                	jne    802bf4 <sget+0x114>
  802bdd:	83 ec 04             	sub    $0x4,%esp
  802be0:	68 f8 4e 80 00       	push   $0x804ef8
  802be5:	68 c8 01 00 00       	push   $0x1c8
  802bea:	68 ac 4e 80 00       	push   $0x804eac
  802bef:	e8 d0 d9 ff ff       	call   8005c4 <_panic>
  802bf4:	8b 15 34 e1 81 00    	mov    0x81e134,%edx
  802bfa:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802bfd:	89 50 0c             	mov    %edx,0xc(%eax)
  802c00:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802c03:	8b 40 0c             	mov    0xc(%eax),%eax
  802c06:	85 c0                	test   %eax,%eax
  802c08:	74 0d                	je     802c17 <sget+0x137>
  802c0a:	a1 34 e1 81 00       	mov    0x81e134,%eax
  802c0f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802c12:	89 50 08             	mov    %edx,0x8(%eax)
  802c15:	eb 08                	jmp    802c1f <sget+0x13f>
  802c17:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802c1a:	a3 30 e1 81 00       	mov    %eax,0x81e130
  802c1f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802c22:	a3 34 e1 81 00       	mov    %eax,0x81e134
  802c27:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802c2a:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802c31:	a1 3c e1 81 00       	mov    0x81e13c,%eax
  802c36:	40                   	inc    %eax
  802c37:	a3 3c e1 81 00       	mov    %eax,0x81e13c


						int result = sys_get_shared_object(ownerEnvID ,sharedVarName ,(void*)allocblock->startva);
  802c3c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802c3f:	8b 00                	mov    (%eax),%eax
  802c41:	83 ec 04             	sub    $0x4,%esp
  802c44:	50                   	push   %eax
  802c45:	ff 75 0c             	pushl  0xc(%ebp)
  802c48:	ff 75 08             	pushl  0x8(%ebp)
  802c4b:	e8 cc 06 00 00       	call   80331c <sys_get_shared_object>
  802c50:	83 c4 10             	add    $0x10,%esp
  802c53:	89 45 cc             	mov    %eax,-0x34(%ebp)

						if(result <0){
  802c56:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802c5a:	79 28                	jns    802c84 <sget+0x1a4>
							free_block(allocblock);
  802c5c:	83 ec 0c             	sub    $0xc,%esp
  802c5f:	ff 75 e0             	pushl  -0x20(%ebp)
  802c62:	e8 0c 11 00 00       	call   803d73 <free_block>
  802c67:	83 c4 10             	add    $0x10,%esp
							release_uspinlock(&ulock);
  802c6a:	83 ec 0c             	sub    $0xc,%esp
  802c6d:	68 40 e1 81 00       	push   $0x81e140
  802c72:	e8 de 15 00 00       	call   804255 <release_uspinlock>
  802c77:	83 c4 10             	add    $0x10,%esp
							return NULL;
  802c7a:	b8 00 00 00 00       	mov    $0x0,%eax
  802c7f:	e9 19 04 00 00       	jmp    80309d <sget+0x5bd>
						}
						release_uspinlock(&ulock);
  802c84:	83 ec 0c             	sub    $0xc,%esp
  802c87:	68 40 e1 81 00       	push   $0x81e140
  802c8c:	e8 c4 15 00 00       	call   804255 <release_uspinlock>
  802c91:	83 c4 10             	add    $0x10,%esp
						return (void*)allocblock -> startva;
  802c94:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802c97:	8b 00                	mov    (%eax),%eax
  802c99:	e9 ff 03 00 00       	jmp    80309d <sget+0x5bd>
				}else{
						release_uspinlock(&ulock);
  802c9e:	83 ec 0c             	sub    $0xc,%esp
  802ca1:	68 40 e1 81 00       	push   $0x81e140
  802ca6:	e8 aa 15 00 00       	call   804255 <release_uspinlock>
  802cab:	83 c4 10             	add    $0x10,%esp
						return NULL;
  802cae:	b8 00 00 00 00       	mov    $0x0,%eax
  802cb3:	e9 e5 03 00 00       	jmp    80309d <sget+0x5bd>
					 }
		}else{
			//custom fit
			struct UserHeapStruct* currentfreeelement = LIST_FIRST(&u_freelist);
  802cb8:	a1 20 e1 81 00       	mov    0x81e120,%eax
  802cbd:	89 45 f4             	mov    %eax,-0xc(%ebp)
			//worst fit
			while(currentfreeelement != NULL){
  802cc0:	e9 ab 03 00 00       	jmp    803070 <sget+0x590>
				if(size<currentfreeelement->size){
  802cc5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cc8:	8b 50 04             	mov    0x4(%eax),%edx
  802ccb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cce:	39 c2                	cmp    %eax,%edx
  802cd0:	0f 86 24 02 00 00    	jbe    802efa <sget+0x41a>
					allocblock->startva = lastfreeelement->startva;
  802cd6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802cd9:	8b 10                	mov    (%eax),%edx
  802cdb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802cde:	89 10                	mov    %edx,(%eax)
					allocblock->size = size;
  802ce0:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802ce3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802ce6:	89 50 04             	mov    %edx,0x4(%eax)
					LIST_INSERT_TAIL(&u_allocatedlist,allocblock);
  802ce9:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802ced:	75 17                	jne    802d06 <sget+0x226>
  802cef:	83 ec 04             	sub    $0x4,%esp
  802cf2:	68 f8 4e 80 00       	push   $0x804ef8
  802cf7:	68 e0 01 00 00       	push   $0x1e0
  802cfc:	68 ac 4e 80 00       	push   $0x804eac
  802d01:	e8 be d8 ff ff       	call   8005c4 <_panic>
  802d06:	8b 15 34 e1 81 00    	mov    0x81e134,%edx
  802d0c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802d0f:	89 50 0c             	mov    %edx,0xc(%eax)
  802d12:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802d15:	8b 40 0c             	mov    0xc(%eax),%eax
  802d18:	85 c0                	test   %eax,%eax
  802d1a:	74 0d                	je     802d29 <sget+0x249>
  802d1c:	a1 34 e1 81 00       	mov    0x81e134,%eax
  802d21:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802d24:	89 50 08             	mov    %edx,0x8(%eax)
  802d27:	eb 08                	jmp    802d31 <sget+0x251>
  802d29:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802d2c:	a3 30 e1 81 00       	mov    %eax,0x81e130
  802d31:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802d34:	a3 34 e1 81 00       	mov    %eax,0x81e134
  802d39:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802d3c:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802d43:	a1 3c e1 81 00       	mov    0x81e13c,%eax
  802d48:	40                   	inc    %eax
  802d49:	a3 3c e1 81 00       	mov    %eax,0x81e13c
					lastfreeelement->startva += size;
  802d4e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802d51:	8b 10                	mov    (%eax),%edx
  802d53:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d56:	01 c2                	add    %eax,%edx
  802d58:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802d5b:	89 10                	mov    %edx,(%eax)
					lastfreeelement->size -= size;
  802d5d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802d60:	8b 50 04             	mov    0x4(%eax),%edx
  802d63:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d66:	29 c2                	sub    %eax,%edx
  802d68:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802d6b:	89 50 04             	mov    %edx,0x4(%eax)
					struct UserHeapStruct* currentfree2 = LIST_FIRST(&u_freelist);
  802d6e:	a1 20 e1 81 00       	mov    0x81e120,%eax
  802d73:	89 45 f0             	mov    %eax,-0x10(%ebp)
					//check order of last element

					while (currentfree2 != NULL){
  802d76:	e9 13 01 00 00       	jmp    802e8e <sget+0x3ae>
						if(lastfreeelement->size <currentfree2->size){
  802d7b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802d7e:	8b 50 04             	mov    0x4(%eax),%edx
  802d81:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d84:	8b 40 04             	mov    0x4(%eax),%eax
  802d87:	39 c2                	cmp    %eax,%edx
  802d89:	0f 83 f6 00 00 00    	jae    802e85 <sget+0x3a5>
							LIST_REMOVE(&u_freelist ,lastfreeelement);
  802d8f:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802d93:	75 17                	jne    802dac <sget+0x2cc>
  802d95:	83 ec 04             	sub    $0x4,%esp
  802d98:	68 1b 4f 80 00       	push   $0x804f1b
  802d9d:	68 e8 01 00 00       	push   $0x1e8
  802da2:	68 ac 4e 80 00       	push   $0x804eac
  802da7:	e8 18 d8 ff ff       	call   8005c4 <_panic>
  802dac:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802daf:	8b 40 08             	mov    0x8(%eax),%eax
  802db2:	85 c0                	test   %eax,%eax
  802db4:	74 11                	je     802dc7 <sget+0x2e7>
  802db6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802db9:	8b 40 08             	mov    0x8(%eax),%eax
  802dbc:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802dbf:	8b 52 0c             	mov    0xc(%edx),%edx
  802dc2:	89 50 0c             	mov    %edx,0xc(%eax)
  802dc5:	eb 0b                	jmp    802dd2 <sget+0x2f2>
  802dc7:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802dca:	8b 40 0c             	mov    0xc(%eax),%eax
  802dcd:	a3 24 e1 81 00       	mov    %eax,0x81e124
  802dd2:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802dd5:	8b 40 0c             	mov    0xc(%eax),%eax
  802dd8:	85 c0                	test   %eax,%eax
  802dda:	74 11                	je     802ded <sget+0x30d>
  802ddc:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802ddf:	8b 40 0c             	mov    0xc(%eax),%eax
  802de2:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802de5:	8b 52 08             	mov    0x8(%edx),%edx
  802de8:	89 50 08             	mov    %edx,0x8(%eax)
  802deb:	eb 0b                	jmp    802df8 <sget+0x318>
  802ded:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802df0:	8b 40 08             	mov    0x8(%eax),%eax
  802df3:	a3 20 e1 81 00       	mov    %eax,0x81e120
  802df8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802dfb:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802e02:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802e05:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  802e0c:	a1 2c e1 81 00       	mov    0x81e12c,%eax
  802e11:	48                   	dec    %eax
  802e12:	a3 2c e1 81 00       	mov    %eax,0x81e12c
							LIST_INSERT_BEFORE(&u_freelist ,currentfree2 ,lastfreeelement);
  802e17:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802e1b:	74 06                	je     802e23 <sget+0x343>
  802e1d:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802e21:	75 17                	jne    802e3a <sget+0x35a>
  802e23:	83 ec 04             	sub    $0x4,%esp
  802e26:	68 3c 4f 80 00       	push   $0x804f3c
  802e2b:	68 e9 01 00 00       	push   $0x1e9
  802e30:	68 ac 4e 80 00       	push   $0x804eac
  802e35:	e8 8a d7 ff ff       	call   8005c4 <_panic>
  802e3a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e3d:	8b 50 0c             	mov    0xc(%eax),%edx
  802e40:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802e43:	89 50 0c             	mov    %edx,0xc(%eax)
  802e46:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802e49:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802e4c:	89 50 08             	mov    %edx,0x8(%eax)
  802e4f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e52:	8b 40 0c             	mov    0xc(%eax),%eax
  802e55:	85 c0                	test   %eax,%eax
  802e57:	74 0e                	je     802e67 <sget+0x387>
  802e59:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e5c:	8b 40 0c             	mov    0xc(%eax),%eax
  802e5f:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802e62:	89 50 08             	mov    %edx,0x8(%eax)
  802e65:	eb 08                	jmp    802e6f <sget+0x38f>
  802e67:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802e6a:	a3 20 e1 81 00       	mov    %eax,0x81e120
  802e6f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e72:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802e75:	89 50 0c             	mov    %edx,0xc(%eax)
  802e78:	a1 2c e1 81 00       	mov    0x81e12c,%eax
  802e7d:	40                   	inc    %eax
  802e7e:	a3 2c e1 81 00       	mov    %eax,0x81e12c
							break;
  802e83:	eb 13                	jmp    802e98 <sget+0x3b8>
						}
						currentfree2 = currentfree2->prev_next_info.le_next;
  802e85:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e88:	8b 40 08             	mov    0x8(%eax),%eax
  802e8b:	89 45 f0             	mov    %eax,-0x10(%ebp)
					lastfreeelement->startva += size;
					lastfreeelement->size -= size;
					struct UserHeapStruct* currentfree2 = LIST_FIRST(&u_freelist);
					//check order of last element

					while (currentfree2 != NULL){
  802e8e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802e92:	0f 85 e3 fe ff ff    	jne    802d7b <sget+0x29b>
						}
						currentfree2 = currentfree2->prev_next_info.le_next;
					}


					int result = sys_get_shared_object(ownerEnvID ,sharedVarName ,(void*)allocblock->startva);
  802e98:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802e9b:	8b 00                	mov    (%eax),%eax
  802e9d:	83 ec 04             	sub    $0x4,%esp
  802ea0:	50                   	push   %eax
  802ea1:	ff 75 0c             	pushl  0xc(%ebp)
  802ea4:	ff 75 08             	pushl  0x8(%ebp)
  802ea7:	e8 70 04 00 00       	call   80331c <sys_get_shared_object>
  802eac:	83 c4 10             	add    $0x10,%esp
  802eaf:	89 45 d4             	mov    %eax,-0x2c(%ebp)

					if(result <0){
  802eb2:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  802eb6:	79 28                	jns    802ee0 <sget+0x400>
						free_block(allocblock);
  802eb8:	83 ec 0c             	sub    $0xc,%esp
  802ebb:	ff 75 e0             	pushl  -0x20(%ebp)
  802ebe:	e8 b0 0e 00 00       	call   803d73 <free_block>
  802ec3:	83 c4 10             	add    $0x10,%esp
						release_uspinlock(&ulock);
  802ec6:	83 ec 0c             	sub    $0xc,%esp
  802ec9:	68 40 e1 81 00       	push   $0x81e140
  802ece:	e8 82 13 00 00       	call   804255 <release_uspinlock>
  802ed3:	83 c4 10             	add    $0x10,%esp
						return NULL;
  802ed6:	b8 00 00 00 00       	mov    $0x0,%eax
  802edb:	e9 bd 01 00 00       	jmp    80309d <sget+0x5bd>
					}
					release_uspinlock(&ulock);
  802ee0:	83 ec 0c             	sub    $0xc,%esp
  802ee3:	68 40 e1 81 00       	push   $0x81e140
  802ee8:	e8 68 13 00 00       	call   804255 <release_uspinlock>
  802eed:	83 c4 10             	add    $0x10,%esp
					return (void*)allocblock->startva;
  802ef0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802ef3:	8b 00                	mov    (%eax),%eax
  802ef5:	e9 a3 01 00 00       	jmp    80309d <sget+0x5bd>
					//exact fit
				}else if(size == currentfreeelement->size){
  802efa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802efd:	8b 50 04             	mov    0x4(%eax),%edx
  802f00:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f03:	39 c2                	cmp    %eax,%edx
  802f05:	0f 85 5c 01 00 00    	jne    803067 <sget+0x587>

					allocblock->startva = currentfreeelement->startva;
  802f0b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f0e:	8b 10                	mov    (%eax),%edx
  802f10:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802f13:	89 10                	mov    %edx,(%eax)
					allocblock->size = size;
  802f15:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802f18:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802f1b:	89 50 04             	mov    %edx,0x4(%eax)
					LIST_INSERT_TAIL(&u_allocatedlist ,allocblock);
  802f1e:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802f22:	75 17                	jne    802f3b <sget+0x45b>
  802f24:	83 ec 04             	sub    $0x4,%esp
  802f27:	68 f8 4e 80 00       	push   $0x804ef8
  802f2c:	68 fe 01 00 00       	push   $0x1fe
  802f31:	68 ac 4e 80 00       	push   $0x804eac
  802f36:	e8 89 d6 ff ff       	call   8005c4 <_panic>
  802f3b:	8b 15 34 e1 81 00    	mov    0x81e134,%edx
  802f41:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802f44:	89 50 0c             	mov    %edx,0xc(%eax)
  802f47:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802f4a:	8b 40 0c             	mov    0xc(%eax),%eax
  802f4d:	85 c0                	test   %eax,%eax
  802f4f:	74 0d                	je     802f5e <sget+0x47e>
  802f51:	a1 34 e1 81 00       	mov    0x81e134,%eax
  802f56:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802f59:	89 50 08             	mov    %edx,0x8(%eax)
  802f5c:	eb 08                	jmp    802f66 <sget+0x486>
  802f5e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802f61:	a3 30 e1 81 00       	mov    %eax,0x81e130
  802f66:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802f69:	a3 34 e1 81 00       	mov    %eax,0x81e134
  802f6e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802f71:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802f78:	a1 3c e1 81 00       	mov    0x81e13c,%eax
  802f7d:	40                   	inc    %eax
  802f7e:	a3 3c e1 81 00       	mov    %eax,0x81e13c
					LIST_REMOVE(&u_freelist ,currentfreeelement);
  802f83:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f87:	75 17                	jne    802fa0 <sget+0x4c0>
  802f89:	83 ec 04             	sub    $0x4,%esp
  802f8c:	68 1b 4f 80 00       	push   $0x804f1b
  802f91:	68 ff 01 00 00       	push   $0x1ff
  802f96:	68 ac 4e 80 00       	push   $0x804eac
  802f9b:	e8 24 d6 ff ff       	call   8005c4 <_panic>
  802fa0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fa3:	8b 40 08             	mov    0x8(%eax),%eax
  802fa6:	85 c0                	test   %eax,%eax
  802fa8:	74 11                	je     802fbb <sget+0x4db>
  802faa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fad:	8b 40 08             	mov    0x8(%eax),%eax
  802fb0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802fb3:	8b 52 0c             	mov    0xc(%edx),%edx
  802fb6:	89 50 0c             	mov    %edx,0xc(%eax)
  802fb9:	eb 0b                	jmp    802fc6 <sget+0x4e6>
  802fbb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fbe:	8b 40 0c             	mov    0xc(%eax),%eax
  802fc1:	a3 24 e1 81 00       	mov    %eax,0x81e124
  802fc6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fc9:	8b 40 0c             	mov    0xc(%eax),%eax
  802fcc:	85 c0                	test   %eax,%eax
  802fce:	74 11                	je     802fe1 <sget+0x501>
  802fd0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fd3:	8b 40 0c             	mov    0xc(%eax),%eax
  802fd6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802fd9:	8b 52 08             	mov    0x8(%edx),%edx
  802fdc:	89 50 08             	mov    %edx,0x8(%eax)
  802fdf:	eb 0b                	jmp    802fec <sget+0x50c>
  802fe1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fe4:	8b 40 08             	mov    0x8(%eax),%eax
  802fe7:	a3 20 e1 81 00       	mov    %eax,0x81e120
  802fec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fef:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802ff6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ff9:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  803000:	a1 2c e1 81 00       	mov    0x81e12c,%eax
  803005:	48                   	dec    %eax
  803006:	a3 2c e1 81 00       	mov    %eax,0x81e12c

					int result = sys_get_shared_object(ownerEnvID ,sharedVarName ,(void*)allocblock->startva);
  80300b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80300e:	8b 00                	mov    (%eax),%eax
  803010:	83 ec 04             	sub    $0x4,%esp
  803013:	50                   	push   %eax
  803014:	ff 75 0c             	pushl  0xc(%ebp)
  803017:	ff 75 08             	pushl  0x8(%ebp)
  80301a:	e8 fd 02 00 00       	call   80331c <sys_get_shared_object>
  80301f:	83 c4 10             	add    $0x10,%esp
  803022:	89 45 d8             	mov    %eax,-0x28(%ebp)
					if(result <0){
  803025:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  803029:	79 25                	jns    803050 <sget+0x570>
						free_block(allocblock);
  80302b:	83 ec 0c             	sub    $0xc,%esp
  80302e:	ff 75 e0             	pushl  -0x20(%ebp)
  803031:	e8 3d 0d 00 00       	call   803d73 <free_block>
  803036:	83 c4 10             	add    $0x10,%esp
						release_uspinlock(&ulock);
  803039:	83 ec 0c             	sub    $0xc,%esp
  80303c:	68 40 e1 81 00       	push   $0x81e140
  803041:	e8 0f 12 00 00       	call   804255 <release_uspinlock>
  803046:	83 c4 10             	add    $0x10,%esp
						return NULL;
  803049:	b8 00 00 00 00       	mov    $0x0,%eax
  80304e:	eb 4d                	jmp    80309d <sget+0x5bd>
					}

					release_uspinlock(&ulock);
  803050:	83 ec 0c             	sub    $0xc,%esp
  803053:	68 40 e1 81 00       	push   $0x81e140
  803058:	e8 f8 11 00 00       	call   804255 <release_uspinlock>
  80305d:	83 c4 10             	add    $0x10,%esp
					return (void*)allocblock->startva;
  803060:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803063:	8b 00                	mov    (%eax),%eax
  803065:	eb 36                	jmp    80309d <sget+0x5bd>
				}
				currentfreeelement = currentfreeelement->prev_next_info.le_next;
  803067:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80306a:	8b 40 08             	mov    0x8(%eax),%eax
  80306d:	89 45 f4             	mov    %eax,-0xc(%ebp)
					 }
		}else{
			//custom fit
			struct UserHeapStruct* currentfreeelement = LIST_FIRST(&u_freelist);
			//worst fit
			while(currentfreeelement != NULL){
  803070:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803074:	0f 85 4b fc ff ff    	jne    802cc5 <sget+0x1e5>
					return (void*)allocblock->startva;
				}
				currentfreeelement = currentfreeelement->prev_next_info.le_next;
			}
		}
		free_block(allocblock);
  80307a:	83 ec 0c             	sub    $0xc,%esp
  80307d:	ff 75 e0             	pushl  -0x20(%ebp)
  803080:	e8 ee 0c 00 00       	call   803d73 <free_block>
  803085:	83 c4 10             	add    $0x10,%esp
		release_uspinlock(&ulock);
  803088:	83 ec 0c             	sub    $0xc,%esp
  80308b:	68 40 e1 81 00       	push   $0x81e140
  803090:	e8 c0 11 00 00       	call   804255 <release_uspinlock>
  803095:	83 c4 10             	add    $0x10,%esp
		return NULL;
  803098:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80309d:	c9                   	leave  
  80309e:	c3                   	ret    

0080309f <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  80309f:	55                   	push   %ebp
  8030a0:	89 e5                	mov    %esp,%ebp
  8030a2:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  8030a5:	e8 cd e6 ff ff       	call   801777 <uheap_init>
	//==============================================================
	panic("realloc() is not implemented yet...!!");
  8030aa:	83 ec 04             	sub    $0x4,%esp
  8030ad:	68 cc 4f 80 00       	push   $0x804fcc
  8030b2:	68 2d 02 00 00       	push   $0x22d
  8030b7:	68 ac 4e 80 00       	push   $0x804eac
  8030bc:	e8 03 d5 ff ff       	call   8005c4 <_panic>

008030c1 <sfree>:
//
//	use sys_delete_shared_object(...); which switches to the kernel mode,
//	calls delete_shared_object(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the delete_shared_object() function is empty, make sure to implement it.
void sfree(void* virtual_address)
{
  8030c1:	55                   	push   %ebp
  8030c2:	89 e5                	mov    %esp,%ebp
  8030c4:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.BONUS#5] EXIT #2 - sfree
	//Your code is here
	//Comment the following line
	panic("sfree() is not implemented yet...!!");
  8030c7:	83 ec 04             	sub    $0x4,%esp
  8030ca:	68 f4 4f 80 00       	push   $0x804ff4
  8030cf:	68 40 02 00 00       	push   $0x240
  8030d4:	68 ac 4e 80 00       	push   $0x804eac
  8030d9:	e8 e6 d4 ff ff       	call   8005c4 <_panic>

008030de <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8030de:	55                   	push   %ebp
  8030df:	89 e5                	mov    %esp,%ebp
  8030e1:	57                   	push   %edi
  8030e2:	56                   	push   %esi
  8030e3:	53                   	push   %ebx
  8030e4:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8030e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8030ea:	8b 55 0c             	mov    0xc(%ebp),%edx
  8030ed:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8030f0:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8030f3:	8b 7d 18             	mov    0x18(%ebp),%edi
  8030f6:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8030f9:	cd 30                	int    $0x30
  8030fb:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  8030fe:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  803101:	83 c4 10             	add    $0x10,%esp
  803104:	5b                   	pop    %ebx
  803105:	5e                   	pop    %esi
  803106:	5f                   	pop    %edi
  803107:	5d                   	pop    %ebp
  803108:	c3                   	ret    

00803109 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  803109:	55                   	push   %ebp
  80310a:	89 e5                	mov    %esp,%ebp
  80310c:	83 ec 04             	sub    $0x4,%esp
  80310f:	8b 45 10             	mov    0x10(%ebp),%eax
  803112:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  803115:	8b 4d 14             	mov    0x14(%ebp),%ecx
  803118:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80311c:	8b 45 08             	mov    0x8(%ebp),%eax
  80311f:	6a 00                	push   $0x0
  803121:	51                   	push   %ecx
  803122:	52                   	push   %edx
  803123:	ff 75 0c             	pushl  0xc(%ebp)
  803126:	50                   	push   %eax
  803127:	6a 00                	push   $0x0
  803129:	e8 b0 ff ff ff       	call   8030de <syscall>
  80312e:	83 c4 18             	add    $0x18,%esp
}
  803131:	90                   	nop
  803132:	c9                   	leave  
  803133:	c3                   	ret    

00803134 <sys_cgetc>:

int
sys_cgetc(void)
{
  803134:	55                   	push   %ebp
  803135:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  803137:	6a 00                	push   $0x0
  803139:	6a 00                	push   $0x0
  80313b:	6a 00                	push   $0x0
  80313d:	6a 00                	push   $0x0
  80313f:	6a 00                	push   $0x0
  803141:	6a 02                	push   $0x2
  803143:	e8 96 ff ff ff       	call   8030de <syscall>
  803148:	83 c4 18             	add    $0x18,%esp
}
  80314b:	c9                   	leave  
  80314c:	c3                   	ret    

0080314d <sys_lock_cons>:

void sys_lock_cons(void)
{
  80314d:	55                   	push   %ebp
  80314e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  803150:	6a 00                	push   $0x0
  803152:	6a 00                	push   $0x0
  803154:	6a 00                	push   $0x0
  803156:	6a 00                	push   $0x0
  803158:	6a 00                	push   $0x0
  80315a:	6a 03                	push   $0x3
  80315c:	e8 7d ff ff ff       	call   8030de <syscall>
  803161:	83 c4 18             	add    $0x18,%esp
}
  803164:	90                   	nop
  803165:	c9                   	leave  
  803166:	c3                   	ret    

00803167 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  803167:	55                   	push   %ebp
  803168:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  80316a:	6a 00                	push   $0x0
  80316c:	6a 00                	push   $0x0
  80316e:	6a 00                	push   $0x0
  803170:	6a 00                	push   $0x0
  803172:	6a 00                	push   $0x0
  803174:	6a 04                	push   $0x4
  803176:	e8 63 ff ff ff       	call   8030de <syscall>
  80317b:	83 c4 18             	add    $0x18,%esp
}
  80317e:	90                   	nop
  80317f:	c9                   	leave  
  803180:	c3                   	ret    

00803181 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  803181:	55                   	push   %ebp
  803182:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  803184:	8b 55 0c             	mov    0xc(%ebp),%edx
  803187:	8b 45 08             	mov    0x8(%ebp),%eax
  80318a:	6a 00                	push   $0x0
  80318c:	6a 00                	push   $0x0
  80318e:	6a 00                	push   $0x0
  803190:	52                   	push   %edx
  803191:	50                   	push   %eax
  803192:	6a 08                	push   $0x8
  803194:	e8 45 ff ff ff       	call   8030de <syscall>
  803199:	83 c4 18             	add    $0x18,%esp
}
  80319c:	c9                   	leave  
  80319d:	c3                   	ret    

0080319e <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  80319e:	55                   	push   %ebp
  80319f:	89 e5                	mov    %esp,%ebp
  8031a1:	56                   	push   %esi
  8031a2:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8031a3:	8b 75 18             	mov    0x18(%ebp),%esi
  8031a6:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8031a9:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8031ac:	8b 55 0c             	mov    0xc(%ebp),%edx
  8031af:	8b 45 08             	mov    0x8(%ebp),%eax
  8031b2:	56                   	push   %esi
  8031b3:	53                   	push   %ebx
  8031b4:	51                   	push   %ecx
  8031b5:	52                   	push   %edx
  8031b6:	50                   	push   %eax
  8031b7:	6a 09                	push   $0x9
  8031b9:	e8 20 ff ff ff       	call   8030de <syscall>
  8031be:	83 c4 18             	add    $0x18,%esp
}
  8031c1:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8031c4:	5b                   	pop    %ebx
  8031c5:	5e                   	pop    %esi
  8031c6:	5d                   	pop    %ebp
  8031c7:	c3                   	ret    

008031c8 <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  8031c8:	55                   	push   %ebp
  8031c9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  8031cb:	6a 00                	push   $0x0
  8031cd:	6a 00                	push   $0x0
  8031cf:	6a 00                	push   $0x0
  8031d1:	6a 00                	push   $0x0
  8031d3:	ff 75 08             	pushl  0x8(%ebp)
  8031d6:	6a 0a                	push   $0xa
  8031d8:	e8 01 ff ff ff       	call   8030de <syscall>
  8031dd:	83 c4 18             	add    $0x18,%esp
}
  8031e0:	c9                   	leave  
  8031e1:	c3                   	ret    

008031e2 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8031e2:	55                   	push   %ebp
  8031e3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8031e5:	6a 00                	push   $0x0
  8031e7:	6a 00                	push   $0x0
  8031e9:	6a 00                	push   $0x0
  8031eb:	ff 75 0c             	pushl  0xc(%ebp)
  8031ee:	ff 75 08             	pushl  0x8(%ebp)
  8031f1:	6a 0b                	push   $0xb
  8031f3:	e8 e6 fe ff ff       	call   8030de <syscall>
  8031f8:	83 c4 18             	add    $0x18,%esp
}
  8031fb:	c9                   	leave  
  8031fc:	c3                   	ret    

008031fd <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8031fd:	55                   	push   %ebp
  8031fe:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  803200:	6a 00                	push   $0x0
  803202:	6a 00                	push   $0x0
  803204:	6a 00                	push   $0x0
  803206:	6a 00                	push   $0x0
  803208:	6a 00                	push   $0x0
  80320a:	6a 0c                	push   $0xc
  80320c:	e8 cd fe ff ff       	call   8030de <syscall>
  803211:	83 c4 18             	add    $0x18,%esp
}
  803214:	c9                   	leave  
  803215:	c3                   	ret    

00803216 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  803216:	55                   	push   %ebp
  803217:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  803219:	6a 00                	push   $0x0
  80321b:	6a 00                	push   $0x0
  80321d:	6a 00                	push   $0x0
  80321f:	6a 00                	push   $0x0
  803221:	6a 00                	push   $0x0
  803223:	6a 0d                	push   $0xd
  803225:	e8 b4 fe ff ff       	call   8030de <syscall>
  80322a:	83 c4 18             	add    $0x18,%esp
}
  80322d:	c9                   	leave  
  80322e:	c3                   	ret    

0080322f <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  80322f:	55                   	push   %ebp
  803230:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  803232:	6a 00                	push   $0x0
  803234:	6a 00                	push   $0x0
  803236:	6a 00                	push   $0x0
  803238:	6a 00                	push   $0x0
  80323a:	6a 00                	push   $0x0
  80323c:	6a 0e                	push   $0xe
  80323e:	e8 9b fe ff ff       	call   8030de <syscall>
  803243:	83 c4 18             	add    $0x18,%esp
}
  803246:	c9                   	leave  
  803247:	c3                   	ret    

00803248 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  803248:	55                   	push   %ebp
  803249:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  80324b:	6a 00                	push   $0x0
  80324d:	6a 00                	push   $0x0
  80324f:	6a 00                	push   $0x0
  803251:	6a 00                	push   $0x0
  803253:	6a 00                	push   $0x0
  803255:	6a 0f                	push   $0xf
  803257:	e8 82 fe ff ff       	call   8030de <syscall>
  80325c:	83 c4 18             	add    $0x18,%esp
}
  80325f:	c9                   	leave  
  803260:	c3                   	ret    

00803261 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  803261:	55                   	push   %ebp
  803262:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  803264:	6a 00                	push   $0x0
  803266:	6a 00                	push   $0x0
  803268:	6a 00                	push   $0x0
  80326a:	6a 00                	push   $0x0
  80326c:	ff 75 08             	pushl  0x8(%ebp)
  80326f:	6a 10                	push   $0x10
  803271:	e8 68 fe ff ff       	call   8030de <syscall>
  803276:	83 c4 18             	add    $0x18,%esp
}
  803279:	c9                   	leave  
  80327a:	c3                   	ret    

0080327b <sys_scarce_memory>:

void sys_scarce_memory()
{
  80327b:	55                   	push   %ebp
  80327c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  80327e:	6a 00                	push   $0x0
  803280:	6a 00                	push   $0x0
  803282:	6a 00                	push   $0x0
  803284:	6a 00                	push   $0x0
  803286:	6a 00                	push   $0x0
  803288:	6a 11                	push   $0x11
  80328a:	e8 4f fe ff ff       	call   8030de <syscall>
  80328f:	83 c4 18             	add    $0x18,%esp
}
  803292:	90                   	nop
  803293:	c9                   	leave  
  803294:	c3                   	ret    

00803295 <sys_cputc>:

void
sys_cputc(const char c)
{
  803295:	55                   	push   %ebp
  803296:	89 e5                	mov    %esp,%ebp
  803298:	83 ec 04             	sub    $0x4,%esp
  80329b:	8b 45 08             	mov    0x8(%ebp),%eax
  80329e:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8032a1:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8032a5:	6a 00                	push   $0x0
  8032a7:	6a 00                	push   $0x0
  8032a9:	6a 00                	push   $0x0
  8032ab:	6a 00                	push   $0x0
  8032ad:	50                   	push   %eax
  8032ae:	6a 01                	push   $0x1
  8032b0:	e8 29 fe ff ff       	call   8030de <syscall>
  8032b5:	83 c4 18             	add    $0x18,%esp
}
  8032b8:	90                   	nop
  8032b9:	c9                   	leave  
  8032ba:	c3                   	ret    

008032bb <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8032bb:	55                   	push   %ebp
  8032bc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8032be:	6a 00                	push   $0x0
  8032c0:	6a 00                	push   $0x0
  8032c2:	6a 00                	push   $0x0
  8032c4:	6a 00                	push   $0x0
  8032c6:	6a 00                	push   $0x0
  8032c8:	6a 14                	push   $0x14
  8032ca:	e8 0f fe ff ff       	call   8030de <syscall>
  8032cf:	83 c4 18             	add    $0x18,%esp
}
  8032d2:	90                   	nop
  8032d3:	c9                   	leave  
  8032d4:	c3                   	ret    

008032d5 <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8032d5:	55                   	push   %ebp
  8032d6:	89 e5                	mov    %esp,%ebp
  8032d8:	83 ec 04             	sub    $0x4,%esp
  8032db:	8b 45 10             	mov    0x10(%ebp),%eax
  8032de:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8032e1:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8032e4:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8032e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8032eb:	6a 00                	push   $0x0
  8032ed:	51                   	push   %ecx
  8032ee:	52                   	push   %edx
  8032ef:	ff 75 0c             	pushl  0xc(%ebp)
  8032f2:	50                   	push   %eax
  8032f3:	6a 15                	push   $0x15
  8032f5:	e8 e4 fd ff ff       	call   8030de <syscall>
  8032fa:	83 c4 18             	add    $0x18,%esp
}
  8032fd:	c9                   	leave  
  8032fe:	c3                   	ret    

008032ff <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  8032ff:	55                   	push   %ebp
  803300:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  803302:	8b 55 0c             	mov    0xc(%ebp),%edx
  803305:	8b 45 08             	mov    0x8(%ebp),%eax
  803308:	6a 00                	push   $0x0
  80330a:	6a 00                	push   $0x0
  80330c:	6a 00                	push   $0x0
  80330e:	52                   	push   %edx
  80330f:	50                   	push   %eax
  803310:	6a 16                	push   $0x16
  803312:	e8 c7 fd ff ff       	call   8030de <syscall>
  803317:	83 c4 18             	add    $0x18,%esp
}
  80331a:	c9                   	leave  
  80331b:	c3                   	ret    

0080331c <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  80331c:	55                   	push   %ebp
  80331d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  80331f:	8b 4d 10             	mov    0x10(%ebp),%ecx
  803322:	8b 55 0c             	mov    0xc(%ebp),%edx
  803325:	8b 45 08             	mov    0x8(%ebp),%eax
  803328:	6a 00                	push   $0x0
  80332a:	6a 00                	push   $0x0
  80332c:	51                   	push   %ecx
  80332d:	52                   	push   %edx
  80332e:	50                   	push   %eax
  80332f:	6a 17                	push   $0x17
  803331:	e8 a8 fd ff ff       	call   8030de <syscall>
  803336:	83 c4 18             	add    $0x18,%esp
}
  803339:	c9                   	leave  
  80333a:	c3                   	ret    

0080333b <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  80333b:	55                   	push   %ebp
  80333c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  80333e:	8b 55 0c             	mov    0xc(%ebp),%edx
  803341:	8b 45 08             	mov    0x8(%ebp),%eax
  803344:	6a 00                	push   $0x0
  803346:	6a 00                	push   $0x0
  803348:	6a 00                	push   $0x0
  80334a:	52                   	push   %edx
  80334b:	50                   	push   %eax
  80334c:	6a 18                	push   $0x18
  80334e:	e8 8b fd ff ff       	call   8030de <syscall>
  803353:	83 c4 18             	add    $0x18,%esp
}
  803356:	c9                   	leave  
  803357:	c3                   	ret    

00803358 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  803358:	55                   	push   %ebp
  803359:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  80335b:	8b 45 08             	mov    0x8(%ebp),%eax
  80335e:	6a 00                	push   $0x0
  803360:	ff 75 14             	pushl  0x14(%ebp)
  803363:	ff 75 10             	pushl  0x10(%ebp)
  803366:	ff 75 0c             	pushl  0xc(%ebp)
  803369:	50                   	push   %eax
  80336a:	6a 19                	push   $0x19
  80336c:	e8 6d fd ff ff       	call   8030de <syscall>
  803371:	83 c4 18             	add    $0x18,%esp
}
  803374:	c9                   	leave  
  803375:	c3                   	ret    

00803376 <sys_run_env>:

void sys_run_env(int32 envId)
{
  803376:	55                   	push   %ebp
  803377:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  803379:	8b 45 08             	mov    0x8(%ebp),%eax
  80337c:	6a 00                	push   $0x0
  80337e:	6a 00                	push   $0x0
  803380:	6a 00                	push   $0x0
  803382:	6a 00                	push   $0x0
  803384:	50                   	push   %eax
  803385:	6a 1a                	push   $0x1a
  803387:	e8 52 fd ff ff       	call   8030de <syscall>
  80338c:	83 c4 18             	add    $0x18,%esp
}
  80338f:	90                   	nop
  803390:	c9                   	leave  
  803391:	c3                   	ret    

00803392 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  803392:	55                   	push   %ebp
  803393:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  803395:	8b 45 08             	mov    0x8(%ebp),%eax
  803398:	6a 00                	push   $0x0
  80339a:	6a 00                	push   $0x0
  80339c:	6a 00                	push   $0x0
  80339e:	6a 00                	push   $0x0
  8033a0:	50                   	push   %eax
  8033a1:	6a 1b                	push   $0x1b
  8033a3:	e8 36 fd ff ff       	call   8030de <syscall>
  8033a8:	83 c4 18             	add    $0x18,%esp
}
  8033ab:	c9                   	leave  
  8033ac:	c3                   	ret    

008033ad <sys_getenvid>:

int32 sys_getenvid(void)
{
  8033ad:	55                   	push   %ebp
  8033ae:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8033b0:	6a 00                	push   $0x0
  8033b2:	6a 00                	push   $0x0
  8033b4:	6a 00                	push   $0x0
  8033b6:	6a 00                	push   $0x0
  8033b8:	6a 00                	push   $0x0
  8033ba:	6a 05                	push   $0x5
  8033bc:	e8 1d fd ff ff       	call   8030de <syscall>
  8033c1:	83 c4 18             	add    $0x18,%esp
}
  8033c4:	c9                   	leave  
  8033c5:	c3                   	ret    

008033c6 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8033c6:	55                   	push   %ebp
  8033c7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8033c9:	6a 00                	push   $0x0
  8033cb:	6a 00                	push   $0x0
  8033cd:	6a 00                	push   $0x0
  8033cf:	6a 00                	push   $0x0
  8033d1:	6a 00                	push   $0x0
  8033d3:	6a 06                	push   $0x6
  8033d5:	e8 04 fd ff ff       	call   8030de <syscall>
  8033da:	83 c4 18             	add    $0x18,%esp
}
  8033dd:	c9                   	leave  
  8033de:	c3                   	ret    

008033df <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8033df:	55                   	push   %ebp
  8033e0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8033e2:	6a 00                	push   $0x0
  8033e4:	6a 00                	push   $0x0
  8033e6:	6a 00                	push   $0x0
  8033e8:	6a 00                	push   $0x0
  8033ea:	6a 00                	push   $0x0
  8033ec:	6a 07                	push   $0x7
  8033ee:	e8 eb fc ff ff       	call   8030de <syscall>
  8033f3:	83 c4 18             	add    $0x18,%esp
}
  8033f6:	c9                   	leave  
  8033f7:	c3                   	ret    

008033f8 <sys_exit_env>:


void sys_exit_env(void)
{
  8033f8:	55                   	push   %ebp
  8033f9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  8033fb:	6a 00                	push   $0x0
  8033fd:	6a 00                	push   $0x0
  8033ff:	6a 00                	push   $0x0
  803401:	6a 00                	push   $0x0
  803403:	6a 00                	push   $0x0
  803405:	6a 1c                	push   $0x1c
  803407:	e8 d2 fc ff ff       	call   8030de <syscall>
  80340c:	83 c4 18             	add    $0x18,%esp
}
  80340f:	90                   	nop
  803410:	c9                   	leave  
  803411:	c3                   	ret    

00803412 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  803412:	55                   	push   %ebp
  803413:	89 e5                	mov    %esp,%ebp
  803415:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  803418:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80341b:	8d 50 04             	lea    0x4(%eax),%edx
  80341e:	8d 45 f8             	lea    -0x8(%ebp),%eax
  803421:	6a 00                	push   $0x0
  803423:	6a 00                	push   $0x0
  803425:	6a 00                	push   $0x0
  803427:	52                   	push   %edx
  803428:	50                   	push   %eax
  803429:	6a 1d                	push   $0x1d
  80342b:	e8 ae fc ff ff       	call   8030de <syscall>
  803430:	83 c4 18             	add    $0x18,%esp
	return result;
  803433:	8b 4d 08             	mov    0x8(%ebp),%ecx
  803436:	8b 45 f8             	mov    -0x8(%ebp),%eax
  803439:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80343c:	89 01                	mov    %eax,(%ecx)
  80343e:	89 51 04             	mov    %edx,0x4(%ecx)
}
  803441:	8b 45 08             	mov    0x8(%ebp),%eax
  803444:	c9                   	leave  
  803445:	c2 04 00             	ret    $0x4

00803448 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  803448:	55                   	push   %ebp
  803449:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  80344b:	6a 00                	push   $0x0
  80344d:	6a 00                	push   $0x0
  80344f:	ff 75 10             	pushl  0x10(%ebp)
  803452:	ff 75 0c             	pushl  0xc(%ebp)
  803455:	ff 75 08             	pushl  0x8(%ebp)
  803458:	6a 13                	push   $0x13
  80345a:	e8 7f fc ff ff       	call   8030de <syscall>
  80345f:	83 c4 18             	add    $0x18,%esp
	return ;
  803462:	90                   	nop
}
  803463:	c9                   	leave  
  803464:	c3                   	ret    

00803465 <sys_rcr2>:
uint32 sys_rcr2()
{
  803465:	55                   	push   %ebp
  803466:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  803468:	6a 00                	push   $0x0
  80346a:	6a 00                	push   $0x0
  80346c:	6a 00                	push   $0x0
  80346e:	6a 00                	push   $0x0
  803470:	6a 00                	push   $0x0
  803472:	6a 1e                	push   $0x1e
  803474:	e8 65 fc ff ff       	call   8030de <syscall>
  803479:	83 c4 18             	add    $0x18,%esp
}
  80347c:	c9                   	leave  
  80347d:	c3                   	ret    

0080347e <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  80347e:	55                   	push   %ebp
  80347f:	89 e5                	mov    %esp,%ebp
  803481:	83 ec 04             	sub    $0x4,%esp
  803484:	8b 45 08             	mov    0x8(%ebp),%eax
  803487:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  80348a:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  80348e:	6a 00                	push   $0x0
  803490:	6a 00                	push   $0x0
  803492:	6a 00                	push   $0x0
  803494:	6a 00                	push   $0x0
  803496:	50                   	push   %eax
  803497:	6a 1f                	push   $0x1f
  803499:	e8 40 fc ff ff       	call   8030de <syscall>
  80349e:	83 c4 18             	add    $0x18,%esp
	return ;
  8034a1:	90                   	nop
}
  8034a2:	c9                   	leave  
  8034a3:	c3                   	ret    

008034a4 <rsttst>:
void rsttst()
{
  8034a4:	55                   	push   %ebp
  8034a5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8034a7:	6a 00                	push   $0x0
  8034a9:	6a 00                	push   $0x0
  8034ab:	6a 00                	push   $0x0
  8034ad:	6a 00                	push   $0x0
  8034af:	6a 00                	push   $0x0
  8034b1:	6a 21                	push   $0x21
  8034b3:	e8 26 fc ff ff       	call   8030de <syscall>
  8034b8:	83 c4 18             	add    $0x18,%esp
	return ;
  8034bb:	90                   	nop
}
  8034bc:	c9                   	leave  
  8034bd:	c3                   	ret    

008034be <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8034be:	55                   	push   %ebp
  8034bf:	89 e5                	mov    %esp,%ebp
  8034c1:	83 ec 04             	sub    $0x4,%esp
  8034c4:	8b 45 14             	mov    0x14(%ebp),%eax
  8034c7:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8034ca:	8b 55 18             	mov    0x18(%ebp),%edx
  8034cd:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8034d1:	52                   	push   %edx
  8034d2:	50                   	push   %eax
  8034d3:	ff 75 10             	pushl  0x10(%ebp)
  8034d6:	ff 75 0c             	pushl  0xc(%ebp)
  8034d9:	ff 75 08             	pushl  0x8(%ebp)
  8034dc:	6a 20                	push   $0x20
  8034de:	e8 fb fb ff ff       	call   8030de <syscall>
  8034e3:	83 c4 18             	add    $0x18,%esp
	return ;
  8034e6:	90                   	nop
}
  8034e7:	c9                   	leave  
  8034e8:	c3                   	ret    

008034e9 <chktst>:
void chktst(uint32 n)
{
  8034e9:	55                   	push   %ebp
  8034ea:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8034ec:	6a 00                	push   $0x0
  8034ee:	6a 00                	push   $0x0
  8034f0:	6a 00                	push   $0x0
  8034f2:	6a 00                	push   $0x0
  8034f4:	ff 75 08             	pushl  0x8(%ebp)
  8034f7:	6a 22                	push   $0x22
  8034f9:	e8 e0 fb ff ff       	call   8030de <syscall>
  8034fe:	83 c4 18             	add    $0x18,%esp
	return ;
  803501:	90                   	nop
}
  803502:	c9                   	leave  
  803503:	c3                   	ret    

00803504 <inctst>:

void inctst()
{
  803504:	55                   	push   %ebp
  803505:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  803507:	6a 00                	push   $0x0
  803509:	6a 00                	push   $0x0
  80350b:	6a 00                	push   $0x0
  80350d:	6a 00                	push   $0x0
  80350f:	6a 00                	push   $0x0
  803511:	6a 23                	push   $0x23
  803513:	e8 c6 fb ff ff       	call   8030de <syscall>
  803518:	83 c4 18             	add    $0x18,%esp
	return ;
  80351b:	90                   	nop
}
  80351c:	c9                   	leave  
  80351d:	c3                   	ret    

0080351e <gettst>:
uint32 gettst()
{
  80351e:	55                   	push   %ebp
  80351f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  803521:	6a 00                	push   $0x0
  803523:	6a 00                	push   $0x0
  803525:	6a 00                	push   $0x0
  803527:	6a 00                	push   $0x0
  803529:	6a 00                	push   $0x0
  80352b:	6a 24                	push   $0x24
  80352d:	e8 ac fb ff ff       	call   8030de <syscall>
  803532:	83 c4 18             	add    $0x18,%esp
}
  803535:	c9                   	leave  
  803536:	c3                   	ret    

00803537 <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  803537:	55                   	push   %ebp
  803538:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80353a:	6a 00                	push   $0x0
  80353c:	6a 00                	push   $0x0
  80353e:	6a 00                	push   $0x0
  803540:	6a 00                	push   $0x0
  803542:	6a 00                	push   $0x0
  803544:	6a 25                	push   $0x25
  803546:	e8 93 fb ff ff       	call   8030de <syscall>
  80354b:	83 c4 18             	add    $0x18,%esp
  80354e:	a3 60 e0 81 00       	mov    %eax,0x81e060
	return uheapPlaceStrategy ;
  803553:	a1 60 e0 81 00       	mov    0x81e060,%eax
}
  803558:	c9                   	leave  
  803559:	c3                   	ret    

0080355a <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  80355a:	55                   	push   %ebp
  80355b:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  80355d:	8b 45 08             	mov    0x8(%ebp),%eax
  803560:	a3 60 e0 81 00       	mov    %eax,0x81e060
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  803565:	6a 00                	push   $0x0
  803567:	6a 00                	push   $0x0
  803569:	6a 00                	push   $0x0
  80356b:	6a 00                	push   $0x0
  80356d:	ff 75 08             	pushl  0x8(%ebp)
  803570:	6a 26                	push   $0x26
  803572:	e8 67 fb ff ff       	call   8030de <syscall>
  803577:	83 c4 18             	add    $0x18,%esp
	return ;
  80357a:	90                   	nop
}
  80357b:	c9                   	leave  
  80357c:	c3                   	ret    

0080357d <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  80357d:	55                   	push   %ebp
  80357e:	89 e5                	mov    %esp,%ebp
  803580:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  803581:	8b 5d 14             	mov    0x14(%ebp),%ebx
  803584:	8b 4d 10             	mov    0x10(%ebp),%ecx
  803587:	8b 55 0c             	mov    0xc(%ebp),%edx
  80358a:	8b 45 08             	mov    0x8(%ebp),%eax
  80358d:	6a 00                	push   $0x0
  80358f:	53                   	push   %ebx
  803590:	51                   	push   %ecx
  803591:	52                   	push   %edx
  803592:	50                   	push   %eax
  803593:	6a 27                	push   $0x27
  803595:	e8 44 fb ff ff       	call   8030de <syscall>
  80359a:	83 c4 18             	add    $0x18,%esp
}
  80359d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8035a0:	c9                   	leave  
  8035a1:	c3                   	ret    

008035a2 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  8035a2:	55                   	push   %ebp
  8035a3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  8035a5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8035a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8035ab:	6a 00                	push   $0x0
  8035ad:	6a 00                	push   $0x0
  8035af:	6a 00                	push   $0x0
  8035b1:	52                   	push   %edx
  8035b2:	50                   	push   %eax
  8035b3:	6a 28                	push   $0x28
  8035b5:	e8 24 fb ff ff       	call   8030de <syscall>
  8035ba:	83 c4 18             	add    $0x18,%esp
}
  8035bd:	c9                   	leave  
  8035be:	c3                   	ret    

008035bf <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  8035bf:	55                   	push   %ebp
  8035c0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  8035c2:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8035c5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8035c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8035cb:	6a 00                	push   $0x0
  8035cd:	51                   	push   %ecx
  8035ce:	ff 75 10             	pushl  0x10(%ebp)
  8035d1:	52                   	push   %edx
  8035d2:	50                   	push   %eax
  8035d3:	6a 29                	push   $0x29
  8035d5:	e8 04 fb ff ff       	call   8030de <syscall>
  8035da:	83 c4 18             	add    $0x18,%esp
}
  8035dd:	c9                   	leave  
  8035de:	c3                   	ret    

008035df <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8035df:	55                   	push   %ebp
  8035e0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8035e2:	6a 00                	push   $0x0
  8035e4:	6a 00                	push   $0x0
  8035e6:	ff 75 10             	pushl  0x10(%ebp)
  8035e9:	ff 75 0c             	pushl  0xc(%ebp)
  8035ec:	ff 75 08             	pushl  0x8(%ebp)
  8035ef:	6a 12                	push   $0x12
  8035f1:	e8 e8 fa ff ff       	call   8030de <syscall>
  8035f6:	83 c4 18             	add    $0x18,%esp
	return ;
  8035f9:	90                   	nop
}
  8035fa:	c9                   	leave  
  8035fb:	c3                   	ret    

008035fc <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  8035fc:	55                   	push   %ebp
  8035fd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  8035ff:	8b 55 0c             	mov    0xc(%ebp),%edx
  803602:	8b 45 08             	mov    0x8(%ebp),%eax
  803605:	6a 00                	push   $0x0
  803607:	6a 00                	push   $0x0
  803609:	6a 00                	push   $0x0
  80360b:	52                   	push   %edx
  80360c:	50                   	push   %eax
  80360d:	6a 2a                	push   $0x2a
  80360f:	e8 ca fa ff ff       	call   8030de <syscall>
  803614:	83 c4 18             	add    $0x18,%esp
	return;
  803617:	90                   	nop
}
  803618:	c9                   	leave  
  803619:	c3                   	ret    

0080361a <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  80361a:	55                   	push   %ebp
  80361b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  80361d:	6a 00                	push   $0x0
  80361f:	6a 00                	push   $0x0
  803621:	6a 00                	push   $0x0
  803623:	6a 00                	push   $0x0
  803625:	6a 00                	push   $0x0
  803627:	6a 2b                	push   $0x2b
  803629:	e8 b0 fa ff ff       	call   8030de <syscall>
  80362e:	83 c4 18             	add    $0x18,%esp
}
  803631:	c9                   	leave  
  803632:	c3                   	ret    

00803633 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  803633:	55                   	push   %ebp
  803634:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  803636:	6a 00                	push   $0x0
  803638:	6a 00                	push   $0x0
  80363a:	6a 00                	push   $0x0
  80363c:	ff 75 0c             	pushl  0xc(%ebp)
  80363f:	ff 75 08             	pushl  0x8(%ebp)
  803642:	6a 2d                	push   $0x2d
  803644:	e8 95 fa ff ff       	call   8030de <syscall>
  803649:	83 c4 18             	add    $0x18,%esp
	return;
  80364c:	90                   	nop
}
  80364d:	c9                   	leave  
  80364e:	c3                   	ret    

0080364f <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  80364f:	55                   	push   %ebp
  803650:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  803652:	6a 00                	push   $0x0
  803654:	6a 00                	push   $0x0
  803656:	6a 00                	push   $0x0
  803658:	ff 75 0c             	pushl  0xc(%ebp)
  80365b:	ff 75 08             	pushl  0x8(%ebp)
  80365e:	6a 2c                	push   $0x2c
  803660:	e8 79 fa ff ff       	call   8030de <syscall>
  803665:	83 c4 18             	add    $0x18,%esp
	return ;
  803668:	90                   	nop
}
  803669:	c9                   	leave  
  80366a:	c3                   	ret    

0080366b <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  80366b:	55                   	push   %ebp
  80366c:	89 e5                	mov    %esp,%ebp
	//TODO: [PROJECT'25.IM#4] CPU SCHEDULING - #1 System Calls - Add suitable code here
	//Your code is here
	//Comment the following line
	//panic("sys_env_set_priority() is not implemented yet...!!");
	syscall(SYS_env_set_priority, envID, priority, 0, 0, 0);
  80366e:	8b 55 0c             	mov    0xc(%ebp),%edx
  803671:	8b 45 08             	mov    0x8(%ebp),%eax
  803674:	6a 00                	push   $0x0
  803676:	6a 00                	push   $0x0
  803678:	6a 00                	push   $0x0
  80367a:	52                   	push   %edx
  80367b:	50                   	push   %eax
  80367c:	6a 2e                	push   $0x2e
  80367e:	e8 5b fa ff ff       	call   8030de <syscall>
  803683:	83 c4 18             	add    $0x18,%esp
	    return;
  803686:	90                   	nop
}
  803687:	c9                   	leave  
  803688:	c3                   	ret    

00803689 <to_page_va>:
//==================================================================================//
//==================================
// [1] GET PAGE VA:
//==================================
__inline__ uint32 to_page_va(struct PageInfoElement *ptrPageInfo)
{
  803689:	55                   	push   %ebp
  80368a:	89 e5                	mov    %esp,%ebp
  80368c:	83 ec 10             	sub    $0x10,%esp
	//Get start VA of the page from the corresponding Page Info pointer
	int idxInPageInfoArr = (ptrPageInfo - pageBlockInfoArr);
  80368f:	8b 45 08             	mov    0x8(%ebp),%eax
  803692:	ba 60 60 80 00       	mov    $0x806060,%edx
  803697:	29 d0                	sub    %edx,%eax
  803699:	c1 f8 02             	sar    $0x2,%eax
  80369c:	89 c2                	mov    %eax,%edx
  80369e:	89 d0                	mov    %edx,%eax
  8036a0:	c1 e0 02             	shl    $0x2,%eax
  8036a3:	01 d0                	add    %edx,%eax
  8036a5:	c1 e0 02             	shl    $0x2,%eax
  8036a8:	01 d0                	add    %edx,%eax
  8036aa:	c1 e0 02             	shl    $0x2,%eax
  8036ad:	01 d0                	add    %edx,%eax
  8036af:	89 c1                	mov    %eax,%ecx
  8036b1:	c1 e1 08             	shl    $0x8,%ecx
  8036b4:	01 c8                	add    %ecx,%eax
  8036b6:	89 c1                	mov    %eax,%ecx
  8036b8:	c1 e1 10             	shl    $0x10,%ecx
  8036bb:	01 c8                	add    %ecx,%eax
  8036bd:	01 c0                	add    %eax,%eax
  8036bf:	01 d0                	add    %edx,%eax
  8036c1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return dynAllocStart + (idxInPageInfoArr << PGSHIFT);
  8036c4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8036c7:	c1 e0 0c             	shl    $0xc,%eax
  8036ca:	89 c2                	mov    %eax,%edx
  8036cc:	a1 64 e0 81 00       	mov    0x81e064,%eax
  8036d1:	01 d0                	add    %edx,%eax
}
  8036d3:	c9                   	leave  
  8036d4:	c3                   	ret    

008036d5 <log2>:

//==================================================================================//
//============================ REQUIRED FUNCTIONS ==================================//
//==================================================================================//
__inline__ int log2(uint32 n)
	{
  8036d5:	55                   	push   %ebp
  8036d6:	89 e5                	mov    %esp,%ebp
  8036d8:	83 ec 10             	sub    $0x10,%esp
		int result = 0;
  8036db:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
		while( n > 1){
  8036e2:	eb 06                	jmp    8036ea <log2+0x15>
			n >>=1;
  8036e4:	d1 6d 08             	shrl   0x8(%ebp)
			result++;
  8036e7:	ff 45 fc             	incl   -0x4(%ebp)
//============================ REQUIRED FUNCTIONS ==================================//
//==================================================================================//
__inline__ int log2(uint32 n)
	{
		int result = 0;
		while( n > 1){
  8036ea:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
  8036ee:	77 f4                	ja     8036e4 <log2+0xf>
			n >>=1;
			result++;
		}
		return result;
  8036f0:	8b 45 fc             	mov    -0x4(%ebp),%eax
	}
  8036f3:	c9                   	leave  
  8036f4:	c3                   	ret    

008036f5 <initialize_dynamic_allocator>:
//==================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================
bool is_initialized = 0;
void initialize_dynamic_allocator(uint32 daStart, uint32 daEnd)
{
  8036f5:	55                   	push   %ebp
  8036f6:	89 e5                	mov    %esp,%ebp
  8036f8:	83 ec 18             	sub    $0x18,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(daEnd <= daStart + DYN_ALLOC_MAX_SIZE);
  8036fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8036fe:	05 00 00 00 02       	add    $0x2000000,%eax
  803703:	3b 45 0c             	cmp    0xc(%ebp),%eax
  803706:	73 16                	jae    80371e <initialize_dynamic_allocator+0x29>
  803708:	68 18 50 80 00       	push   $0x805018
  80370d:	68 3e 50 80 00       	push   $0x80503e
  803712:	6a 2d                	push   $0x2d
  803714:	68 53 50 80 00       	push   $0x805053
  803719:	e8 a6 ce ff ff       	call   8005c4 <_panic>
		is_initialized = 1;
  80371e:	c7 05 24 60 80 00 01 	movl   $0x1,0x806024
  803725:	00 00 00 
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #1 initialize_dynamic_allocator
	//Your code is here


	dynAllocStart = daStart;
  803728:	8b 45 08             	mov    0x8(%ebp),%eax
  80372b:	a3 64 e0 81 00       	mov    %eax,0x81e064
	dynAllocEnd= daEnd;
  803730:	8b 45 0c             	mov    0xc(%ebp),%eax
  803733:	a3 40 60 80 00       	mov    %eax,0x806040
	int numOfPages = (dynAllocEnd - dynAllocStart)/PAGE_SIZE;
  803738:	8b 15 40 60 80 00    	mov    0x806040,%edx
  80373e:	a1 64 e0 81 00       	mov    0x81e064,%eax
  803743:	29 c2                	sub    %eax,%edx
  803745:	89 d0                	mov    %edx,%eax
  803747:	c1 e8 0c             	shr    $0xc,%eax
  80374a:	89 45 e8             	mov    %eax,-0x18(%ebp)


	for(int i=0; i< numOfPages; i++){
  80374d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  803754:	eb 2f                	jmp    803785 <initialize_dynamic_allocator+0x90>
	    pageBlockInfoArr[i].block_size=0;
  803756:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803759:	89 d0                	mov    %edx,%eax
  80375b:	01 c0                	add    %eax,%eax
  80375d:	01 d0                	add    %edx,%eax
  80375f:	c1 e0 02             	shl    $0x2,%eax
  803762:	05 68 60 80 00       	add    $0x806068,%eax
  803767:	66 c7 00 00 00       	movw   $0x0,(%eax)
	    pageBlockInfoArr[i].num_of_free_blocks=0;
  80376c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80376f:	89 d0                	mov    %edx,%eax
  803771:	01 c0                	add    %eax,%eax
  803773:	01 d0                	add    %edx,%eax
  803775:	c1 e0 02             	shl    $0x2,%eax
  803778:	05 6a 60 80 00       	add    $0x80606a,%eax
  80377d:	66 c7 00 00 00       	movw   $0x0,(%eax)
	dynAllocStart = daStart;
	dynAllocEnd= daEnd;
	int numOfPages = (dynAllocEnd - dynAllocStart)/PAGE_SIZE;


	for(int i=0; i< numOfPages; i++){
  803782:	ff 45 f4             	incl   -0xc(%ebp)
  803785:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803788:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80378b:	7c c9                	jl     803756 <initialize_dynamic_allocator+0x61>
	    pageBlockInfoArr[i].block_size=0;
	    pageBlockInfoArr[i].num_of_free_blocks=0;
	}


	LIST_INIT(&freePagesList);
  80378d:	c7 05 48 60 80 00 00 	movl   $0x0,0x806048
  803794:	00 00 00 
  803797:	c7 05 4c 60 80 00 00 	movl   $0x0,0x80604c
  80379e:	00 00 00 
  8037a1:	c7 05 54 60 80 00 00 	movl   $0x0,0x806054
  8037a8:	00 00 00 
	for(int i=0; i<numOfPages; i++){
  8037ab:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8037b2:	e9 9c 00 00 00       	jmp    803853 <initialize_dynamic_allocator+0x15e>
		LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
  8037b7:	8b 15 4c 60 80 00    	mov    0x80604c,%edx
  8037bd:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8037c0:	89 c8                	mov    %ecx,%eax
  8037c2:	01 c0                	add    %eax,%eax
  8037c4:	01 c8                	add    %ecx,%eax
  8037c6:	c1 e0 02             	shl    $0x2,%eax
  8037c9:	05 64 60 80 00       	add    $0x806064,%eax
  8037ce:	89 10                	mov    %edx,(%eax)
  8037d0:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8037d3:	89 d0                	mov    %edx,%eax
  8037d5:	01 c0                	add    %eax,%eax
  8037d7:	01 d0                	add    %edx,%eax
  8037d9:	c1 e0 02             	shl    $0x2,%eax
  8037dc:	05 64 60 80 00       	add    $0x806064,%eax
  8037e1:	8b 00                	mov    (%eax),%eax
  8037e3:	85 c0                	test   %eax,%eax
  8037e5:	74 1b                	je     803802 <initialize_dynamic_allocator+0x10d>
  8037e7:	8b 15 4c 60 80 00    	mov    0x80604c,%edx
  8037ed:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8037f0:	89 c8                	mov    %ecx,%eax
  8037f2:	01 c0                	add    %eax,%eax
  8037f4:	01 c8                	add    %ecx,%eax
  8037f6:	c1 e0 02             	shl    $0x2,%eax
  8037f9:	05 60 60 80 00       	add    $0x806060,%eax
  8037fe:	89 02                	mov    %eax,(%edx)
  803800:	eb 16                	jmp    803818 <initialize_dynamic_allocator+0x123>
  803802:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803805:	89 d0                	mov    %edx,%eax
  803807:	01 c0                	add    %eax,%eax
  803809:	01 d0                	add    %edx,%eax
  80380b:	c1 e0 02             	shl    $0x2,%eax
  80380e:	05 60 60 80 00       	add    $0x806060,%eax
  803813:	a3 48 60 80 00       	mov    %eax,0x806048
  803818:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80381b:	89 d0                	mov    %edx,%eax
  80381d:	01 c0                	add    %eax,%eax
  80381f:	01 d0                	add    %edx,%eax
  803821:	c1 e0 02             	shl    $0x2,%eax
  803824:	05 60 60 80 00       	add    $0x806060,%eax
  803829:	a3 4c 60 80 00       	mov    %eax,0x80604c
  80382e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803831:	89 d0                	mov    %edx,%eax
  803833:	01 c0                	add    %eax,%eax
  803835:	01 d0                	add    %edx,%eax
  803837:	c1 e0 02             	shl    $0x2,%eax
  80383a:	05 60 60 80 00       	add    $0x806060,%eax
  80383f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803845:	a1 54 60 80 00       	mov    0x806054,%eax
  80384a:	40                   	inc    %eax
  80384b:	a3 54 60 80 00       	mov    %eax,0x806054
	    pageBlockInfoArr[i].num_of_free_blocks=0;
	}


	LIST_INIT(&freePagesList);
	for(int i=0; i<numOfPages; i++){
  803850:	ff 45 f0             	incl   -0x10(%ebp)
  803853:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803856:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803859:	0f 8c 58 ff ff ff    	jl     8037b7 <initialize_dynamic_allocator+0xc2>
		LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
	}



	for (int i = 0; i < LOG2_MAX_SIZE - LOG2_MIN_SIZE + 1; i++) {
  80385f:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  803866:	eb 36                	jmp    80389e <initialize_dynamic_allocator+0x1a9>
	    LIST_INIT(&freeBlockLists[i]);
  803868:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80386b:	c1 e0 04             	shl    $0x4,%eax
  80386e:	05 80 e0 81 00       	add    $0x81e080,%eax
  803873:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803879:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80387c:	c1 e0 04             	shl    $0x4,%eax
  80387f:	05 84 e0 81 00       	add    $0x81e084,%eax
  803884:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80388a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80388d:	c1 e0 04             	shl    $0x4,%eax
  803890:	05 8c e0 81 00       	add    $0x81e08c,%eax
  803895:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
	}



	for (int i = 0; i < LOG2_MAX_SIZE - LOG2_MIN_SIZE + 1; i++) {
  80389b:	ff 45 ec             	incl   -0x14(%ebp)
  80389e:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  8038a2:	7e c4                	jle    803868 <initialize_dynamic_allocator+0x173>


	//Comment the following line
	//panic("initialize_dynamic_allocator() Not implemented yet");

}
  8038a4:	90                   	nop
  8038a5:	c9                   	leave  
  8038a6:	c3                   	ret    

008038a7 <get_block_size>:
// [2] GET BLOCK SIZE:
//===========================


__inline__ uint32 get_block_size(void *va)
{
  8038a7:	55                   	push   %ebp
  8038a8:	89 e5                	mov    %esp,%ebp
  8038aa:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #2 get_block_size
	//Your code is here

	uint32 page_index = ((uint32)va - dynAllocStart)/ PAGE_SIZE;
  8038ad:	8b 55 08             	mov    0x8(%ebp),%edx
  8038b0:	a1 64 e0 81 00       	mov    0x81e064,%eax
  8038b5:	29 c2                	sub    %eax,%edx
  8038b7:	89 d0                	mov    %edx,%eax
  8038b9:	c1 e8 0c             	shr    $0xc,%eax
  8038bc:	89 45 fc             	mov    %eax,-0x4(%ebp)
    return pageBlockInfoArr[page_index].block_size;
  8038bf:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8038c2:	89 d0                	mov    %edx,%eax
  8038c4:	01 c0                	add    %eax,%eax
  8038c6:	01 d0                	add    %edx,%eax
  8038c8:	c1 e0 02             	shl    $0x2,%eax
  8038cb:	05 68 60 80 00       	add    $0x806068,%eax
  8038d0:	8b 00                	mov    (%eax),%eax
  8038d2:	0f b7 c0             	movzwl %ax,%eax
	//Comment the following line
	//panic("get_block_size() Not implemented yet");
}
  8038d5:	c9                   	leave  
  8038d6:	c3                   	ret    

008038d7 <alloc_block>:

//===========================
// 3) ALLOCATE BLOCK:
//===========================
void *alloc_block(uint32 size)
{
  8038d7:	55                   	push   %ebp
  8038d8:	89 e5                	mov    %esp,%ebp
  8038da:	83 ec 48             	sub    $0x48,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(size <= DYN_ALLOC_MAX_BLOCK_SIZE);
  8038dd:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  8038e4:	76 16                	jbe    8038fc <alloc_block+0x25>
  8038e6:	68 6c 50 80 00       	push   $0x80506c
  8038eb:	68 3e 50 80 00       	push   $0x80503e
  8038f0:	6a 6c                	push   $0x6c
  8038f2:	68 53 50 80 00       	push   $0x805053
  8038f7:	e8 c8 cc ff ff       	call   8005c4 <_panic>
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #3 alloc_block
	//Your code is here


	if(size == 0){
  8038fc:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803900:	75 0a                	jne    80390c <alloc_block+0x35>
		return NULL;
  803902:	b8 00 00 00 00       	mov    $0x0,%eax
  803907:	e9 65 04 00 00       	jmp    803d71 <alloc_block+0x49a>
	}
	else if(size<=8){
  80390c:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  803910:	77 09                	ja     80391b <alloc_block+0x44>
		size=8;
  803912:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
  803919:	eb 1f                	jmp    80393a <alloc_block+0x63>
	}
	else{
		uint32 reqsize=8;
  80391b:	c7 45 f4 08 00 00 00 	movl   $0x8,-0xc(%ebp)
		while(reqsize < size){
  803922:	eb 08                	jmp    80392c <alloc_block+0x55>
			reqsize*=2;
  803924:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803927:	01 c0                	add    %eax,%eax
  803929:	89 45 f4             	mov    %eax,-0xc(%ebp)
	else if(size<=8){
		size=8;
	}
	else{
		uint32 reqsize=8;
		while(reqsize < size){
  80392c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80392f:	3b 45 08             	cmp    0x8(%ebp),%eax
  803932:	72 f0                	jb     803924 <alloc_block+0x4d>
			reqsize*=2;
		}
		size= reqsize;
  803934:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803937:	89 45 08             	mov    %eax,0x8(%ebp)
	}

	int list_index = log2(size)- LOG2_MIN_SIZE;
  80393a:	83 ec 0c             	sub    $0xc,%esp
  80393d:	ff 75 08             	pushl  0x8(%ebp)
  803940:	e8 90 fd ff ff       	call   8036d5 <log2>
  803945:	83 c4 10             	add    $0x10,%esp
  803948:	83 e8 03             	sub    $0x3,%eax
  80394b:	89 45 e8             	mov    %eax,-0x18(%ebp)

	if(!LIST_EMPTY(&freeBlockLists[list_index])){
  80394e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803951:	c1 e0 04             	shl    $0x4,%eax
  803954:	05 80 e0 81 00       	add    $0x81e080,%eax
  803959:	8b 00                	mov    (%eax),%eax
  80395b:	85 c0                	test   %eax,%eax
  80395d:	0f 84 fb 00 00 00    	je     803a5e <alloc_block+0x187>
		struct BlockElement *block = LIST_FIRST(&freeBlockLists[list_index]);
  803963:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803966:	c1 e0 04             	shl    $0x4,%eax
  803969:	05 80 e0 81 00       	add    $0x81e080,%eax
  80396e:	8b 00                	mov    (%eax),%eax
  803970:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		LIST_REMOVE(&freeBlockLists[list_index], block);
  803973:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803977:	75 17                	jne    803990 <alloc_block+0xb9>
  803979:	83 ec 04             	sub    $0x4,%esp
  80397c:	68 8d 50 80 00       	push   $0x80508d
  803981:	68 86 00 00 00       	push   $0x86
  803986:	68 53 50 80 00       	push   $0x805053
  80398b:	e8 34 cc ff ff       	call   8005c4 <_panic>
  803990:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803993:	8b 00                	mov    (%eax),%eax
  803995:	85 c0                	test   %eax,%eax
  803997:	74 10                	je     8039a9 <alloc_block+0xd2>
  803999:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80399c:	8b 00                	mov    (%eax),%eax
  80399e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8039a1:	8b 52 04             	mov    0x4(%edx),%edx
  8039a4:	89 50 04             	mov    %edx,0x4(%eax)
  8039a7:	eb 14                	jmp    8039bd <alloc_block+0xe6>
  8039a9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8039ac:	8b 40 04             	mov    0x4(%eax),%eax
  8039af:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8039b2:	c1 e2 04             	shl    $0x4,%edx
  8039b5:	81 c2 84 e0 81 00    	add    $0x81e084,%edx
  8039bb:	89 02                	mov    %eax,(%edx)
  8039bd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8039c0:	8b 40 04             	mov    0x4(%eax),%eax
  8039c3:	85 c0                	test   %eax,%eax
  8039c5:	74 0f                	je     8039d6 <alloc_block+0xff>
  8039c7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8039ca:	8b 40 04             	mov    0x4(%eax),%eax
  8039cd:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8039d0:	8b 12                	mov    (%edx),%edx
  8039d2:	89 10                	mov    %edx,(%eax)
  8039d4:	eb 13                	jmp    8039e9 <alloc_block+0x112>
  8039d6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8039d9:	8b 00                	mov    (%eax),%eax
  8039db:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8039de:	c1 e2 04             	shl    $0x4,%edx
  8039e1:	81 c2 80 e0 81 00    	add    $0x81e080,%edx
  8039e7:	89 02                	mov    %eax,(%edx)
  8039e9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8039ec:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8039f2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8039f5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8039fc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8039ff:	c1 e0 04             	shl    $0x4,%eax
  803a02:	05 8c e0 81 00       	add    $0x81e08c,%eax
  803a07:	8b 00                	mov    (%eax),%eax
  803a09:	8d 50 ff             	lea    -0x1(%eax),%edx
  803a0c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a0f:	c1 e0 04             	shl    $0x4,%eax
  803a12:	05 8c e0 81 00       	add    $0x81e08c,%eax
  803a17:	89 10                	mov    %edx,(%eax)
		uint32 page_index = ((uint32)block - dynAllocStart)/ PAGE_SIZE;
  803a19:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803a1c:	a1 64 e0 81 00       	mov    0x81e064,%eax
  803a21:	29 c2                	sub    %eax,%edx
  803a23:	89 d0                	mov    %edx,%eax
  803a25:	c1 e8 0c             	shr    $0xc,%eax
  803a28:	89 45 e0             	mov    %eax,-0x20(%ebp)
		pageBlockInfoArr[page_index].num_of_free_blocks--;
  803a2b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803a2e:	89 d0                	mov    %edx,%eax
  803a30:	01 c0                	add    %eax,%eax
  803a32:	01 d0                	add    %edx,%eax
  803a34:	c1 e0 02             	shl    $0x2,%eax
  803a37:	05 6a 60 80 00       	add    $0x80606a,%eax
  803a3c:	66 8b 00             	mov    (%eax),%ax
  803a3f:	8d 50 ff             	lea    -0x1(%eax),%edx
  803a42:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  803a45:	89 c8                	mov    %ecx,%eax
  803a47:	01 c0                	add    %eax,%eax
  803a49:	01 c8                	add    %ecx,%eax
  803a4b:	c1 e0 02             	shl    $0x2,%eax
  803a4e:	05 6a 60 80 00       	add    $0x80606a,%eax
  803a53:	66 89 10             	mov    %dx,(%eax)
		return (void*)block;
  803a56:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a59:	e9 13 03 00 00       	jmp    803d71 <alloc_block+0x49a>
	}

	if(!LIST_EMPTY(&freePagesList)){
  803a5e:	a1 48 60 80 00       	mov    0x806048,%eax
  803a63:	85 c0                	test   %eax,%eax
  803a65:	0f 84 c9 01 00 00    	je     803c34 <alloc_block+0x35d>

		struct PageInfoElement *page_info = LIST_FIRST(&freePagesList);
  803a6b:	a1 48 60 80 00       	mov    0x806048,%eax
  803a70:	89 45 dc             	mov    %eax,-0x24(%ebp)
		LIST_REMOVE(&freePagesList, page_info);
  803a73:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803a77:	75 17                	jne    803a90 <alloc_block+0x1b9>
  803a79:	83 ec 04             	sub    $0x4,%esp
  803a7c:	68 8d 50 80 00       	push   $0x80508d
  803a81:	68 8f 00 00 00       	push   $0x8f
  803a86:	68 53 50 80 00       	push   $0x805053
  803a8b:	e8 34 cb ff ff       	call   8005c4 <_panic>
  803a90:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803a93:	8b 00                	mov    (%eax),%eax
  803a95:	85 c0                	test   %eax,%eax
  803a97:	74 10                	je     803aa9 <alloc_block+0x1d2>
  803a99:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803a9c:	8b 00                	mov    (%eax),%eax
  803a9e:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803aa1:	8b 52 04             	mov    0x4(%edx),%edx
  803aa4:	89 50 04             	mov    %edx,0x4(%eax)
  803aa7:	eb 0b                	jmp    803ab4 <alloc_block+0x1dd>
  803aa9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803aac:	8b 40 04             	mov    0x4(%eax),%eax
  803aaf:	a3 4c 60 80 00       	mov    %eax,0x80604c
  803ab4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803ab7:	8b 40 04             	mov    0x4(%eax),%eax
  803aba:	85 c0                	test   %eax,%eax
  803abc:	74 0f                	je     803acd <alloc_block+0x1f6>
  803abe:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803ac1:	8b 40 04             	mov    0x4(%eax),%eax
  803ac4:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803ac7:	8b 12                	mov    (%edx),%edx
  803ac9:	89 10                	mov    %edx,(%eax)
  803acb:	eb 0a                	jmp    803ad7 <alloc_block+0x200>
  803acd:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803ad0:	8b 00                	mov    (%eax),%eax
  803ad2:	a3 48 60 80 00       	mov    %eax,0x806048
  803ad7:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803ada:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803ae0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803ae3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803aea:	a1 54 60 80 00       	mov    0x806054,%eax
  803aef:	48                   	dec    %eax
  803af0:	a3 54 60 80 00       	mov    %eax,0x806054
		uint32 page_va = to_page_va(page_info);
  803af5:	83 ec 0c             	sub    $0xc,%esp
  803af8:	ff 75 dc             	pushl  -0x24(%ebp)
  803afb:	e8 89 fb ff ff       	call   803689 <to_page_va>
  803b00:	83 c4 10             	add    $0x10,%esp
  803b03:	89 45 d8             	mov    %eax,-0x28(%ebp)

		uint32 page_index = (page_va - dynAllocStart)/ PAGE_SIZE;
  803b06:	a1 64 e0 81 00       	mov    0x81e064,%eax
  803b0b:	8b 55 d8             	mov    -0x28(%ebp),%edx
  803b0e:	29 c2                	sub    %eax,%edx
  803b10:	89 d0                	mov    %edx,%eax
  803b12:	c1 e8 0c             	shr    $0xc,%eax
  803b15:	89 45 d4             	mov    %eax,-0x2c(%ebp)

		get_page((void*)page_va);
  803b18:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803b1b:	83 ec 0c             	sub    $0xc,%esp
  803b1e:	50                   	push   %eax
  803b1f:	e8 fe dc ff ff       	call   801822 <get_page>
  803b24:	83 c4 10             	add    $0x10,%esp


		pageBlockInfoArr[page_index].block_size = size;
  803b27:	8b 45 08             	mov    0x8(%ebp),%eax
  803b2a:	89 c2                	mov    %eax,%edx
  803b2c:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  803b2f:	89 c8                	mov    %ecx,%eax
  803b31:	01 c0                	add    %eax,%eax
  803b33:	01 c8                	add    %ecx,%eax
  803b35:	c1 e0 02             	shl    $0x2,%eax
  803b38:	05 68 60 80 00       	add    $0x806068,%eax
  803b3d:	66 89 10             	mov    %dx,(%eax)
		int num_blocks = PAGE_SIZE / size ;
  803b40:	b8 00 10 00 00       	mov    $0x1000,%eax
  803b45:	ba 00 00 00 00       	mov    $0x0,%edx
  803b4a:	f7 75 08             	divl   0x8(%ebp)
  803b4d:	89 45 d0             	mov    %eax,-0x30(%ebp)
		pageBlockInfoArr[page_index].num_of_free_blocks= num_blocks - 1 ;
  803b50:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803b53:	8d 50 ff             	lea    -0x1(%eax),%edx
  803b56:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  803b59:	89 c8                	mov    %ecx,%eax
  803b5b:	01 c0                	add    %eax,%eax
  803b5d:	01 c8                	add    %ecx,%eax
  803b5f:	c1 e0 02             	shl    $0x2,%eax
  803b62:	05 6a 60 80 00       	add    $0x80606a,%eax
  803b67:	66 89 10             	mov    %dx,(%eax)

		for(int i=1; i< num_blocks; i++){
  803b6a:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
  803b71:	e9 aa 00 00 00       	jmp    803c20 <alloc_block+0x349>
			struct BlockElement *new_block = (struct BlockElement*)(page_va + i *size);
  803b76:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803b79:	0f af 45 08          	imul   0x8(%ebp),%eax
  803b7d:	89 c2                	mov    %eax,%edx
  803b7f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803b82:	01 d0                	add    %edx,%eax
  803b84:	89 45 cc             	mov    %eax,-0x34(%ebp)
			LIST_INSERT_TAIL(&freeBlockLists[list_index], new_block);
  803b87:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  803b8b:	75 17                	jne    803ba4 <alloc_block+0x2cd>
  803b8d:	83 ec 04             	sub    $0x4,%esp
  803b90:	68 ac 50 80 00       	push   $0x8050ac
  803b95:	68 9d 00 00 00       	push   $0x9d
  803b9a:	68 53 50 80 00       	push   $0x805053
  803b9f:	e8 20 ca ff ff       	call   8005c4 <_panic>
  803ba4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803ba7:	c1 e0 04             	shl    $0x4,%eax
  803baa:	05 84 e0 81 00       	add    $0x81e084,%eax
  803baf:	8b 10                	mov    (%eax),%edx
  803bb1:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803bb4:	89 50 04             	mov    %edx,0x4(%eax)
  803bb7:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803bba:	8b 40 04             	mov    0x4(%eax),%eax
  803bbd:	85 c0                	test   %eax,%eax
  803bbf:	74 14                	je     803bd5 <alloc_block+0x2fe>
  803bc1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803bc4:	c1 e0 04             	shl    $0x4,%eax
  803bc7:	05 84 e0 81 00       	add    $0x81e084,%eax
  803bcc:	8b 00                	mov    (%eax),%eax
  803bce:	8b 55 cc             	mov    -0x34(%ebp),%edx
  803bd1:	89 10                	mov    %edx,(%eax)
  803bd3:	eb 11                	jmp    803be6 <alloc_block+0x30f>
  803bd5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803bd8:	c1 e0 04             	shl    $0x4,%eax
  803bdb:	8d 90 80 e0 81 00    	lea    0x81e080(%eax),%edx
  803be1:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803be4:	89 02                	mov    %eax,(%edx)
  803be6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803be9:	c1 e0 04             	shl    $0x4,%eax
  803bec:	8d 90 84 e0 81 00    	lea    0x81e084(%eax),%edx
  803bf2:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803bf5:	89 02                	mov    %eax,(%edx)
  803bf7:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803bfa:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803c00:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803c03:	c1 e0 04             	shl    $0x4,%eax
  803c06:	05 8c e0 81 00       	add    $0x81e08c,%eax
  803c0b:	8b 00                	mov    (%eax),%eax
  803c0d:	8d 50 01             	lea    0x1(%eax),%edx
  803c10:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803c13:	c1 e0 04             	shl    $0x4,%eax
  803c16:	05 8c e0 81 00       	add    $0x81e08c,%eax
  803c1b:	89 10                	mov    %edx,(%eax)

		pageBlockInfoArr[page_index].block_size = size;
		int num_blocks = PAGE_SIZE / size ;
		pageBlockInfoArr[page_index].num_of_free_blocks= num_blocks - 1 ;

		for(int i=1; i< num_blocks; i++){
  803c1d:	ff 45 f0             	incl   -0x10(%ebp)
  803c20:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803c23:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  803c26:	0f 8c 4a ff ff ff    	jl     803b76 <alloc_block+0x29f>
			struct BlockElement *new_block = (struct BlockElement*)(page_va + i *size);
			LIST_INSERT_TAIL(&freeBlockLists[list_index], new_block);
		}
		return(void*)page_va;
  803c2c:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803c2f:	e9 3d 01 00 00       	jmp    803d71 <alloc_block+0x49a>
	}


	for(int i =list_index+1; i<= LOG2_MAX_SIZE - LOG2_MIN_SIZE; i++){
  803c34:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803c37:	40                   	inc    %eax
  803c38:	89 45 ec             	mov    %eax,-0x14(%ebp)
  803c3b:	e9 10 01 00 00       	jmp    803d50 <alloc_block+0x479>

		if(!LIST_EMPTY(&freeBlockLists[i])){
  803c40:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803c43:	c1 e0 04             	shl    $0x4,%eax
  803c46:	05 80 e0 81 00       	add    $0x81e080,%eax
  803c4b:	8b 00                	mov    (%eax),%eax
  803c4d:	85 c0                	test   %eax,%eax
  803c4f:	0f 84 f8 00 00 00    	je     803d4d <alloc_block+0x476>

			struct BlockElement *block = LIST_FIRST(&freeBlockLists[i]);
  803c55:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803c58:	c1 e0 04             	shl    $0x4,%eax
  803c5b:	05 80 e0 81 00       	add    $0x81e080,%eax
  803c60:	8b 00                	mov    (%eax),%eax
  803c62:	89 45 c8             	mov    %eax,-0x38(%ebp)
			LIST_REMOVE( &freeBlockLists[i], block);
  803c65:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  803c69:	75 17                	jne    803c82 <alloc_block+0x3ab>
  803c6b:	83 ec 04             	sub    $0x4,%esp
  803c6e:	68 8d 50 80 00       	push   $0x80508d
  803c73:	68 a8 00 00 00       	push   $0xa8
  803c78:	68 53 50 80 00       	push   $0x805053
  803c7d:	e8 42 c9 ff ff       	call   8005c4 <_panic>
  803c82:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803c85:	8b 00                	mov    (%eax),%eax
  803c87:	85 c0                	test   %eax,%eax
  803c89:	74 10                	je     803c9b <alloc_block+0x3c4>
  803c8b:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803c8e:	8b 00                	mov    (%eax),%eax
  803c90:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803c93:	8b 52 04             	mov    0x4(%edx),%edx
  803c96:	89 50 04             	mov    %edx,0x4(%eax)
  803c99:	eb 14                	jmp    803caf <alloc_block+0x3d8>
  803c9b:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803c9e:	8b 40 04             	mov    0x4(%eax),%eax
  803ca1:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803ca4:	c1 e2 04             	shl    $0x4,%edx
  803ca7:	81 c2 84 e0 81 00    	add    $0x81e084,%edx
  803cad:	89 02                	mov    %eax,(%edx)
  803caf:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803cb2:	8b 40 04             	mov    0x4(%eax),%eax
  803cb5:	85 c0                	test   %eax,%eax
  803cb7:	74 0f                	je     803cc8 <alloc_block+0x3f1>
  803cb9:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803cbc:	8b 40 04             	mov    0x4(%eax),%eax
  803cbf:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803cc2:	8b 12                	mov    (%edx),%edx
  803cc4:	89 10                	mov    %edx,(%eax)
  803cc6:	eb 13                	jmp    803cdb <alloc_block+0x404>
  803cc8:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803ccb:	8b 00                	mov    (%eax),%eax
  803ccd:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803cd0:	c1 e2 04             	shl    $0x4,%edx
  803cd3:	81 c2 80 e0 81 00    	add    $0x81e080,%edx
  803cd9:	89 02                	mov    %eax,(%edx)
  803cdb:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803cde:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803ce4:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803ce7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803cee:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803cf1:	c1 e0 04             	shl    $0x4,%eax
  803cf4:	05 8c e0 81 00       	add    $0x81e08c,%eax
  803cf9:	8b 00                	mov    (%eax),%eax
  803cfb:	8d 50 ff             	lea    -0x1(%eax),%edx
  803cfe:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803d01:	c1 e0 04             	shl    $0x4,%eax
  803d04:	05 8c e0 81 00       	add    $0x81e08c,%eax
  803d09:	89 10                	mov    %edx,(%eax)

			uint32 page_index = ((uint32)block - dynAllocStart)/ PAGE_SIZE;
  803d0b:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803d0e:	a1 64 e0 81 00       	mov    0x81e064,%eax
  803d13:	29 c2                	sub    %eax,%edx
  803d15:	89 d0                	mov    %edx,%eax
  803d17:	c1 e8 0c             	shr    $0xc,%eax
  803d1a:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			pageBlockInfoArr[page_index].num_of_free_blocks-- ;
  803d1d:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  803d20:	89 d0                	mov    %edx,%eax
  803d22:	01 c0                	add    %eax,%eax
  803d24:	01 d0                	add    %edx,%eax
  803d26:	c1 e0 02             	shl    $0x2,%eax
  803d29:	05 6a 60 80 00       	add    $0x80606a,%eax
  803d2e:	66 8b 00             	mov    (%eax),%ax
  803d31:	8d 50 ff             	lea    -0x1(%eax),%edx
  803d34:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  803d37:	89 c8                	mov    %ecx,%eax
  803d39:	01 c0                	add    %eax,%eax
  803d3b:	01 c8                	add    %ecx,%eax
  803d3d:	c1 e0 02             	shl    $0x2,%eax
  803d40:	05 6a 60 80 00       	add    $0x80606a,%eax
  803d45:	66 89 10             	mov    %dx,(%eax)

			return (void*)block;
  803d48:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803d4b:	eb 24                	jmp    803d71 <alloc_block+0x49a>
		}
		return(void*)page_va;
	}


	for(int i =list_index+1; i<= LOG2_MAX_SIZE - LOG2_MIN_SIZE; i++){
  803d4d:	ff 45 ec             	incl   -0x14(%ebp)
  803d50:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  803d54:	0f 8e e6 fe ff ff    	jle    803c40 <alloc_block+0x369>

			return (void*)block;
		}
	}

	panic("alloc_block: out of memory! ");
  803d5a:	83 ec 04             	sub    $0x4,%esp
  803d5d:	68 cf 50 80 00       	push   $0x8050cf
  803d62:	68 b1 00 00 00       	push   $0xb1
  803d67:	68 53 50 80 00       	push   $0x805053
  803d6c:	e8 53 c8 ff ff       	call   8005c4 <_panic>

	//Comment the following line
	//panic("alloc_block() Not implemented yet");

	//TODO: [PROJECT'25.BONUS#1] DYNAMIC ALLOCATOR - block if no free block
}
  803d71:	c9                   	leave  
  803d72:	c3                   	ret    

00803d73 <free_block>:

//===========================
// [4] FREE BLOCK:
//===========================
void free_block(void *va)
{
  803d73:	55                   	push   %ebp
  803d74:	89 e5                	mov    %esp,%ebp
  803d76:	83 ec 38             	sub    $0x38,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert((uint32)va >= dynAllocStart && (uint32)va < dynAllocEnd);
  803d79:	8b 55 08             	mov    0x8(%ebp),%edx
  803d7c:	a1 64 e0 81 00       	mov    0x81e064,%eax
  803d81:	39 c2                	cmp    %eax,%edx
  803d83:	72 0c                	jb     803d91 <free_block+0x1e>
  803d85:	8b 55 08             	mov    0x8(%ebp),%edx
  803d88:	a1 40 60 80 00       	mov    0x806040,%eax
  803d8d:	39 c2                	cmp    %eax,%edx
  803d8f:	72 19                	jb     803daa <free_block+0x37>
  803d91:	68 ec 50 80 00       	push   $0x8050ec
  803d96:	68 3e 50 80 00       	push   $0x80503e
  803d9b:	68 c3 00 00 00       	push   $0xc3
  803da0:	68 53 50 80 00       	push   $0x805053
  803da5:	e8 1a c8 ff ff       	call   8005c4 <_panic>
	//==================================================================================

	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #4 free_block
	//Your code is here

	uint32 page_index=((uint32)va - dynAllocStart)/ PAGE_SIZE;
  803daa:	8b 55 08             	mov    0x8(%ebp),%edx
  803dad:	a1 64 e0 81 00       	mov    0x81e064,%eax
  803db2:	29 c2                	sub    %eax,%edx
  803db4:	89 d0                	mov    %edx,%eax
  803db6:	c1 e8 0c             	shr    $0xc,%eax
  803db9:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 block_size = pageBlockInfoArr[page_index].block_size;
  803dbc:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803dbf:	89 d0                	mov    %edx,%eax
  803dc1:	01 c0                	add    %eax,%eax
  803dc3:	01 d0                	add    %edx,%eax
  803dc5:	c1 e0 02             	shl    $0x2,%eax
  803dc8:	05 68 60 80 00       	add    $0x806068,%eax
  803dcd:	8b 00                	mov    (%eax),%eax
  803dcf:	0f b7 c0             	movzwl %ax,%eax
  803dd2:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if(block_size == 0){
  803dd5:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803dd9:	75 17                	jne    803df2 <free_block+0x7f>
		panic("page is empty(already not allocated)");
  803ddb:	83 ec 04             	sub    $0x4,%esp
  803dde:	68 24 51 80 00       	push   $0x805124
  803de3:	68 cf 00 00 00       	push   $0xcf
  803de8:	68 53 50 80 00       	push   $0x805053
  803ded:	e8 d2 c7 ff ff       	call   8005c4 <_panic>
	}

	int list_index = log2(block_size) - LOG2_MIN_SIZE;
  803df2:	83 ec 0c             	sub    $0xc,%esp
  803df5:	ff 75 ec             	pushl  -0x14(%ebp)
  803df8:	e8 d8 f8 ff ff       	call   8036d5 <log2>
  803dfd:	83 c4 10             	add    $0x10,%esp
  803e00:	83 e8 03             	sub    $0x3,%eax
  803e03:	89 45 e8             	mov    %eax,-0x18(%ebp)
	// mn va l block "elta7weel mn virtual l phy hna"
	struct BlockElement *block = (struct BlockElement *)va;
  803e06:	8b 45 08             	mov    0x8(%ebp),%eax
  803e09:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	LIST_INSERT_TAIL(&freeBlockLists[list_index], block);
  803e0c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803e10:	75 17                	jne    803e29 <free_block+0xb6>
  803e12:	83 ec 04             	sub    $0x4,%esp
  803e15:	68 ac 50 80 00       	push   $0x8050ac
  803e1a:	68 d5 00 00 00       	push   $0xd5
  803e1f:	68 53 50 80 00       	push   $0x805053
  803e24:	e8 9b c7 ff ff       	call   8005c4 <_panic>
  803e29:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803e2c:	c1 e0 04             	shl    $0x4,%eax
  803e2f:	05 84 e0 81 00       	add    $0x81e084,%eax
  803e34:	8b 10                	mov    (%eax),%edx
  803e36:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803e39:	89 50 04             	mov    %edx,0x4(%eax)
  803e3c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803e3f:	8b 40 04             	mov    0x4(%eax),%eax
  803e42:	85 c0                	test   %eax,%eax
  803e44:	74 14                	je     803e5a <free_block+0xe7>
  803e46:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803e49:	c1 e0 04             	shl    $0x4,%eax
  803e4c:	05 84 e0 81 00       	add    $0x81e084,%eax
  803e51:	8b 00                	mov    (%eax),%eax
  803e53:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803e56:	89 10                	mov    %edx,(%eax)
  803e58:	eb 11                	jmp    803e6b <free_block+0xf8>
  803e5a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803e5d:	c1 e0 04             	shl    $0x4,%eax
  803e60:	8d 90 80 e0 81 00    	lea    0x81e080(%eax),%edx
  803e66:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803e69:	89 02                	mov    %eax,(%edx)
  803e6b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803e6e:	c1 e0 04             	shl    $0x4,%eax
  803e71:	8d 90 84 e0 81 00    	lea    0x81e084(%eax),%edx
  803e77:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803e7a:	89 02                	mov    %eax,(%edx)
  803e7c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803e7f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803e85:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803e88:	c1 e0 04             	shl    $0x4,%eax
  803e8b:	05 8c e0 81 00       	add    $0x81e08c,%eax
  803e90:	8b 00                	mov    (%eax),%eax
  803e92:	8d 50 01             	lea    0x1(%eax),%edx
  803e95:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803e98:	c1 e0 04             	shl    $0x4,%eax
  803e9b:	05 8c e0 81 00       	add    $0x81e08c,%eax
  803ea0:	89 10                	mov    %edx,(%eax)
	// b3d ma wdytha fy el freeBlockLists hzwed elfree elly fy el array 1
	pageBlockInfoArr[page_index].num_of_free_blocks++;
  803ea2:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803ea5:	89 d0                	mov    %edx,%eax
  803ea7:	01 c0                	add    %eax,%eax
  803ea9:	01 d0                	add    %edx,%eax
  803eab:	c1 e0 02             	shl    $0x2,%eax
  803eae:	05 6a 60 80 00       	add    $0x80606a,%eax
  803eb3:	66 8b 00             	mov    (%eax),%ax
  803eb6:	8d 50 01             	lea    0x1(%eax),%edx
  803eb9:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  803ebc:	89 c8                	mov    %ecx,%eax
  803ebe:	01 c0                	add    %eax,%eax
  803ec0:	01 c8                	add    %ecx,%eax
  803ec2:	c1 e0 02             	shl    $0x2,%eax
  803ec5:	05 6a 60 80 00       	add    $0x80606a,%eax
  803eca:	66 89 10             	mov    %dx,(%eax)
	int blocks_number = PAGE_SIZE / block_size;
  803ecd:	b8 00 10 00 00       	mov    $0x1000,%eax
  803ed2:	ba 00 00 00 00       	mov    $0x0,%edx
  803ed7:	f7 75 ec             	divl   -0x14(%ebp)
  803eda:	89 45 e0             	mov    %eax,-0x20(%ebp)
	if(pageBlockInfoArr[page_index].num_of_free_blocks == blocks_number){
  803edd:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803ee0:	89 d0                	mov    %edx,%eax
  803ee2:	01 c0                	add    %eax,%eax
  803ee4:	01 d0                	add    %edx,%eax
  803ee6:	c1 e0 02             	shl    $0x2,%eax
  803ee9:	05 6a 60 80 00       	add    $0x80606a,%eax
  803eee:	66 8b 00             	mov    (%eax),%ax
  803ef1:	0f b7 c0             	movzwl %ax,%eax
  803ef4:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  803ef7:	0f 85 d3 01 00 00    	jne    8040d0 <free_block+0x35d>
		struct BlockElement *itr = LIST_FIRST(&freeBlockLists[list_index]);
  803efd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803f00:	c1 e0 04             	shl    $0x4,%eax
  803f03:	05 80 e0 81 00       	add    $0x81e080,%eax
  803f08:	8b 00                	mov    (%eax),%eax
  803f0a:	89 45 f4             	mov    %eax,-0xc(%ebp)
		while(itr != NULL){
  803f0d:	e9 f1 00 00 00       	jmp    804003 <free_block+0x290>
			//lw ms7to el pointer mydy34 ->
			struct BlockElement *next = LIST_NEXT(itr);
  803f12:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803f15:	8b 00                	mov    (%eax),%eax
  803f17:	89 45 dc             	mov    %eax,-0x24(%ebp)
			uint32 page_beginning_address= dynAllocStart + page_index * PAGE_SIZE;
  803f1a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803f1d:	c1 e0 0c             	shl    $0xc,%eax
  803f20:	89 c2                	mov    %eax,%edx
  803f22:	a1 64 e0 81 00       	mov    0x81e064,%eax
  803f27:	01 d0                	add    %edx,%eax
  803f29:	89 45 d8             	mov    %eax,-0x28(%ebp)
			uint32 page_end_address = dynAllocStart + (page_index +1 )* PAGE_SIZE;
  803f2c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803f2f:	40                   	inc    %eax
  803f30:	c1 e0 0c             	shl    $0xc,%eax
  803f33:	89 c2                	mov    %eax,%edx
  803f35:	a1 64 e0 81 00       	mov    0x81e064,%eax
  803f3a:	01 d0                	add    %edx,%eax
  803f3c:	89 45 d4             	mov    %eax,-0x2c(%ebp)

			if((uint32)itr >= page_beginning_address && (uint32)itr < page_end_address){
  803f3f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803f42:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  803f45:	0f 82 b8 00 00 00    	jb     804003 <free_block+0x290>
  803f4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803f4e:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803f51:	0f 83 ac 00 00 00    	jae    804003 <free_block+0x290>
				LIST_REMOVE(&freeBlockLists[list_index], itr);
  803f57:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803f5b:	75 17                	jne    803f74 <free_block+0x201>
  803f5d:	83 ec 04             	sub    $0x4,%esp
  803f60:	68 8d 50 80 00       	push   $0x80508d
  803f65:	68 e2 00 00 00       	push   $0xe2
  803f6a:	68 53 50 80 00       	push   $0x805053
  803f6f:	e8 50 c6 ff ff       	call   8005c4 <_panic>
  803f74:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803f77:	8b 00                	mov    (%eax),%eax
  803f79:	85 c0                	test   %eax,%eax
  803f7b:	74 10                	je     803f8d <free_block+0x21a>
  803f7d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803f80:	8b 00                	mov    (%eax),%eax
  803f82:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803f85:	8b 52 04             	mov    0x4(%edx),%edx
  803f88:	89 50 04             	mov    %edx,0x4(%eax)
  803f8b:	eb 14                	jmp    803fa1 <free_block+0x22e>
  803f8d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803f90:	8b 40 04             	mov    0x4(%eax),%eax
  803f93:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803f96:	c1 e2 04             	shl    $0x4,%edx
  803f99:	81 c2 84 e0 81 00    	add    $0x81e084,%edx
  803f9f:	89 02                	mov    %eax,(%edx)
  803fa1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803fa4:	8b 40 04             	mov    0x4(%eax),%eax
  803fa7:	85 c0                	test   %eax,%eax
  803fa9:	74 0f                	je     803fba <free_block+0x247>
  803fab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803fae:	8b 40 04             	mov    0x4(%eax),%eax
  803fb1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803fb4:	8b 12                	mov    (%edx),%edx
  803fb6:	89 10                	mov    %edx,(%eax)
  803fb8:	eb 13                	jmp    803fcd <free_block+0x25a>
  803fba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803fbd:	8b 00                	mov    (%eax),%eax
  803fbf:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803fc2:	c1 e2 04             	shl    $0x4,%edx
  803fc5:	81 c2 80 e0 81 00    	add    $0x81e080,%edx
  803fcb:	89 02                	mov    %eax,(%edx)
  803fcd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803fd0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803fd6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803fd9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803fe0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803fe3:	c1 e0 04             	shl    $0x4,%eax
  803fe6:	05 8c e0 81 00       	add    $0x81e08c,%eax
  803feb:	8b 00                	mov    (%eax),%eax
  803fed:	8d 50 ff             	lea    -0x1(%eax),%edx
  803ff0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803ff3:	c1 e0 04             	shl    $0x4,%eax
  803ff6:	05 8c e0 81 00       	add    $0x81e08c,%eax
  803ffb:	89 10                	mov    %edx,(%eax)
				//y5o4 3la elly b3do
				itr = next;
  803ffd:	8b 45 dc             	mov    -0x24(%ebp),%eax
  804000:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// b3d ma wdytha fy el freeBlockLists hzwed elfree elly fy el array 1
	pageBlockInfoArr[page_index].num_of_free_blocks++;
	int blocks_number = PAGE_SIZE / block_size;
	if(pageBlockInfoArr[page_index].num_of_free_blocks == blocks_number){
		struct BlockElement *itr = LIST_FIRST(&freeBlockLists[list_index]);
		while(itr != NULL){
  804003:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  804007:	0f 85 05 ff ff ff    	jne    803f12 <free_block+0x19f>
				LIST_REMOVE(&freeBlockLists[list_index], itr);
				//y5o4 3la elly b3do
				itr = next;
			}
		}
		pageBlockInfoArr[page_index].block_size=0;
  80400d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  804010:	89 d0                	mov    %edx,%eax
  804012:	01 c0                	add    %eax,%eax
  804014:	01 d0                	add    %edx,%eax
  804016:	c1 e0 02             	shl    $0x2,%eax
  804019:	05 68 60 80 00       	add    $0x806068,%eax
  80401e:	66 c7 00 00 00       	movw   $0x0,(%eax)
		pageBlockInfoArr[page_index].num_of_free_blocks=0;
  804023:	8b 55 f0             	mov    -0x10(%ebp),%edx
  804026:	89 d0                	mov    %edx,%eax
  804028:	01 c0                	add    %eax,%eax
  80402a:	01 d0                	add    %edx,%eax
  80402c:	c1 e0 02             	shl    $0x2,%eax
  80402f:	05 6a 60 80 00       	add    $0x80606a,%eax
  804034:	66 c7 00 00 00       	movw   $0x0,(%eax)

		struct PageInfoElement *page_info = &pageBlockInfoArr[page_index];
  804039:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80403c:	89 d0                	mov    %edx,%eax
  80403e:	01 c0                	add    %eax,%eax
  804040:	01 d0                	add    %edx,%eax
  804042:	c1 e0 02             	shl    $0x2,%eax
  804045:	05 60 60 80 00       	add    $0x806060,%eax
  80404a:	89 45 d0             	mov    %eax,-0x30(%ebp)
		LIST_INSERT_TAIL(&freePagesList, page_info);
  80404d:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  804051:	75 17                	jne    80406a <free_block+0x2f7>
  804053:	83 ec 04             	sub    $0x4,%esp
  804056:	68 ac 50 80 00       	push   $0x8050ac
  80405b:	68 eb 00 00 00       	push   $0xeb
  804060:	68 53 50 80 00       	push   $0x805053
  804065:	e8 5a c5 ff ff       	call   8005c4 <_panic>
  80406a:	8b 15 4c 60 80 00    	mov    0x80604c,%edx
  804070:	8b 45 d0             	mov    -0x30(%ebp),%eax
  804073:	89 50 04             	mov    %edx,0x4(%eax)
  804076:	8b 45 d0             	mov    -0x30(%ebp),%eax
  804079:	8b 40 04             	mov    0x4(%eax),%eax
  80407c:	85 c0                	test   %eax,%eax
  80407e:	74 0c                	je     80408c <free_block+0x319>
  804080:	a1 4c 60 80 00       	mov    0x80604c,%eax
  804085:	8b 55 d0             	mov    -0x30(%ebp),%edx
  804088:	89 10                	mov    %edx,(%eax)
  80408a:	eb 08                	jmp    804094 <free_block+0x321>
  80408c:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80408f:	a3 48 60 80 00       	mov    %eax,0x806048
  804094:	8b 45 d0             	mov    -0x30(%ebp),%eax
  804097:	a3 4c 60 80 00       	mov    %eax,0x80604c
  80409c:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80409f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8040a5:	a1 54 60 80 00       	mov    0x806054,%eax
  8040aa:	40                   	inc    %eax
  8040ab:	a3 54 60 80 00       	mov    %eax,0x806054
		uint32 page_va = to_page_va(page_info);
  8040b0:	83 ec 0c             	sub    $0xc,%esp
  8040b3:	ff 75 d0             	pushl  -0x30(%ebp)
  8040b6:	e8 ce f5 ff ff       	call   803689 <to_page_va>
  8040bb:	83 c4 10             	add    $0x10,%esp
  8040be:	89 45 cc             	mov    %eax,-0x34(%ebp)
		return_page((void *)page_va);
  8040c1:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8040c4:	83 ec 0c             	sub    $0xc,%esp
  8040c7:	50                   	push   %eax
  8040c8:	e8 9e d7 ff ff       	call   80186b <return_page>
  8040cd:	83 c4 10             	add    $0x10,%esp
	}


	//Comment the following line
	//panic("free_block() Not implemented yet");
}
  8040d0:	90                   	nop
  8040d1:	c9                   	leave  
  8040d2:	c3                   	ret    

008040d3 <realloc_block>:

//===========================
// [1] REALLOCATE BLOCK:
//===========================
void *realloc_block(void* va, uint32 new_size)
{
  8040d3:	55                   	push   %ebp
  8040d4:	89 e5                	mov    %esp,%ebp
  8040d6:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.BONUS#2] KERNEL REALLOC - realloc_block
	//Your code is here
	//Comment the following line
	panic("realloc_block() Not implemented yet");
  8040d9:	83 ec 04             	sub    $0x4,%esp
  8040dc:	68 4c 51 80 00       	push   $0x80514c
  8040e1:	68 01 01 00 00       	push   $0x101
  8040e6:	68 53 50 80 00       	push   $0x805053
  8040eb:	e8 d4 c4 ff ff       	call   8005c4 <_panic>

008040f0 <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  8040f0:	55                   	push   %ebp
  8040f1:	89 e5                	mov    %esp,%ebp
  8040f3:	83 ec 30             	sub    $0x30,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  8040f6:	8b 55 08             	mov    0x8(%ebp),%edx
  8040f9:	89 d0                	mov    %edx,%eax
  8040fb:	c1 e0 02             	shl    $0x2,%eax
  8040fe:	01 d0                	add    %edx,%eax
  804100:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  804107:	01 d0                	add    %edx,%eax
  804109:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  804110:	01 d0                	add    %edx,%eax
  804112:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  804119:	01 d0                	add    %edx,%eax
  80411b:	c1 e0 04             	shl    $0x4,%eax
  80411e:	89 45 f8             	mov    %eax,-0x8(%ebp)
	uint32 cycles_counter =0;
  804121:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)

static inline __attribute__((always_inline)) struct uint64 get_virtual_time_user()
{
	struct uint64 result;

	__asm __volatile("rdtsc\n"
  804128:	0f 31                	rdtsc  
  80412a:	89 45 e8             	mov    %eax,-0x18(%ebp)
  80412d:	89 55 ec             	mov    %edx,-0x14(%ebp)
	: "=a" (result.low), "=d" (result.hi)
	);

	return result;
  804130:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804133:	8b 55 ec             	mov    -0x14(%ebp),%edx
  804136:	89 45 f0             	mov    %eax,-0x10(%ebp)
  804139:	89 55 f4             	mov    %edx,-0xc(%ebp)

	/*2024*/ //USE A USER-SIDE VERSION OF THIS FUNCTION TO AVOID SLOW-DOWN THE PERFORMANCE DUE SYS_CALL (el7 :))
	//struct uint64 baseTime = sys_get_virtual_time() ;
	struct uint64 baseTime = get_virtual_time_user() ;
	while(cycles_counter<time_in_cycles)
  80413c:	eb 46                	jmp    804184 <env_sleep+0x94>

static inline __attribute__((always_inline)) struct uint64 get_virtual_time_user()
{
	struct uint64 result;

	__asm __volatile("rdtsc\n"
  80413e:	0f 31                	rdtsc  
  804140:	89 45 d0             	mov    %eax,-0x30(%ebp)
  804143:	89 55 d4             	mov    %edx,-0x2c(%ebp)
	: "=a" (result.low), "=d" (result.hi)
	);

	return result;
  804146:	8b 45 d0             	mov    -0x30(%ebp),%eax
  804149:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80414c:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80414f:	89 55 e4             	mov    %edx,-0x1c(%ebp)

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  804152:	8b 55 e0             	mov    -0x20(%ebp),%edx
  804155:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804158:	29 c2                	sub    %eax,%edx
  80415a:	89 d0                	mov    %edx,%eax
  80415c:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  80415f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  804162:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804165:	89 d1                	mov    %edx,%ecx
  804167:	29 c1                	sub    %eax,%ecx
  804169:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80416c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80416f:	39 c2                	cmp    %eax,%edx
  804171:	0f 97 c0             	seta   %al
  804174:	0f b6 c0             	movzbl %al,%eax
  804177:	29 c1                	sub    %eax,%ecx
  804179:	89 c8                	mov    %ecx,%eax
  80417b:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  80417e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  804181:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint32 cycles_counter =0;

	/*2024*/ //USE A USER-SIDE VERSION OF THIS FUNCTION TO AVOID SLOW-DOWN THE PERFORMANCE DUE SYS_CALL (el7 :))
	//struct uint64 baseTime = sys_get_virtual_time() ;
	struct uint64 baseTime = get_virtual_time_user() ;
	while(cycles_counter<time_in_cycles)
  804184:	8b 45 fc             	mov    -0x4(%ebp),%eax
  804187:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80418a:	72 b2                	jb     80413e <env_sleep+0x4e>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  80418c:	90                   	nop
  80418d:	c9                   	leave  
  80418e:	c3                   	ret    

0080418f <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  80418f:	55                   	push   %ebp
  804190:	89 e5                	mov    %esp,%ebp
  804192:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  804195:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  80419c:	eb 03                	jmp    8041a1 <busy_wait+0x12>
  80419e:	ff 45 fc             	incl   -0x4(%ebp)
  8041a1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8041a4:	3b 45 08             	cmp    0x8(%ebp),%eax
  8041a7:	72 f5                	jb     80419e <busy_wait+0xf>
	return i;
  8041a9:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8041ac:	c9                   	leave  
  8041ad:	c3                   	ret    

008041ae <init_uspinlock>:
#include "inc/uspinlock.h"

extern volatile struct Env *myEnv;

void init_uspinlock(struct uspinlock *lk, char *name, bool isOpened)
{
  8041ae:	55                   	push   %ebp
  8041af:	89 e5                	mov    %esp,%ebp
  8041b1:	83 ec 08             	sub    $0x8,%esp
	assert(isOpened == 0 || isOpened == 1);
  8041b4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8041b8:	74 1c                	je     8041d6 <init_uspinlock+0x28>
  8041ba:	83 7d 10 01          	cmpl   $0x1,0x10(%ebp)
  8041be:	74 16                	je     8041d6 <init_uspinlock+0x28>
  8041c0:	68 70 51 80 00       	push   $0x805170
  8041c5:	68 8f 51 80 00       	push   $0x80518f
  8041ca:	6a 10                	push   $0x10
  8041cc:	68 a4 51 80 00       	push   $0x8051a4
  8041d1:	e8 ee c3 ff ff       	call   8005c4 <_panic>
	strcpy(lk->name, name);
  8041d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8041d9:	83 c0 04             	add    $0x4,%eax
  8041dc:	83 ec 08             	sub    $0x8,%esp
  8041df:	ff 75 0c             	pushl  0xc(%ebp)
  8041e2:	50                   	push   %eax
  8041e3:	e8 d2 cd ff ff       	call   800fba <strcpy>
  8041e8:	83 c4 10             	add    $0x10,%esp
	lk->locked = (1 - isOpened);
  8041eb:	b8 01 00 00 00       	mov    $0x1,%eax
  8041f0:	2b 45 10             	sub    0x10(%ebp),%eax
  8041f3:	89 c2                	mov    %eax,%edx
  8041f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8041f8:	89 10                	mov    %edx,(%eax)
}
  8041fa:	90                   	nop
  8041fb:	c9                   	leave  
  8041fc:	c3                   	ret    

008041fd <acquire_uspinlock>:
// Acquire the lock.
// Loops (spins) until the lock is acquired.
// Holding a lock for a long time may cause
// other CPUs to waste time spinning to acquire it.
void acquire_uspinlock(struct uspinlock *lk)
{
  8041fd:	55                   	push   %ebp
  8041fe:	89 e5                	mov    %esp,%ebp
  804200:	83 ec 18             	sub    $0x18,%esp
	// The xchg is atomic.
	while(xchg(&lk->locked, 1) != 0) ;
  804203:	90                   	nop
  804204:	8b 45 08             	mov    0x8(%ebp),%eax
  804207:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80420a:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
xchg(volatile uint32 *addr, uint32 newval)
{
  uint32 result;

  // The + in "+m" denotes a read-modify-write operand.
  __asm __volatile("lock; xchgl %0, %1" :
  804211:	8b 55 f4             	mov    -0xc(%ebp),%edx
  804214:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804217:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  80421a:	f0 87 02             	lock xchg %eax,(%edx)
  80421d:	89 45 ec             	mov    %eax,-0x14(%ebp)
               "+m" (*addr), "=a" (result) :
               "1" (newval) :
               "cc");
  return result;
  804220:	8b 45 ec             	mov    -0x14(%ebp),%eax
  804223:	85 c0                	test   %eax,%eax
  804225:	75 dd                	jne    804204 <acquire_uspinlock+0x7>

	cprintf("[%d: %s] ACQUIRED spinlock [%s]\n", myEnv->env_id, myEnv->prog_name, lk->name);
  804227:	8b 45 08             	mov    0x8(%ebp),%eax
  80422a:	8d 48 04             	lea    0x4(%eax),%ecx
  80422d:	a1 20 60 80 00       	mov    0x806020,%eax
  804232:	8d 50 20             	lea    0x20(%eax),%edx
  804235:	a1 20 60 80 00       	mov    0x806020,%eax
  80423a:	8b 40 10             	mov    0x10(%eax),%eax
  80423d:	51                   	push   %ecx
  80423e:	52                   	push   %edx
  80423f:	50                   	push   %eax
  804240:	68 b4 51 80 00       	push   $0x8051b4
  804245:	e8 48 c6 ff ff       	call   800892 <cprintf>
  80424a:	83 c4 10             	add    $0x10,%esp

	// Tell the C compiler and the processor to not move loads or stores
	// past this point, to ensure that the critical section's memory
	// references happen after the lock is acquired.
	__sync_synchronize();
  80424d:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
}
  804252:	90                   	nop
  804253:	c9                   	leave  
  804254:	c3                   	ret    

00804255 <release_uspinlock>:

// Release the lock.
void release_uspinlock(struct uspinlock *lk)
{
  804255:	55                   	push   %ebp
  804256:	89 e5                	mov    %esp,%ebp
  804258:	83 ec 08             	sub    $0x8,%esp
	if(!(lk->locked))
  80425b:	8b 45 08             	mov    0x8(%ebp),%eax
  80425e:	8b 00                	mov    (%eax),%eax
  804260:	85 c0                	test   %eax,%eax
  804262:	75 18                	jne    80427c <release_uspinlock+0x27>
	{
		panic("release: lock \"%s\" is not held!", lk->name);
  804264:	8b 45 08             	mov    0x8(%ebp),%eax
  804267:	83 c0 04             	add    $0x4,%eax
  80426a:	50                   	push   %eax
  80426b:	68 d8 51 80 00       	push   $0x8051d8
  804270:	6a 2b                	push   $0x2b
  804272:	68 a4 51 80 00       	push   $0x8051a4
  804277:	e8 48 c3 ff ff       	call   8005c4 <_panic>
	// Tell the C compiler and the processor to not move loads or stores
	// past this point, to ensure that all the stores in the critical
	// section are visible to other cores before the lock is released.
	// Both the C compiler and the hardware may re-order loads and
	// stores; __sync_synchronize() tells them both not to.
	__sync_synchronize();
  80427c:	f0 83 0c 24 00       	lock orl $0x0,(%esp)

	// Release the lock, equivalent to lk->locked = 0.
	// This code can't use a C assignment, since it might
	// not be atomic. A real OS would use C atomics here.
	asm volatile("movl $0, %0" : "+m" (lk->locked) : );
  804281:	8b 45 08             	mov    0x8(%ebp),%eax
  804284:	8b 55 08             	mov    0x8(%ebp),%edx
  804287:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	cprintf("[%d: %s] RELEASED spinlock [%s]\n", myEnv->env_id, myEnv->prog_name, lk->name);
  80428d:	8b 45 08             	mov    0x8(%ebp),%eax
  804290:	8d 48 04             	lea    0x4(%eax),%ecx
  804293:	a1 20 60 80 00       	mov    0x806020,%eax
  804298:	8d 50 20             	lea    0x20(%eax),%edx
  80429b:	a1 20 60 80 00       	mov    0x806020,%eax
  8042a0:	8b 40 10             	mov    0x10(%eax),%eax
  8042a3:	51                   	push   %ecx
  8042a4:	52                   	push   %edx
  8042a5:	50                   	push   %eax
  8042a6:	68 f8 51 80 00       	push   $0x8051f8
  8042ab:	e8 e2 c5 ff ff       	call   800892 <cprintf>
  8042b0:	83 c4 10             	add    $0x10,%esp
}
  8042b3:	90                   	nop
  8042b4:	c9                   	leave  
  8042b5:	c3                   	ret    
  8042b6:	66 90                	xchg   %ax,%ax

008042b8 <__udivdi3>:
  8042b8:	55                   	push   %ebp
  8042b9:	57                   	push   %edi
  8042ba:	56                   	push   %esi
  8042bb:	53                   	push   %ebx
  8042bc:	83 ec 1c             	sub    $0x1c,%esp
  8042bf:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8042c3:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8042c7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8042cb:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8042cf:	89 ca                	mov    %ecx,%edx
  8042d1:	89 f8                	mov    %edi,%eax
  8042d3:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8042d7:	85 f6                	test   %esi,%esi
  8042d9:	75 2d                	jne    804308 <__udivdi3+0x50>
  8042db:	39 cf                	cmp    %ecx,%edi
  8042dd:	77 65                	ja     804344 <__udivdi3+0x8c>
  8042df:	89 fd                	mov    %edi,%ebp
  8042e1:	85 ff                	test   %edi,%edi
  8042e3:	75 0b                	jne    8042f0 <__udivdi3+0x38>
  8042e5:	b8 01 00 00 00       	mov    $0x1,%eax
  8042ea:	31 d2                	xor    %edx,%edx
  8042ec:	f7 f7                	div    %edi
  8042ee:	89 c5                	mov    %eax,%ebp
  8042f0:	31 d2                	xor    %edx,%edx
  8042f2:	89 c8                	mov    %ecx,%eax
  8042f4:	f7 f5                	div    %ebp
  8042f6:	89 c1                	mov    %eax,%ecx
  8042f8:	89 d8                	mov    %ebx,%eax
  8042fa:	f7 f5                	div    %ebp
  8042fc:	89 cf                	mov    %ecx,%edi
  8042fe:	89 fa                	mov    %edi,%edx
  804300:	83 c4 1c             	add    $0x1c,%esp
  804303:	5b                   	pop    %ebx
  804304:	5e                   	pop    %esi
  804305:	5f                   	pop    %edi
  804306:	5d                   	pop    %ebp
  804307:	c3                   	ret    
  804308:	39 ce                	cmp    %ecx,%esi
  80430a:	77 28                	ja     804334 <__udivdi3+0x7c>
  80430c:	0f bd fe             	bsr    %esi,%edi
  80430f:	83 f7 1f             	xor    $0x1f,%edi
  804312:	75 40                	jne    804354 <__udivdi3+0x9c>
  804314:	39 ce                	cmp    %ecx,%esi
  804316:	72 0a                	jb     804322 <__udivdi3+0x6a>
  804318:	3b 44 24 08          	cmp    0x8(%esp),%eax
  80431c:	0f 87 9e 00 00 00    	ja     8043c0 <__udivdi3+0x108>
  804322:	b8 01 00 00 00       	mov    $0x1,%eax
  804327:	89 fa                	mov    %edi,%edx
  804329:	83 c4 1c             	add    $0x1c,%esp
  80432c:	5b                   	pop    %ebx
  80432d:	5e                   	pop    %esi
  80432e:	5f                   	pop    %edi
  80432f:	5d                   	pop    %ebp
  804330:	c3                   	ret    
  804331:	8d 76 00             	lea    0x0(%esi),%esi
  804334:	31 ff                	xor    %edi,%edi
  804336:	31 c0                	xor    %eax,%eax
  804338:	89 fa                	mov    %edi,%edx
  80433a:	83 c4 1c             	add    $0x1c,%esp
  80433d:	5b                   	pop    %ebx
  80433e:	5e                   	pop    %esi
  80433f:	5f                   	pop    %edi
  804340:	5d                   	pop    %ebp
  804341:	c3                   	ret    
  804342:	66 90                	xchg   %ax,%ax
  804344:	89 d8                	mov    %ebx,%eax
  804346:	f7 f7                	div    %edi
  804348:	31 ff                	xor    %edi,%edi
  80434a:	89 fa                	mov    %edi,%edx
  80434c:	83 c4 1c             	add    $0x1c,%esp
  80434f:	5b                   	pop    %ebx
  804350:	5e                   	pop    %esi
  804351:	5f                   	pop    %edi
  804352:	5d                   	pop    %ebp
  804353:	c3                   	ret    
  804354:	bd 20 00 00 00       	mov    $0x20,%ebp
  804359:	89 eb                	mov    %ebp,%ebx
  80435b:	29 fb                	sub    %edi,%ebx
  80435d:	89 f9                	mov    %edi,%ecx
  80435f:	d3 e6                	shl    %cl,%esi
  804361:	89 c5                	mov    %eax,%ebp
  804363:	88 d9                	mov    %bl,%cl
  804365:	d3 ed                	shr    %cl,%ebp
  804367:	89 e9                	mov    %ebp,%ecx
  804369:	09 f1                	or     %esi,%ecx
  80436b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80436f:	89 f9                	mov    %edi,%ecx
  804371:	d3 e0                	shl    %cl,%eax
  804373:	89 c5                	mov    %eax,%ebp
  804375:	89 d6                	mov    %edx,%esi
  804377:	88 d9                	mov    %bl,%cl
  804379:	d3 ee                	shr    %cl,%esi
  80437b:	89 f9                	mov    %edi,%ecx
  80437d:	d3 e2                	shl    %cl,%edx
  80437f:	8b 44 24 08          	mov    0x8(%esp),%eax
  804383:	88 d9                	mov    %bl,%cl
  804385:	d3 e8                	shr    %cl,%eax
  804387:	09 c2                	or     %eax,%edx
  804389:	89 d0                	mov    %edx,%eax
  80438b:	89 f2                	mov    %esi,%edx
  80438d:	f7 74 24 0c          	divl   0xc(%esp)
  804391:	89 d6                	mov    %edx,%esi
  804393:	89 c3                	mov    %eax,%ebx
  804395:	f7 e5                	mul    %ebp
  804397:	39 d6                	cmp    %edx,%esi
  804399:	72 19                	jb     8043b4 <__udivdi3+0xfc>
  80439b:	74 0b                	je     8043a8 <__udivdi3+0xf0>
  80439d:	89 d8                	mov    %ebx,%eax
  80439f:	31 ff                	xor    %edi,%edi
  8043a1:	e9 58 ff ff ff       	jmp    8042fe <__udivdi3+0x46>
  8043a6:	66 90                	xchg   %ax,%ax
  8043a8:	8b 54 24 08          	mov    0x8(%esp),%edx
  8043ac:	89 f9                	mov    %edi,%ecx
  8043ae:	d3 e2                	shl    %cl,%edx
  8043b0:	39 c2                	cmp    %eax,%edx
  8043b2:	73 e9                	jae    80439d <__udivdi3+0xe5>
  8043b4:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8043b7:	31 ff                	xor    %edi,%edi
  8043b9:	e9 40 ff ff ff       	jmp    8042fe <__udivdi3+0x46>
  8043be:	66 90                	xchg   %ax,%ax
  8043c0:	31 c0                	xor    %eax,%eax
  8043c2:	e9 37 ff ff ff       	jmp    8042fe <__udivdi3+0x46>
  8043c7:	90                   	nop

008043c8 <__umoddi3>:
  8043c8:	55                   	push   %ebp
  8043c9:	57                   	push   %edi
  8043ca:	56                   	push   %esi
  8043cb:	53                   	push   %ebx
  8043cc:	83 ec 1c             	sub    $0x1c,%esp
  8043cf:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8043d3:	8b 74 24 34          	mov    0x34(%esp),%esi
  8043d7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8043db:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8043df:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8043e3:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8043e7:	89 f3                	mov    %esi,%ebx
  8043e9:	89 fa                	mov    %edi,%edx
  8043eb:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8043ef:	89 34 24             	mov    %esi,(%esp)
  8043f2:	85 c0                	test   %eax,%eax
  8043f4:	75 1a                	jne    804410 <__umoddi3+0x48>
  8043f6:	39 f7                	cmp    %esi,%edi
  8043f8:	0f 86 a2 00 00 00    	jbe    8044a0 <__umoddi3+0xd8>
  8043fe:	89 c8                	mov    %ecx,%eax
  804400:	89 f2                	mov    %esi,%edx
  804402:	f7 f7                	div    %edi
  804404:	89 d0                	mov    %edx,%eax
  804406:	31 d2                	xor    %edx,%edx
  804408:	83 c4 1c             	add    $0x1c,%esp
  80440b:	5b                   	pop    %ebx
  80440c:	5e                   	pop    %esi
  80440d:	5f                   	pop    %edi
  80440e:	5d                   	pop    %ebp
  80440f:	c3                   	ret    
  804410:	39 f0                	cmp    %esi,%eax
  804412:	0f 87 ac 00 00 00    	ja     8044c4 <__umoddi3+0xfc>
  804418:	0f bd e8             	bsr    %eax,%ebp
  80441b:	83 f5 1f             	xor    $0x1f,%ebp
  80441e:	0f 84 ac 00 00 00    	je     8044d0 <__umoddi3+0x108>
  804424:	bf 20 00 00 00       	mov    $0x20,%edi
  804429:	29 ef                	sub    %ebp,%edi
  80442b:	89 fe                	mov    %edi,%esi
  80442d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  804431:	89 e9                	mov    %ebp,%ecx
  804433:	d3 e0                	shl    %cl,%eax
  804435:	89 d7                	mov    %edx,%edi
  804437:	89 f1                	mov    %esi,%ecx
  804439:	d3 ef                	shr    %cl,%edi
  80443b:	09 c7                	or     %eax,%edi
  80443d:	89 e9                	mov    %ebp,%ecx
  80443f:	d3 e2                	shl    %cl,%edx
  804441:	89 14 24             	mov    %edx,(%esp)
  804444:	89 d8                	mov    %ebx,%eax
  804446:	d3 e0                	shl    %cl,%eax
  804448:	89 c2                	mov    %eax,%edx
  80444a:	8b 44 24 08          	mov    0x8(%esp),%eax
  80444e:	d3 e0                	shl    %cl,%eax
  804450:	89 44 24 04          	mov    %eax,0x4(%esp)
  804454:	8b 44 24 08          	mov    0x8(%esp),%eax
  804458:	89 f1                	mov    %esi,%ecx
  80445a:	d3 e8                	shr    %cl,%eax
  80445c:	09 d0                	or     %edx,%eax
  80445e:	d3 eb                	shr    %cl,%ebx
  804460:	89 da                	mov    %ebx,%edx
  804462:	f7 f7                	div    %edi
  804464:	89 d3                	mov    %edx,%ebx
  804466:	f7 24 24             	mull   (%esp)
  804469:	89 c6                	mov    %eax,%esi
  80446b:	89 d1                	mov    %edx,%ecx
  80446d:	39 d3                	cmp    %edx,%ebx
  80446f:	0f 82 87 00 00 00    	jb     8044fc <__umoddi3+0x134>
  804475:	0f 84 91 00 00 00    	je     80450c <__umoddi3+0x144>
  80447b:	8b 54 24 04          	mov    0x4(%esp),%edx
  80447f:	29 f2                	sub    %esi,%edx
  804481:	19 cb                	sbb    %ecx,%ebx
  804483:	89 d8                	mov    %ebx,%eax
  804485:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  804489:	d3 e0                	shl    %cl,%eax
  80448b:	89 e9                	mov    %ebp,%ecx
  80448d:	d3 ea                	shr    %cl,%edx
  80448f:	09 d0                	or     %edx,%eax
  804491:	89 e9                	mov    %ebp,%ecx
  804493:	d3 eb                	shr    %cl,%ebx
  804495:	89 da                	mov    %ebx,%edx
  804497:	83 c4 1c             	add    $0x1c,%esp
  80449a:	5b                   	pop    %ebx
  80449b:	5e                   	pop    %esi
  80449c:	5f                   	pop    %edi
  80449d:	5d                   	pop    %ebp
  80449e:	c3                   	ret    
  80449f:	90                   	nop
  8044a0:	89 fd                	mov    %edi,%ebp
  8044a2:	85 ff                	test   %edi,%edi
  8044a4:	75 0b                	jne    8044b1 <__umoddi3+0xe9>
  8044a6:	b8 01 00 00 00       	mov    $0x1,%eax
  8044ab:	31 d2                	xor    %edx,%edx
  8044ad:	f7 f7                	div    %edi
  8044af:	89 c5                	mov    %eax,%ebp
  8044b1:	89 f0                	mov    %esi,%eax
  8044b3:	31 d2                	xor    %edx,%edx
  8044b5:	f7 f5                	div    %ebp
  8044b7:	89 c8                	mov    %ecx,%eax
  8044b9:	f7 f5                	div    %ebp
  8044bb:	89 d0                	mov    %edx,%eax
  8044bd:	e9 44 ff ff ff       	jmp    804406 <__umoddi3+0x3e>
  8044c2:	66 90                	xchg   %ax,%ax
  8044c4:	89 c8                	mov    %ecx,%eax
  8044c6:	89 f2                	mov    %esi,%edx
  8044c8:	83 c4 1c             	add    $0x1c,%esp
  8044cb:	5b                   	pop    %ebx
  8044cc:	5e                   	pop    %esi
  8044cd:	5f                   	pop    %edi
  8044ce:	5d                   	pop    %ebp
  8044cf:	c3                   	ret    
  8044d0:	3b 04 24             	cmp    (%esp),%eax
  8044d3:	72 06                	jb     8044db <__umoddi3+0x113>
  8044d5:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8044d9:	77 0f                	ja     8044ea <__umoddi3+0x122>
  8044db:	89 f2                	mov    %esi,%edx
  8044dd:	29 f9                	sub    %edi,%ecx
  8044df:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8044e3:	89 14 24             	mov    %edx,(%esp)
  8044e6:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8044ea:	8b 44 24 04          	mov    0x4(%esp),%eax
  8044ee:	8b 14 24             	mov    (%esp),%edx
  8044f1:	83 c4 1c             	add    $0x1c,%esp
  8044f4:	5b                   	pop    %ebx
  8044f5:	5e                   	pop    %esi
  8044f6:	5f                   	pop    %edi
  8044f7:	5d                   	pop    %ebp
  8044f8:	c3                   	ret    
  8044f9:	8d 76 00             	lea    0x0(%esi),%esi
  8044fc:	2b 04 24             	sub    (%esp),%eax
  8044ff:	19 fa                	sbb    %edi,%edx
  804501:	89 d1                	mov    %edx,%ecx
  804503:	89 c6                	mov    %eax,%esi
  804505:	e9 71 ff ff ff       	jmp    80447b <__umoddi3+0xb3>
  80450a:	66 90                	xchg   %ax,%ax
  80450c:	39 44 24 04          	cmp    %eax,0x4(%esp)
  804510:	72 ea                	jb     8044fc <__umoddi3+0x134>
  804512:	89 d9                	mov    %ebx,%ecx
  804514:	e9 62 ff ff ff       	jmp    80447b <__umoddi3+0xb3>
