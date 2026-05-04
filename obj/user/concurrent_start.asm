
obj/user/concurrent_start:     file format elf32-i386


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
  800031:	e8 f9 00 00 00       	call   80012f <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
// hello, world
#include <inc/lib.h>

void
_main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	83 ec 28             	sub    $0x28,%esp
	char *str ;
	sys_create_shared_object("cnc1", 512, 1, (void*) &str);
  80003e:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800041:	50                   	push   %eax
  800042:	6a 01                	push   $0x1
  800044:	68 00 02 00 00       	push   $0x200
  800049:	68 20 1d 80 00       	push   $0x801d20
  80004e:	e8 3f 16 00 00       	call   801692 <sys_create_shared_object>
  800053:	83 c4 10             	add    $0x10,%esp

	struct semaphore cnc1 = create_semaphore("cnc1", 1);
  800056:	8d 45 e8             	lea    -0x18(%ebp),%eax
  800059:	83 ec 04             	sub    $0x4,%esp
  80005c:	6a 01                	push   $0x1
  80005e:	68 20 1d 80 00       	push   $0x801d20
  800063:	50                   	push   %eax
  800064:	e8 dd 19 00 00       	call   801a46 <create_semaphore>
  800069:	83 c4 0c             	add    $0xc,%esp
	struct semaphore depend1 = create_semaphore("depend1", 0);
  80006c:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80006f:	83 ec 04             	sub    $0x4,%esp
  800072:	6a 00                	push   $0x0
  800074:	68 25 1d 80 00       	push   $0x801d25
  800079:	50                   	push   %eax
  80007a:	e8 c7 19 00 00       	call   801a46 <create_semaphore>
  80007f:	83 c4 0c             	add    $0xc,%esp

	uint32 id1, id2;
	id2 = sys_create_env("qs2", (myEnv->page_WS_max_size), (myEnv->SecondListSize), (myEnv->percentage_of_WS_pages_to_be_removed));
  800082:	a1 20 30 80 00       	mov    0x803020,%eax
  800087:	8b 90 a8 05 00 00    	mov    0x5a8(%eax),%edx
  80008d:	a1 20 30 80 00       	mov    0x803020,%eax
  800092:	8b 80 a0 05 00 00    	mov    0x5a0(%eax),%eax
  800098:	89 c1                	mov    %eax,%ecx
  80009a:	a1 20 30 80 00       	mov    0x803020,%eax
  80009f:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  8000a5:	52                   	push   %edx
  8000a6:	51                   	push   %ecx
  8000a7:	50                   	push   %eax
  8000a8:	68 2d 1d 80 00       	push   $0x801d2d
  8000ad:	e8 63 16 00 00       	call   801715 <sys_create_env>
  8000b2:	83 c4 10             	add    $0x10,%esp
  8000b5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	id1 = sys_create_env("qs1", (myEnv->page_WS_max_size),(myEnv->SecondListSize), (myEnv->percentage_of_WS_pages_to_be_removed));
  8000b8:	a1 20 30 80 00       	mov    0x803020,%eax
  8000bd:	8b 90 a8 05 00 00    	mov    0x5a8(%eax),%edx
  8000c3:	a1 20 30 80 00       	mov    0x803020,%eax
  8000c8:	8b 80 a0 05 00 00    	mov    0x5a0(%eax),%eax
  8000ce:	89 c1                	mov    %eax,%ecx
  8000d0:	a1 20 30 80 00       	mov    0x803020,%eax
  8000d5:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  8000db:	52                   	push   %edx
  8000dc:	51                   	push   %ecx
  8000dd:	50                   	push   %eax
  8000de:	68 31 1d 80 00       	push   $0x801d31
  8000e3:	e8 2d 16 00 00       	call   801715 <sys_create_env>
  8000e8:	83 c4 10             	add    $0x10,%esp
  8000eb:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (id1 == E_ENV_CREATION_ERROR || id2 == E_ENV_CREATION_ERROR)
  8000ee:	83 7d f0 ef          	cmpl   $0xffffffef,-0x10(%ebp)
  8000f2:	74 06                	je     8000fa <_main+0xc2>
  8000f4:	83 7d f4 ef          	cmpl   $0xffffffef,-0xc(%ebp)
  8000f8:	75 14                	jne    80010e <_main+0xd6>
		panic("NO AVAILABLE ENVs...");
  8000fa:	83 ec 04             	sub    $0x4,%esp
  8000fd:	68 35 1d 80 00       	push   $0x801d35
  800102:	6a 11                	push   $0x11
  800104:	68 4a 1d 80 00       	push   $0x801d4a
  800109:	e8 da 01 00 00       	call   8002e8 <_panic>

	sys_run_env(id2);
  80010e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800111:	83 ec 0c             	sub    $0xc,%esp
  800114:	50                   	push   %eax
  800115:	e8 19 16 00 00       	call   801733 <sys_run_env>
  80011a:	83 c4 10             	add    $0x10,%esp
	sys_run_env(id1);
  80011d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800120:	83 ec 0c             	sub    $0xc,%esp
  800123:	50                   	push   %eax
  800124:	e8 0a 16 00 00       	call   801733 <sys_run_env>
  800129:	83 c4 10             	add    $0x10,%esp

	return;
  80012c:	90                   	nop
}
  80012d:	c9                   	leave  
  80012e:	c3                   	ret    

0080012f <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  80012f:	55                   	push   %ebp
  800130:	89 e5                	mov    %esp,%ebp
  800132:	57                   	push   %edi
  800133:	56                   	push   %esi
  800134:	53                   	push   %ebx
  800135:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  800138:	e8 46 16 00 00       	call   801783 <sys_getenvindex>
  80013d:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  800140:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800143:	89 d0                	mov    %edx,%eax
  800145:	c1 e0 02             	shl    $0x2,%eax
  800148:	01 d0                	add    %edx,%eax
  80014a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800151:	01 d0                	add    %edx,%eax
  800153:	89 c2                	mov    %eax,%edx
  800155:	c1 e2 04             	shl    $0x4,%edx
  800158:	29 c2                	sub    %eax,%edx
  80015a:	8d 04 95 00 00 00 00 	lea    0x0(,%edx,4),%eax
  800161:	89 c2                	mov    %eax,%edx
  800163:	8d 82 00 00 c0 ee    	lea    -0x11400000(%edx),%eax
  800169:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  80016e:	a1 20 30 80 00       	mov    0x803020,%eax
  800173:	8a 40 20             	mov    0x20(%eax),%al
  800176:	84 c0                	test   %al,%al
  800178:	74 0d                	je     800187 <libmain+0x58>
		binaryname = myEnv->prog_name;
  80017a:	a1 20 30 80 00       	mov    0x803020,%eax
  80017f:	83 c0 20             	add    $0x20,%eax
  800182:	a3 04 30 80 00       	mov    %eax,0x803004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800187:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80018b:	7e 0a                	jle    800197 <libmain+0x68>
		binaryname = argv[0];
  80018d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800190:	8b 00                	mov    (%eax),%eax
  800192:	a3 04 30 80 00       	mov    %eax,0x803004

	// call user main routine
	_main(argc, argv);
  800197:	83 ec 08             	sub    $0x8,%esp
  80019a:	ff 75 0c             	pushl  0xc(%ebp)
  80019d:	ff 75 08             	pushl  0x8(%ebp)
  8001a0:	e8 93 fe ff ff       	call   800038 <_main>
  8001a5:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  8001a8:	a1 00 30 80 00       	mov    0x803000,%eax
  8001ad:	85 c0                	test   %eax,%eax
  8001af:	0f 84 01 01 00 00    	je     8002b6 <libmain+0x187>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  8001b5:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  8001bb:	bb 5c 1e 80 00       	mov    $0x801e5c,%ebx
  8001c0:	ba 0e 00 00 00       	mov    $0xe,%edx
  8001c5:	89 c7                	mov    %eax,%edi
  8001c7:	89 de                	mov    %ebx,%esi
  8001c9:	89 d1                	mov    %edx,%ecx
  8001cb:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  8001cd:	8d 55 8a             	lea    -0x76(%ebp),%edx
  8001d0:	b9 56 00 00 00       	mov    $0x56,%ecx
  8001d5:	b0 00                	mov    $0x0,%al
  8001d7:	89 d7                	mov    %edx,%edi
  8001d9:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  8001db:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  8001e2:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8001e5:	83 ec 08             	sub    $0x8,%esp
  8001e8:	50                   	push   %eax
  8001e9:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  8001ef:	50                   	push   %eax
  8001f0:	e8 c4 17 00 00       	call   8019b9 <sys_utilities>
  8001f5:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  8001f8:	e8 0d 13 00 00       	call   80150a <sys_lock_cons>
		{
			cprintf("**************************************\n");
  8001fd:	83 ec 0c             	sub    $0xc,%esp
  800200:	68 7c 1d 80 00       	push   $0x801d7c
  800205:	e8 ac 03 00 00       	call   8005b6 <cprintf>
  80020a:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  80020d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800210:	85 c0                	test   %eax,%eax
  800212:	74 18                	je     80022c <libmain+0xfd>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  800214:	e8 be 17 00 00       	call   8019d7 <sys_get_optimal_num_faults>
  800219:	83 ec 08             	sub    $0x8,%esp
  80021c:	50                   	push   %eax
  80021d:	68 a4 1d 80 00       	push   $0x801da4
  800222:	e8 8f 03 00 00       	call   8005b6 <cprintf>
  800227:	83 c4 10             	add    $0x10,%esp
  80022a:	eb 59                	jmp    800285 <libmain+0x156>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  80022c:	a1 20 30 80 00       	mov    0x803020,%eax
  800231:	8b 90 bc 05 00 00    	mov    0x5bc(%eax),%edx
  800237:	a1 20 30 80 00       	mov    0x803020,%eax
  80023c:	8b 80 ac 05 00 00    	mov    0x5ac(%eax),%eax
  800242:	83 ec 04             	sub    $0x4,%esp
  800245:	52                   	push   %edx
  800246:	50                   	push   %eax
  800247:	68 c8 1d 80 00       	push   $0x801dc8
  80024c:	e8 65 03 00 00       	call   8005b6 <cprintf>
  800251:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800254:	a1 20 30 80 00       	mov    0x803020,%eax
  800259:	8b 88 d0 05 00 00    	mov    0x5d0(%eax),%ecx
  80025f:	a1 20 30 80 00       	mov    0x803020,%eax
  800264:	8b 90 cc 05 00 00    	mov    0x5cc(%eax),%edx
  80026a:	a1 20 30 80 00       	mov    0x803020,%eax
  80026f:	8b 80 c8 05 00 00    	mov    0x5c8(%eax),%eax
  800275:	51                   	push   %ecx
  800276:	52                   	push   %edx
  800277:	50                   	push   %eax
  800278:	68 f0 1d 80 00       	push   $0x801df0
  80027d:	e8 34 03 00 00       	call   8005b6 <cprintf>
  800282:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800285:	a1 20 30 80 00       	mov    0x803020,%eax
  80028a:	8b 80 d4 05 00 00    	mov    0x5d4(%eax),%eax
  800290:	83 ec 08             	sub    $0x8,%esp
  800293:	50                   	push   %eax
  800294:	68 48 1e 80 00       	push   $0x801e48
  800299:	e8 18 03 00 00       	call   8005b6 <cprintf>
  80029e:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  8002a1:	83 ec 0c             	sub    $0xc,%esp
  8002a4:	68 7c 1d 80 00       	push   $0x801d7c
  8002a9:	e8 08 03 00 00       	call   8005b6 <cprintf>
  8002ae:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  8002b1:	e8 6e 12 00 00       	call   801524 <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  8002b6:	e8 1f 00 00 00       	call   8002da <exit>
}
  8002bb:	90                   	nop
  8002bc:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002bf:	5b                   	pop    %ebx
  8002c0:	5e                   	pop    %esi
  8002c1:	5f                   	pop    %edi
  8002c2:	5d                   	pop    %ebp
  8002c3:	c3                   	ret    

008002c4 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8002c4:	55                   	push   %ebp
  8002c5:	89 e5                	mov    %esp,%ebp
  8002c7:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8002ca:	83 ec 0c             	sub    $0xc,%esp
  8002cd:	6a 00                	push   $0x0
  8002cf:	e8 7b 14 00 00       	call   80174f <sys_destroy_env>
  8002d4:	83 c4 10             	add    $0x10,%esp
}
  8002d7:	90                   	nop
  8002d8:	c9                   	leave  
  8002d9:	c3                   	ret    

008002da <exit>:

void
exit(void)
{
  8002da:	55                   	push   %ebp
  8002db:	89 e5                	mov    %esp,%ebp
  8002dd:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8002e0:	e8 d0 14 00 00       	call   8017b5 <sys_exit_env>
}
  8002e5:	90                   	nop
  8002e6:	c9                   	leave  
  8002e7:	c3                   	ret    

008002e8 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8002e8:	55                   	push   %ebp
  8002e9:	89 e5                	mov    %esp,%ebp
  8002eb:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8002ee:	8d 45 10             	lea    0x10(%ebp),%eax
  8002f1:	83 c0 04             	add    $0x4,%eax
  8002f4:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8002f7:	a1 18 b1 81 00       	mov    0x81b118,%eax
  8002fc:	85 c0                	test   %eax,%eax
  8002fe:	74 16                	je     800316 <_panic+0x2e>
		cprintf("%s: ", argv0);
  800300:	a1 18 b1 81 00       	mov    0x81b118,%eax
  800305:	83 ec 08             	sub    $0x8,%esp
  800308:	50                   	push   %eax
  800309:	68 c0 1e 80 00       	push   $0x801ec0
  80030e:	e8 a3 02 00 00       	call   8005b6 <cprintf>
  800313:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  800316:	a1 04 30 80 00       	mov    0x803004,%eax
  80031b:	83 ec 0c             	sub    $0xc,%esp
  80031e:	ff 75 0c             	pushl  0xc(%ebp)
  800321:	ff 75 08             	pushl  0x8(%ebp)
  800324:	50                   	push   %eax
  800325:	68 c8 1e 80 00       	push   $0x801ec8
  80032a:	6a 74                	push   $0x74
  80032c:	e8 b2 02 00 00       	call   8005e3 <cprintf_colored>
  800331:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  800334:	8b 45 10             	mov    0x10(%ebp),%eax
  800337:	83 ec 08             	sub    $0x8,%esp
  80033a:	ff 75 f4             	pushl  -0xc(%ebp)
  80033d:	50                   	push   %eax
  80033e:	e8 04 02 00 00       	call   800547 <vcprintf>
  800343:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800346:	83 ec 08             	sub    $0x8,%esp
  800349:	6a 00                	push   $0x0
  80034b:	68 f0 1e 80 00       	push   $0x801ef0
  800350:	e8 f2 01 00 00       	call   800547 <vcprintf>
  800355:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800358:	e8 7d ff ff ff       	call   8002da <exit>

	// should not return here
	while (1) ;
  80035d:	eb fe                	jmp    80035d <_panic+0x75>

0080035f <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  80035f:	55                   	push   %ebp
  800360:	89 e5                	mov    %esp,%ebp
  800362:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800365:	a1 20 30 80 00       	mov    0x803020,%eax
  80036a:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800370:	8b 45 0c             	mov    0xc(%ebp),%eax
  800373:	39 c2                	cmp    %eax,%edx
  800375:	74 14                	je     80038b <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800377:	83 ec 04             	sub    $0x4,%esp
  80037a:	68 f4 1e 80 00       	push   $0x801ef4
  80037f:	6a 26                	push   $0x26
  800381:	68 40 1f 80 00       	push   $0x801f40
  800386:	e8 5d ff ff ff       	call   8002e8 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  80038b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800392:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800399:	e9 c5 00 00 00       	jmp    800463 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  80039e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003a1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8003ab:	01 d0                	add    %edx,%eax
  8003ad:	8b 00                	mov    (%eax),%eax
  8003af:	85 c0                	test   %eax,%eax
  8003b1:	75 08                	jne    8003bb <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  8003b3:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8003b6:	e9 a5 00 00 00       	jmp    800460 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  8003bb:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8003c2:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8003c9:	eb 69                	jmp    800434 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8003cb:	a1 20 30 80 00       	mov    0x803020,%eax
  8003d0:	8b 88 a4 05 00 00    	mov    0x5a4(%eax),%ecx
  8003d6:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8003d9:	89 d0                	mov    %edx,%eax
  8003db:	01 c0                	add    %eax,%eax
  8003dd:	01 d0                	add    %edx,%eax
  8003df:	c1 e0 03             	shl    $0x3,%eax
  8003e2:	01 c8                	add    %ecx,%eax
  8003e4:	8a 40 04             	mov    0x4(%eax),%al
  8003e7:	84 c0                	test   %al,%al
  8003e9:	75 46                	jne    800431 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8003eb:	a1 20 30 80 00       	mov    0x803020,%eax
  8003f0:	8b 88 a4 05 00 00    	mov    0x5a4(%eax),%ecx
  8003f6:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8003f9:	89 d0                	mov    %edx,%eax
  8003fb:	01 c0                	add    %eax,%eax
  8003fd:	01 d0                	add    %edx,%eax
  8003ff:	c1 e0 03             	shl    $0x3,%eax
  800402:	01 c8                	add    %ecx,%eax
  800404:	8b 00                	mov    (%eax),%eax
  800406:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800409:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80040c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800411:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800413:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800416:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80041d:	8b 45 08             	mov    0x8(%ebp),%eax
  800420:	01 c8                	add    %ecx,%eax
  800422:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800424:	39 c2                	cmp    %eax,%edx
  800426:	75 09                	jne    800431 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  800428:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  80042f:	eb 15                	jmp    800446 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800431:	ff 45 e8             	incl   -0x18(%ebp)
  800434:	a1 20 30 80 00       	mov    0x803020,%eax
  800439:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  80043f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800442:	39 c2                	cmp    %eax,%edx
  800444:	77 85                	ja     8003cb <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800446:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80044a:	75 14                	jne    800460 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  80044c:	83 ec 04             	sub    $0x4,%esp
  80044f:	68 4c 1f 80 00       	push   $0x801f4c
  800454:	6a 3a                	push   $0x3a
  800456:	68 40 1f 80 00       	push   $0x801f40
  80045b:	e8 88 fe ff ff       	call   8002e8 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800460:	ff 45 f0             	incl   -0x10(%ebp)
  800463:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800466:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800469:	0f 8c 2f ff ff ff    	jl     80039e <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  80046f:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800476:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80047d:	eb 26                	jmp    8004a5 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  80047f:	a1 20 30 80 00       	mov    0x803020,%eax
  800484:	8b 88 a4 05 00 00    	mov    0x5a4(%eax),%ecx
  80048a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80048d:	89 d0                	mov    %edx,%eax
  80048f:	01 c0                	add    %eax,%eax
  800491:	01 d0                	add    %edx,%eax
  800493:	c1 e0 03             	shl    $0x3,%eax
  800496:	01 c8                	add    %ecx,%eax
  800498:	8a 40 04             	mov    0x4(%eax),%al
  80049b:	3c 01                	cmp    $0x1,%al
  80049d:	75 03                	jne    8004a2 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  80049f:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8004a2:	ff 45 e0             	incl   -0x20(%ebp)
  8004a5:	a1 20 30 80 00       	mov    0x803020,%eax
  8004aa:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8004b0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8004b3:	39 c2                	cmp    %eax,%edx
  8004b5:	77 c8                	ja     80047f <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8004b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8004ba:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8004bd:	74 14                	je     8004d3 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  8004bf:	83 ec 04             	sub    $0x4,%esp
  8004c2:	68 a0 1f 80 00       	push   $0x801fa0
  8004c7:	6a 44                	push   $0x44
  8004c9:	68 40 1f 80 00       	push   $0x801f40
  8004ce:	e8 15 fe ff ff       	call   8002e8 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8004d3:	90                   	nop
  8004d4:	c9                   	leave  
  8004d5:	c3                   	ret    

008004d6 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  8004d6:	55                   	push   %ebp
  8004d7:	89 e5                	mov    %esp,%ebp
  8004d9:	53                   	push   %ebx
  8004da:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  8004dd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004e0:	8b 00                	mov    (%eax),%eax
  8004e2:	8d 48 01             	lea    0x1(%eax),%ecx
  8004e5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004e8:	89 0a                	mov    %ecx,(%edx)
  8004ea:	8b 55 08             	mov    0x8(%ebp),%edx
  8004ed:	88 d1                	mov    %dl,%cl
  8004ef:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004f2:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8004f6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004f9:	8b 00                	mov    (%eax),%eax
  8004fb:	3d ff 00 00 00       	cmp    $0xff,%eax
  800500:	75 30                	jne    800532 <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  800502:	8b 15 1c b1 81 00    	mov    0x81b11c,%edx
  800508:	a0 44 30 80 00       	mov    0x803044,%al
  80050d:	0f b6 c0             	movzbl %al,%eax
  800510:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800513:	8b 09                	mov    (%ecx),%ecx
  800515:	89 cb                	mov    %ecx,%ebx
  800517:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80051a:	83 c1 08             	add    $0x8,%ecx
  80051d:	52                   	push   %edx
  80051e:	50                   	push   %eax
  80051f:	53                   	push   %ebx
  800520:	51                   	push   %ecx
  800521:	e8 a0 0f 00 00       	call   8014c6 <sys_cputs>
  800526:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800529:	8b 45 0c             	mov    0xc(%ebp),%eax
  80052c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800532:	8b 45 0c             	mov    0xc(%ebp),%eax
  800535:	8b 40 04             	mov    0x4(%eax),%eax
  800538:	8d 50 01             	lea    0x1(%eax),%edx
  80053b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80053e:	89 50 04             	mov    %edx,0x4(%eax)
}
  800541:	90                   	nop
  800542:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800545:	c9                   	leave  
  800546:	c3                   	ret    

00800547 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800547:	55                   	push   %ebp
  800548:	89 e5                	mov    %esp,%ebp
  80054a:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800550:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800557:	00 00 00 
	b.cnt = 0;
  80055a:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800561:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800564:	ff 75 0c             	pushl  0xc(%ebp)
  800567:	ff 75 08             	pushl  0x8(%ebp)
  80056a:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800570:	50                   	push   %eax
  800571:	68 d6 04 80 00       	push   $0x8004d6
  800576:	e8 5a 02 00 00       	call   8007d5 <vprintfmt>
  80057b:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  80057e:	8b 15 1c b1 81 00    	mov    0x81b11c,%edx
  800584:	a0 44 30 80 00       	mov    0x803044,%al
  800589:	0f b6 c0             	movzbl %al,%eax
  80058c:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  800592:	52                   	push   %edx
  800593:	50                   	push   %eax
  800594:	51                   	push   %ecx
  800595:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80059b:	83 c0 08             	add    $0x8,%eax
  80059e:	50                   	push   %eax
  80059f:	e8 22 0f 00 00       	call   8014c6 <sys_cputs>
  8005a4:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8005a7:	c6 05 44 30 80 00 00 	movb   $0x0,0x803044
	return b.cnt;
  8005ae:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8005b4:	c9                   	leave  
  8005b5:	c3                   	ret    

008005b6 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  8005b6:	55                   	push   %ebp
  8005b7:	89 e5                	mov    %esp,%ebp
  8005b9:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8005bc:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
	va_start(ap, fmt);
  8005c3:	8d 45 0c             	lea    0xc(%ebp),%eax
  8005c6:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8005c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8005cc:	83 ec 08             	sub    $0x8,%esp
  8005cf:	ff 75 f4             	pushl  -0xc(%ebp)
  8005d2:	50                   	push   %eax
  8005d3:	e8 6f ff ff ff       	call   800547 <vcprintf>
  8005d8:	83 c4 10             	add    $0x10,%esp
  8005db:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8005de:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8005e1:	c9                   	leave  
  8005e2:	c3                   	ret    

008005e3 <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  8005e3:	55                   	push   %ebp
  8005e4:	89 e5                	mov    %esp,%ebp
  8005e6:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8005e9:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
	curTextClr = (textClr << 8) ; //set text color by the given value
  8005f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8005f3:	c1 e0 08             	shl    $0x8,%eax
  8005f6:	a3 1c b1 81 00       	mov    %eax,0x81b11c
	va_start(ap, fmt);
  8005fb:	8d 45 0c             	lea    0xc(%ebp),%eax
  8005fe:	83 c0 04             	add    $0x4,%eax
  800601:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800604:	8b 45 0c             	mov    0xc(%ebp),%eax
  800607:	83 ec 08             	sub    $0x8,%esp
  80060a:	ff 75 f4             	pushl  -0xc(%ebp)
  80060d:	50                   	push   %eax
  80060e:	e8 34 ff ff ff       	call   800547 <vcprintf>
  800613:	83 c4 10             	add    $0x10,%esp
  800616:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  800619:	c7 05 1c b1 81 00 00 	movl   $0x700,0x81b11c
  800620:	07 00 00 

	return cnt;
  800623:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800626:	c9                   	leave  
  800627:	c3                   	ret    

00800628 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  800628:	55                   	push   %ebp
  800629:	89 e5                	mov    %esp,%ebp
  80062b:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  80062e:	e8 d7 0e 00 00       	call   80150a <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  800633:	8d 45 0c             	lea    0xc(%ebp),%eax
  800636:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  800639:	8b 45 08             	mov    0x8(%ebp),%eax
  80063c:	83 ec 08             	sub    $0x8,%esp
  80063f:	ff 75 f4             	pushl  -0xc(%ebp)
  800642:	50                   	push   %eax
  800643:	e8 ff fe ff ff       	call   800547 <vcprintf>
  800648:	83 c4 10             	add    $0x10,%esp
  80064b:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  80064e:	e8 d1 0e 00 00       	call   801524 <sys_unlock_cons>
	return cnt;
  800653:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800656:	c9                   	leave  
  800657:	c3                   	ret    

00800658 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800658:	55                   	push   %ebp
  800659:	89 e5                	mov    %esp,%ebp
  80065b:	53                   	push   %ebx
  80065c:	83 ec 14             	sub    $0x14,%esp
  80065f:	8b 45 10             	mov    0x10(%ebp),%eax
  800662:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800665:	8b 45 14             	mov    0x14(%ebp),%eax
  800668:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80066b:	8b 45 18             	mov    0x18(%ebp),%eax
  80066e:	ba 00 00 00 00       	mov    $0x0,%edx
  800673:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800676:	77 55                	ja     8006cd <printnum+0x75>
  800678:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80067b:	72 05                	jb     800682 <printnum+0x2a>
  80067d:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800680:	77 4b                	ja     8006cd <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800682:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800685:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800688:	8b 45 18             	mov    0x18(%ebp),%eax
  80068b:	ba 00 00 00 00       	mov    $0x0,%edx
  800690:	52                   	push   %edx
  800691:	50                   	push   %eax
  800692:	ff 75 f4             	pushl  -0xc(%ebp)
  800695:	ff 75 f0             	pushl  -0x10(%ebp)
  800698:	e8 1f 14 00 00       	call   801abc <__udivdi3>
  80069d:	83 c4 10             	add    $0x10,%esp
  8006a0:	83 ec 04             	sub    $0x4,%esp
  8006a3:	ff 75 20             	pushl  0x20(%ebp)
  8006a6:	53                   	push   %ebx
  8006a7:	ff 75 18             	pushl  0x18(%ebp)
  8006aa:	52                   	push   %edx
  8006ab:	50                   	push   %eax
  8006ac:	ff 75 0c             	pushl  0xc(%ebp)
  8006af:	ff 75 08             	pushl  0x8(%ebp)
  8006b2:	e8 a1 ff ff ff       	call   800658 <printnum>
  8006b7:	83 c4 20             	add    $0x20,%esp
  8006ba:	eb 1a                	jmp    8006d6 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8006bc:	83 ec 08             	sub    $0x8,%esp
  8006bf:	ff 75 0c             	pushl  0xc(%ebp)
  8006c2:	ff 75 20             	pushl  0x20(%ebp)
  8006c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8006c8:	ff d0                	call   *%eax
  8006ca:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8006cd:	ff 4d 1c             	decl   0x1c(%ebp)
  8006d0:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  8006d4:	7f e6                	jg     8006bc <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8006d6:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8006d9:	bb 00 00 00 00       	mov    $0x0,%ebx
  8006de:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8006e1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8006e4:	53                   	push   %ebx
  8006e5:	51                   	push   %ecx
  8006e6:	52                   	push   %edx
  8006e7:	50                   	push   %eax
  8006e8:	e8 df 14 00 00       	call   801bcc <__umoddi3>
  8006ed:	83 c4 10             	add    $0x10,%esp
  8006f0:	05 14 22 80 00       	add    $0x802214,%eax
  8006f5:	8a 00                	mov    (%eax),%al
  8006f7:	0f be c0             	movsbl %al,%eax
  8006fa:	83 ec 08             	sub    $0x8,%esp
  8006fd:	ff 75 0c             	pushl  0xc(%ebp)
  800700:	50                   	push   %eax
  800701:	8b 45 08             	mov    0x8(%ebp),%eax
  800704:	ff d0                	call   *%eax
  800706:	83 c4 10             	add    $0x10,%esp
}
  800709:	90                   	nop
  80070a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80070d:	c9                   	leave  
  80070e:	c3                   	ret    

0080070f <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80070f:	55                   	push   %ebp
  800710:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800712:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800716:	7e 1c                	jle    800734 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800718:	8b 45 08             	mov    0x8(%ebp),%eax
  80071b:	8b 00                	mov    (%eax),%eax
  80071d:	8d 50 08             	lea    0x8(%eax),%edx
  800720:	8b 45 08             	mov    0x8(%ebp),%eax
  800723:	89 10                	mov    %edx,(%eax)
  800725:	8b 45 08             	mov    0x8(%ebp),%eax
  800728:	8b 00                	mov    (%eax),%eax
  80072a:	83 e8 08             	sub    $0x8,%eax
  80072d:	8b 50 04             	mov    0x4(%eax),%edx
  800730:	8b 00                	mov    (%eax),%eax
  800732:	eb 40                	jmp    800774 <getuint+0x65>
	else if (lflag)
  800734:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800738:	74 1e                	je     800758 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  80073a:	8b 45 08             	mov    0x8(%ebp),%eax
  80073d:	8b 00                	mov    (%eax),%eax
  80073f:	8d 50 04             	lea    0x4(%eax),%edx
  800742:	8b 45 08             	mov    0x8(%ebp),%eax
  800745:	89 10                	mov    %edx,(%eax)
  800747:	8b 45 08             	mov    0x8(%ebp),%eax
  80074a:	8b 00                	mov    (%eax),%eax
  80074c:	83 e8 04             	sub    $0x4,%eax
  80074f:	8b 00                	mov    (%eax),%eax
  800751:	ba 00 00 00 00       	mov    $0x0,%edx
  800756:	eb 1c                	jmp    800774 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
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
}
  800774:	5d                   	pop    %ebp
  800775:	c3                   	ret    

00800776 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800776:	55                   	push   %ebp
  800777:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800779:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80077d:	7e 1c                	jle    80079b <getint+0x25>
		return va_arg(*ap, long long);
  80077f:	8b 45 08             	mov    0x8(%ebp),%eax
  800782:	8b 00                	mov    (%eax),%eax
  800784:	8d 50 08             	lea    0x8(%eax),%edx
  800787:	8b 45 08             	mov    0x8(%ebp),%eax
  80078a:	89 10                	mov    %edx,(%eax)
  80078c:	8b 45 08             	mov    0x8(%ebp),%eax
  80078f:	8b 00                	mov    (%eax),%eax
  800791:	83 e8 08             	sub    $0x8,%eax
  800794:	8b 50 04             	mov    0x4(%eax),%edx
  800797:	8b 00                	mov    (%eax),%eax
  800799:	eb 38                	jmp    8007d3 <getint+0x5d>
	else if (lflag)
  80079b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80079f:	74 1a                	je     8007bb <getint+0x45>
		return va_arg(*ap, long);
  8007a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8007a4:	8b 00                	mov    (%eax),%eax
  8007a6:	8d 50 04             	lea    0x4(%eax),%edx
  8007a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8007ac:	89 10                	mov    %edx,(%eax)
  8007ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8007b1:	8b 00                	mov    (%eax),%eax
  8007b3:	83 e8 04             	sub    $0x4,%eax
  8007b6:	8b 00                	mov    (%eax),%eax
  8007b8:	99                   	cltd   
  8007b9:	eb 18                	jmp    8007d3 <getint+0x5d>
	else
		return va_arg(*ap, int);
  8007bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8007be:	8b 00                	mov    (%eax),%eax
  8007c0:	8d 50 04             	lea    0x4(%eax),%edx
  8007c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8007c6:	89 10                	mov    %edx,(%eax)
  8007c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8007cb:	8b 00                	mov    (%eax),%eax
  8007cd:	83 e8 04             	sub    $0x4,%eax
  8007d0:	8b 00                	mov    (%eax),%eax
  8007d2:	99                   	cltd   
}
  8007d3:	5d                   	pop    %ebp
  8007d4:	c3                   	ret    

008007d5 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8007d5:	55                   	push   %ebp
  8007d6:	89 e5                	mov    %esp,%ebp
  8007d8:	56                   	push   %esi
  8007d9:	53                   	push   %ebx
  8007da:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8007dd:	eb 17                	jmp    8007f6 <vprintfmt+0x21>
			if (ch == '\0')
  8007df:	85 db                	test   %ebx,%ebx
  8007e1:	0f 84 c1 03 00 00    	je     800ba8 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  8007e7:	83 ec 08             	sub    $0x8,%esp
  8007ea:	ff 75 0c             	pushl  0xc(%ebp)
  8007ed:	53                   	push   %ebx
  8007ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8007f1:	ff d0                	call   *%eax
  8007f3:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8007f6:	8b 45 10             	mov    0x10(%ebp),%eax
  8007f9:	8d 50 01             	lea    0x1(%eax),%edx
  8007fc:	89 55 10             	mov    %edx,0x10(%ebp)
  8007ff:	8a 00                	mov    (%eax),%al
  800801:	0f b6 d8             	movzbl %al,%ebx
  800804:	83 fb 25             	cmp    $0x25,%ebx
  800807:	75 d6                	jne    8007df <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800809:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  80080d:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800814:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80081b:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800822:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800829:	8b 45 10             	mov    0x10(%ebp),%eax
  80082c:	8d 50 01             	lea    0x1(%eax),%edx
  80082f:	89 55 10             	mov    %edx,0x10(%ebp)
  800832:	8a 00                	mov    (%eax),%al
  800834:	0f b6 d8             	movzbl %al,%ebx
  800837:	8d 43 dd             	lea    -0x23(%ebx),%eax
  80083a:	83 f8 5b             	cmp    $0x5b,%eax
  80083d:	0f 87 3d 03 00 00    	ja     800b80 <vprintfmt+0x3ab>
  800843:	8b 04 85 38 22 80 00 	mov    0x802238(,%eax,4),%eax
  80084a:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  80084c:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800850:	eb d7                	jmp    800829 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800852:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800856:	eb d1                	jmp    800829 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800858:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  80085f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800862:	89 d0                	mov    %edx,%eax
  800864:	c1 e0 02             	shl    $0x2,%eax
  800867:	01 d0                	add    %edx,%eax
  800869:	01 c0                	add    %eax,%eax
  80086b:	01 d8                	add    %ebx,%eax
  80086d:	83 e8 30             	sub    $0x30,%eax
  800870:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800873:	8b 45 10             	mov    0x10(%ebp),%eax
  800876:	8a 00                	mov    (%eax),%al
  800878:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  80087b:	83 fb 2f             	cmp    $0x2f,%ebx
  80087e:	7e 3e                	jle    8008be <vprintfmt+0xe9>
  800880:	83 fb 39             	cmp    $0x39,%ebx
  800883:	7f 39                	jg     8008be <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800885:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800888:	eb d5                	jmp    80085f <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  80088a:	8b 45 14             	mov    0x14(%ebp),%eax
  80088d:	83 c0 04             	add    $0x4,%eax
  800890:	89 45 14             	mov    %eax,0x14(%ebp)
  800893:	8b 45 14             	mov    0x14(%ebp),%eax
  800896:	83 e8 04             	sub    $0x4,%eax
  800899:	8b 00                	mov    (%eax),%eax
  80089b:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  80089e:	eb 1f                	jmp    8008bf <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8008a0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008a4:	79 83                	jns    800829 <vprintfmt+0x54>
				width = 0;
  8008a6:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8008ad:	e9 77 ff ff ff       	jmp    800829 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  8008b2:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  8008b9:	e9 6b ff ff ff       	jmp    800829 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  8008be:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8008bf:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008c3:	0f 89 60 ff ff ff    	jns    800829 <vprintfmt+0x54>
				width = precision, precision = -1;
  8008c9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8008cc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8008cf:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  8008d6:	e9 4e ff ff ff       	jmp    800829 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8008db:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  8008de:	e9 46 ff ff ff       	jmp    800829 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8008e3:	8b 45 14             	mov    0x14(%ebp),%eax
  8008e6:	83 c0 04             	add    $0x4,%eax
  8008e9:	89 45 14             	mov    %eax,0x14(%ebp)
  8008ec:	8b 45 14             	mov    0x14(%ebp),%eax
  8008ef:	83 e8 04             	sub    $0x4,%eax
  8008f2:	8b 00                	mov    (%eax),%eax
  8008f4:	83 ec 08             	sub    $0x8,%esp
  8008f7:	ff 75 0c             	pushl  0xc(%ebp)
  8008fa:	50                   	push   %eax
  8008fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8008fe:	ff d0                	call   *%eax
  800900:	83 c4 10             	add    $0x10,%esp
			break;
  800903:	e9 9b 02 00 00       	jmp    800ba3 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800908:	8b 45 14             	mov    0x14(%ebp),%eax
  80090b:	83 c0 04             	add    $0x4,%eax
  80090e:	89 45 14             	mov    %eax,0x14(%ebp)
  800911:	8b 45 14             	mov    0x14(%ebp),%eax
  800914:	83 e8 04             	sub    $0x4,%eax
  800917:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800919:	85 db                	test   %ebx,%ebx
  80091b:	79 02                	jns    80091f <vprintfmt+0x14a>
				err = -err;
  80091d:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  80091f:	83 fb 64             	cmp    $0x64,%ebx
  800922:	7f 0b                	jg     80092f <vprintfmt+0x15a>
  800924:	8b 34 9d 80 20 80 00 	mov    0x802080(,%ebx,4),%esi
  80092b:	85 f6                	test   %esi,%esi
  80092d:	75 19                	jne    800948 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  80092f:	53                   	push   %ebx
  800930:	68 25 22 80 00       	push   $0x802225
  800935:	ff 75 0c             	pushl  0xc(%ebp)
  800938:	ff 75 08             	pushl  0x8(%ebp)
  80093b:	e8 70 02 00 00       	call   800bb0 <printfmt>
  800940:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800943:	e9 5b 02 00 00       	jmp    800ba3 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800948:	56                   	push   %esi
  800949:	68 2e 22 80 00       	push   $0x80222e
  80094e:	ff 75 0c             	pushl  0xc(%ebp)
  800951:	ff 75 08             	pushl  0x8(%ebp)
  800954:	e8 57 02 00 00       	call   800bb0 <printfmt>
  800959:	83 c4 10             	add    $0x10,%esp
			break;
  80095c:	e9 42 02 00 00       	jmp    800ba3 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800961:	8b 45 14             	mov    0x14(%ebp),%eax
  800964:	83 c0 04             	add    $0x4,%eax
  800967:	89 45 14             	mov    %eax,0x14(%ebp)
  80096a:	8b 45 14             	mov    0x14(%ebp),%eax
  80096d:	83 e8 04             	sub    $0x4,%eax
  800970:	8b 30                	mov    (%eax),%esi
  800972:	85 f6                	test   %esi,%esi
  800974:	75 05                	jne    80097b <vprintfmt+0x1a6>
				p = "(null)";
  800976:	be 31 22 80 00       	mov    $0x802231,%esi
			if (width > 0 && padc != '-')
  80097b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80097f:	7e 6d                	jle    8009ee <vprintfmt+0x219>
  800981:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800985:	74 67                	je     8009ee <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800987:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80098a:	83 ec 08             	sub    $0x8,%esp
  80098d:	50                   	push   %eax
  80098e:	56                   	push   %esi
  80098f:	e8 1e 03 00 00       	call   800cb2 <strnlen>
  800994:	83 c4 10             	add    $0x10,%esp
  800997:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  80099a:	eb 16                	jmp    8009b2 <vprintfmt+0x1dd>
					putch(padc, putdat);
  80099c:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  8009a0:	83 ec 08             	sub    $0x8,%esp
  8009a3:	ff 75 0c             	pushl  0xc(%ebp)
  8009a6:	50                   	push   %eax
  8009a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8009aa:	ff d0                	call   *%eax
  8009ac:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8009af:	ff 4d e4             	decl   -0x1c(%ebp)
  8009b2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8009b6:	7f e4                	jg     80099c <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8009b8:	eb 34                	jmp    8009ee <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  8009ba:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8009be:	74 1c                	je     8009dc <vprintfmt+0x207>
  8009c0:	83 fb 1f             	cmp    $0x1f,%ebx
  8009c3:	7e 05                	jle    8009ca <vprintfmt+0x1f5>
  8009c5:	83 fb 7e             	cmp    $0x7e,%ebx
  8009c8:	7e 12                	jle    8009dc <vprintfmt+0x207>
					putch('?', putdat);
  8009ca:	83 ec 08             	sub    $0x8,%esp
  8009cd:	ff 75 0c             	pushl  0xc(%ebp)
  8009d0:	6a 3f                	push   $0x3f
  8009d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8009d5:	ff d0                	call   *%eax
  8009d7:	83 c4 10             	add    $0x10,%esp
  8009da:	eb 0f                	jmp    8009eb <vprintfmt+0x216>
				else
					putch(ch, putdat);
  8009dc:	83 ec 08             	sub    $0x8,%esp
  8009df:	ff 75 0c             	pushl  0xc(%ebp)
  8009e2:	53                   	push   %ebx
  8009e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8009e6:	ff d0                	call   *%eax
  8009e8:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8009eb:	ff 4d e4             	decl   -0x1c(%ebp)
  8009ee:	89 f0                	mov    %esi,%eax
  8009f0:	8d 70 01             	lea    0x1(%eax),%esi
  8009f3:	8a 00                	mov    (%eax),%al
  8009f5:	0f be d8             	movsbl %al,%ebx
  8009f8:	85 db                	test   %ebx,%ebx
  8009fa:	74 24                	je     800a20 <vprintfmt+0x24b>
  8009fc:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800a00:	78 b8                	js     8009ba <vprintfmt+0x1e5>
  800a02:	ff 4d e0             	decl   -0x20(%ebp)
  800a05:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800a09:	79 af                	jns    8009ba <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800a0b:	eb 13                	jmp    800a20 <vprintfmt+0x24b>
				putch(' ', putdat);
  800a0d:	83 ec 08             	sub    $0x8,%esp
  800a10:	ff 75 0c             	pushl  0xc(%ebp)
  800a13:	6a 20                	push   $0x20
  800a15:	8b 45 08             	mov    0x8(%ebp),%eax
  800a18:	ff d0                	call   *%eax
  800a1a:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800a1d:	ff 4d e4             	decl   -0x1c(%ebp)
  800a20:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a24:	7f e7                	jg     800a0d <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800a26:	e9 78 01 00 00       	jmp    800ba3 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800a2b:	83 ec 08             	sub    $0x8,%esp
  800a2e:	ff 75 e8             	pushl  -0x18(%ebp)
  800a31:	8d 45 14             	lea    0x14(%ebp),%eax
  800a34:	50                   	push   %eax
  800a35:	e8 3c fd ff ff       	call   800776 <getint>
  800a3a:	83 c4 10             	add    $0x10,%esp
  800a3d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a40:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800a43:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a46:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a49:	85 d2                	test   %edx,%edx
  800a4b:	79 23                	jns    800a70 <vprintfmt+0x29b>
				putch('-', putdat);
  800a4d:	83 ec 08             	sub    $0x8,%esp
  800a50:	ff 75 0c             	pushl  0xc(%ebp)
  800a53:	6a 2d                	push   $0x2d
  800a55:	8b 45 08             	mov    0x8(%ebp),%eax
  800a58:	ff d0                	call   *%eax
  800a5a:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800a5d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a60:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a63:	f7 d8                	neg    %eax
  800a65:	83 d2 00             	adc    $0x0,%edx
  800a68:	f7 da                	neg    %edx
  800a6a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a6d:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800a70:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800a77:	e9 bc 00 00 00       	jmp    800b38 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800a7c:	83 ec 08             	sub    $0x8,%esp
  800a7f:	ff 75 e8             	pushl  -0x18(%ebp)
  800a82:	8d 45 14             	lea    0x14(%ebp),%eax
  800a85:	50                   	push   %eax
  800a86:	e8 84 fc ff ff       	call   80070f <getuint>
  800a8b:	83 c4 10             	add    $0x10,%esp
  800a8e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a91:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800a94:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800a9b:	e9 98 00 00 00       	jmp    800b38 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800aa0:	83 ec 08             	sub    $0x8,%esp
  800aa3:	ff 75 0c             	pushl  0xc(%ebp)
  800aa6:	6a 58                	push   $0x58
  800aa8:	8b 45 08             	mov    0x8(%ebp),%eax
  800aab:	ff d0                	call   *%eax
  800aad:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800ab0:	83 ec 08             	sub    $0x8,%esp
  800ab3:	ff 75 0c             	pushl  0xc(%ebp)
  800ab6:	6a 58                	push   $0x58
  800ab8:	8b 45 08             	mov    0x8(%ebp),%eax
  800abb:	ff d0                	call   *%eax
  800abd:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800ac0:	83 ec 08             	sub    $0x8,%esp
  800ac3:	ff 75 0c             	pushl  0xc(%ebp)
  800ac6:	6a 58                	push   $0x58
  800ac8:	8b 45 08             	mov    0x8(%ebp),%eax
  800acb:	ff d0                	call   *%eax
  800acd:	83 c4 10             	add    $0x10,%esp
			break;
  800ad0:	e9 ce 00 00 00       	jmp    800ba3 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800ad5:	83 ec 08             	sub    $0x8,%esp
  800ad8:	ff 75 0c             	pushl  0xc(%ebp)
  800adb:	6a 30                	push   $0x30
  800add:	8b 45 08             	mov    0x8(%ebp),%eax
  800ae0:	ff d0                	call   *%eax
  800ae2:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800ae5:	83 ec 08             	sub    $0x8,%esp
  800ae8:	ff 75 0c             	pushl  0xc(%ebp)
  800aeb:	6a 78                	push   $0x78
  800aed:	8b 45 08             	mov    0x8(%ebp),%eax
  800af0:	ff d0                	call   *%eax
  800af2:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800af5:	8b 45 14             	mov    0x14(%ebp),%eax
  800af8:	83 c0 04             	add    $0x4,%eax
  800afb:	89 45 14             	mov    %eax,0x14(%ebp)
  800afe:	8b 45 14             	mov    0x14(%ebp),%eax
  800b01:	83 e8 04             	sub    $0x4,%eax
  800b04:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800b06:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b09:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800b10:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800b17:	eb 1f                	jmp    800b38 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800b19:	83 ec 08             	sub    $0x8,%esp
  800b1c:	ff 75 e8             	pushl  -0x18(%ebp)
  800b1f:	8d 45 14             	lea    0x14(%ebp),%eax
  800b22:	50                   	push   %eax
  800b23:	e8 e7 fb ff ff       	call   80070f <getuint>
  800b28:	83 c4 10             	add    $0x10,%esp
  800b2b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b2e:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800b31:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800b38:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800b3c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800b3f:	83 ec 04             	sub    $0x4,%esp
  800b42:	52                   	push   %edx
  800b43:	ff 75 e4             	pushl  -0x1c(%ebp)
  800b46:	50                   	push   %eax
  800b47:	ff 75 f4             	pushl  -0xc(%ebp)
  800b4a:	ff 75 f0             	pushl  -0x10(%ebp)
  800b4d:	ff 75 0c             	pushl  0xc(%ebp)
  800b50:	ff 75 08             	pushl  0x8(%ebp)
  800b53:	e8 00 fb ff ff       	call   800658 <printnum>
  800b58:	83 c4 20             	add    $0x20,%esp
			break;
  800b5b:	eb 46                	jmp    800ba3 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800b5d:	83 ec 08             	sub    $0x8,%esp
  800b60:	ff 75 0c             	pushl  0xc(%ebp)
  800b63:	53                   	push   %ebx
  800b64:	8b 45 08             	mov    0x8(%ebp),%eax
  800b67:	ff d0                	call   *%eax
  800b69:	83 c4 10             	add    $0x10,%esp
			break;
  800b6c:	eb 35                	jmp    800ba3 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800b6e:	c6 05 44 30 80 00 00 	movb   $0x0,0x803044
			break;
  800b75:	eb 2c                	jmp    800ba3 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800b77:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
			break;
  800b7e:	eb 23                	jmp    800ba3 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800b80:	83 ec 08             	sub    $0x8,%esp
  800b83:	ff 75 0c             	pushl  0xc(%ebp)
  800b86:	6a 25                	push   $0x25
  800b88:	8b 45 08             	mov    0x8(%ebp),%eax
  800b8b:	ff d0                	call   *%eax
  800b8d:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800b90:	ff 4d 10             	decl   0x10(%ebp)
  800b93:	eb 03                	jmp    800b98 <vprintfmt+0x3c3>
  800b95:	ff 4d 10             	decl   0x10(%ebp)
  800b98:	8b 45 10             	mov    0x10(%ebp),%eax
  800b9b:	48                   	dec    %eax
  800b9c:	8a 00                	mov    (%eax),%al
  800b9e:	3c 25                	cmp    $0x25,%al
  800ba0:	75 f3                	jne    800b95 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800ba2:	90                   	nop
		}
	}
  800ba3:	e9 35 fc ff ff       	jmp    8007dd <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800ba8:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800ba9:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800bac:	5b                   	pop    %ebx
  800bad:	5e                   	pop    %esi
  800bae:	5d                   	pop    %ebp
  800baf:	c3                   	ret    

00800bb0 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800bb0:	55                   	push   %ebp
  800bb1:	89 e5                	mov    %esp,%ebp
  800bb3:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800bb6:	8d 45 10             	lea    0x10(%ebp),%eax
  800bb9:	83 c0 04             	add    $0x4,%eax
  800bbc:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800bbf:	8b 45 10             	mov    0x10(%ebp),%eax
  800bc2:	ff 75 f4             	pushl  -0xc(%ebp)
  800bc5:	50                   	push   %eax
  800bc6:	ff 75 0c             	pushl  0xc(%ebp)
  800bc9:	ff 75 08             	pushl  0x8(%ebp)
  800bcc:	e8 04 fc ff ff       	call   8007d5 <vprintfmt>
  800bd1:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800bd4:	90                   	nop
  800bd5:	c9                   	leave  
  800bd6:	c3                   	ret    

00800bd7 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800bd7:	55                   	push   %ebp
  800bd8:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800bda:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bdd:	8b 40 08             	mov    0x8(%eax),%eax
  800be0:	8d 50 01             	lea    0x1(%eax),%edx
  800be3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800be6:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800be9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bec:	8b 10                	mov    (%eax),%edx
  800bee:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bf1:	8b 40 04             	mov    0x4(%eax),%eax
  800bf4:	39 c2                	cmp    %eax,%edx
  800bf6:	73 12                	jae    800c0a <sprintputch+0x33>
		*b->buf++ = ch;
  800bf8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bfb:	8b 00                	mov    (%eax),%eax
  800bfd:	8d 48 01             	lea    0x1(%eax),%ecx
  800c00:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c03:	89 0a                	mov    %ecx,(%edx)
  800c05:	8b 55 08             	mov    0x8(%ebp),%edx
  800c08:	88 10                	mov    %dl,(%eax)
}
  800c0a:	90                   	nop
  800c0b:	5d                   	pop    %ebp
  800c0c:	c3                   	ret    

00800c0d <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800c0d:	55                   	push   %ebp
  800c0e:	89 e5                	mov    %esp,%ebp
  800c10:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800c13:	8b 45 08             	mov    0x8(%ebp),%eax
  800c16:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800c19:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c1c:	8d 50 ff             	lea    -0x1(%eax),%edx
  800c1f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c22:	01 d0                	add    %edx,%eax
  800c24:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c27:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800c2e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800c32:	74 06                	je     800c3a <vsnprintf+0x2d>
  800c34:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c38:	7f 07                	jg     800c41 <vsnprintf+0x34>
		return -E_INVAL;
  800c3a:	b8 03 00 00 00       	mov    $0x3,%eax
  800c3f:	eb 20                	jmp    800c61 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800c41:	ff 75 14             	pushl  0x14(%ebp)
  800c44:	ff 75 10             	pushl  0x10(%ebp)
  800c47:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800c4a:	50                   	push   %eax
  800c4b:	68 d7 0b 80 00       	push   $0x800bd7
  800c50:	e8 80 fb ff ff       	call   8007d5 <vprintfmt>
  800c55:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800c58:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800c5b:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800c5e:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800c61:	c9                   	leave  
  800c62:	c3                   	ret    

00800c63 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800c63:	55                   	push   %ebp
  800c64:	89 e5                	mov    %esp,%ebp
  800c66:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800c69:	8d 45 10             	lea    0x10(%ebp),%eax
  800c6c:	83 c0 04             	add    $0x4,%eax
  800c6f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800c72:	8b 45 10             	mov    0x10(%ebp),%eax
  800c75:	ff 75 f4             	pushl  -0xc(%ebp)
  800c78:	50                   	push   %eax
  800c79:	ff 75 0c             	pushl  0xc(%ebp)
  800c7c:	ff 75 08             	pushl  0x8(%ebp)
  800c7f:	e8 89 ff ff ff       	call   800c0d <vsnprintf>
  800c84:	83 c4 10             	add    $0x10,%esp
  800c87:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800c8a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800c8d:	c9                   	leave  
  800c8e:	c3                   	ret    

00800c8f <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800c8f:	55                   	push   %ebp
  800c90:	89 e5                	mov    %esp,%ebp
  800c92:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800c95:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c9c:	eb 06                	jmp    800ca4 <strlen+0x15>
		n++;
  800c9e:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800ca1:	ff 45 08             	incl   0x8(%ebp)
  800ca4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ca7:	8a 00                	mov    (%eax),%al
  800ca9:	84 c0                	test   %al,%al
  800cab:	75 f1                	jne    800c9e <strlen+0xf>
		n++;
	return n;
  800cad:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800cb0:	c9                   	leave  
  800cb1:	c3                   	ret    

00800cb2 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800cb2:	55                   	push   %ebp
  800cb3:	89 e5                	mov    %esp,%ebp
  800cb5:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800cb8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800cbf:	eb 09                	jmp    800cca <strnlen+0x18>
		n++;
  800cc1:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800cc4:	ff 45 08             	incl   0x8(%ebp)
  800cc7:	ff 4d 0c             	decl   0xc(%ebp)
  800cca:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800cce:	74 09                	je     800cd9 <strnlen+0x27>
  800cd0:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd3:	8a 00                	mov    (%eax),%al
  800cd5:	84 c0                	test   %al,%al
  800cd7:	75 e8                	jne    800cc1 <strnlen+0xf>
		n++;
	return n;
  800cd9:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800cdc:	c9                   	leave  
  800cdd:	c3                   	ret    

00800cde <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800cde:	55                   	push   %ebp
  800cdf:	89 e5                	mov    %esp,%ebp
  800ce1:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800ce4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800cea:	90                   	nop
  800ceb:	8b 45 08             	mov    0x8(%ebp),%eax
  800cee:	8d 50 01             	lea    0x1(%eax),%edx
  800cf1:	89 55 08             	mov    %edx,0x8(%ebp)
  800cf4:	8b 55 0c             	mov    0xc(%ebp),%edx
  800cf7:	8d 4a 01             	lea    0x1(%edx),%ecx
  800cfa:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800cfd:	8a 12                	mov    (%edx),%dl
  800cff:	88 10                	mov    %dl,(%eax)
  800d01:	8a 00                	mov    (%eax),%al
  800d03:	84 c0                	test   %al,%al
  800d05:	75 e4                	jne    800ceb <strcpy+0xd>
		/* do nothing */;
	return ret;
  800d07:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800d0a:	c9                   	leave  
  800d0b:	c3                   	ret    

00800d0c <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800d0c:	55                   	push   %ebp
  800d0d:	89 e5                	mov    %esp,%ebp
  800d0f:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800d12:	8b 45 08             	mov    0x8(%ebp),%eax
  800d15:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800d18:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800d1f:	eb 1f                	jmp    800d40 <strncpy+0x34>
		*dst++ = *src;
  800d21:	8b 45 08             	mov    0x8(%ebp),%eax
  800d24:	8d 50 01             	lea    0x1(%eax),%edx
  800d27:	89 55 08             	mov    %edx,0x8(%ebp)
  800d2a:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d2d:	8a 12                	mov    (%edx),%dl
  800d2f:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800d31:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d34:	8a 00                	mov    (%eax),%al
  800d36:	84 c0                	test   %al,%al
  800d38:	74 03                	je     800d3d <strncpy+0x31>
			src++;
  800d3a:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800d3d:	ff 45 fc             	incl   -0x4(%ebp)
  800d40:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d43:	3b 45 10             	cmp    0x10(%ebp),%eax
  800d46:	72 d9                	jb     800d21 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800d48:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800d4b:	c9                   	leave  
  800d4c:	c3                   	ret    

00800d4d <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800d4d:	55                   	push   %ebp
  800d4e:	89 e5                	mov    %esp,%ebp
  800d50:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800d53:	8b 45 08             	mov    0x8(%ebp),%eax
  800d56:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800d59:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d5d:	74 30                	je     800d8f <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800d5f:	eb 16                	jmp    800d77 <strlcpy+0x2a>
			*dst++ = *src++;
  800d61:	8b 45 08             	mov    0x8(%ebp),%eax
  800d64:	8d 50 01             	lea    0x1(%eax),%edx
  800d67:	89 55 08             	mov    %edx,0x8(%ebp)
  800d6a:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d6d:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d70:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800d73:	8a 12                	mov    (%edx),%dl
  800d75:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800d77:	ff 4d 10             	decl   0x10(%ebp)
  800d7a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d7e:	74 09                	je     800d89 <strlcpy+0x3c>
  800d80:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d83:	8a 00                	mov    (%eax),%al
  800d85:	84 c0                	test   %al,%al
  800d87:	75 d8                	jne    800d61 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800d89:	8b 45 08             	mov    0x8(%ebp),%eax
  800d8c:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800d8f:	8b 55 08             	mov    0x8(%ebp),%edx
  800d92:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d95:	29 c2                	sub    %eax,%edx
  800d97:	89 d0                	mov    %edx,%eax
}
  800d99:	c9                   	leave  
  800d9a:	c3                   	ret    

00800d9b <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800d9b:	55                   	push   %ebp
  800d9c:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800d9e:	eb 06                	jmp    800da6 <strcmp+0xb>
		p++, q++;
  800da0:	ff 45 08             	incl   0x8(%ebp)
  800da3:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800da6:	8b 45 08             	mov    0x8(%ebp),%eax
  800da9:	8a 00                	mov    (%eax),%al
  800dab:	84 c0                	test   %al,%al
  800dad:	74 0e                	je     800dbd <strcmp+0x22>
  800daf:	8b 45 08             	mov    0x8(%ebp),%eax
  800db2:	8a 10                	mov    (%eax),%dl
  800db4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800db7:	8a 00                	mov    (%eax),%al
  800db9:	38 c2                	cmp    %al,%dl
  800dbb:	74 e3                	je     800da0 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800dbd:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc0:	8a 00                	mov    (%eax),%al
  800dc2:	0f b6 d0             	movzbl %al,%edx
  800dc5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dc8:	8a 00                	mov    (%eax),%al
  800dca:	0f b6 c0             	movzbl %al,%eax
  800dcd:	29 c2                	sub    %eax,%edx
  800dcf:	89 d0                	mov    %edx,%eax
}
  800dd1:	5d                   	pop    %ebp
  800dd2:	c3                   	ret    

00800dd3 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800dd3:	55                   	push   %ebp
  800dd4:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800dd6:	eb 09                	jmp    800de1 <strncmp+0xe>
		n--, p++, q++;
  800dd8:	ff 4d 10             	decl   0x10(%ebp)
  800ddb:	ff 45 08             	incl   0x8(%ebp)
  800dde:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800de1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800de5:	74 17                	je     800dfe <strncmp+0x2b>
  800de7:	8b 45 08             	mov    0x8(%ebp),%eax
  800dea:	8a 00                	mov    (%eax),%al
  800dec:	84 c0                	test   %al,%al
  800dee:	74 0e                	je     800dfe <strncmp+0x2b>
  800df0:	8b 45 08             	mov    0x8(%ebp),%eax
  800df3:	8a 10                	mov    (%eax),%dl
  800df5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800df8:	8a 00                	mov    (%eax),%al
  800dfa:	38 c2                	cmp    %al,%dl
  800dfc:	74 da                	je     800dd8 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800dfe:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e02:	75 07                	jne    800e0b <strncmp+0x38>
		return 0;
  800e04:	b8 00 00 00 00       	mov    $0x0,%eax
  800e09:	eb 14                	jmp    800e1f <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800e0b:	8b 45 08             	mov    0x8(%ebp),%eax
  800e0e:	8a 00                	mov    (%eax),%al
  800e10:	0f b6 d0             	movzbl %al,%edx
  800e13:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e16:	8a 00                	mov    (%eax),%al
  800e18:	0f b6 c0             	movzbl %al,%eax
  800e1b:	29 c2                	sub    %eax,%edx
  800e1d:	89 d0                	mov    %edx,%eax
}
  800e1f:	5d                   	pop    %ebp
  800e20:	c3                   	ret    

00800e21 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800e21:	55                   	push   %ebp
  800e22:	89 e5                	mov    %esp,%ebp
  800e24:	83 ec 04             	sub    $0x4,%esp
  800e27:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e2a:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800e2d:	eb 12                	jmp    800e41 <strchr+0x20>
		if (*s == c)
  800e2f:	8b 45 08             	mov    0x8(%ebp),%eax
  800e32:	8a 00                	mov    (%eax),%al
  800e34:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800e37:	75 05                	jne    800e3e <strchr+0x1d>
			return (char *) s;
  800e39:	8b 45 08             	mov    0x8(%ebp),%eax
  800e3c:	eb 11                	jmp    800e4f <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800e3e:	ff 45 08             	incl   0x8(%ebp)
  800e41:	8b 45 08             	mov    0x8(%ebp),%eax
  800e44:	8a 00                	mov    (%eax),%al
  800e46:	84 c0                	test   %al,%al
  800e48:	75 e5                	jne    800e2f <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800e4a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e4f:	c9                   	leave  
  800e50:	c3                   	ret    

00800e51 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800e51:	55                   	push   %ebp
  800e52:	89 e5                	mov    %esp,%ebp
  800e54:	83 ec 04             	sub    $0x4,%esp
  800e57:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e5a:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800e5d:	eb 0d                	jmp    800e6c <strfind+0x1b>
		if (*s == c)
  800e5f:	8b 45 08             	mov    0x8(%ebp),%eax
  800e62:	8a 00                	mov    (%eax),%al
  800e64:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800e67:	74 0e                	je     800e77 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800e69:	ff 45 08             	incl   0x8(%ebp)
  800e6c:	8b 45 08             	mov    0x8(%ebp),%eax
  800e6f:	8a 00                	mov    (%eax),%al
  800e71:	84 c0                	test   %al,%al
  800e73:	75 ea                	jne    800e5f <strfind+0xe>
  800e75:	eb 01                	jmp    800e78 <strfind+0x27>
		if (*s == c)
			break;
  800e77:	90                   	nop
	return (char *) s;
  800e78:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e7b:	c9                   	leave  
  800e7c:	c3                   	ret    

00800e7d <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  800e7d:	55                   	push   %ebp
  800e7e:	89 e5                	mov    %esp,%ebp
  800e80:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  800e83:	8b 45 08             	mov    0x8(%ebp),%eax
  800e86:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  800e89:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800e8d:	76 63                	jbe    800ef2 <memset+0x75>
		uint64 data_block = c;
  800e8f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e92:	99                   	cltd   
  800e93:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e96:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  800e99:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e9c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e9f:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  800ea3:	c1 e0 08             	shl    $0x8,%eax
  800ea6:	09 45 f0             	or     %eax,-0x10(%ebp)
  800ea9:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  800eac:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800eaf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800eb2:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  800eb6:	c1 e0 10             	shl    $0x10,%eax
  800eb9:	09 45 f0             	or     %eax,-0x10(%ebp)
  800ebc:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  800ebf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ec2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ec5:	89 c2                	mov    %eax,%edx
  800ec7:	b8 00 00 00 00       	mov    $0x0,%eax
  800ecc:	09 45 f0             	or     %eax,-0x10(%ebp)
  800ecf:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  800ed2:	eb 18                	jmp    800eec <memset+0x6f>
			*p64++ = data_block, n -= 8;
  800ed4:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  800ed7:	8d 41 08             	lea    0x8(%ecx),%eax
  800eda:	89 45 fc             	mov    %eax,-0x4(%ebp)
  800edd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ee0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ee3:	89 01                	mov    %eax,(%ecx)
  800ee5:	89 51 04             	mov    %edx,0x4(%ecx)
  800ee8:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  800eec:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800ef0:	77 e2                	ja     800ed4 <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  800ef2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ef6:	74 23                	je     800f1b <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  800ef8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800efb:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  800efe:	eb 0e                	jmp    800f0e <memset+0x91>
			*p8++ = (uint8)c;
  800f00:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f03:	8d 50 01             	lea    0x1(%eax),%edx
  800f06:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800f09:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f0c:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  800f0e:	8b 45 10             	mov    0x10(%ebp),%eax
  800f11:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f14:	89 55 10             	mov    %edx,0x10(%ebp)
  800f17:	85 c0                	test   %eax,%eax
  800f19:	75 e5                	jne    800f00 <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  800f1b:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f1e:	c9                   	leave  
  800f1f:	c3                   	ret    

00800f20 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800f20:	55                   	push   %ebp
  800f21:	89 e5                	mov    %esp,%ebp
  800f23:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  800f26:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f29:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  800f2c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f2f:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  800f32:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800f36:	76 24                	jbe    800f5c <memcpy+0x3c>
		while(n >= 8){
  800f38:	eb 1c                	jmp    800f56 <memcpy+0x36>
			*d64 = *s64;
  800f3a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f3d:	8b 50 04             	mov    0x4(%eax),%edx
  800f40:	8b 00                	mov    (%eax),%eax
  800f42:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  800f45:	89 01                	mov    %eax,(%ecx)
  800f47:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  800f4a:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  800f4e:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  800f52:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  800f56:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800f5a:	77 de                	ja     800f3a <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  800f5c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f60:	74 31                	je     800f93 <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  800f62:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f65:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  800f68:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f6b:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  800f6e:	eb 16                	jmp    800f86 <memcpy+0x66>
			*d8++ = *s8++;
  800f70:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800f73:	8d 50 01             	lea    0x1(%eax),%edx
  800f76:	89 55 f0             	mov    %edx,-0x10(%ebp)
  800f79:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f7c:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f7f:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  800f82:	8a 12                	mov    (%edx),%dl
  800f84:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  800f86:	8b 45 10             	mov    0x10(%ebp),%eax
  800f89:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f8c:	89 55 10             	mov    %edx,0x10(%ebp)
  800f8f:	85 c0                	test   %eax,%eax
  800f91:	75 dd                	jne    800f70 <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  800f93:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f96:	c9                   	leave  
  800f97:	c3                   	ret    

00800f98 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800f98:	55                   	push   %ebp
  800f99:	89 e5                	mov    %esp,%ebp
  800f9b:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800f9e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fa1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800fa4:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa7:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800faa:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fad:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800fb0:	73 50                	jae    801002 <memmove+0x6a>
  800fb2:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800fb5:	8b 45 10             	mov    0x10(%ebp),%eax
  800fb8:	01 d0                	add    %edx,%eax
  800fba:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800fbd:	76 43                	jbe    801002 <memmove+0x6a>
		s += n;
  800fbf:	8b 45 10             	mov    0x10(%ebp),%eax
  800fc2:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800fc5:	8b 45 10             	mov    0x10(%ebp),%eax
  800fc8:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800fcb:	eb 10                	jmp    800fdd <memmove+0x45>
			*--d = *--s;
  800fcd:	ff 4d f8             	decl   -0x8(%ebp)
  800fd0:	ff 4d fc             	decl   -0x4(%ebp)
  800fd3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fd6:	8a 10                	mov    (%eax),%dl
  800fd8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fdb:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800fdd:	8b 45 10             	mov    0x10(%ebp),%eax
  800fe0:	8d 50 ff             	lea    -0x1(%eax),%edx
  800fe3:	89 55 10             	mov    %edx,0x10(%ebp)
  800fe6:	85 c0                	test   %eax,%eax
  800fe8:	75 e3                	jne    800fcd <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800fea:	eb 23                	jmp    80100f <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800fec:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fef:	8d 50 01             	lea    0x1(%eax),%edx
  800ff2:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800ff5:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800ff8:	8d 4a 01             	lea    0x1(%edx),%ecx
  800ffb:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800ffe:	8a 12                	mov    (%edx),%dl
  801000:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801002:	8b 45 10             	mov    0x10(%ebp),%eax
  801005:	8d 50 ff             	lea    -0x1(%eax),%edx
  801008:	89 55 10             	mov    %edx,0x10(%ebp)
  80100b:	85 c0                	test   %eax,%eax
  80100d:	75 dd                	jne    800fec <memmove+0x54>
			*d++ = *s++;

	return dst;
  80100f:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801012:	c9                   	leave  
  801013:	c3                   	ret    

00801014 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  801014:	55                   	push   %ebp
  801015:	89 e5                	mov    %esp,%ebp
  801017:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  80101a:	8b 45 08             	mov    0x8(%ebp),%eax
  80101d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  801020:	8b 45 0c             	mov    0xc(%ebp),%eax
  801023:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  801026:	eb 2a                	jmp    801052 <memcmp+0x3e>
		if (*s1 != *s2)
  801028:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80102b:	8a 10                	mov    (%eax),%dl
  80102d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801030:	8a 00                	mov    (%eax),%al
  801032:	38 c2                	cmp    %al,%dl
  801034:	74 16                	je     80104c <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801036:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801039:	8a 00                	mov    (%eax),%al
  80103b:	0f b6 d0             	movzbl %al,%edx
  80103e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801041:	8a 00                	mov    (%eax),%al
  801043:	0f b6 c0             	movzbl %al,%eax
  801046:	29 c2                	sub    %eax,%edx
  801048:	89 d0                	mov    %edx,%eax
  80104a:	eb 18                	jmp    801064 <memcmp+0x50>
		s1++, s2++;
  80104c:	ff 45 fc             	incl   -0x4(%ebp)
  80104f:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801052:	8b 45 10             	mov    0x10(%ebp),%eax
  801055:	8d 50 ff             	lea    -0x1(%eax),%edx
  801058:	89 55 10             	mov    %edx,0x10(%ebp)
  80105b:	85 c0                	test   %eax,%eax
  80105d:	75 c9                	jne    801028 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  80105f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801064:	c9                   	leave  
  801065:	c3                   	ret    

00801066 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801066:	55                   	push   %ebp
  801067:	89 e5                	mov    %esp,%ebp
  801069:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  80106c:	8b 55 08             	mov    0x8(%ebp),%edx
  80106f:	8b 45 10             	mov    0x10(%ebp),%eax
  801072:	01 d0                	add    %edx,%eax
  801074:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801077:	eb 15                	jmp    80108e <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801079:	8b 45 08             	mov    0x8(%ebp),%eax
  80107c:	8a 00                	mov    (%eax),%al
  80107e:	0f b6 d0             	movzbl %al,%edx
  801081:	8b 45 0c             	mov    0xc(%ebp),%eax
  801084:	0f b6 c0             	movzbl %al,%eax
  801087:	39 c2                	cmp    %eax,%edx
  801089:	74 0d                	je     801098 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80108b:	ff 45 08             	incl   0x8(%ebp)
  80108e:	8b 45 08             	mov    0x8(%ebp),%eax
  801091:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801094:	72 e3                	jb     801079 <memfind+0x13>
  801096:	eb 01                	jmp    801099 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801098:	90                   	nop
	return (void *) s;
  801099:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80109c:	c9                   	leave  
  80109d:	c3                   	ret    

0080109e <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80109e:	55                   	push   %ebp
  80109f:	89 e5                	mov    %esp,%ebp
  8010a1:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  8010a4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  8010ab:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8010b2:	eb 03                	jmp    8010b7 <strtol+0x19>
		s++;
  8010b4:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8010b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ba:	8a 00                	mov    (%eax),%al
  8010bc:	3c 20                	cmp    $0x20,%al
  8010be:	74 f4                	je     8010b4 <strtol+0x16>
  8010c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c3:	8a 00                	mov    (%eax),%al
  8010c5:	3c 09                	cmp    $0x9,%al
  8010c7:	74 eb                	je     8010b4 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  8010c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8010cc:	8a 00                	mov    (%eax),%al
  8010ce:	3c 2b                	cmp    $0x2b,%al
  8010d0:	75 05                	jne    8010d7 <strtol+0x39>
		s++;
  8010d2:	ff 45 08             	incl   0x8(%ebp)
  8010d5:	eb 13                	jmp    8010ea <strtol+0x4c>
	else if (*s == '-')
  8010d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8010da:	8a 00                	mov    (%eax),%al
  8010dc:	3c 2d                	cmp    $0x2d,%al
  8010de:	75 0a                	jne    8010ea <strtol+0x4c>
		s++, neg = 1;
  8010e0:	ff 45 08             	incl   0x8(%ebp)
  8010e3:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8010ea:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010ee:	74 06                	je     8010f6 <strtol+0x58>
  8010f0:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8010f4:	75 20                	jne    801116 <strtol+0x78>
  8010f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8010f9:	8a 00                	mov    (%eax),%al
  8010fb:	3c 30                	cmp    $0x30,%al
  8010fd:	75 17                	jne    801116 <strtol+0x78>
  8010ff:	8b 45 08             	mov    0x8(%ebp),%eax
  801102:	40                   	inc    %eax
  801103:	8a 00                	mov    (%eax),%al
  801105:	3c 78                	cmp    $0x78,%al
  801107:	75 0d                	jne    801116 <strtol+0x78>
		s += 2, base = 16;
  801109:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  80110d:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801114:	eb 28                	jmp    80113e <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801116:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80111a:	75 15                	jne    801131 <strtol+0x93>
  80111c:	8b 45 08             	mov    0x8(%ebp),%eax
  80111f:	8a 00                	mov    (%eax),%al
  801121:	3c 30                	cmp    $0x30,%al
  801123:	75 0c                	jne    801131 <strtol+0x93>
		s++, base = 8;
  801125:	ff 45 08             	incl   0x8(%ebp)
  801128:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  80112f:	eb 0d                	jmp    80113e <strtol+0xa0>
	else if (base == 0)
  801131:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801135:	75 07                	jne    80113e <strtol+0xa0>
		base = 10;
  801137:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  80113e:	8b 45 08             	mov    0x8(%ebp),%eax
  801141:	8a 00                	mov    (%eax),%al
  801143:	3c 2f                	cmp    $0x2f,%al
  801145:	7e 19                	jle    801160 <strtol+0xc2>
  801147:	8b 45 08             	mov    0x8(%ebp),%eax
  80114a:	8a 00                	mov    (%eax),%al
  80114c:	3c 39                	cmp    $0x39,%al
  80114e:	7f 10                	jg     801160 <strtol+0xc2>
			dig = *s - '0';
  801150:	8b 45 08             	mov    0x8(%ebp),%eax
  801153:	8a 00                	mov    (%eax),%al
  801155:	0f be c0             	movsbl %al,%eax
  801158:	83 e8 30             	sub    $0x30,%eax
  80115b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80115e:	eb 42                	jmp    8011a2 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801160:	8b 45 08             	mov    0x8(%ebp),%eax
  801163:	8a 00                	mov    (%eax),%al
  801165:	3c 60                	cmp    $0x60,%al
  801167:	7e 19                	jle    801182 <strtol+0xe4>
  801169:	8b 45 08             	mov    0x8(%ebp),%eax
  80116c:	8a 00                	mov    (%eax),%al
  80116e:	3c 7a                	cmp    $0x7a,%al
  801170:	7f 10                	jg     801182 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801172:	8b 45 08             	mov    0x8(%ebp),%eax
  801175:	8a 00                	mov    (%eax),%al
  801177:	0f be c0             	movsbl %al,%eax
  80117a:	83 e8 57             	sub    $0x57,%eax
  80117d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801180:	eb 20                	jmp    8011a2 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801182:	8b 45 08             	mov    0x8(%ebp),%eax
  801185:	8a 00                	mov    (%eax),%al
  801187:	3c 40                	cmp    $0x40,%al
  801189:	7e 39                	jle    8011c4 <strtol+0x126>
  80118b:	8b 45 08             	mov    0x8(%ebp),%eax
  80118e:	8a 00                	mov    (%eax),%al
  801190:	3c 5a                	cmp    $0x5a,%al
  801192:	7f 30                	jg     8011c4 <strtol+0x126>
			dig = *s - 'A' + 10;
  801194:	8b 45 08             	mov    0x8(%ebp),%eax
  801197:	8a 00                	mov    (%eax),%al
  801199:	0f be c0             	movsbl %al,%eax
  80119c:	83 e8 37             	sub    $0x37,%eax
  80119f:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  8011a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8011a5:	3b 45 10             	cmp    0x10(%ebp),%eax
  8011a8:	7d 19                	jge    8011c3 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  8011aa:	ff 45 08             	incl   0x8(%ebp)
  8011ad:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011b0:	0f af 45 10          	imul   0x10(%ebp),%eax
  8011b4:	89 c2                	mov    %eax,%edx
  8011b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8011b9:	01 d0                	add    %edx,%eax
  8011bb:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8011be:	e9 7b ff ff ff       	jmp    80113e <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8011c3:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8011c4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8011c8:	74 08                	je     8011d2 <strtol+0x134>
		*endptr = (char *) s;
  8011ca:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011cd:	8b 55 08             	mov    0x8(%ebp),%edx
  8011d0:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8011d2:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8011d6:	74 07                	je     8011df <strtol+0x141>
  8011d8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011db:	f7 d8                	neg    %eax
  8011dd:	eb 03                	jmp    8011e2 <strtol+0x144>
  8011df:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8011e2:	c9                   	leave  
  8011e3:	c3                   	ret    

008011e4 <ltostr>:

void
ltostr(long value, char *str)
{
  8011e4:	55                   	push   %ebp
  8011e5:	89 e5                	mov    %esp,%ebp
  8011e7:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8011ea:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8011f1:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8011f8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8011fc:	79 13                	jns    801211 <ltostr+0x2d>
	{
		neg = 1;
  8011fe:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801205:	8b 45 0c             	mov    0xc(%ebp),%eax
  801208:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  80120b:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  80120e:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801211:	8b 45 08             	mov    0x8(%ebp),%eax
  801214:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801219:	99                   	cltd   
  80121a:	f7 f9                	idiv   %ecx
  80121c:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  80121f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801222:	8d 50 01             	lea    0x1(%eax),%edx
  801225:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801228:	89 c2                	mov    %eax,%edx
  80122a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80122d:	01 d0                	add    %edx,%eax
  80122f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801232:	83 c2 30             	add    $0x30,%edx
  801235:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801237:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80123a:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80123f:	f7 e9                	imul   %ecx
  801241:	c1 fa 02             	sar    $0x2,%edx
  801244:	89 c8                	mov    %ecx,%eax
  801246:	c1 f8 1f             	sar    $0x1f,%eax
  801249:	29 c2                	sub    %eax,%edx
  80124b:	89 d0                	mov    %edx,%eax
  80124d:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  801250:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801254:	75 bb                	jne    801211 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801256:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  80125d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801260:	48                   	dec    %eax
  801261:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801264:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801268:	74 3d                	je     8012a7 <ltostr+0xc3>
		start = 1 ;
  80126a:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801271:	eb 34                	jmp    8012a7 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  801273:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801276:	8b 45 0c             	mov    0xc(%ebp),%eax
  801279:	01 d0                	add    %edx,%eax
  80127b:	8a 00                	mov    (%eax),%al
  80127d:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801280:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801283:	8b 45 0c             	mov    0xc(%ebp),%eax
  801286:	01 c2                	add    %eax,%edx
  801288:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80128b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80128e:	01 c8                	add    %ecx,%eax
  801290:	8a 00                	mov    (%eax),%al
  801292:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801294:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801297:	8b 45 0c             	mov    0xc(%ebp),%eax
  80129a:	01 c2                	add    %eax,%edx
  80129c:	8a 45 eb             	mov    -0x15(%ebp),%al
  80129f:	88 02                	mov    %al,(%edx)
		start++ ;
  8012a1:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8012a4:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8012a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8012aa:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8012ad:	7c c4                	jl     801273 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8012af:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8012b2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012b5:	01 d0                	add    %edx,%eax
  8012b7:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8012ba:	90                   	nop
  8012bb:	c9                   	leave  
  8012bc:	c3                   	ret    

008012bd <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8012bd:	55                   	push   %ebp
  8012be:	89 e5                	mov    %esp,%ebp
  8012c0:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8012c3:	ff 75 08             	pushl  0x8(%ebp)
  8012c6:	e8 c4 f9 ff ff       	call   800c8f <strlen>
  8012cb:	83 c4 04             	add    $0x4,%esp
  8012ce:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8012d1:	ff 75 0c             	pushl  0xc(%ebp)
  8012d4:	e8 b6 f9 ff ff       	call   800c8f <strlen>
  8012d9:	83 c4 04             	add    $0x4,%esp
  8012dc:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8012df:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8012e6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8012ed:	eb 17                	jmp    801306 <strcconcat+0x49>
		final[s] = str1[s] ;
  8012ef:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8012f2:	8b 45 10             	mov    0x10(%ebp),%eax
  8012f5:	01 c2                	add    %eax,%edx
  8012f7:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8012fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8012fd:	01 c8                	add    %ecx,%eax
  8012ff:	8a 00                	mov    (%eax),%al
  801301:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801303:	ff 45 fc             	incl   -0x4(%ebp)
  801306:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801309:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80130c:	7c e1                	jl     8012ef <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  80130e:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801315:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  80131c:	eb 1f                	jmp    80133d <strcconcat+0x80>
		final[s++] = str2[i] ;
  80131e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801321:	8d 50 01             	lea    0x1(%eax),%edx
  801324:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801327:	89 c2                	mov    %eax,%edx
  801329:	8b 45 10             	mov    0x10(%ebp),%eax
  80132c:	01 c2                	add    %eax,%edx
  80132e:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801331:	8b 45 0c             	mov    0xc(%ebp),%eax
  801334:	01 c8                	add    %ecx,%eax
  801336:	8a 00                	mov    (%eax),%al
  801338:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  80133a:	ff 45 f8             	incl   -0x8(%ebp)
  80133d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801340:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801343:	7c d9                	jl     80131e <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801345:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801348:	8b 45 10             	mov    0x10(%ebp),%eax
  80134b:	01 d0                	add    %edx,%eax
  80134d:	c6 00 00             	movb   $0x0,(%eax)
}
  801350:	90                   	nop
  801351:	c9                   	leave  
  801352:	c3                   	ret    

00801353 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801353:	55                   	push   %ebp
  801354:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801356:	8b 45 14             	mov    0x14(%ebp),%eax
  801359:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  80135f:	8b 45 14             	mov    0x14(%ebp),%eax
  801362:	8b 00                	mov    (%eax),%eax
  801364:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80136b:	8b 45 10             	mov    0x10(%ebp),%eax
  80136e:	01 d0                	add    %edx,%eax
  801370:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801376:	eb 0c                	jmp    801384 <strsplit+0x31>
			*string++ = 0;
  801378:	8b 45 08             	mov    0x8(%ebp),%eax
  80137b:	8d 50 01             	lea    0x1(%eax),%edx
  80137e:	89 55 08             	mov    %edx,0x8(%ebp)
  801381:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801384:	8b 45 08             	mov    0x8(%ebp),%eax
  801387:	8a 00                	mov    (%eax),%al
  801389:	84 c0                	test   %al,%al
  80138b:	74 18                	je     8013a5 <strsplit+0x52>
  80138d:	8b 45 08             	mov    0x8(%ebp),%eax
  801390:	8a 00                	mov    (%eax),%al
  801392:	0f be c0             	movsbl %al,%eax
  801395:	50                   	push   %eax
  801396:	ff 75 0c             	pushl  0xc(%ebp)
  801399:	e8 83 fa ff ff       	call   800e21 <strchr>
  80139e:	83 c4 08             	add    $0x8,%esp
  8013a1:	85 c0                	test   %eax,%eax
  8013a3:	75 d3                	jne    801378 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8013a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8013a8:	8a 00                	mov    (%eax),%al
  8013aa:	84 c0                	test   %al,%al
  8013ac:	74 5a                	je     801408 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8013ae:	8b 45 14             	mov    0x14(%ebp),%eax
  8013b1:	8b 00                	mov    (%eax),%eax
  8013b3:	83 f8 0f             	cmp    $0xf,%eax
  8013b6:	75 07                	jne    8013bf <strsplit+0x6c>
		{
			return 0;
  8013b8:	b8 00 00 00 00       	mov    $0x0,%eax
  8013bd:	eb 66                	jmp    801425 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8013bf:	8b 45 14             	mov    0x14(%ebp),%eax
  8013c2:	8b 00                	mov    (%eax),%eax
  8013c4:	8d 48 01             	lea    0x1(%eax),%ecx
  8013c7:	8b 55 14             	mov    0x14(%ebp),%edx
  8013ca:	89 0a                	mov    %ecx,(%edx)
  8013cc:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8013d3:	8b 45 10             	mov    0x10(%ebp),%eax
  8013d6:	01 c2                	add    %eax,%edx
  8013d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8013db:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8013dd:	eb 03                	jmp    8013e2 <strsplit+0x8f>
			string++;
  8013df:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8013e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8013e5:	8a 00                	mov    (%eax),%al
  8013e7:	84 c0                	test   %al,%al
  8013e9:	74 8b                	je     801376 <strsplit+0x23>
  8013eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8013ee:	8a 00                	mov    (%eax),%al
  8013f0:	0f be c0             	movsbl %al,%eax
  8013f3:	50                   	push   %eax
  8013f4:	ff 75 0c             	pushl  0xc(%ebp)
  8013f7:	e8 25 fa ff ff       	call   800e21 <strchr>
  8013fc:	83 c4 08             	add    $0x8,%esp
  8013ff:	85 c0                	test   %eax,%eax
  801401:	74 dc                	je     8013df <strsplit+0x8c>
			string++;
	}
  801403:	e9 6e ff ff ff       	jmp    801376 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801408:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801409:	8b 45 14             	mov    0x14(%ebp),%eax
  80140c:	8b 00                	mov    (%eax),%eax
  80140e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801415:	8b 45 10             	mov    0x10(%ebp),%eax
  801418:	01 d0                	add    %edx,%eax
  80141a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801420:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801425:	c9                   	leave  
  801426:	c3                   	ret    

00801427 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  801427:	55                   	push   %ebp
  801428:	89 e5                	mov    %esp,%ebp
  80142a:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  80142d:	8b 45 08             	mov    0x8(%ebp),%eax
  801430:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  801433:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80143a:	eb 4a                	jmp    801486 <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  80143c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80143f:	8b 45 08             	mov    0x8(%ebp),%eax
  801442:	01 c2                	add    %eax,%edx
  801444:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801447:	8b 45 0c             	mov    0xc(%ebp),%eax
  80144a:	01 c8                	add    %ecx,%eax
  80144c:	8a 00                	mov    (%eax),%al
  80144e:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  801450:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801453:	8b 45 0c             	mov    0xc(%ebp),%eax
  801456:	01 d0                	add    %edx,%eax
  801458:	8a 00                	mov    (%eax),%al
  80145a:	3c 40                	cmp    $0x40,%al
  80145c:	7e 25                	jle    801483 <str2lower+0x5c>
  80145e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801461:	8b 45 0c             	mov    0xc(%ebp),%eax
  801464:	01 d0                	add    %edx,%eax
  801466:	8a 00                	mov    (%eax),%al
  801468:	3c 5a                	cmp    $0x5a,%al
  80146a:	7f 17                	jg     801483 <str2lower+0x5c>
		{
			dst[i] += 32 ;
  80146c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80146f:	8b 45 08             	mov    0x8(%ebp),%eax
  801472:	01 d0                	add    %edx,%eax
  801474:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801477:	8b 55 08             	mov    0x8(%ebp),%edx
  80147a:	01 ca                	add    %ecx,%edx
  80147c:	8a 12                	mov    (%edx),%dl
  80147e:	83 c2 20             	add    $0x20,%edx
  801481:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  801483:	ff 45 fc             	incl   -0x4(%ebp)
  801486:	ff 75 0c             	pushl  0xc(%ebp)
  801489:	e8 01 f8 ff ff       	call   800c8f <strlen>
  80148e:	83 c4 04             	add    $0x4,%esp
  801491:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801494:	7f a6                	jg     80143c <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  801496:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801499:	c9                   	leave  
  80149a:	c3                   	ret    

0080149b <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  80149b:	55                   	push   %ebp
  80149c:	89 e5                	mov    %esp,%ebp
  80149e:	57                   	push   %edi
  80149f:	56                   	push   %esi
  8014a0:	53                   	push   %ebx
  8014a1:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8014a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8014a7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014aa:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8014ad:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8014b0:	8b 7d 18             	mov    0x18(%ebp),%edi
  8014b3:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8014b6:	cd 30                	int    $0x30
  8014b8:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  8014bb:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8014be:	83 c4 10             	add    $0x10,%esp
  8014c1:	5b                   	pop    %ebx
  8014c2:	5e                   	pop    %esi
  8014c3:	5f                   	pop    %edi
  8014c4:	5d                   	pop    %ebp
  8014c5:	c3                   	ret    

008014c6 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  8014c6:	55                   	push   %ebp
  8014c7:	89 e5                	mov    %esp,%ebp
  8014c9:	83 ec 04             	sub    $0x4,%esp
  8014cc:	8b 45 10             	mov    0x10(%ebp),%eax
  8014cf:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  8014d2:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8014d5:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8014d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8014dc:	6a 00                	push   $0x0
  8014de:	51                   	push   %ecx
  8014df:	52                   	push   %edx
  8014e0:	ff 75 0c             	pushl  0xc(%ebp)
  8014e3:	50                   	push   %eax
  8014e4:	6a 00                	push   $0x0
  8014e6:	e8 b0 ff ff ff       	call   80149b <syscall>
  8014eb:	83 c4 18             	add    $0x18,%esp
}
  8014ee:	90                   	nop
  8014ef:	c9                   	leave  
  8014f0:	c3                   	ret    

008014f1 <sys_cgetc>:

int
sys_cgetc(void)
{
  8014f1:	55                   	push   %ebp
  8014f2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8014f4:	6a 00                	push   $0x0
  8014f6:	6a 00                	push   $0x0
  8014f8:	6a 00                	push   $0x0
  8014fa:	6a 00                	push   $0x0
  8014fc:	6a 00                	push   $0x0
  8014fe:	6a 02                	push   $0x2
  801500:	e8 96 ff ff ff       	call   80149b <syscall>
  801505:	83 c4 18             	add    $0x18,%esp
}
  801508:	c9                   	leave  
  801509:	c3                   	ret    

0080150a <sys_lock_cons>:

void sys_lock_cons(void)
{
  80150a:	55                   	push   %ebp
  80150b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  80150d:	6a 00                	push   $0x0
  80150f:	6a 00                	push   $0x0
  801511:	6a 00                	push   $0x0
  801513:	6a 00                	push   $0x0
  801515:	6a 00                	push   $0x0
  801517:	6a 03                	push   $0x3
  801519:	e8 7d ff ff ff       	call   80149b <syscall>
  80151e:	83 c4 18             	add    $0x18,%esp
}
  801521:	90                   	nop
  801522:	c9                   	leave  
  801523:	c3                   	ret    

00801524 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  801524:	55                   	push   %ebp
  801525:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  801527:	6a 00                	push   $0x0
  801529:	6a 00                	push   $0x0
  80152b:	6a 00                	push   $0x0
  80152d:	6a 00                	push   $0x0
  80152f:	6a 00                	push   $0x0
  801531:	6a 04                	push   $0x4
  801533:	e8 63 ff ff ff       	call   80149b <syscall>
  801538:	83 c4 18             	add    $0x18,%esp
}
  80153b:	90                   	nop
  80153c:	c9                   	leave  
  80153d:	c3                   	ret    

0080153e <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  80153e:	55                   	push   %ebp
  80153f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801541:	8b 55 0c             	mov    0xc(%ebp),%edx
  801544:	8b 45 08             	mov    0x8(%ebp),%eax
  801547:	6a 00                	push   $0x0
  801549:	6a 00                	push   $0x0
  80154b:	6a 00                	push   $0x0
  80154d:	52                   	push   %edx
  80154e:	50                   	push   %eax
  80154f:	6a 08                	push   $0x8
  801551:	e8 45 ff ff ff       	call   80149b <syscall>
  801556:	83 c4 18             	add    $0x18,%esp
}
  801559:	c9                   	leave  
  80155a:	c3                   	ret    

0080155b <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  80155b:	55                   	push   %ebp
  80155c:	89 e5                	mov    %esp,%ebp
  80155e:	56                   	push   %esi
  80155f:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801560:	8b 75 18             	mov    0x18(%ebp),%esi
  801563:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801566:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801569:	8b 55 0c             	mov    0xc(%ebp),%edx
  80156c:	8b 45 08             	mov    0x8(%ebp),%eax
  80156f:	56                   	push   %esi
  801570:	53                   	push   %ebx
  801571:	51                   	push   %ecx
  801572:	52                   	push   %edx
  801573:	50                   	push   %eax
  801574:	6a 09                	push   $0x9
  801576:	e8 20 ff ff ff       	call   80149b <syscall>
  80157b:	83 c4 18             	add    $0x18,%esp
}
  80157e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801581:	5b                   	pop    %ebx
  801582:	5e                   	pop    %esi
  801583:	5d                   	pop    %ebp
  801584:	c3                   	ret    

00801585 <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  801585:	55                   	push   %ebp
  801586:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  801588:	6a 00                	push   $0x0
  80158a:	6a 00                	push   $0x0
  80158c:	6a 00                	push   $0x0
  80158e:	6a 00                	push   $0x0
  801590:	ff 75 08             	pushl  0x8(%ebp)
  801593:	6a 0a                	push   $0xa
  801595:	e8 01 ff ff ff       	call   80149b <syscall>
  80159a:	83 c4 18             	add    $0x18,%esp
}
  80159d:	c9                   	leave  
  80159e:	c3                   	ret    

0080159f <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  80159f:	55                   	push   %ebp
  8015a0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8015a2:	6a 00                	push   $0x0
  8015a4:	6a 00                	push   $0x0
  8015a6:	6a 00                	push   $0x0
  8015a8:	ff 75 0c             	pushl  0xc(%ebp)
  8015ab:	ff 75 08             	pushl  0x8(%ebp)
  8015ae:	6a 0b                	push   $0xb
  8015b0:	e8 e6 fe ff ff       	call   80149b <syscall>
  8015b5:	83 c4 18             	add    $0x18,%esp
}
  8015b8:	c9                   	leave  
  8015b9:	c3                   	ret    

008015ba <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8015ba:	55                   	push   %ebp
  8015bb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8015bd:	6a 00                	push   $0x0
  8015bf:	6a 00                	push   $0x0
  8015c1:	6a 00                	push   $0x0
  8015c3:	6a 00                	push   $0x0
  8015c5:	6a 00                	push   $0x0
  8015c7:	6a 0c                	push   $0xc
  8015c9:	e8 cd fe ff ff       	call   80149b <syscall>
  8015ce:	83 c4 18             	add    $0x18,%esp
}
  8015d1:	c9                   	leave  
  8015d2:	c3                   	ret    

008015d3 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8015d3:	55                   	push   %ebp
  8015d4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8015d6:	6a 00                	push   $0x0
  8015d8:	6a 00                	push   $0x0
  8015da:	6a 00                	push   $0x0
  8015dc:	6a 00                	push   $0x0
  8015de:	6a 00                	push   $0x0
  8015e0:	6a 0d                	push   $0xd
  8015e2:	e8 b4 fe ff ff       	call   80149b <syscall>
  8015e7:	83 c4 18             	add    $0x18,%esp
}
  8015ea:	c9                   	leave  
  8015eb:	c3                   	ret    

008015ec <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8015ec:	55                   	push   %ebp
  8015ed:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8015ef:	6a 00                	push   $0x0
  8015f1:	6a 00                	push   $0x0
  8015f3:	6a 00                	push   $0x0
  8015f5:	6a 00                	push   $0x0
  8015f7:	6a 00                	push   $0x0
  8015f9:	6a 0e                	push   $0xe
  8015fb:	e8 9b fe ff ff       	call   80149b <syscall>
  801600:	83 c4 18             	add    $0x18,%esp
}
  801603:	c9                   	leave  
  801604:	c3                   	ret    

00801605 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801605:	55                   	push   %ebp
  801606:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801608:	6a 00                	push   $0x0
  80160a:	6a 00                	push   $0x0
  80160c:	6a 00                	push   $0x0
  80160e:	6a 00                	push   $0x0
  801610:	6a 00                	push   $0x0
  801612:	6a 0f                	push   $0xf
  801614:	e8 82 fe ff ff       	call   80149b <syscall>
  801619:	83 c4 18             	add    $0x18,%esp
}
  80161c:	c9                   	leave  
  80161d:	c3                   	ret    

0080161e <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  80161e:	55                   	push   %ebp
  80161f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801621:	6a 00                	push   $0x0
  801623:	6a 00                	push   $0x0
  801625:	6a 00                	push   $0x0
  801627:	6a 00                	push   $0x0
  801629:	ff 75 08             	pushl  0x8(%ebp)
  80162c:	6a 10                	push   $0x10
  80162e:	e8 68 fe ff ff       	call   80149b <syscall>
  801633:	83 c4 18             	add    $0x18,%esp
}
  801636:	c9                   	leave  
  801637:	c3                   	ret    

00801638 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801638:	55                   	push   %ebp
  801639:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  80163b:	6a 00                	push   $0x0
  80163d:	6a 00                	push   $0x0
  80163f:	6a 00                	push   $0x0
  801641:	6a 00                	push   $0x0
  801643:	6a 00                	push   $0x0
  801645:	6a 11                	push   $0x11
  801647:	e8 4f fe ff ff       	call   80149b <syscall>
  80164c:	83 c4 18             	add    $0x18,%esp
}
  80164f:	90                   	nop
  801650:	c9                   	leave  
  801651:	c3                   	ret    

00801652 <sys_cputc>:

void
sys_cputc(const char c)
{
  801652:	55                   	push   %ebp
  801653:	89 e5                	mov    %esp,%ebp
  801655:	83 ec 04             	sub    $0x4,%esp
  801658:	8b 45 08             	mov    0x8(%ebp),%eax
  80165b:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  80165e:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801662:	6a 00                	push   $0x0
  801664:	6a 00                	push   $0x0
  801666:	6a 00                	push   $0x0
  801668:	6a 00                	push   $0x0
  80166a:	50                   	push   %eax
  80166b:	6a 01                	push   $0x1
  80166d:	e8 29 fe ff ff       	call   80149b <syscall>
  801672:	83 c4 18             	add    $0x18,%esp
}
  801675:	90                   	nop
  801676:	c9                   	leave  
  801677:	c3                   	ret    

00801678 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801678:	55                   	push   %ebp
  801679:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  80167b:	6a 00                	push   $0x0
  80167d:	6a 00                	push   $0x0
  80167f:	6a 00                	push   $0x0
  801681:	6a 00                	push   $0x0
  801683:	6a 00                	push   $0x0
  801685:	6a 14                	push   $0x14
  801687:	e8 0f fe ff ff       	call   80149b <syscall>
  80168c:	83 c4 18             	add    $0x18,%esp
}
  80168f:	90                   	nop
  801690:	c9                   	leave  
  801691:	c3                   	ret    

00801692 <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801692:	55                   	push   %ebp
  801693:	89 e5                	mov    %esp,%ebp
  801695:	83 ec 04             	sub    $0x4,%esp
  801698:	8b 45 10             	mov    0x10(%ebp),%eax
  80169b:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  80169e:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8016a1:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8016a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8016a8:	6a 00                	push   $0x0
  8016aa:	51                   	push   %ecx
  8016ab:	52                   	push   %edx
  8016ac:	ff 75 0c             	pushl  0xc(%ebp)
  8016af:	50                   	push   %eax
  8016b0:	6a 15                	push   $0x15
  8016b2:	e8 e4 fd ff ff       	call   80149b <syscall>
  8016b7:	83 c4 18             	add    $0x18,%esp
}
  8016ba:	c9                   	leave  
  8016bb:	c3                   	ret    

008016bc <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  8016bc:	55                   	push   %ebp
  8016bd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8016bf:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8016c5:	6a 00                	push   $0x0
  8016c7:	6a 00                	push   $0x0
  8016c9:	6a 00                	push   $0x0
  8016cb:	52                   	push   %edx
  8016cc:	50                   	push   %eax
  8016cd:	6a 16                	push   $0x16
  8016cf:	e8 c7 fd ff ff       	call   80149b <syscall>
  8016d4:	83 c4 18             	add    $0x18,%esp
}
  8016d7:	c9                   	leave  
  8016d8:	c3                   	ret    

008016d9 <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  8016d9:	55                   	push   %ebp
  8016da:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8016dc:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8016df:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8016e5:	6a 00                	push   $0x0
  8016e7:	6a 00                	push   $0x0
  8016e9:	51                   	push   %ecx
  8016ea:	52                   	push   %edx
  8016eb:	50                   	push   %eax
  8016ec:	6a 17                	push   $0x17
  8016ee:	e8 a8 fd ff ff       	call   80149b <syscall>
  8016f3:	83 c4 18             	add    $0x18,%esp
}
  8016f6:	c9                   	leave  
  8016f7:	c3                   	ret    

008016f8 <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  8016f8:	55                   	push   %ebp
  8016f9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8016fb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016fe:	8b 45 08             	mov    0x8(%ebp),%eax
  801701:	6a 00                	push   $0x0
  801703:	6a 00                	push   $0x0
  801705:	6a 00                	push   $0x0
  801707:	52                   	push   %edx
  801708:	50                   	push   %eax
  801709:	6a 18                	push   $0x18
  80170b:	e8 8b fd ff ff       	call   80149b <syscall>
  801710:	83 c4 18             	add    $0x18,%esp
}
  801713:	c9                   	leave  
  801714:	c3                   	ret    

00801715 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801715:	55                   	push   %ebp
  801716:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801718:	8b 45 08             	mov    0x8(%ebp),%eax
  80171b:	6a 00                	push   $0x0
  80171d:	ff 75 14             	pushl  0x14(%ebp)
  801720:	ff 75 10             	pushl  0x10(%ebp)
  801723:	ff 75 0c             	pushl  0xc(%ebp)
  801726:	50                   	push   %eax
  801727:	6a 19                	push   $0x19
  801729:	e8 6d fd ff ff       	call   80149b <syscall>
  80172e:	83 c4 18             	add    $0x18,%esp
}
  801731:	c9                   	leave  
  801732:	c3                   	ret    

00801733 <sys_run_env>:

void sys_run_env(int32 envId)
{
  801733:	55                   	push   %ebp
  801734:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801736:	8b 45 08             	mov    0x8(%ebp),%eax
  801739:	6a 00                	push   $0x0
  80173b:	6a 00                	push   $0x0
  80173d:	6a 00                	push   $0x0
  80173f:	6a 00                	push   $0x0
  801741:	50                   	push   %eax
  801742:	6a 1a                	push   $0x1a
  801744:	e8 52 fd ff ff       	call   80149b <syscall>
  801749:	83 c4 18             	add    $0x18,%esp
}
  80174c:	90                   	nop
  80174d:	c9                   	leave  
  80174e:	c3                   	ret    

0080174f <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  80174f:	55                   	push   %ebp
  801750:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801752:	8b 45 08             	mov    0x8(%ebp),%eax
  801755:	6a 00                	push   $0x0
  801757:	6a 00                	push   $0x0
  801759:	6a 00                	push   $0x0
  80175b:	6a 00                	push   $0x0
  80175d:	50                   	push   %eax
  80175e:	6a 1b                	push   $0x1b
  801760:	e8 36 fd ff ff       	call   80149b <syscall>
  801765:	83 c4 18             	add    $0x18,%esp
}
  801768:	c9                   	leave  
  801769:	c3                   	ret    

0080176a <sys_getenvid>:

int32 sys_getenvid(void)
{
  80176a:	55                   	push   %ebp
  80176b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  80176d:	6a 00                	push   $0x0
  80176f:	6a 00                	push   $0x0
  801771:	6a 00                	push   $0x0
  801773:	6a 00                	push   $0x0
  801775:	6a 00                	push   $0x0
  801777:	6a 05                	push   $0x5
  801779:	e8 1d fd ff ff       	call   80149b <syscall>
  80177e:	83 c4 18             	add    $0x18,%esp
}
  801781:	c9                   	leave  
  801782:	c3                   	ret    

00801783 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801783:	55                   	push   %ebp
  801784:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801786:	6a 00                	push   $0x0
  801788:	6a 00                	push   $0x0
  80178a:	6a 00                	push   $0x0
  80178c:	6a 00                	push   $0x0
  80178e:	6a 00                	push   $0x0
  801790:	6a 06                	push   $0x6
  801792:	e8 04 fd ff ff       	call   80149b <syscall>
  801797:	83 c4 18             	add    $0x18,%esp
}
  80179a:	c9                   	leave  
  80179b:	c3                   	ret    

0080179c <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  80179c:	55                   	push   %ebp
  80179d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  80179f:	6a 00                	push   $0x0
  8017a1:	6a 00                	push   $0x0
  8017a3:	6a 00                	push   $0x0
  8017a5:	6a 00                	push   $0x0
  8017a7:	6a 00                	push   $0x0
  8017a9:	6a 07                	push   $0x7
  8017ab:	e8 eb fc ff ff       	call   80149b <syscall>
  8017b0:	83 c4 18             	add    $0x18,%esp
}
  8017b3:	c9                   	leave  
  8017b4:	c3                   	ret    

008017b5 <sys_exit_env>:


void sys_exit_env(void)
{
  8017b5:	55                   	push   %ebp
  8017b6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  8017b8:	6a 00                	push   $0x0
  8017ba:	6a 00                	push   $0x0
  8017bc:	6a 00                	push   $0x0
  8017be:	6a 00                	push   $0x0
  8017c0:	6a 00                	push   $0x0
  8017c2:	6a 1c                	push   $0x1c
  8017c4:	e8 d2 fc ff ff       	call   80149b <syscall>
  8017c9:	83 c4 18             	add    $0x18,%esp
}
  8017cc:	90                   	nop
  8017cd:	c9                   	leave  
  8017ce:	c3                   	ret    

008017cf <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  8017cf:	55                   	push   %ebp
  8017d0:	89 e5                	mov    %esp,%ebp
  8017d2:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8017d5:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8017d8:	8d 50 04             	lea    0x4(%eax),%edx
  8017db:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8017de:	6a 00                	push   $0x0
  8017e0:	6a 00                	push   $0x0
  8017e2:	6a 00                	push   $0x0
  8017e4:	52                   	push   %edx
  8017e5:	50                   	push   %eax
  8017e6:	6a 1d                	push   $0x1d
  8017e8:	e8 ae fc ff ff       	call   80149b <syscall>
  8017ed:	83 c4 18             	add    $0x18,%esp
	return result;
  8017f0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8017f3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8017f6:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8017f9:	89 01                	mov    %eax,(%ecx)
  8017fb:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8017fe:	8b 45 08             	mov    0x8(%ebp),%eax
  801801:	c9                   	leave  
  801802:	c2 04 00             	ret    $0x4

00801805 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801805:	55                   	push   %ebp
  801806:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801808:	6a 00                	push   $0x0
  80180a:	6a 00                	push   $0x0
  80180c:	ff 75 10             	pushl  0x10(%ebp)
  80180f:	ff 75 0c             	pushl  0xc(%ebp)
  801812:	ff 75 08             	pushl  0x8(%ebp)
  801815:	6a 13                	push   $0x13
  801817:	e8 7f fc ff ff       	call   80149b <syscall>
  80181c:	83 c4 18             	add    $0x18,%esp
	return ;
  80181f:	90                   	nop
}
  801820:	c9                   	leave  
  801821:	c3                   	ret    

00801822 <sys_rcr2>:
uint32 sys_rcr2()
{
  801822:	55                   	push   %ebp
  801823:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801825:	6a 00                	push   $0x0
  801827:	6a 00                	push   $0x0
  801829:	6a 00                	push   $0x0
  80182b:	6a 00                	push   $0x0
  80182d:	6a 00                	push   $0x0
  80182f:	6a 1e                	push   $0x1e
  801831:	e8 65 fc ff ff       	call   80149b <syscall>
  801836:	83 c4 18             	add    $0x18,%esp
}
  801839:	c9                   	leave  
  80183a:	c3                   	ret    

0080183b <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  80183b:	55                   	push   %ebp
  80183c:	89 e5                	mov    %esp,%ebp
  80183e:	83 ec 04             	sub    $0x4,%esp
  801841:	8b 45 08             	mov    0x8(%ebp),%eax
  801844:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801847:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  80184b:	6a 00                	push   $0x0
  80184d:	6a 00                	push   $0x0
  80184f:	6a 00                	push   $0x0
  801851:	6a 00                	push   $0x0
  801853:	50                   	push   %eax
  801854:	6a 1f                	push   $0x1f
  801856:	e8 40 fc ff ff       	call   80149b <syscall>
  80185b:	83 c4 18             	add    $0x18,%esp
	return ;
  80185e:	90                   	nop
}
  80185f:	c9                   	leave  
  801860:	c3                   	ret    

00801861 <rsttst>:
void rsttst()
{
  801861:	55                   	push   %ebp
  801862:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801864:	6a 00                	push   $0x0
  801866:	6a 00                	push   $0x0
  801868:	6a 00                	push   $0x0
  80186a:	6a 00                	push   $0x0
  80186c:	6a 00                	push   $0x0
  80186e:	6a 21                	push   $0x21
  801870:	e8 26 fc ff ff       	call   80149b <syscall>
  801875:	83 c4 18             	add    $0x18,%esp
	return ;
  801878:	90                   	nop
}
  801879:	c9                   	leave  
  80187a:	c3                   	ret    

0080187b <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  80187b:	55                   	push   %ebp
  80187c:	89 e5                	mov    %esp,%ebp
  80187e:	83 ec 04             	sub    $0x4,%esp
  801881:	8b 45 14             	mov    0x14(%ebp),%eax
  801884:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801887:	8b 55 18             	mov    0x18(%ebp),%edx
  80188a:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80188e:	52                   	push   %edx
  80188f:	50                   	push   %eax
  801890:	ff 75 10             	pushl  0x10(%ebp)
  801893:	ff 75 0c             	pushl  0xc(%ebp)
  801896:	ff 75 08             	pushl  0x8(%ebp)
  801899:	6a 20                	push   $0x20
  80189b:	e8 fb fb ff ff       	call   80149b <syscall>
  8018a0:	83 c4 18             	add    $0x18,%esp
	return ;
  8018a3:	90                   	nop
}
  8018a4:	c9                   	leave  
  8018a5:	c3                   	ret    

008018a6 <chktst>:
void chktst(uint32 n)
{
  8018a6:	55                   	push   %ebp
  8018a7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8018a9:	6a 00                	push   $0x0
  8018ab:	6a 00                	push   $0x0
  8018ad:	6a 00                	push   $0x0
  8018af:	6a 00                	push   $0x0
  8018b1:	ff 75 08             	pushl  0x8(%ebp)
  8018b4:	6a 22                	push   $0x22
  8018b6:	e8 e0 fb ff ff       	call   80149b <syscall>
  8018bb:	83 c4 18             	add    $0x18,%esp
	return ;
  8018be:	90                   	nop
}
  8018bf:	c9                   	leave  
  8018c0:	c3                   	ret    

008018c1 <inctst>:

void inctst()
{
  8018c1:	55                   	push   %ebp
  8018c2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8018c4:	6a 00                	push   $0x0
  8018c6:	6a 00                	push   $0x0
  8018c8:	6a 00                	push   $0x0
  8018ca:	6a 00                	push   $0x0
  8018cc:	6a 00                	push   $0x0
  8018ce:	6a 23                	push   $0x23
  8018d0:	e8 c6 fb ff ff       	call   80149b <syscall>
  8018d5:	83 c4 18             	add    $0x18,%esp
	return ;
  8018d8:	90                   	nop
}
  8018d9:	c9                   	leave  
  8018da:	c3                   	ret    

008018db <gettst>:
uint32 gettst()
{
  8018db:	55                   	push   %ebp
  8018dc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8018de:	6a 00                	push   $0x0
  8018e0:	6a 00                	push   $0x0
  8018e2:	6a 00                	push   $0x0
  8018e4:	6a 00                	push   $0x0
  8018e6:	6a 00                	push   $0x0
  8018e8:	6a 24                	push   $0x24
  8018ea:	e8 ac fb ff ff       	call   80149b <syscall>
  8018ef:	83 c4 18             	add    $0x18,%esp
}
  8018f2:	c9                   	leave  
  8018f3:	c3                   	ret    

008018f4 <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  8018f4:	55                   	push   %ebp
  8018f5:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8018f7:	6a 00                	push   $0x0
  8018f9:	6a 00                	push   $0x0
  8018fb:	6a 00                	push   $0x0
  8018fd:	6a 00                	push   $0x0
  8018ff:	6a 00                	push   $0x0
  801901:	6a 25                	push   $0x25
  801903:	e8 93 fb ff ff       	call   80149b <syscall>
  801908:	83 c4 18             	add    $0x18,%esp
  80190b:	a3 60 b0 81 00       	mov    %eax,0x81b060
	return uheapPlaceStrategy ;
  801910:	a1 60 b0 81 00       	mov    0x81b060,%eax
}
  801915:	c9                   	leave  
  801916:	c3                   	ret    

00801917 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801917:	55                   	push   %ebp
  801918:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  80191a:	8b 45 08             	mov    0x8(%ebp),%eax
  80191d:	a3 60 b0 81 00       	mov    %eax,0x81b060
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801922:	6a 00                	push   $0x0
  801924:	6a 00                	push   $0x0
  801926:	6a 00                	push   $0x0
  801928:	6a 00                	push   $0x0
  80192a:	ff 75 08             	pushl  0x8(%ebp)
  80192d:	6a 26                	push   $0x26
  80192f:	e8 67 fb ff ff       	call   80149b <syscall>
  801934:	83 c4 18             	add    $0x18,%esp
	return ;
  801937:	90                   	nop
}
  801938:	c9                   	leave  
  801939:	c3                   	ret    

0080193a <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  80193a:	55                   	push   %ebp
  80193b:	89 e5                	mov    %esp,%ebp
  80193d:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  80193e:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801941:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801944:	8b 55 0c             	mov    0xc(%ebp),%edx
  801947:	8b 45 08             	mov    0x8(%ebp),%eax
  80194a:	6a 00                	push   $0x0
  80194c:	53                   	push   %ebx
  80194d:	51                   	push   %ecx
  80194e:	52                   	push   %edx
  80194f:	50                   	push   %eax
  801950:	6a 27                	push   $0x27
  801952:	e8 44 fb ff ff       	call   80149b <syscall>
  801957:	83 c4 18             	add    $0x18,%esp
}
  80195a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80195d:	c9                   	leave  
  80195e:	c3                   	ret    

0080195f <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  80195f:	55                   	push   %ebp
  801960:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801962:	8b 55 0c             	mov    0xc(%ebp),%edx
  801965:	8b 45 08             	mov    0x8(%ebp),%eax
  801968:	6a 00                	push   $0x0
  80196a:	6a 00                	push   $0x0
  80196c:	6a 00                	push   $0x0
  80196e:	52                   	push   %edx
  80196f:	50                   	push   %eax
  801970:	6a 28                	push   $0x28
  801972:	e8 24 fb ff ff       	call   80149b <syscall>
  801977:	83 c4 18             	add    $0x18,%esp
}
  80197a:	c9                   	leave  
  80197b:	c3                   	ret    

0080197c <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  80197c:	55                   	push   %ebp
  80197d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  80197f:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801982:	8b 55 0c             	mov    0xc(%ebp),%edx
  801985:	8b 45 08             	mov    0x8(%ebp),%eax
  801988:	6a 00                	push   $0x0
  80198a:	51                   	push   %ecx
  80198b:	ff 75 10             	pushl  0x10(%ebp)
  80198e:	52                   	push   %edx
  80198f:	50                   	push   %eax
  801990:	6a 29                	push   $0x29
  801992:	e8 04 fb ff ff       	call   80149b <syscall>
  801997:	83 c4 18             	add    $0x18,%esp
}
  80199a:	c9                   	leave  
  80199b:	c3                   	ret    

0080199c <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  80199c:	55                   	push   %ebp
  80199d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  80199f:	6a 00                	push   $0x0
  8019a1:	6a 00                	push   $0x0
  8019a3:	ff 75 10             	pushl  0x10(%ebp)
  8019a6:	ff 75 0c             	pushl  0xc(%ebp)
  8019a9:	ff 75 08             	pushl  0x8(%ebp)
  8019ac:	6a 12                	push   $0x12
  8019ae:	e8 e8 fa ff ff       	call   80149b <syscall>
  8019b3:	83 c4 18             	add    $0x18,%esp
	return ;
  8019b6:	90                   	nop
}
  8019b7:	c9                   	leave  
  8019b8:	c3                   	ret    

008019b9 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  8019b9:	55                   	push   %ebp
  8019ba:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  8019bc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8019c2:	6a 00                	push   $0x0
  8019c4:	6a 00                	push   $0x0
  8019c6:	6a 00                	push   $0x0
  8019c8:	52                   	push   %edx
  8019c9:	50                   	push   %eax
  8019ca:	6a 2a                	push   $0x2a
  8019cc:	e8 ca fa ff ff       	call   80149b <syscall>
  8019d1:	83 c4 18             	add    $0x18,%esp
	return;
  8019d4:	90                   	nop
}
  8019d5:	c9                   	leave  
  8019d6:	c3                   	ret    

008019d7 <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  8019d7:	55                   	push   %ebp
  8019d8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  8019da:	6a 00                	push   $0x0
  8019dc:	6a 00                	push   $0x0
  8019de:	6a 00                	push   $0x0
  8019e0:	6a 00                	push   $0x0
  8019e2:	6a 00                	push   $0x0
  8019e4:	6a 2b                	push   $0x2b
  8019e6:	e8 b0 fa ff ff       	call   80149b <syscall>
  8019eb:	83 c4 18             	add    $0x18,%esp
}
  8019ee:	c9                   	leave  
  8019ef:	c3                   	ret    

008019f0 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8019f0:	55                   	push   %ebp
  8019f1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  8019f3:	6a 00                	push   $0x0
  8019f5:	6a 00                	push   $0x0
  8019f7:	6a 00                	push   $0x0
  8019f9:	ff 75 0c             	pushl  0xc(%ebp)
  8019fc:	ff 75 08             	pushl  0x8(%ebp)
  8019ff:	6a 2d                	push   $0x2d
  801a01:	e8 95 fa ff ff       	call   80149b <syscall>
  801a06:	83 c4 18             	add    $0x18,%esp
	return;
  801a09:	90                   	nop
}
  801a0a:	c9                   	leave  
  801a0b:	c3                   	ret    

00801a0c <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801a0c:	55                   	push   %ebp
  801a0d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801a0f:	6a 00                	push   $0x0
  801a11:	6a 00                	push   $0x0
  801a13:	6a 00                	push   $0x0
  801a15:	ff 75 0c             	pushl  0xc(%ebp)
  801a18:	ff 75 08             	pushl  0x8(%ebp)
  801a1b:	6a 2c                	push   $0x2c
  801a1d:	e8 79 fa ff ff       	call   80149b <syscall>
  801a22:	83 c4 18             	add    $0x18,%esp
	return ;
  801a25:	90                   	nop
}
  801a26:	c9                   	leave  
  801a27:	c3                   	ret    

00801a28 <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  801a28:	55                   	push   %ebp
  801a29:	89 e5                	mov    %esp,%ebp
	//TODO: [PROJECT'25.IM#4] CPU SCHEDULING - #1 System Calls - Add suitable code here
	//Your code is here
	//Comment the following line
	//panic("sys_env_set_priority() is not implemented yet...!!");
	syscall(SYS_env_set_priority, envID, priority, 0, 0, 0);
  801a2b:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a2e:	8b 45 08             	mov    0x8(%ebp),%eax
  801a31:	6a 00                	push   $0x0
  801a33:	6a 00                	push   $0x0
  801a35:	6a 00                	push   $0x0
  801a37:	52                   	push   %edx
  801a38:	50                   	push   %eax
  801a39:	6a 2e                	push   $0x2e
  801a3b:	e8 5b fa ff ff       	call   80149b <syscall>
  801a40:	83 c4 18             	add    $0x18,%esp
	    return;
  801a43:	90                   	nop
}
  801a44:	c9                   	leave  
  801a45:	c3                   	ret    

00801a46 <create_semaphore>:
// User-level Semaphore

#include "inc/lib.h"

struct semaphore create_semaphore(char *semaphoreName, uint32 value)
{
  801a46:	55                   	push   %ebp
  801a47:	89 e5                	mov    %esp,%ebp
  801a49:	83 ec 08             	sub    $0x8,%esp
	panic("create_semaphore() is not implemented yet...!!");
  801a4c:	83 ec 04             	sub    $0x4,%esp
  801a4f:	68 a8 23 80 00       	push   $0x8023a8
  801a54:	6a 07                	push   $0x7
  801a56:	68 d7 23 80 00       	push   $0x8023d7
  801a5b:	e8 88 e8 ff ff       	call   8002e8 <_panic>

00801a60 <get_semaphore>:
}
struct semaphore get_semaphore(int32 ownerEnvID, char* semaphoreName)
{
  801a60:	55                   	push   %ebp
  801a61:	89 e5                	mov    %esp,%ebp
  801a63:	83 ec 08             	sub    $0x8,%esp
	panic("get_semaphore() is not implemented yet...!!");
  801a66:	83 ec 04             	sub    $0x4,%esp
  801a69:	68 e8 23 80 00       	push   $0x8023e8
  801a6e:	6a 0b                	push   $0xb
  801a70:	68 d7 23 80 00       	push   $0x8023d7
  801a75:	e8 6e e8 ff ff       	call   8002e8 <_panic>

00801a7a <wait_semaphore>:
}

void wait_semaphore(struct semaphore sem)
{
  801a7a:	55                   	push   %ebp
  801a7b:	89 e5                	mov    %esp,%ebp
  801a7d:	83 ec 08             	sub    $0x8,%esp
	panic("wait_semaphore() is not implemented yet...!!");
  801a80:	83 ec 04             	sub    $0x4,%esp
  801a83:	68 14 24 80 00       	push   $0x802414
  801a88:	6a 10                	push   $0x10
  801a8a:	68 d7 23 80 00       	push   $0x8023d7
  801a8f:	e8 54 e8 ff ff       	call   8002e8 <_panic>

00801a94 <signal_semaphore>:
}

void signal_semaphore(struct semaphore sem)
{
  801a94:	55                   	push   %ebp
  801a95:	89 e5                	mov    %esp,%ebp
  801a97:	83 ec 08             	sub    $0x8,%esp
	panic("signal_semaphore() is not implemented yet...!!");
  801a9a:	83 ec 04             	sub    $0x4,%esp
  801a9d:	68 44 24 80 00       	push   $0x802444
  801aa2:	6a 15                	push   $0x15
  801aa4:	68 d7 23 80 00       	push   $0x8023d7
  801aa9:	e8 3a e8 ff ff       	call   8002e8 <_panic>

00801aae <semaphore_count>:
}

int semaphore_count(struct semaphore sem)
{
  801aae:	55                   	push   %ebp
  801aaf:	89 e5                	mov    %esp,%ebp
	return sem.semdata->count;
  801ab1:	8b 45 08             	mov    0x8(%ebp),%eax
  801ab4:	8b 40 10             	mov    0x10(%eax),%eax
}
  801ab7:	5d                   	pop    %ebp
  801ab8:	c3                   	ret    
  801ab9:	66 90                	xchg   %ax,%ax
  801abb:	90                   	nop

00801abc <__udivdi3>:
  801abc:	55                   	push   %ebp
  801abd:	57                   	push   %edi
  801abe:	56                   	push   %esi
  801abf:	53                   	push   %ebx
  801ac0:	83 ec 1c             	sub    $0x1c,%esp
  801ac3:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801ac7:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801acb:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801acf:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801ad3:	89 ca                	mov    %ecx,%edx
  801ad5:	89 f8                	mov    %edi,%eax
  801ad7:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801adb:	85 f6                	test   %esi,%esi
  801add:	75 2d                	jne    801b0c <__udivdi3+0x50>
  801adf:	39 cf                	cmp    %ecx,%edi
  801ae1:	77 65                	ja     801b48 <__udivdi3+0x8c>
  801ae3:	89 fd                	mov    %edi,%ebp
  801ae5:	85 ff                	test   %edi,%edi
  801ae7:	75 0b                	jne    801af4 <__udivdi3+0x38>
  801ae9:	b8 01 00 00 00       	mov    $0x1,%eax
  801aee:	31 d2                	xor    %edx,%edx
  801af0:	f7 f7                	div    %edi
  801af2:	89 c5                	mov    %eax,%ebp
  801af4:	31 d2                	xor    %edx,%edx
  801af6:	89 c8                	mov    %ecx,%eax
  801af8:	f7 f5                	div    %ebp
  801afa:	89 c1                	mov    %eax,%ecx
  801afc:	89 d8                	mov    %ebx,%eax
  801afe:	f7 f5                	div    %ebp
  801b00:	89 cf                	mov    %ecx,%edi
  801b02:	89 fa                	mov    %edi,%edx
  801b04:	83 c4 1c             	add    $0x1c,%esp
  801b07:	5b                   	pop    %ebx
  801b08:	5e                   	pop    %esi
  801b09:	5f                   	pop    %edi
  801b0a:	5d                   	pop    %ebp
  801b0b:	c3                   	ret    
  801b0c:	39 ce                	cmp    %ecx,%esi
  801b0e:	77 28                	ja     801b38 <__udivdi3+0x7c>
  801b10:	0f bd fe             	bsr    %esi,%edi
  801b13:	83 f7 1f             	xor    $0x1f,%edi
  801b16:	75 40                	jne    801b58 <__udivdi3+0x9c>
  801b18:	39 ce                	cmp    %ecx,%esi
  801b1a:	72 0a                	jb     801b26 <__udivdi3+0x6a>
  801b1c:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801b20:	0f 87 9e 00 00 00    	ja     801bc4 <__udivdi3+0x108>
  801b26:	b8 01 00 00 00       	mov    $0x1,%eax
  801b2b:	89 fa                	mov    %edi,%edx
  801b2d:	83 c4 1c             	add    $0x1c,%esp
  801b30:	5b                   	pop    %ebx
  801b31:	5e                   	pop    %esi
  801b32:	5f                   	pop    %edi
  801b33:	5d                   	pop    %ebp
  801b34:	c3                   	ret    
  801b35:	8d 76 00             	lea    0x0(%esi),%esi
  801b38:	31 ff                	xor    %edi,%edi
  801b3a:	31 c0                	xor    %eax,%eax
  801b3c:	89 fa                	mov    %edi,%edx
  801b3e:	83 c4 1c             	add    $0x1c,%esp
  801b41:	5b                   	pop    %ebx
  801b42:	5e                   	pop    %esi
  801b43:	5f                   	pop    %edi
  801b44:	5d                   	pop    %ebp
  801b45:	c3                   	ret    
  801b46:	66 90                	xchg   %ax,%ax
  801b48:	89 d8                	mov    %ebx,%eax
  801b4a:	f7 f7                	div    %edi
  801b4c:	31 ff                	xor    %edi,%edi
  801b4e:	89 fa                	mov    %edi,%edx
  801b50:	83 c4 1c             	add    $0x1c,%esp
  801b53:	5b                   	pop    %ebx
  801b54:	5e                   	pop    %esi
  801b55:	5f                   	pop    %edi
  801b56:	5d                   	pop    %ebp
  801b57:	c3                   	ret    
  801b58:	bd 20 00 00 00       	mov    $0x20,%ebp
  801b5d:	89 eb                	mov    %ebp,%ebx
  801b5f:	29 fb                	sub    %edi,%ebx
  801b61:	89 f9                	mov    %edi,%ecx
  801b63:	d3 e6                	shl    %cl,%esi
  801b65:	89 c5                	mov    %eax,%ebp
  801b67:	88 d9                	mov    %bl,%cl
  801b69:	d3 ed                	shr    %cl,%ebp
  801b6b:	89 e9                	mov    %ebp,%ecx
  801b6d:	09 f1                	or     %esi,%ecx
  801b6f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801b73:	89 f9                	mov    %edi,%ecx
  801b75:	d3 e0                	shl    %cl,%eax
  801b77:	89 c5                	mov    %eax,%ebp
  801b79:	89 d6                	mov    %edx,%esi
  801b7b:	88 d9                	mov    %bl,%cl
  801b7d:	d3 ee                	shr    %cl,%esi
  801b7f:	89 f9                	mov    %edi,%ecx
  801b81:	d3 e2                	shl    %cl,%edx
  801b83:	8b 44 24 08          	mov    0x8(%esp),%eax
  801b87:	88 d9                	mov    %bl,%cl
  801b89:	d3 e8                	shr    %cl,%eax
  801b8b:	09 c2                	or     %eax,%edx
  801b8d:	89 d0                	mov    %edx,%eax
  801b8f:	89 f2                	mov    %esi,%edx
  801b91:	f7 74 24 0c          	divl   0xc(%esp)
  801b95:	89 d6                	mov    %edx,%esi
  801b97:	89 c3                	mov    %eax,%ebx
  801b99:	f7 e5                	mul    %ebp
  801b9b:	39 d6                	cmp    %edx,%esi
  801b9d:	72 19                	jb     801bb8 <__udivdi3+0xfc>
  801b9f:	74 0b                	je     801bac <__udivdi3+0xf0>
  801ba1:	89 d8                	mov    %ebx,%eax
  801ba3:	31 ff                	xor    %edi,%edi
  801ba5:	e9 58 ff ff ff       	jmp    801b02 <__udivdi3+0x46>
  801baa:	66 90                	xchg   %ax,%ax
  801bac:	8b 54 24 08          	mov    0x8(%esp),%edx
  801bb0:	89 f9                	mov    %edi,%ecx
  801bb2:	d3 e2                	shl    %cl,%edx
  801bb4:	39 c2                	cmp    %eax,%edx
  801bb6:	73 e9                	jae    801ba1 <__udivdi3+0xe5>
  801bb8:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801bbb:	31 ff                	xor    %edi,%edi
  801bbd:	e9 40 ff ff ff       	jmp    801b02 <__udivdi3+0x46>
  801bc2:	66 90                	xchg   %ax,%ax
  801bc4:	31 c0                	xor    %eax,%eax
  801bc6:	e9 37 ff ff ff       	jmp    801b02 <__udivdi3+0x46>
  801bcb:	90                   	nop

00801bcc <__umoddi3>:
  801bcc:	55                   	push   %ebp
  801bcd:	57                   	push   %edi
  801bce:	56                   	push   %esi
  801bcf:	53                   	push   %ebx
  801bd0:	83 ec 1c             	sub    $0x1c,%esp
  801bd3:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801bd7:	8b 74 24 34          	mov    0x34(%esp),%esi
  801bdb:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801bdf:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801be3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801be7:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801beb:	89 f3                	mov    %esi,%ebx
  801bed:	89 fa                	mov    %edi,%edx
  801bef:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801bf3:	89 34 24             	mov    %esi,(%esp)
  801bf6:	85 c0                	test   %eax,%eax
  801bf8:	75 1a                	jne    801c14 <__umoddi3+0x48>
  801bfa:	39 f7                	cmp    %esi,%edi
  801bfc:	0f 86 a2 00 00 00    	jbe    801ca4 <__umoddi3+0xd8>
  801c02:	89 c8                	mov    %ecx,%eax
  801c04:	89 f2                	mov    %esi,%edx
  801c06:	f7 f7                	div    %edi
  801c08:	89 d0                	mov    %edx,%eax
  801c0a:	31 d2                	xor    %edx,%edx
  801c0c:	83 c4 1c             	add    $0x1c,%esp
  801c0f:	5b                   	pop    %ebx
  801c10:	5e                   	pop    %esi
  801c11:	5f                   	pop    %edi
  801c12:	5d                   	pop    %ebp
  801c13:	c3                   	ret    
  801c14:	39 f0                	cmp    %esi,%eax
  801c16:	0f 87 ac 00 00 00    	ja     801cc8 <__umoddi3+0xfc>
  801c1c:	0f bd e8             	bsr    %eax,%ebp
  801c1f:	83 f5 1f             	xor    $0x1f,%ebp
  801c22:	0f 84 ac 00 00 00    	je     801cd4 <__umoddi3+0x108>
  801c28:	bf 20 00 00 00       	mov    $0x20,%edi
  801c2d:	29 ef                	sub    %ebp,%edi
  801c2f:	89 fe                	mov    %edi,%esi
  801c31:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801c35:	89 e9                	mov    %ebp,%ecx
  801c37:	d3 e0                	shl    %cl,%eax
  801c39:	89 d7                	mov    %edx,%edi
  801c3b:	89 f1                	mov    %esi,%ecx
  801c3d:	d3 ef                	shr    %cl,%edi
  801c3f:	09 c7                	or     %eax,%edi
  801c41:	89 e9                	mov    %ebp,%ecx
  801c43:	d3 e2                	shl    %cl,%edx
  801c45:	89 14 24             	mov    %edx,(%esp)
  801c48:	89 d8                	mov    %ebx,%eax
  801c4a:	d3 e0                	shl    %cl,%eax
  801c4c:	89 c2                	mov    %eax,%edx
  801c4e:	8b 44 24 08          	mov    0x8(%esp),%eax
  801c52:	d3 e0                	shl    %cl,%eax
  801c54:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c58:	8b 44 24 08          	mov    0x8(%esp),%eax
  801c5c:	89 f1                	mov    %esi,%ecx
  801c5e:	d3 e8                	shr    %cl,%eax
  801c60:	09 d0                	or     %edx,%eax
  801c62:	d3 eb                	shr    %cl,%ebx
  801c64:	89 da                	mov    %ebx,%edx
  801c66:	f7 f7                	div    %edi
  801c68:	89 d3                	mov    %edx,%ebx
  801c6a:	f7 24 24             	mull   (%esp)
  801c6d:	89 c6                	mov    %eax,%esi
  801c6f:	89 d1                	mov    %edx,%ecx
  801c71:	39 d3                	cmp    %edx,%ebx
  801c73:	0f 82 87 00 00 00    	jb     801d00 <__umoddi3+0x134>
  801c79:	0f 84 91 00 00 00    	je     801d10 <__umoddi3+0x144>
  801c7f:	8b 54 24 04          	mov    0x4(%esp),%edx
  801c83:	29 f2                	sub    %esi,%edx
  801c85:	19 cb                	sbb    %ecx,%ebx
  801c87:	89 d8                	mov    %ebx,%eax
  801c89:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801c8d:	d3 e0                	shl    %cl,%eax
  801c8f:	89 e9                	mov    %ebp,%ecx
  801c91:	d3 ea                	shr    %cl,%edx
  801c93:	09 d0                	or     %edx,%eax
  801c95:	89 e9                	mov    %ebp,%ecx
  801c97:	d3 eb                	shr    %cl,%ebx
  801c99:	89 da                	mov    %ebx,%edx
  801c9b:	83 c4 1c             	add    $0x1c,%esp
  801c9e:	5b                   	pop    %ebx
  801c9f:	5e                   	pop    %esi
  801ca0:	5f                   	pop    %edi
  801ca1:	5d                   	pop    %ebp
  801ca2:	c3                   	ret    
  801ca3:	90                   	nop
  801ca4:	89 fd                	mov    %edi,%ebp
  801ca6:	85 ff                	test   %edi,%edi
  801ca8:	75 0b                	jne    801cb5 <__umoddi3+0xe9>
  801caa:	b8 01 00 00 00       	mov    $0x1,%eax
  801caf:	31 d2                	xor    %edx,%edx
  801cb1:	f7 f7                	div    %edi
  801cb3:	89 c5                	mov    %eax,%ebp
  801cb5:	89 f0                	mov    %esi,%eax
  801cb7:	31 d2                	xor    %edx,%edx
  801cb9:	f7 f5                	div    %ebp
  801cbb:	89 c8                	mov    %ecx,%eax
  801cbd:	f7 f5                	div    %ebp
  801cbf:	89 d0                	mov    %edx,%eax
  801cc1:	e9 44 ff ff ff       	jmp    801c0a <__umoddi3+0x3e>
  801cc6:	66 90                	xchg   %ax,%ax
  801cc8:	89 c8                	mov    %ecx,%eax
  801cca:	89 f2                	mov    %esi,%edx
  801ccc:	83 c4 1c             	add    $0x1c,%esp
  801ccf:	5b                   	pop    %ebx
  801cd0:	5e                   	pop    %esi
  801cd1:	5f                   	pop    %edi
  801cd2:	5d                   	pop    %ebp
  801cd3:	c3                   	ret    
  801cd4:	3b 04 24             	cmp    (%esp),%eax
  801cd7:	72 06                	jb     801cdf <__umoddi3+0x113>
  801cd9:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801cdd:	77 0f                	ja     801cee <__umoddi3+0x122>
  801cdf:	89 f2                	mov    %esi,%edx
  801ce1:	29 f9                	sub    %edi,%ecx
  801ce3:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801ce7:	89 14 24             	mov    %edx,(%esp)
  801cea:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801cee:	8b 44 24 04          	mov    0x4(%esp),%eax
  801cf2:	8b 14 24             	mov    (%esp),%edx
  801cf5:	83 c4 1c             	add    $0x1c,%esp
  801cf8:	5b                   	pop    %ebx
  801cf9:	5e                   	pop    %esi
  801cfa:	5f                   	pop    %edi
  801cfb:	5d                   	pop    %ebp
  801cfc:	c3                   	ret    
  801cfd:	8d 76 00             	lea    0x0(%esi),%esi
  801d00:	2b 04 24             	sub    (%esp),%eax
  801d03:	19 fa                	sbb    %edi,%edx
  801d05:	89 d1                	mov    %edx,%ecx
  801d07:	89 c6                	mov    %eax,%esi
  801d09:	e9 71 ff ff ff       	jmp    801c7f <__umoddi3+0xb3>
  801d0e:	66 90                	xchg   %ax,%ax
  801d10:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801d14:	72 ea                	jb     801d00 <__umoddi3+0x134>
  801d16:	89 d9                	mov    %ebx,%ecx
  801d18:	e9 62 ff ff ff       	jmp    801c7f <__umoddi3+0xb3>
