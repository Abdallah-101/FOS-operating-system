
obj/user/tst_custom_fit_2:     file format elf32-i386


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
  800031:	e8 a4 00 00 00       	call   8000da <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <check_dynalloc_datastruct>:
#define USER_TST_UTILITIES_H_
#include <inc/types.h>
#include <inc/stdio.h>

int check_dynalloc_datastruct(void* va, void* expectedVA, uint32 expectedSize, uint8 expectedFlag)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	83 ec 28             	sub    $0x28,%esp
  80003e:	8b 45 14             	mov    0x14(%ebp),%eax
  800041:	88 45 e4             	mov    %al,-0x1c(%ebp)
	//Check returned va
	if(va != expectedVA)
  800044:	8b 45 08             	mov    0x8(%ebp),%eax
  800047:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80004a:	74 1d                	je     800069 <check_dynalloc_datastruct+0x31>
	{
		cprintf("wrong block address. Expected %x, Actual %x\n", expectedVA, va);
  80004c:	83 ec 04             	sub    $0x4,%esp
  80004f:	ff 75 08             	pushl  0x8(%ebp)
  800052:	ff 75 0c             	pushl  0xc(%ebp)
  800055:	68 60 1c 80 00       	push   $0x801c60
  80005a:	e8 02 05 00 00       	call   800561 <cprintf>
  80005f:	83 c4 10             	add    $0x10,%esp
		return 0;
  800062:	b8 00 00 00 00       	mov    $0x0,%eax
  800067:	eb 55                	jmp    8000be <check_dynalloc_datastruct+0x86>
	}
	//Check header & footer
	uint32 header = *((uint32*)va-1);
  800069:	8b 45 08             	mov    0x8(%ebp),%eax
  80006c:	8b 40 fc             	mov    -0x4(%eax),%eax
  80006f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	uint32 footer = *((uint32*)(va + expectedSize - 8));
  800072:	8b 45 10             	mov    0x10(%ebp),%eax
  800075:	8d 50 f8             	lea    -0x8(%eax),%edx
  800078:	8b 45 08             	mov    0x8(%ebp),%eax
  80007b:	01 d0                	add    %edx,%eax
  80007d:	8b 00                	mov    (%eax),%eax
  80007f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 expectedData = expectedSize | expectedFlag ;
  800082:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  800086:	0b 45 10             	or     0x10(%ebp),%eax
  800089:	89 45 ec             	mov    %eax,-0x14(%ebp)
	if(header != expectedData || footer != expectedData)
  80008c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80008f:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  800092:	75 08                	jne    80009c <check_dynalloc_datastruct+0x64>
  800094:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800097:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  80009a:	74 1d                	je     8000b9 <check_dynalloc_datastruct+0x81>
	{
		cprintf("wrong header/footer data. Expected %d, Actual H:%d F:%d\n", expectedData, header, footer);
  80009c:	ff 75 f0             	pushl  -0x10(%ebp)
  80009f:	ff 75 f4             	pushl  -0xc(%ebp)
  8000a2:	ff 75 ec             	pushl  -0x14(%ebp)
  8000a5:	68 90 1c 80 00       	push   $0x801c90
  8000aa:	e8 b2 04 00 00       	call   800561 <cprintf>
  8000af:	83 c4 10             	add    $0x10,%esp
		return 0;
  8000b2:	b8 00 00 00 00       	mov    $0x0,%eax
  8000b7:	eb 05                	jmp    8000be <check_dynalloc_datastruct+0x86>
	}
	return 1;
  8000b9:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8000be:	c9                   	leave  
  8000bf:	c3                   	ret    

008000c0 <_main>:
short* startVAs[numOfAllocs*allocCntPerSize+1] ;
short* midVAs[numOfAllocs*allocCntPerSize+1] ;
short* endVAs[numOfAllocs*allocCntPerSize+1] ;

void _main(void)
{
  8000c0:	55                   	push   %ebp
  8000c1:	89 e5                	mov    %esp,%ebp
  8000c3:	83 ec 68             	sub    $0x68,%esp
	panic("update is required!!");
  8000c6:	83 ec 04             	sub    $0x4,%esp
  8000c9:	68 c9 1c 80 00       	push   $0x801cc9
  8000ce:	6a 19                	push   $0x19
  8000d0:	68 de 1c 80 00       	push   $0x801cde
  8000d5:	e8 b9 01 00 00       	call   800293 <_panic>

008000da <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  8000da:	55                   	push   %ebp
  8000db:	89 e5                	mov    %esp,%ebp
  8000dd:	57                   	push   %edi
  8000de:	56                   	push   %esi
  8000df:	53                   	push   %ebx
  8000e0:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  8000e3:	e8 46 16 00 00       	call   80172e <sys_getenvindex>
  8000e8:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  8000eb:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8000ee:	89 d0                	mov    %edx,%eax
  8000f0:	c1 e0 02             	shl    $0x2,%eax
  8000f3:	01 d0                	add    %edx,%eax
  8000f5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8000fc:	01 d0                	add    %edx,%eax
  8000fe:	89 c2                	mov    %eax,%edx
  800100:	c1 e2 04             	shl    $0x4,%edx
  800103:	29 c2                	sub    %eax,%edx
  800105:	8d 04 95 00 00 00 00 	lea    0x0(,%edx,4),%eax
  80010c:	89 c2                	mov    %eax,%edx
  80010e:	8d 82 00 00 c0 ee    	lea    -0x11400000(%edx),%eax
  800114:	a3 40 30 80 00       	mov    %eax,0x803040

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800119:	a1 40 30 80 00       	mov    0x803040,%eax
  80011e:	8a 40 20             	mov    0x20(%eax),%al
  800121:	84 c0                	test   %al,%al
  800123:	74 0d                	je     800132 <libmain+0x58>
		binaryname = myEnv->prog_name;
  800125:	a1 40 30 80 00       	mov    0x803040,%eax
  80012a:	83 c0 20             	add    $0x20,%eax
  80012d:	a3 20 30 80 00       	mov    %eax,0x803020

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800132:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800136:	7e 0a                	jle    800142 <libmain+0x68>
		binaryname = argv[0];
  800138:	8b 45 0c             	mov    0xc(%ebp),%eax
  80013b:	8b 00                	mov    (%eax),%eax
  80013d:	a3 20 30 80 00       	mov    %eax,0x803020

	// call user main routine
	_main(argc, argv);
  800142:	83 ec 08             	sub    $0x8,%esp
  800145:	ff 75 0c             	pushl  0xc(%ebp)
  800148:	ff 75 08             	pushl  0x8(%ebp)
  80014b:	e8 70 ff ff ff       	call   8000c0 <_main>
  800150:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  800153:	a1 1c 30 80 00       	mov    0x80301c,%eax
  800158:	85 c0                	test   %eax,%eax
  80015a:	0f 84 01 01 00 00    	je     800261 <libmain+0x187>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  800160:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  800166:	bb f0 1d 80 00       	mov    $0x801df0,%ebx
  80016b:	ba 0e 00 00 00       	mov    $0xe,%edx
  800170:	89 c7                	mov    %eax,%edi
  800172:	89 de                	mov    %ebx,%esi
  800174:	89 d1                	mov    %edx,%ecx
  800176:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  800178:	8d 55 8a             	lea    -0x76(%ebp),%edx
  80017b:	b9 56 00 00 00       	mov    $0x56,%ecx
  800180:	b0 00                	mov    $0x0,%al
  800182:	89 d7                	mov    %edx,%edi
  800184:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  800186:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  80018d:	8d 45 e0             	lea    -0x20(%ebp),%eax
  800190:	83 ec 08             	sub    $0x8,%esp
  800193:	50                   	push   %eax
  800194:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  80019a:	50                   	push   %eax
  80019b:	e8 c4 17 00 00       	call   801964 <sys_utilities>
  8001a0:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  8001a3:	e8 0d 13 00 00       	call   8014b5 <sys_lock_cons>
		{
			cprintf("**************************************\n");
  8001a8:	83 ec 0c             	sub    $0xc,%esp
  8001ab:	68 10 1d 80 00       	push   $0x801d10
  8001b0:	e8 ac 03 00 00       	call   800561 <cprintf>
  8001b5:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  8001b8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8001bb:	85 c0                	test   %eax,%eax
  8001bd:	74 18                	je     8001d7 <libmain+0xfd>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  8001bf:	e8 be 17 00 00       	call   801982 <sys_get_optimal_num_faults>
  8001c4:	83 ec 08             	sub    $0x8,%esp
  8001c7:	50                   	push   %eax
  8001c8:	68 38 1d 80 00       	push   $0x801d38
  8001cd:	e8 8f 03 00 00       	call   800561 <cprintf>
  8001d2:	83 c4 10             	add    $0x10,%esp
  8001d5:	eb 59                	jmp    800230 <libmain+0x156>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8001d7:	a1 40 30 80 00       	mov    0x803040,%eax
  8001dc:	8b 90 bc 05 00 00    	mov    0x5bc(%eax),%edx
  8001e2:	a1 40 30 80 00       	mov    0x803040,%eax
  8001e7:	8b 80 ac 05 00 00    	mov    0x5ac(%eax),%eax
  8001ed:	83 ec 04             	sub    $0x4,%esp
  8001f0:	52                   	push   %edx
  8001f1:	50                   	push   %eax
  8001f2:	68 5c 1d 80 00       	push   $0x801d5c
  8001f7:	e8 65 03 00 00       	call   800561 <cprintf>
  8001fc:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8001ff:	a1 40 30 80 00       	mov    0x803040,%eax
  800204:	8b 88 d0 05 00 00    	mov    0x5d0(%eax),%ecx
  80020a:	a1 40 30 80 00       	mov    0x803040,%eax
  80020f:	8b 90 cc 05 00 00    	mov    0x5cc(%eax),%edx
  800215:	a1 40 30 80 00       	mov    0x803040,%eax
  80021a:	8b 80 c8 05 00 00    	mov    0x5c8(%eax),%eax
  800220:	51                   	push   %ecx
  800221:	52                   	push   %edx
  800222:	50                   	push   %eax
  800223:	68 84 1d 80 00       	push   $0x801d84
  800228:	e8 34 03 00 00       	call   800561 <cprintf>
  80022d:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800230:	a1 40 30 80 00       	mov    0x803040,%eax
  800235:	8b 80 d4 05 00 00    	mov    0x5d4(%eax),%eax
  80023b:	83 ec 08             	sub    $0x8,%esp
  80023e:	50                   	push   %eax
  80023f:	68 dc 1d 80 00       	push   $0x801ddc
  800244:	e8 18 03 00 00       	call   800561 <cprintf>
  800249:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  80024c:	83 ec 0c             	sub    $0xc,%esp
  80024f:	68 10 1d 80 00       	push   $0x801d10
  800254:	e8 08 03 00 00       	call   800561 <cprintf>
  800259:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  80025c:	e8 6e 12 00 00       	call   8014cf <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  800261:	e8 1f 00 00 00       	call   800285 <exit>
}
  800266:	90                   	nop
  800267:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80026a:	5b                   	pop    %ebx
  80026b:	5e                   	pop    %esi
  80026c:	5f                   	pop    %edi
  80026d:	5d                   	pop    %ebp
  80026e:	c3                   	ret    

0080026f <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  80026f:	55                   	push   %ebp
  800270:	89 e5                	mov    %esp,%ebp
  800272:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800275:	83 ec 0c             	sub    $0xc,%esp
  800278:	6a 00                	push   $0x0
  80027a:	e8 7b 14 00 00       	call   8016fa <sys_destroy_env>
  80027f:	83 c4 10             	add    $0x10,%esp
}
  800282:	90                   	nop
  800283:	c9                   	leave  
  800284:	c3                   	ret    

00800285 <exit>:

void
exit(void)
{
  800285:	55                   	push   %ebp
  800286:	89 e5                	mov    %esp,%ebp
  800288:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  80028b:	e8 d0 14 00 00       	call   801760 <sys_exit_env>
}
  800290:	90                   	nop
  800291:	c9                   	leave  
  800292:	c3                   	ret    

00800293 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800293:	55                   	push   %ebp
  800294:	89 e5                	mov    %esp,%ebp
  800296:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800299:	8d 45 10             	lea    0x10(%ebp),%eax
  80029c:	83 c0 04             	add    $0x4,%eax
  80029f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8002a2:	a1 38 f3 81 00       	mov    0x81f338,%eax
  8002a7:	85 c0                	test   %eax,%eax
  8002a9:	74 16                	je     8002c1 <_panic+0x2e>
		cprintf("%s: ", argv0);
  8002ab:	a1 38 f3 81 00       	mov    0x81f338,%eax
  8002b0:	83 ec 08             	sub    $0x8,%esp
  8002b3:	50                   	push   %eax
  8002b4:	68 54 1e 80 00       	push   $0x801e54
  8002b9:	e8 a3 02 00 00       	call   800561 <cprintf>
  8002be:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  8002c1:	a1 20 30 80 00       	mov    0x803020,%eax
  8002c6:	83 ec 0c             	sub    $0xc,%esp
  8002c9:	ff 75 0c             	pushl  0xc(%ebp)
  8002cc:	ff 75 08             	pushl  0x8(%ebp)
  8002cf:	50                   	push   %eax
  8002d0:	68 5c 1e 80 00       	push   $0x801e5c
  8002d5:	6a 74                	push   $0x74
  8002d7:	e8 b2 02 00 00       	call   80058e <cprintf_colored>
  8002dc:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  8002df:	8b 45 10             	mov    0x10(%ebp),%eax
  8002e2:	83 ec 08             	sub    $0x8,%esp
  8002e5:	ff 75 f4             	pushl  -0xc(%ebp)
  8002e8:	50                   	push   %eax
  8002e9:	e8 04 02 00 00       	call   8004f2 <vcprintf>
  8002ee:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8002f1:	83 ec 08             	sub    $0x8,%esp
  8002f4:	6a 00                	push   $0x0
  8002f6:	68 84 1e 80 00       	push   $0x801e84
  8002fb:	e8 f2 01 00 00       	call   8004f2 <vcprintf>
  800300:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800303:	e8 7d ff ff ff       	call   800285 <exit>

	// should not return here
	while (1) ;
  800308:	eb fe                	jmp    800308 <_panic+0x75>

0080030a <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  80030a:	55                   	push   %ebp
  80030b:	89 e5                	mov    %esp,%ebp
  80030d:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800310:	a1 40 30 80 00       	mov    0x803040,%eax
  800315:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  80031b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80031e:	39 c2                	cmp    %eax,%edx
  800320:	74 14                	je     800336 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800322:	83 ec 04             	sub    $0x4,%esp
  800325:	68 88 1e 80 00       	push   $0x801e88
  80032a:	6a 26                	push   $0x26
  80032c:	68 d4 1e 80 00       	push   $0x801ed4
  800331:	e8 5d ff ff ff       	call   800293 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800336:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  80033d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800344:	e9 c5 00 00 00       	jmp    80040e <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  800349:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80034c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800353:	8b 45 08             	mov    0x8(%ebp),%eax
  800356:	01 d0                	add    %edx,%eax
  800358:	8b 00                	mov    (%eax),%eax
  80035a:	85 c0                	test   %eax,%eax
  80035c:	75 08                	jne    800366 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  80035e:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800361:	e9 a5 00 00 00       	jmp    80040b <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  800366:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80036d:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800374:	eb 69                	jmp    8003df <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800376:	a1 40 30 80 00       	mov    0x803040,%eax
  80037b:	8b 88 a4 05 00 00    	mov    0x5a4(%eax),%ecx
  800381:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800384:	89 d0                	mov    %edx,%eax
  800386:	01 c0                	add    %eax,%eax
  800388:	01 d0                	add    %edx,%eax
  80038a:	c1 e0 03             	shl    $0x3,%eax
  80038d:	01 c8                	add    %ecx,%eax
  80038f:	8a 40 04             	mov    0x4(%eax),%al
  800392:	84 c0                	test   %al,%al
  800394:	75 46                	jne    8003dc <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800396:	a1 40 30 80 00       	mov    0x803040,%eax
  80039b:	8b 88 a4 05 00 00    	mov    0x5a4(%eax),%ecx
  8003a1:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8003a4:	89 d0                	mov    %edx,%eax
  8003a6:	01 c0                	add    %eax,%eax
  8003a8:	01 d0                	add    %edx,%eax
  8003aa:	c1 e0 03             	shl    $0x3,%eax
  8003ad:	01 c8                	add    %ecx,%eax
  8003af:	8b 00                	mov    (%eax),%eax
  8003b1:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8003b4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8003b7:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8003bc:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8003be:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003c1:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8003c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8003cb:	01 c8                	add    %ecx,%eax
  8003cd:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8003cf:	39 c2                	cmp    %eax,%edx
  8003d1:	75 09                	jne    8003dc <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  8003d3:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8003da:	eb 15                	jmp    8003f1 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8003dc:	ff 45 e8             	incl   -0x18(%ebp)
  8003df:	a1 40 30 80 00       	mov    0x803040,%eax
  8003e4:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8003ea:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8003ed:	39 c2                	cmp    %eax,%edx
  8003ef:	77 85                	ja     800376 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8003f1:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8003f5:	75 14                	jne    80040b <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  8003f7:	83 ec 04             	sub    $0x4,%esp
  8003fa:	68 e0 1e 80 00       	push   $0x801ee0
  8003ff:	6a 3a                	push   $0x3a
  800401:	68 d4 1e 80 00       	push   $0x801ed4
  800406:	e8 88 fe ff ff       	call   800293 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  80040b:	ff 45 f0             	incl   -0x10(%ebp)
  80040e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800411:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800414:	0f 8c 2f ff ff ff    	jl     800349 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  80041a:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800421:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800428:	eb 26                	jmp    800450 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  80042a:	a1 40 30 80 00       	mov    0x803040,%eax
  80042f:	8b 88 a4 05 00 00    	mov    0x5a4(%eax),%ecx
  800435:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800438:	89 d0                	mov    %edx,%eax
  80043a:	01 c0                	add    %eax,%eax
  80043c:	01 d0                	add    %edx,%eax
  80043e:	c1 e0 03             	shl    $0x3,%eax
  800441:	01 c8                	add    %ecx,%eax
  800443:	8a 40 04             	mov    0x4(%eax),%al
  800446:	3c 01                	cmp    $0x1,%al
  800448:	75 03                	jne    80044d <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  80044a:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80044d:	ff 45 e0             	incl   -0x20(%ebp)
  800450:	a1 40 30 80 00       	mov    0x803040,%eax
  800455:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  80045b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80045e:	39 c2                	cmp    %eax,%edx
  800460:	77 c8                	ja     80042a <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800462:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800465:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800468:	74 14                	je     80047e <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  80046a:	83 ec 04             	sub    $0x4,%esp
  80046d:	68 34 1f 80 00       	push   $0x801f34
  800472:	6a 44                	push   $0x44
  800474:	68 d4 1e 80 00       	push   $0x801ed4
  800479:	e8 15 fe ff ff       	call   800293 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  80047e:	90                   	nop
  80047f:	c9                   	leave  
  800480:	c3                   	ret    

00800481 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  800481:	55                   	push   %ebp
  800482:	89 e5                	mov    %esp,%ebp
  800484:	53                   	push   %ebx
  800485:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  800488:	8b 45 0c             	mov    0xc(%ebp),%eax
  80048b:	8b 00                	mov    (%eax),%eax
  80048d:	8d 48 01             	lea    0x1(%eax),%ecx
  800490:	8b 55 0c             	mov    0xc(%ebp),%edx
  800493:	89 0a                	mov    %ecx,(%edx)
  800495:	8b 55 08             	mov    0x8(%ebp),%edx
  800498:	88 d1                	mov    %dl,%cl
  80049a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80049d:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8004a1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004a4:	8b 00                	mov    (%eax),%eax
  8004a6:	3d ff 00 00 00       	cmp    $0xff,%eax
  8004ab:	75 30                	jne    8004dd <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  8004ad:	8b 15 3c f3 81 00    	mov    0x81f33c,%edx
  8004b3:	a0 64 30 80 00       	mov    0x803064,%al
  8004b8:	0f b6 c0             	movzbl %al,%eax
  8004bb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8004be:	8b 09                	mov    (%ecx),%ecx
  8004c0:	89 cb                	mov    %ecx,%ebx
  8004c2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8004c5:	83 c1 08             	add    $0x8,%ecx
  8004c8:	52                   	push   %edx
  8004c9:	50                   	push   %eax
  8004ca:	53                   	push   %ebx
  8004cb:	51                   	push   %ecx
  8004cc:	e8 a0 0f 00 00       	call   801471 <sys_cputs>
  8004d1:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8004d4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004d7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8004dd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004e0:	8b 40 04             	mov    0x4(%eax),%eax
  8004e3:	8d 50 01             	lea    0x1(%eax),%edx
  8004e6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004e9:	89 50 04             	mov    %edx,0x4(%eax)
}
  8004ec:	90                   	nop
  8004ed:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8004f0:	c9                   	leave  
  8004f1:	c3                   	ret    

008004f2 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8004f2:	55                   	push   %ebp
  8004f3:	89 e5                	mov    %esp,%ebp
  8004f5:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8004fb:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800502:	00 00 00 
	b.cnt = 0;
  800505:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80050c:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  80050f:	ff 75 0c             	pushl  0xc(%ebp)
  800512:	ff 75 08             	pushl  0x8(%ebp)
  800515:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80051b:	50                   	push   %eax
  80051c:	68 81 04 80 00       	push   $0x800481
  800521:	e8 5a 02 00 00       	call   800780 <vprintfmt>
  800526:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  800529:	8b 15 3c f3 81 00    	mov    0x81f33c,%edx
  80052f:	a0 64 30 80 00       	mov    0x803064,%al
  800534:	0f b6 c0             	movzbl %al,%eax
  800537:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  80053d:	52                   	push   %edx
  80053e:	50                   	push   %eax
  80053f:	51                   	push   %ecx
  800540:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800546:	83 c0 08             	add    $0x8,%eax
  800549:	50                   	push   %eax
  80054a:	e8 22 0f 00 00       	call   801471 <sys_cputs>
  80054f:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800552:	c6 05 64 30 80 00 00 	movb   $0x0,0x803064
	return b.cnt;
  800559:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  80055f:	c9                   	leave  
  800560:	c3                   	ret    

00800561 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  800561:	55                   	push   %ebp
  800562:	89 e5                	mov    %esp,%ebp
  800564:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800567:	c6 05 64 30 80 00 01 	movb   $0x1,0x803064
	va_start(ap, fmt);
  80056e:	8d 45 0c             	lea    0xc(%ebp),%eax
  800571:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800574:	8b 45 08             	mov    0x8(%ebp),%eax
  800577:	83 ec 08             	sub    $0x8,%esp
  80057a:	ff 75 f4             	pushl  -0xc(%ebp)
  80057d:	50                   	push   %eax
  80057e:	e8 6f ff ff ff       	call   8004f2 <vcprintf>
  800583:	83 c4 10             	add    $0x10,%esp
  800586:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800589:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80058c:	c9                   	leave  
  80058d:	c3                   	ret    

0080058e <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  80058e:	55                   	push   %ebp
  80058f:	89 e5                	mov    %esp,%ebp
  800591:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800594:	c6 05 64 30 80 00 01 	movb   $0x1,0x803064
	curTextClr = (textClr << 8) ; //set text color by the given value
  80059b:	8b 45 08             	mov    0x8(%ebp),%eax
  80059e:	c1 e0 08             	shl    $0x8,%eax
  8005a1:	a3 3c f3 81 00       	mov    %eax,0x81f33c
	va_start(ap, fmt);
  8005a6:	8d 45 0c             	lea    0xc(%ebp),%eax
  8005a9:	83 c0 04             	add    $0x4,%eax
  8005ac:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8005af:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005b2:	83 ec 08             	sub    $0x8,%esp
  8005b5:	ff 75 f4             	pushl  -0xc(%ebp)
  8005b8:	50                   	push   %eax
  8005b9:	e8 34 ff ff ff       	call   8004f2 <vcprintf>
  8005be:	83 c4 10             	add    $0x10,%esp
  8005c1:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  8005c4:	c7 05 3c f3 81 00 00 	movl   $0x700,0x81f33c
  8005cb:	07 00 00 

	return cnt;
  8005ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8005d1:	c9                   	leave  
  8005d2:	c3                   	ret    

008005d3 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  8005d3:	55                   	push   %ebp
  8005d4:	89 e5                	mov    %esp,%ebp
  8005d6:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  8005d9:	e8 d7 0e 00 00       	call   8014b5 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  8005de:	8d 45 0c             	lea    0xc(%ebp),%eax
  8005e1:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  8005e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8005e7:	83 ec 08             	sub    $0x8,%esp
  8005ea:	ff 75 f4             	pushl  -0xc(%ebp)
  8005ed:	50                   	push   %eax
  8005ee:	e8 ff fe ff ff       	call   8004f2 <vcprintf>
  8005f3:	83 c4 10             	add    $0x10,%esp
  8005f6:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  8005f9:	e8 d1 0e 00 00       	call   8014cf <sys_unlock_cons>
	return cnt;
  8005fe:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800601:	c9                   	leave  
  800602:	c3                   	ret    

00800603 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800603:	55                   	push   %ebp
  800604:	89 e5                	mov    %esp,%ebp
  800606:	53                   	push   %ebx
  800607:	83 ec 14             	sub    $0x14,%esp
  80060a:	8b 45 10             	mov    0x10(%ebp),%eax
  80060d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800610:	8b 45 14             	mov    0x14(%ebp),%eax
  800613:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800616:	8b 45 18             	mov    0x18(%ebp),%eax
  800619:	ba 00 00 00 00       	mov    $0x0,%edx
  80061e:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800621:	77 55                	ja     800678 <printnum+0x75>
  800623:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800626:	72 05                	jb     80062d <printnum+0x2a>
  800628:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80062b:	77 4b                	ja     800678 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80062d:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800630:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800633:	8b 45 18             	mov    0x18(%ebp),%eax
  800636:	ba 00 00 00 00       	mov    $0x0,%edx
  80063b:	52                   	push   %edx
  80063c:	50                   	push   %eax
  80063d:	ff 75 f4             	pushl  -0xc(%ebp)
  800640:	ff 75 f0             	pushl  -0x10(%ebp)
  800643:	e8 ac 13 00 00       	call   8019f4 <__udivdi3>
  800648:	83 c4 10             	add    $0x10,%esp
  80064b:	83 ec 04             	sub    $0x4,%esp
  80064e:	ff 75 20             	pushl  0x20(%ebp)
  800651:	53                   	push   %ebx
  800652:	ff 75 18             	pushl  0x18(%ebp)
  800655:	52                   	push   %edx
  800656:	50                   	push   %eax
  800657:	ff 75 0c             	pushl  0xc(%ebp)
  80065a:	ff 75 08             	pushl  0x8(%ebp)
  80065d:	e8 a1 ff ff ff       	call   800603 <printnum>
  800662:	83 c4 20             	add    $0x20,%esp
  800665:	eb 1a                	jmp    800681 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800667:	83 ec 08             	sub    $0x8,%esp
  80066a:	ff 75 0c             	pushl  0xc(%ebp)
  80066d:	ff 75 20             	pushl  0x20(%ebp)
  800670:	8b 45 08             	mov    0x8(%ebp),%eax
  800673:	ff d0                	call   *%eax
  800675:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800678:	ff 4d 1c             	decl   0x1c(%ebp)
  80067b:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  80067f:	7f e6                	jg     800667 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800681:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800684:	bb 00 00 00 00       	mov    $0x0,%ebx
  800689:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80068c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80068f:	53                   	push   %ebx
  800690:	51                   	push   %ecx
  800691:	52                   	push   %edx
  800692:	50                   	push   %eax
  800693:	e8 6c 14 00 00       	call   801b04 <__umoddi3>
  800698:	83 c4 10             	add    $0x10,%esp
  80069b:	05 94 21 80 00       	add    $0x802194,%eax
  8006a0:	8a 00                	mov    (%eax),%al
  8006a2:	0f be c0             	movsbl %al,%eax
  8006a5:	83 ec 08             	sub    $0x8,%esp
  8006a8:	ff 75 0c             	pushl  0xc(%ebp)
  8006ab:	50                   	push   %eax
  8006ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8006af:	ff d0                	call   *%eax
  8006b1:	83 c4 10             	add    $0x10,%esp
}
  8006b4:	90                   	nop
  8006b5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8006b8:	c9                   	leave  
  8006b9:	c3                   	ret    

008006ba <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8006ba:	55                   	push   %ebp
  8006bb:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8006bd:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8006c1:	7e 1c                	jle    8006df <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8006c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8006c6:	8b 00                	mov    (%eax),%eax
  8006c8:	8d 50 08             	lea    0x8(%eax),%edx
  8006cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ce:	89 10                	mov    %edx,(%eax)
  8006d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8006d3:	8b 00                	mov    (%eax),%eax
  8006d5:	83 e8 08             	sub    $0x8,%eax
  8006d8:	8b 50 04             	mov    0x4(%eax),%edx
  8006db:	8b 00                	mov    (%eax),%eax
  8006dd:	eb 40                	jmp    80071f <getuint+0x65>
	else if (lflag)
  8006df:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8006e3:	74 1e                	je     800703 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8006e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8006e8:	8b 00                	mov    (%eax),%eax
  8006ea:	8d 50 04             	lea    0x4(%eax),%edx
  8006ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8006f0:	89 10                	mov    %edx,(%eax)
  8006f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8006f5:	8b 00                	mov    (%eax),%eax
  8006f7:	83 e8 04             	sub    $0x4,%eax
  8006fa:	8b 00                	mov    (%eax),%eax
  8006fc:	ba 00 00 00 00       	mov    $0x0,%edx
  800701:	eb 1c                	jmp    80071f <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800703:	8b 45 08             	mov    0x8(%ebp),%eax
  800706:	8b 00                	mov    (%eax),%eax
  800708:	8d 50 04             	lea    0x4(%eax),%edx
  80070b:	8b 45 08             	mov    0x8(%ebp),%eax
  80070e:	89 10                	mov    %edx,(%eax)
  800710:	8b 45 08             	mov    0x8(%ebp),%eax
  800713:	8b 00                	mov    (%eax),%eax
  800715:	83 e8 04             	sub    $0x4,%eax
  800718:	8b 00                	mov    (%eax),%eax
  80071a:	ba 00 00 00 00       	mov    $0x0,%edx
}
  80071f:	5d                   	pop    %ebp
  800720:	c3                   	ret    

00800721 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800721:	55                   	push   %ebp
  800722:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800724:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800728:	7e 1c                	jle    800746 <getint+0x25>
		return va_arg(*ap, long long);
  80072a:	8b 45 08             	mov    0x8(%ebp),%eax
  80072d:	8b 00                	mov    (%eax),%eax
  80072f:	8d 50 08             	lea    0x8(%eax),%edx
  800732:	8b 45 08             	mov    0x8(%ebp),%eax
  800735:	89 10                	mov    %edx,(%eax)
  800737:	8b 45 08             	mov    0x8(%ebp),%eax
  80073a:	8b 00                	mov    (%eax),%eax
  80073c:	83 e8 08             	sub    $0x8,%eax
  80073f:	8b 50 04             	mov    0x4(%eax),%edx
  800742:	8b 00                	mov    (%eax),%eax
  800744:	eb 38                	jmp    80077e <getint+0x5d>
	else if (lflag)
  800746:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80074a:	74 1a                	je     800766 <getint+0x45>
		return va_arg(*ap, long);
  80074c:	8b 45 08             	mov    0x8(%ebp),%eax
  80074f:	8b 00                	mov    (%eax),%eax
  800751:	8d 50 04             	lea    0x4(%eax),%edx
  800754:	8b 45 08             	mov    0x8(%ebp),%eax
  800757:	89 10                	mov    %edx,(%eax)
  800759:	8b 45 08             	mov    0x8(%ebp),%eax
  80075c:	8b 00                	mov    (%eax),%eax
  80075e:	83 e8 04             	sub    $0x4,%eax
  800761:	8b 00                	mov    (%eax),%eax
  800763:	99                   	cltd   
  800764:	eb 18                	jmp    80077e <getint+0x5d>
	else
		return va_arg(*ap, int);
  800766:	8b 45 08             	mov    0x8(%ebp),%eax
  800769:	8b 00                	mov    (%eax),%eax
  80076b:	8d 50 04             	lea    0x4(%eax),%edx
  80076e:	8b 45 08             	mov    0x8(%ebp),%eax
  800771:	89 10                	mov    %edx,(%eax)
  800773:	8b 45 08             	mov    0x8(%ebp),%eax
  800776:	8b 00                	mov    (%eax),%eax
  800778:	83 e8 04             	sub    $0x4,%eax
  80077b:	8b 00                	mov    (%eax),%eax
  80077d:	99                   	cltd   
}
  80077e:	5d                   	pop    %ebp
  80077f:	c3                   	ret    

00800780 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800780:	55                   	push   %ebp
  800781:	89 e5                	mov    %esp,%ebp
  800783:	56                   	push   %esi
  800784:	53                   	push   %ebx
  800785:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800788:	eb 17                	jmp    8007a1 <vprintfmt+0x21>
			if (ch == '\0')
  80078a:	85 db                	test   %ebx,%ebx
  80078c:	0f 84 c1 03 00 00    	je     800b53 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  800792:	83 ec 08             	sub    $0x8,%esp
  800795:	ff 75 0c             	pushl  0xc(%ebp)
  800798:	53                   	push   %ebx
  800799:	8b 45 08             	mov    0x8(%ebp),%eax
  80079c:	ff d0                	call   *%eax
  80079e:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8007a1:	8b 45 10             	mov    0x10(%ebp),%eax
  8007a4:	8d 50 01             	lea    0x1(%eax),%edx
  8007a7:	89 55 10             	mov    %edx,0x10(%ebp)
  8007aa:	8a 00                	mov    (%eax),%al
  8007ac:	0f b6 d8             	movzbl %al,%ebx
  8007af:	83 fb 25             	cmp    $0x25,%ebx
  8007b2:	75 d6                	jne    80078a <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8007b4:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  8007b8:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  8007bf:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8007c6:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8007cd:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8007d4:	8b 45 10             	mov    0x10(%ebp),%eax
  8007d7:	8d 50 01             	lea    0x1(%eax),%edx
  8007da:	89 55 10             	mov    %edx,0x10(%ebp)
  8007dd:	8a 00                	mov    (%eax),%al
  8007df:	0f b6 d8             	movzbl %al,%ebx
  8007e2:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8007e5:	83 f8 5b             	cmp    $0x5b,%eax
  8007e8:	0f 87 3d 03 00 00    	ja     800b2b <vprintfmt+0x3ab>
  8007ee:	8b 04 85 b8 21 80 00 	mov    0x8021b8(,%eax,4),%eax
  8007f5:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8007f7:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8007fb:	eb d7                	jmp    8007d4 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8007fd:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800801:	eb d1                	jmp    8007d4 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800803:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  80080a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80080d:	89 d0                	mov    %edx,%eax
  80080f:	c1 e0 02             	shl    $0x2,%eax
  800812:	01 d0                	add    %edx,%eax
  800814:	01 c0                	add    %eax,%eax
  800816:	01 d8                	add    %ebx,%eax
  800818:	83 e8 30             	sub    $0x30,%eax
  80081b:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  80081e:	8b 45 10             	mov    0x10(%ebp),%eax
  800821:	8a 00                	mov    (%eax),%al
  800823:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800826:	83 fb 2f             	cmp    $0x2f,%ebx
  800829:	7e 3e                	jle    800869 <vprintfmt+0xe9>
  80082b:	83 fb 39             	cmp    $0x39,%ebx
  80082e:	7f 39                	jg     800869 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800830:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800833:	eb d5                	jmp    80080a <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800835:	8b 45 14             	mov    0x14(%ebp),%eax
  800838:	83 c0 04             	add    $0x4,%eax
  80083b:	89 45 14             	mov    %eax,0x14(%ebp)
  80083e:	8b 45 14             	mov    0x14(%ebp),%eax
  800841:	83 e8 04             	sub    $0x4,%eax
  800844:	8b 00                	mov    (%eax),%eax
  800846:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800849:	eb 1f                	jmp    80086a <vprintfmt+0xea>

		case '.':
			if (width < 0)
  80084b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80084f:	79 83                	jns    8007d4 <vprintfmt+0x54>
				width = 0;
  800851:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800858:	e9 77 ff ff ff       	jmp    8007d4 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  80085d:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800864:	e9 6b ff ff ff       	jmp    8007d4 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800869:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  80086a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80086e:	0f 89 60 ff ff ff    	jns    8007d4 <vprintfmt+0x54>
				width = precision, precision = -1;
  800874:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800877:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80087a:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800881:	e9 4e ff ff ff       	jmp    8007d4 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800886:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800889:	e9 46 ff ff ff       	jmp    8007d4 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  80088e:	8b 45 14             	mov    0x14(%ebp),%eax
  800891:	83 c0 04             	add    $0x4,%eax
  800894:	89 45 14             	mov    %eax,0x14(%ebp)
  800897:	8b 45 14             	mov    0x14(%ebp),%eax
  80089a:	83 e8 04             	sub    $0x4,%eax
  80089d:	8b 00                	mov    (%eax),%eax
  80089f:	83 ec 08             	sub    $0x8,%esp
  8008a2:	ff 75 0c             	pushl  0xc(%ebp)
  8008a5:	50                   	push   %eax
  8008a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8008a9:	ff d0                	call   *%eax
  8008ab:	83 c4 10             	add    $0x10,%esp
			break;
  8008ae:	e9 9b 02 00 00       	jmp    800b4e <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8008b3:	8b 45 14             	mov    0x14(%ebp),%eax
  8008b6:	83 c0 04             	add    $0x4,%eax
  8008b9:	89 45 14             	mov    %eax,0x14(%ebp)
  8008bc:	8b 45 14             	mov    0x14(%ebp),%eax
  8008bf:	83 e8 04             	sub    $0x4,%eax
  8008c2:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  8008c4:	85 db                	test   %ebx,%ebx
  8008c6:	79 02                	jns    8008ca <vprintfmt+0x14a>
				err = -err;
  8008c8:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  8008ca:	83 fb 64             	cmp    $0x64,%ebx
  8008cd:	7f 0b                	jg     8008da <vprintfmt+0x15a>
  8008cf:	8b 34 9d 00 20 80 00 	mov    0x802000(,%ebx,4),%esi
  8008d6:	85 f6                	test   %esi,%esi
  8008d8:	75 19                	jne    8008f3 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8008da:	53                   	push   %ebx
  8008db:	68 a5 21 80 00       	push   $0x8021a5
  8008e0:	ff 75 0c             	pushl  0xc(%ebp)
  8008e3:	ff 75 08             	pushl  0x8(%ebp)
  8008e6:	e8 70 02 00 00       	call   800b5b <printfmt>
  8008eb:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8008ee:	e9 5b 02 00 00       	jmp    800b4e <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8008f3:	56                   	push   %esi
  8008f4:	68 ae 21 80 00       	push   $0x8021ae
  8008f9:	ff 75 0c             	pushl  0xc(%ebp)
  8008fc:	ff 75 08             	pushl  0x8(%ebp)
  8008ff:	e8 57 02 00 00       	call   800b5b <printfmt>
  800904:	83 c4 10             	add    $0x10,%esp
			break;
  800907:	e9 42 02 00 00       	jmp    800b4e <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  80090c:	8b 45 14             	mov    0x14(%ebp),%eax
  80090f:	83 c0 04             	add    $0x4,%eax
  800912:	89 45 14             	mov    %eax,0x14(%ebp)
  800915:	8b 45 14             	mov    0x14(%ebp),%eax
  800918:	83 e8 04             	sub    $0x4,%eax
  80091b:	8b 30                	mov    (%eax),%esi
  80091d:	85 f6                	test   %esi,%esi
  80091f:	75 05                	jne    800926 <vprintfmt+0x1a6>
				p = "(null)";
  800921:	be b1 21 80 00       	mov    $0x8021b1,%esi
			if (width > 0 && padc != '-')
  800926:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80092a:	7e 6d                	jle    800999 <vprintfmt+0x219>
  80092c:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800930:	74 67                	je     800999 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800932:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800935:	83 ec 08             	sub    $0x8,%esp
  800938:	50                   	push   %eax
  800939:	56                   	push   %esi
  80093a:	e8 1e 03 00 00       	call   800c5d <strnlen>
  80093f:	83 c4 10             	add    $0x10,%esp
  800942:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800945:	eb 16                	jmp    80095d <vprintfmt+0x1dd>
					putch(padc, putdat);
  800947:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  80094b:	83 ec 08             	sub    $0x8,%esp
  80094e:	ff 75 0c             	pushl  0xc(%ebp)
  800951:	50                   	push   %eax
  800952:	8b 45 08             	mov    0x8(%ebp),%eax
  800955:	ff d0                	call   *%eax
  800957:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80095a:	ff 4d e4             	decl   -0x1c(%ebp)
  80095d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800961:	7f e4                	jg     800947 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800963:	eb 34                	jmp    800999 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800965:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800969:	74 1c                	je     800987 <vprintfmt+0x207>
  80096b:	83 fb 1f             	cmp    $0x1f,%ebx
  80096e:	7e 05                	jle    800975 <vprintfmt+0x1f5>
  800970:	83 fb 7e             	cmp    $0x7e,%ebx
  800973:	7e 12                	jle    800987 <vprintfmt+0x207>
					putch('?', putdat);
  800975:	83 ec 08             	sub    $0x8,%esp
  800978:	ff 75 0c             	pushl  0xc(%ebp)
  80097b:	6a 3f                	push   $0x3f
  80097d:	8b 45 08             	mov    0x8(%ebp),%eax
  800980:	ff d0                	call   *%eax
  800982:	83 c4 10             	add    $0x10,%esp
  800985:	eb 0f                	jmp    800996 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800987:	83 ec 08             	sub    $0x8,%esp
  80098a:	ff 75 0c             	pushl  0xc(%ebp)
  80098d:	53                   	push   %ebx
  80098e:	8b 45 08             	mov    0x8(%ebp),%eax
  800991:	ff d0                	call   *%eax
  800993:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800996:	ff 4d e4             	decl   -0x1c(%ebp)
  800999:	89 f0                	mov    %esi,%eax
  80099b:	8d 70 01             	lea    0x1(%eax),%esi
  80099e:	8a 00                	mov    (%eax),%al
  8009a0:	0f be d8             	movsbl %al,%ebx
  8009a3:	85 db                	test   %ebx,%ebx
  8009a5:	74 24                	je     8009cb <vprintfmt+0x24b>
  8009a7:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8009ab:	78 b8                	js     800965 <vprintfmt+0x1e5>
  8009ad:	ff 4d e0             	decl   -0x20(%ebp)
  8009b0:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8009b4:	79 af                	jns    800965 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8009b6:	eb 13                	jmp    8009cb <vprintfmt+0x24b>
				putch(' ', putdat);
  8009b8:	83 ec 08             	sub    $0x8,%esp
  8009bb:	ff 75 0c             	pushl  0xc(%ebp)
  8009be:	6a 20                	push   $0x20
  8009c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8009c3:	ff d0                	call   *%eax
  8009c5:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8009c8:	ff 4d e4             	decl   -0x1c(%ebp)
  8009cb:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8009cf:	7f e7                	jg     8009b8 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  8009d1:	e9 78 01 00 00       	jmp    800b4e <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  8009d6:	83 ec 08             	sub    $0x8,%esp
  8009d9:	ff 75 e8             	pushl  -0x18(%ebp)
  8009dc:	8d 45 14             	lea    0x14(%ebp),%eax
  8009df:	50                   	push   %eax
  8009e0:	e8 3c fd ff ff       	call   800721 <getint>
  8009e5:	83 c4 10             	add    $0x10,%esp
  8009e8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009eb:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  8009ee:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009f1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8009f4:	85 d2                	test   %edx,%edx
  8009f6:	79 23                	jns    800a1b <vprintfmt+0x29b>
				putch('-', putdat);
  8009f8:	83 ec 08             	sub    $0x8,%esp
  8009fb:	ff 75 0c             	pushl  0xc(%ebp)
  8009fe:	6a 2d                	push   $0x2d
  800a00:	8b 45 08             	mov    0x8(%ebp),%eax
  800a03:	ff d0                	call   *%eax
  800a05:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800a08:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a0b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a0e:	f7 d8                	neg    %eax
  800a10:	83 d2 00             	adc    $0x0,%edx
  800a13:	f7 da                	neg    %edx
  800a15:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a18:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800a1b:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800a22:	e9 bc 00 00 00       	jmp    800ae3 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800a27:	83 ec 08             	sub    $0x8,%esp
  800a2a:	ff 75 e8             	pushl  -0x18(%ebp)
  800a2d:	8d 45 14             	lea    0x14(%ebp),%eax
  800a30:	50                   	push   %eax
  800a31:	e8 84 fc ff ff       	call   8006ba <getuint>
  800a36:	83 c4 10             	add    $0x10,%esp
  800a39:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a3c:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800a3f:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800a46:	e9 98 00 00 00       	jmp    800ae3 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800a4b:	83 ec 08             	sub    $0x8,%esp
  800a4e:	ff 75 0c             	pushl  0xc(%ebp)
  800a51:	6a 58                	push   $0x58
  800a53:	8b 45 08             	mov    0x8(%ebp),%eax
  800a56:	ff d0                	call   *%eax
  800a58:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800a5b:	83 ec 08             	sub    $0x8,%esp
  800a5e:	ff 75 0c             	pushl  0xc(%ebp)
  800a61:	6a 58                	push   $0x58
  800a63:	8b 45 08             	mov    0x8(%ebp),%eax
  800a66:	ff d0                	call   *%eax
  800a68:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800a6b:	83 ec 08             	sub    $0x8,%esp
  800a6e:	ff 75 0c             	pushl  0xc(%ebp)
  800a71:	6a 58                	push   $0x58
  800a73:	8b 45 08             	mov    0x8(%ebp),%eax
  800a76:	ff d0                	call   *%eax
  800a78:	83 c4 10             	add    $0x10,%esp
			break;
  800a7b:	e9 ce 00 00 00       	jmp    800b4e <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800a80:	83 ec 08             	sub    $0x8,%esp
  800a83:	ff 75 0c             	pushl  0xc(%ebp)
  800a86:	6a 30                	push   $0x30
  800a88:	8b 45 08             	mov    0x8(%ebp),%eax
  800a8b:	ff d0                	call   *%eax
  800a8d:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800a90:	83 ec 08             	sub    $0x8,%esp
  800a93:	ff 75 0c             	pushl  0xc(%ebp)
  800a96:	6a 78                	push   $0x78
  800a98:	8b 45 08             	mov    0x8(%ebp),%eax
  800a9b:	ff d0                	call   *%eax
  800a9d:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800aa0:	8b 45 14             	mov    0x14(%ebp),%eax
  800aa3:	83 c0 04             	add    $0x4,%eax
  800aa6:	89 45 14             	mov    %eax,0x14(%ebp)
  800aa9:	8b 45 14             	mov    0x14(%ebp),%eax
  800aac:	83 e8 04             	sub    $0x4,%eax
  800aaf:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800ab1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ab4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800abb:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800ac2:	eb 1f                	jmp    800ae3 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800ac4:	83 ec 08             	sub    $0x8,%esp
  800ac7:	ff 75 e8             	pushl  -0x18(%ebp)
  800aca:	8d 45 14             	lea    0x14(%ebp),%eax
  800acd:	50                   	push   %eax
  800ace:	e8 e7 fb ff ff       	call   8006ba <getuint>
  800ad3:	83 c4 10             	add    $0x10,%esp
  800ad6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ad9:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800adc:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800ae3:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800ae7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800aea:	83 ec 04             	sub    $0x4,%esp
  800aed:	52                   	push   %edx
  800aee:	ff 75 e4             	pushl  -0x1c(%ebp)
  800af1:	50                   	push   %eax
  800af2:	ff 75 f4             	pushl  -0xc(%ebp)
  800af5:	ff 75 f0             	pushl  -0x10(%ebp)
  800af8:	ff 75 0c             	pushl  0xc(%ebp)
  800afb:	ff 75 08             	pushl  0x8(%ebp)
  800afe:	e8 00 fb ff ff       	call   800603 <printnum>
  800b03:	83 c4 20             	add    $0x20,%esp
			break;
  800b06:	eb 46                	jmp    800b4e <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800b08:	83 ec 08             	sub    $0x8,%esp
  800b0b:	ff 75 0c             	pushl  0xc(%ebp)
  800b0e:	53                   	push   %ebx
  800b0f:	8b 45 08             	mov    0x8(%ebp),%eax
  800b12:	ff d0                	call   *%eax
  800b14:	83 c4 10             	add    $0x10,%esp
			break;
  800b17:	eb 35                	jmp    800b4e <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800b19:	c6 05 64 30 80 00 00 	movb   $0x0,0x803064
			break;
  800b20:	eb 2c                	jmp    800b4e <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800b22:	c6 05 64 30 80 00 01 	movb   $0x1,0x803064
			break;
  800b29:	eb 23                	jmp    800b4e <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800b2b:	83 ec 08             	sub    $0x8,%esp
  800b2e:	ff 75 0c             	pushl  0xc(%ebp)
  800b31:	6a 25                	push   $0x25
  800b33:	8b 45 08             	mov    0x8(%ebp),%eax
  800b36:	ff d0                	call   *%eax
  800b38:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800b3b:	ff 4d 10             	decl   0x10(%ebp)
  800b3e:	eb 03                	jmp    800b43 <vprintfmt+0x3c3>
  800b40:	ff 4d 10             	decl   0x10(%ebp)
  800b43:	8b 45 10             	mov    0x10(%ebp),%eax
  800b46:	48                   	dec    %eax
  800b47:	8a 00                	mov    (%eax),%al
  800b49:	3c 25                	cmp    $0x25,%al
  800b4b:	75 f3                	jne    800b40 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800b4d:	90                   	nop
		}
	}
  800b4e:	e9 35 fc ff ff       	jmp    800788 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800b53:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800b54:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800b57:	5b                   	pop    %ebx
  800b58:	5e                   	pop    %esi
  800b59:	5d                   	pop    %ebp
  800b5a:	c3                   	ret    

00800b5b <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800b5b:	55                   	push   %ebp
  800b5c:	89 e5                	mov    %esp,%ebp
  800b5e:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800b61:	8d 45 10             	lea    0x10(%ebp),%eax
  800b64:	83 c0 04             	add    $0x4,%eax
  800b67:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800b6a:	8b 45 10             	mov    0x10(%ebp),%eax
  800b6d:	ff 75 f4             	pushl  -0xc(%ebp)
  800b70:	50                   	push   %eax
  800b71:	ff 75 0c             	pushl  0xc(%ebp)
  800b74:	ff 75 08             	pushl  0x8(%ebp)
  800b77:	e8 04 fc ff ff       	call   800780 <vprintfmt>
  800b7c:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800b7f:	90                   	nop
  800b80:	c9                   	leave  
  800b81:	c3                   	ret    

00800b82 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800b82:	55                   	push   %ebp
  800b83:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800b85:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b88:	8b 40 08             	mov    0x8(%eax),%eax
  800b8b:	8d 50 01             	lea    0x1(%eax),%edx
  800b8e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b91:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800b94:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b97:	8b 10                	mov    (%eax),%edx
  800b99:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b9c:	8b 40 04             	mov    0x4(%eax),%eax
  800b9f:	39 c2                	cmp    %eax,%edx
  800ba1:	73 12                	jae    800bb5 <sprintputch+0x33>
		*b->buf++ = ch;
  800ba3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ba6:	8b 00                	mov    (%eax),%eax
  800ba8:	8d 48 01             	lea    0x1(%eax),%ecx
  800bab:	8b 55 0c             	mov    0xc(%ebp),%edx
  800bae:	89 0a                	mov    %ecx,(%edx)
  800bb0:	8b 55 08             	mov    0x8(%ebp),%edx
  800bb3:	88 10                	mov    %dl,(%eax)
}
  800bb5:	90                   	nop
  800bb6:	5d                   	pop    %ebp
  800bb7:	c3                   	ret    

00800bb8 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800bb8:	55                   	push   %ebp
  800bb9:	89 e5                	mov    %esp,%ebp
  800bbb:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800bbe:	8b 45 08             	mov    0x8(%ebp),%eax
  800bc1:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800bc4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bc7:	8d 50 ff             	lea    -0x1(%eax),%edx
  800bca:	8b 45 08             	mov    0x8(%ebp),%eax
  800bcd:	01 d0                	add    %edx,%eax
  800bcf:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bd2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800bd9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800bdd:	74 06                	je     800be5 <vsnprintf+0x2d>
  800bdf:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800be3:	7f 07                	jg     800bec <vsnprintf+0x34>
		return -E_INVAL;
  800be5:	b8 03 00 00 00       	mov    $0x3,%eax
  800bea:	eb 20                	jmp    800c0c <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800bec:	ff 75 14             	pushl  0x14(%ebp)
  800bef:	ff 75 10             	pushl  0x10(%ebp)
  800bf2:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800bf5:	50                   	push   %eax
  800bf6:	68 82 0b 80 00       	push   $0x800b82
  800bfb:	e8 80 fb ff ff       	call   800780 <vprintfmt>
  800c00:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800c03:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800c06:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800c09:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800c0c:	c9                   	leave  
  800c0d:	c3                   	ret    

00800c0e <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800c0e:	55                   	push   %ebp
  800c0f:	89 e5                	mov    %esp,%ebp
  800c11:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800c14:	8d 45 10             	lea    0x10(%ebp),%eax
  800c17:	83 c0 04             	add    $0x4,%eax
  800c1a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800c1d:	8b 45 10             	mov    0x10(%ebp),%eax
  800c20:	ff 75 f4             	pushl  -0xc(%ebp)
  800c23:	50                   	push   %eax
  800c24:	ff 75 0c             	pushl  0xc(%ebp)
  800c27:	ff 75 08             	pushl  0x8(%ebp)
  800c2a:	e8 89 ff ff ff       	call   800bb8 <vsnprintf>
  800c2f:	83 c4 10             	add    $0x10,%esp
  800c32:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800c35:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800c38:	c9                   	leave  
  800c39:	c3                   	ret    

00800c3a <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800c3a:	55                   	push   %ebp
  800c3b:	89 e5                	mov    %esp,%ebp
  800c3d:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800c40:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c47:	eb 06                	jmp    800c4f <strlen+0x15>
		n++;
  800c49:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800c4c:	ff 45 08             	incl   0x8(%ebp)
  800c4f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c52:	8a 00                	mov    (%eax),%al
  800c54:	84 c0                	test   %al,%al
  800c56:	75 f1                	jne    800c49 <strlen+0xf>
		n++;
	return n;
  800c58:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c5b:	c9                   	leave  
  800c5c:	c3                   	ret    

00800c5d <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800c5d:	55                   	push   %ebp
  800c5e:	89 e5                	mov    %esp,%ebp
  800c60:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c63:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c6a:	eb 09                	jmp    800c75 <strnlen+0x18>
		n++;
  800c6c:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c6f:	ff 45 08             	incl   0x8(%ebp)
  800c72:	ff 4d 0c             	decl   0xc(%ebp)
  800c75:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c79:	74 09                	je     800c84 <strnlen+0x27>
  800c7b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c7e:	8a 00                	mov    (%eax),%al
  800c80:	84 c0                	test   %al,%al
  800c82:	75 e8                	jne    800c6c <strnlen+0xf>
		n++;
	return n;
  800c84:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c87:	c9                   	leave  
  800c88:	c3                   	ret    

00800c89 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800c89:	55                   	push   %ebp
  800c8a:	89 e5                	mov    %esp,%ebp
  800c8c:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800c8f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c92:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800c95:	90                   	nop
  800c96:	8b 45 08             	mov    0x8(%ebp),%eax
  800c99:	8d 50 01             	lea    0x1(%eax),%edx
  800c9c:	89 55 08             	mov    %edx,0x8(%ebp)
  800c9f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ca2:	8d 4a 01             	lea    0x1(%edx),%ecx
  800ca5:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800ca8:	8a 12                	mov    (%edx),%dl
  800caa:	88 10                	mov    %dl,(%eax)
  800cac:	8a 00                	mov    (%eax),%al
  800cae:	84 c0                	test   %al,%al
  800cb0:	75 e4                	jne    800c96 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800cb2:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800cb5:	c9                   	leave  
  800cb6:	c3                   	ret    

00800cb7 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800cb7:	55                   	push   %ebp
  800cb8:	89 e5                	mov    %esp,%ebp
  800cba:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800cbd:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc0:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800cc3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800cca:	eb 1f                	jmp    800ceb <strncpy+0x34>
		*dst++ = *src;
  800ccc:	8b 45 08             	mov    0x8(%ebp),%eax
  800ccf:	8d 50 01             	lea    0x1(%eax),%edx
  800cd2:	89 55 08             	mov    %edx,0x8(%ebp)
  800cd5:	8b 55 0c             	mov    0xc(%ebp),%edx
  800cd8:	8a 12                	mov    (%edx),%dl
  800cda:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800cdc:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cdf:	8a 00                	mov    (%eax),%al
  800ce1:	84 c0                	test   %al,%al
  800ce3:	74 03                	je     800ce8 <strncpy+0x31>
			src++;
  800ce5:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800ce8:	ff 45 fc             	incl   -0x4(%ebp)
  800ceb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800cee:	3b 45 10             	cmp    0x10(%ebp),%eax
  800cf1:	72 d9                	jb     800ccc <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800cf3:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800cf6:	c9                   	leave  
  800cf7:	c3                   	ret    

00800cf8 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800cf8:	55                   	push   %ebp
  800cf9:	89 e5                	mov    %esp,%ebp
  800cfb:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800cfe:	8b 45 08             	mov    0x8(%ebp),%eax
  800d01:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800d04:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d08:	74 30                	je     800d3a <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800d0a:	eb 16                	jmp    800d22 <strlcpy+0x2a>
			*dst++ = *src++;
  800d0c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d0f:	8d 50 01             	lea    0x1(%eax),%edx
  800d12:	89 55 08             	mov    %edx,0x8(%ebp)
  800d15:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d18:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d1b:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800d1e:	8a 12                	mov    (%edx),%dl
  800d20:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800d22:	ff 4d 10             	decl   0x10(%ebp)
  800d25:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d29:	74 09                	je     800d34 <strlcpy+0x3c>
  800d2b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d2e:	8a 00                	mov    (%eax),%al
  800d30:	84 c0                	test   %al,%al
  800d32:	75 d8                	jne    800d0c <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800d34:	8b 45 08             	mov    0x8(%ebp),%eax
  800d37:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800d3a:	8b 55 08             	mov    0x8(%ebp),%edx
  800d3d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d40:	29 c2                	sub    %eax,%edx
  800d42:	89 d0                	mov    %edx,%eax
}
  800d44:	c9                   	leave  
  800d45:	c3                   	ret    

00800d46 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800d46:	55                   	push   %ebp
  800d47:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800d49:	eb 06                	jmp    800d51 <strcmp+0xb>
		p++, q++;
  800d4b:	ff 45 08             	incl   0x8(%ebp)
  800d4e:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800d51:	8b 45 08             	mov    0x8(%ebp),%eax
  800d54:	8a 00                	mov    (%eax),%al
  800d56:	84 c0                	test   %al,%al
  800d58:	74 0e                	je     800d68 <strcmp+0x22>
  800d5a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d5d:	8a 10                	mov    (%eax),%dl
  800d5f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d62:	8a 00                	mov    (%eax),%al
  800d64:	38 c2                	cmp    %al,%dl
  800d66:	74 e3                	je     800d4b <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800d68:	8b 45 08             	mov    0x8(%ebp),%eax
  800d6b:	8a 00                	mov    (%eax),%al
  800d6d:	0f b6 d0             	movzbl %al,%edx
  800d70:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d73:	8a 00                	mov    (%eax),%al
  800d75:	0f b6 c0             	movzbl %al,%eax
  800d78:	29 c2                	sub    %eax,%edx
  800d7a:	89 d0                	mov    %edx,%eax
}
  800d7c:	5d                   	pop    %ebp
  800d7d:	c3                   	ret    

00800d7e <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800d7e:	55                   	push   %ebp
  800d7f:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800d81:	eb 09                	jmp    800d8c <strncmp+0xe>
		n--, p++, q++;
  800d83:	ff 4d 10             	decl   0x10(%ebp)
  800d86:	ff 45 08             	incl   0x8(%ebp)
  800d89:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800d8c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d90:	74 17                	je     800da9 <strncmp+0x2b>
  800d92:	8b 45 08             	mov    0x8(%ebp),%eax
  800d95:	8a 00                	mov    (%eax),%al
  800d97:	84 c0                	test   %al,%al
  800d99:	74 0e                	je     800da9 <strncmp+0x2b>
  800d9b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d9e:	8a 10                	mov    (%eax),%dl
  800da0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800da3:	8a 00                	mov    (%eax),%al
  800da5:	38 c2                	cmp    %al,%dl
  800da7:	74 da                	je     800d83 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800da9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800dad:	75 07                	jne    800db6 <strncmp+0x38>
		return 0;
  800daf:	b8 00 00 00 00       	mov    $0x0,%eax
  800db4:	eb 14                	jmp    800dca <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800db6:	8b 45 08             	mov    0x8(%ebp),%eax
  800db9:	8a 00                	mov    (%eax),%al
  800dbb:	0f b6 d0             	movzbl %al,%edx
  800dbe:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dc1:	8a 00                	mov    (%eax),%al
  800dc3:	0f b6 c0             	movzbl %al,%eax
  800dc6:	29 c2                	sub    %eax,%edx
  800dc8:	89 d0                	mov    %edx,%eax
}
  800dca:	5d                   	pop    %ebp
  800dcb:	c3                   	ret    

00800dcc <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800dcc:	55                   	push   %ebp
  800dcd:	89 e5                	mov    %esp,%ebp
  800dcf:	83 ec 04             	sub    $0x4,%esp
  800dd2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dd5:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800dd8:	eb 12                	jmp    800dec <strchr+0x20>
		if (*s == c)
  800dda:	8b 45 08             	mov    0x8(%ebp),%eax
  800ddd:	8a 00                	mov    (%eax),%al
  800ddf:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800de2:	75 05                	jne    800de9 <strchr+0x1d>
			return (char *) s;
  800de4:	8b 45 08             	mov    0x8(%ebp),%eax
  800de7:	eb 11                	jmp    800dfa <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800de9:	ff 45 08             	incl   0x8(%ebp)
  800dec:	8b 45 08             	mov    0x8(%ebp),%eax
  800def:	8a 00                	mov    (%eax),%al
  800df1:	84 c0                	test   %al,%al
  800df3:	75 e5                	jne    800dda <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800df5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800dfa:	c9                   	leave  
  800dfb:	c3                   	ret    

00800dfc <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800dfc:	55                   	push   %ebp
  800dfd:	89 e5                	mov    %esp,%ebp
  800dff:	83 ec 04             	sub    $0x4,%esp
  800e02:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e05:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800e08:	eb 0d                	jmp    800e17 <strfind+0x1b>
		if (*s == c)
  800e0a:	8b 45 08             	mov    0x8(%ebp),%eax
  800e0d:	8a 00                	mov    (%eax),%al
  800e0f:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800e12:	74 0e                	je     800e22 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800e14:	ff 45 08             	incl   0x8(%ebp)
  800e17:	8b 45 08             	mov    0x8(%ebp),%eax
  800e1a:	8a 00                	mov    (%eax),%al
  800e1c:	84 c0                	test   %al,%al
  800e1e:	75 ea                	jne    800e0a <strfind+0xe>
  800e20:	eb 01                	jmp    800e23 <strfind+0x27>
		if (*s == c)
			break;
  800e22:	90                   	nop
	return (char *) s;
  800e23:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e26:	c9                   	leave  
  800e27:	c3                   	ret    

00800e28 <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  800e28:	55                   	push   %ebp
  800e29:	89 e5                	mov    %esp,%ebp
  800e2b:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  800e2e:	8b 45 08             	mov    0x8(%ebp),%eax
  800e31:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  800e34:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800e38:	76 63                	jbe    800e9d <memset+0x75>
		uint64 data_block = c;
  800e3a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e3d:	99                   	cltd   
  800e3e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e41:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  800e44:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e47:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e4a:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  800e4e:	c1 e0 08             	shl    $0x8,%eax
  800e51:	09 45 f0             	or     %eax,-0x10(%ebp)
  800e54:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  800e57:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e5a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e5d:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  800e61:	c1 e0 10             	shl    $0x10,%eax
  800e64:	09 45 f0             	or     %eax,-0x10(%ebp)
  800e67:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  800e6a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e6d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e70:	89 c2                	mov    %eax,%edx
  800e72:	b8 00 00 00 00       	mov    $0x0,%eax
  800e77:	09 45 f0             	or     %eax,-0x10(%ebp)
  800e7a:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  800e7d:	eb 18                	jmp    800e97 <memset+0x6f>
			*p64++ = data_block, n -= 8;
  800e7f:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  800e82:	8d 41 08             	lea    0x8(%ecx),%eax
  800e85:	89 45 fc             	mov    %eax,-0x4(%ebp)
  800e88:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e8b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e8e:	89 01                	mov    %eax,(%ecx)
  800e90:	89 51 04             	mov    %edx,0x4(%ecx)
  800e93:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  800e97:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800e9b:	77 e2                	ja     800e7f <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  800e9d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ea1:	74 23                	je     800ec6 <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  800ea3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ea6:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  800ea9:	eb 0e                	jmp    800eb9 <memset+0x91>
			*p8++ = (uint8)c;
  800eab:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800eae:	8d 50 01             	lea    0x1(%eax),%edx
  800eb1:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800eb4:	8b 55 0c             	mov    0xc(%ebp),%edx
  800eb7:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  800eb9:	8b 45 10             	mov    0x10(%ebp),%eax
  800ebc:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ebf:	89 55 10             	mov    %edx,0x10(%ebp)
  800ec2:	85 c0                	test   %eax,%eax
  800ec4:	75 e5                	jne    800eab <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  800ec6:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ec9:	c9                   	leave  
  800eca:	c3                   	ret    

00800ecb <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800ecb:	55                   	push   %ebp
  800ecc:	89 e5                	mov    %esp,%ebp
  800ece:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  800ed1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ed4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  800ed7:	8b 45 08             	mov    0x8(%ebp),%eax
  800eda:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  800edd:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800ee1:	76 24                	jbe    800f07 <memcpy+0x3c>
		while(n >= 8){
  800ee3:	eb 1c                	jmp    800f01 <memcpy+0x36>
			*d64 = *s64;
  800ee5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ee8:	8b 50 04             	mov    0x4(%eax),%edx
  800eeb:	8b 00                	mov    (%eax),%eax
  800eed:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  800ef0:	89 01                	mov    %eax,(%ecx)
  800ef2:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  800ef5:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  800ef9:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  800efd:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  800f01:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800f05:	77 de                	ja     800ee5 <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  800f07:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f0b:	74 31                	je     800f3e <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  800f0d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f10:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  800f13:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f16:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  800f19:	eb 16                	jmp    800f31 <memcpy+0x66>
			*d8++ = *s8++;
  800f1b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800f1e:	8d 50 01             	lea    0x1(%eax),%edx
  800f21:	89 55 f0             	mov    %edx,-0x10(%ebp)
  800f24:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f27:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f2a:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  800f2d:	8a 12                	mov    (%edx),%dl
  800f2f:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  800f31:	8b 45 10             	mov    0x10(%ebp),%eax
  800f34:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f37:	89 55 10             	mov    %edx,0x10(%ebp)
  800f3a:	85 c0                	test   %eax,%eax
  800f3c:	75 dd                	jne    800f1b <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  800f3e:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f41:	c9                   	leave  
  800f42:	c3                   	ret    

00800f43 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800f43:	55                   	push   %ebp
  800f44:	89 e5                	mov    %esp,%ebp
  800f46:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800f49:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f4c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800f4f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f52:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800f55:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f58:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800f5b:	73 50                	jae    800fad <memmove+0x6a>
  800f5d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f60:	8b 45 10             	mov    0x10(%ebp),%eax
  800f63:	01 d0                	add    %edx,%eax
  800f65:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800f68:	76 43                	jbe    800fad <memmove+0x6a>
		s += n;
  800f6a:	8b 45 10             	mov    0x10(%ebp),%eax
  800f6d:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800f70:	8b 45 10             	mov    0x10(%ebp),%eax
  800f73:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800f76:	eb 10                	jmp    800f88 <memmove+0x45>
			*--d = *--s;
  800f78:	ff 4d f8             	decl   -0x8(%ebp)
  800f7b:	ff 4d fc             	decl   -0x4(%ebp)
  800f7e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f81:	8a 10                	mov    (%eax),%dl
  800f83:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f86:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800f88:	8b 45 10             	mov    0x10(%ebp),%eax
  800f8b:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f8e:	89 55 10             	mov    %edx,0x10(%ebp)
  800f91:	85 c0                	test   %eax,%eax
  800f93:	75 e3                	jne    800f78 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800f95:	eb 23                	jmp    800fba <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800f97:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f9a:	8d 50 01             	lea    0x1(%eax),%edx
  800f9d:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800fa0:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800fa3:	8d 4a 01             	lea    0x1(%edx),%ecx
  800fa6:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800fa9:	8a 12                	mov    (%edx),%dl
  800fab:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800fad:	8b 45 10             	mov    0x10(%ebp),%eax
  800fb0:	8d 50 ff             	lea    -0x1(%eax),%edx
  800fb3:	89 55 10             	mov    %edx,0x10(%ebp)
  800fb6:	85 c0                	test   %eax,%eax
  800fb8:	75 dd                	jne    800f97 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800fba:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800fbd:	c9                   	leave  
  800fbe:	c3                   	ret    

00800fbf <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800fbf:	55                   	push   %ebp
  800fc0:	89 e5                	mov    %esp,%ebp
  800fc2:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800fc5:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800fcb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fce:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800fd1:	eb 2a                	jmp    800ffd <memcmp+0x3e>
		if (*s1 != *s2)
  800fd3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fd6:	8a 10                	mov    (%eax),%dl
  800fd8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fdb:	8a 00                	mov    (%eax),%al
  800fdd:	38 c2                	cmp    %al,%dl
  800fdf:	74 16                	je     800ff7 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800fe1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fe4:	8a 00                	mov    (%eax),%al
  800fe6:	0f b6 d0             	movzbl %al,%edx
  800fe9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fec:	8a 00                	mov    (%eax),%al
  800fee:	0f b6 c0             	movzbl %al,%eax
  800ff1:	29 c2                	sub    %eax,%edx
  800ff3:	89 d0                	mov    %edx,%eax
  800ff5:	eb 18                	jmp    80100f <memcmp+0x50>
		s1++, s2++;
  800ff7:	ff 45 fc             	incl   -0x4(%ebp)
  800ffa:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800ffd:	8b 45 10             	mov    0x10(%ebp),%eax
  801000:	8d 50 ff             	lea    -0x1(%eax),%edx
  801003:	89 55 10             	mov    %edx,0x10(%ebp)
  801006:	85 c0                	test   %eax,%eax
  801008:	75 c9                	jne    800fd3 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  80100a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80100f:	c9                   	leave  
  801010:	c3                   	ret    

00801011 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801011:	55                   	push   %ebp
  801012:	89 e5                	mov    %esp,%ebp
  801014:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801017:	8b 55 08             	mov    0x8(%ebp),%edx
  80101a:	8b 45 10             	mov    0x10(%ebp),%eax
  80101d:	01 d0                	add    %edx,%eax
  80101f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801022:	eb 15                	jmp    801039 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801024:	8b 45 08             	mov    0x8(%ebp),%eax
  801027:	8a 00                	mov    (%eax),%al
  801029:	0f b6 d0             	movzbl %al,%edx
  80102c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80102f:	0f b6 c0             	movzbl %al,%eax
  801032:	39 c2                	cmp    %eax,%edx
  801034:	74 0d                	je     801043 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801036:	ff 45 08             	incl   0x8(%ebp)
  801039:	8b 45 08             	mov    0x8(%ebp),%eax
  80103c:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80103f:	72 e3                	jb     801024 <memfind+0x13>
  801041:	eb 01                	jmp    801044 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801043:	90                   	nop
	return (void *) s;
  801044:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801047:	c9                   	leave  
  801048:	c3                   	ret    

00801049 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801049:	55                   	push   %ebp
  80104a:	89 e5                	mov    %esp,%ebp
  80104c:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  80104f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801056:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80105d:	eb 03                	jmp    801062 <strtol+0x19>
		s++;
  80105f:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801062:	8b 45 08             	mov    0x8(%ebp),%eax
  801065:	8a 00                	mov    (%eax),%al
  801067:	3c 20                	cmp    $0x20,%al
  801069:	74 f4                	je     80105f <strtol+0x16>
  80106b:	8b 45 08             	mov    0x8(%ebp),%eax
  80106e:	8a 00                	mov    (%eax),%al
  801070:	3c 09                	cmp    $0x9,%al
  801072:	74 eb                	je     80105f <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801074:	8b 45 08             	mov    0x8(%ebp),%eax
  801077:	8a 00                	mov    (%eax),%al
  801079:	3c 2b                	cmp    $0x2b,%al
  80107b:	75 05                	jne    801082 <strtol+0x39>
		s++;
  80107d:	ff 45 08             	incl   0x8(%ebp)
  801080:	eb 13                	jmp    801095 <strtol+0x4c>
	else if (*s == '-')
  801082:	8b 45 08             	mov    0x8(%ebp),%eax
  801085:	8a 00                	mov    (%eax),%al
  801087:	3c 2d                	cmp    $0x2d,%al
  801089:	75 0a                	jne    801095 <strtol+0x4c>
		s++, neg = 1;
  80108b:	ff 45 08             	incl   0x8(%ebp)
  80108e:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801095:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801099:	74 06                	je     8010a1 <strtol+0x58>
  80109b:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  80109f:	75 20                	jne    8010c1 <strtol+0x78>
  8010a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a4:	8a 00                	mov    (%eax),%al
  8010a6:	3c 30                	cmp    $0x30,%al
  8010a8:	75 17                	jne    8010c1 <strtol+0x78>
  8010aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ad:	40                   	inc    %eax
  8010ae:	8a 00                	mov    (%eax),%al
  8010b0:	3c 78                	cmp    $0x78,%al
  8010b2:	75 0d                	jne    8010c1 <strtol+0x78>
		s += 2, base = 16;
  8010b4:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8010b8:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8010bf:	eb 28                	jmp    8010e9 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8010c1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010c5:	75 15                	jne    8010dc <strtol+0x93>
  8010c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ca:	8a 00                	mov    (%eax),%al
  8010cc:	3c 30                	cmp    $0x30,%al
  8010ce:	75 0c                	jne    8010dc <strtol+0x93>
		s++, base = 8;
  8010d0:	ff 45 08             	incl   0x8(%ebp)
  8010d3:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8010da:	eb 0d                	jmp    8010e9 <strtol+0xa0>
	else if (base == 0)
  8010dc:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010e0:	75 07                	jne    8010e9 <strtol+0xa0>
		base = 10;
  8010e2:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8010e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ec:	8a 00                	mov    (%eax),%al
  8010ee:	3c 2f                	cmp    $0x2f,%al
  8010f0:	7e 19                	jle    80110b <strtol+0xc2>
  8010f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8010f5:	8a 00                	mov    (%eax),%al
  8010f7:	3c 39                	cmp    $0x39,%al
  8010f9:	7f 10                	jg     80110b <strtol+0xc2>
			dig = *s - '0';
  8010fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8010fe:	8a 00                	mov    (%eax),%al
  801100:	0f be c0             	movsbl %al,%eax
  801103:	83 e8 30             	sub    $0x30,%eax
  801106:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801109:	eb 42                	jmp    80114d <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  80110b:	8b 45 08             	mov    0x8(%ebp),%eax
  80110e:	8a 00                	mov    (%eax),%al
  801110:	3c 60                	cmp    $0x60,%al
  801112:	7e 19                	jle    80112d <strtol+0xe4>
  801114:	8b 45 08             	mov    0x8(%ebp),%eax
  801117:	8a 00                	mov    (%eax),%al
  801119:	3c 7a                	cmp    $0x7a,%al
  80111b:	7f 10                	jg     80112d <strtol+0xe4>
			dig = *s - 'a' + 10;
  80111d:	8b 45 08             	mov    0x8(%ebp),%eax
  801120:	8a 00                	mov    (%eax),%al
  801122:	0f be c0             	movsbl %al,%eax
  801125:	83 e8 57             	sub    $0x57,%eax
  801128:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80112b:	eb 20                	jmp    80114d <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  80112d:	8b 45 08             	mov    0x8(%ebp),%eax
  801130:	8a 00                	mov    (%eax),%al
  801132:	3c 40                	cmp    $0x40,%al
  801134:	7e 39                	jle    80116f <strtol+0x126>
  801136:	8b 45 08             	mov    0x8(%ebp),%eax
  801139:	8a 00                	mov    (%eax),%al
  80113b:	3c 5a                	cmp    $0x5a,%al
  80113d:	7f 30                	jg     80116f <strtol+0x126>
			dig = *s - 'A' + 10;
  80113f:	8b 45 08             	mov    0x8(%ebp),%eax
  801142:	8a 00                	mov    (%eax),%al
  801144:	0f be c0             	movsbl %al,%eax
  801147:	83 e8 37             	sub    $0x37,%eax
  80114a:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  80114d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801150:	3b 45 10             	cmp    0x10(%ebp),%eax
  801153:	7d 19                	jge    80116e <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801155:	ff 45 08             	incl   0x8(%ebp)
  801158:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80115b:	0f af 45 10          	imul   0x10(%ebp),%eax
  80115f:	89 c2                	mov    %eax,%edx
  801161:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801164:	01 d0                	add    %edx,%eax
  801166:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801169:	e9 7b ff ff ff       	jmp    8010e9 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  80116e:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  80116f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801173:	74 08                	je     80117d <strtol+0x134>
		*endptr = (char *) s;
  801175:	8b 45 0c             	mov    0xc(%ebp),%eax
  801178:	8b 55 08             	mov    0x8(%ebp),%edx
  80117b:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  80117d:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801181:	74 07                	je     80118a <strtol+0x141>
  801183:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801186:	f7 d8                	neg    %eax
  801188:	eb 03                	jmp    80118d <strtol+0x144>
  80118a:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80118d:	c9                   	leave  
  80118e:	c3                   	ret    

0080118f <ltostr>:

void
ltostr(long value, char *str)
{
  80118f:	55                   	push   %ebp
  801190:	89 e5                	mov    %esp,%ebp
  801192:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801195:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  80119c:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8011a3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8011a7:	79 13                	jns    8011bc <ltostr+0x2d>
	{
		neg = 1;
  8011a9:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8011b0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011b3:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8011b6:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8011b9:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8011bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8011bf:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8011c4:	99                   	cltd   
  8011c5:	f7 f9                	idiv   %ecx
  8011c7:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8011ca:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011cd:	8d 50 01             	lea    0x1(%eax),%edx
  8011d0:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8011d3:	89 c2                	mov    %eax,%edx
  8011d5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011d8:	01 d0                	add    %edx,%eax
  8011da:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8011dd:	83 c2 30             	add    $0x30,%edx
  8011e0:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8011e2:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8011e5:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8011ea:	f7 e9                	imul   %ecx
  8011ec:	c1 fa 02             	sar    $0x2,%edx
  8011ef:	89 c8                	mov    %ecx,%eax
  8011f1:	c1 f8 1f             	sar    $0x1f,%eax
  8011f4:	29 c2                	sub    %eax,%edx
  8011f6:	89 d0                	mov    %edx,%eax
  8011f8:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  8011fb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8011ff:	75 bb                	jne    8011bc <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801201:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801208:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80120b:	48                   	dec    %eax
  80120c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  80120f:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801213:	74 3d                	je     801252 <ltostr+0xc3>
		start = 1 ;
  801215:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  80121c:	eb 34                	jmp    801252 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  80121e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801221:	8b 45 0c             	mov    0xc(%ebp),%eax
  801224:	01 d0                	add    %edx,%eax
  801226:	8a 00                	mov    (%eax),%al
  801228:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  80122b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80122e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801231:	01 c2                	add    %eax,%edx
  801233:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801236:	8b 45 0c             	mov    0xc(%ebp),%eax
  801239:	01 c8                	add    %ecx,%eax
  80123b:	8a 00                	mov    (%eax),%al
  80123d:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  80123f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801242:	8b 45 0c             	mov    0xc(%ebp),%eax
  801245:	01 c2                	add    %eax,%edx
  801247:	8a 45 eb             	mov    -0x15(%ebp),%al
  80124a:	88 02                	mov    %al,(%edx)
		start++ ;
  80124c:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  80124f:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801252:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801255:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801258:	7c c4                	jl     80121e <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  80125a:	8b 55 f8             	mov    -0x8(%ebp),%edx
  80125d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801260:	01 d0                	add    %edx,%eax
  801262:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801265:	90                   	nop
  801266:	c9                   	leave  
  801267:	c3                   	ret    

00801268 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801268:	55                   	push   %ebp
  801269:	89 e5                	mov    %esp,%ebp
  80126b:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  80126e:	ff 75 08             	pushl  0x8(%ebp)
  801271:	e8 c4 f9 ff ff       	call   800c3a <strlen>
  801276:	83 c4 04             	add    $0x4,%esp
  801279:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  80127c:	ff 75 0c             	pushl  0xc(%ebp)
  80127f:	e8 b6 f9 ff ff       	call   800c3a <strlen>
  801284:	83 c4 04             	add    $0x4,%esp
  801287:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  80128a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801291:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801298:	eb 17                	jmp    8012b1 <strcconcat+0x49>
		final[s] = str1[s] ;
  80129a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80129d:	8b 45 10             	mov    0x10(%ebp),%eax
  8012a0:	01 c2                	add    %eax,%edx
  8012a2:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8012a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a8:	01 c8                	add    %ecx,%eax
  8012aa:	8a 00                	mov    (%eax),%al
  8012ac:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8012ae:	ff 45 fc             	incl   -0x4(%ebp)
  8012b1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012b4:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8012b7:	7c e1                	jl     80129a <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8012b9:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8012c0:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8012c7:	eb 1f                	jmp    8012e8 <strcconcat+0x80>
		final[s++] = str2[i] ;
  8012c9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012cc:	8d 50 01             	lea    0x1(%eax),%edx
  8012cf:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8012d2:	89 c2                	mov    %eax,%edx
  8012d4:	8b 45 10             	mov    0x10(%ebp),%eax
  8012d7:	01 c2                	add    %eax,%edx
  8012d9:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8012dc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012df:	01 c8                	add    %ecx,%eax
  8012e1:	8a 00                	mov    (%eax),%al
  8012e3:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8012e5:	ff 45 f8             	incl   -0x8(%ebp)
  8012e8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012eb:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8012ee:	7c d9                	jl     8012c9 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8012f0:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8012f3:	8b 45 10             	mov    0x10(%ebp),%eax
  8012f6:	01 d0                	add    %edx,%eax
  8012f8:	c6 00 00             	movb   $0x0,(%eax)
}
  8012fb:	90                   	nop
  8012fc:	c9                   	leave  
  8012fd:	c3                   	ret    

008012fe <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8012fe:	55                   	push   %ebp
  8012ff:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801301:	8b 45 14             	mov    0x14(%ebp),%eax
  801304:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  80130a:	8b 45 14             	mov    0x14(%ebp),%eax
  80130d:	8b 00                	mov    (%eax),%eax
  80130f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801316:	8b 45 10             	mov    0x10(%ebp),%eax
  801319:	01 d0                	add    %edx,%eax
  80131b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801321:	eb 0c                	jmp    80132f <strsplit+0x31>
			*string++ = 0;
  801323:	8b 45 08             	mov    0x8(%ebp),%eax
  801326:	8d 50 01             	lea    0x1(%eax),%edx
  801329:	89 55 08             	mov    %edx,0x8(%ebp)
  80132c:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80132f:	8b 45 08             	mov    0x8(%ebp),%eax
  801332:	8a 00                	mov    (%eax),%al
  801334:	84 c0                	test   %al,%al
  801336:	74 18                	je     801350 <strsplit+0x52>
  801338:	8b 45 08             	mov    0x8(%ebp),%eax
  80133b:	8a 00                	mov    (%eax),%al
  80133d:	0f be c0             	movsbl %al,%eax
  801340:	50                   	push   %eax
  801341:	ff 75 0c             	pushl  0xc(%ebp)
  801344:	e8 83 fa ff ff       	call   800dcc <strchr>
  801349:	83 c4 08             	add    $0x8,%esp
  80134c:	85 c0                	test   %eax,%eax
  80134e:	75 d3                	jne    801323 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801350:	8b 45 08             	mov    0x8(%ebp),%eax
  801353:	8a 00                	mov    (%eax),%al
  801355:	84 c0                	test   %al,%al
  801357:	74 5a                	je     8013b3 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801359:	8b 45 14             	mov    0x14(%ebp),%eax
  80135c:	8b 00                	mov    (%eax),%eax
  80135e:	83 f8 0f             	cmp    $0xf,%eax
  801361:	75 07                	jne    80136a <strsplit+0x6c>
		{
			return 0;
  801363:	b8 00 00 00 00       	mov    $0x0,%eax
  801368:	eb 66                	jmp    8013d0 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  80136a:	8b 45 14             	mov    0x14(%ebp),%eax
  80136d:	8b 00                	mov    (%eax),%eax
  80136f:	8d 48 01             	lea    0x1(%eax),%ecx
  801372:	8b 55 14             	mov    0x14(%ebp),%edx
  801375:	89 0a                	mov    %ecx,(%edx)
  801377:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80137e:	8b 45 10             	mov    0x10(%ebp),%eax
  801381:	01 c2                	add    %eax,%edx
  801383:	8b 45 08             	mov    0x8(%ebp),%eax
  801386:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801388:	eb 03                	jmp    80138d <strsplit+0x8f>
			string++;
  80138a:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  80138d:	8b 45 08             	mov    0x8(%ebp),%eax
  801390:	8a 00                	mov    (%eax),%al
  801392:	84 c0                	test   %al,%al
  801394:	74 8b                	je     801321 <strsplit+0x23>
  801396:	8b 45 08             	mov    0x8(%ebp),%eax
  801399:	8a 00                	mov    (%eax),%al
  80139b:	0f be c0             	movsbl %al,%eax
  80139e:	50                   	push   %eax
  80139f:	ff 75 0c             	pushl  0xc(%ebp)
  8013a2:	e8 25 fa ff ff       	call   800dcc <strchr>
  8013a7:	83 c4 08             	add    $0x8,%esp
  8013aa:	85 c0                	test   %eax,%eax
  8013ac:	74 dc                	je     80138a <strsplit+0x8c>
			string++;
	}
  8013ae:	e9 6e ff ff ff       	jmp    801321 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8013b3:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8013b4:	8b 45 14             	mov    0x14(%ebp),%eax
  8013b7:	8b 00                	mov    (%eax),%eax
  8013b9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8013c0:	8b 45 10             	mov    0x10(%ebp),%eax
  8013c3:	01 d0                	add    %edx,%eax
  8013c5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8013cb:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8013d0:	c9                   	leave  
  8013d1:	c3                   	ret    

008013d2 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  8013d2:	55                   	push   %ebp
  8013d3:	89 e5                	mov    %esp,%ebp
  8013d5:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  8013d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8013db:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  8013de:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8013e5:	eb 4a                	jmp    801431 <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  8013e7:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8013ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8013ed:	01 c2                	add    %eax,%edx
  8013ef:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8013f2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013f5:	01 c8                	add    %ecx,%eax
  8013f7:	8a 00                	mov    (%eax),%al
  8013f9:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  8013fb:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8013fe:	8b 45 0c             	mov    0xc(%ebp),%eax
  801401:	01 d0                	add    %edx,%eax
  801403:	8a 00                	mov    (%eax),%al
  801405:	3c 40                	cmp    $0x40,%al
  801407:	7e 25                	jle    80142e <str2lower+0x5c>
  801409:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80140c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80140f:	01 d0                	add    %edx,%eax
  801411:	8a 00                	mov    (%eax),%al
  801413:	3c 5a                	cmp    $0x5a,%al
  801415:	7f 17                	jg     80142e <str2lower+0x5c>
		{
			dst[i] += 32 ;
  801417:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80141a:	8b 45 08             	mov    0x8(%ebp),%eax
  80141d:	01 d0                	add    %edx,%eax
  80141f:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801422:	8b 55 08             	mov    0x8(%ebp),%edx
  801425:	01 ca                	add    %ecx,%edx
  801427:	8a 12                	mov    (%edx),%dl
  801429:	83 c2 20             	add    $0x20,%edx
  80142c:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  80142e:	ff 45 fc             	incl   -0x4(%ebp)
  801431:	ff 75 0c             	pushl  0xc(%ebp)
  801434:	e8 01 f8 ff ff       	call   800c3a <strlen>
  801439:	83 c4 04             	add    $0x4,%esp
  80143c:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80143f:	7f a6                	jg     8013e7 <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  801441:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801444:	c9                   	leave  
  801445:	c3                   	ret    

00801446 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801446:	55                   	push   %ebp
  801447:	89 e5                	mov    %esp,%ebp
  801449:	57                   	push   %edi
  80144a:	56                   	push   %esi
  80144b:	53                   	push   %ebx
  80144c:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80144f:	8b 45 08             	mov    0x8(%ebp),%eax
  801452:	8b 55 0c             	mov    0xc(%ebp),%edx
  801455:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801458:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80145b:	8b 7d 18             	mov    0x18(%ebp),%edi
  80145e:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801461:	cd 30                	int    $0x30
  801463:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  801466:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801469:	83 c4 10             	add    $0x10,%esp
  80146c:	5b                   	pop    %ebx
  80146d:	5e                   	pop    %esi
  80146e:	5f                   	pop    %edi
  80146f:	5d                   	pop    %ebp
  801470:	c3                   	ret    

00801471 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  801471:	55                   	push   %ebp
  801472:	89 e5                	mov    %esp,%ebp
  801474:	83 ec 04             	sub    $0x4,%esp
  801477:	8b 45 10             	mov    0x10(%ebp),%eax
  80147a:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  80147d:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801480:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801484:	8b 45 08             	mov    0x8(%ebp),%eax
  801487:	6a 00                	push   $0x0
  801489:	51                   	push   %ecx
  80148a:	52                   	push   %edx
  80148b:	ff 75 0c             	pushl  0xc(%ebp)
  80148e:	50                   	push   %eax
  80148f:	6a 00                	push   $0x0
  801491:	e8 b0 ff ff ff       	call   801446 <syscall>
  801496:	83 c4 18             	add    $0x18,%esp
}
  801499:	90                   	nop
  80149a:	c9                   	leave  
  80149b:	c3                   	ret    

0080149c <sys_cgetc>:

int
sys_cgetc(void)
{
  80149c:	55                   	push   %ebp
  80149d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  80149f:	6a 00                	push   $0x0
  8014a1:	6a 00                	push   $0x0
  8014a3:	6a 00                	push   $0x0
  8014a5:	6a 00                	push   $0x0
  8014a7:	6a 00                	push   $0x0
  8014a9:	6a 02                	push   $0x2
  8014ab:	e8 96 ff ff ff       	call   801446 <syscall>
  8014b0:	83 c4 18             	add    $0x18,%esp
}
  8014b3:	c9                   	leave  
  8014b4:	c3                   	ret    

008014b5 <sys_lock_cons>:

void sys_lock_cons(void)
{
  8014b5:	55                   	push   %ebp
  8014b6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  8014b8:	6a 00                	push   $0x0
  8014ba:	6a 00                	push   $0x0
  8014bc:	6a 00                	push   $0x0
  8014be:	6a 00                	push   $0x0
  8014c0:	6a 00                	push   $0x0
  8014c2:	6a 03                	push   $0x3
  8014c4:	e8 7d ff ff ff       	call   801446 <syscall>
  8014c9:	83 c4 18             	add    $0x18,%esp
}
  8014cc:	90                   	nop
  8014cd:	c9                   	leave  
  8014ce:	c3                   	ret    

008014cf <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  8014cf:	55                   	push   %ebp
  8014d0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  8014d2:	6a 00                	push   $0x0
  8014d4:	6a 00                	push   $0x0
  8014d6:	6a 00                	push   $0x0
  8014d8:	6a 00                	push   $0x0
  8014da:	6a 00                	push   $0x0
  8014dc:	6a 04                	push   $0x4
  8014de:	e8 63 ff ff ff       	call   801446 <syscall>
  8014e3:	83 c4 18             	add    $0x18,%esp
}
  8014e6:	90                   	nop
  8014e7:	c9                   	leave  
  8014e8:	c3                   	ret    

008014e9 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8014e9:	55                   	push   %ebp
  8014ea:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8014ec:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8014f2:	6a 00                	push   $0x0
  8014f4:	6a 00                	push   $0x0
  8014f6:	6a 00                	push   $0x0
  8014f8:	52                   	push   %edx
  8014f9:	50                   	push   %eax
  8014fa:	6a 08                	push   $0x8
  8014fc:	e8 45 ff ff ff       	call   801446 <syscall>
  801501:	83 c4 18             	add    $0x18,%esp
}
  801504:	c9                   	leave  
  801505:	c3                   	ret    

00801506 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801506:	55                   	push   %ebp
  801507:	89 e5                	mov    %esp,%ebp
  801509:	56                   	push   %esi
  80150a:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  80150b:	8b 75 18             	mov    0x18(%ebp),%esi
  80150e:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801511:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801514:	8b 55 0c             	mov    0xc(%ebp),%edx
  801517:	8b 45 08             	mov    0x8(%ebp),%eax
  80151a:	56                   	push   %esi
  80151b:	53                   	push   %ebx
  80151c:	51                   	push   %ecx
  80151d:	52                   	push   %edx
  80151e:	50                   	push   %eax
  80151f:	6a 09                	push   $0x9
  801521:	e8 20 ff ff ff       	call   801446 <syscall>
  801526:	83 c4 18             	add    $0x18,%esp
}
  801529:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80152c:	5b                   	pop    %ebx
  80152d:	5e                   	pop    %esi
  80152e:	5d                   	pop    %ebp
  80152f:	c3                   	ret    

00801530 <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  801530:	55                   	push   %ebp
  801531:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  801533:	6a 00                	push   $0x0
  801535:	6a 00                	push   $0x0
  801537:	6a 00                	push   $0x0
  801539:	6a 00                	push   $0x0
  80153b:	ff 75 08             	pushl  0x8(%ebp)
  80153e:	6a 0a                	push   $0xa
  801540:	e8 01 ff ff ff       	call   801446 <syscall>
  801545:	83 c4 18             	add    $0x18,%esp
}
  801548:	c9                   	leave  
  801549:	c3                   	ret    

0080154a <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  80154a:	55                   	push   %ebp
  80154b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  80154d:	6a 00                	push   $0x0
  80154f:	6a 00                	push   $0x0
  801551:	6a 00                	push   $0x0
  801553:	ff 75 0c             	pushl  0xc(%ebp)
  801556:	ff 75 08             	pushl  0x8(%ebp)
  801559:	6a 0b                	push   $0xb
  80155b:	e8 e6 fe ff ff       	call   801446 <syscall>
  801560:	83 c4 18             	add    $0x18,%esp
}
  801563:	c9                   	leave  
  801564:	c3                   	ret    

00801565 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801565:	55                   	push   %ebp
  801566:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801568:	6a 00                	push   $0x0
  80156a:	6a 00                	push   $0x0
  80156c:	6a 00                	push   $0x0
  80156e:	6a 00                	push   $0x0
  801570:	6a 00                	push   $0x0
  801572:	6a 0c                	push   $0xc
  801574:	e8 cd fe ff ff       	call   801446 <syscall>
  801579:	83 c4 18             	add    $0x18,%esp
}
  80157c:	c9                   	leave  
  80157d:	c3                   	ret    

0080157e <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  80157e:	55                   	push   %ebp
  80157f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801581:	6a 00                	push   $0x0
  801583:	6a 00                	push   $0x0
  801585:	6a 00                	push   $0x0
  801587:	6a 00                	push   $0x0
  801589:	6a 00                	push   $0x0
  80158b:	6a 0d                	push   $0xd
  80158d:	e8 b4 fe ff ff       	call   801446 <syscall>
  801592:	83 c4 18             	add    $0x18,%esp
}
  801595:	c9                   	leave  
  801596:	c3                   	ret    

00801597 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801597:	55                   	push   %ebp
  801598:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  80159a:	6a 00                	push   $0x0
  80159c:	6a 00                	push   $0x0
  80159e:	6a 00                	push   $0x0
  8015a0:	6a 00                	push   $0x0
  8015a2:	6a 00                	push   $0x0
  8015a4:	6a 0e                	push   $0xe
  8015a6:	e8 9b fe ff ff       	call   801446 <syscall>
  8015ab:	83 c4 18             	add    $0x18,%esp
}
  8015ae:	c9                   	leave  
  8015af:	c3                   	ret    

008015b0 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8015b0:	55                   	push   %ebp
  8015b1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8015b3:	6a 00                	push   $0x0
  8015b5:	6a 00                	push   $0x0
  8015b7:	6a 00                	push   $0x0
  8015b9:	6a 00                	push   $0x0
  8015bb:	6a 00                	push   $0x0
  8015bd:	6a 0f                	push   $0xf
  8015bf:	e8 82 fe ff ff       	call   801446 <syscall>
  8015c4:	83 c4 18             	add    $0x18,%esp
}
  8015c7:	c9                   	leave  
  8015c8:	c3                   	ret    

008015c9 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8015c9:	55                   	push   %ebp
  8015ca:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8015cc:	6a 00                	push   $0x0
  8015ce:	6a 00                	push   $0x0
  8015d0:	6a 00                	push   $0x0
  8015d2:	6a 00                	push   $0x0
  8015d4:	ff 75 08             	pushl  0x8(%ebp)
  8015d7:	6a 10                	push   $0x10
  8015d9:	e8 68 fe ff ff       	call   801446 <syscall>
  8015de:	83 c4 18             	add    $0x18,%esp
}
  8015e1:	c9                   	leave  
  8015e2:	c3                   	ret    

008015e3 <sys_scarce_memory>:

void sys_scarce_memory()
{
  8015e3:	55                   	push   %ebp
  8015e4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8015e6:	6a 00                	push   $0x0
  8015e8:	6a 00                	push   $0x0
  8015ea:	6a 00                	push   $0x0
  8015ec:	6a 00                	push   $0x0
  8015ee:	6a 00                	push   $0x0
  8015f0:	6a 11                	push   $0x11
  8015f2:	e8 4f fe ff ff       	call   801446 <syscall>
  8015f7:	83 c4 18             	add    $0x18,%esp
}
  8015fa:	90                   	nop
  8015fb:	c9                   	leave  
  8015fc:	c3                   	ret    

008015fd <sys_cputc>:

void
sys_cputc(const char c)
{
  8015fd:	55                   	push   %ebp
  8015fe:	89 e5                	mov    %esp,%ebp
  801600:	83 ec 04             	sub    $0x4,%esp
  801603:	8b 45 08             	mov    0x8(%ebp),%eax
  801606:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801609:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80160d:	6a 00                	push   $0x0
  80160f:	6a 00                	push   $0x0
  801611:	6a 00                	push   $0x0
  801613:	6a 00                	push   $0x0
  801615:	50                   	push   %eax
  801616:	6a 01                	push   $0x1
  801618:	e8 29 fe ff ff       	call   801446 <syscall>
  80161d:	83 c4 18             	add    $0x18,%esp
}
  801620:	90                   	nop
  801621:	c9                   	leave  
  801622:	c3                   	ret    

00801623 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801623:	55                   	push   %ebp
  801624:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801626:	6a 00                	push   $0x0
  801628:	6a 00                	push   $0x0
  80162a:	6a 00                	push   $0x0
  80162c:	6a 00                	push   $0x0
  80162e:	6a 00                	push   $0x0
  801630:	6a 14                	push   $0x14
  801632:	e8 0f fe ff ff       	call   801446 <syscall>
  801637:	83 c4 18             	add    $0x18,%esp
}
  80163a:	90                   	nop
  80163b:	c9                   	leave  
  80163c:	c3                   	ret    

0080163d <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  80163d:	55                   	push   %ebp
  80163e:	89 e5                	mov    %esp,%ebp
  801640:	83 ec 04             	sub    $0x4,%esp
  801643:	8b 45 10             	mov    0x10(%ebp),%eax
  801646:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801649:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80164c:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801650:	8b 45 08             	mov    0x8(%ebp),%eax
  801653:	6a 00                	push   $0x0
  801655:	51                   	push   %ecx
  801656:	52                   	push   %edx
  801657:	ff 75 0c             	pushl  0xc(%ebp)
  80165a:	50                   	push   %eax
  80165b:	6a 15                	push   $0x15
  80165d:	e8 e4 fd ff ff       	call   801446 <syscall>
  801662:	83 c4 18             	add    $0x18,%esp
}
  801665:	c9                   	leave  
  801666:	c3                   	ret    

00801667 <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  801667:	55                   	push   %ebp
  801668:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  80166a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80166d:	8b 45 08             	mov    0x8(%ebp),%eax
  801670:	6a 00                	push   $0x0
  801672:	6a 00                	push   $0x0
  801674:	6a 00                	push   $0x0
  801676:	52                   	push   %edx
  801677:	50                   	push   %eax
  801678:	6a 16                	push   $0x16
  80167a:	e8 c7 fd ff ff       	call   801446 <syscall>
  80167f:	83 c4 18             	add    $0x18,%esp
}
  801682:	c9                   	leave  
  801683:	c3                   	ret    

00801684 <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  801684:	55                   	push   %ebp
  801685:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801687:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80168a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80168d:	8b 45 08             	mov    0x8(%ebp),%eax
  801690:	6a 00                	push   $0x0
  801692:	6a 00                	push   $0x0
  801694:	51                   	push   %ecx
  801695:	52                   	push   %edx
  801696:	50                   	push   %eax
  801697:	6a 17                	push   $0x17
  801699:	e8 a8 fd ff ff       	call   801446 <syscall>
  80169e:	83 c4 18             	add    $0x18,%esp
}
  8016a1:	c9                   	leave  
  8016a2:	c3                   	ret    

008016a3 <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  8016a3:	55                   	push   %ebp
  8016a4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8016a6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8016ac:	6a 00                	push   $0x0
  8016ae:	6a 00                	push   $0x0
  8016b0:	6a 00                	push   $0x0
  8016b2:	52                   	push   %edx
  8016b3:	50                   	push   %eax
  8016b4:	6a 18                	push   $0x18
  8016b6:	e8 8b fd ff ff       	call   801446 <syscall>
  8016bb:	83 c4 18             	add    $0x18,%esp
}
  8016be:	c9                   	leave  
  8016bf:	c3                   	ret    

008016c0 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8016c0:	55                   	push   %ebp
  8016c1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8016c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8016c6:	6a 00                	push   $0x0
  8016c8:	ff 75 14             	pushl  0x14(%ebp)
  8016cb:	ff 75 10             	pushl  0x10(%ebp)
  8016ce:	ff 75 0c             	pushl  0xc(%ebp)
  8016d1:	50                   	push   %eax
  8016d2:	6a 19                	push   $0x19
  8016d4:	e8 6d fd ff ff       	call   801446 <syscall>
  8016d9:	83 c4 18             	add    $0x18,%esp
}
  8016dc:	c9                   	leave  
  8016dd:	c3                   	ret    

008016de <sys_run_env>:

void sys_run_env(int32 envId)
{
  8016de:	55                   	push   %ebp
  8016df:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8016e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8016e4:	6a 00                	push   $0x0
  8016e6:	6a 00                	push   $0x0
  8016e8:	6a 00                	push   $0x0
  8016ea:	6a 00                	push   $0x0
  8016ec:	50                   	push   %eax
  8016ed:	6a 1a                	push   $0x1a
  8016ef:	e8 52 fd ff ff       	call   801446 <syscall>
  8016f4:	83 c4 18             	add    $0x18,%esp
}
  8016f7:	90                   	nop
  8016f8:	c9                   	leave  
  8016f9:	c3                   	ret    

008016fa <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8016fa:	55                   	push   %ebp
  8016fb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8016fd:	8b 45 08             	mov    0x8(%ebp),%eax
  801700:	6a 00                	push   $0x0
  801702:	6a 00                	push   $0x0
  801704:	6a 00                	push   $0x0
  801706:	6a 00                	push   $0x0
  801708:	50                   	push   %eax
  801709:	6a 1b                	push   $0x1b
  80170b:	e8 36 fd ff ff       	call   801446 <syscall>
  801710:	83 c4 18             	add    $0x18,%esp
}
  801713:	c9                   	leave  
  801714:	c3                   	ret    

00801715 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801715:	55                   	push   %ebp
  801716:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801718:	6a 00                	push   $0x0
  80171a:	6a 00                	push   $0x0
  80171c:	6a 00                	push   $0x0
  80171e:	6a 00                	push   $0x0
  801720:	6a 00                	push   $0x0
  801722:	6a 05                	push   $0x5
  801724:	e8 1d fd ff ff       	call   801446 <syscall>
  801729:	83 c4 18             	add    $0x18,%esp
}
  80172c:	c9                   	leave  
  80172d:	c3                   	ret    

0080172e <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  80172e:	55                   	push   %ebp
  80172f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801731:	6a 00                	push   $0x0
  801733:	6a 00                	push   $0x0
  801735:	6a 00                	push   $0x0
  801737:	6a 00                	push   $0x0
  801739:	6a 00                	push   $0x0
  80173b:	6a 06                	push   $0x6
  80173d:	e8 04 fd ff ff       	call   801446 <syscall>
  801742:	83 c4 18             	add    $0x18,%esp
}
  801745:	c9                   	leave  
  801746:	c3                   	ret    

00801747 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801747:	55                   	push   %ebp
  801748:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  80174a:	6a 00                	push   $0x0
  80174c:	6a 00                	push   $0x0
  80174e:	6a 00                	push   $0x0
  801750:	6a 00                	push   $0x0
  801752:	6a 00                	push   $0x0
  801754:	6a 07                	push   $0x7
  801756:	e8 eb fc ff ff       	call   801446 <syscall>
  80175b:	83 c4 18             	add    $0x18,%esp
}
  80175e:	c9                   	leave  
  80175f:	c3                   	ret    

00801760 <sys_exit_env>:


void sys_exit_env(void)
{
  801760:	55                   	push   %ebp
  801761:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801763:	6a 00                	push   $0x0
  801765:	6a 00                	push   $0x0
  801767:	6a 00                	push   $0x0
  801769:	6a 00                	push   $0x0
  80176b:	6a 00                	push   $0x0
  80176d:	6a 1c                	push   $0x1c
  80176f:	e8 d2 fc ff ff       	call   801446 <syscall>
  801774:	83 c4 18             	add    $0x18,%esp
}
  801777:	90                   	nop
  801778:	c9                   	leave  
  801779:	c3                   	ret    

0080177a <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  80177a:	55                   	push   %ebp
  80177b:	89 e5                	mov    %esp,%ebp
  80177d:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801780:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801783:	8d 50 04             	lea    0x4(%eax),%edx
  801786:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801789:	6a 00                	push   $0x0
  80178b:	6a 00                	push   $0x0
  80178d:	6a 00                	push   $0x0
  80178f:	52                   	push   %edx
  801790:	50                   	push   %eax
  801791:	6a 1d                	push   $0x1d
  801793:	e8 ae fc ff ff       	call   801446 <syscall>
  801798:	83 c4 18             	add    $0x18,%esp
	return result;
  80179b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80179e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8017a1:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8017a4:	89 01                	mov    %eax,(%ecx)
  8017a6:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8017a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8017ac:	c9                   	leave  
  8017ad:	c2 04 00             	ret    $0x4

008017b0 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8017b0:	55                   	push   %ebp
  8017b1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8017b3:	6a 00                	push   $0x0
  8017b5:	6a 00                	push   $0x0
  8017b7:	ff 75 10             	pushl  0x10(%ebp)
  8017ba:	ff 75 0c             	pushl  0xc(%ebp)
  8017bd:	ff 75 08             	pushl  0x8(%ebp)
  8017c0:	6a 13                	push   $0x13
  8017c2:	e8 7f fc ff ff       	call   801446 <syscall>
  8017c7:	83 c4 18             	add    $0x18,%esp
	return ;
  8017ca:	90                   	nop
}
  8017cb:	c9                   	leave  
  8017cc:	c3                   	ret    

008017cd <sys_rcr2>:
uint32 sys_rcr2()
{
  8017cd:	55                   	push   %ebp
  8017ce:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8017d0:	6a 00                	push   $0x0
  8017d2:	6a 00                	push   $0x0
  8017d4:	6a 00                	push   $0x0
  8017d6:	6a 00                	push   $0x0
  8017d8:	6a 00                	push   $0x0
  8017da:	6a 1e                	push   $0x1e
  8017dc:	e8 65 fc ff ff       	call   801446 <syscall>
  8017e1:	83 c4 18             	add    $0x18,%esp
}
  8017e4:	c9                   	leave  
  8017e5:	c3                   	ret    

008017e6 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  8017e6:	55                   	push   %ebp
  8017e7:	89 e5                	mov    %esp,%ebp
  8017e9:	83 ec 04             	sub    $0x4,%esp
  8017ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8017ef:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8017f2:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8017f6:	6a 00                	push   $0x0
  8017f8:	6a 00                	push   $0x0
  8017fa:	6a 00                	push   $0x0
  8017fc:	6a 00                	push   $0x0
  8017fe:	50                   	push   %eax
  8017ff:	6a 1f                	push   $0x1f
  801801:	e8 40 fc ff ff       	call   801446 <syscall>
  801806:	83 c4 18             	add    $0x18,%esp
	return ;
  801809:	90                   	nop
}
  80180a:	c9                   	leave  
  80180b:	c3                   	ret    

0080180c <rsttst>:
void rsttst()
{
  80180c:	55                   	push   %ebp
  80180d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  80180f:	6a 00                	push   $0x0
  801811:	6a 00                	push   $0x0
  801813:	6a 00                	push   $0x0
  801815:	6a 00                	push   $0x0
  801817:	6a 00                	push   $0x0
  801819:	6a 21                	push   $0x21
  80181b:	e8 26 fc ff ff       	call   801446 <syscall>
  801820:	83 c4 18             	add    $0x18,%esp
	return ;
  801823:	90                   	nop
}
  801824:	c9                   	leave  
  801825:	c3                   	ret    

00801826 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801826:	55                   	push   %ebp
  801827:	89 e5                	mov    %esp,%ebp
  801829:	83 ec 04             	sub    $0x4,%esp
  80182c:	8b 45 14             	mov    0x14(%ebp),%eax
  80182f:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801832:	8b 55 18             	mov    0x18(%ebp),%edx
  801835:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801839:	52                   	push   %edx
  80183a:	50                   	push   %eax
  80183b:	ff 75 10             	pushl  0x10(%ebp)
  80183e:	ff 75 0c             	pushl  0xc(%ebp)
  801841:	ff 75 08             	pushl  0x8(%ebp)
  801844:	6a 20                	push   $0x20
  801846:	e8 fb fb ff ff       	call   801446 <syscall>
  80184b:	83 c4 18             	add    $0x18,%esp
	return ;
  80184e:	90                   	nop
}
  80184f:	c9                   	leave  
  801850:	c3                   	ret    

00801851 <chktst>:
void chktst(uint32 n)
{
  801851:	55                   	push   %ebp
  801852:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801854:	6a 00                	push   $0x0
  801856:	6a 00                	push   $0x0
  801858:	6a 00                	push   $0x0
  80185a:	6a 00                	push   $0x0
  80185c:	ff 75 08             	pushl  0x8(%ebp)
  80185f:	6a 22                	push   $0x22
  801861:	e8 e0 fb ff ff       	call   801446 <syscall>
  801866:	83 c4 18             	add    $0x18,%esp
	return ;
  801869:	90                   	nop
}
  80186a:	c9                   	leave  
  80186b:	c3                   	ret    

0080186c <inctst>:

void inctst()
{
  80186c:	55                   	push   %ebp
  80186d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  80186f:	6a 00                	push   $0x0
  801871:	6a 00                	push   $0x0
  801873:	6a 00                	push   $0x0
  801875:	6a 00                	push   $0x0
  801877:	6a 00                	push   $0x0
  801879:	6a 23                	push   $0x23
  80187b:	e8 c6 fb ff ff       	call   801446 <syscall>
  801880:	83 c4 18             	add    $0x18,%esp
	return ;
  801883:	90                   	nop
}
  801884:	c9                   	leave  
  801885:	c3                   	ret    

00801886 <gettst>:
uint32 gettst()
{
  801886:	55                   	push   %ebp
  801887:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801889:	6a 00                	push   $0x0
  80188b:	6a 00                	push   $0x0
  80188d:	6a 00                	push   $0x0
  80188f:	6a 00                	push   $0x0
  801891:	6a 00                	push   $0x0
  801893:	6a 24                	push   $0x24
  801895:	e8 ac fb ff ff       	call   801446 <syscall>
  80189a:	83 c4 18             	add    $0x18,%esp
}
  80189d:	c9                   	leave  
  80189e:	c3                   	ret    

0080189f <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  80189f:	55                   	push   %ebp
  8018a0:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8018a2:	6a 00                	push   $0x0
  8018a4:	6a 00                	push   $0x0
  8018a6:	6a 00                	push   $0x0
  8018a8:	6a 00                	push   $0x0
  8018aa:	6a 00                	push   $0x0
  8018ac:	6a 25                	push   $0x25
  8018ae:	e8 93 fb ff ff       	call   801446 <syscall>
  8018b3:	83 c4 18             	add    $0x18,%esp
  8018b6:	a3 80 f2 81 00       	mov    %eax,0x81f280
	return uheapPlaceStrategy ;
  8018bb:	a1 80 f2 81 00       	mov    0x81f280,%eax
}
  8018c0:	c9                   	leave  
  8018c1:	c3                   	ret    

008018c2 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  8018c2:	55                   	push   %ebp
  8018c3:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  8018c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8018c8:	a3 80 f2 81 00       	mov    %eax,0x81f280
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  8018cd:	6a 00                	push   $0x0
  8018cf:	6a 00                	push   $0x0
  8018d1:	6a 00                	push   $0x0
  8018d3:	6a 00                	push   $0x0
  8018d5:	ff 75 08             	pushl  0x8(%ebp)
  8018d8:	6a 26                	push   $0x26
  8018da:	e8 67 fb ff ff       	call   801446 <syscall>
  8018df:	83 c4 18             	add    $0x18,%esp
	return ;
  8018e2:	90                   	nop
}
  8018e3:	c9                   	leave  
  8018e4:	c3                   	ret    

008018e5 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  8018e5:	55                   	push   %ebp
  8018e6:	89 e5                	mov    %esp,%ebp
  8018e8:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  8018e9:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8018ec:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8018ef:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8018f5:	6a 00                	push   $0x0
  8018f7:	53                   	push   %ebx
  8018f8:	51                   	push   %ecx
  8018f9:	52                   	push   %edx
  8018fa:	50                   	push   %eax
  8018fb:	6a 27                	push   $0x27
  8018fd:	e8 44 fb ff ff       	call   801446 <syscall>
  801902:	83 c4 18             	add    $0x18,%esp
}
  801905:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801908:	c9                   	leave  
  801909:	c3                   	ret    

0080190a <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  80190a:	55                   	push   %ebp
  80190b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  80190d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801910:	8b 45 08             	mov    0x8(%ebp),%eax
  801913:	6a 00                	push   $0x0
  801915:	6a 00                	push   $0x0
  801917:	6a 00                	push   $0x0
  801919:	52                   	push   %edx
  80191a:	50                   	push   %eax
  80191b:	6a 28                	push   $0x28
  80191d:	e8 24 fb ff ff       	call   801446 <syscall>
  801922:	83 c4 18             	add    $0x18,%esp
}
  801925:	c9                   	leave  
  801926:	c3                   	ret    

00801927 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801927:	55                   	push   %ebp
  801928:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  80192a:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80192d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801930:	8b 45 08             	mov    0x8(%ebp),%eax
  801933:	6a 00                	push   $0x0
  801935:	51                   	push   %ecx
  801936:	ff 75 10             	pushl  0x10(%ebp)
  801939:	52                   	push   %edx
  80193a:	50                   	push   %eax
  80193b:	6a 29                	push   $0x29
  80193d:	e8 04 fb ff ff       	call   801446 <syscall>
  801942:	83 c4 18             	add    $0x18,%esp
}
  801945:	c9                   	leave  
  801946:	c3                   	ret    

00801947 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801947:	55                   	push   %ebp
  801948:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  80194a:	6a 00                	push   $0x0
  80194c:	6a 00                	push   $0x0
  80194e:	ff 75 10             	pushl  0x10(%ebp)
  801951:	ff 75 0c             	pushl  0xc(%ebp)
  801954:	ff 75 08             	pushl  0x8(%ebp)
  801957:	6a 12                	push   $0x12
  801959:	e8 e8 fa ff ff       	call   801446 <syscall>
  80195e:	83 c4 18             	add    $0x18,%esp
	return ;
  801961:	90                   	nop
}
  801962:	c9                   	leave  
  801963:	c3                   	ret    

00801964 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  801964:	55                   	push   %ebp
  801965:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  801967:	8b 55 0c             	mov    0xc(%ebp),%edx
  80196a:	8b 45 08             	mov    0x8(%ebp),%eax
  80196d:	6a 00                	push   $0x0
  80196f:	6a 00                	push   $0x0
  801971:	6a 00                	push   $0x0
  801973:	52                   	push   %edx
  801974:	50                   	push   %eax
  801975:	6a 2a                	push   $0x2a
  801977:	e8 ca fa ff ff       	call   801446 <syscall>
  80197c:	83 c4 18             	add    $0x18,%esp
	return;
  80197f:	90                   	nop
}
  801980:	c9                   	leave  
  801981:	c3                   	ret    

00801982 <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  801982:	55                   	push   %ebp
  801983:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  801985:	6a 00                	push   $0x0
  801987:	6a 00                	push   $0x0
  801989:	6a 00                	push   $0x0
  80198b:	6a 00                	push   $0x0
  80198d:	6a 00                	push   $0x0
  80198f:	6a 2b                	push   $0x2b
  801991:	e8 b0 fa ff ff       	call   801446 <syscall>
  801996:	83 c4 18             	add    $0x18,%esp
}
  801999:	c9                   	leave  
  80199a:	c3                   	ret    

0080199b <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  80199b:	55                   	push   %ebp
  80199c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  80199e:	6a 00                	push   $0x0
  8019a0:	6a 00                	push   $0x0
  8019a2:	6a 00                	push   $0x0
  8019a4:	ff 75 0c             	pushl  0xc(%ebp)
  8019a7:	ff 75 08             	pushl  0x8(%ebp)
  8019aa:	6a 2d                	push   $0x2d
  8019ac:	e8 95 fa ff ff       	call   801446 <syscall>
  8019b1:	83 c4 18             	add    $0x18,%esp
	return;
  8019b4:	90                   	nop
}
  8019b5:	c9                   	leave  
  8019b6:	c3                   	ret    

008019b7 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8019b7:	55                   	push   %ebp
  8019b8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  8019ba:	6a 00                	push   $0x0
  8019bc:	6a 00                	push   $0x0
  8019be:	6a 00                	push   $0x0
  8019c0:	ff 75 0c             	pushl  0xc(%ebp)
  8019c3:	ff 75 08             	pushl  0x8(%ebp)
  8019c6:	6a 2c                	push   $0x2c
  8019c8:	e8 79 fa ff ff       	call   801446 <syscall>
  8019cd:	83 c4 18             	add    $0x18,%esp
	return ;
  8019d0:	90                   	nop
}
  8019d1:	c9                   	leave  
  8019d2:	c3                   	ret    

008019d3 <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  8019d3:	55                   	push   %ebp
  8019d4:	89 e5                	mov    %esp,%ebp
	//TODO: [PROJECT'25.IM#4] CPU SCHEDULING - #1 System Calls - Add suitable code here
	//Your code is here
	//Comment the following line
	//panic("sys_env_set_priority() is not implemented yet...!!");
	syscall(SYS_env_set_priority, envID, priority, 0, 0, 0);
  8019d6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8019dc:	6a 00                	push   $0x0
  8019de:	6a 00                	push   $0x0
  8019e0:	6a 00                	push   $0x0
  8019e2:	52                   	push   %edx
  8019e3:	50                   	push   %eax
  8019e4:	6a 2e                	push   $0x2e
  8019e6:	e8 5b fa ff ff       	call   801446 <syscall>
  8019eb:	83 c4 18             	add    $0x18,%esp
	    return;
  8019ee:	90                   	nop
}
  8019ef:	c9                   	leave  
  8019f0:	c3                   	ret    
  8019f1:	66 90                	xchg   %ax,%ax
  8019f3:	90                   	nop

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
