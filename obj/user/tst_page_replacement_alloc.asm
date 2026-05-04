
obj/user/tst_page_replacement_alloc:     file format elf32-i386


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
  800031:	e8 3d 01 00 00       	call   800173 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
		0xeebfd000, 	//Stack
		} ;


void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	53                   	push   %ebx
  80003c:	83 ec 24             	sub    $0x24,%esp
	//("STEP 0: checking Initial WS entries ...\n");
	bool found ;

#if USE_KHEAP
	{
		found = sys_check_WS_list(expectedInitialVAs, 11, 0x800000, 1);
  80003f:	6a 01                	push   $0x1
  800041:	68 00 00 80 00       	push   $0x800000
  800046:	6a 0b                	push   $0xb
  800048:	68 20 30 80 00       	push   $0x803020
  80004d:	e8 6e 19 00 00       	call   8019c0 <sys_check_WS_list>
  800052:	83 c4 10             	add    $0x10,%esp
  800055:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (found != 1) panic("INITIAL PAGE WS entry checking failed! Review size of the WS!!\n*****IF CORRECT, CHECK THE ISSUE WITH THE STAFF*****");
  800058:	83 7d ec 01          	cmpl   $0x1,-0x14(%ebp)
  80005c:	74 14                	je     800072 <_main+0x3a>
  80005e:	83 ec 04             	sub    $0x4,%esp
  800061:	68 00 1d 80 00       	push   $0x801d00
  800066:	6a 1c                	push   $0x1c
  800068:	68 74 1d 80 00       	push   $0x801d74
  80006d:	e8 ba 02 00 00       	call   80032c <_panic>
	}
#else
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif

	int freePages = sys_calculate_free_frames();
  800072:	e8 87 15 00 00       	call   8015fe <sys_calculate_free_frames>
  800077:	89 45 e8             	mov    %eax,-0x18(%ebp)
	int usedDiskPages = sys_pf_calculate_allocated_pages();
  80007a:	e8 ca 15 00 00       	call   801649 <sys_pf_calculate_allocated_pages>
  80007f:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	//Writing (Modified)
	__arr__[PAGE_SIZE*10-1] = 'a' ;
  800082:	c6 05 9f d0 80 00 61 	movb   $0x61,0x80d09f

	//Reading (Not Modified)
	char garbage1 = __arr__[PAGE_SIZE*11-1] ;
  800089:	a0 9f e0 80 00       	mov    0x80e09f,%al
  80008e:	88 45 e3             	mov    %al,-0x1d(%ebp)
	char garbage2 = __arr__[PAGE_SIZE*12-1] ;
  800091:	a0 9f f0 80 00       	mov    0x80f09f,%al
  800096:	88 45 e2             	mov    %al,-0x1e(%ebp)
	char garbage4,garbage5;

	//Writing (Modified)
	int i ;
	for (i = 0 ; i < PAGE_SIZE*10 ; i+=PAGE_SIZE/2)
  800099:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8000a0:	eb 4a                	jmp    8000ec <_main+0xb4>
	{
		__arr__[i] = -1 ;
  8000a2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8000a5:	05 a0 30 80 00       	add    $0x8030a0,%eax
  8000aa:	c6 00 ff             	movb   $0xff,(%eax)
		/*2016: this BUGGY line is REMOVED el7! it overwrites the KERNEL CODE :( !!!*/
		//*__ptr__ = *__ptr2__ ;
		/*==========================================================================*/
		//always use pages at 0x801000 and 0x804000
		garbage4 = *__ptr__ + garbage5;
  8000ad:	a1 00 30 80 00       	mov    0x803000,%eax
  8000b2:	8a 00                	mov    (%eax),%al
  8000b4:	88 c2                	mov    %al,%dl
  8000b6:	8a 45 f7             	mov    -0x9(%ebp),%al
  8000b9:	01 d0                	add    %edx,%eax
  8000bb:	88 45 e1             	mov    %al,-0x1f(%ebp)
		garbage5 = *__ptr2__ + garbage4;
  8000be:	a1 04 30 80 00       	mov    0x803004,%eax
  8000c3:	8a 00                	mov    (%eax),%al
  8000c5:	88 c2                	mov    %al,%dl
  8000c7:	8a 45 e1             	mov    -0x1f(%ebp),%al
  8000ca:	01 d0                	add    %edx,%eax
  8000cc:	88 45 f7             	mov    %al,-0x9(%ebp)
		__ptr__++ ; __ptr2__++ ;
  8000cf:	a1 00 30 80 00       	mov    0x803000,%eax
  8000d4:	40                   	inc    %eax
  8000d5:	a3 00 30 80 00       	mov    %eax,0x803000
  8000da:	a1 04 30 80 00       	mov    0x803004,%eax
  8000df:	40                   	inc    %eax
  8000e0:	a3 04 30 80 00       	mov    %eax,0x803004
	char garbage2 = __arr__[PAGE_SIZE*12-1] ;
	char garbage4,garbage5;

	//Writing (Modified)
	int i ;
	for (i = 0 ; i < PAGE_SIZE*10 ; i+=PAGE_SIZE/2)
  8000e5:	81 45 f0 00 08 00 00 	addl   $0x800,-0x10(%ebp)
  8000ec:	81 7d f0 ff 9f 00 00 	cmpl   $0x9fff,-0x10(%ebp)
  8000f3:	7e ad                	jle    8000a2 <_main+0x6a>
		__ptr__++ ; __ptr2__++ ;
	}

	//===================

	cprintf_colored(TEXT_cyan, "%~\nChecking Allocation in Mem & Page File... \n");
  8000f5:	83 ec 08             	sub    $0x8,%esp
  8000f8:	68 98 1d 80 00       	push   $0x801d98
  8000fd:	6a 03                	push   $0x3
  8000ff:	e8 23 05 00 00       	call   800627 <cprintf_colored>
  800104:	83 c4 10             	add    $0x10,%esp
	{
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Unexpected extra/less pages have been added to page file.. NOT Expected to add new pages to the page file");
  800107:	e8 3d 15 00 00       	call   801649 <sys_pf_calculate_allocated_pages>
  80010c:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80010f:	74 14                	je     800125 <_main+0xed>
  800111:	83 ec 04             	sub    $0x4,%esp
  800114:	68 c8 1d 80 00       	push   $0x801dc8
  800119:	6a 3f                	push   $0x3f
  80011b:	68 74 1d 80 00       	push   $0x801d74
  800120:	e8 07 02 00 00       	call   80032c <_panic>

		int freePagesAfter = (sys_calculate_free_frames() + sys_calculate_modified_frames());
  800125:	e8 d4 14 00 00       	call   8015fe <sys_calculate_free_frames>
  80012a:	89 c3                	mov    %eax,%ebx
  80012c:	e8 e6 14 00 00       	call   801617 <sys_calculate_modified_frames>
  800131:	01 d8                	add    %ebx,%eax
  800133:	89 45 dc             	mov    %eax,-0x24(%ebp)
		if( (freePages - freePagesAfter) != 0 )
  800136:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800139:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  80013c:	74 1d                	je     80015b <_main+0x123>
			panic("Extra memory are wrongly allocated... It's REplacement: expected that no extra frames are allocated. Expected = %d, Actual = %d", 0, (freePages - freePagesAfter));
  80013e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800141:	2b 45 dc             	sub    -0x24(%ebp),%eax
  800144:	83 ec 0c             	sub    $0xc,%esp
  800147:	50                   	push   %eax
  800148:	6a 00                	push   $0x0
  80014a:	68 34 1e 80 00       	push   $0x801e34
  80014f:	6a 43                	push   $0x43
  800151:	68 74 1d 80 00       	push   $0x801d74
  800156:	e8 d1 01 00 00       	call   80032c <_panic>
	}

	cprintf_colored(TEXT_light_green, "%~\nCongratulations!! test PAGE replacement [ALLOCATION] is completed successfully\n");
  80015b:	83 ec 08             	sub    $0x8,%esp
  80015e:	68 b4 1e 80 00       	push   $0x801eb4
  800163:	6a 0a                	push   $0xa
  800165:	e8 bd 04 00 00       	call   800627 <cprintf_colored>
  80016a:	83 c4 10             	add    $0x10,%esp
	return;
  80016d:	90                   	nop
}
  80016e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800171:	c9                   	leave  
  800172:	c3                   	ret    

00800173 <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  800173:	55                   	push   %ebp
  800174:	89 e5                	mov    %esp,%ebp
  800176:	57                   	push   %edi
  800177:	56                   	push   %esi
  800178:	53                   	push   %ebx
  800179:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  80017c:	e8 46 16 00 00       	call   8017c7 <sys_getenvindex>
  800181:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  800184:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800187:	89 d0                	mov    %edx,%eax
  800189:	c1 e0 02             	shl    $0x2,%eax
  80018c:	01 d0                	add    %edx,%eax
  80018e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800195:	01 d0                	add    %edx,%eax
  800197:	89 c2                	mov    %eax,%edx
  800199:	c1 e2 04             	shl    $0x4,%edx
  80019c:	29 c2                	sub    %eax,%edx
  80019e:	8d 04 95 00 00 00 00 	lea    0x0(,%edx,4),%eax
  8001a5:	89 c2                	mov    %eax,%edx
  8001a7:	8d 82 00 00 c0 ee    	lea    -0x11400000(%edx),%eax
  8001ad:	a3 60 30 80 00       	mov    %eax,0x803060

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8001b2:	a1 60 30 80 00       	mov    0x803060,%eax
  8001b7:	8a 40 20             	mov    0x20(%eax),%al
  8001ba:	84 c0                	test   %al,%al
  8001bc:	74 0d                	je     8001cb <libmain+0x58>
		binaryname = myEnv->prog_name;
  8001be:	a1 60 30 80 00       	mov    0x803060,%eax
  8001c3:	83 c0 20             	add    $0x20,%eax
  8001c6:	a3 50 30 80 00       	mov    %eax,0x803050

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8001cb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8001cf:	7e 0a                	jle    8001db <libmain+0x68>
		binaryname = argv[0];
  8001d1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001d4:	8b 00                	mov    (%eax),%eax
  8001d6:	a3 50 30 80 00       	mov    %eax,0x803050

	// call user main routine
	_main(argc, argv);
  8001db:	83 ec 08             	sub    $0x8,%esp
  8001de:	ff 75 0c             	pushl  0xc(%ebp)
  8001e1:	ff 75 08             	pushl  0x8(%ebp)
  8001e4:	e8 4f fe ff ff       	call   800038 <_main>
  8001e9:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  8001ec:	a1 4c 30 80 00       	mov    0x80304c,%eax
  8001f1:	85 c0                	test   %eax,%eax
  8001f3:	0f 84 01 01 00 00    	je     8002fa <libmain+0x187>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  8001f9:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  8001ff:	bb 00 20 80 00       	mov    $0x802000,%ebx
  800204:	ba 0e 00 00 00       	mov    $0xe,%edx
  800209:	89 c7                	mov    %eax,%edi
  80020b:	89 de                	mov    %ebx,%esi
  80020d:	89 d1                	mov    %edx,%ecx
  80020f:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  800211:	8d 55 8a             	lea    -0x76(%ebp),%edx
  800214:	b9 56 00 00 00       	mov    $0x56,%ecx
  800219:	b0 00                	mov    $0x0,%al
  80021b:	89 d7                	mov    %edx,%edi
  80021d:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  80021f:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  800226:	8d 45 e0             	lea    -0x20(%ebp),%eax
  800229:	83 ec 08             	sub    $0x8,%esp
  80022c:	50                   	push   %eax
  80022d:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  800233:	50                   	push   %eax
  800234:	e8 c4 17 00 00       	call   8019fd <sys_utilities>
  800239:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  80023c:	e8 0d 13 00 00       	call   80154e <sys_lock_cons>
		{
			cprintf("**************************************\n");
  800241:	83 ec 0c             	sub    $0xc,%esp
  800244:	68 20 1f 80 00       	push   $0x801f20
  800249:	e8 ac 03 00 00       	call   8005fa <cprintf>
  80024e:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  800251:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800254:	85 c0                	test   %eax,%eax
  800256:	74 18                	je     800270 <libmain+0xfd>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  800258:	e8 be 17 00 00       	call   801a1b <sys_get_optimal_num_faults>
  80025d:	83 ec 08             	sub    $0x8,%esp
  800260:	50                   	push   %eax
  800261:	68 48 1f 80 00       	push   $0x801f48
  800266:	e8 8f 03 00 00       	call   8005fa <cprintf>
  80026b:	83 c4 10             	add    $0x10,%esp
  80026e:	eb 59                	jmp    8002c9 <libmain+0x156>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800270:	a1 60 30 80 00       	mov    0x803060,%eax
  800275:	8b 90 bc 05 00 00    	mov    0x5bc(%eax),%edx
  80027b:	a1 60 30 80 00       	mov    0x803060,%eax
  800280:	8b 80 ac 05 00 00    	mov    0x5ac(%eax),%eax
  800286:	83 ec 04             	sub    $0x4,%esp
  800289:	52                   	push   %edx
  80028a:	50                   	push   %eax
  80028b:	68 6c 1f 80 00       	push   $0x801f6c
  800290:	e8 65 03 00 00       	call   8005fa <cprintf>
  800295:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800298:	a1 60 30 80 00       	mov    0x803060,%eax
  80029d:	8b 88 d0 05 00 00    	mov    0x5d0(%eax),%ecx
  8002a3:	a1 60 30 80 00       	mov    0x803060,%eax
  8002a8:	8b 90 cc 05 00 00    	mov    0x5cc(%eax),%edx
  8002ae:	a1 60 30 80 00       	mov    0x803060,%eax
  8002b3:	8b 80 c8 05 00 00    	mov    0x5c8(%eax),%eax
  8002b9:	51                   	push   %ecx
  8002ba:	52                   	push   %edx
  8002bb:	50                   	push   %eax
  8002bc:	68 94 1f 80 00       	push   $0x801f94
  8002c1:	e8 34 03 00 00       	call   8005fa <cprintf>
  8002c6:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8002c9:	a1 60 30 80 00       	mov    0x803060,%eax
  8002ce:	8b 80 d4 05 00 00    	mov    0x5d4(%eax),%eax
  8002d4:	83 ec 08             	sub    $0x8,%esp
  8002d7:	50                   	push   %eax
  8002d8:	68 ec 1f 80 00       	push   $0x801fec
  8002dd:	e8 18 03 00 00       	call   8005fa <cprintf>
  8002e2:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  8002e5:	83 ec 0c             	sub    $0xc,%esp
  8002e8:	68 20 1f 80 00       	push   $0x801f20
  8002ed:	e8 08 03 00 00       	call   8005fa <cprintf>
  8002f2:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  8002f5:	e8 6e 12 00 00       	call   801568 <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  8002fa:	e8 1f 00 00 00       	call   80031e <exit>
}
  8002ff:	90                   	nop
  800300:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800303:	5b                   	pop    %ebx
  800304:	5e                   	pop    %esi
  800305:	5f                   	pop    %edi
  800306:	5d                   	pop    %ebp
  800307:	c3                   	ret    

00800308 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800308:	55                   	push   %ebp
  800309:	89 e5                	mov    %esp,%ebp
  80030b:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  80030e:	83 ec 0c             	sub    $0xc,%esp
  800311:	6a 00                	push   $0x0
  800313:	e8 7b 14 00 00       	call   801793 <sys_destroy_env>
  800318:	83 c4 10             	add    $0x10,%esp
}
  80031b:	90                   	nop
  80031c:	c9                   	leave  
  80031d:	c3                   	ret    

0080031e <exit>:

void
exit(void)
{
  80031e:	55                   	push   %ebp
  80031f:	89 e5                	mov    %esp,%ebp
  800321:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800324:	e8 d0 14 00 00       	call   8017f9 <sys_exit_env>
}
  800329:	90                   	nop
  80032a:	c9                   	leave  
  80032b:	c3                   	ret    

0080032c <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  80032c:	55                   	push   %ebp
  80032d:	89 e5                	mov    %esp,%ebp
  80032f:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800332:	8d 45 10             	lea    0x10(%ebp),%eax
  800335:	83 c0 04             	add    $0x4,%eax
  800338:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  80033b:	a1 78 71 82 00       	mov    0x827178,%eax
  800340:	85 c0                	test   %eax,%eax
  800342:	74 16                	je     80035a <_panic+0x2e>
		cprintf("%s: ", argv0);
  800344:	a1 78 71 82 00       	mov    0x827178,%eax
  800349:	83 ec 08             	sub    $0x8,%esp
  80034c:	50                   	push   %eax
  80034d:	68 64 20 80 00       	push   $0x802064
  800352:	e8 a3 02 00 00       	call   8005fa <cprintf>
  800357:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  80035a:	a1 50 30 80 00       	mov    0x803050,%eax
  80035f:	83 ec 0c             	sub    $0xc,%esp
  800362:	ff 75 0c             	pushl  0xc(%ebp)
  800365:	ff 75 08             	pushl  0x8(%ebp)
  800368:	50                   	push   %eax
  800369:	68 6c 20 80 00       	push   $0x80206c
  80036e:	6a 74                	push   $0x74
  800370:	e8 b2 02 00 00       	call   800627 <cprintf_colored>
  800375:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  800378:	8b 45 10             	mov    0x10(%ebp),%eax
  80037b:	83 ec 08             	sub    $0x8,%esp
  80037e:	ff 75 f4             	pushl  -0xc(%ebp)
  800381:	50                   	push   %eax
  800382:	e8 04 02 00 00       	call   80058b <vcprintf>
  800387:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  80038a:	83 ec 08             	sub    $0x8,%esp
  80038d:	6a 00                	push   $0x0
  80038f:	68 94 20 80 00       	push   $0x802094
  800394:	e8 f2 01 00 00       	call   80058b <vcprintf>
  800399:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  80039c:	e8 7d ff ff ff       	call   80031e <exit>

	// should not return here
	while (1) ;
  8003a1:	eb fe                	jmp    8003a1 <_panic+0x75>

008003a3 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8003a3:	55                   	push   %ebp
  8003a4:	89 e5                	mov    %esp,%ebp
  8003a6:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8003a9:	a1 60 30 80 00       	mov    0x803060,%eax
  8003ae:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8003b4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003b7:	39 c2                	cmp    %eax,%edx
  8003b9:	74 14                	je     8003cf <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8003bb:	83 ec 04             	sub    $0x4,%esp
  8003be:	68 98 20 80 00       	push   $0x802098
  8003c3:	6a 26                	push   $0x26
  8003c5:	68 e4 20 80 00       	push   $0x8020e4
  8003ca:	e8 5d ff ff ff       	call   80032c <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8003cf:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8003d6:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8003dd:	e9 c5 00 00 00       	jmp    8004a7 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  8003e2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003e5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8003ef:	01 d0                	add    %edx,%eax
  8003f1:	8b 00                	mov    (%eax),%eax
  8003f3:	85 c0                	test   %eax,%eax
  8003f5:	75 08                	jne    8003ff <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  8003f7:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8003fa:	e9 a5 00 00 00       	jmp    8004a4 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  8003ff:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800406:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  80040d:	eb 69                	jmp    800478 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  80040f:	a1 60 30 80 00       	mov    0x803060,%eax
  800414:	8b 88 a4 05 00 00    	mov    0x5a4(%eax),%ecx
  80041a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80041d:	89 d0                	mov    %edx,%eax
  80041f:	01 c0                	add    %eax,%eax
  800421:	01 d0                	add    %edx,%eax
  800423:	c1 e0 03             	shl    $0x3,%eax
  800426:	01 c8                	add    %ecx,%eax
  800428:	8a 40 04             	mov    0x4(%eax),%al
  80042b:	84 c0                	test   %al,%al
  80042d:	75 46                	jne    800475 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80042f:	a1 60 30 80 00       	mov    0x803060,%eax
  800434:	8b 88 a4 05 00 00    	mov    0x5a4(%eax),%ecx
  80043a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80043d:	89 d0                	mov    %edx,%eax
  80043f:	01 c0                	add    %eax,%eax
  800441:	01 d0                	add    %edx,%eax
  800443:	c1 e0 03             	shl    $0x3,%eax
  800446:	01 c8                	add    %ecx,%eax
  800448:	8b 00                	mov    (%eax),%eax
  80044a:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80044d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800450:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800455:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800457:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80045a:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800461:	8b 45 08             	mov    0x8(%ebp),%eax
  800464:	01 c8                	add    %ecx,%eax
  800466:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800468:	39 c2                	cmp    %eax,%edx
  80046a:	75 09                	jne    800475 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  80046c:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800473:	eb 15                	jmp    80048a <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800475:	ff 45 e8             	incl   -0x18(%ebp)
  800478:	a1 60 30 80 00       	mov    0x803060,%eax
  80047d:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800483:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800486:	39 c2                	cmp    %eax,%edx
  800488:	77 85                	ja     80040f <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  80048a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80048e:	75 14                	jne    8004a4 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  800490:	83 ec 04             	sub    $0x4,%esp
  800493:	68 f0 20 80 00       	push   $0x8020f0
  800498:	6a 3a                	push   $0x3a
  80049a:	68 e4 20 80 00       	push   $0x8020e4
  80049f:	e8 88 fe ff ff       	call   80032c <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8004a4:	ff 45 f0             	incl   -0x10(%ebp)
  8004a7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8004aa:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8004ad:	0f 8c 2f ff ff ff    	jl     8003e2 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8004b3:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8004ba:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8004c1:	eb 26                	jmp    8004e9 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  8004c3:	a1 60 30 80 00       	mov    0x803060,%eax
  8004c8:	8b 88 a4 05 00 00    	mov    0x5a4(%eax),%ecx
  8004ce:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8004d1:	89 d0                	mov    %edx,%eax
  8004d3:	01 c0                	add    %eax,%eax
  8004d5:	01 d0                	add    %edx,%eax
  8004d7:	c1 e0 03             	shl    $0x3,%eax
  8004da:	01 c8                	add    %ecx,%eax
  8004dc:	8a 40 04             	mov    0x4(%eax),%al
  8004df:	3c 01                	cmp    $0x1,%al
  8004e1:	75 03                	jne    8004e6 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  8004e3:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8004e6:	ff 45 e0             	incl   -0x20(%ebp)
  8004e9:	a1 60 30 80 00       	mov    0x803060,%eax
  8004ee:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8004f4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8004f7:	39 c2                	cmp    %eax,%edx
  8004f9:	77 c8                	ja     8004c3 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8004fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8004fe:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800501:	74 14                	je     800517 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  800503:	83 ec 04             	sub    $0x4,%esp
  800506:	68 44 21 80 00       	push   $0x802144
  80050b:	6a 44                	push   $0x44
  80050d:	68 e4 20 80 00       	push   $0x8020e4
  800512:	e8 15 fe ff ff       	call   80032c <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800517:	90                   	nop
  800518:	c9                   	leave  
  800519:	c3                   	ret    

0080051a <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  80051a:	55                   	push   %ebp
  80051b:	89 e5                	mov    %esp,%ebp
  80051d:	53                   	push   %ebx
  80051e:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  800521:	8b 45 0c             	mov    0xc(%ebp),%eax
  800524:	8b 00                	mov    (%eax),%eax
  800526:	8d 48 01             	lea    0x1(%eax),%ecx
  800529:	8b 55 0c             	mov    0xc(%ebp),%edx
  80052c:	89 0a                	mov    %ecx,(%edx)
  80052e:	8b 55 08             	mov    0x8(%ebp),%edx
  800531:	88 d1                	mov    %dl,%cl
  800533:	8b 55 0c             	mov    0xc(%ebp),%edx
  800536:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  80053a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80053d:	8b 00                	mov    (%eax),%eax
  80053f:	3d ff 00 00 00       	cmp    $0xff,%eax
  800544:	75 30                	jne    800576 <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  800546:	8b 15 7c 71 82 00    	mov    0x82717c,%edx
  80054c:	a0 84 30 80 00       	mov    0x803084,%al
  800551:	0f b6 c0             	movzbl %al,%eax
  800554:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800557:	8b 09                	mov    (%ecx),%ecx
  800559:	89 cb                	mov    %ecx,%ebx
  80055b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80055e:	83 c1 08             	add    $0x8,%ecx
  800561:	52                   	push   %edx
  800562:	50                   	push   %eax
  800563:	53                   	push   %ebx
  800564:	51                   	push   %ecx
  800565:	e8 a0 0f 00 00       	call   80150a <sys_cputs>
  80056a:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  80056d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800570:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800576:	8b 45 0c             	mov    0xc(%ebp),%eax
  800579:	8b 40 04             	mov    0x4(%eax),%eax
  80057c:	8d 50 01             	lea    0x1(%eax),%edx
  80057f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800582:	89 50 04             	mov    %edx,0x4(%eax)
}
  800585:	90                   	nop
  800586:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800589:	c9                   	leave  
  80058a:	c3                   	ret    

0080058b <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  80058b:	55                   	push   %ebp
  80058c:	89 e5                	mov    %esp,%ebp
  80058e:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800594:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80059b:	00 00 00 
	b.cnt = 0;
  80059e:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8005a5:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8005a8:	ff 75 0c             	pushl  0xc(%ebp)
  8005ab:	ff 75 08             	pushl  0x8(%ebp)
  8005ae:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8005b4:	50                   	push   %eax
  8005b5:	68 1a 05 80 00       	push   $0x80051a
  8005ba:	e8 5a 02 00 00       	call   800819 <vprintfmt>
  8005bf:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  8005c2:	8b 15 7c 71 82 00    	mov    0x82717c,%edx
  8005c8:	a0 84 30 80 00       	mov    0x803084,%al
  8005cd:	0f b6 c0             	movzbl %al,%eax
  8005d0:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  8005d6:	52                   	push   %edx
  8005d7:	50                   	push   %eax
  8005d8:	51                   	push   %ecx
  8005d9:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8005df:	83 c0 08             	add    $0x8,%eax
  8005e2:	50                   	push   %eax
  8005e3:	e8 22 0f 00 00       	call   80150a <sys_cputs>
  8005e8:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8005eb:	c6 05 84 30 80 00 00 	movb   $0x0,0x803084
	return b.cnt;
  8005f2:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8005f8:	c9                   	leave  
  8005f9:	c3                   	ret    

008005fa <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  8005fa:	55                   	push   %ebp
  8005fb:	89 e5                	mov    %esp,%ebp
  8005fd:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800600:	c6 05 84 30 80 00 01 	movb   $0x1,0x803084
	va_start(ap, fmt);
  800607:	8d 45 0c             	lea    0xc(%ebp),%eax
  80060a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80060d:	8b 45 08             	mov    0x8(%ebp),%eax
  800610:	83 ec 08             	sub    $0x8,%esp
  800613:	ff 75 f4             	pushl  -0xc(%ebp)
  800616:	50                   	push   %eax
  800617:	e8 6f ff ff ff       	call   80058b <vcprintf>
  80061c:	83 c4 10             	add    $0x10,%esp
  80061f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800622:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800625:	c9                   	leave  
  800626:	c3                   	ret    

00800627 <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  800627:	55                   	push   %ebp
  800628:	89 e5                	mov    %esp,%ebp
  80062a:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  80062d:	c6 05 84 30 80 00 01 	movb   $0x1,0x803084
	curTextClr = (textClr << 8) ; //set text color by the given value
  800634:	8b 45 08             	mov    0x8(%ebp),%eax
  800637:	c1 e0 08             	shl    $0x8,%eax
  80063a:	a3 7c 71 82 00       	mov    %eax,0x82717c
	va_start(ap, fmt);
  80063f:	8d 45 0c             	lea    0xc(%ebp),%eax
  800642:	83 c0 04             	add    $0x4,%eax
  800645:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800648:	8b 45 0c             	mov    0xc(%ebp),%eax
  80064b:	83 ec 08             	sub    $0x8,%esp
  80064e:	ff 75 f4             	pushl  -0xc(%ebp)
  800651:	50                   	push   %eax
  800652:	e8 34 ff ff ff       	call   80058b <vcprintf>
  800657:	83 c4 10             	add    $0x10,%esp
  80065a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  80065d:	c7 05 7c 71 82 00 00 	movl   $0x700,0x82717c
  800664:	07 00 00 

	return cnt;
  800667:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80066a:	c9                   	leave  
  80066b:	c3                   	ret    

0080066c <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  80066c:	55                   	push   %ebp
  80066d:	89 e5                	mov    %esp,%ebp
  80066f:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  800672:	e8 d7 0e 00 00       	call   80154e <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  800677:	8d 45 0c             	lea    0xc(%ebp),%eax
  80067a:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  80067d:	8b 45 08             	mov    0x8(%ebp),%eax
  800680:	83 ec 08             	sub    $0x8,%esp
  800683:	ff 75 f4             	pushl  -0xc(%ebp)
  800686:	50                   	push   %eax
  800687:	e8 ff fe ff ff       	call   80058b <vcprintf>
  80068c:	83 c4 10             	add    $0x10,%esp
  80068f:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  800692:	e8 d1 0e 00 00       	call   801568 <sys_unlock_cons>
	return cnt;
  800697:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80069a:	c9                   	leave  
  80069b:	c3                   	ret    

0080069c <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80069c:	55                   	push   %ebp
  80069d:	89 e5                	mov    %esp,%ebp
  80069f:	53                   	push   %ebx
  8006a0:	83 ec 14             	sub    $0x14,%esp
  8006a3:	8b 45 10             	mov    0x10(%ebp),%eax
  8006a6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8006a9:	8b 45 14             	mov    0x14(%ebp),%eax
  8006ac:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8006af:	8b 45 18             	mov    0x18(%ebp),%eax
  8006b2:	ba 00 00 00 00       	mov    $0x0,%edx
  8006b7:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8006ba:	77 55                	ja     800711 <printnum+0x75>
  8006bc:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8006bf:	72 05                	jb     8006c6 <printnum+0x2a>
  8006c1:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8006c4:	77 4b                	ja     800711 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8006c6:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8006c9:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8006cc:	8b 45 18             	mov    0x18(%ebp),%eax
  8006cf:	ba 00 00 00 00       	mov    $0x0,%edx
  8006d4:	52                   	push   %edx
  8006d5:	50                   	push   %eax
  8006d6:	ff 75 f4             	pushl  -0xc(%ebp)
  8006d9:	ff 75 f0             	pushl  -0x10(%ebp)
  8006dc:	e8 ab 13 00 00       	call   801a8c <__udivdi3>
  8006e1:	83 c4 10             	add    $0x10,%esp
  8006e4:	83 ec 04             	sub    $0x4,%esp
  8006e7:	ff 75 20             	pushl  0x20(%ebp)
  8006ea:	53                   	push   %ebx
  8006eb:	ff 75 18             	pushl  0x18(%ebp)
  8006ee:	52                   	push   %edx
  8006ef:	50                   	push   %eax
  8006f0:	ff 75 0c             	pushl  0xc(%ebp)
  8006f3:	ff 75 08             	pushl  0x8(%ebp)
  8006f6:	e8 a1 ff ff ff       	call   80069c <printnum>
  8006fb:	83 c4 20             	add    $0x20,%esp
  8006fe:	eb 1a                	jmp    80071a <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800700:	83 ec 08             	sub    $0x8,%esp
  800703:	ff 75 0c             	pushl  0xc(%ebp)
  800706:	ff 75 20             	pushl  0x20(%ebp)
  800709:	8b 45 08             	mov    0x8(%ebp),%eax
  80070c:	ff d0                	call   *%eax
  80070e:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800711:	ff 4d 1c             	decl   0x1c(%ebp)
  800714:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800718:	7f e6                	jg     800700 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80071a:	8b 4d 18             	mov    0x18(%ebp),%ecx
  80071d:	bb 00 00 00 00       	mov    $0x0,%ebx
  800722:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800725:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800728:	53                   	push   %ebx
  800729:	51                   	push   %ecx
  80072a:	52                   	push   %edx
  80072b:	50                   	push   %eax
  80072c:	e8 6b 14 00 00       	call   801b9c <__umoddi3>
  800731:	83 c4 10             	add    $0x10,%esp
  800734:	05 b4 23 80 00       	add    $0x8023b4,%eax
  800739:	8a 00                	mov    (%eax),%al
  80073b:	0f be c0             	movsbl %al,%eax
  80073e:	83 ec 08             	sub    $0x8,%esp
  800741:	ff 75 0c             	pushl  0xc(%ebp)
  800744:	50                   	push   %eax
  800745:	8b 45 08             	mov    0x8(%ebp),%eax
  800748:	ff d0                	call   *%eax
  80074a:	83 c4 10             	add    $0x10,%esp
}
  80074d:	90                   	nop
  80074e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800751:	c9                   	leave  
  800752:	c3                   	ret    

00800753 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800753:	55                   	push   %ebp
  800754:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800756:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80075a:	7e 1c                	jle    800778 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  80075c:	8b 45 08             	mov    0x8(%ebp),%eax
  80075f:	8b 00                	mov    (%eax),%eax
  800761:	8d 50 08             	lea    0x8(%eax),%edx
  800764:	8b 45 08             	mov    0x8(%ebp),%eax
  800767:	89 10                	mov    %edx,(%eax)
  800769:	8b 45 08             	mov    0x8(%ebp),%eax
  80076c:	8b 00                	mov    (%eax),%eax
  80076e:	83 e8 08             	sub    $0x8,%eax
  800771:	8b 50 04             	mov    0x4(%eax),%edx
  800774:	8b 00                	mov    (%eax),%eax
  800776:	eb 40                	jmp    8007b8 <getuint+0x65>
	else if (lflag)
  800778:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80077c:	74 1e                	je     80079c <getuint+0x49>
		return va_arg(*ap, unsigned long);
  80077e:	8b 45 08             	mov    0x8(%ebp),%eax
  800781:	8b 00                	mov    (%eax),%eax
  800783:	8d 50 04             	lea    0x4(%eax),%edx
  800786:	8b 45 08             	mov    0x8(%ebp),%eax
  800789:	89 10                	mov    %edx,(%eax)
  80078b:	8b 45 08             	mov    0x8(%ebp),%eax
  80078e:	8b 00                	mov    (%eax),%eax
  800790:	83 e8 04             	sub    $0x4,%eax
  800793:	8b 00                	mov    (%eax),%eax
  800795:	ba 00 00 00 00       	mov    $0x0,%edx
  80079a:	eb 1c                	jmp    8007b8 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  80079c:	8b 45 08             	mov    0x8(%ebp),%eax
  80079f:	8b 00                	mov    (%eax),%eax
  8007a1:	8d 50 04             	lea    0x4(%eax),%edx
  8007a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8007a7:	89 10                	mov    %edx,(%eax)
  8007a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8007ac:	8b 00                	mov    (%eax),%eax
  8007ae:	83 e8 04             	sub    $0x4,%eax
  8007b1:	8b 00                	mov    (%eax),%eax
  8007b3:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8007b8:	5d                   	pop    %ebp
  8007b9:	c3                   	ret    

008007ba <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8007ba:	55                   	push   %ebp
  8007bb:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8007bd:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8007c1:	7e 1c                	jle    8007df <getint+0x25>
		return va_arg(*ap, long long);
  8007c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8007c6:	8b 00                	mov    (%eax),%eax
  8007c8:	8d 50 08             	lea    0x8(%eax),%edx
  8007cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8007ce:	89 10                	mov    %edx,(%eax)
  8007d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8007d3:	8b 00                	mov    (%eax),%eax
  8007d5:	83 e8 08             	sub    $0x8,%eax
  8007d8:	8b 50 04             	mov    0x4(%eax),%edx
  8007db:	8b 00                	mov    (%eax),%eax
  8007dd:	eb 38                	jmp    800817 <getint+0x5d>
	else if (lflag)
  8007df:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8007e3:	74 1a                	je     8007ff <getint+0x45>
		return va_arg(*ap, long);
  8007e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8007e8:	8b 00                	mov    (%eax),%eax
  8007ea:	8d 50 04             	lea    0x4(%eax),%edx
  8007ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8007f0:	89 10                	mov    %edx,(%eax)
  8007f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8007f5:	8b 00                	mov    (%eax),%eax
  8007f7:	83 e8 04             	sub    $0x4,%eax
  8007fa:	8b 00                	mov    (%eax),%eax
  8007fc:	99                   	cltd   
  8007fd:	eb 18                	jmp    800817 <getint+0x5d>
	else
		return va_arg(*ap, int);
  8007ff:	8b 45 08             	mov    0x8(%ebp),%eax
  800802:	8b 00                	mov    (%eax),%eax
  800804:	8d 50 04             	lea    0x4(%eax),%edx
  800807:	8b 45 08             	mov    0x8(%ebp),%eax
  80080a:	89 10                	mov    %edx,(%eax)
  80080c:	8b 45 08             	mov    0x8(%ebp),%eax
  80080f:	8b 00                	mov    (%eax),%eax
  800811:	83 e8 04             	sub    $0x4,%eax
  800814:	8b 00                	mov    (%eax),%eax
  800816:	99                   	cltd   
}
  800817:	5d                   	pop    %ebp
  800818:	c3                   	ret    

00800819 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800819:	55                   	push   %ebp
  80081a:	89 e5                	mov    %esp,%ebp
  80081c:	56                   	push   %esi
  80081d:	53                   	push   %ebx
  80081e:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800821:	eb 17                	jmp    80083a <vprintfmt+0x21>
			if (ch == '\0')
  800823:	85 db                	test   %ebx,%ebx
  800825:	0f 84 c1 03 00 00    	je     800bec <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  80082b:	83 ec 08             	sub    $0x8,%esp
  80082e:	ff 75 0c             	pushl  0xc(%ebp)
  800831:	53                   	push   %ebx
  800832:	8b 45 08             	mov    0x8(%ebp),%eax
  800835:	ff d0                	call   *%eax
  800837:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80083a:	8b 45 10             	mov    0x10(%ebp),%eax
  80083d:	8d 50 01             	lea    0x1(%eax),%edx
  800840:	89 55 10             	mov    %edx,0x10(%ebp)
  800843:	8a 00                	mov    (%eax),%al
  800845:	0f b6 d8             	movzbl %al,%ebx
  800848:	83 fb 25             	cmp    $0x25,%ebx
  80084b:	75 d6                	jne    800823 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  80084d:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800851:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800858:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80085f:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800866:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80086d:	8b 45 10             	mov    0x10(%ebp),%eax
  800870:	8d 50 01             	lea    0x1(%eax),%edx
  800873:	89 55 10             	mov    %edx,0x10(%ebp)
  800876:	8a 00                	mov    (%eax),%al
  800878:	0f b6 d8             	movzbl %al,%ebx
  80087b:	8d 43 dd             	lea    -0x23(%ebx),%eax
  80087e:	83 f8 5b             	cmp    $0x5b,%eax
  800881:	0f 87 3d 03 00 00    	ja     800bc4 <vprintfmt+0x3ab>
  800887:	8b 04 85 d8 23 80 00 	mov    0x8023d8(,%eax,4),%eax
  80088e:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800890:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800894:	eb d7                	jmp    80086d <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800896:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  80089a:	eb d1                	jmp    80086d <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80089c:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8008a3:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8008a6:	89 d0                	mov    %edx,%eax
  8008a8:	c1 e0 02             	shl    $0x2,%eax
  8008ab:	01 d0                	add    %edx,%eax
  8008ad:	01 c0                	add    %eax,%eax
  8008af:	01 d8                	add    %ebx,%eax
  8008b1:	83 e8 30             	sub    $0x30,%eax
  8008b4:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8008b7:	8b 45 10             	mov    0x10(%ebp),%eax
  8008ba:	8a 00                	mov    (%eax),%al
  8008bc:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8008bf:	83 fb 2f             	cmp    $0x2f,%ebx
  8008c2:	7e 3e                	jle    800902 <vprintfmt+0xe9>
  8008c4:	83 fb 39             	cmp    $0x39,%ebx
  8008c7:	7f 39                	jg     800902 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8008c9:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8008cc:	eb d5                	jmp    8008a3 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8008ce:	8b 45 14             	mov    0x14(%ebp),%eax
  8008d1:	83 c0 04             	add    $0x4,%eax
  8008d4:	89 45 14             	mov    %eax,0x14(%ebp)
  8008d7:	8b 45 14             	mov    0x14(%ebp),%eax
  8008da:	83 e8 04             	sub    $0x4,%eax
  8008dd:	8b 00                	mov    (%eax),%eax
  8008df:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8008e2:	eb 1f                	jmp    800903 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8008e4:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008e8:	79 83                	jns    80086d <vprintfmt+0x54>
				width = 0;
  8008ea:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8008f1:	e9 77 ff ff ff       	jmp    80086d <vprintfmt+0x54>

		case '#':
			altflag = 1;
  8008f6:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  8008fd:	e9 6b ff ff ff       	jmp    80086d <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800902:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800903:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800907:	0f 89 60 ff ff ff    	jns    80086d <vprintfmt+0x54>
				width = precision, precision = -1;
  80090d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800910:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800913:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  80091a:	e9 4e ff ff ff       	jmp    80086d <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  80091f:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800922:	e9 46 ff ff ff       	jmp    80086d <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800927:	8b 45 14             	mov    0x14(%ebp),%eax
  80092a:	83 c0 04             	add    $0x4,%eax
  80092d:	89 45 14             	mov    %eax,0x14(%ebp)
  800930:	8b 45 14             	mov    0x14(%ebp),%eax
  800933:	83 e8 04             	sub    $0x4,%eax
  800936:	8b 00                	mov    (%eax),%eax
  800938:	83 ec 08             	sub    $0x8,%esp
  80093b:	ff 75 0c             	pushl  0xc(%ebp)
  80093e:	50                   	push   %eax
  80093f:	8b 45 08             	mov    0x8(%ebp),%eax
  800942:	ff d0                	call   *%eax
  800944:	83 c4 10             	add    $0x10,%esp
			break;
  800947:	e9 9b 02 00 00       	jmp    800be7 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  80094c:	8b 45 14             	mov    0x14(%ebp),%eax
  80094f:	83 c0 04             	add    $0x4,%eax
  800952:	89 45 14             	mov    %eax,0x14(%ebp)
  800955:	8b 45 14             	mov    0x14(%ebp),%eax
  800958:	83 e8 04             	sub    $0x4,%eax
  80095b:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  80095d:	85 db                	test   %ebx,%ebx
  80095f:	79 02                	jns    800963 <vprintfmt+0x14a>
				err = -err;
  800961:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800963:	83 fb 64             	cmp    $0x64,%ebx
  800966:	7f 0b                	jg     800973 <vprintfmt+0x15a>
  800968:	8b 34 9d 20 22 80 00 	mov    0x802220(,%ebx,4),%esi
  80096f:	85 f6                	test   %esi,%esi
  800971:	75 19                	jne    80098c <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800973:	53                   	push   %ebx
  800974:	68 c5 23 80 00       	push   $0x8023c5
  800979:	ff 75 0c             	pushl  0xc(%ebp)
  80097c:	ff 75 08             	pushl  0x8(%ebp)
  80097f:	e8 70 02 00 00       	call   800bf4 <printfmt>
  800984:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800987:	e9 5b 02 00 00       	jmp    800be7 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  80098c:	56                   	push   %esi
  80098d:	68 ce 23 80 00       	push   $0x8023ce
  800992:	ff 75 0c             	pushl  0xc(%ebp)
  800995:	ff 75 08             	pushl  0x8(%ebp)
  800998:	e8 57 02 00 00       	call   800bf4 <printfmt>
  80099d:	83 c4 10             	add    $0x10,%esp
			break;
  8009a0:	e9 42 02 00 00       	jmp    800be7 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8009a5:	8b 45 14             	mov    0x14(%ebp),%eax
  8009a8:	83 c0 04             	add    $0x4,%eax
  8009ab:	89 45 14             	mov    %eax,0x14(%ebp)
  8009ae:	8b 45 14             	mov    0x14(%ebp),%eax
  8009b1:	83 e8 04             	sub    $0x4,%eax
  8009b4:	8b 30                	mov    (%eax),%esi
  8009b6:	85 f6                	test   %esi,%esi
  8009b8:	75 05                	jne    8009bf <vprintfmt+0x1a6>
				p = "(null)";
  8009ba:	be d1 23 80 00       	mov    $0x8023d1,%esi
			if (width > 0 && padc != '-')
  8009bf:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8009c3:	7e 6d                	jle    800a32 <vprintfmt+0x219>
  8009c5:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8009c9:	74 67                	je     800a32 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8009cb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8009ce:	83 ec 08             	sub    $0x8,%esp
  8009d1:	50                   	push   %eax
  8009d2:	56                   	push   %esi
  8009d3:	e8 1e 03 00 00       	call   800cf6 <strnlen>
  8009d8:	83 c4 10             	add    $0x10,%esp
  8009db:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  8009de:	eb 16                	jmp    8009f6 <vprintfmt+0x1dd>
					putch(padc, putdat);
  8009e0:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  8009e4:	83 ec 08             	sub    $0x8,%esp
  8009e7:	ff 75 0c             	pushl  0xc(%ebp)
  8009ea:	50                   	push   %eax
  8009eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ee:	ff d0                	call   *%eax
  8009f0:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8009f3:	ff 4d e4             	decl   -0x1c(%ebp)
  8009f6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8009fa:	7f e4                	jg     8009e0 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8009fc:	eb 34                	jmp    800a32 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  8009fe:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800a02:	74 1c                	je     800a20 <vprintfmt+0x207>
  800a04:	83 fb 1f             	cmp    $0x1f,%ebx
  800a07:	7e 05                	jle    800a0e <vprintfmt+0x1f5>
  800a09:	83 fb 7e             	cmp    $0x7e,%ebx
  800a0c:	7e 12                	jle    800a20 <vprintfmt+0x207>
					putch('?', putdat);
  800a0e:	83 ec 08             	sub    $0x8,%esp
  800a11:	ff 75 0c             	pushl  0xc(%ebp)
  800a14:	6a 3f                	push   $0x3f
  800a16:	8b 45 08             	mov    0x8(%ebp),%eax
  800a19:	ff d0                	call   *%eax
  800a1b:	83 c4 10             	add    $0x10,%esp
  800a1e:	eb 0f                	jmp    800a2f <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800a20:	83 ec 08             	sub    $0x8,%esp
  800a23:	ff 75 0c             	pushl  0xc(%ebp)
  800a26:	53                   	push   %ebx
  800a27:	8b 45 08             	mov    0x8(%ebp),%eax
  800a2a:	ff d0                	call   *%eax
  800a2c:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800a2f:	ff 4d e4             	decl   -0x1c(%ebp)
  800a32:	89 f0                	mov    %esi,%eax
  800a34:	8d 70 01             	lea    0x1(%eax),%esi
  800a37:	8a 00                	mov    (%eax),%al
  800a39:	0f be d8             	movsbl %al,%ebx
  800a3c:	85 db                	test   %ebx,%ebx
  800a3e:	74 24                	je     800a64 <vprintfmt+0x24b>
  800a40:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800a44:	78 b8                	js     8009fe <vprintfmt+0x1e5>
  800a46:	ff 4d e0             	decl   -0x20(%ebp)
  800a49:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800a4d:	79 af                	jns    8009fe <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800a4f:	eb 13                	jmp    800a64 <vprintfmt+0x24b>
				putch(' ', putdat);
  800a51:	83 ec 08             	sub    $0x8,%esp
  800a54:	ff 75 0c             	pushl  0xc(%ebp)
  800a57:	6a 20                	push   $0x20
  800a59:	8b 45 08             	mov    0x8(%ebp),%eax
  800a5c:	ff d0                	call   *%eax
  800a5e:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800a61:	ff 4d e4             	decl   -0x1c(%ebp)
  800a64:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a68:	7f e7                	jg     800a51 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800a6a:	e9 78 01 00 00       	jmp    800be7 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800a6f:	83 ec 08             	sub    $0x8,%esp
  800a72:	ff 75 e8             	pushl  -0x18(%ebp)
  800a75:	8d 45 14             	lea    0x14(%ebp),%eax
  800a78:	50                   	push   %eax
  800a79:	e8 3c fd ff ff       	call   8007ba <getint>
  800a7e:	83 c4 10             	add    $0x10,%esp
  800a81:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a84:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800a87:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a8a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a8d:	85 d2                	test   %edx,%edx
  800a8f:	79 23                	jns    800ab4 <vprintfmt+0x29b>
				putch('-', putdat);
  800a91:	83 ec 08             	sub    $0x8,%esp
  800a94:	ff 75 0c             	pushl  0xc(%ebp)
  800a97:	6a 2d                	push   $0x2d
  800a99:	8b 45 08             	mov    0x8(%ebp),%eax
  800a9c:	ff d0                	call   *%eax
  800a9e:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800aa1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800aa4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800aa7:	f7 d8                	neg    %eax
  800aa9:	83 d2 00             	adc    $0x0,%edx
  800aac:	f7 da                	neg    %edx
  800aae:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ab1:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800ab4:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800abb:	e9 bc 00 00 00       	jmp    800b7c <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800ac0:	83 ec 08             	sub    $0x8,%esp
  800ac3:	ff 75 e8             	pushl  -0x18(%ebp)
  800ac6:	8d 45 14             	lea    0x14(%ebp),%eax
  800ac9:	50                   	push   %eax
  800aca:	e8 84 fc ff ff       	call   800753 <getuint>
  800acf:	83 c4 10             	add    $0x10,%esp
  800ad2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ad5:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800ad8:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800adf:	e9 98 00 00 00       	jmp    800b7c <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800ae4:	83 ec 08             	sub    $0x8,%esp
  800ae7:	ff 75 0c             	pushl  0xc(%ebp)
  800aea:	6a 58                	push   $0x58
  800aec:	8b 45 08             	mov    0x8(%ebp),%eax
  800aef:	ff d0                	call   *%eax
  800af1:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800af4:	83 ec 08             	sub    $0x8,%esp
  800af7:	ff 75 0c             	pushl  0xc(%ebp)
  800afa:	6a 58                	push   $0x58
  800afc:	8b 45 08             	mov    0x8(%ebp),%eax
  800aff:	ff d0                	call   *%eax
  800b01:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800b04:	83 ec 08             	sub    $0x8,%esp
  800b07:	ff 75 0c             	pushl  0xc(%ebp)
  800b0a:	6a 58                	push   $0x58
  800b0c:	8b 45 08             	mov    0x8(%ebp),%eax
  800b0f:	ff d0                	call   *%eax
  800b11:	83 c4 10             	add    $0x10,%esp
			break;
  800b14:	e9 ce 00 00 00       	jmp    800be7 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800b19:	83 ec 08             	sub    $0x8,%esp
  800b1c:	ff 75 0c             	pushl  0xc(%ebp)
  800b1f:	6a 30                	push   $0x30
  800b21:	8b 45 08             	mov    0x8(%ebp),%eax
  800b24:	ff d0                	call   *%eax
  800b26:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800b29:	83 ec 08             	sub    $0x8,%esp
  800b2c:	ff 75 0c             	pushl  0xc(%ebp)
  800b2f:	6a 78                	push   $0x78
  800b31:	8b 45 08             	mov    0x8(%ebp),%eax
  800b34:	ff d0                	call   *%eax
  800b36:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800b39:	8b 45 14             	mov    0x14(%ebp),%eax
  800b3c:	83 c0 04             	add    $0x4,%eax
  800b3f:	89 45 14             	mov    %eax,0x14(%ebp)
  800b42:	8b 45 14             	mov    0x14(%ebp),%eax
  800b45:	83 e8 04             	sub    $0x4,%eax
  800b48:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800b4a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b4d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800b54:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800b5b:	eb 1f                	jmp    800b7c <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800b5d:	83 ec 08             	sub    $0x8,%esp
  800b60:	ff 75 e8             	pushl  -0x18(%ebp)
  800b63:	8d 45 14             	lea    0x14(%ebp),%eax
  800b66:	50                   	push   %eax
  800b67:	e8 e7 fb ff ff       	call   800753 <getuint>
  800b6c:	83 c4 10             	add    $0x10,%esp
  800b6f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b72:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800b75:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800b7c:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800b80:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800b83:	83 ec 04             	sub    $0x4,%esp
  800b86:	52                   	push   %edx
  800b87:	ff 75 e4             	pushl  -0x1c(%ebp)
  800b8a:	50                   	push   %eax
  800b8b:	ff 75 f4             	pushl  -0xc(%ebp)
  800b8e:	ff 75 f0             	pushl  -0x10(%ebp)
  800b91:	ff 75 0c             	pushl  0xc(%ebp)
  800b94:	ff 75 08             	pushl  0x8(%ebp)
  800b97:	e8 00 fb ff ff       	call   80069c <printnum>
  800b9c:	83 c4 20             	add    $0x20,%esp
			break;
  800b9f:	eb 46                	jmp    800be7 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800ba1:	83 ec 08             	sub    $0x8,%esp
  800ba4:	ff 75 0c             	pushl  0xc(%ebp)
  800ba7:	53                   	push   %ebx
  800ba8:	8b 45 08             	mov    0x8(%ebp),%eax
  800bab:	ff d0                	call   *%eax
  800bad:	83 c4 10             	add    $0x10,%esp
			break;
  800bb0:	eb 35                	jmp    800be7 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800bb2:	c6 05 84 30 80 00 00 	movb   $0x0,0x803084
			break;
  800bb9:	eb 2c                	jmp    800be7 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800bbb:	c6 05 84 30 80 00 01 	movb   $0x1,0x803084
			break;
  800bc2:	eb 23                	jmp    800be7 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800bc4:	83 ec 08             	sub    $0x8,%esp
  800bc7:	ff 75 0c             	pushl  0xc(%ebp)
  800bca:	6a 25                	push   $0x25
  800bcc:	8b 45 08             	mov    0x8(%ebp),%eax
  800bcf:	ff d0                	call   *%eax
  800bd1:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800bd4:	ff 4d 10             	decl   0x10(%ebp)
  800bd7:	eb 03                	jmp    800bdc <vprintfmt+0x3c3>
  800bd9:	ff 4d 10             	decl   0x10(%ebp)
  800bdc:	8b 45 10             	mov    0x10(%ebp),%eax
  800bdf:	48                   	dec    %eax
  800be0:	8a 00                	mov    (%eax),%al
  800be2:	3c 25                	cmp    $0x25,%al
  800be4:	75 f3                	jne    800bd9 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800be6:	90                   	nop
		}
	}
  800be7:	e9 35 fc ff ff       	jmp    800821 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800bec:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800bed:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800bf0:	5b                   	pop    %ebx
  800bf1:	5e                   	pop    %esi
  800bf2:	5d                   	pop    %ebp
  800bf3:	c3                   	ret    

00800bf4 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800bf4:	55                   	push   %ebp
  800bf5:	89 e5                	mov    %esp,%ebp
  800bf7:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800bfa:	8d 45 10             	lea    0x10(%ebp),%eax
  800bfd:	83 c0 04             	add    $0x4,%eax
  800c00:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800c03:	8b 45 10             	mov    0x10(%ebp),%eax
  800c06:	ff 75 f4             	pushl  -0xc(%ebp)
  800c09:	50                   	push   %eax
  800c0a:	ff 75 0c             	pushl  0xc(%ebp)
  800c0d:	ff 75 08             	pushl  0x8(%ebp)
  800c10:	e8 04 fc ff ff       	call   800819 <vprintfmt>
  800c15:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800c18:	90                   	nop
  800c19:	c9                   	leave  
  800c1a:	c3                   	ret    

00800c1b <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800c1b:	55                   	push   %ebp
  800c1c:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800c1e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c21:	8b 40 08             	mov    0x8(%eax),%eax
  800c24:	8d 50 01             	lea    0x1(%eax),%edx
  800c27:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c2a:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800c2d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c30:	8b 10                	mov    (%eax),%edx
  800c32:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c35:	8b 40 04             	mov    0x4(%eax),%eax
  800c38:	39 c2                	cmp    %eax,%edx
  800c3a:	73 12                	jae    800c4e <sprintputch+0x33>
		*b->buf++ = ch;
  800c3c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c3f:	8b 00                	mov    (%eax),%eax
  800c41:	8d 48 01             	lea    0x1(%eax),%ecx
  800c44:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c47:	89 0a                	mov    %ecx,(%edx)
  800c49:	8b 55 08             	mov    0x8(%ebp),%edx
  800c4c:	88 10                	mov    %dl,(%eax)
}
  800c4e:	90                   	nop
  800c4f:	5d                   	pop    %ebp
  800c50:	c3                   	ret    

00800c51 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800c51:	55                   	push   %ebp
  800c52:	89 e5                	mov    %esp,%ebp
  800c54:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800c57:	8b 45 08             	mov    0x8(%ebp),%eax
  800c5a:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800c5d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c60:	8d 50 ff             	lea    -0x1(%eax),%edx
  800c63:	8b 45 08             	mov    0x8(%ebp),%eax
  800c66:	01 d0                	add    %edx,%eax
  800c68:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c6b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800c72:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800c76:	74 06                	je     800c7e <vsnprintf+0x2d>
  800c78:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c7c:	7f 07                	jg     800c85 <vsnprintf+0x34>
		return -E_INVAL;
  800c7e:	b8 03 00 00 00       	mov    $0x3,%eax
  800c83:	eb 20                	jmp    800ca5 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800c85:	ff 75 14             	pushl  0x14(%ebp)
  800c88:	ff 75 10             	pushl  0x10(%ebp)
  800c8b:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800c8e:	50                   	push   %eax
  800c8f:	68 1b 0c 80 00       	push   $0x800c1b
  800c94:	e8 80 fb ff ff       	call   800819 <vprintfmt>
  800c99:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800c9c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800c9f:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800ca2:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800ca5:	c9                   	leave  
  800ca6:	c3                   	ret    

00800ca7 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800ca7:	55                   	push   %ebp
  800ca8:	89 e5                	mov    %esp,%ebp
  800caa:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800cad:	8d 45 10             	lea    0x10(%ebp),%eax
  800cb0:	83 c0 04             	add    $0x4,%eax
  800cb3:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800cb6:	8b 45 10             	mov    0x10(%ebp),%eax
  800cb9:	ff 75 f4             	pushl  -0xc(%ebp)
  800cbc:	50                   	push   %eax
  800cbd:	ff 75 0c             	pushl  0xc(%ebp)
  800cc0:	ff 75 08             	pushl  0x8(%ebp)
  800cc3:	e8 89 ff ff ff       	call   800c51 <vsnprintf>
  800cc8:	83 c4 10             	add    $0x10,%esp
  800ccb:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800cce:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800cd1:	c9                   	leave  
  800cd2:	c3                   	ret    

00800cd3 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800cd3:	55                   	push   %ebp
  800cd4:	89 e5                	mov    %esp,%ebp
  800cd6:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800cd9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800ce0:	eb 06                	jmp    800ce8 <strlen+0x15>
		n++;
  800ce2:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800ce5:	ff 45 08             	incl   0x8(%ebp)
  800ce8:	8b 45 08             	mov    0x8(%ebp),%eax
  800ceb:	8a 00                	mov    (%eax),%al
  800ced:	84 c0                	test   %al,%al
  800cef:	75 f1                	jne    800ce2 <strlen+0xf>
		n++;
	return n;
  800cf1:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800cf4:	c9                   	leave  
  800cf5:	c3                   	ret    

00800cf6 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800cf6:	55                   	push   %ebp
  800cf7:	89 e5                	mov    %esp,%ebp
  800cf9:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800cfc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800d03:	eb 09                	jmp    800d0e <strnlen+0x18>
		n++;
  800d05:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800d08:	ff 45 08             	incl   0x8(%ebp)
  800d0b:	ff 4d 0c             	decl   0xc(%ebp)
  800d0e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d12:	74 09                	je     800d1d <strnlen+0x27>
  800d14:	8b 45 08             	mov    0x8(%ebp),%eax
  800d17:	8a 00                	mov    (%eax),%al
  800d19:	84 c0                	test   %al,%al
  800d1b:	75 e8                	jne    800d05 <strnlen+0xf>
		n++;
	return n;
  800d1d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800d20:	c9                   	leave  
  800d21:	c3                   	ret    

00800d22 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800d22:	55                   	push   %ebp
  800d23:	89 e5                	mov    %esp,%ebp
  800d25:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800d28:	8b 45 08             	mov    0x8(%ebp),%eax
  800d2b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800d2e:	90                   	nop
  800d2f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d32:	8d 50 01             	lea    0x1(%eax),%edx
  800d35:	89 55 08             	mov    %edx,0x8(%ebp)
  800d38:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d3b:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d3e:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800d41:	8a 12                	mov    (%edx),%dl
  800d43:	88 10                	mov    %dl,(%eax)
  800d45:	8a 00                	mov    (%eax),%al
  800d47:	84 c0                	test   %al,%al
  800d49:	75 e4                	jne    800d2f <strcpy+0xd>
		/* do nothing */;
	return ret;
  800d4b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800d4e:	c9                   	leave  
  800d4f:	c3                   	ret    

00800d50 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800d50:	55                   	push   %ebp
  800d51:	89 e5                	mov    %esp,%ebp
  800d53:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800d56:	8b 45 08             	mov    0x8(%ebp),%eax
  800d59:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800d5c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800d63:	eb 1f                	jmp    800d84 <strncpy+0x34>
		*dst++ = *src;
  800d65:	8b 45 08             	mov    0x8(%ebp),%eax
  800d68:	8d 50 01             	lea    0x1(%eax),%edx
  800d6b:	89 55 08             	mov    %edx,0x8(%ebp)
  800d6e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d71:	8a 12                	mov    (%edx),%dl
  800d73:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800d75:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d78:	8a 00                	mov    (%eax),%al
  800d7a:	84 c0                	test   %al,%al
  800d7c:	74 03                	je     800d81 <strncpy+0x31>
			src++;
  800d7e:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800d81:	ff 45 fc             	incl   -0x4(%ebp)
  800d84:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d87:	3b 45 10             	cmp    0x10(%ebp),%eax
  800d8a:	72 d9                	jb     800d65 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800d8c:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800d8f:	c9                   	leave  
  800d90:	c3                   	ret    

00800d91 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800d91:	55                   	push   %ebp
  800d92:	89 e5                	mov    %esp,%ebp
  800d94:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800d97:	8b 45 08             	mov    0x8(%ebp),%eax
  800d9a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800d9d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800da1:	74 30                	je     800dd3 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800da3:	eb 16                	jmp    800dbb <strlcpy+0x2a>
			*dst++ = *src++;
  800da5:	8b 45 08             	mov    0x8(%ebp),%eax
  800da8:	8d 50 01             	lea    0x1(%eax),%edx
  800dab:	89 55 08             	mov    %edx,0x8(%ebp)
  800dae:	8b 55 0c             	mov    0xc(%ebp),%edx
  800db1:	8d 4a 01             	lea    0x1(%edx),%ecx
  800db4:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800db7:	8a 12                	mov    (%edx),%dl
  800db9:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800dbb:	ff 4d 10             	decl   0x10(%ebp)
  800dbe:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800dc2:	74 09                	je     800dcd <strlcpy+0x3c>
  800dc4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dc7:	8a 00                	mov    (%eax),%al
  800dc9:	84 c0                	test   %al,%al
  800dcb:	75 d8                	jne    800da5 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800dcd:	8b 45 08             	mov    0x8(%ebp),%eax
  800dd0:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800dd3:	8b 55 08             	mov    0x8(%ebp),%edx
  800dd6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800dd9:	29 c2                	sub    %eax,%edx
  800ddb:	89 d0                	mov    %edx,%eax
}
  800ddd:	c9                   	leave  
  800dde:	c3                   	ret    

00800ddf <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800ddf:	55                   	push   %ebp
  800de0:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800de2:	eb 06                	jmp    800dea <strcmp+0xb>
		p++, q++;
  800de4:	ff 45 08             	incl   0x8(%ebp)
  800de7:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800dea:	8b 45 08             	mov    0x8(%ebp),%eax
  800ded:	8a 00                	mov    (%eax),%al
  800def:	84 c0                	test   %al,%al
  800df1:	74 0e                	je     800e01 <strcmp+0x22>
  800df3:	8b 45 08             	mov    0x8(%ebp),%eax
  800df6:	8a 10                	mov    (%eax),%dl
  800df8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dfb:	8a 00                	mov    (%eax),%al
  800dfd:	38 c2                	cmp    %al,%dl
  800dff:	74 e3                	je     800de4 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800e01:	8b 45 08             	mov    0x8(%ebp),%eax
  800e04:	8a 00                	mov    (%eax),%al
  800e06:	0f b6 d0             	movzbl %al,%edx
  800e09:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e0c:	8a 00                	mov    (%eax),%al
  800e0e:	0f b6 c0             	movzbl %al,%eax
  800e11:	29 c2                	sub    %eax,%edx
  800e13:	89 d0                	mov    %edx,%eax
}
  800e15:	5d                   	pop    %ebp
  800e16:	c3                   	ret    

00800e17 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800e17:	55                   	push   %ebp
  800e18:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800e1a:	eb 09                	jmp    800e25 <strncmp+0xe>
		n--, p++, q++;
  800e1c:	ff 4d 10             	decl   0x10(%ebp)
  800e1f:	ff 45 08             	incl   0x8(%ebp)
  800e22:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800e25:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e29:	74 17                	je     800e42 <strncmp+0x2b>
  800e2b:	8b 45 08             	mov    0x8(%ebp),%eax
  800e2e:	8a 00                	mov    (%eax),%al
  800e30:	84 c0                	test   %al,%al
  800e32:	74 0e                	je     800e42 <strncmp+0x2b>
  800e34:	8b 45 08             	mov    0x8(%ebp),%eax
  800e37:	8a 10                	mov    (%eax),%dl
  800e39:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e3c:	8a 00                	mov    (%eax),%al
  800e3e:	38 c2                	cmp    %al,%dl
  800e40:	74 da                	je     800e1c <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800e42:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e46:	75 07                	jne    800e4f <strncmp+0x38>
		return 0;
  800e48:	b8 00 00 00 00       	mov    $0x0,%eax
  800e4d:	eb 14                	jmp    800e63 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800e4f:	8b 45 08             	mov    0x8(%ebp),%eax
  800e52:	8a 00                	mov    (%eax),%al
  800e54:	0f b6 d0             	movzbl %al,%edx
  800e57:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e5a:	8a 00                	mov    (%eax),%al
  800e5c:	0f b6 c0             	movzbl %al,%eax
  800e5f:	29 c2                	sub    %eax,%edx
  800e61:	89 d0                	mov    %edx,%eax
}
  800e63:	5d                   	pop    %ebp
  800e64:	c3                   	ret    

00800e65 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800e65:	55                   	push   %ebp
  800e66:	89 e5                	mov    %esp,%ebp
  800e68:	83 ec 04             	sub    $0x4,%esp
  800e6b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e6e:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800e71:	eb 12                	jmp    800e85 <strchr+0x20>
		if (*s == c)
  800e73:	8b 45 08             	mov    0x8(%ebp),%eax
  800e76:	8a 00                	mov    (%eax),%al
  800e78:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800e7b:	75 05                	jne    800e82 <strchr+0x1d>
			return (char *) s;
  800e7d:	8b 45 08             	mov    0x8(%ebp),%eax
  800e80:	eb 11                	jmp    800e93 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800e82:	ff 45 08             	incl   0x8(%ebp)
  800e85:	8b 45 08             	mov    0x8(%ebp),%eax
  800e88:	8a 00                	mov    (%eax),%al
  800e8a:	84 c0                	test   %al,%al
  800e8c:	75 e5                	jne    800e73 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800e8e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e93:	c9                   	leave  
  800e94:	c3                   	ret    

00800e95 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800e95:	55                   	push   %ebp
  800e96:	89 e5                	mov    %esp,%ebp
  800e98:	83 ec 04             	sub    $0x4,%esp
  800e9b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e9e:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800ea1:	eb 0d                	jmp    800eb0 <strfind+0x1b>
		if (*s == c)
  800ea3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ea6:	8a 00                	mov    (%eax),%al
  800ea8:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800eab:	74 0e                	je     800ebb <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800ead:	ff 45 08             	incl   0x8(%ebp)
  800eb0:	8b 45 08             	mov    0x8(%ebp),%eax
  800eb3:	8a 00                	mov    (%eax),%al
  800eb5:	84 c0                	test   %al,%al
  800eb7:	75 ea                	jne    800ea3 <strfind+0xe>
  800eb9:	eb 01                	jmp    800ebc <strfind+0x27>
		if (*s == c)
			break;
  800ebb:	90                   	nop
	return (char *) s;
  800ebc:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ebf:	c9                   	leave  
  800ec0:	c3                   	ret    

00800ec1 <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  800ec1:	55                   	push   %ebp
  800ec2:	89 e5                	mov    %esp,%ebp
  800ec4:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  800ec7:	8b 45 08             	mov    0x8(%ebp),%eax
  800eca:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  800ecd:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800ed1:	76 63                	jbe    800f36 <memset+0x75>
		uint64 data_block = c;
  800ed3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ed6:	99                   	cltd   
  800ed7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800eda:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  800edd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ee0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ee3:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  800ee7:	c1 e0 08             	shl    $0x8,%eax
  800eea:	09 45 f0             	or     %eax,-0x10(%ebp)
  800eed:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  800ef0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ef3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ef6:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  800efa:	c1 e0 10             	shl    $0x10,%eax
  800efd:	09 45 f0             	or     %eax,-0x10(%ebp)
  800f00:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  800f03:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800f06:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f09:	89 c2                	mov    %eax,%edx
  800f0b:	b8 00 00 00 00       	mov    $0x0,%eax
  800f10:	09 45 f0             	or     %eax,-0x10(%ebp)
  800f13:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  800f16:	eb 18                	jmp    800f30 <memset+0x6f>
			*p64++ = data_block, n -= 8;
  800f18:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  800f1b:	8d 41 08             	lea    0x8(%ecx),%eax
  800f1e:	89 45 fc             	mov    %eax,-0x4(%ebp)
  800f21:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800f24:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f27:	89 01                	mov    %eax,(%ecx)
  800f29:	89 51 04             	mov    %edx,0x4(%ecx)
  800f2c:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  800f30:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800f34:	77 e2                	ja     800f18 <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  800f36:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f3a:	74 23                	je     800f5f <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  800f3c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f3f:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  800f42:	eb 0e                	jmp    800f52 <memset+0x91>
			*p8++ = (uint8)c;
  800f44:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f47:	8d 50 01             	lea    0x1(%eax),%edx
  800f4a:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800f4d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f50:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  800f52:	8b 45 10             	mov    0x10(%ebp),%eax
  800f55:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f58:	89 55 10             	mov    %edx,0x10(%ebp)
  800f5b:	85 c0                	test   %eax,%eax
  800f5d:	75 e5                	jne    800f44 <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  800f5f:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f62:	c9                   	leave  
  800f63:	c3                   	ret    

00800f64 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800f64:	55                   	push   %ebp
  800f65:	89 e5                	mov    %esp,%ebp
  800f67:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  800f6a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f6d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  800f70:	8b 45 08             	mov    0x8(%ebp),%eax
  800f73:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  800f76:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800f7a:	76 24                	jbe    800fa0 <memcpy+0x3c>
		while(n >= 8){
  800f7c:	eb 1c                	jmp    800f9a <memcpy+0x36>
			*d64 = *s64;
  800f7e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f81:	8b 50 04             	mov    0x4(%eax),%edx
  800f84:	8b 00                	mov    (%eax),%eax
  800f86:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  800f89:	89 01                	mov    %eax,(%ecx)
  800f8b:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  800f8e:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  800f92:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  800f96:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  800f9a:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800f9e:	77 de                	ja     800f7e <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  800fa0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fa4:	74 31                	je     800fd7 <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  800fa6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fa9:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  800fac:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800faf:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  800fb2:	eb 16                	jmp    800fca <memcpy+0x66>
			*d8++ = *s8++;
  800fb4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800fb7:	8d 50 01             	lea    0x1(%eax),%edx
  800fba:	89 55 f0             	mov    %edx,-0x10(%ebp)
  800fbd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800fc0:	8d 4a 01             	lea    0x1(%edx),%ecx
  800fc3:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  800fc6:	8a 12                	mov    (%edx),%dl
  800fc8:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  800fca:	8b 45 10             	mov    0x10(%ebp),%eax
  800fcd:	8d 50 ff             	lea    -0x1(%eax),%edx
  800fd0:	89 55 10             	mov    %edx,0x10(%ebp)
  800fd3:	85 c0                	test   %eax,%eax
  800fd5:	75 dd                	jne    800fb4 <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  800fd7:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800fda:	c9                   	leave  
  800fdb:	c3                   	ret    

00800fdc <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800fdc:	55                   	push   %ebp
  800fdd:	89 e5                	mov    %esp,%ebp
  800fdf:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800fe2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fe5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800fe8:	8b 45 08             	mov    0x8(%ebp),%eax
  800feb:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800fee:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ff1:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800ff4:	73 50                	jae    801046 <memmove+0x6a>
  800ff6:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800ff9:	8b 45 10             	mov    0x10(%ebp),%eax
  800ffc:	01 d0                	add    %edx,%eax
  800ffe:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801001:	76 43                	jbe    801046 <memmove+0x6a>
		s += n;
  801003:	8b 45 10             	mov    0x10(%ebp),%eax
  801006:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801009:	8b 45 10             	mov    0x10(%ebp),%eax
  80100c:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  80100f:	eb 10                	jmp    801021 <memmove+0x45>
			*--d = *--s;
  801011:	ff 4d f8             	decl   -0x8(%ebp)
  801014:	ff 4d fc             	decl   -0x4(%ebp)
  801017:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80101a:	8a 10                	mov    (%eax),%dl
  80101c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80101f:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  801021:	8b 45 10             	mov    0x10(%ebp),%eax
  801024:	8d 50 ff             	lea    -0x1(%eax),%edx
  801027:	89 55 10             	mov    %edx,0x10(%ebp)
  80102a:	85 c0                	test   %eax,%eax
  80102c:	75 e3                	jne    801011 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  80102e:	eb 23                	jmp    801053 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  801030:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801033:	8d 50 01             	lea    0x1(%eax),%edx
  801036:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801039:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80103c:	8d 4a 01             	lea    0x1(%edx),%ecx
  80103f:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801042:	8a 12                	mov    (%edx),%dl
  801044:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801046:	8b 45 10             	mov    0x10(%ebp),%eax
  801049:	8d 50 ff             	lea    -0x1(%eax),%edx
  80104c:	89 55 10             	mov    %edx,0x10(%ebp)
  80104f:	85 c0                	test   %eax,%eax
  801051:	75 dd                	jne    801030 <memmove+0x54>
			*d++ = *s++;

	return dst;
  801053:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801056:	c9                   	leave  
  801057:	c3                   	ret    

00801058 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  801058:	55                   	push   %ebp
  801059:	89 e5                	mov    %esp,%ebp
  80105b:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  80105e:	8b 45 08             	mov    0x8(%ebp),%eax
  801061:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  801064:	8b 45 0c             	mov    0xc(%ebp),%eax
  801067:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  80106a:	eb 2a                	jmp    801096 <memcmp+0x3e>
		if (*s1 != *s2)
  80106c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80106f:	8a 10                	mov    (%eax),%dl
  801071:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801074:	8a 00                	mov    (%eax),%al
  801076:	38 c2                	cmp    %al,%dl
  801078:	74 16                	je     801090 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  80107a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80107d:	8a 00                	mov    (%eax),%al
  80107f:	0f b6 d0             	movzbl %al,%edx
  801082:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801085:	8a 00                	mov    (%eax),%al
  801087:	0f b6 c0             	movzbl %al,%eax
  80108a:	29 c2                	sub    %eax,%edx
  80108c:	89 d0                	mov    %edx,%eax
  80108e:	eb 18                	jmp    8010a8 <memcmp+0x50>
		s1++, s2++;
  801090:	ff 45 fc             	incl   -0x4(%ebp)
  801093:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801096:	8b 45 10             	mov    0x10(%ebp),%eax
  801099:	8d 50 ff             	lea    -0x1(%eax),%edx
  80109c:	89 55 10             	mov    %edx,0x10(%ebp)
  80109f:	85 c0                	test   %eax,%eax
  8010a1:	75 c9                	jne    80106c <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8010a3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8010a8:	c9                   	leave  
  8010a9:	c3                   	ret    

008010aa <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  8010aa:	55                   	push   %ebp
  8010ab:	89 e5                	mov    %esp,%ebp
  8010ad:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  8010b0:	8b 55 08             	mov    0x8(%ebp),%edx
  8010b3:	8b 45 10             	mov    0x10(%ebp),%eax
  8010b6:	01 d0                	add    %edx,%eax
  8010b8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  8010bb:	eb 15                	jmp    8010d2 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  8010bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c0:	8a 00                	mov    (%eax),%al
  8010c2:	0f b6 d0             	movzbl %al,%edx
  8010c5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010c8:	0f b6 c0             	movzbl %al,%eax
  8010cb:	39 c2                	cmp    %eax,%edx
  8010cd:	74 0d                	je     8010dc <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8010cf:	ff 45 08             	incl   0x8(%ebp)
  8010d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8010d5:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8010d8:	72 e3                	jb     8010bd <memfind+0x13>
  8010da:	eb 01                	jmp    8010dd <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  8010dc:	90                   	nop
	return (void *) s;
  8010dd:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8010e0:	c9                   	leave  
  8010e1:	c3                   	ret    

008010e2 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8010e2:	55                   	push   %ebp
  8010e3:	89 e5                	mov    %esp,%ebp
  8010e5:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  8010e8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  8010ef:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8010f6:	eb 03                	jmp    8010fb <strtol+0x19>
		s++;
  8010f8:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8010fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8010fe:	8a 00                	mov    (%eax),%al
  801100:	3c 20                	cmp    $0x20,%al
  801102:	74 f4                	je     8010f8 <strtol+0x16>
  801104:	8b 45 08             	mov    0x8(%ebp),%eax
  801107:	8a 00                	mov    (%eax),%al
  801109:	3c 09                	cmp    $0x9,%al
  80110b:	74 eb                	je     8010f8 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  80110d:	8b 45 08             	mov    0x8(%ebp),%eax
  801110:	8a 00                	mov    (%eax),%al
  801112:	3c 2b                	cmp    $0x2b,%al
  801114:	75 05                	jne    80111b <strtol+0x39>
		s++;
  801116:	ff 45 08             	incl   0x8(%ebp)
  801119:	eb 13                	jmp    80112e <strtol+0x4c>
	else if (*s == '-')
  80111b:	8b 45 08             	mov    0x8(%ebp),%eax
  80111e:	8a 00                	mov    (%eax),%al
  801120:	3c 2d                	cmp    $0x2d,%al
  801122:	75 0a                	jne    80112e <strtol+0x4c>
		s++, neg = 1;
  801124:	ff 45 08             	incl   0x8(%ebp)
  801127:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80112e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801132:	74 06                	je     80113a <strtol+0x58>
  801134:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801138:	75 20                	jne    80115a <strtol+0x78>
  80113a:	8b 45 08             	mov    0x8(%ebp),%eax
  80113d:	8a 00                	mov    (%eax),%al
  80113f:	3c 30                	cmp    $0x30,%al
  801141:	75 17                	jne    80115a <strtol+0x78>
  801143:	8b 45 08             	mov    0x8(%ebp),%eax
  801146:	40                   	inc    %eax
  801147:	8a 00                	mov    (%eax),%al
  801149:	3c 78                	cmp    $0x78,%al
  80114b:	75 0d                	jne    80115a <strtol+0x78>
		s += 2, base = 16;
  80114d:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801151:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801158:	eb 28                	jmp    801182 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  80115a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80115e:	75 15                	jne    801175 <strtol+0x93>
  801160:	8b 45 08             	mov    0x8(%ebp),%eax
  801163:	8a 00                	mov    (%eax),%al
  801165:	3c 30                	cmp    $0x30,%al
  801167:	75 0c                	jne    801175 <strtol+0x93>
		s++, base = 8;
  801169:	ff 45 08             	incl   0x8(%ebp)
  80116c:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801173:	eb 0d                	jmp    801182 <strtol+0xa0>
	else if (base == 0)
  801175:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801179:	75 07                	jne    801182 <strtol+0xa0>
		base = 10;
  80117b:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801182:	8b 45 08             	mov    0x8(%ebp),%eax
  801185:	8a 00                	mov    (%eax),%al
  801187:	3c 2f                	cmp    $0x2f,%al
  801189:	7e 19                	jle    8011a4 <strtol+0xc2>
  80118b:	8b 45 08             	mov    0x8(%ebp),%eax
  80118e:	8a 00                	mov    (%eax),%al
  801190:	3c 39                	cmp    $0x39,%al
  801192:	7f 10                	jg     8011a4 <strtol+0xc2>
			dig = *s - '0';
  801194:	8b 45 08             	mov    0x8(%ebp),%eax
  801197:	8a 00                	mov    (%eax),%al
  801199:	0f be c0             	movsbl %al,%eax
  80119c:	83 e8 30             	sub    $0x30,%eax
  80119f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8011a2:	eb 42                	jmp    8011e6 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  8011a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8011a7:	8a 00                	mov    (%eax),%al
  8011a9:	3c 60                	cmp    $0x60,%al
  8011ab:	7e 19                	jle    8011c6 <strtol+0xe4>
  8011ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8011b0:	8a 00                	mov    (%eax),%al
  8011b2:	3c 7a                	cmp    $0x7a,%al
  8011b4:	7f 10                	jg     8011c6 <strtol+0xe4>
			dig = *s - 'a' + 10;
  8011b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8011b9:	8a 00                	mov    (%eax),%al
  8011bb:	0f be c0             	movsbl %al,%eax
  8011be:	83 e8 57             	sub    $0x57,%eax
  8011c1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8011c4:	eb 20                	jmp    8011e6 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  8011c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8011c9:	8a 00                	mov    (%eax),%al
  8011cb:	3c 40                	cmp    $0x40,%al
  8011cd:	7e 39                	jle    801208 <strtol+0x126>
  8011cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8011d2:	8a 00                	mov    (%eax),%al
  8011d4:	3c 5a                	cmp    $0x5a,%al
  8011d6:	7f 30                	jg     801208 <strtol+0x126>
			dig = *s - 'A' + 10;
  8011d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8011db:	8a 00                	mov    (%eax),%al
  8011dd:	0f be c0             	movsbl %al,%eax
  8011e0:	83 e8 37             	sub    $0x37,%eax
  8011e3:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  8011e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8011e9:	3b 45 10             	cmp    0x10(%ebp),%eax
  8011ec:	7d 19                	jge    801207 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  8011ee:	ff 45 08             	incl   0x8(%ebp)
  8011f1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011f4:	0f af 45 10          	imul   0x10(%ebp),%eax
  8011f8:	89 c2                	mov    %eax,%edx
  8011fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8011fd:	01 d0                	add    %edx,%eax
  8011ff:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801202:	e9 7b ff ff ff       	jmp    801182 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801207:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801208:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80120c:	74 08                	je     801216 <strtol+0x134>
		*endptr = (char *) s;
  80120e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801211:	8b 55 08             	mov    0x8(%ebp),%edx
  801214:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801216:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80121a:	74 07                	je     801223 <strtol+0x141>
  80121c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80121f:	f7 d8                	neg    %eax
  801221:	eb 03                	jmp    801226 <strtol+0x144>
  801223:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801226:	c9                   	leave  
  801227:	c3                   	ret    

00801228 <ltostr>:

void
ltostr(long value, char *str)
{
  801228:	55                   	push   %ebp
  801229:	89 e5                	mov    %esp,%ebp
  80122b:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  80122e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801235:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  80123c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801240:	79 13                	jns    801255 <ltostr+0x2d>
	{
		neg = 1;
  801242:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801249:	8b 45 0c             	mov    0xc(%ebp),%eax
  80124c:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  80124f:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801252:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801255:	8b 45 08             	mov    0x8(%ebp),%eax
  801258:	b9 0a 00 00 00       	mov    $0xa,%ecx
  80125d:	99                   	cltd   
  80125e:	f7 f9                	idiv   %ecx
  801260:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801263:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801266:	8d 50 01             	lea    0x1(%eax),%edx
  801269:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80126c:	89 c2                	mov    %eax,%edx
  80126e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801271:	01 d0                	add    %edx,%eax
  801273:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801276:	83 c2 30             	add    $0x30,%edx
  801279:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  80127b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80127e:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801283:	f7 e9                	imul   %ecx
  801285:	c1 fa 02             	sar    $0x2,%edx
  801288:	89 c8                	mov    %ecx,%eax
  80128a:	c1 f8 1f             	sar    $0x1f,%eax
  80128d:	29 c2                	sub    %eax,%edx
  80128f:	89 d0                	mov    %edx,%eax
  801291:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  801294:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801298:	75 bb                	jne    801255 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  80129a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8012a1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012a4:	48                   	dec    %eax
  8012a5:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8012a8:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8012ac:	74 3d                	je     8012eb <ltostr+0xc3>
		start = 1 ;
  8012ae:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8012b5:	eb 34                	jmp    8012eb <ltostr+0xc3>
	{
		char tmp = str[start] ;
  8012b7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8012ba:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012bd:	01 d0                	add    %edx,%eax
  8012bf:	8a 00                	mov    (%eax),%al
  8012c1:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8012c4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8012c7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012ca:	01 c2                	add    %eax,%edx
  8012cc:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8012cf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012d2:	01 c8                	add    %ecx,%eax
  8012d4:	8a 00                	mov    (%eax),%al
  8012d6:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8012d8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8012db:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012de:	01 c2                	add    %eax,%edx
  8012e0:	8a 45 eb             	mov    -0x15(%ebp),%al
  8012e3:	88 02                	mov    %al,(%edx)
		start++ ;
  8012e5:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8012e8:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8012eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8012ee:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8012f1:	7c c4                	jl     8012b7 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8012f3:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8012f6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012f9:	01 d0                	add    %edx,%eax
  8012fb:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8012fe:	90                   	nop
  8012ff:	c9                   	leave  
  801300:	c3                   	ret    

00801301 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801301:	55                   	push   %ebp
  801302:	89 e5                	mov    %esp,%ebp
  801304:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801307:	ff 75 08             	pushl  0x8(%ebp)
  80130a:	e8 c4 f9 ff ff       	call   800cd3 <strlen>
  80130f:	83 c4 04             	add    $0x4,%esp
  801312:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801315:	ff 75 0c             	pushl  0xc(%ebp)
  801318:	e8 b6 f9 ff ff       	call   800cd3 <strlen>
  80131d:	83 c4 04             	add    $0x4,%esp
  801320:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801323:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  80132a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801331:	eb 17                	jmp    80134a <strcconcat+0x49>
		final[s] = str1[s] ;
  801333:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801336:	8b 45 10             	mov    0x10(%ebp),%eax
  801339:	01 c2                	add    %eax,%edx
  80133b:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80133e:	8b 45 08             	mov    0x8(%ebp),%eax
  801341:	01 c8                	add    %ecx,%eax
  801343:	8a 00                	mov    (%eax),%al
  801345:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801347:	ff 45 fc             	incl   -0x4(%ebp)
  80134a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80134d:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801350:	7c e1                	jl     801333 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801352:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801359:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801360:	eb 1f                	jmp    801381 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801362:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801365:	8d 50 01             	lea    0x1(%eax),%edx
  801368:	89 55 fc             	mov    %edx,-0x4(%ebp)
  80136b:	89 c2                	mov    %eax,%edx
  80136d:	8b 45 10             	mov    0x10(%ebp),%eax
  801370:	01 c2                	add    %eax,%edx
  801372:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801375:	8b 45 0c             	mov    0xc(%ebp),%eax
  801378:	01 c8                	add    %ecx,%eax
  80137a:	8a 00                	mov    (%eax),%al
  80137c:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  80137e:	ff 45 f8             	incl   -0x8(%ebp)
  801381:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801384:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801387:	7c d9                	jl     801362 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801389:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80138c:	8b 45 10             	mov    0x10(%ebp),%eax
  80138f:	01 d0                	add    %edx,%eax
  801391:	c6 00 00             	movb   $0x0,(%eax)
}
  801394:	90                   	nop
  801395:	c9                   	leave  
  801396:	c3                   	ret    

00801397 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801397:	55                   	push   %ebp
  801398:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  80139a:	8b 45 14             	mov    0x14(%ebp),%eax
  80139d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8013a3:	8b 45 14             	mov    0x14(%ebp),%eax
  8013a6:	8b 00                	mov    (%eax),%eax
  8013a8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8013af:	8b 45 10             	mov    0x10(%ebp),%eax
  8013b2:	01 d0                	add    %edx,%eax
  8013b4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8013ba:	eb 0c                	jmp    8013c8 <strsplit+0x31>
			*string++ = 0;
  8013bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8013bf:	8d 50 01             	lea    0x1(%eax),%edx
  8013c2:	89 55 08             	mov    %edx,0x8(%ebp)
  8013c5:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8013c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8013cb:	8a 00                	mov    (%eax),%al
  8013cd:	84 c0                	test   %al,%al
  8013cf:	74 18                	je     8013e9 <strsplit+0x52>
  8013d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8013d4:	8a 00                	mov    (%eax),%al
  8013d6:	0f be c0             	movsbl %al,%eax
  8013d9:	50                   	push   %eax
  8013da:	ff 75 0c             	pushl  0xc(%ebp)
  8013dd:	e8 83 fa ff ff       	call   800e65 <strchr>
  8013e2:	83 c4 08             	add    $0x8,%esp
  8013e5:	85 c0                	test   %eax,%eax
  8013e7:	75 d3                	jne    8013bc <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8013e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8013ec:	8a 00                	mov    (%eax),%al
  8013ee:	84 c0                	test   %al,%al
  8013f0:	74 5a                	je     80144c <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8013f2:	8b 45 14             	mov    0x14(%ebp),%eax
  8013f5:	8b 00                	mov    (%eax),%eax
  8013f7:	83 f8 0f             	cmp    $0xf,%eax
  8013fa:	75 07                	jne    801403 <strsplit+0x6c>
		{
			return 0;
  8013fc:	b8 00 00 00 00       	mov    $0x0,%eax
  801401:	eb 66                	jmp    801469 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801403:	8b 45 14             	mov    0x14(%ebp),%eax
  801406:	8b 00                	mov    (%eax),%eax
  801408:	8d 48 01             	lea    0x1(%eax),%ecx
  80140b:	8b 55 14             	mov    0x14(%ebp),%edx
  80140e:	89 0a                	mov    %ecx,(%edx)
  801410:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801417:	8b 45 10             	mov    0x10(%ebp),%eax
  80141a:	01 c2                	add    %eax,%edx
  80141c:	8b 45 08             	mov    0x8(%ebp),%eax
  80141f:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801421:	eb 03                	jmp    801426 <strsplit+0x8f>
			string++;
  801423:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801426:	8b 45 08             	mov    0x8(%ebp),%eax
  801429:	8a 00                	mov    (%eax),%al
  80142b:	84 c0                	test   %al,%al
  80142d:	74 8b                	je     8013ba <strsplit+0x23>
  80142f:	8b 45 08             	mov    0x8(%ebp),%eax
  801432:	8a 00                	mov    (%eax),%al
  801434:	0f be c0             	movsbl %al,%eax
  801437:	50                   	push   %eax
  801438:	ff 75 0c             	pushl  0xc(%ebp)
  80143b:	e8 25 fa ff ff       	call   800e65 <strchr>
  801440:	83 c4 08             	add    $0x8,%esp
  801443:	85 c0                	test   %eax,%eax
  801445:	74 dc                	je     801423 <strsplit+0x8c>
			string++;
	}
  801447:	e9 6e ff ff ff       	jmp    8013ba <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  80144c:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  80144d:	8b 45 14             	mov    0x14(%ebp),%eax
  801450:	8b 00                	mov    (%eax),%eax
  801452:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801459:	8b 45 10             	mov    0x10(%ebp),%eax
  80145c:	01 d0                	add    %edx,%eax
  80145e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801464:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801469:	c9                   	leave  
  80146a:	c3                   	ret    

0080146b <str2lower>:


char* str2lower(char *dst, const char *src)
{
  80146b:	55                   	push   %ebp
  80146c:	89 e5                	mov    %esp,%ebp
  80146e:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  801471:	8b 45 08             	mov    0x8(%ebp),%eax
  801474:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  801477:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80147e:	eb 4a                	jmp    8014ca <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  801480:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801483:	8b 45 08             	mov    0x8(%ebp),%eax
  801486:	01 c2                	add    %eax,%edx
  801488:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80148b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80148e:	01 c8                	add    %ecx,%eax
  801490:	8a 00                	mov    (%eax),%al
  801492:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  801494:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801497:	8b 45 0c             	mov    0xc(%ebp),%eax
  80149a:	01 d0                	add    %edx,%eax
  80149c:	8a 00                	mov    (%eax),%al
  80149e:	3c 40                	cmp    $0x40,%al
  8014a0:	7e 25                	jle    8014c7 <str2lower+0x5c>
  8014a2:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8014a5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014a8:	01 d0                	add    %edx,%eax
  8014aa:	8a 00                	mov    (%eax),%al
  8014ac:	3c 5a                	cmp    $0x5a,%al
  8014ae:	7f 17                	jg     8014c7 <str2lower+0x5c>
		{
			dst[i] += 32 ;
  8014b0:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8014b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8014b6:	01 d0                	add    %edx,%eax
  8014b8:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8014bb:	8b 55 08             	mov    0x8(%ebp),%edx
  8014be:	01 ca                	add    %ecx,%edx
  8014c0:	8a 12                	mov    (%edx),%dl
  8014c2:	83 c2 20             	add    $0x20,%edx
  8014c5:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  8014c7:	ff 45 fc             	incl   -0x4(%ebp)
  8014ca:	ff 75 0c             	pushl  0xc(%ebp)
  8014cd:	e8 01 f8 ff ff       	call   800cd3 <strlen>
  8014d2:	83 c4 04             	add    $0x4,%esp
  8014d5:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8014d8:	7f a6                	jg     801480 <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  8014da:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8014dd:	c9                   	leave  
  8014de:	c3                   	ret    

008014df <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8014df:	55                   	push   %ebp
  8014e0:	89 e5                	mov    %esp,%ebp
  8014e2:	57                   	push   %edi
  8014e3:	56                   	push   %esi
  8014e4:	53                   	push   %ebx
  8014e5:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8014e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8014eb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014ee:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8014f1:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8014f4:	8b 7d 18             	mov    0x18(%ebp),%edi
  8014f7:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8014fa:	cd 30                	int    $0x30
  8014fc:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  8014ff:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801502:	83 c4 10             	add    $0x10,%esp
  801505:	5b                   	pop    %ebx
  801506:	5e                   	pop    %esi
  801507:	5f                   	pop    %edi
  801508:	5d                   	pop    %ebp
  801509:	c3                   	ret    

0080150a <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  80150a:	55                   	push   %ebp
  80150b:	89 e5                	mov    %esp,%ebp
  80150d:	83 ec 04             	sub    $0x4,%esp
  801510:	8b 45 10             	mov    0x10(%ebp),%eax
  801513:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  801516:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801519:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80151d:	8b 45 08             	mov    0x8(%ebp),%eax
  801520:	6a 00                	push   $0x0
  801522:	51                   	push   %ecx
  801523:	52                   	push   %edx
  801524:	ff 75 0c             	pushl  0xc(%ebp)
  801527:	50                   	push   %eax
  801528:	6a 00                	push   $0x0
  80152a:	e8 b0 ff ff ff       	call   8014df <syscall>
  80152f:	83 c4 18             	add    $0x18,%esp
}
  801532:	90                   	nop
  801533:	c9                   	leave  
  801534:	c3                   	ret    

00801535 <sys_cgetc>:

int
sys_cgetc(void)
{
  801535:	55                   	push   %ebp
  801536:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801538:	6a 00                	push   $0x0
  80153a:	6a 00                	push   $0x0
  80153c:	6a 00                	push   $0x0
  80153e:	6a 00                	push   $0x0
  801540:	6a 00                	push   $0x0
  801542:	6a 02                	push   $0x2
  801544:	e8 96 ff ff ff       	call   8014df <syscall>
  801549:	83 c4 18             	add    $0x18,%esp
}
  80154c:	c9                   	leave  
  80154d:	c3                   	ret    

0080154e <sys_lock_cons>:

void sys_lock_cons(void)
{
  80154e:	55                   	push   %ebp
  80154f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  801551:	6a 00                	push   $0x0
  801553:	6a 00                	push   $0x0
  801555:	6a 00                	push   $0x0
  801557:	6a 00                	push   $0x0
  801559:	6a 00                	push   $0x0
  80155b:	6a 03                	push   $0x3
  80155d:	e8 7d ff ff ff       	call   8014df <syscall>
  801562:	83 c4 18             	add    $0x18,%esp
}
  801565:	90                   	nop
  801566:	c9                   	leave  
  801567:	c3                   	ret    

00801568 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  801568:	55                   	push   %ebp
  801569:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  80156b:	6a 00                	push   $0x0
  80156d:	6a 00                	push   $0x0
  80156f:	6a 00                	push   $0x0
  801571:	6a 00                	push   $0x0
  801573:	6a 00                	push   $0x0
  801575:	6a 04                	push   $0x4
  801577:	e8 63 ff ff ff       	call   8014df <syscall>
  80157c:	83 c4 18             	add    $0x18,%esp
}
  80157f:	90                   	nop
  801580:	c9                   	leave  
  801581:	c3                   	ret    

00801582 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801582:	55                   	push   %ebp
  801583:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801585:	8b 55 0c             	mov    0xc(%ebp),%edx
  801588:	8b 45 08             	mov    0x8(%ebp),%eax
  80158b:	6a 00                	push   $0x0
  80158d:	6a 00                	push   $0x0
  80158f:	6a 00                	push   $0x0
  801591:	52                   	push   %edx
  801592:	50                   	push   %eax
  801593:	6a 08                	push   $0x8
  801595:	e8 45 ff ff ff       	call   8014df <syscall>
  80159a:	83 c4 18             	add    $0x18,%esp
}
  80159d:	c9                   	leave  
  80159e:	c3                   	ret    

0080159f <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  80159f:	55                   	push   %ebp
  8015a0:	89 e5                	mov    %esp,%ebp
  8015a2:	56                   	push   %esi
  8015a3:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8015a4:	8b 75 18             	mov    0x18(%ebp),%esi
  8015a7:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8015aa:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8015ad:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8015b3:	56                   	push   %esi
  8015b4:	53                   	push   %ebx
  8015b5:	51                   	push   %ecx
  8015b6:	52                   	push   %edx
  8015b7:	50                   	push   %eax
  8015b8:	6a 09                	push   $0x9
  8015ba:	e8 20 ff ff ff       	call   8014df <syscall>
  8015bf:	83 c4 18             	add    $0x18,%esp
}
  8015c2:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8015c5:	5b                   	pop    %ebx
  8015c6:	5e                   	pop    %esi
  8015c7:	5d                   	pop    %ebp
  8015c8:	c3                   	ret    

008015c9 <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  8015c9:	55                   	push   %ebp
  8015ca:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  8015cc:	6a 00                	push   $0x0
  8015ce:	6a 00                	push   $0x0
  8015d0:	6a 00                	push   $0x0
  8015d2:	6a 00                	push   $0x0
  8015d4:	ff 75 08             	pushl  0x8(%ebp)
  8015d7:	6a 0a                	push   $0xa
  8015d9:	e8 01 ff ff ff       	call   8014df <syscall>
  8015de:	83 c4 18             	add    $0x18,%esp
}
  8015e1:	c9                   	leave  
  8015e2:	c3                   	ret    

008015e3 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8015e3:	55                   	push   %ebp
  8015e4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8015e6:	6a 00                	push   $0x0
  8015e8:	6a 00                	push   $0x0
  8015ea:	6a 00                	push   $0x0
  8015ec:	ff 75 0c             	pushl  0xc(%ebp)
  8015ef:	ff 75 08             	pushl  0x8(%ebp)
  8015f2:	6a 0b                	push   $0xb
  8015f4:	e8 e6 fe ff ff       	call   8014df <syscall>
  8015f9:	83 c4 18             	add    $0x18,%esp
}
  8015fc:	c9                   	leave  
  8015fd:	c3                   	ret    

008015fe <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8015fe:	55                   	push   %ebp
  8015ff:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801601:	6a 00                	push   $0x0
  801603:	6a 00                	push   $0x0
  801605:	6a 00                	push   $0x0
  801607:	6a 00                	push   $0x0
  801609:	6a 00                	push   $0x0
  80160b:	6a 0c                	push   $0xc
  80160d:	e8 cd fe ff ff       	call   8014df <syscall>
  801612:	83 c4 18             	add    $0x18,%esp
}
  801615:	c9                   	leave  
  801616:	c3                   	ret    

00801617 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801617:	55                   	push   %ebp
  801618:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  80161a:	6a 00                	push   $0x0
  80161c:	6a 00                	push   $0x0
  80161e:	6a 00                	push   $0x0
  801620:	6a 00                	push   $0x0
  801622:	6a 00                	push   $0x0
  801624:	6a 0d                	push   $0xd
  801626:	e8 b4 fe ff ff       	call   8014df <syscall>
  80162b:	83 c4 18             	add    $0x18,%esp
}
  80162e:	c9                   	leave  
  80162f:	c3                   	ret    

00801630 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801630:	55                   	push   %ebp
  801631:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801633:	6a 00                	push   $0x0
  801635:	6a 00                	push   $0x0
  801637:	6a 00                	push   $0x0
  801639:	6a 00                	push   $0x0
  80163b:	6a 00                	push   $0x0
  80163d:	6a 0e                	push   $0xe
  80163f:	e8 9b fe ff ff       	call   8014df <syscall>
  801644:	83 c4 18             	add    $0x18,%esp
}
  801647:	c9                   	leave  
  801648:	c3                   	ret    

00801649 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801649:	55                   	push   %ebp
  80164a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  80164c:	6a 00                	push   $0x0
  80164e:	6a 00                	push   $0x0
  801650:	6a 00                	push   $0x0
  801652:	6a 00                	push   $0x0
  801654:	6a 00                	push   $0x0
  801656:	6a 0f                	push   $0xf
  801658:	e8 82 fe ff ff       	call   8014df <syscall>
  80165d:	83 c4 18             	add    $0x18,%esp
}
  801660:	c9                   	leave  
  801661:	c3                   	ret    

00801662 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801662:	55                   	push   %ebp
  801663:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801665:	6a 00                	push   $0x0
  801667:	6a 00                	push   $0x0
  801669:	6a 00                	push   $0x0
  80166b:	6a 00                	push   $0x0
  80166d:	ff 75 08             	pushl  0x8(%ebp)
  801670:	6a 10                	push   $0x10
  801672:	e8 68 fe ff ff       	call   8014df <syscall>
  801677:	83 c4 18             	add    $0x18,%esp
}
  80167a:	c9                   	leave  
  80167b:	c3                   	ret    

0080167c <sys_scarce_memory>:

void sys_scarce_memory()
{
  80167c:	55                   	push   %ebp
  80167d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  80167f:	6a 00                	push   $0x0
  801681:	6a 00                	push   $0x0
  801683:	6a 00                	push   $0x0
  801685:	6a 00                	push   $0x0
  801687:	6a 00                	push   $0x0
  801689:	6a 11                	push   $0x11
  80168b:	e8 4f fe ff ff       	call   8014df <syscall>
  801690:	83 c4 18             	add    $0x18,%esp
}
  801693:	90                   	nop
  801694:	c9                   	leave  
  801695:	c3                   	ret    

00801696 <sys_cputc>:

void
sys_cputc(const char c)
{
  801696:	55                   	push   %ebp
  801697:	89 e5                	mov    %esp,%ebp
  801699:	83 ec 04             	sub    $0x4,%esp
  80169c:	8b 45 08             	mov    0x8(%ebp),%eax
  80169f:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8016a2:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8016a6:	6a 00                	push   $0x0
  8016a8:	6a 00                	push   $0x0
  8016aa:	6a 00                	push   $0x0
  8016ac:	6a 00                	push   $0x0
  8016ae:	50                   	push   %eax
  8016af:	6a 01                	push   $0x1
  8016b1:	e8 29 fe ff ff       	call   8014df <syscall>
  8016b6:	83 c4 18             	add    $0x18,%esp
}
  8016b9:	90                   	nop
  8016ba:	c9                   	leave  
  8016bb:	c3                   	ret    

008016bc <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8016bc:	55                   	push   %ebp
  8016bd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8016bf:	6a 00                	push   $0x0
  8016c1:	6a 00                	push   $0x0
  8016c3:	6a 00                	push   $0x0
  8016c5:	6a 00                	push   $0x0
  8016c7:	6a 00                	push   $0x0
  8016c9:	6a 14                	push   $0x14
  8016cb:	e8 0f fe ff ff       	call   8014df <syscall>
  8016d0:	83 c4 18             	add    $0x18,%esp
}
  8016d3:	90                   	nop
  8016d4:	c9                   	leave  
  8016d5:	c3                   	ret    

008016d6 <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8016d6:	55                   	push   %ebp
  8016d7:	89 e5                	mov    %esp,%ebp
  8016d9:	83 ec 04             	sub    $0x4,%esp
  8016dc:	8b 45 10             	mov    0x10(%ebp),%eax
  8016df:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8016e2:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8016e5:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8016e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8016ec:	6a 00                	push   $0x0
  8016ee:	51                   	push   %ecx
  8016ef:	52                   	push   %edx
  8016f0:	ff 75 0c             	pushl  0xc(%ebp)
  8016f3:	50                   	push   %eax
  8016f4:	6a 15                	push   $0x15
  8016f6:	e8 e4 fd ff ff       	call   8014df <syscall>
  8016fb:	83 c4 18             	add    $0x18,%esp
}
  8016fe:	c9                   	leave  
  8016ff:	c3                   	ret    

00801700 <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  801700:	55                   	push   %ebp
  801701:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801703:	8b 55 0c             	mov    0xc(%ebp),%edx
  801706:	8b 45 08             	mov    0x8(%ebp),%eax
  801709:	6a 00                	push   $0x0
  80170b:	6a 00                	push   $0x0
  80170d:	6a 00                	push   $0x0
  80170f:	52                   	push   %edx
  801710:	50                   	push   %eax
  801711:	6a 16                	push   $0x16
  801713:	e8 c7 fd ff ff       	call   8014df <syscall>
  801718:	83 c4 18             	add    $0x18,%esp
}
  80171b:	c9                   	leave  
  80171c:	c3                   	ret    

0080171d <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  80171d:	55                   	push   %ebp
  80171e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801720:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801723:	8b 55 0c             	mov    0xc(%ebp),%edx
  801726:	8b 45 08             	mov    0x8(%ebp),%eax
  801729:	6a 00                	push   $0x0
  80172b:	6a 00                	push   $0x0
  80172d:	51                   	push   %ecx
  80172e:	52                   	push   %edx
  80172f:	50                   	push   %eax
  801730:	6a 17                	push   $0x17
  801732:	e8 a8 fd ff ff       	call   8014df <syscall>
  801737:	83 c4 18             	add    $0x18,%esp
}
  80173a:	c9                   	leave  
  80173b:	c3                   	ret    

0080173c <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  80173c:	55                   	push   %ebp
  80173d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  80173f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801742:	8b 45 08             	mov    0x8(%ebp),%eax
  801745:	6a 00                	push   $0x0
  801747:	6a 00                	push   $0x0
  801749:	6a 00                	push   $0x0
  80174b:	52                   	push   %edx
  80174c:	50                   	push   %eax
  80174d:	6a 18                	push   $0x18
  80174f:	e8 8b fd ff ff       	call   8014df <syscall>
  801754:	83 c4 18             	add    $0x18,%esp
}
  801757:	c9                   	leave  
  801758:	c3                   	ret    

00801759 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801759:	55                   	push   %ebp
  80175a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  80175c:	8b 45 08             	mov    0x8(%ebp),%eax
  80175f:	6a 00                	push   $0x0
  801761:	ff 75 14             	pushl  0x14(%ebp)
  801764:	ff 75 10             	pushl  0x10(%ebp)
  801767:	ff 75 0c             	pushl  0xc(%ebp)
  80176a:	50                   	push   %eax
  80176b:	6a 19                	push   $0x19
  80176d:	e8 6d fd ff ff       	call   8014df <syscall>
  801772:	83 c4 18             	add    $0x18,%esp
}
  801775:	c9                   	leave  
  801776:	c3                   	ret    

00801777 <sys_run_env>:

void sys_run_env(int32 envId)
{
  801777:	55                   	push   %ebp
  801778:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  80177a:	8b 45 08             	mov    0x8(%ebp),%eax
  80177d:	6a 00                	push   $0x0
  80177f:	6a 00                	push   $0x0
  801781:	6a 00                	push   $0x0
  801783:	6a 00                	push   $0x0
  801785:	50                   	push   %eax
  801786:	6a 1a                	push   $0x1a
  801788:	e8 52 fd ff ff       	call   8014df <syscall>
  80178d:	83 c4 18             	add    $0x18,%esp
}
  801790:	90                   	nop
  801791:	c9                   	leave  
  801792:	c3                   	ret    

00801793 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801793:	55                   	push   %ebp
  801794:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801796:	8b 45 08             	mov    0x8(%ebp),%eax
  801799:	6a 00                	push   $0x0
  80179b:	6a 00                	push   $0x0
  80179d:	6a 00                	push   $0x0
  80179f:	6a 00                	push   $0x0
  8017a1:	50                   	push   %eax
  8017a2:	6a 1b                	push   $0x1b
  8017a4:	e8 36 fd ff ff       	call   8014df <syscall>
  8017a9:	83 c4 18             	add    $0x18,%esp
}
  8017ac:	c9                   	leave  
  8017ad:	c3                   	ret    

008017ae <sys_getenvid>:

int32 sys_getenvid(void)
{
  8017ae:	55                   	push   %ebp
  8017af:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8017b1:	6a 00                	push   $0x0
  8017b3:	6a 00                	push   $0x0
  8017b5:	6a 00                	push   $0x0
  8017b7:	6a 00                	push   $0x0
  8017b9:	6a 00                	push   $0x0
  8017bb:	6a 05                	push   $0x5
  8017bd:	e8 1d fd ff ff       	call   8014df <syscall>
  8017c2:	83 c4 18             	add    $0x18,%esp
}
  8017c5:	c9                   	leave  
  8017c6:	c3                   	ret    

008017c7 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8017c7:	55                   	push   %ebp
  8017c8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8017ca:	6a 00                	push   $0x0
  8017cc:	6a 00                	push   $0x0
  8017ce:	6a 00                	push   $0x0
  8017d0:	6a 00                	push   $0x0
  8017d2:	6a 00                	push   $0x0
  8017d4:	6a 06                	push   $0x6
  8017d6:	e8 04 fd ff ff       	call   8014df <syscall>
  8017db:	83 c4 18             	add    $0x18,%esp
}
  8017de:	c9                   	leave  
  8017df:	c3                   	ret    

008017e0 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8017e0:	55                   	push   %ebp
  8017e1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8017e3:	6a 00                	push   $0x0
  8017e5:	6a 00                	push   $0x0
  8017e7:	6a 00                	push   $0x0
  8017e9:	6a 00                	push   $0x0
  8017eb:	6a 00                	push   $0x0
  8017ed:	6a 07                	push   $0x7
  8017ef:	e8 eb fc ff ff       	call   8014df <syscall>
  8017f4:	83 c4 18             	add    $0x18,%esp
}
  8017f7:	c9                   	leave  
  8017f8:	c3                   	ret    

008017f9 <sys_exit_env>:


void sys_exit_env(void)
{
  8017f9:	55                   	push   %ebp
  8017fa:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  8017fc:	6a 00                	push   $0x0
  8017fe:	6a 00                	push   $0x0
  801800:	6a 00                	push   $0x0
  801802:	6a 00                	push   $0x0
  801804:	6a 00                	push   $0x0
  801806:	6a 1c                	push   $0x1c
  801808:	e8 d2 fc ff ff       	call   8014df <syscall>
  80180d:	83 c4 18             	add    $0x18,%esp
}
  801810:	90                   	nop
  801811:	c9                   	leave  
  801812:	c3                   	ret    

00801813 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  801813:	55                   	push   %ebp
  801814:	89 e5                	mov    %esp,%ebp
  801816:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801819:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80181c:	8d 50 04             	lea    0x4(%eax),%edx
  80181f:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801822:	6a 00                	push   $0x0
  801824:	6a 00                	push   $0x0
  801826:	6a 00                	push   $0x0
  801828:	52                   	push   %edx
  801829:	50                   	push   %eax
  80182a:	6a 1d                	push   $0x1d
  80182c:	e8 ae fc ff ff       	call   8014df <syscall>
  801831:	83 c4 18             	add    $0x18,%esp
	return result;
  801834:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801837:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80183a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80183d:	89 01                	mov    %eax,(%ecx)
  80183f:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801842:	8b 45 08             	mov    0x8(%ebp),%eax
  801845:	c9                   	leave  
  801846:	c2 04 00             	ret    $0x4

00801849 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801849:	55                   	push   %ebp
  80184a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  80184c:	6a 00                	push   $0x0
  80184e:	6a 00                	push   $0x0
  801850:	ff 75 10             	pushl  0x10(%ebp)
  801853:	ff 75 0c             	pushl  0xc(%ebp)
  801856:	ff 75 08             	pushl  0x8(%ebp)
  801859:	6a 13                	push   $0x13
  80185b:	e8 7f fc ff ff       	call   8014df <syscall>
  801860:	83 c4 18             	add    $0x18,%esp
	return ;
  801863:	90                   	nop
}
  801864:	c9                   	leave  
  801865:	c3                   	ret    

00801866 <sys_rcr2>:
uint32 sys_rcr2()
{
  801866:	55                   	push   %ebp
  801867:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801869:	6a 00                	push   $0x0
  80186b:	6a 00                	push   $0x0
  80186d:	6a 00                	push   $0x0
  80186f:	6a 00                	push   $0x0
  801871:	6a 00                	push   $0x0
  801873:	6a 1e                	push   $0x1e
  801875:	e8 65 fc ff ff       	call   8014df <syscall>
  80187a:	83 c4 18             	add    $0x18,%esp
}
  80187d:	c9                   	leave  
  80187e:	c3                   	ret    

0080187f <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  80187f:	55                   	push   %ebp
  801880:	89 e5                	mov    %esp,%ebp
  801882:	83 ec 04             	sub    $0x4,%esp
  801885:	8b 45 08             	mov    0x8(%ebp),%eax
  801888:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  80188b:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  80188f:	6a 00                	push   $0x0
  801891:	6a 00                	push   $0x0
  801893:	6a 00                	push   $0x0
  801895:	6a 00                	push   $0x0
  801897:	50                   	push   %eax
  801898:	6a 1f                	push   $0x1f
  80189a:	e8 40 fc ff ff       	call   8014df <syscall>
  80189f:	83 c4 18             	add    $0x18,%esp
	return ;
  8018a2:	90                   	nop
}
  8018a3:	c9                   	leave  
  8018a4:	c3                   	ret    

008018a5 <rsttst>:
void rsttst()
{
  8018a5:	55                   	push   %ebp
  8018a6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8018a8:	6a 00                	push   $0x0
  8018aa:	6a 00                	push   $0x0
  8018ac:	6a 00                	push   $0x0
  8018ae:	6a 00                	push   $0x0
  8018b0:	6a 00                	push   $0x0
  8018b2:	6a 21                	push   $0x21
  8018b4:	e8 26 fc ff ff       	call   8014df <syscall>
  8018b9:	83 c4 18             	add    $0x18,%esp
	return ;
  8018bc:	90                   	nop
}
  8018bd:	c9                   	leave  
  8018be:	c3                   	ret    

008018bf <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8018bf:	55                   	push   %ebp
  8018c0:	89 e5                	mov    %esp,%ebp
  8018c2:	83 ec 04             	sub    $0x4,%esp
  8018c5:	8b 45 14             	mov    0x14(%ebp),%eax
  8018c8:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8018cb:	8b 55 18             	mov    0x18(%ebp),%edx
  8018ce:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8018d2:	52                   	push   %edx
  8018d3:	50                   	push   %eax
  8018d4:	ff 75 10             	pushl  0x10(%ebp)
  8018d7:	ff 75 0c             	pushl  0xc(%ebp)
  8018da:	ff 75 08             	pushl  0x8(%ebp)
  8018dd:	6a 20                	push   $0x20
  8018df:	e8 fb fb ff ff       	call   8014df <syscall>
  8018e4:	83 c4 18             	add    $0x18,%esp
	return ;
  8018e7:	90                   	nop
}
  8018e8:	c9                   	leave  
  8018e9:	c3                   	ret    

008018ea <chktst>:
void chktst(uint32 n)
{
  8018ea:	55                   	push   %ebp
  8018eb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8018ed:	6a 00                	push   $0x0
  8018ef:	6a 00                	push   $0x0
  8018f1:	6a 00                	push   $0x0
  8018f3:	6a 00                	push   $0x0
  8018f5:	ff 75 08             	pushl  0x8(%ebp)
  8018f8:	6a 22                	push   $0x22
  8018fa:	e8 e0 fb ff ff       	call   8014df <syscall>
  8018ff:	83 c4 18             	add    $0x18,%esp
	return ;
  801902:	90                   	nop
}
  801903:	c9                   	leave  
  801904:	c3                   	ret    

00801905 <inctst>:

void inctst()
{
  801905:	55                   	push   %ebp
  801906:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801908:	6a 00                	push   $0x0
  80190a:	6a 00                	push   $0x0
  80190c:	6a 00                	push   $0x0
  80190e:	6a 00                	push   $0x0
  801910:	6a 00                	push   $0x0
  801912:	6a 23                	push   $0x23
  801914:	e8 c6 fb ff ff       	call   8014df <syscall>
  801919:	83 c4 18             	add    $0x18,%esp
	return ;
  80191c:	90                   	nop
}
  80191d:	c9                   	leave  
  80191e:	c3                   	ret    

0080191f <gettst>:
uint32 gettst()
{
  80191f:	55                   	push   %ebp
  801920:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801922:	6a 00                	push   $0x0
  801924:	6a 00                	push   $0x0
  801926:	6a 00                	push   $0x0
  801928:	6a 00                	push   $0x0
  80192a:	6a 00                	push   $0x0
  80192c:	6a 24                	push   $0x24
  80192e:	e8 ac fb ff ff       	call   8014df <syscall>
  801933:	83 c4 18             	add    $0x18,%esp
}
  801936:	c9                   	leave  
  801937:	c3                   	ret    

00801938 <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  801938:	55                   	push   %ebp
  801939:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80193b:	6a 00                	push   $0x0
  80193d:	6a 00                	push   $0x0
  80193f:	6a 00                	push   $0x0
  801941:	6a 00                	push   $0x0
  801943:	6a 00                	push   $0x0
  801945:	6a 25                	push   $0x25
  801947:	e8 93 fb ff ff       	call   8014df <syscall>
  80194c:	83 c4 18             	add    $0x18,%esp
  80194f:	a3 c0 70 82 00       	mov    %eax,0x8270c0
	return uheapPlaceStrategy ;
  801954:	a1 c0 70 82 00       	mov    0x8270c0,%eax
}
  801959:	c9                   	leave  
  80195a:	c3                   	ret    

0080195b <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  80195b:	55                   	push   %ebp
  80195c:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  80195e:	8b 45 08             	mov    0x8(%ebp),%eax
  801961:	a3 c0 70 82 00       	mov    %eax,0x8270c0
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801966:	6a 00                	push   $0x0
  801968:	6a 00                	push   $0x0
  80196a:	6a 00                	push   $0x0
  80196c:	6a 00                	push   $0x0
  80196e:	ff 75 08             	pushl  0x8(%ebp)
  801971:	6a 26                	push   $0x26
  801973:	e8 67 fb ff ff       	call   8014df <syscall>
  801978:	83 c4 18             	add    $0x18,%esp
	return ;
  80197b:	90                   	nop
}
  80197c:	c9                   	leave  
  80197d:	c3                   	ret    

0080197e <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  80197e:	55                   	push   %ebp
  80197f:	89 e5                	mov    %esp,%ebp
  801981:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801982:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801985:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801988:	8b 55 0c             	mov    0xc(%ebp),%edx
  80198b:	8b 45 08             	mov    0x8(%ebp),%eax
  80198e:	6a 00                	push   $0x0
  801990:	53                   	push   %ebx
  801991:	51                   	push   %ecx
  801992:	52                   	push   %edx
  801993:	50                   	push   %eax
  801994:	6a 27                	push   $0x27
  801996:	e8 44 fb ff ff       	call   8014df <syscall>
  80199b:	83 c4 18             	add    $0x18,%esp
}
  80199e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8019a1:	c9                   	leave  
  8019a2:	c3                   	ret    

008019a3 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  8019a3:	55                   	push   %ebp
  8019a4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  8019a6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ac:	6a 00                	push   $0x0
  8019ae:	6a 00                	push   $0x0
  8019b0:	6a 00                	push   $0x0
  8019b2:	52                   	push   %edx
  8019b3:	50                   	push   %eax
  8019b4:	6a 28                	push   $0x28
  8019b6:	e8 24 fb ff ff       	call   8014df <syscall>
  8019bb:	83 c4 18             	add    $0x18,%esp
}
  8019be:	c9                   	leave  
  8019bf:	c3                   	ret    

008019c0 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  8019c0:	55                   	push   %ebp
  8019c1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  8019c3:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8019c6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8019cc:	6a 00                	push   $0x0
  8019ce:	51                   	push   %ecx
  8019cf:	ff 75 10             	pushl  0x10(%ebp)
  8019d2:	52                   	push   %edx
  8019d3:	50                   	push   %eax
  8019d4:	6a 29                	push   $0x29
  8019d6:	e8 04 fb ff ff       	call   8014df <syscall>
  8019db:	83 c4 18             	add    $0x18,%esp
}
  8019de:	c9                   	leave  
  8019df:	c3                   	ret    

008019e0 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8019e0:	55                   	push   %ebp
  8019e1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8019e3:	6a 00                	push   $0x0
  8019e5:	6a 00                	push   $0x0
  8019e7:	ff 75 10             	pushl  0x10(%ebp)
  8019ea:	ff 75 0c             	pushl  0xc(%ebp)
  8019ed:	ff 75 08             	pushl  0x8(%ebp)
  8019f0:	6a 12                	push   $0x12
  8019f2:	e8 e8 fa ff ff       	call   8014df <syscall>
  8019f7:	83 c4 18             	add    $0x18,%esp
	return ;
  8019fa:	90                   	nop
}
  8019fb:	c9                   	leave  
  8019fc:	c3                   	ret    

008019fd <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  8019fd:	55                   	push   %ebp
  8019fe:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  801a00:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a03:	8b 45 08             	mov    0x8(%ebp),%eax
  801a06:	6a 00                	push   $0x0
  801a08:	6a 00                	push   $0x0
  801a0a:	6a 00                	push   $0x0
  801a0c:	52                   	push   %edx
  801a0d:	50                   	push   %eax
  801a0e:	6a 2a                	push   $0x2a
  801a10:	e8 ca fa ff ff       	call   8014df <syscall>
  801a15:	83 c4 18             	add    $0x18,%esp
	return;
  801a18:	90                   	nop
}
  801a19:	c9                   	leave  
  801a1a:	c3                   	ret    

00801a1b <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  801a1b:	55                   	push   %ebp
  801a1c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  801a1e:	6a 00                	push   $0x0
  801a20:	6a 00                	push   $0x0
  801a22:	6a 00                	push   $0x0
  801a24:	6a 00                	push   $0x0
  801a26:	6a 00                	push   $0x0
  801a28:	6a 2b                	push   $0x2b
  801a2a:	e8 b0 fa ff ff       	call   8014df <syscall>
  801a2f:	83 c4 18             	add    $0x18,%esp
}
  801a32:	c9                   	leave  
  801a33:	c3                   	ret    

00801a34 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801a34:	55                   	push   %ebp
  801a35:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801a37:	6a 00                	push   $0x0
  801a39:	6a 00                	push   $0x0
  801a3b:	6a 00                	push   $0x0
  801a3d:	ff 75 0c             	pushl  0xc(%ebp)
  801a40:	ff 75 08             	pushl  0x8(%ebp)
  801a43:	6a 2d                	push   $0x2d
  801a45:	e8 95 fa ff ff       	call   8014df <syscall>
  801a4a:	83 c4 18             	add    $0x18,%esp
	return;
  801a4d:	90                   	nop
}
  801a4e:	c9                   	leave  
  801a4f:	c3                   	ret    

00801a50 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801a50:	55                   	push   %ebp
  801a51:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801a53:	6a 00                	push   $0x0
  801a55:	6a 00                	push   $0x0
  801a57:	6a 00                	push   $0x0
  801a59:	ff 75 0c             	pushl  0xc(%ebp)
  801a5c:	ff 75 08             	pushl  0x8(%ebp)
  801a5f:	6a 2c                	push   $0x2c
  801a61:	e8 79 fa ff ff       	call   8014df <syscall>
  801a66:	83 c4 18             	add    $0x18,%esp
	return ;
  801a69:	90                   	nop
}
  801a6a:	c9                   	leave  
  801a6b:	c3                   	ret    

00801a6c <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  801a6c:	55                   	push   %ebp
  801a6d:	89 e5                	mov    %esp,%ebp
	//TODO: [PROJECT'25.IM#4] CPU SCHEDULING - #1 System Calls - Add suitable code here
	//Your code is here
	//Comment the following line
	//panic("sys_env_set_priority() is not implemented yet...!!");
	syscall(SYS_env_set_priority, envID, priority, 0, 0, 0);
  801a6f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a72:	8b 45 08             	mov    0x8(%ebp),%eax
  801a75:	6a 00                	push   $0x0
  801a77:	6a 00                	push   $0x0
  801a79:	6a 00                	push   $0x0
  801a7b:	52                   	push   %edx
  801a7c:	50                   	push   %eax
  801a7d:	6a 2e                	push   $0x2e
  801a7f:	e8 5b fa ff ff       	call   8014df <syscall>
  801a84:	83 c4 18             	add    $0x18,%esp
	    return;
  801a87:	90                   	nop
}
  801a88:	c9                   	leave  
  801a89:	c3                   	ret    
  801a8a:	66 90                	xchg   %ax,%ax

00801a8c <__udivdi3>:
  801a8c:	55                   	push   %ebp
  801a8d:	57                   	push   %edi
  801a8e:	56                   	push   %esi
  801a8f:	53                   	push   %ebx
  801a90:	83 ec 1c             	sub    $0x1c,%esp
  801a93:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801a97:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801a9b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801a9f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801aa3:	89 ca                	mov    %ecx,%edx
  801aa5:	89 f8                	mov    %edi,%eax
  801aa7:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801aab:	85 f6                	test   %esi,%esi
  801aad:	75 2d                	jne    801adc <__udivdi3+0x50>
  801aaf:	39 cf                	cmp    %ecx,%edi
  801ab1:	77 65                	ja     801b18 <__udivdi3+0x8c>
  801ab3:	89 fd                	mov    %edi,%ebp
  801ab5:	85 ff                	test   %edi,%edi
  801ab7:	75 0b                	jne    801ac4 <__udivdi3+0x38>
  801ab9:	b8 01 00 00 00       	mov    $0x1,%eax
  801abe:	31 d2                	xor    %edx,%edx
  801ac0:	f7 f7                	div    %edi
  801ac2:	89 c5                	mov    %eax,%ebp
  801ac4:	31 d2                	xor    %edx,%edx
  801ac6:	89 c8                	mov    %ecx,%eax
  801ac8:	f7 f5                	div    %ebp
  801aca:	89 c1                	mov    %eax,%ecx
  801acc:	89 d8                	mov    %ebx,%eax
  801ace:	f7 f5                	div    %ebp
  801ad0:	89 cf                	mov    %ecx,%edi
  801ad2:	89 fa                	mov    %edi,%edx
  801ad4:	83 c4 1c             	add    $0x1c,%esp
  801ad7:	5b                   	pop    %ebx
  801ad8:	5e                   	pop    %esi
  801ad9:	5f                   	pop    %edi
  801ada:	5d                   	pop    %ebp
  801adb:	c3                   	ret    
  801adc:	39 ce                	cmp    %ecx,%esi
  801ade:	77 28                	ja     801b08 <__udivdi3+0x7c>
  801ae0:	0f bd fe             	bsr    %esi,%edi
  801ae3:	83 f7 1f             	xor    $0x1f,%edi
  801ae6:	75 40                	jne    801b28 <__udivdi3+0x9c>
  801ae8:	39 ce                	cmp    %ecx,%esi
  801aea:	72 0a                	jb     801af6 <__udivdi3+0x6a>
  801aec:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801af0:	0f 87 9e 00 00 00    	ja     801b94 <__udivdi3+0x108>
  801af6:	b8 01 00 00 00       	mov    $0x1,%eax
  801afb:	89 fa                	mov    %edi,%edx
  801afd:	83 c4 1c             	add    $0x1c,%esp
  801b00:	5b                   	pop    %ebx
  801b01:	5e                   	pop    %esi
  801b02:	5f                   	pop    %edi
  801b03:	5d                   	pop    %ebp
  801b04:	c3                   	ret    
  801b05:	8d 76 00             	lea    0x0(%esi),%esi
  801b08:	31 ff                	xor    %edi,%edi
  801b0a:	31 c0                	xor    %eax,%eax
  801b0c:	89 fa                	mov    %edi,%edx
  801b0e:	83 c4 1c             	add    $0x1c,%esp
  801b11:	5b                   	pop    %ebx
  801b12:	5e                   	pop    %esi
  801b13:	5f                   	pop    %edi
  801b14:	5d                   	pop    %ebp
  801b15:	c3                   	ret    
  801b16:	66 90                	xchg   %ax,%ax
  801b18:	89 d8                	mov    %ebx,%eax
  801b1a:	f7 f7                	div    %edi
  801b1c:	31 ff                	xor    %edi,%edi
  801b1e:	89 fa                	mov    %edi,%edx
  801b20:	83 c4 1c             	add    $0x1c,%esp
  801b23:	5b                   	pop    %ebx
  801b24:	5e                   	pop    %esi
  801b25:	5f                   	pop    %edi
  801b26:	5d                   	pop    %ebp
  801b27:	c3                   	ret    
  801b28:	bd 20 00 00 00       	mov    $0x20,%ebp
  801b2d:	89 eb                	mov    %ebp,%ebx
  801b2f:	29 fb                	sub    %edi,%ebx
  801b31:	89 f9                	mov    %edi,%ecx
  801b33:	d3 e6                	shl    %cl,%esi
  801b35:	89 c5                	mov    %eax,%ebp
  801b37:	88 d9                	mov    %bl,%cl
  801b39:	d3 ed                	shr    %cl,%ebp
  801b3b:	89 e9                	mov    %ebp,%ecx
  801b3d:	09 f1                	or     %esi,%ecx
  801b3f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801b43:	89 f9                	mov    %edi,%ecx
  801b45:	d3 e0                	shl    %cl,%eax
  801b47:	89 c5                	mov    %eax,%ebp
  801b49:	89 d6                	mov    %edx,%esi
  801b4b:	88 d9                	mov    %bl,%cl
  801b4d:	d3 ee                	shr    %cl,%esi
  801b4f:	89 f9                	mov    %edi,%ecx
  801b51:	d3 e2                	shl    %cl,%edx
  801b53:	8b 44 24 08          	mov    0x8(%esp),%eax
  801b57:	88 d9                	mov    %bl,%cl
  801b59:	d3 e8                	shr    %cl,%eax
  801b5b:	09 c2                	or     %eax,%edx
  801b5d:	89 d0                	mov    %edx,%eax
  801b5f:	89 f2                	mov    %esi,%edx
  801b61:	f7 74 24 0c          	divl   0xc(%esp)
  801b65:	89 d6                	mov    %edx,%esi
  801b67:	89 c3                	mov    %eax,%ebx
  801b69:	f7 e5                	mul    %ebp
  801b6b:	39 d6                	cmp    %edx,%esi
  801b6d:	72 19                	jb     801b88 <__udivdi3+0xfc>
  801b6f:	74 0b                	je     801b7c <__udivdi3+0xf0>
  801b71:	89 d8                	mov    %ebx,%eax
  801b73:	31 ff                	xor    %edi,%edi
  801b75:	e9 58 ff ff ff       	jmp    801ad2 <__udivdi3+0x46>
  801b7a:	66 90                	xchg   %ax,%ax
  801b7c:	8b 54 24 08          	mov    0x8(%esp),%edx
  801b80:	89 f9                	mov    %edi,%ecx
  801b82:	d3 e2                	shl    %cl,%edx
  801b84:	39 c2                	cmp    %eax,%edx
  801b86:	73 e9                	jae    801b71 <__udivdi3+0xe5>
  801b88:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801b8b:	31 ff                	xor    %edi,%edi
  801b8d:	e9 40 ff ff ff       	jmp    801ad2 <__udivdi3+0x46>
  801b92:	66 90                	xchg   %ax,%ax
  801b94:	31 c0                	xor    %eax,%eax
  801b96:	e9 37 ff ff ff       	jmp    801ad2 <__udivdi3+0x46>
  801b9b:	90                   	nop

00801b9c <__umoddi3>:
  801b9c:	55                   	push   %ebp
  801b9d:	57                   	push   %edi
  801b9e:	56                   	push   %esi
  801b9f:	53                   	push   %ebx
  801ba0:	83 ec 1c             	sub    $0x1c,%esp
  801ba3:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801ba7:	8b 74 24 34          	mov    0x34(%esp),%esi
  801bab:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801baf:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801bb3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801bb7:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801bbb:	89 f3                	mov    %esi,%ebx
  801bbd:	89 fa                	mov    %edi,%edx
  801bbf:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801bc3:	89 34 24             	mov    %esi,(%esp)
  801bc6:	85 c0                	test   %eax,%eax
  801bc8:	75 1a                	jne    801be4 <__umoddi3+0x48>
  801bca:	39 f7                	cmp    %esi,%edi
  801bcc:	0f 86 a2 00 00 00    	jbe    801c74 <__umoddi3+0xd8>
  801bd2:	89 c8                	mov    %ecx,%eax
  801bd4:	89 f2                	mov    %esi,%edx
  801bd6:	f7 f7                	div    %edi
  801bd8:	89 d0                	mov    %edx,%eax
  801bda:	31 d2                	xor    %edx,%edx
  801bdc:	83 c4 1c             	add    $0x1c,%esp
  801bdf:	5b                   	pop    %ebx
  801be0:	5e                   	pop    %esi
  801be1:	5f                   	pop    %edi
  801be2:	5d                   	pop    %ebp
  801be3:	c3                   	ret    
  801be4:	39 f0                	cmp    %esi,%eax
  801be6:	0f 87 ac 00 00 00    	ja     801c98 <__umoddi3+0xfc>
  801bec:	0f bd e8             	bsr    %eax,%ebp
  801bef:	83 f5 1f             	xor    $0x1f,%ebp
  801bf2:	0f 84 ac 00 00 00    	je     801ca4 <__umoddi3+0x108>
  801bf8:	bf 20 00 00 00       	mov    $0x20,%edi
  801bfd:	29 ef                	sub    %ebp,%edi
  801bff:	89 fe                	mov    %edi,%esi
  801c01:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801c05:	89 e9                	mov    %ebp,%ecx
  801c07:	d3 e0                	shl    %cl,%eax
  801c09:	89 d7                	mov    %edx,%edi
  801c0b:	89 f1                	mov    %esi,%ecx
  801c0d:	d3 ef                	shr    %cl,%edi
  801c0f:	09 c7                	or     %eax,%edi
  801c11:	89 e9                	mov    %ebp,%ecx
  801c13:	d3 e2                	shl    %cl,%edx
  801c15:	89 14 24             	mov    %edx,(%esp)
  801c18:	89 d8                	mov    %ebx,%eax
  801c1a:	d3 e0                	shl    %cl,%eax
  801c1c:	89 c2                	mov    %eax,%edx
  801c1e:	8b 44 24 08          	mov    0x8(%esp),%eax
  801c22:	d3 e0                	shl    %cl,%eax
  801c24:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c28:	8b 44 24 08          	mov    0x8(%esp),%eax
  801c2c:	89 f1                	mov    %esi,%ecx
  801c2e:	d3 e8                	shr    %cl,%eax
  801c30:	09 d0                	or     %edx,%eax
  801c32:	d3 eb                	shr    %cl,%ebx
  801c34:	89 da                	mov    %ebx,%edx
  801c36:	f7 f7                	div    %edi
  801c38:	89 d3                	mov    %edx,%ebx
  801c3a:	f7 24 24             	mull   (%esp)
  801c3d:	89 c6                	mov    %eax,%esi
  801c3f:	89 d1                	mov    %edx,%ecx
  801c41:	39 d3                	cmp    %edx,%ebx
  801c43:	0f 82 87 00 00 00    	jb     801cd0 <__umoddi3+0x134>
  801c49:	0f 84 91 00 00 00    	je     801ce0 <__umoddi3+0x144>
  801c4f:	8b 54 24 04          	mov    0x4(%esp),%edx
  801c53:	29 f2                	sub    %esi,%edx
  801c55:	19 cb                	sbb    %ecx,%ebx
  801c57:	89 d8                	mov    %ebx,%eax
  801c59:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801c5d:	d3 e0                	shl    %cl,%eax
  801c5f:	89 e9                	mov    %ebp,%ecx
  801c61:	d3 ea                	shr    %cl,%edx
  801c63:	09 d0                	or     %edx,%eax
  801c65:	89 e9                	mov    %ebp,%ecx
  801c67:	d3 eb                	shr    %cl,%ebx
  801c69:	89 da                	mov    %ebx,%edx
  801c6b:	83 c4 1c             	add    $0x1c,%esp
  801c6e:	5b                   	pop    %ebx
  801c6f:	5e                   	pop    %esi
  801c70:	5f                   	pop    %edi
  801c71:	5d                   	pop    %ebp
  801c72:	c3                   	ret    
  801c73:	90                   	nop
  801c74:	89 fd                	mov    %edi,%ebp
  801c76:	85 ff                	test   %edi,%edi
  801c78:	75 0b                	jne    801c85 <__umoddi3+0xe9>
  801c7a:	b8 01 00 00 00       	mov    $0x1,%eax
  801c7f:	31 d2                	xor    %edx,%edx
  801c81:	f7 f7                	div    %edi
  801c83:	89 c5                	mov    %eax,%ebp
  801c85:	89 f0                	mov    %esi,%eax
  801c87:	31 d2                	xor    %edx,%edx
  801c89:	f7 f5                	div    %ebp
  801c8b:	89 c8                	mov    %ecx,%eax
  801c8d:	f7 f5                	div    %ebp
  801c8f:	89 d0                	mov    %edx,%eax
  801c91:	e9 44 ff ff ff       	jmp    801bda <__umoddi3+0x3e>
  801c96:	66 90                	xchg   %ax,%ax
  801c98:	89 c8                	mov    %ecx,%eax
  801c9a:	89 f2                	mov    %esi,%edx
  801c9c:	83 c4 1c             	add    $0x1c,%esp
  801c9f:	5b                   	pop    %ebx
  801ca0:	5e                   	pop    %esi
  801ca1:	5f                   	pop    %edi
  801ca2:	5d                   	pop    %ebp
  801ca3:	c3                   	ret    
  801ca4:	3b 04 24             	cmp    (%esp),%eax
  801ca7:	72 06                	jb     801caf <__umoddi3+0x113>
  801ca9:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801cad:	77 0f                	ja     801cbe <__umoddi3+0x122>
  801caf:	89 f2                	mov    %esi,%edx
  801cb1:	29 f9                	sub    %edi,%ecx
  801cb3:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801cb7:	89 14 24             	mov    %edx,(%esp)
  801cba:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801cbe:	8b 44 24 04          	mov    0x4(%esp),%eax
  801cc2:	8b 14 24             	mov    (%esp),%edx
  801cc5:	83 c4 1c             	add    $0x1c,%esp
  801cc8:	5b                   	pop    %ebx
  801cc9:	5e                   	pop    %esi
  801cca:	5f                   	pop    %edi
  801ccb:	5d                   	pop    %ebp
  801ccc:	c3                   	ret    
  801ccd:	8d 76 00             	lea    0x0(%esi),%esi
  801cd0:	2b 04 24             	sub    (%esp),%eax
  801cd3:	19 fa                	sbb    %edi,%edx
  801cd5:	89 d1                	mov    %edx,%ecx
  801cd7:	89 c6                	mov    %eax,%esi
  801cd9:	e9 71 ff ff ff       	jmp    801c4f <__umoddi3+0xb3>
  801cde:	66 90                	xchg   %ax,%ax
  801ce0:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801ce4:	72 ea                	jb     801cd0 <__umoddi3+0x134>
  801ce6:	89 d9                	mov    %ebx,%ecx
  801ce8:	e9 62 ff ff ff       	jmp    801c4f <__umoddi3+0xb3>
