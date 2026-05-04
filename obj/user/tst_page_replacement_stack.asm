
obj/user/tst_page_replacement_stack:     file format elf32-i386


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
  800031:	e8 fd 00 00 00       	call   800133 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
/************************************************************/

#include <inc/lib.h>

void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	53                   	push   %ebx
  80003c:	81 ec 14 a0 00 00    	sub    $0xa014,%esp
	int8 arr[PAGE_SIZE*10];

	uint32 kilo = 1024;
  800042:	c7 45 f0 00 04 00 00 	movl   $0x400,-0x10(%ebp)

//	cprintf("envID = %d\n",envID);

	int freePages = sys_calculate_free_frames();
  800049:	e8 70 15 00 00       	call   8015be <sys_calculate_free_frames>
  80004e:	89 45 ec             	mov    %eax,-0x14(%ebp)
	int usedDiskPages = sys_pf_calculate_allocated_pages();
  800051:	e8 b3 15 00 00       	call   801609 <sys_pf_calculate_allocated_pages>
  800056:	89 45 e8             	mov    %eax,-0x18(%ebp)

	int i ;
	for (i = 0 ; i < PAGE_SIZE*10 ; i+=PAGE_SIZE/2)
  800059:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800060:	eb 15                	jmp    800077 <_main+0x3f>
		arr[i] = -1 ;
  800062:	8d 95 e8 5f ff ff    	lea    -0xa018(%ebp),%edx
  800068:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80006b:	01 d0                	add    %edx,%eax
  80006d:	c6 00 ff             	movb   $0xff,(%eax)

	int freePages = sys_calculate_free_frames();
	int usedDiskPages = sys_pf_calculate_allocated_pages();

	int i ;
	for (i = 0 ; i < PAGE_SIZE*10 ; i+=PAGE_SIZE/2)
  800070:	81 45 f4 00 08 00 00 	addl   $0x800,-0xc(%ebp)
  800077:	81 7d f4 ff 9f 00 00 	cmpl   $0x9fff,-0xc(%ebp)
  80007e:	7e e2                	jle    800062 <_main+0x2a>
		arr[i] = -1 ;


	cprintf_colored(TEXT_cyan, "%~\nchecking REPLACEMENT fault handling of STACK pages... \n");
  800080:	83 ec 08             	sub    $0x8,%esp
  800083:	68 c0 1c 80 00       	push   $0x801cc0
  800088:	6a 03                	push   $0x3
  80008a:	e8 58 05 00 00       	call   8005e7 <cprintf_colored>
  80008f:	83 c4 10             	add    $0x10,%esp
	{
		for (i = 0 ; i < PAGE_SIZE*10 ; i+=PAGE_SIZE/2)
  800092:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800099:	eb 2c                	jmp    8000c7 <_main+0x8f>
			if( arr[i] != -1) panic("modified stack page(s) not restored correctly");
  80009b:	8d 95 e8 5f ff ff    	lea    -0xa018(%ebp),%edx
  8000a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8000a4:	01 d0                	add    %edx,%eax
  8000a6:	8a 00                	mov    (%eax),%al
  8000a8:	3c ff                	cmp    $0xff,%al
  8000aa:	74 14                	je     8000c0 <_main+0x88>
  8000ac:	83 ec 04             	sub    $0x4,%esp
  8000af:	68 fc 1c 80 00       	push   $0x801cfc
  8000b4:	6a 1a                	push   $0x1a
  8000b6:	68 2c 1d 80 00       	push   $0x801d2c
  8000bb:	e8 2c 02 00 00       	call   8002ec <_panic>
		arr[i] = -1 ;


	cprintf_colored(TEXT_cyan, "%~\nchecking REPLACEMENT fault handling of STACK pages... \n");
	{
		for (i = 0 ; i < PAGE_SIZE*10 ; i+=PAGE_SIZE/2)
  8000c0:	81 45 f4 00 08 00 00 	addl   $0x800,-0xc(%ebp)
  8000c7:	81 7d f4 ff 9f 00 00 	cmpl   $0x9fff,-0xc(%ebp)
  8000ce:	7e cb                	jle    80009b <_main+0x63>
			if( arr[i] != -1) panic("modified stack page(s) not restored correctly");

		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  10) panic("Unexpected extra/less pages have been added to page file");
  8000d0:	e8 34 15 00 00       	call   801609 <sys_pf_calculate_allocated_pages>
  8000d5:	2b 45 e8             	sub    -0x18(%ebp),%eax
  8000d8:	83 f8 0a             	cmp    $0xa,%eax
  8000db:	74 14                	je     8000f1 <_main+0xb9>
  8000dd:	83 ec 04             	sub    $0x4,%esp
  8000e0:	68 50 1d 80 00       	push   $0x801d50
  8000e5:	6a 1c                	push   $0x1c
  8000e7:	68 2c 1d 80 00       	push   $0x801d2c
  8000ec:	e8 fb 01 00 00       	call   8002ec <_panic>

		if( (freePages - (sys_calculate_free_frames() + sys_calculate_modified_frames())) != 0 ) panic("Extra memory are wrongly allocated... It's REplacement: expected that no extra frames are allocated");
  8000f1:	e8 c8 14 00 00       	call   8015be <sys_calculate_free_frames>
  8000f6:	89 c3                	mov    %eax,%ebx
  8000f8:	e8 da 14 00 00       	call   8015d7 <sys_calculate_modified_frames>
  8000fd:	8d 14 03             	lea    (%ebx,%eax,1),%edx
  800100:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800103:	39 c2                	cmp    %eax,%edx
  800105:	74 14                	je     80011b <_main+0xe3>
  800107:	83 ec 04             	sub    $0x4,%esp
  80010a:	68 8c 1d 80 00       	push   $0x801d8c
  80010f:	6a 1e                	push   $0x1e
  800111:	68 2c 1d 80 00       	push   $0x801d2c
  800116:	e8 d1 01 00 00       	call   8002ec <_panic>
	}//consider tables of PF, disk pages

	cprintf_colored(TEXT_light_green, "%~\nCongratulations: stack pages created, modified and read is completed successfully\n\n");
  80011b:	83 ec 08             	sub    $0x8,%esp
  80011e:	68 f0 1d 80 00       	push   $0x801df0
  800123:	6a 0a                	push   $0xa
  800125:	e8 bd 04 00 00       	call   8005e7 <cprintf_colored>
  80012a:	83 c4 10             	add    $0x10,%esp


	return;
  80012d:	90                   	nop
}
  80012e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800131:	c9                   	leave  
  800132:	c3                   	ret    

00800133 <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  800133:	55                   	push   %ebp
  800134:	89 e5                	mov    %esp,%ebp
  800136:	57                   	push   %edi
  800137:	56                   	push   %esi
  800138:	53                   	push   %ebx
  800139:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  80013c:	e8 46 16 00 00       	call   801787 <sys_getenvindex>
  800141:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  800144:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800147:	89 d0                	mov    %edx,%eax
  800149:	c1 e0 02             	shl    $0x2,%eax
  80014c:	01 d0                	add    %edx,%eax
  80014e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800155:	01 d0                	add    %edx,%eax
  800157:	89 c2                	mov    %eax,%edx
  800159:	c1 e2 04             	shl    $0x4,%edx
  80015c:	29 c2                	sub    %eax,%edx
  80015e:	8d 04 95 00 00 00 00 	lea    0x0(,%edx,4),%eax
  800165:	89 c2                	mov    %eax,%edx
  800167:	8d 82 00 00 c0 ee    	lea    -0x11400000(%edx),%eax
  80016d:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800172:	a1 20 30 80 00       	mov    0x803020,%eax
  800177:	8a 40 20             	mov    0x20(%eax),%al
  80017a:	84 c0                	test   %al,%al
  80017c:	74 0d                	je     80018b <libmain+0x58>
		binaryname = myEnv->prog_name;
  80017e:	a1 20 30 80 00       	mov    0x803020,%eax
  800183:	83 c0 20             	add    $0x20,%eax
  800186:	a3 04 30 80 00       	mov    %eax,0x803004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80018b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80018f:	7e 0a                	jle    80019b <libmain+0x68>
		binaryname = argv[0];
  800191:	8b 45 0c             	mov    0xc(%ebp),%eax
  800194:	8b 00                	mov    (%eax),%eax
  800196:	a3 04 30 80 00       	mov    %eax,0x803004

	// call user main routine
	_main(argc, argv);
  80019b:	83 ec 08             	sub    $0x8,%esp
  80019e:	ff 75 0c             	pushl  0xc(%ebp)
  8001a1:	ff 75 08             	pushl  0x8(%ebp)
  8001a4:	e8 8f fe ff ff       	call   800038 <_main>
  8001a9:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  8001ac:	a1 00 30 80 00       	mov    0x803000,%eax
  8001b1:	85 c0                	test   %eax,%eax
  8001b3:	0f 84 01 01 00 00    	je     8002ba <libmain+0x187>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  8001b9:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  8001bf:	bb 40 1f 80 00       	mov    $0x801f40,%ebx
  8001c4:	ba 0e 00 00 00       	mov    $0xe,%edx
  8001c9:	89 c7                	mov    %eax,%edi
  8001cb:	89 de                	mov    %ebx,%esi
  8001cd:	89 d1                	mov    %edx,%ecx
  8001cf:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  8001d1:	8d 55 8a             	lea    -0x76(%ebp),%edx
  8001d4:	b9 56 00 00 00       	mov    $0x56,%ecx
  8001d9:	b0 00                	mov    $0x0,%al
  8001db:	89 d7                	mov    %edx,%edi
  8001dd:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  8001df:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  8001e6:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8001e9:	83 ec 08             	sub    $0x8,%esp
  8001ec:	50                   	push   %eax
  8001ed:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  8001f3:	50                   	push   %eax
  8001f4:	e8 c4 17 00 00       	call   8019bd <sys_utilities>
  8001f9:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  8001fc:	e8 0d 13 00 00       	call   80150e <sys_lock_cons>
		{
			cprintf("**************************************\n");
  800201:	83 ec 0c             	sub    $0xc,%esp
  800204:	68 60 1e 80 00       	push   $0x801e60
  800209:	e8 ac 03 00 00       	call   8005ba <cprintf>
  80020e:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  800211:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800214:	85 c0                	test   %eax,%eax
  800216:	74 18                	je     800230 <libmain+0xfd>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  800218:	e8 be 17 00 00       	call   8019db <sys_get_optimal_num_faults>
  80021d:	83 ec 08             	sub    $0x8,%esp
  800220:	50                   	push   %eax
  800221:	68 88 1e 80 00       	push   $0x801e88
  800226:	e8 8f 03 00 00       	call   8005ba <cprintf>
  80022b:	83 c4 10             	add    $0x10,%esp
  80022e:	eb 59                	jmp    800289 <libmain+0x156>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800230:	a1 20 30 80 00       	mov    0x803020,%eax
  800235:	8b 90 bc 05 00 00    	mov    0x5bc(%eax),%edx
  80023b:	a1 20 30 80 00       	mov    0x803020,%eax
  800240:	8b 80 ac 05 00 00    	mov    0x5ac(%eax),%eax
  800246:	83 ec 04             	sub    $0x4,%esp
  800249:	52                   	push   %edx
  80024a:	50                   	push   %eax
  80024b:	68 ac 1e 80 00       	push   $0x801eac
  800250:	e8 65 03 00 00       	call   8005ba <cprintf>
  800255:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800258:	a1 20 30 80 00       	mov    0x803020,%eax
  80025d:	8b 88 d0 05 00 00    	mov    0x5d0(%eax),%ecx
  800263:	a1 20 30 80 00       	mov    0x803020,%eax
  800268:	8b 90 cc 05 00 00    	mov    0x5cc(%eax),%edx
  80026e:	a1 20 30 80 00       	mov    0x803020,%eax
  800273:	8b 80 c8 05 00 00    	mov    0x5c8(%eax),%eax
  800279:	51                   	push   %ecx
  80027a:	52                   	push   %edx
  80027b:	50                   	push   %eax
  80027c:	68 d4 1e 80 00       	push   $0x801ed4
  800281:	e8 34 03 00 00       	call   8005ba <cprintf>
  800286:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800289:	a1 20 30 80 00       	mov    0x803020,%eax
  80028e:	8b 80 d4 05 00 00    	mov    0x5d4(%eax),%eax
  800294:	83 ec 08             	sub    $0x8,%esp
  800297:	50                   	push   %eax
  800298:	68 2c 1f 80 00       	push   $0x801f2c
  80029d:	e8 18 03 00 00       	call   8005ba <cprintf>
  8002a2:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  8002a5:	83 ec 0c             	sub    $0xc,%esp
  8002a8:	68 60 1e 80 00       	push   $0x801e60
  8002ad:	e8 08 03 00 00       	call   8005ba <cprintf>
  8002b2:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  8002b5:	e8 6e 12 00 00       	call   801528 <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  8002ba:	e8 1f 00 00 00       	call   8002de <exit>
}
  8002bf:	90                   	nop
  8002c0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002c3:	5b                   	pop    %ebx
  8002c4:	5e                   	pop    %esi
  8002c5:	5f                   	pop    %edi
  8002c6:	5d                   	pop    %ebp
  8002c7:	c3                   	ret    

008002c8 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8002c8:	55                   	push   %ebp
  8002c9:	89 e5                	mov    %esp,%ebp
  8002cb:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8002ce:	83 ec 0c             	sub    $0xc,%esp
  8002d1:	6a 00                	push   $0x0
  8002d3:	e8 7b 14 00 00       	call   801753 <sys_destroy_env>
  8002d8:	83 c4 10             	add    $0x10,%esp
}
  8002db:	90                   	nop
  8002dc:	c9                   	leave  
  8002dd:	c3                   	ret    

008002de <exit>:

void
exit(void)
{
  8002de:	55                   	push   %ebp
  8002df:	89 e5                	mov    %esp,%ebp
  8002e1:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8002e4:	e8 d0 14 00 00       	call   8017b9 <sys_exit_env>
}
  8002e9:	90                   	nop
  8002ea:	c9                   	leave  
  8002eb:	c3                   	ret    

008002ec <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8002ec:	55                   	push   %ebp
  8002ed:	89 e5                	mov    %esp,%ebp
  8002ef:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8002f2:	8d 45 10             	lea    0x10(%ebp),%eax
  8002f5:	83 c0 04             	add    $0x4,%eax
  8002f8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8002fb:	a1 18 b1 81 00       	mov    0x81b118,%eax
  800300:	85 c0                	test   %eax,%eax
  800302:	74 16                	je     80031a <_panic+0x2e>
		cprintf("%s: ", argv0);
  800304:	a1 18 b1 81 00       	mov    0x81b118,%eax
  800309:	83 ec 08             	sub    $0x8,%esp
  80030c:	50                   	push   %eax
  80030d:	68 a4 1f 80 00       	push   $0x801fa4
  800312:	e8 a3 02 00 00       	call   8005ba <cprintf>
  800317:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  80031a:	a1 04 30 80 00       	mov    0x803004,%eax
  80031f:	83 ec 0c             	sub    $0xc,%esp
  800322:	ff 75 0c             	pushl  0xc(%ebp)
  800325:	ff 75 08             	pushl  0x8(%ebp)
  800328:	50                   	push   %eax
  800329:	68 ac 1f 80 00       	push   $0x801fac
  80032e:	6a 74                	push   $0x74
  800330:	e8 b2 02 00 00       	call   8005e7 <cprintf_colored>
  800335:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  800338:	8b 45 10             	mov    0x10(%ebp),%eax
  80033b:	83 ec 08             	sub    $0x8,%esp
  80033e:	ff 75 f4             	pushl  -0xc(%ebp)
  800341:	50                   	push   %eax
  800342:	e8 04 02 00 00       	call   80054b <vcprintf>
  800347:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  80034a:	83 ec 08             	sub    $0x8,%esp
  80034d:	6a 00                	push   $0x0
  80034f:	68 d4 1f 80 00       	push   $0x801fd4
  800354:	e8 f2 01 00 00       	call   80054b <vcprintf>
  800359:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  80035c:	e8 7d ff ff ff       	call   8002de <exit>

	// should not return here
	while (1) ;
  800361:	eb fe                	jmp    800361 <_panic+0x75>

00800363 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800363:	55                   	push   %ebp
  800364:	89 e5                	mov    %esp,%ebp
  800366:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800369:	a1 20 30 80 00       	mov    0x803020,%eax
  80036e:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800374:	8b 45 0c             	mov    0xc(%ebp),%eax
  800377:	39 c2                	cmp    %eax,%edx
  800379:	74 14                	je     80038f <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  80037b:	83 ec 04             	sub    $0x4,%esp
  80037e:	68 d8 1f 80 00       	push   $0x801fd8
  800383:	6a 26                	push   $0x26
  800385:	68 24 20 80 00       	push   $0x802024
  80038a:	e8 5d ff ff ff       	call   8002ec <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  80038f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800396:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80039d:	e9 c5 00 00 00       	jmp    800467 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  8003a2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003a5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8003af:	01 d0                	add    %edx,%eax
  8003b1:	8b 00                	mov    (%eax),%eax
  8003b3:	85 c0                	test   %eax,%eax
  8003b5:	75 08                	jne    8003bf <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  8003b7:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8003ba:	e9 a5 00 00 00       	jmp    800464 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  8003bf:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8003c6:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8003cd:	eb 69                	jmp    800438 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8003cf:	a1 20 30 80 00       	mov    0x803020,%eax
  8003d4:	8b 88 a4 05 00 00    	mov    0x5a4(%eax),%ecx
  8003da:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8003dd:	89 d0                	mov    %edx,%eax
  8003df:	01 c0                	add    %eax,%eax
  8003e1:	01 d0                	add    %edx,%eax
  8003e3:	c1 e0 03             	shl    $0x3,%eax
  8003e6:	01 c8                	add    %ecx,%eax
  8003e8:	8a 40 04             	mov    0x4(%eax),%al
  8003eb:	84 c0                	test   %al,%al
  8003ed:	75 46                	jne    800435 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8003ef:	a1 20 30 80 00       	mov    0x803020,%eax
  8003f4:	8b 88 a4 05 00 00    	mov    0x5a4(%eax),%ecx
  8003fa:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8003fd:	89 d0                	mov    %edx,%eax
  8003ff:	01 c0                	add    %eax,%eax
  800401:	01 d0                	add    %edx,%eax
  800403:	c1 e0 03             	shl    $0x3,%eax
  800406:	01 c8                	add    %ecx,%eax
  800408:	8b 00                	mov    (%eax),%eax
  80040a:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80040d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800410:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800415:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800417:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80041a:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800421:	8b 45 08             	mov    0x8(%ebp),%eax
  800424:	01 c8                	add    %ecx,%eax
  800426:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800428:	39 c2                	cmp    %eax,%edx
  80042a:	75 09                	jne    800435 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  80042c:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800433:	eb 15                	jmp    80044a <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800435:	ff 45 e8             	incl   -0x18(%ebp)
  800438:	a1 20 30 80 00       	mov    0x803020,%eax
  80043d:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800443:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800446:	39 c2                	cmp    %eax,%edx
  800448:	77 85                	ja     8003cf <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  80044a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80044e:	75 14                	jne    800464 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  800450:	83 ec 04             	sub    $0x4,%esp
  800453:	68 30 20 80 00       	push   $0x802030
  800458:	6a 3a                	push   $0x3a
  80045a:	68 24 20 80 00       	push   $0x802024
  80045f:	e8 88 fe ff ff       	call   8002ec <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800464:	ff 45 f0             	incl   -0x10(%ebp)
  800467:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80046a:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80046d:	0f 8c 2f ff ff ff    	jl     8003a2 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800473:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80047a:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800481:	eb 26                	jmp    8004a9 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800483:	a1 20 30 80 00       	mov    0x803020,%eax
  800488:	8b 88 a4 05 00 00    	mov    0x5a4(%eax),%ecx
  80048e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800491:	89 d0                	mov    %edx,%eax
  800493:	01 c0                	add    %eax,%eax
  800495:	01 d0                	add    %edx,%eax
  800497:	c1 e0 03             	shl    $0x3,%eax
  80049a:	01 c8                	add    %ecx,%eax
  80049c:	8a 40 04             	mov    0x4(%eax),%al
  80049f:	3c 01                	cmp    $0x1,%al
  8004a1:	75 03                	jne    8004a6 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  8004a3:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8004a6:	ff 45 e0             	incl   -0x20(%ebp)
  8004a9:	a1 20 30 80 00       	mov    0x803020,%eax
  8004ae:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8004b4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8004b7:	39 c2                	cmp    %eax,%edx
  8004b9:	77 c8                	ja     800483 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8004bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8004be:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8004c1:	74 14                	je     8004d7 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  8004c3:	83 ec 04             	sub    $0x4,%esp
  8004c6:	68 84 20 80 00       	push   $0x802084
  8004cb:	6a 44                	push   $0x44
  8004cd:	68 24 20 80 00       	push   $0x802024
  8004d2:	e8 15 fe ff ff       	call   8002ec <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8004d7:	90                   	nop
  8004d8:	c9                   	leave  
  8004d9:	c3                   	ret    

008004da <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  8004da:	55                   	push   %ebp
  8004db:	89 e5                	mov    %esp,%ebp
  8004dd:	53                   	push   %ebx
  8004de:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  8004e1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004e4:	8b 00                	mov    (%eax),%eax
  8004e6:	8d 48 01             	lea    0x1(%eax),%ecx
  8004e9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004ec:	89 0a                	mov    %ecx,(%edx)
  8004ee:	8b 55 08             	mov    0x8(%ebp),%edx
  8004f1:	88 d1                	mov    %dl,%cl
  8004f3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004f6:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8004fa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004fd:	8b 00                	mov    (%eax),%eax
  8004ff:	3d ff 00 00 00       	cmp    $0xff,%eax
  800504:	75 30                	jne    800536 <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  800506:	8b 15 1c b1 81 00    	mov    0x81b11c,%edx
  80050c:	a0 44 30 80 00       	mov    0x803044,%al
  800511:	0f b6 c0             	movzbl %al,%eax
  800514:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800517:	8b 09                	mov    (%ecx),%ecx
  800519:	89 cb                	mov    %ecx,%ebx
  80051b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80051e:	83 c1 08             	add    $0x8,%ecx
  800521:	52                   	push   %edx
  800522:	50                   	push   %eax
  800523:	53                   	push   %ebx
  800524:	51                   	push   %ecx
  800525:	e8 a0 0f 00 00       	call   8014ca <sys_cputs>
  80052a:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  80052d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800530:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800536:	8b 45 0c             	mov    0xc(%ebp),%eax
  800539:	8b 40 04             	mov    0x4(%eax),%eax
  80053c:	8d 50 01             	lea    0x1(%eax),%edx
  80053f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800542:	89 50 04             	mov    %edx,0x4(%eax)
}
  800545:	90                   	nop
  800546:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800549:	c9                   	leave  
  80054a:	c3                   	ret    

0080054b <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  80054b:	55                   	push   %ebp
  80054c:	89 e5                	mov    %esp,%ebp
  80054e:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800554:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80055b:	00 00 00 
	b.cnt = 0;
  80055e:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800565:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800568:	ff 75 0c             	pushl  0xc(%ebp)
  80056b:	ff 75 08             	pushl  0x8(%ebp)
  80056e:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800574:	50                   	push   %eax
  800575:	68 da 04 80 00       	push   $0x8004da
  80057a:	e8 5a 02 00 00       	call   8007d9 <vprintfmt>
  80057f:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  800582:	8b 15 1c b1 81 00    	mov    0x81b11c,%edx
  800588:	a0 44 30 80 00       	mov    0x803044,%al
  80058d:	0f b6 c0             	movzbl %al,%eax
  800590:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  800596:	52                   	push   %edx
  800597:	50                   	push   %eax
  800598:	51                   	push   %ecx
  800599:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80059f:	83 c0 08             	add    $0x8,%eax
  8005a2:	50                   	push   %eax
  8005a3:	e8 22 0f 00 00       	call   8014ca <sys_cputs>
  8005a8:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8005ab:	c6 05 44 30 80 00 00 	movb   $0x0,0x803044
	return b.cnt;
  8005b2:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8005b8:	c9                   	leave  
  8005b9:	c3                   	ret    

008005ba <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  8005ba:	55                   	push   %ebp
  8005bb:	89 e5                	mov    %esp,%ebp
  8005bd:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8005c0:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
	va_start(ap, fmt);
  8005c7:	8d 45 0c             	lea    0xc(%ebp),%eax
  8005ca:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8005cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8005d0:	83 ec 08             	sub    $0x8,%esp
  8005d3:	ff 75 f4             	pushl  -0xc(%ebp)
  8005d6:	50                   	push   %eax
  8005d7:	e8 6f ff ff ff       	call   80054b <vcprintf>
  8005dc:	83 c4 10             	add    $0x10,%esp
  8005df:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8005e2:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8005e5:	c9                   	leave  
  8005e6:	c3                   	ret    

008005e7 <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  8005e7:	55                   	push   %ebp
  8005e8:	89 e5                	mov    %esp,%ebp
  8005ea:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8005ed:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
	curTextClr = (textClr << 8) ; //set text color by the given value
  8005f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8005f7:	c1 e0 08             	shl    $0x8,%eax
  8005fa:	a3 1c b1 81 00       	mov    %eax,0x81b11c
	va_start(ap, fmt);
  8005ff:	8d 45 0c             	lea    0xc(%ebp),%eax
  800602:	83 c0 04             	add    $0x4,%eax
  800605:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800608:	8b 45 0c             	mov    0xc(%ebp),%eax
  80060b:	83 ec 08             	sub    $0x8,%esp
  80060e:	ff 75 f4             	pushl  -0xc(%ebp)
  800611:	50                   	push   %eax
  800612:	e8 34 ff ff ff       	call   80054b <vcprintf>
  800617:	83 c4 10             	add    $0x10,%esp
  80061a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  80061d:	c7 05 1c b1 81 00 00 	movl   $0x700,0x81b11c
  800624:	07 00 00 

	return cnt;
  800627:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80062a:	c9                   	leave  
  80062b:	c3                   	ret    

0080062c <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  80062c:	55                   	push   %ebp
  80062d:	89 e5                	mov    %esp,%ebp
  80062f:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  800632:	e8 d7 0e 00 00       	call   80150e <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  800637:	8d 45 0c             	lea    0xc(%ebp),%eax
  80063a:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  80063d:	8b 45 08             	mov    0x8(%ebp),%eax
  800640:	83 ec 08             	sub    $0x8,%esp
  800643:	ff 75 f4             	pushl  -0xc(%ebp)
  800646:	50                   	push   %eax
  800647:	e8 ff fe ff ff       	call   80054b <vcprintf>
  80064c:	83 c4 10             	add    $0x10,%esp
  80064f:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  800652:	e8 d1 0e 00 00       	call   801528 <sys_unlock_cons>
	return cnt;
  800657:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80065a:	c9                   	leave  
  80065b:	c3                   	ret    

0080065c <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80065c:	55                   	push   %ebp
  80065d:	89 e5                	mov    %esp,%ebp
  80065f:	53                   	push   %ebx
  800660:	83 ec 14             	sub    $0x14,%esp
  800663:	8b 45 10             	mov    0x10(%ebp),%eax
  800666:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800669:	8b 45 14             	mov    0x14(%ebp),%eax
  80066c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80066f:	8b 45 18             	mov    0x18(%ebp),%eax
  800672:	ba 00 00 00 00       	mov    $0x0,%edx
  800677:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80067a:	77 55                	ja     8006d1 <printnum+0x75>
  80067c:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80067f:	72 05                	jb     800686 <printnum+0x2a>
  800681:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800684:	77 4b                	ja     8006d1 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800686:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800689:	8d 58 ff             	lea    -0x1(%eax),%ebx
  80068c:	8b 45 18             	mov    0x18(%ebp),%eax
  80068f:	ba 00 00 00 00       	mov    $0x0,%edx
  800694:	52                   	push   %edx
  800695:	50                   	push   %eax
  800696:	ff 75 f4             	pushl  -0xc(%ebp)
  800699:	ff 75 f0             	pushl  -0x10(%ebp)
  80069c:	e8 ab 13 00 00       	call   801a4c <__udivdi3>
  8006a1:	83 c4 10             	add    $0x10,%esp
  8006a4:	83 ec 04             	sub    $0x4,%esp
  8006a7:	ff 75 20             	pushl  0x20(%ebp)
  8006aa:	53                   	push   %ebx
  8006ab:	ff 75 18             	pushl  0x18(%ebp)
  8006ae:	52                   	push   %edx
  8006af:	50                   	push   %eax
  8006b0:	ff 75 0c             	pushl  0xc(%ebp)
  8006b3:	ff 75 08             	pushl  0x8(%ebp)
  8006b6:	e8 a1 ff ff ff       	call   80065c <printnum>
  8006bb:	83 c4 20             	add    $0x20,%esp
  8006be:	eb 1a                	jmp    8006da <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8006c0:	83 ec 08             	sub    $0x8,%esp
  8006c3:	ff 75 0c             	pushl  0xc(%ebp)
  8006c6:	ff 75 20             	pushl  0x20(%ebp)
  8006c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8006cc:	ff d0                	call   *%eax
  8006ce:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8006d1:	ff 4d 1c             	decl   0x1c(%ebp)
  8006d4:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  8006d8:	7f e6                	jg     8006c0 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8006da:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8006dd:	bb 00 00 00 00       	mov    $0x0,%ebx
  8006e2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8006e5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8006e8:	53                   	push   %ebx
  8006e9:	51                   	push   %ecx
  8006ea:	52                   	push   %edx
  8006eb:	50                   	push   %eax
  8006ec:	e8 6b 14 00 00       	call   801b5c <__umoddi3>
  8006f1:	83 c4 10             	add    $0x10,%esp
  8006f4:	05 f4 22 80 00       	add    $0x8022f4,%eax
  8006f9:	8a 00                	mov    (%eax),%al
  8006fb:	0f be c0             	movsbl %al,%eax
  8006fe:	83 ec 08             	sub    $0x8,%esp
  800701:	ff 75 0c             	pushl  0xc(%ebp)
  800704:	50                   	push   %eax
  800705:	8b 45 08             	mov    0x8(%ebp),%eax
  800708:	ff d0                	call   *%eax
  80070a:	83 c4 10             	add    $0x10,%esp
}
  80070d:	90                   	nop
  80070e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800711:	c9                   	leave  
  800712:	c3                   	ret    

00800713 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800713:	55                   	push   %ebp
  800714:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800716:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80071a:	7e 1c                	jle    800738 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  80071c:	8b 45 08             	mov    0x8(%ebp),%eax
  80071f:	8b 00                	mov    (%eax),%eax
  800721:	8d 50 08             	lea    0x8(%eax),%edx
  800724:	8b 45 08             	mov    0x8(%ebp),%eax
  800727:	89 10                	mov    %edx,(%eax)
  800729:	8b 45 08             	mov    0x8(%ebp),%eax
  80072c:	8b 00                	mov    (%eax),%eax
  80072e:	83 e8 08             	sub    $0x8,%eax
  800731:	8b 50 04             	mov    0x4(%eax),%edx
  800734:	8b 00                	mov    (%eax),%eax
  800736:	eb 40                	jmp    800778 <getuint+0x65>
	else if (lflag)
  800738:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80073c:	74 1e                	je     80075c <getuint+0x49>
		return va_arg(*ap, unsigned long);
  80073e:	8b 45 08             	mov    0x8(%ebp),%eax
  800741:	8b 00                	mov    (%eax),%eax
  800743:	8d 50 04             	lea    0x4(%eax),%edx
  800746:	8b 45 08             	mov    0x8(%ebp),%eax
  800749:	89 10                	mov    %edx,(%eax)
  80074b:	8b 45 08             	mov    0x8(%ebp),%eax
  80074e:	8b 00                	mov    (%eax),%eax
  800750:	83 e8 04             	sub    $0x4,%eax
  800753:	8b 00                	mov    (%eax),%eax
  800755:	ba 00 00 00 00       	mov    $0x0,%edx
  80075a:	eb 1c                	jmp    800778 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  80075c:	8b 45 08             	mov    0x8(%ebp),%eax
  80075f:	8b 00                	mov    (%eax),%eax
  800761:	8d 50 04             	lea    0x4(%eax),%edx
  800764:	8b 45 08             	mov    0x8(%ebp),%eax
  800767:	89 10                	mov    %edx,(%eax)
  800769:	8b 45 08             	mov    0x8(%ebp),%eax
  80076c:	8b 00                	mov    (%eax),%eax
  80076e:	83 e8 04             	sub    $0x4,%eax
  800771:	8b 00                	mov    (%eax),%eax
  800773:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800778:	5d                   	pop    %ebp
  800779:	c3                   	ret    

0080077a <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  80077a:	55                   	push   %ebp
  80077b:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80077d:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800781:	7e 1c                	jle    80079f <getint+0x25>
		return va_arg(*ap, long long);
  800783:	8b 45 08             	mov    0x8(%ebp),%eax
  800786:	8b 00                	mov    (%eax),%eax
  800788:	8d 50 08             	lea    0x8(%eax),%edx
  80078b:	8b 45 08             	mov    0x8(%ebp),%eax
  80078e:	89 10                	mov    %edx,(%eax)
  800790:	8b 45 08             	mov    0x8(%ebp),%eax
  800793:	8b 00                	mov    (%eax),%eax
  800795:	83 e8 08             	sub    $0x8,%eax
  800798:	8b 50 04             	mov    0x4(%eax),%edx
  80079b:	8b 00                	mov    (%eax),%eax
  80079d:	eb 38                	jmp    8007d7 <getint+0x5d>
	else if (lflag)
  80079f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8007a3:	74 1a                	je     8007bf <getint+0x45>
		return va_arg(*ap, long);
  8007a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8007a8:	8b 00                	mov    (%eax),%eax
  8007aa:	8d 50 04             	lea    0x4(%eax),%edx
  8007ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8007b0:	89 10                	mov    %edx,(%eax)
  8007b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8007b5:	8b 00                	mov    (%eax),%eax
  8007b7:	83 e8 04             	sub    $0x4,%eax
  8007ba:	8b 00                	mov    (%eax),%eax
  8007bc:	99                   	cltd   
  8007bd:	eb 18                	jmp    8007d7 <getint+0x5d>
	else
		return va_arg(*ap, int);
  8007bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8007c2:	8b 00                	mov    (%eax),%eax
  8007c4:	8d 50 04             	lea    0x4(%eax),%edx
  8007c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8007ca:	89 10                	mov    %edx,(%eax)
  8007cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8007cf:	8b 00                	mov    (%eax),%eax
  8007d1:	83 e8 04             	sub    $0x4,%eax
  8007d4:	8b 00                	mov    (%eax),%eax
  8007d6:	99                   	cltd   
}
  8007d7:	5d                   	pop    %ebp
  8007d8:	c3                   	ret    

008007d9 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8007d9:	55                   	push   %ebp
  8007da:	89 e5                	mov    %esp,%ebp
  8007dc:	56                   	push   %esi
  8007dd:	53                   	push   %ebx
  8007de:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8007e1:	eb 17                	jmp    8007fa <vprintfmt+0x21>
			if (ch == '\0')
  8007e3:	85 db                	test   %ebx,%ebx
  8007e5:	0f 84 c1 03 00 00    	je     800bac <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  8007eb:	83 ec 08             	sub    $0x8,%esp
  8007ee:	ff 75 0c             	pushl  0xc(%ebp)
  8007f1:	53                   	push   %ebx
  8007f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8007f5:	ff d0                	call   *%eax
  8007f7:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8007fa:	8b 45 10             	mov    0x10(%ebp),%eax
  8007fd:	8d 50 01             	lea    0x1(%eax),%edx
  800800:	89 55 10             	mov    %edx,0x10(%ebp)
  800803:	8a 00                	mov    (%eax),%al
  800805:	0f b6 d8             	movzbl %al,%ebx
  800808:	83 fb 25             	cmp    $0x25,%ebx
  80080b:	75 d6                	jne    8007e3 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  80080d:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800811:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800818:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80081f:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800826:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80082d:	8b 45 10             	mov    0x10(%ebp),%eax
  800830:	8d 50 01             	lea    0x1(%eax),%edx
  800833:	89 55 10             	mov    %edx,0x10(%ebp)
  800836:	8a 00                	mov    (%eax),%al
  800838:	0f b6 d8             	movzbl %al,%ebx
  80083b:	8d 43 dd             	lea    -0x23(%ebx),%eax
  80083e:	83 f8 5b             	cmp    $0x5b,%eax
  800841:	0f 87 3d 03 00 00    	ja     800b84 <vprintfmt+0x3ab>
  800847:	8b 04 85 18 23 80 00 	mov    0x802318(,%eax,4),%eax
  80084e:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800850:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800854:	eb d7                	jmp    80082d <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800856:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  80085a:	eb d1                	jmp    80082d <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80085c:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800863:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800866:	89 d0                	mov    %edx,%eax
  800868:	c1 e0 02             	shl    $0x2,%eax
  80086b:	01 d0                	add    %edx,%eax
  80086d:	01 c0                	add    %eax,%eax
  80086f:	01 d8                	add    %ebx,%eax
  800871:	83 e8 30             	sub    $0x30,%eax
  800874:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800877:	8b 45 10             	mov    0x10(%ebp),%eax
  80087a:	8a 00                	mov    (%eax),%al
  80087c:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  80087f:	83 fb 2f             	cmp    $0x2f,%ebx
  800882:	7e 3e                	jle    8008c2 <vprintfmt+0xe9>
  800884:	83 fb 39             	cmp    $0x39,%ebx
  800887:	7f 39                	jg     8008c2 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800889:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  80088c:	eb d5                	jmp    800863 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  80088e:	8b 45 14             	mov    0x14(%ebp),%eax
  800891:	83 c0 04             	add    $0x4,%eax
  800894:	89 45 14             	mov    %eax,0x14(%ebp)
  800897:	8b 45 14             	mov    0x14(%ebp),%eax
  80089a:	83 e8 04             	sub    $0x4,%eax
  80089d:	8b 00                	mov    (%eax),%eax
  80089f:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8008a2:	eb 1f                	jmp    8008c3 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8008a4:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008a8:	79 83                	jns    80082d <vprintfmt+0x54>
				width = 0;
  8008aa:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8008b1:	e9 77 ff ff ff       	jmp    80082d <vprintfmt+0x54>

		case '#':
			altflag = 1;
  8008b6:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  8008bd:	e9 6b ff ff ff       	jmp    80082d <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  8008c2:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8008c3:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008c7:	0f 89 60 ff ff ff    	jns    80082d <vprintfmt+0x54>
				width = precision, precision = -1;
  8008cd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8008d0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8008d3:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  8008da:	e9 4e ff ff ff       	jmp    80082d <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8008df:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  8008e2:	e9 46 ff ff ff       	jmp    80082d <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8008e7:	8b 45 14             	mov    0x14(%ebp),%eax
  8008ea:	83 c0 04             	add    $0x4,%eax
  8008ed:	89 45 14             	mov    %eax,0x14(%ebp)
  8008f0:	8b 45 14             	mov    0x14(%ebp),%eax
  8008f3:	83 e8 04             	sub    $0x4,%eax
  8008f6:	8b 00                	mov    (%eax),%eax
  8008f8:	83 ec 08             	sub    $0x8,%esp
  8008fb:	ff 75 0c             	pushl  0xc(%ebp)
  8008fe:	50                   	push   %eax
  8008ff:	8b 45 08             	mov    0x8(%ebp),%eax
  800902:	ff d0                	call   *%eax
  800904:	83 c4 10             	add    $0x10,%esp
			break;
  800907:	e9 9b 02 00 00       	jmp    800ba7 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  80090c:	8b 45 14             	mov    0x14(%ebp),%eax
  80090f:	83 c0 04             	add    $0x4,%eax
  800912:	89 45 14             	mov    %eax,0x14(%ebp)
  800915:	8b 45 14             	mov    0x14(%ebp),%eax
  800918:	83 e8 04             	sub    $0x4,%eax
  80091b:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  80091d:	85 db                	test   %ebx,%ebx
  80091f:	79 02                	jns    800923 <vprintfmt+0x14a>
				err = -err;
  800921:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800923:	83 fb 64             	cmp    $0x64,%ebx
  800926:	7f 0b                	jg     800933 <vprintfmt+0x15a>
  800928:	8b 34 9d 60 21 80 00 	mov    0x802160(,%ebx,4),%esi
  80092f:	85 f6                	test   %esi,%esi
  800931:	75 19                	jne    80094c <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800933:	53                   	push   %ebx
  800934:	68 05 23 80 00       	push   $0x802305
  800939:	ff 75 0c             	pushl  0xc(%ebp)
  80093c:	ff 75 08             	pushl  0x8(%ebp)
  80093f:	e8 70 02 00 00       	call   800bb4 <printfmt>
  800944:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800947:	e9 5b 02 00 00       	jmp    800ba7 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  80094c:	56                   	push   %esi
  80094d:	68 0e 23 80 00       	push   $0x80230e
  800952:	ff 75 0c             	pushl  0xc(%ebp)
  800955:	ff 75 08             	pushl  0x8(%ebp)
  800958:	e8 57 02 00 00       	call   800bb4 <printfmt>
  80095d:	83 c4 10             	add    $0x10,%esp
			break;
  800960:	e9 42 02 00 00       	jmp    800ba7 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800965:	8b 45 14             	mov    0x14(%ebp),%eax
  800968:	83 c0 04             	add    $0x4,%eax
  80096b:	89 45 14             	mov    %eax,0x14(%ebp)
  80096e:	8b 45 14             	mov    0x14(%ebp),%eax
  800971:	83 e8 04             	sub    $0x4,%eax
  800974:	8b 30                	mov    (%eax),%esi
  800976:	85 f6                	test   %esi,%esi
  800978:	75 05                	jne    80097f <vprintfmt+0x1a6>
				p = "(null)";
  80097a:	be 11 23 80 00       	mov    $0x802311,%esi
			if (width > 0 && padc != '-')
  80097f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800983:	7e 6d                	jle    8009f2 <vprintfmt+0x219>
  800985:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800989:	74 67                	je     8009f2 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  80098b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80098e:	83 ec 08             	sub    $0x8,%esp
  800991:	50                   	push   %eax
  800992:	56                   	push   %esi
  800993:	e8 1e 03 00 00       	call   800cb6 <strnlen>
  800998:	83 c4 10             	add    $0x10,%esp
  80099b:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  80099e:	eb 16                	jmp    8009b6 <vprintfmt+0x1dd>
					putch(padc, putdat);
  8009a0:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  8009a4:	83 ec 08             	sub    $0x8,%esp
  8009a7:	ff 75 0c             	pushl  0xc(%ebp)
  8009aa:	50                   	push   %eax
  8009ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ae:	ff d0                	call   *%eax
  8009b0:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8009b3:	ff 4d e4             	decl   -0x1c(%ebp)
  8009b6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8009ba:	7f e4                	jg     8009a0 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8009bc:	eb 34                	jmp    8009f2 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  8009be:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8009c2:	74 1c                	je     8009e0 <vprintfmt+0x207>
  8009c4:	83 fb 1f             	cmp    $0x1f,%ebx
  8009c7:	7e 05                	jle    8009ce <vprintfmt+0x1f5>
  8009c9:	83 fb 7e             	cmp    $0x7e,%ebx
  8009cc:	7e 12                	jle    8009e0 <vprintfmt+0x207>
					putch('?', putdat);
  8009ce:	83 ec 08             	sub    $0x8,%esp
  8009d1:	ff 75 0c             	pushl  0xc(%ebp)
  8009d4:	6a 3f                	push   $0x3f
  8009d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8009d9:	ff d0                	call   *%eax
  8009db:	83 c4 10             	add    $0x10,%esp
  8009de:	eb 0f                	jmp    8009ef <vprintfmt+0x216>
				else
					putch(ch, putdat);
  8009e0:	83 ec 08             	sub    $0x8,%esp
  8009e3:	ff 75 0c             	pushl  0xc(%ebp)
  8009e6:	53                   	push   %ebx
  8009e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ea:	ff d0                	call   *%eax
  8009ec:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8009ef:	ff 4d e4             	decl   -0x1c(%ebp)
  8009f2:	89 f0                	mov    %esi,%eax
  8009f4:	8d 70 01             	lea    0x1(%eax),%esi
  8009f7:	8a 00                	mov    (%eax),%al
  8009f9:	0f be d8             	movsbl %al,%ebx
  8009fc:	85 db                	test   %ebx,%ebx
  8009fe:	74 24                	je     800a24 <vprintfmt+0x24b>
  800a00:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800a04:	78 b8                	js     8009be <vprintfmt+0x1e5>
  800a06:	ff 4d e0             	decl   -0x20(%ebp)
  800a09:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800a0d:	79 af                	jns    8009be <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800a0f:	eb 13                	jmp    800a24 <vprintfmt+0x24b>
				putch(' ', putdat);
  800a11:	83 ec 08             	sub    $0x8,%esp
  800a14:	ff 75 0c             	pushl  0xc(%ebp)
  800a17:	6a 20                	push   $0x20
  800a19:	8b 45 08             	mov    0x8(%ebp),%eax
  800a1c:	ff d0                	call   *%eax
  800a1e:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800a21:	ff 4d e4             	decl   -0x1c(%ebp)
  800a24:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a28:	7f e7                	jg     800a11 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800a2a:	e9 78 01 00 00       	jmp    800ba7 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800a2f:	83 ec 08             	sub    $0x8,%esp
  800a32:	ff 75 e8             	pushl  -0x18(%ebp)
  800a35:	8d 45 14             	lea    0x14(%ebp),%eax
  800a38:	50                   	push   %eax
  800a39:	e8 3c fd ff ff       	call   80077a <getint>
  800a3e:	83 c4 10             	add    $0x10,%esp
  800a41:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a44:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800a47:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a4a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a4d:	85 d2                	test   %edx,%edx
  800a4f:	79 23                	jns    800a74 <vprintfmt+0x29b>
				putch('-', putdat);
  800a51:	83 ec 08             	sub    $0x8,%esp
  800a54:	ff 75 0c             	pushl  0xc(%ebp)
  800a57:	6a 2d                	push   $0x2d
  800a59:	8b 45 08             	mov    0x8(%ebp),%eax
  800a5c:	ff d0                	call   *%eax
  800a5e:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800a61:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a64:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a67:	f7 d8                	neg    %eax
  800a69:	83 d2 00             	adc    $0x0,%edx
  800a6c:	f7 da                	neg    %edx
  800a6e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a71:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800a74:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800a7b:	e9 bc 00 00 00       	jmp    800b3c <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800a80:	83 ec 08             	sub    $0x8,%esp
  800a83:	ff 75 e8             	pushl  -0x18(%ebp)
  800a86:	8d 45 14             	lea    0x14(%ebp),%eax
  800a89:	50                   	push   %eax
  800a8a:	e8 84 fc ff ff       	call   800713 <getuint>
  800a8f:	83 c4 10             	add    $0x10,%esp
  800a92:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a95:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800a98:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800a9f:	e9 98 00 00 00       	jmp    800b3c <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800aa4:	83 ec 08             	sub    $0x8,%esp
  800aa7:	ff 75 0c             	pushl  0xc(%ebp)
  800aaa:	6a 58                	push   $0x58
  800aac:	8b 45 08             	mov    0x8(%ebp),%eax
  800aaf:	ff d0                	call   *%eax
  800ab1:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800ab4:	83 ec 08             	sub    $0x8,%esp
  800ab7:	ff 75 0c             	pushl  0xc(%ebp)
  800aba:	6a 58                	push   $0x58
  800abc:	8b 45 08             	mov    0x8(%ebp),%eax
  800abf:	ff d0                	call   *%eax
  800ac1:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800ac4:	83 ec 08             	sub    $0x8,%esp
  800ac7:	ff 75 0c             	pushl  0xc(%ebp)
  800aca:	6a 58                	push   $0x58
  800acc:	8b 45 08             	mov    0x8(%ebp),%eax
  800acf:	ff d0                	call   *%eax
  800ad1:	83 c4 10             	add    $0x10,%esp
			break;
  800ad4:	e9 ce 00 00 00       	jmp    800ba7 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800ad9:	83 ec 08             	sub    $0x8,%esp
  800adc:	ff 75 0c             	pushl  0xc(%ebp)
  800adf:	6a 30                	push   $0x30
  800ae1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ae4:	ff d0                	call   *%eax
  800ae6:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800ae9:	83 ec 08             	sub    $0x8,%esp
  800aec:	ff 75 0c             	pushl  0xc(%ebp)
  800aef:	6a 78                	push   $0x78
  800af1:	8b 45 08             	mov    0x8(%ebp),%eax
  800af4:	ff d0                	call   *%eax
  800af6:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800af9:	8b 45 14             	mov    0x14(%ebp),%eax
  800afc:	83 c0 04             	add    $0x4,%eax
  800aff:	89 45 14             	mov    %eax,0x14(%ebp)
  800b02:	8b 45 14             	mov    0x14(%ebp),%eax
  800b05:	83 e8 04             	sub    $0x4,%eax
  800b08:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800b0a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b0d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800b14:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800b1b:	eb 1f                	jmp    800b3c <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800b1d:	83 ec 08             	sub    $0x8,%esp
  800b20:	ff 75 e8             	pushl  -0x18(%ebp)
  800b23:	8d 45 14             	lea    0x14(%ebp),%eax
  800b26:	50                   	push   %eax
  800b27:	e8 e7 fb ff ff       	call   800713 <getuint>
  800b2c:	83 c4 10             	add    $0x10,%esp
  800b2f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b32:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800b35:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800b3c:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800b40:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800b43:	83 ec 04             	sub    $0x4,%esp
  800b46:	52                   	push   %edx
  800b47:	ff 75 e4             	pushl  -0x1c(%ebp)
  800b4a:	50                   	push   %eax
  800b4b:	ff 75 f4             	pushl  -0xc(%ebp)
  800b4e:	ff 75 f0             	pushl  -0x10(%ebp)
  800b51:	ff 75 0c             	pushl  0xc(%ebp)
  800b54:	ff 75 08             	pushl  0x8(%ebp)
  800b57:	e8 00 fb ff ff       	call   80065c <printnum>
  800b5c:	83 c4 20             	add    $0x20,%esp
			break;
  800b5f:	eb 46                	jmp    800ba7 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800b61:	83 ec 08             	sub    $0x8,%esp
  800b64:	ff 75 0c             	pushl  0xc(%ebp)
  800b67:	53                   	push   %ebx
  800b68:	8b 45 08             	mov    0x8(%ebp),%eax
  800b6b:	ff d0                	call   *%eax
  800b6d:	83 c4 10             	add    $0x10,%esp
			break;
  800b70:	eb 35                	jmp    800ba7 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800b72:	c6 05 44 30 80 00 00 	movb   $0x0,0x803044
			break;
  800b79:	eb 2c                	jmp    800ba7 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800b7b:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
			break;
  800b82:	eb 23                	jmp    800ba7 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800b84:	83 ec 08             	sub    $0x8,%esp
  800b87:	ff 75 0c             	pushl  0xc(%ebp)
  800b8a:	6a 25                	push   $0x25
  800b8c:	8b 45 08             	mov    0x8(%ebp),%eax
  800b8f:	ff d0                	call   *%eax
  800b91:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800b94:	ff 4d 10             	decl   0x10(%ebp)
  800b97:	eb 03                	jmp    800b9c <vprintfmt+0x3c3>
  800b99:	ff 4d 10             	decl   0x10(%ebp)
  800b9c:	8b 45 10             	mov    0x10(%ebp),%eax
  800b9f:	48                   	dec    %eax
  800ba0:	8a 00                	mov    (%eax),%al
  800ba2:	3c 25                	cmp    $0x25,%al
  800ba4:	75 f3                	jne    800b99 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800ba6:	90                   	nop
		}
	}
  800ba7:	e9 35 fc ff ff       	jmp    8007e1 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800bac:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800bad:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800bb0:	5b                   	pop    %ebx
  800bb1:	5e                   	pop    %esi
  800bb2:	5d                   	pop    %ebp
  800bb3:	c3                   	ret    

00800bb4 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800bb4:	55                   	push   %ebp
  800bb5:	89 e5                	mov    %esp,%ebp
  800bb7:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800bba:	8d 45 10             	lea    0x10(%ebp),%eax
  800bbd:	83 c0 04             	add    $0x4,%eax
  800bc0:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800bc3:	8b 45 10             	mov    0x10(%ebp),%eax
  800bc6:	ff 75 f4             	pushl  -0xc(%ebp)
  800bc9:	50                   	push   %eax
  800bca:	ff 75 0c             	pushl  0xc(%ebp)
  800bcd:	ff 75 08             	pushl  0x8(%ebp)
  800bd0:	e8 04 fc ff ff       	call   8007d9 <vprintfmt>
  800bd5:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800bd8:	90                   	nop
  800bd9:	c9                   	leave  
  800bda:	c3                   	ret    

00800bdb <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800bdb:	55                   	push   %ebp
  800bdc:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800bde:	8b 45 0c             	mov    0xc(%ebp),%eax
  800be1:	8b 40 08             	mov    0x8(%eax),%eax
  800be4:	8d 50 01             	lea    0x1(%eax),%edx
  800be7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bea:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800bed:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bf0:	8b 10                	mov    (%eax),%edx
  800bf2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bf5:	8b 40 04             	mov    0x4(%eax),%eax
  800bf8:	39 c2                	cmp    %eax,%edx
  800bfa:	73 12                	jae    800c0e <sprintputch+0x33>
		*b->buf++ = ch;
  800bfc:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bff:	8b 00                	mov    (%eax),%eax
  800c01:	8d 48 01             	lea    0x1(%eax),%ecx
  800c04:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c07:	89 0a                	mov    %ecx,(%edx)
  800c09:	8b 55 08             	mov    0x8(%ebp),%edx
  800c0c:	88 10                	mov    %dl,(%eax)
}
  800c0e:	90                   	nop
  800c0f:	5d                   	pop    %ebp
  800c10:	c3                   	ret    

00800c11 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800c11:	55                   	push   %ebp
  800c12:	89 e5                	mov    %esp,%ebp
  800c14:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800c17:	8b 45 08             	mov    0x8(%ebp),%eax
  800c1a:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800c1d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c20:	8d 50 ff             	lea    -0x1(%eax),%edx
  800c23:	8b 45 08             	mov    0x8(%ebp),%eax
  800c26:	01 d0                	add    %edx,%eax
  800c28:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c2b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800c32:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800c36:	74 06                	je     800c3e <vsnprintf+0x2d>
  800c38:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c3c:	7f 07                	jg     800c45 <vsnprintf+0x34>
		return -E_INVAL;
  800c3e:	b8 03 00 00 00       	mov    $0x3,%eax
  800c43:	eb 20                	jmp    800c65 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800c45:	ff 75 14             	pushl  0x14(%ebp)
  800c48:	ff 75 10             	pushl  0x10(%ebp)
  800c4b:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800c4e:	50                   	push   %eax
  800c4f:	68 db 0b 80 00       	push   $0x800bdb
  800c54:	e8 80 fb ff ff       	call   8007d9 <vprintfmt>
  800c59:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800c5c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800c5f:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800c62:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800c65:	c9                   	leave  
  800c66:	c3                   	ret    

00800c67 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800c67:	55                   	push   %ebp
  800c68:	89 e5                	mov    %esp,%ebp
  800c6a:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800c6d:	8d 45 10             	lea    0x10(%ebp),%eax
  800c70:	83 c0 04             	add    $0x4,%eax
  800c73:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800c76:	8b 45 10             	mov    0x10(%ebp),%eax
  800c79:	ff 75 f4             	pushl  -0xc(%ebp)
  800c7c:	50                   	push   %eax
  800c7d:	ff 75 0c             	pushl  0xc(%ebp)
  800c80:	ff 75 08             	pushl  0x8(%ebp)
  800c83:	e8 89 ff ff ff       	call   800c11 <vsnprintf>
  800c88:	83 c4 10             	add    $0x10,%esp
  800c8b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800c8e:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800c91:	c9                   	leave  
  800c92:	c3                   	ret    

00800c93 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800c93:	55                   	push   %ebp
  800c94:	89 e5                	mov    %esp,%ebp
  800c96:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800c99:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800ca0:	eb 06                	jmp    800ca8 <strlen+0x15>
		n++;
  800ca2:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800ca5:	ff 45 08             	incl   0x8(%ebp)
  800ca8:	8b 45 08             	mov    0x8(%ebp),%eax
  800cab:	8a 00                	mov    (%eax),%al
  800cad:	84 c0                	test   %al,%al
  800caf:	75 f1                	jne    800ca2 <strlen+0xf>
		n++;
	return n;
  800cb1:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800cb4:	c9                   	leave  
  800cb5:	c3                   	ret    

00800cb6 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800cb6:	55                   	push   %ebp
  800cb7:	89 e5                	mov    %esp,%ebp
  800cb9:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800cbc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800cc3:	eb 09                	jmp    800cce <strnlen+0x18>
		n++;
  800cc5:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800cc8:	ff 45 08             	incl   0x8(%ebp)
  800ccb:	ff 4d 0c             	decl   0xc(%ebp)
  800cce:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800cd2:	74 09                	je     800cdd <strnlen+0x27>
  800cd4:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd7:	8a 00                	mov    (%eax),%al
  800cd9:	84 c0                	test   %al,%al
  800cdb:	75 e8                	jne    800cc5 <strnlen+0xf>
		n++;
	return n;
  800cdd:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800ce0:	c9                   	leave  
  800ce1:	c3                   	ret    

00800ce2 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800ce2:	55                   	push   %ebp
  800ce3:	89 e5                	mov    %esp,%ebp
  800ce5:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800ce8:	8b 45 08             	mov    0x8(%ebp),%eax
  800ceb:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800cee:	90                   	nop
  800cef:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf2:	8d 50 01             	lea    0x1(%eax),%edx
  800cf5:	89 55 08             	mov    %edx,0x8(%ebp)
  800cf8:	8b 55 0c             	mov    0xc(%ebp),%edx
  800cfb:	8d 4a 01             	lea    0x1(%edx),%ecx
  800cfe:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800d01:	8a 12                	mov    (%edx),%dl
  800d03:	88 10                	mov    %dl,(%eax)
  800d05:	8a 00                	mov    (%eax),%al
  800d07:	84 c0                	test   %al,%al
  800d09:	75 e4                	jne    800cef <strcpy+0xd>
		/* do nothing */;
	return ret;
  800d0b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800d0e:	c9                   	leave  
  800d0f:	c3                   	ret    

00800d10 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800d10:	55                   	push   %ebp
  800d11:	89 e5                	mov    %esp,%ebp
  800d13:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800d16:	8b 45 08             	mov    0x8(%ebp),%eax
  800d19:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800d1c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800d23:	eb 1f                	jmp    800d44 <strncpy+0x34>
		*dst++ = *src;
  800d25:	8b 45 08             	mov    0x8(%ebp),%eax
  800d28:	8d 50 01             	lea    0x1(%eax),%edx
  800d2b:	89 55 08             	mov    %edx,0x8(%ebp)
  800d2e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d31:	8a 12                	mov    (%edx),%dl
  800d33:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800d35:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d38:	8a 00                	mov    (%eax),%al
  800d3a:	84 c0                	test   %al,%al
  800d3c:	74 03                	je     800d41 <strncpy+0x31>
			src++;
  800d3e:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800d41:	ff 45 fc             	incl   -0x4(%ebp)
  800d44:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d47:	3b 45 10             	cmp    0x10(%ebp),%eax
  800d4a:	72 d9                	jb     800d25 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800d4c:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800d4f:	c9                   	leave  
  800d50:	c3                   	ret    

00800d51 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800d51:	55                   	push   %ebp
  800d52:	89 e5                	mov    %esp,%ebp
  800d54:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800d57:	8b 45 08             	mov    0x8(%ebp),%eax
  800d5a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800d5d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d61:	74 30                	je     800d93 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800d63:	eb 16                	jmp    800d7b <strlcpy+0x2a>
			*dst++ = *src++;
  800d65:	8b 45 08             	mov    0x8(%ebp),%eax
  800d68:	8d 50 01             	lea    0x1(%eax),%edx
  800d6b:	89 55 08             	mov    %edx,0x8(%ebp)
  800d6e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d71:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d74:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800d77:	8a 12                	mov    (%edx),%dl
  800d79:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800d7b:	ff 4d 10             	decl   0x10(%ebp)
  800d7e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d82:	74 09                	je     800d8d <strlcpy+0x3c>
  800d84:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d87:	8a 00                	mov    (%eax),%al
  800d89:	84 c0                	test   %al,%al
  800d8b:	75 d8                	jne    800d65 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800d8d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d90:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800d93:	8b 55 08             	mov    0x8(%ebp),%edx
  800d96:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d99:	29 c2                	sub    %eax,%edx
  800d9b:	89 d0                	mov    %edx,%eax
}
  800d9d:	c9                   	leave  
  800d9e:	c3                   	ret    

00800d9f <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800d9f:	55                   	push   %ebp
  800da0:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800da2:	eb 06                	jmp    800daa <strcmp+0xb>
		p++, q++;
  800da4:	ff 45 08             	incl   0x8(%ebp)
  800da7:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800daa:	8b 45 08             	mov    0x8(%ebp),%eax
  800dad:	8a 00                	mov    (%eax),%al
  800daf:	84 c0                	test   %al,%al
  800db1:	74 0e                	je     800dc1 <strcmp+0x22>
  800db3:	8b 45 08             	mov    0x8(%ebp),%eax
  800db6:	8a 10                	mov    (%eax),%dl
  800db8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dbb:	8a 00                	mov    (%eax),%al
  800dbd:	38 c2                	cmp    %al,%dl
  800dbf:	74 e3                	je     800da4 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800dc1:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc4:	8a 00                	mov    (%eax),%al
  800dc6:	0f b6 d0             	movzbl %al,%edx
  800dc9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dcc:	8a 00                	mov    (%eax),%al
  800dce:	0f b6 c0             	movzbl %al,%eax
  800dd1:	29 c2                	sub    %eax,%edx
  800dd3:	89 d0                	mov    %edx,%eax
}
  800dd5:	5d                   	pop    %ebp
  800dd6:	c3                   	ret    

00800dd7 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800dd7:	55                   	push   %ebp
  800dd8:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800dda:	eb 09                	jmp    800de5 <strncmp+0xe>
		n--, p++, q++;
  800ddc:	ff 4d 10             	decl   0x10(%ebp)
  800ddf:	ff 45 08             	incl   0x8(%ebp)
  800de2:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800de5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800de9:	74 17                	je     800e02 <strncmp+0x2b>
  800deb:	8b 45 08             	mov    0x8(%ebp),%eax
  800dee:	8a 00                	mov    (%eax),%al
  800df0:	84 c0                	test   %al,%al
  800df2:	74 0e                	je     800e02 <strncmp+0x2b>
  800df4:	8b 45 08             	mov    0x8(%ebp),%eax
  800df7:	8a 10                	mov    (%eax),%dl
  800df9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dfc:	8a 00                	mov    (%eax),%al
  800dfe:	38 c2                	cmp    %al,%dl
  800e00:	74 da                	je     800ddc <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800e02:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e06:	75 07                	jne    800e0f <strncmp+0x38>
		return 0;
  800e08:	b8 00 00 00 00       	mov    $0x0,%eax
  800e0d:	eb 14                	jmp    800e23 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800e0f:	8b 45 08             	mov    0x8(%ebp),%eax
  800e12:	8a 00                	mov    (%eax),%al
  800e14:	0f b6 d0             	movzbl %al,%edx
  800e17:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e1a:	8a 00                	mov    (%eax),%al
  800e1c:	0f b6 c0             	movzbl %al,%eax
  800e1f:	29 c2                	sub    %eax,%edx
  800e21:	89 d0                	mov    %edx,%eax
}
  800e23:	5d                   	pop    %ebp
  800e24:	c3                   	ret    

00800e25 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800e25:	55                   	push   %ebp
  800e26:	89 e5                	mov    %esp,%ebp
  800e28:	83 ec 04             	sub    $0x4,%esp
  800e2b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e2e:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800e31:	eb 12                	jmp    800e45 <strchr+0x20>
		if (*s == c)
  800e33:	8b 45 08             	mov    0x8(%ebp),%eax
  800e36:	8a 00                	mov    (%eax),%al
  800e38:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800e3b:	75 05                	jne    800e42 <strchr+0x1d>
			return (char *) s;
  800e3d:	8b 45 08             	mov    0x8(%ebp),%eax
  800e40:	eb 11                	jmp    800e53 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800e42:	ff 45 08             	incl   0x8(%ebp)
  800e45:	8b 45 08             	mov    0x8(%ebp),%eax
  800e48:	8a 00                	mov    (%eax),%al
  800e4a:	84 c0                	test   %al,%al
  800e4c:	75 e5                	jne    800e33 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800e4e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e53:	c9                   	leave  
  800e54:	c3                   	ret    

00800e55 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800e55:	55                   	push   %ebp
  800e56:	89 e5                	mov    %esp,%ebp
  800e58:	83 ec 04             	sub    $0x4,%esp
  800e5b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e5e:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800e61:	eb 0d                	jmp    800e70 <strfind+0x1b>
		if (*s == c)
  800e63:	8b 45 08             	mov    0x8(%ebp),%eax
  800e66:	8a 00                	mov    (%eax),%al
  800e68:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800e6b:	74 0e                	je     800e7b <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800e6d:	ff 45 08             	incl   0x8(%ebp)
  800e70:	8b 45 08             	mov    0x8(%ebp),%eax
  800e73:	8a 00                	mov    (%eax),%al
  800e75:	84 c0                	test   %al,%al
  800e77:	75 ea                	jne    800e63 <strfind+0xe>
  800e79:	eb 01                	jmp    800e7c <strfind+0x27>
		if (*s == c)
			break;
  800e7b:	90                   	nop
	return (char *) s;
  800e7c:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e7f:	c9                   	leave  
  800e80:	c3                   	ret    

00800e81 <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  800e81:	55                   	push   %ebp
  800e82:	89 e5                	mov    %esp,%ebp
  800e84:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  800e87:	8b 45 08             	mov    0x8(%ebp),%eax
  800e8a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  800e8d:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800e91:	76 63                	jbe    800ef6 <memset+0x75>
		uint64 data_block = c;
  800e93:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e96:	99                   	cltd   
  800e97:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e9a:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  800e9d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ea0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ea3:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  800ea7:	c1 e0 08             	shl    $0x8,%eax
  800eaa:	09 45 f0             	or     %eax,-0x10(%ebp)
  800ead:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  800eb0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800eb3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800eb6:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  800eba:	c1 e0 10             	shl    $0x10,%eax
  800ebd:	09 45 f0             	or     %eax,-0x10(%ebp)
  800ec0:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  800ec3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ec6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ec9:	89 c2                	mov    %eax,%edx
  800ecb:	b8 00 00 00 00       	mov    $0x0,%eax
  800ed0:	09 45 f0             	or     %eax,-0x10(%ebp)
  800ed3:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  800ed6:	eb 18                	jmp    800ef0 <memset+0x6f>
			*p64++ = data_block, n -= 8;
  800ed8:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  800edb:	8d 41 08             	lea    0x8(%ecx),%eax
  800ede:	89 45 fc             	mov    %eax,-0x4(%ebp)
  800ee1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ee4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ee7:	89 01                	mov    %eax,(%ecx)
  800ee9:	89 51 04             	mov    %edx,0x4(%ecx)
  800eec:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  800ef0:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800ef4:	77 e2                	ja     800ed8 <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  800ef6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800efa:	74 23                	je     800f1f <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  800efc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800eff:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  800f02:	eb 0e                	jmp    800f12 <memset+0x91>
			*p8++ = (uint8)c;
  800f04:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f07:	8d 50 01             	lea    0x1(%eax),%edx
  800f0a:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800f0d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f10:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  800f12:	8b 45 10             	mov    0x10(%ebp),%eax
  800f15:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f18:	89 55 10             	mov    %edx,0x10(%ebp)
  800f1b:	85 c0                	test   %eax,%eax
  800f1d:	75 e5                	jne    800f04 <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  800f1f:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f22:	c9                   	leave  
  800f23:	c3                   	ret    

00800f24 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800f24:	55                   	push   %ebp
  800f25:	89 e5                	mov    %esp,%ebp
  800f27:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  800f2a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f2d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  800f30:	8b 45 08             	mov    0x8(%ebp),%eax
  800f33:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  800f36:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800f3a:	76 24                	jbe    800f60 <memcpy+0x3c>
		while(n >= 8){
  800f3c:	eb 1c                	jmp    800f5a <memcpy+0x36>
			*d64 = *s64;
  800f3e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f41:	8b 50 04             	mov    0x4(%eax),%edx
  800f44:	8b 00                	mov    (%eax),%eax
  800f46:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  800f49:	89 01                	mov    %eax,(%ecx)
  800f4b:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  800f4e:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  800f52:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  800f56:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  800f5a:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800f5e:	77 de                	ja     800f3e <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  800f60:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f64:	74 31                	je     800f97 <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  800f66:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f69:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  800f6c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f6f:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  800f72:	eb 16                	jmp    800f8a <memcpy+0x66>
			*d8++ = *s8++;
  800f74:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800f77:	8d 50 01             	lea    0x1(%eax),%edx
  800f7a:	89 55 f0             	mov    %edx,-0x10(%ebp)
  800f7d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f80:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f83:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  800f86:	8a 12                	mov    (%edx),%dl
  800f88:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  800f8a:	8b 45 10             	mov    0x10(%ebp),%eax
  800f8d:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f90:	89 55 10             	mov    %edx,0x10(%ebp)
  800f93:	85 c0                	test   %eax,%eax
  800f95:	75 dd                	jne    800f74 <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  800f97:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f9a:	c9                   	leave  
  800f9b:	c3                   	ret    

00800f9c <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800f9c:	55                   	push   %ebp
  800f9d:	89 e5                	mov    %esp,%ebp
  800f9f:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800fa2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fa5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800fa8:	8b 45 08             	mov    0x8(%ebp),%eax
  800fab:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800fae:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fb1:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800fb4:	73 50                	jae    801006 <memmove+0x6a>
  800fb6:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800fb9:	8b 45 10             	mov    0x10(%ebp),%eax
  800fbc:	01 d0                	add    %edx,%eax
  800fbe:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800fc1:	76 43                	jbe    801006 <memmove+0x6a>
		s += n;
  800fc3:	8b 45 10             	mov    0x10(%ebp),%eax
  800fc6:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800fc9:	8b 45 10             	mov    0x10(%ebp),%eax
  800fcc:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800fcf:	eb 10                	jmp    800fe1 <memmove+0x45>
			*--d = *--s;
  800fd1:	ff 4d f8             	decl   -0x8(%ebp)
  800fd4:	ff 4d fc             	decl   -0x4(%ebp)
  800fd7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fda:	8a 10                	mov    (%eax),%dl
  800fdc:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fdf:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800fe1:	8b 45 10             	mov    0x10(%ebp),%eax
  800fe4:	8d 50 ff             	lea    -0x1(%eax),%edx
  800fe7:	89 55 10             	mov    %edx,0x10(%ebp)
  800fea:	85 c0                	test   %eax,%eax
  800fec:	75 e3                	jne    800fd1 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800fee:	eb 23                	jmp    801013 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800ff0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ff3:	8d 50 01             	lea    0x1(%eax),%edx
  800ff6:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800ff9:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800ffc:	8d 4a 01             	lea    0x1(%edx),%ecx
  800fff:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801002:	8a 12                	mov    (%edx),%dl
  801004:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801006:	8b 45 10             	mov    0x10(%ebp),%eax
  801009:	8d 50 ff             	lea    -0x1(%eax),%edx
  80100c:	89 55 10             	mov    %edx,0x10(%ebp)
  80100f:	85 c0                	test   %eax,%eax
  801011:	75 dd                	jne    800ff0 <memmove+0x54>
			*d++ = *s++;

	return dst;
  801013:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801016:	c9                   	leave  
  801017:	c3                   	ret    

00801018 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  801018:	55                   	push   %ebp
  801019:	89 e5                	mov    %esp,%ebp
  80101b:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  80101e:	8b 45 08             	mov    0x8(%ebp),%eax
  801021:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  801024:	8b 45 0c             	mov    0xc(%ebp),%eax
  801027:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  80102a:	eb 2a                	jmp    801056 <memcmp+0x3e>
		if (*s1 != *s2)
  80102c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80102f:	8a 10                	mov    (%eax),%dl
  801031:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801034:	8a 00                	mov    (%eax),%al
  801036:	38 c2                	cmp    %al,%dl
  801038:	74 16                	je     801050 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  80103a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80103d:	8a 00                	mov    (%eax),%al
  80103f:	0f b6 d0             	movzbl %al,%edx
  801042:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801045:	8a 00                	mov    (%eax),%al
  801047:	0f b6 c0             	movzbl %al,%eax
  80104a:	29 c2                	sub    %eax,%edx
  80104c:	89 d0                	mov    %edx,%eax
  80104e:	eb 18                	jmp    801068 <memcmp+0x50>
		s1++, s2++;
  801050:	ff 45 fc             	incl   -0x4(%ebp)
  801053:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801056:	8b 45 10             	mov    0x10(%ebp),%eax
  801059:	8d 50 ff             	lea    -0x1(%eax),%edx
  80105c:	89 55 10             	mov    %edx,0x10(%ebp)
  80105f:	85 c0                	test   %eax,%eax
  801061:	75 c9                	jne    80102c <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801063:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801068:	c9                   	leave  
  801069:	c3                   	ret    

0080106a <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  80106a:	55                   	push   %ebp
  80106b:	89 e5                	mov    %esp,%ebp
  80106d:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801070:	8b 55 08             	mov    0x8(%ebp),%edx
  801073:	8b 45 10             	mov    0x10(%ebp),%eax
  801076:	01 d0                	add    %edx,%eax
  801078:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  80107b:	eb 15                	jmp    801092 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  80107d:	8b 45 08             	mov    0x8(%ebp),%eax
  801080:	8a 00                	mov    (%eax),%al
  801082:	0f b6 d0             	movzbl %al,%edx
  801085:	8b 45 0c             	mov    0xc(%ebp),%eax
  801088:	0f b6 c0             	movzbl %al,%eax
  80108b:	39 c2                	cmp    %eax,%edx
  80108d:	74 0d                	je     80109c <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80108f:	ff 45 08             	incl   0x8(%ebp)
  801092:	8b 45 08             	mov    0x8(%ebp),%eax
  801095:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801098:	72 e3                	jb     80107d <memfind+0x13>
  80109a:	eb 01                	jmp    80109d <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  80109c:	90                   	nop
	return (void *) s;
  80109d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8010a0:	c9                   	leave  
  8010a1:	c3                   	ret    

008010a2 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8010a2:	55                   	push   %ebp
  8010a3:	89 e5                	mov    %esp,%ebp
  8010a5:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  8010a8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  8010af:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8010b6:	eb 03                	jmp    8010bb <strtol+0x19>
		s++;
  8010b8:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8010bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8010be:	8a 00                	mov    (%eax),%al
  8010c0:	3c 20                	cmp    $0x20,%al
  8010c2:	74 f4                	je     8010b8 <strtol+0x16>
  8010c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c7:	8a 00                	mov    (%eax),%al
  8010c9:	3c 09                	cmp    $0x9,%al
  8010cb:	74 eb                	je     8010b8 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  8010cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8010d0:	8a 00                	mov    (%eax),%al
  8010d2:	3c 2b                	cmp    $0x2b,%al
  8010d4:	75 05                	jne    8010db <strtol+0x39>
		s++;
  8010d6:	ff 45 08             	incl   0x8(%ebp)
  8010d9:	eb 13                	jmp    8010ee <strtol+0x4c>
	else if (*s == '-')
  8010db:	8b 45 08             	mov    0x8(%ebp),%eax
  8010de:	8a 00                	mov    (%eax),%al
  8010e0:	3c 2d                	cmp    $0x2d,%al
  8010e2:	75 0a                	jne    8010ee <strtol+0x4c>
		s++, neg = 1;
  8010e4:	ff 45 08             	incl   0x8(%ebp)
  8010e7:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8010ee:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010f2:	74 06                	je     8010fa <strtol+0x58>
  8010f4:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8010f8:	75 20                	jne    80111a <strtol+0x78>
  8010fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8010fd:	8a 00                	mov    (%eax),%al
  8010ff:	3c 30                	cmp    $0x30,%al
  801101:	75 17                	jne    80111a <strtol+0x78>
  801103:	8b 45 08             	mov    0x8(%ebp),%eax
  801106:	40                   	inc    %eax
  801107:	8a 00                	mov    (%eax),%al
  801109:	3c 78                	cmp    $0x78,%al
  80110b:	75 0d                	jne    80111a <strtol+0x78>
		s += 2, base = 16;
  80110d:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801111:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801118:	eb 28                	jmp    801142 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  80111a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80111e:	75 15                	jne    801135 <strtol+0x93>
  801120:	8b 45 08             	mov    0x8(%ebp),%eax
  801123:	8a 00                	mov    (%eax),%al
  801125:	3c 30                	cmp    $0x30,%al
  801127:	75 0c                	jne    801135 <strtol+0x93>
		s++, base = 8;
  801129:	ff 45 08             	incl   0x8(%ebp)
  80112c:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801133:	eb 0d                	jmp    801142 <strtol+0xa0>
	else if (base == 0)
  801135:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801139:	75 07                	jne    801142 <strtol+0xa0>
		base = 10;
  80113b:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801142:	8b 45 08             	mov    0x8(%ebp),%eax
  801145:	8a 00                	mov    (%eax),%al
  801147:	3c 2f                	cmp    $0x2f,%al
  801149:	7e 19                	jle    801164 <strtol+0xc2>
  80114b:	8b 45 08             	mov    0x8(%ebp),%eax
  80114e:	8a 00                	mov    (%eax),%al
  801150:	3c 39                	cmp    $0x39,%al
  801152:	7f 10                	jg     801164 <strtol+0xc2>
			dig = *s - '0';
  801154:	8b 45 08             	mov    0x8(%ebp),%eax
  801157:	8a 00                	mov    (%eax),%al
  801159:	0f be c0             	movsbl %al,%eax
  80115c:	83 e8 30             	sub    $0x30,%eax
  80115f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801162:	eb 42                	jmp    8011a6 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801164:	8b 45 08             	mov    0x8(%ebp),%eax
  801167:	8a 00                	mov    (%eax),%al
  801169:	3c 60                	cmp    $0x60,%al
  80116b:	7e 19                	jle    801186 <strtol+0xe4>
  80116d:	8b 45 08             	mov    0x8(%ebp),%eax
  801170:	8a 00                	mov    (%eax),%al
  801172:	3c 7a                	cmp    $0x7a,%al
  801174:	7f 10                	jg     801186 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801176:	8b 45 08             	mov    0x8(%ebp),%eax
  801179:	8a 00                	mov    (%eax),%al
  80117b:	0f be c0             	movsbl %al,%eax
  80117e:	83 e8 57             	sub    $0x57,%eax
  801181:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801184:	eb 20                	jmp    8011a6 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801186:	8b 45 08             	mov    0x8(%ebp),%eax
  801189:	8a 00                	mov    (%eax),%al
  80118b:	3c 40                	cmp    $0x40,%al
  80118d:	7e 39                	jle    8011c8 <strtol+0x126>
  80118f:	8b 45 08             	mov    0x8(%ebp),%eax
  801192:	8a 00                	mov    (%eax),%al
  801194:	3c 5a                	cmp    $0x5a,%al
  801196:	7f 30                	jg     8011c8 <strtol+0x126>
			dig = *s - 'A' + 10;
  801198:	8b 45 08             	mov    0x8(%ebp),%eax
  80119b:	8a 00                	mov    (%eax),%al
  80119d:	0f be c0             	movsbl %al,%eax
  8011a0:	83 e8 37             	sub    $0x37,%eax
  8011a3:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  8011a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8011a9:	3b 45 10             	cmp    0x10(%ebp),%eax
  8011ac:	7d 19                	jge    8011c7 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  8011ae:	ff 45 08             	incl   0x8(%ebp)
  8011b1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011b4:	0f af 45 10          	imul   0x10(%ebp),%eax
  8011b8:	89 c2                	mov    %eax,%edx
  8011ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8011bd:	01 d0                	add    %edx,%eax
  8011bf:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8011c2:	e9 7b ff ff ff       	jmp    801142 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8011c7:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8011c8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8011cc:	74 08                	je     8011d6 <strtol+0x134>
		*endptr = (char *) s;
  8011ce:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011d1:	8b 55 08             	mov    0x8(%ebp),%edx
  8011d4:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8011d6:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8011da:	74 07                	je     8011e3 <strtol+0x141>
  8011dc:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011df:	f7 d8                	neg    %eax
  8011e1:	eb 03                	jmp    8011e6 <strtol+0x144>
  8011e3:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8011e6:	c9                   	leave  
  8011e7:	c3                   	ret    

008011e8 <ltostr>:

void
ltostr(long value, char *str)
{
  8011e8:	55                   	push   %ebp
  8011e9:	89 e5                	mov    %esp,%ebp
  8011eb:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8011ee:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8011f5:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8011fc:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801200:	79 13                	jns    801215 <ltostr+0x2d>
	{
		neg = 1;
  801202:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801209:	8b 45 0c             	mov    0xc(%ebp),%eax
  80120c:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  80120f:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801212:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801215:	8b 45 08             	mov    0x8(%ebp),%eax
  801218:	b9 0a 00 00 00       	mov    $0xa,%ecx
  80121d:	99                   	cltd   
  80121e:	f7 f9                	idiv   %ecx
  801220:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801223:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801226:	8d 50 01             	lea    0x1(%eax),%edx
  801229:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80122c:	89 c2                	mov    %eax,%edx
  80122e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801231:	01 d0                	add    %edx,%eax
  801233:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801236:	83 c2 30             	add    $0x30,%edx
  801239:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  80123b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80123e:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801243:	f7 e9                	imul   %ecx
  801245:	c1 fa 02             	sar    $0x2,%edx
  801248:	89 c8                	mov    %ecx,%eax
  80124a:	c1 f8 1f             	sar    $0x1f,%eax
  80124d:	29 c2                	sub    %eax,%edx
  80124f:	89 d0                	mov    %edx,%eax
  801251:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  801254:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801258:	75 bb                	jne    801215 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  80125a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801261:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801264:	48                   	dec    %eax
  801265:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801268:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80126c:	74 3d                	je     8012ab <ltostr+0xc3>
		start = 1 ;
  80126e:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801275:	eb 34                	jmp    8012ab <ltostr+0xc3>
	{
		char tmp = str[start] ;
  801277:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80127a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80127d:	01 d0                	add    %edx,%eax
  80127f:	8a 00                	mov    (%eax),%al
  801281:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801284:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801287:	8b 45 0c             	mov    0xc(%ebp),%eax
  80128a:	01 c2                	add    %eax,%edx
  80128c:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80128f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801292:	01 c8                	add    %ecx,%eax
  801294:	8a 00                	mov    (%eax),%al
  801296:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801298:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80129b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80129e:	01 c2                	add    %eax,%edx
  8012a0:	8a 45 eb             	mov    -0x15(%ebp),%al
  8012a3:	88 02                	mov    %al,(%edx)
		start++ ;
  8012a5:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8012a8:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8012ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8012ae:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8012b1:	7c c4                	jl     801277 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8012b3:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8012b6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012b9:	01 d0                	add    %edx,%eax
  8012bb:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8012be:	90                   	nop
  8012bf:	c9                   	leave  
  8012c0:	c3                   	ret    

008012c1 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8012c1:	55                   	push   %ebp
  8012c2:	89 e5                	mov    %esp,%ebp
  8012c4:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8012c7:	ff 75 08             	pushl  0x8(%ebp)
  8012ca:	e8 c4 f9 ff ff       	call   800c93 <strlen>
  8012cf:	83 c4 04             	add    $0x4,%esp
  8012d2:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8012d5:	ff 75 0c             	pushl  0xc(%ebp)
  8012d8:	e8 b6 f9 ff ff       	call   800c93 <strlen>
  8012dd:	83 c4 04             	add    $0x4,%esp
  8012e0:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8012e3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8012ea:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8012f1:	eb 17                	jmp    80130a <strcconcat+0x49>
		final[s] = str1[s] ;
  8012f3:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8012f6:	8b 45 10             	mov    0x10(%ebp),%eax
  8012f9:	01 c2                	add    %eax,%edx
  8012fb:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8012fe:	8b 45 08             	mov    0x8(%ebp),%eax
  801301:	01 c8                	add    %ecx,%eax
  801303:	8a 00                	mov    (%eax),%al
  801305:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801307:	ff 45 fc             	incl   -0x4(%ebp)
  80130a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80130d:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801310:	7c e1                	jl     8012f3 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801312:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801319:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801320:	eb 1f                	jmp    801341 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801322:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801325:	8d 50 01             	lea    0x1(%eax),%edx
  801328:	89 55 fc             	mov    %edx,-0x4(%ebp)
  80132b:	89 c2                	mov    %eax,%edx
  80132d:	8b 45 10             	mov    0x10(%ebp),%eax
  801330:	01 c2                	add    %eax,%edx
  801332:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801335:	8b 45 0c             	mov    0xc(%ebp),%eax
  801338:	01 c8                	add    %ecx,%eax
  80133a:	8a 00                	mov    (%eax),%al
  80133c:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  80133e:	ff 45 f8             	incl   -0x8(%ebp)
  801341:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801344:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801347:	7c d9                	jl     801322 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801349:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80134c:	8b 45 10             	mov    0x10(%ebp),%eax
  80134f:	01 d0                	add    %edx,%eax
  801351:	c6 00 00             	movb   $0x0,(%eax)
}
  801354:	90                   	nop
  801355:	c9                   	leave  
  801356:	c3                   	ret    

00801357 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801357:	55                   	push   %ebp
  801358:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  80135a:	8b 45 14             	mov    0x14(%ebp),%eax
  80135d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801363:	8b 45 14             	mov    0x14(%ebp),%eax
  801366:	8b 00                	mov    (%eax),%eax
  801368:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80136f:	8b 45 10             	mov    0x10(%ebp),%eax
  801372:	01 d0                	add    %edx,%eax
  801374:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80137a:	eb 0c                	jmp    801388 <strsplit+0x31>
			*string++ = 0;
  80137c:	8b 45 08             	mov    0x8(%ebp),%eax
  80137f:	8d 50 01             	lea    0x1(%eax),%edx
  801382:	89 55 08             	mov    %edx,0x8(%ebp)
  801385:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801388:	8b 45 08             	mov    0x8(%ebp),%eax
  80138b:	8a 00                	mov    (%eax),%al
  80138d:	84 c0                	test   %al,%al
  80138f:	74 18                	je     8013a9 <strsplit+0x52>
  801391:	8b 45 08             	mov    0x8(%ebp),%eax
  801394:	8a 00                	mov    (%eax),%al
  801396:	0f be c0             	movsbl %al,%eax
  801399:	50                   	push   %eax
  80139a:	ff 75 0c             	pushl  0xc(%ebp)
  80139d:	e8 83 fa ff ff       	call   800e25 <strchr>
  8013a2:	83 c4 08             	add    $0x8,%esp
  8013a5:	85 c0                	test   %eax,%eax
  8013a7:	75 d3                	jne    80137c <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8013a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8013ac:	8a 00                	mov    (%eax),%al
  8013ae:	84 c0                	test   %al,%al
  8013b0:	74 5a                	je     80140c <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8013b2:	8b 45 14             	mov    0x14(%ebp),%eax
  8013b5:	8b 00                	mov    (%eax),%eax
  8013b7:	83 f8 0f             	cmp    $0xf,%eax
  8013ba:	75 07                	jne    8013c3 <strsplit+0x6c>
		{
			return 0;
  8013bc:	b8 00 00 00 00       	mov    $0x0,%eax
  8013c1:	eb 66                	jmp    801429 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8013c3:	8b 45 14             	mov    0x14(%ebp),%eax
  8013c6:	8b 00                	mov    (%eax),%eax
  8013c8:	8d 48 01             	lea    0x1(%eax),%ecx
  8013cb:	8b 55 14             	mov    0x14(%ebp),%edx
  8013ce:	89 0a                	mov    %ecx,(%edx)
  8013d0:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8013d7:	8b 45 10             	mov    0x10(%ebp),%eax
  8013da:	01 c2                	add    %eax,%edx
  8013dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8013df:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8013e1:	eb 03                	jmp    8013e6 <strsplit+0x8f>
			string++;
  8013e3:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8013e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8013e9:	8a 00                	mov    (%eax),%al
  8013eb:	84 c0                	test   %al,%al
  8013ed:	74 8b                	je     80137a <strsplit+0x23>
  8013ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8013f2:	8a 00                	mov    (%eax),%al
  8013f4:	0f be c0             	movsbl %al,%eax
  8013f7:	50                   	push   %eax
  8013f8:	ff 75 0c             	pushl  0xc(%ebp)
  8013fb:	e8 25 fa ff ff       	call   800e25 <strchr>
  801400:	83 c4 08             	add    $0x8,%esp
  801403:	85 c0                	test   %eax,%eax
  801405:	74 dc                	je     8013e3 <strsplit+0x8c>
			string++;
	}
  801407:	e9 6e ff ff ff       	jmp    80137a <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  80140c:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  80140d:	8b 45 14             	mov    0x14(%ebp),%eax
  801410:	8b 00                	mov    (%eax),%eax
  801412:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801419:	8b 45 10             	mov    0x10(%ebp),%eax
  80141c:	01 d0                	add    %edx,%eax
  80141e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801424:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801429:	c9                   	leave  
  80142a:	c3                   	ret    

0080142b <str2lower>:


char* str2lower(char *dst, const char *src)
{
  80142b:	55                   	push   %ebp
  80142c:	89 e5                	mov    %esp,%ebp
  80142e:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  801431:	8b 45 08             	mov    0x8(%ebp),%eax
  801434:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  801437:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80143e:	eb 4a                	jmp    80148a <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  801440:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801443:	8b 45 08             	mov    0x8(%ebp),%eax
  801446:	01 c2                	add    %eax,%edx
  801448:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80144b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80144e:	01 c8                	add    %ecx,%eax
  801450:	8a 00                	mov    (%eax),%al
  801452:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  801454:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801457:	8b 45 0c             	mov    0xc(%ebp),%eax
  80145a:	01 d0                	add    %edx,%eax
  80145c:	8a 00                	mov    (%eax),%al
  80145e:	3c 40                	cmp    $0x40,%al
  801460:	7e 25                	jle    801487 <str2lower+0x5c>
  801462:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801465:	8b 45 0c             	mov    0xc(%ebp),%eax
  801468:	01 d0                	add    %edx,%eax
  80146a:	8a 00                	mov    (%eax),%al
  80146c:	3c 5a                	cmp    $0x5a,%al
  80146e:	7f 17                	jg     801487 <str2lower+0x5c>
		{
			dst[i] += 32 ;
  801470:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801473:	8b 45 08             	mov    0x8(%ebp),%eax
  801476:	01 d0                	add    %edx,%eax
  801478:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80147b:	8b 55 08             	mov    0x8(%ebp),%edx
  80147e:	01 ca                	add    %ecx,%edx
  801480:	8a 12                	mov    (%edx),%dl
  801482:	83 c2 20             	add    $0x20,%edx
  801485:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  801487:	ff 45 fc             	incl   -0x4(%ebp)
  80148a:	ff 75 0c             	pushl  0xc(%ebp)
  80148d:	e8 01 f8 ff ff       	call   800c93 <strlen>
  801492:	83 c4 04             	add    $0x4,%esp
  801495:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801498:	7f a6                	jg     801440 <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  80149a:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80149d:	c9                   	leave  
  80149e:	c3                   	ret    

0080149f <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  80149f:	55                   	push   %ebp
  8014a0:	89 e5                	mov    %esp,%ebp
  8014a2:	57                   	push   %edi
  8014a3:	56                   	push   %esi
  8014a4:	53                   	push   %ebx
  8014a5:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8014a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ab:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014ae:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8014b1:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8014b4:	8b 7d 18             	mov    0x18(%ebp),%edi
  8014b7:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8014ba:	cd 30                	int    $0x30
  8014bc:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  8014bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8014c2:	83 c4 10             	add    $0x10,%esp
  8014c5:	5b                   	pop    %ebx
  8014c6:	5e                   	pop    %esi
  8014c7:	5f                   	pop    %edi
  8014c8:	5d                   	pop    %ebp
  8014c9:	c3                   	ret    

008014ca <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  8014ca:	55                   	push   %ebp
  8014cb:	89 e5                	mov    %esp,%ebp
  8014cd:	83 ec 04             	sub    $0x4,%esp
  8014d0:	8b 45 10             	mov    0x10(%ebp),%eax
  8014d3:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  8014d6:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8014d9:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8014dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8014e0:	6a 00                	push   $0x0
  8014e2:	51                   	push   %ecx
  8014e3:	52                   	push   %edx
  8014e4:	ff 75 0c             	pushl  0xc(%ebp)
  8014e7:	50                   	push   %eax
  8014e8:	6a 00                	push   $0x0
  8014ea:	e8 b0 ff ff ff       	call   80149f <syscall>
  8014ef:	83 c4 18             	add    $0x18,%esp
}
  8014f2:	90                   	nop
  8014f3:	c9                   	leave  
  8014f4:	c3                   	ret    

008014f5 <sys_cgetc>:

int
sys_cgetc(void)
{
  8014f5:	55                   	push   %ebp
  8014f6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8014f8:	6a 00                	push   $0x0
  8014fa:	6a 00                	push   $0x0
  8014fc:	6a 00                	push   $0x0
  8014fe:	6a 00                	push   $0x0
  801500:	6a 00                	push   $0x0
  801502:	6a 02                	push   $0x2
  801504:	e8 96 ff ff ff       	call   80149f <syscall>
  801509:	83 c4 18             	add    $0x18,%esp
}
  80150c:	c9                   	leave  
  80150d:	c3                   	ret    

0080150e <sys_lock_cons>:

void sys_lock_cons(void)
{
  80150e:	55                   	push   %ebp
  80150f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  801511:	6a 00                	push   $0x0
  801513:	6a 00                	push   $0x0
  801515:	6a 00                	push   $0x0
  801517:	6a 00                	push   $0x0
  801519:	6a 00                	push   $0x0
  80151b:	6a 03                	push   $0x3
  80151d:	e8 7d ff ff ff       	call   80149f <syscall>
  801522:	83 c4 18             	add    $0x18,%esp
}
  801525:	90                   	nop
  801526:	c9                   	leave  
  801527:	c3                   	ret    

00801528 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  801528:	55                   	push   %ebp
  801529:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  80152b:	6a 00                	push   $0x0
  80152d:	6a 00                	push   $0x0
  80152f:	6a 00                	push   $0x0
  801531:	6a 00                	push   $0x0
  801533:	6a 00                	push   $0x0
  801535:	6a 04                	push   $0x4
  801537:	e8 63 ff ff ff       	call   80149f <syscall>
  80153c:	83 c4 18             	add    $0x18,%esp
}
  80153f:	90                   	nop
  801540:	c9                   	leave  
  801541:	c3                   	ret    

00801542 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801542:	55                   	push   %ebp
  801543:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801545:	8b 55 0c             	mov    0xc(%ebp),%edx
  801548:	8b 45 08             	mov    0x8(%ebp),%eax
  80154b:	6a 00                	push   $0x0
  80154d:	6a 00                	push   $0x0
  80154f:	6a 00                	push   $0x0
  801551:	52                   	push   %edx
  801552:	50                   	push   %eax
  801553:	6a 08                	push   $0x8
  801555:	e8 45 ff ff ff       	call   80149f <syscall>
  80155a:	83 c4 18             	add    $0x18,%esp
}
  80155d:	c9                   	leave  
  80155e:	c3                   	ret    

0080155f <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  80155f:	55                   	push   %ebp
  801560:	89 e5                	mov    %esp,%ebp
  801562:	56                   	push   %esi
  801563:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801564:	8b 75 18             	mov    0x18(%ebp),%esi
  801567:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80156a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80156d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801570:	8b 45 08             	mov    0x8(%ebp),%eax
  801573:	56                   	push   %esi
  801574:	53                   	push   %ebx
  801575:	51                   	push   %ecx
  801576:	52                   	push   %edx
  801577:	50                   	push   %eax
  801578:	6a 09                	push   $0x9
  80157a:	e8 20 ff ff ff       	call   80149f <syscall>
  80157f:	83 c4 18             	add    $0x18,%esp
}
  801582:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801585:	5b                   	pop    %ebx
  801586:	5e                   	pop    %esi
  801587:	5d                   	pop    %ebp
  801588:	c3                   	ret    

00801589 <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  801589:	55                   	push   %ebp
  80158a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  80158c:	6a 00                	push   $0x0
  80158e:	6a 00                	push   $0x0
  801590:	6a 00                	push   $0x0
  801592:	6a 00                	push   $0x0
  801594:	ff 75 08             	pushl  0x8(%ebp)
  801597:	6a 0a                	push   $0xa
  801599:	e8 01 ff ff ff       	call   80149f <syscall>
  80159e:	83 c4 18             	add    $0x18,%esp
}
  8015a1:	c9                   	leave  
  8015a2:	c3                   	ret    

008015a3 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8015a3:	55                   	push   %ebp
  8015a4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8015a6:	6a 00                	push   $0x0
  8015a8:	6a 00                	push   $0x0
  8015aa:	6a 00                	push   $0x0
  8015ac:	ff 75 0c             	pushl  0xc(%ebp)
  8015af:	ff 75 08             	pushl  0x8(%ebp)
  8015b2:	6a 0b                	push   $0xb
  8015b4:	e8 e6 fe ff ff       	call   80149f <syscall>
  8015b9:	83 c4 18             	add    $0x18,%esp
}
  8015bc:	c9                   	leave  
  8015bd:	c3                   	ret    

008015be <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8015be:	55                   	push   %ebp
  8015bf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8015c1:	6a 00                	push   $0x0
  8015c3:	6a 00                	push   $0x0
  8015c5:	6a 00                	push   $0x0
  8015c7:	6a 00                	push   $0x0
  8015c9:	6a 00                	push   $0x0
  8015cb:	6a 0c                	push   $0xc
  8015cd:	e8 cd fe ff ff       	call   80149f <syscall>
  8015d2:	83 c4 18             	add    $0x18,%esp
}
  8015d5:	c9                   	leave  
  8015d6:	c3                   	ret    

008015d7 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8015d7:	55                   	push   %ebp
  8015d8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8015da:	6a 00                	push   $0x0
  8015dc:	6a 00                	push   $0x0
  8015de:	6a 00                	push   $0x0
  8015e0:	6a 00                	push   $0x0
  8015e2:	6a 00                	push   $0x0
  8015e4:	6a 0d                	push   $0xd
  8015e6:	e8 b4 fe ff ff       	call   80149f <syscall>
  8015eb:	83 c4 18             	add    $0x18,%esp
}
  8015ee:	c9                   	leave  
  8015ef:	c3                   	ret    

008015f0 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8015f0:	55                   	push   %ebp
  8015f1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8015f3:	6a 00                	push   $0x0
  8015f5:	6a 00                	push   $0x0
  8015f7:	6a 00                	push   $0x0
  8015f9:	6a 00                	push   $0x0
  8015fb:	6a 00                	push   $0x0
  8015fd:	6a 0e                	push   $0xe
  8015ff:	e8 9b fe ff ff       	call   80149f <syscall>
  801604:	83 c4 18             	add    $0x18,%esp
}
  801607:	c9                   	leave  
  801608:	c3                   	ret    

00801609 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801609:	55                   	push   %ebp
  80160a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  80160c:	6a 00                	push   $0x0
  80160e:	6a 00                	push   $0x0
  801610:	6a 00                	push   $0x0
  801612:	6a 00                	push   $0x0
  801614:	6a 00                	push   $0x0
  801616:	6a 0f                	push   $0xf
  801618:	e8 82 fe ff ff       	call   80149f <syscall>
  80161d:	83 c4 18             	add    $0x18,%esp
}
  801620:	c9                   	leave  
  801621:	c3                   	ret    

00801622 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801622:	55                   	push   %ebp
  801623:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801625:	6a 00                	push   $0x0
  801627:	6a 00                	push   $0x0
  801629:	6a 00                	push   $0x0
  80162b:	6a 00                	push   $0x0
  80162d:	ff 75 08             	pushl  0x8(%ebp)
  801630:	6a 10                	push   $0x10
  801632:	e8 68 fe ff ff       	call   80149f <syscall>
  801637:	83 c4 18             	add    $0x18,%esp
}
  80163a:	c9                   	leave  
  80163b:	c3                   	ret    

0080163c <sys_scarce_memory>:

void sys_scarce_memory()
{
  80163c:	55                   	push   %ebp
  80163d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  80163f:	6a 00                	push   $0x0
  801641:	6a 00                	push   $0x0
  801643:	6a 00                	push   $0x0
  801645:	6a 00                	push   $0x0
  801647:	6a 00                	push   $0x0
  801649:	6a 11                	push   $0x11
  80164b:	e8 4f fe ff ff       	call   80149f <syscall>
  801650:	83 c4 18             	add    $0x18,%esp
}
  801653:	90                   	nop
  801654:	c9                   	leave  
  801655:	c3                   	ret    

00801656 <sys_cputc>:

void
sys_cputc(const char c)
{
  801656:	55                   	push   %ebp
  801657:	89 e5                	mov    %esp,%ebp
  801659:	83 ec 04             	sub    $0x4,%esp
  80165c:	8b 45 08             	mov    0x8(%ebp),%eax
  80165f:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801662:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801666:	6a 00                	push   $0x0
  801668:	6a 00                	push   $0x0
  80166a:	6a 00                	push   $0x0
  80166c:	6a 00                	push   $0x0
  80166e:	50                   	push   %eax
  80166f:	6a 01                	push   $0x1
  801671:	e8 29 fe ff ff       	call   80149f <syscall>
  801676:	83 c4 18             	add    $0x18,%esp
}
  801679:	90                   	nop
  80167a:	c9                   	leave  
  80167b:	c3                   	ret    

0080167c <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  80167c:	55                   	push   %ebp
  80167d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  80167f:	6a 00                	push   $0x0
  801681:	6a 00                	push   $0x0
  801683:	6a 00                	push   $0x0
  801685:	6a 00                	push   $0x0
  801687:	6a 00                	push   $0x0
  801689:	6a 14                	push   $0x14
  80168b:	e8 0f fe ff ff       	call   80149f <syscall>
  801690:	83 c4 18             	add    $0x18,%esp
}
  801693:	90                   	nop
  801694:	c9                   	leave  
  801695:	c3                   	ret    

00801696 <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801696:	55                   	push   %ebp
  801697:	89 e5                	mov    %esp,%ebp
  801699:	83 ec 04             	sub    $0x4,%esp
  80169c:	8b 45 10             	mov    0x10(%ebp),%eax
  80169f:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8016a2:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8016a5:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8016a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8016ac:	6a 00                	push   $0x0
  8016ae:	51                   	push   %ecx
  8016af:	52                   	push   %edx
  8016b0:	ff 75 0c             	pushl  0xc(%ebp)
  8016b3:	50                   	push   %eax
  8016b4:	6a 15                	push   $0x15
  8016b6:	e8 e4 fd ff ff       	call   80149f <syscall>
  8016bb:	83 c4 18             	add    $0x18,%esp
}
  8016be:	c9                   	leave  
  8016bf:	c3                   	ret    

008016c0 <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  8016c0:	55                   	push   %ebp
  8016c1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8016c3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8016c9:	6a 00                	push   $0x0
  8016cb:	6a 00                	push   $0x0
  8016cd:	6a 00                	push   $0x0
  8016cf:	52                   	push   %edx
  8016d0:	50                   	push   %eax
  8016d1:	6a 16                	push   $0x16
  8016d3:	e8 c7 fd ff ff       	call   80149f <syscall>
  8016d8:	83 c4 18             	add    $0x18,%esp
}
  8016db:	c9                   	leave  
  8016dc:	c3                   	ret    

008016dd <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  8016dd:	55                   	push   %ebp
  8016de:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8016e0:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8016e3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8016e9:	6a 00                	push   $0x0
  8016eb:	6a 00                	push   $0x0
  8016ed:	51                   	push   %ecx
  8016ee:	52                   	push   %edx
  8016ef:	50                   	push   %eax
  8016f0:	6a 17                	push   $0x17
  8016f2:	e8 a8 fd ff ff       	call   80149f <syscall>
  8016f7:	83 c4 18             	add    $0x18,%esp
}
  8016fa:	c9                   	leave  
  8016fb:	c3                   	ret    

008016fc <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  8016fc:	55                   	push   %ebp
  8016fd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8016ff:	8b 55 0c             	mov    0xc(%ebp),%edx
  801702:	8b 45 08             	mov    0x8(%ebp),%eax
  801705:	6a 00                	push   $0x0
  801707:	6a 00                	push   $0x0
  801709:	6a 00                	push   $0x0
  80170b:	52                   	push   %edx
  80170c:	50                   	push   %eax
  80170d:	6a 18                	push   $0x18
  80170f:	e8 8b fd ff ff       	call   80149f <syscall>
  801714:	83 c4 18             	add    $0x18,%esp
}
  801717:	c9                   	leave  
  801718:	c3                   	ret    

00801719 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801719:	55                   	push   %ebp
  80171a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  80171c:	8b 45 08             	mov    0x8(%ebp),%eax
  80171f:	6a 00                	push   $0x0
  801721:	ff 75 14             	pushl  0x14(%ebp)
  801724:	ff 75 10             	pushl  0x10(%ebp)
  801727:	ff 75 0c             	pushl  0xc(%ebp)
  80172a:	50                   	push   %eax
  80172b:	6a 19                	push   $0x19
  80172d:	e8 6d fd ff ff       	call   80149f <syscall>
  801732:	83 c4 18             	add    $0x18,%esp
}
  801735:	c9                   	leave  
  801736:	c3                   	ret    

00801737 <sys_run_env>:

void sys_run_env(int32 envId)
{
  801737:	55                   	push   %ebp
  801738:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  80173a:	8b 45 08             	mov    0x8(%ebp),%eax
  80173d:	6a 00                	push   $0x0
  80173f:	6a 00                	push   $0x0
  801741:	6a 00                	push   $0x0
  801743:	6a 00                	push   $0x0
  801745:	50                   	push   %eax
  801746:	6a 1a                	push   $0x1a
  801748:	e8 52 fd ff ff       	call   80149f <syscall>
  80174d:	83 c4 18             	add    $0x18,%esp
}
  801750:	90                   	nop
  801751:	c9                   	leave  
  801752:	c3                   	ret    

00801753 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801753:	55                   	push   %ebp
  801754:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801756:	8b 45 08             	mov    0x8(%ebp),%eax
  801759:	6a 00                	push   $0x0
  80175b:	6a 00                	push   $0x0
  80175d:	6a 00                	push   $0x0
  80175f:	6a 00                	push   $0x0
  801761:	50                   	push   %eax
  801762:	6a 1b                	push   $0x1b
  801764:	e8 36 fd ff ff       	call   80149f <syscall>
  801769:	83 c4 18             	add    $0x18,%esp
}
  80176c:	c9                   	leave  
  80176d:	c3                   	ret    

0080176e <sys_getenvid>:

int32 sys_getenvid(void)
{
  80176e:	55                   	push   %ebp
  80176f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801771:	6a 00                	push   $0x0
  801773:	6a 00                	push   $0x0
  801775:	6a 00                	push   $0x0
  801777:	6a 00                	push   $0x0
  801779:	6a 00                	push   $0x0
  80177b:	6a 05                	push   $0x5
  80177d:	e8 1d fd ff ff       	call   80149f <syscall>
  801782:	83 c4 18             	add    $0x18,%esp
}
  801785:	c9                   	leave  
  801786:	c3                   	ret    

00801787 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801787:	55                   	push   %ebp
  801788:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  80178a:	6a 00                	push   $0x0
  80178c:	6a 00                	push   $0x0
  80178e:	6a 00                	push   $0x0
  801790:	6a 00                	push   $0x0
  801792:	6a 00                	push   $0x0
  801794:	6a 06                	push   $0x6
  801796:	e8 04 fd ff ff       	call   80149f <syscall>
  80179b:	83 c4 18             	add    $0x18,%esp
}
  80179e:	c9                   	leave  
  80179f:	c3                   	ret    

008017a0 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8017a0:	55                   	push   %ebp
  8017a1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8017a3:	6a 00                	push   $0x0
  8017a5:	6a 00                	push   $0x0
  8017a7:	6a 00                	push   $0x0
  8017a9:	6a 00                	push   $0x0
  8017ab:	6a 00                	push   $0x0
  8017ad:	6a 07                	push   $0x7
  8017af:	e8 eb fc ff ff       	call   80149f <syscall>
  8017b4:	83 c4 18             	add    $0x18,%esp
}
  8017b7:	c9                   	leave  
  8017b8:	c3                   	ret    

008017b9 <sys_exit_env>:


void sys_exit_env(void)
{
  8017b9:	55                   	push   %ebp
  8017ba:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  8017bc:	6a 00                	push   $0x0
  8017be:	6a 00                	push   $0x0
  8017c0:	6a 00                	push   $0x0
  8017c2:	6a 00                	push   $0x0
  8017c4:	6a 00                	push   $0x0
  8017c6:	6a 1c                	push   $0x1c
  8017c8:	e8 d2 fc ff ff       	call   80149f <syscall>
  8017cd:	83 c4 18             	add    $0x18,%esp
}
  8017d0:	90                   	nop
  8017d1:	c9                   	leave  
  8017d2:	c3                   	ret    

008017d3 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  8017d3:	55                   	push   %ebp
  8017d4:	89 e5                	mov    %esp,%ebp
  8017d6:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8017d9:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8017dc:	8d 50 04             	lea    0x4(%eax),%edx
  8017df:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8017e2:	6a 00                	push   $0x0
  8017e4:	6a 00                	push   $0x0
  8017e6:	6a 00                	push   $0x0
  8017e8:	52                   	push   %edx
  8017e9:	50                   	push   %eax
  8017ea:	6a 1d                	push   $0x1d
  8017ec:	e8 ae fc ff ff       	call   80149f <syscall>
  8017f1:	83 c4 18             	add    $0x18,%esp
	return result;
  8017f4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8017f7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8017fa:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8017fd:	89 01                	mov    %eax,(%ecx)
  8017ff:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801802:	8b 45 08             	mov    0x8(%ebp),%eax
  801805:	c9                   	leave  
  801806:	c2 04 00             	ret    $0x4

00801809 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801809:	55                   	push   %ebp
  80180a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  80180c:	6a 00                	push   $0x0
  80180e:	6a 00                	push   $0x0
  801810:	ff 75 10             	pushl  0x10(%ebp)
  801813:	ff 75 0c             	pushl  0xc(%ebp)
  801816:	ff 75 08             	pushl  0x8(%ebp)
  801819:	6a 13                	push   $0x13
  80181b:	e8 7f fc ff ff       	call   80149f <syscall>
  801820:	83 c4 18             	add    $0x18,%esp
	return ;
  801823:	90                   	nop
}
  801824:	c9                   	leave  
  801825:	c3                   	ret    

00801826 <sys_rcr2>:
uint32 sys_rcr2()
{
  801826:	55                   	push   %ebp
  801827:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801829:	6a 00                	push   $0x0
  80182b:	6a 00                	push   $0x0
  80182d:	6a 00                	push   $0x0
  80182f:	6a 00                	push   $0x0
  801831:	6a 00                	push   $0x0
  801833:	6a 1e                	push   $0x1e
  801835:	e8 65 fc ff ff       	call   80149f <syscall>
  80183a:	83 c4 18             	add    $0x18,%esp
}
  80183d:	c9                   	leave  
  80183e:	c3                   	ret    

0080183f <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  80183f:	55                   	push   %ebp
  801840:	89 e5                	mov    %esp,%ebp
  801842:	83 ec 04             	sub    $0x4,%esp
  801845:	8b 45 08             	mov    0x8(%ebp),%eax
  801848:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  80184b:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  80184f:	6a 00                	push   $0x0
  801851:	6a 00                	push   $0x0
  801853:	6a 00                	push   $0x0
  801855:	6a 00                	push   $0x0
  801857:	50                   	push   %eax
  801858:	6a 1f                	push   $0x1f
  80185a:	e8 40 fc ff ff       	call   80149f <syscall>
  80185f:	83 c4 18             	add    $0x18,%esp
	return ;
  801862:	90                   	nop
}
  801863:	c9                   	leave  
  801864:	c3                   	ret    

00801865 <rsttst>:
void rsttst()
{
  801865:	55                   	push   %ebp
  801866:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801868:	6a 00                	push   $0x0
  80186a:	6a 00                	push   $0x0
  80186c:	6a 00                	push   $0x0
  80186e:	6a 00                	push   $0x0
  801870:	6a 00                	push   $0x0
  801872:	6a 21                	push   $0x21
  801874:	e8 26 fc ff ff       	call   80149f <syscall>
  801879:	83 c4 18             	add    $0x18,%esp
	return ;
  80187c:	90                   	nop
}
  80187d:	c9                   	leave  
  80187e:	c3                   	ret    

0080187f <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  80187f:	55                   	push   %ebp
  801880:	89 e5                	mov    %esp,%ebp
  801882:	83 ec 04             	sub    $0x4,%esp
  801885:	8b 45 14             	mov    0x14(%ebp),%eax
  801888:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  80188b:	8b 55 18             	mov    0x18(%ebp),%edx
  80188e:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801892:	52                   	push   %edx
  801893:	50                   	push   %eax
  801894:	ff 75 10             	pushl  0x10(%ebp)
  801897:	ff 75 0c             	pushl  0xc(%ebp)
  80189a:	ff 75 08             	pushl  0x8(%ebp)
  80189d:	6a 20                	push   $0x20
  80189f:	e8 fb fb ff ff       	call   80149f <syscall>
  8018a4:	83 c4 18             	add    $0x18,%esp
	return ;
  8018a7:	90                   	nop
}
  8018a8:	c9                   	leave  
  8018a9:	c3                   	ret    

008018aa <chktst>:
void chktst(uint32 n)
{
  8018aa:	55                   	push   %ebp
  8018ab:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8018ad:	6a 00                	push   $0x0
  8018af:	6a 00                	push   $0x0
  8018b1:	6a 00                	push   $0x0
  8018b3:	6a 00                	push   $0x0
  8018b5:	ff 75 08             	pushl  0x8(%ebp)
  8018b8:	6a 22                	push   $0x22
  8018ba:	e8 e0 fb ff ff       	call   80149f <syscall>
  8018bf:	83 c4 18             	add    $0x18,%esp
	return ;
  8018c2:	90                   	nop
}
  8018c3:	c9                   	leave  
  8018c4:	c3                   	ret    

008018c5 <inctst>:

void inctst()
{
  8018c5:	55                   	push   %ebp
  8018c6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8018c8:	6a 00                	push   $0x0
  8018ca:	6a 00                	push   $0x0
  8018cc:	6a 00                	push   $0x0
  8018ce:	6a 00                	push   $0x0
  8018d0:	6a 00                	push   $0x0
  8018d2:	6a 23                	push   $0x23
  8018d4:	e8 c6 fb ff ff       	call   80149f <syscall>
  8018d9:	83 c4 18             	add    $0x18,%esp
	return ;
  8018dc:	90                   	nop
}
  8018dd:	c9                   	leave  
  8018de:	c3                   	ret    

008018df <gettst>:
uint32 gettst()
{
  8018df:	55                   	push   %ebp
  8018e0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8018e2:	6a 00                	push   $0x0
  8018e4:	6a 00                	push   $0x0
  8018e6:	6a 00                	push   $0x0
  8018e8:	6a 00                	push   $0x0
  8018ea:	6a 00                	push   $0x0
  8018ec:	6a 24                	push   $0x24
  8018ee:	e8 ac fb ff ff       	call   80149f <syscall>
  8018f3:	83 c4 18             	add    $0x18,%esp
}
  8018f6:	c9                   	leave  
  8018f7:	c3                   	ret    

008018f8 <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  8018f8:	55                   	push   %ebp
  8018f9:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8018fb:	6a 00                	push   $0x0
  8018fd:	6a 00                	push   $0x0
  8018ff:	6a 00                	push   $0x0
  801901:	6a 00                	push   $0x0
  801903:	6a 00                	push   $0x0
  801905:	6a 25                	push   $0x25
  801907:	e8 93 fb ff ff       	call   80149f <syscall>
  80190c:	83 c4 18             	add    $0x18,%esp
  80190f:	a3 60 b0 81 00       	mov    %eax,0x81b060
	return uheapPlaceStrategy ;
  801914:	a1 60 b0 81 00       	mov    0x81b060,%eax
}
  801919:	c9                   	leave  
  80191a:	c3                   	ret    

0080191b <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  80191b:	55                   	push   %ebp
  80191c:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  80191e:	8b 45 08             	mov    0x8(%ebp),%eax
  801921:	a3 60 b0 81 00       	mov    %eax,0x81b060
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801926:	6a 00                	push   $0x0
  801928:	6a 00                	push   $0x0
  80192a:	6a 00                	push   $0x0
  80192c:	6a 00                	push   $0x0
  80192e:	ff 75 08             	pushl  0x8(%ebp)
  801931:	6a 26                	push   $0x26
  801933:	e8 67 fb ff ff       	call   80149f <syscall>
  801938:	83 c4 18             	add    $0x18,%esp
	return ;
  80193b:	90                   	nop
}
  80193c:	c9                   	leave  
  80193d:	c3                   	ret    

0080193e <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  80193e:	55                   	push   %ebp
  80193f:	89 e5                	mov    %esp,%ebp
  801941:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801942:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801945:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801948:	8b 55 0c             	mov    0xc(%ebp),%edx
  80194b:	8b 45 08             	mov    0x8(%ebp),%eax
  80194e:	6a 00                	push   $0x0
  801950:	53                   	push   %ebx
  801951:	51                   	push   %ecx
  801952:	52                   	push   %edx
  801953:	50                   	push   %eax
  801954:	6a 27                	push   $0x27
  801956:	e8 44 fb ff ff       	call   80149f <syscall>
  80195b:	83 c4 18             	add    $0x18,%esp
}
  80195e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801961:	c9                   	leave  
  801962:	c3                   	ret    

00801963 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801963:	55                   	push   %ebp
  801964:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801966:	8b 55 0c             	mov    0xc(%ebp),%edx
  801969:	8b 45 08             	mov    0x8(%ebp),%eax
  80196c:	6a 00                	push   $0x0
  80196e:	6a 00                	push   $0x0
  801970:	6a 00                	push   $0x0
  801972:	52                   	push   %edx
  801973:	50                   	push   %eax
  801974:	6a 28                	push   $0x28
  801976:	e8 24 fb ff ff       	call   80149f <syscall>
  80197b:	83 c4 18             	add    $0x18,%esp
}
  80197e:	c9                   	leave  
  80197f:	c3                   	ret    

00801980 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801980:	55                   	push   %ebp
  801981:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801983:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801986:	8b 55 0c             	mov    0xc(%ebp),%edx
  801989:	8b 45 08             	mov    0x8(%ebp),%eax
  80198c:	6a 00                	push   $0x0
  80198e:	51                   	push   %ecx
  80198f:	ff 75 10             	pushl  0x10(%ebp)
  801992:	52                   	push   %edx
  801993:	50                   	push   %eax
  801994:	6a 29                	push   $0x29
  801996:	e8 04 fb ff ff       	call   80149f <syscall>
  80199b:	83 c4 18             	add    $0x18,%esp
}
  80199e:	c9                   	leave  
  80199f:	c3                   	ret    

008019a0 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8019a0:	55                   	push   %ebp
  8019a1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8019a3:	6a 00                	push   $0x0
  8019a5:	6a 00                	push   $0x0
  8019a7:	ff 75 10             	pushl  0x10(%ebp)
  8019aa:	ff 75 0c             	pushl  0xc(%ebp)
  8019ad:	ff 75 08             	pushl  0x8(%ebp)
  8019b0:	6a 12                	push   $0x12
  8019b2:	e8 e8 fa ff ff       	call   80149f <syscall>
  8019b7:	83 c4 18             	add    $0x18,%esp
	return ;
  8019ba:	90                   	nop
}
  8019bb:	c9                   	leave  
  8019bc:	c3                   	ret    

008019bd <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  8019bd:	55                   	push   %ebp
  8019be:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  8019c0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8019c6:	6a 00                	push   $0x0
  8019c8:	6a 00                	push   $0x0
  8019ca:	6a 00                	push   $0x0
  8019cc:	52                   	push   %edx
  8019cd:	50                   	push   %eax
  8019ce:	6a 2a                	push   $0x2a
  8019d0:	e8 ca fa ff ff       	call   80149f <syscall>
  8019d5:	83 c4 18             	add    $0x18,%esp
	return;
  8019d8:	90                   	nop
}
  8019d9:	c9                   	leave  
  8019da:	c3                   	ret    

008019db <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  8019db:	55                   	push   %ebp
  8019dc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  8019de:	6a 00                	push   $0x0
  8019e0:	6a 00                	push   $0x0
  8019e2:	6a 00                	push   $0x0
  8019e4:	6a 00                	push   $0x0
  8019e6:	6a 00                	push   $0x0
  8019e8:	6a 2b                	push   $0x2b
  8019ea:	e8 b0 fa ff ff       	call   80149f <syscall>
  8019ef:	83 c4 18             	add    $0x18,%esp
}
  8019f2:	c9                   	leave  
  8019f3:	c3                   	ret    

008019f4 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8019f4:	55                   	push   %ebp
  8019f5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  8019f7:	6a 00                	push   $0x0
  8019f9:	6a 00                	push   $0x0
  8019fb:	6a 00                	push   $0x0
  8019fd:	ff 75 0c             	pushl  0xc(%ebp)
  801a00:	ff 75 08             	pushl  0x8(%ebp)
  801a03:	6a 2d                	push   $0x2d
  801a05:	e8 95 fa ff ff       	call   80149f <syscall>
  801a0a:	83 c4 18             	add    $0x18,%esp
	return;
  801a0d:	90                   	nop
}
  801a0e:	c9                   	leave  
  801a0f:	c3                   	ret    

00801a10 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801a10:	55                   	push   %ebp
  801a11:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801a13:	6a 00                	push   $0x0
  801a15:	6a 00                	push   $0x0
  801a17:	6a 00                	push   $0x0
  801a19:	ff 75 0c             	pushl  0xc(%ebp)
  801a1c:	ff 75 08             	pushl  0x8(%ebp)
  801a1f:	6a 2c                	push   $0x2c
  801a21:	e8 79 fa ff ff       	call   80149f <syscall>
  801a26:	83 c4 18             	add    $0x18,%esp
	return ;
  801a29:	90                   	nop
}
  801a2a:	c9                   	leave  
  801a2b:	c3                   	ret    

00801a2c <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  801a2c:	55                   	push   %ebp
  801a2d:	89 e5                	mov    %esp,%ebp
	//TODO: [PROJECT'25.IM#4] CPU SCHEDULING - #1 System Calls - Add suitable code here
	//Your code is here
	//Comment the following line
	//panic("sys_env_set_priority() is not implemented yet...!!");
	syscall(SYS_env_set_priority, envID, priority, 0, 0, 0);
  801a2f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a32:	8b 45 08             	mov    0x8(%ebp),%eax
  801a35:	6a 00                	push   $0x0
  801a37:	6a 00                	push   $0x0
  801a39:	6a 00                	push   $0x0
  801a3b:	52                   	push   %edx
  801a3c:	50                   	push   %eax
  801a3d:	6a 2e                	push   $0x2e
  801a3f:	e8 5b fa ff ff       	call   80149f <syscall>
  801a44:	83 c4 18             	add    $0x18,%esp
	    return;
  801a47:	90                   	nop
}
  801a48:	c9                   	leave  
  801a49:	c3                   	ret    
  801a4a:	66 90                	xchg   %ax,%ax

00801a4c <__udivdi3>:
  801a4c:	55                   	push   %ebp
  801a4d:	57                   	push   %edi
  801a4e:	56                   	push   %esi
  801a4f:	53                   	push   %ebx
  801a50:	83 ec 1c             	sub    $0x1c,%esp
  801a53:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801a57:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801a5b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801a5f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801a63:	89 ca                	mov    %ecx,%edx
  801a65:	89 f8                	mov    %edi,%eax
  801a67:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801a6b:	85 f6                	test   %esi,%esi
  801a6d:	75 2d                	jne    801a9c <__udivdi3+0x50>
  801a6f:	39 cf                	cmp    %ecx,%edi
  801a71:	77 65                	ja     801ad8 <__udivdi3+0x8c>
  801a73:	89 fd                	mov    %edi,%ebp
  801a75:	85 ff                	test   %edi,%edi
  801a77:	75 0b                	jne    801a84 <__udivdi3+0x38>
  801a79:	b8 01 00 00 00       	mov    $0x1,%eax
  801a7e:	31 d2                	xor    %edx,%edx
  801a80:	f7 f7                	div    %edi
  801a82:	89 c5                	mov    %eax,%ebp
  801a84:	31 d2                	xor    %edx,%edx
  801a86:	89 c8                	mov    %ecx,%eax
  801a88:	f7 f5                	div    %ebp
  801a8a:	89 c1                	mov    %eax,%ecx
  801a8c:	89 d8                	mov    %ebx,%eax
  801a8e:	f7 f5                	div    %ebp
  801a90:	89 cf                	mov    %ecx,%edi
  801a92:	89 fa                	mov    %edi,%edx
  801a94:	83 c4 1c             	add    $0x1c,%esp
  801a97:	5b                   	pop    %ebx
  801a98:	5e                   	pop    %esi
  801a99:	5f                   	pop    %edi
  801a9a:	5d                   	pop    %ebp
  801a9b:	c3                   	ret    
  801a9c:	39 ce                	cmp    %ecx,%esi
  801a9e:	77 28                	ja     801ac8 <__udivdi3+0x7c>
  801aa0:	0f bd fe             	bsr    %esi,%edi
  801aa3:	83 f7 1f             	xor    $0x1f,%edi
  801aa6:	75 40                	jne    801ae8 <__udivdi3+0x9c>
  801aa8:	39 ce                	cmp    %ecx,%esi
  801aaa:	72 0a                	jb     801ab6 <__udivdi3+0x6a>
  801aac:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801ab0:	0f 87 9e 00 00 00    	ja     801b54 <__udivdi3+0x108>
  801ab6:	b8 01 00 00 00       	mov    $0x1,%eax
  801abb:	89 fa                	mov    %edi,%edx
  801abd:	83 c4 1c             	add    $0x1c,%esp
  801ac0:	5b                   	pop    %ebx
  801ac1:	5e                   	pop    %esi
  801ac2:	5f                   	pop    %edi
  801ac3:	5d                   	pop    %ebp
  801ac4:	c3                   	ret    
  801ac5:	8d 76 00             	lea    0x0(%esi),%esi
  801ac8:	31 ff                	xor    %edi,%edi
  801aca:	31 c0                	xor    %eax,%eax
  801acc:	89 fa                	mov    %edi,%edx
  801ace:	83 c4 1c             	add    $0x1c,%esp
  801ad1:	5b                   	pop    %ebx
  801ad2:	5e                   	pop    %esi
  801ad3:	5f                   	pop    %edi
  801ad4:	5d                   	pop    %ebp
  801ad5:	c3                   	ret    
  801ad6:	66 90                	xchg   %ax,%ax
  801ad8:	89 d8                	mov    %ebx,%eax
  801ada:	f7 f7                	div    %edi
  801adc:	31 ff                	xor    %edi,%edi
  801ade:	89 fa                	mov    %edi,%edx
  801ae0:	83 c4 1c             	add    $0x1c,%esp
  801ae3:	5b                   	pop    %ebx
  801ae4:	5e                   	pop    %esi
  801ae5:	5f                   	pop    %edi
  801ae6:	5d                   	pop    %ebp
  801ae7:	c3                   	ret    
  801ae8:	bd 20 00 00 00       	mov    $0x20,%ebp
  801aed:	89 eb                	mov    %ebp,%ebx
  801aef:	29 fb                	sub    %edi,%ebx
  801af1:	89 f9                	mov    %edi,%ecx
  801af3:	d3 e6                	shl    %cl,%esi
  801af5:	89 c5                	mov    %eax,%ebp
  801af7:	88 d9                	mov    %bl,%cl
  801af9:	d3 ed                	shr    %cl,%ebp
  801afb:	89 e9                	mov    %ebp,%ecx
  801afd:	09 f1                	or     %esi,%ecx
  801aff:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801b03:	89 f9                	mov    %edi,%ecx
  801b05:	d3 e0                	shl    %cl,%eax
  801b07:	89 c5                	mov    %eax,%ebp
  801b09:	89 d6                	mov    %edx,%esi
  801b0b:	88 d9                	mov    %bl,%cl
  801b0d:	d3 ee                	shr    %cl,%esi
  801b0f:	89 f9                	mov    %edi,%ecx
  801b11:	d3 e2                	shl    %cl,%edx
  801b13:	8b 44 24 08          	mov    0x8(%esp),%eax
  801b17:	88 d9                	mov    %bl,%cl
  801b19:	d3 e8                	shr    %cl,%eax
  801b1b:	09 c2                	or     %eax,%edx
  801b1d:	89 d0                	mov    %edx,%eax
  801b1f:	89 f2                	mov    %esi,%edx
  801b21:	f7 74 24 0c          	divl   0xc(%esp)
  801b25:	89 d6                	mov    %edx,%esi
  801b27:	89 c3                	mov    %eax,%ebx
  801b29:	f7 e5                	mul    %ebp
  801b2b:	39 d6                	cmp    %edx,%esi
  801b2d:	72 19                	jb     801b48 <__udivdi3+0xfc>
  801b2f:	74 0b                	je     801b3c <__udivdi3+0xf0>
  801b31:	89 d8                	mov    %ebx,%eax
  801b33:	31 ff                	xor    %edi,%edi
  801b35:	e9 58 ff ff ff       	jmp    801a92 <__udivdi3+0x46>
  801b3a:	66 90                	xchg   %ax,%ax
  801b3c:	8b 54 24 08          	mov    0x8(%esp),%edx
  801b40:	89 f9                	mov    %edi,%ecx
  801b42:	d3 e2                	shl    %cl,%edx
  801b44:	39 c2                	cmp    %eax,%edx
  801b46:	73 e9                	jae    801b31 <__udivdi3+0xe5>
  801b48:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801b4b:	31 ff                	xor    %edi,%edi
  801b4d:	e9 40 ff ff ff       	jmp    801a92 <__udivdi3+0x46>
  801b52:	66 90                	xchg   %ax,%ax
  801b54:	31 c0                	xor    %eax,%eax
  801b56:	e9 37 ff ff ff       	jmp    801a92 <__udivdi3+0x46>
  801b5b:	90                   	nop

00801b5c <__umoddi3>:
  801b5c:	55                   	push   %ebp
  801b5d:	57                   	push   %edi
  801b5e:	56                   	push   %esi
  801b5f:	53                   	push   %ebx
  801b60:	83 ec 1c             	sub    $0x1c,%esp
  801b63:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801b67:	8b 74 24 34          	mov    0x34(%esp),%esi
  801b6b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801b6f:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801b73:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801b77:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801b7b:	89 f3                	mov    %esi,%ebx
  801b7d:	89 fa                	mov    %edi,%edx
  801b7f:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801b83:	89 34 24             	mov    %esi,(%esp)
  801b86:	85 c0                	test   %eax,%eax
  801b88:	75 1a                	jne    801ba4 <__umoddi3+0x48>
  801b8a:	39 f7                	cmp    %esi,%edi
  801b8c:	0f 86 a2 00 00 00    	jbe    801c34 <__umoddi3+0xd8>
  801b92:	89 c8                	mov    %ecx,%eax
  801b94:	89 f2                	mov    %esi,%edx
  801b96:	f7 f7                	div    %edi
  801b98:	89 d0                	mov    %edx,%eax
  801b9a:	31 d2                	xor    %edx,%edx
  801b9c:	83 c4 1c             	add    $0x1c,%esp
  801b9f:	5b                   	pop    %ebx
  801ba0:	5e                   	pop    %esi
  801ba1:	5f                   	pop    %edi
  801ba2:	5d                   	pop    %ebp
  801ba3:	c3                   	ret    
  801ba4:	39 f0                	cmp    %esi,%eax
  801ba6:	0f 87 ac 00 00 00    	ja     801c58 <__umoddi3+0xfc>
  801bac:	0f bd e8             	bsr    %eax,%ebp
  801baf:	83 f5 1f             	xor    $0x1f,%ebp
  801bb2:	0f 84 ac 00 00 00    	je     801c64 <__umoddi3+0x108>
  801bb8:	bf 20 00 00 00       	mov    $0x20,%edi
  801bbd:	29 ef                	sub    %ebp,%edi
  801bbf:	89 fe                	mov    %edi,%esi
  801bc1:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801bc5:	89 e9                	mov    %ebp,%ecx
  801bc7:	d3 e0                	shl    %cl,%eax
  801bc9:	89 d7                	mov    %edx,%edi
  801bcb:	89 f1                	mov    %esi,%ecx
  801bcd:	d3 ef                	shr    %cl,%edi
  801bcf:	09 c7                	or     %eax,%edi
  801bd1:	89 e9                	mov    %ebp,%ecx
  801bd3:	d3 e2                	shl    %cl,%edx
  801bd5:	89 14 24             	mov    %edx,(%esp)
  801bd8:	89 d8                	mov    %ebx,%eax
  801bda:	d3 e0                	shl    %cl,%eax
  801bdc:	89 c2                	mov    %eax,%edx
  801bde:	8b 44 24 08          	mov    0x8(%esp),%eax
  801be2:	d3 e0                	shl    %cl,%eax
  801be4:	89 44 24 04          	mov    %eax,0x4(%esp)
  801be8:	8b 44 24 08          	mov    0x8(%esp),%eax
  801bec:	89 f1                	mov    %esi,%ecx
  801bee:	d3 e8                	shr    %cl,%eax
  801bf0:	09 d0                	or     %edx,%eax
  801bf2:	d3 eb                	shr    %cl,%ebx
  801bf4:	89 da                	mov    %ebx,%edx
  801bf6:	f7 f7                	div    %edi
  801bf8:	89 d3                	mov    %edx,%ebx
  801bfa:	f7 24 24             	mull   (%esp)
  801bfd:	89 c6                	mov    %eax,%esi
  801bff:	89 d1                	mov    %edx,%ecx
  801c01:	39 d3                	cmp    %edx,%ebx
  801c03:	0f 82 87 00 00 00    	jb     801c90 <__umoddi3+0x134>
  801c09:	0f 84 91 00 00 00    	je     801ca0 <__umoddi3+0x144>
  801c0f:	8b 54 24 04          	mov    0x4(%esp),%edx
  801c13:	29 f2                	sub    %esi,%edx
  801c15:	19 cb                	sbb    %ecx,%ebx
  801c17:	89 d8                	mov    %ebx,%eax
  801c19:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801c1d:	d3 e0                	shl    %cl,%eax
  801c1f:	89 e9                	mov    %ebp,%ecx
  801c21:	d3 ea                	shr    %cl,%edx
  801c23:	09 d0                	or     %edx,%eax
  801c25:	89 e9                	mov    %ebp,%ecx
  801c27:	d3 eb                	shr    %cl,%ebx
  801c29:	89 da                	mov    %ebx,%edx
  801c2b:	83 c4 1c             	add    $0x1c,%esp
  801c2e:	5b                   	pop    %ebx
  801c2f:	5e                   	pop    %esi
  801c30:	5f                   	pop    %edi
  801c31:	5d                   	pop    %ebp
  801c32:	c3                   	ret    
  801c33:	90                   	nop
  801c34:	89 fd                	mov    %edi,%ebp
  801c36:	85 ff                	test   %edi,%edi
  801c38:	75 0b                	jne    801c45 <__umoddi3+0xe9>
  801c3a:	b8 01 00 00 00       	mov    $0x1,%eax
  801c3f:	31 d2                	xor    %edx,%edx
  801c41:	f7 f7                	div    %edi
  801c43:	89 c5                	mov    %eax,%ebp
  801c45:	89 f0                	mov    %esi,%eax
  801c47:	31 d2                	xor    %edx,%edx
  801c49:	f7 f5                	div    %ebp
  801c4b:	89 c8                	mov    %ecx,%eax
  801c4d:	f7 f5                	div    %ebp
  801c4f:	89 d0                	mov    %edx,%eax
  801c51:	e9 44 ff ff ff       	jmp    801b9a <__umoddi3+0x3e>
  801c56:	66 90                	xchg   %ax,%ax
  801c58:	89 c8                	mov    %ecx,%eax
  801c5a:	89 f2                	mov    %esi,%edx
  801c5c:	83 c4 1c             	add    $0x1c,%esp
  801c5f:	5b                   	pop    %ebx
  801c60:	5e                   	pop    %esi
  801c61:	5f                   	pop    %edi
  801c62:	5d                   	pop    %ebp
  801c63:	c3                   	ret    
  801c64:	3b 04 24             	cmp    (%esp),%eax
  801c67:	72 06                	jb     801c6f <__umoddi3+0x113>
  801c69:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801c6d:	77 0f                	ja     801c7e <__umoddi3+0x122>
  801c6f:	89 f2                	mov    %esi,%edx
  801c71:	29 f9                	sub    %edi,%ecx
  801c73:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801c77:	89 14 24             	mov    %edx,(%esp)
  801c7a:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801c7e:	8b 44 24 04          	mov    0x4(%esp),%eax
  801c82:	8b 14 24             	mov    (%esp),%edx
  801c85:	83 c4 1c             	add    $0x1c,%esp
  801c88:	5b                   	pop    %ebx
  801c89:	5e                   	pop    %esi
  801c8a:	5f                   	pop    %edi
  801c8b:	5d                   	pop    %ebp
  801c8c:	c3                   	ret    
  801c8d:	8d 76 00             	lea    0x0(%esi),%esi
  801c90:	2b 04 24             	sub    (%esp),%eax
  801c93:	19 fa                	sbb    %edi,%edx
  801c95:	89 d1                	mov    %edx,%ecx
  801c97:	89 c6                	mov    %eax,%esi
  801c99:	e9 71 ff ff ff       	jmp    801c0f <__umoddi3+0xb3>
  801c9e:	66 90                	xchg   %ax,%ax
  801ca0:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801ca4:	72 ea                	jb     801c90 <__umoddi3+0x134>
  801ca6:	89 d9                	mov    %ebx,%ecx
  801ca8:	e9 62 ff ff ff       	jmp    801c0f <__umoddi3+0xb3>
