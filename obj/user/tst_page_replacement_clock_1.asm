
obj/user/tst_page_replacement_clock_1:     file format elf32-i386


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
  800031:	e8 a1 01 00 00       	call   8001d7 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
uint32 expectedFinalVAs[11] = {
		0xeebfd000, 	//Stack
		0x800000, 0x809000, 0x80a000, 0x803000, 0x801000, 0x804000, 0x80b000, 0x80c000, 0x827000, 0x802000, 	//Code & Data
} ;
void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	83 ec 28             	sub    $0x28,%esp
	//("STEP 0: checking Initial WS entries ...\n");
	bool found ;

#if USE_KHEAP
	{
		found = sys_check_WS_list(expectedInitialVAs, 11, 0x800000, 1);
  80003e:	6a 01                	push   $0x1
  800040:	68 00 00 80 00       	push   $0x800000
  800045:	6a 0b                	push   $0xb
  800047:	68 20 30 80 00       	push   $0x803020
  80004c:	e8 d3 19 00 00       	call   801a24 <sys_check_WS_list>
  800051:	83 c4 10             	add    $0x10,%esp
  800054:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (found != 1) panic("INITIAL PAGE WS entry checking failed! Review size of the WS!!\n*****IF CORRECT, CHECK THE ISSUE WITH THE STAFF*****");
  800057:	83 7d ec 01          	cmpl   $0x1,-0x14(%ebp)
  80005b:	74 14                	je     800071 <_main+0x39>
  80005d:	83 ec 04             	sub    $0x4,%esp
  800060:	68 60 1d 80 00       	push   $0x801d60
  800065:	6a 1b                	push   $0x1b
  800067:	68 d4 1d 80 00       	push   $0x801dd4
  80006c:	e8 1f 03 00 00       	call   800390 <_panic>
#else
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif

	//Writing (Modified)
	__arr__[PAGE_SIZE*10-1] = 'a' ;
  800071:	c6 05 df d0 80 00 61 	movb   $0x61,0x80d0df

	//Reading (Not Modified)
	char garbage1 = __arr__[PAGE_SIZE*11-1] ;
  800078:	a0 df e0 80 00       	mov    0x80e0df,%al
  80007d:	88 45 eb             	mov    %al,-0x15(%ebp)
	char garbage2 = __arr__[PAGE_SIZE*12-1] ;
  800080:	a0 df f0 80 00       	mov    0x80f0df,%al
  800085:	88 45 ea             	mov    %al,-0x16(%ebp)
	char garbage4,garbage5;

	//Writing (Modified)
	int i ;
	for (i = 0 ; i < PAGE_SIZE*10 ; i+=PAGE_SIZE/2)
  800088:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80008f:	eb 26                	jmp    8000b7 <_main+0x7f>
	{
		__arr__[i] = -1 ;
  800091:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800094:	05 e0 30 80 00       	add    $0x8030e0,%eax
  800099:	c6 00 ff             	movb   $0xff,(%eax)
		/*2016: this BUGGY line is REMOVED el7! it overwrites the KERNEL CODE :( !!!*/
		//*__ptr__ = *__ptr2__ ;
		/*==========================================================================*/
		//always use pages at 0x801000 and 0x804000
		garbage4 = *__ptr__ ;
  80009c:	a1 00 30 80 00       	mov    0x803000,%eax
  8000a1:	8a 00                	mov    (%eax),%al
  8000a3:	88 45 f7             	mov    %al,-0x9(%ebp)
		garbage5 = *__ptr2__ ;
  8000a6:	a1 04 30 80 00       	mov    0x803004,%eax
  8000ab:	8a 00                	mov    (%eax),%al
  8000ad:	88 45 f6             	mov    %al,-0xa(%ebp)
	char garbage2 = __arr__[PAGE_SIZE*12-1] ;
	char garbage4,garbage5;

	//Writing (Modified)
	int i ;
	for (i = 0 ; i < PAGE_SIZE*10 ; i+=PAGE_SIZE/2)
  8000b0:	81 45 f0 00 08 00 00 	addl   $0x800,-0x10(%ebp)
  8000b7:	81 7d f0 ff 9f 00 00 	cmpl   $0x9fff,-0x10(%ebp)
  8000be:	7e d1                	jle    800091 <_main+0x59>
		garbage5 = *__ptr2__ ;
	}

	//===================

	cprintf_colored(TEXT_cyan, "%~\nChecking Content... \n");
  8000c0:	83 ec 08             	sub    $0x8,%esp
  8000c3:	68 f8 1d 80 00       	push   $0x801df8
  8000c8:	6a 03                	push   $0x3
  8000ca:	e8 bc 05 00 00       	call   80068b <cprintf_colored>
  8000cf:	83 c4 10             	add    $0x10,%esp
	{
		if (garbage4 != *__ptr__) panic("test failed!");
  8000d2:	a1 00 30 80 00       	mov    0x803000,%eax
  8000d7:	8a 00                	mov    (%eax),%al
  8000d9:	3a 45 f7             	cmp    -0x9(%ebp),%al
  8000dc:	74 14                	je     8000f2 <_main+0xba>
  8000de:	83 ec 04             	sub    $0x4,%esp
  8000e1:	68 11 1e 80 00       	push   $0x801e11
  8000e6:	6a 3a                	push   $0x3a
  8000e8:	68 d4 1d 80 00       	push   $0x801dd4
  8000ed:	e8 9e 02 00 00       	call   800390 <_panic>
		if (garbage5 != *__ptr2__) panic("test failed!");
  8000f2:	a1 04 30 80 00       	mov    0x803004,%eax
  8000f7:	8a 00                	mov    (%eax),%al
  8000f9:	3a 45 f6             	cmp    -0xa(%ebp),%al
  8000fc:	74 14                	je     800112 <_main+0xda>
  8000fe:	83 ec 04             	sub    $0x4,%esp
  800101:	68 11 1e 80 00       	push   $0x801e11
  800106:	6a 3b                	push   $0x3b
  800108:	68 d4 1d 80 00       	push   $0x801dd4
  80010d:	e8 7e 02 00 00       	call   800390 <_panic>
	}
	cprintf_colored(TEXT_cyan, "%~\nChecking PAGE CLOCK algorithm... \n");
  800112:	83 ec 08             	sub    $0x8,%esp
  800115:	68 20 1e 80 00       	push   $0x801e20
  80011a:	6a 03                	push   $0x3
  80011c:	e8 6a 05 00 00       	call   80068b <cprintf_colored>
  800121:	83 c4 10             	add    $0x10,%esp
	{
		found = sys_check_WS_list(expectedFinalVAs, 11, 0xeebfd000, 1);
  800124:	6a 01                	push   $0x1
  800126:	68 00 d0 bf ee       	push   $0xeebfd000
  80012b:	6a 0b                	push   $0xb
  80012d:	68 60 30 80 00       	push   $0x803060
  800132:	e8 ed 18 00 00       	call   801a24 <sys_check_WS_list>
  800137:	83 c4 10             	add    $0x10,%esp
  80013a:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (found != 1) panic("CLOCK alg. failed.. trace it by printing WS before and after page fault");
  80013d:	83 7d ec 01          	cmpl   $0x1,-0x14(%ebp)
  800141:	74 14                	je     800157 <_main+0x11f>
  800143:	83 ec 04             	sub    $0x4,%esp
  800146:	68 48 1e 80 00       	push   $0x801e48
  80014b:	6a 40                	push   $0x40
  80014d:	68 d4 1d 80 00       	push   $0x801dd4
  800152:	e8 39 02 00 00       	call   800390 <_panic>
	}
	cprintf_colored(TEXT_cyan, "%~\nChecking Number of Disk Access... \n");
  800157:	83 ec 08             	sub    $0x8,%esp
  80015a:	68 90 1e 80 00       	push   $0x801e90
  80015f:	6a 03                	push   $0x3
  800161:	e8 25 05 00 00       	call   80068b <cprintf_colored>
  800166:	83 c4 10             	add    $0x10,%esp
	{
		uint32 expectedNumOfFaults = 18;
  800169:	c7 45 e4 12 00 00 00 	movl   $0x12,-0x1c(%ebp)
		uint32 expectedNumOfWrites = 7;
  800170:	c7 45 e0 07 00 00 00 	movl   $0x7,-0x20(%ebp)
		uint32 expectedNumOfReads = 18;
  800177:	c7 45 dc 12 00 00 00 	movl   $0x12,-0x24(%ebp)

		if (myEnv->nPageIn != expectedNumOfReads || myEnv->nPageOut != expectedNumOfWrites || myEnv->pageFaultsCounter != expectedNumOfFaults)
  80017e:	a1 a0 30 80 00       	mov    0x8030a0,%eax
  800183:	8b 80 c8 05 00 00    	mov    0x5c8(%eax),%eax
  800189:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  80018c:	75 20                	jne    8001ae <_main+0x176>
  80018e:	a1 a0 30 80 00       	mov    0x8030a0,%eax
  800193:	8b 80 cc 05 00 00    	mov    0x5cc(%eax),%eax
  800199:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80019c:	75 10                	jne    8001ae <_main+0x176>
  80019e:	a1 a0 30 80 00       	mov    0x8030a0,%eax
  8001a3:	8b 80 ac 05 00 00    	mov    0x5ac(%eax),%eax
  8001a9:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8001ac:	74 14                	je     8001c2 <_main+0x18a>

			panic("CLOCK alg. failed.. unexpected number of disk access");
  8001ae:	83 ec 04             	sub    $0x4,%esp
  8001b1:	68 b8 1e 80 00       	push   $0x801eb8
  8001b6:	6a 4a                	push   $0x4a
  8001b8:	68 d4 1d 80 00       	push   $0x801dd4
  8001bd:	e8 ce 01 00 00       	call   800390 <_panic>
	}
	cprintf_colored(TEXT_light_green, "%~\nCongratulations!! test PAGE replacement [CLOCK Alg. #1] is completed successfully.\n");
  8001c2:	83 ec 08             	sub    $0x8,%esp
  8001c5:	68 f0 1e 80 00       	push   $0x801ef0
  8001ca:	6a 0a                	push   $0xa
  8001cc:	e8 ba 04 00 00       	call   80068b <cprintf_colored>
  8001d1:	83 c4 10             	add    $0x10,%esp
	return;
  8001d4:	90                   	nop
}
  8001d5:	c9                   	leave  
  8001d6:	c3                   	ret    

008001d7 <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  8001d7:	55                   	push   %ebp
  8001d8:	89 e5                	mov    %esp,%ebp
  8001da:	57                   	push   %edi
  8001db:	56                   	push   %esi
  8001dc:	53                   	push   %ebx
  8001dd:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  8001e0:	e8 46 16 00 00       	call   80182b <sys_getenvindex>
  8001e5:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  8001e8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8001eb:	89 d0                	mov    %edx,%eax
  8001ed:	c1 e0 02             	shl    $0x2,%eax
  8001f0:	01 d0                	add    %edx,%eax
  8001f2:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8001f9:	01 d0                	add    %edx,%eax
  8001fb:	89 c2                	mov    %eax,%edx
  8001fd:	c1 e2 04             	shl    $0x4,%edx
  800200:	29 c2                	sub    %eax,%edx
  800202:	8d 04 95 00 00 00 00 	lea    0x0(,%edx,4),%eax
  800209:	89 c2                	mov    %eax,%edx
  80020b:	8d 82 00 00 c0 ee    	lea    -0x11400000(%edx),%eax
  800211:	a3 a0 30 80 00       	mov    %eax,0x8030a0

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800216:	a1 a0 30 80 00       	mov    0x8030a0,%eax
  80021b:	8a 40 20             	mov    0x20(%eax),%al
  80021e:	84 c0                	test   %al,%al
  800220:	74 0d                	je     80022f <libmain+0x58>
		binaryname = myEnv->prog_name;
  800222:	a1 a0 30 80 00       	mov    0x8030a0,%eax
  800227:	83 c0 20             	add    $0x20,%eax
  80022a:	a3 90 30 80 00       	mov    %eax,0x803090

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80022f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800233:	7e 0a                	jle    80023f <libmain+0x68>
		binaryname = argv[0];
  800235:	8b 45 0c             	mov    0xc(%ebp),%eax
  800238:	8b 00                	mov    (%eax),%eax
  80023a:	a3 90 30 80 00       	mov    %eax,0x803090

	// call user main routine
	_main(argc, argv);
  80023f:	83 ec 08             	sub    $0x8,%esp
  800242:	ff 75 0c             	pushl  0xc(%ebp)
  800245:	ff 75 08             	pushl  0x8(%ebp)
  800248:	e8 eb fd ff ff       	call   800038 <_main>
  80024d:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  800250:	a1 8c 30 80 00       	mov    0x80308c,%eax
  800255:	85 c0                	test   %eax,%eax
  800257:	0f 84 01 01 00 00    	je     80035e <libmain+0x187>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  80025d:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  800263:	bb 40 20 80 00       	mov    $0x802040,%ebx
  800268:	ba 0e 00 00 00       	mov    $0xe,%edx
  80026d:	89 c7                	mov    %eax,%edi
  80026f:	89 de                	mov    %ebx,%esi
  800271:	89 d1                	mov    %edx,%ecx
  800273:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  800275:	8d 55 8a             	lea    -0x76(%ebp),%edx
  800278:	b9 56 00 00 00       	mov    $0x56,%ecx
  80027d:	b0 00                	mov    $0x0,%al
  80027f:	89 d7                	mov    %edx,%edi
  800281:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  800283:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  80028a:	8d 45 e0             	lea    -0x20(%ebp),%eax
  80028d:	83 ec 08             	sub    $0x8,%esp
  800290:	50                   	push   %eax
  800291:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  800297:	50                   	push   %eax
  800298:	e8 c4 17 00 00       	call   801a61 <sys_utilities>
  80029d:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  8002a0:	e8 0d 13 00 00       	call   8015b2 <sys_lock_cons>
		{
			cprintf("**************************************\n");
  8002a5:	83 ec 0c             	sub    $0xc,%esp
  8002a8:	68 60 1f 80 00       	push   $0x801f60
  8002ad:	e8 ac 03 00 00       	call   80065e <cprintf>
  8002b2:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  8002b5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8002b8:	85 c0                	test   %eax,%eax
  8002ba:	74 18                	je     8002d4 <libmain+0xfd>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  8002bc:	e8 be 17 00 00       	call   801a7f <sys_get_optimal_num_faults>
  8002c1:	83 ec 08             	sub    $0x8,%esp
  8002c4:	50                   	push   %eax
  8002c5:	68 88 1f 80 00       	push   $0x801f88
  8002ca:	e8 8f 03 00 00       	call   80065e <cprintf>
  8002cf:	83 c4 10             	add    $0x10,%esp
  8002d2:	eb 59                	jmp    80032d <libmain+0x156>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8002d4:	a1 a0 30 80 00       	mov    0x8030a0,%eax
  8002d9:	8b 90 bc 05 00 00    	mov    0x5bc(%eax),%edx
  8002df:	a1 a0 30 80 00       	mov    0x8030a0,%eax
  8002e4:	8b 80 ac 05 00 00    	mov    0x5ac(%eax),%eax
  8002ea:	83 ec 04             	sub    $0x4,%esp
  8002ed:	52                   	push   %edx
  8002ee:	50                   	push   %eax
  8002ef:	68 ac 1f 80 00       	push   $0x801fac
  8002f4:	e8 65 03 00 00       	call   80065e <cprintf>
  8002f9:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8002fc:	a1 a0 30 80 00       	mov    0x8030a0,%eax
  800301:	8b 88 d0 05 00 00    	mov    0x5d0(%eax),%ecx
  800307:	a1 a0 30 80 00       	mov    0x8030a0,%eax
  80030c:	8b 90 cc 05 00 00    	mov    0x5cc(%eax),%edx
  800312:	a1 a0 30 80 00       	mov    0x8030a0,%eax
  800317:	8b 80 c8 05 00 00    	mov    0x5c8(%eax),%eax
  80031d:	51                   	push   %ecx
  80031e:	52                   	push   %edx
  80031f:	50                   	push   %eax
  800320:	68 d4 1f 80 00       	push   $0x801fd4
  800325:	e8 34 03 00 00       	call   80065e <cprintf>
  80032a:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80032d:	a1 a0 30 80 00       	mov    0x8030a0,%eax
  800332:	8b 80 d4 05 00 00    	mov    0x5d4(%eax),%eax
  800338:	83 ec 08             	sub    $0x8,%esp
  80033b:	50                   	push   %eax
  80033c:	68 2c 20 80 00       	push   $0x80202c
  800341:	e8 18 03 00 00       	call   80065e <cprintf>
  800346:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  800349:	83 ec 0c             	sub    $0xc,%esp
  80034c:	68 60 1f 80 00       	push   $0x801f60
  800351:	e8 08 03 00 00       	call   80065e <cprintf>
  800356:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  800359:	e8 6e 12 00 00       	call   8015cc <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  80035e:	e8 1f 00 00 00       	call   800382 <exit>
}
  800363:	90                   	nop
  800364:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800367:	5b                   	pop    %ebx
  800368:	5e                   	pop    %esi
  800369:	5f                   	pop    %edi
  80036a:	5d                   	pop    %ebp
  80036b:	c3                   	ret    

0080036c <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  80036c:	55                   	push   %ebp
  80036d:	89 e5                	mov    %esp,%ebp
  80036f:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800372:	83 ec 0c             	sub    $0xc,%esp
  800375:	6a 00                	push   $0x0
  800377:	e8 7b 14 00 00       	call   8017f7 <sys_destroy_env>
  80037c:	83 c4 10             	add    $0x10,%esp
}
  80037f:	90                   	nop
  800380:	c9                   	leave  
  800381:	c3                   	ret    

00800382 <exit>:

void
exit(void)
{
  800382:	55                   	push   %ebp
  800383:	89 e5                	mov    %esp,%ebp
  800385:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800388:	e8 d0 14 00 00       	call   80185d <sys_exit_env>
}
  80038d:	90                   	nop
  80038e:	c9                   	leave  
  80038f:	c3                   	ret    

00800390 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800390:	55                   	push   %ebp
  800391:	89 e5                	mov    %esp,%ebp
  800393:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800396:	8d 45 10             	lea    0x10(%ebp),%eax
  800399:	83 c0 04             	add    $0x4,%eax
  80039c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  80039f:	a1 b8 71 82 00       	mov    0x8271b8,%eax
  8003a4:	85 c0                	test   %eax,%eax
  8003a6:	74 16                	je     8003be <_panic+0x2e>
		cprintf("%s: ", argv0);
  8003a8:	a1 b8 71 82 00       	mov    0x8271b8,%eax
  8003ad:	83 ec 08             	sub    $0x8,%esp
  8003b0:	50                   	push   %eax
  8003b1:	68 a4 20 80 00       	push   $0x8020a4
  8003b6:	e8 a3 02 00 00       	call   80065e <cprintf>
  8003bb:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  8003be:	a1 90 30 80 00       	mov    0x803090,%eax
  8003c3:	83 ec 0c             	sub    $0xc,%esp
  8003c6:	ff 75 0c             	pushl  0xc(%ebp)
  8003c9:	ff 75 08             	pushl  0x8(%ebp)
  8003cc:	50                   	push   %eax
  8003cd:	68 ac 20 80 00       	push   $0x8020ac
  8003d2:	6a 74                	push   $0x74
  8003d4:	e8 b2 02 00 00       	call   80068b <cprintf_colored>
  8003d9:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  8003dc:	8b 45 10             	mov    0x10(%ebp),%eax
  8003df:	83 ec 08             	sub    $0x8,%esp
  8003e2:	ff 75 f4             	pushl  -0xc(%ebp)
  8003e5:	50                   	push   %eax
  8003e6:	e8 04 02 00 00       	call   8005ef <vcprintf>
  8003eb:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8003ee:	83 ec 08             	sub    $0x8,%esp
  8003f1:	6a 00                	push   $0x0
  8003f3:	68 d4 20 80 00       	push   $0x8020d4
  8003f8:	e8 f2 01 00 00       	call   8005ef <vcprintf>
  8003fd:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800400:	e8 7d ff ff ff       	call   800382 <exit>

	// should not return here
	while (1) ;
  800405:	eb fe                	jmp    800405 <_panic+0x75>

00800407 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800407:	55                   	push   %ebp
  800408:	89 e5                	mov    %esp,%ebp
  80040a:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  80040d:	a1 a0 30 80 00       	mov    0x8030a0,%eax
  800412:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800418:	8b 45 0c             	mov    0xc(%ebp),%eax
  80041b:	39 c2                	cmp    %eax,%edx
  80041d:	74 14                	je     800433 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  80041f:	83 ec 04             	sub    $0x4,%esp
  800422:	68 d8 20 80 00       	push   $0x8020d8
  800427:	6a 26                	push   $0x26
  800429:	68 24 21 80 00       	push   $0x802124
  80042e:	e8 5d ff ff ff       	call   800390 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800433:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  80043a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800441:	e9 c5 00 00 00       	jmp    80050b <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  800446:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800449:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800450:	8b 45 08             	mov    0x8(%ebp),%eax
  800453:	01 d0                	add    %edx,%eax
  800455:	8b 00                	mov    (%eax),%eax
  800457:	85 c0                	test   %eax,%eax
  800459:	75 08                	jne    800463 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  80045b:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  80045e:	e9 a5 00 00 00       	jmp    800508 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  800463:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80046a:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800471:	eb 69                	jmp    8004dc <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800473:	a1 a0 30 80 00       	mov    0x8030a0,%eax
  800478:	8b 88 a4 05 00 00    	mov    0x5a4(%eax),%ecx
  80047e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800481:	89 d0                	mov    %edx,%eax
  800483:	01 c0                	add    %eax,%eax
  800485:	01 d0                	add    %edx,%eax
  800487:	c1 e0 03             	shl    $0x3,%eax
  80048a:	01 c8                	add    %ecx,%eax
  80048c:	8a 40 04             	mov    0x4(%eax),%al
  80048f:	84 c0                	test   %al,%al
  800491:	75 46                	jne    8004d9 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800493:	a1 a0 30 80 00       	mov    0x8030a0,%eax
  800498:	8b 88 a4 05 00 00    	mov    0x5a4(%eax),%ecx
  80049e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8004a1:	89 d0                	mov    %edx,%eax
  8004a3:	01 c0                	add    %eax,%eax
  8004a5:	01 d0                	add    %edx,%eax
  8004a7:	c1 e0 03             	shl    $0x3,%eax
  8004aa:	01 c8                	add    %ecx,%eax
  8004ac:	8b 00                	mov    (%eax),%eax
  8004ae:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8004b1:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8004b4:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8004b9:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8004bb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8004be:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8004c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8004c8:	01 c8                	add    %ecx,%eax
  8004ca:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8004cc:	39 c2                	cmp    %eax,%edx
  8004ce:	75 09                	jne    8004d9 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  8004d0:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8004d7:	eb 15                	jmp    8004ee <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8004d9:	ff 45 e8             	incl   -0x18(%ebp)
  8004dc:	a1 a0 30 80 00       	mov    0x8030a0,%eax
  8004e1:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8004e7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8004ea:	39 c2                	cmp    %eax,%edx
  8004ec:	77 85                	ja     800473 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8004ee:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8004f2:	75 14                	jne    800508 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  8004f4:	83 ec 04             	sub    $0x4,%esp
  8004f7:	68 30 21 80 00       	push   $0x802130
  8004fc:	6a 3a                	push   $0x3a
  8004fe:	68 24 21 80 00       	push   $0x802124
  800503:	e8 88 fe ff ff       	call   800390 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800508:	ff 45 f0             	incl   -0x10(%ebp)
  80050b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80050e:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800511:	0f 8c 2f ff ff ff    	jl     800446 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800517:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80051e:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800525:	eb 26                	jmp    80054d <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800527:	a1 a0 30 80 00       	mov    0x8030a0,%eax
  80052c:	8b 88 a4 05 00 00    	mov    0x5a4(%eax),%ecx
  800532:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800535:	89 d0                	mov    %edx,%eax
  800537:	01 c0                	add    %eax,%eax
  800539:	01 d0                	add    %edx,%eax
  80053b:	c1 e0 03             	shl    $0x3,%eax
  80053e:	01 c8                	add    %ecx,%eax
  800540:	8a 40 04             	mov    0x4(%eax),%al
  800543:	3c 01                	cmp    $0x1,%al
  800545:	75 03                	jne    80054a <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  800547:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80054a:	ff 45 e0             	incl   -0x20(%ebp)
  80054d:	a1 a0 30 80 00       	mov    0x8030a0,%eax
  800552:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800558:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80055b:	39 c2                	cmp    %eax,%edx
  80055d:	77 c8                	ja     800527 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  80055f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800562:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800565:	74 14                	je     80057b <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  800567:	83 ec 04             	sub    $0x4,%esp
  80056a:	68 84 21 80 00       	push   $0x802184
  80056f:	6a 44                	push   $0x44
  800571:	68 24 21 80 00       	push   $0x802124
  800576:	e8 15 fe ff ff       	call   800390 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  80057b:	90                   	nop
  80057c:	c9                   	leave  
  80057d:	c3                   	ret    

0080057e <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  80057e:	55                   	push   %ebp
  80057f:	89 e5                	mov    %esp,%ebp
  800581:	53                   	push   %ebx
  800582:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  800585:	8b 45 0c             	mov    0xc(%ebp),%eax
  800588:	8b 00                	mov    (%eax),%eax
  80058a:	8d 48 01             	lea    0x1(%eax),%ecx
  80058d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800590:	89 0a                	mov    %ecx,(%edx)
  800592:	8b 55 08             	mov    0x8(%ebp),%edx
  800595:	88 d1                	mov    %dl,%cl
  800597:	8b 55 0c             	mov    0xc(%ebp),%edx
  80059a:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  80059e:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005a1:	8b 00                	mov    (%eax),%eax
  8005a3:	3d ff 00 00 00       	cmp    $0xff,%eax
  8005a8:	75 30                	jne    8005da <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  8005aa:	8b 15 bc 71 82 00    	mov    0x8271bc,%edx
  8005b0:	a0 c4 30 80 00       	mov    0x8030c4,%al
  8005b5:	0f b6 c0             	movzbl %al,%eax
  8005b8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8005bb:	8b 09                	mov    (%ecx),%ecx
  8005bd:	89 cb                	mov    %ecx,%ebx
  8005bf:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8005c2:	83 c1 08             	add    $0x8,%ecx
  8005c5:	52                   	push   %edx
  8005c6:	50                   	push   %eax
  8005c7:	53                   	push   %ebx
  8005c8:	51                   	push   %ecx
  8005c9:	e8 a0 0f 00 00       	call   80156e <sys_cputs>
  8005ce:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8005d1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005d4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8005da:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005dd:	8b 40 04             	mov    0x4(%eax),%eax
  8005e0:	8d 50 01             	lea    0x1(%eax),%edx
  8005e3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005e6:	89 50 04             	mov    %edx,0x4(%eax)
}
  8005e9:	90                   	nop
  8005ea:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8005ed:	c9                   	leave  
  8005ee:	c3                   	ret    

008005ef <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8005ef:	55                   	push   %ebp
  8005f0:	89 e5                	mov    %esp,%ebp
  8005f2:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8005f8:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8005ff:	00 00 00 
	b.cnt = 0;
  800602:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800609:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  80060c:	ff 75 0c             	pushl  0xc(%ebp)
  80060f:	ff 75 08             	pushl  0x8(%ebp)
  800612:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800618:	50                   	push   %eax
  800619:	68 7e 05 80 00       	push   $0x80057e
  80061e:	e8 5a 02 00 00       	call   80087d <vprintfmt>
  800623:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  800626:	8b 15 bc 71 82 00    	mov    0x8271bc,%edx
  80062c:	a0 c4 30 80 00       	mov    0x8030c4,%al
  800631:	0f b6 c0             	movzbl %al,%eax
  800634:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  80063a:	52                   	push   %edx
  80063b:	50                   	push   %eax
  80063c:	51                   	push   %ecx
  80063d:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800643:	83 c0 08             	add    $0x8,%eax
  800646:	50                   	push   %eax
  800647:	e8 22 0f 00 00       	call   80156e <sys_cputs>
  80064c:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  80064f:	c6 05 c4 30 80 00 00 	movb   $0x0,0x8030c4
	return b.cnt;
  800656:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  80065c:	c9                   	leave  
  80065d:	c3                   	ret    

0080065e <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  80065e:	55                   	push   %ebp
  80065f:	89 e5                	mov    %esp,%ebp
  800661:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800664:	c6 05 c4 30 80 00 01 	movb   $0x1,0x8030c4
	va_start(ap, fmt);
  80066b:	8d 45 0c             	lea    0xc(%ebp),%eax
  80066e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800671:	8b 45 08             	mov    0x8(%ebp),%eax
  800674:	83 ec 08             	sub    $0x8,%esp
  800677:	ff 75 f4             	pushl  -0xc(%ebp)
  80067a:	50                   	push   %eax
  80067b:	e8 6f ff ff ff       	call   8005ef <vcprintf>
  800680:	83 c4 10             	add    $0x10,%esp
  800683:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800686:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800689:	c9                   	leave  
  80068a:	c3                   	ret    

0080068b <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  80068b:	55                   	push   %ebp
  80068c:	89 e5                	mov    %esp,%ebp
  80068e:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800691:	c6 05 c4 30 80 00 01 	movb   $0x1,0x8030c4
	curTextClr = (textClr << 8) ; //set text color by the given value
  800698:	8b 45 08             	mov    0x8(%ebp),%eax
  80069b:	c1 e0 08             	shl    $0x8,%eax
  80069e:	a3 bc 71 82 00       	mov    %eax,0x8271bc
	va_start(ap, fmt);
  8006a3:	8d 45 0c             	lea    0xc(%ebp),%eax
  8006a6:	83 c0 04             	add    $0x4,%eax
  8006a9:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8006ac:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006af:	83 ec 08             	sub    $0x8,%esp
  8006b2:	ff 75 f4             	pushl  -0xc(%ebp)
  8006b5:	50                   	push   %eax
  8006b6:	e8 34 ff ff ff       	call   8005ef <vcprintf>
  8006bb:	83 c4 10             	add    $0x10,%esp
  8006be:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  8006c1:	c7 05 bc 71 82 00 00 	movl   $0x700,0x8271bc
  8006c8:	07 00 00 

	return cnt;
  8006cb:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8006ce:	c9                   	leave  
  8006cf:	c3                   	ret    

008006d0 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  8006d0:	55                   	push   %ebp
  8006d1:	89 e5                	mov    %esp,%ebp
  8006d3:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  8006d6:	e8 d7 0e 00 00       	call   8015b2 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  8006db:	8d 45 0c             	lea    0xc(%ebp),%eax
  8006de:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  8006e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8006e4:	83 ec 08             	sub    $0x8,%esp
  8006e7:	ff 75 f4             	pushl  -0xc(%ebp)
  8006ea:	50                   	push   %eax
  8006eb:	e8 ff fe ff ff       	call   8005ef <vcprintf>
  8006f0:	83 c4 10             	add    $0x10,%esp
  8006f3:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  8006f6:	e8 d1 0e 00 00       	call   8015cc <sys_unlock_cons>
	return cnt;
  8006fb:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8006fe:	c9                   	leave  
  8006ff:	c3                   	ret    

00800700 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800700:	55                   	push   %ebp
  800701:	89 e5                	mov    %esp,%ebp
  800703:	53                   	push   %ebx
  800704:	83 ec 14             	sub    $0x14,%esp
  800707:	8b 45 10             	mov    0x10(%ebp),%eax
  80070a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80070d:	8b 45 14             	mov    0x14(%ebp),%eax
  800710:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800713:	8b 45 18             	mov    0x18(%ebp),%eax
  800716:	ba 00 00 00 00       	mov    $0x0,%edx
  80071b:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80071e:	77 55                	ja     800775 <printnum+0x75>
  800720:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800723:	72 05                	jb     80072a <printnum+0x2a>
  800725:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800728:	77 4b                	ja     800775 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80072a:	8b 45 1c             	mov    0x1c(%ebp),%eax
  80072d:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800730:	8b 45 18             	mov    0x18(%ebp),%eax
  800733:	ba 00 00 00 00       	mov    $0x0,%edx
  800738:	52                   	push   %edx
  800739:	50                   	push   %eax
  80073a:	ff 75 f4             	pushl  -0xc(%ebp)
  80073d:	ff 75 f0             	pushl  -0x10(%ebp)
  800740:	e8 ab 13 00 00       	call   801af0 <__udivdi3>
  800745:	83 c4 10             	add    $0x10,%esp
  800748:	83 ec 04             	sub    $0x4,%esp
  80074b:	ff 75 20             	pushl  0x20(%ebp)
  80074e:	53                   	push   %ebx
  80074f:	ff 75 18             	pushl  0x18(%ebp)
  800752:	52                   	push   %edx
  800753:	50                   	push   %eax
  800754:	ff 75 0c             	pushl  0xc(%ebp)
  800757:	ff 75 08             	pushl  0x8(%ebp)
  80075a:	e8 a1 ff ff ff       	call   800700 <printnum>
  80075f:	83 c4 20             	add    $0x20,%esp
  800762:	eb 1a                	jmp    80077e <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800764:	83 ec 08             	sub    $0x8,%esp
  800767:	ff 75 0c             	pushl  0xc(%ebp)
  80076a:	ff 75 20             	pushl  0x20(%ebp)
  80076d:	8b 45 08             	mov    0x8(%ebp),%eax
  800770:	ff d0                	call   *%eax
  800772:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800775:	ff 4d 1c             	decl   0x1c(%ebp)
  800778:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  80077c:	7f e6                	jg     800764 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80077e:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800781:	bb 00 00 00 00       	mov    $0x0,%ebx
  800786:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800789:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80078c:	53                   	push   %ebx
  80078d:	51                   	push   %ecx
  80078e:	52                   	push   %edx
  80078f:	50                   	push   %eax
  800790:	e8 6b 14 00 00       	call   801c00 <__umoddi3>
  800795:	83 c4 10             	add    $0x10,%esp
  800798:	05 f4 23 80 00       	add    $0x8023f4,%eax
  80079d:	8a 00                	mov    (%eax),%al
  80079f:	0f be c0             	movsbl %al,%eax
  8007a2:	83 ec 08             	sub    $0x8,%esp
  8007a5:	ff 75 0c             	pushl  0xc(%ebp)
  8007a8:	50                   	push   %eax
  8007a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8007ac:	ff d0                	call   *%eax
  8007ae:	83 c4 10             	add    $0x10,%esp
}
  8007b1:	90                   	nop
  8007b2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8007b5:	c9                   	leave  
  8007b6:	c3                   	ret    

008007b7 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8007b7:	55                   	push   %ebp
  8007b8:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8007ba:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8007be:	7e 1c                	jle    8007dc <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8007c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8007c3:	8b 00                	mov    (%eax),%eax
  8007c5:	8d 50 08             	lea    0x8(%eax),%edx
  8007c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8007cb:	89 10                	mov    %edx,(%eax)
  8007cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8007d0:	8b 00                	mov    (%eax),%eax
  8007d2:	83 e8 08             	sub    $0x8,%eax
  8007d5:	8b 50 04             	mov    0x4(%eax),%edx
  8007d8:	8b 00                	mov    (%eax),%eax
  8007da:	eb 40                	jmp    80081c <getuint+0x65>
	else if (lflag)
  8007dc:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8007e0:	74 1e                	je     800800 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8007e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8007e5:	8b 00                	mov    (%eax),%eax
  8007e7:	8d 50 04             	lea    0x4(%eax),%edx
  8007ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8007ed:	89 10                	mov    %edx,(%eax)
  8007ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8007f2:	8b 00                	mov    (%eax),%eax
  8007f4:	83 e8 04             	sub    $0x4,%eax
  8007f7:	8b 00                	mov    (%eax),%eax
  8007f9:	ba 00 00 00 00       	mov    $0x0,%edx
  8007fe:	eb 1c                	jmp    80081c <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800800:	8b 45 08             	mov    0x8(%ebp),%eax
  800803:	8b 00                	mov    (%eax),%eax
  800805:	8d 50 04             	lea    0x4(%eax),%edx
  800808:	8b 45 08             	mov    0x8(%ebp),%eax
  80080b:	89 10                	mov    %edx,(%eax)
  80080d:	8b 45 08             	mov    0x8(%ebp),%eax
  800810:	8b 00                	mov    (%eax),%eax
  800812:	83 e8 04             	sub    $0x4,%eax
  800815:	8b 00                	mov    (%eax),%eax
  800817:	ba 00 00 00 00       	mov    $0x0,%edx
}
  80081c:	5d                   	pop    %ebp
  80081d:	c3                   	ret    

0080081e <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  80081e:	55                   	push   %ebp
  80081f:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800821:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800825:	7e 1c                	jle    800843 <getint+0x25>
		return va_arg(*ap, long long);
  800827:	8b 45 08             	mov    0x8(%ebp),%eax
  80082a:	8b 00                	mov    (%eax),%eax
  80082c:	8d 50 08             	lea    0x8(%eax),%edx
  80082f:	8b 45 08             	mov    0x8(%ebp),%eax
  800832:	89 10                	mov    %edx,(%eax)
  800834:	8b 45 08             	mov    0x8(%ebp),%eax
  800837:	8b 00                	mov    (%eax),%eax
  800839:	83 e8 08             	sub    $0x8,%eax
  80083c:	8b 50 04             	mov    0x4(%eax),%edx
  80083f:	8b 00                	mov    (%eax),%eax
  800841:	eb 38                	jmp    80087b <getint+0x5d>
	else if (lflag)
  800843:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800847:	74 1a                	je     800863 <getint+0x45>
		return va_arg(*ap, long);
  800849:	8b 45 08             	mov    0x8(%ebp),%eax
  80084c:	8b 00                	mov    (%eax),%eax
  80084e:	8d 50 04             	lea    0x4(%eax),%edx
  800851:	8b 45 08             	mov    0x8(%ebp),%eax
  800854:	89 10                	mov    %edx,(%eax)
  800856:	8b 45 08             	mov    0x8(%ebp),%eax
  800859:	8b 00                	mov    (%eax),%eax
  80085b:	83 e8 04             	sub    $0x4,%eax
  80085e:	8b 00                	mov    (%eax),%eax
  800860:	99                   	cltd   
  800861:	eb 18                	jmp    80087b <getint+0x5d>
	else
		return va_arg(*ap, int);
  800863:	8b 45 08             	mov    0x8(%ebp),%eax
  800866:	8b 00                	mov    (%eax),%eax
  800868:	8d 50 04             	lea    0x4(%eax),%edx
  80086b:	8b 45 08             	mov    0x8(%ebp),%eax
  80086e:	89 10                	mov    %edx,(%eax)
  800870:	8b 45 08             	mov    0x8(%ebp),%eax
  800873:	8b 00                	mov    (%eax),%eax
  800875:	83 e8 04             	sub    $0x4,%eax
  800878:	8b 00                	mov    (%eax),%eax
  80087a:	99                   	cltd   
}
  80087b:	5d                   	pop    %ebp
  80087c:	c3                   	ret    

0080087d <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80087d:	55                   	push   %ebp
  80087e:	89 e5                	mov    %esp,%ebp
  800880:	56                   	push   %esi
  800881:	53                   	push   %ebx
  800882:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800885:	eb 17                	jmp    80089e <vprintfmt+0x21>
			if (ch == '\0')
  800887:	85 db                	test   %ebx,%ebx
  800889:	0f 84 c1 03 00 00    	je     800c50 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  80088f:	83 ec 08             	sub    $0x8,%esp
  800892:	ff 75 0c             	pushl  0xc(%ebp)
  800895:	53                   	push   %ebx
  800896:	8b 45 08             	mov    0x8(%ebp),%eax
  800899:	ff d0                	call   *%eax
  80089b:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80089e:	8b 45 10             	mov    0x10(%ebp),%eax
  8008a1:	8d 50 01             	lea    0x1(%eax),%edx
  8008a4:	89 55 10             	mov    %edx,0x10(%ebp)
  8008a7:	8a 00                	mov    (%eax),%al
  8008a9:	0f b6 d8             	movzbl %al,%ebx
  8008ac:	83 fb 25             	cmp    $0x25,%ebx
  8008af:	75 d6                	jne    800887 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8008b1:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  8008b5:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  8008bc:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8008c3:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8008ca:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8008d1:	8b 45 10             	mov    0x10(%ebp),%eax
  8008d4:	8d 50 01             	lea    0x1(%eax),%edx
  8008d7:	89 55 10             	mov    %edx,0x10(%ebp)
  8008da:	8a 00                	mov    (%eax),%al
  8008dc:	0f b6 d8             	movzbl %al,%ebx
  8008df:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8008e2:	83 f8 5b             	cmp    $0x5b,%eax
  8008e5:	0f 87 3d 03 00 00    	ja     800c28 <vprintfmt+0x3ab>
  8008eb:	8b 04 85 18 24 80 00 	mov    0x802418(,%eax,4),%eax
  8008f2:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8008f4:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8008f8:	eb d7                	jmp    8008d1 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8008fa:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8008fe:	eb d1                	jmp    8008d1 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800900:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800907:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80090a:	89 d0                	mov    %edx,%eax
  80090c:	c1 e0 02             	shl    $0x2,%eax
  80090f:	01 d0                	add    %edx,%eax
  800911:	01 c0                	add    %eax,%eax
  800913:	01 d8                	add    %ebx,%eax
  800915:	83 e8 30             	sub    $0x30,%eax
  800918:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  80091b:	8b 45 10             	mov    0x10(%ebp),%eax
  80091e:	8a 00                	mov    (%eax),%al
  800920:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800923:	83 fb 2f             	cmp    $0x2f,%ebx
  800926:	7e 3e                	jle    800966 <vprintfmt+0xe9>
  800928:	83 fb 39             	cmp    $0x39,%ebx
  80092b:	7f 39                	jg     800966 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80092d:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800930:	eb d5                	jmp    800907 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800932:	8b 45 14             	mov    0x14(%ebp),%eax
  800935:	83 c0 04             	add    $0x4,%eax
  800938:	89 45 14             	mov    %eax,0x14(%ebp)
  80093b:	8b 45 14             	mov    0x14(%ebp),%eax
  80093e:	83 e8 04             	sub    $0x4,%eax
  800941:	8b 00                	mov    (%eax),%eax
  800943:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800946:	eb 1f                	jmp    800967 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800948:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80094c:	79 83                	jns    8008d1 <vprintfmt+0x54>
				width = 0;
  80094e:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800955:	e9 77 ff ff ff       	jmp    8008d1 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  80095a:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800961:	e9 6b ff ff ff       	jmp    8008d1 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800966:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800967:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80096b:	0f 89 60 ff ff ff    	jns    8008d1 <vprintfmt+0x54>
				width = precision, precision = -1;
  800971:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800974:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800977:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  80097e:	e9 4e ff ff ff       	jmp    8008d1 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800983:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800986:	e9 46 ff ff ff       	jmp    8008d1 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  80098b:	8b 45 14             	mov    0x14(%ebp),%eax
  80098e:	83 c0 04             	add    $0x4,%eax
  800991:	89 45 14             	mov    %eax,0x14(%ebp)
  800994:	8b 45 14             	mov    0x14(%ebp),%eax
  800997:	83 e8 04             	sub    $0x4,%eax
  80099a:	8b 00                	mov    (%eax),%eax
  80099c:	83 ec 08             	sub    $0x8,%esp
  80099f:	ff 75 0c             	pushl  0xc(%ebp)
  8009a2:	50                   	push   %eax
  8009a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8009a6:	ff d0                	call   *%eax
  8009a8:	83 c4 10             	add    $0x10,%esp
			break;
  8009ab:	e9 9b 02 00 00       	jmp    800c4b <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8009b0:	8b 45 14             	mov    0x14(%ebp),%eax
  8009b3:	83 c0 04             	add    $0x4,%eax
  8009b6:	89 45 14             	mov    %eax,0x14(%ebp)
  8009b9:	8b 45 14             	mov    0x14(%ebp),%eax
  8009bc:	83 e8 04             	sub    $0x4,%eax
  8009bf:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  8009c1:	85 db                	test   %ebx,%ebx
  8009c3:	79 02                	jns    8009c7 <vprintfmt+0x14a>
				err = -err;
  8009c5:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  8009c7:	83 fb 64             	cmp    $0x64,%ebx
  8009ca:	7f 0b                	jg     8009d7 <vprintfmt+0x15a>
  8009cc:	8b 34 9d 60 22 80 00 	mov    0x802260(,%ebx,4),%esi
  8009d3:	85 f6                	test   %esi,%esi
  8009d5:	75 19                	jne    8009f0 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8009d7:	53                   	push   %ebx
  8009d8:	68 05 24 80 00       	push   $0x802405
  8009dd:	ff 75 0c             	pushl  0xc(%ebp)
  8009e0:	ff 75 08             	pushl  0x8(%ebp)
  8009e3:	e8 70 02 00 00       	call   800c58 <printfmt>
  8009e8:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8009eb:	e9 5b 02 00 00       	jmp    800c4b <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8009f0:	56                   	push   %esi
  8009f1:	68 0e 24 80 00       	push   $0x80240e
  8009f6:	ff 75 0c             	pushl  0xc(%ebp)
  8009f9:	ff 75 08             	pushl  0x8(%ebp)
  8009fc:	e8 57 02 00 00       	call   800c58 <printfmt>
  800a01:	83 c4 10             	add    $0x10,%esp
			break;
  800a04:	e9 42 02 00 00       	jmp    800c4b <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800a09:	8b 45 14             	mov    0x14(%ebp),%eax
  800a0c:	83 c0 04             	add    $0x4,%eax
  800a0f:	89 45 14             	mov    %eax,0x14(%ebp)
  800a12:	8b 45 14             	mov    0x14(%ebp),%eax
  800a15:	83 e8 04             	sub    $0x4,%eax
  800a18:	8b 30                	mov    (%eax),%esi
  800a1a:	85 f6                	test   %esi,%esi
  800a1c:	75 05                	jne    800a23 <vprintfmt+0x1a6>
				p = "(null)";
  800a1e:	be 11 24 80 00       	mov    $0x802411,%esi
			if (width > 0 && padc != '-')
  800a23:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a27:	7e 6d                	jle    800a96 <vprintfmt+0x219>
  800a29:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800a2d:	74 67                	je     800a96 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800a2f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800a32:	83 ec 08             	sub    $0x8,%esp
  800a35:	50                   	push   %eax
  800a36:	56                   	push   %esi
  800a37:	e8 1e 03 00 00       	call   800d5a <strnlen>
  800a3c:	83 c4 10             	add    $0x10,%esp
  800a3f:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800a42:	eb 16                	jmp    800a5a <vprintfmt+0x1dd>
					putch(padc, putdat);
  800a44:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800a48:	83 ec 08             	sub    $0x8,%esp
  800a4b:	ff 75 0c             	pushl  0xc(%ebp)
  800a4e:	50                   	push   %eax
  800a4f:	8b 45 08             	mov    0x8(%ebp),%eax
  800a52:	ff d0                	call   *%eax
  800a54:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800a57:	ff 4d e4             	decl   -0x1c(%ebp)
  800a5a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a5e:	7f e4                	jg     800a44 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800a60:	eb 34                	jmp    800a96 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800a62:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800a66:	74 1c                	je     800a84 <vprintfmt+0x207>
  800a68:	83 fb 1f             	cmp    $0x1f,%ebx
  800a6b:	7e 05                	jle    800a72 <vprintfmt+0x1f5>
  800a6d:	83 fb 7e             	cmp    $0x7e,%ebx
  800a70:	7e 12                	jle    800a84 <vprintfmt+0x207>
					putch('?', putdat);
  800a72:	83 ec 08             	sub    $0x8,%esp
  800a75:	ff 75 0c             	pushl  0xc(%ebp)
  800a78:	6a 3f                	push   $0x3f
  800a7a:	8b 45 08             	mov    0x8(%ebp),%eax
  800a7d:	ff d0                	call   *%eax
  800a7f:	83 c4 10             	add    $0x10,%esp
  800a82:	eb 0f                	jmp    800a93 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800a84:	83 ec 08             	sub    $0x8,%esp
  800a87:	ff 75 0c             	pushl  0xc(%ebp)
  800a8a:	53                   	push   %ebx
  800a8b:	8b 45 08             	mov    0x8(%ebp),%eax
  800a8e:	ff d0                	call   *%eax
  800a90:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800a93:	ff 4d e4             	decl   -0x1c(%ebp)
  800a96:	89 f0                	mov    %esi,%eax
  800a98:	8d 70 01             	lea    0x1(%eax),%esi
  800a9b:	8a 00                	mov    (%eax),%al
  800a9d:	0f be d8             	movsbl %al,%ebx
  800aa0:	85 db                	test   %ebx,%ebx
  800aa2:	74 24                	je     800ac8 <vprintfmt+0x24b>
  800aa4:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800aa8:	78 b8                	js     800a62 <vprintfmt+0x1e5>
  800aaa:	ff 4d e0             	decl   -0x20(%ebp)
  800aad:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800ab1:	79 af                	jns    800a62 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800ab3:	eb 13                	jmp    800ac8 <vprintfmt+0x24b>
				putch(' ', putdat);
  800ab5:	83 ec 08             	sub    $0x8,%esp
  800ab8:	ff 75 0c             	pushl  0xc(%ebp)
  800abb:	6a 20                	push   $0x20
  800abd:	8b 45 08             	mov    0x8(%ebp),%eax
  800ac0:	ff d0                	call   *%eax
  800ac2:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800ac5:	ff 4d e4             	decl   -0x1c(%ebp)
  800ac8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800acc:	7f e7                	jg     800ab5 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800ace:	e9 78 01 00 00       	jmp    800c4b <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800ad3:	83 ec 08             	sub    $0x8,%esp
  800ad6:	ff 75 e8             	pushl  -0x18(%ebp)
  800ad9:	8d 45 14             	lea    0x14(%ebp),%eax
  800adc:	50                   	push   %eax
  800add:	e8 3c fd ff ff       	call   80081e <getint>
  800ae2:	83 c4 10             	add    $0x10,%esp
  800ae5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ae8:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800aeb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800aee:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800af1:	85 d2                	test   %edx,%edx
  800af3:	79 23                	jns    800b18 <vprintfmt+0x29b>
				putch('-', putdat);
  800af5:	83 ec 08             	sub    $0x8,%esp
  800af8:	ff 75 0c             	pushl  0xc(%ebp)
  800afb:	6a 2d                	push   $0x2d
  800afd:	8b 45 08             	mov    0x8(%ebp),%eax
  800b00:	ff d0                	call   *%eax
  800b02:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800b05:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b08:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b0b:	f7 d8                	neg    %eax
  800b0d:	83 d2 00             	adc    $0x0,%edx
  800b10:	f7 da                	neg    %edx
  800b12:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b15:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800b18:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800b1f:	e9 bc 00 00 00       	jmp    800be0 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800b24:	83 ec 08             	sub    $0x8,%esp
  800b27:	ff 75 e8             	pushl  -0x18(%ebp)
  800b2a:	8d 45 14             	lea    0x14(%ebp),%eax
  800b2d:	50                   	push   %eax
  800b2e:	e8 84 fc ff ff       	call   8007b7 <getuint>
  800b33:	83 c4 10             	add    $0x10,%esp
  800b36:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b39:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800b3c:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800b43:	e9 98 00 00 00       	jmp    800be0 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800b48:	83 ec 08             	sub    $0x8,%esp
  800b4b:	ff 75 0c             	pushl  0xc(%ebp)
  800b4e:	6a 58                	push   $0x58
  800b50:	8b 45 08             	mov    0x8(%ebp),%eax
  800b53:	ff d0                	call   *%eax
  800b55:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800b58:	83 ec 08             	sub    $0x8,%esp
  800b5b:	ff 75 0c             	pushl  0xc(%ebp)
  800b5e:	6a 58                	push   $0x58
  800b60:	8b 45 08             	mov    0x8(%ebp),%eax
  800b63:	ff d0                	call   *%eax
  800b65:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800b68:	83 ec 08             	sub    $0x8,%esp
  800b6b:	ff 75 0c             	pushl  0xc(%ebp)
  800b6e:	6a 58                	push   $0x58
  800b70:	8b 45 08             	mov    0x8(%ebp),%eax
  800b73:	ff d0                	call   *%eax
  800b75:	83 c4 10             	add    $0x10,%esp
			break;
  800b78:	e9 ce 00 00 00       	jmp    800c4b <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800b7d:	83 ec 08             	sub    $0x8,%esp
  800b80:	ff 75 0c             	pushl  0xc(%ebp)
  800b83:	6a 30                	push   $0x30
  800b85:	8b 45 08             	mov    0x8(%ebp),%eax
  800b88:	ff d0                	call   *%eax
  800b8a:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800b8d:	83 ec 08             	sub    $0x8,%esp
  800b90:	ff 75 0c             	pushl  0xc(%ebp)
  800b93:	6a 78                	push   $0x78
  800b95:	8b 45 08             	mov    0x8(%ebp),%eax
  800b98:	ff d0                	call   *%eax
  800b9a:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800b9d:	8b 45 14             	mov    0x14(%ebp),%eax
  800ba0:	83 c0 04             	add    $0x4,%eax
  800ba3:	89 45 14             	mov    %eax,0x14(%ebp)
  800ba6:	8b 45 14             	mov    0x14(%ebp),%eax
  800ba9:	83 e8 04             	sub    $0x4,%eax
  800bac:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800bae:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bb1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800bb8:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800bbf:	eb 1f                	jmp    800be0 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800bc1:	83 ec 08             	sub    $0x8,%esp
  800bc4:	ff 75 e8             	pushl  -0x18(%ebp)
  800bc7:	8d 45 14             	lea    0x14(%ebp),%eax
  800bca:	50                   	push   %eax
  800bcb:	e8 e7 fb ff ff       	call   8007b7 <getuint>
  800bd0:	83 c4 10             	add    $0x10,%esp
  800bd3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bd6:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800bd9:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800be0:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800be4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800be7:	83 ec 04             	sub    $0x4,%esp
  800bea:	52                   	push   %edx
  800beb:	ff 75 e4             	pushl  -0x1c(%ebp)
  800bee:	50                   	push   %eax
  800bef:	ff 75 f4             	pushl  -0xc(%ebp)
  800bf2:	ff 75 f0             	pushl  -0x10(%ebp)
  800bf5:	ff 75 0c             	pushl  0xc(%ebp)
  800bf8:	ff 75 08             	pushl  0x8(%ebp)
  800bfb:	e8 00 fb ff ff       	call   800700 <printnum>
  800c00:	83 c4 20             	add    $0x20,%esp
			break;
  800c03:	eb 46                	jmp    800c4b <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800c05:	83 ec 08             	sub    $0x8,%esp
  800c08:	ff 75 0c             	pushl  0xc(%ebp)
  800c0b:	53                   	push   %ebx
  800c0c:	8b 45 08             	mov    0x8(%ebp),%eax
  800c0f:	ff d0                	call   *%eax
  800c11:	83 c4 10             	add    $0x10,%esp
			break;
  800c14:	eb 35                	jmp    800c4b <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800c16:	c6 05 c4 30 80 00 00 	movb   $0x0,0x8030c4
			break;
  800c1d:	eb 2c                	jmp    800c4b <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800c1f:	c6 05 c4 30 80 00 01 	movb   $0x1,0x8030c4
			break;
  800c26:	eb 23                	jmp    800c4b <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800c28:	83 ec 08             	sub    $0x8,%esp
  800c2b:	ff 75 0c             	pushl  0xc(%ebp)
  800c2e:	6a 25                	push   $0x25
  800c30:	8b 45 08             	mov    0x8(%ebp),%eax
  800c33:	ff d0                	call   *%eax
  800c35:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800c38:	ff 4d 10             	decl   0x10(%ebp)
  800c3b:	eb 03                	jmp    800c40 <vprintfmt+0x3c3>
  800c3d:	ff 4d 10             	decl   0x10(%ebp)
  800c40:	8b 45 10             	mov    0x10(%ebp),%eax
  800c43:	48                   	dec    %eax
  800c44:	8a 00                	mov    (%eax),%al
  800c46:	3c 25                	cmp    $0x25,%al
  800c48:	75 f3                	jne    800c3d <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800c4a:	90                   	nop
		}
	}
  800c4b:	e9 35 fc ff ff       	jmp    800885 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800c50:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800c51:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800c54:	5b                   	pop    %ebx
  800c55:	5e                   	pop    %esi
  800c56:	5d                   	pop    %ebp
  800c57:	c3                   	ret    

00800c58 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800c58:	55                   	push   %ebp
  800c59:	89 e5                	mov    %esp,%ebp
  800c5b:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800c5e:	8d 45 10             	lea    0x10(%ebp),%eax
  800c61:	83 c0 04             	add    $0x4,%eax
  800c64:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800c67:	8b 45 10             	mov    0x10(%ebp),%eax
  800c6a:	ff 75 f4             	pushl  -0xc(%ebp)
  800c6d:	50                   	push   %eax
  800c6e:	ff 75 0c             	pushl  0xc(%ebp)
  800c71:	ff 75 08             	pushl  0x8(%ebp)
  800c74:	e8 04 fc ff ff       	call   80087d <vprintfmt>
  800c79:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800c7c:	90                   	nop
  800c7d:	c9                   	leave  
  800c7e:	c3                   	ret    

00800c7f <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800c7f:	55                   	push   %ebp
  800c80:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800c82:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c85:	8b 40 08             	mov    0x8(%eax),%eax
  800c88:	8d 50 01             	lea    0x1(%eax),%edx
  800c8b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c8e:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800c91:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c94:	8b 10                	mov    (%eax),%edx
  800c96:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c99:	8b 40 04             	mov    0x4(%eax),%eax
  800c9c:	39 c2                	cmp    %eax,%edx
  800c9e:	73 12                	jae    800cb2 <sprintputch+0x33>
		*b->buf++ = ch;
  800ca0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ca3:	8b 00                	mov    (%eax),%eax
  800ca5:	8d 48 01             	lea    0x1(%eax),%ecx
  800ca8:	8b 55 0c             	mov    0xc(%ebp),%edx
  800cab:	89 0a                	mov    %ecx,(%edx)
  800cad:	8b 55 08             	mov    0x8(%ebp),%edx
  800cb0:	88 10                	mov    %dl,(%eax)
}
  800cb2:	90                   	nop
  800cb3:	5d                   	pop    %ebp
  800cb4:	c3                   	ret    

00800cb5 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800cb5:	55                   	push   %ebp
  800cb6:	89 e5                	mov    %esp,%ebp
  800cb8:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800cbb:	8b 45 08             	mov    0x8(%ebp),%eax
  800cbe:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800cc1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cc4:	8d 50 ff             	lea    -0x1(%eax),%edx
  800cc7:	8b 45 08             	mov    0x8(%ebp),%eax
  800cca:	01 d0                	add    %edx,%eax
  800ccc:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ccf:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800cd6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800cda:	74 06                	je     800ce2 <vsnprintf+0x2d>
  800cdc:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800ce0:	7f 07                	jg     800ce9 <vsnprintf+0x34>
		return -E_INVAL;
  800ce2:	b8 03 00 00 00       	mov    $0x3,%eax
  800ce7:	eb 20                	jmp    800d09 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800ce9:	ff 75 14             	pushl  0x14(%ebp)
  800cec:	ff 75 10             	pushl  0x10(%ebp)
  800cef:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800cf2:	50                   	push   %eax
  800cf3:	68 7f 0c 80 00       	push   $0x800c7f
  800cf8:	e8 80 fb ff ff       	call   80087d <vprintfmt>
  800cfd:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800d00:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800d03:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800d06:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800d09:	c9                   	leave  
  800d0a:	c3                   	ret    

00800d0b <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800d0b:	55                   	push   %ebp
  800d0c:	89 e5                	mov    %esp,%ebp
  800d0e:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800d11:	8d 45 10             	lea    0x10(%ebp),%eax
  800d14:	83 c0 04             	add    $0x4,%eax
  800d17:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800d1a:	8b 45 10             	mov    0x10(%ebp),%eax
  800d1d:	ff 75 f4             	pushl  -0xc(%ebp)
  800d20:	50                   	push   %eax
  800d21:	ff 75 0c             	pushl  0xc(%ebp)
  800d24:	ff 75 08             	pushl  0x8(%ebp)
  800d27:	e8 89 ff ff ff       	call   800cb5 <vsnprintf>
  800d2c:	83 c4 10             	add    $0x10,%esp
  800d2f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800d32:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800d35:	c9                   	leave  
  800d36:	c3                   	ret    

00800d37 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800d37:	55                   	push   %ebp
  800d38:	89 e5                	mov    %esp,%ebp
  800d3a:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800d3d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800d44:	eb 06                	jmp    800d4c <strlen+0x15>
		n++;
  800d46:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800d49:	ff 45 08             	incl   0x8(%ebp)
  800d4c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d4f:	8a 00                	mov    (%eax),%al
  800d51:	84 c0                	test   %al,%al
  800d53:	75 f1                	jne    800d46 <strlen+0xf>
		n++;
	return n;
  800d55:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800d58:	c9                   	leave  
  800d59:	c3                   	ret    

00800d5a <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800d5a:	55                   	push   %ebp
  800d5b:	89 e5                	mov    %esp,%ebp
  800d5d:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800d60:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800d67:	eb 09                	jmp    800d72 <strnlen+0x18>
		n++;
  800d69:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800d6c:	ff 45 08             	incl   0x8(%ebp)
  800d6f:	ff 4d 0c             	decl   0xc(%ebp)
  800d72:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d76:	74 09                	je     800d81 <strnlen+0x27>
  800d78:	8b 45 08             	mov    0x8(%ebp),%eax
  800d7b:	8a 00                	mov    (%eax),%al
  800d7d:	84 c0                	test   %al,%al
  800d7f:	75 e8                	jne    800d69 <strnlen+0xf>
		n++;
	return n;
  800d81:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800d84:	c9                   	leave  
  800d85:	c3                   	ret    

00800d86 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800d86:	55                   	push   %ebp
  800d87:	89 e5                	mov    %esp,%ebp
  800d89:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800d8c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d8f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800d92:	90                   	nop
  800d93:	8b 45 08             	mov    0x8(%ebp),%eax
  800d96:	8d 50 01             	lea    0x1(%eax),%edx
  800d99:	89 55 08             	mov    %edx,0x8(%ebp)
  800d9c:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d9f:	8d 4a 01             	lea    0x1(%edx),%ecx
  800da2:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800da5:	8a 12                	mov    (%edx),%dl
  800da7:	88 10                	mov    %dl,(%eax)
  800da9:	8a 00                	mov    (%eax),%al
  800dab:	84 c0                	test   %al,%al
  800dad:	75 e4                	jne    800d93 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800daf:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800db2:	c9                   	leave  
  800db3:	c3                   	ret    

00800db4 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800db4:	55                   	push   %ebp
  800db5:	89 e5                	mov    %esp,%ebp
  800db7:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800dba:	8b 45 08             	mov    0x8(%ebp),%eax
  800dbd:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800dc0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800dc7:	eb 1f                	jmp    800de8 <strncpy+0x34>
		*dst++ = *src;
  800dc9:	8b 45 08             	mov    0x8(%ebp),%eax
  800dcc:	8d 50 01             	lea    0x1(%eax),%edx
  800dcf:	89 55 08             	mov    %edx,0x8(%ebp)
  800dd2:	8b 55 0c             	mov    0xc(%ebp),%edx
  800dd5:	8a 12                	mov    (%edx),%dl
  800dd7:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800dd9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ddc:	8a 00                	mov    (%eax),%al
  800dde:	84 c0                	test   %al,%al
  800de0:	74 03                	je     800de5 <strncpy+0x31>
			src++;
  800de2:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800de5:	ff 45 fc             	incl   -0x4(%ebp)
  800de8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800deb:	3b 45 10             	cmp    0x10(%ebp),%eax
  800dee:	72 d9                	jb     800dc9 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800df0:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800df3:	c9                   	leave  
  800df4:	c3                   	ret    

00800df5 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800df5:	55                   	push   %ebp
  800df6:	89 e5                	mov    %esp,%ebp
  800df8:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800dfb:	8b 45 08             	mov    0x8(%ebp),%eax
  800dfe:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800e01:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e05:	74 30                	je     800e37 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800e07:	eb 16                	jmp    800e1f <strlcpy+0x2a>
			*dst++ = *src++;
  800e09:	8b 45 08             	mov    0x8(%ebp),%eax
  800e0c:	8d 50 01             	lea    0x1(%eax),%edx
  800e0f:	89 55 08             	mov    %edx,0x8(%ebp)
  800e12:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e15:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e18:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800e1b:	8a 12                	mov    (%edx),%dl
  800e1d:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800e1f:	ff 4d 10             	decl   0x10(%ebp)
  800e22:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e26:	74 09                	je     800e31 <strlcpy+0x3c>
  800e28:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e2b:	8a 00                	mov    (%eax),%al
  800e2d:	84 c0                	test   %al,%al
  800e2f:	75 d8                	jne    800e09 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800e31:	8b 45 08             	mov    0x8(%ebp),%eax
  800e34:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800e37:	8b 55 08             	mov    0x8(%ebp),%edx
  800e3a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e3d:	29 c2                	sub    %eax,%edx
  800e3f:	89 d0                	mov    %edx,%eax
}
  800e41:	c9                   	leave  
  800e42:	c3                   	ret    

00800e43 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800e43:	55                   	push   %ebp
  800e44:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800e46:	eb 06                	jmp    800e4e <strcmp+0xb>
		p++, q++;
  800e48:	ff 45 08             	incl   0x8(%ebp)
  800e4b:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800e4e:	8b 45 08             	mov    0x8(%ebp),%eax
  800e51:	8a 00                	mov    (%eax),%al
  800e53:	84 c0                	test   %al,%al
  800e55:	74 0e                	je     800e65 <strcmp+0x22>
  800e57:	8b 45 08             	mov    0x8(%ebp),%eax
  800e5a:	8a 10                	mov    (%eax),%dl
  800e5c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e5f:	8a 00                	mov    (%eax),%al
  800e61:	38 c2                	cmp    %al,%dl
  800e63:	74 e3                	je     800e48 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800e65:	8b 45 08             	mov    0x8(%ebp),%eax
  800e68:	8a 00                	mov    (%eax),%al
  800e6a:	0f b6 d0             	movzbl %al,%edx
  800e6d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e70:	8a 00                	mov    (%eax),%al
  800e72:	0f b6 c0             	movzbl %al,%eax
  800e75:	29 c2                	sub    %eax,%edx
  800e77:	89 d0                	mov    %edx,%eax
}
  800e79:	5d                   	pop    %ebp
  800e7a:	c3                   	ret    

00800e7b <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800e7b:	55                   	push   %ebp
  800e7c:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800e7e:	eb 09                	jmp    800e89 <strncmp+0xe>
		n--, p++, q++;
  800e80:	ff 4d 10             	decl   0x10(%ebp)
  800e83:	ff 45 08             	incl   0x8(%ebp)
  800e86:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800e89:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e8d:	74 17                	je     800ea6 <strncmp+0x2b>
  800e8f:	8b 45 08             	mov    0x8(%ebp),%eax
  800e92:	8a 00                	mov    (%eax),%al
  800e94:	84 c0                	test   %al,%al
  800e96:	74 0e                	je     800ea6 <strncmp+0x2b>
  800e98:	8b 45 08             	mov    0x8(%ebp),%eax
  800e9b:	8a 10                	mov    (%eax),%dl
  800e9d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ea0:	8a 00                	mov    (%eax),%al
  800ea2:	38 c2                	cmp    %al,%dl
  800ea4:	74 da                	je     800e80 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800ea6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800eaa:	75 07                	jne    800eb3 <strncmp+0x38>
		return 0;
  800eac:	b8 00 00 00 00       	mov    $0x0,%eax
  800eb1:	eb 14                	jmp    800ec7 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800eb3:	8b 45 08             	mov    0x8(%ebp),%eax
  800eb6:	8a 00                	mov    (%eax),%al
  800eb8:	0f b6 d0             	movzbl %al,%edx
  800ebb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ebe:	8a 00                	mov    (%eax),%al
  800ec0:	0f b6 c0             	movzbl %al,%eax
  800ec3:	29 c2                	sub    %eax,%edx
  800ec5:	89 d0                	mov    %edx,%eax
}
  800ec7:	5d                   	pop    %ebp
  800ec8:	c3                   	ret    

00800ec9 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800ec9:	55                   	push   %ebp
  800eca:	89 e5                	mov    %esp,%ebp
  800ecc:	83 ec 04             	sub    $0x4,%esp
  800ecf:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ed2:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800ed5:	eb 12                	jmp    800ee9 <strchr+0x20>
		if (*s == c)
  800ed7:	8b 45 08             	mov    0x8(%ebp),%eax
  800eda:	8a 00                	mov    (%eax),%al
  800edc:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800edf:	75 05                	jne    800ee6 <strchr+0x1d>
			return (char *) s;
  800ee1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ee4:	eb 11                	jmp    800ef7 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800ee6:	ff 45 08             	incl   0x8(%ebp)
  800ee9:	8b 45 08             	mov    0x8(%ebp),%eax
  800eec:	8a 00                	mov    (%eax),%al
  800eee:	84 c0                	test   %al,%al
  800ef0:	75 e5                	jne    800ed7 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800ef2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ef7:	c9                   	leave  
  800ef8:	c3                   	ret    

00800ef9 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800ef9:	55                   	push   %ebp
  800efa:	89 e5                	mov    %esp,%ebp
  800efc:	83 ec 04             	sub    $0x4,%esp
  800eff:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f02:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800f05:	eb 0d                	jmp    800f14 <strfind+0x1b>
		if (*s == c)
  800f07:	8b 45 08             	mov    0x8(%ebp),%eax
  800f0a:	8a 00                	mov    (%eax),%al
  800f0c:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800f0f:	74 0e                	je     800f1f <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800f11:	ff 45 08             	incl   0x8(%ebp)
  800f14:	8b 45 08             	mov    0x8(%ebp),%eax
  800f17:	8a 00                	mov    (%eax),%al
  800f19:	84 c0                	test   %al,%al
  800f1b:	75 ea                	jne    800f07 <strfind+0xe>
  800f1d:	eb 01                	jmp    800f20 <strfind+0x27>
		if (*s == c)
			break;
  800f1f:	90                   	nop
	return (char *) s;
  800f20:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f23:	c9                   	leave  
  800f24:	c3                   	ret    

00800f25 <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  800f25:	55                   	push   %ebp
  800f26:	89 e5                	mov    %esp,%ebp
  800f28:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  800f2b:	8b 45 08             	mov    0x8(%ebp),%eax
  800f2e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  800f31:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800f35:	76 63                	jbe    800f9a <memset+0x75>
		uint64 data_block = c;
  800f37:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f3a:	99                   	cltd   
  800f3b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f3e:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  800f41:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800f44:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f47:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  800f4b:	c1 e0 08             	shl    $0x8,%eax
  800f4e:	09 45 f0             	or     %eax,-0x10(%ebp)
  800f51:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  800f54:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800f57:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f5a:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  800f5e:	c1 e0 10             	shl    $0x10,%eax
  800f61:	09 45 f0             	or     %eax,-0x10(%ebp)
  800f64:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  800f67:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800f6a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f6d:	89 c2                	mov    %eax,%edx
  800f6f:	b8 00 00 00 00       	mov    $0x0,%eax
  800f74:	09 45 f0             	or     %eax,-0x10(%ebp)
  800f77:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  800f7a:	eb 18                	jmp    800f94 <memset+0x6f>
			*p64++ = data_block, n -= 8;
  800f7c:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  800f7f:	8d 41 08             	lea    0x8(%ecx),%eax
  800f82:	89 45 fc             	mov    %eax,-0x4(%ebp)
  800f85:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800f88:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f8b:	89 01                	mov    %eax,(%ecx)
  800f8d:	89 51 04             	mov    %edx,0x4(%ecx)
  800f90:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  800f94:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800f98:	77 e2                	ja     800f7c <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  800f9a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f9e:	74 23                	je     800fc3 <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  800fa0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fa3:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  800fa6:	eb 0e                	jmp    800fb6 <memset+0x91>
			*p8++ = (uint8)c;
  800fa8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fab:	8d 50 01             	lea    0x1(%eax),%edx
  800fae:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800fb1:	8b 55 0c             	mov    0xc(%ebp),%edx
  800fb4:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  800fb6:	8b 45 10             	mov    0x10(%ebp),%eax
  800fb9:	8d 50 ff             	lea    -0x1(%eax),%edx
  800fbc:	89 55 10             	mov    %edx,0x10(%ebp)
  800fbf:	85 c0                	test   %eax,%eax
  800fc1:	75 e5                	jne    800fa8 <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  800fc3:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800fc6:	c9                   	leave  
  800fc7:	c3                   	ret    

00800fc8 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800fc8:	55                   	push   %ebp
  800fc9:	89 e5                	mov    %esp,%ebp
  800fcb:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  800fce:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fd1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  800fd4:	8b 45 08             	mov    0x8(%ebp),%eax
  800fd7:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  800fda:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800fde:	76 24                	jbe    801004 <memcpy+0x3c>
		while(n >= 8){
  800fe0:	eb 1c                	jmp    800ffe <memcpy+0x36>
			*d64 = *s64;
  800fe2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fe5:	8b 50 04             	mov    0x4(%eax),%edx
  800fe8:	8b 00                	mov    (%eax),%eax
  800fea:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  800fed:	89 01                	mov    %eax,(%ecx)
  800fef:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  800ff2:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  800ff6:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  800ffa:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  800ffe:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801002:	77 de                	ja     800fe2 <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  801004:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801008:	74 31                	je     80103b <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  80100a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80100d:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  801010:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801013:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  801016:	eb 16                	jmp    80102e <memcpy+0x66>
			*d8++ = *s8++;
  801018:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80101b:	8d 50 01             	lea    0x1(%eax),%edx
  80101e:	89 55 f0             	mov    %edx,-0x10(%ebp)
  801021:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801024:	8d 4a 01             	lea    0x1(%edx),%ecx
  801027:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  80102a:	8a 12                	mov    (%edx),%dl
  80102c:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  80102e:	8b 45 10             	mov    0x10(%ebp),%eax
  801031:	8d 50 ff             	lea    -0x1(%eax),%edx
  801034:	89 55 10             	mov    %edx,0x10(%ebp)
  801037:	85 c0                	test   %eax,%eax
  801039:	75 dd                	jne    801018 <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  80103b:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80103e:	c9                   	leave  
  80103f:	c3                   	ret    

00801040 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801040:	55                   	push   %ebp
  801041:	89 e5                	mov    %esp,%ebp
  801043:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801046:	8b 45 0c             	mov    0xc(%ebp),%eax
  801049:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  80104c:	8b 45 08             	mov    0x8(%ebp),%eax
  80104f:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801052:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801055:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801058:	73 50                	jae    8010aa <memmove+0x6a>
  80105a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80105d:	8b 45 10             	mov    0x10(%ebp),%eax
  801060:	01 d0                	add    %edx,%eax
  801062:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801065:	76 43                	jbe    8010aa <memmove+0x6a>
		s += n;
  801067:	8b 45 10             	mov    0x10(%ebp),%eax
  80106a:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  80106d:	8b 45 10             	mov    0x10(%ebp),%eax
  801070:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  801073:	eb 10                	jmp    801085 <memmove+0x45>
			*--d = *--s;
  801075:	ff 4d f8             	decl   -0x8(%ebp)
  801078:	ff 4d fc             	decl   -0x4(%ebp)
  80107b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80107e:	8a 10                	mov    (%eax),%dl
  801080:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801083:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  801085:	8b 45 10             	mov    0x10(%ebp),%eax
  801088:	8d 50 ff             	lea    -0x1(%eax),%edx
  80108b:	89 55 10             	mov    %edx,0x10(%ebp)
  80108e:	85 c0                	test   %eax,%eax
  801090:	75 e3                	jne    801075 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801092:	eb 23                	jmp    8010b7 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  801094:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801097:	8d 50 01             	lea    0x1(%eax),%edx
  80109a:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80109d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8010a0:	8d 4a 01             	lea    0x1(%edx),%ecx
  8010a3:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8010a6:	8a 12                	mov    (%edx),%dl
  8010a8:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  8010aa:	8b 45 10             	mov    0x10(%ebp),%eax
  8010ad:	8d 50 ff             	lea    -0x1(%eax),%edx
  8010b0:	89 55 10             	mov    %edx,0x10(%ebp)
  8010b3:	85 c0                	test   %eax,%eax
  8010b5:	75 dd                	jne    801094 <memmove+0x54>
			*d++ = *s++;

	return dst;
  8010b7:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8010ba:	c9                   	leave  
  8010bb:	c3                   	ret    

008010bc <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8010bc:	55                   	push   %ebp
  8010bd:	89 e5                	mov    %esp,%ebp
  8010bf:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  8010c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  8010c8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010cb:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8010ce:	eb 2a                	jmp    8010fa <memcmp+0x3e>
		if (*s1 != *s2)
  8010d0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010d3:	8a 10                	mov    (%eax),%dl
  8010d5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010d8:	8a 00                	mov    (%eax),%al
  8010da:	38 c2                	cmp    %al,%dl
  8010dc:	74 16                	je     8010f4 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  8010de:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010e1:	8a 00                	mov    (%eax),%al
  8010e3:	0f b6 d0             	movzbl %al,%edx
  8010e6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010e9:	8a 00                	mov    (%eax),%al
  8010eb:	0f b6 c0             	movzbl %al,%eax
  8010ee:	29 c2                	sub    %eax,%edx
  8010f0:	89 d0                	mov    %edx,%eax
  8010f2:	eb 18                	jmp    80110c <memcmp+0x50>
		s1++, s2++;
  8010f4:	ff 45 fc             	incl   -0x4(%ebp)
  8010f7:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  8010fa:	8b 45 10             	mov    0x10(%ebp),%eax
  8010fd:	8d 50 ff             	lea    -0x1(%eax),%edx
  801100:	89 55 10             	mov    %edx,0x10(%ebp)
  801103:	85 c0                	test   %eax,%eax
  801105:	75 c9                	jne    8010d0 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801107:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80110c:	c9                   	leave  
  80110d:	c3                   	ret    

0080110e <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  80110e:	55                   	push   %ebp
  80110f:	89 e5                	mov    %esp,%ebp
  801111:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801114:	8b 55 08             	mov    0x8(%ebp),%edx
  801117:	8b 45 10             	mov    0x10(%ebp),%eax
  80111a:	01 d0                	add    %edx,%eax
  80111c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  80111f:	eb 15                	jmp    801136 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801121:	8b 45 08             	mov    0x8(%ebp),%eax
  801124:	8a 00                	mov    (%eax),%al
  801126:	0f b6 d0             	movzbl %al,%edx
  801129:	8b 45 0c             	mov    0xc(%ebp),%eax
  80112c:	0f b6 c0             	movzbl %al,%eax
  80112f:	39 c2                	cmp    %eax,%edx
  801131:	74 0d                	je     801140 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801133:	ff 45 08             	incl   0x8(%ebp)
  801136:	8b 45 08             	mov    0x8(%ebp),%eax
  801139:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80113c:	72 e3                	jb     801121 <memfind+0x13>
  80113e:	eb 01                	jmp    801141 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801140:	90                   	nop
	return (void *) s;
  801141:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801144:	c9                   	leave  
  801145:	c3                   	ret    

00801146 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801146:	55                   	push   %ebp
  801147:	89 e5                	mov    %esp,%ebp
  801149:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  80114c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801153:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80115a:	eb 03                	jmp    80115f <strtol+0x19>
		s++;
  80115c:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80115f:	8b 45 08             	mov    0x8(%ebp),%eax
  801162:	8a 00                	mov    (%eax),%al
  801164:	3c 20                	cmp    $0x20,%al
  801166:	74 f4                	je     80115c <strtol+0x16>
  801168:	8b 45 08             	mov    0x8(%ebp),%eax
  80116b:	8a 00                	mov    (%eax),%al
  80116d:	3c 09                	cmp    $0x9,%al
  80116f:	74 eb                	je     80115c <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801171:	8b 45 08             	mov    0x8(%ebp),%eax
  801174:	8a 00                	mov    (%eax),%al
  801176:	3c 2b                	cmp    $0x2b,%al
  801178:	75 05                	jne    80117f <strtol+0x39>
		s++;
  80117a:	ff 45 08             	incl   0x8(%ebp)
  80117d:	eb 13                	jmp    801192 <strtol+0x4c>
	else if (*s == '-')
  80117f:	8b 45 08             	mov    0x8(%ebp),%eax
  801182:	8a 00                	mov    (%eax),%al
  801184:	3c 2d                	cmp    $0x2d,%al
  801186:	75 0a                	jne    801192 <strtol+0x4c>
		s++, neg = 1;
  801188:	ff 45 08             	incl   0x8(%ebp)
  80118b:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801192:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801196:	74 06                	je     80119e <strtol+0x58>
  801198:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  80119c:	75 20                	jne    8011be <strtol+0x78>
  80119e:	8b 45 08             	mov    0x8(%ebp),%eax
  8011a1:	8a 00                	mov    (%eax),%al
  8011a3:	3c 30                	cmp    $0x30,%al
  8011a5:	75 17                	jne    8011be <strtol+0x78>
  8011a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8011aa:	40                   	inc    %eax
  8011ab:	8a 00                	mov    (%eax),%al
  8011ad:	3c 78                	cmp    $0x78,%al
  8011af:	75 0d                	jne    8011be <strtol+0x78>
		s += 2, base = 16;
  8011b1:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8011b5:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8011bc:	eb 28                	jmp    8011e6 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8011be:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8011c2:	75 15                	jne    8011d9 <strtol+0x93>
  8011c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8011c7:	8a 00                	mov    (%eax),%al
  8011c9:	3c 30                	cmp    $0x30,%al
  8011cb:	75 0c                	jne    8011d9 <strtol+0x93>
		s++, base = 8;
  8011cd:	ff 45 08             	incl   0x8(%ebp)
  8011d0:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8011d7:	eb 0d                	jmp    8011e6 <strtol+0xa0>
	else if (base == 0)
  8011d9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8011dd:	75 07                	jne    8011e6 <strtol+0xa0>
		base = 10;
  8011df:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8011e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8011e9:	8a 00                	mov    (%eax),%al
  8011eb:	3c 2f                	cmp    $0x2f,%al
  8011ed:	7e 19                	jle    801208 <strtol+0xc2>
  8011ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8011f2:	8a 00                	mov    (%eax),%al
  8011f4:	3c 39                	cmp    $0x39,%al
  8011f6:	7f 10                	jg     801208 <strtol+0xc2>
			dig = *s - '0';
  8011f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8011fb:	8a 00                	mov    (%eax),%al
  8011fd:	0f be c0             	movsbl %al,%eax
  801200:	83 e8 30             	sub    $0x30,%eax
  801203:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801206:	eb 42                	jmp    80124a <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801208:	8b 45 08             	mov    0x8(%ebp),%eax
  80120b:	8a 00                	mov    (%eax),%al
  80120d:	3c 60                	cmp    $0x60,%al
  80120f:	7e 19                	jle    80122a <strtol+0xe4>
  801211:	8b 45 08             	mov    0x8(%ebp),%eax
  801214:	8a 00                	mov    (%eax),%al
  801216:	3c 7a                	cmp    $0x7a,%al
  801218:	7f 10                	jg     80122a <strtol+0xe4>
			dig = *s - 'a' + 10;
  80121a:	8b 45 08             	mov    0x8(%ebp),%eax
  80121d:	8a 00                	mov    (%eax),%al
  80121f:	0f be c0             	movsbl %al,%eax
  801222:	83 e8 57             	sub    $0x57,%eax
  801225:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801228:	eb 20                	jmp    80124a <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  80122a:	8b 45 08             	mov    0x8(%ebp),%eax
  80122d:	8a 00                	mov    (%eax),%al
  80122f:	3c 40                	cmp    $0x40,%al
  801231:	7e 39                	jle    80126c <strtol+0x126>
  801233:	8b 45 08             	mov    0x8(%ebp),%eax
  801236:	8a 00                	mov    (%eax),%al
  801238:	3c 5a                	cmp    $0x5a,%al
  80123a:	7f 30                	jg     80126c <strtol+0x126>
			dig = *s - 'A' + 10;
  80123c:	8b 45 08             	mov    0x8(%ebp),%eax
  80123f:	8a 00                	mov    (%eax),%al
  801241:	0f be c0             	movsbl %al,%eax
  801244:	83 e8 37             	sub    $0x37,%eax
  801247:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  80124a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80124d:	3b 45 10             	cmp    0x10(%ebp),%eax
  801250:	7d 19                	jge    80126b <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801252:	ff 45 08             	incl   0x8(%ebp)
  801255:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801258:	0f af 45 10          	imul   0x10(%ebp),%eax
  80125c:	89 c2                	mov    %eax,%edx
  80125e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801261:	01 d0                	add    %edx,%eax
  801263:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801266:	e9 7b ff ff ff       	jmp    8011e6 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  80126b:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  80126c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801270:	74 08                	je     80127a <strtol+0x134>
		*endptr = (char *) s;
  801272:	8b 45 0c             	mov    0xc(%ebp),%eax
  801275:	8b 55 08             	mov    0x8(%ebp),%edx
  801278:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  80127a:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80127e:	74 07                	je     801287 <strtol+0x141>
  801280:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801283:	f7 d8                	neg    %eax
  801285:	eb 03                	jmp    80128a <strtol+0x144>
  801287:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80128a:	c9                   	leave  
  80128b:	c3                   	ret    

0080128c <ltostr>:

void
ltostr(long value, char *str)
{
  80128c:	55                   	push   %ebp
  80128d:	89 e5                	mov    %esp,%ebp
  80128f:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801292:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801299:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8012a0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8012a4:	79 13                	jns    8012b9 <ltostr+0x2d>
	{
		neg = 1;
  8012a6:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8012ad:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012b0:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8012b3:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8012b6:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8012b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8012bc:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8012c1:	99                   	cltd   
  8012c2:	f7 f9                	idiv   %ecx
  8012c4:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8012c7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012ca:	8d 50 01             	lea    0x1(%eax),%edx
  8012cd:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8012d0:	89 c2                	mov    %eax,%edx
  8012d2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012d5:	01 d0                	add    %edx,%eax
  8012d7:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8012da:	83 c2 30             	add    $0x30,%edx
  8012dd:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8012df:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8012e2:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8012e7:	f7 e9                	imul   %ecx
  8012e9:	c1 fa 02             	sar    $0x2,%edx
  8012ec:	89 c8                	mov    %ecx,%eax
  8012ee:	c1 f8 1f             	sar    $0x1f,%eax
  8012f1:	29 c2                	sub    %eax,%edx
  8012f3:	89 d0                	mov    %edx,%eax
  8012f5:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  8012f8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8012fc:	75 bb                	jne    8012b9 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8012fe:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801305:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801308:	48                   	dec    %eax
  801309:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  80130c:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801310:	74 3d                	je     80134f <ltostr+0xc3>
		start = 1 ;
  801312:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801319:	eb 34                	jmp    80134f <ltostr+0xc3>
	{
		char tmp = str[start] ;
  80131b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80131e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801321:	01 d0                	add    %edx,%eax
  801323:	8a 00                	mov    (%eax),%al
  801325:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801328:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80132b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80132e:	01 c2                	add    %eax,%edx
  801330:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801333:	8b 45 0c             	mov    0xc(%ebp),%eax
  801336:	01 c8                	add    %ecx,%eax
  801338:	8a 00                	mov    (%eax),%al
  80133a:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  80133c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80133f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801342:	01 c2                	add    %eax,%edx
  801344:	8a 45 eb             	mov    -0x15(%ebp),%al
  801347:	88 02                	mov    %al,(%edx)
		start++ ;
  801349:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  80134c:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  80134f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801352:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801355:	7c c4                	jl     80131b <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801357:	8b 55 f8             	mov    -0x8(%ebp),%edx
  80135a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80135d:	01 d0                	add    %edx,%eax
  80135f:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801362:	90                   	nop
  801363:	c9                   	leave  
  801364:	c3                   	ret    

00801365 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801365:	55                   	push   %ebp
  801366:	89 e5                	mov    %esp,%ebp
  801368:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  80136b:	ff 75 08             	pushl  0x8(%ebp)
  80136e:	e8 c4 f9 ff ff       	call   800d37 <strlen>
  801373:	83 c4 04             	add    $0x4,%esp
  801376:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801379:	ff 75 0c             	pushl  0xc(%ebp)
  80137c:	e8 b6 f9 ff ff       	call   800d37 <strlen>
  801381:	83 c4 04             	add    $0x4,%esp
  801384:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801387:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  80138e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801395:	eb 17                	jmp    8013ae <strcconcat+0x49>
		final[s] = str1[s] ;
  801397:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80139a:	8b 45 10             	mov    0x10(%ebp),%eax
  80139d:	01 c2                	add    %eax,%edx
  80139f:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8013a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8013a5:	01 c8                	add    %ecx,%eax
  8013a7:	8a 00                	mov    (%eax),%al
  8013a9:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8013ab:	ff 45 fc             	incl   -0x4(%ebp)
  8013ae:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8013b1:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8013b4:	7c e1                	jl     801397 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8013b6:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8013bd:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8013c4:	eb 1f                	jmp    8013e5 <strcconcat+0x80>
		final[s++] = str2[i] ;
  8013c6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8013c9:	8d 50 01             	lea    0x1(%eax),%edx
  8013cc:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8013cf:	89 c2                	mov    %eax,%edx
  8013d1:	8b 45 10             	mov    0x10(%ebp),%eax
  8013d4:	01 c2                	add    %eax,%edx
  8013d6:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8013d9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013dc:	01 c8                	add    %ecx,%eax
  8013de:	8a 00                	mov    (%eax),%al
  8013e0:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8013e2:	ff 45 f8             	incl   -0x8(%ebp)
  8013e5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8013e8:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8013eb:	7c d9                	jl     8013c6 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8013ed:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8013f0:	8b 45 10             	mov    0x10(%ebp),%eax
  8013f3:	01 d0                	add    %edx,%eax
  8013f5:	c6 00 00             	movb   $0x0,(%eax)
}
  8013f8:	90                   	nop
  8013f9:	c9                   	leave  
  8013fa:	c3                   	ret    

008013fb <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8013fb:	55                   	push   %ebp
  8013fc:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8013fe:	8b 45 14             	mov    0x14(%ebp),%eax
  801401:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801407:	8b 45 14             	mov    0x14(%ebp),%eax
  80140a:	8b 00                	mov    (%eax),%eax
  80140c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801413:	8b 45 10             	mov    0x10(%ebp),%eax
  801416:	01 d0                	add    %edx,%eax
  801418:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80141e:	eb 0c                	jmp    80142c <strsplit+0x31>
			*string++ = 0;
  801420:	8b 45 08             	mov    0x8(%ebp),%eax
  801423:	8d 50 01             	lea    0x1(%eax),%edx
  801426:	89 55 08             	mov    %edx,0x8(%ebp)
  801429:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80142c:	8b 45 08             	mov    0x8(%ebp),%eax
  80142f:	8a 00                	mov    (%eax),%al
  801431:	84 c0                	test   %al,%al
  801433:	74 18                	je     80144d <strsplit+0x52>
  801435:	8b 45 08             	mov    0x8(%ebp),%eax
  801438:	8a 00                	mov    (%eax),%al
  80143a:	0f be c0             	movsbl %al,%eax
  80143d:	50                   	push   %eax
  80143e:	ff 75 0c             	pushl  0xc(%ebp)
  801441:	e8 83 fa ff ff       	call   800ec9 <strchr>
  801446:	83 c4 08             	add    $0x8,%esp
  801449:	85 c0                	test   %eax,%eax
  80144b:	75 d3                	jne    801420 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  80144d:	8b 45 08             	mov    0x8(%ebp),%eax
  801450:	8a 00                	mov    (%eax),%al
  801452:	84 c0                	test   %al,%al
  801454:	74 5a                	je     8014b0 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801456:	8b 45 14             	mov    0x14(%ebp),%eax
  801459:	8b 00                	mov    (%eax),%eax
  80145b:	83 f8 0f             	cmp    $0xf,%eax
  80145e:	75 07                	jne    801467 <strsplit+0x6c>
		{
			return 0;
  801460:	b8 00 00 00 00       	mov    $0x0,%eax
  801465:	eb 66                	jmp    8014cd <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801467:	8b 45 14             	mov    0x14(%ebp),%eax
  80146a:	8b 00                	mov    (%eax),%eax
  80146c:	8d 48 01             	lea    0x1(%eax),%ecx
  80146f:	8b 55 14             	mov    0x14(%ebp),%edx
  801472:	89 0a                	mov    %ecx,(%edx)
  801474:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80147b:	8b 45 10             	mov    0x10(%ebp),%eax
  80147e:	01 c2                	add    %eax,%edx
  801480:	8b 45 08             	mov    0x8(%ebp),%eax
  801483:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801485:	eb 03                	jmp    80148a <strsplit+0x8f>
			string++;
  801487:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  80148a:	8b 45 08             	mov    0x8(%ebp),%eax
  80148d:	8a 00                	mov    (%eax),%al
  80148f:	84 c0                	test   %al,%al
  801491:	74 8b                	je     80141e <strsplit+0x23>
  801493:	8b 45 08             	mov    0x8(%ebp),%eax
  801496:	8a 00                	mov    (%eax),%al
  801498:	0f be c0             	movsbl %al,%eax
  80149b:	50                   	push   %eax
  80149c:	ff 75 0c             	pushl  0xc(%ebp)
  80149f:	e8 25 fa ff ff       	call   800ec9 <strchr>
  8014a4:	83 c4 08             	add    $0x8,%esp
  8014a7:	85 c0                	test   %eax,%eax
  8014a9:	74 dc                	je     801487 <strsplit+0x8c>
			string++;
	}
  8014ab:	e9 6e ff ff ff       	jmp    80141e <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8014b0:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8014b1:	8b 45 14             	mov    0x14(%ebp),%eax
  8014b4:	8b 00                	mov    (%eax),%eax
  8014b6:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8014bd:	8b 45 10             	mov    0x10(%ebp),%eax
  8014c0:	01 d0                	add    %edx,%eax
  8014c2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8014c8:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8014cd:	c9                   	leave  
  8014ce:	c3                   	ret    

008014cf <str2lower>:


char* str2lower(char *dst, const char *src)
{
  8014cf:	55                   	push   %ebp
  8014d0:	89 e5                	mov    %esp,%ebp
  8014d2:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  8014d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8014d8:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  8014db:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8014e2:	eb 4a                	jmp    80152e <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  8014e4:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8014e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ea:	01 c2                	add    %eax,%edx
  8014ec:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8014ef:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014f2:	01 c8                	add    %ecx,%eax
  8014f4:	8a 00                	mov    (%eax),%al
  8014f6:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  8014f8:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8014fb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014fe:	01 d0                	add    %edx,%eax
  801500:	8a 00                	mov    (%eax),%al
  801502:	3c 40                	cmp    $0x40,%al
  801504:	7e 25                	jle    80152b <str2lower+0x5c>
  801506:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801509:	8b 45 0c             	mov    0xc(%ebp),%eax
  80150c:	01 d0                	add    %edx,%eax
  80150e:	8a 00                	mov    (%eax),%al
  801510:	3c 5a                	cmp    $0x5a,%al
  801512:	7f 17                	jg     80152b <str2lower+0x5c>
		{
			dst[i] += 32 ;
  801514:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801517:	8b 45 08             	mov    0x8(%ebp),%eax
  80151a:	01 d0                	add    %edx,%eax
  80151c:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80151f:	8b 55 08             	mov    0x8(%ebp),%edx
  801522:	01 ca                	add    %ecx,%edx
  801524:	8a 12                	mov    (%edx),%dl
  801526:	83 c2 20             	add    $0x20,%edx
  801529:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  80152b:	ff 45 fc             	incl   -0x4(%ebp)
  80152e:	ff 75 0c             	pushl  0xc(%ebp)
  801531:	e8 01 f8 ff ff       	call   800d37 <strlen>
  801536:	83 c4 04             	add    $0x4,%esp
  801539:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80153c:	7f a6                	jg     8014e4 <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  80153e:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801541:	c9                   	leave  
  801542:	c3                   	ret    

00801543 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801543:	55                   	push   %ebp
  801544:	89 e5                	mov    %esp,%ebp
  801546:	57                   	push   %edi
  801547:	56                   	push   %esi
  801548:	53                   	push   %ebx
  801549:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80154c:	8b 45 08             	mov    0x8(%ebp),%eax
  80154f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801552:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801555:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801558:	8b 7d 18             	mov    0x18(%ebp),%edi
  80155b:	8b 75 1c             	mov    0x1c(%ebp),%esi
  80155e:	cd 30                	int    $0x30
  801560:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  801563:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801566:	83 c4 10             	add    $0x10,%esp
  801569:	5b                   	pop    %ebx
  80156a:	5e                   	pop    %esi
  80156b:	5f                   	pop    %edi
  80156c:	5d                   	pop    %ebp
  80156d:	c3                   	ret    

0080156e <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  80156e:	55                   	push   %ebp
  80156f:	89 e5                	mov    %esp,%ebp
  801571:	83 ec 04             	sub    $0x4,%esp
  801574:	8b 45 10             	mov    0x10(%ebp),%eax
  801577:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  80157a:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80157d:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801581:	8b 45 08             	mov    0x8(%ebp),%eax
  801584:	6a 00                	push   $0x0
  801586:	51                   	push   %ecx
  801587:	52                   	push   %edx
  801588:	ff 75 0c             	pushl  0xc(%ebp)
  80158b:	50                   	push   %eax
  80158c:	6a 00                	push   $0x0
  80158e:	e8 b0 ff ff ff       	call   801543 <syscall>
  801593:	83 c4 18             	add    $0x18,%esp
}
  801596:	90                   	nop
  801597:	c9                   	leave  
  801598:	c3                   	ret    

00801599 <sys_cgetc>:

int
sys_cgetc(void)
{
  801599:	55                   	push   %ebp
  80159a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  80159c:	6a 00                	push   $0x0
  80159e:	6a 00                	push   $0x0
  8015a0:	6a 00                	push   $0x0
  8015a2:	6a 00                	push   $0x0
  8015a4:	6a 00                	push   $0x0
  8015a6:	6a 02                	push   $0x2
  8015a8:	e8 96 ff ff ff       	call   801543 <syscall>
  8015ad:	83 c4 18             	add    $0x18,%esp
}
  8015b0:	c9                   	leave  
  8015b1:	c3                   	ret    

008015b2 <sys_lock_cons>:

void sys_lock_cons(void)
{
  8015b2:	55                   	push   %ebp
  8015b3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  8015b5:	6a 00                	push   $0x0
  8015b7:	6a 00                	push   $0x0
  8015b9:	6a 00                	push   $0x0
  8015bb:	6a 00                	push   $0x0
  8015bd:	6a 00                	push   $0x0
  8015bf:	6a 03                	push   $0x3
  8015c1:	e8 7d ff ff ff       	call   801543 <syscall>
  8015c6:	83 c4 18             	add    $0x18,%esp
}
  8015c9:	90                   	nop
  8015ca:	c9                   	leave  
  8015cb:	c3                   	ret    

008015cc <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  8015cc:	55                   	push   %ebp
  8015cd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  8015cf:	6a 00                	push   $0x0
  8015d1:	6a 00                	push   $0x0
  8015d3:	6a 00                	push   $0x0
  8015d5:	6a 00                	push   $0x0
  8015d7:	6a 00                	push   $0x0
  8015d9:	6a 04                	push   $0x4
  8015db:	e8 63 ff ff ff       	call   801543 <syscall>
  8015e0:	83 c4 18             	add    $0x18,%esp
}
  8015e3:	90                   	nop
  8015e4:	c9                   	leave  
  8015e5:	c3                   	ret    

008015e6 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8015e6:	55                   	push   %ebp
  8015e7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8015e9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8015ef:	6a 00                	push   $0x0
  8015f1:	6a 00                	push   $0x0
  8015f3:	6a 00                	push   $0x0
  8015f5:	52                   	push   %edx
  8015f6:	50                   	push   %eax
  8015f7:	6a 08                	push   $0x8
  8015f9:	e8 45 ff ff ff       	call   801543 <syscall>
  8015fe:	83 c4 18             	add    $0x18,%esp
}
  801601:	c9                   	leave  
  801602:	c3                   	ret    

00801603 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801603:	55                   	push   %ebp
  801604:	89 e5                	mov    %esp,%ebp
  801606:	56                   	push   %esi
  801607:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801608:	8b 75 18             	mov    0x18(%ebp),%esi
  80160b:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80160e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801611:	8b 55 0c             	mov    0xc(%ebp),%edx
  801614:	8b 45 08             	mov    0x8(%ebp),%eax
  801617:	56                   	push   %esi
  801618:	53                   	push   %ebx
  801619:	51                   	push   %ecx
  80161a:	52                   	push   %edx
  80161b:	50                   	push   %eax
  80161c:	6a 09                	push   $0x9
  80161e:	e8 20 ff ff ff       	call   801543 <syscall>
  801623:	83 c4 18             	add    $0x18,%esp
}
  801626:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801629:	5b                   	pop    %ebx
  80162a:	5e                   	pop    %esi
  80162b:	5d                   	pop    %ebp
  80162c:	c3                   	ret    

0080162d <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  80162d:	55                   	push   %ebp
  80162e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  801630:	6a 00                	push   $0x0
  801632:	6a 00                	push   $0x0
  801634:	6a 00                	push   $0x0
  801636:	6a 00                	push   $0x0
  801638:	ff 75 08             	pushl  0x8(%ebp)
  80163b:	6a 0a                	push   $0xa
  80163d:	e8 01 ff ff ff       	call   801543 <syscall>
  801642:	83 c4 18             	add    $0x18,%esp
}
  801645:	c9                   	leave  
  801646:	c3                   	ret    

00801647 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801647:	55                   	push   %ebp
  801648:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  80164a:	6a 00                	push   $0x0
  80164c:	6a 00                	push   $0x0
  80164e:	6a 00                	push   $0x0
  801650:	ff 75 0c             	pushl  0xc(%ebp)
  801653:	ff 75 08             	pushl  0x8(%ebp)
  801656:	6a 0b                	push   $0xb
  801658:	e8 e6 fe ff ff       	call   801543 <syscall>
  80165d:	83 c4 18             	add    $0x18,%esp
}
  801660:	c9                   	leave  
  801661:	c3                   	ret    

00801662 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801662:	55                   	push   %ebp
  801663:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801665:	6a 00                	push   $0x0
  801667:	6a 00                	push   $0x0
  801669:	6a 00                	push   $0x0
  80166b:	6a 00                	push   $0x0
  80166d:	6a 00                	push   $0x0
  80166f:	6a 0c                	push   $0xc
  801671:	e8 cd fe ff ff       	call   801543 <syscall>
  801676:	83 c4 18             	add    $0x18,%esp
}
  801679:	c9                   	leave  
  80167a:	c3                   	ret    

0080167b <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  80167b:	55                   	push   %ebp
  80167c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  80167e:	6a 00                	push   $0x0
  801680:	6a 00                	push   $0x0
  801682:	6a 00                	push   $0x0
  801684:	6a 00                	push   $0x0
  801686:	6a 00                	push   $0x0
  801688:	6a 0d                	push   $0xd
  80168a:	e8 b4 fe ff ff       	call   801543 <syscall>
  80168f:	83 c4 18             	add    $0x18,%esp
}
  801692:	c9                   	leave  
  801693:	c3                   	ret    

00801694 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801694:	55                   	push   %ebp
  801695:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801697:	6a 00                	push   $0x0
  801699:	6a 00                	push   $0x0
  80169b:	6a 00                	push   $0x0
  80169d:	6a 00                	push   $0x0
  80169f:	6a 00                	push   $0x0
  8016a1:	6a 0e                	push   $0xe
  8016a3:	e8 9b fe ff ff       	call   801543 <syscall>
  8016a8:	83 c4 18             	add    $0x18,%esp
}
  8016ab:	c9                   	leave  
  8016ac:	c3                   	ret    

008016ad <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8016ad:	55                   	push   %ebp
  8016ae:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8016b0:	6a 00                	push   $0x0
  8016b2:	6a 00                	push   $0x0
  8016b4:	6a 00                	push   $0x0
  8016b6:	6a 00                	push   $0x0
  8016b8:	6a 00                	push   $0x0
  8016ba:	6a 0f                	push   $0xf
  8016bc:	e8 82 fe ff ff       	call   801543 <syscall>
  8016c1:	83 c4 18             	add    $0x18,%esp
}
  8016c4:	c9                   	leave  
  8016c5:	c3                   	ret    

008016c6 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8016c6:	55                   	push   %ebp
  8016c7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8016c9:	6a 00                	push   $0x0
  8016cb:	6a 00                	push   $0x0
  8016cd:	6a 00                	push   $0x0
  8016cf:	6a 00                	push   $0x0
  8016d1:	ff 75 08             	pushl  0x8(%ebp)
  8016d4:	6a 10                	push   $0x10
  8016d6:	e8 68 fe ff ff       	call   801543 <syscall>
  8016db:	83 c4 18             	add    $0x18,%esp
}
  8016de:	c9                   	leave  
  8016df:	c3                   	ret    

008016e0 <sys_scarce_memory>:

void sys_scarce_memory()
{
  8016e0:	55                   	push   %ebp
  8016e1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8016e3:	6a 00                	push   $0x0
  8016e5:	6a 00                	push   $0x0
  8016e7:	6a 00                	push   $0x0
  8016e9:	6a 00                	push   $0x0
  8016eb:	6a 00                	push   $0x0
  8016ed:	6a 11                	push   $0x11
  8016ef:	e8 4f fe ff ff       	call   801543 <syscall>
  8016f4:	83 c4 18             	add    $0x18,%esp
}
  8016f7:	90                   	nop
  8016f8:	c9                   	leave  
  8016f9:	c3                   	ret    

008016fa <sys_cputc>:

void
sys_cputc(const char c)
{
  8016fa:	55                   	push   %ebp
  8016fb:	89 e5                	mov    %esp,%ebp
  8016fd:	83 ec 04             	sub    $0x4,%esp
  801700:	8b 45 08             	mov    0x8(%ebp),%eax
  801703:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801706:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80170a:	6a 00                	push   $0x0
  80170c:	6a 00                	push   $0x0
  80170e:	6a 00                	push   $0x0
  801710:	6a 00                	push   $0x0
  801712:	50                   	push   %eax
  801713:	6a 01                	push   $0x1
  801715:	e8 29 fe ff ff       	call   801543 <syscall>
  80171a:	83 c4 18             	add    $0x18,%esp
}
  80171d:	90                   	nop
  80171e:	c9                   	leave  
  80171f:	c3                   	ret    

00801720 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801720:	55                   	push   %ebp
  801721:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801723:	6a 00                	push   $0x0
  801725:	6a 00                	push   $0x0
  801727:	6a 00                	push   $0x0
  801729:	6a 00                	push   $0x0
  80172b:	6a 00                	push   $0x0
  80172d:	6a 14                	push   $0x14
  80172f:	e8 0f fe ff ff       	call   801543 <syscall>
  801734:	83 c4 18             	add    $0x18,%esp
}
  801737:	90                   	nop
  801738:	c9                   	leave  
  801739:	c3                   	ret    

0080173a <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  80173a:	55                   	push   %ebp
  80173b:	89 e5                	mov    %esp,%ebp
  80173d:	83 ec 04             	sub    $0x4,%esp
  801740:	8b 45 10             	mov    0x10(%ebp),%eax
  801743:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801746:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801749:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80174d:	8b 45 08             	mov    0x8(%ebp),%eax
  801750:	6a 00                	push   $0x0
  801752:	51                   	push   %ecx
  801753:	52                   	push   %edx
  801754:	ff 75 0c             	pushl  0xc(%ebp)
  801757:	50                   	push   %eax
  801758:	6a 15                	push   $0x15
  80175a:	e8 e4 fd ff ff       	call   801543 <syscall>
  80175f:	83 c4 18             	add    $0x18,%esp
}
  801762:	c9                   	leave  
  801763:	c3                   	ret    

00801764 <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  801764:	55                   	push   %ebp
  801765:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801767:	8b 55 0c             	mov    0xc(%ebp),%edx
  80176a:	8b 45 08             	mov    0x8(%ebp),%eax
  80176d:	6a 00                	push   $0x0
  80176f:	6a 00                	push   $0x0
  801771:	6a 00                	push   $0x0
  801773:	52                   	push   %edx
  801774:	50                   	push   %eax
  801775:	6a 16                	push   $0x16
  801777:	e8 c7 fd ff ff       	call   801543 <syscall>
  80177c:	83 c4 18             	add    $0x18,%esp
}
  80177f:	c9                   	leave  
  801780:	c3                   	ret    

00801781 <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  801781:	55                   	push   %ebp
  801782:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801784:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801787:	8b 55 0c             	mov    0xc(%ebp),%edx
  80178a:	8b 45 08             	mov    0x8(%ebp),%eax
  80178d:	6a 00                	push   $0x0
  80178f:	6a 00                	push   $0x0
  801791:	51                   	push   %ecx
  801792:	52                   	push   %edx
  801793:	50                   	push   %eax
  801794:	6a 17                	push   $0x17
  801796:	e8 a8 fd ff ff       	call   801543 <syscall>
  80179b:	83 c4 18             	add    $0x18,%esp
}
  80179e:	c9                   	leave  
  80179f:	c3                   	ret    

008017a0 <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  8017a0:	55                   	push   %ebp
  8017a1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8017a3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8017a9:	6a 00                	push   $0x0
  8017ab:	6a 00                	push   $0x0
  8017ad:	6a 00                	push   $0x0
  8017af:	52                   	push   %edx
  8017b0:	50                   	push   %eax
  8017b1:	6a 18                	push   $0x18
  8017b3:	e8 8b fd ff ff       	call   801543 <syscall>
  8017b8:	83 c4 18             	add    $0x18,%esp
}
  8017bb:	c9                   	leave  
  8017bc:	c3                   	ret    

008017bd <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8017bd:	55                   	push   %ebp
  8017be:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8017c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8017c3:	6a 00                	push   $0x0
  8017c5:	ff 75 14             	pushl  0x14(%ebp)
  8017c8:	ff 75 10             	pushl  0x10(%ebp)
  8017cb:	ff 75 0c             	pushl  0xc(%ebp)
  8017ce:	50                   	push   %eax
  8017cf:	6a 19                	push   $0x19
  8017d1:	e8 6d fd ff ff       	call   801543 <syscall>
  8017d6:	83 c4 18             	add    $0x18,%esp
}
  8017d9:	c9                   	leave  
  8017da:	c3                   	ret    

008017db <sys_run_env>:

void sys_run_env(int32 envId)
{
  8017db:	55                   	push   %ebp
  8017dc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8017de:	8b 45 08             	mov    0x8(%ebp),%eax
  8017e1:	6a 00                	push   $0x0
  8017e3:	6a 00                	push   $0x0
  8017e5:	6a 00                	push   $0x0
  8017e7:	6a 00                	push   $0x0
  8017e9:	50                   	push   %eax
  8017ea:	6a 1a                	push   $0x1a
  8017ec:	e8 52 fd ff ff       	call   801543 <syscall>
  8017f1:	83 c4 18             	add    $0x18,%esp
}
  8017f4:	90                   	nop
  8017f5:	c9                   	leave  
  8017f6:	c3                   	ret    

008017f7 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8017f7:	55                   	push   %ebp
  8017f8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8017fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8017fd:	6a 00                	push   $0x0
  8017ff:	6a 00                	push   $0x0
  801801:	6a 00                	push   $0x0
  801803:	6a 00                	push   $0x0
  801805:	50                   	push   %eax
  801806:	6a 1b                	push   $0x1b
  801808:	e8 36 fd ff ff       	call   801543 <syscall>
  80180d:	83 c4 18             	add    $0x18,%esp
}
  801810:	c9                   	leave  
  801811:	c3                   	ret    

00801812 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801812:	55                   	push   %ebp
  801813:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801815:	6a 00                	push   $0x0
  801817:	6a 00                	push   $0x0
  801819:	6a 00                	push   $0x0
  80181b:	6a 00                	push   $0x0
  80181d:	6a 00                	push   $0x0
  80181f:	6a 05                	push   $0x5
  801821:	e8 1d fd ff ff       	call   801543 <syscall>
  801826:	83 c4 18             	add    $0x18,%esp
}
  801829:	c9                   	leave  
  80182a:	c3                   	ret    

0080182b <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  80182b:	55                   	push   %ebp
  80182c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  80182e:	6a 00                	push   $0x0
  801830:	6a 00                	push   $0x0
  801832:	6a 00                	push   $0x0
  801834:	6a 00                	push   $0x0
  801836:	6a 00                	push   $0x0
  801838:	6a 06                	push   $0x6
  80183a:	e8 04 fd ff ff       	call   801543 <syscall>
  80183f:	83 c4 18             	add    $0x18,%esp
}
  801842:	c9                   	leave  
  801843:	c3                   	ret    

00801844 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801844:	55                   	push   %ebp
  801845:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801847:	6a 00                	push   $0x0
  801849:	6a 00                	push   $0x0
  80184b:	6a 00                	push   $0x0
  80184d:	6a 00                	push   $0x0
  80184f:	6a 00                	push   $0x0
  801851:	6a 07                	push   $0x7
  801853:	e8 eb fc ff ff       	call   801543 <syscall>
  801858:	83 c4 18             	add    $0x18,%esp
}
  80185b:	c9                   	leave  
  80185c:	c3                   	ret    

0080185d <sys_exit_env>:


void sys_exit_env(void)
{
  80185d:	55                   	push   %ebp
  80185e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801860:	6a 00                	push   $0x0
  801862:	6a 00                	push   $0x0
  801864:	6a 00                	push   $0x0
  801866:	6a 00                	push   $0x0
  801868:	6a 00                	push   $0x0
  80186a:	6a 1c                	push   $0x1c
  80186c:	e8 d2 fc ff ff       	call   801543 <syscall>
  801871:	83 c4 18             	add    $0x18,%esp
}
  801874:	90                   	nop
  801875:	c9                   	leave  
  801876:	c3                   	ret    

00801877 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  801877:	55                   	push   %ebp
  801878:	89 e5                	mov    %esp,%ebp
  80187a:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  80187d:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801880:	8d 50 04             	lea    0x4(%eax),%edx
  801883:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801886:	6a 00                	push   $0x0
  801888:	6a 00                	push   $0x0
  80188a:	6a 00                	push   $0x0
  80188c:	52                   	push   %edx
  80188d:	50                   	push   %eax
  80188e:	6a 1d                	push   $0x1d
  801890:	e8 ae fc ff ff       	call   801543 <syscall>
  801895:	83 c4 18             	add    $0x18,%esp
	return result;
  801898:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80189b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80189e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8018a1:	89 01                	mov    %eax,(%ecx)
  8018a3:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8018a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8018a9:	c9                   	leave  
  8018aa:	c2 04 00             	ret    $0x4

008018ad <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8018ad:	55                   	push   %ebp
  8018ae:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8018b0:	6a 00                	push   $0x0
  8018b2:	6a 00                	push   $0x0
  8018b4:	ff 75 10             	pushl  0x10(%ebp)
  8018b7:	ff 75 0c             	pushl  0xc(%ebp)
  8018ba:	ff 75 08             	pushl  0x8(%ebp)
  8018bd:	6a 13                	push   $0x13
  8018bf:	e8 7f fc ff ff       	call   801543 <syscall>
  8018c4:	83 c4 18             	add    $0x18,%esp
	return ;
  8018c7:	90                   	nop
}
  8018c8:	c9                   	leave  
  8018c9:	c3                   	ret    

008018ca <sys_rcr2>:
uint32 sys_rcr2()
{
  8018ca:	55                   	push   %ebp
  8018cb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8018cd:	6a 00                	push   $0x0
  8018cf:	6a 00                	push   $0x0
  8018d1:	6a 00                	push   $0x0
  8018d3:	6a 00                	push   $0x0
  8018d5:	6a 00                	push   $0x0
  8018d7:	6a 1e                	push   $0x1e
  8018d9:	e8 65 fc ff ff       	call   801543 <syscall>
  8018de:	83 c4 18             	add    $0x18,%esp
}
  8018e1:	c9                   	leave  
  8018e2:	c3                   	ret    

008018e3 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  8018e3:	55                   	push   %ebp
  8018e4:	89 e5                	mov    %esp,%ebp
  8018e6:	83 ec 04             	sub    $0x4,%esp
  8018e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8018ec:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8018ef:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8018f3:	6a 00                	push   $0x0
  8018f5:	6a 00                	push   $0x0
  8018f7:	6a 00                	push   $0x0
  8018f9:	6a 00                	push   $0x0
  8018fb:	50                   	push   %eax
  8018fc:	6a 1f                	push   $0x1f
  8018fe:	e8 40 fc ff ff       	call   801543 <syscall>
  801903:	83 c4 18             	add    $0x18,%esp
	return ;
  801906:	90                   	nop
}
  801907:	c9                   	leave  
  801908:	c3                   	ret    

00801909 <rsttst>:
void rsttst()
{
  801909:	55                   	push   %ebp
  80190a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  80190c:	6a 00                	push   $0x0
  80190e:	6a 00                	push   $0x0
  801910:	6a 00                	push   $0x0
  801912:	6a 00                	push   $0x0
  801914:	6a 00                	push   $0x0
  801916:	6a 21                	push   $0x21
  801918:	e8 26 fc ff ff       	call   801543 <syscall>
  80191d:	83 c4 18             	add    $0x18,%esp
	return ;
  801920:	90                   	nop
}
  801921:	c9                   	leave  
  801922:	c3                   	ret    

00801923 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801923:	55                   	push   %ebp
  801924:	89 e5                	mov    %esp,%ebp
  801926:	83 ec 04             	sub    $0x4,%esp
  801929:	8b 45 14             	mov    0x14(%ebp),%eax
  80192c:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  80192f:	8b 55 18             	mov    0x18(%ebp),%edx
  801932:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801936:	52                   	push   %edx
  801937:	50                   	push   %eax
  801938:	ff 75 10             	pushl  0x10(%ebp)
  80193b:	ff 75 0c             	pushl  0xc(%ebp)
  80193e:	ff 75 08             	pushl  0x8(%ebp)
  801941:	6a 20                	push   $0x20
  801943:	e8 fb fb ff ff       	call   801543 <syscall>
  801948:	83 c4 18             	add    $0x18,%esp
	return ;
  80194b:	90                   	nop
}
  80194c:	c9                   	leave  
  80194d:	c3                   	ret    

0080194e <chktst>:
void chktst(uint32 n)
{
  80194e:	55                   	push   %ebp
  80194f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801951:	6a 00                	push   $0x0
  801953:	6a 00                	push   $0x0
  801955:	6a 00                	push   $0x0
  801957:	6a 00                	push   $0x0
  801959:	ff 75 08             	pushl  0x8(%ebp)
  80195c:	6a 22                	push   $0x22
  80195e:	e8 e0 fb ff ff       	call   801543 <syscall>
  801963:	83 c4 18             	add    $0x18,%esp
	return ;
  801966:	90                   	nop
}
  801967:	c9                   	leave  
  801968:	c3                   	ret    

00801969 <inctst>:

void inctst()
{
  801969:	55                   	push   %ebp
  80196a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  80196c:	6a 00                	push   $0x0
  80196e:	6a 00                	push   $0x0
  801970:	6a 00                	push   $0x0
  801972:	6a 00                	push   $0x0
  801974:	6a 00                	push   $0x0
  801976:	6a 23                	push   $0x23
  801978:	e8 c6 fb ff ff       	call   801543 <syscall>
  80197d:	83 c4 18             	add    $0x18,%esp
	return ;
  801980:	90                   	nop
}
  801981:	c9                   	leave  
  801982:	c3                   	ret    

00801983 <gettst>:
uint32 gettst()
{
  801983:	55                   	push   %ebp
  801984:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801986:	6a 00                	push   $0x0
  801988:	6a 00                	push   $0x0
  80198a:	6a 00                	push   $0x0
  80198c:	6a 00                	push   $0x0
  80198e:	6a 00                	push   $0x0
  801990:	6a 24                	push   $0x24
  801992:	e8 ac fb ff ff       	call   801543 <syscall>
  801997:	83 c4 18             	add    $0x18,%esp
}
  80199a:	c9                   	leave  
  80199b:	c3                   	ret    

0080199c <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  80199c:	55                   	push   %ebp
  80199d:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80199f:	6a 00                	push   $0x0
  8019a1:	6a 00                	push   $0x0
  8019a3:	6a 00                	push   $0x0
  8019a5:	6a 00                	push   $0x0
  8019a7:	6a 00                	push   $0x0
  8019a9:	6a 25                	push   $0x25
  8019ab:	e8 93 fb ff ff       	call   801543 <syscall>
  8019b0:	83 c4 18             	add    $0x18,%esp
  8019b3:	a3 00 71 82 00       	mov    %eax,0x827100
	return uheapPlaceStrategy ;
  8019b8:	a1 00 71 82 00       	mov    0x827100,%eax
}
  8019bd:	c9                   	leave  
  8019be:	c3                   	ret    

008019bf <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  8019bf:	55                   	push   %ebp
  8019c0:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  8019c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8019c5:	a3 00 71 82 00       	mov    %eax,0x827100
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  8019ca:	6a 00                	push   $0x0
  8019cc:	6a 00                	push   $0x0
  8019ce:	6a 00                	push   $0x0
  8019d0:	6a 00                	push   $0x0
  8019d2:	ff 75 08             	pushl  0x8(%ebp)
  8019d5:	6a 26                	push   $0x26
  8019d7:	e8 67 fb ff ff       	call   801543 <syscall>
  8019dc:	83 c4 18             	add    $0x18,%esp
	return ;
  8019df:	90                   	nop
}
  8019e0:	c9                   	leave  
  8019e1:	c3                   	ret    

008019e2 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  8019e2:	55                   	push   %ebp
  8019e3:	89 e5                	mov    %esp,%ebp
  8019e5:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  8019e6:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8019e9:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8019ec:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8019f2:	6a 00                	push   $0x0
  8019f4:	53                   	push   %ebx
  8019f5:	51                   	push   %ecx
  8019f6:	52                   	push   %edx
  8019f7:	50                   	push   %eax
  8019f8:	6a 27                	push   $0x27
  8019fa:	e8 44 fb ff ff       	call   801543 <syscall>
  8019ff:	83 c4 18             	add    $0x18,%esp
}
  801a02:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a05:	c9                   	leave  
  801a06:	c3                   	ret    

00801a07 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801a07:	55                   	push   %ebp
  801a08:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801a0a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a0d:	8b 45 08             	mov    0x8(%ebp),%eax
  801a10:	6a 00                	push   $0x0
  801a12:	6a 00                	push   $0x0
  801a14:	6a 00                	push   $0x0
  801a16:	52                   	push   %edx
  801a17:	50                   	push   %eax
  801a18:	6a 28                	push   $0x28
  801a1a:	e8 24 fb ff ff       	call   801543 <syscall>
  801a1f:	83 c4 18             	add    $0x18,%esp
}
  801a22:	c9                   	leave  
  801a23:	c3                   	ret    

00801a24 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801a24:	55                   	push   %ebp
  801a25:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801a27:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801a2a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a2d:	8b 45 08             	mov    0x8(%ebp),%eax
  801a30:	6a 00                	push   $0x0
  801a32:	51                   	push   %ecx
  801a33:	ff 75 10             	pushl  0x10(%ebp)
  801a36:	52                   	push   %edx
  801a37:	50                   	push   %eax
  801a38:	6a 29                	push   $0x29
  801a3a:	e8 04 fb ff ff       	call   801543 <syscall>
  801a3f:	83 c4 18             	add    $0x18,%esp
}
  801a42:	c9                   	leave  
  801a43:	c3                   	ret    

00801a44 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801a44:	55                   	push   %ebp
  801a45:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801a47:	6a 00                	push   $0x0
  801a49:	6a 00                	push   $0x0
  801a4b:	ff 75 10             	pushl  0x10(%ebp)
  801a4e:	ff 75 0c             	pushl  0xc(%ebp)
  801a51:	ff 75 08             	pushl  0x8(%ebp)
  801a54:	6a 12                	push   $0x12
  801a56:	e8 e8 fa ff ff       	call   801543 <syscall>
  801a5b:	83 c4 18             	add    $0x18,%esp
	return ;
  801a5e:	90                   	nop
}
  801a5f:	c9                   	leave  
  801a60:	c3                   	ret    

00801a61 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  801a61:	55                   	push   %ebp
  801a62:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  801a64:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a67:	8b 45 08             	mov    0x8(%ebp),%eax
  801a6a:	6a 00                	push   $0x0
  801a6c:	6a 00                	push   $0x0
  801a6e:	6a 00                	push   $0x0
  801a70:	52                   	push   %edx
  801a71:	50                   	push   %eax
  801a72:	6a 2a                	push   $0x2a
  801a74:	e8 ca fa ff ff       	call   801543 <syscall>
  801a79:	83 c4 18             	add    $0x18,%esp
	return;
  801a7c:	90                   	nop
}
  801a7d:	c9                   	leave  
  801a7e:	c3                   	ret    

00801a7f <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  801a7f:	55                   	push   %ebp
  801a80:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  801a82:	6a 00                	push   $0x0
  801a84:	6a 00                	push   $0x0
  801a86:	6a 00                	push   $0x0
  801a88:	6a 00                	push   $0x0
  801a8a:	6a 00                	push   $0x0
  801a8c:	6a 2b                	push   $0x2b
  801a8e:	e8 b0 fa ff ff       	call   801543 <syscall>
  801a93:	83 c4 18             	add    $0x18,%esp
}
  801a96:	c9                   	leave  
  801a97:	c3                   	ret    

00801a98 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801a98:	55                   	push   %ebp
  801a99:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801a9b:	6a 00                	push   $0x0
  801a9d:	6a 00                	push   $0x0
  801a9f:	6a 00                	push   $0x0
  801aa1:	ff 75 0c             	pushl  0xc(%ebp)
  801aa4:	ff 75 08             	pushl  0x8(%ebp)
  801aa7:	6a 2d                	push   $0x2d
  801aa9:	e8 95 fa ff ff       	call   801543 <syscall>
  801aae:	83 c4 18             	add    $0x18,%esp
	return;
  801ab1:	90                   	nop
}
  801ab2:	c9                   	leave  
  801ab3:	c3                   	ret    

00801ab4 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801ab4:	55                   	push   %ebp
  801ab5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801ab7:	6a 00                	push   $0x0
  801ab9:	6a 00                	push   $0x0
  801abb:	6a 00                	push   $0x0
  801abd:	ff 75 0c             	pushl  0xc(%ebp)
  801ac0:	ff 75 08             	pushl  0x8(%ebp)
  801ac3:	6a 2c                	push   $0x2c
  801ac5:	e8 79 fa ff ff       	call   801543 <syscall>
  801aca:	83 c4 18             	add    $0x18,%esp
	return ;
  801acd:	90                   	nop
}
  801ace:	c9                   	leave  
  801acf:	c3                   	ret    

00801ad0 <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  801ad0:	55                   	push   %ebp
  801ad1:	89 e5                	mov    %esp,%ebp
	//TODO: [PROJECT'25.IM#4] CPU SCHEDULING - #1 System Calls - Add suitable code here
	//Your code is here
	//Comment the following line
	//panic("sys_env_set_priority() is not implemented yet...!!");
	syscall(SYS_env_set_priority, envID, priority, 0, 0, 0);
  801ad3:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ad6:	8b 45 08             	mov    0x8(%ebp),%eax
  801ad9:	6a 00                	push   $0x0
  801adb:	6a 00                	push   $0x0
  801add:	6a 00                	push   $0x0
  801adf:	52                   	push   %edx
  801ae0:	50                   	push   %eax
  801ae1:	6a 2e                	push   $0x2e
  801ae3:	e8 5b fa ff ff       	call   801543 <syscall>
  801ae8:	83 c4 18             	add    $0x18,%esp
	    return;
  801aeb:	90                   	nop
}
  801aec:	c9                   	leave  
  801aed:	c3                   	ret    
  801aee:	66 90                	xchg   %ax,%ax

00801af0 <__udivdi3>:
  801af0:	55                   	push   %ebp
  801af1:	57                   	push   %edi
  801af2:	56                   	push   %esi
  801af3:	53                   	push   %ebx
  801af4:	83 ec 1c             	sub    $0x1c,%esp
  801af7:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801afb:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801aff:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801b03:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801b07:	89 ca                	mov    %ecx,%edx
  801b09:	89 f8                	mov    %edi,%eax
  801b0b:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801b0f:	85 f6                	test   %esi,%esi
  801b11:	75 2d                	jne    801b40 <__udivdi3+0x50>
  801b13:	39 cf                	cmp    %ecx,%edi
  801b15:	77 65                	ja     801b7c <__udivdi3+0x8c>
  801b17:	89 fd                	mov    %edi,%ebp
  801b19:	85 ff                	test   %edi,%edi
  801b1b:	75 0b                	jne    801b28 <__udivdi3+0x38>
  801b1d:	b8 01 00 00 00       	mov    $0x1,%eax
  801b22:	31 d2                	xor    %edx,%edx
  801b24:	f7 f7                	div    %edi
  801b26:	89 c5                	mov    %eax,%ebp
  801b28:	31 d2                	xor    %edx,%edx
  801b2a:	89 c8                	mov    %ecx,%eax
  801b2c:	f7 f5                	div    %ebp
  801b2e:	89 c1                	mov    %eax,%ecx
  801b30:	89 d8                	mov    %ebx,%eax
  801b32:	f7 f5                	div    %ebp
  801b34:	89 cf                	mov    %ecx,%edi
  801b36:	89 fa                	mov    %edi,%edx
  801b38:	83 c4 1c             	add    $0x1c,%esp
  801b3b:	5b                   	pop    %ebx
  801b3c:	5e                   	pop    %esi
  801b3d:	5f                   	pop    %edi
  801b3e:	5d                   	pop    %ebp
  801b3f:	c3                   	ret    
  801b40:	39 ce                	cmp    %ecx,%esi
  801b42:	77 28                	ja     801b6c <__udivdi3+0x7c>
  801b44:	0f bd fe             	bsr    %esi,%edi
  801b47:	83 f7 1f             	xor    $0x1f,%edi
  801b4a:	75 40                	jne    801b8c <__udivdi3+0x9c>
  801b4c:	39 ce                	cmp    %ecx,%esi
  801b4e:	72 0a                	jb     801b5a <__udivdi3+0x6a>
  801b50:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801b54:	0f 87 9e 00 00 00    	ja     801bf8 <__udivdi3+0x108>
  801b5a:	b8 01 00 00 00       	mov    $0x1,%eax
  801b5f:	89 fa                	mov    %edi,%edx
  801b61:	83 c4 1c             	add    $0x1c,%esp
  801b64:	5b                   	pop    %ebx
  801b65:	5e                   	pop    %esi
  801b66:	5f                   	pop    %edi
  801b67:	5d                   	pop    %ebp
  801b68:	c3                   	ret    
  801b69:	8d 76 00             	lea    0x0(%esi),%esi
  801b6c:	31 ff                	xor    %edi,%edi
  801b6e:	31 c0                	xor    %eax,%eax
  801b70:	89 fa                	mov    %edi,%edx
  801b72:	83 c4 1c             	add    $0x1c,%esp
  801b75:	5b                   	pop    %ebx
  801b76:	5e                   	pop    %esi
  801b77:	5f                   	pop    %edi
  801b78:	5d                   	pop    %ebp
  801b79:	c3                   	ret    
  801b7a:	66 90                	xchg   %ax,%ax
  801b7c:	89 d8                	mov    %ebx,%eax
  801b7e:	f7 f7                	div    %edi
  801b80:	31 ff                	xor    %edi,%edi
  801b82:	89 fa                	mov    %edi,%edx
  801b84:	83 c4 1c             	add    $0x1c,%esp
  801b87:	5b                   	pop    %ebx
  801b88:	5e                   	pop    %esi
  801b89:	5f                   	pop    %edi
  801b8a:	5d                   	pop    %ebp
  801b8b:	c3                   	ret    
  801b8c:	bd 20 00 00 00       	mov    $0x20,%ebp
  801b91:	89 eb                	mov    %ebp,%ebx
  801b93:	29 fb                	sub    %edi,%ebx
  801b95:	89 f9                	mov    %edi,%ecx
  801b97:	d3 e6                	shl    %cl,%esi
  801b99:	89 c5                	mov    %eax,%ebp
  801b9b:	88 d9                	mov    %bl,%cl
  801b9d:	d3 ed                	shr    %cl,%ebp
  801b9f:	89 e9                	mov    %ebp,%ecx
  801ba1:	09 f1                	or     %esi,%ecx
  801ba3:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801ba7:	89 f9                	mov    %edi,%ecx
  801ba9:	d3 e0                	shl    %cl,%eax
  801bab:	89 c5                	mov    %eax,%ebp
  801bad:	89 d6                	mov    %edx,%esi
  801baf:	88 d9                	mov    %bl,%cl
  801bb1:	d3 ee                	shr    %cl,%esi
  801bb3:	89 f9                	mov    %edi,%ecx
  801bb5:	d3 e2                	shl    %cl,%edx
  801bb7:	8b 44 24 08          	mov    0x8(%esp),%eax
  801bbb:	88 d9                	mov    %bl,%cl
  801bbd:	d3 e8                	shr    %cl,%eax
  801bbf:	09 c2                	or     %eax,%edx
  801bc1:	89 d0                	mov    %edx,%eax
  801bc3:	89 f2                	mov    %esi,%edx
  801bc5:	f7 74 24 0c          	divl   0xc(%esp)
  801bc9:	89 d6                	mov    %edx,%esi
  801bcb:	89 c3                	mov    %eax,%ebx
  801bcd:	f7 e5                	mul    %ebp
  801bcf:	39 d6                	cmp    %edx,%esi
  801bd1:	72 19                	jb     801bec <__udivdi3+0xfc>
  801bd3:	74 0b                	je     801be0 <__udivdi3+0xf0>
  801bd5:	89 d8                	mov    %ebx,%eax
  801bd7:	31 ff                	xor    %edi,%edi
  801bd9:	e9 58 ff ff ff       	jmp    801b36 <__udivdi3+0x46>
  801bde:	66 90                	xchg   %ax,%ax
  801be0:	8b 54 24 08          	mov    0x8(%esp),%edx
  801be4:	89 f9                	mov    %edi,%ecx
  801be6:	d3 e2                	shl    %cl,%edx
  801be8:	39 c2                	cmp    %eax,%edx
  801bea:	73 e9                	jae    801bd5 <__udivdi3+0xe5>
  801bec:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801bef:	31 ff                	xor    %edi,%edi
  801bf1:	e9 40 ff ff ff       	jmp    801b36 <__udivdi3+0x46>
  801bf6:	66 90                	xchg   %ax,%ax
  801bf8:	31 c0                	xor    %eax,%eax
  801bfa:	e9 37 ff ff ff       	jmp    801b36 <__udivdi3+0x46>
  801bff:	90                   	nop

00801c00 <__umoddi3>:
  801c00:	55                   	push   %ebp
  801c01:	57                   	push   %edi
  801c02:	56                   	push   %esi
  801c03:	53                   	push   %ebx
  801c04:	83 ec 1c             	sub    $0x1c,%esp
  801c07:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801c0b:	8b 74 24 34          	mov    0x34(%esp),%esi
  801c0f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801c13:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801c17:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801c1b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801c1f:	89 f3                	mov    %esi,%ebx
  801c21:	89 fa                	mov    %edi,%edx
  801c23:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801c27:	89 34 24             	mov    %esi,(%esp)
  801c2a:	85 c0                	test   %eax,%eax
  801c2c:	75 1a                	jne    801c48 <__umoddi3+0x48>
  801c2e:	39 f7                	cmp    %esi,%edi
  801c30:	0f 86 a2 00 00 00    	jbe    801cd8 <__umoddi3+0xd8>
  801c36:	89 c8                	mov    %ecx,%eax
  801c38:	89 f2                	mov    %esi,%edx
  801c3a:	f7 f7                	div    %edi
  801c3c:	89 d0                	mov    %edx,%eax
  801c3e:	31 d2                	xor    %edx,%edx
  801c40:	83 c4 1c             	add    $0x1c,%esp
  801c43:	5b                   	pop    %ebx
  801c44:	5e                   	pop    %esi
  801c45:	5f                   	pop    %edi
  801c46:	5d                   	pop    %ebp
  801c47:	c3                   	ret    
  801c48:	39 f0                	cmp    %esi,%eax
  801c4a:	0f 87 ac 00 00 00    	ja     801cfc <__umoddi3+0xfc>
  801c50:	0f bd e8             	bsr    %eax,%ebp
  801c53:	83 f5 1f             	xor    $0x1f,%ebp
  801c56:	0f 84 ac 00 00 00    	je     801d08 <__umoddi3+0x108>
  801c5c:	bf 20 00 00 00       	mov    $0x20,%edi
  801c61:	29 ef                	sub    %ebp,%edi
  801c63:	89 fe                	mov    %edi,%esi
  801c65:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801c69:	89 e9                	mov    %ebp,%ecx
  801c6b:	d3 e0                	shl    %cl,%eax
  801c6d:	89 d7                	mov    %edx,%edi
  801c6f:	89 f1                	mov    %esi,%ecx
  801c71:	d3 ef                	shr    %cl,%edi
  801c73:	09 c7                	or     %eax,%edi
  801c75:	89 e9                	mov    %ebp,%ecx
  801c77:	d3 e2                	shl    %cl,%edx
  801c79:	89 14 24             	mov    %edx,(%esp)
  801c7c:	89 d8                	mov    %ebx,%eax
  801c7e:	d3 e0                	shl    %cl,%eax
  801c80:	89 c2                	mov    %eax,%edx
  801c82:	8b 44 24 08          	mov    0x8(%esp),%eax
  801c86:	d3 e0                	shl    %cl,%eax
  801c88:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c8c:	8b 44 24 08          	mov    0x8(%esp),%eax
  801c90:	89 f1                	mov    %esi,%ecx
  801c92:	d3 e8                	shr    %cl,%eax
  801c94:	09 d0                	or     %edx,%eax
  801c96:	d3 eb                	shr    %cl,%ebx
  801c98:	89 da                	mov    %ebx,%edx
  801c9a:	f7 f7                	div    %edi
  801c9c:	89 d3                	mov    %edx,%ebx
  801c9e:	f7 24 24             	mull   (%esp)
  801ca1:	89 c6                	mov    %eax,%esi
  801ca3:	89 d1                	mov    %edx,%ecx
  801ca5:	39 d3                	cmp    %edx,%ebx
  801ca7:	0f 82 87 00 00 00    	jb     801d34 <__umoddi3+0x134>
  801cad:	0f 84 91 00 00 00    	je     801d44 <__umoddi3+0x144>
  801cb3:	8b 54 24 04          	mov    0x4(%esp),%edx
  801cb7:	29 f2                	sub    %esi,%edx
  801cb9:	19 cb                	sbb    %ecx,%ebx
  801cbb:	89 d8                	mov    %ebx,%eax
  801cbd:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801cc1:	d3 e0                	shl    %cl,%eax
  801cc3:	89 e9                	mov    %ebp,%ecx
  801cc5:	d3 ea                	shr    %cl,%edx
  801cc7:	09 d0                	or     %edx,%eax
  801cc9:	89 e9                	mov    %ebp,%ecx
  801ccb:	d3 eb                	shr    %cl,%ebx
  801ccd:	89 da                	mov    %ebx,%edx
  801ccf:	83 c4 1c             	add    $0x1c,%esp
  801cd2:	5b                   	pop    %ebx
  801cd3:	5e                   	pop    %esi
  801cd4:	5f                   	pop    %edi
  801cd5:	5d                   	pop    %ebp
  801cd6:	c3                   	ret    
  801cd7:	90                   	nop
  801cd8:	89 fd                	mov    %edi,%ebp
  801cda:	85 ff                	test   %edi,%edi
  801cdc:	75 0b                	jne    801ce9 <__umoddi3+0xe9>
  801cde:	b8 01 00 00 00       	mov    $0x1,%eax
  801ce3:	31 d2                	xor    %edx,%edx
  801ce5:	f7 f7                	div    %edi
  801ce7:	89 c5                	mov    %eax,%ebp
  801ce9:	89 f0                	mov    %esi,%eax
  801ceb:	31 d2                	xor    %edx,%edx
  801ced:	f7 f5                	div    %ebp
  801cef:	89 c8                	mov    %ecx,%eax
  801cf1:	f7 f5                	div    %ebp
  801cf3:	89 d0                	mov    %edx,%eax
  801cf5:	e9 44 ff ff ff       	jmp    801c3e <__umoddi3+0x3e>
  801cfa:	66 90                	xchg   %ax,%ax
  801cfc:	89 c8                	mov    %ecx,%eax
  801cfe:	89 f2                	mov    %esi,%edx
  801d00:	83 c4 1c             	add    $0x1c,%esp
  801d03:	5b                   	pop    %ebx
  801d04:	5e                   	pop    %esi
  801d05:	5f                   	pop    %edi
  801d06:	5d                   	pop    %ebp
  801d07:	c3                   	ret    
  801d08:	3b 04 24             	cmp    (%esp),%eax
  801d0b:	72 06                	jb     801d13 <__umoddi3+0x113>
  801d0d:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801d11:	77 0f                	ja     801d22 <__umoddi3+0x122>
  801d13:	89 f2                	mov    %esi,%edx
  801d15:	29 f9                	sub    %edi,%ecx
  801d17:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801d1b:	89 14 24             	mov    %edx,(%esp)
  801d1e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801d22:	8b 44 24 04          	mov    0x4(%esp),%eax
  801d26:	8b 14 24             	mov    (%esp),%edx
  801d29:	83 c4 1c             	add    $0x1c,%esp
  801d2c:	5b                   	pop    %ebx
  801d2d:	5e                   	pop    %esi
  801d2e:	5f                   	pop    %edi
  801d2f:	5d                   	pop    %ebp
  801d30:	c3                   	ret    
  801d31:	8d 76 00             	lea    0x0(%esi),%esi
  801d34:	2b 04 24             	sub    (%esp),%eax
  801d37:	19 fa                	sbb    %edi,%edx
  801d39:	89 d1                	mov    %edx,%ecx
  801d3b:	89 c6                	mov    %eax,%esi
  801d3d:	e9 71 ff ff ff       	jmp    801cb3 <__umoddi3+0xb3>
  801d42:	66 90                	xchg   %ax,%ax
  801d44:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801d48:	72 ea                	jb     801d34 <__umoddi3+0x134>
  801d4a:	89 d9                	mov    %ebx,%ecx
  801d4c:	e9 62 ff ff ff       	jmp    801cb3 <__umoddi3+0xb3>
