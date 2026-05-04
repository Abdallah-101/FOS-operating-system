
obj/user/ef_tst_semaphore_1slave:     file format elf32-i386


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
  800031:	e8 fa 00 00 00       	call   800130 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
// Slave program: enter critical section, print it's ID, exit and signal the master program
#include <inc/lib.h>

void
_main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	83 ec 28             	sub    $0x28,%esp
	int32 parentenvID = sys_getparentenvid();
  80003e:	e8 5a 17 00 00       	call   80179d <sys_getparentenvid>
  800043:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int id = sys_getenvindex();
  800046:	e8 39 17 00 00       	call   801784 <sys_getenvindex>
  80004b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("%d: before the critical section\n", id);
  80004e:	83 ec 08             	sub    $0x8,%esp
  800051:	ff 75 f0             	pushl  -0x10(%ebp)
  800054:	68 e0 1d 80 00       	push   $0x801de0
  800059:	e8 59 05 00 00       	call   8005b7 <cprintf>
  80005e:	83 c4 10             	add    $0x10,%esp

	struct semaphore cs1 = get_semaphore(parentenvID, "cs1");
  800061:	8d 45 e8             	lea    -0x18(%ebp),%eax
  800064:	83 ec 04             	sub    $0x4,%esp
  800067:	68 01 1e 80 00       	push   $0x801e01
  80006c:	ff 75 f4             	pushl  -0xc(%ebp)
  80006f:	50                   	push   %eax
  800070:	e8 ec 19 00 00       	call   801a61 <get_semaphore>
  800075:	83 c4 0c             	add    $0xc,%esp
	struct semaphore depend1 = get_semaphore(parentenvID, "depend1");
  800078:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80007b:	83 ec 04             	sub    $0x4,%esp
  80007e:	68 05 1e 80 00       	push   $0x801e05
  800083:	ff 75 f4             	pushl  -0xc(%ebp)
  800086:	50                   	push   %eax
  800087:	e8 d5 19 00 00       	call   801a61 <get_semaphore>
  80008c:	83 c4 0c             	add    $0xc,%esp

	wait_semaphore(cs1);
  80008f:	83 ec 0c             	sub    $0xc,%esp
  800092:	ff 75 e8             	pushl  -0x18(%ebp)
  800095:	e8 e1 19 00 00       	call   801a7b <wait_semaphore>
  80009a:	83 c4 10             	add    $0x10,%esp
	{
		cprintf("%d: inside the critical section\n", id) ;
  80009d:	83 ec 08             	sub    $0x8,%esp
  8000a0:	ff 75 f0             	pushl  -0x10(%ebp)
  8000a3:	68 10 1e 80 00       	push   $0x801e10
  8000a8:	e8 0a 05 00 00       	call   8005b7 <cprintf>
  8000ad:	83 c4 10             	add    $0x10,%esp
		cprintf("my ID is %d\n", id);
  8000b0:	83 ec 08             	sub    $0x8,%esp
  8000b3:	ff 75 f0             	pushl  -0x10(%ebp)
  8000b6:	68 31 1e 80 00       	push   $0x801e31
  8000bb:	e8 f7 04 00 00       	call   8005b7 <cprintf>
  8000c0:	83 c4 10             	add    $0x10,%esp
		int sem1val = semaphore_count(cs1);
  8000c3:	83 ec 0c             	sub    $0xc,%esp
  8000c6:	ff 75 e8             	pushl  -0x18(%ebp)
  8000c9:	e8 e1 19 00 00       	call   801aaf <semaphore_count>
  8000ce:	83 c4 10             	add    $0x10,%esp
  8000d1:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (sem1val > 0)
  8000d4:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8000d8:	7e 14                	jle    8000ee <_main+0xb6>
			panic("Error: more than 1 process inside the CS... please review your semaphore code again...");
  8000da:	83 ec 04             	sub    $0x4,%esp
  8000dd:	68 40 1e 80 00       	push   $0x801e40
  8000e2:	6a 15                	push   $0x15
  8000e4:	68 98 1e 80 00       	push   $0x801e98
  8000e9:	e8 fb 01 00 00       	call   8002e9 <_panic>
		env_sleep(1000) ;
  8000ee:	83 ec 0c             	sub    $0xc,%esp
  8000f1:	68 e8 03 00 00       	push   $0x3e8
  8000f6:	e8 bf 19 00 00       	call   801aba <env_sleep>
  8000fb:	83 c4 10             	add    $0x10,%esp
	}
	signal_semaphore(cs1);
  8000fe:	83 ec 0c             	sub    $0xc,%esp
  800101:	ff 75 e8             	pushl  -0x18(%ebp)
  800104:	e8 8c 19 00 00       	call   801a95 <signal_semaphore>
  800109:	83 c4 10             	add    $0x10,%esp

	cprintf("%d: after the critical section\n", id);
  80010c:	83 ec 08             	sub    $0x8,%esp
  80010f:	ff 75 f0             	pushl  -0x10(%ebp)
  800112:	68 b8 1e 80 00       	push   $0x801eb8
  800117:	e8 9b 04 00 00       	call   8005b7 <cprintf>
  80011c:	83 c4 10             	add    $0x10,%esp
	signal_semaphore(depend1);
  80011f:	83 ec 0c             	sub    $0xc,%esp
  800122:	ff 75 e4             	pushl  -0x1c(%ebp)
  800125:	e8 6b 19 00 00       	call   801a95 <signal_semaphore>
  80012a:	83 c4 10             	add    $0x10,%esp
	return;
  80012d:	90                   	nop
}
  80012e:	c9                   	leave  
  80012f:	c3                   	ret    

00800130 <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  800130:	55                   	push   %ebp
  800131:	89 e5                	mov    %esp,%ebp
  800133:	57                   	push   %edi
  800134:	56                   	push   %esi
  800135:	53                   	push   %ebx
  800136:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  800139:	e8 46 16 00 00       	call   801784 <sys_getenvindex>
  80013e:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  800141:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800144:	89 d0                	mov    %edx,%eax
  800146:	c1 e0 02             	shl    $0x2,%eax
  800149:	01 d0                	add    %edx,%eax
  80014b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800152:	01 d0                	add    %edx,%eax
  800154:	89 c2                	mov    %eax,%edx
  800156:	c1 e2 04             	shl    $0x4,%edx
  800159:	29 c2                	sub    %eax,%edx
  80015b:	8d 04 95 00 00 00 00 	lea    0x0(,%edx,4),%eax
  800162:	89 c2                	mov    %eax,%edx
  800164:	8d 82 00 00 c0 ee    	lea    -0x11400000(%edx),%eax
  80016a:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  80016f:	a1 20 30 80 00       	mov    0x803020,%eax
  800174:	8a 40 20             	mov    0x20(%eax),%al
  800177:	84 c0                	test   %al,%al
  800179:	74 0d                	je     800188 <libmain+0x58>
		binaryname = myEnv->prog_name;
  80017b:	a1 20 30 80 00       	mov    0x803020,%eax
  800180:	83 c0 20             	add    $0x20,%eax
  800183:	a3 04 30 80 00       	mov    %eax,0x803004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800188:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80018c:	7e 0a                	jle    800198 <libmain+0x68>
		binaryname = argv[0];
  80018e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800191:	8b 00                	mov    (%eax),%eax
  800193:	a3 04 30 80 00       	mov    %eax,0x803004

	// call user main routine
	_main(argc, argv);
  800198:	83 ec 08             	sub    $0x8,%esp
  80019b:	ff 75 0c             	pushl  0xc(%ebp)
  80019e:	ff 75 08             	pushl  0x8(%ebp)
  8001a1:	e8 92 fe ff ff       	call   800038 <_main>
  8001a6:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  8001a9:	a1 00 30 80 00       	mov    0x803000,%eax
  8001ae:	85 c0                	test   %eax,%eax
  8001b0:	0f 84 01 01 00 00    	je     8002b7 <libmain+0x187>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  8001b6:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  8001bc:	bb d0 1f 80 00       	mov    $0x801fd0,%ebx
  8001c1:	ba 0e 00 00 00       	mov    $0xe,%edx
  8001c6:	89 c7                	mov    %eax,%edi
  8001c8:	89 de                	mov    %ebx,%esi
  8001ca:	89 d1                	mov    %edx,%ecx
  8001cc:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  8001ce:	8d 55 8a             	lea    -0x76(%ebp),%edx
  8001d1:	b9 56 00 00 00       	mov    $0x56,%ecx
  8001d6:	b0 00                	mov    $0x0,%al
  8001d8:	89 d7                	mov    %edx,%edi
  8001da:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  8001dc:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  8001e3:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8001e6:	83 ec 08             	sub    $0x8,%esp
  8001e9:	50                   	push   %eax
  8001ea:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  8001f0:	50                   	push   %eax
  8001f1:	e8 c4 17 00 00       	call   8019ba <sys_utilities>
  8001f6:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  8001f9:	e8 0d 13 00 00       	call   80150b <sys_lock_cons>
		{
			cprintf("**************************************\n");
  8001fe:	83 ec 0c             	sub    $0xc,%esp
  800201:	68 f0 1e 80 00       	push   $0x801ef0
  800206:	e8 ac 03 00 00       	call   8005b7 <cprintf>
  80020b:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  80020e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800211:	85 c0                	test   %eax,%eax
  800213:	74 18                	je     80022d <libmain+0xfd>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  800215:	e8 be 17 00 00       	call   8019d8 <sys_get_optimal_num_faults>
  80021a:	83 ec 08             	sub    $0x8,%esp
  80021d:	50                   	push   %eax
  80021e:	68 18 1f 80 00       	push   $0x801f18
  800223:	e8 8f 03 00 00       	call   8005b7 <cprintf>
  800228:	83 c4 10             	add    $0x10,%esp
  80022b:	eb 59                	jmp    800286 <libmain+0x156>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  80022d:	a1 20 30 80 00       	mov    0x803020,%eax
  800232:	8b 90 bc 05 00 00    	mov    0x5bc(%eax),%edx
  800238:	a1 20 30 80 00       	mov    0x803020,%eax
  80023d:	8b 80 ac 05 00 00    	mov    0x5ac(%eax),%eax
  800243:	83 ec 04             	sub    $0x4,%esp
  800246:	52                   	push   %edx
  800247:	50                   	push   %eax
  800248:	68 3c 1f 80 00       	push   $0x801f3c
  80024d:	e8 65 03 00 00       	call   8005b7 <cprintf>
  800252:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800255:	a1 20 30 80 00       	mov    0x803020,%eax
  80025a:	8b 88 d0 05 00 00    	mov    0x5d0(%eax),%ecx
  800260:	a1 20 30 80 00       	mov    0x803020,%eax
  800265:	8b 90 cc 05 00 00    	mov    0x5cc(%eax),%edx
  80026b:	a1 20 30 80 00       	mov    0x803020,%eax
  800270:	8b 80 c8 05 00 00    	mov    0x5c8(%eax),%eax
  800276:	51                   	push   %ecx
  800277:	52                   	push   %edx
  800278:	50                   	push   %eax
  800279:	68 64 1f 80 00       	push   $0x801f64
  80027e:	e8 34 03 00 00       	call   8005b7 <cprintf>
  800283:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800286:	a1 20 30 80 00       	mov    0x803020,%eax
  80028b:	8b 80 d4 05 00 00    	mov    0x5d4(%eax),%eax
  800291:	83 ec 08             	sub    $0x8,%esp
  800294:	50                   	push   %eax
  800295:	68 bc 1f 80 00       	push   $0x801fbc
  80029a:	e8 18 03 00 00       	call   8005b7 <cprintf>
  80029f:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  8002a2:	83 ec 0c             	sub    $0xc,%esp
  8002a5:	68 f0 1e 80 00       	push   $0x801ef0
  8002aa:	e8 08 03 00 00       	call   8005b7 <cprintf>
  8002af:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  8002b2:	e8 6e 12 00 00       	call   801525 <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  8002b7:	e8 1f 00 00 00       	call   8002db <exit>
}
  8002bc:	90                   	nop
  8002bd:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002c0:	5b                   	pop    %ebx
  8002c1:	5e                   	pop    %esi
  8002c2:	5f                   	pop    %edi
  8002c3:	5d                   	pop    %ebp
  8002c4:	c3                   	ret    

008002c5 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8002c5:	55                   	push   %ebp
  8002c6:	89 e5                	mov    %esp,%ebp
  8002c8:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8002cb:	83 ec 0c             	sub    $0xc,%esp
  8002ce:	6a 00                	push   $0x0
  8002d0:	e8 7b 14 00 00       	call   801750 <sys_destroy_env>
  8002d5:	83 c4 10             	add    $0x10,%esp
}
  8002d8:	90                   	nop
  8002d9:	c9                   	leave  
  8002da:	c3                   	ret    

008002db <exit>:

void
exit(void)
{
  8002db:	55                   	push   %ebp
  8002dc:	89 e5                	mov    %esp,%ebp
  8002de:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8002e1:	e8 d0 14 00 00       	call   8017b6 <sys_exit_env>
}
  8002e6:	90                   	nop
  8002e7:	c9                   	leave  
  8002e8:	c3                   	ret    

008002e9 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8002e9:	55                   	push   %ebp
  8002ea:	89 e5                	mov    %esp,%ebp
  8002ec:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8002ef:	8d 45 10             	lea    0x10(%ebp),%eax
  8002f2:	83 c0 04             	add    $0x4,%eax
  8002f5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8002f8:	a1 18 b1 81 00       	mov    0x81b118,%eax
  8002fd:	85 c0                	test   %eax,%eax
  8002ff:	74 16                	je     800317 <_panic+0x2e>
		cprintf("%s: ", argv0);
  800301:	a1 18 b1 81 00       	mov    0x81b118,%eax
  800306:	83 ec 08             	sub    $0x8,%esp
  800309:	50                   	push   %eax
  80030a:	68 34 20 80 00       	push   $0x802034
  80030f:	e8 a3 02 00 00       	call   8005b7 <cprintf>
  800314:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  800317:	a1 04 30 80 00       	mov    0x803004,%eax
  80031c:	83 ec 0c             	sub    $0xc,%esp
  80031f:	ff 75 0c             	pushl  0xc(%ebp)
  800322:	ff 75 08             	pushl  0x8(%ebp)
  800325:	50                   	push   %eax
  800326:	68 3c 20 80 00       	push   $0x80203c
  80032b:	6a 74                	push   $0x74
  80032d:	e8 b2 02 00 00       	call   8005e4 <cprintf_colored>
  800332:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  800335:	8b 45 10             	mov    0x10(%ebp),%eax
  800338:	83 ec 08             	sub    $0x8,%esp
  80033b:	ff 75 f4             	pushl  -0xc(%ebp)
  80033e:	50                   	push   %eax
  80033f:	e8 04 02 00 00       	call   800548 <vcprintf>
  800344:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800347:	83 ec 08             	sub    $0x8,%esp
  80034a:	6a 00                	push   $0x0
  80034c:	68 64 20 80 00       	push   $0x802064
  800351:	e8 f2 01 00 00       	call   800548 <vcprintf>
  800356:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800359:	e8 7d ff ff ff       	call   8002db <exit>

	// should not return here
	while (1) ;
  80035e:	eb fe                	jmp    80035e <_panic+0x75>

00800360 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800360:	55                   	push   %ebp
  800361:	89 e5                	mov    %esp,%ebp
  800363:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800366:	a1 20 30 80 00       	mov    0x803020,%eax
  80036b:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800371:	8b 45 0c             	mov    0xc(%ebp),%eax
  800374:	39 c2                	cmp    %eax,%edx
  800376:	74 14                	je     80038c <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800378:	83 ec 04             	sub    $0x4,%esp
  80037b:	68 68 20 80 00       	push   $0x802068
  800380:	6a 26                	push   $0x26
  800382:	68 b4 20 80 00       	push   $0x8020b4
  800387:	e8 5d ff ff ff       	call   8002e9 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  80038c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800393:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80039a:	e9 c5 00 00 00       	jmp    800464 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  80039f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003a2:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8003ac:	01 d0                	add    %edx,%eax
  8003ae:	8b 00                	mov    (%eax),%eax
  8003b0:	85 c0                	test   %eax,%eax
  8003b2:	75 08                	jne    8003bc <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  8003b4:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8003b7:	e9 a5 00 00 00       	jmp    800461 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  8003bc:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8003c3:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8003ca:	eb 69                	jmp    800435 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8003cc:	a1 20 30 80 00       	mov    0x803020,%eax
  8003d1:	8b 88 a4 05 00 00    	mov    0x5a4(%eax),%ecx
  8003d7:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8003da:	89 d0                	mov    %edx,%eax
  8003dc:	01 c0                	add    %eax,%eax
  8003de:	01 d0                	add    %edx,%eax
  8003e0:	c1 e0 03             	shl    $0x3,%eax
  8003e3:	01 c8                	add    %ecx,%eax
  8003e5:	8a 40 04             	mov    0x4(%eax),%al
  8003e8:	84 c0                	test   %al,%al
  8003ea:	75 46                	jne    800432 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8003ec:	a1 20 30 80 00       	mov    0x803020,%eax
  8003f1:	8b 88 a4 05 00 00    	mov    0x5a4(%eax),%ecx
  8003f7:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8003fa:	89 d0                	mov    %edx,%eax
  8003fc:	01 c0                	add    %eax,%eax
  8003fe:	01 d0                	add    %edx,%eax
  800400:	c1 e0 03             	shl    $0x3,%eax
  800403:	01 c8                	add    %ecx,%eax
  800405:	8b 00                	mov    (%eax),%eax
  800407:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80040a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80040d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800412:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800414:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800417:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80041e:	8b 45 08             	mov    0x8(%ebp),%eax
  800421:	01 c8                	add    %ecx,%eax
  800423:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800425:	39 c2                	cmp    %eax,%edx
  800427:	75 09                	jne    800432 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  800429:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800430:	eb 15                	jmp    800447 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800432:	ff 45 e8             	incl   -0x18(%ebp)
  800435:	a1 20 30 80 00       	mov    0x803020,%eax
  80043a:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800440:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800443:	39 c2                	cmp    %eax,%edx
  800445:	77 85                	ja     8003cc <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800447:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80044b:	75 14                	jne    800461 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  80044d:	83 ec 04             	sub    $0x4,%esp
  800450:	68 c0 20 80 00       	push   $0x8020c0
  800455:	6a 3a                	push   $0x3a
  800457:	68 b4 20 80 00       	push   $0x8020b4
  80045c:	e8 88 fe ff ff       	call   8002e9 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800461:	ff 45 f0             	incl   -0x10(%ebp)
  800464:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800467:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80046a:	0f 8c 2f ff ff ff    	jl     80039f <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800470:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800477:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80047e:	eb 26                	jmp    8004a6 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800480:	a1 20 30 80 00       	mov    0x803020,%eax
  800485:	8b 88 a4 05 00 00    	mov    0x5a4(%eax),%ecx
  80048b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80048e:	89 d0                	mov    %edx,%eax
  800490:	01 c0                	add    %eax,%eax
  800492:	01 d0                	add    %edx,%eax
  800494:	c1 e0 03             	shl    $0x3,%eax
  800497:	01 c8                	add    %ecx,%eax
  800499:	8a 40 04             	mov    0x4(%eax),%al
  80049c:	3c 01                	cmp    $0x1,%al
  80049e:	75 03                	jne    8004a3 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  8004a0:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8004a3:	ff 45 e0             	incl   -0x20(%ebp)
  8004a6:	a1 20 30 80 00       	mov    0x803020,%eax
  8004ab:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8004b1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8004b4:	39 c2                	cmp    %eax,%edx
  8004b6:	77 c8                	ja     800480 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8004b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8004bb:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8004be:	74 14                	je     8004d4 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  8004c0:	83 ec 04             	sub    $0x4,%esp
  8004c3:	68 14 21 80 00       	push   $0x802114
  8004c8:	6a 44                	push   $0x44
  8004ca:	68 b4 20 80 00       	push   $0x8020b4
  8004cf:	e8 15 fe ff ff       	call   8002e9 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8004d4:	90                   	nop
  8004d5:	c9                   	leave  
  8004d6:	c3                   	ret    

008004d7 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  8004d7:	55                   	push   %ebp
  8004d8:	89 e5                	mov    %esp,%ebp
  8004da:	53                   	push   %ebx
  8004db:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  8004de:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004e1:	8b 00                	mov    (%eax),%eax
  8004e3:	8d 48 01             	lea    0x1(%eax),%ecx
  8004e6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004e9:	89 0a                	mov    %ecx,(%edx)
  8004eb:	8b 55 08             	mov    0x8(%ebp),%edx
  8004ee:	88 d1                	mov    %dl,%cl
  8004f0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004f3:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8004f7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004fa:	8b 00                	mov    (%eax),%eax
  8004fc:	3d ff 00 00 00       	cmp    $0xff,%eax
  800501:	75 30                	jne    800533 <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  800503:	8b 15 1c b1 81 00    	mov    0x81b11c,%edx
  800509:	a0 44 30 80 00       	mov    0x803044,%al
  80050e:	0f b6 c0             	movzbl %al,%eax
  800511:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800514:	8b 09                	mov    (%ecx),%ecx
  800516:	89 cb                	mov    %ecx,%ebx
  800518:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80051b:	83 c1 08             	add    $0x8,%ecx
  80051e:	52                   	push   %edx
  80051f:	50                   	push   %eax
  800520:	53                   	push   %ebx
  800521:	51                   	push   %ecx
  800522:	e8 a0 0f 00 00       	call   8014c7 <sys_cputs>
  800527:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  80052a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80052d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800533:	8b 45 0c             	mov    0xc(%ebp),%eax
  800536:	8b 40 04             	mov    0x4(%eax),%eax
  800539:	8d 50 01             	lea    0x1(%eax),%edx
  80053c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80053f:	89 50 04             	mov    %edx,0x4(%eax)
}
  800542:	90                   	nop
  800543:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800546:	c9                   	leave  
  800547:	c3                   	ret    

00800548 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800548:	55                   	push   %ebp
  800549:	89 e5                	mov    %esp,%ebp
  80054b:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800551:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800558:	00 00 00 
	b.cnt = 0;
  80055b:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800562:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800565:	ff 75 0c             	pushl  0xc(%ebp)
  800568:	ff 75 08             	pushl  0x8(%ebp)
  80056b:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800571:	50                   	push   %eax
  800572:	68 d7 04 80 00       	push   $0x8004d7
  800577:	e8 5a 02 00 00       	call   8007d6 <vprintfmt>
  80057c:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  80057f:	8b 15 1c b1 81 00    	mov    0x81b11c,%edx
  800585:	a0 44 30 80 00       	mov    0x803044,%al
  80058a:	0f b6 c0             	movzbl %al,%eax
  80058d:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  800593:	52                   	push   %edx
  800594:	50                   	push   %eax
  800595:	51                   	push   %ecx
  800596:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80059c:	83 c0 08             	add    $0x8,%eax
  80059f:	50                   	push   %eax
  8005a0:	e8 22 0f 00 00       	call   8014c7 <sys_cputs>
  8005a5:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8005a8:	c6 05 44 30 80 00 00 	movb   $0x0,0x803044
	return b.cnt;
  8005af:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8005b5:	c9                   	leave  
  8005b6:	c3                   	ret    

008005b7 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  8005b7:	55                   	push   %ebp
  8005b8:	89 e5                	mov    %esp,%ebp
  8005ba:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8005bd:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
	va_start(ap, fmt);
  8005c4:	8d 45 0c             	lea    0xc(%ebp),%eax
  8005c7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8005ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8005cd:	83 ec 08             	sub    $0x8,%esp
  8005d0:	ff 75 f4             	pushl  -0xc(%ebp)
  8005d3:	50                   	push   %eax
  8005d4:	e8 6f ff ff ff       	call   800548 <vcprintf>
  8005d9:	83 c4 10             	add    $0x10,%esp
  8005dc:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8005df:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8005e2:	c9                   	leave  
  8005e3:	c3                   	ret    

008005e4 <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  8005e4:	55                   	push   %ebp
  8005e5:	89 e5                	mov    %esp,%ebp
  8005e7:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8005ea:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
	curTextClr = (textClr << 8) ; //set text color by the given value
  8005f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8005f4:	c1 e0 08             	shl    $0x8,%eax
  8005f7:	a3 1c b1 81 00       	mov    %eax,0x81b11c
	va_start(ap, fmt);
  8005fc:	8d 45 0c             	lea    0xc(%ebp),%eax
  8005ff:	83 c0 04             	add    $0x4,%eax
  800602:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800605:	8b 45 0c             	mov    0xc(%ebp),%eax
  800608:	83 ec 08             	sub    $0x8,%esp
  80060b:	ff 75 f4             	pushl  -0xc(%ebp)
  80060e:	50                   	push   %eax
  80060f:	e8 34 ff ff ff       	call   800548 <vcprintf>
  800614:	83 c4 10             	add    $0x10,%esp
  800617:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  80061a:	c7 05 1c b1 81 00 00 	movl   $0x700,0x81b11c
  800621:	07 00 00 

	return cnt;
  800624:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800627:	c9                   	leave  
  800628:	c3                   	ret    

00800629 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  800629:	55                   	push   %ebp
  80062a:	89 e5                	mov    %esp,%ebp
  80062c:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  80062f:	e8 d7 0e 00 00       	call   80150b <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  800634:	8d 45 0c             	lea    0xc(%ebp),%eax
  800637:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  80063a:	8b 45 08             	mov    0x8(%ebp),%eax
  80063d:	83 ec 08             	sub    $0x8,%esp
  800640:	ff 75 f4             	pushl  -0xc(%ebp)
  800643:	50                   	push   %eax
  800644:	e8 ff fe ff ff       	call   800548 <vcprintf>
  800649:	83 c4 10             	add    $0x10,%esp
  80064c:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  80064f:	e8 d1 0e 00 00       	call   801525 <sys_unlock_cons>
	return cnt;
  800654:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800657:	c9                   	leave  
  800658:	c3                   	ret    

00800659 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800659:	55                   	push   %ebp
  80065a:	89 e5                	mov    %esp,%ebp
  80065c:	53                   	push   %ebx
  80065d:	83 ec 14             	sub    $0x14,%esp
  800660:	8b 45 10             	mov    0x10(%ebp),%eax
  800663:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800666:	8b 45 14             	mov    0x14(%ebp),%eax
  800669:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80066c:	8b 45 18             	mov    0x18(%ebp),%eax
  80066f:	ba 00 00 00 00       	mov    $0x0,%edx
  800674:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800677:	77 55                	ja     8006ce <printnum+0x75>
  800679:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80067c:	72 05                	jb     800683 <printnum+0x2a>
  80067e:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800681:	77 4b                	ja     8006ce <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800683:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800686:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800689:	8b 45 18             	mov    0x18(%ebp),%eax
  80068c:	ba 00 00 00 00       	mov    $0x0,%edx
  800691:	52                   	push   %edx
  800692:	50                   	push   %eax
  800693:	ff 75 f4             	pushl  -0xc(%ebp)
  800696:	ff 75 f0             	pushl  -0x10(%ebp)
  800699:	e8 da 14 00 00       	call   801b78 <__udivdi3>
  80069e:	83 c4 10             	add    $0x10,%esp
  8006a1:	83 ec 04             	sub    $0x4,%esp
  8006a4:	ff 75 20             	pushl  0x20(%ebp)
  8006a7:	53                   	push   %ebx
  8006a8:	ff 75 18             	pushl  0x18(%ebp)
  8006ab:	52                   	push   %edx
  8006ac:	50                   	push   %eax
  8006ad:	ff 75 0c             	pushl  0xc(%ebp)
  8006b0:	ff 75 08             	pushl  0x8(%ebp)
  8006b3:	e8 a1 ff ff ff       	call   800659 <printnum>
  8006b8:	83 c4 20             	add    $0x20,%esp
  8006bb:	eb 1a                	jmp    8006d7 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8006bd:	83 ec 08             	sub    $0x8,%esp
  8006c0:	ff 75 0c             	pushl  0xc(%ebp)
  8006c3:	ff 75 20             	pushl  0x20(%ebp)
  8006c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8006c9:	ff d0                	call   *%eax
  8006cb:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8006ce:	ff 4d 1c             	decl   0x1c(%ebp)
  8006d1:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  8006d5:	7f e6                	jg     8006bd <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8006d7:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8006da:	bb 00 00 00 00       	mov    $0x0,%ebx
  8006df:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8006e2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8006e5:	53                   	push   %ebx
  8006e6:	51                   	push   %ecx
  8006e7:	52                   	push   %edx
  8006e8:	50                   	push   %eax
  8006e9:	e8 9a 15 00 00       	call   801c88 <__umoddi3>
  8006ee:	83 c4 10             	add    $0x10,%esp
  8006f1:	05 74 23 80 00       	add    $0x802374,%eax
  8006f6:	8a 00                	mov    (%eax),%al
  8006f8:	0f be c0             	movsbl %al,%eax
  8006fb:	83 ec 08             	sub    $0x8,%esp
  8006fe:	ff 75 0c             	pushl  0xc(%ebp)
  800701:	50                   	push   %eax
  800702:	8b 45 08             	mov    0x8(%ebp),%eax
  800705:	ff d0                	call   *%eax
  800707:	83 c4 10             	add    $0x10,%esp
}
  80070a:	90                   	nop
  80070b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80070e:	c9                   	leave  
  80070f:	c3                   	ret    

00800710 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800710:	55                   	push   %ebp
  800711:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800713:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800717:	7e 1c                	jle    800735 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800719:	8b 45 08             	mov    0x8(%ebp),%eax
  80071c:	8b 00                	mov    (%eax),%eax
  80071e:	8d 50 08             	lea    0x8(%eax),%edx
  800721:	8b 45 08             	mov    0x8(%ebp),%eax
  800724:	89 10                	mov    %edx,(%eax)
  800726:	8b 45 08             	mov    0x8(%ebp),%eax
  800729:	8b 00                	mov    (%eax),%eax
  80072b:	83 e8 08             	sub    $0x8,%eax
  80072e:	8b 50 04             	mov    0x4(%eax),%edx
  800731:	8b 00                	mov    (%eax),%eax
  800733:	eb 40                	jmp    800775 <getuint+0x65>
	else if (lflag)
  800735:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800739:	74 1e                	je     800759 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  80073b:	8b 45 08             	mov    0x8(%ebp),%eax
  80073e:	8b 00                	mov    (%eax),%eax
  800740:	8d 50 04             	lea    0x4(%eax),%edx
  800743:	8b 45 08             	mov    0x8(%ebp),%eax
  800746:	89 10                	mov    %edx,(%eax)
  800748:	8b 45 08             	mov    0x8(%ebp),%eax
  80074b:	8b 00                	mov    (%eax),%eax
  80074d:	83 e8 04             	sub    $0x4,%eax
  800750:	8b 00                	mov    (%eax),%eax
  800752:	ba 00 00 00 00       	mov    $0x0,%edx
  800757:	eb 1c                	jmp    800775 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800759:	8b 45 08             	mov    0x8(%ebp),%eax
  80075c:	8b 00                	mov    (%eax),%eax
  80075e:	8d 50 04             	lea    0x4(%eax),%edx
  800761:	8b 45 08             	mov    0x8(%ebp),%eax
  800764:	89 10                	mov    %edx,(%eax)
  800766:	8b 45 08             	mov    0x8(%ebp),%eax
  800769:	8b 00                	mov    (%eax),%eax
  80076b:	83 e8 04             	sub    $0x4,%eax
  80076e:	8b 00                	mov    (%eax),%eax
  800770:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800775:	5d                   	pop    %ebp
  800776:	c3                   	ret    

00800777 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800777:	55                   	push   %ebp
  800778:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80077a:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80077e:	7e 1c                	jle    80079c <getint+0x25>
		return va_arg(*ap, long long);
  800780:	8b 45 08             	mov    0x8(%ebp),%eax
  800783:	8b 00                	mov    (%eax),%eax
  800785:	8d 50 08             	lea    0x8(%eax),%edx
  800788:	8b 45 08             	mov    0x8(%ebp),%eax
  80078b:	89 10                	mov    %edx,(%eax)
  80078d:	8b 45 08             	mov    0x8(%ebp),%eax
  800790:	8b 00                	mov    (%eax),%eax
  800792:	83 e8 08             	sub    $0x8,%eax
  800795:	8b 50 04             	mov    0x4(%eax),%edx
  800798:	8b 00                	mov    (%eax),%eax
  80079a:	eb 38                	jmp    8007d4 <getint+0x5d>
	else if (lflag)
  80079c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8007a0:	74 1a                	je     8007bc <getint+0x45>
		return va_arg(*ap, long);
  8007a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8007a5:	8b 00                	mov    (%eax),%eax
  8007a7:	8d 50 04             	lea    0x4(%eax),%edx
  8007aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8007ad:	89 10                	mov    %edx,(%eax)
  8007af:	8b 45 08             	mov    0x8(%ebp),%eax
  8007b2:	8b 00                	mov    (%eax),%eax
  8007b4:	83 e8 04             	sub    $0x4,%eax
  8007b7:	8b 00                	mov    (%eax),%eax
  8007b9:	99                   	cltd   
  8007ba:	eb 18                	jmp    8007d4 <getint+0x5d>
	else
		return va_arg(*ap, int);
  8007bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8007bf:	8b 00                	mov    (%eax),%eax
  8007c1:	8d 50 04             	lea    0x4(%eax),%edx
  8007c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8007c7:	89 10                	mov    %edx,(%eax)
  8007c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8007cc:	8b 00                	mov    (%eax),%eax
  8007ce:	83 e8 04             	sub    $0x4,%eax
  8007d1:	8b 00                	mov    (%eax),%eax
  8007d3:	99                   	cltd   
}
  8007d4:	5d                   	pop    %ebp
  8007d5:	c3                   	ret    

008007d6 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8007d6:	55                   	push   %ebp
  8007d7:	89 e5                	mov    %esp,%ebp
  8007d9:	56                   	push   %esi
  8007da:	53                   	push   %ebx
  8007db:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8007de:	eb 17                	jmp    8007f7 <vprintfmt+0x21>
			if (ch == '\0')
  8007e0:	85 db                	test   %ebx,%ebx
  8007e2:	0f 84 c1 03 00 00    	je     800ba9 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  8007e8:	83 ec 08             	sub    $0x8,%esp
  8007eb:	ff 75 0c             	pushl  0xc(%ebp)
  8007ee:	53                   	push   %ebx
  8007ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8007f2:	ff d0                	call   *%eax
  8007f4:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8007f7:	8b 45 10             	mov    0x10(%ebp),%eax
  8007fa:	8d 50 01             	lea    0x1(%eax),%edx
  8007fd:	89 55 10             	mov    %edx,0x10(%ebp)
  800800:	8a 00                	mov    (%eax),%al
  800802:	0f b6 d8             	movzbl %al,%ebx
  800805:	83 fb 25             	cmp    $0x25,%ebx
  800808:	75 d6                	jne    8007e0 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  80080a:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  80080e:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800815:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80081c:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800823:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80082a:	8b 45 10             	mov    0x10(%ebp),%eax
  80082d:	8d 50 01             	lea    0x1(%eax),%edx
  800830:	89 55 10             	mov    %edx,0x10(%ebp)
  800833:	8a 00                	mov    (%eax),%al
  800835:	0f b6 d8             	movzbl %al,%ebx
  800838:	8d 43 dd             	lea    -0x23(%ebx),%eax
  80083b:	83 f8 5b             	cmp    $0x5b,%eax
  80083e:	0f 87 3d 03 00 00    	ja     800b81 <vprintfmt+0x3ab>
  800844:	8b 04 85 98 23 80 00 	mov    0x802398(,%eax,4),%eax
  80084b:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  80084d:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800851:	eb d7                	jmp    80082a <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800853:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800857:	eb d1                	jmp    80082a <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800859:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800860:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800863:	89 d0                	mov    %edx,%eax
  800865:	c1 e0 02             	shl    $0x2,%eax
  800868:	01 d0                	add    %edx,%eax
  80086a:	01 c0                	add    %eax,%eax
  80086c:	01 d8                	add    %ebx,%eax
  80086e:	83 e8 30             	sub    $0x30,%eax
  800871:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800874:	8b 45 10             	mov    0x10(%ebp),%eax
  800877:	8a 00                	mov    (%eax),%al
  800879:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  80087c:	83 fb 2f             	cmp    $0x2f,%ebx
  80087f:	7e 3e                	jle    8008bf <vprintfmt+0xe9>
  800881:	83 fb 39             	cmp    $0x39,%ebx
  800884:	7f 39                	jg     8008bf <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800886:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800889:	eb d5                	jmp    800860 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  80088b:	8b 45 14             	mov    0x14(%ebp),%eax
  80088e:	83 c0 04             	add    $0x4,%eax
  800891:	89 45 14             	mov    %eax,0x14(%ebp)
  800894:	8b 45 14             	mov    0x14(%ebp),%eax
  800897:	83 e8 04             	sub    $0x4,%eax
  80089a:	8b 00                	mov    (%eax),%eax
  80089c:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  80089f:	eb 1f                	jmp    8008c0 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8008a1:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008a5:	79 83                	jns    80082a <vprintfmt+0x54>
				width = 0;
  8008a7:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8008ae:	e9 77 ff ff ff       	jmp    80082a <vprintfmt+0x54>

		case '#':
			altflag = 1;
  8008b3:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  8008ba:	e9 6b ff ff ff       	jmp    80082a <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  8008bf:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8008c0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008c4:	0f 89 60 ff ff ff    	jns    80082a <vprintfmt+0x54>
				width = precision, precision = -1;
  8008ca:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8008cd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8008d0:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  8008d7:	e9 4e ff ff ff       	jmp    80082a <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8008dc:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  8008df:	e9 46 ff ff ff       	jmp    80082a <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8008e4:	8b 45 14             	mov    0x14(%ebp),%eax
  8008e7:	83 c0 04             	add    $0x4,%eax
  8008ea:	89 45 14             	mov    %eax,0x14(%ebp)
  8008ed:	8b 45 14             	mov    0x14(%ebp),%eax
  8008f0:	83 e8 04             	sub    $0x4,%eax
  8008f3:	8b 00                	mov    (%eax),%eax
  8008f5:	83 ec 08             	sub    $0x8,%esp
  8008f8:	ff 75 0c             	pushl  0xc(%ebp)
  8008fb:	50                   	push   %eax
  8008fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ff:	ff d0                	call   *%eax
  800901:	83 c4 10             	add    $0x10,%esp
			break;
  800904:	e9 9b 02 00 00       	jmp    800ba4 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800909:	8b 45 14             	mov    0x14(%ebp),%eax
  80090c:	83 c0 04             	add    $0x4,%eax
  80090f:	89 45 14             	mov    %eax,0x14(%ebp)
  800912:	8b 45 14             	mov    0x14(%ebp),%eax
  800915:	83 e8 04             	sub    $0x4,%eax
  800918:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  80091a:	85 db                	test   %ebx,%ebx
  80091c:	79 02                	jns    800920 <vprintfmt+0x14a>
				err = -err;
  80091e:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800920:	83 fb 64             	cmp    $0x64,%ebx
  800923:	7f 0b                	jg     800930 <vprintfmt+0x15a>
  800925:	8b 34 9d e0 21 80 00 	mov    0x8021e0(,%ebx,4),%esi
  80092c:	85 f6                	test   %esi,%esi
  80092e:	75 19                	jne    800949 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800930:	53                   	push   %ebx
  800931:	68 85 23 80 00       	push   $0x802385
  800936:	ff 75 0c             	pushl  0xc(%ebp)
  800939:	ff 75 08             	pushl  0x8(%ebp)
  80093c:	e8 70 02 00 00       	call   800bb1 <printfmt>
  800941:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800944:	e9 5b 02 00 00       	jmp    800ba4 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800949:	56                   	push   %esi
  80094a:	68 8e 23 80 00       	push   $0x80238e
  80094f:	ff 75 0c             	pushl  0xc(%ebp)
  800952:	ff 75 08             	pushl  0x8(%ebp)
  800955:	e8 57 02 00 00       	call   800bb1 <printfmt>
  80095a:	83 c4 10             	add    $0x10,%esp
			break;
  80095d:	e9 42 02 00 00       	jmp    800ba4 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800962:	8b 45 14             	mov    0x14(%ebp),%eax
  800965:	83 c0 04             	add    $0x4,%eax
  800968:	89 45 14             	mov    %eax,0x14(%ebp)
  80096b:	8b 45 14             	mov    0x14(%ebp),%eax
  80096e:	83 e8 04             	sub    $0x4,%eax
  800971:	8b 30                	mov    (%eax),%esi
  800973:	85 f6                	test   %esi,%esi
  800975:	75 05                	jne    80097c <vprintfmt+0x1a6>
				p = "(null)";
  800977:	be 91 23 80 00       	mov    $0x802391,%esi
			if (width > 0 && padc != '-')
  80097c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800980:	7e 6d                	jle    8009ef <vprintfmt+0x219>
  800982:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800986:	74 67                	je     8009ef <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800988:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80098b:	83 ec 08             	sub    $0x8,%esp
  80098e:	50                   	push   %eax
  80098f:	56                   	push   %esi
  800990:	e8 1e 03 00 00       	call   800cb3 <strnlen>
  800995:	83 c4 10             	add    $0x10,%esp
  800998:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  80099b:	eb 16                	jmp    8009b3 <vprintfmt+0x1dd>
					putch(padc, putdat);
  80099d:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  8009a1:	83 ec 08             	sub    $0x8,%esp
  8009a4:	ff 75 0c             	pushl  0xc(%ebp)
  8009a7:	50                   	push   %eax
  8009a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ab:	ff d0                	call   *%eax
  8009ad:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8009b0:	ff 4d e4             	decl   -0x1c(%ebp)
  8009b3:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8009b7:	7f e4                	jg     80099d <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8009b9:	eb 34                	jmp    8009ef <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  8009bb:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8009bf:	74 1c                	je     8009dd <vprintfmt+0x207>
  8009c1:	83 fb 1f             	cmp    $0x1f,%ebx
  8009c4:	7e 05                	jle    8009cb <vprintfmt+0x1f5>
  8009c6:	83 fb 7e             	cmp    $0x7e,%ebx
  8009c9:	7e 12                	jle    8009dd <vprintfmt+0x207>
					putch('?', putdat);
  8009cb:	83 ec 08             	sub    $0x8,%esp
  8009ce:	ff 75 0c             	pushl  0xc(%ebp)
  8009d1:	6a 3f                	push   $0x3f
  8009d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8009d6:	ff d0                	call   *%eax
  8009d8:	83 c4 10             	add    $0x10,%esp
  8009db:	eb 0f                	jmp    8009ec <vprintfmt+0x216>
				else
					putch(ch, putdat);
  8009dd:	83 ec 08             	sub    $0x8,%esp
  8009e0:	ff 75 0c             	pushl  0xc(%ebp)
  8009e3:	53                   	push   %ebx
  8009e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8009e7:	ff d0                	call   *%eax
  8009e9:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8009ec:	ff 4d e4             	decl   -0x1c(%ebp)
  8009ef:	89 f0                	mov    %esi,%eax
  8009f1:	8d 70 01             	lea    0x1(%eax),%esi
  8009f4:	8a 00                	mov    (%eax),%al
  8009f6:	0f be d8             	movsbl %al,%ebx
  8009f9:	85 db                	test   %ebx,%ebx
  8009fb:	74 24                	je     800a21 <vprintfmt+0x24b>
  8009fd:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800a01:	78 b8                	js     8009bb <vprintfmt+0x1e5>
  800a03:	ff 4d e0             	decl   -0x20(%ebp)
  800a06:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800a0a:	79 af                	jns    8009bb <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800a0c:	eb 13                	jmp    800a21 <vprintfmt+0x24b>
				putch(' ', putdat);
  800a0e:	83 ec 08             	sub    $0x8,%esp
  800a11:	ff 75 0c             	pushl  0xc(%ebp)
  800a14:	6a 20                	push   $0x20
  800a16:	8b 45 08             	mov    0x8(%ebp),%eax
  800a19:	ff d0                	call   *%eax
  800a1b:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800a1e:	ff 4d e4             	decl   -0x1c(%ebp)
  800a21:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a25:	7f e7                	jg     800a0e <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800a27:	e9 78 01 00 00       	jmp    800ba4 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800a2c:	83 ec 08             	sub    $0x8,%esp
  800a2f:	ff 75 e8             	pushl  -0x18(%ebp)
  800a32:	8d 45 14             	lea    0x14(%ebp),%eax
  800a35:	50                   	push   %eax
  800a36:	e8 3c fd ff ff       	call   800777 <getint>
  800a3b:	83 c4 10             	add    $0x10,%esp
  800a3e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a41:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800a44:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a47:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a4a:	85 d2                	test   %edx,%edx
  800a4c:	79 23                	jns    800a71 <vprintfmt+0x29b>
				putch('-', putdat);
  800a4e:	83 ec 08             	sub    $0x8,%esp
  800a51:	ff 75 0c             	pushl  0xc(%ebp)
  800a54:	6a 2d                	push   $0x2d
  800a56:	8b 45 08             	mov    0x8(%ebp),%eax
  800a59:	ff d0                	call   *%eax
  800a5b:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800a5e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a61:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a64:	f7 d8                	neg    %eax
  800a66:	83 d2 00             	adc    $0x0,%edx
  800a69:	f7 da                	neg    %edx
  800a6b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a6e:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800a71:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800a78:	e9 bc 00 00 00       	jmp    800b39 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800a7d:	83 ec 08             	sub    $0x8,%esp
  800a80:	ff 75 e8             	pushl  -0x18(%ebp)
  800a83:	8d 45 14             	lea    0x14(%ebp),%eax
  800a86:	50                   	push   %eax
  800a87:	e8 84 fc ff ff       	call   800710 <getuint>
  800a8c:	83 c4 10             	add    $0x10,%esp
  800a8f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a92:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800a95:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800a9c:	e9 98 00 00 00       	jmp    800b39 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800aa1:	83 ec 08             	sub    $0x8,%esp
  800aa4:	ff 75 0c             	pushl  0xc(%ebp)
  800aa7:	6a 58                	push   $0x58
  800aa9:	8b 45 08             	mov    0x8(%ebp),%eax
  800aac:	ff d0                	call   *%eax
  800aae:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800ab1:	83 ec 08             	sub    $0x8,%esp
  800ab4:	ff 75 0c             	pushl  0xc(%ebp)
  800ab7:	6a 58                	push   $0x58
  800ab9:	8b 45 08             	mov    0x8(%ebp),%eax
  800abc:	ff d0                	call   *%eax
  800abe:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800ac1:	83 ec 08             	sub    $0x8,%esp
  800ac4:	ff 75 0c             	pushl  0xc(%ebp)
  800ac7:	6a 58                	push   $0x58
  800ac9:	8b 45 08             	mov    0x8(%ebp),%eax
  800acc:	ff d0                	call   *%eax
  800ace:	83 c4 10             	add    $0x10,%esp
			break;
  800ad1:	e9 ce 00 00 00       	jmp    800ba4 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800ad6:	83 ec 08             	sub    $0x8,%esp
  800ad9:	ff 75 0c             	pushl  0xc(%ebp)
  800adc:	6a 30                	push   $0x30
  800ade:	8b 45 08             	mov    0x8(%ebp),%eax
  800ae1:	ff d0                	call   *%eax
  800ae3:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800ae6:	83 ec 08             	sub    $0x8,%esp
  800ae9:	ff 75 0c             	pushl  0xc(%ebp)
  800aec:	6a 78                	push   $0x78
  800aee:	8b 45 08             	mov    0x8(%ebp),%eax
  800af1:	ff d0                	call   *%eax
  800af3:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800af6:	8b 45 14             	mov    0x14(%ebp),%eax
  800af9:	83 c0 04             	add    $0x4,%eax
  800afc:	89 45 14             	mov    %eax,0x14(%ebp)
  800aff:	8b 45 14             	mov    0x14(%ebp),%eax
  800b02:	83 e8 04             	sub    $0x4,%eax
  800b05:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800b07:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b0a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800b11:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800b18:	eb 1f                	jmp    800b39 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800b1a:	83 ec 08             	sub    $0x8,%esp
  800b1d:	ff 75 e8             	pushl  -0x18(%ebp)
  800b20:	8d 45 14             	lea    0x14(%ebp),%eax
  800b23:	50                   	push   %eax
  800b24:	e8 e7 fb ff ff       	call   800710 <getuint>
  800b29:	83 c4 10             	add    $0x10,%esp
  800b2c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b2f:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800b32:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800b39:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800b3d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800b40:	83 ec 04             	sub    $0x4,%esp
  800b43:	52                   	push   %edx
  800b44:	ff 75 e4             	pushl  -0x1c(%ebp)
  800b47:	50                   	push   %eax
  800b48:	ff 75 f4             	pushl  -0xc(%ebp)
  800b4b:	ff 75 f0             	pushl  -0x10(%ebp)
  800b4e:	ff 75 0c             	pushl  0xc(%ebp)
  800b51:	ff 75 08             	pushl  0x8(%ebp)
  800b54:	e8 00 fb ff ff       	call   800659 <printnum>
  800b59:	83 c4 20             	add    $0x20,%esp
			break;
  800b5c:	eb 46                	jmp    800ba4 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800b5e:	83 ec 08             	sub    $0x8,%esp
  800b61:	ff 75 0c             	pushl  0xc(%ebp)
  800b64:	53                   	push   %ebx
  800b65:	8b 45 08             	mov    0x8(%ebp),%eax
  800b68:	ff d0                	call   *%eax
  800b6a:	83 c4 10             	add    $0x10,%esp
			break;
  800b6d:	eb 35                	jmp    800ba4 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800b6f:	c6 05 44 30 80 00 00 	movb   $0x0,0x803044
			break;
  800b76:	eb 2c                	jmp    800ba4 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800b78:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
			break;
  800b7f:	eb 23                	jmp    800ba4 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800b81:	83 ec 08             	sub    $0x8,%esp
  800b84:	ff 75 0c             	pushl  0xc(%ebp)
  800b87:	6a 25                	push   $0x25
  800b89:	8b 45 08             	mov    0x8(%ebp),%eax
  800b8c:	ff d0                	call   *%eax
  800b8e:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800b91:	ff 4d 10             	decl   0x10(%ebp)
  800b94:	eb 03                	jmp    800b99 <vprintfmt+0x3c3>
  800b96:	ff 4d 10             	decl   0x10(%ebp)
  800b99:	8b 45 10             	mov    0x10(%ebp),%eax
  800b9c:	48                   	dec    %eax
  800b9d:	8a 00                	mov    (%eax),%al
  800b9f:	3c 25                	cmp    $0x25,%al
  800ba1:	75 f3                	jne    800b96 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800ba3:	90                   	nop
		}
	}
  800ba4:	e9 35 fc ff ff       	jmp    8007de <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800ba9:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800baa:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800bad:	5b                   	pop    %ebx
  800bae:	5e                   	pop    %esi
  800baf:	5d                   	pop    %ebp
  800bb0:	c3                   	ret    

00800bb1 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800bb1:	55                   	push   %ebp
  800bb2:	89 e5                	mov    %esp,%ebp
  800bb4:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800bb7:	8d 45 10             	lea    0x10(%ebp),%eax
  800bba:	83 c0 04             	add    $0x4,%eax
  800bbd:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800bc0:	8b 45 10             	mov    0x10(%ebp),%eax
  800bc3:	ff 75 f4             	pushl  -0xc(%ebp)
  800bc6:	50                   	push   %eax
  800bc7:	ff 75 0c             	pushl  0xc(%ebp)
  800bca:	ff 75 08             	pushl  0x8(%ebp)
  800bcd:	e8 04 fc ff ff       	call   8007d6 <vprintfmt>
  800bd2:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800bd5:	90                   	nop
  800bd6:	c9                   	leave  
  800bd7:	c3                   	ret    

00800bd8 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800bd8:	55                   	push   %ebp
  800bd9:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800bdb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bde:	8b 40 08             	mov    0x8(%eax),%eax
  800be1:	8d 50 01             	lea    0x1(%eax),%edx
  800be4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800be7:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800bea:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bed:	8b 10                	mov    (%eax),%edx
  800bef:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bf2:	8b 40 04             	mov    0x4(%eax),%eax
  800bf5:	39 c2                	cmp    %eax,%edx
  800bf7:	73 12                	jae    800c0b <sprintputch+0x33>
		*b->buf++ = ch;
  800bf9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bfc:	8b 00                	mov    (%eax),%eax
  800bfe:	8d 48 01             	lea    0x1(%eax),%ecx
  800c01:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c04:	89 0a                	mov    %ecx,(%edx)
  800c06:	8b 55 08             	mov    0x8(%ebp),%edx
  800c09:	88 10                	mov    %dl,(%eax)
}
  800c0b:	90                   	nop
  800c0c:	5d                   	pop    %ebp
  800c0d:	c3                   	ret    

00800c0e <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800c0e:	55                   	push   %ebp
  800c0f:	89 e5                	mov    %esp,%ebp
  800c11:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800c14:	8b 45 08             	mov    0x8(%ebp),%eax
  800c17:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800c1a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c1d:	8d 50 ff             	lea    -0x1(%eax),%edx
  800c20:	8b 45 08             	mov    0x8(%ebp),%eax
  800c23:	01 d0                	add    %edx,%eax
  800c25:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c28:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800c2f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800c33:	74 06                	je     800c3b <vsnprintf+0x2d>
  800c35:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c39:	7f 07                	jg     800c42 <vsnprintf+0x34>
		return -E_INVAL;
  800c3b:	b8 03 00 00 00       	mov    $0x3,%eax
  800c40:	eb 20                	jmp    800c62 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800c42:	ff 75 14             	pushl  0x14(%ebp)
  800c45:	ff 75 10             	pushl  0x10(%ebp)
  800c48:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800c4b:	50                   	push   %eax
  800c4c:	68 d8 0b 80 00       	push   $0x800bd8
  800c51:	e8 80 fb ff ff       	call   8007d6 <vprintfmt>
  800c56:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800c59:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800c5c:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800c5f:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800c62:	c9                   	leave  
  800c63:	c3                   	ret    

00800c64 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800c64:	55                   	push   %ebp
  800c65:	89 e5                	mov    %esp,%ebp
  800c67:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800c6a:	8d 45 10             	lea    0x10(%ebp),%eax
  800c6d:	83 c0 04             	add    $0x4,%eax
  800c70:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800c73:	8b 45 10             	mov    0x10(%ebp),%eax
  800c76:	ff 75 f4             	pushl  -0xc(%ebp)
  800c79:	50                   	push   %eax
  800c7a:	ff 75 0c             	pushl  0xc(%ebp)
  800c7d:	ff 75 08             	pushl  0x8(%ebp)
  800c80:	e8 89 ff ff ff       	call   800c0e <vsnprintf>
  800c85:	83 c4 10             	add    $0x10,%esp
  800c88:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800c8b:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800c8e:	c9                   	leave  
  800c8f:	c3                   	ret    

00800c90 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800c90:	55                   	push   %ebp
  800c91:	89 e5                	mov    %esp,%ebp
  800c93:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800c96:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c9d:	eb 06                	jmp    800ca5 <strlen+0x15>
		n++;
  800c9f:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800ca2:	ff 45 08             	incl   0x8(%ebp)
  800ca5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ca8:	8a 00                	mov    (%eax),%al
  800caa:	84 c0                	test   %al,%al
  800cac:	75 f1                	jne    800c9f <strlen+0xf>
		n++;
	return n;
  800cae:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800cb1:	c9                   	leave  
  800cb2:	c3                   	ret    

00800cb3 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800cb3:	55                   	push   %ebp
  800cb4:	89 e5                	mov    %esp,%ebp
  800cb6:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800cb9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800cc0:	eb 09                	jmp    800ccb <strnlen+0x18>
		n++;
  800cc2:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800cc5:	ff 45 08             	incl   0x8(%ebp)
  800cc8:	ff 4d 0c             	decl   0xc(%ebp)
  800ccb:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800ccf:	74 09                	je     800cda <strnlen+0x27>
  800cd1:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd4:	8a 00                	mov    (%eax),%al
  800cd6:	84 c0                	test   %al,%al
  800cd8:	75 e8                	jne    800cc2 <strnlen+0xf>
		n++;
	return n;
  800cda:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800cdd:	c9                   	leave  
  800cde:	c3                   	ret    

00800cdf <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800cdf:	55                   	push   %ebp
  800ce0:	89 e5                	mov    %esp,%ebp
  800ce2:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800ce5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800ceb:	90                   	nop
  800cec:	8b 45 08             	mov    0x8(%ebp),%eax
  800cef:	8d 50 01             	lea    0x1(%eax),%edx
  800cf2:	89 55 08             	mov    %edx,0x8(%ebp)
  800cf5:	8b 55 0c             	mov    0xc(%ebp),%edx
  800cf8:	8d 4a 01             	lea    0x1(%edx),%ecx
  800cfb:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800cfe:	8a 12                	mov    (%edx),%dl
  800d00:	88 10                	mov    %dl,(%eax)
  800d02:	8a 00                	mov    (%eax),%al
  800d04:	84 c0                	test   %al,%al
  800d06:	75 e4                	jne    800cec <strcpy+0xd>
		/* do nothing */;
	return ret;
  800d08:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800d0b:	c9                   	leave  
  800d0c:	c3                   	ret    

00800d0d <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800d0d:	55                   	push   %ebp
  800d0e:	89 e5                	mov    %esp,%ebp
  800d10:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800d13:	8b 45 08             	mov    0x8(%ebp),%eax
  800d16:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800d19:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800d20:	eb 1f                	jmp    800d41 <strncpy+0x34>
		*dst++ = *src;
  800d22:	8b 45 08             	mov    0x8(%ebp),%eax
  800d25:	8d 50 01             	lea    0x1(%eax),%edx
  800d28:	89 55 08             	mov    %edx,0x8(%ebp)
  800d2b:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d2e:	8a 12                	mov    (%edx),%dl
  800d30:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800d32:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d35:	8a 00                	mov    (%eax),%al
  800d37:	84 c0                	test   %al,%al
  800d39:	74 03                	je     800d3e <strncpy+0x31>
			src++;
  800d3b:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800d3e:	ff 45 fc             	incl   -0x4(%ebp)
  800d41:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d44:	3b 45 10             	cmp    0x10(%ebp),%eax
  800d47:	72 d9                	jb     800d22 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800d49:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800d4c:	c9                   	leave  
  800d4d:	c3                   	ret    

00800d4e <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800d4e:	55                   	push   %ebp
  800d4f:	89 e5                	mov    %esp,%ebp
  800d51:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800d54:	8b 45 08             	mov    0x8(%ebp),%eax
  800d57:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800d5a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d5e:	74 30                	je     800d90 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800d60:	eb 16                	jmp    800d78 <strlcpy+0x2a>
			*dst++ = *src++;
  800d62:	8b 45 08             	mov    0x8(%ebp),%eax
  800d65:	8d 50 01             	lea    0x1(%eax),%edx
  800d68:	89 55 08             	mov    %edx,0x8(%ebp)
  800d6b:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d6e:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d71:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800d74:	8a 12                	mov    (%edx),%dl
  800d76:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800d78:	ff 4d 10             	decl   0x10(%ebp)
  800d7b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d7f:	74 09                	je     800d8a <strlcpy+0x3c>
  800d81:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d84:	8a 00                	mov    (%eax),%al
  800d86:	84 c0                	test   %al,%al
  800d88:	75 d8                	jne    800d62 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800d8a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d8d:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800d90:	8b 55 08             	mov    0x8(%ebp),%edx
  800d93:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d96:	29 c2                	sub    %eax,%edx
  800d98:	89 d0                	mov    %edx,%eax
}
  800d9a:	c9                   	leave  
  800d9b:	c3                   	ret    

00800d9c <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800d9c:	55                   	push   %ebp
  800d9d:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800d9f:	eb 06                	jmp    800da7 <strcmp+0xb>
		p++, q++;
  800da1:	ff 45 08             	incl   0x8(%ebp)
  800da4:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800da7:	8b 45 08             	mov    0x8(%ebp),%eax
  800daa:	8a 00                	mov    (%eax),%al
  800dac:	84 c0                	test   %al,%al
  800dae:	74 0e                	je     800dbe <strcmp+0x22>
  800db0:	8b 45 08             	mov    0x8(%ebp),%eax
  800db3:	8a 10                	mov    (%eax),%dl
  800db5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800db8:	8a 00                	mov    (%eax),%al
  800dba:	38 c2                	cmp    %al,%dl
  800dbc:	74 e3                	je     800da1 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800dbe:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc1:	8a 00                	mov    (%eax),%al
  800dc3:	0f b6 d0             	movzbl %al,%edx
  800dc6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dc9:	8a 00                	mov    (%eax),%al
  800dcb:	0f b6 c0             	movzbl %al,%eax
  800dce:	29 c2                	sub    %eax,%edx
  800dd0:	89 d0                	mov    %edx,%eax
}
  800dd2:	5d                   	pop    %ebp
  800dd3:	c3                   	ret    

00800dd4 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800dd4:	55                   	push   %ebp
  800dd5:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800dd7:	eb 09                	jmp    800de2 <strncmp+0xe>
		n--, p++, q++;
  800dd9:	ff 4d 10             	decl   0x10(%ebp)
  800ddc:	ff 45 08             	incl   0x8(%ebp)
  800ddf:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800de2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800de6:	74 17                	je     800dff <strncmp+0x2b>
  800de8:	8b 45 08             	mov    0x8(%ebp),%eax
  800deb:	8a 00                	mov    (%eax),%al
  800ded:	84 c0                	test   %al,%al
  800def:	74 0e                	je     800dff <strncmp+0x2b>
  800df1:	8b 45 08             	mov    0x8(%ebp),%eax
  800df4:	8a 10                	mov    (%eax),%dl
  800df6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800df9:	8a 00                	mov    (%eax),%al
  800dfb:	38 c2                	cmp    %al,%dl
  800dfd:	74 da                	je     800dd9 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800dff:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e03:	75 07                	jne    800e0c <strncmp+0x38>
		return 0;
  800e05:	b8 00 00 00 00       	mov    $0x0,%eax
  800e0a:	eb 14                	jmp    800e20 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800e0c:	8b 45 08             	mov    0x8(%ebp),%eax
  800e0f:	8a 00                	mov    (%eax),%al
  800e11:	0f b6 d0             	movzbl %al,%edx
  800e14:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e17:	8a 00                	mov    (%eax),%al
  800e19:	0f b6 c0             	movzbl %al,%eax
  800e1c:	29 c2                	sub    %eax,%edx
  800e1e:	89 d0                	mov    %edx,%eax
}
  800e20:	5d                   	pop    %ebp
  800e21:	c3                   	ret    

00800e22 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800e22:	55                   	push   %ebp
  800e23:	89 e5                	mov    %esp,%ebp
  800e25:	83 ec 04             	sub    $0x4,%esp
  800e28:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e2b:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800e2e:	eb 12                	jmp    800e42 <strchr+0x20>
		if (*s == c)
  800e30:	8b 45 08             	mov    0x8(%ebp),%eax
  800e33:	8a 00                	mov    (%eax),%al
  800e35:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800e38:	75 05                	jne    800e3f <strchr+0x1d>
			return (char *) s;
  800e3a:	8b 45 08             	mov    0x8(%ebp),%eax
  800e3d:	eb 11                	jmp    800e50 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800e3f:	ff 45 08             	incl   0x8(%ebp)
  800e42:	8b 45 08             	mov    0x8(%ebp),%eax
  800e45:	8a 00                	mov    (%eax),%al
  800e47:	84 c0                	test   %al,%al
  800e49:	75 e5                	jne    800e30 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800e4b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e50:	c9                   	leave  
  800e51:	c3                   	ret    

00800e52 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800e52:	55                   	push   %ebp
  800e53:	89 e5                	mov    %esp,%ebp
  800e55:	83 ec 04             	sub    $0x4,%esp
  800e58:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e5b:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800e5e:	eb 0d                	jmp    800e6d <strfind+0x1b>
		if (*s == c)
  800e60:	8b 45 08             	mov    0x8(%ebp),%eax
  800e63:	8a 00                	mov    (%eax),%al
  800e65:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800e68:	74 0e                	je     800e78 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800e6a:	ff 45 08             	incl   0x8(%ebp)
  800e6d:	8b 45 08             	mov    0x8(%ebp),%eax
  800e70:	8a 00                	mov    (%eax),%al
  800e72:	84 c0                	test   %al,%al
  800e74:	75 ea                	jne    800e60 <strfind+0xe>
  800e76:	eb 01                	jmp    800e79 <strfind+0x27>
		if (*s == c)
			break;
  800e78:	90                   	nop
	return (char *) s;
  800e79:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e7c:	c9                   	leave  
  800e7d:	c3                   	ret    

00800e7e <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  800e7e:	55                   	push   %ebp
  800e7f:	89 e5                	mov    %esp,%ebp
  800e81:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  800e84:	8b 45 08             	mov    0x8(%ebp),%eax
  800e87:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  800e8a:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800e8e:	76 63                	jbe    800ef3 <memset+0x75>
		uint64 data_block = c;
  800e90:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e93:	99                   	cltd   
  800e94:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e97:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  800e9a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e9d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ea0:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  800ea4:	c1 e0 08             	shl    $0x8,%eax
  800ea7:	09 45 f0             	or     %eax,-0x10(%ebp)
  800eaa:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  800ead:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800eb0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800eb3:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  800eb7:	c1 e0 10             	shl    $0x10,%eax
  800eba:	09 45 f0             	or     %eax,-0x10(%ebp)
  800ebd:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  800ec0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ec3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ec6:	89 c2                	mov    %eax,%edx
  800ec8:	b8 00 00 00 00       	mov    $0x0,%eax
  800ecd:	09 45 f0             	or     %eax,-0x10(%ebp)
  800ed0:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  800ed3:	eb 18                	jmp    800eed <memset+0x6f>
			*p64++ = data_block, n -= 8;
  800ed5:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  800ed8:	8d 41 08             	lea    0x8(%ecx),%eax
  800edb:	89 45 fc             	mov    %eax,-0x4(%ebp)
  800ede:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ee1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ee4:	89 01                	mov    %eax,(%ecx)
  800ee6:	89 51 04             	mov    %edx,0x4(%ecx)
  800ee9:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  800eed:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800ef1:	77 e2                	ja     800ed5 <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  800ef3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ef7:	74 23                	je     800f1c <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  800ef9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800efc:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  800eff:	eb 0e                	jmp    800f0f <memset+0x91>
			*p8++ = (uint8)c;
  800f01:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f04:	8d 50 01             	lea    0x1(%eax),%edx
  800f07:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800f0a:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f0d:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  800f0f:	8b 45 10             	mov    0x10(%ebp),%eax
  800f12:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f15:	89 55 10             	mov    %edx,0x10(%ebp)
  800f18:	85 c0                	test   %eax,%eax
  800f1a:	75 e5                	jne    800f01 <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  800f1c:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f1f:	c9                   	leave  
  800f20:	c3                   	ret    

00800f21 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800f21:	55                   	push   %ebp
  800f22:	89 e5                	mov    %esp,%ebp
  800f24:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  800f27:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f2a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  800f2d:	8b 45 08             	mov    0x8(%ebp),%eax
  800f30:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  800f33:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800f37:	76 24                	jbe    800f5d <memcpy+0x3c>
		while(n >= 8){
  800f39:	eb 1c                	jmp    800f57 <memcpy+0x36>
			*d64 = *s64;
  800f3b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f3e:	8b 50 04             	mov    0x4(%eax),%edx
  800f41:	8b 00                	mov    (%eax),%eax
  800f43:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  800f46:	89 01                	mov    %eax,(%ecx)
  800f48:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  800f4b:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  800f4f:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  800f53:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  800f57:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800f5b:	77 de                	ja     800f3b <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  800f5d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f61:	74 31                	je     800f94 <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  800f63:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f66:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  800f69:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f6c:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  800f6f:	eb 16                	jmp    800f87 <memcpy+0x66>
			*d8++ = *s8++;
  800f71:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800f74:	8d 50 01             	lea    0x1(%eax),%edx
  800f77:	89 55 f0             	mov    %edx,-0x10(%ebp)
  800f7a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f7d:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f80:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  800f83:	8a 12                	mov    (%edx),%dl
  800f85:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  800f87:	8b 45 10             	mov    0x10(%ebp),%eax
  800f8a:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f8d:	89 55 10             	mov    %edx,0x10(%ebp)
  800f90:	85 c0                	test   %eax,%eax
  800f92:	75 dd                	jne    800f71 <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  800f94:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f97:	c9                   	leave  
  800f98:	c3                   	ret    

00800f99 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800f99:	55                   	push   %ebp
  800f9a:	89 e5                	mov    %esp,%ebp
  800f9c:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800f9f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fa2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800fa5:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa8:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800fab:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fae:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800fb1:	73 50                	jae    801003 <memmove+0x6a>
  800fb3:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800fb6:	8b 45 10             	mov    0x10(%ebp),%eax
  800fb9:	01 d0                	add    %edx,%eax
  800fbb:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800fbe:	76 43                	jbe    801003 <memmove+0x6a>
		s += n;
  800fc0:	8b 45 10             	mov    0x10(%ebp),%eax
  800fc3:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800fc6:	8b 45 10             	mov    0x10(%ebp),%eax
  800fc9:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800fcc:	eb 10                	jmp    800fde <memmove+0x45>
			*--d = *--s;
  800fce:	ff 4d f8             	decl   -0x8(%ebp)
  800fd1:	ff 4d fc             	decl   -0x4(%ebp)
  800fd4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fd7:	8a 10                	mov    (%eax),%dl
  800fd9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fdc:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800fde:	8b 45 10             	mov    0x10(%ebp),%eax
  800fe1:	8d 50 ff             	lea    -0x1(%eax),%edx
  800fe4:	89 55 10             	mov    %edx,0x10(%ebp)
  800fe7:	85 c0                	test   %eax,%eax
  800fe9:	75 e3                	jne    800fce <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800feb:	eb 23                	jmp    801010 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800fed:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ff0:	8d 50 01             	lea    0x1(%eax),%edx
  800ff3:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800ff6:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800ff9:	8d 4a 01             	lea    0x1(%edx),%ecx
  800ffc:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800fff:	8a 12                	mov    (%edx),%dl
  801001:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801003:	8b 45 10             	mov    0x10(%ebp),%eax
  801006:	8d 50 ff             	lea    -0x1(%eax),%edx
  801009:	89 55 10             	mov    %edx,0x10(%ebp)
  80100c:	85 c0                	test   %eax,%eax
  80100e:	75 dd                	jne    800fed <memmove+0x54>
			*d++ = *s++;

	return dst;
  801010:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801013:	c9                   	leave  
  801014:	c3                   	ret    

00801015 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  801015:	55                   	push   %ebp
  801016:	89 e5                	mov    %esp,%ebp
  801018:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  80101b:	8b 45 08             	mov    0x8(%ebp),%eax
  80101e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  801021:	8b 45 0c             	mov    0xc(%ebp),%eax
  801024:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  801027:	eb 2a                	jmp    801053 <memcmp+0x3e>
		if (*s1 != *s2)
  801029:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80102c:	8a 10                	mov    (%eax),%dl
  80102e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801031:	8a 00                	mov    (%eax),%al
  801033:	38 c2                	cmp    %al,%dl
  801035:	74 16                	je     80104d <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801037:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80103a:	8a 00                	mov    (%eax),%al
  80103c:	0f b6 d0             	movzbl %al,%edx
  80103f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801042:	8a 00                	mov    (%eax),%al
  801044:	0f b6 c0             	movzbl %al,%eax
  801047:	29 c2                	sub    %eax,%edx
  801049:	89 d0                	mov    %edx,%eax
  80104b:	eb 18                	jmp    801065 <memcmp+0x50>
		s1++, s2++;
  80104d:	ff 45 fc             	incl   -0x4(%ebp)
  801050:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801053:	8b 45 10             	mov    0x10(%ebp),%eax
  801056:	8d 50 ff             	lea    -0x1(%eax),%edx
  801059:	89 55 10             	mov    %edx,0x10(%ebp)
  80105c:	85 c0                	test   %eax,%eax
  80105e:	75 c9                	jne    801029 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801060:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801065:	c9                   	leave  
  801066:	c3                   	ret    

00801067 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801067:	55                   	push   %ebp
  801068:	89 e5                	mov    %esp,%ebp
  80106a:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  80106d:	8b 55 08             	mov    0x8(%ebp),%edx
  801070:	8b 45 10             	mov    0x10(%ebp),%eax
  801073:	01 d0                	add    %edx,%eax
  801075:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801078:	eb 15                	jmp    80108f <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  80107a:	8b 45 08             	mov    0x8(%ebp),%eax
  80107d:	8a 00                	mov    (%eax),%al
  80107f:	0f b6 d0             	movzbl %al,%edx
  801082:	8b 45 0c             	mov    0xc(%ebp),%eax
  801085:	0f b6 c0             	movzbl %al,%eax
  801088:	39 c2                	cmp    %eax,%edx
  80108a:	74 0d                	je     801099 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80108c:	ff 45 08             	incl   0x8(%ebp)
  80108f:	8b 45 08             	mov    0x8(%ebp),%eax
  801092:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801095:	72 e3                	jb     80107a <memfind+0x13>
  801097:	eb 01                	jmp    80109a <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801099:	90                   	nop
	return (void *) s;
  80109a:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80109d:	c9                   	leave  
  80109e:	c3                   	ret    

0080109f <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80109f:	55                   	push   %ebp
  8010a0:	89 e5                	mov    %esp,%ebp
  8010a2:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  8010a5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  8010ac:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8010b3:	eb 03                	jmp    8010b8 <strtol+0x19>
		s++;
  8010b5:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8010b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8010bb:	8a 00                	mov    (%eax),%al
  8010bd:	3c 20                	cmp    $0x20,%al
  8010bf:	74 f4                	je     8010b5 <strtol+0x16>
  8010c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c4:	8a 00                	mov    (%eax),%al
  8010c6:	3c 09                	cmp    $0x9,%al
  8010c8:	74 eb                	je     8010b5 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  8010ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8010cd:	8a 00                	mov    (%eax),%al
  8010cf:	3c 2b                	cmp    $0x2b,%al
  8010d1:	75 05                	jne    8010d8 <strtol+0x39>
		s++;
  8010d3:	ff 45 08             	incl   0x8(%ebp)
  8010d6:	eb 13                	jmp    8010eb <strtol+0x4c>
	else if (*s == '-')
  8010d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8010db:	8a 00                	mov    (%eax),%al
  8010dd:	3c 2d                	cmp    $0x2d,%al
  8010df:	75 0a                	jne    8010eb <strtol+0x4c>
		s++, neg = 1;
  8010e1:	ff 45 08             	incl   0x8(%ebp)
  8010e4:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8010eb:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010ef:	74 06                	je     8010f7 <strtol+0x58>
  8010f1:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8010f5:	75 20                	jne    801117 <strtol+0x78>
  8010f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8010fa:	8a 00                	mov    (%eax),%al
  8010fc:	3c 30                	cmp    $0x30,%al
  8010fe:	75 17                	jne    801117 <strtol+0x78>
  801100:	8b 45 08             	mov    0x8(%ebp),%eax
  801103:	40                   	inc    %eax
  801104:	8a 00                	mov    (%eax),%al
  801106:	3c 78                	cmp    $0x78,%al
  801108:	75 0d                	jne    801117 <strtol+0x78>
		s += 2, base = 16;
  80110a:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  80110e:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801115:	eb 28                	jmp    80113f <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801117:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80111b:	75 15                	jne    801132 <strtol+0x93>
  80111d:	8b 45 08             	mov    0x8(%ebp),%eax
  801120:	8a 00                	mov    (%eax),%al
  801122:	3c 30                	cmp    $0x30,%al
  801124:	75 0c                	jne    801132 <strtol+0x93>
		s++, base = 8;
  801126:	ff 45 08             	incl   0x8(%ebp)
  801129:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801130:	eb 0d                	jmp    80113f <strtol+0xa0>
	else if (base == 0)
  801132:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801136:	75 07                	jne    80113f <strtol+0xa0>
		base = 10;
  801138:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  80113f:	8b 45 08             	mov    0x8(%ebp),%eax
  801142:	8a 00                	mov    (%eax),%al
  801144:	3c 2f                	cmp    $0x2f,%al
  801146:	7e 19                	jle    801161 <strtol+0xc2>
  801148:	8b 45 08             	mov    0x8(%ebp),%eax
  80114b:	8a 00                	mov    (%eax),%al
  80114d:	3c 39                	cmp    $0x39,%al
  80114f:	7f 10                	jg     801161 <strtol+0xc2>
			dig = *s - '0';
  801151:	8b 45 08             	mov    0x8(%ebp),%eax
  801154:	8a 00                	mov    (%eax),%al
  801156:	0f be c0             	movsbl %al,%eax
  801159:	83 e8 30             	sub    $0x30,%eax
  80115c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80115f:	eb 42                	jmp    8011a3 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801161:	8b 45 08             	mov    0x8(%ebp),%eax
  801164:	8a 00                	mov    (%eax),%al
  801166:	3c 60                	cmp    $0x60,%al
  801168:	7e 19                	jle    801183 <strtol+0xe4>
  80116a:	8b 45 08             	mov    0x8(%ebp),%eax
  80116d:	8a 00                	mov    (%eax),%al
  80116f:	3c 7a                	cmp    $0x7a,%al
  801171:	7f 10                	jg     801183 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801173:	8b 45 08             	mov    0x8(%ebp),%eax
  801176:	8a 00                	mov    (%eax),%al
  801178:	0f be c0             	movsbl %al,%eax
  80117b:	83 e8 57             	sub    $0x57,%eax
  80117e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801181:	eb 20                	jmp    8011a3 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801183:	8b 45 08             	mov    0x8(%ebp),%eax
  801186:	8a 00                	mov    (%eax),%al
  801188:	3c 40                	cmp    $0x40,%al
  80118a:	7e 39                	jle    8011c5 <strtol+0x126>
  80118c:	8b 45 08             	mov    0x8(%ebp),%eax
  80118f:	8a 00                	mov    (%eax),%al
  801191:	3c 5a                	cmp    $0x5a,%al
  801193:	7f 30                	jg     8011c5 <strtol+0x126>
			dig = *s - 'A' + 10;
  801195:	8b 45 08             	mov    0x8(%ebp),%eax
  801198:	8a 00                	mov    (%eax),%al
  80119a:	0f be c0             	movsbl %al,%eax
  80119d:	83 e8 37             	sub    $0x37,%eax
  8011a0:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  8011a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8011a6:	3b 45 10             	cmp    0x10(%ebp),%eax
  8011a9:	7d 19                	jge    8011c4 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  8011ab:	ff 45 08             	incl   0x8(%ebp)
  8011ae:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011b1:	0f af 45 10          	imul   0x10(%ebp),%eax
  8011b5:	89 c2                	mov    %eax,%edx
  8011b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8011ba:	01 d0                	add    %edx,%eax
  8011bc:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8011bf:	e9 7b ff ff ff       	jmp    80113f <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8011c4:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8011c5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8011c9:	74 08                	je     8011d3 <strtol+0x134>
		*endptr = (char *) s;
  8011cb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011ce:	8b 55 08             	mov    0x8(%ebp),%edx
  8011d1:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8011d3:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8011d7:	74 07                	je     8011e0 <strtol+0x141>
  8011d9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011dc:	f7 d8                	neg    %eax
  8011de:	eb 03                	jmp    8011e3 <strtol+0x144>
  8011e0:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8011e3:	c9                   	leave  
  8011e4:	c3                   	ret    

008011e5 <ltostr>:

void
ltostr(long value, char *str)
{
  8011e5:	55                   	push   %ebp
  8011e6:	89 e5                	mov    %esp,%ebp
  8011e8:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8011eb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8011f2:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8011f9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8011fd:	79 13                	jns    801212 <ltostr+0x2d>
	{
		neg = 1;
  8011ff:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801206:	8b 45 0c             	mov    0xc(%ebp),%eax
  801209:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  80120c:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  80120f:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801212:	8b 45 08             	mov    0x8(%ebp),%eax
  801215:	b9 0a 00 00 00       	mov    $0xa,%ecx
  80121a:	99                   	cltd   
  80121b:	f7 f9                	idiv   %ecx
  80121d:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801220:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801223:	8d 50 01             	lea    0x1(%eax),%edx
  801226:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801229:	89 c2                	mov    %eax,%edx
  80122b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80122e:	01 d0                	add    %edx,%eax
  801230:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801233:	83 c2 30             	add    $0x30,%edx
  801236:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801238:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80123b:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801240:	f7 e9                	imul   %ecx
  801242:	c1 fa 02             	sar    $0x2,%edx
  801245:	89 c8                	mov    %ecx,%eax
  801247:	c1 f8 1f             	sar    $0x1f,%eax
  80124a:	29 c2                	sub    %eax,%edx
  80124c:	89 d0                	mov    %edx,%eax
  80124e:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  801251:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801255:	75 bb                	jne    801212 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801257:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  80125e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801261:	48                   	dec    %eax
  801262:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801265:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801269:	74 3d                	je     8012a8 <ltostr+0xc3>
		start = 1 ;
  80126b:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801272:	eb 34                	jmp    8012a8 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  801274:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801277:	8b 45 0c             	mov    0xc(%ebp),%eax
  80127a:	01 d0                	add    %edx,%eax
  80127c:	8a 00                	mov    (%eax),%al
  80127e:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801281:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801284:	8b 45 0c             	mov    0xc(%ebp),%eax
  801287:	01 c2                	add    %eax,%edx
  801289:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80128c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80128f:	01 c8                	add    %ecx,%eax
  801291:	8a 00                	mov    (%eax),%al
  801293:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801295:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801298:	8b 45 0c             	mov    0xc(%ebp),%eax
  80129b:	01 c2                	add    %eax,%edx
  80129d:	8a 45 eb             	mov    -0x15(%ebp),%al
  8012a0:	88 02                	mov    %al,(%edx)
		start++ ;
  8012a2:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8012a5:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8012a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8012ab:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8012ae:	7c c4                	jl     801274 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8012b0:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8012b3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012b6:	01 d0                	add    %edx,%eax
  8012b8:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8012bb:	90                   	nop
  8012bc:	c9                   	leave  
  8012bd:	c3                   	ret    

008012be <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8012be:	55                   	push   %ebp
  8012bf:	89 e5                	mov    %esp,%ebp
  8012c1:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8012c4:	ff 75 08             	pushl  0x8(%ebp)
  8012c7:	e8 c4 f9 ff ff       	call   800c90 <strlen>
  8012cc:	83 c4 04             	add    $0x4,%esp
  8012cf:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8012d2:	ff 75 0c             	pushl  0xc(%ebp)
  8012d5:	e8 b6 f9 ff ff       	call   800c90 <strlen>
  8012da:	83 c4 04             	add    $0x4,%esp
  8012dd:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8012e0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8012e7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8012ee:	eb 17                	jmp    801307 <strcconcat+0x49>
		final[s] = str1[s] ;
  8012f0:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8012f3:	8b 45 10             	mov    0x10(%ebp),%eax
  8012f6:	01 c2                	add    %eax,%edx
  8012f8:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8012fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8012fe:	01 c8                	add    %ecx,%eax
  801300:	8a 00                	mov    (%eax),%al
  801302:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801304:	ff 45 fc             	incl   -0x4(%ebp)
  801307:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80130a:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80130d:	7c e1                	jl     8012f0 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  80130f:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801316:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  80131d:	eb 1f                	jmp    80133e <strcconcat+0x80>
		final[s++] = str2[i] ;
  80131f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801322:	8d 50 01             	lea    0x1(%eax),%edx
  801325:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801328:	89 c2                	mov    %eax,%edx
  80132a:	8b 45 10             	mov    0x10(%ebp),%eax
  80132d:	01 c2                	add    %eax,%edx
  80132f:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801332:	8b 45 0c             	mov    0xc(%ebp),%eax
  801335:	01 c8                	add    %ecx,%eax
  801337:	8a 00                	mov    (%eax),%al
  801339:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  80133b:	ff 45 f8             	incl   -0x8(%ebp)
  80133e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801341:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801344:	7c d9                	jl     80131f <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801346:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801349:	8b 45 10             	mov    0x10(%ebp),%eax
  80134c:	01 d0                	add    %edx,%eax
  80134e:	c6 00 00             	movb   $0x0,(%eax)
}
  801351:	90                   	nop
  801352:	c9                   	leave  
  801353:	c3                   	ret    

00801354 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801354:	55                   	push   %ebp
  801355:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801357:	8b 45 14             	mov    0x14(%ebp),%eax
  80135a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801360:	8b 45 14             	mov    0x14(%ebp),%eax
  801363:	8b 00                	mov    (%eax),%eax
  801365:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80136c:	8b 45 10             	mov    0x10(%ebp),%eax
  80136f:	01 d0                	add    %edx,%eax
  801371:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801377:	eb 0c                	jmp    801385 <strsplit+0x31>
			*string++ = 0;
  801379:	8b 45 08             	mov    0x8(%ebp),%eax
  80137c:	8d 50 01             	lea    0x1(%eax),%edx
  80137f:	89 55 08             	mov    %edx,0x8(%ebp)
  801382:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801385:	8b 45 08             	mov    0x8(%ebp),%eax
  801388:	8a 00                	mov    (%eax),%al
  80138a:	84 c0                	test   %al,%al
  80138c:	74 18                	je     8013a6 <strsplit+0x52>
  80138e:	8b 45 08             	mov    0x8(%ebp),%eax
  801391:	8a 00                	mov    (%eax),%al
  801393:	0f be c0             	movsbl %al,%eax
  801396:	50                   	push   %eax
  801397:	ff 75 0c             	pushl  0xc(%ebp)
  80139a:	e8 83 fa ff ff       	call   800e22 <strchr>
  80139f:	83 c4 08             	add    $0x8,%esp
  8013a2:	85 c0                	test   %eax,%eax
  8013a4:	75 d3                	jne    801379 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8013a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8013a9:	8a 00                	mov    (%eax),%al
  8013ab:	84 c0                	test   %al,%al
  8013ad:	74 5a                	je     801409 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8013af:	8b 45 14             	mov    0x14(%ebp),%eax
  8013b2:	8b 00                	mov    (%eax),%eax
  8013b4:	83 f8 0f             	cmp    $0xf,%eax
  8013b7:	75 07                	jne    8013c0 <strsplit+0x6c>
		{
			return 0;
  8013b9:	b8 00 00 00 00       	mov    $0x0,%eax
  8013be:	eb 66                	jmp    801426 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8013c0:	8b 45 14             	mov    0x14(%ebp),%eax
  8013c3:	8b 00                	mov    (%eax),%eax
  8013c5:	8d 48 01             	lea    0x1(%eax),%ecx
  8013c8:	8b 55 14             	mov    0x14(%ebp),%edx
  8013cb:	89 0a                	mov    %ecx,(%edx)
  8013cd:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8013d4:	8b 45 10             	mov    0x10(%ebp),%eax
  8013d7:	01 c2                	add    %eax,%edx
  8013d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8013dc:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8013de:	eb 03                	jmp    8013e3 <strsplit+0x8f>
			string++;
  8013e0:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8013e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8013e6:	8a 00                	mov    (%eax),%al
  8013e8:	84 c0                	test   %al,%al
  8013ea:	74 8b                	je     801377 <strsplit+0x23>
  8013ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8013ef:	8a 00                	mov    (%eax),%al
  8013f1:	0f be c0             	movsbl %al,%eax
  8013f4:	50                   	push   %eax
  8013f5:	ff 75 0c             	pushl  0xc(%ebp)
  8013f8:	e8 25 fa ff ff       	call   800e22 <strchr>
  8013fd:	83 c4 08             	add    $0x8,%esp
  801400:	85 c0                	test   %eax,%eax
  801402:	74 dc                	je     8013e0 <strsplit+0x8c>
			string++;
	}
  801404:	e9 6e ff ff ff       	jmp    801377 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801409:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  80140a:	8b 45 14             	mov    0x14(%ebp),%eax
  80140d:	8b 00                	mov    (%eax),%eax
  80140f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801416:	8b 45 10             	mov    0x10(%ebp),%eax
  801419:	01 d0                	add    %edx,%eax
  80141b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801421:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801426:	c9                   	leave  
  801427:	c3                   	ret    

00801428 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  801428:	55                   	push   %ebp
  801429:	89 e5                	mov    %esp,%ebp
  80142b:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  80142e:	8b 45 08             	mov    0x8(%ebp),%eax
  801431:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  801434:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80143b:	eb 4a                	jmp    801487 <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  80143d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801440:	8b 45 08             	mov    0x8(%ebp),%eax
  801443:	01 c2                	add    %eax,%edx
  801445:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801448:	8b 45 0c             	mov    0xc(%ebp),%eax
  80144b:	01 c8                	add    %ecx,%eax
  80144d:	8a 00                	mov    (%eax),%al
  80144f:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  801451:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801454:	8b 45 0c             	mov    0xc(%ebp),%eax
  801457:	01 d0                	add    %edx,%eax
  801459:	8a 00                	mov    (%eax),%al
  80145b:	3c 40                	cmp    $0x40,%al
  80145d:	7e 25                	jle    801484 <str2lower+0x5c>
  80145f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801462:	8b 45 0c             	mov    0xc(%ebp),%eax
  801465:	01 d0                	add    %edx,%eax
  801467:	8a 00                	mov    (%eax),%al
  801469:	3c 5a                	cmp    $0x5a,%al
  80146b:	7f 17                	jg     801484 <str2lower+0x5c>
		{
			dst[i] += 32 ;
  80146d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801470:	8b 45 08             	mov    0x8(%ebp),%eax
  801473:	01 d0                	add    %edx,%eax
  801475:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801478:	8b 55 08             	mov    0x8(%ebp),%edx
  80147b:	01 ca                	add    %ecx,%edx
  80147d:	8a 12                	mov    (%edx),%dl
  80147f:	83 c2 20             	add    $0x20,%edx
  801482:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  801484:	ff 45 fc             	incl   -0x4(%ebp)
  801487:	ff 75 0c             	pushl  0xc(%ebp)
  80148a:	e8 01 f8 ff ff       	call   800c90 <strlen>
  80148f:	83 c4 04             	add    $0x4,%esp
  801492:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801495:	7f a6                	jg     80143d <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  801497:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80149a:	c9                   	leave  
  80149b:	c3                   	ret    

0080149c <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  80149c:	55                   	push   %ebp
  80149d:	89 e5                	mov    %esp,%ebp
  80149f:	57                   	push   %edi
  8014a0:	56                   	push   %esi
  8014a1:	53                   	push   %ebx
  8014a2:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8014a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8014a8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014ab:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8014ae:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8014b1:	8b 7d 18             	mov    0x18(%ebp),%edi
  8014b4:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8014b7:	cd 30                	int    $0x30
  8014b9:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  8014bc:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8014bf:	83 c4 10             	add    $0x10,%esp
  8014c2:	5b                   	pop    %ebx
  8014c3:	5e                   	pop    %esi
  8014c4:	5f                   	pop    %edi
  8014c5:	5d                   	pop    %ebp
  8014c6:	c3                   	ret    

008014c7 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  8014c7:	55                   	push   %ebp
  8014c8:	89 e5                	mov    %esp,%ebp
  8014ca:	83 ec 04             	sub    $0x4,%esp
  8014cd:	8b 45 10             	mov    0x10(%ebp),%eax
  8014d0:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  8014d3:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8014d6:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8014da:	8b 45 08             	mov    0x8(%ebp),%eax
  8014dd:	6a 00                	push   $0x0
  8014df:	51                   	push   %ecx
  8014e0:	52                   	push   %edx
  8014e1:	ff 75 0c             	pushl  0xc(%ebp)
  8014e4:	50                   	push   %eax
  8014e5:	6a 00                	push   $0x0
  8014e7:	e8 b0 ff ff ff       	call   80149c <syscall>
  8014ec:	83 c4 18             	add    $0x18,%esp
}
  8014ef:	90                   	nop
  8014f0:	c9                   	leave  
  8014f1:	c3                   	ret    

008014f2 <sys_cgetc>:

int
sys_cgetc(void)
{
  8014f2:	55                   	push   %ebp
  8014f3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8014f5:	6a 00                	push   $0x0
  8014f7:	6a 00                	push   $0x0
  8014f9:	6a 00                	push   $0x0
  8014fb:	6a 00                	push   $0x0
  8014fd:	6a 00                	push   $0x0
  8014ff:	6a 02                	push   $0x2
  801501:	e8 96 ff ff ff       	call   80149c <syscall>
  801506:	83 c4 18             	add    $0x18,%esp
}
  801509:	c9                   	leave  
  80150a:	c3                   	ret    

0080150b <sys_lock_cons>:

void sys_lock_cons(void)
{
  80150b:	55                   	push   %ebp
  80150c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  80150e:	6a 00                	push   $0x0
  801510:	6a 00                	push   $0x0
  801512:	6a 00                	push   $0x0
  801514:	6a 00                	push   $0x0
  801516:	6a 00                	push   $0x0
  801518:	6a 03                	push   $0x3
  80151a:	e8 7d ff ff ff       	call   80149c <syscall>
  80151f:	83 c4 18             	add    $0x18,%esp
}
  801522:	90                   	nop
  801523:	c9                   	leave  
  801524:	c3                   	ret    

00801525 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  801525:	55                   	push   %ebp
  801526:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  801528:	6a 00                	push   $0x0
  80152a:	6a 00                	push   $0x0
  80152c:	6a 00                	push   $0x0
  80152e:	6a 00                	push   $0x0
  801530:	6a 00                	push   $0x0
  801532:	6a 04                	push   $0x4
  801534:	e8 63 ff ff ff       	call   80149c <syscall>
  801539:	83 c4 18             	add    $0x18,%esp
}
  80153c:	90                   	nop
  80153d:	c9                   	leave  
  80153e:	c3                   	ret    

0080153f <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  80153f:	55                   	push   %ebp
  801540:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801542:	8b 55 0c             	mov    0xc(%ebp),%edx
  801545:	8b 45 08             	mov    0x8(%ebp),%eax
  801548:	6a 00                	push   $0x0
  80154a:	6a 00                	push   $0x0
  80154c:	6a 00                	push   $0x0
  80154e:	52                   	push   %edx
  80154f:	50                   	push   %eax
  801550:	6a 08                	push   $0x8
  801552:	e8 45 ff ff ff       	call   80149c <syscall>
  801557:	83 c4 18             	add    $0x18,%esp
}
  80155a:	c9                   	leave  
  80155b:	c3                   	ret    

0080155c <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  80155c:	55                   	push   %ebp
  80155d:	89 e5                	mov    %esp,%ebp
  80155f:	56                   	push   %esi
  801560:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801561:	8b 75 18             	mov    0x18(%ebp),%esi
  801564:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801567:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80156a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80156d:	8b 45 08             	mov    0x8(%ebp),%eax
  801570:	56                   	push   %esi
  801571:	53                   	push   %ebx
  801572:	51                   	push   %ecx
  801573:	52                   	push   %edx
  801574:	50                   	push   %eax
  801575:	6a 09                	push   $0x9
  801577:	e8 20 ff ff ff       	call   80149c <syscall>
  80157c:	83 c4 18             	add    $0x18,%esp
}
  80157f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801582:	5b                   	pop    %ebx
  801583:	5e                   	pop    %esi
  801584:	5d                   	pop    %ebp
  801585:	c3                   	ret    

00801586 <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  801586:	55                   	push   %ebp
  801587:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  801589:	6a 00                	push   $0x0
  80158b:	6a 00                	push   $0x0
  80158d:	6a 00                	push   $0x0
  80158f:	6a 00                	push   $0x0
  801591:	ff 75 08             	pushl  0x8(%ebp)
  801594:	6a 0a                	push   $0xa
  801596:	e8 01 ff ff ff       	call   80149c <syscall>
  80159b:	83 c4 18             	add    $0x18,%esp
}
  80159e:	c9                   	leave  
  80159f:	c3                   	ret    

008015a0 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8015a0:	55                   	push   %ebp
  8015a1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8015a3:	6a 00                	push   $0x0
  8015a5:	6a 00                	push   $0x0
  8015a7:	6a 00                	push   $0x0
  8015a9:	ff 75 0c             	pushl  0xc(%ebp)
  8015ac:	ff 75 08             	pushl  0x8(%ebp)
  8015af:	6a 0b                	push   $0xb
  8015b1:	e8 e6 fe ff ff       	call   80149c <syscall>
  8015b6:	83 c4 18             	add    $0x18,%esp
}
  8015b9:	c9                   	leave  
  8015ba:	c3                   	ret    

008015bb <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8015bb:	55                   	push   %ebp
  8015bc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8015be:	6a 00                	push   $0x0
  8015c0:	6a 00                	push   $0x0
  8015c2:	6a 00                	push   $0x0
  8015c4:	6a 00                	push   $0x0
  8015c6:	6a 00                	push   $0x0
  8015c8:	6a 0c                	push   $0xc
  8015ca:	e8 cd fe ff ff       	call   80149c <syscall>
  8015cf:	83 c4 18             	add    $0x18,%esp
}
  8015d2:	c9                   	leave  
  8015d3:	c3                   	ret    

008015d4 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8015d4:	55                   	push   %ebp
  8015d5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8015d7:	6a 00                	push   $0x0
  8015d9:	6a 00                	push   $0x0
  8015db:	6a 00                	push   $0x0
  8015dd:	6a 00                	push   $0x0
  8015df:	6a 00                	push   $0x0
  8015e1:	6a 0d                	push   $0xd
  8015e3:	e8 b4 fe ff ff       	call   80149c <syscall>
  8015e8:	83 c4 18             	add    $0x18,%esp
}
  8015eb:	c9                   	leave  
  8015ec:	c3                   	ret    

008015ed <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8015ed:	55                   	push   %ebp
  8015ee:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8015f0:	6a 00                	push   $0x0
  8015f2:	6a 00                	push   $0x0
  8015f4:	6a 00                	push   $0x0
  8015f6:	6a 00                	push   $0x0
  8015f8:	6a 00                	push   $0x0
  8015fa:	6a 0e                	push   $0xe
  8015fc:	e8 9b fe ff ff       	call   80149c <syscall>
  801601:	83 c4 18             	add    $0x18,%esp
}
  801604:	c9                   	leave  
  801605:	c3                   	ret    

00801606 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801606:	55                   	push   %ebp
  801607:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801609:	6a 00                	push   $0x0
  80160b:	6a 00                	push   $0x0
  80160d:	6a 00                	push   $0x0
  80160f:	6a 00                	push   $0x0
  801611:	6a 00                	push   $0x0
  801613:	6a 0f                	push   $0xf
  801615:	e8 82 fe ff ff       	call   80149c <syscall>
  80161a:	83 c4 18             	add    $0x18,%esp
}
  80161d:	c9                   	leave  
  80161e:	c3                   	ret    

0080161f <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  80161f:	55                   	push   %ebp
  801620:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801622:	6a 00                	push   $0x0
  801624:	6a 00                	push   $0x0
  801626:	6a 00                	push   $0x0
  801628:	6a 00                	push   $0x0
  80162a:	ff 75 08             	pushl  0x8(%ebp)
  80162d:	6a 10                	push   $0x10
  80162f:	e8 68 fe ff ff       	call   80149c <syscall>
  801634:	83 c4 18             	add    $0x18,%esp
}
  801637:	c9                   	leave  
  801638:	c3                   	ret    

00801639 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801639:	55                   	push   %ebp
  80163a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  80163c:	6a 00                	push   $0x0
  80163e:	6a 00                	push   $0x0
  801640:	6a 00                	push   $0x0
  801642:	6a 00                	push   $0x0
  801644:	6a 00                	push   $0x0
  801646:	6a 11                	push   $0x11
  801648:	e8 4f fe ff ff       	call   80149c <syscall>
  80164d:	83 c4 18             	add    $0x18,%esp
}
  801650:	90                   	nop
  801651:	c9                   	leave  
  801652:	c3                   	ret    

00801653 <sys_cputc>:

void
sys_cputc(const char c)
{
  801653:	55                   	push   %ebp
  801654:	89 e5                	mov    %esp,%ebp
  801656:	83 ec 04             	sub    $0x4,%esp
  801659:	8b 45 08             	mov    0x8(%ebp),%eax
  80165c:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  80165f:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801663:	6a 00                	push   $0x0
  801665:	6a 00                	push   $0x0
  801667:	6a 00                	push   $0x0
  801669:	6a 00                	push   $0x0
  80166b:	50                   	push   %eax
  80166c:	6a 01                	push   $0x1
  80166e:	e8 29 fe ff ff       	call   80149c <syscall>
  801673:	83 c4 18             	add    $0x18,%esp
}
  801676:	90                   	nop
  801677:	c9                   	leave  
  801678:	c3                   	ret    

00801679 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801679:	55                   	push   %ebp
  80167a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  80167c:	6a 00                	push   $0x0
  80167e:	6a 00                	push   $0x0
  801680:	6a 00                	push   $0x0
  801682:	6a 00                	push   $0x0
  801684:	6a 00                	push   $0x0
  801686:	6a 14                	push   $0x14
  801688:	e8 0f fe ff ff       	call   80149c <syscall>
  80168d:	83 c4 18             	add    $0x18,%esp
}
  801690:	90                   	nop
  801691:	c9                   	leave  
  801692:	c3                   	ret    

00801693 <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801693:	55                   	push   %ebp
  801694:	89 e5                	mov    %esp,%ebp
  801696:	83 ec 04             	sub    $0x4,%esp
  801699:	8b 45 10             	mov    0x10(%ebp),%eax
  80169c:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  80169f:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8016a2:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8016a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8016a9:	6a 00                	push   $0x0
  8016ab:	51                   	push   %ecx
  8016ac:	52                   	push   %edx
  8016ad:	ff 75 0c             	pushl  0xc(%ebp)
  8016b0:	50                   	push   %eax
  8016b1:	6a 15                	push   $0x15
  8016b3:	e8 e4 fd ff ff       	call   80149c <syscall>
  8016b8:	83 c4 18             	add    $0x18,%esp
}
  8016bb:	c9                   	leave  
  8016bc:	c3                   	ret    

008016bd <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  8016bd:	55                   	push   %ebp
  8016be:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8016c0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8016c6:	6a 00                	push   $0x0
  8016c8:	6a 00                	push   $0x0
  8016ca:	6a 00                	push   $0x0
  8016cc:	52                   	push   %edx
  8016cd:	50                   	push   %eax
  8016ce:	6a 16                	push   $0x16
  8016d0:	e8 c7 fd ff ff       	call   80149c <syscall>
  8016d5:	83 c4 18             	add    $0x18,%esp
}
  8016d8:	c9                   	leave  
  8016d9:	c3                   	ret    

008016da <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  8016da:	55                   	push   %ebp
  8016db:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8016dd:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8016e0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8016e6:	6a 00                	push   $0x0
  8016e8:	6a 00                	push   $0x0
  8016ea:	51                   	push   %ecx
  8016eb:	52                   	push   %edx
  8016ec:	50                   	push   %eax
  8016ed:	6a 17                	push   $0x17
  8016ef:	e8 a8 fd ff ff       	call   80149c <syscall>
  8016f4:	83 c4 18             	add    $0x18,%esp
}
  8016f7:	c9                   	leave  
  8016f8:	c3                   	ret    

008016f9 <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  8016f9:	55                   	push   %ebp
  8016fa:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8016fc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016ff:	8b 45 08             	mov    0x8(%ebp),%eax
  801702:	6a 00                	push   $0x0
  801704:	6a 00                	push   $0x0
  801706:	6a 00                	push   $0x0
  801708:	52                   	push   %edx
  801709:	50                   	push   %eax
  80170a:	6a 18                	push   $0x18
  80170c:	e8 8b fd ff ff       	call   80149c <syscall>
  801711:	83 c4 18             	add    $0x18,%esp
}
  801714:	c9                   	leave  
  801715:	c3                   	ret    

00801716 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801716:	55                   	push   %ebp
  801717:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801719:	8b 45 08             	mov    0x8(%ebp),%eax
  80171c:	6a 00                	push   $0x0
  80171e:	ff 75 14             	pushl  0x14(%ebp)
  801721:	ff 75 10             	pushl  0x10(%ebp)
  801724:	ff 75 0c             	pushl  0xc(%ebp)
  801727:	50                   	push   %eax
  801728:	6a 19                	push   $0x19
  80172a:	e8 6d fd ff ff       	call   80149c <syscall>
  80172f:	83 c4 18             	add    $0x18,%esp
}
  801732:	c9                   	leave  
  801733:	c3                   	ret    

00801734 <sys_run_env>:

void sys_run_env(int32 envId)
{
  801734:	55                   	push   %ebp
  801735:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801737:	8b 45 08             	mov    0x8(%ebp),%eax
  80173a:	6a 00                	push   $0x0
  80173c:	6a 00                	push   $0x0
  80173e:	6a 00                	push   $0x0
  801740:	6a 00                	push   $0x0
  801742:	50                   	push   %eax
  801743:	6a 1a                	push   $0x1a
  801745:	e8 52 fd ff ff       	call   80149c <syscall>
  80174a:	83 c4 18             	add    $0x18,%esp
}
  80174d:	90                   	nop
  80174e:	c9                   	leave  
  80174f:	c3                   	ret    

00801750 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801750:	55                   	push   %ebp
  801751:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801753:	8b 45 08             	mov    0x8(%ebp),%eax
  801756:	6a 00                	push   $0x0
  801758:	6a 00                	push   $0x0
  80175a:	6a 00                	push   $0x0
  80175c:	6a 00                	push   $0x0
  80175e:	50                   	push   %eax
  80175f:	6a 1b                	push   $0x1b
  801761:	e8 36 fd ff ff       	call   80149c <syscall>
  801766:	83 c4 18             	add    $0x18,%esp
}
  801769:	c9                   	leave  
  80176a:	c3                   	ret    

0080176b <sys_getenvid>:

int32 sys_getenvid(void)
{
  80176b:	55                   	push   %ebp
  80176c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  80176e:	6a 00                	push   $0x0
  801770:	6a 00                	push   $0x0
  801772:	6a 00                	push   $0x0
  801774:	6a 00                	push   $0x0
  801776:	6a 00                	push   $0x0
  801778:	6a 05                	push   $0x5
  80177a:	e8 1d fd ff ff       	call   80149c <syscall>
  80177f:	83 c4 18             	add    $0x18,%esp
}
  801782:	c9                   	leave  
  801783:	c3                   	ret    

00801784 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801784:	55                   	push   %ebp
  801785:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801787:	6a 00                	push   $0x0
  801789:	6a 00                	push   $0x0
  80178b:	6a 00                	push   $0x0
  80178d:	6a 00                	push   $0x0
  80178f:	6a 00                	push   $0x0
  801791:	6a 06                	push   $0x6
  801793:	e8 04 fd ff ff       	call   80149c <syscall>
  801798:	83 c4 18             	add    $0x18,%esp
}
  80179b:	c9                   	leave  
  80179c:	c3                   	ret    

0080179d <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  80179d:	55                   	push   %ebp
  80179e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8017a0:	6a 00                	push   $0x0
  8017a2:	6a 00                	push   $0x0
  8017a4:	6a 00                	push   $0x0
  8017a6:	6a 00                	push   $0x0
  8017a8:	6a 00                	push   $0x0
  8017aa:	6a 07                	push   $0x7
  8017ac:	e8 eb fc ff ff       	call   80149c <syscall>
  8017b1:	83 c4 18             	add    $0x18,%esp
}
  8017b4:	c9                   	leave  
  8017b5:	c3                   	ret    

008017b6 <sys_exit_env>:


void sys_exit_env(void)
{
  8017b6:	55                   	push   %ebp
  8017b7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  8017b9:	6a 00                	push   $0x0
  8017bb:	6a 00                	push   $0x0
  8017bd:	6a 00                	push   $0x0
  8017bf:	6a 00                	push   $0x0
  8017c1:	6a 00                	push   $0x0
  8017c3:	6a 1c                	push   $0x1c
  8017c5:	e8 d2 fc ff ff       	call   80149c <syscall>
  8017ca:	83 c4 18             	add    $0x18,%esp
}
  8017cd:	90                   	nop
  8017ce:	c9                   	leave  
  8017cf:	c3                   	ret    

008017d0 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  8017d0:	55                   	push   %ebp
  8017d1:	89 e5                	mov    %esp,%ebp
  8017d3:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8017d6:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8017d9:	8d 50 04             	lea    0x4(%eax),%edx
  8017dc:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8017df:	6a 00                	push   $0x0
  8017e1:	6a 00                	push   $0x0
  8017e3:	6a 00                	push   $0x0
  8017e5:	52                   	push   %edx
  8017e6:	50                   	push   %eax
  8017e7:	6a 1d                	push   $0x1d
  8017e9:	e8 ae fc ff ff       	call   80149c <syscall>
  8017ee:	83 c4 18             	add    $0x18,%esp
	return result;
  8017f1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8017f4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8017f7:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8017fa:	89 01                	mov    %eax,(%ecx)
  8017fc:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8017ff:	8b 45 08             	mov    0x8(%ebp),%eax
  801802:	c9                   	leave  
  801803:	c2 04 00             	ret    $0x4

00801806 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801806:	55                   	push   %ebp
  801807:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801809:	6a 00                	push   $0x0
  80180b:	6a 00                	push   $0x0
  80180d:	ff 75 10             	pushl  0x10(%ebp)
  801810:	ff 75 0c             	pushl  0xc(%ebp)
  801813:	ff 75 08             	pushl  0x8(%ebp)
  801816:	6a 13                	push   $0x13
  801818:	e8 7f fc ff ff       	call   80149c <syscall>
  80181d:	83 c4 18             	add    $0x18,%esp
	return ;
  801820:	90                   	nop
}
  801821:	c9                   	leave  
  801822:	c3                   	ret    

00801823 <sys_rcr2>:
uint32 sys_rcr2()
{
  801823:	55                   	push   %ebp
  801824:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801826:	6a 00                	push   $0x0
  801828:	6a 00                	push   $0x0
  80182a:	6a 00                	push   $0x0
  80182c:	6a 00                	push   $0x0
  80182e:	6a 00                	push   $0x0
  801830:	6a 1e                	push   $0x1e
  801832:	e8 65 fc ff ff       	call   80149c <syscall>
  801837:	83 c4 18             	add    $0x18,%esp
}
  80183a:	c9                   	leave  
  80183b:	c3                   	ret    

0080183c <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  80183c:	55                   	push   %ebp
  80183d:	89 e5                	mov    %esp,%ebp
  80183f:	83 ec 04             	sub    $0x4,%esp
  801842:	8b 45 08             	mov    0x8(%ebp),%eax
  801845:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801848:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  80184c:	6a 00                	push   $0x0
  80184e:	6a 00                	push   $0x0
  801850:	6a 00                	push   $0x0
  801852:	6a 00                	push   $0x0
  801854:	50                   	push   %eax
  801855:	6a 1f                	push   $0x1f
  801857:	e8 40 fc ff ff       	call   80149c <syscall>
  80185c:	83 c4 18             	add    $0x18,%esp
	return ;
  80185f:	90                   	nop
}
  801860:	c9                   	leave  
  801861:	c3                   	ret    

00801862 <rsttst>:
void rsttst()
{
  801862:	55                   	push   %ebp
  801863:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801865:	6a 00                	push   $0x0
  801867:	6a 00                	push   $0x0
  801869:	6a 00                	push   $0x0
  80186b:	6a 00                	push   $0x0
  80186d:	6a 00                	push   $0x0
  80186f:	6a 21                	push   $0x21
  801871:	e8 26 fc ff ff       	call   80149c <syscall>
  801876:	83 c4 18             	add    $0x18,%esp
	return ;
  801879:	90                   	nop
}
  80187a:	c9                   	leave  
  80187b:	c3                   	ret    

0080187c <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  80187c:	55                   	push   %ebp
  80187d:	89 e5                	mov    %esp,%ebp
  80187f:	83 ec 04             	sub    $0x4,%esp
  801882:	8b 45 14             	mov    0x14(%ebp),%eax
  801885:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801888:	8b 55 18             	mov    0x18(%ebp),%edx
  80188b:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80188f:	52                   	push   %edx
  801890:	50                   	push   %eax
  801891:	ff 75 10             	pushl  0x10(%ebp)
  801894:	ff 75 0c             	pushl  0xc(%ebp)
  801897:	ff 75 08             	pushl  0x8(%ebp)
  80189a:	6a 20                	push   $0x20
  80189c:	e8 fb fb ff ff       	call   80149c <syscall>
  8018a1:	83 c4 18             	add    $0x18,%esp
	return ;
  8018a4:	90                   	nop
}
  8018a5:	c9                   	leave  
  8018a6:	c3                   	ret    

008018a7 <chktst>:
void chktst(uint32 n)
{
  8018a7:	55                   	push   %ebp
  8018a8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8018aa:	6a 00                	push   $0x0
  8018ac:	6a 00                	push   $0x0
  8018ae:	6a 00                	push   $0x0
  8018b0:	6a 00                	push   $0x0
  8018b2:	ff 75 08             	pushl  0x8(%ebp)
  8018b5:	6a 22                	push   $0x22
  8018b7:	e8 e0 fb ff ff       	call   80149c <syscall>
  8018bc:	83 c4 18             	add    $0x18,%esp
	return ;
  8018bf:	90                   	nop
}
  8018c0:	c9                   	leave  
  8018c1:	c3                   	ret    

008018c2 <inctst>:

void inctst()
{
  8018c2:	55                   	push   %ebp
  8018c3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8018c5:	6a 00                	push   $0x0
  8018c7:	6a 00                	push   $0x0
  8018c9:	6a 00                	push   $0x0
  8018cb:	6a 00                	push   $0x0
  8018cd:	6a 00                	push   $0x0
  8018cf:	6a 23                	push   $0x23
  8018d1:	e8 c6 fb ff ff       	call   80149c <syscall>
  8018d6:	83 c4 18             	add    $0x18,%esp
	return ;
  8018d9:	90                   	nop
}
  8018da:	c9                   	leave  
  8018db:	c3                   	ret    

008018dc <gettst>:
uint32 gettst()
{
  8018dc:	55                   	push   %ebp
  8018dd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8018df:	6a 00                	push   $0x0
  8018e1:	6a 00                	push   $0x0
  8018e3:	6a 00                	push   $0x0
  8018e5:	6a 00                	push   $0x0
  8018e7:	6a 00                	push   $0x0
  8018e9:	6a 24                	push   $0x24
  8018eb:	e8 ac fb ff ff       	call   80149c <syscall>
  8018f0:	83 c4 18             	add    $0x18,%esp
}
  8018f3:	c9                   	leave  
  8018f4:	c3                   	ret    

008018f5 <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  8018f5:	55                   	push   %ebp
  8018f6:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8018f8:	6a 00                	push   $0x0
  8018fa:	6a 00                	push   $0x0
  8018fc:	6a 00                	push   $0x0
  8018fe:	6a 00                	push   $0x0
  801900:	6a 00                	push   $0x0
  801902:	6a 25                	push   $0x25
  801904:	e8 93 fb ff ff       	call   80149c <syscall>
  801909:	83 c4 18             	add    $0x18,%esp
  80190c:	a3 60 b0 81 00       	mov    %eax,0x81b060
	return uheapPlaceStrategy ;
  801911:	a1 60 b0 81 00       	mov    0x81b060,%eax
}
  801916:	c9                   	leave  
  801917:	c3                   	ret    

00801918 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801918:	55                   	push   %ebp
  801919:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  80191b:	8b 45 08             	mov    0x8(%ebp),%eax
  80191e:	a3 60 b0 81 00       	mov    %eax,0x81b060
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801923:	6a 00                	push   $0x0
  801925:	6a 00                	push   $0x0
  801927:	6a 00                	push   $0x0
  801929:	6a 00                	push   $0x0
  80192b:	ff 75 08             	pushl  0x8(%ebp)
  80192e:	6a 26                	push   $0x26
  801930:	e8 67 fb ff ff       	call   80149c <syscall>
  801935:	83 c4 18             	add    $0x18,%esp
	return ;
  801938:	90                   	nop
}
  801939:	c9                   	leave  
  80193a:	c3                   	ret    

0080193b <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  80193b:	55                   	push   %ebp
  80193c:	89 e5                	mov    %esp,%ebp
  80193e:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  80193f:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801942:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801945:	8b 55 0c             	mov    0xc(%ebp),%edx
  801948:	8b 45 08             	mov    0x8(%ebp),%eax
  80194b:	6a 00                	push   $0x0
  80194d:	53                   	push   %ebx
  80194e:	51                   	push   %ecx
  80194f:	52                   	push   %edx
  801950:	50                   	push   %eax
  801951:	6a 27                	push   $0x27
  801953:	e8 44 fb ff ff       	call   80149c <syscall>
  801958:	83 c4 18             	add    $0x18,%esp
}
  80195b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80195e:	c9                   	leave  
  80195f:	c3                   	ret    

00801960 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801960:	55                   	push   %ebp
  801961:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801963:	8b 55 0c             	mov    0xc(%ebp),%edx
  801966:	8b 45 08             	mov    0x8(%ebp),%eax
  801969:	6a 00                	push   $0x0
  80196b:	6a 00                	push   $0x0
  80196d:	6a 00                	push   $0x0
  80196f:	52                   	push   %edx
  801970:	50                   	push   %eax
  801971:	6a 28                	push   $0x28
  801973:	e8 24 fb ff ff       	call   80149c <syscall>
  801978:	83 c4 18             	add    $0x18,%esp
}
  80197b:	c9                   	leave  
  80197c:	c3                   	ret    

0080197d <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  80197d:	55                   	push   %ebp
  80197e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801980:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801983:	8b 55 0c             	mov    0xc(%ebp),%edx
  801986:	8b 45 08             	mov    0x8(%ebp),%eax
  801989:	6a 00                	push   $0x0
  80198b:	51                   	push   %ecx
  80198c:	ff 75 10             	pushl  0x10(%ebp)
  80198f:	52                   	push   %edx
  801990:	50                   	push   %eax
  801991:	6a 29                	push   $0x29
  801993:	e8 04 fb ff ff       	call   80149c <syscall>
  801998:	83 c4 18             	add    $0x18,%esp
}
  80199b:	c9                   	leave  
  80199c:	c3                   	ret    

0080199d <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  80199d:	55                   	push   %ebp
  80199e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8019a0:	6a 00                	push   $0x0
  8019a2:	6a 00                	push   $0x0
  8019a4:	ff 75 10             	pushl  0x10(%ebp)
  8019a7:	ff 75 0c             	pushl  0xc(%ebp)
  8019aa:	ff 75 08             	pushl  0x8(%ebp)
  8019ad:	6a 12                	push   $0x12
  8019af:	e8 e8 fa ff ff       	call   80149c <syscall>
  8019b4:	83 c4 18             	add    $0x18,%esp
	return ;
  8019b7:	90                   	nop
}
  8019b8:	c9                   	leave  
  8019b9:	c3                   	ret    

008019ba <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  8019ba:	55                   	push   %ebp
  8019bb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  8019bd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8019c3:	6a 00                	push   $0x0
  8019c5:	6a 00                	push   $0x0
  8019c7:	6a 00                	push   $0x0
  8019c9:	52                   	push   %edx
  8019ca:	50                   	push   %eax
  8019cb:	6a 2a                	push   $0x2a
  8019cd:	e8 ca fa ff ff       	call   80149c <syscall>
  8019d2:	83 c4 18             	add    $0x18,%esp
	return;
  8019d5:	90                   	nop
}
  8019d6:	c9                   	leave  
  8019d7:	c3                   	ret    

008019d8 <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  8019d8:	55                   	push   %ebp
  8019d9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  8019db:	6a 00                	push   $0x0
  8019dd:	6a 00                	push   $0x0
  8019df:	6a 00                	push   $0x0
  8019e1:	6a 00                	push   $0x0
  8019e3:	6a 00                	push   $0x0
  8019e5:	6a 2b                	push   $0x2b
  8019e7:	e8 b0 fa ff ff       	call   80149c <syscall>
  8019ec:	83 c4 18             	add    $0x18,%esp
}
  8019ef:	c9                   	leave  
  8019f0:	c3                   	ret    

008019f1 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8019f1:	55                   	push   %ebp
  8019f2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  8019f4:	6a 00                	push   $0x0
  8019f6:	6a 00                	push   $0x0
  8019f8:	6a 00                	push   $0x0
  8019fa:	ff 75 0c             	pushl  0xc(%ebp)
  8019fd:	ff 75 08             	pushl  0x8(%ebp)
  801a00:	6a 2d                	push   $0x2d
  801a02:	e8 95 fa ff ff       	call   80149c <syscall>
  801a07:	83 c4 18             	add    $0x18,%esp
	return;
  801a0a:	90                   	nop
}
  801a0b:	c9                   	leave  
  801a0c:	c3                   	ret    

00801a0d <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801a0d:	55                   	push   %ebp
  801a0e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801a10:	6a 00                	push   $0x0
  801a12:	6a 00                	push   $0x0
  801a14:	6a 00                	push   $0x0
  801a16:	ff 75 0c             	pushl  0xc(%ebp)
  801a19:	ff 75 08             	pushl  0x8(%ebp)
  801a1c:	6a 2c                	push   $0x2c
  801a1e:	e8 79 fa ff ff       	call   80149c <syscall>
  801a23:	83 c4 18             	add    $0x18,%esp
	return ;
  801a26:	90                   	nop
}
  801a27:	c9                   	leave  
  801a28:	c3                   	ret    

00801a29 <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  801a29:	55                   	push   %ebp
  801a2a:	89 e5                	mov    %esp,%ebp
	//TODO: [PROJECT'25.IM#4] CPU SCHEDULING - #1 System Calls - Add suitable code here
	//Your code is here
	//Comment the following line
	//panic("sys_env_set_priority() is not implemented yet...!!");
	syscall(SYS_env_set_priority, envID, priority, 0, 0, 0);
  801a2c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a2f:	8b 45 08             	mov    0x8(%ebp),%eax
  801a32:	6a 00                	push   $0x0
  801a34:	6a 00                	push   $0x0
  801a36:	6a 00                	push   $0x0
  801a38:	52                   	push   %edx
  801a39:	50                   	push   %eax
  801a3a:	6a 2e                	push   $0x2e
  801a3c:	e8 5b fa ff ff       	call   80149c <syscall>
  801a41:	83 c4 18             	add    $0x18,%esp
	    return;
  801a44:	90                   	nop
}
  801a45:	c9                   	leave  
  801a46:	c3                   	ret    

00801a47 <create_semaphore>:
// User-level Semaphore

#include "inc/lib.h"

struct semaphore create_semaphore(char *semaphoreName, uint32 value)
{
  801a47:	55                   	push   %ebp
  801a48:	89 e5                	mov    %esp,%ebp
  801a4a:	83 ec 08             	sub    $0x8,%esp
	panic("create_semaphore() is not implemented yet...!!");
  801a4d:	83 ec 04             	sub    $0x4,%esp
  801a50:	68 08 25 80 00       	push   $0x802508
  801a55:	6a 07                	push   $0x7
  801a57:	68 37 25 80 00       	push   $0x802537
  801a5c:	e8 88 e8 ff ff       	call   8002e9 <_panic>

00801a61 <get_semaphore>:
}
struct semaphore get_semaphore(int32 ownerEnvID, char* semaphoreName)
{
  801a61:	55                   	push   %ebp
  801a62:	89 e5                	mov    %esp,%ebp
  801a64:	83 ec 08             	sub    $0x8,%esp
	panic("get_semaphore() is not implemented yet...!!");
  801a67:	83 ec 04             	sub    $0x4,%esp
  801a6a:	68 48 25 80 00       	push   $0x802548
  801a6f:	6a 0b                	push   $0xb
  801a71:	68 37 25 80 00       	push   $0x802537
  801a76:	e8 6e e8 ff ff       	call   8002e9 <_panic>

00801a7b <wait_semaphore>:
}

void wait_semaphore(struct semaphore sem)
{
  801a7b:	55                   	push   %ebp
  801a7c:	89 e5                	mov    %esp,%ebp
  801a7e:	83 ec 08             	sub    $0x8,%esp
	panic("wait_semaphore() is not implemented yet...!!");
  801a81:	83 ec 04             	sub    $0x4,%esp
  801a84:	68 74 25 80 00       	push   $0x802574
  801a89:	6a 10                	push   $0x10
  801a8b:	68 37 25 80 00       	push   $0x802537
  801a90:	e8 54 e8 ff ff       	call   8002e9 <_panic>

00801a95 <signal_semaphore>:
}

void signal_semaphore(struct semaphore sem)
{
  801a95:	55                   	push   %ebp
  801a96:	89 e5                	mov    %esp,%ebp
  801a98:	83 ec 08             	sub    $0x8,%esp
	panic("signal_semaphore() is not implemented yet...!!");
  801a9b:	83 ec 04             	sub    $0x4,%esp
  801a9e:	68 a4 25 80 00       	push   $0x8025a4
  801aa3:	6a 15                	push   $0x15
  801aa5:	68 37 25 80 00       	push   $0x802537
  801aaa:	e8 3a e8 ff ff       	call   8002e9 <_panic>

00801aaf <semaphore_count>:
}

int semaphore_count(struct semaphore sem)
{
  801aaf:	55                   	push   %ebp
  801ab0:	89 e5                	mov    %esp,%ebp
	return sem.semdata->count;
  801ab2:	8b 45 08             	mov    0x8(%ebp),%eax
  801ab5:	8b 40 10             	mov    0x10(%eax),%eax
}
  801ab8:	5d                   	pop    %ebp
  801ab9:	c3                   	ret    

00801aba <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  801aba:	55                   	push   %ebp
  801abb:	89 e5                	mov    %esp,%ebp
  801abd:	83 ec 30             	sub    $0x30,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  801ac0:	8b 55 08             	mov    0x8(%ebp),%edx
  801ac3:	89 d0                	mov    %edx,%eax
  801ac5:	c1 e0 02             	shl    $0x2,%eax
  801ac8:	01 d0                	add    %edx,%eax
  801aca:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801ad1:	01 d0                	add    %edx,%eax
  801ad3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801ada:	01 d0                	add    %edx,%eax
  801adc:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801ae3:	01 d0                	add    %edx,%eax
  801ae5:	c1 e0 04             	shl    $0x4,%eax
  801ae8:	89 45 f8             	mov    %eax,-0x8(%ebp)
	uint32 cycles_counter =0;
  801aeb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)

static inline __attribute__((always_inline)) struct uint64 get_virtual_time_user()
{
	struct uint64 result;

	__asm __volatile("rdtsc\n"
  801af2:	0f 31                	rdtsc  
  801af4:	89 45 e8             	mov    %eax,-0x18(%ebp)
  801af7:	89 55 ec             	mov    %edx,-0x14(%ebp)
	: "=a" (result.low), "=d" (result.hi)
	);

	return result;
  801afa:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801afd:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801b00:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801b03:	89 55 f4             	mov    %edx,-0xc(%ebp)

	/*2024*/ //USE A USER-SIDE VERSION OF THIS FUNCTION TO AVOID SLOW-DOWN THE PERFORMANCE DUE SYS_CALL (el7 :))
	//struct uint64 baseTime = sys_get_virtual_time() ;
	struct uint64 baseTime = get_virtual_time_user() ;
	while(cycles_counter<time_in_cycles)
  801b06:	eb 46                	jmp    801b4e <env_sleep+0x94>

static inline __attribute__((always_inline)) struct uint64 get_virtual_time_user()
{
	struct uint64 result;

	__asm __volatile("rdtsc\n"
  801b08:	0f 31                	rdtsc  
  801b0a:	89 45 d0             	mov    %eax,-0x30(%ebp)
  801b0d:	89 55 d4             	mov    %edx,-0x2c(%ebp)
	: "=a" (result.low), "=d" (result.hi)
	);

	return result;
  801b10:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801b13:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  801b16:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801b19:	89 55 e4             	mov    %edx,-0x1c(%ebp)

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  801b1c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801b1f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b22:	29 c2                	sub    %eax,%edx
  801b24:	89 d0                	mov    %edx,%eax
  801b26:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  801b29:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801b2c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b2f:	89 d1                	mov    %edx,%ecx
  801b31:	29 c1                	sub    %eax,%ecx
  801b33:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801b36:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801b39:	39 c2                	cmp    %eax,%edx
  801b3b:	0f 97 c0             	seta   %al
  801b3e:	0f b6 c0             	movzbl %al,%eax
  801b41:	29 c1                	sub    %eax,%ecx
  801b43:	89 c8                	mov    %ecx,%eax
  801b45:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  801b48:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801b4b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint32 cycles_counter =0;

	/*2024*/ //USE A USER-SIDE VERSION OF THIS FUNCTION TO AVOID SLOW-DOWN THE PERFORMANCE DUE SYS_CALL (el7 :))
	//struct uint64 baseTime = sys_get_virtual_time() ;
	struct uint64 baseTime = get_virtual_time_user() ;
	while(cycles_counter<time_in_cycles)
  801b4e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801b51:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801b54:	72 b2                	jb     801b08 <env_sleep+0x4e>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  801b56:	90                   	nop
  801b57:	c9                   	leave  
  801b58:	c3                   	ret    

00801b59 <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  801b59:	55                   	push   %ebp
  801b5a:	89 e5                	mov    %esp,%ebp
  801b5c:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  801b5f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  801b66:	eb 03                	jmp    801b6b <busy_wait+0x12>
  801b68:	ff 45 fc             	incl   -0x4(%ebp)
  801b6b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801b6e:	3b 45 08             	cmp    0x8(%ebp),%eax
  801b71:	72 f5                	jb     801b68 <busy_wait+0xf>
	return i;
  801b73:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801b76:	c9                   	leave  
  801b77:	c3                   	ret    

00801b78 <__udivdi3>:
  801b78:	55                   	push   %ebp
  801b79:	57                   	push   %edi
  801b7a:	56                   	push   %esi
  801b7b:	53                   	push   %ebx
  801b7c:	83 ec 1c             	sub    $0x1c,%esp
  801b7f:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801b83:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801b87:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801b8b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801b8f:	89 ca                	mov    %ecx,%edx
  801b91:	89 f8                	mov    %edi,%eax
  801b93:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801b97:	85 f6                	test   %esi,%esi
  801b99:	75 2d                	jne    801bc8 <__udivdi3+0x50>
  801b9b:	39 cf                	cmp    %ecx,%edi
  801b9d:	77 65                	ja     801c04 <__udivdi3+0x8c>
  801b9f:	89 fd                	mov    %edi,%ebp
  801ba1:	85 ff                	test   %edi,%edi
  801ba3:	75 0b                	jne    801bb0 <__udivdi3+0x38>
  801ba5:	b8 01 00 00 00       	mov    $0x1,%eax
  801baa:	31 d2                	xor    %edx,%edx
  801bac:	f7 f7                	div    %edi
  801bae:	89 c5                	mov    %eax,%ebp
  801bb0:	31 d2                	xor    %edx,%edx
  801bb2:	89 c8                	mov    %ecx,%eax
  801bb4:	f7 f5                	div    %ebp
  801bb6:	89 c1                	mov    %eax,%ecx
  801bb8:	89 d8                	mov    %ebx,%eax
  801bba:	f7 f5                	div    %ebp
  801bbc:	89 cf                	mov    %ecx,%edi
  801bbe:	89 fa                	mov    %edi,%edx
  801bc0:	83 c4 1c             	add    $0x1c,%esp
  801bc3:	5b                   	pop    %ebx
  801bc4:	5e                   	pop    %esi
  801bc5:	5f                   	pop    %edi
  801bc6:	5d                   	pop    %ebp
  801bc7:	c3                   	ret    
  801bc8:	39 ce                	cmp    %ecx,%esi
  801bca:	77 28                	ja     801bf4 <__udivdi3+0x7c>
  801bcc:	0f bd fe             	bsr    %esi,%edi
  801bcf:	83 f7 1f             	xor    $0x1f,%edi
  801bd2:	75 40                	jne    801c14 <__udivdi3+0x9c>
  801bd4:	39 ce                	cmp    %ecx,%esi
  801bd6:	72 0a                	jb     801be2 <__udivdi3+0x6a>
  801bd8:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801bdc:	0f 87 9e 00 00 00    	ja     801c80 <__udivdi3+0x108>
  801be2:	b8 01 00 00 00       	mov    $0x1,%eax
  801be7:	89 fa                	mov    %edi,%edx
  801be9:	83 c4 1c             	add    $0x1c,%esp
  801bec:	5b                   	pop    %ebx
  801bed:	5e                   	pop    %esi
  801bee:	5f                   	pop    %edi
  801bef:	5d                   	pop    %ebp
  801bf0:	c3                   	ret    
  801bf1:	8d 76 00             	lea    0x0(%esi),%esi
  801bf4:	31 ff                	xor    %edi,%edi
  801bf6:	31 c0                	xor    %eax,%eax
  801bf8:	89 fa                	mov    %edi,%edx
  801bfa:	83 c4 1c             	add    $0x1c,%esp
  801bfd:	5b                   	pop    %ebx
  801bfe:	5e                   	pop    %esi
  801bff:	5f                   	pop    %edi
  801c00:	5d                   	pop    %ebp
  801c01:	c3                   	ret    
  801c02:	66 90                	xchg   %ax,%ax
  801c04:	89 d8                	mov    %ebx,%eax
  801c06:	f7 f7                	div    %edi
  801c08:	31 ff                	xor    %edi,%edi
  801c0a:	89 fa                	mov    %edi,%edx
  801c0c:	83 c4 1c             	add    $0x1c,%esp
  801c0f:	5b                   	pop    %ebx
  801c10:	5e                   	pop    %esi
  801c11:	5f                   	pop    %edi
  801c12:	5d                   	pop    %ebp
  801c13:	c3                   	ret    
  801c14:	bd 20 00 00 00       	mov    $0x20,%ebp
  801c19:	89 eb                	mov    %ebp,%ebx
  801c1b:	29 fb                	sub    %edi,%ebx
  801c1d:	89 f9                	mov    %edi,%ecx
  801c1f:	d3 e6                	shl    %cl,%esi
  801c21:	89 c5                	mov    %eax,%ebp
  801c23:	88 d9                	mov    %bl,%cl
  801c25:	d3 ed                	shr    %cl,%ebp
  801c27:	89 e9                	mov    %ebp,%ecx
  801c29:	09 f1                	or     %esi,%ecx
  801c2b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801c2f:	89 f9                	mov    %edi,%ecx
  801c31:	d3 e0                	shl    %cl,%eax
  801c33:	89 c5                	mov    %eax,%ebp
  801c35:	89 d6                	mov    %edx,%esi
  801c37:	88 d9                	mov    %bl,%cl
  801c39:	d3 ee                	shr    %cl,%esi
  801c3b:	89 f9                	mov    %edi,%ecx
  801c3d:	d3 e2                	shl    %cl,%edx
  801c3f:	8b 44 24 08          	mov    0x8(%esp),%eax
  801c43:	88 d9                	mov    %bl,%cl
  801c45:	d3 e8                	shr    %cl,%eax
  801c47:	09 c2                	or     %eax,%edx
  801c49:	89 d0                	mov    %edx,%eax
  801c4b:	89 f2                	mov    %esi,%edx
  801c4d:	f7 74 24 0c          	divl   0xc(%esp)
  801c51:	89 d6                	mov    %edx,%esi
  801c53:	89 c3                	mov    %eax,%ebx
  801c55:	f7 e5                	mul    %ebp
  801c57:	39 d6                	cmp    %edx,%esi
  801c59:	72 19                	jb     801c74 <__udivdi3+0xfc>
  801c5b:	74 0b                	je     801c68 <__udivdi3+0xf0>
  801c5d:	89 d8                	mov    %ebx,%eax
  801c5f:	31 ff                	xor    %edi,%edi
  801c61:	e9 58 ff ff ff       	jmp    801bbe <__udivdi3+0x46>
  801c66:	66 90                	xchg   %ax,%ax
  801c68:	8b 54 24 08          	mov    0x8(%esp),%edx
  801c6c:	89 f9                	mov    %edi,%ecx
  801c6e:	d3 e2                	shl    %cl,%edx
  801c70:	39 c2                	cmp    %eax,%edx
  801c72:	73 e9                	jae    801c5d <__udivdi3+0xe5>
  801c74:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801c77:	31 ff                	xor    %edi,%edi
  801c79:	e9 40 ff ff ff       	jmp    801bbe <__udivdi3+0x46>
  801c7e:	66 90                	xchg   %ax,%ax
  801c80:	31 c0                	xor    %eax,%eax
  801c82:	e9 37 ff ff ff       	jmp    801bbe <__udivdi3+0x46>
  801c87:	90                   	nop

00801c88 <__umoddi3>:
  801c88:	55                   	push   %ebp
  801c89:	57                   	push   %edi
  801c8a:	56                   	push   %esi
  801c8b:	53                   	push   %ebx
  801c8c:	83 ec 1c             	sub    $0x1c,%esp
  801c8f:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801c93:	8b 74 24 34          	mov    0x34(%esp),%esi
  801c97:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801c9b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801c9f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801ca3:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801ca7:	89 f3                	mov    %esi,%ebx
  801ca9:	89 fa                	mov    %edi,%edx
  801cab:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801caf:	89 34 24             	mov    %esi,(%esp)
  801cb2:	85 c0                	test   %eax,%eax
  801cb4:	75 1a                	jne    801cd0 <__umoddi3+0x48>
  801cb6:	39 f7                	cmp    %esi,%edi
  801cb8:	0f 86 a2 00 00 00    	jbe    801d60 <__umoddi3+0xd8>
  801cbe:	89 c8                	mov    %ecx,%eax
  801cc0:	89 f2                	mov    %esi,%edx
  801cc2:	f7 f7                	div    %edi
  801cc4:	89 d0                	mov    %edx,%eax
  801cc6:	31 d2                	xor    %edx,%edx
  801cc8:	83 c4 1c             	add    $0x1c,%esp
  801ccb:	5b                   	pop    %ebx
  801ccc:	5e                   	pop    %esi
  801ccd:	5f                   	pop    %edi
  801cce:	5d                   	pop    %ebp
  801ccf:	c3                   	ret    
  801cd0:	39 f0                	cmp    %esi,%eax
  801cd2:	0f 87 ac 00 00 00    	ja     801d84 <__umoddi3+0xfc>
  801cd8:	0f bd e8             	bsr    %eax,%ebp
  801cdb:	83 f5 1f             	xor    $0x1f,%ebp
  801cde:	0f 84 ac 00 00 00    	je     801d90 <__umoddi3+0x108>
  801ce4:	bf 20 00 00 00       	mov    $0x20,%edi
  801ce9:	29 ef                	sub    %ebp,%edi
  801ceb:	89 fe                	mov    %edi,%esi
  801ced:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801cf1:	89 e9                	mov    %ebp,%ecx
  801cf3:	d3 e0                	shl    %cl,%eax
  801cf5:	89 d7                	mov    %edx,%edi
  801cf7:	89 f1                	mov    %esi,%ecx
  801cf9:	d3 ef                	shr    %cl,%edi
  801cfb:	09 c7                	or     %eax,%edi
  801cfd:	89 e9                	mov    %ebp,%ecx
  801cff:	d3 e2                	shl    %cl,%edx
  801d01:	89 14 24             	mov    %edx,(%esp)
  801d04:	89 d8                	mov    %ebx,%eax
  801d06:	d3 e0                	shl    %cl,%eax
  801d08:	89 c2                	mov    %eax,%edx
  801d0a:	8b 44 24 08          	mov    0x8(%esp),%eax
  801d0e:	d3 e0                	shl    %cl,%eax
  801d10:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d14:	8b 44 24 08          	mov    0x8(%esp),%eax
  801d18:	89 f1                	mov    %esi,%ecx
  801d1a:	d3 e8                	shr    %cl,%eax
  801d1c:	09 d0                	or     %edx,%eax
  801d1e:	d3 eb                	shr    %cl,%ebx
  801d20:	89 da                	mov    %ebx,%edx
  801d22:	f7 f7                	div    %edi
  801d24:	89 d3                	mov    %edx,%ebx
  801d26:	f7 24 24             	mull   (%esp)
  801d29:	89 c6                	mov    %eax,%esi
  801d2b:	89 d1                	mov    %edx,%ecx
  801d2d:	39 d3                	cmp    %edx,%ebx
  801d2f:	0f 82 87 00 00 00    	jb     801dbc <__umoddi3+0x134>
  801d35:	0f 84 91 00 00 00    	je     801dcc <__umoddi3+0x144>
  801d3b:	8b 54 24 04          	mov    0x4(%esp),%edx
  801d3f:	29 f2                	sub    %esi,%edx
  801d41:	19 cb                	sbb    %ecx,%ebx
  801d43:	89 d8                	mov    %ebx,%eax
  801d45:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801d49:	d3 e0                	shl    %cl,%eax
  801d4b:	89 e9                	mov    %ebp,%ecx
  801d4d:	d3 ea                	shr    %cl,%edx
  801d4f:	09 d0                	or     %edx,%eax
  801d51:	89 e9                	mov    %ebp,%ecx
  801d53:	d3 eb                	shr    %cl,%ebx
  801d55:	89 da                	mov    %ebx,%edx
  801d57:	83 c4 1c             	add    $0x1c,%esp
  801d5a:	5b                   	pop    %ebx
  801d5b:	5e                   	pop    %esi
  801d5c:	5f                   	pop    %edi
  801d5d:	5d                   	pop    %ebp
  801d5e:	c3                   	ret    
  801d5f:	90                   	nop
  801d60:	89 fd                	mov    %edi,%ebp
  801d62:	85 ff                	test   %edi,%edi
  801d64:	75 0b                	jne    801d71 <__umoddi3+0xe9>
  801d66:	b8 01 00 00 00       	mov    $0x1,%eax
  801d6b:	31 d2                	xor    %edx,%edx
  801d6d:	f7 f7                	div    %edi
  801d6f:	89 c5                	mov    %eax,%ebp
  801d71:	89 f0                	mov    %esi,%eax
  801d73:	31 d2                	xor    %edx,%edx
  801d75:	f7 f5                	div    %ebp
  801d77:	89 c8                	mov    %ecx,%eax
  801d79:	f7 f5                	div    %ebp
  801d7b:	89 d0                	mov    %edx,%eax
  801d7d:	e9 44 ff ff ff       	jmp    801cc6 <__umoddi3+0x3e>
  801d82:	66 90                	xchg   %ax,%ax
  801d84:	89 c8                	mov    %ecx,%eax
  801d86:	89 f2                	mov    %esi,%edx
  801d88:	83 c4 1c             	add    $0x1c,%esp
  801d8b:	5b                   	pop    %ebx
  801d8c:	5e                   	pop    %esi
  801d8d:	5f                   	pop    %edi
  801d8e:	5d                   	pop    %ebp
  801d8f:	c3                   	ret    
  801d90:	3b 04 24             	cmp    (%esp),%eax
  801d93:	72 06                	jb     801d9b <__umoddi3+0x113>
  801d95:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801d99:	77 0f                	ja     801daa <__umoddi3+0x122>
  801d9b:	89 f2                	mov    %esi,%edx
  801d9d:	29 f9                	sub    %edi,%ecx
  801d9f:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801da3:	89 14 24             	mov    %edx,(%esp)
  801da6:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801daa:	8b 44 24 04          	mov    0x4(%esp),%eax
  801dae:	8b 14 24             	mov    (%esp),%edx
  801db1:	83 c4 1c             	add    $0x1c,%esp
  801db4:	5b                   	pop    %ebx
  801db5:	5e                   	pop    %esi
  801db6:	5f                   	pop    %edi
  801db7:	5d                   	pop    %ebp
  801db8:	c3                   	ret    
  801db9:	8d 76 00             	lea    0x0(%esi),%esi
  801dbc:	2b 04 24             	sub    (%esp),%eax
  801dbf:	19 fa                	sbb    %edi,%edx
  801dc1:	89 d1                	mov    %edx,%ecx
  801dc3:	89 c6                	mov    %eax,%esi
  801dc5:	e9 71 ff ff ff       	jmp    801d3b <__umoddi3+0xb3>
  801dca:	66 90                	xchg   %ax,%ax
  801dcc:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801dd0:	72 ea                	jb     801dbc <__umoddi3+0x134>
  801dd2:	89 d9                	mov    %ebx,%ecx
  801dd4:	e9 62 ff ff ff       	jmp    801d3b <__umoddi3+0xb3>
