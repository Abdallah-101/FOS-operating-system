
obj/user/tst_envfree5_1:     file format elf32-i386


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
  800031:	e8 17 01 00 00       	call   80014d <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
// Scenario that tests the usage of shared variables
#include <inc/lib.h>

void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	83 ec 28             	sub    $0x28,%esp
	// Testing removing the shared variables
	// Testing scenario 5_1: Kill ONE program has shared variables and it frees them
	int *numOfFinished = smalloc("finishedCount", sizeof(int), 1) ;
  80003e:	83 ec 04             	sub    $0x4,%esp
  800041:	6a 01                	push   $0x1
  800043:	6a 04                	push   $0x4
  800045:	68 a0 41 80 00       	push   $0x8041a0
  80004a:	e8 2c 22 00 00       	call   80227b <smalloc>
  80004f:	83 c4 10             	add    $0x10,%esp
  800052:	89 45 f4             	mov    %eax,-0xc(%ebp)
	*numOfFinished = 0 ;
  800055:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800058:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	int freeFrames_before = sys_calculate_free_frames() ;
  80005e:	e8 dc 2e 00 00       	call   802f3f <sys_calculate_free_frames>
  800063:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int usedDiskPages_before = sys_pf_calculate_allocated_pages() ;
  800066:	e8 1f 2f 00 00       	call   802f8a <sys_pf_calculate_allocated_pages>
  80006b:	89 45 ec             	mov    %eax,-0x14(%ebp)
	cprintf("\n---# of free frames before running programs = %d\n", freeFrames_before);
  80006e:	83 ec 08             	sub    $0x8,%esp
  800071:	ff 75 f0             	pushl  -0x10(%ebp)
  800074:	68 b0 41 80 00       	push   $0x8041b0
  800079:	e8 56 05 00 00       	call   8005d4 <cprintf>
  80007e:	83 c4 10             	add    $0x10,%esp

	int32 envIdProcessA = sys_create_env("ef_tshr4", 3000,(myEnv->SecondListSize), 50);
  800081:	a1 20 50 80 00       	mov    0x805020,%eax
  800086:	8b 80 a0 05 00 00    	mov    0x5a0(%eax),%eax
  80008c:	6a 32                	push   $0x32
  80008e:	50                   	push   %eax
  80008f:	68 b8 0b 00 00       	push   $0xbb8
  800094:	68 e3 41 80 00       	push   $0x8041e3
  800099:	e8 fc 2f 00 00       	call   80309a <sys_create_env>
  80009e:	83 c4 10             	add    $0x10,%esp
  8000a1:	89 45 e8             	mov    %eax,-0x18(%ebp)

	sys_run_env(envIdProcessA);
  8000a4:	83 ec 0c             	sub    $0xc,%esp
  8000a7:	ff 75 e8             	pushl  -0x18(%ebp)
  8000aa:	e8 09 30 00 00       	call   8030b8 <sys_run_env>
  8000af:	83 c4 10             	add    $0x10,%esp

	while (*numOfFinished != 1) ;
  8000b2:	90                   	nop
  8000b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8000b6:	8b 00                	mov    (%eax),%eax
  8000b8:	83 f8 01             	cmp    $0x1,%eax
  8000bb:	75 f6                	jne    8000b3 <_main+0x7b>
	cprintf("\n---# of free frames after running programs = %d\n", sys_calculate_free_frames());
  8000bd:	e8 7d 2e 00 00       	call   802f3f <sys_calculate_free_frames>
  8000c2:	83 ec 08             	sub    $0x8,%esp
  8000c5:	50                   	push   %eax
  8000c6:	68 ec 41 80 00       	push   $0x8041ec
  8000cb:	e8 04 05 00 00       	call   8005d4 <cprintf>
  8000d0:	83 c4 10             	add    $0x10,%esp

	sys_destroy_env(envIdProcessA);
  8000d3:	83 ec 0c             	sub    $0xc,%esp
  8000d6:	ff 75 e8             	pushl  -0x18(%ebp)
  8000d9:	e8 f6 2f 00 00       	call   8030d4 <sys_destroy_env>
  8000de:	83 c4 10             	add    $0x10,%esp

	//Checking the number of frames after killing the created environments
	int freeFrames_after = sys_calculate_free_frames() ;
  8000e1:	e8 59 2e 00 00       	call   802f3f <sys_calculate_free_frames>
  8000e6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	int usedDiskPages_after = sys_pf_calculate_allocated_pages() ;
  8000e9:	e8 9c 2e 00 00       	call   802f8a <sys_pf_calculate_allocated_pages>
  8000ee:	89 45 e0             	mov    %eax,-0x20(%ebp)

	if ((freeFrames_after - freeFrames_before) != 0) {
  8000f1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8000f4:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8000f7:	74 2e                	je     800127 <_main+0xef>
		cprintf("\n---# of free frames after closing running programs not as before running = %d\ndifference = %d\n",
  8000f9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8000fc:	2b 45 f0             	sub    -0x10(%ebp),%eax
  8000ff:	83 ec 04             	sub    $0x4,%esp
  800102:	50                   	push   %eax
  800103:	ff 75 e4             	pushl  -0x1c(%ebp)
  800106:	68 20 42 80 00       	push   $0x804220
  80010b:	e8 c4 04 00 00       	call   8005d4 <cprintf>
  800110:	83 c4 10             	add    $0x10,%esp
				freeFrames_after, freeFrames_after - freeFrames_before);
		panic("env_free() does not work correctly... check it again.");
  800113:	83 ec 04             	sub    $0x4,%esp
  800116:	68 80 42 80 00       	push   $0x804280
  80011b:	6a 1f                	push   $0x1f
  80011d:	68 b6 42 80 00       	push   $0x8042b6
  800122:	e8 df 01 00 00       	call   800306 <_panic>
	}

	cprintf("\n---# of free frames after closing running programs returned back to be as before running = %d\n", freeFrames_after);
  800127:	83 ec 08             	sub    $0x8,%esp
  80012a:	ff 75 e4             	pushl  -0x1c(%ebp)
  80012d:	68 cc 42 80 00       	push   $0x8042cc
  800132:	e8 9d 04 00 00       	call   8005d4 <cprintf>
  800137:	83 c4 10             	add    $0x10,%esp

	cprintf("\n\nCongratulations!! test scenario 5_1 for envfree completed successfully.\n");
  80013a:	83 ec 0c             	sub    $0xc,%esp
  80013d:	68 2c 43 80 00       	push   $0x80432c
  800142:	e8 8d 04 00 00       	call   8005d4 <cprintf>
  800147:	83 c4 10             	add    $0x10,%esp
	return;
  80014a:	90                   	nop
}
  80014b:	c9                   	leave  
  80014c:	c3                   	ret    

0080014d <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  80014d:	55                   	push   %ebp
  80014e:	89 e5                	mov    %esp,%ebp
  800150:	57                   	push   %edi
  800151:	56                   	push   %esi
  800152:	53                   	push   %ebx
  800153:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  800156:	e8 ad 2f 00 00       	call   803108 <sys_getenvindex>
  80015b:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  80015e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800161:	89 d0                	mov    %edx,%eax
  800163:	c1 e0 02             	shl    $0x2,%eax
  800166:	01 d0                	add    %edx,%eax
  800168:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80016f:	01 d0                	add    %edx,%eax
  800171:	89 c2                	mov    %eax,%edx
  800173:	c1 e2 04             	shl    $0x4,%edx
  800176:	29 c2                	sub    %eax,%edx
  800178:	8d 04 95 00 00 00 00 	lea    0x0(,%edx,4),%eax
  80017f:	89 c2                	mov    %eax,%edx
  800181:	8d 82 00 00 c0 ee    	lea    -0x11400000(%edx),%eax
  800187:	a3 20 50 80 00       	mov    %eax,0x805020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  80018c:	a1 20 50 80 00       	mov    0x805020,%eax
  800191:	8a 40 20             	mov    0x20(%eax),%al
  800194:	84 c0                	test   %al,%al
  800196:	74 0d                	je     8001a5 <libmain+0x58>
		binaryname = myEnv->prog_name;
  800198:	a1 20 50 80 00       	mov    0x805020,%eax
  80019d:	83 c0 20             	add    $0x20,%eax
  8001a0:	a3 04 50 80 00       	mov    %eax,0x805004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8001a5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8001a9:	7e 0a                	jle    8001b5 <libmain+0x68>
		binaryname = argv[0];
  8001ab:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001ae:	8b 00                	mov    (%eax),%eax
  8001b0:	a3 04 50 80 00       	mov    %eax,0x805004

	// call user main routine
	_main(argc, argv);
  8001b5:	83 ec 08             	sub    $0x8,%esp
  8001b8:	ff 75 0c             	pushl  0xc(%ebp)
  8001bb:	ff 75 08             	pushl  0x8(%ebp)
  8001be:	e8 75 fe ff ff       	call   800038 <_main>
  8001c3:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  8001c6:	a1 00 50 80 00       	mov    0x805000,%eax
  8001cb:	85 c0                	test   %eax,%eax
  8001cd:	0f 84 01 01 00 00    	je     8002d4 <libmain+0x187>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  8001d3:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  8001d9:	bb 70 44 80 00       	mov    $0x804470,%ebx
  8001de:	ba 0e 00 00 00       	mov    $0xe,%edx
  8001e3:	89 c7                	mov    %eax,%edi
  8001e5:	89 de                	mov    %ebx,%esi
  8001e7:	89 d1                	mov    %edx,%ecx
  8001e9:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  8001eb:	8d 55 8a             	lea    -0x76(%ebp),%edx
  8001ee:	b9 56 00 00 00       	mov    $0x56,%ecx
  8001f3:	b0 00                	mov    $0x0,%al
  8001f5:	89 d7                	mov    %edx,%edi
  8001f7:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  8001f9:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  800200:	8d 45 e0             	lea    -0x20(%ebp),%eax
  800203:	83 ec 08             	sub    $0x8,%esp
  800206:	50                   	push   %eax
  800207:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  80020d:	50                   	push   %eax
  80020e:	e8 2b 31 00 00       	call   80333e <sys_utilities>
  800213:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  800216:	e8 74 2c 00 00       	call   802e8f <sys_lock_cons>
		{
			cprintf("**************************************\n");
  80021b:	83 ec 0c             	sub    $0xc,%esp
  80021e:	68 90 43 80 00       	push   $0x804390
  800223:	e8 ac 03 00 00       	call   8005d4 <cprintf>
  800228:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  80022b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80022e:	85 c0                	test   %eax,%eax
  800230:	74 18                	je     80024a <libmain+0xfd>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  800232:	e8 25 31 00 00       	call   80335c <sys_get_optimal_num_faults>
  800237:	83 ec 08             	sub    $0x8,%esp
  80023a:	50                   	push   %eax
  80023b:	68 b8 43 80 00       	push   $0x8043b8
  800240:	e8 8f 03 00 00       	call   8005d4 <cprintf>
  800245:	83 c4 10             	add    $0x10,%esp
  800248:	eb 59                	jmp    8002a3 <libmain+0x156>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  80024a:	a1 20 50 80 00       	mov    0x805020,%eax
  80024f:	8b 90 bc 05 00 00    	mov    0x5bc(%eax),%edx
  800255:	a1 20 50 80 00       	mov    0x805020,%eax
  80025a:	8b 80 ac 05 00 00    	mov    0x5ac(%eax),%eax
  800260:	83 ec 04             	sub    $0x4,%esp
  800263:	52                   	push   %edx
  800264:	50                   	push   %eax
  800265:	68 dc 43 80 00       	push   $0x8043dc
  80026a:	e8 65 03 00 00       	call   8005d4 <cprintf>
  80026f:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800272:	a1 20 50 80 00       	mov    0x805020,%eax
  800277:	8b 88 d0 05 00 00    	mov    0x5d0(%eax),%ecx
  80027d:	a1 20 50 80 00       	mov    0x805020,%eax
  800282:	8b 90 cc 05 00 00    	mov    0x5cc(%eax),%edx
  800288:	a1 20 50 80 00       	mov    0x805020,%eax
  80028d:	8b 80 c8 05 00 00    	mov    0x5c8(%eax),%eax
  800293:	51                   	push   %ecx
  800294:	52                   	push   %edx
  800295:	50                   	push   %eax
  800296:	68 04 44 80 00       	push   $0x804404
  80029b:	e8 34 03 00 00       	call   8005d4 <cprintf>
  8002a0:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8002a3:	a1 20 50 80 00       	mov    0x805020,%eax
  8002a8:	8b 80 d4 05 00 00    	mov    0x5d4(%eax),%eax
  8002ae:	83 ec 08             	sub    $0x8,%esp
  8002b1:	50                   	push   %eax
  8002b2:	68 5c 44 80 00       	push   $0x80445c
  8002b7:	e8 18 03 00 00       	call   8005d4 <cprintf>
  8002bc:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  8002bf:	83 ec 0c             	sub    $0xc,%esp
  8002c2:	68 90 43 80 00       	push   $0x804390
  8002c7:	e8 08 03 00 00       	call   8005d4 <cprintf>
  8002cc:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  8002cf:	e8 d5 2b 00 00       	call   802ea9 <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  8002d4:	e8 1f 00 00 00       	call   8002f8 <exit>
}
  8002d9:	90                   	nop
  8002da:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002dd:	5b                   	pop    %ebx
  8002de:	5e                   	pop    %esi
  8002df:	5f                   	pop    %edi
  8002e0:	5d                   	pop    %ebp
  8002e1:	c3                   	ret    

008002e2 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8002e2:	55                   	push   %ebp
  8002e3:	89 e5                	mov    %esp,%ebp
  8002e5:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8002e8:	83 ec 0c             	sub    $0xc,%esp
  8002eb:	6a 00                	push   $0x0
  8002ed:	e8 e2 2d 00 00       	call   8030d4 <sys_destroy_env>
  8002f2:	83 c4 10             	add    $0x10,%esp
}
  8002f5:	90                   	nop
  8002f6:	c9                   	leave  
  8002f7:	c3                   	ret    

008002f8 <exit>:

void
exit(void)
{
  8002f8:	55                   	push   %ebp
  8002f9:	89 e5                	mov    %esp,%ebp
  8002fb:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8002fe:	e8 37 2e 00 00       	call   80313a <sys_exit_env>
}
  800303:	90                   	nop
  800304:	c9                   	leave  
  800305:	c3                   	ret    

00800306 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800306:	55                   	push   %ebp
  800307:	89 e5                	mov    %esp,%ebp
  800309:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  80030c:	8d 45 10             	lea    0x10(%ebp),%eax
  80030f:	83 c0 04             	add    $0x4,%eax
  800312:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800315:	a1 18 d1 81 00       	mov    0x81d118,%eax
  80031a:	85 c0                	test   %eax,%eax
  80031c:	74 16                	je     800334 <_panic+0x2e>
		cprintf("%s: ", argv0);
  80031e:	a1 18 d1 81 00       	mov    0x81d118,%eax
  800323:	83 ec 08             	sub    $0x8,%esp
  800326:	50                   	push   %eax
  800327:	68 d4 44 80 00       	push   $0x8044d4
  80032c:	e8 a3 02 00 00       	call   8005d4 <cprintf>
  800331:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  800334:	a1 04 50 80 00       	mov    0x805004,%eax
  800339:	83 ec 0c             	sub    $0xc,%esp
  80033c:	ff 75 0c             	pushl  0xc(%ebp)
  80033f:	ff 75 08             	pushl  0x8(%ebp)
  800342:	50                   	push   %eax
  800343:	68 dc 44 80 00       	push   $0x8044dc
  800348:	6a 74                	push   $0x74
  80034a:	e8 b2 02 00 00       	call   800601 <cprintf_colored>
  80034f:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  800352:	8b 45 10             	mov    0x10(%ebp),%eax
  800355:	83 ec 08             	sub    $0x8,%esp
  800358:	ff 75 f4             	pushl  -0xc(%ebp)
  80035b:	50                   	push   %eax
  80035c:	e8 04 02 00 00       	call   800565 <vcprintf>
  800361:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800364:	83 ec 08             	sub    $0x8,%esp
  800367:	6a 00                	push   $0x0
  800369:	68 04 45 80 00       	push   $0x804504
  80036e:	e8 f2 01 00 00       	call   800565 <vcprintf>
  800373:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800376:	e8 7d ff ff ff       	call   8002f8 <exit>

	// should not return here
	while (1) ;
  80037b:	eb fe                	jmp    80037b <_panic+0x75>

0080037d <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  80037d:	55                   	push   %ebp
  80037e:	89 e5                	mov    %esp,%ebp
  800380:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800383:	a1 20 50 80 00       	mov    0x805020,%eax
  800388:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  80038e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800391:	39 c2                	cmp    %eax,%edx
  800393:	74 14                	je     8003a9 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800395:	83 ec 04             	sub    $0x4,%esp
  800398:	68 08 45 80 00       	push   $0x804508
  80039d:	6a 26                	push   $0x26
  80039f:	68 54 45 80 00       	push   $0x804554
  8003a4:	e8 5d ff ff ff       	call   800306 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8003a9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8003b0:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8003b7:	e9 c5 00 00 00       	jmp    800481 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  8003bc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003bf:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8003c9:	01 d0                	add    %edx,%eax
  8003cb:	8b 00                	mov    (%eax),%eax
  8003cd:	85 c0                	test   %eax,%eax
  8003cf:	75 08                	jne    8003d9 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  8003d1:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8003d4:	e9 a5 00 00 00       	jmp    80047e <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  8003d9:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8003e0:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8003e7:	eb 69                	jmp    800452 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8003e9:	a1 20 50 80 00       	mov    0x805020,%eax
  8003ee:	8b 88 a4 05 00 00    	mov    0x5a4(%eax),%ecx
  8003f4:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8003f7:	89 d0                	mov    %edx,%eax
  8003f9:	01 c0                	add    %eax,%eax
  8003fb:	01 d0                	add    %edx,%eax
  8003fd:	c1 e0 03             	shl    $0x3,%eax
  800400:	01 c8                	add    %ecx,%eax
  800402:	8a 40 04             	mov    0x4(%eax),%al
  800405:	84 c0                	test   %al,%al
  800407:	75 46                	jne    80044f <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800409:	a1 20 50 80 00       	mov    0x805020,%eax
  80040e:	8b 88 a4 05 00 00    	mov    0x5a4(%eax),%ecx
  800414:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800417:	89 d0                	mov    %edx,%eax
  800419:	01 c0                	add    %eax,%eax
  80041b:	01 d0                	add    %edx,%eax
  80041d:	c1 e0 03             	shl    $0x3,%eax
  800420:	01 c8                	add    %ecx,%eax
  800422:	8b 00                	mov    (%eax),%eax
  800424:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800427:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80042a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80042f:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800431:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800434:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80043b:	8b 45 08             	mov    0x8(%ebp),%eax
  80043e:	01 c8                	add    %ecx,%eax
  800440:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800442:	39 c2                	cmp    %eax,%edx
  800444:	75 09                	jne    80044f <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  800446:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  80044d:	eb 15                	jmp    800464 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80044f:	ff 45 e8             	incl   -0x18(%ebp)
  800452:	a1 20 50 80 00       	mov    0x805020,%eax
  800457:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  80045d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800460:	39 c2                	cmp    %eax,%edx
  800462:	77 85                	ja     8003e9 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800464:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800468:	75 14                	jne    80047e <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  80046a:	83 ec 04             	sub    $0x4,%esp
  80046d:	68 60 45 80 00       	push   $0x804560
  800472:	6a 3a                	push   $0x3a
  800474:	68 54 45 80 00       	push   $0x804554
  800479:	e8 88 fe ff ff       	call   800306 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  80047e:	ff 45 f0             	incl   -0x10(%ebp)
  800481:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800484:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800487:	0f 8c 2f ff ff ff    	jl     8003bc <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  80048d:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800494:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80049b:	eb 26                	jmp    8004c3 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  80049d:	a1 20 50 80 00       	mov    0x805020,%eax
  8004a2:	8b 88 a4 05 00 00    	mov    0x5a4(%eax),%ecx
  8004a8:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8004ab:	89 d0                	mov    %edx,%eax
  8004ad:	01 c0                	add    %eax,%eax
  8004af:	01 d0                	add    %edx,%eax
  8004b1:	c1 e0 03             	shl    $0x3,%eax
  8004b4:	01 c8                	add    %ecx,%eax
  8004b6:	8a 40 04             	mov    0x4(%eax),%al
  8004b9:	3c 01                	cmp    $0x1,%al
  8004bb:	75 03                	jne    8004c0 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  8004bd:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8004c0:	ff 45 e0             	incl   -0x20(%ebp)
  8004c3:	a1 20 50 80 00       	mov    0x805020,%eax
  8004c8:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8004ce:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8004d1:	39 c2                	cmp    %eax,%edx
  8004d3:	77 c8                	ja     80049d <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8004d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8004d8:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8004db:	74 14                	je     8004f1 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  8004dd:	83 ec 04             	sub    $0x4,%esp
  8004e0:	68 b4 45 80 00       	push   $0x8045b4
  8004e5:	6a 44                	push   $0x44
  8004e7:	68 54 45 80 00       	push   $0x804554
  8004ec:	e8 15 fe ff ff       	call   800306 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8004f1:	90                   	nop
  8004f2:	c9                   	leave  
  8004f3:	c3                   	ret    

008004f4 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  8004f4:	55                   	push   %ebp
  8004f5:	89 e5                	mov    %esp,%ebp
  8004f7:	53                   	push   %ebx
  8004f8:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  8004fb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004fe:	8b 00                	mov    (%eax),%eax
  800500:	8d 48 01             	lea    0x1(%eax),%ecx
  800503:	8b 55 0c             	mov    0xc(%ebp),%edx
  800506:	89 0a                	mov    %ecx,(%edx)
  800508:	8b 55 08             	mov    0x8(%ebp),%edx
  80050b:	88 d1                	mov    %dl,%cl
  80050d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800510:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800514:	8b 45 0c             	mov    0xc(%ebp),%eax
  800517:	8b 00                	mov    (%eax),%eax
  800519:	3d ff 00 00 00       	cmp    $0xff,%eax
  80051e:	75 30                	jne    800550 <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  800520:	8b 15 1c d1 81 00    	mov    0x81d11c,%edx
  800526:	a0 44 50 80 00       	mov    0x805044,%al
  80052b:	0f b6 c0             	movzbl %al,%eax
  80052e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800531:	8b 09                	mov    (%ecx),%ecx
  800533:	89 cb                	mov    %ecx,%ebx
  800535:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800538:	83 c1 08             	add    $0x8,%ecx
  80053b:	52                   	push   %edx
  80053c:	50                   	push   %eax
  80053d:	53                   	push   %ebx
  80053e:	51                   	push   %ecx
  80053f:	e8 07 29 00 00       	call   802e4b <sys_cputs>
  800544:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800547:	8b 45 0c             	mov    0xc(%ebp),%eax
  80054a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800550:	8b 45 0c             	mov    0xc(%ebp),%eax
  800553:	8b 40 04             	mov    0x4(%eax),%eax
  800556:	8d 50 01             	lea    0x1(%eax),%edx
  800559:	8b 45 0c             	mov    0xc(%ebp),%eax
  80055c:	89 50 04             	mov    %edx,0x4(%eax)
}
  80055f:	90                   	nop
  800560:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800563:	c9                   	leave  
  800564:	c3                   	ret    

00800565 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800565:	55                   	push   %ebp
  800566:	89 e5                	mov    %esp,%ebp
  800568:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80056e:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800575:	00 00 00 
	b.cnt = 0;
  800578:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80057f:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800582:	ff 75 0c             	pushl  0xc(%ebp)
  800585:	ff 75 08             	pushl  0x8(%ebp)
  800588:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80058e:	50                   	push   %eax
  80058f:	68 f4 04 80 00       	push   $0x8004f4
  800594:	e8 5a 02 00 00       	call   8007f3 <vprintfmt>
  800599:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  80059c:	8b 15 1c d1 81 00    	mov    0x81d11c,%edx
  8005a2:	a0 44 50 80 00       	mov    0x805044,%al
  8005a7:	0f b6 c0             	movzbl %al,%eax
  8005aa:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  8005b0:	52                   	push   %edx
  8005b1:	50                   	push   %eax
  8005b2:	51                   	push   %ecx
  8005b3:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8005b9:	83 c0 08             	add    $0x8,%eax
  8005bc:	50                   	push   %eax
  8005bd:	e8 89 28 00 00       	call   802e4b <sys_cputs>
  8005c2:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8005c5:	c6 05 44 50 80 00 00 	movb   $0x0,0x805044
	return b.cnt;
  8005cc:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8005d2:	c9                   	leave  
  8005d3:	c3                   	ret    

008005d4 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  8005d4:	55                   	push   %ebp
  8005d5:	89 e5                	mov    %esp,%ebp
  8005d7:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8005da:	c6 05 44 50 80 00 01 	movb   $0x1,0x805044
	va_start(ap, fmt);
  8005e1:	8d 45 0c             	lea    0xc(%ebp),%eax
  8005e4:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8005e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8005ea:	83 ec 08             	sub    $0x8,%esp
  8005ed:	ff 75 f4             	pushl  -0xc(%ebp)
  8005f0:	50                   	push   %eax
  8005f1:	e8 6f ff ff ff       	call   800565 <vcprintf>
  8005f6:	83 c4 10             	add    $0x10,%esp
  8005f9:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8005fc:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8005ff:	c9                   	leave  
  800600:	c3                   	ret    

00800601 <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  800601:	55                   	push   %ebp
  800602:	89 e5                	mov    %esp,%ebp
  800604:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800607:	c6 05 44 50 80 00 01 	movb   $0x1,0x805044
	curTextClr = (textClr << 8) ; //set text color by the given value
  80060e:	8b 45 08             	mov    0x8(%ebp),%eax
  800611:	c1 e0 08             	shl    $0x8,%eax
  800614:	a3 1c d1 81 00       	mov    %eax,0x81d11c
	va_start(ap, fmt);
  800619:	8d 45 0c             	lea    0xc(%ebp),%eax
  80061c:	83 c0 04             	add    $0x4,%eax
  80061f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800622:	8b 45 0c             	mov    0xc(%ebp),%eax
  800625:	83 ec 08             	sub    $0x8,%esp
  800628:	ff 75 f4             	pushl  -0xc(%ebp)
  80062b:	50                   	push   %eax
  80062c:	e8 34 ff ff ff       	call   800565 <vcprintf>
  800631:	83 c4 10             	add    $0x10,%esp
  800634:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  800637:	c7 05 1c d1 81 00 00 	movl   $0x700,0x81d11c
  80063e:	07 00 00 

	return cnt;
  800641:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800644:	c9                   	leave  
  800645:	c3                   	ret    

00800646 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  800646:	55                   	push   %ebp
  800647:	89 e5                	mov    %esp,%ebp
  800649:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  80064c:	e8 3e 28 00 00       	call   802e8f <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  800651:	8d 45 0c             	lea    0xc(%ebp),%eax
  800654:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  800657:	8b 45 08             	mov    0x8(%ebp),%eax
  80065a:	83 ec 08             	sub    $0x8,%esp
  80065d:	ff 75 f4             	pushl  -0xc(%ebp)
  800660:	50                   	push   %eax
  800661:	e8 ff fe ff ff       	call   800565 <vcprintf>
  800666:	83 c4 10             	add    $0x10,%esp
  800669:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  80066c:	e8 38 28 00 00       	call   802ea9 <sys_unlock_cons>
	return cnt;
  800671:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800674:	c9                   	leave  
  800675:	c3                   	ret    

00800676 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800676:	55                   	push   %ebp
  800677:	89 e5                	mov    %esp,%ebp
  800679:	53                   	push   %ebx
  80067a:	83 ec 14             	sub    $0x14,%esp
  80067d:	8b 45 10             	mov    0x10(%ebp),%eax
  800680:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800683:	8b 45 14             	mov    0x14(%ebp),%eax
  800686:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800689:	8b 45 18             	mov    0x18(%ebp),%eax
  80068c:	ba 00 00 00 00       	mov    $0x0,%edx
  800691:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800694:	77 55                	ja     8006eb <printnum+0x75>
  800696:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800699:	72 05                	jb     8006a0 <printnum+0x2a>
  80069b:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80069e:	77 4b                	ja     8006eb <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8006a0:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8006a3:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8006a6:	8b 45 18             	mov    0x18(%ebp),%eax
  8006a9:	ba 00 00 00 00       	mov    $0x0,%edx
  8006ae:	52                   	push   %edx
  8006af:	50                   	push   %eax
  8006b0:	ff 75 f4             	pushl  -0xc(%ebp)
  8006b3:	ff 75 f0             	pushl  -0x10(%ebp)
  8006b6:	e8 81 38 00 00       	call   803f3c <__udivdi3>
  8006bb:	83 c4 10             	add    $0x10,%esp
  8006be:	83 ec 04             	sub    $0x4,%esp
  8006c1:	ff 75 20             	pushl  0x20(%ebp)
  8006c4:	53                   	push   %ebx
  8006c5:	ff 75 18             	pushl  0x18(%ebp)
  8006c8:	52                   	push   %edx
  8006c9:	50                   	push   %eax
  8006ca:	ff 75 0c             	pushl  0xc(%ebp)
  8006cd:	ff 75 08             	pushl  0x8(%ebp)
  8006d0:	e8 a1 ff ff ff       	call   800676 <printnum>
  8006d5:	83 c4 20             	add    $0x20,%esp
  8006d8:	eb 1a                	jmp    8006f4 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8006da:	83 ec 08             	sub    $0x8,%esp
  8006dd:	ff 75 0c             	pushl  0xc(%ebp)
  8006e0:	ff 75 20             	pushl  0x20(%ebp)
  8006e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8006e6:	ff d0                	call   *%eax
  8006e8:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8006eb:	ff 4d 1c             	decl   0x1c(%ebp)
  8006ee:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  8006f2:	7f e6                	jg     8006da <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8006f4:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8006f7:	bb 00 00 00 00       	mov    $0x0,%ebx
  8006fc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8006ff:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800702:	53                   	push   %ebx
  800703:	51                   	push   %ecx
  800704:	52                   	push   %edx
  800705:	50                   	push   %eax
  800706:	e8 41 39 00 00       	call   80404c <__umoddi3>
  80070b:	83 c4 10             	add    $0x10,%esp
  80070e:	05 14 48 80 00       	add    $0x804814,%eax
  800713:	8a 00                	mov    (%eax),%al
  800715:	0f be c0             	movsbl %al,%eax
  800718:	83 ec 08             	sub    $0x8,%esp
  80071b:	ff 75 0c             	pushl  0xc(%ebp)
  80071e:	50                   	push   %eax
  80071f:	8b 45 08             	mov    0x8(%ebp),%eax
  800722:	ff d0                	call   *%eax
  800724:	83 c4 10             	add    $0x10,%esp
}
  800727:	90                   	nop
  800728:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80072b:	c9                   	leave  
  80072c:	c3                   	ret    

0080072d <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80072d:	55                   	push   %ebp
  80072e:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800730:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800734:	7e 1c                	jle    800752 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800736:	8b 45 08             	mov    0x8(%ebp),%eax
  800739:	8b 00                	mov    (%eax),%eax
  80073b:	8d 50 08             	lea    0x8(%eax),%edx
  80073e:	8b 45 08             	mov    0x8(%ebp),%eax
  800741:	89 10                	mov    %edx,(%eax)
  800743:	8b 45 08             	mov    0x8(%ebp),%eax
  800746:	8b 00                	mov    (%eax),%eax
  800748:	83 e8 08             	sub    $0x8,%eax
  80074b:	8b 50 04             	mov    0x4(%eax),%edx
  80074e:	8b 00                	mov    (%eax),%eax
  800750:	eb 40                	jmp    800792 <getuint+0x65>
	else if (lflag)
  800752:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800756:	74 1e                	je     800776 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800758:	8b 45 08             	mov    0x8(%ebp),%eax
  80075b:	8b 00                	mov    (%eax),%eax
  80075d:	8d 50 04             	lea    0x4(%eax),%edx
  800760:	8b 45 08             	mov    0x8(%ebp),%eax
  800763:	89 10                	mov    %edx,(%eax)
  800765:	8b 45 08             	mov    0x8(%ebp),%eax
  800768:	8b 00                	mov    (%eax),%eax
  80076a:	83 e8 04             	sub    $0x4,%eax
  80076d:	8b 00                	mov    (%eax),%eax
  80076f:	ba 00 00 00 00       	mov    $0x0,%edx
  800774:	eb 1c                	jmp    800792 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800776:	8b 45 08             	mov    0x8(%ebp),%eax
  800779:	8b 00                	mov    (%eax),%eax
  80077b:	8d 50 04             	lea    0x4(%eax),%edx
  80077e:	8b 45 08             	mov    0x8(%ebp),%eax
  800781:	89 10                	mov    %edx,(%eax)
  800783:	8b 45 08             	mov    0x8(%ebp),%eax
  800786:	8b 00                	mov    (%eax),%eax
  800788:	83 e8 04             	sub    $0x4,%eax
  80078b:	8b 00                	mov    (%eax),%eax
  80078d:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800792:	5d                   	pop    %ebp
  800793:	c3                   	ret    

00800794 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800794:	55                   	push   %ebp
  800795:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800797:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80079b:	7e 1c                	jle    8007b9 <getint+0x25>
		return va_arg(*ap, long long);
  80079d:	8b 45 08             	mov    0x8(%ebp),%eax
  8007a0:	8b 00                	mov    (%eax),%eax
  8007a2:	8d 50 08             	lea    0x8(%eax),%edx
  8007a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8007a8:	89 10                	mov    %edx,(%eax)
  8007aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8007ad:	8b 00                	mov    (%eax),%eax
  8007af:	83 e8 08             	sub    $0x8,%eax
  8007b2:	8b 50 04             	mov    0x4(%eax),%edx
  8007b5:	8b 00                	mov    (%eax),%eax
  8007b7:	eb 38                	jmp    8007f1 <getint+0x5d>
	else if (lflag)
  8007b9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8007bd:	74 1a                	je     8007d9 <getint+0x45>
		return va_arg(*ap, long);
  8007bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8007c2:	8b 00                	mov    (%eax),%eax
  8007c4:	8d 50 04             	lea    0x4(%eax),%edx
  8007c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8007ca:	89 10                	mov    %edx,(%eax)
  8007cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8007cf:	8b 00                	mov    (%eax),%eax
  8007d1:	83 e8 04             	sub    $0x4,%eax
  8007d4:	8b 00                	mov    (%eax),%eax
  8007d6:	99                   	cltd   
  8007d7:	eb 18                	jmp    8007f1 <getint+0x5d>
	else
		return va_arg(*ap, int);
  8007d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8007dc:	8b 00                	mov    (%eax),%eax
  8007de:	8d 50 04             	lea    0x4(%eax),%edx
  8007e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8007e4:	89 10                	mov    %edx,(%eax)
  8007e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8007e9:	8b 00                	mov    (%eax),%eax
  8007eb:	83 e8 04             	sub    $0x4,%eax
  8007ee:	8b 00                	mov    (%eax),%eax
  8007f0:	99                   	cltd   
}
  8007f1:	5d                   	pop    %ebp
  8007f2:	c3                   	ret    

008007f3 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8007f3:	55                   	push   %ebp
  8007f4:	89 e5                	mov    %esp,%ebp
  8007f6:	56                   	push   %esi
  8007f7:	53                   	push   %ebx
  8007f8:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8007fb:	eb 17                	jmp    800814 <vprintfmt+0x21>
			if (ch == '\0')
  8007fd:	85 db                	test   %ebx,%ebx
  8007ff:	0f 84 c1 03 00 00    	je     800bc6 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  800805:	83 ec 08             	sub    $0x8,%esp
  800808:	ff 75 0c             	pushl  0xc(%ebp)
  80080b:	53                   	push   %ebx
  80080c:	8b 45 08             	mov    0x8(%ebp),%eax
  80080f:	ff d0                	call   *%eax
  800811:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800814:	8b 45 10             	mov    0x10(%ebp),%eax
  800817:	8d 50 01             	lea    0x1(%eax),%edx
  80081a:	89 55 10             	mov    %edx,0x10(%ebp)
  80081d:	8a 00                	mov    (%eax),%al
  80081f:	0f b6 d8             	movzbl %al,%ebx
  800822:	83 fb 25             	cmp    $0x25,%ebx
  800825:	75 d6                	jne    8007fd <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800827:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  80082b:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800832:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800839:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800840:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800847:	8b 45 10             	mov    0x10(%ebp),%eax
  80084a:	8d 50 01             	lea    0x1(%eax),%edx
  80084d:	89 55 10             	mov    %edx,0x10(%ebp)
  800850:	8a 00                	mov    (%eax),%al
  800852:	0f b6 d8             	movzbl %al,%ebx
  800855:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800858:	83 f8 5b             	cmp    $0x5b,%eax
  80085b:	0f 87 3d 03 00 00    	ja     800b9e <vprintfmt+0x3ab>
  800861:	8b 04 85 38 48 80 00 	mov    0x804838(,%eax,4),%eax
  800868:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  80086a:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  80086e:	eb d7                	jmp    800847 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800870:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800874:	eb d1                	jmp    800847 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800876:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  80087d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800880:	89 d0                	mov    %edx,%eax
  800882:	c1 e0 02             	shl    $0x2,%eax
  800885:	01 d0                	add    %edx,%eax
  800887:	01 c0                	add    %eax,%eax
  800889:	01 d8                	add    %ebx,%eax
  80088b:	83 e8 30             	sub    $0x30,%eax
  80088e:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800891:	8b 45 10             	mov    0x10(%ebp),%eax
  800894:	8a 00                	mov    (%eax),%al
  800896:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800899:	83 fb 2f             	cmp    $0x2f,%ebx
  80089c:	7e 3e                	jle    8008dc <vprintfmt+0xe9>
  80089e:	83 fb 39             	cmp    $0x39,%ebx
  8008a1:	7f 39                	jg     8008dc <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8008a3:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8008a6:	eb d5                	jmp    80087d <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8008a8:	8b 45 14             	mov    0x14(%ebp),%eax
  8008ab:	83 c0 04             	add    $0x4,%eax
  8008ae:	89 45 14             	mov    %eax,0x14(%ebp)
  8008b1:	8b 45 14             	mov    0x14(%ebp),%eax
  8008b4:	83 e8 04             	sub    $0x4,%eax
  8008b7:	8b 00                	mov    (%eax),%eax
  8008b9:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8008bc:	eb 1f                	jmp    8008dd <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8008be:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008c2:	79 83                	jns    800847 <vprintfmt+0x54>
				width = 0;
  8008c4:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8008cb:	e9 77 ff ff ff       	jmp    800847 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  8008d0:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  8008d7:	e9 6b ff ff ff       	jmp    800847 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  8008dc:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8008dd:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008e1:	0f 89 60 ff ff ff    	jns    800847 <vprintfmt+0x54>
				width = precision, precision = -1;
  8008e7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8008ea:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8008ed:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  8008f4:	e9 4e ff ff ff       	jmp    800847 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8008f9:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  8008fc:	e9 46 ff ff ff       	jmp    800847 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800901:	8b 45 14             	mov    0x14(%ebp),%eax
  800904:	83 c0 04             	add    $0x4,%eax
  800907:	89 45 14             	mov    %eax,0x14(%ebp)
  80090a:	8b 45 14             	mov    0x14(%ebp),%eax
  80090d:	83 e8 04             	sub    $0x4,%eax
  800910:	8b 00                	mov    (%eax),%eax
  800912:	83 ec 08             	sub    $0x8,%esp
  800915:	ff 75 0c             	pushl  0xc(%ebp)
  800918:	50                   	push   %eax
  800919:	8b 45 08             	mov    0x8(%ebp),%eax
  80091c:	ff d0                	call   *%eax
  80091e:	83 c4 10             	add    $0x10,%esp
			break;
  800921:	e9 9b 02 00 00       	jmp    800bc1 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800926:	8b 45 14             	mov    0x14(%ebp),%eax
  800929:	83 c0 04             	add    $0x4,%eax
  80092c:	89 45 14             	mov    %eax,0x14(%ebp)
  80092f:	8b 45 14             	mov    0x14(%ebp),%eax
  800932:	83 e8 04             	sub    $0x4,%eax
  800935:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800937:	85 db                	test   %ebx,%ebx
  800939:	79 02                	jns    80093d <vprintfmt+0x14a>
				err = -err;
  80093b:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  80093d:	83 fb 64             	cmp    $0x64,%ebx
  800940:	7f 0b                	jg     80094d <vprintfmt+0x15a>
  800942:	8b 34 9d 80 46 80 00 	mov    0x804680(,%ebx,4),%esi
  800949:	85 f6                	test   %esi,%esi
  80094b:	75 19                	jne    800966 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  80094d:	53                   	push   %ebx
  80094e:	68 25 48 80 00       	push   $0x804825
  800953:	ff 75 0c             	pushl  0xc(%ebp)
  800956:	ff 75 08             	pushl  0x8(%ebp)
  800959:	e8 70 02 00 00       	call   800bce <printfmt>
  80095e:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800961:	e9 5b 02 00 00       	jmp    800bc1 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800966:	56                   	push   %esi
  800967:	68 2e 48 80 00       	push   $0x80482e
  80096c:	ff 75 0c             	pushl  0xc(%ebp)
  80096f:	ff 75 08             	pushl  0x8(%ebp)
  800972:	e8 57 02 00 00       	call   800bce <printfmt>
  800977:	83 c4 10             	add    $0x10,%esp
			break;
  80097a:	e9 42 02 00 00       	jmp    800bc1 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  80097f:	8b 45 14             	mov    0x14(%ebp),%eax
  800982:	83 c0 04             	add    $0x4,%eax
  800985:	89 45 14             	mov    %eax,0x14(%ebp)
  800988:	8b 45 14             	mov    0x14(%ebp),%eax
  80098b:	83 e8 04             	sub    $0x4,%eax
  80098e:	8b 30                	mov    (%eax),%esi
  800990:	85 f6                	test   %esi,%esi
  800992:	75 05                	jne    800999 <vprintfmt+0x1a6>
				p = "(null)";
  800994:	be 31 48 80 00       	mov    $0x804831,%esi
			if (width > 0 && padc != '-')
  800999:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80099d:	7e 6d                	jle    800a0c <vprintfmt+0x219>
  80099f:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8009a3:	74 67                	je     800a0c <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8009a5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8009a8:	83 ec 08             	sub    $0x8,%esp
  8009ab:	50                   	push   %eax
  8009ac:	56                   	push   %esi
  8009ad:	e8 1e 03 00 00       	call   800cd0 <strnlen>
  8009b2:	83 c4 10             	add    $0x10,%esp
  8009b5:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  8009b8:	eb 16                	jmp    8009d0 <vprintfmt+0x1dd>
					putch(padc, putdat);
  8009ba:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  8009be:	83 ec 08             	sub    $0x8,%esp
  8009c1:	ff 75 0c             	pushl  0xc(%ebp)
  8009c4:	50                   	push   %eax
  8009c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8009c8:	ff d0                	call   *%eax
  8009ca:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8009cd:	ff 4d e4             	decl   -0x1c(%ebp)
  8009d0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8009d4:	7f e4                	jg     8009ba <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8009d6:	eb 34                	jmp    800a0c <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  8009d8:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8009dc:	74 1c                	je     8009fa <vprintfmt+0x207>
  8009de:	83 fb 1f             	cmp    $0x1f,%ebx
  8009e1:	7e 05                	jle    8009e8 <vprintfmt+0x1f5>
  8009e3:	83 fb 7e             	cmp    $0x7e,%ebx
  8009e6:	7e 12                	jle    8009fa <vprintfmt+0x207>
					putch('?', putdat);
  8009e8:	83 ec 08             	sub    $0x8,%esp
  8009eb:	ff 75 0c             	pushl  0xc(%ebp)
  8009ee:	6a 3f                	push   $0x3f
  8009f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8009f3:	ff d0                	call   *%eax
  8009f5:	83 c4 10             	add    $0x10,%esp
  8009f8:	eb 0f                	jmp    800a09 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  8009fa:	83 ec 08             	sub    $0x8,%esp
  8009fd:	ff 75 0c             	pushl  0xc(%ebp)
  800a00:	53                   	push   %ebx
  800a01:	8b 45 08             	mov    0x8(%ebp),%eax
  800a04:	ff d0                	call   *%eax
  800a06:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800a09:	ff 4d e4             	decl   -0x1c(%ebp)
  800a0c:	89 f0                	mov    %esi,%eax
  800a0e:	8d 70 01             	lea    0x1(%eax),%esi
  800a11:	8a 00                	mov    (%eax),%al
  800a13:	0f be d8             	movsbl %al,%ebx
  800a16:	85 db                	test   %ebx,%ebx
  800a18:	74 24                	je     800a3e <vprintfmt+0x24b>
  800a1a:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800a1e:	78 b8                	js     8009d8 <vprintfmt+0x1e5>
  800a20:	ff 4d e0             	decl   -0x20(%ebp)
  800a23:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800a27:	79 af                	jns    8009d8 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800a29:	eb 13                	jmp    800a3e <vprintfmt+0x24b>
				putch(' ', putdat);
  800a2b:	83 ec 08             	sub    $0x8,%esp
  800a2e:	ff 75 0c             	pushl  0xc(%ebp)
  800a31:	6a 20                	push   $0x20
  800a33:	8b 45 08             	mov    0x8(%ebp),%eax
  800a36:	ff d0                	call   *%eax
  800a38:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800a3b:	ff 4d e4             	decl   -0x1c(%ebp)
  800a3e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a42:	7f e7                	jg     800a2b <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800a44:	e9 78 01 00 00       	jmp    800bc1 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800a49:	83 ec 08             	sub    $0x8,%esp
  800a4c:	ff 75 e8             	pushl  -0x18(%ebp)
  800a4f:	8d 45 14             	lea    0x14(%ebp),%eax
  800a52:	50                   	push   %eax
  800a53:	e8 3c fd ff ff       	call   800794 <getint>
  800a58:	83 c4 10             	add    $0x10,%esp
  800a5b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a5e:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800a61:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a64:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a67:	85 d2                	test   %edx,%edx
  800a69:	79 23                	jns    800a8e <vprintfmt+0x29b>
				putch('-', putdat);
  800a6b:	83 ec 08             	sub    $0x8,%esp
  800a6e:	ff 75 0c             	pushl  0xc(%ebp)
  800a71:	6a 2d                	push   $0x2d
  800a73:	8b 45 08             	mov    0x8(%ebp),%eax
  800a76:	ff d0                	call   *%eax
  800a78:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800a7b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a7e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a81:	f7 d8                	neg    %eax
  800a83:	83 d2 00             	adc    $0x0,%edx
  800a86:	f7 da                	neg    %edx
  800a88:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a8b:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800a8e:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800a95:	e9 bc 00 00 00       	jmp    800b56 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800a9a:	83 ec 08             	sub    $0x8,%esp
  800a9d:	ff 75 e8             	pushl  -0x18(%ebp)
  800aa0:	8d 45 14             	lea    0x14(%ebp),%eax
  800aa3:	50                   	push   %eax
  800aa4:	e8 84 fc ff ff       	call   80072d <getuint>
  800aa9:	83 c4 10             	add    $0x10,%esp
  800aac:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800aaf:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800ab2:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800ab9:	e9 98 00 00 00       	jmp    800b56 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800abe:	83 ec 08             	sub    $0x8,%esp
  800ac1:	ff 75 0c             	pushl  0xc(%ebp)
  800ac4:	6a 58                	push   $0x58
  800ac6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ac9:	ff d0                	call   *%eax
  800acb:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800ace:	83 ec 08             	sub    $0x8,%esp
  800ad1:	ff 75 0c             	pushl  0xc(%ebp)
  800ad4:	6a 58                	push   $0x58
  800ad6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ad9:	ff d0                	call   *%eax
  800adb:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800ade:	83 ec 08             	sub    $0x8,%esp
  800ae1:	ff 75 0c             	pushl  0xc(%ebp)
  800ae4:	6a 58                	push   $0x58
  800ae6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ae9:	ff d0                	call   *%eax
  800aeb:	83 c4 10             	add    $0x10,%esp
			break;
  800aee:	e9 ce 00 00 00       	jmp    800bc1 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800af3:	83 ec 08             	sub    $0x8,%esp
  800af6:	ff 75 0c             	pushl  0xc(%ebp)
  800af9:	6a 30                	push   $0x30
  800afb:	8b 45 08             	mov    0x8(%ebp),%eax
  800afe:	ff d0                	call   *%eax
  800b00:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800b03:	83 ec 08             	sub    $0x8,%esp
  800b06:	ff 75 0c             	pushl  0xc(%ebp)
  800b09:	6a 78                	push   $0x78
  800b0b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b0e:	ff d0                	call   *%eax
  800b10:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800b13:	8b 45 14             	mov    0x14(%ebp),%eax
  800b16:	83 c0 04             	add    $0x4,%eax
  800b19:	89 45 14             	mov    %eax,0x14(%ebp)
  800b1c:	8b 45 14             	mov    0x14(%ebp),%eax
  800b1f:	83 e8 04             	sub    $0x4,%eax
  800b22:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800b24:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b27:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800b2e:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800b35:	eb 1f                	jmp    800b56 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800b37:	83 ec 08             	sub    $0x8,%esp
  800b3a:	ff 75 e8             	pushl  -0x18(%ebp)
  800b3d:	8d 45 14             	lea    0x14(%ebp),%eax
  800b40:	50                   	push   %eax
  800b41:	e8 e7 fb ff ff       	call   80072d <getuint>
  800b46:	83 c4 10             	add    $0x10,%esp
  800b49:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b4c:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800b4f:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800b56:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800b5a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800b5d:	83 ec 04             	sub    $0x4,%esp
  800b60:	52                   	push   %edx
  800b61:	ff 75 e4             	pushl  -0x1c(%ebp)
  800b64:	50                   	push   %eax
  800b65:	ff 75 f4             	pushl  -0xc(%ebp)
  800b68:	ff 75 f0             	pushl  -0x10(%ebp)
  800b6b:	ff 75 0c             	pushl  0xc(%ebp)
  800b6e:	ff 75 08             	pushl  0x8(%ebp)
  800b71:	e8 00 fb ff ff       	call   800676 <printnum>
  800b76:	83 c4 20             	add    $0x20,%esp
			break;
  800b79:	eb 46                	jmp    800bc1 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800b7b:	83 ec 08             	sub    $0x8,%esp
  800b7e:	ff 75 0c             	pushl  0xc(%ebp)
  800b81:	53                   	push   %ebx
  800b82:	8b 45 08             	mov    0x8(%ebp),%eax
  800b85:	ff d0                	call   *%eax
  800b87:	83 c4 10             	add    $0x10,%esp
			break;
  800b8a:	eb 35                	jmp    800bc1 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800b8c:	c6 05 44 50 80 00 00 	movb   $0x0,0x805044
			break;
  800b93:	eb 2c                	jmp    800bc1 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800b95:	c6 05 44 50 80 00 01 	movb   $0x1,0x805044
			break;
  800b9c:	eb 23                	jmp    800bc1 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800b9e:	83 ec 08             	sub    $0x8,%esp
  800ba1:	ff 75 0c             	pushl  0xc(%ebp)
  800ba4:	6a 25                	push   $0x25
  800ba6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ba9:	ff d0                	call   *%eax
  800bab:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800bae:	ff 4d 10             	decl   0x10(%ebp)
  800bb1:	eb 03                	jmp    800bb6 <vprintfmt+0x3c3>
  800bb3:	ff 4d 10             	decl   0x10(%ebp)
  800bb6:	8b 45 10             	mov    0x10(%ebp),%eax
  800bb9:	48                   	dec    %eax
  800bba:	8a 00                	mov    (%eax),%al
  800bbc:	3c 25                	cmp    $0x25,%al
  800bbe:	75 f3                	jne    800bb3 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800bc0:	90                   	nop
		}
	}
  800bc1:	e9 35 fc ff ff       	jmp    8007fb <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800bc6:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800bc7:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800bca:	5b                   	pop    %ebx
  800bcb:	5e                   	pop    %esi
  800bcc:	5d                   	pop    %ebp
  800bcd:	c3                   	ret    

00800bce <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800bce:	55                   	push   %ebp
  800bcf:	89 e5                	mov    %esp,%ebp
  800bd1:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800bd4:	8d 45 10             	lea    0x10(%ebp),%eax
  800bd7:	83 c0 04             	add    $0x4,%eax
  800bda:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800bdd:	8b 45 10             	mov    0x10(%ebp),%eax
  800be0:	ff 75 f4             	pushl  -0xc(%ebp)
  800be3:	50                   	push   %eax
  800be4:	ff 75 0c             	pushl  0xc(%ebp)
  800be7:	ff 75 08             	pushl  0x8(%ebp)
  800bea:	e8 04 fc ff ff       	call   8007f3 <vprintfmt>
  800bef:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800bf2:	90                   	nop
  800bf3:	c9                   	leave  
  800bf4:	c3                   	ret    

00800bf5 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800bf5:	55                   	push   %ebp
  800bf6:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800bf8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bfb:	8b 40 08             	mov    0x8(%eax),%eax
  800bfe:	8d 50 01             	lea    0x1(%eax),%edx
  800c01:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c04:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800c07:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c0a:	8b 10                	mov    (%eax),%edx
  800c0c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c0f:	8b 40 04             	mov    0x4(%eax),%eax
  800c12:	39 c2                	cmp    %eax,%edx
  800c14:	73 12                	jae    800c28 <sprintputch+0x33>
		*b->buf++ = ch;
  800c16:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c19:	8b 00                	mov    (%eax),%eax
  800c1b:	8d 48 01             	lea    0x1(%eax),%ecx
  800c1e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c21:	89 0a                	mov    %ecx,(%edx)
  800c23:	8b 55 08             	mov    0x8(%ebp),%edx
  800c26:	88 10                	mov    %dl,(%eax)
}
  800c28:	90                   	nop
  800c29:	5d                   	pop    %ebp
  800c2a:	c3                   	ret    

00800c2b <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800c2b:	55                   	push   %ebp
  800c2c:	89 e5                	mov    %esp,%ebp
  800c2e:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800c31:	8b 45 08             	mov    0x8(%ebp),%eax
  800c34:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800c37:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c3a:	8d 50 ff             	lea    -0x1(%eax),%edx
  800c3d:	8b 45 08             	mov    0x8(%ebp),%eax
  800c40:	01 d0                	add    %edx,%eax
  800c42:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c45:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800c4c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800c50:	74 06                	je     800c58 <vsnprintf+0x2d>
  800c52:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c56:	7f 07                	jg     800c5f <vsnprintf+0x34>
		return -E_INVAL;
  800c58:	b8 03 00 00 00       	mov    $0x3,%eax
  800c5d:	eb 20                	jmp    800c7f <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800c5f:	ff 75 14             	pushl  0x14(%ebp)
  800c62:	ff 75 10             	pushl  0x10(%ebp)
  800c65:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800c68:	50                   	push   %eax
  800c69:	68 f5 0b 80 00       	push   $0x800bf5
  800c6e:	e8 80 fb ff ff       	call   8007f3 <vprintfmt>
  800c73:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800c76:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800c79:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800c7c:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800c7f:	c9                   	leave  
  800c80:	c3                   	ret    

00800c81 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800c81:	55                   	push   %ebp
  800c82:	89 e5                	mov    %esp,%ebp
  800c84:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800c87:	8d 45 10             	lea    0x10(%ebp),%eax
  800c8a:	83 c0 04             	add    $0x4,%eax
  800c8d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800c90:	8b 45 10             	mov    0x10(%ebp),%eax
  800c93:	ff 75 f4             	pushl  -0xc(%ebp)
  800c96:	50                   	push   %eax
  800c97:	ff 75 0c             	pushl  0xc(%ebp)
  800c9a:	ff 75 08             	pushl  0x8(%ebp)
  800c9d:	e8 89 ff ff ff       	call   800c2b <vsnprintf>
  800ca2:	83 c4 10             	add    $0x10,%esp
  800ca5:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800ca8:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800cab:	c9                   	leave  
  800cac:	c3                   	ret    

00800cad <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800cad:	55                   	push   %ebp
  800cae:	89 e5                	mov    %esp,%ebp
  800cb0:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800cb3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800cba:	eb 06                	jmp    800cc2 <strlen+0x15>
		n++;
  800cbc:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800cbf:	ff 45 08             	incl   0x8(%ebp)
  800cc2:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc5:	8a 00                	mov    (%eax),%al
  800cc7:	84 c0                	test   %al,%al
  800cc9:	75 f1                	jne    800cbc <strlen+0xf>
		n++;
	return n;
  800ccb:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800cce:	c9                   	leave  
  800ccf:	c3                   	ret    

00800cd0 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800cd0:	55                   	push   %ebp
  800cd1:	89 e5                	mov    %esp,%ebp
  800cd3:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800cd6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800cdd:	eb 09                	jmp    800ce8 <strnlen+0x18>
		n++;
  800cdf:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800ce2:	ff 45 08             	incl   0x8(%ebp)
  800ce5:	ff 4d 0c             	decl   0xc(%ebp)
  800ce8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800cec:	74 09                	je     800cf7 <strnlen+0x27>
  800cee:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf1:	8a 00                	mov    (%eax),%al
  800cf3:	84 c0                	test   %al,%al
  800cf5:	75 e8                	jne    800cdf <strnlen+0xf>
		n++;
	return n;
  800cf7:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800cfa:	c9                   	leave  
  800cfb:	c3                   	ret    

00800cfc <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800cfc:	55                   	push   %ebp
  800cfd:	89 e5                	mov    %esp,%ebp
  800cff:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800d02:	8b 45 08             	mov    0x8(%ebp),%eax
  800d05:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800d08:	90                   	nop
  800d09:	8b 45 08             	mov    0x8(%ebp),%eax
  800d0c:	8d 50 01             	lea    0x1(%eax),%edx
  800d0f:	89 55 08             	mov    %edx,0x8(%ebp)
  800d12:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d15:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d18:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800d1b:	8a 12                	mov    (%edx),%dl
  800d1d:	88 10                	mov    %dl,(%eax)
  800d1f:	8a 00                	mov    (%eax),%al
  800d21:	84 c0                	test   %al,%al
  800d23:	75 e4                	jne    800d09 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800d25:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800d28:	c9                   	leave  
  800d29:	c3                   	ret    

00800d2a <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800d2a:	55                   	push   %ebp
  800d2b:	89 e5                	mov    %esp,%ebp
  800d2d:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800d30:	8b 45 08             	mov    0x8(%ebp),%eax
  800d33:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800d36:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800d3d:	eb 1f                	jmp    800d5e <strncpy+0x34>
		*dst++ = *src;
  800d3f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d42:	8d 50 01             	lea    0x1(%eax),%edx
  800d45:	89 55 08             	mov    %edx,0x8(%ebp)
  800d48:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d4b:	8a 12                	mov    (%edx),%dl
  800d4d:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800d4f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d52:	8a 00                	mov    (%eax),%al
  800d54:	84 c0                	test   %al,%al
  800d56:	74 03                	je     800d5b <strncpy+0x31>
			src++;
  800d58:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800d5b:	ff 45 fc             	incl   -0x4(%ebp)
  800d5e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d61:	3b 45 10             	cmp    0x10(%ebp),%eax
  800d64:	72 d9                	jb     800d3f <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800d66:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800d69:	c9                   	leave  
  800d6a:	c3                   	ret    

00800d6b <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800d6b:	55                   	push   %ebp
  800d6c:	89 e5                	mov    %esp,%ebp
  800d6e:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800d71:	8b 45 08             	mov    0x8(%ebp),%eax
  800d74:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800d77:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d7b:	74 30                	je     800dad <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800d7d:	eb 16                	jmp    800d95 <strlcpy+0x2a>
			*dst++ = *src++;
  800d7f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d82:	8d 50 01             	lea    0x1(%eax),%edx
  800d85:	89 55 08             	mov    %edx,0x8(%ebp)
  800d88:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d8b:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d8e:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800d91:	8a 12                	mov    (%edx),%dl
  800d93:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800d95:	ff 4d 10             	decl   0x10(%ebp)
  800d98:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d9c:	74 09                	je     800da7 <strlcpy+0x3c>
  800d9e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800da1:	8a 00                	mov    (%eax),%al
  800da3:	84 c0                	test   %al,%al
  800da5:	75 d8                	jne    800d7f <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800da7:	8b 45 08             	mov    0x8(%ebp),%eax
  800daa:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800dad:	8b 55 08             	mov    0x8(%ebp),%edx
  800db0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800db3:	29 c2                	sub    %eax,%edx
  800db5:	89 d0                	mov    %edx,%eax
}
  800db7:	c9                   	leave  
  800db8:	c3                   	ret    

00800db9 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800db9:	55                   	push   %ebp
  800dba:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800dbc:	eb 06                	jmp    800dc4 <strcmp+0xb>
		p++, q++;
  800dbe:	ff 45 08             	incl   0x8(%ebp)
  800dc1:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800dc4:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc7:	8a 00                	mov    (%eax),%al
  800dc9:	84 c0                	test   %al,%al
  800dcb:	74 0e                	je     800ddb <strcmp+0x22>
  800dcd:	8b 45 08             	mov    0x8(%ebp),%eax
  800dd0:	8a 10                	mov    (%eax),%dl
  800dd2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dd5:	8a 00                	mov    (%eax),%al
  800dd7:	38 c2                	cmp    %al,%dl
  800dd9:	74 e3                	je     800dbe <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800ddb:	8b 45 08             	mov    0x8(%ebp),%eax
  800dde:	8a 00                	mov    (%eax),%al
  800de0:	0f b6 d0             	movzbl %al,%edx
  800de3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800de6:	8a 00                	mov    (%eax),%al
  800de8:	0f b6 c0             	movzbl %al,%eax
  800deb:	29 c2                	sub    %eax,%edx
  800ded:	89 d0                	mov    %edx,%eax
}
  800def:	5d                   	pop    %ebp
  800df0:	c3                   	ret    

00800df1 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800df1:	55                   	push   %ebp
  800df2:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800df4:	eb 09                	jmp    800dff <strncmp+0xe>
		n--, p++, q++;
  800df6:	ff 4d 10             	decl   0x10(%ebp)
  800df9:	ff 45 08             	incl   0x8(%ebp)
  800dfc:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800dff:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e03:	74 17                	je     800e1c <strncmp+0x2b>
  800e05:	8b 45 08             	mov    0x8(%ebp),%eax
  800e08:	8a 00                	mov    (%eax),%al
  800e0a:	84 c0                	test   %al,%al
  800e0c:	74 0e                	je     800e1c <strncmp+0x2b>
  800e0e:	8b 45 08             	mov    0x8(%ebp),%eax
  800e11:	8a 10                	mov    (%eax),%dl
  800e13:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e16:	8a 00                	mov    (%eax),%al
  800e18:	38 c2                	cmp    %al,%dl
  800e1a:	74 da                	je     800df6 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800e1c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e20:	75 07                	jne    800e29 <strncmp+0x38>
		return 0;
  800e22:	b8 00 00 00 00       	mov    $0x0,%eax
  800e27:	eb 14                	jmp    800e3d <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800e29:	8b 45 08             	mov    0x8(%ebp),%eax
  800e2c:	8a 00                	mov    (%eax),%al
  800e2e:	0f b6 d0             	movzbl %al,%edx
  800e31:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e34:	8a 00                	mov    (%eax),%al
  800e36:	0f b6 c0             	movzbl %al,%eax
  800e39:	29 c2                	sub    %eax,%edx
  800e3b:	89 d0                	mov    %edx,%eax
}
  800e3d:	5d                   	pop    %ebp
  800e3e:	c3                   	ret    

00800e3f <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800e3f:	55                   	push   %ebp
  800e40:	89 e5                	mov    %esp,%ebp
  800e42:	83 ec 04             	sub    $0x4,%esp
  800e45:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e48:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800e4b:	eb 12                	jmp    800e5f <strchr+0x20>
		if (*s == c)
  800e4d:	8b 45 08             	mov    0x8(%ebp),%eax
  800e50:	8a 00                	mov    (%eax),%al
  800e52:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800e55:	75 05                	jne    800e5c <strchr+0x1d>
			return (char *) s;
  800e57:	8b 45 08             	mov    0x8(%ebp),%eax
  800e5a:	eb 11                	jmp    800e6d <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800e5c:	ff 45 08             	incl   0x8(%ebp)
  800e5f:	8b 45 08             	mov    0x8(%ebp),%eax
  800e62:	8a 00                	mov    (%eax),%al
  800e64:	84 c0                	test   %al,%al
  800e66:	75 e5                	jne    800e4d <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800e68:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e6d:	c9                   	leave  
  800e6e:	c3                   	ret    

00800e6f <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800e6f:	55                   	push   %ebp
  800e70:	89 e5                	mov    %esp,%ebp
  800e72:	83 ec 04             	sub    $0x4,%esp
  800e75:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e78:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800e7b:	eb 0d                	jmp    800e8a <strfind+0x1b>
		if (*s == c)
  800e7d:	8b 45 08             	mov    0x8(%ebp),%eax
  800e80:	8a 00                	mov    (%eax),%al
  800e82:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800e85:	74 0e                	je     800e95 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800e87:	ff 45 08             	incl   0x8(%ebp)
  800e8a:	8b 45 08             	mov    0x8(%ebp),%eax
  800e8d:	8a 00                	mov    (%eax),%al
  800e8f:	84 c0                	test   %al,%al
  800e91:	75 ea                	jne    800e7d <strfind+0xe>
  800e93:	eb 01                	jmp    800e96 <strfind+0x27>
		if (*s == c)
			break;
  800e95:	90                   	nop
	return (char *) s;
  800e96:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e99:	c9                   	leave  
  800e9a:	c3                   	ret    

00800e9b <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  800e9b:	55                   	push   %ebp
  800e9c:	89 e5                	mov    %esp,%ebp
  800e9e:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  800ea1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ea4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  800ea7:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800eab:	76 63                	jbe    800f10 <memset+0x75>
		uint64 data_block = c;
  800ead:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eb0:	99                   	cltd   
  800eb1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800eb4:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  800eb7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800eba:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ebd:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  800ec1:	c1 e0 08             	shl    $0x8,%eax
  800ec4:	09 45 f0             	or     %eax,-0x10(%ebp)
  800ec7:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  800eca:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ecd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ed0:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  800ed4:	c1 e0 10             	shl    $0x10,%eax
  800ed7:	09 45 f0             	or     %eax,-0x10(%ebp)
  800eda:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  800edd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ee0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ee3:	89 c2                	mov    %eax,%edx
  800ee5:	b8 00 00 00 00       	mov    $0x0,%eax
  800eea:	09 45 f0             	or     %eax,-0x10(%ebp)
  800eed:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  800ef0:	eb 18                	jmp    800f0a <memset+0x6f>
			*p64++ = data_block, n -= 8;
  800ef2:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  800ef5:	8d 41 08             	lea    0x8(%ecx),%eax
  800ef8:	89 45 fc             	mov    %eax,-0x4(%ebp)
  800efb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800efe:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f01:	89 01                	mov    %eax,(%ecx)
  800f03:	89 51 04             	mov    %edx,0x4(%ecx)
  800f06:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  800f0a:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800f0e:	77 e2                	ja     800ef2 <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  800f10:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f14:	74 23                	je     800f39 <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  800f16:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f19:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  800f1c:	eb 0e                	jmp    800f2c <memset+0x91>
			*p8++ = (uint8)c;
  800f1e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f21:	8d 50 01             	lea    0x1(%eax),%edx
  800f24:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800f27:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f2a:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  800f2c:	8b 45 10             	mov    0x10(%ebp),%eax
  800f2f:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f32:	89 55 10             	mov    %edx,0x10(%ebp)
  800f35:	85 c0                	test   %eax,%eax
  800f37:	75 e5                	jne    800f1e <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  800f39:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f3c:	c9                   	leave  
  800f3d:	c3                   	ret    

00800f3e <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800f3e:	55                   	push   %ebp
  800f3f:	89 e5                	mov    %esp,%ebp
  800f41:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  800f44:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f47:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  800f4a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f4d:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  800f50:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800f54:	76 24                	jbe    800f7a <memcpy+0x3c>
		while(n >= 8){
  800f56:	eb 1c                	jmp    800f74 <memcpy+0x36>
			*d64 = *s64;
  800f58:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f5b:	8b 50 04             	mov    0x4(%eax),%edx
  800f5e:	8b 00                	mov    (%eax),%eax
  800f60:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  800f63:	89 01                	mov    %eax,(%ecx)
  800f65:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  800f68:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  800f6c:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  800f70:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  800f74:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800f78:	77 de                	ja     800f58 <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  800f7a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f7e:	74 31                	je     800fb1 <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  800f80:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f83:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  800f86:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f89:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  800f8c:	eb 16                	jmp    800fa4 <memcpy+0x66>
			*d8++ = *s8++;
  800f8e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800f91:	8d 50 01             	lea    0x1(%eax),%edx
  800f94:	89 55 f0             	mov    %edx,-0x10(%ebp)
  800f97:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f9a:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f9d:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  800fa0:	8a 12                	mov    (%edx),%dl
  800fa2:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  800fa4:	8b 45 10             	mov    0x10(%ebp),%eax
  800fa7:	8d 50 ff             	lea    -0x1(%eax),%edx
  800faa:	89 55 10             	mov    %edx,0x10(%ebp)
  800fad:	85 c0                	test   %eax,%eax
  800faf:	75 dd                	jne    800f8e <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  800fb1:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800fb4:	c9                   	leave  
  800fb5:	c3                   	ret    

00800fb6 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800fb6:	55                   	push   %ebp
  800fb7:	89 e5                	mov    %esp,%ebp
  800fb9:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800fbc:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fbf:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800fc2:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc5:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800fc8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fcb:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800fce:	73 50                	jae    801020 <memmove+0x6a>
  800fd0:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800fd3:	8b 45 10             	mov    0x10(%ebp),%eax
  800fd6:	01 d0                	add    %edx,%eax
  800fd8:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800fdb:	76 43                	jbe    801020 <memmove+0x6a>
		s += n;
  800fdd:	8b 45 10             	mov    0x10(%ebp),%eax
  800fe0:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800fe3:	8b 45 10             	mov    0x10(%ebp),%eax
  800fe6:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800fe9:	eb 10                	jmp    800ffb <memmove+0x45>
			*--d = *--s;
  800feb:	ff 4d f8             	decl   -0x8(%ebp)
  800fee:	ff 4d fc             	decl   -0x4(%ebp)
  800ff1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ff4:	8a 10                	mov    (%eax),%dl
  800ff6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ff9:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800ffb:	8b 45 10             	mov    0x10(%ebp),%eax
  800ffe:	8d 50 ff             	lea    -0x1(%eax),%edx
  801001:	89 55 10             	mov    %edx,0x10(%ebp)
  801004:	85 c0                	test   %eax,%eax
  801006:	75 e3                	jne    800feb <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801008:	eb 23                	jmp    80102d <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  80100a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80100d:	8d 50 01             	lea    0x1(%eax),%edx
  801010:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801013:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801016:	8d 4a 01             	lea    0x1(%edx),%ecx
  801019:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  80101c:	8a 12                	mov    (%edx),%dl
  80101e:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801020:	8b 45 10             	mov    0x10(%ebp),%eax
  801023:	8d 50 ff             	lea    -0x1(%eax),%edx
  801026:	89 55 10             	mov    %edx,0x10(%ebp)
  801029:	85 c0                	test   %eax,%eax
  80102b:	75 dd                	jne    80100a <memmove+0x54>
			*d++ = *s++;

	return dst;
  80102d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801030:	c9                   	leave  
  801031:	c3                   	ret    

00801032 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  801032:	55                   	push   %ebp
  801033:	89 e5                	mov    %esp,%ebp
  801035:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  801038:	8b 45 08             	mov    0x8(%ebp),%eax
  80103b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  80103e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801041:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  801044:	eb 2a                	jmp    801070 <memcmp+0x3e>
		if (*s1 != *s2)
  801046:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801049:	8a 10                	mov    (%eax),%dl
  80104b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80104e:	8a 00                	mov    (%eax),%al
  801050:	38 c2                	cmp    %al,%dl
  801052:	74 16                	je     80106a <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801054:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801057:	8a 00                	mov    (%eax),%al
  801059:	0f b6 d0             	movzbl %al,%edx
  80105c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80105f:	8a 00                	mov    (%eax),%al
  801061:	0f b6 c0             	movzbl %al,%eax
  801064:	29 c2                	sub    %eax,%edx
  801066:	89 d0                	mov    %edx,%eax
  801068:	eb 18                	jmp    801082 <memcmp+0x50>
		s1++, s2++;
  80106a:	ff 45 fc             	incl   -0x4(%ebp)
  80106d:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801070:	8b 45 10             	mov    0x10(%ebp),%eax
  801073:	8d 50 ff             	lea    -0x1(%eax),%edx
  801076:	89 55 10             	mov    %edx,0x10(%ebp)
  801079:	85 c0                	test   %eax,%eax
  80107b:	75 c9                	jne    801046 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  80107d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801082:	c9                   	leave  
  801083:	c3                   	ret    

00801084 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801084:	55                   	push   %ebp
  801085:	89 e5                	mov    %esp,%ebp
  801087:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  80108a:	8b 55 08             	mov    0x8(%ebp),%edx
  80108d:	8b 45 10             	mov    0x10(%ebp),%eax
  801090:	01 d0                	add    %edx,%eax
  801092:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801095:	eb 15                	jmp    8010ac <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801097:	8b 45 08             	mov    0x8(%ebp),%eax
  80109a:	8a 00                	mov    (%eax),%al
  80109c:	0f b6 d0             	movzbl %al,%edx
  80109f:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010a2:	0f b6 c0             	movzbl %al,%eax
  8010a5:	39 c2                	cmp    %eax,%edx
  8010a7:	74 0d                	je     8010b6 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8010a9:	ff 45 08             	incl   0x8(%ebp)
  8010ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8010af:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8010b2:	72 e3                	jb     801097 <memfind+0x13>
  8010b4:	eb 01                	jmp    8010b7 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  8010b6:	90                   	nop
	return (void *) s;
  8010b7:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8010ba:	c9                   	leave  
  8010bb:	c3                   	ret    

008010bc <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8010bc:	55                   	push   %ebp
  8010bd:	89 e5                	mov    %esp,%ebp
  8010bf:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  8010c2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  8010c9:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8010d0:	eb 03                	jmp    8010d5 <strtol+0x19>
		s++;
  8010d2:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8010d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8010d8:	8a 00                	mov    (%eax),%al
  8010da:	3c 20                	cmp    $0x20,%al
  8010dc:	74 f4                	je     8010d2 <strtol+0x16>
  8010de:	8b 45 08             	mov    0x8(%ebp),%eax
  8010e1:	8a 00                	mov    (%eax),%al
  8010e3:	3c 09                	cmp    $0x9,%al
  8010e5:	74 eb                	je     8010d2 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  8010e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ea:	8a 00                	mov    (%eax),%al
  8010ec:	3c 2b                	cmp    $0x2b,%al
  8010ee:	75 05                	jne    8010f5 <strtol+0x39>
		s++;
  8010f0:	ff 45 08             	incl   0x8(%ebp)
  8010f3:	eb 13                	jmp    801108 <strtol+0x4c>
	else if (*s == '-')
  8010f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8010f8:	8a 00                	mov    (%eax),%al
  8010fa:	3c 2d                	cmp    $0x2d,%al
  8010fc:	75 0a                	jne    801108 <strtol+0x4c>
		s++, neg = 1;
  8010fe:	ff 45 08             	incl   0x8(%ebp)
  801101:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801108:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80110c:	74 06                	je     801114 <strtol+0x58>
  80110e:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801112:	75 20                	jne    801134 <strtol+0x78>
  801114:	8b 45 08             	mov    0x8(%ebp),%eax
  801117:	8a 00                	mov    (%eax),%al
  801119:	3c 30                	cmp    $0x30,%al
  80111b:	75 17                	jne    801134 <strtol+0x78>
  80111d:	8b 45 08             	mov    0x8(%ebp),%eax
  801120:	40                   	inc    %eax
  801121:	8a 00                	mov    (%eax),%al
  801123:	3c 78                	cmp    $0x78,%al
  801125:	75 0d                	jne    801134 <strtol+0x78>
		s += 2, base = 16;
  801127:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  80112b:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801132:	eb 28                	jmp    80115c <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801134:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801138:	75 15                	jne    80114f <strtol+0x93>
  80113a:	8b 45 08             	mov    0x8(%ebp),%eax
  80113d:	8a 00                	mov    (%eax),%al
  80113f:	3c 30                	cmp    $0x30,%al
  801141:	75 0c                	jne    80114f <strtol+0x93>
		s++, base = 8;
  801143:	ff 45 08             	incl   0x8(%ebp)
  801146:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  80114d:	eb 0d                	jmp    80115c <strtol+0xa0>
	else if (base == 0)
  80114f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801153:	75 07                	jne    80115c <strtol+0xa0>
		base = 10;
  801155:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  80115c:	8b 45 08             	mov    0x8(%ebp),%eax
  80115f:	8a 00                	mov    (%eax),%al
  801161:	3c 2f                	cmp    $0x2f,%al
  801163:	7e 19                	jle    80117e <strtol+0xc2>
  801165:	8b 45 08             	mov    0x8(%ebp),%eax
  801168:	8a 00                	mov    (%eax),%al
  80116a:	3c 39                	cmp    $0x39,%al
  80116c:	7f 10                	jg     80117e <strtol+0xc2>
			dig = *s - '0';
  80116e:	8b 45 08             	mov    0x8(%ebp),%eax
  801171:	8a 00                	mov    (%eax),%al
  801173:	0f be c0             	movsbl %al,%eax
  801176:	83 e8 30             	sub    $0x30,%eax
  801179:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80117c:	eb 42                	jmp    8011c0 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  80117e:	8b 45 08             	mov    0x8(%ebp),%eax
  801181:	8a 00                	mov    (%eax),%al
  801183:	3c 60                	cmp    $0x60,%al
  801185:	7e 19                	jle    8011a0 <strtol+0xe4>
  801187:	8b 45 08             	mov    0x8(%ebp),%eax
  80118a:	8a 00                	mov    (%eax),%al
  80118c:	3c 7a                	cmp    $0x7a,%al
  80118e:	7f 10                	jg     8011a0 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801190:	8b 45 08             	mov    0x8(%ebp),%eax
  801193:	8a 00                	mov    (%eax),%al
  801195:	0f be c0             	movsbl %al,%eax
  801198:	83 e8 57             	sub    $0x57,%eax
  80119b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80119e:	eb 20                	jmp    8011c0 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  8011a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8011a3:	8a 00                	mov    (%eax),%al
  8011a5:	3c 40                	cmp    $0x40,%al
  8011a7:	7e 39                	jle    8011e2 <strtol+0x126>
  8011a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ac:	8a 00                	mov    (%eax),%al
  8011ae:	3c 5a                	cmp    $0x5a,%al
  8011b0:	7f 30                	jg     8011e2 <strtol+0x126>
			dig = *s - 'A' + 10;
  8011b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8011b5:	8a 00                	mov    (%eax),%al
  8011b7:	0f be c0             	movsbl %al,%eax
  8011ba:	83 e8 37             	sub    $0x37,%eax
  8011bd:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  8011c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8011c3:	3b 45 10             	cmp    0x10(%ebp),%eax
  8011c6:	7d 19                	jge    8011e1 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  8011c8:	ff 45 08             	incl   0x8(%ebp)
  8011cb:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011ce:	0f af 45 10          	imul   0x10(%ebp),%eax
  8011d2:	89 c2                	mov    %eax,%edx
  8011d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8011d7:	01 d0                	add    %edx,%eax
  8011d9:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8011dc:	e9 7b ff ff ff       	jmp    80115c <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8011e1:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8011e2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8011e6:	74 08                	je     8011f0 <strtol+0x134>
		*endptr = (char *) s;
  8011e8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011eb:	8b 55 08             	mov    0x8(%ebp),%edx
  8011ee:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8011f0:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8011f4:	74 07                	je     8011fd <strtol+0x141>
  8011f6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011f9:	f7 d8                	neg    %eax
  8011fb:	eb 03                	jmp    801200 <strtol+0x144>
  8011fd:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801200:	c9                   	leave  
  801201:	c3                   	ret    

00801202 <ltostr>:

void
ltostr(long value, char *str)
{
  801202:	55                   	push   %ebp
  801203:	89 e5                	mov    %esp,%ebp
  801205:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801208:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  80120f:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801216:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80121a:	79 13                	jns    80122f <ltostr+0x2d>
	{
		neg = 1;
  80121c:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801223:	8b 45 0c             	mov    0xc(%ebp),%eax
  801226:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801229:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  80122c:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  80122f:	8b 45 08             	mov    0x8(%ebp),%eax
  801232:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801237:	99                   	cltd   
  801238:	f7 f9                	idiv   %ecx
  80123a:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  80123d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801240:	8d 50 01             	lea    0x1(%eax),%edx
  801243:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801246:	89 c2                	mov    %eax,%edx
  801248:	8b 45 0c             	mov    0xc(%ebp),%eax
  80124b:	01 d0                	add    %edx,%eax
  80124d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801250:	83 c2 30             	add    $0x30,%edx
  801253:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801255:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801258:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80125d:	f7 e9                	imul   %ecx
  80125f:	c1 fa 02             	sar    $0x2,%edx
  801262:	89 c8                	mov    %ecx,%eax
  801264:	c1 f8 1f             	sar    $0x1f,%eax
  801267:	29 c2                	sub    %eax,%edx
  801269:	89 d0                	mov    %edx,%eax
  80126b:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  80126e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801272:	75 bb                	jne    80122f <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801274:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  80127b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80127e:	48                   	dec    %eax
  80127f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801282:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801286:	74 3d                	je     8012c5 <ltostr+0xc3>
		start = 1 ;
  801288:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  80128f:	eb 34                	jmp    8012c5 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  801291:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801294:	8b 45 0c             	mov    0xc(%ebp),%eax
  801297:	01 d0                	add    %edx,%eax
  801299:	8a 00                	mov    (%eax),%al
  80129b:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  80129e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8012a1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012a4:	01 c2                	add    %eax,%edx
  8012a6:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8012a9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012ac:	01 c8                	add    %ecx,%eax
  8012ae:	8a 00                	mov    (%eax),%al
  8012b0:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8012b2:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8012b5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012b8:	01 c2                	add    %eax,%edx
  8012ba:	8a 45 eb             	mov    -0x15(%ebp),%al
  8012bd:	88 02                	mov    %al,(%edx)
		start++ ;
  8012bf:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8012c2:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8012c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8012c8:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8012cb:	7c c4                	jl     801291 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8012cd:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8012d0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012d3:	01 d0                	add    %edx,%eax
  8012d5:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8012d8:	90                   	nop
  8012d9:	c9                   	leave  
  8012da:	c3                   	ret    

008012db <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8012db:	55                   	push   %ebp
  8012dc:	89 e5                	mov    %esp,%ebp
  8012de:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8012e1:	ff 75 08             	pushl  0x8(%ebp)
  8012e4:	e8 c4 f9 ff ff       	call   800cad <strlen>
  8012e9:	83 c4 04             	add    $0x4,%esp
  8012ec:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8012ef:	ff 75 0c             	pushl  0xc(%ebp)
  8012f2:	e8 b6 f9 ff ff       	call   800cad <strlen>
  8012f7:	83 c4 04             	add    $0x4,%esp
  8012fa:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8012fd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801304:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80130b:	eb 17                	jmp    801324 <strcconcat+0x49>
		final[s] = str1[s] ;
  80130d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801310:	8b 45 10             	mov    0x10(%ebp),%eax
  801313:	01 c2                	add    %eax,%edx
  801315:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801318:	8b 45 08             	mov    0x8(%ebp),%eax
  80131b:	01 c8                	add    %ecx,%eax
  80131d:	8a 00                	mov    (%eax),%al
  80131f:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801321:	ff 45 fc             	incl   -0x4(%ebp)
  801324:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801327:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80132a:	7c e1                	jl     80130d <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  80132c:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801333:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  80133a:	eb 1f                	jmp    80135b <strcconcat+0x80>
		final[s++] = str2[i] ;
  80133c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80133f:	8d 50 01             	lea    0x1(%eax),%edx
  801342:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801345:	89 c2                	mov    %eax,%edx
  801347:	8b 45 10             	mov    0x10(%ebp),%eax
  80134a:	01 c2                	add    %eax,%edx
  80134c:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  80134f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801352:	01 c8                	add    %ecx,%eax
  801354:	8a 00                	mov    (%eax),%al
  801356:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801358:	ff 45 f8             	incl   -0x8(%ebp)
  80135b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80135e:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801361:	7c d9                	jl     80133c <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801363:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801366:	8b 45 10             	mov    0x10(%ebp),%eax
  801369:	01 d0                	add    %edx,%eax
  80136b:	c6 00 00             	movb   $0x0,(%eax)
}
  80136e:	90                   	nop
  80136f:	c9                   	leave  
  801370:	c3                   	ret    

00801371 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801371:	55                   	push   %ebp
  801372:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801374:	8b 45 14             	mov    0x14(%ebp),%eax
  801377:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  80137d:	8b 45 14             	mov    0x14(%ebp),%eax
  801380:	8b 00                	mov    (%eax),%eax
  801382:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801389:	8b 45 10             	mov    0x10(%ebp),%eax
  80138c:	01 d0                	add    %edx,%eax
  80138e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801394:	eb 0c                	jmp    8013a2 <strsplit+0x31>
			*string++ = 0;
  801396:	8b 45 08             	mov    0x8(%ebp),%eax
  801399:	8d 50 01             	lea    0x1(%eax),%edx
  80139c:	89 55 08             	mov    %edx,0x8(%ebp)
  80139f:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8013a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8013a5:	8a 00                	mov    (%eax),%al
  8013a7:	84 c0                	test   %al,%al
  8013a9:	74 18                	je     8013c3 <strsplit+0x52>
  8013ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8013ae:	8a 00                	mov    (%eax),%al
  8013b0:	0f be c0             	movsbl %al,%eax
  8013b3:	50                   	push   %eax
  8013b4:	ff 75 0c             	pushl  0xc(%ebp)
  8013b7:	e8 83 fa ff ff       	call   800e3f <strchr>
  8013bc:	83 c4 08             	add    $0x8,%esp
  8013bf:	85 c0                	test   %eax,%eax
  8013c1:	75 d3                	jne    801396 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8013c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8013c6:	8a 00                	mov    (%eax),%al
  8013c8:	84 c0                	test   %al,%al
  8013ca:	74 5a                	je     801426 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8013cc:	8b 45 14             	mov    0x14(%ebp),%eax
  8013cf:	8b 00                	mov    (%eax),%eax
  8013d1:	83 f8 0f             	cmp    $0xf,%eax
  8013d4:	75 07                	jne    8013dd <strsplit+0x6c>
		{
			return 0;
  8013d6:	b8 00 00 00 00       	mov    $0x0,%eax
  8013db:	eb 66                	jmp    801443 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8013dd:	8b 45 14             	mov    0x14(%ebp),%eax
  8013e0:	8b 00                	mov    (%eax),%eax
  8013e2:	8d 48 01             	lea    0x1(%eax),%ecx
  8013e5:	8b 55 14             	mov    0x14(%ebp),%edx
  8013e8:	89 0a                	mov    %ecx,(%edx)
  8013ea:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8013f1:	8b 45 10             	mov    0x10(%ebp),%eax
  8013f4:	01 c2                	add    %eax,%edx
  8013f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8013f9:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8013fb:	eb 03                	jmp    801400 <strsplit+0x8f>
			string++;
  8013fd:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801400:	8b 45 08             	mov    0x8(%ebp),%eax
  801403:	8a 00                	mov    (%eax),%al
  801405:	84 c0                	test   %al,%al
  801407:	74 8b                	je     801394 <strsplit+0x23>
  801409:	8b 45 08             	mov    0x8(%ebp),%eax
  80140c:	8a 00                	mov    (%eax),%al
  80140e:	0f be c0             	movsbl %al,%eax
  801411:	50                   	push   %eax
  801412:	ff 75 0c             	pushl  0xc(%ebp)
  801415:	e8 25 fa ff ff       	call   800e3f <strchr>
  80141a:	83 c4 08             	add    $0x8,%esp
  80141d:	85 c0                	test   %eax,%eax
  80141f:	74 dc                	je     8013fd <strsplit+0x8c>
			string++;
	}
  801421:	e9 6e ff ff ff       	jmp    801394 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801426:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801427:	8b 45 14             	mov    0x14(%ebp),%eax
  80142a:	8b 00                	mov    (%eax),%eax
  80142c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801433:	8b 45 10             	mov    0x10(%ebp),%eax
  801436:	01 d0                	add    %edx,%eax
  801438:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  80143e:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801443:	c9                   	leave  
  801444:	c3                   	ret    

00801445 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  801445:	55                   	push   %ebp
  801446:	89 e5                	mov    %esp,%ebp
  801448:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  80144b:	8b 45 08             	mov    0x8(%ebp),%eax
  80144e:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  801451:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801458:	eb 4a                	jmp    8014a4 <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  80145a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80145d:	8b 45 08             	mov    0x8(%ebp),%eax
  801460:	01 c2                	add    %eax,%edx
  801462:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801465:	8b 45 0c             	mov    0xc(%ebp),%eax
  801468:	01 c8                	add    %ecx,%eax
  80146a:	8a 00                	mov    (%eax),%al
  80146c:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  80146e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801471:	8b 45 0c             	mov    0xc(%ebp),%eax
  801474:	01 d0                	add    %edx,%eax
  801476:	8a 00                	mov    (%eax),%al
  801478:	3c 40                	cmp    $0x40,%al
  80147a:	7e 25                	jle    8014a1 <str2lower+0x5c>
  80147c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80147f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801482:	01 d0                	add    %edx,%eax
  801484:	8a 00                	mov    (%eax),%al
  801486:	3c 5a                	cmp    $0x5a,%al
  801488:	7f 17                	jg     8014a1 <str2lower+0x5c>
		{
			dst[i] += 32 ;
  80148a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80148d:	8b 45 08             	mov    0x8(%ebp),%eax
  801490:	01 d0                	add    %edx,%eax
  801492:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801495:	8b 55 08             	mov    0x8(%ebp),%edx
  801498:	01 ca                	add    %ecx,%edx
  80149a:	8a 12                	mov    (%edx),%dl
  80149c:	83 c2 20             	add    $0x20,%edx
  80149f:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  8014a1:	ff 45 fc             	incl   -0x4(%ebp)
  8014a4:	ff 75 0c             	pushl  0xc(%ebp)
  8014a7:	e8 01 f8 ff ff       	call   800cad <strlen>
  8014ac:	83 c4 04             	add    $0x4,%esp
  8014af:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8014b2:	7f a6                	jg     80145a <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  8014b4:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8014b7:	c9                   	leave  
  8014b8:	c3                   	ret    

008014b9 <uheap_init>:
//==============================================
// [1] INITIALIZE USER HEAP:
//==============================================
int __firstTimeFlag = 1;
void uheap_init()
{
  8014b9:	55                   	push   %ebp
  8014ba:	89 e5                	mov    %esp,%ebp
  8014bc:	83 ec 08             	sub    $0x8,%esp
	if(__firstTimeFlag)
  8014bf:	a1 08 50 80 00       	mov    0x805008,%eax
  8014c4:	85 c0                	test   %eax,%eax
  8014c6:	0f 84 95 00 00 00    	je     801561 <uheap_init+0xa8>
	{
		initialize_dynamic_allocator(USER_HEAP_START, USER_HEAP_START + DYN_ALLOC_MAX_SIZE);
  8014cc:	83 ec 08             	sub    $0x8,%esp
  8014cf:	68 00 00 00 82       	push   $0x82000000
  8014d4:	68 00 00 00 80       	push   $0x80000000
  8014d9:	e8 59 1f 00 00       	call   803437 <initialize_dynamic_allocator>
  8014de:	83 c4 10             	add    $0x10,%esp
		uheapPlaceStrategy = sys_get_uheap_strategy();
  8014e1:	e8 93 1d 00 00       	call   803279 <sys_get_uheap_strategy>
  8014e6:	a3 60 d0 81 00       	mov    %eax,0x81d060
		uheapPageAllocStart = dynAllocEnd + PAGE_SIZE;
  8014eb:	a1 40 50 80 00       	mov    0x805040,%eax
  8014f0:	05 00 10 00 00       	add    $0x1000,%eax
  8014f5:	a3 10 d1 81 00       	mov    %eax,0x81d110
		uheapPageAllocBreak = uheapPageAllocStart;
  8014fa:	a1 10 d1 81 00       	mov    0x81d110,%eax
  8014ff:	a3 68 d0 81 00       	mov    %eax,0x81d068
		init_uspinlock(&ulock,"malloc",1);
  801504:	83 ec 04             	sub    $0x4,%esp
  801507:	6a 01                	push   $0x1
  801509:	68 a8 49 80 00       	push   $0x8049a8
  80150e:	68 40 d1 81 00       	push   $0x81d140
  801513:	e8 1a 29 00 00       	call   803e32 <init_uspinlock>
  801518:	83 c4 10             	add    $0x10,%esp
		LIST_INIT(&u_freelist);
  80151b:	c7 05 20 d1 81 00 00 	movl   $0x0,0x81d120
  801522:	00 00 00 
  801525:	c7 05 24 d1 81 00 00 	movl   $0x0,0x81d124
  80152c:	00 00 00 
  80152f:	c7 05 2c d1 81 00 00 	movl   $0x0,0x81d12c
  801536:	00 00 00 
		LIST_INIT(&u_allocatedlist);
  801539:	c7 05 30 d1 81 00 00 	movl   $0x0,0x81d130
  801540:	00 00 00 
  801543:	c7 05 34 d1 81 00 00 	movl   $0x0,0x81d134
  80154a:	00 00 00 
  80154d:	c7 05 3c d1 81 00 00 	movl   $0x0,0x81d13c
  801554:	00 00 00 
		__firstTimeFlag = 0;
  801557:	c7 05 08 50 80 00 00 	movl   $0x0,0x805008
  80155e:	00 00 00 
	}
}
  801561:	90                   	nop
  801562:	c9                   	leave  
  801563:	c3                   	ret    

00801564 <get_page>:

//==============================================
// [2] GET A PAGE FROM THE KERNEL FOR DA:
//==============================================
int get_page(void* va)
{
  801564:	55                   	push   %ebp
  801565:	89 e5                	mov    %esp,%ebp
  801567:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_allocate_page(ROUNDDOWN(va, PAGE_SIZE), PERM_USER|PERM_WRITEABLE|PERM_UHPAGE);
  80156a:	8b 45 08             	mov    0x8(%ebp),%eax
  80156d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801570:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801573:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801578:	83 ec 08             	sub    $0x8,%esp
  80157b:	68 06 04 00 00       	push   $0x406
  801580:	50                   	push   %eax
  801581:	e8 3d 19 00 00       	call   802ec3 <__sys_allocate_page>
  801586:	83 c4 10             	add    $0x10,%esp
  801589:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  80158c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801590:	79 14                	jns    8015a6 <get_page+0x42>
		panic("get_page() in user: failed to allocate page from the kernel");
  801592:	83 ec 04             	sub    $0x4,%esp
  801595:	68 b0 49 80 00       	push   $0x8049b0
  80159a:	6a 2d                	push   $0x2d
  80159c:	68 ec 49 80 00       	push   $0x8049ec
  8015a1:	e8 60 ed ff ff       	call   800306 <_panic>
	return 0;
  8015a6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8015ab:	c9                   	leave  
  8015ac:	c3                   	ret    

008015ad <return_page>:

//==============================================
// [3] RETURN A PAGE FROM THE DA TO KERNEL:
//==============================================
void return_page(void* va)
{
  8015ad:	55                   	push   %ebp
  8015ae:	89 e5                	mov    %esp,%ebp
  8015b0:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_unmap_frame(ROUNDDOWN((uint32)va, PAGE_SIZE));
  8015b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8015b6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8015b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015bc:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8015c1:	83 ec 0c             	sub    $0xc,%esp
  8015c4:	50                   	push   %eax
  8015c5:	e8 40 19 00 00       	call   802f0a <__sys_unmap_frame>
  8015ca:	83 c4 10             	add    $0x10,%esp
  8015cd:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  8015d0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8015d4:	79 14                	jns    8015ea <return_page+0x3d>
		panic("return_page() in user: failed to return a page to the kernel");
  8015d6:	83 ec 04             	sub    $0x4,%esp
  8015d9:	68 f8 49 80 00       	push   $0x8049f8
  8015de:	6a 38                	push   $0x38
  8015e0:	68 ec 49 80 00       	push   $0x8049ec
  8015e5:	e8 1c ed ff ff       	call   800306 <_panic>
}
  8015ea:	90                   	nop
  8015eb:	c9                   	leave  
  8015ec:	c3                   	ret    

008015ed <malloc>:

//=================================
// [1] ALLOCATE SPACE IN USER HEAP:
//=================================
void* malloc(uint32 size)
{
  8015ed:	55                   	push   %ebp
  8015ee:	89 e5                	mov    %esp,%ebp
  8015f0:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  8015f3:	e8 c1 fe ff ff       	call   8014b9 <uheap_init>
	if (size == 0) return NULL ;
  8015f8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8015fc:	75 0a                	jne    801608 <malloc+0x1b>
  8015fe:	b8 00 00 00 00       	mov    $0x0,%eax
  801603:	e9 e1 04 00 00       	jmp    801ae9 <malloc+0x4fc>
	//==============================================================

	acquire_uspinlock(&ulock);
  801608:	83 ec 0c             	sub    $0xc,%esp
  80160b:	68 40 d1 81 00       	push   $0x81d140
  801610:	e8 6c 28 00 00       	call   803e81 <acquire_uspinlock>
  801615:	83 c4 10             	add    $0x10,%esp
	if(size <  DYN_ALLOC_MAX_BLOCK_SIZE){
  801618:	81 7d 08 ff 07 00 00 	cmpl   $0x7ff,0x8(%ebp)
  80161f:	77 23                	ja     801644 <malloc+0x57>
		release_uspinlock(&ulock);
  801621:	83 ec 0c             	sub    $0xc,%esp
  801624:	68 40 d1 81 00       	push   $0x81d140
  801629:	e8 ab 28 00 00       	call   803ed9 <release_uspinlock>
  80162e:	83 c4 10             	add    $0x10,%esp
		return alloc_block(size);
  801631:	83 ec 0c             	sub    $0xc,%esp
  801634:	ff 75 08             	pushl  0x8(%ebp)
  801637:	e8 dd 1f 00 00       	call   803619 <alloc_block>
  80163c:	83 c4 10             	add    $0x10,%esp
  80163f:	e9 a5 04 00 00       	jmp    801ae9 <malloc+0x4fc>
	}

	struct UserHeapStruct* allocblock= (struct UserHeapStruct*) alloc_block(sizeof(struct UserHeapStruct));
  801644:	83 ec 0c             	sub    $0xc,%esp
  801647:	6a 10                	push   $0x10
  801649:	e8 cb 1f 00 00       	call   803619 <alloc_block>
  80164e:	83 c4 10             	add    $0x10,%esp
  801651:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (allocblock == NULL){
  801654:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801658:	75 0a                	jne    801664 <malloc+0x77>
			return NULL;
  80165a:	b8 00 00 00 00       	mov    $0x0,%eax
  80165f:	e9 85 04 00 00       	jmp    801ae9 <malloc+0x4fc>
	}

	size = ROUNDUP(size,PAGE_SIZE);
  801664:	c7 45 e8 00 10 00 00 	movl   $0x1000,-0x18(%ebp)
  80166b:	8b 55 08             	mov    0x8(%ebp),%edx
  80166e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801671:	01 d0                	add    %edx,%eax
  801673:	48                   	dec    %eax
  801674:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801677:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80167a:	ba 00 00 00 00       	mov    $0x0,%edx
  80167f:	f7 75 e8             	divl   -0x18(%ebp)
  801682:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801685:	29 d0                	sub    %edx,%eax
  801687:	89 45 08             	mov    %eax,0x8(%ebp)
	struct UserHeapStruct* lastfreeelement = LIST_LAST(&u_freelist);
  80168a:	a1 24 d1 81 00       	mov    0x81d124,%eax
  80168f:	89 45 e0             	mov    %eax,-0x20(%ebp)

	if(LIST_SIZE(&u_freelist)==0 || size>lastfreeelement->size){
  801692:	a1 2c d1 81 00       	mov    0x81d12c,%eax
  801697:	85 c0                	test   %eax,%eax
  801699:	74 0f                	je     8016aa <malloc+0xbd>
  80169b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80169e:	8b 40 04             	mov    0x4(%eax),%eax
  8016a1:	3b 45 08             	cmp    0x8(%ebp),%eax
  8016a4:	0f 83 ea 00 00 00    	jae    801794 <malloc+0x1a7>
			if(uheapPageAllocBreak < USER_HEAP_MAX - size){
  8016aa:	b8 00 00 00 a0       	mov    $0xa0000000,%eax
  8016af:	2b 45 08             	sub    0x8(%ebp),%eax
  8016b2:	89 c2                	mov    %eax,%edx
  8016b4:	a1 68 d0 81 00       	mov    0x81d068,%eax
  8016b9:	39 c2                	cmp    %eax,%edx
  8016bb:	0f 86 b9 00 00 00    	jbe    80177a <malloc+0x18d>
					uint32 requestedblockva = uheapPageAllocBreak;
  8016c1:	a1 68 d0 81 00       	mov    0x81d068,%eax
  8016c6:	89 45 dc             	mov    %eax,-0x24(%ebp)
					uheapPageAllocBreak+=size;
  8016c9:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  8016cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8016d2:	01 d0                	add    %edx,%eax
  8016d4:	a3 68 d0 81 00       	mov    %eax,0x81d068
					allocblock->startva = requestedblockva;
  8016d9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8016dc:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8016df:	89 10                	mov    %edx,(%eax)
					allocblock->size = size;
  8016e1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8016e4:	8b 55 08             	mov    0x8(%ebp),%edx
  8016e7:	89 50 04             	mov    %edx,0x4(%eax)

					LIST_INSERT_TAIL(&u_allocatedlist, allocblock);
  8016ea:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8016ee:	75 14                	jne    801704 <malloc+0x117>
  8016f0:	83 ec 04             	sub    $0x4,%esp
  8016f3:	68 38 4a 80 00       	push   $0x804a38
  8016f8:	6a 60                	push   $0x60
  8016fa:	68 ec 49 80 00       	push   $0x8049ec
  8016ff:	e8 02 ec ff ff       	call   800306 <_panic>
  801704:	8b 15 34 d1 81 00    	mov    0x81d134,%edx
  80170a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80170d:	89 50 0c             	mov    %edx,0xc(%eax)
  801710:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801713:	8b 40 0c             	mov    0xc(%eax),%eax
  801716:	85 c0                	test   %eax,%eax
  801718:	74 0d                	je     801727 <malloc+0x13a>
  80171a:	a1 34 d1 81 00       	mov    0x81d134,%eax
  80171f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801722:	89 50 08             	mov    %edx,0x8(%eax)
  801725:	eb 08                	jmp    80172f <malloc+0x142>
  801727:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80172a:	a3 30 d1 81 00       	mov    %eax,0x81d130
  80172f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801732:	a3 34 d1 81 00       	mov    %eax,0x81d134
  801737:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80173a:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  801741:	a1 3c d1 81 00       	mov    0x81d13c,%eax
  801746:	40                   	inc    %eax
  801747:	a3 3c d1 81 00       	mov    %eax,0x81d13c


					sys_allocate_user_mem(allocblock->startva ,size);
  80174c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80174f:	8b 00                	mov    (%eax),%eax
  801751:	83 ec 08             	sub    $0x8,%esp
  801754:	ff 75 08             	pushl  0x8(%ebp)
  801757:	50                   	push   %eax
  801758:	e8 34 1c 00 00       	call   803391 <sys_allocate_user_mem>
  80175d:	83 c4 10             	add    $0x10,%esp
					release_uspinlock(&ulock);
  801760:	83 ec 0c             	sub    $0xc,%esp
  801763:	68 40 d1 81 00       	push   $0x81d140
  801768:	e8 6c 27 00 00       	call   803ed9 <release_uspinlock>
  80176d:	83 c4 10             	add    $0x10,%esp
					return (void*)allocblock->startva;
  801770:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801773:	8b 00                	mov    (%eax),%eax
  801775:	e9 6f 03 00 00       	jmp    801ae9 <malloc+0x4fc>
			}else{
					release_uspinlock(&ulock);
  80177a:	83 ec 0c             	sub    $0xc,%esp
  80177d:	68 40 d1 81 00       	push   $0x81d140
  801782:	e8 52 27 00 00       	call   803ed9 <release_uspinlock>
  801787:	83 c4 10             	add    $0x10,%esp
					return NULL;
  80178a:	b8 00 00 00 00       	mov    $0x0,%eax
  80178f:	e9 55 03 00 00       	jmp    801ae9 <malloc+0x4fc>
				}
	}else{
		//custom fit
		struct UserHeapStruct* currentfreeelement = LIST_FIRST(&u_freelist);
  801794:	a1 20 d1 81 00       	mov    0x81d120,%eax
  801799:	89 45 f4             	mov    %eax,-0xc(%ebp)
		//worst fit
		while(currentfreeelement != NULL){
  80179c:	e9 39 03 00 00       	jmp    801ada <malloc+0x4ed>
			if(size<currentfreeelement->size){
  8017a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017a4:	8b 40 04             	mov    0x4(%eax),%eax
  8017a7:	3b 45 08             	cmp    0x8(%ebp),%eax
  8017aa:	0f 86 e7 01 00 00    	jbe    801997 <malloc+0x3aa>
				allocblock->startva = lastfreeelement->startva;
  8017b0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8017b3:	8b 10                	mov    (%eax),%edx
  8017b5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8017b8:	89 10                	mov    %edx,(%eax)
                allocblock->size = size;
  8017ba:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8017bd:	8b 55 08             	mov    0x8(%ebp),%edx
  8017c0:	89 50 04             	mov    %edx,0x4(%eax)
                LIST_INSERT_TAIL(&u_allocatedlist,allocblock);
  8017c3:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8017c7:	75 14                	jne    8017dd <malloc+0x1f0>
  8017c9:	83 ec 04             	sub    $0x4,%esp
  8017cc:	68 38 4a 80 00       	push   $0x804a38
  8017d1:	6a 72                	push   $0x72
  8017d3:	68 ec 49 80 00       	push   $0x8049ec
  8017d8:	e8 29 eb ff ff       	call   800306 <_panic>
  8017dd:	8b 15 34 d1 81 00    	mov    0x81d134,%edx
  8017e3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8017e6:	89 50 0c             	mov    %edx,0xc(%eax)
  8017e9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8017ec:	8b 40 0c             	mov    0xc(%eax),%eax
  8017ef:	85 c0                	test   %eax,%eax
  8017f1:	74 0d                	je     801800 <malloc+0x213>
  8017f3:	a1 34 d1 81 00       	mov    0x81d134,%eax
  8017f8:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8017fb:	89 50 08             	mov    %edx,0x8(%eax)
  8017fe:	eb 08                	jmp    801808 <malloc+0x21b>
  801800:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801803:	a3 30 d1 81 00       	mov    %eax,0x81d130
  801808:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80180b:	a3 34 d1 81 00       	mov    %eax,0x81d134
  801810:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801813:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  80181a:	a1 3c d1 81 00       	mov    0x81d13c,%eax
  80181f:	40                   	inc    %eax
  801820:	a3 3c d1 81 00       	mov    %eax,0x81d13c
                lastfreeelement->startva += size;
  801825:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801828:	8b 10                	mov    (%eax),%edx
  80182a:	8b 45 08             	mov    0x8(%ebp),%eax
  80182d:	01 c2                	add    %eax,%edx
  80182f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801832:	89 10                	mov    %edx,(%eax)
                lastfreeelement->size -= size;
  801834:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801837:	8b 40 04             	mov    0x4(%eax),%eax
  80183a:	2b 45 08             	sub    0x8(%ebp),%eax
  80183d:	89 c2                	mov    %eax,%edx
  80183f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801842:	89 50 04             	mov    %edx,0x4(%eax)
                struct UserHeapStruct* currentfree2 = LIST_FIRST(&u_freelist);
  801845:	a1 20 d1 81 00       	mov    0x81d120,%eax
  80184a:	89 45 f0             	mov    %eax,-0x10(%ebp)
                //check order of last element

                while (currentfree2 != NULL){
  80184d:	e9 0d 01 00 00       	jmp    80195f <malloc+0x372>
                	if(lastfreeelement->size <currentfree2->size){
  801852:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801855:	8b 50 04             	mov    0x4(%eax),%edx
  801858:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80185b:	8b 40 04             	mov    0x4(%eax),%eax
  80185e:	39 c2                	cmp    %eax,%edx
  801860:	0f 83 f0 00 00 00    	jae    801956 <malloc+0x369>
                		LIST_REMOVE(&u_freelist ,lastfreeelement);
  801866:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80186a:	75 14                	jne    801880 <malloc+0x293>
  80186c:	83 ec 04             	sub    $0x4,%esp
  80186f:	68 5b 4a 80 00       	push   $0x804a5b
  801874:	6a 7a                	push   $0x7a
  801876:	68 ec 49 80 00       	push   $0x8049ec
  80187b:	e8 86 ea ff ff       	call   800306 <_panic>
  801880:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801883:	8b 40 08             	mov    0x8(%eax),%eax
  801886:	85 c0                	test   %eax,%eax
  801888:	74 11                	je     80189b <malloc+0x2ae>
  80188a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80188d:	8b 40 08             	mov    0x8(%eax),%eax
  801890:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801893:	8b 52 0c             	mov    0xc(%edx),%edx
  801896:	89 50 0c             	mov    %edx,0xc(%eax)
  801899:	eb 0b                	jmp    8018a6 <malloc+0x2b9>
  80189b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80189e:	8b 40 0c             	mov    0xc(%eax),%eax
  8018a1:	a3 24 d1 81 00       	mov    %eax,0x81d124
  8018a6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8018a9:	8b 40 0c             	mov    0xc(%eax),%eax
  8018ac:	85 c0                	test   %eax,%eax
  8018ae:	74 11                	je     8018c1 <malloc+0x2d4>
  8018b0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8018b3:	8b 40 0c             	mov    0xc(%eax),%eax
  8018b6:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8018b9:	8b 52 08             	mov    0x8(%edx),%edx
  8018bc:	89 50 08             	mov    %edx,0x8(%eax)
  8018bf:	eb 0b                	jmp    8018cc <malloc+0x2df>
  8018c1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8018c4:	8b 40 08             	mov    0x8(%eax),%eax
  8018c7:	a3 20 d1 81 00       	mov    %eax,0x81d120
  8018cc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8018cf:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  8018d6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8018d9:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  8018e0:	a1 2c d1 81 00       	mov    0x81d12c,%eax
  8018e5:	48                   	dec    %eax
  8018e6:	a3 2c d1 81 00       	mov    %eax,0x81d12c
                		LIST_INSERT_BEFORE(&u_freelist ,currentfree2 ,lastfreeelement);
  8018eb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8018ef:	74 06                	je     8018f7 <malloc+0x30a>
  8018f1:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8018f5:	75 14                	jne    80190b <malloc+0x31e>
  8018f7:	83 ec 04             	sub    $0x4,%esp
  8018fa:	68 7c 4a 80 00       	push   $0x804a7c
  8018ff:	6a 7b                	push   $0x7b
  801901:	68 ec 49 80 00       	push   $0x8049ec
  801906:	e8 fb e9 ff ff       	call   800306 <_panic>
  80190b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80190e:	8b 50 0c             	mov    0xc(%eax),%edx
  801911:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801914:	89 50 0c             	mov    %edx,0xc(%eax)
  801917:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80191a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80191d:	89 50 08             	mov    %edx,0x8(%eax)
  801920:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801923:	8b 40 0c             	mov    0xc(%eax),%eax
  801926:	85 c0                	test   %eax,%eax
  801928:	74 0e                	je     801938 <malloc+0x34b>
  80192a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80192d:	8b 40 0c             	mov    0xc(%eax),%eax
  801930:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801933:	89 50 08             	mov    %edx,0x8(%eax)
  801936:	eb 08                	jmp    801940 <malloc+0x353>
  801938:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80193b:	a3 20 d1 81 00       	mov    %eax,0x81d120
  801940:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801943:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801946:	89 50 0c             	mov    %edx,0xc(%eax)
  801949:	a1 2c d1 81 00       	mov    0x81d12c,%eax
  80194e:	40                   	inc    %eax
  80194f:	a3 2c d1 81 00       	mov    %eax,0x81d12c
                		break;
  801954:	eb 13                	jmp    801969 <malloc+0x37c>
                	}
                	currentfree2 = currentfree2->prev_next_info.le_next;
  801956:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801959:	8b 40 08             	mov    0x8(%eax),%eax
  80195c:	89 45 f0             	mov    %eax,-0x10(%ebp)
                lastfreeelement->startva += size;
                lastfreeelement->size -= size;
                struct UserHeapStruct* currentfree2 = LIST_FIRST(&u_freelist);
                //check order of last element

                while (currentfree2 != NULL){
  80195f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801963:	0f 85 e9 fe ff ff    	jne    801852 <malloc+0x265>
                	}
                	currentfree2 = currentfree2->prev_next_info.le_next;
                }


                sys_allocate_user_mem(allocblock->startva ,size);
  801969:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80196c:	8b 00                	mov    (%eax),%eax
  80196e:	83 ec 08             	sub    $0x8,%esp
  801971:	ff 75 08             	pushl  0x8(%ebp)
  801974:	50                   	push   %eax
  801975:	e8 17 1a 00 00       	call   803391 <sys_allocate_user_mem>
  80197a:	83 c4 10             	add    $0x10,%esp
                release_uspinlock(&ulock);
  80197d:	83 ec 0c             	sub    $0xc,%esp
  801980:	68 40 d1 81 00       	push   $0x81d140
  801985:	e8 4f 25 00 00       	call   803ed9 <release_uspinlock>
  80198a:	83 c4 10             	add    $0x10,%esp
                return (void*)allocblock->startva;
  80198d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801990:	8b 00                	mov    (%eax),%eax
  801992:	e9 52 01 00 00       	jmp    801ae9 <malloc+0x4fc>
                //exact fit
			}else if(size == currentfreeelement->size){
  801997:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80199a:	8b 40 04             	mov    0x4(%eax),%eax
  80199d:	3b 45 08             	cmp    0x8(%ebp),%eax
  8019a0:	0f 85 2b 01 00 00    	jne    801ad1 <malloc+0x4e4>
				allocblock->startva = currentfreeelement->startva;
  8019a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019a9:	8b 10                	mov    (%eax),%edx
  8019ab:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8019ae:	89 10                	mov    %edx,(%eax)
				allocblock->size = size;
  8019b0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8019b3:	8b 55 08             	mov    0x8(%ebp),%edx
  8019b6:	89 50 04             	mov    %edx,0x4(%eax)
				LIST_INSERT_TAIL(&u_allocatedlist ,allocblock);
  8019b9:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8019bd:	75 17                	jne    8019d6 <malloc+0x3e9>
  8019bf:	83 ec 04             	sub    $0x4,%esp
  8019c2:	68 38 4a 80 00       	push   $0x804a38
  8019c7:	68 89 00 00 00       	push   $0x89
  8019cc:	68 ec 49 80 00       	push   $0x8049ec
  8019d1:	e8 30 e9 ff ff       	call   800306 <_panic>
  8019d6:	8b 15 34 d1 81 00    	mov    0x81d134,%edx
  8019dc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8019df:	89 50 0c             	mov    %edx,0xc(%eax)
  8019e2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8019e5:	8b 40 0c             	mov    0xc(%eax),%eax
  8019e8:	85 c0                	test   %eax,%eax
  8019ea:	74 0d                	je     8019f9 <malloc+0x40c>
  8019ec:	a1 34 d1 81 00       	mov    0x81d134,%eax
  8019f1:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8019f4:	89 50 08             	mov    %edx,0x8(%eax)
  8019f7:	eb 08                	jmp    801a01 <malloc+0x414>
  8019f9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8019fc:	a3 30 d1 81 00       	mov    %eax,0x81d130
  801a01:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801a04:	a3 34 d1 81 00       	mov    %eax,0x81d134
  801a09:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801a0c:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  801a13:	a1 3c d1 81 00       	mov    0x81d13c,%eax
  801a18:	40                   	inc    %eax
  801a19:	a3 3c d1 81 00       	mov    %eax,0x81d13c
				LIST_REMOVE(&u_freelist ,currentfreeelement);
  801a1e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801a22:	75 17                	jne    801a3b <malloc+0x44e>
  801a24:	83 ec 04             	sub    $0x4,%esp
  801a27:	68 5b 4a 80 00       	push   $0x804a5b
  801a2c:	68 8a 00 00 00       	push   $0x8a
  801a31:	68 ec 49 80 00       	push   $0x8049ec
  801a36:	e8 cb e8 ff ff       	call   800306 <_panic>
  801a3b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a3e:	8b 40 08             	mov    0x8(%eax),%eax
  801a41:	85 c0                	test   %eax,%eax
  801a43:	74 11                	je     801a56 <malloc+0x469>
  801a45:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a48:	8b 40 08             	mov    0x8(%eax),%eax
  801a4b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801a4e:	8b 52 0c             	mov    0xc(%edx),%edx
  801a51:	89 50 0c             	mov    %edx,0xc(%eax)
  801a54:	eb 0b                	jmp    801a61 <malloc+0x474>
  801a56:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a59:	8b 40 0c             	mov    0xc(%eax),%eax
  801a5c:	a3 24 d1 81 00       	mov    %eax,0x81d124
  801a61:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a64:	8b 40 0c             	mov    0xc(%eax),%eax
  801a67:	85 c0                	test   %eax,%eax
  801a69:	74 11                	je     801a7c <malloc+0x48f>
  801a6b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a6e:	8b 40 0c             	mov    0xc(%eax),%eax
  801a71:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801a74:	8b 52 08             	mov    0x8(%edx),%edx
  801a77:	89 50 08             	mov    %edx,0x8(%eax)
  801a7a:	eb 0b                	jmp    801a87 <malloc+0x49a>
  801a7c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a7f:	8b 40 08             	mov    0x8(%eax),%eax
  801a82:	a3 20 d1 81 00       	mov    %eax,0x81d120
  801a87:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a8a:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  801a91:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a94:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  801a9b:	a1 2c d1 81 00       	mov    0x81d12c,%eax
  801aa0:	48                   	dec    %eax
  801aa1:	a3 2c d1 81 00       	mov    %eax,0x81d12c
				sys_allocate_user_mem(allocblock->startva ,size);
  801aa6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801aa9:	8b 00                	mov    (%eax),%eax
  801aab:	83 ec 08             	sub    $0x8,%esp
  801aae:	ff 75 08             	pushl  0x8(%ebp)
  801ab1:	50                   	push   %eax
  801ab2:	e8 da 18 00 00       	call   803391 <sys_allocate_user_mem>
  801ab7:	83 c4 10             	add    $0x10,%esp
				release_uspinlock(&ulock);
  801aba:	83 ec 0c             	sub    $0xc,%esp
  801abd:	68 40 d1 81 00       	push   $0x81d140
  801ac2:	e8 12 24 00 00       	call   803ed9 <release_uspinlock>
  801ac7:	83 c4 10             	add    $0x10,%esp
				return (void*)allocblock->startva;
  801aca:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801acd:	8b 00                	mov    (%eax),%eax
  801acf:	eb 18                	jmp    801ae9 <malloc+0x4fc>
			}
			currentfreeelement = currentfreeelement->prev_next_info.le_next;
  801ad1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ad4:	8b 40 08             	mov    0x8(%eax),%eax
  801ad7:	89 45 f4             	mov    %eax,-0xc(%ebp)
				}
	}else{
		//custom fit
		struct UserHeapStruct* currentfreeelement = LIST_FIRST(&u_freelist);
		//worst fit
		while(currentfreeelement != NULL){
  801ada:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801ade:	0f 85 bd fc ff ff    	jne    8017a1 <malloc+0x1b4>
				return (void*)allocblock->startva;
			}
			currentfreeelement = currentfreeelement->prev_next_info.le_next;
		}
	}
	 return NULL;
  801ae4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ae9:	c9                   	leave  
  801aea:	c3                   	ret    

00801aeb <free>:

//=================================
// [2] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
  801aeb:	55                   	push   %ebp
  801aec:	89 e5                	mov    %esp,%ebp
  801aee:	83 ec 38             	sub    $0x38,%esp
	uint32  VA = ROUNDDOWN(((uint32 ) virtual_address), PAGE_SIZE);
  801af1:	8b 45 08             	mov    0x8(%ebp),%eax
  801af4:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801af7:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801afa:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801aff:	89 45 d8             	mov    %eax,-0x28(%ebp)


		uheap_init();
  801b02:	e8 b2 f9 ff ff       	call   8014b9 <uheap_init>
		acquire_uspinlock(&ulock);
  801b07:	83 ec 0c             	sub    $0xc,%esp
  801b0a:	68 40 d1 81 00       	push   $0x81d140
  801b0f:	e8 6d 23 00 00       	call   803e81 <acquire_uspinlock>
  801b14:	83 c4 10             	add    $0x10,%esp
		if (VA < uheapPageAllocStart){
  801b17:	a1 10 d1 81 00       	mov    0x81d110,%eax
  801b1c:	39 45 d8             	cmp    %eax,-0x28(%ebp)
  801b1f:	73 23                	jae    801b44 <free+0x59>
			free_block(virtual_address);
  801b21:	83 ec 0c             	sub    $0xc,%esp
  801b24:	ff 75 08             	pushl  0x8(%ebp)
  801b27:	e8 89 1f 00 00       	call   803ab5 <free_block>
  801b2c:	83 c4 10             	add    $0x10,%esp
			release_uspinlock(&ulock);
  801b2f:	83 ec 0c             	sub    $0xc,%esp
  801b32:	68 40 d1 81 00       	push   $0x81d140
  801b37:	e8 9d 23 00 00       	call   803ed9 <release_uspinlock>
  801b3c:	83 c4 10             	add    $0x10,%esp
			return;
  801b3f:	e9 35 07 00 00       	jmp    802279 <free+0x78e>
		}
		if (VA >= uheapPageAllocBreak){
  801b44:	a1 68 d0 81 00       	mov    0x81d068,%eax
  801b49:	39 45 d8             	cmp    %eax,-0x28(%ebp)
  801b4c:	72 30                	jb     801b7e <free+0x93>
			cprintf("%d\n %d\n", VA, uheapPageAllocBreak);
  801b4e:	a1 68 d0 81 00       	mov    0x81d068,%eax
  801b53:	83 ec 04             	sub    $0x4,%esp
  801b56:	50                   	push   %eax
  801b57:	ff 75 d8             	pushl  -0x28(%ebp)
  801b5a:	68 b1 4a 80 00       	push   $0x804ab1
  801b5f:	e8 70 ea ff ff       	call   8005d4 <cprintf>
  801b64:	83 c4 10             	add    $0x10,%esp

			panic("freeing from restricted area");
  801b67:	83 ec 04             	sub    $0x4,%esp
  801b6a:	68 b9 4a 80 00       	push   $0x804ab9
  801b6f:	68 a7 00 00 00       	push   $0xa7
  801b74:	68 ec 49 80 00       	push   $0x8049ec
  801b79:	e8 88 e7 ff ff       	call   800306 <_panic>
			release_uspinlock(&ulock);
			return;
		}

		struct UserHeapStruct* newfree = (struct UserHeapStruct*) alloc_block(sizeof(struct UserHeapStruct));
  801b7e:	83 ec 0c             	sub    $0xc,%esp
  801b81:	6a 10                	push   $0x10
  801b83:	e8 91 1a 00 00       	call   803619 <alloc_block>
  801b88:	83 c4 10             	add    $0x10,%esp
  801b8b:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		struct UserHeapStruct* MergedBlock  = ( struct UserHeapStruct*)alloc_block(sizeof(struct UserHeapStruct));
  801b8e:	83 ec 0c             	sub    $0xc,%esp
  801b91:	6a 10                	push   $0x10
  801b93:	e8 81 1a 00 00       	call   803619 <alloc_block>
  801b98:	83 c4 10             	add    $0x10,%esp
  801b9b:	89 45 d0             	mov    %eax,-0x30(%ebp)

		struct UserHeapStruct* ToBefreed = LIST_FIRST(&u_allocatedlist);
  801b9e:	a1 30 d1 81 00       	mov    0x81d130,%eax
  801ba3:	89 45 f4             	mov    %eax,-0xc(%ebp)
		bool foundVA = 0;
  801ba6:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

		//find the allocated block
		while(ToBefreed !=NULL ){
  801bad:	eb 1c                	jmp    801bcb <free+0xe0>

			if (VA ==ToBefreed->startva ){
  801baf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bb2:	8b 00                	mov    (%eax),%eax
  801bb4:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  801bb7:	75 09                	jne    801bc2 <free+0xd7>
				foundVA = 1;
  801bb9:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
				break;
  801bc0:	eb 0f                	jmp    801bd1 <free+0xe6>
			}
				ToBefreed = ToBefreed->prev_next_info.le_next;
  801bc2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bc5:	8b 40 08             	mov    0x8(%eax),%eax
  801bc8:	89 45 f4             	mov    %eax,-0xc(%ebp)

		struct UserHeapStruct* ToBefreed = LIST_FIRST(&u_allocatedlist);
		bool foundVA = 0;

		//find the allocated block
		while(ToBefreed !=NULL ){
  801bcb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801bcf:	75 de                	jne    801baf <free+0xc4>
			}
				ToBefreed = ToBefreed->prev_next_info.le_next;
		}


		if(!foundVA){
  801bd1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801bd5:	75 17                	jne    801bee <free+0x103>
				panic("INVALID ADDRESS!");
  801bd7:	83 ec 04             	sub    $0x4,%esp
  801bda:	68 d6 4a 80 00       	push   $0x804ad6
  801bdf:	68 be 00 00 00       	push   $0xbe
  801be4:	68 ec 49 80 00       	push   $0x8049ec
  801be9:	e8 18 e7 ff ff       	call   800306 <_panic>
				release_uspinlock(&ulock);
				return;
			}


		newfree->startva = ToBefreed->startva;
  801bee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bf1:	8b 10                	mov    (%eax),%edx
  801bf3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801bf6:	89 10                	mov    %edx,(%eax)
		newfree->size = ToBefreed->size;
  801bf8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bfb:	8b 50 04             	mov    0x4(%eax),%edx
  801bfe:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801c01:	89 50 04             	mov    %edx,0x4(%eax)

		//remove allocated block from alloclist
		LIST_REMOVE(&u_allocatedlist, ToBefreed);
  801c04:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801c08:	75 17                	jne    801c21 <free+0x136>
  801c0a:	83 ec 04             	sub    $0x4,%esp
  801c0d:	68 5b 4a 80 00       	push   $0x804a5b
  801c12:	68 c8 00 00 00       	push   $0xc8
  801c17:	68 ec 49 80 00       	push   $0x8049ec
  801c1c:	e8 e5 e6 ff ff       	call   800306 <_panic>
  801c21:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c24:	8b 40 08             	mov    0x8(%eax),%eax
  801c27:	85 c0                	test   %eax,%eax
  801c29:	74 11                	je     801c3c <free+0x151>
  801c2b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c2e:	8b 40 08             	mov    0x8(%eax),%eax
  801c31:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801c34:	8b 52 0c             	mov    0xc(%edx),%edx
  801c37:	89 50 0c             	mov    %edx,0xc(%eax)
  801c3a:	eb 0b                	jmp    801c47 <free+0x15c>
  801c3c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c3f:	8b 40 0c             	mov    0xc(%eax),%eax
  801c42:	a3 34 d1 81 00       	mov    %eax,0x81d134
  801c47:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c4a:	8b 40 0c             	mov    0xc(%eax),%eax
  801c4d:	85 c0                	test   %eax,%eax
  801c4f:	74 11                	je     801c62 <free+0x177>
  801c51:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c54:	8b 40 0c             	mov    0xc(%eax),%eax
  801c57:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801c5a:	8b 52 08             	mov    0x8(%edx),%edx
  801c5d:	89 50 08             	mov    %edx,0x8(%eax)
  801c60:	eb 0b                	jmp    801c6d <free+0x182>
  801c62:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c65:	8b 40 08             	mov    0x8(%eax),%eax
  801c68:	a3 30 d1 81 00       	mov    %eax,0x81d130
  801c6d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c70:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  801c77:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c7a:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  801c81:	a1 3c d1 81 00       	mov    0x81d13c,%eax
  801c86:	48                   	dec    %eax
  801c87:	a3 3c d1 81 00       	mov    %eax,0x81d13c

		sys_free_user_mem(ToBefreed->startva, ToBefreed->size);
  801c8c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c8f:	8b 50 04             	mov    0x4(%eax),%edx
  801c92:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c95:	8b 00                	mov    (%eax),%eax
  801c97:	83 ec 08             	sub    $0x8,%esp
  801c9a:	52                   	push   %edx
  801c9b:	50                   	push   %eax
  801c9c:	e8 d4 16 00 00       	call   803375 <sys_free_user_mem>
  801ca1:	83 c4 10             	add    $0x10,%esp




		if(LIST_SIZE(&u_freelist) == 0){
  801ca4:	a1 2c d1 81 00       	mov    0x81d12c,%eax
  801ca9:	85 c0                	test   %eax,%eax
  801cab:	75 7a                	jne    801d27 <free+0x23c>
			LIST_INSERT_HEAD(&u_freelist,newfree);
  801cad:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  801cb1:	75 17                	jne    801cca <free+0x1df>
  801cb3:	83 ec 04             	sub    $0x4,%esp
  801cb6:	68 e8 4a 80 00       	push   $0x804ae8
  801cbb:	68 d0 00 00 00       	push   $0xd0
  801cc0:	68 ec 49 80 00       	push   $0x8049ec
  801cc5:	e8 3c e6 ff ff       	call   800306 <_panic>
  801cca:	8b 15 20 d1 81 00    	mov    0x81d120,%edx
  801cd0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801cd3:	89 50 08             	mov    %edx,0x8(%eax)
  801cd6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801cd9:	8b 40 08             	mov    0x8(%eax),%eax
  801cdc:	85 c0                	test   %eax,%eax
  801cde:	74 0d                	je     801ced <free+0x202>
  801ce0:	a1 20 d1 81 00       	mov    0x81d120,%eax
  801ce5:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  801ce8:	89 50 0c             	mov    %edx,0xc(%eax)
  801ceb:	eb 08                	jmp    801cf5 <free+0x20a>
  801ced:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801cf0:	a3 24 d1 81 00       	mov    %eax,0x81d124
  801cf5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801cf8:	a3 20 d1 81 00       	mov    %eax,0x81d120
  801cfd:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801d00:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  801d07:	a1 2c d1 81 00       	mov    0x81d12c,%eax
  801d0c:	40                   	inc    %eax
  801d0d:	a3 2c d1 81 00       	mov    %eax,0x81d12c
			release_uspinlock(&ulock);
  801d12:	83 ec 0c             	sub    $0xc,%esp
  801d15:	68 40 d1 81 00       	push   $0x81d140
  801d1a:	e8 ba 21 00 00       	call   803ed9 <release_uspinlock>
  801d1f:	83 c4 10             	add    $0x10,%esp
			return;
  801d22:	e9 52 05 00 00       	jmp    802279 <free+0x78e>
		}


		struct UserHeapStruct* ToBeMerged = LIST_FIRST(&u_freelist);
  801d27:	a1 20 d1 81 00       	mov    0x81d120,%eax
  801d2c:	89 45 ec             	mov    %eax,-0x14(%ebp)
		// merge with prev if possible
		bool mergeprev = 0;
  801d2f:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		bool mergenext = 0;
  801d36:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
		while(ToBeMerged != NULL){
  801d3d:	e9 d2 00 00 00       	jmp    801e14 <free+0x329>
			if((ToBeMerged->startva +ToBeMerged->size) == newfree->startva){
  801d42:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801d45:	8b 10                	mov    (%eax),%edx
  801d47:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801d4a:	8b 40 04             	mov    0x4(%eax),%eax
  801d4d:	01 c2                	add    %eax,%edx
  801d4f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801d52:	8b 00                	mov    (%eax),%eax
  801d54:	39 c2                	cmp    %eax,%edx
  801d56:	0f 85 af 00 00 00    	jne    801e0b <free+0x320>

				MergedBlock->startva = ToBeMerged->startva;
  801d5c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801d5f:	8b 10                	mov    (%eax),%edx
  801d61:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801d64:	89 10                	mov    %edx,(%eax)
				MergedBlock->size = ToBeMerged->size + newfree->size;
  801d66:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801d69:	8b 50 04             	mov    0x4(%eax),%edx
  801d6c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801d6f:	8b 40 04             	mov    0x4(%eax),%eax
  801d72:	01 c2                	add    %eax,%edx
  801d74:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801d77:	89 50 04             	mov    %edx,0x4(%eax)
				LIST_REMOVE(&u_freelist, ToBeMerged);
  801d7a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801d7e:	75 17                	jne    801d97 <free+0x2ac>
  801d80:	83 ec 04             	sub    $0x4,%esp
  801d83:	68 5b 4a 80 00       	push   $0x804a5b
  801d88:	68 df 00 00 00       	push   $0xdf
  801d8d:	68 ec 49 80 00       	push   $0x8049ec
  801d92:	e8 6f e5 ff ff       	call   800306 <_panic>
  801d97:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801d9a:	8b 40 08             	mov    0x8(%eax),%eax
  801d9d:	85 c0                	test   %eax,%eax
  801d9f:	74 11                	je     801db2 <free+0x2c7>
  801da1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801da4:	8b 40 08             	mov    0x8(%eax),%eax
  801da7:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801daa:	8b 52 0c             	mov    0xc(%edx),%edx
  801dad:	89 50 0c             	mov    %edx,0xc(%eax)
  801db0:	eb 0b                	jmp    801dbd <free+0x2d2>
  801db2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801db5:	8b 40 0c             	mov    0xc(%eax),%eax
  801db8:	a3 24 d1 81 00       	mov    %eax,0x81d124
  801dbd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801dc0:	8b 40 0c             	mov    0xc(%eax),%eax
  801dc3:	85 c0                	test   %eax,%eax
  801dc5:	74 11                	je     801dd8 <free+0x2ed>
  801dc7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801dca:	8b 40 0c             	mov    0xc(%eax),%eax
  801dcd:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801dd0:	8b 52 08             	mov    0x8(%edx),%edx
  801dd3:	89 50 08             	mov    %edx,0x8(%eax)
  801dd6:	eb 0b                	jmp    801de3 <free+0x2f8>
  801dd8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801ddb:	8b 40 08             	mov    0x8(%eax),%eax
  801dde:	a3 20 d1 81 00       	mov    %eax,0x81d120
  801de3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801de6:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  801ded:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801df0:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  801df7:	a1 2c d1 81 00       	mov    0x81d12c,%eax
  801dfc:	48                   	dec    %eax
  801dfd:	a3 2c d1 81 00       	mov    %eax,0x81d12c
				mergeprev = 1;
  801e02:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
				break;
  801e09:	eb 13                	jmp    801e1e <free+0x333>
			}
				ToBeMerged = ToBeMerged->prev_next_info.le_next;
  801e0b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801e0e:	8b 40 08             	mov    0x8(%eax),%eax
  801e11:	89 45 ec             	mov    %eax,-0x14(%ebp)

		struct UserHeapStruct* ToBeMerged = LIST_FIRST(&u_freelist);
		// merge with prev if possible
		bool mergeprev = 0;
		bool mergenext = 0;
		while(ToBeMerged != NULL){
  801e14:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801e18:	0f 85 24 ff ff ff    	jne    801d42 <free+0x257>
//									uheapPageAllocBreak = newfree->startva;
//						}
//					}


		if ( newfree ->startva + newfree->size == uheapPageAllocBreak){
  801e1e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801e21:	8b 10                	mov    (%eax),%edx
  801e23:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801e26:	8b 40 04             	mov    0x4(%eax),%eax
  801e29:	01 c2                	add    %eax,%edx
  801e2b:	a1 68 d0 81 00       	mov    0x81d068,%eax
  801e30:	39 c2                	cmp    %eax,%edx
  801e32:	75 44                	jne    801e78 <free+0x38d>

			if(mergeprev){
  801e34:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  801e38:	74 1f                	je     801e59 <free+0x36e>
				uheapPageAllocBreak = MergedBlock->startva;
  801e3a:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801e3d:	8b 00                	mov    (%eax),%eax
  801e3f:	a3 68 d0 81 00       	mov    %eax,0x81d068
				release_uspinlock(&ulock);
  801e44:	83 ec 0c             	sub    $0xc,%esp
  801e47:	68 40 d1 81 00       	push   $0x81d140
  801e4c:	e8 88 20 00 00       	call   803ed9 <release_uspinlock>
  801e51:	83 c4 10             	add    $0x10,%esp
				return;
  801e54:	e9 20 04 00 00       	jmp    802279 <free+0x78e>

			}else{
				uheapPageAllocBreak = newfree->startva;
  801e59:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801e5c:	8b 00                	mov    (%eax),%eax
  801e5e:	a3 68 d0 81 00       	mov    %eax,0x81d068
				release_uspinlock(&ulock);
  801e63:	83 ec 0c             	sub    $0xc,%esp
  801e66:	68 40 d1 81 00       	push   $0x81d140
  801e6b:	e8 69 20 00 00       	call   803ed9 <release_uspinlock>
  801e70:	83 c4 10             	add    $0x10,%esp
				return;
  801e73:	e9 01 04 00 00       	jmp    802279 <free+0x78e>

		}


		//check if block is merged with prev ,and find possible merge with next
		ToBeMerged = LIST_FIRST(&u_freelist);
  801e78:	a1 20 d1 81 00       	mov    0x81d120,%eax
  801e7d:	89 45 ec             	mov    %eax,-0x14(%ebp)
		while(ToBeMerged != NULL){
  801e80:	e9 7d 01 00 00       	jmp    802002 <free+0x517>
			if ((newfree->startva + newfree->size) == ToBeMerged->startva ){
  801e85:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801e88:	8b 10                	mov    (%eax),%edx
  801e8a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801e8d:	8b 40 04             	mov    0x4(%eax),%eax
  801e90:	01 c2                	add    %eax,%edx
  801e92:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801e95:	8b 00                	mov    (%eax),%eax
  801e97:	39 c2                	cmp    %eax,%edx
  801e99:	0f 85 5a 01 00 00    	jne    801ff9 <free+0x50e>
				if (mergeprev){
  801e9f:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  801ea3:	0f 84 a1 00 00 00    	je     801f4a <free+0x45f>
					MergedBlock->size += ToBeMerged->size;
  801ea9:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801eac:	8b 50 04             	mov    0x4(%eax),%edx
  801eaf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801eb2:	8b 40 04             	mov    0x4(%eax),%eax
  801eb5:	01 c2                	add    %eax,%edx
  801eb7:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801eba:	89 50 04             	mov    %edx,0x4(%eax)
					LIST_REMOVE(&u_freelist, ToBeMerged);
  801ebd:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801ec1:	75 17                	jne    801eda <free+0x3ef>
  801ec3:	83 ec 04             	sub    $0x4,%esp
  801ec6:	68 5b 4a 80 00       	push   $0x804a5b
  801ecb:	68 0a 01 00 00       	push   $0x10a
  801ed0:	68 ec 49 80 00       	push   $0x8049ec
  801ed5:	e8 2c e4 ff ff       	call   800306 <_panic>
  801eda:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801edd:	8b 40 08             	mov    0x8(%eax),%eax
  801ee0:	85 c0                	test   %eax,%eax
  801ee2:	74 11                	je     801ef5 <free+0x40a>
  801ee4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801ee7:	8b 40 08             	mov    0x8(%eax),%eax
  801eea:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801eed:	8b 52 0c             	mov    0xc(%edx),%edx
  801ef0:	89 50 0c             	mov    %edx,0xc(%eax)
  801ef3:	eb 0b                	jmp    801f00 <free+0x415>
  801ef5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801ef8:	8b 40 0c             	mov    0xc(%eax),%eax
  801efb:	a3 24 d1 81 00       	mov    %eax,0x81d124
  801f00:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f03:	8b 40 0c             	mov    0xc(%eax),%eax
  801f06:	85 c0                	test   %eax,%eax
  801f08:	74 11                	je     801f1b <free+0x430>
  801f0a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f0d:	8b 40 0c             	mov    0xc(%eax),%eax
  801f10:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801f13:	8b 52 08             	mov    0x8(%edx),%edx
  801f16:	89 50 08             	mov    %edx,0x8(%eax)
  801f19:	eb 0b                	jmp    801f26 <free+0x43b>
  801f1b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f1e:	8b 40 08             	mov    0x8(%eax),%eax
  801f21:	a3 20 d1 81 00       	mov    %eax,0x81d120
  801f26:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f29:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  801f30:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f33:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  801f3a:	a1 2c d1 81 00       	mov    0x81d12c,%eax
  801f3f:	48                   	dec    %eax
  801f40:	a3 2c d1 81 00       	mov    %eax,0x81d12c
					break;
  801f45:	e9 c2 00 00 00       	jmp    80200c <free+0x521>
		//if not merged find possible merge with next
				}else{
					MergedBlock->startva = newfree->startva;
  801f4a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801f4d:	8b 10                	mov    (%eax),%edx
  801f4f:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801f52:	89 10                	mov    %edx,(%eax)
					MergedBlock->size  = newfree->size + ToBeMerged->size;
  801f54:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801f57:	8b 50 04             	mov    0x4(%eax),%edx
  801f5a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f5d:	8b 40 04             	mov    0x4(%eax),%eax
  801f60:	01 c2                	add    %eax,%edx
  801f62:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801f65:	89 50 04             	mov    %edx,0x4(%eax)
					LIST_REMOVE(&u_freelist, ToBeMerged);
  801f68:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801f6c:	75 17                	jne    801f85 <free+0x49a>
  801f6e:	83 ec 04             	sub    $0x4,%esp
  801f71:	68 5b 4a 80 00       	push   $0x804a5b
  801f76:	68 10 01 00 00       	push   $0x110
  801f7b:	68 ec 49 80 00       	push   $0x8049ec
  801f80:	e8 81 e3 ff ff       	call   800306 <_panic>
  801f85:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f88:	8b 40 08             	mov    0x8(%eax),%eax
  801f8b:	85 c0                	test   %eax,%eax
  801f8d:	74 11                	je     801fa0 <free+0x4b5>
  801f8f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f92:	8b 40 08             	mov    0x8(%eax),%eax
  801f95:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801f98:	8b 52 0c             	mov    0xc(%edx),%edx
  801f9b:	89 50 0c             	mov    %edx,0xc(%eax)
  801f9e:	eb 0b                	jmp    801fab <free+0x4c0>
  801fa0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801fa3:	8b 40 0c             	mov    0xc(%eax),%eax
  801fa6:	a3 24 d1 81 00       	mov    %eax,0x81d124
  801fab:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801fae:	8b 40 0c             	mov    0xc(%eax),%eax
  801fb1:	85 c0                	test   %eax,%eax
  801fb3:	74 11                	je     801fc6 <free+0x4db>
  801fb5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801fb8:	8b 40 0c             	mov    0xc(%eax),%eax
  801fbb:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801fbe:	8b 52 08             	mov    0x8(%edx),%edx
  801fc1:	89 50 08             	mov    %edx,0x8(%eax)
  801fc4:	eb 0b                	jmp    801fd1 <free+0x4e6>
  801fc6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801fc9:	8b 40 08             	mov    0x8(%eax),%eax
  801fcc:	a3 20 d1 81 00       	mov    %eax,0x81d120
  801fd1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801fd4:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  801fdb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801fde:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  801fe5:	a1 2c d1 81 00       	mov    0x81d12c,%eax
  801fea:	48                   	dec    %eax
  801feb:	a3 2c d1 81 00       	mov    %eax,0x81d12c
					mergenext = 1;
  801ff0:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
					break;
  801ff7:	eb 13                	jmp    80200c <free+0x521>
				}
			}
			ToBeMerged = ToBeMerged->prev_next_info.le_next;
  801ff9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801ffc:	8b 40 08             	mov    0x8(%eax),%eax
  801fff:	89 45 ec             	mov    %eax,-0x14(%ebp)
		}


		//check if block is merged with prev ,and find possible merge with next
		ToBeMerged = LIST_FIRST(&u_freelist);
		while(ToBeMerged != NULL){
  802002:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802006:	0f 85 79 fe ff ff    	jne    801e85 <free+0x39a>




			// insertion
			struct UserHeapStruct* currentfree = LIST_FIRST(&u_freelist);
  80200c:	a1 20 d1 81 00       	mov    0x81d120,%eax
  802011:	89 45 e0             	mov    %eax,-0x20(%ebp)

			if(mergeprev || mergenext){
  802014:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802018:	0f 85 ad 00 00 00    	jne    8020cb <free+0x5e0>
  80201e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802022:	0f 84 c3 01 00 00    	je     8021eb <free+0x700>
				while(currentfree != NULL){
  802028:	e9 9e 00 00 00       	jmp    8020cb <free+0x5e0>
					if(MergedBlock->size < currentfree->size){
  80202d:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802030:	8b 50 04             	mov    0x4(%eax),%edx
  802033:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802036:	8b 40 04             	mov    0x4(%eax),%eax
  802039:	39 c2                	cmp    %eax,%edx
  80203b:	0f 83 81 00 00 00    	jae    8020c2 <free+0x5d7>

							LIST_INSERT_BEFORE(&u_freelist,currentfree,MergedBlock);
  802041:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802045:	74 06                	je     80204d <free+0x562>
  802047:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  80204b:	75 17                	jne    802064 <free+0x579>
  80204d:	83 ec 04             	sub    $0x4,%esp
  802050:	68 7c 4a 80 00       	push   $0x804a7c
  802055:	68 23 01 00 00       	push   $0x123
  80205a:	68 ec 49 80 00       	push   $0x8049ec
  80205f:	e8 a2 e2 ff ff       	call   800306 <_panic>
  802064:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802067:	8b 50 0c             	mov    0xc(%eax),%edx
  80206a:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80206d:	89 50 0c             	mov    %edx,0xc(%eax)
  802070:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802073:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802076:	89 50 08             	mov    %edx,0x8(%eax)
  802079:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80207c:	8b 40 0c             	mov    0xc(%eax),%eax
  80207f:	85 c0                	test   %eax,%eax
  802081:	74 0e                	je     802091 <free+0x5a6>
  802083:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802086:	8b 40 0c             	mov    0xc(%eax),%eax
  802089:	8b 55 d0             	mov    -0x30(%ebp),%edx
  80208c:	89 50 08             	mov    %edx,0x8(%eax)
  80208f:	eb 08                	jmp    802099 <free+0x5ae>
  802091:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802094:	a3 20 d1 81 00       	mov    %eax,0x81d120
  802099:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80209c:	8b 55 d0             	mov    -0x30(%ebp),%edx
  80209f:	89 50 0c             	mov    %edx,0xc(%eax)
  8020a2:	a1 2c d1 81 00       	mov    0x81d12c,%eax
  8020a7:	40                   	inc    %eax
  8020a8:	a3 2c d1 81 00       	mov    %eax,0x81d12c
							release_uspinlock(&ulock);
  8020ad:	83 ec 0c             	sub    $0xc,%esp
  8020b0:	68 40 d1 81 00       	push   $0x81d140
  8020b5:	e8 1f 1e 00 00       	call   803ed9 <release_uspinlock>
  8020ba:	83 c4 10             	add    $0x10,%esp
							return;
  8020bd:	e9 b7 01 00 00       	jmp    802279 <free+0x78e>
					}
							currentfree = currentfree->prev_next_info.le_next;
  8020c2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8020c5:	8b 40 08             	mov    0x8(%eax),%eax
  8020c8:	89 45 e0             	mov    %eax,-0x20(%ebp)

			// insertion
			struct UserHeapStruct* currentfree = LIST_FIRST(&u_freelist);

			if(mergeprev || mergenext){
				while(currentfree != NULL){
  8020cb:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8020cf:	0f 85 58 ff ff ff    	jne    80202d <free+0x542>
							release_uspinlock(&ulock);
							return;
					}
							currentfree = currentfree->prev_next_info.le_next;
				}
				free_block(newfree);
  8020d5:	83 ec 0c             	sub    $0xc,%esp
  8020d8:	ff 75 d4             	pushl  -0x2c(%ebp)
  8020db:	e8 d5 19 00 00       	call   803ab5 <free_block>
  8020e0:	83 c4 10             	add    $0x10,%esp
				LIST_INSERT_TAIL(&u_freelist,MergedBlock);
  8020e3:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  8020e7:	75 17                	jne    802100 <free+0x615>
  8020e9:	83 ec 04             	sub    $0x4,%esp
  8020ec:	68 38 4a 80 00       	push   $0x804a38
  8020f1:	68 2a 01 00 00       	push   $0x12a
  8020f6:	68 ec 49 80 00       	push   $0x8049ec
  8020fb:	e8 06 e2 ff ff       	call   800306 <_panic>
  802100:	8b 15 24 d1 81 00    	mov    0x81d124,%edx
  802106:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802109:	89 50 0c             	mov    %edx,0xc(%eax)
  80210c:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80210f:	8b 40 0c             	mov    0xc(%eax),%eax
  802112:	85 c0                	test   %eax,%eax
  802114:	74 0d                	je     802123 <free+0x638>
  802116:	a1 24 d1 81 00       	mov    0x81d124,%eax
  80211b:	8b 55 d0             	mov    -0x30(%ebp),%edx
  80211e:	89 50 08             	mov    %edx,0x8(%eax)
  802121:	eb 08                	jmp    80212b <free+0x640>
  802123:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802126:	a3 20 d1 81 00       	mov    %eax,0x81d120
  80212b:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80212e:	a3 24 d1 81 00       	mov    %eax,0x81d124
  802133:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802136:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  80213d:	a1 2c d1 81 00       	mov    0x81d12c,%eax
  802142:	40                   	inc    %eax
  802143:	a3 2c d1 81 00       	mov    %eax,0x81d12c
  802148:	e9 1b 01 00 00       	jmp    802268 <free+0x77d>

			}else{
				while(currentfree != NULL){
					if(newfree->size < currentfree->size){
  80214d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802150:	8b 50 04             	mov    0x4(%eax),%edx
  802153:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802156:	8b 40 04             	mov    0x4(%eax),%eax
  802159:	39 c2                	cmp    %eax,%edx
  80215b:	0f 83 81 00 00 00    	jae    8021e2 <free+0x6f7>

							LIST_INSERT_BEFORE(&u_freelist,currentfree,newfree);
  802161:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802165:	74 06                	je     80216d <free+0x682>
  802167:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80216b:	75 17                	jne    802184 <free+0x699>
  80216d:	83 ec 04             	sub    $0x4,%esp
  802170:	68 7c 4a 80 00       	push   $0x804a7c
  802175:	68 30 01 00 00       	push   $0x130
  80217a:	68 ec 49 80 00       	push   $0x8049ec
  80217f:	e8 82 e1 ff ff       	call   800306 <_panic>
  802184:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802187:	8b 50 0c             	mov    0xc(%eax),%edx
  80218a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80218d:	89 50 0c             	mov    %edx,0xc(%eax)
  802190:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802193:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802196:	89 50 08             	mov    %edx,0x8(%eax)
  802199:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80219c:	8b 40 0c             	mov    0xc(%eax),%eax
  80219f:	85 c0                	test   %eax,%eax
  8021a1:	74 0e                	je     8021b1 <free+0x6c6>
  8021a3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8021a6:	8b 40 0c             	mov    0xc(%eax),%eax
  8021a9:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8021ac:	89 50 08             	mov    %edx,0x8(%eax)
  8021af:	eb 08                	jmp    8021b9 <free+0x6ce>
  8021b1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8021b4:	a3 20 d1 81 00       	mov    %eax,0x81d120
  8021b9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8021bc:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8021bf:	89 50 0c             	mov    %edx,0xc(%eax)
  8021c2:	a1 2c d1 81 00       	mov    0x81d12c,%eax
  8021c7:	40                   	inc    %eax
  8021c8:	a3 2c d1 81 00       	mov    %eax,0x81d12c
							release_uspinlock(&ulock);
  8021cd:	83 ec 0c             	sub    $0xc,%esp
  8021d0:	68 40 d1 81 00       	push   $0x81d140
  8021d5:	e8 ff 1c 00 00       	call   803ed9 <release_uspinlock>
  8021da:	83 c4 10             	add    $0x10,%esp
							return;
  8021dd:	e9 97 00 00 00       	jmp    802279 <free+0x78e>
					}
							currentfree = currentfree->prev_next_info.le_next;
  8021e2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8021e5:	8b 40 08             	mov    0x8(%eax),%eax
  8021e8:	89 45 e0             	mov    %eax,-0x20(%ebp)
				}
				free_block(newfree);
				LIST_INSERT_TAIL(&u_freelist,MergedBlock);

			}else{
				while(currentfree != NULL){
  8021eb:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8021ef:	0f 85 58 ff ff ff    	jne    80214d <free+0x662>
							release_uspinlock(&ulock);
							return;
					}
							currentfree = currentfree->prev_next_info.le_next;
				}
				free_block(MergedBlock);
  8021f5:	83 ec 0c             	sub    $0xc,%esp
  8021f8:	ff 75 d0             	pushl  -0x30(%ebp)
  8021fb:	e8 b5 18 00 00       	call   803ab5 <free_block>
  802200:	83 c4 10             	add    $0x10,%esp
				LIST_INSERT_TAIL(&u_freelist,newfree);
  802203:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  802207:	75 17                	jne    802220 <free+0x735>
  802209:	83 ec 04             	sub    $0x4,%esp
  80220c:	68 38 4a 80 00       	push   $0x804a38
  802211:	68 37 01 00 00       	push   $0x137
  802216:	68 ec 49 80 00       	push   $0x8049ec
  80221b:	e8 e6 e0 ff ff       	call   800306 <_panic>
  802220:	8b 15 24 d1 81 00    	mov    0x81d124,%edx
  802226:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802229:	89 50 0c             	mov    %edx,0xc(%eax)
  80222c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80222f:	8b 40 0c             	mov    0xc(%eax),%eax
  802232:	85 c0                	test   %eax,%eax
  802234:	74 0d                	je     802243 <free+0x758>
  802236:	a1 24 d1 81 00       	mov    0x81d124,%eax
  80223b:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80223e:	89 50 08             	mov    %edx,0x8(%eax)
  802241:	eb 08                	jmp    80224b <free+0x760>
  802243:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802246:	a3 20 d1 81 00       	mov    %eax,0x81d120
  80224b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80224e:	a3 24 d1 81 00       	mov    %eax,0x81d124
  802253:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802256:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  80225d:	a1 2c d1 81 00       	mov    0x81d12c,%eax
  802262:	40                   	inc    %eax
  802263:	a3 2c d1 81 00       	mov    %eax,0x81d12c
			}
		release_uspinlock(&ulock);
  802268:	83 ec 0c             	sub    $0xc,%esp
  80226b:	68 40 d1 81 00       	push   $0x81d140
  802270:	e8 64 1c 00 00       	call   803ed9 <release_uspinlock>
  802275:	83 c4 10             	add    $0x10,%esp
		return;
  802278:	90                   	nop
}
  802279:	c9                   	leave  
  80227a:	c3                   	ret    

0080227b <smalloc>:

//=================================
// [3] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  80227b:	55                   	push   %ebp
  80227c:	89 e5                	mov    %esp,%ebp
  80227e:	83 ec 48             	sub    $0x48,%esp
  802281:	8b 45 10             	mov    0x10(%ebp),%eax
  802284:	88 45 c4             	mov    %al,-0x3c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  802287:	e8 2d f2 ff ff       	call   8014b9 <uheap_init>
	if (size == 0) return NULL;
  80228c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802290:	75 0a                	jne    80229c <smalloc+0x21>
  802292:	b8 00 00 00 00       	mov    $0x0,%eax
  802297:	e9 84 05 00 00       	jmp    802820 <smalloc+0x5a5>
	//==============================================================
	acquire_uspinlock(&ulock);
  80229c:	83 ec 0c             	sub    $0xc,%esp
  80229f:	68 40 d1 81 00       	push   $0x81d140
  8022a4:	e8 d8 1b 00 00       	call   803e81 <acquire_uspinlock>
  8022a9:	83 c4 10             	add    $0x10,%esp

	struct UserHeapStruct* allocblock = (struct UserHeapStruct*) alloc_block(sizeof(struct UserHeapStruct));
  8022ac:	83 ec 0c             	sub    $0xc,%esp
  8022af:	6a 10                	push   $0x10
  8022b1:	e8 63 13 00 00       	call   803619 <alloc_block>
  8022b6:	83 c4 10             	add    $0x10,%esp
  8022b9:	89 45 ec             	mov    %eax,-0x14(%ebp)
	if (allocblock == NULL){
  8022bc:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8022c0:	75 0a                	jne    8022cc <smalloc+0x51>
				return NULL;
  8022c2:	b8 00 00 00 00       	mov    $0x0,%eax
  8022c7:	e9 54 05 00 00       	jmp    802820 <smalloc+0x5a5>
	}
		size = ROUNDUP(size,PAGE_SIZE);
  8022cc:	c7 45 e8 00 10 00 00 	movl   $0x1000,-0x18(%ebp)
  8022d3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022d6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8022d9:	01 d0                	add    %edx,%eax
  8022db:	48                   	dec    %eax
  8022dc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8022df:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8022e2:	ba 00 00 00 00       	mov    $0x0,%edx
  8022e7:	f7 75 e8             	divl   -0x18(%ebp)
  8022ea:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8022ed:	29 d0                	sub    %edx,%eax
  8022ef:	89 45 0c             	mov    %eax,0xc(%ebp)
		struct UserHeapStruct* lastfreeelement = LIST_LAST(&u_freelist);
  8022f2:	a1 24 d1 81 00       	mov    0x81d124,%eax
  8022f7:	89 45 e0             	mov    %eax,-0x20(%ebp)

		if(LIST_SIZE(&u_freelist)==0 || size>lastfreeelement->size){
  8022fa:	a1 2c d1 81 00       	mov    0x81d12c,%eax
  8022ff:	85 c0                	test   %eax,%eax
  802301:	74 0f                	je     802312 <smalloc+0x97>
  802303:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802306:	8b 40 04             	mov    0x4(%eax),%eax
  802309:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80230c:	0f 83 25 01 00 00    	jae    802437 <smalloc+0x1bc>
				if(uheapPageAllocBreak <= USER_HEAP_MAX - size){
  802312:	b8 00 00 00 a0       	mov    $0xa0000000,%eax
  802317:	2b 45 0c             	sub    0xc(%ebp),%eax
  80231a:	89 c2                	mov    %eax,%edx
  80231c:	a1 68 d0 81 00       	mov    0x81d068,%eax
  802321:	39 c2                	cmp    %eax,%edx
  802323:	0f 82 f4 00 00 00    	jb     80241d <smalloc+0x1a2>
						uint32 requestedblockva = uheapPageAllocBreak;
  802329:	a1 68 d0 81 00       	mov    0x81d068,%eax
  80232e:	89 45 d4             	mov    %eax,-0x2c(%ebp)
						uheapPageAllocBreak+=size;
  802331:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  802337:	8b 45 0c             	mov    0xc(%ebp),%eax
  80233a:	01 d0                	add    %edx,%eax
  80233c:	a3 68 d0 81 00       	mov    %eax,0x81d068
						allocblock->startva = requestedblockva;
  802341:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802344:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802347:	89 10                	mov    %edx,(%eax)
						allocblock->size = size;
  802349:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80234c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80234f:	89 50 04             	mov    %edx,0x4(%eax)

						LIST_INSERT_TAIL(&u_allocatedlist, allocblock);
  802352:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802356:	75 17                	jne    80236f <smalloc+0xf4>
  802358:	83 ec 04             	sub    $0x4,%esp
  80235b:	68 38 4a 80 00       	push   $0x804a38
  802360:	68 57 01 00 00       	push   $0x157
  802365:	68 ec 49 80 00       	push   $0x8049ec
  80236a:	e8 97 df ff ff       	call   800306 <_panic>
  80236f:	8b 15 34 d1 81 00    	mov    0x81d134,%edx
  802375:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802378:	89 50 0c             	mov    %edx,0xc(%eax)
  80237b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80237e:	8b 40 0c             	mov    0xc(%eax),%eax
  802381:	85 c0                	test   %eax,%eax
  802383:	74 0d                	je     802392 <smalloc+0x117>
  802385:	a1 34 d1 81 00       	mov    0x81d134,%eax
  80238a:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80238d:	89 50 08             	mov    %edx,0x8(%eax)
  802390:	eb 08                	jmp    80239a <smalloc+0x11f>
  802392:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802395:	a3 30 d1 81 00       	mov    %eax,0x81d130
  80239a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80239d:	a3 34 d1 81 00       	mov    %eax,0x81d134
  8023a2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8023a5:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  8023ac:	a1 3c d1 81 00       	mov    0x81d13c,%eax
  8023b1:	40                   	inc    %eax
  8023b2:	a3 3c d1 81 00       	mov    %eax,0x81d13c


						int result = sys_create_shared_object(sharedVarName ,size ,isWritable ,(void*)allocblock->startva);
  8023b7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8023ba:	8b 00                	mov    (%eax),%eax
  8023bc:	89 c2                	mov    %eax,%edx
  8023be:	0f b6 45 c4          	movzbl -0x3c(%ebp),%eax
  8023c2:	52                   	push   %edx
  8023c3:	50                   	push   %eax
  8023c4:	ff 75 0c             	pushl  0xc(%ebp)
  8023c7:	ff 75 08             	pushl  0x8(%ebp)
  8023ca:	e8 48 0c 00 00       	call   803017 <sys_create_shared_object>
  8023cf:	83 c4 10             	add    $0x10,%esp
  8023d2:	89 45 d0             	mov    %eax,-0x30(%ebp)

						if(result <0){
  8023d5:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  8023d9:	79 28                	jns    802403 <smalloc+0x188>
							free_block(allocblock);
  8023db:	83 ec 0c             	sub    $0xc,%esp
  8023de:	ff 75 ec             	pushl  -0x14(%ebp)
  8023e1:	e8 cf 16 00 00       	call   803ab5 <free_block>
  8023e6:	83 c4 10             	add    $0x10,%esp
							release_uspinlock(&ulock);
  8023e9:	83 ec 0c             	sub    $0xc,%esp
  8023ec:	68 40 d1 81 00       	push   $0x81d140
  8023f1:	e8 e3 1a 00 00       	call   803ed9 <release_uspinlock>
  8023f6:	83 c4 10             	add    $0x10,%esp
							return NULL;
  8023f9:	b8 00 00 00 00       	mov    $0x0,%eax
  8023fe:	e9 1d 04 00 00       	jmp    802820 <smalloc+0x5a5>
						}
						release_uspinlock(&ulock);
  802403:	83 ec 0c             	sub    $0xc,%esp
  802406:	68 40 d1 81 00       	push   $0x81d140
  80240b:	e8 c9 1a 00 00       	call   803ed9 <release_uspinlock>
  802410:	83 c4 10             	add    $0x10,%esp
						return (void*)allocblock -> startva;
  802413:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802416:	8b 00                	mov    (%eax),%eax
  802418:	e9 03 04 00 00       	jmp    802820 <smalloc+0x5a5>
				}else{
						release_uspinlock(&ulock);
  80241d:	83 ec 0c             	sub    $0xc,%esp
  802420:	68 40 d1 81 00       	push   $0x81d140
  802425:	e8 af 1a 00 00       	call   803ed9 <release_uspinlock>
  80242a:	83 c4 10             	add    $0x10,%esp
						return NULL;
  80242d:	b8 00 00 00 00       	mov    $0x0,%eax
  802432:	e9 e9 03 00 00       	jmp    802820 <smalloc+0x5a5>
					 }
		}else{
			//custom fit
			struct UserHeapStruct* currentfreeelement = LIST_FIRST(&u_freelist);
  802437:	a1 20 d1 81 00       	mov    0x81d120,%eax
  80243c:	89 45 f4             	mov    %eax,-0xc(%ebp)
			//worst fit
			while(currentfreeelement != NULL){
  80243f:	e9 af 03 00 00       	jmp    8027f3 <smalloc+0x578>
				if(size<currentfreeelement->size){
  802444:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802447:	8b 40 04             	mov    0x4(%eax),%eax
  80244a:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80244d:	0f 86 28 02 00 00    	jbe    80267b <smalloc+0x400>
					allocblock->startva = lastfreeelement->startva;
  802453:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802456:	8b 10                	mov    (%eax),%edx
  802458:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80245b:	89 10                	mov    %edx,(%eax)
	                allocblock->size = size;
  80245d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802460:	8b 55 0c             	mov    0xc(%ebp),%edx
  802463:	89 50 04             	mov    %edx,0x4(%eax)
	                LIST_INSERT_TAIL(&u_allocatedlist,allocblock);
  802466:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80246a:	75 17                	jne    802483 <smalloc+0x208>
  80246c:	83 ec 04             	sub    $0x4,%esp
  80246f:	68 38 4a 80 00       	push   $0x804a38
  802474:	68 6f 01 00 00       	push   $0x16f
  802479:	68 ec 49 80 00       	push   $0x8049ec
  80247e:	e8 83 de ff ff       	call   800306 <_panic>
  802483:	8b 15 34 d1 81 00    	mov    0x81d134,%edx
  802489:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80248c:	89 50 0c             	mov    %edx,0xc(%eax)
  80248f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802492:	8b 40 0c             	mov    0xc(%eax),%eax
  802495:	85 c0                	test   %eax,%eax
  802497:	74 0d                	je     8024a6 <smalloc+0x22b>
  802499:	a1 34 d1 81 00       	mov    0x81d134,%eax
  80249e:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8024a1:	89 50 08             	mov    %edx,0x8(%eax)
  8024a4:	eb 08                	jmp    8024ae <smalloc+0x233>
  8024a6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8024a9:	a3 30 d1 81 00       	mov    %eax,0x81d130
  8024ae:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8024b1:	a3 34 d1 81 00       	mov    %eax,0x81d134
  8024b6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8024b9:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  8024c0:	a1 3c d1 81 00       	mov    0x81d13c,%eax
  8024c5:	40                   	inc    %eax
  8024c6:	a3 3c d1 81 00       	mov    %eax,0x81d13c
	                lastfreeelement->startva += size;
  8024cb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8024ce:	8b 10                	mov    (%eax),%edx
  8024d0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8024d3:	01 c2                	add    %eax,%edx
  8024d5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8024d8:	89 10                	mov    %edx,(%eax)
	                lastfreeelement->size -= size;
  8024da:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8024dd:	8b 40 04             	mov    0x4(%eax),%eax
  8024e0:	2b 45 0c             	sub    0xc(%ebp),%eax
  8024e3:	89 c2                	mov    %eax,%edx
  8024e5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8024e8:	89 50 04             	mov    %edx,0x4(%eax)
	                struct UserHeapStruct* currentfree2 = LIST_FIRST(&u_freelist);
  8024eb:	a1 20 d1 81 00       	mov    0x81d120,%eax
  8024f0:	89 45 f0             	mov    %eax,-0x10(%ebp)
	                //check order of last element

	                while (currentfree2 != NULL){
  8024f3:	e9 13 01 00 00       	jmp    80260b <smalloc+0x390>
	                	if(lastfreeelement->size <currentfree2->size){
  8024f8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8024fb:	8b 50 04             	mov    0x4(%eax),%edx
  8024fe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802501:	8b 40 04             	mov    0x4(%eax),%eax
  802504:	39 c2                	cmp    %eax,%edx
  802506:	0f 83 f6 00 00 00    	jae    802602 <smalloc+0x387>
	                		LIST_REMOVE(&u_freelist ,lastfreeelement);
  80250c:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802510:	75 17                	jne    802529 <smalloc+0x2ae>
  802512:	83 ec 04             	sub    $0x4,%esp
  802515:	68 5b 4a 80 00       	push   $0x804a5b
  80251a:	68 77 01 00 00       	push   $0x177
  80251f:	68 ec 49 80 00       	push   $0x8049ec
  802524:	e8 dd dd ff ff       	call   800306 <_panic>
  802529:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80252c:	8b 40 08             	mov    0x8(%eax),%eax
  80252f:	85 c0                	test   %eax,%eax
  802531:	74 11                	je     802544 <smalloc+0x2c9>
  802533:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802536:	8b 40 08             	mov    0x8(%eax),%eax
  802539:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80253c:	8b 52 0c             	mov    0xc(%edx),%edx
  80253f:	89 50 0c             	mov    %edx,0xc(%eax)
  802542:	eb 0b                	jmp    80254f <smalloc+0x2d4>
  802544:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802547:	8b 40 0c             	mov    0xc(%eax),%eax
  80254a:	a3 24 d1 81 00       	mov    %eax,0x81d124
  80254f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802552:	8b 40 0c             	mov    0xc(%eax),%eax
  802555:	85 c0                	test   %eax,%eax
  802557:	74 11                	je     80256a <smalloc+0x2ef>
  802559:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80255c:	8b 40 0c             	mov    0xc(%eax),%eax
  80255f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802562:	8b 52 08             	mov    0x8(%edx),%edx
  802565:	89 50 08             	mov    %edx,0x8(%eax)
  802568:	eb 0b                	jmp    802575 <smalloc+0x2fa>
  80256a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80256d:	8b 40 08             	mov    0x8(%eax),%eax
  802570:	a3 20 d1 81 00       	mov    %eax,0x81d120
  802575:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802578:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  80257f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802582:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  802589:	a1 2c d1 81 00       	mov    0x81d12c,%eax
  80258e:	48                   	dec    %eax
  80258f:	a3 2c d1 81 00       	mov    %eax,0x81d12c
	                		LIST_INSERT_BEFORE(&u_freelist ,currentfree2 ,lastfreeelement);
  802594:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802598:	74 06                	je     8025a0 <smalloc+0x325>
  80259a:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80259e:	75 17                	jne    8025b7 <smalloc+0x33c>
  8025a0:	83 ec 04             	sub    $0x4,%esp
  8025a3:	68 7c 4a 80 00       	push   $0x804a7c
  8025a8:	68 78 01 00 00       	push   $0x178
  8025ad:	68 ec 49 80 00       	push   $0x8049ec
  8025b2:	e8 4f dd ff ff       	call   800306 <_panic>
  8025b7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025ba:	8b 50 0c             	mov    0xc(%eax),%edx
  8025bd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8025c0:	89 50 0c             	mov    %edx,0xc(%eax)
  8025c3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8025c6:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8025c9:	89 50 08             	mov    %edx,0x8(%eax)
  8025cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025cf:	8b 40 0c             	mov    0xc(%eax),%eax
  8025d2:	85 c0                	test   %eax,%eax
  8025d4:	74 0e                	je     8025e4 <smalloc+0x369>
  8025d6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025d9:	8b 40 0c             	mov    0xc(%eax),%eax
  8025dc:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8025df:	89 50 08             	mov    %edx,0x8(%eax)
  8025e2:	eb 08                	jmp    8025ec <smalloc+0x371>
  8025e4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8025e7:	a3 20 d1 81 00       	mov    %eax,0x81d120
  8025ec:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025ef:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8025f2:	89 50 0c             	mov    %edx,0xc(%eax)
  8025f5:	a1 2c d1 81 00       	mov    0x81d12c,%eax
  8025fa:	40                   	inc    %eax
  8025fb:	a3 2c d1 81 00       	mov    %eax,0x81d12c
	                		break;
  802600:	eb 13                	jmp    802615 <smalloc+0x39a>
	                	}
	                	currentfree2 = currentfree2->prev_next_info.le_next;
  802602:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802605:	8b 40 08             	mov    0x8(%eax),%eax
  802608:	89 45 f0             	mov    %eax,-0x10(%ebp)
	                lastfreeelement->startva += size;
	                lastfreeelement->size -= size;
	                struct UserHeapStruct* currentfree2 = LIST_FIRST(&u_freelist);
	                //check order of last element

	                while (currentfree2 != NULL){
  80260b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80260f:	0f 85 e3 fe ff ff    	jne    8024f8 <smalloc+0x27d>
	                	}
	                	currentfree2 = currentfree2->prev_next_info.le_next;
	                }


	                int result = sys_create_shared_object(sharedVarName ,size ,isWritable ,(void*)allocblock->startva);
  802615:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802618:	8b 00                	mov    (%eax),%eax
  80261a:	89 c2                	mov    %eax,%edx
  80261c:	0f b6 45 c4          	movzbl -0x3c(%ebp),%eax
  802620:	52                   	push   %edx
  802621:	50                   	push   %eax
  802622:	ff 75 0c             	pushl  0xc(%ebp)
  802625:	ff 75 08             	pushl  0x8(%ebp)
  802628:	e8 ea 09 00 00       	call   803017 <sys_create_shared_object>
  80262d:	83 c4 10             	add    $0x10,%esp
  802630:	89 45 d8             	mov    %eax,-0x28(%ebp)

	                if(result <0){
  802633:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  802637:	79 28                	jns    802661 <smalloc+0x3e6>
	                	free_block(allocblock);
  802639:	83 ec 0c             	sub    $0xc,%esp
  80263c:	ff 75 ec             	pushl  -0x14(%ebp)
  80263f:	e8 71 14 00 00       	call   803ab5 <free_block>
  802644:	83 c4 10             	add    $0x10,%esp
	                	release_uspinlock(&ulock);
  802647:	83 ec 0c             	sub    $0xc,%esp
  80264a:	68 40 d1 81 00       	push   $0x81d140
  80264f:	e8 85 18 00 00       	call   803ed9 <release_uspinlock>
  802654:	83 c4 10             	add    $0x10,%esp
	                	return NULL;
  802657:	b8 00 00 00 00       	mov    $0x0,%eax
  80265c:	e9 bf 01 00 00       	jmp    802820 <smalloc+0x5a5>
	                }
	                release_uspinlock(&ulock);
  802661:	83 ec 0c             	sub    $0xc,%esp
  802664:	68 40 d1 81 00       	push   $0x81d140
  802669:	e8 6b 18 00 00       	call   803ed9 <release_uspinlock>
  80266e:	83 c4 10             	add    $0x10,%esp
	                return (void*)allocblock->startva;
  802671:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802674:	8b 00                	mov    (%eax),%eax
  802676:	e9 a5 01 00 00       	jmp    802820 <smalloc+0x5a5>
	                //exact fit
				}else if(size == currentfreeelement->size){
  80267b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80267e:	8b 40 04             	mov    0x4(%eax),%eax
  802681:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802684:	0f 85 60 01 00 00    	jne    8027ea <smalloc+0x56f>
					allocblock->startva = currentfreeelement->startva;
  80268a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80268d:	8b 10                	mov    (%eax),%edx
  80268f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802692:	89 10                	mov    %edx,(%eax)
					allocblock->size = size;
  802694:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802697:	8b 55 0c             	mov    0xc(%ebp),%edx
  80269a:	89 50 04             	mov    %edx,0x4(%eax)
					LIST_INSERT_TAIL(&u_allocatedlist ,allocblock);
  80269d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8026a1:	75 17                	jne    8026ba <smalloc+0x43f>
  8026a3:	83 ec 04             	sub    $0x4,%esp
  8026a6:	68 38 4a 80 00       	push   $0x804a38
  8026ab:	68 8c 01 00 00       	push   $0x18c
  8026b0:	68 ec 49 80 00       	push   $0x8049ec
  8026b5:	e8 4c dc ff ff       	call   800306 <_panic>
  8026ba:	8b 15 34 d1 81 00    	mov    0x81d134,%edx
  8026c0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026c3:	89 50 0c             	mov    %edx,0xc(%eax)
  8026c6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026c9:	8b 40 0c             	mov    0xc(%eax),%eax
  8026cc:	85 c0                	test   %eax,%eax
  8026ce:	74 0d                	je     8026dd <smalloc+0x462>
  8026d0:	a1 34 d1 81 00       	mov    0x81d134,%eax
  8026d5:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8026d8:	89 50 08             	mov    %edx,0x8(%eax)
  8026db:	eb 08                	jmp    8026e5 <smalloc+0x46a>
  8026dd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026e0:	a3 30 d1 81 00       	mov    %eax,0x81d130
  8026e5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026e8:	a3 34 d1 81 00       	mov    %eax,0x81d134
  8026ed:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026f0:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  8026f7:	a1 3c d1 81 00       	mov    0x81d13c,%eax
  8026fc:	40                   	inc    %eax
  8026fd:	a3 3c d1 81 00       	mov    %eax,0x81d13c
					LIST_REMOVE(&u_freelist ,currentfreeelement);
  802702:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802706:	75 17                	jne    80271f <smalloc+0x4a4>
  802708:	83 ec 04             	sub    $0x4,%esp
  80270b:	68 5b 4a 80 00       	push   $0x804a5b
  802710:	68 8d 01 00 00       	push   $0x18d
  802715:	68 ec 49 80 00       	push   $0x8049ec
  80271a:	e8 e7 db ff ff       	call   800306 <_panic>
  80271f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802722:	8b 40 08             	mov    0x8(%eax),%eax
  802725:	85 c0                	test   %eax,%eax
  802727:	74 11                	je     80273a <smalloc+0x4bf>
  802729:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80272c:	8b 40 08             	mov    0x8(%eax),%eax
  80272f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802732:	8b 52 0c             	mov    0xc(%edx),%edx
  802735:	89 50 0c             	mov    %edx,0xc(%eax)
  802738:	eb 0b                	jmp    802745 <smalloc+0x4ca>
  80273a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80273d:	8b 40 0c             	mov    0xc(%eax),%eax
  802740:	a3 24 d1 81 00       	mov    %eax,0x81d124
  802745:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802748:	8b 40 0c             	mov    0xc(%eax),%eax
  80274b:	85 c0                	test   %eax,%eax
  80274d:	74 11                	je     802760 <smalloc+0x4e5>
  80274f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802752:	8b 40 0c             	mov    0xc(%eax),%eax
  802755:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802758:	8b 52 08             	mov    0x8(%edx),%edx
  80275b:	89 50 08             	mov    %edx,0x8(%eax)
  80275e:	eb 0b                	jmp    80276b <smalloc+0x4f0>
  802760:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802763:	8b 40 08             	mov    0x8(%eax),%eax
  802766:	a3 20 d1 81 00       	mov    %eax,0x81d120
  80276b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80276e:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802775:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802778:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  80277f:	a1 2c d1 81 00       	mov    0x81d12c,%eax
  802784:	48                   	dec    %eax
  802785:	a3 2c d1 81 00       	mov    %eax,0x81d12c
					int result = sys_create_shared_object(sharedVarName ,size ,isWritable ,(void*)allocblock->startva);
  80278a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80278d:	8b 00                	mov    (%eax),%eax
  80278f:	89 c2                	mov    %eax,%edx
  802791:	0f b6 45 c4          	movzbl -0x3c(%ebp),%eax
  802795:	52                   	push   %edx
  802796:	50                   	push   %eax
  802797:	ff 75 0c             	pushl  0xc(%ebp)
  80279a:	ff 75 08             	pushl  0x8(%ebp)
  80279d:	e8 75 08 00 00       	call   803017 <sys_create_shared_object>
  8027a2:	83 c4 10             	add    $0x10,%esp
  8027a5:	89 45 dc             	mov    %eax,-0x24(%ebp)

					if(result <0){
  8027a8:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8027ac:	79 25                	jns    8027d3 <smalloc+0x558>
						free_block(allocblock);
  8027ae:	83 ec 0c             	sub    $0xc,%esp
  8027b1:	ff 75 ec             	pushl  -0x14(%ebp)
  8027b4:	e8 fc 12 00 00       	call   803ab5 <free_block>
  8027b9:	83 c4 10             	add    $0x10,%esp
						release_uspinlock(&ulock);
  8027bc:	83 ec 0c             	sub    $0xc,%esp
  8027bf:	68 40 d1 81 00       	push   $0x81d140
  8027c4:	e8 10 17 00 00       	call   803ed9 <release_uspinlock>
  8027c9:	83 c4 10             	add    $0x10,%esp
						return NULL;
  8027cc:	b8 00 00 00 00       	mov    $0x0,%eax
  8027d1:	eb 4d                	jmp    802820 <smalloc+0x5a5>
					}
					release_uspinlock(&ulock);
  8027d3:	83 ec 0c             	sub    $0xc,%esp
  8027d6:	68 40 d1 81 00       	push   $0x81d140
  8027db:	e8 f9 16 00 00       	call   803ed9 <release_uspinlock>
  8027e0:	83 c4 10             	add    $0x10,%esp
					return (void*)allocblock->startva;
  8027e3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027e6:	8b 00                	mov    (%eax),%eax
  8027e8:	eb 36                	jmp    802820 <smalloc+0x5a5>
				}
				currentfreeelement = currentfreeelement->prev_next_info.le_next;
  8027ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027ed:	8b 40 08             	mov    0x8(%eax),%eax
  8027f0:	89 45 f4             	mov    %eax,-0xc(%ebp)
					 }
		}else{
			//custom fit
			struct UserHeapStruct* currentfreeelement = LIST_FIRST(&u_freelist);
			//worst fit
			while(currentfreeelement != NULL){
  8027f3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027f7:	0f 85 47 fc ff ff    	jne    802444 <smalloc+0x1c9>
					return (void*)allocblock->startva;
				}
				currentfreeelement = currentfreeelement->prev_next_info.le_next;
			}
		}
		free_block(allocblock);
  8027fd:	83 ec 0c             	sub    $0xc,%esp
  802800:	ff 75 ec             	pushl  -0x14(%ebp)
  802803:	e8 ad 12 00 00       	call   803ab5 <free_block>
  802808:	83 c4 10             	add    $0x10,%esp
		release_uspinlock(&ulock);
  80280b:	83 ec 0c             	sub    $0xc,%esp
  80280e:	68 40 d1 81 00       	push   $0x81d140
  802813:	e8 c1 16 00 00       	call   803ed9 <release_uspinlock>
  802818:	83 c4 10             	add    $0x10,%esp
		return NULL;
  80281b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802820:	c9                   	leave  
  802821:	c3                   	ret    

00802822 <sget>:

//========================================
// [4] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  802822:	55                   	push   %ebp
  802823:	89 e5                	mov    %esp,%ebp
  802825:	83 ec 38             	sub    $0x38,%esp


	 //==============================================================
	 // DON'T CHANGE THIS CODE
	    uheap_init();
  802828:	e8 8c ec ff ff       	call   8014b9 <uheap_init>
	 //==============================================================
	 // Get size of the shared variable from kernel
	acquire_uspinlock(&ulock);
  80282d:	83 ec 0c             	sub    $0xc,%esp
  802830:	68 40 d1 81 00       	push   $0x81d140
  802835:	e8 47 16 00 00       	call   803e81 <acquire_uspinlock>
  80283a:	83 c4 10             	add    $0x10,%esp


	int size = sys_size_of_shared_object(ownerEnvID ,sharedVarName);
  80283d:	83 ec 08             	sub    $0x8,%esp
  802840:	ff 75 0c             	pushl  0xc(%ebp)
  802843:	ff 75 08             	pushl  0x8(%ebp)
  802846:	e8 f6 07 00 00       	call   803041 <sys_size_of_shared_object>
  80284b:	83 c4 10             	add    $0x10,%esp
  80284e:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if ( size < 0 ){
  802851:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802855:	79 1a                	jns    802871 <sget+0x4f>
			release_uspinlock(&ulock);
  802857:	83 ec 0c             	sub    $0xc,%esp
  80285a:	68 40 d1 81 00       	push   $0x81d140
  80285f:	e8 75 16 00 00       	call   803ed9 <release_uspinlock>
  802864:	83 c4 10             	add    $0x10,%esp
			return NULL;
  802867:	b8 00 00 00 00       	mov    $0x0,%eax
  80286c:	e9 6e 05 00 00       	jmp    802ddf <sget+0x5bd>
		}
		size = ROUNDUP(size,PAGE_SIZE);
  802871:	c7 45 e8 00 10 00 00 	movl   $0x1000,-0x18(%ebp)
  802878:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80287b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80287e:	01 d0                	add    %edx,%eax
  802880:	48                   	dec    %eax
  802881:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  802884:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802887:	ba 00 00 00 00       	mov    $0x0,%edx
  80288c:	f7 75 e8             	divl   -0x18(%ebp)
  80288f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802892:	29 d0                	sub    %edx,%eax
  802894:	89 45 ec             	mov    %eax,-0x14(%ebp)

		struct UserHeapStruct* allocblock = (struct UserHeapStruct*) alloc_block(sizeof(struct UserHeapStruct));
  802897:	83 ec 0c             	sub    $0xc,%esp
  80289a:	6a 10                	push   $0x10
  80289c:	e8 78 0d 00 00       	call   803619 <alloc_block>
  8028a1:	83 c4 10             	add    $0x10,%esp
  8028a4:	89 45 e0             	mov    %eax,-0x20(%ebp)

		if (allocblock == NULL){
  8028a7:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8028ab:	75 0a                	jne    8028b7 <sget+0x95>
			return NULL;
  8028ad:	b8 00 00 00 00       	mov    $0x0,%eax
  8028b2:	e9 28 05 00 00       	jmp    802ddf <sget+0x5bd>
		}
		struct UserHeapStruct* lastfreeelement = LIST_LAST(&u_freelist);
  8028b7:	a1 24 d1 81 00       	mov    0x81d124,%eax
  8028bc:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if(LIST_SIZE(&u_freelist)==0 || size>lastfreeelement->size){
  8028bf:	a1 2c d1 81 00       	mov    0x81d12c,%eax
  8028c4:	85 c0                	test   %eax,%eax
  8028c6:	74 11                	je     8028d9 <sget+0xb7>
  8028c8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8028cb:	8b 50 04             	mov    0x4(%eax),%edx
  8028ce:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028d1:	39 c2                	cmp    %eax,%edx
  8028d3:	0f 83 21 01 00 00    	jae    8029fa <sget+0x1d8>
				if(uheapPageAllocBreak <= USER_HEAP_MAX - size){
  8028d9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028dc:	ba 00 00 00 a0       	mov    $0xa0000000,%edx
  8028e1:	29 c2                	sub    %eax,%edx
  8028e3:	a1 68 d0 81 00       	mov    0x81d068,%eax
  8028e8:	39 c2                	cmp    %eax,%edx
  8028ea:	0f 82 f0 00 00 00    	jb     8029e0 <sget+0x1be>

						uint32 requestedblockva = uheapPageAllocBreak;
  8028f0:	a1 68 d0 81 00       	mov    0x81d068,%eax
  8028f5:	89 45 d0             	mov    %eax,-0x30(%ebp)
						uheapPageAllocBreak+=size;
  8028f8:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  8028fe:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802901:	01 d0                	add    %edx,%eax
  802903:	a3 68 d0 81 00       	mov    %eax,0x81d068
						allocblock->startva = requestedblockva;
  802908:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80290b:	8b 55 d0             	mov    -0x30(%ebp),%edx
  80290e:	89 10                	mov    %edx,(%eax)
						allocblock->size = size;
  802910:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802913:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802916:	89 50 04             	mov    %edx,0x4(%eax)

						LIST_INSERT_TAIL(&u_allocatedlist, allocblock);
  802919:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80291d:	75 17                	jne    802936 <sget+0x114>
  80291f:	83 ec 04             	sub    $0x4,%esp
  802922:	68 38 4a 80 00       	push   $0x804a38
  802927:	68 c8 01 00 00       	push   $0x1c8
  80292c:	68 ec 49 80 00       	push   $0x8049ec
  802931:	e8 d0 d9 ff ff       	call   800306 <_panic>
  802936:	8b 15 34 d1 81 00    	mov    0x81d134,%edx
  80293c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80293f:	89 50 0c             	mov    %edx,0xc(%eax)
  802942:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802945:	8b 40 0c             	mov    0xc(%eax),%eax
  802948:	85 c0                	test   %eax,%eax
  80294a:	74 0d                	je     802959 <sget+0x137>
  80294c:	a1 34 d1 81 00       	mov    0x81d134,%eax
  802951:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802954:	89 50 08             	mov    %edx,0x8(%eax)
  802957:	eb 08                	jmp    802961 <sget+0x13f>
  802959:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80295c:	a3 30 d1 81 00       	mov    %eax,0x81d130
  802961:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802964:	a3 34 d1 81 00       	mov    %eax,0x81d134
  802969:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80296c:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802973:	a1 3c d1 81 00       	mov    0x81d13c,%eax
  802978:	40                   	inc    %eax
  802979:	a3 3c d1 81 00       	mov    %eax,0x81d13c


						int result = sys_get_shared_object(ownerEnvID ,sharedVarName ,(void*)allocblock->startva);
  80297e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802981:	8b 00                	mov    (%eax),%eax
  802983:	83 ec 04             	sub    $0x4,%esp
  802986:	50                   	push   %eax
  802987:	ff 75 0c             	pushl  0xc(%ebp)
  80298a:	ff 75 08             	pushl  0x8(%ebp)
  80298d:	e8 cc 06 00 00       	call   80305e <sys_get_shared_object>
  802992:	83 c4 10             	add    $0x10,%esp
  802995:	89 45 cc             	mov    %eax,-0x34(%ebp)

						if(result <0){
  802998:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  80299c:	79 28                	jns    8029c6 <sget+0x1a4>
							free_block(allocblock);
  80299e:	83 ec 0c             	sub    $0xc,%esp
  8029a1:	ff 75 e0             	pushl  -0x20(%ebp)
  8029a4:	e8 0c 11 00 00       	call   803ab5 <free_block>
  8029a9:	83 c4 10             	add    $0x10,%esp
							release_uspinlock(&ulock);
  8029ac:	83 ec 0c             	sub    $0xc,%esp
  8029af:	68 40 d1 81 00       	push   $0x81d140
  8029b4:	e8 20 15 00 00       	call   803ed9 <release_uspinlock>
  8029b9:	83 c4 10             	add    $0x10,%esp
							return NULL;
  8029bc:	b8 00 00 00 00       	mov    $0x0,%eax
  8029c1:	e9 19 04 00 00       	jmp    802ddf <sget+0x5bd>
						}
						release_uspinlock(&ulock);
  8029c6:	83 ec 0c             	sub    $0xc,%esp
  8029c9:	68 40 d1 81 00       	push   $0x81d140
  8029ce:	e8 06 15 00 00       	call   803ed9 <release_uspinlock>
  8029d3:	83 c4 10             	add    $0x10,%esp
						return (void*)allocblock -> startva;
  8029d6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8029d9:	8b 00                	mov    (%eax),%eax
  8029db:	e9 ff 03 00 00       	jmp    802ddf <sget+0x5bd>
				}else{
						release_uspinlock(&ulock);
  8029e0:	83 ec 0c             	sub    $0xc,%esp
  8029e3:	68 40 d1 81 00       	push   $0x81d140
  8029e8:	e8 ec 14 00 00       	call   803ed9 <release_uspinlock>
  8029ed:	83 c4 10             	add    $0x10,%esp
						return NULL;
  8029f0:	b8 00 00 00 00       	mov    $0x0,%eax
  8029f5:	e9 e5 03 00 00       	jmp    802ddf <sget+0x5bd>
					 }
		}else{
			//custom fit
			struct UserHeapStruct* currentfreeelement = LIST_FIRST(&u_freelist);
  8029fa:	a1 20 d1 81 00       	mov    0x81d120,%eax
  8029ff:	89 45 f4             	mov    %eax,-0xc(%ebp)
			//worst fit
			while(currentfreeelement != NULL){
  802a02:	e9 ab 03 00 00       	jmp    802db2 <sget+0x590>
				if(size<currentfreeelement->size){
  802a07:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a0a:	8b 50 04             	mov    0x4(%eax),%edx
  802a0d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a10:	39 c2                	cmp    %eax,%edx
  802a12:	0f 86 24 02 00 00    	jbe    802c3c <sget+0x41a>
					allocblock->startva = lastfreeelement->startva;
  802a18:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802a1b:	8b 10                	mov    (%eax),%edx
  802a1d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802a20:	89 10                	mov    %edx,(%eax)
					allocblock->size = size;
  802a22:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802a25:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802a28:	89 50 04             	mov    %edx,0x4(%eax)
					LIST_INSERT_TAIL(&u_allocatedlist,allocblock);
  802a2b:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802a2f:	75 17                	jne    802a48 <sget+0x226>
  802a31:	83 ec 04             	sub    $0x4,%esp
  802a34:	68 38 4a 80 00       	push   $0x804a38
  802a39:	68 e0 01 00 00       	push   $0x1e0
  802a3e:	68 ec 49 80 00       	push   $0x8049ec
  802a43:	e8 be d8 ff ff       	call   800306 <_panic>
  802a48:	8b 15 34 d1 81 00    	mov    0x81d134,%edx
  802a4e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802a51:	89 50 0c             	mov    %edx,0xc(%eax)
  802a54:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802a57:	8b 40 0c             	mov    0xc(%eax),%eax
  802a5a:	85 c0                	test   %eax,%eax
  802a5c:	74 0d                	je     802a6b <sget+0x249>
  802a5e:	a1 34 d1 81 00       	mov    0x81d134,%eax
  802a63:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802a66:	89 50 08             	mov    %edx,0x8(%eax)
  802a69:	eb 08                	jmp    802a73 <sget+0x251>
  802a6b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802a6e:	a3 30 d1 81 00       	mov    %eax,0x81d130
  802a73:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802a76:	a3 34 d1 81 00       	mov    %eax,0x81d134
  802a7b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802a7e:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802a85:	a1 3c d1 81 00       	mov    0x81d13c,%eax
  802a8a:	40                   	inc    %eax
  802a8b:	a3 3c d1 81 00       	mov    %eax,0x81d13c
					lastfreeelement->startva += size;
  802a90:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802a93:	8b 10                	mov    (%eax),%edx
  802a95:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a98:	01 c2                	add    %eax,%edx
  802a9a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802a9d:	89 10                	mov    %edx,(%eax)
					lastfreeelement->size -= size;
  802a9f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802aa2:	8b 50 04             	mov    0x4(%eax),%edx
  802aa5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802aa8:	29 c2                	sub    %eax,%edx
  802aaa:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802aad:	89 50 04             	mov    %edx,0x4(%eax)
					struct UserHeapStruct* currentfree2 = LIST_FIRST(&u_freelist);
  802ab0:	a1 20 d1 81 00       	mov    0x81d120,%eax
  802ab5:	89 45 f0             	mov    %eax,-0x10(%ebp)
					//check order of last element

					while (currentfree2 != NULL){
  802ab8:	e9 13 01 00 00       	jmp    802bd0 <sget+0x3ae>
						if(lastfreeelement->size <currentfree2->size){
  802abd:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802ac0:	8b 50 04             	mov    0x4(%eax),%edx
  802ac3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ac6:	8b 40 04             	mov    0x4(%eax),%eax
  802ac9:	39 c2                	cmp    %eax,%edx
  802acb:	0f 83 f6 00 00 00    	jae    802bc7 <sget+0x3a5>
							LIST_REMOVE(&u_freelist ,lastfreeelement);
  802ad1:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802ad5:	75 17                	jne    802aee <sget+0x2cc>
  802ad7:	83 ec 04             	sub    $0x4,%esp
  802ada:	68 5b 4a 80 00       	push   $0x804a5b
  802adf:	68 e8 01 00 00       	push   $0x1e8
  802ae4:	68 ec 49 80 00       	push   $0x8049ec
  802ae9:	e8 18 d8 ff ff       	call   800306 <_panic>
  802aee:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802af1:	8b 40 08             	mov    0x8(%eax),%eax
  802af4:	85 c0                	test   %eax,%eax
  802af6:	74 11                	je     802b09 <sget+0x2e7>
  802af8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802afb:	8b 40 08             	mov    0x8(%eax),%eax
  802afe:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802b01:	8b 52 0c             	mov    0xc(%edx),%edx
  802b04:	89 50 0c             	mov    %edx,0xc(%eax)
  802b07:	eb 0b                	jmp    802b14 <sget+0x2f2>
  802b09:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802b0c:	8b 40 0c             	mov    0xc(%eax),%eax
  802b0f:	a3 24 d1 81 00       	mov    %eax,0x81d124
  802b14:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802b17:	8b 40 0c             	mov    0xc(%eax),%eax
  802b1a:	85 c0                	test   %eax,%eax
  802b1c:	74 11                	je     802b2f <sget+0x30d>
  802b1e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802b21:	8b 40 0c             	mov    0xc(%eax),%eax
  802b24:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802b27:	8b 52 08             	mov    0x8(%edx),%edx
  802b2a:	89 50 08             	mov    %edx,0x8(%eax)
  802b2d:	eb 0b                	jmp    802b3a <sget+0x318>
  802b2f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802b32:	8b 40 08             	mov    0x8(%eax),%eax
  802b35:	a3 20 d1 81 00       	mov    %eax,0x81d120
  802b3a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802b3d:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802b44:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802b47:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  802b4e:	a1 2c d1 81 00       	mov    0x81d12c,%eax
  802b53:	48                   	dec    %eax
  802b54:	a3 2c d1 81 00       	mov    %eax,0x81d12c
							LIST_INSERT_BEFORE(&u_freelist ,currentfree2 ,lastfreeelement);
  802b59:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802b5d:	74 06                	je     802b65 <sget+0x343>
  802b5f:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802b63:	75 17                	jne    802b7c <sget+0x35a>
  802b65:	83 ec 04             	sub    $0x4,%esp
  802b68:	68 7c 4a 80 00       	push   $0x804a7c
  802b6d:	68 e9 01 00 00       	push   $0x1e9
  802b72:	68 ec 49 80 00       	push   $0x8049ec
  802b77:	e8 8a d7 ff ff       	call   800306 <_panic>
  802b7c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b7f:	8b 50 0c             	mov    0xc(%eax),%edx
  802b82:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802b85:	89 50 0c             	mov    %edx,0xc(%eax)
  802b88:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802b8b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802b8e:	89 50 08             	mov    %edx,0x8(%eax)
  802b91:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b94:	8b 40 0c             	mov    0xc(%eax),%eax
  802b97:	85 c0                	test   %eax,%eax
  802b99:	74 0e                	je     802ba9 <sget+0x387>
  802b9b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b9e:	8b 40 0c             	mov    0xc(%eax),%eax
  802ba1:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802ba4:	89 50 08             	mov    %edx,0x8(%eax)
  802ba7:	eb 08                	jmp    802bb1 <sget+0x38f>
  802ba9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802bac:	a3 20 d1 81 00       	mov    %eax,0x81d120
  802bb1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bb4:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802bb7:	89 50 0c             	mov    %edx,0xc(%eax)
  802bba:	a1 2c d1 81 00       	mov    0x81d12c,%eax
  802bbf:	40                   	inc    %eax
  802bc0:	a3 2c d1 81 00       	mov    %eax,0x81d12c
							break;
  802bc5:	eb 13                	jmp    802bda <sget+0x3b8>
						}
						currentfree2 = currentfree2->prev_next_info.le_next;
  802bc7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bca:	8b 40 08             	mov    0x8(%eax),%eax
  802bcd:	89 45 f0             	mov    %eax,-0x10(%ebp)
					lastfreeelement->startva += size;
					lastfreeelement->size -= size;
					struct UserHeapStruct* currentfree2 = LIST_FIRST(&u_freelist);
					//check order of last element

					while (currentfree2 != NULL){
  802bd0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802bd4:	0f 85 e3 fe ff ff    	jne    802abd <sget+0x29b>
						}
						currentfree2 = currentfree2->prev_next_info.le_next;
					}


					int result = sys_get_shared_object(ownerEnvID ,sharedVarName ,(void*)allocblock->startva);
  802bda:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802bdd:	8b 00                	mov    (%eax),%eax
  802bdf:	83 ec 04             	sub    $0x4,%esp
  802be2:	50                   	push   %eax
  802be3:	ff 75 0c             	pushl  0xc(%ebp)
  802be6:	ff 75 08             	pushl  0x8(%ebp)
  802be9:	e8 70 04 00 00       	call   80305e <sys_get_shared_object>
  802bee:	83 c4 10             	add    $0x10,%esp
  802bf1:	89 45 d4             	mov    %eax,-0x2c(%ebp)

					if(result <0){
  802bf4:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  802bf8:	79 28                	jns    802c22 <sget+0x400>
						free_block(allocblock);
  802bfa:	83 ec 0c             	sub    $0xc,%esp
  802bfd:	ff 75 e0             	pushl  -0x20(%ebp)
  802c00:	e8 b0 0e 00 00       	call   803ab5 <free_block>
  802c05:	83 c4 10             	add    $0x10,%esp
						release_uspinlock(&ulock);
  802c08:	83 ec 0c             	sub    $0xc,%esp
  802c0b:	68 40 d1 81 00       	push   $0x81d140
  802c10:	e8 c4 12 00 00       	call   803ed9 <release_uspinlock>
  802c15:	83 c4 10             	add    $0x10,%esp
						return NULL;
  802c18:	b8 00 00 00 00       	mov    $0x0,%eax
  802c1d:	e9 bd 01 00 00       	jmp    802ddf <sget+0x5bd>
					}
					release_uspinlock(&ulock);
  802c22:	83 ec 0c             	sub    $0xc,%esp
  802c25:	68 40 d1 81 00       	push   $0x81d140
  802c2a:	e8 aa 12 00 00       	call   803ed9 <release_uspinlock>
  802c2f:	83 c4 10             	add    $0x10,%esp
					return (void*)allocblock->startva;
  802c32:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802c35:	8b 00                	mov    (%eax),%eax
  802c37:	e9 a3 01 00 00       	jmp    802ddf <sget+0x5bd>
					//exact fit
				}else if(size == currentfreeelement->size){
  802c3c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c3f:	8b 50 04             	mov    0x4(%eax),%edx
  802c42:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c45:	39 c2                	cmp    %eax,%edx
  802c47:	0f 85 5c 01 00 00    	jne    802da9 <sget+0x587>

					allocblock->startva = currentfreeelement->startva;
  802c4d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c50:	8b 10                	mov    (%eax),%edx
  802c52:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802c55:	89 10                	mov    %edx,(%eax)
					allocblock->size = size;
  802c57:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802c5a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802c5d:	89 50 04             	mov    %edx,0x4(%eax)
					LIST_INSERT_TAIL(&u_allocatedlist ,allocblock);
  802c60:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802c64:	75 17                	jne    802c7d <sget+0x45b>
  802c66:	83 ec 04             	sub    $0x4,%esp
  802c69:	68 38 4a 80 00       	push   $0x804a38
  802c6e:	68 fe 01 00 00       	push   $0x1fe
  802c73:	68 ec 49 80 00       	push   $0x8049ec
  802c78:	e8 89 d6 ff ff       	call   800306 <_panic>
  802c7d:	8b 15 34 d1 81 00    	mov    0x81d134,%edx
  802c83:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802c86:	89 50 0c             	mov    %edx,0xc(%eax)
  802c89:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802c8c:	8b 40 0c             	mov    0xc(%eax),%eax
  802c8f:	85 c0                	test   %eax,%eax
  802c91:	74 0d                	je     802ca0 <sget+0x47e>
  802c93:	a1 34 d1 81 00       	mov    0x81d134,%eax
  802c98:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802c9b:	89 50 08             	mov    %edx,0x8(%eax)
  802c9e:	eb 08                	jmp    802ca8 <sget+0x486>
  802ca0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802ca3:	a3 30 d1 81 00       	mov    %eax,0x81d130
  802ca8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802cab:	a3 34 d1 81 00       	mov    %eax,0x81d134
  802cb0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802cb3:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802cba:	a1 3c d1 81 00       	mov    0x81d13c,%eax
  802cbf:	40                   	inc    %eax
  802cc0:	a3 3c d1 81 00       	mov    %eax,0x81d13c
					LIST_REMOVE(&u_freelist ,currentfreeelement);
  802cc5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802cc9:	75 17                	jne    802ce2 <sget+0x4c0>
  802ccb:	83 ec 04             	sub    $0x4,%esp
  802cce:	68 5b 4a 80 00       	push   $0x804a5b
  802cd3:	68 ff 01 00 00       	push   $0x1ff
  802cd8:	68 ec 49 80 00       	push   $0x8049ec
  802cdd:	e8 24 d6 ff ff       	call   800306 <_panic>
  802ce2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ce5:	8b 40 08             	mov    0x8(%eax),%eax
  802ce8:	85 c0                	test   %eax,%eax
  802cea:	74 11                	je     802cfd <sget+0x4db>
  802cec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cef:	8b 40 08             	mov    0x8(%eax),%eax
  802cf2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802cf5:	8b 52 0c             	mov    0xc(%edx),%edx
  802cf8:	89 50 0c             	mov    %edx,0xc(%eax)
  802cfb:	eb 0b                	jmp    802d08 <sget+0x4e6>
  802cfd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d00:	8b 40 0c             	mov    0xc(%eax),%eax
  802d03:	a3 24 d1 81 00       	mov    %eax,0x81d124
  802d08:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d0b:	8b 40 0c             	mov    0xc(%eax),%eax
  802d0e:	85 c0                	test   %eax,%eax
  802d10:	74 11                	je     802d23 <sget+0x501>
  802d12:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d15:	8b 40 0c             	mov    0xc(%eax),%eax
  802d18:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d1b:	8b 52 08             	mov    0x8(%edx),%edx
  802d1e:	89 50 08             	mov    %edx,0x8(%eax)
  802d21:	eb 0b                	jmp    802d2e <sget+0x50c>
  802d23:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d26:	8b 40 08             	mov    0x8(%eax),%eax
  802d29:	a3 20 d1 81 00       	mov    %eax,0x81d120
  802d2e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d31:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802d38:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d3b:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  802d42:	a1 2c d1 81 00       	mov    0x81d12c,%eax
  802d47:	48                   	dec    %eax
  802d48:	a3 2c d1 81 00       	mov    %eax,0x81d12c

					int result = sys_get_shared_object(ownerEnvID ,sharedVarName ,(void*)allocblock->startva);
  802d4d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802d50:	8b 00                	mov    (%eax),%eax
  802d52:	83 ec 04             	sub    $0x4,%esp
  802d55:	50                   	push   %eax
  802d56:	ff 75 0c             	pushl  0xc(%ebp)
  802d59:	ff 75 08             	pushl  0x8(%ebp)
  802d5c:	e8 fd 02 00 00       	call   80305e <sys_get_shared_object>
  802d61:	83 c4 10             	add    $0x10,%esp
  802d64:	89 45 d8             	mov    %eax,-0x28(%ebp)
					if(result <0){
  802d67:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  802d6b:	79 25                	jns    802d92 <sget+0x570>
						free_block(allocblock);
  802d6d:	83 ec 0c             	sub    $0xc,%esp
  802d70:	ff 75 e0             	pushl  -0x20(%ebp)
  802d73:	e8 3d 0d 00 00       	call   803ab5 <free_block>
  802d78:	83 c4 10             	add    $0x10,%esp
						release_uspinlock(&ulock);
  802d7b:	83 ec 0c             	sub    $0xc,%esp
  802d7e:	68 40 d1 81 00       	push   $0x81d140
  802d83:	e8 51 11 00 00       	call   803ed9 <release_uspinlock>
  802d88:	83 c4 10             	add    $0x10,%esp
						return NULL;
  802d8b:	b8 00 00 00 00       	mov    $0x0,%eax
  802d90:	eb 4d                	jmp    802ddf <sget+0x5bd>
					}

					release_uspinlock(&ulock);
  802d92:	83 ec 0c             	sub    $0xc,%esp
  802d95:	68 40 d1 81 00       	push   $0x81d140
  802d9a:	e8 3a 11 00 00       	call   803ed9 <release_uspinlock>
  802d9f:	83 c4 10             	add    $0x10,%esp
					return (void*)allocblock->startva;
  802da2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802da5:	8b 00                	mov    (%eax),%eax
  802da7:	eb 36                	jmp    802ddf <sget+0x5bd>
				}
				currentfreeelement = currentfreeelement->prev_next_info.le_next;
  802da9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dac:	8b 40 08             	mov    0x8(%eax),%eax
  802daf:	89 45 f4             	mov    %eax,-0xc(%ebp)
					 }
		}else{
			//custom fit
			struct UserHeapStruct* currentfreeelement = LIST_FIRST(&u_freelist);
			//worst fit
			while(currentfreeelement != NULL){
  802db2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802db6:	0f 85 4b fc ff ff    	jne    802a07 <sget+0x1e5>
					return (void*)allocblock->startva;
				}
				currentfreeelement = currentfreeelement->prev_next_info.le_next;
			}
		}
		free_block(allocblock);
  802dbc:	83 ec 0c             	sub    $0xc,%esp
  802dbf:	ff 75 e0             	pushl  -0x20(%ebp)
  802dc2:	e8 ee 0c 00 00       	call   803ab5 <free_block>
  802dc7:	83 c4 10             	add    $0x10,%esp
		release_uspinlock(&ulock);
  802dca:	83 ec 0c             	sub    $0xc,%esp
  802dcd:	68 40 d1 81 00       	push   $0x81d140
  802dd2:	e8 02 11 00 00       	call   803ed9 <release_uspinlock>
  802dd7:	83 c4 10             	add    $0x10,%esp
		return NULL;
  802dda:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802ddf:	c9                   	leave  
  802de0:	c3                   	ret    

00802de1 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  802de1:	55                   	push   %ebp
  802de2:	89 e5                	mov    %esp,%ebp
  802de4:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  802de7:	e8 cd e6 ff ff       	call   8014b9 <uheap_init>
	//==============================================================
	panic("realloc() is not implemented yet...!!");
  802dec:	83 ec 04             	sub    $0x4,%esp
  802def:	68 0c 4b 80 00       	push   $0x804b0c
  802df4:	68 2d 02 00 00       	push   $0x22d
  802df9:	68 ec 49 80 00       	push   $0x8049ec
  802dfe:	e8 03 d5 ff ff       	call   800306 <_panic>

00802e03 <sfree>:
//
//	use sys_delete_shared_object(...); which switches to the kernel mode,
//	calls delete_shared_object(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the delete_shared_object() function is empty, make sure to implement it.
void sfree(void* virtual_address)
{
  802e03:	55                   	push   %ebp
  802e04:	89 e5                	mov    %esp,%ebp
  802e06:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.BONUS#5] EXIT #2 - sfree
	//Your code is here
	//Comment the following line
	panic("sfree() is not implemented yet...!!");
  802e09:	83 ec 04             	sub    $0x4,%esp
  802e0c:	68 34 4b 80 00       	push   $0x804b34
  802e11:	68 40 02 00 00       	push   $0x240
  802e16:	68 ec 49 80 00       	push   $0x8049ec
  802e1b:	e8 e6 d4 ff ff       	call   800306 <_panic>

00802e20 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  802e20:	55                   	push   %ebp
  802e21:	89 e5                	mov    %esp,%ebp
  802e23:	57                   	push   %edi
  802e24:	56                   	push   %esi
  802e25:	53                   	push   %ebx
  802e26:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  802e29:	8b 45 08             	mov    0x8(%ebp),%eax
  802e2c:	8b 55 0c             	mov    0xc(%ebp),%edx
  802e2f:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802e32:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802e35:	8b 7d 18             	mov    0x18(%ebp),%edi
  802e38:	8b 75 1c             	mov    0x1c(%ebp),%esi
  802e3b:	cd 30                	int    $0x30
  802e3d:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  802e40:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  802e43:	83 c4 10             	add    $0x10,%esp
  802e46:	5b                   	pop    %ebx
  802e47:	5e                   	pop    %esi
  802e48:	5f                   	pop    %edi
  802e49:	5d                   	pop    %ebp
  802e4a:	c3                   	ret    

00802e4b <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  802e4b:	55                   	push   %ebp
  802e4c:	89 e5                	mov    %esp,%ebp
  802e4e:	83 ec 04             	sub    $0x4,%esp
  802e51:	8b 45 10             	mov    0x10(%ebp),%eax
  802e54:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  802e57:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802e5a:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802e5e:	8b 45 08             	mov    0x8(%ebp),%eax
  802e61:	6a 00                	push   $0x0
  802e63:	51                   	push   %ecx
  802e64:	52                   	push   %edx
  802e65:	ff 75 0c             	pushl  0xc(%ebp)
  802e68:	50                   	push   %eax
  802e69:	6a 00                	push   $0x0
  802e6b:	e8 b0 ff ff ff       	call   802e20 <syscall>
  802e70:	83 c4 18             	add    $0x18,%esp
}
  802e73:	90                   	nop
  802e74:	c9                   	leave  
  802e75:	c3                   	ret    

00802e76 <sys_cgetc>:

int
sys_cgetc(void)
{
  802e76:	55                   	push   %ebp
  802e77:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  802e79:	6a 00                	push   $0x0
  802e7b:	6a 00                	push   $0x0
  802e7d:	6a 00                	push   $0x0
  802e7f:	6a 00                	push   $0x0
  802e81:	6a 00                	push   $0x0
  802e83:	6a 02                	push   $0x2
  802e85:	e8 96 ff ff ff       	call   802e20 <syscall>
  802e8a:	83 c4 18             	add    $0x18,%esp
}
  802e8d:	c9                   	leave  
  802e8e:	c3                   	ret    

00802e8f <sys_lock_cons>:

void sys_lock_cons(void)
{
  802e8f:	55                   	push   %ebp
  802e90:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  802e92:	6a 00                	push   $0x0
  802e94:	6a 00                	push   $0x0
  802e96:	6a 00                	push   $0x0
  802e98:	6a 00                	push   $0x0
  802e9a:	6a 00                	push   $0x0
  802e9c:	6a 03                	push   $0x3
  802e9e:	e8 7d ff ff ff       	call   802e20 <syscall>
  802ea3:	83 c4 18             	add    $0x18,%esp
}
  802ea6:	90                   	nop
  802ea7:	c9                   	leave  
  802ea8:	c3                   	ret    

00802ea9 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  802ea9:	55                   	push   %ebp
  802eaa:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  802eac:	6a 00                	push   $0x0
  802eae:	6a 00                	push   $0x0
  802eb0:	6a 00                	push   $0x0
  802eb2:	6a 00                	push   $0x0
  802eb4:	6a 00                	push   $0x0
  802eb6:	6a 04                	push   $0x4
  802eb8:	e8 63 ff ff ff       	call   802e20 <syscall>
  802ebd:	83 c4 18             	add    $0x18,%esp
}
  802ec0:	90                   	nop
  802ec1:	c9                   	leave  
  802ec2:	c3                   	ret    

00802ec3 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  802ec3:	55                   	push   %ebp
  802ec4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  802ec6:	8b 55 0c             	mov    0xc(%ebp),%edx
  802ec9:	8b 45 08             	mov    0x8(%ebp),%eax
  802ecc:	6a 00                	push   $0x0
  802ece:	6a 00                	push   $0x0
  802ed0:	6a 00                	push   $0x0
  802ed2:	52                   	push   %edx
  802ed3:	50                   	push   %eax
  802ed4:	6a 08                	push   $0x8
  802ed6:	e8 45 ff ff ff       	call   802e20 <syscall>
  802edb:	83 c4 18             	add    $0x18,%esp
}
  802ede:	c9                   	leave  
  802edf:	c3                   	ret    

00802ee0 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  802ee0:	55                   	push   %ebp
  802ee1:	89 e5                	mov    %esp,%ebp
  802ee3:	56                   	push   %esi
  802ee4:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  802ee5:	8b 75 18             	mov    0x18(%ebp),%esi
  802ee8:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802eeb:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802eee:	8b 55 0c             	mov    0xc(%ebp),%edx
  802ef1:	8b 45 08             	mov    0x8(%ebp),%eax
  802ef4:	56                   	push   %esi
  802ef5:	53                   	push   %ebx
  802ef6:	51                   	push   %ecx
  802ef7:	52                   	push   %edx
  802ef8:	50                   	push   %eax
  802ef9:	6a 09                	push   $0x9
  802efb:	e8 20 ff ff ff       	call   802e20 <syscall>
  802f00:	83 c4 18             	add    $0x18,%esp
}
  802f03:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802f06:	5b                   	pop    %ebx
  802f07:	5e                   	pop    %esi
  802f08:	5d                   	pop    %ebp
  802f09:	c3                   	ret    

00802f0a <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  802f0a:	55                   	push   %ebp
  802f0b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  802f0d:	6a 00                	push   $0x0
  802f0f:	6a 00                	push   $0x0
  802f11:	6a 00                	push   $0x0
  802f13:	6a 00                	push   $0x0
  802f15:	ff 75 08             	pushl  0x8(%ebp)
  802f18:	6a 0a                	push   $0xa
  802f1a:	e8 01 ff ff ff       	call   802e20 <syscall>
  802f1f:	83 c4 18             	add    $0x18,%esp
}
  802f22:	c9                   	leave  
  802f23:	c3                   	ret    

00802f24 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  802f24:	55                   	push   %ebp
  802f25:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  802f27:	6a 00                	push   $0x0
  802f29:	6a 00                	push   $0x0
  802f2b:	6a 00                	push   $0x0
  802f2d:	ff 75 0c             	pushl  0xc(%ebp)
  802f30:	ff 75 08             	pushl  0x8(%ebp)
  802f33:	6a 0b                	push   $0xb
  802f35:	e8 e6 fe ff ff       	call   802e20 <syscall>
  802f3a:	83 c4 18             	add    $0x18,%esp
}
  802f3d:	c9                   	leave  
  802f3e:	c3                   	ret    

00802f3f <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  802f3f:	55                   	push   %ebp
  802f40:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  802f42:	6a 00                	push   $0x0
  802f44:	6a 00                	push   $0x0
  802f46:	6a 00                	push   $0x0
  802f48:	6a 00                	push   $0x0
  802f4a:	6a 00                	push   $0x0
  802f4c:	6a 0c                	push   $0xc
  802f4e:	e8 cd fe ff ff       	call   802e20 <syscall>
  802f53:	83 c4 18             	add    $0x18,%esp
}
  802f56:	c9                   	leave  
  802f57:	c3                   	ret    

00802f58 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  802f58:	55                   	push   %ebp
  802f59:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  802f5b:	6a 00                	push   $0x0
  802f5d:	6a 00                	push   $0x0
  802f5f:	6a 00                	push   $0x0
  802f61:	6a 00                	push   $0x0
  802f63:	6a 00                	push   $0x0
  802f65:	6a 0d                	push   $0xd
  802f67:	e8 b4 fe ff ff       	call   802e20 <syscall>
  802f6c:	83 c4 18             	add    $0x18,%esp
}
  802f6f:	c9                   	leave  
  802f70:	c3                   	ret    

00802f71 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  802f71:	55                   	push   %ebp
  802f72:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  802f74:	6a 00                	push   $0x0
  802f76:	6a 00                	push   $0x0
  802f78:	6a 00                	push   $0x0
  802f7a:	6a 00                	push   $0x0
  802f7c:	6a 00                	push   $0x0
  802f7e:	6a 0e                	push   $0xe
  802f80:	e8 9b fe ff ff       	call   802e20 <syscall>
  802f85:	83 c4 18             	add    $0x18,%esp
}
  802f88:	c9                   	leave  
  802f89:	c3                   	ret    

00802f8a <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  802f8a:	55                   	push   %ebp
  802f8b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  802f8d:	6a 00                	push   $0x0
  802f8f:	6a 00                	push   $0x0
  802f91:	6a 00                	push   $0x0
  802f93:	6a 00                	push   $0x0
  802f95:	6a 00                	push   $0x0
  802f97:	6a 0f                	push   $0xf
  802f99:	e8 82 fe ff ff       	call   802e20 <syscall>
  802f9e:	83 c4 18             	add    $0x18,%esp
}
  802fa1:	c9                   	leave  
  802fa2:	c3                   	ret    

00802fa3 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  802fa3:	55                   	push   %ebp
  802fa4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  802fa6:	6a 00                	push   $0x0
  802fa8:	6a 00                	push   $0x0
  802faa:	6a 00                	push   $0x0
  802fac:	6a 00                	push   $0x0
  802fae:	ff 75 08             	pushl  0x8(%ebp)
  802fb1:	6a 10                	push   $0x10
  802fb3:	e8 68 fe ff ff       	call   802e20 <syscall>
  802fb8:	83 c4 18             	add    $0x18,%esp
}
  802fbb:	c9                   	leave  
  802fbc:	c3                   	ret    

00802fbd <sys_scarce_memory>:

void sys_scarce_memory()
{
  802fbd:	55                   	push   %ebp
  802fbe:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  802fc0:	6a 00                	push   $0x0
  802fc2:	6a 00                	push   $0x0
  802fc4:	6a 00                	push   $0x0
  802fc6:	6a 00                	push   $0x0
  802fc8:	6a 00                	push   $0x0
  802fca:	6a 11                	push   $0x11
  802fcc:	e8 4f fe ff ff       	call   802e20 <syscall>
  802fd1:	83 c4 18             	add    $0x18,%esp
}
  802fd4:	90                   	nop
  802fd5:	c9                   	leave  
  802fd6:	c3                   	ret    

00802fd7 <sys_cputc>:

void
sys_cputc(const char c)
{
  802fd7:	55                   	push   %ebp
  802fd8:	89 e5                	mov    %esp,%ebp
  802fda:	83 ec 04             	sub    $0x4,%esp
  802fdd:	8b 45 08             	mov    0x8(%ebp),%eax
  802fe0:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  802fe3:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802fe7:	6a 00                	push   $0x0
  802fe9:	6a 00                	push   $0x0
  802feb:	6a 00                	push   $0x0
  802fed:	6a 00                	push   $0x0
  802fef:	50                   	push   %eax
  802ff0:	6a 01                	push   $0x1
  802ff2:	e8 29 fe ff ff       	call   802e20 <syscall>
  802ff7:	83 c4 18             	add    $0x18,%esp
}
  802ffa:	90                   	nop
  802ffb:	c9                   	leave  
  802ffc:	c3                   	ret    

00802ffd <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  802ffd:	55                   	push   %ebp
  802ffe:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  803000:	6a 00                	push   $0x0
  803002:	6a 00                	push   $0x0
  803004:	6a 00                	push   $0x0
  803006:	6a 00                	push   $0x0
  803008:	6a 00                	push   $0x0
  80300a:	6a 14                	push   $0x14
  80300c:	e8 0f fe ff ff       	call   802e20 <syscall>
  803011:	83 c4 18             	add    $0x18,%esp
}
  803014:	90                   	nop
  803015:	c9                   	leave  
  803016:	c3                   	ret    

00803017 <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  803017:	55                   	push   %ebp
  803018:	89 e5                	mov    %esp,%ebp
  80301a:	83 ec 04             	sub    $0x4,%esp
  80301d:	8b 45 10             	mov    0x10(%ebp),%eax
  803020:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  803023:	8b 4d 14             	mov    0x14(%ebp),%ecx
  803026:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80302a:	8b 45 08             	mov    0x8(%ebp),%eax
  80302d:	6a 00                	push   $0x0
  80302f:	51                   	push   %ecx
  803030:	52                   	push   %edx
  803031:	ff 75 0c             	pushl  0xc(%ebp)
  803034:	50                   	push   %eax
  803035:	6a 15                	push   $0x15
  803037:	e8 e4 fd ff ff       	call   802e20 <syscall>
  80303c:	83 c4 18             	add    $0x18,%esp
}
  80303f:	c9                   	leave  
  803040:	c3                   	ret    

00803041 <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  803041:	55                   	push   %ebp
  803042:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  803044:	8b 55 0c             	mov    0xc(%ebp),%edx
  803047:	8b 45 08             	mov    0x8(%ebp),%eax
  80304a:	6a 00                	push   $0x0
  80304c:	6a 00                	push   $0x0
  80304e:	6a 00                	push   $0x0
  803050:	52                   	push   %edx
  803051:	50                   	push   %eax
  803052:	6a 16                	push   $0x16
  803054:	e8 c7 fd ff ff       	call   802e20 <syscall>
  803059:	83 c4 18             	add    $0x18,%esp
}
  80305c:	c9                   	leave  
  80305d:	c3                   	ret    

0080305e <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  80305e:	55                   	push   %ebp
  80305f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  803061:	8b 4d 10             	mov    0x10(%ebp),%ecx
  803064:	8b 55 0c             	mov    0xc(%ebp),%edx
  803067:	8b 45 08             	mov    0x8(%ebp),%eax
  80306a:	6a 00                	push   $0x0
  80306c:	6a 00                	push   $0x0
  80306e:	51                   	push   %ecx
  80306f:	52                   	push   %edx
  803070:	50                   	push   %eax
  803071:	6a 17                	push   $0x17
  803073:	e8 a8 fd ff ff       	call   802e20 <syscall>
  803078:	83 c4 18             	add    $0x18,%esp
}
  80307b:	c9                   	leave  
  80307c:	c3                   	ret    

0080307d <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  80307d:	55                   	push   %ebp
  80307e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  803080:	8b 55 0c             	mov    0xc(%ebp),%edx
  803083:	8b 45 08             	mov    0x8(%ebp),%eax
  803086:	6a 00                	push   $0x0
  803088:	6a 00                	push   $0x0
  80308a:	6a 00                	push   $0x0
  80308c:	52                   	push   %edx
  80308d:	50                   	push   %eax
  80308e:	6a 18                	push   $0x18
  803090:	e8 8b fd ff ff       	call   802e20 <syscall>
  803095:	83 c4 18             	add    $0x18,%esp
}
  803098:	c9                   	leave  
  803099:	c3                   	ret    

0080309a <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  80309a:	55                   	push   %ebp
  80309b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  80309d:	8b 45 08             	mov    0x8(%ebp),%eax
  8030a0:	6a 00                	push   $0x0
  8030a2:	ff 75 14             	pushl  0x14(%ebp)
  8030a5:	ff 75 10             	pushl  0x10(%ebp)
  8030a8:	ff 75 0c             	pushl  0xc(%ebp)
  8030ab:	50                   	push   %eax
  8030ac:	6a 19                	push   $0x19
  8030ae:	e8 6d fd ff ff       	call   802e20 <syscall>
  8030b3:	83 c4 18             	add    $0x18,%esp
}
  8030b6:	c9                   	leave  
  8030b7:	c3                   	ret    

008030b8 <sys_run_env>:

void sys_run_env(int32 envId)
{
  8030b8:	55                   	push   %ebp
  8030b9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8030bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8030be:	6a 00                	push   $0x0
  8030c0:	6a 00                	push   $0x0
  8030c2:	6a 00                	push   $0x0
  8030c4:	6a 00                	push   $0x0
  8030c6:	50                   	push   %eax
  8030c7:	6a 1a                	push   $0x1a
  8030c9:	e8 52 fd ff ff       	call   802e20 <syscall>
  8030ce:	83 c4 18             	add    $0x18,%esp
}
  8030d1:	90                   	nop
  8030d2:	c9                   	leave  
  8030d3:	c3                   	ret    

008030d4 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8030d4:	55                   	push   %ebp
  8030d5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8030d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8030da:	6a 00                	push   $0x0
  8030dc:	6a 00                	push   $0x0
  8030de:	6a 00                	push   $0x0
  8030e0:	6a 00                	push   $0x0
  8030e2:	50                   	push   %eax
  8030e3:	6a 1b                	push   $0x1b
  8030e5:	e8 36 fd ff ff       	call   802e20 <syscall>
  8030ea:	83 c4 18             	add    $0x18,%esp
}
  8030ed:	c9                   	leave  
  8030ee:	c3                   	ret    

008030ef <sys_getenvid>:

int32 sys_getenvid(void)
{
  8030ef:	55                   	push   %ebp
  8030f0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8030f2:	6a 00                	push   $0x0
  8030f4:	6a 00                	push   $0x0
  8030f6:	6a 00                	push   $0x0
  8030f8:	6a 00                	push   $0x0
  8030fa:	6a 00                	push   $0x0
  8030fc:	6a 05                	push   $0x5
  8030fe:	e8 1d fd ff ff       	call   802e20 <syscall>
  803103:	83 c4 18             	add    $0x18,%esp
}
  803106:	c9                   	leave  
  803107:	c3                   	ret    

00803108 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  803108:	55                   	push   %ebp
  803109:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  80310b:	6a 00                	push   $0x0
  80310d:	6a 00                	push   $0x0
  80310f:	6a 00                	push   $0x0
  803111:	6a 00                	push   $0x0
  803113:	6a 00                	push   $0x0
  803115:	6a 06                	push   $0x6
  803117:	e8 04 fd ff ff       	call   802e20 <syscall>
  80311c:	83 c4 18             	add    $0x18,%esp
}
  80311f:	c9                   	leave  
  803120:	c3                   	ret    

00803121 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  803121:	55                   	push   %ebp
  803122:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  803124:	6a 00                	push   $0x0
  803126:	6a 00                	push   $0x0
  803128:	6a 00                	push   $0x0
  80312a:	6a 00                	push   $0x0
  80312c:	6a 00                	push   $0x0
  80312e:	6a 07                	push   $0x7
  803130:	e8 eb fc ff ff       	call   802e20 <syscall>
  803135:	83 c4 18             	add    $0x18,%esp
}
  803138:	c9                   	leave  
  803139:	c3                   	ret    

0080313a <sys_exit_env>:


void sys_exit_env(void)
{
  80313a:	55                   	push   %ebp
  80313b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  80313d:	6a 00                	push   $0x0
  80313f:	6a 00                	push   $0x0
  803141:	6a 00                	push   $0x0
  803143:	6a 00                	push   $0x0
  803145:	6a 00                	push   $0x0
  803147:	6a 1c                	push   $0x1c
  803149:	e8 d2 fc ff ff       	call   802e20 <syscall>
  80314e:	83 c4 18             	add    $0x18,%esp
}
  803151:	90                   	nop
  803152:	c9                   	leave  
  803153:	c3                   	ret    

00803154 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  803154:	55                   	push   %ebp
  803155:	89 e5                	mov    %esp,%ebp
  803157:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  80315a:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80315d:	8d 50 04             	lea    0x4(%eax),%edx
  803160:	8d 45 f8             	lea    -0x8(%ebp),%eax
  803163:	6a 00                	push   $0x0
  803165:	6a 00                	push   $0x0
  803167:	6a 00                	push   $0x0
  803169:	52                   	push   %edx
  80316a:	50                   	push   %eax
  80316b:	6a 1d                	push   $0x1d
  80316d:	e8 ae fc ff ff       	call   802e20 <syscall>
  803172:	83 c4 18             	add    $0x18,%esp
	return result;
  803175:	8b 4d 08             	mov    0x8(%ebp),%ecx
  803178:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80317b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80317e:	89 01                	mov    %eax,(%ecx)
  803180:	89 51 04             	mov    %edx,0x4(%ecx)
}
  803183:	8b 45 08             	mov    0x8(%ebp),%eax
  803186:	c9                   	leave  
  803187:	c2 04 00             	ret    $0x4

0080318a <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  80318a:	55                   	push   %ebp
  80318b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  80318d:	6a 00                	push   $0x0
  80318f:	6a 00                	push   $0x0
  803191:	ff 75 10             	pushl  0x10(%ebp)
  803194:	ff 75 0c             	pushl  0xc(%ebp)
  803197:	ff 75 08             	pushl  0x8(%ebp)
  80319a:	6a 13                	push   $0x13
  80319c:	e8 7f fc ff ff       	call   802e20 <syscall>
  8031a1:	83 c4 18             	add    $0x18,%esp
	return ;
  8031a4:	90                   	nop
}
  8031a5:	c9                   	leave  
  8031a6:	c3                   	ret    

008031a7 <sys_rcr2>:
uint32 sys_rcr2()
{
  8031a7:	55                   	push   %ebp
  8031a8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8031aa:	6a 00                	push   $0x0
  8031ac:	6a 00                	push   $0x0
  8031ae:	6a 00                	push   $0x0
  8031b0:	6a 00                	push   $0x0
  8031b2:	6a 00                	push   $0x0
  8031b4:	6a 1e                	push   $0x1e
  8031b6:	e8 65 fc ff ff       	call   802e20 <syscall>
  8031bb:	83 c4 18             	add    $0x18,%esp
}
  8031be:	c9                   	leave  
  8031bf:	c3                   	ret    

008031c0 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  8031c0:	55                   	push   %ebp
  8031c1:	89 e5                	mov    %esp,%ebp
  8031c3:	83 ec 04             	sub    $0x4,%esp
  8031c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8031c9:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8031cc:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8031d0:	6a 00                	push   $0x0
  8031d2:	6a 00                	push   $0x0
  8031d4:	6a 00                	push   $0x0
  8031d6:	6a 00                	push   $0x0
  8031d8:	50                   	push   %eax
  8031d9:	6a 1f                	push   $0x1f
  8031db:	e8 40 fc ff ff       	call   802e20 <syscall>
  8031e0:	83 c4 18             	add    $0x18,%esp
	return ;
  8031e3:	90                   	nop
}
  8031e4:	c9                   	leave  
  8031e5:	c3                   	ret    

008031e6 <rsttst>:
void rsttst()
{
  8031e6:	55                   	push   %ebp
  8031e7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8031e9:	6a 00                	push   $0x0
  8031eb:	6a 00                	push   $0x0
  8031ed:	6a 00                	push   $0x0
  8031ef:	6a 00                	push   $0x0
  8031f1:	6a 00                	push   $0x0
  8031f3:	6a 21                	push   $0x21
  8031f5:	e8 26 fc ff ff       	call   802e20 <syscall>
  8031fa:	83 c4 18             	add    $0x18,%esp
	return ;
  8031fd:	90                   	nop
}
  8031fe:	c9                   	leave  
  8031ff:	c3                   	ret    

00803200 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  803200:	55                   	push   %ebp
  803201:	89 e5                	mov    %esp,%ebp
  803203:	83 ec 04             	sub    $0x4,%esp
  803206:	8b 45 14             	mov    0x14(%ebp),%eax
  803209:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  80320c:	8b 55 18             	mov    0x18(%ebp),%edx
  80320f:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  803213:	52                   	push   %edx
  803214:	50                   	push   %eax
  803215:	ff 75 10             	pushl  0x10(%ebp)
  803218:	ff 75 0c             	pushl  0xc(%ebp)
  80321b:	ff 75 08             	pushl  0x8(%ebp)
  80321e:	6a 20                	push   $0x20
  803220:	e8 fb fb ff ff       	call   802e20 <syscall>
  803225:	83 c4 18             	add    $0x18,%esp
	return ;
  803228:	90                   	nop
}
  803229:	c9                   	leave  
  80322a:	c3                   	ret    

0080322b <chktst>:
void chktst(uint32 n)
{
  80322b:	55                   	push   %ebp
  80322c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  80322e:	6a 00                	push   $0x0
  803230:	6a 00                	push   $0x0
  803232:	6a 00                	push   $0x0
  803234:	6a 00                	push   $0x0
  803236:	ff 75 08             	pushl  0x8(%ebp)
  803239:	6a 22                	push   $0x22
  80323b:	e8 e0 fb ff ff       	call   802e20 <syscall>
  803240:	83 c4 18             	add    $0x18,%esp
	return ;
  803243:	90                   	nop
}
  803244:	c9                   	leave  
  803245:	c3                   	ret    

00803246 <inctst>:

void inctst()
{
  803246:	55                   	push   %ebp
  803247:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  803249:	6a 00                	push   $0x0
  80324b:	6a 00                	push   $0x0
  80324d:	6a 00                	push   $0x0
  80324f:	6a 00                	push   $0x0
  803251:	6a 00                	push   $0x0
  803253:	6a 23                	push   $0x23
  803255:	e8 c6 fb ff ff       	call   802e20 <syscall>
  80325a:	83 c4 18             	add    $0x18,%esp
	return ;
  80325d:	90                   	nop
}
  80325e:	c9                   	leave  
  80325f:	c3                   	ret    

00803260 <gettst>:
uint32 gettst()
{
  803260:	55                   	push   %ebp
  803261:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  803263:	6a 00                	push   $0x0
  803265:	6a 00                	push   $0x0
  803267:	6a 00                	push   $0x0
  803269:	6a 00                	push   $0x0
  80326b:	6a 00                	push   $0x0
  80326d:	6a 24                	push   $0x24
  80326f:	e8 ac fb ff ff       	call   802e20 <syscall>
  803274:	83 c4 18             	add    $0x18,%esp
}
  803277:	c9                   	leave  
  803278:	c3                   	ret    

00803279 <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  803279:	55                   	push   %ebp
  80327a:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80327c:	6a 00                	push   $0x0
  80327e:	6a 00                	push   $0x0
  803280:	6a 00                	push   $0x0
  803282:	6a 00                	push   $0x0
  803284:	6a 00                	push   $0x0
  803286:	6a 25                	push   $0x25
  803288:	e8 93 fb ff ff       	call   802e20 <syscall>
  80328d:	83 c4 18             	add    $0x18,%esp
  803290:	a3 60 d0 81 00       	mov    %eax,0x81d060
	return uheapPlaceStrategy ;
  803295:	a1 60 d0 81 00       	mov    0x81d060,%eax
}
  80329a:	c9                   	leave  
  80329b:	c3                   	ret    

0080329c <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  80329c:	55                   	push   %ebp
  80329d:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  80329f:	8b 45 08             	mov    0x8(%ebp),%eax
  8032a2:	a3 60 d0 81 00       	mov    %eax,0x81d060
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  8032a7:	6a 00                	push   $0x0
  8032a9:	6a 00                	push   $0x0
  8032ab:	6a 00                	push   $0x0
  8032ad:	6a 00                	push   $0x0
  8032af:	ff 75 08             	pushl  0x8(%ebp)
  8032b2:	6a 26                	push   $0x26
  8032b4:	e8 67 fb ff ff       	call   802e20 <syscall>
  8032b9:	83 c4 18             	add    $0x18,%esp
	return ;
  8032bc:	90                   	nop
}
  8032bd:	c9                   	leave  
  8032be:	c3                   	ret    

008032bf <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  8032bf:	55                   	push   %ebp
  8032c0:	89 e5                	mov    %esp,%ebp
  8032c2:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  8032c3:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8032c6:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8032c9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8032cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8032cf:	6a 00                	push   $0x0
  8032d1:	53                   	push   %ebx
  8032d2:	51                   	push   %ecx
  8032d3:	52                   	push   %edx
  8032d4:	50                   	push   %eax
  8032d5:	6a 27                	push   $0x27
  8032d7:	e8 44 fb ff ff       	call   802e20 <syscall>
  8032dc:	83 c4 18             	add    $0x18,%esp
}
  8032df:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8032e2:	c9                   	leave  
  8032e3:	c3                   	ret    

008032e4 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  8032e4:	55                   	push   %ebp
  8032e5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  8032e7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8032ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8032ed:	6a 00                	push   $0x0
  8032ef:	6a 00                	push   $0x0
  8032f1:	6a 00                	push   $0x0
  8032f3:	52                   	push   %edx
  8032f4:	50                   	push   %eax
  8032f5:	6a 28                	push   $0x28
  8032f7:	e8 24 fb ff ff       	call   802e20 <syscall>
  8032fc:	83 c4 18             	add    $0x18,%esp
}
  8032ff:	c9                   	leave  
  803300:	c3                   	ret    

00803301 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  803301:	55                   	push   %ebp
  803302:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  803304:	8b 4d 14             	mov    0x14(%ebp),%ecx
  803307:	8b 55 0c             	mov    0xc(%ebp),%edx
  80330a:	8b 45 08             	mov    0x8(%ebp),%eax
  80330d:	6a 00                	push   $0x0
  80330f:	51                   	push   %ecx
  803310:	ff 75 10             	pushl  0x10(%ebp)
  803313:	52                   	push   %edx
  803314:	50                   	push   %eax
  803315:	6a 29                	push   $0x29
  803317:	e8 04 fb ff ff       	call   802e20 <syscall>
  80331c:	83 c4 18             	add    $0x18,%esp
}
  80331f:	c9                   	leave  
  803320:	c3                   	ret    

00803321 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  803321:	55                   	push   %ebp
  803322:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  803324:	6a 00                	push   $0x0
  803326:	6a 00                	push   $0x0
  803328:	ff 75 10             	pushl  0x10(%ebp)
  80332b:	ff 75 0c             	pushl  0xc(%ebp)
  80332e:	ff 75 08             	pushl  0x8(%ebp)
  803331:	6a 12                	push   $0x12
  803333:	e8 e8 fa ff ff       	call   802e20 <syscall>
  803338:	83 c4 18             	add    $0x18,%esp
	return ;
  80333b:	90                   	nop
}
  80333c:	c9                   	leave  
  80333d:	c3                   	ret    

0080333e <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  80333e:	55                   	push   %ebp
  80333f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  803341:	8b 55 0c             	mov    0xc(%ebp),%edx
  803344:	8b 45 08             	mov    0x8(%ebp),%eax
  803347:	6a 00                	push   $0x0
  803349:	6a 00                	push   $0x0
  80334b:	6a 00                	push   $0x0
  80334d:	52                   	push   %edx
  80334e:	50                   	push   %eax
  80334f:	6a 2a                	push   $0x2a
  803351:	e8 ca fa ff ff       	call   802e20 <syscall>
  803356:	83 c4 18             	add    $0x18,%esp
	return;
  803359:	90                   	nop
}
  80335a:	c9                   	leave  
  80335b:	c3                   	ret    

0080335c <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  80335c:	55                   	push   %ebp
  80335d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  80335f:	6a 00                	push   $0x0
  803361:	6a 00                	push   $0x0
  803363:	6a 00                	push   $0x0
  803365:	6a 00                	push   $0x0
  803367:	6a 00                	push   $0x0
  803369:	6a 2b                	push   $0x2b
  80336b:	e8 b0 fa ff ff       	call   802e20 <syscall>
  803370:	83 c4 18             	add    $0x18,%esp
}
  803373:	c9                   	leave  
  803374:	c3                   	ret    

00803375 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  803375:	55                   	push   %ebp
  803376:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  803378:	6a 00                	push   $0x0
  80337a:	6a 00                	push   $0x0
  80337c:	6a 00                	push   $0x0
  80337e:	ff 75 0c             	pushl  0xc(%ebp)
  803381:	ff 75 08             	pushl  0x8(%ebp)
  803384:	6a 2d                	push   $0x2d
  803386:	e8 95 fa ff ff       	call   802e20 <syscall>
  80338b:	83 c4 18             	add    $0x18,%esp
	return;
  80338e:	90                   	nop
}
  80338f:	c9                   	leave  
  803390:	c3                   	ret    

00803391 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  803391:	55                   	push   %ebp
  803392:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  803394:	6a 00                	push   $0x0
  803396:	6a 00                	push   $0x0
  803398:	6a 00                	push   $0x0
  80339a:	ff 75 0c             	pushl  0xc(%ebp)
  80339d:	ff 75 08             	pushl  0x8(%ebp)
  8033a0:	6a 2c                	push   $0x2c
  8033a2:	e8 79 fa ff ff       	call   802e20 <syscall>
  8033a7:	83 c4 18             	add    $0x18,%esp
	return ;
  8033aa:	90                   	nop
}
  8033ab:	c9                   	leave  
  8033ac:	c3                   	ret    

008033ad <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  8033ad:	55                   	push   %ebp
  8033ae:	89 e5                	mov    %esp,%ebp
	//TODO: [PROJECT'25.IM#4] CPU SCHEDULING - #1 System Calls - Add suitable code here
	//Your code is here
	//Comment the following line
	//panic("sys_env_set_priority() is not implemented yet...!!");
	syscall(SYS_env_set_priority, envID, priority, 0, 0, 0);
  8033b0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8033b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8033b6:	6a 00                	push   $0x0
  8033b8:	6a 00                	push   $0x0
  8033ba:	6a 00                	push   $0x0
  8033bc:	52                   	push   %edx
  8033bd:	50                   	push   %eax
  8033be:	6a 2e                	push   $0x2e
  8033c0:	e8 5b fa ff ff       	call   802e20 <syscall>
  8033c5:	83 c4 18             	add    $0x18,%esp
	    return;
  8033c8:	90                   	nop
}
  8033c9:	c9                   	leave  
  8033ca:	c3                   	ret    

008033cb <to_page_va>:
//==================================================================================//
//==================================
// [1] GET PAGE VA:
//==================================
__inline__ uint32 to_page_va(struct PageInfoElement *ptrPageInfo)
{
  8033cb:	55                   	push   %ebp
  8033cc:	89 e5                	mov    %esp,%ebp
  8033ce:	83 ec 10             	sub    $0x10,%esp
	//Get start VA of the page from the corresponding Page Info pointer
	int idxInPageInfoArr = (ptrPageInfo - pageBlockInfoArr);
  8033d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8033d4:	ba 60 50 80 00       	mov    $0x805060,%edx
  8033d9:	29 d0                	sub    %edx,%eax
  8033db:	c1 f8 02             	sar    $0x2,%eax
  8033de:	89 c2                	mov    %eax,%edx
  8033e0:	89 d0                	mov    %edx,%eax
  8033e2:	c1 e0 02             	shl    $0x2,%eax
  8033e5:	01 d0                	add    %edx,%eax
  8033e7:	c1 e0 02             	shl    $0x2,%eax
  8033ea:	01 d0                	add    %edx,%eax
  8033ec:	c1 e0 02             	shl    $0x2,%eax
  8033ef:	01 d0                	add    %edx,%eax
  8033f1:	89 c1                	mov    %eax,%ecx
  8033f3:	c1 e1 08             	shl    $0x8,%ecx
  8033f6:	01 c8                	add    %ecx,%eax
  8033f8:	89 c1                	mov    %eax,%ecx
  8033fa:	c1 e1 10             	shl    $0x10,%ecx
  8033fd:	01 c8                	add    %ecx,%eax
  8033ff:	01 c0                	add    %eax,%eax
  803401:	01 d0                	add    %edx,%eax
  803403:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return dynAllocStart + (idxInPageInfoArr << PGSHIFT);
  803406:	8b 45 fc             	mov    -0x4(%ebp),%eax
  803409:	c1 e0 0c             	shl    $0xc,%eax
  80340c:	89 c2                	mov    %eax,%edx
  80340e:	a1 64 d0 81 00       	mov    0x81d064,%eax
  803413:	01 d0                	add    %edx,%eax
}
  803415:	c9                   	leave  
  803416:	c3                   	ret    

00803417 <log2>:

//==================================================================================//
//============================ REQUIRED FUNCTIONS ==================================//
//==================================================================================//
__inline__ int log2(uint32 n)
	{
  803417:	55                   	push   %ebp
  803418:	89 e5                	mov    %esp,%ebp
  80341a:	83 ec 10             	sub    $0x10,%esp
		int result = 0;
  80341d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
		while( n > 1){
  803424:	eb 06                	jmp    80342c <log2+0x15>
			n >>=1;
  803426:	d1 6d 08             	shrl   0x8(%ebp)
			result++;
  803429:	ff 45 fc             	incl   -0x4(%ebp)
//============================ REQUIRED FUNCTIONS ==================================//
//==================================================================================//
__inline__ int log2(uint32 n)
	{
		int result = 0;
		while( n > 1){
  80342c:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
  803430:	77 f4                	ja     803426 <log2+0xf>
			n >>=1;
			result++;
		}
		return result;
  803432:	8b 45 fc             	mov    -0x4(%ebp),%eax
	}
  803435:	c9                   	leave  
  803436:	c3                   	ret    

00803437 <initialize_dynamic_allocator>:
//==================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================
bool is_initialized = 0;
void initialize_dynamic_allocator(uint32 daStart, uint32 daEnd)
{
  803437:	55                   	push   %ebp
  803438:	89 e5                	mov    %esp,%ebp
  80343a:	83 ec 18             	sub    $0x18,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(daEnd <= daStart + DYN_ALLOC_MAX_SIZE);
  80343d:	8b 45 08             	mov    0x8(%ebp),%eax
  803440:	05 00 00 00 02       	add    $0x2000000,%eax
  803445:	3b 45 0c             	cmp    0xc(%ebp),%eax
  803448:	73 16                	jae    803460 <initialize_dynamic_allocator+0x29>
  80344a:	68 58 4b 80 00       	push   $0x804b58
  80344f:	68 7e 4b 80 00       	push   $0x804b7e
  803454:	6a 2d                	push   $0x2d
  803456:	68 93 4b 80 00       	push   $0x804b93
  80345b:	e8 a6 ce ff ff       	call   800306 <_panic>
		is_initialized = 1;
  803460:	c7 05 24 50 80 00 01 	movl   $0x1,0x805024
  803467:	00 00 00 
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #1 initialize_dynamic_allocator
	//Your code is here


	dynAllocStart = daStart;
  80346a:	8b 45 08             	mov    0x8(%ebp),%eax
  80346d:	a3 64 d0 81 00       	mov    %eax,0x81d064
	dynAllocEnd= daEnd;
  803472:	8b 45 0c             	mov    0xc(%ebp),%eax
  803475:	a3 40 50 80 00       	mov    %eax,0x805040
	int numOfPages = (dynAllocEnd - dynAllocStart)/PAGE_SIZE;
  80347a:	8b 15 40 50 80 00    	mov    0x805040,%edx
  803480:	a1 64 d0 81 00       	mov    0x81d064,%eax
  803485:	29 c2                	sub    %eax,%edx
  803487:	89 d0                	mov    %edx,%eax
  803489:	c1 e8 0c             	shr    $0xc,%eax
  80348c:	89 45 e8             	mov    %eax,-0x18(%ebp)


	for(int i=0; i< numOfPages; i++){
  80348f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  803496:	eb 2f                	jmp    8034c7 <initialize_dynamic_allocator+0x90>
	    pageBlockInfoArr[i].block_size=0;
  803498:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80349b:	89 d0                	mov    %edx,%eax
  80349d:	01 c0                	add    %eax,%eax
  80349f:	01 d0                	add    %edx,%eax
  8034a1:	c1 e0 02             	shl    $0x2,%eax
  8034a4:	05 68 50 80 00       	add    $0x805068,%eax
  8034a9:	66 c7 00 00 00       	movw   $0x0,(%eax)
	    pageBlockInfoArr[i].num_of_free_blocks=0;
  8034ae:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8034b1:	89 d0                	mov    %edx,%eax
  8034b3:	01 c0                	add    %eax,%eax
  8034b5:	01 d0                	add    %edx,%eax
  8034b7:	c1 e0 02             	shl    $0x2,%eax
  8034ba:	05 6a 50 80 00       	add    $0x80506a,%eax
  8034bf:	66 c7 00 00 00       	movw   $0x0,(%eax)
	dynAllocStart = daStart;
	dynAllocEnd= daEnd;
	int numOfPages = (dynAllocEnd - dynAllocStart)/PAGE_SIZE;


	for(int i=0; i< numOfPages; i++){
  8034c4:	ff 45 f4             	incl   -0xc(%ebp)
  8034c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034ca:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8034cd:	7c c9                	jl     803498 <initialize_dynamic_allocator+0x61>
	    pageBlockInfoArr[i].block_size=0;
	    pageBlockInfoArr[i].num_of_free_blocks=0;
	}


	LIST_INIT(&freePagesList);
  8034cf:	c7 05 48 50 80 00 00 	movl   $0x0,0x805048
  8034d6:	00 00 00 
  8034d9:	c7 05 4c 50 80 00 00 	movl   $0x0,0x80504c
  8034e0:	00 00 00 
  8034e3:	c7 05 54 50 80 00 00 	movl   $0x0,0x805054
  8034ea:	00 00 00 
	for(int i=0; i<numOfPages; i++){
  8034ed:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8034f4:	e9 9c 00 00 00       	jmp    803595 <initialize_dynamic_allocator+0x15e>
		LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
  8034f9:	8b 15 4c 50 80 00    	mov    0x80504c,%edx
  8034ff:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  803502:	89 c8                	mov    %ecx,%eax
  803504:	01 c0                	add    %eax,%eax
  803506:	01 c8                	add    %ecx,%eax
  803508:	c1 e0 02             	shl    $0x2,%eax
  80350b:	05 64 50 80 00       	add    $0x805064,%eax
  803510:	89 10                	mov    %edx,(%eax)
  803512:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803515:	89 d0                	mov    %edx,%eax
  803517:	01 c0                	add    %eax,%eax
  803519:	01 d0                	add    %edx,%eax
  80351b:	c1 e0 02             	shl    $0x2,%eax
  80351e:	05 64 50 80 00       	add    $0x805064,%eax
  803523:	8b 00                	mov    (%eax),%eax
  803525:	85 c0                	test   %eax,%eax
  803527:	74 1b                	je     803544 <initialize_dynamic_allocator+0x10d>
  803529:	8b 15 4c 50 80 00    	mov    0x80504c,%edx
  80352f:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  803532:	89 c8                	mov    %ecx,%eax
  803534:	01 c0                	add    %eax,%eax
  803536:	01 c8                	add    %ecx,%eax
  803538:	c1 e0 02             	shl    $0x2,%eax
  80353b:	05 60 50 80 00       	add    $0x805060,%eax
  803540:	89 02                	mov    %eax,(%edx)
  803542:	eb 16                	jmp    80355a <initialize_dynamic_allocator+0x123>
  803544:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803547:	89 d0                	mov    %edx,%eax
  803549:	01 c0                	add    %eax,%eax
  80354b:	01 d0                	add    %edx,%eax
  80354d:	c1 e0 02             	shl    $0x2,%eax
  803550:	05 60 50 80 00       	add    $0x805060,%eax
  803555:	a3 48 50 80 00       	mov    %eax,0x805048
  80355a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80355d:	89 d0                	mov    %edx,%eax
  80355f:	01 c0                	add    %eax,%eax
  803561:	01 d0                	add    %edx,%eax
  803563:	c1 e0 02             	shl    $0x2,%eax
  803566:	05 60 50 80 00       	add    $0x805060,%eax
  80356b:	a3 4c 50 80 00       	mov    %eax,0x80504c
  803570:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803573:	89 d0                	mov    %edx,%eax
  803575:	01 c0                	add    %eax,%eax
  803577:	01 d0                	add    %edx,%eax
  803579:	c1 e0 02             	shl    $0x2,%eax
  80357c:	05 60 50 80 00       	add    $0x805060,%eax
  803581:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803587:	a1 54 50 80 00       	mov    0x805054,%eax
  80358c:	40                   	inc    %eax
  80358d:	a3 54 50 80 00       	mov    %eax,0x805054
	    pageBlockInfoArr[i].num_of_free_blocks=0;
	}


	LIST_INIT(&freePagesList);
	for(int i=0; i<numOfPages; i++){
  803592:	ff 45 f0             	incl   -0x10(%ebp)
  803595:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803598:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80359b:	0f 8c 58 ff ff ff    	jl     8034f9 <initialize_dynamic_allocator+0xc2>
		LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
	}



	for (int i = 0; i < LOG2_MAX_SIZE - LOG2_MIN_SIZE + 1; i++) {
  8035a1:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  8035a8:	eb 36                	jmp    8035e0 <initialize_dynamic_allocator+0x1a9>
	    LIST_INIT(&freeBlockLists[i]);
  8035aa:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8035ad:	c1 e0 04             	shl    $0x4,%eax
  8035b0:	05 80 d0 81 00       	add    $0x81d080,%eax
  8035b5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8035bb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8035be:	c1 e0 04             	shl    $0x4,%eax
  8035c1:	05 84 d0 81 00       	add    $0x81d084,%eax
  8035c6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8035cc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8035cf:	c1 e0 04             	shl    $0x4,%eax
  8035d2:	05 8c d0 81 00       	add    $0x81d08c,%eax
  8035d7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
	}



	for (int i = 0; i < LOG2_MAX_SIZE - LOG2_MIN_SIZE + 1; i++) {
  8035dd:	ff 45 ec             	incl   -0x14(%ebp)
  8035e0:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  8035e4:	7e c4                	jle    8035aa <initialize_dynamic_allocator+0x173>


	//Comment the following line
	//panic("initialize_dynamic_allocator() Not implemented yet");

}
  8035e6:	90                   	nop
  8035e7:	c9                   	leave  
  8035e8:	c3                   	ret    

008035e9 <get_block_size>:
// [2] GET BLOCK SIZE:
//===========================


__inline__ uint32 get_block_size(void *va)
{
  8035e9:	55                   	push   %ebp
  8035ea:	89 e5                	mov    %esp,%ebp
  8035ec:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #2 get_block_size
	//Your code is here

	uint32 page_index = ((uint32)va - dynAllocStart)/ PAGE_SIZE;
  8035ef:	8b 55 08             	mov    0x8(%ebp),%edx
  8035f2:	a1 64 d0 81 00       	mov    0x81d064,%eax
  8035f7:	29 c2                	sub    %eax,%edx
  8035f9:	89 d0                	mov    %edx,%eax
  8035fb:	c1 e8 0c             	shr    $0xc,%eax
  8035fe:	89 45 fc             	mov    %eax,-0x4(%ebp)
    return pageBlockInfoArr[page_index].block_size;
  803601:	8b 55 fc             	mov    -0x4(%ebp),%edx
  803604:	89 d0                	mov    %edx,%eax
  803606:	01 c0                	add    %eax,%eax
  803608:	01 d0                	add    %edx,%eax
  80360a:	c1 e0 02             	shl    $0x2,%eax
  80360d:	05 68 50 80 00       	add    $0x805068,%eax
  803612:	8b 00                	mov    (%eax),%eax
  803614:	0f b7 c0             	movzwl %ax,%eax
	//Comment the following line
	//panic("get_block_size() Not implemented yet");
}
  803617:	c9                   	leave  
  803618:	c3                   	ret    

00803619 <alloc_block>:

//===========================
// 3) ALLOCATE BLOCK:
//===========================
void *alloc_block(uint32 size)
{
  803619:	55                   	push   %ebp
  80361a:	89 e5                	mov    %esp,%ebp
  80361c:	83 ec 48             	sub    $0x48,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(size <= DYN_ALLOC_MAX_BLOCK_SIZE);
  80361f:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  803626:	76 16                	jbe    80363e <alloc_block+0x25>
  803628:	68 ac 4b 80 00       	push   $0x804bac
  80362d:	68 7e 4b 80 00       	push   $0x804b7e
  803632:	6a 6c                	push   $0x6c
  803634:	68 93 4b 80 00       	push   $0x804b93
  803639:	e8 c8 cc ff ff       	call   800306 <_panic>
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #3 alloc_block
	//Your code is here


	if(size == 0){
  80363e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803642:	75 0a                	jne    80364e <alloc_block+0x35>
		return NULL;
  803644:	b8 00 00 00 00       	mov    $0x0,%eax
  803649:	e9 65 04 00 00       	jmp    803ab3 <alloc_block+0x49a>
	}
	else if(size<=8){
  80364e:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  803652:	77 09                	ja     80365d <alloc_block+0x44>
		size=8;
  803654:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
  80365b:	eb 1f                	jmp    80367c <alloc_block+0x63>
	}
	else{
		uint32 reqsize=8;
  80365d:	c7 45 f4 08 00 00 00 	movl   $0x8,-0xc(%ebp)
		while(reqsize < size){
  803664:	eb 08                	jmp    80366e <alloc_block+0x55>
			reqsize*=2;
  803666:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803669:	01 c0                	add    %eax,%eax
  80366b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	else if(size<=8){
		size=8;
	}
	else{
		uint32 reqsize=8;
		while(reqsize < size){
  80366e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803671:	3b 45 08             	cmp    0x8(%ebp),%eax
  803674:	72 f0                	jb     803666 <alloc_block+0x4d>
			reqsize*=2;
		}
		size= reqsize;
  803676:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803679:	89 45 08             	mov    %eax,0x8(%ebp)
	}

	int list_index = log2(size)- LOG2_MIN_SIZE;
  80367c:	83 ec 0c             	sub    $0xc,%esp
  80367f:	ff 75 08             	pushl  0x8(%ebp)
  803682:	e8 90 fd ff ff       	call   803417 <log2>
  803687:	83 c4 10             	add    $0x10,%esp
  80368a:	83 e8 03             	sub    $0x3,%eax
  80368d:	89 45 e8             	mov    %eax,-0x18(%ebp)

	if(!LIST_EMPTY(&freeBlockLists[list_index])){
  803690:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803693:	c1 e0 04             	shl    $0x4,%eax
  803696:	05 80 d0 81 00       	add    $0x81d080,%eax
  80369b:	8b 00                	mov    (%eax),%eax
  80369d:	85 c0                	test   %eax,%eax
  80369f:	0f 84 fb 00 00 00    	je     8037a0 <alloc_block+0x187>
		struct BlockElement *block = LIST_FIRST(&freeBlockLists[list_index]);
  8036a5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8036a8:	c1 e0 04             	shl    $0x4,%eax
  8036ab:	05 80 d0 81 00       	add    $0x81d080,%eax
  8036b0:	8b 00                	mov    (%eax),%eax
  8036b2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		LIST_REMOVE(&freeBlockLists[list_index], block);
  8036b5:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8036b9:	75 17                	jne    8036d2 <alloc_block+0xb9>
  8036bb:	83 ec 04             	sub    $0x4,%esp
  8036be:	68 cd 4b 80 00       	push   $0x804bcd
  8036c3:	68 86 00 00 00       	push   $0x86
  8036c8:	68 93 4b 80 00       	push   $0x804b93
  8036cd:	e8 34 cc ff ff       	call   800306 <_panic>
  8036d2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8036d5:	8b 00                	mov    (%eax),%eax
  8036d7:	85 c0                	test   %eax,%eax
  8036d9:	74 10                	je     8036eb <alloc_block+0xd2>
  8036db:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8036de:	8b 00                	mov    (%eax),%eax
  8036e0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8036e3:	8b 52 04             	mov    0x4(%edx),%edx
  8036e6:	89 50 04             	mov    %edx,0x4(%eax)
  8036e9:	eb 14                	jmp    8036ff <alloc_block+0xe6>
  8036eb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8036ee:	8b 40 04             	mov    0x4(%eax),%eax
  8036f1:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8036f4:	c1 e2 04             	shl    $0x4,%edx
  8036f7:	81 c2 84 d0 81 00    	add    $0x81d084,%edx
  8036fd:	89 02                	mov    %eax,(%edx)
  8036ff:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803702:	8b 40 04             	mov    0x4(%eax),%eax
  803705:	85 c0                	test   %eax,%eax
  803707:	74 0f                	je     803718 <alloc_block+0xff>
  803709:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80370c:	8b 40 04             	mov    0x4(%eax),%eax
  80370f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803712:	8b 12                	mov    (%edx),%edx
  803714:	89 10                	mov    %edx,(%eax)
  803716:	eb 13                	jmp    80372b <alloc_block+0x112>
  803718:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80371b:	8b 00                	mov    (%eax),%eax
  80371d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803720:	c1 e2 04             	shl    $0x4,%edx
  803723:	81 c2 80 d0 81 00    	add    $0x81d080,%edx
  803729:	89 02                	mov    %eax,(%edx)
  80372b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80372e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803734:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803737:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80373e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803741:	c1 e0 04             	shl    $0x4,%eax
  803744:	05 8c d0 81 00       	add    $0x81d08c,%eax
  803749:	8b 00                	mov    (%eax),%eax
  80374b:	8d 50 ff             	lea    -0x1(%eax),%edx
  80374e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803751:	c1 e0 04             	shl    $0x4,%eax
  803754:	05 8c d0 81 00       	add    $0x81d08c,%eax
  803759:	89 10                	mov    %edx,(%eax)
		uint32 page_index = ((uint32)block - dynAllocStart)/ PAGE_SIZE;
  80375b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80375e:	a1 64 d0 81 00       	mov    0x81d064,%eax
  803763:	29 c2                	sub    %eax,%edx
  803765:	89 d0                	mov    %edx,%eax
  803767:	c1 e8 0c             	shr    $0xc,%eax
  80376a:	89 45 e0             	mov    %eax,-0x20(%ebp)
		pageBlockInfoArr[page_index].num_of_free_blocks--;
  80376d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803770:	89 d0                	mov    %edx,%eax
  803772:	01 c0                	add    %eax,%eax
  803774:	01 d0                	add    %edx,%eax
  803776:	c1 e0 02             	shl    $0x2,%eax
  803779:	05 6a 50 80 00       	add    $0x80506a,%eax
  80377e:	66 8b 00             	mov    (%eax),%ax
  803781:	8d 50 ff             	lea    -0x1(%eax),%edx
  803784:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  803787:	89 c8                	mov    %ecx,%eax
  803789:	01 c0                	add    %eax,%eax
  80378b:	01 c8                	add    %ecx,%eax
  80378d:	c1 e0 02             	shl    $0x2,%eax
  803790:	05 6a 50 80 00       	add    $0x80506a,%eax
  803795:	66 89 10             	mov    %dx,(%eax)
		return (void*)block;
  803798:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80379b:	e9 13 03 00 00       	jmp    803ab3 <alloc_block+0x49a>
	}

	if(!LIST_EMPTY(&freePagesList)){
  8037a0:	a1 48 50 80 00       	mov    0x805048,%eax
  8037a5:	85 c0                	test   %eax,%eax
  8037a7:	0f 84 c9 01 00 00    	je     803976 <alloc_block+0x35d>

		struct PageInfoElement *page_info = LIST_FIRST(&freePagesList);
  8037ad:	a1 48 50 80 00       	mov    0x805048,%eax
  8037b2:	89 45 dc             	mov    %eax,-0x24(%ebp)
		LIST_REMOVE(&freePagesList, page_info);
  8037b5:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8037b9:	75 17                	jne    8037d2 <alloc_block+0x1b9>
  8037bb:	83 ec 04             	sub    $0x4,%esp
  8037be:	68 cd 4b 80 00       	push   $0x804bcd
  8037c3:	68 8f 00 00 00       	push   $0x8f
  8037c8:	68 93 4b 80 00       	push   $0x804b93
  8037cd:	e8 34 cb ff ff       	call   800306 <_panic>
  8037d2:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8037d5:	8b 00                	mov    (%eax),%eax
  8037d7:	85 c0                	test   %eax,%eax
  8037d9:	74 10                	je     8037eb <alloc_block+0x1d2>
  8037db:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8037de:	8b 00                	mov    (%eax),%eax
  8037e0:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8037e3:	8b 52 04             	mov    0x4(%edx),%edx
  8037e6:	89 50 04             	mov    %edx,0x4(%eax)
  8037e9:	eb 0b                	jmp    8037f6 <alloc_block+0x1dd>
  8037eb:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8037ee:	8b 40 04             	mov    0x4(%eax),%eax
  8037f1:	a3 4c 50 80 00       	mov    %eax,0x80504c
  8037f6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8037f9:	8b 40 04             	mov    0x4(%eax),%eax
  8037fc:	85 c0                	test   %eax,%eax
  8037fe:	74 0f                	je     80380f <alloc_block+0x1f6>
  803800:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803803:	8b 40 04             	mov    0x4(%eax),%eax
  803806:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803809:	8b 12                	mov    (%edx),%edx
  80380b:	89 10                	mov    %edx,(%eax)
  80380d:	eb 0a                	jmp    803819 <alloc_block+0x200>
  80380f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803812:	8b 00                	mov    (%eax),%eax
  803814:	a3 48 50 80 00       	mov    %eax,0x805048
  803819:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80381c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803822:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803825:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80382c:	a1 54 50 80 00       	mov    0x805054,%eax
  803831:	48                   	dec    %eax
  803832:	a3 54 50 80 00       	mov    %eax,0x805054
		uint32 page_va = to_page_va(page_info);
  803837:	83 ec 0c             	sub    $0xc,%esp
  80383a:	ff 75 dc             	pushl  -0x24(%ebp)
  80383d:	e8 89 fb ff ff       	call   8033cb <to_page_va>
  803842:	83 c4 10             	add    $0x10,%esp
  803845:	89 45 d8             	mov    %eax,-0x28(%ebp)

		uint32 page_index = (page_va - dynAllocStart)/ PAGE_SIZE;
  803848:	a1 64 d0 81 00       	mov    0x81d064,%eax
  80384d:	8b 55 d8             	mov    -0x28(%ebp),%edx
  803850:	29 c2                	sub    %eax,%edx
  803852:	89 d0                	mov    %edx,%eax
  803854:	c1 e8 0c             	shr    $0xc,%eax
  803857:	89 45 d4             	mov    %eax,-0x2c(%ebp)

		get_page((void*)page_va);
  80385a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80385d:	83 ec 0c             	sub    $0xc,%esp
  803860:	50                   	push   %eax
  803861:	e8 fe dc ff ff       	call   801564 <get_page>
  803866:	83 c4 10             	add    $0x10,%esp


		pageBlockInfoArr[page_index].block_size = size;
  803869:	8b 45 08             	mov    0x8(%ebp),%eax
  80386c:	89 c2                	mov    %eax,%edx
  80386e:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  803871:	89 c8                	mov    %ecx,%eax
  803873:	01 c0                	add    %eax,%eax
  803875:	01 c8                	add    %ecx,%eax
  803877:	c1 e0 02             	shl    $0x2,%eax
  80387a:	05 68 50 80 00       	add    $0x805068,%eax
  80387f:	66 89 10             	mov    %dx,(%eax)
		int num_blocks = PAGE_SIZE / size ;
  803882:	b8 00 10 00 00       	mov    $0x1000,%eax
  803887:	ba 00 00 00 00       	mov    $0x0,%edx
  80388c:	f7 75 08             	divl   0x8(%ebp)
  80388f:	89 45 d0             	mov    %eax,-0x30(%ebp)
		pageBlockInfoArr[page_index].num_of_free_blocks= num_blocks - 1 ;
  803892:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803895:	8d 50 ff             	lea    -0x1(%eax),%edx
  803898:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  80389b:	89 c8                	mov    %ecx,%eax
  80389d:	01 c0                	add    %eax,%eax
  80389f:	01 c8                	add    %ecx,%eax
  8038a1:	c1 e0 02             	shl    $0x2,%eax
  8038a4:	05 6a 50 80 00       	add    $0x80506a,%eax
  8038a9:	66 89 10             	mov    %dx,(%eax)

		for(int i=1; i< num_blocks; i++){
  8038ac:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
  8038b3:	e9 aa 00 00 00       	jmp    803962 <alloc_block+0x349>
			struct BlockElement *new_block = (struct BlockElement*)(page_va + i *size);
  8038b8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8038bb:	0f af 45 08          	imul   0x8(%ebp),%eax
  8038bf:	89 c2                	mov    %eax,%edx
  8038c1:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8038c4:	01 d0                	add    %edx,%eax
  8038c6:	89 45 cc             	mov    %eax,-0x34(%ebp)
			LIST_INSERT_TAIL(&freeBlockLists[list_index], new_block);
  8038c9:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  8038cd:	75 17                	jne    8038e6 <alloc_block+0x2cd>
  8038cf:	83 ec 04             	sub    $0x4,%esp
  8038d2:	68 ec 4b 80 00       	push   $0x804bec
  8038d7:	68 9d 00 00 00       	push   $0x9d
  8038dc:	68 93 4b 80 00       	push   $0x804b93
  8038e1:	e8 20 ca ff ff       	call   800306 <_panic>
  8038e6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8038e9:	c1 e0 04             	shl    $0x4,%eax
  8038ec:	05 84 d0 81 00       	add    $0x81d084,%eax
  8038f1:	8b 10                	mov    (%eax),%edx
  8038f3:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8038f6:	89 50 04             	mov    %edx,0x4(%eax)
  8038f9:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8038fc:	8b 40 04             	mov    0x4(%eax),%eax
  8038ff:	85 c0                	test   %eax,%eax
  803901:	74 14                	je     803917 <alloc_block+0x2fe>
  803903:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803906:	c1 e0 04             	shl    $0x4,%eax
  803909:	05 84 d0 81 00       	add    $0x81d084,%eax
  80390e:	8b 00                	mov    (%eax),%eax
  803910:	8b 55 cc             	mov    -0x34(%ebp),%edx
  803913:	89 10                	mov    %edx,(%eax)
  803915:	eb 11                	jmp    803928 <alloc_block+0x30f>
  803917:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80391a:	c1 e0 04             	shl    $0x4,%eax
  80391d:	8d 90 80 d0 81 00    	lea    0x81d080(%eax),%edx
  803923:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803926:	89 02                	mov    %eax,(%edx)
  803928:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80392b:	c1 e0 04             	shl    $0x4,%eax
  80392e:	8d 90 84 d0 81 00    	lea    0x81d084(%eax),%edx
  803934:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803937:	89 02                	mov    %eax,(%edx)
  803939:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80393c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803942:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803945:	c1 e0 04             	shl    $0x4,%eax
  803948:	05 8c d0 81 00       	add    $0x81d08c,%eax
  80394d:	8b 00                	mov    (%eax),%eax
  80394f:	8d 50 01             	lea    0x1(%eax),%edx
  803952:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803955:	c1 e0 04             	shl    $0x4,%eax
  803958:	05 8c d0 81 00       	add    $0x81d08c,%eax
  80395d:	89 10                	mov    %edx,(%eax)

		pageBlockInfoArr[page_index].block_size = size;
		int num_blocks = PAGE_SIZE / size ;
		pageBlockInfoArr[page_index].num_of_free_blocks= num_blocks - 1 ;

		for(int i=1; i< num_blocks; i++){
  80395f:	ff 45 f0             	incl   -0x10(%ebp)
  803962:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803965:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  803968:	0f 8c 4a ff ff ff    	jl     8038b8 <alloc_block+0x29f>
			struct BlockElement *new_block = (struct BlockElement*)(page_va + i *size);
			LIST_INSERT_TAIL(&freeBlockLists[list_index], new_block);
		}
		return(void*)page_va;
  80396e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803971:	e9 3d 01 00 00       	jmp    803ab3 <alloc_block+0x49a>
	}


	for(int i =list_index+1; i<= LOG2_MAX_SIZE - LOG2_MIN_SIZE; i++){
  803976:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803979:	40                   	inc    %eax
  80397a:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80397d:	e9 10 01 00 00       	jmp    803a92 <alloc_block+0x479>

		if(!LIST_EMPTY(&freeBlockLists[i])){
  803982:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803985:	c1 e0 04             	shl    $0x4,%eax
  803988:	05 80 d0 81 00       	add    $0x81d080,%eax
  80398d:	8b 00                	mov    (%eax),%eax
  80398f:	85 c0                	test   %eax,%eax
  803991:	0f 84 f8 00 00 00    	je     803a8f <alloc_block+0x476>

			struct BlockElement *block = LIST_FIRST(&freeBlockLists[i]);
  803997:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80399a:	c1 e0 04             	shl    $0x4,%eax
  80399d:	05 80 d0 81 00       	add    $0x81d080,%eax
  8039a2:	8b 00                	mov    (%eax),%eax
  8039a4:	89 45 c8             	mov    %eax,-0x38(%ebp)
			LIST_REMOVE( &freeBlockLists[i], block);
  8039a7:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8039ab:	75 17                	jne    8039c4 <alloc_block+0x3ab>
  8039ad:	83 ec 04             	sub    $0x4,%esp
  8039b0:	68 cd 4b 80 00       	push   $0x804bcd
  8039b5:	68 a8 00 00 00       	push   $0xa8
  8039ba:	68 93 4b 80 00       	push   $0x804b93
  8039bf:	e8 42 c9 ff ff       	call   800306 <_panic>
  8039c4:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8039c7:	8b 00                	mov    (%eax),%eax
  8039c9:	85 c0                	test   %eax,%eax
  8039cb:	74 10                	je     8039dd <alloc_block+0x3c4>
  8039cd:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8039d0:	8b 00                	mov    (%eax),%eax
  8039d2:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8039d5:	8b 52 04             	mov    0x4(%edx),%edx
  8039d8:	89 50 04             	mov    %edx,0x4(%eax)
  8039db:	eb 14                	jmp    8039f1 <alloc_block+0x3d8>
  8039dd:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8039e0:	8b 40 04             	mov    0x4(%eax),%eax
  8039e3:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8039e6:	c1 e2 04             	shl    $0x4,%edx
  8039e9:	81 c2 84 d0 81 00    	add    $0x81d084,%edx
  8039ef:	89 02                	mov    %eax,(%edx)
  8039f1:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8039f4:	8b 40 04             	mov    0x4(%eax),%eax
  8039f7:	85 c0                	test   %eax,%eax
  8039f9:	74 0f                	je     803a0a <alloc_block+0x3f1>
  8039fb:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8039fe:	8b 40 04             	mov    0x4(%eax),%eax
  803a01:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803a04:	8b 12                	mov    (%edx),%edx
  803a06:	89 10                	mov    %edx,(%eax)
  803a08:	eb 13                	jmp    803a1d <alloc_block+0x404>
  803a0a:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803a0d:	8b 00                	mov    (%eax),%eax
  803a0f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803a12:	c1 e2 04             	shl    $0x4,%edx
  803a15:	81 c2 80 d0 81 00    	add    $0x81d080,%edx
  803a1b:	89 02                	mov    %eax,(%edx)
  803a1d:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803a20:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803a26:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803a29:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803a30:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803a33:	c1 e0 04             	shl    $0x4,%eax
  803a36:	05 8c d0 81 00       	add    $0x81d08c,%eax
  803a3b:	8b 00                	mov    (%eax),%eax
  803a3d:	8d 50 ff             	lea    -0x1(%eax),%edx
  803a40:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803a43:	c1 e0 04             	shl    $0x4,%eax
  803a46:	05 8c d0 81 00       	add    $0x81d08c,%eax
  803a4b:	89 10                	mov    %edx,(%eax)

			uint32 page_index = ((uint32)block - dynAllocStart)/ PAGE_SIZE;
  803a4d:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803a50:	a1 64 d0 81 00       	mov    0x81d064,%eax
  803a55:	29 c2                	sub    %eax,%edx
  803a57:	89 d0                	mov    %edx,%eax
  803a59:	c1 e8 0c             	shr    $0xc,%eax
  803a5c:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			pageBlockInfoArr[page_index].num_of_free_blocks-- ;
  803a5f:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  803a62:	89 d0                	mov    %edx,%eax
  803a64:	01 c0                	add    %eax,%eax
  803a66:	01 d0                	add    %edx,%eax
  803a68:	c1 e0 02             	shl    $0x2,%eax
  803a6b:	05 6a 50 80 00       	add    $0x80506a,%eax
  803a70:	66 8b 00             	mov    (%eax),%ax
  803a73:	8d 50 ff             	lea    -0x1(%eax),%edx
  803a76:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  803a79:	89 c8                	mov    %ecx,%eax
  803a7b:	01 c0                	add    %eax,%eax
  803a7d:	01 c8                	add    %ecx,%eax
  803a7f:	c1 e0 02             	shl    $0x2,%eax
  803a82:	05 6a 50 80 00       	add    $0x80506a,%eax
  803a87:	66 89 10             	mov    %dx,(%eax)

			return (void*)block;
  803a8a:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803a8d:	eb 24                	jmp    803ab3 <alloc_block+0x49a>
		}
		return(void*)page_va;
	}


	for(int i =list_index+1; i<= LOG2_MAX_SIZE - LOG2_MIN_SIZE; i++){
  803a8f:	ff 45 ec             	incl   -0x14(%ebp)
  803a92:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  803a96:	0f 8e e6 fe ff ff    	jle    803982 <alloc_block+0x369>

			return (void*)block;
		}
	}

	panic("alloc_block: out of memory! ");
  803a9c:	83 ec 04             	sub    $0x4,%esp
  803a9f:	68 0f 4c 80 00       	push   $0x804c0f
  803aa4:	68 b1 00 00 00       	push   $0xb1
  803aa9:	68 93 4b 80 00       	push   $0x804b93
  803aae:	e8 53 c8 ff ff       	call   800306 <_panic>

	//Comment the following line
	//panic("alloc_block() Not implemented yet");

	//TODO: [PROJECT'25.BONUS#1] DYNAMIC ALLOCATOR - block if no free block
}
  803ab3:	c9                   	leave  
  803ab4:	c3                   	ret    

00803ab5 <free_block>:

//===========================
// [4] FREE BLOCK:
//===========================
void free_block(void *va)
{
  803ab5:	55                   	push   %ebp
  803ab6:	89 e5                	mov    %esp,%ebp
  803ab8:	83 ec 38             	sub    $0x38,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert((uint32)va >= dynAllocStart && (uint32)va < dynAllocEnd);
  803abb:	8b 55 08             	mov    0x8(%ebp),%edx
  803abe:	a1 64 d0 81 00       	mov    0x81d064,%eax
  803ac3:	39 c2                	cmp    %eax,%edx
  803ac5:	72 0c                	jb     803ad3 <free_block+0x1e>
  803ac7:	8b 55 08             	mov    0x8(%ebp),%edx
  803aca:	a1 40 50 80 00       	mov    0x805040,%eax
  803acf:	39 c2                	cmp    %eax,%edx
  803ad1:	72 19                	jb     803aec <free_block+0x37>
  803ad3:	68 2c 4c 80 00       	push   $0x804c2c
  803ad8:	68 7e 4b 80 00       	push   $0x804b7e
  803add:	68 c3 00 00 00       	push   $0xc3
  803ae2:	68 93 4b 80 00       	push   $0x804b93
  803ae7:	e8 1a c8 ff ff       	call   800306 <_panic>
	//==================================================================================

	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #4 free_block
	//Your code is here

	uint32 page_index=((uint32)va - dynAllocStart)/ PAGE_SIZE;
  803aec:	8b 55 08             	mov    0x8(%ebp),%edx
  803aef:	a1 64 d0 81 00       	mov    0x81d064,%eax
  803af4:	29 c2                	sub    %eax,%edx
  803af6:	89 d0                	mov    %edx,%eax
  803af8:	c1 e8 0c             	shr    $0xc,%eax
  803afb:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 block_size = pageBlockInfoArr[page_index].block_size;
  803afe:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803b01:	89 d0                	mov    %edx,%eax
  803b03:	01 c0                	add    %eax,%eax
  803b05:	01 d0                	add    %edx,%eax
  803b07:	c1 e0 02             	shl    $0x2,%eax
  803b0a:	05 68 50 80 00       	add    $0x805068,%eax
  803b0f:	8b 00                	mov    (%eax),%eax
  803b11:	0f b7 c0             	movzwl %ax,%eax
  803b14:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if(block_size == 0){
  803b17:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803b1b:	75 17                	jne    803b34 <free_block+0x7f>
		panic("page is empty(already not allocated)");
  803b1d:	83 ec 04             	sub    $0x4,%esp
  803b20:	68 64 4c 80 00       	push   $0x804c64
  803b25:	68 cf 00 00 00       	push   $0xcf
  803b2a:	68 93 4b 80 00       	push   $0x804b93
  803b2f:	e8 d2 c7 ff ff       	call   800306 <_panic>
	}

	int list_index = log2(block_size) - LOG2_MIN_SIZE;
  803b34:	83 ec 0c             	sub    $0xc,%esp
  803b37:	ff 75 ec             	pushl  -0x14(%ebp)
  803b3a:	e8 d8 f8 ff ff       	call   803417 <log2>
  803b3f:	83 c4 10             	add    $0x10,%esp
  803b42:	83 e8 03             	sub    $0x3,%eax
  803b45:	89 45 e8             	mov    %eax,-0x18(%ebp)
	// mn va l block "elta7weel mn virtual l phy hna"
	struct BlockElement *block = (struct BlockElement *)va;
  803b48:	8b 45 08             	mov    0x8(%ebp),%eax
  803b4b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	LIST_INSERT_TAIL(&freeBlockLists[list_index], block);
  803b4e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803b52:	75 17                	jne    803b6b <free_block+0xb6>
  803b54:	83 ec 04             	sub    $0x4,%esp
  803b57:	68 ec 4b 80 00       	push   $0x804bec
  803b5c:	68 d5 00 00 00       	push   $0xd5
  803b61:	68 93 4b 80 00       	push   $0x804b93
  803b66:	e8 9b c7 ff ff       	call   800306 <_panic>
  803b6b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803b6e:	c1 e0 04             	shl    $0x4,%eax
  803b71:	05 84 d0 81 00       	add    $0x81d084,%eax
  803b76:	8b 10                	mov    (%eax),%edx
  803b78:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803b7b:	89 50 04             	mov    %edx,0x4(%eax)
  803b7e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803b81:	8b 40 04             	mov    0x4(%eax),%eax
  803b84:	85 c0                	test   %eax,%eax
  803b86:	74 14                	je     803b9c <free_block+0xe7>
  803b88:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803b8b:	c1 e0 04             	shl    $0x4,%eax
  803b8e:	05 84 d0 81 00       	add    $0x81d084,%eax
  803b93:	8b 00                	mov    (%eax),%eax
  803b95:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803b98:	89 10                	mov    %edx,(%eax)
  803b9a:	eb 11                	jmp    803bad <free_block+0xf8>
  803b9c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803b9f:	c1 e0 04             	shl    $0x4,%eax
  803ba2:	8d 90 80 d0 81 00    	lea    0x81d080(%eax),%edx
  803ba8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803bab:	89 02                	mov    %eax,(%edx)
  803bad:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803bb0:	c1 e0 04             	shl    $0x4,%eax
  803bb3:	8d 90 84 d0 81 00    	lea    0x81d084(%eax),%edx
  803bb9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803bbc:	89 02                	mov    %eax,(%edx)
  803bbe:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803bc1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803bc7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803bca:	c1 e0 04             	shl    $0x4,%eax
  803bcd:	05 8c d0 81 00       	add    $0x81d08c,%eax
  803bd2:	8b 00                	mov    (%eax),%eax
  803bd4:	8d 50 01             	lea    0x1(%eax),%edx
  803bd7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803bda:	c1 e0 04             	shl    $0x4,%eax
  803bdd:	05 8c d0 81 00       	add    $0x81d08c,%eax
  803be2:	89 10                	mov    %edx,(%eax)
	// b3d ma wdytha fy el freeBlockLists hzwed elfree elly fy el array 1
	pageBlockInfoArr[page_index].num_of_free_blocks++;
  803be4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803be7:	89 d0                	mov    %edx,%eax
  803be9:	01 c0                	add    %eax,%eax
  803beb:	01 d0                	add    %edx,%eax
  803bed:	c1 e0 02             	shl    $0x2,%eax
  803bf0:	05 6a 50 80 00       	add    $0x80506a,%eax
  803bf5:	66 8b 00             	mov    (%eax),%ax
  803bf8:	8d 50 01             	lea    0x1(%eax),%edx
  803bfb:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  803bfe:	89 c8                	mov    %ecx,%eax
  803c00:	01 c0                	add    %eax,%eax
  803c02:	01 c8                	add    %ecx,%eax
  803c04:	c1 e0 02             	shl    $0x2,%eax
  803c07:	05 6a 50 80 00       	add    $0x80506a,%eax
  803c0c:	66 89 10             	mov    %dx,(%eax)
	int blocks_number = PAGE_SIZE / block_size;
  803c0f:	b8 00 10 00 00       	mov    $0x1000,%eax
  803c14:	ba 00 00 00 00       	mov    $0x0,%edx
  803c19:	f7 75 ec             	divl   -0x14(%ebp)
  803c1c:	89 45 e0             	mov    %eax,-0x20(%ebp)
	if(pageBlockInfoArr[page_index].num_of_free_blocks == blocks_number){
  803c1f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803c22:	89 d0                	mov    %edx,%eax
  803c24:	01 c0                	add    %eax,%eax
  803c26:	01 d0                	add    %edx,%eax
  803c28:	c1 e0 02             	shl    $0x2,%eax
  803c2b:	05 6a 50 80 00       	add    $0x80506a,%eax
  803c30:	66 8b 00             	mov    (%eax),%ax
  803c33:	0f b7 c0             	movzwl %ax,%eax
  803c36:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  803c39:	0f 85 d3 01 00 00    	jne    803e12 <free_block+0x35d>
		struct BlockElement *itr = LIST_FIRST(&freeBlockLists[list_index]);
  803c3f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803c42:	c1 e0 04             	shl    $0x4,%eax
  803c45:	05 80 d0 81 00       	add    $0x81d080,%eax
  803c4a:	8b 00                	mov    (%eax),%eax
  803c4c:	89 45 f4             	mov    %eax,-0xc(%ebp)
		while(itr != NULL){
  803c4f:	e9 f1 00 00 00       	jmp    803d45 <free_block+0x290>
			//lw ms7to el pointer mydy34 ->
			struct BlockElement *next = LIST_NEXT(itr);
  803c54:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c57:	8b 00                	mov    (%eax),%eax
  803c59:	89 45 dc             	mov    %eax,-0x24(%ebp)
			uint32 page_beginning_address= dynAllocStart + page_index * PAGE_SIZE;
  803c5c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803c5f:	c1 e0 0c             	shl    $0xc,%eax
  803c62:	89 c2                	mov    %eax,%edx
  803c64:	a1 64 d0 81 00       	mov    0x81d064,%eax
  803c69:	01 d0                	add    %edx,%eax
  803c6b:	89 45 d8             	mov    %eax,-0x28(%ebp)
			uint32 page_end_address = dynAllocStart + (page_index +1 )* PAGE_SIZE;
  803c6e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803c71:	40                   	inc    %eax
  803c72:	c1 e0 0c             	shl    $0xc,%eax
  803c75:	89 c2                	mov    %eax,%edx
  803c77:	a1 64 d0 81 00       	mov    0x81d064,%eax
  803c7c:	01 d0                	add    %edx,%eax
  803c7e:	89 45 d4             	mov    %eax,-0x2c(%ebp)

			if((uint32)itr >= page_beginning_address && (uint32)itr < page_end_address){
  803c81:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c84:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  803c87:	0f 82 b8 00 00 00    	jb     803d45 <free_block+0x290>
  803c8d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c90:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803c93:	0f 83 ac 00 00 00    	jae    803d45 <free_block+0x290>
				LIST_REMOVE(&freeBlockLists[list_index], itr);
  803c99:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803c9d:	75 17                	jne    803cb6 <free_block+0x201>
  803c9f:	83 ec 04             	sub    $0x4,%esp
  803ca2:	68 cd 4b 80 00       	push   $0x804bcd
  803ca7:	68 e2 00 00 00       	push   $0xe2
  803cac:	68 93 4b 80 00       	push   $0x804b93
  803cb1:	e8 50 c6 ff ff       	call   800306 <_panic>
  803cb6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803cb9:	8b 00                	mov    (%eax),%eax
  803cbb:	85 c0                	test   %eax,%eax
  803cbd:	74 10                	je     803ccf <free_block+0x21a>
  803cbf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803cc2:	8b 00                	mov    (%eax),%eax
  803cc4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803cc7:	8b 52 04             	mov    0x4(%edx),%edx
  803cca:	89 50 04             	mov    %edx,0x4(%eax)
  803ccd:	eb 14                	jmp    803ce3 <free_block+0x22e>
  803ccf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803cd2:	8b 40 04             	mov    0x4(%eax),%eax
  803cd5:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803cd8:	c1 e2 04             	shl    $0x4,%edx
  803cdb:	81 c2 84 d0 81 00    	add    $0x81d084,%edx
  803ce1:	89 02                	mov    %eax,(%edx)
  803ce3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ce6:	8b 40 04             	mov    0x4(%eax),%eax
  803ce9:	85 c0                	test   %eax,%eax
  803ceb:	74 0f                	je     803cfc <free_block+0x247>
  803ced:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803cf0:	8b 40 04             	mov    0x4(%eax),%eax
  803cf3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803cf6:	8b 12                	mov    (%edx),%edx
  803cf8:	89 10                	mov    %edx,(%eax)
  803cfa:	eb 13                	jmp    803d0f <free_block+0x25a>
  803cfc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803cff:	8b 00                	mov    (%eax),%eax
  803d01:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803d04:	c1 e2 04             	shl    $0x4,%edx
  803d07:	81 c2 80 d0 81 00    	add    $0x81d080,%edx
  803d0d:	89 02                	mov    %eax,(%edx)
  803d0f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d12:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803d18:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d1b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803d22:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803d25:	c1 e0 04             	shl    $0x4,%eax
  803d28:	05 8c d0 81 00       	add    $0x81d08c,%eax
  803d2d:	8b 00                	mov    (%eax),%eax
  803d2f:	8d 50 ff             	lea    -0x1(%eax),%edx
  803d32:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803d35:	c1 e0 04             	shl    $0x4,%eax
  803d38:	05 8c d0 81 00       	add    $0x81d08c,%eax
  803d3d:	89 10                	mov    %edx,(%eax)
				//y5o4 3la elly b3do
				itr = next;
  803d3f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803d42:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// b3d ma wdytha fy el freeBlockLists hzwed elfree elly fy el array 1
	pageBlockInfoArr[page_index].num_of_free_blocks++;
	int blocks_number = PAGE_SIZE / block_size;
	if(pageBlockInfoArr[page_index].num_of_free_blocks == blocks_number){
		struct BlockElement *itr = LIST_FIRST(&freeBlockLists[list_index]);
		while(itr != NULL){
  803d45:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803d49:	0f 85 05 ff ff ff    	jne    803c54 <free_block+0x19f>
				LIST_REMOVE(&freeBlockLists[list_index], itr);
				//y5o4 3la elly b3do
				itr = next;
			}
		}
		pageBlockInfoArr[page_index].block_size=0;
  803d4f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803d52:	89 d0                	mov    %edx,%eax
  803d54:	01 c0                	add    %eax,%eax
  803d56:	01 d0                	add    %edx,%eax
  803d58:	c1 e0 02             	shl    $0x2,%eax
  803d5b:	05 68 50 80 00       	add    $0x805068,%eax
  803d60:	66 c7 00 00 00       	movw   $0x0,(%eax)
		pageBlockInfoArr[page_index].num_of_free_blocks=0;
  803d65:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803d68:	89 d0                	mov    %edx,%eax
  803d6a:	01 c0                	add    %eax,%eax
  803d6c:	01 d0                	add    %edx,%eax
  803d6e:	c1 e0 02             	shl    $0x2,%eax
  803d71:	05 6a 50 80 00       	add    $0x80506a,%eax
  803d76:	66 c7 00 00 00       	movw   $0x0,(%eax)

		struct PageInfoElement *page_info = &pageBlockInfoArr[page_index];
  803d7b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803d7e:	89 d0                	mov    %edx,%eax
  803d80:	01 c0                	add    %eax,%eax
  803d82:	01 d0                	add    %edx,%eax
  803d84:	c1 e0 02             	shl    $0x2,%eax
  803d87:	05 60 50 80 00       	add    $0x805060,%eax
  803d8c:	89 45 d0             	mov    %eax,-0x30(%ebp)
		LIST_INSERT_TAIL(&freePagesList, page_info);
  803d8f:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  803d93:	75 17                	jne    803dac <free_block+0x2f7>
  803d95:	83 ec 04             	sub    $0x4,%esp
  803d98:	68 ec 4b 80 00       	push   $0x804bec
  803d9d:	68 eb 00 00 00       	push   $0xeb
  803da2:	68 93 4b 80 00       	push   $0x804b93
  803da7:	e8 5a c5 ff ff       	call   800306 <_panic>
  803dac:	8b 15 4c 50 80 00    	mov    0x80504c,%edx
  803db2:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803db5:	89 50 04             	mov    %edx,0x4(%eax)
  803db8:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803dbb:	8b 40 04             	mov    0x4(%eax),%eax
  803dbe:	85 c0                	test   %eax,%eax
  803dc0:	74 0c                	je     803dce <free_block+0x319>
  803dc2:	a1 4c 50 80 00       	mov    0x80504c,%eax
  803dc7:	8b 55 d0             	mov    -0x30(%ebp),%edx
  803dca:	89 10                	mov    %edx,(%eax)
  803dcc:	eb 08                	jmp    803dd6 <free_block+0x321>
  803dce:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803dd1:	a3 48 50 80 00       	mov    %eax,0x805048
  803dd6:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803dd9:	a3 4c 50 80 00       	mov    %eax,0x80504c
  803dde:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803de1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803de7:	a1 54 50 80 00       	mov    0x805054,%eax
  803dec:	40                   	inc    %eax
  803ded:	a3 54 50 80 00       	mov    %eax,0x805054
		uint32 page_va = to_page_va(page_info);
  803df2:	83 ec 0c             	sub    $0xc,%esp
  803df5:	ff 75 d0             	pushl  -0x30(%ebp)
  803df8:	e8 ce f5 ff ff       	call   8033cb <to_page_va>
  803dfd:	83 c4 10             	add    $0x10,%esp
  803e00:	89 45 cc             	mov    %eax,-0x34(%ebp)
		return_page((void *)page_va);
  803e03:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803e06:	83 ec 0c             	sub    $0xc,%esp
  803e09:	50                   	push   %eax
  803e0a:	e8 9e d7 ff ff       	call   8015ad <return_page>
  803e0f:	83 c4 10             	add    $0x10,%esp
	}


	//Comment the following line
	//panic("free_block() Not implemented yet");
}
  803e12:	90                   	nop
  803e13:	c9                   	leave  
  803e14:	c3                   	ret    

00803e15 <realloc_block>:

//===========================
// [1] REALLOCATE BLOCK:
//===========================
void *realloc_block(void* va, uint32 new_size)
{
  803e15:	55                   	push   %ebp
  803e16:	89 e5                	mov    %esp,%ebp
  803e18:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.BONUS#2] KERNEL REALLOC - realloc_block
	//Your code is here
	//Comment the following line
	panic("realloc_block() Not implemented yet");
  803e1b:	83 ec 04             	sub    $0x4,%esp
  803e1e:	68 8c 4c 80 00       	push   $0x804c8c
  803e23:	68 01 01 00 00       	push   $0x101
  803e28:	68 93 4b 80 00       	push   $0x804b93
  803e2d:	e8 d4 c4 ff ff       	call   800306 <_panic>

00803e32 <init_uspinlock>:
#include "inc/uspinlock.h"

extern volatile struct Env *myEnv;

void init_uspinlock(struct uspinlock *lk, char *name, bool isOpened)
{
  803e32:	55                   	push   %ebp
  803e33:	89 e5                	mov    %esp,%ebp
  803e35:	83 ec 08             	sub    $0x8,%esp
	assert(isOpened == 0 || isOpened == 1);
  803e38:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  803e3c:	74 1c                	je     803e5a <init_uspinlock+0x28>
  803e3e:	83 7d 10 01          	cmpl   $0x1,0x10(%ebp)
  803e42:	74 16                	je     803e5a <init_uspinlock+0x28>
  803e44:	68 b0 4c 80 00       	push   $0x804cb0
  803e49:	68 cf 4c 80 00       	push   $0x804ccf
  803e4e:	6a 10                	push   $0x10
  803e50:	68 e4 4c 80 00       	push   $0x804ce4
  803e55:	e8 ac c4 ff ff       	call   800306 <_panic>
	strcpy(lk->name, name);
  803e5a:	8b 45 08             	mov    0x8(%ebp),%eax
  803e5d:	83 c0 04             	add    $0x4,%eax
  803e60:	83 ec 08             	sub    $0x8,%esp
  803e63:	ff 75 0c             	pushl  0xc(%ebp)
  803e66:	50                   	push   %eax
  803e67:	e8 90 ce ff ff       	call   800cfc <strcpy>
  803e6c:	83 c4 10             	add    $0x10,%esp
	lk->locked = (1 - isOpened);
  803e6f:	b8 01 00 00 00       	mov    $0x1,%eax
  803e74:	2b 45 10             	sub    0x10(%ebp),%eax
  803e77:	89 c2                	mov    %eax,%edx
  803e79:	8b 45 08             	mov    0x8(%ebp),%eax
  803e7c:	89 10                	mov    %edx,(%eax)
}
  803e7e:	90                   	nop
  803e7f:	c9                   	leave  
  803e80:	c3                   	ret    

00803e81 <acquire_uspinlock>:
// Acquire the lock.
// Loops (spins) until the lock is acquired.
// Holding a lock for a long time may cause
// other CPUs to waste time spinning to acquire it.
void acquire_uspinlock(struct uspinlock *lk)
{
  803e81:	55                   	push   %ebp
  803e82:	89 e5                	mov    %esp,%ebp
  803e84:	83 ec 18             	sub    $0x18,%esp
	// The xchg is atomic.
	while(xchg(&lk->locked, 1) != 0) ;
  803e87:	90                   	nop
  803e88:	8b 45 08             	mov    0x8(%ebp),%eax
  803e8b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803e8e:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
xchg(volatile uint32 *addr, uint32 newval)
{
  uint32 result;

  // The + in "+m" denotes a read-modify-write operand.
  __asm __volatile("lock; xchgl %0, %1" :
  803e95:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803e98:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803e9b:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  803e9e:	f0 87 02             	lock xchg %eax,(%edx)
  803ea1:	89 45 ec             	mov    %eax,-0x14(%ebp)
               "+m" (*addr), "=a" (result) :
               "1" (newval) :
               "cc");
  return result;
  803ea4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803ea7:	85 c0                	test   %eax,%eax
  803ea9:	75 dd                	jne    803e88 <acquire_uspinlock+0x7>

	cprintf("[%d: %s] ACQUIRED spinlock [%s]\n", myEnv->env_id, myEnv->prog_name, lk->name);
  803eab:	8b 45 08             	mov    0x8(%ebp),%eax
  803eae:	8d 48 04             	lea    0x4(%eax),%ecx
  803eb1:	a1 20 50 80 00       	mov    0x805020,%eax
  803eb6:	8d 50 20             	lea    0x20(%eax),%edx
  803eb9:	a1 20 50 80 00       	mov    0x805020,%eax
  803ebe:	8b 40 10             	mov    0x10(%eax),%eax
  803ec1:	51                   	push   %ecx
  803ec2:	52                   	push   %edx
  803ec3:	50                   	push   %eax
  803ec4:	68 f4 4c 80 00       	push   $0x804cf4
  803ec9:	e8 06 c7 ff ff       	call   8005d4 <cprintf>
  803ece:	83 c4 10             	add    $0x10,%esp

	// Tell the C compiler and the processor to not move loads or stores
	// past this point, to ensure that the critical section's memory
	// references happen after the lock is acquired.
	__sync_synchronize();
  803ed1:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
}
  803ed6:	90                   	nop
  803ed7:	c9                   	leave  
  803ed8:	c3                   	ret    

00803ed9 <release_uspinlock>:

// Release the lock.
void release_uspinlock(struct uspinlock *lk)
{
  803ed9:	55                   	push   %ebp
  803eda:	89 e5                	mov    %esp,%ebp
  803edc:	83 ec 08             	sub    $0x8,%esp
	if(!(lk->locked))
  803edf:	8b 45 08             	mov    0x8(%ebp),%eax
  803ee2:	8b 00                	mov    (%eax),%eax
  803ee4:	85 c0                	test   %eax,%eax
  803ee6:	75 18                	jne    803f00 <release_uspinlock+0x27>
	{
		panic("release: lock \"%s\" is not held!", lk->name);
  803ee8:	8b 45 08             	mov    0x8(%ebp),%eax
  803eeb:	83 c0 04             	add    $0x4,%eax
  803eee:	50                   	push   %eax
  803eef:	68 18 4d 80 00       	push   $0x804d18
  803ef4:	6a 2b                	push   $0x2b
  803ef6:	68 e4 4c 80 00       	push   $0x804ce4
  803efb:	e8 06 c4 ff ff       	call   800306 <_panic>
	// Tell the C compiler and the processor to not move loads or stores
	// past this point, to ensure that all the stores in the critical
	// section are visible to other cores before the lock is released.
	// Both the C compiler and the hardware may re-order loads and
	// stores; __sync_synchronize() tells them both not to.
	__sync_synchronize();
  803f00:	f0 83 0c 24 00       	lock orl $0x0,(%esp)

	// Release the lock, equivalent to lk->locked = 0.
	// This code can't use a C assignment, since it might
	// not be atomic. A real OS would use C atomics here.
	asm volatile("movl $0, %0" : "+m" (lk->locked) : );
  803f05:	8b 45 08             	mov    0x8(%ebp),%eax
  803f08:	8b 55 08             	mov    0x8(%ebp),%edx
  803f0b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	cprintf("[%d: %s] RELEASED spinlock [%s]\n", myEnv->env_id, myEnv->prog_name, lk->name);
  803f11:	8b 45 08             	mov    0x8(%ebp),%eax
  803f14:	8d 48 04             	lea    0x4(%eax),%ecx
  803f17:	a1 20 50 80 00       	mov    0x805020,%eax
  803f1c:	8d 50 20             	lea    0x20(%eax),%edx
  803f1f:	a1 20 50 80 00       	mov    0x805020,%eax
  803f24:	8b 40 10             	mov    0x10(%eax),%eax
  803f27:	51                   	push   %ecx
  803f28:	52                   	push   %edx
  803f29:	50                   	push   %eax
  803f2a:	68 38 4d 80 00       	push   $0x804d38
  803f2f:	e8 a0 c6 ff ff       	call   8005d4 <cprintf>
  803f34:	83 c4 10             	add    $0x10,%esp
}
  803f37:	90                   	nop
  803f38:	c9                   	leave  
  803f39:	c3                   	ret    
  803f3a:	66 90                	xchg   %ax,%ax

00803f3c <__udivdi3>:
  803f3c:	55                   	push   %ebp
  803f3d:	57                   	push   %edi
  803f3e:	56                   	push   %esi
  803f3f:	53                   	push   %ebx
  803f40:	83 ec 1c             	sub    $0x1c,%esp
  803f43:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803f47:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803f4b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803f4f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803f53:	89 ca                	mov    %ecx,%edx
  803f55:	89 f8                	mov    %edi,%eax
  803f57:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803f5b:	85 f6                	test   %esi,%esi
  803f5d:	75 2d                	jne    803f8c <__udivdi3+0x50>
  803f5f:	39 cf                	cmp    %ecx,%edi
  803f61:	77 65                	ja     803fc8 <__udivdi3+0x8c>
  803f63:	89 fd                	mov    %edi,%ebp
  803f65:	85 ff                	test   %edi,%edi
  803f67:	75 0b                	jne    803f74 <__udivdi3+0x38>
  803f69:	b8 01 00 00 00       	mov    $0x1,%eax
  803f6e:	31 d2                	xor    %edx,%edx
  803f70:	f7 f7                	div    %edi
  803f72:	89 c5                	mov    %eax,%ebp
  803f74:	31 d2                	xor    %edx,%edx
  803f76:	89 c8                	mov    %ecx,%eax
  803f78:	f7 f5                	div    %ebp
  803f7a:	89 c1                	mov    %eax,%ecx
  803f7c:	89 d8                	mov    %ebx,%eax
  803f7e:	f7 f5                	div    %ebp
  803f80:	89 cf                	mov    %ecx,%edi
  803f82:	89 fa                	mov    %edi,%edx
  803f84:	83 c4 1c             	add    $0x1c,%esp
  803f87:	5b                   	pop    %ebx
  803f88:	5e                   	pop    %esi
  803f89:	5f                   	pop    %edi
  803f8a:	5d                   	pop    %ebp
  803f8b:	c3                   	ret    
  803f8c:	39 ce                	cmp    %ecx,%esi
  803f8e:	77 28                	ja     803fb8 <__udivdi3+0x7c>
  803f90:	0f bd fe             	bsr    %esi,%edi
  803f93:	83 f7 1f             	xor    $0x1f,%edi
  803f96:	75 40                	jne    803fd8 <__udivdi3+0x9c>
  803f98:	39 ce                	cmp    %ecx,%esi
  803f9a:	72 0a                	jb     803fa6 <__udivdi3+0x6a>
  803f9c:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803fa0:	0f 87 9e 00 00 00    	ja     804044 <__udivdi3+0x108>
  803fa6:	b8 01 00 00 00       	mov    $0x1,%eax
  803fab:	89 fa                	mov    %edi,%edx
  803fad:	83 c4 1c             	add    $0x1c,%esp
  803fb0:	5b                   	pop    %ebx
  803fb1:	5e                   	pop    %esi
  803fb2:	5f                   	pop    %edi
  803fb3:	5d                   	pop    %ebp
  803fb4:	c3                   	ret    
  803fb5:	8d 76 00             	lea    0x0(%esi),%esi
  803fb8:	31 ff                	xor    %edi,%edi
  803fba:	31 c0                	xor    %eax,%eax
  803fbc:	89 fa                	mov    %edi,%edx
  803fbe:	83 c4 1c             	add    $0x1c,%esp
  803fc1:	5b                   	pop    %ebx
  803fc2:	5e                   	pop    %esi
  803fc3:	5f                   	pop    %edi
  803fc4:	5d                   	pop    %ebp
  803fc5:	c3                   	ret    
  803fc6:	66 90                	xchg   %ax,%ax
  803fc8:	89 d8                	mov    %ebx,%eax
  803fca:	f7 f7                	div    %edi
  803fcc:	31 ff                	xor    %edi,%edi
  803fce:	89 fa                	mov    %edi,%edx
  803fd0:	83 c4 1c             	add    $0x1c,%esp
  803fd3:	5b                   	pop    %ebx
  803fd4:	5e                   	pop    %esi
  803fd5:	5f                   	pop    %edi
  803fd6:	5d                   	pop    %ebp
  803fd7:	c3                   	ret    
  803fd8:	bd 20 00 00 00       	mov    $0x20,%ebp
  803fdd:	89 eb                	mov    %ebp,%ebx
  803fdf:	29 fb                	sub    %edi,%ebx
  803fe1:	89 f9                	mov    %edi,%ecx
  803fe3:	d3 e6                	shl    %cl,%esi
  803fe5:	89 c5                	mov    %eax,%ebp
  803fe7:	88 d9                	mov    %bl,%cl
  803fe9:	d3 ed                	shr    %cl,%ebp
  803feb:	89 e9                	mov    %ebp,%ecx
  803fed:	09 f1                	or     %esi,%ecx
  803fef:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803ff3:	89 f9                	mov    %edi,%ecx
  803ff5:	d3 e0                	shl    %cl,%eax
  803ff7:	89 c5                	mov    %eax,%ebp
  803ff9:	89 d6                	mov    %edx,%esi
  803ffb:	88 d9                	mov    %bl,%cl
  803ffd:	d3 ee                	shr    %cl,%esi
  803fff:	89 f9                	mov    %edi,%ecx
  804001:	d3 e2                	shl    %cl,%edx
  804003:	8b 44 24 08          	mov    0x8(%esp),%eax
  804007:	88 d9                	mov    %bl,%cl
  804009:	d3 e8                	shr    %cl,%eax
  80400b:	09 c2                	or     %eax,%edx
  80400d:	89 d0                	mov    %edx,%eax
  80400f:	89 f2                	mov    %esi,%edx
  804011:	f7 74 24 0c          	divl   0xc(%esp)
  804015:	89 d6                	mov    %edx,%esi
  804017:	89 c3                	mov    %eax,%ebx
  804019:	f7 e5                	mul    %ebp
  80401b:	39 d6                	cmp    %edx,%esi
  80401d:	72 19                	jb     804038 <__udivdi3+0xfc>
  80401f:	74 0b                	je     80402c <__udivdi3+0xf0>
  804021:	89 d8                	mov    %ebx,%eax
  804023:	31 ff                	xor    %edi,%edi
  804025:	e9 58 ff ff ff       	jmp    803f82 <__udivdi3+0x46>
  80402a:	66 90                	xchg   %ax,%ax
  80402c:	8b 54 24 08          	mov    0x8(%esp),%edx
  804030:	89 f9                	mov    %edi,%ecx
  804032:	d3 e2                	shl    %cl,%edx
  804034:	39 c2                	cmp    %eax,%edx
  804036:	73 e9                	jae    804021 <__udivdi3+0xe5>
  804038:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80403b:	31 ff                	xor    %edi,%edi
  80403d:	e9 40 ff ff ff       	jmp    803f82 <__udivdi3+0x46>
  804042:	66 90                	xchg   %ax,%ax
  804044:	31 c0                	xor    %eax,%eax
  804046:	e9 37 ff ff ff       	jmp    803f82 <__udivdi3+0x46>
  80404b:	90                   	nop

0080404c <__umoddi3>:
  80404c:	55                   	push   %ebp
  80404d:	57                   	push   %edi
  80404e:	56                   	push   %esi
  80404f:	53                   	push   %ebx
  804050:	83 ec 1c             	sub    $0x1c,%esp
  804053:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  804057:	8b 74 24 34          	mov    0x34(%esp),%esi
  80405b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80405f:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  804063:	89 44 24 0c          	mov    %eax,0xc(%esp)
  804067:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80406b:	89 f3                	mov    %esi,%ebx
  80406d:	89 fa                	mov    %edi,%edx
  80406f:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  804073:	89 34 24             	mov    %esi,(%esp)
  804076:	85 c0                	test   %eax,%eax
  804078:	75 1a                	jne    804094 <__umoddi3+0x48>
  80407a:	39 f7                	cmp    %esi,%edi
  80407c:	0f 86 a2 00 00 00    	jbe    804124 <__umoddi3+0xd8>
  804082:	89 c8                	mov    %ecx,%eax
  804084:	89 f2                	mov    %esi,%edx
  804086:	f7 f7                	div    %edi
  804088:	89 d0                	mov    %edx,%eax
  80408a:	31 d2                	xor    %edx,%edx
  80408c:	83 c4 1c             	add    $0x1c,%esp
  80408f:	5b                   	pop    %ebx
  804090:	5e                   	pop    %esi
  804091:	5f                   	pop    %edi
  804092:	5d                   	pop    %ebp
  804093:	c3                   	ret    
  804094:	39 f0                	cmp    %esi,%eax
  804096:	0f 87 ac 00 00 00    	ja     804148 <__umoddi3+0xfc>
  80409c:	0f bd e8             	bsr    %eax,%ebp
  80409f:	83 f5 1f             	xor    $0x1f,%ebp
  8040a2:	0f 84 ac 00 00 00    	je     804154 <__umoddi3+0x108>
  8040a8:	bf 20 00 00 00       	mov    $0x20,%edi
  8040ad:	29 ef                	sub    %ebp,%edi
  8040af:	89 fe                	mov    %edi,%esi
  8040b1:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8040b5:	89 e9                	mov    %ebp,%ecx
  8040b7:	d3 e0                	shl    %cl,%eax
  8040b9:	89 d7                	mov    %edx,%edi
  8040bb:	89 f1                	mov    %esi,%ecx
  8040bd:	d3 ef                	shr    %cl,%edi
  8040bf:	09 c7                	or     %eax,%edi
  8040c1:	89 e9                	mov    %ebp,%ecx
  8040c3:	d3 e2                	shl    %cl,%edx
  8040c5:	89 14 24             	mov    %edx,(%esp)
  8040c8:	89 d8                	mov    %ebx,%eax
  8040ca:	d3 e0                	shl    %cl,%eax
  8040cc:	89 c2                	mov    %eax,%edx
  8040ce:	8b 44 24 08          	mov    0x8(%esp),%eax
  8040d2:	d3 e0                	shl    %cl,%eax
  8040d4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8040d8:	8b 44 24 08          	mov    0x8(%esp),%eax
  8040dc:	89 f1                	mov    %esi,%ecx
  8040de:	d3 e8                	shr    %cl,%eax
  8040e0:	09 d0                	or     %edx,%eax
  8040e2:	d3 eb                	shr    %cl,%ebx
  8040e4:	89 da                	mov    %ebx,%edx
  8040e6:	f7 f7                	div    %edi
  8040e8:	89 d3                	mov    %edx,%ebx
  8040ea:	f7 24 24             	mull   (%esp)
  8040ed:	89 c6                	mov    %eax,%esi
  8040ef:	89 d1                	mov    %edx,%ecx
  8040f1:	39 d3                	cmp    %edx,%ebx
  8040f3:	0f 82 87 00 00 00    	jb     804180 <__umoddi3+0x134>
  8040f9:	0f 84 91 00 00 00    	je     804190 <__umoddi3+0x144>
  8040ff:	8b 54 24 04          	mov    0x4(%esp),%edx
  804103:	29 f2                	sub    %esi,%edx
  804105:	19 cb                	sbb    %ecx,%ebx
  804107:	89 d8                	mov    %ebx,%eax
  804109:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  80410d:	d3 e0                	shl    %cl,%eax
  80410f:	89 e9                	mov    %ebp,%ecx
  804111:	d3 ea                	shr    %cl,%edx
  804113:	09 d0                	or     %edx,%eax
  804115:	89 e9                	mov    %ebp,%ecx
  804117:	d3 eb                	shr    %cl,%ebx
  804119:	89 da                	mov    %ebx,%edx
  80411b:	83 c4 1c             	add    $0x1c,%esp
  80411e:	5b                   	pop    %ebx
  80411f:	5e                   	pop    %esi
  804120:	5f                   	pop    %edi
  804121:	5d                   	pop    %ebp
  804122:	c3                   	ret    
  804123:	90                   	nop
  804124:	89 fd                	mov    %edi,%ebp
  804126:	85 ff                	test   %edi,%edi
  804128:	75 0b                	jne    804135 <__umoddi3+0xe9>
  80412a:	b8 01 00 00 00       	mov    $0x1,%eax
  80412f:	31 d2                	xor    %edx,%edx
  804131:	f7 f7                	div    %edi
  804133:	89 c5                	mov    %eax,%ebp
  804135:	89 f0                	mov    %esi,%eax
  804137:	31 d2                	xor    %edx,%edx
  804139:	f7 f5                	div    %ebp
  80413b:	89 c8                	mov    %ecx,%eax
  80413d:	f7 f5                	div    %ebp
  80413f:	89 d0                	mov    %edx,%eax
  804141:	e9 44 ff ff ff       	jmp    80408a <__umoddi3+0x3e>
  804146:	66 90                	xchg   %ax,%ax
  804148:	89 c8                	mov    %ecx,%eax
  80414a:	89 f2                	mov    %esi,%edx
  80414c:	83 c4 1c             	add    $0x1c,%esp
  80414f:	5b                   	pop    %ebx
  804150:	5e                   	pop    %esi
  804151:	5f                   	pop    %edi
  804152:	5d                   	pop    %ebp
  804153:	c3                   	ret    
  804154:	3b 04 24             	cmp    (%esp),%eax
  804157:	72 06                	jb     80415f <__umoddi3+0x113>
  804159:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  80415d:	77 0f                	ja     80416e <__umoddi3+0x122>
  80415f:	89 f2                	mov    %esi,%edx
  804161:	29 f9                	sub    %edi,%ecx
  804163:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  804167:	89 14 24             	mov    %edx,(%esp)
  80416a:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80416e:	8b 44 24 04          	mov    0x4(%esp),%eax
  804172:	8b 14 24             	mov    (%esp),%edx
  804175:	83 c4 1c             	add    $0x1c,%esp
  804178:	5b                   	pop    %ebx
  804179:	5e                   	pop    %esi
  80417a:	5f                   	pop    %edi
  80417b:	5d                   	pop    %ebp
  80417c:	c3                   	ret    
  80417d:	8d 76 00             	lea    0x0(%esi),%esi
  804180:	2b 04 24             	sub    (%esp),%eax
  804183:	19 fa                	sbb    %edi,%edx
  804185:	89 d1                	mov    %edx,%ecx
  804187:	89 c6                	mov    %eax,%esi
  804189:	e9 71 ff ff ff       	jmp    8040ff <__umoddi3+0xb3>
  80418e:	66 90                	xchg   %ax,%ax
  804190:	39 44 24 04          	cmp    %eax,0x4(%esp)
  804194:	72 ea                	jb     804180 <__umoddi3+0x134>
  804196:	89 d9                	mov    %ebx,%ecx
  804198:	e9 62 ff ff ff       	jmp    8040ff <__umoddi3+0xb3>
