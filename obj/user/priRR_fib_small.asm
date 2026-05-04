
obj/user/priRR_fib_small:     file format elf32-i386


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
  800031:	e8 a7 00 00 00       	call   8000dd <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:

int fibonacci(int n);

void
_main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	81 ec 18 01 00 00    	sub    $0x118,%esp
	int i1=0;
  800041:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	char buff1[256];
	i1 = 8;
  800048:	c7 45 f4 08 00 00 00 	movl   $0x8,-0xc(%ebp)

	int res = fibonacci(i1) ;
  80004f:	83 ec 0c             	sub    $0xc,%esp
  800052:	ff 75 f4             	pushl  -0xc(%ebp)
  800055:	e8 44 00 00 00       	call   80009e <fibonacci>
  80005a:	83 c4 10             	add    $0x10,%esp
  80005d:	89 45 f0             	mov    %eax,-0x10(%ebp)

	atomic_cprintf("Fibonacci #%d = %d\n",i1, res);
  800060:	83 ec 04             	sub    $0x4,%esp
  800063:	ff 75 f0             	pushl  -0x10(%ebp)
  800066:	ff 75 f4             	pushl  -0xc(%ebp)
  800069:	68 60 1c 80 00       	push   $0x801c60
  80006e:	e8 63 05 00 00       	call   8005d6 <atomic_cprintf>
  800073:	83 c4 10             	add    $0x10,%esp

	if (res != 34)
  800076:	83 7d f0 22          	cmpl   $0x22,-0x10(%ebp)
  80007a:	74 1a                	je     800096 <_main+0x5e>
		panic("[envID %d] wrong result!", myEnv->env_id);
  80007c:	a1 20 30 80 00       	mov    0x803020,%eax
  800081:	8b 40 10             	mov    0x10(%eax),%eax
  800084:	50                   	push   %eax
  800085:	68 74 1c 80 00       	push   $0x801c74
  80008a:	6a 13                	push   $0x13
  80008c:	68 8d 1c 80 00       	push   $0x801c8d
  800091:	e8 00 02 00 00       	call   800296 <_panic>

	//To indicate that it's completed successfully
	inctst();
  800096:	e8 d4 17 00 00       	call   80186f <inctst>

	return;
  80009b:	90                   	nop
}
  80009c:	c9                   	leave  
  80009d:	c3                   	ret    

0080009e <fibonacci>:


int fibonacci(int n)
{
  80009e:	55                   	push   %ebp
  80009f:	89 e5                	mov    %esp,%ebp
  8000a1:	53                   	push   %ebx
  8000a2:	83 ec 04             	sub    $0x4,%esp
	if (n <= 1)
  8000a5:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
  8000a9:	7f 07                	jg     8000b2 <fibonacci+0x14>
		return 1 ;
  8000ab:	b8 01 00 00 00       	mov    $0x1,%eax
  8000b0:	eb 26                	jmp    8000d8 <fibonacci+0x3a>
	return fibonacci(n-1) + fibonacci(n-2) ;
  8000b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8000b5:	48                   	dec    %eax
  8000b6:	83 ec 0c             	sub    $0xc,%esp
  8000b9:	50                   	push   %eax
  8000ba:	e8 df ff ff ff       	call   80009e <fibonacci>
  8000bf:	83 c4 10             	add    $0x10,%esp
  8000c2:	89 c3                	mov    %eax,%ebx
  8000c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8000c7:	83 e8 02             	sub    $0x2,%eax
  8000ca:	83 ec 0c             	sub    $0xc,%esp
  8000cd:	50                   	push   %eax
  8000ce:	e8 cb ff ff ff       	call   80009e <fibonacci>
  8000d3:	83 c4 10             	add    $0x10,%esp
  8000d6:	01 d8                	add    %ebx,%eax
}
  8000d8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8000db:	c9                   	leave  
  8000dc:	c3                   	ret    

008000dd <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  8000dd:	55                   	push   %ebp
  8000de:	89 e5                	mov    %esp,%ebp
  8000e0:	57                   	push   %edi
  8000e1:	56                   	push   %esi
  8000e2:	53                   	push   %ebx
  8000e3:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  8000e6:	e8 46 16 00 00       	call   801731 <sys_getenvindex>
  8000eb:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  8000ee:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8000f1:	89 d0                	mov    %edx,%eax
  8000f3:	c1 e0 02             	shl    $0x2,%eax
  8000f6:	01 d0                	add    %edx,%eax
  8000f8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8000ff:	01 d0                	add    %edx,%eax
  800101:	89 c2                	mov    %eax,%edx
  800103:	c1 e2 04             	shl    $0x4,%edx
  800106:	29 c2                	sub    %eax,%edx
  800108:	8d 04 95 00 00 00 00 	lea    0x0(,%edx,4),%eax
  80010f:	89 c2                	mov    %eax,%edx
  800111:	8d 82 00 00 c0 ee    	lea    -0x11400000(%edx),%eax
  800117:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  80011c:	a1 20 30 80 00       	mov    0x803020,%eax
  800121:	8a 40 20             	mov    0x20(%eax),%al
  800124:	84 c0                	test   %al,%al
  800126:	74 0d                	je     800135 <libmain+0x58>
		binaryname = myEnv->prog_name;
  800128:	a1 20 30 80 00       	mov    0x803020,%eax
  80012d:	83 c0 20             	add    $0x20,%eax
  800130:	a3 04 30 80 00       	mov    %eax,0x803004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800135:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800139:	7e 0a                	jle    800145 <libmain+0x68>
		binaryname = argv[0];
  80013b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80013e:	8b 00                	mov    (%eax),%eax
  800140:	a3 04 30 80 00       	mov    %eax,0x803004

	// call user main routine
	_main(argc, argv);
  800145:	83 ec 08             	sub    $0x8,%esp
  800148:	ff 75 0c             	pushl  0xc(%ebp)
  80014b:	ff 75 08             	pushl  0x8(%ebp)
  80014e:	e8 e5 fe ff ff       	call   800038 <_main>
  800153:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  800156:	a1 00 30 80 00       	mov    0x803000,%eax
  80015b:	85 c0                	test   %eax,%eax
  80015d:	0f 84 01 01 00 00    	je     800264 <libmain+0x187>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  800163:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  800169:	bb 9c 1d 80 00       	mov    $0x801d9c,%ebx
  80016e:	ba 0e 00 00 00       	mov    $0xe,%edx
  800173:	89 c7                	mov    %eax,%edi
  800175:	89 de                	mov    %ebx,%esi
  800177:	89 d1                	mov    %edx,%ecx
  800179:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  80017b:	8d 55 8a             	lea    -0x76(%ebp),%edx
  80017e:	b9 56 00 00 00       	mov    $0x56,%ecx
  800183:	b0 00                	mov    $0x0,%al
  800185:	89 d7                	mov    %edx,%edi
  800187:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  800189:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  800190:	8d 45 e0             	lea    -0x20(%ebp),%eax
  800193:	83 ec 08             	sub    $0x8,%esp
  800196:	50                   	push   %eax
  800197:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  80019d:	50                   	push   %eax
  80019e:	e8 c4 17 00 00       	call   801967 <sys_utilities>
  8001a3:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  8001a6:	e8 0d 13 00 00       	call   8014b8 <sys_lock_cons>
		{
			cprintf("**************************************\n");
  8001ab:	83 ec 0c             	sub    $0xc,%esp
  8001ae:	68 bc 1c 80 00       	push   $0x801cbc
  8001b3:	e8 ac 03 00 00       	call   800564 <cprintf>
  8001b8:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  8001bb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8001be:	85 c0                	test   %eax,%eax
  8001c0:	74 18                	je     8001da <libmain+0xfd>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  8001c2:	e8 be 17 00 00       	call   801985 <sys_get_optimal_num_faults>
  8001c7:	83 ec 08             	sub    $0x8,%esp
  8001ca:	50                   	push   %eax
  8001cb:	68 e4 1c 80 00       	push   $0x801ce4
  8001d0:	e8 8f 03 00 00       	call   800564 <cprintf>
  8001d5:	83 c4 10             	add    $0x10,%esp
  8001d8:	eb 59                	jmp    800233 <libmain+0x156>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8001da:	a1 20 30 80 00       	mov    0x803020,%eax
  8001df:	8b 90 bc 05 00 00    	mov    0x5bc(%eax),%edx
  8001e5:	a1 20 30 80 00       	mov    0x803020,%eax
  8001ea:	8b 80 ac 05 00 00    	mov    0x5ac(%eax),%eax
  8001f0:	83 ec 04             	sub    $0x4,%esp
  8001f3:	52                   	push   %edx
  8001f4:	50                   	push   %eax
  8001f5:	68 08 1d 80 00       	push   $0x801d08
  8001fa:	e8 65 03 00 00       	call   800564 <cprintf>
  8001ff:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800202:	a1 20 30 80 00       	mov    0x803020,%eax
  800207:	8b 88 d0 05 00 00    	mov    0x5d0(%eax),%ecx
  80020d:	a1 20 30 80 00       	mov    0x803020,%eax
  800212:	8b 90 cc 05 00 00    	mov    0x5cc(%eax),%edx
  800218:	a1 20 30 80 00       	mov    0x803020,%eax
  80021d:	8b 80 c8 05 00 00    	mov    0x5c8(%eax),%eax
  800223:	51                   	push   %ecx
  800224:	52                   	push   %edx
  800225:	50                   	push   %eax
  800226:	68 30 1d 80 00       	push   $0x801d30
  80022b:	e8 34 03 00 00       	call   800564 <cprintf>
  800230:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800233:	a1 20 30 80 00       	mov    0x803020,%eax
  800238:	8b 80 d4 05 00 00    	mov    0x5d4(%eax),%eax
  80023e:	83 ec 08             	sub    $0x8,%esp
  800241:	50                   	push   %eax
  800242:	68 88 1d 80 00       	push   $0x801d88
  800247:	e8 18 03 00 00       	call   800564 <cprintf>
  80024c:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  80024f:	83 ec 0c             	sub    $0xc,%esp
  800252:	68 bc 1c 80 00       	push   $0x801cbc
  800257:	e8 08 03 00 00       	call   800564 <cprintf>
  80025c:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  80025f:	e8 6e 12 00 00       	call   8014d2 <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  800264:	e8 1f 00 00 00       	call   800288 <exit>
}
  800269:	90                   	nop
  80026a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80026d:	5b                   	pop    %ebx
  80026e:	5e                   	pop    %esi
  80026f:	5f                   	pop    %edi
  800270:	5d                   	pop    %ebp
  800271:	c3                   	ret    

00800272 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800272:	55                   	push   %ebp
  800273:	89 e5                	mov    %esp,%ebp
  800275:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800278:	83 ec 0c             	sub    $0xc,%esp
  80027b:	6a 00                	push   $0x0
  80027d:	e8 7b 14 00 00       	call   8016fd <sys_destroy_env>
  800282:	83 c4 10             	add    $0x10,%esp
}
  800285:	90                   	nop
  800286:	c9                   	leave  
  800287:	c3                   	ret    

00800288 <exit>:

void
exit(void)
{
  800288:	55                   	push   %ebp
  800289:	89 e5                	mov    %esp,%ebp
  80028b:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  80028e:	e8 d0 14 00 00       	call   801763 <sys_exit_env>
}
  800293:	90                   	nop
  800294:	c9                   	leave  
  800295:	c3                   	ret    

00800296 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800296:	55                   	push   %ebp
  800297:	89 e5                	mov    %esp,%ebp
  800299:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  80029c:	8d 45 10             	lea    0x10(%ebp),%eax
  80029f:	83 c0 04             	add    $0x4,%eax
  8002a2:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8002a5:	a1 18 b1 81 00       	mov    0x81b118,%eax
  8002aa:	85 c0                	test   %eax,%eax
  8002ac:	74 16                	je     8002c4 <_panic+0x2e>
		cprintf("%s: ", argv0);
  8002ae:	a1 18 b1 81 00       	mov    0x81b118,%eax
  8002b3:	83 ec 08             	sub    $0x8,%esp
  8002b6:	50                   	push   %eax
  8002b7:	68 00 1e 80 00       	push   $0x801e00
  8002bc:	e8 a3 02 00 00       	call   800564 <cprintf>
  8002c1:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  8002c4:	a1 04 30 80 00       	mov    0x803004,%eax
  8002c9:	83 ec 0c             	sub    $0xc,%esp
  8002cc:	ff 75 0c             	pushl  0xc(%ebp)
  8002cf:	ff 75 08             	pushl  0x8(%ebp)
  8002d2:	50                   	push   %eax
  8002d3:	68 08 1e 80 00       	push   $0x801e08
  8002d8:	6a 74                	push   $0x74
  8002da:	e8 b2 02 00 00       	call   800591 <cprintf_colored>
  8002df:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  8002e2:	8b 45 10             	mov    0x10(%ebp),%eax
  8002e5:	83 ec 08             	sub    $0x8,%esp
  8002e8:	ff 75 f4             	pushl  -0xc(%ebp)
  8002eb:	50                   	push   %eax
  8002ec:	e8 04 02 00 00       	call   8004f5 <vcprintf>
  8002f1:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8002f4:	83 ec 08             	sub    $0x8,%esp
  8002f7:	6a 00                	push   $0x0
  8002f9:	68 30 1e 80 00       	push   $0x801e30
  8002fe:	e8 f2 01 00 00       	call   8004f5 <vcprintf>
  800303:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800306:	e8 7d ff ff ff       	call   800288 <exit>

	// should not return here
	while (1) ;
  80030b:	eb fe                	jmp    80030b <_panic+0x75>

0080030d <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  80030d:	55                   	push   %ebp
  80030e:	89 e5                	mov    %esp,%ebp
  800310:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800313:	a1 20 30 80 00       	mov    0x803020,%eax
  800318:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  80031e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800321:	39 c2                	cmp    %eax,%edx
  800323:	74 14                	je     800339 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800325:	83 ec 04             	sub    $0x4,%esp
  800328:	68 34 1e 80 00       	push   $0x801e34
  80032d:	6a 26                	push   $0x26
  80032f:	68 80 1e 80 00       	push   $0x801e80
  800334:	e8 5d ff ff ff       	call   800296 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800339:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800340:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800347:	e9 c5 00 00 00       	jmp    800411 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  80034c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80034f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800356:	8b 45 08             	mov    0x8(%ebp),%eax
  800359:	01 d0                	add    %edx,%eax
  80035b:	8b 00                	mov    (%eax),%eax
  80035d:	85 c0                	test   %eax,%eax
  80035f:	75 08                	jne    800369 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  800361:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800364:	e9 a5 00 00 00       	jmp    80040e <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  800369:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800370:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800377:	eb 69                	jmp    8003e2 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800379:	a1 20 30 80 00       	mov    0x803020,%eax
  80037e:	8b 88 a4 05 00 00    	mov    0x5a4(%eax),%ecx
  800384:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800387:	89 d0                	mov    %edx,%eax
  800389:	01 c0                	add    %eax,%eax
  80038b:	01 d0                	add    %edx,%eax
  80038d:	c1 e0 03             	shl    $0x3,%eax
  800390:	01 c8                	add    %ecx,%eax
  800392:	8a 40 04             	mov    0x4(%eax),%al
  800395:	84 c0                	test   %al,%al
  800397:	75 46                	jne    8003df <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800399:	a1 20 30 80 00       	mov    0x803020,%eax
  80039e:	8b 88 a4 05 00 00    	mov    0x5a4(%eax),%ecx
  8003a4:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8003a7:	89 d0                	mov    %edx,%eax
  8003a9:	01 c0                	add    %eax,%eax
  8003ab:	01 d0                	add    %edx,%eax
  8003ad:	c1 e0 03             	shl    $0x3,%eax
  8003b0:	01 c8                	add    %ecx,%eax
  8003b2:	8b 00                	mov    (%eax),%eax
  8003b4:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8003b7:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8003ba:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8003bf:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8003c1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003c4:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8003cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8003ce:	01 c8                	add    %ecx,%eax
  8003d0:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8003d2:	39 c2                	cmp    %eax,%edx
  8003d4:	75 09                	jne    8003df <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  8003d6:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8003dd:	eb 15                	jmp    8003f4 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8003df:	ff 45 e8             	incl   -0x18(%ebp)
  8003e2:	a1 20 30 80 00       	mov    0x803020,%eax
  8003e7:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8003ed:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8003f0:	39 c2                	cmp    %eax,%edx
  8003f2:	77 85                	ja     800379 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8003f4:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8003f8:	75 14                	jne    80040e <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  8003fa:	83 ec 04             	sub    $0x4,%esp
  8003fd:	68 8c 1e 80 00       	push   $0x801e8c
  800402:	6a 3a                	push   $0x3a
  800404:	68 80 1e 80 00       	push   $0x801e80
  800409:	e8 88 fe ff ff       	call   800296 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  80040e:	ff 45 f0             	incl   -0x10(%ebp)
  800411:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800414:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800417:	0f 8c 2f ff ff ff    	jl     80034c <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  80041d:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800424:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80042b:	eb 26                	jmp    800453 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  80042d:	a1 20 30 80 00       	mov    0x803020,%eax
  800432:	8b 88 a4 05 00 00    	mov    0x5a4(%eax),%ecx
  800438:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80043b:	89 d0                	mov    %edx,%eax
  80043d:	01 c0                	add    %eax,%eax
  80043f:	01 d0                	add    %edx,%eax
  800441:	c1 e0 03             	shl    $0x3,%eax
  800444:	01 c8                	add    %ecx,%eax
  800446:	8a 40 04             	mov    0x4(%eax),%al
  800449:	3c 01                	cmp    $0x1,%al
  80044b:	75 03                	jne    800450 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  80044d:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800450:	ff 45 e0             	incl   -0x20(%ebp)
  800453:	a1 20 30 80 00       	mov    0x803020,%eax
  800458:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  80045e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800461:	39 c2                	cmp    %eax,%edx
  800463:	77 c8                	ja     80042d <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800465:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800468:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80046b:	74 14                	je     800481 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  80046d:	83 ec 04             	sub    $0x4,%esp
  800470:	68 e0 1e 80 00       	push   $0x801ee0
  800475:	6a 44                	push   $0x44
  800477:	68 80 1e 80 00       	push   $0x801e80
  80047c:	e8 15 fe ff ff       	call   800296 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800481:	90                   	nop
  800482:	c9                   	leave  
  800483:	c3                   	ret    

00800484 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  800484:	55                   	push   %ebp
  800485:	89 e5                	mov    %esp,%ebp
  800487:	53                   	push   %ebx
  800488:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  80048b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80048e:	8b 00                	mov    (%eax),%eax
  800490:	8d 48 01             	lea    0x1(%eax),%ecx
  800493:	8b 55 0c             	mov    0xc(%ebp),%edx
  800496:	89 0a                	mov    %ecx,(%edx)
  800498:	8b 55 08             	mov    0x8(%ebp),%edx
  80049b:	88 d1                	mov    %dl,%cl
  80049d:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004a0:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8004a4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004a7:	8b 00                	mov    (%eax),%eax
  8004a9:	3d ff 00 00 00       	cmp    $0xff,%eax
  8004ae:	75 30                	jne    8004e0 <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  8004b0:	8b 15 1c b1 81 00    	mov    0x81b11c,%edx
  8004b6:	a0 44 30 80 00       	mov    0x803044,%al
  8004bb:	0f b6 c0             	movzbl %al,%eax
  8004be:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8004c1:	8b 09                	mov    (%ecx),%ecx
  8004c3:	89 cb                	mov    %ecx,%ebx
  8004c5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8004c8:	83 c1 08             	add    $0x8,%ecx
  8004cb:	52                   	push   %edx
  8004cc:	50                   	push   %eax
  8004cd:	53                   	push   %ebx
  8004ce:	51                   	push   %ecx
  8004cf:	e8 a0 0f 00 00       	call   801474 <sys_cputs>
  8004d4:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8004d7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004da:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8004e0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004e3:	8b 40 04             	mov    0x4(%eax),%eax
  8004e6:	8d 50 01             	lea    0x1(%eax),%edx
  8004e9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004ec:	89 50 04             	mov    %edx,0x4(%eax)
}
  8004ef:	90                   	nop
  8004f0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8004f3:	c9                   	leave  
  8004f4:	c3                   	ret    

008004f5 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8004f5:	55                   	push   %ebp
  8004f6:	89 e5                	mov    %esp,%ebp
  8004f8:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8004fe:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800505:	00 00 00 
	b.cnt = 0;
  800508:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80050f:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800512:	ff 75 0c             	pushl  0xc(%ebp)
  800515:	ff 75 08             	pushl  0x8(%ebp)
  800518:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80051e:	50                   	push   %eax
  80051f:	68 84 04 80 00       	push   $0x800484
  800524:	e8 5a 02 00 00       	call   800783 <vprintfmt>
  800529:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  80052c:	8b 15 1c b1 81 00    	mov    0x81b11c,%edx
  800532:	a0 44 30 80 00       	mov    0x803044,%al
  800537:	0f b6 c0             	movzbl %al,%eax
  80053a:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  800540:	52                   	push   %edx
  800541:	50                   	push   %eax
  800542:	51                   	push   %ecx
  800543:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800549:	83 c0 08             	add    $0x8,%eax
  80054c:	50                   	push   %eax
  80054d:	e8 22 0f 00 00       	call   801474 <sys_cputs>
  800552:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800555:	c6 05 44 30 80 00 00 	movb   $0x0,0x803044
	return b.cnt;
  80055c:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800562:	c9                   	leave  
  800563:	c3                   	ret    

00800564 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  800564:	55                   	push   %ebp
  800565:	89 e5                	mov    %esp,%ebp
  800567:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  80056a:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
	va_start(ap, fmt);
  800571:	8d 45 0c             	lea    0xc(%ebp),%eax
  800574:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800577:	8b 45 08             	mov    0x8(%ebp),%eax
  80057a:	83 ec 08             	sub    $0x8,%esp
  80057d:	ff 75 f4             	pushl  -0xc(%ebp)
  800580:	50                   	push   %eax
  800581:	e8 6f ff ff ff       	call   8004f5 <vcprintf>
  800586:	83 c4 10             	add    $0x10,%esp
  800589:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  80058c:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80058f:	c9                   	leave  
  800590:	c3                   	ret    

00800591 <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  800591:	55                   	push   %ebp
  800592:	89 e5                	mov    %esp,%ebp
  800594:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800597:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
	curTextClr = (textClr << 8) ; //set text color by the given value
  80059e:	8b 45 08             	mov    0x8(%ebp),%eax
  8005a1:	c1 e0 08             	shl    $0x8,%eax
  8005a4:	a3 1c b1 81 00       	mov    %eax,0x81b11c
	va_start(ap, fmt);
  8005a9:	8d 45 0c             	lea    0xc(%ebp),%eax
  8005ac:	83 c0 04             	add    $0x4,%eax
  8005af:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8005b2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005b5:	83 ec 08             	sub    $0x8,%esp
  8005b8:	ff 75 f4             	pushl  -0xc(%ebp)
  8005bb:	50                   	push   %eax
  8005bc:	e8 34 ff ff ff       	call   8004f5 <vcprintf>
  8005c1:	83 c4 10             	add    $0x10,%esp
  8005c4:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  8005c7:	c7 05 1c b1 81 00 00 	movl   $0x700,0x81b11c
  8005ce:	07 00 00 

	return cnt;
  8005d1:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8005d4:	c9                   	leave  
  8005d5:	c3                   	ret    

008005d6 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  8005d6:	55                   	push   %ebp
  8005d7:	89 e5                	mov    %esp,%ebp
  8005d9:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  8005dc:	e8 d7 0e 00 00       	call   8014b8 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  8005e1:	8d 45 0c             	lea    0xc(%ebp),%eax
  8005e4:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  8005e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8005ea:	83 ec 08             	sub    $0x8,%esp
  8005ed:	ff 75 f4             	pushl  -0xc(%ebp)
  8005f0:	50                   	push   %eax
  8005f1:	e8 ff fe ff ff       	call   8004f5 <vcprintf>
  8005f6:	83 c4 10             	add    $0x10,%esp
  8005f9:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  8005fc:	e8 d1 0e 00 00       	call   8014d2 <sys_unlock_cons>
	return cnt;
  800601:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800604:	c9                   	leave  
  800605:	c3                   	ret    

00800606 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800606:	55                   	push   %ebp
  800607:	89 e5                	mov    %esp,%ebp
  800609:	53                   	push   %ebx
  80060a:	83 ec 14             	sub    $0x14,%esp
  80060d:	8b 45 10             	mov    0x10(%ebp),%eax
  800610:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800613:	8b 45 14             	mov    0x14(%ebp),%eax
  800616:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800619:	8b 45 18             	mov    0x18(%ebp),%eax
  80061c:	ba 00 00 00 00       	mov    $0x0,%edx
  800621:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800624:	77 55                	ja     80067b <printnum+0x75>
  800626:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800629:	72 05                	jb     800630 <printnum+0x2a>
  80062b:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80062e:	77 4b                	ja     80067b <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800630:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800633:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800636:	8b 45 18             	mov    0x18(%ebp),%eax
  800639:	ba 00 00 00 00       	mov    $0x0,%edx
  80063e:	52                   	push   %edx
  80063f:	50                   	push   %eax
  800640:	ff 75 f4             	pushl  -0xc(%ebp)
  800643:	ff 75 f0             	pushl  -0x10(%ebp)
  800646:	e8 a9 13 00 00       	call   8019f4 <__udivdi3>
  80064b:	83 c4 10             	add    $0x10,%esp
  80064e:	83 ec 04             	sub    $0x4,%esp
  800651:	ff 75 20             	pushl  0x20(%ebp)
  800654:	53                   	push   %ebx
  800655:	ff 75 18             	pushl  0x18(%ebp)
  800658:	52                   	push   %edx
  800659:	50                   	push   %eax
  80065a:	ff 75 0c             	pushl  0xc(%ebp)
  80065d:	ff 75 08             	pushl  0x8(%ebp)
  800660:	e8 a1 ff ff ff       	call   800606 <printnum>
  800665:	83 c4 20             	add    $0x20,%esp
  800668:	eb 1a                	jmp    800684 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80066a:	83 ec 08             	sub    $0x8,%esp
  80066d:	ff 75 0c             	pushl  0xc(%ebp)
  800670:	ff 75 20             	pushl  0x20(%ebp)
  800673:	8b 45 08             	mov    0x8(%ebp),%eax
  800676:	ff d0                	call   *%eax
  800678:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80067b:	ff 4d 1c             	decl   0x1c(%ebp)
  80067e:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800682:	7f e6                	jg     80066a <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800684:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800687:	bb 00 00 00 00       	mov    $0x0,%ebx
  80068c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80068f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800692:	53                   	push   %ebx
  800693:	51                   	push   %ecx
  800694:	52                   	push   %edx
  800695:	50                   	push   %eax
  800696:	e8 69 14 00 00       	call   801b04 <__umoddi3>
  80069b:	83 c4 10             	add    $0x10,%esp
  80069e:	05 54 21 80 00       	add    $0x802154,%eax
  8006a3:	8a 00                	mov    (%eax),%al
  8006a5:	0f be c0             	movsbl %al,%eax
  8006a8:	83 ec 08             	sub    $0x8,%esp
  8006ab:	ff 75 0c             	pushl  0xc(%ebp)
  8006ae:	50                   	push   %eax
  8006af:	8b 45 08             	mov    0x8(%ebp),%eax
  8006b2:	ff d0                	call   *%eax
  8006b4:	83 c4 10             	add    $0x10,%esp
}
  8006b7:	90                   	nop
  8006b8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8006bb:	c9                   	leave  
  8006bc:	c3                   	ret    

008006bd <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8006bd:	55                   	push   %ebp
  8006be:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8006c0:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8006c4:	7e 1c                	jle    8006e2 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8006c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8006c9:	8b 00                	mov    (%eax),%eax
  8006cb:	8d 50 08             	lea    0x8(%eax),%edx
  8006ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8006d1:	89 10                	mov    %edx,(%eax)
  8006d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8006d6:	8b 00                	mov    (%eax),%eax
  8006d8:	83 e8 08             	sub    $0x8,%eax
  8006db:	8b 50 04             	mov    0x4(%eax),%edx
  8006de:	8b 00                	mov    (%eax),%eax
  8006e0:	eb 40                	jmp    800722 <getuint+0x65>
	else if (lflag)
  8006e2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8006e6:	74 1e                	je     800706 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8006e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8006eb:	8b 00                	mov    (%eax),%eax
  8006ed:	8d 50 04             	lea    0x4(%eax),%edx
  8006f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8006f3:	89 10                	mov    %edx,(%eax)
  8006f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8006f8:	8b 00                	mov    (%eax),%eax
  8006fa:	83 e8 04             	sub    $0x4,%eax
  8006fd:	8b 00                	mov    (%eax),%eax
  8006ff:	ba 00 00 00 00       	mov    $0x0,%edx
  800704:	eb 1c                	jmp    800722 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800706:	8b 45 08             	mov    0x8(%ebp),%eax
  800709:	8b 00                	mov    (%eax),%eax
  80070b:	8d 50 04             	lea    0x4(%eax),%edx
  80070e:	8b 45 08             	mov    0x8(%ebp),%eax
  800711:	89 10                	mov    %edx,(%eax)
  800713:	8b 45 08             	mov    0x8(%ebp),%eax
  800716:	8b 00                	mov    (%eax),%eax
  800718:	83 e8 04             	sub    $0x4,%eax
  80071b:	8b 00                	mov    (%eax),%eax
  80071d:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800722:	5d                   	pop    %ebp
  800723:	c3                   	ret    

00800724 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800724:	55                   	push   %ebp
  800725:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800727:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80072b:	7e 1c                	jle    800749 <getint+0x25>
		return va_arg(*ap, long long);
  80072d:	8b 45 08             	mov    0x8(%ebp),%eax
  800730:	8b 00                	mov    (%eax),%eax
  800732:	8d 50 08             	lea    0x8(%eax),%edx
  800735:	8b 45 08             	mov    0x8(%ebp),%eax
  800738:	89 10                	mov    %edx,(%eax)
  80073a:	8b 45 08             	mov    0x8(%ebp),%eax
  80073d:	8b 00                	mov    (%eax),%eax
  80073f:	83 e8 08             	sub    $0x8,%eax
  800742:	8b 50 04             	mov    0x4(%eax),%edx
  800745:	8b 00                	mov    (%eax),%eax
  800747:	eb 38                	jmp    800781 <getint+0x5d>
	else if (lflag)
  800749:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80074d:	74 1a                	je     800769 <getint+0x45>
		return va_arg(*ap, long);
  80074f:	8b 45 08             	mov    0x8(%ebp),%eax
  800752:	8b 00                	mov    (%eax),%eax
  800754:	8d 50 04             	lea    0x4(%eax),%edx
  800757:	8b 45 08             	mov    0x8(%ebp),%eax
  80075a:	89 10                	mov    %edx,(%eax)
  80075c:	8b 45 08             	mov    0x8(%ebp),%eax
  80075f:	8b 00                	mov    (%eax),%eax
  800761:	83 e8 04             	sub    $0x4,%eax
  800764:	8b 00                	mov    (%eax),%eax
  800766:	99                   	cltd   
  800767:	eb 18                	jmp    800781 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800769:	8b 45 08             	mov    0x8(%ebp),%eax
  80076c:	8b 00                	mov    (%eax),%eax
  80076e:	8d 50 04             	lea    0x4(%eax),%edx
  800771:	8b 45 08             	mov    0x8(%ebp),%eax
  800774:	89 10                	mov    %edx,(%eax)
  800776:	8b 45 08             	mov    0x8(%ebp),%eax
  800779:	8b 00                	mov    (%eax),%eax
  80077b:	83 e8 04             	sub    $0x4,%eax
  80077e:	8b 00                	mov    (%eax),%eax
  800780:	99                   	cltd   
}
  800781:	5d                   	pop    %ebp
  800782:	c3                   	ret    

00800783 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800783:	55                   	push   %ebp
  800784:	89 e5                	mov    %esp,%ebp
  800786:	56                   	push   %esi
  800787:	53                   	push   %ebx
  800788:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80078b:	eb 17                	jmp    8007a4 <vprintfmt+0x21>
			if (ch == '\0')
  80078d:	85 db                	test   %ebx,%ebx
  80078f:	0f 84 c1 03 00 00    	je     800b56 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  800795:	83 ec 08             	sub    $0x8,%esp
  800798:	ff 75 0c             	pushl  0xc(%ebp)
  80079b:	53                   	push   %ebx
  80079c:	8b 45 08             	mov    0x8(%ebp),%eax
  80079f:	ff d0                	call   *%eax
  8007a1:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8007a4:	8b 45 10             	mov    0x10(%ebp),%eax
  8007a7:	8d 50 01             	lea    0x1(%eax),%edx
  8007aa:	89 55 10             	mov    %edx,0x10(%ebp)
  8007ad:	8a 00                	mov    (%eax),%al
  8007af:	0f b6 d8             	movzbl %al,%ebx
  8007b2:	83 fb 25             	cmp    $0x25,%ebx
  8007b5:	75 d6                	jne    80078d <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8007b7:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  8007bb:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  8007c2:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8007c9:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8007d0:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8007d7:	8b 45 10             	mov    0x10(%ebp),%eax
  8007da:	8d 50 01             	lea    0x1(%eax),%edx
  8007dd:	89 55 10             	mov    %edx,0x10(%ebp)
  8007e0:	8a 00                	mov    (%eax),%al
  8007e2:	0f b6 d8             	movzbl %al,%ebx
  8007e5:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8007e8:	83 f8 5b             	cmp    $0x5b,%eax
  8007eb:	0f 87 3d 03 00 00    	ja     800b2e <vprintfmt+0x3ab>
  8007f1:	8b 04 85 78 21 80 00 	mov    0x802178(,%eax,4),%eax
  8007f8:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8007fa:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8007fe:	eb d7                	jmp    8007d7 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800800:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800804:	eb d1                	jmp    8007d7 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800806:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  80080d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800810:	89 d0                	mov    %edx,%eax
  800812:	c1 e0 02             	shl    $0x2,%eax
  800815:	01 d0                	add    %edx,%eax
  800817:	01 c0                	add    %eax,%eax
  800819:	01 d8                	add    %ebx,%eax
  80081b:	83 e8 30             	sub    $0x30,%eax
  80081e:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800821:	8b 45 10             	mov    0x10(%ebp),%eax
  800824:	8a 00                	mov    (%eax),%al
  800826:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800829:	83 fb 2f             	cmp    $0x2f,%ebx
  80082c:	7e 3e                	jle    80086c <vprintfmt+0xe9>
  80082e:	83 fb 39             	cmp    $0x39,%ebx
  800831:	7f 39                	jg     80086c <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800833:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800836:	eb d5                	jmp    80080d <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800838:	8b 45 14             	mov    0x14(%ebp),%eax
  80083b:	83 c0 04             	add    $0x4,%eax
  80083e:	89 45 14             	mov    %eax,0x14(%ebp)
  800841:	8b 45 14             	mov    0x14(%ebp),%eax
  800844:	83 e8 04             	sub    $0x4,%eax
  800847:	8b 00                	mov    (%eax),%eax
  800849:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  80084c:	eb 1f                	jmp    80086d <vprintfmt+0xea>

		case '.':
			if (width < 0)
  80084e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800852:	79 83                	jns    8007d7 <vprintfmt+0x54>
				width = 0;
  800854:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  80085b:	e9 77 ff ff ff       	jmp    8007d7 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800860:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800867:	e9 6b ff ff ff       	jmp    8007d7 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  80086c:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  80086d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800871:	0f 89 60 ff ff ff    	jns    8007d7 <vprintfmt+0x54>
				width = precision, precision = -1;
  800877:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80087a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80087d:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800884:	e9 4e ff ff ff       	jmp    8007d7 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800889:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  80088c:	e9 46 ff ff ff       	jmp    8007d7 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800891:	8b 45 14             	mov    0x14(%ebp),%eax
  800894:	83 c0 04             	add    $0x4,%eax
  800897:	89 45 14             	mov    %eax,0x14(%ebp)
  80089a:	8b 45 14             	mov    0x14(%ebp),%eax
  80089d:	83 e8 04             	sub    $0x4,%eax
  8008a0:	8b 00                	mov    (%eax),%eax
  8008a2:	83 ec 08             	sub    $0x8,%esp
  8008a5:	ff 75 0c             	pushl  0xc(%ebp)
  8008a8:	50                   	push   %eax
  8008a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ac:	ff d0                	call   *%eax
  8008ae:	83 c4 10             	add    $0x10,%esp
			break;
  8008b1:	e9 9b 02 00 00       	jmp    800b51 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8008b6:	8b 45 14             	mov    0x14(%ebp),%eax
  8008b9:	83 c0 04             	add    $0x4,%eax
  8008bc:	89 45 14             	mov    %eax,0x14(%ebp)
  8008bf:	8b 45 14             	mov    0x14(%ebp),%eax
  8008c2:	83 e8 04             	sub    $0x4,%eax
  8008c5:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  8008c7:	85 db                	test   %ebx,%ebx
  8008c9:	79 02                	jns    8008cd <vprintfmt+0x14a>
				err = -err;
  8008cb:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  8008cd:	83 fb 64             	cmp    $0x64,%ebx
  8008d0:	7f 0b                	jg     8008dd <vprintfmt+0x15a>
  8008d2:	8b 34 9d c0 1f 80 00 	mov    0x801fc0(,%ebx,4),%esi
  8008d9:	85 f6                	test   %esi,%esi
  8008db:	75 19                	jne    8008f6 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8008dd:	53                   	push   %ebx
  8008de:	68 65 21 80 00       	push   $0x802165
  8008e3:	ff 75 0c             	pushl  0xc(%ebp)
  8008e6:	ff 75 08             	pushl  0x8(%ebp)
  8008e9:	e8 70 02 00 00       	call   800b5e <printfmt>
  8008ee:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8008f1:	e9 5b 02 00 00       	jmp    800b51 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8008f6:	56                   	push   %esi
  8008f7:	68 6e 21 80 00       	push   $0x80216e
  8008fc:	ff 75 0c             	pushl  0xc(%ebp)
  8008ff:	ff 75 08             	pushl  0x8(%ebp)
  800902:	e8 57 02 00 00       	call   800b5e <printfmt>
  800907:	83 c4 10             	add    $0x10,%esp
			break;
  80090a:	e9 42 02 00 00       	jmp    800b51 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  80090f:	8b 45 14             	mov    0x14(%ebp),%eax
  800912:	83 c0 04             	add    $0x4,%eax
  800915:	89 45 14             	mov    %eax,0x14(%ebp)
  800918:	8b 45 14             	mov    0x14(%ebp),%eax
  80091b:	83 e8 04             	sub    $0x4,%eax
  80091e:	8b 30                	mov    (%eax),%esi
  800920:	85 f6                	test   %esi,%esi
  800922:	75 05                	jne    800929 <vprintfmt+0x1a6>
				p = "(null)";
  800924:	be 71 21 80 00       	mov    $0x802171,%esi
			if (width > 0 && padc != '-')
  800929:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80092d:	7e 6d                	jle    80099c <vprintfmt+0x219>
  80092f:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800933:	74 67                	je     80099c <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800935:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800938:	83 ec 08             	sub    $0x8,%esp
  80093b:	50                   	push   %eax
  80093c:	56                   	push   %esi
  80093d:	e8 1e 03 00 00       	call   800c60 <strnlen>
  800942:	83 c4 10             	add    $0x10,%esp
  800945:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800948:	eb 16                	jmp    800960 <vprintfmt+0x1dd>
					putch(padc, putdat);
  80094a:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  80094e:	83 ec 08             	sub    $0x8,%esp
  800951:	ff 75 0c             	pushl  0xc(%ebp)
  800954:	50                   	push   %eax
  800955:	8b 45 08             	mov    0x8(%ebp),%eax
  800958:	ff d0                	call   *%eax
  80095a:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80095d:	ff 4d e4             	decl   -0x1c(%ebp)
  800960:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800964:	7f e4                	jg     80094a <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800966:	eb 34                	jmp    80099c <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800968:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80096c:	74 1c                	je     80098a <vprintfmt+0x207>
  80096e:	83 fb 1f             	cmp    $0x1f,%ebx
  800971:	7e 05                	jle    800978 <vprintfmt+0x1f5>
  800973:	83 fb 7e             	cmp    $0x7e,%ebx
  800976:	7e 12                	jle    80098a <vprintfmt+0x207>
					putch('?', putdat);
  800978:	83 ec 08             	sub    $0x8,%esp
  80097b:	ff 75 0c             	pushl  0xc(%ebp)
  80097e:	6a 3f                	push   $0x3f
  800980:	8b 45 08             	mov    0x8(%ebp),%eax
  800983:	ff d0                	call   *%eax
  800985:	83 c4 10             	add    $0x10,%esp
  800988:	eb 0f                	jmp    800999 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  80098a:	83 ec 08             	sub    $0x8,%esp
  80098d:	ff 75 0c             	pushl  0xc(%ebp)
  800990:	53                   	push   %ebx
  800991:	8b 45 08             	mov    0x8(%ebp),%eax
  800994:	ff d0                	call   *%eax
  800996:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800999:	ff 4d e4             	decl   -0x1c(%ebp)
  80099c:	89 f0                	mov    %esi,%eax
  80099e:	8d 70 01             	lea    0x1(%eax),%esi
  8009a1:	8a 00                	mov    (%eax),%al
  8009a3:	0f be d8             	movsbl %al,%ebx
  8009a6:	85 db                	test   %ebx,%ebx
  8009a8:	74 24                	je     8009ce <vprintfmt+0x24b>
  8009aa:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8009ae:	78 b8                	js     800968 <vprintfmt+0x1e5>
  8009b0:	ff 4d e0             	decl   -0x20(%ebp)
  8009b3:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8009b7:	79 af                	jns    800968 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8009b9:	eb 13                	jmp    8009ce <vprintfmt+0x24b>
				putch(' ', putdat);
  8009bb:	83 ec 08             	sub    $0x8,%esp
  8009be:	ff 75 0c             	pushl  0xc(%ebp)
  8009c1:	6a 20                	push   $0x20
  8009c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8009c6:	ff d0                	call   *%eax
  8009c8:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8009cb:	ff 4d e4             	decl   -0x1c(%ebp)
  8009ce:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8009d2:	7f e7                	jg     8009bb <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  8009d4:	e9 78 01 00 00       	jmp    800b51 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  8009d9:	83 ec 08             	sub    $0x8,%esp
  8009dc:	ff 75 e8             	pushl  -0x18(%ebp)
  8009df:	8d 45 14             	lea    0x14(%ebp),%eax
  8009e2:	50                   	push   %eax
  8009e3:	e8 3c fd ff ff       	call   800724 <getint>
  8009e8:	83 c4 10             	add    $0x10,%esp
  8009eb:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009ee:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  8009f1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009f4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8009f7:	85 d2                	test   %edx,%edx
  8009f9:	79 23                	jns    800a1e <vprintfmt+0x29b>
				putch('-', putdat);
  8009fb:	83 ec 08             	sub    $0x8,%esp
  8009fe:	ff 75 0c             	pushl  0xc(%ebp)
  800a01:	6a 2d                	push   $0x2d
  800a03:	8b 45 08             	mov    0x8(%ebp),%eax
  800a06:	ff d0                	call   *%eax
  800a08:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800a0b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a0e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a11:	f7 d8                	neg    %eax
  800a13:	83 d2 00             	adc    $0x0,%edx
  800a16:	f7 da                	neg    %edx
  800a18:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a1b:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800a1e:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800a25:	e9 bc 00 00 00       	jmp    800ae6 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800a2a:	83 ec 08             	sub    $0x8,%esp
  800a2d:	ff 75 e8             	pushl  -0x18(%ebp)
  800a30:	8d 45 14             	lea    0x14(%ebp),%eax
  800a33:	50                   	push   %eax
  800a34:	e8 84 fc ff ff       	call   8006bd <getuint>
  800a39:	83 c4 10             	add    $0x10,%esp
  800a3c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a3f:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800a42:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800a49:	e9 98 00 00 00       	jmp    800ae6 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800a4e:	83 ec 08             	sub    $0x8,%esp
  800a51:	ff 75 0c             	pushl  0xc(%ebp)
  800a54:	6a 58                	push   $0x58
  800a56:	8b 45 08             	mov    0x8(%ebp),%eax
  800a59:	ff d0                	call   *%eax
  800a5b:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800a5e:	83 ec 08             	sub    $0x8,%esp
  800a61:	ff 75 0c             	pushl  0xc(%ebp)
  800a64:	6a 58                	push   $0x58
  800a66:	8b 45 08             	mov    0x8(%ebp),%eax
  800a69:	ff d0                	call   *%eax
  800a6b:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800a6e:	83 ec 08             	sub    $0x8,%esp
  800a71:	ff 75 0c             	pushl  0xc(%ebp)
  800a74:	6a 58                	push   $0x58
  800a76:	8b 45 08             	mov    0x8(%ebp),%eax
  800a79:	ff d0                	call   *%eax
  800a7b:	83 c4 10             	add    $0x10,%esp
			break;
  800a7e:	e9 ce 00 00 00       	jmp    800b51 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800a83:	83 ec 08             	sub    $0x8,%esp
  800a86:	ff 75 0c             	pushl  0xc(%ebp)
  800a89:	6a 30                	push   $0x30
  800a8b:	8b 45 08             	mov    0x8(%ebp),%eax
  800a8e:	ff d0                	call   *%eax
  800a90:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800a93:	83 ec 08             	sub    $0x8,%esp
  800a96:	ff 75 0c             	pushl  0xc(%ebp)
  800a99:	6a 78                	push   $0x78
  800a9b:	8b 45 08             	mov    0x8(%ebp),%eax
  800a9e:	ff d0                	call   *%eax
  800aa0:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800aa3:	8b 45 14             	mov    0x14(%ebp),%eax
  800aa6:	83 c0 04             	add    $0x4,%eax
  800aa9:	89 45 14             	mov    %eax,0x14(%ebp)
  800aac:	8b 45 14             	mov    0x14(%ebp),%eax
  800aaf:	83 e8 04             	sub    $0x4,%eax
  800ab2:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800ab4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ab7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800abe:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800ac5:	eb 1f                	jmp    800ae6 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800ac7:	83 ec 08             	sub    $0x8,%esp
  800aca:	ff 75 e8             	pushl  -0x18(%ebp)
  800acd:	8d 45 14             	lea    0x14(%ebp),%eax
  800ad0:	50                   	push   %eax
  800ad1:	e8 e7 fb ff ff       	call   8006bd <getuint>
  800ad6:	83 c4 10             	add    $0x10,%esp
  800ad9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800adc:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800adf:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800ae6:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800aea:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800aed:	83 ec 04             	sub    $0x4,%esp
  800af0:	52                   	push   %edx
  800af1:	ff 75 e4             	pushl  -0x1c(%ebp)
  800af4:	50                   	push   %eax
  800af5:	ff 75 f4             	pushl  -0xc(%ebp)
  800af8:	ff 75 f0             	pushl  -0x10(%ebp)
  800afb:	ff 75 0c             	pushl  0xc(%ebp)
  800afe:	ff 75 08             	pushl  0x8(%ebp)
  800b01:	e8 00 fb ff ff       	call   800606 <printnum>
  800b06:	83 c4 20             	add    $0x20,%esp
			break;
  800b09:	eb 46                	jmp    800b51 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800b0b:	83 ec 08             	sub    $0x8,%esp
  800b0e:	ff 75 0c             	pushl  0xc(%ebp)
  800b11:	53                   	push   %ebx
  800b12:	8b 45 08             	mov    0x8(%ebp),%eax
  800b15:	ff d0                	call   *%eax
  800b17:	83 c4 10             	add    $0x10,%esp
			break;
  800b1a:	eb 35                	jmp    800b51 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800b1c:	c6 05 44 30 80 00 00 	movb   $0x0,0x803044
			break;
  800b23:	eb 2c                	jmp    800b51 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800b25:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
			break;
  800b2c:	eb 23                	jmp    800b51 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800b2e:	83 ec 08             	sub    $0x8,%esp
  800b31:	ff 75 0c             	pushl  0xc(%ebp)
  800b34:	6a 25                	push   $0x25
  800b36:	8b 45 08             	mov    0x8(%ebp),%eax
  800b39:	ff d0                	call   *%eax
  800b3b:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800b3e:	ff 4d 10             	decl   0x10(%ebp)
  800b41:	eb 03                	jmp    800b46 <vprintfmt+0x3c3>
  800b43:	ff 4d 10             	decl   0x10(%ebp)
  800b46:	8b 45 10             	mov    0x10(%ebp),%eax
  800b49:	48                   	dec    %eax
  800b4a:	8a 00                	mov    (%eax),%al
  800b4c:	3c 25                	cmp    $0x25,%al
  800b4e:	75 f3                	jne    800b43 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800b50:	90                   	nop
		}
	}
  800b51:	e9 35 fc ff ff       	jmp    80078b <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800b56:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800b57:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800b5a:	5b                   	pop    %ebx
  800b5b:	5e                   	pop    %esi
  800b5c:	5d                   	pop    %ebp
  800b5d:	c3                   	ret    

00800b5e <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800b5e:	55                   	push   %ebp
  800b5f:	89 e5                	mov    %esp,%ebp
  800b61:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800b64:	8d 45 10             	lea    0x10(%ebp),%eax
  800b67:	83 c0 04             	add    $0x4,%eax
  800b6a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800b6d:	8b 45 10             	mov    0x10(%ebp),%eax
  800b70:	ff 75 f4             	pushl  -0xc(%ebp)
  800b73:	50                   	push   %eax
  800b74:	ff 75 0c             	pushl  0xc(%ebp)
  800b77:	ff 75 08             	pushl  0x8(%ebp)
  800b7a:	e8 04 fc ff ff       	call   800783 <vprintfmt>
  800b7f:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800b82:	90                   	nop
  800b83:	c9                   	leave  
  800b84:	c3                   	ret    

00800b85 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800b85:	55                   	push   %ebp
  800b86:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800b88:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b8b:	8b 40 08             	mov    0x8(%eax),%eax
  800b8e:	8d 50 01             	lea    0x1(%eax),%edx
  800b91:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b94:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800b97:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b9a:	8b 10                	mov    (%eax),%edx
  800b9c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b9f:	8b 40 04             	mov    0x4(%eax),%eax
  800ba2:	39 c2                	cmp    %eax,%edx
  800ba4:	73 12                	jae    800bb8 <sprintputch+0x33>
		*b->buf++ = ch;
  800ba6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ba9:	8b 00                	mov    (%eax),%eax
  800bab:	8d 48 01             	lea    0x1(%eax),%ecx
  800bae:	8b 55 0c             	mov    0xc(%ebp),%edx
  800bb1:	89 0a                	mov    %ecx,(%edx)
  800bb3:	8b 55 08             	mov    0x8(%ebp),%edx
  800bb6:	88 10                	mov    %dl,(%eax)
}
  800bb8:	90                   	nop
  800bb9:	5d                   	pop    %ebp
  800bba:	c3                   	ret    

00800bbb <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800bbb:	55                   	push   %ebp
  800bbc:	89 e5                	mov    %esp,%ebp
  800bbe:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800bc1:	8b 45 08             	mov    0x8(%ebp),%eax
  800bc4:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800bc7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bca:	8d 50 ff             	lea    -0x1(%eax),%edx
  800bcd:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd0:	01 d0                	add    %edx,%eax
  800bd2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bd5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800bdc:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800be0:	74 06                	je     800be8 <vsnprintf+0x2d>
  800be2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800be6:	7f 07                	jg     800bef <vsnprintf+0x34>
		return -E_INVAL;
  800be8:	b8 03 00 00 00       	mov    $0x3,%eax
  800bed:	eb 20                	jmp    800c0f <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800bef:	ff 75 14             	pushl  0x14(%ebp)
  800bf2:	ff 75 10             	pushl  0x10(%ebp)
  800bf5:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800bf8:	50                   	push   %eax
  800bf9:	68 85 0b 80 00       	push   $0x800b85
  800bfe:	e8 80 fb ff ff       	call   800783 <vprintfmt>
  800c03:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800c06:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800c09:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800c0c:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800c0f:	c9                   	leave  
  800c10:	c3                   	ret    

00800c11 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800c11:	55                   	push   %ebp
  800c12:	89 e5                	mov    %esp,%ebp
  800c14:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800c17:	8d 45 10             	lea    0x10(%ebp),%eax
  800c1a:	83 c0 04             	add    $0x4,%eax
  800c1d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800c20:	8b 45 10             	mov    0x10(%ebp),%eax
  800c23:	ff 75 f4             	pushl  -0xc(%ebp)
  800c26:	50                   	push   %eax
  800c27:	ff 75 0c             	pushl  0xc(%ebp)
  800c2a:	ff 75 08             	pushl  0x8(%ebp)
  800c2d:	e8 89 ff ff ff       	call   800bbb <vsnprintf>
  800c32:	83 c4 10             	add    $0x10,%esp
  800c35:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800c38:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800c3b:	c9                   	leave  
  800c3c:	c3                   	ret    

00800c3d <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800c3d:	55                   	push   %ebp
  800c3e:	89 e5                	mov    %esp,%ebp
  800c40:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800c43:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c4a:	eb 06                	jmp    800c52 <strlen+0x15>
		n++;
  800c4c:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800c4f:	ff 45 08             	incl   0x8(%ebp)
  800c52:	8b 45 08             	mov    0x8(%ebp),%eax
  800c55:	8a 00                	mov    (%eax),%al
  800c57:	84 c0                	test   %al,%al
  800c59:	75 f1                	jne    800c4c <strlen+0xf>
		n++;
	return n;
  800c5b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c5e:	c9                   	leave  
  800c5f:	c3                   	ret    

00800c60 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800c60:	55                   	push   %ebp
  800c61:	89 e5                	mov    %esp,%ebp
  800c63:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c66:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c6d:	eb 09                	jmp    800c78 <strnlen+0x18>
		n++;
  800c6f:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c72:	ff 45 08             	incl   0x8(%ebp)
  800c75:	ff 4d 0c             	decl   0xc(%ebp)
  800c78:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c7c:	74 09                	je     800c87 <strnlen+0x27>
  800c7e:	8b 45 08             	mov    0x8(%ebp),%eax
  800c81:	8a 00                	mov    (%eax),%al
  800c83:	84 c0                	test   %al,%al
  800c85:	75 e8                	jne    800c6f <strnlen+0xf>
		n++;
	return n;
  800c87:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c8a:	c9                   	leave  
  800c8b:	c3                   	ret    

00800c8c <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800c8c:	55                   	push   %ebp
  800c8d:	89 e5                	mov    %esp,%ebp
  800c8f:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800c92:	8b 45 08             	mov    0x8(%ebp),%eax
  800c95:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800c98:	90                   	nop
  800c99:	8b 45 08             	mov    0x8(%ebp),%eax
  800c9c:	8d 50 01             	lea    0x1(%eax),%edx
  800c9f:	89 55 08             	mov    %edx,0x8(%ebp)
  800ca2:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ca5:	8d 4a 01             	lea    0x1(%edx),%ecx
  800ca8:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800cab:	8a 12                	mov    (%edx),%dl
  800cad:	88 10                	mov    %dl,(%eax)
  800caf:	8a 00                	mov    (%eax),%al
  800cb1:	84 c0                	test   %al,%al
  800cb3:	75 e4                	jne    800c99 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800cb5:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800cb8:	c9                   	leave  
  800cb9:	c3                   	ret    

00800cba <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800cba:	55                   	push   %ebp
  800cbb:	89 e5                	mov    %esp,%ebp
  800cbd:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800cc0:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc3:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800cc6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800ccd:	eb 1f                	jmp    800cee <strncpy+0x34>
		*dst++ = *src;
  800ccf:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd2:	8d 50 01             	lea    0x1(%eax),%edx
  800cd5:	89 55 08             	mov    %edx,0x8(%ebp)
  800cd8:	8b 55 0c             	mov    0xc(%ebp),%edx
  800cdb:	8a 12                	mov    (%edx),%dl
  800cdd:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800cdf:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ce2:	8a 00                	mov    (%eax),%al
  800ce4:	84 c0                	test   %al,%al
  800ce6:	74 03                	je     800ceb <strncpy+0x31>
			src++;
  800ce8:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800ceb:	ff 45 fc             	incl   -0x4(%ebp)
  800cee:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800cf1:	3b 45 10             	cmp    0x10(%ebp),%eax
  800cf4:	72 d9                	jb     800ccf <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800cf6:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800cf9:	c9                   	leave  
  800cfa:	c3                   	ret    

00800cfb <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800cfb:	55                   	push   %ebp
  800cfc:	89 e5                	mov    %esp,%ebp
  800cfe:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800d01:	8b 45 08             	mov    0x8(%ebp),%eax
  800d04:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800d07:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d0b:	74 30                	je     800d3d <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800d0d:	eb 16                	jmp    800d25 <strlcpy+0x2a>
			*dst++ = *src++;
  800d0f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d12:	8d 50 01             	lea    0x1(%eax),%edx
  800d15:	89 55 08             	mov    %edx,0x8(%ebp)
  800d18:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d1b:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d1e:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800d21:	8a 12                	mov    (%edx),%dl
  800d23:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800d25:	ff 4d 10             	decl   0x10(%ebp)
  800d28:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d2c:	74 09                	je     800d37 <strlcpy+0x3c>
  800d2e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d31:	8a 00                	mov    (%eax),%al
  800d33:	84 c0                	test   %al,%al
  800d35:	75 d8                	jne    800d0f <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800d37:	8b 45 08             	mov    0x8(%ebp),%eax
  800d3a:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800d3d:	8b 55 08             	mov    0x8(%ebp),%edx
  800d40:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d43:	29 c2                	sub    %eax,%edx
  800d45:	89 d0                	mov    %edx,%eax
}
  800d47:	c9                   	leave  
  800d48:	c3                   	ret    

00800d49 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800d49:	55                   	push   %ebp
  800d4a:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800d4c:	eb 06                	jmp    800d54 <strcmp+0xb>
		p++, q++;
  800d4e:	ff 45 08             	incl   0x8(%ebp)
  800d51:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800d54:	8b 45 08             	mov    0x8(%ebp),%eax
  800d57:	8a 00                	mov    (%eax),%al
  800d59:	84 c0                	test   %al,%al
  800d5b:	74 0e                	je     800d6b <strcmp+0x22>
  800d5d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d60:	8a 10                	mov    (%eax),%dl
  800d62:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d65:	8a 00                	mov    (%eax),%al
  800d67:	38 c2                	cmp    %al,%dl
  800d69:	74 e3                	je     800d4e <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800d6b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d6e:	8a 00                	mov    (%eax),%al
  800d70:	0f b6 d0             	movzbl %al,%edx
  800d73:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d76:	8a 00                	mov    (%eax),%al
  800d78:	0f b6 c0             	movzbl %al,%eax
  800d7b:	29 c2                	sub    %eax,%edx
  800d7d:	89 d0                	mov    %edx,%eax
}
  800d7f:	5d                   	pop    %ebp
  800d80:	c3                   	ret    

00800d81 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800d81:	55                   	push   %ebp
  800d82:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800d84:	eb 09                	jmp    800d8f <strncmp+0xe>
		n--, p++, q++;
  800d86:	ff 4d 10             	decl   0x10(%ebp)
  800d89:	ff 45 08             	incl   0x8(%ebp)
  800d8c:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800d8f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d93:	74 17                	je     800dac <strncmp+0x2b>
  800d95:	8b 45 08             	mov    0x8(%ebp),%eax
  800d98:	8a 00                	mov    (%eax),%al
  800d9a:	84 c0                	test   %al,%al
  800d9c:	74 0e                	je     800dac <strncmp+0x2b>
  800d9e:	8b 45 08             	mov    0x8(%ebp),%eax
  800da1:	8a 10                	mov    (%eax),%dl
  800da3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800da6:	8a 00                	mov    (%eax),%al
  800da8:	38 c2                	cmp    %al,%dl
  800daa:	74 da                	je     800d86 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800dac:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800db0:	75 07                	jne    800db9 <strncmp+0x38>
		return 0;
  800db2:	b8 00 00 00 00       	mov    $0x0,%eax
  800db7:	eb 14                	jmp    800dcd <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800db9:	8b 45 08             	mov    0x8(%ebp),%eax
  800dbc:	8a 00                	mov    (%eax),%al
  800dbe:	0f b6 d0             	movzbl %al,%edx
  800dc1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dc4:	8a 00                	mov    (%eax),%al
  800dc6:	0f b6 c0             	movzbl %al,%eax
  800dc9:	29 c2                	sub    %eax,%edx
  800dcb:	89 d0                	mov    %edx,%eax
}
  800dcd:	5d                   	pop    %ebp
  800dce:	c3                   	ret    

00800dcf <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800dcf:	55                   	push   %ebp
  800dd0:	89 e5                	mov    %esp,%ebp
  800dd2:	83 ec 04             	sub    $0x4,%esp
  800dd5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dd8:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800ddb:	eb 12                	jmp    800def <strchr+0x20>
		if (*s == c)
  800ddd:	8b 45 08             	mov    0x8(%ebp),%eax
  800de0:	8a 00                	mov    (%eax),%al
  800de2:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800de5:	75 05                	jne    800dec <strchr+0x1d>
			return (char *) s;
  800de7:	8b 45 08             	mov    0x8(%ebp),%eax
  800dea:	eb 11                	jmp    800dfd <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800dec:	ff 45 08             	incl   0x8(%ebp)
  800def:	8b 45 08             	mov    0x8(%ebp),%eax
  800df2:	8a 00                	mov    (%eax),%al
  800df4:	84 c0                	test   %al,%al
  800df6:	75 e5                	jne    800ddd <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800df8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800dfd:	c9                   	leave  
  800dfe:	c3                   	ret    

00800dff <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800dff:	55                   	push   %ebp
  800e00:	89 e5                	mov    %esp,%ebp
  800e02:	83 ec 04             	sub    $0x4,%esp
  800e05:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e08:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800e0b:	eb 0d                	jmp    800e1a <strfind+0x1b>
		if (*s == c)
  800e0d:	8b 45 08             	mov    0x8(%ebp),%eax
  800e10:	8a 00                	mov    (%eax),%al
  800e12:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800e15:	74 0e                	je     800e25 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800e17:	ff 45 08             	incl   0x8(%ebp)
  800e1a:	8b 45 08             	mov    0x8(%ebp),%eax
  800e1d:	8a 00                	mov    (%eax),%al
  800e1f:	84 c0                	test   %al,%al
  800e21:	75 ea                	jne    800e0d <strfind+0xe>
  800e23:	eb 01                	jmp    800e26 <strfind+0x27>
		if (*s == c)
			break;
  800e25:	90                   	nop
	return (char *) s;
  800e26:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e29:	c9                   	leave  
  800e2a:	c3                   	ret    

00800e2b <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  800e2b:	55                   	push   %ebp
  800e2c:	89 e5                	mov    %esp,%ebp
  800e2e:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  800e31:	8b 45 08             	mov    0x8(%ebp),%eax
  800e34:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  800e37:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800e3b:	76 63                	jbe    800ea0 <memset+0x75>
		uint64 data_block = c;
  800e3d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e40:	99                   	cltd   
  800e41:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e44:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  800e47:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e4a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e4d:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  800e51:	c1 e0 08             	shl    $0x8,%eax
  800e54:	09 45 f0             	or     %eax,-0x10(%ebp)
  800e57:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  800e5a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e5d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e60:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  800e64:	c1 e0 10             	shl    $0x10,%eax
  800e67:	09 45 f0             	or     %eax,-0x10(%ebp)
  800e6a:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  800e6d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e70:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e73:	89 c2                	mov    %eax,%edx
  800e75:	b8 00 00 00 00       	mov    $0x0,%eax
  800e7a:	09 45 f0             	or     %eax,-0x10(%ebp)
  800e7d:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  800e80:	eb 18                	jmp    800e9a <memset+0x6f>
			*p64++ = data_block, n -= 8;
  800e82:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  800e85:	8d 41 08             	lea    0x8(%ecx),%eax
  800e88:	89 45 fc             	mov    %eax,-0x4(%ebp)
  800e8b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e8e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e91:	89 01                	mov    %eax,(%ecx)
  800e93:	89 51 04             	mov    %edx,0x4(%ecx)
  800e96:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  800e9a:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800e9e:	77 e2                	ja     800e82 <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  800ea0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ea4:	74 23                	je     800ec9 <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  800ea6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ea9:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  800eac:	eb 0e                	jmp    800ebc <memset+0x91>
			*p8++ = (uint8)c;
  800eae:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800eb1:	8d 50 01             	lea    0x1(%eax),%edx
  800eb4:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800eb7:	8b 55 0c             	mov    0xc(%ebp),%edx
  800eba:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  800ebc:	8b 45 10             	mov    0x10(%ebp),%eax
  800ebf:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ec2:	89 55 10             	mov    %edx,0x10(%ebp)
  800ec5:	85 c0                	test   %eax,%eax
  800ec7:	75 e5                	jne    800eae <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  800ec9:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ecc:	c9                   	leave  
  800ecd:	c3                   	ret    

00800ece <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800ece:	55                   	push   %ebp
  800ecf:	89 e5                	mov    %esp,%ebp
  800ed1:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  800ed4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ed7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  800eda:	8b 45 08             	mov    0x8(%ebp),%eax
  800edd:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  800ee0:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800ee4:	76 24                	jbe    800f0a <memcpy+0x3c>
		while(n >= 8){
  800ee6:	eb 1c                	jmp    800f04 <memcpy+0x36>
			*d64 = *s64;
  800ee8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800eeb:	8b 50 04             	mov    0x4(%eax),%edx
  800eee:	8b 00                	mov    (%eax),%eax
  800ef0:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  800ef3:	89 01                	mov    %eax,(%ecx)
  800ef5:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  800ef8:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  800efc:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  800f00:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  800f04:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800f08:	77 de                	ja     800ee8 <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  800f0a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f0e:	74 31                	je     800f41 <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  800f10:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f13:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  800f16:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f19:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  800f1c:	eb 16                	jmp    800f34 <memcpy+0x66>
			*d8++ = *s8++;
  800f1e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800f21:	8d 50 01             	lea    0x1(%eax),%edx
  800f24:	89 55 f0             	mov    %edx,-0x10(%ebp)
  800f27:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f2a:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f2d:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  800f30:	8a 12                	mov    (%edx),%dl
  800f32:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  800f34:	8b 45 10             	mov    0x10(%ebp),%eax
  800f37:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f3a:	89 55 10             	mov    %edx,0x10(%ebp)
  800f3d:	85 c0                	test   %eax,%eax
  800f3f:	75 dd                	jne    800f1e <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  800f41:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f44:	c9                   	leave  
  800f45:	c3                   	ret    

00800f46 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800f46:	55                   	push   %ebp
  800f47:	89 e5                	mov    %esp,%ebp
  800f49:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800f4c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f4f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800f52:	8b 45 08             	mov    0x8(%ebp),%eax
  800f55:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800f58:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f5b:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800f5e:	73 50                	jae    800fb0 <memmove+0x6a>
  800f60:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f63:	8b 45 10             	mov    0x10(%ebp),%eax
  800f66:	01 d0                	add    %edx,%eax
  800f68:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800f6b:	76 43                	jbe    800fb0 <memmove+0x6a>
		s += n;
  800f6d:	8b 45 10             	mov    0x10(%ebp),%eax
  800f70:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800f73:	8b 45 10             	mov    0x10(%ebp),%eax
  800f76:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800f79:	eb 10                	jmp    800f8b <memmove+0x45>
			*--d = *--s;
  800f7b:	ff 4d f8             	decl   -0x8(%ebp)
  800f7e:	ff 4d fc             	decl   -0x4(%ebp)
  800f81:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f84:	8a 10                	mov    (%eax),%dl
  800f86:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f89:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800f8b:	8b 45 10             	mov    0x10(%ebp),%eax
  800f8e:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f91:	89 55 10             	mov    %edx,0x10(%ebp)
  800f94:	85 c0                	test   %eax,%eax
  800f96:	75 e3                	jne    800f7b <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800f98:	eb 23                	jmp    800fbd <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800f9a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f9d:	8d 50 01             	lea    0x1(%eax),%edx
  800fa0:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800fa3:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800fa6:	8d 4a 01             	lea    0x1(%edx),%ecx
  800fa9:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800fac:	8a 12                	mov    (%edx),%dl
  800fae:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800fb0:	8b 45 10             	mov    0x10(%ebp),%eax
  800fb3:	8d 50 ff             	lea    -0x1(%eax),%edx
  800fb6:	89 55 10             	mov    %edx,0x10(%ebp)
  800fb9:	85 c0                	test   %eax,%eax
  800fbb:	75 dd                	jne    800f9a <memmove+0x54>
			*d++ = *s++;

	return dst;
  800fbd:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800fc0:	c9                   	leave  
  800fc1:	c3                   	ret    

00800fc2 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800fc2:	55                   	push   %ebp
  800fc3:	89 e5                	mov    %esp,%ebp
  800fc5:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800fc8:	8b 45 08             	mov    0x8(%ebp),%eax
  800fcb:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800fce:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fd1:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800fd4:	eb 2a                	jmp    801000 <memcmp+0x3e>
		if (*s1 != *s2)
  800fd6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fd9:	8a 10                	mov    (%eax),%dl
  800fdb:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fde:	8a 00                	mov    (%eax),%al
  800fe0:	38 c2                	cmp    %al,%dl
  800fe2:	74 16                	je     800ffa <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800fe4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fe7:	8a 00                	mov    (%eax),%al
  800fe9:	0f b6 d0             	movzbl %al,%edx
  800fec:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fef:	8a 00                	mov    (%eax),%al
  800ff1:	0f b6 c0             	movzbl %al,%eax
  800ff4:	29 c2                	sub    %eax,%edx
  800ff6:	89 d0                	mov    %edx,%eax
  800ff8:	eb 18                	jmp    801012 <memcmp+0x50>
		s1++, s2++;
  800ffa:	ff 45 fc             	incl   -0x4(%ebp)
  800ffd:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801000:	8b 45 10             	mov    0x10(%ebp),%eax
  801003:	8d 50 ff             	lea    -0x1(%eax),%edx
  801006:	89 55 10             	mov    %edx,0x10(%ebp)
  801009:	85 c0                	test   %eax,%eax
  80100b:	75 c9                	jne    800fd6 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  80100d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801012:	c9                   	leave  
  801013:	c3                   	ret    

00801014 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801014:	55                   	push   %ebp
  801015:	89 e5                	mov    %esp,%ebp
  801017:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  80101a:	8b 55 08             	mov    0x8(%ebp),%edx
  80101d:	8b 45 10             	mov    0x10(%ebp),%eax
  801020:	01 d0                	add    %edx,%eax
  801022:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801025:	eb 15                	jmp    80103c <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801027:	8b 45 08             	mov    0x8(%ebp),%eax
  80102a:	8a 00                	mov    (%eax),%al
  80102c:	0f b6 d0             	movzbl %al,%edx
  80102f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801032:	0f b6 c0             	movzbl %al,%eax
  801035:	39 c2                	cmp    %eax,%edx
  801037:	74 0d                	je     801046 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801039:	ff 45 08             	incl   0x8(%ebp)
  80103c:	8b 45 08             	mov    0x8(%ebp),%eax
  80103f:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801042:	72 e3                	jb     801027 <memfind+0x13>
  801044:	eb 01                	jmp    801047 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801046:	90                   	nop
	return (void *) s;
  801047:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80104a:	c9                   	leave  
  80104b:	c3                   	ret    

0080104c <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80104c:	55                   	push   %ebp
  80104d:	89 e5                	mov    %esp,%ebp
  80104f:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801052:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801059:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801060:	eb 03                	jmp    801065 <strtol+0x19>
		s++;
  801062:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801065:	8b 45 08             	mov    0x8(%ebp),%eax
  801068:	8a 00                	mov    (%eax),%al
  80106a:	3c 20                	cmp    $0x20,%al
  80106c:	74 f4                	je     801062 <strtol+0x16>
  80106e:	8b 45 08             	mov    0x8(%ebp),%eax
  801071:	8a 00                	mov    (%eax),%al
  801073:	3c 09                	cmp    $0x9,%al
  801075:	74 eb                	je     801062 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801077:	8b 45 08             	mov    0x8(%ebp),%eax
  80107a:	8a 00                	mov    (%eax),%al
  80107c:	3c 2b                	cmp    $0x2b,%al
  80107e:	75 05                	jne    801085 <strtol+0x39>
		s++;
  801080:	ff 45 08             	incl   0x8(%ebp)
  801083:	eb 13                	jmp    801098 <strtol+0x4c>
	else if (*s == '-')
  801085:	8b 45 08             	mov    0x8(%ebp),%eax
  801088:	8a 00                	mov    (%eax),%al
  80108a:	3c 2d                	cmp    $0x2d,%al
  80108c:	75 0a                	jne    801098 <strtol+0x4c>
		s++, neg = 1;
  80108e:	ff 45 08             	incl   0x8(%ebp)
  801091:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801098:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80109c:	74 06                	je     8010a4 <strtol+0x58>
  80109e:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8010a2:	75 20                	jne    8010c4 <strtol+0x78>
  8010a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a7:	8a 00                	mov    (%eax),%al
  8010a9:	3c 30                	cmp    $0x30,%al
  8010ab:	75 17                	jne    8010c4 <strtol+0x78>
  8010ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b0:	40                   	inc    %eax
  8010b1:	8a 00                	mov    (%eax),%al
  8010b3:	3c 78                	cmp    $0x78,%al
  8010b5:	75 0d                	jne    8010c4 <strtol+0x78>
		s += 2, base = 16;
  8010b7:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8010bb:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8010c2:	eb 28                	jmp    8010ec <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8010c4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010c8:	75 15                	jne    8010df <strtol+0x93>
  8010ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8010cd:	8a 00                	mov    (%eax),%al
  8010cf:	3c 30                	cmp    $0x30,%al
  8010d1:	75 0c                	jne    8010df <strtol+0x93>
		s++, base = 8;
  8010d3:	ff 45 08             	incl   0x8(%ebp)
  8010d6:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8010dd:	eb 0d                	jmp    8010ec <strtol+0xa0>
	else if (base == 0)
  8010df:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010e3:	75 07                	jne    8010ec <strtol+0xa0>
		base = 10;
  8010e5:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8010ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ef:	8a 00                	mov    (%eax),%al
  8010f1:	3c 2f                	cmp    $0x2f,%al
  8010f3:	7e 19                	jle    80110e <strtol+0xc2>
  8010f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8010f8:	8a 00                	mov    (%eax),%al
  8010fa:	3c 39                	cmp    $0x39,%al
  8010fc:	7f 10                	jg     80110e <strtol+0xc2>
			dig = *s - '0';
  8010fe:	8b 45 08             	mov    0x8(%ebp),%eax
  801101:	8a 00                	mov    (%eax),%al
  801103:	0f be c0             	movsbl %al,%eax
  801106:	83 e8 30             	sub    $0x30,%eax
  801109:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80110c:	eb 42                	jmp    801150 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  80110e:	8b 45 08             	mov    0x8(%ebp),%eax
  801111:	8a 00                	mov    (%eax),%al
  801113:	3c 60                	cmp    $0x60,%al
  801115:	7e 19                	jle    801130 <strtol+0xe4>
  801117:	8b 45 08             	mov    0x8(%ebp),%eax
  80111a:	8a 00                	mov    (%eax),%al
  80111c:	3c 7a                	cmp    $0x7a,%al
  80111e:	7f 10                	jg     801130 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801120:	8b 45 08             	mov    0x8(%ebp),%eax
  801123:	8a 00                	mov    (%eax),%al
  801125:	0f be c0             	movsbl %al,%eax
  801128:	83 e8 57             	sub    $0x57,%eax
  80112b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80112e:	eb 20                	jmp    801150 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801130:	8b 45 08             	mov    0x8(%ebp),%eax
  801133:	8a 00                	mov    (%eax),%al
  801135:	3c 40                	cmp    $0x40,%al
  801137:	7e 39                	jle    801172 <strtol+0x126>
  801139:	8b 45 08             	mov    0x8(%ebp),%eax
  80113c:	8a 00                	mov    (%eax),%al
  80113e:	3c 5a                	cmp    $0x5a,%al
  801140:	7f 30                	jg     801172 <strtol+0x126>
			dig = *s - 'A' + 10;
  801142:	8b 45 08             	mov    0x8(%ebp),%eax
  801145:	8a 00                	mov    (%eax),%al
  801147:	0f be c0             	movsbl %al,%eax
  80114a:	83 e8 37             	sub    $0x37,%eax
  80114d:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801150:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801153:	3b 45 10             	cmp    0x10(%ebp),%eax
  801156:	7d 19                	jge    801171 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801158:	ff 45 08             	incl   0x8(%ebp)
  80115b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80115e:	0f af 45 10          	imul   0x10(%ebp),%eax
  801162:	89 c2                	mov    %eax,%edx
  801164:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801167:	01 d0                	add    %edx,%eax
  801169:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  80116c:	e9 7b ff ff ff       	jmp    8010ec <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801171:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801172:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801176:	74 08                	je     801180 <strtol+0x134>
		*endptr = (char *) s;
  801178:	8b 45 0c             	mov    0xc(%ebp),%eax
  80117b:	8b 55 08             	mov    0x8(%ebp),%edx
  80117e:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801180:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801184:	74 07                	je     80118d <strtol+0x141>
  801186:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801189:	f7 d8                	neg    %eax
  80118b:	eb 03                	jmp    801190 <strtol+0x144>
  80118d:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801190:	c9                   	leave  
  801191:	c3                   	ret    

00801192 <ltostr>:

void
ltostr(long value, char *str)
{
  801192:	55                   	push   %ebp
  801193:	89 e5                	mov    %esp,%ebp
  801195:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801198:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  80119f:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8011a6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8011aa:	79 13                	jns    8011bf <ltostr+0x2d>
	{
		neg = 1;
  8011ac:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8011b3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011b6:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8011b9:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8011bc:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8011bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8011c2:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8011c7:	99                   	cltd   
  8011c8:	f7 f9                	idiv   %ecx
  8011ca:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8011cd:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011d0:	8d 50 01             	lea    0x1(%eax),%edx
  8011d3:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8011d6:	89 c2                	mov    %eax,%edx
  8011d8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011db:	01 d0                	add    %edx,%eax
  8011dd:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8011e0:	83 c2 30             	add    $0x30,%edx
  8011e3:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8011e5:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8011e8:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8011ed:	f7 e9                	imul   %ecx
  8011ef:	c1 fa 02             	sar    $0x2,%edx
  8011f2:	89 c8                	mov    %ecx,%eax
  8011f4:	c1 f8 1f             	sar    $0x1f,%eax
  8011f7:	29 c2                	sub    %eax,%edx
  8011f9:	89 d0                	mov    %edx,%eax
  8011fb:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  8011fe:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801202:	75 bb                	jne    8011bf <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801204:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  80120b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80120e:	48                   	dec    %eax
  80120f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801212:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801216:	74 3d                	je     801255 <ltostr+0xc3>
		start = 1 ;
  801218:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  80121f:	eb 34                	jmp    801255 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  801221:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801224:	8b 45 0c             	mov    0xc(%ebp),%eax
  801227:	01 d0                	add    %edx,%eax
  801229:	8a 00                	mov    (%eax),%al
  80122b:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  80122e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801231:	8b 45 0c             	mov    0xc(%ebp),%eax
  801234:	01 c2                	add    %eax,%edx
  801236:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801239:	8b 45 0c             	mov    0xc(%ebp),%eax
  80123c:	01 c8                	add    %ecx,%eax
  80123e:	8a 00                	mov    (%eax),%al
  801240:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801242:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801245:	8b 45 0c             	mov    0xc(%ebp),%eax
  801248:	01 c2                	add    %eax,%edx
  80124a:	8a 45 eb             	mov    -0x15(%ebp),%al
  80124d:	88 02                	mov    %al,(%edx)
		start++ ;
  80124f:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801252:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801255:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801258:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80125b:	7c c4                	jl     801221 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  80125d:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801260:	8b 45 0c             	mov    0xc(%ebp),%eax
  801263:	01 d0                	add    %edx,%eax
  801265:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801268:	90                   	nop
  801269:	c9                   	leave  
  80126a:	c3                   	ret    

0080126b <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  80126b:	55                   	push   %ebp
  80126c:	89 e5                	mov    %esp,%ebp
  80126e:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801271:	ff 75 08             	pushl  0x8(%ebp)
  801274:	e8 c4 f9 ff ff       	call   800c3d <strlen>
  801279:	83 c4 04             	add    $0x4,%esp
  80127c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  80127f:	ff 75 0c             	pushl  0xc(%ebp)
  801282:	e8 b6 f9 ff ff       	call   800c3d <strlen>
  801287:	83 c4 04             	add    $0x4,%esp
  80128a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  80128d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801294:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80129b:	eb 17                	jmp    8012b4 <strcconcat+0x49>
		final[s] = str1[s] ;
  80129d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8012a0:	8b 45 10             	mov    0x10(%ebp),%eax
  8012a3:	01 c2                	add    %eax,%edx
  8012a5:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8012a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8012ab:	01 c8                	add    %ecx,%eax
  8012ad:	8a 00                	mov    (%eax),%al
  8012af:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8012b1:	ff 45 fc             	incl   -0x4(%ebp)
  8012b4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012b7:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8012ba:	7c e1                	jl     80129d <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8012bc:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8012c3:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8012ca:	eb 1f                	jmp    8012eb <strcconcat+0x80>
		final[s++] = str2[i] ;
  8012cc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012cf:	8d 50 01             	lea    0x1(%eax),%edx
  8012d2:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8012d5:	89 c2                	mov    %eax,%edx
  8012d7:	8b 45 10             	mov    0x10(%ebp),%eax
  8012da:	01 c2                	add    %eax,%edx
  8012dc:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8012df:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012e2:	01 c8                	add    %ecx,%eax
  8012e4:	8a 00                	mov    (%eax),%al
  8012e6:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8012e8:	ff 45 f8             	incl   -0x8(%ebp)
  8012eb:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012ee:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8012f1:	7c d9                	jl     8012cc <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8012f3:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8012f6:	8b 45 10             	mov    0x10(%ebp),%eax
  8012f9:	01 d0                	add    %edx,%eax
  8012fb:	c6 00 00             	movb   $0x0,(%eax)
}
  8012fe:	90                   	nop
  8012ff:	c9                   	leave  
  801300:	c3                   	ret    

00801301 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801301:	55                   	push   %ebp
  801302:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801304:	8b 45 14             	mov    0x14(%ebp),%eax
  801307:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  80130d:	8b 45 14             	mov    0x14(%ebp),%eax
  801310:	8b 00                	mov    (%eax),%eax
  801312:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801319:	8b 45 10             	mov    0x10(%ebp),%eax
  80131c:	01 d0                	add    %edx,%eax
  80131e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801324:	eb 0c                	jmp    801332 <strsplit+0x31>
			*string++ = 0;
  801326:	8b 45 08             	mov    0x8(%ebp),%eax
  801329:	8d 50 01             	lea    0x1(%eax),%edx
  80132c:	89 55 08             	mov    %edx,0x8(%ebp)
  80132f:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801332:	8b 45 08             	mov    0x8(%ebp),%eax
  801335:	8a 00                	mov    (%eax),%al
  801337:	84 c0                	test   %al,%al
  801339:	74 18                	je     801353 <strsplit+0x52>
  80133b:	8b 45 08             	mov    0x8(%ebp),%eax
  80133e:	8a 00                	mov    (%eax),%al
  801340:	0f be c0             	movsbl %al,%eax
  801343:	50                   	push   %eax
  801344:	ff 75 0c             	pushl  0xc(%ebp)
  801347:	e8 83 fa ff ff       	call   800dcf <strchr>
  80134c:	83 c4 08             	add    $0x8,%esp
  80134f:	85 c0                	test   %eax,%eax
  801351:	75 d3                	jne    801326 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801353:	8b 45 08             	mov    0x8(%ebp),%eax
  801356:	8a 00                	mov    (%eax),%al
  801358:	84 c0                	test   %al,%al
  80135a:	74 5a                	je     8013b6 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  80135c:	8b 45 14             	mov    0x14(%ebp),%eax
  80135f:	8b 00                	mov    (%eax),%eax
  801361:	83 f8 0f             	cmp    $0xf,%eax
  801364:	75 07                	jne    80136d <strsplit+0x6c>
		{
			return 0;
  801366:	b8 00 00 00 00       	mov    $0x0,%eax
  80136b:	eb 66                	jmp    8013d3 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  80136d:	8b 45 14             	mov    0x14(%ebp),%eax
  801370:	8b 00                	mov    (%eax),%eax
  801372:	8d 48 01             	lea    0x1(%eax),%ecx
  801375:	8b 55 14             	mov    0x14(%ebp),%edx
  801378:	89 0a                	mov    %ecx,(%edx)
  80137a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801381:	8b 45 10             	mov    0x10(%ebp),%eax
  801384:	01 c2                	add    %eax,%edx
  801386:	8b 45 08             	mov    0x8(%ebp),%eax
  801389:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  80138b:	eb 03                	jmp    801390 <strsplit+0x8f>
			string++;
  80138d:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801390:	8b 45 08             	mov    0x8(%ebp),%eax
  801393:	8a 00                	mov    (%eax),%al
  801395:	84 c0                	test   %al,%al
  801397:	74 8b                	je     801324 <strsplit+0x23>
  801399:	8b 45 08             	mov    0x8(%ebp),%eax
  80139c:	8a 00                	mov    (%eax),%al
  80139e:	0f be c0             	movsbl %al,%eax
  8013a1:	50                   	push   %eax
  8013a2:	ff 75 0c             	pushl  0xc(%ebp)
  8013a5:	e8 25 fa ff ff       	call   800dcf <strchr>
  8013aa:	83 c4 08             	add    $0x8,%esp
  8013ad:	85 c0                	test   %eax,%eax
  8013af:	74 dc                	je     80138d <strsplit+0x8c>
			string++;
	}
  8013b1:	e9 6e ff ff ff       	jmp    801324 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8013b6:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8013b7:	8b 45 14             	mov    0x14(%ebp),%eax
  8013ba:	8b 00                	mov    (%eax),%eax
  8013bc:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8013c3:	8b 45 10             	mov    0x10(%ebp),%eax
  8013c6:	01 d0                	add    %edx,%eax
  8013c8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8013ce:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8013d3:	c9                   	leave  
  8013d4:	c3                   	ret    

008013d5 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  8013d5:	55                   	push   %ebp
  8013d6:	89 e5                	mov    %esp,%ebp
  8013d8:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  8013db:	8b 45 08             	mov    0x8(%ebp),%eax
  8013de:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  8013e1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8013e8:	eb 4a                	jmp    801434 <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  8013ea:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8013ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8013f0:	01 c2                	add    %eax,%edx
  8013f2:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8013f5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013f8:	01 c8                	add    %ecx,%eax
  8013fa:	8a 00                	mov    (%eax),%al
  8013fc:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  8013fe:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801401:	8b 45 0c             	mov    0xc(%ebp),%eax
  801404:	01 d0                	add    %edx,%eax
  801406:	8a 00                	mov    (%eax),%al
  801408:	3c 40                	cmp    $0x40,%al
  80140a:	7e 25                	jle    801431 <str2lower+0x5c>
  80140c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80140f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801412:	01 d0                	add    %edx,%eax
  801414:	8a 00                	mov    (%eax),%al
  801416:	3c 5a                	cmp    $0x5a,%al
  801418:	7f 17                	jg     801431 <str2lower+0x5c>
		{
			dst[i] += 32 ;
  80141a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80141d:	8b 45 08             	mov    0x8(%ebp),%eax
  801420:	01 d0                	add    %edx,%eax
  801422:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801425:	8b 55 08             	mov    0x8(%ebp),%edx
  801428:	01 ca                	add    %ecx,%edx
  80142a:	8a 12                	mov    (%edx),%dl
  80142c:	83 c2 20             	add    $0x20,%edx
  80142f:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  801431:	ff 45 fc             	incl   -0x4(%ebp)
  801434:	ff 75 0c             	pushl  0xc(%ebp)
  801437:	e8 01 f8 ff ff       	call   800c3d <strlen>
  80143c:	83 c4 04             	add    $0x4,%esp
  80143f:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801442:	7f a6                	jg     8013ea <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  801444:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801447:	c9                   	leave  
  801448:	c3                   	ret    

00801449 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801449:	55                   	push   %ebp
  80144a:	89 e5                	mov    %esp,%ebp
  80144c:	57                   	push   %edi
  80144d:	56                   	push   %esi
  80144e:	53                   	push   %ebx
  80144f:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801452:	8b 45 08             	mov    0x8(%ebp),%eax
  801455:	8b 55 0c             	mov    0xc(%ebp),%edx
  801458:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80145b:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80145e:	8b 7d 18             	mov    0x18(%ebp),%edi
  801461:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801464:	cd 30                	int    $0x30
  801466:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  801469:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80146c:	83 c4 10             	add    $0x10,%esp
  80146f:	5b                   	pop    %ebx
  801470:	5e                   	pop    %esi
  801471:	5f                   	pop    %edi
  801472:	5d                   	pop    %ebp
  801473:	c3                   	ret    

00801474 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  801474:	55                   	push   %ebp
  801475:	89 e5                	mov    %esp,%ebp
  801477:	83 ec 04             	sub    $0x4,%esp
  80147a:	8b 45 10             	mov    0x10(%ebp),%eax
  80147d:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  801480:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801483:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801487:	8b 45 08             	mov    0x8(%ebp),%eax
  80148a:	6a 00                	push   $0x0
  80148c:	51                   	push   %ecx
  80148d:	52                   	push   %edx
  80148e:	ff 75 0c             	pushl  0xc(%ebp)
  801491:	50                   	push   %eax
  801492:	6a 00                	push   $0x0
  801494:	e8 b0 ff ff ff       	call   801449 <syscall>
  801499:	83 c4 18             	add    $0x18,%esp
}
  80149c:	90                   	nop
  80149d:	c9                   	leave  
  80149e:	c3                   	ret    

0080149f <sys_cgetc>:

int
sys_cgetc(void)
{
  80149f:	55                   	push   %ebp
  8014a0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8014a2:	6a 00                	push   $0x0
  8014a4:	6a 00                	push   $0x0
  8014a6:	6a 00                	push   $0x0
  8014a8:	6a 00                	push   $0x0
  8014aa:	6a 00                	push   $0x0
  8014ac:	6a 02                	push   $0x2
  8014ae:	e8 96 ff ff ff       	call   801449 <syscall>
  8014b3:	83 c4 18             	add    $0x18,%esp
}
  8014b6:	c9                   	leave  
  8014b7:	c3                   	ret    

008014b8 <sys_lock_cons>:

void sys_lock_cons(void)
{
  8014b8:	55                   	push   %ebp
  8014b9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  8014bb:	6a 00                	push   $0x0
  8014bd:	6a 00                	push   $0x0
  8014bf:	6a 00                	push   $0x0
  8014c1:	6a 00                	push   $0x0
  8014c3:	6a 00                	push   $0x0
  8014c5:	6a 03                	push   $0x3
  8014c7:	e8 7d ff ff ff       	call   801449 <syscall>
  8014cc:	83 c4 18             	add    $0x18,%esp
}
  8014cf:	90                   	nop
  8014d0:	c9                   	leave  
  8014d1:	c3                   	ret    

008014d2 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  8014d2:	55                   	push   %ebp
  8014d3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  8014d5:	6a 00                	push   $0x0
  8014d7:	6a 00                	push   $0x0
  8014d9:	6a 00                	push   $0x0
  8014db:	6a 00                	push   $0x0
  8014dd:	6a 00                	push   $0x0
  8014df:	6a 04                	push   $0x4
  8014e1:	e8 63 ff ff ff       	call   801449 <syscall>
  8014e6:	83 c4 18             	add    $0x18,%esp
}
  8014e9:	90                   	nop
  8014ea:	c9                   	leave  
  8014eb:	c3                   	ret    

008014ec <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8014ec:	55                   	push   %ebp
  8014ed:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8014ef:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8014f5:	6a 00                	push   $0x0
  8014f7:	6a 00                	push   $0x0
  8014f9:	6a 00                	push   $0x0
  8014fb:	52                   	push   %edx
  8014fc:	50                   	push   %eax
  8014fd:	6a 08                	push   $0x8
  8014ff:	e8 45 ff ff ff       	call   801449 <syscall>
  801504:	83 c4 18             	add    $0x18,%esp
}
  801507:	c9                   	leave  
  801508:	c3                   	ret    

00801509 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801509:	55                   	push   %ebp
  80150a:	89 e5                	mov    %esp,%ebp
  80150c:	56                   	push   %esi
  80150d:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  80150e:	8b 75 18             	mov    0x18(%ebp),%esi
  801511:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801514:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801517:	8b 55 0c             	mov    0xc(%ebp),%edx
  80151a:	8b 45 08             	mov    0x8(%ebp),%eax
  80151d:	56                   	push   %esi
  80151e:	53                   	push   %ebx
  80151f:	51                   	push   %ecx
  801520:	52                   	push   %edx
  801521:	50                   	push   %eax
  801522:	6a 09                	push   $0x9
  801524:	e8 20 ff ff ff       	call   801449 <syscall>
  801529:	83 c4 18             	add    $0x18,%esp
}
  80152c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80152f:	5b                   	pop    %ebx
  801530:	5e                   	pop    %esi
  801531:	5d                   	pop    %ebp
  801532:	c3                   	ret    

00801533 <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  801533:	55                   	push   %ebp
  801534:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  801536:	6a 00                	push   $0x0
  801538:	6a 00                	push   $0x0
  80153a:	6a 00                	push   $0x0
  80153c:	6a 00                	push   $0x0
  80153e:	ff 75 08             	pushl  0x8(%ebp)
  801541:	6a 0a                	push   $0xa
  801543:	e8 01 ff ff ff       	call   801449 <syscall>
  801548:	83 c4 18             	add    $0x18,%esp
}
  80154b:	c9                   	leave  
  80154c:	c3                   	ret    

0080154d <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  80154d:	55                   	push   %ebp
  80154e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801550:	6a 00                	push   $0x0
  801552:	6a 00                	push   $0x0
  801554:	6a 00                	push   $0x0
  801556:	ff 75 0c             	pushl  0xc(%ebp)
  801559:	ff 75 08             	pushl  0x8(%ebp)
  80155c:	6a 0b                	push   $0xb
  80155e:	e8 e6 fe ff ff       	call   801449 <syscall>
  801563:	83 c4 18             	add    $0x18,%esp
}
  801566:	c9                   	leave  
  801567:	c3                   	ret    

00801568 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801568:	55                   	push   %ebp
  801569:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  80156b:	6a 00                	push   $0x0
  80156d:	6a 00                	push   $0x0
  80156f:	6a 00                	push   $0x0
  801571:	6a 00                	push   $0x0
  801573:	6a 00                	push   $0x0
  801575:	6a 0c                	push   $0xc
  801577:	e8 cd fe ff ff       	call   801449 <syscall>
  80157c:	83 c4 18             	add    $0x18,%esp
}
  80157f:	c9                   	leave  
  801580:	c3                   	ret    

00801581 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801581:	55                   	push   %ebp
  801582:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801584:	6a 00                	push   $0x0
  801586:	6a 00                	push   $0x0
  801588:	6a 00                	push   $0x0
  80158a:	6a 00                	push   $0x0
  80158c:	6a 00                	push   $0x0
  80158e:	6a 0d                	push   $0xd
  801590:	e8 b4 fe ff ff       	call   801449 <syscall>
  801595:	83 c4 18             	add    $0x18,%esp
}
  801598:	c9                   	leave  
  801599:	c3                   	ret    

0080159a <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  80159a:	55                   	push   %ebp
  80159b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  80159d:	6a 00                	push   $0x0
  80159f:	6a 00                	push   $0x0
  8015a1:	6a 00                	push   $0x0
  8015a3:	6a 00                	push   $0x0
  8015a5:	6a 00                	push   $0x0
  8015a7:	6a 0e                	push   $0xe
  8015a9:	e8 9b fe ff ff       	call   801449 <syscall>
  8015ae:	83 c4 18             	add    $0x18,%esp
}
  8015b1:	c9                   	leave  
  8015b2:	c3                   	ret    

008015b3 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8015b3:	55                   	push   %ebp
  8015b4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8015b6:	6a 00                	push   $0x0
  8015b8:	6a 00                	push   $0x0
  8015ba:	6a 00                	push   $0x0
  8015bc:	6a 00                	push   $0x0
  8015be:	6a 00                	push   $0x0
  8015c0:	6a 0f                	push   $0xf
  8015c2:	e8 82 fe ff ff       	call   801449 <syscall>
  8015c7:	83 c4 18             	add    $0x18,%esp
}
  8015ca:	c9                   	leave  
  8015cb:	c3                   	ret    

008015cc <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8015cc:	55                   	push   %ebp
  8015cd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8015cf:	6a 00                	push   $0x0
  8015d1:	6a 00                	push   $0x0
  8015d3:	6a 00                	push   $0x0
  8015d5:	6a 00                	push   $0x0
  8015d7:	ff 75 08             	pushl  0x8(%ebp)
  8015da:	6a 10                	push   $0x10
  8015dc:	e8 68 fe ff ff       	call   801449 <syscall>
  8015e1:	83 c4 18             	add    $0x18,%esp
}
  8015e4:	c9                   	leave  
  8015e5:	c3                   	ret    

008015e6 <sys_scarce_memory>:

void sys_scarce_memory()
{
  8015e6:	55                   	push   %ebp
  8015e7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8015e9:	6a 00                	push   $0x0
  8015eb:	6a 00                	push   $0x0
  8015ed:	6a 00                	push   $0x0
  8015ef:	6a 00                	push   $0x0
  8015f1:	6a 00                	push   $0x0
  8015f3:	6a 11                	push   $0x11
  8015f5:	e8 4f fe ff ff       	call   801449 <syscall>
  8015fa:	83 c4 18             	add    $0x18,%esp
}
  8015fd:	90                   	nop
  8015fe:	c9                   	leave  
  8015ff:	c3                   	ret    

00801600 <sys_cputc>:

void
sys_cputc(const char c)
{
  801600:	55                   	push   %ebp
  801601:	89 e5                	mov    %esp,%ebp
  801603:	83 ec 04             	sub    $0x4,%esp
  801606:	8b 45 08             	mov    0x8(%ebp),%eax
  801609:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  80160c:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801610:	6a 00                	push   $0x0
  801612:	6a 00                	push   $0x0
  801614:	6a 00                	push   $0x0
  801616:	6a 00                	push   $0x0
  801618:	50                   	push   %eax
  801619:	6a 01                	push   $0x1
  80161b:	e8 29 fe ff ff       	call   801449 <syscall>
  801620:	83 c4 18             	add    $0x18,%esp
}
  801623:	90                   	nop
  801624:	c9                   	leave  
  801625:	c3                   	ret    

00801626 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801626:	55                   	push   %ebp
  801627:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801629:	6a 00                	push   $0x0
  80162b:	6a 00                	push   $0x0
  80162d:	6a 00                	push   $0x0
  80162f:	6a 00                	push   $0x0
  801631:	6a 00                	push   $0x0
  801633:	6a 14                	push   $0x14
  801635:	e8 0f fe ff ff       	call   801449 <syscall>
  80163a:	83 c4 18             	add    $0x18,%esp
}
  80163d:	90                   	nop
  80163e:	c9                   	leave  
  80163f:	c3                   	ret    

00801640 <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801640:	55                   	push   %ebp
  801641:	89 e5                	mov    %esp,%ebp
  801643:	83 ec 04             	sub    $0x4,%esp
  801646:	8b 45 10             	mov    0x10(%ebp),%eax
  801649:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  80164c:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80164f:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801653:	8b 45 08             	mov    0x8(%ebp),%eax
  801656:	6a 00                	push   $0x0
  801658:	51                   	push   %ecx
  801659:	52                   	push   %edx
  80165a:	ff 75 0c             	pushl  0xc(%ebp)
  80165d:	50                   	push   %eax
  80165e:	6a 15                	push   $0x15
  801660:	e8 e4 fd ff ff       	call   801449 <syscall>
  801665:	83 c4 18             	add    $0x18,%esp
}
  801668:	c9                   	leave  
  801669:	c3                   	ret    

0080166a <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  80166a:	55                   	push   %ebp
  80166b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  80166d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801670:	8b 45 08             	mov    0x8(%ebp),%eax
  801673:	6a 00                	push   $0x0
  801675:	6a 00                	push   $0x0
  801677:	6a 00                	push   $0x0
  801679:	52                   	push   %edx
  80167a:	50                   	push   %eax
  80167b:	6a 16                	push   $0x16
  80167d:	e8 c7 fd ff ff       	call   801449 <syscall>
  801682:	83 c4 18             	add    $0x18,%esp
}
  801685:	c9                   	leave  
  801686:	c3                   	ret    

00801687 <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  801687:	55                   	push   %ebp
  801688:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  80168a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80168d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801690:	8b 45 08             	mov    0x8(%ebp),%eax
  801693:	6a 00                	push   $0x0
  801695:	6a 00                	push   $0x0
  801697:	51                   	push   %ecx
  801698:	52                   	push   %edx
  801699:	50                   	push   %eax
  80169a:	6a 17                	push   $0x17
  80169c:	e8 a8 fd ff ff       	call   801449 <syscall>
  8016a1:	83 c4 18             	add    $0x18,%esp
}
  8016a4:	c9                   	leave  
  8016a5:	c3                   	ret    

008016a6 <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  8016a6:	55                   	push   %ebp
  8016a7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8016a9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8016af:	6a 00                	push   $0x0
  8016b1:	6a 00                	push   $0x0
  8016b3:	6a 00                	push   $0x0
  8016b5:	52                   	push   %edx
  8016b6:	50                   	push   %eax
  8016b7:	6a 18                	push   $0x18
  8016b9:	e8 8b fd ff ff       	call   801449 <syscall>
  8016be:	83 c4 18             	add    $0x18,%esp
}
  8016c1:	c9                   	leave  
  8016c2:	c3                   	ret    

008016c3 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8016c3:	55                   	push   %ebp
  8016c4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8016c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8016c9:	6a 00                	push   $0x0
  8016cb:	ff 75 14             	pushl  0x14(%ebp)
  8016ce:	ff 75 10             	pushl  0x10(%ebp)
  8016d1:	ff 75 0c             	pushl  0xc(%ebp)
  8016d4:	50                   	push   %eax
  8016d5:	6a 19                	push   $0x19
  8016d7:	e8 6d fd ff ff       	call   801449 <syscall>
  8016dc:	83 c4 18             	add    $0x18,%esp
}
  8016df:	c9                   	leave  
  8016e0:	c3                   	ret    

008016e1 <sys_run_env>:

void sys_run_env(int32 envId)
{
  8016e1:	55                   	push   %ebp
  8016e2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8016e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8016e7:	6a 00                	push   $0x0
  8016e9:	6a 00                	push   $0x0
  8016eb:	6a 00                	push   $0x0
  8016ed:	6a 00                	push   $0x0
  8016ef:	50                   	push   %eax
  8016f0:	6a 1a                	push   $0x1a
  8016f2:	e8 52 fd ff ff       	call   801449 <syscall>
  8016f7:	83 c4 18             	add    $0x18,%esp
}
  8016fa:	90                   	nop
  8016fb:	c9                   	leave  
  8016fc:	c3                   	ret    

008016fd <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8016fd:	55                   	push   %ebp
  8016fe:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801700:	8b 45 08             	mov    0x8(%ebp),%eax
  801703:	6a 00                	push   $0x0
  801705:	6a 00                	push   $0x0
  801707:	6a 00                	push   $0x0
  801709:	6a 00                	push   $0x0
  80170b:	50                   	push   %eax
  80170c:	6a 1b                	push   $0x1b
  80170e:	e8 36 fd ff ff       	call   801449 <syscall>
  801713:	83 c4 18             	add    $0x18,%esp
}
  801716:	c9                   	leave  
  801717:	c3                   	ret    

00801718 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801718:	55                   	push   %ebp
  801719:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  80171b:	6a 00                	push   $0x0
  80171d:	6a 00                	push   $0x0
  80171f:	6a 00                	push   $0x0
  801721:	6a 00                	push   $0x0
  801723:	6a 00                	push   $0x0
  801725:	6a 05                	push   $0x5
  801727:	e8 1d fd ff ff       	call   801449 <syscall>
  80172c:	83 c4 18             	add    $0x18,%esp
}
  80172f:	c9                   	leave  
  801730:	c3                   	ret    

00801731 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801731:	55                   	push   %ebp
  801732:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801734:	6a 00                	push   $0x0
  801736:	6a 00                	push   $0x0
  801738:	6a 00                	push   $0x0
  80173a:	6a 00                	push   $0x0
  80173c:	6a 00                	push   $0x0
  80173e:	6a 06                	push   $0x6
  801740:	e8 04 fd ff ff       	call   801449 <syscall>
  801745:	83 c4 18             	add    $0x18,%esp
}
  801748:	c9                   	leave  
  801749:	c3                   	ret    

0080174a <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  80174a:	55                   	push   %ebp
  80174b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  80174d:	6a 00                	push   $0x0
  80174f:	6a 00                	push   $0x0
  801751:	6a 00                	push   $0x0
  801753:	6a 00                	push   $0x0
  801755:	6a 00                	push   $0x0
  801757:	6a 07                	push   $0x7
  801759:	e8 eb fc ff ff       	call   801449 <syscall>
  80175e:	83 c4 18             	add    $0x18,%esp
}
  801761:	c9                   	leave  
  801762:	c3                   	ret    

00801763 <sys_exit_env>:


void sys_exit_env(void)
{
  801763:	55                   	push   %ebp
  801764:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801766:	6a 00                	push   $0x0
  801768:	6a 00                	push   $0x0
  80176a:	6a 00                	push   $0x0
  80176c:	6a 00                	push   $0x0
  80176e:	6a 00                	push   $0x0
  801770:	6a 1c                	push   $0x1c
  801772:	e8 d2 fc ff ff       	call   801449 <syscall>
  801777:	83 c4 18             	add    $0x18,%esp
}
  80177a:	90                   	nop
  80177b:	c9                   	leave  
  80177c:	c3                   	ret    

0080177d <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  80177d:	55                   	push   %ebp
  80177e:	89 e5                	mov    %esp,%ebp
  801780:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801783:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801786:	8d 50 04             	lea    0x4(%eax),%edx
  801789:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80178c:	6a 00                	push   $0x0
  80178e:	6a 00                	push   $0x0
  801790:	6a 00                	push   $0x0
  801792:	52                   	push   %edx
  801793:	50                   	push   %eax
  801794:	6a 1d                	push   $0x1d
  801796:	e8 ae fc ff ff       	call   801449 <syscall>
  80179b:	83 c4 18             	add    $0x18,%esp
	return result;
  80179e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8017a1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8017a4:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8017a7:	89 01                	mov    %eax,(%ecx)
  8017a9:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8017ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8017af:	c9                   	leave  
  8017b0:	c2 04 00             	ret    $0x4

008017b3 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8017b3:	55                   	push   %ebp
  8017b4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8017b6:	6a 00                	push   $0x0
  8017b8:	6a 00                	push   $0x0
  8017ba:	ff 75 10             	pushl  0x10(%ebp)
  8017bd:	ff 75 0c             	pushl  0xc(%ebp)
  8017c0:	ff 75 08             	pushl  0x8(%ebp)
  8017c3:	6a 13                	push   $0x13
  8017c5:	e8 7f fc ff ff       	call   801449 <syscall>
  8017ca:	83 c4 18             	add    $0x18,%esp
	return ;
  8017cd:	90                   	nop
}
  8017ce:	c9                   	leave  
  8017cf:	c3                   	ret    

008017d0 <sys_rcr2>:
uint32 sys_rcr2()
{
  8017d0:	55                   	push   %ebp
  8017d1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8017d3:	6a 00                	push   $0x0
  8017d5:	6a 00                	push   $0x0
  8017d7:	6a 00                	push   $0x0
  8017d9:	6a 00                	push   $0x0
  8017db:	6a 00                	push   $0x0
  8017dd:	6a 1e                	push   $0x1e
  8017df:	e8 65 fc ff ff       	call   801449 <syscall>
  8017e4:	83 c4 18             	add    $0x18,%esp
}
  8017e7:	c9                   	leave  
  8017e8:	c3                   	ret    

008017e9 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  8017e9:	55                   	push   %ebp
  8017ea:	89 e5                	mov    %esp,%ebp
  8017ec:	83 ec 04             	sub    $0x4,%esp
  8017ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8017f2:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8017f5:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8017f9:	6a 00                	push   $0x0
  8017fb:	6a 00                	push   $0x0
  8017fd:	6a 00                	push   $0x0
  8017ff:	6a 00                	push   $0x0
  801801:	50                   	push   %eax
  801802:	6a 1f                	push   $0x1f
  801804:	e8 40 fc ff ff       	call   801449 <syscall>
  801809:	83 c4 18             	add    $0x18,%esp
	return ;
  80180c:	90                   	nop
}
  80180d:	c9                   	leave  
  80180e:	c3                   	ret    

0080180f <rsttst>:
void rsttst()
{
  80180f:	55                   	push   %ebp
  801810:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801812:	6a 00                	push   $0x0
  801814:	6a 00                	push   $0x0
  801816:	6a 00                	push   $0x0
  801818:	6a 00                	push   $0x0
  80181a:	6a 00                	push   $0x0
  80181c:	6a 21                	push   $0x21
  80181e:	e8 26 fc ff ff       	call   801449 <syscall>
  801823:	83 c4 18             	add    $0x18,%esp
	return ;
  801826:	90                   	nop
}
  801827:	c9                   	leave  
  801828:	c3                   	ret    

00801829 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801829:	55                   	push   %ebp
  80182a:	89 e5                	mov    %esp,%ebp
  80182c:	83 ec 04             	sub    $0x4,%esp
  80182f:	8b 45 14             	mov    0x14(%ebp),%eax
  801832:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801835:	8b 55 18             	mov    0x18(%ebp),%edx
  801838:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80183c:	52                   	push   %edx
  80183d:	50                   	push   %eax
  80183e:	ff 75 10             	pushl  0x10(%ebp)
  801841:	ff 75 0c             	pushl  0xc(%ebp)
  801844:	ff 75 08             	pushl  0x8(%ebp)
  801847:	6a 20                	push   $0x20
  801849:	e8 fb fb ff ff       	call   801449 <syscall>
  80184e:	83 c4 18             	add    $0x18,%esp
	return ;
  801851:	90                   	nop
}
  801852:	c9                   	leave  
  801853:	c3                   	ret    

00801854 <chktst>:
void chktst(uint32 n)
{
  801854:	55                   	push   %ebp
  801855:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801857:	6a 00                	push   $0x0
  801859:	6a 00                	push   $0x0
  80185b:	6a 00                	push   $0x0
  80185d:	6a 00                	push   $0x0
  80185f:	ff 75 08             	pushl  0x8(%ebp)
  801862:	6a 22                	push   $0x22
  801864:	e8 e0 fb ff ff       	call   801449 <syscall>
  801869:	83 c4 18             	add    $0x18,%esp
	return ;
  80186c:	90                   	nop
}
  80186d:	c9                   	leave  
  80186e:	c3                   	ret    

0080186f <inctst>:

void inctst()
{
  80186f:	55                   	push   %ebp
  801870:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801872:	6a 00                	push   $0x0
  801874:	6a 00                	push   $0x0
  801876:	6a 00                	push   $0x0
  801878:	6a 00                	push   $0x0
  80187a:	6a 00                	push   $0x0
  80187c:	6a 23                	push   $0x23
  80187e:	e8 c6 fb ff ff       	call   801449 <syscall>
  801883:	83 c4 18             	add    $0x18,%esp
	return ;
  801886:	90                   	nop
}
  801887:	c9                   	leave  
  801888:	c3                   	ret    

00801889 <gettst>:
uint32 gettst()
{
  801889:	55                   	push   %ebp
  80188a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  80188c:	6a 00                	push   $0x0
  80188e:	6a 00                	push   $0x0
  801890:	6a 00                	push   $0x0
  801892:	6a 00                	push   $0x0
  801894:	6a 00                	push   $0x0
  801896:	6a 24                	push   $0x24
  801898:	e8 ac fb ff ff       	call   801449 <syscall>
  80189d:	83 c4 18             	add    $0x18,%esp
}
  8018a0:	c9                   	leave  
  8018a1:	c3                   	ret    

008018a2 <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  8018a2:	55                   	push   %ebp
  8018a3:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8018a5:	6a 00                	push   $0x0
  8018a7:	6a 00                	push   $0x0
  8018a9:	6a 00                	push   $0x0
  8018ab:	6a 00                	push   $0x0
  8018ad:	6a 00                	push   $0x0
  8018af:	6a 25                	push   $0x25
  8018b1:	e8 93 fb ff ff       	call   801449 <syscall>
  8018b6:	83 c4 18             	add    $0x18,%esp
  8018b9:	a3 60 b0 81 00       	mov    %eax,0x81b060
	return uheapPlaceStrategy ;
  8018be:	a1 60 b0 81 00       	mov    0x81b060,%eax
}
  8018c3:	c9                   	leave  
  8018c4:	c3                   	ret    

008018c5 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  8018c5:	55                   	push   %ebp
  8018c6:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  8018c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8018cb:	a3 60 b0 81 00       	mov    %eax,0x81b060
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  8018d0:	6a 00                	push   $0x0
  8018d2:	6a 00                	push   $0x0
  8018d4:	6a 00                	push   $0x0
  8018d6:	6a 00                	push   $0x0
  8018d8:	ff 75 08             	pushl  0x8(%ebp)
  8018db:	6a 26                	push   $0x26
  8018dd:	e8 67 fb ff ff       	call   801449 <syscall>
  8018e2:	83 c4 18             	add    $0x18,%esp
	return ;
  8018e5:	90                   	nop
}
  8018e6:	c9                   	leave  
  8018e7:	c3                   	ret    

008018e8 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  8018e8:	55                   	push   %ebp
  8018e9:	89 e5                	mov    %esp,%ebp
  8018eb:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  8018ec:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8018ef:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8018f2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8018f8:	6a 00                	push   $0x0
  8018fa:	53                   	push   %ebx
  8018fb:	51                   	push   %ecx
  8018fc:	52                   	push   %edx
  8018fd:	50                   	push   %eax
  8018fe:	6a 27                	push   $0x27
  801900:	e8 44 fb ff ff       	call   801449 <syscall>
  801905:	83 c4 18             	add    $0x18,%esp
}
  801908:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80190b:	c9                   	leave  
  80190c:	c3                   	ret    

0080190d <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  80190d:	55                   	push   %ebp
  80190e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801910:	8b 55 0c             	mov    0xc(%ebp),%edx
  801913:	8b 45 08             	mov    0x8(%ebp),%eax
  801916:	6a 00                	push   $0x0
  801918:	6a 00                	push   $0x0
  80191a:	6a 00                	push   $0x0
  80191c:	52                   	push   %edx
  80191d:	50                   	push   %eax
  80191e:	6a 28                	push   $0x28
  801920:	e8 24 fb ff ff       	call   801449 <syscall>
  801925:	83 c4 18             	add    $0x18,%esp
}
  801928:	c9                   	leave  
  801929:	c3                   	ret    

0080192a <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  80192a:	55                   	push   %ebp
  80192b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  80192d:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801930:	8b 55 0c             	mov    0xc(%ebp),%edx
  801933:	8b 45 08             	mov    0x8(%ebp),%eax
  801936:	6a 00                	push   $0x0
  801938:	51                   	push   %ecx
  801939:	ff 75 10             	pushl  0x10(%ebp)
  80193c:	52                   	push   %edx
  80193d:	50                   	push   %eax
  80193e:	6a 29                	push   $0x29
  801940:	e8 04 fb ff ff       	call   801449 <syscall>
  801945:	83 c4 18             	add    $0x18,%esp
}
  801948:	c9                   	leave  
  801949:	c3                   	ret    

0080194a <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  80194a:	55                   	push   %ebp
  80194b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  80194d:	6a 00                	push   $0x0
  80194f:	6a 00                	push   $0x0
  801951:	ff 75 10             	pushl  0x10(%ebp)
  801954:	ff 75 0c             	pushl  0xc(%ebp)
  801957:	ff 75 08             	pushl  0x8(%ebp)
  80195a:	6a 12                	push   $0x12
  80195c:	e8 e8 fa ff ff       	call   801449 <syscall>
  801961:	83 c4 18             	add    $0x18,%esp
	return ;
  801964:	90                   	nop
}
  801965:	c9                   	leave  
  801966:	c3                   	ret    

00801967 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  801967:	55                   	push   %ebp
  801968:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  80196a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80196d:	8b 45 08             	mov    0x8(%ebp),%eax
  801970:	6a 00                	push   $0x0
  801972:	6a 00                	push   $0x0
  801974:	6a 00                	push   $0x0
  801976:	52                   	push   %edx
  801977:	50                   	push   %eax
  801978:	6a 2a                	push   $0x2a
  80197a:	e8 ca fa ff ff       	call   801449 <syscall>
  80197f:	83 c4 18             	add    $0x18,%esp
	return;
  801982:	90                   	nop
}
  801983:	c9                   	leave  
  801984:	c3                   	ret    

00801985 <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  801985:	55                   	push   %ebp
  801986:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  801988:	6a 00                	push   $0x0
  80198a:	6a 00                	push   $0x0
  80198c:	6a 00                	push   $0x0
  80198e:	6a 00                	push   $0x0
  801990:	6a 00                	push   $0x0
  801992:	6a 2b                	push   $0x2b
  801994:	e8 b0 fa ff ff       	call   801449 <syscall>
  801999:	83 c4 18             	add    $0x18,%esp
}
  80199c:	c9                   	leave  
  80199d:	c3                   	ret    

0080199e <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  80199e:	55                   	push   %ebp
  80199f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  8019a1:	6a 00                	push   $0x0
  8019a3:	6a 00                	push   $0x0
  8019a5:	6a 00                	push   $0x0
  8019a7:	ff 75 0c             	pushl  0xc(%ebp)
  8019aa:	ff 75 08             	pushl  0x8(%ebp)
  8019ad:	6a 2d                	push   $0x2d
  8019af:	e8 95 fa ff ff       	call   801449 <syscall>
  8019b4:	83 c4 18             	add    $0x18,%esp
	return;
  8019b7:	90                   	nop
}
  8019b8:	c9                   	leave  
  8019b9:	c3                   	ret    

008019ba <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8019ba:	55                   	push   %ebp
  8019bb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  8019bd:	6a 00                	push   $0x0
  8019bf:	6a 00                	push   $0x0
  8019c1:	6a 00                	push   $0x0
  8019c3:	ff 75 0c             	pushl  0xc(%ebp)
  8019c6:	ff 75 08             	pushl  0x8(%ebp)
  8019c9:	6a 2c                	push   $0x2c
  8019cb:	e8 79 fa ff ff       	call   801449 <syscall>
  8019d0:	83 c4 18             	add    $0x18,%esp
	return ;
  8019d3:	90                   	nop
}
  8019d4:	c9                   	leave  
  8019d5:	c3                   	ret    

008019d6 <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  8019d6:	55                   	push   %ebp
  8019d7:	89 e5                	mov    %esp,%ebp
	//TODO: [PROJECT'25.IM#4] CPU SCHEDULING - #1 System Calls - Add suitable code here
	//Your code is here
	//Comment the following line
	//panic("sys_env_set_priority() is not implemented yet...!!");
	syscall(SYS_env_set_priority, envID, priority, 0, 0, 0);
  8019d9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8019df:	6a 00                	push   $0x0
  8019e1:	6a 00                	push   $0x0
  8019e3:	6a 00                	push   $0x0
  8019e5:	52                   	push   %edx
  8019e6:	50                   	push   %eax
  8019e7:	6a 2e                	push   $0x2e
  8019e9:	e8 5b fa ff ff       	call   801449 <syscall>
  8019ee:	83 c4 18             	add    $0x18,%esp
	    return;
  8019f1:	90                   	nop
}
  8019f2:	c9                   	leave  
  8019f3:	c3                   	ret    

008019f4 <__udivdi3>:
  8019f4:	55                   	push   %ebp
  8019f5:	57                   	push   %edi
  8019f6:	56                   	push   %esi
  8019f7:	53                   	push   %ebx
  8019f8:	83 ec 1c             	sub    $0x1c,%esp
  8019fb:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8019ff:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801a03:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801a07:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801a0b:	89 ca                	mov    %ecx,%edx
  801a0d:	89 f8                	mov    %edi,%eax
  801a0f:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801a13:	85 f6                	test   %esi,%esi
  801a15:	75 2d                	jne    801a44 <__udivdi3+0x50>
  801a17:	39 cf                	cmp    %ecx,%edi
  801a19:	77 65                	ja     801a80 <__udivdi3+0x8c>
  801a1b:	89 fd                	mov    %edi,%ebp
  801a1d:	85 ff                	test   %edi,%edi
  801a1f:	75 0b                	jne    801a2c <__udivdi3+0x38>
  801a21:	b8 01 00 00 00       	mov    $0x1,%eax
  801a26:	31 d2                	xor    %edx,%edx
  801a28:	f7 f7                	div    %edi
  801a2a:	89 c5                	mov    %eax,%ebp
  801a2c:	31 d2                	xor    %edx,%edx
  801a2e:	89 c8                	mov    %ecx,%eax
  801a30:	f7 f5                	div    %ebp
  801a32:	89 c1                	mov    %eax,%ecx
  801a34:	89 d8                	mov    %ebx,%eax
  801a36:	f7 f5                	div    %ebp
  801a38:	89 cf                	mov    %ecx,%edi
  801a3a:	89 fa                	mov    %edi,%edx
  801a3c:	83 c4 1c             	add    $0x1c,%esp
  801a3f:	5b                   	pop    %ebx
  801a40:	5e                   	pop    %esi
  801a41:	5f                   	pop    %edi
  801a42:	5d                   	pop    %ebp
  801a43:	c3                   	ret    
  801a44:	39 ce                	cmp    %ecx,%esi
  801a46:	77 28                	ja     801a70 <__udivdi3+0x7c>
  801a48:	0f bd fe             	bsr    %esi,%edi
  801a4b:	83 f7 1f             	xor    $0x1f,%edi
  801a4e:	75 40                	jne    801a90 <__udivdi3+0x9c>
  801a50:	39 ce                	cmp    %ecx,%esi
  801a52:	72 0a                	jb     801a5e <__udivdi3+0x6a>
  801a54:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801a58:	0f 87 9e 00 00 00    	ja     801afc <__udivdi3+0x108>
  801a5e:	b8 01 00 00 00       	mov    $0x1,%eax
  801a63:	89 fa                	mov    %edi,%edx
  801a65:	83 c4 1c             	add    $0x1c,%esp
  801a68:	5b                   	pop    %ebx
  801a69:	5e                   	pop    %esi
  801a6a:	5f                   	pop    %edi
  801a6b:	5d                   	pop    %ebp
  801a6c:	c3                   	ret    
  801a6d:	8d 76 00             	lea    0x0(%esi),%esi
  801a70:	31 ff                	xor    %edi,%edi
  801a72:	31 c0                	xor    %eax,%eax
  801a74:	89 fa                	mov    %edi,%edx
  801a76:	83 c4 1c             	add    $0x1c,%esp
  801a79:	5b                   	pop    %ebx
  801a7a:	5e                   	pop    %esi
  801a7b:	5f                   	pop    %edi
  801a7c:	5d                   	pop    %ebp
  801a7d:	c3                   	ret    
  801a7e:	66 90                	xchg   %ax,%ax
  801a80:	89 d8                	mov    %ebx,%eax
  801a82:	f7 f7                	div    %edi
  801a84:	31 ff                	xor    %edi,%edi
  801a86:	89 fa                	mov    %edi,%edx
  801a88:	83 c4 1c             	add    $0x1c,%esp
  801a8b:	5b                   	pop    %ebx
  801a8c:	5e                   	pop    %esi
  801a8d:	5f                   	pop    %edi
  801a8e:	5d                   	pop    %ebp
  801a8f:	c3                   	ret    
  801a90:	bd 20 00 00 00       	mov    $0x20,%ebp
  801a95:	89 eb                	mov    %ebp,%ebx
  801a97:	29 fb                	sub    %edi,%ebx
  801a99:	89 f9                	mov    %edi,%ecx
  801a9b:	d3 e6                	shl    %cl,%esi
  801a9d:	89 c5                	mov    %eax,%ebp
  801a9f:	88 d9                	mov    %bl,%cl
  801aa1:	d3 ed                	shr    %cl,%ebp
  801aa3:	89 e9                	mov    %ebp,%ecx
  801aa5:	09 f1                	or     %esi,%ecx
  801aa7:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801aab:	89 f9                	mov    %edi,%ecx
  801aad:	d3 e0                	shl    %cl,%eax
  801aaf:	89 c5                	mov    %eax,%ebp
  801ab1:	89 d6                	mov    %edx,%esi
  801ab3:	88 d9                	mov    %bl,%cl
  801ab5:	d3 ee                	shr    %cl,%esi
  801ab7:	89 f9                	mov    %edi,%ecx
  801ab9:	d3 e2                	shl    %cl,%edx
  801abb:	8b 44 24 08          	mov    0x8(%esp),%eax
  801abf:	88 d9                	mov    %bl,%cl
  801ac1:	d3 e8                	shr    %cl,%eax
  801ac3:	09 c2                	or     %eax,%edx
  801ac5:	89 d0                	mov    %edx,%eax
  801ac7:	89 f2                	mov    %esi,%edx
  801ac9:	f7 74 24 0c          	divl   0xc(%esp)
  801acd:	89 d6                	mov    %edx,%esi
  801acf:	89 c3                	mov    %eax,%ebx
  801ad1:	f7 e5                	mul    %ebp
  801ad3:	39 d6                	cmp    %edx,%esi
  801ad5:	72 19                	jb     801af0 <__udivdi3+0xfc>
  801ad7:	74 0b                	je     801ae4 <__udivdi3+0xf0>
  801ad9:	89 d8                	mov    %ebx,%eax
  801adb:	31 ff                	xor    %edi,%edi
  801add:	e9 58 ff ff ff       	jmp    801a3a <__udivdi3+0x46>
  801ae2:	66 90                	xchg   %ax,%ax
  801ae4:	8b 54 24 08          	mov    0x8(%esp),%edx
  801ae8:	89 f9                	mov    %edi,%ecx
  801aea:	d3 e2                	shl    %cl,%edx
  801aec:	39 c2                	cmp    %eax,%edx
  801aee:	73 e9                	jae    801ad9 <__udivdi3+0xe5>
  801af0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801af3:	31 ff                	xor    %edi,%edi
  801af5:	e9 40 ff ff ff       	jmp    801a3a <__udivdi3+0x46>
  801afa:	66 90                	xchg   %ax,%ax
  801afc:	31 c0                	xor    %eax,%eax
  801afe:	e9 37 ff ff ff       	jmp    801a3a <__udivdi3+0x46>
  801b03:	90                   	nop

00801b04 <__umoddi3>:
  801b04:	55                   	push   %ebp
  801b05:	57                   	push   %edi
  801b06:	56                   	push   %esi
  801b07:	53                   	push   %ebx
  801b08:	83 ec 1c             	sub    $0x1c,%esp
  801b0b:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801b0f:	8b 74 24 34          	mov    0x34(%esp),%esi
  801b13:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801b17:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801b1b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801b1f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801b23:	89 f3                	mov    %esi,%ebx
  801b25:	89 fa                	mov    %edi,%edx
  801b27:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801b2b:	89 34 24             	mov    %esi,(%esp)
  801b2e:	85 c0                	test   %eax,%eax
  801b30:	75 1a                	jne    801b4c <__umoddi3+0x48>
  801b32:	39 f7                	cmp    %esi,%edi
  801b34:	0f 86 a2 00 00 00    	jbe    801bdc <__umoddi3+0xd8>
  801b3a:	89 c8                	mov    %ecx,%eax
  801b3c:	89 f2                	mov    %esi,%edx
  801b3e:	f7 f7                	div    %edi
  801b40:	89 d0                	mov    %edx,%eax
  801b42:	31 d2                	xor    %edx,%edx
  801b44:	83 c4 1c             	add    $0x1c,%esp
  801b47:	5b                   	pop    %ebx
  801b48:	5e                   	pop    %esi
  801b49:	5f                   	pop    %edi
  801b4a:	5d                   	pop    %ebp
  801b4b:	c3                   	ret    
  801b4c:	39 f0                	cmp    %esi,%eax
  801b4e:	0f 87 ac 00 00 00    	ja     801c00 <__umoddi3+0xfc>
  801b54:	0f bd e8             	bsr    %eax,%ebp
  801b57:	83 f5 1f             	xor    $0x1f,%ebp
  801b5a:	0f 84 ac 00 00 00    	je     801c0c <__umoddi3+0x108>
  801b60:	bf 20 00 00 00       	mov    $0x20,%edi
  801b65:	29 ef                	sub    %ebp,%edi
  801b67:	89 fe                	mov    %edi,%esi
  801b69:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801b6d:	89 e9                	mov    %ebp,%ecx
  801b6f:	d3 e0                	shl    %cl,%eax
  801b71:	89 d7                	mov    %edx,%edi
  801b73:	89 f1                	mov    %esi,%ecx
  801b75:	d3 ef                	shr    %cl,%edi
  801b77:	09 c7                	or     %eax,%edi
  801b79:	89 e9                	mov    %ebp,%ecx
  801b7b:	d3 e2                	shl    %cl,%edx
  801b7d:	89 14 24             	mov    %edx,(%esp)
  801b80:	89 d8                	mov    %ebx,%eax
  801b82:	d3 e0                	shl    %cl,%eax
  801b84:	89 c2                	mov    %eax,%edx
  801b86:	8b 44 24 08          	mov    0x8(%esp),%eax
  801b8a:	d3 e0                	shl    %cl,%eax
  801b8c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b90:	8b 44 24 08          	mov    0x8(%esp),%eax
  801b94:	89 f1                	mov    %esi,%ecx
  801b96:	d3 e8                	shr    %cl,%eax
  801b98:	09 d0                	or     %edx,%eax
  801b9a:	d3 eb                	shr    %cl,%ebx
  801b9c:	89 da                	mov    %ebx,%edx
  801b9e:	f7 f7                	div    %edi
  801ba0:	89 d3                	mov    %edx,%ebx
  801ba2:	f7 24 24             	mull   (%esp)
  801ba5:	89 c6                	mov    %eax,%esi
  801ba7:	89 d1                	mov    %edx,%ecx
  801ba9:	39 d3                	cmp    %edx,%ebx
  801bab:	0f 82 87 00 00 00    	jb     801c38 <__umoddi3+0x134>
  801bb1:	0f 84 91 00 00 00    	je     801c48 <__umoddi3+0x144>
  801bb7:	8b 54 24 04          	mov    0x4(%esp),%edx
  801bbb:	29 f2                	sub    %esi,%edx
  801bbd:	19 cb                	sbb    %ecx,%ebx
  801bbf:	89 d8                	mov    %ebx,%eax
  801bc1:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801bc5:	d3 e0                	shl    %cl,%eax
  801bc7:	89 e9                	mov    %ebp,%ecx
  801bc9:	d3 ea                	shr    %cl,%edx
  801bcb:	09 d0                	or     %edx,%eax
  801bcd:	89 e9                	mov    %ebp,%ecx
  801bcf:	d3 eb                	shr    %cl,%ebx
  801bd1:	89 da                	mov    %ebx,%edx
  801bd3:	83 c4 1c             	add    $0x1c,%esp
  801bd6:	5b                   	pop    %ebx
  801bd7:	5e                   	pop    %esi
  801bd8:	5f                   	pop    %edi
  801bd9:	5d                   	pop    %ebp
  801bda:	c3                   	ret    
  801bdb:	90                   	nop
  801bdc:	89 fd                	mov    %edi,%ebp
  801bde:	85 ff                	test   %edi,%edi
  801be0:	75 0b                	jne    801bed <__umoddi3+0xe9>
  801be2:	b8 01 00 00 00       	mov    $0x1,%eax
  801be7:	31 d2                	xor    %edx,%edx
  801be9:	f7 f7                	div    %edi
  801beb:	89 c5                	mov    %eax,%ebp
  801bed:	89 f0                	mov    %esi,%eax
  801bef:	31 d2                	xor    %edx,%edx
  801bf1:	f7 f5                	div    %ebp
  801bf3:	89 c8                	mov    %ecx,%eax
  801bf5:	f7 f5                	div    %ebp
  801bf7:	89 d0                	mov    %edx,%eax
  801bf9:	e9 44 ff ff ff       	jmp    801b42 <__umoddi3+0x3e>
  801bfe:	66 90                	xchg   %ax,%ax
  801c00:	89 c8                	mov    %ecx,%eax
  801c02:	89 f2                	mov    %esi,%edx
  801c04:	83 c4 1c             	add    $0x1c,%esp
  801c07:	5b                   	pop    %ebx
  801c08:	5e                   	pop    %esi
  801c09:	5f                   	pop    %edi
  801c0a:	5d                   	pop    %ebp
  801c0b:	c3                   	ret    
  801c0c:	3b 04 24             	cmp    (%esp),%eax
  801c0f:	72 06                	jb     801c17 <__umoddi3+0x113>
  801c11:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801c15:	77 0f                	ja     801c26 <__umoddi3+0x122>
  801c17:	89 f2                	mov    %esi,%edx
  801c19:	29 f9                	sub    %edi,%ecx
  801c1b:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801c1f:	89 14 24             	mov    %edx,(%esp)
  801c22:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801c26:	8b 44 24 04          	mov    0x4(%esp),%eax
  801c2a:	8b 14 24             	mov    (%esp),%edx
  801c2d:	83 c4 1c             	add    $0x1c,%esp
  801c30:	5b                   	pop    %ebx
  801c31:	5e                   	pop    %esi
  801c32:	5f                   	pop    %edi
  801c33:	5d                   	pop    %ebp
  801c34:	c3                   	ret    
  801c35:	8d 76 00             	lea    0x0(%esi),%esi
  801c38:	2b 04 24             	sub    (%esp),%eax
  801c3b:	19 fa                	sbb    %edi,%edx
  801c3d:	89 d1                	mov    %edx,%ecx
  801c3f:	89 c6                	mov    %eax,%esi
  801c41:	e9 71 ff ff ff       	jmp    801bb7 <__umoddi3+0xb3>
  801c46:	66 90                	xchg   %ax,%ax
  801c48:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801c4c:	72 ea                	jb     801c38 <__umoddi3+0x134>
  801c4e:	89 d9                	mov    %ebx,%ecx
  801c50:	e9 62 ff ff ff       	jmp    801bb7 <__umoddi3+0xb3>
