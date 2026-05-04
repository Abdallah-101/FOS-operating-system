
obj/user/tst_envfree4:     file format elf32-i386


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
  800031:	e8 9c 02 00 00       	call   8002d2 <libmain>
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
	// Testing scenario 4: Freeing the allocated shared variables [covers: smalloc (1 env) & sget (multiple envs)]
	// Testing removing the shared variables
	int *numOfFinished = smalloc("finishedCount", sizeof(int), 1) ;
  800044:	83 ec 04             	sub    $0x4,%esp
  800047:	6a 01                	push   $0x1
  800049:	6a 04                	push   $0x4
  80004b:	68 40 43 80 00       	push   $0x804340
  800050:	e8 ab 23 00 00       	call   802400 <smalloc>
  800055:	83 c4 10             	add    $0x10,%esp
  800058:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	*numOfFinished = 0 ;
  80005b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80005e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	char getksbrkCmd[100] = "__getKernelSBreak__";
  800064:	8d 85 54 ff ff ff    	lea    -0xac(%ebp),%eax
  80006a:	bb 41 45 80 00       	mov    $0x804541,%ebx
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
  8000a1:	e8 1d 34 00 00       	call   8034c3 <sys_utilities>
  8000a6:	83 c4 10             	add    $0x10,%esp

	int freeFrames_before = sys_calculate_free_frames() ;
  8000a9:	e8 16 30 00 00       	call   8030c4 <sys_calculate_free_frames>
  8000ae:	89 45 e0             	mov    %eax,-0x20(%ebp)
	int usedDiskPages_before = sys_pf_calculate_allocated_pages() ;
  8000b1:	e8 59 30 00 00       	call   80310f <sys_pf_calculate_allocated_pages>
  8000b6:	89 45 dc             	mov    %eax,-0x24(%ebp)
	cprintf("\n---# of free frames before running programs = %d\n", freeFrames_before);
  8000b9:	83 ec 08             	sub    $0x8,%esp
  8000bc:	ff 75 e0             	pushl  -0x20(%ebp)
  8000bf:	68 50 43 80 00       	push   $0x804350
  8000c4:	e8 90 06 00 00       	call   800759 <cprintf>
  8000c9:	83 c4 10             	add    $0x10,%esp

	int32 envIdProcessA = sys_create_env("ef_tshr1", myEnv->page_WS_max_size,(myEnv->SecondListSize), 50);
  8000cc:	a1 20 50 80 00       	mov    0x805020,%eax
  8000d1:	8b 80 a0 05 00 00    	mov    0x5a0(%eax),%eax
  8000d7:	89 c2                	mov    %eax,%edx
  8000d9:	a1 20 50 80 00       	mov    0x805020,%eax
  8000de:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  8000e4:	6a 32                	push   $0x32
  8000e6:	52                   	push   %edx
  8000e7:	50                   	push   %eax
  8000e8:	68 83 43 80 00       	push   $0x804383
  8000ed:	e8 2d 31 00 00       	call   80321f <sys_create_env>
  8000f2:	83 c4 10             	add    $0x10,%esp
  8000f5:	89 45 d8             	mov    %eax,-0x28(%ebp)
	int32 envIdProcessB = sys_create_env("ef_tshr2", myEnv->page_WS_max_size,(myEnv->SecondListSize), 50);
  8000f8:	a1 20 50 80 00       	mov    0x805020,%eax
  8000fd:	8b 80 a0 05 00 00    	mov    0x5a0(%eax),%eax
  800103:	89 c2                	mov    %eax,%edx
  800105:	a1 20 50 80 00       	mov    0x805020,%eax
  80010a:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  800110:	6a 32                	push   $0x32
  800112:	52                   	push   %edx
  800113:	50                   	push   %eax
  800114:	68 8c 43 80 00       	push   $0x80438c
  800119:	e8 01 31 00 00       	call   80321f <sys_create_env>
  80011e:	83 c4 10             	add    $0x10,%esp
  800121:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	sys_run_env(envIdProcessA);
  800124:	83 ec 0c             	sub    $0xc,%esp
  800127:	ff 75 d8             	pushl  -0x28(%ebp)
  80012a:	e8 0e 31 00 00       	call   80323d <sys_run_env>
  80012f:	83 c4 10             	add    $0x10,%esp

	while (*numOfFinished != 1) ;
  800132:	90                   	nop
  800133:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800136:	8b 00                	mov    (%eax),%eax
  800138:	83 f8 01             	cmp    $0x1,%eax
  80013b:	75 f6                	jne    800133 <_main+0xfb>

	sys_run_env(envIdProcessB);
  80013d:	83 ec 0c             	sub    $0xc,%esp
  800140:	ff 75 d4             	pushl  -0x2c(%ebp)
  800143:	e8 f5 30 00 00       	call   80323d <sys_run_env>
  800148:	83 c4 10             	add    $0x10,%esp

	while (*numOfFinished != 2) ;
  80014b:	90                   	nop
  80014c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80014f:	8b 00                	mov    (%eax),%eax
  800151:	83 f8 02             	cmp    $0x2,%eax
  800154:	75 f6                	jne    80014c <_main+0x114>

	cprintf("\n---# of free frames after running programs = %d\n", sys_calculate_free_frames());
  800156:	e8 69 2f 00 00       	call   8030c4 <sys_calculate_free_frames>
  80015b:	83 ec 08             	sub    $0x8,%esp
  80015e:	50                   	push   %eax
  80015f:	68 98 43 80 00       	push   $0x804398
  800164:	e8 f0 05 00 00       	call   800759 <cprintf>
  800169:	83 c4 10             	add    $0x10,%esp

	uint32 ksbrk_after ;
	sys_utilities(getksbrkCmd, (uint32)&ksbrk_after);
  80016c:	8d 85 4c ff ff ff    	lea    -0xb4(%ebp),%eax
  800172:	83 ec 08             	sub    $0x8,%esp
  800175:	50                   	push   %eax
  800176:	8d 85 54 ff ff ff    	lea    -0xac(%ebp),%eax
  80017c:	50                   	push   %eax
  80017d:	e8 41 33 00 00       	call   8034c3 <sys_utilities>
  800182:	83 c4 10             	add    $0x10,%esp

	//DISABLE the interrupt to ensure the env_free is done as a whole without preemption
	//to avoid context switch (due to clock interrupt) while freeing the env to prevent:
	//	1. context switching to a wrong process specially in the part of temporarily switching the CPU process for freeing shared variables
	//	2. changing the # free frames
	char changeIntCmd[100] = "__changeInterruptStatus__";
  800185:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  80018b:	bb a5 45 80 00       	mov    $0x8045a5,%ebx
  800190:	ba 1a 00 00 00       	mov    $0x1a,%edx
  800195:	89 c7                	mov    %eax,%edi
  800197:	89 de                	mov    %ebx,%esi
  800199:	89 d1                	mov    %edx,%ecx
  80019b:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  80019d:	8d 95 02 ff ff ff    	lea    -0xfe(%ebp),%edx
  8001a3:	b9 4a 00 00 00       	mov    $0x4a,%ecx
  8001a8:	b0 00                	mov    $0x0,%al
  8001aa:	89 d7                	mov    %edx,%edi
  8001ac:	f3 aa                	rep stos %al,%es:(%edi)
	sys_utilities(changeIntCmd, 0);
  8001ae:	83 ec 08             	sub    $0x8,%esp
  8001b1:	6a 00                	push   $0x0
  8001b3:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  8001b9:	50                   	push   %eax
  8001ba:	e8 04 33 00 00       	call   8034c3 <sys_utilities>
  8001bf:	83 c4 10             	add    $0x10,%esp
	{
		sys_destroy_env(envIdProcessA);
  8001c2:	83 ec 0c             	sub    $0xc,%esp
  8001c5:	ff 75 d8             	pushl  -0x28(%ebp)
  8001c8:	e8 8c 30 00 00       	call   803259 <sys_destroy_env>
  8001cd:	83 c4 10             	add    $0x10,%esp
		sys_destroy_env(envIdProcessB);
  8001d0:	83 ec 0c             	sub    $0xc,%esp
  8001d3:	ff 75 d4             	pushl  -0x2c(%ebp)
  8001d6:	e8 7e 30 00 00       	call   803259 <sys_destroy_env>
  8001db:	83 c4 10             	add    $0x10,%esp
	}
	sys_utilities(changeIntCmd, 1);
  8001de:	83 ec 08             	sub    $0x8,%esp
  8001e1:	6a 01                	push   $0x1
  8001e3:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  8001e9:	50                   	push   %eax
  8001ea:	e8 d4 32 00 00       	call   8034c3 <sys_utilities>
  8001ef:	83 c4 10             	add    $0x10,%esp

	//Checking the number of frames after killing the created environments
	int freeFrames_after = sys_calculate_free_frames() ;
  8001f2:	e8 cd 2e 00 00       	call   8030c4 <sys_calculate_free_frames>
  8001f7:	89 45 d0             	mov    %eax,-0x30(%ebp)
	int usedDiskPages_after = sys_pf_calculate_allocated_pages() ;
  8001fa:	e8 10 2f 00 00       	call   80310f <sys_pf_calculate_allocated_pages>
  8001ff:	89 45 cc             	mov    %eax,-0x34(%ebp)

	int expected = (ROUNDUP((uint32)ksbrk_after, PAGE_SIZE) - ROUNDUP((uint32)ksbrk_before, PAGE_SIZE)) / PAGE_SIZE;
  800202:	c7 45 c8 00 10 00 00 	movl   $0x1000,-0x38(%ebp)
  800209:	8b 95 4c ff ff ff    	mov    -0xb4(%ebp),%edx
  80020f:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800212:	01 d0                	add    %edx,%eax
  800214:	48                   	dec    %eax
  800215:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  800218:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80021b:	ba 00 00 00 00       	mov    $0x0,%edx
  800220:	f7 75 c8             	divl   -0x38(%ebp)
  800223:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  800226:	29 d0                	sub    %edx,%eax
  800228:	89 c1                	mov    %eax,%ecx
  80022a:	c7 45 c0 00 10 00 00 	movl   $0x1000,-0x40(%ebp)
  800231:	8b 95 50 ff ff ff    	mov    -0xb0(%ebp),%edx
  800237:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80023a:	01 d0                	add    %edx,%eax
  80023c:	48                   	dec    %eax
  80023d:	89 45 bc             	mov    %eax,-0x44(%ebp)
  800240:	8b 45 bc             	mov    -0x44(%ebp),%eax
  800243:	ba 00 00 00 00       	mov    $0x0,%edx
  800248:	f7 75 c0             	divl   -0x40(%ebp)
  80024b:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80024e:	29 d0                	sub    %edx,%eax
  800250:	29 c1                	sub    %eax,%ecx
  800252:	89 c8                	mov    %ecx,%eax
  800254:	c1 e8 0c             	shr    $0xc,%eax
  800257:	89 45 b8             	mov    %eax,-0x48(%ebp)
	cprintf("expected = %d\n",expected);
  80025a:	83 ec 08             	sub    $0x8,%esp
  80025d:	ff 75 b8             	pushl  -0x48(%ebp)
  800260:	68 ca 43 80 00       	push   $0x8043ca
  800265:	e8 ef 04 00 00       	call   800759 <cprintf>
  80026a:	83 c4 10             	add    $0x10,%esp
	if ((freeFrames_before - freeFrames_after) != expected) {
  80026d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800270:	2b 45 d0             	sub    -0x30(%ebp),%eax
  800273:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  800276:	74 2e                	je     8002a6 <_main+0x26e>
		cprintf("\n---# of free frames after closing running programs not as before running = %d\ndifference = %d, expected = %d\n",
  800278:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80027b:	2b 45 e0             	sub    -0x20(%ebp),%eax
  80027e:	ff 75 b8             	pushl  -0x48(%ebp)
  800281:	50                   	push   %eax
  800282:	ff 75 d0             	pushl  -0x30(%ebp)
  800285:	68 dc 43 80 00       	push   $0x8043dc
  80028a:	e8 ca 04 00 00       	call   800759 <cprintf>
  80028f:	83 c4 10             	add    $0x10,%esp
				freeFrames_after, freeFrames_after - freeFrames_before, expected);
		panic("env_free() does not work correctly... check it again.");
  800292:	83 ec 04             	sub    $0x4,%esp
  800295:	68 4c 44 80 00       	push   $0x80444c
  80029a:	6a 38                	push   $0x38
  80029c:	68 82 44 80 00       	push   $0x804482
  8002a1:	e8 e5 01 00 00       	call   80048b <_panic>
	}

	cprintf("\n---# of free frames after closing running programs returned back to be as before running = %d\n", freeFrames_after);
  8002a6:	83 ec 08             	sub    $0x8,%esp
  8002a9:	ff 75 d0             	pushl  -0x30(%ebp)
  8002ac:	68 98 44 80 00       	push   $0x804498
  8002b1:	e8 a3 04 00 00       	call   800759 <cprintf>
  8002b6:	83 c4 10             	add    $0x10,%esp

	cprintf("\n\nCongratulations!! test scenario 3 for envfree completed successfully.\n");
  8002b9:	83 ec 0c             	sub    $0xc,%esp
  8002bc:	68 f8 44 80 00       	push   $0x8044f8
  8002c1:	e8 93 04 00 00       	call   800759 <cprintf>
  8002c6:	83 c4 10             	add    $0x10,%esp
	return;
  8002c9:	90                   	nop
}
  8002ca:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002cd:	5b                   	pop    %ebx
  8002ce:	5e                   	pop    %esi
  8002cf:	5f                   	pop    %edi
  8002d0:	5d                   	pop    %ebp
  8002d1:	c3                   	ret    

008002d2 <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  8002d2:	55                   	push   %ebp
  8002d3:	89 e5                	mov    %esp,%ebp
  8002d5:	57                   	push   %edi
  8002d6:	56                   	push   %esi
  8002d7:	53                   	push   %ebx
  8002d8:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  8002db:	e8 ad 2f 00 00       	call   80328d <sys_getenvindex>
  8002e0:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  8002e3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8002e6:	89 d0                	mov    %edx,%eax
  8002e8:	c1 e0 02             	shl    $0x2,%eax
  8002eb:	01 d0                	add    %edx,%eax
  8002ed:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8002f4:	01 d0                	add    %edx,%eax
  8002f6:	89 c2                	mov    %eax,%edx
  8002f8:	c1 e2 04             	shl    $0x4,%edx
  8002fb:	29 c2                	sub    %eax,%edx
  8002fd:	8d 04 95 00 00 00 00 	lea    0x0(,%edx,4),%eax
  800304:	89 c2                	mov    %eax,%edx
  800306:	8d 82 00 00 c0 ee    	lea    -0x11400000(%edx),%eax
  80030c:	a3 20 50 80 00       	mov    %eax,0x805020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800311:	a1 20 50 80 00       	mov    0x805020,%eax
  800316:	8a 40 20             	mov    0x20(%eax),%al
  800319:	84 c0                	test   %al,%al
  80031b:	74 0d                	je     80032a <libmain+0x58>
		binaryname = myEnv->prog_name;
  80031d:	a1 20 50 80 00       	mov    0x805020,%eax
  800322:	83 c0 20             	add    $0x20,%eax
  800325:	a3 04 50 80 00       	mov    %eax,0x805004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80032a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80032e:	7e 0a                	jle    80033a <libmain+0x68>
		binaryname = argv[0];
  800330:	8b 45 0c             	mov    0xc(%ebp),%eax
  800333:	8b 00                	mov    (%eax),%eax
  800335:	a3 04 50 80 00       	mov    %eax,0x805004

	// call user main routine
	_main(argc, argv);
  80033a:	83 ec 08             	sub    $0x8,%esp
  80033d:	ff 75 0c             	pushl  0xc(%ebp)
  800340:	ff 75 08             	pushl  0x8(%ebp)
  800343:	e8 f0 fc ff ff       	call   800038 <_main>
  800348:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  80034b:	a1 00 50 80 00       	mov    0x805000,%eax
  800350:	85 c0                	test   %eax,%eax
  800352:	0f 84 01 01 00 00    	je     800459 <libmain+0x187>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  800358:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  80035e:	bb 04 47 80 00       	mov    $0x804704,%ebx
  800363:	ba 0e 00 00 00       	mov    $0xe,%edx
  800368:	89 c7                	mov    %eax,%edi
  80036a:	89 de                	mov    %ebx,%esi
  80036c:	89 d1                	mov    %edx,%ecx
  80036e:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  800370:	8d 55 8a             	lea    -0x76(%ebp),%edx
  800373:	b9 56 00 00 00       	mov    $0x56,%ecx
  800378:	b0 00                	mov    $0x0,%al
  80037a:	89 d7                	mov    %edx,%edi
  80037c:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  80037e:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  800385:	8d 45 e0             	lea    -0x20(%ebp),%eax
  800388:	83 ec 08             	sub    $0x8,%esp
  80038b:	50                   	push   %eax
  80038c:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  800392:	50                   	push   %eax
  800393:	e8 2b 31 00 00       	call   8034c3 <sys_utilities>
  800398:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  80039b:	e8 74 2c 00 00       	call   803014 <sys_lock_cons>
		{
			cprintf("**************************************\n");
  8003a0:	83 ec 0c             	sub    $0xc,%esp
  8003a3:	68 24 46 80 00       	push   $0x804624
  8003a8:	e8 ac 03 00 00       	call   800759 <cprintf>
  8003ad:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  8003b0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8003b3:	85 c0                	test   %eax,%eax
  8003b5:	74 18                	je     8003cf <libmain+0xfd>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  8003b7:	e8 25 31 00 00       	call   8034e1 <sys_get_optimal_num_faults>
  8003bc:	83 ec 08             	sub    $0x8,%esp
  8003bf:	50                   	push   %eax
  8003c0:	68 4c 46 80 00       	push   $0x80464c
  8003c5:	e8 8f 03 00 00       	call   800759 <cprintf>
  8003ca:	83 c4 10             	add    $0x10,%esp
  8003cd:	eb 59                	jmp    800428 <libmain+0x156>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8003cf:	a1 20 50 80 00       	mov    0x805020,%eax
  8003d4:	8b 90 bc 05 00 00    	mov    0x5bc(%eax),%edx
  8003da:	a1 20 50 80 00       	mov    0x805020,%eax
  8003df:	8b 80 ac 05 00 00    	mov    0x5ac(%eax),%eax
  8003e5:	83 ec 04             	sub    $0x4,%esp
  8003e8:	52                   	push   %edx
  8003e9:	50                   	push   %eax
  8003ea:	68 70 46 80 00       	push   $0x804670
  8003ef:	e8 65 03 00 00       	call   800759 <cprintf>
  8003f4:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8003f7:	a1 20 50 80 00       	mov    0x805020,%eax
  8003fc:	8b 88 d0 05 00 00    	mov    0x5d0(%eax),%ecx
  800402:	a1 20 50 80 00       	mov    0x805020,%eax
  800407:	8b 90 cc 05 00 00    	mov    0x5cc(%eax),%edx
  80040d:	a1 20 50 80 00       	mov    0x805020,%eax
  800412:	8b 80 c8 05 00 00    	mov    0x5c8(%eax),%eax
  800418:	51                   	push   %ecx
  800419:	52                   	push   %edx
  80041a:	50                   	push   %eax
  80041b:	68 98 46 80 00       	push   $0x804698
  800420:	e8 34 03 00 00       	call   800759 <cprintf>
  800425:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800428:	a1 20 50 80 00       	mov    0x805020,%eax
  80042d:	8b 80 d4 05 00 00    	mov    0x5d4(%eax),%eax
  800433:	83 ec 08             	sub    $0x8,%esp
  800436:	50                   	push   %eax
  800437:	68 f0 46 80 00       	push   $0x8046f0
  80043c:	e8 18 03 00 00       	call   800759 <cprintf>
  800441:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  800444:	83 ec 0c             	sub    $0xc,%esp
  800447:	68 24 46 80 00       	push   $0x804624
  80044c:	e8 08 03 00 00       	call   800759 <cprintf>
  800451:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  800454:	e8 d5 2b 00 00       	call   80302e <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  800459:	e8 1f 00 00 00       	call   80047d <exit>
}
  80045e:	90                   	nop
  80045f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800462:	5b                   	pop    %ebx
  800463:	5e                   	pop    %esi
  800464:	5f                   	pop    %edi
  800465:	5d                   	pop    %ebp
  800466:	c3                   	ret    

00800467 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800467:	55                   	push   %ebp
  800468:	89 e5                	mov    %esp,%ebp
  80046a:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  80046d:	83 ec 0c             	sub    $0xc,%esp
  800470:	6a 00                	push   $0x0
  800472:	e8 e2 2d 00 00       	call   803259 <sys_destroy_env>
  800477:	83 c4 10             	add    $0x10,%esp
}
  80047a:	90                   	nop
  80047b:	c9                   	leave  
  80047c:	c3                   	ret    

0080047d <exit>:

void
exit(void)
{
  80047d:	55                   	push   %ebp
  80047e:	89 e5                	mov    %esp,%ebp
  800480:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800483:	e8 37 2e 00 00       	call   8032bf <sys_exit_env>
}
  800488:	90                   	nop
  800489:	c9                   	leave  
  80048a:	c3                   	ret    

0080048b <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  80048b:	55                   	push   %ebp
  80048c:	89 e5                	mov    %esp,%ebp
  80048e:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800491:	8d 45 10             	lea    0x10(%ebp),%eax
  800494:	83 c0 04             	add    $0x4,%eax
  800497:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  80049a:	a1 18 d1 81 00       	mov    0x81d118,%eax
  80049f:	85 c0                	test   %eax,%eax
  8004a1:	74 16                	je     8004b9 <_panic+0x2e>
		cprintf("%s: ", argv0);
  8004a3:	a1 18 d1 81 00       	mov    0x81d118,%eax
  8004a8:	83 ec 08             	sub    $0x8,%esp
  8004ab:	50                   	push   %eax
  8004ac:	68 68 47 80 00       	push   $0x804768
  8004b1:	e8 a3 02 00 00       	call   800759 <cprintf>
  8004b6:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  8004b9:	a1 04 50 80 00       	mov    0x805004,%eax
  8004be:	83 ec 0c             	sub    $0xc,%esp
  8004c1:	ff 75 0c             	pushl  0xc(%ebp)
  8004c4:	ff 75 08             	pushl  0x8(%ebp)
  8004c7:	50                   	push   %eax
  8004c8:	68 70 47 80 00       	push   $0x804770
  8004cd:	6a 74                	push   $0x74
  8004cf:	e8 b2 02 00 00       	call   800786 <cprintf_colored>
  8004d4:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  8004d7:	8b 45 10             	mov    0x10(%ebp),%eax
  8004da:	83 ec 08             	sub    $0x8,%esp
  8004dd:	ff 75 f4             	pushl  -0xc(%ebp)
  8004e0:	50                   	push   %eax
  8004e1:	e8 04 02 00 00       	call   8006ea <vcprintf>
  8004e6:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8004e9:	83 ec 08             	sub    $0x8,%esp
  8004ec:	6a 00                	push   $0x0
  8004ee:	68 98 47 80 00       	push   $0x804798
  8004f3:	e8 f2 01 00 00       	call   8006ea <vcprintf>
  8004f8:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8004fb:	e8 7d ff ff ff       	call   80047d <exit>

	// should not return here
	while (1) ;
  800500:	eb fe                	jmp    800500 <_panic+0x75>

00800502 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800502:	55                   	push   %ebp
  800503:	89 e5                	mov    %esp,%ebp
  800505:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800508:	a1 20 50 80 00       	mov    0x805020,%eax
  80050d:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800513:	8b 45 0c             	mov    0xc(%ebp),%eax
  800516:	39 c2                	cmp    %eax,%edx
  800518:	74 14                	je     80052e <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  80051a:	83 ec 04             	sub    $0x4,%esp
  80051d:	68 9c 47 80 00       	push   $0x80479c
  800522:	6a 26                	push   $0x26
  800524:	68 e8 47 80 00       	push   $0x8047e8
  800529:	e8 5d ff ff ff       	call   80048b <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  80052e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800535:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80053c:	e9 c5 00 00 00       	jmp    800606 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  800541:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800544:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80054b:	8b 45 08             	mov    0x8(%ebp),%eax
  80054e:	01 d0                	add    %edx,%eax
  800550:	8b 00                	mov    (%eax),%eax
  800552:	85 c0                	test   %eax,%eax
  800554:	75 08                	jne    80055e <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  800556:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800559:	e9 a5 00 00 00       	jmp    800603 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  80055e:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800565:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  80056c:	eb 69                	jmp    8005d7 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  80056e:	a1 20 50 80 00       	mov    0x805020,%eax
  800573:	8b 88 a4 05 00 00    	mov    0x5a4(%eax),%ecx
  800579:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80057c:	89 d0                	mov    %edx,%eax
  80057e:	01 c0                	add    %eax,%eax
  800580:	01 d0                	add    %edx,%eax
  800582:	c1 e0 03             	shl    $0x3,%eax
  800585:	01 c8                	add    %ecx,%eax
  800587:	8a 40 04             	mov    0x4(%eax),%al
  80058a:	84 c0                	test   %al,%al
  80058c:	75 46                	jne    8005d4 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80058e:	a1 20 50 80 00       	mov    0x805020,%eax
  800593:	8b 88 a4 05 00 00    	mov    0x5a4(%eax),%ecx
  800599:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80059c:	89 d0                	mov    %edx,%eax
  80059e:	01 c0                	add    %eax,%eax
  8005a0:	01 d0                	add    %edx,%eax
  8005a2:	c1 e0 03             	shl    $0x3,%eax
  8005a5:	01 c8                	add    %ecx,%eax
  8005a7:	8b 00                	mov    (%eax),%eax
  8005a9:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8005ac:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8005af:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8005b4:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8005b6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8005b9:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8005c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8005c3:	01 c8                	add    %ecx,%eax
  8005c5:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8005c7:	39 c2                	cmp    %eax,%edx
  8005c9:	75 09                	jne    8005d4 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  8005cb:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8005d2:	eb 15                	jmp    8005e9 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8005d4:	ff 45 e8             	incl   -0x18(%ebp)
  8005d7:	a1 20 50 80 00       	mov    0x805020,%eax
  8005dc:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8005e2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8005e5:	39 c2                	cmp    %eax,%edx
  8005e7:	77 85                	ja     80056e <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8005e9:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8005ed:	75 14                	jne    800603 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  8005ef:	83 ec 04             	sub    $0x4,%esp
  8005f2:	68 f4 47 80 00       	push   $0x8047f4
  8005f7:	6a 3a                	push   $0x3a
  8005f9:	68 e8 47 80 00       	push   $0x8047e8
  8005fe:	e8 88 fe ff ff       	call   80048b <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800603:	ff 45 f0             	incl   -0x10(%ebp)
  800606:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800609:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80060c:	0f 8c 2f ff ff ff    	jl     800541 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800612:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800619:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800620:	eb 26                	jmp    800648 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800622:	a1 20 50 80 00       	mov    0x805020,%eax
  800627:	8b 88 a4 05 00 00    	mov    0x5a4(%eax),%ecx
  80062d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800630:	89 d0                	mov    %edx,%eax
  800632:	01 c0                	add    %eax,%eax
  800634:	01 d0                	add    %edx,%eax
  800636:	c1 e0 03             	shl    $0x3,%eax
  800639:	01 c8                	add    %ecx,%eax
  80063b:	8a 40 04             	mov    0x4(%eax),%al
  80063e:	3c 01                	cmp    $0x1,%al
  800640:	75 03                	jne    800645 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  800642:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800645:	ff 45 e0             	incl   -0x20(%ebp)
  800648:	a1 20 50 80 00       	mov    0x805020,%eax
  80064d:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800653:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800656:	39 c2                	cmp    %eax,%edx
  800658:	77 c8                	ja     800622 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  80065a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80065d:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800660:	74 14                	je     800676 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  800662:	83 ec 04             	sub    $0x4,%esp
  800665:	68 48 48 80 00       	push   $0x804848
  80066a:	6a 44                	push   $0x44
  80066c:	68 e8 47 80 00       	push   $0x8047e8
  800671:	e8 15 fe ff ff       	call   80048b <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800676:	90                   	nop
  800677:	c9                   	leave  
  800678:	c3                   	ret    

00800679 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  800679:	55                   	push   %ebp
  80067a:	89 e5                	mov    %esp,%ebp
  80067c:	53                   	push   %ebx
  80067d:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  800680:	8b 45 0c             	mov    0xc(%ebp),%eax
  800683:	8b 00                	mov    (%eax),%eax
  800685:	8d 48 01             	lea    0x1(%eax),%ecx
  800688:	8b 55 0c             	mov    0xc(%ebp),%edx
  80068b:	89 0a                	mov    %ecx,(%edx)
  80068d:	8b 55 08             	mov    0x8(%ebp),%edx
  800690:	88 d1                	mov    %dl,%cl
  800692:	8b 55 0c             	mov    0xc(%ebp),%edx
  800695:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800699:	8b 45 0c             	mov    0xc(%ebp),%eax
  80069c:	8b 00                	mov    (%eax),%eax
  80069e:	3d ff 00 00 00       	cmp    $0xff,%eax
  8006a3:	75 30                	jne    8006d5 <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  8006a5:	8b 15 1c d1 81 00    	mov    0x81d11c,%edx
  8006ab:	a0 44 50 80 00       	mov    0x805044,%al
  8006b0:	0f b6 c0             	movzbl %al,%eax
  8006b3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8006b6:	8b 09                	mov    (%ecx),%ecx
  8006b8:	89 cb                	mov    %ecx,%ebx
  8006ba:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8006bd:	83 c1 08             	add    $0x8,%ecx
  8006c0:	52                   	push   %edx
  8006c1:	50                   	push   %eax
  8006c2:	53                   	push   %ebx
  8006c3:	51                   	push   %ecx
  8006c4:	e8 07 29 00 00       	call   802fd0 <sys_cputs>
  8006c9:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8006cc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006cf:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8006d5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006d8:	8b 40 04             	mov    0x4(%eax),%eax
  8006db:	8d 50 01             	lea    0x1(%eax),%edx
  8006de:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006e1:	89 50 04             	mov    %edx,0x4(%eax)
}
  8006e4:	90                   	nop
  8006e5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8006e8:	c9                   	leave  
  8006e9:	c3                   	ret    

008006ea <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8006ea:	55                   	push   %ebp
  8006eb:	89 e5                	mov    %esp,%ebp
  8006ed:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8006f3:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8006fa:	00 00 00 
	b.cnt = 0;
  8006fd:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800704:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800707:	ff 75 0c             	pushl  0xc(%ebp)
  80070a:	ff 75 08             	pushl  0x8(%ebp)
  80070d:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800713:	50                   	push   %eax
  800714:	68 79 06 80 00       	push   $0x800679
  800719:	e8 5a 02 00 00       	call   800978 <vprintfmt>
  80071e:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  800721:	8b 15 1c d1 81 00    	mov    0x81d11c,%edx
  800727:	a0 44 50 80 00       	mov    0x805044,%al
  80072c:	0f b6 c0             	movzbl %al,%eax
  80072f:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  800735:	52                   	push   %edx
  800736:	50                   	push   %eax
  800737:	51                   	push   %ecx
  800738:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80073e:	83 c0 08             	add    $0x8,%eax
  800741:	50                   	push   %eax
  800742:	e8 89 28 00 00       	call   802fd0 <sys_cputs>
  800747:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  80074a:	c6 05 44 50 80 00 00 	movb   $0x0,0x805044
	return b.cnt;
  800751:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800757:	c9                   	leave  
  800758:	c3                   	ret    

00800759 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  800759:	55                   	push   %ebp
  80075a:	89 e5                	mov    %esp,%ebp
  80075c:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  80075f:	c6 05 44 50 80 00 01 	movb   $0x1,0x805044
	va_start(ap, fmt);
  800766:	8d 45 0c             	lea    0xc(%ebp),%eax
  800769:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80076c:	8b 45 08             	mov    0x8(%ebp),%eax
  80076f:	83 ec 08             	sub    $0x8,%esp
  800772:	ff 75 f4             	pushl  -0xc(%ebp)
  800775:	50                   	push   %eax
  800776:	e8 6f ff ff ff       	call   8006ea <vcprintf>
  80077b:	83 c4 10             	add    $0x10,%esp
  80077e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800781:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800784:	c9                   	leave  
  800785:	c3                   	ret    

00800786 <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  800786:	55                   	push   %ebp
  800787:	89 e5                	mov    %esp,%ebp
  800789:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  80078c:	c6 05 44 50 80 00 01 	movb   $0x1,0x805044
	curTextClr = (textClr << 8) ; //set text color by the given value
  800793:	8b 45 08             	mov    0x8(%ebp),%eax
  800796:	c1 e0 08             	shl    $0x8,%eax
  800799:	a3 1c d1 81 00       	mov    %eax,0x81d11c
	va_start(ap, fmt);
  80079e:	8d 45 0c             	lea    0xc(%ebp),%eax
  8007a1:	83 c0 04             	add    $0x4,%eax
  8007a4:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8007a7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007aa:	83 ec 08             	sub    $0x8,%esp
  8007ad:	ff 75 f4             	pushl  -0xc(%ebp)
  8007b0:	50                   	push   %eax
  8007b1:	e8 34 ff ff ff       	call   8006ea <vcprintf>
  8007b6:	83 c4 10             	add    $0x10,%esp
  8007b9:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  8007bc:	c7 05 1c d1 81 00 00 	movl   $0x700,0x81d11c
  8007c3:	07 00 00 

	return cnt;
  8007c6:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8007c9:	c9                   	leave  
  8007ca:	c3                   	ret    

008007cb <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  8007cb:	55                   	push   %ebp
  8007cc:	89 e5                	mov    %esp,%ebp
  8007ce:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  8007d1:	e8 3e 28 00 00       	call   803014 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  8007d6:	8d 45 0c             	lea    0xc(%ebp),%eax
  8007d9:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  8007dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8007df:	83 ec 08             	sub    $0x8,%esp
  8007e2:	ff 75 f4             	pushl  -0xc(%ebp)
  8007e5:	50                   	push   %eax
  8007e6:	e8 ff fe ff ff       	call   8006ea <vcprintf>
  8007eb:	83 c4 10             	add    $0x10,%esp
  8007ee:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  8007f1:	e8 38 28 00 00       	call   80302e <sys_unlock_cons>
	return cnt;
  8007f6:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8007f9:	c9                   	leave  
  8007fa:	c3                   	ret    

008007fb <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8007fb:	55                   	push   %ebp
  8007fc:	89 e5                	mov    %esp,%ebp
  8007fe:	53                   	push   %ebx
  8007ff:	83 ec 14             	sub    $0x14,%esp
  800802:	8b 45 10             	mov    0x10(%ebp),%eax
  800805:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800808:	8b 45 14             	mov    0x14(%ebp),%eax
  80080b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80080e:	8b 45 18             	mov    0x18(%ebp),%eax
  800811:	ba 00 00 00 00       	mov    $0x0,%edx
  800816:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800819:	77 55                	ja     800870 <printnum+0x75>
  80081b:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80081e:	72 05                	jb     800825 <printnum+0x2a>
  800820:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800823:	77 4b                	ja     800870 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800825:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800828:	8d 58 ff             	lea    -0x1(%eax),%ebx
  80082b:	8b 45 18             	mov    0x18(%ebp),%eax
  80082e:	ba 00 00 00 00       	mov    $0x0,%edx
  800833:	52                   	push   %edx
  800834:	50                   	push   %eax
  800835:	ff 75 f4             	pushl  -0xc(%ebp)
  800838:	ff 75 f0             	pushl  -0x10(%ebp)
  80083b:	e8 80 38 00 00       	call   8040c0 <__udivdi3>
  800840:	83 c4 10             	add    $0x10,%esp
  800843:	83 ec 04             	sub    $0x4,%esp
  800846:	ff 75 20             	pushl  0x20(%ebp)
  800849:	53                   	push   %ebx
  80084a:	ff 75 18             	pushl  0x18(%ebp)
  80084d:	52                   	push   %edx
  80084e:	50                   	push   %eax
  80084f:	ff 75 0c             	pushl  0xc(%ebp)
  800852:	ff 75 08             	pushl  0x8(%ebp)
  800855:	e8 a1 ff ff ff       	call   8007fb <printnum>
  80085a:	83 c4 20             	add    $0x20,%esp
  80085d:	eb 1a                	jmp    800879 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80085f:	83 ec 08             	sub    $0x8,%esp
  800862:	ff 75 0c             	pushl  0xc(%ebp)
  800865:	ff 75 20             	pushl  0x20(%ebp)
  800868:	8b 45 08             	mov    0x8(%ebp),%eax
  80086b:	ff d0                	call   *%eax
  80086d:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800870:	ff 4d 1c             	decl   0x1c(%ebp)
  800873:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800877:	7f e6                	jg     80085f <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800879:	8b 4d 18             	mov    0x18(%ebp),%ecx
  80087c:	bb 00 00 00 00       	mov    $0x0,%ebx
  800881:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800884:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800887:	53                   	push   %ebx
  800888:	51                   	push   %ecx
  800889:	52                   	push   %edx
  80088a:	50                   	push   %eax
  80088b:	e8 40 39 00 00       	call   8041d0 <__umoddi3>
  800890:	83 c4 10             	add    $0x10,%esp
  800893:	05 b4 4a 80 00       	add    $0x804ab4,%eax
  800898:	8a 00                	mov    (%eax),%al
  80089a:	0f be c0             	movsbl %al,%eax
  80089d:	83 ec 08             	sub    $0x8,%esp
  8008a0:	ff 75 0c             	pushl  0xc(%ebp)
  8008a3:	50                   	push   %eax
  8008a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8008a7:	ff d0                	call   *%eax
  8008a9:	83 c4 10             	add    $0x10,%esp
}
  8008ac:	90                   	nop
  8008ad:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8008b0:	c9                   	leave  
  8008b1:	c3                   	ret    

008008b2 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8008b2:	55                   	push   %ebp
  8008b3:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8008b5:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8008b9:	7e 1c                	jle    8008d7 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8008bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8008be:	8b 00                	mov    (%eax),%eax
  8008c0:	8d 50 08             	lea    0x8(%eax),%edx
  8008c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8008c6:	89 10                	mov    %edx,(%eax)
  8008c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8008cb:	8b 00                	mov    (%eax),%eax
  8008cd:	83 e8 08             	sub    $0x8,%eax
  8008d0:	8b 50 04             	mov    0x4(%eax),%edx
  8008d3:	8b 00                	mov    (%eax),%eax
  8008d5:	eb 40                	jmp    800917 <getuint+0x65>
	else if (lflag)
  8008d7:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8008db:	74 1e                	je     8008fb <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8008dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8008e0:	8b 00                	mov    (%eax),%eax
  8008e2:	8d 50 04             	lea    0x4(%eax),%edx
  8008e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8008e8:	89 10                	mov    %edx,(%eax)
  8008ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ed:	8b 00                	mov    (%eax),%eax
  8008ef:	83 e8 04             	sub    $0x4,%eax
  8008f2:	8b 00                	mov    (%eax),%eax
  8008f4:	ba 00 00 00 00       	mov    $0x0,%edx
  8008f9:	eb 1c                	jmp    800917 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8008fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8008fe:	8b 00                	mov    (%eax),%eax
  800900:	8d 50 04             	lea    0x4(%eax),%edx
  800903:	8b 45 08             	mov    0x8(%ebp),%eax
  800906:	89 10                	mov    %edx,(%eax)
  800908:	8b 45 08             	mov    0x8(%ebp),%eax
  80090b:	8b 00                	mov    (%eax),%eax
  80090d:	83 e8 04             	sub    $0x4,%eax
  800910:	8b 00                	mov    (%eax),%eax
  800912:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800917:	5d                   	pop    %ebp
  800918:	c3                   	ret    

00800919 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800919:	55                   	push   %ebp
  80091a:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80091c:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800920:	7e 1c                	jle    80093e <getint+0x25>
		return va_arg(*ap, long long);
  800922:	8b 45 08             	mov    0x8(%ebp),%eax
  800925:	8b 00                	mov    (%eax),%eax
  800927:	8d 50 08             	lea    0x8(%eax),%edx
  80092a:	8b 45 08             	mov    0x8(%ebp),%eax
  80092d:	89 10                	mov    %edx,(%eax)
  80092f:	8b 45 08             	mov    0x8(%ebp),%eax
  800932:	8b 00                	mov    (%eax),%eax
  800934:	83 e8 08             	sub    $0x8,%eax
  800937:	8b 50 04             	mov    0x4(%eax),%edx
  80093a:	8b 00                	mov    (%eax),%eax
  80093c:	eb 38                	jmp    800976 <getint+0x5d>
	else if (lflag)
  80093e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800942:	74 1a                	je     80095e <getint+0x45>
		return va_arg(*ap, long);
  800944:	8b 45 08             	mov    0x8(%ebp),%eax
  800947:	8b 00                	mov    (%eax),%eax
  800949:	8d 50 04             	lea    0x4(%eax),%edx
  80094c:	8b 45 08             	mov    0x8(%ebp),%eax
  80094f:	89 10                	mov    %edx,(%eax)
  800951:	8b 45 08             	mov    0x8(%ebp),%eax
  800954:	8b 00                	mov    (%eax),%eax
  800956:	83 e8 04             	sub    $0x4,%eax
  800959:	8b 00                	mov    (%eax),%eax
  80095b:	99                   	cltd   
  80095c:	eb 18                	jmp    800976 <getint+0x5d>
	else
		return va_arg(*ap, int);
  80095e:	8b 45 08             	mov    0x8(%ebp),%eax
  800961:	8b 00                	mov    (%eax),%eax
  800963:	8d 50 04             	lea    0x4(%eax),%edx
  800966:	8b 45 08             	mov    0x8(%ebp),%eax
  800969:	89 10                	mov    %edx,(%eax)
  80096b:	8b 45 08             	mov    0x8(%ebp),%eax
  80096e:	8b 00                	mov    (%eax),%eax
  800970:	83 e8 04             	sub    $0x4,%eax
  800973:	8b 00                	mov    (%eax),%eax
  800975:	99                   	cltd   
}
  800976:	5d                   	pop    %ebp
  800977:	c3                   	ret    

00800978 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800978:	55                   	push   %ebp
  800979:	89 e5                	mov    %esp,%ebp
  80097b:	56                   	push   %esi
  80097c:	53                   	push   %ebx
  80097d:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800980:	eb 17                	jmp    800999 <vprintfmt+0x21>
			if (ch == '\0')
  800982:	85 db                	test   %ebx,%ebx
  800984:	0f 84 c1 03 00 00    	je     800d4b <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  80098a:	83 ec 08             	sub    $0x8,%esp
  80098d:	ff 75 0c             	pushl  0xc(%ebp)
  800990:	53                   	push   %ebx
  800991:	8b 45 08             	mov    0x8(%ebp),%eax
  800994:	ff d0                	call   *%eax
  800996:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800999:	8b 45 10             	mov    0x10(%ebp),%eax
  80099c:	8d 50 01             	lea    0x1(%eax),%edx
  80099f:	89 55 10             	mov    %edx,0x10(%ebp)
  8009a2:	8a 00                	mov    (%eax),%al
  8009a4:	0f b6 d8             	movzbl %al,%ebx
  8009a7:	83 fb 25             	cmp    $0x25,%ebx
  8009aa:	75 d6                	jne    800982 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8009ac:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  8009b0:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  8009b7:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8009be:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8009c5:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8009cc:	8b 45 10             	mov    0x10(%ebp),%eax
  8009cf:	8d 50 01             	lea    0x1(%eax),%edx
  8009d2:	89 55 10             	mov    %edx,0x10(%ebp)
  8009d5:	8a 00                	mov    (%eax),%al
  8009d7:	0f b6 d8             	movzbl %al,%ebx
  8009da:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8009dd:	83 f8 5b             	cmp    $0x5b,%eax
  8009e0:	0f 87 3d 03 00 00    	ja     800d23 <vprintfmt+0x3ab>
  8009e6:	8b 04 85 d8 4a 80 00 	mov    0x804ad8(,%eax,4),%eax
  8009ed:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8009ef:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8009f3:	eb d7                	jmp    8009cc <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8009f5:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8009f9:	eb d1                	jmp    8009cc <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8009fb:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800a02:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800a05:	89 d0                	mov    %edx,%eax
  800a07:	c1 e0 02             	shl    $0x2,%eax
  800a0a:	01 d0                	add    %edx,%eax
  800a0c:	01 c0                	add    %eax,%eax
  800a0e:	01 d8                	add    %ebx,%eax
  800a10:	83 e8 30             	sub    $0x30,%eax
  800a13:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800a16:	8b 45 10             	mov    0x10(%ebp),%eax
  800a19:	8a 00                	mov    (%eax),%al
  800a1b:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800a1e:	83 fb 2f             	cmp    $0x2f,%ebx
  800a21:	7e 3e                	jle    800a61 <vprintfmt+0xe9>
  800a23:	83 fb 39             	cmp    $0x39,%ebx
  800a26:	7f 39                	jg     800a61 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800a28:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800a2b:	eb d5                	jmp    800a02 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800a2d:	8b 45 14             	mov    0x14(%ebp),%eax
  800a30:	83 c0 04             	add    $0x4,%eax
  800a33:	89 45 14             	mov    %eax,0x14(%ebp)
  800a36:	8b 45 14             	mov    0x14(%ebp),%eax
  800a39:	83 e8 04             	sub    $0x4,%eax
  800a3c:	8b 00                	mov    (%eax),%eax
  800a3e:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800a41:	eb 1f                	jmp    800a62 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800a43:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a47:	79 83                	jns    8009cc <vprintfmt+0x54>
				width = 0;
  800a49:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800a50:	e9 77 ff ff ff       	jmp    8009cc <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800a55:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800a5c:	e9 6b ff ff ff       	jmp    8009cc <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800a61:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800a62:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a66:	0f 89 60 ff ff ff    	jns    8009cc <vprintfmt+0x54>
				width = precision, precision = -1;
  800a6c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800a6f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800a72:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800a79:	e9 4e ff ff ff       	jmp    8009cc <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800a7e:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800a81:	e9 46 ff ff ff       	jmp    8009cc <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800a86:	8b 45 14             	mov    0x14(%ebp),%eax
  800a89:	83 c0 04             	add    $0x4,%eax
  800a8c:	89 45 14             	mov    %eax,0x14(%ebp)
  800a8f:	8b 45 14             	mov    0x14(%ebp),%eax
  800a92:	83 e8 04             	sub    $0x4,%eax
  800a95:	8b 00                	mov    (%eax),%eax
  800a97:	83 ec 08             	sub    $0x8,%esp
  800a9a:	ff 75 0c             	pushl  0xc(%ebp)
  800a9d:	50                   	push   %eax
  800a9e:	8b 45 08             	mov    0x8(%ebp),%eax
  800aa1:	ff d0                	call   *%eax
  800aa3:	83 c4 10             	add    $0x10,%esp
			break;
  800aa6:	e9 9b 02 00 00       	jmp    800d46 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800aab:	8b 45 14             	mov    0x14(%ebp),%eax
  800aae:	83 c0 04             	add    $0x4,%eax
  800ab1:	89 45 14             	mov    %eax,0x14(%ebp)
  800ab4:	8b 45 14             	mov    0x14(%ebp),%eax
  800ab7:	83 e8 04             	sub    $0x4,%eax
  800aba:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800abc:	85 db                	test   %ebx,%ebx
  800abe:	79 02                	jns    800ac2 <vprintfmt+0x14a>
				err = -err;
  800ac0:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800ac2:	83 fb 64             	cmp    $0x64,%ebx
  800ac5:	7f 0b                	jg     800ad2 <vprintfmt+0x15a>
  800ac7:	8b 34 9d 20 49 80 00 	mov    0x804920(,%ebx,4),%esi
  800ace:	85 f6                	test   %esi,%esi
  800ad0:	75 19                	jne    800aeb <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800ad2:	53                   	push   %ebx
  800ad3:	68 c5 4a 80 00       	push   $0x804ac5
  800ad8:	ff 75 0c             	pushl  0xc(%ebp)
  800adb:	ff 75 08             	pushl  0x8(%ebp)
  800ade:	e8 70 02 00 00       	call   800d53 <printfmt>
  800ae3:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800ae6:	e9 5b 02 00 00       	jmp    800d46 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800aeb:	56                   	push   %esi
  800aec:	68 ce 4a 80 00       	push   $0x804ace
  800af1:	ff 75 0c             	pushl  0xc(%ebp)
  800af4:	ff 75 08             	pushl  0x8(%ebp)
  800af7:	e8 57 02 00 00       	call   800d53 <printfmt>
  800afc:	83 c4 10             	add    $0x10,%esp
			break;
  800aff:	e9 42 02 00 00       	jmp    800d46 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800b04:	8b 45 14             	mov    0x14(%ebp),%eax
  800b07:	83 c0 04             	add    $0x4,%eax
  800b0a:	89 45 14             	mov    %eax,0x14(%ebp)
  800b0d:	8b 45 14             	mov    0x14(%ebp),%eax
  800b10:	83 e8 04             	sub    $0x4,%eax
  800b13:	8b 30                	mov    (%eax),%esi
  800b15:	85 f6                	test   %esi,%esi
  800b17:	75 05                	jne    800b1e <vprintfmt+0x1a6>
				p = "(null)";
  800b19:	be d1 4a 80 00       	mov    $0x804ad1,%esi
			if (width > 0 && padc != '-')
  800b1e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b22:	7e 6d                	jle    800b91 <vprintfmt+0x219>
  800b24:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800b28:	74 67                	je     800b91 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800b2a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800b2d:	83 ec 08             	sub    $0x8,%esp
  800b30:	50                   	push   %eax
  800b31:	56                   	push   %esi
  800b32:	e8 1e 03 00 00       	call   800e55 <strnlen>
  800b37:	83 c4 10             	add    $0x10,%esp
  800b3a:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800b3d:	eb 16                	jmp    800b55 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800b3f:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800b43:	83 ec 08             	sub    $0x8,%esp
  800b46:	ff 75 0c             	pushl  0xc(%ebp)
  800b49:	50                   	push   %eax
  800b4a:	8b 45 08             	mov    0x8(%ebp),%eax
  800b4d:	ff d0                	call   *%eax
  800b4f:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800b52:	ff 4d e4             	decl   -0x1c(%ebp)
  800b55:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b59:	7f e4                	jg     800b3f <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b5b:	eb 34                	jmp    800b91 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800b5d:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800b61:	74 1c                	je     800b7f <vprintfmt+0x207>
  800b63:	83 fb 1f             	cmp    $0x1f,%ebx
  800b66:	7e 05                	jle    800b6d <vprintfmt+0x1f5>
  800b68:	83 fb 7e             	cmp    $0x7e,%ebx
  800b6b:	7e 12                	jle    800b7f <vprintfmt+0x207>
					putch('?', putdat);
  800b6d:	83 ec 08             	sub    $0x8,%esp
  800b70:	ff 75 0c             	pushl  0xc(%ebp)
  800b73:	6a 3f                	push   $0x3f
  800b75:	8b 45 08             	mov    0x8(%ebp),%eax
  800b78:	ff d0                	call   *%eax
  800b7a:	83 c4 10             	add    $0x10,%esp
  800b7d:	eb 0f                	jmp    800b8e <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800b7f:	83 ec 08             	sub    $0x8,%esp
  800b82:	ff 75 0c             	pushl  0xc(%ebp)
  800b85:	53                   	push   %ebx
  800b86:	8b 45 08             	mov    0x8(%ebp),%eax
  800b89:	ff d0                	call   *%eax
  800b8b:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b8e:	ff 4d e4             	decl   -0x1c(%ebp)
  800b91:	89 f0                	mov    %esi,%eax
  800b93:	8d 70 01             	lea    0x1(%eax),%esi
  800b96:	8a 00                	mov    (%eax),%al
  800b98:	0f be d8             	movsbl %al,%ebx
  800b9b:	85 db                	test   %ebx,%ebx
  800b9d:	74 24                	je     800bc3 <vprintfmt+0x24b>
  800b9f:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800ba3:	78 b8                	js     800b5d <vprintfmt+0x1e5>
  800ba5:	ff 4d e0             	decl   -0x20(%ebp)
  800ba8:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800bac:	79 af                	jns    800b5d <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800bae:	eb 13                	jmp    800bc3 <vprintfmt+0x24b>
				putch(' ', putdat);
  800bb0:	83 ec 08             	sub    $0x8,%esp
  800bb3:	ff 75 0c             	pushl  0xc(%ebp)
  800bb6:	6a 20                	push   $0x20
  800bb8:	8b 45 08             	mov    0x8(%ebp),%eax
  800bbb:	ff d0                	call   *%eax
  800bbd:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800bc0:	ff 4d e4             	decl   -0x1c(%ebp)
  800bc3:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800bc7:	7f e7                	jg     800bb0 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800bc9:	e9 78 01 00 00       	jmp    800d46 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800bce:	83 ec 08             	sub    $0x8,%esp
  800bd1:	ff 75 e8             	pushl  -0x18(%ebp)
  800bd4:	8d 45 14             	lea    0x14(%ebp),%eax
  800bd7:	50                   	push   %eax
  800bd8:	e8 3c fd ff ff       	call   800919 <getint>
  800bdd:	83 c4 10             	add    $0x10,%esp
  800be0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800be3:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800be6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800be9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800bec:	85 d2                	test   %edx,%edx
  800bee:	79 23                	jns    800c13 <vprintfmt+0x29b>
				putch('-', putdat);
  800bf0:	83 ec 08             	sub    $0x8,%esp
  800bf3:	ff 75 0c             	pushl  0xc(%ebp)
  800bf6:	6a 2d                	push   $0x2d
  800bf8:	8b 45 08             	mov    0x8(%ebp),%eax
  800bfb:	ff d0                	call   *%eax
  800bfd:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800c00:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c03:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800c06:	f7 d8                	neg    %eax
  800c08:	83 d2 00             	adc    $0x0,%edx
  800c0b:	f7 da                	neg    %edx
  800c0d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c10:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800c13:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800c1a:	e9 bc 00 00 00       	jmp    800cdb <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800c1f:	83 ec 08             	sub    $0x8,%esp
  800c22:	ff 75 e8             	pushl  -0x18(%ebp)
  800c25:	8d 45 14             	lea    0x14(%ebp),%eax
  800c28:	50                   	push   %eax
  800c29:	e8 84 fc ff ff       	call   8008b2 <getuint>
  800c2e:	83 c4 10             	add    $0x10,%esp
  800c31:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c34:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800c37:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800c3e:	e9 98 00 00 00       	jmp    800cdb <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800c43:	83 ec 08             	sub    $0x8,%esp
  800c46:	ff 75 0c             	pushl  0xc(%ebp)
  800c49:	6a 58                	push   $0x58
  800c4b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c4e:	ff d0                	call   *%eax
  800c50:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800c53:	83 ec 08             	sub    $0x8,%esp
  800c56:	ff 75 0c             	pushl  0xc(%ebp)
  800c59:	6a 58                	push   $0x58
  800c5b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c5e:	ff d0                	call   *%eax
  800c60:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800c63:	83 ec 08             	sub    $0x8,%esp
  800c66:	ff 75 0c             	pushl  0xc(%ebp)
  800c69:	6a 58                	push   $0x58
  800c6b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c6e:	ff d0                	call   *%eax
  800c70:	83 c4 10             	add    $0x10,%esp
			break;
  800c73:	e9 ce 00 00 00       	jmp    800d46 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800c78:	83 ec 08             	sub    $0x8,%esp
  800c7b:	ff 75 0c             	pushl  0xc(%ebp)
  800c7e:	6a 30                	push   $0x30
  800c80:	8b 45 08             	mov    0x8(%ebp),%eax
  800c83:	ff d0                	call   *%eax
  800c85:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800c88:	83 ec 08             	sub    $0x8,%esp
  800c8b:	ff 75 0c             	pushl  0xc(%ebp)
  800c8e:	6a 78                	push   $0x78
  800c90:	8b 45 08             	mov    0x8(%ebp),%eax
  800c93:	ff d0                	call   *%eax
  800c95:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800c98:	8b 45 14             	mov    0x14(%ebp),%eax
  800c9b:	83 c0 04             	add    $0x4,%eax
  800c9e:	89 45 14             	mov    %eax,0x14(%ebp)
  800ca1:	8b 45 14             	mov    0x14(%ebp),%eax
  800ca4:	83 e8 04             	sub    $0x4,%eax
  800ca7:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800ca9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800cac:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800cb3:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800cba:	eb 1f                	jmp    800cdb <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800cbc:	83 ec 08             	sub    $0x8,%esp
  800cbf:	ff 75 e8             	pushl  -0x18(%ebp)
  800cc2:	8d 45 14             	lea    0x14(%ebp),%eax
  800cc5:	50                   	push   %eax
  800cc6:	e8 e7 fb ff ff       	call   8008b2 <getuint>
  800ccb:	83 c4 10             	add    $0x10,%esp
  800cce:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800cd1:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800cd4:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800cdb:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800cdf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800ce2:	83 ec 04             	sub    $0x4,%esp
  800ce5:	52                   	push   %edx
  800ce6:	ff 75 e4             	pushl  -0x1c(%ebp)
  800ce9:	50                   	push   %eax
  800cea:	ff 75 f4             	pushl  -0xc(%ebp)
  800ced:	ff 75 f0             	pushl  -0x10(%ebp)
  800cf0:	ff 75 0c             	pushl  0xc(%ebp)
  800cf3:	ff 75 08             	pushl  0x8(%ebp)
  800cf6:	e8 00 fb ff ff       	call   8007fb <printnum>
  800cfb:	83 c4 20             	add    $0x20,%esp
			break;
  800cfe:	eb 46                	jmp    800d46 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800d00:	83 ec 08             	sub    $0x8,%esp
  800d03:	ff 75 0c             	pushl  0xc(%ebp)
  800d06:	53                   	push   %ebx
  800d07:	8b 45 08             	mov    0x8(%ebp),%eax
  800d0a:	ff d0                	call   *%eax
  800d0c:	83 c4 10             	add    $0x10,%esp
			break;
  800d0f:	eb 35                	jmp    800d46 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800d11:	c6 05 44 50 80 00 00 	movb   $0x0,0x805044
			break;
  800d18:	eb 2c                	jmp    800d46 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800d1a:	c6 05 44 50 80 00 01 	movb   $0x1,0x805044
			break;
  800d21:	eb 23                	jmp    800d46 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800d23:	83 ec 08             	sub    $0x8,%esp
  800d26:	ff 75 0c             	pushl  0xc(%ebp)
  800d29:	6a 25                	push   $0x25
  800d2b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d2e:	ff d0                	call   *%eax
  800d30:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800d33:	ff 4d 10             	decl   0x10(%ebp)
  800d36:	eb 03                	jmp    800d3b <vprintfmt+0x3c3>
  800d38:	ff 4d 10             	decl   0x10(%ebp)
  800d3b:	8b 45 10             	mov    0x10(%ebp),%eax
  800d3e:	48                   	dec    %eax
  800d3f:	8a 00                	mov    (%eax),%al
  800d41:	3c 25                	cmp    $0x25,%al
  800d43:	75 f3                	jne    800d38 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800d45:	90                   	nop
		}
	}
  800d46:	e9 35 fc ff ff       	jmp    800980 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800d4b:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800d4c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800d4f:	5b                   	pop    %ebx
  800d50:	5e                   	pop    %esi
  800d51:	5d                   	pop    %ebp
  800d52:	c3                   	ret    

00800d53 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800d53:	55                   	push   %ebp
  800d54:	89 e5                	mov    %esp,%ebp
  800d56:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800d59:	8d 45 10             	lea    0x10(%ebp),%eax
  800d5c:	83 c0 04             	add    $0x4,%eax
  800d5f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800d62:	8b 45 10             	mov    0x10(%ebp),%eax
  800d65:	ff 75 f4             	pushl  -0xc(%ebp)
  800d68:	50                   	push   %eax
  800d69:	ff 75 0c             	pushl  0xc(%ebp)
  800d6c:	ff 75 08             	pushl  0x8(%ebp)
  800d6f:	e8 04 fc ff ff       	call   800978 <vprintfmt>
  800d74:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800d77:	90                   	nop
  800d78:	c9                   	leave  
  800d79:	c3                   	ret    

00800d7a <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800d7a:	55                   	push   %ebp
  800d7b:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800d7d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d80:	8b 40 08             	mov    0x8(%eax),%eax
  800d83:	8d 50 01             	lea    0x1(%eax),%edx
  800d86:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d89:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800d8c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d8f:	8b 10                	mov    (%eax),%edx
  800d91:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d94:	8b 40 04             	mov    0x4(%eax),%eax
  800d97:	39 c2                	cmp    %eax,%edx
  800d99:	73 12                	jae    800dad <sprintputch+0x33>
		*b->buf++ = ch;
  800d9b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d9e:	8b 00                	mov    (%eax),%eax
  800da0:	8d 48 01             	lea    0x1(%eax),%ecx
  800da3:	8b 55 0c             	mov    0xc(%ebp),%edx
  800da6:	89 0a                	mov    %ecx,(%edx)
  800da8:	8b 55 08             	mov    0x8(%ebp),%edx
  800dab:	88 10                	mov    %dl,(%eax)
}
  800dad:	90                   	nop
  800dae:	5d                   	pop    %ebp
  800daf:	c3                   	ret    

00800db0 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800db0:	55                   	push   %ebp
  800db1:	89 e5                	mov    %esp,%ebp
  800db3:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800db6:	8b 45 08             	mov    0x8(%ebp),%eax
  800db9:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800dbc:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dbf:	8d 50 ff             	lea    -0x1(%eax),%edx
  800dc2:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc5:	01 d0                	add    %edx,%eax
  800dc7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800dca:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800dd1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800dd5:	74 06                	je     800ddd <vsnprintf+0x2d>
  800dd7:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800ddb:	7f 07                	jg     800de4 <vsnprintf+0x34>
		return -E_INVAL;
  800ddd:	b8 03 00 00 00       	mov    $0x3,%eax
  800de2:	eb 20                	jmp    800e04 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800de4:	ff 75 14             	pushl  0x14(%ebp)
  800de7:	ff 75 10             	pushl  0x10(%ebp)
  800dea:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800ded:	50                   	push   %eax
  800dee:	68 7a 0d 80 00       	push   $0x800d7a
  800df3:	e8 80 fb ff ff       	call   800978 <vprintfmt>
  800df8:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800dfb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800dfe:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800e01:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800e04:	c9                   	leave  
  800e05:	c3                   	ret    

00800e06 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800e06:	55                   	push   %ebp
  800e07:	89 e5                	mov    %esp,%ebp
  800e09:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800e0c:	8d 45 10             	lea    0x10(%ebp),%eax
  800e0f:	83 c0 04             	add    $0x4,%eax
  800e12:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800e15:	8b 45 10             	mov    0x10(%ebp),%eax
  800e18:	ff 75 f4             	pushl  -0xc(%ebp)
  800e1b:	50                   	push   %eax
  800e1c:	ff 75 0c             	pushl  0xc(%ebp)
  800e1f:	ff 75 08             	pushl  0x8(%ebp)
  800e22:	e8 89 ff ff ff       	call   800db0 <vsnprintf>
  800e27:	83 c4 10             	add    $0x10,%esp
  800e2a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800e2d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800e30:	c9                   	leave  
  800e31:	c3                   	ret    

00800e32 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800e32:	55                   	push   %ebp
  800e33:	89 e5                	mov    %esp,%ebp
  800e35:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800e38:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800e3f:	eb 06                	jmp    800e47 <strlen+0x15>
		n++;
  800e41:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800e44:	ff 45 08             	incl   0x8(%ebp)
  800e47:	8b 45 08             	mov    0x8(%ebp),%eax
  800e4a:	8a 00                	mov    (%eax),%al
  800e4c:	84 c0                	test   %al,%al
  800e4e:	75 f1                	jne    800e41 <strlen+0xf>
		n++;
	return n;
  800e50:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e53:	c9                   	leave  
  800e54:	c3                   	ret    

00800e55 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800e55:	55                   	push   %ebp
  800e56:	89 e5                	mov    %esp,%ebp
  800e58:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800e5b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800e62:	eb 09                	jmp    800e6d <strnlen+0x18>
		n++;
  800e64:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800e67:	ff 45 08             	incl   0x8(%ebp)
  800e6a:	ff 4d 0c             	decl   0xc(%ebp)
  800e6d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e71:	74 09                	je     800e7c <strnlen+0x27>
  800e73:	8b 45 08             	mov    0x8(%ebp),%eax
  800e76:	8a 00                	mov    (%eax),%al
  800e78:	84 c0                	test   %al,%al
  800e7a:	75 e8                	jne    800e64 <strnlen+0xf>
		n++;
	return n;
  800e7c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e7f:	c9                   	leave  
  800e80:	c3                   	ret    

00800e81 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800e81:	55                   	push   %ebp
  800e82:	89 e5                	mov    %esp,%ebp
  800e84:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800e87:	8b 45 08             	mov    0x8(%ebp),%eax
  800e8a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800e8d:	90                   	nop
  800e8e:	8b 45 08             	mov    0x8(%ebp),%eax
  800e91:	8d 50 01             	lea    0x1(%eax),%edx
  800e94:	89 55 08             	mov    %edx,0x8(%ebp)
  800e97:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e9a:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e9d:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800ea0:	8a 12                	mov    (%edx),%dl
  800ea2:	88 10                	mov    %dl,(%eax)
  800ea4:	8a 00                	mov    (%eax),%al
  800ea6:	84 c0                	test   %al,%al
  800ea8:	75 e4                	jne    800e8e <strcpy+0xd>
		/* do nothing */;
	return ret;
  800eaa:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800ead:	c9                   	leave  
  800eae:	c3                   	ret    

00800eaf <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800eaf:	55                   	push   %ebp
  800eb0:	89 e5                	mov    %esp,%ebp
  800eb2:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800eb5:	8b 45 08             	mov    0x8(%ebp),%eax
  800eb8:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800ebb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800ec2:	eb 1f                	jmp    800ee3 <strncpy+0x34>
		*dst++ = *src;
  800ec4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ec7:	8d 50 01             	lea    0x1(%eax),%edx
  800eca:	89 55 08             	mov    %edx,0x8(%ebp)
  800ecd:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ed0:	8a 12                	mov    (%edx),%dl
  800ed2:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800ed4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ed7:	8a 00                	mov    (%eax),%al
  800ed9:	84 c0                	test   %al,%al
  800edb:	74 03                	je     800ee0 <strncpy+0x31>
			src++;
  800edd:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800ee0:	ff 45 fc             	incl   -0x4(%ebp)
  800ee3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ee6:	3b 45 10             	cmp    0x10(%ebp),%eax
  800ee9:	72 d9                	jb     800ec4 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800eeb:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800eee:	c9                   	leave  
  800eef:	c3                   	ret    

00800ef0 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800ef0:	55                   	push   %ebp
  800ef1:	89 e5                	mov    %esp,%ebp
  800ef3:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800ef6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800efc:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f00:	74 30                	je     800f32 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800f02:	eb 16                	jmp    800f1a <strlcpy+0x2a>
			*dst++ = *src++;
  800f04:	8b 45 08             	mov    0x8(%ebp),%eax
  800f07:	8d 50 01             	lea    0x1(%eax),%edx
  800f0a:	89 55 08             	mov    %edx,0x8(%ebp)
  800f0d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f10:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f13:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800f16:	8a 12                	mov    (%edx),%dl
  800f18:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800f1a:	ff 4d 10             	decl   0x10(%ebp)
  800f1d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f21:	74 09                	je     800f2c <strlcpy+0x3c>
  800f23:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f26:	8a 00                	mov    (%eax),%al
  800f28:	84 c0                	test   %al,%al
  800f2a:	75 d8                	jne    800f04 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800f2c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f2f:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800f32:	8b 55 08             	mov    0x8(%ebp),%edx
  800f35:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f38:	29 c2                	sub    %eax,%edx
  800f3a:	89 d0                	mov    %edx,%eax
}
  800f3c:	c9                   	leave  
  800f3d:	c3                   	ret    

00800f3e <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800f3e:	55                   	push   %ebp
  800f3f:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800f41:	eb 06                	jmp    800f49 <strcmp+0xb>
		p++, q++;
  800f43:	ff 45 08             	incl   0x8(%ebp)
  800f46:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800f49:	8b 45 08             	mov    0x8(%ebp),%eax
  800f4c:	8a 00                	mov    (%eax),%al
  800f4e:	84 c0                	test   %al,%al
  800f50:	74 0e                	je     800f60 <strcmp+0x22>
  800f52:	8b 45 08             	mov    0x8(%ebp),%eax
  800f55:	8a 10                	mov    (%eax),%dl
  800f57:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f5a:	8a 00                	mov    (%eax),%al
  800f5c:	38 c2                	cmp    %al,%dl
  800f5e:	74 e3                	je     800f43 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800f60:	8b 45 08             	mov    0x8(%ebp),%eax
  800f63:	8a 00                	mov    (%eax),%al
  800f65:	0f b6 d0             	movzbl %al,%edx
  800f68:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f6b:	8a 00                	mov    (%eax),%al
  800f6d:	0f b6 c0             	movzbl %al,%eax
  800f70:	29 c2                	sub    %eax,%edx
  800f72:	89 d0                	mov    %edx,%eax
}
  800f74:	5d                   	pop    %ebp
  800f75:	c3                   	ret    

00800f76 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800f76:	55                   	push   %ebp
  800f77:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800f79:	eb 09                	jmp    800f84 <strncmp+0xe>
		n--, p++, q++;
  800f7b:	ff 4d 10             	decl   0x10(%ebp)
  800f7e:	ff 45 08             	incl   0x8(%ebp)
  800f81:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800f84:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f88:	74 17                	je     800fa1 <strncmp+0x2b>
  800f8a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f8d:	8a 00                	mov    (%eax),%al
  800f8f:	84 c0                	test   %al,%al
  800f91:	74 0e                	je     800fa1 <strncmp+0x2b>
  800f93:	8b 45 08             	mov    0x8(%ebp),%eax
  800f96:	8a 10                	mov    (%eax),%dl
  800f98:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f9b:	8a 00                	mov    (%eax),%al
  800f9d:	38 c2                	cmp    %al,%dl
  800f9f:	74 da                	je     800f7b <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800fa1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fa5:	75 07                	jne    800fae <strncmp+0x38>
		return 0;
  800fa7:	b8 00 00 00 00       	mov    $0x0,%eax
  800fac:	eb 14                	jmp    800fc2 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800fae:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb1:	8a 00                	mov    (%eax),%al
  800fb3:	0f b6 d0             	movzbl %al,%edx
  800fb6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fb9:	8a 00                	mov    (%eax),%al
  800fbb:	0f b6 c0             	movzbl %al,%eax
  800fbe:	29 c2                	sub    %eax,%edx
  800fc0:	89 d0                	mov    %edx,%eax
}
  800fc2:	5d                   	pop    %ebp
  800fc3:	c3                   	ret    

00800fc4 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800fc4:	55                   	push   %ebp
  800fc5:	89 e5                	mov    %esp,%ebp
  800fc7:	83 ec 04             	sub    $0x4,%esp
  800fca:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fcd:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800fd0:	eb 12                	jmp    800fe4 <strchr+0x20>
		if (*s == c)
  800fd2:	8b 45 08             	mov    0x8(%ebp),%eax
  800fd5:	8a 00                	mov    (%eax),%al
  800fd7:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800fda:	75 05                	jne    800fe1 <strchr+0x1d>
			return (char *) s;
  800fdc:	8b 45 08             	mov    0x8(%ebp),%eax
  800fdf:	eb 11                	jmp    800ff2 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800fe1:	ff 45 08             	incl   0x8(%ebp)
  800fe4:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe7:	8a 00                	mov    (%eax),%al
  800fe9:	84 c0                	test   %al,%al
  800feb:	75 e5                	jne    800fd2 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800fed:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ff2:	c9                   	leave  
  800ff3:	c3                   	ret    

00800ff4 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800ff4:	55                   	push   %ebp
  800ff5:	89 e5                	mov    %esp,%ebp
  800ff7:	83 ec 04             	sub    $0x4,%esp
  800ffa:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ffd:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801000:	eb 0d                	jmp    80100f <strfind+0x1b>
		if (*s == c)
  801002:	8b 45 08             	mov    0x8(%ebp),%eax
  801005:	8a 00                	mov    (%eax),%al
  801007:	3a 45 fc             	cmp    -0x4(%ebp),%al
  80100a:	74 0e                	je     80101a <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  80100c:	ff 45 08             	incl   0x8(%ebp)
  80100f:	8b 45 08             	mov    0x8(%ebp),%eax
  801012:	8a 00                	mov    (%eax),%al
  801014:	84 c0                	test   %al,%al
  801016:	75 ea                	jne    801002 <strfind+0xe>
  801018:	eb 01                	jmp    80101b <strfind+0x27>
		if (*s == c)
			break;
  80101a:	90                   	nop
	return (char *) s;
  80101b:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80101e:	c9                   	leave  
  80101f:	c3                   	ret    

00801020 <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  801020:	55                   	push   %ebp
  801021:	89 e5                	mov    %esp,%ebp
  801023:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  801026:	8b 45 08             	mov    0x8(%ebp),%eax
  801029:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  80102c:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801030:	76 63                	jbe    801095 <memset+0x75>
		uint64 data_block = c;
  801032:	8b 45 0c             	mov    0xc(%ebp),%eax
  801035:	99                   	cltd   
  801036:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801039:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  80103c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80103f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801042:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  801046:	c1 e0 08             	shl    $0x8,%eax
  801049:	09 45 f0             	or     %eax,-0x10(%ebp)
  80104c:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  80104f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801052:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801055:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  801059:	c1 e0 10             	shl    $0x10,%eax
  80105c:	09 45 f0             	or     %eax,-0x10(%ebp)
  80105f:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  801062:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801065:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801068:	89 c2                	mov    %eax,%edx
  80106a:	b8 00 00 00 00       	mov    $0x0,%eax
  80106f:	09 45 f0             	or     %eax,-0x10(%ebp)
  801072:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  801075:	eb 18                	jmp    80108f <memset+0x6f>
			*p64++ = data_block, n -= 8;
  801077:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80107a:	8d 41 08             	lea    0x8(%ecx),%eax
  80107d:	89 45 fc             	mov    %eax,-0x4(%ebp)
  801080:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801083:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801086:	89 01                	mov    %eax,(%ecx)
  801088:	89 51 04             	mov    %edx,0x4(%ecx)
  80108b:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  80108f:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801093:	77 e2                	ja     801077 <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  801095:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801099:	74 23                	je     8010be <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  80109b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80109e:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  8010a1:	eb 0e                	jmp    8010b1 <memset+0x91>
			*p8++ = (uint8)c;
  8010a3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010a6:	8d 50 01             	lea    0x1(%eax),%edx
  8010a9:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8010ac:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010af:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  8010b1:	8b 45 10             	mov    0x10(%ebp),%eax
  8010b4:	8d 50 ff             	lea    -0x1(%eax),%edx
  8010b7:	89 55 10             	mov    %edx,0x10(%ebp)
  8010ba:	85 c0                	test   %eax,%eax
  8010bc:	75 e5                	jne    8010a3 <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  8010be:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8010c1:	c9                   	leave  
  8010c2:	c3                   	ret    

008010c3 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  8010c3:	55                   	push   %ebp
  8010c4:	89 e5                	mov    %esp,%ebp
  8010c6:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  8010c9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010cc:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  8010cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8010d2:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  8010d5:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  8010d9:	76 24                	jbe    8010ff <memcpy+0x3c>
		while(n >= 8){
  8010db:	eb 1c                	jmp    8010f9 <memcpy+0x36>
			*d64 = *s64;
  8010dd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010e0:	8b 50 04             	mov    0x4(%eax),%edx
  8010e3:	8b 00                	mov    (%eax),%eax
  8010e5:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8010e8:	89 01                	mov    %eax,(%ecx)
  8010ea:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  8010ed:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  8010f1:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  8010f5:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  8010f9:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  8010fd:	77 de                	ja     8010dd <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  8010ff:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801103:	74 31                	je     801136 <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  801105:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801108:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  80110b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80110e:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  801111:	eb 16                	jmp    801129 <memcpy+0x66>
			*d8++ = *s8++;
  801113:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801116:	8d 50 01             	lea    0x1(%eax),%edx
  801119:	89 55 f0             	mov    %edx,-0x10(%ebp)
  80111c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80111f:	8d 4a 01             	lea    0x1(%edx),%ecx
  801122:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  801125:	8a 12                	mov    (%edx),%dl
  801127:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  801129:	8b 45 10             	mov    0x10(%ebp),%eax
  80112c:	8d 50 ff             	lea    -0x1(%eax),%edx
  80112f:	89 55 10             	mov    %edx,0x10(%ebp)
  801132:	85 c0                	test   %eax,%eax
  801134:	75 dd                	jne    801113 <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  801136:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801139:	c9                   	leave  
  80113a:	c3                   	ret    

0080113b <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  80113b:	55                   	push   %ebp
  80113c:	89 e5                	mov    %esp,%ebp
  80113e:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801141:	8b 45 0c             	mov    0xc(%ebp),%eax
  801144:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801147:	8b 45 08             	mov    0x8(%ebp),%eax
  80114a:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  80114d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801150:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801153:	73 50                	jae    8011a5 <memmove+0x6a>
  801155:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801158:	8b 45 10             	mov    0x10(%ebp),%eax
  80115b:	01 d0                	add    %edx,%eax
  80115d:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801160:	76 43                	jbe    8011a5 <memmove+0x6a>
		s += n;
  801162:	8b 45 10             	mov    0x10(%ebp),%eax
  801165:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801168:	8b 45 10             	mov    0x10(%ebp),%eax
  80116b:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  80116e:	eb 10                	jmp    801180 <memmove+0x45>
			*--d = *--s;
  801170:	ff 4d f8             	decl   -0x8(%ebp)
  801173:	ff 4d fc             	decl   -0x4(%ebp)
  801176:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801179:	8a 10                	mov    (%eax),%dl
  80117b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80117e:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  801180:	8b 45 10             	mov    0x10(%ebp),%eax
  801183:	8d 50 ff             	lea    -0x1(%eax),%edx
  801186:	89 55 10             	mov    %edx,0x10(%ebp)
  801189:	85 c0                	test   %eax,%eax
  80118b:	75 e3                	jne    801170 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  80118d:	eb 23                	jmp    8011b2 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  80118f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801192:	8d 50 01             	lea    0x1(%eax),%edx
  801195:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801198:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80119b:	8d 4a 01             	lea    0x1(%edx),%ecx
  80119e:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8011a1:	8a 12                	mov    (%edx),%dl
  8011a3:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  8011a5:	8b 45 10             	mov    0x10(%ebp),%eax
  8011a8:	8d 50 ff             	lea    -0x1(%eax),%edx
  8011ab:	89 55 10             	mov    %edx,0x10(%ebp)
  8011ae:	85 c0                	test   %eax,%eax
  8011b0:	75 dd                	jne    80118f <memmove+0x54>
			*d++ = *s++;

	return dst;
  8011b2:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8011b5:	c9                   	leave  
  8011b6:	c3                   	ret    

008011b7 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8011b7:	55                   	push   %ebp
  8011b8:	89 e5                	mov    %esp,%ebp
  8011ba:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  8011bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8011c0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  8011c3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011c6:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8011c9:	eb 2a                	jmp    8011f5 <memcmp+0x3e>
		if (*s1 != *s2)
  8011cb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011ce:	8a 10                	mov    (%eax),%dl
  8011d0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011d3:	8a 00                	mov    (%eax),%al
  8011d5:	38 c2                	cmp    %al,%dl
  8011d7:	74 16                	je     8011ef <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  8011d9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011dc:	8a 00                	mov    (%eax),%al
  8011de:	0f b6 d0             	movzbl %al,%edx
  8011e1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011e4:	8a 00                	mov    (%eax),%al
  8011e6:	0f b6 c0             	movzbl %al,%eax
  8011e9:	29 c2                	sub    %eax,%edx
  8011eb:	89 d0                	mov    %edx,%eax
  8011ed:	eb 18                	jmp    801207 <memcmp+0x50>
		s1++, s2++;
  8011ef:	ff 45 fc             	incl   -0x4(%ebp)
  8011f2:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  8011f5:	8b 45 10             	mov    0x10(%ebp),%eax
  8011f8:	8d 50 ff             	lea    -0x1(%eax),%edx
  8011fb:	89 55 10             	mov    %edx,0x10(%ebp)
  8011fe:	85 c0                	test   %eax,%eax
  801200:	75 c9                	jne    8011cb <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801202:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801207:	c9                   	leave  
  801208:	c3                   	ret    

00801209 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801209:	55                   	push   %ebp
  80120a:	89 e5                	mov    %esp,%ebp
  80120c:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  80120f:	8b 55 08             	mov    0x8(%ebp),%edx
  801212:	8b 45 10             	mov    0x10(%ebp),%eax
  801215:	01 d0                	add    %edx,%eax
  801217:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  80121a:	eb 15                	jmp    801231 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  80121c:	8b 45 08             	mov    0x8(%ebp),%eax
  80121f:	8a 00                	mov    (%eax),%al
  801221:	0f b6 d0             	movzbl %al,%edx
  801224:	8b 45 0c             	mov    0xc(%ebp),%eax
  801227:	0f b6 c0             	movzbl %al,%eax
  80122a:	39 c2                	cmp    %eax,%edx
  80122c:	74 0d                	je     80123b <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80122e:	ff 45 08             	incl   0x8(%ebp)
  801231:	8b 45 08             	mov    0x8(%ebp),%eax
  801234:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801237:	72 e3                	jb     80121c <memfind+0x13>
  801239:	eb 01                	jmp    80123c <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  80123b:	90                   	nop
	return (void *) s;
  80123c:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80123f:	c9                   	leave  
  801240:	c3                   	ret    

00801241 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801241:	55                   	push   %ebp
  801242:	89 e5                	mov    %esp,%ebp
  801244:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801247:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  80124e:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801255:	eb 03                	jmp    80125a <strtol+0x19>
		s++;
  801257:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80125a:	8b 45 08             	mov    0x8(%ebp),%eax
  80125d:	8a 00                	mov    (%eax),%al
  80125f:	3c 20                	cmp    $0x20,%al
  801261:	74 f4                	je     801257 <strtol+0x16>
  801263:	8b 45 08             	mov    0x8(%ebp),%eax
  801266:	8a 00                	mov    (%eax),%al
  801268:	3c 09                	cmp    $0x9,%al
  80126a:	74 eb                	je     801257 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  80126c:	8b 45 08             	mov    0x8(%ebp),%eax
  80126f:	8a 00                	mov    (%eax),%al
  801271:	3c 2b                	cmp    $0x2b,%al
  801273:	75 05                	jne    80127a <strtol+0x39>
		s++;
  801275:	ff 45 08             	incl   0x8(%ebp)
  801278:	eb 13                	jmp    80128d <strtol+0x4c>
	else if (*s == '-')
  80127a:	8b 45 08             	mov    0x8(%ebp),%eax
  80127d:	8a 00                	mov    (%eax),%al
  80127f:	3c 2d                	cmp    $0x2d,%al
  801281:	75 0a                	jne    80128d <strtol+0x4c>
		s++, neg = 1;
  801283:	ff 45 08             	incl   0x8(%ebp)
  801286:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80128d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801291:	74 06                	je     801299 <strtol+0x58>
  801293:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801297:	75 20                	jne    8012b9 <strtol+0x78>
  801299:	8b 45 08             	mov    0x8(%ebp),%eax
  80129c:	8a 00                	mov    (%eax),%al
  80129e:	3c 30                	cmp    $0x30,%al
  8012a0:	75 17                	jne    8012b9 <strtol+0x78>
  8012a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a5:	40                   	inc    %eax
  8012a6:	8a 00                	mov    (%eax),%al
  8012a8:	3c 78                	cmp    $0x78,%al
  8012aa:	75 0d                	jne    8012b9 <strtol+0x78>
		s += 2, base = 16;
  8012ac:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8012b0:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8012b7:	eb 28                	jmp    8012e1 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8012b9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8012bd:	75 15                	jne    8012d4 <strtol+0x93>
  8012bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8012c2:	8a 00                	mov    (%eax),%al
  8012c4:	3c 30                	cmp    $0x30,%al
  8012c6:	75 0c                	jne    8012d4 <strtol+0x93>
		s++, base = 8;
  8012c8:	ff 45 08             	incl   0x8(%ebp)
  8012cb:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8012d2:	eb 0d                	jmp    8012e1 <strtol+0xa0>
	else if (base == 0)
  8012d4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8012d8:	75 07                	jne    8012e1 <strtol+0xa0>
		base = 10;
  8012da:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8012e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8012e4:	8a 00                	mov    (%eax),%al
  8012e6:	3c 2f                	cmp    $0x2f,%al
  8012e8:	7e 19                	jle    801303 <strtol+0xc2>
  8012ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8012ed:	8a 00                	mov    (%eax),%al
  8012ef:	3c 39                	cmp    $0x39,%al
  8012f1:	7f 10                	jg     801303 <strtol+0xc2>
			dig = *s - '0';
  8012f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8012f6:	8a 00                	mov    (%eax),%al
  8012f8:	0f be c0             	movsbl %al,%eax
  8012fb:	83 e8 30             	sub    $0x30,%eax
  8012fe:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801301:	eb 42                	jmp    801345 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801303:	8b 45 08             	mov    0x8(%ebp),%eax
  801306:	8a 00                	mov    (%eax),%al
  801308:	3c 60                	cmp    $0x60,%al
  80130a:	7e 19                	jle    801325 <strtol+0xe4>
  80130c:	8b 45 08             	mov    0x8(%ebp),%eax
  80130f:	8a 00                	mov    (%eax),%al
  801311:	3c 7a                	cmp    $0x7a,%al
  801313:	7f 10                	jg     801325 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801315:	8b 45 08             	mov    0x8(%ebp),%eax
  801318:	8a 00                	mov    (%eax),%al
  80131a:	0f be c0             	movsbl %al,%eax
  80131d:	83 e8 57             	sub    $0x57,%eax
  801320:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801323:	eb 20                	jmp    801345 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801325:	8b 45 08             	mov    0x8(%ebp),%eax
  801328:	8a 00                	mov    (%eax),%al
  80132a:	3c 40                	cmp    $0x40,%al
  80132c:	7e 39                	jle    801367 <strtol+0x126>
  80132e:	8b 45 08             	mov    0x8(%ebp),%eax
  801331:	8a 00                	mov    (%eax),%al
  801333:	3c 5a                	cmp    $0x5a,%al
  801335:	7f 30                	jg     801367 <strtol+0x126>
			dig = *s - 'A' + 10;
  801337:	8b 45 08             	mov    0x8(%ebp),%eax
  80133a:	8a 00                	mov    (%eax),%al
  80133c:	0f be c0             	movsbl %al,%eax
  80133f:	83 e8 37             	sub    $0x37,%eax
  801342:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801345:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801348:	3b 45 10             	cmp    0x10(%ebp),%eax
  80134b:	7d 19                	jge    801366 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  80134d:	ff 45 08             	incl   0x8(%ebp)
  801350:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801353:	0f af 45 10          	imul   0x10(%ebp),%eax
  801357:	89 c2                	mov    %eax,%edx
  801359:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80135c:	01 d0                	add    %edx,%eax
  80135e:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801361:	e9 7b ff ff ff       	jmp    8012e1 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801366:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801367:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80136b:	74 08                	je     801375 <strtol+0x134>
		*endptr = (char *) s;
  80136d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801370:	8b 55 08             	mov    0x8(%ebp),%edx
  801373:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801375:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801379:	74 07                	je     801382 <strtol+0x141>
  80137b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80137e:	f7 d8                	neg    %eax
  801380:	eb 03                	jmp    801385 <strtol+0x144>
  801382:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801385:	c9                   	leave  
  801386:	c3                   	ret    

00801387 <ltostr>:

void
ltostr(long value, char *str)
{
  801387:	55                   	push   %ebp
  801388:	89 e5                	mov    %esp,%ebp
  80138a:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  80138d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801394:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  80139b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80139f:	79 13                	jns    8013b4 <ltostr+0x2d>
	{
		neg = 1;
  8013a1:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8013a8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013ab:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8013ae:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8013b1:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8013b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8013b7:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8013bc:	99                   	cltd   
  8013bd:	f7 f9                	idiv   %ecx
  8013bf:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8013c2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8013c5:	8d 50 01             	lea    0x1(%eax),%edx
  8013c8:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8013cb:	89 c2                	mov    %eax,%edx
  8013cd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013d0:	01 d0                	add    %edx,%eax
  8013d2:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8013d5:	83 c2 30             	add    $0x30,%edx
  8013d8:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8013da:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8013dd:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8013e2:	f7 e9                	imul   %ecx
  8013e4:	c1 fa 02             	sar    $0x2,%edx
  8013e7:	89 c8                	mov    %ecx,%eax
  8013e9:	c1 f8 1f             	sar    $0x1f,%eax
  8013ec:	29 c2                	sub    %eax,%edx
  8013ee:	89 d0                	mov    %edx,%eax
  8013f0:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  8013f3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8013f7:	75 bb                	jne    8013b4 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8013f9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801400:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801403:	48                   	dec    %eax
  801404:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801407:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80140b:	74 3d                	je     80144a <ltostr+0xc3>
		start = 1 ;
  80140d:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801414:	eb 34                	jmp    80144a <ltostr+0xc3>
	{
		char tmp = str[start] ;
  801416:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801419:	8b 45 0c             	mov    0xc(%ebp),%eax
  80141c:	01 d0                	add    %edx,%eax
  80141e:	8a 00                	mov    (%eax),%al
  801420:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801423:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801426:	8b 45 0c             	mov    0xc(%ebp),%eax
  801429:	01 c2                	add    %eax,%edx
  80142b:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80142e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801431:	01 c8                	add    %ecx,%eax
  801433:	8a 00                	mov    (%eax),%al
  801435:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801437:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80143a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80143d:	01 c2                	add    %eax,%edx
  80143f:	8a 45 eb             	mov    -0x15(%ebp),%al
  801442:	88 02                	mov    %al,(%edx)
		start++ ;
  801444:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801447:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  80144a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80144d:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801450:	7c c4                	jl     801416 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801452:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801455:	8b 45 0c             	mov    0xc(%ebp),%eax
  801458:	01 d0                	add    %edx,%eax
  80145a:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  80145d:	90                   	nop
  80145e:	c9                   	leave  
  80145f:	c3                   	ret    

00801460 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801460:	55                   	push   %ebp
  801461:	89 e5                	mov    %esp,%ebp
  801463:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801466:	ff 75 08             	pushl  0x8(%ebp)
  801469:	e8 c4 f9 ff ff       	call   800e32 <strlen>
  80146e:	83 c4 04             	add    $0x4,%esp
  801471:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801474:	ff 75 0c             	pushl  0xc(%ebp)
  801477:	e8 b6 f9 ff ff       	call   800e32 <strlen>
  80147c:	83 c4 04             	add    $0x4,%esp
  80147f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801482:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801489:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801490:	eb 17                	jmp    8014a9 <strcconcat+0x49>
		final[s] = str1[s] ;
  801492:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801495:	8b 45 10             	mov    0x10(%ebp),%eax
  801498:	01 c2                	add    %eax,%edx
  80149a:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80149d:	8b 45 08             	mov    0x8(%ebp),%eax
  8014a0:	01 c8                	add    %ecx,%eax
  8014a2:	8a 00                	mov    (%eax),%al
  8014a4:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8014a6:	ff 45 fc             	incl   -0x4(%ebp)
  8014a9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8014ac:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8014af:	7c e1                	jl     801492 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8014b1:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8014b8:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8014bf:	eb 1f                	jmp    8014e0 <strcconcat+0x80>
		final[s++] = str2[i] ;
  8014c1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8014c4:	8d 50 01             	lea    0x1(%eax),%edx
  8014c7:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8014ca:	89 c2                	mov    %eax,%edx
  8014cc:	8b 45 10             	mov    0x10(%ebp),%eax
  8014cf:	01 c2                	add    %eax,%edx
  8014d1:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8014d4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014d7:	01 c8                	add    %ecx,%eax
  8014d9:	8a 00                	mov    (%eax),%al
  8014db:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8014dd:	ff 45 f8             	incl   -0x8(%ebp)
  8014e0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8014e3:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8014e6:	7c d9                	jl     8014c1 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8014e8:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8014eb:	8b 45 10             	mov    0x10(%ebp),%eax
  8014ee:	01 d0                	add    %edx,%eax
  8014f0:	c6 00 00             	movb   $0x0,(%eax)
}
  8014f3:	90                   	nop
  8014f4:	c9                   	leave  
  8014f5:	c3                   	ret    

008014f6 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8014f6:	55                   	push   %ebp
  8014f7:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8014f9:	8b 45 14             	mov    0x14(%ebp),%eax
  8014fc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801502:	8b 45 14             	mov    0x14(%ebp),%eax
  801505:	8b 00                	mov    (%eax),%eax
  801507:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80150e:	8b 45 10             	mov    0x10(%ebp),%eax
  801511:	01 d0                	add    %edx,%eax
  801513:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801519:	eb 0c                	jmp    801527 <strsplit+0x31>
			*string++ = 0;
  80151b:	8b 45 08             	mov    0x8(%ebp),%eax
  80151e:	8d 50 01             	lea    0x1(%eax),%edx
  801521:	89 55 08             	mov    %edx,0x8(%ebp)
  801524:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801527:	8b 45 08             	mov    0x8(%ebp),%eax
  80152a:	8a 00                	mov    (%eax),%al
  80152c:	84 c0                	test   %al,%al
  80152e:	74 18                	je     801548 <strsplit+0x52>
  801530:	8b 45 08             	mov    0x8(%ebp),%eax
  801533:	8a 00                	mov    (%eax),%al
  801535:	0f be c0             	movsbl %al,%eax
  801538:	50                   	push   %eax
  801539:	ff 75 0c             	pushl  0xc(%ebp)
  80153c:	e8 83 fa ff ff       	call   800fc4 <strchr>
  801541:	83 c4 08             	add    $0x8,%esp
  801544:	85 c0                	test   %eax,%eax
  801546:	75 d3                	jne    80151b <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801548:	8b 45 08             	mov    0x8(%ebp),%eax
  80154b:	8a 00                	mov    (%eax),%al
  80154d:	84 c0                	test   %al,%al
  80154f:	74 5a                	je     8015ab <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801551:	8b 45 14             	mov    0x14(%ebp),%eax
  801554:	8b 00                	mov    (%eax),%eax
  801556:	83 f8 0f             	cmp    $0xf,%eax
  801559:	75 07                	jne    801562 <strsplit+0x6c>
		{
			return 0;
  80155b:	b8 00 00 00 00       	mov    $0x0,%eax
  801560:	eb 66                	jmp    8015c8 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801562:	8b 45 14             	mov    0x14(%ebp),%eax
  801565:	8b 00                	mov    (%eax),%eax
  801567:	8d 48 01             	lea    0x1(%eax),%ecx
  80156a:	8b 55 14             	mov    0x14(%ebp),%edx
  80156d:	89 0a                	mov    %ecx,(%edx)
  80156f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801576:	8b 45 10             	mov    0x10(%ebp),%eax
  801579:	01 c2                	add    %eax,%edx
  80157b:	8b 45 08             	mov    0x8(%ebp),%eax
  80157e:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801580:	eb 03                	jmp    801585 <strsplit+0x8f>
			string++;
  801582:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801585:	8b 45 08             	mov    0x8(%ebp),%eax
  801588:	8a 00                	mov    (%eax),%al
  80158a:	84 c0                	test   %al,%al
  80158c:	74 8b                	je     801519 <strsplit+0x23>
  80158e:	8b 45 08             	mov    0x8(%ebp),%eax
  801591:	8a 00                	mov    (%eax),%al
  801593:	0f be c0             	movsbl %al,%eax
  801596:	50                   	push   %eax
  801597:	ff 75 0c             	pushl  0xc(%ebp)
  80159a:	e8 25 fa ff ff       	call   800fc4 <strchr>
  80159f:	83 c4 08             	add    $0x8,%esp
  8015a2:	85 c0                	test   %eax,%eax
  8015a4:	74 dc                	je     801582 <strsplit+0x8c>
			string++;
	}
  8015a6:	e9 6e ff ff ff       	jmp    801519 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8015ab:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8015ac:	8b 45 14             	mov    0x14(%ebp),%eax
  8015af:	8b 00                	mov    (%eax),%eax
  8015b1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8015b8:	8b 45 10             	mov    0x10(%ebp),%eax
  8015bb:	01 d0                	add    %edx,%eax
  8015bd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8015c3:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8015c8:	c9                   	leave  
  8015c9:	c3                   	ret    

008015ca <str2lower>:


char* str2lower(char *dst, const char *src)
{
  8015ca:	55                   	push   %ebp
  8015cb:	89 e5                	mov    %esp,%ebp
  8015cd:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  8015d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8015d3:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  8015d6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8015dd:	eb 4a                	jmp    801629 <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  8015df:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8015e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8015e5:	01 c2                	add    %eax,%edx
  8015e7:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8015ea:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015ed:	01 c8                	add    %ecx,%eax
  8015ef:	8a 00                	mov    (%eax),%al
  8015f1:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  8015f3:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8015f6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015f9:	01 d0                	add    %edx,%eax
  8015fb:	8a 00                	mov    (%eax),%al
  8015fd:	3c 40                	cmp    $0x40,%al
  8015ff:	7e 25                	jle    801626 <str2lower+0x5c>
  801601:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801604:	8b 45 0c             	mov    0xc(%ebp),%eax
  801607:	01 d0                	add    %edx,%eax
  801609:	8a 00                	mov    (%eax),%al
  80160b:	3c 5a                	cmp    $0x5a,%al
  80160d:	7f 17                	jg     801626 <str2lower+0x5c>
		{
			dst[i] += 32 ;
  80160f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801612:	8b 45 08             	mov    0x8(%ebp),%eax
  801615:	01 d0                	add    %edx,%eax
  801617:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80161a:	8b 55 08             	mov    0x8(%ebp),%edx
  80161d:	01 ca                	add    %ecx,%edx
  80161f:	8a 12                	mov    (%edx),%dl
  801621:	83 c2 20             	add    $0x20,%edx
  801624:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  801626:	ff 45 fc             	incl   -0x4(%ebp)
  801629:	ff 75 0c             	pushl  0xc(%ebp)
  80162c:	e8 01 f8 ff ff       	call   800e32 <strlen>
  801631:	83 c4 04             	add    $0x4,%esp
  801634:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801637:	7f a6                	jg     8015df <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  801639:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80163c:	c9                   	leave  
  80163d:	c3                   	ret    

0080163e <uheap_init>:
//==============================================
// [1] INITIALIZE USER HEAP:
//==============================================
int __firstTimeFlag = 1;
void uheap_init()
{
  80163e:	55                   	push   %ebp
  80163f:	89 e5                	mov    %esp,%ebp
  801641:	83 ec 08             	sub    $0x8,%esp
	if(__firstTimeFlag)
  801644:	a1 08 50 80 00       	mov    0x805008,%eax
  801649:	85 c0                	test   %eax,%eax
  80164b:	0f 84 95 00 00 00    	je     8016e6 <uheap_init+0xa8>
	{
		initialize_dynamic_allocator(USER_HEAP_START, USER_HEAP_START + DYN_ALLOC_MAX_SIZE);
  801651:	83 ec 08             	sub    $0x8,%esp
  801654:	68 00 00 00 82       	push   $0x82000000
  801659:	68 00 00 00 80       	push   $0x80000000
  80165e:	e8 59 1f 00 00       	call   8035bc <initialize_dynamic_allocator>
  801663:	83 c4 10             	add    $0x10,%esp
		uheapPlaceStrategy = sys_get_uheap_strategy();
  801666:	e8 93 1d 00 00       	call   8033fe <sys_get_uheap_strategy>
  80166b:	a3 60 d0 81 00       	mov    %eax,0x81d060
		uheapPageAllocStart = dynAllocEnd + PAGE_SIZE;
  801670:	a1 40 50 80 00       	mov    0x805040,%eax
  801675:	05 00 10 00 00       	add    $0x1000,%eax
  80167a:	a3 10 d1 81 00       	mov    %eax,0x81d110
		uheapPageAllocBreak = uheapPageAllocStart;
  80167f:	a1 10 d1 81 00       	mov    0x81d110,%eax
  801684:	a3 68 d0 81 00       	mov    %eax,0x81d068
		init_uspinlock(&ulock,"malloc",1);
  801689:	83 ec 04             	sub    $0x4,%esp
  80168c:	6a 01                	push   $0x1
  80168e:	68 48 4c 80 00       	push   $0x804c48
  801693:	68 40 d1 81 00       	push   $0x81d140
  801698:	e8 1a 29 00 00       	call   803fb7 <init_uspinlock>
  80169d:	83 c4 10             	add    $0x10,%esp
		LIST_INIT(&u_freelist);
  8016a0:	c7 05 20 d1 81 00 00 	movl   $0x0,0x81d120
  8016a7:	00 00 00 
  8016aa:	c7 05 24 d1 81 00 00 	movl   $0x0,0x81d124
  8016b1:	00 00 00 
  8016b4:	c7 05 2c d1 81 00 00 	movl   $0x0,0x81d12c
  8016bb:	00 00 00 
		LIST_INIT(&u_allocatedlist);
  8016be:	c7 05 30 d1 81 00 00 	movl   $0x0,0x81d130
  8016c5:	00 00 00 
  8016c8:	c7 05 34 d1 81 00 00 	movl   $0x0,0x81d134
  8016cf:	00 00 00 
  8016d2:	c7 05 3c d1 81 00 00 	movl   $0x0,0x81d13c
  8016d9:	00 00 00 
		__firstTimeFlag = 0;
  8016dc:	c7 05 08 50 80 00 00 	movl   $0x0,0x805008
  8016e3:	00 00 00 
	}
}
  8016e6:	90                   	nop
  8016e7:	c9                   	leave  
  8016e8:	c3                   	ret    

008016e9 <get_page>:

//==============================================
// [2] GET A PAGE FROM THE KERNEL FOR DA:
//==============================================
int get_page(void* va)
{
  8016e9:	55                   	push   %ebp
  8016ea:	89 e5                	mov    %esp,%ebp
  8016ec:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_allocate_page(ROUNDDOWN(va, PAGE_SIZE), PERM_USER|PERM_WRITEABLE|PERM_UHPAGE);
  8016ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8016f2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8016f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016f8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8016fd:	83 ec 08             	sub    $0x8,%esp
  801700:	68 06 04 00 00       	push   $0x406
  801705:	50                   	push   %eax
  801706:	e8 3d 19 00 00       	call   803048 <__sys_allocate_page>
  80170b:	83 c4 10             	add    $0x10,%esp
  80170e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  801711:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801715:	79 14                	jns    80172b <get_page+0x42>
		panic("get_page() in user: failed to allocate page from the kernel");
  801717:	83 ec 04             	sub    $0x4,%esp
  80171a:	68 50 4c 80 00       	push   $0x804c50
  80171f:	6a 2d                	push   $0x2d
  801721:	68 8c 4c 80 00       	push   $0x804c8c
  801726:	e8 60 ed ff ff       	call   80048b <_panic>
	return 0;
  80172b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801730:	c9                   	leave  
  801731:	c3                   	ret    

00801732 <return_page>:

//==============================================
// [3] RETURN A PAGE FROM THE DA TO KERNEL:
//==============================================
void return_page(void* va)
{
  801732:	55                   	push   %ebp
  801733:	89 e5                	mov    %esp,%ebp
  801735:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_unmap_frame(ROUNDDOWN((uint32)va, PAGE_SIZE));
  801738:	8b 45 08             	mov    0x8(%ebp),%eax
  80173b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80173e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801741:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801746:	83 ec 0c             	sub    $0xc,%esp
  801749:	50                   	push   %eax
  80174a:	e8 40 19 00 00       	call   80308f <__sys_unmap_frame>
  80174f:	83 c4 10             	add    $0x10,%esp
  801752:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  801755:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801759:	79 14                	jns    80176f <return_page+0x3d>
		panic("return_page() in user: failed to return a page to the kernel");
  80175b:	83 ec 04             	sub    $0x4,%esp
  80175e:	68 98 4c 80 00       	push   $0x804c98
  801763:	6a 38                	push   $0x38
  801765:	68 8c 4c 80 00       	push   $0x804c8c
  80176a:	e8 1c ed ff ff       	call   80048b <_panic>
}
  80176f:	90                   	nop
  801770:	c9                   	leave  
  801771:	c3                   	ret    

00801772 <malloc>:

//=================================
// [1] ALLOCATE SPACE IN USER HEAP:
//=================================
void* malloc(uint32 size)
{
  801772:	55                   	push   %ebp
  801773:	89 e5                	mov    %esp,%ebp
  801775:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  801778:	e8 c1 fe ff ff       	call   80163e <uheap_init>
	if (size == 0) return NULL ;
  80177d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801781:	75 0a                	jne    80178d <malloc+0x1b>
  801783:	b8 00 00 00 00       	mov    $0x0,%eax
  801788:	e9 e1 04 00 00       	jmp    801c6e <malloc+0x4fc>
	//==============================================================

	acquire_uspinlock(&ulock);
  80178d:	83 ec 0c             	sub    $0xc,%esp
  801790:	68 40 d1 81 00       	push   $0x81d140
  801795:	e8 6c 28 00 00       	call   804006 <acquire_uspinlock>
  80179a:	83 c4 10             	add    $0x10,%esp
	if(size <  DYN_ALLOC_MAX_BLOCK_SIZE){
  80179d:	81 7d 08 ff 07 00 00 	cmpl   $0x7ff,0x8(%ebp)
  8017a4:	77 23                	ja     8017c9 <malloc+0x57>
		release_uspinlock(&ulock);
  8017a6:	83 ec 0c             	sub    $0xc,%esp
  8017a9:	68 40 d1 81 00       	push   $0x81d140
  8017ae:	e8 ab 28 00 00       	call   80405e <release_uspinlock>
  8017b3:	83 c4 10             	add    $0x10,%esp
		return alloc_block(size);
  8017b6:	83 ec 0c             	sub    $0xc,%esp
  8017b9:	ff 75 08             	pushl  0x8(%ebp)
  8017bc:	e8 dd 1f 00 00       	call   80379e <alloc_block>
  8017c1:	83 c4 10             	add    $0x10,%esp
  8017c4:	e9 a5 04 00 00       	jmp    801c6e <malloc+0x4fc>
	}

	struct UserHeapStruct* allocblock= (struct UserHeapStruct*) alloc_block(sizeof(struct UserHeapStruct));
  8017c9:	83 ec 0c             	sub    $0xc,%esp
  8017cc:	6a 10                	push   $0x10
  8017ce:	e8 cb 1f 00 00       	call   80379e <alloc_block>
  8017d3:	83 c4 10             	add    $0x10,%esp
  8017d6:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (allocblock == NULL){
  8017d9:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8017dd:	75 0a                	jne    8017e9 <malloc+0x77>
			return NULL;
  8017df:	b8 00 00 00 00       	mov    $0x0,%eax
  8017e4:	e9 85 04 00 00       	jmp    801c6e <malloc+0x4fc>
	}

	size = ROUNDUP(size,PAGE_SIZE);
  8017e9:	c7 45 e8 00 10 00 00 	movl   $0x1000,-0x18(%ebp)
  8017f0:	8b 55 08             	mov    0x8(%ebp),%edx
  8017f3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8017f6:	01 d0                	add    %edx,%eax
  8017f8:	48                   	dec    %eax
  8017f9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8017fc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8017ff:	ba 00 00 00 00       	mov    $0x0,%edx
  801804:	f7 75 e8             	divl   -0x18(%ebp)
  801807:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80180a:	29 d0                	sub    %edx,%eax
  80180c:	89 45 08             	mov    %eax,0x8(%ebp)
	struct UserHeapStruct* lastfreeelement = LIST_LAST(&u_freelist);
  80180f:	a1 24 d1 81 00       	mov    0x81d124,%eax
  801814:	89 45 e0             	mov    %eax,-0x20(%ebp)

	if(LIST_SIZE(&u_freelist)==0 || size>lastfreeelement->size){
  801817:	a1 2c d1 81 00       	mov    0x81d12c,%eax
  80181c:	85 c0                	test   %eax,%eax
  80181e:	74 0f                	je     80182f <malloc+0xbd>
  801820:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801823:	8b 40 04             	mov    0x4(%eax),%eax
  801826:	3b 45 08             	cmp    0x8(%ebp),%eax
  801829:	0f 83 ea 00 00 00    	jae    801919 <malloc+0x1a7>
			if(uheapPageAllocBreak < USER_HEAP_MAX - size){
  80182f:	b8 00 00 00 a0       	mov    $0xa0000000,%eax
  801834:	2b 45 08             	sub    0x8(%ebp),%eax
  801837:	89 c2                	mov    %eax,%edx
  801839:	a1 68 d0 81 00       	mov    0x81d068,%eax
  80183e:	39 c2                	cmp    %eax,%edx
  801840:	0f 86 b9 00 00 00    	jbe    8018ff <malloc+0x18d>
					uint32 requestedblockva = uheapPageAllocBreak;
  801846:	a1 68 d0 81 00       	mov    0x81d068,%eax
  80184b:	89 45 dc             	mov    %eax,-0x24(%ebp)
					uheapPageAllocBreak+=size;
  80184e:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  801854:	8b 45 08             	mov    0x8(%ebp),%eax
  801857:	01 d0                	add    %edx,%eax
  801859:	a3 68 d0 81 00       	mov    %eax,0x81d068
					allocblock->startva = requestedblockva;
  80185e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801861:	8b 55 dc             	mov    -0x24(%ebp),%edx
  801864:	89 10                	mov    %edx,(%eax)
					allocblock->size = size;
  801866:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801869:	8b 55 08             	mov    0x8(%ebp),%edx
  80186c:	89 50 04             	mov    %edx,0x4(%eax)

					LIST_INSERT_TAIL(&u_allocatedlist, allocblock);
  80186f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801873:	75 14                	jne    801889 <malloc+0x117>
  801875:	83 ec 04             	sub    $0x4,%esp
  801878:	68 d8 4c 80 00       	push   $0x804cd8
  80187d:	6a 60                	push   $0x60
  80187f:	68 8c 4c 80 00       	push   $0x804c8c
  801884:	e8 02 ec ff ff       	call   80048b <_panic>
  801889:	8b 15 34 d1 81 00    	mov    0x81d134,%edx
  80188f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801892:	89 50 0c             	mov    %edx,0xc(%eax)
  801895:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801898:	8b 40 0c             	mov    0xc(%eax),%eax
  80189b:	85 c0                	test   %eax,%eax
  80189d:	74 0d                	je     8018ac <malloc+0x13a>
  80189f:	a1 34 d1 81 00       	mov    0x81d134,%eax
  8018a4:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8018a7:	89 50 08             	mov    %edx,0x8(%eax)
  8018aa:	eb 08                	jmp    8018b4 <malloc+0x142>
  8018ac:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8018af:	a3 30 d1 81 00       	mov    %eax,0x81d130
  8018b4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8018b7:	a3 34 d1 81 00       	mov    %eax,0x81d134
  8018bc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8018bf:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  8018c6:	a1 3c d1 81 00       	mov    0x81d13c,%eax
  8018cb:	40                   	inc    %eax
  8018cc:	a3 3c d1 81 00       	mov    %eax,0x81d13c


					sys_allocate_user_mem(allocblock->startva ,size);
  8018d1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8018d4:	8b 00                	mov    (%eax),%eax
  8018d6:	83 ec 08             	sub    $0x8,%esp
  8018d9:	ff 75 08             	pushl  0x8(%ebp)
  8018dc:	50                   	push   %eax
  8018dd:	e8 34 1c 00 00       	call   803516 <sys_allocate_user_mem>
  8018e2:	83 c4 10             	add    $0x10,%esp
					release_uspinlock(&ulock);
  8018e5:	83 ec 0c             	sub    $0xc,%esp
  8018e8:	68 40 d1 81 00       	push   $0x81d140
  8018ed:	e8 6c 27 00 00       	call   80405e <release_uspinlock>
  8018f2:	83 c4 10             	add    $0x10,%esp
					return (void*)allocblock->startva;
  8018f5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8018f8:	8b 00                	mov    (%eax),%eax
  8018fa:	e9 6f 03 00 00       	jmp    801c6e <malloc+0x4fc>
			}else{
					release_uspinlock(&ulock);
  8018ff:	83 ec 0c             	sub    $0xc,%esp
  801902:	68 40 d1 81 00       	push   $0x81d140
  801907:	e8 52 27 00 00       	call   80405e <release_uspinlock>
  80190c:	83 c4 10             	add    $0x10,%esp
					return NULL;
  80190f:	b8 00 00 00 00       	mov    $0x0,%eax
  801914:	e9 55 03 00 00       	jmp    801c6e <malloc+0x4fc>
				}
	}else{
		//custom fit
		struct UserHeapStruct* currentfreeelement = LIST_FIRST(&u_freelist);
  801919:	a1 20 d1 81 00       	mov    0x81d120,%eax
  80191e:	89 45 f4             	mov    %eax,-0xc(%ebp)
		//worst fit
		while(currentfreeelement != NULL){
  801921:	e9 39 03 00 00       	jmp    801c5f <malloc+0x4ed>
			if(size<currentfreeelement->size){
  801926:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801929:	8b 40 04             	mov    0x4(%eax),%eax
  80192c:	3b 45 08             	cmp    0x8(%ebp),%eax
  80192f:	0f 86 e7 01 00 00    	jbe    801b1c <malloc+0x3aa>
				allocblock->startva = lastfreeelement->startva;
  801935:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801938:	8b 10                	mov    (%eax),%edx
  80193a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80193d:	89 10                	mov    %edx,(%eax)
                allocblock->size = size;
  80193f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801942:	8b 55 08             	mov    0x8(%ebp),%edx
  801945:	89 50 04             	mov    %edx,0x4(%eax)
                LIST_INSERT_TAIL(&u_allocatedlist,allocblock);
  801948:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80194c:	75 14                	jne    801962 <malloc+0x1f0>
  80194e:	83 ec 04             	sub    $0x4,%esp
  801951:	68 d8 4c 80 00       	push   $0x804cd8
  801956:	6a 72                	push   $0x72
  801958:	68 8c 4c 80 00       	push   $0x804c8c
  80195d:	e8 29 eb ff ff       	call   80048b <_panic>
  801962:	8b 15 34 d1 81 00    	mov    0x81d134,%edx
  801968:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80196b:	89 50 0c             	mov    %edx,0xc(%eax)
  80196e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801971:	8b 40 0c             	mov    0xc(%eax),%eax
  801974:	85 c0                	test   %eax,%eax
  801976:	74 0d                	je     801985 <malloc+0x213>
  801978:	a1 34 d1 81 00       	mov    0x81d134,%eax
  80197d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801980:	89 50 08             	mov    %edx,0x8(%eax)
  801983:	eb 08                	jmp    80198d <malloc+0x21b>
  801985:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801988:	a3 30 d1 81 00       	mov    %eax,0x81d130
  80198d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801990:	a3 34 d1 81 00       	mov    %eax,0x81d134
  801995:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801998:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  80199f:	a1 3c d1 81 00       	mov    0x81d13c,%eax
  8019a4:	40                   	inc    %eax
  8019a5:	a3 3c d1 81 00       	mov    %eax,0x81d13c
                lastfreeelement->startva += size;
  8019aa:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8019ad:	8b 10                	mov    (%eax),%edx
  8019af:	8b 45 08             	mov    0x8(%ebp),%eax
  8019b2:	01 c2                	add    %eax,%edx
  8019b4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8019b7:	89 10                	mov    %edx,(%eax)
                lastfreeelement->size -= size;
  8019b9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8019bc:	8b 40 04             	mov    0x4(%eax),%eax
  8019bf:	2b 45 08             	sub    0x8(%ebp),%eax
  8019c2:	89 c2                	mov    %eax,%edx
  8019c4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8019c7:	89 50 04             	mov    %edx,0x4(%eax)
                struct UserHeapStruct* currentfree2 = LIST_FIRST(&u_freelist);
  8019ca:	a1 20 d1 81 00       	mov    0x81d120,%eax
  8019cf:	89 45 f0             	mov    %eax,-0x10(%ebp)
                //check order of last element

                while (currentfree2 != NULL){
  8019d2:	e9 0d 01 00 00       	jmp    801ae4 <malloc+0x372>
                	if(lastfreeelement->size <currentfree2->size){
  8019d7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8019da:	8b 50 04             	mov    0x4(%eax),%edx
  8019dd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019e0:	8b 40 04             	mov    0x4(%eax),%eax
  8019e3:	39 c2                	cmp    %eax,%edx
  8019e5:	0f 83 f0 00 00 00    	jae    801adb <malloc+0x369>
                		LIST_REMOVE(&u_freelist ,lastfreeelement);
  8019eb:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8019ef:	75 14                	jne    801a05 <malloc+0x293>
  8019f1:	83 ec 04             	sub    $0x4,%esp
  8019f4:	68 fb 4c 80 00       	push   $0x804cfb
  8019f9:	6a 7a                	push   $0x7a
  8019fb:	68 8c 4c 80 00       	push   $0x804c8c
  801a00:	e8 86 ea ff ff       	call   80048b <_panic>
  801a05:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801a08:	8b 40 08             	mov    0x8(%eax),%eax
  801a0b:	85 c0                	test   %eax,%eax
  801a0d:	74 11                	je     801a20 <malloc+0x2ae>
  801a0f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801a12:	8b 40 08             	mov    0x8(%eax),%eax
  801a15:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801a18:	8b 52 0c             	mov    0xc(%edx),%edx
  801a1b:	89 50 0c             	mov    %edx,0xc(%eax)
  801a1e:	eb 0b                	jmp    801a2b <malloc+0x2b9>
  801a20:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801a23:	8b 40 0c             	mov    0xc(%eax),%eax
  801a26:	a3 24 d1 81 00       	mov    %eax,0x81d124
  801a2b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801a2e:	8b 40 0c             	mov    0xc(%eax),%eax
  801a31:	85 c0                	test   %eax,%eax
  801a33:	74 11                	je     801a46 <malloc+0x2d4>
  801a35:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801a38:	8b 40 0c             	mov    0xc(%eax),%eax
  801a3b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801a3e:	8b 52 08             	mov    0x8(%edx),%edx
  801a41:	89 50 08             	mov    %edx,0x8(%eax)
  801a44:	eb 0b                	jmp    801a51 <malloc+0x2df>
  801a46:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801a49:	8b 40 08             	mov    0x8(%eax),%eax
  801a4c:	a3 20 d1 81 00       	mov    %eax,0x81d120
  801a51:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801a54:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  801a5b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801a5e:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  801a65:	a1 2c d1 81 00       	mov    0x81d12c,%eax
  801a6a:	48                   	dec    %eax
  801a6b:	a3 2c d1 81 00       	mov    %eax,0x81d12c
                		LIST_INSERT_BEFORE(&u_freelist ,currentfree2 ,lastfreeelement);
  801a70:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801a74:	74 06                	je     801a7c <malloc+0x30a>
  801a76:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801a7a:	75 14                	jne    801a90 <malloc+0x31e>
  801a7c:	83 ec 04             	sub    $0x4,%esp
  801a7f:	68 1c 4d 80 00       	push   $0x804d1c
  801a84:	6a 7b                	push   $0x7b
  801a86:	68 8c 4c 80 00       	push   $0x804c8c
  801a8b:	e8 fb e9 ff ff       	call   80048b <_panic>
  801a90:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a93:	8b 50 0c             	mov    0xc(%eax),%edx
  801a96:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801a99:	89 50 0c             	mov    %edx,0xc(%eax)
  801a9c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801a9f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801aa2:	89 50 08             	mov    %edx,0x8(%eax)
  801aa5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801aa8:	8b 40 0c             	mov    0xc(%eax),%eax
  801aab:	85 c0                	test   %eax,%eax
  801aad:	74 0e                	je     801abd <malloc+0x34b>
  801aaf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ab2:	8b 40 0c             	mov    0xc(%eax),%eax
  801ab5:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801ab8:	89 50 08             	mov    %edx,0x8(%eax)
  801abb:	eb 08                	jmp    801ac5 <malloc+0x353>
  801abd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801ac0:	a3 20 d1 81 00       	mov    %eax,0x81d120
  801ac5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ac8:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801acb:	89 50 0c             	mov    %edx,0xc(%eax)
  801ace:	a1 2c d1 81 00       	mov    0x81d12c,%eax
  801ad3:	40                   	inc    %eax
  801ad4:	a3 2c d1 81 00       	mov    %eax,0x81d12c
                		break;
  801ad9:	eb 13                	jmp    801aee <malloc+0x37c>
                	}
                	currentfree2 = currentfree2->prev_next_info.le_next;
  801adb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ade:	8b 40 08             	mov    0x8(%eax),%eax
  801ae1:	89 45 f0             	mov    %eax,-0x10(%ebp)
                lastfreeelement->startva += size;
                lastfreeelement->size -= size;
                struct UserHeapStruct* currentfree2 = LIST_FIRST(&u_freelist);
                //check order of last element

                while (currentfree2 != NULL){
  801ae4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801ae8:	0f 85 e9 fe ff ff    	jne    8019d7 <malloc+0x265>
                	}
                	currentfree2 = currentfree2->prev_next_info.le_next;
                }


                sys_allocate_user_mem(allocblock->startva ,size);
  801aee:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801af1:	8b 00                	mov    (%eax),%eax
  801af3:	83 ec 08             	sub    $0x8,%esp
  801af6:	ff 75 08             	pushl  0x8(%ebp)
  801af9:	50                   	push   %eax
  801afa:	e8 17 1a 00 00       	call   803516 <sys_allocate_user_mem>
  801aff:	83 c4 10             	add    $0x10,%esp
                release_uspinlock(&ulock);
  801b02:	83 ec 0c             	sub    $0xc,%esp
  801b05:	68 40 d1 81 00       	push   $0x81d140
  801b0a:	e8 4f 25 00 00       	call   80405e <release_uspinlock>
  801b0f:	83 c4 10             	add    $0x10,%esp
                return (void*)allocblock->startva;
  801b12:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801b15:	8b 00                	mov    (%eax),%eax
  801b17:	e9 52 01 00 00       	jmp    801c6e <malloc+0x4fc>
                //exact fit
			}else if(size == currentfreeelement->size){
  801b1c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b1f:	8b 40 04             	mov    0x4(%eax),%eax
  801b22:	3b 45 08             	cmp    0x8(%ebp),%eax
  801b25:	0f 85 2b 01 00 00    	jne    801c56 <malloc+0x4e4>
				allocblock->startva = currentfreeelement->startva;
  801b2b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b2e:	8b 10                	mov    (%eax),%edx
  801b30:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801b33:	89 10                	mov    %edx,(%eax)
				allocblock->size = size;
  801b35:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801b38:	8b 55 08             	mov    0x8(%ebp),%edx
  801b3b:	89 50 04             	mov    %edx,0x4(%eax)
				LIST_INSERT_TAIL(&u_allocatedlist ,allocblock);
  801b3e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801b42:	75 17                	jne    801b5b <malloc+0x3e9>
  801b44:	83 ec 04             	sub    $0x4,%esp
  801b47:	68 d8 4c 80 00       	push   $0x804cd8
  801b4c:	68 89 00 00 00       	push   $0x89
  801b51:	68 8c 4c 80 00       	push   $0x804c8c
  801b56:	e8 30 e9 ff ff       	call   80048b <_panic>
  801b5b:	8b 15 34 d1 81 00    	mov    0x81d134,%edx
  801b61:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801b64:	89 50 0c             	mov    %edx,0xc(%eax)
  801b67:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801b6a:	8b 40 0c             	mov    0xc(%eax),%eax
  801b6d:	85 c0                	test   %eax,%eax
  801b6f:	74 0d                	je     801b7e <malloc+0x40c>
  801b71:	a1 34 d1 81 00       	mov    0x81d134,%eax
  801b76:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801b79:	89 50 08             	mov    %edx,0x8(%eax)
  801b7c:	eb 08                	jmp    801b86 <malloc+0x414>
  801b7e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801b81:	a3 30 d1 81 00       	mov    %eax,0x81d130
  801b86:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801b89:	a3 34 d1 81 00       	mov    %eax,0x81d134
  801b8e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801b91:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  801b98:	a1 3c d1 81 00       	mov    0x81d13c,%eax
  801b9d:	40                   	inc    %eax
  801b9e:	a3 3c d1 81 00       	mov    %eax,0x81d13c
				LIST_REMOVE(&u_freelist ,currentfreeelement);
  801ba3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801ba7:	75 17                	jne    801bc0 <malloc+0x44e>
  801ba9:	83 ec 04             	sub    $0x4,%esp
  801bac:	68 fb 4c 80 00       	push   $0x804cfb
  801bb1:	68 8a 00 00 00       	push   $0x8a
  801bb6:	68 8c 4c 80 00       	push   $0x804c8c
  801bbb:	e8 cb e8 ff ff       	call   80048b <_panic>
  801bc0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bc3:	8b 40 08             	mov    0x8(%eax),%eax
  801bc6:	85 c0                	test   %eax,%eax
  801bc8:	74 11                	je     801bdb <malloc+0x469>
  801bca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bcd:	8b 40 08             	mov    0x8(%eax),%eax
  801bd0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801bd3:	8b 52 0c             	mov    0xc(%edx),%edx
  801bd6:	89 50 0c             	mov    %edx,0xc(%eax)
  801bd9:	eb 0b                	jmp    801be6 <malloc+0x474>
  801bdb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bde:	8b 40 0c             	mov    0xc(%eax),%eax
  801be1:	a3 24 d1 81 00       	mov    %eax,0x81d124
  801be6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801be9:	8b 40 0c             	mov    0xc(%eax),%eax
  801bec:	85 c0                	test   %eax,%eax
  801bee:	74 11                	je     801c01 <malloc+0x48f>
  801bf0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bf3:	8b 40 0c             	mov    0xc(%eax),%eax
  801bf6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801bf9:	8b 52 08             	mov    0x8(%edx),%edx
  801bfc:	89 50 08             	mov    %edx,0x8(%eax)
  801bff:	eb 0b                	jmp    801c0c <malloc+0x49a>
  801c01:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c04:	8b 40 08             	mov    0x8(%eax),%eax
  801c07:	a3 20 d1 81 00       	mov    %eax,0x81d120
  801c0c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c0f:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  801c16:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c19:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  801c20:	a1 2c d1 81 00       	mov    0x81d12c,%eax
  801c25:	48                   	dec    %eax
  801c26:	a3 2c d1 81 00       	mov    %eax,0x81d12c
				sys_allocate_user_mem(allocblock->startva ,size);
  801c2b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801c2e:	8b 00                	mov    (%eax),%eax
  801c30:	83 ec 08             	sub    $0x8,%esp
  801c33:	ff 75 08             	pushl  0x8(%ebp)
  801c36:	50                   	push   %eax
  801c37:	e8 da 18 00 00       	call   803516 <sys_allocate_user_mem>
  801c3c:	83 c4 10             	add    $0x10,%esp
				release_uspinlock(&ulock);
  801c3f:	83 ec 0c             	sub    $0xc,%esp
  801c42:	68 40 d1 81 00       	push   $0x81d140
  801c47:	e8 12 24 00 00       	call   80405e <release_uspinlock>
  801c4c:	83 c4 10             	add    $0x10,%esp
				return (void*)allocblock->startva;
  801c4f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801c52:	8b 00                	mov    (%eax),%eax
  801c54:	eb 18                	jmp    801c6e <malloc+0x4fc>
			}
			currentfreeelement = currentfreeelement->prev_next_info.le_next;
  801c56:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c59:	8b 40 08             	mov    0x8(%eax),%eax
  801c5c:	89 45 f4             	mov    %eax,-0xc(%ebp)
				}
	}else{
		//custom fit
		struct UserHeapStruct* currentfreeelement = LIST_FIRST(&u_freelist);
		//worst fit
		while(currentfreeelement != NULL){
  801c5f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801c63:	0f 85 bd fc ff ff    	jne    801926 <malloc+0x1b4>
				return (void*)allocblock->startva;
			}
			currentfreeelement = currentfreeelement->prev_next_info.le_next;
		}
	}
	 return NULL;
  801c69:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c6e:	c9                   	leave  
  801c6f:	c3                   	ret    

00801c70 <free>:

//=================================
// [2] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
  801c70:	55                   	push   %ebp
  801c71:	89 e5                	mov    %esp,%ebp
  801c73:	83 ec 38             	sub    $0x38,%esp
	uint32  VA = ROUNDDOWN(((uint32 ) virtual_address), PAGE_SIZE);
  801c76:	8b 45 08             	mov    0x8(%ebp),%eax
  801c79:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801c7c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801c7f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801c84:	89 45 d8             	mov    %eax,-0x28(%ebp)


		uheap_init();
  801c87:	e8 b2 f9 ff ff       	call   80163e <uheap_init>
		acquire_uspinlock(&ulock);
  801c8c:	83 ec 0c             	sub    $0xc,%esp
  801c8f:	68 40 d1 81 00       	push   $0x81d140
  801c94:	e8 6d 23 00 00       	call   804006 <acquire_uspinlock>
  801c99:	83 c4 10             	add    $0x10,%esp
		if (VA < uheapPageAllocStart){
  801c9c:	a1 10 d1 81 00       	mov    0x81d110,%eax
  801ca1:	39 45 d8             	cmp    %eax,-0x28(%ebp)
  801ca4:	73 23                	jae    801cc9 <free+0x59>
			free_block(virtual_address);
  801ca6:	83 ec 0c             	sub    $0xc,%esp
  801ca9:	ff 75 08             	pushl  0x8(%ebp)
  801cac:	e8 89 1f 00 00       	call   803c3a <free_block>
  801cb1:	83 c4 10             	add    $0x10,%esp
			release_uspinlock(&ulock);
  801cb4:	83 ec 0c             	sub    $0xc,%esp
  801cb7:	68 40 d1 81 00       	push   $0x81d140
  801cbc:	e8 9d 23 00 00       	call   80405e <release_uspinlock>
  801cc1:	83 c4 10             	add    $0x10,%esp
			return;
  801cc4:	e9 35 07 00 00       	jmp    8023fe <free+0x78e>
		}
		if (VA >= uheapPageAllocBreak){
  801cc9:	a1 68 d0 81 00       	mov    0x81d068,%eax
  801cce:	39 45 d8             	cmp    %eax,-0x28(%ebp)
  801cd1:	72 30                	jb     801d03 <free+0x93>
			cprintf("%d\n %d\n", VA, uheapPageAllocBreak);
  801cd3:	a1 68 d0 81 00       	mov    0x81d068,%eax
  801cd8:	83 ec 04             	sub    $0x4,%esp
  801cdb:	50                   	push   %eax
  801cdc:	ff 75 d8             	pushl  -0x28(%ebp)
  801cdf:	68 51 4d 80 00       	push   $0x804d51
  801ce4:	e8 70 ea ff ff       	call   800759 <cprintf>
  801ce9:	83 c4 10             	add    $0x10,%esp

			panic("freeing from restricted area");
  801cec:	83 ec 04             	sub    $0x4,%esp
  801cef:	68 59 4d 80 00       	push   $0x804d59
  801cf4:	68 a7 00 00 00       	push   $0xa7
  801cf9:	68 8c 4c 80 00       	push   $0x804c8c
  801cfe:	e8 88 e7 ff ff       	call   80048b <_panic>
			release_uspinlock(&ulock);
			return;
		}

		struct UserHeapStruct* newfree = (struct UserHeapStruct*) alloc_block(sizeof(struct UserHeapStruct));
  801d03:	83 ec 0c             	sub    $0xc,%esp
  801d06:	6a 10                	push   $0x10
  801d08:	e8 91 1a 00 00       	call   80379e <alloc_block>
  801d0d:	83 c4 10             	add    $0x10,%esp
  801d10:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		struct UserHeapStruct* MergedBlock  = ( struct UserHeapStruct*)alloc_block(sizeof(struct UserHeapStruct));
  801d13:	83 ec 0c             	sub    $0xc,%esp
  801d16:	6a 10                	push   $0x10
  801d18:	e8 81 1a 00 00       	call   80379e <alloc_block>
  801d1d:	83 c4 10             	add    $0x10,%esp
  801d20:	89 45 d0             	mov    %eax,-0x30(%ebp)

		struct UserHeapStruct* ToBefreed = LIST_FIRST(&u_allocatedlist);
  801d23:	a1 30 d1 81 00       	mov    0x81d130,%eax
  801d28:	89 45 f4             	mov    %eax,-0xc(%ebp)
		bool foundVA = 0;
  801d2b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

		//find the allocated block
		while(ToBefreed !=NULL ){
  801d32:	eb 1c                	jmp    801d50 <free+0xe0>

			if (VA ==ToBefreed->startva ){
  801d34:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d37:	8b 00                	mov    (%eax),%eax
  801d39:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  801d3c:	75 09                	jne    801d47 <free+0xd7>
				foundVA = 1;
  801d3e:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
				break;
  801d45:	eb 0f                	jmp    801d56 <free+0xe6>
			}
				ToBefreed = ToBefreed->prev_next_info.le_next;
  801d47:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d4a:	8b 40 08             	mov    0x8(%eax),%eax
  801d4d:	89 45 f4             	mov    %eax,-0xc(%ebp)

		struct UserHeapStruct* ToBefreed = LIST_FIRST(&u_allocatedlist);
		bool foundVA = 0;

		//find the allocated block
		while(ToBefreed !=NULL ){
  801d50:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801d54:	75 de                	jne    801d34 <free+0xc4>
			}
				ToBefreed = ToBefreed->prev_next_info.le_next;
		}


		if(!foundVA){
  801d56:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801d5a:	75 17                	jne    801d73 <free+0x103>
				panic("INVALID ADDRESS!");
  801d5c:	83 ec 04             	sub    $0x4,%esp
  801d5f:	68 76 4d 80 00       	push   $0x804d76
  801d64:	68 be 00 00 00       	push   $0xbe
  801d69:	68 8c 4c 80 00       	push   $0x804c8c
  801d6e:	e8 18 e7 ff ff       	call   80048b <_panic>
				release_uspinlock(&ulock);
				return;
			}


		newfree->startva = ToBefreed->startva;
  801d73:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d76:	8b 10                	mov    (%eax),%edx
  801d78:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801d7b:	89 10                	mov    %edx,(%eax)
		newfree->size = ToBefreed->size;
  801d7d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d80:	8b 50 04             	mov    0x4(%eax),%edx
  801d83:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801d86:	89 50 04             	mov    %edx,0x4(%eax)

		//remove allocated block from alloclist
		LIST_REMOVE(&u_allocatedlist, ToBefreed);
  801d89:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801d8d:	75 17                	jne    801da6 <free+0x136>
  801d8f:	83 ec 04             	sub    $0x4,%esp
  801d92:	68 fb 4c 80 00       	push   $0x804cfb
  801d97:	68 c8 00 00 00       	push   $0xc8
  801d9c:	68 8c 4c 80 00       	push   $0x804c8c
  801da1:	e8 e5 e6 ff ff       	call   80048b <_panic>
  801da6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801da9:	8b 40 08             	mov    0x8(%eax),%eax
  801dac:	85 c0                	test   %eax,%eax
  801dae:	74 11                	je     801dc1 <free+0x151>
  801db0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801db3:	8b 40 08             	mov    0x8(%eax),%eax
  801db6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801db9:	8b 52 0c             	mov    0xc(%edx),%edx
  801dbc:	89 50 0c             	mov    %edx,0xc(%eax)
  801dbf:	eb 0b                	jmp    801dcc <free+0x15c>
  801dc1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dc4:	8b 40 0c             	mov    0xc(%eax),%eax
  801dc7:	a3 34 d1 81 00       	mov    %eax,0x81d134
  801dcc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dcf:	8b 40 0c             	mov    0xc(%eax),%eax
  801dd2:	85 c0                	test   %eax,%eax
  801dd4:	74 11                	je     801de7 <free+0x177>
  801dd6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dd9:	8b 40 0c             	mov    0xc(%eax),%eax
  801ddc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ddf:	8b 52 08             	mov    0x8(%edx),%edx
  801de2:	89 50 08             	mov    %edx,0x8(%eax)
  801de5:	eb 0b                	jmp    801df2 <free+0x182>
  801de7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dea:	8b 40 08             	mov    0x8(%eax),%eax
  801ded:	a3 30 d1 81 00       	mov    %eax,0x81d130
  801df2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801df5:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  801dfc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dff:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  801e06:	a1 3c d1 81 00       	mov    0x81d13c,%eax
  801e0b:	48                   	dec    %eax
  801e0c:	a3 3c d1 81 00       	mov    %eax,0x81d13c

		sys_free_user_mem(ToBefreed->startva, ToBefreed->size);
  801e11:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e14:	8b 50 04             	mov    0x4(%eax),%edx
  801e17:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e1a:	8b 00                	mov    (%eax),%eax
  801e1c:	83 ec 08             	sub    $0x8,%esp
  801e1f:	52                   	push   %edx
  801e20:	50                   	push   %eax
  801e21:	e8 d4 16 00 00       	call   8034fa <sys_free_user_mem>
  801e26:	83 c4 10             	add    $0x10,%esp




		if(LIST_SIZE(&u_freelist) == 0){
  801e29:	a1 2c d1 81 00       	mov    0x81d12c,%eax
  801e2e:	85 c0                	test   %eax,%eax
  801e30:	75 7a                	jne    801eac <free+0x23c>
			LIST_INSERT_HEAD(&u_freelist,newfree);
  801e32:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  801e36:	75 17                	jne    801e4f <free+0x1df>
  801e38:	83 ec 04             	sub    $0x4,%esp
  801e3b:	68 88 4d 80 00       	push   $0x804d88
  801e40:	68 d0 00 00 00       	push   $0xd0
  801e45:	68 8c 4c 80 00       	push   $0x804c8c
  801e4a:	e8 3c e6 ff ff       	call   80048b <_panic>
  801e4f:	8b 15 20 d1 81 00    	mov    0x81d120,%edx
  801e55:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801e58:	89 50 08             	mov    %edx,0x8(%eax)
  801e5b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801e5e:	8b 40 08             	mov    0x8(%eax),%eax
  801e61:	85 c0                	test   %eax,%eax
  801e63:	74 0d                	je     801e72 <free+0x202>
  801e65:	a1 20 d1 81 00       	mov    0x81d120,%eax
  801e6a:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  801e6d:	89 50 0c             	mov    %edx,0xc(%eax)
  801e70:	eb 08                	jmp    801e7a <free+0x20a>
  801e72:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801e75:	a3 24 d1 81 00       	mov    %eax,0x81d124
  801e7a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801e7d:	a3 20 d1 81 00       	mov    %eax,0x81d120
  801e82:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801e85:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  801e8c:	a1 2c d1 81 00       	mov    0x81d12c,%eax
  801e91:	40                   	inc    %eax
  801e92:	a3 2c d1 81 00       	mov    %eax,0x81d12c
			release_uspinlock(&ulock);
  801e97:	83 ec 0c             	sub    $0xc,%esp
  801e9a:	68 40 d1 81 00       	push   $0x81d140
  801e9f:	e8 ba 21 00 00       	call   80405e <release_uspinlock>
  801ea4:	83 c4 10             	add    $0x10,%esp
			return;
  801ea7:	e9 52 05 00 00       	jmp    8023fe <free+0x78e>
		}


		struct UserHeapStruct* ToBeMerged = LIST_FIRST(&u_freelist);
  801eac:	a1 20 d1 81 00       	mov    0x81d120,%eax
  801eb1:	89 45 ec             	mov    %eax,-0x14(%ebp)
		// merge with prev if possible
		bool mergeprev = 0;
  801eb4:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		bool mergenext = 0;
  801ebb:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
		while(ToBeMerged != NULL){
  801ec2:	e9 d2 00 00 00       	jmp    801f99 <free+0x329>
			if((ToBeMerged->startva +ToBeMerged->size) == newfree->startva){
  801ec7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801eca:	8b 10                	mov    (%eax),%edx
  801ecc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801ecf:	8b 40 04             	mov    0x4(%eax),%eax
  801ed2:	01 c2                	add    %eax,%edx
  801ed4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801ed7:	8b 00                	mov    (%eax),%eax
  801ed9:	39 c2                	cmp    %eax,%edx
  801edb:	0f 85 af 00 00 00    	jne    801f90 <free+0x320>

				MergedBlock->startva = ToBeMerged->startva;
  801ee1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801ee4:	8b 10                	mov    (%eax),%edx
  801ee6:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801ee9:	89 10                	mov    %edx,(%eax)
				MergedBlock->size = ToBeMerged->size + newfree->size;
  801eeb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801eee:	8b 50 04             	mov    0x4(%eax),%edx
  801ef1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801ef4:	8b 40 04             	mov    0x4(%eax),%eax
  801ef7:	01 c2                	add    %eax,%edx
  801ef9:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801efc:	89 50 04             	mov    %edx,0x4(%eax)
				LIST_REMOVE(&u_freelist, ToBeMerged);
  801eff:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801f03:	75 17                	jne    801f1c <free+0x2ac>
  801f05:	83 ec 04             	sub    $0x4,%esp
  801f08:	68 fb 4c 80 00       	push   $0x804cfb
  801f0d:	68 df 00 00 00       	push   $0xdf
  801f12:	68 8c 4c 80 00       	push   $0x804c8c
  801f17:	e8 6f e5 ff ff       	call   80048b <_panic>
  801f1c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f1f:	8b 40 08             	mov    0x8(%eax),%eax
  801f22:	85 c0                	test   %eax,%eax
  801f24:	74 11                	je     801f37 <free+0x2c7>
  801f26:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f29:	8b 40 08             	mov    0x8(%eax),%eax
  801f2c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801f2f:	8b 52 0c             	mov    0xc(%edx),%edx
  801f32:	89 50 0c             	mov    %edx,0xc(%eax)
  801f35:	eb 0b                	jmp    801f42 <free+0x2d2>
  801f37:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f3a:	8b 40 0c             	mov    0xc(%eax),%eax
  801f3d:	a3 24 d1 81 00       	mov    %eax,0x81d124
  801f42:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f45:	8b 40 0c             	mov    0xc(%eax),%eax
  801f48:	85 c0                	test   %eax,%eax
  801f4a:	74 11                	je     801f5d <free+0x2ed>
  801f4c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f4f:	8b 40 0c             	mov    0xc(%eax),%eax
  801f52:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801f55:	8b 52 08             	mov    0x8(%edx),%edx
  801f58:	89 50 08             	mov    %edx,0x8(%eax)
  801f5b:	eb 0b                	jmp    801f68 <free+0x2f8>
  801f5d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f60:	8b 40 08             	mov    0x8(%eax),%eax
  801f63:	a3 20 d1 81 00       	mov    %eax,0x81d120
  801f68:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f6b:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  801f72:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f75:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  801f7c:	a1 2c d1 81 00       	mov    0x81d12c,%eax
  801f81:	48                   	dec    %eax
  801f82:	a3 2c d1 81 00       	mov    %eax,0x81d12c
				mergeprev = 1;
  801f87:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
				break;
  801f8e:	eb 13                	jmp    801fa3 <free+0x333>
			}
				ToBeMerged = ToBeMerged->prev_next_info.le_next;
  801f90:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f93:	8b 40 08             	mov    0x8(%eax),%eax
  801f96:	89 45 ec             	mov    %eax,-0x14(%ebp)

		struct UserHeapStruct* ToBeMerged = LIST_FIRST(&u_freelist);
		// merge with prev if possible
		bool mergeprev = 0;
		bool mergenext = 0;
		while(ToBeMerged != NULL){
  801f99:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801f9d:	0f 85 24 ff ff ff    	jne    801ec7 <free+0x257>
//									uheapPageAllocBreak = newfree->startva;
//						}
//					}


		if ( newfree ->startva + newfree->size == uheapPageAllocBreak){
  801fa3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801fa6:	8b 10                	mov    (%eax),%edx
  801fa8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801fab:	8b 40 04             	mov    0x4(%eax),%eax
  801fae:	01 c2                	add    %eax,%edx
  801fb0:	a1 68 d0 81 00       	mov    0x81d068,%eax
  801fb5:	39 c2                	cmp    %eax,%edx
  801fb7:	75 44                	jne    801ffd <free+0x38d>

			if(mergeprev){
  801fb9:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  801fbd:	74 1f                	je     801fde <free+0x36e>
				uheapPageAllocBreak = MergedBlock->startva;
  801fbf:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801fc2:	8b 00                	mov    (%eax),%eax
  801fc4:	a3 68 d0 81 00       	mov    %eax,0x81d068
				release_uspinlock(&ulock);
  801fc9:	83 ec 0c             	sub    $0xc,%esp
  801fcc:	68 40 d1 81 00       	push   $0x81d140
  801fd1:	e8 88 20 00 00       	call   80405e <release_uspinlock>
  801fd6:	83 c4 10             	add    $0x10,%esp
				return;
  801fd9:	e9 20 04 00 00       	jmp    8023fe <free+0x78e>

			}else{
				uheapPageAllocBreak = newfree->startva;
  801fde:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801fe1:	8b 00                	mov    (%eax),%eax
  801fe3:	a3 68 d0 81 00       	mov    %eax,0x81d068
				release_uspinlock(&ulock);
  801fe8:	83 ec 0c             	sub    $0xc,%esp
  801feb:	68 40 d1 81 00       	push   $0x81d140
  801ff0:	e8 69 20 00 00       	call   80405e <release_uspinlock>
  801ff5:	83 c4 10             	add    $0x10,%esp
				return;
  801ff8:	e9 01 04 00 00       	jmp    8023fe <free+0x78e>

		}


		//check if block is merged with prev ,and find possible merge with next
		ToBeMerged = LIST_FIRST(&u_freelist);
  801ffd:	a1 20 d1 81 00       	mov    0x81d120,%eax
  802002:	89 45 ec             	mov    %eax,-0x14(%ebp)
		while(ToBeMerged != NULL){
  802005:	e9 7d 01 00 00       	jmp    802187 <free+0x517>
			if ((newfree->startva + newfree->size) == ToBeMerged->startva ){
  80200a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80200d:	8b 10                	mov    (%eax),%edx
  80200f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802012:	8b 40 04             	mov    0x4(%eax),%eax
  802015:	01 c2                	add    %eax,%edx
  802017:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80201a:	8b 00                	mov    (%eax),%eax
  80201c:	39 c2                	cmp    %eax,%edx
  80201e:	0f 85 5a 01 00 00    	jne    80217e <free+0x50e>
				if (mergeprev){
  802024:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802028:	0f 84 a1 00 00 00    	je     8020cf <free+0x45f>
					MergedBlock->size += ToBeMerged->size;
  80202e:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802031:	8b 50 04             	mov    0x4(%eax),%edx
  802034:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802037:	8b 40 04             	mov    0x4(%eax),%eax
  80203a:	01 c2                	add    %eax,%edx
  80203c:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80203f:	89 50 04             	mov    %edx,0x4(%eax)
					LIST_REMOVE(&u_freelist, ToBeMerged);
  802042:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802046:	75 17                	jne    80205f <free+0x3ef>
  802048:	83 ec 04             	sub    $0x4,%esp
  80204b:	68 fb 4c 80 00       	push   $0x804cfb
  802050:	68 0a 01 00 00       	push   $0x10a
  802055:	68 8c 4c 80 00       	push   $0x804c8c
  80205a:	e8 2c e4 ff ff       	call   80048b <_panic>
  80205f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802062:	8b 40 08             	mov    0x8(%eax),%eax
  802065:	85 c0                	test   %eax,%eax
  802067:	74 11                	je     80207a <free+0x40a>
  802069:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80206c:	8b 40 08             	mov    0x8(%eax),%eax
  80206f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802072:	8b 52 0c             	mov    0xc(%edx),%edx
  802075:	89 50 0c             	mov    %edx,0xc(%eax)
  802078:	eb 0b                	jmp    802085 <free+0x415>
  80207a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80207d:	8b 40 0c             	mov    0xc(%eax),%eax
  802080:	a3 24 d1 81 00       	mov    %eax,0x81d124
  802085:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802088:	8b 40 0c             	mov    0xc(%eax),%eax
  80208b:	85 c0                	test   %eax,%eax
  80208d:	74 11                	je     8020a0 <free+0x430>
  80208f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802092:	8b 40 0c             	mov    0xc(%eax),%eax
  802095:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802098:	8b 52 08             	mov    0x8(%edx),%edx
  80209b:	89 50 08             	mov    %edx,0x8(%eax)
  80209e:	eb 0b                	jmp    8020ab <free+0x43b>
  8020a0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8020a3:	8b 40 08             	mov    0x8(%eax),%eax
  8020a6:	a3 20 d1 81 00       	mov    %eax,0x81d120
  8020ab:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8020ae:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  8020b5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8020b8:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  8020bf:	a1 2c d1 81 00       	mov    0x81d12c,%eax
  8020c4:	48                   	dec    %eax
  8020c5:	a3 2c d1 81 00       	mov    %eax,0x81d12c
					break;
  8020ca:	e9 c2 00 00 00       	jmp    802191 <free+0x521>
		//if not merged find possible merge with next
				}else{
					MergedBlock->startva = newfree->startva;
  8020cf:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8020d2:	8b 10                	mov    (%eax),%edx
  8020d4:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8020d7:	89 10                	mov    %edx,(%eax)
					MergedBlock->size  = newfree->size + ToBeMerged->size;
  8020d9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8020dc:	8b 50 04             	mov    0x4(%eax),%edx
  8020df:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8020e2:	8b 40 04             	mov    0x4(%eax),%eax
  8020e5:	01 c2                	add    %eax,%edx
  8020e7:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8020ea:	89 50 04             	mov    %edx,0x4(%eax)
					LIST_REMOVE(&u_freelist, ToBeMerged);
  8020ed:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8020f1:	75 17                	jne    80210a <free+0x49a>
  8020f3:	83 ec 04             	sub    $0x4,%esp
  8020f6:	68 fb 4c 80 00       	push   $0x804cfb
  8020fb:	68 10 01 00 00       	push   $0x110
  802100:	68 8c 4c 80 00       	push   $0x804c8c
  802105:	e8 81 e3 ff ff       	call   80048b <_panic>
  80210a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80210d:	8b 40 08             	mov    0x8(%eax),%eax
  802110:	85 c0                	test   %eax,%eax
  802112:	74 11                	je     802125 <free+0x4b5>
  802114:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802117:	8b 40 08             	mov    0x8(%eax),%eax
  80211a:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80211d:	8b 52 0c             	mov    0xc(%edx),%edx
  802120:	89 50 0c             	mov    %edx,0xc(%eax)
  802123:	eb 0b                	jmp    802130 <free+0x4c0>
  802125:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802128:	8b 40 0c             	mov    0xc(%eax),%eax
  80212b:	a3 24 d1 81 00       	mov    %eax,0x81d124
  802130:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802133:	8b 40 0c             	mov    0xc(%eax),%eax
  802136:	85 c0                	test   %eax,%eax
  802138:	74 11                	je     80214b <free+0x4db>
  80213a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80213d:	8b 40 0c             	mov    0xc(%eax),%eax
  802140:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802143:	8b 52 08             	mov    0x8(%edx),%edx
  802146:	89 50 08             	mov    %edx,0x8(%eax)
  802149:	eb 0b                	jmp    802156 <free+0x4e6>
  80214b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80214e:	8b 40 08             	mov    0x8(%eax),%eax
  802151:	a3 20 d1 81 00       	mov    %eax,0x81d120
  802156:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802159:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802160:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802163:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  80216a:	a1 2c d1 81 00       	mov    0x81d12c,%eax
  80216f:	48                   	dec    %eax
  802170:	a3 2c d1 81 00       	mov    %eax,0x81d12c
					mergenext = 1;
  802175:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
					break;
  80217c:	eb 13                	jmp    802191 <free+0x521>
				}
			}
			ToBeMerged = ToBeMerged->prev_next_info.le_next;
  80217e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802181:	8b 40 08             	mov    0x8(%eax),%eax
  802184:	89 45 ec             	mov    %eax,-0x14(%ebp)
		}


		//check if block is merged with prev ,and find possible merge with next
		ToBeMerged = LIST_FIRST(&u_freelist);
		while(ToBeMerged != NULL){
  802187:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80218b:	0f 85 79 fe ff ff    	jne    80200a <free+0x39a>




			// insertion
			struct UserHeapStruct* currentfree = LIST_FIRST(&u_freelist);
  802191:	a1 20 d1 81 00       	mov    0x81d120,%eax
  802196:	89 45 e0             	mov    %eax,-0x20(%ebp)

			if(mergeprev || mergenext){
  802199:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80219d:	0f 85 ad 00 00 00    	jne    802250 <free+0x5e0>
  8021a3:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8021a7:	0f 84 c3 01 00 00    	je     802370 <free+0x700>
				while(currentfree != NULL){
  8021ad:	e9 9e 00 00 00       	jmp    802250 <free+0x5e0>
					if(MergedBlock->size < currentfree->size){
  8021b2:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8021b5:	8b 50 04             	mov    0x4(%eax),%edx
  8021b8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8021bb:	8b 40 04             	mov    0x4(%eax),%eax
  8021be:	39 c2                	cmp    %eax,%edx
  8021c0:	0f 83 81 00 00 00    	jae    802247 <free+0x5d7>

							LIST_INSERT_BEFORE(&u_freelist,currentfree,MergedBlock);
  8021c6:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8021ca:	74 06                	je     8021d2 <free+0x562>
  8021cc:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  8021d0:	75 17                	jne    8021e9 <free+0x579>
  8021d2:	83 ec 04             	sub    $0x4,%esp
  8021d5:	68 1c 4d 80 00       	push   $0x804d1c
  8021da:	68 23 01 00 00       	push   $0x123
  8021df:	68 8c 4c 80 00       	push   $0x804c8c
  8021e4:	e8 a2 e2 ff ff       	call   80048b <_panic>
  8021e9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8021ec:	8b 50 0c             	mov    0xc(%eax),%edx
  8021ef:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8021f2:	89 50 0c             	mov    %edx,0xc(%eax)
  8021f5:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8021f8:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8021fb:	89 50 08             	mov    %edx,0x8(%eax)
  8021fe:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802201:	8b 40 0c             	mov    0xc(%eax),%eax
  802204:	85 c0                	test   %eax,%eax
  802206:	74 0e                	je     802216 <free+0x5a6>
  802208:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80220b:	8b 40 0c             	mov    0xc(%eax),%eax
  80220e:	8b 55 d0             	mov    -0x30(%ebp),%edx
  802211:	89 50 08             	mov    %edx,0x8(%eax)
  802214:	eb 08                	jmp    80221e <free+0x5ae>
  802216:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802219:	a3 20 d1 81 00       	mov    %eax,0x81d120
  80221e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802221:	8b 55 d0             	mov    -0x30(%ebp),%edx
  802224:	89 50 0c             	mov    %edx,0xc(%eax)
  802227:	a1 2c d1 81 00       	mov    0x81d12c,%eax
  80222c:	40                   	inc    %eax
  80222d:	a3 2c d1 81 00       	mov    %eax,0x81d12c
							release_uspinlock(&ulock);
  802232:	83 ec 0c             	sub    $0xc,%esp
  802235:	68 40 d1 81 00       	push   $0x81d140
  80223a:	e8 1f 1e 00 00       	call   80405e <release_uspinlock>
  80223f:	83 c4 10             	add    $0x10,%esp
							return;
  802242:	e9 b7 01 00 00       	jmp    8023fe <free+0x78e>
					}
							currentfree = currentfree->prev_next_info.le_next;
  802247:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80224a:	8b 40 08             	mov    0x8(%eax),%eax
  80224d:	89 45 e0             	mov    %eax,-0x20(%ebp)

			// insertion
			struct UserHeapStruct* currentfree = LIST_FIRST(&u_freelist);

			if(mergeprev || mergenext){
				while(currentfree != NULL){
  802250:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802254:	0f 85 58 ff ff ff    	jne    8021b2 <free+0x542>
							release_uspinlock(&ulock);
							return;
					}
							currentfree = currentfree->prev_next_info.le_next;
				}
				free_block(newfree);
  80225a:	83 ec 0c             	sub    $0xc,%esp
  80225d:	ff 75 d4             	pushl  -0x2c(%ebp)
  802260:	e8 d5 19 00 00       	call   803c3a <free_block>
  802265:	83 c4 10             	add    $0x10,%esp
				LIST_INSERT_TAIL(&u_freelist,MergedBlock);
  802268:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  80226c:	75 17                	jne    802285 <free+0x615>
  80226e:	83 ec 04             	sub    $0x4,%esp
  802271:	68 d8 4c 80 00       	push   $0x804cd8
  802276:	68 2a 01 00 00       	push   $0x12a
  80227b:	68 8c 4c 80 00       	push   $0x804c8c
  802280:	e8 06 e2 ff ff       	call   80048b <_panic>
  802285:	8b 15 24 d1 81 00    	mov    0x81d124,%edx
  80228b:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80228e:	89 50 0c             	mov    %edx,0xc(%eax)
  802291:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802294:	8b 40 0c             	mov    0xc(%eax),%eax
  802297:	85 c0                	test   %eax,%eax
  802299:	74 0d                	je     8022a8 <free+0x638>
  80229b:	a1 24 d1 81 00       	mov    0x81d124,%eax
  8022a0:	8b 55 d0             	mov    -0x30(%ebp),%edx
  8022a3:	89 50 08             	mov    %edx,0x8(%eax)
  8022a6:	eb 08                	jmp    8022b0 <free+0x640>
  8022a8:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8022ab:	a3 20 d1 81 00       	mov    %eax,0x81d120
  8022b0:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8022b3:	a3 24 d1 81 00       	mov    %eax,0x81d124
  8022b8:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8022bb:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  8022c2:	a1 2c d1 81 00       	mov    0x81d12c,%eax
  8022c7:	40                   	inc    %eax
  8022c8:	a3 2c d1 81 00       	mov    %eax,0x81d12c
  8022cd:	e9 1b 01 00 00       	jmp    8023ed <free+0x77d>

			}else{
				while(currentfree != NULL){
					if(newfree->size < currentfree->size){
  8022d2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8022d5:	8b 50 04             	mov    0x4(%eax),%edx
  8022d8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8022db:	8b 40 04             	mov    0x4(%eax),%eax
  8022de:	39 c2                	cmp    %eax,%edx
  8022e0:	0f 83 81 00 00 00    	jae    802367 <free+0x6f7>

							LIST_INSERT_BEFORE(&u_freelist,currentfree,newfree);
  8022e6:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8022ea:	74 06                	je     8022f2 <free+0x682>
  8022ec:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8022f0:	75 17                	jne    802309 <free+0x699>
  8022f2:	83 ec 04             	sub    $0x4,%esp
  8022f5:	68 1c 4d 80 00       	push   $0x804d1c
  8022fa:	68 30 01 00 00       	push   $0x130
  8022ff:	68 8c 4c 80 00       	push   $0x804c8c
  802304:	e8 82 e1 ff ff       	call   80048b <_panic>
  802309:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80230c:	8b 50 0c             	mov    0xc(%eax),%edx
  80230f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802312:	89 50 0c             	mov    %edx,0xc(%eax)
  802315:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802318:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80231b:	89 50 08             	mov    %edx,0x8(%eax)
  80231e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802321:	8b 40 0c             	mov    0xc(%eax),%eax
  802324:	85 c0                	test   %eax,%eax
  802326:	74 0e                	je     802336 <free+0x6c6>
  802328:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80232b:	8b 40 0c             	mov    0xc(%eax),%eax
  80232e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802331:	89 50 08             	mov    %edx,0x8(%eax)
  802334:	eb 08                	jmp    80233e <free+0x6ce>
  802336:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802339:	a3 20 d1 81 00       	mov    %eax,0x81d120
  80233e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802341:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802344:	89 50 0c             	mov    %edx,0xc(%eax)
  802347:	a1 2c d1 81 00       	mov    0x81d12c,%eax
  80234c:	40                   	inc    %eax
  80234d:	a3 2c d1 81 00       	mov    %eax,0x81d12c
							release_uspinlock(&ulock);
  802352:	83 ec 0c             	sub    $0xc,%esp
  802355:	68 40 d1 81 00       	push   $0x81d140
  80235a:	e8 ff 1c 00 00       	call   80405e <release_uspinlock>
  80235f:	83 c4 10             	add    $0x10,%esp
							return;
  802362:	e9 97 00 00 00       	jmp    8023fe <free+0x78e>
					}
							currentfree = currentfree->prev_next_info.le_next;
  802367:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80236a:	8b 40 08             	mov    0x8(%eax),%eax
  80236d:	89 45 e0             	mov    %eax,-0x20(%ebp)
				}
				free_block(newfree);
				LIST_INSERT_TAIL(&u_freelist,MergedBlock);

			}else{
				while(currentfree != NULL){
  802370:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802374:	0f 85 58 ff ff ff    	jne    8022d2 <free+0x662>
							release_uspinlock(&ulock);
							return;
					}
							currentfree = currentfree->prev_next_info.le_next;
				}
				free_block(MergedBlock);
  80237a:	83 ec 0c             	sub    $0xc,%esp
  80237d:	ff 75 d0             	pushl  -0x30(%ebp)
  802380:	e8 b5 18 00 00       	call   803c3a <free_block>
  802385:	83 c4 10             	add    $0x10,%esp
				LIST_INSERT_TAIL(&u_freelist,newfree);
  802388:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80238c:	75 17                	jne    8023a5 <free+0x735>
  80238e:	83 ec 04             	sub    $0x4,%esp
  802391:	68 d8 4c 80 00       	push   $0x804cd8
  802396:	68 37 01 00 00       	push   $0x137
  80239b:	68 8c 4c 80 00       	push   $0x804c8c
  8023a0:	e8 e6 e0 ff ff       	call   80048b <_panic>
  8023a5:	8b 15 24 d1 81 00    	mov    0x81d124,%edx
  8023ab:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8023ae:	89 50 0c             	mov    %edx,0xc(%eax)
  8023b1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8023b4:	8b 40 0c             	mov    0xc(%eax),%eax
  8023b7:	85 c0                	test   %eax,%eax
  8023b9:	74 0d                	je     8023c8 <free+0x758>
  8023bb:	a1 24 d1 81 00       	mov    0x81d124,%eax
  8023c0:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8023c3:	89 50 08             	mov    %edx,0x8(%eax)
  8023c6:	eb 08                	jmp    8023d0 <free+0x760>
  8023c8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8023cb:	a3 20 d1 81 00       	mov    %eax,0x81d120
  8023d0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8023d3:	a3 24 d1 81 00       	mov    %eax,0x81d124
  8023d8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8023db:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  8023e2:	a1 2c d1 81 00       	mov    0x81d12c,%eax
  8023e7:	40                   	inc    %eax
  8023e8:	a3 2c d1 81 00       	mov    %eax,0x81d12c
			}
		release_uspinlock(&ulock);
  8023ed:	83 ec 0c             	sub    $0xc,%esp
  8023f0:	68 40 d1 81 00       	push   $0x81d140
  8023f5:	e8 64 1c 00 00       	call   80405e <release_uspinlock>
  8023fa:	83 c4 10             	add    $0x10,%esp
		return;
  8023fd:	90                   	nop
}
  8023fe:	c9                   	leave  
  8023ff:	c3                   	ret    

00802400 <smalloc>:

//=================================
// [3] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  802400:	55                   	push   %ebp
  802401:	89 e5                	mov    %esp,%ebp
  802403:	83 ec 48             	sub    $0x48,%esp
  802406:	8b 45 10             	mov    0x10(%ebp),%eax
  802409:	88 45 c4             	mov    %al,-0x3c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  80240c:	e8 2d f2 ff ff       	call   80163e <uheap_init>
	if (size == 0) return NULL;
  802411:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802415:	75 0a                	jne    802421 <smalloc+0x21>
  802417:	b8 00 00 00 00       	mov    $0x0,%eax
  80241c:	e9 84 05 00 00       	jmp    8029a5 <smalloc+0x5a5>
	//==============================================================
	acquire_uspinlock(&ulock);
  802421:	83 ec 0c             	sub    $0xc,%esp
  802424:	68 40 d1 81 00       	push   $0x81d140
  802429:	e8 d8 1b 00 00       	call   804006 <acquire_uspinlock>
  80242e:	83 c4 10             	add    $0x10,%esp

	struct UserHeapStruct* allocblock = (struct UserHeapStruct*) alloc_block(sizeof(struct UserHeapStruct));
  802431:	83 ec 0c             	sub    $0xc,%esp
  802434:	6a 10                	push   $0x10
  802436:	e8 63 13 00 00       	call   80379e <alloc_block>
  80243b:	83 c4 10             	add    $0x10,%esp
  80243e:	89 45 ec             	mov    %eax,-0x14(%ebp)
	if (allocblock == NULL){
  802441:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802445:	75 0a                	jne    802451 <smalloc+0x51>
				return NULL;
  802447:	b8 00 00 00 00       	mov    $0x0,%eax
  80244c:	e9 54 05 00 00       	jmp    8029a5 <smalloc+0x5a5>
	}
		size = ROUNDUP(size,PAGE_SIZE);
  802451:	c7 45 e8 00 10 00 00 	movl   $0x1000,-0x18(%ebp)
  802458:	8b 55 0c             	mov    0xc(%ebp),%edx
  80245b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80245e:	01 d0                	add    %edx,%eax
  802460:	48                   	dec    %eax
  802461:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  802464:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802467:	ba 00 00 00 00       	mov    $0x0,%edx
  80246c:	f7 75 e8             	divl   -0x18(%ebp)
  80246f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802472:	29 d0                	sub    %edx,%eax
  802474:	89 45 0c             	mov    %eax,0xc(%ebp)
		struct UserHeapStruct* lastfreeelement = LIST_LAST(&u_freelist);
  802477:	a1 24 d1 81 00       	mov    0x81d124,%eax
  80247c:	89 45 e0             	mov    %eax,-0x20(%ebp)

		if(LIST_SIZE(&u_freelist)==0 || size>lastfreeelement->size){
  80247f:	a1 2c d1 81 00       	mov    0x81d12c,%eax
  802484:	85 c0                	test   %eax,%eax
  802486:	74 0f                	je     802497 <smalloc+0x97>
  802488:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80248b:	8b 40 04             	mov    0x4(%eax),%eax
  80248e:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802491:	0f 83 25 01 00 00    	jae    8025bc <smalloc+0x1bc>
				if(uheapPageAllocBreak <= USER_HEAP_MAX - size){
  802497:	b8 00 00 00 a0       	mov    $0xa0000000,%eax
  80249c:	2b 45 0c             	sub    0xc(%ebp),%eax
  80249f:	89 c2                	mov    %eax,%edx
  8024a1:	a1 68 d0 81 00       	mov    0x81d068,%eax
  8024a6:	39 c2                	cmp    %eax,%edx
  8024a8:	0f 82 f4 00 00 00    	jb     8025a2 <smalloc+0x1a2>
						uint32 requestedblockva = uheapPageAllocBreak;
  8024ae:	a1 68 d0 81 00       	mov    0x81d068,%eax
  8024b3:	89 45 d4             	mov    %eax,-0x2c(%ebp)
						uheapPageAllocBreak+=size;
  8024b6:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  8024bc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8024bf:	01 d0                	add    %edx,%eax
  8024c1:	a3 68 d0 81 00       	mov    %eax,0x81d068
						allocblock->startva = requestedblockva;
  8024c6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8024c9:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8024cc:	89 10                	mov    %edx,(%eax)
						allocblock->size = size;
  8024ce:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8024d1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8024d4:	89 50 04             	mov    %edx,0x4(%eax)

						LIST_INSERT_TAIL(&u_allocatedlist, allocblock);
  8024d7:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8024db:	75 17                	jne    8024f4 <smalloc+0xf4>
  8024dd:	83 ec 04             	sub    $0x4,%esp
  8024e0:	68 d8 4c 80 00       	push   $0x804cd8
  8024e5:	68 57 01 00 00       	push   $0x157
  8024ea:	68 8c 4c 80 00       	push   $0x804c8c
  8024ef:	e8 97 df ff ff       	call   80048b <_panic>
  8024f4:	8b 15 34 d1 81 00    	mov    0x81d134,%edx
  8024fa:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8024fd:	89 50 0c             	mov    %edx,0xc(%eax)
  802500:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802503:	8b 40 0c             	mov    0xc(%eax),%eax
  802506:	85 c0                	test   %eax,%eax
  802508:	74 0d                	je     802517 <smalloc+0x117>
  80250a:	a1 34 d1 81 00       	mov    0x81d134,%eax
  80250f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802512:	89 50 08             	mov    %edx,0x8(%eax)
  802515:	eb 08                	jmp    80251f <smalloc+0x11f>
  802517:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80251a:	a3 30 d1 81 00       	mov    %eax,0x81d130
  80251f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802522:	a3 34 d1 81 00       	mov    %eax,0x81d134
  802527:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80252a:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802531:	a1 3c d1 81 00       	mov    0x81d13c,%eax
  802536:	40                   	inc    %eax
  802537:	a3 3c d1 81 00       	mov    %eax,0x81d13c


						int result = sys_create_shared_object(sharedVarName ,size ,isWritable ,(void*)allocblock->startva);
  80253c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80253f:	8b 00                	mov    (%eax),%eax
  802541:	89 c2                	mov    %eax,%edx
  802543:	0f b6 45 c4          	movzbl -0x3c(%ebp),%eax
  802547:	52                   	push   %edx
  802548:	50                   	push   %eax
  802549:	ff 75 0c             	pushl  0xc(%ebp)
  80254c:	ff 75 08             	pushl  0x8(%ebp)
  80254f:	e8 48 0c 00 00       	call   80319c <sys_create_shared_object>
  802554:	83 c4 10             	add    $0x10,%esp
  802557:	89 45 d0             	mov    %eax,-0x30(%ebp)

						if(result <0){
  80255a:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  80255e:	79 28                	jns    802588 <smalloc+0x188>
							free_block(allocblock);
  802560:	83 ec 0c             	sub    $0xc,%esp
  802563:	ff 75 ec             	pushl  -0x14(%ebp)
  802566:	e8 cf 16 00 00       	call   803c3a <free_block>
  80256b:	83 c4 10             	add    $0x10,%esp
							release_uspinlock(&ulock);
  80256e:	83 ec 0c             	sub    $0xc,%esp
  802571:	68 40 d1 81 00       	push   $0x81d140
  802576:	e8 e3 1a 00 00       	call   80405e <release_uspinlock>
  80257b:	83 c4 10             	add    $0x10,%esp
							return NULL;
  80257e:	b8 00 00 00 00       	mov    $0x0,%eax
  802583:	e9 1d 04 00 00       	jmp    8029a5 <smalloc+0x5a5>
						}
						release_uspinlock(&ulock);
  802588:	83 ec 0c             	sub    $0xc,%esp
  80258b:	68 40 d1 81 00       	push   $0x81d140
  802590:	e8 c9 1a 00 00       	call   80405e <release_uspinlock>
  802595:	83 c4 10             	add    $0x10,%esp
						return (void*)allocblock -> startva;
  802598:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80259b:	8b 00                	mov    (%eax),%eax
  80259d:	e9 03 04 00 00       	jmp    8029a5 <smalloc+0x5a5>
				}else{
						release_uspinlock(&ulock);
  8025a2:	83 ec 0c             	sub    $0xc,%esp
  8025a5:	68 40 d1 81 00       	push   $0x81d140
  8025aa:	e8 af 1a 00 00       	call   80405e <release_uspinlock>
  8025af:	83 c4 10             	add    $0x10,%esp
						return NULL;
  8025b2:	b8 00 00 00 00       	mov    $0x0,%eax
  8025b7:	e9 e9 03 00 00       	jmp    8029a5 <smalloc+0x5a5>
					 }
		}else{
			//custom fit
			struct UserHeapStruct* currentfreeelement = LIST_FIRST(&u_freelist);
  8025bc:	a1 20 d1 81 00       	mov    0x81d120,%eax
  8025c1:	89 45 f4             	mov    %eax,-0xc(%ebp)
			//worst fit
			while(currentfreeelement != NULL){
  8025c4:	e9 af 03 00 00       	jmp    802978 <smalloc+0x578>
				if(size<currentfreeelement->size){
  8025c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025cc:	8b 40 04             	mov    0x4(%eax),%eax
  8025cf:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8025d2:	0f 86 28 02 00 00    	jbe    802800 <smalloc+0x400>
					allocblock->startva = lastfreeelement->startva;
  8025d8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8025db:	8b 10                	mov    (%eax),%edx
  8025dd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025e0:	89 10                	mov    %edx,(%eax)
	                allocblock->size = size;
  8025e2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025e5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8025e8:	89 50 04             	mov    %edx,0x4(%eax)
	                LIST_INSERT_TAIL(&u_allocatedlist,allocblock);
  8025eb:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8025ef:	75 17                	jne    802608 <smalloc+0x208>
  8025f1:	83 ec 04             	sub    $0x4,%esp
  8025f4:	68 d8 4c 80 00       	push   $0x804cd8
  8025f9:	68 6f 01 00 00       	push   $0x16f
  8025fe:	68 8c 4c 80 00       	push   $0x804c8c
  802603:	e8 83 de ff ff       	call   80048b <_panic>
  802608:	8b 15 34 d1 81 00    	mov    0x81d134,%edx
  80260e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802611:	89 50 0c             	mov    %edx,0xc(%eax)
  802614:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802617:	8b 40 0c             	mov    0xc(%eax),%eax
  80261a:	85 c0                	test   %eax,%eax
  80261c:	74 0d                	je     80262b <smalloc+0x22b>
  80261e:	a1 34 d1 81 00       	mov    0x81d134,%eax
  802623:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802626:	89 50 08             	mov    %edx,0x8(%eax)
  802629:	eb 08                	jmp    802633 <smalloc+0x233>
  80262b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80262e:	a3 30 d1 81 00       	mov    %eax,0x81d130
  802633:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802636:	a3 34 d1 81 00       	mov    %eax,0x81d134
  80263b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80263e:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802645:	a1 3c d1 81 00       	mov    0x81d13c,%eax
  80264a:	40                   	inc    %eax
  80264b:	a3 3c d1 81 00       	mov    %eax,0x81d13c
	                lastfreeelement->startva += size;
  802650:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802653:	8b 10                	mov    (%eax),%edx
  802655:	8b 45 0c             	mov    0xc(%ebp),%eax
  802658:	01 c2                	add    %eax,%edx
  80265a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80265d:	89 10                	mov    %edx,(%eax)
	                lastfreeelement->size -= size;
  80265f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802662:	8b 40 04             	mov    0x4(%eax),%eax
  802665:	2b 45 0c             	sub    0xc(%ebp),%eax
  802668:	89 c2                	mov    %eax,%edx
  80266a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80266d:	89 50 04             	mov    %edx,0x4(%eax)
	                struct UserHeapStruct* currentfree2 = LIST_FIRST(&u_freelist);
  802670:	a1 20 d1 81 00       	mov    0x81d120,%eax
  802675:	89 45 f0             	mov    %eax,-0x10(%ebp)
	                //check order of last element

	                while (currentfree2 != NULL){
  802678:	e9 13 01 00 00       	jmp    802790 <smalloc+0x390>
	                	if(lastfreeelement->size <currentfree2->size){
  80267d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802680:	8b 50 04             	mov    0x4(%eax),%edx
  802683:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802686:	8b 40 04             	mov    0x4(%eax),%eax
  802689:	39 c2                	cmp    %eax,%edx
  80268b:	0f 83 f6 00 00 00    	jae    802787 <smalloc+0x387>
	                		LIST_REMOVE(&u_freelist ,lastfreeelement);
  802691:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802695:	75 17                	jne    8026ae <smalloc+0x2ae>
  802697:	83 ec 04             	sub    $0x4,%esp
  80269a:	68 fb 4c 80 00       	push   $0x804cfb
  80269f:	68 77 01 00 00       	push   $0x177
  8026a4:	68 8c 4c 80 00       	push   $0x804c8c
  8026a9:	e8 dd dd ff ff       	call   80048b <_panic>
  8026ae:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8026b1:	8b 40 08             	mov    0x8(%eax),%eax
  8026b4:	85 c0                	test   %eax,%eax
  8026b6:	74 11                	je     8026c9 <smalloc+0x2c9>
  8026b8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8026bb:	8b 40 08             	mov    0x8(%eax),%eax
  8026be:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8026c1:	8b 52 0c             	mov    0xc(%edx),%edx
  8026c4:	89 50 0c             	mov    %edx,0xc(%eax)
  8026c7:	eb 0b                	jmp    8026d4 <smalloc+0x2d4>
  8026c9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8026cc:	8b 40 0c             	mov    0xc(%eax),%eax
  8026cf:	a3 24 d1 81 00       	mov    %eax,0x81d124
  8026d4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8026d7:	8b 40 0c             	mov    0xc(%eax),%eax
  8026da:	85 c0                	test   %eax,%eax
  8026dc:	74 11                	je     8026ef <smalloc+0x2ef>
  8026de:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8026e1:	8b 40 0c             	mov    0xc(%eax),%eax
  8026e4:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8026e7:	8b 52 08             	mov    0x8(%edx),%edx
  8026ea:	89 50 08             	mov    %edx,0x8(%eax)
  8026ed:	eb 0b                	jmp    8026fa <smalloc+0x2fa>
  8026ef:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8026f2:	8b 40 08             	mov    0x8(%eax),%eax
  8026f5:	a3 20 d1 81 00       	mov    %eax,0x81d120
  8026fa:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8026fd:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802704:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802707:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  80270e:	a1 2c d1 81 00       	mov    0x81d12c,%eax
  802713:	48                   	dec    %eax
  802714:	a3 2c d1 81 00       	mov    %eax,0x81d12c
	                		LIST_INSERT_BEFORE(&u_freelist ,currentfree2 ,lastfreeelement);
  802719:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80271d:	74 06                	je     802725 <smalloc+0x325>
  80271f:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802723:	75 17                	jne    80273c <smalloc+0x33c>
  802725:	83 ec 04             	sub    $0x4,%esp
  802728:	68 1c 4d 80 00       	push   $0x804d1c
  80272d:	68 78 01 00 00       	push   $0x178
  802732:	68 8c 4c 80 00       	push   $0x804c8c
  802737:	e8 4f dd ff ff       	call   80048b <_panic>
  80273c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80273f:	8b 50 0c             	mov    0xc(%eax),%edx
  802742:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802745:	89 50 0c             	mov    %edx,0xc(%eax)
  802748:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80274b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80274e:	89 50 08             	mov    %edx,0x8(%eax)
  802751:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802754:	8b 40 0c             	mov    0xc(%eax),%eax
  802757:	85 c0                	test   %eax,%eax
  802759:	74 0e                	je     802769 <smalloc+0x369>
  80275b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80275e:	8b 40 0c             	mov    0xc(%eax),%eax
  802761:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802764:	89 50 08             	mov    %edx,0x8(%eax)
  802767:	eb 08                	jmp    802771 <smalloc+0x371>
  802769:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80276c:	a3 20 d1 81 00       	mov    %eax,0x81d120
  802771:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802774:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802777:	89 50 0c             	mov    %edx,0xc(%eax)
  80277a:	a1 2c d1 81 00       	mov    0x81d12c,%eax
  80277f:	40                   	inc    %eax
  802780:	a3 2c d1 81 00       	mov    %eax,0x81d12c
	                		break;
  802785:	eb 13                	jmp    80279a <smalloc+0x39a>
	                	}
	                	currentfree2 = currentfree2->prev_next_info.le_next;
  802787:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80278a:	8b 40 08             	mov    0x8(%eax),%eax
  80278d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	                lastfreeelement->startva += size;
	                lastfreeelement->size -= size;
	                struct UserHeapStruct* currentfree2 = LIST_FIRST(&u_freelist);
	                //check order of last element

	                while (currentfree2 != NULL){
  802790:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802794:	0f 85 e3 fe ff ff    	jne    80267d <smalloc+0x27d>
	                	}
	                	currentfree2 = currentfree2->prev_next_info.le_next;
	                }


	                int result = sys_create_shared_object(sharedVarName ,size ,isWritable ,(void*)allocblock->startva);
  80279a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80279d:	8b 00                	mov    (%eax),%eax
  80279f:	89 c2                	mov    %eax,%edx
  8027a1:	0f b6 45 c4          	movzbl -0x3c(%ebp),%eax
  8027a5:	52                   	push   %edx
  8027a6:	50                   	push   %eax
  8027a7:	ff 75 0c             	pushl  0xc(%ebp)
  8027aa:	ff 75 08             	pushl  0x8(%ebp)
  8027ad:	e8 ea 09 00 00       	call   80319c <sys_create_shared_object>
  8027b2:	83 c4 10             	add    $0x10,%esp
  8027b5:	89 45 d8             	mov    %eax,-0x28(%ebp)

	                if(result <0){
  8027b8:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8027bc:	79 28                	jns    8027e6 <smalloc+0x3e6>
	                	free_block(allocblock);
  8027be:	83 ec 0c             	sub    $0xc,%esp
  8027c1:	ff 75 ec             	pushl  -0x14(%ebp)
  8027c4:	e8 71 14 00 00       	call   803c3a <free_block>
  8027c9:	83 c4 10             	add    $0x10,%esp
	                	release_uspinlock(&ulock);
  8027cc:	83 ec 0c             	sub    $0xc,%esp
  8027cf:	68 40 d1 81 00       	push   $0x81d140
  8027d4:	e8 85 18 00 00       	call   80405e <release_uspinlock>
  8027d9:	83 c4 10             	add    $0x10,%esp
	                	return NULL;
  8027dc:	b8 00 00 00 00       	mov    $0x0,%eax
  8027e1:	e9 bf 01 00 00       	jmp    8029a5 <smalloc+0x5a5>
	                }
	                release_uspinlock(&ulock);
  8027e6:	83 ec 0c             	sub    $0xc,%esp
  8027e9:	68 40 d1 81 00       	push   $0x81d140
  8027ee:	e8 6b 18 00 00       	call   80405e <release_uspinlock>
  8027f3:	83 c4 10             	add    $0x10,%esp
	                return (void*)allocblock->startva;
  8027f6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027f9:	8b 00                	mov    (%eax),%eax
  8027fb:	e9 a5 01 00 00       	jmp    8029a5 <smalloc+0x5a5>
	                //exact fit
				}else if(size == currentfreeelement->size){
  802800:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802803:	8b 40 04             	mov    0x4(%eax),%eax
  802806:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802809:	0f 85 60 01 00 00    	jne    80296f <smalloc+0x56f>
					allocblock->startva = currentfreeelement->startva;
  80280f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802812:	8b 10                	mov    (%eax),%edx
  802814:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802817:	89 10                	mov    %edx,(%eax)
					allocblock->size = size;
  802819:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80281c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80281f:	89 50 04             	mov    %edx,0x4(%eax)
					LIST_INSERT_TAIL(&u_allocatedlist ,allocblock);
  802822:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802826:	75 17                	jne    80283f <smalloc+0x43f>
  802828:	83 ec 04             	sub    $0x4,%esp
  80282b:	68 d8 4c 80 00       	push   $0x804cd8
  802830:	68 8c 01 00 00       	push   $0x18c
  802835:	68 8c 4c 80 00       	push   $0x804c8c
  80283a:	e8 4c dc ff ff       	call   80048b <_panic>
  80283f:	8b 15 34 d1 81 00    	mov    0x81d134,%edx
  802845:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802848:	89 50 0c             	mov    %edx,0xc(%eax)
  80284b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80284e:	8b 40 0c             	mov    0xc(%eax),%eax
  802851:	85 c0                	test   %eax,%eax
  802853:	74 0d                	je     802862 <smalloc+0x462>
  802855:	a1 34 d1 81 00       	mov    0x81d134,%eax
  80285a:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80285d:	89 50 08             	mov    %edx,0x8(%eax)
  802860:	eb 08                	jmp    80286a <smalloc+0x46a>
  802862:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802865:	a3 30 d1 81 00       	mov    %eax,0x81d130
  80286a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80286d:	a3 34 d1 81 00       	mov    %eax,0x81d134
  802872:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802875:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  80287c:	a1 3c d1 81 00       	mov    0x81d13c,%eax
  802881:	40                   	inc    %eax
  802882:	a3 3c d1 81 00       	mov    %eax,0x81d13c
					LIST_REMOVE(&u_freelist ,currentfreeelement);
  802887:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80288b:	75 17                	jne    8028a4 <smalloc+0x4a4>
  80288d:	83 ec 04             	sub    $0x4,%esp
  802890:	68 fb 4c 80 00       	push   $0x804cfb
  802895:	68 8d 01 00 00       	push   $0x18d
  80289a:	68 8c 4c 80 00       	push   $0x804c8c
  80289f:	e8 e7 db ff ff       	call   80048b <_panic>
  8028a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028a7:	8b 40 08             	mov    0x8(%eax),%eax
  8028aa:	85 c0                	test   %eax,%eax
  8028ac:	74 11                	je     8028bf <smalloc+0x4bf>
  8028ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028b1:	8b 40 08             	mov    0x8(%eax),%eax
  8028b4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028b7:	8b 52 0c             	mov    0xc(%edx),%edx
  8028ba:	89 50 0c             	mov    %edx,0xc(%eax)
  8028bd:	eb 0b                	jmp    8028ca <smalloc+0x4ca>
  8028bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028c2:	8b 40 0c             	mov    0xc(%eax),%eax
  8028c5:	a3 24 d1 81 00       	mov    %eax,0x81d124
  8028ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028cd:	8b 40 0c             	mov    0xc(%eax),%eax
  8028d0:	85 c0                	test   %eax,%eax
  8028d2:	74 11                	je     8028e5 <smalloc+0x4e5>
  8028d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028d7:	8b 40 0c             	mov    0xc(%eax),%eax
  8028da:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028dd:	8b 52 08             	mov    0x8(%edx),%edx
  8028e0:	89 50 08             	mov    %edx,0x8(%eax)
  8028e3:	eb 0b                	jmp    8028f0 <smalloc+0x4f0>
  8028e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028e8:	8b 40 08             	mov    0x8(%eax),%eax
  8028eb:	a3 20 d1 81 00       	mov    %eax,0x81d120
  8028f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028f3:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  8028fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028fd:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  802904:	a1 2c d1 81 00       	mov    0x81d12c,%eax
  802909:	48                   	dec    %eax
  80290a:	a3 2c d1 81 00       	mov    %eax,0x81d12c
					int result = sys_create_shared_object(sharedVarName ,size ,isWritable ,(void*)allocblock->startva);
  80290f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802912:	8b 00                	mov    (%eax),%eax
  802914:	89 c2                	mov    %eax,%edx
  802916:	0f b6 45 c4          	movzbl -0x3c(%ebp),%eax
  80291a:	52                   	push   %edx
  80291b:	50                   	push   %eax
  80291c:	ff 75 0c             	pushl  0xc(%ebp)
  80291f:	ff 75 08             	pushl  0x8(%ebp)
  802922:	e8 75 08 00 00       	call   80319c <sys_create_shared_object>
  802927:	83 c4 10             	add    $0x10,%esp
  80292a:	89 45 dc             	mov    %eax,-0x24(%ebp)

					if(result <0){
  80292d:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802931:	79 25                	jns    802958 <smalloc+0x558>
						free_block(allocblock);
  802933:	83 ec 0c             	sub    $0xc,%esp
  802936:	ff 75 ec             	pushl  -0x14(%ebp)
  802939:	e8 fc 12 00 00       	call   803c3a <free_block>
  80293e:	83 c4 10             	add    $0x10,%esp
						release_uspinlock(&ulock);
  802941:	83 ec 0c             	sub    $0xc,%esp
  802944:	68 40 d1 81 00       	push   $0x81d140
  802949:	e8 10 17 00 00       	call   80405e <release_uspinlock>
  80294e:	83 c4 10             	add    $0x10,%esp
						return NULL;
  802951:	b8 00 00 00 00       	mov    $0x0,%eax
  802956:	eb 4d                	jmp    8029a5 <smalloc+0x5a5>
					}
					release_uspinlock(&ulock);
  802958:	83 ec 0c             	sub    $0xc,%esp
  80295b:	68 40 d1 81 00       	push   $0x81d140
  802960:	e8 f9 16 00 00       	call   80405e <release_uspinlock>
  802965:	83 c4 10             	add    $0x10,%esp
					return (void*)allocblock->startva;
  802968:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80296b:	8b 00                	mov    (%eax),%eax
  80296d:	eb 36                	jmp    8029a5 <smalloc+0x5a5>
				}
				currentfreeelement = currentfreeelement->prev_next_info.le_next;
  80296f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802972:	8b 40 08             	mov    0x8(%eax),%eax
  802975:	89 45 f4             	mov    %eax,-0xc(%ebp)
					 }
		}else{
			//custom fit
			struct UserHeapStruct* currentfreeelement = LIST_FIRST(&u_freelist);
			//worst fit
			while(currentfreeelement != NULL){
  802978:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80297c:	0f 85 47 fc ff ff    	jne    8025c9 <smalloc+0x1c9>
					return (void*)allocblock->startva;
				}
				currentfreeelement = currentfreeelement->prev_next_info.le_next;
			}
		}
		free_block(allocblock);
  802982:	83 ec 0c             	sub    $0xc,%esp
  802985:	ff 75 ec             	pushl  -0x14(%ebp)
  802988:	e8 ad 12 00 00       	call   803c3a <free_block>
  80298d:	83 c4 10             	add    $0x10,%esp
		release_uspinlock(&ulock);
  802990:	83 ec 0c             	sub    $0xc,%esp
  802993:	68 40 d1 81 00       	push   $0x81d140
  802998:	e8 c1 16 00 00       	call   80405e <release_uspinlock>
  80299d:	83 c4 10             	add    $0x10,%esp
		return NULL;
  8029a0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8029a5:	c9                   	leave  
  8029a6:	c3                   	ret    

008029a7 <sget>:

//========================================
// [4] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8029a7:	55                   	push   %ebp
  8029a8:	89 e5                	mov    %esp,%ebp
  8029aa:	83 ec 38             	sub    $0x38,%esp


	 //==============================================================
	 // DON'T CHANGE THIS CODE
	    uheap_init();
  8029ad:	e8 8c ec ff ff       	call   80163e <uheap_init>
	 //==============================================================
	 // Get size of the shared variable from kernel
	acquire_uspinlock(&ulock);
  8029b2:	83 ec 0c             	sub    $0xc,%esp
  8029b5:	68 40 d1 81 00       	push   $0x81d140
  8029ba:	e8 47 16 00 00       	call   804006 <acquire_uspinlock>
  8029bf:	83 c4 10             	add    $0x10,%esp


	int size = sys_size_of_shared_object(ownerEnvID ,sharedVarName);
  8029c2:	83 ec 08             	sub    $0x8,%esp
  8029c5:	ff 75 0c             	pushl  0xc(%ebp)
  8029c8:	ff 75 08             	pushl  0x8(%ebp)
  8029cb:	e8 f6 07 00 00       	call   8031c6 <sys_size_of_shared_object>
  8029d0:	83 c4 10             	add    $0x10,%esp
  8029d3:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if ( size < 0 ){
  8029d6:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8029da:	79 1a                	jns    8029f6 <sget+0x4f>
			release_uspinlock(&ulock);
  8029dc:	83 ec 0c             	sub    $0xc,%esp
  8029df:	68 40 d1 81 00       	push   $0x81d140
  8029e4:	e8 75 16 00 00       	call   80405e <release_uspinlock>
  8029e9:	83 c4 10             	add    $0x10,%esp
			return NULL;
  8029ec:	b8 00 00 00 00       	mov    $0x0,%eax
  8029f1:	e9 6e 05 00 00       	jmp    802f64 <sget+0x5bd>
		}
		size = ROUNDUP(size,PAGE_SIZE);
  8029f6:	c7 45 e8 00 10 00 00 	movl   $0x1000,-0x18(%ebp)
  8029fd:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802a00:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a03:	01 d0                	add    %edx,%eax
  802a05:	48                   	dec    %eax
  802a06:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  802a09:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802a0c:	ba 00 00 00 00       	mov    $0x0,%edx
  802a11:	f7 75 e8             	divl   -0x18(%ebp)
  802a14:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802a17:	29 d0                	sub    %edx,%eax
  802a19:	89 45 ec             	mov    %eax,-0x14(%ebp)

		struct UserHeapStruct* allocblock = (struct UserHeapStruct*) alloc_block(sizeof(struct UserHeapStruct));
  802a1c:	83 ec 0c             	sub    $0xc,%esp
  802a1f:	6a 10                	push   $0x10
  802a21:	e8 78 0d 00 00       	call   80379e <alloc_block>
  802a26:	83 c4 10             	add    $0x10,%esp
  802a29:	89 45 e0             	mov    %eax,-0x20(%ebp)

		if (allocblock == NULL){
  802a2c:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802a30:	75 0a                	jne    802a3c <sget+0x95>
			return NULL;
  802a32:	b8 00 00 00 00       	mov    $0x0,%eax
  802a37:	e9 28 05 00 00       	jmp    802f64 <sget+0x5bd>
		}
		struct UserHeapStruct* lastfreeelement = LIST_LAST(&u_freelist);
  802a3c:	a1 24 d1 81 00       	mov    0x81d124,%eax
  802a41:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if(LIST_SIZE(&u_freelist)==0 || size>lastfreeelement->size){
  802a44:	a1 2c d1 81 00       	mov    0x81d12c,%eax
  802a49:	85 c0                	test   %eax,%eax
  802a4b:	74 11                	je     802a5e <sget+0xb7>
  802a4d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802a50:	8b 50 04             	mov    0x4(%eax),%edx
  802a53:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a56:	39 c2                	cmp    %eax,%edx
  802a58:	0f 83 21 01 00 00    	jae    802b7f <sget+0x1d8>
				if(uheapPageAllocBreak <= USER_HEAP_MAX - size){
  802a5e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a61:	ba 00 00 00 a0       	mov    $0xa0000000,%edx
  802a66:	29 c2                	sub    %eax,%edx
  802a68:	a1 68 d0 81 00       	mov    0x81d068,%eax
  802a6d:	39 c2                	cmp    %eax,%edx
  802a6f:	0f 82 f0 00 00 00    	jb     802b65 <sget+0x1be>

						uint32 requestedblockva = uheapPageAllocBreak;
  802a75:	a1 68 d0 81 00       	mov    0x81d068,%eax
  802a7a:	89 45 d0             	mov    %eax,-0x30(%ebp)
						uheapPageAllocBreak+=size;
  802a7d:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  802a83:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a86:	01 d0                	add    %edx,%eax
  802a88:	a3 68 d0 81 00       	mov    %eax,0x81d068
						allocblock->startva = requestedblockva;
  802a8d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802a90:	8b 55 d0             	mov    -0x30(%ebp),%edx
  802a93:	89 10                	mov    %edx,(%eax)
						allocblock->size = size;
  802a95:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802a98:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802a9b:	89 50 04             	mov    %edx,0x4(%eax)

						LIST_INSERT_TAIL(&u_allocatedlist, allocblock);
  802a9e:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802aa2:	75 17                	jne    802abb <sget+0x114>
  802aa4:	83 ec 04             	sub    $0x4,%esp
  802aa7:	68 d8 4c 80 00       	push   $0x804cd8
  802aac:	68 c8 01 00 00       	push   $0x1c8
  802ab1:	68 8c 4c 80 00       	push   $0x804c8c
  802ab6:	e8 d0 d9 ff ff       	call   80048b <_panic>
  802abb:	8b 15 34 d1 81 00    	mov    0x81d134,%edx
  802ac1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802ac4:	89 50 0c             	mov    %edx,0xc(%eax)
  802ac7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802aca:	8b 40 0c             	mov    0xc(%eax),%eax
  802acd:	85 c0                	test   %eax,%eax
  802acf:	74 0d                	je     802ade <sget+0x137>
  802ad1:	a1 34 d1 81 00       	mov    0x81d134,%eax
  802ad6:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802ad9:	89 50 08             	mov    %edx,0x8(%eax)
  802adc:	eb 08                	jmp    802ae6 <sget+0x13f>
  802ade:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802ae1:	a3 30 d1 81 00       	mov    %eax,0x81d130
  802ae6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802ae9:	a3 34 d1 81 00       	mov    %eax,0x81d134
  802aee:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802af1:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802af8:	a1 3c d1 81 00       	mov    0x81d13c,%eax
  802afd:	40                   	inc    %eax
  802afe:	a3 3c d1 81 00       	mov    %eax,0x81d13c


						int result = sys_get_shared_object(ownerEnvID ,sharedVarName ,(void*)allocblock->startva);
  802b03:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802b06:	8b 00                	mov    (%eax),%eax
  802b08:	83 ec 04             	sub    $0x4,%esp
  802b0b:	50                   	push   %eax
  802b0c:	ff 75 0c             	pushl  0xc(%ebp)
  802b0f:	ff 75 08             	pushl  0x8(%ebp)
  802b12:	e8 cc 06 00 00       	call   8031e3 <sys_get_shared_object>
  802b17:	83 c4 10             	add    $0x10,%esp
  802b1a:	89 45 cc             	mov    %eax,-0x34(%ebp)

						if(result <0){
  802b1d:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802b21:	79 28                	jns    802b4b <sget+0x1a4>
							free_block(allocblock);
  802b23:	83 ec 0c             	sub    $0xc,%esp
  802b26:	ff 75 e0             	pushl  -0x20(%ebp)
  802b29:	e8 0c 11 00 00       	call   803c3a <free_block>
  802b2e:	83 c4 10             	add    $0x10,%esp
							release_uspinlock(&ulock);
  802b31:	83 ec 0c             	sub    $0xc,%esp
  802b34:	68 40 d1 81 00       	push   $0x81d140
  802b39:	e8 20 15 00 00       	call   80405e <release_uspinlock>
  802b3e:	83 c4 10             	add    $0x10,%esp
							return NULL;
  802b41:	b8 00 00 00 00       	mov    $0x0,%eax
  802b46:	e9 19 04 00 00       	jmp    802f64 <sget+0x5bd>
						}
						release_uspinlock(&ulock);
  802b4b:	83 ec 0c             	sub    $0xc,%esp
  802b4e:	68 40 d1 81 00       	push   $0x81d140
  802b53:	e8 06 15 00 00       	call   80405e <release_uspinlock>
  802b58:	83 c4 10             	add    $0x10,%esp
						return (void*)allocblock -> startva;
  802b5b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802b5e:	8b 00                	mov    (%eax),%eax
  802b60:	e9 ff 03 00 00       	jmp    802f64 <sget+0x5bd>
				}else{
						release_uspinlock(&ulock);
  802b65:	83 ec 0c             	sub    $0xc,%esp
  802b68:	68 40 d1 81 00       	push   $0x81d140
  802b6d:	e8 ec 14 00 00       	call   80405e <release_uspinlock>
  802b72:	83 c4 10             	add    $0x10,%esp
						return NULL;
  802b75:	b8 00 00 00 00       	mov    $0x0,%eax
  802b7a:	e9 e5 03 00 00       	jmp    802f64 <sget+0x5bd>
					 }
		}else{
			//custom fit
			struct UserHeapStruct* currentfreeelement = LIST_FIRST(&u_freelist);
  802b7f:	a1 20 d1 81 00       	mov    0x81d120,%eax
  802b84:	89 45 f4             	mov    %eax,-0xc(%ebp)
			//worst fit
			while(currentfreeelement != NULL){
  802b87:	e9 ab 03 00 00       	jmp    802f37 <sget+0x590>
				if(size<currentfreeelement->size){
  802b8c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b8f:	8b 50 04             	mov    0x4(%eax),%edx
  802b92:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b95:	39 c2                	cmp    %eax,%edx
  802b97:	0f 86 24 02 00 00    	jbe    802dc1 <sget+0x41a>
					allocblock->startva = lastfreeelement->startva;
  802b9d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802ba0:	8b 10                	mov    (%eax),%edx
  802ba2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802ba5:	89 10                	mov    %edx,(%eax)
					allocblock->size = size;
  802ba7:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802baa:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802bad:	89 50 04             	mov    %edx,0x4(%eax)
					LIST_INSERT_TAIL(&u_allocatedlist,allocblock);
  802bb0:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802bb4:	75 17                	jne    802bcd <sget+0x226>
  802bb6:	83 ec 04             	sub    $0x4,%esp
  802bb9:	68 d8 4c 80 00       	push   $0x804cd8
  802bbe:	68 e0 01 00 00       	push   $0x1e0
  802bc3:	68 8c 4c 80 00       	push   $0x804c8c
  802bc8:	e8 be d8 ff ff       	call   80048b <_panic>
  802bcd:	8b 15 34 d1 81 00    	mov    0x81d134,%edx
  802bd3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802bd6:	89 50 0c             	mov    %edx,0xc(%eax)
  802bd9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802bdc:	8b 40 0c             	mov    0xc(%eax),%eax
  802bdf:	85 c0                	test   %eax,%eax
  802be1:	74 0d                	je     802bf0 <sget+0x249>
  802be3:	a1 34 d1 81 00       	mov    0x81d134,%eax
  802be8:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802beb:	89 50 08             	mov    %edx,0x8(%eax)
  802bee:	eb 08                	jmp    802bf8 <sget+0x251>
  802bf0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802bf3:	a3 30 d1 81 00       	mov    %eax,0x81d130
  802bf8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802bfb:	a3 34 d1 81 00       	mov    %eax,0x81d134
  802c00:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802c03:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802c0a:	a1 3c d1 81 00       	mov    0x81d13c,%eax
  802c0f:	40                   	inc    %eax
  802c10:	a3 3c d1 81 00       	mov    %eax,0x81d13c
					lastfreeelement->startva += size;
  802c15:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802c18:	8b 10                	mov    (%eax),%edx
  802c1a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c1d:	01 c2                	add    %eax,%edx
  802c1f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802c22:	89 10                	mov    %edx,(%eax)
					lastfreeelement->size -= size;
  802c24:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802c27:	8b 50 04             	mov    0x4(%eax),%edx
  802c2a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c2d:	29 c2                	sub    %eax,%edx
  802c2f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802c32:	89 50 04             	mov    %edx,0x4(%eax)
					struct UserHeapStruct* currentfree2 = LIST_FIRST(&u_freelist);
  802c35:	a1 20 d1 81 00       	mov    0x81d120,%eax
  802c3a:	89 45 f0             	mov    %eax,-0x10(%ebp)
					//check order of last element

					while (currentfree2 != NULL){
  802c3d:	e9 13 01 00 00       	jmp    802d55 <sget+0x3ae>
						if(lastfreeelement->size <currentfree2->size){
  802c42:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802c45:	8b 50 04             	mov    0x4(%eax),%edx
  802c48:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c4b:	8b 40 04             	mov    0x4(%eax),%eax
  802c4e:	39 c2                	cmp    %eax,%edx
  802c50:	0f 83 f6 00 00 00    	jae    802d4c <sget+0x3a5>
							LIST_REMOVE(&u_freelist ,lastfreeelement);
  802c56:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802c5a:	75 17                	jne    802c73 <sget+0x2cc>
  802c5c:	83 ec 04             	sub    $0x4,%esp
  802c5f:	68 fb 4c 80 00       	push   $0x804cfb
  802c64:	68 e8 01 00 00       	push   $0x1e8
  802c69:	68 8c 4c 80 00       	push   $0x804c8c
  802c6e:	e8 18 d8 ff ff       	call   80048b <_panic>
  802c73:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802c76:	8b 40 08             	mov    0x8(%eax),%eax
  802c79:	85 c0                	test   %eax,%eax
  802c7b:	74 11                	je     802c8e <sget+0x2e7>
  802c7d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802c80:	8b 40 08             	mov    0x8(%eax),%eax
  802c83:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802c86:	8b 52 0c             	mov    0xc(%edx),%edx
  802c89:	89 50 0c             	mov    %edx,0xc(%eax)
  802c8c:	eb 0b                	jmp    802c99 <sget+0x2f2>
  802c8e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802c91:	8b 40 0c             	mov    0xc(%eax),%eax
  802c94:	a3 24 d1 81 00       	mov    %eax,0x81d124
  802c99:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802c9c:	8b 40 0c             	mov    0xc(%eax),%eax
  802c9f:	85 c0                	test   %eax,%eax
  802ca1:	74 11                	je     802cb4 <sget+0x30d>
  802ca3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802ca6:	8b 40 0c             	mov    0xc(%eax),%eax
  802ca9:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802cac:	8b 52 08             	mov    0x8(%edx),%edx
  802caf:	89 50 08             	mov    %edx,0x8(%eax)
  802cb2:	eb 0b                	jmp    802cbf <sget+0x318>
  802cb4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802cb7:	8b 40 08             	mov    0x8(%eax),%eax
  802cba:	a3 20 d1 81 00       	mov    %eax,0x81d120
  802cbf:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802cc2:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802cc9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802ccc:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  802cd3:	a1 2c d1 81 00       	mov    0x81d12c,%eax
  802cd8:	48                   	dec    %eax
  802cd9:	a3 2c d1 81 00       	mov    %eax,0x81d12c
							LIST_INSERT_BEFORE(&u_freelist ,currentfree2 ,lastfreeelement);
  802cde:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802ce2:	74 06                	je     802cea <sget+0x343>
  802ce4:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802ce8:	75 17                	jne    802d01 <sget+0x35a>
  802cea:	83 ec 04             	sub    $0x4,%esp
  802ced:	68 1c 4d 80 00       	push   $0x804d1c
  802cf2:	68 e9 01 00 00       	push   $0x1e9
  802cf7:	68 8c 4c 80 00       	push   $0x804c8c
  802cfc:	e8 8a d7 ff ff       	call   80048b <_panic>
  802d01:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d04:	8b 50 0c             	mov    0xc(%eax),%edx
  802d07:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802d0a:	89 50 0c             	mov    %edx,0xc(%eax)
  802d0d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802d10:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802d13:	89 50 08             	mov    %edx,0x8(%eax)
  802d16:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d19:	8b 40 0c             	mov    0xc(%eax),%eax
  802d1c:	85 c0                	test   %eax,%eax
  802d1e:	74 0e                	je     802d2e <sget+0x387>
  802d20:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d23:	8b 40 0c             	mov    0xc(%eax),%eax
  802d26:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802d29:	89 50 08             	mov    %edx,0x8(%eax)
  802d2c:	eb 08                	jmp    802d36 <sget+0x38f>
  802d2e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802d31:	a3 20 d1 81 00       	mov    %eax,0x81d120
  802d36:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d39:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802d3c:	89 50 0c             	mov    %edx,0xc(%eax)
  802d3f:	a1 2c d1 81 00       	mov    0x81d12c,%eax
  802d44:	40                   	inc    %eax
  802d45:	a3 2c d1 81 00       	mov    %eax,0x81d12c
							break;
  802d4a:	eb 13                	jmp    802d5f <sget+0x3b8>
						}
						currentfree2 = currentfree2->prev_next_info.le_next;
  802d4c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d4f:	8b 40 08             	mov    0x8(%eax),%eax
  802d52:	89 45 f0             	mov    %eax,-0x10(%ebp)
					lastfreeelement->startva += size;
					lastfreeelement->size -= size;
					struct UserHeapStruct* currentfree2 = LIST_FIRST(&u_freelist);
					//check order of last element

					while (currentfree2 != NULL){
  802d55:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802d59:	0f 85 e3 fe ff ff    	jne    802c42 <sget+0x29b>
						}
						currentfree2 = currentfree2->prev_next_info.le_next;
					}


					int result = sys_get_shared_object(ownerEnvID ,sharedVarName ,(void*)allocblock->startva);
  802d5f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802d62:	8b 00                	mov    (%eax),%eax
  802d64:	83 ec 04             	sub    $0x4,%esp
  802d67:	50                   	push   %eax
  802d68:	ff 75 0c             	pushl  0xc(%ebp)
  802d6b:	ff 75 08             	pushl  0x8(%ebp)
  802d6e:	e8 70 04 00 00       	call   8031e3 <sys_get_shared_object>
  802d73:	83 c4 10             	add    $0x10,%esp
  802d76:	89 45 d4             	mov    %eax,-0x2c(%ebp)

					if(result <0){
  802d79:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  802d7d:	79 28                	jns    802da7 <sget+0x400>
						free_block(allocblock);
  802d7f:	83 ec 0c             	sub    $0xc,%esp
  802d82:	ff 75 e0             	pushl  -0x20(%ebp)
  802d85:	e8 b0 0e 00 00       	call   803c3a <free_block>
  802d8a:	83 c4 10             	add    $0x10,%esp
						release_uspinlock(&ulock);
  802d8d:	83 ec 0c             	sub    $0xc,%esp
  802d90:	68 40 d1 81 00       	push   $0x81d140
  802d95:	e8 c4 12 00 00       	call   80405e <release_uspinlock>
  802d9a:	83 c4 10             	add    $0x10,%esp
						return NULL;
  802d9d:	b8 00 00 00 00       	mov    $0x0,%eax
  802da2:	e9 bd 01 00 00       	jmp    802f64 <sget+0x5bd>
					}
					release_uspinlock(&ulock);
  802da7:	83 ec 0c             	sub    $0xc,%esp
  802daa:	68 40 d1 81 00       	push   $0x81d140
  802daf:	e8 aa 12 00 00       	call   80405e <release_uspinlock>
  802db4:	83 c4 10             	add    $0x10,%esp
					return (void*)allocblock->startva;
  802db7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802dba:	8b 00                	mov    (%eax),%eax
  802dbc:	e9 a3 01 00 00       	jmp    802f64 <sget+0x5bd>
					//exact fit
				}else if(size == currentfreeelement->size){
  802dc1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dc4:	8b 50 04             	mov    0x4(%eax),%edx
  802dc7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802dca:	39 c2                	cmp    %eax,%edx
  802dcc:	0f 85 5c 01 00 00    	jne    802f2e <sget+0x587>

					allocblock->startva = currentfreeelement->startva;
  802dd2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dd5:	8b 10                	mov    (%eax),%edx
  802dd7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802dda:	89 10                	mov    %edx,(%eax)
					allocblock->size = size;
  802ddc:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802ddf:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802de2:	89 50 04             	mov    %edx,0x4(%eax)
					LIST_INSERT_TAIL(&u_allocatedlist ,allocblock);
  802de5:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802de9:	75 17                	jne    802e02 <sget+0x45b>
  802deb:	83 ec 04             	sub    $0x4,%esp
  802dee:	68 d8 4c 80 00       	push   $0x804cd8
  802df3:	68 fe 01 00 00       	push   $0x1fe
  802df8:	68 8c 4c 80 00       	push   $0x804c8c
  802dfd:	e8 89 d6 ff ff       	call   80048b <_panic>
  802e02:	8b 15 34 d1 81 00    	mov    0x81d134,%edx
  802e08:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802e0b:	89 50 0c             	mov    %edx,0xc(%eax)
  802e0e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802e11:	8b 40 0c             	mov    0xc(%eax),%eax
  802e14:	85 c0                	test   %eax,%eax
  802e16:	74 0d                	je     802e25 <sget+0x47e>
  802e18:	a1 34 d1 81 00       	mov    0x81d134,%eax
  802e1d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802e20:	89 50 08             	mov    %edx,0x8(%eax)
  802e23:	eb 08                	jmp    802e2d <sget+0x486>
  802e25:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802e28:	a3 30 d1 81 00       	mov    %eax,0x81d130
  802e2d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802e30:	a3 34 d1 81 00       	mov    %eax,0x81d134
  802e35:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802e38:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802e3f:	a1 3c d1 81 00       	mov    0x81d13c,%eax
  802e44:	40                   	inc    %eax
  802e45:	a3 3c d1 81 00       	mov    %eax,0x81d13c
					LIST_REMOVE(&u_freelist ,currentfreeelement);
  802e4a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e4e:	75 17                	jne    802e67 <sget+0x4c0>
  802e50:	83 ec 04             	sub    $0x4,%esp
  802e53:	68 fb 4c 80 00       	push   $0x804cfb
  802e58:	68 ff 01 00 00       	push   $0x1ff
  802e5d:	68 8c 4c 80 00       	push   $0x804c8c
  802e62:	e8 24 d6 ff ff       	call   80048b <_panic>
  802e67:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e6a:	8b 40 08             	mov    0x8(%eax),%eax
  802e6d:	85 c0                	test   %eax,%eax
  802e6f:	74 11                	je     802e82 <sget+0x4db>
  802e71:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e74:	8b 40 08             	mov    0x8(%eax),%eax
  802e77:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e7a:	8b 52 0c             	mov    0xc(%edx),%edx
  802e7d:	89 50 0c             	mov    %edx,0xc(%eax)
  802e80:	eb 0b                	jmp    802e8d <sget+0x4e6>
  802e82:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e85:	8b 40 0c             	mov    0xc(%eax),%eax
  802e88:	a3 24 d1 81 00       	mov    %eax,0x81d124
  802e8d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e90:	8b 40 0c             	mov    0xc(%eax),%eax
  802e93:	85 c0                	test   %eax,%eax
  802e95:	74 11                	je     802ea8 <sget+0x501>
  802e97:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e9a:	8b 40 0c             	mov    0xc(%eax),%eax
  802e9d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ea0:	8b 52 08             	mov    0x8(%edx),%edx
  802ea3:	89 50 08             	mov    %edx,0x8(%eax)
  802ea6:	eb 0b                	jmp    802eb3 <sget+0x50c>
  802ea8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eab:	8b 40 08             	mov    0x8(%eax),%eax
  802eae:	a3 20 d1 81 00       	mov    %eax,0x81d120
  802eb3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eb6:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802ebd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ec0:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  802ec7:	a1 2c d1 81 00       	mov    0x81d12c,%eax
  802ecc:	48                   	dec    %eax
  802ecd:	a3 2c d1 81 00       	mov    %eax,0x81d12c

					int result = sys_get_shared_object(ownerEnvID ,sharedVarName ,(void*)allocblock->startva);
  802ed2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802ed5:	8b 00                	mov    (%eax),%eax
  802ed7:	83 ec 04             	sub    $0x4,%esp
  802eda:	50                   	push   %eax
  802edb:	ff 75 0c             	pushl  0xc(%ebp)
  802ede:	ff 75 08             	pushl  0x8(%ebp)
  802ee1:	e8 fd 02 00 00       	call   8031e3 <sys_get_shared_object>
  802ee6:	83 c4 10             	add    $0x10,%esp
  802ee9:	89 45 d8             	mov    %eax,-0x28(%ebp)
					if(result <0){
  802eec:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  802ef0:	79 25                	jns    802f17 <sget+0x570>
						free_block(allocblock);
  802ef2:	83 ec 0c             	sub    $0xc,%esp
  802ef5:	ff 75 e0             	pushl  -0x20(%ebp)
  802ef8:	e8 3d 0d 00 00       	call   803c3a <free_block>
  802efd:	83 c4 10             	add    $0x10,%esp
						release_uspinlock(&ulock);
  802f00:	83 ec 0c             	sub    $0xc,%esp
  802f03:	68 40 d1 81 00       	push   $0x81d140
  802f08:	e8 51 11 00 00       	call   80405e <release_uspinlock>
  802f0d:	83 c4 10             	add    $0x10,%esp
						return NULL;
  802f10:	b8 00 00 00 00       	mov    $0x0,%eax
  802f15:	eb 4d                	jmp    802f64 <sget+0x5bd>
					}

					release_uspinlock(&ulock);
  802f17:	83 ec 0c             	sub    $0xc,%esp
  802f1a:	68 40 d1 81 00       	push   $0x81d140
  802f1f:	e8 3a 11 00 00       	call   80405e <release_uspinlock>
  802f24:	83 c4 10             	add    $0x10,%esp
					return (void*)allocblock->startva;
  802f27:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802f2a:	8b 00                	mov    (%eax),%eax
  802f2c:	eb 36                	jmp    802f64 <sget+0x5bd>
				}
				currentfreeelement = currentfreeelement->prev_next_info.le_next;
  802f2e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f31:	8b 40 08             	mov    0x8(%eax),%eax
  802f34:	89 45 f4             	mov    %eax,-0xc(%ebp)
					 }
		}else{
			//custom fit
			struct UserHeapStruct* currentfreeelement = LIST_FIRST(&u_freelist);
			//worst fit
			while(currentfreeelement != NULL){
  802f37:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f3b:	0f 85 4b fc ff ff    	jne    802b8c <sget+0x1e5>
					return (void*)allocblock->startva;
				}
				currentfreeelement = currentfreeelement->prev_next_info.le_next;
			}
		}
		free_block(allocblock);
  802f41:	83 ec 0c             	sub    $0xc,%esp
  802f44:	ff 75 e0             	pushl  -0x20(%ebp)
  802f47:	e8 ee 0c 00 00       	call   803c3a <free_block>
  802f4c:	83 c4 10             	add    $0x10,%esp
		release_uspinlock(&ulock);
  802f4f:	83 ec 0c             	sub    $0xc,%esp
  802f52:	68 40 d1 81 00       	push   $0x81d140
  802f57:	e8 02 11 00 00       	call   80405e <release_uspinlock>
  802f5c:	83 c4 10             	add    $0x10,%esp
		return NULL;
  802f5f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802f64:	c9                   	leave  
  802f65:	c3                   	ret    

00802f66 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  802f66:	55                   	push   %ebp
  802f67:	89 e5                	mov    %esp,%ebp
  802f69:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  802f6c:	e8 cd e6 ff ff       	call   80163e <uheap_init>
	//==============================================================
	panic("realloc() is not implemented yet...!!");
  802f71:	83 ec 04             	sub    $0x4,%esp
  802f74:	68 ac 4d 80 00       	push   $0x804dac
  802f79:	68 2d 02 00 00       	push   $0x22d
  802f7e:	68 8c 4c 80 00       	push   $0x804c8c
  802f83:	e8 03 d5 ff ff       	call   80048b <_panic>

00802f88 <sfree>:
//
//	use sys_delete_shared_object(...); which switches to the kernel mode,
//	calls delete_shared_object(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the delete_shared_object() function is empty, make sure to implement it.
void sfree(void* virtual_address)
{
  802f88:	55                   	push   %ebp
  802f89:	89 e5                	mov    %esp,%ebp
  802f8b:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.BONUS#5] EXIT #2 - sfree
	//Your code is here
	//Comment the following line
	panic("sfree() is not implemented yet...!!");
  802f8e:	83 ec 04             	sub    $0x4,%esp
  802f91:	68 d4 4d 80 00       	push   $0x804dd4
  802f96:	68 40 02 00 00       	push   $0x240
  802f9b:	68 8c 4c 80 00       	push   $0x804c8c
  802fa0:	e8 e6 d4 ff ff       	call   80048b <_panic>

00802fa5 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  802fa5:	55                   	push   %ebp
  802fa6:	89 e5                	mov    %esp,%ebp
  802fa8:	57                   	push   %edi
  802fa9:	56                   	push   %esi
  802faa:	53                   	push   %ebx
  802fab:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  802fae:	8b 45 08             	mov    0x8(%ebp),%eax
  802fb1:	8b 55 0c             	mov    0xc(%ebp),%edx
  802fb4:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802fb7:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802fba:	8b 7d 18             	mov    0x18(%ebp),%edi
  802fbd:	8b 75 1c             	mov    0x1c(%ebp),%esi
  802fc0:	cd 30                	int    $0x30
  802fc2:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  802fc5:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  802fc8:	83 c4 10             	add    $0x10,%esp
  802fcb:	5b                   	pop    %ebx
  802fcc:	5e                   	pop    %esi
  802fcd:	5f                   	pop    %edi
  802fce:	5d                   	pop    %ebp
  802fcf:	c3                   	ret    

00802fd0 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  802fd0:	55                   	push   %ebp
  802fd1:	89 e5                	mov    %esp,%ebp
  802fd3:	83 ec 04             	sub    $0x4,%esp
  802fd6:	8b 45 10             	mov    0x10(%ebp),%eax
  802fd9:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  802fdc:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802fdf:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802fe3:	8b 45 08             	mov    0x8(%ebp),%eax
  802fe6:	6a 00                	push   $0x0
  802fe8:	51                   	push   %ecx
  802fe9:	52                   	push   %edx
  802fea:	ff 75 0c             	pushl  0xc(%ebp)
  802fed:	50                   	push   %eax
  802fee:	6a 00                	push   $0x0
  802ff0:	e8 b0 ff ff ff       	call   802fa5 <syscall>
  802ff5:	83 c4 18             	add    $0x18,%esp
}
  802ff8:	90                   	nop
  802ff9:	c9                   	leave  
  802ffa:	c3                   	ret    

00802ffb <sys_cgetc>:

int
sys_cgetc(void)
{
  802ffb:	55                   	push   %ebp
  802ffc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  802ffe:	6a 00                	push   $0x0
  803000:	6a 00                	push   $0x0
  803002:	6a 00                	push   $0x0
  803004:	6a 00                	push   $0x0
  803006:	6a 00                	push   $0x0
  803008:	6a 02                	push   $0x2
  80300a:	e8 96 ff ff ff       	call   802fa5 <syscall>
  80300f:	83 c4 18             	add    $0x18,%esp
}
  803012:	c9                   	leave  
  803013:	c3                   	ret    

00803014 <sys_lock_cons>:

void sys_lock_cons(void)
{
  803014:	55                   	push   %ebp
  803015:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  803017:	6a 00                	push   $0x0
  803019:	6a 00                	push   $0x0
  80301b:	6a 00                	push   $0x0
  80301d:	6a 00                	push   $0x0
  80301f:	6a 00                	push   $0x0
  803021:	6a 03                	push   $0x3
  803023:	e8 7d ff ff ff       	call   802fa5 <syscall>
  803028:	83 c4 18             	add    $0x18,%esp
}
  80302b:	90                   	nop
  80302c:	c9                   	leave  
  80302d:	c3                   	ret    

0080302e <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  80302e:	55                   	push   %ebp
  80302f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  803031:	6a 00                	push   $0x0
  803033:	6a 00                	push   $0x0
  803035:	6a 00                	push   $0x0
  803037:	6a 00                	push   $0x0
  803039:	6a 00                	push   $0x0
  80303b:	6a 04                	push   $0x4
  80303d:	e8 63 ff ff ff       	call   802fa5 <syscall>
  803042:	83 c4 18             	add    $0x18,%esp
}
  803045:	90                   	nop
  803046:	c9                   	leave  
  803047:	c3                   	ret    

00803048 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  803048:	55                   	push   %ebp
  803049:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  80304b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80304e:	8b 45 08             	mov    0x8(%ebp),%eax
  803051:	6a 00                	push   $0x0
  803053:	6a 00                	push   $0x0
  803055:	6a 00                	push   $0x0
  803057:	52                   	push   %edx
  803058:	50                   	push   %eax
  803059:	6a 08                	push   $0x8
  80305b:	e8 45 ff ff ff       	call   802fa5 <syscall>
  803060:	83 c4 18             	add    $0x18,%esp
}
  803063:	c9                   	leave  
  803064:	c3                   	ret    

00803065 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  803065:	55                   	push   %ebp
  803066:	89 e5                	mov    %esp,%ebp
  803068:	56                   	push   %esi
  803069:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  80306a:	8b 75 18             	mov    0x18(%ebp),%esi
  80306d:	8b 5d 14             	mov    0x14(%ebp),%ebx
  803070:	8b 4d 10             	mov    0x10(%ebp),%ecx
  803073:	8b 55 0c             	mov    0xc(%ebp),%edx
  803076:	8b 45 08             	mov    0x8(%ebp),%eax
  803079:	56                   	push   %esi
  80307a:	53                   	push   %ebx
  80307b:	51                   	push   %ecx
  80307c:	52                   	push   %edx
  80307d:	50                   	push   %eax
  80307e:	6a 09                	push   $0x9
  803080:	e8 20 ff ff ff       	call   802fa5 <syscall>
  803085:	83 c4 18             	add    $0x18,%esp
}
  803088:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80308b:	5b                   	pop    %ebx
  80308c:	5e                   	pop    %esi
  80308d:	5d                   	pop    %ebp
  80308e:	c3                   	ret    

0080308f <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  80308f:	55                   	push   %ebp
  803090:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  803092:	6a 00                	push   $0x0
  803094:	6a 00                	push   $0x0
  803096:	6a 00                	push   $0x0
  803098:	6a 00                	push   $0x0
  80309a:	ff 75 08             	pushl  0x8(%ebp)
  80309d:	6a 0a                	push   $0xa
  80309f:	e8 01 ff ff ff       	call   802fa5 <syscall>
  8030a4:	83 c4 18             	add    $0x18,%esp
}
  8030a7:	c9                   	leave  
  8030a8:	c3                   	ret    

008030a9 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8030a9:	55                   	push   %ebp
  8030aa:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8030ac:	6a 00                	push   $0x0
  8030ae:	6a 00                	push   $0x0
  8030b0:	6a 00                	push   $0x0
  8030b2:	ff 75 0c             	pushl  0xc(%ebp)
  8030b5:	ff 75 08             	pushl  0x8(%ebp)
  8030b8:	6a 0b                	push   $0xb
  8030ba:	e8 e6 fe ff ff       	call   802fa5 <syscall>
  8030bf:	83 c4 18             	add    $0x18,%esp
}
  8030c2:	c9                   	leave  
  8030c3:	c3                   	ret    

008030c4 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8030c4:	55                   	push   %ebp
  8030c5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8030c7:	6a 00                	push   $0x0
  8030c9:	6a 00                	push   $0x0
  8030cb:	6a 00                	push   $0x0
  8030cd:	6a 00                	push   $0x0
  8030cf:	6a 00                	push   $0x0
  8030d1:	6a 0c                	push   $0xc
  8030d3:	e8 cd fe ff ff       	call   802fa5 <syscall>
  8030d8:	83 c4 18             	add    $0x18,%esp
}
  8030db:	c9                   	leave  
  8030dc:	c3                   	ret    

008030dd <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8030dd:	55                   	push   %ebp
  8030de:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8030e0:	6a 00                	push   $0x0
  8030e2:	6a 00                	push   $0x0
  8030e4:	6a 00                	push   $0x0
  8030e6:	6a 00                	push   $0x0
  8030e8:	6a 00                	push   $0x0
  8030ea:	6a 0d                	push   $0xd
  8030ec:	e8 b4 fe ff ff       	call   802fa5 <syscall>
  8030f1:	83 c4 18             	add    $0x18,%esp
}
  8030f4:	c9                   	leave  
  8030f5:	c3                   	ret    

008030f6 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8030f6:	55                   	push   %ebp
  8030f7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8030f9:	6a 00                	push   $0x0
  8030fb:	6a 00                	push   $0x0
  8030fd:	6a 00                	push   $0x0
  8030ff:	6a 00                	push   $0x0
  803101:	6a 00                	push   $0x0
  803103:	6a 0e                	push   $0xe
  803105:	e8 9b fe ff ff       	call   802fa5 <syscall>
  80310a:	83 c4 18             	add    $0x18,%esp
}
  80310d:	c9                   	leave  
  80310e:	c3                   	ret    

0080310f <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  80310f:	55                   	push   %ebp
  803110:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  803112:	6a 00                	push   $0x0
  803114:	6a 00                	push   $0x0
  803116:	6a 00                	push   $0x0
  803118:	6a 00                	push   $0x0
  80311a:	6a 00                	push   $0x0
  80311c:	6a 0f                	push   $0xf
  80311e:	e8 82 fe ff ff       	call   802fa5 <syscall>
  803123:	83 c4 18             	add    $0x18,%esp
}
  803126:	c9                   	leave  
  803127:	c3                   	ret    

00803128 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  803128:	55                   	push   %ebp
  803129:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  80312b:	6a 00                	push   $0x0
  80312d:	6a 00                	push   $0x0
  80312f:	6a 00                	push   $0x0
  803131:	6a 00                	push   $0x0
  803133:	ff 75 08             	pushl  0x8(%ebp)
  803136:	6a 10                	push   $0x10
  803138:	e8 68 fe ff ff       	call   802fa5 <syscall>
  80313d:	83 c4 18             	add    $0x18,%esp
}
  803140:	c9                   	leave  
  803141:	c3                   	ret    

00803142 <sys_scarce_memory>:

void sys_scarce_memory()
{
  803142:	55                   	push   %ebp
  803143:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  803145:	6a 00                	push   $0x0
  803147:	6a 00                	push   $0x0
  803149:	6a 00                	push   $0x0
  80314b:	6a 00                	push   $0x0
  80314d:	6a 00                	push   $0x0
  80314f:	6a 11                	push   $0x11
  803151:	e8 4f fe ff ff       	call   802fa5 <syscall>
  803156:	83 c4 18             	add    $0x18,%esp
}
  803159:	90                   	nop
  80315a:	c9                   	leave  
  80315b:	c3                   	ret    

0080315c <sys_cputc>:

void
sys_cputc(const char c)
{
  80315c:	55                   	push   %ebp
  80315d:	89 e5                	mov    %esp,%ebp
  80315f:	83 ec 04             	sub    $0x4,%esp
  803162:	8b 45 08             	mov    0x8(%ebp),%eax
  803165:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  803168:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80316c:	6a 00                	push   $0x0
  80316e:	6a 00                	push   $0x0
  803170:	6a 00                	push   $0x0
  803172:	6a 00                	push   $0x0
  803174:	50                   	push   %eax
  803175:	6a 01                	push   $0x1
  803177:	e8 29 fe ff ff       	call   802fa5 <syscall>
  80317c:	83 c4 18             	add    $0x18,%esp
}
  80317f:	90                   	nop
  803180:	c9                   	leave  
  803181:	c3                   	ret    

00803182 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  803182:	55                   	push   %ebp
  803183:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  803185:	6a 00                	push   $0x0
  803187:	6a 00                	push   $0x0
  803189:	6a 00                	push   $0x0
  80318b:	6a 00                	push   $0x0
  80318d:	6a 00                	push   $0x0
  80318f:	6a 14                	push   $0x14
  803191:	e8 0f fe ff ff       	call   802fa5 <syscall>
  803196:	83 c4 18             	add    $0x18,%esp
}
  803199:	90                   	nop
  80319a:	c9                   	leave  
  80319b:	c3                   	ret    

0080319c <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  80319c:	55                   	push   %ebp
  80319d:	89 e5                	mov    %esp,%ebp
  80319f:	83 ec 04             	sub    $0x4,%esp
  8031a2:	8b 45 10             	mov    0x10(%ebp),%eax
  8031a5:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8031a8:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8031ab:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8031af:	8b 45 08             	mov    0x8(%ebp),%eax
  8031b2:	6a 00                	push   $0x0
  8031b4:	51                   	push   %ecx
  8031b5:	52                   	push   %edx
  8031b6:	ff 75 0c             	pushl  0xc(%ebp)
  8031b9:	50                   	push   %eax
  8031ba:	6a 15                	push   $0x15
  8031bc:	e8 e4 fd ff ff       	call   802fa5 <syscall>
  8031c1:	83 c4 18             	add    $0x18,%esp
}
  8031c4:	c9                   	leave  
  8031c5:	c3                   	ret    

008031c6 <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  8031c6:	55                   	push   %ebp
  8031c7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8031c9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8031cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8031cf:	6a 00                	push   $0x0
  8031d1:	6a 00                	push   $0x0
  8031d3:	6a 00                	push   $0x0
  8031d5:	52                   	push   %edx
  8031d6:	50                   	push   %eax
  8031d7:	6a 16                	push   $0x16
  8031d9:	e8 c7 fd ff ff       	call   802fa5 <syscall>
  8031de:	83 c4 18             	add    $0x18,%esp
}
  8031e1:	c9                   	leave  
  8031e2:	c3                   	ret    

008031e3 <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  8031e3:	55                   	push   %ebp
  8031e4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8031e6:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8031e9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8031ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8031ef:	6a 00                	push   $0x0
  8031f1:	6a 00                	push   $0x0
  8031f3:	51                   	push   %ecx
  8031f4:	52                   	push   %edx
  8031f5:	50                   	push   %eax
  8031f6:	6a 17                	push   $0x17
  8031f8:	e8 a8 fd ff ff       	call   802fa5 <syscall>
  8031fd:	83 c4 18             	add    $0x18,%esp
}
  803200:	c9                   	leave  
  803201:	c3                   	ret    

00803202 <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  803202:	55                   	push   %ebp
  803203:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  803205:	8b 55 0c             	mov    0xc(%ebp),%edx
  803208:	8b 45 08             	mov    0x8(%ebp),%eax
  80320b:	6a 00                	push   $0x0
  80320d:	6a 00                	push   $0x0
  80320f:	6a 00                	push   $0x0
  803211:	52                   	push   %edx
  803212:	50                   	push   %eax
  803213:	6a 18                	push   $0x18
  803215:	e8 8b fd ff ff       	call   802fa5 <syscall>
  80321a:	83 c4 18             	add    $0x18,%esp
}
  80321d:	c9                   	leave  
  80321e:	c3                   	ret    

0080321f <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  80321f:	55                   	push   %ebp
  803220:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  803222:	8b 45 08             	mov    0x8(%ebp),%eax
  803225:	6a 00                	push   $0x0
  803227:	ff 75 14             	pushl  0x14(%ebp)
  80322a:	ff 75 10             	pushl  0x10(%ebp)
  80322d:	ff 75 0c             	pushl  0xc(%ebp)
  803230:	50                   	push   %eax
  803231:	6a 19                	push   $0x19
  803233:	e8 6d fd ff ff       	call   802fa5 <syscall>
  803238:	83 c4 18             	add    $0x18,%esp
}
  80323b:	c9                   	leave  
  80323c:	c3                   	ret    

0080323d <sys_run_env>:

void sys_run_env(int32 envId)
{
  80323d:	55                   	push   %ebp
  80323e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  803240:	8b 45 08             	mov    0x8(%ebp),%eax
  803243:	6a 00                	push   $0x0
  803245:	6a 00                	push   $0x0
  803247:	6a 00                	push   $0x0
  803249:	6a 00                	push   $0x0
  80324b:	50                   	push   %eax
  80324c:	6a 1a                	push   $0x1a
  80324e:	e8 52 fd ff ff       	call   802fa5 <syscall>
  803253:	83 c4 18             	add    $0x18,%esp
}
  803256:	90                   	nop
  803257:	c9                   	leave  
  803258:	c3                   	ret    

00803259 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  803259:	55                   	push   %ebp
  80325a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  80325c:	8b 45 08             	mov    0x8(%ebp),%eax
  80325f:	6a 00                	push   $0x0
  803261:	6a 00                	push   $0x0
  803263:	6a 00                	push   $0x0
  803265:	6a 00                	push   $0x0
  803267:	50                   	push   %eax
  803268:	6a 1b                	push   $0x1b
  80326a:	e8 36 fd ff ff       	call   802fa5 <syscall>
  80326f:	83 c4 18             	add    $0x18,%esp
}
  803272:	c9                   	leave  
  803273:	c3                   	ret    

00803274 <sys_getenvid>:

int32 sys_getenvid(void)
{
  803274:	55                   	push   %ebp
  803275:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  803277:	6a 00                	push   $0x0
  803279:	6a 00                	push   $0x0
  80327b:	6a 00                	push   $0x0
  80327d:	6a 00                	push   $0x0
  80327f:	6a 00                	push   $0x0
  803281:	6a 05                	push   $0x5
  803283:	e8 1d fd ff ff       	call   802fa5 <syscall>
  803288:	83 c4 18             	add    $0x18,%esp
}
  80328b:	c9                   	leave  
  80328c:	c3                   	ret    

0080328d <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  80328d:	55                   	push   %ebp
  80328e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  803290:	6a 00                	push   $0x0
  803292:	6a 00                	push   $0x0
  803294:	6a 00                	push   $0x0
  803296:	6a 00                	push   $0x0
  803298:	6a 00                	push   $0x0
  80329a:	6a 06                	push   $0x6
  80329c:	e8 04 fd ff ff       	call   802fa5 <syscall>
  8032a1:	83 c4 18             	add    $0x18,%esp
}
  8032a4:	c9                   	leave  
  8032a5:	c3                   	ret    

008032a6 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8032a6:	55                   	push   %ebp
  8032a7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8032a9:	6a 00                	push   $0x0
  8032ab:	6a 00                	push   $0x0
  8032ad:	6a 00                	push   $0x0
  8032af:	6a 00                	push   $0x0
  8032b1:	6a 00                	push   $0x0
  8032b3:	6a 07                	push   $0x7
  8032b5:	e8 eb fc ff ff       	call   802fa5 <syscall>
  8032ba:	83 c4 18             	add    $0x18,%esp
}
  8032bd:	c9                   	leave  
  8032be:	c3                   	ret    

008032bf <sys_exit_env>:


void sys_exit_env(void)
{
  8032bf:	55                   	push   %ebp
  8032c0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  8032c2:	6a 00                	push   $0x0
  8032c4:	6a 00                	push   $0x0
  8032c6:	6a 00                	push   $0x0
  8032c8:	6a 00                	push   $0x0
  8032ca:	6a 00                	push   $0x0
  8032cc:	6a 1c                	push   $0x1c
  8032ce:	e8 d2 fc ff ff       	call   802fa5 <syscall>
  8032d3:	83 c4 18             	add    $0x18,%esp
}
  8032d6:	90                   	nop
  8032d7:	c9                   	leave  
  8032d8:	c3                   	ret    

008032d9 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  8032d9:	55                   	push   %ebp
  8032da:	89 e5                	mov    %esp,%ebp
  8032dc:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8032df:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8032e2:	8d 50 04             	lea    0x4(%eax),%edx
  8032e5:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8032e8:	6a 00                	push   $0x0
  8032ea:	6a 00                	push   $0x0
  8032ec:	6a 00                	push   $0x0
  8032ee:	52                   	push   %edx
  8032ef:	50                   	push   %eax
  8032f0:	6a 1d                	push   $0x1d
  8032f2:	e8 ae fc ff ff       	call   802fa5 <syscall>
  8032f7:	83 c4 18             	add    $0x18,%esp
	return result;
  8032fa:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8032fd:	8b 45 f8             	mov    -0x8(%ebp),%eax
  803300:	8b 55 fc             	mov    -0x4(%ebp),%edx
  803303:	89 01                	mov    %eax,(%ecx)
  803305:	89 51 04             	mov    %edx,0x4(%ecx)
}
  803308:	8b 45 08             	mov    0x8(%ebp),%eax
  80330b:	c9                   	leave  
  80330c:	c2 04 00             	ret    $0x4

0080330f <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  80330f:	55                   	push   %ebp
  803310:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  803312:	6a 00                	push   $0x0
  803314:	6a 00                	push   $0x0
  803316:	ff 75 10             	pushl  0x10(%ebp)
  803319:	ff 75 0c             	pushl  0xc(%ebp)
  80331c:	ff 75 08             	pushl  0x8(%ebp)
  80331f:	6a 13                	push   $0x13
  803321:	e8 7f fc ff ff       	call   802fa5 <syscall>
  803326:	83 c4 18             	add    $0x18,%esp
	return ;
  803329:	90                   	nop
}
  80332a:	c9                   	leave  
  80332b:	c3                   	ret    

0080332c <sys_rcr2>:
uint32 sys_rcr2()
{
  80332c:	55                   	push   %ebp
  80332d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  80332f:	6a 00                	push   $0x0
  803331:	6a 00                	push   $0x0
  803333:	6a 00                	push   $0x0
  803335:	6a 00                	push   $0x0
  803337:	6a 00                	push   $0x0
  803339:	6a 1e                	push   $0x1e
  80333b:	e8 65 fc ff ff       	call   802fa5 <syscall>
  803340:	83 c4 18             	add    $0x18,%esp
}
  803343:	c9                   	leave  
  803344:	c3                   	ret    

00803345 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  803345:	55                   	push   %ebp
  803346:	89 e5                	mov    %esp,%ebp
  803348:	83 ec 04             	sub    $0x4,%esp
  80334b:	8b 45 08             	mov    0x8(%ebp),%eax
  80334e:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  803351:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  803355:	6a 00                	push   $0x0
  803357:	6a 00                	push   $0x0
  803359:	6a 00                	push   $0x0
  80335b:	6a 00                	push   $0x0
  80335d:	50                   	push   %eax
  80335e:	6a 1f                	push   $0x1f
  803360:	e8 40 fc ff ff       	call   802fa5 <syscall>
  803365:	83 c4 18             	add    $0x18,%esp
	return ;
  803368:	90                   	nop
}
  803369:	c9                   	leave  
  80336a:	c3                   	ret    

0080336b <rsttst>:
void rsttst()
{
  80336b:	55                   	push   %ebp
  80336c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  80336e:	6a 00                	push   $0x0
  803370:	6a 00                	push   $0x0
  803372:	6a 00                	push   $0x0
  803374:	6a 00                	push   $0x0
  803376:	6a 00                	push   $0x0
  803378:	6a 21                	push   $0x21
  80337a:	e8 26 fc ff ff       	call   802fa5 <syscall>
  80337f:	83 c4 18             	add    $0x18,%esp
	return ;
  803382:	90                   	nop
}
  803383:	c9                   	leave  
  803384:	c3                   	ret    

00803385 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  803385:	55                   	push   %ebp
  803386:	89 e5                	mov    %esp,%ebp
  803388:	83 ec 04             	sub    $0x4,%esp
  80338b:	8b 45 14             	mov    0x14(%ebp),%eax
  80338e:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  803391:	8b 55 18             	mov    0x18(%ebp),%edx
  803394:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  803398:	52                   	push   %edx
  803399:	50                   	push   %eax
  80339a:	ff 75 10             	pushl  0x10(%ebp)
  80339d:	ff 75 0c             	pushl  0xc(%ebp)
  8033a0:	ff 75 08             	pushl  0x8(%ebp)
  8033a3:	6a 20                	push   $0x20
  8033a5:	e8 fb fb ff ff       	call   802fa5 <syscall>
  8033aa:	83 c4 18             	add    $0x18,%esp
	return ;
  8033ad:	90                   	nop
}
  8033ae:	c9                   	leave  
  8033af:	c3                   	ret    

008033b0 <chktst>:
void chktst(uint32 n)
{
  8033b0:	55                   	push   %ebp
  8033b1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8033b3:	6a 00                	push   $0x0
  8033b5:	6a 00                	push   $0x0
  8033b7:	6a 00                	push   $0x0
  8033b9:	6a 00                	push   $0x0
  8033bb:	ff 75 08             	pushl  0x8(%ebp)
  8033be:	6a 22                	push   $0x22
  8033c0:	e8 e0 fb ff ff       	call   802fa5 <syscall>
  8033c5:	83 c4 18             	add    $0x18,%esp
	return ;
  8033c8:	90                   	nop
}
  8033c9:	c9                   	leave  
  8033ca:	c3                   	ret    

008033cb <inctst>:

void inctst()
{
  8033cb:	55                   	push   %ebp
  8033cc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8033ce:	6a 00                	push   $0x0
  8033d0:	6a 00                	push   $0x0
  8033d2:	6a 00                	push   $0x0
  8033d4:	6a 00                	push   $0x0
  8033d6:	6a 00                	push   $0x0
  8033d8:	6a 23                	push   $0x23
  8033da:	e8 c6 fb ff ff       	call   802fa5 <syscall>
  8033df:	83 c4 18             	add    $0x18,%esp
	return ;
  8033e2:	90                   	nop
}
  8033e3:	c9                   	leave  
  8033e4:	c3                   	ret    

008033e5 <gettst>:
uint32 gettst()
{
  8033e5:	55                   	push   %ebp
  8033e6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8033e8:	6a 00                	push   $0x0
  8033ea:	6a 00                	push   $0x0
  8033ec:	6a 00                	push   $0x0
  8033ee:	6a 00                	push   $0x0
  8033f0:	6a 00                	push   $0x0
  8033f2:	6a 24                	push   $0x24
  8033f4:	e8 ac fb ff ff       	call   802fa5 <syscall>
  8033f9:	83 c4 18             	add    $0x18,%esp
}
  8033fc:	c9                   	leave  
  8033fd:	c3                   	ret    

008033fe <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  8033fe:	55                   	push   %ebp
  8033ff:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  803401:	6a 00                	push   $0x0
  803403:	6a 00                	push   $0x0
  803405:	6a 00                	push   $0x0
  803407:	6a 00                	push   $0x0
  803409:	6a 00                	push   $0x0
  80340b:	6a 25                	push   $0x25
  80340d:	e8 93 fb ff ff       	call   802fa5 <syscall>
  803412:	83 c4 18             	add    $0x18,%esp
  803415:	a3 60 d0 81 00       	mov    %eax,0x81d060
	return uheapPlaceStrategy ;
  80341a:	a1 60 d0 81 00       	mov    0x81d060,%eax
}
  80341f:	c9                   	leave  
  803420:	c3                   	ret    

00803421 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  803421:	55                   	push   %ebp
  803422:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  803424:	8b 45 08             	mov    0x8(%ebp),%eax
  803427:	a3 60 d0 81 00       	mov    %eax,0x81d060
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  80342c:	6a 00                	push   $0x0
  80342e:	6a 00                	push   $0x0
  803430:	6a 00                	push   $0x0
  803432:	6a 00                	push   $0x0
  803434:	ff 75 08             	pushl  0x8(%ebp)
  803437:	6a 26                	push   $0x26
  803439:	e8 67 fb ff ff       	call   802fa5 <syscall>
  80343e:	83 c4 18             	add    $0x18,%esp
	return ;
  803441:	90                   	nop
}
  803442:	c9                   	leave  
  803443:	c3                   	ret    

00803444 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  803444:	55                   	push   %ebp
  803445:	89 e5                	mov    %esp,%ebp
  803447:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  803448:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80344b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80344e:	8b 55 0c             	mov    0xc(%ebp),%edx
  803451:	8b 45 08             	mov    0x8(%ebp),%eax
  803454:	6a 00                	push   $0x0
  803456:	53                   	push   %ebx
  803457:	51                   	push   %ecx
  803458:	52                   	push   %edx
  803459:	50                   	push   %eax
  80345a:	6a 27                	push   $0x27
  80345c:	e8 44 fb ff ff       	call   802fa5 <syscall>
  803461:	83 c4 18             	add    $0x18,%esp
}
  803464:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  803467:	c9                   	leave  
  803468:	c3                   	ret    

00803469 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  803469:	55                   	push   %ebp
  80346a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  80346c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80346f:	8b 45 08             	mov    0x8(%ebp),%eax
  803472:	6a 00                	push   $0x0
  803474:	6a 00                	push   $0x0
  803476:	6a 00                	push   $0x0
  803478:	52                   	push   %edx
  803479:	50                   	push   %eax
  80347a:	6a 28                	push   $0x28
  80347c:	e8 24 fb ff ff       	call   802fa5 <syscall>
  803481:	83 c4 18             	add    $0x18,%esp
}
  803484:	c9                   	leave  
  803485:	c3                   	ret    

00803486 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  803486:	55                   	push   %ebp
  803487:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  803489:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80348c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80348f:	8b 45 08             	mov    0x8(%ebp),%eax
  803492:	6a 00                	push   $0x0
  803494:	51                   	push   %ecx
  803495:	ff 75 10             	pushl  0x10(%ebp)
  803498:	52                   	push   %edx
  803499:	50                   	push   %eax
  80349a:	6a 29                	push   $0x29
  80349c:	e8 04 fb ff ff       	call   802fa5 <syscall>
  8034a1:	83 c4 18             	add    $0x18,%esp
}
  8034a4:	c9                   	leave  
  8034a5:	c3                   	ret    

008034a6 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8034a6:	55                   	push   %ebp
  8034a7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8034a9:	6a 00                	push   $0x0
  8034ab:	6a 00                	push   $0x0
  8034ad:	ff 75 10             	pushl  0x10(%ebp)
  8034b0:	ff 75 0c             	pushl  0xc(%ebp)
  8034b3:	ff 75 08             	pushl  0x8(%ebp)
  8034b6:	6a 12                	push   $0x12
  8034b8:	e8 e8 fa ff ff       	call   802fa5 <syscall>
  8034bd:	83 c4 18             	add    $0x18,%esp
	return ;
  8034c0:	90                   	nop
}
  8034c1:	c9                   	leave  
  8034c2:	c3                   	ret    

008034c3 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  8034c3:	55                   	push   %ebp
  8034c4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  8034c6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8034c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8034cc:	6a 00                	push   $0x0
  8034ce:	6a 00                	push   $0x0
  8034d0:	6a 00                	push   $0x0
  8034d2:	52                   	push   %edx
  8034d3:	50                   	push   %eax
  8034d4:	6a 2a                	push   $0x2a
  8034d6:	e8 ca fa ff ff       	call   802fa5 <syscall>
  8034db:	83 c4 18             	add    $0x18,%esp
	return;
  8034de:	90                   	nop
}
  8034df:	c9                   	leave  
  8034e0:	c3                   	ret    

008034e1 <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  8034e1:	55                   	push   %ebp
  8034e2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  8034e4:	6a 00                	push   $0x0
  8034e6:	6a 00                	push   $0x0
  8034e8:	6a 00                	push   $0x0
  8034ea:	6a 00                	push   $0x0
  8034ec:	6a 00                	push   $0x0
  8034ee:	6a 2b                	push   $0x2b
  8034f0:	e8 b0 fa ff ff       	call   802fa5 <syscall>
  8034f5:	83 c4 18             	add    $0x18,%esp
}
  8034f8:	c9                   	leave  
  8034f9:	c3                   	ret    

008034fa <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8034fa:	55                   	push   %ebp
  8034fb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  8034fd:	6a 00                	push   $0x0
  8034ff:	6a 00                	push   $0x0
  803501:	6a 00                	push   $0x0
  803503:	ff 75 0c             	pushl  0xc(%ebp)
  803506:	ff 75 08             	pushl  0x8(%ebp)
  803509:	6a 2d                	push   $0x2d
  80350b:	e8 95 fa ff ff       	call   802fa5 <syscall>
  803510:	83 c4 18             	add    $0x18,%esp
	return;
  803513:	90                   	nop
}
  803514:	c9                   	leave  
  803515:	c3                   	ret    

00803516 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  803516:	55                   	push   %ebp
  803517:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  803519:	6a 00                	push   $0x0
  80351b:	6a 00                	push   $0x0
  80351d:	6a 00                	push   $0x0
  80351f:	ff 75 0c             	pushl  0xc(%ebp)
  803522:	ff 75 08             	pushl  0x8(%ebp)
  803525:	6a 2c                	push   $0x2c
  803527:	e8 79 fa ff ff       	call   802fa5 <syscall>
  80352c:	83 c4 18             	add    $0x18,%esp
	return ;
  80352f:	90                   	nop
}
  803530:	c9                   	leave  
  803531:	c3                   	ret    

00803532 <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  803532:	55                   	push   %ebp
  803533:	89 e5                	mov    %esp,%ebp
	//TODO: [PROJECT'25.IM#4] CPU SCHEDULING - #1 System Calls - Add suitable code here
	//Your code is here
	//Comment the following line
	//panic("sys_env_set_priority() is not implemented yet...!!");
	syscall(SYS_env_set_priority, envID, priority, 0, 0, 0);
  803535:	8b 55 0c             	mov    0xc(%ebp),%edx
  803538:	8b 45 08             	mov    0x8(%ebp),%eax
  80353b:	6a 00                	push   $0x0
  80353d:	6a 00                	push   $0x0
  80353f:	6a 00                	push   $0x0
  803541:	52                   	push   %edx
  803542:	50                   	push   %eax
  803543:	6a 2e                	push   $0x2e
  803545:	e8 5b fa ff ff       	call   802fa5 <syscall>
  80354a:	83 c4 18             	add    $0x18,%esp
	    return;
  80354d:	90                   	nop
}
  80354e:	c9                   	leave  
  80354f:	c3                   	ret    

00803550 <to_page_va>:
//==================================================================================//
//==================================
// [1] GET PAGE VA:
//==================================
__inline__ uint32 to_page_va(struct PageInfoElement *ptrPageInfo)
{
  803550:	55                   	push   %ebp
  803551:	89 e5                	mov    %esp,%ebp
  803553:	83 ec 10             	sub    $0x10,%esp
	//Get start VA of the page from the corresponding Page Info pointer
	int idxInPageInfoArr = (ptrPageInfo - pageBlockInfoArr);
  803556:	8b 45 08             	mov    0x8(%ebp),%eax
  803559:	ba 60 50 80 00       	mov    $0x805060,%edx
  80355e:	29 d0                	sub    %edx,%eax
  803560:	c1 f8 02             	sar    $0x2,%eax
  803563:	89 c2                	mov    %eax,%edx
  803565:	89 d0                	mov    %edx,%eax
  803567:	c1 e0 02             	shl    $0x2,%eax
  80356a:	01 d0                	add    %edx,%eax
  80356c:	c1 e0 02             	shl    $0x2,%eax
  80356f:	01 d0                	add    %edx,%eax
  803571:	c1 e0 02             	shl    $0x2,%eax
  803574:	01 d0                	add    %edx,%eax
  803576:	89 c1                	mov    %eax,%ecx
  803578:	c1 e1 08             	shl    $0x8,%ecx
  80357b:	01 c8                	add    %ecx,%eax
  80357d:	89 c1                	mov    %eax,%ecx
  80357f:	c1 e1 10             	shl    $0x10,%ecx
  803582:	01 c8                	add    %ecx,%eax
  803584:	01 c0                	add    %eax,%eax
  803586:	01 d0                	add    %edx,%eax
  803588:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return dynAllocStart + (idxInPageInfoArr << PGSHIFT);
  80358b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80358e:	c1 e0 0c             	shl    $0xc,%eax
  803591:	89 c2                	mov    %eax,%edx
  803593:	a1 64 d0 81 00       	mov    0x81d064,%eax
  803598:	01 d0                	add    %edx,%eax
}
  80359a:	c9                   	leave  
  80359b:	c3                   	ret    

0080359c <log2>:

//==================================================================================//
//============================ REQUIRED FUNCTIONS ==================================//
//==================================================================================//
__inline__ int log2(uint32 n)
	{
  80359c:	55                   	push   %ebp
  80359d:	89 e5                	mov    %esp,%ebp
  80359f:	83 ec 10             	sub    $0x10,%esp
		int result = 0;
  8035a2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
		while( n > 1){
  8035a9:	eb 06                	jmp    8035b1 <log2+0x15>
			n >>=1;
  8035ab:	d1 6d 08             	shrl   0x8(%ebp)
			result++;
  8035ae:	ff 45 fc             	incl   -0x4(%ebp)
//============================ REQUIRED FUNCTIONS ==================================//
//==================================================================================//
__inline__ int log2(uint32 n)
	{
		int result = 0;
		while( n > 1){
  8035b1:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
  8035b5:	77 f4                	ja     8035ab <log2+0xf>
			n >>=1;
			result++;
		}
		return result;
  8035b7:	8b 45 fc             	mov    -0x4(%ebp),%eax
	}
  8035ba:	c9                   	leave  
  8035bb:	c3                   	ret    

008035bc <initialize_dynamic_allocator>:
//==================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================
bool is_initialized = 0;
void initialize_dynamic_allocator(uint32 daStart, uint32 daEnd)
{
  8035bc:	55                   	push   %ebp
  8035bd:	89 e5                	mov    %esp,%ebp
  8035bf:	83 ec 18             	sub    $0x18,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(daEnd <= daStart + DYN_ALLOC_MAX_SIZE);
  8035c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8035c5:	05 00 00 00 02       	add    $0x2000000,%eax
  8035ca:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8035cd:	73 16                	jae    8035e5 <initialize_dynamic_allocator+0x29>
  8035cf:	68 f8 4d 80 00       	push   $0x804df8
  8035d4:	68 1e 4e 80 00       	push   $0x804e1e
  8035d9:	6a 2d                	push   $0x2d
  8035db:	68 33 4e 80 00       	push   $0x804e33
  8035e0:	e8 a6 ce ff ff       	call   80048b <_panic>
		is_initialized = 1;
  8035e5:	c7 05 24 50 80 00 01 	movl   $0x1,0x805024
  8035ec:	00 00 00 
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #1 initialize_dynamic_allocator
	//Your code is here


	dynAllocStart = daStart;
  8035ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8035f2:	a3 64 d0 81 00       	mov    %eax,0x81d064
	dynAllocEnd= daEnd;
  8035f7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8035fa:	a3 40 50 80 00       	mov    %eax,0x805040
	int numOfPages = (dynAllocEnd - dynAllocStart)/PAGE_SIZE;
  8035ff:	8b 15 40 50 80 00    	mov    0x805040,%edx
  803605:	a1 64 d0 81 00       	mov    0x81d064,%eax
  80360a:	29 c2                	sub    %eax,%edx
  80360c:	89 d0                	mov    %edx,%eax
  80360e:	c1 e8 0c             	shr    $0xc,%eax
  803611:	89 45 e8             	mov    %eax,-0x18(%ebp)


	for(int i=0; i< numOfPages; i++){
  803614:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80361b:	eb 2f                	jmp    80364c <initialize_dynamic_allocator+0x90>
	    pageBlockInfoArr[i].block_size=0;
  80361d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803620:	89 d0                	mov    %edx,%eax
  803622:	01 c0                	add    %eax,%eax
  803624:	01 d0                	add    %edx,%eax
  803626:	c1 e0 02             	shl    $0x2,%eax
  803629:	05 68 50 80 00       	add    $0x805068,%eax
  80362e:	66 c7 00 00 00       	movw   $0x0,(%eax)
	    pageBlockInfoArr[i].num_of_free_blocks=0;
  803633:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803636:	89 d0                	mov    %edx,%eax
  803638:	01 c0                	add    %eax,%eax
  80363a:	01 d0                	add    %edx,%eax
  80363c:	c1 e0 02             	shl    $0x2,%eax
  80363f:	05 6a 50 80 00       	add    $0x80506a,%eax
  803644:	66 c7 00 00 00       	movw   $0x0,(%eax)
	dynAllocStart = daStart;
	dynAllocEnd= daEnd;
	int numOfPages = (dynAllocEnd - dynAllocStart)/PAGE_SIZE;


	for(int i=0; i< numOfPages; i++){
  803649:	ff 45 f4             	incl   -0xc(%ebp)
  80364c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80364f:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803652:	7c c9                	jl     80361d <initialize_dynamic_allocator+0x61>
	    pageBlockInfoArr[i].block_size=0;
	    pageBlockInfoArr[i].num_of_free_blocks=0;
	}


	LIST_INIT(&freePagesList);
  803654:	c7 05 48 50 80 00 00 	movl   $0x0,0x805048
  80365b:	00 00 00 
  80365e:	c7 05 4c 50 80 00 00 	movl   $0x0,0x80504c
  803665:	00 00 00 
  803668:	c7 05 54 50 80 00 00 	movl   $0x0,0x805054
  80366f:	00 00 00 
	for(int i=0; i<numOfPages; i++){
  803672:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  803679:	e9 9c 00 00 00       	jmp    80371a <initialize_dynamic_allocator+0x15e>
		LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
  80367e:	8b 15 4c 50 80 00    	mov    0x80504c,%edx
  803684:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  803687:	89 c8                	mov    %ecx,%eax
  803689:	01 c0                	add    %eax,%eax
  80368b:	01 c8                	add    %ecx,%eax
  80368d:	c1 e0 02             	shl    $0x2,%eax
  803690:	05 64 50 80 00       	add    $0x805064,%eax
  803695:	89 10                	mov    %edx,(%eax)
  803697:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80369a:	89 d0                	mov    %edx,%eax
  80369c:	01 c0                	add    %eax,%eax
  80369e:	01 d0                	add    %edx,%eax
  8036a0:	c1 e0 02             	shl    $0x2,%eax
  8036a3:	05 64 50 80 00       	add    $0x805064,%eax
  8036a8:	8b 00                	mov    (%eax),%eax
  8036aa:	85 c0                	test   %eax,%eax
  8036ac:	74 1b                	je     8036c9 <initialize_dynamic_allocator+0x10d>
  8036ae:	8b 15 4c 50 80 00    	mov    0x80504c,%edx
  8036b4:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8036b7:	89 c8                	mov    %ecx,%eax
  8036b9:	01 c0                	add    %eax,%eax
  8036bb:	01 c8                	add    %ecx,%eax
  8036bd:	c1 e0 02             	shl    $0x2,%eax
  8036c0:	05 60 50 80 00       	add    $0x805060,%eax
  8036c5:	89 02                	mov    %eax,(%edx)
  8036c7:	eb 16                	jmp    8036df <initialize_dynamic_allocator+0x123>
  8036c9:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8036cc:	89 d0                	mov    %edx,%eax
  8036ce:	01 c0                	add    %eax,%eax
  8036d0:	01 d0                	add    %edx,%eax
  8036d2:	c1 e0 02             	shl    $0x2,%eax
  8036d5:	05 60 50 80 00       	add    $0x805060,%eax
  8036da:	a3 48 50 80 00       	mov    %eax,0x805048
  8036df:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8036e2:	89 d0                	mov    %edx,%eax
  8036e4:	01 c0                	add    %eax,%eax
  8036e6:	01 d0                	add    %edx,%eax
  8036e8:	c1 e0 02             	shl    $0x2,%eax
  8036eb:	05 60 50 80 00       	add    $0x805060,%eax
  8036f0:	a3 4c 50 80 00       	mov    %eax,0x80504c
  8036f5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8036f8:	89 d0                	mov    %edx,%eax
  8036fa:	01 c0                	add    %eax,%eax
  8036fc:	01 d0                	add    %edx,%eax
  8036fe:	c1 e0 02             	shl    $0x2,%eax
  803701:	05 60 50 80 00       	add    $0x805060,%eax
  803706:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80370c:	a1 54 50 80 00       	mov    0x805054,%eax
  803711:	40                   	inc    %eax
  803712:	a3 54 50 80 00       	mov    %eax,0x805054
	    pageBlockInfoArr[i].num_of_free_blocks=0;
	}


	LIST_INIT(&freePagesList);
	for(int i=0; i<numOfPages; i++){
  803717:	ff 45 f0             	incl   -0x10(%ebp)
  80371a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80371d:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803720:	0f 8c 58 ff ff ff    	jl     80367e <initialize_dynamic_allocator+0xc2>
		LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
	}



	for (int i = 0; i < LOG2_MAX_SIZE - LOG2_MIN_SIZE + 1; i++) {
  803726:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  80372d:	eb 36                	jmp    803765 <initialize_dynamic_allocator+0x1a9>
	    LIST_INIT(&freeBlockLists[i]);
  80372f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803732:	c1 e0 04             	shl    $0x4,%eax
  803735:	05 80 d0 81 00       	add    $0x81d080,%eax
  80373a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803740:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803743:	c1 e0 04             	shl    $0x4,%eax
  803746:	05 84 d0 81 00       	add    $0x81d084,%eax
  80374b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803751:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803754:	c1 e0 04             	shl    $0x4,%eax
  803757:	05 8c d0 81 00       	add    $0x81d08c,%eax
  80375c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
	}



	for (int i = 0; i < LOG2_MAX_SIZE - LOG2_MIN_SIZE + 1; i++) {
  803762:	ff 45 ec             	incl   -0x14(%ebp)
  803765:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  803769:	7e c4                	jle    80372f <initialize_dynamic_allocator+0x173>


	//Comment the following line
	//panic("initialize_dynamic_allocator() Not implemented yet");

}
  80376b:	90                   	nop
  80376c:	c9                   	leave  
  80376d:	c3                   	ret    

0080376e <get_block_size>:
// [2] GET BLOCK SIZE:
//===========================


__inline__ uint32 get_block_size(void *va)
{
  80376e:	55                   	push   %ebp
  80376f:	89 e5                	mov    %esp,%ebp
  803771:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #2 get_block_size
	//Your code is here

	uint32 page_index = ((uint32)va - dynAllocStart)/ PAGE_SIZE;
  803774:	8b 55 08             	mov    0x8(%ebp),%edx
  803777:	a1 64 d0 81 00       	mov    0x81d064,%eax
  80377c:	29 c2                	sub    %eax,%edx
  80377e:	89 d0                	mov    %edx,%eax
  803780:	c1 e8 0c             	shr    $0xc,%eax
  803783:	89 45 fc             	mov    %eax,-0x4(%ebp)
    return pageBlockInfoArr[page_index].block_size;
  803786:	8b 55 fc             	mov    -0x4(%ebp),%edx
  803789:	89 d0                	mov    %edx,%eax
  80378b:	01 c0                	add    %eax,%eax
  80378d:	01 d0                	add    %edx,%eax
  80378f:	c1 e0 02             	shl    $0x2,%eax
  803792:	05 68 50 80 00       	add    $0x805068,%eax
  803797:	8b 00                	mov    (%eax),%eax
  803799:	0f b7 c0             	movzwl %ax,%eax
	//Comment the following line
	//panic("get_block_size() Not implemented yet");
}
  80379c:	c9                   	leave  
  80379d:	c3                   	ret    

0080379e <alloc_block>:

//===========================
// 3) ALLOCATE BLOCK:
//===========================
void *alloc_block(uint32 size)
{
  80379e:	55                   	push   %ebp
  80379f:	89 e5                	mov    %esp,%ebp
  8037a1:	83 ec 48             	sub    $0x48,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(size <= DYN_ALLOC_MAX_BLOCK_SIZE);
  8037a4:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  8037ab:	76 16                	jbe    8037c3 <alloc_block+0x25>
  8037ad:	68 4c 4e 80 00       	push   $0x804e4c
  8037b2:	68 1e 4e 80 00       	push   $0x804e1e
  8037b7:	6a 6c                	push   $0x6c
  8037b9:	68 33 4e 80 00       	push   $0x804e33
  8037be:	e8 c8 cc ff ff       	call   80048b <_panic>
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #3 alloc_block
	//Your code is here


	if(size == 0){
  8037c3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8037c7:	75 0a                	jne    8037d3 <alloc_block+0x35>
		return NULL;
  8037c9:	b8 00 00 00 00       	mov    $0x0,%eax
  8037ce:	e9 65 04 00 00       	jmp    803c38 <alloc_block+0x49a>
	}
	else if(size<=8){
  8037d3:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  8037d7:	77 09                	ja     8037e2 <alloc_block+0x44>
		size=8;
  8037d9:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
  8037e0:	eb 1f                	jmp    803801 <alloc_block+0x63>
	}
	else{
		uint32 reqsize=8;
  8037e2:	c7 45 f4 08 00 00 00 	movl   $0x8,-0xc(%ebp)
		while(reqsize < size){
  8037e9:	eb 08                	jmp    8037f3 <alloc_block+0x55>
			reqsize*=2;
  8037eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037ee:	01 c0                	add    %eax,%eax
  8037f0:	89 45 f4             	mov    %eax,-0xc(%ebp)
	else if(size<=8){
		size=8;
	}
	else{
		uint32 reqsize=8;
		while(reqsize < size){
  8037f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037f6:	3b 45 08             	cmp    0x8(%ebp),%eax
  8037f9:	72 f0                	jb     8037eb <alloc_block+0x4d>
			reqsize*=2;
		}
		size= reqsize;
  8037fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037fe:	89 45 08             	mov    %eax,0x8(%ebp)
	}

	int list_index = log2(size)- LOG2_MIN_SIZE;
  803801:	83 ec 0c             	sub    $0xc,%esp
  803804:	ff 75 08             	pushl  0x8(%ebp)
  803807:	e8 90 fd ff ff       	call   80359c <log2>
  80380c:	83 c4 10             	add    $0x10,%esp
  80380f:	83 e8 03             	sub    $0x3,%eax
  803812:	89 45 e8             	mov    %eax,-0x18(%ebp)

	if(!LIST_EMPTY(&freeBlockLists[list_index])){
  803815:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803818:	c1 e0 04             	shl    $0x4,%eax
  80381b:	05 80 d0 81 00       	add    $0x81d080,%eax
  803820:	8b 00                	mov    (%eax),%eax
  803822:	85 c0                	test   %eax,%eax
  803824:	0f 84 fb 00 00 00    	je     803925 <alloc_block+0x187>
		struct BlockElement *block = LIST_FIRST(&freeBlockLists[list_index]);
  80382a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80382d:	c1 e0 04             	shl    $0x4,%eax
  803830:	05 80 d0 81 00       	add    $0x81d080,%eax
  803835:	8b 00                	mov    (%eax),%eax
  803837:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		LIST_REMOVE(&freeBlockLists[list_index], block);
  80383a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80383e:	75 17                	jne    803857 <alloc_block+0xb9>
  803840:	83 ec 04             	sub    $0x4,%esp
  803843:	68 6d 4e 80 00       	push   $0x804e6d
  803848:	68 86 00 00 00       	push   $0x86
  80384d:	68 33 4e 80 00       	push   $0x804e33
  803852:	e8 34 cc ff ff       	call   80048b <_panic>
  803857:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80385a:	8b 00                	mov    (%eax),%eax
  80385c:	85 c0                	test   %eax,%eax
  80385e:	74 10                	je     803870 <alloc_block+0xd2>
  803860:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803863:	8b 00                	mov    (%eax),%eax
  803865:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803868:	8b 52 04             	mov    0x4(%edx),%edx
  80386b:	89 50 04             	mov    %edx,0x4(%eax)
  80386e:	eb 14                	jmp    803884 <alloc_block+0xe6>
  803870:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803873:	8b 40 04             	mov    0x4(%eax),%eax
  803876:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803879:	c1 e2 04             	shl    $0x4,%edx
  80387c:	81 c2 84 d0 81 00    	add    $0x81d084,%edx
  803882:	89 02                	mov    %eax,(%edx)
  803884:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803887:	8b 40 04             	mov    0x4(%eax),%eax
  80388a:	85 c0                	test   %eax,%eax
  80388c:	74 0f                	je     80389d <alloc_block+0xff>
  80388e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803891:	8b 40 04             	mov    0x4(%eax),%eax
  803894:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803897:	8b 12                	mov    (%edx),%edx
  803899:	89 10                	mov    %edx,(%eax)
  80389b:	eb 13                	jmp    8038b0 <alloc_block+0x112>
  80389d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038a0:	8b 00                	mov    (%eax),%eax
  8038a2:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8038a5:	c1 e2 04             	shl    $0x4,%edx
  8038a8:	81 c2 80 d0 81 00    	add    $0x81d080,%edx
  8038ae:	89 02                	mov    %eax,(%edx)
  8038b0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038b3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8038b9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038bc:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8038c3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8038c6:	c1 e0 04             	shl    $0x4,%eax
  8038c9:	05 8c d0 81 00       	add    $0x81d08c,%eax
  8038ce:	8b 00                	mov    (%eax),%eax
  8038d0:	8d 50 ff             	lea    -0x1(%eax),%edx
  8038d3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8038d6:	c1 e0 04             	shl    $0x4,%eax
  8038d9:	05 8c d0 81 00       	add    $0x81d08c,%eax
  8038de:	89 10                	mov    %edx,(%eax)
		uint32 page_index = ((uint32)block - dynAllocStart)/ PAGE_SIZE;
  8038e0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8038e3:	a1 64 d0 81 00       	mov    0x81d064,%eax
  8038e8:	29 c2                	sub    %eax,%edx
  8038ea:	89 d0                	mov    %edx,%eax
  8038ec:	c1 e8 0c             	shr    $0xc,%eax
  8038ef:	89 45 e0             	mov    %eax,-0x20(%ebp)
		pageBlockInfoArr[page_index].num_of_free_blocks--;
  8038f2:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8038f5:	89 d0                	mov    %edx,%eax
  8038f7:	01 c0                	add    %eax,%eax
  8038f9:	01 d0                	add    %edx,%eax
  8038fb:	c1 e0 02             	shl    $0x2,%eax
  8038fe:	05 6a 50 80 00       	add    $0x80506a,%eax
  803903:	66 8b 00             	mov    (%eax),%ax
  803906:	8d 50 ff             	lea    -0x1(%eax),%edx
  803909:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  80390c:	89 c8                	mov    %ecx,%eax
  80390e:	01 c0                	add    %eax,%eax
  803910:	01 c8                	add    %ecx,%eax
  803912:	c1 e0 02             	shl    $0x2,%eax
  803915:	05 6a 50 80 00       	add    $0x80506a,%eax
  80391a:	66 89 10             	mov    %dx,(%eax)
		return (void*)block;
  80391d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803920:	e9 13 03 00 00       	jmp    803c38 <alloc_block+0x49a>
	}

	if(!LIST_EMPTY(&freePagesList)){
  803925:	a1 48 50 80 00       	mov    0x805048,%eax
  80392a:	85 c0                	test   %eax,%eax
  80392c:	0f 84 c9 01 00 00    	je     803afb <alloc_block+0x35d>

		struct PageInfoElement *page_info = LIST_FIRST(&freePagesList);
  803932:	a1 48 50 80 00       	mov    0x805048,%eax
  803937:	89 45 dc             	mov    %eax,-0x24(%ebp)
		LIST_REMOVE(&freePagesList, page_info);
  80393a:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80393e:	75 17                	jne    803957 <alloc_block+0x1b9>
  803940:	83 ec 04             	sub    $0x4,%esp
  803943:	68 6d 4e 80 00       	push   $0x804e6d
  803948:	68 8f 00 00 00       	push   $0x8f
  80394d:	68 33 4e 80 00       	push   $0x804e33
  803952:	e8 34 cb ff ff       	call   80048b <_panic>
  803957:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80395a:	8b 00                	mov    (%eax),%eax
  80395c:	85 c0                	test   %eax,%eax
  80395e:	74 10                	je     803970 <alloc_block+0x1d2>
  803960:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803963:	8b 00                	mov    (%eax),%eax
  803965:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803968:	8b 52 04             	mov    0x4(%edx),%edx
  80396b:	89 50 04             	mov    %edx,0x4(%eax)
  80396e:	eb 0b                	jmp    80397b <alloc_block+0x1dd>
  803970:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803973:	8b 40 04             	mov    0x4(%eax),%eax
  803976:	a3 4c 50 80 00       	mov    %eax,0x80504c
  80397b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80397e:	8b 40 04             	mov    0x4(%eax),%eax
  803981:	85 c0                	test   %eax,%eax
  803983:	74 0f                	je     803994 <alloc_block+0x1f6>
  803985:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803988:	8b 40 04             	mov    0x4(%eax),%eax
  80398b:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80398e:	8b 12                	mov    (%edx),%edx
  803990:	89 10                	mov    %edx,(%eax)
  803992:	eb 0a                	jmp    80399e <alloc_block+0x200>
  803994:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803997:	8b 00                	mov    (%eax),%eax
  803999:	a3 48 50 80 00       	mov    %eax,0x805048
  80399e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8039a1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8039a7:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8039aa:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8039b1:	a1 54 50 80 00       	mov    0x805054,%eax
  8039b6:	48                   	dec    %eax
  8039b7:	a3 54 50 80 00       	mov    %eax,0x805054
		uint32 page_va = to_page_va(page_info);
  8039bc:	83 ec 0c             	sub    $0xc,%esp
  8039bf:	ff 75 dc             	pushl  -0x24(%ebp)
  8039c2:	e8 89 fb ff ff       	call   803550 <to_page_va>
  8039c7:	83 c4 10             	add    $0x10,%esp
  8039ca:	89 45 d8             	mov    %eax,-0x28(%ebp)

		uint32 page_index = (page_va - dynAllocStart)/ PAGE_SIZE;
  8039cd:	a1 64 d0 81 00       	mov    0x81d064,%eax
  8039d2:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8039d5:	29 c2                	sub    %eax,%edx
  8039d7:	89 d0                	mov    %edx,%eax
  8039d9:	c1 e8 0c             	shr    $0xc,%eax
  8039dc:	89 45 d4             	mov    %eax,-0x2c(%ebp)

		get_page((void*)page_va);
  8039df:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8039e2:	83 ec 0c             	sub    $0xc,%esp
  8039e5:	50                   	push   %eax
  8039e6:	e8 fe dc ff ff       	call   8016e9 <get_page>
  8039eb:	83 c4 10             	add    $0x10,%esp


		pageBlockInfoArr[page_index].block_size = size;
  8039ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8039f1:	89 c2                	mov    %eax,%edx
  8039f3:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  8039f6:	89 c8                	mov    %ecx,%eax
  8039f8:	01 c0                	add    %eax,%eax
  8039fa:	01 c8                	add    %ecx,%eax
  8039fc:	c1 e0 02             	shl    $0x2,%eax
  8039ff:	05 68 50 80 00       	add    $0x805068,%eax
  803a04:	66 89 10             	mov    %dx,(%eax)
		int num_blocks = PAGE_SIZE / size ;
  803a07:	b8 00 10 00 00       	mov    $0x1000,%eax
  803a0c:	ba 00 00 00 00       	mov    $0x0,%edx
  803a11:	f7 75 08             	divl   0x8(%ebp)
  803a14:	89 45 d0             	mov    %eax,-0x30(%ebp)
		pageBlockInfoArr[page_index].num_of_free_blocks= num_blocks - 1 ;
  803a17:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803a1a:	8d 50 ff             	lea    -0x1(%eax),%edx
  803a1d:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  803a20:	89 c8                	mov    %ecx,%eax
  803a22:	01 c0                	add    %eax,%eax
  803a24:	01 c8                	add    %ecx,%eax
  803a26:	c1 e0 02             	shl    $0x2,%eax
  803a29:	05 6a 50 80 00       	add    $0x80506a,%eax
  803a2e:	66 89 10             	mov    %dx,(%eax)

		for(int i=1; i< num_blocks; i++){
  803a31:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
  803a38:	e9 aa 00 00 00       	jmp    803ae7 <alloc_block+0x349>
			struct BlockElement *new_block = (struct BlockElement*)(page_va + i *size);
  803a3d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803a40:	0f af 45 08          	imul   0x8(%ebp),%eax
  803a44:	89 c2                	mov    %eax,%edx
  803a46:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803a49:	01 d0                	add    %edx,%eax
  803a4b:	89 45 cc             	mov    %eax,-0x34(%ebp)
			LIST_INSERT_TAIL(&freeBlockLists[list_index], new_block);
  803a4e:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  803a52:	75 17                	jne    803a6b <alloc_block+0x2cd>
  803a54:	83 ec 04             	sub    $0x4,%esp
  803a57:	68 8c 4e 80 00       	push   $0x804e8c
  803a5c:	68 9d 00 00 00       	push   $0x9d
  803a61:	68 33 4e 80 00       	push   $0x804e33
  803a66:	e8 20 ca ff ff       	call   80048b <_panic>
  803a6b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a6e:	c1 e0 04             	shl    $0x4,%eax
  803a71:	05 84 d0 81 00       	add    $0x81d084,%eax
  803a76:	8b 10                	mov    (%eax),%edx
  803a78:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803a7b:	89 50 04             	mov    %edx,0x4(%eax)
  803a7e:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803a81:	8b 40 04             	mov    0x4(%eax),%eax
  803a84:	85 c0                	test   %eax,%eax
  803a86:	74 14                	je     803a9c <alloc_block+0x2fe>
  803a88:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a8b:	c1 e0 04             	shl    $0x4,%eax
  803a8e:	05 84 d0 81 00       	add    $0x81d084,%eax
  803a93:	8b 00                	mov    (%eax),%eax
  803a95:	8b 55 cc             	mov    -0x34(%ebp),%edx
  803a98:	89 10                	mov    %edx,(%eax)
  803a9a:	eb 11                	jmp    803aad <alloc_block+0x30f>
  803a9c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a9f:	c1 e0 04             	shl    $0x4,%eax
  803aa2:	8d 90 80 d0 81 00    	lea    0x81d080(%eax),%edx
  803aa8:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803aab:	89 02                	mov    %eax,(%edx)
  803aad:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803ab0:	c1 e0 04             	shl    $0x4,%eax
  803ab3:	8d 90 84 d0 81 00    	lea    0x81d084(%eax),%edx
  803ab9:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803abc:	89 02                	mov    %eax,(%edx)
  803abe:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803ac1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803ac7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803aca:	c1 e0 04             	shl    $0x4,%eax
  803acd:	05 8c d0 81 00       	add    $0x81d08c,%eax
  803ad2:	8b 00                	mov    (%eax),%eax
  803ad4:	8d 50 01             	lea    0x1(%eax),%edx
  803ad7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803ada:	c1 e0 04             	shl    $0x4,%eax
  803add:	05 8c d0 81 00       	add    $0x81d08c,%eax
  803ae2:	89 10                	mov    %edx,(%eax)

		pageBlockInfoArr[page_index].block_size = size;
		int num_blocks = PAGE_SIZE / size ;
		pageBlockInfoArr[page_index].num_of_free_blocks= num_blocks - 1 ;

		for(int i=1; i< num_blocks; i++){
  803ae4:	ff 45 f0             	incl   -0x10(%ebp)
  803ae7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803aea:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  803aed:	0f 8c 4a ff ff ff    	jl     803a3d <alloc_block+0x29f>
			struct BlockElement *new_block = (struct BlockElement*)(page_va + i *size);
			LIST_INSERT_TAIL(&freeBlockLists[list_index], new_block);
		}
		return(void*)page_va;
  803af3:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803af6:	e9 3d 01 00 00       	jmp    803c38 <alloc_block+0x49a>
	}


	for(int i =list_index+1; i<= LOG2_MAX_SIZE - LOG2_MIN_SIZE; i++){
  803afb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803afe:	40                   	inc    %eax
  803aff:	89 45 ec             	mov    %eax,-0x14(%ebp)
  803b02:	e9 10 01 00 00       	jmp    803c17 <alloc_block+0x479>

		if(!LIST_EMPTY(&freeBlockLists[i])){
  803b07:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803b0a:	c1 e0 04             	shl    $0x4,%eax
  803b0d:	05 80 d0 81 00       	add    $0x81d080,%eax
  803b12:	8b 00                	mov    (%eax),%eax
  803b14:	85 c0                	test   %eax,%eax
  803b16:	0f 84 f8 00 00 00    	je     803c14 <alloc_block+0x476>

			struct BlockElement *block = LIST_FIRST(&freeBlockLists[i]);
  803b1c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803b1f:	c1 e0 04             	shl    $0x4,%eax
  803b22:	05 80 d0 81 00       	add    $0x81d080,%eax
  803b27:	8b 00                	mov    (%eax),%eax
  803b29:	89 45 c8             	mov    %eax,-0x38(%ebp)
			LIST_REMOVE( &freeBlockLists[i], block);
  803b2c:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  803b30:	75 17                	jne    803b49 <alloc_block+0x3ab>
  803b32:	83 ec 04             	sub    $0x4,%esp
  803b35:	68 6d 4e 80 00       	push   $0x804e6d
  803b3a:	68 a8 00 00 00       	push   $0xa8
  803b3f:	68 33 4e 80 00       	push   $0x804e33
  803b44:	e8 42 c9 ff ff       	call   80048b <_panic>
  803b49:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803b4c:	8b 00                	mov    (%eax),%eax
  803b4e:	85 c0                	test   %eax,%eax
  803b50:	74 10                	je     803b62 <alloc_block+0x3c4>
  803b52:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803b55:	8b 00                	mov    (%eax),%eax
  803b57:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803b5a:	8b 52 04             	mov    0x4(%edx),%edx
  803b5d:	89 50 04             	mov    %edx,0x4(%eax)
  803b60:	eb 14                	jmp    803b76 <alloc_block+0x3d8>
  803b62:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803b65:	8b 40 04             	mov    0x4(%eax),%eax
  803b68:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803b6b:	c1 e2 04             	shl    $0x4,%edx
  803b6e:	81 c2 84 d0 81 00    	add    $0x81d084,%edx
  803b74:	89 02                	mov    %eax,(%edx)
  803b76:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803b79:	8b 40 04             	mov    0x4(%eax),%eax
  803b7c:	85 c0                	test   %eax,%eax
  803b7e:	74 0f                	je     803b8f <alloc_block+0x3f1>
  803b80:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803b83:	8b 40 04             	mov    0x4(%eax),%eax
  803b86:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803b89:	8b 12                	mov    (%edx),%edx
  803b8b:	89 10                	mov    %edx,(%eax)
  803b8d:	eb 13                	jmp    803ba2 <alloc_block+0x404>
  803b8f:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803b92:	8b 00                	mov    (%eax),%eax
  803b94:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803b97:	c1 e2 04             	shl    $0x4,%edx
  803b9a:	81 c2 80 d0 81 00    	add    $0x81d080,%edx
  803ba0:	89 02                	mov    %eax,(%edx)
  803ba2:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803ba5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803bab:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803bae:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803bb5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803bb8:	c1 e0 04             	shl    $0x4,%eax
  803bbb:	05 8c d0 81 00       	add    $0x81d08c,%eax
  803bc0:	8b 00                	mov    (%eax),%eax
  803bc2:	8d 50 ff             	lea    -0x1(%eax),%edx
  803bc5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803bc8:	c1 e0 04             	shl    $0x4,%eax
  803bcb:	05 8c d0 81 00       	add    $0x81d08c,%eax
  803bd0:	89 10                	mov    %edx,(%eax)

			uint32 page_index = ((uint32)block - dynAllocStart)/ PAGE_SIZE;
  803bd2:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803bd5:	a1 64 d0 81 00       	mov    0x81d064,%eax
  803bda:	29 c2                	sub    %eax,%edx
  803bdc:	89 d0                	mov    %edx,%eax
  803bde:	c1 e8 0c             	shr    $0xc,%eax
  803be1:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			pageBlockInfoArr[page_index].num_of_free_blocks-- ;
  803be4:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  803be7:	89 d0                	mov    %edx,%eax
  803be9:	01 c0                	add    %eax,%eax
  803beb:	01 d0                	add    %edx,%eax
  803bed:	c1 e0 02             	shl    $0x2,%eax
  803bf0:	05 6a 50 80 00       	add    $0x80506a,%eax
  803bf5:	66 8b 00             	mov    (%eax),%ax
  803bf8:	8d 50 ff             	lea    -0x1(%eax),%edx
  803bfb:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  803bfe:	89 c8                	mov    %ecx,%eax
  803c00:	01 c0                	add    %eax,%eax
  803c02:	01 c8                	add    %ecx,%eax
  803c04:	c1 e0 02             	shl    $0x2,%eax
  803c07:	05 6a 50 80 00       	add    $0x80506a,%eax
  803c0c:	66 89 10             	mov    %dx,(%eax)

			return (void*)block;
  803c0f:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803c12:	eb 24                	jmp    803c38 <alloc_block+0x49a>
		}
		return(void*)page_va;
	}


	for(int i =list_index+1; i<= LOG2_MAX_SIZE - LOG2_MIN_SIZE; i++){
  803c14:	ff 45 ec             	incl   -0x14(%ebp)
  803c17:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  803c1b:	0f 8e e6 fe ff ff    	jle    803b07 <alloc_block+0x369>

			return (void*)block;
		}
	}

	panic("alloc_block: out of memory! ");
  803c21:	83 ec 04             	sub    $0x4,%esp
  803c24:	68 af 4e 80 00       	push   $0x804eaf
  803c29:	68 b1 00 00 00       	push   $0xb1
  803c2e:	68 33 4e 80 00       	push   $0x804e33
  803c33:	e8 53 c8 ff ff       	call   80048b <_panic>

	//Comment the following line
	//panic("alloc_block() Not implemented yet");

	//TODO: [PROJECT'25.BONUS#1] DYNAMIC ALLOCATOR - block if no free block
}
  803c38:	c9                   	leave  
  803c39:	c3                   	ret    

00803c3a <free_block>:

//===========================
// [4] FREE BLOCK:
//===========================
void free_block(void *va)
{
  803c3a:	55                   	push   %ebp
  803c3b:	89 e5                	mov    %esp,%ebp
  803c3d:	83 ec 38             	sub    $0x38,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert((uint32)va >= dynAllocStart && (uint32)va < dynAllocEnd);
  803c40:	8b 55 08             	mov    0x8(%ebp),%edx
  803c43:	a1 64 d0 81 00       	mov    0x81d064,%eax
  803c48:	39 c2                	cmp    %eax,%edx
  803c4a:	72 0c                	jb     803c58 <free_block+0x1e>
  803c4c:	8b 55 08             	mov    0x8(%ebp),%edx
  803c4f:	a1 40 50 80 00       	mov    0x805040,%eax
  803c54:	39 c2                	cmp    %eax,%edx
  803c56:	72 19                	jb     803c71 <free_block+0x37>
  803c58:	68 cc 4e 80 00       	push   $0x804ecc
  803c5d:	68 1e 4e 80 00       	push   $0x804e1e
  803c62:	68 c3 00 00 00       	push   $0xc3
  803c67:	68 33 4e 80 00       	push   $0x804e33
  803c6c:	e8 1a c8 ff ff       	call   80048b <_panic>
	//==================================================================================

	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #4 free_block
	//Your code is here

	uint32 page_index=((uint32)va - dynAllocStart)/ PAGE_SIZE;
  803c71:	8b 55 08             	mov    0x8(%ebp),%edx
  803c74:	a1 64 d0 81 00       	mov    0x81d064,%eax
  803c79:	29 c2                	sub    %eax,%edx
  803c7b:	89 d0                	mov    %edx,%eax
  803c7d:	c1 e8 0c             	shr    $0xc,%eax
  803c80:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 block_size = pageBlockInfoArr[page_index].block_size;
  803c83:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803c86:	89 d0                	mov    %edx,%eax
  803c88:	01 c0                	add    %eax,%eax
  803c8a:	01 d0                	add    %edx,%eax
  803c8c:	c1 e0 02             	shl    $0x2,%eax
  803c8f:	05 68 50 80 00       	add    $0x805068,%eax
  803c94:	8b 00                	mov    (%eax),%eax
  803c96:	0f b7 c0             	movzwl %ax,%eax
  803c99:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if(block_size == 0){
  803c9c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803ca0:	75 17                	jne    803cb9 <free_block+0x7f>
		panic("page is empty(already not allocated)");
  803ca2:	83 ec 04             	sub    $0x4,%esp
  803ca5:	68 04 4f 80 00       	push   $0x804f04
  803caa:	68 cf 00 00 00       	push   $0xcf
  803caf:	68 33 4e 80 00       	push   $0x804e33
  803cb4:	e8 d2 c7 ff ff       	call   80048b <_panic>
	}

	int list_index = log2(block_size) - LOG2_MIN_SIZE;
  803cb9:	83 ec 0c             	sub    $0xc,%esp
  803cbc:	ff 75 ec             	pushl  -0x14(%ebp)
  803cbf:	e8 d8 f8 ff ff       	call   80359c <log2>
  803cc4:	83 c4 10             	add    $0x10,%esp
  803cc7:	83 e8 03             	sub    $0x3,%eax
  803cca:	89 45 e8             	mov    %eax,-0x18(%ebp)
	// mn va l block "elta7weel mn virtual l phy hna"
	struct BlockElement *block = (struct BlockElement *)va;
  803ccd:	8b 45 08             	mov    0x8(%ebp),%eax
  803cd0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	LIST_INSERT_TAIL(&freeBlockLists[list_index], block);
  803cd3:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803cd7:	75 17                	jne    803cf0 <free_block+0xb6>
  803cd9:	83 ec 04             	sub    $0x4,%esp
  803cdc:	68 8c 4e 80 00       	push   $0x804e8c
  803ce1:	68 d5 00 00 00       	push   $0xd5
  803ce6:	68 33 4e 80 00       	push   $0x804e33
  803ceb:	e8 9b c7 ff ff       	call   80048b <_panic>
  803cf0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803cf3:	c1 e0 04             	shl    $0x4,%eax
  803cf6:	05 84 d0 81 00       	add    $0x81d084,%eax
  803cfb:	8b 10                	mov    (%eax),%edx
  803cfd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803d00:	89 50 04             	mov    %edx,0x4(%eax)
  803d03:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803d06:	8b 40 04             	mov    0x4(%eax),%eax
  803d09:	85 c0                	test   %eax,%eax
  803d0b:	74 14                	je     803d21 <free_block+0xe7>
  803d0d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803d10:	c1 e0 04             	shl    $0x4,%eax
  803d13:	05 84 d0 81 00       	add    $0x81d084,%eax
  803d18:	8b 00                	mov    (%eax),%eax
  803d1a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803d1d:	89 10                	mov    %edx,(%eax)
  803d1f:	eb 11                	jmp    803d32 <free_block+0xf8>
  803d21:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803d24:	c1 e0 04             	shl    $0x4,%eax
  803d27:	8d 90 80 d0 81 00    	lea    0x81d080(%eax),%edx
  803d2d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803d30:	89 02                	mov    %eax,(%edx)
  803d32:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803d35:	c1 e0 04             	shl    $0x4,%eax
  803d38:	8d 90 84 d0 81 00    	lea    0x81d084(%eax),%edx
  803d3e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803d41:	89 02                	mov    %eax,(%edx)
  803d43:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803d46:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803d4c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803d4f:	c1 e0 04             	shl    $0x4,%eax
  803d52:	05 8c d0 81 00       	add    $0x81d08c,%eax
  803d57:	8b 00                	mov    (%eax),%eax
  803d59:	8d 50 01             	lea    0x1(%eax),%edx
  803d5c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803d5f:	c1 e0 04             	shl    $0x4,%eax
  803d62:	05 8c d0 81 00       	add    $0x81d08c,%eax
  803d67:	89 10                	mov    %edx,(%eax)
	// b3d ma wdytha fy el freeBlockLists hzwed elfree elly fy el array 1
	pageBlockInfoArr[page_index].num_of_free_blocks++;
  803d69:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803d6c:	89 d0                	mov    %edx,%eax
  803d6e:	01 c0                	add    %eax,%eax
  803d70:	01 d0                	add    %edx,%eax
  803d72:	c1 e0 02             	shl    $0x2,%eax
  803d75:	05 6a 50 80 00       	add    $0x80506a,%eax
  803d7a:	66 8b 00             	mov    (%eax),%ax
  803d7d:	8d 50 01             	lea    0x1(%eax),%edx
  803d80:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  803d83:	89 c8                	mov    %ecx,%eax
  803d85:	01 c0                	add    %eax,%eax
  803d87:	01 c8                	add    %ecx,%eax
  803d89:	c1 e0 02             	shl    $0x2,%eax
  803d8c:	05 6a 50 80 00       	add    $0x80506a,%eax
  803d91:	66 89 10             	mov    %dx,(%eax)
	int blocks_number = PAGE_SIZE / block_size;
  803d94:	b8 00 10 00 00       	mov    $0x1000,%eax
  803d99:	ba 00 00 00 00       	mov    $0x0,%edx
  803d9e:	f7 75 ec             	divl   -0x14(%ebp)
  803da1:	89 45 e0             	mov    %eax,-0x20(%ebp)
	if(pageBlockInfoArr[page_index].num_of_free_blocks == blocks_number){
  803da4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803da7:	89 d0                	mov    %edx,%eax
  803da9:	01 c0                	add    %eax,%eax
  803dab:	01 d0                	add    %edx,%eax
  803dad:	c1 e0 02             	shl    $0x2,%eax
  803db0:	05 6a 50 80 00       	add    $0x80506a,%eax
  803db5:	66 8b 00             	mov    (%eax),%ax
  803db8:	0f b7 c0             	movzwl %ax,%eax
  803dbb:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  803dbe:	0f 85 d3 01 00 00    	jne    803f97 <free_block+0x35d>
		struct BlockElement *itr = LIST_FIRST(&freeBlockLists[list_index]);
  803dc4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803dc7:	c1 e0 04             	shl    $0x4,%eax
  803dca:	05 80 d0 81 00       	add    $0x81d080,%eax
  803dcf:	8b 00                	mov    (%eax),%eax
  803dd1:	89 45 f4             	mov    %eax,-0xc(%ebp)
		while(itr != NULL){
  803dd4:	e9 f1 00 00 00       	jmp    803eca <free_block+0x290>
			//lw ms7to el pointer mydy34 ->
			struct BlockElement *next = LIST_NEXT(itr);
  803dd9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ddc:	8b 00                	mov    (%eax),%eax
  803dde:	89 45 dc             	mov    %eax,-0x24(%ebp)
			uint32 page_beginning_address= dynAllocStart + page_index * PAGE_SIZE;
  803de1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803de4:	c1 e0 0c             	shl    $0xc,%eax
  803de7:	89 c2                	mov    %eax,%edx
  803de9:	a1 64 d0 81 00       	mov    0x81d064,%eax
  803dee:	01 d0                	add    %edx,%eax
  803df0:	89 45 d8             	mov    %eax,-0x28(%ebp)
			uint32 page_end_address = dynAllocStart + (page_index +1 )* PAGE_SIZE;
  803df3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803df6:	40                   	inc    %eax
  803df7:	c1 e0 0c             	shl    $0xc,%eax
  803dfa:	89 c2                	mov    %eax,%edx
  803dfc:	a1 64 d0 81 00       	mov    0x81d064,%eax
  803e01:	01 d0                	add    %edx,%eax
  803e03:	89 45 d4             	mov    %eax,-0x2c(%ebp)

			if((uint32)itr >= page_beginning_address && (uint32)itr < page_end_address){
  803e06:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e09:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  803e0c:	0f 82 b8 00 00 00    	jb     803eca <free_block+0x290>
  803e12:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e15:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803e18:	0f 83 ac 00 00 00    	jae    803eca <free_block+0x290>
				LIST_REMOVE(&freeBlockLists[list_index], itr);
  803e1e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803e22:	75 17                	jne    803e3b <free_block+0x201>
  803e24:	83 ec 04             	sub    $0x4,%esp
  803e27:	68 6d 4e 80 00       	push   $0x804e6d
  803e2c:	68 e2 00 00 00       	push   $0xe2
  803e31:	68 33 4e 80 00       	push   $0x804e33
  803e36:	e8 50 c6 ff ff       	call   80048b <_panic>
  803e3b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e3e:	8b 00                	mov    (%eax),%eax
  803e40:	85 c0                	test   %eax,%eax
  803e42:	74 10                	je     803e54 <free_block+0x21a>
  803e44:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e47:	8b 00                	mov    (%eax),%eax
  803e49:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803e4c:	8b 52 04             	mov    0x4(%edx),%edx
  803e4f:	89 50 04             	mov    %edx,0x4(%eax)
  803e52:	eb 14                	jmp    803e68 <free_block+0x22e>
  803e54:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e57:	8b 40 04             	mov    0x4(%eax),%eax
  803e5a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803e5d:	c1 e2 04             	shl    $0x4,%edx
  803e60:	81 c2 84 d0 81 00    	add    $0x81d084,%edx
  803e66:	89 02                	mov    %eax,(%edx)
  803e68:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e6b:	8b 40 04             	mov    0x4(%eax),%eax
  803e6e:	85 c0                	test   %eax,%eax
  803e70:	74 0f                	je     803e81 <free_block+0x247>
  803e72:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e75:	8b 40 04             	mov    0x4(%eax),%eax
  803e78:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803e7b:	8b 12                	mov    (%edx),%edx
  803e7d:	89 10                	mov    %edx,(%eax)
  803e7f:	eb 13                	jmp    803e94 <free_block+0x25a>
  803e81:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e84:	8b 00                	mov    (%eax),%eax
  803e86:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803e89:	c1 e2 04             	shl    $0x4,%edx
  803e8c:	81 c2 80 d0 81 00    	add    $0x81d080,%edx
  803e92:	89 02                	mov    %eax,(%edx)
  803e94:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e97:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803e9d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ea0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803ea7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803eaa:	c1 e0 04             	shl    $0x4,%eax
  803ead:	05 8c d0 81 00       	add    $0x81d08c,%eax
  803eb2:	8b 00                	mov    (%eax),%eax
  803eb4:	8d 50 ff             	lea    -0x1(%eax),%edx
  803eb7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803eba:	c1 e0 04             	shl    $0x4,%eax
  803ebd:	05 8c d0 81 00       	add    $0x81d08c,%eax
  803ec2:	89 10                	mov    %edx,(%eax)
				//y5o4 3la elly b3do
				itr = next;
  803ec4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803ec7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// b3d ma wdytha fy el freeBlockLists hzwed elfree elly fy el array 1
	pageBlockInfoArr[page_index].num_of_free_blocks++;
	int blocks_number = PAGE_SIZE / block_size;
	if(pageBlockInfoArr[page_index].num_of_free_blocks == blocks_number){
		struct BlockElement *itr = LIST_FIRST(&freeBlockLists[list_index]);
		while(itr != NULL){
  803eca:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803ece:	0f 85 05 ff ff ff    	jne    803dd9 <free_block+0x19f>
				LIST_REMOVE(&freeBlockLists[list_index], itr);
				//y5o4 3la elly b3do
				itr = next;
			}
		}
		pageBlockInfoArr[page_index].block_size=0;
  803ed4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803ed7:	89 d0                	mov    %edx,%eax
  803ed9:	01 c0                	add    %eax,%eax
  803edb:	01 d0                	add    %edx,%eax
  803edd:	c1 e0 02             	shl    $0x2,%eax
  803ee0:	05 68 50 80 00       	add    $0x805068,%eax
  803ee5:	66 c7 00 00 00       	movw   $0x0,(%eax)
		pageBlockInfoArr[page_index].num_of_free_blocks=0;
  803eea:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803eed:	89 d0                	mov    %edx,%eax
  803eef:	01 c0                	add    %eax,%eax
  803ef1:	01 d0                	add    %edx,%eax
  803ef3:	c1 e0 02             	shl    $0x2,%eax
  803ef6:	05 6a 50 80 00       	add    $0x80506a,%eax
  803efb:	66 c7 00 00 00       	movw   $0x0,(%eax)

		struct PageInfoElement *page_info = &pageBlockInfoArr[page_index];
  803f00:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803f03:	89 d0                	mov    %edx,%eax
  803f05:	01 c0                	add    %eax,%eax
  803f07:	01 d0                	add    %edx,%eax
  803f09:	c1 e0 02             	shl    $0x2,%eax
  803f0c:	05 60 50 80 00       	add    $0x805060,%eax
  803f11:	89 45 d0             	mov    %eax,-0x30(%ebp)
		LIST_INSERT_TAIL(&freePagesList, page_info);
  803f14:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  803f18:	75 17                	jne    803f31 <free_block+0x2f7>
  803f1a:	83 ec 04             	sub    $0x4,%esp
  803f1d:	68 8c 4e 80 00       	push   $0x804e8c
  803f22:	68 eb 00 00 00       	push   $0xeb
  803f27:	68 33 4e 80 00       	push   $0x804e33
  803f2c:	e8 5a c5 ff ff       	call   80048b <_panic>
  803f31:	8b 15 4c 50 80 00    	mov    0x80504c,%edx
  803f37:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803f3a:	89 50 04             	mov    %edx,0x4(%eax)
  803f3d:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803f40:	8b 40 04             	mov    0x4(%eax),%eax
  803f43:	85 c0                	test   %eax,%eax
  803f45:	74 0c                	je     803f53 <free_block+0x319>
  803f47:	a1 4c 50 80 00       	mov    0x80504c,%eax
  803f4c:	8b 55 d0             	mov    -0x30(%ebp),%edx
  803f4f:	89 10                	mov    %edx,(%eax)
  803f51:	eb 08                	jmp    803f5b <free_block+0x321>
  803f53:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803f56:	a3 48 50 80 00       	mov    %eax,0x805048
  803f5b:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803f5e:	a3 4c 50 80 00       	mov    %eax,0x80504c
  803f63:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803f66:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803f6c:	a1 54 50 80 00       	mov    0x805054,%eax
  803f71:	40                   	inc    %eax
  803f72:	a3 54 50 80 00       	mov    %eax,0x805054
		uint32 page_va = to_page_va(page_info);
  803f77:	83 ec 0c             	sub    $0xc,%esp
  803f7a:	ff 75 d0             	pushl  -0x30(%ebp)
  803f7d:	e8 ce f5 ff ff       	call   803550 <to_page_va>
  803f82:	83 c4 10             	add    $0x10,%esp
  803f85:	89 45 cc             	mov    %eax,-0x34(%ebp)
		return_page((void *)page_va);
  803f88:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803f8b:	83 ec 0c             	sub    $0xc,%esp
  803f8e:	50                   	push   %eax
  803f8f:	e8 9e d7 ff ff       	call   801732 <return_page>
  803f94:	83 c4 10             	add    $0x10,%esp
	}


	//Comment the following line
	//panic("free_block() Not implemented yet");
}
  803f97:	90                   	nop
  803f98:	c9                   	leave  
  803f99:	c3                   	ret    

00803f9a <realloc_block>:

//===========================
// [1] REALLOCATE BLOCK:
//===========================
void *realloc_block(void* va, uint32 new_size)
{
  803f9a:	55                   	push   %ebp
  803f9b:	89 e5                	mov    %esp,%ebp
  803f9d:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.BONUS#2] KERNEL REALLOC - realloc_block
	//Your code is here
	//Comment the following line
	panic("realloc_block() Not implemented yet");
  803fa0:	83 ec 04             	sub    $0x4,%esp
  803fa3:	68 2c 4f 80 00       	push   $0x804f2c
  803fa8:	68 01 01 00 00       	push   $0x101
  803fad:	68 33 4e 80 00       	push   $0x804e33
  803fb2:	e8 d4 c4 ff ff       	call   80048b <_panic>

00803fb7 <init_uspinlock>:
#include "inc/uspinlock.h"

extern volatile struct Env *myEnv;

void init_uspinlock(struct uspinlock *lk, char *name, bool isOpened)
{
  803fb7:	55                   	push   %ebp
  803fb8:	89 e5                	mov    %esp,%ebp
  803fba:	83 ec 08             	sub    $0x8,%esp
	assert(isOpened == 0 || isOpened == 1);
  803fbd:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  803fc1:	74 1c                	je     803fdf <init_uspinlock+0x28>
  803fc3:	83 7d 10 01          	cmpl   $0x1,0x10(%ebp)
  803fc7:	74 16                	je     803fdf <init_uspinlock+0x28>
  803fc9:	68 50 4f 80 00       	push   $0x804f50
  803fce:	68 6f 4f 80 00       	push   $0x804f6f
  803fd3:	6a 10                	push   $0x10
  803fd5:	68 84 4f 80 00       	push   $0x804f84
  803fda:	e8 ac c4 ff ff       	call   80048b <_panic>
	strcpy(lk->name, name);
  803fdf:	8b 45 08             	mov    0x8(%ebp),%eax
  803fe2:	83 c0 04             	add    $0x4,%eax
  803fe5:	83 ec 08             	sub    $0x8,%esp
  803fe8:	ff 75 0c             	pushl  0xc(%ebp)
  803feb:	50                   	push   %eax
  803fec:	e8 90 ce ff ff       	call   800e81 <strcpy>
  803ff1:	83 c4 10             	add    $0x10,%esp
	lk->locked = (1 - isOpened);
  803ff4:	b8 01 00 00 00       	mov    $0x1,%eax
  803ff9:	2b 45 10             	sub    0x10(%ebp),%eax
  803ffc:	89 c2                	mov    %eax,%edx
  803ffe:	8b 45 08             	mov    0x8(%ebp),%eax
  804001:	89 10                	mov    %edx,(%eax)
}
  804003:	90                   	nop
  804004:	c9                   	leave  
  804005:	c3                   	ret    

00804006 <acquire_uspinlock>:
// Acquire the lock.
// Loops (spins) until the lock is acquired.
// Holding a lock for a long time may cause
// other CPUs to waste time spinning to acquire it.
void acquire_uspinlock(struct uspinlock *lk)
{
  804006:	55                   	push   %ebp
  804007:	89 e5                	mov    %esp,%ebp
  804009:	83 ec 18             	sub    $0x18,%esp
	// The xchg is atomic.
	while(xchg(&lk->locked, 1) != 0) ;
  80400c:	90                   	nop
  80400d:	8b 45 08             	mov    0x8(%ebp),%eax
  804010:	89 45 f4             	mov    %eax,-0xc(%ebp)
  804013:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
xchg(volatile uint32 *addr, uint32 newval)
{
  uint32 result;

  // The + in "+m" denotes a read-modify-write operand.
  __asm __volatile("lock; xchgl %0, %1" :
  80401a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80401d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804020:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  804023:	f0 87 02             	lock xchg %eax,(%edx)
  804026:	89 45 ec             	mov    %eax,-0x14(%ebp)
               "+m" (*addr), "=a" (result) :
               "1" (newval) :
               "cc");
  return result;
  804029:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80402c:	85 c0                	test   %eax,%eax
  80402e:	75 dd                	jne    80400d <acquire_uspinlock+0x7>

	cprintf("[%d: %s] ACQUIRED spinlock [%s]\n", myEnv->env_id, myEnv->prog_name, lk->name);
  804030:	8b 45 08             	mov    0x8(%ebp),%eax
  804033:	8d 48 04             	lea    0x4(%eax),%ecx
  804036:	a1 20 50 80 00       	mov    0x805020,%eax
  80403b:	8d 50 20             	lea    0x20(%eax),%edx
  80403e:	a1 20 50 80 00       	mov    0x805020,%eax
  804043:	8b 40 10             	mov    0x10(%eax),%eax
  804046:	51                   	push   %ecx
  804047:	52                   	push   %edx
  804048:	50                   	push   %eax
  804049:	68 94 4f 80 00       	push   $0x804f94
  80404e:	e8 06 c7 ff ff       	call   800759 <cprintf>
  804053:	83 c4 10             	add    $0x10,%esp

	// Tell the C compiler and the processor to not move loads or stores
	// past this point, to ensure that the critical section's memory
	// references happen after the lock is acquired.
	__sync_synchronize();
  804056:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
}
  80405b:	90                   	nop
  80405c:	c9                   	leave  
  80405d:	c3                   	ret    

0080405e <release_uspinlock>:

// Release the lock.
void release_uspinlock(struct uspinlock *lk)
{
  80405e:	55                   	push   %ebp
  80405f:	89 e5                	mov    %esp,%ebp
  804061:	83 ec 08             	sub    $0x8,%esp
	if(!(lk->locked))
  804064:	8b 45 08             	mov    0x8(%ebp),%eax
  804067:	8b 00                	mov    (%eax),%eax
  804069:	85 c0                	test   %eax,%eax
  80406b:	75 18                	jne    804085 <release_uspinlock+0x27>
	{
		panic("release: lock \"%s\" is not held!", lk->name);
  80406d:	8b 45 08             	mov    0x8(%ebp),%eax
  804070:	83 c0 04             	add    $0x4,%eax
  804073:	50                   	push   %eax
  804074:	68 b8 4f 80 00       	push   $0x804fb8
  804079:	6a 2b                	push   $0x2b
  80407b:	68 84 4f 80 00       	push   $0x804f84
  804080:	e8 06 c4 ff ff       	call   80048b <_panic>
	// Tell the C compiler and the processor to not move loads or stores
	// past this point, to ensure that all the stores in the critical
	// section are visible to other cores before the lock is released.
	// Both the C compiler and the hardware may re-order loads and
	// stores; __sync_synchronize() tells them both not to.
	__sync_synchronize();
  804085:	f0 83 0c 24 00       	lock orl $0x0,(%esp)

	// Release the lock, equivalent to lk->locked = 0.
	// This code can't use a C assignment, since it might
	// not be atomic. A real OS would use C atomics here.
	asm volatile("movl $0, %0" : "+m" (lk->locked) : );
  80408a:	8b 45 08             	mov    0x8(%ebp),%eax
  80408d:	8b 55 08             	mov    0x8(%ebp),%edx
  804090:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	cprintf("[%d: %s] RELEASED spinlock [%s]\n", myEnv->env_id, myEnv->prog_name, lk->name);
  804096:	8b 45 08             	mov    0x8(%ebp),%eax
  804099:	8d 48 04             	lea    0x4(%eax),%ecx
  80409c:	a1 20 50 80 00       	mov    0x805020,%eax
  8040a1:	8d 50 20             	lea    0x20(%eax),%edx
  8040a4:	a1 20 50 80 00       	mov    0x805020,%eax
  8040a9:	8b 40 10             	mov    0x10(%eax),%eax
  8040ac:	51                   	push   %ecx
  8040ad:	52                   	push   %edx
  8040ae:	50                   	push   %eax
  8040af:	68 d8 4f 80 00       	push   $0x804fd8
  8040b4:	e8 a0 c6 ff ff       	call   800759 <cprintf>
  8040b9:	83 c4 10             	add    $0x10,%esp
}
  8040bc:	90                   	nop
  8040bd:	c9                   	leave  
  8040be:	c3                   	ret    
  8040bf:	90                   	nop

008040c0 <__udivdi3>:
  8040c0:	55                   	push   %ebp
  8040c1:	57                   	push   %edi
  8040c2:	56                   	push   %esi
  8040c3:	53                   	push   %ebx
  8040c4:	83 ec 1c             	sub    $0x1c,%esp
  8040c7:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8040cb:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8040cf:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8040d3:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8040d7:	89 ca                	mov    %ecx,%edx
  8040d9:	89 f8                	mov    %edi,%eax
  8040db:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8040df:	85 f6                	test   %esi,%esi
  8040e1:	75 2d                	jne    804110 <__udivdi3+0x50>
  8040e3:	39 cf                	cmp    %ecx,%edi
  8040e5:	77 65                	ja     80414c <__udivdi3+0x8c>
  8040e7:	89 fd                	mov    %edi,%ebp
  8040e9:	85 ff                	test   %edi,%edi
  8040eb:	75 0b                	jne    8040f8 <__udivdi3+0x38>
  8040ed:	b8 01 00 00 00       	mov    $0x1,%eax
  8040f2:	31 d2                	xor    %edx,%edx
  8040f4:	f7 f7                	div    %edi
  8040f6:	89 c5                	mov    %eax,%ebp
  8040f8:	31 d2                	xor    %edx,%edx
  8040fa:	89 c8                	mov    %ecx,%eax
  8040fc:	f7 f5                	div    %ebp
  8040fe:	89 c1                	mov    %eax,%ecx
  804100:	89 d8                	mov    %ebx,%eax
  804102:	f7 f5                	div    %ebp
  804104:	89 cf                	mov    %ecx,%edi
  804106:	89 fa                	mov    %edi,%edx
  804108:	83 c4 1c             	add    $0x1c,%esp
  80410b:	5b                   	pop    %ebx
  80410c:	5e                   	pop    %esi
  80410d:	5f                   	pop    %edi
  80410e:	5d                   	pop    %ebp
  80410f:	c3                   	ret    
  804110:	39 ce                	cmp    %ecx,%esi
  804112:	77 28                	ja     80413c <__udivdi3+0x7c>
  804114:	0f bd fe             	bsr    %esi,%edi
  804117:	83 f7 1f             	xor    $0x1f,%edi
  80411a:	75 40                	jne    80415c <__udivdi3+0x9c>
  80411c:	39 ce                	cmp    %ecx,%esi
  80411e:	72 0a                	jb     80412a <__udivdi3+0x6a>
  804120:	3b 44 24 08          	cmp    0x8(%esp),%eax
  804124:	0f 87 9e 00 00 00    	ja     8041c8 <__udivdi3+0x108>
  80412a:	b8 01 00 00 00       	mov    $0x1,%eax
  80412f:	89 fa                	mov    %edi,%edx
  804131:	83 c4 1c             	add    $0x1c,%esp
  804134:	5b                   	pop    %ebx
  804135:	5e                   	pop    %esi
  804136:	5f                   	pop    %edi
  804137:	5d                   	pop    %ebp
  804138:	c3                   	ret    
  804139:	8d 76 00             	lea    0x0(%esi),%esi
  80413c:	31 ff                	xor    %edi,%edi
  80413e:	31 c0                	xor    %eax,%eax
  804140:	89 fa                	mov    %edi,%edx
  804142:	83 c4 1c             	add    $0x1c,%esp
  804145:	5b                   	pop    %ebx
  804146:	5e                   	pop    %esi
  804147:	5f                   	pop    %edi
  804148:	5d                   	pop    %ebp
  804149:	c3                   	ret    
  80414a:	66 90                	xchg   %ax,%ax
  80414c:	89 d8                	mov    %ebx,%eax
  80414e:	f7 f7                	div    %edi
  804150:	31 ff                	xor    %edi,%edi
  804152:	89 fa                	mov    %edi,%edx
  804154:	83 c4 1c             	add    $0x1c,%esp
  804157:	5b                   	pop    %ebx
  804158:	5e                   	pop    %esi
  804159:	5f                   	pop    %edi
  80415a:	5d                   	pop    %ebp
  80415b:	c3                   	ret    
  80415c:	bd 20 00 00 00       	mov    $0x20,%ebp
  804161:	89 eb                	mov    %ebp,%ebx
  804163:	29 fb                	sub    %edi,%ebx
  804165:	89 f9                	mov    %edi,%ecx
  804167:	d3 e6                	shl    %cl,%esi
  804169:	89 c5                	mov    %eax,%ebp
  80416b:	88 d9                	mov    %bl,%cl
  80416d:	d3 ed                	shr    %cl,%ebp
  80416f:	89 e9                	mov    %ebp,%ecx
  804171:	09 f1                	or     %esi,%ecx
  804173:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  804177:	89 f9                	mov    %edi,%ecx
  804179:	d3 e0                	shl    %cl,%eax
  80417b:	89 c5                	mov    %eax,%ebp
  80417d:	89 d6                	mov    %edx,%esi
  80417f:	88 d9                	mov    %bl,%cl
  804181:	d3 ee                	shr    %cl,%esi
  804183:	89 f9                	mov    %edi,%ecx
  804185:	d3 e2                	shl    %cl,%edx
  804187:	8b 44 24 08          	mov    0x8(%esp),%eax
  80418b:	88 d9                	mov    %bl,%cl
  80418d:	d3 e8                	shr    %cl,%eax
  80418f:	09 c2                	or     %eax,%edx
  804191:	89 d0                	mov    %edx,%eax
  804193:	89 f2                	mov    %esi,%edx
  804195:	f7 74 24 0c          	divl   0xc(%esp)
  804199:	89 d6                	mov    %edx,%esi
  80419b:	89 c3                	mov    %eax,%ebx
  80419d:	f7 e5                	mul    %ebp
  80419f:	39 d6                	cmp    %edx,%esi
  8041a1:	72 19                	jb     8041bc <__udivdi3+0xfc>
  8041a3:	74 0b                	je     8041b0 <__udivdi3+0xf0>
  8041a5:	89 d8                	mov    %ebx,%eax
  8041a7:	31 ff                	xor    %edi,%edi
  8041a9:	e9 58 ff ff ff       	jmp    804106 <__udivdi3+0x46>
  8041ae:	66 90                	xchg   %ax,%ax
  8041b0:	8b 54 24 08          	mov    0x8(%esp),%edx
  8041b4:	89 f9                	mov    %edi,%ecx
  8041b6:	d3 e2                	shl    %cl,%edx
  8041b8:	39 c2                	cmp    %eax,%edx
  8041ba:	73 e9                	jae    8041a5 <__udivdi3+0xe5>
  8041bc:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8041bf:	31 ff                	xor    %edi,%edi
  8041c1:	e9 40 ff ff ff       	jmp    804106 <__udivdi3+0x46>
  8041c6:	66 90                	xchg   %ax,%ax
  8041c8:	31 c0                	xor    %eax,%eax
  8041ca:	e9 37 ff ff ff       	jmp    804106 <__udivdi3+0x46>
  8041cf:	90                   	nop

008041d0 <__umoddi3>:
  8041d0:	55                   	push   %ebp
  8041d1:	57                   	push   %edi
  8041d2:	56                   	push   %esi
  8041d3:	53                   	push   %ebx
  8041d4:	83 ec 1c             	sub    $0x1c,%esp
  8041d7:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8041db:	8b 74 24 34          	mov    0x34(%esp),%esi
  8041df:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8041e3:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8041e7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8041eb:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8041ef:	89 f3                	mov    %esi,%ebx
  8041f1:	89 fa                	mov    %edi,%edx
  8041f3:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8041f7:	89 34 24             	mov    %esi,(%esp)
  8041fa:	85 c0                	test   %eax,%eax
  8041fc:	75 1a                	jne    804218 <__umoddi3+0x48>
  8041fe:	39 f7                	cmp    %esi,%edi
  804200:	0f 86 a2 00 00 00    	jbe    8042a8 <__umoddi3+0xd8>
  804206:	89 c8                	mov    %ecx,%eax
  804208:	89 f2                	mov    %esi,%edx
  80420a:	f7 f7                	div    %edi
  80420c:	89 d0                	mov    %edx,%eax
  80420e:	31 d2                	xor    %edx,%edx
  804210:	83 c4 1c             	add    $0x1c,%esp
  804213:	5b                   	pop    %ebx
  804214:	5e                   	pop    %esi
  804215:	5f                   	pop    %edi
  804216:	5d                   	pop    %ebp
  804217:	c3                   	ret    
  804218:	39 f0                	cmp    %esi,%eax
  80421a:	0f 87 ac 00 00 00    	ja     8042cc <__umoddi3+0xfc>
  804220:	0f bd e8             	bsr    %eax,%ebp
  804223:	83 f5 1f             	xor    $0x1f,%ebp
  804226:	0f 84 ac 00 00 00    	je     8042d8 <__umoddi3+0x108>
  80422c:	bf 20 00 00 00       	mov    $0x20,%edi
  804231:	29 ef                	sub    %ebp,%edi
  804233:	89 fe                	mov    %edi,%esi
  804235:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  804239:	89 e9                	mov    %ebp,%ecx
  80423b:	d3 e0                	shl    %cl,%eax
  80423d:	89 d7                	mov    %edx,%edi
  80423f:	89 f1                	mov    %esi,%ecx
  804241:	d3 ef                	shr    %cl,%edi
  804243:	09 c7                	or     %eax,%edi
  804245:	89 e9                	mov    %ebp,%ecx
  804247:	d3 e2                	shl    %cl,%edx
  804249:	89 14 24             	mov    %edx,(%esp)
  80424c:	89 d8                	mov    %ebx,%eax
  80424e:	d3 e0                	shl    %cl,%eax
  804250:	89 c2                	mov    %eax,%edx
  804252:	8b 44 24 08          	mov    0x8(%esp),%eax
  804256:	d3 e0                	shl    %cl,%eax
  804258:	89 44 24 04          	mov    %eax,0x4(%esp)
  80425c:	8b 44 24 08          	mov    0x8(%esp),%eax
  804260:	89 f1                	mov    %esi,%ecx
  804262:	d3 e8                	shr    %cl,%eax
  804264:	09 d0                	or     %edx,%eax
  804266:	d3 eb                	shr    %cl,%ebx
  804268:	89 da                	mov    %ebx,%edx
  80426a:	f7 f7                	div    %edi
  80426c:	89 d3                	mov    %edx,%ebx
  80426e:	f7 24 24             	mull   (%esp)
  804271:	89 c6                	mov    %eax,%esi
  804273:	89 d1                	mov    %edx,%ecx
  804275:	39 d3                	cmp    %edx,%ebx
  804277:	0f 82 87 00 00 00    	jb     804304 <__umoddi3+0x134>
  80427d:	0f 84 91 00 00 00    	je     804314 <__umoddi3+0x144>
  804283:	8b 54 24 04          	mov    0x4(%esp),%edx
  804287:	29 f2                	sub    %esi,%edx
  804289:	19 cb                	sbb    %ecx,%ebx
  80428b:	89 d8                	mov    %ebx,%eax
  80428d:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  804291:	d3 e0                	shl    %cl,%eax
  804293:	89 e9                	mov    %ebp,%ecx
  804295:	d3 ea                	shr    %cl,%edx
  804297:	09 d0                	or     %edx,%eax
  804299:	89 e9                	mov    %ebp,%ecx
  80429b:	d3 eb                	shr    %cl,%ebx
  80429d:	89 da                	mov    %ebx,%edx
  80429f:	83 c4 1c             	add    $0x1c,%esp
  8042a2:	5b                   	pop    %ebx
  8042a3:	5e                   	pop    %esi
  8042a4:	5f                   	pop    %edi
  8042a5:	5d                   	pop    %ebp
  8042a6:	c3                   	ret    
  8042a7:	90                   	nop
  8042a8:	89 fd                	mov    %edi,%ebp
  8042aa:	85 ff                	test   %edi,%edi
  8042ac:	75 0b                	jne    8042b9 <__umoddi3+0xe9>
  8042ae:	b8 01 00 00 00       	mov    $0x1,%eax
  8042b3:	31 d2                	xor    %edx,%edx
  8042b5:	f7 f7                	div    %edi
  8042b7:	89 c5                	mov    %eax,%ebp
  8042b9:	89 f0                	mov    %esi,%eax
  8042bb:	31 d2                	xor    %edx,%edx
  8042bd:	f7 f5                	div    %ebp
  8042bf:	89 c8                	mov    %ecx,%eax
  8042c1:	f7 f5                	div    %ebp
  8042c3:	89 d0                	mov    %edx,%eax
  8042c5:	e9 44 ff ff ff       	jmp    80420e <__umoddi3+0x3e>
  8042ca:	66 90                	xchg   %ax,%ax
  8042cc:	89 c8                	mov    %ecx,%eax
  8042ce:	89 f2                	mov    %esi,%edx
  8042d0:	83 c4 1c             	add    $0x1c,%esp
  8042d3:	5b                   	pop    %ebx
  8042d4:	5e                   	pop    %esi
  8042d5:	5f                   	pop    %edi
  8042d6:	5d                   	pop    %ebp
  8042d7:	c3                   	ret    
  8042d8:	3b 04 24             	cmp    (%esp),%eax
  8042db:	72 06                	jb     8042e3 <__umoddi3+0x113>
  8042dd:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8042e1:	77 0f                	ja     8042f2 <__umoddi3+0x122>
  8042e3:	89 f2                	mov    %esi,%edx
  8042e5:	29 f9                	sub    %edi,%ecx
  8042e7:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8042eb:	89 14 24             	mov    %edx,(%esp)
  8042ee:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8042f2:	8b 44 24 04          	mov    0x4(%esp),%eax
  8042f6:	8b 14 24             	mov    (%esp),%edx
  8042f9:	83 c4 1c             	add    $0x1c,%esp
  8042fc:	5b                   	pop    %ebx
  8042fd:	5e                   	pop    %esi
  8042fe:	5f                   	pop    %edi
  8042ff:	5d                   	pop    %ebp
  804300:	c3                   	ret    
  804301:	8d 76 00             	lea    0x0(%esi),%esi
  804304:	2b 04 24             	sub    (%esp),%eax
  804307:	19 fa                	sbb    %edi,%edx
  804309:	89 d1                	mov    %edx,%ecx
  80430b:	89 c6                	mov    %eax,%esi
  80430d:	e9 71 ff ff ff       	jmp    804283 <__umoddi3+0xb3>
  804312:	66 90                	xchg   %ax,%ax
  804314:	39 44 24 04          	cmp    %eax,0x4(%esp)
  804318:	72 ea                	jb     804304 <__umoddi3+0x134>
  80431a:	89 d9                	mov    %ebx,%ecx
  80431c:	e9 62 ff ff ff       	jmp    804283 <__umoddi3+0xb3>
