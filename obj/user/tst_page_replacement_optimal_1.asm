
obj/user/tst_page_replacement_optimal_1:     file format elf32-i386


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
  800031:	e8 99 02 00 00       	call   8002cf <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
		0x806000, 0x807000, 0x808000, 0x800000, 0x803000, 0x801000, 0xeebfd000, 0x804000, 0x809000,
		0x80a000, 0x80b000, 0x80c000, 0x827000, 0x802000, 0x800000, 0x803000, 0xeebfd000, 0x801000,
		0x827000
} ;
void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	57                   	push   %edi
  80003c:	56                   	push   %esi
  80003d:	53                   	push   %ebx
  80003e:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
	//("STEP 0: checking Initial WS entries ...\n");
	bool found ;

#if USE_KHEAP
	{
		found = sys_check_WS_list(expectedInitialVAs, 11, 0x800000, 1);
  800044:	6a 01                	push   $0x1
  800046:	68 00 00 80 00       	push   $0x800000
  80004b:	6a 0b                	push   $0xb
  80004d:	68 20 30 80 00       	push   $0x803020
  800052:	e8 c5 1a 00 00       	call   801b1c <sys_check_WS_list>
  800057:	83 c4 10             	add    $0x10,%esp
  80005a:	89 45 cc             	mov    %eax,-0x34(%ebp)
		if (found != 1) panic("INITIAL PAGE WS entry checking failed! Review size of the WS!!\n*****IF CORRECT, CHECK THE ISSUE WITH THE STAFF*****");
  80005d:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800060:	83 f8 01             	cmp    $0x1,%eax
  800063:	74 14                	je     800079 <_main+0x41>
  800065:	83 ec 04             	sub    $0x4,%esp
  800068:	68 60 1e 80 00       	push   $0x801e60
  80006d:	6a 1e                	push   $0x1e
  80006f:	68 d4 1e 80 00       	push   $0x801ed4
  800074:	e8 0f 04 00 00       	call   800488 <_panic>
	}
#else
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif

	int freePages = sys_calculate_free_frames();
  800079:	e8 dc 16 00 00       	call   80175a <sys_calculate_free_frames>
  80007e:	89 45 e0             	mov    %eax,-0x20(%ebp)
	int usedDiskPages = sys_pf_calculate_allocated_pages();
  800081:	e8 1f 17 00 00       	call   8017a5 <sys_pf_calculate_allocated_pages>
  800086:	89 45 dc             	mov    %eax,-0x24(%ebp)

	//Writing (Modified)
	__arr__[PAGE_SIZE*10-1] = 'a' ;
  800089:	c6 05 1f d1 80 00 61 	movb   $0x61,0x80d11f

	//Reading (Not Modified)
	char garbage1 = __arr__[PAGE_SIZE*11-1] ;
  800090:	a0 1f e1 80 00       	mov    0x80e11f,%al
  800095:	88 45 db             	mov    %al,-0x25(%ebp)
	char garbage2 = __arr__[PAGE_SIZE*12-1] ;
  800098:	a0 1f f1 80 00       	mov    0x80f11f,%al
  80009d:	88 45 da             	mov    %al,-0x26(%ebp)
	char garbage4,garbage5;

	//Writing (Modified)
	int i ;
	for (i = 0 ; i < PAGE_SIZE*10 ; i+=PAGE_SIZE/2)
  8000a0:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  8000a7:	eb 26                	jmp    8000cf <_main+0x97>
	{
		__arr__[i] = -1 ;
  8000a9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8000ac:	05 20 31 80 00       	add    $0x803120,%eax
  8000b1:	c6 00 ff             	movb   $0xff,(%eax)
		/*2016: this BUGGY line is REMOVED el7! it overwrites the KERNEL CODE :( !!!*/
		//*ptr = *ptr2 ;
		/*==========================================================================*/
		//always use pages at 0x801000 and 0x804000
		garbage4 = *__ptr__ ;
  8000b4:	a1 00 30 80 00       	mov    0x803000,%eax
  8000b9:	8a 00                	mov    (%eax),%al
  8000bb:	88 45 d9             	mov    %al,-0x27(%ebp)
		garbage5 = *__ptr2__ ;
  8000be:	a1 04 30 80 00       	mov    0x803004,%eax
  8000c3:	8a 00                	mov    (%eax),%al
  8000c5:	88 45 d8             	mov    %al,-0x28(%ebp)
	char garbage2 = __arr__[PAGE_SIZE*12-1] ;
	char garbage4,garbage5;

	//Writing (Modified)
	int i ;
	for (i = 0 ; i < PAGE_SIZE*10 ; i+=PAGE_SIZE/2)
  8000c8:	81 45 e4 00 08 00 00 	addl   $0x800,-0x1c(%ebp)
  8000cf:	81 7d e4 ff 9f 00 00 	cmpl   $0x9fff,-0x1c(%ebp)
  8000d6:	7e d1                	jle    8000a9 <_main+0x71>
		garbage5 = *__ptr2__ ;
	}

	//===================

	cprintf_colored(TEXT_cyan, "%~\nChecking INITIAL WS... \n");
  8000d8:	83 ec 08             	sub    $0x8,%esp
  8000db:	68 fa 1e 80 00       	push   $0x801efa
  8000e0:	6a 03                	push   $0x3
  8000e2:	e8 9c 06 00 00       	call   800783 <cprintf_colored>
  8000e7:	83 c4 10             	add    $0x10,%esp
	{
		found = sys_check_WS_list(expectedInitialVAs, 11, 0x800000, 1);
  8000ea:	6a 01                	push   $0x1
  8000ec:	68 00 00 80 00       	push   $0x800000
  8000f1:	6a 0b                	push   $0xb
  8000f3:	68 20 30 80 00       	push   $0x803020
  8000f8:	e8 1f 1a 00 00       	call   801b1c <sys_check_WS_list>
  8000fd:	83 c4 10             	add    $0x10,%esp
  800100:	89 45 cc             	mov    %eax,-0x34(%ebp)
		if (found != 1) panic("OPTIMAL alg. failed.. the initial working set is changed while it's not expected to");
  800103:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800106:	83 f8 01             	cmp    $0x1,%eax
  800109:	74 14                	je     80011f <_main+0xe7>
  80010b:	83 ec 04             	sub    $0x4,%esp
  80010e:	68 18 1f 80 00       	push   $0x801f18
  800113:	6a 41                	push   $0x41
  800115:	68 d4 1e 80 00       	push   $0x801ed4
  80011a:	e8 69 03 00 00       	call   800488 <_panic>
	}
	cprintf_colored(TEXT_cyan, "%~\nChecking EXPECTED REFERENCE STREAM... \n");
  80011f:	83 ec 08             	sub    $0x8,%esp
  800122:	68 6c 1f 80 00       	push   $0x801f6c
  800127:	6a 03                	push   $0x3
  800129:	e8 55 06 00 00       	call   800783 <cprintf_colored>
  80012e:	83 c4 10             	add    $0x10,%esp
	{
		char separator[2] = "@";
  800131:	66 c7 45 ca 40 00    	movw   $0x40,-0x36(%ebp)
		char checkRefStreamCmd[100] = "__CheckRefStream@";
  800137:	8d 85 ee fe ff ff    	lea    -0x112(%ebp),%eax
  80013d:	bb 25 21 80 00       	mov    $0x802125,%ebx
  800142:	ba 12 00 00 00       	mov    $0x12,%edx
  800147:	89 c7                	mov    %eax,%edi
  800149:	89 de                	mov    %ebx,%esi
  80014b:	89 d1                	mov    %edx,%ecx
  80014d:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  80014f:	8d 95 00 ff ff ff    	lea    -0x100(%ebp),%edx
  800155:	b9 52 00 00 00       	mov    $0x52,%ecx
  80015a:	b0 00                	mov    $0x0,%al
  80015c:	89 d7                	mov    %edx,%edi
  80015e:	f3 aa                	rep stos %al,%es:(%edi)
		char token[20] ;
		char cmdWithCnt[100] ;
		ltostr(EXPECTED_REF_CNT, token);
  800160:	83 ec 08             	sub    $0x8,%esp
  800163:	8d 45 b6             	lea    -0x4a(%ebp),%eax
  800166:	50                   	push   %eax
  800167:	6a 1c                	push   $0x1c
  800169:	e8 16 12 00 00       	call   801384 <ltostr>
  80016e:	83 c4 10             	add    $0x10,%esp
		strcconcat(checkRefStreamCmd, token, cmdWithCnt);
  800171:	83 ec 04             	sub    $0x4,%esp
  800174:	8d 85 52 ff ff ff    	lea    -0xae(%ebp),%eax
  80017a:	50                   	push   %eax
  80017b:	8d 45 b6             	lea    -0x4a(%ebp),%eax
  80017e:	50                   	push   %eax
  80017f:	8d 85 ee fe ff ff    	lea    -0x112(%ebp),%eax
  800185:	50                   	push   %eax
  800186:	e8 d2 12 00 00       	call   80145d <strcconcat>
  80018b:	83 c4 10             	add    $0x10,%esp
		strcconcat(cmdWithCnt, separator, cmdWithCnt);
  80018e:	83 ec 04             	sub    $0x4,%esp
  800191:	8d 85 52 ff ff ff    	lea    -0xae(%ebp),%eax
  800197:	50                   	push   %eax
  800198:	8d 45 ca             	lea    -0x36(%ebp),%eax
  80019b:	50                   	push   %eax
  80019c:	8d 85 52 ff ff ff    	lea    -0xae(%ebp),%eax
  8001a2:	50                   	push   %eax
  8001a3:	e8 b5 12 00 00       	call   80145d <strcconcat>
  8001a8:	83 c4 10             	add    $0x10,%esp
		ltostr((uint32)&expectedRefStream, token);
  8001ab:	ba 60 30 80 00       	mov    $0x803060,%edx
  8001b0:	83 ec 08             	sub    $0x8,%esp
  8001b3:	8d 45 b6             	lea    -0x4a(%ebp),%eax
  8001b6:	50                   	push   %eax
  8001b7:	52                   	push   %edx
  8001b8:	e8 c7 11 00 00       	call   801384 <ltostr>
  8001bd:	83 c4 10             	add    $0x10,%esp
		strcconcat(cmdWithCnt, token, cmdWithCnt);
  8001c0:	83 ec 04             	sub    $0x4,%esp
  8001c3:	8d 85 52 ff ff ff    	lea    -0xae(%ebp),%eax
  8001c9:	50                   	push   %eax
  8001ca:	8d 45 b6             	lea    -0x4a(%ebp),%eax
  8001cd:	50                   	push   %eax
  8001ce:	8d 85 52 ff ff ff    	lea    -0xae(%ebp),%eax
  8001d4:	50                   	push   %eax
  8001d5:	e8 83 12 00 00       	call   80145d <strcconcat>
  8001da:	83 c4 10             	add    $0x10,%esp
		strcconcat(cmdWithCnt, separator, cmdWithCnt);
  8001dd:	83 ec 04             	sub    $0x4,%esp
  8001e0:	8d 85 52 ff ff ff    	lea    -0xae(%ebp),%eax
  8001e6:	50                   	push   %eax
  8001e7:	8d 45 ca             	lea    -0x36(%ebp),%eax
  8001ea:	50                   	push   %eax
  8001eb:	8d 85 52 ff ff ff    	lea    -0xae(%ebp),%eax
  8001f1:	50                   	push   %eax
  8001f2:	e8 66 12 00 00       	call   80145d <strcconcat>
  8001f7:	83 c4 10             	add    $0x10,%esp

		atomic_cprintf("%~Ref Command = %s\n", cmdWithCnt);
  8001fa:	83 ec 08             	sub    $0x8,%esp
  8001fd:	8d 85 52 ff ff ff    	lea    -0xae(%ebp),%eax
  800203:	50                   	push   %eax
  800204:	68 97 1f 80 00       	push   $0x801f97
  800209:	e8 ba 05 00 00       	call   8007c8 <atomic_cprintf>
  80020e:	83 c4 10             	add    $0x10,%esp

		sys_utilities(cmdWithCnt, (uint32)&found);
  800211:	8d 45 cc             	lea    -0x34(%ebp),%eax
  800214:	83 ec 08             	sub    $0x8,%esp
  800217:	50                   	push   %eax
  800218:	8d 85 52 ff ff ff    	lea    -0xae(%ebp),%eax
  80021e:	50                   	push   %eax
  80021f:	e8 35 19 00 00       	call   801b59 <sys_utilities>
  800224:	83 c4 10             	add    $0x10,%esp

		if (found != 1) panic("OPTIMAL alg. failed.. unexpected page reference stream!");
  800227:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80022a:	83 f8 01             	cmp    $0x1,%eax
  80022d:	74 14                	je     800243 <_main+0x20b>
  80022f:	83 ec 04             	sub    $0x4,%esp
  800232:	68 ac 1f 80 00       	push   $0x801fac
  800237:	6a 54                	push   $0x54
  800239:	68 d4 1e 80 00       	push   $0x801ed4
  80023e:	e8 45 02 00 00       	call   800488 <_panic>
	}
	cprintf_colored(TEXT_cyan, "%~\nChecking Allocation in Mem & Page File... \n");
  800243:	83 ec 08             	sub    $0x8,%esp
  800246:	68 e4 1f 80 00       	push   $0x801fe4
  80024b:	6a 03                	push   $0x3
  80024d:	e8 31 05 00 00       	call   800783 <cprintf_colored>
  800252:	83 c4 10             	add    $0x10,%esp
	{
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Unexpected extra/less pages have been added to page file.. NOT Expected to add new pages to the page file");
  800255:	e8 4b 15 00 00       	call   8017a5 <sys_pf_calculate_allocated_pages>
  80025a:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  80025d:	74 14                	je     800273 <_main+0x23b>
  80025f:	83 ec 04             	sub    $0x4,%esp
  800262:	68 14 20 80 00       	push   $0x802014
  800267:	6a 58                	push   $0x58
  800269:	68 d4 1e 80 00       	push   $0x801ed4
  80026e:	e8 15 02 00 00       	call   800488 <_panic>

		int freePagesAfter = (sys_calculate_free_frames() + sys_calculate_modified_frames());
  800273:	e8 e2 14 00 00       	call   80175a <sys_calculate_free_frames>
  800278:	89 c3                	mov    %eax,%ebx
  80027a:	e8 f4 14 00 00       	call   801773 <sys_calculate_modified_frames>
  80027f:	01 d8                	add    %ebx,%eax
  800281:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		int expectedNumOfFrames = 7;
  800284:	c7 45 d0 07 00 00 00 	movl   $0x7,-0x30(%ebp)
		if( (freePages - freePagesAfter) != expectedNumOfFrames)
  80028b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80028e:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  800291:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  800294:	74 1e                	je     8002b4 <_main+0x27c>
			panic("Unexpected number of allocated frames in RAM. Expected = %d, Actual = %d", expectedNumOfFrames, (freePages - freePagesAfter));
  800296:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800299:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  80029c:	83 ec 0c             	sub    $0xc,%esp
  80029f:	50                   	push   %eax
  8002a0:	ff 75 d0             	pushl  -0x30(%ebp)
  8002a3:	68 80 20 80 00       	push   $0x802080
  8002a8:	6a 5d                	push   $0x5d
  8002aa:	68 d4 1e 80 00       	push   $0x801ed4
  8002af:	e8 d4 01 00 00       	call   800488 <_panic>
	}

	cprintf_colored(TEXT_light_green, "%~\nCongratulations!! test PAGE replacement #1 [OPTIMAL Alg.] is completed successfully.\n");
  8002b4:	83 ec 08             	sub    $0x8,%esp
  8002b7:	68 cc 20 80 00       	push   $0x8020cc
  8002bc:	6a 0a                	push   $0xa
  8002be:	e8 c0 04 00 00       	call   800783 <cprintf_colored>
  8002c3:	83 c4 10             	add    $0x10,%esp
	return;
  8002c6:	90                   	nop
}
  8002c7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002ca:	5b                   	pop    %ebx
  8002cb:	5e                   	pop    %esi
  8002cc:	5f                   	pop    %edi
  8002cd:	5d                   	pop    %ebp
  8002ce:	c3                   	ret    

008002cf <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  8002cf:	55                   	push   %ebp
  8002d0:	89 e5                	mov    %esp,%ebp
  8002d2:	57                   	push   %edi
  8002d3:	56                   	push   %esi
  8002d4:	53                   	push   %ebx
  8002d5:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  8002d8:	e8 46 16 00 00       	call   801923 <sys_getenvindex>
  8002dd:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  8002e0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8002e3:	89 d0                	mov    %edx,%eax
  8002e5:	c1 e0 02             	shl    $0x2,%eax
  8002e8:	01 d0                	add    %edx,%eax
  8002ea:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8002f1:	01 d0                	add    %edx,%eax
  8002f3:	89 c2                	mov    %eax,%edx
  8002f5:	c1 e2 04             	shl    $0x4,%edx
  8002f8:	29 c2                	sub    %eax,%edx
  8002fa:	8d 04 95 00 00 00 00 	lea    0x0(,%edx,4),%eax
  800301:	89 c2                	mov    %eax,%edx
  800303:	8d 82 00 00 c0 ee    	lea    -0x11400000(%edx),%eax
  800309:	a3 e0 30 80 00       	mov    %eax,0x8030e0

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  80030e:	a1 e0 30 80 00       	mov    0x8030e0,%eax
  800313:	8a 40 20             	mov    0x20(%eax),%al
  800316:	84 c0                	test   %al,%al
  800318:	74 0d                	je     800327 <libmain+0x58>
		binaryname = myEnv->prog_name;
  80031a:	a1 e0 30 80 00       	mov    0x8030e0,%eax
  80031f:	83 c0 20             	add    $0x20,%eax
  800322:	a3 d4 30 80 00       	mov    %eax,0x8030d4

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800327:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80032b:	7e 0a                	jle    800337 <libmain+0x68>
		binaryname = argv[0];
  80032d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800330:	8b 00                	mov    (%eax),%eax
  800332:	a3 d4 30 80 00       	mov    %eax,0x8030d4

	// call user main routine
	_main(argc, argv);
  800337:	83 ec 08             	sub    $0x8,%esp
  80033a:	ff 75 0c             	pushl  0xc(%ebp)
  80033d:	ff 75 08             	pushl  0x8(%ebp)
  800340:	e8 f3 fc ff ff       	call   800038 <_main>
  800345:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  800348:	a1 d0 30 80 00       	mov    0x8030d0,%eax
  80034d:	85 c0                	test   %eax,%eax
  80034f:	0f 84 01 01 00 00    	je     800456 <libmain+0x187>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  800355:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  80035b:	bb 84 22 80 00       	mov    $0x802284,%ebx
  800360:	ba 0e 00 00 00       	mov    $0xe,%edx
  800365:	89 c7                	mov    %eax,%edi
  800367:	89 de                	mov    %ebx,%esi
  800369:	89 d1                	mov    %edx,%ecx
  80036b:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  80036d:	8d 55 8a             	lea    -0x76(%ebp),%edx
  800370:	b9 56 00 00 00       	mov    $0x56,%ecx
  800375:	b0 00                	mov    $0x0,%al
  800377:	89 d7                	mov    %edx,%edi
  800379:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  80037b:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  800382:	8d 45 e0             	lea    -0x20(%ebp),%eax
  800385:	83 ec 08             	sub    $0x8,%esp
  800388:	50                   	push   %eax
  800389:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  80038f:	50                   	push   %eax
  800390:	e8 c4 17 00 00       	call   801b59 <sys_utilities>
  800395:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  800398:	e8 0d 13 00 00       	call   8016aa <sys_lock_cons>
		{
			cprintf("**************************************\n");
  80039d:	83 ec 0c             	sub    $0xc,%esp
  8003a0:	68 a4 21 80 00       	push   $0x8021a4
  8003a5:	e8 ac 03 00 00       	call   800756 <cprintf>
  8003aa:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  8003ad:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8003b0:	85 c0                	test   %eax,%eax
  8003b2:	74 18                	je     8003cc <libmain+0xfd>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  8003b4:	e8 be 17 00 00       	call   801b77 <sys_get_optimal_num_faults>
  8003b9:	83 ec 08             	sub    $0x8,%esp
  8003bc:	50                   	push   %eax
  8003bd:	68 cc 21 80 00       	push   $0x8021cc
  8003c2:	e8 8f 03 00 00       	call   800756 <cprintf>
  8003c7:	83 c4 10             	add    $0x10,%esp
  8003ca:	eb 59                	jmp    800425 <libmain+0x156>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8003cc:	a1 e0 30 80 00       	mov    0x8030e0,%eax
  8003d1:	8b 90 bc 05 00 00    	mov    0x5bc(%eax),%edx
  8003d7:	a1 e0 30 80 00       	mov    0x8030e0,%eax
  8003dc:	8b 80 ac 05 00 00    	mov    0x5ac(%eax),%eax
  8003e2:	83 ec 04             	sub    $0x4,%esp
  8003e5:	52                   	push   %edx
  8003e6:	50                   	push   %eax
  8003e7:	68 f0 21 80 00       	push   $0x8021f0
  8003ec:	e8 65 03 00 00       	call   800756 <cprintf>
  8003f1:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8003f4:	a1 e0 30 80 00       	mov    0x8030e0,%eax
  8003f9:	8b 88 d0 05 00 00    	mov    0x5d0(%eax),%ecx
  8003ff:	a1 e0 30 80 00       	mov    0x8030e0,%eax
  800404:	8b 90 cc 05 00 00    	mov    0x5cc(%eax),%edx
  80040a:	a1 e0 30 80 00       	mov    0x8030e0,%eax
  80040f:	8b 80 c8 05 00 00    	mov    0x5c8(%eax),%eax
  800415:	51                   	push   %ecx
  800416:	52                   	push   %edx
  800417:	50                   	push   %eax
  800418:	68 18 22 80 00       	push   $0x802218
  80041d:	e8 34 03 00 00       	call   800756 <cprintf>
  800422:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800425:	a1 e0 30 80 00       	mov    0x8030e0,%eax
  80042a:	8b 80 d4 05 00 00    	mov    0x5d4(%eax),%eax
  800430:	83 ec 08             	sub    $0x8,%esp
  800433:	50                   	push   %eax
  800434:	68 70 22 80 00       	push   $0x802270
  800439:	e8 18 03 00 00       	call   800756 <cprintf>
  80043e:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  800441:	83 ec 0c             	sub    $0xc,%esp
  800444:	68 a4 21 80 00       	push   $0x8021a4
  800449:	e8 08 03 00 00       	call   800756 <cprintf>
  80044e:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  800451:	e8 6e 12 00 00       	call   8016c4 <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  800456:	e8 1f 00 00 00       	call   80047a <exit>
}
  80045b:	90                   	nop
  80045c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80045f:	5b                   	pop    %ebx
  800460:	5e                   	pop    %esi
  800461:	5f                   	pop    %edi
  800462:	5d                   	pop    %ebp
  800463:	c3                   	ret    

00800464 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800464:	55                   	push   %ebp
  800465:	89 e5                	mov    %esp,%ebp
  800467:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  80046a:	83 ec 0c             	sub    $0xc,%esp
  80046d:	6a 00                	push   $0x0
  80046f:	e8 7b 14 00 00       	call   8018ef <sys_destroy_env>
  800474:	83 c4 10             	add    $0x10,%esp
}
  800477:	90                   	nop
  800478:	c9                   	leave  
  800479:	c3                   	ret    

0080047a <exit>:

void
exit(void)
{
  80047a:	55                   	push   %ebp
  80047b:	89 e5                	mov    %esp,%ebp
  80047d:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800480:	e8 d0 14 00 00       	call   801955 <sys_exit_env>
}
  800485:	90                   	nop
  800486:	c9                   	leave  
  800487:	c3                   	ret    

00800488 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800488:	55                   	push   %ebp
  800489:	89 e5                	mov    %esp,%ebp
  80048b:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  80048e:	8d 45 10             	lea    0x10(%ebp),%eax
  800491:	83 c0 04             	add    $0x4,%eax
  800494:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800497:	a1 f8 71 82 00       	mov    0x8271f8,%eax
  80049c:	85 c0                	test   %eax,%eax
  80049e:	74 16                	je     8004b6 <_panic+0x2e>
		cprintf("%s: ", argv0);
  8004a0:	a1 f8 71 82 00       	mov    0x8271f8,%eax
  8004a5:	83 ec 08             	sub    $0x8,%esp
  8004a8:	50                   	push   %eax
  8004a9:	68 e8 22 80 00       	push   $0x8022e8
  8004ae:	e8 a3 02 00 00       	call   800756 <cprintf>
  8004b3:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  8004b6:	a1 d4 30 80 00       	mov    0x8030d4,%eax
  8004bb:	83 ec 0c             	sub    $0xc,%esp
  8004be:	ff 75 0c             	pushl  0xc(%ebp)
  8004c1:	ff 75 08             	pushl  0x8(%ebp)
  8004c4:	50                   	push   %eax
  8004c5:	68 f0 22 80 00       	push   $0x8022f0
  8004ca:	6a 74                	push   $0x74
  8004cc:	e8 b2 02 00 00       	call   800783 <cprintf_colored>
  8004d1:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  8004d4:	8b 45 10             	mov    0x10(%ebp),%eax
  8004d7:	83 ec 08             	sub    $0x8,%esp
  8004da:	ff 75 f4             	pushl  -0xc(%ebp)
  8004dd:	50                   	push   %eax
  8004de:	e8 04 02 00 00       	call   8006e7 <vcprintf>
  8004e3:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8004e6:	83 ec 08             	sub    $0x8,%esp
  8004e9:	6a 00                	push   $0x0
  8004eb:	68 18 23 80 00       	push   $0x802318
  8004f0:	e8 f2 01 00 00       	call   8006e7 <vcprintf>
  8004f5:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8004f8:	e8 7d ff ff ff       	call   80047a <exit>

	// should not return here
	while (1) ;
  8004fd:	eb fe                	jmp    8004fd <_panic+0x75>

008004ff <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8004ff:	55                   	push   %ebp
  800500:	89 e5                	mov    %esp,%ebp
  800502:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800505:	a1 e0 30 80 00       	mov    0x8030e0,%eax
  80050a:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800510:	8b 45 0c             	mov    0xc(%ebp),%eax
  800513:	39 c2                	cmp    %eax,%edx
  800515:	74 14                	je     80052b <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800517:	83 ec 04             	sub    $0x4,%esp
  80051a:	68 1c 23 80 00       	push   $0x80231c
  80051f:	6a 26                	push   $0x26
  800521:	68 68 23 80 00       	push   $0x802368
  800526:	e8 5d ff ff ff       	call   800488 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  80052b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800532:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800539:	e9 c5 00 00 00       	jmp    800603 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  80053e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800541:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800548:	8b 45 08             	mov    0x8(%ebp),%eax
  80054b:	01 d0                	add    %edx,%eax
  80054d:	8b 00                	mov    (%eax),%eax
  80054f:	85 c0                	test   %eax,%eax
  800551:	75 08                	jne    80055b <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  800553:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800556:	e9 a5 00 00 00       	jmp    800600 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  80055b:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800562:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800569:	eb 69                	jmp    8005d4 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  80056b:	a1 e0 30 80 00       	mov    0x8030e0,%eax
  800570:	8b 88 a4 05 00 00    	mov    0x5a4(%eax),%ecx
  800576:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800579:	89 d0                	mov    %edx,%eax
  80057b:	01 c0                	add    %eax,%eax
  80057d:	01 d0                	add    %edx,%eax
  80057f:	c1 e0 03             	shl    $0x3,%eax
  800582:	01 c8                	add    %ecx,%eax
  800584:	8a 40 04             	mov    0x4(%eax),%al
  800587:	84 c0                	test   %al,%al
  800589:	75 46                	jne    8005d1 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80058b:	a1 e0 30 80 00       	mov    0x8030e0,%eax
  800590:	8b 88 a4 05 00 00    	mov    0x5a4(%eax),%ecx
  800596:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800599:	89 d0                	mov    %edx,%eax
  80059b:	01 c0                	add    %eax,%eax
  80059d:	01 d0                	add    %edx,%eax
  80059f:	c1 e0 03             	shl    $0x3,%eax
  8005a2:	01 c8                	add    %ecx,%eax
  8005a4:	8b 00                	mov    (%eax),%eax
  8005a6:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8005a9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8005ac:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8005b1:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8005b3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8005b6:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8005bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8005c0:	01 c8                	add    %ecx,%eax
  8005c2:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8005c4:	39 c2                	cmp    %eax,%edx
  8005c6:	75 09                	jne    8005d1 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  8005c8:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8005cf:	eb 15                	jmp    8005e6 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8005d1:	ff 45 e8             	incl   -0x18(%ebp)
  8005d4:	a1 e0 30 80 00       	mov    0x8030e0,%eax
  8005d9:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8005df:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8005e2:	39 c2                	cmp    %eax,%edx
  8005e4:	77 85                	ja     80056b <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8005e6:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8005ea:	75 14                	jne    800600 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  8005ec:	83 ec 04             	sub    $0x4,%esp
  8005ef:	68 74 23 80 00       	push   $0x802374
  8005f4:	6a 3a                	push   $0x3a
  8005f6:	68 68 23 80 00       	push   $0x802368
  8005fb:	e8 88 fe ff ff       	call   800488 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800600:	ff 45 f0             	incl   -0x10(%ebp)
  800603:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800606:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800609:	0f 8c 2f ff ff ff    	jl     80053e <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  80060f:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800616:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80061d:	eb 26                	jmp    800645 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  80061f:	a1 e0 30 80 00       	mov    0x8030e0,%eax
  800624:	8b 88 a4 05 00 00    	mov    0x5a4(%eax),%ecx
  80062a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80062d:	89 d0                	mov    %edx,%eax
  80062f:	01 c0                	add    %eax,%eax
  800631:	01 d0                	add    %edx,%eax
  800633:	c1 e0 03             	shl    $0x3,%eax
  800636:	01 c8                	add    %ecx,%eax
  800638:	8a 40 04             	mov    0x4(%eax),%al
  80063b:	3c 01                	cmp    $0x1,%al
  80063d:	75 03                	jne    800642 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  80063f:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800642:	ff 45 e0             	incl   -0x20(%ebp)
  800645:	a1 e0 30 80 00       	mov    0x8030e0,%eax
  80064a:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800650:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800653:	39 c2                	cmp    %eax,%edx
  800655:	77 c8                	ja     80061f <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800657:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80065a:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80065d:	74 14                	je     800673 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  80065f:	83 ec 04             	sub    $0x4,%esp
  800662:	68 c8 23 80 00       	push   $0x8023c8
  800667:	6a 44                	push   $0x44
  800669:	68 68 23 80 00       	push   $0x802368
  80066e:	e8 15 fe ff ff       	call   800488 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800673:	90                   	nop
  800674:	c9                   	leave  
  800675:	c3                   	ret    

00800676 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  800676:	55                   	push   %ebp
  800677:	89 e5                	mov    %esp,%ebp
  800679:	53                   	push   %ebx
  80067a:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  80067d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800680:	8b 00                	mov    (%eax),%eax
  800682:	8d 48 01             	lea    0x1(%eax),%ecx
  800685:	8b 55 0c             	mov    0xc(%ebp),%edx
  800688:	89 0a                	mov    %ecx,(%edx)
  80068a:	8b 55 08             	mov    0x8(%ebp),%edx
  80068d:	88 d1                	mov    %dl,%cl
  80068f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800692:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800696:	8b 45 0c             	mov    0xc(%ebp),%eax
  800699:	8b 00                	mov    (%eax),%eax
  80069b:	3d ff 00 00 00       	cmp    $0xff,%eax
  8006a0:	75 30                	jne    8006d2 <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  8006a2:	8b 15 fc 71 82 00    	mov    0x8271fc,%edx
  8006a8:	a0 04 31 80 00       	mov    0x803104,%al
  8006ad:	0f b6 c0             	movzbl %al,%eax
  8006b0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8006b3:	8b 09                	mov    (%ecx),%ecx
  8006b5:	89 cb                	mov    %ecx,%ebx
  8006b7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8006ba:	83 c1 08             	add    $0x8,%ecx
  8006bd:	52                   	push   %edx
  8006be:	50                   	push   %eax
  8006bf:	53                   	push   %ebx
  8006c0:	51                   	push   %ecx
  8006c1:	e8 a0 0f 00 00       	call   801666 <sys_cputs>
  8006c6:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8006c9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006cc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8006d2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006d5:	8b 40 04             	mov    0x4(%eax),%eax
  8006d8:	8d 50 01             	lea    0x1(%eax),%edx
  8006db:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006de:	89 50 04             	mov    %edx,0x4(%eax)
}
  8006e1:	90                   	nop
  8006e2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8006e5:	c9                   	leave  
  8006e6:	c3                   	ret    

008006e7 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8006e7:	55                   	push   %ebp
  8006e8:	89 e5                	mov    %esp,%ebp
  8006ea:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8006f0:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8006f7:	00 00 00 
	b.cnt = 0;
  8006fa:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800701:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800704:	ff 75 0c             	pushl  0xc(%ebp)
  800707:	ff 75 08             	pushl  0x8(%ebp)
  80070a:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800710:	50                   	push   %eax
  800711:	68 76 06 80 00       	push   $0x800676
  800716:	e8 5a 02 00 00       	call   800975 <vprintfmt>
  80071b:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  80071e:	8b 15 fc 71 82 00    	mov    0x8271fc,%edx
  800724:	a0 04 31 80 00       	mov    0x803104,%al
  800729:	0f b6 c0             	movzbl %al,%eax
  80072c:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  800732:	52                   	push   %edx
  800733:	50                   	push   %eax
  800734:	51                   	push   %ecx
  800735:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80073b:	83 c0 08             	add    $0x8,%eax
  80073e:	50                   	push   %eax
  80073f:	e8 22 0f 00 00       	call   801666 <sys_cputs>
  800744:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800747:	c6 05 04 31 80 00 00 	movb   $0x0,0x803104
	return b.cnt;
  80074e:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800754:	c9                   	leave  
  800755:	c3                   	ret    

00800756 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  800756:	55                   	push   %ebp
  800757:	89 e5                	mov    %esp,%ebp
  800759:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  80075c:	c6 05 04 31 80 00 01 	movb   $0x1,0x803104
	va_start(ap, fmt);
  800763:	8d 45 0c             	lea    0xc(%ebp),%eax
  800766:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800769:	8b 45 08             	mov    0x8(%ebp),%eax
  80076c:	83 ec 08             	sub    $0x8,%esp
  80076f:	ff 75 f4             	pushl  -0xc(%ebp)
  800772:	50                   	push   %eax
  800773:	e8 6f ff ff ff       	call   8006e7 <vcprintf>
  800778:	83 c4 10             	add    $0x10,%esp
  80077b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  80077e:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800781:	c9                   	leave  
  800782:	c3                   	ret    

00800783 <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  800783:	55                   	push   %ebp
  800784:	89 e5                	mov    %esp,%ebp
  800786:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800789:	c6 05 04 31 80 00 01 	movb   $0x1,0x803104
	curTextClr = (textClr << 8) ; //set text color by the given value
  800790:	8b 45 08             	mov    0x8(%ebp),%eax
  800793:	c1 e0 08             	shl    $0x8,%eax
  800796:	a3 fc 71 82 00       	mov    %eax,0x8271fc
	va_start(ap, fmt);
  80079b:	8d 45 0c             	lea    0xc(%ebp),%eax
  80079e:	83 c0 04             	add    $0x4,%eax
  8007a1:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8007a4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007a7:	83 ec 08             	sub    $0x8,%esp
  8007aa:	ff 75 f4             	pushl  -0xc(%ebp)
  8007ad:	50                   	push   %eax
  8007ae:	e8 34 ff ff ff       	call   8006e7 <vcprintf>
  8007b3:	83 c4 10             	add    $0x10,%esp
  8007b6:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  8007b9:	c7 05 fc 71 82 00 00 	movl   $0x700,0x8271fc
  8007c0:	07 00 00 

	return cnt;
  8007c3:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8007c6:	c9                   	leave  
  8007c7:	c3                   	ret    

008007c8 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  8007c8:	55                   	push   %ebp
  8007c9:	89 e5                	mov    %esp,%ebp
  8007cb:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  8007ce:	e8 d7 0e 00 00       	call   8016aa <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  8007d3:	8d 45 0c             	lea    0xc(%ebp),%eax
  8007d6:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  8007d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8007dc:	83 ec 08             	sub    $0x8,%esp
  8007df:	ff 75 f4             	pushl  -0xc(%ebp)
  8007e2:	50                   	push   %eax
  8007e3:	e8 ff fe ff ff       	call   8006e7 <vcprintf>
  8007e8:	83 c4 10             	add    $0x10,%esp
  8007eb:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  8007ee:	e8 d1 0e 00 00       	call   8016c4 <sys_unlock_cons>
	return cnt;
  8007f3:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8007f6:	c9                   	leave  
  8007f7:	c3                   	ret    

008007f8 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8007f8:	55                   	push   %ebp
  8007f9:	89 e5                	mov    %esp,%ebp
  8007fb:	53                   	push   %ebx
  8007fc:	83 ec 14             	sub    $0x14,%esp
  8007ff:	8b 45 10             	mov    0x10(%ebp),%eax
  800802:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800805:	8b 45 14             	mov    0x14(%ebp),%eax
  800808:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80080b:	8b 45 18             	mov    0x18(%ebp),%eax
  80080e:	ba 00 00 00 00       	mov    $0x0,%edx
  800813:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800816:	77 55                	ja     80086d <printnum+0x75>
  800818:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80081b:	72 05                	jb     800822 <printnum+0x2a>
  80081d:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800820:	77 4b                	ja     80086d <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800822:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800825:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800828:	8b 45 18             	mov    0x18(%ebp),%eax
  80082b:	ba 00 00 00 00       	mov    $0x0,%edx
  800830:	52                   	push   %edx
  800831:	50                   	push   %eax
  800832:	ff 75 f4             	pushl  -0xc(%ebp)
  800835:	ff 75 f0             	pushl  -0x10(%ebp)
  800838:	e8 ab 13 00 00       	call   801be8 <__udivdi3>
  80083d:	83 c4 10             	add    $0x10,%esp
  800840:	83 ec 04             	sub    $0x4,%esp
  800843:	ff 75 20             	pushl  0x20(%ebp)
  800846:	53                   	push   %ebx
  800847:	ff 75 18             	pushl  0x18(%ebp)
  80084a:	52                   	push   %edx
  80084b:	50                   	push   %eax
  80084c:	ff 75 0c             	pushl  0xc(%ebp)
  80084f:	ff 75 08             	pushl  0x8(%ebp)
  800852:	e8 a1 ff ff ff       	call   8007f8 <printnum>
  800857:	83 c4 20             	add    $0x20,%esp
  80085a:	eb 1a                	jmp    800876 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80085c:	83 ec 08             	sub    $0x8,%esp
  80085f:	ff 75 0c             	pushl  0xc(%ebp)
  800862:	ff 75 20             	pushl  0x20(%ebp)
  800865:	8b 45 08             	mov    0x8(%ebp),%eax
  800868:	ff d0                	call   *%eax
  80086a:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80086d:	ff 4d 1c             	decl   0x1c(%ebp)
  800870:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800874:	7f e6                	jg     80085c <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800876:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800879:	bb 00 00 00 00       	mov    $0x0,%ebx
  80087e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800881:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800884:	53                   	push   %ebx
  800885:	51                   	push   %ecx
  800886:	52                   	push   %edx
  800887:	50                   	push   %eax
  800888:	e8 6b 14 00 00       	call   801cf8 <__umoddi3>
  80088d:	83 c4 10             	add    $0x10,%esp
  800890:	05 34 26 80 00       	add    $0x802634,%eax
  800895:	8a 00                	mov    (%eax),%al
  800897:	0f be c0             	movsbl %al,%eax
  80089a:	83 ec 08             	sub    $0x8,%esp
  80089d:	ff 75 0c             	pushl  0xc(%ebp)
  8008a0:	50                   	push   %eax
  8008a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8008a4:	ff d0                	call   *%eax
  8008a6:	83 c4 10             	add    $0x10,%esp
}
  8008a9:	90                   	nop
  8008aa:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8008ad:	c9                   	leave  
  8008ae:	c3                   	ret    

008008af <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8008af:	55                   	push   %ebp
  8008b0:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8008b2:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8008b6:	7e 1c                	jle    8008d4 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8008b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8008bb:	8b 00                	mov    (%eax),%eax
  8008bd:	8d 50 08             	lea    0x8(%eax),%edx
  8008c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8008c3:	89 10                	mov    %edx,(%eax)
  8008c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8008c8:	8b 00                	mov    (%eax),%eax
  8008ca:	83 e8 08             	sub    $0x8,%eax
  8008cd:	8b 50 04             	mov    0x4(%eax),%edx
  8008d0:	8b 00                	mov    (%eax),%eax
  8008d2:	eb 40                	jmp    800914 <getuint+0x65>
	else if (lflag)
  8008d4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8008d8:	74 1e                	je     8008f8 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8008da:	8b 45 08             	mov    0x8(%ebp),%eax
  8008dd:	8b 00                	mov    (%eax),%eax
  8008df:	8d 50 04             	lea    0x4(%eax),%edx
  8008e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8008e5:	89 10                	mov    %edx,(%eax)
  8008e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ea:	8b 00                	mov    (%eax),%eax
  8008ec:	83 e8 04             	sub    $0x4,%eax
  8008ef:	8b 00                	mov    (%eax),%eax
  8008f1:	ba 00 00 00 00       	mov    $0x0,%edx
  8008f6:	eb 1c                	jmp    800914 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8008f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8008fb:	8b 00                	mov    (%eax),%eax
  8008fd:	8d 50 04             	lea    0x4(%eax),%edx
  800900:	8b 45 08             	mov    0x8(%ebp),%eax
  800903:	89 10                	mov    %edx,(%eax)
  800905:	8b 45 08             	mov    0x8(%ebp),%eax
  800908:	8b 00                	mov    (%eax),%eax
  80090a:	83 e8 04             	sub    $0x4,%eax
  80090d:	8b 00                	mov    (%eax),%eax
  80090f:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800914:	5d                   	pop    %ebp
  800915:	c3                   	ret    

00800916 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800916:	55                   	push   %ebp
  800917:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800919:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80091d:	7e 1c                	jle    80093b <getint+0x25>
		return va_arg(*ap, long long);
  80091f:	8b 45 08             	mov    0x8(%ebp),%eax
  800922:	8b 00                	mov    (%eax),%eax
  800924:	8d 50 08             	lea    0x8(%eax),%edx
  800927:	8b 45 08             	mov    0x8(%ebp),%eax
  80092a:	89 10                	mov    %edx,(%eax)
  80092c:	8b 45 08             	mov    0x8(%ebp),%eax
  80092f:	8b 00                	mov    (%eax),%eax
  800931:	83 e8 08             	sub    $0x8,%eax
  800934:	8b 50 04             	mov    0x4(%eax),%edx
  800937:	8b 00                	mov    (%eax),%eax
  800939:	eb 38                	jmp    800973 <getint+0x5d>
	else if (lflag)
  80093b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80093f:	74 1a                	je     80095b <getint+0x45>
		return va_arg(*ap, long);
  800941:	8b 45 08             	mov    0x8(%ebp),%eax
  800944:	8b 00                	mov    (%eax),%eax
  800946:	8d 50 04             	lea    0x4(%eax),%edx
  800949:	8b 45 08             	mov    0x8(%ebp),%eax
  80094c:	89 10                	mov    %edx,(%eax)
  80094e:	8b 45 08             	mov    0x8(%ebp),%eax
  800951:	8b 00                	mov    (%eax),%eax
  800953:	83 e8 04             	sub    $0x4,%eax
  800956:	8b 00                	mov    (%eax),%eax
  800958:	99                   	cltd   
  800959:	eb 18                	jmp    800973 <getint+0x5d>
	else
		return va_arg(*ap, int);
  80095b:	8b 45 08             	mov    0x8(%ebp),%eax
  80095e:	8b 00                	mov    (%eax),%eax
  800960:	8d 50 04             	lea    0x4(%eax),%edx
  800963:	8b 45 08             	mov    0x8(%ebp),%eax
  800966:	89 10                	mov    %edx,(%eax)
  800968:	8b 45 08             	mov    0x8(%ebp),%eax
  80096b:	8b 00                	mov    (%eax),%eax
  80096d:	83 e8 04             	sub    $0x4,%eax
  800970:	8b 00                	mov    (%eax),%eax
  800972:	99                   	cltd   
}
  800973:	5d                   	pop    %ebp
  800974:	c3                   	ret    

00800975 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800975:	55                   	push   %ebp
  800976:	89 e5                	mov    %esp,%ebp
  800978:	56                   	push   %esi
  800979:	53                   	push   %ebx
  80097a:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80097d:	eb 17                	jmp    800996 <vprintfmt+0x21>
			if (ch == '\0')
  80097f:	85 db                	test   %ebx,%ebx
  800981:	0f 84 c1 03 00 00    	je     800d48 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  800987:	83 ec 08             	sub    $0x8,%esp
  80098a:	ff 75 0c             	pushl  0xc(%ebp)
  80098d:	53                   	push   %ebx
  80098e:	8b 45 08             	mov    0x8(%ebp),%eax
  800991:	ff d0                	call   *%eax
  800993:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800996:	8b 45 10             	mov    0x10(%ebp),%eax
  800999:	8d 50 01             	lea    0x1(%eax),%edx
  80099c:	89 55 10             	mov    %edx,0x10(%ebp)
  80099f:	8a 00                	mov    (%eax),%al
  8009a1:	0f b6 d8             	movzbl %al,%ebx
  8009a4:	83 fb 25             	cmp    $0x25,%ebx
  8009a7:	75 d6                	jne    80097f <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8009a9:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  8009ad:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  8009b4:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8009bb:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8009c2:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8009c9:	8b 45 10             	mov    0x10(%ebp),%eax
  8009cc:	8d 50 01             	lea    0x1(%eax),%edx
  8009cf:	89 55 10             	mov    %edx,0x10(%ebp)
  8009d2:	8a 00                	mov    (%eax),%al
  8009d4:	0f b6 d8             	movzbl %al,%ebx
  8009d7:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8009da:	83 f8 5b             	cmp    $0x5b,%eax
  8009dd:	0f 87 3d 03 00 00    	ja     800d20 <vprintfmt+0x3ab>
  8009e3:	8b 04 85 58 26 80 00 	mov    0x802658(,%eax,4),%eax
  8009ea:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8009ec:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8009f0:	eb d7                	jmp    8009c9 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8009f2:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8009f6:	eb d1                	jmp    8009c9 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8009f8:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8009ff:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800a02:	89 d0                	mov    %edx,%eax
  800a04:	c1 e0 02             	shl    $0x2,%eax
  800a07:	01 d0                	add    %edx,%eax
  800a09:	01 c0                	add    %eax,%eax
  800a0b:	01 d8                	add    %ebx,%eax
  800a0d:	83 e8 30             	sub    $0x30,%eax
  800a10:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800a13:	8b 45 10             	mov    0x10(%ebp),%eax
  800a16:	8a 00                	mov    (%eax),%al
  800a18:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800a1b:	83 fb 2f             	cmp    $0x2f,%ebx
  800a1e:	7e 3e                	jle    800a5e <vprintfmt+0xe9>
  800a20:	83 fb 39             	cmp    $0x39,%ebx
  800a23:	7f 39                	jg     800a5e <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800a25:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800a28:	eb d5                	jmp    8009ff <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800a2a:	8b 45 14             	mov    0x14(%ebp),%eax
  800a2d:	83 c0 04             	add    $0x4,%eax
  800a30:	89 45 14             	mov    %eax,0x14(%ebp)
  800a33:	8b 45 14             	mov    0x14(%ebp),%eax
  800a36:	83 e8 04             	sub    $0x4,%eax
  800a39:	8b 00                	mov    (%eax),%eax
  800a3b:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800a3e:	eb 1f                	jmp    800a5f <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800a40:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a44:	79 83                	jns    8009c9 <vprintfmt+0x54>
				width = 0;
  800a46:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800a4d:	e9 77 ff ff ff       	jmp    8009c9 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800a52:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800a59:	e9 6b ff ff ff       	jmp    8009c9 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800a5e:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800a5f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a63:	0f 89 60 ff ff ff    	jns    8009c9 <vprintfmt+0x54>
				width = precision, precision = -1;
  800a69:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800a6c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800a6f:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800a76:	e9 4e ff ff ff       	jmp    8009c9 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800a7b:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800a7e:	e9 46 ff ff ff       	jmp    8009c9 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800a83:	8b 45 14             	mov    0x14(%ebp),%eax
  800a86:	83 c0 04             	add    $0x4,%eax
  800a89:	89 45 14             	mov    %eax,0x14(%ebp)
  800a8c:	8b 45 14             	mov    0x14(%ebp),%eax
  800a8f:	83 e8 04             	sub    $0x4,%eax
  800a92:	8b 00                	mov    (%eax),%eax
  800a94:	83 ec 08             	sub    $0x8,%esp
  800a97:	ff 75 0c             	pushl  0xc(%ebp)
  800a9a:	50                   	push   %eax
  800a9b:	8b 45 08             	mov    0x8(%ebp),%eax
  800a9e:	ff d0                	call   *%eax
  800aa0:	83 c4 10             	add    $0x10,%esp
			break;
  800aa3:	e9 9b 02 00 00       	jmp    800d43 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800aa8:	8b 45 14             	mov    0x14(%ebp),%eax
  800aab:	83 c0 04             	add    $0x4,%eax
  800aae:	89 45 14             	mov    %eax,0x14(%ebp)
  800ab1:	8b 45 14             	mov    0x14(%ebp),%eax
  800ab4:	83 e8 04             	sub    $0x4,%eax
  800ab7:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800ab9:	85 db                	test   %ebx,%ebx
  800abb:	79 02                	jns    800abf <vprintfmt+0x14a>
				err = -err;
  800abd:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800abf:	83 fb 64             	cmp    $0x64,%ebx
  800ac2:	7f 0b                	jg     800acf <vprintfmt+0x15a>
  800ac4:	8b 34 9d a0 24 80 00 	mov    0x8024a0(,%ebx,4),%esi
  800acb:	85 f6                	test   %esi,%esi
  800acd:	75 19                	jne    800ae8 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800acf:	53                   	push   %ebx
  800ad0:	68 45 26 80 00       	push   $0x802645
  800ad5:	ff 75 0c             	pushl  0xc(%ebp)
  800ad8:	ff 75 08             	pushl  0x8(%ebp)
  800adb:	e8 70 02 00 00       	call   800d50 <printfmt>
  800ae0:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800ae3:	e9 5b 02 00 00       	jmp    800d43 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800ae8:	56                   	push   %esi
  800ae9:	68 4e 26 80 00       	push   $0x80264e
  800aee:	ff 75 0c             	pushl  0xc(%ebp)
  800af1:	ff 75 08             	pushl  0x8(%ebp)
  800af4:	e8 57 02 00 00       	call   800d50 <printfmt>
  800af9:	83 c4 10             	add    $0x10,%esp
			break;
  800afc:	e9 42 02 00 00       	jmp    800d43 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800b01:	8b 45 14             	mov    0x14(%ebp),%eax
  800b04:	83 c0 04             	add    $0x4,%eax
  800b07:	89 45 14             	mov    %eax,0x14(%ebp)
  800b0a:	8b 45 14             	mov    0x14(%ebp),%eax
  800b0d:	83 e8 04             	sub    $0x4,%eax
  800b10:	8b 30                	mov    (%eax),%esi
  800b12:	85 f6                	test   %esi,%esi
  800b14:	75 05                	jne    800b1b <vprintfmt+0x1a6>
				p = "(null)";
  800b16:	be 51 26 80 00       	mov    $0x802651,%esi
			if (width > 0 && padc != '-')
  800b1b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b1f:	7e 6d                	jle    800b8e <vprintfmt+0x219>
  800b21:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800b25:	74 67                	je     800b8e <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800b27:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800b2a:	83 ec 08             	sub    $0x8,%esp
  800b2d:	50                   	push   %eax
  800b2e:	56                   	push   %esi
  800b2f:	e8 1e 03 00 00       	call   800e52 <strnlen>
  800b34:	83 c4 10             	add    $0x10,%esp
  800b37:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800b3a:	eb 16                	jmp    800b52 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800b3c:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800b40:	83 ec 08             	sub    $0x8,%esp
  800b43:	ff 75 0c             	pushl  0xc(%ebp)
  800b46:	50                   	push   %eax
  800b47:	8b 45 08             	mov    0x8(%ebp),%eax
  800b4a:	ff d0                	call   *%eax
  800b4c:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800b4f:	ff 4d e4             	decl   -0x1c(%ebp)
  800b52:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b56:	7f e4                	jg     800b3c <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b58:	eb 34                	jmp    800b8e <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800b5a:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800b5e:	74 1c                	je     800b7c <vprintfmt+0x207>
  800b60:	83 fb 1f             	cmp    $0x1f,%ebx
  800b63:	7e 05                	jle    800b6a <vprintfmt+0x1f5>
  800b65:	83 fb 7e             	cmp    $0x7e,%ebx
  800b68:	7e 12                	jle    800b7c <vprintfmt+0x207>
					putch('?', putdat);
  800b6a:	83 ec 08             	sub    $0x8,%esp
  800b6d:	ff 75 0c             	pushl  0xc(%ebp)
  800b70:	6a 3f                	push   $0x3f
  800b72:	8b 45 08             	mov    0x8(%ebp),%eax
  800b75:	ff d0                	call   *%eax
  800b77:	83 c4 10             	add    $0x10,%esp
  800b7a:	eb 0f                	jmp    800b8b <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800b7c:	83 ec 08             	sub    $0x8,%esp
  800b7f:	ff 75 0c             	pushl  0xc(%ebp)
  800b82:	53                   	push   %ebx
  800b83:	8b 45 08             	mov    0x8(%ebp),%eax
  800b86:	ff d0                	call   *%eax
  800b88:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b8b:	ff 4d e4             	decl   -0x1c(%ebp)
  800b8e:	89 f0                	mov    %esi,%eax
  800b90:	8d 70 01             	lea    0x1(%eax),%esi
  800b93:	8a 00                	mov    (%eax),%al
  800b95:	0f be d8             	movsbl %al,%ebx
  800b98:	85 db                	test   %ebx,%ebx
  800b9a:	74 24                	je     800bc0 <vprintfmt+0x24b>
  800b9c:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800ba0:	78 b8                	js     800b5a <vprintfmt+0x1e5>
  800ba2:	ff 4d e0             	decl   -0x20(%ebp)
  800ba5:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800ba9:	79 af                	jns    800b5a <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800bab:	eb 13                	jmp    800bc0 <vprintfmt+0x24b>
				putch(' ', putdat);
  800bad:	83 ec 08             	sub    $0x8,%esp
  800bb0:	ff 75 0c             	pushl  0xc(%ebp)
  800bb3:	6a 20                	push   $0x20
  800bb5:	8b 45 08             	mov    0x8(%ebp),%eax
  800bb8:	ff d0                	call   *%eax
  800bba:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800bbd:	ff 4d e4             	decl   -0x1c(%ebp)
  800bc0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800bc4:	7f e7                	jg     800bad <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800bc6:	e9 78 01 00 00       	jmp    800d43 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800bcb:	83 ec 08             	sub    $0x8,%esp
  800bce:	ff 75 e8             	pushl  -0x18(%ebp)
  800bd1:	8d 45 14             	lea    0x14(%ebp),%eax
  800bd4:	50                   	push   %eax
  800bd5:	e8 3c fd ff ff       	call   800916 <getint>
  800bda:	83 c4 10             	add    $0x10,%esp
  800bdd:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800be0:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800be3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800be6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800be9:	85 d2                	test   %edx,%edx
  800beb:	79 23                	jns    800c10 <vprintfmt+0x29b>
				putch('-', putdat);
  800bed:	83 ec 08             	sub    $0x8,%esp
  800bf0:	ff 75 0c             	pushl  0xc(%ebp)
  800bf3:	6a 2d                	push   $0x2d
  800bf5:	8b 45 08             	mov    0x8(%ebp),%eax
  800bf8:	ff d0                	call   *%eax
  800bfa:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800bfd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c00:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800c03:	f7 d8                	neg    %eax
  800c05:	83 d2 00             	adc    $0x0,%edx
  800c08:	f7 da                	neg    %edx
  800c0a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c0d:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800c10:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800c17:	e9 bc 00 00 00       	jmp    800cd8 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800c1c:	83 ec 08             	sub    $0x8,%esp
  800c1f:	ff 75 e8             	pushl  -0x18(%ebp)
  800c22:	8d 45 14             	lea    0x14(%ebp),%eax
  800c25:	50                   	push   %eax
  800c26:	e8 84 fc ff ff       	call   8008af <getuint>
  800c2b:	83 c4 10             	add    $0x10,%esp
  800c2e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c31:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800c34:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800c3b:	e9 98 00 00 00       	jmp    800cd8 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800c40:	83 ec 08             	sub    $0x8,%esp
  800c43:	ff 75 0c             	pushl  0xc(%ebp)
  800c46:	6a 58                	push   $0x58
  800c48:	8b 45 08             	mov    0x8(%ebp),%eax
  800c4b:	ff d0                	call   *%eax
  800c4d:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800c50:	83 ec 08             	sub    $0x8,%esp
  800c53:	ff 75 0c             	pushl  0xc(%ebp)
  800c56:	6a 58                	push   $0x58
  800c58:	8b 45 08             	mov    0x8(%ebp),%eax
  800c5b:	ff d0                	call   *%eax
  800c5d:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800c60:	83 ec 08             	sub    $0x8,%esp
  800c63:	ff 75 0c             	pushl  0xc(%ebp)
  800c66:	6a 58                	push   $0x58
  800c68:	8b 45 08             	mov    0x8(%ebp),%eax
  800c6b:	ff d0                	call   *%eax
  800c6d:	83 c4 10             	add    $0x10,%esp
			break;
  800c70:	e9 ce 00 00 00       	jmp    800d43 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800c75:	83 ec 08             	sub    $0x8,%esp
  800c78:	ff 75 0c             	pushl  0xc(%ebp)
  800c7b:	6a 30                	push   $0x30
  800c7d:	8b 45 08             	mov    0x8(%ebp),%eax
  800c80:	ff d0                	call   *%eax
  800c82:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800c85:	83 ec 08             	sub    $0x8,%esp
  800c88:	ff 75 0c             	pushl  0xc(%ebp)
  800c8b:	6a 78                	push   $0x78
  800c8d:	8b 45 08             	mov    0x8(%ebp),%eax
  800c90:	ff d0                	call   *%eax
  800c92:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800c95:	8b 45 14             	mov    0x14(%ebp),%eax
  800c98:	83 c0 04             	add    $0x4,%eax
  800c9b:	89 45 14             	mov    %eax,0x14(%ebp)
  800c9e:	8b 45 14             	mov    0x14(%ebp),%eax
  800ca1:	83 e8 04             	sub    $0x4,%eax
  800ca4:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800ca6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ca9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800cb0:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800cb7:	eb 1f                	jmp    800cd8 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800cb9:	83 ec 08             	sub    $0x8,%esp
  800cbc:	ff 75 e8             	pushl  -0x18(%ebp)
  800cbf:	8d 45 14             	lea    0x14(%ebp),%eax
  800cc2:	50                   	push   %eax
  800cc3:	e8 e7 fb ff ff       	call   8008af <getuint>
  800cc8:	83 c4 10             	add    $0x10,%esp
  800ccb:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800cce:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800cd1:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800cd8:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800cdc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800cdf:	83 ec 04             	sub    $0x4,%esp
  800ce2:	52                   	push   %edx
  800ce3:	ff 75 e4             	pushl  -0x1c(%ebp)
  800ce6:	50                   	push   %eax
  800ce7:	ff 75 f4             	pushl  -0xc(%ebp)
  800cea:	ff 75 f0             	pushl  -0x10(%ebp)
  800ced:	ff 75 0c             	pushl  0xc(%ebp)
  800cf0:	ff 75 08             	pushl  0x8(%ebp)
  800cf3:	e8 00 fb ff ff       	call   8007f8 <printnum>
  800cf8:	83 c4 20             	add    $0x20,%esp
			break;
  800cfb:	eb 46                	jmp    800d43 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800cfd:	83 ec 08             	sub    $0x8,%esp
  800d00:	ff 75 0c             	pushl  0xc(%ebp)
  800d03:	53                   	push   %ebx
  800d04:	8b 45 08             	mov    0x8(%ebp),%eax
  800d07:	ff d0                	call   *%eax
  800d09:	83 c4 10             	add    $0x10,%esp
			break;
  800d0c:	eb 35                	jmp    800d43 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800d0e:	c6 05 04 31 80 00 00 	movb   $0x0,0x803104
			break;
  800d15:	eb 2c                	jmp    800d43 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800d17:	c6 05 04 31 80 00 01 	movb   $0x1,0x803104
			break;
  800d1e:	eb 23                	jmp    800d43 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800d20:	83 ec 08             	sub    $0x8,%esp
  800d23:	ff 75 0c             	pushl  0xc(%ebp)
  800d26:	6a 25                	push   $0x25
  800d28:	8b 45 08             	mov    0x8(%ebp),%eax
  800d2b:	ff d0                	call   *%eax
  800d2d:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800d30:	ff 4d 10             	decl   0x10(%ebp)
  800d33:	eb 03                	jmp    800d38 <vprintfmt+0x3c3>
  800d35:	ff 4d 10             	decl   0x10(%ebp)
  800d38:	8b 45 10             	mov    0x10(%ebp),%eax
  800d3b:	48                   	dec    %eax
  800d3c:	8a 00                	mov    (%eax),%al
  800d3e:	3c 25                	cmp    $0x25,%al
  800d40:	75 f3                	jne    800d35 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800d42:	90                   	nop
		}
	}
  800d43:	e9 35 fc ff ff       	jmp    80097d <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800d48:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800d49:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800d4c:	5b                   	pop    %ebx
  800d4d:	5e                   	pop    %esi
  800d4e:	5d                   	pop    %ebp
  800d4f:	c3                   	ret    

00800d50 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800d50:	55                   	push   %ebp
  800d51:	89 e5                	mov    %esp,%ebp
  800d53:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800d56:	8d 45 10             	lea    0x10(%ebp),%eax
  800d59:	83 c0 04             	add    $0x4,%eax
  800d5c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800d5f:	8b 45 10             	mov    0x10(%ebp),%eax
  800d62:	ff 75 f4             	pushl  -0xc(%ebp)
  800d65:	50                   	push   %eax
  800d66:	ff 75 0c             	pushl  0xc(%ebp)
  800d69:	ff 75 08             	pushl  0x8(%ebp)
  800d6c:	e8 04 fc ff ff       	call   800975 <vprintfmt>
  800d71:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800d74:	90                   	nop
  800d75:	c9                   	leave  
  800d76:	c3                   	ret    

00800d77 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800d77:	55                   	push   %ebp
  800d78:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800d7a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d7d:	8b 40 08             	mov    0x8(%eax),%eax
  800d80:	8d 50 01             	lea    0x1(%eax),%edx
  800d83:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d86:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800d89:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d8c:	8b 10                	mov    (%eax),%edx
  800d8e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d91:	8b 40 04             	mov    0x4(%eax),%eax
  800d94:	39 c2                	cmp    %eax,%edx
  800d96:	73 12                	jae    800daa <sprintputch+0x33>
		*b->buf++ = ch;
  800d98:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d9b:	8b 00                	mov    (%eax),%eax
  800d9d:	8d 48 01             	lea    0x1(%eax),%ecx
  800da0:	8b 55 0c             	mov    0xc(%ebp),%edx
  800da3:	89 0a                	mov    %ecx,(%edx)
  800da5:	8b 55 08             	mov    0x8(%ebp),%edx
  800da8:	88 10                	mov    %dl,(%eax)
}
  800daa:	90                   	nop
  800dab:	5d                   	pop    %ebp
  800dac:	c3                   	ret    

00800dad <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800dad:	55                   	push   %ebp
  800dae:	89 e5                	mov    %esp,%ebp
  800db0:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800db3:	8b 45 08             	mov    0x8(%ebp),%eax
  800db6:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800db9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dbc:	8d 50 ff             	lea    -0x1(%eax),%edx
  800dbf:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc2:	01 d0                	add    %edx,%eax
  800dc4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800dc7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800dce:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800dd2:	74 06                	je     800dda <vsnprintf+0x2d>
  800dd4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800dd8:	7f 07                	jg     800de1 <vsnprintf+0x34>
		return -E_INVAL;
  800dda:	b8 03 00 00 00       	mov    $0x3,%eax
  800ddf:	eb 20                	jmp    800e01 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800de1:	ff 75 14             	pushl  0x14(%ebp)
  800de4:	ff 75 10             	pushl  0x10(%ebp)
  800de7:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800dea:	50                   	push   %eax
  800deb:	68 77 0d 80 00       	push   $0x800d77
  800df0:	e8 80 fb ff ff       	call   800975 <vprintfmt>
  800df5:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800df8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800dfb:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800dfe:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800e01:	c9                   	leave  
  800e02:	c3                   	ret    

00800e03 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800e03:	55                   	push   %ebp
  800e04:	89 e5                	mov    %esp,%ebp
  800e06:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800e09:	8d 45 10             	lea    0x10(%ebp),%eax
  800e0c:	83 c0 04             	add    $0x4,%eax
  800e0f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800e12:	8b 45 10             	mov    0x10(%ebp),%eax
  800e15:	ff 75 f4             	pushl  -0xc(%ebp)
  800e18:	50                   	push   %eax
  800e19:	ff 75 0c             	pushl  0xc(%ebp)
  800e1c:	ff 75 08             	pushl  0x8(%ebp)
  800e1f:	e8 89 ff ff ff       	call   800dad <vsnprintf>
  800e24:	83 c4 10             	add    $0x10,%esp
  800e27:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800e2a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800e2d:	c9                   	leave  
  800e2e:	c3                   	ret    

00800e2f <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800e2f:	55                   	push   %ebp
  800e30:	89 e5                	mov    %esp,%ebp
  800e32:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800e35:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800e3c:	eb 06                	jmp    800e44 <strlen+0x15>
		n++;
  800e3e:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800e41:	ff 45 08             	incl   0x8(%ebp)
  800e44:	8b 45 08             	mov    0x8(%ebp),%eax
  800e47:	8a 00                	mov    (%eax),%al
  800e49:	84 c0                	test   %al,%al
  800e4b:	75 f1                	jne    800e3e <strlen+0xf>
		n++;
	return n;
  800e4d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e50:	c9                   	leave  
  800e51:	c3                   	ret    

00800e52 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800e52:	55                   	push   %ebp
  800e53:	89 e5                	mov    %esp,%ebp
  800e55:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800e58:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800e5f:	eb 09                	jmp    800e6a <strnlen+0x18>
		n++;
  800e61:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800e64:	ff 45 08             	incl   0x8(%ebp)
  800e67:	ff 4d 0c             	decl   0xc(%ebp)
  800e6a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e6e:	74 09                	je     800e79 <strnlen+0x27>
  800e70:	8b 45 08             	mov    0x8(%ebp),%eax
  800e73:	8a 00                	mov    (%eax),%al
  800e75:	84 c0                	test   %al,%al
  800e77:	75 e8                	jne    800e61 <strnlen+0xf>
		n++;
	return n;
  800e79:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e7c:	c9                   	leave  
  800e7d:	c3                   	ret    

00800e7e <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800e7e:	55                   	push   %ebp
  800e7f:	89 e5                	mov    %esp,%ebp
  800e81:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800e84:	8b 45 08             	mov    0x8(%ebp),%eax
  800e87:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800e8a:	90                   	nop
  800e8b:	8b 45 08             	mov    0x8(%ebp),%eax
  800e8e:	8d 50 01             	lea    0x1(%eax),%edx
  800e91:	89 55 08             	mov    %edx,0x8(%ebp)
  800e94:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e97:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e9a:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800e9d:	8a 12                	mov    (%edx),%dl
  800e9f:	88 10                	mov    %dl,(%eax)
  800ea1:	8a 00                	mov    (%eax),%al
  800ea3:	84 c0                	test   %al,%al
  800ea5:	75 e4                	jne    800e8b <strcpy+0xd>
		/* do nothing */;
	return ret;
  800ea7:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800eaa:	c9                   	leave  
  800eab:	c3                   	ret    

00800eac <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800eac:	55                   	push   %ebp
  800ead:	89 e5                	mov    %esp,%ebp
  800eaf:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800eb2:	8b 45 08             	mov    0x8(%ebp),%eax
  800eb5:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800eb8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800ebf:	eb 1f                	jmp    800ee0 <strncpy+0x34>
		*dst++ = *src;
  800ec1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ec4:	8d 50 01             	lea    0x1(%eax),%edx
  800ec7:	89 55 08             	mov    %edx,0x8(%ebp)
  800eca:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ecd:	8a 12                	mov    (%edx),%dl
  800ecf:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800ed1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ed4:	8a 00                	mov    (%eax),%al
  800ed6:	84 c0                	test   %al,%al
  800ed8:	74 03                	je     800edd <strncpy+0x31>
			src++;
  800eda:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800edd:	ff 45 fc             	incl   -0x4(%ebp)
  800ee0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ee3:	3b 45 10             	cmp    0x10(%ebp),%eax
  800ee6:	72 d9                	jb     800ec1 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800ee8:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800eeb:	c9                   	leave  
  800eec:	c3                   	ret    

00800eed <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800eed:	55                   	push   %ebp
  800eee:	89 e5                	mov    %esp,%ebp
  800ef0:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800ef3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800ef9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800efd:	74 30                	je     800f2f <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800eff:	eb 16                	jmp    800f17 <strlcpy+0x2a>
			*dst++ = *src++;
  800f01:	8b 45 08             	mov    0x8(%ebp),%eax
  800f04:	8d 50 01             	lea    0x1(%eax),%edx
  800f07:	89 55 08             	mov    %edx,0x8(%ebp)
  800f0a:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f0d:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f10:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800f13:	8a 12                	mov    (%edx),%dl
  800f15:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800f17:	ff 4d 10             	decl   0x10(%ebp)
  800f1a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f1e:	74 09                	je     800f29 <strlcpy+0x3c>
  800f20:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f23:	8a 00                	mov    (%eax),%al
  800f25:	84 c0                	test   %al,%al
  800f27:	75 d8                	jne    800f01 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800f29:	8b 45 08             	mov    0x8(%ebp),%eax
  800f2c:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800f2f:	8b 55 08             	mov    0x8(%ebp),%edx
  800f32:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f35:	29 c2                	sub    %eax,%edx
  800f37:	89 d0                	mov    %edx,%eax
}
  800f39:	c9                   	leave  
  800f3a:	c3                   	ret    

00800f3b <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800f3b:	55                   	push   %ebp
  800f3c:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800f3e:	eb 06                	jmp    800f46 <strcmp+0xb>
		p++, q++;
  800f40:	ff 45 08             	incl   0x8(%ebp)
  800f43:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800f46:	8b 45 08             	mov    0x8(%ebp),%eax
  800f49:	8a 00                	mov    (%eax),%al
  800f4b:	84 c0                	test   %al,%al
  800f4d:	74 0e                	je     800f5d <strcmp+0x22>
  800f4f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f52:	8a 10                	mov    (%eax),%dl
  800f54:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f57:	8a 00                	mov    (%eax),%al
  800f59:	38 c2                	cmp    %al,%dl
  800f5b:	74 e3                	je     800f40 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800f5d:	8b 45 08             	mov    0x8(%ebp),%eax
  800f60:	8a 00                	mov    (%eax),%al
  800f62:	0f b6 d0             	movzbl %al,%edx
  800f65:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f68:	8a 00                	mov    (%eax),%al
  800f6a:	0f b6 c0             	movzbl %al,%eax
  800f6d:	29 c2                	sub    %eax,%edx
  800f6f:	89 d0                	mov    %edx,%eax
}
  800f71:	5d                   	pop    %ebp
  800f72:	c3                   	ret    

00800f73 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800f73:	55                   	push   %ebp
  800f74:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800f76:	eb 09                	jmp    800f81 <strncmp+0xe>
		n--, p++, q++;
  800f78:	ff 4d 10             	decl   0x10(%ebp)
  800f7b:	ff 45 08             	incl   0x8(%ebp)
  800f7e:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800f81:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f85:	74 17                	je     800f9e <strncmp+0x2b>
  800f87:	8b 45 08             	mov    0x8(%ebp),%eax
  800f8a:	8a 00                	mov    (%eax),%al
  800f8c:	84 c0                	test   %al,%al
  800f8e:	74 0e                	je     800f9e <strncmp+0x2b>
  800f90:	8b 45 08             	mov    0x8(%ebp),%eax
  800f93:	8a 10                	mov    (%eax),%dl
  800f95:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f98:	8a 00                	mov    (%eax),%al
  800f9a:	38 c2                	cmp    %al,%dl
  800f9c:	74 da                	je     800f78 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800f9e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fa2:	75 07                	jne    800fab <strncmp+0x38>
		return 0;
  800fa4:	b8 00 00 00 00       	mov    $0x0,%eax
  800fa9:	eb 14                	jmp    800fbf <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800fab:	8b 45 08             	mov    0x8(%ebp),%eax
  800fae:	8a 00                	mov    (%eax),%al
  800fb0:	0f b6 d0             	movzbl %al,%edx
  800fb3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fb6:	8a 00                	mov    (%eax),%al
  800fb8:	0f b6 c0             	movzbl %al,%eax
  800fbb:	29 c2                	sub    %eax,%edx
  800fbd:	89 d0                	mov    %edx,%eax
}
  800fbf:	5d                   	pop    %ebp
  800fc0:	c3                   	ret    

00800fc1 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800fc1:	55                   	push   %ebp
  800fc2:	89 e5                	mov    %esp,%ebp
  800fc4:	83 ec 04             	sub    $0x4,%esp
  800fc7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fca:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800fcd:	eb 12                	jmp    800fe1 <strchr+0x20>
		if (*s == c)
  800fcf:	8b 45 08             	mov    0x8(%ebp),%eax
  800fd2:	8a 00                	mov    (%eax),%al
  800fd4:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800fd7:	75 05                	jne    800fde <strchr+0x1d>
			return (char *) s;
  800fd9:	8b 45 08             	mov    0x8(%ebp),%eax
  800fdc:	eb 11                	jmp    800fef <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800fde:	ff 45 08             	incl   0x8(%ebp)
  800fe1:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe4:	8a 00                	mov    (%eax),%al
  800fe6:	84 c0                	test   %al,%al
  800fe8:	75 e5                	jne    800fcf <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800fea:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800fef:	c9                   	leave  
  800ff0:	c3                   	ret    

00800ff1 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800ff1:	55                   	push   %ebp
  800ff2:	89 e5                	mov    %esp,%ebp
  800ff4:	83 ec 04             	sub    $0x4,%esp
  800ff7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ffa:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800ffd:	eb 0d                	jmp    80100c <strfind+0x1b>
		if (*s == c)
  800fff:	8b 45 08             	mov    0x8(%ebp),%eax
  801002:	8a 00                	mov    (%eax),%al
  801004:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801007:	74 0e                	je     801017 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801009:	ff 45 08             	incl   0x8(%ebp)
  80100c:	8b 45 08             	mov    0x8(%ebp),%eax
  80100f:	8a 00                	mov    (%eax),%al
  801011:	84 c0                	test   %al,%al
  801013:	75 ea                	jne    800fff <strfind+0xe>
  801015:	eb 01                	jmp    801018 <strfind+0x27>
		if (*s == c)
			break;
  801017:	90                   	nop
	return (char *) s;
  801018:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80101b:	c9                   	leave  
  80101c:	c3                   	ret    

0080101d <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  80101d:	55                   	push   %ebp
  80101e:	89 e5                	mov    %esp,%ebp
  801020:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  801023:	8b 45 08             	mov    0x8(%ebp),%eax
  801026:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  801029:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  80102d:	76 63                	jbe    801092 <memset+0x75>
		uint64 data_block = c;
  80102f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801032:	99                   	cltd   
  801033:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801036:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  801039:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80103c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80103f:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  801043:	c1 e0 08             	shl    $0x8,%eax
  801046:	09 45 f0             	or     %eax,-0x10(%ebp)
  801049:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  80104c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80104f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801052:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  801056:	c1 e0 10             	shl    $0x10,%eax
  801059:	09 45 f0             	or     %eax,-0x10(%ebp)
  80105c:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  80105f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801062:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801065:	89 c2                	mov    %eax,%edx
  801067:	b8 00 00 00 00       	mov    $0x0,%eax
  80106c:	09 45 f0             	or     %eax,-0x10(%ebp)
  80106f:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  801072:	eb 18                	jmp    80108c <memset+0x6f>
			*p64++ = data_block, n -= 8;
  801074:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801077:	8d 41 08             	lea    0x8(%ecx),%eax
  80107a:	89 45 fc             	mov    %eax,-0x4(%ebp)
  80107d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801080:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801083:	89 01                	mov    %eax,(%ecx)
  801085:	89 51 04             	mov    %edx,0x4(%ecx)
  801088:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  80108c:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801090:	77 e2                	ja     801074 <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  801092:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801096:	74 23                	je     8010bb <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  801098:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80109b:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  80109e:	eb 0e                	jmp    8010ae <memset+0x91>
			*p8++ = (uint8)c;
  8010a0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010a3:	8d 50 01             	lea    0x1(%eax),%edx
  8010a6:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8010a9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010ac:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  8010ae:	8b 45 10             	mov    0x10(%ebp),%eax
  8010b1:	8d 50 ff             	lea    -0x1(%eax),%edx
  8010b4:	89 55 10             	mov    %edx,0x10(%ebp)
  8010b7:	85 c0                	test   %eax,%eax
  8010b9:	75 e5                	jne    8010a0 <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  8010bb:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8010be:	c9                   	leave  
  8010bf:	c3                   	ret    

008010c0 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  8010c0:	55                   	push   %ebp
  8010c1:	89 e5                	mov    %esp,%ebp
  8010c3:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  8010c6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010c9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  8010cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8010cf:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  8010d2:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  8010d6:	76 24                	jbe    8010fc <memcpy+0x3c>
		while(n >= 8){
  8010d8:	eb 1c                	jmp    8010f6 <memcpy+0x36>
			*d64 = *s64;
  8010da:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010dd:	8b 50 04             	mov    0x4(%eax),%edx
  8010e0:	8b 00                	mov    (%eax),%eax
  8010e2:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8010e5:	89 01                	mov    %eax,(%ecx)
  8010e7:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  8010ea:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  8010ee:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  8010f2:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  8010f6:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  8010fa:	77 de                	ja     8010da <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  8010fc:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801100:	74 31                	je     801133 <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  801102:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801105:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  801108:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80110b:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  80110e:	eb 16                	jmp    801126 <memcpy+0x66>
			*d8++ = *s8++;
  801110:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801113:	8d 50 01             	lea    0x1(%eax),%edx
  801116:	89 55 f0             	mov    %edx,-0x10(%ebp)
  801119:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80111c:	8d 4a 01             	lea    0x1(%edx),%ecx
  80111f:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  801122:	8a 12                	mov    (%edx),%dl
  801124:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  801126:	8b 45 10             	mov    0x10(%ebp),%eax
  801129:	8d 50 ff             	lea    -0x1(%eax),%edx
  80112c:	89 55 10             	mov    %edx,0x10(%ebp)
  80112f:	85 c0                	test   %eax,%eax
  801131:	75 dd                	jne    801110 <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  801133:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801136:	c9                   	leave  
  801137:	c3                   	ret    

00801138 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801138:	55                   	push   %ebp
  801139:	89 e5                	mov    %esp,%ebp
  80113b:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  80113e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801141:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801144:	8b 45 08             	mov    0x8(%ebp),%eax
  801147:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  80114a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80114d:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801150:	73 50                	jae    8011a2 <memmove+0x6a>
  801152:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801155:	8b 45 10             	mov    0x10(%ebp),%eax
  801158:	01 d0                	add    %edx,%eax
  80115a:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80115d:	76 43                	jbe    8011a2 <memmove+0x6a>
		s += n;
  80115f:	8b 45 10             	mov    0x10(%ebp),%eax
  801162:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801165:	8b 45 10             	mov    0x10(%ebp),%eax
  801168:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  80116b:	eb 10                	jmp    80117d <memmove+0x45>
			*--d = *--s;
  80116d:	ff 4d f8             	decl   -0x8(%ebp)
  801170:	ff 4d fc             	decl   -0x4(%ebp)
  801173:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801176:	8a 10                	mov    (%eax),%dl
  801178:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80117b:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  80117d:	8b 45 10             	mov    0x10(%ebp),%eax
  801180:	8d 50 ff             	lea    -0x1(%eax),%edx
  801183:	89 55 10             	mov    %edx,0x10(%ebp)
  801186:	85 c0                	test   %eax,%eax
  801188:	75 e3                	jne    80116d <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  80118a:	eb 23                	jmp    8011af <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  80118c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80118f:	8d 50 01             	lea    0x1(%eax),%edx
  801192:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801195:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801198:	8d 4a 01             	lea    0x1(%edx),%ecx
  80119b:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  80119e:	8a 12                	mov    (%edx),%dl
  8011a0:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  8011a2:	8b 45 10             	mov    0x10(%ebp),%eax
  8011a5:	8d 50 ff             	lea    -0x1(%eax),%edx
  8011a8:	89 55 10             	mov    %edx,0x10(%ebp)
  8011ab:	85 c0                	test   %eax,%eax
  8011ad:	75 dd                	jne    80118c <memmove+0x54>
			*d++ = *s++;

	return dst;
  8011af:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8011b2:	c9                   	leave  
  8011b3:	c3                   	ret    

008011b4 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8011b4:	55                   	push   %ebp
  8011b5:	89 e5                	mov    %esp,%ebp
  8011b7:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  8011ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8011bd:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  8011c0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011c3:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8011c6:	eb 2a                	jmp    8011f2 <memcmp+0x3e>
		if (*s1 != *s2)
  8011c8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011cb:	8a 10                	mov    (%eax),%dl
  8011cd:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011d0:	8a 00                	mov    (%eax),%al
  8011d2:	38 c2                	cmp    %al,%dl
  8011d4:	74 16                	je     8011ec <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  8011d6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011d9:	8a 00                	mov    (%eax),%al
  8011db:	0f b6 d0             	movzbl %al,%edx
  8011de:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011e1:	8a 00                	mov    (%eax),%al
  8011e3:	0f b6 c0             	movzbl %al,%eax
  8011e6:	29 c2                	sub    %eax,%edx
  8011e8:	89 d0                	mov    %edx,%eax
  8011ea:	eb 18                	jmp    801204 <memcmp+0x50>
		s1++, s2++;
  8011ec:	ff 45 fc             	incl   -0x4(%ebp)
  8011ef:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  8011f2:	8b 45 10             	mov    0x10(%ebp),%eax
  8011f5:	8d 50 ff             	lea    -0x1(%eax),%edx
  8011f8:	89 55 10             	mov    %edx,0x10(%ebp)
  8011fb:	85 c0                	test   %eax,%eax
  8011fd:	75 c9                	jne    8011c8 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8011ff:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801204:	c9                   	leave  
  801205:	c3                   	ret    

00801206 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801206:	55                   	push   %ebp
  801207:	89 e5                	mov    %esp,%ebp
  801209:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  80120c:	8b 55 08             	mov    0x8(%ebp),%edx
  80120f:	8b 45 10             	mov    0x10(%ebp),%eax
  801212:	01 d0                	add    %edx,%eax
  801214:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801217:	eb 15                	jmp    80122e <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801219:	8b 45 08             	mov    0x8(%ebp),%eax
  80121c:	8a 00                	mov    (%eax),%al
  80121e:	0f b6 d0             	movzbl %al,%edx
  801221:	8b 45 0c             	mov    0xc(%ebp),%eax
  801224:	0f b6 c0             	movzbl %al,%eax
  801227:	39 c2                	cmp    %eax,%edx
  801229:	74 0d                	je     801238 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80122b:	ff 45 08             	incl   0x8(%ebp)
  80122e:	8b 45 08             	mov    0x8(%ebp),%eax
  801231:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801234:	72 e3                	jb     801219 <memfind+0x13>
  801236:	eb 01                	jmp    801239 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801238:	90                   	nop
	return (void *) s;
  801239:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80123c:	c9                   	leave  
  80123d:	c3                   	ret    

0080123e <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80123e:	55                   	push   %ebp
  80123f:	89 e5                	mov    %esp,%ebp
  801241:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801244:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  80124b:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801252:	eb 03                	jmp    801257 <strtol+0x19>
		s++;
  801254:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801257:	8b 45 08             	mov    0x8(%ebp),%eax
  80125a:	8a 00                	mov    (%eax),%al
  80125c:	3c 20                	cmp    $0x20,%al
  80125e:	74 f4                	je     801254 <strtol+0x16>
  801260:	8b 45 08             	mov    0x8(%ebp),%eax
  801263:	8a 00                	mov    (%eax),%al
  801265:	3c 09                	cmp    $0x9,%al
  801267:	74 eb                	je     801254 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801269:	8b 45 08             	mov    0x8(%ebp),%eax
  80126c:	8a 00                	mov    (%eax),%al
  80126e:	3c 2b                	cmp    $0x2b,%al
  801270:	75 05                	jne    801277 <strtol+0x39>
		s++;
  801272:	ff 45 08             	incl   0x8(%ebp)
  801275:	eb 13                	jmp    80128a <strtol+0x4c>
	else if (*s == '-')
  801277:	8b 45 08             	mov    0x8(%ebp),%eax
  80127a:	8a 00                	mov    (%eax),%al
  80127c:	3c 2d                	cmp    $0x2d,%al
  80127e:	75 0a                	jne    80128a <strtol+0x4c>
		s++, neg = 1;
  801280:	ff 45 08             	incl   0x8(%ebp)
  801283:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80128a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80128e:	74 06                	je     801296 <strtol+0x58>
  801290:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801294:	75 20                	jne    8012b6 <strtol+0x78>
  801296:	8b 45 08             	mov    0x8(%ebp),%eax
  801299:	8a 00                	mov    (%eax),%al
  80129b:	3c 30                	cmp    $0x30,%al
  80129d:	75 17                	jne    8012b6 <strtol+0x78>
  80129f:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a2:	40                   	inc    %eax
  8012a3:	8a 00                	mov    (%eax),%al
  8012a5:	3c 78                	cmp    $0x78,%al
  8012a7:	75 0d                	jne    8012b6 <strtol+0x78>
		s += 2, base = 16;
  8012a9:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8012ad:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8012b4:	eb 28                	jmp    8012de <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8012b6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8012ba:	75 15                	jne    8012d1 <strtol+0x93>
  8012bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8012bf:	8a 00                	mov    (%eax),%al
  8012c1:	3c 30                	cmp    $0x30,%al
  8012c3:	75 0c                	jne    8012d1 <strtol+0x93>
		s++, base = 8;
  8012c5:	ff 45 08             	incl   0x8(%ebp)
  8012c8:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8012cf:	eb 0d                	jmp    8012de <strtol+0xa0>
	else if (base == 0)
  8012d1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8012d5:	75 07                	jne    8012de <strtol+0xa0>
		base = 10;
  8012d7:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8012de:	8b 45 08             	mov    0x8(%ebp),%eax
  8012e1:	8a 00                	mov    (%eax),%al
  8012e3:	3c 2f                	cmp    $0x2f,%al
  8012e5:	7e 19                	jle    801300 <strtol+0xc2>
  8012e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8012ea:	8a 00                	mov    (%eax),%al
  8012ec:	3c 39                	cmp    $0x39,%al
  8012ee:	7f 10                	jg     801300 <strtol+0xc2>
			dig = *s - '0';
  8012f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8012f3:	8a 00                	mov    (%eax),%al
  8012f5:	0f be c0             	movsbl %al,%eax
  8012f8:	83 e8 30             	sub    $0x30,%eax
  8012fb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8012fe:	eb 42                	jmp    801342 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801300:	8b 45 08             	mov    0x8(%ebp),%eax
  801303:	8a 00                	mov    (%eax),%al
  801305:	3c 60                	cmp    $0x60,%al
  801307:	7e 19                	jle    801322 <strtol+0xe4>
  801309:	8b 45 08             	mov    0x8(%ebp),%eax
  80130c:	8a 00                	mov    (%eax),%al
  80130e:	3c 7a                	cmp    $0x7a,%al
  801310:	7f 10                	jg     801322 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801312:	8b 45 08             	mov    0x8(%ebp),%eax
  801315:	8a 00                	mov    (%eax),%al
  801317:	0f be c0             	movsbl %al,%eax
  80131a:	83 e8 57             	sub    $0x57,%eax
  80131d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801320:	eb 20                	jmp    801342 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801322:	8b 45 08             	mov    0x8(%ebp),%eax
  801325:	8a 00                	mov    (%eax),%al
  801327:	3c 40                	cmp    $0x40,%al
  801329:	7e 39                	jle    801364 <strtol+0x126>
  80132b:	8b 45 08             	mov    0x8(%ebp),%eax
  80132e:	8a 00                	mov    (%eax),%al
  801330:	3c 5a                	cmp    $0x5a,%al
  801332:	7f 30                	jg     801364 <strtol+0x126>
			dig = *s - 'A' + 10;
  801334:	8b 45 08             	mov    0x8(%ebp),%eax
  801337:	8a 00                	mov    (%eax),%al
  801339:	0f be c0             	movsbl %al,%eax
  80133c:	83 e8 37             	sub    $0x37,%eax
  80133f:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801342:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801345:	3b 45 10             	cmp    0x10(%ebp),%eax
  801348:	7d 19                	jge    801363 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  80134a:	ff 45 08             	incl   0x8(%ebp)
  80134d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801350:	0f af 45 10          	imul   0x10(%ebp),%eax
  801354:	89 c2                	mov    %eax,%edx
  801356:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801359:	01 d0                	add    %edx,%eax
  80135b:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  80135e:	e9 7b ff ff ff       	jmp    8012de <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801363:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801364:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801368:	74 08                	je     801372 <strtol+0x134>
		*endptr = (char *) s;
  80136a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80136d:	8b 55 08             	mov    0x8(%ebp),%edx
  801370:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801372:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801376:	74 07                	je     80137f <strtol+0x141>
  801378:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80137b:	f7 d8                	neg    %eax
  80137d:	eb 03                	jmp    801382 <strtol+0x144>
  80137f:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801382:	c9                   	leave  
  801383:	c3                   	ret    

00801384 <ltostr>:

void
ltostr(long value, char *str)
{
  801384:	55                   	push   %ebp
  801385:	89 e5                	mov    %esp,%ebp
  801387:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  80138a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801391:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801398:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80139c:	79 13                	jns    8013b1 <ltostr+0x2d>
	{
		neg = 1;
  80139e:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8013a5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013a8:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8013ab:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8013ae:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8013b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8013b4:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8013b9:	99                   	cltd   
  8013ba:	f7 f9                	idiv   %ecx
  8013bc:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8013bf:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8013c2:	8d 50 01             	lea    0x1(%eax),%edx
  8013c5:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8013c8:	89 c2                	mov    %eax,%edx
  8013ca:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013cd:	01 d0                	add    %edx,%eax
  8013cf:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8013d2:	83 c2 30             	add    $0x30,%edx
  8013d5:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8013d7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8013da:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8013df:	f7 e9                	imul   %ecx
  8013e1:	c1 fa 02             	sar    $0x2,%edx
  8013e4:	89 c8                	mov    %ecx,%eax
  8013e6:	c1 f8 1f             	sar    $0x1f,%eax
  8013e9:	29 c2                	sub    %eax,%edx
  8013eb:	89 d0                	mov    %edx,%eax
  8013ed:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  8013f0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8013f4:	75 bb                	jne    8013b1 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8013f6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8013fd:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801400:	48                   	dec    %eax
  801401:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801404:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801408:	74 3d                	je     801447 <ltostr+0xc3>
		start = 1 ;
  80140a:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801411:	eb 34                	jmp    801447 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  801413:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801416:	8b 45 0c             	mov    0xc(%ebp),%eax
  801419:	01 d0                	add    %edx,%eax
  80141b:	8a 00                	mov    (%eax),%al
  80141d:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801420:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801423:	8b 45 0c             	mov    0xc(%ebp),%eax
  801426:	01 c2                	add    %eax,%edx
  801428:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80142b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80142e:	01 c8                	add    %ecx,%eax
  801430:	8a 00                	mov    (%eax),%al
  801432:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801434:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801437:	8b 45 0c             	mov    0xc(%ebp),%eax
  80143a:	01 c2                	add    %eax,%edx
  80143c:	8a 45 eb             	mov    -0x15(%ebp),%al
  80143f:	88 02                	mov    %al,(%edx)
		start++ ;
  801441:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801444:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801447:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80144a:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80144d:	7c c4                	jl     801413 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  80144f:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801452:	8b 45 0c             	mov    0xc(%ebp),%eax
  801455:	01 d0                	add    %edx,%eax
  801457:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  80145a:	90                   	nop
  80145b:	c9                   	leave  
  80145c:	c3                   	ret    

0080145d <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  80145d:	55                   	push   %ebp
  80145e:	89 e5                	mov    %esp,%ebp
  801460:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801463:	ff 75 08             	pushl  0x8(%ebp)
  801466:	e8 c4 f9 ff ff       	call   800e2f <strlen>
  80146b:	83 c4 04             	add    $0x4,%esp
  80146e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801471:	ff 75 0c             	pushl  0xc(%ebp)
  801474:	e8 b6 f9 ff ff       	call   800e2f <strlen>
  801479:	83 c4 04             	add    $0x4,%esp
  80147c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  80147f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801486:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80148d:	eb 17                	jmp    8014a6 <strcconcat+0x49>
		final[s] = str1[s] ;
  80148f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801492:	8b 45 10             	mov    0x10(%ebp),%eax
  801495:	01 c2                	add    %eax,%edx
  801497:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80149a:	8b 45 08             	mov    0x8(%ebp),%eax
  80149d:	01 c8                	add    %ecx,%eax
  80149f:	8a 00                	mov    (%eax),%al
  8014a1:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8014a3:	ff 45 fc             	incl   -0x4(%ebp)
  8014a6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8014a9:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8014ac:	7c e1                	jl     80148f <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8014ae:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8014b5:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8014bc:	eb 1f                	jmp    8014dd <strcconcat+0x80>
		final[s++] = str2[i] ;
  8014be:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8014c1:	8d 50 01             	lea    0x1(%eax),%edx
  8014c4:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8014c7:	89 c2                	mov    %eax,%edx
  8014c9:	8b 45 10             	mov    0x10(%ebp),%eax
  8014cc:	01 c2                	add    %eax,%edx
  8014ce:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8014d1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014d4:	01 c8                	add    %ecx,%eax
  8014d6:	8a 00                	mov    (%eax),%al
  8014d8:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8014da:	ff 45 f8             	incl   -0x8(%ebp)
  8014dd:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8014e0:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8014e3:	7c d9                	jl     8014be <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8014e5:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8014e8:	8b 45 10             	mov    0x10(%ebp),%eax
  8014eb:	01 d0                	add    %edx,%eax
  8014ed:	c6 00 00             	movb   $0x0,(%eax)
}
  8014f0:	90                   	nop
  8014f1:	c9                   	leave  
  8014f2:	c3                   	ret    

008014f3 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8014f3:	55                   	push   %ebp
  8014f4:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8014f6:	8b 45 14             	mov    0x14(%ebp),%eax
  8014f9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8014ff:	8b 45 14             	mov    0x14(%ebp),%eax
  801502:	8b 00                	mov    (%eax),%eax
  801504:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80150b:	8b 45 10             	mov    0x10(%ebp),%eax
  80150e:	01 d0                	add    %edx,%eax
  801510:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801516:	eb 0c                	jmp    801524 <strsplit+0x31>
			*string++ = 0;
  801518:	8b 45 08             	mov    0x8(%ebp),%eax
  80151b:	8d 50 01             	lea    0x1(%eax),%edx
  80151e:	89 55 08             	mov    %edx,0x8(%ebp)
  801521:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801524:	8b 45 08             	mov    0x8(%ebp),%eax
  801527:	8a 00                	mov    (%eax),%al
  801529:	84 c0                	test   %al,%al
  80152b:	74 18                	je     801545 <strsplit+0x52>
  80152d:	8b 45 08             	mov    0x8(%ebp),%eax
  801530:	8a 00                	mov    (%eax),%al
  801532:	0f be c0             	movsbl %al,%eax
  801535:	50                   	push   %eax
  801536:	ff 75 0c             	pushl  0xc(%ebp)
  801539:	e8 83 fa ff ff       	call   800fc1 <strchr>
  80153e:	83 c4 08             	add    $0x8,%esp
  801541:	85 c0                	test   %eax,%eax
  801543:	75 d3                	jne    801518 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801545:	8b 45 08             	mov    0x8(%ebp),%eax
  801548:	8a 00                	mov    (%eax),%al
  80154a:	84 c0                	test   %al,%al
  80154c:	74 5a                	je     8015a8 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  80154e:	8b 45 14             	mov    0x14(%ebp),%eax
  801551:	8b 00                	mov    (%eax),%eax
  801553:	83 f8 0f             	cmp    $0xf,%eax
  801556:	75 07                	jne    80155f <strsplit+0x6c>
		{
			return 0;
  801558:	b8 00 00 00 00       	mov    $0x0,%eax
  80155d:	eb 66                	jmp    8015c5 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  80155f:	8b 45 14             	mov    0x14(%ebp),%eax
  801562:	8b 00                	mov    (%eax),%eax
  801564:	8d 48 01             	lea    0x1(%eax),%ecx
  801567:	8b 55 14             	mov    0x14(%ebp),%edx
  80156a:	89 0a                	mov    %ecx,(%edx)
  80156c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801573:	8b 45 10             	mov    0x10(%ebp),%eax
  801576:	01 c2                	add    %eax,%edx
  801578:	8b 45 08             	mov    0x8(%ebp),%eax
  80157b:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  80157d:	eb 03                	jmp    801582 <strsplit+0x8f>
			string++;
  80157f:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801582:	8b 45 08             	mov    0x8(%ebp),%eax
  801585:	8a 00                	mov    (%eax),%al
  801587:	84 c0                	test   %al,%al
  801589:	74 8b                	je     801516 <strsplit+0x23>
  80158b:	8b 45 08             	mov    0x8(%ebp),%eax
  80158e:	8a 00                	mov    (%eax),%al
  801590:	0f be c0             	movsbl %al,%eax
  801593:	50                   	push   %eax
  801594:	ff 75 0c             	pushl  0xc(%ebp)
  801597:	e8 25 fa ff ff       	call   800fc1 <strchr>
  80159c:	83 c4 08             	add    $0x8,%esp
  80159f:	85 c0                	test   %eax,%eax
  8015a1:	74 dc                	je     80157f <strsplit+0x8c>
			string++;
	}
  8015a3:	e9 6e ff ff ff       	jmp    801516 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8015a8:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8015a9:	8b 45 14             	mov    0x14(%ebp),%eax
  8015ac:	8b 00                	mov    (%eax),%eax
  8015ae:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8015b5:	8b 45 10             	mov    0x10(%ebp),%eax
  8015b8:	01 d0                	add    %edx,%eax
  8015ba:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8015c0:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8015c5:	c9                   	leave  
  8015c6:	c3                   	ret    

008015c7 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  8015c7:	55                   	push   %ebp
  8015c8:	89 e5                	mov    %esp,%ebp
  8015ca:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  8015cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8015d0:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  8015d3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8015da:	eb 4a                	jmp    801626 <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  8015dc:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8015df:	8b 45 08             	mov    0x8(%ebp),%eax
  8015e2:	01 c2                	add    %eax,%edx
  8015e4:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8015e7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015ea:	01 c8                	add    %ecx,%eax
  8015ec:	8a 00                	mov    (%eax),%al
  8015ee:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  8015f0:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8015f3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015f6:	01 d0                	add    %edx,%eax
  8015f8:	8a 00                	mov    (%eax),%al
  8015fa:	3c 40                	cmp    $0x40,%al
  8015fc:	7e 25                	jle    801623 <str2lower+0x5c>
  8015fe:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801601:	8b 45 0c             	mov    0xc(%ebp),%eax
  801604:	01 d0                	add    %edx,%eax
  801606:	8a 00                	mov    (%eax),%al
  801608:	3c 5a                	cmp    $0x5a,%al
  80160a:	7f 17                	jg     801623 <str2lower+0x5c>
		{
			dst[i] += 32 ;
  80160c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80160f:	8b 45 08             	mov    0x8(%ebp),%eax
  801612:	01 d0                	add    %edx,%eax
  801614:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801617:	8b 55 08             	mov    0x8(%ebp),%edx
  80161a:	01 ca                	add    %ecx,%edx
  80161c:	8a 12                	mov    (%edx),%dl
  80161e:	83 c2 20             	add    $0x20,%edx
  801621:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  801623:	ff 45 fc             	incl   -0x4(%ebp)
  801626:	ff 75 0c             	pushl  0xc(%ebp)
  801629:	e8 01 f8 ff ff       	call   800e2f <strlen>
  80162e:	83 c4 04             	add    $0x4,%esp
  801631:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801634:	7f a6                	jg     8015dc <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  801636:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801639:	c9                   	leave  
  80163a:	c3                   	ret    

0080163b <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  80163b:	55                   	push   %ebp
  80163c:	89 e5                	mov    %esp,%ebp
  80163e:	57                   	push   %edi
  80163f:	56                   	push   %esi
  801640:	53                   	push   %ebx
  801641:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801644:	8b 45 08             	mov    0x8(%ebp),%eax
  801647:	8b 55 0c             	mov    0xc(%ebp),%edx
  80164a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80164d:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801650:	8b 7d 18             	mov    0x18(%ebp),%edi
  801653:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801656:	cd 30                	int    $0x30
  801658:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  80165b:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80165e:	83 c4 10             	add    $0x10,%esp
  801661:	5b                   	pop    %ebx
  801662:	5e                   	pop    %esi
  801663:	5f                   	pop    %edi
  801664:	5d                   	pop    %ebp
  801665:	c3                   	ret    

00801666 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  801666:	55                   	push   %ebp
  801667:	89 e5                	mov    %esp,%ebp
  801669:	83 ec 04             	sub    $0x4,%esp
  80166c:	8b 45 10             	mov    0x10(%ebp),%eax
  80166f:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  801672:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801675:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801679:	8b 45 08             	mov    0x8(%ebp),%eax
  80167c:	6a 00                	push   $0x0
  80167e:	51                   	push   %ecx
  80167f:	52                   	push   %edx
  801680:	ff 75 0c             	pushl  0xc(%ebp)
  801683:	50                   	push   %eax
  801684:	6a 00                	push   $0x0
  801686:	e8 b0 ff ff ff       	call   80163b <syscall>
  80168b:	83 c4 18             	add    $0x18,%esp
}
  80168e:	90                   	nop
  80168f:	c9                   	leave  
  801690:	c3                   	ret    

00801691 <sys_cgetc>:

int
sys_cgetc(void)
{
  801691:	55                   	push   %ebp
  801692:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801694:	6a 00                	push   $0x0
  801696:	6a 00                	push   $0x0
  801698:	6a 00                	push   $0x0
  80169a:	6a 00                	push   $0x0
  80169c:	6a 00                	push   $0x0
  80169e:	6a 02                	push   $0x2
  8016a0:	e8 96 ff ff ff       	call   80163b <syscall>
  8016a5:	83 c4 18             	add    $0x18,%esp
}
  8016a8:	c9                   	leave  
  8016a9:	c3                   	ret    

008016aa <sys_lock_cons>:

void sys_lock_cons(void)
{
  8016aa:	55                   	push   %ebp
  8016ab:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  8016ad:	6a 00                	push   $0x0
  8016af:	6a 00                	push   $0x0
  8016b1:	6a 00                	push   $0x0
  8016b3:	6a 00                	push   $0x0
  8016b5:	6a 00                	push   $0x0
  8016b7:	6a 03                	push   $0x3
  8016b9:	e8 7d ff ff ff       	call   80163b <syscall>
  8016be:	83 c4 18             	add    $0x18,%esp
}
  8016c1:	90                   	nop
  8016c2:	c9                   	leave  
  8016c3:	c3                   	ret    

008016c4 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  8016c4:	55                   	push   %ebp
  8016c5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  8016c7:	6a 00                	push   $0x0
  8016c9:	6a 00                	push   $0x0
  8016cb:	6a 00                	push   $0x0
  8016cd:	6a 00                	push   $0x0
  8016cf:	6a 00                	push   $0x0
  8016d1:	6a 04                	push   $0x4
  8016d3:	e8 63 ff ff ff       	call   80163b <syscall>
  8016d8:	83 c4 18             	add    $0x18,%esp
}
  8016db:	90                   	nop
  8016dc:	c9                   	leave  
  8016dd:	c3                   	ret    

008016de <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8016de:	55                   	push   %ebp
  8016df:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8016e1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8016e7:	6a 00                	push   $0x0
  8016e9:	6a 00                	push   $0x0
  8016eb:	6a 00                	push   $0x0
  8016ed:	52                   	push   %edx
  8016ee:	50                   	push   %eax
  8016ef:	6a 08                	push   $0x8
  8016f1:	e8 45 ff ff ff       	call   80163b <syscall>
  8016f6:	83 c4 18             	add    $0x18,%esp
}
  8016f9:	c9                   	leave  
  8016fa:	c3                   	ret    

008016fb <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8016fb:	55                   	push   %ebp
  8016fc:	89 e5                	mov    %esp,%ebp
  8016fe:	56                   	push   %esi
  8016ff:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801700:	8b 75 18             	mov    0x18(%ebp),%esi
  801703:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801706:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801709:	8b 55 0c             	mov    0xc(%ebp),%edx
  80170c:	8b 45 08             	mov    0x8(%ebp),%eax
  80170f:	56                   	push   %esi
  801710:	53                   	push   %ebx
  801711:	51                   	push   %ecx
  801712:	52                   	push   %edx
  801713:	50                   	push   %eax
  801714:	6a 09                	push   $0x9
  801716:	e8 20 ff ff ff       	call   80163b <syscall>
  80171b:	83 c4 18             	add    $0x18,%esp
}
  80171e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801721:	5b                   	pop    %ebx
  801722:	5e                   	pop    %esi
  801723:	5d                   	pop    %ebp
  801724:	c3                   	ret    

00801725 <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  801725:	55                   	push   %ebp
  801726:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  801728:	6a 00                	push   $0x0
  80172a:	6a 00                	push   $0x0
  80172c:	6a 00                	push   $0x0
  80172e:	6a 00                	push   $0x0
  801730:	ff 75 08             	pushl  0x8(%ebp)
  801733:	6a 0a                	push   $0xa
  801735:	e8 01 ff ff ff       	call   80163b <syscall>
  80173a:	83 c4 18             	add    $0x18,%esp
}
  80173d:	c9                   	leave  
  80173e:	c3                   	ret    

0080173f <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  80173f:	55                   	push   %ebp
  801740:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801742:	6a 00                	push   $0x0
  801744:	6a 00                	push   $0x0
  801746:	6a 00                	push   $0x0
  801748:	ff 75 0c             	pushl  0xc(%ebp)
  80174b:	ff 75 08             	pushl  0x8(%ebp)
  80174e:	6a 0b                	push   $0xb
  801750:	e8 e6 fe ff ff       	call   80163b <syscall>
  801755:	83 c4 18             	add    $0x18,%esp
}
  801758:	c9                   	leave  
  801759:	c3                   	ret    

0080175a <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  80175a:	55                   	push   %ebp
  80175b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  80175d:	6a 00                	push   $0x0
  80175f:	6a 00                	push   $0x0
  801761:	6a 00                	push   $0x0
  801763:	6a 00                	push   $0x0
  801765:	6a 00                	push   $0x0
  801767:	6a 0c                	push   $0xc
  801769:	e8 cd fe ff ff       	call   80163b <syscall>
  80176e:	83 c4 18             	add    $0x18,%esp
}
  801771:	c9                   	leave  
  801772:	c3                   	ret    

00801773 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801773:	55                   	push   %ebp
  801774:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801776:	6a 00                	push   $0x0
  801778:	6a 00                	push   $0x0
  80177a:	6a 00                	push   $0x0
  80177c:	6a 00                	push   $0x0
  80177e:	6a 00                	push   $0x0
  801780:	6a 0d                	push   $0xd
  801782:	e8 b4 fe ff ff       	call   80163b <syscall>
  801787:	83 c4 18             	add    $0x18,%esp
}
  80178a:	c9                   	leave  
  80178b:	c3                   	ret    

0080178c <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  80178c:	55                   	push   %ebp
  80178d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  80178f:	6a 00                	push   $0x0
  801791:	6a 00                	push   $0x0
  801793:	6a 00                	push   $0x0
  801795:	6a 00                	push   $0x0
  801797:	6a 00                	push   $0x0
  801799:	6a 0e                	push   $0xe
  80179b:	e8 9b fe ff ff       	call   80163b <syscall>
  8017a0:	83 c4 18             	add    $0x18,%esp
}
  8017a3:	c9                   	leave  
  8017a4:	c3                   	ret    

008017a5 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8017a5:	55                   	push   %ebp
  8017a6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8017a8:	6a 00                	push   $0x0
  8017aa:	6a 00                	push   $0x0
  8017ac:	6a 00                	push   $0x0
  8017ae:	6a 00                	push   $0x0
  8017b0:	6a 00                	push   $0x0
  8017b2:	6a 0f                	push   $0xf
  8017b4:	e8 82 fe ff ff       	call   80163b <syscall>
  8017b9:	83 c4 18             	add    $0x18,%esp
}
  8017bc:	c9                   	leave  
  8017bd:	c3                   	ret    

008017be <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8017be:	55                   	push   %ebp
  8017bf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8017c1:	6a 00                	push   $0x0
  8017c3:	6a 00                	push   $0x0
  8017c5:	6a 00                	push   $0x0
  8017c7:	6a 00                	push   $0x0
  8017c9:	ff 75 08             	pushl  0x8(%ebp)
  8017cc:	6a 10                	push   $0x10
  8017ce:	e8 68 fe ff ff       	call   80163b <syscall>
  8017d3:	83 c4 18             	add    $0x18,%esp
}
  8017d6:	c9                   	leave  
  8017d7:	c3                   	ret    

008017d8 <sys_scarce_memory>:

void sys_scarce_memory()
{
  8017d8:	55                   	push   %ebp
  8017d9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8017db:	6a 00                	push   $0x0
  8017dd:	6a 00                	push   $0x0
  8017df:	6a 00                	push   $0x0
  8017e1:	6a 00                	push   $0x0
  8017e3:	6a 00                	push   $0x0
  8017e5:	6a 11                	push   $0x11
  8017e7:	e8 4f fe ff ff       	call   80163b <syscall>
  8017ec:	83 c4 18             	add    $0x18,%esp
}
  8017ef:	90                   	nop
  8017f0:	c9                   	leave  
  8017f1:	c3                   	ret    

008017f2 <sys_cputc>:

void
sys_cputc(const char c)
{
  8017f2:	55                   	push   %ebp
  8017f3:	89 e5                	mov    %esp,%ebp
  8017f5:	83 ec 04             	sub    $0x4,%esp
  8017f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8017fb:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8017fe:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801802:	6a 00                	push   $0x0
  801804:	6a 00                	push   $0x0
  801806:	6a 00                	push   $0x0
  801808:	6a 00                	push   $0x0
  80180a:	50                   	push   %eax
  80180b:	6a 01                	push   $0x1
  80180d:	e8 29 fe ff ff       	call   80163b <syscall>
  801812:	83 c4 18             	add    $0x18,%esp
}
  801815:	90                   	nop
  801816:	c9                   	leave  
  801817:	c3                   	ret    

00801818 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801818:	55                   	push   %ebp
  801819:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  80181b:	6a 00                	push   $0x0
  80181d:	6a 00                	push   $0x0
  80181f:	6a 00                	push   $0x0
  801821:	6a 00                	push   $0x0
  801823:	6a 00                	push   $0x0
  801825:	6a 14                	push   $0x14
  801827:	e8 0f fe ff ff       	call   80163b <syscall>
  80182c:	83 c4 18             	add    $0x18,%esp
}
  80182f:	90                   	nop
  801830:	c9                   	leave  
  801831:	c3                   	ret    

00801832 <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801832:	55                   	push   %ebp
  801833:	89 e5                	mov    %esp,%ebp
  801835:	83 ec 04             	sub    $0x4,%esp
  801838:	8b 45 10             	mov    0x10(%ebp),%eax
  80183b:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  80183e:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801841:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801845:	8b 45 08             	mov    0x8(%ebp),%eax
  801848:	6a 00                	push   $0x0
  80184a:	51                   	push   %ecx
  80184b:	52                   	push   %edx
  80184c:	ff 75 0c             	pushl  0xc(%ebp)
  80184f:	50                   	push   %eax
  801850:	6a 15                	push   $0x15
  801852:	e8 e4 fd ff ff       	call   80163b <syscall>
  801857:	83 c4 18             	add    $0x18,%esp
}
  80185a:	c9                   	leave  
  80185b:	c3                   	ret    

0080185c <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  80185c:	55                   	push   %ebp
  80185d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  80185f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801862:	8b 45 08             	mov    0x8(%ebp),%eax
  801865:	6a 00                	push   $0x0
  801867:	6a 00                	push   $0x0
  801869:	6a 00                	push   $0x0
  80186b:	52                   	push   %edx
  80186c:	50                   	push   %eax
  80186d:	6a 16                	push   $0x16
  80186f:	e8 c7 fd ff ff       	call   80163b <syscall>
  801874:	83 c4 18             	add    $0x18,%esp
}
  801877:	c9                   	leave  
  801878:	c3                   	ret    

00801879 <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  801879:	55                   	push   %ebp
  80187a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  80187c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80187f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801882:	8b 45 08             	mov    0x8(%ebp),%eax
  801885:	6a 00                	push   $0x0
  801887:	6a 00                	push   $0x0
  801889:	51                   	push   %ecx
  80188a:	52                   	push   %edx
  80188b:	50                   	push   %eax
  80188c:	6a 17                	push   $0x17
  80188e:	e8 a8 fd ff ff       	call   80163b <syscall>
  801893:	83 c4 18             	add    $0x18,%esp
}
  801896:	c9                   	leave  
  801897:	c3                   	ret    

00801898 <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  801898:	55                   	push   %ebp
  801899:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  80189b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80189e:	8b 45 08             	mov    0x8(%ebp),%eax
  8018a1:	6a 00                	push   $0x0
  8018a3:	6a 00                	push   $0x0
  8018a5:	6a 00                	push   $0x0
  8018a7:	52                   	push   %edx
  8018a8:	50                   	push   %eax
  8018a9:	6a 18                	push   $0x18
  8018ab:	e8 8b fd ff ff       	call   80163b <syscall>
  8018b0:	83 c4 18             	add    $0x18,%esp
}
  8018b3:	c9                   	leave  
  8018b4:	c3                   	ret    

008018b5 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8018b5:	55                   	push   %ebp
  8018b6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8018b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8018bb:	6a 00                	push   $0x0
  8018bd:	ff 75 14             	pushl  0x14(%ebp)
  8018c0:	ff 75 10             	pushl  0x10(%ebp)
  8018c3:	ff 75 0c             	pushl  0xc(%ebp)
  8018c6:	50                   	push   %eax
  8018c7:	6a 19                	push   $0x19
  8018c9:	e8 6d fd ff ff       	call   80163b <syscall>
  8018ce:	83 c4 18             	add    $0x18,%esp
}
  8018d1:	c9                   	leave  
  8018d2:	c3                   	ret    

008018d3 <sys_run_env>:

void sys_run_env(int32 envId)
{
  8018d3:	55                   	push   %ebp
  8018d4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8018d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8018d9:	6a 00                	push   $0x0
  8018db:	6a 00                	push   $0x0
  8018dd:	6a 00                	push   $0x0
  8018df:	6a 00                	push   $0x0
  8018e1:	50                   	push   %eax
  8018e2:	6a 1a                	push   $0x1a
  8018e4:	e8 52 fd ff ff       	call   80163b <syscall>
  8018e9:	83 c4 18             	add    $0x18,%esp
}
  8018ec:	90                   	nop
  8018ed:	c9                   	leave  
  8018ee:	c3                   	ret    

008018ef <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8018ef:	55                   	push   %ebp
  8018f0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8018f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8018f5:	6a 00                	push   $0x0
  8018f7:	6a 00                	push   $0x0
  8018f9:	6a 00                	push   $0x0
  8018fb:	6a 00                	push   $0x0
  8018fd:	50                   	push   %eax
  8018fe:	6a 1b                	push   $0x1b
  801900:	e8 36 fd ff ff       	call   80163b <syscall>
  801905:	83 c4 18             	add    $0x18,%esp
}
  801908:	c9                   	leave  
  801909:	c3                   	ret    

0080190a <sys_getenvid>:

int32 sys_getenvid(void)
{
  80190a:	55                   	push   %ebp
  80190b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  80190d:	6a 00                	push   $0x0
  80190f:	6a 00                	push   $0x0
  801911:	6a 00                	push   $0x0
  801913:	6a 00                	push   $0x0
  801915:	6a 00                	push   $0x0
  801917:	6a 05                	push   $0x5
  801919:	e8 1d fd ff ff       	call   80163b <syscall>
  80191e:	83 c4 18             	add    $0x18,%esp
}
  801921:	c9                   	leave  
  801922:	c3                   	ret    

00801923 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801923:	55                   	push   %ebp
  801924:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801926:	6a 00                	push   $0x0
  801928:	6a 00                	push   $0x0
  80192a:	6a 00                	push   $0x0
  80192c:	6a 00                	push   $0x0
  80192e:	6a 00                	push   $0x0
  801930:	6a 06                	push   $0x6
  801932:	e8 04 fd ff ff       	call   80163b <syscall>
  801937:	83 c4 18             	add    $0x18,%esp
}
  80193a:	c9                   	leave  
  80193b:	c3                   	ret    

0080193c <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  80193c:	55                   	push   %ebp
  80193d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  80193f:	6a 00                	push   $0x0
  801941:	6a 00                	push   $0x0
  801943:	6a 00                	push   $0x0
  801945:	6a 00                	push   $0x0
  801947:	6a 00                	push   $0x0
  801949:	6a 07                	push   $0x7
  80194b:	e8 eb fc ff ff       	call   80163b <syscall>
  801950:	83 c4 18             	add    $0x18,%esp
}
  801953:	c9                   	leave  
  801954:	c3                   	ret    

00801955 <sys_exit_env>:


void sys_exit_env(void)
{
  801955:	55                   	push   %ebp
  801956:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801958:	6a 00                	push   $0x0
  80195a:	6a 00                	push   $0x0
  80195c:	6a 00                	push   $0x0
  80195e:	6a 00                	push   $0x0
  801960:	6a 00                	push   $0x0
  801962:	6a 1c                	push   $0x1c
  801964:	e8 d2 fc ff ff       	call   80163b <syscall>
  801969:	83 c4 18             	add    $0x18,%esp
}
  80196c:	90                   	nop
  80196d:	c9                   	leave  
  80196e:	c3                   	ret    

0080196f <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  80196f:	55                   	push   %ebp
  801970:	89 e5                	mov    %esp,%ebp
  801972:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801975:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801978:	8d 50 04             	lea    0x4(%eax),%edx
  80197b:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80197e:	6a 00                	push   $0x0
  801980:	6a 00                	push   $0x0
  801982:	6a 00                	push   $0x0
  801984:	52                   	push   %edx
  801985:	50                   	push   %eax
  801986:	6a 1d                	push   $0x1d
  801988:	e8 ae fc ff ff       	call   80163b <syscall>
  80198d:	83 c4 18             	add    $0x18,%esp
	return result;
  801990:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801993:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801996:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801999:	89 01                	mov    %eax,(%ecx)
  80199b:	89 51 04             	mov    %edx,0x4(%ecx)
}
  80199e:	8b 45 08             	mov    0x8(%ebp),%eax
  8019a1:	c9                   	leave  
  8019a2:	c2 04 00             	ret    $0x4

008019a5 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8019a5:	55                   	push   %ebp
  8019a6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8019a8:	6a 00                	push   $0x0
  8019aa:	6a 00                	push   $0x0
  8019ac:	ff 75 10             	pushl  0x10(%ebp)
  8019af:	ff 75 0c             	pushl  0xc(%ebp)
  8019b2:	ff 75 08             	pushl  0x8(%ebp)
  8019b5:	6a 13                	push   $0x13
  8019b7:	e8 7f fc ff ff       	call   80163b <syscall>
  8019bc:	83 c4 18             	add    $0x18,%esp
	return ;
  8019bf:	90                   	nop
}
  8019c0:	c9                   	leave  
  8019c1:	c3                   	ret    

008019c2 <sys_rcr2>:
uint32 sys_rcr2()
{
  8019c2:	55                   	push   %ebp
  8019c3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8019c5:	6a 00                	push   $0x0
  8019c7:	6a 00                	push   $0x0
  8019c9:	6a 00                	push   $0x0
  8019cb:	6a 00                	push   $0x0
  8019cd:	6a 00                	push   $0x0
  8019cf:	6a 1e                	push   $0x1e
  8019d1:	e8 65 fc ff ff       	call   80163b <syscall>
  8019d6:	83 c4 18             	add    $0x18,%esp
}
  8019d9:	c9                   	leave  
  8019da:	c3                   	ret    

008019db <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  8019db:	55                   	push   %ebp
  8019dc:	89 e5                	mov    %esp,%ebp
  8019de:	83 ec 04             	sub    $0x4,%esp
  8019e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8019e4:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8019e7:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8019eb:	6a 00                	push   $0x0
  8019ed:	6a 00                	push   $0x0
  8019ef:	6a 00                	push   $0x0
  8019f1:	6a 00                	push   $0x0
  8019f3:	50                   	push   %eax
  8019f4:	6a 1f                	push   $0x1f
  8019f6:	e8 40 fc ff ff       	call   80163b <syscall>
  8019fb:	83 c4 18             	add    $0x18,%esp
	return ;
  8019fe:	90                   	nop
}
  8019ff:	c9                   	leave  
  801a00:	c3                   	ret    

00801a01 <rsttst>:
void rsttst()
{
  801a01:	55                   	push   %ebp
  801a02:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801a04:	6a 00                	push   $0x0
  801a06:	6a 00                	push   $0x0
  801a08:	6a 00                	push   $0x0
  801a0a:	6a 00                	push   $0x0
  801a0c:	6a 00                	push   $0x0
  801a0e:	6a 21                	push   $0x21
  801a10:	e8 26 fc ff ff       	call   80163b <syscall>
  801a15:	83 c4 18             	add    $0x18,%esp
	return ;
  801a18:	90                   	nop
}
  801a19:	c9                   	leave  
  801a1a:	c3                   	ret    

00801a1b <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801a1b:	55                   	push   %ebp
  801a1c:	89 e5                	mov    %esp,%ebp
  801a1e:	83 ec 04             	sub    $0x4,%esp
  801a21:	8b 45 14             	mov    0x14(%ebp),%eax
  801a24:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801a27:	8b 55 18             	mov    0x18(%ebp),%edx
  801a2a:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801a2e:	52                   	push   %edx
  801a2f:	50                   	push   %eax
  801a30:	ff 75 10             	pushl  0x10(%ebp)
  801a33:	ff 75 0c             	pushl  0xc(%ebp)
  801a36:	ff 75 08             	pushl  0x8(%ebp)
  801a39:	6a 20                	push   $0x20
  801a3b:	e8 fb fb ff ff       	call   80163b <syscall>
  801a40:	83 c4 18             	add    $0x18,%esp
	return ;
  801a43:	90                   	nop
}
  801a44:	c9                   	leave  
  801a45:	c3                   	ret    

00801a46 <chktst>:
void chktst(uint32 n)
{
  801a46:	55                   	push   %ebp
  801a47:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801a49:	6a 00                	push   $0x0
  801a4b:	6a 00                	push   $0x0
  801a4d:	6a 00                	push   $0x0
  801a4f:	6a 00                	push   $0x0
  801a51:	ff 75 08             	pushl  0x8(%ebp)
  801a54:	6a 22                	push   $0x22
  801a56:	e8 e0 fb ff ff       	call   80163b <syscall>
  801a5b:	83 c4 18             	add    $0x18,%esp
	return ;
  801a5e:	90                   	nop
}
  801a5f:	c9                   	leave  
  801a60:	c3                   	ret    

00801a61 <inctst>:

void inctst()
{
  801a61:	55                   	push   %ebp
  801a62:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801a64:	6a 00                	push   $0x0
  801a66:	6a 00                	push   $0x0
  801a68:	6a 00                	push   $0x0
  801a6a:	6a 00                	push   $0x0
  801a6c:	6a 00                	push   $0x0
  801a6e:	6a 23                	push   $0x23
  801a70:	e8 c6 fb ff ff       	call   80163b <syscall>
  801a75:	83 c4 18             	add    $0x18,%esp
	return ;
  801a78:	90                   	nop
}
  801a79:	c9                   	leave  
  801a7a:	c3                   	ret    

00801a7b <gettst>:
uint32 gettst()
{
  801a7b:	55                   	push   %ebp
  801a7c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801a7e:	6a 00                	push   $0x0
  801a80:	6a 00                	push   $0x0
  801a82:	6a 00                	push   $0x0
  801a84:	6a 00                	push   $0x0
  801a86:	6a 00                	push   $0x0
  801a88:	6a 24                	push   $0x24
  801a8a:	e8 ac fb ff ff       	call   80163b <syscall>
  801a8f:	83 c4 18             	add    $0x18,%esp
}
  801a92:	c9                   	leave  
  801a93:	c3                   	ret    

00801a94 <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  801a94:	55                   	push   %ebp
  801a95:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801a97:	6a 00                	push   $0x0
  801a99:	6a 00                	push   $0x0
  801a9b:	6a 00                	push   $0x0
  801a9d:	6a 00                	push   $0x0
  801a9f:	6a 00                	push   $0x0
  801aa1:	6a 25                	push   $0x25
  801aa3:	e8 93 fb ff ff       	call   80163b <syscall>
  801aa8:	83 c4 18             	add    $0x18,%esp
  801aab:	a3 40 71 82 00       	mov    %eax,0x827140
	return uheapPlaceStrategy ;
  801ab0:	a1 40 71 82 00       	mov    0x827140,%eax
}
  801ab5:	c9                   	leave  
  801ab6:	c3                   	ret    

00801ab7 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801ab7:	55                   	push   %ebp
  801ab8:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  801aba:	8b 45 08             	mov    0x8(%ebp),%eax
  801abd:	a3 40 71 82 00       	mov    %eax,0x827140
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801ac2:	6a 00                	push   $0x0
  801ac4:	6a 00                	push   $0x0
  801ac6:	6a 00                	push   $0x0
  801ac8:	6a 00                	push   $0x0
  801aca:	ff 75 08             	pushl  0x8(%ebp)
  801acd:	6a 26                	push   $0x26
  801acf:	e8 67 fb ff ff       	call   80163b <syscall>
  801ad4:	83 c4 18             	add    $0x18,%esp
	return ;
  801ad7:	90                   	nop
}
  801ad8:	c9                   	leave  
  801ad9:	c3                   	ret    

00801ada <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801ada:	55                   	push   %ebp
  801adb:	89 e5                	mov    %esp,%ebp
  801add:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801ade:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801ae1:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801ae4:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ae7:	8b 45 08             	mov    0x8(%ebp),%eax
  801aea:	6a 00                	push   $0x0
  801aec:	53                   	push   %ebx
  801aed:	51                   	push   %ecx
  801aee:	52                   	push   %edx
  801aef:	50                   	push   %eax
  801af0:	6a 27                	push   $0x27
  801af2:	e8 44 fb ff ff       	call   80163b <syscall>
  801af7:	83 c4 18             	add    $0x18,%esp
}
  801afa:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801afd:	c9                   	leave  
  801afe:	c3                   	ret    

00801aff <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801aff:	55                   	push   %ebp
  801b00:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801b02:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b05:	8b 45 08             	mov    0x8(%ebp),%eax
  801b08:	6a 00                	push   $0x0
  801b0a:	6a 00                	push   $0x0
  801b0c:	6a 00                	push   $0x0
  801b0e:	52                   	push   %edx
  801b0f:	50                   	push   %eax
  801b10:	6a 28                	push   $0x28
  801b12:	e8 24 fb ff ff       	call   80163b <syscall>
  801b17:	83 c4 18             	add    $0x18,%esp
}
  801b1a:	c9                   	leave  
  801b1b:	c3                   	ret    

00801b1c <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801b1c:	55                   	push   %ebp
  801b1d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801b1f:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801b22:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b25:	8b 45 08             	mov    0x8(%ebp),%eax
  801b28:	6a 00                	push   $0x0
  801b2a:	51                   	push   %ecx
  801b2b:	ff 75 10             	pushl  0x10(%ebp)
  801b2e:	52                   	push   %edx
  801b2f:	50                   	push   %eax
  801b30:	6a 29                	push   $0x29
  801b32:	e8 04 fb ff ff       	call   80163b <syscall>
  801b37:	83 c4 18             	add    $0x18,%esp
}
  801b3a:	c9                   	leave  
  801b3b:	c3                   	ret    

00801b3c <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801b3c:	55                   	push   %ebp
  801b3d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801b3f:	6a 00                	push   $0x0
  801b41:	6a 00                	push   $0x0
  801b43:	ff 75 10             	pushl  0x10(%ebp)
  801b46:	ff 75 0c             	pushl  0xc(%ebp)
  801b49:	ff 75 08             	pushl  0x8(%ebp)
  801b4c:	6a 12                	push   $0x12
  801b4e:	e8 e8 fa ff ff       	call   80163b <syscall>
  801b53:	83 c4 18             	add    $0x18,%esp
	return ;
  801b56:	90                   	nop
}
  801b57:	c9                   	leave  
  801b58:	c3                   	ret    

00801b59 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  801b59:	55                   	push   %ebp
  801b5a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  801b5c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b5f:	8b 45 08             	mov    0x8(%ebp),%eax
  801b62:	6a 00                	push   $0x0
  801b64:	6a 00                	push   $0x0
  801b66:	6a 00                	push   $0x0
  801b68:	52                   	push   %edx
  801b69:	50                   	push   %eax
  801b6a:	6a 2a                	push   $0x2a
  801b6c:	e8 ca fa ff ff       	call   80163b <syscall>
  801b71:	83 c4 18             	add    $0x18,%esp
	return;
  801b74:	90                   	nop
}
  801b75:	c9                   	leave  
  801b76:	c3                   	ret    

00801b77 <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  801b77:	55                   	push   %ebp
  801b78:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  801b7a:	6a 00                	push   $0x0
  801b7c:	6a 00                	push   $0x0
  801b7e:	6a 00                	push   $0x0
  801b80:	6a 00                	push   $0x0
  801b82:	6a 00                	push   $0x0
  801b84:	6a 2b                	push   $0x2b
  801b86:	e8 b0 fa ff ff       	call   80163b <syscall>
  801b8b:	83 c4 18             	add    $0x18,%esp
}
  801b8e:	c9                   	leave  
  801b8f:	c3                   	ret    

00801b90 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801b90:	55                   	push   %ebp
  801b91:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801b93:	6a 00                	push   $0x0
  801b95:	6a 00                	push   $0x0
  801b97:	6a 00                	push   $0x0
  801b99:	ff 75 0c             	pushl  0xc(%ebp)
  801b9c:	ff 75 08             	pushl  0x8(%ebp)
  801b9f:	6a 2d                	push   $0x2d
  801ba1:	e8 95 fa ff ff       	call   80163b <syscall>
  801ba6:	83 c4 18             	add    $0x18,%esp
	return;
  801ba9:	90                   	nop
}
  801baa:	c9                   	leave  
  801bab:	c3                   	ret    

00801bac <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801bac:	55                   	push   %ebp
  801bad:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801baf:	6a 00                	push   $0x0
  801bb1:	6a 00                	push   $0x0
  801bb3:	6a 00                	push   $0x0
  801bb5:	ff 75 0c             	pushl  0xc(%ebp)
  801bb8:	ff 75 08             	pushl  0x8(%ebp)
  801bbb:	6a 2c                	push   $0x2c
  801bbd:	e8 79 fa ff ff       	call   80163b <syscall>
  801bc2:	83 c4 18             	add    $0x18,%esp
	return ;
  801bc5:	90                   	nop
}
  801bc6:	c9                   	leave  
  801bc7:	c3                   	ret    

00801bc8 <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  801bc8:	55                   	push   %ebp
  801bc9:	89 e5                	mov    %esp,%ebp
	//TODO: [PROJECT'25.IM#4] CPU SCHEDULING - #1 System Calls - Add suitable code here
	//Your code is here
	//Comment the following line
	//panic("sys_env_set_priority() is not implemented yet...!!");
	syscall(SYS_env_set_priority, envID, priority, 0, 0, 0);
  801bcb:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bce:	8b 45 08             	mov    0x8(%ebp),%eax
  801bd1:	6a 00                	push   $0x0
  801bd3:	6a 00                	push   $0x0
  801bd5:	6a 00                	push   $0x0
  801bd7:	52                   	push   %edx
  801bd8:	50                   	push   %eax
  801bd9:	6a 2e                	push   $0x2e
  801bdb:	e8 5b fa ff ff       	call   80163b <syscall>
  801be0:	83 c4 18             	add    $0x18,%esp
	    return;
  801be3:	90                   	nop
}
  801be4:	c9                   	leave  
  801be5:	c3                   	ret    
  801be6:	66 90                	xchg   %ax,%ax

00801be8 <__udivdi3>:
  801be8:	55                   	push   %ebp
  801be9:	57                   	push   %edi
  801bea:	56                   	push   %esi
  801beb:	53                   	push   %ebx
  801bec:	83 ec 1c             	sub    $0x1c,%esp
  801bef:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801bf3:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801bf7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801bfb:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801bff:	89 ca                	mov    %ecx,%edx
  801c01:	89 f8                	mov    %edi,%eax
  801c03:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801c07:	85 f6                	test   %esi,%esi
  801c09:	75 2d                	jne    801c38 <__udivdi3+0x50>
  801c0b:	39 cf                	cmp    %ecx,%edi
  801c0d:	77 65                	ja     801c74 <__udivdi3+0x8c>
  801c0f:	89 fd                	mov    %edi,%ebp
  801c11:	85 ff                	test   %edi,%edi
  801c13:	75 0b                	jne    801c20 <__udivdi3+0x38>
  801c15:	b8 01 00 00 00       	mov    $0x1,%eax
  801c1a:	31 d2                	xor    %edx,%edx
  801c1c:	f7 f7                	div    %edi
  801c1e:	89 c5                	mov    %eax,%ebp
  801c20:	31 d2                	xor    %edx,%edx
  801c22:	89 c8                	mov    %ecx,%eax
  801c24:	f7 f5                	div    %ebp
  801c26:	89 c1                	mov    %eax,%ecx
  801c28:	89 d8                	mov    %ebx,%eax
  801c2a:	f7 f5                	div    %ebp
  801c2c:	89 cf                	mov    %ecx,%edi
  801c2e:	89 fa                	mov    %edi,%edx
  801c30:	83 c4 1c             	add    $0x1c,%esp
  801c33:	5b                   	pop    %ebx
  801c34:	5e                   	pop    %esi
  801c35:	5f                   	pop    %edi
  801c36:	5d                   	pop    %ebp
  801c37:	c3                   	ret    
  801c38:	39 ce                	cmp    %ecx,%esi
  801c3a:	77 28                	ja     801c64 <__udivdi3+0x7c>
  801c3c:	0f bd fe             	bsr    %esi,%edi
  801c3f:	83 f7 1f             	xor    $0x1f,%edi
  801c42:	75 40                	jne    801c84 <__udivdi3+0x9c>
  801c44:	39 ce                	cmp    %ecx,%esi
  801c46:	72 0a                	jb     801c52 <__udivdi3+0x6a>
  801c48:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801c4c:	0f 87 9e 00 00 00    	ja     801cf0 <__udivdi3+0x108>
  801c52:	b8 01 00 00 00       	mov    $0x1,%eax
  801c57:	89 fa                	mov    %edi,%edx
  801c59:	83 c4 1c             	add    $0x1c,%esp
  801c5c:	5b                   	pop    %ebx
  801c5d:	5e                   	pop    %esi
  801c5e:	5f                   	pop    %edi
  801c5f:	5d                   	pop    %ebp
  801c60:	c3                   	ret    
  801c61:	8d 76 00             	lea    0x0(%esi),%esi
  801c64:	31 ff                	xor    %edi,%edi
  801c66:	31 c0                	xor    %eax,%eax
  801c68:	89 fa                	mov    %edi,%edx
  801c6a:	83 c4 1c             	add    $0x1c,%esp
  801c6d:	5b                   	pop    %ebx
  801c6e:	5e                   	pop    %esi
  801c6f:	5f                   	pop    %edi
  801c70:	5d                   	pop    %ebp
  801c71:	c3                   	ret    
  801c72:	66 90                	xchg   %ax,%ax
  801c74:	89 d8                	mov    %ebx,%eax
  801c76:	f7 f7                	div    %edi
  801c78:	31 ff                	xor    %edi,%edi
  801c7a:	89 fa                	mov    %edi,%edx
  801c7c:	83 c4 1c             	add    $0x1c,%esp
  801c7f:	5b                   	pop    %ebx
  801c80:	5e                   	pop    %esi
  801c81:	5f                   	pop    %edi
  801c82:	5d                   	pop    %ebp
  801c83:	c3                   	ret    
  801c84:	bd 20 00 00 00       	mov    $0x20,%ebp
  801c89:	89 eb                	mov    %ebp,%ebx
  801c8b:	29 fb                	sub    %edi,%ebx
  801c8d:	89 f9                	mov    %edi,%ecx
  801c8f:	d3 e6                	shl    %cl,%esi
  801c91:	89 c5                	mov    %eax,%ebp
  801c93:	88 d9                	mov    %bl,%cl
  801c95:	d3 ed                	shr    %cl,%ebp
  801c97:	89 e9                	mov    %ebp,%ecx
  801c99:	09 f1                	or     %esi,%ecx
  801c9b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801c9f:	89 f9                	mov    %edi,%ecx
  801ca1:	d3 e0                	shl    %cl,%eax
  801ca3:	89 c5                	mov    %eax,%ebp
  801ca5:	89 d6                	mov    %edx,%esi
  801ca7:	88 d9                	mov    %bl,%cl
  801ca9:	d3 ee                	shr    %cl,%esi
  801cab:	89 f9                	mov    %edi,%ecx
  801cad:	d3 e2                	shl    %cl,%edx
  801caf:	8b 44 24 08          	mov    0x8(%esp),%eax
  801cb3:	88 d9                	mov    %bl,%cl
  801cb5:	d3 e8                	shr    %cl,%eax
  801cb7:	09 c2                	or     %eax,%edx
  801cb9:	89 d0                	mov    %edx,%eax
  801cbb:	89 f2                	mov    %esi,%edx
  801cbd:	f7 74 24 0c          	divl   0xc(%esp)
  801cc1:	89 d6                	mov    %edx,%esi
  801cc3:	89 c3                	mov    %eax,%ebx
  801cc5:	f7 e5                	mul    %ebp
  801cc7:	39 d6                	cmp    %edx,%esi
  801cc9:	72 19                	jb     801ce4 <__udivdi3+0xfc>
  801ccb:	74 0b                	je     801cd8 <__udivdi3+0xf0>
  801ccd:	89 d8                	mov    %ebx,%eax
  801ccf:	31 ff                	xor    %edi,%edi
  801cd1:	e9 58 ff ff ff       	jmp    801c2e <__udivdi3+0x46>
  801cd6:	66 90                	xchg   %ax,%ax
  801cd8:	8b 54 24 08          	mov    0x8(%esp),%edx
  801cdc:	89 f9                	mov    %edi,%ecx
  801cde:	d3 e2                	shl    %cl,%edx
  801ce0:	39 c2                	cmp    %eax,%edx
  801ce2:	73 e9                	jae    801ccd <__udivdi3+0xe5>
  801ce4:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801ce7:	31 ff                	xor    %edi,%edi
  801ce9:	e9 40 ff ff ff       	jmp    801c2e <__udivdi3+0x46>
  801cee:	66 90                	xchg   %ax,%ax
  801cf0:	31 c0                	xor    %eax,%eax
  801cf2:	e9 37 ff ff ff       	jmp    801c2e <__udivdi3+0x46>
  801cf7:	90                   	nop

00801cf8 <__umoddi3>:
  801cf8:	55                   	push   %ebp
  801cf9:	57                   	push   %edi
  801cfa:	56                   	push   %esi
  801cfb:	53                   	push   %ebx
  801cfc:	83 ec 1c             	sub    $0x1c,%esp
  801cff:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801d03:	8b 74 24 34          	mov    0x34(%esp),%esi
  801d07:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801d0b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801d0f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801d13:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801d17:	89 f3                	mov    %esi,%ebx
  801d19:	89 fa                	mov    %edi,%edx
  801d1b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801d1f:	89 34 24             	mov    %esi,(%esp)
  801d22:	85 c0                	test   %eax,%eax
  801d24:	75 1a                	jne    801d40 <__umoddi3+0x48>
  801d26:	39 f7                	cmp    %esi,%edi
  801d28:	0f 86 a2 00 00 00    	jbe    801dd0 <__umoddi3+0xd8>
  801d2e:	89 c8                	mov    %ecx,%eax
  801d30:	89 f2                	mov    %esi,%edx
  801d32:	f7 f7                	div    %edi
  801d34:	89 d0                	mov    %edx,%eax
  801d36:	31 d2                	xor    %edx,%edx
  801d38:	83 c4 1c             	add    $0x1c,%esp
  801d3b:	5b                   	pop    %ebx
  801d3c:	5e                   	pop    %esi
  801d3d:	5f                   	pop    %edi
  801d3e:	5d                   	pop    %ebp
  801d3f:	c3                   	ret    
  801d40:	39 f0                	cmp    %esi,%eax
  801d42:	0f 87 ac 00 00 00    	ja     801df4 <__umoddi3+0xfc>
  801d48:	0f bd e8             	bsr    %eax,%ebp
  801d4b:	83 f5 1f             	xor    $0x1f,%ebp
  801d4e:	0f 84 ac 00 00 00    	je     801e00 <__umoddi3+0x108>
  801d54:	bf 20 00 00 00       	mov    $0x20,%edi
  801d59:	29 ef                	sub    %ebp,%edi
  801d5b:	89 fe                	mov    %edi,%esi
  801d5d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801d61:	89 e9                	mov    %ebp,%ecx
  801d63:	d3 e0                	shl    %cl,%eax
  801d65:	89 d7                	mov    %edx,%edi
  801d67:	89 f1                	mov    %esi,%ecx
  801d69:	d3 ef                	shr    %cl,%edi
  801d6b:	09 c7                	or     %eax,%edi
  801d6d:	89 e9                	mov    %ebp,%ecx
  801d6f:	d3 e2                	shl    %cl,%edx
  801d71:	89 14 24             	mov    %edx,(%esp)
  801d74:	89 d8                	mov    %ebx,%eax
  801d76:	d3 e0                	shl    %cl,%eax
  801d78:	89 c2                	mov    %eax,%edx
  801d7a:	8b 44 24 08          	mov    0x8(%esp),%eax
  801d7e:	d3 e0                	shl    %cl,%eax
  801d80:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d84:	8b 44 24 08          	mov    0x8(%esp),%eax
  801d88:	89 f1                	mov    %esi,%ecx
  801d8a:	d3 e8                	shr    %cl,%eax
  801d8c:	09 d0                	or     %edx,%eax
  801d8e:	d3 eb                	shr    %cl,%ebx
  801d90:	89 da                	mov    %ebx,%edx
  801d92:	f7 f7                	div    %edi
  801d94:	89 d3                	mov    %edx,%ebx
  801d96:	f7 24 24             	mull   (%esp)
  801d99:	89 c6                	mov    %eax,%esi
  801d9b:	89 d1                	mov    %edx,%ecx
  801d9d:	39 d3                	cmp    %edx,%ebx
  801d9f:	0f 82 87 00 00 00    	jb     801e2c <__umoddi3+0x134>
  801da5:	0f 84 91 00 00 00    	je     801e3c <__umoddi3+0x144>
  801dab:	8b 54 24 04          	mov    0x4(%esp),%edx
  801daf:	29 f2                	sub    %esi,%edx
  801db1:	19 cb                	sbb    %ecx,%ebx
  801db3:	89 d8                	mov    %ebx,%eax
  801db5:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801db9:	d3 e0                	shl    %cl,%eax
  801dbb:	89 e9                	mov    %ebp,%ecx
  801dbd:	d3 ea                	shr    %cl,%edx
  801dbf:	09 d0                	or     %edx,%eax
  801dc1:	89 e9                	mov    %ebp,%ecx
  801dc3:	d3 eb                	shr    %cl,%ebx
  801dc5:	89 da                	mov    %ebx,%edx
  801dc7:	83 c4 1c             	add    $0x1c,%esp
  801dca:	5b                   	pop    %ebx
  801dcb:	5e                   	pop    %esi
  801dcc:	5f                   	pop    %edi
  801dcd:	5d                   	pop    %ebp
  801dce:	c3                   	ret    
  801dcf:	90                   	nop
  801dd0:	89 fd                	mov    %edi,%ebp
  801dd2:	85 ff                	test   %edi,%edi
  801dd4:	75 0b                	jne    801de1 <__umoddi3+0xe9>
  801dd6:	b8 01 00 00 00       	mov    $0x1,%eax
  801ddb:	31 d2                	xor    %edx,%edx
  801ddd:	f7 f7                	div    %edi
  801ddf:	89 c5                	mov    %eax,%ebp
  801de1:	89 f0                	mov    %esi,%eax
  801de3:	31 d2                	xor    %edx,%edx
  801de5:	f7 f5                	div    %ebp
  801de7:	89 c8                	mov    %ecx,%eax
  801de9:	f7 f5                	div    %ebp
  801deb:	89 d0                	mov    %edx,%eax
  801ded:	e9 44 ff ff ff       	jmp    801d36 <__umoddi3+0x3e>
  801df2:	66 90                	xchg   %ax,%ax
  801df4:	89 c8                	mov    %ecx,%eax
  801df6:	89 f2                	mov    %esi,%edx
  801df8:	83 c4 1c             	add    $0x1c,%esp
  801dfb:	5b                   	pop    %ebx
  801dfc:	5e                   	pop    %esi
  801dfd:	5f                   	pop    %edi
  801dfe:	5d                   	pop    %ebp
  801dff:	c3                   	ret    
  801e00:	3b 04 24             	cmp    (%esp),%eax
  801e03:	72 06                	jb     801e0b <__umoddi3+0x113>
  801e05:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801e09:	77 0f                	ja     801e1a <__umoddi3+0x122>
  801e0b:	89 f2                	mov    %esi,%edx
  801e0d:	29 f9                	sub    %edi,%ecx
  801e0f:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801e13:	89 14 24             	mov    %edx,(%esp)
  801e16:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801e1a:	8b 44 24 04          	mov    0x4(%esp),%eax
  801e1e:	8b 14 24             	mov    (%esp),%edx
  801e21:	83 c4 1c             	add    $0x1c,%esp
  801e24:	5b                   	pop    %ebx
  801e25:	5e                   	pop    %esi
  801e26:	5f                   	pop    %edi
  801e27:	5d                   	pop    %ebp
  801e28:	c3                   	ret    
  801e29:	8d 76 00             	lea    0x0(%esi),%esi
  801e2c:	2b 04 24             	sub    (%esp),%eax
  801e2f:	19 fa                	sbb    %edi,%edx
  801e31:	89 d1                	mov    %edx,%ecx
  801e33:	89 c6                	mov    %eax,%esi
  801e35:	e9 71 ff ff ff       	jmp    801dab <__umoddi3+0xb3>
  801e3a:	66 90                	xchg   %ax,%ax
  801e3c:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801e40:	72 ea                	jb     801e2c <__umoddi3+0x134>
  801e42:	89 d9                	mov    %ebx,%ecx
  801e44:	e9 62 ff ff ff       	jmp    801dab <__umoddi3+0xb3>
