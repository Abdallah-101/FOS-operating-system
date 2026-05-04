
obj/user/tst_envfree6:     file format elf32-i386


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
  800031:	e8 a1 02 00 00       	call   8002d7 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
// Scenario that tests the usage of shared variables
#include <inc/lib.h>

void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	57                   	push   %edi
  80003c:	56                   	push   %esi
  80003d:	53                   	push   %ebx
  80003e:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
	// Testing scenario 6: Semaphores & shared variables
	// Testing removing the shared variables and semaphores
	int *numOfFinished = smalloc("finishedCount", sizeof(int), 1) ;
  800044:	83 ec 04             	sub    $0x4,%esp
  800047:	6a 01                	push   $0x1
  800049:	6a 04                	push   $0x4
  80004b:	68 00 44 80 00       	push   $0x804400
  800050:	e8 b0 23 00 00       	call   802405 <smalloc>
  800055:	83 c4 10             	add    $0x10,%esp
  800058:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	*numOfFinished = 0 ;
  80005b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80005e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	char getksbrkCmd[100] = "__getKernelSBreak__";
  800064:	8d 85 54 ff ff ff    	lea    -0xac(%ebp),%eax
  80006a:	bb 01 46 80 00       	mov    $0x804601,%ebx
  80006f:	ba 05 00 00 00       	mov    $0x5,%edx
  800074:	89 c7                	mov    %eax,%edi
  800076:	89 de                	mov    %ebx,%esi
  800078:	89 d1                	mov    %edx,%ecx
  80007a:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  80007c:	8d 95 68 ff ff ff    	lea    -0x98(%ebp),%edx
  800082:	b9 14 00 00 00       	mov    $0x14,%ecx
  800087:	b8 00 00 00 00       	mov    $0x0,%eax
  80008c:	89 d7                	mov    %edx,%edi
  80008e:	f3 ab                	rep stos %eax,%es:(%edi)
	uint32 ksbrk_before ;
	sys_utilities(getksbrkCmd, (uint32)&ksbrk_before);
  800090:	8d 85 50 ff ff ff    	lea    -0xb0(%ebp),%eax
  800096:	83 ec 08             	sub    $0x8,%esp
  800099:	50                   	push   %eax
  80009a:	8d 85 54 ff ff ff    	lea    -0xac(%ebp),%eax
  8000a0:	50                   	push   %eax
  8000a1:	e8 22 34 00 00       	call   8034c8 <sys_utilities>
  8000a6:	83 c4 10             	add    $0x10,%esp

	int freeFrames_before = sys_calculate_free_frames() ;
  8000a9:	e8 1b 30 00 00       	call   8030c9 <sys_calculate_free_frames>
  8000ae:	89 45 e0             	mov    %eax,-0x20(%ebp)
	int usedDiskPages_before = sys_pf_calculate_allocated_pages() ;
  8000b1:	e8 5e 30 00 00       	call   803114 <sys_pf_calculate_allocated_pages>
  8000b6:	89 45 dc             	mov    %eax,-0x24(%ebp)
	cprintf("\n---# of free frames before running programs = %d\n", freeFrames_before);
  8000b9:	83 ec 08             	sub    $0x8,%esp
  8000bc:	ff 75 e0             	pushl  -0x20(%ebp)
  8000bf:	68 10 44 80 00       	push   $0x804410
  8000c4:	e8 95 06 00 00       	call   80075e <cprintf>
  8000c9:	83 c4 10             	add    $0x10,%esp

	int32 envIdProcessA = sys_create_env("ef_tshr1", myEnv->page_WS_max_size, (myEnv->SecondListSize),50);
  8000cc:	a1 20 60 80 00       	mov    0x806020,%eax
  8000d1:	8b 80 a0 05 00 00    	mov    0x5a0(%eax),%eax
  8000d7:	89 c2                	mov    %eax,%edx
  8000d9:	a1 20 60 80 00       	mov    0x806020,%eax
  8000de:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  8000e4:	6a 32                	push   $0x32
  8000e6:	52                   	push   %edx
  8000e7:	50                   	push   %eax
  8000e8:	68 43 44 80 00       	push   $0x804443
  8000ed:	e8 32 31 00 00       	call   803224 <sys_create_env>
  8000f2:	83 c4 10             	add    $0x10,%esp
  8000f5:	89 45 d8             	mov    %eax,-0x28(%ebp)
	int32 envIdProcessB = sys_create_env("ef_midterm", myEnv->page_WS_max_size,(myEnv->SecondListSize), 50);
  8000f8:	a1 20 60 80 00       	mov    0x806020,%eax
  8000fd:	8b 80 a0 05 00 00    	mov    0x5a0(%eax),%eax
  800103:	89 c2                	mov    %eax,%edx
  800105:	a1 20 60 80 00       	mov    0x806020,%eax
  80010a:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  800110:	6a 32                	push   $0x32
  800112:	52                   	push   %edx
  800113:	50                   	push   %eax
  800114:	68 4c 44 80 00       	push   $0x80444c
  800119:	e8 06 31 00 00       	call   803224 <sys_create_env>
  80011e:	83 c4 10             	add    $0x10,%esp
  800121:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	sys_run_env(envIdProcessA);
  800124:	83 ec 0c             	sub    $0xc,%esp
  800127:	ff 75 d8             	pushl  -0x28(%ebp)
  80012a:	e8 13 31 00 00       	call   803242 <sys_run_env>
  80012f:	83 c4 10             	add    $0x10,%esp
	env_sleep(10000);
  800132:	83 ec 0c             	sub    $0xc,%esp
  800135:	68 10 27 00 00       	push   $0x2710
  80013a:	e8 7d 3e 00 00       	call   803fbc <env_sleep>
  80013f:	83 c4 10             	add    $0x10,%esp
	sys_run_env(envIdProcessB);
  800142:	83 ec 0c             	sub    $0xc,%esp
  800145:	ff 75 d4             	pushl  -0x2c(%ebp)
  800148:	e8 f5 30 00 00       	call   803242 <sys_run_env>
  80014d:	83 c4 10             	add    $0x10,%esp

	while (*numOfFinished != 2) ;
  800150:	90                   	nop
  800151:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800154:	8b 00                	mov    (%eax),%eax
  800156:	83 f8 02             	cmp    $0x2,%eax
  800159:	75 f6                	jne    800151 <_main+0x119>

	cprintf("\n---# of free frames after running programs = %d\n", sys_calculate_free_frames());
  80015b:	e8 69 2f 00 00       	call   8030c9 <sys_calculate_free_frames>
  800160:	83 ec 08             	sub    $0x8,%esp
  800163:	50                   	push   %eax
  800164:	68 58 44 80 00       	push   $0x804458
  800169:	e8 f0 05 00 00       	call   80075e <cprintf>
  80016e:	83 c4 10             	add    $0x10,%esp

	uint32 ksbrk_after ;
	sys_utilities(getksbrkCmd, (uint32)&ksbrk_after);
  800171:	8d 85 4c ff ff ff    	lea    -0xb4(%ebp),%eax
  800177:	83 ec 08             	sub    $0x8,%esp
  80017a:	50                   	push   %eax
  80017b:	8d 85 54 ff ff ff    	lea    -0xac(%ebp),%eax
  800181:	50                   	push   %eax
  800182:	e8 41 33 00 00       	call   8034c8 <sys_utilities>
  800187:	83 c4 10             	add    $0x10,%esp

	//DISABLE the interrupt to ensure the env_free is done as a whole without preemption
	//to avoid context switch (due to clock interrupt) while freeing the env to prevent:
	//	1. context switching to a wrong process specially in the part of temporarily switching the CPU process for freeing shared variables
	//	2. changing the # free frames
	char changeIntCmd[100] = "__changeInterruptStatus__";
  80018a:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  800190:	bb 65 46 80 00       	mov    $0x804665,%ebx
  800195:	ba 1a 00 00 00       	mov    $0x1a,%edx
  80019a:	89 c7                	mov    %eax,%edi
  80019c:	89 de                	mov    %ebx,%esi
  80019e:	89 d1                	mov    %edx,%ecx
  8001a0:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  8001a2:	8d 95 02 ff ff ff    	lea    -0xfe(%ebp),%edx
  8001a8:	b9 4a 00 00 00       	mov    $0x4a,%ecx
  8001ad:	b0 00                	mov    $0x0,%al
  8001af:	89 d7                	mov    %edx,%edi
  8001b1:	f3 aa                	rep stos %al,%es:(%edi)
	sys_utilities(changeIntCmd, 0);
  8001b3:	83 ec 08             	sub    $0x8,%esp
  8001b6:	6a 00                	push   $0x0
  8001b8:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  8001be:	50                   	push   %eax
  8001bf:	e8 04 33 00 00       	call   8034c8 <sys_utilities>
  8001c4:	83 c4 10             	add    $0x10,%esp
	{
		sys_destroy_env(envIdProcessA);
  8001c7:	83 ec 0c             	sub    $0xc,%esp
  8001ca:	ff 75 d8             	pushl  -0x28(%ebp)
  8001cd:	e8 8c 30 00 00       	call   80325e <sys_destroy_env>
  8001d2:	83 c4 10             	add    $0x10,%esp
		sys_destroy_env(envIdProcessB);
  8001d5:	83 ec 0c             	sub    $0xc,%esp
  8001d8:	ff 75 d4             	pushl  -0x2c(%ebp)
  8001db:	e8 7e 30 00 00       	call   80325e <sys_destroy_env>
  8001e0:	83 c4 10             	add    $0x10,%esp
	}
	sys_utilities(changeIntCmd, 1);
  8001e3:	83 ec 08             	sub    $0x8,%esp
  8001e6:	6a 01                	push   $0x1
  8001e8:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  8001ee:	50                   	push   %eax
  8001ef:	e8 d4 32 00 00       	call   8034c8 <sys_utilities>
  8001f4:	83 c4 10             	add    $0x10,%esp

	//Checking the number of frames after killing the created environments
	int freeFrames_after = sys_calculate_free_frames() ;
  8001f7:	e8 cd 2e 00 00       	call   8030c9 <sys_calculate_free_frames>
  8001fc:	89 45 d0             	mov    %eax,-0x30(%ebp)
	int usedDiskPages_after = sys_pf_calculate_allocated_pages() ;
  8001ff:	e8 10 2f 00 00       	call   803114 <sys_pf_calculate_allocated_pages>
  800204:	89 45 cc             	mov    %eax,-0x34(%ebp)

	int expected = (ROUNDUP((uint32)ksbrk_after, PAGE_SIZE) - ROUNDUP((uint32)ksbrk_before, PAGE_SIZE)) / PAGE_SIZE;
  800207:	c7 45 c8 00 10 00 00 	movl   $0x1000,-0x38(%ebp)
  80020e:	8b 95 4c ff ff ff    	mov    -0xb4(%ebp),%edx
  800214:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800217:	01 d0                	add    %edx,%eax
  800219:	48                   	dec    %eax
  80021a:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  80021d:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  800220:	ba 00 00 00 00       	mov    $0x0,%edx
  800225:	f7 75 c8             	divl   -0x38(%ebp)
  800228:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80022b:	29 d0                	sub    %edx,%eax
  80022d:	89 c1                	mov    %eax,%ecx
  80022f:	c7 45 c0 00 10 00 00 	movl   $0x1000,-0x40(%ebp)
  800236:	8b 95 50 ff ff ff    	mov    -0xb0(%ebp),%edx
  80023c:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80023f:	01 d0                	add    %edx,%eax
  800241:	48                   	dec    %eax
  800242:	89 45 bc             	mov    %eax,-0x44(%ebp)
  800245:	8b 45 bc             	mov    -0x44(%ebp),%eax
  800248:	ba 00 00 00 00       	mov    $0x0,%edx
  80024d:	f7 75 c0             	divl   -0x40(%ebp)
  800250:	8b 45 bc             	mov    -0x44(%ebp),%eax
  800253:	29 d0                	sub    %edx,%eax
  800255:	29 c1                	sub    %eax,%ecx
  800257:	89 c8                	mov    %ecx,%eax
  800259:	c1 e8 0c             	shr    $0xc,%eax
  80025c:	89 45 b8             	mov    %eax,-0x48(%ebp)
	cprintf("expected = %d\n",expected);
  80025f:	83 ec 08             	sub    $0x8,%esp
  800262:	ff 75 b8             	pushl  -0x48(%ebp)
  800265:	68 8a 44 80 00       	push   $0x80448a
  80026a:	e8 ef 04 00 00       	call   80075e <cprintf>
  80026f:	83 c4 10             	add    $0x10,%esp
	if ((freeFrames_before - freeFrames_after) != expected) {
  800272:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800275:	2b 45 d0             	sub    -0x30(%ebp),%eax
  800278:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  80027b:	74 2e                	je     8002ab <_main+0x273>
		cprintf("\n---# of free frames after closing running programs not as before running = %d\ndifference = %d, expected = %d\n",
  80027d:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800280:	2b 45 e0             	sub    -0x20(%ebp),%eax
  800283:	ff 75 b8             	pushl  -0x48(%ebp)
  800286:	50                   	push   %eax
  800287:	ff 75 d0             	pushl  -0x30(%ebp)
  80028a:	68 9c 44 80 00       	push   $0x80449c
  80028f:	e8 ca 04 00 00       	call   80075e <cprintf>
  800294:	83 c4 10             	add    $0x10,%esp
				freeFrames_after, freeFrames_after - freeFrames_before, expected);
		panic("env_free() does not work correctly... check it again.");
  800297:	83 ec 04             	sub    $0x4,%esp
  80029a:	68 0c 45 80 00       	push   $0x80450c
  80029f:	6a 36                	push   $0x36
  8002a1:	68 42 45 80 00       	push   $0x804542
  8002a6:	e8 e5 01 00 00       	call   800490 <_panic>
	}

	cprintf("\n---# of free frames after closing running programs returned back to be as before running = %d\n", freeFrames_after);
  8002ab:	83 ec 08             	sub    $0x8,%esp
  8002ae:	ff 75 d0             	pushl  -0x30(%ebp)
  8002b1:	68 58 45 80 00       	push   $0x804558
  8002b6:	e8 a3 04 00 00       	call   80075e <cprintf>
  8002bb:	83 c4 10             	add    $0x10,%esp

	cprintf("\n\nCongratulations!! test scenario 6 for envfree completed successfully.\n");
  8002be:	83 ec 0c             	sub    $0xc,%esp
  8002c1:	68 b8 45 80 00       	push   $0x8045b8
  8002c6:	e8 93 04 00 00       	call   80075e <cprintf>
  8002cb:	83 c4 10             	add    $0x10,%esp
	return;
  8002ce:	90                   	nop
}
  8002cf:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002d2:	5b                   	pop    %ebx
  8002d3:	5e                   	pop    %esi
  8002d4:	5f                   	pop    %edi
  8002d5:	5d                   	pop    %ebp
  8002d6:	c3                   	ret    

008002d7 <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  8002d7:	55                   	push   %ebp
  8002d8:	89 e5                	mov    %esp,%ebp
  8002da:	57                   	push   %edi
  8002db:	56                   	push   %esi
  8002dc:	53                   	push   %ebx
  8002dd:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  8002e0:	e8 ad 2f 00 00       	call   803292 <sys_getenvindex>
  8002e5:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  8002e8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8002eb:	89 d0                	mov    %edx,%eax
  8002ed:	c1 e0 02             	shl    $0x2,%eax
  8002f0:	01 d0                	add    %edx,%eax
  8002f2:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8002f9:	01 d0                	add    %edx,%eax
  8002fb:	89 c2                	mov    %eax,%edx
  8002fd:	c1 e2 04             	shl    $0x4,%edx
  800300:	29 c2                	sub    %eax,%edx
  800302:	8d 04 95 00 00 00 00 	lea    0x0(,%edx,4),%eax
  800309:	89 c2                	mov    %eax,%edx
  80030b:	8d 82 00 00 c0 ee    	lea    -0x11400000(%edx),%eax
  800311:	a3 20 60 80 00       	mov    %eax,0x806020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800316:	a1 20 60 80 00       	mov    0x806020,%eax
  80031b:	8a 40 20             	mov    0x20(%eax),%al
  80031e:	84 c0                	test   %al,%al
  800320:	74 0d                	je     80032f <libmain+0x58>
		binaryname = myEnv->prog_name;
  800322:	a1 20 60 80 00       	mov    0x806020,%eax
  800327:	83 c0 20             	add    $0x20,%eax
  80032a:	a3 04 60 80 00       	mov    %eax,0x806004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80032f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800333:	7e 0a                	jle    80033f <libmain+0x68>
		binaryname = argv[0];
  800335:	8b 45 0c             	mov    0xc(%ebp),%eax
  800338:	8b 00                	mov    (%eax),%eax
  80033a:	a3 04 60 80 00       	mov    %eax,0x806004

	// call user main routine
	_main(argc, argv);
  80033f:	83 ec 08             	sub    $0x8,%esp
  800342:	ff 75 0c             	pushl  0xc(%ebp)
  800345:	ff 75 08             	pushl  0x8(%ebp)
  800348:	e8 eb fc ff ff       	call   800038 <_main>
  80034d:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  800350:	a1 00 60 80 00       	mov    0x806000,%eax
  800355:	85 c0                	test   %eax,%eax
  800357:	0f 84 01 01 00 00    	je     80045e <libmain+0x187>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  80035d:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  800363:	bb c4 47 80 00       	mov    $0x8047c4,%ebx
  800368:	ba 0e 00 00 00       	mov    $0xe,%edx
  80036d:	89 c7                	mov    %eax,%edi
  80036f:	89 de                	mov    %ebx,%esi
  800371:	89 d1                	mov    %edx,%ecx
  800373:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  800375:	8d 55 8a             	lea    -0x76(%ebp),%edx
  800378:	b9 56 00 00 00       	mov    $0x56,%ecx
  80037d:	b0 00                	mov    $0x0,%al
  80037f:	89 d7                	mov    %edx,%edi
  800381:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  800383:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  80038a:	8d 45 e0             	lea    -0x20(%ebp),%eax
  80038d:	83 ec 08             	sub    $0x8,%esp
  800390:	50                   	push   %eax
  800391:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  800397:	50                   	push   %eax
  800398:	e8 2b 31 00 00       	call   8034c8 <sys_utilities>
  80039d:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  8003a0:	e8 74 2c 00 00       	call   803019 <sys_lock_cons>
		{
			cprintf("**************************************\n");
  8003a5:	83 ec 0c             	sub    $0xc,%esp
  8003a8:	68 e4 46 80 00       	push   $0x8046e4
  8003ad:	e8 ac 03 00 00       	call   80075e <cprintf>
  8003b2:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  8003b5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8003b8:	85 c0                	test   %eax,%eax
  8003ba:	74 18                	je     8003d4 <libmain+0xfd>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  8003bc:	e8 25 31 00 00       	call   8034e6 <sys_get_optimal_num_faults>
  8003c1:	83 ec 08             	sub    $0x8,%esp
  8003c4:	50                   	push   %eax
  8003c5:	68 0c 47 80 00       	push   $0x80470c
  8003ca:	e8 8f 03 00 00       	call   80075e <cprintf>
  8003cf:	83 c4 10             	add    $0x10,%esp
  8003d2:	eb 59                	jmp    80042d <libmain+0x156>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8003d4:	a1 20 60 80 00       	mov    0x806020,%eax
  8003d9:	8b 90 bc 05 00 00    	mov    0x5bc(%eax),%edx
  8003df:	a1 20 60 80 00       	mov    0x806020,%eax
  8003e4:	8b 80 ac 05 00 00    	mov    0x5ac(%eax),%eax
  8003ea:	83 ec 04             	sub    $0x4,%esp
  8003ed:	52                   	push   %edx
  8003ee:	50                   	push   %eax
  8003ef:	68 30 47 80 00       	push   $0x804730
  8003f4:	e8 65 03 00 00       	call   80075e <cprintf>
  8003f9:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8003fc:	a1 20 60 80 00       	mov    0x806020,%eax
  800401:	8b 88 d0 05 00 00    	mov    0x5d0(%eax),%ecx
  800407:	a1 20 60 80 00       	mov    0x806020,%eax
  80040c:	8b 90 cc 05 00 00    	mov    0x5cc(%eax),%edx
  800412:	a1 20 60 80 00       	mov    0x806020,%eax
  800417:	8b 80 c8 05 00 00    	mov    0x5c8(%eax),%eax
  80041d:	51                   	push   %ecx
  80041e:	52                   	push   %edx
  80041f:	50                   	push   %eax
  800420:	68 58 47 80 00       	push   $0x804758
  800425:	e8 34 03 00 00       	call   80075e <cprintf>
  80042a:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80042d:	a1 20 60 80 00       	mov    0x806020,%eax
  800432:	8b 80 d4 05 00 00    	mov    0x5d4(%eax),%eax
  800438:	83 ec 08             	sub    $0x8,%esp
  80043b:	50                   	push   %eax
  80043c:	68 b0 47 80 00       	push   $0x8047b0
  800441:	e8 18 03 00 00       	call   80075e <cprintf>
  800446:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  800449:	83 ec 0c             	sub    $0xc,%esp
  80044c:	68 e4 46 80 00       	push   $0x8046e4
  800451:	e8 08 03 00 00       	call   80075e <cprintf>
  800456:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  800459:	e8 d5 2b 00 00       	call   803033 <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  80045e:	e8 1f 00 00 00       	call   800482 <exit>
}
  800463:	90                   	nop
  800464:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800467:	5b                   	pop    %ebx
  800468:	5e                   	pop    %esi
  800469:	5f                   	pop    %edi
  80046a:	5d                   	pop    %ebp
  80046b:	c3                   	ret    

0080046c <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  80046c:	55                   	push   %ebp
  80046d:	89 e5                	mov    %esp,%ebp
  80046f:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800472:	83 ec 0c             	sub    $0xc,%esp
  800475:	6a 00                	push   $0x0
  800477:	e8 e2 2d 00 00       	call   80325e <sys_destroy_env>
  80047c:	83 c4 10             	add    $0x10,%esp
}
  80047f:	90                   	nop
  800480:	c9                   	leave  
  800481:	c3                   	ret    

00800482 <exit>:

void
exit(void)
{
  800482:	55                   	push   %ebp
  800483:	89 e5                	mov    %esp,%ebp
  800485:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800488:	e8 37 2e 00 00       	call   8032c4 <sys_exit_env>
}
  80048d:	90                   	nop
  80048e:	c9                   	leave  
  80048f:	c3                   	ret    

00800490 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800490:	55                   	push   %ebp
  800491:	89 e5                	mov    %esp,%ebp
  800493:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800496:	8d 45 10             	lea    0x10(%ebp),%eax
  800499:	83 c0 04             	add    $0x4,%eax
  80049c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  80049f:	a1 18 e1 81 00       	mov    0x81e118,%eax
  8004a4:	85 c0                	test   %eax,%eax
  8004a6:	74 16                	je     8004be <_panic+0x2e>
		cprintf("%s: ", argv0);
  8004a8:	a1 18 e1 81 00       	mov    0x81e118,%eax
  8004ad:	83 ec 08             	sub    $0x8,%esp
  8004b0:	50                   	push   %eax
  8004b1:	68 28 48 80 00       	push   $0x804828
  8004b6:	e8 a3 02 00 00       	call   80075e <cprintf>
  8004bb:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  8004be:	a1 04 60 80 00       	mov    0x806004,%eax
  8004c3:	83 ec 0c             	sub    $0xc,%esp
  8004c6:	ff 75 0c             	pushl  0xc(%ebp)
  8004c9:	ff 75 08             	pushl  0x8(%ebp)
  8004cc:	50                   	push   %eax
  8004cd:	68 30 48 80 00       	push   $0x804830
  8004d2:	6a 74                	push   $0x74
  8004d4:	e8 b2 02 00 00       	call   80078b <cprintf_colored>
  8004d9:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  8004dc:	8b 45 10             	mov    0x10(%ebp),%eax
  8004df:	83 ec 08             	sub    $0x8,%esp
  8004e2:	ff 75 f4             	pushl  -0xc(%ebp)
  8004e5:	50                   	push   %eax
  8004e6:	e8 04 02 00 00       	call   8006ef <vcprintf>
  8004eb:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8004ee:	83 ec 08             	sub    $0x8,%esp
  8004f1:	6a 00                	push   $0x0
  8004f3:	68 58 48 80 00       	push   $0x804858
  8004f8:	e8 f2 01 00 00       	call   8006ef <vcprintf>
  8004fd:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800500:	e8 7d ff ff ff       	call   800482 <exit>

	// should not return here
	while (1) ;
  800505:	eb fe                	jmp    800505 <_panic+0x75>

00800507 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800507:	55                   	push   %ebp
  800508:	89 e5                	mov    %esp,%ebp
  80050a:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  80050d:	a1 20 60 80 00       	mov    0x806020,%eax
  800512:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800518:	8b 45 0c             	mov    0xc(%ebp),%eax
  80051b:	39 c2                	cmp    %eax,%edx
  80051d:	74 14                	je     800533 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  80051f:	83 ec 04             	sub    $0x4,%esp
  800522:	68 5c 48 80 00       	push   $0x80485c
  800527:	6a 26                	push   $0x26
  800529:	68 a8 48 80 00       	push   $0x8048a8
  80052e:	e8 5d ff ff ff       	call   800490 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800533:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  80053a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800541:	e9 c5 00 00 00       	jmp    80060b <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  800546:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800549:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800550:	8b 45 08             	mov    0x8(%ebp),%eax
  800553:	01 d0                	add    %edx,%eax
  800555:	8b 00                	mov    (%eax),%eax
  800557:	85 c0                	test   %eax,%eax
  800559:	75 08                	jne    800563 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  80055b:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  80055e:	e9 a5 00 00 00       	jmp    800608 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  800563:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80056a:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800571:	eb 69                	jmp    8005dc <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800573:	a1 20 60 80 00       	mov    0x806020,%eax
  800578:	8b 88 a4 05 00 00    	mov    0x5a4(%eax),%ecx
  80057e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800581:	89 d0                	mov    %edx,%eax
  800583:	01 c0                	add    %eax,%eax
  800585:	01 d0                	add    %edx,%eax
  800587:	c1 e0 03             	shl    $0x3,%eax
  80058a:	01 c8                	add    %ecx,%eax
  80058c:	8a 40 04             	mov    0x4(%eax),%al
  80058f:	84 c0                	test   %al,%al
  800591:	75 46                	jne    8005d9 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800593:	a1 20 60 80 00       	mov    0x806020,%eax
  800598:	8b 88 a4 05 00 00    	mov    0x5a4(%eax),%ecx
  80059e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8005a1:	89 d0                	mov    %edx,%eax
  8005a3:	01 c0                	add    %eax,%eax
  8005a5:	01 d0                	add    %edx,%eax
  8005a7:	c1 e0 03             	shl    $0x3,%eax
  8005aa:	01 c8                	add    %ecx,%eax
  8005ac:	8b 00                	mov    (%eax),%eax
  8005ae:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8005b1:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8005b4:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8005b9:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8005bb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8005be:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8005c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8005c8:	01 c8                	add    %ecx,%eax
  8005ca:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8005cc:	39 c2                	cmp    %eax,%edx
  8005ce:	75 09                	jne    8005d9 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  8005d0:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8005d7:	eb 15                	jmp    8005ee <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8005d9:	ff 45 e8             	incl   -0x18(%ebp)
  8005dc:	a1 20 60 80 00       	mov    0x806020,%eax
  8005e1:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8005e7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8005ea:	39 c2                	cmp    %eax,%edx
  8005ec:	77 85                	ja     800573 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8005ee:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8005f2:	75 14                	jne    800608 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  8005f4:	83 ec 04             	sub    $0x4,%esp
  8005f7:	68 b4 48 80 00       	push   $0x8048b4
  8005fc:	6a 3a                	push   $0x3a
  8005fe:	68 a8 48 80 00       	push   $0x8048a8
  800603:	e8 88 fe ff ff       	call   800490 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800608:	ff 45 f0             	incl   -0x10(%ebp)
  80060b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80060e:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800611:	0f 8c 2f ff ff ff    	jl     800546 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800617:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80061e:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800625:	eb 26                	jmp    80064d <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800627:	a1 20 60 80 00       	mov    0x806020,%eax
  80062c:	8b 88 a4 05 00 00    	mov    0x5a4(%eax),%ecx
  800632:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800635:	89 d0                	mov    %edx,%eax
  800637:	01 c0                	add    %eax,%eax
  800639:	01 d0                	add    %edx,%eax
  80063b:	c1 e0 03             	shl    $0x3,%eax
  80063e:	01 c8                	add    %ecx,%eax
  800640:	8a 40 04             	mov    0x4(%eax),%al
  800643:	3c 01                	cmp    $0x1,%al
  800645:	75 03                	jne    80064a <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  800647:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80064a:	ff 45 e0             	incl   -0x20(%ebp)
  80064d:	a1 20 60 80 00       	mov    0x806020,%eax
  800652:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800658:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80065b:	39 c2                	cmp    %eax,%edx
  80065d:	77 c8                	ja     800627 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  80065f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800662:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800665:	74 14                	je     80067b <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  800667:	83 ec 04             	sub    $0x4,%esp
  80066a:	68 08 49 80 00       	push   $0x804908
  80066f:	6a 44                	push   $0x44
  800671:	68 a8 48 80 00       	push   $0x8048a8
  800676:	e8 15 fe ff ff       	call   800490 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  80067b:	90                   	nop
  80067c:	c9                   	leave  
  80067d:	c3                   	ret    

0080067e <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  80067e:	55                   	push   %ebp
  80067f:	89 e5                	mov    %esp,%ebp
  800681:	53                   	push   %ebx
  800682:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  800685:	8b 45 0c             	mov    0xc(%ebp),%eax
  800688:	8b 00                	mov    (%eax),%eax
  80068a:	8d 48 01             	lea    0x1(%eax),%ecx
  80068d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800690:	89 0a                	mov    %ecx,(%edx)
  800692:	8b 55 08             	mov    0x8(%ebp),%edx
  800695:	88 d1                	mov    %dl,%cl
  800697:	8b 55 0c             	mov    0xc(%ebp),%edx
  80069a:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  80069e:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006a1:	8b 00                	mov    (%eax),%eax
  8006a3:	3d ff 00 00 00       	cmp    $0xff,%eax
  8006a8:	75 30                	jne    8006da <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  8006aa:	8b 15 1c e1 81 00    	mov    0x81e11c,%edx
  8006b0:	a0 44 60 80 00       	mov    0x806044,%al
  8006b5:	0f b6 c0             	movzbl %al,%eax
  8006b8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8006bb:	8b 09                	mov    (%ecx),%ecx
  8006bd:	89 cb                	mov    %ecx,%ebx
  8006bf:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8006c2:	83 c1 08             	add    $0x8,%ecx
  8006c5:	52                   	push   %edx
  8006c6:	50                   	push   %eax
  8006c7:	53                   	push   %ebx
  8006c8:	51                   	push   %ecx
  8006c9:	e8 07 29 00 00       	call   802fd5 <sys_cputs>
  8006ce:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8006d1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006d4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8006da:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006dd:	8b 40 04             	mov    0x4(%eax),%eax
  8006e0:	8d 50 01             	lea    0x1(%eax),%edx
  8006e3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006e6:	89 50 04             	mov    %edx,0x4(%eax)
}
  8006e9:	90                   	nop
  8006ea:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8006ed:	c9                   	leave  
  8006ee:	c3                   	ret    

008006ef <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8006ef:	55                   	push   %ebp
  8006f0:	89 e5                	mov    %esp,%ebp
  8006f2:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8006f8:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8006ff:	00 00 00 
	b.cnt = 0;
  800702:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800709:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  80070c:	ff 75 0c             	pushl  0xc(%ebp)
  80070f:	ff 75 08             	pushl  0x8(%ebp)
  800712:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800718:	50                   	push   %eax
  800719:	68 7e 06 80 00       	push   $0x80067e
  80071e:	e8 5a 02 00 00       	call   80097d <vprintfmt>
  800723:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  800726:	8b 15 1c e1 81 00    	mov    0x81e11c,%edx
  80072c:	a0 44 60 80 00       	mov    0x806044,%al
  800731:	0f b6 c0             	movzbl %al,%eax
  800734:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  80073a:	52                   	push   %edx
  80073b:	50                   	push   %eax
  80073c:	51                   	push   %ecx
  80073d:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800743:	83 c0 08             	add    $0x8,%eax
  800746:	50                   	push   %eax
  800747:	e8 89 28 00 00       	call   802fd5 <sys_cputs>
  80074c:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  80074f:	c6 05 44 60 80 00 00 	movb   $0x0,0x806044
	return b.cnt;
  800756:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  80075c:	c9                   	leave  
  80075d:	c3                   	ret    

0080075e <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  80075e:	55                   	push   %ebp
  80075f:	89 e5                	mov    %esp,%ebp
  800761:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800764:	c6 05 44 60 80 00 01 	movb   $0x1,0x806044
	va_start(ap, fmt);
  80076b:	8d 45 0c             	lea    0xc(%ebp),%eax
  80076e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800771:	8b 45 08             	mov    0x8(%ebp),%eax
  800774:	83 ec 08             	sub    $0x8,%esp
  800777:	ff 75 f4             	pushl  -0xc(%ebp)
  80077a:	50                   	push   %eax
  80077b:	e8 6f ff ff ff       	call   8006ef <vcprintf>
  800780:	83 c4 10             	add    $0x10,%esp
  800783:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800786:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800789:	c9                   	leave  
  80078a:	c3                   	ret    

0080078b <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  80078b:	55                   	push   %ebp
  80078c:	89 e5                	mov    %esp,%ebp
  80078e:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800791:	c6 05 44 60 80 00 01 	movb   $0x1,0x806044
	curTextClr = (textClr << 8) ; //set text color by the given value
  800798:	8b 45 08             	mov    0x8(%ebp),%eax
  80079b:	c1 e0 08             	shl    $0x8,%eax
  80079e:	a3 1c e1 81 00       	mov    %eax,0x81e11c
	va_start(ap, fmt);
  8007a3:	8d 45 0c             	lea    0xc(%ebp),%eax
  8007a6:	83 c0 04             	add    $0x4,%eax
  8007a9:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8007ac:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007af:	83 ec 08             	sub    $0x8,%esp
  8007b2:	ff 75 f4             	pushl  -0xc(%ebp)
  8007b5:	50                   	push   %eax
  8007b6:	e8 34 ff ff ff       	call   8006ef <vcprintf>
  8007bb:	83 c4 10             	add    $0x10,%esp
  8007be:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  8007c1:	c7 05 1c e1 81 00 00 	movl   $0x700,0x81e11c
  8007c8:	07 00 00 

	return cnt;
  8007cb:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8007ce:	c9                   	leave  
  8007cf:	c3                   	ret    

008007d0 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  8007d0:	55                   	push   %ebp
  8007d1:	89 e5                	mov    %esp,%ebp
  8007d3:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  8007d6:	e8 3e 28 00 00       	call   803019 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  8007db:	8d 45 0c             	lea    0xc(%ebp),%eax
  8007de:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  8007e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8007e4:	83 ec 08             	sub    $0x8,%esp
  8007e7:	ff 75 f4             	pushl  -0xc(%ebp)
  8007ea:	50                   	push   %eax
  8007eb:	e8 ff fe ff ff       	call   8006ef <vcprintf>
  8007f0:	83 c4 10             	add    $0x10,%esp
  8007f3:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  8007f6:	e8 38 28 00 00       	call   803033 <sys_unlock_cons>
	return cnt;
  8007fb:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8007fe:	c9                   	leave  
  8007ff:	c3                   	ret    

00800800 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800800:	55                   	push   %ebp
  800801:	89 e5                	mov    %esp,%ebp
  800803:	53                   	push   %ebx
  800804:	83 ec 14             	sub    $0x14,%esp
  800807:	8b 45 10             	mov    0x10(%ebp),%eax
  80080a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80080d:	8b 45 14             	mov    0x14(%ebp),%eax
  800810:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800813:	8b 45 18             	mov    0x18(%ebp),%eax
  800816:	ba 00 00 00 00       	mov    $0x0,%edx
  80081b:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80081e:	77 55                	ja     800875 <printnum+0x75>
  800820:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800823:	72 05                	jb     80082a <printnum+0x2a>
  800825:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800828:	77 4b                	ja     800875 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80082a:	8b 45 1c             	mov    0x1c(%ebp),%eax
  80082d:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800830:	8b 45 18             	mov    0x18(%ebp),%eax
  800833:	ba 00 00 00 00       	mov    $0x0,%edx
  800838:	52                   	push   %edx
  800839:	50                   	push   %eax
  80083a:	ff 75 f4             	pushl  -0xc(%ebp)
  80083d:	ff 75 f0             	pushl  -0x10(%ebp)
  800840:	e8 3f 39 00 00       	call   804184 <__udivdi3>
  800845:	83 c4 10             	add    $0x10,%esp
  800848:	83 ec 04             	sub    $0x4,%esp
  80084b:	ff 75 20             	pushl  0x20(%ebp)
  80084e:	53                   	push   %ebx
  80084f:	ff 75 18             	pushl  0x18(%ebp)
  800852:	52                   	push   %edx
  800853:	50                   	push   %eax
  800854:	ff 75 0c             	pushl  0xc(%ebp)
  800857:	ff 75 08             	pushl  0x8(%ebp)
  80085a:	e8 a1 ff ff ff       	call   800800 <printnum>
  80085f:	83 c4 20             	add    $0x20,%esp
  800862:	eb 1a                	jmp    80087e <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800864:	83 ec 08             	sub    $0x8,%esp
  800867:	ff 75 0c             	pushl  0xc(%ebp)
  80086a:	ff 75 20             	pushl  0x20(%ebp)
  80086d:	8b 45 08             	mov    0x8(%ebp),%eax
  800870:	ff d0                	call   *%eax
  800872:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800875:	ff 4d 1c             	decl   0x1c(%ebp)
  800878:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  80087c:	7f e6                	jg     800864 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80087e:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800881:	bb 00 00 00 00       	mov    $0x0,%ebx
  800886:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800889:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80088c:	53                   	push   %ebx
  80088d:	51                   	push   %ecx
  80088e:	52                   	push   %edx
  80088f:	50                   	push   %eax
  800890:	e8 ff 39 00 00       	call   804294 <__umoddi3>
  800895:	83 c4 10             	add    $0x10,%esp
  800898:	05 74 4b 80 00       	add    $0x804b74,%eax
  80089d:	8a 00                	mov    (%eax),%al
  80089f:	0f be c0             	movsbl %al,%eax
  8008a2:	83 ec 08             	sub    $0x8,%esp
  8008a5:	ff 75 0c             	pushl  0xc(%ebp)
  8008a8:	50                   	push   %eax
  8008a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ac:	ff d0                	call   *%eax
  8008ae:	83 c4 10             	add    $0x10,%esp
}
  8008b1:	90                   	nop
  8008b2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8008b5:	c9                   	leave  
  8008b6:	c3                   	ret    

008008b7 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8008b7:	55                   	push   %ebp
  8008b8:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8008ba:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8008be:	7e 1c                	jle    8008dc <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8008c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8008c3:	8b 00                	mov    (%eax),%eax
  8008c5:	8d 50 08             	lea    0x8(%eax),%edx
  8008c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8008cb:	89 10                	mov    %edx,(%eax)
  8008cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8008d0:	8b 00                	mov    (%eax),%eax
  8008d2:	83 e8 08             	sub    $0x8,%eax
  8008d5:	8b 50 04             	mov    0x4(%eax),%edx
  8008d8:	8b 00                	mov    (%eax),%eax
  8008da:	eb 40                	jmp    80091c <getuint+0x65>
	else if (lflag)
  8008dc:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8008e0:	74 1e                	je     800900 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8008e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8008e5:	8b 00                	mov    (%eax),%eax
  8008e7:	8d 50 04             	lea    0x4(%eax),%edx
  8008ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ed:	89 10                	mov    %edx,(%eax)
  8008ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8008f2:	8b 00                	mov    (%eax),%eax
  8008f4:	83 e8 04             	sub    $0x4,%eax
  8008f7:	8b 00                	mov    (%eax),%eax
  8008f9:	ba 00 00 00 00       	mov    $0x0,%edx
  8008fe:	eb 1c                	jmp    80091c <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800900:	8b 45 08             	mov    0x8(%ebp),%eax
  800903:	8b 00                	mov    (%eax),%eax
  800905:	8d 50 04             	lea    0x4(%eax),%edx
  800908:	8b 45 08             	mov    0x8(%ebp),%eax
  80090b:	89 10                	mov    %edx,(%eax)
  80090d:	8b 45 08             	mov    0x8(%ebp),%eax
  800910:	8b 00                	mov    (%eax),%eax
  800912:	83 e8 04             	sub    $0x4,%eax
  800915:	8b 00                	mov    (%eax),%eax
  800917:	ba 00 00 00 00       	mov    $0x0,%edx
}
  80091c:	5d                   	pop    %ebp
  80091d:	c3                   	ret    

0080091e <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  80091e:	55                   	push   %ebp
  80091f:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800921:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800925:	7e 1c                	jle    800943 <getint+0x25>
		return va_arg(*ap, long long);
  800927:	8b 45 08             	mov    0x8(%ebp),%eax
  80092a:	8b 00                	mov    (%eax),%eax
  80092c:	8d 50 08             	lea    0x8(%eax),%edx
  80092f:	8b 45 08             	mov    0x8(%ebp),%eax
  800932:	89 10                	mov    %edx,(%eax)
  800934:	8b 45 08             	mov    0x8(%ebp),%eax
  800937:	8b 00                	mov    (%eax),%eax
  800939:	83 e8 08             	sub    $0x8,%eax
  80093c:	8b 50 04             	mov    0x4(%eax),%edx
  80093f:	8b 00                	mov    (%eax),%eax
  800941:	eb 38                	jmp    80097b <getint+0x5d>
	else if (lflag)
  800943:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800947:	74 1a                	je     800963 <getint+0x45>
		return va_arg(*ap, long);
  800949:	8b 45 08             	mov    0x8(%ebp),%eax
  80094c:	8b 00                	mov    (%eax),%eax
  80094e:	8d 50 04             	lea    0x4(%eax),%edx
  800951:	8b 45 08             	mov    0x8(%ebp),%eax
  800954:	89 10                	mov    %edx,(%eax)
  800956:	8b 45 08             	mov    0x8(%ebp),%eax
  800959:	8b 00                	mov    (%eax),%eax
  80095b:	83 e8 04             	sub    $0x4,%eax
  80095e:	8b 00                	mov    (%eax),%eax
  800960:	99                   	cltd   
  800961:	eb 18                	jmp    80097b <getint+0x5d>
	else
		return va_arg(*ap, int);
  800963:	8b 45 08             	mov    0x8(%ebp),%eax
  800966:	8b 00                	mov    (%eax),%eax
  800968:	8d 50 04             	lea    0x4(%eax),%edx
  80096b:	8b 45 08             	mov    0x8(%ebp),%eax
  80096e:	89 10                	mov    %edx,(%eax)
  800970:	8b 45 08             	mov    0x8(%ebp),%eax
  800973:	8b 00                	mov    (%eax),%eax
  800975:	83 e8 04             	sub    $0x4,%eax
  800978:	8b 00                	mov    (%eax),%eax
  80097a:	99                   	cltd   
}
  80097b:	5d                   	pop    %ebp
  80097c:	c3                   	ret    

0080097d <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80097d:	55                   	push   %ebp
  80097e:	89 e5                	mov    %esp,%ebp
  800980:	56                   	push   %esi
  800981:	53                   	push   %ebx
  800982:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800985:	eb 17                	jmp    80099e <vprintfmt+0x21>
			if (ch == '\0')
  800987:	85 db                	test   %ebx,%ebx
  800989:	0f 84 c1 03 00 00    	je     800d50 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  80098f:	83 ec 08             	sub    $0x8,%esp
  800992:	ff 75 0c             	pushl  0xc(%ebp)
  800995:	53                   	push   %ebx
  800996:	8b 45 08             	mov    0x8(%ebp),%eax
  800999:	ff d0                	call   *%eax
  80099b:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80099e:	8b 45 10             	mov    0x10(%ebp),%eax
  8009a1:	8d 50 01             	lea    0x1(%eax),%edx
  8009a4:	89 55 10             	mov    %edx,0x10(%ebp)
  8009a7:	8a 00                	mov    (%eax),%al
  8009a9:	0f b6 d8             	movzbl %al,%ebx
  8009ac:	83 fb 25             	cmp    $0x25,%ebx
  8009af:	75 d6                	jne    800987 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8009b1:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  8009b5:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  8009bc:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8009c3:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8009ca:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8009d1:	8b 45 10             	mov    0x10(%ebp),%eax
  8009d4:	8d 50 01             	lea    0x1(%eax),%edx
  8009d7:	89 55 10             	mov    %edx,0x10(%ebp)
  8009da:	8a 00                	mov    (%eax),%al
  8009dc:	0f b6 d8             	movzbl %al,%ebx
  8009df:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8009e2:	83 f8 5b             	cmp    $0x5b,%eax
  8009e5:	0f 87 3d 03 00 00    	ja     800d28 <vprintfmt+0x3ab>
  8009eb:	8b 04 85 98 4b 80 00 	mov    0x804b98(,%eax,4),%eax
  8009f2:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8009f4:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8009f8:	eb d7                	jmp    8009d1 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8009fa:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8009fe:	eb d1                	jmp    8009d1 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800a00:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800a07:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800a0a:	89 d0                	mov    %edx,%eax
  800a0c:	c1 e0 02             	shl    $0x2,%eax
  800a0f:	01 d0                	add    %edx,%eax
  800a11:	01 c0                	add    %eax,%eax
  800a13:	01 d8                	add    %ebx,%eax
  800a15:	83 e8 30             	sub    $0x30,%eax
  800a18:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800a1b:	8b 45 10             	mov    0x10(%ebp),%eax
  800a1e:	8a 00                	mov    (%eax),%al
  800a20:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800a23:	83 fb 2f             	cmp    $0x2f,%ebx
  800a26:	7e 3e                	jle    800a66 <vprintfmt+0xe9>
  800a28:	83 fb 39             	cmp    $0x39,%ebx
  800a2b:	7f 39                	jg     800a66 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800a2d:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800a30:	eb d5                	jmp    800a07 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800a32:	8b 45 14             	mov    0x14(%ebp),%eax
  800a35:	83 c0 04             	add    $0x4,%eax
  800a38:	89 45 14             	mov    %eax,0x14(%ebp)
  800a3b:	8b 45 14             	mov    0x14(%ebp),%eax
  800a3e:	83 e8 04             	sub    $0x4,%eax
  800a41:	8b 00                	mov    (%eax),%eax
  800a43:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800a46:	eb 1f                	jmp    800a67 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800a48:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a4c:	79 83                	jns    8009d1 <vprintfmt+0x54>
				width = 0;
  800a4e:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800a55:	e9 77 ff ff ff       	jmp    8009d1 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800a5a:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800a61:	e9 6b ff ff ff       	jmp    8009d1 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800a66:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800a67:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a6b:	0f 89 60 ff ff ff    	jns    8009d1 <vprintfmt+0x54>
				width = precision, precision = -1;
  800a71:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800a74:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800a77:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800a7e:	e9 4e ff ff ff       	jmp    8009d1 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800a83:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800a86:	e9 46 ff ff ff       	jmp    8009d1 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800a8b:	8b 45 14             	mov    0x14(%ebp),%eax
  800a8e:	83 c0 04             	add    $0x4,%eax
  800a91:	89 45 14             	mov    %eax,0x14(%ebp)
  800a94:	8b 45 14             	mov    0x14(%ebp),%eax
  800a97:	83 e8 04             	sub    $0x4,%eax
  800a9a:	8b 00                	mov    (%eax),%eax
  800a9c:	83 ec 08             	sub    $0x8,%esp
  800a9f:	ff 75 0c             	pushl  0xc(%ebp)
  800aa2:	50                   	push   %eax
  800aa3:	8b 45 08             	mov    0x8(%ebp),%eax
  800aa6:	ff d0                	call   *%eax
  800aa8:	83 c4 10             	add    $0x10,%esp
			break;
  800aab:	e9 9b 02 00 00       	jmp    800d4b <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800ab0:	8b 45 14             	mov    0x14(%ebp),%eax
  800ab3:	83 c0 04             	add    $0x4,%eax
  800ab6:	89 45 14             	mov    %eax,0x14(%ebp)
  800ab9:	8b 45 14             	mov    0x14(%ebp),%eax
  800abc:	83 e8 04             	sub    $0x4,%eax
  800abf:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800ac1:	85 db                	test   %ebx,%ebx
  800ac3:	79 02                	jns    800ac7 <vprintfmt+0x14a>
				err = -err;
  800ac5:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800ac7:	83 fb 64             	cmp    $0x64,%ebx
  800aca:	7f 0b                	jg     800ad7 <vprintfmt+0x15a>
  800acc:	8b 34 9d e0 49 80 00 	mov    0x8049e0(,%ebx,4),%esi
  800ad3:	85 f6                	test   %esi,%esi
  800ad5:	75 19                	jne    800af0 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800ad7:	53                   	push   %ebx
  800ad8:	68 85 4b 80 00       	push   $0x804b85
  800add:	ff 75 0c             	pushl  0xc(%ebp)
  800ae0:	ff 75 08             	pushl  0x8(%ebp)
  800ae3:	e8 70 02 00 00       	call   800d58 <printfmt>
  800ae8:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800aeb:	e9 5b 02 00 00       	jmp    800d4b <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800af0:	56                   	push   %esi
  800af1:	68 8e 4b 80 00       	push   $0x804b8e
  800af6:	ff 75 0c             	pushl  0xc(%ebp)
  800af9:	ff 75 08             	pushl  0x8(%ebp)
  800afc:	e8 57 02 00 00       	call   800d58 <printfmt>
  800b01:	83 c4 10             	add    $0x10,%esp
			break;
  800b04:	e9 42 02 00 00       	jmp    800d4b <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800b09:	8b 45 14             	mov    0x14(%ebp),%eax
  800b0c:	83 c0 04             	add    $0x4,%eax
  800b0f:	89 45 14             	mov    %eax,0x14(%ebp)
  800b12:	8b 45 14             	mov    0x14(%ebp),%eax
  800b15:	83 e8 04             	sub    $0x4,%eax
  800b18:	8b 30                	mov    (%eax),%esi
  800b1a:	85 f6                	test   %esi,%esi
  800b1c:	75 05                	jne    800b23 <vprintfmt+0x1a6>
				p = "(null)";
  800b1e:	be 91 4b 80 00       	mov    $0x804b91,%esi
			if (width > 0 && padc != '-')
  800b23:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b27:	7e 6d                	jle    800b96 <vprintfmt+0x219>
  800b29:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800b2d:	74 67                	je     800b96 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800b2f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800b32:	83 ec 08             	sub    $0x8,%esp
  800b35:	50                   	push   %eax
  800b36:	56                   	push   %esi
  800b37:	e8 1e 03 00 00       	call   800e5a <strnlen>
  800b3c:	83 c4 10             	add    $0x10,%esp
  800b3f:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800b42:	eb 16                	jmp    800b5a <vprintfmt+0x1dd>
					putch(padc, putdat);
  800b44:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800b48:	83 ec 08             	sub    $0x8,%esp
  800b4b:	ff 75 0c             	pushl  0xc(%ebp)
  800b4e:	50                   	push   %eax
  800b4f:	8b 45 08             	mov    0x8(%ebp),%eax
  800b52:	ff d0                	call   *%eax
  800b54:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800b57:	ff 4d e4             	decl   -0x1c(%ebp)
  800b5a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b5e:	7f e4                	jg     800b44 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b60:	eb 34                	jmp    800b96 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800b62:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800b66:	74 1c                	je     800b84 <vprintfmt+0x207>
  800b68:	83 fb 1f             	cmp    $0x1f,%ebx
  800b6b:	7e 05                	jle    800b72 <vprintfmt+0x1f5>
  800b6d:	83 fb 7e             	cmp    $0x7e,%ebx
  800b70:	7e 12                	jle    800b84 <vprintfmt+0x207>
					putch('?', putdat);
  800b72:	83 ec 08             	sub    $0x8,%esp
  800b75:	ff 75 0c             	pushl  0xc(%ebp)
  800b78:	6a 3f                	push   $0x3f
  800b7a:	8b 45 08             	mov    0x8(%ebp),%eax
  800b7d:	ff d0                	call   *%eax
  800b7f:	83 c4 10             	add    $0x10,%esp
  800b82:	eb 0f                	jmp    800b93 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800b84:	83 ec 08             	sub    $0x8,%esp
  800b87:	ff 75 0c             	pushl  0xc(%ebp)
  800b8a:	53                   	push   %ebx
  800b8b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b8e:	ff d0                	call   *%eax
  800b90:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b93:	ff 4d e4             	decl   -0x1c(%ebp)
  800b96:	89 f0                	mov    %esi,%eax
  800b98:	8d 70 01             	lea    0x1(%eax),%esi
  800b9b:	8a 00                	mov    (%eax),%al
  800b9d:	0f be d8             	movsbl %al,%ebx
  800ba0:	85 db                	test   %ebx,%ebx
  800ba2:	74 24                	je     800bc8 <vprintfmt+0x24b>
  800ba4:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800ba8:	78 b8                	js     800b62 <vprintfmt+0x1e5>
  800baa:	ff 4d e0             	decl   -0x20(%ebp)
  800bad:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800bb1:	79 af                	jns    800b62 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800bb3:	eb 13                	jmp    800bc8 <vprintfmt+0x24b>
				putch(' ', putdat);
  800bb5:	83 ec 08             	sub    $0x8,%esp
  800bb8:	ff 75 0c             	pushl  0xc(%ebp)
  800bbb:	6a 20                	push   $0x20
  800bbd:	8b 45 08             	mov    0x8(%ebp),%eax
  800bc0:	ff d0                	call   *%eax
  800bc2:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800bc5:	ff 4d e4             	decl   -0x1c(%ebp)
  800bc8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800bcc:	7f e7                	jg     800bb5 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800bce:	e9 78 01 00 00       	jmp    800d4b <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800bd3:	83 ec 08             	sub    $0x8,%esp
  800bd6:	ff 75 e8             	pushl  -0x18(%ebp)
  800bd9:	8d 45 14             	lea    0x14(%ebp),%eax
  800bdc:	50                   	push   %eax
  800bdd:	e8 3c fd ff ff       	call   80091e <getint>
  800be2:	83 c4 10             	add    $0x10,%esp
  800be5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800be8:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800beb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800bee:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800bf1:	85 d2                	test   %edx,%edx
  800bf3:	79 23                	jns    800c18 <vprintfmt+0x29b>
				putch('-', putdat);
  800bf5:	83 ec 08             	sub    $0x8,%esp
  800bf8:	ff 75 0c             	pushl  0xc(%ebp)
  800bfb:	6a 2d                	push   $0x2d
  800bfd:	8b 45 08             	mov    0x8(%ebp),%eax
  800c00:	ff d0                	call   *%eax
  800c02:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800c05:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c08:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800c0b:	f7 d8                	neg    %eax
  800c0d:	83 d2 00             	adc    $0x0,%edx
  800c10:	f7 da                	neg    %edx
  800c12:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c15:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800c18:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800c1f:	e9 bc 00 00 00       	jmp    800ce0 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800c24:	83 ec 08             	sub    $0x8,%esp
  800c27:	ff 75 e8             	pushl  -0x18(%ebp)
  800c2a:	8d 45 14             	lea    0x14(%ebp),%eax
  800c2d:	50                   	push   %eax
  800c2e:	e8 84 fc ff ff       	call   8008b7 <getuint>
  800c33:	83 c4 10             	add    $0x10,%esp
  800c36:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c39:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800c3c:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800c43:	e9 98 00 00 00       	jmp    800ce0 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800c48:	83 ec 08             	sub    $0x8,%esp
  800c4b:	ff 75 0c             	pushl  0xc(%ebp)
  800c4e:	6a 58                	push   $0x58
  800c50:	8b 45 08             	mov    0x8(%ebp),%eax
  800c53:	ff d0                	call   *%eax
  800c55:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800c58:	83 ec 08             	sub    $0x8,%esp
  800c5b:	ff 75 0c             	pushl  0xc(%ebp)
  800c5e:	6a 58                	push   $0x58
  800c60:	8b 45 08             	mov    0x8(%ebp),%eax
  800c63:	ff d0                	call   *%eax
  800c65:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800c68:	83 ec 08             	sub    $0x8,%esp
  800c6b:	ff 75 0c             	pushl  0xc(%ebp)
  800c6e:	6a 58                	push   $0x58
  800c70:	8b 45 08             	mov    0x8(%ebp),%eax
  800c73:	ff d0                	call   *%eax
  800c75:	83 c4 10             	add    $0x10,%esp
			break;
  800c78:	e9 ce 00 00 00       	jmp    800d4b <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800c7d:	83 ec 08             	sub    $0x8,%esp
  800c80:	ff 75 0c             	pushl  0xc(%ebp)
  800c83:	6a 30                	push   $0x30
  800c85:	8b 45 08             	mov    0x8(%ebp),%eax
  800c88:	ff d0                	call   *%eax
  800c8a:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800c8d:	83 ec 08             	sub    $0x8,%esp
  800c90:	ff 75 0c             	pushl  0xc(%ebp)
  800c93:	6a 78                	push   $0x78
  800c95:	8b 45 08             	mov    0x8(%ebp),%eax
  800c98:	ff d0                	call   *%eax
  800c9a:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800c9d:	8b 45 14             	mov    0x14(%ebp),%eax
  800ca0:	83 c0 04             	add    $0x4,%eax
  800ca3:	89 45 14             	mov    %eax,0x14(%ebp)
  800ca6:	8b 45 14             	mov    0x14(%ebp),%eax
  800ca9:	83 e8 04             	sub    $0x4,%eax
  800cac:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800cae:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800cb1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800cb8:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800cbf:	eb 1f                	jmp    800ce0 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800cc1:	83 ec 08             	sub    $0x8,%esp
  800cc4:	ff 75 e8             	pushl  -0x18(%ebp)
  800cc7:	8d 45 14             	lea    0x14(%ebp),%eax
  800cca:	50                   	push   %eax
  800ccb:	e8 e7 fb ff ff       	call   8008b7 <getuint>
  800cd0:	83 c4 10             	add    $0x10,%esp
  800cd3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800cd6:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800cd9:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800ce0:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800ce4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800ce7:	83 ec 04             	sub    $0x4,%esp
  800cea:	52                   	push   %edx
  800ceb:	ff 75 e4             	pushl  -0x1c(%ebp)
  800cee:	50                   	push   %eax
  800cef:	ff 75 f4             	pushl  -0xc(%ebp)
  800cf2:	ff 75 f0             	pushl  -0x10(%ebp)
  800cf5:	ff 75 0c             	pushl  0xc(%ebp)
  800cf8:	ff 75 08             	pushl  0x8(%ebp)
  800cfb:	e8 00 fb ff ff       	call   800800 <printnum>
  800d00:	83 c4 20             	add    $0x20,%esp
			break;
  800d03:	eb 46                	jmp    800d4b <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800d05:	83 ec 08             	sub    $0x8,%esp
  800d08:	ff 75 0c             	pushl  0xc(%ebp)
  800d0b:	53                   	push   %ebx
  800d0c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d0f:	ff d0                	call   *%eax
  800d11:	83 c4 10             	add    $0x10,%esp
			break;
  800d14:	eb 35                	jmp    800d4b <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800d16:	c6 05 44 60 80 00 00 	movb   $0x0,0x806044
			break;
  800d1d:	eb 2c                	jmp    800d4b <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800d1f:	c6 05 44 60 80 00 01 	movb   $0x1,0x806044
			break;
  800d26:	eb 23                	jmp    800d4b <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800d28:	83 ec 08             	sub    $0x8,%esp
  800d2b:	ff 75 0c             	pushl  0xc(%ebp)
  800d2e:	6a 25                	push   $0x25
  800d30:	8b 45 08             	mov    0x8(%ebp),%eax
  800d33:	ff d0                	call   *%eax
  800d35:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800d38:	ff 4d 10             	decl   0x10(%ebp)
  800d3b:	eb 03                	jmp    800d40 <vprintfmt+0x3c3>
  800d3d:	ff 4d 10             	decl   0x10(%ebp)
  800d40:	8b 45 10             	mov    0x10(%ebp),%eax
  800d43:	48                   	dec    %eax
  800d44:	8a 00                	mov    (%eax),%al
  800d46:	3c 25                	cmp    $0x25,%al
  800d48:	75 f3                	jne    800d3d <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800d4a:	90                   	nop
		}
	}
  800d4b:	e9 35 fc ff ff       	jmp    800985 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800d50:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800d51:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800d54:	5b                   	pop    %ebx
  800d55:	5e                   	pop    %esi
  800d56:	5d                   	pop    %ebp
  800d57:	c3                   	ret    

00800d58 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800d58:	55                   	push   %ebp
  800d59:	89 e5                	mov    %esp,%ebp
  800d5b:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800d5e:	8d 45 10             	lea    0x10(%ebp),%eax
  800d61:	83 c0 04             	add    $0x4,%eax
  800d64:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800d67:	8b 45 10             	mov    0x10(%ebp),%eax
  800d6a:	ff 75 f4             	pushl  -0xc(%ebp)
  800d6d:	50                   	push   %eax
  800d6e:	ff 75 0c             	pushl  0xc(%ebp)
  800d71:	ff 75 08             	pushl  0x8(%ebp)
  800d74:	e8 04 fc ff ff       	call   80097d <vprintfmt>
  800d79:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800d7c:	90                   	nop
  800d7d:	c9                   	leave  
  800d7e:	c3                   	ret    

00800d7f <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800d7f:	55                   	push   %ebp
  800d80:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800d82:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d85:	8b 40 08             	mov    0x8(%eax),%eax
  800d88:	8d 50 01             	lea    0x1(%eax),%edx
  800d8b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d8e:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800d91:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d94:	8b 10                	mov    (%eax),%edx
  800d96:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d99:	8b 40 04             	mov    0x4(%eax),%eax
  800d9c:	39 c2                	cmp    %eax,%edx
  800d9e:	73 12                	jae    800db2 <sprintputch+0x33>
		*b->buf++ = ch;
  800da0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800da3:	8b 00                	mov    (%eax),%eax
  800da5:	8d 48 01             	lea    0x1(%eax),%ecx
  800da8:	8b 55 0c             	mov    0xc(%ebp),%edx
  800dab:	89 0a                	mov    %ecx,(%edx)
  800dad:	8b 55 08             	mov    0x8(%ebp),%edx
  800db0:	88 10                	mov    %dl,(%eax)
}
  800db2:	90                   	nop
  800db3:	5d                   	pop    %ebp
  800db4:	c3                   	ret    

00800db5 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800db5:	55                   	push   %ebp
  800db6:	89 e5                	mov    %esp,%ebp
  800db8:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800dbb:	8b 45 08             	mov    0x8(%ebp),%eax
  800dbe:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800dc1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dc4:	8d 50 ff             	lea    -0x1(%eax),%edx
  800dc7:	8b 45 08             	mov    0x8(%ebp),%eax
  800dca:	01 d0                	add    %edx,%eax
  800dcc:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800dcf:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800dd6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800dda:	74 06                	je     800de2 <vsnprintf+0x2d>
  800ddc:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800de0:	7f 07                	jg     800de9 <vsnprintf+0x34>
		return -E_INVAL;
  800de2:	b8 03 00 00 00       	mov    $0x3,%eax
  800de7:	eb 20                	jmp    800e09 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800de9:	ff 75 14             	pushl  0x14(%ebp)
  800dec:	ff 75 10             	pushl  0x10(%ebp)
  800def:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800df2:	50                   	push   %eax
  800df3:	68 7f 0d 80 00       	push   $0x800d7f
  800df8:	e8 80 fb ff ff       	call   80097d <vprintfmt>
  800dfd:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800e00:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800e03:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800e06:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800e09:	c9                   	leave  
  800e0a:	c3                   	ret    

00800e0b <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800e0b:	55                   	push   %ebp
  800e0c:	89 e5                	mov    %esp,%ebp
  800e0e:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800e11:	8d 45 10             	lea    0x10(%ebp),%eax
  800e14:	83 c0 04             	add    $0x4,%eax
  800e17:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800e1a:	8b 45 10             	mov    0x10(%ebp),%eax
  800e1d:	ff 75 f4             	pushl  -0xc(%ebp)
  800e20:	50                   	push   %eax
  800e21:	ff 75 0c             	pushl  0xc(%ebp)
  800e24:	ff 75 08             	pushl  0x8(%ebp)
  800e27:	e8 89 ff ff ff       	call   800db5 <vsnprintf>
  800e2c:	83 c4 10             	add    $0x10,%esp
  800e2f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800e32:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800e35:	c9                   	leave  
  800e36:	c3                   	ret    

00800e37 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800e37:	55                   	push   %ebp
  800e38:	89 e5                	mov    %esp,%ebp
  800e3a:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800e3d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800e44:	eb 06                	jmp    800e4c <strlen+0x15>
		n++;
  800e46:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800e49:	ff 45 08             	incl   0x8(%ebp)
  800e4c:	8b 45 08             	mov    0x8(%ebp),%eax
  800e4f:	8a 00                	mov    (%eax),%al
  800e51:	84 c0                	test   %al,%al
  800e53:	75 f1                	jne    800e46 <strlen+0xf>
		n++;
	return n;
  800e55:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e58:	c9                   	leave  
  800e59:	c3                   	ret    

00800e5a <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800e5a:	55                   	push   %ebp
  800e5b:	89 e5                	mov    %esp,%ebp
  800e5d:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800e60:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800e67:	eb 09                	jmp    800e72 <strnlen+0x18>
		n++;
  800e69:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800e6c:	ff 45 08             	incl   0x8(%ebp)
  800e6f:	ff 4d 0c             	decl   0xc(%ebp)
  800e72:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e76:	74 09                	je     800e81 <strnlen+0x27>
  800e78:	8b 45 08             	mov    0x8(%ebp),%eax
  800e7b:	8a 00                	mov    (%eax),%al
  800e7d:	84 c0                	test   %al,%al
  800e7f:	75 e8                	jne    800e69 <strnlen+0xf>
		n++;
	return n;
  800e81:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e84:	c9                   	leave  
  800e85:	c3                   	ret    

00800e86 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800e86:	55                   	push   %ebp
  800e87:	89 e5                	mov    %esp,%ebp
  800e89:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800e8c:	8b 45 08             	mov    0x8(%ebp),%eax
  800e8f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800e92:	90                   	nop
  800e93:	8b 45 08             	mov    0x8(%ebp),%eax
  800e96:	8d 50 01             	lea    0x1(%eax),%edx
  800e99:	89 55 08             	mov    %edx,0x8(%ebp)
  800e9c:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e9f:	8d 4a 01             	lea    0x1(%edx),%ecx
  800ea2:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800ea5:	8a 12                	mov    (%edx),%dl
  800ea7:	88 10                	mov    %dl,(%eax)
  800ea9:	8a 00                	mov    (%eax),%al
  800eab:	84 c0                	test   %al,%al
  800ead:	75 e4                	jne    800e93 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800eaf:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800eb2:	c9                   	leave  
  800eb3:	c3                   	ret    

00800eb4 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800eb4:	55                   	push   %ebp
  800eb5:	89 e5                	mov    %esp,%ebp
  800eb7:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800eba:	8b 45 08             	mov    0x8(%ebp),%eax
  800ebd:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800ec0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800ec7:	eb 1f                	jmp    800ee8 <strncpy+0x34>
		*dst++ = *src;
  800ec9:	8b 45 08             	mov    0x8(%ebp),%eax
  800ecc:	8d 50 01             	lea    0x1(%eax),%edx
  800ecf:	89 55 08             	mov    %edx,0x8(%ebp)
  800ed2:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ed5:	8a 12                	mov    (%edx),%dl
  800ed7:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800ed9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800edc:	8a 00                	mov    (%eax),%al
  800ede:	84 c0                	test   %al,%al
  800ee0:	74 03                	je     800ee5 <strncpy+0x31>
			src++;
  800ee2:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800ee5:	ff 45 fc             	incl   -0x4(%ebp)
  800ee8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800eeb:	3b 45 10             	cmp    0x10(%ebp),%eax
  800eee:	72 d9                	jb     800ec9 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800ef0:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800ef3:	c9                   	leave  
  800ef4:	c3                   	ret    

00800ef5 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800ef5:	55                   	push   %ebp
  800ef6:	89 e5                	mov    %esp,%ebp
  800ef8:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800efb:	8b 45 08             	mov    0x8(%ebp),%eax
  800efe:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800f01:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f05:	74 30                	je     800f37 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800f07:	eb 16                	jmp    800f1f <strlcpy+0x2a>
			*dst++ = *src++;
  800f09:	8b 45 08             	mov    0x8(%ebp),%eax
  800f0c:	8d 50 01             	lea    0x1(%eax),%edx
  800f0f:	89 55 08             	mov    %edx,0x8(%ebp)
  800f12:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f15:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f18:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800f1b:	8a 12                	mov    (%edx),%dl
  800f1d:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800f1f:	ff 4d 10             	decl   0x10(%ebp)
  800f22:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f26:	74 09                	je     800f31 <strlcpy+0x3c>
  800f28:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f2b:	8a 00                	mov    (%eax),%al
  800f2d:	84 c0                	test   %al,%al
  800f2f:	75 d8                	jne    800f09 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800f31:	8b 45 08             	mov    0x8(%ebp),%eax
  800f34:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800f37:	8b 55 08             	mov    0x8(%ebp),%edx
  800f3a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f3d:	29 c2                	sub    %eax,%edx
  800f3f:	89 d0                	mov    %edx,%eax
}
  800f41:	c9                   	leave  
  800f42:	c3                   	ret    

00800f43 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800f43:	55                   	push   %ebp
  800f44:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800f46:	eb 06                	jmp    800f4e <strcmp+0xb>
		p++, q++;
  800f48:	ff 45 08             	incl   0x8(%ebp)
  800f4b:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800f4e:	8b 45 08             	mov    0x8(%ebp),%eax
  800f51:	8a 00                	mov    (%eax),%al
  800f53:	84 c0                	test   %al,%al
  800f55:	74 0e                	je     800f65 <strcmp+0x22>
  800f57:	8b 45 08             	mov    0x8(%ebp),%eax
  800f5a:	8a 10                	mov    (%eax),%dl
  800f5c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f5f:	8a 00                	mov    (%eax),%al
  800f61:	38 c2                	cmp    %al,%dl
  800f63:	74 e3                	je     800f48 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800f65:	8b 45 08             	mov    0x8(%ebp),%eax
  800f68:	8a 00                	mov    (%eax),%al
  800f6a:	0f b6 d0             	movzbl %al,%edx
  800f6d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f70:	8a 00                	mov    (%eax),%al
  800f72:	0f b6 c0             	movzbl %al,%eax
  800f75:	29 c2                	sub    %eax,%edx
  800f77:	89 d0                	mov    %edx,%eax
}
  800f79:	5d                   	pop    %ebp
  800f7a:	c3                   	ret    

00800f7b <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800f7b:	55                   	push   %ebp
  800f7c:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800f7e:	eb 09                	jmp    800f89 <strncmp+0xe>
		n--, p++, q++;
  800f80:	ff 4d 10             	decl   0x10(%ebp)
  800f83:	ff 45 08             	incl   0x8(%ebp)
  800f86:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800f89:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f8d:	74 17                	je     800fa6 <strncmp+0x2b>
  800f8f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f92:	8a 00                	mov    (%eax),%al
  800f94:	84 c0                	test   %al,%al
  800f96:	74 0e                	je     800fa6 <strncmp+0x2b>
  800f98:	8b 45 08             	mov    0x8(%ebp),%eax
  800f9b:	8a 10                	mov    (%eax),%dl
  800f9d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fa0:	8a 00                	mov    (%eax),%al
  800fa2:	38 c2                	cmp    %al,%dl
  800fa4:	74 da                	je     800f80 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800fa6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800faa:	75 07                	jne    800fb3 <strncmp+0x38>
		return 0;
  800fac:	b8 00 00 00 00       	mov    $0x0,%eax
  800fb1:	eb 14                	jmp    800fc7 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800fb3:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb6:	8a 00                	mov    (%eax),%al
  800fb8:	0f b6 d0             	movzbl %al,%edx
  800fbb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fbe:	8a 00                	mov    (%eax),%al
  800fc0:	0f b6 c0             	movzbl %al,%eax
  800fc3:	29 c2                	sub    %eax,%edx
  800fc5:	89 d0                	mov    %edx,%eax
}
  800fc7:	5d                   	pop    %ebp
  800fc8:	c3                   	ret    

00800fc9 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800fc9:	55                   	push   %ebp
  800fca:	89 e5                	mov    %esp,%ebp
  800fcc:	83 ec 04             	sub    $0x4,%esp
  800fcf:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fd2:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800fd5:	eb 12                	jmp    800fe9 <strchr+0x20>
		if (*s == c)
  800fd7:	8b 45 08             	mov    0x8(%ebp),%eax
  800fda:	8a 00                	mov    (%eax),%al
  800fdc:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800fdf:	75 05                	jne    800fe6 <strchr+0x1d>
			return (char *) s;
  800fe1:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe4:	eb 11                	jmp    800ff7 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800fe6:	ff 45 08             	incl   0x8(%ebp)
  800fe9:	8b 45 08             	mov    0x8(%ebp),%eax
  800fec:	8a 00                	mov    (%eax),%al
  800fee:	84 c0                	test   %al,%al
  800ff0:	75 e5                	jne    800fd7 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800ff2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ff7:	c9                   	leave  
  800ff8:	c3                   	ret    

00800ff9 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800ff9:	55                   	push   %ebp
  800ffa:	89 e5                	mov    %esp,%ebp
  800ffc:	83 ec 04             	sub    $0x4,%esp
  800fff:	8b 45 0c             	mov    0xc(%ebp),%eax
  801002:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801005:	eb 0d                	jmp    801014 <strfind+0x1b>
		if (*s == c)
  801007:	8b 45 08             	mov    0x8(%ebp),%eax
  80100a:	8a 00                	mov    (%eax),%al
  80100c:	3a 45 fc             	cmp    -0x4(%ebp),%al
  80100f:	74 0e                	je     80101f <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801011:	ff 45 08             	incl   0x8(%ebp)
  801014:	8b 45 08             	mov    0x8(%ebp),%eax
  801017:	8a 00                	mov    (%eax),%al
  801019:	84 c0                	test   %al,%al
  80101b:	75 ea                	jne    801007 <strfind+0xe>
  80101d:	eb 01                	jmp    801020 <strfind+0x27>
		if (*s == c)
			break;
  80101f:	90                   	nop
	return (char *) s;
  801020:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801023:	c9                   	leave  
  801024:	c3                   	ret    

00801025 <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  801025:	55                   	push   %ebp
  801026:	89 e5                	mov    %esp,%ebp
  801028:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  80102b:	8b 45 08             	mov    0x8(%ebp),%eax
  80102e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  801031:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801035:	76 63                	jbe    80109a <memset+0x75>
		uint64 data_block = c;
  801037:	8b 45 0c             	mov    0xc(%ebp),%eax
  80103a:	99                   	cltd   
  80103b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80103e:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  801041:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801044:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801047:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  80104b:	c1 e0 08             	shl    $0x8,%eax
  80104e:	09 45 f0             	or     %eax,-0x10(%ebp)
  801051:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  801054:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801057:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80105a:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  80105e:	c1 e0 10             	shl    $0x10,%eax
  801061:	09 45 f0             	or     %eax,-0x10(%ebp)
  801064:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  801067:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80106a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80106d:	89 c2                	mov    %eax,%edx
  80106f:	b8 00 00 00 00       	mov    $0x0,%eax
  801074:	09 45 f0             	or     %eax,-0x10(%ebp)
  801077:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  80107a:	eb 18                	jmp    801094 <memset+0x6f>
			*p64++ = data_block, n -= 8;
  80107c:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80107f:	8d 41 08             	lea    0x8(%ecx),%eax
  801082:	89 45 fc             	mov    %eax,-0x4(%ebp)
  801085:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801088:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80108b:	89 01                	mov    %eax,(%ecx)
  80108d:	89 51 04             	mov    %edx,0x4(%ecx)
  801090:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  801094:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801098:	77 e2                	ja     80107c <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  80109a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80109e:	74 23                	je     8010c3 <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  8010a0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010a3:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  8010a6:	eb 0e                	jmp    8010b6 <memset+0x91>
			*p8++ = (uint8)c;
  8010a8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010ab:	8d 50 01             	lea    0x1(%eax),%edx
  8010ae:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8010b1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010b4:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  8010b6:	8b 45 10             	mov    0x10(%ebp),%eax
  8010b9:	8d 50 ff             	lea    -0x1(%eax),%edx
  8010bc:	89 55 10             	mov    %edx,0x10(%ebp)
  8010bf:	85 c0                	test   %eax,%eax
  8010c1:	75 e5                	jne    8010a8 <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  8010c3:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8010c6:	c9                   	leave  
  8010c7:	c3                   	ret    

008010c8 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  8010c8:	55                   	push   %ebp
  8010c9:	89 e5                	mov    %esp,%ebp
  8010cb:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  8010ce:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010d1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  8010d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8010d7:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  8010da:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  8010de:	76 24                	jbe    801104 <memcpy+0x3c>
		while(n >= 8){
  8010e0:	eb 1c                	jmp    8010fe <memcpy+0x36>
			*d64 = *s64;
  8010e2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010e5:	8b 50 04             	mov    0x4(%eax),%edx
  8010e8:	8b 00                	mov    (%eax),%eax
  8010ea:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8010ed:	89 01                	mov    %eax,(%ecx)
  8010ef:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  8010f2:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  8010f6:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  8010fa:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  8010fe:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801102:	77 de                	ja     8010e2 <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  801104:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801108:	74 31                	je     80113b <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  80110a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80110d:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  801110:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801113:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  801116:	eb 16                	jmp    80112e <memcpy+0x66>
			*d8++ = *s8++;
  801118:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80111b:	8d 50 01             	lea    0x1(%eax),%edx
  80111e:	89 55 f0             	mov    %edx,-0x10(%ebp)
  801121:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801124:	8d 4a 01             	lea    0x1(%edx),%ecx
  801127:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  80112a:	8a 12                	mov    (%edx),%dl
  80112c:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  80112e:	8b 45 10             	mov    0x10(%ebp),%eax
  801131:	8d 50 ff             	lea    -0x1(%eax),%edx
  801134:	89 55 10             	mov    %edx,0x10(%ebp)
  801137:	85 c0                	test   %eax,%eax
  801139:	75 dd                	jne    801118 <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  80113b:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80113e:	c9                   	leave  
  80113f:	c3                   	ret    

00801140 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801140:	55                   	push   %ebp
  801141:	89 e5                	mov    %esp,%ebp
  801143:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801146:	8b 45 0c             	mov    0xc(%ebp),%eax
  801149:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  80114c:	8b 45 08             	mov    0x8(%ebp),%eax
  80114f:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801152:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801155:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801158:	73 50                	jae    8011aa <memmove+0x6a>
  80115a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80115d:	8b 45 10             	mov    0x10(%ebp),%eax
  801160:	01 d0                	add    %edx,%eax
  801162:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801165:	76 43                	jbe    8011aa <memmove+0x6a>
		s += n;
  801167:	8b 45 10             	mov    0x10(%ebp),%eax
  80116a:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  80116d:	8b 45 10             	mov    0x10(%ebp),%eax
  801170:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  801173:	eb 10                	jmp    801185 <memmove+0x45>
			*--d = *--s;
  801175:	ff 4d f8             	decl   -0x8(%ebp)
  801178:	ff 4d fc             	decl   -0x4(%ebp)
  80117b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80117e:	8a 10                	mov    (%eax),%dl
  801180:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801183:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  801185:	8b 45 10             	mov    0x10(%ebp),%eax
  801188:	8d 50 ff             	lea    -0x1(%eax),%edx
  80118b:	89 55 10             	mov    %edx,0x10(%ebp)
  80118e:	85 c0                	test   %eax,%eax
  801190:	75 e3                	jne    801175 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801192:	eb 23                	jmp    8011b7 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  801194:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801197:	8d 50 01             	lea    0x1(%eax),%edx
  80119a:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80119d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8011a0:	8d 4a 01             	lea    0x1(%edx),%ecx
  8011a3:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8011a6:	8a 12                	mov    (%edx),%dl
  8011a8:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  8011aa:	8b 45 10             	mov    0x10(%ebp),%eax
  8011ad:	8d 50 ff             	lea    -0x1(%eax),%edx
  8011b0:	89 55 10             	mov    %edx,0x10(%ebp)
  8011b3:	85 c0                	test   %eax,%eax
  8011b5:	75 dd                	jne    801194 <memmove+0x54>
			*d++ = *s++;

	return dst;
  8011b7:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8011ba:	c9                   	leave  
  8011bb:	c3                   	ret    

008011bc <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8011bc:	55                   	push   %ebp
  8011bd:	89 e5                	mov    %esp,%ebp
  8011bf:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  8011c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8011c5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  8011c8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011cb:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8011ce:	eb 2a                	jmp    8011fa <memcmp+0x3e>
		if (*s1 != *s2)
  8011d0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011d3:	8a 10                	mov    (%eax),%dl
  8011d5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011d8:	8a 00                	mov    (%eax),%al
  8011da:	38 c2                	cmp    %al,%dl
  8011dc:	74 16                	je     8011f4 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  8011de:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011e1:	8a 00                	mov    (%eax),%al
  8011e3:	0f b6 d0             	movzbl %al,%edx
  8011e6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011e9:	8a 00                	mov    (%eax),%al
  8011eb:	0f b6 c0             	movzbl %al,%eax
  8011ee:	29 c2                	sub    %eax,%edx
  8011f0:	89 d0                	mov    %edx,%eax
  8011f2:	eb 18                	jmp    80120c <memcmp+0x50>
		s1++, s2++;
  8011f4:	ff 45 fc             	incl   -0x4(%ebp)
  8011f7:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  8011fa:	8b 45 10             	mov    0x10(%ebp),%eax
  8011fd:	8d 50 ff             	lea    -0x1(%eax),%edx
  801200:	89 55 10             	mov    %edx,0x10(%ebp)
  801203:	85 c0                	test   %eax,%eax
  801205:	75 c9                	jne    8011d0 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801207:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80120c:	c9                   	leave  
  80120d:	c3                   	ret    

0080120e <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  80120e:	55                   	push   %ebp
  80120f:	89 e5                	mov    %esp,%ebp
  801211:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801214:	8b 55 08             	mov    0x8(%ebp),%edx
  801217:	8b 45 10             	mov    0x10(%ebp),%eax
  80121a:	01 d0                	add    %edx,%eax
  80121c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  80121f:	eb 15                	jmp    801236 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801221:	8b 45 08             	mov    0x8(%ebp),%eax
  801224:	8a 00                	mov    (%eax),%al
  801226:	0f b6 d0             	movzbl %al,%edx
  801229:	8b 45 0c             	mov    0xc(%ebp),%eax
  80122c:	0f b6 c0             	movzbl %al,%eax
  80122f:	39 c2                	cmp    %eax,%edx
  801231:	74 0d                	je     801240 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801233:	ff 45 08             	incl   0x8(%ebp)
  801236:	8b 45 08             	mov    0x8(%ebp),%eax
  801239:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80123c:	72 e3                	jb     801221 <memfind+0x13>
  80123e:	eb 01                	jmp    801241 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801240:	90                   	nop
	return (void *) s;
  801241:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801244:	c9                   	leave  
  801245:	c3                   	ret    

00801246 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801246:	55                   	push   %ebp
  801247:	89 e5                	mov    %esp,%ebp
  801249:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  80124c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801253:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80125a:	eb 03                	jmp    80125f <strtol+0x19>
		s++;
  80125c:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80125f:	8b 45 08             	mov    0x8(%ebp),%eax
  801262:	8a 00                	mov    (%eax),%al
  801264:	3c 20                	cmp    $0x20,%al
  801266:	74 f4                	je     80125c <strtol+0x16>
  801268:	8b 45 08             	mov    0x8(%ebp),%eax
  80126b:	8a 00                	mov    (%eax),%al
  80126d:	3c 09                	cmp    $0x9,%al
  80126f:	74 eb                	je     80125c <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801271:	8b 45 08             	mov    0x8(%ebp),%eax
  801274:	8a 00                	mov    (%eax),%al
  801276:	3c 2b                	cmp    $0x2b,%al
  801278:	75 05                	jne    80127f <strtol+0x39>
		s++;
  80127a:	ff 45 08             	incl   0x8(%ebp)
  80127d:	eb 13                	jmp    801292 <strtol+0x4c>
	else if (*s == '-')
  80127f:	8b 45 08             	mov    0x8(%ebp),%eax
  801282:	8a 00                	mov    (%eax),%al
  801284:	3c 2d                	cmp    $0x2d,%al
  801286:	75 0a                	jne    801292 <strtol+0x4c>
		s++, neg = 1;
  801288:	ff 45 08             	incl   0x8(%ebp)
  80128b:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801292:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801296:	74 06                	je     80129e <strtol+0x58>
  801298:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  80129c:	75 20                	jne    8012be <strtol+0x78>
  80129e:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a1:	8a 00                	mov    (%eax),%al
  8012a3:	3c 30                	cmp    $0x30,%al
  8012a5:	75 17                	jne    8012be <strtol+0x78>
  8012a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8012aa:	40                   	inc    %eax
  8012ab:	8a 00                	mov    (%eax),%al
  8012ad:	3c 78                	cmp    $0x78,%al
  8012af:	75 0d                	jne    8012be <strtol+0x78>
		s += 2, base = 16;
  8012b1:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8012b5:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8012bc:	eb 28                	jmp    8012e6 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8012be:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8012c2:	75 15                	jne    8012d9 <strtol+0x93>
  8012c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8012c7:	8a 00                	mov    (%eax),%al
  8012c9:	3c 30                	cmp    $0x30,%al
  8012cb:	75 0c                	jne    8012d9 <strtol+0x93>
		s++, base = 8;
  8012cd:	ff 45 08             	incl   0x8(%ebp)
  8012d0:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8012d7:	eb 0d                	jmp    8012e6 <strtol+0xa0>
	else if (base == 0)
  8012d9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8012dd:	75 07                	jne    8012e6 <strtol+0xa0>
		base = 10;
  8012df:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8012e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8012e9:	8a 00                	mov    (%eax),%al
  8012eb:	3c 2f                	cmp    $0x2f,%al
  8012ed:	7e 19                	jle    801308 <strtol+0xc2>
  8012ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8012f2:	8a 00                	mov    (%eax),%al
  8012f4:	3c 39                	cmp    $0x39,%al
  8012f6:	7f 10                	jg     801308 <strtol+0xc2>
			dig = *s - '0';
  8012f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8012fb:	8a 00                	mov    (%eax),%al
  8012fd:	0f be c0             	movsbl %al,%eax
  801300:	83 e8 30             	sub    $0x30,%eax
  801303:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801306:	eb 42                	jmp    80134a <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801308:	8b 45 08             	mov    0x8(%ebp),%eax
  80130b:	8a 00                	mov    (%eax),%al
  80130d:	3c 60                	cmp    $0x60,%al
  80130f:	7e 19                	jle    80132a <strtol+0xe4>
  801311:	8b 45 08             	mov    0x8(%ebp),%eax
  801314:	8a 00                	mov    (%eax),%al
  801316:	3c 7a                	cmp    $0x7a,%al
  801318:	7f 10                	jg     80132a <strtol+0xe4>
			dig = *s - 'a' + 10;
  80131a:	8b 45 08             	mov    0x8(%ebp),%eax
  80131d:	8a 00                	mov    (%eax),%al
  80131f:	0f be c0             	movsbl %al,%eax
  801322:	83 e8 57             	sub    $0x57,%eax
  801325:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801328:	eb 20                	jmp    80134a <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  80132a:	8b 45 08             	mov    0x8(%ebp),%eax
  80132d:	8a 00                	mov    (%eax),%al
  80132f:	3c 40                	cmp    $0x40,%al
  801331:	7e 39                	jle    80136c <strtol+0x126>
  801333:	8b 45 08             	mov    0x8(%ebp),%eax
  801336:	8a 00                	mov    (%eax),%al
  801338:	3c 5a                	cmp    $0x5a,%al
  80133a:	7f 30                	jg     80136c <strtol+0x126>
			dig = *s - 'A' + 10;
  80133c:	8b 45 08             	mov    0x8(%ebp),%eax
  80133f:	8a 00                	mov    (%eax),%al
  801341:	0f be c0             	movsbl %al,%eax
  801344:	83 e8 37             	sub    $0x37,%eax
  801347:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  80134a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80134d:	3b 45 10             	cmp    0x10(%ebp),%eax
  801350:	7d 19                	jge    80136b <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801352:	ff 45 08             	incl   0x8(%ebp)
  801355:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801358:	0f af 45 10          	imul   0x10(%ebp),%eax
  80135c:	89 c2                	mov    %eax,%edx
  80135e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801361:	01 d0                	add    %edx,%eax
  801363:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801366:	e9 7b ff ff ff       	jmp    8012e6 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  80136b:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  80136c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801370:	74 08                	je     80137a <strtol+0x134>
		*endptr = (char *) s;
  801372:	8b 45 0c             	mov    0xc(%ebp),%eax
  801375:	8b 55 08             	mov    0x8(%ebp),%edx
  801378:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  80137a:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80137e:	74 07                	je     801387 <strtol+0x141>
  801380:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801383:	f7 d8                	neg    %eax
  801385:	eb 03                	jmp    80138a <strtol+0x144>
  801387:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80138a:	c9                   	leave  
  80138b:	c3                   	ret    

0080138c <ltostr>:

void
ltostr(long value, char *str)
{
  80138c:	55                   	push   %ebp
  80138d:	89 e5                	mov    %esp,%ebp
  80138f:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801392:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801399:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8013a0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8013a4:	79 13                	jns    8013b9 <ltostr+0x2d>
	{
		neg = 1;
  8013a6:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8013ad:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013b0:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8013b3:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8013b6:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8013b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8013bc:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8013c1:	99                   	cltd   
  8013c2:	f7 f9                	idiv   %ecx
  8013c4:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8013c7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8013ca:	8d 50 01             	lea    0x1(%eax),%edx
  8013cd:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8013d0:	89 c2                	mov    %eax,%edx
  8013d2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013d5:	01 d0                	add    %edx,%eax
  8013d7:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8013da:	83 c2 30             	add    $0x30,%edx
  8013dd:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8013df:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8013e2:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8013e7:	f7 e9                	imul   %ecx
  8013e9:	c1 fa 02             	sar    $0x2,%edx
  8013ec:	89 c8                	mov    %ecx,%eax
  8013ee:	c1 f8 1f             	sar    $0x1f,%eax
  8013f1:	29 c2                	sub    %eax,%edx
  8013f3:	89 d0                	mov    %edx,%eax
  8013f5:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  8013f8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8013fc:	75 bb                	jne    8013b9 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8013fe:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801405:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801408:	48                   	dec    %eax
  801409:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  80140c:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801410:	74 3d                	je     80144f <ltostr+0xc3>
		start = 1 ;
  801412:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801419:	eb 34                	jmp    80144f <ltostr+0xc3>
	{
		char tmp = str[start] ;
  80141b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80141e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801421:	01 d0                	add    %edx,%eax
  801423:	8a 00                	mov    (%eax),%al
  801425:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801428:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80142b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80142e:	01 c2                	add    %eax,%edx
  801430:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801433:	8b 45 0c             	mov    0xc(%ebp),%eax
  801436:	01 c8                	add    %ecx,%eax
  801438:	8a 00                	mov    (%eax),%al
  80143a:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  80143c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80143f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801442:	01 c2                	add    %eax,%edx
  801444:	8a 45 eb             	mov    -0x15(%ebp),%al
  801447:	88 02                	mov    %al,(%edx)
		start++ ;
  801449:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  80144c:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  80144f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801452:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801455:	7c c4                	jl     80141b <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801457:	8b 55 f8             	mov    -0x8(%ebp),%edx
  80145a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80145d:	01 d0                	add    %edx,%eax
  80145f:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801462:	90                   	nop
  801463:	c9                   	leave  
  801464:	c3                   	ret    

00801465 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801465:	55                   	push   %ebp
  801466:	89 e5                	mov    %esp,%ebp
  801468:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  80146b:	ff 75 08             	pushl  0x8(%ebp)
  80146e:	e8 c4 f9 ff ff       	call   800e37 <strlen>
  801473:	83 c4 04             	add    $0x4,%esp
  801476:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801479:	ff 75 0c             	pushl  0xc(%ebp)
  80147c:	e8 b6 f9 ff ff       	call   800e37 <strlen>
  801481:	83 c4 04             	add    $0x4,%esp
  801484:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801487:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  80148e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801495:	eb 17                	jmp    8014ae <strcconcat+0x49>
		final[s] = str1[s] ;
  801497:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80149a:	8b 45 10             	mov    0x10(%ebp),%eax
  80149d:	01 c2                	add    %eax,%edx
  80149f:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8014a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8014a5:	01 c8                	add    %ecx,%eax
  8014a7:	8a 00                	mov    (%eax),%al
  8014a9:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8014ab:	ff 45 fc             	incl   -0x4(%ebp)
  8014ae:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8014b1:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8014b4:	7c e1                	jl     801497 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8014b6:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8014bd:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8014c4:	eb 1f                	jmp    8014e5 <strcconcat+0x80>
		final[s++] = str2[i] ;
  8014c6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8014c9:	8d 50 01             	lea    0x1(%eax),%edx
  8014cc:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8014cf:	89 c2                	mov    %eax,%edx
  8014d1:	8b 45 10             	mov    0x10(%ebp),%eax
  8014d4:	01 c2                	add    %eax,%edx
  8014d6:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8014d9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014dc:	01 c8                	add    %ecx,%eax
  8014de:	8a 00                	mov    (%eax),%al
  8014e0:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8014e2:	ff 45 f8             	incl   -0x8(%ebp)
  8014e5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8014e8:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8014eb:	7c d9                	jl     8014c6 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8014ed:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8014f0:	8b 45 10             	mov    0x10(%ebp),%eax
  8014f3:	01 d0                	add    %edx,%eax
  8014f5:	c6 00 00             	movb   $0x0,(%eax)
}
  8014f8:	90                   	nop
  8014f9:	c9                   	leave  
  8014fa:	c3                   	ret    

008014fb <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8014fb:	55                   	push   %ebp
  8014fc:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8014fe:	8b 45 14             	mov    0x14(%ebp),%eax
  801501:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801507:	8b 45 14             	mov    0x14(%ebp),%eax
  80150a:	8b 00                	mov    (%eax),%eax
  80150c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801513:	8b 45 10             	mov    0x10(%ebp),%eax
  801516:	01 d0                	add    %edx,%eax
  801518:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80151e:	eb 0c                	jmp    80152c <strsplit+0x31>
			*string++ = 0;
  801520:	8b 45 08             	mov    0x8(%ebp),%eax
  801523:	8d 50 01             	lea    0x1(%eax),%edx
  801526:	89 55 08             	mov    %edx,0x8(%ebp)
  801529:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80152c:	8b 45 08             	mov    0x8(%ebp),%eax
  80152f:	8a 00                	mov    (%eax),%al
  801531:	84 c0                	test   %al,%al
  801533:	74 18                	je     80154d <strsplit+0x52>
  801535:	8b 45 08             	mov    0x8(%ebp),%eax
  801538:	8a 00                	mov    (%eax),%al
  80153a:	0f be c0             	movsbl %al,%eax
  80153d:	50                   	push   %eax
  80153e:	ff 75 0c             	pushl  0xc(%ebp)
  801541:	e8 83 fa ff ff       	call   800fc9 <strchr>
  801546:	83 c4 08             	add    $0x8,%esp
  801549:	85 c0                	test   %eax,%eax
  80154b:	75 d3                	jne    801520 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  80154d:	8b 45 08             	mov    0x8(%ebp),%eax
  801550:	8a 00                	mov    (%eax),%al
  801552:	84 c0                	test   %al,%al
  801554:	74 5a                	je     8015b0 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801556:	8b 45 14             	mov    0x14(%ebp),%eax
  801559:	8b 00                	mov    (%eax),%eax
  80155b:	83 f8 0f             	cmp    $0xf,%eax
  80155e:	75 07                	jne    801567 <strsplit+0x6c>
		{
			return 0;
  801560:	b8 00 00 00 00       	mov    $0x0,%eax
  801565:	eb 66                	jmp    8015cd <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801567:	8b 45 14             	mov    0x14(%ebp),%eax
  80156a:	8b 00                	mov    (%eax),%eax
  80156c:	8d 48 01             	lea    0x1(%eax),%ecx
  80156f:	8b 55 14             	mov    0x14(%ebp),%edx
  801572:	89 0a                	mov    %ecx,(%edx)
  801574:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80157b:	8b 45 10             	mov    0x10(%ebp),%eax
  80157e:	01 c2                	add    %eax,%edx
  801580:	8b 45 08             	mov    0x8(%ebp),%eax
  801583:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801585:	eb 03                	jmp    80158a <strsplit+0x8f>
			string++;
  801587:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  80158a:	8b 45 08             	mov    0x8(%ebp),%eax
  80158d:	8a 00                	mov    (%eax),%al
  80158f:	84 c0                	test   %al,%al
  801591:	74 8b                	je     80151e <strsplit+0x23>
  801593:	8b 45 08             	mov    0x8(%ebp),%eax
  801596:	8a 00                	mov    (%eax),%al
  801598:	0f be c0             	movsbl %al,%eax
  80159b:	50                   	push   %eax
  80159c:	ff 75 0c             	pushl  0xc(%ebp)
  80159f:	e8 25 fa ff ff       	call   800fc9 <strchr>
  8015a4:	83 c4 08             	add    $0x8,%esp
  8015a7:	85 c0                	test   %eax,%eax
  8015a9:	74 dc                	je     801587 <strsplit+0x8c>
			string++;
	}
  8015ab:	e9 6e ff ff ff       	jmp    80151e <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8015b0:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8015b1:	8b 45 14             	mov    0x14(%ebp),%eax
  8015b4:	8b 00                	mov    (%eax),%eax
  8015b6:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8015bd:	8b 45 10             	mov    0x10(%ebp),%eax
  8015c0:	01 d0                	add    %edx,%eax
  8015c2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8015c8:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8015cd:	c9                   	leave  
  8015ce:	c3                   	ret    

008015cf <str2lower>:


char* str2lower(char *dst, const char *src)
{
  8015cf:	55                   	push   %ebp
  8015d0:	89 e5                	mov    %esp,%ebp
  8015d2:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  8015d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8015d8:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  8015db:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8015e2:	eb 4a                	jmp    80162e <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  8015e4:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8015e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8015ea:	01 c2                	add    %eax,%edx
  8015ec:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8015ef:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015f2:	01 c8                	add    %ecx,%eax
  8015f4:	8a 00                	mov    (%eax),%al
  8015f6:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  8015f8:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8015fb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015fe:	01 d0                	add    %edx,%eax
  801600:	8a 00                	mov    (%eax),%al
  801602:	3c 40                	cmp    $0x40,%al
  801604:	7e 25                	jle    80162b <str2lower+0x5c>
  801606:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801609:	8b 45 0c             	mov    0xc(%ebp),%eax
  80160c:	01 d0                	add    %edx,%eax
  80160e:	8a 00                	mov    (%eax),%al
  801610:	3c 5a                	cmp    $0x5a,%al
  801612:	7f 17                	jg     80162b <str2lower+0x5c>
		{
			dst[i] += 32 ;
  801614:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801617:	8b 45 08             	mov    0x8(%ebp),%eax
  80161a:	01 d0                	add    %edx,%eax
  80161c:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80161f:	8b 55 08             	mov    0x8(%ebp),%edx
  801622:	01 ca                	add    %ecx,%edx
  801624:	8a 12                	mov    (%edx),%dl
  801626:	83 c2 20             	add    $0x20,%edx
  801629:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  80162b:	ff 45 fc             	incl   -0x4(%ebp)
  80162e:	ff 75 0c             	pushl  0xc(%ebp)
  801631:	e8 01 f8 ff ff       	call   800e37 <strlen>
  801636:	83 c4 04             	add    $0x4,%esp
  801639:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80163c:	7f a6                	jg     8015e4 <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  80163e:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801641:	c9                   	leave  
  801642:	c3                   	ret    

00801643 <uheap_init>:
//==============================================
// [1] INITIALIZE USER HEAP:
//==============================================
int __firstTimeFlag = 1;
void uheap_init()
{
  801643:	55                   	push   %ebp
  801644:	89 e5                	mov    %esp,%ebp
  801646:	83 ec 08             	sub    $0x8,%esp
	if(__firstTimeFlag)
  801649:	a1 08 60 80 00       	mov    0x806008,%eax
  80164e:	85 c0                	test   %eax,%eax
  801650:	0f 84 95 00 00 00    	je     8016eb <uheap_init+0xa8>
	{
		initialize_dynamic_allocator(USER_HEAP_START, USER_HEAP_START + DYN_ALLOC_MAX_SIZE);
  801656:	83 ec 08             	sub    $0x8,%esp
  801659:	68 00 00 00 82       	push   $0x82000000
  80165e:	68 00 00 00 80       	push   $0x80000000
  801663:	e8 59 1f 00 00       	call   8035c1 <initialize_dynamic_allocator>
  801668:	83 c4 10             	add    $0x10,%esp
		uheapPlaceStrategy = sys_get_uheap_strategy();
  80166b:	e8 93 1d 00 00       	call   803403 <sys_get_uheap_strategy>
  801670:	a3 60 e0 81 00       	mov    %eax,0x81e060
		uheapPageAllocStart = dynAllocEnd + PAGE_SIZE;
  801675:	a1 40 60 80 00       	mov    0x806040,%eax
  80167a:	05 00 10 00 00       	add    $0x1000,%eax
  80167f:	a3 10 e1 81 00       	mov    %eax,0x81e110
		uheapPageAllocBreak = uheapPageAllocStart;
  801684:	a1 10 e1 81 00       	mov    0x81e110,%eax
  801689:	a3 68 e0 81 00       	mov    %eax,0x81e068
		init_uspinlock(&ulock,"malloc",1);
  80168e:	83 ec 04             	sub    $0x4,%esp
  801691:	6a 01                	push   $0x1
  801693:	68 08 4d 80 00       	push   $0x804d08
  801698:	68 40 e1 81 00       	push   $0x81e140
  80169d:	e8 d8 29 00 00       	call   80407a <init_uspinlock>
  8016a2:	83 c4 10             	add    $0x10,%esp
		LIST_INIT(&u_freelist);
  8016a5:	c7 05 20 e1 81 00 00 	movl   $0x0,0x81e120
  8016ac:	00 00 00 
  8016af:	c7 05 24 e1 81 00 00 	movl   $0x0,0x81e124
  8016b6:	00 00 00 
  8016b9:	c7 05 2c e1 81 00 00 	movl   $0x0,0x81e12c
  8016c0:	00 00 00 
		LIST_INIT(&u_allocatedlist);
  8016c3:	c7 05 30 e1 81 00 00 	movl   $0x0,0x81e130
  8016ca:	00 00 00 
  8016cd:	c7 05 34 e1 81 00 00 	movl   $0x0,0x81e134
  8016d4:	00 00 00 
  8016d7:	c7 05 3c e1 81 00 00 	movl   $0x0,0x81e13c
  8016de:	00 00 00 
		__firstTimeFlag = 0;
  8016e1:	c7 05 08 60 80 00 00 	movl   $0x0,0x806008
  8016e8:	00 00 00 
	}
}
  8016eb:	90                   	nop
  8016ec:	c9                   	leave  
  8016ed:	c3                   	ret    

008016ee <get_page>:

//==============================================
// [2] GET A PAGE FROM THE KERNEL FOR DA:
//==============================================
int get_page(void* va)
{
  8016ee:	55                   	push   %ebp
  8016ef:	89 e5                	mov    %esp,%ebp
  8016f1:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_allocate_page(ROUNDDOWN(va, PAGE_SIZE), PERM_USER|PERM_WRITEABLE|PERM_UHPAGE);
  8016f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8016f7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8016fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016fd:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801702:	83 ec 08             	sub    $0x8,%esp
  801705:	68 06 04 00 00       	push   $0x406
  80170a:	50                   	push   %eax
  80170b:	e8 3d 19 00 00       	call   80304d <__sys_allocate_page>
  801710:	83 c4 10             	add    $0x10,%esp
  801713:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  801716:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80171a:	79 14                	jns    801730 <get_page+0x42>
		panic("get_page() in user: failed to allocate page from the kernel");
  80171c:	83 ec 04             	sub    $0x4,%esp
  80171f:	68 10 4d 80 00       	push   $0x804d10
  801724:	6a 2d                	push   $0x2d
  801726:	68 4c 4d 80 00       	push   $0x804d4c
  80172b:	e8 60 ed ff ff       	call   800490 <_panic>
	return 0;
  801730:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801735:	c9                   	leave  
  801736:	c3                   	ret    

00801737 <return_page>:

//==============================================
// [3] RETURN A PAGE FROM THE DA TO KERNEL:
//==============================================
void return_page(void* va)
{
  801737:	55                   	push   %ebp
  801738:	89 e5                	mov    %esp,%ebp
  80173a:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_unmap_frame(ROUNDDOWN((uint32)va, PAGE_SIZE));
  80173d:	8b 45 08             	mov    0x8(%ebp),%eax
  801740:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801743:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801746:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80174b:	83 ec 0c             	sub    $0xc,%esp
  80174e:	50                   	push   %eax
  80174f:	e8 40 19 00 00       	call   803094 <__sys_unmap_frame>
  801754:	83 c4 10             	add    $0x10,%esp
  801757:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  80175a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80175e:	79 14                	jns    801774 <return_page+0x3d>
		panic("return_page() in user: failed to return a page to the kernel");
  801760:	83 ec 04             	sub    $0x4,%esp
  801763:	68 58 4d 80 00       	push   $0x804d58
  801768:	6a 38                	push   $0x38
  80176a:	68 4c 4d 80 00       	push   $0x804d4c
  80176f:	e8 1c ed ff ff       	call   800490 <_panic>
}
  801774:	90                   	nop
  801775:	c9                   	leave  
  801776:	c3                   	ret    

00801777 <malloc>:

//=================================
// [1] ALLOCATE SPACE IN USER HEAP:
//=================================
void* malloc(uint32 size)
{
  801777:	55                   	push   %ebp
  801778:	89 e5                	mov    %esp,%ebp
  80177a:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  80177d:	e8 c1 fe ff ff       	call   801643 <uheap_init>
	if (size == 0) return NULL ;
  801782:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801786:	75 0a                	jne    801792 <malloc+0x1b>
  801788:	b8 00 00 00 00       	mov    $0x0,%eax
  80178d:	e9 e1 04 00 00       	jmp    801c73 <malloc+0x4fc>
	//==============================================================

	acquire_uspinlock(&ulock);
  801792:	83 ec 0c             	sub    $0xc,%esp
  801795:	68 40 e1 81 00       	push   $0x81e140
  80179a:	e8 2a 29 00 00       	call   8040c9 <acquire_uspinlock>
  80179f:	83 c4 10             	add    $0x10,%esp
	if(size <  DYN_ALLOC_MAX_BLOCK_SIZE){
  8017a2:	81 7d 08 ff 07 00 00 	cmpl   $0x7ff,0x8(%ebp)
  8017a9:	77 23                	ja     8017ce <malloc+0x57>
		release_uspinlock(&ulock);
  8017ab:	83 ec 0c             	sub    $0xc,%esp
  8017ae:	68 40 e1 81 00       	push   $0x81e140
  8017b3:	e8 69 29 00 00       	call   804121 <release_uspinlock>
  8017b8:	83 c4 10             	add    $0x10,%esp
		return alloc_block(size);
  8017bb:	83 ec 0c             	sub    $0xc,%esp
  8017be:	ff 75 08             	pushl  0x8(%ebp)
  8017c1:	e8 dd 1f 00 00       	call   8037a3 <alloc_block>
  8017c6:	83 c4 10             	add    $0x10,%esp
  8017c9:	e9 a5 04 00 00       	jmp    801c73 <malloc+0x4fc>
	}

	struct UserHeapStruct* allocblock= (struct UserHeapStruct*) alloc_block(sizeof(struct UserHeapStruct));
  8017ce:	83 ec 0c             	sub    $0xc,%esp
  8017d1:	6a 10                	push   $0x10
  8017d3:	e8 cb 1f 00 00       	call   8037a3 <alloc_block>
  8017d8:	83 c4 10             	add    $0x10,%esp
  8017db:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (allocblock == NULL){
  8017de:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8017e2:	75 0a                	jne    8017ee <malloc+0x77>
			return NULL;
  8017e4:	b8 00 00 00 00       	mov    $0x0,%eax
  8017e9:	e9 85 04 00 00       	jmp    801c73 <malloc+0x4fc>
	}

	size = ROUNDUP(size,PAGE_SIZE);
  8017ee:	c7 45 e8 00 10 00 00 	movl   $0x1000,-0x18(%ebp)
  8017f5:	8b 55 08             	mov    0x8(%ebp),%edx
  8017f8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8017fb:	01 d0                	add    %edx,%eax
  8017fd:	48                   	dec    %eax
  8017fe:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801801:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801804:	ba 00 00 00 00       	mov    $0x0,%edx
  801809:	f7 75 e8             	divl   -0x18(%ebp)
  80180c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80180f:	29 d0                	sub    %edx,%eax
  801811:	89 45 08             	mov    %eax,0x8(%ebp)
	struct UserHeapStruct* lastfreeelement = LIST_LAST(&u_freelist);
  801814:	a1 24 e1 81 00       	mov    0x81e124,%eax
  801819:	89 45 e0             	mov    %eax,-0x20(%ebp)

	if(LIST_SIZE(&u_freelist)==0 || size>lastfreeelement->size){
  80181c:	a1 2c e1 81 00       	mov    0x81e12c,%eax
  801821:	85 c0                	test   %eax,%eax
  801823:	74 0f                	je     801834 <malloc+0xbd>
  801825:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801828:	8b 40 04             	mov    0x4(%eax),%eax
  80182b:	3b 45 08             	cmp    0x8(%ebp),%eax
  80182e:	0f 83 ea 00 00 00    	jae    80191e <malloc+0x1a7>
			if(uheapPageAllocBreak < USER_HEAP_MAX - size){
  801834:	b8 00 00 00 a0       	mov    $0xa0000000,%eax
  801839:	2b 45 08             	sub    0x8(%ebp),%eax
  80183c:	89 c2                	mov    %eax,%edx
  80183e:	a1 68 e0 81 00       	mov    0x81e068,%eax
  801843:	39 c2                	cmp    %eax,%edx
  801845:	0f 86 b9 00 00 00    	jbe    801904 <malloc+0x18d>
					uint32 requestedblockva = uheapPageAllocBreak;
  80184b:	a1 68 e0 81 00       	mov    0x81e068,%eax
  801850:	89 45 dc             	mov    %eax,-0x24(%ebp)
					uheapPageAllocBreak+=size;
  801853:	8b 15 68 e0 81 00    	mov    0x81e068,%edx
  801859:	8b 45 08             	mov    0x8(%ebp),%eax
  80185c:	01 d0                	add    %edx,%eax
  80185e:	a3 68 e0 81 00       	mov    %eax,0x81e068
					allocblock->startva = requestedblockva;
  801863:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801866:	8b 55 dc             	mov    -0x24(%ebp),%edx
  801869:	89 10                	mov    %edx,(%eax)
					allocblock->size = size;
  80186b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80186e:	8b 55 08             	mov    0x8(%ebp),%edx
  801871:	89 50 04             	mov    %edx,0x4(%eax)

					LIST_INSERT_TAIL(&u_allocatedlist, allocblock);
  801874:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801878:	75 14                	jne    80188e <malloc+0x117>
  80187a:	83 ec 04             	sub    $0x4,%esp
  80187d:	68 98 4d 80 00       	push   $0x804d98
  801882:	6a 60                	push   $0x60
  801884:	68 4c 4d 80 00       	push   $0x804d4c
  801889:	e8 02 ec ff ff       	call   800490 <_panic>
  80188e:	8b 15 34 e1 81 00    	mov    0x81e134,%edx
  801894:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801897:	89 50 0c             	mov    %edx,0xc(%eax)
  80189a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80189d:	8b 40 0c             	mov    0xc(%eax),%eax
  8018a0:	85 c0                	test   %eax,%eax
  8018a2:	74 0d                	je     8018b1 <malloc+0x13a>
  8018a4:	a1 34 e1 81 00       	mov    0x81e134,%eax
  8018a9:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8018ac:	89 50 08             	mov    %edx,0x8(%eax)
  8018af:	eb 08                	jmp    8018b9 <malloc+0x142>
  8018b1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8018b4:	a3 30 e1 81 00       	mov    %eax,0x81e130
  8018b9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8018bc:	a3 34 e1 81 00       	mov    %eax,0x81e134
  8018c1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8018c4:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  8018cb:	a1 3c e1 81 00       	mov    0x81e13c,%eax
  8018d0:	40                   	inc    %eax
  8018d1:	a3 3c e1 81 00       	mov    %eax,0x81e13c


					sys_allocate_user_mem(allocblock->startva ,size);
  8018d6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8018d9:	8b 00                	mov    (%eax),%eax
  8018db:	83 ec 08             	sub    $0x8,%esp
  8018de:	ff 75 08             	pushl  0x8(%ebp)
  8018e1:	50                   	push   %eax
  8018e2:	e8 34 1c 00 00       	call   80351b <sys_allocate_user_mem>
  8018e7:	83 c4 10             	add    $0x10,%esp
					release_uspinlock(&ulock);
  8018ea:	83 ec 0c             	sub    $0xc,%esp
  8018ed:	68 40 e1 81 00       	push   $0x81e140
  8018f2:	e8 2a 28 00 00       	call   804121 <release_uspinlock>
  8018f7:	83 c4 10             	add    $0x10,%esp
					return (void*)allocblock->startva;
  8018fa:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8018fd:	8b 00                	mov    (%eax),%eax
  8018ff:	e9 6f 03 00 00       	jmp    801c73 <malloc+0x4fc>
			}else{
					release_uspinlock(&ulock);
  801904:	83 ec 0c             	sub    $0xc,%esp
  801907:	68 40 e1 81 00       	push   $0x81e140
  80190c:	e8 10 28 00 00       	call   804121 <release_uspinlock>
  801911:	83 c4 10             	add    $0x10,%esp
					return NULL;
  801914:	b8 00 00 00 00       	mov    $0x0,%eax
  801919:	e9 55 03 00 00       	jmp    801c73 <malloc+0x4fc>
				}
	}else{
		//custom fit
		struct UserHeapStruct* currentfreeelement = LIST_FIRST(&u_freelist);
  80191e:	a1 20 e1 81 00       	mov    0x81e120,%eax
  801923:	89 45 f4             	mov    %eax,-0xc(%ebp)
		//worst fit
		while(currentfreeelement != NULL){
  801926:	e9 39 03 00 00       	jmp    801c64 <malloc+0x4ed>
			if(size<currentfreeelement->size){
  80192b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80192e:	8b 40 04             	mov    0x4(%eax),%eax
  801931:	3b 45 08             	cmp    0x8(%ebp),%eax
  801934:	0f 86 e7 01 00 00    	jbe    801b21 <malloc+0x3aa>
				allocblock->startva = lastfreeelement->startva;
  80193a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80193d:	8b 10                	mov    (%eax),%edx
  80193f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801942:	89 10                	mov    %edx,(%eax)
                allocblock->size = size;
  801944:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801947:	8b 55 08             	mov    0x8(%ebp),%edx
  80194a:	89 50 04             	mov    %edx,0x4(%eax)
                LIST_INSERT_TAIL(&u_allocatedlist,allocblock);
  80194d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801951:	75 14                	jne    801967 <malloc+0x1f0>
  801953:	83 ec 04             	sub    $0x4,%esp
  801956:	68 98 4d 80 00       	push   $0x804d98
  80195b:	6a 72                	push   $0x72
  80195d:	68 4c 4d 80 00       	push   $0x804d4c
  801962:	e8 29 eb ff ff       	call   800490 <_panic>
  801967:	8b 15 34 e1 81 00    	mov    0x81e134,%edx
  80196d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801970:	89 50 0c             	mov    %edx,0xc(%eax)
  801973:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801976:	8b 40 0c             	mov    0xc(%eax),%eax
  801979:	85 c0                	test   %eax,%eax
  80197b:	74 0d                	je     80198a <malloc+0x213>
  80197d:	a1 34 e1 81 00       	mov    0x81e134,%eax
  801982:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801985:	89 50 08             	mov    %edx,0x8(%eax)
  801988:	eb 08                	jmp    801992 <malloc+0x21b>
  80198a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80198d:	a3 30 e1 81 00       	mov    %eax,0x81e130
  801992:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801995:	a3 34 e1 81 00       	mov    %eax,0x81e134
  80199a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80199d:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  8019a4:	a1 3c e1 81 00       	mov    0x81e13c,%eax
  8019a9:	40                   	inc    %eax
  8019aa:	a3 3c e1 81 00       	mov    %eax,0x81e13c
                lastfreeelement->startva += size;
  8019af:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8019b2:	8b 10                	mov    (%eax),%edx
  8019b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8019b7:	01 c2                	add    %eax,%edx
  8019b9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8019bc:	89 10                	mov    %edx,(%eax)
                lastfreeelement->size -= size;
  8019be:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8019c1:	8b 40 04             	mov    0x4(%eax),%eax
  8019c4:	2b 45 08             	sub    0x8(%ebp),%eax
  8019c7:	89 c2                	mov    %eax,%edx
  8019c9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8019cc:	89 50 04             	mov    %edx,0x4(%eax)
                struct UserHeapStruct* currentfree2 = LIST_FIRST(&u_freelist);
  8019cf:	a1 20 e1 81 00       	mov    0x81e120,%eax
  8019d4:	89 45 f0             	mov    %eax,-0x10(%ebp)
                //check order of last element

                while (currentfree2 != NULL){
  8019d7:	e9 0d 01 00 00       	jmp    801ae9 <malloc+0x372>
                	if(lastfreeelement->size <currentfree2->size){
  8019dc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8019df:	8b 50 04             	mov    0x4(%eax),%edx
  8019e2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019e5:	8b 40 04             	mov    0x4(%eax),%eax
  8019e8:	39 c2                	cmp    %eax,%edx
  8019ea:	0f 83 f0 00 00 00    	jae    801ae0 <malloc+0x369>
                		LIST_REMOVE(&u_freelist ,lastfreeelement);
  8019f0:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8019f4:	75 14                	jne    801a0a <malloc+0x293>
  8019f6:	83 ec 04             	sub    $0x4,%esp
  8019f9:	68 bb 4d 80 00       	push   $0x804dbb
  8019fe:	6a 7a                	push   $0x7a
  801a00:	68 4c 4d 80 00       	push   $0x804d4c
  801a05:	e8 86 ea ff ff       	call   800490 <_panic>
  801a0a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801a0d:	8b 40 08             	mov    0x8(%eax),%eax
  801a10:	85 c0                	test   %eax,%eax
  801a12:	74 11                	je     801a25 <malloc+0x2ae>
  801a14:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801a17:	8b 40 08             	mov    0x8(%eax),%eax
  801a1a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801a1d:	8b 52 0c             	mov    0xc(%edx),%edx
  801a20:	89 50 0c             	mov    %edx,0xc(%eax)
  801a23:	eb 0b                	jmp    801a30 <malloc+0x2b9>
  801a25:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801a28:	8b 40 0c             	mov    0xc(%eax),%eax
  801a2b:	a3 24 e1 81 00       	mov    %eax,0x81e124
  801a30:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801a33:	8b 40 0c             	mov    0xc(%eax),%eax
  801a36:	85 c0                	test   %eax,%eax
  801a38:	74 11                	je     801a4b <malloc+0x2d4>
  801a3a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801a3d:	8b 40 0c             	mov    0xc(%eax),%eax
  801a40:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801a43:	8b 52 08             	mov    0x8(%edx),%edx
  801a46:	89 50 08             	mov    %edx,0x8(%eax)
  801a49:	eb 0b                	jmp    801a56 <malloc+0x2df>
  801a4b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801a4e:	8b 40 08             	mov    0x8(%eax),%eax
  801a51:	a3 20 e1 81 00       	mov    %eax,0x81e120
  801a56:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801a59:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  801a60:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801a63:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  801a6a:	a1 2c e1 81 00       	mov    0x81e12c,%eax
  801a6f:	48                   	dec    %eax
  801a70:	a3 2c e1 81 00       	mov    %eax,0x81e12c
                		LIST_INSERT_BEFORE(&u_freelist ,currentfree2 ,lastfreeelement);
  801a75:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801a79:	74 06                	je     801a81 <malloc+0x30a>
  801a7b:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801a7f:	75 14                	jne    801a95 <malloc+0x31e>
  801a81:	83 ec 04             	sub    $0x4,%esp
  801a84:	68 dc 4d 80 00       	push   $0x804ddc
  801a89:	6a 7b                	push   $0x7b
  801a8b:	68 4c 4d 80 00       	push   $0x804d4c
  801a90:	e8 fb e9 ff ff       	call   800490 <_panic>
  801a95:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a98:	8b 50 0c             	mov    0xc(%eax),%edx
  801a9b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801a9e:	89 50 0c             	mov    %edx,0xc(%eax)
  801aa1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801aa4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801aa7:	89 50 08             	mov    %edx,0x8(%eax)
  801aaa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801aad:	8b 40 0c             	mov    0xc(%eax),%eax
  801ab0:	85 c0                	test   %eax,%eax
  801ab2:	74 0e                	je     801ac2 <malloc+0x34b>
  801ab4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ab7:	8b 40 0c             	mov    0xc(%eax),%eax
  801aba:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801abd:	89 50 08             	mov    %edx,0x8(%eax)
  801ac0:	eb 08                	jmp    801aca <malloc+0x353>
  801ac2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801ac5:	a3 20 e1 81 00       	mov    %eax,0x81e120
  801aca:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801acd:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801ad0:	89 50 0c             	mov    %edx,0xc(%eax)
  801ad3:	a1 2c e1 81 00       	mov    0x81e12c,%eax
  801ad8:	40                   	inc    %eax
  801ad9:	a3 2c e1 81 00       	mov    %eax,0x81e12c
                		break;
  801ade:	eb 13                	jmp    801af3 <malloc+0x37c>
                	}
                	currentfree2 = currentfree2->prev_next_info.le_next;
  801ae0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ae3:	8b 40 08             	mov    0x8(%eax),%eax
  801ae6:	89 45 f0             	mov    %eax,-0x10(%ebp)
                lastfreeelement->startva += size;
                lastfreeelement->size -= size;
                struct UserHeapStruct* currentfree2 = LIST_FIRST(&u_freelist);
                //check order of last element

                while (currentfree2 != NULL){
  801ae9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801aed:	0f 85 e9 fe ff ff    	jne    8019dc <malloc+0x265>
                	}
                	currentfree2 = currentfree2->prev_next_info.le_next;
                }


                sys_allocate_user_mem(allocblock->startva ,size);
  801af3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801af6:	8b 00                	mov    (%eax),%eax
  801af8:	83 ec 08             	sub    $0x8,%esp
  801afb:	ff 75 08             	pushl  0x8(%ebp)
  801afe:	50                   	push   %eax
  801aff:	e8 17 1a 00 00       	call   80351b <sys_allocate_user_mem>
  801b04:	83 c4 10             	add    $0x10,%esp
                release_uspinlock(&ulock);
  801b07:	83 ec 0c             	sub    $0xc,%esp
  801b0a:	68 40 e1 81 00       	push   $0x81e140
  801b0f:	e8 0d 26 00 00       	call   804121 <release_uspinlock>
  801b14:	83 c4 10             	add    $0x10,%esp
                return (void*)allocblock->startva;
  801b17:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801b1a:	8b 00                	mov    (%eax),%eax
  801b1c:	e9 52 01 00 00       	jmp    801c73 <malloc+0x4fc>
                //exact fit
			}else if(size == currentfreeelement->size){
  801b21:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b24:	8b 40 04             	mov    0x4(%eax),%eax
  801b27:	3b 45 08             	cmp    0x8(%ebp),%eax
  801b2a:	0f 85 2b 01 00 00    	jne    801c5b <malloc+0x4e4>
				allocblock->startva = currentfreeelement->startva;
  801b30:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b33:	8b 10                	mov    (%eax),%edx
  801b35:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801b38:	89 10                	mov    %edx,(%eax)
				allocblock->size = size;
  801b3a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801b3d:	8b 55 08             	mov    0x8(%ebp),%edx
  801b40:	89 50 04             	mov    %edx,0x4(%eax)
				LIST_INSERT_TAIL(&u_allocatedlist ,allocblock);
  801b43:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801b47:	75 17                	jne    801b60 <malloc+0x3e9>
  801b49:	83 ec 04             	sub    $0x4,%esp
  801b4c:	68 98 4d 80 00       	push   $0x804d98
  801b51:	68 89 00 00 00       	push   $0x89
  801b56:	68 4c 4d 80 00       	push   $0x804d4c
  801b5b:	e8 30 e9 ff ff       	call   800490 <_panic>
  801b60:	8b 15 34 e1 81 00    	mov    0x81e134,%edx
  801b66:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801b69:	89 50 0c             	mov    %edx,0xc(%eax)
  801b6c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801b6f:	8b 40 0c             	mov    0xc(%eax),%eax
  801b72:	85 c0                	test   %eax,%eax
  801b74:	74 0d                	je     801b83 <malloc+0x40c>
  801b76:	a1 34 e1 81 00       	mov    0x81e134,%eax
  801b7b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801b7e:	89 50 08             	mov    %edx,0x8(%eax)
  801b81:	eb 08                	jmp    801b8b <malloc+0x414>
  801b83:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801b86:	a3 30 e1 81 00       	mov    %eax,0x81e130
  801b8b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801b8e:	a3 34 e1 81 00       	mov    %eax,0x81e134
  801b93:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801b96:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  801b9d:	a1 3c e1 81 00       	mov    0x81e13c,%eax
  801ba2:	40                   	inc    %eax
  801ba3:	a3 3c e1 81 00       	mov    %eax,0x81e13c
				LIST_REMOVE(&u_freelist ,currentfreeelement);
  801ba8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801bac:	75 17                	jne    801bc5 <malloc+0x44e>
  801bae:	83 ec 04             	sub    $0x4,%esp
  801bb1:	68 bb 4d 80 00       	push   $0x804dbb
  801bb6:	68 8a 00 00 00       	push   $0x8a
  801bbb:	68 4c 4d 80 00       	push   $0x804d4c
  801bc0:	e8 cb e8 ff ff       	call   800490 <_panic>
  801bc5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bc8:	8b 40 08             	mov    0x8(%eax),%eax
  801bcb:	85 c0                	test   %eax,%eax
  801bcd:	74 11                	je     801be0 <malloc+0x469>
  801bcf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bd2:	8b 40 08             	mov    0x8(%eax),%eax
  801bd5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801bd8:	8b 52 0c             	mov    0xc(%edx),%edx
  801bdb:	89 50 0c             	mov    %edx,0xc(%eax)
  801bde:	eb 0b                	jmp    801beb <malloc+0x474>
  801be0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801be3:	8b 40 0c             	mov    0xc(%eax),%eax
  801be6:	a3 24 e1 81 00       	mov    %eax,0x81e124
  801beb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bee:	8b 40 0c             	mov    0xc(%eax),%eax
  801bf1:	85 c0                	test   %eax,%eax
  801bf3:	74 11                	je     801c06 <malloc+0x48f>
  801bf5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bf8:	8b 40 0c             	mov    0xc(%eax),%eax
  801bfb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801bfe:	8b 52 08             	mov    0x8(%edx),%edx
  801c01:	89 50 08             	mov    %edx,0x8(%eax)
  801c04:	eb 0b                	jmp    801c11 <malloc+0x49a>
  801c06:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c09:	8b 40 08             	mov    0x8(%eax),%eax
  801c0c:	a3 20 e1 81 00       	mov    %eax,0x81e120
  801c11:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c14:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  801c1b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c1e:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  801c25:	a1 2c e1 81 00       	mov    0x81e12c,%eax
  801c2a:	48                   	dec    %eax
  801c2b:	a3 2c e1 81 00       	mov    %eax,0x81e12c
				sys_allocate_user_mem(allocblock->startva ,size);
  801c30:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801c33:	8b 00                	mov    (%eax),%eax
  801c35:	83 ec 08             	sub    $0x8,%esp
  801c38:	ff 75 08             	pushl  0x8(%ebp)
  801c3b:	50                   	push   %eax
  801c3c:	e8 da 18 00 00       	call   80351b <sys_allocate_user_mem>
  801c41:	83 c4 10             	add    $0x10,%esp
				release_uspinlock(&ulock);
  801c44:	83 ec 0c             	sub    $0xc,%esp
  801c47:	68 40 e1 81 00       	push   $0x81e140
  801c4c:	e8 d0 24 00 00       	call   804121 <release_uspinlock>
  801c51:	83 c4 10             	add    $0x10,%esp
				return (void*)allocblock->startva;
  801c54:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801c57:	8b 00                	mov    (%eax),%eax
  801c59:	eb 18                	jmp    801c73 <malloc+0x4fc>
			}
			currentfreeelement = currentfreeelement->prev_next_info.le_next;
  801c5b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c5e:	8b 40 08             	mov    0x8(%eax),%eax
  801c61:	89 45 f4             	mov    %eax,-0xc(%ebp)
				}
	}else{
		//custom fit
		struct UserHeapStruct* currentfreeelement = LIST_FIRST(&u_freelist);
		//worst fit
		while(currentfreeelement != NULL){
  801c64:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801c68:	0f 85 bd fc ff ff    	jne    80192b <malloc+0x1b4>
				return (void*)allocblock->startva;
			}
			currentfreeelement = currentfreeelement->prev_next_info.le_next;
		}
	}
	 return NULL;
  801c6e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c73:	c9                   	leave  
  801c74:	c3                   	ret    

00801c75 <free>:

//=================================
// [2] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
  801c75:	55                   	push   %ebp
  801c76:	89 e5                	mov    %esp,%ebp
  801c78:	83 ec 38             	sub    $0x38,%esp
	uint32  VA = ROUNDDOWN(((uint32 ) virtual_address), PAGE_SIZE);
  801c7b:	8b 45 08             	mov    0x8(%ebp),%eax
  801c7e:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801c81:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801c84:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801c89:	89 45 d8             	mov    %eax,-0x28(%ebp)


		uheap_init();
  801c8c:	e8 b2 f9 ff ff       	call   801643 <uheap_init>
		acquire_uspinlock(&ulock);
  801c91:	83 ec 0c             	sub    $0xc,%esp
  801c94:	68 40 e1 81 00       	push   $0x81e140
  801c99:	e8 2b 24 00 00       	call   8040c9 <acquire_uspinlock>
  801c9e:	83 c4 10             	add    $0x10,%esp
		if (VA < uheapPageAllocStart){
  801ca1:	a1 10 e1 81 00       	mov    0x81e110,%eax
  801ca6:	39 45 d8             	cmp    %eax,-0x28(%ebp)
  801ca9:	73 23                	jae    801cce <free+0x59>
			free_block(virtual_address);
  801cab:	83 ec 0c             	sub    $0xc,%esp
  801cae:	ff 75 08             	pushl  0x8(%ebp)
  801cb1:	e8 89 1f 00 00       	call   803c3f <free_block>
  801cb6:	83 c4 10             	add    $0x10,%esp
			release_uspinlock(&ulock);
  801cb9:	83 ec 0c             	sub    $0xc,%esp
  801cbc:	68 40 e1 81 00       	push   $0x81e140
  801cc1:	e8 5b 24 00 00       	call   804121 <release_uspinlock>
  801cc6:	83 c4 10             	add    $0x10,%esp
			return;
  801cc9:	e9 35 07 00 00       	jmp    802403 <free+0x78e>
		}
		if (VA >= uheapPageAllocBreak){
  801cce:	a1 68 e0 81 00       	mov    0x81e068,%eax
  801cd3:	39 45 d8             	cmp    %eax,-0x28(%ebp)
  801cd6:	72 30                	jb     801d08 <free+0x93>
			cprintf("%d\n %d\n", VA, uheapPageAllocBreak);
  801cd8:	a1 68 e0 81 00       	mov    0x81e068,%eax
  801cdd:	83 ec 04             	sub    $0x4,%esp
  801ce0:	50                   	push   %eax
  801ce1:	ff 75 d8             	pushl  -0x28(%ebp)
  801ce4:	68 11 4e 80 00       	push   $0x804e11
  801ce9:	e8 70 ea ff ff       	call   80075e <cprintf>
  801cee:	83 c4 10             	add    $0x10,%esp

			panic("freeing from restricted area");
  801cf1:	83 ec 04             	sub    $0x4,%esp
  801cf4:	68 19 4e 80 00       	push   $0x804e19
  801cf9:	68 a7 00 00 00       	push   $0xa7
  801cfe:	68 4c 4d 80 00       	push   $0x804d4c
  801d03:	e8 88 e7 ff ff       	call   800490 <_panic>
			release_uspinlock(&ulock);
			return;
		}

		struct UserHeapStruct* newfree = (struct UserHeapStruct*) alloc_block(sizeof(struct UserHeapStruct));
  801d08:	83 ec 0c             	sub    $0xc,%esp
  801d0b:	6a 10                	push   $0x10
  801d0d:	e8 91 1a 00 00       	call   8037a3 <alloc_block>
  801d12:	83 c4 10             	add    $0x10,%esp
  801d15:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		struct UserHeapStruct* MergedBlock  = ( struct UserHeapStruct*)alloc_block(sizeof(struct UserHeapStruct));
  801d18:	83 ec 0c             	sub    $0xc,%esp
  801d1b:	6a 10                	push   $0x10
  801d1d:	e8 81 1a 00 00       	call   8037a3 <alloc_block>
  801d22:	83 c4 10             	add    $0x10,%esp
  801d25:	89 45 d0             	mov    %eax,-0x30(%ebp)

		struct UserHeapStruct* ToBefreed = LIST_FIRST(&u_allocatedlist);
  801d28:	a1 30 e1 81 00       	mov    0x81e130,%eax
  801d2d:	89 45 f4             	mov    %eax,-0xc(%ebp)
		bool foundVA = 0;
  801d30:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

		//find the allocated block
		while(ToBefreed !=NULL ){
  801d37:	eb 1c                	jmp    801d55 <free+0xe0>

			if (VA ==ToBefreed->startva ){
  801d39:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d3c:	8b 00                	mov    (%eax),%eax
  801d3e:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  801d41:	75 09                	jne    801d4c <free+0xd7>
				foundVA = 1;
  801d43:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
				break;
  801d4a:	eb 0f                	jmp    801d5b <free+0xe6>
			}
				ToBefreed = ToBefreed->prev_next_info.le_next;
  801d4c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d4f:	8b 40 08             	mov    0x8(%eax),%eax
  801d52:	89 45 f4             	mov    %eax,-0xc(%ebp)

		struct UserHeapStruct* ToBefreed = LIST_FIRST(&u_allocatedlist);
		bool foundVA = 0;

		//find the allocated block
		while(ToBefreed !=NULL ){
  801d55:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801d59:	75 de                	jne    801d39 <free+0xc4>
			}
				ToBefreed = ToBefreed->prev_next_info.le_next;
		}


		if(!foundVA){
  801d5b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801d5f:	75 17                	jne    801d78 <free+0x103>
				panic("INVALID ADDRESS!");
  801d61:	83 ec 04             	sub    $0x4,%esp
  801d64:	68 36 4e 80 00       	push   $0x804e36
  801d69:	68 be 00 00 00       	push   $0xbe
  801d6e:	68 4c 4d 80 00       	push   $0x804d4c
  801d73:	e8 18 e7 ff ff       	call   800490 <_panic>
				release_uspinlock(&ulock);
				return;
			}


		newfree->startva = ToBefreed->startva;
  801d78:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d7b:	8b 10                	mov    (%eax),%edx
  801d7d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801d80:	89 10                	mov    %edx,(%eax)
		newfree->size = ToBefreed->size;
  801d82:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d85:	8b 50 04             	mov    0x4(%eax),%edx
  801d88:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801d8b:	89 50 04             	mov    %edx,0x4(%eax)

		//remove allocated block from alloclist
		LIST_REMOVE(&u_allocatedlist, ToBefreed);
  801d8e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801d92:	75 17                	jne    801dab <free+0x136>
  801d94:	83 ec 04             	sub    $0x4,%esp
  801d97:	68 bb 4d 80 00       	push   $0x804dbb
  801d9c:	68 c8 00 00 00       	push   $0xc8
  801da1:	68 4c 4d 80 00       	push   $0x804d4c
  801da6:	e8 e5 e6 ff ff       	call   800490 <_panic>
  801dab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dae:	8b 40 08             	mov    0x8(%eax),%eax
  801db1:	85 c0                	test   %eax,%eax
  801db3:	74 11                	je     801dc6 <free+0x151>
  801db5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801db8:	8b 40 08             	mov    0x8(%eax),%eax
  801dbb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801dbe:	8b 52 0c             	mov    0xc(%edx),%edx
  801dc1:	89 50 0c             	mov    %edx,0xc(%eax)
  801dc4:	eb 0b                	jmp    801dd1 <free+0x15c>
  801dc6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dc9:	8b 40 0c             	mov    0xc(%eax),%eax
  801dcc:	a3 34 e1 81 00       	mov    %eax,0x81e134
  801dd1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dd4:	8b 40 0c             	mov    0xc(%eax),%eax
  801dd7:	85 c0                	test   %eax,%eax
  801dd9:	74 11                	je     801dec <free+0x177>
  801ddb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dde:	8b 40 0c             	mov    0xc(%eax),%eax
  801de1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801de4:	8b 52 08             	mov    0x8(%edx),%edx
  801de7:	89 50 08             	mov    %edx,0x8(%eax)
  801dea:	eb 0b                	jmp    801df7 <free+0x182>
  801dec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801def:	8b 40 08             	mov    0x8(%eax),%eax
  801df2:	a3 30 e1 81 00       	mov    %eax,0x81e130
  801df7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dfa:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  801e01:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e04:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  801e0b:	a1 3c e1 81 00       	mov    0x81e13c,%eax
  801e10:	48                   	dec    %eax
  801e11:	a3 3c e1 81 00       	mov    %eax,0x81e13c

		sys_free_user_mem(ToBefreed->startva, ToBefreed->size);
  801e16:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e19:	8b 50 04             	mov    0x4(%eax),%edx
  801e1c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e1f:	8b 00                	mov    (%eax),%eax
  801e21:	83 ec 08             	sub    $0x8,%esp
  801e24:	52                   	push   %edx
  801e25:	50                   	push   %eax
  801e26:	e8 d4 16 00 00       	call   8034ff <sys_free_user_mem>
  801e2b:	83 c4 10             	add    $0x10,%esp




		if(LIST_SIZE(&u_freelist) == 0){
  801e2e:	a1 2c e1 81 00       	mov    0x81e12c,%eax
  801e33:	85 c0                	test   %eax,%eax
  801e35:	75 7a                	jne    801eb1 <free+0x23c>
			LIST_INSERT_HEAD(&u_freelist,newfree);
  801e37:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  801e3b:	75 17                	jne    801e54 <free+0x1df>
  801e3d:	83 ec 04             	sub    $0x4,%esp
  801e40:	68 48 4e 80 00       	push   $0x804e48
  801e45:	68 d0 00 00 00       	push   $0xd0
  801e4a:	68 4c 4d 80 00       	push   $0x804d4c
  801e4f:	e8 3c e6 ff ff       	call   800490 <_panic>
  801e54:	8b 15 20 e1 81 00    	mov    0x81e120,%edx
  801e5a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801e5d:	89 50 08             	mov    %edx,0x8(%eax)
  801e60:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801e63:	8b 40 08             	mov    0x8(%eax),%eax
  801e66:	85 c0                	test   %eax,%eax
  801e68:	74 0d                	je     801e77 <free+0x202>
  801e6a:	a1 20 e1 81 00       	mov    0x81e120,%eax
  801e6f:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  801e72:	89 50 0c             	mov    %edx,0xc(%eax)
  801e75:	eb 08                	jmp    801e7f <free+0x20a>
  801e77:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801e7a:	a3 24 e1 81 00       	mov    %eax,0x81e124
  801e7f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801e82:	a3 20 e1 81 00       	mov    %eax,0x81e120
  801e87:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801e8a:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  801e91:	a1 2c e1 81 00       	mov    0x81e12c,%eax
  801e96:	40                   	inc    %eax
  801e97:	a3 2c e1 81 00       	mov    %eax,0x81e12c
			release_uspinlock(&ulock);
  801e9c:	83 ec 0c             	sub    $0xc,%esp
  801e9f:	68 40 e1 81 00       	push   $0x81e140
  801ea4:	e8 78 22 00 00       	call   804121 <release_uspinlock>
  801ea9:	83 c4 10             	add    $0x10,%esp
			return;
  801eac:	e9 52 05 00 00       	jmp    802403 <free+0x78e>
		}


		struct UserHeapStruct* ToBeMerged = LIST_FIRST(&u_freelist);
  801eb1:	a1 20 e1 81 00       	mov    0x81e120,%eax
  801eb6:	89 45 ec             	mov    %eax,-0x14(%ebp)
		// merge with prev if possible
		bool mergeprev = 0;
  801eb9:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		bool mergenext = 0;
  801ec0:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
		while(ToBeMerged != NULL){
  801ec7:	e9 d2 00 00 00       	jmp    801f9e <free+0x329>
			if((ToBeMerged->startva +ToBeMerged->size) == newfree->startva){
  801ecc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801ecf:	8b 10                	mov    (%eax),%edx
  801ed1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801ed4:	8b 40 04             	mov    0x4(%eax),%eax
  801ed7:	01 c2                	add    %eax,%edx
  801ed9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801edc:	8b 00                	mov    (%eax),%eax
  801ede:	39 c2                	cmp    %eax,%edx
  801ee0:	0f 85 af 00 00 00    	jne    801f95 <free+0x320>

				MergedBlock->startva = ToBeMerged->startva;
  801ee6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801ee9:	8b 10                	mov    (%eax),%edx
  801eeb:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801eee:	89 10                	mov    %edx,(%eax)
				MergedBlock->size = ToBeMerged->size + newfree->size;
  801ef0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801ef3:	8b 50 04             	mov    0x4(%eax),%edx
  801ef6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801ef9:	8b 40 04             	mov    0x4(%eax),%eax
  801efc:	01 c2                	add    %eax,%edx
  801efe:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801f01:	89 50 04             	mov    %edx,0x4(%eax)
				LIST_REMOVE(&u_freelist, ToBeMerged);
  801f04:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801f08:	75 17                	jne    801f21 <free+0x2ac>
  801f0a:	83 ec 04             	sub    $0x4,%esp
  801f0d:	68 bb 4d 80 00       	push   $0x804dbb
  801f12:	68 df 00 00 00       	push   $0xdf
  801f17:	68 4c 4d 80 00       	push   $0x804d4c
  801f1c:	e8 6f e5 ff ff       	call   800490 <_panic>
  801f21:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f24:	8b 40 08             	mov    0x8(%eax),%eax
  801f27:	85 c0                	test   %eax,%eax
  801f29:	74 11                	je     801f3c <free+0x2c7>
  801f2b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f2e:	8b 40 08             	mov    0x8(%eax),%eax
  801f31:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801f34:	8b 52 0c             	mov    0xc(%edx),%edx
  801f37:	89 50 0c             	mov    %edx,0xc(%eax)
  801f3a:	eb 0b                	jmp    801f47 <free+0x2d2>
  801f3c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f3f:	8b 40 0c             	mov    0xc(%eax),%eax
  801f42:	a3 24 e1 81 00       	mov    %eax,0x81e124
  801f47:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f4a:	8b 40 0c             	mov    0xc(%eax),%eax
  801f4d:	85 c0                	test   %eax,%eax
  801f4f:	74 11                	je     801f62 <free+0x2ed>
  801f51:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f54:	8b 40 0c             	mov    0xc(%eax),%eax
  801f57:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801f5a:	8b 52 08             	mov    0x8(%edx),%edx
  801f5d:	89 50 08             	mov    %edx,0x8(%eax)
  801f60:	eb 0b                	jmp    801f6d <free+0x2f8>
  801f62:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f65:	8b 40 08             	mov    0x8(%eax),%eax
  801f68:	a3 20 e1 81 00       	mov    %eax,0x81e120
  801f6d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f70:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  801f77:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f7a:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  801f81:	a1 2c e1 81 00       	mov    0x81e12c,%eax
  801f86:	48                   	dec    %eax
  801f87:	a3 2c e1 81 00       	mov    %eax,0x81e12c
				mergeprev = 1;
  801f8c:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
				break;
  801f93:	eb 13                	jmp    801fa8 <free+0x333>
			}
				ToBeMerged = ToBeMerged->prev_next_info.le_next;
  801f95:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f98:	8b 40 08             	mov    0x8(%eax),%eax
  801f9b:	89 45 ec             	mov    %eax,-0x14(%ebp)

		struct UserHeapStruct* ToBeMerged = LIST_FIRST(&u_freelist);
		// merge with prev if possible
		bool mergeprev = 0;
		bool mergenext = 0;
		while(ToBeMerged != NULL){
  801f9e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801fa2:	0f 85 24 ff ff ff    	jne    801ecc <free+0x257>
//									uheapPageAllocBreak = newfree->startva;
//						}
//					}


		if ( newfree ->startva + newfree->size == uheapPageAllocBreak){
  801fa8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801fab:	8b 10                	mov    (%eax),%edx
  801fad:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801fb0:	8b 40 04             	mov    0x4(%eax),%eax
  801fb3:	01 c2                	add    %eax,%edx
  801fb5:	a1 68 e0 81 00       	mov    0x81e068,%eax
  801fba:	39 c2                	cmp    %eax,%edx
  801fbc:	75 44                	jne    802002 <free+0x38d>

			if(mergeprev){
  801fbe:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  801fc2:	74 1f                	je     801fe3 <free+0x36e>
				uheapPageAllocBreak = MergedBlock->startva;
  801fc4:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801fc7:	8b 00                	mov    (%eax),%eax
  801fc9:	a3 68 e0 81 00       	mov    %eax,0x81e068
				release_uspinlock(&ulock);
  801fce:	83 ec 0c             	sub    $0xc,%esp
  801fd1:	68 40 e1 81 00       	push   $0x81e140
  801fd6:	e8 46 21 00 00       	call   804121 <release_uspinlock>
  801fdb:	83 c4 10             	add    $0x10,%esp
				return;
  801fde:	e9 20 04 00 00       	jmp    802403 <free+0x78e>

			}else{
				uheapPageAllocBreak = newfree->startva;
  801fe3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801fe6:	8b 00                	mov    (%eax),%eax
  801fe8:	a3 68 e0 81 00       	mov    %eax,0x81e068
				release_uspinlock(&ulock);
  801fed:	83 ec 0c             	sub    $0xc,%esp
  801ff0:	68 40 e1 81 00       	push   $0x81e140
  801ff5:	e8 27 21 00 00       	call   804121 <release_uspinlock>
  801ffa:	83 c4 10             	add    $0x10,%esp
				return;
  801ffd:	e9 01 04 00 00       	jmp    802403 <free+0x78e>

		}


		//check if block is merged with prev ,and find possible merge with next
		ToBeMerged = LIST_FIRST(&u_freelist);
  802002:	a1 20 e1 81 00       	mov    0x81e120,%eax
  802007:	89 45 ec             	mov    %eax,-0x14(%ebp)
		while(ToBeMerged != NULL){
  80200a:	e9 7d 01 00 00       	jmp    80218c <free+0x517>
			if ((newfree->startva + newfree->size) == ToBeMerged->startva ){
  80200f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802012:	8b 10                	mov    (%eax),%edx
  802014:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802017:	8b 40 04             	mov    0x4(%eax),%eax
  80201a:	01 c2                	add    %eax,%edx
  80201c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80201f:	8b 00                	mov    (%eax),%eax
  802021:	39 c2                	cmp    %eax,%edx
  802023:	0f 85 5a 01 00 00    	jne    802183 <free+0x50e>
				if (mergeprev){
  802029:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80202d:	0f 84 a1 00 00 00    	je     8020d4 <free+0x45f>
					MergedBlock->size += ToBeMerged->size;
  802033:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802036:	8b 50 04             	mov    0x4(%eax),%edx
  802039:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80203c:	8b 40 04             	mov    0x4(%eax),%eax
  80203f:	01 c2                	add    %eax,%edx
  802041:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802044:	89 50 04             	mov    %edx,0x4(%eax)
					LIST_REMOVE(&u_freelist, ToBeMerged);
  802047:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80204b:	75 17                	jne    802064 <free+0x3ef>
  80204d:	83 ec 04             	sub    $0x4,%esp
  802050:	68 bb 4d 80 00       	push   $0x804dbb
  802055:	68 0a 01 00 00       	push   $0x10a
  80205a:	68 4c 4d 80 00       	push   $0x804d4c
  80205f:	e8 2c e4 ff ff       	call   800490 <_panic>
  802064:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802067:	8b 40 08             	mov    0x8(%eax),%eax
  80206a:	85 c0                	test   %eax,%eax
  80206c:	74 11                	je     80207f <free+0x40a>
  80206e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802071:	8b 40 08             	mov    0x8(%eax),%eax
  802074:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802077:	8b 52 0c             	mov    0xc(%edx),%edx
  80207a:	89 50 0c             	mov    %edx,0xc(%eax)
  80207d:	eb 0b                	jmp    80208a <free+0x415>
  80207f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802082:	8b 40 0c             	mov    0xc(%eax),%eax
  802085:	a3 24 e1 81 00       	mov    %eax,0x81e124
  80208a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80208d:	8b 40 0c             	mov    0xc(%eax),%eax
  802090:	85 c0                	test   %eax,%eax
  802092:	74 11                	je     8020a5 <free+0x430>
  802094:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802097:	8b 40 0c             	mov    0xc(%eax),%eax
  80209a:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80209d:	8b 52 08             	mov    0x8(%edx),%edx
  8020a0:	89 50 08             	mov    %edx,0x8(%eax)
  8020a3:	eb 0b                	jmp    8020b0 <free+0x43b>
  8020a5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8020a8:	8b 40 08             	mov    0x8(%eax),%eax
  8020ab:	a3 20 e1 81 00       	mov    %eax,0x81e120
  8020b0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8020b3:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  8020ba:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8020bd:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  8020c4:	a1 2c e1 81 00       	mov    0x81e12c,%eax
  8020c9:	48                   	dec    %eax
  8020ca:	a3 2c e1 81 00       	mov    %eax,0x81e12c
					break;
  8020cf:	e9 c2 00 00 00       	jmp    802196 <free+0x521>
		//if not merged find possible merge with next
				}else{
					MergedBlock->startva = newfree->startva;
  8020d4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8020d7:	8b 10                	mov    (%eax),%edx
  8020d9:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8020dc:	89 10                	mov    %edx,(%eax)
					MergedBlock->size  = newfree->size + ToBeMerged->size;
  8020de:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8020e1:	8b 50 04             	mov    0x4(%eax),%edx
  8020e4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8020e7:	8b 40 04             	mov    0x4(%eax),%eax
  8020ea:	01 c2                	add    %eax,%edx
  8020ec:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8020ef:	89 50 04             	mov    %edx,0x4(%eax)
					LIST_REMOVE(&u_freelist, ToBeMerged);
  8020f2:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8020f6:	75 17                	jne    80210f <free+0x49a>
  8020f8:	83 ec 04             	sub    $0x4,%esp
  8020fb:	68 bb 4d 80 00       	push   $0x804dbb
  802100:	68 10 01 00 00       	push   $0x110
  802105:	68 4c 4d 80 00       	push   $0x804d4c
  80210a:	e8 81 e3 ff ff       	call   800490 <_panic>
  80210f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802112:	8b 40 08             	mov    0x8(%eax),%eax
  802115:	85 c0                	test   %eax,%eax
  802117:	74 11                	je     80212a <free+0x4b5>
  802119:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80211c:	8b 40 08             	mov    0x8(%eax),%eax
  80211f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802122:	8b 52 0c             	mov    0xc(%edx),%edx
  802125:	89 50 0c             	mov    %edx,0xc(%eax)
  802128:	eb 0b                	jmp    802135 <free+0x4c0>
  80212a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80212d:	8b 40 0c             	mov    0xc(%eax),%eax
  802130:	a3 24 e1 81 00       	mov    %eax,0x81e124
  802135:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802138:	8b 40 0c             	mov    0xc(%eax),%eax
  80213b:	85 c0                	test   %eax,%eax
  80213d:	74 11                	je     802150 <free+0x4db>
  80213f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802142:	8b 40 0c             	mov    0xc(%eax),%eax
  802145:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802148:	8b 52 08             	mov    0x8(%edx),%edx
  80214b:	89 50 08             	mov    %edx,0x8(%eax)
  80214e:	eb 0b                	jmp    80215b <free+0x4e6>
  802150:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802153:	8b 40 08             	mov    0x8(%eax),%eax
  802156:	a3 20 e1 81 00       	mov    %eax,0x81e120
  80215b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80215e:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802165:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802168:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  80216f:	a1 2c e1 81 00       	mov    0x81e12c,%eax
  802174:	48                   	dec    %eax
  802175:	a3 2c e1 81 00       	mov    %eax,0x81e12c
					mergenext = 1;
  80217a:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
					break;
  802181:	eb 13                	jmp    802196 <free+0x521>
				}
			}
			ToBeMerged = ToBeMerged->prev_next_info.le_next;
  802183:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802186:	8b 40 08             	mov    0x8(%eax),%eax
  802189:	89 45 ec             	mov    %eax,-0x14(%ebp)
		}


		//check if block is merged with prev ,and find possible merge with next
		ToBeMerged = LIST_FIRST(&u_freelist);
		while(ToBeMerged != NULL){
  80218c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802190:	0f 85 79 fe ff ff    	jne    80200f <free+0x39a>




			// insertion
			struct UserHeapStruct* currentfree = LIST_FIRST(&u_freelist);
  802196:	a1 20 e1 81 00       	mov    0x81e120,%eax
  80219b:	89 45 e0             	mov    %eax,-0x20(%ebp)

			if(mergeprev || mergenext){
  80219e:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8021a2:	0f 85 ad 00 00 00    	jne    802255 <free+0x5e0>
  8021a8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8021ac:	0f 84 c3 01 00 00    	je     802375 <free+0x700>
				while(currentfree != NULL){
  8021b2:	e9 9e 00 00 00       	jmp    802255 <free+0x5e0>
					if(MergedBlock->size < currentfree->size){
  8021b7:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8021ba:	8b 50 04             	mov    0x4(%eax),%edx
  8021bd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8021c0:	8b 40 04             	mov    0x4(%eax),%eax
  8021c3:	39 c2                	cmp    %eax,%edx
  8021c5:	0f 83 81 00 00 00    	jae    80224c <free+0x5d7>

							LIST_INSERT_BEFORE(&u_freelist,currentfree,MergedBlock);
  8021cb:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8021cf:	74 06                	je     8021d7 <free+0x562>
  8021d1:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  8021d5:	75 17                	jne    8021ee <free+0x579>
  8021d7:	83 ec 04             	sub    $0x4,%esp
  8021da:	68 dc 4d 80 00       	push   $0x804ddc
  8021df:	68 23 01 00 00       	push   $0x123
  8021e4:	68 4c 4d 80 00       	push   $0x804d4c
  8021e9:	e8 a2 e2 ff ff       	call   800490 <_panic>
  8021ee:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8021f1:	8b 50 0c             	mov    0xc(%eax),%edx
  8021f4:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8021f7:	89 50 0c             	mov    %edx,0xc(%eax)
  8021fa:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8021fd:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802200:	89 50 08             	mov    %edx,0x8(%eax)
  802203:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802206:	8b 40 0c             	mov    0xc(%eax),%eax
  802209:	85 c0                	test   %eax,%eax
  80220b:	74 0e                	je     80221b <free+0x5a6>
  80220d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802210:	8b 40 0c             	mov    0xc(%eax),%eax
  802213:	8b 55 d0             	mov    -0x30(%ebp),%edx
  802216:	89 50 08             	mov    %edx,0x8(%eax)
  802219:	eb 08                	jmp    802223 <free+0x5ae>
  80221b:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80221e:	a3 20 e1 81 00       	mov    %eax,0x81e120
  802223:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802226:	8b 55 d0             	mov    -0x30(%ebp),%edx
  802229:	89 50 0c             	mov    %edx,0xc(%eax)
  80222c:	a1 2c e1 81 00       	mov    0x81e12c,%eax
  802231:	40                   	inc    %eax
  802232:	a3 2c e1 81 00       	mov    %eax,0x81e12c
							release_uspinlock(&ulock);
  802237:	83 ec 0c             	sub    $0xc,%esp
  80223a:	68 40 e1 81 00       	push   $0x81e140
  80223f:	e8 dd 1e 00 00       	call   804121 <release_uspinlock>
  802244:	83 c4 10             	add    $0x10,%esp
							return;
  802247:	e9 b7 01 00 00       	jmp    802403 <free+0x78e>
					}
							currentfree = currentfree->prev_next_info.le_next;
  80224c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80224f:	8b 40 08             	mov    0x8(%eax),%eax
  802252:	89 45 e0             	mov    %eax,-0x20(%ebp)

			// insertion
			struct UserHeapStruct* currentfree = LIST_FIRST(&u_freelist);

			if(mergeprev || mergenext){
				while(currentfree != NULL){
  802255:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802259:	0f 85 58 ff ff ff    	jne    8021b7 <free+0x542>
							release_uspinlock(&ulock);
							return;
					}
							currentfree = currentfree->prev_next_info.le_next;
				}
				free_block(newfree);
  80225f:	83 ec 0c             	sub    $0xc,%esp
  802262:	ff 75 d4             	pushl  -0x2c(%ebp)
  802265:	e8 d5 19 00 00       	call   803c3f <free_block>
  80226a:	83 c4 10             	add    $0x10,%esp
				LIST_INSERT_TAIL(&u_freelist,MergedBlock);
  80226d:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  802271:	75 17                	jne    80228a <free+0x615>
  802273:	83 ec 04             	sub    $0x4,%esp
  802276:	68 98 4d 80 00       	push   $0x804d98
  80227b:	68 2a 01 00 00       	push   $0x12a
  802280:	68 4c 4d 80 00       	push   $0x804d4c
  802285:	e8 06 e2 ff ff       	call   800490 <_panic>
  80228a:	8b 15 24 e1 81 00    	mov    0x81e124,%edx
  802290:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802293:	89 50 0c             	mov    %edx,0xc(%eax)
  802296:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802299:	8b 40 0c             	mov    0xc(%eax),%eax
  80229c:	85 c0                	test   %eax,%eax
  80229e:	74 0d                	je     8022ad <free+0x638>
  8022a0:	a1 24 e1 81 00       	mov    0x81e124,%eax
  8022a5:	8b 55 d0             	mov    -0x30(%ebp),%edx
  8022a8:	89 50 08             	mov    %edx,0x8(%eax)
  8022ab:	eb 08                	jmp    8022b5 <free+0x640>
  8022ad:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8022b0:	a3 20 e1 81 00       	mov    %eax,0x81e120
  8022b5:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8022b8:	a3 24 e1 81 00       	mov    %eax,0x81e124
  8022bd:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8022c0:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  8022c7:	a1 2c e1 81 00       	mov    0x81e12c,%eax
  8022cc:	40                   	inc    %eax
  8022cd:	a3 2c e1 81 00       	mov    %eax,0x81e12c
  8022d2:	e9 1b 01 00 00       	jmp    8023f2 <free+0x77d>

			}else{
				while(currentfree != NULL){
					if(newfree->size < currentfree->size){
  8022d7:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8022da:	8b 50 04             	mov    0x4(%eax),%edx
  8022dd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8022e0:	8b 40 04             	mov    0x4(%eax),%eax
  8022e3:	39 c2                	cmp    %eax,%edx
  8022e5:	0f 83 81 00 00 00    	jae    80236c <free+0x6f7>

							LIST_INSERT_BEFORE(&u_freelist,currentfree,newfree);
  8022eb:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8022ef:	74 06                	je     8022f7 <free+0x682>
  8022f1:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8022f5:	75 17                	jne    80230e <free+0x699>
  8022f7:	83 ec 04             	sub    $0x4,%esp
  8022fa:	68 dc 4d 80 00       	push   $0x804ddc
  8022ff:	68 30 01 00 00       	push   $0x130
  802304:	68 4c 4d 80 00       	push   $0x804d4c
  802309:	e8 82 e1 ff ff       	call   800490 <_panic>
  80230e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802311:	8b 50 0c             	mov    0xc(%eax),%edx
  802314:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802317:	89 50 0c             	mov    %edx,0xc(%eax)
  80231a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80231d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802320:	89 50 08             	mov    %edx,0x8(%eax)
  802323:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802326:	8b 40 0c             	mov    0xc(%eax),%eax
  802329:	85 c0                	test   %eax,%eax
  80232b:	74 0e                	je     80233b <free+0x6c6>
  80232d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802330:	8b 40 0c             	mov    0xc(%eax),%eax
  802333:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802336:	89 50 08             	mov    %edx,0x8(%eax)
  802339:	eb 08                	jmp    802343 <free+0x6ce>
  80233b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80233e:	a3 20 e1 81 00       	mov    %eax,0x81e120
  802343:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802346:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802349:	89 50 0c             	mov    %edx,0xc(%eax)
  80234c:	a1 2c e1 81 00       	mov    0x81e12c,%eax
  802351:	40                   	inc    %eax
  802352:	a3 2c e1 81 00       	mov    %eax,0x81e12c
							release_uspinlock(&ulock);
  802357:	83 ec 0c             	sub    $0xc,%esp
  80235a:	68 40 e1 81 00       	push   $0x81e140
  80235f:	e8 bd 1d 00 00       	call   804121 <release_uspinlock>
  802364:	83 c4 10             	add    $0x10,%esp
							return;
  802367:	e9 97 00 00 00       	jmp    802403 <free+0x78e>
					}
							currentfree = currentfree->prev_next_info.le_next;
  80236c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80236f:	8b 40 08             	mov    0x8(%eax),%eax
  802372:	89 45 e0             	mov    %eax,-0x20(%ebp)
				}
				free_block(newfree);
				LIST_INSERT_TAIL(&u_freelist,MergedBlock);

			}else{
				while(currentfree != NULL){
  802375:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802379:	0f 85 58 ff ff ff    	jne    8022d7 <free+0x662>
							release_uspinlock(&ulock);
							return;
					}
							currentfree = currentfree->prev_next_info.le_next;
				}
				free_block(MergedBlock);
  80237f:	83 ec 0c             	sub    $0xc,%esp
  802382:	ff 75 d0             	pushl  -0x30(%ebp)
  802385:	e8 b5 18 00 00       	call   803c3f <free_block>
  80238a:	83 c4 10             	add    $0x10,%esp
				LIST_INSERT_TAIL(&u_freelist,newfree);
  80238d:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  802391:	75 17                	jne    8023aa <free+0x735>
  802393:	83 ec 04             	sub    $0x4,%esp
  802396:	68 98 4d 80 00       	push   $0x804d98
  80239b:	68 37 01 00 00       	push   $0x137
  8023a0:	68 4c 4d 80 00       	push   $0x804d4c
  8023a5:	e8 e6 e0 ff ff       	call   800490 <_panic>
  8023aa:	8b 15 24 e1 81 00    	mov    0x81e124,%edx
  8023b0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8023b3:	89 50 0c             	mov    %edx,0xc(%eax)
  8023b6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8023b9:	8b 40 0c             	mov    0xc(%eax),%eax
  8023bc:	85 c0                	test   %eax,%eax
  8023be:	74 0d                	je     8023cd <free+0x758>
  8023c0:	a1 24 e1 81 00       	mov    0x81e124,%eax
  8023c5:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8023c8:	89 50 08             	mov    %edx,0x8(%eax)
  8023cb:	eb 08                	jmp    8023d5 <free+0x760>
  8023cd:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8023d0:	a3 20 e1 81 00       	mov    %eax,0x81e120
  8023d5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8023d8:	a3 24 e1 81 00       	mov    %eax,0x81e124
  8023dd:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8023e0:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  8023e7:	a1 2c e1 81 00       	mov    0x81e12c,%eax
  8023ec:	40                   	inc    %eax
  8023ed:	a3 2c e1 81 00       	mov    %eax,0x81e12c
			}
		release_uspinlock(&ulock);
  8023f2:	83 ec 0c             	sub    $0xc,%esp
  8023f5:	68 40 e1 81 00       	push   $0x81e140
  8023fa:	e8 22 1d 00 00       	call   804121 <release_uspinlock>
  8023ff:	83 c4 10             	add    $0x10,%esp
		return;
  802402:	90                   	nop
}
  802403:	c9                   	leave  
  802404:	c3                   	ret    

00802405 <smalloc>:

//=================================
// [3] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  802405:	55                   	push   %ebp
  802406:	89 e5                	mov    %esp,%ebp
  802408:	83 ec 48             	sub    $0x48,%esp
  80240b:	8b 45 10             	mov    0x10(%ebp),%eax
  80240e:	88 45 c4             	mov    %al,-0x3c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  802411:	e8 2d f2 ff ff       	call   801643 <uheap_init>
	if (size == 0) return NULL;
  802416:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80241a:	75 0a                	jne    802426 <smalloc+0x21>
  80241c:	b8 00 00 00 00       	mov    $0x0,%eax
  802421:	e9 84 05 00 00       	jmp    8029aa <smalloc+0x5a5>
	//==============================================================
	acquire_uspinlock(&ulock);
  802426:	83 ec 0c             	sub    $0xc,%esp
  802429:	68 40 e1 81 00       	push   $0x81e140
  80242e:	e8 96 1c 00 00       	call   8040c9 <acquire_uspinlock>
  802433:	83 c4 10             	add    $0x10,%esp

	struct UserHeapStruct* allocblock = (struct UserHeapStruct*) alloc_block(sizeof(struct UserHeapStruct));
  802436:	83 ec 0c             	sub    $0xc,%esp
  802439:	6a 10                	push   $0x10
  80243b:	e8 63 13 00 00       	call   8037a3 <alloc_block>
  802440:	83 c4 10             	add    $0x10,%esp
  802443:	89 45 ec             	mov    %eax,-0x14(%ebp)
	if (allocblock == NULL){
  802446:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80244a:	75 0a                	jne    802456 <smalloc+0x51>
				return NULL;
  80244c:	b8 00 00 00 00       	mov    $0x0,%eax
  802451:	e9 54 05 00 00       	jmp    8029aa <smalloc+0x5a5>
	}
		size = ROUNDUP(size,PAGE_SIZE);
  802456:	c7 45 e8 00 10 00 00 	movl   $0x1000,-0x18(%ebp)
  80245d:	8b 55 0c             	mov    0xc(%ebp),%edx
  802460:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802463:	01 d0                	add    %edx,%eax
  802465:	48                   	dec    %eax
  802466:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  802469:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80246c:	ba 00 00 00 00       	mov    $0x0,%edx
  802471:	f7 75 e8             	divl   -0x18(%ebp)
  802474:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802477:	29 d0                	sub    %edx,%eax
  802479:	89 45 0c             	mov    %eax,0xc(%ebp)
		struct UserHeapStruct* lastfreeelement = LIST_LAST(&u_freelist);
  80247c:	a1 24 e1 81 00       	mov    0x81e124,%eax
  802481:	89 45 e0             	mov    %eax,-0x20(%ebp)

		if(LIST_SIZE(&u_freelist)==0 || size>lastfreeelement->size){
  802484:	a1 2c e1 81 00       	mov    0x81e12c,%eax
  802489:	85 c0                	test   %eax,%eax
  80248b:	74 0f                	je     80249c <smalloc+0x97>
  80248d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802490:	8b 40 04             	mov    0x4(%eax),%eax
  802493:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802496:	0f 83 25 01 00 00    	jae    8025c1 <smalloc+0x1bc>
				if(uheapPageAllocBreak <= USER_HEAP_MAX - size){
  80249c:	b8 00 00 00 a0       	mov    $0xa0000000,%eax
  8024a1:	2b 45 0c             	sub    0xc(%ebp),%eax
  8024a4:	89 c2                	mov    %eax,%edx
  8024a6:	a1 68 e0 81 00       	mov    0x81e068,%eax
  8024ab:	39 c2                	cmp    %eax,%edx
  8024ad:	0f 82 f4 00 00 00    	jb     8025a7 <smalloc+0x1a2>
						uint32 requestedblockva = uheapPageAllocBreak;
  8024b3:	a1 68 e0 81 00       	mov    0x81e068,%eax
  8024b8:	89 45 d4             	mov    %eax,-0x2c(%ebp)
						uheapPageAllocBreak+=size;
  8024bb:	8b 15 68 e0 81 00    	mov    0x81e068,%edx
  8024c1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8024c4:	01 d0                	add    %edx,%eax
  8024c6:	a3 68 e0 81 00       	mov    %eax,0x81e068
						allocblock->startva = requestedblockva;
  8024cb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8024ce:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8024d1:	89 10                	mov    %edx,(%eax)
						allocblock->size = size;
  8024d3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8024d6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8024d9:	89 50 04             	mov    %edx,0x4(%eax)

						LIST_INSERT_TAIL(&u_allocatedlist, allocblock);
  8024dc:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8024e0:	75 17                	jne    8024f9 <smalloc+0xf4>
  8024e2:	83 ec 04             	sub    $0x4,%esp
  8024e5:	68 98 4d 80 00       	push   $0x804d98
  8024ea:	68 57 01 00 00       	push   $0x157
  8024ef:	68 4c 4d 80 00       	push   $0x804d4c
  8024f4:	e8 97 df ff ff       	call   800490 <_panic>
  8024f9:	8b 15 34 e1 81 00    	mov    0x81e134,%edx
  8024ff:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802502:	89 50 0c             	mov    %edx,0xc(%eax)
  802505:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802508:	8b 40 0c             	mov    0xc(%eax),%eax
  80250b:	85 c0                	test   %eax,%eax
  80250d:	74 0d                	je     80251c <smalloc+0x117>
  80250f:	a1 34 e1 81 00       	mov    0x81e134,%eax
  802514:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802517:	89 50 08             	mov    %edx,0x8(%eax)
  80251a:	eb 08                	jmp    802524 <smalloc+0x11f>
  80251c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80251f:	a3 30 e1 81 00       	mov    %eax,0x81e130
  802524:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802527:	a3 34 e1 81 00       	mov    %eax,0x81e134
  80252c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80252f:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802536:	a1 3c e1 81 00       	mov    0x81e13c,%eax
  80253b:	40                   	inc    %eax
  80253c:	a3 3c e1 81 00       	mov    %eax,0x81e13c


						int result = sys_create_shared_object(sharedVarName ,size ,isWritable ,(void*)allocblock->startva);
  802541:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802544:	8b 00                	mov    (%eax),%eax
  802546:	89 c2                	mov    %eax,%edx
  802548:	0f b6 45 c4          	movzbl -0x3c(%ebp),%eax
  80254c:	52                   	push   %edx
  80254d:	50                   	push   %eax
  80254e:	ff 75 0c             	pushl  0xc(%ebp)
  802551:	ff 75 08             	pushl  0x8(%ebp)
  802554:	e8 48 0c 00 00       	call   8031a1 <sys_create_shared_object>
  802559:	83 c4 10             	add    $0x10,%esp
  80255c:	89 45 d0             	mov    %eax,-0x30(%ebp)

						if(result <0){
  80255f:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  802563:	79 28                	jns    80258d <smalloc+0x188>
							free_block(allocblock);
  802565:	83 ec 0c             	sub    $0xc,%esp
  802568:	ff 75 ec             	pushl  -0x14(%ebp)
  80256b:	e8 cf 16 00 00       	call   803c3f <free_block>
  802570:	83 c4 10             	add    $0x10,%esp
							release_uspinlock(&ulock);
  802573:	83 ec 0c             	sub    $0xc,%esp
  802576:	68 40 e1 81 00       	push   $0x81e140
  80257b:	e8 a1 1b 00 00       	call   804121 <release_uspinlock>
  802580:	83 c4 10             	add    $0x10,%esp
							return NULL;
  802583:	b8 00 00 00 00       	mov    $0x0,%eax
  802588:	e9 1d 04 00 00       	jmp    8029aa <smalloc+0x5a5>
						}
						release_uspinlock(&ulock);
  80258d:	83 ec 0c             	sub    $0xc,%esp
  802590:	68 40 e1 81 00       	push   $0x81e140
  802595:	e8 87 1b 00 00       	call   804121 <release_uspinlock>
  80259a:	83 c4 10             	add    $0x10,%esp
						return (void*)allocblock -> startva;
  80259d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025a0:	8b 00                	mov    (%eax),%eax
  8025a2:	e9 03 04 00 00       	jmp    8029aa <smalloc+0x5a5>
				}else{
						release_uspinlock(&ulock);
  8025a7:	83 ec 0c             	sub    $0xc,%esp
  8025aa:	68 40 e1 81 00       	push   $0x81e140
  8025af:	e8 6d 1b 00 00       	call   804121 <release_uspinlock>
  8025b4:	83 c4 10             	add    $0x10,%esp
						return NULL;
  8025b7:	b8 00 00 00 00       	mov    $0x0,%eax
  8025bc:	e9 e9 03 00 00       	jmp    8029aa <smalloc+0x5a5>
					 }
		}else{
			//custom fit
			struct UserHeapStruct* currentfreeelement = LIST_FIRST(&u_freelist);
  8025c1:	a1 20 e1 81 00       	mov    0x81e120,%eax
  8025c6:	89 45 f4             	mov    %eax,-0xc(%ebp)
			//worst fit
			while(currentfreeelement != NULL){
  8025c9:	e9 af 03 00 00       	jmp    80297d <smalloc+0x578>
				if(size<currentfreeelement->size){
  8025ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025d1:	8b 40 04             	mov    0x4(%eax),%eax
  8025d4:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8025d7:	0f 86 28 02 00 00    	jbe    802805 <smalloc+0x400>
					allocblock->startva = lastfreeelement->startva;
  8025dd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8025e0:	8b 10                	mov    (%eax),%edx
  8025e2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025e5:	89 10                	mov    %edx,(%eax)
	                allocblock->size = size;
  8025e7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025ea:	8b 55 0c             	mov    0xc(%ebp),%edx
  8025ed:	89 50 04             	mov    %edx,0x4(%eax)
	                LIST_INSERT_TAIL(&u_allocatedlist,allocblock);
  8025f0:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8025f4:	75 17                	jne    80260d <smalloc+0x208>
  8025f6:	83 ec 04             	sub    $0x4,%esp
  8025f9:	68 98 4d 80 00       	push   $0x804d98
  8025fe:	68 6f 01 00 00       	push   $0x16f
  802603:	68 4c 4d 80 00       	push   $0x804d4c
  802608:	e8 83 de ff ff       	call   800490 <_panic>
  80260d:	8b 15 34 e1 81 00    	mov    0x81e134,%edx
  802613:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802616:	89 50 0c             	mov    %edx,0xc(%eax)
  802619:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80261c:	8b 40 0c             	mov    0xc(%eax),%eax
  80261f:	85 c0                	test   %eax,%eax
  802621:	74 0d                	je     802630 <smalloc+0x22b>
  802623:	a1 34 e1 81 00       	mov    0x81e134,%eax
  802628:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80262b:	89 50 08             	mov    %edx,0x8(%eax)
  80262e:	eb 08                	jmp    802638 <smalloc+0x233>
  802630:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802633:	a3 30 e1 81 00       	mov    %eax,0x81e130
  802638:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80263b:	a3 34 e1 81 00       	mov    %eax,0x81e134
  802640:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802643:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  80264a:	a1 3c e1 81 00       	mov    0x81e13c,%eax
  80264f:	40                   	inc    %eax
  802650:	a3 3c e1 81 00       	mov    %eax,0x81e13c
	                lastfreeelement->startva += size;
  802655:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802658:	8b 10                	mov    (%eax),%edx
  80265a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80265d:	01 c2                	add    %eax,%edx
  80265f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802662:	89 10                	mov    %edx,(%eax)
	                lastfreeelement->size -= size;
  802664:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802667:	8b 40 04             	mov    0x4(%eax),%eax
  80266a:	2b 45 0c             	sub    0xc(%ebp),%eax
  80266d:	89 c2                	mov    %eax,%edx
  80266f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802672:	89 50 04             	mov    %edx,0x4(%eax)
	                struct UserHeapStruct* currentfree2 = LIST_FIRST(&u_freelist);
  802675:	a1 20 e1 81 00       	mov    0x81e120,%eax
  80267a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	                //check order of last element

	                while (currentfree2 != NULL){
  80267d:	e9 13 01 00 00       	jmp    802795 <smalloc+0x390>
	                	if(lastfreeelement->size <currentfree2->size){
  802682:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802685:	8b 50 04             	mov    0x4(%eax),%edx
  802688:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80268b:	8b 40 04             	mov    0x4(%eax),%eax
  80268e:	39 c2                	cmp    %eax,%edx
  802690:	0f 83 f6 00 00 00    	jae    80278c <smalloc+0x387>
	                		LIST_REMOVE(&u_freelist ,lastfreeelement);
  802696:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80269a:	75 17                	jne    8026b3 <smalloc+0x2ae>
  80269c:	83 ec 04             	sub    $0x4,%esp
  80269f:	68 bb 4d 80 00       	push   $0x804dbb
  8026a4:	68 77 01 00 00       	push   $0x177
  8026a9:	68 4c 4d 80 00       	push   $0x804d4c
  8026ae:	e8 dd dd ff ff       	call   800490 <_panic>
  8026b3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8026b6:	8b 40 08             	mov    0x8(%eax),%eax
  8026b9:	85 c0                	test   %eax,%eax
  8026bb:	74 11                	je     8026ce <smalloc+0x2c9>
  8026bd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8026c0:	8b 40 08             	mov    0x8(%eax),%eax
  8026c3:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8026c6:	8b 52 0c             	mov    0xc(%edx),%edx
  8026c9:	89 50 0c             	mov    %edx,0xc(%eax)
  8026cc:	eb 0b                	jmp    8026d9 <smalloc+0x2d4>
  8026ce:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8026d1:	8b 40 0c             	mov    0xc(%eax),%eax
  8026d4:	a3 24 e1 81 00       	mov    %eax,0x81e124
  8026d9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8026dc:	8b 40 0c             	mov    0xc(%eax),%eax
  8026df:	85 c0                	test   %eax,%eax
  8026e1:	74 11                	je     8026f4 <smalloc+0x2ef>
  8026e3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8026e6:	8b 40 0c             	mov    0xc(%eax),%eax
  8026e9:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8026ec:	8b 52 08             	mov    0x8(%edx),%edx
  8026ef:	89 50 08             	mov    %edx,0x8(%eax)
  8026f2:	eb 0b                	jmp    8026ff <smalloc+0x2fa>
  8026f4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8026f7:	8b 40 08             	mov    0x8(%eax),%eax
  8026fa:	a3 20 e1 81 00       	mov    %eax,0x81e120
  8026ff:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802702:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802709:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80270c:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  802713:	a1 2c e1 81 00       	mov    0x81e12c,%eax
  802718:	48                   	dec    %eax
  802719:	a3 2c e1 81 00       	mov    %eax,0x81e12c
	                		LIST_INSERT_BEFORE(&u_freelist ,currentfree2 ,lastfreeelement);
  80271e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802722:	74 06                	je     80272a <smalloc+0x325>
  802724:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802728:	75 17                	jne    802741 <smalloc+0x33c>
  80272a:	83 ec 04             	sub    $0x4,%esp
  80272d:	68 dc 4d 80 00       	push   $0x804ddc
  802732:	68 78 01 00 00       	push   $0x178
  802737:	68 4c 4d 80 00       	push   $0x804d4c
  80273c:	e8 4f dd ff ff       	call   800490 <_panic>
  802741:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802744:	8b 50 0c             	mov    0xc(%eax),%edx
  802747:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80274a:	89 50 0c             	mov    %edx,0xc(%eax)
  80274d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802750:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802753:	89 50 08             	mov    %edx,0x8(%eax)
  802756:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802759:	8b 40 0c             	mov    0xc(%eax),%eax
  80275c:	85 c0                	test   %eax,%eax
  80275e:	74 0e                	je     80276e <smalloc+0x369>
  802760:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802763:	8b 40 0c             	mov    0xc(%eax),%eax
  802766:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802769:	89 50 08             	mov    %edx,0x8(%eax)
  80276c:	eb 08                	jmp    802776 <smalloc+0x371>
  80276e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802771:	a3 20 e1 81 00       	mov    %eax,0x81e120
  802776:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802779:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80277c:	89 50 0c             	mov    %edx,0xc(%eax)
  80277f:	a1 2c e1 81 00       	mov    0x81e12c,%eax
  802784:	40                   	inc    %eax
  802785:	a3 2c e1 81 00       	mov    %eax,0x81e12c
	                		break;
  80278a:	eb 13                	jmp    80279f <smalloc+0x39a>
	                	}
	                	currentfree2 = currentfree2->prev_next_info.le_next;
  80278c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80278f:	8b 40 08             	mov    0x8(%eax),%eax
  802792:	89 45 f0             	mov    %eax,-0x10(%ebp)
	                lastfreeelement->startva += size;
	                lastfreeelement->size -= size;
	                struct UserHeapStruct* currentfree2 = LIST_FIRST(&u_freelist);
	                //check order of last element

	                while (currentfree2 != NULL){
  802795:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802799:	0f 85 e3 fe ff ff    	jne    802682 <smalloc+0x27d>
	                	}
	                	currentfree2 = currentfree2->prev_next_info.le_next;
	                }


	                int result = sys_create_shared_object(sharedVarName ,size ,isWritable ,(void*)allocblock->startva);
  80279f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027a2:	8b 00                	mov    (%eax),%eax
  8027a4:	89 c2                	mov    %eax,%edx
  8027a6:	0f b6 45 c4          	movzbl -0x3c(%ebp),%eax
  8027aa:	52                   	push   %edx
  8027ab:	50                   	push   %eax
  8027ac:	ff 75 0c             	pushl  0xc(%ebp)
  8027af:	ff 75 08             	pushl  0x8(%ebp)
  8027b2:	e8 ea 09 00 00       	call   8031a1 <sys_create_shared_object>
  8027b7:	83 c4 10             	add    $0x10,%esp
  8027ba:	89 45 d8             	mov    %eax,-0x28(%ebp)

	                if(result <0){
  8027bd:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8027c1:	79 28                	jns    8027eb <smalloc+0x3e6>
	                	free_block(allocblock);
  8027c3:	83 ec 0c             	sub    $0xc,%esp
  8027c6:	ff 75 ec             	pushl  -0x14(%ebp)
  8027c9:	e8 71 14 00 00       	call   803c3f <free_block>
  8027ce:	83 c4 10             	add    $0x10,%esp
	                	release_uspinlock(&ulock);
  8027d1:	83 ec 0c             	sub    $0xc,%esp
  8027d4:	68 40 e1 81 00       	push   $0x81e140
  8027d9:	e8 43 19 00 00       	call   804121 <release_uspinlock>
  8027de:	83 c4 10             	add    $0x10,%esp
	                	return NULL;
  8027e1:	b8 00 00 00 00       	mov    $0x0,%eax
  8027e6:	e9 bf 01 00 00       	jmp    8029aa <smalloc+0x5a5>
	                }
	                release_uspinlock(&ulock);
  8027eb:	83 ec 0c             	sub    $0xc,%esp
  8027ee:	68 40 e1 81 00       	push   $0x81e140
  8027f3:	e8 29 19 00 00       	call   804121 <release_uspinlock>
  8027f8:	83 c4 10             	add    $0x10,%esp
	                return (void*)allocblock->startva;
  8027fb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027fe:	8b 00                	mov    (%eax),%eax
  802800:	e9 a5 01 00 00       	jmp    8029aa <smalloc+0x5a5>
	                //exact fit
				}else if(size == currentfreeelement->size){
  802805:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802808:	8b 40 04             	mov    0x4(%eax),%eax
  80280b:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80280e:	0f 85 60 01 00 00    	jne    802974 <smalloc+0x56f>
					allocblock->startva = currentfreeelement->startva;
  802814:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802817:	8b 10                	mov    (%eax),%edx
  802819:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80281c:	89 10                	mov    %edx,(%eax)
					allocblock->size = size;
  80281e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802821:	8b 55 0c             	mov    0xc(%ebp),%edx
  802824:	89 50 04             	mov    %edx,0x4(%eax)
					LIST_INSERT_TAIL(&u_allocatedlist ,allocblock);
  802827:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80282b:	75 17                	jne    802844 <smalloc+0x43f>
  80282d:	83 ec 04             	sub    $0x4,%esp
  802830:	68 98 4d 80 00       	push   $0x804d98
  802835:	68 8c 01 00 00       	push   $0x18c
  80283a:	68 4c 4d 80 00       	push   $0x804d4c
  80283f:	e8 4c dc ff ff       	call   800490 <_panic>
  802844:	8b 15 34 e1 81 00    	mov    0x81e134,%edx
  80284a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80284d:	89 50 0c             	mov    %edx,0xc(%eax)
  802850:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802853:	8b 40 0c             	mov    0xc(%eax),%eax
  802856:	85 c0                	test   %eax,%eax
  802858:	74 0d                	je     802867 <smalloc+0x462>
  80285a:	a1 34 e1 81 00       	mov    0x81e134,%eax
  80285f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802862:	89 50 08             	mov    %edx,0x8(%eax)
  802865:	eb 08                	jmp    80286f <smalloc+0x46a>
  802867:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80286a:	a3 30 e1 81 00       	mov    %eax,0x81e130
  80286f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802872:	a3 34 e1 81 00       	mov    %eax,0x81e134
  802877:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80287a:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802881:	a1 3c e1 81 00       	mov    0x81e13c,%eax
  802886:	40                   	inc    %eax
  802887:	a3 3c e1 81 00       	mov    %eax,0x81e13c
					LIST_REMOVE(&u_freelist ,currentfreeelement);
  80288c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802890:	75 17                	jne    8028a9 <smalloc+0x4a4>
  802892:	83 ec 04             	sub    $0x4,%esp
  802895:	68 bb 4d 80 00       	push   $0x804dbb
  80289a:	68 8d 01 00 00       	push   $0x18d
  80289f:	68 4c 4d 80 00       	push   $0x804d4c
  8028a4:	e8 e7 db ff ff       	call   800490 <_panic>
  8028a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028ac:	8b 40 08             	mov    0x8(%eax),%eax
  8028af:	85 c0                	test   %eax,%eax
  8028b1:	74 11                	je     8028c4 <smalloc+0x4bf>
  8028b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028b6:	8b 40 08             	mov    0x8(%eax),%eax
  8028b9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028bc:	8b 52 0c             	mov    0xc(%edx),%edx
  8028bf:	89 50 0c             	mov    %edx,0xc(%eax)
  8028c2:	eb 0b                	jmp    8028cf <smalloc+0x4ca>
  8028c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028c7:	8b 40 0c             	mov    0xc(%eax),%eax
  8028ca:	a3 24 e1 81 00       	mov    %eax,0x81e124
  8028cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028d2:	8b 40 0c             	mov    0xc(%eax),%eax
  8028d5:	85 c0                	test   %eax,%eax
  8028d7:	74 11                	je     8028ea <smalloc+0x4e5>
  8028d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028dc:	8b 40 0c             	mov    0xc(%eax),%eax
  8028df:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028e2:	8b 52 08             	mov    0x8(%edx),%edx
  8028e5:	89 50 08             	mov    %edx,0x8(%eax)
  8028e8:	eb 0b                	jmp    8028f5 <smalloc+0x4f0>
  8028ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028ed:	8b 40 08             	mov    0x8(%eax),%eax
  8028f0:	a3 20 e1 81 00       	mov    %eax,0x81e120
  8028f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028f8:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  8028ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802902:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  802909:	a1 2c e1 81 00       	mov    0x81e12c,%eax
  80290e:	48                   	dec    %eax
  80290f:	a3 2c e1 81 00       	mov    %eax,0x81e12c
					int result = sys_create_shared_object(sharedVarName ,size ,isWritable ,(void*)allocblock->startva);
  802914:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802917:	8b 00                	mov    (%eax),%eax
  802919:	89 c2                	mov    %eax,%edx
  80291b:	0f b6 45 c4          	movzbl -0x3c(%ebp),%eax
  80291f:	52                   	push   %edx
  802920:	50                   	push   %eax
  802921:	ff 75 0c             	pushl  0xc(%ebp)
  802924:	ff 75 08             	pushl  0x8(%ebp)
  802927:	e8 75 08 00 00       	call   8031a1 <sys_create_shared_object>
  80292c:	83 c4 10             	add    $0x10,%esp
  80292f:	89 45 dc             	mov    %eax,-0x24(%ebp)

					if(result <0){
  802932:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802936:	79 25                	jns    80295d <smalloc+0x558>
						free_block(allocblock);
  802938:	83 ec 0c             	sub    $0xc,%esp
  80293b:	ff 75 ec             	pushl  -0x14(%ebp)
  80293e:	e8 fc 12 00 00       	call   803c3f <free_block>
  802943:	83 c4 10             	add    $0x10,%esp
						release_uspinlock(&ulock);
  802946:	83 ec 0c             	sub    $0xc,%esp
  802949:	68 40 e1 81 00       	push   $0x81e140
  80294e:	e8 ce 17 00 00       	call   804121 <release_uspinlock>
  802953:	83 c4 10             	add    $0x10,%esp
						return NULL;
  802956:	b8 00 00 00 00       	mov    $0x0,%eax
  80295b:	eb 4d                	jmp    8029aa <smalloc+0x5a5>
					}
					release_uspinlock(&ulock);
  80295d:	83 ec 0c             	sub    $0xc,%esp
  802960:	68 40 e1 81 00       	push   $0x81e140
  802965:	e8 b7 17 00 00       	call   804121 <release_uspinlock>
  80296a:	83 c4 10             	add    $0x10,%esp
					return (void*)allocblock->startva;
  80296d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802970:	8b 00                	mov    (%eax),%eax
  802972:	eb 36                	jmp    8029aa <smalloc+0x5a5>
				}
				currentfreeelement = currentfreeelement->prev_next_info.le_next;
  802974:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802977:	8b 40 08             	mov    0x8(%eax),%eax
  80297a:	89 45 f4             	mov    %eax,-0xc(%ebp)
					 }
		}else{
			//custom fit
			struct UserHeapStruct* currentfreeelement = LIST_FIRST(&u_freelist);
			//worst fit
			while(currentfreeelement != NULL){
  80297d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802981:	0f 85 47 fc ff ff    	jne    8025ce <smalloc+0x1c9>
					return (void*)allocblock->startva;
				}
				currentfreeelement = currentfreeelement->prev_next_info.le_next;
			}
		}
		free_block(allocblock);
  802987:	83 ec 0c             	sub    $0xc,%esp
  80298a:	ff 75 ec             	pushl  -0x14(%ebp)
  80298d:	e8 ad 12 00 00       	call   803c3f <free_block>
  802992:	83 c4 10             	add    $0x10,%esp
		release_uspinlock(&ulock);
  802995:	83 ec 0c             	sub    $0xc,%esp
  802998:	68 40 e1 81 00       	push   $0x81e140
  80299d:	e8 7f 17 00 00       	call   804121 <release_uspinlock>
  8029a2:	83 c4 10             	add    $0x10,%esp
		return NULL;
  8029a5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8029aa:	c9                   	leave  
  8029ab:	c3                   	ret    

008029ac <sget>:

//========================================
// [4] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8029ac:	55                   	push   %ebp
  8029ad:	89 e5                	mov    %esp,%ebp
  8029af:	83 ec 38             	sub    $0x38,%esp


	 //==============================================================
	 // DON'T CHANGE THIS CODE
	    uheap_init();
  8029b2:	e8 8c ec ff ff       	call   801643 <uheap_init>
	 //==============================================================
	 // Get size of the shared variable from kernel
	acquire_uspinlock(&ulock);
  8029b7:	83 ec 0c             	sub    $0xc,%esp
  8029ba:	68 40 e1 81 00       	push   $0x81e140
  8029bf:	e8 05 17 00 00       	call   8040c9 <acquire_uspinlock>
  8029c4:	83 c4 10             	add    $0x10,%esp


	int size = sys_size_of_shared_object(ownerEnvID ,sharedVarName);
  8029c7:	83 ec 08             	sub    $0x8,%esp
  8029ca:	ff 75 0c             	pushl  0xc(%ebp)
  8029cd:	ff 75 08             	pushl  0x8(%ebp)
  8029d0:	e8 f6 07 00 00       	call   8031cb <sys_size_of_shared_object>
  8029d5:	83 c4 10             	add    $0x10,%esp
  8029d8:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if ( size < 0 ){
  8029db:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8029df:	79 1a                	jns    8029fb <sget+0x4f>
			release_uspinlock(&ulock);
  8029e1:	83 ec 0c             	sub    $0xc,%esp
  8029e4:	68 40 e1 81 00       	push   $0x81e140
  8029e9:	e8 33 17 00 00       	call   804121 <release_uspinlock>
  8029ee:	83 c4 10             	add    $0x10,%esp
			return NULL;
  8029f1:	b8 00 00 00 00       	mov    $0x0,%eax
  8029f6:	e9 6e 05 00 00       	jmp    802f69 <sget+0x5bd>
		}
		size = ROUNDUP(size,PAGE_SIZE);
  8029fb:	c7 45 e8 00 10 00 00 	movl   $0x1000,-0x18(%ebp)
  802a02:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802a05:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a08:	01 d0                	add    %edx,%eax
  802a0a:	48                   	dec    %eax
  802a0b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  802a0e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802a11:	ba 00 00 00 00       	mov    $0x0,%edx
  802a16:	f7 75 e8             	divl   -0x18(%ebp)
  802a19:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802a1c:	29 d0                	sub    %edx,%eax
  802a1e:	89 45 ec             	mov    %eax,-0x14(%ebp)

		struct UserHeapStruct* allocblock = (struct UserHeapStruct*) alloc_block(sizeof(struct UserHeapStruct));
  802a21:	83 ec 0c             	sub    $0xc,%esp
  802a24:	6a 10                	push   $0x10
  802a26:	e8 78 0d 00 00       	call   8037a3 <alloc_block>
  802a2b:	83 c4 10             	add    $0x10,%esp
  802a2e:	89 45 e0             	mov    %eax,-0x20(%ebp)

		if (allocblock == NULL){
  802a31:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802a35:	75 0a                	jne    802a41 <sget+0x95>
			return NULL;
  802a37:	b8 00 00 00 00       	mov    $0x0,%eax
  802a3c:	e9 28 05 00 00       	jmp    802f69 <sget+0x5bd>
		}
		struct UserHeapStruct* lastfreeelement = LIST_LAST(&u_freelist);
  802a41:	a1 24 e1 81 00       	mov    0x81e124,%eax
  802a46:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if(LIST_SIZE(&u_freelist)==0 || size>lastfreeelement->size){
  802a49:	a1 2c e1 81 00       	mov    0x81e12c,%eax
  802a4e:	85 c0                	test   %eax,%eax
  802a50:	74 11                	je     802a63 <sget+0xb7>
  802a52:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802a55:	8b 50 04             	mov    0x4(%eax),%edx
  802a58:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a5b:	39 c2                	cmp    %eax,%edx
  802a5d:	0f 83 21 01 00 00    	jae    802b84 <sget+0x1d8>
				if(uheapPageAllocBreak <= USER_HEAP_MAX - size){
  802a63:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a66:	ba 00 00 00 a0       	mov    $0xa0000000,%edx
  802a6b:	29 c2                	sub    %eax,%edx
  802a6d:	a1 68 e0 81 00       	mov    0x81e068,%eax
  802a72:	39 c2                	cmp    %eax,%edx
  802a74:	0f 82 f0 00 00 00    	jb     802b6a <sget+0x1be>

						uint32 requestedblockva = uheapPageAllocBreak;
  802a7a:	a1 68 e0 81 00       	mov    0x81e068,%eax
  802a7f:	89 45 d0             	mov    %eax,-0x30(%ebp)
						uheapPageAllocBreak+=size;
  802a82:	8b 15 68 e0 81 00    	mov    0x81e068,%edx
  802a88:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a8b:	01 d0                	add    %edx,%eax
  802a8d:	a3 68 e0 81 00       	mov    %eax,0x81e068
						allocblock->startva = requestedblockva;
  802a92:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802a95:	8b 55 d0             	mov    -0x30(%ebp),%edx
  802a98:	89 10                	mov    %edx,(%eax)
						allocblock->size = size;
  802a9a:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802a9d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802aa0:	89 50 04             	mov    %edx,0x4(%eax)

						LIST_INSERT_TAIL(&u_allocatedlist, allocblock);
  802aa3:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802aa7:	75 17                	jne    802ac0 <sget+0x114>
  802aa9:	83 ec 04             	sub    $0x4,%esp
  802aac:	68 98 4d 80 00       	push   $0x804d98
  802ab1:	68 c8 01 00 00       	push   $0x1c8
  802ab6:	68 4c 4d 80 00       	push   $0x804d4c
  802abb:	e8 d0 d9 ff ff       	call   800490 <_panic>
  802ac0:	8b 15 34 e1 81 00    	mov    0x81e134,%edx
  802ac6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802ac9:	89 50 0c             	mov    %edx,0xc(%eax)
  802acc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802acf:	8b 40 0c             	mov    0xc(%eax),%eax
  802ad2:	85 c0                	test   %eax,%eax
  802ad4:	74 0d                	je     802ae3 <sget+0x137>
  802ad6:	a1 34 e1 81 00       	mov    0x81e134,%eax
  802adb:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802ade:	89 50 08             	mov    %edx,0x8(%eax)
  802ae1:	eb 08                	jmp    802aeb <sget+0x13f>
  802ae3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802ae6:	a3 30 e1 81 00       	mov    %eax,0x81e130
  802aeb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802aee:	a3 34 e1 81 00       	mov    %eax,0x81e134
  802af3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802af6:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802afd:	a1 3c e1 81 00       	mov    0x81e13c,%eax
  802b02:	40                   	inc    %eax
  802b03:	a3 3c e1 81 00       	mov    %eax,0x81e13c


						int result = sys_get_shared_object(ownerEnvID ,sharedVarName ,(void*)allocblock->startva);
  802b08:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802b0b:	8b 00                	mov    (%eax),%eax
  802b0d:	83 ec 04             	sub    $0x4,%esp
  802b10:	50                   	push   %eax
  802b11:	ff 75 0c             	pushl  0xc(%ebp)
  802b14:	ff 75 08             	pushl  0x8(%ebp)
  802b17:	e8 cc 06 00 00       	call   8031e8 <sys_get_shared_object>
  802b1c:	83 c4 10             	add    $0x10,%esp
  802b1f:	89 45 cc             	mov    %eax,-0x34(%ebp)

						if(result <0){
  802b22:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802b26:	79 28                	jns    802b50 <sget+0x1a4>
							free_block(allocblock);
  802b28:	83 ec 0c             	sub    $0xc,%esp
  802b2b:	ff 75 e0             	pushl  -0x20(%ebp)
  802b2e:	e8 0c 11 00 00       	call   803c3f <free_block>
  802b33:	83 c4 10             	add    $0x10,%esp
							release_uspinlock(&ulock);
  802b36:	83 ec 0c             	sub    $0xc,%esp
  802b39:	68 40 e1 81 00       	push   $0x81e140
  802b3e:	e8 de 15 00 00       	call   804121 <release_uspinlock>
  802b43:	83 c4 10             	add    $0x10,%esp
							return NULL;
  802b46:	b8 00 00 00 00       	mov    $0x0,%eax
  802b4b:	e9 19 04 00 00       	jmp    802f69 <sget+0x5bd>
						}
						release_uspinlock(&ulock);
  802b50:	83 ec 0c             	sub    $0xc,%esp
  802b53:	68 40 e1 81 00       	push   $0x81e140
  802b58:	e8 c4 15 00 00       	call   804121 <release_uspinlock>
  802b5d:	83 c4 10             	add    $0x10,%esp
						return (void*)allocblock -> startva;
  802b60:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802b63:	8b 00                	mov    (%eax),%eax
  802b65:	e9 ff 03 00 00       	jmp    802f69 <sget+0x5bd>
				}else{
						release_uspinlock(&ulock);
  802b6a:	83 ec 0c             	sub    $0xc,%esp
  802b6d:	68 40 e1 81 00       	push   $0x81e140
  802b72:	e8 aa 15 00 00       	call   804121 <release_uspinlock>
  802b77:	83 c4 10             	add    $0x10,%esp
						return NULL;
  802b7a:	b8 00 00 00 00       	mov    $0x0,%eax
  802b7f:	e9 e5 03 00 00       	jmp    802f69 <sget+0x5bd>
					 }
		}else{
			//custom fit
			struct UserHeapStruct* currentfreeelement = LIST_FIRST(&u_freelist);
  802b84:	a1 20 e1 81 00       	mov    0x81e120,%eax
  802b89:	89 45 f4             	mov    %eax,-0xc(%ebp)
			//worst fit
			while(currentfreeelement != NULL){
  802b8c:	e9 ab 03 00 00       	jmp    802f3c <sget+0x590>
				if(size<currentfreeelement->size){
  802b91:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b94:	8b 50 04             	mov    0x4(%eax),%edx
  802b97:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b9a:	39 c2                	cmp    %eax,%edx
  802b9c:	0f 86 24 02 00 00    	jbe    802dc6 <sget+0x41a>
					allocblock->startva = lastfreeelement->startva;
  802ba2:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802ba5:	8b 10                	mov    (%eax),%edx
  802ba7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802baa:	89 10                	mov    %edx,(%eax)
					allocblock->size = size;
  802bac:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802baf:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802bb2:	89 50 04             	mov    %edx,0x4(%eax)
					LIST_INSERT_TAIL(&u_allocatedlist,allocblock);
  802bb5:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802bb9:	75 17                	jne    802bd2 <sget+0x226>
  802bbb:	83 ec 04             	sub    $0x4,%esp
  802bbe:	68 98 4d 80 00       	push   $0x804d98
  802bc3:	68 e0 01 00 00       	push   $0x1e0
  802bc8:	68 4c 4d 80 00       	push   $0x804d4c
  802bcd:	e8 be d8 ff ff       	call   800490 <_panic>
  802bd2:	8b 15 34 e1 81 00    	mov    0x81e134,%edx
  802bd8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802bdb:	89 50 0c             	mov    %edx,0xc(%eax)
  802bde:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802be1:	8b 40 0c             	mov    0xc(%eax),%eax
  802be4:	85 c0                	test   %eax,%eax
  802be6:	74 0d                	je     802bf5 <sget+0x249>
  802be8:	a1 34 e1 81 00       	mov    0x81e134,%eax
  802bed:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802bf0:	89 50 08             	mov    %edx,0x8(%eax)
  802bf3:	eb 08                	jmp    802bfd <sget+0x251>
  802bf5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802bf8:	a3 30 e1 81 00       	mov    %eax,0x81e130
  802bfd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802c00:	a3 34 e1 81 00       	mov    %eax,0x81e134
  802c05:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802c08:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802c0f:	a1 3c e1 81 00       	mov    0x81e13c,%eax
  802c14:	40                   	inc    %eax
  802c15:	a3 3c e1 81 00       	mov    %eax,0x81e13c
					lastfreeelement->startva += size;
  802c1a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802c1d:	8b 10                	mov    (%eax),%edx
  802c1f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c22:	01 c2                	add    %eax,%edx
  802c24:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802c27:	89 10                	mov    %edx,(%eax)
					lastfreeelement->size -= size;
  802c29:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802c2c:	8b 50 04             	mov    0x4(%eax),%edx
  802c2f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c32:	29 c2                	sub    %eax,%edx
  802c34:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802c37:	89 50 04             	mov    %edx,0x4(%eax)
					struct UserHeapStruct* currentfree2 = LIST_FIRST(&u_freelist);
  802c3a:	a1 20 e1 81 00       	mov    0x81e120,%eax
  802c3f:	89 45 f0             	mov    %eax,-0x10(%ebp)
					//check order of last element

					while (currentfree2 != NULL){
  802c42:	e9 13 01 00 00       	jmp    802d5a <sget+0x3ae>
						if(lastfreeelement->size <currentfree2->size){
  802c47:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802c4a:	8b 50 04             	mov    0x4(%eax),%edx
  802c4d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c50:	8b 40 04             	mov    0x4(%eax),%eax
  802c53:	39 c2                	cmp    %eax,%edx
  802c55:	0f 83 f6 00 00 00    	jae    802d51 <sget+0x3a5>
							LIST_REMOVE(&u_freelist ,lastfreeelement);
  802c5b:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802c5f:	75 17                	jne    802c78 <sget+0x2cc>
  802c61:	83 ec 04             	sub    $0x4,%esp
  802c64:	68 bb 4d 80 00       	push   $0x804dbb
  802c69:	68 e8 01 00 00       	push   $0x1e8
  802c6e:	68 4c 4d 80 00       	push   $0x804d4c
  802c73:	e8 18 d8 ff ff       	call   800490 <_panic>
  802c78:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802c7b:	8b 40 08             	mov    0x8(%eax),%eax
  802c7e:	85 c0                	test   %eax,%eax
  802c80:	74 11                	je     802c93 <sget+0x2e7>
  802c82:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802c85:	8b 40 08             	mov    0x8(%eax),%eax
  802c88:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802c8b:	8b 52 0c             	mov    0xc(%edx),%edx
  802c8e:	89 50 0c             	mov    %edx,0xc(%eax)
  802c91:	eb 0b                	jmp    802c9e <sget+0x2f2>
  802c93:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802c96:	8b 40 0c             	mov    0xc(%eax),%eax
  802c99:	a3 24 e1 81 00       	mov    %eax,0x81e124
  802c9e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802ca1:	8b 40 0c             	mov    0xc(%eax),%eax
  802ca4:	85 c0                	test   %eax,%eax
  802ca6:	74 11                	je     802cb9 <sget+0x30d>
  802ca8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802cab:	8b 40 0c             	mov    0xc(%eax),%eax
  802cae:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802cb1:	8b 52 08             	mov    0x8(%edx),%edx
  802cb4:	89 50 08             	mov    %edx,0x8(%eax)
  802cb7:	eb 0b                	jmp    802cc4 <sget+0x318>
  802cb9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802cbc:	8b 40 08             	mov    0x8(%eax),%eax
  802cbf:	a3 20 e1 81 00       	mov    %eax,0x81e120
  802cc4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802cc7:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802cce:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802cd1:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  802cd8:	a1 2c e1 81 00       	mov    0x81e12c,%eax
  802cdd:	48                   	dec    %eax
  802cde:	a3 2c e1 81 00       	mov    %eax,0x81e12c
							LIST_INSERT_BEFORE(&u_freelist ,currentfree2 ,lastfreeelement);
  802ce3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802ce7:	74 06                	je     802cef <sget+0x343>
  802ce9:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802ced:	75 17                	jne    802d06 <sget+0x35a>
  802cef:	83 ec 04             	sub    $0x4,%esp
  802cf2:	68 dc 4d 80 00       	push   $0x804ddc
  802cf7:	68 e9 01 00 00       	push   $0x1e9
  802cfc:	68 4c 4d 80 00       	push   $0x804d4c
  802d01:	e8 8a d7 ff ff       	call   800490 <_panic>
  802d06:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d09:	8b 50 0c             	mov    0xc(%eax),%edx
  802d0c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802d0f:	89 50 0c             	mov    %edx,0xc(%eax)
  802d12:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802d15:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802d18:	89 50 08             	mov    %edx,0x8(%eax)
  802d1b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d1e:	8b 40 0c             	mov    0xc(%eax),%eax
  802d21:	85 c0                	test   %eax,%eax
  802d23:	74 0e                	je     802d33 <sget+0x387>
  802d25:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d28:	8b 40 0c             	mov    0xc(%eax),%eax
  802d2b:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802d2e:	89 50 08             	mov    %edx,0x8(%eax)
  802d31:	eb 08                	jmp    802d3b <sget+0x38f>
  802d33:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802d36:	a3 20 e1 81 00       	mov    %eax,0x81e120
  802d3b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d3e:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802d41:	89 50 0c             	mov    %edx,0xc(%eax)
  802d44:	a1 2c e1 81 00       	mov    0x81e12c,%eax
  802d49:	40                   	inc    %eax
  802d4a:	a3 2c e1 81 00       	mov    %eax,0x81e12c
							break;
  802d4f:	eb 13                	jmp    802d64 <sget+0x3b8>
						}
						currentfree2 = currentfree2->prev_next_info.le_next;
  802d51:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d54:	8b 40 08             	mov    0x8(%eax),%eax
  802d57:	89 45 f0             	mov    %eax,-0x10(%ebp)
					lastfreeelement->startva += size;
					lastfreeelement->size -= size;
					struct UserHeapStruct* currentfree2 = LIST_FIRST(&u_freelist);
					//check order of last element

					while (currentfree2 != NULL){
  802d5a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802d5e:	0f 85 e3 fe ff ff    	jne    802c47 <sget+0x29b>
						}
						currentfree2 = currentfree2->prev_next_info.le_next;
					}


					int result = sys_get_shared_object(ownerEnvID ,sharedVarName ,(void*)allocblock->startva);
  802d64:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802d67:	8b 00                	mov    (%eax),%eax
  802d69:	83 ec 04             	sub    $0x4,%esp
  802d6c:	50                   	push   %eax
  802d6d:	ff 75 0c             	pushl  0xc(%ebp)
  802d70:	ff 75 08             	pushl  0x8(%ebp)
  802d73:	e8 70 04 00 00       	call   8031e8 <sys_get_shared_object>
  802d78:	83 c4 10             	add    $0x10,%esp
  802d7b:	89 45 d4             	mov    %eax,-0x2c(%ebp)

					if(result <0){
  802d7e:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  802d82:	79 28                	jns    802dac <sget+0x400>
						free_block(allocblock);
  802d84:	83 ec 0c             	sub    $0xc,%esp
  802d87:	ff 75 e0             	pushl  -0x20(%ebp)
  802d8a:	e8 b0 0e 00 00       	call   803c3f <free_block>
  802d8f:	83 c4 10             	add    $0x10,%esp
						release_uspinlock(&ulock);
  802d92:	83 ec 0c             	sub    $0xc,%esp
  802d95:	68 40 e1 81 00       	push   $0x81e140
  802d9a:	e8 82 13 00 00       	call   804121 <release_uspinlock>
  802d9f:	83 c4 10             	add    $0x10,%esp
						return NULL;
  802da2:	b8 00 00 00 00       	mov    $0x0,%eax
  802da7:	e9 bd 01 00 00       	jmp    802f69 <sget+0x5bd>
					}
					release_uspinlock(&ulock);
  802dac:	83 ec 0c             	sub    $0xc,%esp
  802daf:	68 40 e1 81 00       	push   $0x81e140
  802db4:	e8 68 13 00 00       	call   804121 <release_uspinlock>
  802db9:	83 c4 10             	add    $0x10,%esp
					return (void*)allocblock->startva;
  802dbc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802dbf:	8b 00                	mov    (%eax),%eax
  802dc1:	e9 a3 01 00 00       	jmp    802f69 <sget+0x5bd>
					//exact fit
				}else if(size == currentfreeelement->size){
  802dc6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dc9:	8b 50 04             	mov    0x4(%eax),%edx
  802dcc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802dcf:	39 c2                	cmp    %eax,%edx
  802dd1:	0f 85 5c 01 00 00    	jne    802f33 <sget+0x587>

					allocblock->startva = currentfreeelement->startva;
  802dd7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dda:	8b 10                	mov    (%eax),%edx
  802ddc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802ddf:	89 10                	mov    %edx,(%eax)
					allocblock->size = size;
  802de1:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802de4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802de7:	89 50 04             	mov    %edx,0x4(%eax)
					LIST_INSERT_TAIL(&u_allocatedlist ,allocblock);
  802dea:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802dee:	75 17                	jne    802e07 <sget+0x45b>
  802df0:	83 ec 04             	sub    $0x4,%esp
  802df3:	68 98 4d 80 00       	push   $0x804d98
  802df8:	68 fe 01 00 00       	push   $0x1fe
  802dfd:	68 4c 4d 80 00       	push   $0x804d4c
  802e02:	e8 89 d6 ff ff       	call   800490 <_panic>
  802e07:	8b 15 34 e1 81 00    	mov    0x81e134,%edx
  802e0d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802e10:	89 50 0c             	mov    %edx,0xc(%eax)
  802e13:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802e16:	8b 40 0c             	mov    0xc(%eax),%eax
  802e19:	85 c0                	test   %eax,%eax
  802e1b:	74 0d                	je     802e2a <sget+0x47e>
  802e1d:	a1 34 e1 81 00       	mov    0x81e134,%eax
  802e22:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802e25:	89 50 08             	mov    %edx,0x8(%eax)
  802e28:	eb 08                	jmp    802e32 <sget+0x486>
  802e2a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802e2d:	a3 30 e1 81 00       	mov    %eax,0x81e130
  802e32:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802e35:	a3 34 e1 81 00       	mov    %eax,0x81e134
  802e3a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802e3d:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802e44:	a1 3c e1 81 00       	mov    0x81e13c,%eax
  802e49:	40                   	inc    %eax
  802e4a:	a3 3c e1 81 00       	mov    %eax,0x81e13c
					LIST_REMOVE(&u_freelist ,currentfreeelement);
  802e4f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e53:	75 17                	jne    802e6c <sget+0x4c0>
  802e55:	83 ec 04             	sub    $0x4,%esp
  802e58:	68 bb 4d 80 00       	push   $0x804dbb
  802e5d:	68 ff 01 00 00       	push   $0x1ff
  802e62:	68 4c 4d 80 00       	push   $0x804d4c
  802e67:	e8 24 d6 ff ff       	call   800490 <_panic>
  802e6c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e6f:	8b 40 08             	mov    0x8(%eax),%eax
  802e72:	85 c0                	test   %eax,%eax
  802e74:	74 11                	je     802e87 <sget+0x4db>
  802e76:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e79:	8b 40 08             	mov    0x8(%eax),%eax
  802e7c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e7f:	8b 52 0c             	mov    0xc(%edx),%edx
  802e82:	89 50 0c             	mov    %edx,0xc(%eax)
  802e85:	eb 0b                	jmp    802e92 <sget+0x4e6>
  802e87:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e8a:	8b 40 0c             	mov    0xc(%eax),%eax
  802e8d:	a3 24 e1 81 00       	mov    %eax,0x81e124
  802e92:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e95:	8b 40 0c             	mov    0xc(%eax),%eax
  802e98:	85 c0                	test   %eax,%eax
  802e9a:	74 11                	je     802ead <sget+0x501>
  802e9c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e9f:	8b 40 0c             	mov    0xc(%eax),%eax
  802ea2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ea5:	8b 52 08             	mov    0x8(%edx),%edx
  802ea8:	89 50 08             	mov    %edx,0x8(%eax)
  802eab:	eb 0b                	jmp    802eb8 <sget+0x50c>
  802ead:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eb0:	8b 40 08             	mov    0x8(%eax),%eax
  802eb3:	a3 20 e1 81 00       	mov    %eax,0x81e120
  802eb8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ebb:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802ec2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ec5:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  802ecc:	a1 2c e1 81 00       	mov    0x81e12c,%eax
  802ed1:	48                   	dec    %eax
  802ed2:	a3 2c e1 81 00       	mov    %eax,0x81e12c

					int result = sys_get_shared_object(ownerEnvID ,sharedVarName ,(void*)allocblock->startva);
  802ed7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802eda:	8b 00                	mov    (%eax),%eax
  802edc:	83 ec 04             	sub    $0x4,%esp
  802edf:	50                   	push   %eax
  802ee0:	ff 75 0c             	pushl  0xc(%ebp)
  802ee3:	ff 75 08             	pushl  0x8(%ebp)
  802ee6:	e8 fd 02 00 00       	call   8031e8 <sys_get_shared_object>
  802eeb:	83 c4 10             	add    $0x10,%esp
  802eee:	89 45 d8             	mov    %eax,-0x28(%ebp)
					if(result <0){
  802ef1:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  802ef5:	79 25                	jns    802f1c <sget+0x570>
						free_block(allocblock);
  802ef7:	83 ec 0c             	sub    $0xc,%esp
  802efa:	ff 75 e0             	pushl  -0x20(%ebp)
  802efd:	e8 3d 0d 00 00       	call   803c3f <free_block>
  802f02:	83 c4 10             	add    $0x10,%esp
						release_uspinlock(&ulock);
  802f05:	83 ec 0c             	sub    $0xc,%esp
  802f08:	68 40 e1 81 00       	push   $0x81e140
  802f0d:	e8 0f 12 00 00       	call   804121 <release_uspinlock>
  802f12:	83 c4 10             	add    $0x10,%esp
						return NULL;
  802f15:	b8 00 00 00 00       	mov    $0x0,%eax
  802f1a:	eb 4d                	jmp    802f69 <sget+0x5bd>
					}

					release_uspinlock(&ulock);
  802f1c:	83 ec 0c             	sub    $0xc,%esp
  802f1f:	68 40 e1 81 00       	push   $0x81e140
  802f24:	e8 f8 11 00 00       	call   804121 <release_uspinlock>
  802f29:	83 c4 10             	add    $0x10,%esp
					return (void*)allocblock->startva;
  802f2c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802f2f:	8b 00                	mov    (%eax),%eax
  802f31:	eb 36                	jmp    802f69 <sget+0x5bd>
				}
				currentfreeelement = currentfreeelement->prev_next_info.le_next;
  802f33:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f36:	8b 40 08             	mov    0x8(%eax),%eax
  802f39:	89 45 f4             	mov    %eax,-0xc(%ebp)
					 }
		}else{
			//custom fit
			struct UserHeapStruct* currentfreeelement = LIST_FIRST(&u_freelist);
			//worst fit
			while(currentfreeelement != NULL){
  802f3c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f40:	0f 85 4b fc ff ff    	jne    802b91 <sget+0x1e5>
					return (void*)allocblock->startva;
				}
				currentfreeelement = currentfreeelement->prev_next_info.le_next;
			}
		}
		free_block(allocblock);
  802f46:	83 ec 0c             	sub    $0xc,%esp
  802f49:	ff 75 e0             	pushl  -0x20(%ebp)
  802f4c:	e8 ee 0c 00 00       	call   803c3f <free_block>
  802f51:	83 c4 10             	add    $0x10,%esp
		release_uspinlock(&ulock);
  802f54:	83 ec 0c             	sub    $0xc,%esp
  802f57:	68 40 e1 81 00       	push   $0x81e140
  802f5c:	e8 c0 11 00 00       	call   804121 <release_uspinlock>
  802f61:	83 c4 10             	add    $0x10,%esp
		return NULL;
  802f64:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802f69:	c9                   	leave  
  802f6a:	c3                   	ret    

00802f6b <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  802f6b:	55                   	push   %ebp
  802f6c:	89 e5                	mov    %esp,%ebp
  802f6e:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  802f71:	e8 cd e6 ff ff       	call   801643 <uheap_init>
	//==============================================================
	panic("realloc() is not implemented yet...!!");
  802f76:	83 ec 04             	sub    $0x4,%esp
  802f79:	68 6c 4e 80 00       	push   $0x804e6c
  802f7e:	68 2d 02 00 00       	push   $0x22d
  802f83:	68 4c 4d 80 00       	push   $0x804d4c
  802f88:	e8 03 d5 ff ff       	call   800490 <_panic>

00802f8d <sfree>:
//
//	use sys_delete_shared_object(...); which switches to the kernel mode,
//	calls delete_shared_object(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the delete_shared_object() function is empty, make sure to implement it.
void sfree(void* virtual_address)
{
  802f8d:	55                   	push   %ebp
  802f8e:	89 e5                	mov    %esp,%ebp
  802f90:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.BONUS#5] EXIT #2 - sfree
	//Your code is here
	//Comment the following line
	panic("sfree() is not implemented yet...!!");
  802f93:	83 ec 04             	sub    $0x4,%esp
  802f96:	68 94 4e 80 00       	push   $0x804e94
  802f9b:	68 40 02 00 00       	push   $0x240
  802fa0:	68 4c 4d 80 00       	push   $0x804d4c
  802fa5:	e8 e6 d4 ff ff       	call   800490 <_panic>

00802faa <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  802faa:	55                   	push   %ebp
  802fab:	89 e5                	mov    %esp,%ebp
  802fad:	57                   	push   %edi
  802fae:	56                   	push   %esi
  802faf:	53                   	push   %ebx
  802fb0:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  802fb3:	8b 45 08             	mov    0x8(%ebp),%eax
  802fb6:	8b 55 0c             	mov    0xc(%ebp),%edx
  802fb9:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802fbc:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802fbf:	8b 7d 18             	mov    0x18(%ebp),%edi
  802fc2:	8b 75 1c             	mov    0x1c(%ebp),%esi
  802fc5:	cd 30                	int    $0x30
  802fc7:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  802fca:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  802fcd:	83 c4 10             	add    $0x10,%esp
  802fd0:	5b                   	pop    %ebx
  802fd1:	5e                   	pop    %esi
  802fd2:	5f                   	pop    %edi
  802fd3:	5d                   	pop    %ebp
  802fd4:	c3                   	ret    

00802fd5 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  802fd5:	55                   	push   %ebp
  802fd6:	89 e5                	mov    %esp,%ebp
  802fd8:	83 ec 04             	sub    $0x4,%esp
  802fdb:	8b 45 10             	mov    0x10(%ebp),%eax
  802fde:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  802fe1:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802fe4:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802fe8:	8b 45 08             	mov    0x8(%ebp),%eax
  802feb:	6a 00                	push   $0x0
  802fed:	51                   	push   %ecx
  802fee:	52                   	push   %edx
  802fef:	ff 75 0c             	pushl  0xc(%ebp)
  802ff2:	50                   	push   %eax
  802ff3:	6a 00                	push   $0x0
  802ff5:	e8 b0 ff ff ff       	call   802faa <syscall>
  802ffa:	83 c4 18             	add    $0x18,%esp
}
  802ffd:	90                   	nop
  802ffe:	c9                   	leave  
  802fff:	c3                   	ret    

00803000 <sys_cgetc>:

int
sys_cgetc(void)
{
  803000:	55                   	push   %ebp
  803001:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  803003:	6a 00                	push   $0x0
  803005:	6a 00                	push   $0x0
  803007:	6a 00                	push   $0x0
  803009:	6a 00                	push   $0x0
  80300b:	6a 00                	push   $0x0
  80300d:	6a 02                	push   $0x2
  80300f:	e8 96 ff ff ff       	call   802faa <syscall>
  803014:	83 c4 18             	add    $0x18,%esp
}
  803017:	c9                   	leave  
  803018:	c3                   	ret    

00803019 <sys_lock_cons>:

void sys_lock_cons(void)
{
  803019:	55                   	push   %ebp
  80301a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  80301c:	6a 00                	push   $0x0
  80301e:	6a 00                	push   $0x0
  803020:	6a 00                	push   $0x0
  803022:	6a 00                	push   $0x0
  803024:	6a 00                	push   $0x0
  803026:	6a 03                	push   $0x3
  803028:	e8 7d ff ff ff       	call   802faa <syscall>
  80302d:	83 c4 18             	add    $0x18,%esp
}
  803030:	90                   	nop
  803031:	c9                   	leave  
  803032:	c3                   	ret    

00803033 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  803033:	55                   	push   %ebp
  803034:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  803036:	6a 00                	push   $0x0
  803038:	6a 00                	push   $0x0
  80303a:	6a 00                	push   $0x0
  80303c:	6a 00                	push   $0x0
  80303e:	6a 00                	push   $0x0
  803040:	6a 04                	push   $0x4
  803042:	e8 63 ff ff ff       	call   802faa <syscall>
  803047:	83 c4 18             	add    $0x18,%esp
}
  80304a:	90                   	nop
  80304b:	c9                   	leave  
  80304c:	c3                   	ret    

0080304d <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  80304d:	55                   	push   %ebp
  80304e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  803050:	8b 55 0c             	mov    0xc(%ebp),%edx
  803053:	8b 45 08             	mov    0x8(%ebp),%eax
  803056:	6a 00                	push   $0x0
  803058:	6a 00                	push   $0x0
  80305a:	6a 00                	push   $0x0
  80305c:	52                   	push   %edx
  80305d:	50                   	push   %eax
  80305e:	6a 08                	push   $0x8
  803060:	e8 45 ff ff ff       	call   802faa <syscall>
  803065:	83 c4 18             	add    $0x18,%esp
}
  803068:	c9                   	leave  
  803069:	c3                   	ret    

0080306a <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  80306a:	55                   	push   %ebp
  80306b:	89 e5                	mov    %esp,%ebp
  80306d:	56                   	push   %esi
  80306e:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  80306f:	8b 75 18             	mov    0x18(%ebp),%esi
  803072:	8b 5d 14             	mov    0x14(%ebp),%ebx
  803075:	8b 4d 10             	mov    0x10(%ebp),%ecx
  803078:	8b 55 0c             	mov    0xc(%ebp),%edx
  80307b:	8b 45 08             	mov    0x8(%ebp),%eax
  80307e:	56                   	push   %esi
  80307f:	53                   	push   %ebx
  803080:	51                   	push   %ecx
  803081:	52                   	push   %edx
  803082:	50                   	push   %eax
  803083:	6a 09                	push   $0x9
  803085:	e8 20 ff ff ff       	call   802faa <syscall>
  80308a:	83 c4 18             	add    $0x18,%esp
}
  80308d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  803090:	5b                   	pop    %ebx
  803091:	5e                   	pop    %esi
  803092:	5d                   	pop    %ebp
  803093:	c3                   	ret    

00803094 <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  803094:	55                   	push   %ebp
  803095:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  803097:	6a 00                	push   $0x0
  803099:	6a 00                	push   $0x0
  80309b:	6a 00                	push   $0x0
  80309d:	6a 00                	push   $0x0
  80309f:	ff 75 08             	pushl  0x8(%ebp)
  8030a2:	6a 0a                	push   $0xa
  8030a4:	e8 01 ff ff ff       	call   802faa <syscall>
  8030a9:	83 c4 18             	add    $0x18,%esp
}
  8030ac:	c9                   	leave  
  8030ad:	c3                   	ret    

008030ae <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8030ae:	55                   	push   %ebp
  8030af:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8030b1:	6a 00                	push   $0x0
  8030b3:	6a 00                	push   $0x0
  8030b5:	6a 00                	push   $0x0
  8030b7:	ff 75 0c             	pushl  0xc(%ebp)
  8030ba:	ff 75 08             	pushl  0x8(%ebp)
  8030bd:	6a 0b                	push   $0xb
  8030bf:	e8 e6 fe ff ff       	call   802faa <syscall>
  8030c4:	83 c4 18             	add    $0x18,%esp
}
  8030c7:	c9                   	leave  
  8030c8:	c3                   	ret    

008030c9 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8030c9:	55                   	push   %ebp
  8030ca:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8030cc:	6a 00                	push   $0x0
  8030ce:	6a 00                	push   $0x0
  8030d0:	6a 00                	push   $0x0
  8030d2:	6a 00                	push   $0x0
  8030d4:	6a 00                	push   $0x0
  8030d6:	6a 0c                	push   $0xc
  8030d8:	e8 cd fe ff ff       	call   802faa <syscall>
  8030dd:	83 c4 18             	add    $0x18,%esp
}
  8030e0:	c9                   	leave  
  8030e1:	c3                   	ret    

008030e2 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8030e2:	55                   	push   %ebp
  8030e3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8030e5:	6a 00                	push   $0x0
  8030e7:	6a 00                	push   $0x0
  8030e9:	6a 00                	push   $0x0
  8030eb:	6a 00                	push   $0x0
  8030ed:	6a 00                	push   $0x0
  8030ef:	6a 0d                	push   $0xd
  8030f1:	e8 b4 fe ff ff       	call   802faa <syscall>
  8030f6:	83 c4 18             	add    $0x18,%esp
}
  8030f9:	c9                   	leave  
  8030fa:	c3                   	ret    

008030fb <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8030fb:	55                   	push   %ebp
  8030fc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8030fe:	6a 00                	push   $0x0
  803100:	6a 00                	push   $0x0
  803102:	6a 00                	push   $0x0
  803104:	6a 00                	push   $0x0
  803106:	6a 00                	push   $0x0
  803108:	6a 0e                	push   $0xe
  80310a:	e8 9b fe ff ff       	call   802faa <syscall>
  80310f:	83 c4 18             	add    $0x18,%esp
}
  803112:	c9                   	leave  
  803113:	c3                   	ret    

00803114 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  803114:	55                   	push   %ebp
  803115:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  803117:	6a 00                	push   $0x0
  803119:	6a 00                	push   $0x0
  80311b:	6a 00                	push   $0x0
  80311d:	6a 00                	push   $0x0
  80311f:	6a 00                	push   $0x0
  803121:	6a 0f                	push   $0xf
  803123:	e8 82 fe ff ff       	call   802faa <syscall>
  803128:	83 c4 18             	add    $0x18,%esp
}
  80312b:	c9                   	leave  
  80312c:	c3                   	ret    

0080312d <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  80312d:	55                   	push   %ebp
  80312e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  803130:	6a 00                	push   $0x0
  803132:	6a 00                	push   $0x0
  803134:	6a 00                	push   $0x0
  803136:	6a 00                	push   $0x0
  803138:	ff 75 08             	pushl  0x8(%ebp)
  80313b:	6a 10                	push   $0x10
  80313d:	e8 68 fe ff ff       	call   802faa <syscall>
  803142:	83 c4 18             	add    $0x18,%esp
}
  803145:	c9                   	leave  
  803146:	c3                   	ret    

00803147 <sys_scarce_memory>:

void sys_scarce_memory()
{
  803147:	55                   	push   %ebp
  803148:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  80314a:	6a 00                	push   $0x0
  80314c:	6a 00                	push   $0x0
  80314e:	6a 00                	push   $0x0
  803150:	6a 00                	push   $0x0
  803152:	6a 00                	push   $0x0
  803154:	6a 11                	push   $0x11
  803156:	e8 4f fe ff ff       	call   802faa <syscall>
  80315b:	83 c4 18             	add    $0x18,%esp
}
  80315e:	90                   	nop
  80315f:	c9                   	leave  
  803160:	c3                   	ret    

00803161 <sys_cputc>:

void
sys_cputc(const char c)
{
  803161:	55                   	push   %ebp
  803162:	89 e5                	mov    %esp,%ebp
  803164:	83 ec 04             	sub    $0x4,%esp
  803167:	8b 45 08             	mov    0x8(%ebp),%eax
  80316a:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  80316d:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  803171:	6a 00                	push   $0x0
  803173:	6a 00                	push   $0x0
  803175:	6a 00                	push   $0x0
  803177:	6a 00                	push   $0x0
  803179:	50                   	push   %eax
  80317a:	6a 01                	push   $0x1
  80317c:	e8 29 fe ff ff       	call   802faa <syscall>
  803181:	83 c4 18             	add    $0x18,%esp
}
  803184:	90                   	nop
  803185:	c9                   	leave  
  803186:	c3                   	ret    

00803187 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  803187:	55                   	push   %ebp
  803188:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  80318a:	6a 00                	push   $0x0
  80318c:	6a 00                	push   $0x0
  80318e:	6a 00                	push   $0x0
  803190:	6a 00                	push   $0x0
  803192:	6a 00                	push   $0x0
  803194:	6a 14                	push   $0x14
  803196:	e8 0f fe ff ff       	call   802faa <syscall>
  80319b:	83 c4 18             	add    $0x18,%esp
}
  80319e:	90                   	nop
  80319f:	c9                   	leave  
  8031a0:	c3                   	ret    

008031a1 <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8031a1:	55                   	push   %ebp
  8031a2:	89 e5                	mov    %esp,%ebp
  8031a4:	83 ec 04             	sub    $0x4,%esp
  8031a7:	8b 45 10             	mov    0x10(%ebp),%eax
  8031aa:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8031ad:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8031b0:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8031b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8031b7:	6a 00                	push   $0x0
  8031b9:	51                   	push   %ecx
  8031ba:	52                   	push   %edx
  8031bb:	ff 75 0c             	pushl  0xc(%ebp)
  8031be:	50                   	push   %eax
  8031bf:	6a 15                	push   $0x15
  8031c1:	e8 e4 fd ff ff       	call   802faa <syscall>
  8031c6:	83 c4 18             	add    $0x18,%esp
}
  8031c9:	c9                   	leave  
  8031ca:	c3                   	ret    

008031cb <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  8031cb:	55                   	push   %ebp
  8031cc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8031ce:	8b 55 0c             	mov    0xc(%ebp),%edx
  8031d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8031d4:	6a 00                	push   $0x0
  8031d6:	6a 00                	push   $0x0
  8031d8:	6a 00                	push   $0x0
  8031da:	52                   	push   %edx
  8031db:	50                   	push   %eax
  8031dc:	6a 16                	push   $0x16
  8031de:	e8 c7 fd ff ff       	call   802faa <syscall>
  8031e3:	83 c4 18             	add    $0x18,%esp
}
  8031e6:	c9                   	leave  
  8031e7:	c3                   	ret    

008031e8 <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  8031e8:	55                   	push   %ebp
  8031e9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8031eb:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8031ee:	8b 55 0c             	mov    0xc(%ebp),%edx
  8031f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8031f4:	6a 00                	push   $0x0
  8031f6:	6a 00                	push   $0x0
  8031f8:	51                   	push   %ecx
  8031f9:	52                   	push   %edx
  8031fa:	50                   	push   %eax
  8031fb:	6a 17                	push   $0x17
  8031fd:	e8 a8 fd ff ff       	call   802faa <syscall>
  803202:	83 c4 18             	add    $0x18,%esp
}
  803205:	c9                   	leave  
  803206:	c3                   	ret    

00803207 <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  803207:	55                   	push   %ebp
  803208:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  80320a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80320d:	8b 45 08             	mov    0x8(%ebp),%eax
  803210:	6a 00                	push   $0x0
  803212:	6a 00                	push   $0x0
  803214:	6a 00                	push   $0x0
  803216:	52                   	push   %edx
  803217:	50                   	push   %eax
  803218:	6a 18                	push   $0x18
  80321a:	e8 8b fd ff ff       	call   802faa <syscall>
  80321f:	83 c4 18             	add    $0x18,%esp
}
  803222:	c9                   	leave  
  803223:	c3                   	ret    

00803224 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  803224:	55                   	push   %ebp
  803225:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  803227:	8b 45 08             	mov    0x8(%ebp),%eax
  80322a:	6a 00                	push   $0x0
  80322c:	ff 75 14             	pushl  0x14(%ebp)
  80322f:	ff 75 10             	pushl  0x10(%ebp)
  803232:	ff 75 0c             	pushl  0xc(%ebp)
  803235:	50                   	push   %eax
  803236:	6a 19                	push   $0x19
  803238:	e8 6d fd ff ff       	call   802faa <syscall>
  80323d:	83 c4 18             	add    $0x18,%esp
}
  803240:	c9                   	leave  
  803241:	c3                   	ret    

00803242 <sys_run_env>:

void sys_run_env(int32 envId)
{
  803242:	55                   	push   %ebp
  803243:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  803245:	8b 45 08             	mov    0x8(%ebp),%eax
  803248:	6a 00                	push   $0x0
  80324a:	6a 00                	push   $0x0
  80324c:	6a 00                	push   $0x0
  80324e:	6a 00                	push   $0x0
  803250:	50                   	push   %eax
  803251:	6a 1a                	push   $0x1a
  803253:	e8 52 fd ff ff       	call   802faa <syscall>
  803258:	83 c4 18             	add    $0x18,%esp
}
  80325b:	90                   	nop
  80325c:	c9                   	leave  
  80325d:	c3                   	ret    

0080325e <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  80325e:	55                   	push   %ebp
  80325f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  803261:	8b 45 08             	mov    0x8(%ebp),%eax
  803264:	6a 00                	push   $0x0
  803266:	6a 00                	push   $0x0
  803268:	6a 00                	push   $0x0
  80326a:	6a 00                	push   $0x0
  80326c:	50                   	push   %eax
  80326d:	6a 1b                	push   $0x1b
  80326f:	e8 36 fd ff ff       	call   802faa <syscall>
  803274:	83 c4 18             	add    $0x18,%esp
}
  803277:	c9                   	leave  
  803278:	c3                   	ret    

00803279 <sys_getenvid>:

int32 sys_getenvid(void)
{
  803279:	55                   	push   %ebp
  80327a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  80327c:	6a 00                	push   $0x0
  80327e:	6a 00                	push   $0x0
  803280:	6a 00                	push   $0x0
  803282:	6a 00                	push   $0x0
  803284:	6a 00                	push   $0x0
  803286:	6a 05                	push   $0x5
  803288:	e8 1d fd ff ff       	call   802faa <syscall>
  80328d:	83 c4 18             	add    $0x18,%esp
}
  803290:	c9                   	leave  
  803291:	c3                   	ret    

00803292 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  803292:	55                   	push   %ebp
  803293:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  803295:	6a 00                	push   $0x0
  803297:	6a 00                	push   $0x0
  803299:	6a 00                	push   $0x0
  80329b:	6a 00                	push   $0x0
  80329d:	6a 00                	push   $0x0
  80329f:	6a 06                	push   $0x6
  8032a1:	e8 04 fd ff ff       	call   802faa <syscall>
  8032a6:	83 c4 18             	add    $0x18,%esp
}
  8032a9:	c9                   	leave  
  8032aa:	c3                   	ret    

008032ab <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8032ab:	55                   	push   %ebp
  8032ac:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8032ae:	6a 00                	push   $0x0
  8032b0:	6a 00                	push   $0x0
  8032b2:	6a 00                	push   $0x0
  8032b4:	6a 00                	push   $0x0
  8032b6:	6a 00                	push   $0x0
  8032b8:	6a 07                	push   $0x7
  8032ba:	e8 eb fc ff ff       	call   802faa <syscall>
  8032bf:	83 c4 18             	add    $0x18,%esp
}
  8032c2:	c9                   	leave  
  8032c3:	c3                   	ret    

008032c4 <sys_exit_env>:


void sys_exit_env(void)
{
  8032c4:	55                   	push   %ebp
  8032c5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  8032c7:	6a 00                	push   $0x0
  8032c9:	6a 00                	push   $0x0
  8032cb:	6a 00                	push   $0x0
  8032cd:	6a 00                	push   $0x0
  8032cf:	6a 00                	push   $0x0
  8032d1:	6a 1c                	push   $0x1c
  8032d3:	e8 d2 fc ff ff       	call   802faa <syscall>
  8032d8:	83 c4 18             	add    $0x18,%esp
}
  8032db:	90                   	nop
  8032dc:	c9                   	leave  
  8032dd:	c3                   	ret    

008032de <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  8032de:	55                   	push   %ebp
  8032df:	89 e5                	mov    %esp,%ebp
  8032e1:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8032e4:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8032e7:	8d 50 04             	lea    0x4(%eax),%edx
  8032ea:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8032ed:	6a 00                	push   $0x0
  8032ef:	6a 00                	push   $0x0
  8032f1:	6a 00                	push   $0x0
  8032f3:	52                   	push   %edx
  8032f4:	50                   	push   %eax
  8032f5:	6a 1d                	push   $0x1d
  8032f7:	e8 ae fc ff ff       	call   802faa <syscall>
  8032fc:	83 c4 18             	add    $0x18,%esp
	return result;
  8032ff:	8b 4d 08             	mov    0x8(%ebp),%ecx
  803302:	8b 45 f8             	mov    -0x8(%ebp),%eax
  803305:	8b 55 fc             	mov    -0x4(%ebp),%edx
  803308:	89 01                	mov    %eax,(%ecx)
  80330a:	89 51 04             	mov    %edx,0x4(%ecx)
}
  80330d:	8b 45 08             	mov    0x8(%ebp),%eax
  803310:	c9                   	leave  
  803311:	c2 04 00             	ret    $0x4

00803314 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  803314:	55                   	push   %ebp
  803315:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  803317:	6a 00                	push   $0x0
  803319:	6a 00                	push   $0x0
  80331b:	ff 75 10             	pushl  0x10(%ebp)
  80331e:	ff 75 0c             	pushl  0xc(%ebp)
  803321:	ff 75 08             	pushl  0x8(%ebp)
  803324:	6a 13                	push   $0x13
  803326:	e8 7f fc ff ff       	call   802faa <syscall>
  80332b:	83 c4 18             	add    $0x18,%esp
	return ;
  80332e:	90                   	nop
}
  80332f:	c9                   	leave  
  803330:	c3                   	ret    

00803331 <sys_rcr2>:
uint32 sys_rcr2()
{
  803331:	55                   	push   %ebp
  803332:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  803334:	6a 00                	push   $0x0
  803336:	6a 00                	push   $0x0
  803338:	6a 00                	push   $0x0
  80333a:	6a 00                	push   $0x0
  80333c:	6a 00                	push   $0x0
  80333e:	6a 1e                	push   $0x1e
  803340:	e8 65 fc ff ff       	call   802faa <syscall>
  803345:	83 c4 18             	add    $0x18,%esp
}
  803348:	c9                   	leave  
  803349:	c3                   	ret    

0080334a <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  80334a:	55                   	push   %ebp
  80334b:	89 e5                	mov    %esp,%ebp
  80334d:	83 ec 04             	sub    $0x4,%esp
  803350:	8b 45 08             	mov    0x8(%ebp),%eax
  803353:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  803356:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  80335a:	6a 00                	push   $0x0
  80335c:	6a 00                	push   $0x0
  80335e:	6a 00                	push   $0x0
  803360:	6a 00                	push   $0x0
  803362:	50                   	push   %eax
  803363:	6a 1f                	push   $0x1f
  803365:	e8 40 fc ff ff       	call   802faa <syscall>
  80336a:	83 c4 18             	add    $0x18,%esp
	return ;
  80336d:	90                   	nop
}
  80336e:	c9                   	leave  
  80336f:	c3                   	ret    

00803370 <rsttst>:
void rsttst()
{
  803370:	55                   	push   %ebp
  803371:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  803373:	6a 00                	push   $0x0
  803375:	6a 00                	push   $0x0
  803377:	6a 00                	push   $0x0
  803379:	6a 00                	push   $0x0
  80337b:	6a 00                	push   $0x0
  80337d:	6a 21                	push   $0x21
  80337f:	e8 26 fc ff ff       	call   802faa <syscall>
  803384:	83 c4 18             	add    $0x18,%esp
	return ;
  803387:	90                   	nop
}
  803388:	c9                   	leave  
  803389:	c3                   	ret    

0080338a <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  80338a:	55                   	push   %ebp
  80338b:	89 e5                	mov    %esp,%ebp
  80338d:	83 ec 04             	sub    $0x4,%esp
  803390:	8b 45 14             	mov    0x14(%ebp),%eax
  803393:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  803396:	8b 55 18             	mov    0x18(%ebp),%edx
  803399:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80339d:	52                   	push   %edx
  80339e:	50                   	push   %eax
  80339f:	ff 75 10             	pushl  0x10(%ebp)
  8033a2:	ff 75 0c             	pushl  0xc(%ebp)
  8033a5:	ff 75 08             	pushl  0x8(%ebp)
  8033a8:	6a 20                	push   $0x20
  8033aa:	e8 fb fb ff ff       	call   802faa <syscall>
  8033af:	83 c4 18             	add    $0x18,%esp
	return ;
  8033b2:	90                   	nop
}
  8033b3:	c9                   	leave  
  8033b4:	c3                   	ret    

008033b5 <chktst>:
void chktst(uint32 n)
{
  8033b5:	55                   	push   %ebp
  8033b6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8033b8:	6a 00                	push   $0x0
  8033ba:	6a 00                	push   $0x0
  8033bc:	6a 00                	push   $0x0
  8033be:	6a 00                	push   $0x0
  8033c0:	ff 75 08             	pushl  0x8(%ebp)
  8033c3:	6a 22                	push   $0x22
  8033c5:	e8 e0 fb ff ff       	call   802faa <syscall>
  8033ca:	83 c4 18             	add    $0x18,%esp
	return ;
  8033cd:	90                   	nop
}
  8033ce:	c9                   	leave  
  8033cf:	c3                   	ret    

008033d0 <inctst>:

void inctst()
{
  8033d0:	55                   	push   %ebp
  8033d1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8033d3:	6a 00                	push   $0x0
  8033d5:	6a 00                	push   $0x0
  8033d7:	6a 00                	push   $0x0
  8033d9:	6a 00                	push   $0x0
  8033db:	6a 00                	push   $0x0
  8033dd:	6a 23                	push   $0x23
  8033df:	e8 c6 fb ff ff       	call   802faa <syscall>
  8033e4:	83 c4 18             	add    $0x18,%esp
	return ;
  8033e7:	90                   	nop
}
  8033e8:	c9                   	leave  
  8033e9:	c3                   	ret    

008033ea <gettst>:
uint32 gettst()
{
  8033ea:	55                   	push   %ebp
  8033eb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8033ed:	6a 00                	push   $0x0
  8033ef:	6a 00                	push   $0x0
  8033f1:	6a 00                	push   $0x0
  8033f3:	6a 00                	push   $0x0
  8033f5:	6a 00                	push   $0x0
  8033f7:	6a 24                	push   $0x24
  8033f9:	e8 ac fb ff ff       	call   802faa <syscall>
  8033fe:	83 c4 18             	add    $0x18,%esp
}
  803401:	c9                   	leave  
  803402:	c3                   	ret    

00803403 <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  803403:	55                   	push   %ebp
  803404:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  803406:	6a 00                	push   $0x0
  803408:	6a 00                	push   $0x0
  80340a:	6a 00                	push   $0x0
  80340c:	6a 00                	push   $0x0
  80340e:	6a 00                	push   $0x0
  803410:	6a 25                	push   $0x25
  803412:	e8 93 fb ff ff       	call   802faa <syscall>
  803417:	83 c4 18             	add    $0x18,%esp
  80341a:	a3 60 e0 81 00       	mov    %eax,0x81e060
	return uheapPlaceStrategy ;
  80341f:	a1 60 e0 81 00       	mov    0x81e060,%eax
}
  803424:	c9                   	leave  
  803425:	c3                   	ret    

00803426 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  803426:	55                   	push   %ebp
  803427:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  803429:	8b 45 08             	mov    0x8(%ebp),%eax
  80342c:	a3 60 e0 81 00       	mov    %eax,0x81e060
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  803431:	6a 00                	push   $0x0
  803433:	6a 00                	push   $0x0
  803435:	6a 00                	push   $0x0
  803437:	6a 00                	push   $0x0
  803439:	ff 75 08             	pushl  0x8(%ebp)
  80343c:	6a 26                	push   $0x26
  80343e:	e8 67 fb ff ff       	call   802faa <syscall>
  803443:	83 c4 18             	add    $0x18,%esp
	return ;
  803446:	90                   	nop
}
  803447:	c9                   	leave  
  803448:	c3                   	ret    

00803449 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  803449:	55                   	push   %ebp
  80344a:	89 e5                	mov    %esp,%ebp
  80344c:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  80344d:	8b 5d 14             	mov    0x14(%ebp),%ebx
  803450:	8b 4d 10             	mov    0x10(%ebp),%ecx
  803453:	8b 55 0c             	mov    0xc(%ebp),%edx
  803456:	8b 45 08             	mov    0x8(%ebp),%eax
  803459:	6a 00                	push   $0x0
  80345b:	53                   	push   %ebx
  80345c:	51                   	push   %ecx
  80345d:	52                   	push   %edx
  80345e:	50                   	push   %eax
  80345f:	6a 27                	push   $0x27
  803461:	e8 44 fb ff ff       	call   802faa <syscall>
  803466:	83 c4 18             	add    $0x18,%esp
}
  803469:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80346c:	c9                   	leave  
  80346d:	c3                   	ret    

0080346e <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  80346e:	55                   	push   %ebp
  80346f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  803471:	8b 55 0c             	mov    0xc(%ebp),%edx
  803474:	8b 45 08             	mov    0x8(%ebp),%eax
  803477:	6a 00                	push   $0x0
  803479:	6a 00                	push   $0x0
  80347b:	6a 00                	push   $0x0
  80347d:	52                   	push   %edx
  80347e:	50                   	push   %eax
  80347f:	6a 28                	push   $0x28
  803481:	e8 24 fb ff ff       	call   802faa <syscall>
  803486:	83 c4 18             	add    $0x18,%esp
}
  803489:	c9                   	leave  
  80348a:	c3                   	ret    

0080348b <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  80348b:	55                   	push   %ebp
  80348c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  80348e:	8b 4d 14             	mov    0x14(%ebp),%ecx
  803491:	8b 55 0c             	mov    0xc(%ebp),%edx
  803494:	8b 45 08             	mov    0x8(%ebp),%eax
  803497:	6a 00                	push   $0x0
  803499:	51                   	push   %ecx
  80349a:	ff 75 10             	pushl  0x10(%ebp)
  80349d:	52                   	push   %edx
  80349e:	50                   	push   %eax
  80349f:	6a 29                	push   $0x29
  8034a1:	e8 04 fb ff ff       	call   802faa <syscall>
  8034a6:	83 c4 18             	add    $0x18,%esp
}
  8034a9:	c9                   	leave  
  8034aa:	c3                   	ret    

008034ab <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8034ab:	55                   	push   %ebp
  8034ac:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8034ae:	6a 00                	push   $0x0
  8034b0:	6a 00                	push   $0x0
  8034b2:	ff 75 10             	pushl  0x10(%ebp)
  8034b5:	ff 75 0c             	pushl  0xc(%ebp)
  8034b8:	ff 75 08             	pushl  0x8(%ebp)
  8034bb:	6a 12                	push   $0x12
  8034bd:	e8 e8 fa ff ff       	call   802faa <syscall>
  8034c2:	83 c4 18             	add    $0x18,%esp
	return ;
  8034c5:	90                   	nop
}
  8034c6:	c9                   	leave  
  8034c7:	c3                   	ret    

008034c8 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  8034c8:	55                   	push   %ebp
  8034c9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  8034cb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8034ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8034d1:	6a 00                	push   $0x0
  8034d3:	6a 00                	push   $0x0
  8034d5:	6a 00                	push   $0x0
  8034d7:	52                   	push   %edx
  8034d8:	50                   	push   %eax
  8034d9:	6a 2a                	push   $0x2a
  8034db:	e8 ca fa ff ff       	call   802faa <syscall>
  8034e0:	83 c4 18             	add    $0x18,%esp
	return;
  8034e3:	90                   	nop
}
  8034e4:	c9                   	leave  
  8034e5:	c3                   	ret    

008034e6 <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  8034e6:	55                   	push   %ebp
  8034e7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  8034e9:	6a 00                	push   $0x0
  8034eb:	6a 00                	push   $0x0
  8034ed:	6a 00                	push   $0x0
  8034ef:	6a 00                	push   $0x0
  8034f1:	6a 00                	push   $0x0
  8034f3:	6a 2b                	push   $0x2b
  8034f5:	e8 b0 fa ff ff       	call   802faa <syscall>
  8034fa:	83 c4 18             	add    $0x18,%esp
}
  8034fd:	c9                   	leave  
  8034fe:	c3                   	ret    

008034ff <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8034ff:	55                   	push   %ebp
  803500:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  803502:	6a 00                	push   $0x0
  803504:	6a 00                	push   $0x0
  803506:	6a 00                	push   $0x0
  803508:	ff 75 0c             	pushl  0xc(%ebp)
  80350b:	ff 75 08             	pushl  0x8(%ebp)
  80350e:	6a 2d                	push   $0x2d
  803510:	e8 95 fa ff ff       	call   802faa <syscall>
  803515:	83 c4 18             	add    $0x18,%esp
	return;
  803518:	90                   	nop
}
  803519:	c9                   	leave  
  80351a:	c3                   	ret    

0080351b <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  80351b:	55                   	push   %ebp
  80351c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  80351e:	6a 00                	push   $0x0
  803520:	6a 00                	push   $0x0
  803522:	6a 00                	push   $0x0
  803524:	ff 75 0c             	pushl  0xc(%ebp)
  803527:	ff 75 08             	pushl  0x8(%ebp)
  80352a:	6a 2c                	push   $0x2c
  80352c:	e8 79 fa ff ff       	call   802faa <syscall>
  803531:	83 c4 18             	add    $0x18,%esp
	return ;
  803534:	90                   	nop
}
  803535:	c9                   	leave  
  803536:	c3                   	ret    

00803537 <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  803537:	55                   	push   %ebp
  803538:	89 e5                	mov    %esp,%ebp
	//TODO: [PROJECT'25.IM#4] CPU SCHEDULING - #1 System Calls - Add suitable code here
	//Your code is here
	//Comment the following line
	//panic("sys_env_set_priority() is not implemented yet...!!");
	syscall(SYS_env_set_priority, envID, priority, 0, 0, 0);
  80353a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80353d:	8b 45 08             	mov    0x8(%ebp),%eax
  803540:	6a 00                	push   $0x0
  803542:	6a 00                	push   $0x0
  803544:	6a 00                	push   $0x0
  803546:	52                   	push   %edx
  803547:	50                   	push   %eax
  803548:	6a 2e                	push   $0x2e
  80354a:	e8 5b fa ff ff       	call   802faa <syscall>
  80354f:	83 c4 18             	add    $0x18,%esp
	    return;
  803552:	90                   	nop
}
  803553:	c9                   	leave  
  803554:	c3                   	ret    

00803555 <to_page_va>:
//==================================================================================//
//==================================
// [1] GET PAGE VA:
//==================================
__inline__ uint32 to_page_va(struct PageInfoElement *ptrPageInfo)
{
  803555:	55                   	push   %ebp
  803556:	89 e5                	mov    %esp,%ebp
  803558:	83 ec 10             	sub    $0x10,%esp
	//Get start VA of the page from the corresponding Page Info pointer
	int idxInPageInfoArr = (ptrPageInfo - pageBlockInfoArr);
  80355b:	8b 45 08             	mov    0x8(%ebp),%eax
  80355e:	ba 60 60 80 00       	mov    $0x806060,%edx
  803563:	29 d0                	sub    %edx,%eax
  803565:	c1 f8 02             	sar    $0x2,%eax
  803568:	89 c2                	mov    %eax,%edx
  80356a:	89 d0                	mov    %edx,%eax
  80356c:	c1 e0 02             	shl    $0x2,%eax
  80356f:	01 d0                	add    %edx,%eax
  803571:	c1 e0 02             	shl    $0x2,%eax
  803574:	01 d0                	add    %edx,%eax
  803576:	c1 e0 02             	shl    $0x2,%eax
  803579:	01 d0                	add    %edx,%eax
  80357b:	89 c1                	mov    %eax,%ecx
  80357d:	c1 e1 08             	shl    $0x8,%ecx
  803580:	01 c8                	add    %ecx,%eax
  803582:	89 c1                	mov    %eax,%ecx
  803584:	c1 e1 10             	shl    $0x10,%ecx
  803587:	01 c8                	add    %ecx,%eax
  803589:	01 c0                	add    %eax,%eax
  80358b:	01 d0                	add    %edx,%eax
  80358d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return dynAllocStart + (idxInPageInfoArr << PGSHIFT);
  803590:	8b 45 fc             	mov    -0x4(%ebp),%eax
  803593:	c1 e0 0c             	shl    $0xc,%eax
  803596:	89 c2                	mov    %eax,%edx
  803598:	a1 64 e0 81 00       	mov    0x81e064,%eax
  80359d:	01 d0                	add    %edx,%eax
}
  80359f:	c9                   	leave  
  8035a0:	c3                   	ret    

008035a1 <log2>:

//==================================================================================//
//============================ REQUIRED FUNCTIONS ==================================//
//==================================================================================//
__inline__ int log2(uint32 n)
	{
  8035a1:	55                   	push   %ebp
  8035a2:	89 e5                	mov    %esp,%ebp
  8035a4:	83 ec 10             	sub    $0x10,%esp
		int result = 0;
  8035a7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
		while( n > 1){
  8035ae:	eb 06                	jmp    8035b6 <log2+0x15>
			n >>=1;
  8035b0:	d1 6d 08             	shrl   0x8(%ebp)
			result++;
  8035b3:	ff 45 fc             	incl   -0x4(%ebp)
//============================ REQUIRED FUNCTIONS ==================================//
//==================================================================================//
__inline__ int log2(uint32 n)
	{
		int result = 0;
		while( n > 1){
  8035b6:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
  8035ba:	77 f4                	ja     8035b0 <log2+0xf>
			n >>=1;
			result++;
		}
		return result;
  8035bc:	8b 45 fc             	mov    -0x4(%ebp),%eax
	}
  8035bf:	c9                   	leave  
  8035c0:	c3                   	ret    

008035c1 <initialize_dynamic_allocator>:
//==================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================
bool is_initialized = 0;
void initialize_dynamic_allocator(uint32 daStart, uint32 daEnd)
{
  8035c1:	55                   	push   %ebp
  8035c2:	89 e5                	mov    %esp,%ebp
  8035c4:	83 ec 18             	sub    $0x18,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(daEnd <= daStart + DYN_ALLOC_MAX_SIZE);
  8035c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8035ca:	05 00 00 00 02       	add    $0x2000000,%eax
  8035cf:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8035d2:	73 16                	jae    8035ea <initialize_dynamic_allocator+0x29>
  8035d4:	68 b8 4e 80 00       	push   $0x804eb8
  8035d9:	68 de 4e 80 00       	push   $0x804ede
  8035de:	6a 2d                	push   $0x2d
  8035e0:	68 f3 4e 80 00       	push   $0x804ef3
  8035e5:	e8 a6 ce ff ff       	call   800490 <_panic>
		is_initialized = 1;
  8035ea:	c7 05 24 60 80 00 01 	movl   $0x1,0x806024
  8035f1:	00 00 00 
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #1 initialize_dynamic_allocator
	//Your code is here


	dynAllocStart = daStart;
  8035f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8035f7:	a3 64 e0 81 00       	mov    %eax,0x81e064
	dynAllocEnd= daEnd;
  8035fc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8035ff:	a3 40 60 80 00       	mov    %eax,0x806040
	int numOfPages = (dynAllocEnd - dynAllocStart)/PAGE_SIZE;
  803604:	8b 15 40 60 80 00    	mov    0x806040,%edx
  80360a:	a1 64 e0 81 00       	mov    0x81e064,%eax
  80360f:	29 c2                	sub    %eax,%edx
  803611:	89 d0                	mov    %edx,%eax
  803613:	c1 e8 0c             	shr    $0xc,%eax
  803616:	89 45 e8             	mov    %eax,-0x18(%ebp)


	for(int i=0; i< numOfPages; i++){
  803619:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  803620:	eb 2f                	jmp    803651 <initialize_dynamic_allocator+0x90>
	    pageBlockInfoArr[i].block_size=0;
  803622:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803625:	89 d0                	mov    %edx,%eax
  803627:	01 c0                	add    %eax,%eax
  803629:	01 d0                	add    %edx,%eax
  80362b:	c1 e0 02             	shl    $0x2,%eax
  80362e:	05 68 60 80 00       	add    $0x806068,%eax
  803633:	66 c7 00 00 00       	movw   $0x0,(%eax)
	    pageBlockInfoArr[i].num_of_free_blocks=0;
  803638:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80363b:	89 d0                	mov    %edx,%eax
  80363d:	01 c0                	add    %eax,%eax
  80363f:	01 d0                	add    %edx,%eax
  803641:	c1 e0 02             	shl    $0x2,%eax
  803644:	05 6a 60 80 00       	add    $0x80606a,%eax
  803649:	66 c7 00 00 00       	movw   $0x0,(%eax)
	dynAllocStart = daStart;
	dynAllocEnd= daEnd;
	int numOfPages = (dynAllocEnd - dynAllocStart)/PAGE_SIZE;


	for(int i=0; i< numOfPages; i++){
  80364e:	ff 45 f4             	incl   -0xc(%ebp)
  803651:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803654:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803657:	7c c9                	jl     803622 <initialize_dynamic_allocator+0x61>
	    pageBlockInfoArr[i].block_size=0;
	    pageBlockInfoArr[i].num_of_free_blocks=0;
	}


	LIST_INIT(&freePagesList);
  803659:	c7 05 48 60 80 00 00 	movl   $0x0,0x806048
  803660:	00 00 00 
  803663:	c7 05 4c 60 80 00 00 	movl   $0x0,0x80604c
  80366a:	00 00 00 
  80366d:	c7 05 54 60 80 00 00 	movl   $0x0,0x806054
  803674:	00 00 00 
	for(int i=0; i<numOfPages; i++){
  803677:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80367e:	e9 9c 00 00 00       	jmp    80371f <initialize_dynamic_allocator+0x15e>
		LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
  803683:	8b 15 4c 60 80 00    	mov    0x80604c,%edx
  803689:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80368c:	89 c8                	mov    %ecx,%eax
  80368e:	01 c0                	add    %eax,%eax
  803690:	01 c8                	add    %ecx,%eax
  803692:	c1 e0 02             	shl    $0x2,%eax
  803695:	05 64 60 80 00       	add    $0x806064,%eax
  80369a:	89 10                	mov    %edx,(%eax)
  80369c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80369f:	89 d0                	mov    %edx,%eax
  8036a1:	01 c0                	add    %eax,%eax
  8036a3:	01 d0                	add    %edx,%eax
  8036a5:	c1 e0 02             	shl    $0x2,%eax
  8036a8:	05 64 60 80 00       	add    $0x806064,%eax
  8036ad:	8b 00                	mov    (%eax),%eax
  8036af:	85 c0                	test   %eax,%eax
  8036b1:	74 1b                	je     8036ce <initialize_dynamic_allocator+0x10d>
  8036b3:	8b 15 4c 60 80 00    	mov    0x80604c,%edx
  8036b9:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8036bc:	89 c8                	mov    %ecx,%eax
  8036be:	01 c0                	add    %eax,%eax
  8036c0:	01 c8                	add    %ecx,%eax
  8036c2:	c1 e0 02             	shl    $0x2,%eax
  8036c5:	05 60 60 80 00       	add    $0x806060,%eax
  8036ca:	89 02                	mov    %eax,(%edx)
  8036cc:	eb 16                	jmp    8036e4 <initialize_dynamic_allocator+0x123>
  8036ce:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8036d1:	89 d0                	mov    %edx,%eax
  8036d3:	01 c0                	add    %eax,%eax
  8036d5:	01 d0                	add    %edx,%eax
  8036d7:	c1 e0 02             	shl    $0x2,%eax
  8036da:	05 60 60 80 00       	add    $0x806060,%eax
  8036df:	a3 48 60 80 00       	mov    %eax,0x806048
  8036e4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8036e7:	89 d0                	mov    %edx,%eax
  8036e9:	01 c0                	add    %eax,%eax
  8036eb:	01 d0                	add    %edx,%eax
  8036ed:	c1 e0 02             	shl    $0x2,%eax
  8036f0:	05 60 60 80 00       	add    $0x806060,%eax
  8036f5:	a3 4c 60 80 00       	mov    %eax,0x80604c
  8036fa:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8036fd:	89 d0                	mov    %edx,%eax
  8036ff:	01 c0                	add    %eax,%eax
  803701:	01 d0                	add    %edx,%eax
  803703:	c1 e0 02             	shl    $0x2,%eax
  803706:	05 60 60 80 00       	add    $0x806060,%eax
  80370b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803711:	a1 54 60 80 00       	mov    0x806054,%eax
  803716:	40                   	inc    %eax
  803717:	a3 54 60 80 00       	mov    %eax,0x806054
	    pageBlockInfoArr[i].num_of_free_blocks=0;
	}


	LIST_INIT(&freePagesList);
	for(int i=0; i<numOfPages; i++){
  80371c:	ff 45 f0             	incl   -0x10(%ebp)
  80371f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803722:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803725:	0f 8c 58 ff ff ff    	jl     803683 <initialize_dynamic_allocator+0xc2>
		LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
	}



	for (int i = 0; i < LOG2_MAX_SIZE - LOG2_MIN_SIZE + 1; i++) {
  80372b:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  803732:	eb 36                	jmp    80376a <initialize_dynamic_allocator+0x1a9>
	    LIST_INIT(&freeBlockLists[i]);
  803734:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803737:	c1 e0 04             	shl    $0x4,%eax
  80373a:	05 80 e0 81 00       	add    $0x81e080,%eax
  80373f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803745:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803748:	c1 e0 04             	shl    $0x4,%eax
  80374b:	05 84 e0 81 00       	add    $0x81e084,%eax
  803750:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803756:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803759:	c1 e0 04             	shl    $0x4,%eax
  80375c:	05 8c e0 81 00       	add    $0x81e08c,%eax
  803761:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
	}



	for (int i = 0; i < LOG2_MAX_SIZE - LOG2_MIN_SIZE + 1; i++) {
  803767:	ff 45 ec             	incl   -0x14(%ebp)
  80376a:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  80376e:	7e c4                	jle    803734 <initialize_dynamic_allocator+0x173>


	//Comment the following line
	//panic("initialize_dynamic_allocator() Not implemented yet");

}
  803770:	90                   	nop
  803771:	c9                   	leave  
  803772:	c3                   	ret    

00803773 <get_block_size>:
// [2] GET BLOCK SIZE:
//===========================


__inline__ uint32 get_block_size(void *va)
{
  803773:	55                   	push   %ebp
  803774:	89 e5                	mov    %esp,%ebp
  803776:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #2 get_block_size
	//Your code is here

	uint32 page_index = ((uint32)va - dynAllocStart)/ PAGE_SIZE;
  803779:	8b 55 08             	mov    0x8(%ebp),%edx
  80377c:	a1 64 e0 81 00       	mov    0x81e064,%eax
  803781:	29 c2                	sub    %eax,%edx
  803783:	89 d0                	mov    %edx,%eax
  803785:	c1 e8 0c             	shr    $0xc,%eax
  803788:	89 45 fc             	mov    %eax,-0x4(%ebp)
    return pageBlockInfoArr[page_index].block_size;
  80378b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80378e:	89 d0                	mov    %edx,%eax
  803790:	01 c0                	add    %eax,%eax
  803792:	01 d0                	add    %edx,%eax
  803794:	c1 e0 02             	shl    $0x2,%eax
  803797:	05 68 60 80 00       	add    $0x806068,%eax
  80379c:	8b 00                	mov    (%eax),%eax
  80379e:	0f b7 c0             	movzwl %ax,%eax
	//Comment the following line
	//panic("get_block_size() Not implemented yet");
}
  8037a1:	c9                   	leave  
  8037a2:	c3                   	ret    

008037a3 <alloc_block>:

//===========================
// 3) ALLOCATE BLOCK:
//===========================
void *alloc_block(uint32 size)
{
  8037a3:	55                   	push   %ebp
  8037a4:	89 e5                	mov    %esp,%ebp
  8037a6:	83 ec 48             	sub    $0x48,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(size <= DYN_ALLOC_MAX_BLOCK_SIZE);
  8037a9:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  8037b0:	76 16                	jbe    8037c8 <alloc_block+0x25>
  8037b2:	68 0c 4f 80 00       	push   $0x804f0c
  8037b7:	68 de 4e 80 00       	push   $0x804ede
  8037bc:	6a 6c                	push   $0x6c
  8037be:	68 f3 4e 80 00       	push   $0x804ef3
  8037c3:	e8 c8 cc ff ff       	call   800490 <_panic>
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #3 alloc_block
	//Your code is here


	if(size == 0){
  8037c8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8037cc:	75 0a                	jne    8037d8 <alloc_block+0x35>
		return NULL;
  8037ce:	b8 00 00 00 00       	mov    $0x0,%eax
  8037d3:	e9 65 04 00 00       	jmp    803c3d <alloc_block+0x49a>
	}
	else if(size<=8){
  8037d8:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  8037dc:	77 09                	ja     8037e7 <alloc_block+0x44>
		size=8;
  8037de:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
  8037e5:	eb 1f                	jmp    803806 <alloc_block+0x63>
	}
	else{
		uint32 reqsize=8;
  8037e7:	c7 45 f4 08 00 00 00 	movl   $0x8,-0xc(%ebp)
		while(reqsize < size){
  8037ee:	eb 08                	jmp    8037f8 <alloc_block+0x55>
			reqsize*=2;
  8037f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037f3:	01 c0                	add    %eax,%eax
  8037f5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	else if(size<=8){
		size=8;
	}
	else{
		uint32 reqsize=8;
		while(reqsize < size){
  8037f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037fb:	3b 45 08             	cmp    0x8(%ebp),%eax
  8037fe:	72 f0                	jb     8037f0 <alloc_block+0x4d>
			reqsize*=2;
		}
		size= reqsize;
  803800:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803803:	89 45 08             	mov    %eax,0x8(%ebp)
	}

	int list_index = log2(size)- LOG2_MIN_SIZE;
  803806:	83 ec 0c             	sub    $0xc,%esp
  803809:	ff 75 08             	pushl  0x8(%ebp)
  80380c:	e8 90 fd ff ff       	call   8035a1 <log2>
  803811:	83 c4 10             	add    $0x10,%esp
  803814:	83 e8 03             	sub    $0x3,%eax
  803817:	89 45 e8             	mov    %eax,-0x18(%ebp)

	if(!LIST_EMPTY(&freeBlockLists[list_index])){
  80381a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80381d:	c1 e0 04             	shl    $0x4,%eax
  803820:	05 80 e0 81 00       	add    $0x81e080,%eax
  803825:	8b 00                	mov    (%eax),%eax
  803827:	85 c0                	test   %eax,%eax
  803829:	0f 84 fb 00 00 00    	je     80392a <alloc_block+0x187>
		struct BlockElement *block = LIST_FIRST(&freeBlockLists[list_index]);
  80382f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803832:	c1 e0 04             	shl    $0x4,%eax
  803835:	05 80 e0 81 00       	add    $0x81e080,%eax
  80383a:	8b 00                	mov    (%eax),%eax
  80383c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		LIST_REMOVE(&freeBlockLists[list_index], block);
  80383f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803843:	75 17                	jne    80385c <alloc_block+0xb9>
  803845:	83 ec 04             	sub    $0x4,%esp
  803848:	68 2d 4f 80 00       	push   $0x804f2d
  80384d:	68 86 00 00 00       	push   $0x86
  803852:	68 f3 4e 80 00       	push   $0x804ef3
  803857:	e8 34 cc ff ff       	call   800490 <_panic>
  80385c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80385f:	8b 00                	mov    (%eax),%eax
  803861:	85 c0                	test   %eax,%eax
  803863:	74 10                	je     803875 <alloc_block+0xd2>
  803865:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803868:	8b 00                	mov    (%eax),%eax
  80386a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80386d:	8b 52 04             	mov    0x4(%edx),%edx
  803870:	89 50 04             	mov    %edx,0x4(%eax)
  803873:	eb 14                	jmp    803889 <alloc_block+0xe6>
  803875:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803878:	8b 40 04             	mov    0x4(%eax),%eax
  80387b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80387e:	c1 e2 04             	shl    $0x4,%edx
  803881:	81 c2 84 e0 81 00    	add    $0x81e084,%edx
  803887:	89 02                	mov    %eax,(%edx)
  803889:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80388c:	8b 40 04             	mov    0x4(%eax),%eax
  80388f:	85 c0                	test   %eax,%eax
  803891:	74 0f                	je     8038a2 <alloc_block+0xff>
  803893:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803896:	8b 40 04             	mov    0x4(%eax),%eax
  803899:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80389c:	8b 12                	mov    (%edx),%edx
  80389e:	89 10                	mov    %edx,(%eax)
  8038a0:	eb 13                	jmp    8038b5 <alloc_block+0x112>
  8038a2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038a5:	8b 00                	mov    (%eax),%eax
  8038a7:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8038aa:	c1 e2 04             	shl    $0x4,%edx
  8038ad:	81 c2 80 e0 81 00    	add    $0x81e080,%edx
  8038b3:	89 02                	mov    %eax,(%edx)
  8038b5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038b8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8038be:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038c1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8038c8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8038cb:	c1 e0 04             	shl    $0x4,%eax
  8038ce:	05 8c e0 81 00       	add    $0x81e08c,%eax
  8038d3:	8b 00                	mov    (%eax),%eax
  8038d5:	8d 50 ff             	lea    -0x1(%eax),%edx
  8038d8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8038db:	c1 e0 04             	shl    $0x4,%eax
  8038de:	05 8c e0 81 00       	add    $0x81e08c,%eax
  8038e3:	89 10                	mov    %edx,(%eax)
		uint32 page_index = ((uint32)block - dynAllocStart)/ PAGE_SIZE;
  8038e5:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8038e8:	a1 64 e0 81 00       	mov    0x81e064,%eax
  8038ed:	29 c2                	sub    %eax,%edx
  8038ef:	89 d0                	mov    %edx,%eax
  8038f1:	c1 e8 0c             	shr    $0xc,%eax
  8038f4:	89 45 e0             	mov    %eax,-0x20(%ebp)
		pageBlockInfoArr[page_index].num_of_free_blocks--;
  8038f7:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8038fa:	89 d0                	mov    %edx,%eax
  8038fc:	01 c0                	add    %eax,%eax
  8038fe:	01 d0                	add    %edx,%eax
  803900:	c1 e0 02             	shl    $0x2,%eax
  803903:	05 6a 60 80 00       	add    $0x80606a,%eax
  803908:	66 8b 00             	mov    (%eax),%ax
  80390b:	8d 50 ff             	lea    -0x1(%eax),%edx
  80390e:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  803911:	89 c8                	mov    %ecx,%eax
  803913:	01 c0                	add    %eax,%eax
  803915:	01 c8                	add    %ecx,%eax
  803917:	c1 e0 02             	shl    $0x2,%eax
  80391a:	05 6a 60 80 00       	add    $0x80606a,%eax
  80391f:	66 89 10             	mov    %dx,(%eax)
		return (void*)block;
  803922:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803925:	e9 13 03 00 00       	jmp    803c3d <alloc_block+0x49a>
	}

	if(!LIST_EMPTY(&freePagesList)){
  80392a:	a1 48 60 80 00       	mov    0x806048,%eax
  80392f:	85 c0                	test   %eax,%eax
  803931:	0f 84 c9 01 00 00    	je     803b00 <alloc_block+0x35d>

		struct PageInfoElement *page_info = LIST_FIRST(&freePagesList);
  803937:	a1 48 60 80 00       	mov    0x806048,%eax
  80393c:	89 45 dc             	mov    %eax,-0x24(%ebp)
		LIST_REMOVE(&freePagesList, page_info);
  80393f:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803943:	75 17                	jne    80395c <alloc_block+0x1b9>
  803945:	83 ec 04             	sub    $0x4,%esp
  803948:	68 2d 4f 80 00       	push   $0x804f2d
  80394d:	68 8f 00 00 00       	push   $0x8f
  803952:	68 f3 4e 80 00       	push   $0x804ef3
  803957:	e8 34 cb ff ff       	call   800490 <_panic>
  80395c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80395f:	8b 00                	mov    (%eax),%eax
  803961:	85 c0                	test   %eax,%eax
  803963:	74 10                	je     803975 <alloc_block+0x1d2>
  803965:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803968:	8b 00                	mov    (%eax),%eax
  80396a:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80396d:	8b 52 04             	mov    0x4(%edx),%edx
  803970:	89 50 04             	mov    %edx,0x4(%eax)
  803973:	eb 0b                	jmp    803980 <alloc_block+0x1dd>
  803975:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803978:	8b 40 04             	mov    0x4(%eax),%eax
  80397b:	a3 4c 60 80 00       	mov    %eax,0x80604c
  803980:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803983:	8b 40 04             	mov    0x4(%eax),%eax
  803986:	85 c0                	test   %eax,%eax
  803988:	74 0f                	je     803999 <alloc_block+0x1f6>
  80398a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80398d:	8b 40 04             	mov    0x4(%eax),%eax
  803990:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803993:	8b 12                	mov    (%edx),%edx
  803995:	89 10                	mov    %edx,(%eax)
  803997:	eb 0a                	jmp    8039a3 <alloc_block+0x200>
  803999:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80399c:	8b 00                	mov    (%eax),%eax
  80399e:	a3 48 60 80 00       	mov    %eax,0x806048
  8039a3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8039a6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8039ac:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8039af:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8039b6:	a1 54 60 80 00       	mov    0x806054,%eax
  8039bb:	48                   	dec    %eax
  8039bc:	a3 54 60 80 00       	mov    %eax,0x806054
		uint32 page_va = to_page_va(page_info);
  8039c1:	83 ec 0c             	sub    $0xc,%esp
  8039c4:	ff 75 dc             	pushl  -0x24(%ebp)
  8039c7:	e8 89 fb ff ff       	call   803555 <to_page_va>
  8039cc:	83 c4 10             	add    $0x10,%esp
  8039cf:	89 45 d8             	mov    %eax,-0x28(%ebp)

		uint32 page_index = (page_va - dynAllocStart)/ PAGE_SIZE;
  8039d2:	a1 64 e0 81 00       	mov    0x81e064,%eax
  8039d7:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8039da:	29 c2                	sub    %eax,%edx
  8039dc:	89 d0                	mov    %edx,%eax
  8039de:	c1 e8 0c             	shr    $0xc,%eax
  8039e1:	89 45 d4             	mov    %eax,-0x2c(%ebp)

		get_page((void*)page_va);
  8039e4:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8039e7:	83 ec 0c             	sub    $0xc,%esp
  8039ea:	50                   	push   %eax
  8039eb:	e8 fe dc ff ff       	call   8016ee <get_page>
  8039f0:	83 c4 10             	add    $0x10,%esp


		pageBlockInfoArr[page_index].block_size = size;
  8039f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8039f6:	89 c2                	mov    %eax,%edx
  8039f8:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  8039fb:	89 c8                	mov    %ecx,%eax
  8039fd:	01 c0                	add    %eax,%eax
  8039ff:	01 c8                	add    %ecx,%eax
  803a01:	c1 e0 02             	shl    $0x2,%eax
  803a04:	05 68 60 80 00       	add    $0x806068,%eax
  803a09:	66 89 10             	mov    %dx,(%eax)
		int num_blocks = PAGE_SIZE / size ;
  803a0c:	b8 00 10 00 00       	mov    $0x1000,%eax
  803a11:	ba 00 00 00 00       	mov    $0x0,%edx
  803a16:	f7 75 08             	divl   0x8(%ebp)
  803a19:	89 45 d0             	mov    %eax,-0x30(%ebp)
		pageBlockInfoArr[page_index].num_of_free_blocks= num_blocks - 1 ;
  803a1c:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803a1f:	8d 50 ff             	lea    -0x1(%eax),%edx
  803a22:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  803a25:	89 c8                	mov    %ecx,%eax
  803a27:	01 c0                	add    %eax,%eax
  803a29:	01 c8                	add    %ecx,%eax
  803a2b:	c1 e0 02             	shl    $0x2,%eax
  803a2e:	05 6a 60 80 00       	add    $0x80606a,%eax
  803a33:	66 89 10             	mov    %dx,(%eax)

		for(int i=1; i< num_blocks; i++){
  803a36:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
  803a3d:	e9 aa 00 00 00       	jmp    803aec <alloc_block+0x349>
			struct BlockElement *new_block = (struct BlockElement*)(page_va + i *size);
  803a42:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803a45:	0f af 45 08          	imul   0x8(%ebp),%eax
  803a49:	89 c2                	mov    %eax,%edx
  803a4b:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803a4e:	01 d0                	add    %edx,%eax
  803a50:	89 45 cc             	mov    %eax,-0x34(%ebp)
			LIST_INSERT_TAIL(&freeBlockLists[list_index], new_block);
  803a53:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  803a57:	75 17                	jne    803a70 <alloc_block+0x2cd>
  803a59:	83 ec 04             	sub    $0x4,%esp
  803a5c:	68 4c 4f 80 00       	push   $0x804f4c
  803a61:	68 9d 00 00 00       	push   $0x9d
  803a66:	68 f3 4e 80 00       	push   $0x804ef3
  803a6b:	e8 20 ca ff ff       	call   800490 <_panic>
  803a70:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a73:	c1 e0 04             	shl    $0x4,%eax
  803a76:	05 84 e0 81 00       	add    $0x81e084,%eax
  803a7b:	8b 10                	mov    (%eax),%edx
  803a7d:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803a80:	89 50 04             	mov    %edx,0x4(%eax)
  803a83:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803a86:	8b 40 04             	mov    0x4(%eax),%eax
  803a89:	85 c0                	test   %eax,%eax
  803a8b:	74 14                	je     803aa1 <alloc_block+0x2fe>
  803a8d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a90:	c1 e0 04             	shl    $0x4,%eax
  803a93:	05 84 e0 81 00       	add    $0x81e084,%eax
  803a98:	8b 00                	mov    (%eax),%eax
  803a9a:	8b 55 cc             	mov    -0x34(%ebp),%edx
  803a9d:	89 10                	mov    %edx,(%eax)
  803a9f:	eb 11                	jmp    803ab2 <alloc_block+0x30f>
  803aa1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803aa4:	c1 e0 04             	shl    $0x4,%eax
  803aa7:	8d 90 80 e0 81 00    	lea    0x81e080(%eax),%edx
  803aad:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803ab0:	89 02                	mov    %eax,(%edx)
  803ab2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803ab5:	c1 e0 04             	shl    $0x4,%eax
  803ab8:	8d 90 84 e0 81 00    	lea    0x81e084(%eax),%edx
  803abe:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803ac1:	89 02                	mov    %eax,(%edx)
  803ac3:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803ac6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803acc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803acf:	c1 e0 04             	shl    $0x4,%eax
  803ad2:	05 8c e0 81 00       	add    $0x81e08c,%eax
  803ad7:	8b 00                	mov    (%eax),%eax
  803ad9:	8d 50 01             	lea    0x1(%eax),%edx
  803adc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803adf:	c1 e0 04             	shl    $0x4,%eax
  803ae2:	05 8c e0 81 00       	add    $0x81e08c,%eax
  803ae7:	89 10                	mov    %edx,(%eax)

		pageBlockInfoArr[page_index].block_size = size;
		int num_blocks = PAGE_SIZE / size ;
		pageBlockInfoArr[page_index].num_of_free_blocks= num_blocks - 1 ;

		for(int i=1; i< num_blocks; i++){
  803ae9:	ff 45 f0             	incl   -0x10(%ebp)
  803aec:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803aef:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  803af2:	0f 8c 4a ff ff ff    	jl     803a42 <alloc_block+0x29f>
			struct BlockElement *new_block = (struct BlockElement*)(page_va + i *size);
			LIST_INSERT_TAIL(&freeBlockLists[list_index], new_block);
		}
		return(void*)page_va;
  803af8:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803afb:	e9 3d 01 00 00       	jmp    803c3d <alloc_block+0x49a>
	}


	for(int i =list_index+1; i<= LOG2_MAX_SIZE - LOG2_MIN_SIZE; i++){
  803b00:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803b03:	40                   	inc    %eax
  803b04:	89 45 ec             	mov    %eax,-0x14(%ebp)
  803b07:	e9 10 01 00 00       	jmp    803c1c <alloc_block+0x479>

		if(!LIST_EMPTY(&freeBlockLists[i])){
  803b0c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803b0f:	c1 e0 04             	shl    $0x4,%eax
  803b12:	05 80 e0 81 00       	add    $0x81e080,%eax
  803b17:	8b 00                	mov    (%eax),%eax
  803b19:	85 c0                	test   %eax,%eax
  803b1b:	0f 84 f8 00 00 00    	je     803c19 <alloc_block+0x476>

			struct BlockElement *block = LIST_FIRST(&freeBlockLists[i]);
  803b21:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803b24:	c1 e0 04             	shl    $0x4,%eax
  803b27:	05 80 e0 81 00       	add    $0x81e080,%eax
  803b2c:	8b 00                	mov    (%eax),%eax
  803b2e:	89 45 c8             	mov    %eax,-0x38(%ebp)
			LIST_REMOVE( &freeBlockLists[i], block);
  803b31:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  803b35:	75 17                	jne    803b4e <alloc_block+0x3ab>
  803b37:	83 ec 04             	sub    $0x4,%esp
  803b3a:	68 2d 4f 80 00       	push   $0x804f2d
  803b3f:	68 a8 00 00 00       	push   $0xa8
  803b44:	68 f3 4e 80 00       	push   $0x804ef3
  803b49:	e8 42 c9 ff ff       	call   800490 <_panic>
  803b4e:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803b51:	8b 00                	mov    (%eax),%eax
  803b53:	85 c0                	test   %eax,%eax
  803b55:	74 10                	je     803b67 <alloc_block+0x3c4>
  803b57:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803b5a:	8b 00                	mov    (%eax),%eax
  803b5c:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803b5f:	8b 52 04             	mov    0x4(%edx),%edx
  803b62:	89 50 04             	mov    %edx,0x4(%eax)
  803b65:	eb 14                	jmp    803b7b <alloc_block+0x3d8>
  803b67:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803b6a:	8b 40 04             	mov    0x4(%eax),%eax
  803b6d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803b70:	c1 e2 04             	shl    $0x4,%edx
  803b73:	81 c2 84 e0 81 00    	add    $0x81e084,%edx
  803b79:	89 02                	mov    %eax,(%edx)
  803b7b:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803b7e:	8b 40 04             	mov    0x4(%eax),%eax
  803b81:	85 c0                	test   %eax,%eax
  803b83:	74 0f                	je     803b94 <alloc_block+0x3f1>
  803b85:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803b88:	8b 40 04             	mov    0x4(%eax),%eax
  803b8b:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803b8e:	8b 12                	mov    (%edx),%edx
  803b90:	89 10                	mov    %edx,(%eax)
  803b92:	eb 13                	jmp    803ba7 <alloc_block+0x404>
  803b94:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803b97:	8b 00                	mov    (%eax),%eax
  803b99:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803b9c:	c1 e2 04             	shl    $0x4,%edx
  803b9f:	81 c2 80 e0 81 00    	add    $0x81e080,%edx
  803ba5:	89 02                	mov    %eax,(%edx)
  803ba7:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803baa:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803bb0:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803bb3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803bba:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803bbd:	c1 e0 04             	shl    $0x4,%eax
  803bc0:	05 8c e0 81 00       	add    $0x81e08c,%eax
  803bc5:	8b 00                	mov    (%eax),%eax
  803bc7:	8d 50 ff             	lea    -0x1(%eax),%edx
  803bca:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803bcd:	c1 e0 04             	shl    $0x4,%eax
  803bd0:	05 8c e0 81 00       	add    $0x81e08c,%eax
  803bd5:	89 10                	mov    %edx,(%eax)

			uint32 page_index = ((uint32)block - dynAllocStart)/ PAGE_SIZE;
  803bd7:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803bda:	a1 64 e0 81 00       	mov    0x81e064,%eax
  803bdf:	29 c2                	sub    %eax,%edx
  803be1:	89 d0                	mov    %edx,%eax
  803be3:	c1 e8 0c             	shr    $0xc,%eax
  803be6:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			pageBlockInfoArr[page_index].num_of_free_blocks-- ;
  803be9:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  803bec:	89 d0                	mov    %edx,%eax
  803bee:	01 c0                	add    %eax,%eax
  803bf0:	01 d0                	add    %edx,%eax
  803bf2:	c1 e0 02             	shl    $0x2,%eax
  803bf5:	05 6a 60 80 00       	add    $0x80606a,%eax
  803bfa:	66 8b 00             	mov    (%eax),%ax
  803bfd:	8d 50 ff             	lea    -0x1(%eax),%edx
  803c00:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  803c03:	89 c8                	mov    %ecx,%eax
  803c05:	01 c0                	add    %eax,%eax
  803c07:	01 c8                	add    %ecx,%eax
  803c09:	c1 e0 02             	shl    $0x2,%eax
  803c0c:	05 6a 60 80 00       	add    $0x80606a,%eax
  803c11:	66 89 10             	mov    %dx,(%eax)

			return (void*)block;
  803c14:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803c17:	eb 24                	jmp    803c3d <alloc_block+0x49a>
		}
		return(void*)page_va;
	}


	for(int i =list_index+1; i<= LOG2_MAX_SIZE - LOG2_MIN_SIZE; i++){
  803c19:	ff 45 ec             	incl   -0x14(%ebp)
  803c1c:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  803c20:	0f 8e e6 fe ff ff    	jle    803b0c <alloc_block+0x369>

			return (void*)block;
		}
	}

	panic("alloc_block: out of memory! ");
  803c26:	83 ec 04             	sub    $0x4,%esp
  803c29:	68 6f 4f 80 00       	push   $0x804f6f
  803c2e:	68 b1 00 00 00       	push   $0xb1
  803c33:	68 f3 4e 80 00       	push   $0x804ef3
  803c38:	e8 53 c8 ff ff       	call   800490 <_panic>

	//Comment the following line
	//panic("alloc_block() Not implemented yet");

	//TODO: [PROJECT'25.BONUS#1] DYNAMIC ALLOCATOR - block if no free block
}
  803c3d:	c9                   	leave  
  803c3e:	c3                   	ret    

00803c3f <free_block>:

//===========================
// [4] FREE BLOCK:
//===========================
void free_block(void *va)
{
  803c3f:	55                   	push   %ebp
  803c40:	89 e5                	mov    %esp,%ebp
  803c42:	83 ec 38             	sub    $0x38,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert((uint32)va >= dynAllocStart && (uint32)va < dynAllocEnd);
  803c45:	8b 55 08             	mov    0x8(%ebp),%edx
  803c48:	a1 64 e0 81 00       	mov    0x81e064,%eax
  803c4d:	39 c2                	cmp    %eax,%edx
  803c4f:	72 0c                	jb     803c5d <free_block+0x1e>
  803c51:	8b 55 08             	mov    0x8(%ebp),%edx
  803c54:	a1 40 60 80 00       	mov    0x806040,%eax
  803c59:	39 c2                	cmp    %eax,%edx
  803c5b:	72 19                	jb     803c76 <free_block+0x37>
  803c5d:	68 8c 4f 80 00       	push   $0x804f8c
  803c62:	68 de 4e 80 00       	push   $0x804ede
  803c67:	68 c3 00 00 00       	push   $0xc3
  803c6c:	68 f3 4e 80 00       	push   $0x804ef3
  803c71:	e8 1a c8 ff ff       	call   800490 <_panic>
	//==================================================================================

	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #4 free_block
	//Your code is here

	uint32 page_index=((uint32)va - dynAllocStart)/ PAGE_SIZE;
  803c76:	8b 55 08             	mov    0x8(%ebp),%edx
  803c79:	a1 64 e0 81 00       	mov    0x81e064,%eax
  803c7e:	29 c2                	sub    %eax,%edx
  803c80:	89 d0                	mov    %edx,%eax
  803c82:	c1 e8 0c             	shr    $0xc,%eax
  803c85:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 block_size = pageBlockInfoArr[page_index].block_size;
  803c88:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803c8b:	89 d0                	mov    %edx,%eax
  803c8d:	01 c0                	add    %eax,%eax
  803c8f:	01 d0                	add    %edx,%eax
  803c91:	c1 e0 02             	shl    $0x2,%eax
  803c94:	05 68 60 80 00       	add    $0x806068,%eax
  803c99:	8b 00                	mov    (%eax),%eax
  803c9b:	0f b7 c0             	movzwl %ax,%eax
  803c9e:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if(block_size == 0){
  803ca1:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803ca5:	75 17                	jne    803cbe <free_block+0x7f>
		panic("page is empty(already not allocated)");
  803ca7:	83 ec 04             	sub    $0x4,%esp
  803caa:	68 c4 4f 80 00       	push   $0x804fc4
  803caf:	68 cf 00 00 00       	push   $0xcf
  803cb4:	68 f3 4e 80 00       	push   $0x804ef3
  803cb9:	e8 d2 c7 ff ff       	call   800490 <_panic>
	}

	int list_index = log2(block_size) - LOG2_MIN_SIZE;
  803cbe:	83 ec 0c             	sub    $0xc,%esp
  803cc1:	ff 75 ec             	pushl  -0x14(%ebp)
  803cc4:	e8 d8 f8 ff ff       	call   8035a1 <log2>
  803cc9:	83 c4 10             	add    $0x10,%esp
  803ccc:	83 e8 03             	sub    $0x3,%eax
  803ccf:	89 45 e8             	mov    %eax,-0x18(%ebp)
	// mn va l block "elta7weel mn virtual l phy hna"
	struct BlockElement *block = (struct BlockElement *)va;
  803cd2:	8b 45 08             	mov    0x8(%ebp),%eax
  803cd5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	LIST_INSERT_TAIL(&freeBlockLists[list_index], block);
  803cd8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803cdc:	75 17                	jne    803cf5 <free_block+0xb6>
  803cde:	83 ec 04             	sub    $0x4,%esp
  803ce1:	68 4c 4f 80 00       	push   $0x804f4c
  803ce6:	68 d5 00 00 00       	push   $0xd5
  803ceb:	68 f3 4e 80 00       	push   $0x804ef3
  803cf0:	e8 9b c7 ff ff       	call   800490 <_panic>
  803cf5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803cf8:	c1 e0 04             	shl    $0x4,%eax
  803cfb:	05 84 e0 81 00       	add    $0x81e084,%eax
  803d00:	8b 10                	mov    (%eax),%edx
  803d02:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803d05:	89 50 04             	mov    %edx,0x4(%eax)
  803d08:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803d0b:	8b 40 04             	mov    0x4(%eax),%eax
  803d0e:	85 c0                	test   %eax,%eax
  803d10:	74 14                	je     803d26 <free_block+0xe7>
  803d12:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803d15:	c1 e0 04             	shl    $0x4,%eax
  803d18:	05 84 e0 81 00       	add    $0x81e084,%eax
  803d1d:	8b 00                	mov    (%eax),%eax
  803d1f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803d22:	89 10                	mov    %edx,(%eax)
  803d24:	eb 11                	jmp    803d37 <free_block+0xf8>
  803d26:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803d29:	c1 e0 04             	shl    $0x4,%eax
  803d2c:	8d 90 80 e0 81 00    	lea    0x81e080(%eax),%edx
  803d32:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803d35:	89 02                	mov    %eax,(%edx)
  803d37:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803d3a:	c1 e0 04             	shl    $0x4,%eax
  803d3d:	8d 90 84 e0 81 00    	lea    0x81e084(%eax),%edx
  803d43:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803d46:	89 02                	mov    %eax,(%edx)
  803d48:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803d4b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803d51:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803d54:	c1 e0 04             	shl    $0x4,%eax
  803d57:	05 8c e0 81 00       	add    $0x81e08c,%eax
  803d5c:	8b 00                	mov    (%eax),%eax
  803d5e:	8d 50 01             	lea    0x1(%eax),%edx
  803d61:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803d64:	c1 e0 04             	shl    $0x4,%eax
  803d67:	05 8c e0 81 00       	add    $0x81e08c,%eax
  803d6c:	89 10                	mov    %edx,(%eax)
	// b3d ma wdytha fy el freeBlockLists hzwed elfree elly fy el array 1
	pageBlockInfoArr[page_index].num_of_free_blocks++;
  803d6e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803d71:	89 d0                	mov    %edx,%eax
  803d73:	01 c0                	add    %eax,%eax
  803d75:	01 d0                	add    %edx,%eax
  803d77:	c1 e0 02             	shl    $0x2,%eax
  803d7a:	05 6a 60 80 00       	add    $0x80606a,%eax
  803d7f:	66 8b 00             	mov    (%eax),%ax
  803d82:	8d 50 01             	lea    0x1(%eax),%edx
  803d85:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  803d88:	89 c8                	mov    %ecx,%eax
  803d8a:	01 c0                	add    %eax,%eax
  803d8c:	01 c8                	add    %ecx,%eax
  803d8e:	c1 e0 02             	shl    $0x2,%eax
  803d91:	05 6a 60 80 00       	add    $0x80606a,%eax
  803d96:	66 89 10             	mov    %dx,(%eax)
	int blocks_number = PAGE_SIZE / block_size;
  803d99:	b8 00 10 00 00       	mov    $0x1000,%eax
  803d9e:	ba 00 00 00 00       	mov    $0x0,%edx
  803da3:	f7 75 ec             	divl   -0x14(%ebp)
  803da6:	89 45 e0             	mov    %eax,-0x20(%ebp)
	if(pageBlockInfoArr[page_index].num_of_free_blocks == blocks_number){
  803da9:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803dac:	89 d0                	mov    %edx,%eax
  803dae:	01 c0                	add    %eax,%eax
  803db0:	01 d0                	add    %edx,%eax
  803db2:	c1 e0 02             	shl    $0x2,%eax
  803db5:	05 6a 60 80 00       	add    $0x80606a,%eax
  803dba:	66 8b 00             	mov    (%eax),%ax
  803dbd:	0f b7 c0             	movzwl %ax,%eax
  803dc0:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  803dc3:	0f 85 d3 01 00 00    	jne    803f9c <free_block+0x35d>
		struct BlockElement *itr = LIST_FIRST(&freeBlockLists[list_index]);
  803dc9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803dcc:	c1 e0 04             	shl    $0x4,%eax
  803dcf:	05 80 e0 81 00       	add    $0x81e080,%eax
  803dd4:	8b 00                	mov    (%eax),%eax
  803dd6:	89 45 f4             	mov    %eax,-0xc(%ebp)
		while(itr != NULL){
  803dd9:	e9 f1 00 00 00       	jmp    803ecf <free_block+0x290>
			//lw ms7to el pointer mydy34 ->
			struct BlockElement *next = LIST_NEXT(itr);
  803dde:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803de1:	8b 00                	mov    (%eax),%eax
  803de3:	89 45 dc             	mov    %eax,-0x24(%ebp)
			uint32 page_beginning_address= dynAllocStart + page_index * PAGE_SIZE;
  803de6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803de9:	c1 e0 0c             	shl    $0xc,%eax
  803dec:	89 c2                	mov    %eax,%edx
  803dee:	a1 64 e0 81 00       	mov    0x81e064,%eax
  803df3:	01 d0                	add    %edx,%eax
  803df5:	89 45 d8             	mov    %eax,-0x28(%ebp)
			uint32 page_end_address = dynAllocStart + (page_index +1 )* PAGE_SIZE;
  803df8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803dfb:	40                   	inc    %eax
  803dfc:	c1 e0 0c             	shl    $0xc,%eax
  803dff:	89 c2                	mov    %eax,%edx
  803e01:	a1 64 e0 81 00       	mov    0x81e064,%eax
  803e06:	01 d0                	add    %edx,%eax
  803e08:	89 45 d4             	mov    %eax,-0x2c(%ebp)

			if((uint32)itr >= page_beginning_address && (uint32)itr < page_end_address){
  803e0b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e0e:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  803e11:	0f 82 b8 00 00 00    	jb     803ecf <free_block+0x290>
  803e17:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e1a:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803e1d:	0f 83 ac 00 00 00    	jae    803ecf <free_block+0x290>
				LIST_REMOVE(&freeBlockLists[list_index], itr);
  803e23:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803e27:	75 17                	jne    803e40 <free_block+0x201>
  803e29:	83 ec 04             	sub    $0x4,%esp
  803e2c:	68 2d 4f 80 00       	push   $0x804f2d
  803e31:	68 e2 00 00 00       	push   $0xe2
  803e36:	68 f3 4e 80 00       	push   $0x804ef3
  803e3b:	e8 50 c6 ff ff       	call   800490 <_panic>
  803e40:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e43:	8b 00                	mov    (%eax),%eax
  803e45:	85 c0                	test   %eax,%eax
  803e47:	74 10                	je     803e59 <free_block+0x21a>
  803e49:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e4c:	8b 00                	mov    (%eax),%eax
  803e4e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803e51:	8b 52 04             	mov    0x4(%edx),%edx
  803e54:	89 50 04             	mov    %edx,0x4(%eax)
  803e57:	eb 14                	jmp    803e6d <free_block+0x22e>
  803e59:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e5c:	8b 40 04             	mov    0x4(%eax),%eax
  803e5f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803e62:	c1 e2 04             	shl    $0x4,%edx
  803e65:	81 c2 84 e0 81 00    	add    $0x81e084,%edx
  803e6b:	89 02                	mov    %eax,(%edx)
  803e6d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e70:	8b 40 04             	mov    0x4(%eax),%eax
  803e73:	85 c0                	test   %eax,%eax
  803e75:	74 0f                	je     803e86 <free_block+0x247>
  803e77:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e7a:	8b 40 04             	mov    0x4(%eax),%eax
  803e7d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803e80:	8b 12                	mov    (%edx),%edx
  803e82:	89 10                	mov    %edx,(%eax)
  803e84:	eb 13                	jmp    803e99 <free_block+0x25a>
  803e86:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e89:	8b 00                	mov    (%eax),%eax
  803e8b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803e8e:	c1 e2 04             	shl    $0x4,%edx
  803e91:	81 c2 80 e0 81 00    	add    $0x81e080,%edx
  803e97:	89 02                	mov    %eax,(%edx)
  803e99:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e9c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803ea2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ea5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803eac:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803eaf:	c1 e0 04             	shl    $0x4,%eax
  803eb2:	05 8c e0 81 00       	add    $0x81e08c,%eax
  803eb7:	8b 00                	mov    (%eax),%eax
  803eb9:	8d 50 ff             	lea    -0x1(%eax),%edx
  803ebc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803ebf:	c1 e0 04             	shl    $0x4,%eax
  803ec2:	05 8c e0 81 00       	add    $0x81e08c,%eax
  803ec7:	89 10                	mov    %edx,(%eax)
				//y5o4 3la elly b3do
				itr = next;
  803ec9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803ecc:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// b3d ma wdytha fy el freeBlockLists hzwed elfree elly fy el array 1
	pageBlockInfoArr[page_index].num_of_free_blocks++;
	int blocks_number = PAGE_SIZE / block_size;
	if(pageBlockInfoArr[page_index].num_of_free_blocks == blocks_number){
		struct BlockElement *itr = LIST_FIRST(&freeBlockLists[list_index]);
		while(itr != NULL){
  803ecf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803ed3:	0f 85 05 ff ff ff    	jne    803dde <free_block+0x19f>
				LIST_REMOVE(&freeBlockLists[list_index], itr);
				//y5o4 3la elly b3do
				itr = next;
			}
		}
		pageBlockInfoArr[page_index].block_size=0;
  803ed9:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803edc:	89 d0                	mov    %edx,%eax
  803ede:	01 c0                	add    %eax,%eax
  803ee0:	01 d0                	add    %edx,%eax
  803ee2:	c1 e0 02             	shl    $0x2,%eax
  803ee5:	05 68 60 80 00       	add    $0x806068,%eax
  803eea:	66 c7 00 00 00       	movw   $0x0,(%eax)
		pageBlockInfoArr[page_index].num_of_free_blocks=0;
  803eef:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803ef2:	89 d0                	mov    %edx,%eax
  803ef4:	01 c0                	add    %eax,%eax
  803ef6:	01 d0                	add    %edx,%eax
  803ef8:	c1 e0 02             	shl    $0x2,%eax
  803efb:	05 6a 60 80 00       	add    $0x80606a,%eax
  803f00:	66 c7 00 00 00       	movw   $0x0,(%eax)

		struct PageInfoElement *page_info = &pageBlockInfoArr[page_index];
  803f05:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803f08:	89 d0                	mov    %edx,%eax
  803f0a:	01 c0                	add    %eax,%eax
  803f0c:	01 d0                	add    %edx,%eax
  803f0e:	c1 e0 02             	shl    $0x2,%eax
  803f11:	05 60 60 80 00       	add    $0x806060,%eax
  803f16:	89 45 d0             	mov    %eax,-0x30(%ebp)
		LIST_INSERT_TAIL(&freePagesList, page_info);
  803f19:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  803f1d:	75 17                	jne    803f36 <free_block+0x2f7>
  803f1f:	83 ec 04             	sub    $0x4,%esp
  803f22:	68 4c 4f 80 00       	push   $0x804f4c
  803f27:	68 eb 00 00 00       	push   $0xeb
  803f2c:	68 f3 4e 80 00       	push   $0x804ef3
  803f31:	e8 5a c5 ff ff       	call   800490 <_panic>
  803f36:	8b 15 4c 60 80 00    	mov    0x80604c,%edx
  803f3c:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803f3f:	89 50 04             	mov    %edx,0x4(%eax)
  803f42:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803f45:	8b 40 04             	mov    0x4(%eax),%eax
  803f48:	85 c0                	test   %eax,%eax
  803f4a:	74 0c                	je     803f58 <free_block+0x319>
  803f4c:	a1 4c 60 80 00       	mov    0x80604c,%eax
  803f51:	8b 55 d0             	mov    -0x30(%ebp),%edx
  803f54:	89 10                	mov    %edx,(%eax)
  803f56:	eb 08                	jmp    803f60 <free_block+0x321>
  803f58:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803f5b:	a3 48 60 80 00       	mov    %eax,0x806048
  803f60:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803f63:	a3 4c 60 80 00       	mov    %eax,0x80604c
  803f68:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803f6b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803f71:	a1 54 60 80 00       	mov    0x806054,%eax
  803f76:	40                   	inc    %eax
  803f77:	a3 54 60 80 00       	mov    %eax,0x806054
		uint32 page_va = to_page_va(page_info);
  803f7c:	83 ec 0c             	sub    $0xc,%esp
  803f7f:	ff 75 d0             	pushl  -0x30(%ebp)
  803f82:	e8 ce f5 ff ff       	call   803555 <to_page_va>
  803f87:	83 c4 10             	add    $0x10,%esp
  803f8a:	89 45 cc             	mov    %eax,-0x34(%ebp)
		return_page((void *)page_va);
  803f8d:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803f90:	83 ec 0c             	sub    $0xc,%esp
  803f93:	50                   	push   %eax
  803f94:	e8 9e d7 ff ff       	call   801737 <return_page>
  803f99:	83 c4 10             	add    $0x10,%esp
	}


	//Comment the following line
	//panic("free_block() Not implemented yet");
}
  803f9c:	90                   	nop
  803f9d:	c9                   	leave  
  803f9e:	c3                   	ret    

00803f9f <realloc_block>:

//===========================
// [1] REALLOCATE BLOCK:
//===========================
void *realloc_block(void* va, uint32 new_size)
{
  803f9f:	55                   	push   %ebp
  803fa0:	89 e5                	mov    %esp,%ebp
  803fa2:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.BONUS#2] KERNEL REALLOC - realloc_block
	//Your code is here
	//Comment the following line
	panic("realloc_block() Not implemented yet");
  803fa5:	83 ec 04             	sub    $0x4,%esp
  803fa8:	68 ec 4f 80 00       	push   $0x804fec
  803fad:	68 01 01 00 00       	push   $0x101
  803fb2:	68 f3 4e 80 00       	push   $0x804ef3
  803fb7:	e8 d4 c4 ff ff       	call   800490 <_panic>

00803fbc <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  803fbc:	55                   	push   %ebp
  803fbd:	89 e5                	mov    %esp,%ebp
  803fbf:	83 ec 30             	sub    $0x30,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  803fc2:	8b 55 08             	mov    0x8(%ebp),%edx
  803fc5:	89 d0                	mov    %edx,%eax
  803fc7:	c1 e0 02             	shl    $0x2,%eax
  803fca:	01 d0                	add    %edx,%eax
  803fcc:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803fd3:	01 d0                	add    %edx,%eax
  803fd5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803fdc:	01 d0                	add    %edx,%eax
  803fde:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803fe5:	01 d0                	add    %edx,%eax
  803fe7:	c1 e0 04             	shl    $0x4,%eax
  803fea:	89 45 f8             	mov    %eax,-0x8(%ebp)
	uint32 cycles_counter =0;
  803fed:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)

static inline __attribute__((always_inline)) struct uint64 get_virtual_time_user()
{
	struct uint64 result;

	__asm __volatile("rdtsc\n"
  803ff4:	0f 31                	rdtsc  
  803ff6:	89 45 e8             	mov    %eax,-0x18(%ebp)
  803ff9:	89 55 ec             	mov    %edx,-0x14(%ebp)
	: "=a" (result.low), "=d" (result.hi)
	);

	return result;
  803ffc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803fff:	8b 55 ec             	mov    -0x14(%ebp),%edx
  804002:	89 45 f0             	mov    %eax,-0x10(%ebp)
  804005:	89 55 f4             	mov    %edx,-0xc(%ebp)

	/*2024*/ //USE A USER-SIDE VERSION OF THIS FUNCTION TO AVOID SLOW-DOWN THE PERFORMANCE DUE SYS_CALL (el7 :))
	//struct uint64 baseTime = sys_get_virtual_time() ;
	struct uint64 baseTime = get_virtual_time_user() ;
	while(cycles_counter<time_in_cycles)
  804008:	eb 46                	jmp    804050 <env_sleep+0x94>

static inline __attribute__((always_inline)) struct uint64 get_virtual_time_user()
{
	struct uint64 result;

	__asm __volatile("rdtsc\n"
  80400a:	0f 31                	rdtsc  
  80400c:	89 45 d0             	mov    %eax,-0x30(%ebp)
  80400f:	89 55 d4             	mov    %edx,-0x2c(%ebp)
	: "=a" (result.low), "=d" (result.hi)
	);

	return result;
  804012:	8b 45 d0             	mov    -0x30(%ebp),%eax
  804015:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  804018:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80401b:	89 55 e4             	mov    %edx,-0x1c(%ebp)

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  80401e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  804021:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804024:	29 c2                	sub    %eax,%edx
  804026:	89 d0                	mov    %edx,%eax
  804028:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  80402b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80402e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804031:	89 d1                	mov    %edx,%ecx
  804033:	29 c1                	sub    %eax,%ecx
  804035:	8b 55 d8             	mov    -0x28(%ebp),%edx
  804038:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80403b:	39 c2                	cmp    %eax,%edx
  80403d:	0f 97 c0             	seta   %al
  804040:	0f b6 c0             	movzbl %al,%eax
  804043:	29 c1                	sub    %eax,%ecx
  804045:	89 c8                	mov    %ecx,%eax
  804047:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  80404a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80404d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint32 cycles_counter =0;

	/*2024*/ //USE A USER-SIDE VERSION OF THIS FUNCTION TO AVOID SLOW-DOWN THE PERFORMANCE DUE SYS_CALL (el7 :))
	//struct uint64 baseTime = sys_get_virtual_time() ;
	struct uint64 baseTime = get_virtual_time_user() ;
	while(cycles_counter<time_in_cycles)
  804050:	8b 45 fc             	mov    -0x4(%ebp),%eax
  804053:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  804056:	72 b2                	jb     80400a <env_sleep+0x4e>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  804058:	90                   	nop
  804059:	c9                   	leave  
  80405a:	c3                   	ret    

0080405b <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  80405b:	55                   	push   %ebp
  80405c:	89 e5                	mov    %esp,%ebp
  80405e:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  804061:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  804068:	eb 03                	jmp    80406d <busy_wait+0x12>
  80406a:	ff 45 fc             	incl   -0x4(%ebp)
  80406d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  804070:	3b 45 08             	cmp    0x8(%ebp),%eax
  804073:	72 f5                	jb     80406a <busy_wait+0xf>
	return i;
  804075:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  804078:	c9                   	leave  
  804079:	c3                   	ret    

0080407a <init_uspinlock>:
#include "inc/uspinlock.h"

extern volatile struct Env *myEnv;

void init_uspinlock(struct uspinlock *lk, char *name, bool isOpened)
{
  80407a:	55                   	push   %ebp
  80407b:	89 e5                	mov    %esp,%ebp
  80407d:	83 ec 08             	sub    $0x8,%esp
	assert(isOpened == 0 || isOpened == 1);
  804080:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  804084:	74 1c                	je     8040a2 <init_uspinlock+0x28>
  804086:	83 7d 10 01          	cmpl   $0x1,0x10(%ebp)
  80408a:	74 16                	je     8040a2 <init_uspinlock+0x28>
  80408c:	68 10 50 80 00       	push   $0x805010
  804091:	68 2f 50 80 00       	push   $0x80502f
  804096:	6a 10                	push   $0x10
  804098:	68 44 50 80 00       	push   $0x805044
  80409d:	e8 ee c3 ff ff       	call   800490 <_panic>
	strcpy(lk->name, name);
  8040a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8040a5:	83 c0 04             	add    $0x4,%eax
  8040a8:	83 ec 08             	sub    $0x8,%esp
  8040ab:	ff 75 0c             	pushl  0xc(%ebp)
  8040ae:	50                   	push   %eax
  8040af:	e8 d2 cd ff ff       	call   800e86 <strcpy>
  8040b4:	83 c4 10             	add    $0x10,%esp
	lk->locked = (1 - isOpened);
  8040b7:	b8 01 00 00 00       	mov    $0x1,%eax
  8040bc:	2b 45 10             	sub    0x10(%ebp),%eax
  8040bf:	89 c2                	mov    %eax,%edx
  8040c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8040c4:	89 10                	mov    %edx,(%eax)
}
  8040c6:	90                   	nop
  8040c7:	c9                   	leave  
  8040c8:	c3                   	ret    

008040c9 <acquire_uspinlock>:
// Acquire the lock.
// Loops (spins) until the lock is acquired.
// Holding a lock for a long time may cause
// other CPUs to waste time spinning to acquire it.
void acquire_uspinlock(struct uspinlock *lk)
{
  8040c9:	55                   	push   %ebp
  8040ca:	89 e5                	mov    %esp,%ebp
  8040cc:	83 ec 18             	sub    $0x18,%esp
	// The xchg is atomic.
	while(xchg(&lk->locked, 1) != 0) ;
  8040cf:	90                   	nop
  8040d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8040d3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8040d6:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
xchg(volatile uint32 *addr, uint32 newval)
{
  uint32 result;

  // The + in "+m" denotes a read-modify-write operand.
  __asm __volatile("lock; xchgl %0, %1" :
  8040dd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8040e0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8040e3:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  8040e6:	f0 87 02             	lock xchg %eax,(%edx)
  8040e9:	89 45 ec             	mov    %eax,-0x14(%ebp)
               "+m" (*addr), "=a" (result) :
               "1" (newval) :
               "cc");
  return result;
  8040ec:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8040ef:	85 c0                	test   %eax,%eax
  8040f1:	75 dd                	jne    8040d0 <acquire_uspinlock+0x7>

	cprintf("[%d: %s] ACQUIRED spinlock [%s]\n", myEnv->env_id, myEnv->prog_name, lk->name);
  8040f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8040f6:	8d 48 04             	lea    0x4(%eax),%ecx
  8040f9:	a1 20 60 80 00       	mov    0x806020,%eax
  8040fe:	8d 50 20             	lea    0x20(%eax),%edx
  804101:	a1 20 60 80 00       	mov    0x806020,%eax
  804106:	8b 40 10             	mov    0x10(%eax),%eax
  804109:	51                   	push   %ecx
  80410a:	52                   	push   %edx
  80410b:	50                   	push   %eax
  80410c:	68 54 50 80 00       	push   $0x805054
  804111:	e8 48 c6 ff ff       	call   80075e <cprintf>
  804116:	83 c4 10             	add    $0x10,%esp

	// Tell the C compiler and the processor to not move loads or stores
	// past this point, to ensure that the critical section's memory
	// references happen after the lock is acquired.
	__sync_synchronize();
  804119:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
}
  80411e:	90                   	nop
  80411f:	c9                   	leave  
  804120:	c3                   	ret    

00804121 <release_uspinlock>:

// Release the lock.
void release_uspinlock(struct uspinlock *lk)
{
  804121:	55                   	push   %ebp
  804122:	89 e5                	mov    %esp,%ebp
  804124:	83 ec 08             	sub    $0x8,%esp
	if(!(lk->locked))
  804127:	8b 45 08             	mov    0x8(%ebp),%eax
  80412a:	8b 00                	mov    (%eax),%eax
  80412c:	85 c0                	test   %eax,%eax
  80412e:	75 18                	jne    804148 <release_uspinlock+0x27>
	{
		panic("release: lock \"%s\" is not held!", lk->name);
  804130:	8b 45 08             	mov    0x8(%ebp),%eax
  804133:	83 c0 04             	add    $0x4,%eax
  804136:	50                   	push   %eax
  804137:	68 78 50 80 00       	push   $0x805078
  80413c:	6a 2b                	push   $0x2b
  80413e:	68 44 50 80 00       	push   $0x805044
  804143:	e8 48 c3 ff ff       	call   800490 <_panic>
	// Tell the C compiler and the processor to not move loads or stores
	// past this point, to ensure that all the stores in the critical
	// section are visible to other cores before the lock is released.
	// Both the C compiler and the hardware may re-order loads and
	// stores; __sync_synchronize() tells them both not to.
	__sync_synchronize();
  804148:	f0 83 0c 24 00       	lock orl $0x0,(%esp)

	// Release the lock, equivalent to lk->locked = 0.
	// This code can't use a C assignment, since it might
	// not be atomic. A real OS would use C atomics here.
	asm volatile("movl $0, %0" : "+m" (lk->locked) : );
  80414d:	8b 45 08             	mov    0x8(%ebp),%eax
  804150:	8b 55 08             	mov    0x8(%ebp),%edx
  804153:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	cprintf("[%d: %s] RELEASED spinlock [%s]\n", myEnv->env_id, myEnv->prog_name, lk->name);
  804159:	8b 45 08             	mov    0x8(%ebp),%eax
  80415c:	8d 48 04             	lea    0x4(%eax),%ecx
  80415f:	a1 20 60 80 00       	mov    0x806020,%eax
  804164:	8d 50 20             	lea    0x20(%eax),%edx
  804167:	a1 20 60 80 00       	mov    0x806020,%eax
  80416c:	8b 40 10             	mov    0x10(%eax),%eax
  80416f:	51                   	push   %ecx
  804170:	52                   	push   %edx
  804171:	50                   	push   %eax
  804172:	68 98 50 80 00       	push   $0x805098
  804177:	e8 e2 c5 ff ff       	call   80075e <cprintf>
  80417c:	83 c4 10             	add    $0x10,%esp
}
  80417f:	90                   	nop
  804180:	c9                   	leave  
  804181:	c3                   	ret    
  804182:	66 90                	xchg   %ax,%ax

00804184 <__udivdi3>:
  804184:	55                   	push   %ebp
  804185:	57                   	push   %edi
  804186:	56                   	push   %esi
  804187:	53                   	push   %ebx
  804188:	83 ec 1c             	sub    $0x1c,%esp
  80418b:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80418f:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  804193:	8b 7c 24 38          	mov    0x38(%esp),%edi
  804197:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80419b:	89 ca                	mov    %ecx,%edx
  80419d:	89 f8                	mov    %edi,%eax
  80419f:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8041a3:	85 f6                	test   %esi,%esi
  8041a5:	75 2d                	jne    8041d4 <__udivdi3+0x50>
  8041a7:	39 cf                	cmp    %ecx,%edi
  8041a9:	77 65                	ja     804210 <__udivdi3+0x8c>
  8041ab:	89 fd                	mov    %edi,%ebp
  8041ad:	85 ff                	test   %edi,%edi
  8041af:	75 0b                	jne    8041bc <__udivdi3+0x38>
  8041b1:	b8 01 00 00 00       	mov    $0x1,%eax
  8041b6:	31 d2                	xor    %edx,%edx
  8041b8:	f7 f7                	div    %edi
  8041ba:	89 c5                	mov    %eax,%ebp
  8041bc:	31 d2                	xor    %edx,%edx
  8041be:	89 c8                	mov    %ecx,%eax
  8041c0:	f7 f5                	div    %ebp
  8041c2:	89 c1                	mov    %eax,%ecx
  8041c4:	89 d8                	mov    %ebx,%eax
  8041c6:	f7 f5                	div    %ebp
  8041c8:	89 cf                	mov    %ecx,%edi
  8041ca:	89 fa                	mov    %edi,%edx
  8041cc:	83 c4 1c             	add    $0x1c,%esp
  8041cf:	5b                   	pop    %ebx
  8041d0:	5e                   	pop    %esi
  8041d1:	5f                   	pop    %edi
  8041d2:	5d                   	pop    %ebp
  8041d3:	c3                   	ret    
  8041d4:	39 ce                	cmp    %ecx,%esi
  8041d6:	77 28                	ja     804200 <__udivdi3+0x7c>
  8041d8:	0f bd fe             	bsr    %esi,%edi
  8041db:	83 f7 1f             	xor    $0x1f,%edi
  8041de:	75 40                	jne    804220 <__udivdi3+0x9c>
  8041e0:	39 ce                	cmp    %ecx,%esi
  8041e2:	72 0a                	jb     8041ee <__udivdi3+0x6a>
  8041e4:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8041e8:	0f 87 9e 00 00 00    	ja     80428c <__udivdi3+0x108>
  8041ee:	b8 01 00 00 00       	mov    $0x1,%eax
  8041f3:	89 fa                	mov    %edi,%edx
  8041f5:	83 c4 1c             	add    $0x1c,%esp
  8041f8:	5b                   	pop    %ebx
  8041f9:	5e                   	pop    %esi
  8041fa:	5f                   	pop    %edi
  8041fb:	5d                   	pop    %ebp
  8041fc:	c3                   	ret    
  8041fd:	8d 76 00             	lea    0x0(%esi),%esi
  804200:	31 ff                	xor    %edi,%edi
  804202:	31 c0                	xor    %eax,%eax
  804204:	89 fa                	mov    %edi,%edx
  804206:	83 c4 1c             	add    $0x1c,%esp
  804209:	5b                   	pop    %ebx
  80420a:	5e                   	pop    %esi
  80420b:	5f                   	pop    %edi
  80420c:	5d                   	pop    %ebp
  80420d:	c3                   	ret    
  80420e:	66 90                	xchg   %ax,%ax
  804210:	89 d8                	mov    %ebx,%eax
  804212:	f7 f7                	div    %edi
  804214:	31 ff                	xor    %edi,%edi
  804216:	89 fa                	mov    %edi,%edx
  804218:	83 c4 1c             	add    $0x1c,%esp
  80421b:	5b                   	pop    %ebx
  80421c:	5e                   	pop    %esi
  80421d:	5f                   	pop    %edi
  80421e:	5d                   	pop    %ebp
  80421f:	c3                   	ret    
  804220:	bd 20 00 00 00       	mov    $0x20,%ebp
  804225:	89 eb                	mov    %ebp,%ebx
  804227:	29 fb                	sub    %edi,%ebx
  804229:	89 f9                	mov    %edi,%ecx
  80422b:	d3 e6                	shl    %cl,%esi
  80422d:	89 c5                	mov    %eax,%ebp
  80422f:	88 d9                	mov    %bl,%cl
  804231:	d3 ed                	shr    %cl,%ebp
  804233:	89 e9                	mov    %ebp,%ecx
  804235:	09 f1                	or     %esi,%ecx
  804237:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80423b:	89 f9                	mov    %edi,%ecx
  80423d:	d3 e0                	shl    %cl,%eax
  80423f:	89 c5                	mov    %eax,%ebp
  804241:	89 d6                	mov    %edx,%esi
  804243:	88 d9                	mov    %bl,%cl
  804245:	d3 ee                	shr    %cl,%esi
  804247:	89 f9                	mov    %edi,%ecx
  804249:	d3 e2                	shl    %cl,%edx
  80424b:	8b 44 24 08          	mov    0x8(%esp),%eax
  80424f:	88 d9                	mov    %bl,%cl
  804251:	d3 e8                	shr    %cl,%eax
  804253:	09 c2                	or     %eax,%edx
  804255:	89 d0                	mov    %edx,%eax
  804257:	89 f2                	mov    %esi,%edx
  804259:	f7 74 24 0c          	divl   0xc(%esp)
  80425d:	89 d6                	mov    %edx,%esi
  80425f:	89 c3                	mov    %eax,%ebx
  804261:	f7 e5                	mul    %ebp
  804263:	39 d6                	cmp    %edx,%esi
  804265:	72 19                	jb     804280 <__udivdi3+0xfc>
  804267:	74 0b                	je     804274 <__udivdi3+0xf0>
  804269:	89 d8                	mov    %ebx,%eax
  80426b:	31 ff                	xor    %edi,%edi
  80426d:	e9 58 ff ff ff       	jmp    8041ca <__udivdi3+0x46>
  804272:	66 90                	xchg   %ax,%ax
  804274:	8b 54 24 08          	mov    0x8(%esp),%edx
  804278:	89 f9                	mov    %edi,%ecx
  80427a:	d3 e2                	shl    %cl,%edx
  80427c:	39 c2                	cmp    %eax,%edx
  80427e:	73 e9                	jae    804269 <__udivdi3+0xe5>
  804280:	8d 43 ff             	lea    -0x1(%ebx),%eax
  804283:	31 ff                	xor    %edi,%edi
  804285:	e9 40 ff ff ff       	jmp    8041ca <__udivdi3+0x46>
  80428a:	66 90                	xchg   %ax,%ax
  80428c:	31 c0                	xor    %eax,%eax
  80428e:	e9 37 ff ff ff       	jmp    8041ca <__udivdi3+0x46>
  804293:	90                   	nop

00804294 <__umoddi3>:
  804294:	55                   	push   %ebp
  804295:	57                   	push   %edi
  804296:	56                   	push   %esi
  804297:	53                   	push   %ebx
  804298:	83 ec 1c             	sub    $0x1c,%esp
  80429b:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80429f:	8b 74 24 34          	mov    0x34(%esp),%esi
  8042a3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8042a7:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8042ab:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8042af:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8042b3:	89 f3                	mov    %esi,%ebx
  8042b5:	89 fa                	mov    %edi,%edx
  8042b7:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8042bb:	89 34 24             	mov    %esi,(%esp)
  8042be:	85 c0                	test   %eax,%eax
  8042c0:	75 1a                	jne    8042dc <__umoddi3+0x48>
  8042c2:	39 f7                	cmp    %esi,%edi
  8042c4:	0f 86 a2 00 00 00    	jbe    80436c <__umoddi3+0xd8>
  8042ca:	89 c8                	mov    %ecx,%eax
  8042cc:	89 f2                	mov    %esi,%edx
  8042ce:	f7 f7                	div    %edi
  8042d0:	89 d0                	mov    %edx,%eax
  8042d2:	31 d2                	xor    %edx,%edx
  8042d4:	83 c4 1c             	add    $0x1c,%esp
  8042d7:	5b                   	pop    %ebx
  8042d8:	5e                   	pop    %esi
  8042d9:	5f                   	pop    %edi
  8042da:	5d                   	pop    %ebp
  8042db:	c3                   	ret    
  8042dc:	39 f0                	cmp    %esi,%eax
  8042de:	0f 87 ac 00 00 00    	ja     804390 <__umoddi3+0xfc>
  8042e4:	0f bd e8             	bsr    %eax,%ebp
  8042e7:	83 f5 1f             	xor    $0x1f,%ebp
  8042ea:	0f 84 ac 00 00 00    	je     80439c <__umoddi3+0x108>
  8042f0:	bf 20 00 00 00       	mov    $0x20,%edi
  8042f5:	29 ef                	sub    %ebp,%edi
  8042f7:	89 fe                	mov    %edi,%esi
  8042f9:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8042fd:	89 e9                	mov    %ebp,%ecx
  8042ff:	d3 e0                	shl    %cl,%eax
  804301:	89 d7                	mov    %edx,%edi
  804303:	89 f1                	mov    %esi,%ecx
  804305:	d3 ef                	shr    %cl,%edi
  804307:	09 c7                	or     %eax,%edi
  804309:	89 e9                	mov    %ebp,%ecx
  80430b:	d3 e2                	shl    %cl,%edx
  80430d:	89 14 24             	mov    %edx,(%esp)
  804310:	89 d8                	mov    %ebx,%eax
  804312:	d3 e0                	shl    %cl,%eax
  804314:	89 c2                	mov    %eax,%edx
  804316:	8b 44 24 08          	mov    0x8(%esp),%eax
  80431a:	d3 e0                	shl    %cl,%eax
  80431c:	89 44 24 04          	mov    %eax,0x4(%esp)
  804320:	8b 44 24 08          	mov    0x8(%esp),%eax
  804324:	89 f1                	mov    %esi,%ecx
  804326:	d3 e8                	shr    %cl,%eax
  804328:	09 d0                	or     %edx,%eax
  80432a:	d3 eb                	shr    %cl,%ebx
  80432c:	89 da                	mov    %ebx,%edx
  80432e:	f7 f7                	div    %edi
  804330:	89 d3                	mov    %edx,%ebx
  804332:	f7 24 24             	mull   (%esp)
  804335:	89 c6                	mov    %eax,%esi
  804337:	89 d1                	mov    %edx,%ecx
  804339:	39 d3                	cmp    %edx,%ebx
  80433b:	0f 82 87 00 00 00    	jb     8043c8 <__umoddi3+0x134>
  804341:	0f 84 91 00 00 00    	je     8043d8 <__umoddi3+0x144>
  804347:	8b 54 24 04          	mov    0x4(%esp),%edx
  80434b:	29 f2                	sub    %esi,%edx
  80434d:	19 cb                	sbb    %ecx,%ebx
  80434f:	89 d8                	mov    %ebx,%eax
  804351:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  804355:	d3 e0                	shl    %cl,%eax
  804357:	89 e9                	mov    %ebp,%ecx
  804359:	d3 ea                	shr    %cl,%edx
  80435b:	09 d0                	or     %edx,%eax
  80435d:	89 e9                	mov    %ebp,%ecx
  80435f:	d3 eb                	shr    %cl,%ebx
  804361:	89 da                	mov    %ebx,%edx
  804363:	83 c4 1c             	add    $0x1c,%esp
  804366:	5b                   	pop    %ebx
  804367:	5e                   	pop    %esi
  804368:	5f                   	pop    %edi
  804369:	5d                   	pop    %ebp
  80436a:	c3                   	ret    
  80436b:	90                   	nop
  80436c:	89 fd                	mov    %edi,%ebp
  80436e:	85 ff                	test   %edi,%edi
  804370:	75 0b                	jne    80437d <__umoddi3+0xe9>
  804372:	b8 01 00 00 00       	mov    $0x1,%eax
  804377:	31 d2                	xor    %edx,%edx
  804379:	f7 f7                	div    %edi
  80437b:	89 c5                	mov    %eax,%ebp
  80437d:	89 f0                	mov    %esi,%eax
  80437f:	31 d2                	xor    %edx,%edx
  804381:	f7 f5                	div    %ebp
  804383:	89 c8                	mov    %ecx,%eax
  804385:	f7 f5                	div    %ebp
  804387:	89 d0                	mov    %edx,%eax
  804389:	e9 44 ff ff ff       	jmp    8042d2 <__umoddi3+0x3e>
  80438e:	66 90                	xchg   %ax,%ax
  804390:	89 c8                	mov    %ecx,%eax
  804392:	89 f2                	mov    %esi,%edx
  804394:	83 c4 1c             	add    $0x1c,%esp
  804397:	5b                   	pop    %ebx
  804398:	5e                   	pop    %esi
  804399:	5f                   	pop    %edi
  80439a:	5d                   	pop    %ebp
  80439b:	c3                   	ret    
  80439c:	3b 04 24             	cmp    (%esp),%eax
  80439f:	72 06                	jb     8043a7 <__umoddi3+0x113>
  8043a1:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8043a5:	77 0f                	ja     8043b6 <__umoddi3+0x122>
  8043a7:	89 f2                	mov    %esi,%edx
  8043a9:	29 f9                	sub    %edi,%ecx
  8043ab:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8043af:	89 14 24             	mov    %edx,(%esp)
  8043b2:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8043b6:	8b 44 24 04          	mov    0x4(%esp),%eax
  8043ba:	8b 14 24             	mov    (%esp),%edx
  8043bd:	83 c4 1c             	add    $0x1c,%esp
  8043c0:	5b                   	pop    %ebx
  8043c1:	5e                   	pop    %esi
  8043c2:	5f                   	pop    %edi
  8043c3:	5d                   	pop    %ebp
  8043c4:	c3                   	ret    
  8043c5:	8d 76 00             	lea    0x0(%esi),%esi
  8043c8:	2b 04 24             	sub    (%esp),%eax
  8043cb:	19 fa                	sbb    %edi,%edx
  8043cd:	89 d1                	mov    %edx,%ecx
  8043cf:	89 c6                	mov    %eax,%esi
  8043d1:	e9 71 ff ff ff       	jmp    804347 <__umoddi3+0xb3>
  8043d6:	66 90                	xchg   %ax,%ax
  8043d8:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8043dc:	72 ea                	jb     8043c8 <__umoddi3+0x134>
  8043de:	89 d9                	mov    %ebx,%ecx
  8043e0:	e9 62 ff ff ff       	jmp    804347 <__umoddi3+0xb3>
