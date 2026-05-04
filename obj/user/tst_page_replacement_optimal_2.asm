
obj/user/tst_page_replacement_optimal_2:     file format elf32-i386


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
  800031:	e8 c9 02 00 00       	call   8002ff <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
uint32 expectedRefStream[EXPECTED_REF_CNT] = {
		0xeebf1000, 0xeebfb000, 0xeebfc000, 0xeebf2000, 0xeebf3000, 0xeebf4000,
		0xeebf5000, 0xeebf6000, 0xeebf7000, 0xeebf8000, 0xeebf9000, 0xeebfa000
} ;
void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	57                   	push   %edi
  80003c:	56                   	push   %esi
  80003d:	53                   	push   %ebx
  80003e:	81 ec 0c c1 00 00    	sub    $0xc10c,%esp
	char __arr__[PAGE_SIZE*12];

	//("STEP 0: checking Initial WS entries ...\n");
	bool found ;

	int freePages = sys_calculate_free_frames();
  800044:	e8 41 17 00 00       	call   80178a <sys_calculate_free_frames>
  800049:	89 45 dc             	mov    %eax,-0x24(%ebp)
	int usedDiskPages = sys_pf_calculate_allocated_pages();
  80004c:	e8 84 17 00 00       	call   8017d5 <sys_pf_calculate_allocated_pages>
  800051:	89 45 d8             	mov    %eax,-0x28(%ebp)

	//Writing (Modified)
	__arr__[PAGE_SIZE*10-1] = 'a' ;
  800054:	c6 85 cb df ff ff 61 	movb   $0x61,-0x2035(%ebp)

	//Reading (Not Modified)
	char garbage1 = __arr__[PAGE_SIZE*11-1] ;
  80005b:	8a 85 cb ef ff ff    	mov    -0x1035(%ebp),%al
  800061:	88 45 d7             	mov    %al,-0x29(%ebp)
	char garbage2 = __arr__[PAGE_SIZE*12-1] ;
  800064:	8a 45 cb             	mov    -0x35(%ebp),%al
  800067:	88 45 d6             	mov    %al,-0x2a(%ebp)
	char garbage4,garbage5;

	//Writing (Modified)
	int i ;
	for (i = 0 ; i < PAGE_SIZE*10 ; i+=PAGE_SIZE/2)
  80006a:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800071:	eb 29                	jmp    80009c <_main+0x64>
	{
		__arr__[i] = -1 ;
  800073:	8d 95 cc 3f ff ff    	lea    -0xc034(%ebp),%edx
  800079:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80007c:	01 d0                	add    %edx,%eax
  80007e:	c6 00 ff             	movb   $0xff,(%eax)
		/*2016: this BUGGY line is REMOVED el7! it overwrites the KERNEL CODE :( !!!*/
		//*ptr = *ptr2 ;
		/*==========================================================================*/
		//always use pages at 0x801000 and 0x804000
		garbage4 = *__ptr__ ;
  800081:	a1 00 30 80 00       	mov    0x803000,%eax
  800086:	8a 00                	mov    (%eax),%al
  800088:	88 45 e7             	mov    %al,-0x19(%ebp)
		garbage5 = *__ptr2__ ;
  80008b:	a1 04 30 80 00       	mov    0x803004,%eax
  800090:	8a 00                	mov    (%eax),%al
  800092:	88 45 e6             	mov    %al,-0x1a(%ebp)
	char garbage2 = __arr__[PAGE_SIZE*12-1] ;
	char garbage4,garbage5;

	//Writing (Modified)
	int i ;
	for (i = 0 ; i < PAGE_SIZE*10 ; i+=PAGE_SIZE/2)
  800095:	81 45 e0 00 08 00 00 	addl   $0x800,-0x20(%ebp)
  80009c:	81 7d e0 ff 9f 00 00 	cmpl   $0x9fff,-0x20(%ebp)
  8000a3:	7e ce                	jle    800073 <_main+0x3b>
		garbage5 = *__ptr2__ ;
	}

	//===================

	cprintf_colored(TEXT_cyan, "%~\nChecking Content... \n");
  8000a5:	83 ec 08             	sub    $0x8,%esp
  8000a8:	68 80 1e 80 00       	push   $0x801e80
  8000ad:	6a 03                	push   $0x3
  8000af:	e8 ff 06 00 00       	call   8007b3 <cprintf_colored>
  8000b4:	83 c4 10             	add    $0x10,%esp
	{
		if (garbage4 != *__ptr__) panic("test failed!");
  8000b7:	a1 00 30 80 00       	mov    0x803000,%eax
  8000bc:	8a 00                	mov    (%eax),%al
  8000be:	3a 45 e7             	cmp    -0x19(%ebp),%al
  8000c1:	74 14                	je     8000d7 <_main+0x9f>
  8000c3:	83 ec 04             	sub    $0x4,%esp
  8000c6:	68 99 1e 80 00       	push   $0x801e99
  8000cb:	6a 31                	push   $0x31
  8000cd:	68 a8 1e 80 00       	push   $0x801ea8
  8000d2:	e8 e1 03 00 00       	call   8004b8 <_panic>
		if (garbage5 != *__ptr2__) panic("test failed!");
  8000d7:	a1 04 30 80 00       	mov    0x803004,%eax
  8000dc:	8a 00                	mov    (%eax),%al
  8000de:	3a 45 e6             	cmp    -0x1a(%ebp),%al
  8000e1:	74 14                	je     8000f7 <_main+0xbf>
  8000e3:	83 ec 04             	sub    $0x4,%esp
  8000e6:	68 99 1e 80 00       	push   $0x801e99
  8000eb:	6a 32                	push   $0x32
  8000ed:	68 a8 1e 80 00       	push   $0x801ea8
  8000f2:	e8 c1 03 00 00       	call   8004b8 <_panic>
		if(__arr__[PAGE_SIZE*10-1] != 'a') panic("test failed!");
  8000f7:	8a 85 cb df ff ff    	mov    -0x2035(%ebp),%al
  8000fd:	3c 61                	cmp    $0x61,%al
  8000ff:	74 14                	je     800115 <_main+0xdd>
  800101:	83 ec 04             	sub    $0x4,%esp
  800104:	68 99 1e 80 00       	push   $0x801e99
  800109:	6a 33                	push   $0x33
  80010b:	68 a8 1e 80 00       	push   $0x801ea8
  800110:	e8 a3 03 00 00       	call   8004b8 <_panic>
		for (i = 0 ; i < PAGE_SIZE*10 ; i+=PAGE_SIZE/2)
  800115:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80011c:	eb 2c                	jmp    80014a <_main+0x112>
		{
			if(__arr__[i] != -1) panic("test failed!");
  80011e:	8d 95 cc 3f ff ff    	lea    -0xc034(%ebp),%edx
  800124:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800127:	01 d0                	add    %edx,%eax
  800129:	8a 00                	mov    (%eax),%al
  80012b:	3c ff                	cmp    $0xff,%al
  80012d:	74 14                	je     800143 <_main+0x10b>
  80012f:	83 ec 04             	sub    $0x4,%esp
  800132:	68 99 1e 80 00       	push   $0x801e99
  800137:	6a 36                	push   $0x36
  800139:	68 a8 1e 80 00       	push   $0x801ea8
  80013e:	e8 75 03 00 00       	call   8004b8 <_panic>
	cprintf_colored(TEXT_cyan, "%~\nChecking Content... \n");
	{
		if (garbage4 != *__ptr__) panic("test failed!");
		if (garbage5 != *__ptr2__) panic("test failed!");
		if(__arr__[PAGE_SIZE*10-1] != 'a') panic("test failed!");
		for (i = 0 ; i < PAGE_SIZE*10 ; i+=PAGE_SIZE/2)
  800143:	81 45 e0 00 08 00 00 	addl   $0x800,-0x20(%ebp)
  80014a:	81 7d e0 ff 9f 00 00 	cmpl   $0x9fff,-0x20(%ebp)
  800151:	7e cb                	jle    80011e <_main+0xe6>
		{
			if(__arr__[i] != -1) panic("test failed!");
		}
	}
	cprintf_colored(TEXT_cyan, "%~\nChecking EXPECTED REFERENCE STREAM... \n");
  800153:	83 ec 08             	sub    $0x8,%esp
  800156:	68 d0 1e 80 00       	push   $0x801ed0
  80015b:	6a 03                	push   $0x3
  80015d:	e8 51 06 00 00       	call   8007b3 <cprintf_colored>
  800162:	83 c4 10             	add    $0x10,%esp
	{
		char separator[2] = "@";
  800165:	66 c7 85 c6 3f ff ff 	movw   $0x40,-0xc03a(%ebp)
  80016c:	40 00 
		char checkRefStreamCmd[100] = "__CheckRefStream@";
  80016e:	8d 85 ea 3e ff ff    	lea    -0xc116(%ebp),%eax
  800174:	bb 51 20 80 00       	mov    $0x802051,%ebx
  800179:	ba 12 00 00 00       	mov    $0x12,%edx
  80017e:	89 c7                	mov    %eax,%edi
  800180:	89 de                	mov    %ebx,%esi
  800182:	89 d1                	mov    %edx,%ecx
  800184:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  800186:	8d 95 fc 3e ff ff    	lea    -0xc104(%ebp),%edx
  80018c:	b9 52 00 00 00       	mov    $0x52,%ecx
  800191:	b0 00                	mov    $0x0,%al
  800193:	89 d7                	mov    %edx,%edi
  800195:	f3 aa                	rep stos %al,%es:(%edi)
		char token[20] ;
		char cmdWithCnt[100] ;
		ltostr(EXPECTED_REF_CNT, token);
  800197:	83 ec 08             	sub    $0x8,%esp
  80019a:	8d 85 b2 3f ff ff    	lea    -0xc04e(%ebp),%eax
  8001a0:	50                   	push   %eax
  8001a1:	6a 0c                	push   $0xc
  8001a3:	e8 0c 12 00 00       	call   8013b4 <ltostr>
  8001a8:	83 c4 10             	add    $0x10,%esp
		strcconcat(checkRefStreamCmd, token, cmdWithCnt);
  8001ab:	83 ec 04             	sub    $0x4,%esp
  8001ae:	8d 85 4e 3f ff ff    	lea    -0xc0b2(%ebp),%eax
  8001b4:	50                   	push   %eax
  8001b5:	8d 85 b2 3f ff ff    	lea    -0xc04e(%ebp),%eax
  8001bb:	50                   	push   %eax
  8001bc:	8d 85 ea 3e ff ff    	lea    -0xc116(%ebp),%eax
  8001c2:	50                   	push   %eax
  8001c3:	e8 c5 12 00 00       	call   80148d <strcconcat>
  8001c8:	83 c4 10             	add    $0x10,%esp
		strcconcat(cmdWithCnt, separator, cmdWithCnt);
  8001cb:	83 ec 04             	sub    $0x4,%esp
  8001ce:	8d 85 4e 3f ff ff    	lea    -0xc0b2(%ebp),%eax
  8001d4:	50                   	push   %eax
  8001d5:	8d 85 c6 3f ff ff    	lea    -0xc03a(%ebp),%eax
  8001db:	50                   	push   %eax
  8001dc:	8d 85 4e 3f ff ff    	lea    -0xc0b2(%ebp),%eax
  8001e2:	50                   	push   %eax
  8001e3:	e8 a5 12 00 00       	call   80148d <strcconcat>
  8001e8:	83 c4 10             	add    $0x10,%esp
		ltostr((uint32)&expectedRefStream, token);
  8001eb:	ba 20 30 80 00       	mov    $0x803020,%edx
  8001f0:	83 ec 08             	sub    $0x8,%esp
  8001f3:	8d 85 b2 3f ff ff    	lea    -0xc04e(%ebp),%eax
  8001f9:	50                   	push   %eax
  8001fa:	52                   	push   %edx
  8001fb:	e8 b4 11 00 00       	call   8013b4 <ltostr>
  800200:	83 c4 10             	add    $0x10,%esp
		strcconcat(cmdWithCnt, token, cmdWithCnt);
  800203:	83 ec 04             	sub    $0x4,%esp
  800206:	8d 85 4e 3f ff ff    	lea    -0xc0b2(%ebp),%eax
  80020c:	50                   	push   %eax
  80020d:	8d 85 b2 3f ff ff    	lea    -0xc04e(%ebp),%eax
  800213:	50                   	push   %eax
  800214:	8d 85 4e 3f ff ff    	lea    -0xc0b2(%ebp),%eax
  80021a:	50                   	push   %eax
  80021b:	e8 6d 12 00 00       	call   80148d <strcconcat>
  800220:	83 c4 10             	add    $0x10,%esp
		strcconcat(cmdWithCnt, separator, cmdWithCnt);
  800223:	83 ec 04             	sub    $0x4,%esp
  800226:	8d 85 4e 3f ff ff    	lea    -0xc0b2(%ebp),%eax
  80022c:	50                   	push   %eax
  80022d:	8d 85 c6 3f ff ff    	lea    -0xc03a(%ebp),%eax
  800233:	50                   	push   %eax
  800234:	8d 85 4e 3f ff ff    	lea    -0xc0b2(%ebp),%eax
  80023a:	50                   	push   %eax
  80023b:	e8 4d 12 00 00       	call   80148d <strcconcat>
  800240:	83 c4 10             	add    $0x10,%esp

		atomic_cprintf("%~Ref Command = %s\n", cmdWithCnt);
  800243:	83 ec 08             	sub    $0x8,%esp
  800246:	8d 85 4e 3f ff ff    	lea    -0xc0b2(%ebp),%eax
  80024c:	50                   	push   %eax
  80024d:	68 fb 1e 80 00       	push   $0x801efb
  800252:	e8 a1 05 00 00       	call   8007f8 <atomic_cprintf>
  800257:	83 c4 10             	add    $0x10,%esp

		sys_utilities(cmdWithCnt, (uint32)&found);
  80025a:	8d 85 c8 3f ff ff    	lea    -0xc038(%ebp),%eax
  800260:	83 ec 08             	sub    $0x8,%esp
  800263:	50                   	push   %eax
  800264:	8d 85 4e 3f ff ff    	lea    -0xc0b2(%ebp),%eax
  80026a:	50                   	push   %eax
  80026b:	e8 19 19 00 00       	call   801b89 <sys_utilities>
  800270:	83 c4 10             	add    $0x10,%esp

		//if (found != 1) panic("OPTIMAL alg. failed.. unexpected page reference stream!");
	}
	cprintf_colored(TEXT_cyan, "%~\nChecking Allocation in Mem & Page File... \n");
  800273:	83 ec 08             	sub    $0x8,%esp
  800276:	68 10 1f 80 00       	push   $0x801f10
  80027b:	6a 03                	push   $0x3
  80027d:	e8 31 05 00 00       	call   8007b3 <cprintf_colored>
  800282:	83 c4 10             	add    $0x10,%esp
	{
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Unexpected extra/less pages have been added to page file.. NOT Expected to add new pages to the page file");
  800285:	e8 4b 15 00 00       	call   8017d5 <sys_pf_calculate_allocated_pages>
  80028a:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  80028d:	74 14                	je     8002a3 <_main+0x26b>
  80028f:	83 ec 04             	sub    $0x4,%esp
  800292:	68 40 1f 80 00       	push   $0x801f40
  800297:	6a 4e                	push   $0x4e
  800299:	68 a8 1e 80 00       	push   $0x801ea8
  80029e:	e8 15 02 00 00       	call   8004b8 <_panic>

		int freePagesAfter = (sys_calculate_free_frames() + sys_calculate_modified_frames());
  8002a3:	e8 e2 14 00 00       	call   80178a <sys_calculate_free_frames>
  8002a8:	89 c3                	mov    %eax,%ebx
  8002aa:	e8 f4 14 00 00       	call   8017a3 <sys_calculate_modified_frames>
  8002af:	01 d8                	add    %ebx,%eax
  8002b1:	89 45 d0             	mov    %eax,-0x30(%ebp)
		int expectedNumOfFrames = 11;
  8002b4:	c7 45 cc 0b 00 00 00 	movl   $0xb,-0x34(%ebp)
		if( (freePages - freePagesAfter) != expectedNumOfFrames)
  8002bb:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8002be:	2b 45 d0             	sub    -0x30(%ebp),%eax
  8002c1:	3b 45 cc             	cmp    -0x34(%ebp),%eax
  8002c4:	74 1e                	je     8002e4 <_main+0x2ac>
			panic("Unexpected number of allocated frames in RAM. Expected = %d, Actual = %d", expectedNumOfFrames, (freePages - freePagesAfter));
  8002c6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8002c9:	2b 45 d0             	sub    -0x30(%ebp),%eax
  8002cc:	83 ec 0c             	sub    $0xc,%esp
  8002cf:	50                   	push   %eax
  8002d0:	ff 75 cc             	pushl  -0x34(%ebp)
  8002d3:	68 ac 1f 80 00       	push   $0x801fac
  8002d8:	6a 53                	push   $0x53
  8002da:	68 a8 1e 80 00       	push   $0x801ea8
  8002df:	e8 d4 01 00 00       	call   8004b8 <_panic>
	}

	cprintf_colored(TEXT_light_green, "%~\nCongratulations!! test PAGE replacement #2 [OPTIMAL Alg.] is completed successfully.\n");
  8002e4:	83 ec 08             	sub    $0x8,%esp
  8002e7:	68 f8 1f 80 00       	push   $0x801ff8
  8002ec:	6a 0a                	push   $0xa
  8002ee:	e8 c0 04 00 00       	call   8007b3 <cprintf_colored>
  8002f3:	83 c4 10             	add    $0x10,%esp
	return;
  8002f6:	90                   	nop
}
  8002f7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002fa:	5b                   	pop    %ebx
  8002fb:	5e                   	pop    %esi
  8002fc:	5f                   	pop    %edi
  8002fd:	5d                   	pop    %ebp
  8002fe:	c3                   	ret    

008002ff <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  8002ff:	55                   	push   %ebp
  800300:	89 e5                	mov    %esp,%ebp
  800302:	57                   	push   %edi
  800303:	56                   	push   %esi
  800304:	53                   	push   %ebx
  800305:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  800308:	e8 46 16 00 00       	call   801953 <sys_getenvindex>
  80030d:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  800310:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800313:	89 d0                	mov    %edx,%eax
  800315:	c1 e0 02             	shl    $0x2,%eax
  800318:	01 d0                	add    %edx,%eax
  80031a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800321:	01 d0                	add    %edx,%eax
  800323:	89 c2                	mov    %eax,%edx
  800325:	c1 e2 04             	shl    $0x4,%edx
  800328:	29 c2                	sub    %eax,%edx
  80032a:	8d 04 95 00 00 00 00 	lea    0x0(,%edx,4),%eax
  800331:	89 c2                	mov    %eax,%edx
  800333:	8d 82 00 00 c0 ee    	lea    -0x11400000(%edx),%eax
  800339:	a3 60 30 80 00       	mov    %eax,0x803060

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  80033e:	a1 60 30 80 00       	mov    0x803060,%eax
  800343:	8a 40 20             	mov    0x20(%eax),%al
  800346:	84 c0                	test   %al,%al
  800348:	74 0d                	je     800357 <libmain+0x58>
		binaryname = myEnv->prog_name;
  80034a:	a1 60 30 80 00       	mov    0x803060,%eax
  80034f:	83 c0 20             	add    $0x20,%eax
  800352:	a3 54 30 80 00       	mov    %eax,0x803054

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800357:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80035b:	7e 0a                	jle    800367 <libmain+0x68>
		binaryname = argv[0];
  80035d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800360:	8b 00                	mov    (%eax),%eax
  800362:	a3 54 30 80 00       	mov    %eax,0x803054

	// call user main routine
	_main(argc, argv);
  800367:	83 ec 08             	sub    $0x8,%esp
  80036a:	ff 75 0c             	pushl  0xc(%ebp)
  80036d:	ff 75 08             	pushl  0x8(%ebp)
  800370:	e8 c3 fc ff ff       	call   800038 <_main>
  800375:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  800378:	a1 50 30 80 00       	mov    0x803050,%eax
  80037d:	85 c0                	test   %eax,%eax
  80037f:	0f 84 01 01 00 00    	je     800486 <libmain+0x187>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  800385:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  80038b:	bb b0 21 80 00       	mov    $0x8021b0,%ebx
  800390:	ba 0e 00 00 00       	mov    $0xe,%edx
  800395:	89 c7                	mov    %eax,%edi
  800397:	89 de                	mov    %ebx,%esi
  800399:	89 d1                	mov    %edx,%ecx
  80039b:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  80039d:	8d 55 8a             	lea    -0x76(%ebp),%edx
  8003a0:	b9 56 00 00 00       	mov    $0x56,%ecx
  8003a5:	b0 00                	mov    $0x0,%al
  8003a7:	89 d7                	mov    %edx,%edi
  8003a9:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  8003ab:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  8003b2:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8003b5:	83 ec 08             	sub    $0x8,%esp
  8003b8:	50                   	push   %eax
  8003b9:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  8003bf:	50                   	push   %eax
  8003c0:	e8 c4 17 00 00       	call   801b89 <sys_utilities>
  8003c5:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  8003c8:	e8 0d 13 00 00       	call   8016da <sys_lock_cons>
		{
			cprintf("**************************************\n");
  8003cd:	83 ec 0c             	sub    $0xc,%esp
  8003d0:	68 d0 20 80 00       	push   $0x8020d0
  8003d5:	e8 ac 03 00 00       	call   800786 <cprintf>
  8003da:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  8003dd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8003e0:	85 c0                	test   %eax,%eax
  8003e2:	74 18                	je     8003fc <libmain+0xfd>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  8003e4:	e8 be 17 00 00       	call   801ba7 <sys_get_optimal_num_faults>
  8003e9:	83 ec 08             	sub    $0x8,%esp
  8003ec:	50                   	push   %eax
  8003ed:	68 f8 20 80 00       	push   $0x8020f8
  8003f2:	e8 8f 03 00 00       	call   800786 <cprintf>
  8003f7:	83 c4 10             	add    $0x10,%esp
  8003fa:	eb 59                	jmp    800455 <libmain+0x156>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8003fc:	a1 60 30 80 00       	mov    0x803060,%eax
  800401:	8b 90 bc 05 00 00    	mov    0x5bc(%eax),%edx
  800407:	a1 60 30 80 00       	mov    0x803060,%eax
  80040c:	8b 80 ac 05 00 00    	mov    0x5ac(%eax),%eax
  800412:	83 ec 04             	sub    $0x4,%esp
  800415:	52                   	push   %edx
  800416:	50                   	push   %eax
  800417:	68 1c 21 80 00       	push   $0x80211c
  80041c:	e8 65 03 00 00       	call   800786 <cprintf>
  800421:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800424:	a1 60 30 80 00       	mov    0x803060,%eax
  800429:	8b 88 d0 05 00 00    	mov    0x5d0(%eax),%ecx
  80042f:	a1 60 30 80 00       	mov    0x803060,%eax
  800434:	8b 90 cc 05 00 00    	mov    0x5cc(%eax),%edx
  80043a:	a1 60 30 80 00       	mov    0x803060,%eax
  80043f:	8b 80 c8 05 00 00    	mov    0x5c8(%eax),%eax
  800445:	51                   	push   %ecx
  800446:	52                   	push   %edx
  800447:	50                   	push   %eax
  800448:	68 44 21 80 00       	push   $0x802144
  80044d:	e8 34 03 00 00       	call   800786 <cprintf>
  800452:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800455:	a1 60 30 80 00       	mov    0x803060,%eax
  80045a:	8b 80 d4 05 00 00    	mov    0x5d4(%eax),%eax
  800460:	83 ec 08             	sub    $0x8,%esp
  800463:	50                   	push   %eax
  800464:	68 9c 21 80 00       	push   $0x80219c
  800469:	e8 18 03 00 00       	call   800786 <cprintf>
  80046e:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  800471:	83 ec 0c             	sub    $0xc,%esp
  800474:	68 d0 20 80 00       	push   $0x8020d0
  800479:	e8 08 03 00 00       	call   800786 <cprintf>
  80047e:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  800481:	e8 6e 12 00 00       	call   8016f4 <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  800486:	e8 1f 00 00 00       	call   8004aa <exit>
}
  80048b:	90                   	nop
  80048c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80048f:	5b                   	pop    %ebx
  800490:	5e                   	pop    %esi
  800491:	5f                   	pop    %edi
  800492:	5d                   	pop    %ebp
  800493:	c3                   	ret    

00800494 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800494:	55                   	push   %ebp
  800495:	89 e5                	mov    %esp,%ebp
  800497:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  80049a:	83 ec 0c             	sub    $0xc,%esp
  80049d:	6a 00                	push   $0x0
  80049f:	e8 7b 14 00 00       	call   80191f <sys_destroy_env>
  8004a4:	83 c4 10             	add    $0x10,%esp
}
  8004a7:	90                   	nop
  8004a8:	c9                   	leave  
  8004a9:	c3                   	ret    

008004aa <exit>:

void
exit(void)
{
  8004aa:	55                   	push   %ebp
  8004ab:	89 e5                	mov    %esp,%ebp
  8004ad:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8004b0:	e8 d0 14 00 00       	call   801985 <sys_exit_env>
}
  8004b5:	90                   	nop
  8004b6:	c9                   	leave  
  8004b7:	c3                   	ret    

008004b8 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8004b8:	55                   	push   %ebp
  8004b9:	89 e5                	mov    %esp,%ebp
  8004bb:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8004be:	8d 45 10             	lea    0x10(%ebp),%eax
  8004c1:	83 c0 04             	add    $0x4,%eax
  8004c4:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8004c7:	a1 58 b1 81 00       	mov    0x81b158,%eax
  8004cc:	85 c0                	test   %eax,%eax
  8004ce:	74 16                	je     8004e6 <_panic+0x2e>
		cprintf("%s: ", argv0);
  8004d0:	a1 58 b1 81 00       	mov    0x81b158,%eax
  8004d5:	83 ec 08             	sub    $0x8,%esp
  8004d8:	50                   	push   %eax
  8004d9:	68 14 22 80 00       	push   $0x802214
  8004de:	e8 a3 02 00 00       	call   800786 <cprintf>
  8004e3:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  8004e6:	a1 54 30 80 00       	mov    0x803054,%eax
  8004eb:	83 ec 0c             	sub    $0xc,%esp
  8004ee:	ff 75 0c             	pushl  0xc(%ebp)
  8004f1:	ff 75 08             	pushl  0x8(%ebp)
  8004f4:	50                   	push   %eax
  8004f5:	68 1c 22 80 00       	push   $0x80221c
  8004fa:	6a 74                	push   $0x74
  8004fc:	e8 b2 02 00 00       	call   8007b3 <cprintf_colored>
  800501:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  800504:	8b 45 10             	mov    0x10(%ebp),%eax
  800507:	83 ec 08             	sub    $0x8,%esp
  80050a:	ff 75 f4             	pushl  -0xc(%ebp)
  80050d:	50                   	push   %eax
  80050e:	e8 04 02 00 00       	call   800717 <vcprintf>
  800513:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800516:	83 ec 08             	sub    $0x8,%esp
  800519:	6a 00                	push   $0x0
  80051b:	68 44 22 80 00       	push   $0x802244
  800520:	e8 f2 01 00 00       	call   800717 <vcprintf>
  800525:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800528:	e8 7d ff ff ff       	call   8004aa <exit>

	// should not return here
	while (1) ;
  80052d:	eb fe                	jmp    80052d <_panic+0x75>

0080052f <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  80052f:	55                   	push   %ebp
  800530:	89 e5                	mov    %esp,%ebp
  800532:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800535:	a1 60 30 80 00       	mov    0x803060,%eax
  80053a:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800540:	8b 45 0c             	mov    0xc(%ebp),%eax
  800543:	39 c2                	cmp    %eax,%edx
  800545:	74 14                	je     80055b <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800547:	83 ec 04             	sub    $0x4,%esp
  80054a:	68 48 22 80 00       	push   $0x802248
  80054f:	6a 26                	push   $0x26
  800551:	68 94 22 80 00       	push   $0x802294
  800556:	e8 5d ff ff ff       	call   8004b8 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  80055b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800562:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800569:	e9 c5 00 00 00       	jmp    800633 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  80056e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800571:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800578:	8b 45 08             	mov    0x8(%ebp),%eax
  80057b:	01 d0                	add    %edx,%eax
  80057d:	8b 00                	mov    (%eax),%eax
  80057f:	85 c0                	test   %eax,%eax
  800581:	75 08                	jne    80058b <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  800583:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800586:	e9 a5 00 00 00       	jmp    800630 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  80058b:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800592:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800599:	eb 69                	jmp    800604 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  80059b:	a1 60 30 80 00       	mov    0x803060,%eax
  8005a0:	8b 88 a4 05 00 00    	mov    0x5a4(%eax),%ecx
  8005a6:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8005a9:	89 d0                	mov    %edx,%eax
  8005ab:	01 c0                	add    %eax,%eax
  8005ad:	01 d0                	add    %edx,%eax
  8005af:	c1 e0 03             	shl    $0x3,%eax
  8005b2:	01 c8                	add    %ecx,%eax
  8005b4:	8a 40 04             	mov    0x4(%eax),%al
  8005b7:	84 c0                	test   %al,%al
  8005b9:	75 46                	jne    800601 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8005bb:	a1 60 30 80 00       	mov    0x803060,%eax
  8005c0:	8b 88 a4 05 00 00    	mov    0x5a4(%eax),%ecx
  8005c6:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8005c9:	89 d0                	mov    %edx,%eax
  8005cb:	01 c0                	add    %eax,%eax
  8005cd:	01 d0                	add    %edx,%eax
  8005cf:	c1 e0 03             	shl    $0x3,%eax
  8005d2:	01 c8                	add    %ecx,%eax
  8005d4:	8b 00                	mov    (%eax),%eax
  8005d6:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8005d9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8005dc:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8005e1:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8005e3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8005e6:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8005ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8005f0:	01 c8                	add    %ecx,%eax
  8005f2:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8005f4:	39 c2                	cmp    %eax,%edx
  8005f6:	75 09                	jne    800601 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  8005f8:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8005ff:	eb 15                	jmp    800616 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800601:	ff 45 e8             	incl   -0x18(%ebp)
  800604:	a1 60 30 80 00       	mov    0x803060,%eax
  800609:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  80060f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800612:	39 c2                	cmp    %eax,%edx
  800614:	77 85                	ja     80059b <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800616:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80061a:	75 14                	jne    800630 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  80061c:	83 ec 04             	sub    $0x4,%esp
  80061f:	68 a0 22 80 00       	push   $0x8022a0
  800624:	6a 3a                	push   $0x3a
  800626:	68 94 22 80 00       	push   $0x802294
  80062b:	e8 88 fe ff ff       	call   8004b8 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800630:	ff 45 f0             	incl   -0x10(%ebp)
  800633:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800636:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800639:	0f 8c 2f ff ff ff    	jl     80056e <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  80063f:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800646:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80064d:	eb 26                	jmp    800675 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  80064f:	a1 60 30 80 00       	mov    0x803060,%eax
  800654:	8b 88 a4 05 00 00    	mov    0x5a4(%eax),%ecx
  80065a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80065d:	89 d0                	mov    %edx,%eax
  80065f:	01 c0                	add    %eax,%eax
  800661:	01 d0                	add    %edx,%eax
  800663:	c1 e0 03             	shl    $0x3,%eax
  800666:	01 c8                	add    %ecx,%eax
  800668:	8a 40 04             	mov    0x4(%eax),%al
  80066b:	3c 01                	cmp    $0x1,%al
  80066d:	75 03                	jne    800672 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  80066f:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800672:	ff 45 e0             	incl   -0x20(%ebp)
  800675:	a1 60 30 80 00       	mov    0x803060,%eax
  80067a:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800680:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800683:	39 c2                	cmp    %eax,%edx
  800685:	77 c8                	ja     80064f <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800687:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80068a:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80068d:	74 14                	je     8006a3 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  80068f:	83 ec 04             	sub    $0x4,%esp
  800692:	68 f4 22 80 00       	push   $0x8022f4
  800697:	6a 44                	push   $0x44
  800699:	68 94 22 80 00       	push   $0x802294
  80069e:	e8 15 fe ff ff       	call   8004b8 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8006a3:	90                   	nop
  8006a4:	c9                   	leave  
  8006a5:	c3                   	ret    

008006a6 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  8006a6:	55                   	push   %ebp
  8006a7:	89 e5                	mov    %esp,%ebp
  8006a9:	53                   	push   %ebx
  8006aa:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  8006ad:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006b0:	8b 00                	mov    (%eax),%eax
  8006b2:	8d 48 01             	lea    0x1(%eax),%ecx
  8006b5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8006b8:	89 0a                	mov    %ecx,(%edx)
  8006ba:	8b 55 08             	mov    0x8(%ebp),%edx
  8006bd:	88 d1                	mov    %dl,%cl
  8006bf:	8b 55 0c             	mov    0xc(%ebp),%edx
  8006c2:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8006c6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006c9:	8b 00                	mov    (%eax),%eax
  8006cb:	3d ff 00 00 00       	cmp    $0xff,%eax
  8006d0:	75 30                	jne    800702 <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  8006d2:	8b 15 5c b1 81 00    	mov    0x81b15c,%edx
  8006d8:	a0 84 30 80 00       	mov    0x803084,%al
  8006dd:	0f b6 c0             	movzbl %al,%eax
  8006e0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8006e3:	8b 09                	mov    (%ecx),%ecx
  8006e5:	89 cb                	mov    %ecx,%ebx
  8006e7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8006ea:	83 c1 08             	add    $0x8,%ecx
  8006ed:	52                   	push   %edx
  8006ee:	50                   	push   %eax
  8006ef:	53                   	push   %ebx
  8006f0:	51                   	push   %ecx
  8006f1:	e8 a0 0f 00 00       	call   801696 <sys_cputs>
  8006f6:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8006f9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006fc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800702:	8b 45 0c             	mov    0xc(%ebp),%eax
  800705:	8b 40 04             	mov    0x4(%eax),%eax
  800708:	8d 50 01             	lea    0x1(%eax),%edx
  80070b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80070e:	89 50 04             	mov    %edx,0x4(%eax)
}
  800711:	90                   	nop
  800712:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800715:	c9                   	leave  
  800716:	c3                   	ret    

00800717 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800717:	55                   	push   %ebp
  800718:	89 e5                	mov    %esp,%ebp
  80071a:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800720:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800727:	00 00 00 
	b.cnt = 0;
  80072a:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800731:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800734:	ff 75 0c             	pushl  0xc(%ebp)
  800737:	ff 75 08             	pushl  0x8(%ebp)
  80073a:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800740:	50                   	push   %eax
  800741:	68 a6 06 80 00       	push   $0x8006a6
  800746:	e8 5a 02 00 00       	call   8009a5 <vprintfmt>
  80074b:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  80074e:	8b 15 5c b1 81 00    	mov    0x81b15c,%edx
  800754:	a0 84 30 80 00       	mov    0x803084,%al
  800759:	0f b6 c0             	movzbl %al,%eax
  80075c:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  800762:	52                   	push   %edx
  800763:	50                   	push   %eax
  800764:	51                   	push   %ecx
  800765:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80076b:	83 c0 08             	add    $0x8,%eax
  80076e:	50                   	push   %eax
  80076f:	e8 22 0f 00 00       	call   801696 <sys_cputs>
  800774:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800777:	c6 05 84 30 80 00 00 	movb   $0x0,0x803084
	return b.cnt;
  80077e:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800784:	c9                   	leave  
  800785:	c3                   	ret    

00800786 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  800786:	55                   	push   %ebp
  800787:	89 e5                	mov    %esp,%ebp
  800789:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  80078c:	c6 05 84 30 80 00 01 	movb   $0x1,0x803084
	va_start(ap, fmt);
  800793:	8d 45 0c             	lea    0xc(%ebp),%eax
  800796:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800799:	8b 45 08             	mov    0x8(%ebp),%eax
  80079c:	83 ec 08             	sub    $0x8,%esp
  80079f:	ff 75 f4             	pushl  -0xc(%ebp)
  8007a2:	50                   	push   %eax
  8007a3:	e8 6f ff ff ff       	call   800717 <vcprintf>
  8007a8:	83 c4 10             	add    $0x10,%esp
  8007ab:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8007ae:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8007b1:	c9                   	leave  
  8007b2:	c3                   	ret    

008007b3 <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  8007b3:	55                   	push   %ebp
  8007b4:	89 e5                	mov    %esp,%ebp
  8007b6:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8007b9:	c6 05 84 30 80 00 01 	movb   $0x1,0x803084
	curTextClr = (textClr << 8) ; //set text color by the given value
  8007c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8007c3:	c1 e0 08             	shl    $0x8,%eax
  8007c6:	a3 5c b1 81 00       	mov    %eax,0x81b15c
	va_start(ap, fmt);
  8007cb:	8d 45 0c             	lea    0xc(%ebp),%eax
  8007ce:	83 c0 04             	add    $0x4,%eax
  8007d1:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8007d4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007d7:	83 ec 08             	sub    $0x8,%esp
  8007da:	ff 75 f4             	pushl  -0xc(%ebp)
  8007dd:	50                   	push   %eax
  8007de:	e8 34 ff ff ff       	call   800717 <vcprintf>
  8007e3:	83 c4 10             	add    $0x10,%esp
  8007e6:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  8007e9:	c7 05 5c b1 81 00 00 	movl   $0x700,0x81b15c
  8007f0:	07 00 00 

	return cnt;
  8007f3:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8007f6:	c9                   	leave  
  8007f7:	c3                   	ret    

008007f8 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  8007f8:	55                   	push   %ebp
  8007f9:	89 e5                	mov    %esp,%ebp
  8007fb:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  8007fe:	e8 d7 0e 00 00       	call   8016da <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  800803:	8d 45 0c             	lea    0xc(%ebp),%eax
  800806:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  800809:	8b 45 08             	mov    0x8(%ebp),%eax
  80080c:	83 ec 08             	sub    $0x8,%esp
  80080f:	ff 75 f4             	pushl  -0xc(%ebp)
  800812:	50                   	push   %eax
  800813:	e8 ff fe ff ff       	call   800717 <vcprintf>
  800818:	83 c4 10             	add    $0x10,%esp
  80081b:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  80081e:	e8 d1 0e 00 00       	call   8016f4 <sys_unlock_cons>
	return cnt;
  800823:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800826:	c9                   	leave  
  800827:	c3                   	ret    

00800828 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800828:	55                   	push   %ebp
  800829:	89 e5                	mov    %esp,%ebp
  80082b:	53                   	push   %ebx
  80082c:	83 ec 14             	sub    $0x14,%esp
  80082f:	8b 45 10             	mov    0x10(%ebp),%eax
  800832:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800835:	8b 45 14             	mov    0x14(%ebp),%eax
  800838:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80083b:	8b 45 18             	mov    0x18(%ebp),%eax
  80083e:	ba 00 00 00 00       	mov    $0x0,%edx
  800843:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800846:	77 55                	ja     80089d <printnum+0x75>
  800848:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80084b:	72 05                	jb     800852 <printnum+0x2a>
  80084d:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800850:	77 4b                	ja     80089d <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800852:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800855:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800858:	8b 45 18             	mov    0x18(%ebp),%eax
  80085b:	ba 00 00 00 00       	mov    $0x0,%edx
  800860:	52                   	push   %edx
  800861:	50                   	push   %eax
  800862:	ff 75 f4             	pushl  -0xc(%ebp)
  800865:	ff 75 f0             	pushl  -0x10(%ebp)
  800868:	e8 ab 13 00 00       	call   801c18 <__udivdi3>
  80086d:	83 c4 10             	add    $0x10,%esp
  800870:	83 ec 04             	sub    $0x4,%esp
  800873:	ff 75 20             	pushl  0x20(%ebp)
  800876:	53                   	push   %ebx
  800877:	ff 75 18             	pushl  0x18(%ebp)
  80087a:	52                   	push   %edx
  80087b:	50                   	push   %eax
  80087c:	ff 75 0c             	pushl  0xc(%ebp)
  80087f:	ff 75 08             	pushl  0x8(%ebp)
  800882:	e8 a1 ff ff ff       	call   800828 <printnum>
  800887:	83 c4 20             	add    $0x20,%esp
  80088a:	eb 1a                	jmp    8008a6 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80088c:	83 ec 08             	sub    $0x8,%esp
  80088f:	ff 75 0c             	pushl  0xc(%ebp)
  800892:	ff 75 20             	pushl  0x20(%ebp)
  800895:	8b 45 08             	mov    0x8(%ebp),%eax
  800898:	ff d0                	call   *%eax
  80089a:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80089d:	ff 4d 1c             	decl   0x1c(%ebp)
  8008a0:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  8008a4:	7f e6                	jg     80088c <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8008a6:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8008a9:	bb 00 00 00 00       	mov    $0x0,%ebx
  8008ae:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8008b1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8008b4:	53                   	push   %ebx
  8008b5:	51                   	push   %ecx
  8008b6:	52                   	push   %edx
  8008b7:	50                   	push   %eax
  8008b8:	e8 6b 14 00 00       	call   801d28 <__umoddi3>
  8008bd:	83 c4 10             	add    $0x10,%esp
  8008c0:	05 54 25 80 00       	add    $0x802554,%eax
  8008c5:	8a 00                	mov    (%eax),%al
  8008c7:	0f be c0             	movsbl %al,%eax
  8008ca:	83 ec 08             	sub    $0x8,%esp
  8008cd:	ff 75 0c             	pushl  0xc(%ebp)
  8008d0:	50                   	push   %eax
  8008d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8008d4:	ff d0                	call   *%eax
  8008d6:	83 c4 10             	add    $0x10,%esp
}
  8008d9:	90                   	nop
  8008da:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8008dd:	c9                   	leave  
  8008de:	c3                   	ret    

008008df <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8008df:	55                   	push   %ebp
  8008e0:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8008e2:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8008e6:	7e 1c                	jle    800904 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8008e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8008eb:	8b 00                	mov    (%eax),%eax
  8008ed:	8d 50 08             	lea    0x8(%eax),%edx
  8008f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8008f3:	89 10                	mov    %edx,(%eax)
  8008f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8008f8:	8b 00                	mov    (%eax),%eax
  8008fa:	83 e8 08             	sub    $0x8,%eax
  8008fd:	8b 50 04             	mov    0x4(%eax),%edx
  800900:	8b 00                	mov    (%eax),%eax
  800902:	eb 40                	jmp    800944 <getuint+0x65>
	else if (lflag)
  800904:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800908:	74 1e                	je     800928 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  80090a:	8b 45 08             	mov    0x8(%ebp),%eax
  80090d:	8b 00                	mov    (%eax),%eax
  80090f:	8d 50 04             	lea    0x4(%eax),%edx
  800912:	8b 45 08             	mov    0x8(%ebp),%eax
  800915:	89 10                	mov    %edx,(%eax)
  800917:	8b 45 08             	mov    0x8(%ebp),%eax
  80091a:	8b 00                	mov    (%eax),%eax
  80091c:	83 e8 04             	sub    $0x4,%eax
  80091f:	8b 00                	mov    (%eax),%eax
  800921:	ba 00 00 00 00       	mov    $0x0,%edx
  800926:	eb 1c                	jmp    800944 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800928:	8b 45 08             	mov    0x8(%ebp),%eax
  80092b:	8b 00                	mov    (%eax),%eax
  80092d:	8d 50 04             	lea    0x4(%eax),%edx
  800930:	8b 45 08             	mov    0x8(%ebp),%eax
  800933:	89 10                	mov    %edx,(%eax)
  800935:	8b 45 08             	mov    0x8(%ebp),%eax
  800938:	8b 00                	mov    (%eax),%eax
  80093a:	83 e8 04             	sub    $0x4,%eax
  80093d:	8b 00                	mov    (%eax),%eax
  80093f:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800944:	5d                   	pop    %ebp
  800945:	c3                   	ret    

00800946 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800946:	55                   	push   %ebp
  800947:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800949:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80094d:	7e 1c                	jle    80096b <getint+0x25>
		return va_arg(*ap, long long);
  80094f:	8b 45 08             	mov    0x8(%ebp),%eax
  800952:	8b 00                	mov    (%eax),%eax
  800954:	8d 50 08             	lea    0x8(%eax),%edx
  800957:	8b 45 08             	mov    0x8(%ebp),%eax
  80095a:	89 10                	mov    %edx,(%eax)
  80095c:	8b 45 08             	mov    0x8(%ebp),%eax
  80095f:	8b 00                	mov    (%eax),%eax
  800961:	83 e8 08             	sub    $0x8,%eax
  800964:	8b 50 04             	mov    0x4(%eax),%edx
  800967:	8b 00                	mov    (%eax),%eax
  800969:	eb 38                	jmp    8009a3 <getint+0x5d>
	else if (lflag)
  80096b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80096f:	74 1a                	je     80098b <getint+0x45>
		return va_arg(*ap, long);
  800971:	8b 45 08             	mov    0x8(%ebp),%eax
  800974:	8b 00                	mov    (%eax),%eax
  800976:	8d 50 04             	lea    0x4(%eax),%edx
  800979:	8b 45 08             	mov    0x8(%ebp),%eax
  80097c:	89 10                	mov    %edx,(%eax)
  80097e:	8b 45 08             	mov    0x8(%ebp),%eax
  800981:	8b 00                	mov    (%eax),%eax
  800983:	83 e8 04             	sub    $0x4,%eax
  800986:	8b 00                	mov    (%eax),%eax
  800988:	99                   	cltd   
  800989:	eb 18                	jmp    8009a3 <getint+0x5d>
	else
		return va_arg(*ap, int);
  80098b:	8b 45 08             	mov    0x8(%ebp),%eax
  80098e:	8b 00                	mov    (%eax),%eax
  800990:	8d 50 04             	lea    0x4(%eax),%edx
  800993:	8b 45 08             	mov    0x8(%ebp),%eax
  800996:	89 10                	mov    %edx,(%eax)
  800998:	8b 45 08             	mov    0x8(%ebp),%eax
  80099b:	8b 00                	mov    (%eax),%eax
  80099d:	83 e8 04             	sub    $0x4,%eax
  8009a0:	8b 00                	mov    (%eax),%eax
  8009a2:	99                   	cltd   
}
  8009a3:	5d                   	pop    %ebp
  8009a4:	c3                   	ret    

008009a5 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8009a5:	55                   	push   %ebp
  8009a6:	89 e5                	mov    %esp,%ebp
  8009a8:	56                   	push   %esi
  8009a9:	53                   	push   %ebx
  8009aa:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8009ad:	eb 17                	jmp    8009c6 <vprintfmt+0x21>
			if (ch == '\0')
  8009af:	85 db                	test   %ebx,%ebx
  8009b1:	0f 84 c1 03 00 00    	je     800d78 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  8009b7:	83 ec 08             	sub    $0x8,%esp
  8009ba:	ff 75 0c             	pushl  0xc(%ebp)
  8009bd:	53                   	push   %ebx
  8009be:	8b 45 08             	mov    0x8(%ebp),%eax
  8009c1:	ff d0                	call   *%eax
  8009c3:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8009c6:	8b 45 10             	mov    0x10(%ebp),%eax
  8009c9:	8d 50 01             	lea    0x1(%eax),%edx
  8009cc:	89 55 10             	mov    %edx,0x10(%ebp)
  8009cf:	8a 00                	mov    (%eax),%al
  8009d1:	0f b6 d8             	movzbl %al,%ebx
  8009d4:	83 fb 25             	cmp    $0x25,%ebx
  8009d7:	75 d6                	jne    8009af <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8009d9:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  8009dd:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  8009e4:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8009eb:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8009f2:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8009f9:	8b 45 10             	mov    0x10(%ebp),%eax
  8009fc:	8d 50 01             	lea    0x1(%eax),%edx
  8009ff:	89 55 10             	mov    %edx,0x10(%ebp)
  800a02:	8a 00                	mov    (%eax),%al
  800a04:	0f b6 d8             	movzbl %al,%ebx
  800a07:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800a0a:	83 f8 5b             	cmp    $0x5b,%eax
  800a0d:	0f 87 3d 03 00 00    	ja     800d50 <vprintfmt+0x3ab>
  800a13:	8b 04 85 78 25 80 00 	mov    0x802578(,%eax,4),%eax
  800a1a:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800a1c:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800a20:	eb d7                	jmp    8009f9 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800a22:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800a26:	eb d1                	jmp    8009f9 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800a28:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800a2f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800a32:	89 d0                	mov    %edx,%eax
  800a34:	c1 e0 02             	shl    $0x2,%eax
  800a37:	01 d0                	add    %edx,%eax
  800a39:	01 c0                	add    %eax,%eax
  800a3b:	01 d8                	add    %ebx,%eax
  800a3d:	83 e8 30             	sub    $0x30,%eax
  800a40:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800a43:	8b 45 10             	mov    0x10(%ebp),%eax
  800a46:	8a 00                	mov    (%eax),%al
  800a48:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800a4b:	83 fb 2f             	cmp    $0x2f,%ebx
  800a4e:	7e 3e                	jle    800a8e <vprintfmt+0xe9>
  800a50:	83 fb 39             	cmp    $0x39,%ebx
  800a53:	7f 39                	jg     800a8e <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800a55:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800a58:	eb d5                	jmp    800a2f <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800a5a:	8b 45 14             	mov    0x14(%ebp),%eax
  800a5d:	83 c0 04             	add    $0x4,%eax
  800a60:	89 45 14             	mov    %eax,0x14(%ebp)
  800a63:	8b 45 14             	mov    0x14(%ebp),%eax
  800a66:	83 e8 04             	sub    $0x4,%eax
  800a69:	8b 00                	mov    (%eax),%eax
  800a6b:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800a6e:	eb 1f                	jmp    800a8f <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800a70:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a74:	79 83                	jns    8009f9 <vprintfmt+0x54>
				width = 0;
  800a76:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800a7d:	e9 77 ff ff ff       	jmp    8009f9 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800a82:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800a89:	e9 6b ff ff ff       	jmp    8009f9 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800a8e:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800a8f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a93:	0f 89 60 ff ff ff    	jns    8009f9 <vprintfmt+0x54>
				width = precision, precision = -1;
  800a99:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800a9c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800a9f:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800aa6:	e9 4e ff ff ff       	jmp    8009f9 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800aab:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800aae:	e9 46 ff ff ff       	jmp    8009f9 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800ab3:	8b 45 14             	mov    0x14(%ebp),%eax
  800ab6:	83 c0 04             	add    $0x4,%eax
  800ab9:	89 45 14             	mov    %eax,0x14(%ebp)
  800abc:	8b 45 14             	mov    0x14(%ebp),%eax
  800abf:	83 e8 04             	sub    $0x4,%eax
  800ac2:	8b 00                	mov    (%eax),%eax
  800ac4:	83 ec 08             	sub    $0x8,%esp
  800ac7:	ff 75 0c             	pushl  0xc(%ebp)
  800aca:	50                   	push   %eax
  800acb:	8b 45 08             	mov    0x8(%ebp),%eax
  800ace:	ff d0                	call   *%eax
  800ad0:	83 c4 10             	add    $0x10,%esp
			break;
  800ad3:	e9 9b 02 00 00       	jmp    800d73 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800ad8:	8b 45 14             	mov    0x14(%ebp),%eax
  800adb:	83 c0 04             	add    $0x4,%eax
  800ade:	89 45 14             	mov    %eax,0x14(%ebp)
  800ae1:	8b 45 14             	mov    0x14(%ebp),%eax
  800ae4:	83 e8 04             	sub    $0x4,%eax
  800ae7:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800ae9:	85 db                	test   %ebx,%ebx
  800aeb:	79 02                	jns    800aef <vprintfmt+0x14a>
				err = -err;
  800aed:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800aef:	83 fb 64             	cmp    $0x64,%ebx
  800af2:	7f 0b                	jg     800aff <vprintfmt+0x15a>
  800af4:	8b 34 9d c0 23 80 00 	mov    0x8023c0(,%ebx,4),%esi
  800afb:	85 f6                	test   %esi,%esi
  800afd:	75 19                	jne    800b18 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800aff:	53                   	push   %ebx
  800b00:	68 65 25 80 00       	push   $0x802565
  800b05:	ff 75 0c             	pushl  0xc(%ebp)
  800b08:	ff 75 08             	pushl  0x8(%ebp)
  800b0b:	e8 70 02 00 00       	call   800d80 <printfmt>
  800b10:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800b13:	e9 5b 02 00 00       	jmp    800d73 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800b18:	56                   	push   %esi
  800b19:	68 6e 25 80 00       	push   $0x80256e
  800b1e:	ff 75 0c             	pushl  0xc(%ebp)
  800b21:	ff 75 08             	pushl  0x8(%ebp)
  800b24:	e8 57 02 00 00       	call   800d80 <printfmt>
  800b29:	83 c4 10             	add    $0x10,%esp
			break;
  800b2c:	e9 42 02 00 00       	jmp    800d73 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800b31:	8b 45 14             	mov    0x14(%ebp),%eax
  800b34:	83 c0 04             	add    $0x4,%eax
  800b37:	89 45 14             	mov    %eax,0x14(%ebp)
  800b3a:	8b 45 14             	mov    0x14(%ebp),%eax
  800b3d:	83 e8 04             	sub    $0x4,%eax
  800b40:	8b 30                	mov    (%eax),%esi
  800b42:	85 f6                	test   %esi,%esi
  800b44:	75 05                	jne    800b4b <vprintfmt+0x1a6>
				p = "(null)";
  800b46:	be 71 25 80 00       	mov    $0x802571,%esi
			if (width > 0 && padc != '-')
  800b4b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b4f:	7e 6d                	jle    800bbe <vprintfmt+0x219>
  800b51:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800b55:	74 67                	je     800bbe <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800b57:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800b5a:	83 ec 08             	sub    $0x8,%esp
  800b5d:	50                   	push   %eax
  800b5e:	56                   	push   %esi
  800b5f:	e8 1e 03 00 00       	call   800e82 <strnlen>
  800b64:	83 c4 10             	add    $0x10,%esp
  800b67:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800b6a:	eb 16                	jmp    800b82 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800b6c:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800b70:	83 ec 08             	sub    $0x8,%esp
  800b73:	ff 75 0c             	pushl  0xc(%ebp)
  800b76:	50                   	push   %eax
  800b77:	8b 45 08             	mov    0x8(%ebp),%eax
  800b7a:	ff d0                	call   *%eax
  800b7c:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800b7f:	ff 4d e4             	decl   -0x1c(%ebp)
  800b82:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b86:	7f e4                	jg     800b6c <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b88:	eb 34                	jmp    800bbe <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800b8a:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800b8e:	74 1c                	je     800bac <vprintfmt+0x207>
  800b90:	83 fb 1f             	cmp    $0x1f,%ebx
  800b93:	7e 05                	jle    800b9a <vprintfmt+0x1f5>
  800b95:	83 fb 7e             	cmp    $0x7e,%ebx
  800b98:	7e 12                	jle    800bac <vprintfmt+0x207>
					putch('?', putdat);
  800b9a:	83 ec 08             	sub    $0x8,%esp
  800b9d:	ff 75 0c             	pushl  0xc(%ebp)
  800ba0:	6a 3f                	push   $0x3f
  800ba2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ba5:	ff d0                	call   *%eax
  800ba7:	83 c4 10             	add    $0x10,%esp
  800baa:	eb 0f                	jmp    800bbb <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800bac:	83 ec 08             	sub    $0x8,%esp
  800baf:	ff 75 0c             	pushl  0xc(%ebp)
  800bb2:	53                   	push   %ebx
  800bb3:	8b 45 08             	mov    0x8(%ebp),%eax
  800bb6:	ff d0                	call   *%eax
  800bb8:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800bbb:	ff 4d e4             	decl   -0x1c(%ebp)
  800bbe:	89 f0                	mov    %esi,%eax
  800bc0:	8d 70 01             	lea    0x1(%eax),%esi
  800bc3:	8a 00                	mov    (%eax),%al
  800bc5:	0f be d8             	movsbl %al,%ebx
  800bc8:	85 db                	test   %ebx,%ebx
  800bca:	74 24                	je     800bf0 <vprintfmt+0x24b>
  800bcc:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800bd0:	78 b8                	js     800b8a <vprintfmt+0x1e5>
  800bd2:	ff 4d e0             	decl   -0x20(%ebp)
  800bd5:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800bd9:	79 af                	jns    800b8a <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800bdb:	eb 13                	jmp    800bf0 <vprintfmt+0x24b>
				putch(' ', putdat);
  800bdd:	83 ec 08             	sub    $0x8,%esp
  800be0:	ff 75 0c             	pushl  0xc(%ebp)
  800be3:	6a 20                	push   $0x20
  800be5:	8b 45 08             	mov    0x8(%ebp),%eax
  800be8:	ff d0                	call   *%eax
  800bea:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800bed:	ff 4d e4             	decl   -0x1c(%ebp)
  800bf0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800bf4:	7f e7                	jg     800bdd <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800bf6:	e9 78 01 00 00       	jmp    800d73 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800bfb:	83 ec 08             	sub    $0x8,%esp
  800bfe:	ff 75 e8             	pushl  -0x18(%ebp)
  800c01:	8d 45 14             	lea    0x14(%ebp),%eax
  800c04:	50                   	push   %eax
  800c05:	e8 3c fd ff ff       	call   800946 <getint>
  800c0a:	83 c4 10             	add    $0x10,%esp
  800c0d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c10:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800c13:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c16:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800c19:	85 d2                	test   %edx,%edx
  800c1b:	79 23                	jns    800c40 <vprintfmt+0x29b>
				putch('-', putdat);
  800c1d:	83 ec 08             	sub    $0x8,%esp
  800c20:	ff 75 0c             	pushl  0xc(%ebp)
  800c23:	6a 2d                	push   $0x2d
  800c25:	8b 45 08             	mov    0x8(%ebp),%eax
  800c28:	ff d0                	call   *%eax
  800c2a:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800c2d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c30:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800c33:	f7 d8                	neg    %eax
  800c35:	83 d2 00             	adc    $0x0,%edx
  800c38:	f7 da                	neg    %edx
  800c3a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c3d:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800c40:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800c47:	e9 bc 00 00 00       	jmp    800d08 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800c4c:	83 ec 08             	sub    $0x8,%esp
  800c4f:	ff 75 e8             	pushl  -0x18(%ebp)
  800c52:	8d 45 14             	lea    0x14(%ebp),%eax
  800c55:	50                   	push   %eax
  800c56:	e8 84 fc ff ff       	call   8008df <getuint>
  800c5b:	83 c4 10             	add    $0x10,%esp
  800c5e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c61:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800c64:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800c6b:	e9 98 00 00 00       	jmp    800d08 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800c70:	83 ec 08             	sub    $0x8,%esp
  800c73:	ff 75 0c             	pushl  0xc(%ebp)
  800c76:	6a 58                	push   $0x58
  800c78:	8b 45 08             	mov    0x8(%ebp),%eax
  800c7b:	ff d0                	call   *%eax
  800c7d:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800c80:	83 ec 08             	sub    $0x8,%esp
  800c83:	ff 75 0c             	pushl  0xc(%ebp)
  800c86:	6a 58                	push   $0x58
  800c88:	8b 45 08             	mov    0x8(%ebp),%eax
  800c8b:	ff d0                	call   *%eax
  800c8d:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800c90:	83 ec 08             	sub    $0x8,%esp
  800c93:	ff 75 0c             	pushl  0xc(%ebp)
  800c96:	6a 58                	push   $0x58
  800c98:	8b 45 08             	mov    0x8(%ebp),%eax
  800c9b:	ff d0                	call   *%eax
  800c9d:	83 c4 10             	add    $0x10,%esp
			break;
  800ca0:	e9 ce 00 00 00       	jmp    800d73 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800ca5:	83 ec 08             	sub    $0x8,%esp
  800ca8:	ff 75 0c             	pushl  0xc(%ebp)
  800cab:	6a 30                	push   $0x30
  800cad:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb0:	ff d0                	call   *%eax
  800cb2:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800cb5:	83 ec 08             	sub    $0x8,%esp
  800cb8:	ff 75 0c             	pushl  0xc(%ebp)
  800cbb:	6a 78                	push   $0x78
  800cbd:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc0:	ff d0                	call   *%eax
  800cc2:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800cc5:	8b 45 14             	mov    0x14(%ebp),%eax
  800cc8:	83 c0 04             	add    $0x4,%eax
  800ccb:	89 45 14             	mov    %eax,0x14(%ebp)
  800cce:	8b 45 14             	mov    0x14(%ebp),%eax
  800cd1:	83 e8 04             	sub    $0x4,%eax
  800cd4:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800cd6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800cd9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800ce0:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800ce7:	eb 1f                	jmp    800d08 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800ce9:	83 ec 08             	sub    $0x8,%esp
  800cec:	ff 75 e8             	pushl  -0x18(%ebp)
  800cef:	8d 45 14             	lea    0x14(%ebp),%eax
  800cf2:	50                   	push   %eax
  800cf3:	e8 e7 fb ff ff       	call   8008df <getuint>
  800cf8:	83 c4 10             	add    $0x10,%esp
  800cfb:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800cfe:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800d01:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800d08:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800d0c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800d0f:	83 ec 04             	sub    $0x4,%esp
  800d12:	52                   	push   %edx
  800d13:	ff 75 e4             	pushl  -0x1c(%ebp)
  800d16:	50                   	push   %eax
  800d17:	ff 75 f4             	pushl  -0xc(%ebp)
  800d1a:	ff 75 f0             	pushl  -0x10(%ebp)
  800d1d:	ff 75 0c             	pushl  0xc(%ebp)
  800d20:	ff 75 08             	pushl  0x8(%ebp)
  800d23:	e8 00 fb ff ff       	call   800828 <printnum>
  800d28:	83 c4 20             	add    $0x20,%esp
			break;
  800d2b:	eb 46                	jmp    800d73 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800d2d:	83 ec 08             	sub    $0x8,%esp
  800d30:	ff 75 0c             	pushl  0xc(%ebp)
  800d33:	53                   	push   %ebx
  800d34:	8b 45 08             	mov    0x8(%ebp),%eax
  800d37:	ff d0                	call   *%eax
  800d39:	83 c4 10             	add    $0x10,%esp
			break;
  800d3c:	eb 35                	jmp    800d73 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800d3e:	c6 05 84 30 80 00 00 	movb   $0x0,0x803084
			break;
  800d45:	eb 2c                	jmp    800d73 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800d47:	c6 05 84 30 80 00 01 	movb   $0x1,0x803084
			break;
  800d4e:	eb 23                	jmp    800d73 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800d50:	83 ec 08             	sub    $0x8,%esp
  800d53:	ff 75 0c             	pushl  0xc(%ebp)
  800d56:	6a 25                	push   $0x25
  800d58:	8b 45 08             	mov    0x8(%ebp),%eax
  800d5b:	ff d0                	call   *%eax
  800d5d:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800d60:	ff 4d 10             	decl   0x10(%ebp)
  800d63:	eb 03                	jmp    800d68 <vprintfmt+0x3c3>
  800d65:	ff 4d 10             	decl   0x10(%ebp)
  800d68:	8b 45 10             	mov    0x10(%ebp),%eax
  800d6b:	48                   	dec    %eax
  800d6c:	8a 00                	mov    (%eax),%al
  800d6e:	3c 25                	cmp    $0x25,%al
  800d70:	75 f3                	jne    800d65 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800d72:	90                   	nop
		}
	}
  800d73:	e9 35 fc ff ff       	jmp    8009ad <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800d78:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800d79:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800d7c:	5b                   	pop    %ebx
  800d7d:	5e                   	pop    %esi
  800d7e:	5d                   	pop    %ebp
  800d7f:	c3                   	ret    

00800d80 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800d80:	55                   	push   %ebp
  800d81:	89 e5                	mov    %esp,%ebp
  800d83:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800d86:	8d 45 10             	lea    0x10(%ebp),%eax
  800d89:	83 c0 04             	add    $0x4,%eax
  800d8c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800d8f:	8b 45 10             	mov    0x10(%ebp),%eax
  800d92:	ff 75 f4             	pushl  -0xc(%ebp)
  800d95:	50                   	push   %eax
  800d96:	ff 75 0c             	pushl  0xc(%ebp)
  800d99:	ff 75 08             	pushl  0x8(%ebp)
  800d9c:	e8 04 fc ff ff       	call   8009a5 <vprintfmt>
  800da1:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800da4:	90                   	nop
  800da5:	c9                   	leave  
  800da6:	c3                   	ret    

00800da7 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800da7:	55                   	push   %ebp
  800da8:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800daa:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dad:	8b 40 08             	mov    0x8(%eax),%eax
  800db0:	8d 50 01             	lea    0x1(%eax),%edx
  800db3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800db6:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800db9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dbc:	8b 10                	mov    (%eax),%edx
  800dbe:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dc1:	8b 40 04             	mov    0x4(%eax),%eax
  800dc4:	39 c2                	cmp    %eax,%edx
  800dc6:	73 12                	jae    800dda <sprintputch+0x33>
		*b->buf++ = ch;
  800dc8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dcb:	8b 00                	mov    (%eax),%eax
  800dcd:	8d 48 01             	lea    0x1(%eax),%ecx
  800dd0:	8b 55 0c             	mov    0xc(%ebp),%edx
  800dd3:	89 0a                	mov    %ecx,(%edx)
  800dd5:	8b 55 08             	mov    0x8(%ebp),%edx
  800dd8:	88 10                	mov    %dl,(%eax)
}
  800dda:	90                   	nop
  800ddb:	5d                   	pop    %ebp
  800ddc:	c3                   	ret    

00800ddd <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800ddd:	55                   	push   %ebp
  800dde:	89 e5                	mov    %esp,%ebp
  800de0:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800de3:	8b 45 08             	mov    0x8(%ebp),%eax
  800de6:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800de9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dec:	8d 50 ff             	lea    -0x1(%eax),%edx
  800def:	8b 45 08             	mov    0x8(%ebp),%eax
  800df2:	01 d0                	add    %edx,%eax
  800df4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800df7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800dfe:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800e02:	74 06                	je     800e0a <vsnprintf+0x2d>
  800e04:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e08:	7f 07                	jg     800e11 <vsnprintf+0x34>
		return -E_INVAL;
  800e0a:	b8 03 00 00 00       	mov    $0x3,%eax
  800e0f:	eb 20                	jmp    800e31 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800e11:	ff 75 14             	pushl  0x14(%ebp)
  800e14:	ff 75 10             	pushl  0x10(%ebp)
  800e17:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800e1a:	50                   	push   %eax
  800e1b:	68 a7 0d 80 00       	push   $0x800da7
  800e20:	e8 80 fb ff ff       	call   8009a5 <vprintfmt>
  800e25:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800e28:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800e2b:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800e2e:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800e31:	c9                   	leave  
  800e32:	c3                   	ret    

00800e33 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800e33:	55                   	push   %ebp
  800e34:	89 e5                	mov    %esp,%ebp
  800e36:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800e39:	8d 45 10             	lea    0x10(%ebp),%eax
  800e3c:	83 c0 04             	add    $0x4,%eax
  800e3f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800e42:	8b 45 10             	mov    0x10(%ebp),%eax
  800e45:	ff 75 f4             	pushl  -0xc(%ebp)
  800e48:	50                   	push   %eax
  800e49:	ff 75 0c             	pushl  0xc(%ebp)
  800e4c:	ff 75 08             	pushl  0x8(%ebp)
  800e4f:	e8 89 ff ff ff       	call   800ddd <vsnprintf>
  800e54:	83 c4 10             	add    $0x10,%esp
  800e57:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800e5a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800e5d:	c9                   	leave  
  800e5e:	c3                   	ret    

00800e5f <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800e5f:	55                   	push   %ebp
  800e60:	89 e5                	mov    %esp,%ebp
  800e62:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800e65:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800e6c:	eb 06                	jmp    800e74 <strlen+0x15>
		n++;
  800e6e:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800e71:	ff 45 08             	incl   0x8(%ebp)
  800e74:	8b 45 08             	mov    0x8(%ebp),%eax
  800e77:	8a 00                	mov    (%eax),%al
  800e79:	84 c0                	test   %al,%al
  800e7b:	75 f1                	jne    800e6e <strlen+0xf>
		n++;
	return n;
  800e7d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e80:	c9                   	leave  
  800e81:	c3                   	ret    

00800e82 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800e82:	55                   	push   %ebp
  800e83:	89 e5                	mov    %esp,%ebp
  800e85:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800e88:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800e8f:	eb 09                	jmp    800e9a <strnlen+0x18>
		n++;
  800e91:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800e94:	ff 45 08             	incl   0x8(%ebp)
  800e97:	ff 4d 0c             	decl   0xc(%ebp)
  800e9a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e9e:	74 09                	je     800ea9 <strnlen+0x27>
  800ea0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ea3:	8a 00                	mov    (%eax),%al
  800ea5:	84 c0                	test   %al,%al
  800ea7:	75 e8                	jne    800e91 <strnlen+0xf>
		n++;
	return n;
  800ea9:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800eac:	c9                   	leave  
  800ead:	c3                   	ret    

00800eae <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800eae:	55                   	push   %ebp
  800eaf:	89 e5                	mov    %esp,%ebp
  800eb1:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800eb4:	8b 45 08             	mov    0x8(%ebp),%eax
  800eb7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800eba:	90                   	nop
  800ebb:	8b 45 08             	mov    0x8(%ebp),%eax
  800ebe:	8d 50 01             	lea    0x1(%eax),%edx
  800ec1:	89 55 08             	mov    %edx,0x8(%ebp)
  800ec4:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ec7:	8d 4a 01             	lea    0x1(%edx),%ecx
  800eca:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800ecd:	8a 12                	mov    (%edx),%dl
  800ecf:	88 10                	mov    %dl,(%eax)
  800ed1:	8a 00                	mov    (%eax),%al
  800ed3:	84 c0                	test   %al,%al
  800ed5:	75 e4                	jne    800ebb <strcpy+0xd>
		/* do nothing */;
	return ret;
  800ed7:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800eda:	c9                   	leave  
  800edb:	c3                   	ret    

00800edc <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800edc:	55                   	push   %ebp
  800edd:	89 e5                	mov    %esp,%ebp
  800edf:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800ee2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ee5:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800ee8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800eef:	eb 1f                	jmp    800f10 <strncpy+0x34>
		*dst++ = *src;
  800ef1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef4:	8d 50 01             	lea    0x1(%eax),%edx
  800ef7:	89 55 08             	mov    %edx,0x8(%ebp)
  800efa:	8b 55 0c             	mov    0xc(%ebp),%edx
  800efd:	8a 12                	mov    (%edx),%dl
  800eff:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800f01:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f04:	8a 00                	mov    (%eax),%al
  800f06:	84 c0                	test   %al,%al
  800f08:	74 03                	je     800f0d <strncpy+0x31>
			src++;
  800f0a:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800f0d:	ff 45 fc             	incl   -0x4(%ebp)
  800f10:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f13:	3b 45 10             	cmp    0x10(%ebp),%eax
  800f16:	72 d9                	jb     800ef1 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800f18:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800f1b:	c9                   	leave  
  800f1c:	c3                   	ret    

00800f1d <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800f1d:	55                   	push   %ebp
  800f1e:	89 e5                	mov    %esp,%ebp
  800f20:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800f23:	8b 45 08             	mov    0x8(%ebp),%eax
  800f26:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800f29:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f2d:	74 30                	je     800f5f <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800f2f:	eb 16                	jmp    800f47 <strlcpy+0x2a>
			*dst++ = *src++;
  800f31:	8b 45 08             	mov    0x8(%ebp),%eax
  800f34:	8d 50 01             	lea    0x1(%eax),%edx
  800f37:	89 55 08             	mov    %edx,0x8(%ebp)
  800f3a:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f3d:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f40:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800f43:	8a 12                	mov    (%edx),%dl
  800f45:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800f47:	ff 4d 10             	decl   0x10(%ebp)
  800f4a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f4e:	74 09                	je     800f59 <strlcpy+0x3c>
  800f50:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f53:	8a 00                	mov    (%eax),%al
  800f55:	84 c0                	test   %al,%al
  800f57:	75 d8                	jne    800f31 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800f59:	8b 45 08             	mov    0x8(%ebp),%eax
  800f5c:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800f5f:	8b 55 08             	mov    0x8(%ebp),%edx
  800f62:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f65:	29 c2                	sub    %eax,%edx
  800f67:	89 d0                	mov    %edx,%eax
}
  800f69:	c9                   	leave  
  800f6a:	c3                   	ret    

00800f6b <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800f6b:	55                   	push   %ebp
  800f6c:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800f6e:	eb 06                	jmp    800f76 <strcmp+0xb>
		p++, q++;
  800f70:	ff 45 08             	incl   0x8(%ebp)
  800f73:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800f76:	8b 45 08             	mov    0x8(%ebp),%eax
  800f79:	8a 00                	mov    (%eax),%al
  800f7b:	84 c0                	test   %al,%al
  800f7d:	74 0e                	je     800f8d <strcmp+0x22>
  800f7f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f82:	8a 10                	mov    (%eax),%dl
  800f84:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f87:	8a 00                	mov    (%eax),%al
  800f89:	38 c2                	cmp    %al,%dl
  800f8b:	74 e3                	je     800f70 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800f8d:	8b 45 08             	mov    0x8(%ebp),%eax
  800f90:	8a 00                	mov    (%eax),%al
  800f92:	0f b6 d0             	movzbl %al,%edx
  800f95:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f98:	8a 00                	mov    (%eax),%al
  800f9a:	0f b6 c0             	movzbl %al,%eax
  800f9d:	29 c2                	sub    %eax,%edx
  800f9f:	89 d0                	mov    %edx,%eax
}
  800fa1:	5d                   	pop    %ebp
  800fa2:	c3                   	ret    

00800fa3 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800fa3:	55                   	push   %ebp
  800fa4:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800fa6:	eb 09                	jmp    800fb1 <strncmp+0xe>
		n--, p++, q++;
  800fa8:	ff 4d 10             	decl   0x10(%ebp)
  800fab:	ff 45 08             	incl   0x8(%ebp)
  800fae:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800fb1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fb5:	74 17                	je     800fce <strncmp+0x2b>
  800fb7:	8b 45 08             	mov    0x8(%ebp),%eax
  800fba:	8a 00                	mov    (%eax),%al
  800fbc:	84 c0                	test   %al,%al
  800fbe:	74 0e                	je     800fce <strncmp+0x2b>
  800fc0:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc3:	8a 10                	mov    (%eax),%dl
  800fc5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fc8:	8a 00                	mov    (%eax),%al
  800fca:	38 c2                	cmp    %al,%dl
  800fcc:	74 da                	je     800fa8 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800fce:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fd2:	75 07                	jne    800fdb <strncmp+0x38>
		return 0;
  800fd4:	b8 00 00 00 00       	mov    $0x0,%eax
  800fd9:	eb 14                	jmp    800fef <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800fdb:	8b 45 08             	mov    0x8(%ebp),%eax
  800fde:	8a 00                	mov    (%eax),%al
  800fe0:	0f b6 d0             	movzbl %al,%edx
  800fe3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fe6:	8a 00                	mov    (%eax),%al
  800fe8:	0f b6 c0             	movzbl %al,%eax
  800feb:	29 c2                	sub    %eax,%edx
  800fed:	89 d0                	mov    %edx,%eax
}
  800fef:	5d                   	pop    %ebp
  800ff0:	c3                   	ret    

00800ff1 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800ff1:	55                   	push   %ebp
  800ff2:	89 e5                	mov    %esp,%ebp
  800ff4:	83 ec 04             	sub    $0x4,%esp
  800ff7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ffa:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800ffd:	eb 12                	jmp    801011 <strchr+0x20>
		if (*s == c)
  800fff:	8b 45 08             	mov    0x8(%ebp),%eax
  801002:	8a 00                	mov    (%eax),%al
  801004:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801007:	75 05                	jne    80100e <strchr+0x1d>
			return (char *) s;
  801009:	8b 45 08             	mov    0x8(%ebp),%eax
  80100c:	eb 11                	jmp    80101f <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  80100e:	ff 45 08             	incl   0x8(%ebp)
  801011:	8b 45 08             	mov    0x8(%ebp),%eax
  801014:	8a 00                	mov    (%eax),%al
  801016:	84 c0                	test   %al,%al
  801018:	75 e5                	jne    800fff <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  80101a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80101f:	c9                   	leave  
  801020:	c3                   	ret    

00801021 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801021:	55                   	push   %ebp
  801022:	89 e5                	mov    %esp,%ebp
  801024:	83 ec 04             	sub    $0x4,%esp
  801027:	8b 45 0c             	mov    0xc(%ebp),%eax
  80102a:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  80102d:	eb 0d                	jmp    80103c <strfind+0x1b>
		if (*s == c)
  80102f:	8b 45 08             	mov    0x8(%ebp),%eax
  801032:	8a 00                	mov    (%eax),%al
  801034:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801037:	74 0e                	je     801047 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801039:	ff 45 08             	incl   0x8(%ebp)
  80103c:	8b 45 08             	mov    0x8(%ebp),%eax
  80103f:	8a 00                	mov    (%eax),%al
  801041:	84 c0                	test   %al,%al
  801043:	75 ea                	jne    80102f <strfind+0xe>
  801045:	eb 01                	jmp    801048 <strfind+0x27>
		if (*s == c)
			break;
  801047:	90                   	nop
	return (char *) s;
  801048:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80104b:	c9                   	leave  
  80104c:	c3                   	ret    

0080104d <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  80104d:	55                   	push   %ebp
  80104e:	89 e5                	mov    %esp,%ebp
  801050:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  801053:	8b 45 08             	mov    0x8(%ebp),%eax
  801056:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  801059:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  80105d:	76 63                	jbe    8010c2 <memset+0x75>
		uint64 data_block = c;
  80105f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801062:	99                   	cltd   
  801063:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801066:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  801069:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80106c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80106f:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  801073:	c1 e0 08             	shl    $0x8,%eax
  801076:	09 45 f0             	or     %eax,-0x10(%ebp)
  801079:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  80107c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80107f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801082:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  801086:	c1 e0 10             	shl    $0x10,%eax
  801089:	09 45 f0             	or     %eax,-0x10(%ebp)
  80108c:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  80108f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801092:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801095:	89 c2                	mov    %eax,%edx
  801097:	b8 00 00 00 00       	mov    $0x0,%eax
  80109c:	09 45 f0             	or     %eax,-0x10(%ebp)
  80109f:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  8010a2:	eb 18                	jmp    8010bc <memset+0x6f>
			*p64++ = data_block, n -= 8;
  8010a4:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8010a7:	8d 41 08             	lea    0x8(%ecx),%eax
  8010aa:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8010ad:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8010b0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8010b3:	89 01                	mov    %eax,(%ecx)
  8010b5:	89 51 04             	mov    %edx,0x4(%ecx)
  8010b8:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  8010bc:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  8010c0:	77 e2                	ja     8010a4 <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  8010c2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010c6:	74 23                	je     8010eb <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  8010c8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010cb:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  8010ce:	eb 0e                	jmp    8010de <memset+0x91>
			*p8++ = (uint8)c;
  8010d0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010d3:	8d 50 01             	lea    0x1(%eax),%edx
  8010d6:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8010d9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010dc:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  8010de:	8b 45 10             	mov    0x10(%ebp),%eax
  8010e1:	8d 50 ff             	lea    -0x1(%eax),%edx
  8010e4:	89 55 10             	mov    %edx,0x10(%ebp)
  8010e7:	85 c0                	test   %eax,%eax
  8010e9:	75 e5                	jne    8010d0 <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  8010eb:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8010ee:	c9                   	leave  
  8010ef:	c3                   	ret    

008010f0 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  8010f0:	55                   	push   %ebp
  8010f1:	89 e5                	mov    %esp,%ebp
  8010f3:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  8010f6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010f9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  8010fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ff:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  801102:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801106:	76 24                	jbe    80112c <memcpy+0x3c>
		while(n >= 8){
  801108:	eb 1c                	jmp    801126 <memcpy+0x36>
			*d64 = *s64;
  80110a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80110d:	8b 50 04             	mov    0x4(%eax),%edx
  801110:	8b 00                	mov    (%eax),%eax
  801112:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801115:	89 01                	mov    %eax,(%ecx)
  801117:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  80111a:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  80111e:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  801122:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  801126:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  80112a:	77 de                	ja     80110a <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  80112c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801130:	74 31                	je     801163 <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  801132:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801135:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  801138:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80113b:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  80113e:	eb 16                	jmp    801156 <memcpy+0x66>
			*d8++ = *s8++;
  801140:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801143:	8d 50 01             	lea    0x1(%eax),%edx
  801146:	89 55 f0             	mov    %edx,-0x10(%ebp)
  801149:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80114c:	8d 4a 01             	lea    0x1(%edx),%ecx
  80114f:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  801152:	8a 12                	mov    (%edx),%dl
  801154:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  801156:	8b 45 10             	mov    0x10(%ebp),%eax
  801159:	8d 50 ff             	lea    -0x1(%eax),%edx
  80115c:	89 55 10             	mov    %edx,0x10(%ebp)
  80115f:	85 c0                	test   %eax,%eax
  801161:	75 dd                	jne    801140 <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  801163:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801166:	c9                   	leave  
  801167:	c3                   	ret    

00801168 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801168:	55                   	push   %ebp
  801169:	89 e5                	mov    %esp,%ebp
  80116b:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  80116e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801171:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801174:	8b 45 08             	mov    0x8(%ebp),%eax
  801177:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  80117a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80117d:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801180:	73 50                	jae    8011d2 <memmove+0x6a>
  801182:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801185:	8b 45 10             	mov    0x10(%ebp),%eax
  801188:	01 d0                	add    %edx,%eax
  80118a:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80118d:	76 43                	jbe    8011d2 <memmove+0x6a>
		s += n;
  80118f:	8b 45 10             	mov    0x10(%ebp),%eax
  801192:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801195:	8b 45 10             	mov    0x10(%ebp),%eax
  801198:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  80119b:	eb 10                	jmp    8011ad <memmove+0x45>
			*--d = *--s;
  80119d:	ff 4d f8             	decl   -0x8(%ebp)
  8011a0:	ff 4d fc             	decl   -0x4(%ebp)
  8011a3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011a6:	8a 10                	mov    (%eax),%dl
  8011a8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011ab:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  8011ad:	8b 45 10             	mov    0x10(%ebp),%eax
  8011b0:	8d 50 ff             	lea    -0x1(%eax),%edx
  8011b3:	89 55 10             	mov    %edx,0x10(%ebp)
  8011b6:	85 c0                	test   %eax,%eax
  8011b8:	75 e3                	jne    80119d <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8011ba:	eb 23                	jmp    8011df <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  8011bc:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011bf:	8d 50 01             	lea    0x1(%eax),%edx
  8011c2:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8011c5:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8011c8:	8d 4a 01             	lea    0x1(%edx),%ecx
  8011cb:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8011ce:	8a 12                	mov    (%edx),%dl
  8011d0:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  8011d2:	8b 45 10             	mov    0x10(%ebp),%eax
  8011d5:	8d 50 ff             	lea    -0x1(%eax),%edx
  8011d8:	89 55 10             	mov    %edx,0x10(%ebp)
  8011db:	85 c0                	test   %eax,%eax
  8011dd:	75 dd                	jne    8011bc <memmove+0x54>
			*d++ = *s++;

	return dst;
  8011df:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8011e2:	c9                   	leave  
  8011e3:	c3                   	ret    

008011e4 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8011e4:	55                   	push   %ebp
  8011e5:	89 e5                	mov    %esp,%ebp
  8011e7:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  8011ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ed:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  8011f0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011f3:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8011f6:	eb 2a                	jmp    801222 <memcmp+0x3e>
		if (*s1 != *s2)
  8011f8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011fb:	8a 10                	mov    (%eax),%dl
  8011fd:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801200:	8a 00                	mov    (%eax),%al
  801202:	38 c2                	cmp    %al,%dl
  801204:	74 16                	je     80121c <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801206:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801209:	8a 00                	mov    (%eax),%al
  80120b:	0f b6 d0             	movzbl %al,%edx
  80120e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801211:	8a 00                	mov    (%eax),%al
  801213:	0f b6 c0             	movzbl %al,%eax
  801216:	29 c2                	sub    %eax,%edx
  801218:	89 d0                	mov    %edx,%eax
  80121a:	eb 18                	jmp    801234 <memcmp+0x50>
		s1++, s2++;
  80121c:	ff 45 fc             	incl   -0x4(%ebp)
  80121f:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801222:	8b 45 10             	mov    0x10(%ebp),%eax
  801225:	8d 50 ff             	lea    -0x1(%eax),%edx
  801228:	89 55 10             	mov    %edx,0x10(%ebp)
  80122b:	85 c0                	test   %eax,%eax
  80122d:	75 c9                	jne    8011f8 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  80122f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801234:	c9                   	leave  
  801235:	c3                   	ret    

00801236 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801236:	55                   	push   %ebp
  801237:	89 e5                	mov    %esp,%ebp
  801239:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  80123c:	8b 55 08             	mov    0x8(%ebp),%edx
  80123f:	8b 45 10             	mov    0x10(%ebp),%eax
  801242:	01 d0                	add    %edx,%eax
  801244:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801247:	eb 15                	jmp    80125e <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801249:	8b 45 08             	mov    0x8(%ebp),%eax
  80124c:	8a 00                	mov    (%eax),%al
  80124e:	0f b6 d0             	movzbl %al,%edx
  801251:	8b 45 0c             	mov    0xc(%ebp),%eax
  801254:	0f b6 c0             	movzbl %al,%eax
  801257:	39 c2                	cmp    %eax,%edx
  801259:	74 0d                	je     801268 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80125b:	ff 45 08             	incl   0x8(%ebp)
  80125e:	8b 45 08             	mov    0x8(%ebp),%eax
  801261:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801264:	72 e3                	jb     801249 <memfind+0x13>
  801266:	eb 01                	jmp    801269 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801268:	90                   	nop
	return (void *) s;
  801269:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80126c:	c9                   	leave  
  80126d:	c3                   	ret    

0080126e <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80126e:	55                   	push   %ebp
  80126f:	89 e5                	mov    %esp,%ebp
  801271:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801274:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  80127b:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801282:	eb 03                	jmp    801287 <strtol+0x19>
		s++;
  801284:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801287:	8b 45 08             	mov    0x8(%ebp),%eax
  80128a:	8a 00                	mov    (%eax),%al
  80128c:	3c 20                	cmp    $0x20,%al
  80128e:	74 f4                	je     801284 <strtol+0x16>
  801290:	8b 45 08             	mov    0x8(%ebp),%eax
  801293:	8a 00                	mov    (%eax),%al
  801295:	3c 09                	cmp    $0x9,%al
  801297:	74 eb                	je     801284 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801299:	8b 45 08             	mov    0x8(%ebp),%eax
  80129c:	8a 00                	mov    (%eax),%al
  80129e:	3c 2b                	cmp    $0x2b,%al
  8012a0:	75 05                	jne    8012a7 <strtol+0x39>
		s++;
  8012a2:	ff 45 08             	incl   0x8(%ebp)
  8012a5:	eb 13                	jmp    8012ba <strtol+0x4c>
	else if (*s == '-')
  8012a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8012aa:	8a 00                	mov    (%eax),%al
  8012ac:	3c 2d                	cmp    $0x2d,%al
  8012ae:	75 0a                	jne    8012ba <strtol+0x4c>
		s++, neg = 1;
  8012b0:	ff 45 08             	incl   0x8(%ebp)
  8012b3:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8012ba:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8012be:	74 06                	je     8012c6 <strtol+0x58>
  8012c0:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8012c4:	75 20                	jne    8012e6 <strtol+0x78>
  8012c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8012c9:	8a 00                	mov    (%eax),%al
  8012cb:	3c 30                	cmp    $0x30,%al
  8012cd:	75 17                	jne    8012e6 <strtol+0x78>
  8012cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8012d2:	40                   	inc    %eax
  8012d3:	8a 00                	mov    (%eax),%al
  8012d5:	3c 78                	cmp    $0x78,%al
  8012d7:	75 0d                	jne    8012e6 <strtol+0x78>
		s += 2, base = 16;
  8012d9:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8012dd:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8012e4:	eb 28                	jmp    80130e <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8012e6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8012ea:	75 15                	jne    801301 <strtol+0x93>
  8012ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8012ef:	8a 00                	mov    (%eax),%al
  8012f1:	3c 30                	cmp    $0x30,%al
  8012f3:	75 0c                	jne    801301 <strtol+0x93>
		s++, base = 8;
  8012f5:	ff 45 08             	incl   0x8(%ebp)
  8012f8:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8012ff:	eb 0d                	jmp    80130e <strtol+0xa0>
	else if (base == 0)
  801301:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801305:	75 07                	jne    80130e <strtol+0xa0>
		base = 10;
  801307:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  80130e:	8b 45 08             	mov    0x8(%ebp),%eax
  801311:	8a 00                	mov    (%eax),%al
  801313:	3c 2f                	cmp    $0x2f,%al
  801315:	7e 19                	jle    801330 <strtol+0xc2>
  801317:	8b 45 08             	mov    0x8(%ebp),%eax
  80131a:	8a 00                	mov    (%eax),%al
  80131c:	3c 39                	cmp    $0x39,%al
  80131e:	7f 10                	jg     801330 <strtol+0xc2>
			dig = *s - '0';
  801320:	8b 45 08             	mov    0x8(%ebp),%eax
  801323:	8a 00                	mov    (%eax),%al
  801325:	0f be c0             	movsbl %al,%eax
  801328:	83 e8 30             	sub    $0x30,%eax
  80132b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80132e:	eb 42                	jmp    801372 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801330:	8b 45 08             	mov    0x8(%ebp),%eax
  801333:	8a 00                	mov    (%eax),%al
  801335:	3c 60                	cmp    $0x60,%al
  801337:	7e 19                	jle    801352 <strtol+0xe4>
  801339:	8b 45 08             	mov    0x8(%ebp),%eax
  80133c:	8a 00                	mov    (%eax),%al
  80133e:	3c 7a                	cmp    $0x7a,%al
  801340:	7f 10                	jg     801352 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801342:	8b 45 08             	mov    0x8(%ebp),%eax
  801345:	8a 00                	mov    (%eax),%al
  801347:	0f be c0             	movsbl %al,%eax
  80134a:	83 e8 57             	sub    $0x57,%eax
  80134d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801350:	eb 20                	jmp    801372 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801352:	8b 45 08             	mov    0x8(%ebp),%eax
  801355:	8a 00                	mov    (%eax),%al
  801357:	3c 40                	cmp    $0x40,%al
  801359:	7e 39                	jle    801394 <strtol+0x126>
  80135b:	8b 45 08             	mov    0x8(%ebp),%eax
  80135e:	8a 00                	mov    (%eax),%al
  801360:	3c 5a                	cmp    $0x5a,%al
  801362:	7f 30                	jg     801394 <strtol+0x126>
			dig = *s - 'A' + 10;
  801364:	8b 45 08             	mov    0x8(%ebp),%eax
  801367:	8a 00                	mov    (%eax),%al
  801369:	0f be c0             	movsbl %al,%eax
  80136c:	83 e8 37             	sub    $0x37,%eax
  80136f:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801372:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801375:	3b 45 10             	cmp    0x10(%ebp),%eax
  801378:	7d 19                	jge    801393 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  80137a:	ff 45 08             	incl   0x8(%ebp)
  80137d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801380:	0f af 45 10          	imul   0x10(%ebp),%eax
  801384:	89 c2                	mov    %eax,%edx
  801386:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801389:	01 d0                	add    %edx,%eax
  80138b:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  80138e:	e9 7b ff ff ff       	jmp    80130e <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801393:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801394:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801398:	74 08                	je     8013a2 <strtol+0x134>
		*endptr = (char *) s;
  80139a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80139d:	8b 55 08             	mov    0x8(%ebp),%edx
  8013a0:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8013a2:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8013a6:	74 07                	je     8013af <strtol+0x141>
  8013a8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8013ab:	f7 d8                	neg    %eax
  8013ad:	eb 03                	jmp    8013b2 <strtol+0x144>
  8013af:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8013b2:	c9                   	leave  
  8013b3:	c3                   	ret    

008013b4 <ltostr>:

void
ltostr(long value, char *str)
{
  8013b4:	55                   	push   %ebp
  8013b5:	89 e5                	mov    %esp,%ebp
  8013b7:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8013ba:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8013c1:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8013c8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8013cc:	79 13                	jns    8013e1 <ltostr+0x2d>
	{
		neg = 1;
  8013ce:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8013d5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013d8:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8013db:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8013de:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8013e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8013e4:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8013e9:	99                   	cltd   
  8013ea:	f7 f9                	idiv   %ecx
  8013ec:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8013ef:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8013f2:	8d 50 01             	lea    0x1(%eax),%edx
  8013f5:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8013f8:	89 c2                	mov    %eax,%edx
  8013fa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013fd:	01 d0                	add    %edx,%eax
  8013ff:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801402:	83 c2 30             	add    $0x30,%edx
  801405:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801407:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80140a:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80140f:	f7 e9                	imul   %ecx
  801411:	c1 fa 02             	sar    $0x2,%edx
  801414:	89 c8                	mov    %ecx,%eax
  801416:	c1 f8 1f             	sar    $0x1f,%eax
  801419:	29 c2                	sub    %eax,%edx
  80141b:	89 d0                	mov    %edx,%eax
  80141d:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  801420:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801424:	75 bb                	jne    8013e1 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801426:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  80142d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801430:	48                   	dec    %eax
  801431:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801434:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801438:	74 3d                	je     801477 <ltostr+0xc3>
		start = 1 ;
  80143a:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801441:	eb 34                	jmp    801477 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  801443:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801446:	8b 45 0c             	mov    0xc(%ebp),%eax
  801449:	01 d0                	add    %edx,%eax
  80144b:	8a 00                	mov    (%eax),%al
  80144d:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801450:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801453:	8b 45 0c             	mov    0xc(%ebp),%eax
  801456:	01 c2                	add    %eax,%edx
  801458:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80145b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80145e:	01 c8                	add    %ecx,%eax
  801460:	8a 00                	mov    (%eax),%al
  801462:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801464:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801467:	8b 45 0c             	mov    0xc(%ebp),%eax
  80146a:	01 c2                	add    %eax,%edx
  80146c:	8a 45 eb             	mov    -0x15(%ebp),%al
  80146f:	88 02                	mov    %al,(%edx)
		start++ ;
  801471:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801474:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801477:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80147a:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80147d:	7c c4                	jl     801443 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  80147f:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801482:	8b 45 0c             	mov    0xc(%ebp),%eax
  801485:	01 d0                	add    %edx,%eax
  801487:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  80148a:	90                   	nop
  80148b:	c9                   	leave  
  80148c:	c3                   	ret    

0080148d <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  80148d:	55                   	push   %ebp
  80148e:	89 e5                	mov    %esp,%ebp
  801490:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801493:	ff 75 08             	pushl  0x8(%ebp)
  801496:	e8 c4 f9 ff ff       	call   800e5f <strlen>
  80149b:	83 c4 04             	add    $0x4,%esp
  80149e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8014a1:	ff 75 0c             	pushl  0xc(%ebp)
  8014a4:	e8 b6 f9 ff ff       	call   800e5f <strlen>
  8014a9:	83 c4 04             	add    $0x4,%esp
  8014ac:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8014af:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8014b6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8014bd:	eb 17                	jmp    8014d6 <strcconcat+0x49>
		final[s] = str1[s] ;
  8014bf:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8014c2:	8b 45 10             	mov    0x10(%ebp),%eax
  8014c5:	01 c2                	add    %eax,%edx
  8014c7:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8014ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8014cd:	01 c8                	add    %ecx,%eax
  8014cf:	8a 00                	mov    (%eax),%al
  8014d1:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8014d3:	ff 45 fc             	incl   -0x4(%ebp)
  8014d6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8014d9:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8014dc:	7c e1                	jl     8014bf <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8014de:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8014e5:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8014ec:	eb 1f                	jmp    80150d <strcconcat+0x80>
		final[s++] = str2[i] ;
  8014ee:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8014f1:	8d 50 01             	lea    0x1(%eax),%edx
  8014f4:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8014f7:	89 c2                	mov    %eax,%edx
  8014f9:	8b 45 10             	mov    0x10(%ebp),%eax
  8014fc:	01 c2                	add    %eax,%edx
  8014fe:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801501:	8b 45 0c             	mov    0xc(%ebp),%eax
  801504:	01 c8                	add    %ecx,%eax
  801506:	8a 00                	mov    (%eax),%al
  801508:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  80150a:	ff 45 f8             	incl   -0x8(%ebp)
  80150d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801510:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801513:	7c d9                	jl     8014ee <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801515:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801518:	8b 45 10             	mov    0x10(%ebp),%eax
  80151b:	01 d0                	add    %edx,%eax
  80151d:	c6 00 00             	movb   $0x0,(%eax)
}
  801520:	90                   	nop
  801521:	c9                   	leave  
  801522:	c3                   	ret    

00801523 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801523:	55                   	push   %ebp
  801524:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801526:	8b 45 14             	mov    0x14(%ebp),%eax
  801529:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  80152f:	8b 45 14             	mov    0x14(%ebp),%eax
  801532:	8b 00                	mov    (%eax),%eax
  801534:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80153b:	8b 45 10             	mov    0x10(%ebp),%eax
  80153e:	01 d0                	add    %edx,%eax
  801540:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801546:	eb 0c                	jmp    801554 <strsplit+0x31>
			*string++ = 0;
  801548:	8b 45 08             	mov    0x8(%ebp),%eax
  80154b:	8d 50 01             	lea    0x1(%eax),%edx
  80154e:	89 55 08             	mov    %edx,0x8(%ebp)
  801551:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801554:	8b 45 08             	mov    0x8(%ebp),%eax
  801557:	8a 00                	mov    (%eax),%al
  801559:	84 c0                	test   %al,%al
  80155b:	74 18                	je     801575 <strsplit+0x52>
  80155d:	8b 45 08             	mov    0x8(%ebp),%eax
  801560:	8a 00                	mov    (%eax),%al
  801562:	0f be c0             	movsbl %al,%eax
  801565:	50                   	push   %eax
  801566:	ff 75 0c             	pushl  0xc(%ebp)
  801569:	e8 83 fa ff ff       	call   800ff1 <strchr>
  80156e:	83 c4 08             	add    $0x8,%esp
  801571:	85 c0                	test   %eax,%eax
  801573:	75 d3                	jne    801548 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801575:	8b 45 08             	mov    0x8(%ebp),%eax
  801578:	8a 00                	mov    (%eax),%al
  80157a:	84 c0                	test   %al,%al
  80157c:	74 5a                	je     8015d8 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  80157e:	8b 45 14             	mov    0x14(%ebp),%eax
  801581:	8b 00                	mov    (%eax),%eax
  801583:	83 f8 0f             	cmp    $0xf,%eax
  801586:	75 07                	jne    80158f <strsplit+0x6c>
		{
			return 0;
  801588:	b8 00 00 00 00       	mov    $0x0,%eax
  80158d:	eb 66                	jmp    8015f5 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  80158f:	8b 45 14             	mov    0x14(%ebp),%eax
  801592:	8b 00                	mov    (%eax),%eax
  801594:	8d 48 01             	lea    0x1(%eax),%ecx
  801597:	8b 55 14             	mov    0x14(%ebp),%edx
  80159a:	89 0a                	mov    %ecx,(%edx)
  80159c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8015a3:	8b 45 10             	mov    0x10(%ebp),%eax
  8015a6:	01 c2                	add    %eax,%edx
  8015a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8015ab:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8015ad:	eb 03                	jmp    8015b2 <strsplit+0x8f>
			string++;
  8015af:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8015b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8015b5:	8a 00                	mov    (%eax),%al
  8015b7:	84 c0                	test   %al,%al
  8015b9:	74 8b                	je     801546 <strsplit+0x23>
  8015bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8015be:	8a 00                	mov    (%eax),%al
  8015c0:	0f be c0             	movsbl %al,%eax
  8015c3:	50                   	push   %eax
  8015c4:	ff 75 0c             	pushl  0xc(%ebp)
  8015c7:	e8 25 fa ff ff       	call   800ff1 <strchr>
  8015cc:	83 c4 08             	add    $0x8,%esp
  8015cf:	85 c0                	test   %eax,%eax
  8015d1:	74 dc                	je     8015af <strsplit+0x8c>
			string++;
	}
  8015d3:	e9 6e ff ff ff       	jmp    801546 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8015d8:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8015d9:	8b 45 14             	mov    0x14(%ebp),%eax
  8015dc:	8b 00                	mov    (%eax),%eax
  8015de:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8015e5:	8b 45 10             	mov    0x10(%ebp),%eax
  8015e8:	01 d0                	add    %edx,%eax
  8015ea:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8015f0:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8015f5:	c9                   	leave  
  8015f6:	c3                   	ret    

008015f7 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  8015f7:	55                   	push   %ebp
  8015f8:	89 e5                	mov    %esp,%ebp
  8015fa:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  8015fd:	8b 45 08             	mov    0x8(%ebp),%eax
  801600:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  801603:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80160a:	eb 4a                	jmp    801656 <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  80160c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80160f:	8b 45 08             	mov    0x8(%ebp),%eax
  801612:	01 c2                	add    %eax,%edx
  801614:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801617:	8b 45 0c             	mov    0xc(%ebp),%eax
  80161a:	01 c8                	add    %ecx,%eax
  80161c:	8a 00                	mov    (%eax),%al
  80161e:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  801620:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801623:	8b 45 0c             	mov    0xc(%ebp),%eax
  801626:	01 d0                	add    %edx,%eax
  801628:	8a 00                	mov    (%eax),%al
  80162a:	3c 40                	cmp    $0x40,%al
  80162c:	7e 25                	jle    801653 <str2lower+0x5c>
  80162e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801631:	8b 45 0c             	mov    0xc(%ebp),%eax
  801634:	01 d0                	add    %edx,%eax
  801636:	8a 00                	mov    (%eax),%al
  801638:	3c 5a                	cmp    $0x5a,%al
  80163a:	7f 17                	jg     801653 <str2lower+0x5c>
		{
			dst[i] += 32 ;
  80163c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80163f:	8b 45 08             	mov    0x8(%ebp),%eax
  801642:	01 d0                	add    %edx,%eax
  801644:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801647:	8b 55 08             	mov    0x8(%ebp),%edx
  80164a:	01 ca                	add    %ecx,%edx
  80164c:	8a 12                	mov    (%edx),%dl
  80164e:	83 c2 20             	add    $0x20,%edx
  801651:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  801653:	ff 45 fc             	incl   -0x4(%ebp)
  801656:	ff 75 0c             	pushl  0xc(%ebp)
  801659:	e8 01 f8 ff ff       	call   800e5f <strlen>
  80165e:	83 c4 04             	add    $0x4,%esp
  801661:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801664:	7f a6                	jg     80160c <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  801666:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801669:	c9                   	leave  
  80166a:	c3                   	ret    

0080166b <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  80166b:	55                   	push   %ebp
  80166c:	89 e5                	mov    %esp,%ebp
  80166e:	57                   	push   %edi
  80166f:	56                   	push   %esi
  801670:	53                   	push   %ebx
  801671:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801674:	8b 45 08             	mov    0x8(%ebp),%eax
  801677:	8b 55 0c             	mov    0xc(%ebp),%edx
  80167a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80167d:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801680:	8b 7d 18             	mov    0x18(%ebp),%edi
  801683:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801686:	cd 30                	int    $0x30
  801688:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  80168b:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80168e:	83 c4 10             	add    $0x10,%esp
  801691:	5b                   	pop    %ebx
  801692:	5e                   	pop    %esi
  801693:	5f                   	pop    %edi
  801694:	5d                   	pop    %ebp
  801695:	c3                   	ret    

00801696 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  801696:	55                   	push   %ebp
  801697:	89 e5                	mov    %esp,%ebp
  801699:	83 ec 04             	sub    $0x4,%esp
  80169c:	8b 45 10             	mov    0x10(%ebp),%eax
  80169f:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  8016a2:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8016a5:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8016a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8016ac:	6a 00                	push   $0x0
  8016ae:	51                   	push   %ecx
  8016af:	52                   	push   %edx
  8016b0:	ff 75 0c             	pushl  0xc(%ebp)
  8016b3:	50                   	push   %eax
  8016b4:	6a 00                	push   $0x0
  8016b6:	e8 b0 ff ff ff       	call   80166b <syscall>
  8016bb:	83 c4 18             	add    $0x18,%esp
}
  8016be:	90                   	nop
  8016bf:	c9                   	leave  
  8016c0:	c3                   	ret    

008016c1 <sys_cgetc>:

int
sys_cgetc(void)
{
  8016c1:	55                   	push   %ebp
  8016c2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8016c4:	6a 00                	push   $0x0
  8016c6:	6a 00                	push   $0x0
  8016c8:	6a 00                	push   $0x0
  8016ca:	6a 00                	push   $0x0
  8016cc:	6a 00                	push   $0x0
  8016ce:	6a 02                	push   $0x2
  8016d0:	e8 96 ff ff ff       	call   80166b <syscall>
  8016d5:	83 c4 18             	add    $0x18,%esp
}
  8016d8:	c9                   	leave  
  8016d9:	c3                   	ret    

008016da <sys_lock_cons>:

void sys_lock_cons(void)
{
  8016da:	55                   	push   %ebp
  8016db:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  8016dd:	6a 00                	push   $0x0
  8016df:	6a 00                	push   $0x0
  8016e1:	6a 00                	push   $0x0
  8016e3:	6a 00                	push   $0x0
  8016e5:	6a 00                	push   $0x0
  8016e7:	6a 03                	push   $0x3
  8016e9:	e8 7d ff ff ff       	call   80166b <syscall>
  8016ee:	83 c4 18             	add    $0x18,%esp
}
  8016f1:	90                   	nop
  8016f2:	c9                   	leave  
  8016f3:	c3                   	ret    

008016f4 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  8016f4:	55                   	push   %ebp
  8016f5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  8016f7:	6a 00                	push   $0x0
  8016f9:	6a 00                	push   $0x0
  8016fb:	6a 00                	push   $0x0
  8016fd:	6a 00                	push   $0x0
  8016ff:	6a 00                	push   $0x0
  801701:	6a 04                	push   $0x4
  801703:	e8 63 ff ff ff       	call   80166b <syscall>
  801708:	83 c4 18             	add    $0x18,%esp
}
  80170b:	90                   	nop
  80170c:	c9                   	leave  
  80170d:	c3                   	ret    

0080170e <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  80170e:	55                   	push   %ebp
  80170f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801711:	8b 55 0c             	mov    0xc(%ebp),%edx
  801714:	8b 45 08             	mov    0x8(%ebp),%eax
  801717:	6a 00                	push   $0x0
  801719:	6a 00                	push   $0x0
  80171b:	6a 00                	push   $0x0
  80171d:	52                   	push   %edx
  80171e:	50                   	push   %eax
  80171f:	6a 08                	push   $0x8
  801721:	e8 45 ff ff ff       	call   80166b <syscall>
  801726:	83 c4 18             	add    $0x18,%esp
}
  801729:	c9                   	leave  
  80172a:	c3                   	ret    

0080172b <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  80172b:	55                   	push   %ebp
  80172c:	89 e5                	mov    %esp,%ebp
  80172e:	56                   	push   %esi
  80172f:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801730:	8b 75 18             	mov    0x18(%ebp),%esi
  801733:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801736:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801739:	8b 55 0c             	mov    0xc(%ebp),%edx
  80173c:	8b 45 08             	mov    0x8(%ebp),%eax
  80173f:	56                   	push   %esi
  801740:	53                   	push   %ebx
  801741:	51                   	push   %ecx
  801742:	52                   	push   %edx
  801743:	50                   	push   %eax
  801744:	6a 09                	push   $0x9
  801746:	e8 20 ff ff ff       	call   80166b <syscall>
  80174b:	83 c4 18             	add    $0x18,%esp
}
  80174e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801751:	5b                   	pop    %ebx
  801752:	5e                   	pop    %esi
  801753:	5d                   	pop    %ebp
  801754:	c3                   	ret    

00801755 <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  801755:	55                   	push   %ebp
  801756:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  801758:	6a 00                	push   $0x0
  80175a:	6a 00                	push   $0x0
  80175c:	6a 00                	push   $0x0
  80175e:	6a 00                	push   $0x0
  801760:	ff 75 08             	pushl  0x8(%ebp)
  801763:	6a 0a                	push   $0xa
  801765:	e8 01 ff ff ff       	call   80166b <syscall>
  80176a:	83 c4 18             	add    $0x18,%esp
}
  80176d:	c9                   	leave  
  80176e:	c3                   	ret    

0080176f <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  80176f:	55                   	push   %ebp
  801770:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801772:	6a 00                	push   $0x0
  801774:	6a 00                	push   $0x0
  801776:	6a 00                	push   $0x0
  801778:	ff 75 0c             	pushl  0xc(%ebp)
  80177b:	ff 75 08             	pushl  0x8(%ebp)
  80177e:	6a 0b                	push   $0xb
  801780:	e8 e6 fe ff ff       	call   80166b <syscall>
  801785:	83 c4 18             	add    $0x18,%esp
}
  801788:	c9                   	leave  
  801789:	c3                   	ret    

0080178a <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  80178a:	55                   	push   %ebp
  80178b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  80178d:	6a 00                	push   $0x0
  80178f:	6a 00                	push   $0x0
  801791:	6a 00                	push   $0x0
  801793:	6a 00                	push   $0x0
  801795:	6a 00                	push   $0x0
  801797:	6a 0c                	push   $0xc
  801799:	e8 cd fe ff ff       	call   80166b <syscall>
  80179e:	83 c4 18             	add    $0x18,%esp
}
  8017a1:	c9                   	leave  
  8017a2:	c3                   	ret    

008017a3 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8017a3:	55                   	push   %ebp
  8017a4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8017a6:	6a 00                	push   $0x0
  8017a8:	6a 00                	push   $0x0
  8017aa:	6a 00                	push   $0x0
  8017ac:	6a 00                	push   $0x0
  8017ae:	6a 00                	push   $0x0
  8017b0:	6a 0d                	push   $0xd
  8017b2:	e8 b4 fe ff ff       	call   80166b <syscall>
  8017b7:	83 c4 18             	add    $0x18,%esp
}
  8017ba:	c9                   	leave  
  8017bb:	c3                   	ret    

008017bc <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8017bc:	55                   	push   %ebp
  8017bd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8017bf:	6a 00                	push   $0x0
  8017c1:	6a 00                	push   $0x0
  8017c3:	6a 00                	push   $0x0
  8017c5:	6a 00                	push   $0x0
  8017c7:	6a 00                	push   $0x0
  8017c9:	6a 0e                	push   $0xe
  8017cb:	e8 9b fe ff ff       	call   80166b <syscall>
  8017d0:	83 c4 18             	add    $0x18,%esp
}
  8017d3:	c9                   	leave  
  8017d4:	c3                   	ret    

008017d5 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8017d5:	55                   	push   %ebp
  8017d6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8017d8:	6a 00                	push   $0x0
  8017da:	6a 00                	push   $0x0
  8017dc:	6a 00                	push   $0x0
  8017de:	6a 00                	push   $0x0
  8017e0:	6a 00                	push   $0x0
  8017e2:	6a 0f                	push   $0xf
  8017e4:	e8 82 fe ff ff       	call   80166b <syscall>
  8017e9:	83 c4 18             	add    $0x18,%esp
}
  8017ec:	c9                   	leave  
  8017ed:	c3                   	ret    

008017ee <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8017ee:	55                   	push   %ebp
  8017ef:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8017f1:	6a 00                	push   $0x0
  8017f3:	6a 00                	push   $0x0
  8017f5:	6a 00                	push   $0x0
  8017f7:	6a 00                	push   $0x0
  8017f9:	ff 75 08             	pushl  0x8(%ebp)
  8017fc:	6a 10                	push   $0x10
  8017fe:	e8 68 fe ff ff       	call   80166b <syscall>
  801803:	83 c4 18             	add    $0x18,%esp
}
  801806:	c9                   	leave  
  801807:	c3                   	ret    

00801808 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801808:	55                   	push   %ebp
  801809:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  80180b:	6a 00                	push   $0x0
  80180d:	6a 00                	push   $0x0
  80180f:	6a 00                	push   $0x0
  801811:	6a 00                	push   $0x0
  801813:	6a 00                	push   $0x0
  801815:	6a 11                	push   $0x11
  801817:	e8 4f fe ff ff       	call   80166b <syscall>
  80181c:	83 c4 18             	add    $0x18,%esp
}
  80181f:	90                   	nop
  801820:	c9                   	leave  
  801821:	c3                   	ret    

00801822 <sys_cputc>:

void
sys_cputc(const char c)
{
  801822:	55                   	push   %ebp
  801823:	89 e5                	mov    %esp,%ebp
  801825:	83 ec 04             	sub    $0x4,%esp
  801828:	8b 45 08             	mov    0x8(%ebp),%eax
  80182b:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  80182e:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801832:	6a 00                	push   $0x0
  801834:	6a 00                	push   $0x0
  801836:	6a 00                	push   $0x0
  801838:	6a 00                	push   $0x0
  80183a:	50                   	push   %eax
  80183b:	6a 01                	push   $0x1
  80183d:	e8 29 fe ff ff       	call   80166b <syscall>
  801842:	83 c4 18             	add    $0x18,%esp
}
  801845:	90                   	nop
  801846:	c9                   	leave  
  801847:	c3                   	ret    

00801848 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801848:	55                   	push   %ebp
  801849:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  80184b:	6a 00                	push   $0x0
  80184d:	6a 00                	push   $0x0
  80184f:	6a 00                	push   $0x0
  801851:	6a 00                	push   $0x0
  801853:	6a 00                	push   $0x0
  801855:	6a 14                	push   $0x14
  801857:	e8 0f fe ff ff       	call   80166b <syscall>
  80185c:	83 c4 18             	add    $0x18,%esp
}
  80185f:	90                   	nop
  801860:	c9                   	leave  
  801861:	c3                   	ret    

00801862 <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801862:	55                   	push   %ebp
  801863:	89 e5                	mov    %esp,%ebp
  801865:	83 ec 04             	sub    $0x4,%esp
  801868:	8b 45 10             	mov    0x10(%ebp),%eax
  80186b:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  80186e:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801871:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801875:	8b 45 08             	mov    0x8(%ebp),%eax
  801878:	6a 00                	push   $0x0
  80187a:	51                   	push   %ecx
  80187b:	52                   	push   %edx
  80187c:	ff 75 0c             	pushl  0xc(%ebp)
  80187f:	50                   	push   %eax
  801880:	6a 15                	push   $0x15
  801882:	e8 e4 fd ff ff       	call   80166b <syscall>
  801887:	83 c4 18             	add    $0x18,%esp
}
  80188a:	c9                   	leave  
  80188b:	c3                   	ret    

0080188c <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  80188c:	55                   	push   %ebp
  80188d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  80188f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801892:	8b 45 08             	mov    0x8(%ebp),%eax
  801895:	6a 00                	push   $0x0
  801897:	6a 00                	push   $0x0
  801899:	6a 00                	push   $0x0
  80189b:	52                   	push   %edx
  80189c:	50                   	push   %eax
  80189d:	6a 16                	push   $0x16
  80189f:	e8 c7 fd ff ff       	call   80166b <syscall>
  8018a4:	83 c4 18             	add    $0x18,%esp
}
  8018a7:	c9                   	leave  
  8018a8:	c3                   	ret    

008018a9 <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  8018a9:	55                   	push   %ebp
  8018aa:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8018ac:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8018af:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8018b5:	6a 00                	push   $0x0
  8018b7:	6a 00                	push   $0x0
  8018b9:	51                   	push   %ecx
  8018ba:	52                   	push   %edx
  8018bb:	50                   	push   %eax
  8018bc:	6a 17                	push   $0x17
  8018be:	e8 a8 fd ff ff       	call   80166b <syscall>
  8018c3:	83 c4 18             	add    $0x18,%esp
}
  8018c6:	c9                   	leave  
  8018c7:	c3                   	ret    

008018c8 <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  8018c8:	55                   	push   %ebp
  8018c9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8018cb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8018d1:	6a 00                	push   $0x0
  8018d3:	6a 00                	push   $0x0
  8018d5:	6a 00                	push   $0x0
  8018d7:	52                   	push   %edx
  8018d8:	50                   	push   %eax
  8018d9:	6a 18                	push   $0x18
  8018db:	e8 8b fd ff ff       	call   80166b <syscall>
  8018e0:	83 c4 18             	add    $0x18,%esp
}
  8018e3:	c9                   	leave  
  8018e4:	c3                   	ret    

008018e5 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8018e5:	55                   	push   %ebp
  8018e6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8018e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8018eb:	6a 00                	push   $0x0
  8018ed:	ff 75 14             	pushl  0x14(%ebp)
  8018f0:	ff 75 10             	pushl  0x10(%ebp)
  8018f3:	ff 75 0c             	pushl  0xc(%ebp)
  8018f6:	50                   	push   %eax
  8018f7:	6a 19                	push   $0x19
  8018f9:	e8 6d fd ff ff       	call   80166b <syscall>
  8018fe:	83 c4 18             	add    $0x18,%esp
}
  801901:	c9                   	leave  
  801902:	c3                   	ret    

00801903 <sys_run_env>:

void sys_run_env(int32 envId)
{
  801903:	55                   	push   %ebp
  801904:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801906:	8b 45 08             	mov    0x8(%ebp),%eax
  801909:	6a 00                	push   $0x0
  80190b:	6a 00                	push   $0x0
  80190d:	6a 00                	push   $0x0
  80190f:	6a 00                	push   $0x0
  801911:	50                   	push   %eax
  801912:	6a 1a                	push   $0x1a
  801914:	e8 52 fd ff ff       	call   80166b <syscall>
  801919:	83 c4 18             	add    $0x18,%esp
}
  80191c:	90                   	nop
  80191d:	c9                   	leave  
  80191e:	c3                   	ret    

0080191f <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  80191f:	55                   	push   %ebp
  801920:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801922:	8b 45 08             	mov    0x8(%ebp),%eax
  801925:	6a 00                	push   $0x0
  801927:	6a 00                	push   $0x0
  801929:	6a 00                	push   $0x0
  80192b:	6a 00                	push   $0x0
  80192d:	50                   	push   %eax
  80192e:	6a 1b                	push   $0x1b
  801930:	e8 36 fd ff ff       	call   80166b <syscall>
  801935:	83 c4 18             	add    $0x18,%esp
}
  801938:	c9                   	leave  
  801939:	c3                   	ret    

0080193a <sys_getenvid>:

int32 sys_getenvid(void)
{
  80193a:	55                   	push   %ebp
  80193b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  80193d:	6a 00                	push   $0x0
  80193f:	6a 00                	push   $0x0
  801941:	6a 00                	push   $0x0
  801943:	6a 00                	push   $0x0
  801945:	6a 00                	push   $0x0
  801947:	6a 05                	push   $0x5
  801949:	e8 1d fd ff ff       	call   80166b <syscall>
  80194e:	83 c4 18             	add    $0x18,%esp
}
  801951:	c9                   	leave  
  801952:	c3                   	ret    

00801953 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801953:	55                   	push   %ebp
  801954:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801956:	6a 00                	push   $0x0
  801958:	6a 00                	push   $0x0
  80195a:	6a 00                	push   $0x0
  80195c:	6a 00                	push   $0x0
  80195e:	6a 00                	push   $0x0
  801960:	6a 06                	push   $0x6
  801962:	e8 04 fd ff ff       	call   80166b <syscall>
  801967:	83 c4 18             	add    $0x18,%esp
}
  80196a:	c9                   	leave  
  80196b:	c3                   	ret    

0080196c <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  80196c:	55                   	push   %ebp
  80196d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  80196f:	6a 00                	push   $0x0
  801971:	6a 00                	push   $0x0
  801973:	6a 00                	push   $0x0
  801975:	6a 00                	push   $0x0
  801977:	6a 00                	push   $0x0
  801979:	6a 07                	push   $0x7
  80197b:	e8 eb fc ff ff       	call   80166b <syscall>
  801980:	83 c4 18             	add    $0x18,%esp
}
  801983:	c9                   	leave  
  801984:	c3                   	ret    

00801985 <sys_exit_env>:


void sys_exit_env(void)
{
  801985:	55                   	push   %ebp
  801986:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801988:	6a 00                	push   $0x0
  80198a:	6a 00                	push   $0x0
  80198c:	6a 00                	push   $0x0
  80198e:	6a 00                	push   $0x0
  801990:	6a 00                	push   $0x0
  801992:	6a 1c                	push   $0x1c
  801994:	e8 d2 fc ff ff       	call   80166b <syscall>
  801999:	83 c4 18             	add    $0x18,%esp
}
  80199c:	90                   	nop
  80199d:	c9                   	leave  
  80199e:	c3                   	ret    

0080199f <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  80199f:	55                   	push   %ebp
  8019a0:	89 e5                	mov    %esp,%ebp
  8019a2:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8019a5:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8019a8:	8d 50 04             	lea    0x4(%eax),%edx
  8019ab:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8019ae:	6a 00                	push   $0x0
  8019b0:	6a 00                	push   $0x0
  8019b2:	6a 00                	push   $0x0
  8019b4:	52                   	push   %edx
  8019b5:	50                   	push   %eax
  8019b6:	6a 1d                	push   $0x1d
  8019b8:	e8 ae fc ff ff       	call   80166b <syscall>
  8019bd:	83 c4 18             	add    $0x18,%esp
	return result;
  8019c0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8019c3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8019c6:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8019c9:	89 01                	mov    %eax,(%ecx)
  8019cb:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8019ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8019d1:	c9                   	leave  
  8019d2:	c2 04 00             	ret    $0x4

008019d5 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8019d5:	55                   	push   %ebp
  8019d6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8019d8:	6a 00                	push   $0x0
  8019da:	6a 00                	push   $0x0
  8019dc:	ff 75 10             	pushl  0x10(%ebp)
  8019df:	ff 75 0c             	pushl  0xc(%ebp)
  8019e2:	ff 75 08             	pushl  0x8(%ebp)
  8019e5:	6a 13                	push   $0x13
  8019e7:	e8 7f fc ff ff       	call   80166b <syscall>
  8019ec:	83 c4 18             	add    $0x18,%esp
	return ;
  8019ef:	90                   	nop
}
  8019f0:	c9                   	leave  
  8019f1:	c3                   	ret    

008019f2 <sys_rcr2>:
uint32 sys_rcr2()
{
  8019f2:	55                   	push   %ebp
  8019f3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8019f5:	6a 00                	push   $0x0
  8019f7:	6a 00                	push   $0x0
  8019f9:	6a 00                	push   $0x0
  8019fb:	6a 00                	push   $0x0
  8019fd:	6a 00                	push   $0x0
  8019ff:	6a 1e                	push   $0x1e
  801a01:	e8 65 fc ff ff       	call   80166b <syscall>
  801a06:	83 c4 18             	add    $0x18,%esp
}
  801a09:	c9                   	leave  
  801a0a:	c3                   	ret    

00801a0b <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  801a0b:	55                   	push   %ebp
  801a0c:	89 e5                	mov    %esp,%ebp
  801a0e:	83 ec 04             	sub    $0x4,%esp
  801a11:	8b 45 08             	mov    0x8(%ebp),%eax
  801a14:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801a17:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801a1b:	6a 00                	push   $0x0
  801a1d:	6a 00                	push   $0x0
  801a1f:	6a 00                	push   $0x0
  801a21:	6a 00                	push   $0x0
  801a23:	50                   	push   %eax
  801a24:	6a 1f                	push   $0x1f
  801a26:	e8 40 fc ff ff       	call   80166b <syscall>
  801a2b:	83 c4 18             	add    $0x18,%esp
	return ;
  801a2e:	90                   	nop
}
  801a2f:	c9                   	leave  
  801a30:	c3                   	ret    

00801a31 <rsttst>:
void rsttst()
{
  801a31:	55                   	push   %ebp
  801a32:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801a34:	6a 00                	push   $0x0
  801a36:	6a 00                	push   $0x0
  801a38:	6a 00                	push   $0x0
  801a3a:	6a 00                	push   $0x0
  801a3c:	6a 00                	push   $0x0
  801a3e:	6a 21                	push   $0x21
  801a40:	e8 26 fc ff ff       	call   80166b <syscall>
  801a45:	83 c4 18             	add    $0x18,%esp
	return ;
  801a48:	90                   	nop
}
  801a49:	c9                   	leave  
  801a4a:	c3                   	ret    

00801a4b <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801a4b:	55                   	push   %ebp
  801a4c:	89 e5                	mov    %esp,%ebp
  801a4e:	83 ec 04             	sub    $0x4,%esp
  801a51:	8b 45 14             	mov    0x14(%ebp),%eax
  801a54:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801a57:	8b 55 18             	mov    0x18(%ebp),%edx
  801a5a:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801a5e:	52                   	push   %edx
  801a5f:	50                   	push   %eax
  801a60:	ff 75 10             	pushl  0x10(%ebp)
  801a63:	ff 75 0c             	pushl  0xc(%ebp)
  801a66:	ff 75 08             	pushl  0x8(%ebp)
  801a69:	6a 20                	push   $0x20
  801a6b:	e8 fb fb ff ff       	call   80166b <syscall>
  801a70:	83 c4 18             	add    $0x18,%esp
	return ;
  801a73:	90                   	nop
}
  801a74:	c9                   	leave  
  801a75:	c3                   	ret    

00801a76 <chktst>:
void chktst(uint32 n)
{
  801a76:	55                   	push   %ebp
  801a77:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801a79:	6a 00                	push   $0x0
  801a7b:	6a 00                	push   $0x0
  801a7d:	6a 00                	push   $0x0
  801a7f:	6a 00                	push   $0x0
  801a81:	ff 75 08             	pushl  0x8(%ebp)
  801a84:	6a 22                	push   $0x22
  801a86:	e8 e0 fb ff ff       	call   80166b <syscall>
  801a8b:	83 c4 18             	add    $0x18,%esp
	return ;
  801a8e:	90                   	nop
}
  801a8f:	c9                   	leave  
  801a90:	c3                   	ret    

00801a91 <inctst>:

void inctst()
{
  801a91:	55                   	push   %ebp
  801a92:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801a94:	6a 00                	push   $0x0
  801a96:	6a 00                	push   $0x0
  801a98:	6a 00                	push   $0x0
  801a9a:	6a 00                	push   $0x0
  801a9c:	6a 00                	push   $0x0
  801a9e:	6a 23                	push   $0x23
  801aa0:	e8 c6 fb ff ff       	call   80166b <syscall>
  801aa5:	83 c4 18             	add    $0x18,%esp
	return ;
  801aa8:	90                   	nop
}
  801aa9:	c9                   	leave  
  801aaa:	c3                   	ret    

00801aab <gettst>:
uint32 gettst()
{
  801aab:	55                   	push   %ebp
  801aac:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801aae:	6a 00                	push   $0x0
  801ab0:	6a 00                	push   $0x0
  801ab2:	6a 00                	push   $0x0
  801ab4:	6a 00                	push   $0x0
  801ab6:	6a 00                	push   $0x0
  801ab8:	6a 24                	push   $0x24
  801aba:	e8 ac fb ff ff       	call   80166b <syscall>
  801abf:	83 c4 18             	add    $0x18,%esp
}
  801ac2:	c9                   	leave  
  801ac3:	c3                   	ret    

00801ac4 <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  801ac4:	55                   	push   %ebp
  801ac5:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801ac7:	6a 00                	push   $0x0
  801ac9:	6a 00                	push   $0x0
  801acb:	6a 00                	push   $0x0
  801acd:	6a 00                	push   $0x0
  801acf:	6a 00                	push   $0x0
  801ad1:	6a 25                	push   $0x25
  801ad3:	e8 93 fb ff ff       	call   80166b <syscall>
  801ad8:	83 c4 18             	add    $0x18,%esp
  801adb:	a3 a0 b0 81 00       	mov    %eax,0x81b0a0
	return uheapPlaceStrategy ;
  801ae0:	a1 a0 b0 81 00       	mov    0x81b0a0,%eax
}
  801ae5:	c9                   	leave  
  801ae6:	c3                   	ret    

00801ae7 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801ae7:	55                   	push   %ebp
  801ae8:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  801aea:	8b 45 08             	mov    0x8(%ebp),%eax
  801aed:	a3 a0 b0 81 00       	mov    %eax,0x81b0a0
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801af2:	6a 00                	push   $0x0
  801af4:	6a 00                	push   $0x0
  801af6:	6a 00                	push   $0x0
  801af8:	6a 00                	push   $0x0
  801afa:	ff 75 08             	pushl  0x8(%ebp)
  801afd:	6a 26                	push   $0x26
  801aff:	e8 67 fb ff ff       	call   80166b <syscall>
  801b04:	83 c4 18             	add    $0x18,%esp
	return ;
  801b07:	90                   	nop
}
  801b08:	c9                   	leave  
  801b09:	c3                   	ret    

00801b0a <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801b0a:	55                   	push   %ebp
  801b0b:	89 e5                	mov    %esp,%ebp
  801b0d:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801b0e:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801b11:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801b14:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b17:	8b 45 08             	mov    0x8(%ebp),%eax
  801b1a:	6a 00                	push   $0x0
  801b1c:	53                   	push   %ebx
  801b1d:	51                   	push   %ecx
  801b1e:	52                   	push   %edx
  801b1f:	50                   	push   %eax
  801b20:	6a 27                	push   $0x27
  801b22:	e8 44 fb ff ff       	call   80166b <syscall>
  801b27:	83 c4 18             	add    $0x18,%esp
}
  801b2a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b2d:	c9                   	leave  
  801b2e:	c3                   	ret    

00801b2f <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801b2f:	55                   	push   %ebp
  801b30:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801b32:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b35:	8b 45 08             	mov    0x8(%ebp),%eax
  801b38:	6a 00                	push   $0x0
  801b3a:	6a 00                	push   $0x0
  801b3c:	6a 00                	push   $0x0
  801b3e:	52                   	push   %edx
  801b3f:	50                   	push   %eax
  801b40:	6a 28                	push   $0x28
  801b42:	e8 24 fb ff ff       	call   80166b <syscall>
  801b47:	83 c4 18             	add    $0x18,%esp
}
  801b4a:	c9                   	leave  
  801b4b:	c3                   	ret    

00801b4c <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801b4c:	55                   	push   %ebp
  801b4d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801b4f:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801b52:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b55:	8b 45 08             	mov    0x8(%ebp),%eax
  801b58:	6a 00                	push   $0x0
  801b5a:	51                   	push   %ecx
  801b5b:	ff 75 10             	pushl  0x10(%ebp)
  801b5e:	52                   	push   %edx
  801b5f:	50                   	push   %eax
  801b60:	6a 29                	push   $0x29
  801b62:	e8 04 fb ff ff       	call   80166b <syscall>
  801b67:	83 c4 18             	add    $0x18,%esp
}
  801b6a:	c9                   	leave  
  801b6b:	c3                   	ret    

00801b6c <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801b6c:	55                   	push   %ebp
  801b6d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801b6f:	6a 00                	push   $0x0
  801b71:	6a 00                	push   $0x0
  801b73:	ff 75 10             	pushl  0x10(%ebp)
  801b76:	ff 75 0c             	pushl  0xc(%ebp)
  801b79:	ff 75 08             	pushl  0x8(%ebp)
  801b7c:	6a 12                	push   $0x12
  801b7e:	e8 e8 fa ff ff       	call   80166b <syscall>
  801b83:	83 c4 18             	add    $0x18,%esp
	return ;
  801b86:	90                   	nop
}
  801b87:	c9                   	leave  
  801b88:	c3                   	ret    

00801b89 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  801b89:	55                   	push   %ebp
  801b8a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  801b8c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b8f:	8b 45 08             	mov    0x8(%ebp),%eax
  801b92:	6a 00                	push   $0x0
  801b94:	6a 00                	push   $0x0
  801b96:	6a 00                	push   $0x0
  801b98:	52                   	push   %edx
  801b99:	50                   	push   %eax
  801b9a:	6a 2a                	push   $0x2a
  801b9c:	e8 ca fa ff ff       	call   80166b <syscall>
  801ba1:	83 c4 18             	add    $0x18,%esp
	return;
  801ba4:	90                   	nop
}
  801ba5:	c9                   	leave  
  801ba6:	c3                   	ret    

00801ba7 <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  801ba7:	55                   	push   %ebp
  801ba8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  801baa:	6a 00                	push   $0x0
  801bac:	6a 00                	push   $0x0
  801bae:	6a 00                	push   $0x0
  801bb0:	6a 00                	push   $0x0
  801bb2:	6a 00                	push   $0x0
  801bb4:	6a 2b                	push   $0x2b
  801bb6:	e8 b0 fa ff ff       	call   80166b <syscall>
  801bbb:	83 c4 18             	add    $0x18,%esp
}
  801bbe:	c9                   	leave  
  801bbf:	c3                   	ret    

00801bc0 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801bc0:	55                   	push   %ebp
  801bc1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801bc3:	6a 00                	push   $0x0
  801bc5:	6a 00                	push   $0x0
  801bc7:	6a 00                	push   $0x0
  801bc9:	ff 75 0c             	pushl  0xc(%ebp)
  801bcc:	ff 75 08             	pushl  0x8(%ebp)
  801bcf:	6a 2d                	push   $0x2d
  801bd1:	e8 95 fa ff ff       	call   80166b <syscall>
  801bd6:	83 c4 18             	add    $0x18,%esp
	return;
  801bd9:	90                   	nop
}
  801bda:	c9                   	leave  
  801bdb:	c3                   	ret    

00801bdc <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801bdc:	55                   	push   %ebp
  801bdd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801bdf:	6a 00                	push   $0x0
  801be1:	6a 00                	push   $0x0
  801be3:	6a 00                	push   $0x0
  801be5:	ff 75 0c             	pushl  0xc(%ebp)
  801be8:	ff 75 08             	pushl  0x8(%ebp)
  801beb:	6a 2c                	push   $0x2c
  801bed:	e8 79 fa ff ff       	call   80166b <syscall>
  801bf2:	83 c4 18             	add    $0x18,%esp
	return ;
  801bf5:	90                   	nop
}
  801bf6:	c9                   	leave  
  801bf7:	c3                   	ret    

00801bf8 <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  801bf8:	55                   	push   %ebp
  801bf9:	89 e5                	mov    %esp,%ebp
	//TODO: [PROJECT'25.IM#4] CPU SCHEDULING - #1 System Calls - Add suitable code here
	//Your code is here
	//Comment the following line
	//panic("sys_env_set_priority() is not implemented yet...!!");
	syscall(SYS_env_set_priority, envID, priority, 0, 0, 0);
  801bfb:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bfe:	8b 45 08             	mov    0x8(%ebp),%eax
  801c01:	6a 00                	push   $0x0
  801c03:	6a 00                	push   $0x0
  801c05:	6a 00                	push   $0x0
  801c07:	52                   	push   %edx
  801c08:	50                   	push   %eax
  801c09:	6a 2e                	push   $0x2e
  801c0b:	e8 5b fa ff ff       	call   80166b <syscall>
  801c10:	83 c4 18             	add    $0x18,%esp
	    return;
  801c13:	90                   	nop
}
  801c14:	c9                   	leave  
  801c15:	c3                   	ret    
  801c16:	66 90                	xchg   %ax,%ax

00801c18 <__udivdi3>:
  801c18:	55                   	push   %ebp
  801c19:	57                   	push   %edi
  801c1a:	56                   	push   %esi
  801c1b:	53                   	push   %ebx
  801c1c:	83 ec 1c             	sub    $0x1c,%esp
  801c1f:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801c23:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801c27:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801c2b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801c2f:	89 ca                	mov    %ecx,%edx
  801c31:	89 f8                	mov    %edi,%eax
  801c33:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801c37:	85 f6                	test   %esi,%esi
  801c39:	75 2d                	jne    801c68 <__udivdi3+0x50>
  801c3b:	39 cf                	cmp    %ecx,%edi
  801c3d:	77 65                	ja     801ca4 <__udivdi3+0x8c>
  801c3f:	89 fd                	mov    %edi,%ebp
  801c41:	85 ff                	test   %edi,%edi
  801c43:	75 0b                	jne    801c50 <__udivdi3+0x38>
  801c45:	b8 01 00 00 00       	mov    $0x1,%eax
  801c4a:	31 d2                	xor    %edx,%edx
  801c4c:	f7 f7                	div    %edi
  801c4e:	89 c5                	mov    %eax,%ebp
  801c50:	31 d2                	xor    %edx,%edx
  801c52:	89 c8                	mov    %ecx,%eax
  801c54:	f7 f5                	div    %ebp
  801c56:	89 c1                	mov    %eax,%ecx
  801c58:	89 d8                	mov    %ebx,%eax
  801c5a:	f7 f5                	div    %ebp
  801c5c:	89 cf                	mov    %ecx,%edi
  801c5e:	89 fa                	mov    %edi,%edx
  801c60:	83 c4 1c             	add    $0x1c,%esp
  801c63:	5b                   	pop    %ebx
  801c64:	5e                   	pop    %esi
  801c65:	5f                   	pop    %edi
  801c66:	5d                   	pop    %ebp
  801c67:	c3                   	ret    
  801c68:	39 ce                	cmp    %ecx,%esi
  801c6a:	77 28                	ja     801c94 <__udivdi3+0x7c>
  801c6c:	0f bd fe             	bsr    %esi,%edi
  801c6f:	83 f7 1f             	xor    $0x1f,%edi
  801c72:	75 40                	jne    801cb4 <__udivdi3+0x9c>
  801c74:	39 ce                	cmp    %ecx,%esi
  801c76:	72 0a                	jb     801c82 <__udivdi3+0x6a>
  801c78:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801c7c:	0f 87 9e 00 00 00    	ja     801d20 <__udivdi3+0x108>
  801c82:	b8 01 00 00 00       	mov    $0x1,%eax
  801c87:	89 fa                	mov    %edi,%edx
  801c89:	83 c4 1c             	add    $0x1c,%esp
  801c8c:	5b                   	pop    %ebx
  801c8d:	5e                   	pop    %esi
  801c8e:	5f                   	pop    %edi
  801c8f:	5d                   	pop    %ebp
  801c90:	c3                   	ret    
  801c91:	8d 76 00             	lea    0x0(%esi),%esi
  801c94:	31 ff                	xor    %edi,%edi
  801c96:	31 c0                	xor    %eax,%eax
  801c98:	89 fa                	mov    %edi,%edx
  801c9a:	83 c4 1c             	add    $0x1c,%esp
  801c9d:	5b                   	pop    %ebx
  801c9e:	5e                   	pop    %esi
  801c9f:	5f                   	pop    %edi
  801ca0:	5d                   	pop    %ebp
  801ca1:	c3                   	ret    
  801ca2:	66 90                	xchg   %ax,%ax
  801ca4:	89 d8                	mov    %ebx,%eax
  801ca6:	f7 f7                	div    %edi
  801ca8:	31 ff                	xor    %edi,%edi
  801caa:	89 fa                	mov    %edi,%edx
  801cac:	83 c4 1c             	add    $0x1c,%esp
  801caf:	5b                   	pop    %ebx
  801cb0:	5e                   	pop    %esi
  801cb1:	5f                   	pop    %edi
  801cb2:	5d                   	pop    %ebp
  801cb3:	c3                   	ret    
  801cb4:	bd 20 00 00 00       	mov    $0x20,%ebp
  801cb9:	89 eb                	mov    %ebp,%ebx
  801cbb:	29 fb                	sub    %edi,%ebx
  801cbd:	89 f9                	mov    %edi,%ecx
  801cbf:	d3 e6                	shl    %cl,%esi
  801cc1:	89 c5                	mov    %eax,%ebp
  801cc3:	88 d9                	mov    %bl,%cl
  801cc5:	d3 ed                	shr    %cl,%ebp
  801cc7:	89 e9                	mov    %ebp,%ecx
  801cc9:	09 f1                	or     %esi,%ecx
  801ccb:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801ccf:	89 f9                	mov    %edi,%ecx
  801cd1:	d3 e0                	shl    %cl,%eax
  801cd3:	89 c5                	mov    %eax,%ebp
  801cd5:	89 d6                	mov    %edx,%esi
  801cd7:	88 d9                	mov    %bl,%cl
  801cd9:	d3 ee                	shr    %cl,%esi
  801cdb:	89 f9                	mov    %edi,%ecx
  801cdd:	d3 e2                	shl    %cl,%edx
  801cdf:	8b 44 24 08          	mov    0x8(%esp),%eax
  801ce3:	88 d9                	mov    %bl,%cl
  801ce5:	d3 e8                	shr    %cl,%eax
  801ce7:	09 c2                	or     %eax,%edx
  801ce9:	89 d0                	mov    %edx,%eax
  801ceb:	89 f2                	mov    %esi,%edx
  801ced:	f7 74 24 0c          	divl   0xc(%esp)
  801cf1:	89 d6                	mov    %edx,%esi
  801cf3:	89 c3                	mov    %eax,%ebx
  801cf5:	f7 e5                	mul    %ebp
  801cf7:	39 d6                	cmp    %edx,%esi
  801cf9:	72 19                	jb     801d14 <__udivdi3+0xfc>
  801cfb:	74 0b                	je     801d08 <__udivdi3+0xf0>
  801cfd:	89 d8                	mov    %ebx,%eax
  801cff:	31 ff                	xor    %edi,%edi
  801d01:	e9 58 ff ff ff       	jmp    801c5e <__udivdi3+0x46>
  801d06:	66 90                	xchg   %ax,%ax
  801d08:	8b 54 24 08          	mov    0x8(%esp),%edx
  801d0c:	89 f9                	mov    %edi,%ecx
  801d0e:	d3 e2                	shl    %cl,%edx
  801d10:	39 c2                	cmp    %eax,%edx
  801d12:	73 e9                	jae    801cfd <__udivdi3+0xe5>
  801d14:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801d17:	31 ff                	xor    %edi,%edi
  801d19:	e9 40 ff ff ff       	jmp    801c5e <__udivdi3+0x46>
  801d1e:	66 90                	xchg   %ax,%ax
  801d20:	31 c0                	xor    %eax,%eax
  801d22:	e9 37 ff ff ff       	jmp    801c5e <__udivdi3+0x46>
  801d27:	90                   	nop

00801d28 <__umoddi3>:
  801d28:	55                   	push   %ebp
  801d29:	57                   	push   %edi
  801d2a:	56                   	push   %esi
  801d2b:	53                   	push   %ebx
  801d2c:	83 ec 1c             	sub    $0x1c,%esp
  801d2f:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801d33:	8b 74 24 34          	mov    0x34(%esp),%esi
  801d37:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801d3b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801d3f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801d43:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801d47:	89 f3                	mov    %esi,%ebx
  801d49:	89 fa                	mov    %edi,%edx
  801d4b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801d4f:	89 34 24             	mov    %esi,(%esp)
  801d52:	85 c0                	test   %eax,%eax
  801d54:	75 1a                	jne    801d70 <__umoddi3+0x48>
  801d56:	39 f7                	cmp    %esi,%edi
  801d58:	0f 86 a2 00 00 00    	jbe    801e00 <__umoddi3+0xd8>
  801d5e:	89 c8                	mov    %ecx,%eax
  801d60:	89 f2                	mov    %esi,%edx
  801d62:	f7 f7                	div    %edi
  801d64:	89 d0                	mov    %edx,%eax
  801d66:	31 d2                	xor    %edx,%edx
  801d68:	83 c4 1c             	add    $0x1c,%esp
  801d6b:	5b                   	pop    %ebx
  801d6c:	5e                   	pop    %esi
  801d6d:	5f                   	pop    %edi
  801d6e:	5d                   	pop    %ebp
  801d6f:	c3                   	ret    
  801d70:	39 f0                	cmp    %esi,%eax
  801d72:	0f 87 ac 00 00 00    	ja     801e24 <__umoddi3+0xfc>
  801d78:	0f bd e8             	bsr    %eax,%ebp
  801d7b:	83 f5 1f             	xor    $0x1f,%ebp
  801d7e:	0f 84 ac 00 00 00    	je     801e30 <__umoddi3+0x108>
  801d84:	bf 20 00 00 00       	mov    $0x20,%edi
  801d89:	29 ef                	sub    %ebp,%edi
  801d8b:	89 fe                	mov    %edi,%esi
  801d8d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801d91:	89 e9                	mov    %ebp,%ecx
  801d93:	d3 e0                	shl    %cl,%eax
  801d95:	89 d7                	mov    %edx,%edi
  801d97:	89 f1                	mov    %esi,%ecx
  801d99:	d3 ef                	shr    %cl,%edi
  801d9b:	09 c7                	or     %eax,%edi
  801d9d:	89 e9                	mov    %ebp,%ecx
  801d9f:	d3 e2                	shl    %cl,%edx
  801da1:	89 14 24             	mov    %edx,(%esp)
  801da4:	89 d8                	mov    %ebx,%eax
  801da6:	d3 e0                	shl    %cl,%eax
  801da8:	89 c2                	mov    %eax,%edx
  801daa:	8b 44 24 08          	mov    0x8(%esp),%eax
  801dae:	d3 e0                	shl    %cl,%eax
  801db0:	89 44 24 04          	mov    %eax,0x4(%esp)
  801db4:	8b 44 24 08          	mov    0x8(%esp),%eax
  801db8:	89 f1                	mov    %esi,%ecx
  801dba:	d3 e8                	shr    %cl,%eax
  801dbc:	09 d0                	or     %edx,%eax
  801dbe:	d3 eb                	shr    %cl,%ebx
  801dc0:	89 da                	mov    %ebx,%edx
  801dc2:	f7 f7                	div    %edi
  801dc4:	89 d3                	mov    %edx,%ebx
  801dc6:	f7 24 24             	mull   (%esp)
  801dc9:	89 c6                	mov    %eax,%esi
  801dcb:	89 d1                	mov    %edx,%ecx
  801dcd:	39 d3                	cmp    %edx,%ebx
  801dcf:	0f 82 87 00 00 00    	jb     801e5c <__umoddi3+0x134>
  801dd5:	0f 84 91 00 00 00    	je     801e6c <__umoddi3+0x144>
  801ddb:	8b 54 24 04          	mov    0x4(%esp),%edx
  801ddf:	29 f2                	sub    %esi,%edx
  801de1:	19 cb                	sbb    %ecx,%ebx
  801de3:	89 d8                	mov    %ebx,%eax
  801de5:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801de9:	d3 e0                	shl    %cl,%eax
  801deb:	89 e9                	mov    %ebp,%ecx
  801ded:	d3 ea                	shr    %cl,%edx
  801def:	09 d0                	or     %edx,%eax
  801df1:	89 e9                	mov    %ebp,%ecx
  801df3:	d3 eb                	shr    %cl,%ebx
  801df5:	89 da                	mov    %ebx,%edx
  801df7:	83 c4 1c             	add    $0x1c,%esp
  801dfa:	5b                   	pop    %ebx
  801dfb:	5e                   	pop    %esi
  801dfc:	5f                   	pop    %edi
  801dfd:	5d                   	pop    %ebp
  801dfe:	c3                   	ret    
  801dff:	90                   	nop
  801e00:	89 fd                	mov    %edi,%ebp
  801e02:	85 ff                	test   %edi,%edi
  801e04:	75 0b                	jne    801e11 <__umoddi3+0xe9>
  801e06:	b8 01 00 00 00       	mov    $0x1,%eax
  801e0b:	31 d2                	xor    %edx,%edx
  801e0d:	f7 f7                	div    %edi
  801e0f:	89 c5                	mov    %eax,%ebp
  801e11:	89 f0                	mov    %esi,%eax
  801e13:	31 d2                	xor    %edx,%edx
  801e15:	f7 f5                	div    %ebp
  801e17:	89 c8                	mov    %ecx,%eax
  801e19:	f7 f5                	div    %ebp
  801e1b:	89 d0                	mov    %edx,%eax
  801e1d:	e9 44 ff ff ff       	jmp    801d66 <__umoddi3+0x3e>
  801e22:	66 90                	xchg   %ax,%ax
  801e24:	89 c8                	mov    %ecx,%eax
  801e26:	89 f2                	mov    %esi,%edx
  801e28:	83 c4 1c             	add    $0x1c,%esp
  801e2b:	5b                   	pop    %ebx
  801e2c:	5e                   	pop    %esi
  801e2d:	5f                   	pop    %edi
  801e2e:	5d                   	pop    %ebp
  801e2f:	c3                   	ret    
  801e30:	3b 04 24             	cmp    (%esp),%eax
  801e33:	72 06                	jb     801e3b <__umoddi3+0x113>
  801e35:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801e39:	77 0f                	ja     801e4a <__umoddi3+0x122>
  801e3b:	89 f2                	mov    %esi,%edx
  801e3d:	29 f9                	sub    %edi,%ecx
  801e3f:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801e43:	89 14 24             	mov    %edx,(%esp)
  801e46:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801e4a:	8b 44 24 04          	mov    0x4(%esp),%eax
  801e4e:	8b 14 24             	mov    (%esp),%edx
  801e51:	83 c4 1c             	add    $0x1c,%esp
  801e54:	5b                   	pop    %ebx
  801e55:	5e                   	pop    %esi
  801e56:	5f                   	pop    %edi
  801e57:	5d                   	pop    %ebp
  801e58:	c3                   	ret    
  801e59:	8d 76 00             	lea    0x0(%esi),%esi
  801e5c:	2b 04 24             	sub    (%esp),%eax
  801e5f:	19 fa                	sbb    %edi,%edx
  801e61:	89 d1                	mov    %edx,%ecx
  801e63:	89 c6                	mov    %eax,%esi
  801e65:	e9 71 ff ff ff       	jmp    801ddb <__umoddi3+0xb3>
  801e6a:	66 90                	xchg   %ax,%ax
  801e6c:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801e70:	72 ea                	jb     801e5c <__umoddi3+0x134>
  801e72:	89 d9                	mov    %ebx,%ecx
  801e74:	e9 62 ff ff ff       	jmp    801ddb <__umoddi3+0xb3>
