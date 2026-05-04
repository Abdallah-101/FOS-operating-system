
obj/user/tst_invalid_access_slave2:     file format elf32-i386


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
  800031:	e8 31 00 00 00       	call   800067 <libmain>
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
	//[1] User address but READ-ONLY
	uint32 *ptr = (uint32*)USER_TOP;
  80003e:	c7 45 f4 00 00 c0 ee 	movl   $0xeec00000,-0xc(%ebp)
	*ptr = 100 ;
  800045:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800048:	c7 00 64 00 00 00    	movl   $0x64,(%eax)

	inctst();
  80004e:	e8 a6 17 00 00       	call   8017f9 <inctst>
	panic("tst invalid access failed: Attempt to write on a READ-ONLY user page.\nThe env must be killed and shouldn't return here.");
  800053:	83 ec 04             	sub    $0x4,%esp
  800056:	68 00 1c 80 00       	push   $0x801c00
  80005b:	6a 0e                	push   $0xe
  80005d:	68 78 1c 80 00       	push   $0x801c78
  800062:	e8 b9 01 00 00       	call   800220 <_panic>

00800067 <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  800067:	55                   	push   %ebp
  800068:	89 e5                	mov    %esp,%ebp
  80006a:	57                   	push   %edi
  80006b:	56                   	push   %esi
  80006c:	53                   	push   %ebx
  80006d:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  800070:	e8 46 16 00 00       	call   8016bb <sys_getenvindex>
  800075:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  800078:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80007b:	89 d0                	mov    %edx,%eax
  80007d:	c1 e0 02             	shl    $0x2,%eax
  800080:	01 d0                	add    %edx,%eax
  800082:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800089:	01 d0                	add    %edx,%eax
  80008b:	89 c2                	mov    %eax,%edx
  80008d:	c1 e2 04             	shl    $0x4,%edx
  800090:	29 c2                	sub    %eax,%edx
  800092:	8d 04 95 00 00 00 00 	lea    0x0(,%edx,4),%eax
  800099:	89 c2                	mov    %eax,%edx
  80009b:	8d 82 00 00 c0 ee    	lea    -0x11400000(%edx),%eax
  8000a1:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8000a6:	a1 20 30 80 00       	mov    0x803020,%eax
  8000ab:	8a 40 20             	mov    0x20(%eax),%al
  8000ae:	84 c0                	test   %al,%al
  8000b0:	74 0d                	je     8000bf <libmain+0x58>
		binaryname = myEnv->prog_name;
  8000b2:	a1 20 30 80 00       	mov    0x803020,%eax
  8000b7:	83 c0 20             	add    $0x20,%eax
  8000ba:	a3 04 30 80 00       	mov    %eax,0x803004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000bf:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8000c3:	7e 0a                	jle    8000cf <libmain+0x68>
		binaryname = argv[0];
  8000c5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8000c8:	8b 00                	mov    (%eax),%eax
  8000ca:	a3 04 30 80 00       	mov    %eax,0x803004

	// call user main routine
	_main(argc, argv);
  8000cf:	83 ec 08             	sub    $0x8,%esp
  8000d2:	ff 75 0c             	pushl  0xc(%ebp)
  8000d5:	ff 75 08             	pushl  0x8(%ebp)
  8000d8:	e8 5b ff ff ff       	call   800038 <_main>
  8000dd:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  8000e0:	a1 00 30 80 00       	mov    0x803000,%eax
  8000e5:	85 c0                	test   %eax,%eax
  8000e7:	0f 84 01 01 00 00    	je     8001ee <libmain+0x187>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  8000ed:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  8000f3:	bb 94 1d 80 00       	mov    $0x801d94,%ebx
  8000f8:	ba 0e 00 00 00       	mov    $0xe,%edx
  8000fd:	89 c7                	mov    %eax,%edi
  8000ff:	89 de                	mov    %ebx,%esi
  800101:	89 d1                	mov    %edx,%ecx
  800103:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  800105:	8d 55 8a             	lea    -0x76(%ebp),%edx
  800108:	b9 56 00 00 00       	mov    $0x56,%ecx
  80010d:	b0 00                	mov    $0x0,%al
  80010f:	89 d7                	mov    %edx,%edi
  800111:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  800113:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  80011a:	8d 45 e0             	lea    -0x20(%ebp),%eax
  80011d:	83 ec 08             	sub    $0x8,%esp
  800120:	50                   	push   %eax
  800121:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  800127:	50                   	push   %eax
  800128:	e8 c4 17 00 00       	call   8018f1 <sys_utilities>
  80012d:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  800130:	e8 0d 13 00 00       	call   801442 <sys_lock_cons>
		{
			cprintf("**************************************\n");
  800135:	83 ec 0c             	sub    $0xc,%esp
  800138:	68 b4 1c 80 00       	push   $0x801cb4
  80013d:	e8 ac 03 00 00       	call   8004ee <cprintf>
  800142:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  800145:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800148:	85 c0                	test   %eax,%eax
  80014a:	74 18                	je     800164 <libmain+0xfd>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  80014c:	e8 be 17 00 00       	call   80190f <sys_get_optimal_num_faults>
  800151:	83 ec 08             	sub    $0x8,%esp
  800154:	50                   	push   %eax
  800155:	68 dc 1c 80 00       	push   $0x801cdc
  80015a:	e8 8f 03 00 00       	call   8004ee <cprintf>
  80015f:	83 c4 10             	add    $0x10,%esp
  800162:	eb 59                	jmp    8001bd <libmain+0x156>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800164:	a1 20 30 80 00       	mov    0x803020,%eax
  800169:	8b 90 bc 05 00 00    	mov    0x5bc(%eax),%edx
  80016f:	a1 20 30 80 00       	mov    0x803020,%eax
  800174:	8b 80 ac 05 00 00    	mov    0x5ac(%eax),%eax
  80017a:	83 ec 04             	sub    $0x4,%esp
  80017d:	52                   	push   %edx
  80017e:	50                   	push   %eax
  80017f:	68 00 1d 80 00       	push   $0x801d00
  800184:	e8 65 03 00 00       	call   8004ee <cprintf>
  800189:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  80018c:	a1 20 30 80 00       	mov    0x803020,%eax
  800191:	8b 88 d0 05 00 00    	mov    0x5d0(%eax),%ecx
  800197:	a1 20 30 80 00       	mov    0x803020,%eax
  80019c:	8b 90 cc 05 00 00    	mov    0x5cc(%eax),%edx
  8001a2:	a1 20 30 80 00       	mov    0x803020,%eax
  8001a7:	8b 80 c8 05 00 00    	mov    0x5c8(%eax),%eax
  8001ad:	51                   	push   %ecx
  8001ae:	52                   	push   %edx
  8001af:	50                   	push   %eax
  8001b0:	68 28 1d 80 00       	push   $0x801d28
  8001b5:	e8 34 03 00 00       	call   8004ee <cprintf>
  8001ba:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8001bd:	a1 20 30 80 00       	mov    0x803020,%eax
  8001c2:	8b 80 d4 05 00 00    	mov    0x5d4(%eax),%eax
  8001c8:	83 ec 08             	sub    $0x8,%esp
  8001cb:	50                   	push   %eax
  8001cc:	68 80 1d 80 00       	push   $0x801d80
  8001d1:	e8 18 03 00 00       	call   8004ee <cprintf>
  8001d6:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  8001d9:	83 ec 0c             	sub    $0xc,%esp
  8001dc:	68 b4 1c 80 00       	push   $0x801cb4
  8001e1:	e8 08 03 00 00       	call   8004ee <cprintf>
  8001e6:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  8001e9:	e8 6e 12 00 00       	call   80145c <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  8001ee:	e8 1f 00 00 00       	call   800212 <exit>
}
  8001f3:	90                   	nop
  8001f4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8001f7:	5b                   	pop    %ebx
  8001f8:	5e                   	pop    %esi
  8001f9:	5f                   	pop    %edi
  8001fa:	5d                   	pop    %ebp
  8001fb:	c3                   	ret    

008001fc <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8001fc:	55                   	push   %ebp
  8001fd:	89 e5                	mov    %esp,%ebp
  8001ff:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800202:	83 ec 0c             	sub    $0xc,%esp
  800205:	6a 00                	push   $0x0
  800207:	e8 7b 14 00 00       	call   801687 <sys_destroy_env>
  80020c:	83 c4 10             	add    $0x10,%esp
}
  80020f:	90                   	nop
  800210:	c9                   	leave  
  800211:	c3                   	ret    

00800212 <exit>:

void
exit(void)
{
  800212:	55                   	push   %ebp
  800213:	89 e5                	mov    %esp,%ebp
  800215:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800218:	e8 d0 14 00 00       	call   8016ed <sys_exit_env>
}
  80021d:	90                   	nop
  80021e:	c9                   	leave  
  80021f:	c3                   	ret    

00800220 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800220:	55                   	push   %ebp
  800221:	89 e5                	mov    %esp,%ebp
  800223:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800226:	8d 45 10             	lea    0x10(%ebp),%eax
  800229:	83 c0 04             	add    $0x4,%eax
  80022c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  80022f:	a1 18 b1 81 00       	mov    0x81b118,%eax
  800234:	85 c0                	test   %eax,%eax
  800236:	74 16                	je     80024e <_panic+0x2e>
		cprintf("%s: ", argv0);
  800238:	a1 18 b1 81 00       	mov    0x81b118,%eax
  80023d:	83 ec 08             	sub    $0x8,%esp
  800240:	50                   	push   %eax
  800241:	68 f8 1d 80 00       	push   $0x801df8
  800246:	e8 a3 02 00 00       	call   8004ee <cprintf>
  80024b:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  80024e:	a1 04 30 80 00       	mov    0x803004,%eax
  800253:	83 ec 0c             	sub    $0xc,%esp
  800256:	ff 75 0c             	pushl  0xc(%ebp)
  800259:	ff 75 08             	pushl  0x8(%ebp)
  80025c:	50                   	push   %eax
  80025d:	68 00 1e 80 00       	push   $0x801e00
  800262:	6a 74                	push   $0x74
  800264:	e8 b2 02 00 00       	call   80051b <cprintf_colored>
  800269:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  80026c:	8b 45 10             	mov    0x10(%ebp),%eax
  80026f:	83 ec 08             	sub    $0x8,%esp
  800272:	ff 75 f4             	pushl  -0xc(%ebp)
  800275:	50                   	push   %eax
  800276:	e8 04 02 00 00       	call   80047f <vcprintf>
  80027b:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  80027e:	83 ec 08             	sub    $0x8,%esp
  800281:	6a 00                	push   $0x0
  800283:	68 28 1e 80 00       	push   $0x801e28
  800288:	e8 f2 01 00 00       	call   80047f <vcprintf>
  80028d:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800290:	e8 7d ff ff ff       	call   800212 <exit>

	// should not return here
	while (1) ;
  800295:	eb fe                	jmp    800295 <_panic+0x75>

00800297 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800297:	55                   	push   %ebp
  800298:	89 e5                	mov    %esp,%ebp
  80029a:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  80029d:	a1 20 30 80 00       	mov    0x803020,%eax
  8002a2:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8002a8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002ab:	39 c2                	cmp    %eax,%edx
  8002ad:	74 14                	je     8002c3 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8002af:	83 ec 04             	sub    $0x4,%esp
  8002b2:	68 2c 1e 80 00       	push   $0x801e2c
  8002b7:	6a 26                	push   $0x26
  8002b9:	68 78 1e 80 00       	push   $0x801e78
  8002be:	e8 5d ff ff ff       	call   800220 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8002c3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8002ca:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8002d1:	e9 c5 00 00 00       	jmp    80039b <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  8002d6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8002d9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8002e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8002e3:	01 d0                	add    %edx,%eax
  8002e5:	8b 00                	mov    (%eax),%eax
  8002e7:	85 c0                	test   %eax,%eax
  8002e9:	75 08                	jne    8002f3 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  8002eb:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8002ee:	e9 a5 00 00 00       	jmp    800398 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  8002f3:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8002fa:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800301:	eb 69                	jmp    80036c <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800303:	a1 20 30 80 00       	mov    0x803020,%eax
  800308:	8b 88 a4 05 00 00    	mov    0x5a4(%eax),%ecx
  80030e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800311:	89 d0                	mov    %edx,%eax
  800313:	01 c0                	add    %eax,%eax
  800315:	01 d0                	add    %edx,%eax
  800317:	c1 e0 03             	shl    $0x3,%eax
  80031a:	01 c8                	add    %ecx,%eax
  80031c:	8a 40 04             	mov    0x4(%eax),%al
  80031f:	84 c0                	test   %al,%al
  800321:	75 46                	jne    800369 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800323:	a1 20 30 80 00       	mov    0x803020,%eax
  800328:	8b 88 a4 05 00 00    	mov    0x5a4(%eax),%ecx
  80032e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800331:	89 d0                	mov    %edx,%eax
  800333:	01 c0                	add    %eax,%eax
  800335:	01 d0                	add    %edx,%eax
  800337:	c1 e0 03             	shl    $0x3,%eax
  80033a:	01 c8                	add    %ecx,%eax
  80033c:	8b 00                	mov    (%eax),%eax
  80033e:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800341:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800344:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800349:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  80034b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80034e:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800355:	8b 45 08             	mov    0x8(%ebp),%eax
  800358:	01 c8                	add    %ecx,%eax
  80035a:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80035c:	39 c2                	cmp    %eax,%edx
  80035e:	75 09                	jne    800369 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  800360:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800367:	eb 15                	jmp    80037e <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800369:	ff 45 e8             	incl   -0x18(%ebp)
  80036c:	a1 20 30 80 00       	mov    0x803020,%eax
  800371:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800377:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80037a:	39 c2                	cmp    %eax,%edx
  80037c:	77 85                	ja     800303 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  80037e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800382:	75 14                	jne    800398 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  800384:	83 ec 04             	sub    $0x4,%esp
  800387:	68 84 1e 80 00       	push   $0x801e84
  80038c:	6a 3a                	push   $0x3a
  80038e:	68 78 1e 80 00       	push   $0x801e78
  800393:	e8 88 fe ff ff       	call   800220 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800398:	ff 45 f0             	incl   -0x10(%ebp)
  80039b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80039e:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8003a1:	0f 8c 2f ff ff ff    	jl     8002d6 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8003a7:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8003ae:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8003b5:	eb 26                	jmp    8003dd <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  8003b7:	a1 20 30 80 00       	mov    0x803020,%eax
  8003bc:	8b 88 a4 05 00 00    	mov    0x5a4(%eax),%ecx
  8003c2:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8003c5:	89 d0                	mov    %edx,%eax
  8003c7:	01 c0                	add    %eax,%eax
  8003c9:	01 d0                	add    %edx,%eax
  8003cb:	c1 e0 03             	shl    $0x3,%eax
  8003ce:	01 c8                	add    %ecx,%eax
  8003d0:	8a 40 04             	mov    0x4(%eax),%al
  8003d3:	3c 01                	cmp    $0x1,%al
  8003d5:	75 03                	jne    8003da <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  8003d7:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8003da:	ff 45 e0             	incl   -0x20(%ebp)
  8003dd:	a1 20 30 80 00       	mov    0x803020,%eax
  8003e2:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8003e8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8003eb:	39 c2                	cmp    %eax,%edx
  8003ed:	77 c8                	ja     8003b7 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8003ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8003f2:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8003f5:	74 14                	je     80040b <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  8003f7:	83 ec 04             	sub    $0x4,%esp
  8003fa:	68 d8 1e 80 00       	push   $0x801ed8
  8003ff:	6a 44                	push   $0x44
  800401:	68 78 1e 80 00       	push   $0x801e78
  800406:	e8 15 fe ff ff       	call   800220 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  80040b:	90                   	nop
  80040c:	c9                   	leave  
  80040d:	c3                   	ret    

0080040e <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  80040e:	55                   	push   %ebp
  80040f:	89 e5                	mov    %esp,%ebp
  800411:	53                   	push   %ebx
  800412:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  800415:	8b 45 0c             	mov    0xc(%ebp),%eax
  800418:	8b 00                	mov    (%eax),%eax
  80041a:	8d 48 01             	lea    0x1(%eax),%ecx
  80041d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800420:	89 0a                	mov    %ecx,(%edx)
  800422:	8b 55 08             	mov    0x8(%ebp),%edx
  800425:	88 d1                	mov    %dl,%cl
  800427:	8b 55 0c             	mov    0xc(%ebp),%edx
  80042a:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  80042e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800431:	8b 00                	mov    (%eax),%eax
  800433:	3d ff 00 00 00       	cmp    $0xff,%eax
  800438:	75 30                	jne    80046a <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  80043a:	8b 15 1c b1 81 00    	mov    0x81b11c,%edx
  800440:	a0 44 30 80 00       	mov    0x803044,%al
  800445:	0f b6 c0             	movzbl %al,%eax
  800448:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80044b:	8b 09                	mov    (%ecx),%ecx
  80044d:	89 cb                	mov    %ecx,%ebx
  80044f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800452:	83 c1 08             	add    $0x8,%ecx
  800455:	52                   	push   %edx
  800456:	50                   	push   %eax
  800457:	53                   	push   %ebx
  800458:	51                   	push   %ecx
  800459:	e8 a0 0f 00 00       	call   8013fe <sys_cputs>
  80045e:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800461:	8b 45 0c             	mov    0xc(%ebp),%eax
  800464:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  80046a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80046d:	8b 40 04             	mov    0x4(%eax),%eax
  800470:	8d 50 01             	lea    0x1(%eax),%edx
  800473:	8b 45 0c             	mov    0xc(%ebp),%eax
  800476:	89 50 04             	mov    %edx,0x4(%eax)
}
  800479:	90                   	nop
  80047a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80047d:	c9                   	leave  
  80047e:	c3                   	ret    

0080047f <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  80047f:	55                   	push   %ebp
  800480:	89 e5                	mov    %esp,%ebp
  800482:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800488:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80048f:	00 00 00 
	b.cnt = 0;
  800492:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800499:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  80049c:	ff 75 0c             	pushl  0xc(%ebp)
  80049f:	ff 75 08             	pushl  0x8(%ebp)
  8004a2:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8004a8:	50                   	push   %eax
  8004a9:	68 0e 04 80 00       	push   $0x80040e
  8004ae:	e8 5a 02 00 00       	call   80070d <vprintfmt>
  8004b3:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  8004b6:	8b 15 1c b1 81 00    	mov    0x81b11c,%edx
  8004bc:	a0 44 30 80 00       	mov    0x803044,%al
  8004c1:	0f b6 c0             	movzbl %al,%eax
  8004c4:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  8004ca:	52                   	push   %edx
  8004cb:	50                   	push   %eax
  8004cc:	51                   	push   %ecx
  8004cd:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8004d3:	83 c0 08             	add    $0x8,%eax
  8004d6:	50                   	push   %eax
  8004d7:	e8 22 0f 00 00       	call   8013fe <sys_cputs>
  8004dc:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8004df:	c6 05 44 30 80 00 00 	movb   $0x0,0x803044
	return b.cnt;
  8004e6:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8004ec:	c9                   	leave  
  8004ed:	c3                   	ret    

008004ee <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  8004ee:	55                   	push   %ebp
  8004ef:	89 e5                	mov    %esp,%ebp
  8004f1:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8004f4:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
	va_start(ap, fmt);
  8004fb:	8d 45 0c             	lea    0xc(%ebp),%eax
  8004fe:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800501:	8b 45 08             	mov    0x8(%ebp),%eax
  800504:	83 ec 08             	sub    $0x8,%esp
  800507:	ff 75 f4             	pushl  -0xc(%ebp)
  80050a:	50                   	push   %eax
  80050b:	e8 6f ff ff ff       	call   80047f <vcprintf>
  800510:	83 c4 10             	add    $0x10,%esp
  800513:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800516:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800519:	c9                   	leave  
  80051a:	c3                   	ret    

0080051b <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  80051b:	55                   	push   %ebp
  80051c:	89 e5                	mov    %esp,%ebp
  80051e:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800521:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
	curTextClr = (textClr << 8) ; //set text color by the given value
  800528:	8b 45 08             	mov    0x8(%ebp),%eax
  80052b:	c1 e0 08             	shl    $0x8,%eax
  80052e:	a3 1c b1 81 00       	mov    %eax,0x81b11c
	va_start(ap, fmt);
  800533:	8d 45 0c             	lea    0xc(%ebp),%eax
  800536:	83 c0 04             	add    $0x4,%eax
  800539:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80053c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80053f:	83 ec 08             	sub    $0x8,%esp
  800542:	ff 75 f4             	pushl  -0xc(%ebp)
  800545:	50                   	push   %eax
  800546:	e8 34 ff ff ff       	call   80047f <vcprintf>
  80054b:	83 c4 10             	add    $0x10,%esp
  80054e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  800551:	c7 05 1c b1 81 00 00 	movl   $0x700,0x81b11c
  800558:	07 00 00 

	return cnt;
  80055b:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80055e:	c9                   	leave  
  80055f:	c3                   	ret    

00800560 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  800560:	55                   	push   %ebp
  800561:	89 e5                	mov    %esp,%ebp
  800563:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  800566:	e8 d7 0e 00 00       	call   801442 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  80056b:	8d 45 0c             	lea    0xc(%ebp),%eax
  80056e:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  800571:	8b 45 08             	mov    0x8(%ebp),%eax
  800574:	83 ec 08             	sub    $0x8,%esp
  800577:	ff 75 f4             	pushl  -0xc(%ebp)
  80057a:	50                   	push   %eax
  80057b:	e8 ff fe ff ff       	call   80047f <vcprintf>
  800580:	83 c4 10             	add    $0x10,%esp
  800583:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  800586:	e8 d1 0e 00 00       	call   80145c <sys_unlock_cons>
	return cnt;
  80058b:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80058e:	c9                   	leave  
  80058f:	c3                   	ret    

00800590 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800590:	55                   	push   %ebp
  800591:	89 e5                	mov    %esp,%ebp
  800593:	53                   	push   %ebx
  800594:	83 ec 14             	sub    $0x14,%esp
  800597:	8b 45 10             	mov    0x10(%ebp),%eax
  80059a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80059d:	8b 45 14             	mov    0x14(%ebp),%eax
  8005a0:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8005a3:	8b 45 18             	mov    0x18(%ebp),%eax
  8005a6:	ba 00 00 00 00       	mov    $0x0,%edx
  8005ab:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8005ae:	77 55                	ja     800605 <printnum+0x75>
  8005b0:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8005b3:	72 05                	jb     8005ba <printnum+0x2a>
  8005b5:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8005b8:	77 4b                	ja     800605 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8005ba:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8005bd:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8005c0:	8b 45 18             	mov    0x18(%ebp),%eax
  8005c3:	ba 00 00 00 00       	mov    $0x0,%edx
  8005c8:	52                   	push   %edx
  8005c9:	50                   	push   %eax
  8005ca:	ff 75 f4             	pushl  -0xc(%ebp)
  8005cd:	ff 75 f0             	pushl  -0x10(%ebp)
  8005d0:	e8 ab 13 00 00       	call   801980 <__udivdi3>
  8005d5:	83 c4 10             	add    $0x10,%esp
  8005d8:	83 ec 04             	sub    $0x4,%esp
  8005db:	ff 75 20             	pushl  0x20(%ebp)
  8005de:	53                   	push   %ebx
  8005df:	ff 75 18             	pushl  0x18(%ebp)
  8005e2:	52                   	push   %edx
  8005e3:	50                   	push   %eax
  8005e4:	ff 75 0c             	pushl  0xc(%ebp)
  8005e7:	ff 75 08             	pushl  0x8(%ebp)
  8005ea:	e8 a1 ff ff ff       	call   800590 <printnum>
  8005ef:	83 c4 20             	add    $0x20,%esp
  8005f2:	eb 1a                	jmp    80060e <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8005f4:	83 ec 08             	sub    $0x8,%esp
  8005f7:	ff 75 0c             	pushl  0xc(%ebp)
  8005fa:	ff 75 20             	pushl  0x20(%ebp)
  8005fd:	8b 45 08             	mov    0x8(%ebp),%eax
  800600:	ff d0                	call   *%eax
  800602:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800605:	ff 4d 1c             	decl   0x1c(%ebp)
  800608:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  80060c:	7f e6                	jg     8005f4 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80060e:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800611:	bb 00 00 00 00       	mov    $0x0,%ebx
  800616:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800619:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80061c:	53                   	push   %ebx
  80061d:	51                   	push   %ecx
  80061e:	52                   	push   %edx
  80061f:	50                   	push   %eax
  800620:	e8 6b 14 00 00       	call   801a90 <__umoddi3>
  800625:	83 c4 10             	add    $0x10,%esp
  800628:	05 54 21 80 00       	add    $0x802154,%eax
  80062d:	8a 00                	mov    (%eax),%al
  80062f:	0f be c0             	movsbl %al,%eax
  800632:	83 ec 08             	sub    $0x8,%esp
  800635:	ff 75 0c             	pushl  0xc(%ebp)
  800638:	50                   	push   %eax
  800639:	8b 45 08             	mov    0x8(%ebp),%eax
  80063c:	ff d0                	call   *%eax
  80063e:	83 c4 10             	add    $0x10,%esp
}
  800641:	90                   	nop
  800642:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800645:	c9                   	leave  
  800646:	c3                   	ret    

00800647 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800647:	55                   	push   %ebp
  800648:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80064a:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80064e:	7e 1c                	jle    80066c <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800650:	8b 45 08             	mov    0x8(%ebp),%eax
  800653:	8b 00                	mov    (%eax),%eax
  800655:	8d 50 08             	lea    0x8(%eax),%edx
  800658:	8b 45 08             	mov    0x8(%ebp),%eax
  80065b:	89 10                	mov    %edx,(%eax)
  80065d:	8b 45 08             	mov    0x8(%ebp),%eax
  800660:	8b 00                	mov    (%eax),%eax
  800662:	83 e8 08             	sub    $0x8,%eax
  800665:	8b 50 04             	mov    0x4(%eax),%edx
  800668:	8b 00                	mov    (%eax),%eax
  80066a:	eb 40                	jmp    8006ac <getuint+0x65>
	else if (lflag)
  80066c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800670:	74 1e                	je     800690 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800672:	8b 45 08             	mov    0x8(%ebp),%eax
  800675:	8b 00                	mov    (%eax),%eax
  800677:	8d 50 04             	lea    0x4(%eax),%edx
  80067a:	8b 45 08             	mov    0x8(%ebp),%eax
  80067d:	89 10                	mov    %edx,(%eax)
  80067f:	8b 45 08             	mov    0x8(%ebp),%eax
  800682:	8b 00                	mov    (%eax),%eax
  800684:	83 e8 04             	sub    $0x4,%eax
  800687:	8b 00                	mov    (%eax),%eax
  800689:	ba 00 00 00 00       	mov    $0x0,%edx
  80068e:	eb 1c                	jmp    8006ac <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800690:	8b 45 08             	mov    0x8(%ebp),%eax
  800693:	8b 00                	mov    (%eax),%eax
  800695:	8d 50 04             	lea    0x4(%eax),%edx
  800698:	8b 45 08             	mov    0x8(%ebp),%eax
  80069b:	89 10                	mov    %edx,(%eax)
  80069d:	8b 45 08             	mov    0x8(%ebp),%eax
  8006a0:	8b 00                	mov    (%eax),%eax
  8006a2:	83 e8 04             	sub    $0x4,%eax
  8006a5:	8b 00                	mov    (%eax),%eax
  8006a7:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8006ac:	5d                   	pop    %ebp
  8006ad:	c3                   	ret    

008006ae <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8006ae:	55                   	push   %ebp
  8006af:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8006b1:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8006b5:	7e 1c                	jle    8006d3 <getint+0x25>
		return va_arg(*ap, long long);
  8006b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ba:	8b 00                	mov    (%eax),%eax
  8006bc:	8d 50 08             	lea    0x8(%eax),%edx
  8006bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8006c2:	89 10                	mov    %edx,(%eax)
  8006c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8006c7:	8b 00                	mov    (%eax),%eax
  8006c9:	83 e8 08             	sub    $0x8,%eax
  8006cc:	8b 50 04             	mov    0x4(%eax),%edx
  8006cf:	8b 00                	mov    (%eax),%eax
  8006d1:	eb 38                	jmp    80070b <getint+0x5d>
	else if (lflag)
  8006d3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8006d7:	74 1a                	je     8006f3 <getint+0x45>
		return va_arg(*ap, long);
  8006d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8006dc:	8b 00                	mov    (%eax),%eax
  8006de:	8d 50 04             	lea    0x4(%eax),%edx
  8006e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8006e4:	89 10                	mov    %edx,(%eax)
  8006e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8006e9:	8b 00                	mov    (%eax),%eax
  8006eb:	83 e8 04             	sub    $0x4,%eax
  8006ee:	8b 00                	mov    (%eax),%eax
  8006f0:	99                   	cltd   
  8006f1:	eb 18                	jmp    80070b <getint+0x5d>
	else
		return va_arg(*ap, int);
  8006f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8006f6:	8b 00                	mov    (%eax),%eax
  8006f8:	8d 50 04             	lea    0x4(%eax),%edx
  8006fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8006fe:	89 10                	mov    %edx,(%eax)
  800700:	8b 45 08             	mov    0x8(%ebp),%eax
  800703:	8b 00                	mov    (%eax),%eax
  800705:	83 e8 04             	sub    $0x4,%eax
  800708:	8b 00                	mov    (%eax),%eax
  80070a:	99                   	cltd   
}
  80070b:	5d                   	pop    %ebp
  80070c:	c3                   	ret    

0080070d <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80070d:	55                   	push   %ebp
  80070e:	89 e5                	mov    %esp,%ebp
  800710:	56                   	push   %esi
  800711:	53                   	push   %ebx
  800712:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800715:	eb 17                	jmp    80072e <vprintfmt+0x21>
			if (ch == '\0')
  800717:	85 db                	test   %ebx,%ebx
  800719:	0f 84 c1 03 00 00    	je     800ae0 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  80071f:	83 ec 08             	sub    $0x8,%esp
  800722:	ff 75 0c             	pushl  0xc(%ebp)
  800725:	53                   	push   %ebx
  800726:	8b 45 08             	mov    0x8(%ebp),%eax
  800729:	ff d0                	call   *%eax
  80072b:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80072e:	8b 45 10             	mov    0x10(%ebp),%eax
  800731:	8d 50 01             	lea    0x1(%eax),%edx
  800734:	89 55 10             	mov    %edx,0x10(%ebp)
  800737:	8a 00                	mov    (%eax),%al
  800739:	0f b6 d8             	movzbl %al,%ebx
  80073c:	83 fb 25             	cmp    $0x25,%ebx
  80073f:	75 d6                	jne    800717 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800741:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800745:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  80074c:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800753:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  80075a:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800761:	8b 45 10             	mov    0x10(%ebp),%eax
  800764:	8d 50 01             	lea    0x1(%eax),%edx
  800767:	89 55 10             	mov    %edx,0x10(%ebp)
  80076a:	8a 00                	mov    (%eax),%al
  80076c:	0f b6 d8             	movzbl %al,%ebx
  80076f:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800772:	83 f8 5b             	cmp    $0x5b,%eax
  800775:	0f 87 3d 03 00 00    	ja     800ab8 <vprintfmt+0x3ab>
  80077b:	8b 04 85 78 21 80 00 	mov    0x802178(,%eax,4),%eax
  800782:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800784:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800788:	eb d7                	jmp    800761 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  80078a:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  80078e:	eb d1                	jmp    800761 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800790:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800797:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80079a:	89 d0                	mov    %edx,%eax
  80079c:	c1 e0 02             	shl    $0x2,%eax
  80079f:	01 d0                	add    %edx,%eax
  8007a1:	01 c0                	add    %eax,%eax
  8007a3:	01 d8                	add    %ebx,%eax
  8007a5:	83 e8 30             	sub    $0x30,%eax
  8007a8:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8007ab:	8b 45 10             	mov    0x10(%ebp),%eax
  8007ae:	8a 00                	mov    (%eax),%al
  8007b0:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8007b3:	83 fb 2f             	cmp    $0x2f,%ebx
  8007b6:	7e 3e                	jle    8007f6 <vprintfmt+0xe9>
  8007b8:	83 fb 39             	cmp    $0x39,%ebx
  8007bb:	7f 39                	jg     8007f6 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8007bd:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8007c0:	eb d5                	jmp    800797 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8007c2:	8b 45 14             	mov    0x14(%ebp),%eax
  8007c5:	83 c0 04             	add    $0x4,%eax
  8007c8:	89 45 14             	mov    %eax,0x14(%ebp)
  8007cb:	8b 45 14             	mov    0x14(%ebp),%eax
  8007ce:	83 e8 04             	sub    $0x4,%eax
  8007d1:	8b 00                	mov    (%eax),%eax
  8007d3:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8007d6:	eb 1f                	jmp    8007f7 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8007d8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8007dc:	79 83                	jns    800761 <vprintfmt+0x54>
				width = 0;
  8007de:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8007e5:	e9 77 ff ff ff       	jmp    800761 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  8007ea:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  8007f1:	e9 6b ff ff ff       	jmp    800761 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  8007f6:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8007f7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8007fb:	0f 89 60 ff ff ff    	jns    800761 <vprintfmt+0x54>
				width = precision, precision = -1;
  800801:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800804:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800807:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  80080e:	e9 4e ff ff ff       	jmp    800761 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800813:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800816:	e9 46 ff ff ff       	jmp    800761 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  80081b:	8b 45 14             	mov    0x14(%ebp),%eax
  80081e:	83 c0 04             	add    $0x4,%eax
  800821:	89 45 14             	mov    %eax,0x14(%ebp)
  800824:	8b 45 14             	mov    0x14(%ebp),%eax
  800827:	83 e8 04             	sub    $0x4,%eax
  80082a:	8b 00                	mov    (%eax),%eax
  80082c:	83 ec 08             	sub    $0x8,%esp
  80082f:	ff 75 0c             	pushl  0xc(%ebp)
  800832:	50                   	push   %eax
  800833:	8b 45 08             	mov    0x8(%ebp),%eax
  800836:	ff d0                	call   *%eax
  800838:	83 c4 10             	add    $0x10,%esp
			break;
  80083b:	e9 9b 02 00 00       	jmp    800adb <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800840:	8b 45 14             	mov    0x14(%ebp),%eax
  800843:	83 c0 04             	add    $0x4,%eax
  800846:	89 45 14             	mov    %eax,0x14(%ebp)
  800849:	8b 45 14             	mov    0x14(%ebp),%eax
  80084c:	83 e8 04             	sub    $0x4,%eax
  80084f:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800851:	85 db                	test   %ebx,%ebx
  800853:	79 02                	jns    800857 <vprintfmt+0x14a>
				err = -err;
  800855:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800857:	83 fb 64             	cmp    $0x64,%ebx
  80085a:	7f 0b                	jg     800867 <vprintfmt+0x15a>
  80085c:	8b 34 9d c0 1f 80 00 	mov    0x801fc0(,%ebx,4),%esi
  800863:	85 f6                	test   %esi,%esi
  800865:	75 19                	jne    800880 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800867:	53                   	push   %ebx
  800868:	68 65 21 80 00       	push   $0x802165
  80086d:	ff 75 0c             	pushl  0xc(%ebp)
  800870:	ff 75 08             	pushl  0x8(%ebp)
  800873:	e8 70 02 00 00       	call   800ae8 <printfmt>
  800878:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  80087b:	e9 5b 02 00 00       	jmp    800adb <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800880:	56                   	push   %esi
  800881:	68 6e 21 80 00       	push   $0x80216e
  800886:	ff 75 0c             	pushl  0xc(%ebp)
  800889:	ff 75 08             	pushl  0x8(%ebp)
  80088c:	e8 57 02 00 00       	call   800ae8 <printfmt>
  800891:	83 c4 10             	add    $0x10,%esp
			break;
  800894:	e9 42 02 00 00       	jmp    800adb <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800899:	8b 45 14             	mov    0x14(%ebp),%eax
  80089c:	83 c0 04             	add    $0x4,%eax
  80089f:	89 45 14             	mov    %eax,0x14(%ebp)
  8008a2:	8b 45 14             	mov    0x14(%ebp),%eax
  8008a5:	83 e8 04             	sub    $0x4,%eax
  8008a8:	8b 30                	mov    (%eax),%esi
  8008aa:	85 f6                	test   %esi,%esi
  8008ac:	75 05                	jne    8008b3 <vprintfmt+0x1a6>
				p = "(null)";
  8008ae:	be 71 21 80 00       	mov    $0x802171,%esi
			if (width > 0 && padc != '-')
  8008b3:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008b7:	7e 6d                	jle    800926 <vprintfmt+0x219>
  8008b9:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8008bd:	74 67                	je     800926 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8008bf:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8008c2:	83 ec 08             	sub    $0x8,%esp
  8008c5:	50                   	push   %eax
  8008c6:	56                   	push   %esi
  8008c7:	e8 1e 03 00 00       	call   800bea <strnlen>
  8008cc:	83 c4 10             	add    $0x10,%esp
  8008cf:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  8008d2:	eb 16                	jmp    8008ea <vprintfmt+0x1dd>
					putch(padc, putdat);
  8008d4:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  8008d8:	83 ec 08             	sub    $0x8,%esp
  8008db:	ff 75 0c             	pushl  0xc(%ebp)
  8008de:	50                   	push   %eax
  8008df:	8b 45 08             	mov    0x8(%ebp),%eax
  8008e2:	ff d0                	call   *%eax
  8008e4:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8008e7:	ff 4d e4             	decl   -0x1c(%ebp)
  8008ea:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008ee:	7f e4                	jg     8008d4 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8008f0:	eb 34                	jmp    800926 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  8008f2:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8008f6:	74 1c                	je     800914 <vprintfmt+0x207>
  8008f8:	83 fb 1f             	cmp    $0x1f,%ebx
  8008fb:	7e 05                	jle    800902 <vprintfmt+0x1f5>
  8008fd:	83 fb 7e             	cmp    $0x7e,%ebx
  800900:	7e 12                	jle    800914 <vprintfmt+0x207>
					putch('?', putdat);
  800902:	83 ec 08             	sub    $0x8,%esp
  800905:	ff 75 0c             	pushl  0xc(%ebp)
  800908:	6a 3f                	push   $0x3f
  80090a:	8b 45 08             	mov    0x8(%ebp),%eax
  80090d:	ff d0                	call   *%eax
  80090f:	83 c4 10             	add    $0x10,%esp
  800912:	eb 0f                	jmp    800923 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800914:	83 ec 08             	sub    $0x8,%esp
  800917:	ff 75 0c             	pushl  0xc(%ebp)
  80091a:	53                   	push   %ebx
  80091b:	8b 45 08             	mov    0x8(%ebp),%eax
  80091e:	ff d0                	call   *%eax
  800920:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800923:	ff 4d e4             	decl   -0x1c(%ebp)
  800926:	89 f0                	mov    %esi,%eax
  800928:	8d 70 01             	lea    0x1(%eax),%esi
  80092b:	8a 00                	mov    (%eax),%al
  80092d:	0f be d8             	movsbl %al,%ebx
  800930:	85 db                	test   %ebx,%ebx
  800932:	74 24                	je     800958 <vprintfmt+0x24b>
  800934:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800938:	78 b8                	js     8008f2 <vprintfmt+0x1e5>
  80093a:	ff 4d e0             	decl   -0x20(%ebp)
  80093d:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800941:	79 af                	jns    8008f2 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800943:	eb 13                	jmp    800958 <vprintfmt+0x24b>
				putch(' ', putdat);
  800945:	83 ec 08             	sub    $0x8,%esp
  800948:	ff 75 0c             	pushl  0xc(%ebp)
  80094b:	6a 20                	push   $0x20
  80094d:	8b 45 08             	mov    0x8(%ebp),%eax
  800950:	ff d0                	call   *%eax
  800952:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800955:	ff 4d e4             	decl   -0x1c(%ebp)
  800958:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80095c:	7f e7                	jg     800945 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  80095e:	e9 78 01 00 00       	jmp    800adb <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800963:	83 ec 08             	sub    $0x8,%esp
  800966:	ff 75 e8             	pushl  -0x18(%ebp)
  800969:	8d 45 14             	lea    0x14(%ebp),%eax
  80096c:	50                   	push   %eax
  80096d:	e8 3c fd ff ff       	call   8006ae <getint>
  800972:	83 c4 10             	add    $0x10,%esp
  800975:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800978:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  80097b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80097e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800981:	85 d2                	test   %edx,%edx
  800983:	79 23                	jns    8009a8 <vprintfmt+0x29b>
				putch('-', putdat);
  800985:	83 ec 08             	sub    $0x8,%esp
  800988:	ff 75 0c             	pushl  0xc(%ebp)
  80098b:	6a 2d                	push   $0x2d
  80098d:	8b 45 08             	mov    0x8(%ebp),%eax
  800990:	ff d0                	call   *%eax
  800992:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800995:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800998:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80099b:	f7 d8                	neg    %eax
  80099d:	83 d2 00             	adc    $0x0,%edx
  8009a0:	f7 da                	neg    %edx
  8009a2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009a5:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8009a8:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8009af:	e9 bc 00 00 00       	jmp    800a70 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8009b4:	83 ec 08             	sub    $0x8,%esp
  8009b7:	ff 75 e8             	pushl  -0x18(%ebp)
  8009ba:	8d 45 14             	lea    0x14(%ebp),%eax
  8009bd:	50                   	push   %eax
  8009be:	e8 84 fc ff ff       	call   800647 <getuint>
  8009c3:	83 c4 10             	add    $0x10,%esp
  8009c6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009c9:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  8009cc:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8009d3:	e9 98 00 00 00       	jmp    800a70 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  8009d8:	83 ec 08             	sub    $0x8,%esp
  8009db:	ff 75 0c             	pushl  0xc(%ebp)
  8009de:	6a 58                	push   $0x58
  8009e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8009e3:	ff d0                	call   *%eax
  8009e5:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8009e8:	83 ec 08             	sub    $0x8,%esp
  8009eb:	ff 75 0c             	pushl  0xc(%ebp)
  8009ee:	6a 58                	push   $0x58
  8009f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8009f3:	ff d0                	call   *%eax
  8009f5:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8009f8:	83 ec 08             	sub    $0x8,%esp
  8009fb:	ff 75 0c             	pushl  0xc(%ebp)
  8009fe:	6a 58                	push   $0x58
  800a00:	8b 45 08             	mov    0x8(%ebp),%eax
  800a03:	ff d0                	call   *%eax
  800a05:	83 c4 10             	add    $0x10,%esp
			break;
  800a08:	e9 ce 00 00 00       	jmp    800adb <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800a0d:	83 ec 08             	sub    $0x8,%esp
  800a10:	ff 75 0c             	pushl  0xc(%ebp)
  800a13:	6a 30                	push   $0x30
  800a15:	8b 45 08             	mov    0x8(%ebp),%eax
  800a18:	ff d0                	call   *%eax
  800a1a:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800a1d:	83 ec 08             	sub    $0x8,%esp
  800a20:	ff 75 0c             	pushl  0xc(%ebp)
  800a23:	6a 78                	push   $0x78
  800a25:	8b 45 08             	mov    0x8(%ebp),%eax
  800a28:	ff d0                	call   *%eax
  800a2a:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800a2d:	8b 45 14             	mov    0x14(%ebp),%eax
  800a30:	83 c0 04             	add    $0x4,%eax
  800a33:	89 45 14             	mov    %eax,0x14(%ebp)
  800a36:	8b 45 14             	mov    0x14(%ebp),%eax
  800a39:	83 e8 04             	sub    $0x4,%eax
  800a3c:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800a3e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a41:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800a48:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800a4f:	eb 1f                	jmp    800a70 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800a51:	83 ec 08             	sub    $0x8,%esp
  800a54:	ff 75 e8             	pushl  -0x18(%ebp)
  800a57:	8d 45 14             	lea    0x14(%ebp),%eax
  800a5a:	50                   	push   %eax
  800a5b:	e8 e7 fb ff ff       	call   800647 <getuint>
  800a60:	83 c4 10             	add    $0x10,%esp
  800a63:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a66:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800a69:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800a70:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800a74:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800a77:	83 ec 04             	sub    $0x4,%esp
  800a7a:	52                   	push   %edx
  800a7b:	ff 75 e4             	pushl  -0x1c(%ebp)
  800a7e:	50                   	push   %eax
  800a7f:	ff 75 f4             	pushl  -0xc(%ebp)
  800a82:	ff 75 f0             	pushl  -0x10(%ebp)
  800a85:	ff 75 0c             	pushl  0xc(%ebp)
  800a88:	ff 75 08             	pushl  0x8(%ebp)
  800a8b:	e8 00 fb ff ff       	call   800590 <printnum>
  800a90:	83 c4 20             	add    $0x20,%esp
			break;
  800a93:	eb 46                	jmp    800adb <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800a95:	83 ec 08             	sub    $0x8,%esp
  800a98:	ff 75 0c             	pushl  0xc(%ebp)
  800a9b:	53                   	push   %ebx
  800a9c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a9f:	ff d0                	call   *%eax
  800aa1:	83 c4 10             	add    $0x10,%esp
			break;
  800aa4:	eb 35                	jmp    800adb <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800aa6:	c6 05 44 30 80 00 00 	movb   $0x0,0x803044
			break;
  800aad:	eb 2c                	jmp    800adb <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800aaf:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
			break;
  800ab6:	eb 23                	jmp    800adb <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800ab8:	83 ec 08             	sub    $0x8,%esp
  800abb:	ff 75 0c             	pushl  0xc(%ebp)
  800abe:	6a 25                	push   $0x25
  800ac0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ac3:	ff d0                	call   *%eax
  800ac5:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800ac8:	ff 4d 10             	decl   0x10(%ebp)
  800acb:	eb 03                	jmp    800ad0 <vprintfmt+0x3c3>
  800acd:	ff 4d 10             	decl   0x10(%ebp)
  800ad0:	8b 45 10             	mov    0x10(%ebp),%eax
  800ad3:	48                   	dec    %eax
  800ad4:	8a 00                	mov    (%eax),%al
  800ad6:	3c 25                	cmp    $0x25,%al
  800ad8:	75 f3                	jne    800acd <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800ada:	90                   	nop
		}
	}
  800adb:	e9 35 fc ff ff       	jmp    800715 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800ae0:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800ae1:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800ae4:	5b                   	pop    %ebx
  800ae5:	5e                   	pop    %esi
  800ae6:	5d                   	pop    %ebp
  800ae7:	c3                   	ret    

00800ae8 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800ae8:	55                   	push   %ebp
  800ae9:	89 e5                	mov    %esp,%ebp
  800aeb:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800aee:	8d 45 10             	lea    0x10(%ebp),%eax
  800af1:	83 c0 04             	add    $0x4,%eax
  800af4:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800af7:	8b 45 10             	mov    0x10(%ebp),%eax
  800afa:	ff 75 f4             	pushl  -0xc(%ebp)
  800afd:	50                   	push   %eax
  800afe:	ff 75 0c             	pushl  0xc(%ebp)
  800b01:	ff 75 08             	pushl  0x8(%ebp)
  800b04:	e8 04 fc ff ff       	call   80070d <vprintfmt>
  800b09:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800b0c:	90                   	nop
  800b0d:	c9                   	leave  
  800b0e:	c3                   	ret    

00800b0f <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800b0f:	55                   	push   %ebp
  800b10:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800b12:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b15:	8b 40 08             	mov    0x8(%eax),%eax
  800b18:	8d 50 01             	lea    0x1(%eax),%edx
  800b1b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b1e:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800b21:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b24:	8b 10                	mov    (%eax),%edx
  800b26:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b29:	8b 40 04             	mov    0x4(%eax),%eax
  800b2c:	39 c2                	cmp    %eax,%edx
  800b2e:	73 12                	jae    800b42 <sprintputch+0x33>
		*b->buf++ = ch;
  800b30:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b33:	8b 00                	mov    (%eax),%eax
  800b35:	8d 48 01             	lea    0x1(%eax),%ecx
  800b38:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b3b:	89 0a                	mov    %ecx,(%edx)
  800b3d:	8b 55 08             	mov    0x8(%ebp),%edx
  800b40:	88 10                	mov    %dl,(%eax)
}
  800b42:	90                   	nop
  800b43:	5d                   	pop    %ebp
  800b44:	c3                   	ret    

00800b45 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800b45:	55                   	push   %ebp
  800b46:	89 e5                	mov    %esp,%ebp
  800b48:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800b4b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b4e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800b51:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b54:	8d 50 ff             	lea    -0x1(%eax),%edx
  800b57:	8b 45 08             	mov    0x8(%ebp),%eax
  800b5a:	01 d0                	add    %edx,%eax
  800b5c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b5f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800b66:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800b6a:	74 06                	je     800b72 <vsnprintf+0x2d>
  800b6c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b70:	7f 07                	jg     800b79 <vsnprintf+0x34>
		return -E_INVAL;
  800b72:	b8 03 00 00 00       	mov    $0x3,%eax
  800b77:	eb 20                	jmp    800b99 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800b79:	ff 75 14             	pushl  0x14(%ebp)
  800b7c:	ff 75 10             	pushl  0x10(%ebp)
  800b7f:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800b82:	50                   	push   %eax
  800b83:	68 0f 0b 80 00       	push   $0x800b0f
  800b88:	e8 80 fb ff ff       	call   80070d <vprintfmt>
  800b8d:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800b90:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800b93:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800b96:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800b99:	c9                   	leave  
  800b9a:	c3                   	ret    

00800b9b <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800b9b:	55                   	push   %ebp
  800b9c:	89 e5                	mov    %esp,%ebp
  800b9e:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800ba1:	8d 45 10             	lea    0x10(%ebp),%eax
  800ba4:	83 c0 04             	add    $0x4,%eax
  800ba7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800baa:	8b 45 10             	mov    0x10(%ebp),%eax
  800bad:	ff 75 f4             	pushl  -0xc(%ebp)
  800bb0:	50                   	push   %eax
  800bb1:	ff 75 0c             	pushl  0xc(%ebp)
  800bb4:	ff 75 08             	pushl  0x8(%ebp)
  800bb7:	e8 89 ff ff ff       	call   800b45 <vsnprintf>
  800bbc:	83 c4 10             	add    $0x10,%esp
  800bbf:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800bc2:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800bc5:	c9                   	leave  
  800bc6:	c3                   	ret    

00800bc7 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800bc7:	55                   	push   %ebp
  800bc8:	89 e5                	mov    %esp,%ebp
  800bca:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800bcd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800bd4:	eb 06                	jmp    800bdc <strlen+0x15>
		n++;
  800bd6:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800bd9:	ff 45 08             	incl   0x8(%ebp)
  800bdc:	8b 45 08             	mov    0x8(%ebp),%eax
  800bdf:	8a 00                	mov    (%eax),%al
  800be1:	84 c0                	test   %al,%al
  800be3:	75 f1                	jne    800bd6 <strlen+0xf>
		n++;
	return n;
  800be5:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800be8:	c9                   	leave  
  800be9:	c3                   	ret    

00800bea <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800bea:	55                   	push   %ebp
  800beb:	89 e5                	mov    %esp,%ebp
  800bed:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800bf0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800bf7:	eb 09                	jmp    800c02 <strnlen+0x18>
		n++;
  800bf9:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800bfc:	ff 45 08             	incl   0x8(%ebp)
  800bff:	ff 4d 0c             	decl   0xc(%ebp)
  800c02:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c06:	74 09                	je     800c11 <strnlen+0x27>
  800c08:	8b 45 08             	mov    0x8(%ebp),%eax
  800c0b:	8a 00                	mov    (%eax),%al
  800c0d:	84 c0                	test   %al,%al
  800c0f:	75 e8                	jne    800bf9 <strnlen+0xf>
		n++;
	return n;
  800c11:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c14:	c9                   	leave  
  800c15:	c3                   	ret    

00800c16 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800c16:	55                   	push   %ebp
  800c17:	89 e5                	mov    %esp,%ebp
  800c19:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800c1c:	8b 45 08             	mov    0x8(%ebp),%eax
  800c1f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800c22:	90                   	nop
  800c23:	8b 45 08             	mov    0x8(%ebp),%eax
  800c26:	8d 50 01             	lea    0x1(%eax),%edx
  800c29:	89 55 08             	mov    %edx,0x8(%ebp)
  800c2c:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c2f:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c32:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800c35:	8a 12                	mov    (%edx),%dl
  800c37:	88 10                	mov    %dl,(%eax)
  800c39:	8a 00                	mov    (%eax),%al
  800c3b:	84 c0                	test   %al,%al
  800c3d:	75 e4                	jne    800c23 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800c3f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c42:	c9                   	leave  
  800c43:	c3                   	ret    

00800c44 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800c44:	55                   	push   %ebp
  800c45:	89 e5                	mov    %esp,%ebp
  800c47:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800c4a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c4d:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800c50:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c57:	eb 1f                	jmp    800c78 <strncpy+0x34>
		*dst++ = *src;
  800c59:	8b 45 08             	mov    0x8(%ebp),%eax
  800c5c:	8d 50 01             	lea    0x1(%eax),%edx
  800c5f:	89 55 08             	mov    %edx,0x8(%ebp)
  800c62:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c65:	8a 12                	mov    (%edx),%dl
  800c67:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800c69:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c6c:	8a 00                	mov    (%eax),%al
  800c6e:	84 c0                	test   %al,%al
  800c70:	74 03                	je     800c75 <strncpy+0x31>
			src++;
  800c72:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800c75:	ff 45 fc             	incl   -0x4(%ebp)
  800c78:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c7b:	3b 45 10             	cmp    0x10(%ebp),%eax
  800c7e:	72 d9                	jb     800c59 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800c80:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800c83:	c9                   	leave  
  800c84:	c3                   	ret    

00800c85 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800c85:	55                   	push   %ebp
  800c86:	89 e5                	mov    %esp,%ebp
  800c88:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800c8b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c8e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800c91:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c95:	74 30                	je     800cc7 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800c97:	eb 16                	jmp    800caf <strlcpy+0x2a>
			*dst++ = *src++;
  800c99:	8b 45 08             	mov    0x8(%ebp),%eax
  800c9c:	8d 50 01             	lea    0x1(%eax),%edx
  800c9f:	89 55 08             	mov    %edx,0x8(%ebp)
  800ca2:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ca5:	8d 4a 01             	lea    0x1(%edx),%ecx
  800ca8:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800cab:	8a 12                	mov    (%edx),%dl
  800cad:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800caf:	ff 4d 10             	decl   0x10(%ebp)
  800cb2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800cb6:	74 09                	je     800cc1 <strlcpy+0x3c>
  800cb8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cbb:	8a 00                	mov    (%eax),%al
  800cbd:	84 c0                	test   %al,%al
  800cbf:	75 d8                	jne    800c99 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800cc1:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc4:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800cc7:	8b 55 08             	mov    0x8(%ebp),%edx
  800cca:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ccd:	29 c2                	sub    %eax,%edx
  800ccf:	89 d0                	mov    %edx,%eax
}
  800cd1:	c9                   	leave  
  800cd2:	c3                   	ret    

00800cd3 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800cd3:	55                   	push   %ebp
  800cd4:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800cd6:	eb 06                	jmp    800cde <strcmp+0xb>
		p++, q++;
  800cd8:	ff 45 08             	incl   0x8(%ebp)
  800cdb:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800cde:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce1:	8a 00                	mov    (%eax),%al
  800ce3:	84 c0                	test   %al,%al
  800ce5:	74 0e                	je     800cf5 <strcmp+0x22>
  800ce7:	8b 45 08             	mov    0x8(%ebp),%eax
  800cea:	8a 10                	mov    (%eax),%dl
  800cec:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cef:	8a 00                	mov    (%eax),%al
  800cf1:	38 c2                	cmp    %al,%dl
  800cf3:	74 e3                	je     800cd8 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800cf5:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf8:	8a 00                	mov    (%eax),%al
  800cfa:	0f b6 d0             	movzbl %al,%edx
  800cfd:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d00:	8a 00                	mov    (%eax),%al
  800d02:	0f b6 c0             	movzbl %al,%eax
  800d05:	29 c2                	sub    %eax,%edx
  800d07:	89 d0                	mov    %edx,%eax
}
  800d09:	5d                   	pop    %ebp
  800d0a:	c3                   	ret    

00800d0b <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800d0b:	55                   	push   %ebp
  800d0c:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800d0e:	eb 09                	jmp    800d19 <strncmp+0xe>
		n--, p++, q++;
  800d10:	ff 4d 10             	decl   0x10(%ebp)
  800d13:	ff 45 08             	incl   0x8(%ebp)
  800d16:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800d19:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d1d:	74 17                	je     800d36 <strncmp+0x2b>
  800d1f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d22:	8a 00                	mov    (%eax),%al
  800d24:	84 c0                	test   %al,%al
  800d26:	74 0e                	je     800d36 <strncmp+0x2b>
  800d28:	8b 45 08             	mov    0x8(%ebp),%eax
  800d2b:	8a 10                	mov    (%eax),%dl
  800d2d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d30:	8a 00                	mov    (%eax),%al
  800d32:	38 c2                	cmp    %al,%dl
  800d34:	74 da                	je     800d10 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800d36:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d3a:	75 07                	jne    800d43 <strncmp+0x38>
		return 0;
  800d3c:	b8 00 00 00 00       	mov    $0x0,%eax
  800d41:	eb 14                	jmp    800d57 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800d43:	8b 45 08             	mov    0x8(%ebp),%eax
  800d46:	8a 00                	mov    (%eax),%al
  800d48:	0f b6 d0             	movzbl %al,%edx
  800d4b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d4e:	8a 00                	mov    (%eax),%al
  800d50:	0f b6 c0             	movzbl %al,%eax
  800d53:	29 c2                	sub    %eax,%edx
  800d55:	89 d0                	mov    %edx,%eax
}
  800d57:	5d                   	pop    %ebp
  800d58:	c3                   	ret    

00800d59 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800d59:	55                   	push   %ebp
  800d5a:	89 e5                	mov    %esp,%ebp
  800d5c:	83 ec 04             	sub    $0x4,%esp
  800d5f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d62:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800d65:	eb 12                	jmp    800d79 <strchr+0x20>
		if (*s == c)
  800d67:	8b 45 08             	mov    0x8(%ebp),%eax
  800d6a:	8a 00                	mov    (%eax),%al
  800d6c:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800d6f:	75 05                	jne    800d76 <strchr+0x1d>
			return (char *) s;
  800d71:	8b 45 08             	mov    0x8(%ebp),%eax
  800d74:	eb 11                	jmp    800d87 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800d76:	ff 45 08             	incl   0x8(%ebp)
  800d79:	8b 45 08             	mov    0x8(%ebp),%eax
  800d7c:	8a 00                	mov    (%eax),%al
  800d7e:	84 c0                	test   %al,%al
  800d80:	75 e5                	jne    800d67 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800d82:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d87:	c9                   	leave  
  800d88:	c3                   	ret    

00800d89 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800d89:	55                   	push   %ebp
  800d8a:	89 e5                	mov    %esp,%ebp
  800d8c:	83 ec 04             	sub    $0x4,%esp
  800d8f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d92:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800d95:	eb 0d                	jmp    800da4 <strfind+0x1b>
		if (*s == c)
  800d97:	8b 45 08             	mov    0x8(%ebp),%eax
  800d9a:	8a 00                	mov    (%eax),%al
  800d9c:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800d9f:	74 0e                	je     800daf <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800da1:	ff 45 08             	incl   0x8(%ebp)
  800da4:	8b 45 08             	mov    0x8(%ebp),%eax
  800da7:	8a 00                	mov    (%eax),%al
  800da9:	84 c0                	test   %al,%al
  800dab:	75 ea                	jne    800d97 <strfind+0xe>
  800dad:	eb 01                	jmp    800db0 <strfind+0x27>
		if (*s == c)
			break;
  800daf:	90                   	nop
	return (char *) s;
  800db0:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800db3:	c9                   	leave  
  800db4:	c3                   	ret    

00800db5 <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  800db5:	55                   	push   %ebp
  800db6:	89 e5                	mov    %esp,%ebp
  800db8:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  800dbb:	8b 45 08             	mov    0x8(%ebp),%eax
  800dbe:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  800dc1:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800dc5:	76 63                	jbe    800e2a <memset+0x75>
		uint64 data_block = c;
  800dc7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dca:	99                   	cltd   
  800dcb:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800dce:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  800dd1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800dd4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800dd7:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  800ddb:	c1 e0 08             	shl    $0x8,%eax
  800dde:	09 45 f0             	or     %eax,-0x10(%ebp)
  800de1:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  800de4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800de7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800dea:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  800dee:	c1 e0 10             	shl    $0x10,%eax
  800df1:	09 45 f0             	or     %eax,-0x10(%ebp)
  800df4:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  800df7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800dfa:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800dfd:	89 c2                	mov    %eax,%edx
  800dff:	b8 00 00 00 00       	mov    $0x0,%eax
  800e04:	09 45 f0             	or     %eax,-0x10(%ebp)
  800e07:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  800e0a:	eb 18                	jmp    800e24 <memset+0x6f>
			*p64++ = data_block, n -= 8;
  800e0c:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  800e0f:	8d 41 08             	lea    0x8(%ecx),%eax
  800e12:	89 45 fc             	mov    %eax,-0x4(%ebp)
  800e15:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e18:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e1b:	89 01                	mov    %eax,(%ecx)
  800e1d:	89 51 04             	mov    %edx,0x4(%ecx)
  800e20:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  800e24:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800e28:	77 e2                	ja     800e0c <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  800e2a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e2e:	74 23                	je     800e53 <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  800e30:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e33:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  800e36:	eb 0e                	jmp    800e46 <memset+0x91>
			*p8++ = (uint8)c;
  800e38:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e3b:	8d 50 01             	lea    0x1(%eax),%edx
  800e3e:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800e41:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e44:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  800e46:	8b 45 10             	mov    0x10(%ebp),%eax
  800e49:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e4c:	89 55 10             	mov    %edx,0x10(%ebp)
  800e4f:	85 c0                	test   %eax,%eax
  800e51:	75 e5                	jne    800e38 <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  800e53:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e56:	c9                   	leave  
  800e57:	c3                   	ret    

00800e58 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800e58:	55                   	push   %ebp
  800e59:	89 e5                	mov    %esp,%ebp
  800e5b:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  800e5e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e61:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  800e64:	8b 45 08             	mov    0x8(%ebp),%eax
  800e67:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  800e6a:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800e6e:	76 24                	jbe    800e94 <memcpy+0x3c>
		while(n >= 8){
  800e70:	eb 1c                	jmp    800e8e <memcpy+0x36>
			*d64 = *s64;
  800e72:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e75:	8b 50 04             	mov    0x4(%eax),%edx
  800e78:	8b 00                	mov    (%eax),%eax
  800e7a:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  800e7d:	89 01                	mov    %eax,(%ecx)
  800e7f:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  800e82:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  800e86:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  800e8a:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  800e8e:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800e92:	77 de                	ja     800e72 <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  800e94:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e98:	74 31                	je     800ecb <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  800e9a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e9d:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  800ea0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ea3:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  800ea6:	eb 16                	jmp    800ebe <memcpy+0x66>
			*d8++ = *s8++;
  800ea8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800eab:	8d 50 01             	lea    0x1(%eax),%edx
  800eae:	89 55 f0             	mov    %edx,-0x10(%ebp)
  800eb1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800eb4:	8d 4a 01             	lea    0x1(%edx),%ecx
  800eb7:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  800eba:	8a 12                	mov    (%edx),%dl
  800ebc:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  800ebe:	8b 45 10             	mov    0x10(%ebp),%eax
  800ec1:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ec4:	89 55 10             	mov    %edx,0x10(%ebp)
  800ec7:	85 c0                	test   %eax,%eax
  800ec9:	75 dd                	jne    800ea8 <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  800ecb:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ece:	c9                   	leave  
  800ecf:	c3                   	ret    

00800ed0 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800ed0:	55                   	push   %ebp
  800ed1:	89 e5                	mov    %esp,%ebp
  800ed3:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800ed6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ed9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800edc:	8b 45 08             	mov    0x8(%ebp),%eax
  800edf:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800ee2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ee5:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800ee8:	73 50                	jae    800f3a <memmove+0x6a>
  800eea:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800eed:	8b 45 10             	mov    0x10(%ebp),%eax
  800ef0:	01 d0                	add    %edx,%eax
  800ef2:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800ef5:	76 43                	jbe    800f3a <memmove+0x6a>
		s += n;
  800ef7:	8b 45 10             	mov    0x10(%ebp),%eax
  800efa:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800efd:	8b 45 10             	mov    0x10(%ebp),%eax
  800f00:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800f03:	eb 10                	jmp    800f15 <memmove+0x45>
			*--d = *--s;
  800f05:	ff 4d f8             	decl   -0x8(%ebp)
  800f08:	ff 4d fc             	decl   -0x4(%ebp)
  800f0b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f0e:	8a 10                	mov    (%eax),%dl
  800f10:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f13:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800f15:	8b 45 10             	mov    0x10(%ebp),%eax
  800f18:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f1b:	89 55 10             	mov    %edx,0x10(%ebp)
  800f1e:	85 c0                	test   %eax,%eax
  800f20:	75 e3                	jne    800f05 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800f22:	eb 23                	jmp    800f47 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800f24:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f27:	8d 50 01             	lea    0x1(%eax),%edx
  800f2a:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800f2d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f30:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f33:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800f36:	8a 12                	mov    (%edx),%dl
  800f38:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800f3a:	8b 45 10             	mov    0x10(%ebp),%eax
  800f3d:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f40:	89 55 10             	mov    %edx,0x10(%ebp)
  800f43:	85 c0                	test   %eax,%eax
  800f45:	75 dd                	jne    800f24 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800f47:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f4a:	c9                   	leave  
  800f4b:	c3                   	ret    

00800f4c <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800f4c:	55                   	push   %ebp
  800f4d:	89 e5                	mov    %esp,%ebp
  800f4f:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800f52:	8b 45 08             	mov    0x8(%ebp),%eax
  800f55:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800f58:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f5b:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800f5e:	eb 2a                	jmp    800f8a <memcmp+0x3e>
		if (*s1 != *s2)
  800f60:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f63:	8a 10                	mov    (%eax),%dl
  800f65:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f68:	8a 00                	mov    (%eax),%al
  800f6a:	38 c2                	cmp    %al,%dl
  800f6c:	74 16                	je     800f84 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800f6e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f71:	8a 00                	mov    (%eax),%al
  800f73:	0f b6 d0             	movzbl %al,%edx
  800f76:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f79:	8a 00                	mov    (%eax),%al
  800f7b:	0f b6 c0             	movzbl %al,%eax
  800f7e:	29 c2                	sub    %eax,%edx
  800f80:	89 d0                	mov    %edx,%eax
  800f82:	eb 18                	jmp    800f9c <memcmp+0x50>
		s1++, s2++;
  800f84:	ff 45 fc             	incl   -0x4(%ebp)
  800f87:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800f8a:	8b 45 10             	mov    0x10(%ebp),%eax
  800f8d:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f90:	89 55 10             	mov    %edx,0x10(%ebp)
  800f93:	85 c0                	test   %eax,%eax
  800f95:	75 c9                	jne    800f60 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800f97:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f9c:	c9                   	leave  
  800f9d:	c3                   	ret    

00800f9e <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800f9e:	55                   	push   %ebp
  800f9f:	89 e5                	mov    %esp,%ebp
  800fa1:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800fa4:	8b 55 08             	mov    0x8(%ebp),%edx
  800fa7:	8b 45 10             	mov    0x10(%ebp),%eax
  800faa:	01 d0                	add    %edx,%eax
  800fac:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800faf:	eb 15                	jmp    800fc6 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800fb1:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb4:	8a 00                	mov    (%eax),%al
  800fb6:	0f b6 d0             	movzbl %al,%edx
  800fb9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fbc:	0f b6 c0             	movzbl %al,%eax
  800fbf:	39 c2                	cmp    %eax,%edx
  800fc1:	74 0d                	je     800fd0 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800fc3:	ff 45 08             	incl   0x8(%ebp)
  800fc6:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc9:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800fcc:	72 e3                	jb     800fb1 <memfind+0x13>
  800fce:	eb 01                	jmp    800fd1 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800fd0:	90                   	nop
	return (void *) s;
  800fd1:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800fd4:	c9                   	leave  
  800fd5:	c3                   	ret    

00800fd6 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800fd6:	55                   	push   %ebp
  800fd7:	89 e5                	mov    %esp,%ebp
  800fd9:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800fdc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800fe3:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800fea:	eb 03                	jmp    800fef <strtol+0x19>
		s++;
  800fec:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800fef:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff2:	8a 00                	mov    (%eax),%al
  800ff4:	3c 20                	cmp    $0x20,%al
  800ff6:	74 f4                	je     800fec <strtol+0x16>
  800ff8:	8b 45 08             	mov    0x8(%ebp),%eax
  800ffb:	8a 00                	mov    (%eax),%al
  800ffd:	3c 09                	cmp    $0x9,%al
  800fff:	74 eb                	je     800fec <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801001:	8b 45 08             	mov    0x8(%ebp),%eax
  801004:	8a 00                	mov    (%eax),%al
  801006:	3c 2b                	cmp    $0x2b,%al
  801008:	75 05                	jne    80100f <strtol+0x39>
		s++;
  80100a:	ff 45 08             	incl   0x8(%ebp)
  80100d:	eb 13                	jmp    801022 <strtol+0x4c>
	else if (*s == '-')
  80100f:	8b 45 08             	mov    0x8(%ebp),%eax
  801012:	8a 00                	mov    (%eax),%al
  801014:	3c 2d                	cmp    $0x2d,%al
  801016:	75 0a                	jne    801022 <strtol+0x4c>
		s++, neg = 1;
  801018:	ff 45 08             	incl   0x8(%ebp)
  80101b:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801022:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801026:	74 06                	je     80102e <strtol+0x58>
  801028:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  80102c:	75 20                	jne    80104e <strtol+0x78>
  80102e:	8b 45 08             	mov    0x8(%ebp),%eax
  801031:	8a 00                	mov    (%eax),%al
  801033:	3c 30                	cmp    $0x30,%al
  801035:	75 17                	jne    80104e <strtol+0x78>
  801037:	8b 45 08             	mov    0x8(%ebp),%eax
  80103a:	40                   	inc    %eax
  80103b:	8a 00                	mov    (%eax),%al
  80103d:	3c 78                	cmp    $0x78,%al
  80103f:	75 0d                	jne    80104e <strtol+0x78>
		s += 2, base = 16;
  801041:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801045:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  80104c:	eb 28                	jmp    801076 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  80104e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801052:	75 15                	jne    801069 <strtol+0x93>
  801054:	8b 45 08             	mov    0x8(%ebp),%eax
  801057:	8a 00                	mov    (%eax),%al
  801059:	3c 30                	cmp    $0x30,%al
  80105b:	75 0c                	jne    801069 <strtol+0x93>
		s++, base = 8;
  80105d:	ff 45 08             	incl   0x8(%ebp)
  801060:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801067:	eb 0d                	jmp    801076 <strtol+0xa0>
	else if (base == 0)
  801069:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80106d:	75 07                	jne    801076 <strtol+0xa0>
		base = 10;
  80106f:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801076:	8b 45 08             	mov    0x8(%ebp),%eax
  801079:	8a 00                	mov    (%eax),%al
  80107b:	3c 2f                	cmp    $0x2f,%al
  80107d:	7e 19                	jle    801098 <strtol+0xc2>
  80107f:	8b 45 08             	mov    0x8(%ebp),%eax
  801082:	8a 00                	mov    (%eax),%al
  801084:	3c 39                	cmp    $0x39,%al
  801086:	7f 10                	jg     801098 <strtol+0xc2>
			dig = *s - '0';
  801088:	8b 45 08             	mov    0x8(%ebp),%eax
  80108b:	8a 00                	mov    (%eax),%al
  80108d:	0f be c0             	movsbl %al,%eax
  801090:	83 e8 30             	sub    $0x30,%eax
  801093:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801096:	eb 42                	jmp    8010da <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801098:	8b 45 08             	mov    0x8(%ebp),%eax
  80109b:	8a 00                	mov    (%eax),%al
  80109d:	3c 60                	cmp    $0x60,%al
  80109f:	7e 19                	jle    8010ba <strtol+0xe4>
  8010a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a4:	8a 00                	mov    (%eax),%al
  8010a6:	3c 7a                	cmp    $0x7a,%al
  8010a8:	7f 10                	jg     8010ba <strtol+0xe4>
			dig = *s - 'a' + 10;
  8010aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ad:	8a 00                	mov    (%eax),%al
  8010af:	0f be c0             	movsbl %al,%eax
  8010b2:	83 e8 57             	sub    $0x57,%eax
  8010b5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8010b8:	eb 20                	jmp    8010da <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  8010ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8010bd:	8a 00                	mov    (%eax),%al
  8010bf:	3c 40                	cmp    $0x40,%al
  8010c1:	7e 39                	jle    8010fc <strtol+0x126>
  8010c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c6:	8a 00                	mov    (%eax),%al
  8010c8:	3c 5a                	cmp    $0x5a,%al
  8010ca:	7f 30                	jg     8010fc <strtol+0x126>
			dig = *s - 'A' + 10;
  8010cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8010cf:	8a 00                	mov    (%eax),%al
  8010d1:	0f be c0             	movsbl %al,%eax
  8010d4:	83 e8 37             	sub    $0x37,%eax
  8010d7:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  8010da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8010dd:	3b 45 10             	cmp    0x10(%ebp),%eax
  8010e0:	7d 19                	jge    8010fb <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  8010e2:	ff 45 08             	incl   0x8(%ebp)
  8010e5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010e8:	0f af 45 10          	imul   0x10(%ebp),%eax
  8010ec:	89 c2                	mov    %eax,%edx
  8010ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8010f1:	01 d0                	add    %edx,%eax
  8010f3:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8010f6:	e9 7b ff ff ff       	jmp    801076 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8010fb:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8010fc:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801100:	74 08                	je     80110a <strtol+0x134>
		*endptr = (char *) s;
  801102:	8b 45 0c             	mov    0xc(%ebp),%eax
  801105:	8b 55 08             	mov    0x8(%ebp),%edx
  801108:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  80110a:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80110e:	74 07                	je     801117 <strtol+0x141>
  801110:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801113:	f7 d8                	neg    %eax
  801115:	eb 03                	jmp    80111a <strtol+0x144>
  801117:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80111a:	c9                   	leave  
  80111b:	c3                   	ret    

0080111c <ltostr>:

void
ltostr(long value, char *str)
{
  80111c:	55                   	push   %ebp
  80111d:	89 e5                	mov    %esp,%ebp
  80111f:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801122:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801129:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801130:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801134:	79 13                	jns    801149 <ltostr+0x2d>
	{
		neg = 1;
  801136:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  80113d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801140:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801143:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801146:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801149:	8b 45 08             	mov    0x8(%ebp),%eax
  80114c:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801151:	99                   	cltd   
  801152:	f7 f9                	idiv   %ecx
  801154:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801157:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80115a:	8d 50 01             	lea    0x1(%eax),%edx
  80115d:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801160:	89 c2                	mov    %eax,%edx
  801162:	8b 45 0c             	mov    0xc(%ebp),%eax
  801165:	01 d0                	add    %edx,%eax
  801167:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80116a:	83 c2 30             	add    $0x30,%edx
  80116d:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  80116f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801172:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801177:	f7 e9                	imul   %ecx
  801179:	c1 fa 02             	sar    $0x2,%edx
  80117c:	89 c8                	mov    %ecx,%eax
  80117e:	c1 f8 1f             	sar    $0x1f,%eax
  801181:	29 c2                	sub    %eax,%edx
  801183:	89 d0                	mov    %edx,%eax
  801185:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  801188:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80118c:	75 bb                	jne    801149 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  80118e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801195:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801198:	48                   	dec    %eax
  801199:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  80119c:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8011a0:	74 3d                	je     8011df <ltostr+0xc3>
		start = 1 ;
  8011a2:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8011a9:	eb 34                	jmp    8011df <ltostr+0xc3>
	{
		char tmp = str[start] ;
  8011ab:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8011ae:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011b1:	01 d0                	add    %edx,%eax
  8011b3:	8a 00                	mov    (%eax),%al
  8011b5:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8011b8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8011bb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011be:	01 c2                	add    %eax,%edx
  8011c0:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8011c3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011c6:	01 c8                	add    %ecx,%eax
  8011c8:	8a 00                	mov    (%eax),%al
  8011ca:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8011cc:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8011cf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011d2:	01 c2                	add    %eax,%edx
  8011d4:	8a 45 eb             	mov    -0x15(%ebp),%al
  8011d7:	88 02                	mov    %al,(%edx)
		start++ ;
  8011d9:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8011dc:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8011df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8011e2:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8011e5:	7c c4                	jl     8011ab <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8011e7:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8011ea:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011ed:	01 d0                	add    %edx,%eax
  8011ef:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8011f2:	90                   	nop
  8011f3:	c9                   	leave  
  8011f4:	c3                   	ret    

008011f5 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8011f5:	55                   	push   %ebp
  8011f6:	89 e5                	mov    %esp,%ebp
  8011f8:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8011fb:	ff 75 08             	pushl  0x8(%ebp)
  8011fe:	e8 c4 f9 ff ff       	call   800bc7 <strlen>
  801203:	83 c4 04             	add    $0x4,%esp
  801206:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801209:	ff 75 0c             	pushl  0xc(%ebp)
  80120c:	e8 b6 f9 ff ff       	call   800bc7 <strlen>
  801211:	83 c4 04             	add    $0x4,%esp
  801214:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801217:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  80121e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801225:	eb 17                	jmp    80123e <strcconcat+0x49>
		final[s] = str1[s] ;
  801227:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80122a:	8b 45 10             	mov    0x10(%ebp),%eax
  80122d:	01 c2                	add    %eax,%edx
  80122f:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801232:	8b 45 08             	mov    0x8(%ebp),%eax
  801235:	01 c8                	add    %ecx,%eax
  801237:	8a 00                	mov    (%eax),%al
  801239:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  80123b:	ff 45 fc             	incl   -0x4(%ebp)
  80123e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801241:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801244:	7c e1                	jl     801227 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801246:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  80124d:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801254:	eb 1f                	jmp    801275 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801256:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801259:	8d 50 01             	lea    0x1(%eax),%edx
  80125c:	89 55 fc             	mov    %edx,-0x4(%ebp)
  80125f:	89 c2                	mov    %eax,%edx
  801261:	8b 45 10             	mov    0x10(%ebp),%eax
  801264:	01 c2                	add    %eax,%edx
  801266:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801269:	8b 45 0c             	mov    0xc(%ebp),%eax
  80126c:	01 c8                	add    %ecx,%eax
  80126e:	8a 00                	mov    (%eax),%al
  801270:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801272:	ff 45 f8             	incl   -0x8(%ebp)
  801275:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801278:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80127b:	7c d9                	jl     801256 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  80127d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801280:	8b 45 10             	mov    0x10(%ebp),%eax
  801283:	01 d0                	add    %edx,%eax
  801285:	c6 00 00             	movb   $0x0,(%eax)
}
  801288:	90                   	nop
  801289:	c9                   	leave  
  80128a:	c3                   	ret    

0080128b <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  80128b:	55                   	push   %ebp
  80128c:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  80128e:	8b 45 14             	mov    0x14(%ebp),%eax
  801291:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801297:	8b 45 14             	mov    0x14(%ebp),%eax
  80129a:	8b 00                	mov    (%eax),%eax
  80129c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8012a3:	8b 45 10             	mov    0x10(%ebp),%eax
  8012a6:	01 d0                	add    %edx,%eax
  8012a8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8012ae:	eb 0c                	jmp    8012bc <strsplit+0x31>
			*string++ = 0;
  8012b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8012b3:	8d 50 01             	lea    0x1(%eax),%edx
  8012b6:	89 55 08             	mov    %edx,0x8(%ebp)
  8012b9:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8012bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8012bf:	8a 00                	mov    (%eax),%al
  8012c1:	84 c0                	test   %al,%al
  8012c3:	74 18                	je     8012dd <strsplit+0x52>
  8012c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8012c8:	8a 00                	mov    (%eax),%al
  8012ca:	0f be c0             	movsbl %al,%eax
  8012cd:	50                   	push   %eax
  8012ce:	ff 75 0c             	pushl  0xc(%ebp)
  8012d1:	e8 83 fa ff ff       	call   800d59 <strchr>
  8012d6:	83 c4 08             	add    $0x8,%esp
  8012d9:	85 c0                	test   %eax,%eax
  8012db:	75 d3                	jne    8012b0 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8012dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8012e0:	8a 00                	mov    (%eax),%al
  8012e2:	84 c0                	test   %al,%al
  8012e4:	74 5a                	je     801340 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8012e6:	8b 45 14             	mov    0x14(%ebp),%eax
  8012e9:	8b 00                	mov    (%eax),%eax
  8012eb:	83 f8 0f             	cmp    $0xf,%eax
  8012ee:	75 07                	jne    8012f7 <strsplit+0x6c>
		{
			return 0;
  8012f0:	b8 00 00 00 00       	mov    $0x0,%eax
  8012f5:	eb 66                	jmp    80135d <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8012f7:	8b 45 14             	mov    0x14(%ebp),%eax
  8012fa:	8b 00                	mov    (%eax),%eax
  8012fc:	8d 48 01             	lea    0x1(%eax),%ecx
  8012ff:	8b 55 14             	mov    0x14(%ebp),%edx
  801302:	89 0a                	mov    %ecx,(%edx)
  801304:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80130b:	8b 45 10             	mov    0x10(%ebp),%eax
  80130e:	01 c2                	add    %eax,%edx
  801310:	8b 45 08             	mov    0x8(%ebp),%eax
  801313:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801315:	eb 03                	jmp    80131a <strsplit+0x8f>
			string++;
  801317:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  80131a:	8b 45 08             	mov    0x8(%ebp),%eax
  80131d:	8a 00                	mov    (%eax),%al
  80131f:	84 c0                	test   %al,%al
  801321:	74 8b                	je     8012ae <strsplit+0x23>
  801323:	8b 45 08             	mov    0x8(%ebp),%eax
  801326:	8a 00                	mov    (%eax),%al
  801328:	0f be c0             	movsbl %al,%eax
  80132b:	50                   	push   %eax
  80132c:	ff 75 0c             	pushl  0xc(%ebp)
  80132f:	e8 25 fa ff ff       	call   800d59 <strchr>
  801334:	83 c4 08             	add    $0x8,%esp
  801337:	85 c0                	test   %eax,%eax
  801339:	74 dc                	je     801317 <strsplit+0x8c>
			string++;
	}
  80133b:	e9 6e ff ff ff       	jmp    8012ae <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801340:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801341:	8b 45 14             	mov    0x14(%ebp),%eax
  801344:	8b 00                	mov    (%eax),%eax
  801346:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80134d:	8b 45 10             	mov    0x10(%ebp),%eax
  801350:	01 d0                	add    %edx,%eax
  801352:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801358:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80135d:	c9                   	leave  
  80135e:	c3                   	ret    

0080135f <str2lower>:


char* str2lower(char *dst, const char *src)
{
  80135f:	55                   	push   %ebp
  801360:	89 e5                	mov    %esp,%ebp
  801362:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  801365:	8b 45 08             	mov    0x8(%ebp),%eax
  801368:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  80136b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801372:	eb 4a                	jmp    8013be <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  801374:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801377:	8b 45 08             	mov    0x8(%ebp),%eax
  80137a:	01 c2                	add    %eax,%edx
  80137c:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80137f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801382:	01 c8                	add    %ecx,%eax
  801384:	8a 00                	mov    (%eax),%al
  801386:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  801388:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80138b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80138e:	01 d0                	add    %edx,%eax
  801390:	8a 00                	mov    (%eax),%al
  801392:	3c 40                	cmp    $0x40,%al
  801394:	7e 25                	jle    8013bb <str2lower+0x5c>
  801396:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801399:	8b 45 0c             	mov    0xc(%ebp),%eax
  80139c:	01 d0                	add    %edx,%eax
  80139e:	8a 00                	mov    (%eax),%al
  8013a0:	3c 5a                	cmp    $0x5a,%al
  8013a2:	7f 17                	jg     8013bb <str2lower+0x5c>
		{
			dst[i] += 32 ;
  8013a4:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8013a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8013aa:	01 d0                	add    %edx,%eax
  8013ac:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8013af:	8b 55 08             	mov    0x8(%ebp),%edx
  8013b2:	01 ca                	add    %ecx,%edx
  8013b4:	8a 12                	mov    (%edx),%dl
  8013b6:	83 c2 20             	add    $0x20,%edx
  8013b9:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  8013bb:	ff 45 fc             	incl   -0x4(%ebp)
  8013be:	ff 75 0c             	pushl  0xc(%ebp)
  8013c1:	e8 01 f8 ff ff       	call   800bc7 <strlen>
  8013c6:	83 c4 04             	add    $0x4,%esp
  8013c9:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8013cc:	7f a6                	jg     801374 <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  8013ce:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8013d1:	c9                   	leave  
  8013d2:	c3                   	ret    

008013d3 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8013d3:	55                   	push   %ebp
  8013d4:	89 e5                	mov    %esp,%ebp
  8013d6:	57                   	push   %edi
  8013d7:	56                   	push   %esi
  8013d8:	53                   	push   %ebx
  8013d9:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8013dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8013df:	8b 55 0c             	mov    0xc(%ebp),%edx
  8013e2:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8013e5:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8013e8:	8b 7d 18             	mov    0x18(%ebp),%edi
  8013eb:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8013ee:	cd 30                	int    $0x30
  8013f0:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  8013f3:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8013f6:	83 c4 10             	add    $0x10,%esp
  8013f9:	5b                   	pop    %ebx
  8013fa:	5e                   	pop    %esi
  8013fb:	5f                   	pop    %edi
  8013fc:	5d                   	pop    %ebp
  8013fd:	c3                   	ret    

008013fe <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  8013fe:	55                   	push   %ebp
  8013ff:	89 e5                	mov    %esp,%ebp
  801401:	83 ec 04             	sub    $0x4,%esp
  801404:	8b 45 10             	mov    0x10(%ebp),%eax
  801407:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  80140a:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80140d:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801411:	8b 45 08             	mov    0x8(%ebp),%eax
  801414:	6a 00                	push   $0x0
  801416:	51                   	push   %ecx
  801417:	52                   	push   %edx
  801418:	ff 75 0c             	pushl  0xc(%ebp)
  80141b:	50                   	push   %eax
  80141c:	6a 00                	push   $0x0
  80141e:	e8 b0 ff ff ff       	call   8013d3 <syscall>
  801423:	83 c4 18             	add    $0x18,%esp
}
  801426:	90                   	nop
  801427:	c9                   	leave  
  801428:	c3                   	ret    

00801429 <sys_cgetc>:

int
sys_cgetc(void)
{
  801429:	55                   	push   %ebp
  80142a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  80142c:	6a 00                	push   $0x0
  80142e:	6a 00                	push   $0x0
  801430:	6a 00                	push   $0x0
  801432:	6a 00                	push   $0x0
  801434:	6a 00                	push   $0x0
  801436:	6a 02                	push   $0x2
  801438:	e8 96 ff ff ff       	call   8013d3 <syscall>
  80143d:	83 c4 18             	add    $0x18,%esp
}
  801440:	c9                   	leave  
  801441:	c3                   	ret    

00801442 <sys_lock_cons>:

void sys_lock_cons(void)
{
  801442:	55                   	push   %ebp
  801443:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  801445:	6a 00                	push   $0x0
  801447:	6a 00                	push   $0x0
  801449:	6a 00                	push   $0x0
  80144b:	6a 00                	push   $0x0
  80144d:	6a 00                	push   $0x0
  80144f:	6a 03                	push   $0x3
  801451:	e8 7d ff ff ff       	call   8013d3 <syscall>
  801456:	83 c4 18             	add    $0x18,%esp
}
  801459:	90                   	nop
  80145a:	c9                   	leave  
  80145b:	c3                   	ret    

0080145c <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  80145c:	55                   	push   %ebp
  80145d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  80145f:	6a 00                	push   $0x0
  801461:	6a 00                	push   $0x0
  801463:	6a 00                	push   $0x0
  801465:	6a 00                	push   $0x0
  801467:	6a 00                	push   $0x0
  801469:	6a 04                	push   $0x4
  80146b:	e8 63 ff ff ff       	call   8013d3 <syscall>
  801470:	83 c4 18             	add    $0x18,%esp
}
  801473:	90                   	nop
  801474:	c9                   	leave  
  801475:	c3                   	ret    

00801476 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801476:	55                   	push   %ebp
  801477:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801479:	8b 55 0c             	mov    0xc(%ebp),%edx
  80147c:	8b 45 08             	mov    0x8(%ebp),%eax
  80147f:	6a 00                	push   $0x0
  801481:	6a 00                	push   $0x0
  801483:	6a 00                	push   $0x0
  801485:	52                   	push   %edx
  801486:	50                   	push   %eax
  801487:	6a 08                	push   $0x8
  801489:	e8 45 ff ff ff       	call   8013d3 <syscall>
  80148e:	83 c4 18             	add    $0x18,%esp
}
  801491:	c9                   	leave  
  801492:	c3                   	ret    

00801493 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801493:	55                   	push   %ebp
  801494:	89 e5                	mov    %esp,%ebp
  801496:	56                   	push   %esi
  801497:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801498:	8b 75 18             	mov    0x18(%ebp),%esi
  80149b:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80149e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8014a1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8014a7:	56                   	push   %esi
  8014a8:	53                   	push   %ebx
  8014a9:	51                   	push   %ecx
  8014aa:	52                   	push   %edx
  8014ab:	50                   	push   %eax
  8014ac:	6a 09                	push   $0x9
  8014ae:	e8 20 ff ff ff       	call   8013d3 <syscall>
  8014b3:	83 c4 18             	add    $0x18,%esp
}
  8014b6:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8014b9:	5b                   	pop    %ebx
  8014ba:	5e                   	pop    %esi
  8014bb:	5d                   	pop    %ebp
  8014bc:	c3                   	ret    

008014bd <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  8014bd:	55                   	push   %ebp
  8014be:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  8014c0:	6a 00                	push   $0x0
  8014c2:	6a 00                	push   $0x0
  8014c4:	6a 00                	push   $0x0
  8014c6:	6a 00                	push   $0x0
  8014c8:	ff 75 08             	pushl  0x8(%ebp)
  8014cb:	6a 0a                	push   $0xa
  8014cd:	e8 01 ff ff ff       	call   8013d3 <syscall>
  8014d2:	83 c4 18             	add    $0x18,%esp
}
  8014d5:	c9                   	leave  
  8014d6:	c3                   	ret    

008014d7 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8014d7:	55                   	push   %ebp
  8014d8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8014da:	6a 00                	push   $0x0
  8014dc:	6a 00                	push   $0x0
  8014de:	6a 00                	push   $0x0
  8014e0:	ff 75 0c             	pushl  0xc(%ebp)
  8014e3:	ff 75 08             	pushl  0x8(%ebp)
  8014e6:	6a 0b                	push   $0xb
  8014e8:	e8 e6 fe ff ff       	call   8013d3 <syscall>
  8014ed:	83 c4 18             	add    $0x18,%esp
}
  8014f0:	c9                   	leave  
  8014f1:	c3                   	ret    

008014f2 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8014f2:	55                   	push   %ebp
  8014f3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8014f5:	6a 00                	push   $0x0
  8014f7:	6a 00                	push   $0x0
  8014f9:	6a 00                	push   $0x0
  8014fb:	6a 00                	push   $0x0
  8014fd:	6a 00                	push   $0x0
  8014ff:	6a 0c                	push   $0xc
  801501:	e8 cd fe ff ff       	call   8013d3 <syscall>
  801506:	83 c4 18             	add    $0x18,%esp
}
  801509:	c9                   	leave  
  80150a:	c3                   	ret    

0080150b <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  80150b:	55                   	push   %ebp
  80150c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  80150e:	6a 00                	push   $0x0
  801510:	6a 00                	push   $0x0
  801512:	6a 00                	push   $0x0
  801514:	6a 00                	push   $0x0
  801516:	6a 00                	push   $0x0
  801518:	6a 0d                	push   $0xd
  80151a:	e8 b4 fe ff ff       	call   8013d3 <syscall>
  80151f:	83 c4 18             	add    $0x18,%esp
}
  801522:	c9                   	leave  
  801523:	c3                   	ret    

00801524 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801524:	55                   	push   %ebp
  801525:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801527:	6a 00                	push   $0x0
  801529:	6a 00                	push   $0x0
  80152b:	6a 00                	push   $0x0
  80152d:	6a 00                	push   $0x0
  80152f:	6a 00                	push   $0x0
  801531:	6a 0e                	push   $0xe
  801533:	e8 9b fe ff ff       	call   8013d3 <syscall>
  801538:	83 c4 18             	add    $0x18,%esp
}
  80153b:	c9                   	leave  
  80153c:	c3                   	ret    

0080153d <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  80153d:	55                   	push   %ebp
  80153e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801540:	6a 00                	push   $0x0
  801542:	6a 00                	push   $0x0
  801544:	6a 00                	push   $0x0
  801546:	6a 00                	push   $0x0
  801548:	6a 00                	push   $0x0
  80154a:	6a 0f                	push   $0xf
  80154c:	e8 82 fe ff ff       	call   8013d3 <syscall>
  801551:	83 c4 18             	add    $0x18,%esp
}
  801554:	c9                   	leave  
  801555:	c3                   	ret    

00801556 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801556:	55                   	push   %ebp
  801557:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801559:	6a 00                	push   $0x0
  80155b:	6a 00                	push   $0x0
  80155d:	6a 00                	push   $0x0
  80155f:	6a 00                	push   $0x0
  801561:	ff 75 08             	pushl  0x8(%ebp)
  801564:	6a 10                	push   $0x10
  801566:	e8 68 fe ff ff       	call   8013d3 <syscall>
  80156b:	83 c4 18             	add    $0x18,%esp
}
  80156e:	c9                   	leave  
  80156f:	c3                   	ret    

00801570 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801570:	55                   	push   %ebp
  801571:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801573:	6a 00                	push   $0x0
  801575:	6a 00                	push   $0x0
  801577:	6a 00                	push   $0x0
  801579:	6a 00                	push   $0x0
  80157b:	6a 00                	push   $0x0
  80157d:	6a 11                	push   $0x11
  80157f:	e8 4f fe ff ff       	call   8013d3 <syscall>
  801584:	83 c4 18             	add    $0x18,%esp
}
  801587:	90                   	nop
  801588:	c9                   	leave  
  801589:	c3                   	ret    

0080158a <sys_cputc>:

void
sys_cputc(const char c)
{
  80158a:	55                   	push   %ebp
  80158b:	89 e5                	mov    %esp,%ebp
  80158d:	83 ec 04             	sub    $0x4,%esp
  801590:	8b 45 08             	mov    0x8(%ebp),%eax
  801593:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801596:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80159a:	6a 00                	push   $0x0
  80159c:	6a 00                	push   $0x0
  80159e:	6a 00                	push   $0x0
  8015a0:	6a 00                	push   $0x0
  8015a2:	50                   	push   %eax
  8015a3:	6a 01                	push   $0x1
  8015a5:	e8 29 fe ff ff       	call   8013d3 <syscall>
  8015aa:	83 c4 18             	add    $0x18,%esp
}
  8015ad:	90                   	nop
  8015ae:	c9                   	leave  
  8015af:	c3                   	ret    

008015b0 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8015b0:	55                   	push   %ebp
  8015b1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8015b3:	6a 00                	push   $0x0
  8015b5:	6a 00                	push   $0x0
  8015b7:	6a 00                	push   $0x0
  8015b9:	6a 00                	push   $0x0
  8015bb:	6a 00                	push   $0x0
  8015bd:	6a 14                	push   $0x14
  8015bf:	e8 0f fe ff ff       	call   8013d3 <syscall>
  8015c4:	83 c4 18             	add    $0x18,%esp
}
  8015c7:	90                   	nop
  8015c8:	c9                   	leave  
  8015c9:	c3                   	ret    

008015ca <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8015ca:	55                   	push   %ebp
  8015cb:	89 e5                	mov    %esp,%ebp
  8015cd:	83 ec 04             	sub    $0x4,%esp
  8015d0:	8b 45 10             	mov    0x10(%ebp),%eax
  8015d3:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8015d6:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8015d9:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8015dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8015e0:	6a 00                	push   $0x0
  8015e2:	51                   	push   %ecx
  8015e3:	52                   	push   %edx
  8015e4:	ff 75 0c             	pushl  0xc(%ebp)
  8015e7:	50                   	push   %eax
  8015e8:	6a 15                	push   $0x15
  8015ea:	e8 e4 fd ff ff       	call   8013d3 <syscall>
  8015ef:	83 c4 18             	add    $0x18,%esp
}
  8015f2:	c9                   	leave  
  8015f3:	c3                   	ret    

008015f4 <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  8015f4:	55                   	push   %ebp
  8015f5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8015f7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8015fd:	6a 00                	push   $0x0
  8015ff:	6a 00                	push   $0x0
  801601:	6a 00                	push   $0x0
  801603:	52                   	push   %edx
  801604:	50                   	push   %eax
  801605:	6a 16                	push   $0x16
  801607:	e8 c7 fd ff ff       	call   8013d3 <syscall>
  80160c:	83 c4 18             	add    $0x18,%esp
}
  80160f:	c9                   	leave  
  801610:	c3                   	ret    

00801611 <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  801611:	55                   	push   %ebp
  801612:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801614:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801617:	8b 55 0c             	mov    0xc(%ebp),%edx
  80161a:	8b 45 08             	mov    0x8(%ebp),%eax
  80161d:	6a 00                	push   $0x0
  80161f:	6a 00                	push   $0x0
  801621:	51                   	push   %ecx
  801622:	52                   	push   %edx
  801623:	50                   	push   %eax
  801624:	6a 17                	push   $0x17
  801626:	e8 a8 fd ff ff       	call   8013d3 <syscall>
  80162b:	83 c4 18             	add    $0x18,%esp
}
  80162e:	c9                   	leave  
  80162f:	c3                   	ret    

00801630 <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  801630:	55                   	push   %ebp
  801631:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801633:	8b 55 0c             	mov    0xc(%ebp),%edx
  801636:	8b 45 08             	mov    0x8(%ebp),%eax
  801639:	6a 00                	push   $0x0
  80163b:	6a 00                	push   $0x0
  80163d:	6a 00                	push   $0x0
  80163f:	52                   	push   %edx
  801640:	50                   	push   %eax
  801641:	6a 18                	push   $0x18
  801643:	e8 8b fd ff ff       	call   8013d3 <syscall>
  801648:	83 c4 18             	add    $0x18,%esp
}
  80164b:	c9                   	leave  
  80164c:	c3                   	ret    

0080164d <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  80164d:	55                   	push   %ebp
  80164e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801650:	8b 45 08             	mov    0x8(%ebp),%eax
  801653:	6a 00                	push   $0x0
  801655:	ff 75 14             	pushl  0x14(%ebp)
  801658:	ff 75 10             	pushl  0x10(%ebp)
  80165b:	ff 75 0c             	pushl  0xc(%ebp)
  80165e:	50                   	push   %eax
  80165f:	6a 19                	push   $0x19
  801661:	e8 6d fd ff ff       	call   8013d3 <syscall>
  801666:	83 c4 18             	add    $0x18,%esp
}
  801669:	c9                   	leave  
  80166a:	c3                   	ret    

0080166b <sys_run_env>:

void sys_run_env(int32 envId)
{
  80166b:	55                   	push   %ebp
  80166c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  80166e:	8b 45 08             	mov    0x8(%ebp),%eax
  801671:	6a 00                	push   $0x0
  801673:	6a 00                	push   $0x0
  801675:	6a 00                	push   $0x0
  801677:	6a 00                	push   $0x0
  801679:	50                   	push   %eax
  80167a:	6a 1a                	push   $0x1a
  80167c:	e8 52 fd ff ff       	call   8013d3 <syscall>
  801681:	83 c4 18             	add    $0x18,%esp
}
  801684:	90                   	nop
  801685:	c9                   	leave  
  801686:	c3                   	ret    

00801687 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801687:	55                   	push   %ebp
  801688:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  80168a:	8b 45 08             	mov    0x8(%ebp),%eax
  80168d:	6a 00                	push   $0x0
  80168f:	6a 00                	push   $0x0
  801691:	6a 00                	push   $0x0
  801693:	6a 00                	push   $0x0
  801695:	50                   	push   %eax
  801696:	6a 1b                	push   $0x1b
  801698:	e8 36 fd ff ff       	call   8013d3 <syscall>
  80169d:	83 c4 18             	add    $0x18,%esp
}
  8016a0:	c9                   	leave  
  8016a1:	c3                   	ret    

008016a2 <sys_getenvid>:

int32 sys_getenvid(void)
{
  8016a2:	55                   	push   %ebp
  8016a3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8016a5:	6a 00                	push   $0x0
  8016a7:	6a 00                	push   $0x0
  8016a9:	6a 00                	push   $0x0
  8016ab:	6a 00                	push   $0x0
  8016ad:	6a 00                	push   $0x0
  8016af:	6a 05                	push   $0x5
  8016b1:	e8 1d fd ff ff       	call   8013d3 <syscall>
  8016b6:	83 c4 18             	add    $0x18,%esp
}
  8016b9:	c9                   	leave  
  8016ba:	c3                   	ret    

008016bb <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8016bb:	55                   	push   %ebp
  8016bc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8016be:	6a 00                	push   $0x0
  8016c0:	6a 00                	push   $0x0
  8016c2:	6a 00                	push   $0x0
  8016c4:	6a 00                	push   $0x0
  8016c6:	6a 00                	push   $0x0
  8016c8:	6a 06                	push   $0x6
  8016ca:	e8 04 fd ff ff       	call   8013d3 <syscall>
  8016cf:	83 c4 18             	add    $0x18,%esp
}
  8016d2:	c9                   	leave  
  8016d3:	c3                   	ret    

008016d4 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8016d4:	55                   	push   %ebp
  8016d5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8016d7:	6a 00                	push   $0x0
  8016d9:	6a 00                	push   $0x0
  8016db:	6a 00                	push   $0x0
  8016dd:	6a 00                	push   $0x0
  8016df:	6a 00                	push   $0x0
  8016e1:	6a 07                	push   $0x7
  8016e3:	e8 eb fc ff ff       	call   8013d3 <syscall>
  8016e8:	83 c4 18             	add    $0x18,%esp
}
  8016eb:	c9                   	leave  
  8016ec:	c3                   	ret    

008016ed <sys_exit_env>:


void sys_exit_env(void)
{
  8016ed:	55                   	push   %ebp
  8016ee:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  8016f0:	6a 00                	push   $0x0
  8016f2:	6a 00                	push   $0x0
  8016f4:	6a 00                	push   $0x0
  8016f6:	6a 00                	push   $0x0
  8016f8:	6a 00                	push   $0x0
  8016fa:	6a 1c                	push   $0x1c
  8016fc:	e8 d2 fc ff ff       	call   8013d3 <syscall>
  801701:	83 c4 18             	add    $0x18,%esp
}
  801704:	90                   	nop
  801705:	c9                   	leave  
  801706:	c3                   	ret    

00801707 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  801707:	55                   	push   %ebp
  801708:	89 e5                	mov    %esp,%ebp
  80170a:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  80170d:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801710:	8d 50 04             	lea    0x4(%eax),%edx
  801713:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801716:	6a 00                	push   $0x0
  801718:	6a 00                	push   $0x0
  80171a:	6a 00                	push   $0x0
  80171c:	52                   	push   %edx
  80171d:	50                   	push   %eax
  80171e:	6a 1d                	push   $0x1d
  801720:	e8 ae fc ff ff       	call   8013d3 <syscall>
  801725:	83 c4 18             	add    $0x18,%esp
	return result;
  801728:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80172b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80172e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801731:	89 01                	mov    %eax,(%ecx)
  801733:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801736:	8b 45 08             	mov    0x8(%ebp),%eax
  801739:	c9                   	leave  
  80173a:	c2 04 00             	ret    $0x4

0080173d <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  80173d:	55                   	push   %ebp
  80173e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801740:	6a 00                	push   $0x0
  801742:	6a 00                	push   $0x0
  801744:	ff 75 10             	pushl  0x10(%ebp)
  801747:	ff 75 0c             	pushl  0xc(%ebp)
  80174a:	ff 75 08             	pushl  0x8(%ebp)
  80174d:	6a 13                	push   $0x13
  80174f:	e8 7f fc ff ff       	call   8013d3 <syscall>
  801754:	83 c4 18             	add    $0x18,%esp
	return ;
  801757:	90                   	nop
}
  801758:	c9                   	leave  
  801759:	c3                   	ret    

0080175a <sys_rcr2>:
uint32 sys_rcr2()
{
  80175a:	55                   	push   %ebp
  80175b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  80175d:	6a 00                	push   $0x0
  80175f:	6a 00                	push   $0x0
  801761:	6a 00                	push   $0x0
  801763:	6a 00                	push   $0x0
  801765:	6a 00                	push   $0x0
  801767:	6a 1e                	push   $0x1e
  801769:	e8 65 fc ff ff       	call   8013d3 <syscall>
  80176e:	83 c4 18             	add    $0x18,%esp
}
  801771:	c9                   	leave  
  801772:	c3                   	ret    

00801773 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  801773:	55                   	push   %ebp
  801774:	89 e5                	mov    %esp,%ebp
  801776:	83 ec 04             	sub    $0x4,%esp
  801779:	8b 45 08             	mov    0x8(%ebp),%eax
  80177c:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  80177f:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801783:	6a 00                	push   $0x0
  801785:	6a 00                	push   $0x0
  801787:	6a 00                	push   $0x0
  801789:	6a 00                	push   $0x0
  80178b:	50                   	push   %eax
  80178c:	6a 1f                	push   $0x1f
  80178e:	e8 40 fc ff ff       	call   8013d3 <syscall>
  801793:	83 c4 18             	add    $0x18,%esp
	return ;
  801796:	90                   	nop
}
  801797:	c9                   	leave  
  801798:	c3                   	ret    

00801799 <rsttst>:
void rsttst()
{
  801799:	55                   	push   %ebp
  80179a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  80179c:	6a 00                	push   $0x0
  80179e:	6a 00                	push   $0x0
  8017a0:	6a 00                	push   $0x0
  8017a2:	6a 00                	push   $0x0
  8017a4:	6a 00                	push   $0x0
  8017a6:	6a 21                	push   $0x21
  8017a8:	e8 26 fc ff ff       	call   8013d3 <syscall>
  8017ad:	83 c4 18             	add    $0x18,%esp
	return ;
  8017b0:	90                   	nop
}
  8017b1:	c9                   	leave  
  8017b2:	c3                   	ret    

008017b3 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8017b3:	55                   	push   %ebp
  8017b4:	89 e5                	mov    %esp,%ebp
  8017b6:	83 ec 04             	sub    $0x4,%esp
  8017b9:	8b 45 14             	mov    0x14(%ebp),%eax
  8017bc:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8017bf:	8b 55 18             	mov    0x18(%ebp),%edx
  8017c2:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8017c6:	52                   	push   %edx
  8017c7:	50                   	push   %eax
  8017c8:	ff 75 10             	pushl  0x10(%ebp)
  8017cb:	ff 75 0c             	pushl  0xc(%ebp)
  8017ce:	ff 75 08             	pushl  0x8(%ebp)
  8017d1:	6a 20                	push   $0x20
  8017d3:	e8 fb fb ff ff       	call   8013d3 <syscall>
  8017d8:	83 c4 18             	add    $0x18,%esp
	return ;
  8017db:	90                   	nop
}
  8017dc:	c9                   	leave  
  8017dd:	c3                   	ret    

008017de <chktst>:
void chktst(uint32 n)
{
  8017de:	55                   	push   %ebp
  8017df:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8017e1:	6a 00                	push   $0x0
  8017e3:	6a 00                	push   $0x0
  8017e5:	6a 00                	push   $0x0
  8017e7:	6a 00                	push   $0x0
  8017e9:	ff 75 08             	pushl  0x8(%ebp)
  8017ec:	6a 22                	push   $0x22
  8017ee:	e8 e0 fb ff ff       	call   8013d3 <syscall>
  8017f3:	83 c4 18             	add    $0x18,%esp
	return ;
  8017f6:	90                   	nop
}
  8017f7:	c9                   	leave  
  8017f8:	c3                   	ret    

008017f9 <inctst>:

void inctst()
{
  8017f9:	55                   	push   %ebp
  8017fa:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8017fc:	6a 00                	push   $0x0
  8017fe:	6a 00                	push   $0x0
  801800:	6a 00                	push   $0x0
  801802:	6a 00                	push   $0x0
  801804:	6a 00                	push   $0x0
  801806:	6a 23                	push   $0x23
  801808:	e8 c6 fb ff ff       	call   8013d3 <syscall>
  80180d:	83 c4 18             	add    $0x18,%esp
	return ;
  801810:	90                   	nop
}
  801811:	c9                   	leave  
  801812:	c3                   	ret    

00801813 <gettst>:
uint32 gettst()
{
  801813:	55                   	push   %ebp
  801814:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801816:	6a 00                	push   $0x0
  801818:	6a 00                	push   $0x0
  80181a:	6a 00                	push   $0x0
  80181c:	6a 00                	push   $0x0
  80181e:	6a 00                	push   $0x0
  801820:	6a 24                	push   $0x24
  801822:	e8 ac fb ff ff       	call   8013d3 <syscall>
  801827:	83 c4 18             	add    $0x18,%esp
}
  80182a:	c9                   	leave  
  80182b:	c3                   	ret    

0080182c <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  80182c:	55                   	push   %ebp
  80182d:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80182f:	6a 00                	push   $0x0
  801831:	6a 00                	push   $0x0
  801833:	6a 00                	push   $0x0
  801835:	6a 00                	push   $0x0
  801837:	6a 00                	push   $0x0
  801839:	6a 25                	push   $0x25
  80183b:	e8 93 fb ff ff       	call   8013d3 <syscall>
  801840:	83 c4 18             	add    $0x18,%esp
  801843:	a3 60 b0 81 00       	mov    %eax,0x81b060
	return uheapPlaceStrategy ;
  801848:	a1 60 b0 81 00       	mov    0x81b060,%eax
}
  80184d:	c9                   	leave  
  80184e:	c3                   	ret    

0080184f <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  80184f:	55                   	push   %ebp
  801850:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  801852:	8b 45 08             	mov    0x8(%ebp),%eax
  801855:	a3 60 b0 81 00       	mov    %eax,0x81b060
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  80185a:	6a 00                	push   $0x0
  80185c:	6a 00                	push   $0x0
  80185e:	6a 00                	push   $0x0
  801860:	6a 00                	push   $0x0
  801862:	ff 75 08             	pushl  0x8(%ebp)
  801865:	6a 26                	push   $0x26
  801867:	e8 67 fb ff ff       	call   8013d3 <syscall>
  80186c:	83 c4 18             	add    $0x18,%esp
	return ;
  80186f:	90                   	nop
}
  801870:	c9                   	leave  
  801871:	c3                   	ret    

00801872 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801872:	55                   	push   %ebp
  801873:	89 e5                	mov    %esp,%ebp
  801875:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801876:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801879:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80187c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80187f:	8b 45 08             	mov    0x8(%ebp),%eax
  801882:	6a 00                	push   $0x0
  801884:	53                   	push   %ebx
  801885:	51                   	push   %ecx
  801886:	52                   	push   %edx
  801887:	50                   	push   %eax
  801888:	6a 27                	push   $0x27
  80188a:	e8 44 fb ff ff       	call   8013d3 <syscall>
  80188f:	83 c4 18             	add    $0x18,%esp
}
  801892:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801895:	c9                   	leave  
  801896:	c3                   	ret    

00801897 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801897:	55                   	push   %ebp
  801898:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  80189a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80189d:	8b 45 08             	mov    0x8(%ebp),%eax
  8018a0:	6a 00                	push   $0x0
  8018a2:	6a 00                	push   $0x0
  8018a4:	6a 00                	push   $0x0
  8018a6:	52                   	push   %edx
  8018a7:	50                   	push   %eax
  8018a8:	6a 28                	push   $0x28
  8018aa:	e8 24 fb ff ff       	call   8013d3 <syscall>
  8018af:	83 c4 18             	add    $0x18,%esp
}
  8018b2:	c9                   	leave  
  8018b3:	c3                   	ret    

008018b4 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  8018b4:	55                   	push   %ebp
  8018b5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  8018b7:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8018ba:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8018c0:	6a 00                	push   $0x0
  8018c2:	51                   	push   %ecx
  8018c3:	ff 75 10             	pushl  0x10(%ebp)
  8018c6:	52                   	push   %edx
  8018c7:	50                   	push   %eax
  8018c8:	6a 29                	push   $0x29
  8018ca:	e8 04 fb ff ff       	call   8013d3 <syscall>
  8018cf:	83 c4 18             	add    $0x18,%esp
}
  8018d2:	c9                   	leave  
  8018d3:	c3                   	ret    

008018d4 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8018d4:	55                   	push   %ebp
  8018d5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8018d7:	6a 00                	push   $0x0
  8018d9:	6a 00                	push   $0x0
  8018db:	ff 75 10             	pushl  0x10(%ebp)
  8018de:	ff 75 0c             	pushl  0xc(%ebp)
  8018e1:	ff 75 08             	pushl  0x8(%ebp)
  8018e4:	6a 12                	push   $0x12
  8018e6:	e8 e8 fa ff ff       	call   8013d3 <syscall>
  8018eb:	83 c4 18             	add    $0x18,%esp
	return ;
  8018ee:	90                   	nop
}
  8018ef:	c9                   	leave  
  8018f0:	c3                   	ret    

008018f1 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  8018f1:	55                   	push   %ebp
  8018f2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  8018f4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8018fa:	6a 00                	push   $0x0
  8018fc:	6a 00                	push   $0x0
  8018fe:	6a 00                	push   $0x0
  801900:	52                   	push   %edx
  801901:	50                   	push   %eax
  801902:	6a 2a                	push   $0x2a
  801904:	e8 ca fa ff ff       	call   8013d3 <syscall>
  801909:	83 c4 18             	add    $0x18,%esp
	return;
  80190c:	90                   	nop
}
  80190d:	c9                   	leave  
  80190e:	c3                   	ret    

0080190f <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  80190f:	55                   	push   %ebp
  801910:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  801912:	6a 00                	push   $0x0
  801914:	6a 00                	push   $0x0
  801916:	6a 00                	push   $0x0
  801918:	6a 00                	push   $0x0
  80191a:	6a 00                	push   $0x0
  80191c:	6a 2b                	push   $0x2b
  80191e:	e8 b0 fa ff ff       	call   8013d3 <syscall>
  801923:	83 c4 18             	add    $0x18,%esp
}
  801926:	c9                   	leave  
  801927:	c3                   	ret    

00801928 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801928:	55                   	push   %ebp
  801929:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  80192b:	6a 00                	push   $0x0
  80192d:	6a 00                	push   $0x0
  80192f:	6a 00                	push   $0x0
  801931:	ff 75 0c             	pushl  0xc(%ebp)
  801934:	ff 75 08             	pushl  0x8(%ebp)
  801937:	6a 2d                	push   $0x2d
  801939:	e8 95 fa ff ff       	call   8013d3 <syscall>
  80193e:	83 c4 18             	add    $0x18,%esp
	return;
  801941:	90                   	nop
}
  801942:	c9                   	leave  
  801943:	c3                   	ret    

00801944 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801944:	55                   	push   %ebp
  801945:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801947:	6a 00                	push   $0x0
  801949:	6a 00                	push   $0x0
  80194b:	6a 00                	push   $0x0
  80194d:	ff 75 0c             	pushl  0xc(%ebp)
  801950:	ff 75 08             	pushl  0x8(%ebp)
  801953:	6a 2c                	push   $0x2c
  801955:	e8 79 fa ff ff       	call   8013d3 <syscall>
  80195a:	83 c4 18             	add    $0x18,%esp
	return ;
  80195d:	90                   	nop
}
  80195e:	c9                   	leave  
  80195f:	c3                   	ret    

00801960 <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  801960:	55                   	push   %ebp
  801961:	89 e5                	mov    %esp,%ebp
	//TODO: [PROJECT'25.IM#4] CPU SCHEDULING - #1 System Calls - Add suitable code here
	//Your code is here
	//Comment the following line
	//panic("sys_env_set_priority() is not implemented yet...!!");
	syscall(SYS_env_set_priority, envID, priority, 0, 0, 0);
  801963:	8b 55 0c             	mov    0xc(%ebp),%edx
  801966:	8b 45 08             	mov    0x8(%ebp),%eax
  801969:	6a 00                	push   $0x0
  80196b:	6a 00                	push   $0x0
  80196d:	6a 00                	push   $0x0
  80196f:	52                   	push   %edx
  801970:	50                   	push   %eax
  801971:	6a 2e                	push   $0x2e
  801973:	e8 5b fa ff ff       	call   8013d3 <syscall>
  801978:	83 c4 18             	add    $0x18,%esp
	    return;
  80197b:	90                   	nop
}
  80197c:	c9                   	leave  
  80197d:	c3                   	ret    
  80197e:	66 90                	xchg   %ax,%ax

00801980 <__udivdi3>:
  801980:	55                   	push   %ebp
  801981:	57                   	push   %edi
  801982:	56                   	push   %esi
  801983:	53                   	push   %ebx
  801984:	83 ec 1c             	sub    $0x1c,%esp
  801987:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80198b:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80198f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801993:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801997:	89 ca                	mov    %ecx,%edx
  801999:	89 f8                	mov    %edi,%eax
  80199b:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80199f:	85 f6                	test   %esi,%esi
  8019a1:	75 2d                	jne    8019d0 <__udivdi3+0x50>
  8019a3:	39 cf                	cmp    %ecx,%edi
  8019a5:	77 65                	ja     801a0c <__udivdi3+0x8c>
  8019a7:	89 fd                	mov    %edi,%ebp
  8019a9:	85 ff                	test   %edi,%edi
  8019ab:	75 0b                	jne    8019b8 <__udivdi3+0x38>
  8019ad:	b8 01 00 00 00       	mov    $0x1,%eax
  8019b2:	31 d2                	xor    %edx,%edx
  8019b4:	f7 f7                	div    %edi
  8019b6:	89 c5                	mov    %eax,%ebp
  8019b8:	31 d2                	xor    %edx,%edx
  8019ba:	89 c8                	mov    %ecx,%eax
  8019bc:	f7 f5                	div    %ebp
  8019be:	89 c1                	mov    %eax,%ecx
  8019c0:	89 d8                	mov    %ebx,%eax
  8019c2:	f7 f5                	div    %ebp
  8019c4:	89 cf                	mov    %ecx,%edi
  8019c6:	89 fa                	mov    %edi,%edx
  8019c8:	83 c4 1c             	add    $0x1c,%esp
  8019cb:	5b                   	pop    %ebx
  8019cc:	5e                   	pop    %esi
  8019cd:	5f                   	pop    %edi
  8019ce:	5d                   	pop    %ebp
  8019cf:	c3                   	ret    
  8019d0:	39 ce                	cmp    %ecx,%esi
  8019d2:	77 28                	ja     8019fc <__udivdi3+0x7c>
  8019d4:	0f bd fe             	bsr    %esi,%edi
  8019d7:	83 f7 1f             	xor    $0x1f,%edi
  8019da:	75 40                	jne    801a1c <__udivdi3+0x9c>
  8019dc:	39 ce                	cmp    %ecx,%esi
  8019de:	72 0a                	jb     8019ea <__udivdi3+0x6a>
  8019e0:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8019e4:	0f 87 9e 00 00 00    	ja     801a88 <__udivdi3+0x108>
  8019ea:	b8 01 00 00 00       	mov    $0x1,%eax
  8019ef:	89 fa                	mov    %edi,%edx
  8019f1:	83 c4 1c             	add    $0x1c,%esp
  8019f4:	5b                   	pop    %ebx
  8019f5:	5e                   	pop    %esi
  8019f6:	5f                   	pop    %edi
  8019f7:	5d                   	pop    %ebp
  8019f8:	c3                   	ret    
  8019f9:	8d 76 00             	lea    0x0(%esi),%esi
  8019fc:	31 ff                	xor    %edi,%edi
  8019fe:	31 c0                	xor    %eax,%eax
  801a00:	89 fa                	mov    %edi,%edx
  801a02:	83 c4 1c             	add    $0x1c,%esp
  801a05:	5b                   	pop    %ebx
  801a06:	5e                   	pop    %esi
  801a07:	5f                   	pop    %edi
  801a08:	5d                   	pop    %ebp
  801a09:	c3                   	ret    
  801a0a:	66 90                	xchg   %ax,%ax
  801a0c:	89 d8                	mov    %ebx,%eax
  801a0e:	f7 f7                	div    %edi
  801a10:	31 ff                	xor    %edi,%edi
  801a12:	89 fa                	mov    %edi,%edx
  801a14:	83 c4 1c             	add    $0x1c,%esp
  801a17:	5b                   	pop    %ebx
  801a18:	5e                   	pop    %esi
  801a19:	5f                   	pop    %edi
  801a1a:	5d                   	pop    %ebp
  801a1b:	c3                   	ret    
  801a1c:	bd 20 00 00 00       	mov    $0x20,%ebp
  801a21:	89 eb                	mov    %ebp,%ebx
  801a23:	29 fb                	sub    %edi,%ebx
  801a25:	89 f9                	mov    %edi,%ecx
  801a27:	d3 e6                	shl    %cl,%esi
  801a29:	89 c5                	mov    %eax,%ebp
  801a2b:	88 d9                	mov    %bl,%cl
  801a2d:	d3 ed                	shr    %cl,%ebp
  801a2f:	89 e9                	mov    %ebp,%ecx
  801a31:	09 f1                	or     %esi,%ecx
  801a33:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801a37:	89 f9                	mov    %edi,%ecx
  801a39:	d3 e0                	shl    %cl,%eax
  801a3b:	89 c5                	mov    %eax,%ebp
  801a3d:	89 d6                	mov    %edx,%esi
  801a3f:	88 d9                	mov    %bl,%cl
  801a41:	d3 ee                	shr    %cl,%esi
  801a43:	89 f9                	mov    %edi,%ecx
  801a45:	d3 e2                	shl    %cl,%edx
  801a47:	8b 44 24 08          	mov    0x8(%esp),%eax
  801a4b:	88 d9                	mov    %bl,%cl
  801a4d:	d3 e8                	shr    %cl,%eax
  801a4f:	09 c2                	or     %eax,%edx
  801a51:	89 d0                	mov    %edx,%eax
  801a53:	89 f2                	mov    %esi,%edx
  801a55:	f7 74 24 0c          	divl   0xc(%esp)
  801a59:	89 d6                	mov    %edx,%esi
  801a5b:	89 c3                	mov    %eax,%ebx
  801a5d:	f7 e5                	mul    %ebp
  801a5f:	39 d6                	cmp    %edx,%esi
  801a61:	72 19                	jb     801a7c <__udivdi3+0xfc>
  801a63:	74 0b                	je     801a70 <__udivdi3+0xf0>
  801a65:	89 d8                	mov    %ebx,%eax
  801a67:	31 ff                	xor    %edi,%edi
  801a69:	e9 58 ff ff ff       	jmp    8019c6 <__udivdi3+0x46>
  801a6e:	66 90                	xchg   %ax,%ax
  801a70:	8b 54 24 08          	mov    0x8(%esp),%edx
  801a74:	89 f9                	mov    %edi,%ecx
  801a76:	d3 e2                	shl    %cl,%edx
  801a78:	39 c2                	cmp    %eax,%edx
  801a7a:	73 e9                	jae    801a65 <__udivdi3+0xe5>
  801a7c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801a7f:	31 ff                	xor    %edi,%edi
  801a81:	e9 40 ff ff ff       	jmp    8019c6 <__udivdi3+0x46>
  801a86:	66 90                	xchg   %ax,%ax
  801a88:	31 c0                	xor    %eax,%eax
  801a8a:	e9 37 ff ff ff       	jmp    8019c6 <__udivdi3+0x46>
  801a8f:	90                   	nop

00801a90 <__umoddi3>:
  801a90:	55                   	push   %ebp
  801a91:	57                   	push   %edi
  801a92:	56                   	push   %esi
  801a93:	53                   	push   %ebx
  801a94:	83 ec 1c             	sub    $0x1c,%esp
  801a97:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801a9b:	8b 74 24 34          	mov    0x34(%esp),%esi
  801a9f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801aa3:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801aa7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801aab:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801aaf:	89 f3                	mov    %esi,%ebx
  801ab1:	89 fa                	mov    %edi,%edx
  801ab3:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801ab7:	89 34 24             	mov    %esi,(%esp)
  801aba:	85 c0                	test   %eax,%eax
  801abc:	75 1a                	jne    801ad8 <__umoddi3+0x48>
  801abe:	39 f7                	cmp    %esi,%edi
  801ac0:	0f 86 a2 00 00 00    	jbe    801b68 <__umoddi3+0xd8>
  801ac6:	89 c8                	mov    %ecx,%eax
  801ac8:	89 f2                	mov    %esi,%edx
  801aca:	f7 f7                	div    %edi
  801acc:	89 d0                	mov    %edx,%eax
  801ace:	31 d2                	xor    %edx,%edx
  801ad0:	83 c4 1c             	add    $0x1c,%esp
  801ad3:	5b                   	pop    %ebx
  801ad4:	5e                   	pop    %esi
  801ad5:	5f                   	pop    %edi
  801ad6:	5d                   	pop    %ebp
  801ad7:	c3                   	ret    
  801ad8:	39 f0                	cmp    %esi,%eax
  801ada:	0f 87 ac 00 00 00    	ja     801b8c <__umoddi3+0xfc>
  801ae0:	0f bd e8             	bsr    %eax,%ebp
  801ae3:	83 f5 1f             	xor    $0x1f,%ebp
  801ae6:	0f 84 ac 00 00 00    	je     801b98 <__umoddi3+0x108>
  801aec:	bf 20 00 00 00       	mov    $0x20,%edi
  801af1:	29 ef                	sub    %ebp,%edi
  801af3:	89 fe                	mov    %edi,%esi
  801af5:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801af9:	89 e9                	mov    %ebp,%ecx
  801afb:	d3 e0                	shl    %cl,%eax
  801afd:	89 d7                	mov    %edx,%edi
  801aff:	89 f1                	mov    %esi,%ecx
  801b01:	d3 ef                	shr    %cl,%edi
  801b03:	09 c7                	or     %eax,%edi
  801b05:	89 e9                	mov    %ebp,%ecx
  801b07:	d3 e2                	shl    %cl,%edx
  801b09:	89 14 24             	mov    %edx,(%esp)
  801b0c:	89 d8                	mov    %ebx,%eax
  801b0e:	d3 e0                	shl    %cl,%eax
  801b10:	89 c2                	mov    %eax,%edx
  801b12:	8b 44 24 08          	mov    0x8(%esp),%eax
  801b16:	d3 e0                	shl    %cl,%eax
  801b18:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b1c:	8b 44 24 08          	mov    0x8(%esp),%eax
  801b20:	89 f1                	mov    %esi,%ecx
  801b22:	d3 e8                	shr    %cl,%eax
  801b24:	09 d0                	or     %edx,%eax
  801b26:	d3 eb                	shr    %cl,%ebx
  801b28:	89 da                	mov    %ebx,%edx
  801b2a:	f7 f7                	div    %edi
  801b2c:	89 d3                	mov    %edx,%ebx
  801b2e:	f7 24 24             	mull   (%esp)
  801b31:	89 c6                	mov    %eax,%esi
  801b33:	89 d1                	mov    %edx,%ecx
  801b35:	39 d3                	cmp    %edx,%ebx
  801b37:	0f 82 87 00 00 00    	jb     801bc4 <__umoddi3+0x134>
  801b3d:	0f 84 91 00 00 00    	je     801bd4 <__umoddi3+0x144>
  801b43:	8b 54 24 04          	mov    0x4(%esp),%edx
  801b47:	29 f2                	sub    %esi,%edx
  801b49:	19 cb                	sbb    %ecx,%ebx
  801b4b:	89 d8                	mov    %ebx,%eax
  801b4d:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801b51:	d3 e0                	shl    %cl,%eax
  801b53:	89 e9                	mov    %ebp,%ecx
  801b55:	d3 ea                	shr    %cl,%edx
  801b57:	09 d0                	or     %edx,%eax
  801b59:	89 e9                	mov    %ebp,%ecx
  801b5b:	d3 eb                	shr    %cl,%ebx
  801b5d:	89 da                	mov    %ebx,%edx
  801b5f:	83 c4 1c             	add    $0x1c,%esp
  801b62:	5b                   	pop    %ebx
  801b63:	5e                   	pop    %esi
  801b64:	5f                   	pop    %edi
  801b65:	5d                   	pop    %ebp
  801b66:	c3                   	ret    
  801b67:	90                   	nop
  801b68:	89 fd                	mov    %edi,%ebp
  801b6a:	85 ff                	test   %edi,%edi
  801b6c:	75 0b                	jne    801b79 <__umoddi3+0xe9>
  801b6e:	b8 01 00 00 00       	mov    $0x1,%eax
  801b73:	31 d2                	xor    %edx,%edx
  801b75:	f7 f7                	div    %edi
  801b77:	89 c5                	mov    %eax,%ebp
  801b79:	89 f0                	mov    %esi,%eax
  801b7b:	31 d2                	xor    %edx,%edx
  801b7d:	f7 f5                	div    %ebp
  801b7f:	89 c8                	mov    %ecx,%eax
  801b81:	f7 f5                	div    %ebp
  801b83:	89 d0                	mov    %edx,%eax
  801b85:	e9 44 ff ff ff       	jmp    801ace <__umoddi3+0x3e>
  801b8a:	66 90                	xchg   %ax,%ax
  801b8c:	89 c8                	mov    %ecx,%eax
  801b8e:	89 f2                	mov    %esi,%edx
  801b90:	83 c4 1c             	add    $0x1c,%esp
  801b93:	5b                   	pop    %ebx
  801b94:	5e                   	pop    %esi
  801b95:	5f                   	pop    %edi
  801b96:	5d                   	pop    %ebp
  801b97:	c3                   	ret    
  801b98:	3b 04 24             	cmp    (%esp),%eax
  801b9b:	72 06                	jb     801ba3 <__umoddi3+0x113>
  801b9d:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801ba1:	77 0f                	ja     801bb2 <__umoddi3+0x122>
  801ba3:	89 f2                	mov    %esi,%edx
  801ba5:	29 f9                	sub    %edi,%ecx
  801ba7:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801bab:	89 14 24             	mov    %edx,(%esp)
  801bae:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801bb2:	8b 44 24 04          	mov    0x4(%esp),%eax
  801bb6:	8b 14 24             	mov    (%esp),%edx
  801bb9:	83 c4 1c             	add    $0x1c,%esp
  801bbc:	5b                   	pop    %ebx
  801bbd:	5e                   	pop    %esi
  801bbe:	5f                   	pop    %edi
  801bbf:	5d                   	pop    %ebp
  801bc0:	c3                   	ret    
  801bc1:	8d 76 00             	lea    0x0(%esi),%esi
  801bc4:	2b 04 24             	sub    (%esp),%eax
  801bc7:	19 fa                	sbb    %edi,%edx
  801bc9:	89 d1                	mov    %edx,%ecx
  801bcb:	89 c6                	mov    %eax,%esi
  801bcd:	e9 71 ff ff ff       	jmp    801b43 <__umoddi3+0xb3>
  801bd2:	66 90                	xchg   %ax,%ax
  801bd4:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801bd8:	72 ea                	jb     801bc4 <__umoddi3+0x134>
  801bda:	89 d9                	mov    %ebx,%ecx
  801bdc:	e9 62 ff ff ff       	jmp    801b43 <__umoddi3+0xb3>
