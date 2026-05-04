
obj/user/tst_envfree1:     file format elf32-i386


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
  800031:	e8 c1 02 00 00       	call   8002f7 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
// Scenario that tests environment free run tef1 5 3
#include <inc/lib.h>

void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	57                   	push   %edi
  80003c:	56                   	push   %esi
  80003d:	53                   	push   %ebx
  80003e:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
	rsttst();
  800044:	e8 e0 19 00 00       	call   801a29 <rsttst>
	// Testing scenario 1: without using dynamic allocation/de-allocation, shared variables and semaphores
	// Testing removing the allocated pages in mem, WS, mapped page tables, env's directory and env's page file

	char getksbrkCmd[100] = "__getKernelSBreak__";
  800049:	8d 85 54 ff ff ff    	lea    -0xac(%ebp),%eax
  80004f:	bb a1 20 80 00       	mov    $0x8020a1,%ebx
  800054:	ba 05 00 00 00       	mov    $0x5,%edx
  800059:	89 c7                	mov    %eax,%edi
  80005b:	89 de                	mov    %ebx,%esi
  80005d:	89 d1                	mov    %edx,%ecx
  80005f:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800061:	8d 95 68 ff ff ff    	lea    -0x98(%ebp),%edx
  800067:	b9 14 00 00 00       	mov    $0x14,%ecx
  80006c:	b8 00 00 00 00       	mov    $0x0,%eax
  800071:	89 d7                	mov    %edx,%edi
  800073:	f3 ab                	rep stos %eax,%es:(%edi)
	uint32 ksbrk_before ;
	sys_utilities(getksbrkCmd, (uint32)&ksbrk_before);
  800075:	8d 85 50 ff ff ff    	lea    -0xb0(%ebp),%eax
  80007b:	83 ec 08             	sub    $0x8,%esp
  80007e:	50                   	push   %eax
  80007f:	8d 85 54 ff ff ff    	lea    -0xac(%ebp),%eax
  800085:	50                   	push   %eax
  800086:	e8 f6 1a 00 00       	call   801b81 <sys_utilities>
  80008b:	83 c4 10             	add    $0x10,%esp

	int freeFrames_before = sys_calculate_free_frames() ;
  80008e:	e8 ef 16 00 00       	call   801782 <sys_calculate_free_frames>
  800093:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	int usedDiskPages_before = sys_pf_calculate_allocated_pages() ;
  800096:	e8 32 17 00 00       	call   8017cd <sys_pf_calculate_allocated_pages>
  80009b:	89 45 e0             	mov    %eax,-0x20(%ebp)
	cprintf("\n---# of free frames before running programs = %d\n", freeFrames_before);
  80009e:	83 ec 08             	sub    $0x8,%esp
  8000a1:	ff 75 e4             	pushl  -0x1c(%ebp)
  8000a4:	68 80 1e 80 00       	push   $0x801e80
  8000a9:	e8 d0 06 00 00       	call   80077e <cprintf>
  8000ae:	83 c4 10             	add    $0x10,%esp

	/*[4] CREATE AND RUN ProcessA & ProcessB*/
	//Create 3 processes

	int32 envIdProcessA = sys_create_env("sc_fib_recursive", (myEnv->page_WS_max_size),(myEnv->SecondListSize), 50);
  8000b1:	a1 20 30 80 00       	mov    0x803020,%eax
  8000b6:	8b 80 a0 05 00 00    	mov    0x5a0(%eax),%eax
  8000bc:	89 c2                	mov    %eax,%edx
  8000be:	a1 20 30 80 00       	mov    0x803020,%eax
  8000c3:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  8000c9:	6a 32                	push   $0x32
  8000cb:	52                   	push   %edx
  8000cc:	50                   	push   %eax
  8000cd:	68 b3 1e 80 00       	push   $0x801eb3
  8000d2:	e8 06 18 00 00       	call   8018dd <sys_create_env>
  8000d7:	83 c4 10             	add    $0x10,%esp
  8000da:	89 45 dc             	mov    %eax,-0x24(%ebp)
	int32 envIdProcessB = sys_create_env("sc_fact_recursive", (myEnv->page_WS_max_size)*4,(myEnv->SecondListSize), 50);
  8000dd:	a1 20 30 80 00       	mov    0x803020,%eax
  8000e2:	8b 80 a0 05 00 00    	mov    0x5a0(%eax),%eax
  8000e8:	89 c2                	mov    %eax,%edx
  8000ea:	a1 20 30 80 00       	mov    0x803020,%eax
  8000ef:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  8000f5:	c1 e0 02             	shl    $0x2,%eax
  8000f8:	6a 32                	push   $0x32
  8000fa:	52                   	push   %edx
  8000fb:	50                   	push   %eax
  8000fc:	68 c4 1e 80 00       	push   $0x801ec4
  800101:	e8 d7 17 00 00       	call   8018dd <sys_create_env>
  800106:	83 c4 10             	add    $0x10,%esp
  800109:	89 45 d8             	mov    %eax,-0x28(%ebp)
	int32 envIdProcessC = sys_create_env("sc_fos_add",(myEnv->page_WS_max_size),(myEnv->SecondListSize), 50);
  80010c:	a1 20 30 80 00       	mov    0x803020,%eax
  800111:	8b 80 a0 05 00 00    	mov    0x5a0(%eax),%eax
  800117:	89 c2                	mov    %eax,%edx
  800119:	a1 20 30 80 00       	mov    0x803020,%eax
  80011e:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  800124:	6a 32                	push   $0x32
  800126:	52                   	push   %edx
  800127:	50                   	push   %eax
  800128:	68 d6 1e 80 00       	push   $0x801ed6
  80012d:	e8 ab 17 00 00       	call   8018dd <sys_create_env>
  800132:	83 c4 10             	add    $0x10,%esp
  800135:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	//Run 3 processes
	sys_run_env(envIdProcessA);
  800138:	83 ec 0c             	sub    $0xc,%esp
  80013b:	ff 75 dc             	pushl  -0x24(%ebp)
  80013e:	e8 b8 17 00 00       	call   8018fb <sys_run_env>
  800143:	83 c4 10             	add    $0x10,%esp
	sys_run_env(envIdProcessB);
  800146:	83 ec 0c             	sub    $0xc,%esp
  800149:	ff 75 d8             	pushl  -0x28(%ebp)
  80014c:	e8 aa 17 00 00       	call   8018fb <sys_run_env>
  800151:	83 c4 10             	add    $0x10,%esp
	sys_run_env(envIdProcessC);
  800154:	83 ec 0c             	sub    $0xc,%esp
  800157:	ff 75 d4             	pushl  -0x2c(%ebp)
  80015a:	e8 9c 17 00 00       	call   8018fb <sys_run_env>
  80015f:	83 c4 10             	add    $0x10,%esp

	//env_sleep(6000);
	while (gettst() != 3) ;
  800162:	90                   	nop
  800163:	e8 3b 19 00 00       	call   801aa3 <gettst>
  800168:	83 f8 03             	cmp    $0x3,%eax
  80016b:	75 f6                	jne    800163 <_main+0x12b>

	cprintf("\n---# of free frames after running programs = %d\n", sys_calculate_free_frames());
  80016d:	e8 10 16 00 00       	call   801782 <sys_calculate_free_frames>
  800172:	83 ec 08             	sub    $0x8,%esp
  800175:	50                   	push   %eax
  800176:	68 e4 1e 80 00       	push   $0x801ee4
  80017b:	e8 fe 05 00 00       	call   80077e <cprintf>
  800180:	83 c4 10             	add    $0x10,%esp

	uint32 ksbrk_after ;
	sys_utilities(getksbrkCmd, (uint32)&ksbrk_after);
  800183:	8d 85 4c ff ff ff    	lea    -0xb4(%ebp),%eax
  800189:	83 ec 08             	sub    $0x8,%esp
  80018c:	50                   	push   %eax
  80018d:	8d 85 54 ff ff ff    	lea    -0xac(%ebp),%eax
  800193:	50                   	push   %eax
  800194:	e8 e8 19 00 00       	call   801b81 <sys_utilities>
  800199:	83 c4 10             	add    $0x10,%esp
	//Kill the 3 processes
	//DISABLE the interrupt to ensure the env_free is done as a whole without preemption
	//to avoid context switch (due to clock interrupt) while freeing the env to prevent:
	//	1. context switching to a wrong process specially in the part of temporarily switching the CPU process for freeing shared variables
	//	2. changing the # free frames
	char changeIntCmd[100] = "__changeInterruptStatus__";
  80019c:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  8001a2:	bb 05 21 80 00       	mov    $0x802105,%ebx
  8001a7:	ba 1a 00 00 00       	mov    $0x1a,%edx
  8001ac:	89 c7                	mov    %eax,%edi
  8001ae:	89 de                	mov    %ebx,%esi
  8001b0:	89 d1                	mov    %edx,%ecx
  8001b2:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  8001b4:	8d 95 02 ff ff ff    	lea    -0xfe(%ebp),%edx
  8001ba:	b9 4a 00 00 00       	mov    $0x4a,%ecx
  8001bf:	b0 00                	mov    $0x0,%al
  8001c1:	89 d7                	mov    %edx,%edi
  8001c3:	f3 aa                	rep stos %al,%es:(%edi)
	sys_utilities(changeIntCmd, 0);
  8001c5:	83 ec 08             	sub    $0x8,%esp
  8001c8:	6a 00                	push   $0x0
  8001ca:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  8001d0:	50                   	push   %eax
  8001d1:	e8 ab 19 00 00       	call   801b81 <sys_utilities>
  8001d6:	83 c4 10             	add    $0x10,%esp
	{
		sys_destroy_env(envIdProcessA);
  8001d9:	83 ec 0c             	sub    $0xc,%esp
  8001dc:	ff 75 dc             	pushl  -0x24(%ebp)
  8001df:	e8 33 17 00 00       	call   801917 <sys_destroy_env>
  8001e4:	83 c4 10             	add    $0x10,%esp
		sys_destroy_env(envIdProcessB);
  8001e7:	83 ec 0c             	sub    $0xc,%esp
  8001ea:	ff 75 d8             	pushl  -0x28(%ebp)
  8001ed:	e8 25 17 00 00       	call   801917 <sys_destroy_env>
  8001f2:	83 c4 10             	add    $0x10,%esp
		sys_destroy_env(envIdProcessC);
  8001f5:	83 ec 0c             	sub    $0xc,%esp
  8001f8:	ff 75 d4             	pushl  -0x2c(%ebp)
  8001fb:	e8 17 17 00 00       	call   801917 <sys_destroy_env>
  800200:	83 c4 10             	add    $0x10,%esp
	}
	sys_utilities(changeIntCmd, 1);
  800203:	83 ec 08             	sub    $0x8,%esp
  800206:	6a 01                	push   $0x1
  800208:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  80020e:	50                   	push   %eax
  80020f:	e8 6d 19 00 00       	call   801b81 <sys_utilities>
  800214:	83 c4 10             	add    $0x10,%esp

	//Checking the number of frames after killing the created environments
	int freeFrames_after = sys_calculate_free_frames() ;
  800217:	e8 66 15 00 00       	call   801782 <sys_calculate_free_frames>
  80021c:	89 45 d0             	mov    %eax,-0x30(%ebp)
	int usedDiskPages_after = sys_pf_calculate_allocated_pages() ;
  80021f:	e8 a9 15 00 00       	call   8017cd <sys_pf_calculate_allocated_pages>
  800224:	89 45 cc             	mov    %eax,-0x34(%ebp)

	cprintf("\n---# of free frames after KILLING programs = %d\n", sys_calculate_free_frames());
  800227:	e8 56 15 00 00       	call   801782 <sys_calculate_free_frames>
  80022c:	83 ec 08             	sub    $0x8,%esp
  80022f:	50                   	push   %eax
  800230:	68 18 1f 80 00       	push   $0x801f18
  800235:	e8 44 05 00 00       	call   80077e <cprintf>
  80023a:	83 c4 10             	add    $0x10,%esp

	int expected = (ROUNDUP((uint32)ksbrk_after, PAGE_SIZE) - ROUNDUP((uint32)ksbrk_before, PAGE_SIZE)) / PAGE_SIZE;
  80023d:	c7 45 c8 00 10 00 00 	movl   $0x1000,-0x38(%ebp)
  800244:	8b 95 4c ff ff ff    	mov    -0xb4(%ebp),%edx
  80024a:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80024d:	01 d0                	add    %edx,%eax
  80024f:	48                   	dec    %eax
  800250:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  800253:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  800256:	ba 00 00 00 00       	mov    $0x0,%edx
  80025b:	f7 75 c8             	divl   -0x38(%ebp)
  80025e:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  800261:	29 d0                	sub    %edx,%eax
  800263:	89 c1                	mov    %eax,%ecx
  800265:	c7 45 c0 00 10 00 00 	movl   $0x1000,-0x40(%ebp)
  80026c:	8b 95 50 ff ff ff    	mov    -0xb0(%ebp),%edx
  800272:	8b 45 c0             	mov    -0x40(%ebp),%eax
  800275:	01 d0                	add    %edx,%eax
  800277:	48                   	dec    %eax
  800278:	89 45 bc             	mov    %eax,-0x44(%ebp)
  80027b:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80027e:	ba 00 00 00 00       	mov    $0x0,%edx
  800283:	f7 75 c0             	divl   -0x40(%ebp)
  800286:	8b 45 bc             	mov    -0x44(%ebp),%eax
  800289:	29 d0                	sub    %edx,%eax
  80028b:	29 c1                	sub    %eax,%ecx
  80028d:	89 c8                	mov    %ecx,%eax
  80028f:	c1 e8 0c             	shr    $0xc,%eax
  800292:	89 45 b8             	mov    %eax,-0x48(%ebp)
	if ((freeFrames_before - freeFrames_after) != expected) {
  800295:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800298:	2b 45 d0             	sub    -0x30(%ebp),%eax
  80029b:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  80029e:	74 2e                	je     8002ce <_main+0x296>
		cprintf("\n---# of free frames after closing running programs not as before running = %d\ndifference = %d, expected = %d\n",
  8002a0:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8002a3:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  8002a6:	ff 75 b8             	pushl  -0x48(%ebp)
  8002a9:	50                   	push   %eax
  8002aa:	ff 75 d0             	pushl  -0x30(%ebp)
  8002ad:	68 4c 1f 80 00       	push   $0x801f4c
  8002b2:	e8 c7 04 00 00       	call   80077e <cprintf>
  8002b7:	83 c4 10             	add    $0x10,%esp
				freeFrames_after, freeFrames_after - freeFrames_before, expected);
		panic("env_free() does not work correctly... check it again.");
  8002ba:	83 ec 04             	sub    $0x4,%esp
  8002bd:	68 bc 1f 80 00       	push   $0x801fbc
  8002c2:	6a 3e                	push   $0x3e
  8002c4:	68 f2 1f 80 00       	push   $0x801ff2
  8002c9:	e8 e2 01 00 00       	call   8004b0 <_panic>
	}

	cprintf("\n---# of free frames after closing running programs returned back as expected\n");
  8002ce:	83 ec 0c             	sub    $0xc,%esp
  8002d1:	68 08 20 80 00       	push   $0x802008
  8002d6:	e8 a3 04 00 00       	call   80077e <cprintf>
  8002db:	83 c4 10             	add    $0x10,%esp

	cprintf("\n\nCongratulations!! test scenario 1 for envfree completed successfully.\n");
  8002de:	83 ec 0c             	sub    $0xc,%esp
  8002e1:	68 58 20 80 00       	push   $0x802058
  8002e6:	e8 93 04 00 00       	call   80077e <cprintf>
  8002eb:	83 c4 10             	add    $0x10,%esp
	return;
  8002ee:	90                   	nop
}
  8002ef:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002f2:	5b                   	pop    %ebx
  8002f3:	5e                   	pop    %esi
  8002f4:	5f                   	pop    %edi
  8002f5:	5d                   	pop    %ebp
  8002f6:	c3                   	ret    

008002f7 <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  8002f7:	55                   	push   %ebp
  8002f8:	89 e5                	mov    %esp,%ebp
  8002fa:	57                   	push   %edi
  8002fb:	56                   	push   %esi
  8002fc:	53                   	push   %ebx
  8002fd:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  800300:	e8 46 16 00 00       	call   80194b <sys_getenvindex>
  800305:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  800308:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80030b:	89 d0                	mov    %edx,%eax
  80030d:	c1 e0 02             	shl    $0x2,%eax
  800310:	01 d0                	add    %edx,%eax
  800312:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800319:	01 d0                	add    %edx,%eax
  80031b:	89 c2                	mov    %eax,%edx
  80031d:	c1 e2 04             	shl    $0x4,%edx
  800320:	29 c2                	sub    %eax,%edx
  800322:	8d 04 95 00 00 00 00 	lea    0x0(,%edx,4),%eax
  800329:	89 c2                	mov    %eax,%edx
  80032b:	8d 82 00 00 c0 ee    	lea    -0x11400000(%edx),%eax
  800331:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800336:	a1 20 30 80 00       	mov    0x803020,%eax
  80033b:	8a 40 20             	mov    0x20(%eax),%al
  80033e:	84 c0                	test   %al,%al
  800340:	74 0d                	je     80034f <libmain+0x58>
		binaryname = myEnv->prog_name;
  800342:	a1 20 30 80 00       	mov    0x803020,%eax
  800347:	83 c0 20             	add    $0x20,%eax
  80034a:	a3 04 30 80 00       	mov    %eax,0x803004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80034f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800353:	7e 0a                	jle    80035f <libmain+0x68>
		binaryname = argv[0];
  800355:	8b 45 0c             	mov    0xc(%ebp),%eax
  800358:	8b 00                	mov    (%eax),%eax
  80035a:	a3 04 30 80 00       	mov    %eax,0x803004

	// call user main routine
	_main(argc, argv);
  80035f:	83 ec 08             	sub    $0x8,%esp
  800362:	ff 75 0c             	pushl  0xc(%ebp)
  800365:	ff 75 08             	pushl  0x8(%ebp)
  800368:	e8 cb fc ff ff       	call   800038 <_main>
  80036d:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  800370:	a1 00 30 80 00       	mov    0x803000,%eax
  800375:	85 c0                	test   %eax,%eax
  800377:	0f 84 01 01 00 00    	je     80047e <libmain+0x187>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  80037d:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  800383:	bb 64 22 80 00       	mov    $0x802264,%ebx
  800388:	ba 0e 00 00 00       	mov    $0xe,%edx
  80038d:	89 c7                	mov    %eax,%edi
  80038f:	89 de                	mov    %ebx,%esi
  800391:	89 d1                	mov    %edx,%ecx
  800393:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  800395:	8d 55 8a             	lea    -0x76(%ebp),%edx
  800398:	b9 56 00 00 00       	mov    $0x56,%ecx
  80039d:	b0 00                	mov    $0x0,%al
  80039f:	89 d7                	mov    %edx,%edi
  8003a1:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  8003a3:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  8003aa:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8003ad:	83 ec 08             	sub    $0x8,%esp
  8003b0:	50                   	push   %eax
  8003b1:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  8003b7:	50                   	push   %eax
  8003b8:	e8 c4 17 00 00       	call   801b81 <sys_utilities>
  8003bd:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  8003c0:	e8 0d 13 00 00       	call   8016d2 <sys_lock_cons>
		{
			cprintf("**************************************\n");
  8003c5:	83 ec 0c             	sub    $0xc,%esp
  8003c8:	68 84 21 80 00       	push   $0x802184
  8003cd:	e8 ac 03 00 00       	call   80077e <cprintf>
  8003d2:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  8003d5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8003d8:	85 c0                	test   %eax,%eax
  8003da:	74 18                	je     8003f4 <libmain+0xfd>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  8003dc:	e8 be 17 00 00       	call   801b9f <sys_get_optimal_num_faults>
  8003e1:	83 ec 08             	sub    $0x8,%esp
  8003e4:	50                   	push   %eax
  8003e5:	68 ac 21 80 00       	push   $0x8021ac
  8003ea:	e8 8f 03 00 00       	call   80077e <cprintf>
  8003ef:	83 c4 10             	add    $0x10,%esp
  8003f2:	eb 59                	jmp    80044d <libmain+0x156>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8003f4:	a1 20 30 80 00       	mov    0x803020,%eax
  8003f9:	8b 90 bc 05 00 00    	mov    0x5bc(%eax),%edx
  8003ff:	a1 20 30 80 00       	mov    0x803020,%eax
  800404:	8b 80 ac 05 00 00    	mov    0x5ac(%eax),%eax
  80040a:	83 ec 04             	sub    $0x4,%esp
  80040d:	52                   	push   %edx
  80040e:	50                   	push   %eax
  80040f:	68 d0 21 80 00       	push   $0x8021d0
  800414:	e8 65 03 00 00       	call   80077e <cprintf>
  800419:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  80041c:	a1 20 30 80 00       	mov    0x803020,%eax
  800421:	8b 88 d0 05 00 00    	mov    0x5d0(%eax),%ecx
  800427:	a1 20 30 80 00       	mov    0x803020,%eax
  80042c:	8b 90 cc 05 00 00    	mov    0x5cc(%eax),%edx
  800432:	a1 20 30 80 00       	mov    0x803020,%eax
  800437:	8b 80 c8 05 00 00    	mov    0x5c8(%eax),%eax
  80043d:	51                   	push   %ecx
  80043e:	52                   	push   %edx
  80043f:	50                   	push   %eax
  800440:	68 f8 21 80 00       	push   $0x8021f8
  800445:	e8 34 03 00 00       	call   80077e <cprintf>
  80044a:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80044d:	a1 20 30 80 00       	mov    0x803020,%eax
  800452:	8b 80 d4 05 00 00    	mov    0x5d4(%eax),%eax
  800458:	83 ec 08             	sub    $0x8,%esp
  80045b:	50                   	push   %eax
  80045c:	68 50 22 80 00       	push   $0x802250
  800461:	e8 18 03 00 00       	call   80077e <cprintf>
  800466:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  800469:	83 ec 0c             	sub    $0xc,%esp
  80046c:	68 84 21 80 00       	push   $0x802184
  800471:	e8 08 03 00 00       	call   80077e <cprintf>
  800476:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  800479:	e8 6e 12 00 00       	call   8016ec <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  80047e:	e8 1f 00 00 00       	call   8004a2 <exit>
}
  800483:	90                   	nop
  800484:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800487:	5b                   	pop    %ebx
  800488:	5e                   	pop    %esi
  800489:	5f                   	pop    %edi
  80048a:	5d                   	pop    %ebp
  80048b:	c3                   	ret    

0080048c <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  80048c:	55                   	push   %ebp
  80048d:	89 e5                	mov    %esp,%ebp
  80048f:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800492:	83 ec 0c             	sub    $0xc,%esp
  800495:	6a 00                	push   $0x0
  800497:	e8 7b 14 00 00       	call   801917 <sys_destroy_env>
  80049c:	83 c4 10             	add    $0x10,%esp
}
  80049f:	90                   	nop
  8004a0:	c9                   	leave  
  8004a1:	c3                   	ret    

008004a2 <exit>:

void
exit(void)
{
  8004a2:	55                   	push   %ebp
  8004a3:	89 e5                	mov    %esp,%ebp
  8004a5:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8004a8:	e8 d0 14 00 00       	call   80197d <sys_exit_env>
}
  8004ad:	90                   	nop
  8004ae:	c9                   	leave  
  8004af:	c3                   	ret    

008004b0 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8004b0:	55                   	push   %ebp
  8004b1:	89 e5                	mov    %esp,%ebp
  8004b3:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8004b6:	8d 45 10             	lea    0x10(%ebp),%eax
  8004b9:	83 c0 04             	add    $0x4,%eax
  8004bc:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8004bf:	a1 18 b1 81 00       	mov    0x81b118,%eax
  8004c4:	85 c0                	test   %eax,%eax
  8004c6:	74 16                	je     8004de <_panic+0x2e>
		cprintf("%s: ", argv0);
  8004c8:	a1 18 b1 81 00       	mov    0x81b118,%eax
  8004cd:	83 ec 08             	sub    $0x8,%esp
  8004d0:	50                   	push   %eax
  8004d1:	68 c8 22 80 00       	push   $0x8022c8
  8004d6:	e8 a3 02 00 00       	call   80077e <cprintf>
  8004db:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  8004de:	a1 04 30 80 00       	mov    0x803004,%eax
  8004e3:	83 ec 0c             	sub    $0xc,%esp
  8004e6:	ff 75 0c             	pushl  0xc(%ebp)
  8004e9:	ff 75 08             	pushl  0x8(%ebp)
  8004ec:	50                   	push   %eax
  8004ed:	68 d0 22 80 00       	push   $0x8022d0
  8004f2:	6a 74                	push   $0x74
  8004f4:	e8 b2 02 00 00       	call   8007ab <cprintf_colored>
  8004f9:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  8004fc:	8b 45 10             	mov    0x10(%ebp),%eax
  8004ff:	83 ec 08             	sub    $0x8,%esp
  800502:	ff 75 f4             	pushl  -0xc(%ebp)
  800505:	50                   	push   %eax
  800506:	e8 04 02 00 00       	call   80070f <vcprintf>
  80050b:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  80050e:	83 ec 08             	sub    $0x8,%esp
  800511:	6a 00                	push   $0x0
  800513:	68 f8 22 80 00       	push   $0x8022f8
  800518:	e8 f2 01 00 00       	call   80070f <vcprintf>
  80051d:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800520:	e8 7d ff ff ff       	call   8004a2 <exit>

	// should not return here
	while (1) ;
  800525:	eb fe                	jmp    800525 <_panic+0x75>

00800527 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800527:	55                   	push   %ebp
  800528:	89 e5                	mov    %esp,%ebp
  80052a:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  80052d:	a1 20 30 80 00       	mov    0x803020,%eax
  800532:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800538:	8b 45 0c             	mov    0xc(%ebp),%eax
  80053b:	39 c2                	cmp    %eax,%edx
  80053d:	74 14                	je     800553 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  80053f:	83 ec 04             	sub    $0x4,%esp
  800542:	68 fc 22 80 00       	push   $0x8022fc
  800547:	6a 26                	push   $0x26
  800549:	68 48 23 80 00       	push   $0x802348
  80054e:	e8 5d ff ff ff       	call   8004b0 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800553:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  80055a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800561:	e9 c5 00 00 00       	jmp    80062b <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  800566:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800569:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800570:	8b 45 08             	mov    0x8(%ebp),%eax
  800573:	01 d0                	add    %edx,%eax
  800575:	8b 00                	mov    (%eax),%eax
  800577:	85 c0                	test   %eax,%eax
  800579:	75 08                	jne    800583 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  80057b:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  80057e:	e9 a5 00 00 00       	jmp    800628 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  800583:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80058a:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800591:	eb 69                	jmp    8005fc <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800593:	a1 20 30 80 00       	mov    0x803020,%eax
  800598:	8b 88 a4 05 00 00    	mov    0x5a4(%eax),%ecx
  80059e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8005a1:	89 d0                	mov    %edx,%eax
  8005a3:	01 c0                	add    %eax,%eax
  8005a5:	01 d0                	add    %edx,%eax
  8005a7:	c1 e0 03             	shl    $0x3,%eax
  8005aa:	01 c8                	add    %ecx,%eax
  8005ac:	8a 40 04             	mov    0x4(%eax),%al
  8005af:	84 c0                	test   %al,%al
  8005b1:	75 46                	jne    8005f9 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8005b3:	a1 20 30 80 00       	mov    0x803020,%eax
  8005b8:	8b 88 a4 05 00 00    	mov    0x5a4(%eax),%ecx
  8005be:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8005c1:	89 d0                	mov    %edx,%eax
  8005c3:	01 c0                	add    %eax,%eax
  8005c5:	01 d0                	add    %edx,%eax
  8005c7:	c1 e0 03             	shl    $0x3,%eax
  8005ca:	01 c8                	add    %ecx,%eax
  8005cc:	8b 00                	mov    (%eax),%eax
  8005ce:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8005d1:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8005d4:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8005d9:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8005db:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8005de:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8005e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8005e8:	01 c8                	add    %ecx,%eax
  8005ea:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8005ec:	39 c2                	cmp    %eax,%edx
  8005ee:	75 09                	jne    8005f9 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  8005f0:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8005f7:	eb 15                	jmp    80060e <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8005f9:	ff 45 e8             	incl   -0x18(%ebp)
  8005fc:	a1 20 30 80 00       	mov    0x803020,%eax
  800601:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800607:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80060a:	39 c2                	cmp    %eax,%edx
  80060c:	77 85                	ja     800593 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  80060e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800612:	75 14                	jne    800628 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  800614:	83 ec 04             	sub    $0x4,%esp
  800617:	68 54 23 80 00       	push   $0x802354
  80061c:	6a 3a                	push   $0x3a
  80061e:	68 48 23 80 00       	push   $0x802348
  800623:	e8 88 fe ff ff       	call   8004b0 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800628:	ff 45 f0             	incl   -0x10(%ebp)
  80062b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80062e:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800631:	0f 8c 2f ff ff ff    	jl     800566 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800637:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80063e:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800645:	eb 26                	jmp    80066d <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800647:	a1 20 30 80 00       	mov    0x803020,%eax
  80064c:	8b 88 a4 05 00 00    	mov    0x5a4(%eax),%ecx
  800652:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800655:	89 d0                	mov    %edx,%eax
  800657:	01 c0                	add    %eax,%eax
  800659:	01 d0                	add    %edx,%eax
  80065b:	c1 e0 03             	shl    $0x3,%eax
  80065e:	01 c8                	add    %ecx,%eax
  800660:	8a 40 04             	mov    0x4(%eax),%al
  800663:	3c 01                	cmp    $0x1,%al
  800665:	75 03                	jne    80066a <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  800667:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80066a:	ff 45 e0             	incl   -0x20(%ebp)
  80066d:	a1 20 30 80 00       	mov    0x803020,%eax
  800672:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800678:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80067b:	39 c2                	cmp    %eax,%edx
  80067d:	77 c8                	ja     800647 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  80067f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800682:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800685:	74 14                	je     80069b <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  800687:	83 ec 04             	sub    $0x4,%esp
  80068a:	68 a8 23 80 00       	push   $0x8023a8
  80068f:	6a 44                	push   $0x44
  800691:	68 48 23 80 00       	push   $0x802348
  800696:	e8 15 fe ff ff       	call   8004b0 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  80069b:	90                   	nop
  80069c:	c9                   	leave  
  80069d:	c3                   	ret    

0080069e <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  80069e:	55                   	push   %ebp
  80069f:	89 e5                	mov    %esp,%ebp
  8006a1:	53                   	push   %ebx
  8006a2:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  8006a5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006a8:	8b 00                	mov    (%eax),%eax
  8006aa:	8d 48 01             	lea    0x1(%eax),%ecx
  8006ad:	8b 55 0c             	mov    0xc(%ebp),%edx
  8006b0:	89 0a                	mov    %ecx,(%edx)
  8006b2:	8b 55 08             	mov    0x8(%ebp),%edx
  8006b5:	88 d1                	mov    %dl,%cl
  8006b7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8006ba:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8006be:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006c1:	8b 00                	mov    (%eax),%eax
  8006c3:	3d ff 00 00 00       	cmp    $0xff,%eax
  8006c8:	75 30                	jne    8006fa <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  8006ca:	8b 15 1c b1 81 00    	mov    0x81b11c,%edx
  8006d0:	a0 44 30 80 00       	mov    0x803044,%al
  8006d5:	0f b6 c0             	movzbl %al,%eax
  8006d8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8006db:	8b 09                	mov    (%ecx),%ecx
  8006dd:	89 cb                	mov    %ecx,%ebx
  8006df:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8006e2:	83 c1 08             	add    $0x8,%ecx
  8006e5:	52                   	push   %edx
  8006e6:	50                   	push   %eax
  8006e7:	53                   	push   %ebx
  8006e8:	51                   	push   %ecx
  8006e9:	e8 a0 0f 00 00       	call   80168e <sys_cputs>
  8006ee:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8006f1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006f4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8006fa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006fd:	8b 40 04             	mov    0x4(%eax),%eax
  800700:	8d 50 01             	lea    0x1(%eax),%edx
  800703:	8b 45 0c             	mov    0xc(%ebp),%eax
  800706:	89 50 04             	mov    %edx,0x4(%eax)
}
  800709:	90                   	nop
  80070a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80070d:	c9                   	leave  
  80070e:	c3                   	ret    

0080070f <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  80070f:	55                   	push   %ebp
  800710:	89 e5                	mov    %esp,%ebp
  800712:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800718:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80071f:	00 00 00 
	b.cnt = 0;
  800722:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800729:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  80072c:	ff 75 0c             	pushl  0xc(%ebp)
  80072f:	ff 75 08             	pushl  0x8(%ebp)
  800732:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800738:	50                   	push   %eax
  800739:	68 9e 06 80 00       	push   $0x80069e
  80073e:	e8 5a 02 00 00       	call   80099d <vprintfmt>
  800743:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  800746:	8b 15 1c b1 81 00    	mov    0x81b11c,%edx
  80074c:	a0 44 30 80 00       	mov    0x803044,%al
  800751:	0f b6 c0             	movzbl %al,%eax
  800754:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  80075a:	52                   	push   %edx
  80075b:	50                   	push   %eax
  80075c:	51                   	push   %ecx
  80075d:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800763:	83 c0 08             	add    $0x8,%eax
  800766:	50                   	push   %eax
  800767:	e8 22 0f 00 00       	call   80168e <sys_cputs>
  80076c:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  80076f:	c6 05 44 30 80 00 00 	movb   $0x0,0x803044
	return b.cnt;
  800776:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  80077c:	c9                   	leave  
  80077d:	c3                   	ret    

0080077e <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  80077e:	55                   	push   %ebp
  80077f:	89 e5                	mov    %esp,%ebp
  800781:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800784:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
	va_start(ap, fmt);
  80078b:	8d 45 0c             	lea    0xc(%ebp),%eax
  80078e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800791:	8b 45 08             	mov    0x8(%ebp),%eax
  800794:	83 ec 08             	sub    $0x8,%esp
  800797:	ff 75 f4             	pushl  -0xc(%ebp)
  80079a:	50                   	push   %eax
  80079b:	e8 6f ff ff ff       	call   80070f <vcprintf>
  8007a0:	83 c4 10             	add    $0x10,%esp
  8007a3:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8007a6:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8007a9:	c9                   	leave  
  8007aa:	c3                   	ret    

008007ab <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  8007ab:	55                   	push   %ebp
  8007ac:	89 e5                	mov    %esp,%ebp
  8007ae:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8007b1:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
	curTextClr = (textClr << 8) ; //set text color by the given value
  8007b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8007bb:	c1 e0 08             	shl    $0x8,%eax
  8007be:	a3 1c b1 81 00       	mov    %eax,0x81b11c
	va_start(ap, fmt);
  8007c3:	8d 45 0c             	lea    0xc(%ebp),%eax
  8007c6:	83 c0 04             	add    $0x4,%eax
  8007c9:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8007cc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007cf:	83 ec 08             	sub    $0x8,%esp
  8007d2:	ff 75 f4             	pushl  -0xc(%ebp)
  8007d5:	50                   	push   %eax
  8007d6:	e8 34 ff ff ff       	call   80070f <vcprintf>
  8007db:	83 c4 10             	add    $0x10,%esp
  8007de:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  8007e1:	c7 05 1c b1 81 00 00 	movl   $0x700,0x81b11c
  8007e8:	07 00 00 

	return cnt;
  8007eb:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8007ee:	c9                   	leave  
  8007ef:	c3                   	ret    

008007f0 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  8007f0:	55                   	push   %ebp
  8007f1:	89 e5                	mov    %esp,%ebp
  8007f3:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  8007f6:	e8 d7 0e 00 00       	call   8016d2 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  8007fb:	8d 45 0c             	lea    0xc(%ebp),%eax
  8007fe:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  800801:	8b 45 08             	mov    0x8(%ebp),%eax
  800804:	83 ec 08             	sub    $0x8,%esp
  800807:	ff 75 f4             	pushl  -0xc(%ebp)
  80080a:	50                   	push   %eax
  80080b:	e8 ff fe ff ff       	call   80070f <vcprintf>
  800810:	83 c4 10             	add    $0x10,%esp
  800813:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  800816:	e8 d1 0e 00 00       	call   8016ec <sys_unlock_cons>
	return cnt;
  80081b:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80081e:	c9                   	leave  
  80081f:	c3                   	ret    

00800820 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800820:	55                   	push   %ebp
  800821:	89 e5                	mov    %esp,%ebp
  800823:	53                   	push   %ebx
  800824:	83 ec 14             	sub    $0x14,%esp
  800827:	8b 45 10             	mov    0x10(%ebp),%eax
  80082a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80082d:	8b 45 14             	mov    0x14(%ebp),%eax
  800830:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800833:	8b 45 18             	mov    0x18(%ebp),%eax
  800836:	ba 00 00 00 00       	mov    $0x0,%edx
  80083b:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80083e:	77 55                	ja     800895 <printnum+0x75>
  800840:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800843:	72 05                	jb     80084a <printnum+0x2a>
  800845:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800848:	77 4b                	ja     800895 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80084a:	8b 45 1c             	mov    0x1c(%ebp),%eax
  80084d:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800850:	8b 45 18             	mov    0x18(%ebp),%eax
  800853:	ba 00 00 00 00       	mov    $0x0,%edx
  800858:	52                   	push   %edx
  800859:	50                   	push   %eax
  80085a:	ff 75 f4             	pushl  -0xc(%ebp)
  80085d:	ff 75 f0             	pushl  -0x10(%ebp)
  800860:	e8 ab 13 00 00       	call   801c10 <__udivdi3>
  800865:	83 c4 10             	add    $0x10,%esp
  800868:	83 ec 04             	sub    $0x4,%esp
  80086b:	ff 75 20             	pushl  0x20(%ebp)
  80086e:	53                   	push   %ebx
  80086f:	ff 75 18             	pushl  0x18(%ebp)
  800872:	52                   	push   %edx
  800873:	50                   	push   %eax
  800874:	ff 75 0c             	pushl  0xc(%ebp)
  800877:	ff 75 08             	pushl  0x8(%ebp)
  80087a:	e8 a1 ff ff ff       	call   800820 <printnum>
  80087f:	83 c4 20             	add    $0x20,%esp
  800882:	eb 1a                	jmp    80089e <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800884:	83 ec 08             	sub    $0x8,%esp
  800887:	ff 75 0c             	pushl  0xc(%ebp)
  80088a:	ff 75 20             	pushl  0x20(%ebp)
  80088d:	8b 45 08             	mov    0x8(%ebp),%eax
  800890:	ff d0                	call   *%eax
  800892:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800895:	ff 4d 1c             	decl   0x1c(%ebp)
  800898:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  80089c:	7f e6                	jg     800884 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80089e:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8008a1:	bb 00 00 00 00       	mov    $0x0,%ebx
  8008a6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8008a9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8008ac:	53                   	push   %ebx
  8008ad:	51                   	push   %ecx
  8008ae:	52                   	push   %edx
  8008af:	50                   	push   %eax
  8008b0:	e8 6b 14 00 00       	call   801d20 <__umoddi3>
  8008b5:	83 c4 10             	add    $0x10,%esp
  8008b8:	05 14 26 80 00       	add    $0x802614,%eax
  8008bd:	8a 00                	mov    (%eax),%al
  8008bf:	0f be c0             	movsbl %al,%eax
  8008c2:	83 ec 08             	sub    $0x8,%esp
  8008c5:	ff 75 0c             	pushl  0xc(%ebp)
  8008c8:	50                   	push   %eax
  8008c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8008cc:	ff d0                	call   *%eax
  8008ce:	83 c4 10             	add    $0x10,%esp
}
  8008d1:	90                   	nop
  8008d2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8008d5:	c9                   	leave  
  8008d6:	c3                   	ret    

008008d7 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8008d7:	55                   	push   %ebp
  8008d8:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8008da:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8008de:	7e 1c                	jle    8008fc <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8008e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8008e3:	8b 00                	mov    (%eax),%eax
  8008e5:	8d 50 08             	lea    0x8(%eax),%edx
  8008e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8008eb:	89 10                	mov    %edx,(%eax)
  8008ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8008f0:	8b 00                	mov    (%eax),%eax
  8008f2:	83 e8 08             	sub    $0x8,%eax
  8008f5:	8b 50 04             	mov    0x4(%eax),%edx
  8008f8:	8b 00                	mov    (%eax),%eax
  8008fa:	eb 40                	jmp    80093c <getuint+0x65>
	else if (lflag)
  8008fc:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800900:	74 1e                	je     800920 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800902:	8b 45 08             	mov    0x8(%ebp),%eax
  800905:	8b 00                	mov    (%eax),%eax
  800907:	8d 50 04             	lea    0x4(%eax),%edx
  80090a:	8b 45 08             	mov    0x8(%ebp),%eax
  80090d:	89 10                	mov    %edx,(%eax)
  80090f:	8b 45 08             	mov    0x8(%ebp),%eax
  800912:	8b 00                	mov    (%eax),%eax
  800914:	83 e8 04             	sub    $0x4,%eax
  800917:	8b 00                	mov    (%eax),%eax
  800919:	ba 00 00 00 00       	mov    $0x0,%edx
  80091e:	eb 1c                	jmp    80093c <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800920:	8b 45 08             	mov    0x8(%ebp),%eax
  800923:	8b 00                	mov    (%eax),%eax
  800925:	8d 50 04             	lea    0x4(%eax),%edx
  800928:	8b 45 08             	mov    0x8(%ebp),%eax
  80092b:	89 10                	mov    %edx,(%eax)
  80092d:	8b 45 08             	mov    0x8(%ebp),%eax
  800930:	8b 00                	mov    (%eax),%eax
  800932:	83 e8 04             	sub    $0x4,%eax
  800935:	8b 00                	mov    (%eax),%eax
  800937:	ba 00 00 00 00       	mov    $0x0,%edx
}
  80093c:	5d                   	pop    %ebp
  80093d:	c3                   	ret    

0080093e <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  80093e:	55                   	push   %ebp
  80093f:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800941:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800945:	7e 1c                	jle    800963 <getint+0x25>
		return va_arg(*ap, long long);
  800947:	8b 45 08             	mov    0x8(%ebp),%eax
  80094a:	8b 00                	mov    (%eax),%eax
  80094c:	8d 50 08             	lea    0x8(%eax),%edx
  80094f:	8b 45 08             	mov    0x8(%ebp),%eax
  800952:	89 10                	mov    %edx,(%eax)
  800954:	8b 45 08             	mov    0x8(%ebp),%eax
  800957:	8b 00                	mov    (%eax),%eax
  800959:	83 e8 08             	sub    $0x8,%eax
  80095c:	8b 50 04             	mov    0x4(%eax),%edx
  80095f:	8b 00                	mov    (%eax),%eax
  800961:	eb 38                	jmp    80099b <getint+0x5d>
	else if (lflag)
  800963:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800967:	74 1a                	je     800983 <getint+0x45>
		return va_arg(*ap, long);
  800969:	8b 45 08             	mov    0x8(%ebp),%eax
  80096c:	8b 00                	mov    (%eax),%eax
  80096e:	8d 50 04             	lea    0x4(%eax),%edx
  800971:	8b 45 08             	mov    0x8(%ebp),%eax
  800974:	89 10                	mov    %edx,(%eax)
  800976:	8b 45 08             	mov    0x8(%ebp),%eax
  800979:	8b 00                	mov    (%eax),%eax
  80097b:	83 e8 04             	sub    $0x4,%eax
  80097e:	8b 00                	mov    (%eax),%eax
  800980:	99                   	cltd   
  800981:	eb 18                	jmp    80099b <getint+0x5d>
	else
		return va_arg(*ap, int);
  800983:	8b 45 08             	mov    0x8(%ebp),%eax
  800986:	8b 00                	mov    (%eax),%eax
  800988:	8d 50 04             	lea    0x4(%eax),%edx
  80098b:	8b 45 08             	mov    0x8(%ebp),%eax
  80098e:	89 10                	mov    %edx,(%eax)
  800990:	8b 45 08             	mov    0x8(%ebp),%eax
  800993:	8b 00                	mov    (%eax),%eax
  800995:	83 e8 04             	sub    $0x4,%eax
  800998:	8b 00                	mov    (%eax),%eax
  80099a:	99                   	cltd   
}
  80099b:	5d                   	pop    %ebp
  80099c:	c3                   	ret    

0080099d <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80099d:	55                   	push   %ebp
  80099e:	89 e5                	mov    %esp,%ebp
  8009a0:	56                   	push   %esi
  8009a1:	53                   	push   %ebx
  8009a2:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8009a5:	eb 17                	jmp    8009be <vprintfmt+0x21>
			if (ch == '\0')
  8009a7:	85 db                	test   %ebx,%ebx
  8009a9:	0f 84 c1 03 00 00    	je     800d70 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  8009af:	83 ec 08             	sub    $0x8,%esp
  8009b2:	ff 75 0c             	pushl  0xc(%ebp)
  8009b5:	53                   	push   %ebx
  8009b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8009b9:	ff d0                	call   *%eax
  8009bb:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8009be:	8b 45 10             	mov    0x10(%ebp),%eax
  8009c1:	8d 50 01             	lea    0x1(%eax),%edx
  8009c4:	89 55 10             	mov    %edx,0x10(%ebp)
  8009c7:	8a 00                	mov    (%eax),%al
  8009c9:	0f b6 d8             	movzbl %al,%ebx
  8009cc:	83 fb 25             	cmp    $0x25,%ebx
  8009cf:	75 d6                	jne    8009a7 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8009d1:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  8009d5:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  8009dc:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8009e3:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8009ea:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8009f1:	8b 45 10             	mov    0x10(%ebp),%eax
  8009f4:	8d 50 01             	lea    0x1(%eax),%edx
  8009f7:	89 55 10             	mov    %edx,0x10(%ebp)
  8009fa:	8a 00                	mov    (%eax),%al
  8009fc:	0f b6 d8             	movzbl %al,%ebx
  8009ff:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800a02:	83 f8 5b             	cmp    $0x5b,%eax
  800a05:	0f 87 3d 03 00 00    	ja     800d48 <vprintfmt+0x3ab>
  800a0b:	8b 04 85 38 26 80 00 	mov    0x802638(,%eax,4),%eax
  800a12:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800a14:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800a18:	eb d7                	jmp    8009f1 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800a1a:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800a1e:	eb d1                	jmp    8009f1 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800a20:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800a27:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800a2a:	89 d0                	mov    %edx,%eax
  800a2c:	c1 e0 02             	shl    $0x2,%eax
  800a2f:	01 d0                	add    %edx,%eax
  800a31:	01 c0                	add    %eax,%eax
  800a33:	01 d8                	add    %ebx,%eax
  800a35:	83 e8 30             	sub    $0x30,%eax
  800a38:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800a3b:	8b 45 10             	mov    0x10(%ebp),%eax
  800a3e:	8a 00                	mov    (%eax),%al
  800a40:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800a43:	83 fb 2f             	cmp    $0x2f,%ebx
  800a46:	7e 3e                	jle    800a86 <vprintfmt+0xe9>
  800a48:	83 fb 39             	cmp    $0x39,%ebx
  800a4b:	7f 39                	jg     800a86 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800a4d:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800a50:	eb d5                	jmp    800a27 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800a52:	8b 45 14             	mov    0x14(%ebp),%eax
  800a55:	83 c0 04             	add    $0x4,%eax
  800a58:	89 45 14             	mov    %eax,0x14(%ebp)
  800a5b:	8b 45 14             	mov    0x14(%ebp),%eax
  800a5e:	83 e8 04             	sub    $0x4,%eax
  800a61:	8b 00                	mov    (%eax),%eax
  800a63:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800a66:	eb 1f                	jmp    800a87 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800a68:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a6c:	79 83                	jns    8009f1 <vprintfmt+0x54>
				width = 0;
  800a6e:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800a75:	e9 77 ff ff ff       	jmp    8009f1 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800a7a:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800a81:	e9 6b ff ff ff       	jmp    8009f1 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800a86:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800a87:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a8b:	0f 89 60 ff ff ff    	jns    8009f1 <vprintfmt+0x54>
				width = precision, precision = -1;
  800a91:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800a94:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800a97:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800a9e:	e9 4e ff ff ff       	jmp    8009f1 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800aa3:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800aa6:	e9 46 ff ff ff       	jmp    8009f1 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800aab:	8b 45 14             	mov    0x14(%ebp),%eax
  800aae:	83 c0 04             	add    $0x4,%eax
  800ab1:	89 45 14             	mov    %eax,0x14(%ebp)
  800ab4:	8b 45 14             	mov    0x14(%ebp),%eax
  800ab7:	83 e8 04             	sub    $0x4,%eax
  800aba:	8b 00                	mov    (%eax),%eax
  800abc:	83 ec 08             	sub    $0x8,%esp
  800abf:	ff 75 0c             	pushl  0xc(%ebp)
  800ac2:	50                   	push   %eax
  800ac3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ac6:	ff d0                	call   *%eax
  800ac8:	83 c4 10             	add    $0x10,%esp
			break;
  800acb:	e9 9b 02 00 00       	jmp    800d6b <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800ad0:	8b 45 14             	mov    0x14(%ebp),%eax
  800ad3:	83 c0 04             	add    $0x4,%eax
  800ad6:	89 45 14             	mov    %eax,0x14(%ebp)
  800ad9:	8b 45 14             	mov    0x14(%ebp),%eax
  800adc:	83 e8 04             	sub    $0x4,%eax
  800adf:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800ae1:	85 db                	test   %ebx,%ebx
  800ae3:	79 02                	jns    800ae7 <vprintfmt+0x14a>
				err = -err;
  800ae5:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800ae7:	83 fb 64             	cmp    $0x64,%ebx
  800aea:	7f 0b                	jg     800af7 <vprintfmt+0x15a>
  800aec:	8b 34 9d 80 24 80 00 	mov    0x802480(,%ebx,4),%esi
  800af3:	85 f6                	test   %esi,%esi
  800af5:	75 19                	jne    800b10 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800af7:	53                   	push   %ebx
  800af8:	68 25 26 80 00       	push   $0x802625
  800afd:	ff 75 0c             	pushl  0xc(%ebp)
  800b00:	ff 75 08             	pushl  0x8(%ebp)
  800b03:	e8 70 02 00 00       	call   800d78 <printfmt>
  800b08:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800b0b:	e9 5b 02 00 00       	jmp    800d6b <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800b10:	56                   	push   %esi
  800b11:	68 2e 26 80 00       	push   $0x80262e
  800b16:	ff 75 0c             	pushl  0xc(%ebp)
  800b19:	ff 75 08             	pushl  0x8(%ebp)
  800b1c:	e8 57 02 00 00       	call   800d78 <printfmt>
  800b21:	83 c4 10             	add    $0x10,%esp
			break;
  800b24:	e9 42 02 00 00       	jmp    800d6b <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800b29:	8b 45 14             	mov    0x14(%ebp),%eax
  800b2c:	83 c0 04             	add    $0x4,%eax
  800b2f:	89 45 14             	mov    %eax,0x14(%ebp)
  800b32:	8b 45 14             	mov    0x14(%ebp),%eax
  800b35:	83 e8 04             	sub    $0x4,%eax
  800b38:	8b 30                	mov    (%eax),%esi
  800b3a:	85 f6                	test   %esi,%esi
  800b3c:	75 05                	jne    800b43 <vprintfmt+0x1a6>
				p = "(null)";
  800b3e:	be 31 26 80 00       	mov    $0x802631,%esi
			if (width > 0 && padc != '-')
  800b43:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b47:	7e 6d                	jle    800bb6 <vprintfmt+0x219>
  800b49:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800b4d:	74 67                	je     800bb6 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800b4f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800b52:	83 ec 08             	sub    $0x8,%esp
  800b55:	50                   	push   %eax
  800b56:	56                   	push   %esi
  800b57:	e8 1e 03 00 00       	call   800e7a <strnlen>
  800b5c:	83 c4 10             	add    $0x10,%esp
  800b5f:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800b62:	eb 16                	jmp    800b7a <vprintfmt+0x1dd>
					putch(padc, putdat);
  800b64:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800b68:	83 ec 08             	sub    $0x8,%esp
  800b6b:	ff 75 0c             	pushl  0xc(%ebp)
  800b6e:	50                   	push   %eax
  800b6f:	8b 45 08             	mov    0x8(%ebp),%eax
  800b72:	ff d0                	call   *%eax
  800b74:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800b77:	ff 4d e4             	decl   -0x1c(%ebp)
  800b7a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b7e:	7f e4                	jg     800b64 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b80:	eb 34                	jmp    800bb6 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800b82:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800b86:	74 1c                	je     800ba4 <vprintfmt+0x207>
  800b88:	83 fb 1f             	cmp    $0x1f,%ebx
  800b8b:	7e 05                	jle    800b92 <vprintfmt+0x1f5>
  800b8d:	83 fb 7e             	cmp    $0x7e,%ebx
  800b90:	7e 12                	jle    800ba4 <vprintfmt+0x207>
					putch('?', putdat);
  800b92:	83 ec 08             	sub    $0x8,%esp
  800b95:	ff 75 0c             	pushl  0xc(%ebp)
  800b98:	6a 3f                	push   $0x3f
  800b9a:	8b 45 08             	mov    0x8(%ebp),%eax
  800b9d:	ff d0                	call   *%eax
  800b9f:	83 c4 10             	add    $0x10,%esp
  800ba2:	eb 0f                	jmp    800bb3 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800ba4:	83 ec 08             	sub    $0x8,%esp
  800ba7:	ff 75 0c             	pushl  0xc(%ebp)
  800baa:	53                   	push   %ebx
  800bab:	8b 45 08             	mov    0x8(%ebp),%eax
  800bae:	ff d0                	call   *%eax
  800bb0:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800bb3:	ff 4d e4             	decl   -0x1c(%ebp)
  800bb6:	89 f0                	mov    %esi,%eax
  800bb8:	8d 70 01             	lea    0x1(%eax),%esi
  800bbb:	8a 00                	mov    (%eax),%al
  800bbd:	0f be d8             	movsbl %al,%ebx
  800bc0:	85 db                	test   %ebx,%ebx
  800bc2:	74 24                	je     800be8 <vprintfmt+0x24b>
  800bc4:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800bc8:	78 b8                	js     800b82 <vprintfmt+0x1e5>
  800bca:	ff 4d e0             	decl   -0x20(%ebp)
  800bcd:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800bd1:	79 af                	jns    800b82 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800bd3:	eb 13                	jmp    800be8 <vprintfmt+0x24b>
				putch(' ', putdat);
  800bd5:	83 ec 08             	sub    $0x8,%esp
  800bd8:	ff 75 0c             	pushl  0xc(%ebp)
  800bdb:	6a 20                	push   $0x20
  800bdd:	8b 45 08             	mov    0x8(%ebp),%eax
  800be0:	ff d0                	call   *%eax
  800be2:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800be5:	ff 4d e4             	decl   -0x1c(%ebp)
  800be8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800bec:	7f e7                	jg     800bd5 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800bee:	e9 78 01 00 00       	jmp    800d6b <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800bf3:	83 ec 08             	sub    $0x8,%esp
  800bf6:	ff 75 e8             	pushl  -0x18(%ebp)
  800bf9:	8d 45 14             	lea    0x14(%ebp),%eax
  800bfc:	50                   	push   %eax
  800bfd:	e8 3c fd ff ff       	call   80093e <getint>
  800c02:	83 c4 10             	add    $0x10,%esp
  800c05:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c08:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800c0b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c0e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800c11:	85 d2                	test   %edx,%edx
  800c13:	79 23                	jns    800c38 <vprintfmt+0x29b>
				putch('-', putdat);
  800c15:	83 ec 08             	sub    $0x8,%esp
  800c18:	ff 75 0c             	pushl  0xc(%ebp)
  800c1b:	6a 2d                	push   $0x2d
  800c1d:	8b 45 08             	mov    0x8(%ebp),%eax
  800c20:	ff d0                	call   *%eax
  800c22:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800c25:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c28:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800c2b:	f7 d8                	neg    %eax
  800c2d:	83 d2 00             	adc    $0x0,%edx
  800c30:	f7 da                	neg    %edx
  800c32:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c35:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800c38:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800c3f:	e9 bc 00 00 00       	jmp    800d00 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800c44:	83 ec 08             	sub    $0x8,%esp
  800c47:	ff 75 e8             	pushl  -0x18(%ebp)
  800c4a:	8d 45 14             	lea    0x14(%ebp),%eax
  800c4d:	50                   	push   %eax
  800c4e:	e8 84 fc ff ff       	call   8008d7 <getuint>
  800c53:	83 c4 10             	add    $0x10,%esp
  800c56:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c59:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800c5c:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800c63:	e9 98 00 00 00       	jmp    800d00 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800c68:	83 ec 08             	sub    $0x8,%esp
  800c6b:	ff 75 0c             	pushl  0xc(%ebp)
  800c6e:	6a 58                	push   $0x58
  800c70:	8b 45 08             	mov    0x8(%ebp),%eax
  800c73:	ff d0                	call   *%eax
  800c75:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800c78:	83 ec 08             	sub    $0x8,%esp
  800c7b:	ff 75 0c             	pushl  0xc(%ebp)
  800c7e:	6a 58                	push   $0x58
  800c80:	8b 45 08             	mov    0x8(%ebp),%eax
  800c83:	ff d0                	call   *%eax
  800c85:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800c88:	83 ec 08             	sub    $0x8,%esp
  800c8b:	ff 75 0c             	pushl  0xc(%ebp)
  800c8e:	6a 58                	push   $0x58
  800c90:	8b 45 08             	mov    0x8(%ebp),%eax
  800c93:	ff d0                	call   *%eax
  800c95:	83 c4 10             	add    $0x10,%esp
			break;
  800c98:	e9 ce 00 00 00       	jmp    800d6b <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800c9d:	83 ec 08             	sub    $0x8,%esp
  800ca0:	ff 75 0c             	pushl  0xc(%ebp)
  800ca3:	6a 30                	push   $0x30
  800ca5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ca8:	ff d0                	call   *%eax
  800caa:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800cad:	83 ec 08             	sub    $0x8,%esp
  800cb0:	ff 75 0c             	pushl  0xc(%ebp)
  800cb3:	6a 78                	push   $0x78
  800cb5:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb8:	ff d0                	call   *%eax
  800cba:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800cbd:	8b 45 14             	mov    0x14(%ebp),%eax
  800cc0:	83 c0 04             	add    $0x4,%eax
  800cc3:	89 45 14             	mov    %eax,0x14(%ebp)
  800cc6:	8b 45 14             	mov    0x14(%ebp),%eax
  800cc9:	83 e8 04             	sub    $0x4,%eax
  800ccc:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800cce:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800cd1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800cd8:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800cdf:	eb 1f                	jmp    800d00 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800ce1:	83 ec 08             	sub    $0x8,%esp
  800ce4:	ff 75 e8             	pushl  -0x18(%ebp)
  800ce7:	8d 45 14             	lea    0x14(%ebp),%eax
  800cea:	50                   	push   %eax
  800ceb:	e8 e7 fb ff ff       	call   8008d7 <getuint>
  800cf0:	83 c4 10             	add    $0x10,%esp
  800cf3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800cf6:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800cf9:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800d00:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800d04:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800d07:	83 ec 04             	sub    $0x4,%esp
  800d0a:	52                   	push   %edx
  800d0b:	ff 75 e4             	pushl  -0x1c(%ebp)
  800d0e:	50                   	push   %eax
  800d0f:	ff 75 f4             	pushl  -0xc(%ebp)
  800d12:	ff 75 f0             	pushl  -0x10(%ebp)
  800d15:	ff 75 0c             	pushl  0xc(%ebp)
  800d18:	ff 75 08             	pushl  0x8(%ebp)
  800d1b:	e8 00 fb ff ff       	call   800820 <printnum>
  800d20:	83 c4 20             	add    $0x20,%esp
			break;
  800d23:	eb 46                	jmp    800d6b <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800d25:	83 ec 08             	sub    $0x8,%esp
  800d28:	ff 75 0c             	pushl  0xc(%ebp)
  800d2b:	53                   	push   %ebx
  800d2c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d2f:	ff d0                	call   *%eax
  800d31:	83 c4 10             	add    $0x10,%esp
			break;
  800d34:	eb 35                	jmp    800d6b <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800d36:	c6 05 44 30 80 00 00 	movb   $0x0,0x803044
			break;
  800d3d:	eb 2c                	jmp    800d6b <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800d3f:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
			break;
  800d46:	eb 23                	jmp    800d6b <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800d48:	83 ec 08             	sub    $0x8,%esp
  800d4b:	ff 75 0c             	pushl  0xc(%ebp)
  800d4e:	6a 25                	push   $0x25
  800d50:	8b 45 08             	mov    0x8(%ebp),%eax
  800d53:	ff d0                	call   *%eax
  800d55:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800d58:	ff 4d 10             	decl   0x10(%ebp)
  800d5b:	eb 03                	jmp    800d60 <vprintfmt+0x3c3>
  800d5d:	ff 4d 10             	decl   0x10(%ebp)
  800d60:	8b 45 10             	mov    0x10(%ebp),%eax
  800d63:	48                   	dec    %eax
  800d64:	8a 00                	mov    (%eax),%al
  800d66:	3c 25                	cmp    $0x25,%al
  800d68:	75 f3                	jne    800d5d <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800d6a:	90                   	nop
		}
	}
  800d6b:	e9 35 fc ff ff       	jmp    8009a5 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800d70:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800d71:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800d74:	5b                   	pop    %ebx
  800d75:	5e                   	pop    %esi
  800d76:	5d                   	pop    %ebp
  800d77:	c3                   	ret    

00800d78 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800d78:	55                   	push   %ebp
  800d79:	89 e5                	mov    %esp,%ebp
  800d7b:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800d7e:	8d 45 10             	lea    0x10(%ebp),%eax
  800d81:	83 c0 04             	add    $0x4,%eax
  800d84:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800d87:	8b 45 10             	mov    0x10(%ebp),%eax
  800d8a:	ff 75 f4             	pushl  -0xc(%ebp)
  800d8d:	50                   	push   %eax
  800d8e:	ff 75 0c             	pushl  0xc(%ebp)
  800d91:	ff 75 08             	pushl  0x8(%ebp)
  800d94:	e8 04 fc ff ff       	call   80099d <vprintfmt>
  800d99:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800d9c:	90                   	nop
  800d9d:	c9                   	leave  
  800d9e:	c3                   	ret    

00800d9f <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800d9f:	55                   	push   %ebp
  800da0:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800da2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800da5:	8b 40 08             	mov    0x8(%eax),%eax
  800da8:	8d 50 01             	lea    0x1(%eax),%edx
  800dab:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dae:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800db1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800db4:	8b 10                	mov    (%eax),%edx
  800db6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800db9:	8b 40 04             	mov    0x4(%eax),%eax
  800dbc:	39 c2                	cmp    %eax,%edx
  800dbe:	73 12                	jae    800dd2 <sprintputch+0x33>
		*b->buf++ = ch;
  800dc0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dc3:	8b 00                	mov    (%eax),%eax
  800dc5:	8d 48 01             	lea    0x1(%eax),%ecx
  800dc8:	8b 55 0c             	mov    0xc(%ebp),%edx
  800dcb:	89 0a                	mov    %ecx,(%edx)
  800dcd:	8b 55 08             	mov    0x8(%ebp),%edx
  800dd0:	88 10                	mov    %dl,(%eax)
}
  800dd2:	90                   	nop
  800dd3:	5d                   	pop    %ebp
  800dd4:	c3                   	ret    

00800dd5 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800dd5:	55                   	push   %ebp
  800dd6:	89 e5                	mov    %esp,%ebp
  800dd8:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800ddb:	8b 45 08             	mov    0x8(%ebp),%eax
  800dde:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800de1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800de4:	8d 50 ff             	lea    -0x1(%eax),%edx
  800de7:	8b 45 08             	mov    0x8(%ebp),%eax
  800dea:	01 d0                	add    %edx,%eax
  800dec:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800def:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800df6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800dfa:	74 06                	je     800e02 <vsnprintf+0x2d>
  800dfc:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e00:	7f 07                	jg     800e09 <vsnprintf+0x34>
		return -E_INVAL;
  800e02:	b8 03 00 00 00       	mov    $0x3,%eax
  800e07:	eb 20                	jmp    800e29 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800e09:	ff 75 14             	pushl  0x14(%ebp)
  800e0c:	ff 75 10             	pushl  0x10(%ebp)
  800e0f:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800e12:	50                   	push   %eax
  800e13:	68 9f 0d 80 00       	push   $0x800d9f
  800e18:	e8 80 fb ff ff       	call   80099d <vprintfmt>
  800e1d:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800e20:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800e23:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800e26:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800e29:	c9                   	leave  
  800e2a:	c3                   	ret    

00800e2b <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800e2b:	55                   	push   %ebp
  800e2c:	89 e5                	mov    %esp,%ebp
  800e2e:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800e31:	8d 45 10             	lea    0x10(%ebp),%eax
  800e34:	83 c0 04             	add    $0x4,%eax
  800e37:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800e3a:	8b 45 10             	mov    0x10(%ebp),%eax
  800e3d:	ff 75 f4             	pushl  -0xc(%ebp)
  800e40:	50                   	push   %eax
  800e41:	ff 75 0c             	pushl  0xc(%ebp)
  800e44:	ff 75 08             	pushl  0x8(%ebp)
  800e47:	e8 89 ff ff ff       	call   800dd5 <vsnprintf>
  800e4c:	83 c4 10             	add    $0x10,%esp
  800e4f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800e52:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800e55:	c9                   	leave  
  800e56:	c3                   	ret    

00800e57 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800e57:	55                   	push   %ebp
  800e58:	89 e5                	mov    %esp,%ebp
  800e5a:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800e5d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800e64:	eb 06                	jmp    800e6c <strlen+0x15>
		n++;
  800e66:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800e69:	ff 45 08             	incl   0x8(%ebp)
  800e6c:	8b 45 08             	mov    0x8(%ebp),%eax
  800e6f:	8a 00                	mov    (%eax),%al
  800e71:	84 c0                	test   %al,%al
  800e73:	75 f1                	jne    800e66 <strlen+0xf>
		n++;
	return n;
  800e75:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e78:	c9                   	leave  
  800e79:	c3                   	ret    

00800e7a <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800e7a:	55                   	push   %ebp
  800e7b:	89 e5                	mov    %esp,%ebp
  800e7d:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800e80:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800e87:	eb 09                	jmp    800e92 <strnlen+0x18>
		n++;
  800e89:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800e8c:	ff 45 08             	incl   0x8(%ebp)
  800e8f:	ff 4d 0c             	decl   0xc(%ebp)
  800e92:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e96:	74 09                	je     800ea1 <strnlen+0x27>
  800e98:	8b 45 08             	mov    0x8(%ebp),%eax
  800e9b:	8a 00                	mov    (%eax),%al
  800e9d:	84 c0                	test   %al,%al
  800e9f:	75 e8                	jne    800e89 <strnlen+0xf>
		n++;
	return n;
  800ea1:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800ea4:	c9                   	leave  
  800ea5:	c3                   	ret    

00800ea6 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800ea6:	55                   	push   %ebp
  800ea7:	89 e5                	mov    %esp,%ebp
  800ea9:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800eac:	8b 45 08             	mov    0x8(%ebp),%eax
  800eaf:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800eb2:	90                   	nop
  800eb3:	8b 45 08             	mov    0x8(%ebp),%eax
  800eb6:	8d 50 01             	lea    0x1(%eax),%edx
  800eb9:	89 55 08             	mov    %edx,0x8(%ebp)
  800ebc:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ebf:	8d 4a 01             	lea    0x1(%edx),%ecx
  800ec2:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800ec5:	8a 12                	mov    (%edx),%dl
  800ec7:	88 10                	mov    %dl,(%eax)
  800ec9:	8a 00                	mov    (%eax),%al
  800ecb:	84 c0                	test   %al,%al
  800ecd:	75 e4                	jne    800eb3 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800ecf:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800ed2:	c9                   	leave  
  800ed3:	c3                   	ret    

00800ed4 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800ed4:	55                   	push   %ebp
  800ed5:	89 e5                	mov    %esp,%ebp
  800ed7:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800eda:	8b 45 08             	mov    0x8(%ebp),%eax
  800edd:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800ee0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800ee7:	eb 1f                	jmp    800f08 <strncpy+0x34>
		*dst++ = *src;
  800ee9:	8b 45 08             	mov    0x8(%ebp),%eax
  800eec:	8d 50 01             	lea    0x1(%eax),%edx
  800eef:	89 55 08             	mov    %edx,0x8(%ebp)
  800ef2:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ef5:	8a 12                	mov    (%edx),%dl
  800ef7:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800ef9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800efc:	8a 00                	mov    (%eax),%al
  800efe:	84 c0                	test   %al,%al
  800f00:	74 03                	je     800f05 <strncpy+0x31>
			src++;
  800f02:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800f05:	ff 45 fc             	incl   -0x4(%ebp)
  800f08:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f0b:	3b 45 10             	cmp    0x10(%ebp),%eax
  800f0e:	72 d9                	jb     800ee9 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800f10:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800f13:	c9                   	leave  
  800f14:	c3                   	ret    

00800f15 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800f15:	55                   	push   %ebp
  800f16:	89 e5                	mov    %esp,%ebp
  800f18:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800f1b:	8b 45 08             	mov    0x8(%ebp),%eax
  800f1e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800f21:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f25:	74 30                	je     800f57 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800f27:	eb 16                	jmp    800f3f <strlcpy+0x2a>
			*dst++ = *src++;
  800f29:	8b 45 08             	mov    0x8(%ebp),%eax
  800f2c:	8d 50 01             	lea    0x1(%eax),%edx
  800f2f:	89 55 08             	mov    %edx,0x8(%ebp)
  800f32:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f35:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f38:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800f3b:	8a 12                	mov    (%edx),%dl
  800f3d:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800f3f:	ff 4d 10             	decl   0x10(%ebp)
  800f42:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f46:	74 09                	je     800f51 <strlcpy+0x3c>
  800f48:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f4b:	8a 00                	mov    (%eax),%al
  800f4d:	84 c0                	test   %al,%al
  800f4f:	75 d8                	jne    800f29 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800f51:	8b 45 08             	mov    0x8(%ebp),%eax
  800f54:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800f57:	8b 55 08             	mov    0x8(%ebp),%edx
  800f5a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f5d:	29 c2                	sub    %eax,%edx
  800f5f:	89 d0                	mov    %edx,%eax
}
  800f61:	c9                   	leave  
  800f62:	c3                   	ret    

00800f63 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800f63:	55                   	push   %ebp
  800f64:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800f66:	eb 06                	jmp    800f6e <strcmp+0xb>
		p++, q++;
  800f68:	ff 45 08             	incl   0x8(%ebp)
  800f6b:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800f6e:	8b 45 08             	mov    0x8(%ebp),%eax
  800f71:	8a 00                	mov    (%eax),%al
  800f73:	84 c0                	test   %al,%al
  800f75:	74 0e                	je     800f85 <strcmp+0x22>
  800f77:	8b 45 08             	mov    0x8(%ebp),%eax
  800f7a:	8a 10                	mov    (%eax),%dl
  800f7c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f7f:	8a 00                	mov    (%eax),%al
  800f81:	38 c2                	cmp    %al,%dl
  800f83:	74 e3                	je     800f68 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800f85:	8b 45 08             	mov    0x8(%ebp),%eax
  800f88:	8a 00                	mov    (%eax),%al
  800f8a:	0f b6 d0             	movzbl %al,%edx
  800f8d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f90:	8a 00                	mov    (%eax),%al
  800f92:	0f b6 c0             	movzbl %al,%eax
  800f95:	29 c2                	sub    %eax,%edx
  800f97:	89 d0                	mov    %edx,%eax
}
  800f99:	5d                   	pop    %ebp
  800f9a:	c3                   	ret    

00800f9b <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800f9b:	55                   	push   %ebp
  800f9c:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800f9e:	eb 09                	jmp    800fa9 <strncmp+0xe>
		n--, p++, q++;
  800fa0:	ff 4d 10             	decl   0x10(%ebp)
  800fa3:	ff 45 08             	incl   0x8(%ebp)
  800fa6:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800fa9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fad:	74 17                	je     800fc6 <strncmp+0x2b>
  800faf:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb2:	8a 00                	mov    (%eax),%al
  800fb4:	84 c0                	test   %al,%al
  800fb6:	74 0e                	je     800fc6 <strncmp+0x2b>
  800fb8:	8b 45 08             	mov    0x8(%ebp),%eax
  800fbb:	8a 10                	mov    (%eax),%dl
  800fbd:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fc0:	8a 00                	mov    (%eax),%al
  800fc2:	38 c2                	cmp    %al,%dl
  800fc4:	74 da                	je     800fa0 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800fc6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fca:	75 07                	jne    800fd3 <strncmp+0x38>
		return 0;
  800fcc:	b8 00 00 00 00       	mov    $0x0,%eax
  800fd1:	eb 14                	jmp    800fe7 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800fd3:	8b 45 08             	mov    0x8(%ebp),%eax
  800fd6:	8a 00                	mov    (%eax),%al
  800fd8:	0f b6 d0             	movzbl %al,%edx
  800fdb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fde:	8a 00                	mov    (%eax),%al
  800fe0:	0f b6 c0             	movzbl %al,%eax
  800fe3:	29 c2                	sub    %eax,%edx
  800fe5:	89 d0                	mov    %edx,%eax
}
  800fe7:	5d                   	pop    %ebp
  800fe8:	c3                   	ret    

00800fe9 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800fe9:	55                   	push   %ebp
  800fea:	89 e5                	mov    %esp,%ebp
  800fec:	83 ec 04             	sub    $0x4,%esp
  800fef:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ff2:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800ff5:	eb 12                	jmp    801009 <strchr+0x20>
		if (*s == c)
  800ff7:	8b 45 08             	mov    0x8(%ebp),%eax
  800ffa:	8a 00                	mov    (%eax),%al
  800ffc:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800fff:	75 05                	jne    801006 <strchr+0x1d>
			return (char *) s;
  801001:	8b 45 08             	mov    0x8(%ebp),%eax
  801004:	eb 11                	jmp    801017 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801006:	ff 45 08             	incl   0x8(%ebp)
  801009:	8b 45 08             	mov    0x8(%ebp),%eax
  80100c:	8a 00                	mov    (%eax),%al
  80100e:	84 c0                	test   %al,%al
  801010:	75 e5                	jne    800ff7 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  801012:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801017:	c9                   	leave  
  801018:	c3                   	ret    

00801019 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801019:	55                   	push   %ebp
  80101a:	89 e5                	mov    %esp,%ebp
  80101c:	83 ec 04             	sub    $0x4,%esp
  80101f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801022:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801025:	eb 0d                	jmp    801034 <strfind+0x1b>
		if (*s == c)
  801027:	8b 45 08             	mov    0x8(%ebp),%eax
  80102a:	8a 00                	mov    (%eax),%al
  80102c:	3a 45 fc             	cmp    -0x4(%ebp),%al
  80102f:	74 0e                	je     80103f <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801031:	ff 45 08             	incl   0x8(%ebp)
  801034:	8b 45 08             	mov    0x8(%ebp),%eax
  801037:	8a 00                	mov    (%eax),%al
  801039:	84 c0                	test   %al,%al
  80103b:	75 ea                	jne    801027 <strfind+0xe>
  80103d:	eb 01                	jmp    801040 <strfind+0x27>
		if (*s == c)
			break;
  80103f:	90                   	nop
	return (char *) s;
  801040:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801043:	c9                   	leave  
  801044:	c3                   	ret    

00801045 <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  801045:	55                   	push   %ebp
  801046:	89 e5                	mov    %esp,%ebp
  801048:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  80104b:	8b 45 08             	mov    0x8(%ebp),%eax
  80104e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  801051:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801055:	76 63                	jbe    8010ba <memset+0x75>
		uint64 data_block = c;
  801057:	8b 45 0c             	mov    0xc(%ebp),%eax
  80105a:	99                   	cltd   
  80105b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80105e:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  801061:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801064:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801067:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  80106b:	c1 e0 08             	shl    $0x8,%eax
  80106e:	09 45 f0             	or     %eax,-0x10(%ebp)
  801071:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  801074:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801077:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80107a:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  80107e:	c1 e0 10             	shl    $0x10,%eax
  801081:	09 45 f0             	or     %eax,-0x10(%ebp)
  801084:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  801087:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80108a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80108d:	89 c2                	mov    %eax,%edx
  80108f:	b8 00 00 00 00       	mov    $0x0,%eax
  801094:	09 45 f0             	or     %eax,-0x10(%ebp)
  801097:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  80109a:	eb 18                	jmp    8010b4 <memset+0x6f>
			*p64++ = data_block, n -= 8;
  80109c:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80109f:	8d 41 08             	lea    0x8(%ecx),%eax
  8010a2:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8010a5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8010a8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8010ab:	89 01                	mov    %eax,(%ecx)
  8010ad:	89 51 04             	mov    %edx,0x4(%ecx)
  8010b0:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  8010b4:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  8010b8:	77 e2                	ja     80109c <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  8010ba:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010be:	74 23                	je     8010e3 <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  8010c0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010c3:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  8010c6:	eb 0e                	jmp    8010d6 <memset+0x91>
			*p8++ = (uint8)c;
  8010c8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010cb:	8d 50 01             	lea    0x1(%eax),%edx
  8010ce:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8010d1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010d4:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  8010d6:	8b 45 10             	mov    0x10(%ebp),%eax
  8010d9:	8d 50 ff             	lea    -0x1(%eax),%edx
  8010dc:	89 55 10             	mov    %edx,0x10(%ebp)
  8010df:	85 c0                	test   %eax,%eax
  8010e1:	75 e5                	jne    8010c8 <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  8010e3:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8010e6:	c9                   	leave  
  8010e7:	c3                   	ret    

008010e8 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  8010e8:	55                   	push   %ebp
  8010e9:	89 e5                	mov    %esp,%ebp
  8010eb:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  8010ee:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010f1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  8010f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8010f7:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  8010fa:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  8010fe:	76 24                	jbe    801124 <memcpy+0x3c>
		while(n >= 8){
  801100:	eb 1c                	jmp    80111e <memcpy+0x36>
			*d64 = *s64;
  801102:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801105:	8b 50 04             	mov    0x4(%eax),%edx
  801108:	8b 00                	mov    (%eax),%eax
  80110a:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  80110d:	89 01                	mov    %eax,(%ecx)
  80110f:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  801112:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  801116:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  80111a:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  80111e:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801122:	77 de                	ja     801102 <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  801124:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801128:	74 31                	je     80115b <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  80112a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80112d:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  801130:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801133:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  801136:	eb 16                	jmp    80114e <memcpy+0x66>
			*d8++ = *s8++;
  801138:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80113b:	8d 50 01             	lea    0x1(%eax),%edx
  80113e:	89 55 f0             	mov    %edx,-0x10(%ebp)
  801141:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801144:	8d 4a 01             	lea    0x1(%edx),%ecx
  801147:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  80114a:	8a 12                	mov    (%edx),%dl
  80114c:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  80114e:	8b 45 10             	mov    0x10(%ebp),%eax
  801151:	8d 50 ff             	lea    -0x1(%eax),%edx
  801154:	89 55 10             	mov    %edx,0x10(%ebp)
  801157:	85 c0                	test   %eax,%eax
  801159:	75 dd                	jne    801138 <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  80115b:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80115e:	c9                   	leave  
  80115f:	c3                   	ret    

00801160 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801160:	55                   	push   %ebp
  801161:	89 e5                	mov    %esp,%ebp
  801163:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801166:	8b 45 0c             	mov    0xc(%ebp),%eax
  801169:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  80116c:	8b 45 08             	mov    0x8(%ebp),%eax
  80116f:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801172:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801175:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801178:	73 50                	jae    8011ca <memmove+0x6a>
  80117a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80117d:	8b 45 10             	mov    0x10(%ebp),%eax
  801180:	01 d0                	add    %edx,%eax
  801182:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801185:	76 43                	jbe    8011ca <memmove+0x6a>
		s += n;
  801187:	8b 45 10             	mov    0x10(%ebp),%eax
  80118a:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  80118d:	8b 45 10             	mov    0x10(%ebp),%eax
  801190:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  801193:	eb 10                	jmp    8011a5 <memmove+0x45>
			*--d = *--s;
  801195:	ff 4d f8             	decl   -0x8(%ebp)
  801198:	ff 4d fc             	decl   -0x4(%ebp)
  80119b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80119e:	8a 10                	mov    (%eax),%dl
  8011a0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011a3:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  8011a5:	8b 45 10             	mov    0x10(%ebp),%eax
  8011a8:	8d 50 ff             	lea    -0x1(%eax),%edx
  8011ab:	89 55 10             	mov    %edx,0x10(%ebp)
  8011ae:	85 c0                	test   %eax,%eax
  8011b0:	75 e3                	jne    801195 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8011b2:	eb 23                	jmp    8011d7 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  8011b4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011b7:	8d 50 01             	lea    0x1(%eax),%edx
  8011ba:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8011bd:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8011c0:	8d 4a 01             	lea    0x1(%edx),%ecx
  8011c3:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8011c6:	8a 12                	mov    (%edx),%dl
  8011c8:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  8011ca:	8b 45 10             	mov    0x10(%ebp),%eax
  8011cd:	8d 50 ff             	lea    -0x1(%eax),%edx
  8011d0:	89 55 10             	mov    %edx,0x10(%ebp)
  8011d3:	85 c0                	test   %eax,%eax
  8011d5:	75 dd                	jne    8011b4 <memmove+0x54>
			*d++ = *s++;

	return dst;
  8011d7:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8011da:	c9                   	leave  
  8011db:	c3                   	ret    

008011dc <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8011dc:	55                   	push   %ebp
  8011dd:	89 e5                	mov    %esp,%ebp
  8011df:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  8011e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8011e5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  8011e8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011eb:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8011ee:	eb 2a                	jmp    80121a <memcmp+0x3e>
		if (*s1 != *s2)
  8011f0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011f3:	8a 10                	mov    (%eax),%dl
  8011f5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011f8:	8a 00                	mov    (%eax),%al
  8011fa:	38 c2                	cmp    %al,%dl
  8011fc:	74 16                	je     801214 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  8011fe:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801201:	8a 00                	mov    (%eax),%al
  801203:	0f b6 d0             	movzbl %al,%edx
  801206:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801209:	8a 00                	mov    (%eax),%al
  80120b:	0f b6 c0             	movzbl %al,%eax
  80120e:	29 c2                	sub    %eax,%edx
  801210:	89 d0                	mov    %edx,%eax
  801212:	eb 18                	jmp    80122c <memcmp+0x50>
		s1++, s2++;
  801214:	ff 45 fc             	incl   -0x4(%ebp)
  801217:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  80121a:	8b 45 10             	mov    0x10(%ebp),%eax
  80121d:	8d 50 ff             	lea    -0x1(%eax),%edx
  801220:	89 55 10             	mov    %edx,0x10(%ebp)
  801223:	85 c0                	test   %eax,%eax
  801225:	75 c9                	jne    8011f0 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801227:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80122c:	c9                   	leave  
  80122d:	c3                   	ret    

0080122e <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  80122e:	55                   	push   %ebp
  80122f:	89 e5                	mov    %esp,%ebp
  801231:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801234:	8b 55 08             	mov    0x8(%ebp),%edx
  801237:	8b 45 10             	mov    0x10(%ebp),%eax
  80123a:	01 d0                	add    %edx,%eax
  80123c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  80123f:	eb 15                	jmp    801256 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801241:	8b 45 08             	mov    0x8(%ebp),%eax
  801244:	8a 00                	mov    (%eax),%al
  801246:	0f b6 d0             	movzbl %al,%edx
  801249:	8b 45 0c             	mov    0xc(%ebp),%eax
  80124c:	0f b6 c0             	movzbl %al,%eax
  80124f:	39 c2                	cmp    %eax,%edx
  801251:	74 0d                	je     801260 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801253:	ff 45 08             	incl   0x8(%ebp)
  801256:	8b 45 08             	mov    0x8(%ebp),%eax
  801259:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80125c:	72 e3                	jb     801241 <memfind+0x13>
  80125e:	eb 01                	jmp    801261 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801260:	90                   	nop
	return (void *) s;
  801261:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801264:	c9                   	leave  
  801265:	c3                   	ret    

00801266 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801266:	55                   	push   %ebp
  801267:	89 e5                	mov    %esp,%ebp
  801269:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  80126c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801273:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80127a:	eb 03                	jmp    80127f <strtol+0x19>
		s++;
  80127c:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80127f:	8b 45 08             	mov    0x8(%ebp),%eax
  801282:	8a 00                	mov    (%eax),%al
  801284:	3c 20                	cmp    $0x20,%al
  801286:	74 f4                	je     80127c <strtol+0x16>
  801288:	8b 45 08             	mov    0x8(%ebp),%eax
  80128b:	8a 00                	mov    (%eax),%al
  80128d:	3c 09                	cmp    $0x9,%al
  80128f:	74 eb                	je     80127c <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801291:	8b 45 08             	mov    0x8(%ebp),%eax
  801294:	8a 00                	mov    (%eax),%al
  801296:	3c 2b                	cmp    $0x2b,%al
  801298:	75 05                	jne    80129f <strtol+0x39>
		s++;
  80129a:	ff 45 08             	incl   0x8(%ebp)
  80129d:	eb 13                	jmp    8012b2 <strtol+0x4c>
	else if (*s == '-')
  80129f:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a2:	8a 00                	mov    (%eax),%al
  8012a4:	3c 2d                	cmp    $0x2d,%al
  8012a6:	75 0a                	jne    8012b2 <strtol+0x4c>
		s++, neg = 1;
  8012a8:	ff 45 08             	incl   0x8(%ebp)
  8012ab:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8012b2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8012b6:	74 06                	je     8012be <strtol+0x58>
  8012b8:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8012bc:	75 20                	jne    8012de <strtol+0x78>
  8012be:	8b 45 08             	mov    0x8(%ebp),%eax
  8012c1:	8a 00                	mov    (%eax),%al
  8012c3:	3c 30                	cmp    $0x30,%al
  8012c5:	75 17                	jne    8012de <strtol+0x78>
  8012c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8012ca:	40                   	inc    %eax
  8012cb:	8a 00                	mov    (%eax),%al
  8012cd:	3c 78                	cmp    $0x78,%al
  8012cf:	75 0d                	jne    8012de <strtol+0x78>
		s += 2, base = 16;
  8012d1:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8012d5:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8012dc:	eb 28                	jmp    801306 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8012de:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8012e2:	75 15                	jne    8012f9 <strtol+0x93>
  8012e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8012e7:	8a 00                	mov    (%eax),%al
  8012e9:	3c 30                	cmp    $0x30,%al
  8012eb:	75 0c                	jne    8012f9 <strtol+0x93>
		s++, base = 8;
  8012ed:	ff 45 08             	incl   0x8(%ebp)
  8012f0:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8012f7:	eb 0d                	jmp    801306 <strtol+0xa0>
	else if (base == 0)
  8012f9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8012fd:	75 07                	jne    801306 <strtol+0xa0>
		base = 10;
  8012ff:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801306:	8b 45 08             	mov    0x8(%ebp),%eax
  801309:	8a 00                	mov    (%eax),%al
  80130b:	3c 2f                	cmp    $0x2f,%al
  80130d:	7e 19                	jle    801328 <strtol+0xc2>
  80130f:	8b 45 08             	mov    0x8(%ebp),%eax
  801312:	8a 00                	mov    (%eax),%al
  801314:	3c 39                	cmp    $0x39,%al
  801316:	7f 10                	jg     801328 <strtol+0xc2>
			dig = *s - '0';
  801318:	8b 45 08             	mov    0x8(%ebp),%eax
  80131b:	8a 00                	mov    (%eax),%al
  80131d:	0f be c0             	movsbl %al,%eax
  801320:	83 e8 30             	sub    $0x30,%eax
  801323:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801326:	eb 42                	jmp    80136a <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801328:	8b 45 08             	mov    0x8(%ebp),%eax
  80132b:	8a 00                	mov    (%eax),%al
  80132d:	3c 60                	cmp    $0x60,%al
  80132f:	7e 19                	jle    80134a <strtol+0xe4>
  801331:	8b 45 08             	mov    0x8(%ebp),%eax
  801334:	8a 00                	mov    (%eax),%al
  801336:	3c 7a                	cmp    $0x7a,%al
  801338:	7f 10                	jg     80134a <strtol+0xe4>
			dig = *s - 'a' + 10;
  80133a:	8b 45 08             	mov    0x8(%ebp),%eax
  80133d:	8a 00                	mov    (%eax),%al
  80133f:	0f be c0             	movsbl %al,%eax
  801342:	83 e8 57             	sub    $0x57,%eax
  801345:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801348:	eb 20                	jmp    80136a <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  80134a:	8b 45 08             	mov    0x8(%ebp),%eax
  80134d:	8a 00                	mov    (%eax),%al
  80134f:	3c 40                	cmp    $0x40,%al
  801351:	7e 39                	jle    80138c <strtol+0x126>
  801353:	8b 45 08             	mov    0x8(%ebp),%eax
  801356:	8a 00                	mov    (%eax),%al
  801358:	3c 5a                	cmp    $0x5a,%al
  80135a:	7f 30                	jg     80138c <strtol+0x126>
			dig = *s - 'A' + 10;
  80135c:	8b 45 08             	mov    0x8(%ebp),%eax
  80135f:	8a 00                	mov    (%eax),%al
  801361:	0f be c0             	movsbl %al,%eax
  801364:	83 e8 37             	sub    $0x37,%eax
  801367:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  80136a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80136d:	3b 45 10             	cmp    0x10(%ebp),%eax
  801370:	7d 19                	jge    80138b <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801372:	ff 45 08             	incl   0x8(%ebp)
  801375:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801378:	0f af 45 10          	imul   0x10(%ebp),%eax
  80137c:	89 c2                	mov    %eax,%edx
  80137e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801381:	01 d0                	add    %edx,%eax
  801383:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801386:	e9 7b ff ff ff       	jmp    801306 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  80138b:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  80138c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801390:	74 08                	je     80139a <strtol+0x134>
		*endptr = (char *) s;
  801392:	8b 45 0c             	mov    0xc(%ebp),%eax
  801395:	8b 55 08             	mov    0x8(%ebp),%edx
  801398:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  80139a:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80139e:	74 07                	je     8013a7 <strtol+0x141>
  8013a0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8013a3:	f7 d8                	neg    %eax
  8013a5:	eb 03                	jmp    8013aa <strtol+0x144>
  8013a7:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8013aa:	c9                   	leave  
  8013ab:	c3                   	ret    

008013ac <ltostr>:

void
ltostr(long value, char *str)
{
  8013ac:	55                   	push   %ebp
  8013ad:	89 e5                	mov    %esp,%ebp
  8013af:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8013b2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8013b9:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8013c0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8013c4:	79 13                	jns    8013d9 <ltostr+0x2d>
	{
		neg = 1;
  8013c6:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8013cd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013d0:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8013d3:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8013d6:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8013d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8013dc:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8013e1:	99                   	cltd   
  8013e2:	f7 f9                	idiv   %ecx
  8013e4:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8013e7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8013ea:	8d 50 01             	lea    0x1(%eax),%edx
  8013ed:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8013f0:	89 c2                	mov    %eax,%edx
  8013f2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013f5:	01 d0                	add    %edx,%eax
  8013f7:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8013fa:	83 c2 30             	add    $0x30,%edx
  8013fd:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8013ff:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801402:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801407:	f7 e9                	imul   %ecx
  801409:	c1 fa 02             	sar    $0x2,%edx
  80140c:	89 c8                	mov    %ecx,%eax
  80140e:	c1 f8 1f             	sar    $0x1f,%eax
  801411:	29 c2                	sub    %eax,%edx
  801413:	89 d0                	mov    %edx,%eax
  801415:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  801418:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80141c:	75 bb                	jne    8013d9 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  80141e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801425:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801428:	48                   	dec    %eax
  801429:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  80142c:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801430:	74 3d                	je     80146f <ltostr+0xc3>
		start = 1 ;
  801432:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801439:	eb 34                	jmp    80146f <ltostr+0xc3>
	{
		char tmp = str[start] ;
  80143b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80143e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801441:	01 d0                	add    %edx,%eax
  801443:	8a 00                	mov    (%eax),%al
  801445:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801448:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80144b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80144e:	01 c2                	add    %eax,%edx
  801450:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801453:	8b 45 0c             	mov    0xc(%ebp),%eax
  801456:	01 c8                	add    %ecx,%eax
  801458:	8a 00                	mov    (%eax),%al
  80145a:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  80145c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80145f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801462:	01 c2                	add    %eax,%edx
  801464:	8a 45 eb             	mov    -0x15(%ebp),%al
  801467:	88 02                	mov    %al,(%edx)
		start++ ;
  801469:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  80146c:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  80146f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801472:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801475:	7c c4                	jl     80143b <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801477:	8b 55 f8             	mov    -0x8(%ebp),%edx
  80147a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80147d:	01 d0                	add    %edx,%eax
  80147f:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801482:	90                   	nop
  801483:	c9                   	leave  
  801484:	c3                   	ret    

00801485 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801485:	55                   	push   %ebp
  801486:	89 e5                	mov    %esp,%ebp
  801488:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  80148b:	ff 75 08             	pushl  0x8(%ebp)
  80148e:	e8 c4 f9 ff ff       	call   800e57 <strlen>
  801493:	83 c4 04             	add    $0x4,%esp
  801496:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801499:	ff 75 0c             	pushl  0xc(%ebp)
  80149c:	e8 b6 f9 ff ff       	call   800e57 <strlen>
  8014a1:	83 c4 04             	add    $0x4,%esp
  8014a4:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8014a7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8014ae:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8014b5:	eb 17                	jmp    8014ce <strcconcat+0x49>
		final[s] = str1[s] ;
  8014b7:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8014ba:	8b 45 10             	mov    0x10(%ebp),%eax
  8014bd:	01 c2                	add    %eax,%edx
  8014bf:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8014c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8014c5:	01 c8                	add    %ecx,%eax
  8014c7:	8a 00                	mov    (%eax),%al
  8014c9:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8014cb:	ff 45 fc             	incl   -0x4(%ebp)
  8014ce:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8014d1:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8014d4:	7c e1                	jl     8014b7 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8014d6:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8014dd:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8014e4:	eb 1f                	jmp    801505 <strcconcat+0x80>
		final[s++] = str2[i] ;
  8014e6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8014e9:	8d 50 01             	lea    0x1(%eax),%edx
  8014ec:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8014ef:	89 c2                	mov    %eax,%edx
  8014f1:	8b 45 10             	mov    0x10(%ebp),%eax
  8014f4:	01 c2                	add    %eax,%edx
  8014f6:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8014f9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014fc:	01 c8                	add    %ecx,%eax
  8014fe:	8a 00                	mov    (%eax),%al
  801500:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801502:	ff 45 f8             	incl   -0x8(%ebp)
  801505:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801508:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80150b:	7c d9                	jl     8014e6 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  80150d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801510:	8b 45 10             	mov    0x10(%ebp),%eax
  801513:	01 d0                	add    %edx,%eax
  801515:	c6 00 00             	movb   $0x0,(%eax)
}
  801518:	90                   	nop
  801519:	c9                   	leave  
  80151a:	c3                   	ret    

0080151b <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  80151b:	55                   	push   %ebp
  80151c:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  80151e:	8b 45 14             	mov    0x14(%ebp),%eax
  801521:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801527:	8b 45 14             	mov    0x14(%ebp),%eax
  80152a:	8b 00                	mov    (%eax),%eax
  80152c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801533:	8b 45 10             	mov    0x10(%ebp),%eax
  801536:	01 d0                	add    %edx,%eax
  801538:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80153e:	eb 0c                	jmp    80154c <strsplit+0x31>
			*string++ = 0;
  801540:	8b 45 08             	mov    0x8(%ebp),%eax
  801543:	8d 50 01             	lea    0x1(%eax),%edx
  801546:	89 55 08             	mov    %edx,0x8(%ebp)
  801549:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80154c:	8b 45 08             	mov    0x8(%ebp),%eax
  80154f:	8a 00                	mov    (%eax),%al
  801551:	84 c0                	test   %al,%al
  801553:	74 18                	je     80156d <strsplit+0x52>
  801555:	8b 45 08             	mov    0x8(%ebp),%eax
  801558:	8a 00                	mov    (%eax),%al
  80155a:	0f be c0             	movsbl %al,%eax
  80155d:	50                   	push   %eax
  80155e:	ff 75 0c             	pushl  0xc(%ebp)
  801561:	e8 83 fa ff ff       	call   800fe9 <strchr>
  801566:	83 c4 08             	add    $0x8,%esp
  801569:	85 c0                	test   %eax,%eax
  80156b:	75 d3                	jne    801540 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  80156d:	8b 45 08             	mov    0x8(%ebp),%eax
  801570:	8a 00                	mov    (%eax),%al
  801572:	84 c0                	test   %al,%al
  801574:	74 5a                	je     8015d0 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801576:	8b 45 14             	mov    0x14(%ebp),%eax
  801579:	8b 00                	mov    (%eax),%eax
  80157b:	83 f8 0f             	cmp    $0xf,%eax
  80157e:	75 07                	jne    801587 <strsplit+0x6c>
		{
			return 0;
  801580:	b8 00 00 00 00       	mov    $0x0,%eax
  801585:	eb 66                	jmp    8015ed <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801587:	8b 45 14             	mov    0x14(%ebp),%eax
  80158a:	8b 00                	mov    (%eax),%eax
  80158c:	8d 48 01             	lea    0x1(%eax),%ecx
  80158f:	8b 55 14             	mov    0x14(%ebp),%edx
  801592:	89 0a                	mov    %ecx,(%edx)
  801594:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80159b:	8b 45 10             	mov    0x10(%ebp),%eax
  80159e:	01 c2                	add    %eax,%edx
  8015a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8015a3:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8015a5:	eb 03                	jmp    8015aa <strsplit+0x8f>
			string++;
  8015a7:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8015aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8015ad:	8a 00                	mov    (%eax),%al
  8015af:	84 c0                	test   %al,%al
  8015b1:	74 8b                	je     80153e <strsplit+0x23>
  8015b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8015b6:	8a 00                	mov    (%eax),%al
  8015b8:	0f be c0             	movsbl %al,%eax
  8015bb:	50                   	push   %eax
  8015bc:	ff 75 0c             	pushl  0xc(%ebp)
  8015bf:	e8 25 fa ff ff       	call   800fe9 <strchr>
  8015c4:	83 c4 08             	add    $0x8,%esp
  8015c7:	85 c0                	test   %eax,%eax
  8015c9:	74 dc                	je     8015a7 <strsplit+0x8c>
			string++;
	}
  8015cb:	e9 6e ff ff ff       	jmp    80153e <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8015d0:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8015d1:	8b 45 14             	mov    0x14(%ebp),%eax
  8015d4:	8b 00                	mov    (%eax),%eax
  8015d6:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8015dd:	8b 45 10             	mov    0x10(%ebp),%eax
  8015e0:	01 d0                	add    %edx,%eax
  8015e2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8015e8:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8015ed:	c9                   	leave  
  8015ee:	c3                   	ret    

008015ef <str2lower>:


char* str2lower(char *dst, const char *src)
{
  8015ef:	55                   	push   %ebp
  8015f0:	89 e5                	mov    %esp,%ebp
  8015f2:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  8015f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8015f8:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  8015fb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801602:	eb 4a                	jmp    80164e <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  801604:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801607:	8b 45 08             	mov    0x8(%ebp),%eax
  80160a:	01 c2                	add    %eax,%edx
  80160c:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80160f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801612:	01 c8                	add    %ecx,%eax
  801614:	8a 00                	mov    (%eax),%al
  801616:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  801618:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80161b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80161e:	01 d0                	add    %edx,%eax
  801620:	8a 00                	mov    (%eax),%al
  801622:	3c 40                	cmp    $0x40,%al
  801624:	7e 25                	jle    80164b <str2lower+0x5c>
  801626:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801629:	8b 45 0c             	mov    0xc(%ebp),%eax
  80162c:	01 d0                	add    %edx,%eax
  80162e:	8a 00                	mov    (%eax),%al
  801630:	3c 5a                	cmp    $0x5a,%al
  801632:	7f 17                	jg     80164b <str2lower+0x5c>
		{
			dst[i] += 32 ;
  801634:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801637:	8b 45 08             	mov    0x8(%ebp),%eax
  80163a:	01 d0                	add    %edx,%eax
  80163c:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80163f:	8b 55 08             	mov    0x8(%ebp),%edx
  801642:	01 ca                	add    %ecx,%edx
  801644:	8a 12                	mov    (%edx),%dl
  801646:	83 c2 20             	add    $0x20,%edx
  801649:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  80164b:	ff 45 fc             	incl   -0x4(%ebp)
  80164e:	ff 75 0c             	pushl  0xc(%ebp)
  801651:	e8 01 f8 ff ff       	call   800e57 <strlen>
  801656:	83 c4 04             	add    $0x4,%esp
  801659:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80165c:	7f a6                	jg     801604 <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  80165e:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801661:	c9                   	leave  
  801662:	c3                   	ret    

00801663 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801663:	55                   	push   %ebp
  801664:	89 e5                	mov    %esp,%ebp
  801666:	57                   	push   %edi
  801667:	56                   	push   %esi
  801668:	53                   	push   %ebx
  801669:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80166c:	8b 45 08             	mov    0x8(%ebp),%eax
  80166f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801672:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801675:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801678:	8b 7d 18             	mov    0x18(%ebp),%edi
  80167b:	8b 75 1c             	mov    0x1c(%ebp),%esi
  80167e:	cd 30                	int    $0x30
  801680:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  801683:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801686:	83 c4 10             	add    $0x10,%esp
  801689:	5b                   	pop    %ebx
  80168a:	5e                   	pop    %esi
  80168b:	5f                   	pop    %edi
  80168c:	5d                   	pop    %ebp
  80168d:	c3                   	ret    

0080168e <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  80168e:	55                   	push   %ebp
  80168f:	89 e5                	mov    %esp,%ebp
  801691:	83 ec 04             	sub    $0x4,%esp
  801694:	8b 45 10             	mov    0x10(%ebp),%eax
  801697:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  80169a:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80169d:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8016a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8016a4:	6a 00                	push   $0x0
  8016a6:	51                   	push   %ecx
  8016a7:	52                   	push   %edx
  8016a8:	ff 75 0c             	pushl  0xc(%ebp)
  8016ab:	50                   	push   %eax
  8016ac:	6a 00                	push   $0x0
  8016ae:	e8 b0 ff ff ff       	call   801663 <syscall>
  8016b3:	83 c4 18             	add    $0x18,%esp
}
  8016b6:	90                   	nop
  8016b7:	c9                   	leave  
  8016b8:	c3                   	ret    

008016b9 <sys_cgetc>:

int
sys_cgetc(void)
{
  8016b9:	55                   	push   %ebp
  8016ba:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8016bc:	6a 00                	push   $0x0
  8016be:	6a 00                	push   $0x0
  8016c0:	6a 00                	push   $0x0
  8016c2:	6a 00                	push   $0x0
  8016c4:	6a 00                	push   $0x0
  8016c6:	6a 02                	push   $0x2
  8016c8:	e8 96 ff ff ff       	call   801663 <syscall>
  8016cd:	83 c4 18             	add    $0x18,%esp
}
  8016d0:	c9                   	leave  
  8016d1:	c3                   	ret    

008016d2 <sys_lock_cons>:

void sys_lock_cons(void)
{
  8016d2:	55                   	push   %ebp
  8016d3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  8016d5:	6a 00                	push   $0x0
  8016d7:	6a 00                	push   $0x0
  8016d9:	6a 00                	push   $0x0
  8016db:	6a 00                	push   $0x0
  8016dd:	6a 00                	push   $0x0
  8016df:	6a 03                	push   $0x3
  8016e1:	e8 7d ff ff ff       	call   801663 <syscall>
  8016e6:	83 c4 18             	add    $0x18,%esp
}
  8016e9:	90                   	nop
  8016ea:	c9                   	leave  
  8016eb:	c3                   	ret    

008016ec <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  8016ec:	55                   	push   %ebp
  8016ed:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  8016ef:	6a 00                	push   $0x0
  8016f1:	6a 00                	push   $0x0
  8016f3:	6a 00                	push   $0x0
  8016f5:	6a 00                	push   $0x0
  8016f7:	6a 00                	push   $0x0
  8016f9:	6a 04                	push   $0x4
  8016fb:	e8 63 ff ff ff       	call   801663 <syscall>
  801700:	83 c4 18             	add    $0x18,%esp
}
  801703:	90                   	nop
  801704:	c9                   	leave  
  801705:	c3                   	ret    

00801706 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801706:	55                   	push   %ebp
  801707:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801709:	8b 55 0c             	mov    0xc(%ebp),%edx
  80170c:	8b 45 08             	mov    0x8(%ebp),%eax
  80170f:	6a 00                	push   $0x0
  801711:	6a 00                	push   $0x0
  801713:	6a 00                	push   $0x0
  801715:	52                   	push   %edx
  801716:	50                   	push   %eax
  801717:	6a 08                	push   $0x8
  801719:	e8 45 ff ff ff       	call   801663 <syscall>
  80171e:	83 c4 18             	add    $0x18,%esp
}
  801721:	c9                   	leave  
  801722:	c3                   	ret    

00801723 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801723:	55                   	push   %ebp
  801724:	89 e5                	mov    %esp,%ebp
  801726:	56                   	push   %esi
  801727:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801728:	8b 75 18             	mov    0x18(%ebp),%esi
  80172b:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80172e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801731:	8b 55 0c             	mov    0xc(%ebp),%edx
  801734:	8b 45 08             	mov    0x8(%ebp),%eax
  801737:	56                   	push   %esi
  801738:	53                   	push   %ebx
  801739:	51                   	push   %ecx
  80173a:	52                   	push   %edx
  80173b:	50                   	push   %eax
  80173c:	6a 09                	push   $0x9
  80173e:	e8 20 ff ff ff       	call   801663 <syscall>
  801743:	83 c4 18             	add    $0x18,%esp
}
  801746:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801749:	5b                   	pop    %ebx
  80174a:	5e                   	pop    %esi
  80174b:	5d                   	pop    %ebp
  80174c:	c3                   	ret    

0080174d <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  80174d:	55                   	push   %ebp
  80174e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  801750:	6a 00                	push   $0x0
  801752:	6a 00                	push   $0x0
  801754:	6a 00                	push   $0x0
  801756:	6a 00                	push   $0x0
  801758:	ff 75 08             	pushl  0x8(%ebp)
  80175b:	6a 0a                	push   $0xa
  80175d:	e8 01 ff ff ff       	call   801663 <syscall>
  801762:	83 c4 18             	add    $0x18,%esp
}
  801765:	c9                   	leave  
  801766:	c3                   	ret    

00801767 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801767:	55                   	push   %ebp
  801768:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  80176a:	6a 00                	push   $0x0
  80176c:	6a 00                	push   $0x0
  80176e:	6a 00                	push   $0x0
  801770:	ff 75 0c             	pushl  0xc(%ebp)
  801773:	ff 75 08             	pushl  0x8(%ebp)
  801776:	6a 0b                	push   $0xb
  801778:	e8 e6 fe ff ff       	call   801663 <syscall>
  80177d:	83 c4 18             	add    $0x18,%esp
}
  801780:	c9                   	leave  
  801781:	c3                   	ret    

00801782 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801782:	55                   	push   %ebp
  801783:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801785:	6a 00                	push   $0x0
  801787:	6a 00                	push   $0x0
  801789:	6a 00                	push   $0x0
  80178b:	6a 00                	push   $0x0
  80178d:	6a 00                	push   $0x0
  80178f:	6a 0c                	push   $0xc
  801791:	e8 cd fe ff ff       	call   801663 <syscall>
  801796:	83 c4 18             	add    $0x18,%esp
}
  801799:	c9                   	leave  
  80179a:	c3                   	ret    

0080179b <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  80179b:	55                   	push   %ebp
  80179c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  80179e:	6a 00                	push   $0x0
  8017a0:	6a 00                	push   $0x0
  8017a2:	6a 00                	push   $0x0
  8017a4:	6a 00                	push   $0x0
  8017a6:	6a 00                	push   $0x0
  8017a8:	6a 0d                	push   $0xd
  8017aa:	e8 b4 fe ff ff       	call   801663 <syscall>
  8017af:	83 c4 18             	add    $0x18,%esp
}
  8017b2:	c9                   	leave  
  8017b3:	c3                   	ret    

008017b4 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8017b4:	55                   	push   %ebp
  8017b5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8017b7:	6a 00                	push   $0x0
  8017b9:	6a 00                	push   $0x0
  8017bb:	6a 00                	push   $0x0
  8017bd:	6a 00                	push   $0x0
  8017bf:	6a 00                	push   $0x0
  8017c1:	6a 0e                	push   $0xe
  8017c3:	e8 9b fe ff ff       	call   801663 <syscall>
  8017c8:	83 c4 18             	add    $0x18,%esp
}
  8017cb:	c9                   	leave  
  8017cc:	c3                   	ret    

008017cd <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8017cd:	55                   	push   %ebp
  8017ce:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8017d0:	6a 00                	push   $0x0
  8017d2:	6a 00                	push   $0x0
  8017d4:	6a 00                	push   $0x0
  8017d6:	6a 00                	push   $0x0
  8017d8:	6a 00                	push   $0x0
  8017da:	6a 0f                	push   $0xf
  8017dc:	e8 82 fe ff ff       	call   801663 <syscall>
  8017e1:	83 c4 18             	add    $0x18,%esp
}
  8017e4:	c9                   	leave  
  8017e5:	c3                   	ret    

008017e6 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8017e6:	55                   	push   %ebp
  8017e7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8017e9:	6a 00                	push   $0x0
  8017eb:	6a 00                	push   $0x0
  8017ed:	6a 00                	push   $0x0
  8017ef:	6a 00                	push   $0x0
  8017f1:	ff 75 08             	pushl  0x8(%ebp)
  8017f4:	6a 10                	push   $0x10
  8017f6:	e8 68 fe ff ff       	call   801663 <syscall>
  8017fb:	83 c4 18             	add    $0x18,%esp
}
  8017fe:	c9                   	leave  
  8017ff:	c3                   	ret    

00801800 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801800:	55                   	push   %ebp
  801801:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801803:	6a 00                	push   $0x0
  801805:	6a 00                	push   $0x0
  801807:	6a 00                	push   $0x0
  801809:	6a 00                	push   $0x0
  80180b:	6a 00                	push   $0x0
  80180d:	6a 11                	push   $0x11
  80180f:	e8 4f fe ff ff       	call   801663 <syscall>
  801814:	83 c4 18             	add    $0x18,%esp
}
  801817:	90                   	nop
  801818:	c9                   	leave  
  801819:	c3                   	ret    

0080181a <sys_cputc>:

void
sys_cputc(const char c)
{
  80181a:	55                   	push   %ebp
  80181b:	89 e5                	mov    %esp,%ebp
  80181d:	83 ec 04             	sub    $0x4,%esp
  801820:	8b 45 08             	mov    0x8(%ebp),%eax
  801823:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801826:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80182a:	6a 00                	push   $0x0
  80182c:	6a 00                	push   $0x0
  80182e:	6a 00                	push   $0x0
  801830:	6a 00                	push   $0x0
  801832:	50                   	push   %eax
  801833:	6a 01                	push   $0x1
  801835:	e8 29 fe ff ff       	call   801663 <syscall>
  80183a:	83 c4 18             	add    $0x18,%esp
}
  80183d:	90                   	nop
  80183e:	c9                   	leave  
  80183f:	c3                   	ret    

00801840 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801840:	55                   	push   %ebp
  801841:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801843:	6a 00                	push   $0x0
  801845:	6a 00                	push   $0x0
  801847:	6a 00                	push   $0x0
  801849:	6a 00                	push   $0x0
  80184b:	6a 00                	push   $0x0
  80184d:	6a 14                	push   $0x14
  80184f:	e8 0f fe ff ff       	call   801663 <syscall>
  801854:	83 c4 18             	add    $0x18,%esp
}
  801857:	90                   	nop
  801858:	c9                   	leave  
  801859:	c3                   	ret    

0080185a <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  80185a:	55                   	push   %ebp
  80185b:	89 e5                	mov    %esp,%ebp
  80185d:	83 ec 04             	sub    $0x4,%esp
  801860:	8b 45 10             	mov    0x10(%ebp),%eax
  801863:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801866:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801869:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80186d:	8b 45 08             	mov    0x8(%ebp),%eax
  801870:	6a 00                	push   $0x0
  801872:	51                   	push   %ecx
  801873:	52                   	push   %edx
  801874:	ff 75 0c             	pushl  0xc(%ebp)
  801877:	50                   	push   %eax
  801878:	6a 15                	push   $0x15
  80187a:	e8 e4 fd ff ff       	call   801663 <syscall>
  80187f:	83 c4 18             	add    $0x18,%esp
}
  801882:	c9                   	leave  
  801883:	c3                   	ret    

00801884 <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  801884:	55                   	push   %ebp
  801885:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801887:	8b 55 0c             	mov    0xc(%ebp),%edx
  80188a:	8b 45 08             	mov    0x8(%ebp),%eax
  80188d:	6a 00                	push   $0x0
  80188f:	6a 00                	push   $0x0
  801891:	6a 00                	push   $0x0
  801893:	52                   	push   %edx
  801894:	50                   	push   %eax
  801895:	6a 16                	push   $0x16
  801897:	e8 c7 fd ff ff       	call   801663 <syscall>
  80189c:	83 c4 18             	add    $0x18,%esp
}
  80189f:	c9                   	leave  
  8018a0:	c3                   	ret    

008018a1 <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  8018a1:	55                   	push   %ebp
  8018a2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8018a4:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8018a7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8018ad:	6a 00                	push   $0x0
  8018af:	6a 00                	push   $0x0
  8018b1:	51                   	push   %ecx
  8018b2:	52                   	push   %edx
  8018b3:	50                   	push   %eax
  8018b4:	6a 17                	push   $0x17
  8018b6:	e8 a8 fd ff ff       	call   801663 <syscall>
  8018bb:	83 c4 18             	add    $0x18,%esp
}
  8018be:	c9                   	leave  
  8018bf:	c3                   	ret    

008018c0 <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  8018c0:	55                   	push   %ebp
  8018c1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8018c3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8018c9:	6a 00                	push   $0x0
  8018cb:	6a 00                	push   $0x0
  8018cd:	6a 00                	push   $0x0
  8018cf:	52                   	push   %edx
  8018d0:	50                   	push   %eax
  8018d1:	6a 18                	push   $0x18
  8018d3:	e8 8b fd ff ff       	call   801663 <syscall>
  8018d8:	83 c4 18             	add    $0x18,%esp
}
  8018db:	c9                   	leave  
  8018dc:	c3                   	ret    

008018dd <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8018dd:	55                   	push   %ebp
  8018de:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8018e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8018e3:	6a 00                	push   $0x0
  8018e5:	ff 75 14             	pushl  0x14(%ebp)
  8018e8:	ff 75 10             	pushl  0x10(%ebp)
  8018eb:	ff 75 0c             	pushl  0xc(%ebp)
  8018ee:	50                   	push   %eax
  8018ef:	6a 19                	push   $0x19
  8018f1:	e8 6d fd ff ff       	call   801663 <syscall>
  8018f6:	83 c4 18             	add    $0x18,%esp
}
  8018f9:	c9                   	leave  
  8018fa:	c3                   	ret    

008018fb <sys_run_env>:

void sys_run_env(int32 envId)
{
  8018fb:	55                   	push   %ebp
  8018fc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8018fe:	8b 45 08             	mov    0x8(%ebp),%eax
  801901:	6a 00                	push   $0x0
  801903:	6a 00                	push   $0x0
  801905:	6a 00                	push   $0x0
  801907:	6a 00                	push   $0x0
  801909:	50                   	push   %eax
  80190a:	6a 1a                	push   $0x1a
  80190c:	e8 52 fd ff ff       	call   801663 <syscall>
  801911:	83 c4 18             	add    $0x18,%esp
}
  801914:	90                   	nop
  801915:	c9                   	leave  
  801916:	c3                   	ret    

00801917 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801917:	55                   	push   %ebp
  801918:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  80191a:	8b 45 08             	mov    0x8(%ebp),%eax
  80191d:	6a 00                	push   $0x0
  80191f:	6a 00                	push   $0x0
  801921:	6a 00                	push   $0x0
  801923:	6a 00                	push   $0x0
  801925:	50                   	push   %eax
  801926:	6a 1b                	push   $0x1b
  801928:	e8 36 fd ff ff       	call   801663 <syscall>
  80192d:	83 c4 18             	add    $0x18,%esp
}
  801930:	c9                   	leave  
  801931:	c3                   	ret    

00801932 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801932:	55                   	push   %ebp
  801933:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801935:	6a 00                	push   $0x0
  801937:	6a 00                	push   $0x0
  801939:	6a 00                	push   $0x0
  80193b:	6a 00                	push   $0x0
  80193d:	6a 00                	push   $0x0
  80193f:	6a 05                	push   $0x5
  801941:	e8 1d fd ff ff       	call   801663 <syscall>
  801946:	83 c4 18             	add    $0x18,%esp
}
  801949:	c9                   	leave  
  80194a:	c3                   	ret    

0080194b <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  80194b:	55                   	push   %ebp
  80194c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  80194e:	6a 00                	push   $0x0
  801950:	6a 00                	push   $0x0
  801952:	6a 00                	push   $0x0
  801954:	6a 00                	push   $0x0
  801956:	6a 00                	push   $0x0
  801958:	6a 06                	push   $0x6
  80195a:	e8 04 fd ff ff       	call   801663 <syscall>
  80195f:	83 c4 18             	add    $0x18,%esp
}
  801962:	c9                   	leave  
  801963:	c3                   	ret    

00801964 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801964:	55                   	push   %ebp
  801965:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801967:	6a 00                	push   $0x0
  801969:	6a 00                	push   $0x0
  80196b:	6a 00                	push   $0x0
  80196d:	6a 00                	push   $0x0
  80196f:	6a 00                	push   $0x0
  801971:	6a 07                	push   $0x7
  801973:	e8 eb fc ff ff       	call   801663 <syscall>
  801978:	83 c4 18             	add    $0x18,%esp
}
  80197b:	c9                   	leave  
  80197c:	c3                   	ret    

0080197d <sys_exit_env>:


void sys_exit_env(void)
{
  80197d:	55                   	push   %ebp
  80197e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801980:	6a 00                	push   $0x0
  801982:	6a 00                	push   $0x0
  801984:	6a 00                	push   $0x0
  801986:	6a 00                	push   $0x0
  801988:	6a 00                	push   $0x0
  80198a:	6a 1c                	push   $0x1c
  80198c:	e8 d2 fc ff ff       	call   801663 <syscall>
  801991:	83 c4 18             	add    $0x18,%esp
}
  801994:	90                   	nop
  801995:	c9                   	leave  
  801996:	c3                   	ret    

00801997 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  801997:	55                   	push   %ebp
  801998:	89 e5                	mov    %esp,%ebp
  80199a:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  80199d:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8019a0:	8d 50 04             	lea    0x4(%eax),%edx
  8019a3:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8019a6:	6a 00                	push   $0x0
  8019a8:	6a 00                	push   $0x0
  8019aa:	6a 00                	push   $0x0
  8019ac:	52                   	push   %edx
  8019ad:	50                   	push   %eax
  8019ae:	6a 1d                	push   $0x1d
  8019b0:	e8 ae fc ff ff       	call   801663 <syscall>
  8019b5:	83 c4 18             	add    $0x18,%esp
	return result;
  8019b8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8019bb:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8019be:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8019c1:	89 01                	mov    %eax,(%ecx)
  8019c3:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8019c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8019c9:	c9                   	leave  
  8019ca:	c2 04 00             	ret    $0x4

008019cd <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8019cd:	55                   	push   %ebp
  8019ce:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8019d0:	6a 00                	push   $0x0
  8019d2:	6a 00                	push   $0x0
  8019d4:	ff 75 10             	pushl  0x10(%ebp)
  8019d7:	ff 75 0c             	pushl  0xc(%ebp)
  8019da:	ff 75 08             	pushl  0x8(%ebp)
  8019dd:	6a 13                	push   $0x13
  8019df:	e8 7f fc ff ff       	call   801663 <syscall>
  8019e4:	83 c4 18             	add    $0x18,%esp
	return ;
  8019e7:	90                   	nop
}
  8019e8:	c9                   	leave  
  8019e9:	c3                   	ret    

008019ea <sys_rcr2>:
uint32 sys_rcr2()
{
  8019ea:	55                   	push   %ebp
  8019eb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8019ed:	6a 00                	push   $0x0
  8019ef:	6a 00                	push   $0x0
  8019f1:	6a 00                	push   $0x0
  8019f3:	6a 00                	push   $0x0
  8019f5:	6a 00                	push   $0x0
  8019f7:	6a 1e                	push   $0x1e
  8019f9:	e8 65 fc ff ff       	call   801663 <syscall>
  8019fe:	83 c4 18             	add    $0x18,%esp
}
  801a01:	c9                   	leave  
  801a02:	c3                   	ret    

00801a03 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  801a03:	55                   	push   %ebp
  801a04:	89 e5                	mov    %esp,%ebp
  801a06:	83 ec 04             	sub    $0x4,%esp
  801a09:	8b 45 08             	mov    0x8(%ebp),%eax
  801a0c:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801a0f:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801a13:	6a 00                	push   $0x0
  801a15:	6a 00                	push   $0x0
  801a17:	6a 00                	push   $0x0
  801a19:	6a 00                	push   $0x0
  801a1b:	50                   	push   %eax
  801a1c:	6a 1f                	push   $0x1f
  801a1e:	e8 40 fc ff ff       	call   801663 <syscall>
  801a23:	83 c4 18             	add    $0x18,%esp
	return ;
  801a26:	90                   	nop
}
  801a27:	c9                   	leave  
  801a28:	c3                   	ret    

00801a29 <rsttst>:
void rsttst()
{
  801a29:	55                   	push   %ebp
  801a2a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801a2c:	6a 00                	push   $0x0
  801a2e:	6a 00                	push   $0x0
  801a30:	6a 00                	push   $0x0
  801a32:	6a 00                	push   $0x0
  801a34:	6a 00                	push   $0x0
  801a36:	6a 21                	push   $0x21
  801a38:	e8 26 fc ff ff       	call   801663 <syscall>
  801a3d:	83 c4 18             	add    $0x18,%esp
	return ;
  801a40:	90                   	nop
}
  801a41:	c9                   	leave  
  801a42:	c3                   	ret    

00801a43 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801a43:	55                   	push   %ebp
  801a44:	89 e5                	mov    %esp,%ebp
  801a46:	83 ec 04             	sub    $0x4,%esp
  801a49:	8b 45 14             	mov    0x14(%ebp),%eax
  801a4c:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801a4f:	8b 55 18             	mov    0x18(%ebp),%edx
  801a52:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801a56:	52                   	push   %edx
  801a57:	50                   	push   %eax
  801a58:	ff 75 10             	pushl  0x10(%ebp)
  801a5b:	ff 75 0c             	pushl  0xc(%ebp)
  801a5e:	ff 75 08             	pushl  0x8(%ebp)
  801a61:	6a 20                	push   $0x20
  801a63:	e8 fb fb ff ff       	call   801663 <syscall>
  801a68:	83 c4 18             	add    $0x18,%esp
	return ;
  801a6b:	90                   	nop
}
  801a6c:	c9                   	leave  
  801a6d:	c3                   	ret    

00801a6e <chktst>:
void chktst(uint32 n)
{
  801a6e:	55                   	push   %ebp
  801a6f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801a71:	6a 00                	push   $0x0
  801a73:	6a 00                	push   $0x0
  801a75:	6a 00                	push   $0x0
  801a77:	6a 00                	push   $0x0
  801a79:	ff 75 08             	pushl  0x8(%ebp)
  801a7c:	6a 22                	push   $0x22
  801a7e:	e8 e0 fb ff ff       	call   801663 <syscall>
  801a83:	83 c4 18             	add    $0x18,%esp
	return ;
  801a86:	90                   	nop
}
  801a87:	c9                   	leave  
  801a88:	c3                   	ret    

00801a89 <inctst>:

void inctst()
{
  801a89:	55                   	push   %ebp
  801a8a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801a8c:	6a 00                	push   $0x0
  801a8e:	6a 00                	push   $0x0
  801a90:	6a 00                	push   $0x0
  801a92:	6a 00                	push   $0x0
  801a94:	6a 00                	push   $0x0
  801a96:	6a 23                	push   $0x23
  801a98:	e8 c6 fb ff ff       	call   801663 <syscall>
  801a9d:	83 c4 18             	add    $0x18,%esp
	return ;
  801aa0:	90                   	nop
}
  801aa1:	c9                   	leave  
  801aa2:	c3                   	ret    

00801aa3 <gettst>:
uint32 gettst()
{
  801aa3:	55                   	push   %ebp
  801aa4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801aa6:	6a 00                	push   $0x0
  801aa8:	6a 00                	push   $0x0
  801aaa:	6a 00                	push   $0x0
  801aac:	6a 00                	push   $0x0
  801aae:	6a 00                	push   $0x0
  801ab0:	6a 24                	push   $0x24
  801ab2:	e8 ac fb ff ff       	call   801663 <syscall>
  801ab7:	83 c4 18             	add    $0x18,%esp
}
  801aba:	c9                   	leave  
  801abb:	c3                   	ret    

00801abc <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  801abc:	55                   	push   %ebp
  801abd:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801abf:	6a 00                	push   $0x0
  801ac1:	6a 00                	push   $0x0
  801ac3:	6a 00                	push   $0x0
  801ac5:	6a 00                	push   $0x0
  801ac7:	6a 00                	push   $0x0
  801ac9:	6a 25                	push   $0x25
  801acb:	e8 93 fb ff ff       	call   801663 <syscall>
  801ad0:	83 c4 18             	add    $0x18,%esp
  801ad3:	a3 60 b0 81 00       	mov    %eax,0x81b060
	return uheapPlaceStrategy ;
  801ad8:	a1 60 b0 81 00       	mov    0x81b060,%eax
}
  801add:	c9                   	leave  
  801ade:	c3                   	ret    

00801adf <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801adf:	55                   	push   %ebp
  801ae0:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  801ae2:	8b 45 08             	mov    0x8(%ebp),%eax
  801ae5:	a3 60 b0 81 00       	mov    %eax,0x81b060
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801aea:	6a 00                	push   $0x0
  801aec:	6a 00                	push   $0x0
  801aee:	6a 00                	push   $0x0
  801af0:	6a 00                	push   $0x0
  801af2:	ff 75 08             	pushl  0x8(%ebp)
  801af5:	6a 26                	push   $0x26
  801af7:	e8 67 fb ff ff       	call   801663 <syscall>
  801afc:	83 c4 18             	add    $0x18,%esp
	return ;
  801aff:	90                   	nop
}
  801b00:	c9                   	leave  
  801b01:	c3                   	ret    

00801b02 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801b02:	55                   	push   %ebp
  801b03:	89 e5                	mov    %esp,%ebp
  801b05:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801b06:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801b09:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801b0c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b0f:	8b 45 08             	mov    0x8(%ebp),%eax
  801b12:	6a 00                	push   $0x0
  801b14:	53                   	push   %ebx
  801b15:	51                   	push   %ecx
  801b16:	52                   	push   %edx
  801b17:	50                   	push   %eax
  801b18:	6a 27                	push   $0x27
  801b1a:	e8 44 fb ff ff       	call   801663 <syscall>
  801b1f:	83 c4 18             	add    $0x18,%esp
}
  801b22:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b25:	c9                   	leave  
  801b26:	c3                   	ret    

00801b27 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801b27:	55                   	push   %ebp
  801b28:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801b2a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b2d:	8b 45 08             	mov    0x8(%ebp),%eax
  801b30:	6a 00                	push   $0x0
  801b32:	6a 00                	push   $0x0
  801b34:	6a 00                	push   $0x0
  801b36:	52                   	push   %edx
  801b37:	50                   	push   %eax
  801b38:	6a 28                	push   $0x28
  801b3a:	e8 24 fb ff ff       	call   801663 <syscall>
  801b3f:	83 c4 18             	add    $0x18,%esp
}
  801b42:	c9                   	leave  
  801b43:	c3                   	ret    

00801b44 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801b44:	55                   	push   %ebp
  801b45:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801b47:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801b4a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b4d:	8b 45 08             	mov    0x8(%ebp),%eax
  801b50:	6a 00                	push   $0x0
  801b52:	51                   	push   %ecx
  801b53:	ff 75 10             	pushl  0x10(%ebp)
  801b56:	52                   	push   %edx
  801b57:	50                   	push   %eax
  801b58:	6a 29                	push   $0x29
  801b5a:	e8 04 fb ff ff       	call   801663 <syscall>
  801b5f:	83 c4 18             	add    $0x18,%esp
}
  801b62:	c9                   	leave  
  801b63:	c3                   	ret    

00801b64 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801b64:	55                   	push   %ebp
  801b65:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801b67:	6a 00                	push   $0x0
  801b69:	6a 00                	push   $0x0
  801b6b:	ff 75 10             	pushl  0x10(%ebp)
  801b6e:	ff 75 0c             	pushl  0xc(%ebp)
  801b71:	ff 75 08             	pushl  0x8(%ebp)
  801b74:	6a 12                	push   $0x12
  801b76:	e8 e8 fa ff ff       	call   801663 <syscall>
  801b7b:	83 c4 18             	add    $0x18,%esp
	return ;
  801b7e:	90                   	nop
}
  801b7f:	c9                   	leave  
  801b80:	c3                   	ret    

00801b81 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  801b81:	55                   	push   %ebp
  801b82:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  801b84:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b87:	8b 45 08             	mov    0x8(%ebp),%eax
  801b8a:	6a 00                	push   $0x0
  801b8c:	6a 00                	push   $0x0
  801b8e:	6a 00                	push   $0x0
  801b90:	52                   	push   %edx
  801b91:	50                   	push   %eax
  801b92:	6a 2a                	push   $0x2a
  801b94:	e8 ca fa ff ff       	call   801663 <syscall>
  801b99:	83 c4 18             	add    $0x18,%esp
	return;
  801b9c:	90                   	nop
}
  801b9d:	c9                   	leave  
  801b9e:	c3                   	ret    

00801b9f <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  801b9f:	55                   	push   %ebp
  801ba0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  801ba2:	6a 00                	push   $0x0
  801ba4:	6a 00                	push   $0x0
  801ba6:	6a 00                	push   $0x0
  801ba8:	6a 00                	push   $0x0
  801baa:	6a 00                	push   $0x0
  801bac:	6a 2b                	push   $0x2b
  801bae:	e8 b0 fa ff ff       	call   801663 <syscall>
  801bb3:	83 c4 18             	add    $0x18,%esp
}
  801bb6:	c9                   	leave  
  801bb7:	c3                   	ret    

00801bb8 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801bb8:	55                   	push   %ebp
  801bb9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801bbb:	6a 00                	push   $0x0
  801bbd:	6a 00                	push   $0x0
  801bbf:	6a 00                	push   $0x0
  801bc1:	ff 75 0c             	pushl  0xc(%ebp)
  801bc4:	ff 75 08             	pushl  0x8(%ebp)
  801bc7:	6a 2d                	push   $0x2d
  801bc9:	e8 95 fa ff ff       	call   801663 <syscall>
  801bce:	83 c4 18             	add    $0x18,%esp
	return;
  801bd1:	90                   	nop
}
  801bd2:	c9                   	leave  
  801bd3:	c3                   	ret    

00801bd4 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801bd4:	55                   	push   %ebp
  801bd5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801bd7:	6a 00                	push   $0x0
  801bd9:	6a 00                	push   $0x0
  801bdb:	6a 00                	push   $0x0
  801bdd:	ff 75 0c             	pushl  0xc(%ebp)
  801be0:	ff 75 08             	pushl  0x8(%ebp)
  801be3:	6a 2c                	push   $0x2c
  801be5:	e8 79 fa ff ff       	call   801663 <syscall>
  801bea:	83 c4 18             	add    $0x18,%esp
	return ;
  801bed:	90                   	nop
}
  801bee:	c9                   	leave  
  801bef:	c3                   	ret    

00801bf0 <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  801bf0:	55                   	push   %ebp
  801bf1:	89 e5                	mov    %esp,%ebp
	//TODO: [PROJECT'25.IM#4] CPU SCHEDULING - #1 System Calls - Add suitable code here
	//Your code is here
	//Comment the following line
	//panic("sys_env_set_priority() is not implemented yet...!!");
	syscall(SYS_env_set_priority, envID, priority, 0, 0, 0);
  801bf3:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bf6:	8b 45 08             	mov    0x8(%ebp),%eax
  801bf9:	6a 00                	push   $0x0
  801bfb:	6a 00                	push   $0x0
  801bfd:	6a 00                	push   $0x0
  801bff:	52                   	push   %edx
  801c00:	50                   	push   %eax
  801c01:	6a 2e                	push   $0x2e
  801c03:	e8 5b fa ff ff       	call   801663 <syscall>
  801c08:	83 c4 18             	add    $0x18,%esp
	    return;
  801c0b:	90                   	nop
}
  801c0c:	c9                   	leave  
  801c0d:	c3                   	ret    
  801c0e:	66 90                	xchg   %ax,%ax

00801c10 <__udivdi3>:
  801c10:	55                   	push   %ebp
  801c11:	57                   	push   %edi
  801c12:	56                   	push   %esi
  801c13:	53                   	push   %ebx
  801c14:	83 ec 1c             	sub    $0x1c,%esp
  801c17:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801c1b:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801c1f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801c23:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801c27:	89 ca                	mov    %ecx,%edx
  801c29:	89 f8                	mov    %edi,%eax
  801c2b:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801c2f:	85 f6                	test   %esi,%esi
  801c31:	75 2d                	jne    801c60 <__udivdi3+0x50>
  801c33:	39 cf                	cmp    %ecx,%edi
  801c35:	77 65                	ja     801c9c <__udivdi3+0x8c>
  801c37:	89 fd                	mov    %edi,%ebp
  801c39:	85 ff                	test   %edi,%edi
  801c3b:	75 0b                	jne    801c48 <__udivdi3+0x38>
  801c3d:	b8 01 00 00 00       	mov    $0x1,%eax
  801c42:	31 d2                	xor    %edx,%edx
  801c44:	f7 f7                	div    %edi
  801c46:	89 c5                	mov    %eax,%ebp
  801c48:	31 d2                	xor    %edx,%edx
  801c4a:	89 c8                	mov    %ecx,%eax
  801c4c:	f7 f5                	div    %ebp
  801c4e:	89 c1                	mov    %eax,%ecx
  801c50:	89 d8                	mov    %ebx,%eax
  801c52:	f7 f5                	div    %ebp
  801c54:	89 cf                	mov    %ecx,%edi
  801c56:	89 fa                	mov    %edi,%edx
  801c58:	83 c4 1c             	add    $0x1c,%esp
  801c5b:	5b                   	pop    %ebx
  801c5c:	5e                   	pop    %esi
  801c5d:	5f                   	pop    %edi
  801c5e:	5d                   	pop    %ebp
  801c5f:	c3                   	ret    
  801c60:	39 ce                	cmp    %ecx,%esi
  801c62:	77 28                	ja     801c8c <__udivdi3+0x7c>
  801c64:	0f bd fe             	bsr    %esi,%edi
  801c67:	83 f7 1f             	xor    $0x1f,%edi
  801c6a:	75 40                	jne    801cac <__udivdi3+0x9c>
  801c6c:	39 ce                	cmp    %ecx,%esi
  801c6e:	72 0a                	jb     801c7a <__udivdi3+0x6a>
  801c70:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801c74:	0f 87 9e 00 00 00    	ja     801d18 <__udivdi3+0x108>
  801c7a:	b8 01 00 00 00       	mov    $0x1,%eax
  801c7f:	89 fa                	mov    %edi,%edx
  801c81:	83 c4 1c             	add    $0x1c,%esp
  801c84:	5b                   	pop    %ebx
  801c85:	5e                   	pop    %esi
  801c86:	5f                   	pop    %edi
  801c87:	5d                   	pop    %ebp
  801c88:	c3                   	ret    
  801c89:	8d 76 00             	lea    0x0(%esi),%esi
  801c8c:	31 ff                	xor    %edi,%edi
  801c8e:	31 c0                	xor    %eax,%eax
  801c90:	89 fa                	mov    %edi,%edx
  801c92:	83 c4 1c             	add    $0x1c,%esp
  801c95:	5b                   	pop    %ebx
  801c96:	5e                   	pop    %esi
  801c97:	5f                   	pop    %edi
  801c98:	5d                   	pop    %ebp
  801c99:	c3                   	ret    
  801c9a:	66 90                	xchg   %ax,%ax
  801c9c:	89 d8                	mov    %ebx,%eax
  801c9e:	f7 f7                	div    %edi
  801ca0:	31 ff                	xor    %edi,%edi
  801ca2:	89 fa                	mov    %edi,%edx
  801ca4:	83 c4 1c             	add    $0x1c,%esp
  801ca7:	5b                   	pop    %ebx
  801ca8:	5e                   	pop    %esi
  801ca9:	5f                   	pop    %edi
  801caa:	5d                   	pop    %ebp
  801cab:	c3                   	ret    
  801cac:	bd 20 00 00 00       	mov    $0x20,%ebp
  801cb1:	89 eb                	mov    %ebp,%ebx
  801cb3:	29 fb                	sub    %edi,%ebx
  801cb5:	89 f9                	mov    %edi,%ecx
  801cb7:	d3 e6                	shl    %cl,%esi
  801cb9:	89 c5                	mov    %eax,%ebp
  801cbb:	88 d9                	mov    %bl,%cl
  801cbd:	d3 ed                	shr    %cl,%ebp
  801cbf:	89 e9                	mov    %ebp,%ecx
  801cc1:	09 f1                	or     %esi,%ecx
  801cc3:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801cc7:	89 f9                	mov    %edi,%ecx
  801cc9:	d3 e0                	shl    %cl,%eax
  801ccb:	89 c5                	mov    %eax,%ebp
  801ccd:	89 d6                	mov    %edx,%esi
  801ccf:	88 d9                	mov    %bl,%cl
  801cd1:	d3 ee                	shr    %cl,%esi
  801cd3:	89 f9                	mov    %edi,%ecx
  801cd5:	d3 e2                	shl    %cl,%edx
  801cd7:	8b 44 24 08          	mov    0x8(%esp),%eax
  801cdb:	88 d9                	mov    %bl,%cl
  801cdd:	d3 e8                	shr    %cl,%eax
  801cdf:	09 c2                	or     %eax,%edx
  801ce1:	89 d0                	mov    %edx,%eax
  801ce3:	89 f2                	mov    %esi,%edx
  801ce5:	f7 74 24 0c          	divl   0xc(%esp)
  801ce9:	89 d6                	mov    %edx,%esi
  801ceb:	89 c3                	mov    %eax,%ebx
  801ced:	f7 e5                	mul    %ebp
  801cef:	39 d6                	cmp    %edx,%esi
  801cf1:	72 19                	jb     801d0c <__udivdi3+0xfc>
  801cf3:	74 0b                	je     801d00 <__udivdi3+0xf0>
  801cf5:	89 d8                	mov    %ebx,%eax
  801cf7:	31 ff                	xor    %edi,%edi
  801cf9:	e9 58 ff ff ff       	jmp    801c56 <__udivdi3+0x46>
  801cfe:	66 90                	xchg   %ax,%ax
  801d00:	8b 54 24 08          	mov    0x8(%esp),%edx
  801d04:	89 f9                	mov    %edi,%ecx
  801d06:	d3 e2                	shl    %cl,%edx
  801d08:	39 c2                	cmp    %eax,%edx
  801d0a:	73 e9                	jae    801cf5 <__udivdi3+0xe5>
  801d0c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801d0f:	31 ff                	xor    %edi,%edi
  801d11:	e9 40 ff ff ff       	jmp    801c56 <__udivdi3+0x46>
  801d16:	66 90                	xchg   %ax,%ax
  801d18:	31 c0                	xor    %eax,%eax
  801d1a:	e9 37 ff ff ff       	jmp    801c56 <__udivdi3+0x46>
  801d1f:	90                   	nop

00801d20 <__umoddi3>:
  801d20:	55                   	push   %ebp
  801d21:	57                   	push   %edi
  801d22:	56                   	push   %esi
  801d23:	53                   	push   %ebx
  801d24:	83 ec 1c             	sub    $0x1c,%esp
  801d27:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801d2b:	8b 74 24 34          	mov    0x34(%esp),%esi
  801d2f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801d33:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801d37:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801d3b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801d3f:	89 f3                	mov    %esi,%ebx
  801d41:	89 fa                	mov    %edi,%edx
  801d43:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801d47:	89 34 24             	mov    %esi,(%esp)
  801d4a:	85 c0                	test   %eax,%eax
  801d4c:	75 1a                	jne    801d68 <__umoddi3+0x48>
  801d4e:	39 f7                	cmp    %esi,%edi
  801d50:	0f 86 a2 00 00 00    	jbe    801df8 <__umoddi3+0xd8>
  801d56:	89 c8                	mov    %ecx,%eax
  801d58:	89 f2                	mov    %esi,%edx
  801d5a:	f7 f7                	div    %edi
  801d5c:	89 d0                	mov    %edx,%eax
  801d5e:	31 d2                	xor    %edx,%edx
  801d60:	83 c4 1c             	add    $0x1c,%esp
  801d63:	5b                   	pop    %ebx
  801d64:	5e                   	pop    %esi
  801d65:	5f                   	pop    %edi
  801d66:	5d                   	pop    %ebp
  801d67:	c3                   	ret    
  801d68:	39 f0                	cmp    %esi,%eax
  801d6a:	0f 87 ac 00 00 00    	ja     801e1c <__umoddi3+0xfc>
  801d70:	0f bd e8             	bsr    %eax,%ebp
  801d73:	83 f5 1f             	xor    $0x1f,%ebp
  801d76:	0f 84 ac 00 00 00    	je     801e28 <__umoddi3+0x108>
  801d7c:	bf 20 00 00 00       	mov    $0x20,%edi
  801d81:	29 ef                	sub    %ebp,%edi
  801d83:	89 fe                	mov    %edi,%esi
  801d85:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801d89:	89 e9                	mov    %ebp,%ecx
  801d8b:	d3 e0                	shl    %cl,%eax
  801d8d:	89 d7                	mov    %edx,%edi
  801d8f:	89 f1                	mov    %esi,%ecx
  801d91:	d3 ef                	shr    %cl,%edi
  801d93:	09 c7                	or     %eax,%edi
  801d95:	89 e9                	mov    %ebp,%ecx
  801d97:	d3 e2                	shl    %cl,%edx
  801d99:	89 14 24             	mov    %edx,(%esp)
  801d9c:	89 d8                	mov    %ebx,%eax
  801d9e:	d3 e0                	shl    %cl,%eax
  801da0:	89 c2                	mov    %eax,%edx
  801da2:	8b 44 24 08          	mov    0x8(%esp),%eax
  801da6:	d3 e0                	shl    %cl,%eax
  801da8:	89 44 24 04          	mov    %eax,0x4(%esp)
  801dac:	8b 44 24 08          	mov    0x8(%esp),%eax
  801db0:	89 f1                	mov    %esi,%ecx
  801db2:	d3 e8                	shr    %cl,%eax
  801db4:	09 d0                	or     %edx,%eax
  801db6:	d3 eb                	shr    %cl,%ebx
  801db8:	89 da                	mov    %ebx,%edx
  801dba:	f7 f7                	div    %edi
  801dbc:	89 d3                	mov    %edx,%ebx
  801dbe:	f7 24 24             	mull   (%esp)
  801dc1:	89 c6                	mov    %eax,%esi
  801dc3:	89 d1                	mov    %edx,%ecx
  801dc5:	39 d3                	cmp    %edx,%ebx
  801dc7:	0f 82 87 00 00 00    	jb     801e54 <__umoddi3+0x134>
  801dcd:	0f 84 91 00 00 00    	je     801e64 <__umoddi3+0x144>
  801dd3:	8b 54 24 04          	mov    0x4(%esp),%edx
  801dd7:	29 f2                	sub    %esi,%edx
  801dd9:	19 cb                	sbb    %ecx,%ebx
  801ddb:	89 d8                	mov    %ebx,%eax
  801ddd:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801de1:	d3 e0                	shl    %cl,%eax
  801de3:	89 e9                	mov    %ebp,%ecx
  801de5:	d3 ea                	shr    %cl,%edx
  801de7:	09 d0                	or     %edx,%eax
  801de9:	89 e9                	mov    %ebp,%ecx
  801deb:	d3 eb                	shr    %cl,%ebx
  801ded:	89 da                	mov    %ebx,%edx
  801def:	83 c4 1c             	add    $0x1c,%esp
  801df2:	5b                   	pop    %ebx
  801df3:	5e                   	pop    %esi
  801df4:	5f                   	pop    %edi
  801df5:	5d                   	pop    %ebp
  801df6:	c3                   	ret    
  801df7:	90                   	nop
  801df8:	89 fd                	mov    %edi,%ebp
  801dfa:	85 ff                	test   %edi,%edi
  801dfc:	75 0b                	jne    801e09 <__umoddi3+0xe9>
  801dfe:	b8 01 00 00 00       	mov    $0x1,%eax
  801e03:	31 d2                	xor    %edx,%edx
  801e05:	f7 f7                	div    %edi
  801e07:	89 c5                	mov    %eax,%ebp
  801e09:	89 f0                	mov    %esi,%eax
  801e0b:	31 d2                	xor    %edx,%edx
  801e0d:	f7 f5                	div    %ebp
  801e0f:	89 c8                	mov    %ecx,%eax
  801e11:	f7 f5                	div    %ebp
  801e13:	89 d0                	mov    %edx,%eax
  801e15:	e9 44 ff ff ff       	jmp    801d5e <__umoddi3+0x3e>
  801e1a:	66 90                	xchg   %ax,%ax
  801e1c:	89 c8                	mov    %ecx,%eax
  801e1e:	89 f2                	mov    %esi,%edx
  801e20:	83 c4 1c             	add    $0x1c,%esp
  801e23:	5b                   	pop    %ebx
  801e24:	5e                   	pop    %esi
  801e25:	5f                   	pop    %edi
  801e26:	5d                   	pop    %ebp
  801e27:	c3                   	ret    
  801e28:	3b 04 24             	cmp    (%esp),%eax
  801e2b:	72 06                	jb     801e33 <__umoddi3+0x113>
  801e2d:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801e31:	77 0f                	ja     801e42 <__umoddi3+0x122>
  801e33:	89 f2                	mov    %esi,%edx
  801e35:	29 f9                	sub    %edi,%ecx
  801e37:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801e3b:	89 14 24             	mov    %edx,(%esp)
  801e3e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801e42:	8b 44 24 04          	mov    0x4(%esp),%eax
  801e46:	8b 14 24             	mov    (%esp),%edx
  801e49:	83 c4 1c             	add    $0x1c,%esp
  801e4c:	5b                   	pop    %ebx
  801e4d:	5e                   	pop    %esi
  801e4e:	5f                   	pop    %edi
  801e4f:	5d                   	pop    %ebp
  801e50:	c3                   	ret    
  801e51:	8d 76 00             	lea    0x0(%esi),%esi
  801e54:	2b 04 24             	sub    (%esp),%eax
  801e57:	19 fa                	sbb    %edi,%edx
  801e59:	89 d1                	mov    %edx,%ecx
  801e5b:	89 c6                	mov    %eax,%esi
  801e5d:	e9 71 ff ff ff       	jmp    801dd3 <__umoddi3+0xb3>
  801e62:	66 90                	xchg   %ax,%ax
  801e64:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801e68:	72 ea                	jb     801e54 <__umoddi3+0x134>
  801e6a:	89 d9                	mov    %ebx,%ecx
  801e6c:	e9 62 ff ff ff       	jmp    801dd3 <__umoddi3+0xb3>
