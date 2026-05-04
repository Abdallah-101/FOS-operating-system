
obj/user/tst_protection_slave1:     file format elf32-i386


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
  800031:	e8 02 01 00 00       	call   800138 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
#include <inc/lib.h>

void
_main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	81 ec 58 4e 00 00    	sub    $0x4e58,%esp

	/*=================================================*/
	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
#if USE_KHEAP
	{
		if (LIST_SIZE(&(myEnv->page_WS_list)) >= myEnv->page_WS_max_size)
  800041:	a1 20 50 80 00       	mov    0x805020,%eax
  800046:	8b 90 94 00 00 00    	mov    0x94(%eax),%edx
  80004c:	a1 20 50 80 00       	mov    0x805020,%eax
  800051:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  800057:	39 c2                	cmp    %eax,%edx
  800059:	72 14                	jb     80006f <_main+0x37>
			panic("Please increase the WS size");
  80005b:	83 ec 04             	sub    $0x4,%esp
  80005e:	68 a0 41 80 00       	push   $0x8041a0
  800063:	6a 12                	push   $0x12
  800065:	68 bc 41 80 00       	push   $0x8041bc
  80006a:	e8 82 02 00 00       	call   8002f1 <_panic>
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif
	/*=================================================*/

	{
		char initname[10] = "x";
  80006f:	c7 45 e6 78 00 00 00 	movl   $0x78,-0x1a(%ebp)
  800076:	c7 45 ea 00 00 00 00 	movl   $0x0,-0x16(%ebp)
  80007d:	66 c7 45 ee 00 00    	movw   $0x0,-0x12(%ebp)
		char name[10] ;
#define NUM_OF_OBJS 5000
		uint32* vars[NUM_OF_OBJS];
		for (int s = 0; s < NUM_OF_OBJS; ++s)
  800083:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80008a:	eb 5d                	jmp    8000e9 <_main+0xb1>
		{
			char index[10];
			ltostr(s, index);
  80008c:	83 ec 08             	sub    $0x8,%esp
  80008f:	8d 45 d2             	lea    -0x2e(%ebp),%eax
  800092:	50                   	push   %eax
  800093:	ff 75 f4             	pushl  -0xc(%ebp)
  800096:	e8 52 11 00 00       	call   8011ed <ltostr>
  80009b:	83 c4 10             	add    $0x10,%esp
			strcconcat(initname, index, name);
  80009e:	83 ec 04             	sub    $0x4,%esp
  8000a1:	8d 45 dc             	lea    -0x24(%ebp),%eax
  8000a4:	50                   	push   %eax
  8000a5:	8d 45 d2             	lea    -0x2e(%ebp),%eax
  8000a8:	50                   	push   %eax
  8000a9:	8d 45 e6             	lea    -0x1a(%ebp),%eax
  8000ac:	50                   	push   %eax
  8000ad:	e8 14 12 00 00       	call   8012c6 <strcconcat>
  8000b2:	83 c4 10             	add    $0x10,%esp
			vars[s] = smalloc(name, PAGE_SIZE, 1);
  8000b5:	83 ec 04             	sub    $0x4,%esp
  8000b8:	6a 01                	push   $0x1
  8000ba:	68 00 10 00 00       	push   $0x1000
  8000bf:	8d 45 dc             	lea    -0x24(%ebp),%eax
  8000c2:	50                   	push   %eax
  8000c3:	e8 9e 21 00 00       	call   802266 <smalloc>
  8000c8:	83 c4 10             	add    $0x10,%esp
  8000cb:	89 c2                	mov    %eax,%edx
  8000cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8000d0:	89 94 85 b0 b1 ff ff 	mov    %edx,-0x4e50(%ebp,%eax,4)
			*vars[s] = s;
  8000d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8000da:	8b 84 85 b0 b1 ff ff 	mov    -0x4e50(%ebp,%eax,4),%eax
  8000e1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8000e4:	89 10                	mov    %edx,(%eax)
	{
		char initname[10] = "x";
		char name[10] ;
#define NUM_OF_OBJS 5000
		uint32* vars[NUM_OF_OBJS];
		for (int s = 0; s < NUM_OF_OBJS; ++s)
  8000e6:	ff 45 f4             	incl   -0xc(%ebp)
  8000e9:	81 7d f4 87 13 00 00 	cmpl   $0x1387,-0xc(%ebp)
  8000f0:	7e 9a                	jle    80008c <_main+0x54>
			ltostr(s, index);
			strcconcat(initname, index, name);
			vars[s] = smalloc(name, PAGE_SIZE, 1);
			*vars[s] = s;
		}
		for (int s = 0; s < NUM_OF_OBJS; ++s)
  8000f2:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8000f9:	eb 2c                	jmp    800127 <_main+0xef>
		{
			assert(*vars[s] == s);
  8000fb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8000fe:	8b 84 85 b0 b1 ff ff 	mov    -0x4e50(%ebp,%eax,4),%eax
  800105:	8b 10                	mov    (%eax),%edx
  800107:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80010a:	39 c2                	cmp    %eax,%edx
  80010c:	74 16                	je     800124 <_main+0xec>
  80010e:	68 d9 41 80 00       	push   $0x8041d9
  800113:	68 e7 41 80 00       	push   $0x8041e7
  800118:	6a 28                	push   $0x28
  80011a:	68 bc 41 80 00       	push   $0x8041bc
  80011f:	e8 cd 01 00 00       	call   8002f1 <_panic>
			ltostr(s, index);
			strcconcat(initname, index, name);
			vars[s] = smalloc(name, PAGE_SIZE, 1);
			*vars[s] = s;
		}
		for (int s = 0; s < NUM_OF_OBJS; ++s)
  800124:	ff 45 f0             	incl   -0x10(%ebp)
  800127:	81 7d f0 87 13 00 00 	cmpl   $0x1387,-0x10(%ebp)
  80012e:	7e cb                	jle    8000fb <_main+0xc3>
		{
			assert(*vars[s] == s);
		}
	}

	inctst();
  800130:	e8 fc 30 00 00       	call   803231 <inctst>
}
  800135:	90                   	nop
  800136:	c9                   	leave  
  800137:	c3                   	ret    

00800138 <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  800138:	55                   	push   %ebp
  800139:	89 e5                	mov    %esp,%ebp
  80013b:	57                   	push   %edi
  80013c:	56                   	push   %esi
  80013d:	53                   	push   %ebx
  80013e:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  800141:	e8 ad 2f 00 00       	call   8030f3 <sys_getenvindex>
  800146:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  800149:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80014c:	89 d0                	mov    %edx,%eax
  80014e:	c1 e0 02             	shl    $0x2,%eax
  800151:	01 d0                	add    %edx,%eax
  800153:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80015a:	01 d0                	add    %edx,%eax
  80015c:	89 c2                	mov    %eax,%edx
  80015e:	c1 e2 04             	shl    $0x4,%edx
  800161:	29 c2                	sub    %eax,%edx
  800163:	8d 04 95 00 00 00 00 	lea    0x0(,%edx,4),%eax
  80016a:	89 c2                	mov    %eax,%edx
  80016c:	8d 82 00 00 c0 ee    	lea    -0x11400000(%edx),%eax
  800172:	a3 20 50 80 00       	mov    %eax,0x805020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800177:	a1 20 50 80 00       	mov    0x805020,%eax
  80017c:	8a 40 20             	mov    0x20(%eax),%al
  80017f:	84 c0                	test   %al,%al
  800181:	74 0d                	je     800190 <libmain+0x58>
		binaryname = myEnv->prog_name;
  800183:	a1 20 50 80 00       	mov    0x805020,%eax
  800188:	83 c0 20             	add    $0x20,%eax
  80018b:	a3 04 50 80 00       	mov    %eax,0x805004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800190:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800194:	7e 0a                	jle    8001a0 <libmain+0x68>
		binaryname = argv[0];
  800196:	8b 45 0c             	mov    0xc(%ebp),%eax
  800199:	8b 00                	mov    (%eax),%eax
  80019b:	a3 04 50 80 00       	mov    %eax,0x805004

	// call user main routine
	_main(argc, argv);
  8001a0:	83 ec 08             	sub    $0x8,%esp
  8001a3:	ff 75 0c             	pushl  0xc(%ebp)
  8001a6:	ff 75 08             	pushl  0x8(%ebp)
  8001a9:	e8 8a fe ff ff       	call   800038 <_main>
  8001ae:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  8001b1:	a1 00 50 80 00       	mov    0x805000,%eax
  8001b6:	85 c0                	test   %eax,%eax
  8001b8:	0f 84 01 01 00 00    	je     8002bf <libmain+0x187>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  8001be:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  8001c4:	bb f4 42 80 00       	mov    $0x8042f4,%ebx
  8001c9:	ba 0e 00 00 00       	mov    $0xe,%edx
  8001ce:	89 c7                	mov    %eax,%edi
  8001d0:	89 de                	mov    %ebx,%esi
  8001d2:	89 d1                	mov    %edx,%ecx
  8001d4:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  8001d6:	8d 55 8a             	lea    -0x76(%ebp),%edx
  8001d9:	b9 56 00 00 00       	mov    $0x56,%ecx
  8001de:	b0 00                	mov    $0x0,%al
  8001e0:	89 d7                	mov    %edx,%edi
  8001e2:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  8001e4:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  8001eb:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8001ee:	83 ec 08             	sub    $0x8,%esp
  8001f1:	50                   	push   %eax
  8001f2:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  8001f8:	50                   	push   %eax
  8001f9:	e8 2b 31 00 00       	call   803329 <sys_utilities>
  8001fe:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  800201:	e8 74 2c 00 00       	call   802e7a <sys_lock_cons>
		{
			cprintf("**************************************\n");
  800206:	83 ec 0c             	sub    $0xc,%esp
  800209:	68 14 42 80 00       	push   $0x804214
  80020e:	e8 ac 03 00 00       	call   8005bf <cprintf>
  800213:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  800216:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800219:	85 c0                	test   %eax,%eax
  80021b:	74 18                	je     800235 <libmain+0xfd>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  80021d:	e8 25 31 00 00       	call   803347 <sys_get_optimal_num_faults>
  800222:	83 ec 08             	sub    $0x8,%esp
  800225:	50                   	push   %eax
  800226:	68 3c 42 80 00       	push   $0x80423c
  80022b:	e8 8f 03 00 00       	call   8005bf <cprintf>
  800230:	83 c4 10             	add    $0x10,%esp
  800233:	eb 59                	jmp    80028e <libmain+0x156>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800235:	a1 20 50 80 00       	mov    0x805020,%eax
  80023a:	8b 90 bc 05 00 00    	mov    0x5bc(%eax),%edx
  800240:	a1 20 50 80 00       	mov    0x805020,%eax
  800245:	8b 80 ac 05 00 00    	mov    0x5ac(%eax),%eax
  80024b:	83 ec 04             	sub    $0x4,%esp
  80024e:	52                   	push   %edx
  80024f:	50                   	push   %eax
  800250:	68 60 42 80 00       	push   $0x804260
  800255:	e8 65 03 00 00       	call   8005bf <cprintf>
  80025a:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  80025d:	a1 20 50 80 00       	mov    0x805020,%eax
  800262:	8b 88 d0 05 00 00    	mov    0x5d0(%eax),%ecx
  800268:	a1 20 50 80 00       	mov    0x805020,%eax
  80026d:	8b 90 cc 05 00 00    	mov    0x5cc(%eax),%edx
  800273:	a1 20 50 80 00       	mov    0x805020,%eax
  800278:	8b 80 c8 05 00 00    	mov    0x5c8(%eax),%eax
  80027e:	51                   	push   %ecx
  80027f:	52                   	push   %edx
  800280:	50                   	push   %eax
  800281:	68 88 42 80 00       	push   $0x804288
  800286:	e8 34 03 00 00       	call   8005bf <cprintf>
  80028b:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80028e:	a1 20 50 80 00       	mov    0x805020,%eax
  800293:	8b 80 d4 05 00 00    	mov    0x5d4(%eax),%eax
  800299:	83 ec 08             	sub    $0x8,%esp
  80029c:	50                   	push   %eax
  80029d:	68 e0 42 80 00       	push   $0x8042e0
  8002a2:	e8 18 03 00 00       	call   8005bf <cprintf>
  8002a7:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  8002aa:	83 ec 0c             	sub    $0xc,%esp
  8002ad:	68 14 42 80 00       	push   $0x804214
  8002b2:	e8 08 03 00 00       	call   8005bf <cprintf>
  8002b7:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  8002ba:	e8 d5 2b 00 00       	call   802e94 <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  8002bf:	e8 1f 00 00 00       	call   8002e3 <exit>
}
  8002c4:	90                   	nop
  8002c5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002c8:	5b                   	pop    %ebx
  8002c9:	5e                   	pop    %esi
  8002ca:	5f                   	pop    %edi
  8002cb:	5d                   	pop    %ebp
  8002cc:	c3                   	ret    

008002cd <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8002cd:	55                   	push   %ebp
  8002ce:	89 e5                	mov    %esp,%ebp
  8002d0:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8002d3:	83 ec 0c             	sub    $0xc,%esp
  8002d6:	6a 00                	push   $0x0
  8002d8:	e8 e2 2d 00 00       	call   8030bf <sys_destroy_env>
  8002dd:	83 c4 10             	add    $0x10,%esp
}
  8002e0:	90                   	nop
  8002e1:	c9                   	leave  
  8002e2:	c3                   	ret    

008002e3 <exit>:

void
exit(void)
{
  8002e3:	55                   	push   %ebp
  8002e4:	89 e5                	mov    %esp,%ebp
  8002e6:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8002e9:	e8 37 2e 00 00       	call   803125 <sys_exit_env>
}
  8002ee:	90                   	nop
  8002ef:	c9                   	leave  
  8002f0:	c3                   	ret    

008002f1 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8002f1:	55                   	push   %ebp
  8002f2:	89 e5                	mov    %esp,%ebp
  8002f4:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8002f7:	8d 45 10             	lea    0x10(%ebp),%eax
  8002fa:	83 c0 04             	add    $0x4,%eax
  8002fd:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800300:	a1 18 d1 81 00       	mov    0x81d118,%eax
  800305:	85 c0                	test   %eax,%eax
  800307:	74 16                	je     80031f <_panic+0x2e>
		cprintf("%s: ", argv0);
  800309:	a1 18 d1 81 00       	mov    0x81d118,%eax
  80030e:	83 ec 08             	sub    $0x8,%esp
  800311:	50                   	push   %eax
  800312:	68 58 43 80 00       	push   $0x804358
  800317:	e8 a3 02 00 00       	call   8005bf <cprintf>
  80031c:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  80031f:	a1 04 50 80 00       	mov    0x805004,%eax
  800324:	83 ec 0c             	sub    $0xc,%esp
  800327:	ff 75 0c             	pushl  0xc(%ebp)
  80032a:	ff 75 08             	pushl  0x8(%ebp)
  80032d:	50                   	push   %eax
  80032e:	68 60 43 80 00       	push   $0x804360
  800333:	6a 74                	push   $0x74
  800335:	e8 b2 02 00 00       	call   8005ec <cprintf_colored>
  80033a:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  80033d:	8b 45 10             	mov    0x10(%ebp),%eax
  800340:	83 ec 08             	sub    $0x8,%esp
  800343:	ff 75 f4             	pushl  -0xc(%ebp)
  800346:	50                   	push   %eax
  800347:	e8 04 02 00 00       	call   800550 <vcprintf>
  80034c:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  80034f:	83 ec 08             	sub    $0x8,%esp
  800352:	6a 00                	push   $0x0
  800354:	68 88 43 80 00       	push   $0x804388
  800359:	e8 f2 01 00 00       	call   800550 <vcprintf>
  80035e:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800361:	e8 7d ff ff ff       	call   8002e3 <exit>

	// should not return here
	while (1) ;
  800366:	eb fe                	jmp    800366 <_panic+0x75>

00800368 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800368:	55                   	push   %ebp
  800369:	89 e5                	mov    %esp,%ebp
  80036b:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  80036e:	a1 20 50 80 00       	mov    0x805020,%eax
  800373:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800379:	8b 45 0c             	mov    0xc(%ebp),%eax
  80037c:	39 c2                	cmp    %eax,%edx
  80037e:	74 14                	je     800394 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800380:	83 ec 04             	sub    $0x4,%esp
  800383:	68 8c 43 80 00       	push   $0x80438c
  800388:	6a 26                	push   $0x26
  80038a:	68 d8 43 80 00       	push   $0x8043d8
  80038f:	e8 5d ff ff ff       	call   8002f1 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800394:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  80039b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8003a2:	e9 c5 00 00 00       	jmp    80046c <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  8003a7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003aa:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8003b4:	01 d0                	add    %edx,%eax
  8003b6:	8b 00                	mov    (%eax),%eax
  8003b8:	85 c0                	test   %eax,%eax
  8003ba:	75 08                	jne    8003c4 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  8003bc:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8003bf:	e9 a5 00 00 00       	jmp    800469 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  8003c4:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8003cb:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8003d2:	eb 69                	jmp    80043d <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8003d4:	a1 20 50 80 00       	mov    0x805020,%eax
  8003d9:	8b 88 a4 05 00 00    	mov    0x5a4(%eax),%ecx
  8003df:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8003e2:	89 d0                	mov    %edx,%eax
  8003e4:	01 c0                	add    %eax,%eax
  8003e6:	01 d0                	add    %edx,%eax
  8003e8:	c1 e0 03             	shl    $0x3,%eax
  8003eb:	01 c8                	add    %ecx,%eax
  8003ed:	8a 40 04             	mov    0x4(%eax),%al
  8003f0:	84 c0                	test   %al,%al
  8003f2:	75 46                	jne    80043a <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8003f4:	a1 20 50 80 00       	mov    0x805020,%eax
  8003f9:	8b 88 a4 05 00 00    	mov    0x5a4(%eax),%ecx
  8003ff:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800402:	89 d0                	mov    %edx,%eax
  800404:	01 c0                	add    %eax,%eax
  800406:	01 d0                	add    %edx,%eax
  800408:	c1 e0 03             	shl    $0x3,%eax
  80040b:	01 c8                	add    %ecx,%eax
  80040d:	8b 00                	mov    (%eax),%eax
  80040f:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800412:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800415:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80041a:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  80041c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80041f:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800426:	8b 45 08             	mov    0x8(%ebp),%eax
  800429:	01 c8                	add    %ecx,%eax
  80042b:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80042d:	39 c2                	cmp    %eax,%edx
  80042f:	75 09                	jne    80043a <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  800431:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800438:	eb 15                	jmp    80044f <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80043a:	ff 45 e8             	incl   -0x18(%ebp)
  80043d:	a1 20 50 80 00       	mov    0x805020,%eax
  800442:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800448:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80044b:	39 c2                	cmp    %eax,%edx
  80044d:	77 85                	ja     8003d4 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  80044f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800453:	75 14                	jne    800469 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  800455:	83 ec 04             	sub    $0x4,%esp
  800458:	68 e4 43 80 00       	push   $0x8043e4
  80045d:	6a 3a                	push   $0x3a
  80045f:	68 d8 43 80 00       	push   $0x8043d8
  800464:	e8 88 fe ff ff       	call   8002f1 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800469:	ff 45 f0             	incl   -0x10(%ebp)
  80046c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80046f:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800472:	0f 8c 2f ff ff ff    	jl     8003a7 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800478:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80047f:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800486:	eb 26                	jmp    8004ae <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800488:	a1 20 50 80 00       	mov    0x805020,%eax
  80048d:	8b 88 a4 05 00 00    	mov    0x5a4(%eax),%ecx
  800493:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800496:	89 d0                	mov    %edx,%eax
  800498:	01 c0                	add    %eax,%eax
  80049a:	01 d0                	add    %edx,%eax
  80049c:	c1 e0 03             	shl    $0x3,%eax
  80049f:	01 c8                	add    %ecx,%eax
  8004a1:	8a 40 04             	mov    0x4(%eax),%al
  8004a4:	3c 01                	cmp    $0x1,%al
  8004a6:	75 03                	jne    8004ab <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  8004a8:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8004ab:	ff 45 e0             	incl   -0x20(%ebp)
  8004ae:	a1 20 50 80 00       	mov    0x805020,%eax
  8004b3:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8004b9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8004bc:	39 c2                	cmp    %eax,%edx
  8004be:	77 c8                	ja     800488 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8004c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8004c3:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8004c6:	74 14                	je     8004dc <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  8004c8:	83 ec 04             	sub    $0x4,%esp
  8004cb:	68 38 44 80 00       	push   $0x804438
  8004d0:	6a 44                	push   $0x44
  8004d2:	68 d8 43 80 00       	push   $0x8043d8
  8004d7:	e8 15 fe ff ff       	call   8002f1 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8004dc:	90                   	nop
  8004dd:	c9                   	leave  
  8004de:	c3                   	ret    

008004df <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  8004df:	55                   	push   %ebp
  8004e0:	89 e5                	mov    %esp,%ebp
  8004e2:	53                   	push   %ebx
  8004e3:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  8004e6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004e9:	8b 00                	mov    (%eax),%eax
  8004eb:	8d 48 01             	lea    0x1(%eax),%ecx
  8004ee:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004f1:	89 0a                	mov    %ecx,(%edx)
  8004f3:	8b 55 08             	mov    0x8(%ebp),%edx
  8004f6:	88 d1                	mov    %dl,%cl
  8004f8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004fb:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8004ff:	8b 45 0c             	mov    0xc(%ebp),%eax
  800502:	8b 00                	mov    (%eax),%eax
  800504:	3d ff 00 00 00       	cmp    $0xff,%eax
  800509:	75 30                	jne    80053b <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  80050b:	8b 15 1c d1 81 00    	mov    0x81d11c,%edx
  800511:	a0 44 50 80 00       	mov    0x805044,%al
  800516:	0f b6 c0             	movzbl %al,%eax
  800519:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80051c:	8b 09                	mov    (%ecx),%ecx
  80051e:	89 cb                	mov    %ecx,%ebx
  800520:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800523:	83 c1 08             	add    $0x8,%ecx
  800526:	52                   	push   %edx
  800527:	50                   	push   %eax
  800528:	53                   	push   %ebx
  800529:	51                   	push   %ecx
  80052a:	e8 07 29 00 00       	call   802e36 <sys_cputs>
  80052f:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800532:	8b 45 0c             	mov    0xc(%ebp),%eax
  800535:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  80053b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80053e:	8b 40 04             	mov    0x4(%eax),%eax
  800541:	8d 50 01             	lea    0x1(%eax),%edx
  800544:	8b 45 0c             	mov    0xc(%ebp),%eax
  800547:	89 50 04             	mov    %edx,0x4(%eax)
}
  80054a:	90                   	nop
  80054b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80054e:	c9                   	leave  
  80054f:	c3                   	ret    

00800550 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800550:	55                   	push   %ebp
  800551:	89 e5                	mov    %esp,%ebp
  800553:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800559:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800560:	00 00 00 
	b.cnt = 0;
  800563:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80056a:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  80056d:	ff 75 0c             	pushl  0xc(%ebp)
  800570:	ff 75 08             	pushl  0x8(%ebp)
  800573:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800579:	50                   	push   %eax
  80057a:	68 df 04 80 00       	push   $0x8004df
  80057f:	e8 5a 02 00 00       	call   8007de <vprintfmt>
  800584:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  800587:	8b 15 1c d1 81 00    	mov    0x81d11c,%edx
  80058d:	a0 44 50 80 00       	mov    0x805044,%al
  800592:	0f b6 c0             	movzbl %al,%eax
  800595:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  80059b:	52                   	push   %edx
  80059c:	50                   	push   %eax
  80059d:	51                   	push   %ecx
  80059e:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8005a4:	83 c0 08             	add    $0x8,%eax
  8005a7:	50                   	push   %eax
  8005a8:	e8 89 28 00 00       	call   802e36 <sys_cputs>
  8005ad:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8005b0:	c6 05 44 50 80 00 00 	movb   $0x0,0x805044
	return b.cnt;
  8005b7:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8005bd:	c9                   	leave  
  8005be:	c3                   	ret    

008005bf <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  8005bf:	55                   	push   %ebp
  8005c0:	89 e5                	mov    %esp,%ebp
  8005c2:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8005c5:	c6 05 44 50 80 00 01 	movb   $0x1,0x805044
	va_start(ap, fmt);
  8005cc:	8d 45 0c             	lea    0xc(%ebp),%eax
  8005cf:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8005d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8005d5:	83 ec 08             	sub    $0x8,%esp
  8005d8:	ff 75 f4             	pushl  -0xc(%ebp)
  8005db:	50                   	push   %eax
  8005dc:	e8 6f ff ff ff       	call   800550 <vcprintf>
  8005e1:	83 c4 10             	add    $0x10,%esp
  8005e4:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8005e7:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8005ea:	c9                   	leave  
  8005eb:	c3                   	ret    

008005ec <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  8005ec:	55                   	push   %ebp
  8005ed:	89 e5                	mov    %esp,%ebp
  8005ef:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8005f2:	c6 05 44 50 80 00 01 	movb   $0x1,0x805044
	curTextClr = (textClr << 8) ; //set text color by the given value
  8005f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8005fc:	c1 e0 08             	shl    $0x8,%eax
  8005ff:	a3 1c d1 81 00       	mov    %eax,0x81d11c
	va_start(ap, fmt);
  800604:	8d 45 0c             	lea    0xc(%ebp),%eax
  800607:	83 c0 04             	add    $0x4,%eax
  80060a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80060d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800610:	83 ec 08             	sub    $0x8,%esp
  800613:	ff 75 f4             	pushl  -0xc(%ebp)
  800616:	50                   	push   %eax
  800617:	e8 34 ff ff ff       	call   800550 <vcprintf>
  80061c:	83 c4 10             	add    $0x10,%esp
  80061f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  800622:	c7 05 1c d1 81 00 00 	movl   $0x700,0x81d11c
  800629:	07 00 00 

	return cnt;
  80062c:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80062f:	c9                   	leave  
  800630:	c3                   	ret    

00800631 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  800631:	55                   	push   %ebp
  800632:	89 e5                	mov    %esp,%ebp
  800634:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  800637:	e8 3e 28 00 00       	call   802e7a <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  80063c:	8d 45 0c             	lea    0xc(%ebp),%eax
  80063f:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  800642:	8b 45 08             	mov    0x8(%ebp),%eax
  800645:	83 ec 08             	sub    $0x8,%esp
  800648:	ff 75 f4             	pushl  -0xc(%ebp)
  80064b:	50                   	push   %eax
  80064c:	e8 ff fe ff ff       	call   800550 <vcprintf>
  800651:	83 c4 10             	add    $0x10,%esp
  800654:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  800657:	e8 38 28 00 00       	call   802e94 <sys_unlock_cons>
	return cnt;
  80065c:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80065f:	c9                   	leave  
  800660:	c3                   	ret    

00800661 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800661:	55                   	push   %ebp
  800662:	89 e5                	mov    %esp,%ebp
  800664:	53                   	push   %ebx
  800665:	83 ec 14             	sub    $0x14,%esp
  800668:	8b 45 10             	mov    0x10(%ebp),%eax
  80066b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80066e:	8b 45 14             	mov    0x14(%ebp),%eax
  800671:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800674:	8b 45 18             	mov    0x18(%ebp),%eax
  800677:	ba 00 00 00 00       	mov    $0x0,%edx
  80067c:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80067f:	77 55                	ja     8006d6 <printnum+0x75>
  800681:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800684:	72 05                	jb     80068b <printnum+0x2a>
  800686:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800689:	77 4b                	ja     8006d6 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80068b:	8b 45 1c             	mov    0x1c(%ebp),%eax
  80068e:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800691:	8b 45 18             	mov    0x18(%ebp),%eax
  800694:	ba 00 00 00 00       	mov    $0x0,%edx
  800699:	52                   	push   %edx
  80069a:	50                   	push   %eax
  80069b:	ff 75 f4             	pushl  -0xc(%ebp)
  80069e:	ff 75 f0             	pushl  -0x10(%ebp)
  8006a1:	e8 82 38 00 00       	call   803f28 <__udivdi3>
  8006a6:	83 c4 10             	add    $0x10,%esp
  8006a9:	83 ec 04             	sub    $0x4,%esp
  8006ac:	ff 75 20             	pushl  0x20(%ebp)
  8006af:	53                   	push   %ebx
  8006b0:	ff 75 18             	pushl  0x18(%ebp)
  8006b3:	52                   	push   %edx
  8006b4:	50                   	push   %eax
  8006b5:	ff 75 0c             	pushl  0xc(%ebp)
  8006b8:	ff 75 08             	pushl  0x8(%ebp)
  8006bb:	e8 a1 ff ff ff       	call   800661 <printnum>
  8006c0:	83 c4 20             	add    $0x20,%esp
  8006c3:	eb 1a                	jmp    8006df <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8006c5:	83 ec 08             	sub    $0x8,%esp
  8006c8:	ff 75 0c             	pushl  0xc(%ebp)
  8006cb:	ff 75 20             	pushl  0x20(%ebp)
  8006ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8006d1:	ff d0                	call   *%eax
  8006d3:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8006d6:	ff 4d 1c             	decl   0x1c(%ebp)
  8006d9:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  8006dd:	7f e6                	jg     8006c5 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8006df:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8006e2:	bb 00 00 00 00       	mov    $0x0,%ebx
  8006e7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8006ea:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8006ed:	53                   	push   %ebx
  8006ee:	51                   	push   %ecx
  8006ef:	52                   	push   %edx
  8006f0:	50                   	push   %eax
  8006f1:	e8 42 39 00 00       	call   804038 <__umoddi3>
  8006f6:	83 c4 10             	add    $0x10,%esp
  8006f9:	05 b4 46 80 00       	add    $0x8046b4,%eax
  8006fe:	8a 00                	mov    (%eax),%al
  800700:	0f be c0             	movsbl %al,%eax
  800703:	83 ec 08             	sub    $0x8,%esp
  800706:	ff 75 0c             	pushl  0xc(%ebp)
  800709:	50                   	push   %eax
  80070a:	8b 45 08             	mov    0x8(%ebp),%eax
  80070d:	ff d0                	call   *%eax
  80070f:	83 c4 10             	add    $0x10,%esp
}
  800712:	90                   	nop
  800713:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800716:	c9                   	leave  
  800717:	c3                   	ret    

00800718 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800718:	55                   	push   %ebp
  800719:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80071b:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80071f:	7e 1c                	jle    80073d <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800721:	8b 45 08             	mov    0x8(%ebp),%eax
  800724:	8b 00                	mov    (%eax),%eax
  800726:	8d 50 08             	lea    0x8(%eax),%edx
  800729:	8b 45 08             	mov    0x8(%ebp),%eax
  80072c:	89 10                	mov    %edx,(%eax)
  80072e:	8b 45 08             	mov    0x8(%ebp),%eax
  800731:	8b 00                	mov    (%eax),%eax
  800733:	83 e8 08             	sub    $0x8,%eax
  800736:	8b 50 04             	mov    0x4(%eax),%edx
  800739:	8b 00                	mov    (%eax),%eax
  80073b:	eb 40                	jmp    80077d <getuint+0x65>
	else if (lflag)
  80073d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800741:	74 1e                	je     800761 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800743:	8b 45 08             	mov    0x8(%ebp),%eax
  800746:	8b 00                	mov    (%eax),%eax
  800748:	8d 50 04             	lea    0x4(%eax),%edx
  80074b:	8b 45 08             	mov    0x8(%ebp),%eax
  80074e:	89 10                	mov    %edx,(%eax)
  800750:	8b 45 08             	mov    0x8(%ebp),%eax
  800753:	8b 00                	mov    (%eax),%eax
  800755:	83 e8 04             	sub    $0x4,%eax
  800758:	8b 00                	mov    (%eax),%eax
  80075a:	ba 00 00 00 00       	mov    $0x0,%edx
  80075f:	eb 1c                	jmp    80077d <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800761:	8b 45 08             	mov    0x8(%ebp),%eax
  800764:	8b 00                	mov    (%eax),%eax
  800766:	8d 50 04             	lea    0x4(%eax),%edx
  800769:	8b 45 08             	mov    0x8(%ebp),%eax
  80076c:	89 10                	mov    %edx,(%eax)
  80076e:	8b 45 08             	mov    0x8(%ebp),%eax
  800771:	8b 00                	mov    (%eax),%eax
  800773:	83 e8 04             	sub    $0x4,%eax
  800776:	8b 00                	mov    (%eax),%eax
  800778:	ba 00 00 00 00       	mov    $0x0,%edx
}
  80077d:	5d                   	pop    %ebp
  80077e:	c3                   	ret    

0080077f <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  80077f:	55                   	push   %ebp
  800780:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800782:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800786:	7e 1c                	jle    8007a4 <getint+0x25>
		return va_arg(*ap, long long);
  800788:	8b 45 08             	mov    0x8(%ebp),%eax
  80078b:	8b 00                	mov    (%eax),%eax
  80078d:	8d 50 08             	lea    0x8(%eax),%edx
  800790:	8b 45 08             	mov    0x8(%ebp),%eax
  800793:	89 10                	mov    %edx,(%eax)
  800795:	8b 45 08             	mov    0x8(%ebp),%eax
  800798:	8b 00                	mov    (%eax),%eax
  80079a:	83 e8 08             	sub    $0x8,%eax
  80079d:	8b 50 04             	mov    0x4(%eax),%edx
  8007a0:	8b 00                	mov    (%eax),%eax
  8007a2:	eb 38                	jmp    8007dc <getint+0x5d>
	else if (lflag)
  8007a4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8007a8:	74 1a                	je     8007c4 <getint+0x45>
		return va_arg(*ap, long);
  8007aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8007ad:	8b 00                	mov    (%eax),%eax
  8007af:	8d 50 04             	lea    0x4(%eax),%edx
  8007b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8007b5:	89 10                	mov    %edx,(%eax)
  8007b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8007ba:	8b 00                	mov    (%eax),%eax
  8007bc:	83 e8 04             	sub    $0x4,%eax
  8007bf:	8b 00                	mov    (%eax),%eax
  8007c1:	99                   	cltd   
  8007c2:	eb 18                	jmp    8007dc <getint+0x5d>
	else
		return va_arg(*ap, int);
  8007c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8007c7:	8b 00                	mov    (%eax),%eax
  8007c9:	8d 50 04             	lea    0x4(%eax),%edx
  8007cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8007cf:	89 10                	mov    %edx,(%eax)
  8007d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8007d4:	8b 00                	mov    (%eax),%eax
  8007d6:	83 e8 04             	sub    $0x4,%eax
  8007d9:	8b 00                	mov    (%eax),%eax
  8007db:	99                   	cltd   
}
  8007dc:	5d                   	pop    %ebp
  8007dd:	c3                   	ret    

008007de <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8007de:	55                   	push   %ebp
  8007df:	89 e5                	mov    %esp,%ebp
  8007e1:	56                   	push   %esi
  8007e2:	53                   	push   %ebx
  8007e3:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8007e6:	eb 17                	jmp    8007ff <vprintfmt+0x21>
			if (ch == '\0')
  8007e8:	85 db                	test   %ebx,%ebx
  8007ea:	0f 84 c1 03 00 00    	je     800bb1 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  8007f0:	83 ec 08             	sub    $0x8,%esp
  8007f3:	ff 75 0c             	pushl  0xc(%ebp)
  8007f6:	53                   	push   %ebx
  8007f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8007fa:	ff d0                	call   *%eax
  8007fc:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8007ff:	8b 45 10             	mov    0x10(%ebp),%eax
  800802:	8d 50 01             	lea    0x1(%eax),%edx
  800805:	89 55 10             	mov    %edx,0x10(%ebp)
  800808:	8a 00                	mov    (%eax),%al
  80080a:	0f b6 d8             	movzbl %al,%ebx
  80080d:	83 fb 25             	cmp    $0x25,%ebx
  800810:	75 d6                	jne    8007e8 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800812:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800816:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  80081d:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800824:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  80082b:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800832:	8b 45 10             	mov    0x10(%ebp),%eax
  800835:	8d 50 01             	lea    0x1(%eax),%edx
  800838:	89 55 10             	mov    %edx,0x10(%ebp)
  80083b:	8a 00                	mov    (%eax),%al
  80083d:	0f b6 d8             	movzbl %al,%ebx
  800840:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800843:	83 f8 5b             	cmp    $0x5b,%eax
  800846:	0f 87 3d 03 00 00    	ja     800b89 <vprintfmt+0x3ab>
  80084c:	8b 04 85 d8 46 80 00 	mov    0x8046d8(,%eax,4),%eax
  800853:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800855:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800859:	eb d7                	jmp    800832 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  80085b:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  80085f:	eb d1                	jmp    800832 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800861:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800868:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80086b:	89 d0                	mov    %edx,%eax
  80086d:	c1 e0 02             	shl    $0x2,%eax
  800870:	01 d0                	add    %edx,%eax
  800872:	01 c0                	add    %eax,%eax
  800874:	01 d8                	add    %ebx,%eax
  800876:	83 e8 30             	sub    $0x30,%eax
  800879:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  80087c:	8b 45 10             	mov    0x10(%ebp),%eax
  80087f:	8a 00                	mov    (%eax),%al
  800881:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800884:	83 fb 2f             	cmp    $0x2f,%ebx
  800887:	7e 3e                	jle    8008c7 <vprintfmt+0xe9>
  800889:	83 fb 39             	cmp    $0x39,%ebx
  80088c:	7f 39                	jg     8008c7 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80088e:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800891:	eb d5                	jmp    800868 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800893:	8b 45 14             	mov    0x14(%ebp),%eax
  800896:	83 c0 04             	add    $0x4,%eax
  800899:	89 45 14             	mov    %eax,0x14(%ebp)
  80089c:	8b 45 14             	mov    0x14(%ebp),%eax
  80089f:	83 e8 04             	sub    $0x4,%eax
  8008a2:	8b 00                	mov    (%eax),%eax
  8008a4:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8008a7:	eb 1f                	jmp    8008c8 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8008a9:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008ad:	79 83                	jns    800832 <vprintfmt+0x54>
				width = 0;
  8008af:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8008b6:	e9 77 ff ff ff       	jmp    800832 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  8008bb:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  8008c2:	e9 6b ff ff ff       	jmp    800832 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  8008c7:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8008c8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008cc:	0f 89 60 ff ff ff    	jns    800832 <vprintfmt+0x54>
				width = precision, precision = -1;
  8008d2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8008d5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8008d8:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  8008df:	e9 4e ff ff ff       	jmp    800832 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8008e4:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  8008e7:	e9 46 ff ff ff       	jmp    800832 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8008ec:	8b 45 14             	mov    0x14(%ebp),%eax
  8008ef:	83 c0 04             	add    $0x4,%eax
  8008f2:	89 45 14             	mov    %eax,0x14(%ebp)
  8008f5:	8b 45 14             	mov    0x14(%ebp),%eax
  8008f8:	83 e8 04             	sub    $0x4,%eax
  8008fb:	8b 00                	mov    (%eax),%eax
  8008fd:	83 ec 08             	sub    $0x8,%esp
  800900:	ff 75 0c             	pushl  0xc(%ebp)
  800903:	50                   	push   %eax
  800904:	8b 45 08             	mov    0x8(%ebp),%eax
  800907:	ff d0                	call   *%eax
  800909:	83 c4 10             	add    $0x10,%esp
			break;
  80090c:	e9 9b 02 00 00       	jmp    800bac <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800911:	8b 45 14             	mov    0x14(%ebp),%eax
  800914:	83 c0 04             	add    $0x4,%eax
  800917:	89 45 14             	mov    %eax,0x14(%ebp)
  80091a:	8b 45 14             	mov    0x14(%ebp),%eax
  80091d:	83 e8 04             	sub    $0x4,%eax
  800920:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800922:	85 db                	test   %ebx,%ebx
  800924:	79 02                	jns    800928 <vprintfmt+0x14a>
				err = -err;
  800926:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800928:	83 fb 64             	cmp    $0x64,%ebx
  80092b:	7f 0b                	jg     800938 <vprintfmt+0x15a>
  80092d:	8b 34 9d 20 45 80 00 	mov    0x804520(,%ebx,4),%esi
  800934:	85 f6                	test   %esi,%esi
  800936:	75 19                	jne    800951 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800938:	53                   	push   %ebx
  800939:	68 c5 46 80 00       	push   $0x8046c5
  80093e:	ff 75 0c             	pushl  0xc(%ebp)
  800941:	ff 75 08             	pushl  0x8(%ebp)
  800944:	e8 70 02 00 00       	call   800bb9 <printfmt>
  800949:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  80094c:	e9 5b 02 00 00       	jmp    800bac <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800951:	56                   	push   %esi
  800952:	68 ce 46 80 00       	push   $0x8046ce
  800957:	ff 75 0c             	pushl  0xc(%ebp)
  80095a:	ff 75 08             	pushl  0x8(%ebp)
  80095d:	e8 57 02 00 00       	call   800bb9 <printfmt>
  800962:	83 c4 10             	add    $0x10,%esp
			break;
  800965:	e9 42 02 00 00       	jmp    800bac <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  80096a:	8b 45 14             	mov    0x14(%ebp),%eax
  80096d:	83 c0 04             	add    $0x4,%eax
  800970:	89 45 14             	mov    %eax,0x14(%ebp)
  800973:	8b 45 14             	mov    0x14(%ebp),%eax
  800976:	83 e8 04             	sub    $0x4,%eax
  800979:	8b 30                	mov    (%eax),%esi
  80097b:	85 f6                	test   %esi,%esi
  80097d:	75 05                	jne    800984 <vprintfmt+0x1a6>
				p = "(null)";
  80097f:	be d1 46 80 00       	mov    $0x8046d1,%esi
			if (width > 0 && padc != '-')
  800984:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800988:	7e 6d                	jle    8009f7 <vprintfmt+0x219>
  80098a:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  80098e:	74 67                	je     8009f7 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800990:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800993:	83 ec 08             	sub    $0x8,%esp
  800996:	50                   	push   %eax
  800997:	56                   	push   %esi
  800998:	e8 1e 03 00 00       	call   800cbb <strnlen>
  80099d:	83 c4 10             	add    $0x10,%esp
  8009a0:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  8009a3:	eb 16                	jmp    8009bb <vprintfmt+0x1dd>
					putch(padc, putdat);
  8009a5:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  8009a9:	83 ec 08             	sub    $0x8,%esp
  8009ac:	ff 75 0c             	pushl  0xc(%ebp)
  8009af:	50                   	push   %eax
  8009b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8009b3:	ff d0                	call   *%eax
  8009b5:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8009b8:	ff 4d e4             	decl   -0x1c(%ebp)
  8009bb:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8009bf:	7f e4                	jg     8009a5 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8009c1:	eb 34                	jmp    8009f7 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  8009c3:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8009c7:	74 1c                	je     8009e5 <vprintfmt+0x207>
  8009c9:	83 fb 1f             	cmp    $0x1f,%ebx
  8009cc:	7e 05                	jle    8009d3 <vprintfmt+0x1f5>
  8009ce:	83 fb 7e             	cmp    $0x7e,%ebx
  8009d1:	7e 12                	jle    8009e5 <vprintfmt+0x207>
					putch('?', putdat);
  8009d3:	83 ec 08             	sub    $0x8,%esp
  8009d6:	ff 75 0c             	pushl  0xc(%ebp)
  8009d9:	6a 3f                	push   $0x3f
  8009db:	8b 45 08             	mov    0x8(%ebp),%eax
  8009de:	ff d0                	call   *%eax
  8009e0:	83 c4 10             	add    $0x10,%esp
  8009e3:	eb 0f                	jmp    8009f4 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  8009e5:	83 ec 08             	sub    $0x8,%esp
  8009e8:	ff 75 0c             	pushl  0xc(%ebp)
  8009eb:	53                   	push   %ebx
  8009ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ef:	ff d0                	call   *%eax
  8009f1:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8009f4:	ff 4d e4             	decl   -0x1c(%ebp)
  8009f7:	89 f0                	mov    %esi,%eax
  8009f9:	8d 70 01             	lea    0x1(%eax),%esi
  8009fc:	8a 00                	mov    (%eax),%al
  8009fe:	0f be d8             	movsbl %al,%ebx
  800a01:	85 db                	test   %ebx,%ebx
  800a03:	74 24                	je     800a29 <vprintfmt+0x24b>
  800a05:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800a09:	78 b8                	js     8009c3 <vprintfmt+0x1e5>
  800a0b:	ff 4d e0             	decl   -0x20(%ebp)
  800a0e:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800a12:	79 af                	jns    8009c3 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800a14:	eb 13                	jmp    800a29 <vprintfmt+0x24b>
				putch(' ', putdat);
  800a16:	83 ec 08             	sub    $0x8,%esp
  800a19:	ff 75 0c             	pushl  0xc(%ebp)
  800a1c:	6a 20                	push   $0x20
  800a1e:	8b 45 08             	mov    0x8(%ebp),%eax
  800a21:	ff d0                	call   *%eax
  800a23:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800a26:	ff 4d e4             	decl   -0x1c(%ebp)
  800a29:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a2d:	7f e7                	jg     800a16 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800a2f:	e9 78 01 00 00       	jmp    800bac <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800a34:	83 ec 08             	sub    $0x8,%esp
  800a37:	ff 75 e8             	pushl  -0x18(%ebp)
  800a3a:	8d 45 14             	lea    0x14(%ebp),%eax
  800a3d:	50                   	push   %eax
  800a3e:	e8 3c fd ff ff       	call   80077f <getint>
  800a43:	83 c4 10             	add    $0x10,%esp
  800a46:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a49:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800a4c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a4f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a52:	85 d2                	test   %edx,%edx
  800a54:	79 23                	jns    800a79 <vprintfmt+0x29b>
				putch('-', putdat);
  800a56:	83 ec 08             	sub    $0x8,%esp
  800a59:	ff 75 0c             	pushl  0xc(%ebp)
  800a5c:	6a 2d                	push   $0x2d
  800a5e:	8b 45 08             	mov    0x8(%ebp),%eax
  800a61:	ff d0                	call   *%eax
  800a63:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800a66:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a69:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a6c:	f7 d8                	neg    %eax
  800a6e:	83 d2 00             	adc    $0x0,%edx
  800a71:	f7 da                	neg    %edx
  800a73:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a76:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800a79:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800a80:	e9 bc 00 00 00       	jmp    800b41 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800a85:	83 ec 08             	sub    $0x8,%esp
  800a88:	ff 75 e8             	pushl  -0x18(%ebp)
  800a8b:	8d 45 14             	lea    0x14(%ebp),%eax
  800a8e:	50                   	push   %eax
  800a8f:	e8 84 fc ff ff       	call   800718 <getuint>
  800a94:	83 c4 10             	add    $0x10,%esp
  800a97:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a9a:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800a9d:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800aa4:	e9 98 00 00 00       	jmp    800b41 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800aa9:	83 ec 08             	sub    $0x8,%esp
  800aac:	ff 75 0c             	pushl  0xc(%ebp)
  800aaf:	6a 58                	push   $0x58
  800ab1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ab4:	ff d0                	call   *%eax
  800ab6:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800ab9:	83 ec 08             	sub    $0x8,%esp
  800abc:	ff 75 0c             	pushl  0xc(%ebp)
  800abf:	6a 58                	push   $0x58
  800ac1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ac4:	ff d0                	call   *%eax
  800ac6:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800ac9:	83 ec 08             	sub    $0x8,%esp
  800acc:	ff 75 0c             	pushl  0xc(%ebp)
  800acf:	6a 58                	push   $0x58
  800ad1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ad4:	ff d0                	call   *%eax
  800ad6:	83 c4 10             	add    $0x10,%esp
			break;
  800ad9:	e9 ce 00 00 00       	jmp    800bac <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800ade:	83 ec 08             	sub    $0x8,%esp
  800ae1:	ff 75 0c             	pushl  0xc(%ebp)
  800ae4:	6a 30                	push   $0x30
  800ae6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ae9:	ff d0                	call   *%eax
  800aeb:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800aee:	83 ec 08             	sub    $0x8,%esp
  800af1:	ff 75 0c             	pushl  0xc(%ebp)
  800af4:	6a 78                	push   $0x78
  800af6:	8b 45 08             	mov    0x8(%ebp),%eax
  800af9:	ff d0                	call   *%eax
  800afb:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800afe:	8b 45 14             	mov    0x14(%ebp),%eax
  800b01:	83 c0 04             	add    $0x4,%eax
  800b04:	89 45 14             	mov    %eax,0x14(%ebp)
  800b07:	8b 45 14             	mov    0x14(%ebp),%eax
  800b0a:	83 e8 04             	sub    $0x4,%eax
  800b0d:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800b0f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b12:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800b19:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800b20:	eb 1f                	jmp    800b41 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800b22:	83 ec 08             	sub    $0x8,%esp
  800b25:	ff 75 e8             	pushl  -0x18(%ebp)
  800b28:	8d 45 14             	lea    0x14(%ebp),%eax
  800b2b:	50                   	push   %eax
  800b2c:	e8 e7 fb ff ff       	call   800718 <getuint>
  800b31:	83 c4 10             	add    $0x10,%esp
  800b34:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b37:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800b3a:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800b41:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800b45:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800b48:	83 ec 04             	sub    $0x4,%esp
  800b4b:	52                   	push   %edx
  800b4c:	ff 75 e4             	pushl  -0x1c(%ebp)
  800b4f:	50                   	push   %eax
  800b50:	ff 75 f4             	pushl  -0xc(%ebp)
  800b53:	ff 75 f0             	pushl  -0x10(%ebp)
  800b56:	ff 75 0c             	pushl  0xc(%ebp)
  800b59:	ff 75 08             	pushl  0x8(%ebp)
  800b5c:	e8 00 fb ff ff       	call   800661 <printnum>
  800b61:	83 c4 20             	add    $0x20,%esp
			break;
  800b64:	eb 46                	jmp    800bac <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800b66:	83 ec 08             	sub    $0x8,%esp
  800b69:	ff 75 0c             	pushl  0xc(%ebp)
  800b6c:	53                   	push   %ebx
  800b6d:	8b 45 08             	mov    0x8(%ebp),%eax
  800b70:	ff d0                	call   *%eax
  800b72:	83 c4 10             	add    $0x10,%esp
			break;
  800b75:	eb 35                	jmp    800bac <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800b77:	c6 05 44 50 80 00 00 	movb   $0x0,0x805044
			break;
  800b7e:	eb 2c                	jmp    800bac <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800b80:	c6 05 44 50 80 00 01 	movb   $0x1,0x805044
			break;
  800b87:	eb 23                	jmp    800bac <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800b89:	83 ec 08             	sub    $0x8,%esp
  800b8c:	ff 75 0c             	pushl  0xc(%ebp)
  800b8f:	6a 25                	push   $0x25
  800b91:	8b 45 08             	mov    0x8(%ebp),%eax
  800b94:	ff d0                	call   *%eax
  800b96:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800b99:	ff 4d 10             	decl   0x10(%ebp)
  800b9c:	eb 03                	jmp    800ba1 <vprintfmt+0x3c3>
  800b9e:	ff 4d 10             	decl   0x10(%ebp)
  800ba1:	8b 45 10             	mov    0x10(%ebp),%eax
  800ba4:	48                   	dec    %eax
  800ba5:	8a 00                	mov    (%eax),%al
  800ba7:	3c 25                	cmp    $0x25,%al
  800ba9:	75 f3                	jne    800b9e <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800bab:	90                   	nop
		}
	}
  800bac:	e9 35 fc ff ff       	jmp    8007e6 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800bb1:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800bb2:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800bb5:	5b                   	pop    %ebx
  800bb6:	5e                   	pop    %esi
  800bb7:	5d                   	pop    %ebp
  800bb8:	c3                   	ret    

00800bb9 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800bb9:	55                   	push   %ebp
  800bba:	89 e5                	mov    %esp,%ebp
  800bbc:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800bbf:	8d 45 10             	lea    0x10(%ebp),%eax
  800bc2:	83 c0 04             	add    $0x4,%eax
  800bc5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800bc8:	8b 45 10             	mov    0x10(%ebp),%eax
  800bcb:	ff 75 f4             	pushl  -0xc(%ebp)
  800bce:	50                   	push   %eax
  800bcf:	ff 75 0c             	pushl  0xc(%ebp)
  800bd2:	ff 75 08             	pushl  0x8(%ebp)
  800bd5:	e8 04 fc ff ff       	call   8007de <vprintfmt>
  800bda:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800bdd:	90                   	nop
  800bde:	c9                   	leave  
  800bdf:	c3                   	ret    

00800be0 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800be0:	55                   	push   %ebp
  800be1:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800be3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800be6:	8b 40 08             	mov    0x8(%eax),%eax
  800be9:	8d 50 01             	lea    0x1(%eax),%edx
  800bec:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bef:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800bf2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bf5:	8b 10                	mov    (%eax),%edx
  800bf7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bfa:	8b 40 04             	mov    0x4(%eax),%eax
  800bfd:	39 c2                	cmp    %eax,%edx
  800bff:	73 12                	jae    800c13 <sprintputch+0x33>
		*b->buf++ = ch;
  800c01:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c04:	8b 00                	mov    (%eax),%eax
  800c06:	8d 48 01             	lea    0x1(%eax),%ecx
  800c09:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c0c:	89 0a                	mov    %ecx,(%edx)
  800c0e:	8b 55 08             	mov    0x8(%ebp),%edx
  800c11:	88 10                	mov    %dl,(%eax)
}
  800c13:	90                   	nop
  800c14:	5d                   	pop    %ebp
  800c15:	c3                   	ret    

00800c16 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800c16:	55                   	push   %ebp
  800c17:	89 e5                	mov    %esp,%ebp
  800c19:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800c1c:	8b 45 08             	mov    0x8(%ebp),%eax
  800c1f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800c22:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c25:	8d 50 ff             	lea    -0x1(%eax),%edx
  800c28:	8b 45 08             	mov    0x8(%ebp),%eax
  800c2b:	01 d0                	add    %edx,%eax
  800c2d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c30:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800c37:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800c3b:	74 06                	je     800c43 <vsnprintf+0x2d>
  800c3d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c41:	7f 07                	jg     800c4a <vsnprintf+0x34>
		return -E_INVAL;
  800c43:	b8 03 00 00 00       	mov    $0x3,%eax
  800c48:	eb 20                	jmp    800c6a <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800c4a:	ff 75 14             	pushl  0x14(%ebp)
  800c4d:	ff 75 10             	pushl  0x10(%ebp)
  800c50:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800c53:	50                   	push   %eax
  800c54:	68 e0 0b 80 00       	push   $0x800be0
  800c59:	e8 80 fb ff ff       	call   8007de <vprintfmt>
  800c5e:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800c61:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800c64:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800c67:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800c6a:	c9                   	leave  
  800c6b:	c3                   	ret    

00800c6c <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800c6c:	55                   	push   %ebp
  800c6d:	89 e5                	mov    %esp,%ebp
  800c6f:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800c72:	8d 45 10             	lea    0x10(%ebp),%eax
  800c75:	83 c0 04             	add    $0x4,%eax
  800c78:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800c7b:	8b 45 10             	mov    0x10(%ebp),%eax
  800c7e:	ff 75 f4             	pushl  -0xc(%ebp)
  800c81:	50                   	push   %eax
  800c82:	ff 75 0c             	pushl  0xc(%ebp)
  800c85:	ff 75 08             	pushl  0x8(%ebp)
  800c88:	e8 89 ff ff ff       	call   800c16 <vsnprintf>
  800c8d:	83 c4 10             	add    $0x10,%esp
  800c90:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800c93:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800c96:	c9                   	leave  
  800c97:	c3                   	ret    

00800c98 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800c98:	55                   	push   %ebp
  800c99:	89 e5                	mov    %esp,%ebp
  800c9b:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800c9e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800ca5:	eb 06                	jmp    800cad <strlen+0x15>
		n++;
  800ca7:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800caa:	ff 45 08             	incl   0x8(%ebp)
  800cad:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb0:	8a 00                	mov    (%eax),%al
  800cb2:	84 c0                	test   %al,%al
  800cb4:	75 f1                	jne    800ca7 <strlen+0xf>
		n++;
	return n;
  800cb6:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800cb9:	c9                   	leave  
  800cba:	c3                   	ret    

00800cbb <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800cbb:	55                   	push   %ebp
  800cbc:	89 e5                	mov    %esp,%ebp
  800cbe:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800cc1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800cc8:	eb 09                	jmp    800cd3 <strnlen+0x18>
		n++;
  800cca:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800ccd:	ff 45 08             	incl   0x8(%ebp)
  800cd0:	ff 4d 0c             	decl   0xc(%ebp)
  800cd3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800cd7:	74 09                	je     800ce2 <strnlen+0x27>
  800cd9:	8b 45 08             	mov    0x8(%ebp),%eax
  800cdc:	8a 00                	mov    (%eax),%al
  800cde:	84 c0                	test   %al,%al
  800ce0:	75 e8                	jne    800cca <strnlen+0xf>
		n++;
	return n;
  800ce2:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800ce5:	c9                   	leave  
  800ce6:	c3                   	ret    

00800ce7 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800ce7:	55                   	push   %ebp
  800ce8:	89 e5                	mov    %esp,%ebp
  800cea:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800ced:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800cf3:	90                   	nop
  800cf4:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf7:	8d 50 01             	lea    0x1(%eax),%edx
  800cfa:	89 55 08             	mov    %edx,0x8(%ebp)
  800cfd:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d00:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d03:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800d06:	8a 12                	mov    (%edx),%dl
  800d08:	88 10                	mov    %dl,(%eax)
  800d0a:	8a 00                	mov    (%eax),%al
  800d0c:	84 c0                	test   %al,%al
  800d0e:	75 e4                	jne    800cf4 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800d10:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800d13:	c9                   	leave  
  800d14:	c3                   	ret    

00800d15 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800d15:	55                   	push   %ebp
  800d16:	89 e5                	mov    %esp,%ebp
  800d18:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800d1b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d1e:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800d21:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800d28:	eb 1f                	jmp    800d49 <strncpy+0x34>
		*dst++ = *src;
  800d2a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d2d:	8d 50 01             	lea    0x1(%eax),%edx
  800d30:	89 55 08             	mov    %edx,0x8(%ebp)
  800d33:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d36:	8a 12                	mov    (%edx),%dl
  800d38:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800d3a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d3d:	8a 00                	mov    (%eax),%al
  800d3f:	84 c0                	test   %al,%al
  800d41:	74 03                	je     800d46 <strncpy+0x31>
			src++;
  800d43:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800d46:	ff 45 fc             	incl   -0x4(%ebp)
  800d49:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d4c:	3b 45 10             	cmp    0x10(%ebp),%eax
  800d4f:	72 d9                	jb     800d2a <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800d51:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800d54:	c9                   	leave  
  800d55:	c3                   	ret    

00800d56 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800d56:	55                   	push   %ebp
  800d57:	89 e5                	mov    %esp,%ebp
  800d59:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800d5c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d5f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800d62:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d66:	74 30                	je     800d98 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800d68:	eb 16                	jmp    800d80 <strlcpy+0x2a>
			*dst++ = *src++;
  800d6a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d6d:	8d 50 01             	lea    0x1(%eax),%edx
  800d70:	89 55 08             	mov    %edx,0x8(%ebp)
  800d73:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d76:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d79:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800d7c:	8a 12                	mov    (%edx),%dl
  800d7e:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800d80:	ff 4d 10             	decl   0x10(%ebp)
  800d83:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d87:	74 09                	je     800d92 <strlcpy+0x3c>
  800d89:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d8c:	8a 00                	mov    (%eax),%al
  800d8e:	84 c0                	test   %al,%al
  800d90:	75 d8                	jne    800d6a <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800d92:	8b 45 08             	mov    0x8(%ebp),%eax
  800d95:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800d98:	8b 55 08             	mov    0x8(%ebp),%edx
  800d9b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d9e:	29 c2                	sub    %eax,%edx
  800da0:	89 d0                	mov    %edx,%eax
}
  800da2:	c9                   	leave  
  800da3:	c3                   	ret    

00800da4 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800da4:	55                   	push   %ebp
  800da5:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800da7:	eb 06                	jmp    800daf <strcmp+0xb>
		p++, q++;
  800da9:	ff 45 08             	incl   0x8(%ebp)
  800dac:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800daf:	8b 45 08             	mov    0x8(%ebp),%eax
  800db2:	8a 00                	mov    (%eax),%al
  800db4:	84 c0                	test   %al,%al
  800db6:	74 0e                	je     800dc6 <strcmp+0x22>
  800db8:	8b 45 08             	mov    0x8(%ebp),%eax
  800dbb:	8a 10                	mov    (%eax),%dl
  800dbd:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dc0:	8a 00                	mov    (%eax),%al
  800dc2:	38 c2                	cmp    %al,%dl
  800dc4:	74 e3                	je     800da9 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800dc6:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc9:	8a 00                	mov    (%eax),%al
  800dcb:	0f b6 d0             	movzbl %al,%edx
  800dce:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dd1:	8a 00                	mov    (%eax),%al
  800dd3:	0f b6 c0             	movzbl %al,%eax
  800dd6:	29 c2                	sub    %eax,%edx
  800dd8:	89 d0                	mov    %edx,%eax
}
  800dda:	5d                   	pop    %ebp
  800ddb:	c3                   	ret    

00800ddc <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800ddc:	55                   	push   %ebp
  800ddd:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800ddf:	eb 09                	jmp    800dea <strncmp+0xe>
		n--, p++, q++;
  800de1:	ff 4d 10             	decl   0x10(%ebp)
  800de4:	ff 45 08             	incl   0x8(%ebp)
  800de7:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800dea:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800dee:	74 17                	je     800e07 <strncmp+0x2b>
  800df0:	8b 45 08             	mov    0x8(%ebp),%eax
  800df3:	8a 00                	mov    (%eax),%al
  800df5:	84 c0                	test   %al,%al
  800df7:	74 0e                	je     800e07 <strncmp+0x2b>
  800df9:	8b 45 08             	mov    0x8(%ebp),%eax
  800dfc:	8a 10                	mov    (%eax),%dl
  800dfe:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e01:	8a 00                	mov    (%eax),%al
  800e03:	38 c2                	cmp    %al,%dl
  800e05:	74 da                	je     800de1 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800e07:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e0b:	75 07                	jne    800e14 <strncmp+0x38>
		return 0;
  800e0d:	b8 00 00 00 00       	mov    $0x0,%eax
  800e12:	eb 14                	jmp    800e28 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800e14:	8b 45 08             	mov    0x8(%ebp),%eax
  800e17:	8a 00                	mov    (%eax),%al
  800e19:	0f b6 d0             	movzbl %al,%edx
  800e1c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e1f:	8a 00                	mov    (%eax),%al
  800e21:	0f b6 c0             	movzbl %al,%eax
  800e24:	29 c2                	sub    %eax,%edx
  800e26:	89 d0                	mov    %edx,%eax
}
  800e28:	5d                   	pop    %ebp
  800e29:	c3                   	ret    

00800e2a <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800e2a:	55                   	push   %ebp
  800e2b:	89 e5                	mov    %esp,%ebp
  800e2d:	83 ec 04             	sub    $0x4,%esp
  800e30:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e33:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800e36:	eb 12                	jmp    800e4a <strchr+0x20>
		if (*s == c)
  800e38:	8b 45 08             	mov    0x8(%ebp),%eax
  800e3b:	8a 00                	mov    (%eax),%al
  800e3d:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800e40:	75 05                	jne    800e47 <strchr+0x1d>
			return (char *) s;
  800e42:	8b 45 08             	mov    0x8(%ebp),%eax
  800e45:	eb 11                	jmp    800e58 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800e47:	ff 45 08             	incl   0x8(%ebp)
  800e4a:	8b 45 08             	mov    0x8(%ebp),%eax
  800e4d:	8a 00                	mov    (%eax),%al
  800e4f:	84 c0                	test   %al,%al
  800e51:	75 e5                	jne    800e38 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800e53:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e58:	c9                   	leave  
  800e59:	c3                   	ret    

00800e5a <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800e5a:	55                   	push   %ebp
  800e5b:	89 e5                	mov    %esp,%ebp
  800e5d:	83 ec 04             	sub    $0x4,%esp
  800e60:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e63:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800e66:	eb 0d                	jmp    800e75 <strfind+0x1b>
		if (*s == c)
  800e68:	8b 45 08             	mov    0x8(%ebp),%eax
  800e6b:	8a 00                	mov    (%eax),%al
  800e6d:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800e70:	74 0e                	je     800e80 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800e72:	ff 45 08             	incl   0x8(%ebp)
  800e75:	8b 45 08             	mov    0x8(%ebp),%eax
  800e78:	8a 00                	mov    (%eax),%al
  800e7a:	84 c0                	test   %al,%al
  800e7c:	75 ea                	jne    800e68 <strfind+0xe>
  800e7e:	eb 01                	jmp    800e81 <strfind+0x27>
		if (*s == c)
			break;
  800e80:	90                   	nop
	return (char *) s;
  800e81:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e84:	c9                   	leave  
  800e85:	c3                   	ret    

00800e86 <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  800e86:	55                   	push   %ebp
  800e87:	89 e5                	mov    %esp,%ebp
  800e89:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  800e8c:	8b 45 08             	mov    0x8(%ebp),%eax
  800e8f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  800e92:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800e96:	76 63                	jbe    800efb <memset+0x75>
		uint64 data_block = c;
  800e98:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e9b:	99                   	cltd   
  800e9c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e9f:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  800ea2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ea5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ea8:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  800eac:	c1 e0 08             	shl    $0x8,%eax
  800eaf:	09 45 f0             	or     %eax,-0x10(%ebp)
  800eb2:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  800eb5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800eb8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ebb:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  800ebf:	c1 e0 10             	shl    $0x10,%eax
  800ec2:	09 45 f0             	or     %eax,-0x10(%ebp)
  800ec5:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  800ec8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ecb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ece:	89 c2                	mov    %eax,%edx
  800ed0:	b8 00 00 00 00       	mov    $0x0,%eax
  800ed5:	09 45 f0             	or     %eax,-0x10(%ebp)
  800ed8:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  800edb:	eb 18                	jmp    800ef5 <memset+0x6f>
			*p64++ = data_block, n -= 8;
  800edd:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  800ee0:	8d 41 08             	lea    0x8(%ecx),%eax
  800ee3:	89 45 fc             	mov    %eax,-0x4(%ebp)
  800ee6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ee9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800eec:	89 01                	mov    %eax,(%ecx)
  800eee:	89 51 04             	mov    %edx,0x4(%ecx)
  800ef1:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  800ef5:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800ef9:	77 e2                	ja     800edd <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  800efb:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800eff:	74 23                	je     800f24 <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  800f01:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f04:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  800f07:	eb 0e                	jmp    800f17 <memset+0x91>
			*p8++ = (uint8)c;
  800f09:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f0c:	8d 50 01             	lea    0x1(%eax),%edx
  800f0f:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800f12:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f15:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  800f17:	8b 45 10             	mov    0x10(%ebp),%eax
  800f1a:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f1d:	89 55 10             	mov    %edx,0x10(%ebp)
  800f20:	85 c0                	test   %eax,%eax
  800f22:	75 e5                	jne    800f09 <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  800f24:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f27:	c9                   	leave  
  800f28:	c3                   	ret    

00800f29 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800f29:	55                   	push   %ebp
  800f2a:	89 e5                	mov    %esp,%ebp
  800f2c:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  800f2f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f32:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  800f35:	8b 45 08             	mov    0x8(%ebp),%eax
  800f38:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  800f3b:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800f3f:	76 24                	jbe    800f65 <memcpy+0x3c>
		while(n >= 8){
  800f41:	eb 1c                	jmp    800f5f <memcpy+0x36>
			*d64 = *s64;
  800f43:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f46:	8b 50 04             	mov    0x4(%eax),%edx
  800f49:	8b 00                	mov    (%eax),%eax
  800f4b:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  800f4e:	89 01                	mov    %eax,(%ecx)
  800f50:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  800f53:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  800f57:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  800f5b:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  800f5f:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800f63:	77 de                	ja     800f43 <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  800f65:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f69:	74 31                	je     800f9c <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  800f6b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f6e:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  800f71:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f74:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  800f77:	eb 16                	jmp    800f8f <memcpy+0x66>
			*d8++ = *s8++;
  800f79:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800f7c:	8d 50 01             	lea    0x1(%eax),%edx
  800f7f:	89 55 f0             	mov    %edx,-0x10(%ebp)
  800f82:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f85:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f88:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  800f8b:	8a 12                	mov    (%edx),%dl
  800f8d:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  800f8f:	8b 45 10             	mov    0x10(%ebp),%eax
  800f92:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f95:	89 55 10             	mov    %edx,0x10(%ebp)
  800f98:	85 c0                	test   %eax,%eax
  800f9a:	75 dd                	jne    800f79 <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  800f9c:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f9f:	c9                   	leave  
  800fa0:	c3                   	ret    

00800fa1 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800fa1:	55                   	push   %ebp
  800fa2:	89 e5                	mov    %esp,%ebp
  800fa4:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800fa7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800faa:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800fad:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb0:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800fb3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fb6:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800fb9:	73 50                	jae    80100b <memmove+0x6a>
  800fbb:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800fbe:	8b 45 10             	mov    0x10(%ebp),%eax
  800fc1:	01 d0                	add    %edx,%eax
  800fc3:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800fc6:	76 43                	jbe    80100b <memmove+0x6a>
		s += n;
  800fc8:	8b 45 10             	mov    0x10(%ebp),%eax
  800fcb:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800fce:	8b 45 10             	mov    0x10(%ebp),%eax
  800fd1:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800fd4:	eb 10                	jmp    800fe6 <memmove+0x45>
			*--d = *--s;
  800fd6:	ff 4d f8             	decl   -0x8(%ebp)
  800fd9:	ff 4d fc             	decl   -0x4(%ebp)
  800fdc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fdf:	8a 10                	mov    (%eax),%dl
  800fe1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fe4:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800fe6:	8b 45 10             	mov    0x10(%ebp),%eax
  800fe9:	8d 50 ff             	lea    -0x1(%eax),%edx
  800fec:	89 55 10             	mov    %edx,0x10(%ebp)
  800fef:	85 c0                	test   %eax,%eax
  800ff1:	75 e3                	jne    800fd6 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800ff3:	eb 23                	jmp    801018 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800ff5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ff8:	8d 50 01             	lea    0x1(%eax),%edx
  800ffb:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800ffe:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801001:	8d 4a 01             	lea    0x1(%edx),%ecx
  801004:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801007:	8a 12                	mov    (%edx),%dl
  801009:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  80100b:	8b 45 10             	mov    0x10(%ebp),%eax
  80100e:	8d 50 ff             	lea    -0x1(%eax),%edx
  801011:	89 55 10             	mov    %edx,0x10(%ebp)
  801014:	85 c0                	test   %eax,%eax
  801016:	75 dd                	jne    800ff5 <memmove+0x54>
			*d++ = *s++;

	return dst;
  801018:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80101b:	c9                   	leave  
  80101c:	c3                   	ret    

0080101d <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  80101d:	55                   	push   %ebp
  80101e:	89 e5                	mov    %esp,%ebp
  801020:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  801023:	8b 45 08             	mov    0x8(%ebp),%eax
  801026:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  801029:	8b 45 0c             	mov    0xc(%ebp),%eax
  80102c:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  80102f:	eb 2a                	jmp    80105b <memcmp+0x3e>
		if (*s1 != *s2)
  801031:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801034:	8a 10                	mov    (%eax),%dl
  801036:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801039:	8a 00                	mov    (%eax),%al
  80103b:	38 c2                	cmp    %al,%dl
  80103d:	74 16                	je     801055 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  80103f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801042:	8a 00                	mov    (%eax),%al
  801044:	0f b6 d0             	movzbl %al,%edx
  801047:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80104a:	8a 00                	mov    (%eax),%al
  80104c:	0f b6 c0             	movzbl %al,%eax
  80104f:	29 c2                	sub    %eax,%edx
  801051:	89 d0                	mov    %edx,%eax
  801053:	eb 18                	jmp    80106d <memcmp+0x50>
		s1++, s2++;
  801055:	ff 45 fc             	incl   -0x4(%ebp)
  801058:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  80105b:	8b 45 10             	mov    0x10(%ebp),%eax
  80105e:	8d 50 ff             	lea    -0x1(%eax),%edx
  801061:	89 55 10             	mov    %edx,0x10(%ebp)
  801064:	85 c0                	test   %eax,%eax
  801066:	75 c9                	jne    801031 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801068:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80106d:	c9                   	leave  
  80106e:	c3                   	ret    

0080106f <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  80106f:	55                   	push   %ebp
  801070:	89 e5                	mov    %esp,%ebp
  801072:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801075:	8b 55 08             	mov    0x8(%ebp),%edx
  801078:	8b 45 10             	mov    0x10(%ebp),%eax
  80107b:	01 d0                	add    %edx,%eax
  80107d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801080:	eb 15                	jmp    801097 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801082:	8b 45 08             	mov    0x8(%ebp),%eax
  801085:	8a 00                	mov    (%eax),%al
  801087:	0f b6 d0             	movzbl %al,%edx
  80108a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80108d:	0f b6 c0             	movzbl %al,%eax
  801090:	39 c2                	cmp    %eax,%edx
  801092:	74 0d                	je     8010a1 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801094:	ff 45 08             	incl   0x8(%ebp)
  801097:	8b 45 08             	mov    0x8(%ebp),%eax
  80109a:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80109d:	72 e3                	jb     801082 <memfind+0x13>
  80109f:	eb 01                	jmp    8010a2 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  8010a1:	90                   	nop
	return (void *) s;
  8010a2:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8010a5:	c9                   	leave  
  8010a6:	c3                   	ret    

008010a7 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8010a7:	55                   	push   %ebp
  8010a8:	89 e5                	mov    %esp,%ebp
  8010aa:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  8010ad:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  8010b4:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8010bb:	eb 03                	jmp    8010c0 <strtol+0x19>
		s++;
  8010bd:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8010c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c3:	8a 00                	mov    (%eax),%al
  8010c5:	3c 20                	cmp    $0x20,%al
  8010c7:	74 f4                	je     8010bd <strtol+0x16>
  8010c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8010cc:	8a 00                	mov    (%eax),%al
  8010ce:	3c 09                	cmp    $0x9,%al
  8010d0:	74 eb                	je     8010bd <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  8010d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8010d5:	8a 00                	mov    (%eax),%al
  8010d7:	3c 2b                	cmp    $0x2b,%al
  8010d9:	75 05                	jne    8010e0 <strtol+0x39>
		s++;
  8010db:	ff 45 08             	incl   0x8(%ebp)
  8010de:	eb 13                	jmp    8010f3 <strtol+0x4c>
	else if (*s == '-')
  8010e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8010e3:	8a 00                	mov    (%eax),%al
  8010e5:	3c 2d                	cmp    $0x2d,%al
  8010e7:	75 0a                	jne    8010f3 <strtol+0x4c>
		s++, neg = 1;
  8010e9:	ff 45 08             	incl   0x8(%ebp)
  8010ec:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8010f3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010f7:	74 06                	je     8010ff <strtol+0x58>
  8010f9:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8010fd:	75 20                	jne    80111f <strtol+0x78>
  8010ff:	8b 45 08             	mov    0x8(%ebp),%eax
  801102:	8a 00                	mov    (%eax),%al
  801104:	3c 30                	cmp    $0x30,%al
  801106:	75 17                	jne    80111f <strtol+0x78>
  801108:	8b 45 08             	mov    0x8(%ebp),%eax
  80110b:	40                   	inc    %eax
  80110c:	8a 00                	mov    (%eax),%al
  80110e:	3c 78                	cmp    $0x78,%al
  801110:	75 0d                	jne    80111f <strtol+0x78>
		s += 2, base = 16;
  801112:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801116:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  80111d:	eb 28                	jmp    801147 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  80111f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801123:	75 15                	jne    80113a <strtol+0x93>
  801125:	8b 45 08             	mov    0x8(%ebp),%eax
  801128:	8a 00                	mov    (%eax),%al
  80112a:	3c 30                	cmp    $0x30,%al
  80112c:	75 0c                	jne    80113a <strtol+0x93>
		s++, base = 8;
  80112e:	ff 45 08             	incl   0x8(%ebp)
  801131:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801138:	eb 0d                	jmp    801147 <strtol+0xa0>
	else if (base == 0)
  80113a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80113e:	75 07                	jne    801147 <strtol+0xa0>
		base = 10;
  801140:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801147:	8b 45 08             	mov    0x8(%ebp),%eax
  80114a:	8a 00                	mov    (%eax),%al
  80114c:	3c 2f                	cmp    $0x2f,%al
  80114e:	7e 19                	jle    801169 <strtol+0xc2>
  801150:	8b 45 08             	mov    0x8(%ebp),%eax
  801153:	8a 00                	mov    (%eax),%al
  801155:	3c 39                	cmp    $0x39,%al
  801157:	7f 10                	jg     801169 <strtol+0xc2>
			dig = *s - '0';
  801159:	8b 45 08             	mov    0x8(%ebp),%eax
  80115c:	8a 00                	mov    (%eax),%al
  80115e:	0f be c0             	movsbl %al,%eax
  801161:	83 e8 30             	sub    $0x30,%eax
  801164:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801167:	eb 42                	jmp    8011ab <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801169:	8b 45 08             	mov    0x8(%ebp),%eax
  80116c:	8a 00                	mov    (%eax),%al
  80116e:	3c 60                	cmp    $0x60,%al
  801170:	7e 19                	jle    80118b <strtol+0xe4>
  801172:	8b 45 08             	mov    0x8(%ebp),%eax
  801175:	8a 00                	mov    (%eax),%al
  801177:	3c 7a                	cmp    $0x7a,%al
  801179:	7f 10                	jg     80118b <strtol+0xe4>
			dig = *s - 'a' + 10;
  80117b:	8b 45 08             	mov    0x8(%ebp),%eax
  80117e:	8a 00                	mov    (%eax),%al
  801180:	0f be c0             	movsbl %al,%eax
  801183:	83 e8 57             	sub    $0x57,%eax
  801186:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801189:	eb 20                	jmp    8011ab <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  80118b:	8b 45 08             	mov    0x8(%ebp),%eax
  80118e:	8a 00                	mov    (%eax),%al
  801190:	3c 40                	cmp    $0x40,%al
  801192:	7e 39                	jle    8011cd <strtol+0x126>
  801194:	8b 45 08             	mov    0x8(%ebp),%eax
  801197:	8a 00                	mov    (%eax),%al
  801199:	3c 5a                	cmp    $0x5a,%al
  80119b:	7f 30                	jg     8011cd <strtol+0x126>
			dig = *s - 'A' + 10;
  80119d:	8b 45 08             	mov    0x8(%ebp),%eax
  8011a0:	8a 00                	mov    (%eax),%al
  8011a2:	0f be c0             	movsbl %al,%eax
  8011a5:	83 e8 37             	sub    $0x37,%eax
  8011a8:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  8011ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8011ae:	3b 45 10             	cmp    0x10(%ebp),%eax
  8011b1:	7d 19                	jge    8011cc <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  8011b3:	ff 45 08             	incl   0x8(%ebp)
  8011b6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011b9:	0f af 45 10          	imul   0x10(%ebp),%eax
  8011bd:	89 c2                	mov    %eax,%edx
  8011bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8011c2:	01 d0                	add    %edx,%eax
  8011c4:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8011c7:	e9 7b ff ff ff       	jmp    801147 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8011cc:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8011cd:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8011d1:	74 08                	je     8011db <strtol+0x134>
		*endptr = (char *) s;
  8011d3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011d6:	8b 55 08             	mov    0x8(%ebp),%edx
  8011d9:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8011db:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8011df:	74 07                	je     8011e8 <strtol+0x141>
  8011e1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011e4:	f7 d8                	neg    %eax
  8011e6:	eb 03                	jmp    8011eb <strtol+0x144>
  8011e8:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8011eb:	c9                   	leave  
  8011ec:	c3                   	ret    

008011ed <ltostr>:

void
ltostr(long value, char *str)
{
  8011ed:	55                   	push   %ebp
  8011ee:	89 e5                	mov    %esp,%ebp
  8011f0:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8011f3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8011fa:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801201:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801205:	79 13                	jns    80121a <ltostr+0x2d>
	{
		neg = 1;
  801207:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  80120e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801211:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801214:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801217:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  80121a:	8b 45 08             	mov    0x8(%ebp),%eax
  80121d:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801222:	99                   	cltd   
  801223:	f7 f9                	idiv   %ecx
  801225:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801228:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80122b:	8d 50 01             	lea    0x1(%eax),%edx
  80122e:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801231:	89 c2                	mov    %eax,%edx
  801233:	8b 45 0c             	mov    0xc(%ebp),%eax
  801236:	01 d0                	add    %edx,%eax
  801238:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80123b:	83 c2 30             	add    $0x30,%edx
  80123e:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801240:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801243:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801248:	f7 e9                	imul   %ecx
  80124a:	c1 fa 02             	sar    $0x2,%edx
  80124d:	89 c8                	mov    %ecx,%eax
  80124f:	c1 f8 1f             	sar    $0x1f,%eax
  801252:	29 c2                	sub    %eax,%edx
  801254:	89 d0                	mov    %edx,%eax
  801256:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  801259:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80125d:	75 bb                	jne    80121a <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  80125f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801266:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801269:	48                   	dec    %eax
  80126a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  80126d:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801271:	74 3d                	je     8012b0 <ltostr+0xc3>
		start = 1 ;
  801273:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  80127a:	eb 34                	jmp    8012b0 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  80127c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80127f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801282:	01 d0                	add    %edx,%eax
  801284:	8a 00                	mov    (%eax),%al
  801286:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801289:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80128c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80128f:	01 c2                	add    %eax,%edx
  801291:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801294:	8b 45 0c             	mov    0xc(%ebp),%eax
  801297:	01 c8                	add    %ecx,%eax
  801299:	8a 00                	mov    (%eax),%al
  80129b:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  80129d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8012a0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012a3:	01 c2                	add    %eax,%edx
  8012a5:	8a 45 eb             	mov    -0x15(%ebp),%al
  8012a8:	88 02                	mov    %al,(%edx)
		start++ ;
  8012aa:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8012ad:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8012b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8012b3:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8012b6:	7c c4                	jl     80127c <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8012b8:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8012bb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012be:	01 d0                	add    %edx,%eax
  8012c0:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8012c3:	90                   	nop
  8012c4:	c9                   	leave  
  8012c5:	c3                   	ret    

008012c6 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8012c6:	55                   	push   %ebp
  8012c7:	89 e5                	mov    %esp,%ebp
  8012c9:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8012cc:	ff 75 08             	pushl  0x8(%ebp)
  8012cf:	e8 c4 f9 ff ff       	call   800c98 <strlen>
  8012d4:	83 c4 04             	add    $0x4,%esp
  8012d7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8012da:	ff 75 0c             	pushl  0xc(%ebp)
  8012dd:	e8 b6 f9 ff ff       	call   800c98 <strlen>
  8012e2:	83 c4 04             	add    $0x4,%esp
  8012e5:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8012e8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8012ef:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8012f6:	eb 17                	jmp    80130f <strcconcat+0x49>
		final[s] = str1[s] ;
  8012f8:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8012fb:	8b 45 10             	mov    0x10(%ebp),%eax
  8012fe:	01 c2                	add    %eax,%edx
  801300:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801303:	8b 45 08             	mov    0x8(%ebp),%eax
  801306:	01 c8                	add    %ecx,%eax
  801308:	8a 00                	mov    (%eax),%al
  80130a:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  80130c:	ff 45 fc             	incl   -0x4(%ebp)
  80130f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801312:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801315:	7c e1                	jl     8012f8 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801317:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  80131e:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801325:	eb 1f                	jmp    801346 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801327:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80132a:	8d 50 01             	lea    0x1(%eax),%edx
  80132d:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801330:	89 c2                	mov    %eax,%edx
  801332:	8b 45 10             	mov    0x10(%ebp),%eax
  801335:	01 c2                	add    %eax,%edx
  801337:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  80133a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80133d:	01 c8                	add    %ecx,%eax
  80133f:	8a 00                	mov    (%eax),%al
  801341:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801343:	ff 45 f8             	incl   -0x8(%ebp)
  801346:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801349:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80134c:	7c d9                	jl     801327 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  80134e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801351:	8b 45 10             	mov    0x10(%ebp),%eax
  801354:	01 d0                	add    %edx,%eax
  801356:	c6 00 00             	movb   $0x0,(%eax)
}
  801359:	90                   	nop
  80135a:	c9                   	leave  
  80135b:	c3                   	ret    

0080135c <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  80135c:	55                   	push   %ebp
  80135d:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  80135f:	8b 45 14             	mov    0x14(%ebp),%eax
  801362:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801368:	8b 45 14             	mov    0x14(%ebp),%eax
  80136b:	8b 00                	mov    (%eax),%eax
  80136d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801374:	8b 45 10             	mov    0x10(%ebp),%eax
  801377:	01 d0                	add    %edx,%eax
  801379:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80137f:	eb 0c                	jmp    80138d <strsplit+0x31>
			*string++ = 0;
  801381:	8b 45 08             	mov    0x8(%ebp),%eax
  801384:	8d 50 01             	lea    0x1(%eax),%edx
  801387:	89 55 08             	mov    %edx,0x8(%ebp)
  80138a:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80138d:	8b 45 08             	mov    0x8(%ebp),%eax
  801390:	8a 00                	mov    (%eax),%al
  801392:	84 c0                	test   %al,%al
  801394:	74 18                	je     8013ae <strsplit+0x52>
  801396:	8b 45 08             	mov    0x8(%ebp),%eax
  801399:	8a 00                	mov    (%eax),%al
  80139b:	0f be c0             	movsbl %al,%eax
  80139e:	50                   	push   %eax
  80139f:	ff 75 0c             	pushl  0xc(%ebp)
  8013a2:	e8 83 fa ff ff       	call   800e2a <strchr>
  8013a7:	83 c4 08             	add    $0x8,%esp
  8013aa:	85 c0                	test   %eax,%eax
  8013ac:	75 d3                	jne    801381 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8013ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8013b1:	8a 00                	mov    (%eax),%al
  8013b3:	84 c0                	test   %al,%al
  8013b5:	74 5a                	je     801411 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8013b7:	8b 45 14             	mov    0x14(%ebp),%eax
  8013ba:	8b 00                	mov    (%eax),%eax
  8013bc:	83 f8 0f             	cmp    $0xf,%eax
  8013bf:	75 07                	jne    8013c8 <strsplit+0x6c>
		{
			return 0;
  8013c1:	b8 00 00 00 00       	mov    $0x0,%eax
  8013c6:	eb 66                	jmp    80142e <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8013c8:	8b 45 14             	mov    0x14(%ebp),%eax
  8013cb:	8b 00                	mov    (%eax),%eax
  8013cd:	8d 48 01             	lea    0x1(%eax),%ecx
  8013d0:	8b 55 14             	mov    0x14(%ebp),%edx
  8013d3:	89 0a                	mov    %ecx,(%edx)
  8013d5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8013dc:	8b 45 10             	mov    0x10(%ebp),%eax
  8013df:	01 c2                	add    %eax,%edx
  8013e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8013e4:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8013e6:	eb 03                	jmp    8013eb <strsplit+0x8f>
			string++;
  8013e8:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8013eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8013ee:	8a 00                	mov    (%eax),%al
  8013f0:	84 c0                	test   %al,%al
  8013f2:	74 8b                	je     80137f <strsplit+0x23>
  8013f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8013f7:	8a 00                	mov    (%eax),%al
  8013f9:	0f be c0             	movsbl %al,%eax
  8013fc:	50                   	push   %eax
  8013fd:	ff 75 0c             	pushl  0xc(%ebp)
  801400:	e8 25 fa ff ff       	call   800e2a <strchr>
  801405:	83 c4 08             	add    $0x8,%esp
  801408:	85 c0                	test   %eax,%eax
  80140a:	74 dc                	je     8013e8 <strsplit+0x8c>
			string++;
	}
  80140c:	e9 6e ff ff ff       	jmp    80137f <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801411:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801412:	8b 45 14             	mov    0x14(%ebp),%eax
  801415:	8b 00                	mov    (%eax),%eax
  801417:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80141e:	8b 45 10             	mov    0x10(%ebp),%eax
  801421:	01 d0                	add    %edx,%eax
  801423:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801429:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80142e:	c9                   	leave  
  80142f:	c3                   	ret    

00801430 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  801430:	55                   	push   %ebp
  801431:	89 e5                	mov    %esp,%ebp
  801433:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  801436:	8b 45 08             	mov    0x8(%ebp),%eax
  801439:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  80143c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801443:	eb 4a                	jmp    80148f <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  801445:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801448:	8b 45 08             	mov    0x8(%ebp),%eax
  80144b:	01 c2                	add    %eax,%edx
  80144d:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801450:	8b 45 0c             	mov    0xc(%ebp),%eax
  801453:	01 c8                	add    %ecx,%eax
  801455:	8a 00                	mov    (%eax),%al
  801457:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  801459:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80145c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80145f:	01 d0                	add    %edx,%eax
  801461:	8a 00                	mov    (%eax),%al
  801463:	3c 40                	cmp    $0x40,%al
  801465:	7e 25                	jle    80148c <str2lower+0x5c>
  801467:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80146a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80146d:	01 d0                	add    %edx,%eax
  80146f:	8a 00                	mov    (%eax),%al
  801471:	3c 5a                	cmp    $0x5a,%al
  801473:	7f 17                	jg     80148c <str2lower+0x5c>
		{
			dst[i] += 32 ;
  801475:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801478:	8b 45 08             	mov    0x8(%ebp),%eax
  80147b:	01 d0                	add    %edx,%eax
  80147d:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801480:	8b 55 08             	mov    0x8(%ebp),%edx
  801483:	01 ca                	add    %ecx,%edx
  801485:	8a 12                	mov    (%edx),%dl
  801487:	83 c2 20             	add    $0x20,%edx
  80148a:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  80148c:	ff 45 fc             	incl   -0x4(%ebp)
  80148f:	ff 75 0c             	pushl  0xc(%ebp)
  801492:	e8 01 f8 ff ff       	call   800c98 <strlen>
  801497:	83 c4 04             	add    $0x4,%esp
  80149a:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80149d:	7f a6                	jg     801445 <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  80149f:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8014a2:	c9                   	leave  
  8014a3:	c3                   	ret    

008014a4 <uheap_init>:
//==============================================
// [1] INITIALIZE USER HEAP:
//==============================================
int __firstTimeFlag = 1;
void uheap_init()
{
  8014a4:	55                   	push   %ebp
  8014a5:	89 e5                	mov    %esp,%ebp
  8014a7:	83 ec 08             	sub    $0x8,%esp
	if(__firstTimeFlag)
  8014aa:	a1 08 50 80 00       	mov    0x805008,%eax
  8014af:	85 c0                	test   %eax,%eax
  8014b1:	0f 84 95 00 00 00    	je     80154c <uheap_init+0xa8>
	{
		initialize_dynamic_allocator(USER_HEAP_START, USER_HEAP_START + DYN_ALLOC_MAX_SIZE);
  8014b7:	83 ec 08             	sub    $0x8,%esp
  8014ba:	68 00 00 00 82       	push   $0x82000000
  8014bf:	68 00 00 00 80       	push   $0x80000000
  8014c4:	e8 59 1f 00 00       	call   803422 <initialize_dynamic_allocator>
  8014c9:	83 c4 10             	add    $0x10,%esp
		uheapPlaceStrategy = sys_get_uheap_strategy();
  8014cc:	e8 93 1d 00 00       	call   803264 <sys_get_uheap_strategy>
  8014d1:	a3 60 d0 81 00       	mov    %eax,0x81d060
		uheapPageAllocStart = dynAllocEnd + PAGE_SIZE;
  8014d6:	a1 40 50 80 00       	mov    0x805040,%eax
  8014db:	05 00 10 00 00       	add    $0x1000,%eax
  8014e0:	a3 10 d1 81 00       	mov    %eax,0x81d110
		uheapPageAllocBreak = uheapPageAllocStart;
  8014e5:	a1 10 d1 81 00       	mov    0x81d110,%eax
  8014ea:	a3 68 d0 81 00       	mov    %eax,0x81d068
		init_uspinlock(&ulock,"malloc",1);
  8014ef:	83 ec 04             	sub    $0x4,%esp
  8014f2:	6a 01                	push   $0x1
  8014f4:	68 48 48 80 00       	push   $0x804848
  8014f9:	68 40 d1 81 00       	push   $0x81d140
  8014fe:	e8 1a 29 00 00       	call   803e1d <init_uspinlock>
  801503:	83 c4 10             	add    $0x10,%esp
		LIST_INIT(&u_freelist);
  801506:	c7 05 20 d1 81 00 00 	movl   $0x0,0x81d120
  80150d:	00 00 00 
  801510:	c7 05 24 d1 81 00 00 	movl   $0x0,0x81d124
  801517:	00 00 00 
  80151a:	c7 05 2c d1 81 00 00 	movl   $0x0,0x81d12c
  801521:	00 00 00 
		LIST_INIT(&u_allocatedlist);
  801524:	c7 05 30 d1 81 00 00 	movl   $0x0,0x81d130
  80152b:	00 00 00 
  80152e:	c7 05 34 d1 81 00 00 	movl   $0x0,0x81d134
  801535:	00 00 00 
  801538:	c7 05 3c d1 81 00 00 	movl   $0x0,0x81d13c
  80153f:	00 00 00 
		__firstTimeFlag = 0;
  801542:	c7 05 08 50 80 00 00 	movl   $0x0,0x805008
  801549:	00 00 00 
	}
}
  80154c:	90                   	nop
  80154d:	c9                   	leave  
  80154e:	c3                   	ret    

0080154f <get_page>:

//==============================================
// [2] GET A PAGE FROM THE KERNEL FOR DA:
//==============================================
int get_page(void* va)
{
  80154f:	55                   	push   %ebp
  801550:	89 e5                	mov    %esp,%ebp
  801552:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_allocate_page(ROUNDDOWN(va, PAGE_SIZE), PERM_USER|PERM_WRITEABLE|PERM_UHPAGE);
  801555:	8b 45 08             	mov    0x8(%ebp),%eax
  801558:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80155b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80155e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801563:	83 ec 08             	sub    $0x8,%esp
  801566:	68 06 04 00 00       	push   $0x406
  80156b:	50                   	push   %eax
  80156c:	e8 3d 19 00 00       	call   802eae <__sys_allocate_page>
  801571:	83 c4 10             	add    $0x10,%esp
  801574:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  801577:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80157b:	79 14                	jns    801591 <get_page+0x42>
		panic("get_page() in user: failed to allocate page from the kernel");
  80157d:	83 ec 04             	sub    $0x4,%esp
  801580:	68 50 48 80 00       	push   $0x804850
  801585:	6a 2d                	push   $0x2d
  801587:	68 8c 48 80 00       	push   $0x80488c
  80158c:	e8 60 ed ff ff       	call   8002f1 <_panic>
	return 0;
  801591:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801596:	c9                   	leave  
  801597:	c3                   	ret    

00801598 <return_page>:

//==============================================
// [3] RETURN A PAGE FROM THE DA TO KERNEL:
//==============================================
void return_page(void* va)
{
  801598:	55                   	push   %ebp
  801599:	89 e5                	mov    %esp,%ebp
  80159b:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_unmap_frame(ROUNDDOWN((uint32)va, PAGE_SIZE));
  80159e:	8b 45 08             	mov    0x8(%ebp),%eax
  8015a1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8015a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015a7:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8015ac:	83 ec 0c             	sub    $0xc,%esp
  8015af:	50                   	push   %eax
  8015b0:	e8 40 19 00 00       	call   802ef5 <__sys_unmap_frame>
  8015b5:	83 c4 10             	add    $0x10,%esp
  8015b8:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  8015bb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8015bf:	79 14                	jns    8015d5 <return_page+0x3d>
		panic("return_page() in user: failed to return a page to the kernel");
  8015c1:	83 ec 04             	sub    $0x4,%esp
  8015c4:	68 98 48 80 00       	push   $0x804898
  8015c9:	6a 38                	push   $0x38
  8015cb:	68 8c 48 80 00       	push   $0x80488c
  8015d0:	e8 1c ed ff ff       	call   8002f1 <_panic>
}
  8015d5:	90                   	nop
  8015d6:	c9                   	leave  
  8015d7:	c3                   	ret    

008015d8 <malloc>:

//=================================
// [1] ALLOCATE SPACE IN USER HEAP:
//=================================
void* malloc(uint32 size)
{
  8015d8:	55                   	push   %ebp
  8015d9:	89 e5                	mov    %esp,%ebp
  8015db:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  8015de:	e8 c1 fe ff ff       	call   8014a4 <uheap_init>
	if (size == 0) return NULL ;
  8015e3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8015e7:	75 0a                	jne    8015f3 <malloc+0x1b>
  8015e9:	b8 00 00 00 00       	mov    $0x0,%eax
  8015ee:	e9 e1 04 00 00       	jmp    801ad4 <malloc+0x4fc>
	//==============================================================

	acquire_uspinlock(&ulock);
  8015f3:	83 ec 0c             	sub    $0xc,%esp
  8015f6:	68 40 d1 81 00       	push   $0x81d140
  8015fb:	e8 6c 28 00 00       	call   803e6c <acquire_uspinlock>
  801600:	83 c4 10             	add    $0x10,%esp
	if(size <  DYN_ALLOC_MAX_BLOCK_SIZE){
  801603:	81 7d 08 ff 07 00 00 	cmpl   $0x7ff,0x8(%ebp)
  80160a:	77 23                	ja     80162f <malloc+0x57>
		release_uspinlock(&ulock);
  80160c:	83 ec 0c             	sub    $0xc,%esp
  80160f:	68 40 d1 81 00       	push   $0x81d140
  801614:	e8 ab 28 00 00       	call   803ec4 <release_uspinlock>
  801619:	83 c4 10             	add    $0x10,%esp
		return alloc_block(size);
  80161c:	83 ec 0c             	sub    $0xc,%esp
  80161f:	ff 75 08             	pushl  0x8(%ebp)
  801622:	e8 dd 1f 00 00       	call   803604 <alloc_block>
  801627:	83 c4 10             	add    $0x10,%esp
  80162a:	e9 a5 04 00 00       	jmp    801ad4 <malloc+0x4fc>
	}

	struct UserHeapStruct* allocblock= (struct UserHeapStruct*) alloc_block(sizeof(struct UserHeapStruct));
  80162f:	83 ec 0c             	sub    $0xc,%esp
  801632:	6a 10                	push   $0x10
  801634:	e8 cb 1f 00 00       	call   803604 <alloc_block>
  801639:	83 c4 10             	add    $0x10,%esp
  80163c:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (allocblock == NULL){
  80163f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801643:	75 0a                	jne    80164f <malloc+0x77>
			return NULL;
  801645:	b8 00 00 00 00       	mov    $0x0,%eax
  80164a:	e9 85 04 00 00       	jmp    801ad4 <malloc+0x4fc>
	}

	size = ROUNDUP(size,PAGE_SIZE);
  80164f:	c7 45 e8 00 10 00 00 	movl   $0x1000,-0x18(%ebp)
  801656:	8b 55 08             	mov    0x8(%ebp),%edx
  801659:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80165c:	01 d0                	add    %edx,%eax
  80165e:	48                   	dec    %eax
  80165f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801662:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801665:	ba 00 00 00 00       	mov    $0x0,%edx
  80166a:	f7 75 e8             	divl   -0x18(%ebp)
  80166d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801670:	29 d0                	sub    %edx,%eax
  801672:	89 45 08             	mov    %eax,0x8(%ebp)
	struct UserHeapStruct* lastfreeelement = LIST_LAST(&u_freelist);
  801675:	a1 24 d1 81 00       	mov    0x81d124,%eax
  80167a:	89 45 e0             	mov    %eax,-0x20(%ebp)

	if(LIST_SIZE(&u_freelist)==0 || size>lastfreeelement->size){
  80167d:	a1 2c d1 81 00       	mov    0x81d12c,%eax
  801682:	85 c0                	test   %eax,%eax
  801684:	74 0f                	je     801695 <malloc+0xbd>
  801686:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801689:	8b 40 04             	mov    0x4(%eax),%eax
  80168c:	3b 45 08             	cmp    0x8(%ebp),%eax
  80168f:	0f 83 ea 00 00 00    	jae    80177f <malloc+0x1a7>
			if(uheapPageAllocBreak < USER_HEAP_MAX - size){
  801695:	b8 00 00 00 a0       	mov    $0xa0000000,%eax
  80169a:	2b 45 08             	sub    0x8(%ebp),%eax
  80169d:	89 c2                	mov    %eax,%edx
  80169f:	a1 68 d0 81 00       	mov    0x81d068,%eax
  8016a4:	39 c2                	cmp    %eax,%edx
  8016a6:	0f 86 b9 00 00 00    	jbe    801765 <malloc+0x18d>
					uint32 requestedblockva = uheapPageAllocBreak;
  8016ac:	a1 68 d0 81 00       	mov    0x81d068,%eax
  8016b1:	89 45 dc             	mov    %eax,-0x24(%ebp)
					uheapPageAllocBreak+=size;
  8016b4:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  8016ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8016bd:	01 d0                	add    %edx,%eax
  8016bf:	a3 68 d0 81 00       	mov    %eax,0x81d068
					allocblock->startva = requestedblockva;
  8016c4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8016c7:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8016ca:	89 10                	mov    %edx,(%eax)
					allocblock->size = size;
  8016cc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8016cf:	8b 55 08             	mov    0x8(%ebp),%edx
  8016d2:	89 50 04             	mov    %edx,0x4(%eax)

					LIST_INSERT_TAIL(&u_allocatedlist, allocblock);
  8016d5:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8016d9:	75 14                	jne    8016ef <malloc+0x117>
  8016db:	83 ec 04             	sub    $0x4,%esp
  8016de:	68 d8 48 80 00       	push   $0x8048d8
  8016e3:	6a 60                	push   $0x60
  8016e5:	68 8c 48 80 00       	push   $0x80488c
  8016ea:	e8 02 ec ff ff       	call   8002f1 <_panic>
  8016ef:	8b 15 34 d1 81 00    	mov    0x81d134,%edx
  8016f5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8016f8:	89 50 0c             	mov    %edx,0xc(%eax)
  8016fb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8016fe:	8b 40 0c             	mov    0xc(%eax),%eax
  801701:	85 c0                	test   %eax,%eax
  801703:	74 0d                	je     801712 <malloc+0x13a>
  801705:	a1 34 d1 81 00       	mov    0x81d134,%eax
  80170a:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80170d:	89 50 08             	mov    %edx,0x8(%eax)
  801710:	eb 08                	jmp    80171a <malloc+0x142>
  801712:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801715:	a3 30 d1 81 00       	mov    %eax,0x81d130
  80171a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80171d:	a3 34 d1 81 00       	mov    %eax,0x81d134
  801722:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801725:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  80172c:	a1 3c d1 81 00       	mov    0x81d13c,%eax
  801731:	40                   	inc    %eax
  801732:	a3 3c d1 81 00       	mov    %eax,0x81d13c


					sys_allocate_user_mem(allocblock->startva ,size);
  801737:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80173a:	8b 00                	mov    (%eax),%eax
  80173c:	83 ec 08             	sub    $0x8,%esp
  80173f:	ff 75 08             	pushl  0x8(%ebp)
  801742:	50                   	push   %eax
  801743:	e8 34 1c 00 00       	call   80337c <sys_allocate_user_mem>
  801748:	83 c4 10             	add    $0x10,%esp
					release_uspinlock(&ulock);
  80174b:	83 ec 0c             	sub    $0xc,%esp
  80174e:	68 40 d1 81 00       	push   $0x81d140
  801753:	e8 6c 27 00 00       	call   803ec4 <release_uspinlock>
  801758:	83 c4 10             	add    $0x10,%esp
					return (void*)allocblock->startva;
  80175b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80175e:	8b 00                	mov    (%eax),%eax
  801760:	e9 6f 03 00 00       	jmp    801ad4 <malloc+0x4fc>
			}else{
					release_uspinlock(&ulock);
  801765:	83 ec 0c             	sub    $0xc,%esp
  801768:	68 40 d1 81 00       	push   $0x81d140
  80176d:	e8 52 27 00 00       	call   803ec4 <release_uspinlock>
  801772:	83 c4 10             	add    $0x10,%esp
					return NULL;
  801775:	b8 00 00 00 00       	mov    $0x0,%eax
  80177a:	e9 55 03 00 00       	jmp    801ad4 <malloc+0x4fc>
				}
	}else{
		//custom fit
		struct UserHeapStruct* currentfreeelement = LIST_FIRST(&u_freelist);
  80177f:	a1 20 d1 81 00       	mov    0x81d120,%eax
  801784:	89 45 f4             	mov    %eax,-0xc(%ebp)
		//worst fit
		while(currentfreeelement != NULL){
  801787:	e9 39 03 00 00       	jmp    801ac5 <malloc+0x4ed>
			if(size<currentfreeelement->size){
  80178c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80178f:	8b 40 04             	mov    0x4(%eax),%eax
  801792:	3b 45 08             	cmp    0x8(%ebp),%eax
  801795:	0f 86 e7 01 00 00    	jbe    801982 <malloc+0x3aa>
				allocblock->startva = lastfreeelement->startva;
  80179b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80179e:	8b 10                	mov    (%eax),%edx
  8017a0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8017a3:	89 10                	mov    %edx,(%eax)
                allocblock->size = size;
  8017a5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8017a8:	8b 55 08             	mov    0x8(%ebp),%edx
  8017ab:	89 50 04             	mov    %edx,0x4(%eax)
                LIST_INSERT_TAIL(&u_allocatedlist,allocblock);
  8017ae:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8017b2:	75 14                	jne    8017c8 <malloc+0x1f0>
  8017b4:	83 ec 04             	sub    $0x4,%esp
  8017b7:	68 d8 48 80 00       	push   $0x8048d8
  8017bc:	6a 72                	push   $0x72
  8017be:	68 8c 48 80 00       	push   $0x80488c
  8017c3:	e8 29 eb ff ff       	call   8002f1 <_panic>
  8017c8:	8b 15 34 d1 81 00    	mov    0x81d134,%edx
  8017ce:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8017d1:	89 50 0c             	mov    %edx,0xc(%eax)
  8017d4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8017d7:	8b 40 0c             	mov    0xc(%eax),%eax
  8017da:	85 c0                	test   %eax,%eax
  8017dc:	74 0d                	je     8017eb <malloc+0x213>
  8017de:	a1 34 d1 81 00       	mov    0x81d134,%eax
  8017e3:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8017e6:	89 50 08             	mov    %edx,0x8(%eax)
  8017e9:	eb 08                	jmp    8017f3 <malloc+0x21b>
  8017eb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8017ee:	a3 30 d1 81 00       	mov    %eax,0x81d130
  8017f3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8017f6:	a3 34 d1 81 00       	mov    %eax,0x81d134
  8017fb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8017fe:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  801805:	a1 3c d1 81 00       	mov    0x81d13c,%eax
  80180a:	40                   	inc    %eax
  80180b:	a3 3c d1 81 00       	mov    %eax,0x81d13c
                lastfreeelement->startva += size;
  801810:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801813:	8b 10                	mov    (%eax),%edx
  801815:	8b 45 08             	mov    0x8(%ebp),%eax
  801818:	01 c2                	add    %eax,%edx
  80181a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80181d:	89 10                	mov    %edx,(%eax)
                lastfreeelement->size -= size;
  80181f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801822:	8b 40 04             	mov    0x4(%eax),%eax
  801825:	2b 45 08             	sub    0x8(%ebp),%eax
  801828:	89 c2                	mov    %eax,%edx
  80182a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80182d:	89 50 04             	mov    %edx,0x4(%eax)
                struct UserHeapStruct* currentfree2 = LIST_FIRST(&u_freelist);
  801830:	a1 20 d1 81 00       	mov    0x81d120,%eax
  801835:	89 45 f0             	mov    %eax,-0x10(%ebp)
                //check order of last element

                while (currentfree2 != NULL){
  801838:	e9 0d 01 00 00       	jmp    80194a <malloc+0x372>
                	if(lastfreeelement->size <currentfree2->size){
  80183d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801840:	8b 50 04             	mov    0x4(%eax),%edx
  801843:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801846:	8b 40 04             	mov    0x4(%eax),%eax
  801849:	39 c2                	cmp    %eax,%edx
  80184b:	0f 83 f0 00 00 00    	jae    801941 <malloc+0x369>
                		LIST_REMOVE(&u_freelist ,lastfreeelement);
  801851:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801855:	75 14                	jne    80186b <malloc+0x293>
  801857:	83 ec 04             	sub    $0x4,%esp
  80185a:	68 fb 48 80 00       	push   $0x8048fb
  80185f:	6a 7a                	push   $0x7a
  801861:	68 8c 48 80 00       	push   $0x80488c
  801866:	e8 86 ea ff ff       	call   8002f1 <_panic>
  80186b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80186e:	8b 40 08             	mov    0x8(%eax),%eax
  801871:	85 c0                	test   %eax,%eax
  801873:	74 11                	je     801886 <malloc+0x2ae>
  801875:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801878:	8b 40 08             	mov    0x8(%eax),%eax
  80187b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80187e:	8b 52 0c             	mov    0xc(%edx),%edx
  801881:	89 50 0c             	mov    %edx,0xc(%eax)
  801884:	eb 0b                	jmp    801891 <malloc+0x2b9>
  801886:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801889:	8b 40 0c             	mov    0xc(%eax),%eax
  80188c:	a3 24 d1 81 00       	mov    %eax,0x81d124
  801891:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801894:	8b 40 0c             	mov    0xc(%eax),%eax
  801897:	85 c0                	test   %eax,%eax
  801899:	74 11                	je     8018ac <malloc+0x2d4>
  80189b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80189e:	8b 40 0c             	mov    0xc(%eax),%eax
  8018a1:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8018a4:	8b 52 08             	mov    0x8(%edx),%edx
  8018a7:	89 50 08             	mov    %edx,0x8(%eax)
  8018aa:	eb 0b                	jmp    8018b7 <malloc+0x2df>
  8018ac:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8018af:	8b 40 08             	mov    0x8(%eax),%eax
  8018b2:	a3 20 d1 81 00       	mov    %eax,0x81d120
  8018b7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8018ba:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  8018c1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8018c4:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  8018cb:	a1 2c d1 81 00       	mov    0x81d12c,%eax
  8018d0:	48                   	dec    %eax
  8018d1:	a3 2c d1 81 00       	mov    %eax,0x81d12c
                		LIST_INSERT_BEFORE(&u_freelist ,currentfree2 ,lastfreeelement);
  8018d6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8018da:	74 06                	je     8018e2 <malloc+0x30a>
  8018dc:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8018e0:	75 14                	jne    8018f6 <malloc+0x31e>
  8018e2:	83 ec 04             	sub    $0x4,%esp
  8018e5:	68 1c 49 80 00       	push   $0x80491c
  8018ea:	6a 7b                	push   $0x7b
  8018ec:	68 8c 48 80 00       	push   $0x80488c
  8018f1:	e8 fb e9 ff ff       	call   8002f1 <_panic>
  8018f6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018f9:	8b 50 0c             	mov    0xc(%eax),%edx
  8018fc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8018ff:	89 50 0c             	mov    %edx,0xc(%eax)
  801902:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801905:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801908:	89 50 08             	mov    %edx,0x8(%eax)
  80190b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80190e:	8b 40 0c             	mov    0xc(%eax),%eax
  801911:	85 c0                	test   %eax,%eax
  801913:	74 0e                	je     801923 <malloc+0x34b>
  801915:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801918:	8b 40 0c             	mov    0xc(%eax),%eax
  80191b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80191e:	89 50 08             	mov    %edx,0x8(%eax)
  801921:	eb 08                	jmp    80192b <malloc+0x353>
  801923:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801926:	a3 20 d1 81 00       	mov    %eax,0x81d120
  80192b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80192e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801931:	89 50 0c             	mov    %edx,0xc(%eax)
  801934:	a1 2c d1 81 00       	mov    0x81d12c,%eax
  801939:	40                   	inc    %eax
  80193a:	a3 2c d1 81 00       	mov    %eax,0x81d12c
                		break;
  80193f:	eb 13                	jmp    801954 <malloc+0x37c>
                	}
                	currentfree2 = currentfree2->prev_next_info.le_next;
  801941:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801944:	8b 40 08             	mov    0x8(%eax),%eax
  801947:	89 45 f0             	mov    %eax,-0x10(%ebp)
                lastfreeelement->startva += size;
                lastfreeelement->size -= size;
                struct UserHeapStruct* currentfree2 = LIST_FIRST(&u_freelist);
                //check order of last element

                while (currentfree2 != NULL){
  80194a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80194e:	0f 85 e9 fe ff ff    	jne    80183d <malloc+0x265>
                	}
                	currentfree2 = currentfree2->prev_next_info.le_next;
                }


                sys_allocate_user_mem(allocblock->startva ,size);
  801954:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801957:	8b 00                	mov    (%eax),%eax
  801959:	83 ec 08             	sub    $0x8,%esp
  80195c:	ff 75 08             	pushl  0x8(%ebp)
  80195f:	50                   	push   %eax
  801960:	e8 17 1a 00 00       	call   80337c <sys_allocate_user_mem>
  801965:	83 c4 10             	add    $0x10,%esp
                release_uspinlock(&ulock);
  801968:	83 ec 0c             	sub    $0xc,%esp
  80196b:	68 40 d1 81 00       	push   $0x81d140
  801970:	e8 4f 25 00 00       	call   803ec4 <release_uspinlock>
  801975:	83 c4 10             	add    $0x10,%esp
                return (void*)allocblock->startva;
  801978:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80197b:	8b 00                	mov    (%eax),%eax
  80197d:	e9 52 01 00 00       	jmp    801ad4 <malloc+0x4fc>
                //exact fit
			}else if(size == currentfreeelement->size){
  801982:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801985:	8b 40 04             	mov    0x4(%eax),%eax
  801988:	3b 45 08             	cmp    0x8(%ebp),%eax
  80198b:	0f 85 2b 01 00 00    	jne    801abc <malloc+0x4e4>
				allocblock->startva = currentfreeelement->startva;
  801991:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801994:	8b 10                	mov    (%eax),%edx
  801996:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801999:	89 10                	mov    %edx,(%eax)
				allocblock->size = size;
  80199b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80199e:	8b 55 08             	mov    0x8(%ebp),%edx
  8019a1:	89 50 04             	mov    %edx,0x4(%eax)
				LIST_INSERT_TAIL(&u_allocatedlist ,allocblock);
  8019a4:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8019a8:	75 17                	jne    8019c1 <malloc+0x3e9>
  8019aa:	83 ec 04             	sub    $0x4,%esp
  8019ad:	68 d8 48 80 00       	push   $0x8048d8
  8019b2:	68 89 00 00 00       	push   $0x89
  8019b7:	68 8c 48 80 00       	push   $0x80488c
  8019bc:	e8 30 e9 ff ff       	call   8002f1 <_panic>
  8019c1:	8b 15 34 d1 81 00    	mov    0x81d134,%edx
  8019c7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8019ca:	89 50 0c             	mov    %edx,0xc(%eax)
  8019cd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8019d0:	8b 40 0c             	mov    0xc(%eax),%eax
  8019d3:	85 c0                	test   %eax,%eax
  8019d5:	74 0d                	je     8019e4 <malloc+0x40c>
  8019d7:	a1 34 d1 81 00       	mov    0x81d134,%eax
  8019dc:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8019df:	89 50 08             	mov    %edx,0x8(%eax)
  8019e2:	eb 08                	jmp    8019ec <malloc+0x414>
  8019e4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8019e7:	a3 30 d1 81 00       	mov    %eax,0x81d130
  8019ec:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8019ef:	a3 34 d1 81 00       	mov    %eax,0x81d134
  8019f4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8019f7:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  8019fe:	a1 3c d1 81 00       	mov    0x81d13c,%eax
  801a03:	40                   	inc    %eax
  801a04:	a3 3c d1 81 00       	mov    %eax,0x81d13c
				LIST_REMOVE(&u_freelist ,currentfreeelement);
  801a09:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801a0d:	75 17                	jne    801a26 <malloc+0x44e>
  801a0f:	83 ec 04             	sub    $0x4,%esp
  801a12:	68 fb 48 80 00       	push   $0x8048fb
  801a17:	68 8a 00 00 00       	push   $0x8a
  801a1c:	68 8c 48 80 00       	push   $0x80488c
  801a21:	e8 cb e8 ff ff       	call   8002f1 <_panic>
  801a26:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a29:	8b 40 08             	mov    0x8(%eax),%eax
  801a2c:	85 c0                	test   %eax,%eax
  801a2e:	74 11                	je     801a41 <malloc+0x469>
  801a30:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a33:	8b 40 08             	mov    0x8(%eax),%eax
  801a36:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801a39:	8b 52 0c             	mov    0xc(%edx),%edx
  801a3c:	89 50 0c             	mov    %edx,0xc(%eax)
  801a3f:	eb 0b                	jmp    801a4c <malloc+0x474>
  801a41:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a44:	8b 40 0c             	mov    0xc(%eax),%eax
  801a47:	a3 24 d1 81 00       	mov    %eax,0x81d124
  801a4c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a4f:	8b 40 0c             	mov    0xc(%eax),%eax
  801a52:	85 c0                	test   %eax,%eax
  801a54:	74 11                	je     801a67 <malloc+0x48f>
  801a56:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a59:	8b 40 0c             	mov    0xc(%eax),%eax
  801a5c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801a5f:	8b 52 08             	mov    0x8(%edx),%edx
  801a62:	89 50 08             	mov    %edx,0x8(%eax)
  801a65:	eb 0b                	jmp    801a72 <malloc+0x49a>
  801a67:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a6a:	8b 40 08             	mov    0x8(%eax),%eax
  801a6d:	a3 20 d1 81 00       	mov    %eax,0x81d120
  801a72:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a75:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  801a7c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a7f:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  801a86:	a1 2c d1 81 00       	mov    0x81d12c,%eax
  801a8b:	48                   	dec    %eax
  801a8c:	a3 2c d1 81 00       	mov    %eax,0x81d12c
				sys_allocate_user_mem(allocblock->startva ,size);
  801a91:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801a94:	8b 00                	mov    (%eax),%eax
  801a96:	83 ec 08             	sub    $0x8,%esp
  801a99:	ff 75 08             	pushl  0x8(%ebp)
  801a9c:	50                   	push   %eax
  801a9d:	e8 da 18 00 00       	call   80337c <sys_allocate_user_mem>
  801aa2:	83 c4 10             	add    $0x10,%esp
				release_uspinlock(&ulock);
  801aa5:	83 ec 0c             	sub    $0xc,%esp
  801aa8:	68 40 d1 81 00       	push   $0x81d140
  801aad:	e8 12 24 00 00       	call   803ec4 <release_uspinlock>
  801ab2:	83 c4 10             	add    $0x10,%esp
				return (void*)allocblock->startva;
  801ab5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801ab8:	8b 00                	mov    (%eax),%eax
  801aba:	eb 18                	jmp    801ad4 <malloc+0x4fc>
			}
			currentfreeelement = currentfreeelement->prev_next_info.le_next;
  801abc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801abf:	8b 40 08             	mov    0x8(%eax),%eax
  801ac2:	89 45 f4             	mov    %eax,-0xc(%ebp)
				}
	}else{
		//custom fit
		struct UserHeapStruct* currentfreeelement = LIST_FIRST(&u_freelist);
		//worst fit
		while(currentfreeelement != NULL){
  801ac5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801ac9:	0f 85 bd fc ff ff    	jne    80178c <malloc+0x1b4>
				return (void*)allocblock->startva;
			}
			currentfreeelement = currentfreeelement->prev_next_info.le_next;
		}
	}
	 return NULL;
  801acf:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ad4:	c9                   	leave  
  801ad5:	c3                   	ret    

00801ad6 <free>:

//=================================
// [2] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
  801ad6:	55                   	push   %ebp
  801ad7:	89 e5                	mov    %esp,%ebp
  801ad9:	83 ec 38             	sub    $0x38,%esp
	uint32  VA = ROUNDDOWN(((uint32 ) virtual_address), PAGE_SIZE);
  801adc:	8b 45 08             	mov    0x8(%ebp),%eax
  801adf:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801ae2:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801ae5:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801aea:	89 45 d8             	mov    %eax,-0x28(%ebp)


		uheap_init();
  801aed:	e8 b2 f9 ff ff       	call   8014a4 <uheap_init>
		acquire_uspinlock(&ulock);
  801af2:	83 ec 0c             	sub    $0xc,%esp
  801af5:	68 40 d1 81 00       	push   $0x81d140
  801afa:	e8 6d 23 00 00       	call   803e6c <acquire_uspinlock>
  801aff:	83 c4 10             	add    $0x10,%esp
		if (VA < uheapPageAllocStart){
  801b02:	a1 10 d1 81 00       	mov    0x81d110,%eax
  801b07:	39 45 d8             	cmp    %eax,-0x28(%ebp)
  801b0a:	73 23                	jae    801b2f <free+0x59>
			free_block(virtual_address);
  801b0c:	83 ec 0c             	sub    $0xc,%esp
  801b0f:	ff 75 08             	pushl  0x8(%ebp)
  801b12:	e8 89 1f 00 00       	call   803aa0 <free_block>
  801b17:	83 c4 10             	add    $0x10,%esp
			release_uspinlock(&ulock);
  801b1a:	83 ec 0c             	sub    $0xc,%esp
  801b1d:	68 40 d1 81 00       	push   $0x81d140
  801b22:	e8 9d 23 00 00       	call   803ec4 <release_uspinlock>
  801b27:	83 c4 10             	add    $0x10,%esp
			return;
  801b2a:	e9 35 07 00 00       	jmp    802264 <free+0x78e>
		}
		if (VA >= uheapPageAllocBreak){
  801b2f:	a1 68 d0 81 00       	mov    0x81d068,%eax
  801b34:	39 45 d8             	cmp    %eax,-0x28(%ebp)
  801b37:	72 30                	jb     801b69 <free+0x93>
			cprintf("%d\n %d\n", VA, uheapPageAllocBreak);
  801b39:	a1 68 d0 81 00       	mov    0x81d068,%eax
  801b3e:	83 ec 04             	sub    $0x4,%esp
  801b41:	50                   	push   %eax
  801b42:	ff 75 d8             	pushl  -0x28(%ebp)
  801b45:	68 51 49 80 00       	push   $0x804951
  801b4a:	e8 70 ea ff ff       	call   8005bf <cprintf>
  801b4f:	83 c4 10             	add    $0x10,%esp

			panic("freeing from restricted area");
  801b52:	83 ec 04             	sub    $0x4,%esp
  801b55:	68 59 49 80 00       	push   $0x804959
  801b5a:	68 a7 00 00 00       	push   $0xa7
  801b5f:	68 8c 48 80 00       	push   $0x80488c
  801b64:	e8 88 e7 ff ff       	call   8002f1 <_panic>
			release_uspinlock(&ulock);
			return;
		}

		struct UserHeapStruct* newfree = (struct UserHeapStruct*) alloc_block(sizeof(struct UserHeapStruct));
  801b69:	83 ec 0c             	sub    $0xc,%esp
  801b6c:	6a 10                	push   $0x10
  801b6e:	e8 91 1a 00 00       	call   803604 <alloc_block>
  801b73:	83 c4 10             	add    $0x10,%esp
  801b76:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		struct UserHeapStruct* MergedBlock  = ( struct UserHeapStruct*)alloc_block(sizeof(struct UserHeapStruct));
  801b79:	83 ec 0c             	sub    $0xc,%esp
  801b7c:	6a 10                	push   $0x10
  801b7e:	e8 81 1a 00 00       	call   803604 <alloc_block>
  801b83:	83 c4 10             	add    $0x10,%esp
  801b86:	89 45 d0             	mov    %eax,-0x30(%ebp)

		struct UserHeapStruct* ToBefreed = LIST_FIRST(&u_allocatedlist);
  801b89:	a1 30 d1 81 00       	mov    0x81d130,%eax
  801b8e:	89 45 f4             	mov    %eax,-0xc(%ebp)
		bool foundVA = 0;
  801b91:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

		//find the allocated block
		while(ToBefreed !=NULL ){
  801b98:	eb 1c                	jmp    801bb6 <free+0xe0>

			if (VA ==ToBefreed->startva ){
  801b9a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b9d:	8b 00                	mov    (%eax),%eax
  801b9f:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  801ba2:	75 09                	jne    801bad <free+0xd7>
				foundVA = 1;
  801ba4:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
				break;
  801bab:	eb 0f                	jmp    801bbc <free+0xe6>
			}
				ToBefreed = ToBefreed->prev_next_info.le_next;
  801bad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bb0:	8b 40 08             	mov    0x8(%eax),%eax
  801bb3:	89 45 f4             	mov    %eax,-0xc(%ebp)

		struct UserHeapStruct* ToBefreed = LIST_FIRST(&u_allocatedlist);
		bool foundVA = 0;

		//find the allocated block
		while(ToBefreed !=NULL ){
  801bb6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801bba:	75 de                	jne    801b9a <free+0xc4>
			}
				ToBefreed = ToBefreed->prev_next_info.le_next;
		}


		if(!foundVA){
  801bbc:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801bc0:	75 17                	jne    801bd9 <free+0x103>
				panic("INVALID ADDRESS!");
  801bc2:	83 ec 04             	sub    $0x4,%esp
  801bc5:	68 76 49 80 00       	push   $0x804976
  801bca:	68 be 00 00 00       	push   $0xbe
  801bcf:	68 8c 48 80 00       	push   $0x80488c
  801bd4:	e8 18 e7 ff ff       	call   8002f1 <_panic>
				release_uspinlock(&ulock);
				return;
			}


		newfree->startva = ToBefreed->startva;
  801bd9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bdc:	8b 10                	mov    (%eax),%edx
  801bde:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801be1:	89 10                	mov    %edx,(%eax)
		newfree->size = ToBefreed->size;
  801be3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801be6:	8b 50 04             	mov    0x4(%eax),%edx
  801be9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801bec:	89 50 04             	mov    %edx,0x4(%eax)

		//remove allocated block from alloclist
		LIST_REMOVE(&u_allocatedlist, ToBefreed);
  801bef:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801bf3:	75 17                	jne    801c0c <free+0x136>
  801bf5:	83 ec 04             	sub    $0x4,%esp
  801bf8:	68 fb 48 80 00       	push   $0x8048fb
  801bfd:	68 c8 00 00 00       	push   $0xc8
  801c02:	68 8c 48 80 00       	push   $0x80488c
  801c07:	e8 e5 e6 ff ff       	call   8002f1 <_panic>
  801c0c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c0f:	8b 40 08             	mov    0x8(%eax),%eax
  801c12:	85 c0                	test   %eax,%eax
  801c14:	74 11                	je     801c27 <free+0x151>
  801c16:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c19:	8b 40 08             	mov    0x8(%eax),%eax
  801c1c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801c1f:	8b 52 0c             	mov    0xc(%edx),%edx
  801c22:	89 50 0c             	mov    %edx,0xc(%eax)
  801c25:	eb 0b                	jmp    801c32 <free+0x15c>
  801c27:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c2a:	8b 40 0c             	mov    0xc(%eax),%eax
  801c2d:	a3 34 d1 81 00       	mov    %eax,0x81d134
  801c32:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c35:	8b 40 0c             	mov    0xc(%eax),%eax
  801c38:	85 c0                	test   %eax,%eax
  801c3a:	74 11                	je     801c4d <free+0x177>
  801c3c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c3f:	8b 40 0c             	mov    0xc(%eax),%eax
  801c42:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801c45:	8b 52 08             	mov    0x8(%edx),%edx
  801c48:	89 50 08             	mov    %edx,0x8(%eax)
  801c4b:	eb 0b                	jmp    801c58 <free+0x182>
  801c4d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c50:	8b 40 08             	mov    0x8(%eax),%eax
  801c53:	a3 30 d1 81 00       	mov    %eax,0x81d130
  801c58:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c5b:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  801c62:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c65:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  801c6c:	a1 3c d1 81 00       	mov    0x81d13c,%eax
  801c71:	48                   	dec    %eax
  801c72:	a3 3c d1 81 00       	mov    %eax,0x81d13c

		sys_free_user_mem(ToBefreed->startva, ToBefreed->size);
  801c77:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c7a:	8b 50 04             	mov    0x4(%eax),%edx
  801c7d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c80:	8b 00                	mov    (%eax),%eax
  801c82:	83 ec 08             	sub    $0x8,%esp
  801c85:	52                   	push   %edx
  801c86:	50                   	push   %eax
  801c87:	e8 d4 16 00 00       	call   803360 <sys_free_user_mem>
  801c8c:	83 c4 10             	add    $0x10,%esp




		if(LIST_SIZE(&u_freelist) == 0){
  801c8f:	a1 2c d1 81 00       	mov    0x81d12c,%eax
  801c94:	85 c0                	test   %eax,%eax
  801c96:	75 7a                	jne    801d12 <free+0x23c>
			LIST_INSERT_HEAD(&u_freelist,newfree);
  801c98:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  801c9c:	75 17                	jne    801cb5 <free+0x1df>
  801c9e:	83 ec 04             	sub    $0x4,%esp
  801ca1:	68 88 49 80 00       	push   $0x804988
  801ca6:	68 d0 00 00 00       	push   $0xd0
  801cab:	68 8c 48 80 00       	push   $0x80488c
  801cb0:	e8 3c e6 ff ff       	call   8002f1 <_panic>
  801cb5:	8b 15 20 d1 81 00    	mov    0x81d120,%edx
  801cbb:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801cbe:	89 50 08             	mov    %edx,0x8(%eax)
  801cc1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801cc4:	8b 40 08             	mov    0x8(%eax),%eax
  801cc7:	85 c0                	test   %eax,%eax
  801cc9:	74 0d                	je     801cd8 <free+0x202>
  801ccb:	a1 20 d1 81 00       	mov    0x81d120,%eax
  801cd0:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  801cd3:	89 50 0c             	mov    %edx,0xc(%eax)
  801cd6:	eb 08                	jmp    801ce0 <free+0x20a>
  801cd8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801cdb:	a3 24 d1 81 00       	mov    %eax,0x81d124
  801ce0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801ce3:	a3 20 d1 81 00       	mov    %eax,0x81d120
  801ce8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801ceb:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  801cf2:	a1 2c d1 81 00       	mov    0x81d12c,%eax
  801cf7:	40                   	inc    %eax
  801cf8:	a3 2c d1 81 00       	mov    %eax,0x81d12c
			release_uspinlock(&ulock);
  801cfd:	83 ec 0c             	sub    $0xc,%esp
  801d00:	68 40 d1 81 00       	push   $0x81d140
  801d05:	e8 ba 21 00 00       	call   803ec4 <release_uspinlock>
  801d0a:	83 c4 10             	add    $0x10,%esp
			return;
  801d0d:	e9 52 05 00 00       	jmp    802264 <free+0x78e>
		}


		struct UserHeapStruct* ToBeMerged = LIST_FIRST(&u_freelist);
  801d12:	a1 20 d1 81 00       	mov    0x81d120,%eax
  801d17:	89 45 ec             	mov    %eax,-0x14(%ebp)
		// merge with prev if possible
		bool mergeprev = 0;
  801d1a:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		bool mergenext = 0;
  801d21:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
		while(ToBeMerged != NULL){
  801d28:	e9 d2 00 00 00       	jmp    801dff <free+0x329>
			if((ToBeMerged->startva +ToBeMerged->size) == newfree->startva){
  801d2d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801d30:	8b 10                	mov    (%eax),%edx
  801d32:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801d35:	8b 40 04             	mov    0x4(%eax),%eax
  801d38:	01 c2                	add    %eax,%edx
  801d3a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801d3d:	8b 00                	mov    (%eax),%eax
  801d3f:	39 c2                	cmp    %eax,%edx
  801d41:	0f 85 af 00 00 00    	jne    801df6 <free+0x320>

				MergedBlock->startva = ToBeMerged->startva;
  801d47:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801d4a:	8b 10                	mov    (%eax),%edx
  801d4c:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801d4f:	89 10                	mov    %edx,(%eax)
				MergedBlock->size = ToBeMerged->size + newfree->size;
  801d51:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801d54:	8b 50 04             	mov    0x4(%eax),%edx
  801d57:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801d5a:	8b 40 04             	mov    0x4(%eax),%eax
  801d5d:	01 c2                	add    %eax,%edx
  801d5f:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801d62:	89 50 04             	mov    %edx,0x4(%eax)
				LIST_REMOVE(&u_freelist, ToBeMerged);
  801d65:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801d69:	75 17                	jne    801d82 <free+0x2ac>
  801d6b:	83 ec 04             	sub    $0x4,%esp
  801d6e:	68 fb 48 80 00       	push   $0x8048fb
  801d73:	68 df 00 00 00       	push   $0xdf
  801d78:	68 8c 48 80 00       	push   $0x80488c
  801d7d:	e8 6f e5 ff ff       	call   8002f1 <_panic>
  801d82:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801d85:	8b 40 08             	mov    0x8(%eax),%eax
  801d88:	85 c0                	test   %eax,%eax
  801d8a:	74 11                	je     801d9d <free+0x2c7>
  801d8c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801d8f:	8b 40 08             	mov    0x8(%eax),%eax
  801d92:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801d95:	8b 52 0c             	mov    0xc(%edx),%edx
  801d98:	89 50 0c             	mov    %edx,0xc(%eax)
  801d9b:	eb 0b                	jmp    801da8 <free+0x2d2>
  801d9d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801da0:	8b 40 0c             	mov    0xc(%eax),%eax
  801da3:	a3 24 d1 81 00       	mov    %eax,0x81d124
  801da8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801dab:	8b 40 0c             	mov    0xc(%eax),%eax
  801dae:	85 c0                	test   %eax,%eax
  801db0:	74 11                	je     801dc3 <free+0x2ed>
  801db2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801db5:	8b 40 0c             	mov    0xc(%eax),%eax
  801db8:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801dbb:	8b 52 08             	mov    0x8(%edx),%edx
  801dbe:	89 50 08             	mov    %edx,0x8(%eax)
  801dc1:	eb 0b                	jmp    801dce <free+0x2f8>
  801dc3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801dc6:	8b 40 08             	mov    0x8(%eax),%eax
  801dc9:	a3 20 d1 81 00       	mov    %eax,0x81d120
  801dce:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801dd1:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  801dd8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801ddb:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  801de2:	a1 2c d1 81 00       	mov    0x81d12c,%eax
  801de7:	48                   	dec    %eax
  801de8:	a3 2c d1 81 00       	mov    %eax,0x81d12c
				mergeprev = 1;
  801ded:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
				break;
  801df4:	eb 13                	jmp    801e09 <free+0x333>
			}
				ToBeMerged = ToBeMerged->prev_next_info.le_next;
  801df6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801df9:	8b 40 08             	mov    0x8(%eax),%eax
  801dfc:	89 45 ec             	mov    %eax,-0x14(%ebp)

		struct UserHeapStruct* ToBeMerged = LIST_FIRST(&u_freelist);
		// merge with prev if possible
		bool mergeprev = 0;
		bool mergenext = 0;
		while(ToBeMerged != NULL){
  801dff:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801e03:	0f 85 24 ff ff ff    	jne    801d2d <free+0x257>
//									uheapPageAllocBreak = newfree->startva;
//						}
//					}


		if ( newfree ->startva + newfree->size == uheapPageAllocBreak){
  801e09:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801e0c:	8b 10                	mov    (%eax),%edx
  801e0e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801e11:	8b 40 04             	mov    0x4(%eax),%eax
  801e14:	01 c2                	add    %eax,%edx
  801e16:	a1 68 d0 81 00       	mov    0x81d068,%eax
  801e1b:	39 c2                	cmp    %eax,%edx
  801e1d:	75 44                	jne    801e63 <free+0x38d>

			if(mergeprev){
  801e1f:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  801e23:	74 1f                	je     801e44 <free+0x36e>
				uheapPageAllocBreak = MergedBlock->startva;
  801e25:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801e28:	8b 00                	mov    (%eax),%eax
  801e2a:	a3 68 d0 81 00       	mov    %eax,0x81d068
				release_uspinlock(&ulock);
  801e2f:	83 ec 0c             	sub    $0xc,%esp
  801e32:	68 40 d1 81 00       	push   $0x81d140
  801e37:	e8 88 20 00 00       	call   803ec4 <release_uspinlock>
  801e3c:	83 c4 10             	add    $0x10,%esp
				return;
  801e3f:	e9 20 04 00 00       	jmp    802264 <free+0x78e>

			}else{
				uheapPageAllocBreak = newfree->startva;
  801e44:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801e47:	8b 00                	mov    (%eax),%eax
  801e49:	a3 68 d0 81 00       	mov    %eax,0x81d068
				release_uspinlock(&ulock);
  801e4e:	83 ec 0c             	sub    $0xc,%esp
  801e51:	68 40 d1 81 00       	push   $0x81d140
  801e56:	e8 69 20 00 00       	call   803ec4 <release_uspinlock>
  801e5b:	83 c4 10             	add    $0x10,%esp
				return;
  801e5e:	e9 01 04 00 00       	jmp    802264 <free+0x78e>

		}


		//check if block is merged with prev ,and find possible merge with next
		ToBeMerged = LIST_FIRST(&u_freelist);
  801e63:	a1 20 d1 81 00       	mov    0x81d120,%eax
  801e68:	89 45 ec             	mov    %eax,-0x14(%ebp)
		while(ToBeMerged != NULL){
  801e6b:	e9 7d 01 00 00       	jmp    801fed <free+0x517>
			if ((newfree->startva + newfree->size) == ToBeMerged->startva ){
  801e70:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801e73:	8b 10                	mov    (%eax),%edx
  801e75:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801e78:	8b 40 04             	mov    0x4(%eax),%eax
  801e7b:	01 c2                	add    %eax,%edx
  801e7d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801e80:	8b 00                	mov    (%eax),%eax
  801e82:	39 c2                	cmp    %eax,%edx
  801e84:	0f 85 5a 01 00 00    	jne    801fe4 <free+0x50e>
				if (mergeprev){
  801e8a:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  801e8e:	0f 84 a1 00 00 00    	je     801f35 <free+0x45f>
					MergedBlock->size += ToBeMerged->size;
  801e94:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801e97:	8b 50 04             	mov    0x4(%eax),%edx
  801e9a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801e9d:	8b 40 04             	mov    0x4(%eax),%eax
  801ea0:	01 c2                	add    %eax,%edx
  801ea2:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801ea5:	89 50 04             	mov    %edx,0x4(%eax)
					LIST_REMOVE(&u_freelist, ToBeMerged);
  801ea8:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801eac:	75 17                	jne    801ec5 <free+0x3ef>
  801eae:	83 ec 04             	sub    $0x4,%esp
  801eb1:	68 fb 48 80 00       	push   $0x8048fb
  801eb6:	68 0a 01 00 00       	push   $0x10a
  801ebb:	68 8c 48 80 00       	push   $0x80488c
  801ec0:	e8 2c e4 ff ff       	call   8002f1 <_panic>
  801ec5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801ec8:	8b 40 08             	mov    0x8(%eax),%eax
  801ecb:	85 c0                	test   %eax,%eax
  801ecd:	74 11                	je     801ee0 <free+0x40a>
  801ecf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801ed2:	8b 40 08             	mov    0x8(%eax),%eax
  801ed5:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801ed8:	8b 52 0c             	mov    0xc(%edx),%edx
  801edb:	89 50 0c             	mov    %edx,0xc(%eax)
  801ede:	eb 0b                	jmp    801eeb <free+0x415>
  801ee0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801ee3:	8b 40 0c             	mov    0xc(%eax),%eax
  801ee6:	a3 24 d1 81 00       	mov    %eax,0x81d124
  801eeb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801eee:	8b 40 0c             	mov    0xc(%eax),%eax
  801ef1:	85 c0                	test   %eax,%eax
  801ef3:	74 11                	je     801f06 <free+0x430>
  801ef5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801ef8:	8b 40 0c             	mov    0xc(%eax),%eax
  801efb:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801efe:	8b 52 08             	mov    0x8(%edx),%edx
  801f01:	89 50 08             	mov    %edx,0x8(%eax)
  801f04:	eb 0b                	jmp    801f11 <free+0x43b>
  801f06:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f09:	8b 40 08             	mov    0x8(%eax),%eax
  801f0c:	a3 20 d1 81 00       	mov    %eax,0x81d120
  801f11:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f14:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  801f1b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f1e:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  801f25:	a1 2c d1 81 00       	mov    0x81d12c,%eax
  801f2a:	48                   	dec    %eax
  801f2b:	a3 2c d1 81 00       	mov    %eax,0x81d12c
					break;
  801f30:	e9 c2 00 00 00       	jmp    801ff7 <free+0x521>
		//if not merged find possible merge with next
				}else{
					MergedBlock->startva = newfree->startva;
  801f35:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801f38:	8b 10                	mov    (%eax),%edx
  801f3a:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801f3d:	89 10                	mov    %edx,(%eax)
					MergedBlock->size  = newfree->size + ToBeMerged->size;
  801f3f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801f42:	8b 50 04             	mov    0x4(%eax),%edx
  801f45:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f48:	8b 40 04             	mov    0x4(%eax),%eax
  801f4b:	01 c2                	add    %eax,%edx
  801f4d:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801f50:	89 50 04             	mov    %edx,0x4(%eax)
					LIST_REMOVE(&u_freelist, ToBeMerged);
  801f53:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801f57:	75 17                	jne    801f70 <free+0x49a>
  801f59:	83 ec 04             	sub    $0x4,%esp
  801f5c:	68 fb 48 80 00       	push   $0x8048fb
  801f61:	68 10 01 00 00       	push   $0x110
  801f66:	68 8c 48 80 00       	push   $0x80488c
  801f6b:	e8 81 e3 ff ff       	call   8002f1 <_panic>
  801f70:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f73:	8b 40 08             	mov    0x8(%eax),%eax
  801f76:	85 c0                	test   %eax,%eax
  801f78:	74 11                	je     801f8b <free+0x4b5>
  801f7a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f7d:	8b 40 08             	mov    0x8(%eax),%eax
  801f80:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801f83:	8b 52 0c             	mov    0xc(%edx),%edx
  801f86:	89 50 0c             	mov    %edx,0xc(%eax)
  801f89:	eb 0b                	jmp    801f96 <free+0x4c0>
  801f8b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f8e:	8b 40 0c             	mov    0xc(%eax),%eax
  801f91:	a3 24 d1 81 00       	mov    %eax,0x81d124
  801f96:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f99:	8b 40 0c             	mov    0xc(%eax),%eax
  801f9c:	85 c0                	test   %eax,%eax
  801f9e:	74 11                	je     801fb1 <free+0x4db>
  801fa0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801fa3:	8b 40 0c             	mov    0xc(%eax),%eax
  801fa6:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801fa9:	8b 52 08             	mov    0x8(%edx),%edx
  801fac:	89 50 08             	mov    %edx,0x8(%eax)
  801faf:	eb 0b                	jmp    801fbc <free+0x4e6>
  801fb1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801fb4:	8b 40 08             	mov    0x8(%eax),%eax
  801fb7:	a3 20 d1 81 00       	mov    %eax,0x81d120
  801fbc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801fbf:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  801fc6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801fc9:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  801fd0:	a1 2c d1 81 00       	mov    0x81d12c,%eax
  801fd5:	48                   	dec    %eax
  801fd6:	a3 2c d1 81 00       	mov    %eax,0x81d12c
					mergenext = 1;
  801fdb:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
					break;
  801fe2:	eb 13                	jmp    801ff7 <free+0x521>
				}
			}
			ToBeMerged = ToBeMerged->prev_next_info.le_next;
  801fe4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801fe7:	8b 40 08             	mov    0x8(%eax),%eax
  801fea:	89 45 ec             	mov    %eax,-0x14(%ebp)
		}


		//check if block is merged with prev ,and find possible merge with next
		ToBeMerged = LIST_FIRST(&u_freelist);
		while(ToBeMerged != NULL){
  801fed:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801ff1:	0f 85 79 fe ff ff    	jne    801e70 <free+0x39a>




			// insertion
			struct UserHeapStruct* currentfree = LIST_FIRST(&u_freelist);
  801ff7:	a1 20 d1 81 00       	mov    0x81d120,%eax
  801ffc:	89 45 e0             	mov    %eax,-0x20(%ebp)

			if(mergeprev || mergenext){
  801fff:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802003:	0f 85 ad 00 00 00    	jne    8020b6 <free+0x5e0>
  802009:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80200d:	0f 84 c3 01 00 00    	je     8021d6 <free+0x700>
				while(currentfree != NULL){
  802013:	e9 9e 00 00 00       	jmp    8020b6 <free+0x5e0>
					if(MergedBlock->size < currentfree->size){
  802018:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80201b:	8b 50 04             	mov    0x4(%eax),%edx
  80201e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802021:	8b 40 04             	mov    0x4(%eax),%eax
  802024:	39 c2                	cmp    %eax,%edx
  802026:	0f 83 81 00 00 00    	jae    8020ad <free+0x5d7>

							LIST_INSERT_BEFORE(&u_freelist,currentfree,MergedBlock);
  80202c:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802030:	74 06                	je     802038 <free+0x562>
  802032:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  802036:	75 17                	jne    80204f <free+0x579>
  802038:	83 ec 04             	sub    $0x4,%esp
  80203b:	68 1c 49 80 00       	push   $0x80491c
  802040:	68 23 01 00 00       	push   $0x123
  802045:	68 8c 48 80 00       	push   $0x80488c
  80204a:	e8 a2 e2 ff ff       	call   8002f1 <_panic>
  80204f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802052:	8b 50 0c             	mov    0xc(%eax),%edx
  802055:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802058:	89 50 0c             	mov    %edx,0xc(%eax)
  80205b:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80205e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802061:	89 50 08             	mov    %edx,0x8(%eax)
  802064:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802067:	8b 40 0c             	mov    0xc(%eax),%eax
  80206a:	85 c0                	test   %eax,%eax
  80206c:	74 0e                	je     80207c <free+0x5a6>
  80206e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802071:	8b 40 0c             	mov    0xc(%eax),%eax
  802074:	8b 55 d0             	mov    -0x30(%ebp),%edx
  802077:	89 50 08             	mov    %edx,0x8(%eax)
  80207a:	eb 08                	jmp    802084 <free+0x5ae>
  80207c:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80207f:	a3 20 d1 81 00       	mov    %eax,0x81d120
  802084:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802087:	8b 55 d0             	mov    -0x30(%ebp),%edx
  80208a:	89 50 0c             	mov    %edx,0xc(%eax)
  80208d:	a1 2c d1 81 00       	mov    0x81d12c,%eax
  802092:	40                   	inc    %eax
  802093:	a3 2c d1 81 00       	mov    %eax,0x81d12c
							release_uspinlock(&ulock);
  802098:	83 ec 0c             	sub    $0xc,%esp
  80209b:	68 40 d1 81 00       	push   $0x81d140
  8020a0:	e8 1f 1e 00 00       	call   803ec4 <release_uspinlock>
  8020a5:	83 c4 10             	add    $0x10,%esp
							return;
  8020a8:	e9 b7 01 00 00       	jmp    802264 <free+0x78e>
					}
							currentfree = currentfree->prev_next_info.le_next;
  8020ad:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8020b0:	8b 40 08             	mov    0x8(%eax),%eax
  8020b3:	89 45 e0             	mov    %eax,-0x20(%ebp)

			// insertion
			struct UserHeapStruct* currentfree = LIST_FIRST(&u_freelist);

			if(mergeprev || mergenext){
				while(currentfree != NULL){
  8020b6:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8020ba:	0f 85 58 ff ff ff    	jne    802018 <free+0x542>
							release_uspinlock(&ulock);
							return;
					}
							currentfree = currentfree->prev_next_info.le_next;
				}
				free_block(newfree);
  8020c0:	83 ec 0c             	sub    $0xc,%esp
  8020c3:	ff 75 d4             	pushl  -0x2c(%ebp)
  8020c6:	e8 d5 19 00 00       	call   803aa0 <free_block>
  8020cb:	83 c4 10             	add    $0x10,%esp
				LIST_INSERT_TAIL(&u_freelist,MergedBlock);
  8020ce:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  8020d2:	75 17                	jne    8020eb <free+0x615>
  8020d4:	83 ec 04             	sub    $0x4,%esp
  8020d7:	68 d8 48 80 00       	push   $0x8048d8
  8020dc:	68 2a 01 00 00       	push   $0x12a
  8020e1:	68 8c 48 80 00       	push   $0x80488c
  8020e6:	e8 06 e2 ff ff       	call   8002f1 <_panic>
  8020eb:	8b 15 24 d1 81 00    	mov    0x81d124,%edx
  8020f1:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8020f4:	89 50 0c             	mov    %edx,0xc(%eax)
  8020f7:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8020fa:	8b 40 0c             	mov    0xc(%eax),%eax
  8020fd:	85 c0                	test   %eax,%eax
  8020ff:	74 0d                	je     80210e <free+0x638>
  802101:	a1 24 d1 81 00       	mov    0x81d124,%eax
  802106:	8b 55 d0             	mov    -0x30(%ebp),%edx
  802109:	89 50 08             	mov    %edx,0x8(%eax)
  80210c:	eb 08                	jmp    802116 <free+0x640>
  80210e:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802111:	a3 20 d1 81 00       	mov    %eax,0x81d120
  802116:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802119:	a3 24 d1 81 00       	mov    %eax,0x81d124
  80211e:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802121:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802128:	a1 2c d1 81 00       	mov    0x81d12c,%eax
  80212d:	40                   	inc    %eax
  80212e:	a3 2c d1 81 00       	mov    %eax,0x81d12c
  802133:	e9 1b 01 00 00       	jmp    802253 <free+0x77d>

			}else{
				while(currentfree != NULL){
					if(newfree->size < currentfree->size){
  802138:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80213b:	8b 50 04             	mov    0x4(%eax),%edx
  80213e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802141:	8b 40 04             	mov    0x4(%eax),%eax
  802144:	39 c2                	cmp    %eax,%edx
  802146:	0f 83 81 00 00 00    	jae    8021cd <free+0x6f7>

							LIST_INSERT_BEFORE(&u_freelist,currentfree,newfree);
  80214c:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802150:	74 06                	je     802158 <free+0x682>
  802152:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  802156:	75 17                	jne    80216f <free+0x699>
  802158:	83 ec 04             	sub    $0x4,%esp
  80215b:	68 1c 49 80 00       	push   $0x80491c
  802160:	68 30 01 00 00       	push   $0x130
  802165:	68 8c 48 80 00       	push   $0x80488c
  80216a:	e8 82 e1 ff ff       	call   8002f1 <_panic>
  80216f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802172:	8b 50 0c             	mov    0xc(%eax),%edx
  802175:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802178:	89 50 0c             	mov    %edx,0xc(%eax)
  80217b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80217e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802181:	89 50 08             	mov    %edx,0x8(%eax)
  802184:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802187:	8b 40 0c             	mov    0xc(%eax),%eax
  80218a:	85 c0                	test   %eax,%eax
  80218c:	74 0e                	je     80219c <free+0x6c6>
  80218e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802191:	8b 40 0c             	mov    0xc(%eax),%eax
  802194:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802197:	89 50 08             	mov    %edx,0x8(%eax)
  80219a:	eb 08                	jmp    8021a4 <free+0x6ce>
  80219c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80219f:	a3 20 d1 81 00       	mov    %eax,0x81d120
  8021a4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8021a7:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8021aa:	89 50 0c             	mov    %edx,0xc(%eax)
  8021ad:	a1 2c d1 81 00       	mov    0x81d12c,%eax
  8021b2:	40                   	inc    %eax
  8021b3:	a3 2c d1 81 00       	mov    %eax,0x81d12c
							release_uspinlock(&ulock);
  8021b8:	83 ec 0c             	sub    $0xc,%esp
  8021bb:	68 40 d1 81 00       	push   $0x81d140
  8021c0:	e8 ff 1c 00 00       	call   803ec4 <release_uspinlock>
  8021c5:	83 c4 10             	add    $0x10,%esp
							return;
  8021c8:	e9 97 00 00 00       	jmp    802264 <free+0x78e>
					}
							currentfree = currentfree->prev_next_info.le_next;
  8021cd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8021d0:	8b 40 08             	mov    0x8(%eax),%eax
  8021d3:	89 45 e0             	mov    %eax,-0x20(%ebp)
				}
				free_block(newfree);
				LIST_INSERT_TAIL(&u_freelist,MergedBlock);

			}else{
				while(currentfree != NULL){
  8021d6:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8021da:	0f 85 58 ff ff ff    	jne    802138 <free+0x662>
							release_uspinlock(&ulock);
							return;
					}
							currentfree = currentfree->prev_next_info.le_next;
				}
				free_block(MergedBlock);
  8021e0:	83 ec 0c             	sub    $0xc,%esp
  8021e3:	ff 75 d0             	pushl  -0x30(%ebp)
  8021e6:	e8 b5 18 00 00       	call   803aa0 <free_block>
  8021eb:	83 c4 10             	add    $0x10,%esp
				LIST_INSERT_TAIL(&u_freelist,newfree);
  8021ee:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8021f2:	75 17                	jne    80220b <free+0x735>
  8021f4:	83 ec 04             	sub    $0x4,%esp
  8021f7:	68 d8 48 80 00       	push   $0x8048d8
  8021fc:	68 37 01 00 00       	push   $0x137
  802201:	68 8c 48 80 00       	push   $0x80488c
  802206:	e8 e6 e0 ff ff       	call   8002f1 <_panic>
  80220b:	8b 15 24 d1 81 00    	mov    0x81d124,%edx
  802211:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802214:	89 50 0c             	mov    %edx,0xc(%eax)
  802217:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80221a:	8b 40 0c             	mov    0xc(%eax),%eax
  80221d:	85 c0                	test   %eax,%eax
  80221f:	74 0d                	je     80222e <free+0x758>
  802221:	a1 24 d1 81 00       	mov    0x81d124,%eax
  802226:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802229:	89 50 08             	mov    %edx,0x8(%eax)
  80222c:	eb 08                	jmp    802236 <free+0x760>
  80222e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802231:	a3 20 d1 81 00       	mov    %eax,0x81d120
  802236:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802239:	a3 24 d1 81 00       	mov    %eax,0x81d124
  80223e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802241:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802248:	a1 2c d1 81 00       	mov    0x81d12c,%eax
  80224d:	40                   	inc    %eax
  80224e:	a3 2c d1 81 00       	mov    %eax,0x81d12c
			}
		release_uspinlock(&ulock);
  802253:	83 ec 0c             	sub    $0xc,%esp
  802256:	68 40 d1 81 00       	push   $0x81d140
  80225b:	e8 64 1c 00 00       	call   803ec4 <release_uspinlock>
  802260:	83 c4 10             	add    $0x10,%esp
		return;
  802263:	90                   	nop
}
  802264:	c9                   	leave  
  802265:	c3                   	ret    

00802266 <smalloc>:

//=================================
// [3] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  802266:	55                   	push   %ebp
  802267:	89 e5                	mov    %esp,%ebp
  802269:	83 ec 48             	sub    $0x48,%esp
  80226c:	8b 45 10             	mov    0x10(%ebp),%eax
  80226f:	88 45 c4             	mov    %al,-0x3c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  802272:	e8 2d f2 ff ff       	call   8014a4 <uheap_init>
	if (size == 0) return NULL;
  802277:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80227b:	75 0a                	jne    802287 <smalloc+0x21>
  80227d:	b8 00 00 00 00       	mov    $0x0,%eax
  802282:	e9 84 05 00 00       	jmp    80280b <smalloc+0x5a5>
	//==============================================================
	acquire_uspinlock(&ulock);
  802287:	83 ec 0c             	sub    $0xc,%esp
  80228a:	68 40 d1 81 00       	push   $0x81d140
  80228f:	e8 d8 1b 00 00       	call   803e6c <acquire_uspinlock>
  802294:	83 c4 10             	add    $0x10,%esp

	struct UserHeapStruct* allocblock = (struct UserHeapStruct*) alloc_block(sizeof(struct UserHeapStruct));
  802297:	83 ec 0c             	sub    $0xc,%esp
  80229a:	6a 10                	push   $0x10
  80229c:	e8 63 13 00 00       	call   803604 <alloc_block>
  8022a1:	83 c4 10             	add    $0x10,%esp
  8022a4:	89 45 ec             	mov    %eax,-0x14(%ebp)
	if (allocblock == NULL){
  8022a7:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8022ab:	75 0a                	jne    8022b7 <smalloc+0x51>
				return NULL;
  8022ad:	b8 00 00 00 00       	mov    $0x0,%eax
  8022b2:	e9 54 05 00 00       	jmp    80280b <smalloc+0x5a5>
	}
		size = ROUNDUP(size,PAGE_SIZE);
  8022b7:	c7 45 e8 00 10 00 00 	movl   $0x1000,-0x18(%ebp)
  8022be:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022c1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8022c4:	01 d0                	add    %edx,%eax
  8022c6:	48                   	dec    %eax
  8022c7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8022ca:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8022cd:	ba 00 00 00 00       	mov    $0x0,%edx
  8022d2:	f7 75 e8             	divl   -0x18(%ebp)
  8022d5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8022d8:	29 d0                	sub    %edx,%eax
  8022da:	89 45 0c             	mov    %eax,0xc(%ebp)
		struct UserHeapStruct* lastfreeelement = LIST_LAST(&u_freelist);
  8022dd:	a1 24 d1 81 00       	mov    0x81d124,%eax
  8022e2:	89 45 e0             	mov    %eax,-0x20(%ebp)

		if(LIST_SIZE(&u_freelist)==0 || size>lastfreeelement->size){
  8022e5:	a1 2c d1 81 00       	mov    0x81d12c,%eax
  8022ea:	85 c0                	test   %eax,%eax
  8022ec:	74 0f                	je     8022fd <smalloc+0x97>
  8022ee:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8022f1:	8b 40 04             	mov    0x4(%eax),%eax
  8022f4:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8022f7:	0f 83 25 01 00 00    	jae    802422 <smalloc+0x1bc>
				if(uheapPageAllocBreak <= USER_HEAP_MAX - size){
  8022fd:	b8 00 00 00 a0       	mov    $0xa0000000,%eax
  802302:	2b 45 0c             	sub    0xc(%ebp),%eax
  802305:	89 c2                	mov    %eax,%edx
  802307:	a1 68 d0 81 00       	mov    0x81d068,%eax
  80230c:	39 c2                	cmp    %eax,%edx
  80230e:	0f 82 f4 00 00 00    	jb     802408 <smalloc+0x1a2>
						uint32 requestedblockva = uheapPageAllocBreak;
  802314:	a1 68 d0 81 00       	mov    0x81d068,%eax
  802319:	89 45 d4             	mov    %eax,-0x2c(%ebp)
						uheapPageAllocBreak+=size;
  80231c:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  802322:	8b 45 0c             	mov    0xc(%ebp),%eax
  802325:	01 d0                	add    %edx,%eax
  802327:	a3 68 d0 81 00       	mov    %eax,0x81d068
						allocblock->startva = requestedblockva;
  80232c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80232f:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802332:	89 10                	mov    %edx,(%eax)
						allocblock->size = size;
  802334:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802337:	8b 55 0c             	mov    0xc(%ebp),%edx
  80233a:	89 50 04             	mov    %edx,0x4(%eax)

						LIST_INSERT_TAIL(&u_allocatedlist, allocblock);
  80233d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802341:	75 17                	jne    80235a <smalloc+0xf4>
  802343:	83 ec 04             	sub    $0x4,%esp
  802346:	68 d8 48 80 00       	push   $0x8048d8
  80234b:	68 57 01 00 00       	push   $0x157
  802350:	68 8c 48 80 00       	push   $0x80488c
  802355:	e8 97 df ff ff       	call   8002f1 <_panic>
  80235a:	8b 15 34 d1 81 00    	mov    0x81d134,%edx
  802360:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802363:	89 50 0c             	mov    %edx,0xc(%eax)
  802366:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802369:	8b 40 0c             	mov    0xc(%eax),%eax
  80236c:	85 c0                	test   %eax,%eax
  80236e:	74 0d                	je     80237d <smalloc+0x117>
  802370:	a1 34 d1 81 00       	mov    0x81d134,%eax
  802375:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802378:	89 50 08             	mov    %edx,0x8(%eax)
  80237b:	eb 08                	jmp    802385 <smalloc+0x11f>
  80237d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802380:	a3 30 d1 81 00       	mov    %eax,0x81d130
  802385:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802388:	a3 34 d1 81 00       	mov    %eax,0x81d134
  80238d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802390:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802397:	a1 3c d1 81 00       	mov    0x81d13c,%eax
  80239c:	40                   	inc    %eax
  80239d:	a3 3c d1 81 00       	mov    %eax,0x81d13c


						int result = sys_create_shared_object(sharedVarName ,size ,isWritable ,(void*)allocblock->startva);
  8023a2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8023a5:	8b 00                	mov    (%eax),%eax
  8023a7:	89 c2                	mov    %eax,%edx
  8023a9:	0f b6 45 c4          	movzbl -0x3c(%ebp),%eax
  8023ad:	52                   	push   %edx
  8023ae:	50                   	push   %eax
  8023af:	ff 75 0c             	pushl  0xc(%ebp)
  8023b2:	ff 75 08             	pushl  0x8(%ebp)
  8023b5:	e8 48 0c 00 00       	call   803002 <sys_create_shared_object>
  8023ba:	83 c4 10             	add    $0x10,%esp
  8023bd:	89 45 d0             	mov    %eax,-0x30(%ebp)

						if(result <0){
  8023c0:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  8023c4:	79 28                	jns    8023ee <smalloc+0x188>
							free_block(allocblock);
  8023c6:	83 ec 0c             	sub    $0xc,%esp
  8023c9:	ff 75 ec             	pushl  -0x14(%ebp)
  8023cc:	e8 cf 16 00 00       	call   803aa0 <free_block>
  8023d1:	83 c4 10             	add    $0x10,%esp
							release_uspinlock(&ulock);
  8023d4:	83 ec 0c             	sub    $0xc,%esp
  8023d7:	68 40 d1 81 00       	push   $0x81d140
  8023dc:	e8 e3 1a 00 00       	call   803ec4 <release_uspinlock>
  8023e1:	83 c4 10             	add    $0x10,%esp
							return NULL;
  8023e4:	b8 00 00 00 00       	mov    $0x0,%eax
  8023e9:	e9 1d 04 00 00       	jmp    80280b <smalloc+0x5a5>
						}
						release_uspinlock(&ulock);
  8023ee:	83 ec 0c             	sub    $0xc,%esp
  8023f1:	68 40 d1 81 00       	push   $0x81d140
  8023f6:	e8 c9 1a 00 00       	call   803ec4 <release_uspinlock>
  8023fb:	83 c4 10             	add    $0x10,%esp
						return (void*)allocblock -> startva;
  8023fe:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802401:	8b 00                	mov    (%eax),%eax
  802403:	e9 03 04 00 00       	jmp    80280b <smalloc+0x5a5>
				}else{
						release_uspinlock(&ulock);
  802408:	83 ec 0c             	sub    $0xc,%esp
  80240b:	68 40 d1 81 00       	push   $0x81d140
  802410:	e8 af 1a 00 00       	call   803ec4 <release_uspinlock>
  802415:	83 c4 10             	add    $0x10,%esp
						return NULL;
  802418:	b8 00 00 00 00       	mov    $0x0,%eax
  80241d:	e9 e9 03 00 00       	jmp    80280b <smalloc+0x5a5>
					 }
		}else{
			//custom fit
			struct UserHeapStruct* currentfreeelement = LIST_FIRST(&u_freelist);
  802422:	a1 20 d1 81 00       	mov    0x81d120,%eax
  802427:	89 45 f4             	mov    %eax,-0xc(%ebp)
			//worst fit
			while(currentfreeelement != NULL){
  80242a:	e9 af 03 00 00       	jmp    8027de <smalloc+0x578>
				if(size<currentfreeelement->size){
  80242f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802432:	8b 40 04             	mov    0x4(%eax),%eax
  802435:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802438:	0f 86 28 02 00 00    	jbe    802666 <smalloc+0x400>
					allocblock->startva = lastfreeelement->startva;
  80243e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802441:	8b 10                	mov    (%eax),%edx
  802443:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802446:	89 10                	mov    %edx,(%eax)
	                allocblock->size = size;
  802448:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80244b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80244e:	89 50 04             	mov    %edx,0x4(%eax)
	                LIST_INSERT_TAIL(&u_allocatedlist,allocblock);
  802451:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802455:	75 17                	jne    80246e <smalloc+0x208>
  802457:	83 ec 04             	sub    $0x4,%esp
  80245a:	68 d8 48 80 00       	push   $0x8048d8
  80245f:	68 6f 01 00 00       	push   $0x16f
  802464:	68 8c 48 80 00       	push   $0x80488c
  802469:	e8 83 de ff ff       	call   8002f1 <_panic>
  80246e:	8b 15 34 d1 81 00    	mov    0x81d134,%edx
  802474:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802477:	89 50 0c             	mov    %edx,0xc(%eax)
  80247a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80247d:	8b 40 0c             	mov    0xc(%eax),%eax
  802480:	85 c0                	test   %eax,%eax
  802482:	74 0d                	je     802491 <smalloc+0x22b>
  802484:	a1 34 d1 81 00       	mov    0x81d134,%eax
  802489:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80248c:	89 50 08             	mov    %edx,0x8(%eax)
  80248f:	eb 08                	jmp    802499 <smalloc+0x233>
  802491:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802494:	a3 30 d1 81 00       	mov    %eax,0x81d130
  802499:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80249c:	a3 34 d1 81 00       	mov    %eax,0x81d134
  8024a1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8024a4:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  8024ab:	a1 3c d1 81 00       	mov    0x81d13c,%eax
  8024b0:	40                   	inc    %eax
  8024b1:	a3 3c d1 81 00       	mov    %eax,0x81d13c
	                lastfreeelement->startva += size;
  8024b6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8024b9:	8b 10                	mov    (%eax),%edx
  8024bb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8024be:	01 c2                	add    %eax,%edx
  8024c0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8024c3:	89 10                	mov    %edx,(%eax)
	                lastfreeelement->size -= size;
  8024c5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8024c8:	8b 40 04             	mov    0x4(%eax),%eax
  8024cb:	2b 45 0c             	sub    0xc(%ebp),%eax
  8024ce:	89 c2                	mov    %eax,%edx
  8024d0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8024d3:	89 50 04             	mov    %edx,0x4(%eax)
	                struct UserHeapStruct* currentfree2 = LIST_FIRST(&u_freelist);
  8024d6:	a1 20 d1 81 00       	mov    0x81d120,%eax
  8024db:	89 45 f0             	mov    %eax,-0x10(%ebp)
	                //check order of last element

	                while (currentfree2 != NULL){
  8024de:	e9 13 01 00 00       	jmp    8025f6 <smalloc+0x390>
	                	if(lastfreeelement->size <currentfree2->size){
  8024e3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8024e6:	8b 50 04             	mov    0x4(%eax),%edx
  8024e9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024ec:	8b 40 04             	mov    0x4(%eax),%eax
  8024ef:	39 c2                	cmp    %eax,%edx
  8024f1:	0f 83 f6 00 00 00    	jae    8025ed <smalloc+0x387>
	                		LIST_REMOVE(&u_freelist ,lastfreeelement);
  8024f7:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8024fb:	75 17                	jne    802514 <smalloc+0x2ae>
  8024fd:	83 ec 04             	sub    $0x4,%esp
  802500:	68 fb 48 80 00       	push   $0x8048fb
  802505:	68 77 01 00 00       	push   $0x177
  80250a:	68 8c 48 80 00       	push   $0x80488c
  80250f:	e8 dd dd ff ff       	call   8002f1 <_panic>
  802514:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802517:	8b 40 08             	mov    0x8(%eax),%eax
  80251a:	85 c0                	test   %eax,%eax
  80251c:	74 11                	je     80252f <smalloc+0x2c9>
  80251e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802521:	8b 40 08             	mov    0x8(%eax),%eax
  802524:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802527:	8b 52 0c             	mov    0xc(%edx),%edx
  80252a:	89 50 0c             	mov    %edx,0xc(%eax)
  80252d:	eb 0b                	jmp    80253a <smalloc+0x2d4>
  80252f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802532:	8b 40 0c             	mov    0xc(%eax),%eax
  802535:	a3 24 d1 81 00       	mov    %eax,0x81d124
  80253a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80253d:	8b 40 0c             	mov    0xc(%eax),%eax
  802540:	85 c0                	test   %eax,%eax
  802542:	74 11                	je     802555 <smalloc+0x2ef>
  802544:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802547:	8b 40 0c             	mov    0xc(%eax),%eax
  80254a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80254d:	8b 52 08             	mov    0x8(%edx),%edx
  802550:	89 50 08             	mov    %edx,0x8(%eax)
  802553:	eb 0b                	jmp    802560 <smalloc+0x2fa>
  802555:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802558:	8b 40 08             	mov    0x8(%eax),%eax
  80255b:	a3 20 d1 81 00       	mov    %eax,0x81d120
  802560:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802563:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  80256a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80256d:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  802574:	a1 2c d1 81 00       	mov    0x81d12c,%eax
  802579:	48                   	dec    %eax
  80257a:	a3 2c d1 81 00       	mov    %eax,0x81d12c
	                		LIST_INSERT_BEFORE(&u_freelist ,currentfree2 ,lastfreeelement);
  80257f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802583:	74 06                	je     80258b <smalloc+0x325>
  802585:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802589:	75 17                	jne    8025a2 <smalloc+0x33c>
  80258b:	83 ec 04             	sub    $0x4,%esp
  80258e:	68 1c 49 80 00       	push   $0x80491c
  802593:	68 78 01 00 00       	push   $0x178
  802598:	68 8c 48 80 00       	push   $0x80488c
  80259d:	e8 4f dd ff ff       	call   8002f1 <_panic>
  8025a2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025a5:	8b 50 0c             	mov    0xc(%eax),%edx
  8025a8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8025ab:	89 50 0c             	mov    %edx,0xc(%eax)
  8025ae:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8025b1:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8025b4:	89 50 08             	mov    %edx,0x8(%eax)
  8025b7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025ba:	8b 40 0c             	mov    0xc(%eax),%eax
  8025bd:	85 c0                	test   %eax,%eax
  8025bf:	74 0e                	je     8025cf <smalloc+0x369>
  8025c1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025c4:	8b 40 0c             	mov    0xc(%eax),%eax
  8025c7:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8025ca:	89 50 08             	mov    %edx,0x8(%eax)
  8025cd:	eb 08                	jmp    8025d7 <smalloc+0x371>
  8025cf:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8025d2:	a3 20 d1 81 00       	mov    %eax,0x81d120
  8025d7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025da:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8025dd:	89 50 0c             	mov    %edx,0xc(%eax)
  8025e0:	a1 2c d1 81 00       	mov    0x81d12c,%eax
  8025e5:	40                   	inc    %eax
  8025e6:	a3 2c d1 81 00       	mov    %eax,0x81d12c
	                		break;
  8025eb:	eb 13                	jmp    802600 <smalloc+0x39a>
	                	}
	                	currentfree2 = currentfree2->prev_next_info.le_next;
  8025ed:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025f0:	8b 40 08             	mov    0x8(%eax),%eax
  8025f3:	89 45 f0             	mov    %eax,-0x10(%ebp)
	                lastfreeelement->startva += size;
	                lastfreeelement->size -= size;
	                struct UserHeapStruct* currentfree2 = LIST_FIRST(&u_freelist);
	                //check order of last element

	                while (currentfree2 != NULL){
  8025f6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8025fa:	0f 85 e3 fe ff ff    	jne    8024e3 <smalloc+0x27d>
	                	}
	                	currentfree2 = currentfree2->prev_next_info.le_next;
	                }


	                int result = sys_create_shared_object(sharedVarName ,size ,isWritable ,(void*)allocblock->startva);
  802600:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802603:	8b 00                	mov    (%eax),%eax
  802605:	89 c2                	mov    %eax,%edx
  802607:	0f b6 45 c4          	movzbl -0x3c(%ebp),%eax
  80260b:	52                   	push   %edx
  80260c:	50                   	push   %eax
  80260d:	ff 75 0c             	pushl  0xc(%ebp)
  802610:	ff 75 08             	pushl  0x8(%ebp)
  802613:	e8 ea 09 00 00       	call   803002 <sys_create_shared_object>
  802618:	83 c4 10             	add    $0x10,%esp
  80261b:	89 45 d8             	mov    %eax,-0x28(%ebp)

	                if(result <0){
  80261e:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  802622:	79 28                	jns    80264c <smalloc+0x3e6>
	                	free_block(allocblock);
  802624:	83 ec 0c             	sub    $0xc,%esp
  802627:	ff 75 ec             	pushl  -0x14(%ebp)
  80262a:	e8 71 14 00 00       	call   803aa0 <free_block>
  80262f:	83 c4 10             	add    $0x10,%esp
	                	release_uspinlock(&ulock);
  802632:	83 ec 0c             	sub    $0xc,%esp
  802635:	68 40 d1 81 00       	push   $0x81d140
  80263a:	e8 85 18 00 00       	call   803ec4 <release_uspinlock>
  80263f:	83 c4 10             	add    $0x10,%esp
	                	return NULL;
  802642:	b8 00 00 00 00       	mov    $0x0,%eax
  802647:	e9 bf 01 00 00       	jmp    80280b <smalloc+0x5a5>
	                }
	                release_uspinlock(&ulock);
  80264c:	83 ec 0c             	sub    $0xc,%esp
  80264f:	68 40 d1 81 00       	push   $0x81d140
  802654:	e8 6b 18 00 00       	call   803ec4 <release_uspinlock>
  802659:	83 c4 10             	add    $0x10,%esp
	                return (void*)allocblock->startva;
  80265c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80265f:	8b 00                	mov    (%eax),%eax
  802661:	e9 a5 01 00 00       	jmp    80280b <smalloc+0x5a5>
	                //exact fit
				}else if(size == currentfreeelement->size){
  802666:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802669:	8b 40 04             	mov    0x4(%eax),%eax
  80266c:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80266f:	0f 85 60 01 00 00    	jne    8027d5 <smalloc+0x56f>
					allocblock->startva = currentfreeelement->startva;
  802675:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802678:	8b 10                	mov    (%eax),%edx
  80267a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80267d:	89 10                	mov    %edx,(%eax)
					allocblock->size = size;
  80267f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802682:	8b 55 0c             	mov    0xc(%ebp),%edx
  802685:	89 50 04             	mov    %edx,0x4(%eax)
					LIST_INSERT_TAIL(&u_allocatedlist ,allocblock);
  802688:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80268c:	75 17                	jne    8026a5 <smalloc+0x43f>
  80268e:	83 ec 04             	sub    $0x4,%esp
  802691:	68 d8 48 80 00       	push   $0x8048d8
  802696:	68 8c 01 00 00       	push   $0x18c
  80269b:	68 8c 48 80 00       	push   $0x80488c
  8026a0:	e8 4c dc ff ff       	call   8002f1 <_panic>
  8026a5:	8b 15 34 d1 81 00    	mov    0x81d134,%edx
  8026ab:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026ae:	89 50 0c             	mov    %edx,0xc(%eax)
  8026b1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026b4:	8b 40 0c             	mov    0xc(%eax),%eax
  8026b7:	85 c0                	test   %eax,%eax
  8026b9:	74 0d                	je     8026c8 <smalloc+0x462>
  8026bb:	a1 34 d1 81 00       	mov    0x81d134,%eax
  8026c0:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8026c3:	89 50 08             	mov    %edx,0x8(%eax)
  8026c6:	eb 08                	jmp    8026d0 <smalloc+0x46a>
  8026c8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026cb:	a3 30 d1 81 00       	mov    %eax,0x81d130
  8026d0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026d3:	a3 34 d1 81 00       	mov    %eax,0x81d134
  8026d8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026db:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  8026e2:	a1 3c d1 81 00       	mov    0x81d13c,%eax
  8026e7:	40                   	inc    %eax
  8026e8:	a3 3c d1 81 00       	mov    %eax,0x81d13c
					LIST_REMOVE(&u_freelist ,currentfreeelement);
  8026ed:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026f1:	75 17                	jne    80270a <smalloc+0x4a4>
  8026f3:	83 ec 04             	sub    $0x4,%esp
  8026f6:	68 fb 48 80 00       	push   $0x8048fb
  8026fb:	68 8d 01 00 00       	push   $0x18d
  802700:	68 8c 48 80 00       	push   $0x80488c
  802705:	e8 e7 db ff ff       	call   8002f1 <_panic>
  80270a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80270d:	8b 40 08             	mov    0x8(%eax),%eax
  802710:	85 c0                	test   %eax,%eax
  802712:	74 11                	je     802725 <smalloc+0x4bf>
  802714:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802717:	8b 40 08             	mov    0x8(%eax),%eax
  80271a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80271d:	8b 52 0c             	mov    0xc(%edx),%edx
  802720:	89 50 0c             	mov    %edx,0xc(%eax)
  802723:	eb 0b                	jmp    802730 <smalloc+0x4ca>
  802725:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802728:	8b 40 0c             	mov    0xc(%eax),%eax
  80272b:	a3 24 d1 81 00       	mov    %eax,0x81d124
  802730:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802733:	8b 40 0c             	mov    0xc(%eax),%eax
  802736:	85 c0                	test   %eax,%eax
  802738:	74 11                	je     80274b <smalloc+0x4e5>
  80273a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80273d:	8b 40 0c             	mov    0xc(%eax),%eax
  802740:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802743:	8b 52 08             	mov    0x8(%edx),%edx
  802746:	89 50 08             	mov    %edx,0x8(%eax)
  802749:	eb 0b                	jmp    802756 <smalloc+0x4f0>
  80274b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80274e:	8b 40 08             	mov    0x8(%eax),%eax
  802751:	a3 20 d1 81 00       	mov    %eax,0x81d120
  802756:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802759:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802760:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802763:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  80276a:	a1 2c d1 81 00       	mov    0x81d12c,%eax
  80276f:	48                   	dec    %eax
  802770:	a3 2c d1 81 00       	mov    %eax,0x81d12c
					int result = sys_create_shared_object(sharedVarName ,size ,isWritable ,(void*)allocblock->startva);
  802775:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802778:	8b 00                	mov    (%eax),%eax
  80277a:	89 c2                	mov    %eax,%edx
  80277c:	0f b6 45 c4          	movzbl -0x3c(%ebp),%eax
  802780:	52                   	push   %edx
  802781:	50                   	push   %eax
  802782:	ff 75 0c             	pushl  0xc(%ebp)
  802785:	ff 75 08             	pushl  0x8(%ebp)
  802788:	e8 75 08 00 00       	call   803002 <sys_create_shared_object>
  80278d:	83 c4 10             	add    $0x10,%esp
  802790:	89 45 dc             	mov    %eax,-0x24(%ebp)

					if(result <0){
  802793:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802797:	79 25                	jns    8027be <smalloc+0x558>
						free_block(allocblock);
  802799:	83 ec 0c             	sub    $0xc,%esp
  80279c:	ff 75 ec             	pushl  -0x14(%ebp)
  80279f:	e8 fc 12 00 00       	call   803aa0 <free_block>
  8027a4:	83 c4 10             	add    $0x10,%esp
						release_uspinlock(&ulock);
  8027a7:	83 ec 0c             	sub    $0xc,%esp
  8027aa:	68 40 d1 81 00       	push   $0x81d140
  8027af:	e8 10 17 00 00       	call   803ec4 <release_uspinlock>
  8027b4:	83 c4 10             	add    $0x10,%esp
						return NULL;
  8027b7:	b8 00 00 00 00       	mov    $0x0,%eax
  8027bc:	eb 4d                	jmp    80280b <smalloc+0x5a5>
					}
					release_uspinlock(&ulock);
  8027be:	83 ec 0c             	sub    $0xc,%esp
  8027c1:	68 40 d1 81 00       	push   $0x81d140
  8027c6:	e8 f9 16 00 00       	call   803ec4 <release_uspinlock>
  8027cb:	83 c4 10             	add    $0x10,%esp
					return (void*)allocblock->startva;
  8027ce:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027d1:	8b 00                	mov    (%eax),%eax
  8027d3:	eb 36                	jmp    80280b <smalloc+0x5a5>
				}
				currentfreeelement = currentfreeelement->prev_next_info.le_next;
  8027d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027d8:	8b 40 08             	mov    0x8(%eax),%eax
  8027db:	89 45 f4             	mov    %eax,-0xc(%ebp)
					 }
		}else{
			//custom fit
			struct UserHeapStruct* currentfreeelement = LIST_FIRST(&u_freelist);
			//worst fit
			while(currentfreeelement != NULL){
  8027de:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027e2:	0f 85 47 fc ff ff    	jne    80242f <smalloc+0x1c9>
					return (void*)allocblock->startva;
				}
				currentfreeelement = currentfreeelement->prev_next_info.le_next;
			}
		}
		free_block(allocblock);
  8027e8:	83 ec 0c             	sub    $0xc,%esp
  8027eb:	ff 75 ec             	pushl  -0x14(%ebp)
  8027ee:	e8 ad 12 00 00       	call   803aa0 <free_block>
  8027f3:	83 c4 10             	add    $0x10,%esp
		release_uspinlock(&ulock);
  8027f6:	83 ec 0c             	sub    $0xc,%esp
  8027f9:	68 40 d1 81 00       	push   $0x81d140
  8027fe:	e8 c1 16 00 00       	call   803ec4 <release_uspinlock>
  802803:	83 c4 10             	add    $0x10,%esp
		return NULL;
  802806:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80280b:	c9                   	leave  
  80280c:	c3                   	ret    

0080280d <sget>:

//========================================
// [4] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  80280d:	55                   	push   %ebp
  80280e:	89 e5                	mov    %esp,%ebp
  802810:	83 ec 38             	sub    $0x38,%esp


	 //==============================================================
	 // DON'T CHANGE THIS CODE
	    uheap_init();
  802813:	e8 8c ec ff ff       	call   8014a4 <uheap_init>
	 //==============================================================
	 // Get size of the shared variable from kernel
	acquire_uspinlock(&ulock);
  802818:	83 ec 0c             	sub    $0xc,%esp
  80281b:	68 40 d1 81 00       	push   $0x81d140
  802820:	e8 47 16 00 00       	call   803e6c <acquire_uspinlock>
  802825:	83 c4 10             	add    $0x10,%esp


	int size = sys_size_of_shared_object(ownerEnvID ,sharedVarName);
  802828:	83 ec 08             	sub    $0x8,%esp
  80282b:	ff 75 0c             	pushl  0xc(%ebp)
  80282e:	ff 75 08             	pushl  0x8(%ebp)
  802831:	e8 f6 07 00 00       	call   80302c <sys_size_of_shared_object>
  802836:	83 c4 10             	add    $0x10,%esp
  802839:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if ( size < 0 ){
  80283c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802840:	79 1a                	jns    80285c <sget+0x4f>
			release_uspinlock(&ulock);
  802842:	83 ec 0c             	sub    $0xc,%esp
  802845:	68 40 d1 81 00       	push   $0x81d140
  80284a:	e8 75 16 00 00       	call   803ec4 <release_uspinlock>
  80284f:	83 c4 10             	add    $0x10,%esp
			return NULL;
  802852:	b8 00 00 00 00       	mov    $0x0,%eax
  802857:	e9 6e 05 00 00       	jmp    802dca <sget+0x5bd>
		}
		size = ROUNDUP(size,PAGE_SIZE);
  80285c:	c7 45 e8 00 10 00 00 	movl   $0x1000,-0x18(%ebp)
  802863:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802866:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802869:	01 d0                	add    %edx,%eax
  80286b:	48                   	dec    %eax
  80286c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80286f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802872:	ba 00 00 00 00       	mov    $0x0,%edx
  802877:	f7 75 e8             	divl   -0x18(%ebp)
  80287a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80287d:	29 d0                	sub    %edx,%eax
  80287f:	89 45 ec             	mov    %eax,-0x14(%ebp)

		struct UserHeapStruct* allocblock = (struct UserHeapStruct*) alloc_block(sizeof(struct UserHeapStruct));
  802882:	83 ec 0c             	sub    $0xc,%esp
  802885:	6a 10                	push   $0x10
  802887:	e8 78 0d 00 00       	call   803604 <alloc_block>
  80288c:	83 c4 10             	add    $0x10,%esp
  80288f:	89 45 e0             	mov    %eax,-0x20(%ebp)

		if (allocblock == NULL){
  802892:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802896:	75 0a                	jne    8028a2 <sget+0x95>
			return NULL;
  802898:	b8 00 00 00 00       	mov    $0x0,%eax
  80289d:	e9 28 05 00 00       	jmp    802dca <sget+0x5bd>
		}
		struct UserHeapStruct* lastfreeelement = LIST_LAST(&u_freelist);
  8028a2:	a1 24 d1 81 00       	mov    0x81d124,%eax
  8028a7:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if(LIST_SIZE(&u_freelist)==0 || size>lastfreeelement->size){
  8028aa:	a1 2c d1 81 00       	mov    0x81d12c,%eax
  8028af:	85 c0                	test   %eax,%eax
  8028b1:	74 11                	je     8028c4 <sget+0xb7>
  8028b3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8028b6:	8b 50 04             	mov    0x4(%eax),%edx
  8028b9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028bc:	39 c2                	cmp    %eax,%edx
  8028be:	0f 83 21 01 00 00    	jae    8029e5 <sget+0x1d8>
				if(uheapPageAllocBreak <= USER_HEAP_MAX - size){
  8028c4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028c7:	ba 00 00 00 a0       	mov    $0xa0000000,%edx
  8028cc:	29 c2                	sub    %eax,%edx
  8028ce:	a1 68 d0 81 00       	mov    0x81d068,%eax
  8028d3:	39 c2                	cmp    %eax,%edx
  8028d5:	0f 82 f0 00 00 00    	jb     8029cb <sget+0x1be>

						uint32 requestedblockva = uheapPageAllocBreak;
  8028db:	a1 68 d0 81 00       	mov    0x81d068,%eax
  8028e0:	89 45 d0             	mov    %eax,-0x30(%ebp)
						uheapPageAllocBreak+=size;
  8028e3:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  8028e9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028ec:	01 d0                	add    %edx,%eax
  8028ee:	a3 68 d0 81 00       	mov    %eax,0x81d068
						allocblock->startva = requestedblockva;
  8028f3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8028f6:	8b 55 d0             	mov    -0x30(%ebp),%edx
  8028f9:	89 10                	mov    %edx,(%eax)
						allocblock->size = size;
  8028fb:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8028fe:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802901:	89 50 04             	mov    %edx,0x4(%eax)

						LIST_INSERT_TAIL(&u_allocatedlist, allocblock);
  802904:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802908:	75 17                	jne    802921 <sget+0x114>
  80290a:	83 ec 04             	sub    $0x4,%esp
  80290d:	68 d8 48 80 00       	push   $0x8048d8
  802912:	68 c8 01 00 00       	push   $0x1c8
  802917:	68 8c 48 80 00       	push   $0x80488c
  80291c:	e8 d0 d9 ff ff       	call   8002f1 <_panic>
  802921:	8b 15 34 d1 81 00    	mov    0x81d134,%edx
  802927:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80292a:	89 50 0c             	mov    %edx,0xc(%eax)
  80292d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802930:	8b 40 0c             	mov    0xc(%eax),%eax
  802933:	85 c0                	test   %eax,%eax
  802935:	74 0d                	je     802944 <sget+0x137>
  802937:	a1 34 d1 81 00       	mov    0x81d134,%eax
  80293c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80293f:	89 50 08             	mov    %edx,0x8(%eax)
  802942:	eb 08                	jmp    80294c <sget+0x13f>
  802944:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802947:	a3 30 d1 81 00       	mov    %eax,0x81d130
  80294c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80294f:	a3 34 d1 81 00       	mov    %eax,0x81d134
  802954:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802957:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  80295e:	a1 3c d1 81 00       	mov    0x81d13c,%eax
  802963:	40                   	inc    %eax
  802964:	a3 3c d1 81 00       	mov    %eax,0x81d13c


						int result = sys_get_shared_object(ownerEnvID ,sharedVarName ,(void*)allocblock->startva);
  802969:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80296c:	8b 00                	mov    (%eax),%eax
  80296e:	83 ec 04             	sub    $0x4,%esp
  802971:	50                   	push   %eax
  802972:	ff 75 0c             	pushl  0xc(%ebp)
  802975:	ff 75 08             	pushl  0x8(%ebp)
  802978:	e8 cc 06 00 00       	call   803049 <sys_get_shared_object>
  80297d:	83 c4 10             	add    $0x10,%esp
  802980:	89 45 cc             	mov    %eax,-0x34(%ebp)

						if(result <0){
  802983:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802987:	79 28                	jns    8029b1 <sget+0x1a4>
							free_block(allocblock);
  802989:	83 ec 0c             	sub    $0xc,%esp
  80298c:	ff 75 e0             	pushl  -0x20(%ebp)
  80298f:	e8 0c 11 00 00       	call   803aa0 <free_block>
  802994:	83 c4 10             	add    $0x10,%esp
							release_uspinlock(&ulock);
  802997:	83 ec 0c             	sub    $0xc,%esp
  80299a:	68 40 d1 81 00       	push   $0x81d140
  80299f:	e8 20 15 00 00       	call   803ec4 <release_uspinlock>
  8029a4:	83 c4 10             	add    $0x10,%esp
							return NULL;
  8029a7:	b8 00 00 00 00       	mov    $0x0,%eax
  8029ac:	e9 19 04 00 00       	jmp    802dca <sget+0x5bd>
						}
						release_uspinlock(&ulock);
  8029b1:	83 ec 0c             	sub    $0xc,%esp
  8029b4:	68 40 d1 81 00       	push   $0x81d140
  8029b9:	e8 06 15 00 00       	call   803ec4 <release_uspinlock>
  8029be:	83 c4 10             	add    $0x10,%esp
						return (void*)allocblock -> startva;
  8029c1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8029c4:	8b 00                	mov    (%eax),%eax
  8029c6:	e9 ff 03 00 00       	jmp    802dca <sget+0x5bd>
				}else{
						release_uspinlock(&ulock);
  8029cb:	83 ec 0c             	sub    $0xc,%esp
  8029ce:	68 40 d1 81 00       	push   $0x81d140
  8029d3:	e8 ec 14 00 00       	call   803ec4 <release_uspinlock>
  8029d8:	83 c4 10             	add    $0x10,%esp
						return NULL;
  8029db:	b8 00 00 00 00       	mov    $0x0,%eax
  8029e0:	e9 e5 03 00 00       	jmp    802dca <sget+0x5bd>
					 }
		}else{
			//custom fit
			struct UserHeapStruct* currentfreeelement = LIST_FIRST(&u_freelist);
  8029e5:	a1 20 d1 81 00       	mov    0x81d120,%eax
  8029ea:	89 45 f4             	mov    %eax,-0xc(%ebp)
			//worst fit
			while(currentfreeelement != NULL){
  8029ed:	e9 ab 03 00 00       	jmp    802d9d <sget+0x590>
				if(size<currentfreeelement->size){
  8029f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029f5:	8b 50 04             	mov    0x4(%eax),%edx
  8029f8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029fb:	39 c2                	cmp    %eax,%edx
  8029fd:	0f 86 24 02 00 00    	jbe    802c27 <sget+0x41a>
					allocblock->startva = lastfreeelement->startva;
  802a03:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802a06:	8b 10                	mov    (%eax),%edx
  802a08:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802a0b:	89 10                	mov    %edx,(%eax)
					allocblock->size = size;
  802a0d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802a10:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802a13:	89 50 04             	mov    %edx,0x4(%eax)
					LIST_INSERT_TAIL(&u_allocatedlist,allocblock);
  802a16:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802a1a:	75 17                	jne    802a33 <sget+0x226>
  802a1c:	83 ec 04             	sub    $0x4,%esp
  802a1f:	68 d8 48 80 00       	push   $0x8048d8
  802a24:	68 e0 01 00 00       	push   $0x1e0
  802a29:	68 8c 48 80 00       	push   $0x80488c
  802a2e:	e8 be d8 ff ff       	call   8002f1 <_panic>
  802a33:	8b 15 34 d1 81 00    	mov    0x81d134,%edx
  802a39:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802a3c:	89 50 0c             	mov    %edx,0xc(%eax)
  802a3f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802a42:	8b 40 0c             	mov    0xc(%eax),%eax
  802a45:	85 c0                	test   %eax,%eax
  802a47:	74 0d                	je     802a56 <sget+0x249>
  802a49:	a1 34 d1 81 00       	mov    0x81d134,%eax
  802a4e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802a51:	89 50 08             	mov    %edx,0x8(%eax)
  802a54:	eb 08                	jmp    802a5e <sget+0x251>
  802a56:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802a59:	a3 30 d1 81 00       	mov    %eax,0x81d130
  802a5e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802a61:	a3 34 d1 81 00       	mov    %eax,0x81d134
  802a66:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802a69:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802a70:	a1 3c d1 81 00       	mov    0x81d13c,%eax
  802a75:	40                   	inc    %eax
  802a76:	a3 3c d1 81 00       	mov    %eax,0x81d13c
					lastfreeelement->startva += size;
  802a7b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802a7e:	8b 10                	mov    (%eax),%edx
  802a80:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a83:	01 c2                	add    %eax,%edx
  802a85:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802a88:	89 10                	mov    %edx,(%eax)
					lastfreeelement->size -= size;
  802a8a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802a8d:	8b 50 04             	mov    0x4(%eax),%edx
  802a90:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a93:	29 c2                	sub    %eax,%edx
  802a95:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802a98:	89 50 04             	mov    %edx,0x4(%eax)
					struct UserHeapStruct* currentfree2 = LIST_FIRST(&u_freelist);
  802a9b:	a1 20 d1 81 00       	mov    0x81d120,%eax
  802aa0:	89 45 f0             	mov    %eax,-0x10(%ebp)
					//check order of last element

					while (currentfree2 != NULL){
  802aa3:	e9 13 01 00 00       	jmp    802bbb <sget+0x3ae>
						if(lastfreeelement->size <currentfree2->size){
  802aa8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802aab:	8b 50 04             	mov    0x4(%eax),%edx
  802aae:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ab1:	8b 40 04             	mov    0x4(%eax),%eax
  802ab4:	39 c2                	cmp    %eax,%edx
  802ab6:	0f 83 f6 00 00 00    	jae    802bb2 <sget+0x3a5>
							LIST_REMOVE(&u_freelist ,lastfreeelement);
  802abc:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802ac0:	75 17                	jne    802ad9 <sget+0x2cc>
  802ac2:	83 ec 04             	sub    $0x4,%esp
  802ac5:	68 fb 48 80 00       	push   $0x8048fb
  802aca:	68 e8 01 00 00       	push   $0x1e8
  802acf:	68 8c 48 80 00       	push   $0x80488c
  802ad4:	e8 18 d8 ff ff       	call   8002f1 <_panic>
  802ad9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802adc:	8b 40 08             	mov    0x8(%eax),%eax
  802adf:	85 c0                	test   %eax,%eax
  802ae1:	74 11                	je     802af4 <sget+0x2e7>
  802ae3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802ae6:	8b 40 08             	mov    0x8(%eax),%eax
  802ae9:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802aec:	8b 52 0c             	mov    0xc(%edx),%edx
  802aef:	89 50 0c             	mov    %edx,0xc(%eax)
  802af2:	eb 0b                	jmp    802aff <sget+0x2f2>
  802af4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802af7:	8b 40 0c             	mov    0xc(%eax),%eax
  802afa:	a3 24 d1 81 00       	mov    %eax,0x81d124
  802aff:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802b02:	8b 40 0c             	mov    0xc(%eax),%eax
  802b05:	85 c0                	test   %eax,%eax
  802b07:	74 11                	je     802b1a <sget+0x30d>
  802b09:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802b0c:	8b 40 0c             	mov    0xc(%eax),%eax
  802b0f:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802b12:	8b 52 08             	mov    0x8(%edx),%edx
  802b15:	89 50 08             	mov    %edx,0x8(%eax)
  802b18:	eb 0b                	jmp    802b25 <sget+0x318>
  802b1a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802b1d:	8b 40 08             	mov    0x8(%eax),%eax
  802b20:	a3 20 d1 81 00       	mov    %eax,0x81d120
  802b25:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802b28:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802b2f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802b32:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  802b39:	a1 2c d1 81 00       	mov    0x81d12c,%eax
  802b3e:	48                   	dec    %eax
  802b3f:	a3 2c d1 81 00       	mov    %eax,0x81d12c
							LIST_INSERT_BEFORE(&u_freelist ,currentfree2 ,lastfreeelement);
  802b44:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802b48:	74 06                	je     802b50 <sget+0x343>
  802b4a:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802b4e:	75 17                	jne    802b67 <sget+0x35a>
  802b50:	83 ec 04             	sub    $0x4,%esp
  802b53:	68 1c 49 80 00       	push   $0x80491c
  802b58:	68 e9 01 00 00       	push   $0x1e9
  802b5d:	68 8c 48 80 00       	push   $0x80488c
  802b62:	e8 8a d7 ff ff       	call   8002f1 <_panic>
  802b67:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b6a:	8b 50 0c             	mov    0xc(%eax),%edx
  802b6d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802b70:	89 50 0c             	mov    %edx,0xc(%eax)
  802b73:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802b76:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802b79:	89 50 08             	mov    %edx,0x8(%eax)
  802b7c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b7f:	8b 40 0c             	mov    0xc(%eax),%eax
  802b82:	85 c0                	test   %eax,%eax
  802b84:	74 0e                	je     802b94 <sget+0x387>
  802b86:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b89:	8b 40 0c             	mov    0xc(%eax),%eax
  802b8c:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802b8f:	89 50 08             	mov    %edx,0x8(%eax)
  802b92:	eb 08                	jmp    802b9c <sget+0x38f>
  802b94:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802b97:	a3 20 d1 81 00       	mov    %eax,0x81d120
  802b9c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b9f:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802ba2:	89 50 0c             	mov    %edx,0xc(%eax)
  802ba5:	a1 2c d1 81 00       	mov    0x81d12c,%eax
  802baa:	40                   	inc    %eax
  802bab:	a3 2c d1 81 00       	mov    %eax,0x81d12c
							break;
  802bb0:	eb 13                	jmp    802bc5 <sget+0x3b8>
						}
						currentfree2 = currentfree2->prev_next_info.le_next;
  802bb2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bb5:	8b 40 08             	mov    0x8(%eax),%eax
  802bb8:	89 45 f0             	mov    %eax,-0x10(%ebp)
					lastfreeelement->startva += size;
					lastfreeelement->size -= size;
					struct UserHeapStruct* currentfree2 = LIST_FIRST(&u_freelist);
					//check order of last element

					while (currentfree2 != NULL){
  802bbb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802bbf:	0f 85 e3 fe ff ff    	jne    802aa8 <sget+0x29b>
						}
						currentfree2 = currentfree2->prev_next_info.le_next;
					}


					int result = sys_get_shared_object(ownerEnvID ,sharedVarName ,(void*)allocblock->startva);
  802bc5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802bc8:	8b 00                	mov    (%eax),%eax
  802bca:	83 ec 04             	sub    $0x4,%esp
  802bcd:	50                   	push   %eax
  802bce:	ff 75 0c             	pushl  0xc(%ebp)
  802bd1:	ff 75 08             	pushl  0x8(%ebp)
  802bd4:	e8 70 04 00 00       	call   803049 <sys_get_shared_object>
  802bd9:	83 c4 10             	add    $0x10,%esp
  802bdc:	89 45 d4             	mov    %eax,-0x2c(%ebp)

					if(result <0){
  802bdf:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  802be3:	79 28                	jns    802c0d <sget+0x400>
						free_block(allocblock);
  802be5:	83 ec 0c             	sub    $0xc,%esp
  802be8:	ff 75 e0             	pushl  -0x20(%ebp)
  802beb:	e8 b0 0e 00 00       	call   803aa0 <free_block>
  802bf0:	83 c4 10             	add    $0x10,%esp
						release_uspinlock(&ulock);
  802bf3:	83 ec 0c             	sub    $0xc,%esp
  802bf6:	68 40 d1 81 00       	push   $0x81d140
  802bfb:	e8 c4 12 00 00       	call   803ec4 <release_uspinlock>
  802c00:	83 c4 10             	add    $0x10,%esp
						return NULL;
  802c03:	b8 00 00 00 00       	mov    $0x0,%eax
  802c08:	e9 bd 01 00 00       	jmp    802dca <sget+0x5bd>
					}
					release_uspinlock(&ulock);
  802c0d:	83 ec 0c             	sub    $0xc,%esp
  802c10:	68 40 d1 81 00       	push   $0x81d140
  802c15:	e8 aa 12 00 00       	call   803ec4 <release_uspinlock>
  802c1a:	83 c4 10             	add    $0x10,%esp
					return (void*)allocblock->startva;
  802c1d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802c20:	8b 00                	mov    (%eax),%eax
  802c22:	e9 a3 01 00 00       	jmp    802dca <sget+0x5bd>
					//exact fit
				}else if(size == currentfreeelement->size){
  802c27:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c2a:	8b 50 04             	mov    0x4(%eax),%edx
  802c2d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c30:	39 c2                	cmp    %eax,%edx
  802c32:	0f 85 5c 01 00 00    	jne    802d94 <sget+0x587>

					allocblock->startva = currentfreeelement->startva;
  802c38:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c3b:	8b 10                	mov    (%eax),%edx
  802c3d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802c40:	89 10                	mov    %edx,(%eax)
					allocblock->size = size;
  802c42:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802c45:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802c48:	89 50 04             	mov    %edx,0x4(%eax)
					LIST_INSERT_TAIL(&u_allocatedlist ,allocblock);
  802c4b:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802c4f:	75 17                	jne    802c68 <sget+0x45b>
  802c51:	83 ec 04             	sub    $0x4,%esp
  802c54:	68 d8 48 80 00       	push   $0x8048d8
  802c59:	68 fe 01 00 00       	push   $0x1fe
  802c5e:	68 8c 48 80 00       	push   $0x80488c
  802c63:	e8 89 d6 ff ff       	call   8002f1 <_panic>
  802c68:	8b 15 34 d1 81 00    	mov    0x81d134,%edx
  802c6e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802c71:	89 50 0c             	mov    %edx,0xc(%eax)
  802c74:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802c77:	8b 40 0c             	mov    0xc(%eax),%eax
  802c7a:	85 c0                	test   %eax,%eax
  802c7c:	74 0d                	je     802c8b <sget+0x47e>
  802c7e:	a1 34 d1 81 00       	mov    0x81d134,%eax
  802c83:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802c86:	89 50 08             	mov    %edx,0x8(%eax)
  802c89:	eb 08                	jmp    802c93 <sget+0x486>
  802c8b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802c8e:	a3 30 d1 81 00       	mov    %eax,0x81d130
  802c93:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802c96:	a3 34 d1 81 00       	mov    %eax,0x81d134
  802c9b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802c9e:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802ca5:	a1 3c d1 81 00       	mov    0x81d13c,%eax
  802caa:	40                   	inc    %eax
  802cab:	a3 3c d1 81 00       	mov    %eax,0x81d13c
					LIST_REMOVE(&u_freelist ,currentfreeelement);
  802cb0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802cb4:	75 17                	jne    802ccd <sget+0x4c0>
  802cb6:	83 ec 04             	sub    $0x4,%esp
  802cb9:	68 fb 48 80 00       	push   $0x8048fb
  802cbe:	68 ff 01 00 00       	push   $0x1ff
  802cc3:	68 8c 48 80 00       	push   $0x80488c
  802cc8:	e8 24 d6 ff ff       	call   8002f1 <_panic>
  802ccd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cd0:	8b 40 08             	mov    0x8(%eax),%eax
  802cd3:	85 c0                	test   %eax,%eax
  802cd5:	74 11                	je     802ce8 <sget+0x4db>
  802cd7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cda:	8b 40 08             	mov    0x8(%eax),%eax
  802cdd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ce0:	8b 52 0c             	mov    0xc(%edx),%edx
  802ce3:	89 50 0c             	mov    %edx,0xc(%eax)
  802ce6:	eb 0b                	jmp    802cf3 <sget+0x4e6>
  802ce8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ceb:	8b 40 0c             	mov    0xc(%eax),%eax
  802cee:	a3 24 d1 81 00       	mov    %eax,0x81d124
  802cf3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cf6:	8b 40 0c             	mov    0xc(%eax),%eax
  802cf9:	85 c0                	test   %eax,%eax
  802cfb:	74 11                	je     802d0e <sget+0x501>
  802cfd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d00:	8b 40 0c             	mov    0xc(%eax),%eax
  802d03:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d06:	8b 52 08             	mov    0x8(%edx),%edx
  802d09:	89 50 08             	mov    %edx,0x8(%eax)
  802d0c:	eb 0b                	jmp    802d19 <sget+0x50c>
  802d0e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d11:	8b 40 08             	mov    0x8(%eax),%eax
  802d14:	a3 20 d1 81 00       	mov    %eax,0x81d120
  802d19:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d1c:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802d23:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d26:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  802d2d:	a1 2c d1 81 00       	mov    0x81d12c,%eax
  802d32:	48                   	dec    %eax
  802d33:	a3 2c d1 81 00       	mov    %eax,0x81d12c

					int result = sys_get_shared_object(ownerEnvID ,sharedVarName ,(void*)allocblock->startva);
  802d38:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802d3b:	8b 00                	mov    (%eax),%eax
  802d3d:	83 ec 04             	sub    $0x4,%esp
  802d40:	50                   	push   %eax
  802d41:	ff 75 0c             	pushl  0xc(%ebp)
  802d44:	ff 75 08             	pushl  0x8(%ebp)
  802d47:	e8 fd 02 00 00       	call   803049 <sys_get_shared_object>
  802d4c:	83 c4 10             	add    $0x10,%esp
  802d4f:	89 45 d8             	mov    %eax,-0x28(%ebp)
					if(result <0){
  802d52:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  802d56:	79 25                	jns    802d7d <sget+0x570>
						free_block(allocblock);
  802d58:	83 ec 0c             	sub    $0xc,%esp
  802d5b:	ff 75 e0             	pushl  -0x20(%ebp)
  802d5e:	e8 3d 0d 00 00       	call   803aa0 <free_block>
  802d63:	83 c4 10             	add    $0x10,%esp
						release_uspinlock(&ulock);
  802d66:	83 ec 0c             	sub    $0xc,%esp
  802d69:	68 40 d1 81 00       	push   $0x81d140
  802d6e:	e8 51 11 00 00       	call   803ec4 <release_uspinlock>
  802d73:	83 c4 10             	add    $0x10,%esp
						return NULL;
  802d76:	b8 00 00 00 00       	mov    $0x0,%eax
  802d7b:	eb 4d                	jmp    802dca <sget+0x5bd>
					}

					release_uspinlock(&ulock);
  802d7d:	83 ec 0c             	sub    $0xc,%esp
  802d80:	68 40 d1 81 00       	push   $0x81d140
  802d85:	e8 3a 11 00 00       	call   803ec4 <release_uspinlock>
  802d8a:	83 c4 10             	add    $0x10,%esp
					return (void*)allocblock->startva;
  802d8d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802d90:	8b 00                	mov    (%eax),%eax
  802d92:	eb 36                	jmp    802dca <sget+0x5bd>
				}
				currentfreeelement = currentfreeelement->prev_next_info.le_next;
  802d94:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d97:	8b 40 08             	mov    0x8(%eax),%eax
  802d9a:	89 45 f4             	mov    %eax,-0xc(%ebp)
					 }
		}else{
			//custom fit
			struct UserHeapStruct* currentfreeelement = LIST_FIRST(&u_freelist);
			//worst fit
			while(currentfreeelement != NULL){
  802d9d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802da1:	0f 85 4b fc ff ff    	jne    8029f2 <sget+0x1e5>
					return (void*)allocblock->startva;
				}
				currentfreeelement = currentfreeelement->prev_next_info.le_next;
			}
		}
		free_block(allocblock);
  802da7:	83 ec 0c             	sub    $0xc,%esp
  802daa:	ff 75 e0             	pushl  -0x20(%ebp)
  802dad:	e8 ee 0c 00 00       	call   803aa0 <free_block>
  802db2:	83 c4 10             	add    $0x10,%esp
		release_uspinlock(&ulock);
  802db5:	83 ec 0c             	sub    $0xc,%esp
  802db8:	68 40 d1 81 00       	push   $0x81d140
  802dbd:	e8 02 11 00 00       	call   803ec4 <release_uspinlock>
  802dc2:	83 c4 10             	add    $0x10,%esp
		return NULL;
  802dc5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802dca:	c9                   	leave  
  802dcb:	c3                   	ret    

00802dcc <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  802dcc:	55                   	push   %ebp
  802dcd:	89 e5                	mov    %esp,%ebp
  802dcf:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  802dd2:	e8 cd e6 ff ff       	call   8014a4 <uheap_init>
	//==============================================================
	panic("realloc() is not implemented yet...!!");
  802dd7:	83 ec 04             	sub    $0x4,%esp
  802dda:	68 ac 49 80 00       	push   $0x8049ac
  802ddf:	68 2d 02 00 00       	push   $0x22d
  802de4:	68 8c 48 80 00       	push   $0x80488c
  802de9:	e8 03 d5 ff ff       	call   8002f1 <_panic>

00802dee <sfree>:
//
//	use sys_delete_shared_object(...); which switches to the kernel mode,
//	calls delete_shared_object(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the delete_shared_object() function is empty, make sure to implement it.
void sfree(void* virtual_address)
{
  802dee:	55                   	push   %ebp
  802def:	89 e5                	mov    %esp,%ebp
  802df1:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.BONUS#5] EXIT #2 - sfree
	//Your code is here
	//Comment the following line
	panic("sfree() is not implemented yet...!!");
  802df4:	83 ec 04             	sub    $0x4,%esp
  802df7:	68 d4 49 80 00       	push   $0x8049d4
  802dfc:	68 40 02 00 00       	push   $0x240
  802e01:	68 8c 48 80 00       	push   $0x80488c
  802e06:	e8 e6 d4 ff ff       	call   8002f1 <_panic>

00802e0b <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  802e0b:	55                   	push   %ebp
  802e0c:	89 e5                	mov    %esp,%ebp
  802e0e:	57                   	push   %edi
  802e0f:	56                   	push   %esi
  802e10:	53                   	push   %ebx
  802e11:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  802e14:	8b 45 08             	mov    0x8(%ebp),%eax
  802e17:	8b 55 0c             	mov    0xc(%ebp),%edx
  802e1a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802e1d:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802e20:	8b 7d 18             	mov    0x18(%ebp),%edi
  802e23:	8b 75 1c             	mov    0x1c(%ebp),%esi
  802e26:	cd 30                	int    $0x30
  802e28:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  802e2b:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  802e2e:	83 c4 10             	add    $0x10,%esp
  802e31:	5b                   	pop    %ebx
  802e32:	5e                   	pop    %esi
  802e33:	5f                   	pop    %edi
  802e34:	5d                   	pop    %ebp
  802e35:	c3                   	ret    

00802e36 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  802e36:	55                   	push   %ebp
  802e37:	89 e5                	mov    %esp,%ebp
  802e39:	83 ec 04             	sub    $0x4,%esp
  802e3c:	8b 45 10             	mov    0x10(%ebp),%eax
  802e3f:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  802e42:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802e45:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802e49:	8b 45 08             	mov    0x8(%ebp),%eax
  802e4c:	6a 00                	push   $0x0
  802e4e:	51                   	push   %ecx
  802e4f:	52                   	push   %edx
  802e50:	ff 75 0c             	pushl  0xc(%ebp)
  802e53:	50                   	push   %eax
  802e54:	6a 00                	push   $0x0
  802e56:	e8 b0 ff ff ff       	call   802e0b <syscall>
  802e5b:	83 c4 18             	add    $0x18,%esp
}
  802e5e:	90                   	nop
  802e5f:	c9                   	leave  
  802e60:	c3                   	ret    

00802e61 <sys_cgetc>:

int
sys_cgetc(void)
{
  802e61:	55                   	push   %ebp
  802e62:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  802e64:	6a 00                	push   $0x0
  802e66:	6a 00                	push   $0x0
  802e68:	6a 00                	push   $0x0
  802e6a:	6a 00                	push   $0x0
  802e6c:	6a 00                	push   $0x0
  802e6e:	6a 02                	push   $0x2
  802e70:	e8 96 ff ff ff       	call   802e0b <syscall>
  802e75:	83 c4 18             	add    $0x18,%esp
}
  802e78:	c9                   	leave  
  802e79:	c3                   	ret    

00802e7a <sys_lock_cons>:

void sys_lock_cons(void)
{
  802e7a:	55                   	push   %ebp
  802e7b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  802e7d:	6a 00                	push   $0x0
  802e7f:	6a 00                	push   $0x0
  802e81:	6a 00                	push   $0x0
  802e83:	6a 00                	push   $0x0
  802e85:	6a 00                	push   $0x0
  802e87:	6a 03                	push   $0x3
  802e89:	e8 7d ff ff ff       	call   802e0b <syscall>
  802e8e:	83 c4 18             	add    $0x18,%esp
}
  802e91:	90                   	nop
  802e92:	c9                   	leave  
  802e93:	c3                   	ret    

00802e94 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  802e94:	55                   	push   %ebp
  802e95:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  802e97:	6a 00                	push   $0x0
  802e99:	6a 00                	push   $0x0
  802e9b:	6a 00                	push   $0x0
  802e9d:	6a 00                	push   $0x0
  802e9f:	6a 00                	push   $0x0
  802ea1:	6a 04                	push   $0x4
  802ea3:	e8 63 ff ff ff       	call   802e0b <syscall>
  802ea8:	83 c4 18             	add    $0x18,%esp
}
  802eab:	90                   	nop
  802eac:	c9                   	leave  
  802ead:	c3                   	ret    

00802eae <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  802eae:	55                   	push   %ebp
  802eaf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  802eb1:	8b 55 0c             	mov    0xc(%ebp),%edx
  802eb4:	8b 45 08             	mov    0x8(%ebp),%eax
  802eb7:	6a 00                	push   $0x0
  802eb9:	6a 00                	push   $0x0
  802ebb:	6a 00                	push   $0x0
  802ebd:	52                   	push   %edx
  802ebe:	50                   	push   %eax
  802ebf:	6a 08                	push   $0x8
  802ec1:	e8 45 ff ff ff       	call   802e0b <syscall>
  802ec6:	83 c4 18             	add    $0x18,%esp
}
  802ec9:	c9                   	leave  
  802eca:	c3                   	ret    

00802ecb <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  802ecb:	55                   	push   %ebp
  802ecc:	89 e5                	mov    %esp,%ebp
  802ece:	56                   	push   %esi
  802ecf:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  802ed0:	8b 75 18             	mov    0x18(%ebp),%esi
  802ed3:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802ed6:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802ed9:	8b 55 0c             	mov    0xc(%ebp),%edx
  802edc:	8b 45 08             	mov    0x8(%ebp),%eax
  802edf:	56                   	push   %esi
  802ee0:	53                   	push   %ebx
  802ee1:	51                   	push   %ecx
  802ee2:	52                   	push   %edx
  802ee3:	50                   	push   %eax
  802ee4:	6a 09                	push   $0x9
  802ee6:	e8 20 ff ff ff       	call   802e0b <syscall>
  802eeb:	83 c4 18             	add    $0x18,%esp
}
  802eee:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802ef1:	5b                   	pop    %ebx
  802ef2:	5e                   	pop    %esi
  802ef3:	5d                   	pop    %ebp
  802ef4:	c3                   	ret    

00802ef5 <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  802ef5:	55                   	push   %ebp
  802ef6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  802ef8:	6a 00                	push   $0x0
  802efa:	6a 00                	push   $0x0
  802efc:	6a 00                	push   $0x0
  802efe:	6a 00                	push   $0x0
  802f00:	ff 75 08             	pushl  0x8(%ebp)
  802f03:	6a 0a                	push   $0xa
  802f05:	e8 01 ff ff ff       	call   802e0b <syscall>
  802f0a:	83 c4 18             	add    $0x18,%esp
}
  802f0d:	c9                   	leave  
  802f0e:	c3                   	ret    

00802f0f <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  802f0f:	55                   	push   %ebp
  802f10:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  802f12:	6a 00                	push   $0x0
  802f14:	6a 00                	push   $0x0
  802f16:	6a 00                	push   $0x0
  802f18:	ff 75 0c             	pushl  0xc(%ebp)
  802f1b:	ff 75 08             	pushl  0x8(%ebp)
  802f1e:	6a 0b                	push   $0xb
  802f20:	e8 e6 fe ff ff       	call   802e0b <syscall>
  802f25:	83 c4 18             	add    $0x18,%esp
}
  802f28:	c9                   	leave  
  802f29:	c3                   	ret    

00802f2a <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  802f2a:	55                   	push   %ebp
  802f2b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  802f2d:	6a 00                	push   $0x0
  802f2f:	6a 00                	push   $0x0
  802f31:	6a 00                	push   $0x0
  802f33:	6a 00                	push   $0x0
  802f35:	6a 00                	push   $0x0
  802f37:	6a 0c                	push   $0xc
  802f39:	e8 cd fe ff ff       	call   802e0b <syscall>
  802f3e:	83 c4 18             	add    $0x18,%esp
}
  802f41:	c9                   	leave  
  802f42:	c3                   	ret    

00802f43 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  802f43:	55                   	push   %ebp
  802f44:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  802f46:	6a 00                	push   $0x0
  802f48:	6a 00                	push   $0x0
  802f4a:	6a 00                	push   $0x0
  802f4c:	6a 00                	push   $0x0
  802f4e:	6a 00                	push   $0x0
  802f50:	6a 0d                	push   $0xd
  802f52:	e8 b4 fe ff ff       	call   802e0b <syscall>
  802f57:	83 c4 18             	add    $0x18,%esp
}
  802f5a:	c9                   	leave  
  802f5b:	c3                   	ret    

00802f5c <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  802f5c:	55                   	push   %ebp
  802f5d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  802f5f:	6a 00                	push   $0x0
  802f61:	6a 00                	push   $0x0
  802f63:	6a 00                	push   $0x0
  802f65:	6a 00                	push   $0x0
  802f67:	6a 00                	push   $0x0
  802f69:	6a 0e                	push   $0xe
  802f6b:	e8 9b fe ff ff       	call   802e0b <syscall>
  802f70:	83 c4 18             	add    $0x18,%esp
}
  802f73:	c9                   	leave  
  802f74:	c3                   	ret    

00802f75 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  802f75:	55                   	push   %ebp
  802f76:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  802f78:	6a 00                	push   $0x0
  802f7a:	6a 00                	push   $0x0
  802f7c:	6a 00                	push   $0x0
  802f7e:	6a 00                	push   $0x0
  802f80:	6a 00                	push   $0x0
  802f82:	6a 0f                	push   $0xf
  802f84:	e8 82 fe ff ff       	call   802e0b <syscall>
  802f89:	83 c4 18             	add    $0x18,%esp
}
  802f8c:	c9                   	leave  
  802f8d:	c3                   	ret    

00802f8e <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  802f8e:	55                   	push   %ebp
  802f8f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  802f91:	6a 00                	push   $0x0
  802f93:	6a 00                	push   $0x0
  802f95:	6a 00                	push   $0x0
  802f97:	6a 00                	push   $0x0
  802f99:	ff 75 08             	pushl  0x8(%ebp)
  802f9c:	6a 10                	push   $0x10
  802f9e:	e8 68 fe ff ff       	call   802e0b <syscall>
  802fa3:	83 c4 18             	add    $0x18,%esp
}
  802fa6:	c9                   	leave  
  802fa7:	c3                   	ret    

00802fa8 <sys_scarce_memory>:

void sys_scarce_memory()
{
  802fa8:	55                   	push   %ebp
  802fa9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  802fab:	6a 00                	push   $0x0
  802fad:	6a 00                	push   $0x0
  802faf:	6a 00                	push   $0x0
  802fb1:	6a 00                	push   $0x0
  802fb3:	6a 00                	push   $0x0
  802fb5:	6a 11                	push   $0x11
  802fb7:	e8 4f fe ff ff       	call   802e0b <syscall>
  802fbc:	83 c4 18             	add    $0x18,%esp
}
  802fbf:	90                   	nop
  802fc0:	c9                   	leave  
  802fc1:	c3                   	ret    

00802fc2 <sys_cputc>:

void
sys_cputc(const char c)
{
  802fc2:	55                   	push   %ebp
  802fc3:	89 e5                	mov    %esp,%ebp
  802fc5:	83 ec 04             	sub    $0x4,%esp
  802fc8:	8b 45 08             	mov    0x8(%ebp),%eax
  802fcb:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  802fce:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802fd2:	6a 00                	push   $0x0
  802fd4:	6a 00                	push   $0x0
  802fd6:	6a 00                	push   $0x0
  802fd8:	6a 00                	push   $0x0
  802fda:	50                   	push   %eax
  802fdb:	6a 01                	push   $0x1
  802fdd:	e8 29 fe ff ff       	call   802e0b <syscall>
  802fe2:	83 c4 18             	add    $0x18,%esp
}
  802fe5:	90                   	nop
  802fe6:	c9                   	leave  
  802fe7:	c3                   	ret    

00802fe8 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  802fe8:	55                   	push   %ebp
  802fe9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  802feb:	6a 00                	push   $0x0
  802fed:	6a 00                	push   $0x0
  802fef:	6a 00                	push   $0x0
  802ff1:	6a 00                	push   $0x0
  802ff3:	6a 00                	push   $0x0
  802ff5:	6a 14                	push   $0x14
  802ff7:	e8 0f fe ff ff       	call   802e0b <syscall>
  802ffc:	83 c4 18             	add    $0x18,%esp
}
  802fff:	90                   	nop
  803000:	c9                   	leave  
  803001:	c3                   	ret    

00803002 <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  803002:	55                   	push   %ebp
  803003:	89 e5                	mov    %esp,%ebp
  803005:	83 ec 04             	sub    $0x4,%esp
  803008:	8b 45 10             	mov    0x10(%ebp),%eax
  80300b:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  80300e:	8b 4d 14             	mov    0x14(%ebp),%ecx
  803011:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  803015:	8b 45 08             	mov    0x8(%ebp),%eax
  803018:	6a 00                	push   $0x0
  80301a:	51                   	push   %ecx
  80301b:	52                   	push   %edx
  80301c:	ff 75 0c             	pushl  0xc(%ebp)
  80301f:	50                   	push   %eax
  803020:	6a 15                	push   $0x15
  803022:	e8 e4 fd ff ff       	call   802e0b <syscall>
  803027:	83 c4 18             	add    $0x18,%esp
}
  80302a:	c9                   	leave  
  80302b:	c3                   	ret    

0080302c <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  80302c:	55                   	push   %ebp
  80302d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  80302f:	8b 55 0c             	mov    0xc(%ebp),%edx
  803032:	8b 45 08             	mov    0x8(%ebp),%eax
  803035:	6a 00                	push   $0x0
  803037:	6a 00                	push   $0x0
  803039:	6a 00                	push   $0x0
  80303b:	52                   	push   %edx
  80303c:	50                   	push   %eax
  80303d:	6a 16                	push   $0x16
  80303f:	e8 c7 fd ff ff       	call   802e0b <syscall>
  803044:	83 c4 18             	add    $0x18,%esp
}
  803047:	c9                   	leave  
  803048:	c3                   	ret    

00803049 <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  803049:	55                   	push   %ebp
  80304a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  80304c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80304f:	8b 55 0c             	mov    0xc(%ebp),%edx
  803052:	8b 45 08             	mov    0x8(%ebp),%eax
  803055:	6a 00                	push   $0x0
  803057:	6a 00                	push   $0x0
  803059:	51                   	push   %ecx
  80305a:	52                   	push   %edx
  80305b:	50                   	push   %eax
  80305c:	6a 17                	push   $0x17
  80305e:	e8 a8 fd ff ff       	call   802e0b <syscall>
  803063:	83 c4 18             	add    $0x18,%esp
}
  803066:	c9                   	leave  
  803067:	c3                   	ret    

00803068 <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  803068:	55                   	push   %ebp
  803069:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  80306b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80306e:	8b 45 08             	mov    0x8(%ebp),%eax
  803071:	6a 00                	push   $0x0
  803073:	6a 00                	push   $0x0
  803075:	6a 00                	push   $0x0
  803077:	52                   	push   %edx
  803078:	50                   	push   %eax
  803079:	6a 18                	push   $0x18
  80307b:	e8 8b fd ff ff       	call   802e0b <syscall>
  803080:	83 c4 18             	add    $0x18,%esp
}
  803083:	c9                   	leave  
  803084:	c3                   	ret    

00803085 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  803085:	55                   	push   %ebp
  803086:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  803088:	8b 45 08             	mov    0x8(%ebp),%eax
  80308b:	6a 00                	push   $0x0
  80308d:	ff 75 14             	pushl  0x14(%ebp)
  803090:	ff 75 10             	pushl  0x10(%ebp)
  803093:	ff 75 0c             	pushl  0xc(%ebp)
  803096:	50                   	push   %eax
  803097:	6a 19                	push   $0x19
  803099:	e8 6d fd ff ff       	call   802e0b <syscall>
  80309e:	83 c4 18             	add    $0x18,%esp
}
  8030a1:	c9                   	leave  
  8030a2:	c3                   	ret    

008030a3 <sys_run_env>:

void sys_run_env(int32 envId)
{
  8030a3:	55                   	push   %ebp
  8030a4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8030a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8030a9:	6a 00                	push   $0x0
  8030ab:	6a 00                	push   $0x0
  8030ad:	6a 00                	push   $0x0
  8030af:	6a 00                	push   $0x0
  8030b1:	50                   	push   %eax
  8030b2:	6a 1a                	push   $0x1a
  8030b4:	e8 52 fd ff ff       	call   802e0b <syscall>
  8030b9:	83 c4 18             	add    $0x18,%esp
}
  8030bc:	90                   	nop
  8030bd:	c9                   	leave  
  8030be:	c3                   	ret    

008030bf <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8030bf:	55                   	push   %ebp
  8030c0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8030c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8030c5:	6a 00                	push   $0x0
  8030c7:	6a 00                	push   $0x0
  8030c9:	6a 00                	push   $0x0
  8030cb:	6a 00                	push   $0x0
  8030cd:	50                   	push   %eax
  8030ce:	6a 1b                	push   $0x1b
  8030d0:	e8 36 fd ff ff       	call   802e0b <syscall>
  8030d5:	83 c4 18             	add    $0x18,%esp
}
  8030d8:	c9                   	leave  
  8030d9:	c3                   	ret    

008030da <sys_getenvid>:

int32 sys_getenvid(void)
{
  8030da:	55                   	push   %ebp
  8030db:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8030dd:	6a 00                	push   $0x0
  8030df:	6a 00                	push   $0x0
  8030e1:	6a 00                	push   $0x0
  8030e3:	6a 00                	push   $0x0
  8030e5:	6a 00                	push   $0x0
  8030e7:	6a 05                	push   $0x5
  8030e9:	e8 1d fd ff ff       	call   802e0b <syscall>
  8030ee:	83 c4 18             	add    $0x18,%esp
}
  8030f1:	c9                   	leave  
  8030f2:	c3                   	ret    

008030f3 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8030f3:	55                   	push   %ebp
  8030f4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8030f6:	6a 00                	push   $0x0
  8030f8:	6a 00                	push   $0x0
  8030fa:	6a 00                	push   $0x0
  8030fc:	6a 00                	push   $0x0
  8030fe:	6a 00                	push   $0x0
  803100:	6a 06                	push   $0x6
  803102:	e8 04 fd ff ff       	call   802e0b <syscall>
  803107:	83 c4 18             	add    $0x18,%esp
}
  80310a:	c9                   	leave  
  80310b:	c3                   	ret    

0080310c <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  80310c:	55                   	push   %ebp
  80310d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  80310f:	6a 00                	push   $0x0
  803111:	6a 00                	push   $0x0
  803113:	6a 00                	push   $0x0
  803115:	6a 00                	push   $0x0
  803117:	6a 00                	push   $0x0
  803119:	6a 07                	push   $0x7
  80311b:	e8 eb fc ff ff       	call   802e0b <syscall>
  803120:	83 c4 18             	add    $0x18,%esp
}
  803123:	c9                   	leave  
  803124:	c3                   	ret    

00803125 <sys_exit_env>:


void sys_exit_env(void)
{
  803125:	55                   	push   %ebp
  803126:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  803128:	6a 00                	push   $0x0
  80312a:	6a 00                	push   $0x0
  80312c:	6a 00                	push   $0x0
  80312e:	6a 00                	push   $0x0
  803130:	6a 00                	push   $0x0
  803132:	6a 1c                	push   $0x1c
  803134:	e8 d2 fc ff ff       	call   802e0b <syscall>
  803139:	83 c4 18             	add    $0x18,%esp
}
  80313c:	90                   	nop
  80313d:	c9                   	leave  
  80313e:	c3                   	ret    

0080313f <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  80313f:	55                   	push   %ebp
  803140:	89 e5                	mov    %esp,%ebp
  803142:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  803145:	8d 45 f8             	lea    -0x8(%ebp),%eax
  803148:	8d 50 04             	lea    0x4(%eax),%edx
  80314b:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80314e:	6a 00                	push   $0x0
  803150:	6a 00                	push   $0x0
  803152:	6a 00                	push   $0x0
  803154:	52                   	push   %edx
  803155:	50                   	push   %eax
  803156:	6a 1d                	push   $0x1d
  803158:	e8 ae fc ff ff       	call   802e0b <syscall>
  80315d:	83 c4 18             	add    $0x18,%esp
	return result;
  803160:	8b 4d 08             	mov    0x8(%ebp),%ecx
  803163:	8b 45 f8             	mov    -0x8(%ebp),%eax
  803166:	8b 55 fc             	mov    -0x4(%ebp),%edx
  803169:	89 01                	mov    %eax,(%ecx)
  80316b:	89 51 04             	mov    %edx,0x4(%ecx)
}
  80316e:	8b 45 08             	mov    0x8(%ebp),%eax
  803171:	c9                   	leave  
  803172:	c2 04 00             	ret    $0x4

00803175 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  803175:	55                   	push   %ebp
  803176:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  803178:	6a 00                	push   $0x0
  80317a:	6a 00                	push   $0x0
  80317c:	ff 75 10             	pushl  0x10(%ebp)
  80317f:	ff 75 0c             	pushl  0xc(%ebp)
  803182:	ff 75 08             	pushl  0x8(%ebp)
  803185:	6a 13                	push   $0x13
  803187:	e8 7f fc ff ff       	call   802e0b <syscall>
  80318c:	83 c4 18             	add    $0x18,%esp
	return ;
  80318f:	90                   	nop
}
  803190:	c9                   	leave  
  803191:	c3                   	ret    

00803192 <sys_rcr2>:
uint32 sys_rcr2()
{
  803192:	55                   	push   %ebp
  803193:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  803195:	6a 00                	push   $0x0
  803197:	6a 00                	push   $0x0
  803199:	6a 00                	push   $0x0
  80319b:	6a 00                	push   $0x0
  80319d:	6a 00                	push   $0x0
  80319f:	6a 1e                	push   $0x1e
  8031a1:	e8 65 fc ff ff       	call   802e0b <syscall>
  8031a6:	83 c4 18             	add    $0x18,%esp
}
  8031a9:	c9                   	leave  
  8031aa:	c3                   	ret    

008031ab <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  8031ab:	55                   	push   %ebp
  8031ac:	89 e5                	mov    %esp,%ebp
  8031ae:	83 ec 04             	sub    $0x4,%esp
  8031b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8031b4:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8031b7:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8031bb:	6a 00                	push   $0x0
  8031bd:	6a 00                	push   $0x0
  8031bf:	6a 00                	push   $0x0
  8031c1:	6a 00                	push   $0x0
  8031c3:	50                   	push   %eax
  8031c4:	6a 1f                	push   $0x1f
  8031c6:	e8 40 fc ff ff       	call   802e0b <syscall>
  8031cb:	83 c4 18             	add    $0x18,%esp
	return ;
  8031ce:	90                   	nop
}
  8031cf:	c9                   	leave  
  8031d0:	c3                   	ret    

008031d1 <rsttst>:
void rsttst()
{
  8031d1:	55                   	push   %ebp
  8031d2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8031d4:	6a 00                	push   $0x0
  8031d6:	6a 00                	push   $0x0
  8031d8:	6a 00                	push   $0x0
  8031da:	6a 00                	push   $0x0
  8031dc:	6a 00                	push   $0x0
  8031de:	6a 21                	push   $0x21
  8031e0:	e8 26 fc ff ff       	call   802e0b <syscall>
  8031e5:	83 c4 18             	add    $0x18,%esp
	return ;
  8031e8:	90                   	nop
}
  8031e9:	c9                   	leave  
  8031ea:	c3                   	ret    

008031eb <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8031eb:	55                   	push   %ebp
  8031ec:	89 e5                	mov    %esp,%ebp
  8031ee:	83 ec 04             	sub    $0x4,%esp
  8031f1:	8b 45 14             	mov    0x14(%ebp),%eax
  8031f4:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8031f7:	8b 55 18             	mov    0x18(%ebp),%edx
  8031fa:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8031fe:	52                   	push   %edx
  8031ff:	50                   	push   %eax
  803200:	ff 75 10             	pushl  0x10(%ebp)
  803203:	ff 75 0c             	pushl  0xc(%ebp)
  803206:	ff 75 08             	pushl  0x8(%ebp)
  803209:	6a 20                	push   $0x20
  80320b:	e8 fb fb ff ff       	call   802e0b <syscall>
  803210:	83 c4 18             	add    $0x18,%esp
	return ;
  803213:	90                   	nop
}
  803214:	c9                   	leave  
  803215:	c3                   	ret    

00803216 <chktst>:
void chktst(uint32 n)
{
  803216:	55                   	push   %ebp
  803217:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  803219:	6a 00                	push   $0x0
  80321b:	6a 00                	push   $0x0
  80321d:	6a 00                	push   $0x0
  80321f:	6a 00                	push   $0x0
  803221:	ff 75 08             	pushl  0x8(%ebp)
  803224:	6a 22                	push   $0x22
  803226:	e8 e0 fb ff ff       	call   802e0b <syscall>
  80322b:	83 c4 18             	add    $0x18,%esp
	return ;
  80322e:	90                   	nop
}
  80322f:	c9                   	leave  
  803230:	c3                   	ret    

00803231 <inctst>:

void inctst()
{
  803231:	55                   	push   %ebp
  803232:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  803234:	6a 00                	push   $0x0
  803236:	6a 00                	push   $0x0
  803238:	6a 00                	push   $0x0
  80323a:	6a 00                	push   $0x0
  80323c:	6a 00                	push   $0x0
  80323e:	6a 23                	push   $0x23
  803240:	e8 c6 fb ff ff       	call   802e0b <syscall>
  803245:	83 c4 18             	add    $0x18,%esp
	return ;
  803248:	90                   	nop
}
  803249:	c9                   	leave  
  80324a:	c3                   	ret    

0080324b <gettst>:
uint32 gettst()
{
  80324b:	55                   	push   %ebp
  80324c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  80324e:	6a 00                	push   $0x0
  803250:	6a 00                	push   $0x0
  803252:	6a 00                	push   $0x0
  803254:	6a 00                	push   $0x0
  803256:	6a 00                	push   $0x0
  803258:	6a 24                	push   $0x24
  80325a:	e8 ac fb ff ff       	call   802e0b <syscall>
  80325f:	83 c4 18             	add    $0x18,%esp
}
  803262:	c9                   	leave  
  803263:	c3                   	ret    

00803264 <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  803264:	55                   	push   %ebp
  803265:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  803267:	6a 00                	push   $0x0
  803269:	6a 00                	push   $0x0
  80326b:	6a 00                	push   $0x0
  80326d:	6a 00                	push   $0x0
  80326f:	6a 00                	push   $0x0
  803271:	6a 25                	push   $0x25
  803273:	e8 93 fb ff ff       	call   802e0b <syscall>
  803278:	83 c4 18             	add    $0x18,%esp
  80327b:	a3 60 d0 81 00       	mov    %eax,0x81d060
	return uheapPlaceStrategy ;
  803280:	a1 60 d0 81 00       	mov    0x81d060,%eax
}
  803285:	c9                   	leave  
  803286:	c3                   	ret    

00803287 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  803287:	55                   	push   %ebp
  803288:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  80328a:	8b 45 08             	mov    0x8(%ebp),%eax
  80328d:	a3 60 d0 81 00       	mov    %eax,0x81d060
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  803292:	6a 00                	push   $0x0
  803294:	6a 00                	push   $0x0
  803296:	6a 00                	push   $0x0
  803298:	6a 00                	push   $0x0
  80329a:	ff 75 08             	pushl  0x8(%ebp)
  80329d:	6a 26                	push   $0x26
  80329f:	e8 67 fb ff ff       	call   802e0b <syscall>
  8032a4:	83 c4 18             	add    $0x18,%esp
	return ;
  8032a7:	90                   	nop
}
  8032a8:	c9                   	leave  
  8032a9:	c3                   	ret    

008032aa <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  8032aa:	55                   	push   %ebp
  8032ab:	89 e5                	mov    %esp,%ebp
  8032ad:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  8032ae:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8032b1:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8032b4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8032b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8032ba:	6a 00                	push   $0x0
  8032bc:	53                   	push   %ebx
  8032bd:	51                   	push   %ecx
  8032be:	52                   	push   %edx
  8032bf:	50                   	push   %eax
  8032c0:	6a 27                	push   $0x27
  8032c2:	e8 44 fb ff ff       	call   802e0b <syscall>
  8032c7:	83 c4 18             	add    $0x18,%esp
}
  8032ca:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8032cd:	c9                   	leave  
  8032ce:	c3                   	ret    

008032cf <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  8032cf:	55                   	push   %ebp
  8032d0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  8032d2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8032d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8032d8:	6a 00                	push   $0x0
  8032da:	6a 00                	push   $0x0
  8032dc:	6a 00                	push   $0x0
  8032de:	52                   	push   %edx
  8032df:	50                   	push   %eax
  8032e0:	6a 28                	push   $0x28
  8032e2:	e8 24 fb ff ff       	call   802e0b <syscall>
  8032e7:	83 c4 18             	add    $0x18,%esp
}
  8032ea:	c9                   	leave  
  8032eb:	c3                   	ret    

008032ec <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  8032ec:	55                   	push   %ebp
  8032ed:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  8032ef:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8032f2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8032f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8032f8:	6a 00                	push   $0x0
  8032fa:	51                   	push   %ecx
  8032fb:	ff 75 10             	pushl  0x10(%ebp)
  8032fe:	52                   	push   %edx
  8032ff:	50                   	push   %eax
  803300:	6a 29                	push   $0x29
  803302:	e8 04 fb ff ff       	call   802e0b <syscall>
  803307:	83 c4 18             	add    $0x18,%esp
}
  80330a:	c9                   	leave  
  80330b:	c3                   	ret    

0080330c <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  80330c:	55                   	push   %ebp
  80330d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  80330f:	6a 00                	push   $0x0
  803311:	6a 00                	push   $0x0
  803313:	ff 75 10             	pushl  0x10(%ebp)
  803316:	ff 75 0c             	pushl  0xc(%ebp)
  803319:	ff 75 08             	pushl  0x8(%ebp)
  80331c:	6a 12                	push   $0x12
  80331e:	e8 e8 fa ff ff       	call   802e0b <syscall>
  803323:	83 c4 18             	add    $0x18,%esp
	return ;
  803326:	90                   	nop
}
  803327:	c9                   	leave  
  803328:	c3                   	ret    

00803329 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  803329:	55                   	push   %ebp
  80332a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  80332c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80332f:	8b 45 08             	mov    0x8(%ebp),%eax
  803332:	6a 00                	push   $0x0
  803334:	6a 00                	push   $0x0
  803336:	6a 00                	push   $0x0
  803338:	52                   	push   %edx
  803339:	50                   	push   %eax
  80333a:	6a 2a                	push   $0x2a
  80333c:	e8 ca fa ff ff       	call   802e0b <syscall>
  803341:	83 c4 18             	add    $0x18,%esp
	return;
  803344:	90                   	nop
}
  803345:	c9                   	leave  
  803346:	c3                   	ret    

00803347 <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  803347:	55                   	push   %ebp
  803348:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  80334a:	6a 00                	push   $0x0
  80334c:	6a 00                	push   $0x0
  80334e:	6a 00                	push   $0x0
  803350:	6a 00                	push   $0x0
  803352:	6a 00                	push   $0x0
  803354:	6a 2b                	push   $0x2b
  803356:	e8 b0 fa ff ff       	call   802e0b <syscall>
  80335b:	83 c4 18             	add    $0x18,%esp
}
  80335e:	c9                   	leave  
  80335f:	c3                   	ret    

00803360 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  803360:	55                   	push   %ebp
  803361:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  803363:	6a 00                	push   $0x0
  803365:	6a 00                	push   $0x0
  803367:	6a 00                	push   $0x0
  803369:	ff 75 0c             	pushl  0xc(%ebp)
  80336c:	ff 75 08             	pushl  0x8(%ebp)
  80336f:	6a 2d                	push   $0x2d
  803371:	e8 95 fa ff ff       	call   802e0b <syscall>
  803376:	83 c4 18             	add    $0x18,%esp
	return;
  803379:	90                   	nop
}
  80337a:	c9                   	leave  
  80337b:	c3                   	ret    

0080337c <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  80337c:	55                   	push   %ebp
  80337d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  80337f:	6a 00                	push   $0x0
  803381:	6a 00                	push   $0x0
  803383:	6a 00                	push   $0x0
  803385:	ff 75 0c             	pushl  0xc(%ebp)
  803388:	ff 75 08             	pushl  0x8(%ebp)
  80338b:	6a 2c                	push   $0x2c
  80338d:	e8 79 fa ff ff       	call   802e0b <syscall>
  803392:	83 c4 18             	add    $0x18,%esp
	return ;
  803395:	90                   	nop
}
  803396:	c9                   	leave  
  803397:	c3                   	ret    

00803398 <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  803398:	55                   	push   %ebp
  803399:	89 e5                	mov    %esp,%ebp
	//TODO: [PROJECT'25.IM#4] CPU SCHEDULING - #1 System Calls - Add suitable code here
	//Your code is here
	//Comment the following line
	//panic("sys_env_set_priority() is not implemented yet...!!");
	syscall(SYS_env_set_priority, envID, priority, 0, 0, 0);
  80339b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80339e:	8b 45 08             	mov    0x8(%ebp),%eax
  8033a1:	6a 00                	push   $0x0
  8033a3:	6a 00                	push   $0x0
  8033a5:	6a 00                	push   $0x0
  8033a7:	52                   	push   %edx
  8033a8:	50                   	push   %eax
  8033a9:	6a 2e                	push   $0x2e
  8033ab:	e8 5b fa ff ff       	call   802e0b <syscall>
  8033b0:	83 c4 18             	add    $0x18,%esp
	    return;
  8033b3:	90                   	nop
}
  8033b4:	c9                   	leave  
  8033b5:	c3                   	ret    

008033b6 <to_page_va>:
//==================================================================================//
//==================================
// [1] GET PAGE VA:
//==================================
__inline__ uint32 to_page_va(struct PageInfoElement *ptrPageInfo)
{
  8033b6:	55                   	push   %ebp
  8033b7:	89 e5                	mov    %esp,%ebp
  8033b9:	83 ec 10             	sub    $0x10,%esp
	//Get start VA of the page from the corresponding Page Info pointer
	int idxInPageInfoArr = (ptrPageInfo - pageBlockInfoArr);
  8033bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8033bf:	ba 60 50 80 00       	mov    $0x805060,%edx
  8033c4:	29 d0                	sub    %edx,%eax
  8033c6:	c1 f8 02             	sar    $0x2,%eax
  8033c9:	89 c2                	mov    %eax,%edx
  8033cb:	89 d0                	mov    %edx,%eax
  8033cd:	c1 e0 02             	shl    $0x2,%eax
  8033d0:	01 d0                	add    %edx,%eax
  8033d2:	c1 e0 02             	shl    $0x2,%eax
  8033d5:	01 d0                	add    %edx,%eax
  8033d7:	c1 e0 02             	shl    $0x2,%eax
  8033da:	01 d0                	add    %edx,%eax
  8033dc:	89 c1                	mov    %eax,%ecx
  8033de:	c1 e1 08             	shl    $0x8,%ecx
  8033e1:	01 c8                	add    %ecx,%eax
  8033e3:	89 c1                	mov    %eax,%ecx
  8033e5:	c1 e1 10             	shl    $0x10,%ecx
  8033e8:	01 c8                	add    %ecx,%eax
  8033ea:	01 c0                	add    %eax,%eax
  8033ec:	01 d0                	add    %edx,%eax
  8033ee:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return dynAllocStart + (idxInPageInfoArr << PGSHIFT);
  8033f1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8033f4:	c1 e0 0c             	shl    $0xc,%eax
  8033f7:	89 c2                	mov    %eax,%edx
  8033f9:	a1 64 d0 81 00       	mov    0x81d064,%eax
  8033fe:	01 d0                	add    %edx,%eax
}
  803400:	c9                   	leave  
  803401:	c3                   	ret    

00803402 <log2>:

//==================================================================================//
//============================ REQUIRED FUNCTIONS ==================================//
//==================================================================================//
__inline__ int log2(uint32 n)
	{
  803402:	55                   	push   %ebp
  803403:	89 e5                	mov    %esp,%ebp
  803405:	83 ec 10             	sub    $0x10,%esp
		int result = 0;
  803408:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
		while( n > 1){
  80340f:	eb 06                	jmp    803417 <log2+0x15>
			n >>=1;
  803411:	d1 6d 08             	shrl   0x8(%ebp)
			result++;
  803414:	ff 45 fc             	incl   -0x4(%ebp)
//============================ REQUIRED FUNCTIONS ==================================//
//==================================================================================//
__inline__ int log2(uint32 n)
	{
		int result = 0;
		while( n > 1){
  803417:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
  80341b:	77 f4                	ja     803411 <log2+0xf>
			n >>=1;
			result++;
		}
		return result;
  80341d:	8b 45 fc             	mov    -0x4(%ebp),%eax
	}
  803420:	c9                   	leave  
  803421:	c3                   	ret    

00803422 <initialize_dynamic_allocator>:
//==================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================
bool is_initialized = 0;
void initialize_dynamic_allocator(uint32 daStart, uint32 daEnd)
{
  803422:	55                   	push   %ebp
  803423:	89 e5                	mov    %esp,%ebp
  803425:	83 ec 18             	sub    $0x18,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(daEnd <= daStart + DYN_ALLOC_MAX_SIZE);
  803428:	8b 45 08             	mov    0x8(%ebp),%eax
  80342b:	05 00 00 00 02       	add    $0x2000000,%eax
  803430:	3b 45 0c             	cmp    0xc(%ebp),%eax
  803433:	73 16                	jae    80344b <initialize_dynamic_allocator+0x29>
  803435:	68 f8 49 80 00       	push   $0x8049f8
  80343a:	68 1e 4a 80 00       	push   $0x804a1e
  80343f:	6a 2d                	push   $0x2d
  803441:	68 33 4a 80 00       	push   $0x804a33
  803446:	e8 a6 ce ff ff       	call   8002f1 <_panic>
		is_initialized = 1;
  80344b:	c7 05 24 50 80 00 01 	movl   $0x1,0x805024
  803452:	00 00 00 
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #1 initialize_dynamic_allocator
	//Your code is here


	dynAllocStart = daStart;
  803455:	8b 45 08             	mov    0x8(%ebp),%eax
  803458:	a3 64 d0 81 00       	mov    %eax,0x81d064
	dynAllocEnd= daEnd;
  80345d:	8b 45 0c             	mov    0xc(%ebp),%eax
  803460:	a3 40 50 80 00       	mov    %eax,0x805040
	int numOfPages = (dynAllocEnd - dynAllocStart)/PAGE_SIZE;
  803465:	8b 15 40 50 80 00    	mov    0x805040,%edx
  80346b:	a1 64 d0 81 00       	mov    0x81d064,%eax
  803470:	29 c2                	sub    %eax,%edx
  803472:	89 d0                	mov    %edx,%eax
  803474:	c1 e8 0c             	shr    $0xc,%eax
  803477:	89 45 e8             	mov    %eax,-0x18(%ebp)


	for(int i=0; i< numOfPages; i++){
  80347a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  803481:	eb 2f                	jmp    8034b2 <initialize_dynamic_allocator+0x90>
	    pageBlockInfoArr[i].block_size=0;
  803483:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803486:	89 d0                	mov    %edx,%eax
  803488:	01 c0                	add    %eax,%eax
  80348a:	01 d0                	add    %edx,%eax
  80348c:	c1 e0 02             	shl    $0x2,%eax
  80348f:	05 68 50 80 00       	add    $0x805068,%eax
  803494:	66 c7 00 00 00       	movw   $0x0,(%eax)
	    pageBlockInfoArr[i].num_of_free_blocks=0;
  803499:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80349c:	89 d0                	mov    %edx,%eax
  80349e:	01 c0                	add    %eax,%eax
  8034a0:	01 d0                	add    %edx,%eax
  8034a2:	c1 e0 02             	shl    $0x2,%eax
  8034a5:	05 6a 50 80 00       	add    $0x80506a,%eax
  8034aa:	66 c7 00 00 00       	movw   $0x0,(%eax)
	dynAllocStart = daStart;
	dynAllocEnd= daEnd;
	int numOfPages = (dynAllocEnd - dynAllocStart)/PAGE_SIZE;


	for(int i=0; i< numOfPages; i++){
  8034af:	ff 45 f4             	incl   -0xc(%ebp)
  8034b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034b5:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8034b8:	7c c9                	jl     803483 <initialize_dynamic_allocator+0x61>
	    pageBlockInfoArr[i].block_size=0;
	    pageBlockInfoArr[i].num_of_free_blocks=0;
	}


	LIST_INIT(&freePagesList);
  8034ba:	c7 05 48 50 80 00 00 	movl   $0x0,0x805048
  8034c1:	00 00 00 
  8034c4:	c7 05 4c 50 80 00 00 	movl   $0x0,0x80504c
  8034cb:	00 00 00 
  8034ce:	c7 05 54 50 80 00 00 	movl   $0x0,0x805054
  8034d5:	00 00 00 
	for(int i=0; i<numOfPages; i++){
  8034d8:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8034df:	e9 9c 00 00 00       	jmp    803580 <initialize_dynamic_allocator+0x15e>
		LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
  8034e4:	8b 15 4c 50 80 00    	mov    0x80504c,%edx
  8034ea:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8034ed:	89 c8                	mov    %ecx,%eax
  8034ef:	01 c0                	add    %eax,%eax
  8034f1:	01 c8                	add    %ecx,%eax
  8034f3:	c1 e0 02             	shl    $0x2,%eax
  8034f6:	05 64 50 80 00       	add    $0x805064,%eax
  8034fb:	89 10                	mov    %edx,(%eax)
  8034fd:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803500:	89 d0                	mov    %edx,%eax
  803502:	01 c0                	add    %eax,%eax
  803504:	01 d0                	add    %edx,%eax
  803506:	c1 e0 02             	shl    $0x2,%eax
  803509:	05 64 50 80 00       	add    $0x805064,%eax
  80350e:	8b 00                	mov    (%eax),%eax
  803510:	85 c0                	test   %eax,%eax
  803512:	74 1b                	je     80352f <initialize_dynamic_allocator+0x10d>
  803514:	8b 15 4c 50 80 00    	mov    0x80504c,%edx
  80351a:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80351d:	89 c8                	mov    %ecx,%eax
  80351f:	01 c0                	add    %eax,%eax
  803521:	01 c8                	add    %ecx,%eax
  803523:	c1 e0 02             	shl    $0x2,%eax
  803526:	05 60 50 80 00       	add    $0x805060,%eax
  80352b:	89 02                	mov    %eax,(%edx)
  80352d:	eb 16                	jmp    803545 <initialize_dynamic_allocator+0x123>
  80352f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803532:	89 d0                	mov    %edx,%eax
  803534:	01 c0                	add    %eax,%eax
  803536:	01 d0                	add    %edx,%eax
  803538:	c1 e0 02             	shl    $0x2,%eax
  80353b:	05 60 50 80 00       	add    $0x805060,%eax
  803540:	a3 48 50 80 00       	mov    %eax,0x805048
  803545:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803548:	89 d0                	mov    %edx,%eax
  80354a:	01 c0                	add    %eax,%eax
  80354c:	01 d0                	add    %edx,%eax
  80354e:	c1 e0 02             	shl    $0x2,%eax
  803551:	05 60 50 80 00       	add    $0x805060,%eax
  803556:	a3 4c 50 80 00       	mov    %eax,0x80504c
  80355b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80355e:	89 d0                	mov    %edx,%eax
  803560:	01 c0                	add    %eax,%eax
  803562:	01 d0                	add    %edx,%eax
  803564:	c1 e0 02             	shl    $0x2,%eax
  803567:	05 60 50 80 00       	add    $0x805060,%eax
  80356c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803572:	a1 54 50 80 00       	mov    0x805054,%eax
  803577:	40                   	inc    %eax
  803578:	a3 54 50 80 00       	mov    %eax,0x805054
	    pageBlockInfoArr[i].num_of_free_blocks=0;
	}


	LIST_INIT(&freePagesList);
	for(int i=0; i<numOfPages; i++){
  80357d:	ff 45 f0             	incl   -0x10(%ebp)
  803580:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803583:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803586:	0f 8c 58 ff ff ff    	jl     8034e4 <initialize_dynamic_allocator+0xc2>
		LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
	}



	for (int i = 0; i < LOG2_MAX_SIZE - LOG2_MIN_SIZE + 1; i++) {
  80358c:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  803593:	eb 36                	jmp    8035cb <initialize_dynamic_allocator+0x1a9>
	    LIST_INIT(&freeBlockLists[i]);
  803595:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803598:	c1 e0 04             	shl    $0x4,%eax
  80359b:	05 80 d0 81 00       	add    $0x81d080,%eax
  8035a0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8035a6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8035a9:	c1 e0 04             	shl    $0x4,%eax
  8035ac:	05 84 d0 81 00       	add    $0x81d084,%eax
  8035b1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8035b7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8035ba:	c1 e0 04             	shl    $0x4,%eax
  8035bd:	05 8c d0 81 00       	add    $0x81d08c,%eax
  8035c2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
	}



	for (int i = 0; i < LOG2_MAX_SIZE - LOG2_MIN_SIZE + 1; i++) {
  8035c8:	ff 45 ec             	incl   -0x14(%ebp)
  8035cb:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  8035cf:	7e c4                	jle    803595 <initialize_dynamic_allocator+0x173>


	//Comment the following line
	//panic("initialize_dynamic_allocator() Not implemented yet");

}
  8035d1:	90                   	nop
  8035d2:	c9                   	leave  
  8035d3:	c3                   	ret    

008035d4 <get_block_size>:
// [2] GET BLOCK SIZE:
//===========================


__inline__ uint32 get_block_size(void *va)
{
  8035d4:	55                   	push   %ebp
  8035d5:	89 e5                	mov    %esp,%ebp
  8035d7:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #2 get_block_size
	//Your code is here

	uint32 page_index = ((uint32)va - dynAllocStart)/ PAGE_SIZE;
  8035da:	8b 55 08             	mov    0x8(%ebp),%edx
  8035dd:	a1 64 d0 81 00       	mov    0x81d064,%eax
  8035e2:	29 c2                	sub    %eax,%edx
  8035e4:	89 d0                	mov    %edx,%eax
  8035e6:	c1 e8 0c             	shr    $0xc,%eax
  8035e9:	89 45 fc             	mov    %eax,-0x4(%ebp)
    return pageBlockInfoArr[page_index].block_size;
  8035ec:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8035ef:	89 d0                	mov    %edx,%eax
  8035f1:	01 c0                	add    %eax,%eax
  8035f3:	01 d0                	add    %edx,%eax
  8035f5:	c1 e0 02             	shl    $0x2,%eax
  8035f8:	05 68 50 80 00       	add    $0x805068,%eax
  8035fd:	8b 00                	mov    (%eax),%eax
  8035ff:	0f b7 c0             	movzwl %ax,%eax
	//Comment the following line
	//panic("get_block_size() Not implemented yet");
}
  803602:	c9                   	leave  
  803603:	c3                   	ret    

00803604 <alloc_block>:

//===========================
// 3) ALLOCATE BLOCK:
//===========================
void *alloc_block(uint32 size)
{
  803604:	55                   	push   %ebp
  803605:	89 e5                	mov    %esp,%ebp
  803607:	83 ec 48             	sub    $0x48,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(size <= DYN_ALLOC_MAX_BLOCK_SIZE);
  80360a:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  803611:	76 16                	jbe    803629 <alloc_block+0x25>
  803613:	68 4c 4a 80 00       	push   $0x804a4c
  803618:	68 1e 4a 80 00       	push   $0x804a1e
  80361d:	6a 6c                	push   $0x6c
  80361f:	68 33 4a 80 00       	push   $0x804a33
  803624:	e8 c8 cc ff ff       	call   8002f1 <_panic>
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #3 alloc_block
	//Your code is here


	if(size == 0){
  803629:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80362d:	75 0a                	jne    803639 <alloc_block+0x35>
		return NULL;
  80362f:	b8 00 00 00 00       	mov    $0x0,%eax
  803634:	e9 65 04 00 00       	jmp    803a9e <alloc_block+0x49a>
	}
	else if(size<=8){
  803639:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  80363d:	77 09                	ja     803648 <alloc_block+0x44>
		size=8;
  80363f:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
  803646:	eb 1f                	jmp    803667 <alloc_block+0x63>
	}
	else{
		uint32 reqsize=8;
  803648:	c7 45 f4 08 00 00 00 	movl   $0x8,-0xc(%ebp)
		while(reqsize < size){
  80364f:	eb 08                	jmp    803659 <alloc_block+0x55>
			reqsize*=2;
  803651:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803654:	01 c0                	add    %eax,%eax
  803656:	89 45 f4             	mov    %eax,-0xc(%ebp)
	else if(size<=8){
		size=8;
	}
	else{
		uint32 reqsize=8;
		while(reqsize < size){
  803659:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80365c:	3b 45 08             	cmp    0x8(%ebp),%eax
  80365f:	72 f0                	jb     803651 <alloc_block+0x4d>
			reqsize*=2;
		}
		size= reqsize;
  803661:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803664:	89 45 08             	mov    %eax,0x8(%ebp)
	}

	int list_index = log2(size)- LOG2_MIN_SIZE;
  803667:	83 ec 0c             	sub    $0xc,%esp
  80366a:	ff 75 08             	pushl  0x8(%ebp)
  80366d:	e8 90 fd ff ff       	call   803402 <log2>
  803672:	83 c4 10             	add    $0x10,%esp
  803675:	83 e8 03             	sub    $0x3,%eax
  803678:	89 45 e8             	mov    %eax,-0x18(%ebp)

	if(!LIST_EMPTY(&freeBlockLists[list_index])){
  80367b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80367e:	c1 e0 04             	shl    $0x4,%eax
  803681:	05 80 d0 81 00       	add    $0x81d080,%eax
  803686:	8b 00                	mov    (%eax),%eax
  803688:	85 c0                	test   %eax,%eax
  80368a:	0f 84 fb 00 00 00    	je     80378b <alloc_block+0x187>
		struct BlockElement *block = LIST_FIRST(&freeBlockLists[list_index]);
  803690:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803693:	c1 e0 04             	shl    $0x4,%eax
  803696:	05 80 d0 81 00       	add    $0x81d080,%eax
  80369b:	8b 00                	mov    (%eax),%eax
  80369d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		LIST_REMOVE(&freeBlockLists[list_index], block);
  8036a0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8036a4:	75 17                	jne    8036bd <alloc_block+0xb9>
  8036a6:	83 ec 04             	sub    $0x4,%esp
  8036a9:	68 6d 4a 80 00       	push   $0x804a6d
  8036ae:	68 86 00 00 00       	push   $0x86
  8036b3:	68 33 4a 80 00       	push   $0x804a33
  8036b8:	e8 34 cc ff ff       	call   8002f1 <_panic>
  8036bd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8036c0:	8b 00                	mov    (%eax),%eax
  8036c2:	85 c0                	test   %eax,%eax
  8036c4:	74 10                	je     8036d6 <alloc_block+0xd2>
  8036c6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8036c9:	8b 00                	mov    (%eax),%eax
  8036cb:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8036ce:	8b 52 04             	mov    0x4(%edx),%edx
  8036d1:	89 50 04             	mov    %edx,0x4(%eax)
  8036d4:	eb 14                	jmp    8036ea <alloc_block+0xe6>
  8036d6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8036d9:	8b 40 04             	mov    0x4(%eax),%eax
  8036dc:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8036df:	c1 e2 04             	shl    $0x4,%edx
  8036e2:	81 c2 84 d0 81 00    	add    $0x81d084,%edx
  8036e8:	89 02                	mov    %eax,(%edx)
  8036ea:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8036ed:	8b 40 04             	mov    0x4(%eax),%eax
  8036f0:	85 c0                	test   %eax,%eax
  8036f2:	74 0f                	je     803703 <alloc_block+0xff>
  8036f4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8036f7:	8b 40 04             	mov    0x4(%eax),%eax
  8036fa:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8036fd:	8b 12                	mov    (%edx),%edx
  8036ff:	89 10                	mov    %edx,(%eax)
  803701:	eb 13                	jmp    803716 <alloc_block+0x112>
  803703:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803706:	8b 00                	mov    (%eax),%eax
  803708:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80370b:	c1 e2 04             	shl    $0x4,%edx
  80370e:	81 c2 80 d0 81 00    	add    $0x81d080,%edx
  803714:	89 02                	mov    %eax,(%edx)
  803716:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803719:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80371f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803722:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803729:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80372c:	c1 e0 04             	shl    $0x4,%eax
  80372f:	05 8c d0 81 00       	add    $0x81d08c,%eax
  803734:	8b 00                	mov    (%eax),%eax
  803736:	8d 50 ff             	lea    -0x1(%eax),%edx
  803739:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80373c:	c1 e0 04             	shl    $0x4,%eax
  80373f:	05 8c d0 81 00       	add    $0x81d08c,%eax
  803744:	89 10                	mov    %edx,(%eax)
		uint32 page_index = ((uint32)block - dynAllocStart)/ PAGE_SIZE;
  803746:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803749:	a1 64 d0 81 00       	mov    0x81d064,%eax
  80374e:	29 c2                	sub    %eax,%edx
  803750:	89 d0                	mov    %edx,%eax
  803752:	c1 e8 0c             	shr    $0xc,%eax
  803755:	89 45 e0             	mov    %eax,-0x20(%ebp)
		pageBlockInfoArr[page_index].num_of_free_blocks--;
  803758:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80375b:	89 d0                	mov    %edx,%eax
  80375d:	01 c0                	add    %eax,%eax
  80375f:	01 d0                	add    %edx,%eax
  803761:	c1 e0 02             	shl    $0x2,%eax
  803764:	05 6a 50 80 00       	add    $0x80506a,%eax
  803769:	66 8b 00             	mov    (%eax),%ax
  80376c:	8d 50 ff             	lea    -0x1(%eax),%edx
  80376f:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  803772:	89 c8                	mov    %ecx,%eax
  803774:	01 c0                	add    %eax,%eax
  803776:	01 c8                	add    %ecx,%eax
  803778:	c1 e0 02             	shl    $0x2,%eax
  80377b:	05 6a 50 80 00       	add    $0x80506a,%eax
  803780:	66 89 10             	mov    %dx,(%eax)
		return (void*)block;
  803783:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803786:	e9 13 03 00 00       	jmp    803a9e <alloc_block+0x49a>
	}

	if(!LIST_EMPTY(&freePagesList)){
  80378b:	a1 48 50 80 00       	mov    0x805048,%eax
  803790:	85 c0                	test   %eax,%eax
  803792:	0f 84 c9 01 00 00    	je     803961 <alloc_block+0x35d>

		struct PageInfoElement *page_info = LIST_FIRST(&freePagesList);
  803798:	a1 48 50 80 00       	mov    0x805048,%eax
  80379d:	89 45 dc             	mov    %eax,-0x24(%ebp)
		LIST_REMOVE(&freePagesList, page_info);
  8037a0:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8037a4:	75 17                	jne    8037bd <alloc_block+0x1b9>
  8037a6:	83 ec 04             	sub    $0x4,%esp
  8037a9:	68 6d 4a 80 00       	push   $0x804a6d
  8037ae:	68 8f 00 00 00       	push   $0x8f
  8037b3:	68 33 4a 80 00       	push   $0x804a33
  8037b8:	e8 34 cb ff ff       	call   8002f1 <_panic>
  8037bd:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8037c0:	8b 00                	mov    (%eax),%eax
  8037c2:	85 c0                	test   %eax,%eax
  8037c4:	74 10                	je     8037d6 <alloc_block+0x1d2>
  8037c6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8037c9:	8b 00                	mov    (%eax),%eax
  8037cb:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8037ce:	8b 52 04             	mov    0x4(%edx),%edx
  8037d1:	89 50 04             	mov    %edx,0x4(%eax)
  8037d4:	eb 0b                	jmp    8037e1 <alloc_block+0x1dd>
  8037d6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8037d9:	8b 40 04             	mov    0x4(%eax),%eax
  8037dc:	a3 4c 50 80 00       	mov    %eax,0x80504c
  8037e1:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8037e4:	8b 40 04             	mov    0x4(%eax),%eax
  8037e7:	85 c0                	test   %eax,%eax
  8037e9:	74 0f                	je     8037fa <alloc_block+0x1f6>
  8037eb:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8037ee:	8b 40 04             	mov    0x4(%eax),%eax
  8037f1:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8037f4:	8b 12                	mov    (%edx),%edx
  8037f6:	89 10                	mov    %edx,(%eax)
  8037f8:	eb 0a                	jmp    803804 <alloc_block+0x200>
  8037fa:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8037fd:	8b 00                	mov    (%eax),%eax
  8037ff:	a3 48 50 80 00       	mov    %eax,0x805048
  803804:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803807:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80380d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803810:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803817:	a1 54 50 80 00       	mov    0x805054,%eax
  80381c:	48                   	dec    %eax
  80381d:	a3 54 50 80 00       	mov    %eax,0x805054
		uint32 page_va = to_page_va(page_info);
  803822:	83 ec 0c             	sub    $0xc,%esp
  803825:	ff 75 dc             	pushl  -0x24(%ebp)
  803828:	e8 89 fb ff ff       	call   8033b6 <to_page_va>
  80382d:	83 c4 10             	add    $0x10,%esp
  803830:	89 45 d8             	mov    %eax,-0x28(%ebp)

		uint32 page_index = (page_va - dynAllocStart)/ PAGE_SIZE;
  803833:	a1 64 d0 81 00       	mov    0x81d064,%eax
  803838:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80383b:	29 c2                	sub    %eax,%edx
  80383d:	89 d0                	mov    %edx,%eax
  80383f:	c1 e8 0c             	shr    $0xc,%eax
  803842:	89 45 d4             	mov    %eax,-0x2c(%ebp)

		get_page((void*)page_va);
  803845:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803848:	83 ec 0c             	sub    $0xc,%esp
  80384b:	50                   	push   %eax
  80384c:	e8 fe dc ff ff       	call   80154f <get_page>
  803851:	83 c4 10             	add    $0x10,%esp


		pageBlockInfoArr[page_index].block_size = size;
  803854:	8b 45 08             	mov    0x8(%ebp),%eax
  803857:	89 c2                	mov    %eax,%edx
  803859:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  80385c:	89 c8                	mov    %ecx,%eax
  80385e:	01 c0                	add    %eax,%eax
  803860:	01 c8                	add    %ecx,%eax
  803862:	c1 e0 02             	shl    $0x2,%eax
  803865:	05 68 50 80 00       	add    $0x805068,%eax
  80386a:	66 89 10             	mov    %dx,(%eax)
		int num_blocks = PAGE_SIZE / size ;
  80386d:	b8 00 10 00 00       	mov    $0x1000,%eax
  803872:	ba 00 00 00 00       	mov    $0x0,%edx
  803877:	f7 75 08             	divl   0x8(%ebp)
  80387a:	89 45 d0             	mov    %eax,-0x30(%ebp)
		pageBlockInfoArr[page_index].num_of_free_blocks= num_blocks - 1 ;
  80387d:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803880:	8d 50 ff             	lea    -0x1(%eax),%edx
  803883:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  803886:	89 c8                	mov    %ecx,%eax
  803888:	01 c0                	add    %eax,%eax
  80388a:	01 c8                	add    %ecx,%eax
  80388c:	c1 e0 02             	shl    $0x2,%eax
  80388f:	05 6a 50 80 00       	add    $0x80506a,%eax
  803894:	66 89 10             	mov    %dx,(%eax)

		for(int i=1; i< num_blocks; i++){
  803897:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
  80389e:	e9 aa 00 00 00       	jmp    80394d <alloc_block+0x349>
			struct BlockElement *new_block = (struct BlockElement*)(page_va + i *size);
  8038a3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8038a6:	0f af 45 08          	imul   0x8(%ebp),%eax
  8038aa:	89 c2                	mov    %eax,%edx
  8038ac:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8038af:	01 d0                	add    %edx,%eax
  8038b1:	89 45 cc             	mov    %eax,-0x34(%ebp)
			LIST_INSERT_TAIL(&freeBlockLists[list_index], new_block);
  8038b4:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  8038b8:	75 17                	jne    8038d1 <alloc_block+0x2cd>
  8038ba:	83 ec 04             	sub    $0x4,%esp
  8038bd:	68 8c 4a 80 00       	push   $0x804a8c
  8038c2:	68 9d 00 00 00       	push   $0x9d
  8038c7:	68 33 4a 80 00       	push   $0x804a33
  8038cc:	e8 20 ca ff ff       	call   8002f1 <_panic>
  8038d1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8038d4:	c1 e0 04             	shl    $0x4,%eax
  8038d7:	05 84 d0 81 00       	add    $0x81d084,%eax
  8038dc:	8b 10                	mov    (%eax),%edx
  8038de:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8038e1:	89 50 04             	mov    %edx,0x4(%eax)
  8038e4:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8038e7:	8b 40 04             	mov    0x4(%eax),%eax
  8038ea:	85 c0                	test   %eax,%eax
  8038ec:	74 14                	je     803902 <alloc_block+0x2fe>
  8038ee:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8038f1:	c1 e0 04             	shl    $0x4,%eax
  8038f4:	05 84 d0 81 00       	add    $0x81d084,%eax
  8038f9:	8b 00                	mov    (%eax),%eax
  8038fb:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8038fe:	89 10                	mov    %edx,(%eax)
  803900:	eb 11                	jmp    803913 <alloc_block+0x30f>
  803902:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803905:	c1 e0 04             	shl    $0x4,%eax
  803908:	8d 90 80 d0 81 00    	lea    0x81d080(%eax),%edx
  80390e:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803911:	89 02                	mov    %eax,(%edx)
  803913:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803916:	c1 e0 04             	shl    $0x4,%eax
  803919:	8d 90 84 d0 81 00    	lea    0x81d084(%eax),%edx
  80391f:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803922:	89 02                	mov    %eax,(%edx)
  803924:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803927:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80392d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803930:	c1 e0 04             	shl    $0x4,%eax
  803933:	05 8c d0 81 00       	add    $0x81d08c,%eax
  803938:	8b 00                	mov    (%eax),%eax
  80393a:	8d 50 01             	lea    0x1(%eax),%edx
  80393d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803940:	c1 e0 04             	shl    $0x4,%eax
  803943:	05 8c d0 81 00       	add    $0x81d08c,%eax
  803948:	89 10                	mov    %edx,(%eax)

		pageBlockInfoArr[page_index].block_size = size;
		int num_blocks = PAGE_SIZE / size ;
		pageBlockInfoArr[page_index].num_of_free_blocks= num_blocks - 1 ;

		for(int i=1; i< num_blocks; i++){
  80394a:	ff 45 f0             	incl   -0x10(%ebp)
  80394d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803950:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  803953:	0f 8c 4a ff ff ff    	jl     8038a3 <alloc_block+0x29f>
			struct BlockElement *new_block = (struct BlockElement*)(page_va + i *size);
			LIST_INSERT_TAIL(&freeBlockLists[list_index], new_block);
		}
		return(void*)page_va;
  803959:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80395c:	e9 3d 01 00 00       	jmp    803a9e <alloc_block+0x49a>
	}


	for(int i =list_index+1; i<= LOG2_MAX_SIZE - LOG2_MIN_SIZE; i++){
  803961:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803964:	40                   	inc    %eax
  803965:	89 45 ec             	mov    %eax,-0x14(%ebp)
  803968:	e9 10 01 00 00       	jmp    803a7d <alloc_block+0x479>

		if(!LIST_EMPTY(&freeBlockLists[i])){
  80396d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803970:	c1 e0 04             	shl    $0x4,%eax
  803973:	05 80 d0 81 00       	add    $0x81d080,%eax
  803978:	8b 00                	mov    (%eax),%eax
  80397a:	85 c0                	test   %eax,%eax
  80397c:	0f 84 f8 00 00 00    	je     803a7a <alloc_block+0x476>

			struct BlockElement *block = LIST_FIRST(&freeBlockLists[i]);
  803982:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803985:	c1 e0 04             	shl    $0x4,%eax
  803988:	05 80 d0 81 00       	add    $0x81d080,%eax
  80398d:	8b 00                	mov    (%eax),%eax
  80398f:	89 45 c8             	mov    %eax,-0x38(%ebp)
			LIST_REMOVE( &freeBlockLists[i], block);
  803992:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  803996:	75 17                	jne    8039af <alloc_block+0x3ab>
  803998:	83 ec 04             	sub    $0x4,%esp
  80399b:	68 6d 4a 80 00       	push   $0x804a6d
  8039a0:	68 a8 00 00 00       	push   $0xa8
  8039a5:	68 33 4a 80 00       	push   $0x804a33
  8039aa:	e8 42 c9 ff ff       	call   8002f1 <_panic>
  8039af:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8039b2:	8b 00                	mov    (%eax),%eax
  8039b4:	85 c0                	test   %eax,%eax
  8039b6:	74 10                	je     8039c8 <alloc_block+0x3c4>
  8039b8:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8039bb:	8b 00                	mov    (%eax),%eax
  8039bd:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8039c0:	8b 52 04             	mov    0x4(%edx),%edx
  8039c3:	89 50 04             	mov    %edx,0x4(%eax)
  8039c6:	eb 14                	jmp    8039dc <alloc_block+0x3d8>
  8039c8:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8039cb:	8b 40 04             	mov    0x4(%eax),%eax
  8039ce:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8039d1:	c1 e2 04             	shl    $0x4,%edx
  8039d4:	81 c2 84 d0 81 00    	add    $0x81d084,%edx
  8039da:	89 02                	mov    %eax,(%edx)
  8039dc:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8039df:	8b 40 04             	mov    0x4(%eax),%eax
  8039e2:	85 c0                	test   %eax,%eax
  8039e4:	74 0f                	je     8039f5 <alloc_block+0x3f1>
  8039e6:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8039e9:	8b 40 04             	mov    0x4(%eax),%eax
  8039ec:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8039ef:	8b 12                	mov    (%edx),%edx
  8039f1:	89 10                	mov    %edx,(%eax)
  8039f3:	eb 13                	jmp    803a08 <alloc_block+0x404>
  8039f5:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8039f8:	8b 00                	mov    (%eax),%eax
  8039fa:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8039fd:	c1 e2 04             	shl    $0x4,%edx
  803a00:	81 c2 80 d0 81 00    	add    $0x81d080,%edx
  803a06:	89 02                	mov    %eax,(%edx)
  803a08:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803a0b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803a11:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803a14:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803a1b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803a1e:	c1 e0 04             	shl    $0x4,%eax
  803a21:	05 8c d0 81 00       	add    $0x81d08c,%eax
  803a26:	8b 00                	mov    (%eax),%eax
  803a28:	8d 50 ff             	lea    -0x1(%eax),%edx
  803a2b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803a2e:	c1 e0 04             	shl    $0x4,%eax
  803a31:	05 8c d0 81 00       	add    $0x81d08c,%eax
  803a36:	89 10                	mov    %edx,(%eax)

			uint32 page_index = ((uint32)block - dynAllocStart)/ PAGE_SIZE;
  803a38:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803a3b:	a1 64 d0 81 00       	mov    0x81d064,%eax
  803a40:	29 c2                	sub    %eax,%edx
  803a42:	89 d0                	mov    %edx,%eax
  803a44:	c1 e8 0c             	shr    $0xc,%eax
  803a47:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			pageBlockInfoArr[page_index].num_of_free_blocks-- ;
  803a4a:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  803a4d:	89 d0                	mov    %edx,%eax
  803a4f:	01 c0                	add    %eax,%eax
  803a51:	01 d0                	add    %edx,%eax
  803a53:	c1 e0 02             	shl    $0x2,%eax
  803a56:	05 6a 50 80 00       	add    $0x80506a,%eax
  803a5b:	66 8b 00             	mov    (%eax),%ax
  803a5e:	8d 50 ff             	lea    -0x1(%eax),%edx
  803a61:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  803a64:	89 c8                	mov    %ecx,%eax
  803a66:	01 c0                	add    %eax,%eax
  803a68:	01 c8                	add    %ecx,%eax
  803a6a:	c1 e0 02             	shl    $0x2,%eax
  803a6d:	05 6a 50 80 00       	add    $0x80506a,%eax
  803a72:	66 89 10             	mov    %dx,(%eax)

			return (void*)block;
  803a75:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803a78:	eb 24                	jmp    803a9e <alloc_block+0x49a>
		}
		return(void*)page_va;
	}


	for(int i =list_index+1; i<= LOG2_MAX_SIZE - LOG2_MIN_SIZE; i++){
  803a7a:	ff 45 ec             	incl   -0x14(%ebp)
  803a7d:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  803a81:	0f 8e e6 fe ff ff    	jle    80396d <alloc_block+0x369>

			return (void*)block;
		}
	}

	panic("alloc_block: out of memory! ");
  803a87:	83 ec 04             	sub    $0x4,%esp
  803a8a:	68 af 4a 80 00       	push   $0x804aaf
  803a8f:	68 b1 00 00 00       	push   $0xb1
  803a94:	68 33 4a 80 00       	push   $0x804a33
  803a99:	e8 53 c8 ff ff       	call   8002f1 <_panic>

	//Comment the following line
	//panic("alloc_block() Not implemented yet");

	//TODO: [PROJECT'25.BONUS#1] DYNAMIC ALLOCATOR - block if no free block
}
  803a9e:	c9                   	leave  
  803a9f:	c3                   	ret    

00803aa0 <free_block>:

//===========================
// [4] FREE BLOCK:
//===========================
void free_block(void *va)
{
  803aa0:	55                   	push   %ebp
  803aa1:	89 e5                	mov    %esp,%ebp
  803aa3:	83 ec 38             	sub    $0x38,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert((uint32)va >= dynAllocStart && (uint32)va < dynAllocEnd);
  803aa6:	8b 55 08             	mov    0x8(%ebp),%edx
  803aa9:	a1 64 d0 81 00       	mov    0x81d064,%eax
  803aae:	39 c2                	cmp    %eax,%edx
  803ab0:	72 0c                	jb     803abe <free_block+0x1e>
  803ab2:	8b 55 08             	mov    0x8(%ebp),%edx
  803ab5:	a1 40 50 80 00       	mov    0x805040,%eax
  803aba:	39 c2                	cmp    %eax,%edx
  803abc:	72 19                	jb     803ad7 <free_block+0x37>
  803abe:	68 cc 4a 80 00       	push   $0x804acc
  803ac3:	68 1e 4a 80 00       	push   $0x804a1e
  803ac8:	68 c3 00 00 00       	push   $0xc3
  803acd:	68 33 4a 80 00       	push   $0x804a33
  803ad2:	e8 1a c8 ff ff       	call   8002f1 <_panic>
	//==================================================================================

	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #4 free_block
	//Your code is here

	uint32 page_index=((uint32)va - dynAllocStart)/ PAGE_SIZE;
  803ad7:	8b 55 08             	mov    0x8(%ebp),%edx
  803ada:	a1 64 d0 81 00       	mov    0x81d064,%eax
  803adf:	29 c2                	sub    %eax,%edx
  803ae1:	89 d0                	mov    %edx,%eax
  803ae3:	c1 e8 0c             	shr    $0xc,%eax
  803ae6:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 block_size = pageBlockInfoArr[page_index].block_size;
  803ae9:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803aec:	89 d0                	mov    %edx,%eax
  803aee:	01 c0                	add    %eax,%eax
  803af0:	01 d0                	add    %edx,%eax
  803af2:	c1 e0 02             	shl    $0x2,%eax
  803af5:	05 68 50 80 00       	add    $0x805068,%eax
  803afa:	8b 00                	mov    (%eax),%eax
  803afc:	0f b7 c0             	movzwl %ax,%eax
  803aff:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if(block_size == 0){
  803b02:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803b06:	75 17                	jne    803b1f <free_block+0x7f>
		panic("page is empty(already not allocated)");
  803b08:	83 ec 04             	sub    $0x4,%esp
  803b0b:	68 04 4b 80 00       	push   $0x804b04
  803b10:	68 cf 00 00 00       	push   $0xcf
  803b15:	68 33 4a 80 00       	push   $0x804a33
  803b1a:	e8 d2 c7 ff ff       	call   8002f1 <_panic>
	}

	int list_index = log2(block_size) - LOG2_MIN_SIZE;
  803b1f:	83 ec 0c             	sub    $0xc,%esp
  803b22:	ff 75 ec             	pushl  -0x14(%ebp)
  803b25:	e8 d8 f8 ff ff       	call   803402 <log2>
  803b2a:	83 c4 10             	add    $0x10,%esp
  803b2d:	83 e8 03             	sub    $0x3,%eax
  803b30:	89 45 e8             	mov    %eax,-0x18(%ebp)
	// mn va l block "elta7weel mn virtual l phy hna"
	struct BlockElement *block = (struct BlockElement *)va;
  803b33:	8b 45 08             	mov    0x8(%ebp),%eax
  803b36:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	LIST_INSERT_TAIL(&freeBlockLists[list_index], block);
  803b39:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803b3d:	75 17                	jne    803b56 <free_block+0xb6>
  803b3f:	83 ec 04             	sub    $0x4,%esp
  803b42:	68 8c 4a 80 00       	push   $0x804a8c
  803b47:	68 d5 00 00 00       	push   $0xd5
  803b4c:	68 33 4a 80 00       	push   $0x804a33
  803b51:	e8 9b c7 ff ff       	call   8002f1 <_panic>
  803b56:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803b59:	c1 e0 04             	shl    $0x4,%eax
  803b5c:	05 84 d0 81 00       	add    $0x81d084,%eax
  803b61:	8b 10                	mov    (%eax),%edx
  803b63:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803b66:	89 50 04             	mov    %edx,0x4(%eax)
  803b69:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803b6c:	8b 40 04             	mov    0x4(%eax),%eax
  803b6f:	85 c0                	test   %eax,%eax
  803b71:	74 14                	je     803b87 <free_block+0xe7>
  803b73:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803b76:	c1 e0 04             	shl    $0x4,%eax
  803b79:	05 84 d0 81 00       	add    $0x81d084,%eax
  803b7e:	8b 00                	mov    (%eax),%eax
  803b80:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803b83:	89 10                	mov    %edx,(%eax)
  803b85:	eb 11                	jmp    803b98 <free_block+0xf8>
  803b87:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803b8a:	c1 e0 04             	shl    $0x4,%eax
  803b8d:	8d 90 80 d0 81 00    	lea    0x81d080(%eax),%edx
  803b93:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803b96:	89 02                	mov    %eax,(%edx)
  803b98:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803b9b:	c1 e0 04             	shl    $0x4,%eax
  803b9e:	8d 90 84 d0 81 00    	lea    0x81d084(%eax),%edx
  803ba4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803ba7:	89 02                	mov    %eax,(%edx)
  803ba9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803bac:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803bb2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803bb5:	c1 e0 04             	shl    $0x4,%eax
  803bb8:	05 8c d0 81 00       	add    $0x81d08c,%eax
  803bbd:	8b 00                	mov    (%eax),%eax
  803bbf:	8d 50 01             	lea    0x1(%eax),%edx
  803bc2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803bc5:	c1 e0 04             	shl    $0x4,%eax
  803bc8:	05 8c d0 81 00       	add    $0x81d08c,%eax
  803bcd:	89 10                	mov    %edx,(%eax)
	// b3d ma wdytha fy el freeBlockLists hzwed elfree elly fy el array 1
	pageBlockInfoArr[page_index].num_of_free_blocks++;
  803bcf:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803bd2:	89 d0                	mov    %edx,%eax
  803bd4:	01 c0                	add    %eax,%eax
  803bd6:	01 d0                	add    %edx,%eax
  803bd8:	c1 e0 02             	shl    $0x2,%eax
  803bdb:	05 6a 50 80 00       	add    $0x80506a,%eax
  803be0:	66 8b 00             	mov    (%eax),%ax
  803be3:	8d 50 01             	lea    0x1(%eax),%edx
  803be6:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  803be9:	89 c8                	mov    %ecx,%eax
  803beb:	01 c0                	add    %eax,%eax
  803bed:	01 c8                	add    %ecx,%eax
  803bef:	c1 e0 02             	shl    $0x2,%eax
  803bf2:	05 6a 50 80 00       	add    $0x80506a,%eax
  803bf7:	66 89 10             	mov    %dx,(%eax)
	int blocks_number = PAGE_SIZE / block_size;
  803bfa:	b8 00 10 00 00       	mov    $0x1000,%eax
  803bff:	ba 00 00 00 00       	mov    $0x0,%edx
  803c04:	f7 75 ec             	divl   -0x14(%ebp)
  803c07:	89 45 e0             	mov    %eax,-0x20(%ebp)
	if(pageBlockInfoArr[page_index].num_of_free_blocks == blocks_number){
  803c0a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803c0d:	89 d0                	mov    %edx,%eax
  803c0f:	01 c0                	add    %eax,%eax
  803c11:	01 d0                	add    %edx,%eax
  803c13:	c1 e0 02             	shl    $0x2,%eax
  803c16:	05 6a 50 80 00       	add    $0x80506a,%eax
  803c1b:	66 8b 00             	mov    (%eax),%ax
  803c1e:	0f b7 c0             	movzwl %ax,%eax
  803c21:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  803c24:	0f 85 d3 01 00 00    	jne    803dfd <free_block+0x35d>
		struct BlockElement *itr = LIST_FIRST(&freeBlockLists[list_index]);
  803c2a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803c2d:	c1 e0 04             	shl    $0x4,%eax
  803c30:	05 80 d0 81 00       	add    $0x81d080,%eax
  803c35:	8b 00                	mov    (%eax),%eax
  803c37:	89 45 f4             	mov    %eax,-0xc(%ebp)
		while(itr != NULL){
  803c3a:	e9 f1 00 00 00       	jmp    803d30 <free_block+0x290>
			//lw ms7to el pointer mydy34 ->
			struct BlockElement *next = LIST_NEXT(itr);
  803c3f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c42:	8b 00                	mov    (%eax),%eax
  803c44:	89 45 dc             	mov    %eax,-0x24(%ebp)
			uint32 page_beginning_address= dynAllocStart + page_index * PAGE_SIZE;
  803c47:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803c4a:	c1 e0 0c             	shl    $0xc,%eax
  803c4d:	89 c2                	mov    %eax,%edx
  803c4f:	a1 64 d0 81 00       	mov    0x81d064,%eax
  803c54:	01 d0                	add    %edx,%eax
  803c56:	89 45 d8             	mov    %eax,-0x28(%ebp)
			uint32 page_end_address = dynAllocStart + (page_index +1 )* PAGE_SIZE;
  803c59:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803c5c:	40                   	inc    %eax
  803c5d:	c1 e0 0c             	shl    $0xc,%eax
  803c60:	89 c2                	mov    %eax,%edx
  803c62:	a1 64 d0 81 00       	mov    0x81d064,%eax
  803c67:	01 d0                	add    %edx,%eax
  803c69:	89 45 d4             	mov    %eax,-0x2c(%ebp)

			if((uint32)itr >= page_beginning_address && (uint32)itr < page_end_address){
  803c6c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c6f:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  803c72:	0f 82 b8 00 00 00    	jb     803d30 <free_block+0x290>
  803c78:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c7b:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803c7e:	0f 83 ac 00 00 00    	jae    803d30 <free_block+0x290>
				LIST_REMOVE(&freeBlockLists[list_index], itr);
  803c84:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803c88:	75 17                	jne    803ca1 <free_block+0x201>
  803c8a:	83 ec 04             	sub    $0x4,%esp
  803c8d:	68 6d 4a 80 00       	push   $0x804a6d
  803c92:	68 e2 00 00 00       	push   $0xe2
  803c97:	68 33 4a 80 00       	push   $0x804a33
  803c9c:	e8 50 c6 ff ff       	call   8002f1 <_panic>
  803ca1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ca4:	8b 00                	mov    (%eax),%eax
  803ca6:	85 c0                	test   %eax,%eax
  803ca8:	74 10                	je     803cba <free_block+0x21a>
  803caa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803cad:	8b 00                	mov    (%eax),%eax
  803caf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803cb2:	8b 52 04             	mov    0x4(%edx),%edx
  803cb5:	89 50 04             	mov    %edx,0x4(%eax)
  803cb8:	eb 14                	jmp    803cce <free_block+0x22e>
  803cba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803cbd:	8b 40 04             	mov    0x4(%eax),%eax
  803cc0:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803cc3:	c1 e2 04             	shl    $0x4,%edx
  803cc6:	81 c2 84 d0 81 00    	add    $0x81d084,%edx
  803ccc:	89 02                	mov    %eax,(%edx)
  803cce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803cd1:	8b 40 04             	mov    0x4(%eax),%eax
  803cd4:	85 c0                	test   %eax,%eax
  803cd6:	74 0f                	je     803ce7 <free_block+0x247>
  803cd8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803cdb:	8b 40 04             	mov    0x4(%eax),%eax
  803cde:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803ce1:	8b 12                	mov    (%edx),%edx
  803ce3:	89 10                	mov    %edx,(%eax)
  803ce5:	eb 13                	jmp    803cfa <free_block+0x25a>
  803ce7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803cea:	8b 00                	mov    (%eax),%eax
  803cec:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803cef:	c1 e2 04             	shl    $0x4,%edx
  803cf2:	81 c2 80 d0 81 00    	add    $0x81d080,%edx
  803cf8:	89 02                	mov    %eax,(%edx)
  803cfa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803cfd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803d03:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d06:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803d0d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803d10:	c1 e0 04             	shl    $0x4,%eax
  803d13:	05 8c d0 81 00       	add    $0x81d08c,%eax
  803d18:	8b 00                	mov    (%eax),%eax
  803d1a:	8d 50 ff             	lea    -0x1(%eax),%edx
  803d1d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803d20:	c1 e0 04             	shl    $0x4,%eax
  803d23:	05 8c d0 81 00       	add    $0x81d08c,%eax
  803d28:	89 10                	mov    %edx,(%eax)
				//y5o4 3la elly b3do
				itr = next;
  803d2a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803d2d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// b3d ma wdytha fy el freeBlockLists hzwed elfree elly fy el array 1
	pageBlockInfoArr[page_index].num_of_free_blocks++;
	int blocks_number = PAGE_SIZE / block_size;
	if(pageBlockInfoArr[page_index].num_of_free_blocks == blocks_number){
		struct BlockElement *itr = LIST_FIRST(&freeBlockLists[list_index]);
		while(itr != NULL){
  803d30:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803d34:	0f 85 05 ff ff ff    	jne    803c3f <free_block+0x19f>
				LIST_REMOVE(&freeBlockLists[list_index], itr);
				//y5o4 3la elly b3do
				itr = next;
			}
		}
		pageBlockInfoArr[page_index].block_size=0;
  803d3a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803d3d:	89 d0                	mov    %edx,%eax
  803d3f:	01 c0                	add    %eax,%eax
  803d41:	01 d0                	add    %edx,%eax
  803d43:	c1 e0 02             	shl    $0x2,%eax
  803d46:	05 68 50 80 00       	add    $0x805068,%eax
  803d4b:	66 c7 00 00 00       	movw   $0x0,(%eax)
		pageBlockInfoArr[page_index].num_of_free_blocks=0;
  803d50:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803d53:	89 d0                	mov    %edx,%eax
  803d55:	01 c0                	add    %eax,%eax
  803d57:	01 d0                	add    %edx,%eax
  803d59:	c1 e0 02             	shl    $0x2,%eax
  803d5c:	05 6a 50 80 00       	add    $0x80506a,%eax
  803d61:	66 c7 00 00 00       	movw   $0x0,(%eax)

		struct PageInfoElement *page_info = &pageBlockInfoArr[page_index];
  803d66:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803d69:	89 d0                	mov    %edx,%eax
  803d6b:	01 c0                	add    %eax,%eax
  803d6d:	01 d0                	add    %edx,%eax
  803d6f:	c1 e0 02             	shl    $0x2,%eax
  803d72:	05 60 50 80 00       	add    $0x805060,%eax
  803d77:	89 45 d0             	mov    %eax,-0x30(%ebp)
		LIST_INSERT_TAIL(&freePagesList, page_info);
  803d7a:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  803d7e:	75 17                	jne    803d97 <free_block+0x2f7>
  803d80:	83 ec 04             	sub    $0x4,%esp
  803d83:	68 8c 4a 80 00       	push   $0x804a8c
  803d88:	68 eb 00 00 00       	push   $0xeb
  803d8d:	68 33 4a 80 00       	push   $0x804a33
  803d92:	e8 5a c5 ff ff       	call   8002f1 <_panic>
  803d97:	8b 15 4c 50 80 00    	mov    0x80504c,%edx
  803d9d:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803da0:	89 50 04             	mov    %edx,0x4(%eax)
  803da3:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803da6:	8b 40 04             	mov    0x4(%eax),%eax
  803da9:	85 c0                	test   %eax,%eax
  803dab:	74 0c                	je     803db9 <free_block+0x319>
  803dad:	a1 4c 50 80 00       	mov    0x80504c,%eax
  803db2:	8b 55 d0             	mov    -0x30(%ebp),%edx
  803db5:	89 10                	mov    %edx,(%eax)
  803db7:	eb 08                	jmp    803dc1 <free_block+0x321>
  803db9:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803dbc:	a3 48 50 80 00       	mov    %eax,0x805048
  803dc1:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803dc4:	a3 4c 50 80 00       	mov    %eax,0x80504c
  803dc9:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803dcc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803dd2:	a1 54 50 80 00       	mov    0x805054,%eax
  803dd7:	40                   	inc    %eax
  803dd8:	a3 54 50 80 00       	mov    %eax,0x805054
		uint32 page_va = to_page_va(page_info);
  803ddd:	83 ec 0c             	sub    $0xc,%esp
  803de0:	ff 75 d0             	pushl  -0x30(%ebp)
  803de3:	e8 ce f5 ff ff       	call   8033b6 <to_page_va>
  803de8:	83 c4 10             	add    $0x10,%esp
  803deb:	89 45 cc             	mov    %eax,-0x34(%ebp)
		return_page((void *)page_va);
  803dee:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803df1:	83 ec 0c             	sub    $0xc,%esp
  803df4:	50                   	push   %eax
  803df5:	e8 9e d7 ff ff       	call   801598 <return_page>
  803dfa:	83 c4 10             	add    $0x10,%esp
	}


	//Comment the following line
	//panic("free_block() Not implemented yet");
}
  803dfd:	90                   	nop
  803dfe:	c9                   	leave  
  803dff:	c3                   	ret    

00803e00 <realloc_block>:

//===========================
// [1] REALLOCATE BLOCK:
//===========================
void *realloc_block(void* va, uint32 new_size)
{
  803e00:	55                   	push   %ebp
  803e01:	89 e5                	mov    %esp,%ebp
  803e03:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.BONUS#2] KERNEL REALLOC - realloc_block
	//Your code is here
	//Comment the following line
	panic("realloc_block() Not implemented yet");
  803e06:	83 ec 04             	sub    $0x4,%esp
  803e09:	68 2c 4b 80 00       	push   $0x804b2c
  803e0e:	68 01 01 00 00       	push   $0x101
  803e13:	68 33 4a 80 00       	push   $0x804a33
  803e18:	e8 d4 c4 ff ff       	call   8002f1 <_panic>

00803e1d <init_uspinlock>:
#include "inc/uspinlock.h"

extern volatile struct Env *myEnv;

void init_uspinlock(struct uspinlock *lk, char *name, bool isOpened)
{
  803e1d:	55                   	push   %ebp
  803e1e:	89 e5                	mov    %esp,%ebp
  803e20:	83 ec 08             	sub    $0x8,%esp
	assert(isOpened == 0 || isOpened == 1);
  803e23:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  803e27:	74 1c                	je     803e45 <init_uspinlock+0x28>
  803e29:	83 7d 10 01          	cmpl   $0x1,0x10(%ebp)
  803e2d:	74 16                	je     803e45 <init_uspinlock+0x28>
  803e2f:	68 50 4b 80 00       	push   $0x804b50
  803e34:	68 6f 4b 80 00       	push   $0x804b6f
  803e39:	6a 10                	push   $0x10
  803e3b:	68 84 4b 80 00       	push   $0x804b84
  803e40:	e8 ac c4 ff ff       	call   8002f1 <_panic>
	strcpy(lk->name, name);
  803e45:	8b 45 08             	mov    0x8(%ebp),%eax
  803e48:	83 c0 04             	add    $0x4,%eax
  803e4b:	83 ec 08             	sub    $0x8,%esp
  803e4e:	ff 75 0c             	pushl  0xc(%ebp)
  803e51:	50                   	push   %eax
  803e52:	e8 90 ce ff ff       	call   800ce7 <strcpy>
  803e57:	83 c4 10             	add    $0x10,%esp
	lk->locked = (1 - isOpened);
  803e5a:	b8 01 00 00 00       	mov    $0x1,%eax
  803e5f:	2b 45 10             	sub    0x10(%ebp),%eax
  803e62:	89 c2                	mov    %eax,%edx
  803e64:	8b 45 08             	mov    0x8(%ebp),%eax
  803e67:	89 10                	mov    %edx,(%eax)
}
  803e69:	90                   	nop
  803e6a:	c9                   	leave  
  803e6b:	c3                   	ret    

00803e6c <acquire_uspinlock>:
// Acquire the lock.
// Loops (spins) until the lock is acquired.
// Holding a lock for a long time may cause
// other CPUs to waste time spinning to acquire it.
void acquire_uspinlock(struct uspinlock *lk)
{
  803e6c:	55                   	push   %ebp
  803e6d:	89 e5                	mov    %esp,%ebp
  803e6f:	83 ec 18             	sub    $0x18,%esp
	// The xchg is atomic.
	while(xchg(&lk->locked, 1) != 0) ;
  803e72:	90                   	nop
  803e73:	8b 45 08             	mov    0x8(%ebp),%eax
  803e76:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803e79:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
xchg(volatile uint32 *addr, uint32 newval)
{
  uint32 result;

  // The + in "+m" denotes a read-modify-write operand.
  __asm __volatile("lock; xchgl %0, %1" :
  803e80:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803e83:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803e86:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  803e89:	f0 87 02             	lock xchg %eax,(%edx)
  803e8c:	89 45 ec             	mov    %eax,-0x14(%ebp)
               "+m" (*addr), "=a" (result) :
               "1" (newval) :
               "cc");
  return result;
  803e8f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803e92:	85 c0                	test   %eax,%eax
  803e94:	75 dd                	jne    803e73 <acquire_uspinlock+0x7>

	cprintf("[%d: %s] ACQUIRED spinlock [%s]\n", myEnv->env_id, myEnv->prog_name, lk->name);
  803e96:	8b 45 08             	mov    0x8(%ebp),%eax
  803e99:	8d 48 04             	lea    0x4(%eax),%ecx
  803e9c:	a1 20 50 80 00       	mov    0x805020,%eax
  803ea1:	8d 50 20             	lea    0x20(%eax),%edx
  803ea4:	a1 20 50 80 00       	mov    0x805020,%eax
  803ea9:	8b 40 10             	mov    0x10(%eax),%eax
  803eac:	51                   	push   %ecx
  803ead:	52                   	push   %edx
  803eae:	50                   	push   %eax
  803eaf:	68 94 4b 80 00       	push   $0x804b94
  803eb4:	e8 06 c7 ff ff       	call   8005bf <cprintf>
  803eb9:	83 c4 10             	add    $0x10,%esp

	// Tell the C compiler and the processor to not move loads or stores
	// past this point, to ensure that the critical section's memory
	// references happen after the lock is acquired.
	__sync_synchronize();
  803ebc:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
}
  803ec1:	90                   	nop
  803ec2:	c9                   	leave  
  803ec3:	c3                   	ret    

00803ec4 <release_uspinlock>:

// Release the lock.
void release_uspinlock(struct uspinlock *lk)
{
  803ec4:	55                   	push   %ebp
  803ec5:	89 e5                	mov    %esp,%ebp
  803ec7:	83 ec 08             	sub    $0x8,%esp
	if(!(lk->locked))
  803eca:	8b 45 08             	mov    0x8(%ebp),%eax
  803ecd:	8b 00                	mov    (%eax),%eax
  803ecf:	85 c0                	test   %eax,%eax
  803ed1:	75 18                	jne    803eeb <release_uspinlock+0x27>
	{
		panic("release: lock \"%s\" is not held!", lk->name);
  803ed3:	8b 45 08             	mov    0x8(%ebp),%eax
  803ed6:	83 c0 04             	add    $0x4,%eax
  803ed9:	50                   	push   %eax
  803eda:	68 b8 4b 80 00       	push   $0x804bb8
  803edf:	6a 2b                	push   $0x2b
  803ee1:	68 84 4b 80 00       	push   $0x804b84
  803ee6:	e8 06 c4 ff ff       	call   8002f1 <_panic>
	// Tell the C compiler and the processor to not move loads or stores
	// past this point, to ensure that all the stores in the critical
	// section are visible to other cores before the lock is released.
	// Both the C compiler and the hardware may re-order loads and
	// stores; __sync_synchronize() tells them both not to.
	__sync_synchronize();
  803eeb:	f0 83 0c 24 00       	lock orl $0x0,(%esp)

	// Release the lock, equivalent to lk->locked = 0.
	// This code can't use a C assignment, since it might
	// not be atomic. A real OS would use C atomics here.
	asm volatile("movl $0, %0" : "+m" (lk->locked) : );
  803ef0:	8b 45 08             	mov    0x8(%ebp),%eax
  803ef3:	8b 55 08             	mov    0x8(%ebp),%edx
  803ef6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	cprintf("[%d: %s] RELEASED spinlock [%s]\n", myEnv->env_id, myEnv->prog_name, lk->name);
  803efc:	8b 45 08             	mov    0x8(%ebp),%eax
  803eff:	8d 48 04             	lea    0x4(%eax),%ecx
  803f02:	a1 20 50 80 00       	mov    0x805020,%eax
  803f07:	8d 50 20             	lea    0x20(%eax),%edx
  803f0a:	a1 20 50 80 00       	mov    0x805020,%eax
  803f0f:	8b 40 10             	mov    0x10(%eax),%eax
  803f12:	51                   	push   %ecx
  803f13:	52                   	push   %edx
  803f14:	50                   	push   %eax
  803f15:	68 d8 4b 80 00       	push   $0x804bd8
  803f1a:	e8 a0 c6 ff ff       	call   8005bf <cprintf>
  803f1f:	83 c4 10             	add    $0x10,%esp
}
  803f22:	90                   	nop
  803f23:	c9                   	leave  
  803f24:	c3                   	ret    
  803f25:	66 90                	xchg   %ax,%ax
  803f27:	90                   	nop

00803f28 <__udivdi3>:
  803f28:	55                   	push   %ebp
  803f29:	57                   	push   %edi
  803f2a:	56                   	push   %esi
  803f2b:	53                   	push   %ebx
  803f2c:	83 ec 1c             	sub    $0x1c,%esp
  803f2f:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803f33:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803f37:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803f3b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803f3f:	89 ca                	mov    %ecx,%edx
  803f41:	89 f8                	mov    %edi,%eax
  803f43:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803f47:	85 f6                	test   %esi,%esi
  803f49:	75 2d                	jne    803f78 <__udivdi3+0x50>
  803f4b:	39 cf                	cmp    %ecx,%edi
  803f4d:	77 65                	ja     803fb4 <__udivdi3+0x8c>
  803f4f:	89 fd                	mov    %edi,%ebp
  803f51:	85 ff                	test   %edi,%edi
  803f53:	75 0b                	jne    803f60 <__udivdi3+0x38>
  803f55:	b8 01 00 00 00       	mov    $0x1,%eax
  803f5a:	31 d2                	xor    %edx,%edx
  803f5c:	f7 f7                	div    %edi
  803f5e:	89 c5                	mov    %eax,%ebp
  803f60:	31 d2                	xor    %edx,%edx
  803f62:	89 c8                	mov    %ecx,%eax
  803f64:	f7 f5                	div    %ebp
  803f66:	89 c1                	mov    %eax,%ecx
  803f68:	89 d8                	mov    %ebx,%eax
  803f6a:	f7 f5                	div    %ebp
  803f6c:	89 cf                	mov    %ecx,%edi
  803f6e:	89 fa                	mov    %edi,%edx
  803f70:	83 c4 1c             	add    $0x1c,%esp
  803f73:	5b                   	pop    %ebx
  803f74:	5e                   	pop    %esi
  803f75:	5f                   	pop    %edi
  803f76:	5d                   	pop    %ebp
  803f77:	c3                   	ret    
  803f78:	39 ce                	cmp    %ecx,%esi
  803f7a:	77 28                	ja     803fa4 <__udivdi3+0x7c>
  803f7c:	0f bd fe             	bsr    %esi,%edi
  803f7f:	83 f7 1f             	xor    $0x1f,%edi
  803f82:	75 40                	jne    803fc4 <__udivdi3+0x9c>
  803f84:	39 ce                	cmp    %ecx,%esi
  803f86:	72 0a                	jb     803f92 <__udivdi3+0x6a>
  803f88:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803f8c:	0f 87 9e 00 00 00    	ja     804030 <__udivdi3+0x108>
  803f92:	b8 01 00 00 00       	mov    $0x1,%eax
  803f97:	89 fa                	mov    %edi,%edx
  803f99:	83 c4 1c             	add    $0x1c,%esp
  803f9c:	5b                   	pop    %ebx
  803f9d:	5e                   	pop    %esi
  803f9e:	5f                   	pop    %edi
  803f9f:	5d                   	pop    %ebp
  803fa0:	c3                   	ret    
  803fa1:	8d 76 00             	lea    0x0(%esi),%esi
  803fa4:	31 ff                	xor    %edi,%edi
  803fa6:	31 c0                	xor    %eax,%eax
  803fa8:	89 fa                	mov    %edi,%edx
  803faa:	83 c4 1c             	add    $0x1c,%esp
  803fad:	5b                   	pop    %ebx
  803fae:	5e                   	pop    %esi
  803faf:	5f                   	pop    %edi
  803fb0:	5d                   	pop    %ebp
  803fb1:	c3                   	ret    
  803fb2:	66 90                	xchg   %ax,%ax
  803fb4:	89 d8                	mov    %ebx,%eax
  803fb6:	f7 f7                	div    %edi
  803fb8:	31 ff                	xor    %edi,%edi
  803fba:	89 fa                	mov    %edi,%edx
  803fbc:	83 c4 1c             	add    $0x1c,%esp
  803fbf:	5b                   	pop    %ebx
  803fc0:	5e                   	pop    %esi
  803fc1:	5f                   	pop    %edi
  803fc2:	5d                   	pop    %ebp
  803fc3:	c3                   	ret    
  803fc4:	bd 20 00 00 00       	mov    $0x20,%ebp
  803fc9:	89 eb                	mov    %ebp,%ebx
  803fcb:	29 fb                	sub    %edi,%ebx
  803fcd:	89 f9                	mov    %edi,%ecx
  803fcf:	d3 e6                	shl    %cl,%esi
  803fd1:	89 c5                	mov    %eax,%ebp
  803fd3:	88 d9                	mov    %bl,%cl
  803fd5:	d3 ed                	shr    %cl,%ebp
  803fd7:	89 e9                	mov    %ebp,%ecx
  803fd9:	09 f1                	or     %esi,%ecx
  803fdb:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803fdf:	89 f9                	mov    %edi,%ecx
  803fe1:	d3 e0                	shl    %cl,%eax
  803fe3:	89 c5                	mov    %eax,%ebp
  803fe5:	89 d6                	mov    %edx,%esi
  803fe7:	88 d9                	mov    %bl,%cl
  803fe9:	d3 ee                	shr    %cl,%esi
  803feb:	89 f9                	mov    %edi,%ecx
  803fed:	d3 e2                	shl    %cl,%edx
  803fef:	8b 44 24 08          	mov    0x8(%esp),%eax
  803ff3:	88 d9                	mov    %bl,%cl
  803ff5:	d3 e8                	shr    %cl,%eax
  803ff7:	09 c2                	or     %eax,%edx
  803ff9:	89 d0                	mov    %edx,%eax
  803ffb:	89 f2                	mov    %esi,%edx
  803ffd:	f7 74 24 0c          	divl   0xc(%esp)
  804001:	89 d6                	mov    %edx,%esi
  804003:	89 c3                	mov    %eax,%ebx
  804005:	f7 e5                	mul    %ebp
  804007:	39 d6                	cmp    %edx,%esi
  804009:	72 19                	jb     804024 <__udivdi3+0xfc>
  80400b:	74 0b                	je     804018 <__udivdi3+0xf0>
  80400d:	89 d8                	mov    %ebx,%eax
  80400f:	31 ff                	xor    %edi,%edi
  804011:	e9 58 ff ff ff       	jmp    803f6e <__udivdi3+0x46>
  804016:	66 90                	xchg   %ax,%ax
  804018:	8b 54 24 08          	mov    0x8(%esp),%edx
  80401c:	89 f9                	mov    %edi,%ecx
  80401e:	d3 e2                	shl    %cl,%edx
  804020:	39 c2                	cmp    %eax,%edx
  804022:	73 e9                	jae    80400d <__udivdi3+0xe5>
  804024:	8d 43 ff             	lea    -0x1(%ebx),%eax
  804027:	31 ff                	xor    %edi,%edi
  804029:	e9 40 ff ff ff       	jmp    803f6e <__udivdi3+0x46>
  80402e:	66 90                	xchg   %ax,%ax
  804030:	31 c0                	xor    %eax,%eax
  804032:	e9 37 ff ff ff       	jmp    803f6e <__udivdi3+0x46>
  804037:	90                   	nop

00804038 <__umoddi3>:
  804038:	55                   	push   %ebp
  804039:	57                   	push   %edi
  80403a:	56                   	push   %esi
  80403b:	53                   	push   %ebx
  80403c:	83 ec 1c             	sub    $0x1c,%esp
  80403f:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  804043:	8b 74 24 34          	mov    0x34(%esp),%esi
  804047:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80404b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80404f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  804053:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  804057:	89 f3                	mov    %esi,%ebx
  804059:	89 fa                	mov    %edi,%edx
  80405b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80405f:	89 34 24             	mov    %esi,(%esp)
  804062:	85 c0                	test   %eax,%eax
  804064:	75 1a                	jne    804080 <__umoddi3+0x48>
  804066:	39 f7                	cmp    %esi,%edi
  804068:	0f 86 a2 00 00 00    	jbe    804110 <__umoddi3+0xd8>
  80406e:	89 c8                	mov    %ecx,%eax
  804070:	89 f2                	mov    %esi,%edx
  804072:	f7 f7                	div    %edi
  804074:	89 d0                	mov    %edx,%eax
  804076:	31 d2                	xor    %edx,%edx
  804078:	83 c4 1c             	add    $0x1c,%esp
  80407b:	5b                   	pop    %ebx
  80407c:	5e                   	pop    %esi
  80407d:	5f                   	pop    %edi
  80407e:	5d                   	pop    %ebp
  80407f:	c3                   	ret    
  804080:	39 f0                	cmp    %esi,%eax
  804082:	0f 87 ac 00 00 00    	ja     804134 <__umoddi3+0xfc>
  804088:	0f bd e8             	bsr    %eax,%ebp
  80408b:	83 f5 1f             	xor    $0x1f,%ebp
  80408e:	0f 84 ac 00 00 00    	je     804140 <__umoddi3+0x108>
  804094:	bf 20 00 00 00       	mov    $0x20,%edi
  804099:	29 ef                	sub    %ebp,%edi
  80409b:	89 fe                	mov    %edi,%esi
  80409d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8040a1:	89 e9                	mov    %ebp,%ecx
  8040a3:	d3 e0                	shl    %cl,%eax
  8040a5:	89 d7                	mov    %edx,%edi
  8040a7:	89 f1                	mov    %esi,%ecx
  8040a9:	d3 ef                	shr    %cl,%edi
  8040ab:	09 c7                	or     %eax,%edi
  8040ad:	89 e9                	mov    %ebp,%ecx
  8040af:	d3 e2                	shl    %cl,%edx
  8040b1:	89 14 24             	mov    %edx,(%esp)
  8040b4:	89 d8                	mov    %ebx,%eax
  8040b6:	d3 e0                	shl    %cl,%eax
  8040b8:	89 c2                	mov    %eax,%edx
  8040ba:	8b 44 24 08          	mov    0x8(%esp),%eax
  8040be:	d3 e0                	shl    %cl,%eax
  8040c0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8040c4:	8b 44 24 08          	mov    0x8(%esp),%eax
  8040c8:	89 f1                	mov    %esi,%ecx
  8040ca:	d3 e8                	shr    %cl,%eax
  8040cc:	09 d0                	or     %edx,%eax
  8040ce:	d3 eb                	shr    %cl,%ebx
  8040d0:	89 da                	mov    %ebx,%edx
  8040d2:	f7 f7                	div    %edi
  8040d4:	89 d3                	mov    %edx,%ebx
  8040d6:	f7 24 24             	mull   (%esp)
  8040d9:	89 c6                	mov    %eax,%esi
  8040db:	89 d1                	mov    %edx,%ecx
  8040dd:	39 d3                	cmp    %edx,%ebx
  8040df:	0f 82 87 00 00 00    	jb     80416c <__umoddi3+0x134>
  8040e5:	0f 84 91 00 00 00    	je     80417c <__umoddi3+0x144>
  8040eb:	8b 54 24 04          	mov    0x4(%esp),%edx
  8040ef:	29 f2                	sub    %esi,%edx
  8040f1:	19 cb                	sbb    %ecx,%ebx
  8040f3:	89 d8                	mov    %ebx,%eax
  8040f5:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8040f9:	d3 e0                	shl    %cl,%eax
  8040fb:	89 e9                	mov    %ebp,%ecx
  8040fd:	d3 ea                	shr    %cl,%edx
  8040ff:	09 d0                	or     %edx,%eax
  804101:	89 e9                	mov    %ebp,%ecx
  804103:	d3 eb                	shr    %cl,%ebx
  804105:	89 da                	mov    %ebx,%edx
  804107:	83 c4 1c             	add    $0x1c,%esp
  80410a:	5b                   	pop    %ebx
  80410b:	5e                   	pop    %esi
  80410c:	5f                   	pop    %edi
  80410d:	5d                   	pop    %ebp
  80410e:	c3                   	ret    
  80410f:	90                   	nop
  804110:	89 fd                	mov    %edi,%ebp
  804112:	85 ff                	test   %edi,%edi
  804114:	75 0b                	jne    804121 <__umoddi3+0xe9>
  804116:	b8 01 00 00 00       	mov    $0x1,%eax
  80411b:	31 d2                	xor    %edx,%edx
  80411d:	f7 f7                	div    %edi
  80411f:	89 c5                	mov    %eax,%ebp
  804121:	89 f0                	mov    %esi,%eax
  804123:	31 d2                	xor    %edx,%edx
  804125:	f7 f5                	div    %ebp
  804127:	89 c8                	mov    %ecx,%eax
  804129:	f7 f5                	div    %ebp
  80412b:	89 d0                	mov    %edx,%eax
  80412d:	e9 44 ff ff ff       	jmp    804076 <__umoddi3+0x3e>
  804132:	66 90                	xchg   %ax,%ax
  804134:	89 c8                	mov    %ecx,%eax
  804136:	89 f2                	mov    %esi,%edx
  804138:	83 c4 1c             	add    $0x1c,%esp
  80413b:	5b                   	pop    %ebx
  80413c:	5e                   	pop    %esi
  80413d:	5f                   	pop    %edi
  80413e:	5d                   	pop    %ebp
  80413f:	c3                   	ret    
  804140:	3b 04 24             	cmp    (%esp),%eax
  804143:	72 06                	jb     80414b <__umoddi3+0x113>
  804145:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  804149:	77 0f                	ja     80415a <__umoddi3+0x122>
  80414b:	89 f2                	mov    %esi,%edx
  80414d:	29 f9                	sub    %edi,%ecx
  80414f:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  804153:	89 14 24             	mov    %edx,(%esp)
  804156:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80415a:	8b 44 24 04          	mov    0x4(%esp),%eax
  80415e:	8b 14 24             	mov    (%esp),%edx
  804161:	83 c4 1c             	add    $0x1c,%esp
  804164:	5b                   	pop    %ebx
  804165:	5e                   	pop    %esi
  804166:	5f                   	pop    %edi
  804167:	5d                   	pop    %ebp
  804168:	c3                   	ret    
  804169:	8d 76 00             	lea    0x0(%esi),%esi
  80416c:	2b 04 24             	sub    (%esp),%eax
  80416f:	19 fa                	sbb    %edi,%edx
  804171:	89 d1                	mov    %edx,%ecx
  804173:	89 c6                	mov    %eax,%esi
  804175:	e9 71 ff ff ff       	jmp    8040eb <__umoddi3+0xb3>
  80417a:	66 90                	xchg   %ax,%ax
  80417c:	39 44 24 04          	cmp    %eax,0x4(%esp)
  804180:	72 ea                	jb     80416c <__umoddi3+0x134>
  804182:	89 d9                	mov    %ebx,%ecx
  804184:	e9 62 ff ff ff       	jmp    8040eb <__umoddi3+0xb3>
