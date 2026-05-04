
obj/user/priRR_fib_pri8:     file format elf32-i386


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
  800031:	e8 c0 00 00 00       	call   8000f6 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
int fibonacci(int n);
extern void sys_env_set_priority(int , int );

void
_main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	81 ec 18 01 00 00    	sub    $0x118,%esp
	sys_env_set_priority(myEnv->env_id, 8);
  800041:	a1 20 30 80 00       	mov    0x803020,%eax
  800046:	8b 40 10             	mov    0x10(%eax),%eax
  800049:	83 ec 08             	sub    $0x8,%esp
  80004c:	6a 08                	push   $0x8
  80004e:	50                   	push   %eax
  80004f:	e8 9b 19 00 00       	call   8019ef <sys_env_set_priority>
  800054:	83 c4 10             	add    $0x10,%esp

	int i1=0;
  800057:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	char buff1[256];
	i1 = 38;
  80005e:	c7 45 f4 26 00 00 00 	movl   $0x26,-0xc(%ebp)

	int res = fibonacci(i1) ;
  800065:	83 ec 0c             	sub    $0xc,%esp
  800068:	ff 75 f4             	pushl  -0xc(%ebp)
  80006b:	e8 47 00 00 00       	call   8000b7 <fibonacci>
  800070:	83 c4 10             	add    $0x10,%esp
  800073:	89 45 f0             	mov    %eax,-0x10(%ebp)

	atomic_cprintf("Fibonacci #%d = %d\n",i1, res);
  800076:	83 ec 04             	sub    $0x4,%esp
  800079:	ff 75 f0             	pushl  -0x10(%ebp)
  80007c:	ff 75 f4             	pushl  -0xc(%ebp)
  80007f:	68 80 1c 80 00       	push   $0x801c80
  800084:	e8 66 05 00 00       	call   8005ef <atomic_cprintf>
  800089:	83 c4 10             	add    $0x10,%esp

	if (res != 63245986)
  80008c:	81 7d f0 a2 0e c5 03 	cmpl   $0x3c50ea2,-0x10(%ebp)
  800093:	74 1a                	je     8000af <_main+0x77>
		panic("[envID %d] wrong result!", myEnv->env_id);
  800095:	a1 20 30 80 00       	mov    0x803020,%eax
  80009a:	8b 40 10             	mov    0x10(%eax),%eax
  80009d:	50                   	push   %eax
  80009e:	68 94 1c 80 00       	push   $0x801c94
  8000a3:	6a 16                	push   $0x16
  8000a5:	68 ad 1c 80 00       	push   $0x801cad
  8000aa:	e8 00 02 00 00       	call   8002af <_panic>

	//To indicate that it's completed successfully
	inctst();
  8000af:	e8 d4 17 00 00       	call   801888 <inctst>

	return;
  8000b4:	90                   	nop
}
  8000b5:	c9                   	leave  
  8000b6:	c3                   	ret    

008000b7 <fibonacci>:


int fibonacci(int n)
{
  8000b7:	55                   	push   %ebp
  8000b8:	89 e5                	mov    %esp,%ebp
  8000ba:	53                   	push   %ebx
  8000bb:	83 ec 04             	sub    $0x4,%esp
	if (n <= 1)
  8000be:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
  8000c2:	7f 07                	jg     8000cb <fibonacci+0x14>
		return 1 ;
  8000c4:	b8 01 00 00 00       	mov    $0x1,%eax
  8000c9:	eb 26                	jmp    8000f1 <fibonacci+0x3a>
	return fibonacci(n-1) + fibonacci(n-2) ;
  8000cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8000ce:	48                   	dec    %eax
  8000cf:	83 ec 0c             	sub    $0xc,%esp
  8000d2:	50                   	push   %eax
  8000d3:	e8 df ff ff ff       	call   8000b7 <fibonacci>
  8000d8:	83 c4 10             	add    $0x10,%esp
  8000db:	89 c3                	mov    %eax,%ebx
  8000dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8000e0:	83 e8 02             	sub    $0x2,%eax
  8000e3:	83 ec 0c             	sub    $0xc,%esp
  8000e6:	50                   	push   %eax
  8000e7:	e8 cb ff ff ff       	call   8000b7 <fibonacci>
  8000ec:	83 c4 10             	add    $0x10,%esp
  8000ef:	01 d8                	add    %ebx,%eax
}
  8000f1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8000f4:	c9                   	leave  
  8000f5:	c3                   	ret    

008000f6 <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  8000f6:	55                   	push   %ebp
  8000f7:	89 e5                	mov    %esp,%ebp
  8000f9:	57                   	push   %edi
  8000fa:	56                   	push   %esi
  8000fb:	53                   	push   %ebx
  8000fc:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  8000ff:	e8 46 16 00 00       	call   80174a <sys_getenvindex>
  800104:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  800107:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80010a:	89 d0                	mov    %edx,%eax
  80010c:	c1 e0 02             	shl    $0x2,%eax
  80010f:	01 d0                	add    %edx,%eax
  800111:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800118:	01 d0                	add    %edx,%eax
  80011a:	89 c2                	mov    %eax,%edx
  80011c:	c1 e2 04             	shl    $0x4,%edx
  80011f:	29 c2                	sub    %eax,%edx
  800121:	8d 04 95 00 00 00 00 	lea    0x0(,%edx,4),%eax
  800128:	89 c2                	mov    %eax,%edx
  80012a:	8d 82 00 00 c0 ee    	lea    -0x11400000(%edx),%eax
  800130:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800135:	a1 20 30 80 00       	mov    0x803020,%eax
  80013a:	8a 40 20             	mov    0x20(%eax),%al
  80013d:	84 c0                	test   %al,%al
  80013f:	74 0d                	je     80014e <libmain+0x58>
		binaryname = myEnv->prog_name;
  800141:	a1 20 30 80 00       	mov    0x803020,%eax
  800146:	83 c0 20             	add    $0x20,%eax
  800149:	a3 04 30 80 00       	mov    %eax,0x803004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80014e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800152:	7e 0a                	jle    80015e <libmain+0x68>
		binaryname = argv[0];
  800154:	8b 45 0c             	mov    0xc(%ebp),%eax
  800157:	8b 00                	mov    (%eax),%eax
  800159:	a3 04 30 80 00       	mov    %eax,0x803004

	// call user main routine
	_main(argc, argv);
  80015e:	83 ec 08             	sub    $0x8,%esp
  800161:	ff 75 0c             	pushl  0xc(%ebp)
  800164:	ff 75 08             	pushl  0x8(%ebp)
  800167:	e8 cc fe ff ff       	call   800038 <_main>
  80016c:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  80016f:	a1 00 30 80 00       	mov    0x803000,%eax
  800174:	85 c0                	test   %eax,%eax
  800176:	0f 84 01 01 00 00    	je     80027d <libmain+0x187>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  80017c:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  800182:	bb bc 1d 80 00       	mov    $0x801dbc,%ebx
  800187:	ba 0e 00 00 00       	mov    $0xe,%edx
  80018c:	89 c7                	mov    %eax,%edi
  80018e:	89 de                	mov    %ebx,%esi
  800190:	89 d1                	mov    %edx,%ecx
  800192:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  800194:	8d 55 8a             	lea    -0x76(%ebp),%edx
  800197:	b9 56 00 00 00       	mov    $0x56,%ecx
  80019c:	b0 00                	mov    $0x0,%al
  80019e:	89 d7                	mov    %edx,%edi
  8001a0:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  8001a2:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  8001a9:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8001ac:	83 ec 08             	sub    $0x8,%esp
  8001af:	50                   	push   %eax
  8001b0:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  8001b6:	50                   	push   %eax
  8001b7:	e8 c4 17 00 00       	call   801980 <sys_utilities>
  8001bc:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  8001bf:	e8 0d 13 00 00       	call   8014d1 <sys_lock_cons>
		{
			cprintf("**************************************\n");
  8001c4:	83 ec 0c             	sub    $0xc,%esp
  8001c7:	68 dc 1c 80 00       	push   $0x801cdc
  8001cc:	e8 ac 03 00 00       	call   80057d <cprintf>
  8001d1:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  8001d4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8001d7:	85 c0                	test   %eax,%eax
  8001d9:	74 18                	je     8001f3 <libmain+0xfd>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  8001db:	e8 be 17 00 00       	call   80199e <sys_get_optimal_num_faults>
  8001e0:	83 ec 08             	sub    $0x8,%esp
  8001e3:	50                   	push   %eax
  8001e4:	68 04 1d 80 00       	push   $0x801d04
  8001e9:	e8 8f 03 00 00       	call   80057d <cprintf>
  8001ee:	83 c4 10             	add    $0x10,%esp
  8001f1:	eb 59                	jmp    80024c <libmain+0x156>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8001f3:	a1 20 30 80 00       	mov    0x803020,%eax
  8001f8:	8b 90 bc 05 00 00    	mov    0x5bc(%eax),%edx
  8001fe:	a1 20 30 80 00       	mov    0x803020,%eax
  800203:	8b 80 ac 05 00 00    	mov    0x5ac(%eax),%eax
  800209:	83 ec 04             	sub    $0x4,%esp
  80020c:	52                   	push   %edx
  80020d:	50                   	push   %eax
  80020e:	68 28 1d 80 00       	push   $0x801d28
  800213:	e8 65 03 00 00       	call   80057d <cprintf>
  800218:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  80021b:	a1 20 30 80 00       	mov    0x803020,%eax
  800220:	8b 88 d0 05 00 00    	mov    0x5d0(%eax),%ecx
  800226:	a1 20 30 80 00       	mov    0x803020,%eax
  80022b:	8b 90 cc 05 00 00    	mov    0x5cc(%eax),%edx
  800231:	a1 20 30 80 00       	mov    0x803020,%eax
  800236:	8b 80 c8 05 00 00    	mov    0x5c8(%eax),%eax
  80023c:	51                   	push   %ecx
  80023d:	52                   	push   %edx
  80023e:	50                   	push   %eax
  80023f:	68 50 1d 80 00       	push   $0x801d50
  800244:	e8 34 03 00 00       	call   80057d <cprintf>
  800249:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80024c:	a1 20 30 80 00       	mov    0x803020,%eax
  800251:	8b 80 d4 05 00 00    	mov    0x5d4(%eax),%eax
  800257:	83 ec 08             	sub    $0x8,%esp
  80025a:	50                   	push   %eax
  80025b:	68 a8 1d 80 00       	push   $0x801da8
  800260:	e8 18 03 00 00       	call   80057d <cprintf>
  800265:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  800268:	83 ec 0c             	sub    $0xc,%esp
  80026b:	68 dc 1c 80 00       	push   $0x801cdc
  800270:	e8 08 03 00 00       	call   80057d <cprintf>
  800275:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  800278:	e8 6e 12 00 00       	call   8014eb <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  80027d:	e8 1f 00 00 00       	call   8002a1 <exit>
}
  800282:	90                   	nop
  800283:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800286:	5b                   	pop    %ebx
  800287:	5e                   	pop    %esi
  800288:	5f                   	pop    %edi
  800289:	5d                   	pop    %ebp
  80028a:	c3                   	ret    

0080028b <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  80028b:	55                   	push   %ebp
  80028c:	89 e5                	mov    %esp,%ebp
  80028e:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800291:	83 ec 0c             	sub    $0xc,%esp
  800294:	6a 00                	push   $0x0
  800296:	e8 7b 14 00 00       	call   801716 <sys_destroy_env>
  80029b:	83 c4 10             	add    $0x10,%esp
}
  80029e:	90                   	nop
  80029f:	c9                   	leave  
  8002a0:	c3                   	ret    

008002a1 <exit>:

void
exit(void)
{
  8002a1:	55                   	push   %ebp
  8002a2:	89 e5                	mov    %esp,%ebp
  8002a4:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8002a7:	e8 d0 14 00 00       	call   80177c <sys_exit_env>
}
  8002ac:	90                   	nop
  8002ad:	c9                   	leave  
  8002ae:	c3                   	ret    

008002af <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8002af:	55                   	push   %ebp
  8002b0:	89 e5                	mov    %esp,%ebp
  8002b2:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8002b5:	8d 45 10             	lea    0x10(%ebp),%eax
  8002b8:	83 c0 04             	add    $0x4,%eax
  8002bb:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8002be:	a1 18 b1 81 00       	mov    0x81b118,%eax
  8002c3:	85 c0                	test   %eax,%eax
  8002c5:	74 16                	je     8002dd <_panic+0x2e>
		cprintf("%s: ", argv0);
  8002c7:	a1 18 b1 81 00       	mov    0x81b118,%eax
  8002cc:	83 ec 08             	sub    $0x8,%esp
  8002cf:	50                   	push   %eax
  8002d0:	68 20 1e 80 00       	push   $0x801e20
  8002d5:	e8 a3 02 00 00       	call   80057d <cprintf>
  8002da:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  8002dd:	a1 04 30 80 00       	mov    0x803004,%eax
  8002e2:	83 ec 0c             	sub    $0xc,%esp
  8002e5:	ff 75 0c             	pushl  0xc(%ebp)
  8002e8:	ff 75 08             	pushl  0x8(%ebp)
  8002eb:	50                   	push   %eax
  8002ec:	68 28 1e 80 00       	push   $0x801e28
  8002f1:	6a 74                	push   $0x74
  8002f3:	e8 b2 02 00 00       	call   8005aa <cprintf_colored>
  8002f8:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  8002fb:	8b 45 10             	mov    0x10(%ebp),%eax
  8002fe:	83 ec 08             	sub    $0x8,%esp
  800301:	ff 75 f4             	pushl  -0xc(%ebp)
  800304:	50                   	push   %eax
  800305:	e8 04 02 00 00       	call   80050e <vcprintf>
  80030a:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  80030d:	83 ec 08             	sub    $0x8,%esp
  800310:	6a 00                	push   $0x0
  800312:	68 50 1e 80 00       	push   $0x801e50
  800317:	e8 f2 01 00 00       	call   80050e <vcprintf>
  80031c:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  80031f:	e8 7d ff ff ff       	call   8002a1 <exit>

	// should not return here
	while (1) ;
  800324:	eb fe                	jmp    800324 <_panic+0x75>

00800326 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800326:	55                   	push   %ebp
  800327:	89 e5                	mov    %esp,%ebp
  800329:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  80032c:	a1 20 30 80 00       	mov    0x803020,%eax
  800331:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800337:	8b 45 0c             	mov    0xc(%ebp),%eax
  80033a:	39 c2                	cmp    %eax,%edx
  80033c:	74 14                	je     800352 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  80033e:	83 ec 04             	sub    $0x4,%esp
  800341:	68 54 1e 80 00       	push   $0x801e54
  800346:	6a 26                	push   $0x26
  800348:	68 a0 1e 80 00       	push   $0x801ea0
  80034d:	e8 5d ff ff ff       	call   8002af <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800352:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800359:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800360:	e9 c5 00 00 00       	jmp    80042a <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  800365:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800368:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80036f:	8b 45 08             	mov    0x8(%ebp),%eax
  800372:	01 d0                	add    %edx,%eax
  800374:	8b 00                	mov    (%eax),%eax
  800376:	85 c0                	test   %eax,%eax
  800378:	75 08                	jne    800382 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  80037a:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  80037d:	e9 a5 00 00 00       	jmp    800427 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  800382:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800389:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800390:	eb 69                	jmp    8003fb <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800392:	a1 20 30 80 00       	mov    0x803020,%eax
  800397:	8b 88 a4 05 00 00    	mov    0x5a4(%eax),%ecx
  80039d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8003a0:	89 d0                	mov    %edx,%eax
  8003a2:	01 c0                	add    %eax,%eax
  8003a4:	01 d0                	add    %edx,%eax
  8003a6:	c1 e0 03             	shl    $0x3,%eax
  8003a9:	01 c8                	add    %ecx,%eax
  8003ab:	8a 40 04             	mov    0x4(%eax),%al
  8003ae:	84 c0                	test   %al,%al
  8003b0:	75 46                	jne    8003f8 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8003b2:	a1 20 30 80 00       	mov    0x803020,%eax
  8003b7:	8b 88 a4 05 00 00    	mov    0x5a4(%eax),%ecx
  8003bd:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8003c0:	89 d0                	mov    %edx,%eax
  8003c2:	01 c0                	add    %eax,%eax
  8003c4:	01 d0                	add    %edx,%eax
  8003c6:	c1 e0 03             	shl    $0x3,%eax
  8003c9:	01 c8                	add    %ecx,%eax
  8003cb:	8b 00                	mov    (%eax),%eax
  8003cd:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8003d0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8003d3:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8003d8:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8003da:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003dd:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8003e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8003e7:	01 c8                	add    %ecx,%eax
  8003e9:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8003eb:	39 c2                	cmp    %eax,%edx
  8003ed:	75 09                	jne    8003f8 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  8003ef:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8003f6:	eb 15                	jmp    80040d <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8003f8:	ff 45 e8             	incl   -0x18(%ebp)
  8003fb:	a1 20 30 80 00       	mov    0x803020,%eax
  800400:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800406:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800409:	39 c2                	cmp    %eax,%edx
  80040b:	77 85                	ja     800392 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  80040d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800411:	75 14                	jne    800427 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  800413:	83 ec 04             	sub    $0x4,%esp
  800416:	68 ac 1e 80 00       	push   $0x801eac
  80041b:	6a 3a                	push   $0x3a
  80041d:	68 a0 1e 80 00       	push   $0x801ea0
  800422:	e8 88 fe ff ff       	call   8002af <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800427:	ff 45 f0             	incl   -0x10(%ebp)
  80042a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80042d:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800430:	0f 8c 2f ff ff ff    	jl     800365 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800436:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80043d:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800444:	eb 26                	jmp    80046c <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800446:	a1 20 30 80 00       	mov    0x803020,%eax
  80044b:	8b 88 a4 05 00 00    	mov    0x5a4(%eax),%ecx
  800451:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800454:	89 d0                	mov    %edx,%eax
  800456:	01 c0                	add    %eax,%eax
  800458:	01 d0                	add    %edx,%eax
  80045a:	c1 e0 03             	shl    $0x3,%eax
  80045d:	01 c8                	add    %ecx,%eax
  80045f:	8a 40 04             	mov    0x4(%eax),%al
  800462:	3c 01                	cmp    $0x1,%al
  800464:	75 03                	jne    800469 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  800466:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800469:	ff 45 e0             	incl   -0x20(%ebp)
  80046c:	a1 20 30 80 00       	mov    0x803020,%eax
  800471:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800477:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80047a:	39 c2                	cmp    %eax,%edx
  80047c:	77 c8                	ja     800446 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  80047e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800481:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800484:	74 14                	je     80049a <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  800486:	83 ec 04             	sub    $0x4,%esp
  800489:	68 00 1f 80 00       	push   $0x801f00
  80048e:	6a 44                	push   $0x44
  800490:	68 a0 1e 80 00       	push   $0x801ea0
  800495:	e8 15 fe ff ff       	call   8002af <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  80049a:	90                   	nop
  80049b:	c9                   	leave  
  80049c:	c3                   	ret    

0080049d <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  80049d:	55                   	push   %ebp
  80049e:	89 e5                	mov    %esp,%ebp
  8004a0:	53                   	push   %ebx
  8004a1:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  8004a4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004a7:	8b 00                	mov    (%eax),%eax
  8004a9:	8d 48 01             	lea    0x1(%eax),%ecx
  8004ac:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004af:	89 0a                	mov    %ecx,(%edx)
  8004b1:	8b 55 08             	mov    0x8(%ebp),%edx
  8004b4:	88 d1                	mov    %dl,%cl
  8004b6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004b9:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8004bd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004c0:	8b 00                	mov    (%eax),%eax
  8004c2:	3d ff 00 00 00       	cmp    $0xff,%eax
  8004c7:	75 30                	jne    8004f9 <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  8004c9:	8b 15 1c b1 81 00    	mov    0x81b11c,%edx
  8004cf:	a0 44 30 80 00       	mov    0x803044,%al
  8004d4:	0f b6 c0             	movzbl %al,%eax
  8004d7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8004da:	8b 09                	mov    (%ecx),%ecx
  8004dc:	89 cb                	mov    %ecx,%ebx
  8004de:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8004e1:	83 c1 08             	add    $0x8,%ecx
  8004e4:	52                   	push   %edx
  8004e5:	50                   	push   %eax
  8004e6:	53                   	push   %ebx
  8004e7:	51                   	push   %ecx
  8004e8:	e8 a0 0f 00 00       	call   80148d <sys_cputs>
  8004ed:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8004f0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004f3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8004f9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004fc:	8b 40 04             	mov    0x4(%eax),%eax
  8004ff:	8d 50 01             	lea    0x1(%eax),%edx
  800502:	8b 45 0c             	mov    0xc(%ebp),%eax
  800505:	89 50 04             	mov    %edx,0x4(%eax)
}
  800508:	90                   	nop
  800509:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80050c:	c9                   	leave  
  80050d:	c3                   	ret    

0080050e <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  80050e:	55                   	push   %ebp
  80050f:	89 e5                	mov    %esp,%ebp
  800511:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800517:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80051e:	00 00 00 
	b.cnt = 0;
  800521:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800528:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  80052b:	ff 75 0c             	pushl  0xc(%ebp)
  80052e:	ff 75 08             	pushl  0x8(%ebp)
  800531:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800537:	50                   	push   %eax
  800538:	68 9d 04 80 00       	push   $0x80049d
  80053d:	e8 5a 02 00 00       	call   80079c <vprintfmt>
  800542:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  800545:	8b 15 1c b1 81 00    	mov    0x81b11c,%edx
  80054b:	a0 44 30 80 00       	mov    0x803044,%al
  800550:	0f b6 c0             	movzbl %al,%eax
  800553:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  800559:	52                   	push   %edx
  80055a:	50                   	push   %eax
  80055b:	51                   	push   %ecx
  80055c:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800562:	83 c0 08             	add    $0x8,%eax
  800565:	50                   	push   %eax
  800566:	e8 22 0f 00 00       	call   80148d <sys_cputs>
  80056b:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  80056e:	c6 05 44 30 80 00 00 	movb   $0x0,0x803044
	return b.cnt;
  800575:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  80057b:	c9                   	leave  
  80057c:	c3                   	ret    

0080057d <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  80057d:	55                   	push   %ebp
  80057e:	89 e5                	mov    %esp,%ebp
  800580:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800583:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
	va_start(ap, fmt);
  80058a:	8d 45 0c             	lea    0xc(%ebp),%eax
  80058d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800590:	8b 45 08             	mov    0x8(%ebp),%eax
  800593:	83 ec 08             	sub    $0x8,%esp
  800596:	ff 75 f4             	pushl  -0xc(%ebp)
  800599:	50                   	push   %eax
  80059a:	e8 6f ff ff ff       	call   80050e <vcprintf>
  80059f:	83 c4 10             	add    $0x10,%esp
  8005a2:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8005a5:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8005a8:	c9                   	leave  
  8005a9:	c3                   	ret    

008005aa <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  8005aa:	55                   	push   %ebp
  8005ab:	89 e5                	mov    %esp,%ebp
  8005ad:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8005b0:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
	curTextClr = (textClr << 8) ; //set text color by the given value
  8005b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8005ba:	c1 e0 08             	shl    $0x8,%eax
  8005bd:	a3 1c b1 81 00       	mov    %eax,0x81b11c
	va_start(ap, fmt);
  8005c2:	8d 45 0c             	lea    0xc(%ebp),%eax
  8005c5:	83 c0 04             	add    $0x4,%eax
  8005c8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8005cb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005ce:	83 ec 08             	sub    $0x8,%esp
  8005d1:	ff 75 f4             	pushl  -0xc(%ebp)
  8005d4:	50                   	push   %eax
  8005d5:	e8 34 ff ff ff       	call   80050e <vcprintf>
  8005da:	83 c4 10             	add    $0x10,%esp
  8005dd:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  8005e0:	c7 05 1c b1 81 00 00 	movl   $0x700,0x81b11c
  8005e7:	07 00 00 

	return cnt;
  8005ea:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8005ed:	c9                   	leave  
  8005ee:	c3                   	ret    

008005ef <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  8005ef:	55                   	push   %ebp
  8005f0:	89 e5                	mov    %esp,%ebp
  8005f2:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  8005f5:	e8 d7 0e 00 00       	call   8014d1 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  8005fa:	8d 45 0c             	lea    0xc(%ebp),%eax
  8005fd:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  800600:	8b 45 08             	mov    0x8(%ebp),%eax
  800603:	83 ec 08             	sub    $0x8,%esp
  800606:	ff 75 f4             	pushl  -0xc(%ebp)
  800609:	50                   	push   %eax
  80060a:	e8 ff fe ff ff       	call   80050e <vcprintf>
  80060f:	83 c4 10             	add    $0x10,%esp
  800612:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  800615:	e8 d1 0e 00 00       	call   8014eb <sys_unlock_cons>
	return cnt;
  80061a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80061d:	c9                   	leave  
  80061e:	c3                   	ret    

0080061f <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80061f:	55                   	push   %ebp
  800620:	89 e5                	mov    %esp,%ebp
  800622:	53                   	push   %ebx
  800623:	83 ec 14             	sub    $0x14,%esp
  800626:	8b 45 10             	mov    0x10(%ebp),%eax
  800629:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80062c:	8b 45 14             	mov    0x14(%ebp),%eax
  80062f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800632:	8b 45 18             	mov    0x18(%ebp),%eax
  800635:	ba 00 00 00 00       	mov    $0x0,%edx
  80063a:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80063d:	77 55                	ja     800694 <printnum+0x75>
  80063f:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800642:	72 05                	jb     800649 <printnum+0x2a>
  800644:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800647:	77 4b                	ja     800694 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800649:	8b 45 1c             	mov    0x1c(%ebp),%eax
  80064c:	8d 58 ff             	lea    -0x1(%eax),%ebx
  80064f:	8b 45 18             	mov    0x18(%ebp),%eax
  800652:	ba 00 00 00 00       	mov    $0x0,%edx
  800657:	52                   	push   %edx
  800658:	50                   	push   %eax
  800659:	ff 75 f4             	pushl  -0xc(%ebp)
  80065c:	ff 75 f0             	pushl  -0x10(%ebp)
  80065f:	e8 ac 13 00 00       	call   801a10 <__udivdi3>
  800664:	83 c4 10             	add    $0x10,%esp
  800667:	83 ec 04             	sub    $0x4,%esp
  80066a:	ff 75 20             	pushl  0x20(%ebp)
  80066d:	53                   	push   %ebx
  80066e:	ff 75 18             	pushl  0x18(%ebp)
  800671:	52                   	push   %edx
  800672:	50                   	push   %eax
  800673:	ff 75 0c             	pushl  0xc(%ebp)
  800676:	ff 75 08             	pushl  0x8(%ebp)
  800679:	e8 a1 ff ff ff       	call   80061f <printnum>
  80067e:	83 c4 20             	add    $0x20,%esp
  800681:	eb 1a                	jmp    80069d <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800683:	83 ec 08             	sub    $0x8,%esp
  800686:	ff 75 0c             	pushl  0xc(%ebp)
  800689:	ff 75 20             	pushl  0x20(%ebp)
  80068c:	8b 45 08             	mov    0x8(%ebp),%eax
  80068f:	ff d0                	call   *%eax
  800691:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800694:	ff 4d 1c             	decl   0x1c(%ebp)
  800697:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  80069b:	7f e6                	jg     800683 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80069d:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8006a0:	bb 00 00 00 00       	mov    $0x0,%ebx
  8006a5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8006a8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8006ab:	53                   	push   %ebx
  8006ac:	51                   	push   %ecx
  8006ad:	52                   	push   %edx
  8006ae:	50                   	push   %eax
  8006af:	e8 6c 14 00 00       	call   801b20 <__umoddi3>
  8006b4:	83 c4 10             	add    $0x10,%esp
  8006b7:	05 74 21 80 00       	add    $0x802174,%eax
  8006bc:	8a 00                	mov    (%eax),%al
  8006be:	0f be c0             	movsbl %al,%eax
  8006c1:	83 ec 08             	sub    $0x8,%esp
  8006c4:	ff 75 0c             	pushl  0xc(%ebp)
  8006c7:	50                   	push   %eax
  8006c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8006cb:	ff d0                	call   *%eax
  8006cd:	83 c4 10             	add    $0x10,%esp
}
  8006d0:	90                   	nop
  8006d1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8006d4:	c9                   	leave  
  8006d5:	c3                   	ret    

008006d6 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8006d6:	55                   	push   %ebp
  8006d7:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8006d9:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8006dd:	7e 1c                	jle    8006fb <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8006df:	8b 45 08             	mov    0x8(%ebp),%eax
  8006e2:	8b 00                	mov    (%eax),%eax
  8006e4:	8d 50 08             	lea    0x8(%eax),%edx
  8006e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ea:	89 10                	mov    %edx,(%eax)
  8006ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ef:	8b 00                	mov    (%eax),%eax
  8006f1:	83 e8 08             	sub    $0x8,%eax
  8006f4:	8b 50 04             	mov    0x4(%eax),%edx
  8006f7:	8b 00                	mov    (%eax),%eax
  8006f9:	eb 40                	jmp    80073b <getuint+0x65>
	else if (lflag)
  8006fb:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8006ff:	74 1e                	je     80071f <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800701:	8b 45 08             	mov    0x8(%ebp),%eax
  800704:	8b 00                	mov    (%eax),%eax
  800706:	8d 50 04             	lea    0x4(%eax),%edx
  800709:	8b 45 08             	mov    0x8(%ebp),%eax
  80070c:	89 10                	mov    %edx,(%eax)
  80070e:	8b 45 08             	mov    0x8(%ebp),%eax
  800711:	8b 00                	mov    (%eax),%eax
  800713:	83 e8 04             	sub    $0x4,%eax
  800716:	8b 00                	mov    (%eax),%eax
  800718:	ba 00 00 00 00       	mov    $0x0,%edx
  80071d:	eb 1c                	jmp    80073b <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  80071f:	8b 45 08             	mov    0x8(%ebp),%eax
  800722:	8b 00                	mov    (%eax),%eax
  800724:	8d 50 04             	lea    0x4(%eax),%edx
  800727:	8b 45 08             	mov    0x8(%ebp),%eax
  80072a:	89 10                	mov    %edx,(%eax)
  80072c:	8b 45 08             	mov    0x8(%ebp),%eax
  80072f:	8b 00                	mov    (%eax),%eax
  800731:	83 e8 04             	sub    $0x4,%eax
  800734:	8b 00                	mov    (%eax),%eax
  800736:	ba 00 00 00 00       	mov    $0x0,%edx
}
  80073b:	5d                   	pop    %ebp
  80073c:	c3                   	ret    

0080073d <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  80073d:	55                   	push   %ebp
  80073e:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800740:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800744:	7e 1c                	jle    800762 <getint+0x25>
		return va_arg(*ap, long long);
  800746:	8b 45 08             	mov    0x8(%ebp),%eax
  800749:	8b 00                	mov    (%eax),%eax
  80074b:	8d 50 08             	lea    0x8(%eax),%edx
  80074e:	8b 45 08             	mov    0x8(%ebp),%eax
  800751:	89 10                	mov    %edx,(%eax)
  800753:	8b 45 08             	mov    0x8(%ebp),%eax
  800756:	8b 00                	mov    (%eax),%eax
  800758:	83 e8 08             	sub    $0x8,%eax
  80075b:	8b 50 04             	mov    0x4(%eax),%edx
  80075e:	8b 00                	mov    (%eax),%eax
  800760:	eb 38                	jmp    80079a <getint+0x5d>
	else if (lflag)
  800762:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800766:	74 1a                	je     800782 <getint+0x45>
		return va_arg(*ap, long);
  800768:	8b 45 08             	mov    0x8(%ebp),%eax
  80076b:	8b 00                	mov    (%eax),%eax
  80076d:	8d 50 04             	lea    0x4(%eax),%edx
  800770:	8b 45 08             	mov    0x8(%ebp),%eax
  800773:	89 10                	mov    %edx,(%eax)
  800775:	8b 45 08             	mov    0x8(%ebp),%eax
  800778:	8b 00                	mov    (%eax),%eax
  80077a:	83 e8 04             	sub    $0x4,%eax
  80077d:	8b 00                	mov    (%eax),%eax
  80077f:	99                   	cltd   
  800780:	eb 18                	jmp    80079a <getint+0x5d>
	else
		return va_arg(*ap, int);
  800782:	8b 45 08             	mov    0x8(%ebp),%eax
  800785:	8b 00                	mov    (%eax),%eax
  800787:	8d 50 04             	lea    0x4(%eax),%edx
  80078a:	8b 45 08             	mov    0x8(%ebp),%eax
  80078d:	89 10                	mov    %edx,(%eax)
  80078f:	8b 45 08             	mov    0x8(%ebp),%eax
  800792:	8b 00                	mov    (%eax),%eax
  800794:	83 e8 04             	sub    $0x4,%eax
  800797:	8b 00                	mov    (%eax),%eax
  800799:	99                   	cltd   
}
  80079a:	5d                   	pop    %ebp
  80079b:	c3                   	ret    

0080079c <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80079c:	55                   	push   %ebp
  80079d:	89 e5                	mov    %esp,%ebp
  80079f:	56                   	push   %esi
  8007a0:	53                   	push   %ebx
  8007a1:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8007a4:	eb 17                	jmp    8007bd <vprintfmt+0x21>
			if (ch == '\0')
  8007a6:	85 db                	test   %ebx,%ebx
  8007a8:	0f 84 c1 03 00 00    	je     800b6f <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  8007ae:	83 ec 08             	sub    $0x8,%esp
  8007b1:	ff 75 0c             	pushl  0xc(%ebp)
  8007b4:	53                   	push   %ebx
  8007b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8007b8:	ff d0                	call   *%eax
  8007ba:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8007bd:	8b 45 10             	mov    0x10(%ebp),%eax
  8007c0:	8d 50 01             	lea    0x1(%eax),%edx
  8007c3:	89 55 10             	mov    %edx,0x10(%ebp)
  8007c6:	8a 00                	mov    (%eax),%al
  8007c8:	0f b6 d8             	movzbl %al,%ebx
  8007cb:	83 fb 25             	cmp    $0x25,%ebx
  8007ce:	75 d6                	jne    8007a6 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8007d0:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  8007d4:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  8007db:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8007e2:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8007e9:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8007f0:	8b 45 10             	mov    0x10(%ebp),%eax
  8007f3:	8d 50 01             	lea    0x1(%eax),%edx
  8007f6:	89 55 10             	mov    %edx,0x10(%ebp)
  8007f9:	8a 00                	mov    (%eax),%al
  8007fb:	0f b6 d8             	movzbl %al,%ebx
  8007fe:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800801:	83 f8 5b             	cmp    $0x5b,%eax
  800804:	0f 87 3d 03 00 00    	ja     800b47 <vprintfmt+0x3ab>
  80080a:	8b 04 85 98 21 80 00 	mov    0x802198(,%eax,4),%eax
  800811:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800813:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800817:	eb d7                	jmp    8007f0 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800819:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  80081d:	eb d1                	jmp    8007f0 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80081f:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800826:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800829:	89 d0                	mov    %edx,%eax
  80082b:	c1 e0 02             	shl    $0x2,%eax
  80082e:	01 d0                	add    %edx,%eax
  800830:	01 c0                	add    %eax,%eax
  800832:	01 d8                	add    %ebx,%eax
  800834:	83 e8 30             	sub    $0x30,%eax
  800837:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  80083a:	8b 45 10             	mov    0x10(%ebp),%eax
  80083d:	8a 00                	mov    (%eax),%al
  80083f:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800842:	83 fb 2f             	cmp    $0x2f,%ebx
  800845:	7e 3e                	jle    800885 <vprintfmt+0xe9>
  800847:	83 fb 39             	cmp    $0x39,%ebx
  80084a:	7f 39                	jg     800885 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80084c:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  80084f:	eb d5                	jmp    800826 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800851:	8b 45 14             	mov    0x14(%ebp),%eax
  800854:	83 c0 04             	add    $0x4,%eax
  800857:	89 45 14             	mov    %eax,0x14(%ebp)
  80085a:	8b 45 14             	mov    0x14(%ebp),%eax
  80085d:	83 e8 04             	sub    $0x4,%eax
  800860:	8b 00                	mov    (%eax),%eax
  800862:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800865:	eb 1f                	jmp    800886 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800867:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80086b:	79 83                	jns    8007f0 <vprintfmt+0x54>
				width = 0;
  80086d:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800874:	e9 77 ff ff ff       	jmp    8007f0 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800879:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800880:	e9 6b ff ff ff       	jmp    8007f0 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800885:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800886:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80088a:	0f 89 60 ff ff ff    	jns    8007f0 <vprintfmt+0x54>
				width = precision, precision = -1;
  800890:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800893:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800896:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  80089d:	e9 4e ff ff ff       	jmp    8007f0 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8008a2:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  8008a5:	e9 46 ff ff ff       	jmp    8007f0 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8008aa:	8b 45 14             	mov    0x14(%ebp),%eax
  8008ad:	83 c0 04             	add    $0x4,%eax
  8008b0:	89 45 14             	mov    %eax,0x14(%ebp)
  8008b3:	8b 45 14             	mov    0x14(%ebp),%eax
  8008b6:	83 e8 04             	sub    $0x4,%eax
  8008b9:	8b 00                	mov    (%eax),%eax
  8008bb:	83 ec 08             	sub    $0x8,%esp
  8008be:	ff 75 0c             	pushl  0xc(%ebp)
  8008c1:	50                   	push   %eax
  8008c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8008c5:	ff d0                	call   *%eax
  8008c7:	83 c4 10             	add    $0x10,%esp
			break;
  8008ca:	e9 9b 02 00 00       	jmp    800b6a <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8008cf:	8b 45 14             	mov    0x14(%ebp),%eax
  8008d2:	83 c0 04             	add    $0x4,%eax
  8008d5:	89 45 14             	mov    %eax,0x14(%ebp)
  8008d8:	8b 45 14             	mov    0x14(%ebp),%eax
  8008db:	83 e8 04             	sub    $0x4,%eax
  8008de:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  8008e0:	85 db                	test   %ebx,%ebx
  8008e2:	79 02                	jns    8008e6 <vprintfmt+0x14a>
				err = -err;
  8008e4:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  8008e6:	83 fb 64             	cmp    $0x64,%ebx
  8008e9:	7f 0b                	jg     8008f6 <vprintfmt+0x15a>
  8008eb:	8b 34 9d e0 1f 80 00 	mov    0x801fe0(,%ebx,4),%esi
  8008f2:	85 f6                	test   %esi,%esi
  8008f4:	75 19                	jne    80090f <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8008f6:	53                   	push   %ebx
  8008f7:	68 85 21 80 00       	push   $0x802185
  8008fc:	ff 75 0c             	pushl  0xc(%ebp)
  8008ff:	ff 75 08             	pushl  0x8(%ebp)
  800902:	e8 70 02 00 00       	call   800b77 <printfmt>
  800907:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  80090a:	e9 5b 02 00 00       	jmp    800b6a <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  80090f:	56                   	push   %esi
  800910:	68 8e 21 80 00       	push   $0x80218e
  800915:	ff 75 0c             	pushl  0xc(%ebp)
  800918:	ff 75 08             	pushl  0x8(%ebp)
  80091b:	e8 57 02 00 00       	call   800b77 <printfmt>
  800920:	83 c4 10             	add    $0x10,%esp
			break;
  800923:	e9 42 02 00 00       	jmp    800b6a <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800928:	8b 45 14             	mov    0x14(%ebp),%eax
  80092b:	83 c0 04             	add    $0x4,%eax
  80092e:	89 45 14             	mov    %eax,0x14(%ebp)
  800931:	8b 45 14             	mov    0x14(%ebp),%eax
  800934:	83 e8 04             	sub    $0x4,%eax
  800937:	8b 30                	mov    (%eax),%esi
  800939:	85 f6                	test   %esi,%esi
  80093b:	75 05                	jne    800942 <vprintfmt+0x1a6>
				p = "(null)";
  80093d:	be 91 21 80 00       	mov    $0x802191,%esi
			if (width > 0 && padc != '-')
  800942:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800946:	7e 6d                	jle    8009b5 <vprintfmt+0x219>
  800948:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  80094c:	74 67                	je     8009b5 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  80094e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800951:	83 ec 08             	sub    $0x8,%esp
  800954:	50                   	push   %eax
  800955:	56                   	push   %esi
  800956:	e8 1e 03 00 00       	call   800c79 <strnlen>
  80095b:	83 c4 10             	add    $0x10,%esp
  80095e:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800961:	eb 16                	jmp    800979 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800963:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800967:	83 ec 08             	sub    $0x8,%esp
  80096a:	ff 75 0c             	pushl  0xc(%ebp)
  80096d:	50                   	push   %eax
  80096e:	8b 45 08             	mov    0x8(%ebp),%eax
  800971:	ff d0                	call   *%eax
  800973:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800976:	ff 4d e4             	decl   -0x1c(%ebp)
  800979:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80097d:	7f e4                	jg     800963 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80097f:	eb 34                	jmp    8009b5 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800981:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800985:	74 1c                	je     8009a3 <vprintfmt+0x207>
  800987:	83 fb 1f             	cmp    $0x1f,%ebx
  80098a:	7e 05                	jle    800991 <vprintfmt+0x1f5>
  80098c:	83 fb 7e             	cmp    $0x7e,%ebx
  80098f:	7e 12                	jle    8009a3 <vprintfmt+0x207>
					putch('?', putdat);
  800991:	83 ec 08             	sub    $0x8,%esp
  800994:	ff 75 0c             	pushl  0xc(%ebp)
  800997:	6a 3f                	push   $0x3f
  800999:	8b 45 08             	mov    0x8(%ebp),%eax
  80099c:	ff d0                	call   *%eax
  80099e:	83 c4 10             	add    $0x10,%esp
  8009a1:	eb 0f                	jmp    8009b2 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  8009a3:	83 ec 08             	sub    $0x8,%esp
  8009a6:	ff 75 0c             	pushl  0xc(%ebp)
  8009a9:	53                   	push   %ebx
  8009aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ad:	ff d0                	call   *%eax
  8009af:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8009b2:	ff 4d e4             	decl   -0x1c(%ebp)
  8009b5:	89 f0                	mov    %esi,%eax
  8009b7:	8d 70 01             	lea    0x1(%eax),%esi
  8009ba:	8a 00                	mov    (%eax),%al
  8009bc:	0f be d8             	movsbl %al,%ebx
  8009bf:	85 db                	test   %ebx,%ebx
  8009c1:	74 24                	je     8009e7 <vprintfmt+0x24b>
  8009c3:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8009c7:	78 b8                	js     800981 <vprintfmt+0x1e5>
  8009c9:	ff 4d e0             	decl   -0x20(%ebp)
  8009cc:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8009d0:	79 af                	jns    800981 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8009d2:	eb 13                	jmp    8009e7 <vprintfmt+0x24b>
				putch(' ', putdat);
  8009d4:	83 ec 08             	sub    $0x8,%esp
  8009d7:	ff 75 0c             	pushl  0xc(%ebp)
  8009da:	6a 20                	push   $0x20
  8009dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8009df:	ff d0                	call   *%eax
  8009e1:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8009e4:	ff 4d e4             	decl   -0x1c(%ebp)
  8009e7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8009eb:	7f e7                	jg     8009d4 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  8009ed:	e9 78 01 00 00       	jmp    800b6a <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  8009f2:	83 ec 08             	sub    $0x8,%esp
  8009f5:	ff 75 e8             	pushl  -0x18(%ebp)
  8009f8:	8d 45 14             	lea    0x14(%ebp),%eax
  8009fb:	50                   	push   %eax
  8009fc:	e8 3c fd ff ff       	call   80073d <getint>
  800a01:	83 c4 10             	add    $0x10,%esp
  800a04:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a07:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800a0a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a0d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a10:	85 d2                	test   %edx,%edx
  800a12:	79 23                	jns    800a37 <vprintfmt+0x29b>
				putch('-', putdat);
  800a14:	83 ec 08             	sub    $0x8,%esp
  800a17:	ff 75 0c             	pushl  0xc(%ebp)
  800a1a:	6a 2d                	push   $0x2d
  800a1c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a1f:	ff d0                	call   *%eax
  800a21:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800a24:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a27:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a2a:	f7 d8                	neg    %eax
  800a2c:	83 d2 00             	adc    $0x0,%edx
  800a2f:	f7 da                	neg    %edx
  800a31:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a34:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800a37:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800a3e:	e9 bc 00 00 00       	jmp    800aff <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800a43:	83 ec 08             	sub    $0x8,%esp
  800a46:	ff 75 e8             	pushl  -0x18(%ebp)
  800a49:	8d 45 14             	lea    0x14(%ebp),%eax
  800a4c:	50                   	push   %eax
  800a4d:	e8 84 fc ff ff       	call   8006d6 <getuint>
  800a52:	83 c4 10             	add    $0x10,%esp
  800a55:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a58:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800a5b:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800a62:	e9 98 00 00 00       	jmp    800aff <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800a67:	83 ec 08             	sub    $0x8,%esp
  800a6a:	ff 75 0c             	pushl  0xc(%ebp)
  800a6d:	6a 58                	push   $0x58
  800a6f:	8b 45 08             	mov    0x8(%ebp),%eax
  800a72:	ff d0                	call   *%eax
  800a74:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800a77:	83 ec 08             	sub    $0x8,%esp
  800a7a:	ff 75 0c             	pushl  0xc(%ebp)
  800a7d:	6a 58                	push   $0x58
  800a7f:	8b 45 08             	mov    0x8(%ebp),%eax
  800a82:	ff d0                	call   *%eax
  800a84:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800a87:	83 ec 08             	sub    $0x8,%esp
  800a8a:	ff 75 0c             	pushl  0xc(%ebp)
  800a8d:	6a 58                	push   $0x58
  800a8f:	8b 45 08             	mov    0x8(%ebp),%eax
  800a92:	ff d0                	call   *%eax
  800a94:	83 c4 10             	add    $0x10,%esp
			break;
  800a97:	e9 ce 00 00 00       	jmp    800b6a <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800a9c:	83 ec 08             	sub    $0x8,%esp
  800a9f:	ff 75 0c             	pushl  0xc(%ebp)
  800aa2:	6a 30                	push   $0x30
  800aa4:	8b 45 08             	mov    0x8(%ebp),%eax
  800aa7:	ff d0                	call   *%eax
  800aa9:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800aac:	83 ec 08             	sub    $0x8,%esp
  800aaf:	ff 75 0c             	pushl  0xc(%ebp)
  800ab2:	6a 78                	push   $0x78
  800ab4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ab7:	ff d0                	call   *%eax
  800ab9:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800abc:	8b 45 14             	mov    0x14(%ebp),%eax
  800abf:	83 c0 04             	add    $0x4,%eax
  800ac2:	89 45 14             	mov    %eax,0x14(%ebp)
  800ac5:	8b 45 14             	mov    0x14(%ebp),%eax
  800ac8:	83 e8 04             	sub    $0x4,%eax
  800acb:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800acd:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ad0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800ad7:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800ade:	eb 1f                	jmp    800aff <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800ae0:	83 ec 08             	sub    $0x8,%esp
  800ae3:	ff 75 e8             	pushl  -0x18(%ebp)
  800ae6:	8d 45 14             	lea    0x14(%ebp),%eax
  800ae9:	50                   	push   %eax
  800aea:	e8 e7 fb ff ff       	call   8006d6 <getuint>
  800aef:	83 c4 10             	add    $0x10,%esp
  800af2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800af5:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800af8:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800aff:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800b03:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800b06:	83 ec 04             	sub    $0x4,%esp
  800b09:	52                   	push   %edx
  800b0a:	ff 75 e4             	pushl  -0x1c(%ebp)
  800b0d:	50                   	push   %eax
  800b0e:	ff 75 f4             	pushl  -0xc(%ebp)
  800b11:	ff 75 f0             	pushl  -0x10(%ebp)
  800b14:	ff 75 0c             	pushl  0xc(%ebp)
  800b17:	ff 75 08             	pushl  0x8(%ebp)
  800b1a:	e8 00 fb ff ff       	call   80061f <printnum>
  800b1f:	83 c4 20             	add    $0x20,%esp
			break;
  800b22:	eb 46                	jmp    800b6a <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800b24:	83 ec 08             	sub    $0x8,%esp
  800b27:	ff 75 0c             	pushl  0xc(%ebp)
  800b2a:	53                   	push   %ebx
  800b2b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b2e:	ff d0                	call   *%eax
  800b30:	83 c4 10             	add    $0x10,%esp
			break;
  800b33:	eb 35                	jmp    800b6a <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800b35:	c6 05 44 30 80 00 00 	movb   $0x0,0x803044
			break;
  800b3c:	eb 2c                	jmp    800b6a <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800b3e:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
			break;
  800b45:	eb 23                	jmp    800b6a <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800b47:	83 ec 08             	sub    $0x8,%esp
  800b4a:	ff 75 0c             	pushl  0xc(%ebp)
  800b4d:	6a 25                	push   $0x25
  800b4f:	8b 45 08             	mov    0x8(%ebp),%eax
  800b52:	ff d0                	call   *%eax
  800b54:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800b57:	ff 4d 10             	decl   0x10(%ebp)
  800b5a:	eb 03                	jmp    800b5f <vprintfmt+0x3c3>
  800b5c:	ff 4d 10             	decl   0x10(%ebp)
  800b5f:	8b 45 10             	mov    0x10(%ebp),%eax
  800b62:	48                   	dec    %eax
  800b63:	8a 00                	mov    (%eax),%al
  800b65:	3c 25                	cmp    $0x25,%al
  800b67:	75 f3                	jne    800b5c <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800b69:	90                   	nop
		}
	}
  800b6a:	e9 35 fc ff ff       	jmp    8007a4 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800b6f:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800b70:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800b73:	5b                   	pop    %ebx
  800b74:	5e                   	pop    %esi
  800b75:	5d                   	pop    %ebp
  800b76:	c3                   	ret    

00800b77 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800b77:	55                   	push   %ebp
  800b78:	89 e5                	mov    %esp,%ebp
  800b7a:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800b7d:	8d 45 10             	lea    0x10(%ebp),%eax
  800b80:	83 c0 04             	add    $0x4,%eax
  800b83:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800b86:	8b 45 10             	mov    0x10(%ebp),%eax
  800b89:	ff 75 f4             	pushl  -0xc(%ebp)
  800b8c:	50                   	push   %eax
  800b8d:	ff 75 0c             	pushl  0xc(%ebp)
  800b90:	ff 75 08             	pushl  0x8(%ebp)
  800b93:	e8 04 fc ff ff       	call   80079c <vprintfmt>
  800b98:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800b9b:	90                   	nop
  800b9c:	c9                   	leave  
  800b9d:	c3                   	ret    

00800b9e <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800b9e:	55                   	push   %ebp
  800b9f:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800ba1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ba4:	8b 40 08             	mov    0x8(%eax),%eax
  800ba7:	8d 50 01             	lea    0x1(%eax),%edx
  800baa:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bad:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800bb0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bb3:	8b 10                	mov    (%eax),%edx
  800bb5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bb8:	8b 40 04             	mov    0x4(%eax),%eax
  800bbb:	39 c2                	cmp    %eax,%edx
  800bbd:	73 12                	jae    800bd1 <sprintputch+0x33>
		*b->buf++ = ch;
  800bbf:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bc2:	8b 00                	mov    (%eax),%eax
  800bc4:	8d 48 01             	lea    0x1(%eax),%ecx
  800bc7:	8b 55 0c             	mov    0xc(%ebp),%edx
  800bca:	89 0a                	mov    %ecx,(%edx)
  800bcc:	8b 55 08             	mov    0x8(%ebp),%edx
  800bcf:	88 10                	mov    %dl,(%eax)
}
  800bd1:	90                   	nop
  800bd2:	5d                   	pop    %ebp
  800bd3:	c3                   	ret    

00800bd4 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800bd4:	55                   	push   %ebp
  800bd5:	89 e5                	mov    %esp,%ebp
  800bd7:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800bda:	8b 45 08             	mov    0x8(%ebp),%eax
  800bdd:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800be0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800be3:	8d 50 ff             	lea    -0x1(%eax),%edx
  800be6:	8b 45 08             	mov    0x8(%ebp),%eax
  800be9:	01 d0                	add    %edx,%eax
  800beb:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bee:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800bf5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800bf9:	74 06                	je     800c01 <vsnprintf+0x2d>
  800bfb:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800bff:	7f 07                	jg     800c08 <vsnprintf+0x34>
		return -E_INVAL;
  800c01:	b8 03 00 00 00       	mov    $0x3,%eax
  800c06:	eb 20                	jmp    800c28 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800c08:	ff 75 14             	pushl  0x14(%ebp)
  800c0b:	ff 75 10             	pushl  0x10(%ebp)
  800c0e:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800c11:	50                   	push   %eax
  800c12:	68 9e 0b 80 00       	push   $0x800b9e
  800c17:	e8 80 fb ff ff       	call   80079c <vprintfmt>
  800c1c:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800c1f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800c22:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800c25:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800c28:	c9                   	leave  
  800c29:	c3                   	ret    

00800c2a <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800c2a:	55                   	push   %ebp
  800c2b:	89 e5                	mov    %esp,%ebp
  800c2d:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800c30:	8d 45 10             	lea    0x10(%ebp),%eax
  800c33:	83 c0 04             	add    $0x4,%eax
  800c36:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800c39:	8b 45 10             	mov    0x10(%ebp),%eax
  800c3c:	ff 75 f4             	pushl  -0xc(%ebp)
  800c3f:	50                   	push   %eax
  800c40:	ff 75 0c             	pushl  0xc(%ebp)
  800c43:	ff 75 08             	pushl  0x8(%ebp)
  800c46:	e8 89 ff ff ff       	call   800bd4 <vsnprintf>
  800c4b:	83 c4 10             	add    $0x10,%esp
  800c4e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800c51:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800c54:	c9                   	leave  
  800c55:	c3                   	ret    

00800c56 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800c56:	55                   	push   %ebp
  800c57:	89 e5                	mov    %esp,%ebp
  800c59:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800c5c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c63:	eb 06                	jmp    800c6b <strlen+0x15>
		n++;
  800c65:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800c68:	ff 45 08             	incl   0x8(%ebp)
  800c6b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c6e:	8a 00                	mov    (%eax),%al
  800c70:	84 c0                	test   %al,%al
  800c72:	75 f1                	jne    800c65 <strlen+0xf>
		n++;
	return n;
  800c74:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c77:	c9                   	leave  
  800c78:	c3                   	ret    

00800c79 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800c79:	55                   	push   %ebp
  800c7a:	89 e5                	mov    %esp,%ebp
  800c7c:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c7f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c86:	eb 09                	jmp    800c91 <strnlen+0x18>
		n++;
  800c88:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c8b:	ff 45 08             	incl   0x8(%ebp)
  800c8e:	ff 4d 0c             	decl   0xc(%ebp)
  800c91:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c95:	74 09                	je     800ca0 <strnlen+0x27>
  800c97:	8b 45 08             	mov    0x8(%ebp),%eax
  800c9a:	8a 00                	mov    (%eax),%al
  800c9c:	84 c0                	test   %al,%al
  800c9e:	75 e8                	jne    800c88 <strnlen+0xf>
		n++;
	return n;
  800ca0:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800ca3:	c9                   	leave  
  800ca4:	c3                   	ret    

00800ca5 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800ca5:	55                   	push   %ebp
  800ca6:	89 e5                	mov    %esp,%ebp
  800ca8:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800cab:	8b 45 08             	mov    0x8(%ebp),%eax
  800cae:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800cb1:	90                   	nop
  800cb2:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb5:	8d 50 01             	lea    0x1(%eax),%edx
  800cb8:	89 55 08             	mov    %edx,0x8(%ebp)
  800cbb:	8b 55 0c             	mov    0xc(%ebp),%edx
  800cbe:	8d 4a 01             	lea    0x1(%edx),%ecx
  800cc1:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800cc4:	8a 12                	mov    (%edx),%dl
  800cc6:	88 10                	mov    %dl,(%eax)
  800cc8:	8a 00                	mov    (%eax),%al
  800cca:	84 c0                	test   %al,%al
  800ccc:	75 e4                	jne    800cb2 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800cce:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800cd1:	c9                   	leave  
  800cd2:	c3                   	ret    

00800cd3 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800cd3:	55                   	push   %ebp
  800cd4:	89 e5                	mov    %esp,%ebp
  800cd6:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800cd9:	8b 45 08             	mov    0x8(%ebp),%eax
  800cdc:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800cdf:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800ce6:	eb 1f                	jmp    800d07 <strncpy+0x34>
		*dst++ = *src;
  800ce8:	8b 45 08             	mov    0x8(%ebp),%eax
  800ceb:	8d 50 01             	lea    0x1(%eax),%edx
  800cee:	89 55 08             	mov    %edx,0x8(%ebp)
  800cf1:	8b 55 0c             	mov    0xc(%ebp),%edx
  800cf4:	8a 12                	mov    (%edx),%dl
  800cf6:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800cf8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cfb:	8a 00                	mov    (%eax),%al
  800cfd:	84 c0                	test   %al,%al
  800cff:	74 03                	je     800d04 <strncpy+0x31>
			src++;
  800d01:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800d04:	ff 45 fc             	incl   -0x4(%ebp)
  800d07:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d0a:	3b 45 10             	cmp    0x10(%ebp),%eax
  800d0d:	72 d9                	jb     800ce8 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800d0f:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800d12:	c9                   	leave  
  800d13:	c3                   	ret    

00800d14 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800d14:	55                   	push   %ebp
  800d15:	89 e5                	mov    %esp,%ebp
  800d17:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800d1a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d1d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800d20:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d24:	74 30                	je     800d56 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800d26:	eb 16                	jmp    800d3e <strlcpy+0x2a>
			*dst++ = *src++;
  800d28:	8b 45 08             	mov    0x8(%ebp),%eax
  800d2b:	8d 50 01             	lea    0x1(%eax),%edx
  800d2e:	89 55 08             	mov    %edx,0x8(%ebp)
  800d31:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d34:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d37:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800d3a:	8a 12                	mov    (%edx),%dl
  800d3c:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800d3e:	ff 4d 10             	decl   0x10(%ebp)
  800d41:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d45:	74 09                	je     800d50 <strlcpy+0x3c>
  800d47:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d4a:	8a 00                	mov    (%eax),%al
  800d4c:	84 c0                	test   %al,%al
  800d4e:	75 d8                	jne    800d28 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800d50:	8b 45 08             	mov    0x8(%ebp),%eax
  800d53:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800d56:	8b 55 08             	mov    0x8(%ebp),%edx
  800d59:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d5c:	29 c2                	sub    %eax,%edx
  800d5e:	89 d0                	mov    %edx,%eax
}
  800d60:	c9                   	leave  
  800d61:	c3                   	ret    

00800d62 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800d62:	55                   	push   %ebp
  800d63:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800d65:	eb 06                	jmp    800d6d <strcmp+0xb>
		p++, q++;
  800d67:	ff 45 08             	incl   0x8(%ebp)
  800d6a:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800d6d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d70:	8a 00                	mov    (%eax),%al
  800d72:	84 c0                	test   %al,%al
  800d74:	74 0e                	je     800d84 <strcmp+0x22>
  800d76:	8b 45 08             	mov    0x8(%ebp),%eax
  800d79:	8a 10                	mov    (%eax),%dl
  800d7b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d7e:	8a 00                	mov    (%eax),%al
  800d80:	38 c2                	cmp    %al,%dl
  800d82:	74 e3                	je     800d67 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800d84:	8b 45 08             	mov    0x8(%ebp),%eax
  800d87:	8a 00                	mov    (%eax),%al
  800d89:	0f b6 d0             	movzbl %al,%edx
  800d8c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d8f:	8a 00                	mov    (%eax),%al
  800d91:	0f b6 c0             	movzbl %al,%eax
  800d94:	29 c2                	sub    %eax,%edx
  800d96:	89 d0                	mov    %edx,%eax
}
  800d98:	5d                   	pop    %ebp
  800d99:	c3                   	ret    

00800d9a <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800d9a:	55                   	push   %ebp
  800d9b:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800d9d:	eb 09                	jmp    800da8 <strncmp+0xe>
		n--, p++, q++;
  800d9f:	ff 4d 10             	decl   0x10(%ebp)
  800da2:	ff 45 08             	incl   0x8(%ebp)
  800da5:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800da8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800dac:	74 17                	je     800dc5 <strncmp+0x2b>
  800dae:	8b 45 08             	mov    0x8(%ebp),%eax
  800db1:	8a 00                	mov    (%eax),%al
  800db3:	84 c0                	test   %al,%al
  800db5:	74 0e                	je     800dc5 <strncmp+0x2b>
  800db7:	8b 45 08             	mov    0x8(%ebp),%eax
  800dba:	8a 10                	mov    (%eax),%dl
  800dbc:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dbf:	8a 00                	mov    (%eax),%al
  800dc1:	38 c2                	cmp    %al,%dl
  800dc3:	74 da                	je     800d9f <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800dc5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800dc9:	75 07                	jne    800dd2 <strncmp+0x38>
		return 0;
  800dcb:	b8 00 00 00 00       	mov    $0x0,%eax
  800dd0:	eb 14                	jmp    800de6 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800dd2:	8b 45 08             	mov    0x8(%ebp),%eax
  800dd5:	8a 00                	mov    (%eax),%al
  800dd7:	0f b6 d0             	movzbl %al,%edx
  800dda:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ddd:	8a 00                	mov    (%eax),%al
  800ddf:	0f b6 c0             	movzbl %al,%eax
  800de2:	29 c2                	sub    %eax,%edx
  800de4:	89 d0                	mov    %edx,%eax
}
  800de6:	5d                   	pop    %ebp
  800de7:	c3                   	ret    

00800de8 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800de8:	55                   	push   %ebp
  800de9:	89 e5                	mov    %esp,%ebp
  800deb:	83 ec 04             	sub    $0x4,%esp
  800dee:	8b 45 0c             	mov    0xc(%ebp),%eax
  800df1:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800df4:	eb 12                	jmp    800e08 <strchr+0x20>
		if (*s == c)
  800df6:	8b 45 08             	mov    0x8(%ebp),%eax
  800df9:	8a 00                	mov    (%eax),%al
  800dfb:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800dfe:	75 05                	jne    800e05 <strchr+0x1d>
			return (char *) s;
  800e00:	8b 45 08             	mov    0x8(%ebp),%eax
  800e03:	eb 11                	jmp    800e16 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800e05:	ff 45 08             	incl   0x8(%ebp)
  800e08:	8b 45 08             	mov    0x8(%ebp),%eax
  800e0b:	8a 00                	mov    (%eax),%al
  800e0d:	84 c0                	test   %al,%al
  800e0f:	75 e5                	jne    800df6 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800e11:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e16:	c9                   	leave  
  800e17:	c3                   	ret    

00800e18 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800e18:	55                   	push   %ebp
  800e19:	89 e5                	mov    %esp,%ebp
  800e1b:	83 ec 04             	sub    $0x4,%esp
  800e1e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e21:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800e24:	eb 0d                	jmp    800e33 <strfind+0x1b>
		if (*s == c)
  800e26:	8b 45 08             	mov    0x8(%ebp),%eax
  800e29:	8a 00                	mov    (%eax),%al
  800e2b:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800e2e:	74 0e                	je     800e3e <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800e30:	ff 45 08             	incl   0x8(%ebp)
  800e33:	8b 45 08             	mov    0x8(%ebp),%eax
  800e36:	8a 00                	mov    (%eax),%al
  800e38:	84 c0                	test   %al,%al
  800e3a:	75 ea                	jne    800e26 <strfind+0xe>
  800e3c:	eb 01                	jmp    800e3f <strfind+0x27>
		if (*s == c)
			break;
  800e3e:	90                   	nop
	return (char *) s;
  800e3f:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e42:	c9                   	leave  
  800e43:	c3                   	ret    

00800e44 <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  800e44:	55                   	push   %ebp
  800e45:	89 e5                	mov    %esp,%ebp
  800e47:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  800e4a:	8b 45 08             	mov    0x8(%ebp),%eax
  800e4d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  800e50:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800e54:	76 63                	jbe    800eb9 <memset+0x75>
		uint64 data_block = c;
  800e56:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e59:	99                   	cltd   
  800e5a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e5d:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  800e60:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e63:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e66:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  800e6a:	c1 e0 08             	shl    $0x8,%eax
  800e6d:	09 45 f0             	or     %eax,-0x10(%ebp)
  800e70:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  800e73:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e76:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e79:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  800e7d:	c1 e0 10             	shl    $0x10,%eax
  800e80:	09 45 f0             	or     %eax,-0x10(%ebp)
  800e83:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  800e86:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e89:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e8c:	89 c2                	mov    %eax,%edx
  800e8e:	b8 00 00 00 00       	mov    $0x0,%eax
  800e93:	09 45 f0             	or     %eax,-0x10(%ebp)
  800e96:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  800e99:	eb 18                	jmp    800eb3 <memset+0x6f>
			*p64++ = data_block, n -= 8;
  800e9b:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  800e9e:	8d 41 08             	lea    0x8(%ecx),%eax
  800ea1:	89 45 fc             	mov    %eax,-0x4(%ebp)
  800ea4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ea7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800eaa:	89 01                	mov    %eax,(%ecx)
  800eac:	89 51 04             	mov    %edx,0x4(%ecx)
  800eaf:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  800eb3:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800eb7:	77 e2                	ja     800e9b <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  800eb9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ebd:	74 23                	je     800ee2 <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  800ebf:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ec2:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  800ec5:	eb 0e                	jmp    800ed5 <memset+0x91>
			*p8++ = (uint8)c;
  800ec7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800eca:	8d 50 01             	lea    0x1(%eax),%edx
  800ecd:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800ed0:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ed3:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  800ed5:	8b 45 10             	mov    0x10(%ebp),%eax
  800ed8:	8d 50 ff             	lea    -0x1(%eax),%edx
  800edb:	89 55 10             	mov    %edx,0x10(%ebp)
  800ede:	85 c0                	test   %eax,%eax
  800ee0:	75 e5                	jne    800ec7 <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  800ee2:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ee5:	c9                   	leave  
  800ee6:	c3                   	ret    

00800ee7 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800ee7:	55                   	push   %ebp
  800ee8:	89 e5                	mov    %esp,%ebp
  800eea:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  800eed:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ef0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  800ef3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef6:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  800ef9:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800efd:	76 24                	jbe    800f23 <memcpy+0x3c>
		while(n >= 8){
  800eff:	eb 1c                	jmp    800f1d <memcpy+0x36>
			*d64 = *s64;
  800f01:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f04:	8b 50 04             	mov    0x4(%eax),%edx
  800f07:	8b 00                	mov    (%eax),%eax
  800f09:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  800f0c:	89 01                	mov    %eax,(%ecx)
  800f0e:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  800f11:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  800f15:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  800f19:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  800f1d:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800f21:	77 de                	ja     800f01 <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  800f23:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f27:	74 31                	je     800f5a <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  800f29:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f2c:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  800f2f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f32:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  800f35:	eb 16                	jmp    800f4d <memcpy+0x66>
			*d8++ = *s8++;
  800f37:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800f3a:	8d 50 01             	lea    0x1(%eax),%edx
  800f3d:	89 55 f0             	mov    %edx,-0x10(%ebp)
  800f40:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f43:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f46:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  800f49:	8a 12                	mov    (%edx),%dl
  800f4b:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  800f4d:	8b 45 10             	mov    0x10(%ebp),%eax
  800f50:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f53:	89 55 10             	mov    %edx,0x10(%ebp)
  800f56:	85 c0                	test   %eax,%eax
  800f58:	75 dd                	jne    800f37 <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  800f5a:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f5d:	c9                   	leave  
  800f5e:	c3                   	ret    

00800f5f <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800f5f:	55                   	push   %ebp
  800f60:	89 e5                	mov    %esp,%ebp
  800f62:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800f65:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f68:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800f6b:	8b 45 08             	mov    0x8(%ebp),%eax
  800f6e:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800f71:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f74:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800f77:	73 50                	jae    800fc9 <memmove+0x6a>
  800f79:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f7c:	8b 45 10             	mov    0x10(%ebp),%eax
  800f7f:	01 d0                	add    %edx,%eax
  800f81:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800f84:	76 43                	jbe    800fc9 <memmove+0x6a>
		s += n;
  800f86:	8b 45 10             	mov    0x10(%ebp),%eax
  800f89:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800f8c:	8b 45 10             	mov    0x10(%ebp),%eax
  800f8f:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800f92:	eb 10                	jmp    800fa4 <memmove+0x45>
			*--d = *--s;
  800f94:	ff 4d f8             	decl   -0x8(%ebp)
  800f97:	ff 4d fc             	decl   -0x4(%ebp)
  800f9a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f9d:	8a 10                	mov    (%eax),%dl
  800f9f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fa2:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800fa4:	8b 45 10             	mov    0x10(%ebp),%eax
  800fa7:	8d 50 ff             	lea    -0x1(%eax),%edx
  800faa:	89 55 10             	mov    %edx,0x10(%ebp)
  800fad:	85 c0                	test   %eax,%eax
  800faf:	75 e3                	jne    800f94 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800fb1:	eb 23                	jmp    800fd6 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800fb3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fb6:	8d 50 01             	lea    0x1(%eax),%edx
  800fb9:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800fbc:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800fbf:	8d 4a 01             	lea    0x1(%edx),%ecx
  800fc2:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800fc5:	8a 12                	mov    (%edx),%dl
  800fc7:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800fc9:	8b 45 10             	mov    0x10(%ebp),%eax
  800fcc:	8d 50 ff             	lea    -0x1(%eax),%edx
  800fcf:	89 55 10             	mov    %edx,0x10(%ebp)
  800fd2:	85 c0                	test   %eax,%eax
  800fd4:	75 dd                	jne    800fb3 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800fd6:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800fd9:	c9                   	leave  
  800fda:	c3                   	ret    

00800fdb <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800fdb:	55                   	push   %ebp
  800fdc:	89 e5                	mov    %esp,%ebp
  800fde:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800fe1:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800fe7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fea:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800fed:	eb 2a                	jmp    801019 <memcmp+0x3e>
		if (*s1 != *s2)
  800fef:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ff2:	8a 10                	mov    (%eax),%dl
  800ff4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ff7:	8a 00                	mov    (%eax),%al
  800ff9:	38 c2                	cmp    %al,%dl
  800ffb:	74 16                	je     801013 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800ffd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801000:	8a 00                	mov    (%eax),%al
  801002:	0f b6 d0             	movzbl %al,%edx
  801005:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801008:	8a 00                	mov    (%eax),%al
  80100a:	0f b6 c0             	movzbl %al,%eax
  80100d:	29 c2                	sub    %eax,%edx
  80100f:	89 d0                	mov    %edx,%eax
  801011:	eb 18                	jmp    80102b <memcmp+0x50>
		s1++, s2++;
  801013:	ff 45 fc             	incl   -0x4(%ebp)
  801016:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801019:	8b 45 10             	mov    0x10(%ebp),%eax
  80101c:	8d 50 ff             	lea    -0x1(%eax),%edx
  80101f:	89 55 10             	mov    %edx,0x10(%ebp)
  801022:	85 c0                	test   %eax,%eax
  801024:	75 c9                	jne    800fef <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801026:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80102b:	c9                   	leave  
  80102c:	c3                   	ret    

0080102d <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  80102d:	55                   	push   %ebp
  80102e:	89 e5                	mov    %esp,%ebp
  801030:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801033:	8b 55 08             	mov    0x8(%ebp),%edx
  801036:	8b 45 10             	mov    0x10(%ebp),%eax
  801039:	01 d0                	add    %edx,%eax
  80103b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  80103e:	eb 15                	jmp    801055 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801040:	8b 45 08             	mov    0x8(%ebp),%eax
  801043:	8a 00                	mov    (%eax),%al
  801045:	0f b6 d0             	movzbl %al,%edx
  801048:	8b 45 0c             	mov    0xc(%ebp),%eax
  80104b:	0f b6 c0             	movzbl %al,%eax
  80104e:	39 c2                	cmp    %eax,%edx
  801050:	74 0d                	je     80105f <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801052:	ff 45 08             	incl   0x8(%ebp)
  801055:	8b 45 08             	mov    0x8(%ebp),%eax
  801058:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80105b:	72 e3                	jb     801040 <memfind+0x13>
  80105d:	eb 01                	jmp    801060 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  80105f:	90                   	nop
	return (void *) s;
  801060:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801063:	c9                   	leave  
  801064:	c3                   	ret    

00801065 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801065:	55                   	push   %ebp
  801066:	89 e5                	mov    %esp,%ebp
  801068:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  80106b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801072:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801079:	eb 03                	jmp    80107e <strtol+0x19>
		s++;
  80107b:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80107e:	8b 45 08             	mov    0x8(%ebp),%eax
  801081:	8a 00                	mov    (%eax),%al
  801083:	3c 20                	cmp    $0x20,%al
  801085:	74 f4                	je     80107b <strtol+0x16>
  801087:	8b 45 08             	mov    0x8(%ebp),%eax
  80108a:	8a 00                	mov    (%eax),%al
  80108c:	3c 09                	cmp    $0x9,%al
  80108e:	74 eb                	je     80107b <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801090:	8b 45 08             	mov    0x8(%ebp),%eax
  801093:	8a 00                	mov    (%eax),%al
  801095:	3c 2b                	cmp    $0x2b,%al
  801097:	75 05                	jne    80109e <strtol+0x39>
		s++;
  801099:	ff 45 08             	incl   0x8(%ebp)
  80109c:	eb 13                	jmp    8010b1 <strtol+0x4c>
	else if (*s == '-')
  80109e:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a1:	8a 00                	mov    (%eax),%al
  8010a3:	3c 2d                	cmp    $0x2d,%al
  8010a5:	75 0a                	jne    8010b1 <strtol+0x4c>
		s++, neg = 1;
  8010a7:	ff 45 08             	incl   0x8(%ebp)
  8010aa:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8010b1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010b5:	74 06                	je     8010bd <strtol+0x58>
  8010b7:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8010bb:	75 20                	jne    8010dd <strtol+0x78>
  8010bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c0:	8a 00                	mov    (%eax),%al
  8010c2:	3c 30                	cmp    $0x30,%al
  8010c4:	75 17                	jne    8010dd <strtol+0x78>
  8010c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c9:	40                   	inc    %eax
  8010ca:	8a 00                	mov    (%eax),%al
  8010cc:	3c 78                	cmp    $0x78,%al
  8010ce:	75 0d                	jne    8010dd <strtol+0x78>
		s += 2, base = 16;
  8010d0:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8010d4:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8010db:	eb 28                	jmp    801105 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8010dd:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010e1:	75 15                	jne    8010f8 <strtol+0x93>
  8010e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8010e6:	8a 00                	mov    (%eax),%al
  8010e8:	3c 30                	cmp    $0x30,%al
  8010ea:	75 0c                	jne    8010f8 <strtol+0x93>
		s++, base = 8;
  8010ec:	ff 45 08             	incl   0x8(%ebp)
  8010ef:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8010f6:	eb 0d                	jmp    801105 <strtol+0xa0>
	else if (base == 0)
  8010f8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010fc:	75 07                	jne    801105 <strtol+0xa0>
		base = 10;
  8010fe:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801105:	8b 45 08             	mov    0x8(%ebp),%eax
  801108:	8a 00                	mov    (%eax),%al
  80110a:	3c 2f                	cmp    $0x2f,%al
  80110c:	7e 19                	jle    801127 <strtol+0xc2>
  80110e:	8b 45 08             	mov    0x8(%ebp),%eax
  801111:	8a 00                	mov    (%eax),%al
  801113:	3c 39                	cmp    $0x39,%al
  801115:	7f 10                	jg     801127 <strtol+0xc2>
			dig = *s - '0';
  801117:	8b 45 08             	mov    0x8(%ebp),%eax
  80111a:	8a 00                	mov    (%eax),%al
  80111c:	0f be c0             	movsbl %al,%eax
  80111f:	83 e8 30             	sub    $0x30,%eax
  801122:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801125:	eb 42                	jmp    801169 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801127:	8b 45 08             	mov    0x8(%ebp),%eax
  80112a:	8a 00                	mov    (%eax),%al
  80112c:	3c 60                	cmp    $0x60,%al
  80112e:	7e 19                	jle    801149 <strtol+0xe4>
  801130:	8b 45 08             	mov    0x8(%ebp),%eax
  801133:	8a 00                	mov    (%eax),%al
  801135:	3c 7a                	cmp    $0x7a,%al
  801137:	7f 10                	jg     801149 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801139:	8b 45 08             	mov    0x8(%ebp),%eax
  80113c:	8a 00                	mov    (%eax),%al
  80113e:	0f be c0             	movsbl %al,%eax
  801141:	83 e8 57             	sub    $0x57,%eax
  801144:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801147:	eb 20                	jmp    801169 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801149:	8b 45 08             	mov    0x8(%ebp),%eax
  80114c:	8a 00                	mov    (%eax),%al
  80114e:	3c 40                	cmp    $0x40,%al
  801150:	7e 39                	jle    80118b <strtol+0x126>
  801152:	8b 45 08             	mov    0x8(%ebp),%eax
  801155:	8a 00                	mov    (%eax),%al
  801157:	3c 5a                	cmp    $0x5a,%al
  801159:	7f 30                	jg     80118b <strtol+0x126>
			dig = *s - 'A' + 10;
  80115b:	8b 45 08             	mov    0x8(%ebp),%eax
  80115e:	8a 00                	mov    (%eax),%al
  801160:	0f be c0             	movsbl %al,%eax
  801163:	83 e8 37             	sub    $0x37,%eax
  801166:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801169:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80116c:	3b 45 10             	cmp    0x10(%ebp),%eax
  80116f:	7d 19                	jge    80118a <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801171:	ff 45 08             	incl   0x8(%ebp)
  801174:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801177:	0f af 45 10          	imul   0x10(%ebp),%eax
  80117b:	89 c2                	mov    %eax,%edx
  80117d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801180:	01 d0                	add    %edx,%eax
  801182:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801185:	e9 7b ff ff ff       	jmp    801105 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  80118a:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  80118b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80118f:	74 08                	je     801199 <strtol+0x134>
		*endptr = (char *) s;
  801191:	8b 45 0c             	mov    0xc(%ebp),%eax
  801194:	8b 55 08             	mov    0x8(%ebp),%edx
  801197:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801199:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80119d:	74 07                	je     8011a6 <strtol+0x141>
  80119f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011a2:	f7 d8                	neg    %eax
  8011a4:	eb 03                	jmp    8011a9 <strtol+0x144>
  8011a6:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8011a9:	c9                   	leave  
  8011aa:	c3                   	ret    

008011ab <ltostr>:

void
ltostr(long value, char *str)
{
  8011ab:	55                   	push   %ebp
  8011ac:	89 e5                	mov    %esp,%ebp
  8011ae:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8011b1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8011b8:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8011bf:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8011c3:	79 13                	jns    8011d8 <ltostr+0x2d>
	{
		neg = 1;
  8011c5:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8011cc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011cf:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8011d2:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8011d5:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8011d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8011db:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8011e0:	99                   	cltd   
  8011e1:	f7 f9                	idiv   %ecx
  8011e3:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8011e6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011e9:	8d 50 01             	lea    0x1(%eax),%edx
  8011ec:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8011ef:	89 c2                	mov    %eax,%edx
  8011f1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011f4:	01 d0                	add    %edx,%eax
  8011f6:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8011f9:	83 c2 30             	add    $0x30,%edx
  8011fc:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8011fe:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801201:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801206:	f7 e9                	imul   %ecx
  801208:	c1 fa 02             	sar    $0x2,%edx
  80120b:	89 c8                	mov    %ecx,%eax
  80120d:	c1 f8 1f             	sar    $0x1f,%eax
  801210:	29 c2                	sub    %eax,%edx
  801212:	89 d0                	mov    %edx,%eax
  801214:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  801217:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80121b:	75 bb                	jne    8011d8 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  80121d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801224:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801227:	48                   	dec    %eax
  801228:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  80122b:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80122f:	74 3d                	je     80126e <ltostr+0xc3>
		start = 1 ;
  801231:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801238:	eb 34                	jmp    80126e <ltostr+0xc3>
	{
		char tmp = str[start] ;
  80123a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80123d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801240:	01 d0                	add    %edx,%eax
  801242:	8a 00                	mov    (%eax),%al
  801244:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801247:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80124a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80124d:	01 c2                	add    %eax,%edx
  80124f:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801252:	8b 45 0c             	mov    0xc(%ebp),%eax
  801255:	01 c8                	add    %ecx,%eax
  801257:	8a 00                	mov    (%eax),%al
  801259:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  80125b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80125e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801261:	01 c2                	add    %eax,%edx
  801263:	8a 45 eb             	mov    -0x15(%ebp),%al
  801266:	88 02                	mov    %al,(%edx)
		start++ ;
  801268:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  80126b:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  80126e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801271:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801274:	7c c4                	jl     80123a <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801276:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801279:	8b 45 0c             	mov    0xc(%ebp),%eax
  80127c:	01 d0                	add    %edx,%eax
  80127e:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801281:	90                   	nop
  801282:	c9                   	leave  
  801283:	c3                   	ret    

00801284 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801284:	55                   	push   %ebp
  801285:	89 e5                	mov    %esp,%ebp
  801287:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  80128a:	ff 75 08             	pushl  0x8(%ebp)
  80128d:	e8 c4 f9 ff ff       	call   800c56 <strlen>
  801292:	83 c4 04             	add    $0x4,%esp
  801295:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801298:	ff 75 0c             	pushl  0xc(%ebp)
  80129b:	e8 b6 f9 ff ff       	call   800c56 <strlen>
  8012a0:	83 c4 04             	add    $0x4,%esp
  8012a3:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8012a6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8012ad:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8012b4:	eb 17                	jmp    8012cd <strcconcat+0x49>
		final[s] = str1[s] ;
  8012b6:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8012b9:	8b 45 10             	mov    0x10(%ebp),%eax
  8012bc:	01 c2                	add    %eax,%edx
  8012be:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8012c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8012c4:	01 c8                	add    %ecx,%eax
  8012c6:	8a 00                	mov    (%eax),%al
  8012c8:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8012ca:	ff 45 fc             	incl   -0x4(%ebp)
  8012cd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012d0:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8012d3:	7c e1                	jl     8012b6 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8012d5:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8012dc:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8012e3:	eb 1f                	jmp    801304 <strcconcat+0x80>
		final[s++] = str2[i] ;
  8012e5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012e8:	8d 50 01             	lea    0x1(%eax),%edx
  8012eb:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8012ee:	89 c2                	mov    %eax,%edx
  8012f0:	8b 45 10             	mov    0x10(%ebp),%eax
  8012f3:	01 c2                	add    %eax,%edx
  8012f5:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8012f8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012fb:	01 c8                	add    %ecx,%eax
  8012fd:	8a 00                	mov    (%eax),%al
  8012ff:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801301:	ff 45 f8             	incl   -0x8(%ebp)
  801304:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801307:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80130a:	7c d9                	jl     8012e5 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  80130c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80130f:	8b 45 10             	mov    0x10(%ebp),%eax
  801312:	01 d0                	add    %edx,%eax
  801314:	c6 00 00             	movb   $0x0,(%eax)
}
  801317:	90                   	nop
  801318:	c9                   	leave  
  801319:	c3                   	ret    

0080131a <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  80131a:	55                   	push   %ebp
  80131b:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  80131d:	8b 45 14             	mov    0x14(%ebp),%eax
  801320:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801326:	8b 45 14             	mov    0x14(%ebp),%eax
  801329:	8b 00                	mov    (%eax),%eax
  80132b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801332:	8b 45 10             	mov    0x10(%ebp),%eax
  801335:	01 d0                	add    %edx,%eax
  801337:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80133d:	eb 0c                	jmp    80134b <strsplit+0x31>
			*string++ = 0;
  80133f:	8b 45 08             	mov    0x8(%ebp),%eax
  801342:	8d 50 01             	lea    0x1(%eax),%edx
  801345:	89 55 08             	mov    %edx,0x8(%ebp)
  801348:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80134b:	8b 45 08             	mov    0x8(%ebp),%eax
  80134e:	8a 00                	mov    (%eax),%al
  801350:	84 c0                	test   %al,%al
  801352:	74 18                	je     80136c <strsplit+0x52>
  801354:	8b 45 08             	mov    0x8(%ebp),%eax
  801357:	8a 00                	mov    (%eax),%al
  801359:	0f be c0             	movsbl %al,%eax
  80135c:	50                   	push   %eax
  80135d:	ff 75 0c             	pushl  0xc(%ebp)
  801360:	e8 83 fa ff ff       	call   800de8 <strchr>
  801365:	83 c4 08             	add    $0x8,%esp
  801368:	85 c0                	test   %eax,%eax
  80136a:	75 d3                	jne    80133f <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  80136c:	8b 45 08             	mov    0x8(%ebp),%eax
  80136f:	8a 00                	mov    (%eax),%al
  801371:	84 c0                	test   %al,%al
  801373:	74 5a                	je     8013cf <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801375:	8b 45 14             	mov    0x14(%ebp),%eax
  801378:	8b 00                	mov    (%eax),%eax
  80137a:	83 f8 0f             	cmp    $0xf,%eax
  80137d:	75 07                	jne    801386 <strsplit+0x6c>
		{
			return 0;
  80137f:	b8 00 00 00 00       	mov    $0x0,%eax
  801384:	eb 66                	jmp    8013ec <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801386:	8b 45 14             	mov    0x14(%ebp),%eax
  801389:	8b 00                	mov    (%eax),%eax
  80138b:	8d 48 01             	lea    0x1(%eax),%ecx
  80138e:	8b 55 14             	mov    0x14(%ebp),%edx
  801391:	89 0a                	mov    %ecx,(%edx)
  801393:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80139a:	8b 45 10             	mov    0x10(%ebp),%eax
  80139d:	01 c2                	add    %eax,%edx
  80139f:	8b 45 08             	mov    0x8(%ebp),%eax
  8013a2:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8013a4:	eb 03                	jmp    8013a9 <strsplit+0x8f>
			string++;
  8013a6:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8013a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8013ac:	8a 00                	mov    (%eax),%al
  8013ae:	84 c0                	test   %al,%al
  8013b0:	74 8b                	je     80133d <strsplit+0x23>
  8013b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8013b5:	8a 00                	mov    (%eax),%al
  8013b7:	0f be c0             	movsbl %al,%eax
  8013ba:	50                   	push   %eax
  8013bb:	ff 75 0c             	pushl  0xc(%ebp)
  8013be:	e8 25 fa ff ff       	call   800de8 <strchr>
  8013c3:	83 c4 08             	add    $0x8,%esp
  8013c6:	85 c0                	test   %eax,%eax
  8013c8:	74 dc                	je     8013a6 <strsplit+0x8c>
			string++;
	}
  8013ca:	e9 6e ff ff ff       	jmp    80133d <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8013cf:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8013d0:	8b 45 14             	mov    0x14(%ebp),%eax
  8013d3:	8b 00                	mov    (%eax),%eax
  8013d5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8013dc:	8b 45 10             	mov    0x10(%ebp),%eax
  8013df:	01 d0                	add    %edx,%eax
  8013e1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8013e7:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8013ec:	c9                   	leave  
  8013ed:	c3                   	ret    

008013ee <str2lower>:


char* str2lower(char *dst, const char *src)
{
  8013ee:	55                   	push   %ebp
  8013ef:	89 e5                	mov    %esp,%ebp
  8013f1:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  8013f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8013f7:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  8013fa:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801401:	eb 4a                	jmp    80144d <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  801403:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801406:	8b 45 08             	mov    0x8(%ebp),%eax
  801409:	01 c2                	add    %eax,%edx
  80140b:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80140e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801411:	01 c8                	add    %ecx,%eax
  801413:	8a 00                	mov    (%eax),%al
  801415:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  801417:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80141a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80141d:	01 d0                	add    %edx,%eax
  80141f:	8a 00                	mov    (%eax),%al
  801421:	3c 40                	cmp    $0x40,%al
  801423:	7e 25                	jle    80144a <str2lower+0x5c>
  801425:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801428:	8b 45 0c             	mov    0xc(%ebp),%eax
  80142b:	01 d0                	add    %edx,%eax
  80142d:	8a 00                	mov    (%eax),%al
  80142f:	3c 5a                	cmp    $0x5a,%al
  801431:	7f 17                	jg     80144a <str2lower+0x5c>
		{
			dst[i] += 32 ;
  801433:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801436:	8b 45 08             	mov    0x8(%ebp),%eax
  801439:	01 d0                	add    %edx,%eax
  80143b:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80143e:	8b 55 08             	mov    0x8(%ebp),%edx
  801441:	01 ca                	add    %ecx,%edx
  801443:	8a 12                	mov    (%edx),%dl
  801445:	83 c2 20             	add    $0x20,%edx
  801448:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  80144a:	ff 45 fc             	incl   -0x4(%ebp)
  80144d:	ff 75 0c             	pushl  0xc(%ebp)
  801450:	e8 01 f8 ff ff       	call   800c56 <strlen>
  801455:	83 c4 04             	add    $0x4,%esp
  801458:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80145b:	7f a6                	jg     801403 <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  80145d:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801460:	c9                   	leave  
  801461:	c3                   	ret    

00801462 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801462:	55                   	push   %ebp
  801463:	89 e5                	mov    %esp,%ebp
  801465:	57                   	push   %edi
  801466:	56                   	push   %esi
  801467:	53                   	push   %ebx
  801468:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80146b:	8b 45 08             	mov    0x8(%ebp),%eax
  80146e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801471:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801474:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801477:	8b 7d 18             	mov    0x18(%ebp),%edi
  80147a:	8b 75 1c             	mov    0x1c(%ebp),%esi
  80147d:	cd 30                	int    $0x30
  80147f:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  801482:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801485:	83 c4 10             	add    $0x10,%esp
  801488:	5b                   	pop    %ebx
  801489:	5e                   	pop    %esi
  80148a:	5f                   	pop    %edi
  80148b:	5d                   	pop    %ebp
  80148c:	c3                   	ret    

0080148d <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  80148d:	55                   	push   %ebp
  80148e:	89 e5                	mov    %esp,%ebp
  801490:	83 ec 04             	sub    $0x4,%esp
  801493:	8b 45 10             	mov    0x10(%ebp),%eax
  801496:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  801499:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80149c:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8014a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8014a3:	6a 00                	push   $0x0
  8014a5:	51                   	push   %ecx
  8014a6:	52                   	push   %edx
  8014a7:	ff 75 0c             	pushl  0xc(%ebp)
  8014aa:	50                   	push   %eax
  8014ab:	6a 00                	push   $0x0
  8014ad:	e8 b0 ff ff ff       	call   801462 <syscall>
  8014b2:	83 c4 18             	add    $0x18,%esp
}
  8014b5:	90                   	nop
  8014b6:	c9                   	leave  
  8014b7:	c3                   	ret    

008014b8 <sys_cgetc>:

int
sys_cgetc(void)
{
  8014b8:	55                   	push   %ebp
  8014b9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8014bb:	6a 00                	push   $0x0
  8014bd:	6a 00                	push   $0x0
  8014bf:	6a 00                	push   $0x0
  8014c1:	6a 00                	push   $0x0
  8014c3:	6a 00                	push   $0x0
  8014c5:	6a 02                	push   $0x2
  8014c7:	e8 96 ff ff ff       	call   801462 <syscall>
  8014cc:	83 c4 18             	add    $0x18,%esp
}
  8014cf:	c9                   	leave  
  8014d0:	c3                   	ret    

008014d1 <sys_lock_cons>:

void sys_lock_cons(void)
{
  8014d1:	55                   	push   %ebp
  8014d2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  8014d4:	6a 00                	push   $0x0
  8014d6:	6a 00                	push   $0x0
  8014d8:	6a 00                	push   $0x0
  8014da:	6a 00                	push   $0x0
  8014dc:	6a 00                	push   $0x0
  8014de:	6a 03                	push   $0x3
  8014e0:	e8 7d ff ff ff       	call   801462 <syscall>
  8014e5:	83 c4 18             	add    $0x18,%esp
}
  8014e8:	90                   	nop
  8014e9:	c9                   	leave  
  8014ea:	c3                   	ret    

008014eb <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  8014eb:	55                   	push   %ebp
  8014ec:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  8014ee:	6a 00                	push   $0x0
  8014f0:	6a 00                	push   $0x0
  8014f2:	6a 00                	push   $0x0
  8014f4:	6a 00                	push   $0x0
  8014f6:	6a 00                	push   $0x0
  8014f8:	6a 04                	push   $0x4
  8014fa:	e8 63 ff ff ff       	call   801462 <syscall>
  8014ff:	83 c4 18             	add    $0x18,%esp
}
  801502:	90                   	nop
  801503:	c9                   	leave  
  801504:	c3                   	ret    

00801505 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801505:	55                   	push   %ebp
  801506:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801508:	8b 55 0c             	mov    0xc(%ebp),%edx
  80150b:	8b 45 08             	mov    0x8(%ebp),%eax
  80150e:	6a 00                	push   $0x0
  801510:	6a 00                	push   $0x0
  801512:	6a 00                	push   $0x0
  801514:	52                   	push   %edx
  801515:	50                   	push   %eax
  801516:	6a 08                	push   $0x8
  801518:	e8 45 ff ff ff       	call   801462 <syscall>
  80151d:	83 c4 18             	add    $0x18,%esp
}
  801520:	c9                   	leave  
  801521:	c3                   	ret    

00801522 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801522:	55                   	push   %ebp
  801523:	89 e5                	mov    %esp,%ebp
  801525:	56                   	push   %esi
  801526:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801527:	8b 75 18             	mov    0x18(%ebp),%esi
  80152a:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80152d:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801530:	8b 55 0c             	mov    0xc(%ebp),%edx
  801533:	8b 45 08             	mov    0x8(%ebp),%eax
  801536:	56                   	push   %esi
  801537:	53                   	push   %ebx
  801538:	51                   	push   %ecx
  801539:	52                   	push   %edx
  80153a:	50                   	push   %eax
  80153b:	6a 09                	push   $0x9
  80153d:	e8 20 ff ff ff       	call   801462 <syscall>
  801542:	83 c4 18             	add    $0x18,%esp
}
  801545:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801548:	5b                   	pop    %ebx
  801549:	5e                   	pop    %esi
  80154a:	5d                   	pop    %ebp
  80154b:	c3                   	ret    

0080154c <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  80154c:	55                   	push   %ebp
  80154d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  80154f:	6a 00                	push   $0x0
  801551:	6a 00                	push   $0x0
  801553:	6a 00                	push   $0x0
  801555:	6a 00                	push   $0x0
  801557:	ff 75 08             	pushl  0x8(%ebp)
  80155a:	6a 0a                	push   $0xa
  80155c:	e8 01 ff ff ff       	call   801462 <syscall>
  801561:	83 c4 18             	add    $0x18,%esp
}
  801564:	c9                   	leave  
  801565:	c3                   	ret    

00801566 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801566:	55                   	push   %ebp
  801567:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801569:	6a 00                	push   $0x0
  80156b:	6a 00                	push   $0x0
  80156d:	6a 00                	push   $0x0
  80156f:	ff 75 0c             	pushl  0xc(%ebp)
  801572:	ff 75 08             	pushl  0x8(%ebp)
  801575:	6a 0b                	push   $0xb
  801577:	e8 e6 fe ff ff       	call   801462 <syscall>
  80157c:	83 c4 18             	add    $0x18,%esp
}
  80157f:	c9                   	leave  
  801580:	c3                   	ret    

00801581 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801581:	55                   	push   %ebp
  801582:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801584:	6a 00                	push   $0x0
  801586:	6a 00                	push   $0x0
  801588:	6a 00                	push   $0x0
  80158a:	6a 00                	push   $0x0
  80158c:	6a 00                	push   $0x0
  80158e:	6a 0c                	push   $0xc
  801590:	e8 cd fe ff ff       	call   801462 <syscall>
  801595:	83 c4 18             	add    $0x18,%esp
}
  801598:	c9                   	leave  
  801599:	c3                   	ret    

0080159a <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  80159a:	55                   	push   %ebp
  80159b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  80159d:	6a 00                	push   $0x0
  80159f:	6a 00                	push   $0x0
  8015a1:	6a 00                	push   $0x0
  8015a3:	6a 00                	push   $0x0
  8015a5:	6a 00                	push   $0x0
  8015a7:	6a 0d                	push   $0xd
  8015a9:	e8 b4 fe ff ff       	call   801462 <syscall>
  8015ae:	83 c4 18             	add    $0x18,%esp
}
  8015b1:	c9                   	leave  
  8015b2:	c3                   	ret    

008015b3 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8015b3:	55                   	push   %ebp
  8015b4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8015b6:	6a 00                	push   $0x0
  8015b8:	6a 00                	push   $0x0
  8015ba:	6a 00                	push   $0x0
  8015bc:	6a 00                	push   $0x0
  8015be:	6a 00                	push   $0x0
  8015c0:	6a 0e                	push   $0xe
  8015c2:	e8 9b fe ff ff       	call   801462 <syscall>
  8015c7:	83 c4 18             	add    $0x18,%esp
}
  8015ca:	c9                   	leave  
  8015cb:	c3                   	ret    

008015cc <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8015cc:	55                   	push   %ebp
  8015cd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8015cf:	6a 00                	push   $0x0
  8015d1:	6a 00                	push   $0x0
  8015d3:	6a 00                	push   $0x0
  8015d5:	6a 00                	push   $0x0
  8015d7:	6a 00                	push   $0x0
  8015d9:	6a 0f                	push   $0xf
  8015db:	e8 82 fe ff ff       	call   801462 <syscall>
  8015e0:	83 c4 18             	add    $0x18,%esp
}
  8015e3:	c9                   	leave  
  8015e4:	c3                   	ret    

008015e5 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8015e5:	55                   	push   %ebp
  8015e6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8015e8:	6a 00                	push   $0x0
  8015ea:	6a 00                	push   $0x0
  8015ec:	6a 00                	push   $0x0
  8015ee:	6a 00                	push   $0x0
  8015f0:	ff 75 08             	pushl  0x8(%ebp)
  8015f3:	6a 10                	push   $0x10
  8015f5:	e8 68 fe ff ff       	call   801462 <syscall>
  8015fa:	83 c4 18             	add    $0x18,%esp
}
  8015fd:	c9                   	leave  
  8015fe:	c3                   	ret    

008015ff <sys_scarce_memory>:

void sys_scarce_memory()
{
  8015ff:	55                   	push   %ebp
  801600:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801602:	6a 00                	push   $0x0
  801604:	6a 00                	push   $0x0
  801606:	6a 00                	push   $0x0
  801608:	6a 00                	push   $0x0
  80160a:	6a 00                	push   $0x0
  80160c:	6a 11                	push   $0x11
  80160e:	e8 4f fe ff ff       	call   801462 <syscall>
  801613:	83 c4 18             	add    $0x18,%esp
}
  801616:	90                   	nop
  801617:	c9                   	leave  
  801618:	c3                   	ret    

00801619 <sys_cputc>:

void
sys_cputc(const char c)
{
  801619:	55                   	push   %ebp
  80161a:	89 e5                	mov    %esp,%ebp
  80161c:	83 ec 04             	sub    $0x4,%esp
  80161f:	8b 45 08             	mov    0x8(%ebp),%eax
  801622:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801625:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801629:	6a 00                	push   $0x0
  80162b:	6a 00                	push   $0x0
  80162d:	6a 00                	push   $0x0
  80162f:	6a 00                	push   $0x0
  801631:	50                   	push   %eax
  801632:	6a 01                	push   $0x1
  801634:	e8 29 fe ff ff       	call   801462 <syscall>
  801639:	83 c4 18             	add    $0x18,%esp
}
  80163c:	90                   	nop
  80163d:	c9                   	leave  
  80163e:	c3                   	ret    

0080163f <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  80163f:	55                   	push   %ebp
  801640:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801642:	6a 00                	push   $0x0
  801644:	6a 00                	push   $0x0
  801646:	6a 00                	push   $0x0
  801648:	6a 00                	push   $0x0
  80164a:	6a 00                	push   $0x0
  80164c:	6a 14                	push   $0x14
  80164e:	e8 0f fe ff ff       	call   801462 <syscall>
  801653:	83 c4 18             	add    $0x18,%esp
}
  801656:	90                   	nop
  801657:	c9                   	leave  
  801658:	c3                   	ret    

00801659 <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801659:	55                   	push   %ebp
  80165a:	89 e5                	mov    %esp,%ebp
  80165c:	83 ec 04             	sub    $0x4,%esp
  80165f:	8b 45 10             	mov    0x10(%ebp),%eax
  801662:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801665:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801668:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80166c:	8b 45 08             	mov    0x8(%ebp),%eax
  80166f:	6a 00                	push   $0x0
  801671:	51                   	push   %ecx
  801672:	52                   	push   %edx
  801673:	ff 75 0c             	pushl  0xc(%ebp)
  801676:	50                   	push   %eax
  801677:	6a 15                	push   $0x15
  801679:	e8 e4 fd ff ff       	call   801462 <syscall>
  80167e:	83 c4 18             	add    $0x18,%esp
}
  801681:	c9                   	leave  
  801682:	c3                   	ret    

00801683 <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  801683:	55                   	push   %ebp
  801684:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801686:	8b 55 0c             	mov    0xc(%ebp),%edx
  801689:	8b 45 08             	mov    0x8(%ebp),%eax
  80168c:	6a 00                	push   $0x0
  80168e:	6a 00                	push   $0x0
  801690:	6a 00                	push   $0x0
  801692:	52                   	push   %edx
  801693:	50                   	push   %eax
  801694:	6a 16                	push   $0x16
  801696:	e8 c7 fd ff ff       	call   801462 <syscall>
  80169b:	83 c4 18             	add    $0x18,%esp
}
  80169e:	c9                   	leave  
  80169f:	c3                   	ret    

008016a0 <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  8016a0:	55                   	push   %ebp
  8016a1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8016a3:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8016a6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8016ac:	6a 00                	push   $0x0
  8016ae:	6a 00                	push   $0x0
  8016b0:	51                   	push   %ecx
  8016b1:	52                   	push   %edx
  8016b2:	50                   	push   %eax
  8016b3:	6a 17                	push   $0x17
  8016b5:	e8 a8 fd ff ff       	call   801462 <syscall>
  8016ba:	83 c4 18             	add    $0x18,%esp
}
  8016bd:	c9                   	leave  
  8016be:	c3                   	ret    

008016bf <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  8016bf:	55                   	push   %ebp
  8016c0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8016c2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8016c8:	6a 00                	push   $0x0
  8016ca:	6a 00                	push   $0x0
  8016cc:	6a 00                	push   $0x0
  8016ce:	52                   	push   %edx
  8016cf:	50                   	push   %eax
  8016d0:	6a 18                	push   $0x18
  8016d2:	e8 8b fd ff ff       	call   801462 <syscall>
  8016d7:	83 c4 18             	add    $0x18,%esp
}
  8016da:	c9                   	leave  
  8016db:	c3                   	ret    

008016dc <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8016dc:	55                   	push   %ebp
  8016dd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8016df:	8b 45 08             	mov    0x8(%ebp),%eax
  8016e2:	6a 00                	push   $0x0
  8016e4:	ff 75 14             	pushl  0x14(%ebp)
  8016e7:	ff 75 10             	pushl  0x10(%ebp)
  8016ea:	ff 75 0c             	pushl  0xc(%ebp)
  8016ed:	50                   	push   %eax
  8016ee:	6a 19                	push   $0x19
  8016f0:	e8 6d fd ff ff       	call   801462 <syscall>
  8016f5:	83 c4 18             	add    $0x18,%esp
}
  8016f8:	c9                   	leave  
  8016f9:	c3                   	ret    

008016fa <sys_run_env>:

void sys_run_env(int32 envId)
{
  8016fa:	55                   	push   %ebp
  8016fb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8016fd:	8b 45 08             	mov    0x8(%ebp),%eax
  801700:	6a 00                	push   $0x0
  801702:	6a 00                	push   $0x0
  801704:	6a 00                	push   $0x0
  801706:	6a 00                	push   $0x0
  801708:	50                   	push   %eax
  801709:	6a 1a                	push   $0x1a
  80170b:	e8 52 fd ff ff       	call   801462 <syscall>
  801710:	83 c4 18             	add    $0x18,%esp
}
  801713:	90                   	nop
  801714:	c9                   	leave  
  801715:	c3                   	ret    

00801716 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801716:	55                   	push   %ebp
  801717:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801719:	8b 45 08             	mov    0x8(%ebp),%eax
  80171c:	6a 00                	push   $0x0
  80171e:	6a 00                	push   $0x0
  801720:	6a 00                	push   $0x0
  801722:	6a 00                	push   $0x0
  801724:	50                   	push   %eax
  801725:	6a 1b                	push   $0x1b
  801727:	e8 36 fd ff ff       	call   801462 <syscall>
  80172c:	83 c4 18             	add    $0x18,%esp
}
  80172f:	c9                   	leave  
  801730:	c3                   	ret    

00801731 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801731:	55                   	push   %ebp
  801732:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801734:	6a 00                	push   $0x0
  801736:	6a 00                	push   $0x0
  801738:	6a 00                	push   $0x0
  80173a:	6a 00                	push   $0x0
  80173c:	6a 00                	push   $0x0
  80173e:	6a 05                	push   $0x5
  801740:	e8 1d fd ff ff       	call   801462 <syscall>
  801745:	83 c4 18             	add    $0x18,%esp
}
  801748:	c9                   	leave  
  801749:	c3                   	ret    

0080174a <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  80174a:	55                   	push   %ebp
  80174b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  80174d:	6a 00                	push   $0x0
  80174f:	6a 00                	push   $0x0
  801751:	6a 00                	push   $0x0
  801753:	6a 00                	push   $0x0
  801755:	6a 00                	push   $0x0
  801757:	6a 06                	push   $0x6
  801759:	e8 04 fd ff ff       	call   801462 <syscall>
  80175e:	83 c4 18             	add    $0x18,%esp
}
  801761:	c9                   	leave  
  801762:	c3                   	ret    

00801763 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801763:	55                   	push   %ebp
  801764:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801766:	6a 00                	push   $0x0
  801768:	6a 00                	push   $0x0
  80176a:	6a 00                	push   $0x0
  80176c:	6a 00                	push   $0x0
  80176e:	6a 00                	push   $0x0
  801770:	6a 07                	push   $0x7
  801772:	e8 eb fc ff ff       	call   801462 <syscall>
  801777:	83 c4 18             	add    $0x18,%esp
}
  80177a:	c9                   	leave  
  80177b:	c3                   	ret    

0080177c <sys_exit_env>:


void sys_exit_env(void)
{
  80177c:	55                   	push   %ebp
  80177d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  80177f:	6a 00                	push   $0x0
  801781:	6a 00                	push   $0x0
  801783:	6a 00                	push   $0x0
  801785:	6a 00                	push   $0x0
  801787:	6a 00                	push   $0x0
  801789:	6a 1c                	push   $0x1c
  80178b:	e8 d2 fc ff ff       	call   801462 <syscall>
  801790:	83 c4 18             	add    $0x18,%esp
}
  801793:	90                   	nop
  801794:	c9                   	leave  
  801795:	c3                   	ret    

00801796 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  801796:	55                   	push   %ebp
  801797:	89 e5                	mov    %esp,%ebp
  801799:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  80179c:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80179f:	8d 50 04             	lea    0x4(%eax),%edx
  8017a2:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8017a5:	6a 00                	push   $0x0
  8017a7:	6a 00                	push   $0x0
  8017a9:	6a 00                	push   $0x0
  8017ab:	52                   	push   %edx
  8017ac:	50                   	push   %eax
  8017ad:	6a 1d                	push   $0x1d
  8017af:	e8 ae fc ff ff       	call   801462 <syscall>
  8017b4:	83 c4 18             	add    $0x18,%esp
	return result;
  8017b7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8017ba:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8017bd:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8017c0:	89 01                	mov    %eax,(%ecx)
  8017c2:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8017c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8017c8:	c9                   	leave  
  8017c9:	c2 04 00             	ret    $0x4

008017cc <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8017cc:	55                   	push   %ebp
  8017cd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8017cf:	6a 00                	push   $0x0
  8017d1:	6a 00                	push   $0x0
  8017d3:	ff 75 10             	pushl  0x10(%ebp)
  8017d6:	ff 75 0c             	pushl  0xc(%ebp)
  8017d9:	ff 75 08             	pushl  0x8(%ebp)
  8017dc:	6a 13                	push   $0x13
  8017de:	e8 7f fc ff ff       	call   801462 <syscall>
  8017e3:	83 c4 18             	add    $0x18,%esp
	return ;
  8017e6:	90                   	nop
}
  8017e7:	c9                   	leave  
  8017e8:	c3                   	ret    

008017e9 <sys_rcr2>:
uint32 sys_rcr2()
{
  8017e9:	55                   	push   %ebp
  8017ea:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8017ec:	6a 00                	push   $0x0
  8017ee:	6a 00                	push   $0x0
  8017f0:	6a 00                	push   $0x0
  8017f2:	6a 00                	push   $0x0
  8017f4:	6a 00                	push   $0x0
  8017f6:	6a 1e                	push   $0x1e
  8017f8:	e8 65 fc ff ff       	call   801462 <syscall>
  8017fd:	83 c4 18             	add    $0x18,%esp
}
  801800:	c9                   	leave  
  801801:	c3                   	ret    

00801802 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  801802:	55                   	push   %ebp
  801803:	89 e5                	mov    %esp,%ebp
  801805:	83 ec 04             	sub    $0x4,%esp
  801808:	8b 45 08             	mov    0x8(%ebp),%eax
  80180b:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  80180e:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801812:	6a 00                	push   $0x0
  801814:	6a 00                	push   $0x0
  801816:	6a 00                	push   $0x0
  801818:	6a 00                	push   $0x0
  80181a:	50                   	push   %eax
  80181b:	6a 1f                	push   $0x1f
  80181d:	e8 40 fc ff ff       	call   801462 <syscall>
  801822:	83 c4 18             	add    $0x18,%esp
	return ;
  801825:	90                   	nop
}
  801826:	c9                   	leave  
  801827:	c3                   	ret    

00801828 <rsttst>:
void rsttst()
{
  801828:	55                   	push   %ebp
  801829:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  80182b:	6a 00                	push   $0x0
  80182d:	6a 00                	push   $0x0
  80182f:	6a 00                	push   $0x0
  801831:	6a 00                	push   $0x0
  801833:	6a 00                	push   $0x0
  801835:	6a 21                	push   $0x21
  801837:	e8 26 fc ff ff       	call   801462 <syscall>
  80183c:	83 c4 18             	add    $0x18,%esp
	return ;
  80183f:	90                   	nop
}
  801840:	c9                   	leave  
  801841:	c3                   	ret    

00801842 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801842:	55                   	push   %ebp
  801843:	89 e5                	mov    %esp,%ebp
  801845:	83 ec 04             	sub    $0x4,%esp
  801848:	8b 45 14             	mov    0x14(%ebp),%eax
  80184b:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  80184e:	8b 55 18             	mov    0x18(%ebp),%edx
  801851:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801855:	52                   	push   %edx
  801856:	50                   	push   %eax
  801857:	ff 75 10             	pushl  0x10(%ebp)
  80185a:	ff 75 0c             	pushl  0xc(%ebp)
  80185d:	ff 75 08             	pushl  0x8(%ebp)
  801860:	6a 20                	push   $0x20
  801862:	e8 fb fb ff ff       	call   801462 <syscall>
  801867:	83 c4 18             	add    $0x18,%esp
	return ;
  80186a:	90                   	nop
}
  80186b:	c9                   	leave  
  80186c:	c3                   	ret    

0080186d <chktst>:
void chktst(uint32 n)
{
  80186d:	55                   	push   %ebp
  80186e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801870:	6a 00                	push   $0x0
  801872:	6a 00                	push   $0x0
  801874:	6a 00                	push   $0x0
  801876:	6a 00                	push   $0x0
  801878:	ff 75 08             	pushl  0x8(%ebp)
  80187b:	6a 22                	push   $0x22
  80187d:	e8 e0 fb ff ff       	call   801462 <syscall>
  801882:	83 c4 18             	add    $0x18,%esp
	return ;
  801885:	90                   	nop
}
  801886:	c9                   	leave  
  801887:	c3                   	ret    

00801888 <inctst>:

void inctst()
{
  801888:	55                   	push   %ebp
  801889:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  80188b:	6a 00                	push   $0x0
  80188d:	6a 00                	push   $0x0
  80188f:	6a 00                	push   $0x0
  801891:	6a 00                	push   $0x0
  801893:	6a 00                	push   $0x0
  801895:	6a 23                	push   $0x23
  801897:	e8 c6 fb ff ff       	call   801462 <syscall>
  80189c:	83 c4 18             	add    $0x18,%esp
	return ;
  80189f:	90                   	nop
}
  8018a0:	c9                   	leave  
  8018a1:	c3                   	ret    

008018a2 <gettst>:
uint32 gettst()
{
  8018a2:	55                   	push   %ebp
  8018a3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8018a5:	6a 00                	push   $0x0
  8018a7:	6a 00                	push   $0x0
  8018a9:	6a 00                	push   $0x0
  8018ab:	6a 00                	push   $0x0
  8018ad:	6a 00                	push   $0x0
  8018af:	6a 24                	push   $0x24
  8018b1:	e8 ac fb ff ff       	call   801462 <syscall>
  8018b6:	83 c4 18             	add    $0x18,%esp
}
  8018b9:	c9                   	leave  
  8018ba:	c3                   	ret    

008018bb <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  8018bb:	55                   	push   %ebp
  8018bc:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8018be:	6a 00                	push   $0x0
  8018c0:	6a 00                	push   $0x0
  8018c2:	6a 00                	push   $0x0
  8018c4:	6a 00                	push   $0x0
  8018c6:	6a 00                	push   $0x0
  8018c8:	6a 25                	push   $0x25
  8018ca:	e8 93 fb ff ff       	call   801462 <syscall>
  8018cf:	83 c4 18             	add    $0x18,%esp
  8018d2:	a3 60 b0 81 00       	mov    %eax,0x81b060
	return uheapPlaceStrategy ;
  8018d7:	a1 60 b0 81 00       	mov    0x81b060,%eax
}
  8018dc:	c9                   	leave  
  8018dd:	c3                   	ret    

008018de <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  8018de:	55                   	push   %ebp
  8018df:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  8018e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8018e4:	a3 60 b0 81 00       	mov    %eax,0x81b060
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  8018e9:	6a 00                	push   $0x0
  8018eb:	6a 00                	push   $0x0
  8018ed:	6a 00                	push   $0x0
  8018ef:	6a 00                	push   $0x0
  8018f1:	ff 75 08             	pushl  0x8(%ebp)
  8018f4:	6a 26                	push   $0x26
  8018f6:	e8 67 fb ff ff       	call   801462 <syscall>
  8018fb:	83 c4 18             	add    $0x18,%esp
	return ;
  8018fe:	90                   	nop
}
  8018ff:	c9                   	leave  
  801900:	c3                   	ret    

00801901 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801901:	55                   	push   %ebp
  801902:	89 e5                	mov    %esp,%ebp
  801904:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801905:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801908:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80190b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80190e:	8b 45 08             	mov    0x8(%ebp),%eax
  801911:	6a 00                	push   $0x0
  801913:	53                   	push   %ebx
  801914:	51                   	push   %ecx
  801915:	52                   	push   %edx
  801916:	50                   	push   %eax
  801917:	6a 27                	push   $0x27
  801919:	e8 44 fb ff ff       	call   801462 <syscall>
  80191e:	83 c4 18             	add    $0x18,%esp
}
  801921:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801924:	c9                   	leave  
  801925:	c3                   	ret    

00801926 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801926:	55                   	push   %ebp
  801927:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801929:	8b 55 0c             	mov    0xc(%ebp),%edx
  80192c:	8b 45 08             	mov    0x8(%ebp),%eax
  80192f:	6a 00                	push   $0x0
  801931:	6a 00                	push   $0x0
  801933:	6a 00                	push   $0x0
  801935:	52                   	push   %edx
  801936:	50                   	push   %eax
  801937:	6a 28                	push   $0x28
  801939:	e8 24 fb ff ff       	call   801462 <syscall>
  80193e:	83 c4 18             	add    $0x18,%esp
}
  801941:	c9                   	leave  
  801942:	c3                   	ret    

00801943 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801943:	55                   	push   %ebp
  801944:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801946:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801949:	8b 55 0c             	mov    0xc(%ebp),%edx
  80194c:	8b 45 08             	mov    0x8(%ebp),%eax
  80194f:	6a 00                	push   $0x0
  801951:	51                   	push   %ecx
  801952:	ff 75 10             	pushl  0x10(%ebp)
  801955:	52                   	push   %edx
  801956:	50                   	push   %eax
  801957:	6a 29                	push   $0x29
  801959:	e8 04 fb ff ff       	call   801462 <syscall>
  80195e:	83 c4 18             	add    $0x18,%esp
}
  801961:	c9                   	leave  
  801962:	c3                   	ret    

00801963 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801963:	55                   	push   %ebp
  801964:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801966:	6a 00                	push   $0x0
  801968:	6a 00                	push   $0x0
  80196a:	ff 75 10             	pushl  0x10(%ebp)
  80196d:	ff 75 0c             	pushl  0xc(%ebp)
  801970:	ff 75 08             	pushl  0x8(%ebp)
  801973:	6a 12                	push   $0x12
  801975:	e8 e8 fa ff ff       	call   801462 <syscall>
  80197a:	83 c4 18             	add    $0x18,%esp
	return ;
  80197d:	90                   	nop
}
  80197e:	c9                   	leave  
  80197f:	c3                   	ret    

00801980 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  801980:	55                   	push   %ebp
  801981:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  801983:	8b 55 0c             	mov    0xc(%ebp),%edx
  801986:	8b 45 08             	mov    0x8(%ebp),%eax
  801989:	6a 00                	push   $0x0
  80198b:	6a 00                	push   $0x0
  80198d:	6a 00                	push   $0x0
  80198f:	52                   	push   %edx
  801990:	50                   	push   %eax
  801991:	6a 2a                	push   $0x2a
  801993:	e8 ca fa ff ff       	call   801462 <syscall>
  801998:	83 c4 18             	add    $0x18,%esp
	return;
  80199b:	90                   	nop
}
  80199c:	c9                   	leave  
  80199d:	c3                   	ret    

0080199e <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  80199e:	55                   	push   %ebp
  80199f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  8019a1:	6a 00                	push   $0x0
  8019a3:	6a 00                	push   $0x0
  8019a5:	6a 00                	push   $0x0
  8019a7:	6a 00                	push   $0x0
  8019a9:	6a 00                	push   $0x0
  8019ab:	6a 2b                	push   $0x2b
  8019ad:	e8 b0 fa ff ff       	call   801462 <syscall>
  8019b2:	83 c4 18             	add    $0x18,%esp
}
  8019b5:	c9                   	leave  
  8019b6:	c3                   	ret    

008019b7 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8019b7:	55                   	push   %ebp
  8019b8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  8019ba:	6a 00                	push   $0x0
  8019bc:	6a 00                	push   $0x0
  8019be:	6a 00                	push   $0x0
  8019c0:	ff 75 0c             	pushl  0xc(%ebp)
  8019c3:	ff 75 08             	pushl  0x8(%ebp)
  8019c6:	6a 2d                	push   $0x2d
  8019c8:	e8 95 fa ff ff       	call   801462 <syscall>
  8019cd:	83 c4 18             	add    $0x18,%esp
	return;
  8019d0:	90                   	nop
}
  8019d1:	c9                   	leave  
  8019d2:	c3                   	ret    

008019d3 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8019d3:	55                   	push   %ebp
  8019d4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  8019d6:	6a 00                	push   $0x0
  8019d8:	6a 00                	push   $0x0
  8019da:	6a 00                	push   $0x0
  8019dc:	ff 75 0c             	pushl  0xc(%ebp)
  8019df:	ff 75 08             	pushl  0x8(%ebp)
  8019e2:	6a 2c                	push   $0x2c
  8019e4:	e8 79 fa ff ff       	call   801462 <syscall>
  8019e9:	83 c4 18             	add    $0x18,%esp
	return ;
  8019ec:	90                   	nop
}
  8019ed:	c9                   	leave  
  8019ee:	c3                   	ret    

008019ef <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  8019ef:	55                   	push   %ebp
  8019f0:	89 e5                	mov    %esp,%ebp
	//TODO: [PROJECT'25.IM#4] CPU SCHEDULING - #1 System Calls - Add suitable code here
	//Your code is here
	//Comment the following line
	//panic("sys_env_set_priority() is not implemented yet...!!");
	syscall(SYS_env_set_priority, envID, priority, 0, 0, 0);
  8019f2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8019f8:	6a 00                	push   $0x0
  8019fa:	6a 00                	push   $0x0
  8019fc:	6a 00                	push   $0x0
  8019fe:	52                   	push   %edx
  8019ff:	50                   	push   %eax
  801a00:	6a 2e                	push   $0x2e
  801a02:	e8 5b fa ff ff       	call   801462 <syscall>
  801a07:	83 c4 18             	add    $0x18,%esp
	    return;
  801a0a:	90                   	nop
}
  801a0b:	c9                   	leave  
  801a0c:	c3                   	ret    
  801a0d:	66 90                	xchg   %ax,%ax
  801a0f:	90                   	nop

00801a10 <__udivdi3>:
  801a10:	55                   	push   %ebp
  801a11:	57                   	push   %edi
  801a12:	56                   	push   %esi
  801a13:	53                   	push   %ebx
  801a14:	83 ec 1c             	sub    $0x1c,%esp
  801a17:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801a1b:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801a1f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801a23:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801a27:	89 ca                	mov    %ecx,%edx
  801a29:	89 f8                	mov    %edi,%eax
  801a2b:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801a2f:	85 f6                	test   %esi,%esi
  801a31:	75 2d                	jne    801a60 <__udivdi3+0x50>
  801a33:	39 cf                	cmp    %ecx,%edi
  801a35:	77 65                	ja     801a9c <__udivdi3+0x8c>
  801a37:	89 fd                	mov    %edi,%ebp
  801a39:	85 ff                	test   %edi,%edi
  801a3b:	75 0b                	jne    801a48 <__udivdi3+0x38>
  801a3d:	b8 01 00 00 00       	mov    $0x1,%eax
  801a42:	31 d2                	xor    %edx,%edx
  801a44:	f7 f7                	div    %edi
  801a46:	89 c5                	mov    %eax,%ebp
  801a48:	31 d2                	xor    %edx,%edx
  801a4a:	89 c8                	mov    %ecx,%eax
  801a4c:	f7 f5                	div    %ebp
  801a4e:	89 c1                	mov    %eax,%ecx
  801a50:	89 d8                	mov    %ebx,%eax
  801a52:	f7 f5                	div    %ebp
  801a54:	89 cf                	mov    %ecx,%edi
  801a56:	89 fa                	mov    %edi,%edx
  801a58:	83 c4 1c             	add    $0x1c,%esp
  801a5b:	5b                   	pop    %ebx
  801a5c:	5e                   	pop    %esi
  801a5d:	5f                   	pop    %edi
  801a5e:	5d                   	pop    %ebp
  801a5f:	c3                   	ret    
  801a60:	39 ce                	cmp    %ecx,%esi
  801a62:	77 28                	ja     801a8c <__udivdi3+0x7c>
  801a64:	0f bd fe             	bsr    %esi,%edi
  801a67:	83 f7 1f             	xor    $0x1f,%edi
  801a6a:	75 40                	jne    801aac <__udivdi3+0x9c>
  801a6c:	39 ce                	cmp    %ecx,%esi
  801a6e:	72 0a                	jb     801a7a <__udivdi3+0x6a>
  801a70:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801a74:	0f 87 9e 00 00 00    	ja     801b18 <__udivdi3+0x108>
  801a7a:	b8 01 00 00 00       	mov    $0x1,%eax
  801a7f:	89 fa                	mov    %edi,%edx
  801a81:	83 c4 1c             	add    $0x1c,%esp
  801a84:	5b                   	pop    %ebx
  801a85:	5e                   	pop    %esi
  801a86:	5f                   	pop    %edi
  801a87:	5d                   	pop    %ebp
  801a88:	c3                   	ret    
  801a89:	8d 76 00             	lea    0x0(%esi),%esi
  801a8c:	31 ff                	xor    %edi,%edi
  801a8e:	31 c0                	xor    %eax,%eax
  801a90:	89 fa                	mov    %edi,%edx
  801a92:	83 c4 1c             	add    $0x1c,%esp
  801a95:	5b                   	pop    %ebx
  801a96:	5e                   	pop    %esi
  801a97:	5f                   	pop    %edi
  801a98:	5d                   	pop    %ebp
  801a99:	c3                   	ret    
  801a9a:	66 90                	xchg   %ax,%ax
  801a9c:	89 d8                	mov    %ebx,%eax
  801a9e:	f7 f7                	div    %edi
  801aa0:	31 ff                	xor    %edi,%edi
  801aa2:	89 fa                	mov    %edi,%edx
  801aa4:	83 c4 1c             	add    $0x1c,%esp
  801aa7:	5b                   	pop    %ebx
  801aa8:	5e                   	pop    %esi
  801aa9:	5f                   	pop    %edi
  801aaa:	5d                   	pop    %ebp
  801aab:	c3                   	ret    
  801aac:	bd 20 00 00 00       	mov    $0x20,%ebp
  801ab1:	89 eb                	mov    %ebp,%ebx
  801ab3:	29 fb                	sub    %edi,%ebx
  801ab5:	89 f9                	mov    %edi,%ecx
  801ab7:	d3 e6                	shl    %cl,%esi
  801ab9:	89 c5                	mov    %eax,%ebp
  801abb:	88 d9                	mov    %bl,%cl
  801abd:	d3 ed                	shr    %cl,%ebp
  801abf:	89 e9                	mov    %ebp,%ecx
  801ac1:	09 f1                	or     %esi,%ecx
  801ac3:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801ac7:	89 f9                	mov    %edi,%ecx
  801ac9:	d3 e0                	shl    %cl,%eax
  801acb:	89 c5                	mov    %eax,%ebp
  801acd:	89 d6                	mov    %edx,%esi
  801acf:	88 d9                	mov    %bl,%cl
  801ad1:	d3 ee                	shr    %cl,%esi
  801ad3:	89 f9                	mov    %edi,%ecx
  801ad5:	d3 e2                	shl    %cl,%edx
  801ad7:	8b 44 24 08          	mov    0x8(%esp),%eax
  801adb:	88 d9                	mov    %bl,%cl
  801add:	d3 e8                	shr    %cl,%eax
  801adf:	09 c2                	or     %eax,%edx
  801ae1:	89 d0                	mov    %edx,%eax
  801ae3:	89 f2                	mov    %esi,%edx
  801ae5:	f7 74 24 0c          	divl   0xc(%esp)
  801ae9:	89 d6                	mov    %edx,%esi
  801aeb:	89 c3                	mov    %eax,%ebx
  801aed:	f7 e5                	mul    %ebp
  801aef:	39 d6                	cmp    %edx,%esi
  801af1:	72 19                	jb     801b0c <__udivdi3+0xfc>
  801af3:	74 0b                	je     801b00 <__udivdi3+0xf0>
  801af5:	89 d8                	mov    %ebx,%eax
  801af7:	31 ff                	xor    %edi,%edi
  801af9:	e9 58 ff ff ff       	jmp    801a56 <__udivdi3+0x46>
  801afe:	66 90                	xchg   %ax,%ax
  801b00:	8b 54 24 08          	mov    0x8(%esp),%edx
  801b04:	89 f9                	mov    %edi,%ecx
  801b06:	d3 e2                	shl    %cl,%edx
  801b08:	39 c2                	cmp    %eax,%edx
  801b0a:	73 e9                	jae    801af5 <__udivdi3+0xe5>
  801b0c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801b0f:	31 ff                	xor    %edi,%edi
  801b11:	e9 40 ff ff ff       	jmp    801a56 <__udivdi3+0x46>
  801b16:	66 90                	xchg   %ax,%ax
  801b18:	31 c0                	xor    %eax,%eax
  801b1a:	e9 37 ff ff ff       	jmp    801a56 <__udivdi3+0x46>
  801b1f:	90                   	nop

00801b20 <__umoddi3>:
  801b20:	55                   	push   %ebp
  801b21:	57                   	push   %edi
  801b22:	56                   	push   %esi
  801b23:	53                   	push   %ebx
  801b24:	83 ec 1c             	sub    $0x1c,%esp
  801b27:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801b2b:	8b 74 24 34          	mov    0x34(%esp),%esi
  801b2f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801b33:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801b37:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801b3b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801b3f:	89 f3                	mov    %esi,%ebx
  801b41:	89 fa                	mov    %edi,%edx
  801b43:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801b47:	89 34 24             	mov    %esi,(%esp)
  801b4a:	85 c0                	test   %eax,%eax
  801b4c:	75 1a                	jne    801b68 <__umoddi3+0x48>
  801b4e:	39 f7                	cmp    %esi,%edi
  801b50:	0f 86 a2 00 00 00    	jbe    801bf8 <__umoddi3+0xd8>
  801b56:	89 c8                	mov    %ecx,%eax
  801b58:	89 f2                	mov    %esi,%edx
  801b5a:	f7 f7                	div    %edi
  801b5c:	89 d0                	mov    %edx,%eax
  801b5e:	31 d2                	xor    %edx,%edx
  801b60:	83 c4 1c             	add    $0x1c,%esp
  801b63:	5b                   	pop    %ebx
  801b64:	5e                   	pop    %esi
  801b65:	5f                   	pop    %edi
  801b66:	5d                   	pop    %ebp
  801b67:	c3                   	ret    
  801b68:	39 f0                	cmp    %esi,%eax
  801b6a:	0f 87 ac 00 00 00    	ja     801c1c <__umoddi3+0xfc>
  801b70:	0f bd e8             	bsr    %eax,%ebp
  801b73:	83 f5 1f             	xor    $0x1f,%ebp
  801b76:	0f 84 ac 00 00 00    	je     801c28 <__umoddi3+0x108>
  801b7c:	bf 20 00 00 00       	mov    $0x20,%edi
  801b81:	29 ef                	sub    %ebp,%edi
  801b83:	89 fe                	mov    %edi,%esi
  801b85:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801b89:	89 e9                	mov    %ebp,%ecx
  801b8b:	d3 e0                	shl    %cl,%eax
  801b8d:	89 d7                	mov    %edx,%edi
  801b8f:	89 f1                	mov    %esi,%ecx
  801b91:	d3 ef                	shr    %cl,%edi
  801b93:	09 c7                	or     %eax,%edi
  801b95:	89 e9                	mov    %ebp,%ecx
  801b97:	d3 e2                	shl    %cl,%edx
  801b99:	89 14 24             	mov    %edx,(%esp)
  801b9c:	89 d8                	mov    %ebx,%eax
  801b9e:	d3 e0                	shl    %cl,%eax
  801ba0:	89 c2                	mov    %eax,%edx
  801ba2:	8b 44 24 08          	mov    0x8(%esp),%eax
  801ba6:	d3 e0                	shl    %cl,%eax
  801ba8:	89 44 24 04          	mov    %eax,0x4(%esp)
  801bac:	8b 44 24 08          	mov    0x8(%esp),%eax
  801bb0:	89 f1                	mov    %esi,%ecx
  801bb2:	d3 e8                	shr    %cl,%eax
  801bb4:	09 d0                	or     %edx,%eax
  801bb6:	d3 eb                	shr    %cl,%ebx
  801bb8:	89 da                	mov    %ebx,%edx
  801bba:	f7 f7                	div    %edi
  801bbc:	89 d3                	mov    %edx,%ebx
  801bbe:	f7 24 24             	mull   (%esp)
  801bc1:	89 c6                	mov    %eax,%esi
  801bc3:	89 d1                	mov    %edx,%ecx
  801bc5:	39 d3                	cmp    %edx,%ebx
  801bc7:	0f 82 87 00 00 00    	jb     801c54 <__umoddi3+0x134>
  801bcd:	0f 84 91 00 00 00    	je     801c64 <__umoddi3+0x144>
  801bd3:	8b 54 24 04          	mov    0x4(%esp),%edx
  801bd7:	29 f2                	sub    %esi,%edx
  801bd9:	19 cb                	sbb    %ecx,%ebx
  801bdb:	89 d8                	mov    %ebx,%eax
  801bdd:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801be1:	d3 e0                	shl    %cl,%eax
  801be3:	89 e9                	mov    %ebp,%ecx
  801be5:	d3 ea                	shr    %cl,%edx
  801be7:	09 d0                	or     %edx,%eax
  801be9:	89 e9                	mov    %ebp,%ecx
  801beb:	d3 eb                	shr    %cl,%ebx
  801bed:	89 da                	mov    %ebx,%edx
  801bef:	83 c4 1c             	add    $0x1c,%esp
  801bf2:	5b                   	pop    %ebx
  801bf3:	5e                   	pop    %esi
  801bf4:	5f                   	pop    %edi
  801bf5:	5d                   	pop    %ebp
  801bf6:	c3                   	ret    
  801bf7:	90                   	nop
  801bf8:	89 fd                	mov    %edi,%ebp
  801bfa:	85 ff                	test   %edi,%edi
  801bfc:	75 0b                	jne    801c09 <__umoddi3+0xe9>
  801bfe:	b8 01 00 00 00       	mov    $0x1,%eax
  801c03:	31 d2                	xor    %edx,%edx
  801c05:	f7 f7                	div    %edi
  801c07:	89 c5                	mov    %eax,%ebp
  801c09:	89 f0                	mov    %esi,%eax
  801c0b:	31 d2                	xor    %edx,%edx
  801c0d:	f7 f5                	div    %ebp
  801c0f:	89 c8                	mov    %ecx,%eax
  801c11:	f7 f5                	div    %ebp
  801c13:	89 d0                	mov    %edx,%eax
  801c15:	e9 44 ff ff ff       	jmp    801b5e <__umoddi3+0x3e>
  801c1a:	66 90                	xchg   %ax,%ax
  801c1c:	89 c8                	mov    %ecx,%eax
  801c1e:	89 f2                	mov    %esi,%edx
  801c20:	83 c4 1c             	add    $0x1c,%esp
  801c23:	5b                   	pop    %ebx
  801c24:	5e                   	pop    %esi
  801c25:	5f                   	pop    %edi
  801c26:	5d                   	pop    %ebp
  801c27:	c3                   	ret    
  801c28:	3b 04 24             	cmp    (%esp),%eax
  801c2b:	72 06                	jb     801c33 <__umoddi3+0x113>
  801c2d:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801c31:	77 0f                	ja     801c42 <__umoddi3+0x122>
  801c33:	89 f2                	mov    %esi,%edx
  801c35:	29 f9                	sub    %edi,%ecx
  801c37:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801c3b:	89 14 24             	mov    %edx,(%esp)
  801c3e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801c42:	8b 44 24 04          	mov    0x4(%esp),%eax
  801c46:	8b 14 24             	mov    (%esp),%edx
  801c49:	83 c4 1c             	add    $0x1c,%esp
  801c4c:	5b                   	pop    %ebx
  801c4d:	5e                   	pop    %esi
  801c4e:	5f                   	pop    %edi
  801c4f:	5d                   	pop    %ebp
  801c50:	c3                   	ret    
  801c51:	8d 76 00             	lea    0x0(%esi),%esi
  801c54:	2b 04 24             	sub    (%esp),%eax
  801c57:	19 fa                	sbb    %edi,%edx
  801c59:	89 d1                	mov    %edx,%ecx
  801c5b:	89 c6                	mov    %eax,%esi
  801c5d:	e9 71 ff ff ff       	jmp    801bd3 <__umoddi3+0xb3>
  801c62:	66 90                	xchg   %ax,%ax
  801c64:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801c68:	72 ea                	jb     801c54 <__umoddi3+0x134>
  801c6a:	89 d9                	mov    %ebx,%ecx
  801c6c:	e9 62 ff ff ff       	jmp    801bd3 <__umoddi3+0xb3>
