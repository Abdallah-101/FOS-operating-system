
obj/user/tst_invalid_access_slave4:     file format elf32-i386


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
  800031:	e8 5c 00 00 00       	call   800092 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
/************************************************************/

#include <inc/lib.h>

void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	83 ec 18             	sub    $0x18,%esp
	//[4] Not in Page File, Not Stack & Not Heap
	uint32 kilo = 1024;
  80003e:	c7 45 f0 00 04 00 00 	movl   $0x400,-0x10(%ebp)
	{
		uint32 size = 4*kilo;
  800045:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800048:	c1 e0 02             	shl    $0x2,%eax
  80004b:	89 45 ec             	mov    %eax,-0x14(%ebp)

		unsigned char *x = (unsigned char *)(0x00200000-PAGE_SIZE);
  80004e:	c7 45 e8 00 f0 1f 00 	movl   $0x1ff000,-0x18(%ebp)

		int i=0;
  800055:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
		for(;i< size+20;i++)
  80005c:	eb 0e                	jmp    80006c <_main+0x34>
		{
			x[i]=-1;
  80005e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800061:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800064:	01 d0                	add    %edx,%eax
  800066:	c6 00 ff             	movb   $0xff,(%eax)
		uint32 size = 4*kilo;

		unsigned char *x = (unsigned char *)(0x00200000-PAGE_SIZE);

		int i=0;
		for(;i< size+20;i++)
  800069:	ff 45 f4             	incl   -0xc(%ebp)
  80006c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80006f:	8d 50 14             	lea    0x14(%eax),%edx
  800072:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800075:	39 c2                	cmp    %eax,%edx
  800077:	77 e5                	ja     80005e <_main+0x26>
		{
			x[i]=-1;
		}
	}

	inctst();
  800079:	e8 a6 17 00 00       	call   801824 <inctst>
	panic("tst invalid access failed: Attempt to access page that's not exist in page file, neither stack or heap.\nThe env must be killed and shouldn't return here.");
  80007e:	83 ec 04             	sub    $0x4,%esp
  800081:	68 20 1c 80 00       	push   $0x801c20
  800086:	6a 18                	push   $0x18
  800088:	68 bc 1c 80 00       	push   $0x801cbc
  80008d:	e8 b9 01 00 00       	call   80024b <_panic>

00800092 <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  800092:	55                   	push   %ebp
  800093:	89 e5                	mov    %esp,%ebp
  800095:	57                   	push   %edi
  800096:	56                   	push   %esi
  800097:	53                   	push   %ebx
  800098:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  80009b:	e8 46 16 00 00       	call   8016e6 <sys_getenvindex>
  8000a0:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  8000a3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8000a6:	89 d0                	mov    %edx,%eax
  8000a8:	c1 e0 02             	shl    $0x2,%eax
  8000ab:	01 d0                	add    %edx,%eax
  8000ad:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8000b4:	01 d0                	add    %edx,%eax
  8000b6:	89 c2                	mov    %eax,%edx
  8000b8:	c1 e2 04             	shl    $0x4,%edx
  8000bb:	29 c2                	sub    %eax,%edx
  8000bd:	8d 04 95 00 00 00 00 	lea    0x0(,%edx,4),%eax
  8000c4:	89 c2                	mov    %eax,%edx
  8000c6:	8d 82 00 00 c0 ee    	lea    -0x11400000(%edx),%eax
  8000cc:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8000d1:	a1 20 30 80 00       	mov    0x803020,%eax
  8000d6:	8a 40 20             	mov    0x20(%eax),%al
  8000d9:	84 c0                	test   %al,%al
  8000db:	74 0d                	je     8000ea <libmain+0x58>
		binaryname = myEnv->prog_name;
  8000dd:	a1 20 30 80 00       	mov    0x803020,%eax
  8000e2:	83 c0 20             	add    $0x20,%eax
  8000e5:	a3 04 30 80 00       	mov    %eax,0x803004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000ea:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8000ee:	7e 0a                	jle    8000fa <libmain+0x68>
		binaryname = argv[0];
  8000f0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8000f3:	8b 00                	mov    (%eax),%eax
  8000f5:	a3 04 30 80 00       	mov    %eax,0x803004

	// call user main routine
	_main(argc, argv);
  8000fa:	83 ec 08             	sub    $0x8,%esp
  8000fd:	ff 75 0c             	pushl  0xc(%ebp)
  800100:	ff 75 08             	pushl  0x8(%ebp)
  800103:	e8 30 ff ff ff       	call   800038 <_main>
  800108:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  80010b:	a1 00 30 80 00       	mov    0x803000,%eax
  800110:	85 c0                	test   %eax,%eax
  800112:	0f 84 01 01 00 00    	je     800219 <libmain+0x187>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  800118:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  80011e:	bb d8 1d 80 00       	mov    $0x801dd8,%ebx
  800123:	ba 0e 00 00 00       	mov    $0xe,%edx
  800128:	89 c7                	mov    %eax,%edi
  80012a:	89 de                	mov    %ebx,%esi
  80012c:	89 d1                	mov    %edx,%ecx
  80012e:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  800130:	8d 55 8a             	lea    -0x76(%ebp),%edx
  800133:	b9 56 00 00 00       	mov    $0x56,%ecx
  800138:	b0 00                	mov    $0x0,%al
  80013a:	89 d7                	mov    %edx,%edi
  80013c:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  80013e:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  800145:	8d 45 e0             	lea    -0x20(%ebp),%eax
  800148:	83 ec 08             	sub    $0x8,%esp
  80014b:	50                   	push   %eax
  80014c:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  800152:	50                   	push   %eax
  800153:	e8 c4 17 00 00       	call   80191c <sys_utilities>
  800158:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  80015b:	e8 0d 13 00 00       	call   80146d <sys_lock_cons>
		{
			cprintf("**************************************\n");
  800160:	83 ec 0c             	sub    $0xc,%esp
  800163:	68 f8 1c 80 00       	push   $0x801cf8
  800168:	e8 ac 03 00 00       	call   800519 <cprintf>
  80016d:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  800170:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800173:	85 c0                	test   %eax,%eax
  800175:	74 18                	je     80018f <libmain+0xfd>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  800177:	e8 be 17 00 00       	call   80193a <sys_get_optimal_num_faults>
  80017c:	83 ec 08             	sub    $0x8,%esp
  80017f:	50                   	push   %eax
  800180:	68 20 1d 80 00       	push   $0x801d20
  800185:	e8 8f 03 00 00       	call   800519 <cprintf>
  80018a:	83 c4 10             	add    $0x10,%esp
  80018d:	eb 59                	jmp    8001e8 <libmain+0x156>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  80018f:	a1 20 30 80 00       	mov    0x803020,%eax
  800194:	8b 90 bc 05 00 00    	mov    0x5bc(%eax),%edx
  80019a:	a1 20 30 80 00       	mov    0x803020,%eax
  80019f:	8b 80 ac 05 00 00    	mov    0x5ac(%eax),%eax
  8001a5:	83 ec 04             	sub    $0x4,%esp
  8001a8:	52                   	push   %edx
  8001a9:	50                   	push   %eax
  8001aa:	68 44 1d 80 00       	push   $0x801d44
  8001af:	e8 65 03 00 00       	call   800519 <cprintf>
  8001b4:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8001b7:	a1 20 30 80 00       	mov    0x803020,%eax
  8001bc:	8b 88 d0 05 00 00    	mov    0x5d0(%eax),%ecx
  8001c2:	a1 20 30 80 00       	mov    0x803020,%eax
  8001c7:	8b 90 cc 05 00 00    	mov    0x5cc(%eax),%edx
  8001cd:	a1 20 30 80 00       	mov    0x803020,%eax
  8001d2:	8b 80 c8 05 00 00    	mov    0x5c8(%eax),%eax
  8001d8:	51                   	push   %ecx
  8001d9:	52                   	push   %edx
  8001da:	50                   	push   %eax
  8001db:	68 6c 1d 80 00       	push   $0x801d6c
  8001e0:	e8 34 03 00 00       	call   800519 <cprintf>
  8001e5:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8001e8:	a1 20 30 80 00       	mov    0x803020,%eax
  8001ed:	8b 80 d4 05 00 00    	mov    0x5d4(%eax),%eax
  8001f3:	83 ec 08             	sub    $0x8,%esp
  8001f6:	50                   	push   %eax
  8001f7:	68 c4 1d 80 00       	push   $0x801dc4
  8001fc:	e8 18 03 00 00       	call   800519 <cprintf>
  800201:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  800204:	83 ec 0c             	sub    $0xc,%esp
  800207:	68 f8 1c 80 00       	push   $0x801cf8
  80020c:	e8 08 03 00 00       	call   800519 <cprintf>
  800211:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  800214:	e8 6e 12 00 00       	call   801487 <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  800219:	e8 1f 00 00 00       	call   80023d <exit>
}
  80021e:	90                   	nop
  80021f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800222:	5b                   	pop    %ebx
  800223:	5e                   	pop    %esi
  800224:	5f                   	pop    %edi
  800225:	5d                   	pop    %ebp
  800226:	c3                   	ret    

00800227 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800227:	55                   	push   %ebp
  800228:	89 e5                	mov    %esp,%ebp
  80022a:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  80022d:	83 ec 0c             	sub    $0xc,%esp
  800230:	6a 00                	push   $0x0
  800232:	e8 7b 14 00 00       	call   8016b2 <sys_destroy_env>
  800237:	83 c4 10             	add    $0x10,%esp
}
  80023a:	90                   	nop
  80023b:	c9                   	leave  
  80023c:	c3                   	ret    

0080023d <exit>:

void
exit(void)
{
  80023d:	55                   	push   %ebp
  80023e:	89 e5                	mov    %esp,%ebp
  800240:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800243:	e8 d0 14 00 00       	call   801718 <sys_exit_env>
}
  800248:	90                   	nop
  800249:	c9                   	leave  
  80024a:	c3                   	ret    

0080024b <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  80024b:	55                   	push   %ebp
  80024c:	89 e5                	mov    %esp,%ebp
  80024e:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800251:	8d 45 10             	lea    0x10(%ebp),%eax
  800254:	83 c0 04             	add    $0x4,%eax
  800257:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  80025a:	a1 18 b1 81 00       	mov    0x81b118,%eax
  80025f:	85 c0                	test   %eax,%eax
  800261:	74 16                	je     800279 <_panic+0x2e>
		cprintf("%s: ", argv0);
  800263:	a1 18 b1 81 00       	mov    0x81b118,%eax
  800268:	83 ec 08             	sub    $0x8,%esp
  80026b:	50                   	push   %eax
  80026c:	68 3c 1e 80 00       	push   $0x801e3c
  800271:	e8 a3 02 00 00       	call   800519 <cprintf>
  800276:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  800279:	a1 04 30 80 00       	mov    0x803004,%eax
  80027e:	83 ec 0c             	sub    $0xc,%esp
  800281:	ff 75 0c             	pushl  0xc(%ebp)
  800284:	ff 75 08             	pushl  0x8(%ebp)
  800287:	50                   	push   %eax
  800288:	68 44 1e 80 00       	push   $0x801e44
  80028d:	6a 74                	push   $0x74
  80028f:	e8 b2 02 00 00       	call   800546 <cprintf_colored>
  800294:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  800297:	8b 45 10             	mov    0x10(%ebp),%eax
  80029a:	83 ec 08             	sub    $0x8,%esp
  80029d:	ff 75 f4             	pushl  -0xc(%ebp)
  8002a0:	50                   	push   %eax
  8002a1:	e8 04 02 00 00       	call   8004aa <vcprintf>
  8002a6:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8002a9:	83 ec 08             	sub    $0x8,%esp
  8002ac:	6a 00                	push   $0x0
  8002ae:	68 6c 1e 80 00       	push   $0x801e6c
  8002b3:	e8 f2 01 00 00       	call   8004aa <vcprintf>
  8002b8:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8002bb:	e8 7d ff ff ff       	call   80023d <exit>

	// should not return here
	while (1) ;
  8002c0:	eb fe                	jmp    8002c0 <_panic+0x75>

008002c2 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8002c2:	55                   	push   %ebp
  8002c3:	89 e5                	mov    %esp,%ebp
  8002c5:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8002c8:	a1 20 30 80 00       	mov    0x803020,%eax
  8002cd:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8002d3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002d6:	39 c2                	cmp    %eax,%edx
  8002d8:	74 14                	je     8002ee <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8002da:	83 ec 04             	sub    $0x4,%esp
  8002dd:	68 70 1e 80 00       	push   $0x801e70
  8002e2:	6a 26                	push   $0x26
  8002e4:	68 bc 1e 80 00       	push   $0x801ebc
  8002e9:	e8 5d ff ff ff       	call   80024b <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8002ee:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8002f5:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8002fc:	e9 c5 00 00 00       	jmp    8003c6 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  800301:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800304:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80030b:	8b 45 08             	mov    0x8(%ebp),%eax
  80030e:	01 d0                	add    %edx,%eax
  800310:	8b 00                	mov    (%eax),%eax
  800312:	85 c0                	test   %eax,%eax
  800314:	75 08                	jne    80031e <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  800316:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800319:	e9 a5 00 00 00       	jmp    8003c3 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  80031e:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800325:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  80032c:	eb 69                	jmp    800397 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  80032e:	a1 20 30 80 00       	mov    0x803020,%eax
  800333:	8b 88 a4 05 00 00    	mov    0x5a4(%eax),%ecx
  800339:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80033c:	89 d0                	mov    %edx,%eax
  80033e:	01 c0                	add    %eax,%eax
  800340:	01 d0                	add    %edx,%eax
  800342:	c1 e0 03             	shl    $0x3,%eax
  800345:	01 c8                	add    %ecx,%eax
  800347:	8a 40 04             	mov    0x4(%eax),%al
  80034a:	84 c0                	test   %al,%al
  80034c:	75 46                	jne    800394 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80034e:	a1 20 30 80 00       	mov    0x803020,%eax
  800353:	8b 88 a4 05 00 00    	mov    0x5a4(%eax),%ecx
  800359:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80035c:	89 d0                	mov    %edx,%eax
  80035e:	01 c0                	add    %eax,%eax
  800360:	01 d0                	add    %edx,%eax
  800362:	c1 e0 03             	shl    $0x3,%eax
  800365:	01 c8                	add    %ecx,%eax
  800367:	8b 00                	mov    (%eax),%eax
  800369:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80036c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80036f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800374:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800376:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800379:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800380:	8b 45 08             	mov    0x8(%ebp),%eax
  800383:	01 c8                	add    %ecx,%eax
  800385:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800387:	39 c2                	cmp    %eax,%edx
  800389:	75 09                	jne    800394 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  80038b:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800392:	eb 15                	jmp    8003a9 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800394:	ff 45 e8             	incl   -0x18(%ebp)
  800397:	a1 20 30 80 00       	mov    0x803020,%eax
  80039c:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8003a2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8003a5:	39 c2                	cmp    %eax,%edx
  8003a7:	77 85                	ja     80032e <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8003a9:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8003ad:	75 14                	jne    8003c3 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  8003af:	83 ec 04             	sub    $0x4,%esp
  8003b2:	68 c8 1e 80 00       	push   $0x801ec8
  8003b7:	6a 3a                	push   $0x3a
  8003b9:	68 bc 1e 80 00       	push   $0x801ebc
  8003be:	e8 88 fe ff ff       	call   80024b <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8003c3:	ff 45 f0             	incl   -0x10(%ebp)
  8003c6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003c9:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8003cc:	0f 8c 2f ff ff ff    	jl     800301 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8003d2:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8003d9:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8003e0:	eb 26                	jmp    800408 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  8003e2:	a1 20 30 80 00       	mov    0x803020,%eax
  8003e7:	8b 88 a4 05 00 00    	mov    0x5a4(%eax),%ecx
  8003ed:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8003f0:	89 d0                	mov    %edx,%eax
  8003f2:	01 c0                	add    %eax,%eax
  8003f4:	01 d0                	add    %edx,%eax
  8003f6:	c1 e0 03             	shl    $0x3,%eax
  8003f9:	01 c8                	add    %ecx,%eax
  8003fb:	8a 40 04             	mov    0x4(%eax),%al
  8003fe:	3c 01                	cmp    $0x1,%al
  800400:	75 03                	jne    800405 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  800402:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800405:	ff 45 e0             	incl   -0x20(%ebp)
  800408:	a1 20 30 80 00       	mov    0x803020,%eax
  80040d:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800413:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800416:	39 c2                	cmp    %eax,%edx
  800418:	77 c8                	ja     8003e2 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  80041a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80041d:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800420:	74 14                	je     800436 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  800422:	83 ec 04             	sub    $0x4,%esp
  800425:	68 1c 1f 80 00       	push   $0x801f1c
  80042a:	6a 44                	push   $0x44
  80042c:	68 bc 1e 80 00       	push   $0x801ebc
  800431:	e8 15 fe ff ff       	call   80024b <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800436:	90                   	nop
  800437:	c9                   	leave  
  800438:	c3                   	ret    

00800439 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  800439:	55                   	push   %ebp
  80043a:	89 e5                	mov    %esp,%ebp
  80043c:	53                   	push   %ebx
  80043d:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  800440:	8b 45 0c             	mov    0xc(%ebp),%eax
  800443:	8b 00                	mov    (%eax),%eax
  800445:	8d 48 01             	lea    0x1(%eax),%ecx
  800448:	8b 55 0c             	mov    0xc(%ebp),%edx
  80044b:	89 0a                	mov    %ecx,(%edx)
  80044d:	8b 55 08             	mov    0x8(%ebp),%edx
  800450:	88 d1                	mov    %dl,%cl
  800452:	8b 55 0c             	mov    0xc(%ebp),%edx
  800455:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800459:	8b 45 0c             	mov    0xc(%ebp),%eax
  80045c:	8b 00                	mov    (%eax),%eax
  80045e:	3d ff 00 00 00       	cmp    $0xff,%eax
  800463:	75 30                	jne    800495 <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  800465:	8b 15 1c b1 81 00    	mov    0x81b11c,%edx
  80046b:	a0 44 30 80 00       	mov    0x803044,%al
  800470:	0f b6 c0             	movzbl %al,%eax
  800473:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800476:	8b 09                	mov    (%ecx),%ecx
  800478:	89 cb                	mov    %ecx,%ebx
  80047a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80047d:	83 c1 08             	add    $0x8,%ecx
  800480:	52                   	push   %edx
  800481:	50                   	push   %eax
  800482:	53                   	push   %ebx
  800483:	51                   	push   %ecx
  800484:	e8 a0 0f 00 00       	call   801429 <sys_cputs>
  800489:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  80048c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80048f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800495:	8b 45 0c             	mov    0xc(%ebp),%eax
  800498:	8b 40 04             	mov    0x4(%eax),%eax
  80049b:	8d 50 01             	lea    0x1(%eax),%edx
  80049e:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004a1:	89 50 04             	mov    %edx,0x4(%eax)
}
  8004a4:	90                   	nop
  8004a5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8004a8:	c9                   	leave  
  8004a9:	c3                   	ret    

008004aa <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8004aa:	55                   	push   %ebp
  8004ab:	89 e5                	mov    %esp,%ebp
  8004ad:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8004b3:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8004ba:	00 00 00 
	b.cnt = 0;
  8004bd:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8004c4:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8004c7:	ff 75 0c             	pushl  0xc(%ebp)
  8004ca:	ff 75 08             	pushl  0x8(%ebp)
  8004cd:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8004d3:	50                   	push   %eax
  8004d4:	68 39 04 80 00       	push   $0x800439
  8004d9:	e8 5a 02 00 00       	call   800738 <vprintfmt>
  8004de:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  8004e1:	8b 15 1c b1 81 00    	mov    0x81b11c,%edx
  8004e7:	a0 44 30 80 00       	mov    0x803044,%al
  8004ec:	0f b6 c0             	movzbl %al,%eax
  8004ef:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  8004f5:	52                   	push   %edx
  8004f6:	50                   	push   %eax
  8004f7:	51                   	push   %ecx
  8004f8:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8004fe:	83 c0 08             	add    $0x8,%eax
  800501:	50                   	push   %eax
  800502:	e8 22 0f 00 00       	call   801429 <sys_cputs>
  800507:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  80050a:	c6 05 44 30 80 00 00 	movb   $0x0,0x803044
	return b.cnt;
  800511:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800517:	c9                   	leave  
  800518:	c3                   	ret    

00800519 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  800519:	55                   	push   %ebp
  80051a:	89 e5                	mov    %esp,%ebp
  80051c:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  80051f:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
	va_start(ap, fmt);
  800526:	8d 45 0c             	lea    0xc(%ebp),%eax
  800529:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80052c:	8b 45 08             	mov    0x8(%ebp),%eax
  80052f:	83 ec 08             	sub    $0x8,%esp
  800532:	ff 75 f4             	pushl  -0xc(%ebp)
  800535:	50                   	push   %eax
  800536:	e8 6f ff ff ff       	call   8004aa <vcprintf>
  80053b:	83 c4 10             	add    $0x10,%esp
  80053e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800541:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800544:	c9                   	leave  
  800545:	c3                   	ret    

00800546 <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  800546:	55                   	push   %ebp
  800547:	89 e5                	mov    %esp,%ebp
  800549:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  80054c:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
	curTextClr = (textClr << 8) ; //set text color by the given value
  800553:	8b 45 08             	mov    0x8(%ebp),%eax
  800556:	c1 e0 08             	shl    $0x8,%eax
  800559:	a3 1c b1 81 00       	mov    %eax,0x81b11c
	va_start(ap, fmt);
  80055e:	8d 45 0c             	lea    0xc(%ebp),%eax
  800561:	83 c0 04             	add    $0x4,%eax
  800564:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800567:	8b 45 0c             	mov    0xc(%ebp),%eax
  80056a:	83 ec 08             	sub    $0x8,%esp
  80056d:	ff 75 f4             	pushl  -0xc(%ebp)
  800570:	50                   	push   %eax
  800571:	e8 34 ff ff ff       	call   8004aa <vcprintf>
  800576:	83 c4 10             	add    $0x10,%esp
  800579:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  80057c:	c7 05 1c b1 81 00 00 	movl   $0x700,0x81b11c
  800583:	07 00 00 

	return cnt;
  800586:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800589:	c9                   	leave  
  80058a:	c3                   	ret    

0080058b <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  80058b:	55                   	push   %ebp
  80058c:	89 e5                	mov    %esp,%ebp
  80058e:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  800591:	e8 d7 0e 00 00       	call   80146d <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  800596:	8d 45 0c             	lea    0xc(%ebp),%eax
  800599:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  80059c:	8b 45 08             	mov    0x8(%ebp),%eax
  80059f:	83 ec 08             	sub    $0x8,%esp
  8005a2:	ff 75 f4             	pushl  -0xc(%ebp)
  8005a5:	50                   	push   %eax
  8005a6:	e8 ff fe ff ff       	call   8004aa <vcprintf>
  8005ab:	83 c4 10             	add    $0x10,%esp
  8005ae:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  8005b1:	e8 d1 0e 00 00       	call   801487 <sys_unlock_cons>
	return cnt;
  8005b6:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8005b9:	c9                   	leave  
  8005ba:	c3                   	ret    

008005bb <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8005bb:	55                   	push   %ebp
  8005bc:	89 e5                	mov    %esp,%ebp
  8005be:	53                   	push   %ebx
  8005bf:	83 ec 14             	sub    $0x14,%esp
  8005c2:	8b 45 10             	mov    0x10(%ebp),%eax
  8005c5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8005c8:	8b 45 14             	mov    0x14(%ebp),%eax
  8005cb:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8005ce:	8b 45 18             	mov    0x18(%ebp),%eax
  8005d1:	ba 00 00 00 00       	mov    $0x0,%edx
  8005d6:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8005d9:	77 55                	ja     800630 <printnum+0x75>
  8005db:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8005de:	72 05                	jb     8005e5 <printnum+0x2a>
  8005e0:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8005e3:	77 4b                	ja     800630 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8005e5:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8005e8:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8005eb:	8b 45 18             	mov    0x18(%ebp),%eax
  8005ee:	ba 00 00 00 00       	mov    $0x0,%edx
  8005f3:	52                   	push   %edx
  8005f4:	50                   	push   %eax
  8005f5:	ff 75 f4             	pushl  -0xc(%ebp)
  8005f8:	ff 75 f0             	pushl  -0x10(%ebp)
  8005fb:	e8 ac 13 00 00       	call   8019ac <__udivdi3>
  800600:	83 c4 10             	add    $0x10,%esp
  800603:	83 ec 04             	sub    $0x4,%esp
  800606:	ff 75 20             	pushl  0x20(%ebp)
  800609:	53                   	push   %ebx
  80060a:	ff 75 18             	pushl  0x18(%ebp)
  80060d:	52                   	push   %edx
  80060e:	50                   	push   %eax
  80060f:	ff 75 0c             	pushl  0xc(%ebp)
  800612:	ff 75 08             	pushl  0x8(%ebp)
  800615:	e8 a1 ff ff ff       	call   8005bb <printnum>
  80061a:	83 c4 20             	add    $0x20,%esp
  80061d:	eb 1a                	jmp    800639 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80061f:	83 ec 08             	sub    $0x8,%esp
  800622:	ff 75 0c             	pushl  0xc(%ebp)
  800625:	ff 75 20             	pushl  0x20(%ebp)
  800628:	8b 45 08             	mov    0x8(%ebp),%eax
  80062b:	ff d0                	call   *%eax
  80062d:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800630:	ff 4d 1c             	decl   0x1c(%ebp)
  800633:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800637:	7f e6                	jg     80061f <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800639:	8b 4d 18             	mov    0x18(%ebp),%ecx
  80063c:	bb 00 00 00 00       	mov    $0x0,%ebx
  800641:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800644:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800647:	53                   	push   %ebx
  800648:	51                   	push   %ecx
  800649:	52                   	push   %edx
  80064a:	50                   	push   %eax
  80064b:	e8 6c 14 00 00       	call   801abc <__umoddi3>
  800650:	83 c4 10             	add    $0x10,%esp
  800653:	05 94 21 80 00       	add    $0x802194,%eax
  800658:	8a 00                	mov    (%eax),%al
  80065a:	0f be c0             	movsbl %al,%eax
  80065d:	83 ec 08             	sub    $0x8,%esp
  800660:	ff 75 0c             	pushl  0xc(%ebp)
  800663:	50                   	push   %eax
  800664:	8b 45 08             	mov    0x8(%ebp),%eax
  800667:	ff d0                	call   *%eax
  800669:	83 c4 10             	add    $0x10,%esp
}
  80066c:	90                   	nop
  80066d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800670:	c9                   	leave  
  800671:	c3                   	ret    

00800672 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800672:	55                   	push   %ebp
  800673:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800675:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800679:	7e 1c                	jle    800697 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  80067b:	8b 45 08             	mov    0x8(%ebp),%eax
  80067e:	8b 00                	mov    (%eax),%eax
  800680:	8d 50 08             	lea    0x8(%eax),%edx
  800683:	8b 45 08             	mov    0x8(%ebp),%eax
  800686:	89 10                	mov    %edx,(%eax)
  800688:	8b 45 08             	mov    0x8(%ebp),%eax
  80068b:	8b 00                	mov    (%eax),%eax
  80068d:	83 e8 08             	sub    $0x8,%eax
  800690:	8b 50 04             	mov    0x4(%eax),%edx
  800693:	8b 00                	mov    (%eax),%eax
  800695:	eb 40                	jmp    8006d7 <getuint+0x65>
	else if (lflag)
  800697:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80069b:	74 1e                	je     8006bb <getuint+0x49>
		return va_arg(*ap, unsigned long);
  80069d:	8b 45 08             	mov    0x8(%ebp),%eax
  8006a0:	8b 00                	mov    (%eax),%eax
  8006a2:	8d 50 04             	lea    0x4(%eax),%edx
  8006a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8006a8:	89 10                	mov    %edx,(%eax)
  8006aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ad:	8b 00                	mov    (%eax),%eax
  8006af:	83 e8 04             	sub    $0x4,%eax
  8006b2:	8b 00                	mov    (%eax),%eax
  8006b4:	ba 00 00 00 00       	mov    $0x0,%edx
  8006b9:	eb 1c                	jmp    8006d7 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8006bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8006be:	8b 00                	mov    (%eax),%eax
  8006c0:	8d 50 04             	lea    0x4(%eax),%edx
  8006c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8006c6:	89 10                	mov    %edx,(%eax)
  8006c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8006cb:	8b 00                	mov    (%eax),%eax
  8006cd:	83 e8 04             	sub    $0x4,%eax
  8006d0:	8b 00                	mov    (%eax),%eax
  8006d2:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8006d7:	5d                   	pop    %ebp
  8006d8:	c3                   	ret    

008006d9 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8006d9:	55                   	push   %ebp
  8006da:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8006dc:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8006e0:	7e 1c                	jle    8006fe <getint+0x25>
		return va_arg(*ap, long long);
  8006e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8006e5:	8b 00                	mov    (%eax),%eax
  8006e7:	8d 50 08             	lea    0x8(%eax),%edx
  8006ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ed:	89 10                	mov    %edx,(%eax)
  8006ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8006f2:	8b 00                	mov    (%eax),%eax
  8006f4:	83 e8 08             	sub    $0x8,%eax
  8006f7:	8b 50 04             	mov    0x4(%eax),%edx
  8006fa:	8b 00                	mov    (%eax),%eax
  8006fc:	eb 38                	jmp    800736 <getint+0x5d>
	else if (lflag)
  8006fe:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800702:	74 1a                	je     80071e <getint+0x45>
		return va_arg(*ap, long);
  800704:	8b 45 08             	mov    0x8(%ebp),%eax
  800707:	8b 00                	mov    (%eax),%eax
  800709:	8d 50 04             	lea    0x4(%eax),%edx
  80070c:	8b 45 08             	mov    0x8(%ebp),%eax
  80070f:	89 10                	mov    %edx,(%eax)
  800711:	8b 45 08             	mov    0x8(%ebp),%eax
  800714:	8b 00                	mov    (%eax),%eax
  800716:	83 e8 04             	sub    $0x4,%eax
  800719:	8b 00                	mov    (%eax),%eax
  80071b:	99                   	cltd   
  80071c:	eb 18                	jmp    800736 <getint+0x5d>
	else
		return va_arg(*ap, int);
  80071e:	8b 45 08             	mov    0x8(%ebp),%eax
  800721:	8b 00                	mov    (%eax),%eax
  800723:	8d 50 04             	lea    0x4(%eax),%edx
  800726:	8b 45 08             	mov    0x8(%ebp),%eax
  800729:	89 10                	mov    %edx,(%eax)
  80072b:	8b 45 08             	mov    0x8(%ebp),%eax
  80072e:	8b 00                	mov    (%eax),%eax
  800730:	83 e8 04             	sub    $0x4,%eax
  800733:	8b 00                	mov    (%eax),%eax
  800735:	99                   	cltd   
}
  800736:	5d                   	pop    %ebp
  800737:	c3                   	ret    

00800738 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800738:	55                   	push   %ebp
  800739:	89 e5                	mov    %esp,%ebp
  80073b:	56                   	push   %esi
  80073c:	53                   	push   %ebx
  80073d:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800740:	eb 17                	jmp    800759 <vprintfmt+0x21>
			if (ch == '\0')
  800742:	85 db                	test   %ebx,%ebx
  800744:	0f 84 c1 03 00 00    	je     800b0b <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  80074a:	83 ec 08             	sub    $0x8,%esp
  80074d:	ff 75 0c             	pushl  0xc(%ebp)
  800750:	53                   	push   %ebx
  800751:	8b 45 08             	mov    0x8(%ebp),%eax
  800754:	ff d0                	call   *%eax
  800756:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800759:	8b 45 10             	mov    0x10(%ebp),%eax
  80075c:	8d 50 01             	lea    0x1(%eax),%edx
  80075f:	89 55 10             	mov    %edx,0x10(%ebp)
  800762:	8a 00                	mov    (%eax),%al
  800764:	0f b6 d8             	movzbl %al,%ebx
  800767:	83 fb 25             	cmp    $0x25,%ebx
  80076a:	75 d6                	jne    800742 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  80076c:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800770:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800777:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80077e:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800785:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80078c:	8b 45 10             	mov    0x10(%ebp),%eax
  80078f:	8d 50 01             	lea    0x1(%eax),%edx
  800792:	89 55 10             	mov    %edx,0x10(%ebp)
  800795:	8a 00                	mov    (%eax),%al
  800797:	0f b6 d8             	movzbl %al,%ebx
  80079a:	8d 43 dd             	lea    -0x23(%ebx),%eax
  80079d:	83 f8 5b             	cmp    $0x5b,%eax
  8007a0:	0f 87 3d 03 00 00    	ja     800ae3 <vprintfmt+0x3ab>
  8007a6:	8b 04 85 b8 21 80 00 	mov    0x8021b8(,%eax,4),%eax
  8007ad:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8007af:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8007b3:	eb d7                	jmp    80078c <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8007b5:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8007b9:	eb d1                	jmp    80078c <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8007bb:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8007c2:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8007c5:	89 d0                	mov    %edx,%eax
  8007c7:	c1 e0 02             	shl    $0x2,%eax
  8007ca:	01 d0                	add    %edx,%eax
  8007cc:	01 c0                	add    %eax,%eax
  8007ce:	01 d8                	add    %ebx,%eax
  8007d0:	83 e8 30             	sub    $0x30,%eax
  8007d3:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8007d6:	8b 45 10             	mov    0x10(%ebp),%eax
  8007d9:	8a 00                	mov    (%eax),%al
  8007db:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8007de:	83 fb 2f             	cmp    $0x2f,%ebx
  8007e1:	7e 3e                	jle    800821 <vprintfmt+0xe9>
  8007e3:	83 fb 39             	cmp    $0x39,%ebx
  8007e6:	7f 39                	jg     800821 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8007e8:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8007eb:	eb d5                	jmp    8007c2 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8007ed:	8b 45 14             	mov    0x14(%ebp),%eax
  8007f0:	83 c0 04             	add    $0x4,%eax
  8007f3:	89 45 14             	mov    %eax,0x14(%ebp)
  8007f6:	8b 45 14             	mov    0x14(%ebp),%eax
  8007f9:	83 e8 04             	sub    $0x4,%eax
  8007fc:	8b 00                	mov    (%eax),%eax
  8007fe:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800801:	eb 1f                	jmp    800822 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800803:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800807:	79 83                	jns    80078c <vprintfmt+0x54>
				width = 0;
  800809:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800810:	e9 77 ff ff ff       	jmp    80078c <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800815:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  80081c:	e9 6b ff ff ff       	jmp    80078c <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800821:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800822:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800826:	0f 89 60 ff ff ff    	jns    80078c <vprintfmt+0x54>
				width = precision, precision = -1;
  80082c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80082f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800832:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800839:	e9 4e ff ff ff       	jmp    80078c <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  80083e:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800841:	e9 46 ff ff ff       	jmp    80078c <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800846:	8b 45 14             	mov    0x14(%ebp),%eax
  800849:	83 c0 04             	add    $0x4,%eax
  80084c:	89 45 14             	mov    %eax,0x14(%ebp)
  80084f:	8b 45 14             	mov    0x14(%ebp),%eax
  800852:	83 e8 04             	sub    $0x4,%eax
  800855:	8b 00                	mov    (%eax),%eax
  800857:	83 ec 08             	sub    $0x8,%esp
  80085a:	ff 75 0c             	pushl  0xc(%ebp)
  80085d:	50                   	push   %eax
  80085e:	8b 45 08             	mov    0x8(%ebp),%eax
  800861:	ff d0                	call   *%eax
  800863:	83 c4 10             	add    $0x10,%esp
			break;
  800866:	e9 9b 02 00 00       	jmp    800b06 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  80086b:	8b 45 14             	mov    0x14(%ebp),%eax
  80086e:	83 c0 04             	add    $0x4,%eax
  800871:	89 45 14             	mov    %eax,0x14(%ebp)
  800874:	8b 45 14             	mov    0x14(%ebp),%eax
  800877:	83 e8 04             	sub    $0x4,%eax
  80087a:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  80087c:	85 db                	test   %ebx,%ebx
  80087e:	79 02                	jns    800882 <vprintfmt+0x14a>
				err = -err;
  800880:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800882:	83 fb 64             	cmp    $0x64,%ebx
  800885:	7f 0b                	jg     800892 <vprintfmt+0x15a>
  800887:	8b 34 9d 00 20 80 00 	mov    0x802000(,%ebx,4),%esi
  80088e:	85 f6                	test   %esi,%esi
  800890:	75 19                	jne    8008ab <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800892:	53                   	push   %ebx
  800893:	68 a5 21 80 00       	push   $0x8021a5
  800898:	ff 75 0c             	pushl  0xc(%ebp)
  80089b:	ff 75 08             	pushl  0x8(%ebp)
  80089e:	e8 70 02 00 00       	call   800b13 <printfmt>
  8008a3:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8008a6:	e9 5b 02 00 00       	jmp    800b06 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8008ab:	56                   	push   %esi
  8008ac:	68 ae 21 80 00       	push   $0x8021ae
  8008b1:	ff 75 0c             	pushl  0xc(%ebp)
  8008b4:	ff 75 08             	pushl  0x8(%ebp)
  8008b7:	e8 57 02 00 00       	call   800b13 <printfmt>
  8008bc:	83 c4 10             	add    $0x10,%esp
			break;
  8008bf:	e9 42 02 00 00       	jmp    800b06 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8008c4:	8b 45 14             	mov    0x14(%ebp),%eax
  8008c7:	83 c0 04             	add    $0x4,%eax
  8008ca:	89 45 14             	mov    %eax,0x14(%ebp)
  8008cd:	8b 45 14             	mov    0x14(%ebp),%eax
  8008d0:	83 e8 04             	sub    $0x4,%eax
  8008d3:	8b 30                	mov    (%eax),%esi
  8008d5:	85 f6                	test   %esi,%esi
  8008d7:	75 05                	jne    8008de <vprintfmt+0x1a6>
				p = "(null)";
  8008d9:	be b1 21 80 00       	mov    $0x8021b1,%esi
			if (width > 0 && padc != '-')
  8008de:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008e2:	7e 6d                	jle    800951 <vprintfmt+0x219>
  8008e4:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8008e8:	74 67                	je     800951 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8008ea:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8008ed:	83 ec 08             	sub    $0x8,%esp
  8008f0:	50                   	push   %eax
  8008f1:	56                   	push   %esi
  8008f2:	e8 1e 03 00 00       	call   800c15 <strnlen>
  8008f7:	83 c4 10             	add    $0x10,%esp
  8008fa:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  8008fd:	eb 16                	jmp    800915 <vprintfmt+0x1dd>
					putch(padc, putdat);
  8008ff:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800903:	83 ec 08             	sub    $0x8,%esp
  800906:	ff 75 0c             	pushl  0xc(%ebp)
  800909:	50                   	push   %eax
  80090a:	8b 45 08             	mov    0x8(%ebp),%eax
  80090d:	ff d0                	call   *%eax
  80090f:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800912:	ff 4d e4             	decl   -0x1c(%ebp)
  800915:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800919:	7f e4                	jg     8008ff <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80091b:	eb 34                	jmp    800951 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  80091d:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800921:	74 1c                	je     80093f <vprintfmt+0x207>
  800923:	83 fb 1f             	cmp    $0x1f,%ebx
  800926:	7e 05                	jle    80092d <vprintfmt+0x1f5>
  800928:	83 fb 7e             	cmp    $0x7e,%ebx
  80092b:	7e 12                	jle    80093f <vprintfmt+0x207>
					putch('?', putdat);
  80092d:	83 ec 08             	sub    $0x8,%esp
  800930:	ff 75 0c             	pushl  0xc(%ebp)
  800933:	6a 3f                	push   $0x3f
  800935:	8b 45 08             	mov    0x8(%ebp),%eax
  800938:	ff d0                	call   *%eax
  80093a:	83 c4 10             	add    $0x10,%esp
  80093d:	eb 0f                	jmp    80094e <vprintfmt+0x216>
				else
					putch(ch, putdat);
  80093f:	83 ec 08             	sub    $0x8,%esp
  800942:	ff 75 0c             	pushl  0xc(%ebp)
  800945:	53                   	push   %ebx
  800946:	8b 45 08             	mov    0x8(%ebp),%eax
  800949:	ff d0                	call   *%eax
  80094b:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80094e:	ff 4d e4             	decl   -0x1c(%ebp)
  800951:	89 f0                	mov    %esi,%eax
  800953:	8d 70 01             	lea    0x1(%eax),%esi
  800956:	8a 00                	mov    (%eax),%al
  800958:	0f be d8             	movsbl %al,%ebx
  80095b:	85 db                	test   %ebx,%ebx
  80095d:	74 24                	je     800983 <vprintfmt+0x24b>
  80095f:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800963:	78 b8                	js     80091d <vprintfmt+0x1e5>
  800965:	ff 4d e0             	decl   -0x20(%ebp)
  800968:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80096c:	79 af                	jns    80091d <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80096e:	eb 13                	jmp    800983 <vprintfmt+0x24b>
				putch(' ', putdat);
  800970:	83 ec 08             	sub    $0x8,%esp
  800973:	ff 75 0c             	pushl  0xc(%ebp)
  800976:	6a 20                	push   $0x20
  800978:	8b 45 08             	mov    0x8(%ebp),%eax
  80097b:	ff d0                	call   *%eax
  80097d:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800980:	ff 4d e4             	decl   -0x1c(%ebp)
  800983:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800987:	7f e7                	jg     800970 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800989:	e9 78 01 00 00       	jmp    800b06 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  80098e:	83 ec 08             	sub    $0x8,%esp
  800991:	ff 75 e8             	pushl  -0x18(%ebp)
  800994:	8d 45 14             	lea    0x14(%ebp),%eax
  800997:	50                   	push   %eax
  800998:	e8 3c fd ff ff       	call   8006d9 <getint>
  80099d:	83 c4 10             	add    $0x10,%esp
  8009a0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009a3:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  8009a6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009a9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8009ac:	85 d2                	test   %edx,%edx
  8009ae:	79 23                	jns    8009d3 <vprintfmt+0x29b>
				putch('-', putdat);
  8009b0:	83 ec 08             	sub    $0x8,%esp
  8009b3:	ff 75 0c             	pushl  0xc(%ebp)
  8009b6:	6a 2d                	push   $0x2d
  8009b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8009bb:	ff d0                	call   *%eax
  8009bd:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  8009c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009c3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8009c6:	f7 d8                	neg    %eax
  8009c8:	83 d2 00             	adc    $0x0,%edx
  8009cb:	f7 da                	neg    %edx
  8009cd:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009d0:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8009d3:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8009da:	e9 bc 00 00 00       	jmp    800a9b <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8009df:	83 ec 08             	sub    $0x8,%esp
  8009e2:	ff 75 e8             	pushl  -0x18(%ebp)
  8009e5:	8d 45 14             	lea    0x14(%ebp),%eax
  8009e8:	50                   	push   %eax
  8009e9:	e8 84 fc ff ff       	call   800672 <getuint>
  8009ee:	83 c4 10             	add    $0x10,%esp
  8009f1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009f4:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  8009f7:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8009fe:	e9 98 00 00 00       	jmp    800a9b <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800a03:	83 ec 08             	sub    $0x8,%esp
  800a06:	ff 75 0c             	pushl  0xc(%ebp)
  800a09:	6a 58                	push   $0x58
  800a0b:	8b 45 08             	mov    0x8(%ebp),%eax
  800a0e:	ff d0                	call   *%eax
  800a10:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800a13:	83 ec 08             	sub    $0x8,%esp
  800a16:	ff 75 0c             	pushl  0xc(%ebp)
  800a19:	6a 58                	push   $0x58
  800a1b:	8b 45 08             	mov    0x8(%ebp),%eax
  800a1e:	ff d0                	call   *%eax
  800a20:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800a23:	83 ec 08             	sub    $0x8,%esp
  800a26:	ff 75 0c             	pushl  0xc(%ebp)
  800a29:	6a 58                	push   $0x58
  800a2b:	8b 45 08             	mov    0x8(%ebp),%eax
  800a2e:	ff d0                	call   *%eax
  800a30:	83 c4 10             	add    $0x10,%esp
			break;
  800a33:	e9 ce 00 00 00       	jmp    800b06 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800a38:	83 ec 08             	sub    $0x8,%esp
  800a3b:	ff 75 0c             	pushl  0xc(%ebp)
  800a3e:	6a 30                	push   $0x30
  800a40:	8b 45 08             	mov    0x8(%ebp),%eax
  800a43:	ff d0                	call   *%eax
  800a45:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800a48:	83 ec 08             	sub    $0x8,%esp
  800a4b:	ff 75 0c             	pushl  0xc(%ebp)
  800a4e:	6a 78                	push   $0x78
  800a50:	8b 45 08             	mov    0x8(%ebp),%eax
  800a53:	ff d0                	call   *%eax
  800a55:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800a58:	8b 45 14             	mov    0x14(%ebp),%eax
  800a5b:	83 c0 04             	add    $0x4,%eax
  800a5e:	89 45 14             	mov    %eax,0x14(%ebp)
  800a61:	8b 45 14             	mov    0x14(%ebp),%eax
  800a64:	83 e8 04             	sub    $0x4,%eax
  800a67:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800a69:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a6c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800a73:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800a7a:	eb 1f                	jmp    800a9b <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800a7c:	83 ec 08             	sub    $0x8,%esp
  800a7f:	ff 75 e8             	pushl  -0x18(%ebp)
  800a82:	8d 45 14             	lea    0x14(%ebp),%eax
  800a85:	50                   	push   %eax
  800a86:	e8 e7 fb ff ff       	call   800672 <getuint>
  800a8b:	83 c4 10             	add    $0x10,%esp
  800a8e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a91:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800a94:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800a9b:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800a9f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800aa2:	83 ec 04             	sub    $0x4,%esp
  800aa5:	52                   	push   %edx
  800aa6:	ff 75 e4             	pushl  -0x1c(%ebp)
  800aa9:	50                   	push   %eax
  800aaa:	ff 75 f4             	pushl  -0xc(%ebp)
  800aad:	ff 75 f0             	pushl  -0x10(%ebp)
  800ab0:	ff 75 0c             	pushl  0xc(%ebp)
  800ab3:	ff 75 08             	pushl  0x8(%ebp)
  800ab6:	e8 00 fb ff ff       	call   8005bb <printnum>
  800abb:	83 c4 20             	add    $0x20,%esp
			break;
  800abe:	eb 46                	jmp    800b06 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800ac0:	83 ec 08             	sub    $0x8,%esp
  800ac3:	ff 75 0c             	pushl  0xc(%ebp)
  800ac6:	53                   	push   %ebx
  800ac7:	8b 45 08             	mov    0x8(%ebp),%eax
  800aca:	ff d0                	call   *%eax
  800acc:	83 c4 10             	add    $0x10,%esp
			break;
  800acf:	eb 35                	jmp    800b06 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800ad1:	c6 05 44 30 80 00 00 	movb   $0x0,0x803044
			break;
  800ad8:	eb 2c                	jmp    800b06 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800ada:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
			break;
  800ae1:	eb 23                	jmp    800b06 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800ae3:	83 ec 08             	sub    $0x8,%esp
  800ae6:	ff 75 0c             	pushl  0xc(%ebp)
  800ae9:	6a 25                	push   $0x25
  800aeb:	8b 45 08             	mov    0x8(%ebp),%eax
  800aee:	ff d0                	call   *%eax
  800af0:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800af3:	ff 4d 10             	decl   0x10(%ebp)
  800af6:	eb 03                	jmp    800afb <vprintfmt+0x3c3>
  800af8:	ff 4d 10             	decl   0x10(%ebp)
  800afb:	8b 45 10             	mov    0x10(%ebp),%eax
  800afe:	48                   	dec    %eax
  800aff:	8a 00                	mov    (%eax),%al
  800b01:	3c 25                	cmp    $0x25,%al
  800b03:	75 f3                	jne    800af8 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800b05:	90                   	nop
		}
	}
  800b06:	e9 35 fc ff ff       	jmp    800740 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800b0b:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800b0c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800b0f:	5b                   	pop    %ebx
  800b10:	5e                   	pop    %esi
  800b11:	5d                   	pop    %ebp
  800b12:	c3                   	ret    

00800b13 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800b13:	55                   	push   %ebp
  800b14:	89 e5                	mov    %esp,%ebp
  800b16:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800b19:	8d 45 10             	lea    0x10(%ebp),%eax
  800b1c:	83 c0 04             	add    $0x4,%eax
  800b1f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800b22:	8b 45 10             	mov    0x10(%ebp),%eax
  800b25:	ff 75 f4             	pushl  -0xc(%ebp)
  800b28:	50                   	push   %eax
  800b29:	ff 75 0c             	pushl  0xc(%ebp)
  800b2c:	ff 75 08             	pushl  0x8(%ebp)
  800b2f:	e8 04 fc ff ff       	call   800738 <vprintfmt>
  800b34:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800b37:	90                   	nop
  800b38:	c9                   	leave  
  800b39:	c3                   	ret    

00800b3a <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800b3a:	55                   	push   %ebp
  800b3b:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800b3d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b40:	8b 40 08             	mov    0x8(%eax),%eax
  800b43:	8d 50 01             	lea    0x1(%eax),%edx
  800b46:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b49:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800b4c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b4f:	8b 10                	mov    (%eax),%edx
  800b51:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b54:	8b 40 04             	mov    0x4(%eax),%eax
  800b57:	39 c2                	cmp    %eax,%edx
  800b59:	73 12                	jae    800b6d <sprintputch+0x33>
		*b->buf++ = ch;
  800b5b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b5e:	8b 00                	mov    (%eax),%eax
  800b60:	8d 48 01             	lea    0x1(%eax),%ecx
  800b63:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b66:	89 0a                	mov    %ecx,(%edx)
  800b68:	8b 55 08             	mov    0x8(%ebp),%edx
  800b6b:	88 10                	mov    %dl,(%eax)
}
  800b6d:	90                   	nop
  800b6e:	5d                   	pop    %ebp
  800b6f:	c3                   	ret    

00800b70 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800b70:	55                   	push   %ebp
  800b71:	89 e5                	mov    %esp,%ebp
  800b73:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800b76:	8b 45 08             	mov    0x8(%ebp),%eax
  800b79:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800b7c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b7f:	8d 50 ff             	lea    -0x1(%eax),%edx
  800b82:	8b 45 08             	mov    0x8(%ebp),%eax
  800b85:	01 d0                	add    %edx,%eax
  800b87:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b8a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800b91:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800b95:	74 06                	je     800b9d <vsnprintf+0x2d>
  800b97:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b9b:	7f 07                	jg     800ba4 <vsnprintf+0x34>
		return -E_INVAL;
  800b9d:	b8 03 00 00 00       	mov    $0x3,%eax
  800ba2:	eb 20                	jmp    800bc4 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800ba4:	ff 75 14             	pushl  0x14(%ebp)
  800ba7:	ff 75 10             	pushl  0x10(%ebp)
  800baa:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800bad:	50                   	push   %eax
  800bae:	68 3a 0b 80 00       	push   $0x800b3a
  800bb3:	e8 80 fb ff ff       	call   800738 <vprintfmt>
  800bb8:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800bbb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800bbe:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800bc1:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800bc4:	c9                   	leave  
  800bc5:	c3                   	ret    

00800bc6 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800bc6:	55                   	push   %ebp
  800bc7:	89 e5                	mov    %esp,%ebp
  800bc9:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800bcc:	8d 45 10             	lea    0x10(%ebp),%eax
  800bcf:	83 c0 04             	add    $0x4,%eax
  800bd2:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800bd5:	8b 45 10             	mov    0x10(%ebp),%eax
  800bd8:	ff 75 f4             	pushl  -0xc(%ebp)
  800bdb:	50                   	push   %eax
  800bdc:	ff 75 0c             	pushl  0xc(%ebp)
  800bdf:	ff 75 08             	pushl  0x8(%ebp)
  800be2:	e8 89 ff ff ff       	call   800b70 <vsnprintf>
  800be7:	83 c4 10             	add    $0x10,%esp
  800bea:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800bed:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800bf0:	c9                   	leave  
  800bf1:	c3                   	ret    

00800bf2 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800bf2:	55                   	push   %ebp
  800bf3:	89 e5                	mov    %esp,%ebp
  800bf5:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800bf8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800bff:	eb 06                	jmp    800c07 <strlen+0x15>
		n++;
  800c01:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800c04:	ff 45 08             	incl   0x8(%ebp)
  800c07:	8b 45 08             	mov    0x8(%ebp),%eax
  800c0a:	8a 00                	mov    (%eax),%al
  800c0c:	84 c0                	test   %al,%al
  800c0e:	75 f1                	jne    800c01 <strlen+0xf>
		n++;
	return n;
  800c10:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c13:	c9                   	leave  
  800c14:	c3                   	ret    

00800c15 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800c15:	55                   	push   %ebp
  800c16:	89 e5                	mov    %esp,%ebp
  800c18:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c1b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c22:	eb 09                	jmp    800c2d <strnlen+0x18>
		n++;
  800c24:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c27:	ff 45 08             	incl   0x8(%ebp)
  800c2a:	ff 4d 0c             	decl   0xc(%ebp)
  800c2d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c31:	74 09                	je     800c3c <strnlen+0x27>
  800c33:	8b 45 08             	mov    0x8(%ebp),%eax
  800c36:	8a 00                	mov    (%eax),%al
  800c38:	84 c0                	test   %al,%al
  800c3a:	75 e8                	jne    800c24 <strnlen+0xf>
		n++;
	return n;
  800c3c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c3f:	c9                   	leave  
  800c40:	c3                   	ret    

00800c41 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800c41:	55                   	push   %ebp
  800c42:	89 e5                	mov    %esp,%ebp
  800c44:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800c47:	8b 45 08             	mov    0x8(%ebp),%eax
  800c4a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800c4d:	90                   	nop
  800c4e:	8b 45 08             	mov    0x8(%ebp),%eax
  800c51:	8d 50 01             	lea    0x1(%eax),%edx
  800c54:	89 55 08             	mov    %edx,0x8(%ebp)
  800c57:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c5a:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c5d:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800c60:	8a 12                	mov    (%edx),%dl
  800c62:	88 10                	mov    %dl,(%eax)
  800c64:	8a 00                	mov    (%eax),%al
  800c66:	84 c0                	test   %al,%al
  800c68:	75 e4                	jne    800c4e <strcpy+0xd>
		/* do nothing */;
	return ret;
  800c6a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c6d:	c9                   	leave  
  800c6e:	c3                   	ret    

00800c6f <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800c6f:	55                   	push   %ebp
  800c70:	89 e5                	mov    %esp,%ebp
  800c72:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800c75:	8b 45 08             	mov    0x8(%ebp),%eax
  800c78:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800c7b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c82:	eb 1f                	jmp    800ca3 <strncpy+0x34>
		*dst++ = *src;
  800c84:	8b 45 08             	mov    0x8(%ebp),%eax
  800c87:	8d 50 01             	lea    0x1(%eax),%edx
  800c8a:	89 55 08             	mov    %edx,0x8(%ebp)
  800c8d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c90:	8a 12                	mov    (%edx),%dl
  800c92:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800c94:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c97:	8a 00                	mov    (%eax),%al
  800c99:	84 c0                	test   %al,%al
  800c9b:	74 03                	je     800ca0 <strncpy+0x31>
			src++;
  800c9d:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800ca0:	ff 45 fc             	incl   -0x4(%ebp)
  800ca3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ca6:	3b 45 10             	cmp    0x10(%ebp),%eax
  800ca9:	72 d9                	jb     800c84 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800cab:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800cae:	c9                   	leave  
  800caf:	c3                   	ret    

00800cb0 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800cb0:	55                   	push   %ebp
  800cb1:	89 e5                	mov    %esp,%ebp
  800cb3:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800cb6:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800cbc:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800cc0:	74 30                	je     800cf2 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800cc2:	eb 16                	jmp    800cda <strlcpy+0x2a>
			*dst++ = *src++;
  800cc4:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc7:	8d 50 01             	lea    0x1(%eax),%edx
  800cca:	89 55 08             	mov    %edx,0x8(%ebp)
  800ccd:	8b 55 0c             	mov    0xc(%ebp),%edx
  800cd0:	8d 4a 01             	lea    0x1(%edx),%ecx
  800cd3:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800cd6:	8a 12                	mov    (%edx),%dl
  800cd8:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800cda:	ff 4d 10             	decl   0x10(%ebp)
  800cdd:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ce1:	74 09                	je     800cec <strlcpy+0x3c>
  800ce3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ce6:	8a 00                	mov    (%eax),%al
  800ce8:	84 c0                	test   %al,%al
  800cea:	75 d8                	jne    800cc4 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800cec:	8b 45 08             	mov    0x8(%ebp),%eax
  800cef:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800cf2:	8b 55 08             	mov    0x8(%ebp),%edx
  800cf5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800cf8:	29 c2                	sub    %eax,%edx
  800cfa:	89 d0                	mov    %edx,%eax
}
  800cfc:	c9                   	leave  
  800cfd:	c3                   	ret    

00800cfe <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800cfe:	55                   	push   %ebp
  800cff:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800d01:	eb 06                	jmp    800d09 <strcmp+0xb>
		p++, q++;
  800d03:	ff 45 08             	incl   0x8(%ebp)
  800d06:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800d09:	8b 45 08             	mov    0x8(%ebp),%eax
  800d0c:	8a 00                	mov    (%eax),%al
  800d0e:	84 c0                	test   %al,%al
  800d10:	74 0e                	je     800d20 <strcmp+0x22>
  800d12:	8b 45 08             	mov    0x8(%ebp),%eax
  800d15:	8a 10                	mov    (%eax),%dl
  800d17:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d1a:	8a 00                	mov    (%eax),%al
  800d1c:	38 c2                	cmp    %al,%dl
  800d1e:	74 e3                	je     800d03 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800d20:	8b 45 08             	mov    0x8(%ebp),%eax
  800d23:	8a 00                	mov    (%eax),%al
  800d25:	0f b6 d0             	movzbl %al,%edx
  800d28:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d2b:	8a 00                	mov    (%eax),%al
  800d2d:	0f b6 c0             	movzbl %al,%eax
  800d30:	29 c2                	sub    %eax,%edx
  800d32:	89 d0                	mov    %edx,%eax
}
  800d34:	5d                   	pop    %ebp
  800d35:	c3                   	ret    

00800d36 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800d36:	55                   	push   %ebp
  800d37:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800d39:	eb 09                	jmp    800d44 <strncmp+0xe>
		n--, p++, q++;
  800d3b:	ff 4d 10             	decl   0x10(%ebp)
  800d3e:	ff 45 08             	incl   0x8(%ebp)
  800d41:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800d44:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d48:	74 17                	je     800d61 <strncmp+0x2b>
  800d4a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d4d:	8a 00                	mov    (%eax),%al
  800d4f:	84 c0                	test   %al,%al
  800d51:	74 0e                	je     800d61 <strncmp+0x2b>
  800d53:	8b 45 08             	mov    0x8(%ebp),%eax
  800d56:	8a 10                	mov    (%eax),%dl
  800d58:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d5b:	8a 00                	mov    (%eax),%al
  800d5d:	38 c2                	cmp    %al,%dl
  800d5f:	74 da                	je     800d3b <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800d61:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d65:	75 07                	jne    800d6e <strncmp+0x38>
		return 0;
  800d67:	b8 00 00 00 00       	mov    $0x0,%eax
  800d6c:	eb 14                	jmp    800d82 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800d6e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d71:	8a 00                	mov    (%eax),%al
  800d73:	0f b6 d0             	movzbl %al,%edx
  800d76:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d79:	8a 00                	mov    (%eax),%al
  800d7b:	0f b6 c0             	movzbl %al,%eax
  800d7e:	29 c2                	sub    %eax,%edx
  800d80:	89 d0                	mov    %edx,%eax
}
  800d82:	5d                   	pop    %ebp
  800d83:	c3                   	ret    

00800d84 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800d84:	55                   	push   %ebp
  800d85:	89 e5                	mov    %esp,%ebp
  800d87:	83 ec 04             	sub    $0x4,%esp
  800d8a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d8d:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800d90:	eb 12                	jmp    800da4 <strchr+0x20>
		if (*s == c)
  800d92:	8b 45 08             	mov    0x8(%ebp),%eax
  800d95:	8a 00                	mov    (%eax),%al
  800d97:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800d9a:	75 05                	jne    800da1 <strchr+0x1d>
			return (char *) s;
  800d9c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d9f:	eb 11                	jmp    800db2 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800da1:	ff 45 08             	incl   0x8(%ebp)
  800da4:	8b 45 08             	mov    0x8(%ebp),%eax
  800da7:	8a 00                	mov    (%eax),%al
  800da9:	84 c0                	test   %al,%al
  800dab:	75 e5                	jne    800d92 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800dad:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800db2:	c9                   	leave  
  800db3:	c3                   	ret    

00800db4 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800db4:	55                   	push   %ebp
  800db5:	89 e5                	mov    %esp,%ebp
  800db7:	83 ec 04             	sub    $0x4,%esp
  800dba:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dbd:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800dc0:	eb 0d                	jmp    800dcf <strfind+0x1b>
		if (*s == c)
  800dc2:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc5:	8a 00                	mov    (%eax),%al
  800dc7:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800dca:	74 0e                	je     800dda <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800dcc:	ff 45 08             	incl   0x8(%ebp)
  800dcf:	8b 45 08             	mov    0x8(%ebp),%eax
  800dd2:	8a 00                	mov    (%eax),%al
  800dd4:	84 c0                	test   %al,%al
  800dd6:	75 ea                	jne    800dc2 <strfind+0xe>
  800dd8:	eb 01                	jmp    800ddb <strfind+0x27>
		if (*s == c)
			break;
  800dda:	90                   	nop
	return (char *) s;
  800ddb:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800dde:	c9                   	leave  
  800ddf:	c3                   	ret    

00800de0 <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  800de0:	55                   	push   %ebp
  800de1:	89 e5                	mov    %esp,%ebp
  800de3:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  800de6:	8b 45 08             	mov    0x8(%ebp),%eax
  800de9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  800dec:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800df0:	76 63                	jbe    800e55 <memset+0x75>
		uint64 data_block = c;
  800df2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800df5:	99                   	cltd   
  800df6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800df9:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  800dfc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800dff:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e02:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  800e06:	c1 e0 08             	shl    $0x8,%eax
  800e09:	09 45 f0             	or     %eax,-0x10(%ebp)
  800e0c:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  800e0f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e12:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e15:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  800e19:	c1 e0 10             	shl    $0x10,%eax
  800e1c:	09 45 f0             	or     %eax,-0x10(%ebp)
  800e1f:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  800e22:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e25:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e28:	89 c2                	mov    %eax,%edx
  800e2a:	b8 00 00 00 00       	mov    $0x0,%eax
  800e2f:	09 45 f0             	or     %eax,-0x10(%ebp)
  800e32:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  800e35:	eb 18                	jmp    800e4f <memset+0x6f>
			*p64++ = data_block, n -= 8;
  800e37:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  800e3a:	8d 41 08             	lea    0x8(%ecx),%eax
  800e3d:	89 45 fc             	mov    %eax,-0x4(%ebp)
  800e40:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e43:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e46:	89 01                	mov    %eax,(%ecx)
  800e48:	89 51 04             	mov    %edx,0x4(%ecx)
  800e4b:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  800e4f:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800e53:	77 e2                	ja     800e37 <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  800e55:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e59:	74 23                	je     800e7e <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  800e5b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e5e:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  800e61:	eb 0e                	jmp    800e71 <memset+0x91>
			*p8++ = (uint8)c;
  800e63:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e66:	8d 50 01             	lea    0x1(%eax),%edx
  800e69:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800e6c:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e6f:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  800e71:	8b 45 10             	mov    0x10(%ebp),%eax
  800e74:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e77:	89 55 10             	mov    %edx,0x10(%ebp)
  800e7a:	85 c0                	test   %eax,%eax
  800e7c:	75 e5                	jne    800e63 <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  800e7e:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e81:	c9                   	leave  
  800e82:	c3                   	ret    

00800e83 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800e83:	55                   	push   %ebp
  800e84:	89 e5                	mov    %esp,%ebp
  800e86:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  800e89:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e8c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  800e8f:	8b 45 08             	mov    0x8(%ebp),%eax
  800e92:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  800e95:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800e99:	76 24                	jbe    800ebf <memcpy+0x3c>
		while(n >= 8){
  800e9b:	eb 1c                	jmp    800eb9 <memcpy+0x36>
			*d64 = *s64;
  800e9d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ea0:	8b 50 04             	mov    0x4(%eax),%edx
  800ea3:	8b 00                	mov    (%eax),%eax
  800ea5:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  800ea8:	89 01                	mov    %eax,(%ecx)
  800eaa:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  800ead:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  800eb1:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  800eb5:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  800eb9:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800ebd:	77 de                	ja     800e9d <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  800ebf:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ec3:	74 31                	je     800ef6 <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  800ec5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ec8:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  800ecb:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ece:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  800ed1:	eb 16                	jmp    800ee9 <memcpy+0x66>
			*d8++ = *s8++;
  800ed3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ed6:	8d 50 01             	lea    0x1(%eax),%edx
  800ed9:	89 55 f0             	mov    %edx,-0x10(%ebp)
  800edc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800edf:	8d 4a 01             	lea    0x1(%edx),%ecx
  800ee2:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  800ee5:	8a 12                	mov    (%edx),%dl
  800ee7:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  800ee9:	8b 45 10             	mov    0x10(%ebp),%eax
  800eec:	8d 50 ff             	lea    -0x1(%eax),%edx
  800eef:	89 55 10             	mov    %edx,0x10(%ebp)
  800ef2:	85 c0                	test   %eax,%eax
  800ef4:	75 dd                	jne    800ed3 <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  800ef6:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ef9:	c9                   	leave  
  800efa:	c3                   	ret    

00800efb <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800efb:	55                   	push   %ebp
  800efc:	89 e5                	mov    %esp,%ebp
  800efe:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800f01:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f04:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800f07:	8b 45 08             	mov    0x8(%ebp),%eax
  800f0a:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800f0d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f10:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800f13:	73 50                	jae    800f65 <memmove+0x6a>
  800f15:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f18:	8b 45 10             	mov    0x10(%ebp),%eax
  800f1b:	01 d0                	add    %edx,%eax
  800f1d:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800f20:	76 43                	jbe    800f65 <memmove+0x6a>
		s += n;
  800f22:	8b 45 10             	mov    0x10(%ebp),%eax
  800f25:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800f28:	8b 45 10             	mov    0x10(%ebp),%eax
  800f2b:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800f2e:	eb 10                	jmp    800f40 <memmove+0x45>
			*--d = *--s;
  800f30:	ff 4d f8             	decl   -0x8(%ebp)
  800f33:	ff 4d fc             	decl   -0x4(%ebp)
  800f36:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f39:	8a 10                	mov    (%eax),%dl
  800f3b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f3e:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800f40:	8b 45 10             	mov    0x10(%ebp),%eax
  800f43:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f46:	89 55 10             	mov    %edx,0x10(%ebp)
  800f49:	85 c0                	test   %eax,%eax
  800f4b:	75 e3                	jne    800f30 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800f4d:	eb 23                	jmp    800f72 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800f4f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f52:	8d 50 01             	lea    0x1(%eax),%edx
  800f55:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800f58:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f5b:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f5e:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800f61:	8a 12                	mov    (%edx),%dl
  800f63:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800f65:	8b 45 10             	mov    0x10(%ebp),%eax
  800f68:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f6b:	89 55 10             	mov    %edx,0x10(%ebp)
  800f6e:	85 c0                	test   %eax,%eax
  800f70:	75 dd                	jne    800f4f <memmove+0x54>
			*d++ = *s++;

	return dst;
  800f72:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f75:	c9                   	leave  
  800f76:	c3                   	ret    

00800f77 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800f77:	55                   	push   %ebp
  800f78:	89 e5                	mov    %esp,%ebp
  800f7a:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800f7d:	8b 45 08             	mov    0x8(%ebp),%eax
  800f80:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800f83:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f86:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800f89:	eb 2a                	jmp    800fb5 <memcmp+0x3e>
		if (*s1 != *s2)
  800f8b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f8e:	8a 10                	mov    (%eax),%dl
  800f90:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f93:	8a 00                	mov    (%eax),%al
  800f95:	38 c2                	cmp    %al,%dl
  800f97:	74 16                	je     800faf <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800f99:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f9c:	8a 00                	mov    (%eax),%al
  800f9e:	0f b6 d0             	movzbl %al,%edx
  800fa1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fa4:	8a 00                	mov    (%eax),%al
  800fa6:	0f b6 c0             	movzbl %al,%eax
  800fa9:	29 c2                	sub    %eax,%edx
  800fab:	89 d0                	mov    %edx,%eax
  800fad:	eb 18                	jmp    800fc7 <memcmp+0x50>
		s1++, s2++;
  800faf:	ff 45 fc             	incl   -0x4(%ebp)
  800fb2:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800fb5:	8b 45 10             	mov    0x10(%ebp),%eax
  800fb8:	8d 50 ff             	lea    -0x1(%eax),%edx
  800fbb:	89 55 10             	mov    %edx,0x10(%ebp)
  800fbe:	85 c0                	test   %eax,%eax
  800fc0:	75 c9                	jne    800f8b <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800fc2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800fc7:	c9                   	leave  
  800fc8:	c3                   	ret    

00800fc9 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800fc9:	55                   	push   %ebp
  800fca:	89 e5                	mov    %esp,%ebp
  800fcc:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800fcf:	8b 55 08             	mov    0x8(%ebp),%edx
  800fd2:	8b 45 10             	mov    0x10(%ebp),%eax
  800fd5:	01 d0                	add    %edx,%eax
  800fd7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800fda:	eb 15                	jmp    800ff1 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800fdc:	8b 45 08             	mov    0x8(%ebp),%eax
  800fdf:	8a 00                	mov    (%eax),%al
  800fe1:	0f b6 d0             	movzbl %al,%edx
  800fe4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fe7:	0f b6 c0             	movzbl %al,%eax
  800fea:	39 c2                	cmp    %eax,%edx
  800fec:	74 0d                	je     800ffb <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800fee:	ff 45 08             	incl   0x8(%ebp)
  800ff1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff4:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800ff7:	72 e3                	jb     800fdc <memfind+0x13>
  800ff9:	eb 01                	jmp    800ffc <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800ffb:	90                   	nop
	return (void *) s;
  800ffc:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800fff:	c9                   	leave  
  801000:	c3                   	ret    

00801001 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801001:	55                   	push   %ebp
  801002:	89 e5                	mov    %esp,%ebp
  801004:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801007:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  80100e:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801015:	eb 03                	jmp    80101a <strtol+0x19>
		s++;
  801017:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80101a:	8b 45 08             	mov    0x8(%ebp),%eax
  80101d:	8a 00                	mov    (%eax),%al
  80101f:	3c 20                	cmp    $0x20,%al
  801021:	74 f4                	je     801017 <strtol+0x16>
  801023:	8b 45 08             	mov    0x8(%ebp),%eax
  801026:	8a 00                	mov    (%eax),%al
  801028:	3c 09                	cmp    $0x9,%al
  80102a:	74 eb                	je     801017 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  80102c:	8b 45 08             	mov    0x8(%ebp),%eax
  80102f:	8a 00                	mov    (%eax),%al
  801031:	3c 2b                	cmp    $0x2b,%al
  801033:	75 05                	jne    80103a <strtol+0x39>
		s++;
  801035:	ff 45 08             	incl   0x8(%ebp)
  801038:	eb 13                	jmp    80104d <strtol+0x4c>
	else if (*s == '-')
  80103a:	8b 45 08             	mov    0x8(%ebp),%eax
  80103d:	8a 00                	mov    (%eax),%al
  80103f:	3c 2d                	cmp    $0x2d,%al
  801041:	75 0a                	jne    80104d <strtol+0x4c>
		s++, neg = 1;
  801043:	ff 45 08             	incl   0x8(%ebp)
  801046:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80104d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801051:	74 06                	je     801059 <strtol+0x58>
  801053:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801057:	75 20                	jne    801079 <strtol+0x78>
  801059:	8b 45 08             	mov    0x8(%ebp),%eax
  80105c:	8a 00                	mov    (%eax),%al
  80105e:	3c 30                	cmp    $0x30,%al
  801060:	75 17                	jne    801079 <strtol+0x78>
  801062:	8b 45 08             	mov    0x8(%ebp),%eax
  801065:	40                   	inc    %eax
  801066:	8a 00                	mov    (%eax),%al
  801068:	3c 78                	cmp    $0x78,%al
  80106a:	75 0d                	jne    801079 <strtol+0x78>
		s += 2, base = 16;
  80106c:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801070:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801077:	eb 28                	jmp    8010a1 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801079:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80107d:	75 15                	jne    801094 <strtol+0x93>
  80107f:	8b 45 08             	mov    0x8(%ebp),%eax
  801082:	8a 00                	mov    (%eax),%al
  801084:	3c 30                	cmp    $0x30,%al
  801086:	75 0c                	jne    801094 <strtol+0x93>
		s++, base = 8;
  801088:	ff 45 08             	incl   0x8(%ebp)
  80108b:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801092:	eb 0d                	jmp    8010a1 <strtol+0xa0>
	else if (base == 0)
  801094:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801098:	75 07                	jne    8010a1 <strtol+0xa0>
		base = 10;
  80109a:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8010a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a4:	8a 00                	mov    (%eax),%al
  8010a6:	3c 2f                	cmp    $0x2f,%al
  8010a8:	7e 19                	jle    8010c3 <strtol+0xc2>
  8010aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ad:	8a 00                	mov    (%eax),%al
  8010af:	3c 39                	cmp    $0x39,%al
  8010b1:	7f 10                	jg     8010c3 <strtol+0xc2>
			dig = *s - '0';
  8010b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b6:	8a 00                	mov    (%eax),%al
  8010b8:	0f be c0             	movsbl %al,%eax
  8010bb:	83 e8 30             	sub    $0x30,%eax
  8010be:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8010c1:	eb 42                	jmp    801105 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  8010c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c6:	8a 00                	mov    (%eax),%al
  8010c8:	3c 60                	cmp    $0x60,%al
  8010ca:	7e 19                	jle    8010e5 <strtol+0xe4>
  8010cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8010cf:	8a 00                	mov    (%eax),%al
  8010d1:	3c 7a                	cmp    $0x7a,%al
  8010d3:	7f 10                	jg     8010e5 <strtol+0xe4>
			dig = *s - 'a' + 10;
  8010d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8010d8:	8a 00                	mov    (%eax),%al
  8010da:	0f be c0             	movsbl %al,%eax
  8010dd:	83 e8 57             	sub    $0x57,%eax
  8010e0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8010e3:	eb 20                	jmp    801105 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  8010e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8010e8:	8a 00                	mov    (%eax),%al
  8010ea:	3c 40                	cmp    $0x40,%al
  8010ec:	7e 39                	jle    801127 <strtol+0x126>
  8010ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8010f1:	8a 00                	mov    (%eax),%al
  8010f3:	3c 5a                	cmp    $0x5a,%al
  8010f5:	7f 30                	jg     801127 <strtol+0x126>
			dig = *s - 'A' + 10;
  8010f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8010fa:	8a 00                	mov    (%eax),%al
  8010fc:	0f be c0             	movsbl %al,%eax
  8010ff:	83 e8 37             	sub    $0x37,%eax
  801102:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801105:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801108:	3b 45 10             	cmp    0x10(%ebp),%eax
  80110b:	7d 19                	jge    801126 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  80110d:	ff 45 08             	incl   0x8(%ebp)
  801110:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801113:	0f af 45 10          	imul   0x10(%ebp),%eax
  801117:	89 c2                	mov    %eax,%edx
  801119:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80111c:	01 d0                	add    %edx,%eax
  80111e:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801121:	e9 7b ff ff ff       	jmp    8010a1 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801126:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801127:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80112b:	74 08                	je     801135 <strtol+0x134>
		*endptr = (char *) s;
  80112d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801130:	8b 55 08             	mov    0x8(%ebp),%edx
  801133:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801135:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801139:	74 07                	je     801142 <strtol+0x141>
  80113b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80113e:	f7 d8                	neg    %eax
  801140:	eb 03                	jmp    801145 <strtol+0x144>
  801142:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801145:	c9                   	leave  
  801146:	c3                   	ret    

00801147 <ltostr>:

void
ltostr(long value, char *str)
{
  801147:	55                   	push   %ebp
  801148:	89 e5                	mov    %esp,%ebp
  80114a:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  80114d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801154:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  80115b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80115f:	79 13                	jns    801174 <ltostr+0x2d>
	{
		neg = 1;
  801161:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801168:	8b 45 0c             	mov    0xc(%ebp),%eax
  80116b:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  80116e:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801171:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801174:	8b 45 08             	mov    0x8(%ebp),%eax
  801177:	b9 0a 00 00 00       	mov    $0xa,%ecx
  80117c:	99                   	cltd   
  80117d:	f7 f9                	idiv   %ecx
  80117f:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801182:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801185:	8d 50 01             	lea    0x1(%eax),%edx
  801188:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80118b:	89 c2                	mov    %eax,%edx
  80118d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801190:	01 d0                	add    %edx,%eax
  801192:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801195:	83 c2 30             	add    $0x30,%edx
  801198:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  80119a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80119d:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8011a2:	f7 e9                	imul   %ecx
  8011a4:	c1 fa 02             	sar    $0x2,%edx
  8011a7:	89 c8                	mov    %ecx,%eax
  8011a9:	c1 f8 1f             	sar    $0x1f,%eax
  8011ac:	29 c2                	sub    %eax,%edx
  8011ae:	89 d0                	mov    %edx,%eax
  8011b0:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  8011b3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8011b7:	75 bb                	jne    801174 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8011b9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8011c0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011c3:	48                   	dec    %eax
  8011c4:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8011c7:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8011cb:	74 3d                	je     80120a <ltostr+0xc3>
		start = 1 ;
  8011cd:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8011d4:	eb 34                	jmp    80120a <ltostr+0xc3>
	{
		char tmp = str[start] ;
  8011d6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8011d9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011dc:	01 d0                	add    %edx,%eax
  8011de:	8a 00                	mov    (%eax),%al
  8011e0:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8011e3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8011e6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011e9:	01 c2                	add    %eax,%edx
  8011eb:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8011ee:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011f1:	01 c8                	add    %ecx,%eax
  8011f3:	8a 00                	mov    (%eax),%al
  8011f5:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8011f7:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8011fa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011fd:	01 c2                	add    %eax,%edx
  8011ff:	8a 45 eb             	mov    -0x15(%ebp),%al
  801202:	88 02                	mov    %al,(%edx)
		start++ ;
  801204:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801207:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  80120a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80120d:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801210:	7c c4                	jl     8011d6 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801212:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801215:	8b 45 0c             	mov    0xc(%ebp),%eax
  801218:	01 d0                	add    %edx,%eax
  80121a:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  80121d:	90                   	nop
  80121e:	c9                   	leave  
  80121f:	c3                   	ret    

00801220 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801220:	55                   	push   %ebp
  801221:	89 e5                	mov    %esp,%ebp
  801223:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801226:	ff 75 08             	pushl  0x8(%ebp)
  801229:	e8 c4 f9 ff ff       	call   800bf2 <strlen>
  80122e:	83 c4 04             	add    $0x4,%esp
  801231:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801234:	ff 75 0c             	pushl  0xc(%ebp)
  801237:	e8 b6 f9 ff ff       	call   800bf2 <strlen>
  80123c:	83 c4 04             	add    $0x4,%esp
  80123f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801242:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801249:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801250:	eb 17                	jmp    801269 <strcconcat+0x49>
		final[s] = str1[s] ;
  801252:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801255:	8b 45 10             	mov    0x10(%ebp),%eax
  801258:	01 c2                	add    %eax,%edx
  80125a:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80125d:	8b 45 08             	mov    0x8(%ebp),%eax
  801260:	01 c8                	add    %ecx,%eax
  801262:	8a 00                	mov    (%eax),%al
  801264:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801266:	ff 45 fc             	incl   -0x4(%ebp)
  801269:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80126c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80126f:	7c e1                	jl     801252 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801271:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801278:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  80127f:	eb 1f                	jmp    8012a0 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801281:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801284:	8d 50 01             	lea    0x1(%eax),%edx
  801287:	89 55 fc             	mov    %edx,-0x4(%ebp)
  80128a:	89 c2                	mov    %eax,%edx
  80128c:	8b 45 10             	mov    0x10(%ebp),%eax
  80128f:	01 c2                	add    %eax,%edx
  801291:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801294:	8b 45 0c             	mov    0xc(%ebp),%eax
  801297:	01 c8                	add    %ecx,%eax
  801299:	8a 00                	mov    (%eax),%al
  80129b:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  80129d:	ff 45 f8             	incl   -0x8(%ebp)
  8012a0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012a3:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8012a6:	7c d9                	jl     801281 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8012a8:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8012ab:	8b 45 10             	mov    0x10(%ebp),%eax
  8012ae:	01 d0                	add    %edx,%eax
  8012b0:	c6 00 00             	movb   $0x0,(%eax)
}
  8012b3:	90                   	nop
  8012b4:	c9                   	leave  
  8012b5:	c3                   	ret    

008012b6 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8012b6:	55                   	push   %ebp
  8012b7:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8012b9:	8b 45 14             	mov    0x14(%ebp),%eax
  8012bc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8012c2:	8b 45 14             	mov    0x14(%ebp),%eax
  8012c5:	8b 00                	mov    (%eax),%eax
  8012c7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8012ce:	8b 45 10             	mov    0x10(%ebp),%eax
  8012d1:	01 d0                	add    %edx,%eax
  8012d3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8012d9:	eb 0c                	jmp    8012e7 <strsplit+0x31>
			*string++ = 0;
  8012db:	8b 45 08             	mov    0x8(%ebp),%eax
  8012de:	8d 50 01             	lea    0x1(%eax),%edx
  8012e1:	89 55 08             	mov    %edx,0x8(%ebp)
  8012e4:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8012e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8012ea:	8a 00                	mov    (%eax),%al
  8012ec:	84 c0                	test   %al,%al
  8012ee:	74 18                	je     801308 <strsplit+0x52>
  8012f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8012f3:	8a 00                	mov    (%eax),%al
  8012f5:	0f be c0             	movsbl %al,%eax
  8012f8:	50                   	push   %eax
  8012f9:	ff 75 0c             	pushl  0xc(%ebp)
  8012fc:	e8 83 fa ff ff       	call   800d84 <strchr>
  801301:	83 c4 08             	add    $0x8,%esp
  801304:	85 c0                	test   %eax,%eax
  801306:	75 d3                	jne    8012db <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801308:	8b 45 08             	mov    0x8(%ebp),%eax
  80130b:	8a 00                	mov    (%eax),%al
  80130d:	84 c0                	test   %al,%al
  80130f:	74 5a                	je     80136b <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801311:	8b 45 14             	mov    0x14(%ebp),%eax
  801314:	8b 00                	mov    (%eax),%eax
  801316:	83 f8 0f             	cmp    $0xf,%eax
  801319:	75 07                	jne    801322 <strsplit+0x6c>
		{
			return 0;
  80131b:	b8 00 00 00 00       	mov    $0x0,%eax
  801320:	eb 66                	jmp    801388 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801322:	8b 45 14             	mov    0x14(%ebp),%eax
  801325:	8b 00                	mov    (%eax),%eax
  801327:	8d 48 01             	lea    0x1(%eax),%ecx
  80132a:	8b 55 14             	mov    0x14(%ebp),%edx
  80132d:	89 0a                	mov    %ecx,(%edx)
  80132f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801336:	8b 45 10             	mov    0x10(%ebp),%eax
  801339:	01 c2                	add    %eax,%edx
  80133b:	8b 45 08             	mov    0x8(%ebp),%eax
  80133e:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801340:	eb 03                	jmp    801345 <strsplit+0x8f>
			string++;
  801342:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801345:	8b 45 08             	mov    0x8(%ebp),%eax
  801348:	8a 00                	mov    (%eax),%al
  80134a:	84 c0                	test   %al,%al
  80134c:	74 8b                	je     8012d9 <strsplit+0x23>
  80134e:	8b 45 08             	mov    0x8(%ebp),%eax
  801351:	8a 00                	mov    (%eax),%al
  801353:	0f be c0             	movsbl %al,%eax
  801356:	50                   	push   %eax
  801357:	ff 75 0c             	pushl  0xc(%ebp)
  80135a:	e8 25 fa ff ff       	call   800d84 <strchr>
  80135f:	83 c4 08             	add    $0x8,%esp
  801362:	85 c0                	test   %eax,%eax
  801364:	74 dc                	je     801342 <strsplit+0x8c>
			string++;
	}
  801366:	e9 6e ff ff ff       	jmp    8012d9 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  80136b:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  80136c:	8b 45 14             	mov    0x14(%ebp),%eax
  80136f:	8b 00                	mov    (%eax),%eax
  801371:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801378:	8b 45 10             	mov    0x10(%ebp),%eax
  80137b:	01 d0                	add    %edx,%eax
  80137d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801383:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801388:	c9                   	leave  
  801389:	c3                   	ret    

0080138a <str2lower>:


char* str2lower(char *dst, const char *src)
{
  80138a:	55                   	push   %ebp
  80138b:	89 e5                	mov    %esp,%ebp
  80138d:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  801390:	8b 45 08             	mov    0x8(%ebp),%eax
  801393:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  801396:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80139d:	eb 4a                	jmp    8013e9 <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  80139f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8013a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8013a5:	01 c2                	add    %eax,%edx
  8013a7:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8013aa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013ad:	01 c8                	add    %ecx,%eax
  8013af:	8a 00                	mov    (%eax),%al
  8013b1:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  8013b3:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8013b6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013b9:	01 d0                	add    %edx,%eax
  8013bb:	8a 00                	mov    (%eax),%al
  8013bd:	3c 40                	cmp    $0x40,%al
  8013bf:	7e 25                	jle    8013e6 <str2lower+0x5c>
  8013c1:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8013c4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013c7:	01 d0                	add    %edx,%eax
  8013c9:	8a 00                	mov    (%eax),%al
  8013cb:	3c 5a                	cmp    $0x5a,%al
  8013cd:	7f 17                	jg     8013e6 <str2lower+0x5c>
		{
			dst[i] += 32 ;
  8013cf:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8013d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8013d5:	01 d0                	add    %edx,%eax
  8013d7:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8013da:	8b 55 08             	mov    0x8(%ebp),%edx
  8013dd:	01 ca                	add    %ecx,%edx
  8013df:	8a 12                	mov    (%edx),%dl
  8013e1:	83 c2 20             	add    $0x20,%edx
  8013e4:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  8013e6:	ff 45 fc             	incl   -0x4(%ebp)
  8013e9:	ff 75 0c             	pushl  0xc(%ebp)
  8013ec:	e8 01 f8 ff ff       	call   800bf2 <strlen>
  8013f1:	83 c4 04             	add    $0x4,%esp
  8013f4:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8013f7:	7f a6                	jg     80139f <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  8013f9:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8013fc:	c9                   	leave  
  8013fd:	c3                   	ret    

008013fe <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8013fe:	55                   	push   %ebp
  8013ff:	89 e5                	mov    %esp,%ebp
  801401:	57                   	push   %edi
  801402:	56                   	push   %esi
  801403:	53                   	push   %ebx
  801404:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801407:	8b 45 08             	mov    0x8(%ebp),%eax
  80140a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80140d:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801410:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801413:	8b 7d 18             	mov    0x18(%ebp),%edi
  801416:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801419:	cd 30                	int    $0x30
  80141b:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  80141e:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801421:	83 c4 10             	add    $0x10,%esp
  801424:	5b                   	pop    %ebx
  801425:	5e                   	pop    %esi
  801426:	5f                   	pop    %edi
  801427:	5d                   	pop    %ebp
  801428:	c3                   	ret    

00801429 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  801429:	55                   	push   %ebp
  80142a:	89 e5                	mov    %esp,%ebp
  80142c:	83 ec 04             	sub    $0x4,%esp
  80142f:	8b 45 10             	mov    0x10(%ebp),%eax
  801432:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  801435:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801438:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80143c:	8b 45 08             	mov    0x8(%ebp),%eax
  80143f:	6a 00                	push   $0x0
  801441:	51                   	push   %ecx
  801442:	52                   	push   %edx
  801443:	ff 75 0c             	pushl  0xc(%ebp)
  801446:	50                   	push   %eax
  801447:	6a 00                	push   $0x0
  801449:	e8 b0 ff ff ff       	call   8013fe <syscall>
  80144e:	83 c4 18             	add    $0x18,%esp
}
  801451:	90                   	nop
  801452:	c9                   	leave  
  801453:	c3                   	ret    

00801454 <sys_cgetc>:

int
sys_cgetc(void)
{
  801454:	55                   	push   %ebp
  801455:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801457:	6a 00                	push   $0x0
  801459:	6a 00                	push   $0x0
  80145b:	6a 00                	push   $0x0
  80145d:	6a 00                	push   $0x0
  80145f:	6a 00                	push   $0x0
  801461:	6a 02                	push   $0x2
  801463:	e8 96 ff ff ff       	call   8013fe <syscall>
  801468:	83 c4 18             	add    $0x18,%esp
}
  80146b:	c9                   	leave  
  80146c:	c3                   	ret    

0080146d <sys_lock_cons>:

void sys_lock_cons(void)
{
  80146d:	55                   	push   %ebp
  80146e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  801470:	6a 00                	push   $0x0
  801472:	6a 00                	push   $0x0
  801474:	6a 00                	push   $0x0
  801476:	6a 00                	push   $0x0
  801478:	6a 00                	push   $0x0
  80147a:	6a 03                	push   $0x3
  80147c:	e8 7d ff ff ff       	call   8013fe <syscall>
  801481:	83 c4 18             	add    $0x18,%esp
}
  801484:	90                   	nop
  801485:	c9                   	leave  
  801486:	c3                   	ret    

00801487 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  801487:	55                   	push   %ebp
  801488:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  80148a:	6a 00                	push   $0x0
  80148c:	6a 00                	push   $0x0
  80148e:	6a 00                	push   $0x0
  801490:	6a 00                	push   $0x0
  801492:	6a 00                	push   $0x0
  801494:	6a 04                	push   $0x4
  801496:	e8 63 ff ff ff       	call   8013fe <syscall>
  80149b:	83 c4 18             	add    $0x18,%esp
}
  80149e:	90                   	nop
  80149f:	c9                   	leave  
  8014a0:	c3                   	ret    

008014a1 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8014a1:	55                   	push   %ebp
  8014a2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8014a4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8014aa:	6a 00                	push   $0x0
  8014ac:	6a 00                	push   $0x0
  8014ae:	6a 00                	push   $0x0
  8014b0:	52                   	push   %edx
  8014b1:	50                   	push   %eax
  8014b2:	6a 08                	push   $0x8
  8014b4:	e8 45 ff ff ff       	call   8013fe <syscall>
  8014b9:	83 c4 18             	add    $0x18,%esp
}
  8014bc:	c9                   	leave  
  8014bd:	c3                   	ret    

008014be <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8014be:	55                   	push   %ebp
  8014bf:	89 e5                	mov    %esp,%ebp
  8014c1:	56                   	push   %esi
  8014c2:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8014c3:	8b 75 18             	mov    0x18(%ebp),%esi
  8014c6:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8014c9:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8014cc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8014d2:	56                   	push   %esi
  8014d3:	53                   	push   %ebx
  8014d4:	51                   	push   %ecx
  8014d5:	52                   	push   %edx
  8014d6:	50                   	push   %eax
  8014d7:	6a 09                	push   $0x9
  8014d9:	e8 20 ff ff ff       	call   8013fe <syscall>
  8014de:	83 c4 18             	add    $0x18,%esp
}
  8014e1:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8014e4:	5b                   	pop    %ebx
  8014e5:	5e                   	pop    %esi
  8014e6:	5d                   	pop    %ebp
  8014e7:	c3                   	ret    

008014e8 <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  8014e8:	55                   	push   %ebp
  8014e9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  8014eb:	6a 00                	push   $0x0
  8014ed:	6a 00                	push   $0x0
  8014ef:	6a 00                	push   $0x0
  8014f1:	6a 00                	push   $0x0
  8014f3:	ff 75 08             	pushl  0x8(%ebp)
  8014f6:	6a 0a                	push   $0xa
  8014f8:	e8 01 ff ff ff       	call   8013fe <syscall>
  8014fd:	83 c4 18             	add    $0x18,%esp
}
  801500:	c9                   	leave  
  801501:	c3                   	ret    

00801502 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801502:	55                   	push   %ebp
  801503:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801505:	6a 00                	push   $0x0
  801507:	6a 00                	push   $0x0
  801509:	6a 00                	push   $0x0
  80150b:	ff 75 0c             	pushl  0xc(%ebp)
  80150e:	ff 75 08             	pushl  0x8(%ebp)
  801511:	6a 0b                	push   $0xb
  801513:	e8 e6 fe ff ff       	call   8013fe <syscall>
  801518:	83 c4 18             	add    $0x18,%esp
}
  80151b:	c9                   	leave  
  80151c:	c3                   	ret    

0080151d <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  80151d:	55                   	push   %ebp
  80151e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801520:	6a 00                	push   $0x0
  801522:	6a 00                	push   $0x0
  801524:	6a 00                	push   $0x0
  801526:	6a 00                	push   $0x0
  801528:	6a 00                	push   $0x0
  80152a:	6a 0c                	push   $0xc
  80152c:	e8 cd fe ff ff       	call   8013fe <syscall>
  801531:	83 c4 18             	add    $0x18,%esp
}
  801534:	c9                   	leave  
  801535:	c3                   	ret    

00801536 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801536:	55                   	push   %ebp
  801537:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801539:	6a 00                	push   $0x0
  80153b:	6a 00                	push   $0x0
  80153d:	6a 00                	push   $0x0
  80153f:	6a 00                	push   $0x0
  801541:	6a 00                	push   $0x0
  801543:	6a 0d                	push   $0xd
  801545:	e8 b4 fe ff ff       	call   8013fe <syscall>
  80154a:	83 c4 18             	add    $0x18,%esp
}
  80154d:	c9                   	leave  
  80154e:	c3                   	ret    

0080154f <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  80154f:	55                   	push   %ebp
  801550:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801552:	6a 00                	push   $0x0
  801554:	6a 00                	push   $0x0
  801556:	6a 00                	push   $0x0
  801558:	6a 00                	push   $0x0
  80155a:	6a 00                	push   $0x0
  80155c:	6a 0e                	push   $0xe
  80155e:	e8 9b fe ff ff       	call   8013fe <syscall>
  801563:	83 c4 18             	add    $0x18,%esp
}
  801566:	c9                   	leave  
  801567:	c3                   	ret    

00801568 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801568:	55                   	push   %ebp
  801569:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  80156b:	6a 00                	push   $0x0
  80156d:	6a 00                	push   $0x0
  80156f:	6a 00                	push   $0x0
  801571:	6a 00                	push   $0x0
  801573:	6a 00                	push   $0x0
  801575:	6a 0f                	push   $0xf
  801577:	e8 82 fe ff ff       	call   8013fe <syscall>
  80157c:	83 c4 18             	add    $0x18,%esp
}
  80157f:	c9                   	leave  
  801580:	c3                   	ret    

00801581 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801581:	55                   	push   %ebp
  801582:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801584:	6a 00                	push   $0x0
  801586:	6a 00                	push   $0x0
  801588:	6a 00                	push   $0x0
  80158a:	6a 00                	push   $0x0
  80158c:	ff 75 08             	pushl  0x8(%ebp)
  80158f:	6a 10                	push   $0x10
  801591:	e8 68 fe ff ff       	call   8013fe <syscall>
  801596:	83 c4 18             	add    $0x18,%esp
}
  801599:	c9                   	leave  
  80159a:	c3                   	ret    

0080159b <sys_scarce_memory>:

void sys_scarce_memory()
{
  80159b:	55                   	push   %ebp
  80159c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  80159e:	6a 00                	push   $0x0
  8015a0:	6a 00                	push   $0x0
  8015a2:	6a 00                	push   $0x0
  8015a4:	6a 00                	push   $0x0
  8015a6:	6a 00                	push   $0x0
  8015a8:	6a 11                	push   $0x11
  8015aa:	e8 4f fe ff ff       	call   8013fe <syscall>
  8015af:	83 c4 18             	add    $0x18,%esp
}
  8015b2:	90                   	nop
  8015b3:	c9                   	leave  
  8015b4:	c3                   	ret    

008015b5 <sys_cputc>:

void
sys_cputc(const char c)
{
  8015b5:	55                   	push   %ebp
  8015b6:	89 e5                	mov    %esp,%ebp
  8015b8:	83 ec 04             	sub    $0x4,%esp
  8015bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8015be:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8015c1:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8015c5:	6a 00                	push   $0x0
  8015c7:	6a 00                	push   $0x0
  8015c9:	6a 00                	push   $0x0
  8015cb:	6a 00                	push   $0x0
  8015cd:	50                   	push   %eax
  8015ce:	6a 01                	push   $0x1
  8015d0:	e8 29 fe ff ff       	call   8013fe <syscall>
  8015d5:	83 c4 18             	add    $0x18,%esp
}
  8015d8:	90                   	nop
  8015d9:	c9                   	leave  
  8015da:	c3                   	ret    

008015db <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8015db:	55                   	push   %ebp
  8015dc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8015de:	6a 00                	push   $0x0
  8015e0:	6a 00                	push   $0x0
  8015e2:	6a 00                	push   $0x0
  8015e4:	6a 00                	push   $0x0
  8015e6:	6a 00                	push   $0x0
  8015e8:	6a 14                	push   $0x14
  8015ea:	e8 0f fe ff ff       	call   8013fe <syscall>
  8015ef:	83 c4 18             	add    $0x18,%esp
}
  8015f2:	90                   	nop
  8015f3:	c9                   	leave  
  8015f4:	c3                   	ret    

008015f5 <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8015f5:	55                   	push   %ebp
  8015f6:	89 e5                	mov    %esp,%ebp
  8015f8:	83 ec 04             	sub    $0x4,%esp
  8015fb:	8b 45 10             	mov    0x10(%ebp),%eax
  8015fe:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801601:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801604:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801608:	8b 45 08             	mov    0x8(%ebp),%eax
  80160b:	6a 00                	push   $0x0
  80160d:	51                   	push   %ecx
  80160e:	52                   	push   %edx
  80160f:	ff 75 0c             	pushl  0xc(%ebp)
  801612:	50                   	push   %eax
  801613:	6a 15                	push   $0x15
  801615:	e8 e4 fd ff ff       	call   8013fe <syscall>
  80161a:	83 c4 18             	add    $0x18,%esp
}
  80161d:	c9                   	leave  
  80161e:	c3                   	ret    

0080161f <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  80161f:	55                   	push   %ebp
  801620:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801622:	8b 55 0c             	mov    0xc(%ebp),%edx
  801625:	8b 45 08             	mov    0x8(%ebp),%eax
  801628:	6a 00                	push   $0x0
  80162a:	6a 00                	push   $0x0
  80162c:	6a 00                	push   $0x0
  80162e:	52                   	push   %edx
  80162f:	50                   	push   %eax
  801630:	6a 16                	push   $0x16
  801632:	e8 c7 fd ff ff       	call   8013fe <syscall>
  801637:	83 c4 18             	add    $0x18,%esp
}
  80163a:	c9                   	leave  
  80163b:	c3                   	ret    

0080163c <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  80163c:	55                   	push   %ebp
  80163d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  80163f:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801642:	8b 55 0c             	mov    0xc(%ebp),%edx
  801645:	8b 45 08             	mov    0x8(%ebp),%eax
  801648:	6a 00                	push   $0x0
  80164a:	6a 00                	push   $0x0
  80164c:	51                   	push   %ecx
  80164d:	52                   	push   %edx
  80164e:	50                   	push   %eax
  80164f:	6a 17                	push   $0x17
  801651:	e8 a8 fd ff ff       	call   8013fe <syscall>
  801656:	83 c4 18             	add    $0x18,%esp
}
  801659:	c9                   	leave  
  80165a:	c3                   	ret    

0080165b <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  80165b:	55                   	push   %ebp
  80165c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  80165e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801661:	8b 45 08             	mov    0x8(%ebp),%eax
  801664:	6a 00                	push   $0x0
  801666:	6a 00                	push   $0x0
  801668:	6a 00                	push   $0x0
  80166a:	52                   	push   %edx
  80166b:	50                   	push   %eax
  80166c:	6a 18                	push   $0x18
  80166e:	e8 8b fd ff ff       	call   8013fe <syscall>
  801673:	83 c4 18             	add    $0x18,%esp
}
  801676:	c9                   	leave  
  801677:	c3                   	ret    

00801678 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801678:	55                   	push   %ebp
  801679:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  80167b:	8b 45 08             	mov    0x8(%ebp),%eax
  80167e:	6a 00                	push   $0x0
  801680:	ff 75 14             	pushl  0x14(%ebp)
  801683:	ff 75 10             	pushl  0x10(%ebp)
  801686:	ff 75 0c             	pushl  0xc(%ebp)
  801689:	50                   	push   %eax
  80168a:	6a 19                	push   $0x19
  80168c:	e8 6d fd ff ff       	call   8013fe <syscall>
  801691:	83 c4 18             	add    $0x18,%esp
}
  801694:	c9                   	leave  
  801695:	c3                   	ret    

00801696 <sys_run_env>:

void sys_run_env(int32 envId)
{
  801696:	55                   	push   %ebp
  801697:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801699:	8b 45 08             	mov    0x8(%ebp),%eax
  80169c:	6a 00                	push   $0x0
  80169e:	6a 00                	push   $0x0
  8016a0:	6a 00                	push   $0x0
  8016a2:	6a 00                	push   $0x0
  8016a4:	50                   	push   %eax
  8016a5:	6a 1a                	push   $0x1a
  8016a7:	e8 52 fd ff ff       	call   8013fe <syscall>
  8016ac:	83 c4 18             	add    $0x18,%esp
}
  8016af:	90                   	nop
  8016b0:	c9                   	leave  
  8016b1:	c3                   	ret    

008016b2 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8016b2:	55                   	push   %ebp
  8016b3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8016b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8016b8:	6a 00                	push   $0x0
  8016ba:	6a 00                	push   $0x0
  8016bc:	6a 00                	push   $0x0
  8016be:	6a 00                	push   $0x0
  8016c0:	50                   	push   %eax
  8016c1:	6a 1b                	push   $0x1b
  8016c3:	e8 36 fd ff ff       	call   8013fe <syscall>
  8016c8:	83 c4 18             	add    $0x18,%esp
}
  8016cb:	c9                   	leave  
  8016cc:	c3                   	ret    

008016cd <sys_getenvid>:

int32 sys_getenvid(void)
{
  8016cd:	55                   	push   %ebp
  8016ce:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8016d0:	6a 00                	push   $0x0
  8016d2:	6a 00                	push   $0x0
  8016d4:	6a 00                	push   $0x0
  8016d6:	6a 00                	push   $0x0
  8016d8:	6a 00                	push   $0x0
  8016da:	6a 05                	push   $0x5
  8016dc:	e8 1d fd ff ff       	call   8013fe <syscall>
  8016e1:	83 c4 18             	add    $0x18,%esp
}
  8016e4:	c9                   	leave  
  8016e5:	c3                   	ret    

008016e6 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8016e6:	55                   	push   %ebp
  8016e7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8016e9:	6a 00                	push   $0x0
  8016eb:	6a 00                	push   $0x0
  8016ed:	6a 00                	push   $0x0
  8016ef:	6a 00                	push   $0x0
  8016f1:	6a 00                	push   $0x0
  8016f3:	6a 06                	push   $0x6
  8016f5:	e8 04 fd ff ff       	call   8013fe <syscall>
  8016fa:	83 c4 18             	add    $0x18,%esp
}
  8016fd:	c9                   	leave  
  8016fe:	c3                   	ret    

008016ff <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8016ff:	55                   	push   %ebp
  801700:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801702:	6a 00                	push   $0x0
  801704:	6a 00                	push   $0x0
  801706:	6a 00                	push   $0x0
  801708:	6a 00                	push   $0x0
  80170a:	6a 00                	push   $0x0
  80170c:	6a 07                	push   $0x7
  80170e:	e8 eb fc ff ff       	call   8013fe <syscall>
  801713:	83 c4 18             	add    $0x18,%esp
}
  801716:	c9                   	leave  
  801717:	c3                   	ret    

00801718 <sys_exit_env>:


void sys_exit_env(void)
{
  801718:	55                   	push   %ebp
  801719:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  80171b:	6a 00                	push   $0x0
  80171d:	6a 00                	push   $0x0
  80171f:	6a 00                	push   $0x0
  801721:	6a 00                	push   $0x0
  801723:	6a 00                	push   $0x0
  801725:	6a 1c                	push   $0x1c
  801727:	e8 d2 fc ff ff       	call   8013fe <syscall>
  80172c:	83 c4 18             	add    $0x18,%esp
}
  80172f:	90                   	nop
  801730:	c9                   	leave  
  801731:	c3                   	ret    

00801732 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  801732:	55                   	push   %ebp
  801733:	89 e5                	mov    %esp,%ebp
  801735:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801738:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80173b:	8d 50 04             	lea    0x4(%eax),%edx
  80173e:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801741:	6a 00                	push   $0x0
  801743:	6a 00                	push   $0x0
  801745:	6a 00                	push   $0x0
  801747:	52                   	push   %edx
  801748:	50                   	push   %eax
  801749:	6a 1d                	push   $0x1d
  80174b:	e8 ae fc ff ff       	call   8013fe <syscall>
  801750:	83 c4 18             	add    $0x18,%esp
	return result;
  801753:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801756:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801759:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80175c:	89 01                	mov    %eax,(%ecx)
  80175e:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801761:	8b 45 08             	mov    0x8(%ebp),%eax
  801764:	c9                   	leave  
  801765:	c2 04 00             	ret    $0x4

00801768 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801768:	55                   	push   %ebp
  801769:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  80176b:	6a 00                	push   $0x0
  80176d:	6a 00                	push   $0x0
  80176f:	ff 75 10             	pushl  0x10(%ebp)
  801772:	ff 75 0c             	pushl  0xc(%ebp)
  801775:	ff 75 08             	pushl  0x8(%ebp)
  801778:	6a 13                	push   $0x13
  80177a:	e8 7f fc ff ff       	call   8013fe <syscall>
  80177f:	83 c4 18             	add    $0x18,%esp
	return ;
  801782:	90                   	nop
}
  801783:	c9                   	leave  
  801784:	c3                   	ret    

00801785 <sys_rcr2>:
uint32 sys_rcr2()
{
  801785:	55                   	push   %ebp
  801786:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801788:	6a 00                	push   $0x0
  80178a:	6a 00                	push   $0x0
  80178c:	6a 00                	push   $0x0
  80178e:	6a 00                	push   $0x0
  801790:	6a 00                	push   $0x0
  801792:	6a 1e                	push   $0x1e
  801794:	e8 65 fc ff ff       	call   8013fe <syscall>
  801799:	83 c4 18             	add    $0x18,%esp
}
  80179c:	c9                   	leave  
  80179d:	c3                   	ret    

0080179e <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  80179e:	55                   	push   %ebp
  80179f:	89 e5                	mov    %esp,%ebp
  8017a1:	83 ec 04             	sub    $0x4,%esp
  8017a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8017a7:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8017aa:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8017ae:	6a 00                	push   $0x0
  8017b0:	6a 00                	push   $0x0
  8017b2:	6a 00                	push   $0x0
  8017b4:	6a 00                	push   $0x0
  8017b6:	50                   	push   %eax
  8017b7:	6a 1f                	push   $0x1f
  8017b9:	e8 40 fc ff ff       	call   8013fe <syscall>
  8017be:	83 c4 18             	add    $0x18,%esp
	return ;
  8017c1:	90                   	nop
}
  8017c2:	c9                   	leave  
  8017c3:	c3                   	ret    

008017c4 <rsttst>:
void rsttst()
{
  8017c4:	55                   	push   %ebp
  8017c5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8017c7:	6a 00                	push   $0x0
  8017c9:	6a 00                	push   $0x0
  8017cb:	6a 00                	push   $0x0
  8017cd:	6a 00                	push   $0x0
  8017cf:	6a 00                	push   $0x0
  8017d1:	6a 21                	push   $0x21
  8017d3:	e8 26 fc ff ff       	call   8013fe <syscall>
  8017d8:	83 c4 18             	add    $0x18,%esp
	return ;
  8017db:	90                   	nop
}
  8017dc:	c9                   	leave  
  8017dd:	c3                   	ret    

008017de <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8017de:	55                   	push   %ebp
  8017df:	89 e5                	mov    %esp,%ebp
  8017e1:	83 ec 04             	sub    $0x4,%esp
  8017e4:	8b 45 14             	mov    0x14(%ebp),%eax
  8017e7:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8017ea:	8b 55 18             	mov    0x18(%ebp),%edx
  8017ed:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8017f1:	52                   	push   %edx
  8017f2:	50                   	push   %eax
  8017f3:	ff 75 10             	pushl  0x10(%ebp)
  8017f6:	ff 75 0c             	pushl  0xc(%ebp)
  8017f9:	ff 75 08             	pushl  0x8(%ebp)
  8017fc:	6a 20                	push   $0x20
  8017fe:	e8 fb fb ff ff       	call   8013fe <syscall>
  801803:	83 c4 18             	add    $0x18,%esp
	return ;
  801806:	90                   	nop
}
  801807:	c9                   	leave  
  801808:	c3                   	ret    

00801809 <chktst>:
void chktst(uint32 n)
{
  801809:	55                   	push   %ebp
  80180a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  80180c:	6a 00                	push   $0x0
  80180e:	6a 00                	push   $0x0
  801810:	6a 00                	push   $0x0
  801812:	6a 00                	push   $0x0
  801814:	ff 75 08             	pushl  0x8(%ebp)
  801817:	6a 22                	push   $0x22
  801819:	e8 e0 fb ff ff       	call   8013fe <syscall>
  80181e:	83 c4 18             	add    $0x18,%esp
	return ;
  801821:	90                   	nop
}
  801822:	c9                   	leave  
  801823:	c3                   	ret    

00801824 <inctst>:

void inctst()
{
  801824:	55                   	push   %ebp
  801825:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801827:	6a 00                	push   $0x0
  801829:	6a 00                	push   $0x0
  80182b:	6a 00                	push   $0x0
  80182d:	6a 00                	push   $0x0
  80182f:	6a 00                	push   $0x0
  801831:	6a 23                	push   $0x23
  801833:	e8 c6 fb ff ff       	call   8013fe <syscall>
  801838:	83 c4 18             	add    $0x18,%esp
	return ;
  80183b:	90                   	nop
}
  80183c:	c9                   	leave  
  80183d:	c3                   	ret    

0080183e <gettst>:
uint32 gettst()
{
  80183e:	55                   	push   %ebp
  80183f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801841:	6a 00                	push   $0x0
  801843:	6a 00                	push   $0x0
  801845:	6a 00                	push   $0x0
  801847:	6a 00                	push   $0x0
  801849:	6a 00                	push   $0x0
  80184b:	6a 24                	push   $0x24
  80184d:	e8 ac fb ff ff       	call   8013fe <syscall>
  801852:	83 c4 18             	add    $0x18,%esp
}
  801855:	c9                   	leave  
  801856:	c3                   	ret    

00801857 <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  801857:	55                   	push   %ebp
  801858:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80185a:	6a 00                	push   $0x0
  80185c:	6a 00                	push   $0x0
  80185e:	6a 00                	push   $0x0
  801860:	6a 00                	push   $0x0
  801862:	6a 00                	push   $0x0
  801864:	6a 25                	push   $0x25
  801866:	e8 93 fb ff ff       	call   8013fe <syscall>
  80186b:	83 c4 18             	add    $0x18,%esp
  80186e:	a3 60 b0 81 00       	mov    %eax,0x81b060
	return uheapPlaceStrategy ;
  801873:	a1 60 b0 81 00       	mov    0x81b060,%eax
}
  801878:	c9                   	leave  
  801879:	c3                   	ret    

0080187a <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  80187a:	55                   	push   %ebp
  80187b:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  80187d:	8b 45 08             	mov    0x8(%ebp),%eax
  801880:	a3 60 b0 81 00       	mov    %eax,0x81b060
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801885:	6a 00                	push   $0x0
  801887:	6a 00                	push   $0x0
  801889:	6a 00                	push   $0x0
  80188b:	6a 00                	push   $0x0
  80188d:	ff 75 08             	pushl  0x8(%ebp)
  801890:	6a 26                	push   $0x26
  801892:	e8 67 fb ff ff       	call   8013fe <syscall>
  801897:	83 c4 18             	add    $0x18,%esp
	return ;
  80189a:	90                   	nop
}
  80189b:	c9                   	leave  
  80189c:	c3                   	ret    

0080189d <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  80189d:	55                   	push   %ebp
  80189e:	89 e5                	mov    %esp,%ebp
  8018a0:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  8018a1:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8018a4:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8018a7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8018ad:	6a 00                	push   $0x0
  8018af:	53                   	push   %ebx
  8018b0:	51                   	push   %ecx
  8018b1:	52                   	push   %edx
  8018b2:	50                   	push   %eax
  8018b3:	6a 27                	push   $0x27
  8018b5:	e8 44 fb ff ff       	call   8013fe <syscall>
  8018ba:	83 c4 18             	add    $0x18,%esp
}
  8018bd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8018c0:	c9                   	leave  
  8018c1:	c3                   	ret    

008018c2 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  8018c2:	55                   	push   %ebp
  8018c3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  8018c5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8018cb:	6a 00                	push   $0x0
  8018cd:	6a 00                	push   $0x0
  8018cf:	6a 00                	push   $0x0
  8018d1:	52                   	push   %edx
  8018d2:	50                   	push   %eax
  8018d3:	6a 28                	push   $0x28
  8018d5:	e8 24 fb ff ff       	call   8013fe <syscall>
  8018da:	83 c4 18             	add    $0x18,%esp
}
  8018dd:	c9                   	leave  
  8018de:	c3                   	ret    

008018df <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  8018df:	55                   	push   %ebp
  8018e0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  8018e2:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8018e5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8018eb:	6a 00                	push   $0x0
  8018ed:	51                   	push   %ecx
  8018ee:	ff 75 10             	pushl  0x10(%ebp)
  8018f1:	52                   	push   %edx
  8018f2:	50                   	push   %eax
  8018f3:	6a 29                	push   $0x29
  8018f5:	e8 04 fb ff ff       	call   8013fe <syscall>
  8018fa:	83 c4 18             	add    $0x18,%esp
}
  8018fd:	c9                   	leave  
  8018fe:	c3                   	ret    

008018ff <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8018ff:	55                   	push   %ebp
  801900:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801902:	6a 00                	push   $0x0
  801904:	6a 00                	push   $0x0
  801906:	ff 75 10             	pushl  0x10(%ebp)
  801909:	ff 75 0c             	pushl  0xc(%ebp)
  80190c:	ff 75 08             	pushl  0x8(%ebp)
  80190f:	6a 12                	push   $0x12
  801911:	e8 e8 fa ff ff       	call   8013fe <syscall>
  801916:	83 c4 18             	add    $0x18,%esp
	return ;
  801919:	90                   	nop
}
  80191a:	c9                   	leave  
  80191b:	c3                   	ret    

0080191c <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  80191c:	55                   	push   %ebp
  80191d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  80191f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801922:	8b 45 08             	mov    0x8(%ebp),%eax
  801925:	6a 00                	push   $0x0
  801927:	6a 00                	push   $0x0
  801929:	6a 00                	push   $0x0
  80192b:	52                   	push   %edx
  80192c:	50                   	push   %eax
  80192d:	6a 2a                	push   $0x2a
  80192f:	e8 ca fa ff ff       	call   8013fe <syscall>
  801934:	83 c4 18             	add    $0x18,%esp
	return;
  801937:	90                   	nop
}
  801938:	c9                   	leave  
  801939:	c3                   	ret    

0080193a <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  80193a:	55                   	push   %ebp
  80193b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  80193d:	6a 00                	push   $0x0
  80193f:	6a 00                	push   $0x0
  801941:	6a 00                	push   $0x0
  801943:	6a 00                	push   $0x0
  801945:	6a 00                	push   $0x0
  801947:	6a 2b                	push   $0x2b
  801949:	e8 b0 fa ff ff       	call   8013fe <syscall>
  80194e:	83 c4 18             	add    $0x18,%esp
}
  801951:	c9                   	leave  
  801952:	c3                   	ret    

00801953 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801953:	55                   	push   %ebp
  801954:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801956:	6a 00                	push   $0x0
  801958:	6a 00                	push   $0x0
  80195a:	6a 00                	push   $0x0
  80195c:	ff 75 0c             	pushl  0xc(%ebp)
  80195f:	ff 75 08             	pushl  0x8(%ebp)
  801962:	6a 2d                	push   $0x2d
  801964:	e8 95 fa ff ff       	call   8013fe <syscall>
  801969:	83 c4 18             	add    $0x18,%esp
	return;
  80196c:	90                   	nop
}
  80196d:	c9                   	leave  
  80196e:	c3                   	ret    

0080196f <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  80196f:	55                   	push   %ebp
  801970:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801972:	6a 00                	push   $0x0
  801974:	6a 00                	push   $0x0
  801976:	6a 00                	push   $0x0
  801978:	ff 75 0c             	pushl  0xc(%ebp)
  80197b:	ff 75 08             	pushl  0x8(%ebp)
  80197e:	6a 2c                	push   $0x2c
  801980:	e8 79 fa ff ff       	call   8013fe <syscall>
  801985:	83 c4 18             	add    $0x18,%esp
	return ;
  801988:	90                   	nop
}
  801989:	c9                   	leave  
  80198a:	c3                   	ret    

0080198b <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  80198b:	55                   	push   %ebp
  80198c:	89 e5                	mov    %esp,%ebp
	//TODO: [PROJECT'25.IM#4] CPU SCHEDULING - #1 System Calls - Add suitable code here
	//Your code is here
	//Comment the following line
	//panic("sys_env_set_priority() is not implemented yet...!!");
	syscall(SYS_env_set_priority, envID, priority, 0, 0, 0);
  80198e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801991:	8b 45 08             	mov    0x8(%ebp),%eax
  801994:	6a 00                	push   $0x0
  801996:	6a 00                	push   $0x0
  801998:	6a 00                	push   $0x0
  80199a:	52                   	push   %edx
  80199b:	50                   	push   %eax
  80199c:	6a 2e                	push   $0x2e
  80199e:	e8 5b fa ff ff       	call   8013fe <syscall>
  8019a3:	83 c4 18             	add    $0x18,%esp
	    return;
  8019a6:	90                   	nop
}
  8019a7:	c9                   	leave  
  8019a8:	c3                   	ret    
  8019a9:	66 90                	xchg   %ax,%ax
  8019ab:	90                   	nop

008019ac <__udivdi3>:
  8019ac:	55                   	push   %ebp
  8019ad:	57                   	push   %edi
  8019ae:	56                   	push   %esi
  8019af:	53                   	push   %ebx
  8019b0:	83 ec 1c             	sub    $0x1c,%esp
  8019b3:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8019b7:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8019bb:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8019bf:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8019c3:	89 ca                	mov    %ecx,%edx
  8019c5:	89 f8                	mov    %edi,%eax
  8019c7:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8019cb:	85 f6                	test   %esi,%esi
  8019cd:	75 2d                	jne    8019fc <__udivdi3+0x50>
  8019cf:	39 cf                	cmp    %ecx,%edi
  8019d1:	77 65                	ja     801a38 <__udivdi3+0x8c>
  8019d3:	89 fd                	mov    %edi,%ebp
  8019d5:	85 ff                	test   %edi,%edi
  8019d7:	75 0b                	jne    8019e4 <__udivdi3+0x38>
  8019d9:	b8 01 00 00 00       	mov    $0x1,%eax
  8019de:	31 d2                	xor    %edx,%edx
  8019e0:	f7 f7                	div    %edi
  8019e2:	89 c5                	mov    %eax,%ebp
  8019e4:	31 d2                	xor    %edx,%edx
  8019e6:	89 c8                	mov    %ecx,%eax
  8019e8:	f7 f5                	div    %ebp
  8019ea:	89 c1                	mov    %eax,%ecx
  8019ec:	89 d8                	mov    %ebx,%eax
  8019ee:	f7 f5                	div    %ebp
  8019f0:	89 cf                	mov    %ecx,%edi
  8019f2:	89 fa                	mov    %edi,%edx
  8019f4:	83 c4 1c             	add    $0x1c,%esp
  8019f7:	5b                   	pop    %ebx
  8019f8:	5e                   	pop    %esi
  8019f9:	5f                   	pop    %edi
  8019fa:	5d                   	pop    %ebp
  8019fb:	c3                   	ret    
  8019fc:	39 ce                	cmp    %ecx,%esi
  8019fe:	77 28                	ja     801a28 <__udivdi3+0x7c>
  801a00:	0f bd fe             	bsr    %esi,%edi
  801a03:	83 f7 1f             	xor    $0x1f,%edi
  801a06:	75 40                	jne    801a48 <__udivdi3+0x9c>
  801a08:	39 ce                	cmp    %ecx,%esi
  801a0a:	72 0a                	jb     801a16 <__udivdi3+0x6a>
  801a0c:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801a10:	0f 87 9e 00 00 00    	ja     801ab4 <__udivdi3+0x108>
  801a16:	b8 01 00 00 00       	mov    $0x1,%eax
  801a1b:	89 fa                	mov    %edi,%edx
  801a1d:	83 c4 1c             	add    $0x1c,%esp
  801a20:	5b                   	pop    %ebx
  801a21:	5e                   	pop    %esi
  801a22:	5f                   	pop    %edi
  801a23:	5d                   	pop    %ebp
  801a24:	c3                   	ret    
  801a25:	8d 76 00             	lea    0x0(%esi),%esi
  801a28:	31 ff                	xor    %edi,%edi
  801a2a:	31 c0                	xor    %eax,%eax
  801a2c:	89 fa                	mov    %edi,%edx
  801a2e:	83 c4 1c             	add    $0x1c,%esp
  801a31:	5b                   	pop    %ebx
  801a32:	5e                   	pop    %esi
  801a33:	5f                   	pop    %edi
  801a34:	5d                   	pop    %ebp
  801a35:	c3                   	ret    
  801a36:	66 90                	xchg   %ax,%ax
  801a38:	89 d8                	mov    %ebx,%eax
  801a3a:	f7 f7                	div    %edi
  801a3c:	31 ff                	xor    %edi,%edi
  801a3e:	89 fa                	mov    %edi,%edx
  801a40:	83 c4 1c             	add    $0x1c,%esp
  801a43:	5b                   	pop    %ebx
  801a44:	5e                   	pop    %esi
  801a45:	5f                   	pop    %edi
  801a46:	5d                   	pop    %ebp
  801a47:	c3                   	ret    
  801a48:	bd 20 00 00 00       	mov    $0x20,%ebp
  801a4d:	89 eb                	mov    %ebp,%ebx
  801a4f:	29 fb                	sub    %edi,%ebx
  801a51:	89 f9                	mov    %edi,%ecx
  801a53:	d3 e6                	shl    %cl,%esi
  801a55:	89 c5                	mov    %eax,%ebp
  801a57:	88 d9                	mov    %bl,%cl
  801a59:	d3 ed                	shr    %cl,%ebp
  801a5b:	89 e9                	mov    %ebp,%ecx
  801a5d:	09 f1                	or     %esi,%ecx
  801a5f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801a63:	89 f9                	mov    %edi,%ecx
  801a65:	d3 e0                	shl    %cl,%eax
  801a67:	89 c5                	mov    %eax,%ebp
  801a69:	89 d6                	mov    %edx,%esi
  801a6b:	88 d9                	mov    %bl,%cl
  801a6d:	d3 ee                	shr    %cl,%esi
  801a6f:	89 f9                	mov    %edi,%ecx
  801a71:	d3 e2                	shl    %cl,%edx
  801a73:	8b 44 24 08          	mov    0x8(%esp),%eax
  801a77:	88 d9                	mov    %bl,%cl
  801a79:	d3 e8                	shr    %cl,%eax
  801a7b:	09 c2                	or     %eax,%edx
  801a7d:	89 d0                	mov    %edx,%eax
  801a7f:	89 f2                	mov    %esi,%edx
  801a81:	f7 74 24 0c          	divl   0xc(%esp)
  801a85:	89 d6                	mov    %edx,%esi
  801a87:	89 c3                	mov    %eax,%ebx
  801a89:	f7 e5                	mul    %ebp
  801a8b:	39 d6                	cmp    %edx,%esi
  801a8d:	72 19                	jb     801aa8 <__udivdi3+0xfc>
  801a8f:	74 0b                	je     801a9c <__udivdi3+0xf0>
  801a91:	89 d8                	mov    %ebx,%eax
  801a93:	31 ff                	xor    %edi,%edi
  801a95:	e9 58 ff ff ff       	jmp    8019f2 <__udivdi3+0x46>
  801a9a:	66 90                	xchg   %ax,%ax
  801a9c:	8b 54 24 08          	mov    0x8(%esp),%edx
  801aa0:	89 f9                	mov    %edi,%ecx
  801aa2:	d3 e2                	shl    %cl,%edx
  801aa4:	39 c2                	cmp    %eax,%edx
  801aa6:	73 e9                	jae    801a91 <__udivdi3+0xe5>
  801aa8:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801aab:	31 ff                	xor    %edi,%edi
  801aad:	e9 40 ff ff ff       	jmp    8019f2 <__udivdi3+0x46>
  801ab2:	66 90                	xchg   %ax,%ax
  801ab4:	31 c0                	xor    %eax,%eax
  801ab6:	e9 37 ff ff ff       	jmp    8019f2 <__udivdi3+0x46>
  801abb:	90                   	nop

00801abc <__umoddi3>:
  801abc:	55                   	push   %ebp
  801abd:	57                   	push   %edi
  801abe:	56                   	push   %esi
  801abf:	53                   	push   %ebx
  801ac0:	83 ec 1c             	sub    $0x1c,%esp
  801ac3:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801ac7:	8b 74 24 34          	mov    0x34(%esp),%esi
  801acb:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801acf:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801ad3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801ad7:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801adb:	89 f3                	mov    %esi,%ebx
  801add:	89 fa                	mov    %edi,%edx
  801adf:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801ae3:	89 34 24             	mov    %esi,(%esp)
  801ae6:	85 c0                	test   %eax,%eax
  801ae8:	75 1a                	jne    801b04 <__umoddi3+0x48>
  801aea:	39 f7                	cmp    %esi,%edi
  801aec:	0f 86 a2 00 00 00    	jbe    801b94 <__umoddi3+0xd8>
  801af2:	89 c8                	mov    %ecx,%eax
  801af4:	89 f2                	mov    %esi,%edx
  801af6:	f7 f7                	div    %edi
  801af8:	89 d0                	mov    %edx,%eax
  801afa:	31 d2                	xor    %edx,%edx
  801afc:	83 c4 1c             	add    $0x1c,%esp
  801aff:	5b                   	pop    %ebx
  801b00:	5e                   	pop    %esi
  801b01:	5f                   	pop    %edi
  801b02:	5d                   	pop    %ebp
  801b03:	c3                   	ret    
  801b04:	39 f0                	cmp    %esi,%eax
  801b06:	0f 87 ac 00 00 00    	ja     801bb8 <__umoddi3+0xfc>
  801b0c:	0f bd e8             	bsr    %eax,%ebp
  801b0f:	83 f5 1f             	xor    $0x1f,%ebp
  801b12:	0f 84 ac 00 00 00    	je     801bc4 <__umoddi3+0x108>
  801b18:	bf 20 00 00 00       	mov    $0x20,%edi
  801b1d:	29 ef                	sub    %ebp,%edi
  801b1f:	89 fe                	mov    %edi,%esi
  801b21:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801b25:	89 e9                	mov    %ebp,%ecx
  801b27:	d3 e0                	shl    %cl,%eax
  801b29:	89 d7                	mov    %edx,%edi
  801b2b:	89 f1                	mov    %esi,%ecx
  801b2d:	d3 ef                	shr    %cl,%edi
  801b2f:	09 c7                	or     %eax,%edi
  801b31:	89 e9                	mov    %ebp,%ecx
  801b33:	d3 e2                	shl    %cl,%edx
  801b35:	89 14 24             	mov    %edx,(%esp)
  801b38:	89 d8                	mov    %ebx,%eax
  801b3a:	d3 e0                	shl    %cl,%eax
  801b3c:	89 c2                	mov    %eax,%edx
  801b3e:	8b 44 24 08          	mov    0x8(%esp),%eax
  801b42:	d3 e0                	shl    %cl,%eax
  801b44:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b48:	8b 44 24 08          	mov    0x8(%esp),%eax
  801b4c:	89 f1                	mov    %esi,%ecx
  801b4e:	d3 e8                	shr    %cl,%eax
  801b50:	09 d0                	or     %edx,%eax
  801b52:	d3 eb                	shr    %cl,%ebx
  801b54:	89 da                	mov    %ebx,%edx
  801b56:	f7 f7                	div    %edi
  801b58:	89 d3                	mov    %edx,%ebx
  801b5a:	f7 24 24             	mull   (%esp)
  801b5d:	89 c6                	mov    %eax,%esi
  801b5f:	89 d1                	mov    %edx,%ecx
  801b61:	39 d3                	cmp    %edx,%ebx
  801b63:	0f 82 87 00 00 00    	jb     801bf0 <__umoddi3+0x134>
  801b69:	0f 84 91 00 00 00    	je     801c00 <__umoddi3+0x144>
  801b6f:	8b 54 24 04          	mov    0x4(%esp),%edx
  801b73:	29 f2                	sub    %esi,%edx
  801b75:	19 cb                	sbb    %ecx,%ebx
  801b77:	89 d8                	mov    %ebx,%eax
  801b79:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801b7d:	d3 e0                	shl    %cl,%eax
  801b7f:	89 e9                	mov    %ebp,%ecx
  801b81:	d3 ea                	shr    %cl,%edx
  801b83:	09 d0                	or     %edx,%eax
  801b85:	89 e9                	mov    %ebp,%ecx
  801b87:	d3 eb                	shr    %cl,%ebx
  801b89:	89 da                	mov    %ebx,%edx
  801b8b:	83 c4 1c             	add    $0x1c,%esp
  801b8e:	5b                   	pop    %ebx
  801b8f:	5e                   	pop    %esi
  801b90:	5f                   	pop    %edi
  801b91:	5d                   	pop    %ebp
  801b92:	c3                   	ret    
  801b93:	90                   	nop
  801b94:	89 fd                	mov    %edi,%ebp
  801b96:	85 ff                	test   %edi,%edi
  801b98:	75 0b                	jne    801ba5 <__umoddi3+0xe9>
  801b9a:	b8 01 00 00 00       	mov    $0x1,%eax
  801b9f:	31 d2                	xor    %edx,%edx
  801ba1:	f7 f7                	div    %edi
  801ba3:	89 c5                	mov    %eax,%ebp
  801ba5:	89 f0                	mov    %esi,%eax
  801ba7:	31 d2                	xor    %edx,%edx
  801ba9:	f7 f5                	div    %ebp
  801bab:	89 c8                	mov    %ecx,%eax
  801bad:	f7 f5                	div    %ebp
  801baf:	89 d0                	mov    %edx,%eax
  801bb1:	e9 44 ff ff ff       	jmp    801afa <__umoddi3+0x3e>
  801bb6:	66 90                	xchg   %ax,%ax
  801bb8:	89 c8                	mov    %ecx,%eax
  801bba:	89 f2                	mov    %esi,%edx
  801bbc:	83 c4 1c             	add    $0x1c,%esp
  801bbf:	5b                   	pop    %ebx
  801bc0:	5e                   	pop    %esi
  801bc1:	5f                   	pop    %edi
  801bc2:	5d                   	pop    %ebp
  801bc3:	c3                   	ret    
  801bc4:	3b 04 24             	cmp    (%esp),%eax
  801bc7:	72 06                	jb     801bcf <__umoddi3+0x113>
  801bc9:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801bcd:	77 0f                	ja     801bde <__umoddi3+0x122>
  801bcf:	89 f2                	mov    %esi,%edx
  801bd1:	29 f9                	sub    %edi,%ecx
  801bd3:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801bd7:	89 14 24             	mov    %edx,(%esp)
  801bda:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801bde:	8b 44 24 04          	mov    0x4(%esp),%eax
  801be2:	8b 14 24             	mov    (%esp),%edx
  801be5:	83 c4 1c             	add    $0x1c,%esp
  801be8:	5b                   	pop    %ebx
  801be9:	5e                   	pop    %esi
  801bea:	5f                   	pop    %edi
  801beb:	5d                   	pop    %ebp
  801bec:	c3                   	ret    
  801bed:	8d 76 00             	lea    0x0(%esi),%esi
  801bf0:	2b 04 24             	sub    (%esp),%eax
  801bf3:	19 fa                	sbb    %edi,%edx
  801bf5:	89 d1                	mov    %edx,%ecx
  801bf7:	89 c6                	mov    %eax,%esi
  801bf9:	e9 71 ff ff ff       	jmp    801b6f <__umoddi3+0xb3>
  801bfe:	66 90                	xchg   %ax,%ax
  801c00:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801c04:	72 ea                	jb     801bf0 <__umoddi3+0x134>
  801c06:	89 d9                	mov    %ebx,%ecx
  801c08:	e9 62 ff ff ff       	jmp    801b6f <__umoddi3+0xb3>
