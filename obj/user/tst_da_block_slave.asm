
obj/user/tst_da_block_slave:     file format elf32-i386


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
  800031:	e8 1c 00 00 00       	call   800052 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
// Master program: create the semaphores, run slaves and wait them to finish
#include <inc/lib.h>

void
_main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	83 ec 18             	sub    $0x18,%esp
	panic("UPDATE IS REQUIRED");
  80003e:	83 ec 04             	sub    $0x4,%esp
  800041:	68 e0 1b 80 00       	push   $0x801be0
  800046:	6a 08                	push   $0x8
  800048:	68 f3 1b 80 00       	push   $0x801bf3
  80004d:	e8 b9 01 00 00       	call   80020b <_panic>

00800052 <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  800052:	55                   	push   %ebp
  800053:	89 e5                	mov    %esp,%ebp
  800055:	57                   	push   %edi
  800056:	56                   	push   %esi
  800057:	53                   	push   %ebx
  800058:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  80005b:	e8 46 16 00 00       	call   8016a6 <sys_getenvindex>
  800060:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  800063:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800066:	89 d0                	mov    %edx,%eax
  800068:	c1 e0 02             	shl    $0x2,%eax
  80006b:	01 d0                	add    %edx,%eax
  80006d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800074:	01 d0                	add    %edx,%eax
  800076:	89 c2                	mov    %eax,%edx
  800078:	c1 e2 04             	shl    $0x4,%edx
  80007b:	29 c2                	sub    %eax,%edx
  80007d:	8d 04 95 00 00 00 00 	lea    0x0(,%edx,4),%eax
  800084:	89 c2                	mov    %eax,%edx
  800086:	8d 82 00 00 c0 ee    	lea    -0x11400000(%edx),%eax
  80008c:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800091:	a1 20 30 80 00       	mov    0x803020,%eax
  800096:	8a 40 20             	mov    0x20(%eax),%al
  800099:	84 c0                	test   %al,%al
  80009b:	74 0d                	je     8000aa <libmain+0x58>
		binaryname = myEnv->prog_name;
  80009d:	a1 20 30 80 00       	mov    0x803020,%eax
  8000a2:	83 c0 20             	add    $0x20,%eax
  8000a5:	a3 04 30 80 00       	mov    %eax,0x803004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000aa:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8000ae:	7e 0a                	jle    8000ba <libmain+0x68>
		binaryname = argv[0];
  8000b0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8000b3:	8b 00                	mov    (%eax),%eax
  8000b5:	a3 04 30 80 00       	mov    %eax,0x803004

	// call user main routine
	_main(argc, argv);
  8000ba:	83 ec 08             	sub    $0x8,%esp
  8000bd:	ff 75 0c             	pushl  0xc(%ebp)
  8000c0:	ff 75 08             	pushl  0x8(%ebp)
  8000c3:	e8 70 ff ff ff       	call   800038 <_main>
  8000c8:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  8000cb:	a1 00 30 80 00       	mov    0x803000,%eax
  8000d0:	85 c0                	test   %eax,%eax
  8000d2:	0f 84 01 01 00 00    	je     8001d9 <libmain+0x187>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  8000d8:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  8000de:	bb 08 1d 80 00       	mov    $0x801d08,%ebx
  8000e3:	ba 0e 00 00 00       	mov    $0xe,%edx
  8000e8:	89 c7                	mov    %eax,%edi
  8000ea:	89 de                	mov    %ebx,%esi
  8000ec:	89 d1                	mov    %edx,%ecx
  8000ee:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  8000f0:	8d 55 8a             	lea    -0x76(%ebp),%edx
  8000f3:	b9 56 00 00 00       	mov    $0x56,%ecx
  8000f8:	b0 00                	mov    $0x0,%al
  8000fa:	89 d7                	mov    %edx,%edi
  8000fc:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  8000fe:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  800105:	8d 45 e0             	lea    -0x20(%ebp),%eax
  800108:	83 ec 08             	sub    $0x8,%esp
  80010b:	50                   	push   %eax
  80010c:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  800112:	50                   	push   %eax
  800113:	e8 c4 17 00 00       	call   8018dc <sys_utilities>
  800118:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  80011b:	e8 0d 13 00 00       	call   80142d <sys_lock_cons>
		{
			cprintf("**************************************\n");
  800120:	83 ec 0c             	sub    $0xc,%esp
  800123:	68 28 1c 80 00       	push   $0x801c28
  800128:	e8 ac 03 00 00       	call   8004d9 <cprintf>
  80012d:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  800130:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800133:	85 c0                	test   %eax,%eax
  800135:	74 18                	je     80014f <libmain+0xfd>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  800137:	e8 be 17 00 00       	call   8018fa <sys_get_optimal_num_faults>
  80013c:	83 ec 08             	sub    $0x8,%esp
  80013f:	50                   	push   %eax
  800140:	68 50 1c 80 00       	push   $0x801c50
  800145:	e8 8f 03 00 00       	call   8004d9 <cprintf>
  80014a:	83 c4 10             	add    $0x10,%esp
  80014d:	eb 59                	jmp    8001a8 <libmain+0x156>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  80014f:	a1 20 30 80 00       	mov    0x803020,%eax
  800154:	8b 90 bc 05 00 00    	mov    0x5bc(%eax),%edx
  80015a:	a1 20 30 80 00       	mov    0x803020,%eax
  80015f:	8b 80 ac 05 00 00    	mov    0x5ac(%eax),%eax
  800165:	83 ec 04             	sub    $0x4,%esp
  800168:	52                   	push   %edx
  800169:	50                   	push   %eax
  80016a:	68 74 1c 80 00       	push   $0x801c74
  80016f:	e8 65 03 00 00       	call   8004d9 <cprintf>
  800174:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800177:	a1 20 30 80 00       	mov    0x803020,%eax
  80017c:	8b 88 d0 05 00 00    	mov    0x5d0(%eax),%ecx
  800182:	a1 20 30 80 00       	mov    0x803020,%eax
  800187:	8b 90 cc 05 00 00    	mov    0x5cc(%eax),%edx
  80018d:	a1 20 30 80 00       	mov    0x803020,%eax
  800192:	8b 80 c8 05 00 00    	mov    0x5c8(%eax),%eax
  800198:	51                   	push   %ecx
  800199:	52                   	push   %edx
  80019a:	50                   	push   %eax
  80019b:	68 9c 1c 80 00       	push   $0x801c9c
  8001a0:	e8 34 03 00 00       	call   8004d9 <cprintf>
  8001a5:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8001a8:	a1 20 30 80 00       	mov    0x803020,%eax
  8001ad:	8b 80 d4 05 00 00    	mov    0x5d4(%eax),%eax
  8001b3:	83 ec 08             	sub    $0x8,%esp
  8001b6:	50                   	push   %eax
  8001b7:	68 f4 1c 80 00       	push   $0x801cf4
  8001bc:	e8 18 03 00 00       	call   8004d9 <cprintf>
  8001c1:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  8001c4:	83 ec 0c             	sub    $0xc,%esp
  8001c7:	68 28 1c 80 00       	push   $0x801c28
  8001cc:	e8 08 03 00 00       	call   8004d9 <cprintf>
  8001d1:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  8001d4:	e8 6e 12 00 00       	call   801447 <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  8001d9:	e8 1f 00 00 00       	call   8001fd <exit>
}
  8001de:	90                   	nop
  8001df:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8001e2:	5b                   	pop    %ebx
  8001e3:	5e                   	pop    %esi
  8001e4:	5f                   	pop    %edi
  8001e5:	5d                   	pop    %ebp
  8001e6:	c3                   	ret    

008001e7 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8001e7:	55                   	push   %ebp
  8001e8:	89 e5                	mov    %esp,%ebp
  8001ea:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8001ed:	83 ec 0c             	sub    $0xc,%esp
  8001f0:	6a 00                	push   $0x0
  8001f2:	e8 7b 14 00 00       	call   801672 <sys_destroy_env>
  8001f7:	83 c4 10             	add    $0x10,%esp
}
  8001fa:	90                   	nop
  8001fb:	c9                   	leave  
  8001fc:	c3                   	ret    

008001fd <exit>:

void
exit(void)
{
  8001fd:	55                   	push   %ebp
  8001fe:	89 e5                	mov    %esp,%ebp
  800200:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800203:	e8 d0 14 00 00       	call   8016d8 <sys_exit_env>
}
  800208:	90                   	nop
  800209:	c9                   	leave  
  80020a:	c3                   	ret    

0080020b <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  80020b:	55                   	push   %ebp
  80020c:	89 e5                	mov    %esp,%ebp
  80020e:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800211:	8d 45 10             	lea    0x10(%ebp),%eax
  800214:	83 c0 04             	add    $0x4,%eax
  800217:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  80021a:	a1 18 b1 81 00       	mov    0x81b118,%eax
  80021f:	85 c0                	test   %eax,%eax
  800221:	74 16                	je     800239 <_panic+0x2e>
		cprintf("%s: ", argv0);
  800223:	a1 18 b1 81 00       	mov    0x81b118,%eax
  800228:	83 ec 08             	sub    $0x8,%esp
  80022b:	50                   	push   %eax
  80022c:	68 6c 1d 80 00       	push   $0x801d6c
  800231:	e8 a3 02 00 00       	call   8004d9 <cprintf>
  800236:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  800239:	a1 04 30 80 00       	mov    0x803004,%eax
  80023e:	83 ec 0c             	sub    $0xc,%esp
  800241:	ff 75 0c             	pushl  0xc(%ebp)
  800244:	ff 75 08             	pushl  0x8(%ebp)
  800247:	50                   	push   %eax
  800248:	68 74 1d 80 00       	push   $0x801d74
  80024d:	6a 74                	push   $0x74
  80024f:	e8 b2 02 00 00       	call   800506 <cprintf_colored>
  800254:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  800257:	8b 45 10             	mov    0x10(%ebp),%eax
  80025a:	83 ec 08             	sub    $0x8,%esp
  80025d:	ff 75 f4             	pushl  -0xc(%ebp)
  800260:	50                   	push   %eax
  800261:	e8 04 02 00 00       	call   80046a <vcprintf>
  800266:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800269:	83 ec 08             	sub    $0x8,%esp
  80026c:	6a 00                	push   $0x0
  80026e:	68 9c 1d 80 00       	push   $0x801d9c
  800273:	e8 f2 01 00 00       	call   80046a <vcprintf>
  800278:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  80027b:	e8 7d ff ff ff       	call   8001fd <exit>

	// should not return here
	while (1) ;
  800280:	eb fe                	jmp    800280 <_panic+0x75>

00800282 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800282:	55                   	push   %ebp
  800283:	89 e5                	mov    %esp,%ebp
  800285:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800288:	a1 20 30 80 00       	mov    0x803020,%eax
  80028d:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800293:	8b 45 0c             	mov    0xc(%ebp),%eax
  800296:	39 c2                	cmp    %eax,%edx
  800298:	74 14                	je     8002ae <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  80029a:	83 ec 04             	sub    $0x4,%esp
  80029d:	68 a0 1d 80 00       	push   $0x801da0
  8002a2:	6a 26                	push   $0x26
  8002a4:	68 ec 1d 80 00       	push   $0x801dec
  8002a9:	e8 5d ff ff ff       	call   80020b <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8002ae:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8002b5:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8002bc:	e9 c5 00 00 00       	jmp    800386 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  8002c1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8002c4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8002cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8002ce:	01 d0                	add    %edx,%eax
  8002d0:	8b 00                	mov    (%eax),%eax
  8002d2:	85 c0                	test   %eax,%eax
  8002d4:	75 08                	jne    8002de <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  8002d6:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8002d9:	e9 a5 00 00 00       	jmp    800383 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  8002de:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8002e5:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8002ec:	eb 69                	jmp    800357 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8002ee:	a1 20 30 80 00       	mov    0x803020,%eax
  8002f3:	8b 88 a4 05 00 00    	mov    0x5a4(%eax),%ecx
  8002f9:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8002fc:	89 d0                	mov    %edx,%eax
  8002fe:	01 c0                	add    %eax,%eax
  800300:	01 d0                	add    %edx,%eax
  800302:	c1 e0 03             	shl    $0x3,%eax
  800305:	01 c8                	add    %ecx,%eax
  800307:	8a 40 04             	mov    0x4(%eax),%al
  80030a:	84 c0                	test   %al,%al
  80030c:	75 46                	jne    800354 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80030e:	a1 20 30 80 00       	mov    0x803020,%eax
  800313:	8b 88 a4 05 00 00    	mov    0x5a4(%eax),%ecx
  800319:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80031c:	89 d0                	mov    %edx,%eax
  80031e:	01 c0                	add    %eax,%eax
  800320:	01 d0                	add    %edx,%eax
  800322:	c1 e0 03             	shl    $0x3,%eax
  800325:	01 c8                	add    %ecx,%eax
  800327:	8b 00                	mov    (%eax),%eax
  800329:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80032c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80032f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800334:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800336:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800339:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800340:	8b 45 08             	mov    0x8(%ebp),%eax
  800343:	01 c8                	add    %ecx,%eax
  800345:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800347:	39 c2                	cmp    %eax,%edx
  800349:	75 09                	jne    800354 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  80034b:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800352:	eb 15                	jmp    800369 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800354:	ff 45 e8             	incl   -0x18(%ebp)
  800357:	a1 20 30 80 00       	mov    0x803020,%eax
  80035c:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800362:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800365:	39 c2                	cmp    %eax,%edx
  800367:	77 85                	ja     8002ee <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800369:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80036d:	75 14                	jne    800383 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  80036f:	83 ec 04             	sub    $0x4,%esp
  800372:	68 f8 1d 80 00       	push   $0x801df8
  800377:	6a 3a                	push   $0x3a
  800379:	68 ec 1d 80 00       	push   $0x801dec
  80037e:	e8 88 fe ff ff       	call   80020b <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800383:	ff 45 f0             	incl   -0x10(%ebp)
  800386:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800389:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80038c:	0f 8c 2f ff ff ff    	jl     8002c1 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800392:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800399:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8003a0:	eb 26                	jmp    8003c8 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  8003a2:	a1 20 30 80 00       	mov    0x803020,%eax
  8003a7:	8b 88 a4 05 00 00    	mov    0x5a4(%eax),%ecx
  8003ad:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8003b0:	89 d0                	mov    %edx,%eax
  8003b2:	01 c0                	add    %eax,%eax
  8003b4:	01 d0                	add    %edx,%eax
  8003b6:	c1 e0 03             	shl    $0x3,%eax
  8003b9:	01 c8                	add    %ecx,%eax
  8003bb:	8a 40 04             	mov    0x4(%eax),%al
  8003be:	3c 01                	cmp    $0x1,%al
  8003c0:	75 03                	jne    8003c5 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  8003c2:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8003c5:	ff 45 e0             	incl   -0x20(%ebp)
  8003c8:	a1 20 30 80 00       	mov    0x803020,%eax
  8003cd:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8003d3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8003d6:	39 c2                	cmp    %eax,%edx
  8003d8:	77 c8                	ja     8003a2 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8003da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8003dd:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8003e0:	74 14                	je     8003f6 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  8003e2:	83 ec 04             	sub    $0x4,%esp
  8003e5:	68 4c 1e 80 00       	push   $0x801e4c
  8003ea:	6a 44                	push   $0x44
  8003ec:	68 ec 1d 80 00       	push   $0x801dec
  8003f1:	e8 15 fe ff ff       	call   80020b <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8003f6:	90                   	nop
  8003f7:	c9                   	leave  
  8003f8:	c3                   	ret    

008003f9 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  8003f9:	55                   	push   %ebp
  8003fa:	89 e5                	mov    %esp,%ebp
  8003fc:	53                   	push   %ebx
  8003fd:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  800400:	8b 45 0c             	mov    0xc(%ebp),%eax
  800403:	8b 00                	mov    (%eax),%eax
  800405:	8d 48 01             	lea    0x1(%eax),%ecx
  800408:	8b 55 0c             	mov    0xc(%ebp),%edx
  80040b:	89 0a                	mov    %ecx,(%edx)
  80040d:	8b 55 08             	mov    0x8(%ebp),%edx
  800410:	88 d1                	mov    %dl,%cl
  800412:	8b 55 0c             	mov    0xc(%ebp),%edx
  800415:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800419:	8b 45 0c             	mov    0xc(%ebp),%eax
  80041c:	8b 00                	mov    (%eax),%eax
  80041e:	3d ff 00 00 00       	cmp    $0xff,%eax
  800423:	75 30                	jne    800455 <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  800425:	8b 15 1c b1 81 00    	mov    0x81b11c,%edx
  80042b:	a0 44 30 80 00       	mov    0x803044,%al
  800430:	0f b6 c0             	movzbl %al,%eax
  800433:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800436:	8b 09                	mov    (%ecx),%ecx
  800438:	89 cb                	mov    %ecx,%ebx
  80043a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80043d:	83 c1 08             	add    $0x8,%ecx
  800440:	52                   	push   %edx
  800441:	50                   	push   %eax
  800442:	53                   	push   %ebx
  800443:	51                   	push   %ecx
  800444:	e8 a0 0f 00 00       	call   8013e9 <sys_cputs>
  800449:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  80044c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80044f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800455:	8b 45 0c             	mov    0xc(%ebp),%eax
  800458:	8b 40 04             	mov    0x4(%eax),%eax
  80045b:	8d 50 01             	lea    0x1(%eax),%edx
  80045e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800461:	89 50 04             	mov    %edx,0x4(%eax)
}
  800464:	90                   	nop
  800465:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800468:	c9                   	leave  
  800469:	c3                   	ret    

0080046a <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  80046a:	55                   	push   %ebp
  80046b:	89 e5                	mov    %esp,%ebp
  80046d:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800473:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80047a:	00 00 00 
	b.cnt = 0;
  80047d:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800484:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800487:	ff 75 0c             	pushl  0xc(%ebp)
  80048a:	ff 75 08             	pushl  0x8(%ebp)
  80048d:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800493:	50                   	push   %eax
  800494:	68 f9 03 80 00       	push   $0x8003f9
  800499:	e8 5a 02 00 00       	call   8006f8 <vprintfmt>
  80049e:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  8004a1:	8b 15 1c b1 81 00    	mov    0x81b11c,%edx
  8004a7:	a0 44 30 80 00       	mov    0x803044,%al
  8004ac:	0f b6 c0             	movzbl %al,%eax
  8004af:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  8004b5:	52                   	push   %edx
  8004b6:	50                   	push   %eax
  8004b7:	51                   	push   %ecx
  8004b8:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8004be:	83 c0 08             	add    $0x8,%eax
  8004c1:	50                   	push   %eax
  8004c2:	e8 22 0f 00 00       	call   8013e9 <sys_cputs>
  8004c7:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8004ca:	c6 05 44 30 80 00 00 	movb   $0x0,0x803044
	return b.cnt;
  8004d1:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8004d7:	c9                   	leave  
  8004d8:	c3                   	ret    

008004d9 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  8004d9:	55                   	push   %ebp
  8004da:	89 e5                	mov    %esp,%ebp
  8004dc:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8004df:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
	va_start(ap, fmt);
  8004e6:	8d 45 0c             	lea    0xc(%ebp),%eax
  8004e9:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8004ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8004ef:	83 ec 08             	sub    $0x8,%esp
  8004f2:	ff 75 f4             	pushl  -0xc(%ebp)
  8004f5:	50                   	push   %eax
  8004f6:	e8 6f ff ff ff       	call   80046a <vcprintf>
  8004fb:	83 c4 10             	add    $0x10,%esp
  8004fe:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800501:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800504:	c9                   	leave  
  800505:	c3                   	ret    

00800506 <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  800506:	55                   	push   %ebp
  800507:	89 e5                	mov    %esp,%ebp
  800509:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  80050c:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
	curTextClr = (textClr << 8) ; //set text color by the given value
  800513:	8b 45 08             	mov    0x8(%ebp),%eax
  800516:	c1 e0 08             	shl    $0x8,%eax
  800519:	a3 1c b1 81 00       	mov    %eax,0x81b11c
	va_start(ap, fmt);
  80051e:	8d 45 0c             	lea    0xc(%ebp),%eax
  800521:	83 c0 04             	add    $0x4,%eax
  800524:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800527:	8b 45 0c             	mov    0xc(%ebp),%eax
  80052a:	83 ec 08             	sub    $0x8,%esp
  80052d:	ff 75 f4             	pushl  -0xc(%ebp)
  800530:	50                   	push   %eax
  800531:	e8 34 ff ff ff       	call   80046a <vcprintf>
  800536:	83 c4 10             	add    $0x10,%esp
  800539:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  80053c:	c7 05 1c b1 81 00 00 	movl   $0x700,0x81b11c
  800543:	07 00 00 

	return cnt;
  800546:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800549:	c9                   	leave  
  80054a:	c3                   	ret    

0080054b <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  80054b:	55                   	push   %ebp
  80054c:	89 e5                	mov    %esp,%ebp
  80054e:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  800551:	e8 d7 0e 00 00       	call   80142d <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  800556:	8d 45 0c             	lea    0xc(%ebp),%eax
  800559:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  80055c:	8b 45 08             	mov    0x8(%ebp),%eax
  80055f:	83 ec 08             	sub    $0x8,%esp
  800562:	ff 75 f4             	pushl  -0xc(%ebp)
  800565:	50                   	push   %eax
  800566:	e8 ff fe ff ff       	call   80046a <vcprintf>
  80056b:	83 c4 10             	add    $0x10,%esp
  80056e:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  800571:	e8 d1 0e 00 00       	call   801447 <sys_unlock_cons>
	return cnt;
  800576:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800579:	c9                   	leave  
  80057a:	c3                   	ret    

0080057b <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80057b:	55                   	push   %ebp
  80057c:	89 e5                	mov    %esp,%ebp
  80057e:	53                   	push   %ebx
  80057f:	83 ec 14             	sub    $0x14,%esp
  800582:	8b 45 10             	mov    0x10(%ebp),%eax
  800585:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800588:	8b 45 14             	mov    0x14(%ebp),%eax
  80058b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80058e:	8b 45 18             	mov    0x18(%ebp),%eax
  800591:	ba 00 00 00 00       	mov    $0x0,%edx
  800596:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800599:	77 55                	ja     8005f0 <printnum+0x75>
  80059b:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80059e:	72 05                	jb     8005a5 <printnum+0x2a>
  8005a0:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8005a3:	77 4b                	ja     8005f0 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8005a5:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8005a8:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8005ab:	8b 45 18             	mov    0x18(%ebp),%eax
  8005ae:	ba 00 00 00 00       	mov    $0x0,%edx
  8005b3:	52                   	push   %edx
  8005b4:	50                   	push   %eax
  8005b5:	ff 75 f4             	pushl  -0xc(%ebp)
  8005b8:	ff 75 f0             	pushl  -0x10(%ebp)
  8005bb:	e8 ac 13 00 00       	call   80196c <__udivdi3>
  8005c0:	83 c4 10             	add    $0x10,%esp
  8005c3:	83 ec 04             	sub    $0x4,%esp
  8005c6:	ff 75 20             	pushl  0x20(%ebp)
  8005c9:	53                   	push   %ebx
  8005ca:	ff 75 18             	pushl  0x18(%ebp)
  8005cd:	52                   	push   %edx
  8005ce:	50                   	push   %eax
  8005cf:	ff 75 0c             	pushl  0xc(%ebp)
  8005d2:	ff 75 08             	pushl  0x8(%ebp)
  8005d5:	e8 a1 ff ff ff       	call   80057b <printnum>
  8005da:	83 c4 20             	add    $0x20,%esp
  8005dd:	eb 1a                	jmp    8005f9 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8005df:	83 ec 08             	sub    $0x8,%esp
  8005e2:	ff 75 0c             	pushl  0xc(%ebp)
  8005e5:	ff 75 20             	pushl  0x20(%ebp)
  8005e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8005eb:	ff d0                	call   *%eax
  8005ed:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8005f0:	ff 4d 1c             	decl   0x1c(%ebp)
  8005f3:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  8005f7:	7f e6                	jg     8005df <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8005f9:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8005fc:	bb 00 00 00 00       	mov    $0x0,%ebx
  800601:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800604:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800607:	53                   	push   %ebx
  800608:	51                   	push   %ecx
  800609:	52                   	push   %edx
  80060a:	50                   	push   %eax
  80060b:	e8 6c 14 00 00       	call   801a7c <__umoddi3>
  800610:	83 c4 10             	add    $0x10,%esp
  800613:	05 b4 20 80 00       	add    $0x8020b4,%eax
  800618:	8a 00                	mov    (%eax),%al
  80061a:	0f be c0             	movsbl %al,%eax
  80061d:	83 ec 08             	sub    $0x8,%esp
  800620:	ff 75 0c             	pushl  0xc(%ebp)
  800623:	50                   	push   %eax
  800624:	8b 45 08             	mov    0x8(%ebp),%eax
  800627:	ff d0                	call   *%eax
  800629:	83 c4 10             	add    $0x10,%esp
}
  80062c:	90                   	nop
  80062d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800630:	c9                   	leave  
  800631:	c3                   	ret    

00800632 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800632:	55                   	push   %ebp
  800633:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800635:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800639:	7e 1c                	jle    800657 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  80063b:	8b 45 08             	mov    0x8(%ebp),%eax
  80063e:	8b 00                	mov    (%eax),%eax
  800640:	8d 50 08             	lea    0x8(%eax),%edx
  800643:	8b 45 08             	mov    0x8(%ebp),%eax
  800646:	89 10                	mov    %edx,(%eax)
  800648:	8b 45 08             	mov    0x8(%ebp),%eax
  80064b:	8b 00                	mov    (%eax),%eax
  80064d:	83 e8 08             	sub    $0x8,%eax
  800650:	8b 50 04             	mov    0x4(%eax),%edx
  800653:	8b 00                	mov    (%eax),%eax
  800655:	eb 40                	jmp    800697 <getuint+0x65>
	else if (lflag)
  800657:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80065b:	74 1e                	je     80067b <getuint+0x49>
		return va_arg(*ap, unsigned long);
  80065d:	8b 45 08             	mov    0x8(%ebp),%eax
  800660:	8b 00                	mov    (%eax),%eax
  800662:	8d 50 04             	lea    0x4(%eax),%edx
  800665:	8b 45 08             	mov    0x8(%ebp),%eax
  800668:	89 10                	mov    %edx,(%eax)
  80066a:	8b 45 08             	mov    0x8(%ebp),%eax
  80066d:	8b 00                	mov    (%eax),%eax
  80066f:	83 e8 04             	sub    $0x4,%eax
  800672:	8b 00                	mov    (%eax),%eax
  800674:	ba 00 00 00 00       	mov    $0x0,%edx
  800679:	eb 1c                	jmp    800697 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  80067b:	8b 45 08             	mov    0x8(%ebp),%eax
  80067e:	8b 00                	mov    (%eax),%eax
  800680:	8d 50 04             	lea    0x4(%eax),%edx
  800683:	8b 45 08             	mov    0x8(%ebp),%eax
  800686:	89 10                	mov    %edx,(%eax)
  800688:	8b 45 08             	mov    0x8(%ebp),%eax
  80068b:	8b 00                	mov    (%eax),%eax
  80068d:	83 e8 04             	sub    $0x4,%eax
  800690:	8b 00                	mov    (%eax),%eax
  800692:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800697:	5d                   	pop    %ebp
  800698:	c3                   	ret    

00800699 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800699:	55                   	push   %ebp
  80069a:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80069c:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8006a0:	7e 1c                	jle    8006be <getint+0x25>
		return va_arg(*ap, long long);
  8006a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8006a5:	8b 00                	mov    (%eax),%eax
  8006a7:	8d 50 08             	lea    0x8(%eax),%edx
  8006aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ad:	89 10                	mov    %edx,(%eax)
  8006af:	8b 45 08             	mov    0x8(%ebp),%eax
  8006b2:	8b 00                	mov    (%eax),%eax
  8006b4:	83 e8 08             	sub    $0x8,%eax
  8006b7:	8b 50 04             	mov    0x4(%eax),%edx
  8006ba:	8b 00                	mov    (%eax),%eax
  8006bc:	eb 38                	jmp    8006f6 <getint+0x5d>
	else if (lflag)
  8006be:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8006c2:	74 1a                	je     8006de <getint+0x45>
		return va_arg(*ap, long);
  8006c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8006c7:	8b 00                	mov    (%eax),%eax
  8006c9:	8d 50 04             	lea    0x4(%eax),%edx
  8006cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8006cf:	89 10                	mov    %edx,(%eax)
  8006d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8006d4:	8b 00                	mov    (%eax),%eax
  8006d6:	83 e8 04             	sub    $0x4,%eax
  8006d9:	8b 00                	mov    (%eax),%eax
  8006db:	99                   	cltd   
  8006dc:	eb 18                	jmp    8006f6 <getint+0x5d>
	else
		return va_arg(*ap, int);
  8006de:	8b 45 08             	mov    0x8(%ebp),%eax
  8006e1:	8b 00                	mov    (%eax),%eax
  8006e3:	8d 50 04             	lea    0x4(%eax),%edx
  8006e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8006e9:	89 10                	mov    %edx,(%eax)
  8006eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ee:	8b 00                	mov    (%eax),%eax
  8006f0:	83 e8 04             	sub    $0x4,%eax
  8006f3:	8b 00                	mov    (%eax),%eax
  8006f5:	99                   	cltd   
}
  8006f6:	5d                   	pop    %ebp
  8006f7:	c3                   	ret    

008006f8 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8006f8:	55                   	push   %ebp
  8006f9:	89 e5                	mov    %esp,%ebp
  8006fb:	56                   	push   %esi
  8006fc:	53                   	push   %ebx
  8006fd:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800700:	eb 17                	jmp    800719 <vprintfmt+0x21>
			if (ch == '\0')
  800702:	85 db                	test   %ebx,%ebx
  800704:	0f 84 c1 03 00 00    	je     800acb <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  80070a:	83 ec 08             	sub    $0x8,%esp
  80070d:	ff 75 0c             	pushl  0xc(%ebp)
  800710:	53                   	push   %ebx
  800711:	8b 45 08             	mov    0x8(%ebp),%eax
  800714:	ff d0                	call   *%eax
  800716:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800719:	8b 45 10             	mov    0x10(%ebp),%eax
  80071c:	8d 50 01             	lea    0x1(%eax),%edx
  80071f:	89 55 10             	mov    %edx,0x10(%ebp)
  800722:	8a 00                	mov    (%eax),%al
  800724:	0f b6 d8             	movzbl %al,%ebx
  800727:	83 fb 25             	cmp    $0x25,%ebx
  80072a:	75 d6                	jne    800702 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  80072c:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800730:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800737:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80073e:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800745:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80074c:	8b 45 10             	mov    0x10(%ebp),%eax
  80074f:	8d 50 01             	lea    0x1(%eax),%edx
  800752:	89 55 10             	mov    %edx,0x10(%ebp)
  800755:	8a 00                	mov    (%eax),%al
  800757:	0f b6 d8             	movzbl %al,%ebx
  80075a:	8d 43 dd             	lea    -0x23(%ebx),%eax
  80075d:	83 f8 5b             	cmp    $0x5b,%eax
  800760:	0f 87 3d 03 00 00    	ja     800aa3 <vprintfmt+0x3ab>
  800766:	8b 04 85 d8 20 80 00 	mov    0x8020d8(,%eax,4),%eax
  80076d:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  80076f:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800773:	eb d7                	jmp    80074c <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800775:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800779:	eb d1                	jmp    80074c <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80077b:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800782:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800785:	89 d0                	mov    %edx,%eax
  800787:	c1 e0 02             	shl    $0x2,%eax
  80078a:	01 d0                	add    %edx,%eax
  80078c:	01 c0                	add    %eax,%eax
  80078e:	01 d8                	add    %ebx,%eax
  800790:	83 e8 30             	sub    $0x30,%eax
  800793:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800796:	8b 45 10             	mov    0x10(%ebp),%eax
  800799:	8a 00                	mov    (%eax),%al
  80079b:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  80079e:	83 fb 2f             	cmp    $0x2f,%ebx
  8007a1:	7e 3e                	jle    8007e1 <vprintfmt+0xe9>
  8007a3:	83 fb 39             	cmp    $0x39,%ebx
  8007a6:	7f 39                	jg     8007e1 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8007a8:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8007ab:	eb d5                	jmp    800782 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8007ad:	8b 45 14             	mov    0x14(%ebp),%eax
  8007b0:	83 c0 04             	add    $0x4,%eax
  8007b3:	89 45 14             	mov    %eax,0x14(%ebp)
  8007b6:	8b 45 14             	mov    0x14(%ebp),%eax
  8007b9:	83 e8 04             	sub    $0x4,%eax
  8007bc:	8b 00                	mov    (%eax),%eax
  8007be:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8007c1:	eb 1f                	jmp    8007e2 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8007c3:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8007c7:	79 83                	jns    80074c <vprintfmt+0x54>
				width = 0;
  8007c9:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8007d0:	e9 77 ff ff ff       	jmp    80074c <vprintfmt+0x54>

		case '#':
			altflag = 1;
  8007d5:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  8007dc:	e9 6b ff ff ff       	jmp    80074c <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  8007e1:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8007e2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8007e6:	0f 89 60 ff ff ff    	jns    80074c <vprintfmt+0x54>
				width = precision, precision = -1;
  8007ec:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8007ef:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8007f2:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  8007f9:	e9 4e ff ff ff       	jmp    80074c <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8007fe:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800801:	e9 46 ff ff ff       	jmp    80074c <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800806:	8b 45 14             	mov    0x14(%ebp),%eax
  800809:	83 c0 04             	add    $0x4,%eax
  80080c:	89 45 14             	mov    %eax,0x14(%ebp)
  80080f:	8b 45 14             	mov    0x14(%ebp),%eax
  800812:	83 e8 04             	sub    $0x4,%eax
  800815:	8b 00                	mov    (%eax),%eax
  800817:	83 ec 08             	sub    $0x8,%esp
  80081a:	ff 75 0c             	pushl  0xc(%ebp)
  80081d:	50                   	push   %eax
  80081e:	8b 45 08             	mov    0x8(%ebp),%eax
  800821:	ff d0                	call   *%eax
  800823:	83 c4 10             	add    $0x10,%esp
			break;
  800826:	e9 9b 02 00 00       	jmp    800ac6 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  80082b:	8b 45 14             	mov    0x14(%ebp),%eax
  80082e:	83 c0 04             	add    $0x4,%eax
  800831:	89 45 14             	mov    %eax,0x14(%ebp)
  800834:	8b 45 14             	mov    0x14(%ebp),%eax
  800837:	83 e8 04             	sub    $0x4,%eax
  80083a:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  80083c:	85 db                	test   %ebx,%ebx
  80083e:	79 02                	jns    800842 <vprintfmt+0x14a>
				err = -err;
  800840:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800842:	83 fb 64             	cmp    $0x64,%ebx
  800845:	7f 0b                	jg     800852 <vprintfmt+0x15a>
  800847:	8b 34 9d 20 1f 80 00 	mov    0x801f20(,%ebx,4),%esi
  80084e:	85 f6                	test   %esi,%esi
  800850:	75 19                	jne    80086b <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800852:	53                   	push   %ebx
  800853:	68 c5 20 80 00       	push   $0x8020c5
  800858:	ff 75 0c             	pushl  0xc(%ebp)
  80085b:	ff 75 08             	pushl  0x8(%ebp)
  80085e:	e8 70 02 00 00       	call   800ad3 <printfmt>
  800863:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800866:	e9 5b 02 00 00       	jmp    800ac6 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  80086b:	56                   	push   %esi
  80086c:	68 ce 20 80 00       	push   $0x8020ce
  800871:	ff 75 0c             	pushl  0xc(%ebp)
  800874:	ff 75 08             	pushl  0x8(%ebp)
  800877:	e8 57 02 00 00       	call   800ad3 <printfmt>
  80087c:	83 c4 10             	add    $0x10,%esp
			break;
  80087f:	e9 42 02 00 00       	jmp    800ac6 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800884:	8b 45 14             	mov    0x14(%ebp),%eax
  800887:	83 c0 04             	add    $0x4,%eax
  80088a:	89 45 14             	mov    %eax,0x14(%ebp)
  80088d:	8b 45 14             	mov    0x14(%ebp),%eax
  800890:	83 e8 04             	sub    $0x4,%eax
  800893:	8b 30                	mov    (%eax),%esi
  800895:	85 f6                	test   %esi,%esi
  800897:	75 05                	jne    80089e <vprintfmt+0x1a6>
				p = "(null)";
  800899:	be d1 20 80 00       	mov    $0x8020d1,%esi
			if (width > 0 && padc != '-')
  80089e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008a2:	7e 6d                	jle    800911 <vprintfmt+0x219>
  8008a4:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8008a8:	74 67                	je     800911 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8008aa:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8008ad:	83 ec 08             	sub    $0x8,%esp
  8008b0:	50                   	push   %eax
  8008b1:	56                   	push   %esi
  8008b2:	e8 1e 03 00 00       	call   800bd5 <strnlen>
  8008b7:	83 c4 10             	add    $0x10,%esp
  8008ba:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  8008bd:	eb 16                	jmp    8008d5 <vprintfmt+0x1dd>
					putch(padc, putdat);
  8008bf:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  8008c3:	83 ec 08             	sub    $0x8,%esp
  8008c6:	ff 75 0c             	pushl  0xc(%ebp)
  8008c9:	50                   	push   %eax
  8008ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8008cd:	ff d0                	call   *%eax
  8008cf:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8008d2:	ff 4d e4             	decl   -0x1c(%ebp)
  8008d5:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008d9:	7f e4                	jg     8008bf <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8008db:	eb 34                	jmp    800911 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  8008dd:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8008e1:	74 1c                	je     8008ff <vprintfmt+0x207>
  8008e3:	83 fb 1f             	cmp    $0x1f,%ebx
  8008e6:	7e 05                	jle    8008ed <vprintfmt+0x1f5>
  8008e8:	83 fb 7e             	cmp    $0x7e,%ebx
  8008eb:	7e 12                	jle    8008ff <vprintfmt+0x207>
					putch('?', putdat);
  8008ed:	83 ec 08             	sub    $0x8,%esp
  8008f0:	ff 75 0c             	pushl  0xc(%ebp)
  8008f3:	6a 3f                	push   $0x3f
  8008f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8008f8:	ff d0                	call   *%eax
  8008fa:	83 c4 10             	add    $0x10,%esp
  8008fd:	eb 0f                	jmp    80090e <vprintfmt+0x216>
				else
					putch(ch, putdat);
  8008ff:	83 ec 08             	sub    $0x8,%esp
  800902:	ff 75 0c             	pushl  0xc(%ebp)
  800905:	53                   	push   %ebx
  800906:	8b 45 08             	mov    0x8(%ebp),%eax
  800909:	ff d0                	call   *%eax
  80090b:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80090e:	ff 4d e4             	decl   -0x1c(%ebp)
  800911:	89 f0                	mov    %esi,%eax
  800913:	8d 70 01             	lea    0x1(%eax),%esi
  800916:	8a 00                	mov    (%eax),%al
  800918:	0f be d8             	movsbl %al,%ebx
  80091b:	85 db                	test   %ebx,%ebx
  80091d:	74 24                	je     800943 <vprintfmt+0x24b>
  80091f:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800923:	78 b8                	js     8008dd <vprintfmt+0x1e5>
  800925:	ff 4d e0             	decl   -0x20(%ebp)
  800928:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80092c:	79 af                	jns    8008dd <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80092e:	eb 13                	jmp    800943 <vprintfmt+0x24b>
				putch(' ', putdat);
  800930:	83 ec 08             	sub    $0x8,%esp
  800933:	ff 75 0c             	pushl  0xc(%ebp)
  800936:	6a 20                	push   $0x20
  800938:	8b 45 08             	mov    0x8(%ebp),%eax
  80093b:	ff d0                	call   *%eax
  80093d:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800940:	ff 4d e4             	decl   -0x1c(%ebp)
  800943:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800947:	7f e7                	jg     800930 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800949:	e9 78 01 00 00       	jmp    800ac6 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  80094e:	83 ec 08             	sub    $0x8,%esp
  800951:	ff 75 e8             	pushl  -0x18(%ebp)
  800954:	8d 45 14             	lea    0x14(%ebp),%eax
  800957:	50                   	push   %eax
  800958:	e8 3c fd ff ff       	call   800699 <getint>
  80095d:	83 c4 10             	add    $0x10,%esp
  800960:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800963:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800966:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800969:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80096c:	85 d2                	test   %edx,%edx
  80096e:	79 23                	jns    800993 <vprintfmt+0x29b>
				putch('-', putdat);
  800970:	83 ec 08             	sub    $0x8,%esp
  800973:	ff 75 0c             	pushl  0xc(%ebp)
  800976:	6a 2d                	push   $0x2d
  800978:	8b 45 08             	mov    0x8(%ebp),%eax
  80097b:	ff d0                	call   *%eax
  80097d:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800980:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800983:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800986:	f7 d8                	neg    %eax
  800988:	83 d2 00             	adc    $0x0,%edx
  80098b:	f7 da                	neg    %edx
  80098d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800990:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800993:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  80099a:	e9 bc 00 00 00       	jmp    800a5b <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  80099f:	83 ec 08             	sub    $0x8,%esp
  8009a2:	ff 75 e8             	pushl  -0x18(%ebp)
  8009a5:	8d 45 14             	lea    0x14(%ebp),%eax
  8009a8:	50                   	push   %eax
  8009a9:	e8 84 fc ff ff       	call   800632 <getuint>
  8009ae:	83 c4 10             	add    $0x10,%esp
  8009b1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009b4:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  8009b7:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8009be:	e9 98 00 00 00       	jmp    800a5b <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  8009c3:	83 ec 08             	sub    $0x8,%esp
  8009c6:	ff 75 0c             	pushl  0xc(%ebp)
  8009c9:	6a 58                	push   $0x58
  8009cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ce:	ff d0                	call   *%eax
  8009d0:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8009d3:	83 ec 08             	sub    $0x8,%esp
  8009d6:	ff 75 0c             	pushl  0xc(%ebp)
  8009d9:	6a 58                	push   $0x58
  8009db:	8b 45 08             	mov    0x8(%ebp),%eax
  8009de:	ff d0                	call   *%eax
  8009e0:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8009e3:	83 ec 08             	sub    $0x8,%esp
  8009e6:	ff 75 0c             	pushl  0xc(%ebp)
  8009e9:	6a 58                	push   $0x58
  8009eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ee:	ff d0                	call   *%eax
  8009f0:	83 c4 10             	add    $0x10,%esp
			break;
  8009f3:	e9 ce 00 00 00       	jmp    800ac6 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  8009f8:	83 ec 08             	sub    $0x8,%esp
  8009fb:	ff 75 0c             	pushl  0xc(%ebp)
  8009fe:	6a 30                	push   $0x30
  800a00:	8b 45 08             	mov    0x8(%ebp),%eax
  800a03:	ff d0                	call   *%eax
  800a05:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800a08:	83 ec 08             	sub    $0x8,%esp
  800a0b:	ff 75 0c             	pushl  0xc(%ebp)
  800a0e:	6a 78                	push   $0x78
  800a10:	8b 45 08             	mov    0x8(%ebp),%eax
  800a13:	ff d0                	call   *%eax
  800a15:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800a18:	8b 45 14             	mov    0x14(%ebp),%eax
  800a1b:	83 c0 04             	add    $0x4,%eax
  800a1e:	89 45 14             	mov    %eax,0x14(%ebp)
  800a21:	8b 45 14             	mov    0x14(%ebp),%eax
  800a24:	83 e8 04             	sub    $0x4,%eax
  800a27:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800a29:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a2c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800a33:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800a3a:	eb 1f                	jmp    800a5b <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800a3c:	83 ec 08             	sub    $0x8,%esp
  800a3f:	ff 75 e8             	pushl  -0x18(%ebp)
  800a42:	8d 45 14             	lea    0x14(%ebp),%eax
  800a45:	50                   	push   %eax
  800a46:	e8 e7 fb ff ff       	call   800632 <getuint>
  800a4b:	83 c4 10             	add    $0x10,%esp
  800a4e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a51:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800a54:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800a5b:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800a5f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800a62:	83 ec 04             	sub    $0x4,%esp
  800a65:	52                   	push   %edx
  800a66:	ff 75 e4             	pushl  -0x1c(%ebp)
  800a69:	50                   	push   %eax
  800a6a:	ff 75 f4             	pushl  -0xc(%ebp)
  800a6d:	ff 75 f0             	pushl  -0x10(%ebp)
  800a70:	ff 75 0c             	pushl  0xc(%ebp)
  800a73:	ff 75 08             	pushl  0x8(%ebp)
  800a76:	e8 00 fb ff ff       	call   80057b <printnum>
  800a7b:	83 c4 20             	add    $0x20,%esp
			break;
  800a7e:	eb 46                	jmp    800ac6 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800a80:	83 ec 08             	sub    $0x8,%esp
  800a83:	ff 75 0c             	pushl  0xc(%ebp)
  800a86:	53                   	push   %ebx
  800a87:	8b 45 08             	mov    0x8(%ebp),%eax
  800a8a:	ff d0                	call   *%eax
  800a8c:	83 c4 10             	add    $0x10,%esp
			break;
  800a8f:	eb 35                	jmp    800ac6 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800a91:	c6 05 44 30 80 00 00 	movb   $0x0,0x803044
			break;
  800a98:	eb 2c                	jmp    800ac6 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800a9a:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
			break;
  800aa1:	eb 23                	jmp    800ac6 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800aa3:	83 ec 08             	sub    $0x8,%esp
  800aa6:	ff 75 0c             	pushl  0xc(%ebp)
  800aa9:	6a 25                	push   $0x25
  800aab:	8b 45 08             	mov    0x8(%ebp),%eax
  800aae:	ff d0                	call   *%eax
  800ab0:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800ab3:	ff 4d 10             	decl   0x10(%ebp)
  800ab6:	eb 03                	jmp    800abb <vprintfmt+0x3c3>
  800ab8:	ff 4d 10             	decl   0x10(%ebp)
  800abb:	8b 45 10             	mov    0x10(%ebp),%eax
  800abe:	48                   	dec    %eax
  800abf:	8a 00                	mov    (%eax),%al
  800ac1:	3c 25                	cmp    $0x25,%al
  800ac3:	75 f3                	jne    800ab8 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800ac5:	90                   	nop
		}
	}
  800ac6:	e9 35 fc ff ff       	jmp    800700 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800acb:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800acc:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800acf:	5b                   	pop    %ebx
  800ad0:	5e                   	pop    %esi
  800ad1:	5d                   	pop    %ebp
  800ad2:	c3                   	ret    

00800ad3 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800ad3:	55                   	push   %ebp
  800ad4:	89 e5                	mov    %esp,%ebp
  800ad6:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800ad9:	8d 45 10             	lea    0x10(%ebp),%eax
  800adc:	83 c0 04             	add    $0x4,%eax
  800adf:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800ae2:	8b 45 10             	mov    0x10(%ebp),%eax
  800ae5:	ff 75 f4             	pushl  -0xc(%ebp)
  800ae8:	50                   	push   %eax
  800ae9:	ff 75 0c             	pushl  0xc(%ebp)
  800aec:	ff 75 08             	pushl  0x8(%ebp)
  800aef:	e8 04 fc ff ff       	call   8006f8 <vprintfmt>
  800af4:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800af7:	90                   	nop
  800af8:	c9                   	leave  
  800af9:	c3                   	ret    

00800afa <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800afa:	55                   	push   %ebp
  800afb:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800afd:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b00:	8b 40 08             	mov    0x8(%eax),%eax
  800b03:	8d 50 01             	lea    0x1(%eax),%edx
  800b06:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b09:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800b0c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b0f:	8b 10                	mov    (%eax),%edx
  800b11:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b14:	8b 40 04             	mov    0x4(%eax),%eax
  800b17:	39 c2                	cmp    %eax,%edx
  800b19:	73 12                	jae    800b2d <sprintputch+0x33>
		*b->buf++ = ch;
  800b1b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b1e:	8b 00                	mov    (%eax),%eax
  800b20:	8d 48 01             	lea    0x1(%eax),%ecx
  800b23:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b26:	89 0a                	mov    %ecx,(%edx)
  800b28:	8b 55 08             	mov    0x8(%ebp),%edx
  800b2b:	88 10                	mov    %dl,(%eax)
}
  800b2d:	90                   	nop
  800b2e:	5d                   	pop    %ebp
  800b2f:	c3                   	ret    

00800b30 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800b30:	55                   	push   %ebp
  800b31:	89 e5                	mov    %esp,%ebp
  800b33:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800b36:	8b 45 08             	mov    0x8(%ebp),%eax
  800b39:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800b3c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b3f:	8d 50 ff             	lea    -0x1(%eax),%edx
  800b42:	8b 45 08             	mov    0x8(%ebp),%eax
  800b45:	01 d0                	add    %edx,%eax
  800b47:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b4a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800b51:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800b55:	74 06                	je     800b5d <vsnprintf+0x2d>
  800b57:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b5b:	7f 07                	jg     800b64 <vsnprintf+0x34>
		return -E_INVAL;
  800b5d:	b8 03 00 00 00       	mov    $0x3,%eax
  800b62:	eb 20                	jmp    800b84 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800b64:	ff 75 14             	pushl  0x14(%ebp)
  800b67:	ff 75 10             	pushl  0x10(%ebp)
  800b6a:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800b6d:	50                   	push   %eax
  800b6e:	68 fa 0a 80 00       	push   $0x800afa
  800b73:	e8 80 fb ff ff       	call   8006f8 <vprintfmt>
  800b78:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800b7b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800b7e:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800b81:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800b84:	c9                   	leave  
  800b85:	c3                   	ret    

00800b86 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800b86:	55                   	push   %ebp
  800b87:	89 e5                	mov    %esp,%ebp
  800b89:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800b8c:	8d 45 10             	lea    0x10(%ebp),%eax
  800b8f:	83 c0 04             	add    $0x4,%eax
  800b92:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800b95:	8b 45 10             	mov    0x10(%ebp),%eax
  800b98:	ff 75 f4             	pushl  -0xc(%ebp)
  800b9b:	50                   	push   %eax
  800b9c:	ff 75 0c             	pushl  0xc(%ebp)
  800b9f:	ff 75 08             	pushl  0x8(%ebp)
  800ba2:	e8 89 ff ff ff       	call   800b30 <vsnprintf>
  800ba7:	83 c4 10             	add    $0x10,%esp
  800baa:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800bad:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800bb0:	c9                   	leave  
  800bb1:	c3                   	ret    

00800bb2 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800bb2:	55                   	push   %ebp
  800bb3:	89 e5                	mov    %esp,%ebp
  800bb5:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800bb8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800bbf:	eb 06                	jmp    800bc7 <strlen+0x15>
		n++;
  800bc1:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800bc4:	ff 45 08             	incl   0x8(%ebp)
  800bc7:	8b 45 08             	mov    0x8(%ebp),%eax
  800bca:	8a 00                	mov    (%eax),%al
  800bcc:	84 c0                	test   %al,%al
  800bce:	75 f1                	jne    800bc1 <strlen+0xf>
		n++;
	return n;
  800bd0:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800bd3:	c9                   	leave  
  800bd4:	c3                   	ret    

00800bd5 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800bd5:	55                   	push   %ebp
  800bd6:	89 e5                	mov    %esp,%ebp
  800bd8:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800bdb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800be2:	eb 09                	jmp    800bed <strnlen+0x18>
		n++;
  800be4:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800be7:	ff 45 08             	incl   0x8(%ebp)
  800bea:	ff 4d 0c             	decl   0xc(%ebp)
  800bed:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800bf1:	74 09                	je     800bfc <strnlen+0x27>
  800bf3:	8b 45 08             	mov    0x8(%ebp),%eax
  800bf6:	8a 00                	mov    (%eax),%al
  800bf8:	84 c0                	test   %al,%al
  800bfa:	75 e8                	jne    800be4 <strnlen+0xf>
		n++;
	return n;
  800bfc:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800bff:	c9                   	leave  
  800c00:	c3                   	ret    

00800c01 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800c01:	55                   	push   %ebp
  800c02:	89 e5                	mov    %esp,%ebp
  800c04:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800c07:	8b 45 08             	mov    0x8(%ebp),%eax
  800c0a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800c0d:	90                   	nop
  800c0e:	8b 45 08             	mov    0x8(%ebp),%eax
  800c11:	8d 50 01             	lea    0x1(%eax),%edx
  800c14:	89 55 08             	mov    %edx,0x8(%ebp)
  800c17:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c1a:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c1d:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800c20:	8a 12                	mov    (%edx),%dl
  800c22:	88 10                	mov    %dl,(%eax)
  800c24:	8a 00                	mov    (%eax),%al
  800c26:	84 c0                	test   %al,%al
  800c28:	75 e4                	jne    800c0e <strcpy+0xd>
		/* do nothing */;
	return ret;
  800c2a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c2d:	c9                   	leave  
  800c2e:	c3                   	ret    

00800c2f <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800c2f:	55                   	push   %ebp
  800c30:	89 e5                	mov    %esp,%ebp
  800c32:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800c35:	8b 45 08             	mov    0x8(%ebp),%eax
  800c38:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800c3b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c42:	eb 1f                	jmp    800c63 <strncpy+0x34>
		*dst++ = *src;
  800c44:	8b 45 08             	mov    0x8(%ebp),%eax
  800c47:	8d 50 01             	lea    0x1(%eax),%edx
  800c4a:	89 55 08             	mov    %edx,0x8(%ebp)
  800c4d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c50:	8a 12                	mov    (%edx),%dl
  800c52:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800c54:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c57:	8a 00                	mov    (%eax),%al
  800c59:	84 c0                	test   %al,%al
  800c5b:	74 03                	je     800c60 <strncpy+0x31>
			src++;
  800c5d:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800c60:	ff 45 fc             	incl   -0x4(%ebp)
  800c63:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c66:	3b 45 10             	cmp    0x10(%ebp),%eax
  800c69:	72 d9                	jb     800c44 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800c6b:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800c6e:	c9                   	leave  
  800c6f:	c3                   	ret    

00800c70 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800c70:	55                   	push   %ebp
  800c71:	89 e5                	mov    %esp,%ebp
  800c73:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800c76:	8b 45 08             	mov    0x8(%ebp),%eax
  800c79:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800c7c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c80:	74 30                	je     800cb2 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800c82:	eb 16                	jmp    800c9a <strlcpy+0x2a>
			*dst++ = *src++;
  800c84:	8b 45 08             	mov    0x8(%ebp),%eax
  800c87:	8d 50 01             	lea    0x1(%eax),%edx
  800c8a:	89 55 08             	mov    %edx,0x8(%ebp)
  800c8d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c90:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c93:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800c96:	8a 12                	mov    (%edx),%dl
  800c98:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800c9a:	ff 4d 10             	decl   0x10(%ebp)
  800c9d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ca1:	74 09                	je     800cac <strlcpy+0x3c>
  800ca3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ca6:	8a 00                	mov    (%eax),%al
  800ca8:	84 c0                	test   %al,%al
  800caa:	75 d8                	jne    800c84 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800cac:	8b 45 08             	mov    0x8(%ebp),%eax
  800caf:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800cb2:	8b 55 08             	mov    0x8(%ebp),%edx
  800cb5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800cb8:	29 c2                	sub    %eax,%edx
  800cba:	89 d0                	mov    %edx,%eax
}
  800cbc:	c9                   	leave  
  800cbd:	c3                   	ret    

00800cbe <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800cbe:	55                   	push   %ebp
  800cbf:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800cc1:	eb 06                	jmp    800cc9 <strcmp+0xb>
		p++, q++;
  800cc3:	ff 45 08             	incl   0x8(%ebp)
  800cc6:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800cc9:	8b 45 08             	mov    0x8(%ebp),%eax
  800ccc:	8a 00                	mov    (%eax),%al
  800cce:	84 c0                	test   %al,%al
  800cd0:	74 0e                	je     800ce0 <strcmp+0x22>
  800cd2:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd5:	8a 10                	mov    (%eax),%dl
  800cd7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cda:	8a 00                	mov    (%eax),%al
  800cdc:	38 c2                	cmp    %al,%dl
  800cde:	74 e3                	je     800cc3 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800ce0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce3:	8a 00                	mov    (%eax),%al
  800ce5:	0f b6 d0             	movzbl %al,%edx
  800ce8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ceb:	8a 00                	mov    (%eax),%al
  800ced:	0f b6 c0             	movzbl %al,%eax
  800cf0:	29 c2                	sub    %eax,%edx
  800cf2:	89 d0                	mov    %edx,%eax
}
  800cf4:	5d                   	pop    %ebp
  800cf5:	c3                   	ret    

00800cf6 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800cf6:	55                   	push   %ebp
  800cf7:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800cf9:	eb 09                	jmp    800d04 <strncmp+0xe>
		n--, p++, q++;
  800cfb:	ff 4d 10             	decl   0x10(%ebp)
  800cfe:	ff 45 08             	incl   0x8(%ebp)
  800d01:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800d04:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d08:	74 17                	je     800d21 <strncmp+0x2b>
  800d0a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d0d:	8a 00                	mov    (%eax),%al
  800d0f:	84 c0                	test   %al,%al
  800d11:	74 0e                	je     800d21 <strncmp+0x2b>
  800d13:	8b 45 08             	mov    0x8(%ebp),%eax
  800d16:	8a 10                	mov    (%eax),%dl
  800d18:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d1b:	8a 00                	mov    (%eax),%al
  800d1d:	38 c2                	cmp    %al,%dl
  800d1f:	74 da                	je     800cfb <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800d21:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d25:	75 07                	jne    800d2e <strncmp+0x38>
		return 0;
  800d27:	b8 00 00 00 00       	mov    $0x0,%eax
  800d2c:	eb 14                	jmp    800d42 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800d2e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d31:	8a 00                	mov    (%eax),%al
  800d33:	0f b6 d0             	movzbl %al,%edx
  800d36:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d39:	8a 00                	mov    (%eax),%al
  800d3b:	0f b6 c0             	movzbl %al,%eax
  800d3e:	29 c2                	sub    %eax,%edx
  800d40:	89 d0                	mov    %edx,%eax
}
  800d42:	5d                   	pop    %ebp
  800d43:	c3                   	ret    

00800d44 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800d44:	55                   	push   %ebp
  800d45:	89 e5                	mov    %esp,%ebp
  800d47:	83 ec 04             	sub    $0x4,%esp
  800d4a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d4d:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800d50:	eb 12                	jmp    800d64 <strchr+0x20>
		if (*s == c)
  800d52:	8b 45 08             	mov    0x8(%ebp),%eax
  800d55:	8a 00                	mov    (%eax),%al
  800d57:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800d5a:	75 05                	jne    800d61 <strchr+0x1d>
			return (char *) s;
  800d5c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d5f:	eb 11                	jmp    800d72 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800d61:	ff 45 08             	incl   0x8(%ebp)
  800d64:	8b 45 08             	mov    0x8(%ebp),%eax
  800d67:	8a 00                	mov    (%eax),%al
  800d69:	84 c0                	test   %al,%al
  800d6b:	75 e5                	jne    800d52 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800d6d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d72:	c9                   	leave  
  800d73:	c3                   	ret    

00800d74 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800d74:	55                   	push   %ebp
  800d75:	89 e5                	mov    %esp,%ebp
  800d77:	83 ec 04             	sub    $0x4,%esp
  800d7a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d7d:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800d80:	eb 0d                	jmp    800d8f <strfind+0x1b>
		if (*s == c)
  800d82:	8b 45 08             	mov    0x8(%ebp),%eax
  800d85:	8a 00                	mov    (%eax),%al
  800d87:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800d8a:	74 0e                	je     800d9a <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800d8c:	ff 45 08             	incl   0x8(%ebp)
  800d8f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d92:	8a 00                	mov    (%eax),%al
  800d94:	84 c0                	test   %al,%al
  800d96:	75 ea                	jne    800d82 <strfind+0xe>
  800d98:	eb 01                	jmp    800d9b <strfind+0x27>
		if (*s == c)
			break;
  800d9a:	90                   	nop
	return (char *) s;
  800d9b:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800d9e:	c9                   	leave  
  800d9f:	c3                   	ret    

00800da0 <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  800da0:	55                   	push   %ebp
  800da1:	89 e5                	mov    %esp,%ebp
  800da3:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  800da6:	8b 45 08             	mov    0x8(%ebp),%eax
  800da9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  800dac:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800db0:	76 63                	jbe    800e15 <memset+0x75>
		uint64 data_block = c;
  800db2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800db5:	99                   	cltd   
  800db6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800db9:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  800dbc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800dbf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800dc2:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  800dc6:	c1 e0 08             	shl    $0x8,%eax
  800dc9:	09 45 f0             	or     %eax,-0x10(%ebp)
  800dcc:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  800dcf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800dd2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800dd5:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  800dd9:	c1 e0 10             	shl    $0x10,%eax
  800ddc:	09 45 f0             	or     %eax,-0x10(%ebp)
  800ddf:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  800de2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800de5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800de8:	89 c2                	mov    %eax,%edx
  800dea:	b8 00 00 00 00       	mov    $0x0,%eax
  800def:	09 45 f0             	or     %eax,-0x10(%ebp)
  800df2:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  800df5:	eb 18                	jmp    800e0f <memset+0x6f>
			*p64++ = data_block, n -= 8;
  800df7:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  800dfa:	8d 41 08             	lea    0x8(%ecx),%eax
  800dfd:	89 45 fc             	mov    %eax,-0x4(%ebp)
  800e00:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e03:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e06:	89 01                	mov    %eax,(%ecx)
  800e08:	89 51 04             	mov    %edx,0x4(%ecx)
  800e0b:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  800e0f:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800e13:	77 e2                	ja     800df7 <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  800e15:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e19:	74 23                	je     800e3e <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  800e1b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e1e:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  800e21:	eb 0e                	jmp    800e31 <memset+0x91>
			*p8++ = (uint8)c;
  800e23:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e26:	8d 50 01             	lea    0x1(%eax),%edx
  800e29:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800e2c:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e2f:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  800e31:	8b 45 10             	mov    0x10(%ebp),%eax
  800e34:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e37:	89 55 10             	mov    %edx,0x10(%ebp)
  800e3a:	85 c0                	test   %eax,%eax
  800e3c:	75 e5                	jne    800e23 <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  800e3e:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e41:	c9                   	leave  
  800e42:	c3                   	ret    

00800e43 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800e43:	55                   	push   %ebp
  800e44:	89 e5                	mov    %esp,%ebp
  800e46:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  800e49:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e4c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  800e4f:	8b 45 08             	mov    0x8(%ebp),%eax
  800e52:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  800e55:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800e59:	76 24                	jbe    800e7f <memcpy+0x3c>
		while(n >= 8){
  800e5b:	eb 1c                	jmp    800e79 <memcpy+0x36>
			*d64 = *s64;
  800e5d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e60:	8b 50 04             	mov    0x4(%eax),%edx
  800e63:	8b 00                	mov    (%eax),%eax
  800e65:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  800e68:	89 01                	mov    %eax,(%ecx)
  800e6a:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  800e6d:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  800e71:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  800e75:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  800e79:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800e7d:	77 de                	ja     800e5d <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  800e7f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e83:	74 31                	je     800eb6 <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  800e85:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e88:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  800e8b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e8e:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  800e91:	eb 16                	jmp    800ea9 <memcpy+0x66>
			*d8++ = *s8++;
  800e93:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e96:	8d 50 01             	lea    0x1(%eax),%edx
  800e99:	89 55 f0             	mov    %edx,-0x10(%ebp)
  800e9c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e9f:	8d 4a 01             	lea    0x1(%edx),%ecx
  800ea2:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  800ea5:	8a 12                	mov    (%edx),%dl
  800ea7:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  800ea9:	8b 45 10             	mov    0x10(%ebp),%eax
  800eac:	8d 50 ff             	lea    -0x1(%eax),%edx
  800eaf:	89 55 10             	mov    %edx,0x10(%ebp)
  800eb2:	85 c0                	test   %eax,%eax
  800eb4:	75 dd                	jne    800e93 <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  800eb6:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800eb9:	c9                   	leave  
  800eba:	c3                   	ret    

00800ebb <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800ebb:	55                   	push   %ebp
  800ebc:	89 e5                	mov    %esp,%ebp
  800ebe:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800ec1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ec4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800ec7:	8b 45 08             	mov    0x8(%ebp),%eax
  800eca:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800ecd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ed0:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800ed3:	73 50                	jae    800f25 <memmove+0x6a>
  800ed5:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800ed8:	8b 45 10             	mov    0x10(%ebp),%eax
  800edb:	01 d0                	add    %edx,%eax
  800edd:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800ee0:	76 43                	jbe    800f25 <memmove+0x6a>
		s += n;
  800ee2:	8b 45 10             	mov    0x10(%ebp),%eax
  800ee5:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800ee8:	8b 45 10             	mov    0x10(%ebp),%eax
  800eeb:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800eee:	eb 10                	jmp    800f00 <memmove+0x45>
			*--d = *--s;
  800ef0:	ff 4d f8             	decl   -0x8(%ebp)
  800ef3:	ff 4d fc             	decl   -0x4(%ebp)
  800ef6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ef9:	8a 10                	mov    (%eax),%dl
  800efb:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800efe:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800f00:	8b 45 10             	mov    0x10(%ebp),%eax
  800f03:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f06:	89 55 10             	mov    %edx,0x10(%ebp)
  800f09:	85 c0                	test   %eax,%eax
  800f0b:	75 e3                	jne    800ef0 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800f0d:	eb 23                	jmp    800f32 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800f0f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f12:	8d 50 01             	lea    0x1(%eax),%edx
  800f15:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800f18:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f1b:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f1e:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800f21:	8a 12                	mov    (%edx),%dl
  800f23:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800f25:	8b 45 10             	mov    0x10(%ebp),%eax
  800f28:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f2b:	89 55 10             	mov    %edx,0x10(%ebp)
  800f2e:	85 c0                	test   %eax,%eax
  800f30:	75 dd                	jne    800f0f <memmove+0x54>
			*d++ = *s++;

	return dst;
  800f32:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f35:	c9                   	leave  
  800f36:	c3                   	ret    

00800f37 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800f37:	55                   	push   %ebp
  800f38:	89 e5                	mov    %esp,%ebp
  800f3a:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800f3d:	8b 45 08             	mov    0x8(%ebp),%eax
  800f40:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800f43:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f46:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800f49:	eb 2a                	jmp    800f75 <memcmp+0x3e>
		if (*s1 != *s2)
  800f4b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f4e:	8a 10                	mov    (%eax),%dl
  800f50:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f53:	8a 00                	mov    (%eax),%al
  800f55:	38 c2                	cmp    %al,%dl
  800f57:	74 16                	je     800f6f <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800f59:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f5c:	8a 00                	mov    (%eax),%al
  800f5e:	0f b6 d0             	movzbl %al,%edx
  800f61:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f64:	8a 00                	mov    (%eax),%al
  800f66:	0f b6 c0             	movzbl %al,%eax
  800f69:	29 c2                	sub    %eax,%edx
  800f6b:	89 d0                	mov    %edx,%eax
  800f6d:	eb 18                	jmp    800f87 <memcmp+0x50>
		s1++, s2++;
  800f6f:	ff 45 fc             	incl   -0x4(%ebp)
  800f72:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800f75:	8b 45 10             	mov    0x10(%ebp),%eax
  800f78:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f7b:	89 55 10             	mov    %edx,0x10(%ebp)
  800f7e:	85 c0                	test   %eax,%eax
  800f80:	75 c9                	jne    800f4b <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800f82:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f87:	c9                   	leave  
  800f88:	c3                   	ret    

00800f89 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800f89:	55                   	push   %ebp
  800f8a:	89 e5                	mov    %esp,%ebp
  800f8c:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800f8f:	8b 55 08             	mov    0x8(%ebp),%edx
  800f92:	8b 45 10             	mov    0x10(%ebp),%eax
  800f95:	01 d0                	add    %edx,%eax
  800f97:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800f9a:	eb 15                	jmp    800fb1 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800f9c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f9f:	8a 00                	mov    (%eax),%al
  800fa1:	0f b6 d0             	movzbl %al,%edx
  800fa4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fa7:	0f b6 c0             	movzbl %al,%eax
  800faa:	39 c2                	cmp    %eax,%edx
  800fac:	74 0d                	je     800fbb <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800fae:	ff 45 08             	incl   0x8(%ebp)
  800fb1:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb4:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800fb7:	72 e3                	jb     800f9c <memfind+0x13>
  800fb9:	eb 01                	jmp    800fbc <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800fbb:	90                   	nop
	return (void *) s;
  800fbc:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800fbf:	c9                   	leave  
  800fc0:	c3                   	ret    

00800fc1 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800fc1:	55                   	push   %ebp
  800fc2:	89 e5                	mov    %esp,%ebp
  800fc4:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800fc7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800fce:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800fd5:	eb 03                	jmp    800fda <strtol+0x19>
		s++;
  800fd7:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800fda:	8b 45 08             	mov    0x8(%ebp),%eax
  800fdd:	8a 00                	mov    (%eax),%al
  800fdf:	3c 20                	cmp    $0x20,%al
  800fe1:	74 f4                	je     800fd7 <strtol+0x16>
  800fe3:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe6:	8a 00                	mov    (%eax),%al
  800fe8:	3c 09                	cmp    $0x9,%al
  800fea:	74 eb                	je     800fd7 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800fec:	8b 45 08             	mov    0x8(%ebp),%eax
  800fef:	8a 00                	mov    (%eax),%al
  800ff1:	3c 2b                	cmp    $0x2b,%al
  800ff3:	75 05                	jne    800ffa <strtol+0x39>
		s++;
  800ff5:	ff 45 08             	incl   0x8(%ebp)
  800ff8:	eb 13                	jmp    80100d <strtol+0x4c>
	else if (*s == '-')
  800ffa:	8b 45 08             	mov    0x8(%ebp),%eax
  800ffd:	8a 00                	mov    (%eax),%al
  800fff:	3c 2d                	cmp    $0x2d,%al
  801001:	75 0a                	jne    80100d <strtol+0x4c>
		s++, neg = 1;
  801003:	ff 45 08             	incl   0x8(%ebp)
  801006:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80100d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801011:	74 06                	je     801019 <strtol+0x58>
  801013:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801017:	75 20                	jne    801039 <strtol+0x78>
  801019:	8b 45 08             	mov    0x8(%ebp),%eax
  80101c:	8a 00                	mov    (%eax),%al
  80101e:	3c 30                	cmp    $0x30,%al
  801020:	75 17                	jne    801039 <strtol+0x78>
  801022:	8b 45 08             	mov    0x8(%ebp),%eax
  801025:	40                   	inc    %eax
  801026:	8a 00                	mov    (%eax),%al
  801028:	3c 78                	cmp    $0x78,%al
  80102a:	75 0d                	jne    801039 <strtol+0x78>
		s += 2, base = 16;
  80102c:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801030:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801037:	eb 28                	jmp    801061 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801039:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80103d:	75 15                	jne    801054 <strtol+0x93>
  80103f:	8b 45 08             	mov    0x8(%ebp),%eax
  801042:	8a 00                	mov    (%eax),%al
  801044:	3c 30                	cmp    $0x30,%al
  801046:	75 0c                	jne    801054 <strtol+0x93>
		s++, base = 8;
  801048:	ff 45 08             	incl   0x8(%ebp)
  80104b:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801052:	eb 0d                	jmp    801061 <strtol+0xa0>
	else if (base == 0)
  801054:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801058:	75 07                	jne    801061 <strtol+0xa0>
		base = 10;
  80105a:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801061:	8b 45 08             	mov    0x8(%ebp),%eax
  801064:	8a 00                	mov    (%eax),%al
  801066:	3c 2f                	cmp    $0x2f,%al
  801068:	7e 19                	jle    801083 <strtol+0xc2>
  80106a:	8b 45 08             	mov    0x8(%ebp),%eax
  80106d:	8a 00                	mov    (%eax),%al
  80106f:	3c 39                	cmp    $0x39,%al
  801071:	7f 10                	jg     801083 <strtol+0xc2>
			dig = *s - '0';
  801073:	8b 45 08             	mov    0x8(%ebp),%eax
  801076:	8a 00                	mov    (%eax),%al
  801078:	0f be c0             	movsbl %al,%eax
  80107b:	83 e8 30             	sub    $0x30,%eax
  80107e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801081:	eb 42                	jmp    8010c5 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801083:	8b 45 08             	mov    0x8(%ebp),%eax
  801086:	8a 00                	mov    (%eax),%al
  801088:	3c 60                	cmp    $0x60,%al
  80108a:	7e 19                	jle    8010a5 <strtol+0xe4>
  80108c:	8b 45 08             	mov    0x8(%ebp),%eax
  80108f:	8a 00                	mov    (%eax),%al
  801091:	3c 7a                	cmp    $0x7a,%al
  801093:	7f 10                	jg     8010a5 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801095:	8b 45 08             	mov    0x8(%ebp),%eax
  801098:	8a 00                	mov    (%eax),%al
  80109a:	0f be c0             	movsbl %al,%eax
  80109d:	83 e8 57             	sub    $0x57,%eax
  8010a0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8010a3:	eb 20                	jmp    8010c5 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  8010a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a8:	8a 00                	mov    (%eax),%al
  8010aa:	3c 40                	cmp    $0x40,%al
  8010ac:	7e 39                	jle    8010e7 <strtol+0x126>
  8010ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b1:	8a 00                	mov    (%eax),%al
  8010b3:	3c 5a                	cmp    $0x5a,%al
  8010b5:	7f 30                	jg     8010e7 <strtol+0x126>
			dig = *s - 'A' + 10;
  8010b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ba:	8a 00                	mov    (%eax),%al
  8010bc:	0f be c0             	movsbl %al,%eax
  8010bf:	83 e8 37             	sub    $0x37,%eax
  8010c2:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  8010c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8010c8:	3b 45 10             	cmp    0x10(%ebp),%eax
  8010cb:	7d 19                	jge    8010e6 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  8010cd:	ff 45 08             	incl   0x8(%ebp)
  8010d0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010d3:	0f af 45 10          	imul   0x10(%ebp),%eax
  8010d7:	89 c2                	mov    %eax,%edx
  8010d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8010dc:	01 d0                	add    %edx,%eax
  8010de:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8010e1:	e9 7b ff ff ff       	jmp    801061 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8010e6:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8010e7:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8010eb:	74 08                	je     8010f5 <strtol+0x134>
		*endptr = (char *) s;
  8010ed:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010f0:	8b 55 08             	mov    0x8(%ebp),%edx
  8010f3:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8010f5:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8010f9:	74 07                	je     801102 <strtol+0x141>
  8010fb:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010fe:	f7 d8                	neg    %eax
  801100:	eb 03                	jmp    801105 <strtol+0x144>
  801102:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801105:	c9                   	leave  
  801106:	c3                   	ret    

00801107 <ltostr>:

void
ltostr(long value, char *str)
{
  801107:	55                   	push   %ebp
  801108:	89 e5                	mov    %esp,%ebp
  80110a:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  80110d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801114:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  80111b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80111f:	79 13                	jns    801134 <ltostr+0x2d>
	{
		neg = 1;
  801121:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801128:	8b 45 0c             	mov    0xc(%ebp),%eax
  80112b:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  80112e:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801131:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801134:	8b 45 08             	mov    0x8(%ebp),%eax
  801137:	b9 0a 00 00 00       	mov    $0xa,%ecx
  80113c:	99                   	cltd   
  80113d:	f7 f9                	idiv   %ecx
  80113f:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801142:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801145:	8d 50 01             	lea    0x1(%eax),%edx
  801148:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80114b:	89 c2                	mov    %eax,%edx
  80114d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801150:	01 d0                	add    %edx,%eax
  801152:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801155:	83 c2 30             	add    $0x30,%edx
  801158:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  80115a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80115d:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801162:	f7 e9                	imul   %ecx
  801164:	c1 fa 02             	sar    $0x2,%edx
  801167:	89 c8                	mov    %ecx,%eax
  801169:	c1 f8 1f             	sar    $0x1f,%eax
  80116c:	29 c2                	sub    %eax,%edx
  80116e:	89 d0                	mov    %edx,%eax
  801170:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  801173:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801177:	75 bb                	jne    801134 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801179:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801180:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801183:	48                   	dec    %eax
  801184:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801187:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80118b:	74 3d                	je     8011ca <ltostr+0xc3>
		start = 1 ;
  80118d:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801194:	eb 34                	jmp    8011ca <ltostr+0xc3>
	{
		char tmp = str[start] ;
  801196:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801199:	8b 45 0c             	mov    0xc(%ebp),%eax
  80119c:	01 d0                	add    %edx,%eax
  80119e:	8a 00                	mov    (%eax),%al
  8011a0:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8011a3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8011a6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011a9:	01 c2                	add    %eax,%edx
  8011ab:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8011ae:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011b1:	01 c8                	add    %ecx,%eax
  8011b3:	8a 00                	mov    (%eax),%al
  8011b5:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8011b7:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8011ba:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011bd:	01 c2                	add    %eax,%edx
  8011bf:	8a 45 eb             	mov    -0x15(%ebp),%al
  8011c2:	88 02                	mov    %al,(%edx)
		start++ ;
  8011c4:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8011c7:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8011ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8011cd:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8011d0:	7c c4                	jl     801196 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8011d2:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8011d5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011d8:	01 d0                	add    %edx,%eax
  8011da:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8011dd:	90                   	nop
  8011de:	c9                   	leave  
  8011df:	c3                   	ret    

008011e0 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8011e0:	55                   	push   %ebp
  8011e1:	89 e5                	mov    %esp,%ebp
  8011e3:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8011e6:	ff 75 08             	pushl  0x8(%ebp)
  8011e9:	e8 c4 f9 ff ff       	call   800bb2 <strlen>
  8011ee:	83 c4 04             	add    $0x4,%esp
  8011f1:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8011f4:	ff 75 0c             	pushl  0xc(%ebp)
  8011f7:	e8 b6 f9 ff ff       	call   800bb2 <strlen>
  8011fc:	83 c4 04             	add    $0x4,%esp
  8011ff:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801202:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801209:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801210:	eb 17                	jmp    801229 <strcconcat+0x49>
		final[s] = str1[s] ;
  801212:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801215:	8b 45 10             	mov    0x10(%ebp),%eax
  801218:	01 c2                	add    %eax,%edx
  80121a:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80121d:	8b 45 08             	mov    0x8(%ebp),%eax
  801220:	01 c8                	add    %ecx,%eax
  801222:	8a 00                	mov    (%eax),%al
  801224:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801226:	ff 45 fc             	incl   -0x4(%ebp)
  801229:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80122c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80122f:	7c e1                	jl     801212 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801231:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801238:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  80123f:	eb 1f                	jmp    801260 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801241:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801244:	8d 50 01             	lea    0x1(%eax),%edx
  801247:	89 55 fc             	mov    %edx,-0x4(%ebp)
  80124a:	89 c2                	mov    %eax,%edx
  80124c:	8b 45 10             	mov    0x10(%ebp),%eax
  80124f:	01 c2                	add    %eax,%edx
  801251:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801254:	8b 45 0c             	mov    0xc(%ebp),%eax
  801257:	01 c8                	add    %ecx,%eax
  801259:	8a 00                	mov    (%eax),%al
  80125b:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  80125d:	ff 45 f8             	incl   -0x8(%ebp)
  801260:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801263:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801266:	7c d9                	jl     801241 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801268:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80126b:	8b 45 10             	mov    0x10(%ebp),%eax
  80126e:	01 d0                	add    %edx,%eax
  801270:	c6 00 00             	movb   $0x0,(%eax)
}
  801273:	90                   	nop
  801274:	c9                   	leave  
  801275:	c3                   	ret    

00801276 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801276:	55                   	push   %ebp
  801277:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801279:	8b 45 14             	mov    0x14(%ebp),%eax
  80127c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801282:	8b 45 14             	mov    0x14(%ebp),%eax
  801285:	8b 00                	mov    (%eax),%eax
  801287:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80128e:	8b 45 10             	mov    0x10(%ebp),%eax
  801291:	01 d0                	add    %edx,%eax
  801293:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801299:	eb 0c                	jmp    8012a7 <strsplit+0x31>
			*string++ = 0;
  80129b:	8b 45 08             	mov    0x8(%ebp),%eax
  80129e:	8d 50 01             	lea    0x1(%eax),%edx
  8012a1:	89 55 08             	mov    %edx,0x8(%ebp)
  8012a4:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8012a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8012aa:	8a 00                	mov    (%eax),%al
  8012ac:	84 c0                	test   %al,%al
  8012ae:	74 18                	je     8012c8 <strsplit+0x52>
  8012b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8012b3:	8a 00                	mov    (%eax),%al
  8012b5:	0f be c0             	movsbl %al,%eax
  8012b8:	50                   	push   %eax
  8012b9:	ff 75 0c             	pushl  0xc(%ebp)
  8012bc:	e8 83 fa ff ff       	call   800d44 <strchr>
  8012c1:	83 c4 08             	add    $0x8,%esp
  8012c4:	85 c0                	test   %eax,%eax
  8012c6:	75 d3                	jne    80129b <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8012c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8012cb:	8a 00                	mov    (%eax),%al
  8012cd:	84 c0                	test   %al,%al
  8012cf:	74 5a                	je     80132b <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8012d1:	8b 45 14             	mov    0x14(%ebp),%eax
  8012d4:	8b 00                	mov    (%eax),%eax
  8012d6:	83 f8 0f             	cmp    $0xf,%eax
  8012d9:	75 07                	jne    8012e2 <strsplit+0x6c>
		{
			return 0;
  8012db:	b8 00 00 00 00       	mov    $0x0,%eax
  8012e0:	eb 66                	jmp    801348 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8012e2:	8b 45 14             	mov    0x14(%ebp),%eax
  8012e5:	8b 00                	mov    (%eax),%eax
  8012e7:	8d 48 01             	lea    0x1(%eax),%ecx
  8012ea:	8b 55 14             	mov    0x14(%ebp),%edx
  8012ed:	89 0a                	mov    %ecx,(%edx)
  8012ef:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8012f6:	8b 45 10             	mov    0x10(%ebp),%eax
  8012f9:	01 c2                	add    %eax,%edx
  8012fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8012fe:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801300:	eb 03                	jmp    801305 <strsplit+0x8f>
			string++;
  801302:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801305:	8b 45 08             	mov    0x8(%ebp),%eax
  801308:	8a 00                	mov    (%eax),%al
  80130a:	84 c0                	test   %al,%al
  80130c:	74 8b                	je     801299 <strsplit+0x23>
  80130e:	8b 45 08             	mov    0x8(%ebp),%eax
  801311:	8a 00                	mov    (%eax),%al
  801313:	0f be c0             	movsbl %al,%eax
  801316:	50                   	push   %eax
  801317:	ff 75 0c             	pushl  0xc(%ebp)
  80131a:	e8 25 fa ff ff       	call   800d44 <strchr>
  80131f:	83 c4 08             	add    $0x8,%esp
  801322:	85 c0                	test   %eax,%eax
  801324:	74 dc                	je     801302 <strsplit+0x8c>
			string++;
	}
  801326:	e9 6e ff ff ff       	jmp    801299 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  80132b:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  80132c:	8b 45 14             	mov    0x14(%ebp),%eax
  80132f:	8b 00                	mov    (%eax),%eax
  801331:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801338:	8b 45 10             	mov    0x10(%ebp),%eax
  80133b:	01 d0                	add    %edx,%eax
  80133d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801343:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801348:	c9                   	leave  
  801349:	c3                   	ret    

0080134a <str2lower>:


char* str2lower(char *dst, const char *src)
{
  80134a:	55                   	push   %ebp
  80134b:	89 e5                	mov    %esp,%ebp
  80134d:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  801350:	8b 45 08             	mov    0x8(%ebp),%eax
  801353:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  801356:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80135d:	eb 4a                	jmp    8013a9 <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  80135f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801362:	8b 45 08             	mov    0x8(%ebp),%eax
  801365:	01 c2                	add    %eax,%edx
  801367:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80136a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80136d:	01 c8                	add    %ecx,%eax
  80136f:	8a 00                	mov    (%eax),%al
  801371:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  801373:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801376:	8b 45 0c             	mov    0xc(%ebp),%eax
  801379:	01 d0                	add    %edx,%eax
  80137b:	8a 00                	mov    (%eax),%al
  80137d:	3c 40                	cmp    $0x40,%al
  80137f:	7e 25                	jle    8013a6 <str2lower+0x5c>
  801381:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801384:	8b 45 0c             	mov    0xc(%ebp),%eax
  801387:	01 d0                	add    %edx,%eax
  801389:	8a 00                	mov    (%eax),%al
  80138b:	3c 5a                	cmp    $0x5a,%al
  80138d:	7f 17                	jg     8013a6 <str2lower+0x5c>
		{
			dst[i] += 32 ;
  80138f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801392:	8b 45 08             	mov    0x8(%ebp),%eax
  801395:	01 d0                	add    %edx,%eax
  801397:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80139a:	8b 55 08             	mov    0x8(%ebp),%edx
  80139d:	01 ca                	add    %ecx,%edx
  80139f:	8a 12                	mov    (%edx),%dl
  8013a1:	83 c2 20             	add    $0x20,%edx
  8013a4:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  8013a6:	ff 45 fc             	incl   -0x4(%ebp)
  8013a9:	ff 75 0c             	pushl  0xc(%ebp)
  8013ac:	e8 01 f8 ff ff       	call   800bb2 <strlen>
  8013b1:	83 c4 04             	add    $0x4,%esp
  8013b4:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8013b7:	7f a6                	jg     80135f <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  8013b9:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8013bc:	c9                   	leave  
  8013bd:	c3                   	ret    

008013be <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8013be:	55                   	push   %ebp
  8013bf:	89 e5                	mov    %esp,%ebp
  8013c1:	57                   	push   %edi
  8013c2:	56                   	push   %esi
  8013c3:	53                   	push   %ebx
  8013c4:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8013c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8013ca:	8b 55 0c             	mov    0xc(%ebp),%edx
  8013cd:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8013d0:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8013d3:	8b 7d 18             	mov    0x18(%ebp),%edi
  8013d6:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8013d9:	cd 30                	int    $0x30
  8013db:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  8013de:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8013e1:	83 c4 10             	add    $0x10,%esp
  8013e4:	5b                   	pop    %ebx
  8013e5:	5e                   	pop    %esi
  8013e6:	5f                   	pop    %edi
  8013e7:	5d                   	pop    %ebp
  8013e8:	c3                   	ret    

008013e9 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  8013e9:	55                   	push   %ebp
  8013ea:	89 e5                	mov    %esp,%ebp
  8013ec:	83 ec 04             	sub    $0x4,%esp
  8013ef:	8b 45 10             	mov    0x10(%ebp),%eax
  8013f2:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  8013f5:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8013f8:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8013fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8013ff:	6a 00                	push   $0x0
  801401:	51                   	push   %ecx
  801402:	52                   	push   %edx
  801403:	ff 75 0c             	pushl  0xc(%ebp)
  801406:	50                   	push   %eax
  801407:	6a 00                	push   $0x0
  801409:	e8 b0 ff ff ff       	call   8013be <syscall>
  80140e:	83 c4 18             	add    $0x18,%esp
}
  801411:	90                   	nop
  801412:	c9                   	leave  
  801413:	c3                   	ret    

00801414 <sys_cgetc>:

int
sys_cgetc(void)
{
  801414:	55                   	push   %ebp
  801415:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801417:	6a 00                	push   $0x0
  801419:	6a 00                	push   $0x0
  80141b:	6a 00                	push   $0x0
  80141d:	6a 00                	push   $0x0
  80141f:	6a 00                	push   $0x0
  801421:	6a 02                	push   $0x2
  801423:	e8 96 ff ff ff       	call   8013be <syscall>
  801428:	83 c4 18             	add    $0x18,%esp
}
  80142b:	c9                   	leave  
  80142c:	c3                   	ret    

0080142d <sys_lock_cons>:

void sys_lock_cons(void)
{
  80142d:	55                   	push   %ebp
  80142e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  801430:	6a 00                	push   $0x0
  801432:	6a 00                	push   $0x0
  801434:	6a 00                	push   $0x0
  801436:	6a 00                	push   $0x0
  801438:	6a 00                	push   $0x0
  80143a:	6a 03                	push   $0x3
  80143c:	e8 7d ff ff ff       	call   8013be <syscall>
  801441:	83 c4 18             	add    $0x18,%esp
}
  801444:	90                   	nop
  801445:	c9                   	leave  
  801446:	c3                   	ret    

00801447 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  801447:	55                   	push   %ebp
  801448:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  80144a:	6a 00                	push   $0x0
  80144c:	6a 00                	push   $0x0
  80144e:	6a 00                	push   $0x0
  801450:	6a 00                	push   $0x0
  801452:	6a 00                	push   $0x0
  801454:	6a 04                	push   $0x4
  801456:	e8 63 ff ff ff       	call   8013be <syscall>
  80145b:	83 c4 18             	add    $0x18,%esp
}
  80145e:	90                   	nop
  80145f:	c9                   	leave  
  801460:	c3                   	ret    

00801461 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801461:	55                   	push   %ebp
  801462:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801464:	8b 55 0c             	mov    0xc(%ebp),%edx
  801467:	8b 45 08             	mov    0x8(%ebp),%eax
  80146a:	6a 00                	push   $0x0
  80146c:	6a 00                	push   $0x0
  80146e:	6a 00                	push   $0x0
  801470:	52                   	push   %edx
  801471:	50                   	push   %eax
  801472:	6a 08                	push   $0x8
  801474:	e8 45 ff ff ff       	call   8013be <syscall>
  801479:	83 c4 18             	add    $0x18,%esp
}
  80147c:	c9                   	leave  
  80147d:	c3                   	ret    

0080147e <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  80147e:	55                   	push   %ebp
  80147f:	89 e5                	mov    %esp,%ebp
  801481:	56                   	push   %esi
  801482:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801483:	8b 75 18             	mov    0x18(%ebp),%esi
  801486:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801489:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80148c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80148f:	8b 45 08             	mov    0x8(%ebp),%eax
  801492:	56                   	push   %esi
  801493:	53                   	push   %ebx
  801494:	51                   	push   %ecx
  801495:	52                   	push   %edx
  801496:	50                   	push   %eax
  801497:	6a 09                	push   $0x9
  801499:	e8 20 ff ff ff       	call   8013be <syscall>
  80149e:	83 c4 18             	add    $0x18,%esp
}
  8014a1:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8014a4:	5b                   	pop    %ebx
  8014a5:	5e                   	pop    %esi
  8014a6:	5d                   	pop    %ebp
  8014a7:	c3                   	ret    

008014a8 <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  8014a8:	55                   	push   %ebp
  8014a9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  8014ab:	6a 00                	push   $0x0
  8014ad:	6a 00                	push   $0x0
  8014af:	6a 00                	push   $0x0
  8014b1:	6a 00                	push   $0x0
  8014b3:	ff 75 08             	pushl  0x8(%ebp)
  8014b6:	6a 0a                	push   $0xa
  8014b8:	e8 01 ff ff ff       	call   8013be <syscall>
  8014bd:	83 c4 18             	add    $0x18,%esp
}
  8014c0:	c9                   	leave  
  8014c1:	c3                   	ret    

008014c2 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8014c2:	55                   	push   %ebp
  8014c3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8014c5:	6a 00                	push   $0x0
  8014c7:	6a 00                	push   $0x0
  8014c9:	6a 00                	push   $0x0
  8014cb:	ff 75 0c             	pushl  0xc(%ebp)
  8014ce:	ff 75 08             	pushl  0x8(%ebp)
  8014d1:	6a 0b                	push   $0xb
  8014d3:	e8 e6 fe ff ff       	call   8013be <syscall>
  8014d8:	83 c4 18             	add    $0x18,%esp
}
  8014db:	c9                   	leave  
  8014dc:	c3                   	ret    

008014dd <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8014dd:	55                   	push   %ebp
  8014de:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8014e0:	6a 00                	push   $0x0
  8014e2:	6a 00                	push   $0x0
  8014e4:	6a 00                	push   $0x0
  8014e6:	6a 00                	push   $0x0
  8014e8:	6a 00                	push   $0x0
  8014ea:	6a 0c                	push   $0xc
  8014ec:	e8 cd fe ff ff       	call   8013be <syscall>
  8014f1:	83 c4 18             	add    $0x18,%esp
}
  8014f4:	c9                   	leave  
  8014f5:	c3                   	ret    

008014f6 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8014f6:	55                   	push   %ebp
  8014f7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8014f9:	6a 00                	push   $0x0
  8014fb:	6a 00                	push   $0x0
  8014fd:	6a 00                	push   $0x0
  8014ff:	6a 00                	push   $0x0
  801501:	6a 00                	push   $0x0
  801503:	6a 0d                	push   $0xd
  801505:	e8 b4 fe ff ff       	call   8013be <syscall>
  80150a:	83 c4 18             	add    $0x18,%esp
}
  80150d:	c9                   	leave  
  80150e:	c3                   	ret    

0080150f <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  80150f:	55                   	push   %ebp
  801510:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801512:	6a 00                	push   $0x0
  801514:	6a 00                	push   $0x0
  801516:	6a 00                	push   $0x0
  801518:	6a 00                	push   $0x0
  80151a:	6a 00                	push   $0x0
  80151c:	6a 0e                	push   $0xe
  80151e:	e8 9b fe ff ff       	call   8013be <syscall>
  801523:	83 c4 18             	add    $0x18,%esp
}
  801526:	c9                   	leave  
  801527:	c3                   	ret    

00801528 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801528:	55                   	push   %ebp
  801529:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  80152b:	6a 00                	push   $0x0
  80152d:	6a 00                	push   $0x0
  80152f:	6a 00                	push   $0x0
  801531:	6a 00                	push   $0x0
  801533:	6a 00                	push   $0x0
  801535:	6a 0f                	push   $0xf
  801537:	e8 82 fe ff ff       	call   8013be <syscall>
  80153c:	83 c4 18             	add    $0x18,%esp
}
  80153f:	c9                   	leave  
  801540:	c3                   	ret    

00801541 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801541:	55                   	push   %ebp
  801542:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801544:	6a 00                	push   $0x0
  801546:	6a 00                	push   $0x0
  801548:	6a 00                	push   $0x0
  80154a:	6a 00                	push   $0x0
  80154c:	ff 75 08             	pushl  0x8(%ebp)
  80154f:	6a 10                	push   $0x10
  801551:	e8 68 fe ff ff       	call   8013be <syscall>
  801556:	83 c4 18             	add    $0x18,%esp
}
  801559:	c9                   	leave  
  80155a:	c3                   	ret    

0080155b <sys_scarce_memory>:

void sys_scarce_memory()
{
  80155b:	55                   	push   %ebp
  80155c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  80155e:	6a 00                	push   $0x0
  801560:	6a 00                	push   $0x0
  801562:	6a 00                	push   $0x0
  801564:	6a 00                	push   $0x0
  801566:	6a 00                	push   $0x0
  801568:	6a 11                	push   $0x11
  80156a:	e8 4f fe ff ff       	call   8013be <syscall>
  80156f:	83 c4 18             	add    $0x18,%esp
}
  801572:	90                   	nop
  801573:	c9                   	leave  
  801574:	c3                   	ret    

00801575 <sys_cputc>:

void
sys_cputc(const char c)
{
  801575:	55                   	push   %ebp
  801576:	89 e5                	mov    %esp,%ebp
  801578:	83 ec 04             	sub    $0x4,%esp
  80157b:	8b 45 08             	mov    0x8(%ebp),%eax
  80157e:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801581:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801585:	6a 00                	push   $0x0
  801587:	6a 00                	push   $0x0
  801589:	6a 00                	push   $0x0
  80158b:	6a 00                	push   $0x0
  80158d:	50                   	push   %eax
  80158e:	6a 01                	push   $0x1
  801590:	e8 29 fe ff ff       	call   8013be <syscall>
  801595:	83 c4 18             	add    $0x18,%esp
}
  801598:	90                   	nop
  801599:	c9                   	leave  
  80159a:	c3                   	ret    

0080159b <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  80159b:	55                   	push   %ebp
  80159c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  80159e:	6a 00                	push   $0x0
  8015a0:	6a 00                	push   $0x0
  8015a2:	6a 00                	push   $0x0
  8015a4:	6a 00                	push   $0x0
  8015a6:	6a 00                	push   $0x0
  8015a8:	6a 14                	push   $0x14
  8015aa:	e8 0f fe ff ff       	call   8013be <syscall>
  8015af:	83 c4 18             	add    $0x18,%esp
}
  8015b2:	90                   	nop
  8015b3:	c9                   	leave  
  8015b4:	c3                   	ret    

008015b5 <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8015b5:	55                   	push   %ebp
  8015b6:	89 e5                	mov    %esp,%ebp
  8015b8:	83 ec 04             	sub    $0x4,%esp
  8015bb:	8b 45 10             	mov    0x10(%ebp),%eax
  8015be:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8015c1:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8015c4:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8015c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8015cb:	6a 00                	push   $0x0
  8015cd:	51                   	push   %ecx
  8015ce:	52                   	push   %edx
  8015cf:	ff 75 0c             	pushl  0xc(%ebp)
  8015d2:	50                   	push   %eax
  8015d3:	6a 15                	push   $0x15
  8015d5:	e8 e4 fd ff ff       	call   8013be <syscall>
  8015da:	83 c4 18             	add    $0x18,%esp
}
  8015dd:	c9                   	leave  
  8015de:	c3                   	ret    

008015df <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  8015df:	55                   	push   %ebp
  8015e0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8015e2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8015e8:	6a 00                	push   $0x0
  8015ea:	6a 00                	push   $0x0
  8015ec:	6a 00                	push   $0x0
  8015ee:	52                   	push   %edx
  8015ef:	50                   	push   %eax
  8015f0:	6a 16                	push   $0x16
  8015f2:	e8 c7 fd ff ff       	call   8013be <syscall>
  8015f7:	83 c4 18             	add    $0x18,%esp
}
  8015fa:	c9                   	leave  
  8015fb:	c3                   	ret    

008015fc <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  8015fc:	55                   	push   %ebp
  8015fd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8015ff:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801602:	8b 55 0c             	mov    0xc(%ebp),%edx
  801605:	8b 45 08             	mov    0x8(%ebp),%eax
  801608:	6a 00                	push   $0x0
  80160a:	6a 00                	push   $0x0
  80160c:	51                   	push   %ecx
  80160d:	52                   	push   %edx
  80160e:	50                   	push   %eax
  80160f:	6a 17                	push   $0x17
  801611:	e8 a8 fd ff ff       	call   8013be <syscall>
  801616:	83 c4 18             	add    $0x18,%esp
}
  801619:	c9                   	leave  
  80161a:	c3                   	ret    

0080161b <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  80161b:	55                   	push   %ebp
  80161c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  80161e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801621:	8b 45 08             	mov    0x8(%ebp),%eax
  801624:	6a 00                	push   $0x0
  801626:	6a 00                	push   $0x0
  801628:	6a 00                	push   $0x0
  80162a:	52                   	push   %edx
  80162b:	50                   	push   %eax
  80162c:	6a 18                	push   $0x18
  80162e:	e8 8b fd ff ff       	call   8013be <syscall>
  801633:	83 c4 18             	add    $0x18,%esp
}
  801636:	c9                   	leave  
  801637:	c3                   	ret    

00801638 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801638:	55                   	push   %ebp
  801639:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  80163b:	8b 45 08             	mov    0x8(%ebp),%eax
  80163e:	6a 00                	push   $0x0
  801640:	ff 75 14             	pushl  0x14(%ebp)
  801643:	ff 75 10             	pushl  0x10(%ebp)
  801646:	ff 75 0c             	pushl  0xc(%ebp)
  801649:	50                   	push   %eax
  80164a:	6a 19                	push   $0x19
  80164c:	e8 6d fd ff ff       	call   8013be <syscall>
  801651:	83 c4 18             	add    $0x18,%esp
}
  801654:	c9                   	leave  
  801655:	c3                   	ret    

00801656 <sys_run_env>:

void sys_run_env(int32 envId)
{
  801656:	55                   	push   %ebp
  801657:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801659:	8b 45 08             	mov    0x8(%ebp),%eax
  80165c:	6a 00                	push   $0x0
  80165e:	6a 00                	push   $0x0
  801660:	6a 00                	push   $0x0
  801662:	6a 00                	push   $0x0
  801664:	50                   	push   %eax
  801665:	6a 1a                	push   $0x1a
  801667:	e8 52 fd ff ff       	call   8013be <syscall>
  80166c:	83 c4 18             	add    $0x18,%esp
}
  80166f:	90                   	nop
  801670:	c9                   	leave  
  801671:	c3                   	ret    

00801672 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801672:	55                   	push   %ebp
  801673:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801675:	8b 45 08             	mov    0x8(%ebp),%eax
  801678:	6a 00                	push   $0x0
  80167a:	6a 00                	push   $0x0
  80167c:	6a 00                	push   $0x0
  80167e:	6a 00                	push   $0x0
  801680:	50                   	push   %eax
  801681:	6a 1b                	push   $0x1b
  801683:	e8 36 fd ff ff       	call   8013be <syscall>
  801688:	83 c4 18             	add    $0x18,%esp
}
  80168b:	c9                   	leave  
  80168c:	c3                   	ret    

0080168d <sys_getenvid>:

int32 sys_getenvid(void)
{
  80168d:	55                   	push   %ebp
  80168e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801690:	6a 00                	push   $0x0
  801692:	6a 00                	push   $0x0
  801694:	6a 00                	push   $0x0
  801696:	6a 00                	push   $0x0
  801698:	6a 00                	push   $0x0
  80169a:	6a 05                	push   $0x5
  80169c:	e8 1d fd ff ff       	call   8013be <syscall>
  8016a1:	83 c4 18             	add    $0x18,%esp
}
  8016a4:	c9                   	leave  
  8016a5:	c3                   	ret    

008016a6 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8016a6:	55                   	push   %ebp
  8016a7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8016a9:	6a 00                	push   $0x0
  8016ab:	6a 00                	push   $0x0
  8016ad:	6a 00                	push   $0x0
  8016af:	6a 00                	push   $0x0
  8016b1:	6a 00                	push   $0x0
  8016b3:	6a 06                	push   $0x6
  8016b5:	e8 04 fd ff ff       	call   8013be <syscall>
  8016ba:	83 c4 18             	add    $0x18,%esp
}
  8016bd:	c9                   	leave  
  8016be:	c3                   	ret    

008016bf <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8016bf:	55                   	push   %ebp
  8016c0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8016c2:	6a 00                	push   $0x0
  8016c4:	6a 00                	push   $0x0
  8016c6:	6a 00                	push   $0x0
  8016c8:	6a 00                	push   $0x0
  8016ca:	6a 00                	push   $0x0
  8016cc:	6a 07                	push   $0x7
  8016ce:	e8 eb fc ff ff       	call   8013be <syscall>
  8016d3:	83 c4 18             	add    $0x18,%esp
}
  8016d6:	c9                   	leave  
  8016d7:	c3                   	ret    

008016d8 <sys_exit_env>:


void sys_exit_env(void)
{
  8016d8:	55                   	push   %ebp
  8016d9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  8016db:	6a 00                	push   $0x0
  8016dd:	6a 00                	push   $0x0
  8016df:	6a 00                	push   $0x0
  8016e1:	6a 00                	push   $0x0
  8016e3:	6a 00                	push   $0x0
  8016e5:	6a 1c                	push   $0x1c
  8016e7:	e8 d2 fc ff ff       	call   8013be <syscall>
  8016ec:	83 c4 18             	add    $0x18,%esp
}
  8016ef:	90                   	nop
  8016f0:	c9                   	leave  
  8016f1:	c3                   	ret    

008016f2 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  8016f2:	55                   	push   %ebp
  8016f3:	89 e5                	mov    %esp,%ebp
  8016f5:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8016f8:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8016fb:	8d 50 04             	lea    0x4(%eax),%edx
  8016fe:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801701:	6a 00                	push   $0x0
  801703:	6a 00                	push   $0x0
  801705:	6a 00                	push   $0x0
  801707:	52                   	push   %edx
  801708:	50                   	push   %eax
  801709:	6a 1d                	push   $0x1d
  80170b:	e8 ae fc ff ff       	call   8013be <syscall>
  801710:	83 c4 18             	add    $0x18,%esp
	return result;
  801713:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801716:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801719:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80171c:	89 01                	mov    %eax,(%ecx)
  80171e:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801721:	8b 45 08             	mov    0x8(%ebp),%eax
  801724:	c9                   	leave  
  801725:	c2 04 00             	ret    $0x4

00801728 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801728:	55                   	push   %ebp
  801729:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  80172b:	6a 00                	push   $0x0
  80172d:	6a 00                	push   $0x0
  80172f:	ff 75 10             	pushl  0x10(%ebp)
  801732:	ff 75 0c             	pushl  0xc(%ebp)
  801735:	ff 75 08             	pushl  0x8(%ebp)
  801738:	6a 13                	push   $0x13
  80173a:	e8 7f fc ff ff       	call   8013be <syscall>
  80173f:	83 c4 18             	add    $0x18,%esp
	return ;
  801742:	90                   	nop
}
  801743:	c9                   	leave  
  801744:	c3                   	ret    

00801745 <sys_rcr2>:
uint32 sys_rcr2()
{
  801745:	55                   	push   %ebp
  801746:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801748:	6a 00                	push   $0x0
  80174a:	6a 00                	push   $0x0
  80174c:	6a 00                	push   $0x0
  80174e:	6a 00                	push   $0x0
  801750:	6a 00                	push   $0x0
  801752:	6a 1e                	push   $0x1e
  801754:	e8 65 fc ff ff       	call   8013be <syscall>
  801759:	83 c4 18             	add    $0x18,%esp
}
  80175c:	c9                   	leave  
  80175d:	c3                   	ret    

0080175e <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  80175e:	55                   	push   %ebp
  80175f:	89 e5                	mov    %esp,%ebp
  801761:	83 ec 04             	sub    $0x4,%esp
  801764:	8b 45 08             	mov    0x8(%ebp),%eax
  801767:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  80176a:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  80176e:	6a 00                	push   $0x0
  801770:	6a 00                	push   $0x0
  801772:	6a 00                	push   $0x0
  801774:	6a 00                	push   $0x0
  801776:	50                   	push   %eax
  801777:	6a 1f                	push   $0x1f
  801779:	e8 40 fc ff ff       	call   8013be <syscall>
  80177e:	83 c4 18             	add    $0x18,%esp
	return ;
  801781:	90                   	nop
}
  801782:	c9                   	leave  
  801783:	c3                   	ret    

00801784 <rsttst>:
void rsttst()
{
  801784:	55                   	push   %ebp
  801785:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801787:	6a 00                	push   $0x0
  801789:	6a 00                	push   $0x0
  80178b:	6a 00                	push   $0x0
  80178d:	6a 00                	push   $0x0
  80178f:	6a 00                	push   $0x0
  801791:	6a 21                	push   $0x21
  801793:	e8 26 fc ff ff       	call   8013be <syscall>
  801798:	83 c4 18             	add    $0x18,%esp
	return ;
  80179b:	90                   	nop
}
  80179c:	c9                   	leave  
  80179d:	c3                   	ret    

0080179e <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  80179e:	55                   	push   %ebp
  80179f:	89 e5                	mov    %esp,%ebp
  8017a1:	83 ec 04             	sub    $0x4,%esp
  8017a4:	8b 45 14             	mov    0x14(%ebp),%eax
  8017a7:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8017aa:	8b 55 18             	mov    0x18(%ebp),%edx
  8017ad:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8017b1:	52                   	push   %edx
  8017b2:	50                   	push   %eax
  8017b3:	ff 75 10             	pushl  0x10(%ebp)
  8017b6:	ff 75 0c             	pushl  0xc(%ebp)
  8017b9:	ff 75 08             	pushl  0x8(%ebp)
  8017bc:	6a 20                	push   $0x20
  8017be:	e8 fb fb ff ff       	call   8013be <syscall>
  8017c3:	83 c4 18             	add    $0x18,%esp
	return ;
  8017c6:	90                   	nop
}
  8017c7:	c9                   	leave  
  8017c8:	c3                   	ret    

008017c9 <chktst>:
void chktst(uint32 n)
{
  8017c9:	55                   	push   %ebp
  8017ca:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8017cc:	6a 00                	push   $0x0
  8017ce:	6a 00                	push   $0x0
  8017d0:	6a 00                	push   $0x0
  8017d2:	6a 00                	push   $0x0
  8017d4:	ff 75 08             	pushl  0x8(%ebp)
  8017d7:	6a 22                	push   $0x22
  8017d9:	e8 e0 fb ff ff       	call   8013be <syscall>
  8017de:	83 c4 18             	add    $0x18,%esp
	return ;
  8017e1:	90                   	nop
}
  8017e2:	c9                   	leave  
  8017e3:	c3                   	ret    

008017e4 <inctst>:

void inctst()
{
  8017e4:	55                   	push   %ebp
  8017e5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8017e7:	6a 00                	push   $0x0
  8017e9:	6a 00                	push   $0x0
  8017eb:	6a 00                	push   $0x0
  8017ed:	6a 00                	push   $0x0
  8017ef:	6a 00                	push   $0x0
  8017f1:	6a 23                	push   $0x23
  8017f3:	e8 c6 fb ff ff       	call   8013be <syscall>
  8017f8:	83 c4 18             	add    $0x18,%esp
	return ;
  8017fb:	90                   	nop
}
  8017fc:	c9                   	leave  
  8017fd:	c3                   	ret    

008017fe <gettst>:
uint32 gettst()
{
  8017fe:	55                   	push   %ebp
  8017ff:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801801:	6a 00                	push   $0x0
  801803:	6a 00                	push   $0x0
  801805:	6a 00                	push   $0x0
  801807:	6a 00                	push   $0x0
  801809:	6a 00                	push   $0x0
  80180b:	6a 24                	push   $0x24
  80180d:	e8 ac fb ff ff       	call   8013be <syscall>
  801812:	83 c4 18             	add    $0x18,%esp
}
  801815:	c9                   	leave  
  801816:	c3                   	ret    

00801817 <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  801817:	55                   	push   %ebp
  801818:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80181a:	6a 00                	push   $0x0
  80181c:	6a 00                	push   $0x0
  80181e:	6a 00                	push   $0x0
  801820:	6a 00                	push   $0x0
  801822:	6a 00                	push   $0x0
  801824:	6a 25                	push   $0x25
  801826:	e8 93 fb ff ff       	call   8013be <syscall>
  80182b:	83 c4 18             	add    $0x18,%esp
  80182e:	a3 60 b0 81 00       	mov    %eax,0x81b060
	return uheapPlaceStrategy ;
  801833:	a1 60 b0 81 00       	mov    0x81b060,%eax
}
  801838:	c9                   	leave  
  801839:	c3                   	ret    

0080183a <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  80183a:	55                   	push   %ebp
  80183b:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  80183d:	8b 45 08             	mov    0x8(%ebp),%eax
  801840:	a3 60 b0 81 00       	mov    %eax,0x81b060
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801845:	6a 00                	push   $0x0
  801847:	6a 00                	push   $0x0
  801849:	6a 00                	push   $0x0
  80184b:	6a 00                	push   $0x0
  80184d:	ff 75 08             	pushl  0x8(%ebp)
  801850:	6a 26                	push   $0x26
  801852:	e8 67 fb ff ff       	call   8013be <syscall>
  801857:	83 c4 18             	add    $0x18,%esp
	return ;
  80185a:	90                   	nop
}
  80185b:	c9                   	leave  
  80185c:	c3                   	ret    

0080185d <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  80185d:	55                   	push   %ebp
  80185e:	89 e5                	mov    %esp,%ebp
  801860:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801861:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801864:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801867:	8b 55 0c             	mov    0xc(%ebp),%edx
  80186a:	8b 45 08             	mov    0x8(%ebp),%eax
  80186d:	6a 00                	push   $0x0
  80186f:	53                   	push   %ebx
  801870:	51                   	push   %ecx
  801871:	52                   	push   %edx
  801872:	50                   	push   %eax
  801873:	6a 27                	push   $0x27
  801875:	e8 44 fb ff ff       	call   8013be <syscall>
  80187a:	83 c4 18             	add    $0x18,%esp
}
  80187d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801880:	c9                   	leave  
  801881:	c3                   	ret    

00801882 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801882:	55                   	push   %ebp
  801883:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801885:	8b 55 0c             	mov    0xc(%ebp),%edx
  801888:	8b 45 08             	mov    0x8(%ebp),%eax
  80188b:	6a 00                	push   $0x0
  80188d:	6a 00                	push   $0x0
  80188f:	6a 00                	push   $0x0
  801891:	52                   	push   %edx
  801892:	50                   	push   %eax
  801893:	6a 28                	push   $0x28
  801895:	e8 24 fb ff ff       	call   8013be <syscall>
  80189a:	83 c4 18             	add    $0x18,%esp
}
  80189d:	c9                   	leave  
  80189e:	c3                   	ret    

0080189f <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  80189f:	55                   	push   %ebp
  8018a0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  8018a2:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8018a5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8018ab:	6a 00                	push   $0x0
  8018ad:	51                   	push   %ecx
  8018ae:	ff 75 10             	pushl  0x10(%ebp)
  8018b1:	52                   	push   %edx
  8018b2:	50                   	push   %eax
  8018b3:	6a 29                	push   $0x29
  8018b5:	e8 04 fb ff ff       	call   8013be <syscall>
  8018ba:	83 c4 18             	add    $0x18,%esp
}
  8018bd:	c9                   	leave  
  8018be:	c3                   	ret    

008018bf <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8018bf:	55                   	push   %ebp
  8018c0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8018c2:	6a 00                	push   $0x0
  8018c4:	6a 00                	push   $0x0
  8018c6:	ff 75 10             	pushl  0x10(%ebp)
  8018c9:	ff 75 0c             	pushl  0xc(%ebp)
  8018cc:	ff 75 08             	pushl  0x8(%ebp)
  8018cf:	6a 12                	push   $0x12
  8018d1:	e8 e8 fa ff ff       	call   8013be <syscall>
  8018d6:	83 c4 18             	add    $0x18,%esp
	return ;
  8018d9:	90                   	nop
}
  8018da:	c9                   	leave  
  8018db:	c3                   	ret    

008018dc <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  8018dc:	55                   	push   %ebp
  8018dd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  8018df:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8018e5:	6a 00                	push   $0x0
  8018e7:	6a 00                	push   $0x0
  8018e9:	6a 00                	push   $0x0
  8018eb:	52                   	push   %edx
  8018ec:	50                   	push   %eax
  8018ed:	6a 2a                	push   $0x2a
  8018ef:	e8 ca fa ff ff       	call   8013be <syscall>
  8018f4:	83 c4 18             	add    $0x18,%esp
	return;
  8018f7:	90                   	nop
}
  8018f8:	c9                   	leave  
  8018f9:	c3                   	ret    

008018fa <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  8018fa:	55                   	push   %ebp
  8018fb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  8018fd:	6a 00                	push   $0x0
  8018ff:	6a 00                	push   $0x0
  801901:	6a 00                	push   $0x0
  801903:	6a 00                	push   $0x0
  801905:	6a 00                	push   $0x0
  801907:	6a 2b                	push   $0x2b
  801909:	e8 b0 fa ff ff       	call   8013be <syscall>
  80190e:	83 c4 18             	add    $0x18,%esp
}
  801911:	c9                   	leave  
  801912:	c3                   	ret    

00801913 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801913:	55                   	push   %ebp
  801914:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801916:	6a 00                	push   $0x0
  801918:	6a 00                	push   $0x0
  80191a:	6a 00                	push   $0x0
  80191c:	ff 75 0c             	pushl  0xc(%ebp)
  80191f:	ff 75 08             	pushl  0x8(%ebp)
  801922:	6a 2d                	push   $0x2d
  801924:	e8 95 fa ff ff       	call   8013be <syscall>
  801929:	83 c4 18             	add    $0x18,%esp
	return;
  80192c:	90                   	nop
}
  80192d:	c9                   	leave  
  80192e:	c3                   	ret    

0080192f <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  80192f:	55                   	push   %ebp
  801930:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801932:	6a 00                	push   $0x0
  801934:	6a 00                	push   $0x0
  801936:	6a 00                	push   $0x0
  801938:	ff 75 0c             	pushl  0xc(%ebp)
  80193b:	ff 75 08             	pushl  0x8(%ebp)
  80193e:	6a 2c                	push   $0x2c
  801940:	e8 79 fa ff ff       	call   8013be <syscall>
  801945:	83 c4 18             	add    $0x18,%esp
	return ;
  801948:	90                   	nop
}
  801949:	c9                   	leave  
  80194a:	c3                   	ret    

0080194b <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  80194b:	55                   	push   %ebp
  80194c:	89 e5                	mov    %esp,%ebp
	//TODO: [PROJECT'25.IM#4] CPU SCHEDULING - #1 System Calls - Add suitable code here
	//Your code is here
	//Comment the following line
	//panic("sys_env_set_priority() is not implemented yet...!!");
	syscall(SYS_env_set_priority, envID, priority, 0, 0, 0);
  80194e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801951:	8b 45 08             	mov    0x8(%ebp),%eax
  801954:	6a 00                	push   $0x0
  801956:	6a 00                	push   $0x0
  801958:	6a 00                	push   $0x0
  80195a:	52                   	push   %edx
  80195b:	50                   	push   %eax
  80195c:	6a 2e                	push   $0x2e
  80195e:	e8 5b fa ff ff       	call   8013be <syscall>
  801963:	83 c4 18             	add    $0x18,%esp
	    return;
  801966:	90                   	nop
}
  801967:	c9                   	leave  
  801968:	c3                   	ret    
  801969:	66 90                	xchg   %ax,%ax
  80196b:	90                   	nop

0080196c <__udivdi3>:
  80196c:	55                   	push   %ebp
  80196d:	57                   	push   %edi
  80196e:	56                   	push   %esi
  80196f:	53                   	push   %ebx
  801970:	83 ec 1c             	sub    $0x1c,%esp
  801973:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801977:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80197b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80197f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801983:	89 ca                	mov    %ecx,%edx
  801985:	89 f8                	mov    %edi,%eax
  801987:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80198b:	85 f6                	test   %esi,%esi
  80198d:	75 2d                	jne    8019bc <__udivdi3+0x50>
  80198f:	39 cf                	cmp    %ecx,%edi
  801991:	77 65                	ja     8019f8 <__udivdi3+0x8c>
  801993:	89 fd                	mov    %edi,%ebp
  801995:	85 ff                	test   %edi,%edi
  801997:	75 0b                	jne    8019a4 <__udivdi3+0x38>
  801999:	b8 01 00 00 00       	mov    $0x1,%eax
  80199e:	31 d2                	xor    %edx,%edx
  8019a0:	f7 f7                	div    %edi
  8019a2:	89 c5                	mov    %eax,%ebp
  8019a4:	31 d2                	xor    %edx,%edx
  8019a6:	89 c8                	mov    %ecx,%eax
  8019a8:	f7 f5                	div    %ebp
  8019aa:	89 c1                	mov    %eax,%ecx
  8019ac:	89 d8                	mov    %ebx,%eax
  8019ae:	f7 f5                	div    %ebp
  8019b0:	89 cf                	mov    %ecx,%edi
  8019b2:	89 fa                	mov    %edi,%edx
  8019b4:	83 c4 1c             	add    $0x1c,%esp
  8019b7:	5b                   	pop    %ebx
  8019b8:	5e                   	pop    %esi
  8019b9:	5f                   	pop    %edi
  8019ba:	5d                   	pop    %ebp
  8019bb:	c3                   	ret    
  8019bc:	39 ce                	cmp    %ecx,%esi
  8019be:	77 28                	ja     8019e8 <__udivdi3+0x7c>
  8019c0:	0f bd fe             	bsr    %esi,%edi
  8019c3:	83 f7 1f             	xor    $0x1f,%edi
  8019c6:	75 40                	jne    801a08 <__udivdi3+0x9c>
  8019c8:	39 ce                	cmp    %ecx,%esi
  8019ca:	72 0a                	jb     8019d6 <__udivdi3+0x6a>
  8019cc:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8019d0:	0f 87 9e 00 00 00    	ja     801a74 <__udivdi3+0x108>
  8019d6:	b8 01 00 00 00       	mov    $0x1,%eax
  8019db:	89 fa                	mov    %edi,%edx
  8019dd:	83 c4 1c             	add    $0x1c,%esp
  8019e0:	5b                   	pop    %ebx
  8019e1:	5e                   	pop    %esi
  8019e2:	5f                   	pop    %edi
  8019e3:	5d                   	pop    %ebp
  8019e4:	c3                   	ret    
  8019e5:	8d 76 00             	lea    0x0(%esi),%esi
  8019e8:	31 ff                	xor    %edi,%edi
  8019ea:	31 c0                	xor    %eax,%eax
  8019ec:	89 fa                	mov    %edi,%edx
  8019ee:	83 c4 1c             	add    $0x1c,%esp
  8019f1:	5b                   	pop    %ebx
  8019f2:	5e                   	pop    %esi
  8019f3:	5f                   	pop    %edi
  8019f4:	5d                   	pop    %ebp
  8019f5:	c3                   	ret    
  8019f6:	66 90                	xchg   %ax,%ax
  8019f8:	89 d8                	mov    %ebx,%eax
  8019fa:	f7 f7                	div    %edi
  8019fc:	31 ff                	xor    %edi,%edi
  8019fe:	89 fa                	mov    %edi,%edx
  801a00:	83 c4 1c             	add    $0x1c,%esp
  801a03:	5b                   	pop    %ebx
  801a04:	5e                   	pop    %esi
  801a05:	5f                   	pop    %edi
  801a06:	5d                   	pop    %ebp
  801a07:	c3                   	ret    
  801a08:	bd 20 00 00 00       	mov    $0x20,%ebp
  801a0d:	89 eb                	mov    %ebp,%ebx
  801a0f:	29 fb                	sub    %edi,%ebx
  801a11:	89 f9                	mov    %edi,%ecx
  801a13:	d3 e6                	shl    %cl,%esi
  801a15:	89 c5                	mov    %eax,%ebp
  801a17:	88 d9                	mov    %bl,%cl
  801a19:	d3 ed                	shr    %cl,%ebp
  801a1b:	89 e9                	mov    %ebp,%ecx
  801a1d:	09 f1                	or     %esi,%ecx
  801a1f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801a23:	89 f9                	mov    %edi,%ecx
  801a25:	d3 e0                	shl    %cl,%eax
  801a27:	89 c5                	mov    %eax,%ebp
  801a29:	89 d6                	mov    %edx,%esi
  801a2b:	88 d9                	mov    %bl,%cl
  801a2d:	d3 ee                	shr    %cl,%esi
  801a2f:	89 f9                	mov    %edi,%ecx
  801a31:	d3 e2                	shl    %cl,%edx
  801a33:	8b 44 24 08          	mov    0x8(%esp),%eax
  801a37:	88 d9                	mov    %bl,%cl
  801a39:	d3 e8                	shr    %cl,%eax
  801a3b:	09 c2                	or     %eax,%edx
  801a3d:	89 d0                	mov    %edx,%eax
  801a3f:	89 f2                	mov    %esi,%edx
  801a41:	f7 74 24 0c          	divl   0xc(%esp)
  801a45:	89 d6                	mov    %edx,%esi
  801a47:	89 c3                	mov    %eax,%ebx
  801a49:	f7 e5                	mul    %ebp
  801a4b:	39 d6                	cmp    %edx,%esi
  801a4d:	72 19                	jb     801a68 <__udivdi3+0xfc>
  801a4f:	74 0b                	je     801a5c <__udivdi3+0xf0>
  801a51:	89 d8                	mov    %ebx,%eax
  801a53:	31 ff                	xor    %edi,%edi
  801a55:	e9 58 ff ff ff       	jmp    8019b2 <__udivdi3+0x46>
  801a5a:	66 90                	xchg   %ax,%ax
  801a5c:	8b 54 24 08          	mov    0x8(%esp),%edx
  801a60:	89 f9                	mov    %edi,%ecx
  801a62:	d3 e2                	shl    %cl,%edx
  801a64:	39 c2                	cmp    %eax,%edx
  801a66:	73 e9                	jae    801a51 <__udivdi3+0xe5>
  801a68:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801a6b:	31 ff                	xor    %edi,%edi
  801a6d:	e9 40 ff ff ff       	jmp    8019b2 <__udivdi3+0x46>
  801a72:	66 90                	xchg   %ax,%ax
  801a74:	31 c0                	xor    %eax,%eax
  801a76:	e9 37 ff ff ff       	jmp    8019b2 <__udivdi3+0x46>
  801a7b:	90                   	nop

00801a7c <__umoddi3>:
  801a7c:	55                   	push   %ebp
  801a7d:	57                   	push   %edi
  801a7e:	56                   	push   %esi
  801a7f:	53                   	push   %ebx
  801a80:	83 ec 1c             	sub    $0x1c,%esp
  801a83:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801a87:	8b 74 24 34          	mov    0x34(%esp),%esi
  801a8b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801a8f:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801a93:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801a97:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801a9b:	89 f3                	mov    %esi,%ebx
  801a9d:	89 fa                	mov    %edi,%edx
  801a9f:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801aa3:	89 34 24             	mov    %esi,(%esp)
  801aa6:	85 c0                	test   %eax,%eax
  801aa8:	75 1a                	jne    801ac4 <__umoddi3+0x48>
  801aaa:	39 f7                	cmp    %esi,%edi
  801aac:	0f 86 a2 00 00 00    	jbe    801b54 <__umoddi3+0xd8>
  801ab2:	89 c8                	mov    %ecx,%eax
  801ab4:	89 f2                	mov    %esi,%edx
  801ab6:	f7 f7                	div    %edi
  801ab8:	89 d0                	mov    %edx,%eax
  801aba:	31 d2                	xor    %edx,%edx
  801abc:	83 c4 1c             	add    $0x1c,%esp
  801abf:	5b                   	pop    %ebx
  801ac0:	5e                   	pop    %esi
  801ac1:	5f                   	pop    %edi
  801ac2:	5d                   	pop    %ebp
  801ac3:	c3                   	ret    
  801ac4:	39 f0                	cmp    %esi,%eax
  801ac6:	0f 87 ac 00 00 00    	ja     801b78 <__umoddi3+0xfc>
  801acc:	0f bd e8             	bsr    %eax,%ebp
  801acf:	83 f5 1f             	xor    $0x1f,%ebp
  801ad2:	0f 84 ac 00 00 00    	je     801b84 <__umoddi3+0x108>
  801ad8:	bf 20 00 00 00       	mov    $0x20,%edi
  801add:	29 ef                	sub    %ebp,%edi
  801adf:	89 fe                	mov    %edi,%esi
  801ae1:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801ae5:	89 e9                	mov    %ebp,%ecx
  801ae7:	d3 e0                	shl    %cl,%eax
  801ae9:	89 d7                	mov    %edx,%edi
  801aeb:	89 f1                	mov    %esi,%ecx
  801aed:	d3 ef                	shr    %cl,%edi
  801aef:	09 c7                	or     %eax,%edi
  801af1:	89 e9                	mov    %ebp,%ecx
  801af3:	d3 e2                	shl    %cl,%edx
  801af5:	89 14 24             	mov    %edx,(%esp)
  801af8:	89 d8                	mov    %ebx,%eax
  801afa:	d3 e0                	shl    %cl,%eax
  801afc:	89 c2                	mov    %eax,%edx
  801afe:	8b 44 24 08          	mov    0x8(%esp),%eax
  801b02:	d3 e0                	shl    %cl,%eax
  801b04:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b08:	8b 44 24 08          	mov    0x8(%esp),%eax
  801b0c:	89 f1                	mov    %esi,%ecx
  801b0e:	d3 e8                	shr    %cl,%eax
  801b10:	09 d0                	or     %edx,%eax
  801b12:	d3 eb                	shr    %cl,%ebx
  801b14:	89 da                	mov    %ebx,%edx
  801b16:	f7 f7                	div    %edi
  801b18:	89 d3                	mov    %edx,%ebx
  801b1a:	f7 24 24             	mull   (%esp)
  801b1d:	89 c6                	mov    %eax,%esi
  801b1f:	89 d1                	mov    %edx,%ecx
  801b21:	39 d3                	cmp    %edx,%ebx
  801b23:	0f 82 87 00 00 00    	jb     801bb0 <__umoddi3+0x134>
  801b29:	0f 84 91 00 00 00    	je     801bc0 <__umoddi3+0x144>
  801b2f:	8b 54 24 04          	mov    0x4(%esp),%edx
  801b33:	29 f2                	sub    %esi,%edx
  801b35:	19 cb                	sbb    %ecx,%ebx
  801b37:	89 d8                	mov    %ebx,%eax
  801b39:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801b3d:	d3 e0                	shl    %cl,%eax
  801b3f:	89 e9                	mov    %ebp,%ecx
  801b41:	d3 ea                	shr    %cl,%edx
  801b43:	09 d0                	or     %edx,%eax
  801b45:	89 e9                	mov    %ebp,%ecx
  801b47:	d3 eb                	shr    %cl,%ebx
  801b49:	89 da                	mov    %ebx,%edx
  801b4b:	83 c4 1c             	add    $0x1c,%esp
  801b4e:	5b                   	pop    %ebx
  801b4f:	5e                   	pop    %esi
  801b50:	5f                   	pop    %edi
  801b51:	5d                   	pop    %ebp
  801b52:	c3                   	ret    
  801b53:	90                   	nop
  801b54:	89 fd                	mov    %edi,%ebp
  801b56:	85 ff                	test   %edi,%edi
  801b58:	75 0b                	jne    801b65 <__umoddi3+0xe9>
  801b5a:	b8 01 00 00 00       	mov    $0x1,%eax
  801b5f:	31 d2                	xor    %edx,%edx
  801b61:	f7 f7                	div    %edi
  801b63:	89 c5                	mov    %eax,%ebp
  801b65:	89 f0                	mov    %esi,%eax
  801b67:	31 d2                	xor    %edx,%edx
  801b69:	f7 f5                	div    %ebp
  801b6b:	89 c8                	mov    %ecx,%eax
  801b6d:	f7 f5                	div    %ebp
  801b6f:	89 d0                	mov    %edx,%eax
  801b71:	e9 44 ff ff ff       	jmp    801aba <__umoddi3+0x3e>
  801b76:	66 90                	xchg   %ax,%ax
  801b78:	89 c8                	mov    %ecx,%eax
  801b7a:	89 f2                	mov    %esi,%edx
  801b7c:	83 c4 1c             	add    $0x1c,%esp
  801b7f:	5b                   	pop    %ebx
  801b80:	5e                   	pop    %esi
  801b81:	5f                   	pop    %edi
  801b82:	5d                   	pop    %ebp
  801b83:	c3                   	ret    
  801b84:	3b 04 24             	cmp    (%esp),%eax
  801b87:	72 06                	jb     801b8f <__umoddi3+0x113>
  801b89:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801b8d:	77 0f                	ja     801b9e <__umoddi3+0x122>
  801b8f:	89 f2                	mov    %esi,%edx
  801b91:	29 f9                	sub    %edi,%ecx
  801b93:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801b97:	89 14 24             	mov    %edx,(%esp)
  801b9a:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801b9e:	8b 44 24 04          	mov    0x4(%esp),%eax
  801ba2:	8b 14 24             	mov    (%esp),%edx
  801ba5:	83 c4 1c             	add    $0x1c,%esp
  801ba8:	5b                   	pop    %ebx
  801ba9:	5e                   	pop    %esi
  801baa:	5f                   	pop    %edi
  801bab:	5d                   	pop    %ebp
  801bac:	c3                   	ret    
  801bad:	8d 76 00             	lea    0x0(%esi),%esi
  801bb0:	2b 04 24             	sub    (%esp),%eax
  801bb3:	19 fa                	sbb    %edi,%edx
  801bb5:	89 d1                	mov    %edx,%ecx
  801bb7:	89 c6                	mov    %eax,%esi
  801bb9:	e9 71 ff ff ff       	jmp    801b2f <__umoddi3+0xb3>
  801bbe:	66 90                	xchg   %ax,%ax
  801bc0:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801bc4:	72 ea                	jb     801bb0 <__umoddi3+0x134>
  801bc6:	89 d9                	mov    %ebx,%ecx
  801bc8:	e9 62 ff ff ff       	jmp    801b2f <__umoddi3+0xb3>
