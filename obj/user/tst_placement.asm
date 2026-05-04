
obj/user/tst_placement:     file format elf32-i386


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
  800031:	e8 d5 05 00 00       	call   80060b <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
		0xeebfd000, 0xedbfd000 /*will be created during the call of sys_check_WS_list*/,	//Stack
		0x81b000 /*for the text color variable*/} ;


void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	53                   	push   %ebx
  80003c:	81 ec 84 00 00 01    	sub    $0x1000084,%esp
#if USE_KHEAP
	//	cprintf_colored(TEXT_cyan,"envID = %d\n",envID);

	char arr[PAGE_SIZE*1024*4];
	bool found ;
	cprintf_colored(TEXT_cyan,"STEP 0: checking Initial WS entries ...\n");
  800042:	83 ec 08             	sub    $0x8,%esp
  800045:	68 a0 21 80 00       	push   $0x8021a0
  80004a:	6a 03                	push   $0x3
  80004c:	e8 6e 0a 00 00       	call   800abf <cprintf_colored>
  800051:	83 c4 10             	add    $0x10,%esp
	{
		found = sys_check_WS_list(expectedInitialVAs, 15, 0, 1);
  800054:	6a 01                	push   $0x1
  800056:	6a 00                	push   $0x0
  800058:	6a 0f                	push   $0xf
  80005a:	68 00 30 80 00       	push   $0x803000
  80005f:	e8 f4 1d 00 00       	call   801e58 <sys_check_WS_list>
  800064:	83 c4 10             	add    $0x10,%esp
  800067:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if (found != 1) panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  80006a:	83 7d e8 01          	cmpl   $0x1,-0x18(%ebp)
  80006e:	74 14                	je     800084 <_main+0x4c>
  800070:	83 ec 04             	sub    $0x4,%esp
  800073:	68 cc 21 80 00       	push   $0x8021cc
  800078:	6a 17                	push   $0x17
  80007a:	68 0d 22 80 00       	push   $0x80220d
  80007f:	e8 40 07 00 00       	call   8007c4 <_panic>

		/*NO NEED FOR THIS IF REPL IS "LRU"*/
		if( myEnv->page_last_WS_element !=  NULL)
  800084:	a1 60 30 80 00       	mov    0x803060,%eax
  800089:	8b 80 98 00 00 00    	mov    0x98(%eax),%eax
  80008f:	85 c0                	test   %eax,%eax
  800091:	74 14                	je     8000a7 <_main+0x6f>
			panic("INITIAL PAGE last WS checking failed! Review size of the WS..!!");
  800093:	83 ec 04             	sub    $0x4,%esp
  800096:	68 24 22 80 00       	push   $0x802224
  80009b:	6a 1b                	push   $0x1b
  80009d:	68 0d 22 80 00       	push   $0x80220d
  8000a2:	e8 1d 07 00 00       	call   8007c4 <_panic>
		/*====================================*/
	}
	int eval = 0;
  8000a7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	bool is_correct = 1;
  8000ae:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)

	cprintf_colored(TEXT_cyan,"\nSTEP 1: checking USER KERNEL STACK... [20%]\n");
  8000b5:	83 ec 08             	sub    $0x8,%esp
  8000b8:	68 64 22 80 00       	push   $0x802264
  8000bd:	6a 03                	push   $0x3
  8000bf:	e8 fb 09 00 00       	call   800abf <cprintf_colored>
  8000c4:	83 c4 10             	add    $0x10,%esp
	{
		uint32 stackIsCorrect;
		sys_utilities("__CheckUserKernStack__", (uint32)(&stackIsCorrect));
  8000c7:	8d 85 d8 ff ff fe    	lea    -0x1000028(%ebp),%eax
  8000cd:	83 ec 08             	sub    $0x8,%esp
  8000d0:	50                   	push   %eax
  8000d1:	68 92 22 80 00       	push   $0x802292
  8000d6:	e8 ba 1d 00 00       	call   801e95 <sys_utilities>
  8000db:	83 c4 10             	add    $0x10,%esp
		if (!stackIsCorrect)
  8000de:	8b 85 d8 ff ff fe    	mov    -0x1000028(%ebp),%eax
  8000e4:	85 c0                	test   %eax,%eax
  8000e6:	75 19                	jne    800101 <_main+0xc9>
		{
			is_correct = 0;
  8000e8:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
			cprintf_colored(TEXT_TESTERR_CLR,"User Kernel Stack is not set correctly\n");
  8000ef:	83 ec 08             	sub    $0x8,%esp
  8000f2:	68 ac 22 80 00       	push   $0x8022ac
  8000f7:	6a 0c                	push   $0xc
  8000f9:	e8 c1 09 00 00       	call   800abf <cprintf_colored>
  8000fe:	83 c4 10             	add    $0x10,%esp
		}
	}
	if (is_correct) eval += 20;
  800101:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800105:	74 04                	je     80010b <_main+0xd3>
  800107:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)

	cprintf_colored(TEXT_cyan,"\nSTEP 2: checking PLACEMENT...\n");
  80010b:	83 ec 08             	sub    $0x8,%esp
  80010e:	68 d4 22 80 00       	push   $0x8022d4
  800113:	6a 03                	push   $0x3
  800115:	e8 a5 09 00 00       	call   800abf <cprintf_colored>
  80011a:	83 c4 10             	add    $0x10,%esp
	{
		int usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80011d:	e8 bf 19 00 00       	call   801ae1 <sys_pf_calculate_allocated_pages>
  800122:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		int freePages = sys_calculate_free_frames();
  800125:	e8 6c 19 00 00       	call   801a96 <sys_calculate_free_frames>
  80012a:	89 45 e0             	mov    %eax,-0x20(%ebp)
		//2 stack pages & page table
		int i=PAGE_SIZE*1024;
  80012d:	c7 45 ec 00 00 40 00 	movl   $0x400000,-0x14(%ebp)
		for(;i<=(PAGE_SIZE*1024 + PAGE_SIZE);i++)
  800134:	eb 11                	jmp    800147 <_main+0x10f>
		{
			arr[i] = 1;
  800136:	8d 95 dc ff ff fe    	lea    -0x1000024(%ebp),%edx
  80013c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80013f:	01 d0                	add    %edx,%eax
  800141:	c6 00 01             	movb   $0x1,(%eax)
	{
		int usedDiskPages = sys_pf_calculate_allocated_pages() ;
		int freePages = sys_calculate_free_frames();
		//2 stack pages & page table
		int i=PAGE_SIZE*1024;
		for(;i<=(PAGE_SIZE*1024 + PAGE_SIZE);i++)
  800144:	ff 45 ec             	incl   -0x14(%ebp)
  800147:	81 7d ec 00 10 40 00 	cmpl   $0x401000,-0x14(%ebp)
  80014e:	7e e6                	jle    800136 <_main+0xfe>
		{
			arr[i] = 1;
		}

		//2 stack pages & page table
		i=PAGE_SIZE*1024*2;
  800150:	c7 45 ec 00 00 80 00 	movl   $0x800000,-0x14(%ebp)
		for(;i<=(PAGE_SIZE*1024*2 + PAGE_SIZE);i++)
  800157:	eb 11                	jmp    80016a <_main+0x132>
		{
			arr[i] = 2;
  800159:	8d 95 dc ff ff fe    	lea    -0x1000024(%ebp),%edx
  80015f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800162:	01 d0                	add    %edx,%eax
  800164:	c6 00 02             	movb   $0x2,(%eax)
			arr[i] = 1;
		}

		//2 stack pages & page table
		i=PAGE_SIZE*1024*2;
		for(;i<=(PAGE_SIZE*1024*2 + PAGE_SIZE);i++)
  800167:	ff 45 ec             	incl   -0x14(%ebp)
  80016a:	81 7d ec 00 10 80 00 	cmpl   $0x801000,-0x14(%ebp)
  800171:	7e e6                	jle    800159 <_main+0x121>
		{
			arr[i] = 2;
		}

		//2 stack pages & page table
		i=PAGE_SIZE*1024*3;
  800173:	c7 45 ec 00 00 c0 00 	movl   $0xc00000,-0x14(%ebp)
		for(;i<=(PAGE_SIZE*1024*3 + PAGE_SIZE);i++)
  80017a:	eb 11                	jmp    80018d <_main+0x155>
		{
			arr[i] = 3;
  80017c:	8d 95 dc ff ff fe    	lea    -0x1000024(%ebp),%edx
  800182:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800185:	01 d0                	add    %edx,%eax
  800187:	c6 00 03             	movb   $0x3,(%eax)
			arr[i] = 2;
		}

		//2 stack pages & page table
		i=PAGE_SIZE*1024*3;
		for(;i<=(PAGE_SIZE*1024*3 + PAGE_SIZE);i++)
  80018a:	ff 45 ec             	incl   -0x14(%ebp)
  80018d:	81 7d ec 00 10 c0 00 	cmpl   $0xc01000,-0x14(%ebp)
  800194:	7e e6                	jle    80017c <_main+0x144>
		{
			arr[i] = 3;
		}

		is_correct = 1;
  800196:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
		cprintf_colored(TEXT_cyan,"	STEP A: checking PLACEMENT fault handling... [30%] \n");
  80019d:	83 ec 08             	sub    $0x8,%esp
  8001a0:	68 f4 22 80 00       	push   $0x8022f4
  8001a5:	6a 03                	push   $0x3
  8001a7:	e8 13 09 00 00       	call   800abf <cprintf_colored>
  8001ac:	83 c4 10             	add    $0x10,%esp
		{
			if( arr[PAGE_SIZE*1024] !=  1)  { is_correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"PLACEMENT of stack page failed\n");}
  8001af:	8a 85 dc ff 3f ff    	mov    -0xc00024(%ebp),%al
  8001b5:	3c 01                	cmp    $0x1,%al
  8001b7:	74 19                	je     8001d2 <_main+0x19a>
  8001b9:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8001c0:	83 ec 08             	sub    $0x8,%esp
  8001c3:	68 2c 23 80 00       	push   $0x80232c
  8001c8:	6a 0c                	push   $0xc
  8001ca:	e8 f0 08 00 00       	call   800abf <cprintf_colored>
  8001cf:	83 c4 10             	add    $0x10,%esp
			if( arr[PAGE_SIZE*1025] !=  1)  { is_correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"PLACEMENT of stack page failed\n");}
  8001d2:	8a 85 dc 0f 40 ff    	mov    -0xbff024(%ebp),%al
  8001d8:	3c 01                	cmp    $0x1,%al
  8001da:	74 19                	je     8001f5 <_main+0x1bd>
  8001dc:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8001e3:	83 ec 08             	sub    $0x8,%esp
  8001e6:	68 2c 23 80 00       	push   $0x80232c
  8001eb:	6a 0c                	push   $0xc
  8001ed:	e8 cd 08 00 00       	call   800abf <cprintf_colored>
  8001f2:	83 c4 10             	add    $0x10,%esp

			if( arr[PAGE_SIZE*1024*2] !=  2)  { is_correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"PLACEMENT of stack page failed\n");}
  8001f5:	8a 85 dc ff 7f ff    	mov    -0x800024(%ebp),%al
  8001fb:	3c 02                	cmp    $0x2,%al
  8001fd:	74 19                	je     800218 <_main+0x1e0>
  8001ff:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800206:	83 ec 08             	sub    $0x8,%esp
  800209:	68 2c 23 80 00       	push   $0x80232c
  80020e:	6a 0c                	push   $0xc
  800210:	e8 aa 08 00 00       	call   800abf <cprintf_colored>
  800215:	83 c4 10             	add    $0x10,%esp
			if( arr[PAGE_SIZE*1024*2 + PAGE_SIZE] !=  2)  { is_correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"PLACEMENT of stack page failed\n");}
  800218:	8a 85 dc 0f 80 ff    	mov    -0x7ff024(%ebp),%al
  80021e:	3c 02                	cmp    $0x2,%al
  800220:	74 19                	je     80023b <_main+0x203>
  800222:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800229:	83 ec 08             	sub    $0x8,%esp
  80022c:	68 2c 23 80 00       	push   $0x80232c
  800231:	6a 0c                	push   $0xc
  800233:	e8 87 08 00 00       	call   800abf <cprintf_colored>
  800238:	83 c4 10             	add    $0x10,%esp

			if( arr[PAGE_SIZE*1024*3] !=  3)  { is_correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"PLACEMENT of stack page failed\n");}
  80023b:	8a 85 dc ff bf ff    	mov    -0x400024(%ebp),%al
  800241:	3c 03                	cmp    $0x3,%al
  800243:	74 19                	je     80025e <_main+0x226>
  800245:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80024c:	83 ec 08             	sub    $0x8,%esp
  80024f:	68 2c 23 80 00       	push   $0x80232c
  800254:	6a 0c                	push   $0xc
  800256:	e8 64 08 00 00       	call   800abf <cprintf_colored>
  80025b:	83 c4 10             	add    $0x10,%esp
			if( arr[PAGE_SIZE*1024*3 + PAGE_SIZE] !=  3)  { is_correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"PLACEMENT of stack page failed\n");}
  80025e:	8a 85 dc 0f c0 ff    	mov    -0x3ff024(%ebp),%al
  800264:	3c 03                	cmp    $0x3,%al
  800266:	74 19                	je     800281 <_main+0x249>
  800268:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80026f:	83 ec 08             	sub    $0x8,%esp
  800272:	68 2c 23 80 00       	push   $0x80232c
  800277:	6a 0c                	push   $0xc
  800279:	e8 41 08 00 00       	call   800abf <cprintf_colored>
  80027e:	83 c4 10             	add    $0x10,%esp

			if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) { is_correct = 0; cprintf_colored(TEXT_cyan,"new stack pages should NOT be written to Page File until evicted as victim\n");}
  800281:	e8 5b 18 00 00       	call   801ae1 <sys_pf_calculate_allocated_pages>
  800286:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800289:	74 19                	je     8002a4 <_main+0x26c>
  80028b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800292:	83 ec 08             	sub    $0x8,%esp
  800295:	68 4c 23 80 00       	push   $0x80234c
  80029a:	6a 03                	push   $0x3
  80029c:	e8 1e 08 00 00       	call   800abf <cprintf_colored>
  8002a1:	83 c4 10             	add    $0x10,%esp

			int expected = 6 /*pages*/ + 3 /*tables*/;
  8002a4:	c7 45 dc 09 00 00 00 	movl   $0x9,-0x24(%ebp)
			if( (freePages - sys_calculate_free_frames() ) != expected )
  8002ab:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  8002ae:	e8 e3 17 00 00       	call   801a96 <sys_calculate_free_frames>
  8002b3:	29 c3                	sub    %eax,%ebx
  8002b5:	89 da                	mov    %ebx,%edx
  8002b7:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8002ba:	39 c2                	cmp    %eax,%edx
  8002bc:	74 26                	je     8002e4 <_main+0x2ac>
			{ is_correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"allocated memory size incorrect. Expected Difference = %d, Actual = %d\n", expected, (freePages - sys_calculate_free_frames() ));}
  8002be:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8002c5:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  8002c8:	e8 c9 17 00 00       	call   801a96 <sys_calculate_free_frames>
  8002cd:	29 c3                	sub    %eax,%ebx
  8002cf:	89 d8                	mov    %ebx,%eax
  8002d1:	50                   	push   %eax
  8002d2:	ff 75 dc             	pushl  -0x24(%ebp)
  8002d5:	68 98 23 80 00       	push   $0x802398
  8002da:	6a 0c                	push   $0xc
  8002dc:	e8 de 07 00 00       	call   800abf <cprintf_colored>
  8002e1:	83 c4 10             	add    $0x10,%esp
		}
		cprintf_colored(TEXT_cyan,"	STEP A finished: PLACEMENT fault handling !\n\n\n");
  8002e4:	83 ec 08             	sub    $0x8,%esp
  8002e7:	68 e0 23 80 00       	push   $0x8023e0
  8002ec:	6a 03                	push   $0x3
  8002ee:	e8 cc 07 00 00       	call   800abf <cprintf_colored>
  8002f3:	83 c4 10             	add    $0x10,%esp

		if (is_correct)
  8002f6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8002fa:	74 04                	je     800300 <_main+0x2c8>
		{
			eval += 30;
  8002fc:	83 45 f4 1e          	addl   $0x1e,-0xc(%ebp)
		}
		is_correct = 1;
  800300:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)

		cprintf_colored(TEXT_cyan,"	STEP B: checking WS entries... [30%]\n");
  800307:	83 ec 08             	sub    $0x8,%esp
  80030a:	68 10 24 80 00       	push   $0x802410
  80030f:	6a 03                	push   $0x3
  800311:	e8 a9 07 00 00       	call   800abf <cprintf_colored>
  800316:	83 c4 10             	add    $0x10,%esp
		{
			uint32 expectedPages[21] ;
			{
				expectedPages[0] = 0x800000 ;
  800319:	c7 85 80 ff ff fe 00 	movl   $0x800000,-0x1000080(%ebp)
  800320:	00 80 00 
				expectedPages[1] = 0x801000 ;
  800323:	c7 85 84 ff ff fe 00 	movl   $0x801000,-0x100007c(%ebp)
  80032a:	10 80 00 
				expectedPages[2] = 0x802000 ;
  80032d:	c7 85 88 ff ff fe 00 	movl   $0x802000,-0x1000078(%ebp)
  800334:	20 80 00 
				expectedPages[3] = 0x803000 ;
  800337:	c7 85 8c ff ff fe 00 	movl   $0x803000,-0x1000074(%ebp)
  80033e:	30 80 00 
				expectedPages[4] = 0x804000 ;
  800341:	c7 85 90 ff ff fe 00 	movl   $0x804000,-0x1000070(%ebp)
  800348:	40 80 00 
				expectedPages[5] = 0x805000 ;
  80034b:	c7 85 94 ff ff fe 00 	movl   $0x805000,-0x100006c(%ebp)
  800352:	50 80 00 
				expectedPages[6] = 0x806000 ;
  800355:	c7 85 98 ff ff fe 00 	movl   $0x806000,-0x1000068(%ebp)
  80035c:	60 80 00 
				expectedPages[7] = 0x807000 ;
  80035f:	c7 85 9c ff ff fe 00 	movl   $0x807000,-0x1000064(%ebp)
  800366:	70 80 00 
				expectedPages[8] = 0x808000 ;
  800369:	c7 85 a0 ff ff fe 00 	movl   $0x808000,-0x1000060(%ebp)
  800370:	80 80 00 
				expectedPages[9] = 0x809000 ;
  800373:	c7 85 a4 ff ff fe 00 	movl   $0x809000,-0x100005c(%ebp)
  80037a:	90 80 00 
				expectedPages[10] = 0x80a000 ;
  80037d:	c7 85 a8 ff ff fe 00 	movl   $0x80a000,-0x1000058(%ebp)
  800384:	a0 80 00 
				expectedPages[11] = 0x80b000 ;
  800387:	c7 85 ac ff ff fe 00 	movl   $0x80b000,-0x1000054(%ebp)
  80038e:	b0 80 00 
				expectedPages[12] = 0xeebfd000 ;
  800391:	c7 85 b0 ff ff fe 00 	movl   $0xeebfd000,-0x1000050(%ebp)
  800398:	d0 bf ee 
				expectedPages[13] = 0xedbfd000 ;
  80039b:	c7 85 b4 ff ff fe 00 	movl   $0xedbfd000,-0x100004c(%ebp)
  8003a2:	d0 bf ed 
				expectedPages[14] = 0x81b000 ;
  8003a5:	c7 85 b8 ff ff fe 00 	movl   $0x81b000,-0x1000048(%ebp)
  8003ac:	b0 81 00 
				expectedPages[15] = 0xedffd000 ;
  8003af:	c7 85 bc ff ff fe 00 	movl   $0xedffd000,-0x1000044(%ebp)
  8003b6:	d0 ff ed 
				expectedPages[16] = 0xedffe000 ;
  8003b9:	c7 85 c0 ff ff fe 00 	movl   $0xedffe000,-0x1000040(%ebp)
  8003c0:	e0 ff ed 
				expectedPages[17] = 0xee3fd000 ;
  8003c3:	c7 85 c4 ff ff fe 00 	movl   $0xee3fd000,-0x100003c(%ebp)
  8003ca:	d0 3f ee 
				expectedPages[18] = 0xee3fe000 ;
  8003cd:	c7 85 c8 ff ff fe 00 	movl   $0xee3fe000,-0x1000038(%ebp)
  8003d4:	e0 3f ee 
				expectedPages[19] = 0xee7fd000 ;
  8003d7:	c7 85 cc ff ff fe 00 	movl   $0xee7fd000,-0x1000034(%ebp)
  8003de:	d0 7f ee 
				expectedPages[20] = 0xee7fe000 ;
  8003e1:	c7 85 d0 ff ff fe 00 	movl   $0xee7fe000,-0x1000030(%ebp)
  8003e8:	e0 7f ee 
			}
			found = sys_check_WS_list(expectedPages, 21, 0, 1);
  8003eb:	6a 01                	push   $0x1
  8003ed:	6a 00                	push   $0x0
  8003ef:	6a 15                	push   $0x15
  8003f1:	8d 85 80 ff ff fe    	lea    -0x1000080(%ebp),%eax
  8003f7:	50                   	push   %eax
  8003f8:	e8 5b 1a 00 00       	call   801e58 <sys_check_WS_list>
  8003fd:	83 c4 10             	add    $0x10,%esp
  800400:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if (found != 1)
  800403:	83 7d e8 01          	cmpl   $0x1,-0x18(%ebp)
  800407:	74 19                	je     800422 <_main+0x3ea>
			{ is_correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"PAGE WS entry checking failed... trace it by printing page WS before & after fault\n");}
  800409:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800410:	83 ec 08             	sub    $0x8,%esp
  800413:	68 38 24 80 00       	push   $0x802438
  800418:	6a 0c                	push   $0xc
  80041a:	e8 a0 06 00 00       	call   800abf <cprintf_colored>
  80041f:	83 c4 10             	add    $0x10,%esp
		}
		cprintf_colored(TEXT_cyan,"	STEP B finished: WS entries test \n\n\n");
  800422:	83 ec 08             	sub    $0x8,%esp
  800425:	68 8c 24 80 00       	push   $0x80248c
  80042a:	6a 03                	push   $0x3
  80042c:	e8 8e 06 00 00       	call   800abf <cprintf_colored>
  800431:	83 c4 10             	add    $0x10,%esp
		if (is_correct)
  800434:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800438:	74 04                	je     80043e <_main+0x406>
		{
			eval += 30;
  80043a:	83 45 f4 1e          	addl   $0x1e,-0xc(%ebp)
		}
		is_correct = 1;
  80043e:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
		cprintf_colored(TEXT_cyan,"	STEP C: checking working sets WHEN BECOMES FULL... [20%]\n");
  800445:	83 ec 08             	sub    $0x8,%esp
  800448:	68 b4 24 80 00       	push   $0x8024b4
  80044d:	6a 03                	push   $0x3
  80044f:	e8 6b 06 00 00       	call   800abf <cprintf_colored>
  800454:	83 c4 10             	add    $0x10,%esp
		{
			/*NO NEED FOR THIS IF REPL IS "LRU"*/
			if(myEnv->page_last_WS_element != NULL)
  800457:	a1 60 30 80 00       	mov    0x803060,%eax
  80045c:	8b 80 98 00 00 00    	mov    0x98(%eax),%eax
  800462:	85 c0                	test   %eax,%eax
  800464:	74 19                	je     80047f <_main+0x447>
			{ is_correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"wrong PAGE WS pointer location... trace it by printing page WS before & after fault\n");}
  800466:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80046d:	83 ec 08             	sub    $0x8,%esp
  800470:	68 f0 24 80 00       	push   $0x8024f0
  800475:	6a 0c                	push   $0xc
  800477:	e8 43 06 00 00       	call   800abf <cprintf_colored>
  80047c:	83 c4 10             	add    $0x10,%esp

			//1 stack page
			i=PAGE_SIZE*1024*3 + 2*PAGE_SIZE;
  80047f:	c7 45 ec 00 20 c0 00 	movl   $0xc02000,-0x14(%ebp)
			arr[i] = 4;
  800486:	8d 95 dc ff ff fe    	lea    -0x1000024(%ebp),%edx
  80048c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80048f:	01 d0                	add    %edx,%eax
  800491:	c6 00 04             	movb   $0x4,(%eax)

			if( arr[i] != 4)  { is_correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"PLACEMENT of stack page failed\n");}
  800494:	8d 95 dc ff ff fe    	lea    -0x1000024(%ebp),%edx
  80049a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80049d:	01 d0                	add    %edx,%eax
  80049f:	8a 00                	mov    (%eax),%al
  8004a1:	3c 04                	cmp    $0x4,%al
  8004a3:	74 19                	je     8004be <_main+0x486>
  8004a5:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8004ac:	83 ec 08             	sub    $0x8,%esp
  8004af:	68 2c 23 80 00       	push   $0x80232c
  8004b4:	6a 0c                	push   $0xc
  8004b6:	e8 04 06 00 00       	call   800abf <cprintf_colored>
  8004bb:	83 c4 10             	add    $0x10,%esp
			//				0x200000,0x201000,0x202000,0x203000,0x204000,0x205000,0x206000,0x207000,
			//				0x800000,0x801000,0x802000,0x803000,
			//				0xeebfd000,0xedbfd000,0xedbfe000,0xedffd000,0xedffe000,0xee3fd000,0xee3fe000,0xee7fd000};
			uint32 expectedPages[22] ;
			{
				expectedPages[0] = 0x800000 ;
  8004be:	c7 85 80 ff ff fe 00 	movl   $0x800000,-0x1000080(%ebp)
  8004c5:	00 80 00 
				expectedPages[1] = 0x801000 ;
  8004c8:	c7 85 84 ff ff fe 00 	movl   $0x801000,-0x100007c(%ebp)
  8004cf:	10 80 00 
				expectedPages[2] = 0x802000 ;
  8004d2:	c7 85 88 ff ff fe 00 	movl   $0x802000,-0x1000078(%ebp)
  8004d9:	20 80 00 
				expectedPages[3] = 0x803000 ;
  8004dc:	c7 85 8c ff ff fe 00 	movl   $0x803000,-0x1000074(%ebp)
  8004e3:	30 80 00 
				expectedPages[4] = 0x804000 ;
  8004e6:	c7 85 90 ff ff fe 00 	movl   $0x804000,-0x1000070(%ebp)
  8004ed:	40 80 00 
				expectedPages[5] = 0x805000 ;
  8004f0:	c7 85 94 ff ff fe 00 	movl   $0x805000,-0x100006c(%ebp)
  8004f7:	50 80 00 
				expectedPages[6] = 0x806000 ;
  8004fa:	c7 85 98 ff ff fe 00 	movl   $0x806000,-0x1000068(%ebp)
  800501:	60 80 00 
				expectedPages[7] = 0x807000 ;
  800504:	c7 85 9c ff ff fe 00 	movl   $0x807000,-0x1000064(%ebp)
  80050b:	70 80 00 
				expectedPages[8] = 0x808000 ;
  80050e:	c7 85 a0 ff ff fe 00 	movl   $0x808000,-0x1000060(%ebp)
  800515:	80 80 00 
				expectedPages[9] = 0x809000 ;
  800518:	c7 85 a4 ff ff fe 00 	movl   $0x809000,-0x100005c(%ebp)
  80051f:	90 80 00 
				expectedPages[10] = 0x80a000 ;
  800522:	c7 85 a8 ff ff fe 00 	movl   $0x80a000,-0x1000058(%ebp)
  800529:	a0 80 00 
				expectedPages[11] = 0x80b000 ;
  80052c:	c7 85 ac ff ff fe 00 	movl   $0x80b000,-0x1000054(%ebp)
  800533:	b0 80 00 
				expectedPages[12] = 0xeebfd000 ;
  800536:	c7 85 b0 ff ff fe 00 	movl   $0xeebfd000,-0x1000050(%ebp)
  80053d:	d0 bf ee 
				expectedPages[13] = 0xedbfd000 ;
  800540:	c7 85 b4 ff ff fe 00 	movl   $0xedbfd000,-0x100004c(%ebp)
  800547:	d0 bf ed 
				expectedPages[14] = 0x81b000 ;
  80054a:	c7 85 b8 ff ff fe 00 	movl   $0x81b000,-0x1000048(%ebp)
  800551:	b0 81 00 
				expectedPages[15] = 0xedffd000 ;
  800554:	c7 85 bc ff ff fe 00 	movl   $0xedffd000,-0x1000044(%ebp)
  80055b:	d0 ff ed 
				expectedPages[16] = 0xedffe000 ;
  80055e:	c7 85 c0 ff ff fe 00 	movl   $0xedffe000,-0x1000040(%ebp)
  800565:	e0 ff ed 
				expectedPages[17] = 0xee3fd000 ;
  800568:	c7 85 c4 ff ff fe 00 	movl   $0xee3fd000,-0x100003c(%ebp)
  80056f:	d0 3f ee 
				expectedPages[18] = 0xee3fe000 ;
  800572:	c7 85 c8 ff ff fe 00 	movl   $0xee3fe000,-0x1000038(%ebp)
  800579:	e0 3f ee 
				expectedPages[19] = 0xee7fd000 ;
  80057c:	c7 85 cc ff ff fe 00 	movl   $0xee7fd000,-0x1000034(%ebp)
  800583:	d0 7f ee 
				expectedPages[20] = 0xee7fe000 ;
  800586:	c7 85 d0 ff ff fe 00 	movl   $0xee7fe000,-0x1000030(%ebp)
  80058d:	e0 7f ee 
				expectedPages[21] = 0xee7ff000 ;
  800590:	c7 85 d4 ff ff fe 00 	movl   $0xee7ff000,-0x100002c(%ebp)
  800597:	f0 7f ee 
			}
			found = sys_check_WS_list(expectedPages, 22, 0x800000, 1);
  80059a:	6a 01                	push   $0x1
  80059c:	68 00 00 80 00       	push   $0x800000
  8005a1:	6a 16                	push   $0x16
  8005a3:	8d 85 80 ff ff fe    	lea    -0x1000080(%ebp),%eax
  8005a9:	50                   	push   %eax
  8005aa:	e8 a9 18 00 00       	call   801e58 <sys_check_WS_list>
  8005af:	83 c4 10             	add    $0x10,%esp
  8005b2:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if (found != 1)
  8005b5:	83 7d e8 01          	cmpl   $0x1,-0x18(%ebp)
  8005b9:	74 19                	je     8005d4 <_main+0x59c>
			{ is_correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"PAGE WS entry checking failed... trace it by printing page WS before & after fault\n");}
  8005bb:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8005c2:	83 ec 08             	sub    $0x8,%esp
  8005c5:	68 38 24 80 00       	push   $0x802438
  8005ca:	6a 0c                	push   $0xc
  8005cc:	e8 ee 04 00 00       	call   800abf <cprintf_colored>
  8005d1:	83 c4 10             	add    $0x10,%esp
		}
		cprintf_colored(TEXT_cyan, "	STEP C finished: WS is FULL now\n\n\n");
  8005d4:	83 ec 08             	sub    $0x8,%esp
  8005d7:	68 48 25 80 00       	push   $0x802548
  8005dc:	6a 03                	push   $0x3
  8005de:	e8 dc 04 00 00       	call   800abf <cprintf_colored>
  8005e3:	83 c4 10             	add    $0x10,%esp
		if (is_correct)
  8005e6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8005ea:	74 04                	je     8005f0 <_main+0x5b8>
		{
			eval += 20;
  8005ec:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
		}
	}
	cprintf_colored(TEXT_light_green, "%~\nTest of KERNEL STACK & PAGE PLACEMENT completed. Eval = %d%\n\n", eval);
  8005f0:	83 ec 04             	sub    $0x4,%esp
  8005f3:	ff 75 f4             	pushl  -0xc(%ebp)
  8005f6:	68 6c 25 80 00       	push   $0x80256c
  8005fb:	6a 0a                	push   $0xa
  8005fd:	e8 bd 04 00 00       	call   800abf <cprintf_colored>
  800602:	83 c4 10             	add    $0x10,%esp

	return;
  800605:	90                   	nop
#endif
}
  800606:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800609:	c9                   	leave  
  80060a:	c3                   	ret    

0080060b <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  80060b:	55                   	push   %ebp
  80060c:	89 e5                	mov    %esp,%ebp
  80060e:	57                   	push   %edi
  80060f:	56                   	push   %esi
  800610:	53                   	push   %ebx
  800611:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  800614:	e8 46 16 00 00       	call   801c5f <sys_getenvindex>
  800619:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  80061c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80061f:	89 d0                	mov    %edx,%eax
  800621:	c1 e0 02             	shl    $0x2,%eax
  800624:	01 d0                	add    %edx,%eax
  800626:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80062d:	01 d0                	add    %edx,%eax
  80062f:	89 c2                	mov    %eax,%edx
  800631:	c1 e2 04             	shl    $0x4,%edx
  800634:	29 c2                	sub    %eax,%edx
  800636:	8d 04 95 00 00 00 00 	lea    0x0(,%edx,4),%eax
  80063d:	89 c2                	mov    %eax,%edx
  80063f:	8d 82 00 00 c0 ee    	lea    -0x11400000(%edx),%eax
  800645:	a3 60 30 80 00       	mov    %eax,0x803060

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  80064a:	a1 60 30 80 00       	mov    0x803060,%eax
  80064f:	8a 40 20             	mov    0x20(%eax),%al
  800652:	84 c0                	test   %al,%al
  800654:	74 0d                	je     800663 <libmain+0x58>
		binaryname = myEnv->prog_name;
  800656:	a1 60 30 80 00       	mov    0x803060,%eax
  80065b:	83 c0 20             	add    $0x20,%eax
  80065e:	a3 40 30 80 00       	mov    %eax,0x803040

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800663:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800667:	7e 0a                	jle    800673 <libmain+0x68>
		binaryname = argv[0];
  800669:	8b 45 0c             	mov    0xc(%ebp),%eax
  80066c:	8b 00                	mov    (%eax),%eax
  80066e:	a3 40 30 80 00       	mov    %eax,0x803040

	// call user main routine
	_main(argc, argv);
  800673:	83 ec 08             	sub    $0x8,%esp
  800676:	ff 75 0c             	pushl  0xc(%ebp)
  800679:	ff 75 08             	pushl  0x8(%ebp)
  80067c:	e8 b7 f9 ff ff       	call   800038 <_main>
  800681:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  800684:	a1 3c 30 80 00       	mov    0x80303c,%eax
  800689:	85 c0                	test   %eax,%eax
  80068b:	0f 84 01 01 00 00    	je     800792 <libmain+0x187>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  800691:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  800697:	bb a8 26 80 00       	mov    $0x8026a8,%ebx
  80069c:	ba 0e 00 00 00       	mov    $0xe,%edx
  8006a1:	89 c7                	mov    %eax,%edi
  8006a3:	89 de                	mov    %ebx,%esi
  8006a5:	89 d1                	mov    %edx,%ecx
  8006a7:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  8006a9:	8d 55 8a             	lea    -0x76(%ebp),%edx
  8006ac:	b9 56 00 00 00       	mov    $0x56,%ecx
  8006b1:	b0 00                	mov    $0x0,%al
  8006b3:	89 d7                	mov    %edx,%edi
  8006b5:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  8006b7:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  8006be:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8006c1:	83 ec 08             	sub    $0x8,%esp
  8006c4:	50                   	push   %eax
  8006c5:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  8006cb:	50                   	push   %eax
  8006cc:	e8 c4 17 00 00       	call   801e95 <sys_utilities>
  8006d1:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  8006d4:	e8 0d 13 00 00       	call   8019e6 <sys_lock_cons>
		{
			cprintf("**************************************\n");
  8006d9:	83 ec 0c             	sub    $0xc,%esp
  8006dc:	68 c8 25 80 00       	push   $0x8025c8
  8006e1:	e8 ac 03 00 00       	call   800a92 <cprintf>
  8006e6:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  8006e9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8006ec:	85 c0                	test   %eax,%eax
  8006ee:	74 18                	je     800708 <libmain+0xfd>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  8006f0:	e8 be 17 00 00       	call   801eb3 <sys_get_optimal_num_faults>
  8006f5:	83 ec 08             	sub    $0x8,%esp
  8006f8:	50                   	push   %eax
  8006f9:	68 f0 25 80 00       	push   $0x8025f0
  8006fe:	e8 8f 03 00 00       	call   800a92 <cprintf>
  800703:	83 c4 10             	add    $0x10,%esp
  800706:	eb 59                	jmp    800761 <libmain+0x156>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800708:	a1 60 30 80 00       	mov    0x803060,%eax
  80070d:	8b 90 bc 05 00 00    	mov    0x5bc(%eax),%edx
  800713:	a1 60 30 80 00       	mov    0x803060,%eax
  800718:	8b 80 ac 05 00 00    	mov    0x5ac(%eax),%eax
  80071e:	83 ec 04             	sub    $0x4,%esp
  800721:	52                   	push   %edx
  800722:	50                   	push   %eax
  800723:	68 14 26 80 00       	push   $0x802614
  800728:	e8 65 03 00 00       	call   800a92 <cprintf>
  80072d:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800730:	a1 60 30 80 00       	mov    0x803060,%eax
  800735:	8b 88 d0 05 00 00    	mov    0x5d0(%eax),%ecx
  80073b:	a1 60 30 80 00       	mov    0x803060,%eax
  800740:	8b 90 cc 05 00 00    	mov    0x5cc(%eax),%edx
  800746:	a1 60 30 80 00       	mov    0x803060,%eax
  80074b:	8b 80 c8 05 00 00    	mov    0x5c8(%eax),%eax
  800751:	51                   	push   %ecx
  800752:	52                   	push   %edx
  800753:	50                   	push   %eax
  800754:	68 3c 26 80 00       	push   $0x80263c
  800759:	e8 34 03 00 00       	call   800a92 <cprintf>
  80075e:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800761:	a1 60 30 80 00       	mov    0x803060,%eax
  800766:	8b 80 d4 05 00 00    	mov    0x5d4(%eax),%eax
  80076c:	83 ec 08             	sub    $0x8,%esp
  80076f:	50                   	push   %eax
  800770:	68 94 26 80 00       	push   $0x802694
  800775:	e8 18 03 00 00       	call   800a92 <cprintf>
  80077a:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  80077d:	83 ec 0c             	sub    $0xc,%esp
  800780:	68 c8 25 80 00       	push   $0x8025c8
  800785:	e8 08 03 00 00       	call   800a92 <cprintf>
  80078a:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  80078d:	e8 6e 12 00 00       	call   801a00 <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  800792:	e8 1f 00 00 00       	call   8007b6 <exit>
}
  800797:	90                   	nop
  800798:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80079b:	5b                   	pop    %ebx
  80079c:	5e                   	pop    %esi
  80079d:	5f                   	pop    %edi
  80079e:	5d                   	pop    %ebp
  80079f:	c3                   	ret    

008007a0 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8007a0:	55                   	push   %ebp
  8007a1:	89 e5                	mov    %esp,%ebp
  8007a3:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8007a6:	83 ec 0c             	sub    $0xc,%esp
  8007a9:	6a 00                	push   $0x0
  8007ab:	e8 7b 14 00 00       	call   801c2b <sys_destroy_env>
  8007b0:	83 c4 10             	add    $0x10,%esp
}
  8007b3:	90                   	nop
  8007b4:	c9                   	leave  
  8007b5:	c3                   	ret    

008007b6 <exit>:

void
exit(void)
{
  8007b6:	55                   	push   %ebp
  8007b7:	89 e5                	mov    %esp,%ebp
  8007b9:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8007bc:	e8 d0 14 00 00       	call   801c91 <sys_exit_env>
}
  8007c1:	90                   	nop
  8007c2:	c9                   	leave  
  8007c3:	c3                   	ret    

008007c4 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8007c4:	55                   	push   %ebp
  8007c5:	89 e5                	mov    %esp,%ebp
  8007c7:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8007ca:	8d 45 10             	lea    0x10(%ebp),%eax
  8007cd:	83 c0 04             	add    $0x4,%eax
  8007d0:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8007d3:	a1 58 b1 81 00       	mov    0x81b158,%eax
  8007d8:	85 c0                	test   %eax,%eax
  8007da:	74 16                	je     8007f2 <_panic+0x2e>
		cprintf("%s: ", argv0);
  8007dc:	a1 58 b1 81 00       	mov    0x81b158,%eax
  8007e1:	83 ec 08             	sub    $0x8,%esp
  8007e4:	50                   	push   %eax
  8007e5:	68 0c 27 80 00       	push   $0x80270c
  8007ea:	e8 a3 02 00 00       	call   800a92 <cprintf>
  8007ef:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  8007f2:	a1 40 30 80 00       	mov    0x803040,%eax
  8007f7:	83 ec 0c             	sub    $0xc,%esp
  8007fa:	ff 75 0c             	pushl  0xc(%ebp)
  8007fd:	ff 75 08             	pushl  0x8(%ebp)
  800800:	50                   	push   %eax
  800801:	68 14 27 80 00       	push   $0x802714
  800806:	6a 74                	push   $0x74
  800808:	e8 b2 02 00 00       	call   800abf <cprintf_colored>
  80080d:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  800810:	8b 45 10             	mov    0x10(%ebp),%eax
  800813:	83 ec 08             	sub    $0x8,%esp
  800816:	ff 75 f4             	pushl  -0xc(%ebp)
  800819:	50                   	push   %eax
  80081a:	e8 04 02 00 00       	call   800a23 <vcprintf>
  80081f:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800822:	83 ec 08             	sub    $0x8,%esp
  800825:	6a 00                	push   $0x0
  800827:	68 3c 27 80 00       	push   $0x80273c
  80082c:	e8 f2 01 00 00       	call   800a23 <vcprintf>
  800831:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800834:	e8 7d ff ff ff       	call   8007b6 <exit>

	// should not return here
	while (1) ;
  800839:	eb fe                	jmp    800839 <_panic+0x75>

0080083b <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  80083b:	55                   	push   %ebp
  80083c:	89 e5                	mov    %esp,%ebp
  80083e:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800841:	a1 60 30 80 00       	mov    0x803060,%eax
  800846:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  80084c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80084f:	39 c2                	cmp    %eax,%edx
  800851:	74 14                	je     800867 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800853:	83 ec 04             	sub    $0x4,%esp
  800856:	68 40 27 80 00       	push   $0x802740
  80085b:	6a 26                	push   $0x26
  80085d:	68 8c 27 80 00       	push   $0x80278c
  800862:	e8 5d ff ff ff       	call   8007c4 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800867:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  80086e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800875:	e9 c5 00 00 00       	jmp    80093f <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  80087a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80087d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800884:	8b 45 08             	mov    0x8(%ebp),%eax
  800887:	01 d0                	add    %edx,%eax
  800889:	8b 00                	mov    (%eax),%eax
  80088b:	85 c0                	test   %eax,%eax
  80088d:	75 08                	jne    800897 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  80088f:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800892:	e9 a5 00 00 00       	jmp    80093c <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  800897:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80089e:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8008a5:	eb 69                	jmp    800910 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8008a7:	a1 60 30 80 00       	mov    0x803060,%eax
  8008ac:	8b 88 a4 05 00 00    	mov    0x5a4(%eax),%ecx
  8008b2:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8008b5:	89 d0                	mov    %edx,%eax
  8008b7:	01 c0                	add    %eax,%eax
  8008b9:	01 d0                	add    %edx,%eax
  8008bb:	c1 e0 03             	shl    $0x3,%eax
  8008be:	01 c8                	add    %ecx,%eax
  8008c0:	8a 40 04             	mov    0x4(%eax),%al
  8008c3:	84 c0                	test   %al,%al
  8008c5:	75 46                	jne    80090d <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8008c7:	a1 60 30 80 00       	mov    0x803060,%eax
  8008cc:	8b 88 a4 05 00 00    	mov    0x5a4(%eax),%ecx
  8008d2:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8008d5:	89 d0                	mov    %edx,%eax
  8008d7:	01 c0                	add    %eax,%eax
  8008d9:	01 d0                	add    %edx,%eax
  8008db:	c1 e0 03             	shl    $0x3,%eax
  8008de:	01 c8                	add    %ecx,%eax
  8008e0:	8b 00                	mov    (%eax),%eax
  8008e2:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8008e5:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8008e8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8008ed:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8008ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8008f2:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8008f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8008fc:	01 c8                	add    %ecx,%eax
  8008fe:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800900:	39 c2                	cmp    %eax,%edx
  800902:	75 09                	jne    80090d <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  800904:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  80090b:	eb 15                	jmp    800922 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80090d:	ff 45 e8             	incl   -0x18(%ebp)
  800910:	a1 60 30 80 00       	mov    0x803060,%eax
  800915:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  80091b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80091e:	39 c2                	cmp    %eax,%edx
  800920:	77 85                	ja     8008a7 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800922:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800926:	75 14                	jne    80093c <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  800928:	83 ec 04             	sub    $0x4,%esp
  80092b:	68 98 27 80 00       	push   $0x802798
  800930:	6a 3a                	push   $0x3a
  800932:	68 8c 27 80 00       	push   $0x80278c
  800937:	e8 88 fe ff ff       	call   8007c4 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  80093c:	ff 45 f0             	incl   -0x10(%ebp)
  80093f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800942:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800945:	0f 8c 2f ff ff ff    	jl     80087a <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  80094b:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800952:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800959:	eb 26                	jmp    800981 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  80095b:	a1 60 30 80 00       	mov    0x803060,%eax
  800960:	8b 88 a4 05 00 00    	mov    0x5a4(%eax),%ecx
  800966:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800969:	89 d0                	mov    %edx,%eax
  80096b:	01 c0                	add    %eax,%eax
  80096d:	01 d0                	add    %edx,%eax
  80096f:	c1 e0 03             	shl    $0x3,%eax
  800972:	01 c8                	add    %ecx,%eax
  800974:	8a 40 04             	mov    0x4(%eax),%al
  800977:	3c 01                	cmp    $0x1,%al
  800979:	75 03                	jne    80097e <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  80097b:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80097e:	ff 45 e0             	incl   -0x20(%ebp)
  800981:	a1 60 30 80 00       	mov    0x803060,%eax
  800986:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  80098c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80098f:	39 c2                	cmp    %eax,%edx
  800991:	77 c8                	ja     80095b <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800993:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800996:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800999:	74 14                	je     8009af <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  80099b:	83 ec 04             	sub    $0x4,%esp
  80099e:	68 ec 27 80 00       	push   $0x8027ec
  8009a3:	6a 44                	push   $0x44
  8009a5:	68 8c 27 80 00       	push   $0x80278c
  8009aa:	e8 15 fe ff ff       	call   8007c4 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8009af:	90                   	nop
  8009b0:	c9                   	leave  
  8009b1:	c3                   	ret    

008009b2 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  8009b2:	55                   	push   %ebp
  8009b3:	89 e5                	mov    %esp,%ebp
  8009b5:	53                   	push   %ebx
  8009b6:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  8009b9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009bc:	8b 00                	mov    (%eax),%eax
  8009be:	8d 48 01             	lea    0x1(%eax),%ecx
  8009c1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009c4:	89 0a                	mov    %ecx,(%edx)
  8009c6:	8b 55 08             	mov    0x8(%ebp),%edx
  8009c9:	88 d1                	mov    %dl,%cl
  8009cb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009ce:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8009d2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009d5:	8b 00                	mov    (%eax),%eax
  8009d7:	3d ff 00 00 00       	cmp    $0xff,%eax
  8009dc:	75 30                	jne    800a0e <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  8009de:	8b 15 5c b1 81 00    	mov    0x81b15c,%edx
  8009e4:	a0 84 30 80 00       	mov    0x803084,%al
  8009e9:	0f b6 c0             	movzbl %al,%eax
  8009ec:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8009ef:	8b 09                	mov    (%ecx),%ecx
  8009f1:	89 cb                	mov    %ecx,%ebx
  8009f3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8009f6:	83 c1 08             	add    $0x8,%ecx
  8009f9:	52                   	push   %edx
  8009fa:	50                   	push   %eax
  8009fb:	53                   	push   %ebx
  8009fc:	51                   	push   %ecx
  8009fd:	e8 a0 0f 00 00       	call   8019a2 <sys_cputs>
  800a02:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800a05:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a08:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800a0e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a11:	8b 40 04             	mov    0x4(%eax),%eax
  800a14:	8d 50 01             	lea    0x1(%eax),%edx
  800a17:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a1a:	89 50 04             	mov    %edx,0x4(%eax)
}
  800a1d:	90                   	nop
  800a1e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800a21:	c9                   	leave  
  800a22:	c3                   	ret    

00800a23 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800a23:	55                   	push   %ebp
  800a24:	89 e5                	mov    %esp,%ebp
  800a26:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800a2c:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800a33:	00 00 00 
	b.cnt = 0;
  800a36:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800a3d:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800a40:	ff 75 0c             	pushl  0xc(%ebp)
  800a43:	ff 75 08             	pushl  0x8(%ebp)
  800a46:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800a4c:	50                   	push   %eax
  800a4d:	68 b2 09 80 00       	push   $0x8009b2
  800a52:	e8 5a 02 00 00       	call   800cb1 <vprintfmt>
  800a57:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  800a5a:	8b 15 5c b1 81 00    	mov    0x81b15c,%edx
  800a60:	a0 84 30 80 00       	mov    0x803084,%al
  800a65:	0f b6 c0             	movzbl %al,%eax
  800a68:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  800a6e:	52                   	push   %edx
  800a6f:	50                   	push   %eax
  800a70:	51                   	push   %ecx
  800a71:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800a77:	83 c0 08             	add    $0x8,%eax
  800a7a:	50                   	push   %eax
  800a7b:	e8 22 0f 00 00       	call   8019a2 <sys_cputs>
  800a80:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800a83:	c6 05 84 30 80 00 00 	movb   $0x0,0x803084
	return b.cnt;
  800a8a:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800a90:	c9                   	leave  
  800a91:	c3                   	ret    

00800a92 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  800a92:	55                   	push   %ebp
  800a93:	89 e5                	mov    %esp,%ebp
  800a95:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800a98:	c6 05 84 30 80 00 01 	movb   $0x1,0x803084
	va_start(ap, fmt);
  800a9f:	8d 45 0c             	lea    0xc(%ebp),%eax
  800aa2:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800aa5:	8b 45 08             	mov    0x8(%ebp),%eax
  800aa8:	83 ec 08             	sub    $0x8,%esp
  800aab:	ff 75 f4             	pushl  -0xc(%ebp)
  800aae:	50                   	push   %eax
  800aaf:	e8 6f ff ff ff       	call   800a23 <vcprintf>
  800ab4:	83 c4 10             	add    $0x10,%esp
  800ab7:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800aba:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800abd:	c9                   	leave  
  800abe:	c3                   	ret    

00800abf <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  800abf:	55                   	push   %ebp
  800ac0:	89 e5                	mov    %esp,%ebp
  800ac2:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800ac5:	c6 05 84 30 80 00 01 	movb   $0x1,0x803084
	curTextClr = (textClr << 8) ; //set text color by the given value
  800acc:	8b 45 08             	mov    0x8(%ebp),%eax
  800acf:	c1 e0 08             	shl    $0x8,%eax
  800ad2:	a3 5c b1 81 00       	mov    %eax,0x81b15c
	va_start(ap, fmt);
  800ad7:	8d 45 0c             	lea    0xc(%ebp),%eax
  800ada:	83 c0 04             	add    $0x4,%eax
  800add:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800ae0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ae3:	83 ec 08             	sub    $0x8,%esp
  800ae6:	ff 75 f4             	pushl  -0xc(%ebp)
  800ae9:	50                   	push   %eax
  800aea:	e8 34 ff ff ff       	call   800a23 <vcprintf>
  800aef:	83 c4 10             	add    $0x10,%esp
  800af2:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  800af5:	c7 05 5c b1 81 00 00 	movl   $0x700,0x81b15c
  800afc:	07 00 00 

	return cnt;
  800aff:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800b02:	c9                   	leave  
  800b03:	c3                   	ret    

00800b04 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  800b04:	55                   	push   %ebp
  800b05:	89 e5                	mov    %esp,%ebp
  800b07:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  800b0a:	e8 d7 0e 00 00       	call   8019e6 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  800b0f:	8d 45 0c             	lea    0xc(%ebp),%eax
  800b12:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  800b15:	8b 45 08             	mov    0x8(%ebp),%eax
  800b18:	83 ec 08             	sub    $0x8,%esp
  800b1b:	ff 75 f4             	pushl  -0xc(%ebp)
  800b1e:	50                   	push   %eax
  800b1f:	e8 ff fe ff ff       	call   800a23 <vcprintf>
  800b24:	83 c4 10             	add    $0x10,%esp
  800b27:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  800b2a:	e8 d1 0e 00 00       	call   801a00 <sys_unlock_cons>
	return cnt;
  800b2f:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800b32:	c9                   	leave  
  800b33:	c3                   	ret    

00800b34 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800b34:	55                   	push   %ebp
  800b35:	89 e5                	mov    %esp,%ebp
  800b37:	53                   	push   %ebx
  800b38:	83 ec 14             	sub    $0x14,%esp
  800b3b:	8b 45 10             	mov    0x10(%ebp),%eax
  800b3e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b41:	8b 45 14             	mov    0x14(%ebp),%eax
  800b44:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800b47:	8b 45 18             	mov    0x18(%ebp),%eax
  800b4a:	ba 00 00 00 00       	mov    $0x0,%edx
  800b4f:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800b52:	77 55                	ja     800ba9 <printnum+0x75>
  800b54:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800b57:	72 05                	jb     800b5e <printnum+0x2a>
  800b59:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800b5c:	77 4b                	ja     800ba9 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800b5e:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800b61:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800b64:	8b 45 18             	mov    0x18(%ebp),%eax
  800b67:	ba 00 00 00 00       	mov    $0x0,%edx
  800b6c:	52                   	push   %edx
  800b6d:	50                   	push   %eax
  800b6e:	ff 75 f4             	pushl  -0xc(%ebp)
  800b71:	ff 75 f0             	pushl  -0x10(%ebp)
  800b74:	e8 ab 13 00 00       	call   801f24 <__udivdi3>
  800b79:	83 c4 10             	add    $0x10,%esp
  800b7c:	83 ec 04             	sub    $0x4,%esp
  800b7f:	ff 75 20             	pushl  0x20(%ebp)
  800b82:	53                   	push   %ebx
  800b83:	ff 75 18             	pushl  0x18(%ebp)
  800b86:	52                   	push   %edx
  800b87:	50                   	push   %eax
  800b88:	ff 75 0c             	pushl  0xc(%ebp)
  800b8b:	ff 75 08             	pushl  0x8(%ebp)
  800b8e:	e8 a1 ff ff ff       	call   800b34 <printnum>
  800b93:	83 c4 20             	add    $0x20,%esp
  800b96:	eb 1a                	jmp    800bb2 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800b98:	83 ec 08             	sub    $0x8,%esp
  800b9b:	ff 75 0c             	pushl  0xc(%ebp)
  800b9e:	ff 75 20             	pushl  0x20(%ebp)
  800ba1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ba4:	ff d0                	call   *%eax
  800ba6:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800ba9:	ff 4d 1c             	decl   0x1c(%ebp)
  800bac:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800bb0:	7f e6                	jg     800b98 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800bb2:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800bb5:	bb 00 00 00 00       	mov    $0x0,%ebx
  800bba:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800bbd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800bc0:	53                   	push   %ebx
  800bc1:	51                   	push   %ecx
  800bc2:	52                   	push   %edx
  800bc3:	50                   	push   %eax
  800bc4:	e8 6b 14 00 00       	call   802034 <__umoddi3>
  800bc9:	83 c4 10             	add    $0x10,%esp
  800bcc:	05 54 2a 80 00       	add    $0x802a54,%eax
  800bd1:	8a 00                	mov    (%eax),%al
  800bd3:	0f be c0             	movsbl %al,%eax
  800bd6:	83 ec 08             	sub    $0x8,%esp
  800bd9:	ff 75 0c             	pushl  0xc(%ebp)
  800bdc:	50                   	push   %eax
  800bdd:	8b 45 08             	mov    0x8(%ebp),%eax
  800be0:	ff d0                	call   *%eax
  800be2:	83 c4 10             	add    $0x10,%esp
}
  800be5:	90                   	nop
  800be6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800be9:	c9                   	leave  
  800bea:	c3                   	ret    

00800beb <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800beb:	55                   	push   %ebp
  800bec:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800bee:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800bf2:	7e 1c                	jle    800c10 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800bf4:	8b 45 08             	mov    0x8(%ebp),%eax
  800bf7:	8b 00                	mov    (%eax),%eax
  800bf9:	8d 50 08             	lea    0x8(%eax),%edx
  800bfc:	8b 45 08             	mov    0x8(%ebp),%eax
  800bff:	89 10                	mov    %edx,(%eax)
  800c01:	8b 45 08             	mov    0x8(%ebp),%eax
  800c04:	8b 00                	mov    (%eax),%eax
  800c06:	83 e8 08             	sub    $0x8,%eax
  800c09:	8b 50 04             	mov    0x4(%eax),%edx
  800c0c:	8b 00                	mov    (%eax),%eax
  800c0e:	eb 40                	jmp    800c50 <getuint+0x65>
	else if (lflag)
  800c10:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c14:	74 1e                	je     800c34 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800c16:	8b 45 08             	mov    0x8(%ebp),%eax
  800c19:	8b 00                	mov    (%eax),%eax
  800c1b:	8d 50 04             	lea    0x4(%eax),%edx
  800c1e:	8b 45 08             	mov    0x8(%ebp),%eax
  800c21:	89 10                	mov    %edx,(%eax)
  800c23:	8b 45 08             	mov    0x8(%ebp),%eax
  800c26:	8b 00                	mov    (%eax),%eax
  800c28:	83 e8 04             	sub    $0x4,%eax
  800c2b:	8b 00                	mov    (%eax),%eax
  800c2d:	ba 00 00 00 00       	mov    $0x0,%edx
  800c32:	eb 1c                	jmp    800c50 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800c34:	8b 45 08             	mov    0x8(%ebp),%eax
  800c37:	8b 00                	mov    (%eax),%eax
  800c39:	8d 50 04             	lea    0x4(%eax),%edx
  800c3c:	8b 45 08             	mov    0x8(%ebp),%eax
  800c3f:	89 10                	mov    %edx,(%eax)
  800c41:	8b 45 08             	mov    0x8(%ebp),%eax
  800c44:	8b 00                	mov    (%eax),%eax
  800c46:	83 e8 04             	sub    $0x4,%eax
  800c49:	8b 00                	mov    (%eax),%eax
  800c4b:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800c50:	5d                   	pop    %ebp
  800c51:	c3                   	ret    

00800c52 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800c52:	55                   	push   %ebp
  800c53:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800c55:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800c59:	7e 1c                	jle    800c77 <getint+0x25>
		return va_arg(*ap, long long);
  800c5b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c5e:	8b 00                	mov    (%eax),%eax
  800c60:	8d 50 08             	lea    0x8(%eax),%edx
  800c63:	8b 45 08             	mov    0x8(%ebp),%eax
  800c66:	89 10                	mov    %edx,(%eax)
  800c68:	8b 45 08             	mov    0x8(%ebp),%eax
  800c6b:	8b 00                	mov    (%eax),%eax
  800c6d:	83 e8 08             	sub    $0x8,%eax
  800c70:	8b 50 04             	mov    0x4(%eax),%edx
  800c73:	8b 00                	mov    (%eax),%eax
  800c75:	eb 38                	jmp    800caf <getint+0x5d>
	else if (lflag)
  800c77:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c7b:	74 1a                	je     800c97 <getint+0x45>
		return va_arg(*ap, long);
  800c7d:	8b 45 08             	mov    0x8(%ebp),%eax
  800c80:	8b 00                	mov    (%eax),%eax
  800c82:	8d 50 04             	lea    0x4(%eax),%edx
  800c85:	8b 45 08             	mov    0x8(%ebp),%eax
  800c88:	89 10                	mov    %edx,(%eax)
  800c8a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c8d:	8b 00                	mov    (%eax),%eax
  800c8f:	83 e8 04             	sub    $0x4,%eax
  800c92:	8b 00                	mov    (%eax),%eax
  800c94:	99                   	cltd   
  800c95:	eb 18                	jmp    800caf <getint+0x5d>
	else
		return va_arg(*ap, int);
  800c97:	8b 45 08             	mov    0x8(%ebp),%eax
  800c9a:	8b 00                	mov    (%eax),%eax
  800c9c:	8d 50 04             	lea    0x4(%eax),%edx
  800c9f:	8b 45 08             	mov    0x8(%ebp),%eax
  800ca2:	89 10                	mov    %edx,(%eax)
  800ca4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ca7:	8b 00                	mov    (%eax),%eax
  800ca9:	83 e8 04             	sub    $0x4,%eax
  800cac:	8b 00                	mov    (%eax),%eax
  800cae:	99                   	cltd   
}
  800caf:	5d                   	pop    %ebp
  800cb0:	c3                   	ret    

00800cb1 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800cb1:	55                   	push   %ebp
  800cb2:	89 e5                	mov    %esp,%ebp
  800cb4:	56                   	push   %esi
  800cb5:	53                   	push   %ebx
  800cb6:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800cb9:	eb 17                	jmp    800cd2 <vprintfmt+0x21>
			if (ch == '\0')
  800cbb:	85 db                	test   %ebx,%ebx
  800cbd:	0f 84 c1 03 00 00    	je     801084 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  800cc3:	83 ec 08             	sub    $0x8,%esp
  800cc6:	ff 75 0c             	pushl  0xc(%ebp)
  800cc9:	53                   	push   %ebx
  800cca:	8b 45 08             	mov    0x8(%ebp),%eax
  800ccd:	ff d0                	call   *%eax
  800ccf:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800cd2:	8b 45 10             	mov    0x10(%ebp),%eax
  800cd5:	8d 50 01             	lea    0x1(%eax),%edx
  800cd8:	89 55 10             	mov    %edx,0x10(%ebp)
  800cdb:	8a 00                	mov    (%eax),%al
  800cdd:	0f b6 d8             	movzbl %al,%ebx
  800ce0:	83 fb 25             	cmp    $0x25,%ebx
  800ce3:	75 d6                	jne    800cbb <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800ce5:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800ce9:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800cf0:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800cf7:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800cfe:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800d05:	8b 45 10             	mov    0x10(%ebp),%eax
  800d08:	8d 50 01             	lea    0x1(%eax),%edx
  800d0b:	89 55 10             	mov    %edx,0x10(%ebp)
  800d0e:	8a 00                	mov    (%eax),%al
  800d10:	0f b6 d8             	movzbl %al,%ebx
  800d13:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800d16:	83 f8 5b             	cmp    $0x5b,%eax
  800d19:	0f 87 3d 03 00 00    	ja     80105c <vprintfmt+0x3ab>
  800d1f:	8b 04 85 78 2a 80 00 	mov    0x802a78(,%eax,4),%eax
  800d26:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800d28:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800d2c:	eb d7                	jmp    800d05 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800d2e:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800d32:	eb d1                	jmp    800d05 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800d34:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800d3b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800d3e:	89 d0                	mov    %edx,%eax
  800d40:	c1 e0 02             	shl    $0x2,%eax
  800d43:	01 d0                	add    %edx,%eax
  800d45:	01 c0                	add    %eax,%eax
  800d47:	01 d8                	add    %ebx,%eax
  800d49:	83 e8 30             	sub    $0x30,%eax
  800d4c:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800d4f:	8b 45 10             	mov    0x10(%ebp),%eax
  800d52:	8a 00                	mov    (%eax),%al
  800d54:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800d57:	83 fb 2f             	cmp    $0x2f,%ebx
  800d5a:	7e 3e                	jle    800d9a <vprintfmt+0xe9>
  800d5c:	83 fb 39             	cmp    $0x39,%ebx
  800d5f:	7f 39                	jg     800d9a <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800d61:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800d64:	eb d5                	jmp    800d3b <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800d66:	8b 45 14             	mov    0x14(%ebp),%eax
  800d69:	83 c0 04             	add    $0x4,%eax
  800d6c:	89 45 14             	mov    %eax,0x14(%ebp)
  800d6f:	8b 45 14             	mov    0x14(%ebp),%eax
  800d72:	83 e8 04             	sub    $0x4,%eax
  800d75:	8b 00                	mov    (%eax),%eax
  800d77:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800d7a:	eb 1f                	jmp    800d9b <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800d7c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800d80:	79 83                	jns    800d05 <vprintfmt+0x54>
				width = 0;
  800d82:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800d89:	e9 77 ff ff ff       	jmp    800d05 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800d8e:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800d95:	e9 6b ff ff ff       	jmp    800d05 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800d9a:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800d9b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800d9f:	0f 89 60 ff ff ff    	jns    800d05 <vprintfmt+0x54>
				width = precision, precision = -1;
  800da5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800da8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800dab:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800db2:	e9 4e ff ff ff       	jmp    800d05 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800db7:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800dba:	e9 46 ff ff ff       	jmp    800d05 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800dbf:	8b 45 14             	mov    0x14(%ebp),%eax
  800dc2:	83 c0 04             	add    $0x4,%eax
  800dc5:	89 45 14             	mov    %eax,0x14(%ebp)
  800dc8:	8b 45 14             	mov    0x14(%ebp),%eax
  800dcb:	83 e8 04             	sub    $0x4,%eax
  800dce:	8b 00                	mov    (%eax),%eax
  800dd0:	83 ec 08             	sub    $0x8,%esp
  800dd3:	ff 75 0c             	pushl  0xc(%ebp)
  800dd6:	50                   	push   %eax
  800dd7:	8b 45 08             	mov    0x8(%ebp),%eax
  800dda:	ff d0                	call   *%eax
  800ddc:	83 c4 10             	add    $0x10,%esp
			break;
  800ddf:	e9 9b 02 00 00       	jmp    80107f <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800de4:	8b 45 14             	mov    0x14(%ebp),%eax
  800de7:	83 c0 04             	add    $0x4,%eax
  800dea:	89 45 14             	mov    %eax,0x14(%ebp)
  800ded:	8b 45 14             	mov    0x14(%ebp),%eax
  800df0:	83 e8 04             	sub    $0x4,%eax
  800df3:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800df5:	85 db                	test   %ebx,%ebx
  800df7:	79 02                	jns    800dfb <vprintfmt+0x14a>
				err = -err;
  800df9:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800dfb:	83 fb 64             	cmp    $0x64,%ebx
  800dfe:	7f 0b                	jg     800e0b <vprintfmt+0x15a>
  800e00:	8b 34 9d c0 28 80 00 	mov    0x8028c0(,%ebx,4),%esi
  800e07:	85 f6                	test   %esi,%esi
  800e09:	75 19                	jne    800e24 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800e0b:	53                   	push   %ebx
  800e0c:	68 65 2a 80 00       	push   $0x802a65
  800e11:	ff 75 0c             	pushl  0xc(%ebp)
  800e14:	ff 75 08             	pushl  0x8(%ebp)
  800e17:	e8 70 02 00 00       	call   80108c <printfmt>
  800e1c:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800e1f:	e9 5b 02 00 00       	jmp    80107f <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800e24:	56                   	push   %esi
  800e25:	68 6e 2a 80 00       	push   $0x802a6e
  800e2a:	ff 75 0c             	pushl  0xc(%ebp)
  800e2d:	ff 75 08             	pushl  0x8(%ebp)
  800e30:	e8 57 02 00 00       	call   80108c <printfmt>
  800e35:	83 c4 10             	add    $0x10,%esp
			break;
  800e38:	e9 42 02 00 00       	jmp    80107f <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800e3d:	8b 45 14             	mov    0x14(%ebp),%eax
  800e40:	83 c0 04             	add    $0x4,%eax
  800e43:	89 45 14             	mov    %eax,0x14(%ebp)
  800e46:	8b 45 14             	mov    0x14(%ebp),%eax
  800e49:	83 e8 04             	sub    $0x4,%eax
  800e4c:	8b 30                	mov    (%eax),%esi
  800e4e:	85 f6                	test   %esi,%esi
  800e50:	75 05                	jne    800e57 <vprintfmt+0x1a6>
				p = "(null)";
  800e52:	be 71 2a 80 00       	mov    $0x802a71,%esi
			if (width > 0 && padc != '-')
  800e57:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800e5b:	7e 6d                	jle    800eca <vprintfmt+0x219>
  800e5d:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800e61:	74 67                	je     800eca <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800e63:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800e66:	83 ec 08             	sub    $0x8,%esp
  800e69:	50                   	push   %eax
  800e6a:	56                   	push   %esi
  800e6b:	e8 1e 03 00 00       	call   80118e <strnlen>
  800e70:	83 c4 10             	add    $0x10,%esp
  800e73:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800e76:	eb 16                	jmp    800e8e <vprintfmt+0x1dd>
					putch(padc, putdat);
  800e78:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800e7c:	83 ec 08             	sub    $0x8,%esp
  800e7f:	ff 75 0c             	pushl  0xc(%ebp)
  800e82:	50                   	push   %eax
  800e83:	8b 45 08             	mov    0x8(%ebp),%eax
  800e86:	ff d0                	call   *%eax
  800e88:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800e8b:	ff 4d e4             	decl   -0x1c(%ebp)
  800e8e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800e92:	7f e4                	jg     800e78 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800e94:	eb 34                	jmp    800eca <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800e96:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800e9a:	74 1c                	je     800eb8 <vprintfmt+0x207>
  800e9c:	83 fb 1f             	cmp    $0x1f,%ebx
  800e9f:	7e 05                	jle    800ea6 <vprintfmt+0x1f5>
  800ea1:	83 fb 7e             	cmp    $0x7e,%ebx
  800ea4:	7e 12                	jle    800eb8 <vprintfmt+0x207>
					putch('?', putdat);
  800ea6:	83 ec 08             	sub    $0x8,%esp
  800ea9:	ff 75 0c             	pushl  0xc(%ebp)
  800eac:	6a 3f                	push   $0x3f
  800eae:	8b 45 08             	mov    0x8(%ebp),%eax
  800eb1:	ff d0                	call   *%eax
  800eb3:	83 c4 10             	add    $0x10,%esp
  800eb6:	eb 0f                	jmp    800ec7 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800eb8:	83 ec 08             	sub    $0x8,%esp
  800ebb:	ff 75 0c             	pushl  0xc(%ebp)
  800ebe:	53                   	push   %ebx
  800ebf:	8b 45 08             	mov    0x8(%ebp),%eax
  800ec2:	ff d0                	call   *%eax
  800ec4:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800ec7:	ff 4d e4             	decl   -0x1c(%ebp)
  800eca:	89 f0                	mov    %esi,%eax
  800ecc:	8d 70 01             	lea    0x1(%eax),%esi
  800ecf:	8a 00                	mov    (%eax),%al
  800ed1:	0f be d8             	movsbl %al,%ebx
  800ed4:	85 db                	test   %ebx,%ebx
  800ed6:	74 24                	je     800efc <vprintfmt+0x24b>
  800ed8:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800edc:	78 b8                	js     800e96 <vprintfmt+0x1e5>
  800ede:	ff 4d e0             	decl   -0x20(%ebp)
  800ee1:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800ee5:	79 af                	jns    800e96 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800ee7:	eb 13                	jmp    800efc <vprintfmt+0x24b>
				putch(' ', putdat);
  800ee9:	83 ec 08             	sub    $0x8,%esp
  800eec:	ff 75 0c             	pushl  0xc(%ebp)
  800eef:	6a 20                	push   $0x20
  800ef1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef4:	ff d0                	call   *%eax
  800ef6:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800ef9:	ff 4d e4             	decl   -0x1c(%ebp)
  800efc:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800f00:	7f e7                	jg     800ee9 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800f02:	e9 78 01 00 00       	jmp    80107f <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800f07:	83 ec 08             	sub    $0x8,%esp
  800f0a:	ff 75 e8             	pushl  -0x18(%ebp)
  800f0d:	8d 45 14             	lea    0x14(%ebp),%eax
  800f10:	50                   	push   %eax
  800f11:	e8 3c fd ff ff       	call   800c52 <getint>
  800f16:	83 c4 10             	add    $0x10,%esp
  800f19:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f1c:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800f1f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800f22:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f25:	85 d2                	test   %edx,%edx
  800f27:	79 23                	jns    800f4c <vprintfmt+0x29b>
				putch('-', putdat);
  800f29:	83 ec 08             	sub    $0x8,%esp
  800f2c:	ff 75 0c             	pushl  0xc(%ebp)
  800f2f:	6a 2d                	push   $0x2d
  800f31:	8b 45 08             	mov    0x8(%ebp),%eax
  800f34:	ff d0                	call   *%eax
  800f36:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800f39:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800f3c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f3f:	f7 d8                	neg    %eax
  800f41:	83 d2 00             	adc    $0x0,%edx
  800f44:	f7 da                	neg    %edx
  800f46:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f49:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800f4c:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800f53:	e9 bc 00 00 00       	jmp    801014 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800f58:	83 ec 08             	sub    $0x8,%esp
  800f5b:	ff 75 e8             	pushl  -0x18(%ebp)
  800f5e:	8d 45 14             	lea    0x14(%ebp),%eax
  800f61:	50                   	push   %eax
  800f62:	e8 84 fc ff ff       	call   800beb <getuint>
  800f67:	83 c4 10             	add    $0x10,%esp
  800f6a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f6d:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800f70:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800f77:	e9 98 00 00 00       	jmp    801014 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800f7c:	83 ec 08             	sub    $0x8,%esp
  800f7f:	ff 75 0c             	pushl  0xc(%ebp)
  800f82:	6a 58                	push   $0x58
  800f84:	8b 45 08             	mov    0x8(%ebp),%eax
  800f87:	ff d0                	call   *%eax
  800f89:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800f8c:	83 ec 08             	sub    $0x8,%esp
  800f8f:	ff 75 0c             	pushl  0xc(%ebp)
  800f92:	6a 58                	push   $0x58
  800f94:	8b 45 08             	mov    0x8(%ebp),%eax
  800f97:	ff d0                	call   *%eax
  800f99:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800f9c:	83 ec 08             	sub    $0x8,%esp
  800f9f:	ff 75 0c             	pushl  0xc(%ebp)
  800fa2:	6a 58                	push   $0x58
  800fa4:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa7:	ff d0                	call   *%eax
  800fa9:	83 c4 10             	add    $0x10,%esp
			break;
  800fac:	e9 ce 00 00 00       	jmp    80107f <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800fb1:	83 ec 08             	sub    $0x8,%esp
  800fb4:	ff 75 0c             	pushl  0xc(%ebp)
  800fb7:	6a 30                	push   $0x30
  800fb9:	8b 45 08             	mov    0x8(%ebp),%eax
  800fbc:	ff d0                	call   *%eax
  800fbe:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800fc1:	83 ec 08             	sub    $0x8,%esp
  800fc4:	ff 75 0c             	pushl  0xc(%ebp)
  800fc7:	6a 78                	push   $0x78
  800fc9:	8b 45 08             	mov    0x8(%ebp),%eax
  800fcc:	ff d0                	call   *%eax
  800fce:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800fd1:	8b 45 14             	mov    0x14(%ebp),%eax
  800fd4:	83 c0 04             	add    $0x4,%eax
  800fd7:	89 45 14             	mov    %eax,0x14(%ebp)
  800fda:	8b 45 14             	mov    0x14(%ebp),%eax
  800fdd:	83 e8 04             	sub    $0x4,%eax
  800fe0:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800fe2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800fe5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800fec:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800ff3:	eb 1f                	jmp    801014 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800ff5:	83 ec 08             	sub    $0x8,%esp
  800ff8:	ff 75 e8             	pushl  -0x18(%ebp)
  800ffb:	8d 45 14             	lea    0x14(%ebp),%eax
  800ffe:	50                   	push   %eax
  800fff:	e8 e7 fb ff ff       	call   800beb <getuint>
  801004:	83 c4 10             	add    $0x10,%esp
  801007:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80100a:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  80100d:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  801014:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  801018:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80101b:	83 ec 04             	sub    $0x4,%esp
  80101e:	52                   	push   %edx
  80101f:	ff 75 e4             	pushl  -0x1c(%ebp)
  801022:	50                   	push   %eax
  801023:	ff 75 f4             	pushl  -0xc(%ebp)
  801026:	ff 75 f0             	pushl  -0x10(%ebp)
  801029:	ff 75 0c             	pushl  0xc(%ebp)
  80102c:	ff 75 08             	pushl  0x8(%ebp)
  80102f:	e8 00 fb ff ff       	call   800b34 <printnum>
  801034:	83 c4 20             	add    $0x20,%esp
			break;
  801037:	eb 46                	jmp    80107f <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  801039:	83 ec 08             	sub    $0x8,%esp
  80103c:	ff 75 0c             	pushl  0xc(%ebp)
  80103f:	53                   	push   %ebx
  801040:	8b 45 08             	mov    0x8(%ebp),%eax
  801043:	ff d0                	call   *%eax
  801045:	83 c4 10             	add    $0x10,%esp
			break;
  801048:	eb 35                	jmp    80107f <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  80104a:	c6 05 84 30 80 00 00 	movb   $0x0,0x803084
			break;
  801051:	eb 2c                	jmp    80107f <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  801053:	c6 05 84 30 80 00 01 	movb   $0x1,0x803084
			break;
  80105a:	eb 23                	jmp    80107f <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  80105c:	83 ec 08             	sub    $0x8,%esp
  80105f:	ff 75 0c             	pushl  0xc(%ebp)
  801062:	6a 25                	push   $0x25
  801064:	8b 45 08             	mov    0x8(%ebp),%eax
  801067:	ff d0                	call   *%eax
  801069:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  80106c:	ff 4d 10             	decl   0x10(%ebp)
  80106f:	eb 03                	jmp    801074 <vprintfmt+0x3c3>
  801071:	ff 4d 10             	decl   0x10(%ebp)
  801074:	8b 45 10             	mov    0x10(%ebp),%eax
  801077:	48                   	dec    %eax
  801078:	8a 00                	mov    (%eax),%al
  80107a:	3c 25                	cmp    $0x25,%al
  80107c:	75 f3                	jne    801071 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  80107e:	90                   	nop
		}
	}
  80107f:	e9 35 fc ff ff       	jmp    800cb9 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  801084:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  801085:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801088:	5b                   	pop    %ebx
  801089:	5e                   	pop    %esi
  80108a:	5d                   	pop    %ebp
  80108b:	c3                   	ret    

0080108c <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  80108c:	55                   	push   %ebp
  80108d:	89 e5                	mov    %esp,%ebp
  80108f:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  801092:	8d 45 10             	lea    0x10(%ebp),%eax
  801095:	83 c0 04             	add    $0x4,%eax
  801098:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  80109b:	8b 45 10             	mov    0x10(%ebp),%eax
  80109e:	ff 75 f4             	pushl  -0xc(%ebp)
  8010a1:	50                   	push   %eax
  8010a2:	ff 75 0c             	pushl  0xc(%ebp)
  8010a5:	ff 75 08             	pushl  0x8(%ebp)
  8010a8:	e8 04 fc ff ff       	call   800cb1 <vprintfmt>
  8010ad:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  8010b0:	90                   	nop
  8010b1:	c9                   	leave  
  8010b2:	c3                   	ret    

008010b3 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8010b3:	55                   	push   %ebp
  8010b4:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  8010b6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010b9:	8b 40 08             	mov    0x8(%eax),%eax
  8010bc:	8d 50 01             	lea    0x1(%eax),%edx
  8010bf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010c2:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  8010c5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010c8:	8b 10                	mov    (%eax),%edx
  8010ca:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010cd:	8b 40 04             	mov    0x4(%eax),%eax
  8010d0:	39 c2                	cmp    %eax,%edx
  8010d2:	73 12                	jae    8010e6 <sprintputch+0x33>
		*b->buf++ = ch;
  8010d4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010d7:	8b 00                	mov    (%eax),%eax
  8010d9:	8d 48 01             	lea    0x1(%eax),%ecx
  8010dc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010df:	89 0a                	mov    %ecx,(%edx)
  8010e1:	8b 55 08             	mov    0x8(%ebp),%edx
  8010e4:	88 10                	mov    %dl,(%eax)
}
  8010e6:	90                   	nop
  8010e7:	5d                   	pop    %ebp
  8010e8:	c3                   	ret    

008010e9 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8010e9:	55                   	push   %ebp
  8010ea:	89 e5                	mov    %esp,%ebp
  8010ec:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  8010ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8010f2:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8010f5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010f8:	8d 50 ff             	lea    -0x1(%eax),%edx
  8010fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8010fe:	01 d0                	add    %edx,%eax
  801100:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801103:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80110a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80110e:	74 06                	je     801116 <vsnprintf+0x2d>
  801110:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801114:	7f 07                	jg     80111d <vsnprintf+0x34>
		return -E_INVAL;
  801116:	b8 03 00 00 00       	mov    $0x3,%eax
  80111b:	eb 20                	jmp    80113d <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80111d:	ff 75 14             	pushl  0x14(%ebp)
  801120:	ff 75 10             	pushl  0x10(%ebp)
  801123:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801126:	50                   	push   %eax
  801127:	68 b3 10 80 00       	push   $0x8010b3
  80112c:	e8 80 fb ff ff       	call   800cb1 <vprintfmt>
  801131:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  801134:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801137:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  80113a:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80113d:	c9                   	leave  
  80113e:	c3                   	ret    

0080113f <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80113f:	55                   	push   %ebp
  801140:	89 e5                	mov    %esp,%ebp
  801142:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801145:	8d 45 10             	lea    0x10(%ebp),%eax
  801148:	83 c0 04             	add    $0x4,%eax
  80114b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  80114e:	8b 45 10             	mov    0x10(%ebp),%eax
  801151:	ff 75 f4             	pushl  -0xc(%ebp)
  801154:	50                   	push   %eax
  801155:	ff 75 0c             	pushl  0xc(%ebp)
  801158:	ff 75 08             	pushl  0x8(%ebp)
  80115b:	e8 89 ff ff ff       	call   8010e9 <vsnprintf>
  801160:	83 c4 10             	add    $0x10,%esp
  801163:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  801166:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801169:	c9                   	leave  
  80116a:	c3                   	ret    

0080116b <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  80116b:	55                   	push   %ebp
  80116c:	89 e5                	mov    %esp,%ebp
  80116e:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  801171:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801178:	eb 06                	jmp    801180 <strlen+0x15>
		n++;
  80117a:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  80117d:	ff 45 08             	incl   0x8(%ebp)
  801180:	8b 45 08             	mov    0x8(%ebp),%eax
  801183:	8a 00                	mov    (%eax),%al
  801185:	84 c0                	test   %al,%al
  801187:	75 f1                	jne    80117a <strlen+0xf>
		n++;
	return n;
  801189:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80118c:	c9                   	leave  
  80118d:	c3                   	ret    

0080118e <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  80118e:	55                   	push   %ebp
  80118f:	89 e5                	mov    %esp,%ebp
  801191:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801194:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80119b:	eb 09                	jmp    8011a6 <strnlen+0x18>
		n++;
  80119d:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8011a0:	ff 45 08             	incl   0x8(%ebp)
  8011a3:	ff 4d 0c             	decl   0xc(%ebp)
  8011a6:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8011aa:	74 09                	je     8011b5 <strnlen+0x27>
  8011ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8011af:	8a 00                	mov    (%eax),%al
  8011b1:	84 c0                	test   %al,%al
  8011b3:	75 e8                	jne    80119d <strnlen+0xf>
		n++;
	return n;
  8011b5:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8011b8:	c9                   	leave  
  8011b9:	c3                   	ret    

008011ba <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8011ba:	55                   	push   %ebp
  8011bb:	89 e5                	mov    %esp,%ebp
  8011bd:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  8011c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8011c3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  8011c6:	90                   	nop
  8011c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ca:	8d 50 01             	lea    0x1(%eax),%edx
  8011cd:	89 55 08             	mov    %edx,0x8(%ebp)
  8011d0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8011d3:	8d 4a 01             	lea    0x1(%edx),%ecx
  8011d6:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8011d9:	8a 12                	mov    (%edx),%dl
  8011db:	88 10                	mov    %dl,(%eax)
  8011dd:	8a 00                	mov    (%eax),%al
  8011df:	84 c0                	test   %al,%al
  8011e1:	75 e4                	jne    8011c7 <strcpy+0xd>
		/* do nothing */;
	return ret;
  8011e3:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8011e6:	c9                   	leave  
  8011e7:	c3                   	ret    

008011e8 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  8011e8:	55                   	push   %ebp
  8011e9:	89 e5                	mov    %esp,%ebp
  8011eb:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  8011ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8011f1:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  8011f4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8011fb:	eb 1f                	jmp    80121c <strncpy+0x34>
		*dst++ = *src;
  8011fd:	8b 45 08             	mov    0x8(%ebp),%eax
  801200:	8d 50 01             	lea    0x1(%eax),%edx
  801203:	89 55 08             	mov    %edx,0x8(%ebp)
  801206:	8b 55 0c             	mov    0xc(%ebp),%edx
  801209:	8a 12                	mov    (%edx),%dl
  80120b:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  80120d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801210:	8a 00                	mov    (%eax),%al
  801212:	84 c0                	test   %al,%al
  801214:	74 03                	je     801219 <strncpy+0x31>
			src++;
  801216:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801219:	ff 45 fc             	incl   -0x4(%ebp)
  80121c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80121f:	3b 45 10             	cmp    0x10(%ebp),%eax
  801222:	72 d9                	jb     8011fd <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801224:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801227:	c9                   	leave  
  801228:	c3                   	ret    

00801229 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  801229:	55                   	push   %ebp
  80122a:	89 e5                	mov    %esp,%ebp
  80122c:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  80122f:	8b 45 08             	mov    0x8(%ebp),%eax
  801232:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  801235:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801239:	74 30                	je     80126b <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  80123b:	eb 16                	jmp    801253 <strlcpy+0x2a>
			*dst++ = *src++;
  80123d:	8b 45 08             	mov    0x8(%ebp),%eax
  801240:	8d 50 01             	lea    0x1(%eax),%edx
  801243:	89 55 08             	mov    %edx,0x8(%ebp)
  801246:	8b 55 0c             	mov    0xc(%ebp),%edx
  801249:	8d 4a 01             	lea    0x1(%edx),%ecx
  80124c:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  80124f:	8a 12                	mov    (%edx),%dl
  801251:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801253:	ff 4d 10             	decl   0x10(%ebp)
  801256:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80125a:	74 09                	je     801265 <strlcpy+0x3c>
  80125c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80125f:	8a 00                	mov    (%eax),%al
  801261:	84 c0                	test   %al,%al
  801263:	75 d8                	jne    80123d <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  801265:	8b 45 08             	mov    0x8(%ebp),%eax
  801268:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  80126b:	8b 55 08             	mov    0x8(%ebp),%edx
  80126e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801271:	29 c2                	sub    %eax,%edx
  801273:	89 d0                	mov    %edx,%eax
}
  801275:	c9                   	leave  
  801276:	c3                   	ret    

00801277 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801277:	55                   	push   %ebp
  801278:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  80127a:	eb 06                	jmp    801282 <strcmp+0xb>
		p++, q++;
  80127c:	ff 45 08             	incl   0x8(%ebp)
  80127f:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801282:	8b 45 08             	mov    0x8(%ebp),%eax
  801285:	8a 00                	mov    (%eax),%al
  801287:	84 c0                	test   %al,%al
  801289:	74 0e                	je     801299 <strcmp+0x22>
  80128b:	8b 45 08             	mov    0x8(%ebp),%eax
  80128e:	8a 10                	mov    (%eax),%dl
  801290:	8b 45 0c             	mov    0xc(%ebp),%eax
  801293:	8a 00                	mov    (%eax),%al
  801295:	38 c2                	cmp    %al,%dl
  801297:	74 e3                	je     80127c <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801299:	8b 45 08             	mov    0x8(%ebp),%eax
  80129c:	8a 00                	mov    (%eax),%al
  80129e:	0f b6 d0             	movzbl %al,%edx
  8012a1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012a4:	8a 00                	mov    (%eax),%al
  8012a6:	0f b6 c0             	movzbl %al,%eax
  8012a9:	29 c2                	sub    %eax,%edx
  8012ab:	89 d0                	mov    %edx,%eax
}
  8012ad:	5d                   	pop    %ebp
  8012ae:	c3                   	ret    

008012af <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  8012af:	55                   	push   %ebp
  8012b0:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  8012b2:	eb 09                	jmp    8012bd <strncmp+0xe>
		n--, p++, q++;
  8012b4:	ff 4d 10             	decl   0x10(%ebp)
  8012b7:	ff 45 08             	incl   0x8(%ebp)
  8012ba:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  8012bd:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8012c1:	74 17                	je     8012da <strncmp+0x2b>
  8012c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8012c6:	8a 00                	mov    (%eax),%al
  8012c8:	84 c0                	test   %al,%al
  8012ca:	74 0e                	je     8012da <strncmp+0x2b>
  8012cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8012cf:	8a 10                	mov    (%eax),%dl
  8012d1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012d4:	8a 00                	mov    (%eax),%al
  8012d6:	38 c2                	cmp    %al,%dl
  8012d8:	74 da                	je     8012b4 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  8012da:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8012de:	75 07                	jne    8012e7 <strncmp+0x38>
		return 0;
  8012e0:	b8 00 00 00 00       	mov    $0x0,%eax
  8012e5:	eb 14                	jmp    8012fb <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8012e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8012ea:	8a 00                	mov    (%eax),%al
  8012ec:	0f b6 d0             	movzbl %al,%edx
  8012ef:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012f2:	8a 00                	mov    (%eax),%al
  8012f4:	0f b6 c0             	movzbl %al,%eax
  8012f7:	29 c2                	sub    %eax,%edx
  8012f9:	89 d0                	mov    %edx,%eax
}
  8012fb:	5d                   	pop    %ebp
  8012fc:	c3                   	ret    

008012fd <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8012fd:	55                   	push   %ebp
  8012fe:	89 e5                	mov    %esp,%ebp
  801300:	83 ec 04             	sub    $0x4,%esp
  801303:	8b 45 0c             	mov    0xc(%ebp),%eax
  801306:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801309:	eb 12                	jmp    80131d <strchr+0x20>
		if (*s == c)
  80130b:	8b 45 08             	mov    0x8(%ebp),%eax
  80130e:	8a 00                	mov    (%eax),%al
  801310:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801313:	75 05                	jne    80131a <strchr+0x1d>
			return (char *) s;
  801315:	8b 45 08             	mov    0x8(%ebp),%eax
  801318:	eb 11                	jmp    80132b <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  80131a:	ff 45 08             	incl   0x8(%ebp)
  80131d:	8b 45 08             	mov    0x8(%ebp),%eax
  801320:	8a 00                	mov    (%eax),%al
  801322:	84 c0                	test   %al,%al
  801324:	75 e5                	jne    80130b <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  801326:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80132b:	c9                   	leave  
  80132c:	c3                   	ret    

0080132d <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80132d:	55                   	push   %ebp
  80132e:	89 e5                	mov    %esp,%ebp
  801330:	83 ec 04             	sub    $0x4,%esp
  801333:	8b 45 0c             	mov    0xc(%ebp),%eax
  801336:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801339:	eb 0d                	jmp    801348 <strfind+0x1b>
		if (*s == c)
  80133b:	8b 45 08             	mov    0x8(%ebp),%eax
  80133e:	8a 00                	mov    (%eax),%al
  801340:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801343:	74 0e                	je     801353 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801345:	ff 45 08             	incl   0x8(%ebp)
  801348:	8b 45 08             	mov    0x8(%ebp),%eax
  80134b:	8a 00                	mov    (%eax),%al
  80134d:	84 c0                	test   %al,%al
  80134f:	75 ea                	jne    80133b <strfind+0xe>
  801351:	eb 01                	jmp    801354 <strfind+0x27>
		if (*s == c)
			break;
  801353:	90                   	nop
	return (char *) s;
  801354:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801357:	c9                   	leave  
  801358:	c3                   	ret    

00801359 <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  801359:	55                   	push   %ebp
  80135a:	89 e5                	mov    %esp,%ebp
  80135c:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  80135f:	8b 45 08             	mov    0x8(%ebp),%eax
  801362:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  801365:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801369:	76 63                	jbe    8013ce <memset+0x75>
		uint64 data_block = c;
  80136b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80136e:	99                   	cltd   
  80136f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801372:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  801375:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801378:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80137b:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  80137f:	c1 e0 08             	shl    $0x8,%eax
  801382:	09 45 f0             	or     %eax,-0x10(%ebp)
  801385:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  801388:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80138b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80138e:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  801392:	c1 e0 10             	shl    $0x10,%eax
  801395:	09 45 f0             	or     %eax,-0x10(%ebp)
  801398:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  80139b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80139e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8013a1:	89 c2                	mov    %eax,%edx
  8013a3:	b8 00 00 00 00       	mov    $0x0,%eax
  8013a8:	09 45 f0             	or     %eax,-0x10(%ebp)
  8013ab:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  8013ae:	eb 18                	jmp    8013c8 <memset+0x6f>
			*p64++ = data_block, n -= 8;
  8013b0:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8013b3:	8d 41 08             	lea    0x8(%ecx),%eax
  8013b6:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8013b9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013bc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8013bf:	89 01                	mov    %eax,(%ecx)
  8013c1:	89 51 04             	mov    %edx,0x4(%ecx)
  8013c4:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  8013c8:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  8013cc:	77 e2                	ja     8013b0 <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  8013ce:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8013d2:	74 23                	je     8013f7 <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  8013d4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8013d7:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  8013da:	eb 0e                	jmp    8013ea <memset+0x91>
			*p8++ = (uint8)c;
  8013dc:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8013df:	8d 50 01             	lea    0x1(%eax),%edx
  8013e2:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8013e5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8013e8:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  8013ea:	8b 45 10             	mov    0x10(%ebp),%eax
  8013ed:	8d 50 ff             	lea    -0x1(%eax),%edx
  8013f0:	89 55 10             	mov    %edx,0x10(%ebp)
  8013f3:	85 c0                	test   %eax,%eax
  8013f5:	75 e5                	jne    8013dc <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  8013f7:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8013fa:	c9                   	leave  
  8013fb:	c3                   	ret    

008013fc <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  8013fc:	55                   	push   %ebp
  8013fd:	89 e5                	mov    %esp,%ebp
  8013ff:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  801402:	8b 45 0c             	mov    0xc(%ebp),%eax
  801405:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  801408:	8b 45 08             	mov    0x8(%ebp),%eax
  80140b:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  80140e:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801412:	76 24                	jbe    801438 <memcpy+0x3c>
		while(n >= 8){
  801414:	eb 1c                	jmp    801432 <memcpy+0x36>
			*d64 = *s64;
  801416:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801419:	8b 50 04             	mov    0x4(%eax),%edx
  80141c:	8b 00                	mov    (%eax),%eax
  80141e:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801421:	89 01                	mov    %eax,(%ecx)
  801423:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  801426:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  80142a:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  80142e:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  801432:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801436:	77 de                	ja     801416 <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  801438:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80143c:	74 31                	je     80146f <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  80143e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801441:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  801444:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801447:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  80144a:	eb 16                	jmp    801462 <memcpy+0x66>
			*d8++ = *s8++;
  80144c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80144f:	8d 50 01             	lea    0x1(%eax),%edx
  801452:	89 55 f0             	mov    %edx,-0x10(%ebp)
  801455:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801458:	8d 4a 01             	lea    0x1(%edx),%ecx
  80145b:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  80145e:	8a 12                	mov    (%edx),%dl
  801460:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  801462:	8b 45 10             	mov    0x10(%ebp),%eax
  801465:	8d 50 ff             	lea    -0x1(%eax),%edx
  801468:	89 55 10             	mov    %edx,0x10(%ebp)
  80146b:	85 c0                	test   %eax,%eax
  80146d:	75 dd                	jne    80144c <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  80146f:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801472:	c9                   	leave  
  801473:	c3                   	ret    

00801474 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801474:	55                   	push   %ebp
  801475:	89 e5                	mov    %esp,%ebp
  801477:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  80147a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80147d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801480:	8b 45 08             	mov    0x8(%ebp),%eax
  801483:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801486:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801489:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80148c:	73 50                	jae    8014de <memmove+0x6a>
  80148e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801491:	8b 45 10             	mov    0x10(%ebp),%eax
  801494:	01 d0                	add    %edx,%eax
  801496:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801499:	76 43                	jbe    8014de <memmove+0x6a>
		s += n;
  80149b:	8b 45 10             	mov    0x10(%ebp),%eax
  80149e:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  8014a1:	8b 45 10             	mov    0x10(%ebp),%eax
  8014a4:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  8014a7:	eb 10                	jmp    8014b9 <memmove+0x45>
			*--d = *--s;
  8014a9:	ff 4d f8             	decl   -0x8(%ebp)
  8014ac:	ff 4d fc             	decl   -0x4(%ebp)
  8014af:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8014b2:	8a 10                	mov    (%eax),%dl
  8014b4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8014b7:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  8014b9:	8b 45 10             	mov    0x10(%ebp),%eax
  8014bc:	8d 50 ff             	lea    -0x1(%eax),%edx
  8014bf:	89 55 10             	mov    %edx,0x10(%ebp)
  8014c2:	85 c0                	test   %eax,%eax
  8014c4:	75 e3                	jne    8014a9 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8014c6:	eb 23                	jmp    8014eb <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  8014c8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8014cb:	8d 50 01             	lea    0x1(%eax),%edx
  8014ce:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8014d1:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8014d4:	8d 4a 01             	lea    0x1(%edx),%ecx
  8014d7:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8014da:	8a 12                	mov    (%edx),%dl
  8014dc:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  8014de:	8b 45 10             	mov    0x10(%ebp),%eax
  8014e1:	8d 50 ff             	lea    -0x1(%eax),%edx
  8014e4:	89 55 10             	mov    %edx,0x10(%ebp)
  8014e7:	85 c0                	test   %eax,%eax
  8014e9:	75 dd                	jne    8014c8 <memmove+0x54>
			*d++ = *s++;

	return dst;
  8014eb:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8014ee:	c9                   	leave  
  8014ef:	c3                   	ret    

008014f0 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8014f0:	55                   	push   %ebp
  8014f1:	89 e5                	mov    %esp,%ebp
  8014f3:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  8014f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8014f9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  8014fc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014ff:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  801502:	eb 2a                	jmp    80152e <memcmp+0x3e>
		if (*s1 != *s2)
  801504:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801507:	8a 10                	mov    (%eax),%dl
  801509:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80150c:	8a 00                	mov    (%eax),%al
  80150e:	38 c2                	cmp    %al,%dl
  801510:	74 16                	je     801528 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801512:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801515:	8a 00                	mov    (%eax),%al
  801517:	0f b6 d0             	movzbl %al,%edx
  80151a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80151d:	8a 00                	mov    (%eax),%al
  80151f:	0f b6 c0             	movzbl %al,%eax
  801522:	29 c2                	sub    %eax,%edx
  801524:	89 d0                	mov    %edx,%eax
  801526:	eb 18                	jmp    801540 <memcmp+0x50>
		s1++, s2++;
  801528:	ff 45 fc             	incl   -0x4(%ebp)
  80152b:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  80152e:	8b 45 10             	mov    0x10(%ebp),%eax
  801531:	8d 50 ff             	lea    -0x1(%eax),%edx
  801534:	89 55 10             	mov    %edx,0x10(%ebp)
  801537:	85 c0                	test   %eax,%eax
  801539:	75 c9                	jne    801504 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  80153b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801540:	c9                   	leave  
  801541:	c3                   	ret    

00801542 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801542:	55                   	push   %ebp
  801543:	89 e5                	mov    %esp,%ebp
  801545:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801548:	8b 55 08             	mov    0x8(%ebp),%edx
  80154b:	8b 45 10             	mov    0x10(%ebp),%eax
  80154e:	01 d0                	add    %edx,%eax
  801550:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801553:	eb 15                	jmp    80156a <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801555:	8b 45 08             	mov    0x8(%ebp),%eax
  801558:	8a 00                	mov    (%eax),%al
  80155a:	0f b6 d0             	movzbl %al,%edx
  80155d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801560:	0f b6 c0             	movzbl %al,%eax
  801563:	39 c2                	cmp    %eax,%edx
  801565:	74 0d                	je     801574 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801567:	ff 45 08             	incl   0x8(%ebp)
  80156a:	8b 45 08             	mov    0x8(%ebp),%eax
  80156d:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801570:	72 e3                	jb     801555 <memfind+0x13>
  801572:	eb 01                	jmp    801575 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801574:	90                   	nop
	return (void *) s;
  801575:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801578:	c9                   	leave  
  801579:	c3                   	ret    

0080157a <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80157a:	55                   	push   %ebp
  80157b:	89 e5                	mov    %esp,%ebp
  80157d:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801580:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801587:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80158e:	eb 03                	jmp    801593 <strtol+0x19>
		s++;
  801590:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801593:	8b 45 08             	mov    0x8(%ebp),%eax
  801596:	8a 00                	mov    (%eax),%al
  801598:	3c 20                	cmp    $0x20,%al
  80159a:	74 f4                	je     801590 <strtol+0x16>
  80159c:	8b 45 08             	mov    0x8(%ebp),%eax
  80159f:	8a 00                	mov    (%eax),%al
  8015a1:	3c 09                	cmp    $0x9,%al
  8015a3:	74 eb                	je     801590 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  8015a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8015a8:	8a 00                	mov    (%eax),%al
  8015aa:	3c 2b                	cmp    $0x2b,%al
  8015ac:	75 05                	jne    8015b3 <strtol+0x39>
		s++;
  8015ae:	ff 45 08             	incl   0x8(%ebp)
  8015b1:	eb 13                	jmp    8015c6 <strtol+0x4c>
	else if (*s == '-')
  8015b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8015b6:	8a 00                	mov    (%eax),%al
  8015b8:	3c 2d                	cmp    $0x2d,%al
  8015ba:	75 0a                	jne    8015c6 <strtol+0x4c>
		s++, neg = 1;
  8015bc:	ff 45 08             	incl   0x8(%ebp)
  8015bf:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8015c6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8015ca:	74 06                	je     8015d2 <strtol+0x58>
  8015cc:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8015d0:	75 20                	jne    8015f2 <strtol+0x78>
  8015d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8015d5:	8a 00                	mov    (%eax),%al
  8015d7:	3c 30                	cmp    $0x30,%al
  8015d9:	75 17                	jne    8015f2 <strtol+0x78>
  8015db:	8b 45 08             	mov    0x8(%ebp),%eax
  8015de:	40                   	inc    %eax
  8015df:	8a 00                	mov    (%eax),%al
  8015e1:	3c 78                	cmp    $0x78,%al
  8015e3:	75 0d                	jne    8015f2 <strtol+0x78>
		s += 2, base = 16;
  8015e5:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8015e9:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8015f0:	eb 28                	jmp    80161a <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8015f2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8015f6:	75 15                	jne    80160d <strtol+0x93>
  8015f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8015fb:	8a 00                	mov    (%eax),%al
  8015fd:	3c 30                	cmp    $0x30,%al
  8015ff:	75 0c                	jne    80160d <strtol+0x93>
		s++, base = 8;
  801601:	ff 45 08             	incl   0x8(%ebp)
  801604:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  80160b:	eb 0d                	jmp    80161a <strtol+0xa0>
	else if (base == 0)
  80160d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801611:	75 07                	jne    80161a <strtol+0xa0>
		base = 10;
  801613:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  80161a:	8b 45 08             	mov    0x8(%ebp),%eax
  80161d:	8a 00                	mov    (%eax),%al
  80161f:	3c 2f                	cmp    $0x2f,%al
  801621:	7e 19                	jle    80163c <strtol+0xc2>
  801623:	8b 45 08             	mov    0x8(%ebp),%eax
  801626:	8a 00                	mov    (%eax),%al
  801628:	3c 39                	cmp    $0x39,%al
  80162a:	7f 10                	jg     80163c <strtol+0xc2>
			dig = *s - '0';
  80162c:	8b 45 08             	mov    0x8(%ebp),%eax
  80162f:	8a 00                	mov    (%eax),%al
  801631:	0f be c0             	movsbl %al,%eax
  801634:	83 e8 30             	sub    $0x30,%eax
  801637:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80163a:	eb 42                	jmp    80167e <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  80163c:	8b 45 08             	mov    0x8(%ebp),%eax
  80163f:	8a 00                	mov    (%eax),%al
  801641:	3c 60                	cmp    $0x60,%al
  801643:	7e 19                	jle    80165e <strtol+0xe4>
  801645:	8b 45 08             	mov    0x8(%ebp),%eax
  801648:	8a 00                	mov    (%eax),%al
  80164a:	3c 7a                	cmp    $0x7a,%al
  80164c:	7f 10                	jg     80165e <strtol+0xe4>
			dig = *s - 'a' + 10;
  80164e:	8b 45 08             	mov    0x8(%ebp),%eax
  801651:	8a 00                	mov    (%eax),%al
  801653:	0f be c0             	movsbl %al,%eax
  801656:	83 e8 57             	sub    $0x57,%eax
  801659:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80165c:	eb 20                	jmp    80167e <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  80165e:	8b 45 08             	mov    0x8(%ebp),%eax
  801661:	8a 00                	mov    (%eax),%al
  801663:	3c 40                	cmp    $0x40,%al
  801665:	7e 39                	jle    8016a0 <strtol+0x126>
  801667:	8b 45 08             	mov    0x8(%ebp),%eax
  80166a:	8a 00                	mov    (%eax),%al
  80166c:	3c 5a                	cmp    $0x5a,%al
  80166e:	7f 30                	jg     8016a0 <strtol+0x126>
			dig = *s - 'A' + 10;
  801670:	8b 45 08             	mov    0x8(%ebp),%eax
  801673:	8a 00                	mov    (%eax),%al
  801675:	0f be c0             	movsbl %al,%eax
  801678:	83 e8 37             	sub    $0x37,%eax
  80167b:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  80167e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801681:	3b 45 10             	cmp    0x10(%ebp),%eax
  801684:	7d 19                	jge    80169f <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801686:	ff 45 08             	incl   0x8(%ebp)
  801689:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80168c:	0f af 45 10          	imul   0x10(%ebp),%eax
  801690:	89 c2                	mov    %eax,%edx
  801692:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801695:	01 d0                	add    %edx,%eax
  801697:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  80169a:	e9 7b ff ff ff       	jmp    80161a <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  80169f:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8016a0:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8016a4:	74 08                	je     8016ae <strtol+0x134>
		*endptr = (char *) s;
  8016a6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016a9:	8b 55 08             	mov    0x8(%ebp),%edx
  8016ac:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8016ae:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8016b2:	74 07                	je     8016bb <strtol+0x141>
  8016b4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8016b7:	f7 d8                	neg    %eax
  8016b9:	eb 03                	jmp    8016be <strtol+0x144>
  8016bb:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8016be:	c9                   	leave  
  8016bf:	c3                   	ret    

008016c0 <ltostr>:

void
ltostr(long value, char *str)
{
  8016c0:	55                   	push   %ebp
  8016c1:	89 e5                	mov    %esp,%ebp
  8016c3:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8016c6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8016cd:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8016d4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8016d8:	79 13                	jns    8016ed <ltostr+0x2d>
	{
		neg = 1;
  8016da:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8016e1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016e4:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8016e7:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8016ea:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8016ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8016f0:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8016f5:	99                   	cltd   
  8016f6:	f7 f9                	idiv   %ecx
  8016f8:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8016fb:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8016fe:	8d 50 01             	lea    0x1(%eax),%edx
  801701:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801704:	89 c2                	mov    %eax,%edx
  801706:	8b 45 0c             	mov    0xc(%ebp),%eax
  801709:	01 d0                	add    %edx,%eax
  80170b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80170e:	83 c2 30             	add    $0x30,%edx
  801711:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801713:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801716:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80171b:	f7 e9                	imul   %ecx
  80171d:	c1 fa 02             	sar    $0x2,%edx
  801720:	89 c8                	mov    %ecx,%eax
  801722:	c1 f8 1f             	sar    $0x1f,%eax
  801725:	29 c2                	sub    %eax,%edx
  801727:	89 d0                	mov    %edx,%eax
  801729:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  80172c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801730:	75 bb                	jne    8016ed <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801732:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801739:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80173c:	48                   	dec    %eax
  80173d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801740:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801744:	74 3d                	je     801783 <ltostr+0xc3>
		start = 1 ;
  801746:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  80174d:	eb 34                	jmp    801783 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  80174f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801752:	8b 45 0c             	mov    0xc(%ebp),%eax
  801755:	01 d0                	add    %edx,%eax
  801757:	8a 00                	mov    (%eax),%al
  801759:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  80175c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80175f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801762:	01 c2                	add    %eax,%edx
  801764:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801767:	8b 45 0c             	mov    0xc(%ebp),%eax
  80176a:	01 c8                	add    %ecx,%eax
  80176c:	8a 00                	mov    (%eax),%al
  80176e:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801770:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801773:	8b 45 0c             	mov    0xc(%ebp),%eax
  801776:	01 c2                	add    %eax,%edx
  801778:	8a 45 eb             	mov    -0x15(%ebp),%al
  80177b:	88 02                	mov    %al,(%edx)
		start++ ;
  80177d:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801780:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801783:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801786:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801789:	7c c4                	jl     80174f <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  80178b:	8b 55 f8             	mov    -0x8(%ebp),%edx
  80178e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801791:	01 d0                	add    %edx,%eax
  801793:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801796:	90                   	nop
  801797:	c9                   	leave  
  801798:	c3                   	ret    

00801799 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801799:	55                   	push   %ebp
  80179a:	89 e5                	mov    %esp,%ebp
  80179c:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  80179f:	ff 75 08             	pushl  0x8(%ebp)
  8017a2:	e8 c4 f9 ff ff       	call   80116b <strlen>
  8017a7:	83 c4 04             	add    $0x4,%esp
  8017aa:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8017ad:	ff 75 0c             	pushl  0xc(%ebp)
  8017b0:	e8 b6 f9 ff ff       	call   80116b <strlen>
  8017b5:	83 c4 04             	add    $0x4,%esp
  8017b8:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8017bb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8017c2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8017c9:	eb 17                	jmp    8017e2 <strcconcat+0x49>
		final[s] = str1[s] ;
  8017cb:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8017ce:	8b 45 10             	mov    0x10(%ebp),%eax
  8017d1:	01 c2                	add    %eax,%edx
  8017d3:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8017d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8017d9:	01 c8                	add    %ecx,%eax
  8017db:	8a 00                	mov    (%eax),%al
  8017dd:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8017df:	ff 45 fc             	incl   -0x4(%ebp)
  8017e2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8017e5:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8017e8:	7c e1                	jl     8017cb <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8017ea:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8017f1:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8017f8:	eb 1f                	jmp    801819 <strcconcat+0x80>
		final[s++] = str2[i] ;
  8017fa:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8017fd:	8d 50 01             	lea    0x1(%eax),%edx
  801800:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801803:	89 c2                	mov    %eax,%edx
  801805:	8b 45 10             	mov    0x10(%ebp),%eax
  801808:	01 c2                	add    %eax,%edx
  80180a:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  80180d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801810:	01 c8                	add    %ecx,%eax
  801812:	8a 00                	mov    (%eax),%al
  801814:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801816:	ff 45 f8             	incl   -0x8(%ebp)
  801819:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80181c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80181f:	7c d9                	jl     8017fa <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801821:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801824:	8b 45 10             	mov    0x10(%ebp),%eax
  801827:	01 d0                	add    %edx,%eax
  801829:	c6 00 00             	movb   $0x0,(%eax)
}
  80182c:	90                   	nop
  80182d:	c9                   	leave  
  80182e:	c3                   	ret    

0080182f <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  80182f:	55                   	push   %ebp
  801830:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801832:	8b 45 14             	mov    0x14(%ebp),%eax
  801835:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  80183b:	8b 45 14             	mov    0x14(%ebp),%eax
  80183e:	8b 00                	mov    (%eax),%eax
  801840:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801847:	8b 45 10             	mov    0x10(%ebp),%eax
  80184a:	01 d0                	add    %edx,%eax
  80184c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801852:	eb 0c                	jmp    801860 <strsplit+0x31>
			*string++ = 0;
  801854:	8b 45 08             	mov    0x8(%ebp),%eax
  801857:	8d 50 01             	lea    0x1(%eax),%edx
  80185a:	89 55 08             	mov    %edx,0x8(%ebp)
  80185d:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801860:	8b 45 08             	mov    0x8(%ebp),%eax
  801863:	8a 00                	mov    (%eax),%al
  801865:	84 c0                	test   %al,%al
  801867:	74 18                	je     801881 <strsplit+0x52>
  801869:	8b 45 08             	mov    0x8(%ebp),%eax
  80186c:	8a 00                	mov    (%eax),%al
  80186e:	0f be c0             	movsbl %al,%eax
  801871:	50                   	push   %eax
  801872:	ff 75 0c             	pushl  0xc(%ebp)
  801875:	e8 83 fa ff ff       	call   8012fd <strchr>
  80187a:	83 c4 08             	add    $0x8,%esp
  80187d:	85 c0                	test   %eax,%eax
  80187f:	75 d3                	jne    801854 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801881:	8b 45 08             	mov    0x8(%ebp),%eax
  801884:	8a 00                	mov    (%eax),%al
  801886:	84 c0                	test   %al,%al
  801888:	74 5a                	je     8018e4 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  80188a:	8b 45 14             	mov    0x14(%ebp),%eax
  80188d:	8b 00                	mov    (%eax),%eax
  80188f:	83 f8 0f             	cmp    $0xf,%eax
  801892:	75 07                	jne    80189b <strsplit+0x6c>
		{
			return 0;
  801894:	b8 00 00 00 00       	mov    $0x0,%eax
  801899:	eb 66                	jmp    801901 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  80189b:	8b 45 14             	mov    0x14(%ebp),%eax
  80189e:	8b 00                	mov    (%eax),%eax
  8018a0:	8d 48 01             	lea    0x1(%eax),%ecx
  8018a3:	8b 55 14             	mov    0x14(%ebp),%edx
  8018a6:	89 0a                	mov    %ecx,(%edx)
  8018a8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8018af:	8b 45 10             	mov    0x10(%ebp),%eax
  8018b2:	01 c2                	add    %eax,%edx
  8018b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8018b7:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8018b9:	eb 03                	jmp    8018be <strsplit+0x8f>
			string++;
  8018bb:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8018be:	8b 45 08             	mov    0x8(%ebp),%eax
  8018c1:	8a 00                	mov    (%eax),%al
  8018c3:	84 c0                	test   %al,%al
  8018c5:	74 8b                	je     801852 <strsplit+0x23>
  8018c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8018ca:	8a 00                	mov    (%eax),%al
  8018cc:	0f be c0             	movsbl %al,%eax
  8018cf:	50                   	push   %eax
  8018d0:	ff 75 0c             	pushl  0xc(%ebp)
  8018d3:	e8 25 fa ff ff       	call   8012fd <strchr>
  8018d8:	83 c4 08             	add    $0x8,%esp
  8018db:	85 c0                	test   %eax,%eax
  8018dd:	74 dc                	je     8018bb <strsplit+0x8c>
			string++;
	}
  8018df:	e9 6e ff ff ff       	jmp    801852 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8018e4:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8018e5:	8b 45 14             	mov    0x14(%ebp),%eax
  8018e8:	8b 00                	mov    (%eax),%eax
  8018ea:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8018f1:	8b 45 10             	mov    0x10(%ebp),%eax
  8018f4:	01 d0                	add    %edx,%eax
  8018f6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8018fc:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801901:	c9                   	leave  
  801902:	c3                   	ret    

00801903 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  801903:	55                   	push   %ebp
  801904:	89 e5                	mov    %esp,%ebp
  801906:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  801909:	8b 45 08             	mov    0x8(%ebp),%eax
  80190c:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  80190f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801916:	eb 4a                	jmp    801962 <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  801918:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80191b:	8b 45 08             	mov    0x8(%ebp),%eax
  80191e:	01 c2                	add    %eax,%edx
  801920:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801923:	8b 45 0c             	mov    0xc(%ebp),%eax
  801926:	01 c8                	add    %ecx,%eax
  801928:	8a 00                	mov    (%eax),%al
  80192a:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  80192c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80192f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801932:	01 d0                	add    %edx,%eax
  801934:	8a 00                	mov    (%eax),%al
  801936:	3c 40                	cmp    $0x40,%al
  801938:	7e 25                	jle    80195f <str2lower+0x5c>
  80193a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80193d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801940:	01 d0                	add    %edx,%eax
  801942:	8a 00                	mov    (%eax),%al
  801944:	3c 5a                	cmp    $0x5a,%al
  801946:	7f 17                	jg     80195f <str2lower+0x5c>
		{
			dst[i] += 32 ;
  801948:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80194b:	8b 45 08             	mov    0x8(%ebp),%eax
  80194e:	01 d0                	add    %edx,%eax
  801950:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801953:	8b 55 08             	mov    0x8(%ebp),%edx
  801956:	01 ca                	add    %ecx,%edx
  801958:	8a 12                	mov    (%edx),%dl
  80195a:	83 c2 20             	add    $0x20,%edx
  80195d:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  80195f:	ff 45 fc             	incl   -0x4(%ebp)
  801962:	ff 75 0c             	pushl  0xc(%ebp)
  801965:	e8 01 f8 ff ff       	call   80116b <strlen>
  80196a:	83 c4 04             	add    $0x4,%esp
  80196d:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801970:	7f a6                	jg     801918 <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  801972:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801975:	c9                   	leave  
  801976:	c3                   	ret    

00801977 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801977:	55                   	push   %ebp
  801978:	89 e5                	mov    %esp,%ebp
  80197a:	57                   	push   %edi
  80197b:	56                   	push   %esi
  80197c:	53                   	push   %ebx
  80197d:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801980:	8b 45 08             	mov    0x8(%ebp),%eax
  801983:	8b 55 0c             	mov    0xc(%ebp),%edx
  801986:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801989:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80198c:	8b 7d 18             	mov    0x18(%ebp),%edi
  80198f:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801992:	cd 30                	int    $0x30
  801994:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  801997:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80199a:	83 c4 10             	add    $0x10,%esp
  80199d:	5b                   	pop    %ebx
  80199e:	5e                   	pop    %esi
  80199f:	5f                   	pop    %edi
  8019a0:	5d                   	pop    %ebp
  8019a1:	c3                   	ret    

008019a2 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  8019a2:	55                   	push   %ebp
  8019a3:	89 e5                	mov    %esp,%ebp
  8019a5:	83 ec 04             	sub    $0x4,%esp
  8019a8:	8b 45 10             	mov    0x10(%ebp),%eax
  8019ab:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  8019ae:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8019b1:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8019b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8019b8:	6a 00                	push   $0x0
  8019ba:	51                   	push   %ecx
  8019bb:	52                   	push   %edx
  8019bc:	ff 75 0c             	pushl  0xc(%ebp)
  8019bf:	50                   	push   %eax
  8019c0:	6a 00                	push   $0x0
  8019c2:	e8 b0 ff ff ff       	call   801977 <syscall>
  8019c7:	83 c4 18             	add    $0x18,%esp
}
  8019ca:	90                   	nop
  8019cb:	c9                   	leave  
  8019cc:	c3                   	ret    

008019cd <sys_cgetc>:

int
sys_cgetc(void)
{
  8019cd:	55                   	push   %ebp
  8019ce:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8019d0:	6a 00                	push   $0x0
  8019d2:	6a 00                	push   $0x0
  8019d4:	6a 00                	push   $0x0
  8019d6:	6a 00                	push   $0x0
  8019d8:	6a 00                	push   $0x0
  8019da:	6a 02                	push   $0x2
  8019dc:	e8 96 ff ff ff       	call   801977 <syscall>
  8019e1:	83 c4 18             	add    $0x18,%esp
}
  8019e4:	c9                   	leave  
  8019e5:	c3                   	ret    

008019e6 <sys_lock_cons>:

void sys_lock_cons(void)
{
  8019e6:	55                   	push   %ebp
  8019e7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  8019e9:	6a 00                	push   $0x0
  8019eb:	6a 00                	push   $0x0
  8019ed:	6a 00                	push   $0x0
  8019ef:	6a 00                	push   $0x0
  8019f1:	6a 00                	push   $0x0
  8019f3:	6a 03                	push   $0x3
  8019f5:	e8 7d ff ff ff       	call   801977 <syscall>
  8019fa:	83 c4 18             	add    $0x18,%esp
}
  8019fd:	90                   	nop
  8019fe:	c9                   	leave  
  8019ff:	c3                   	ret    

00801a00 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  801a00:	55                   	push   %ebp
  801a01:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  801a03:	6a 00                	push   $0x0
  801a05:	6a 00                	push   $0x0
  801a07:	6a 00                	push   $0x0
  801a09:	6a 00                	push   $0x0
  801a0b:	6a 00                	push   $0x0
  801a0d:	6a 04                	push   $0x4
  801a0f:	e8 63 ff ff ff       	call   801977 <syscall>
  801a14:	83 c4 18             	add    $0x18,%esp
}
  801a17:	90                   	nop
  801a18:	c9                   	leave  
  801a19:	c3                   	ret    

00801a1a <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801a1a:	55                   	push   %ebp
  801a1b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801a1d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a20:	8b 45 08             	mov    0x8(%ebp),%eax
  801a23:	6a 00                	push   $0x0
  801a25:	6a 00                	push   $0x0
  801a27:	6a 00                	push   $0x0
  801a29:	52                   	push   %edx
  801a2a:	50                   	push   %eax
  801a2b:	6a 08                	push   $0x8
  801a2d:	e8 45 ff ff ff       	call   801977 <syscall>
  801a32:	83 c4 18             	add    $0x18,%esp
}
  801a35:	c9                   	leave  
  801a36:	c3                   	ret    

00801a37 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801a37:	55                   	push   %ebp
  801a38:	89 e5                	mov    %esp,%ebp
  801a3a:	56                   	push   %esi
  801a3b:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801a3c:	8b 75 18             	mov    0x18(%ebp),%esi
  801a3f:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801a42:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801a45:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a48:	8b 45 08             	mov    0x8(%ebp),%eax
  801a4b:	56                   	push   %esi
  801a4c:	53                   	push   %ebx
  801a4d:	51                   	push   %ecx
  801a4e:	52                   	push   %edx
  801a4f:	50                   	push   %eax
  801a50:	6a 09                	push   $0x9
  801a52:	e8 20 ff ff ff       	call   801977 <syscall>
  801a57:	83 c4 18             	add    $0x18,%esp
}
  801a5a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a5d:	5b                   	pop    %ebx
  801a5e:	5e                   	pop    %esi
  801a5f:	5d                   	pop    %ebp
  801a60:	c3                   	ret    

00801a61 <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  801a61:	55                   	push   %ebp
  801a62:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  801a64:	6a 00                	push   $0x0
  801a66:	6a 00                	push   $0x0
  801a68:	6a 00                	push   $0x0
  801a6a:	6a 00                	push   $0x0
  801a6c:	ff 75 08             	pushl  0x8(%ebp)
  801a6f:	6a 0a                	push   $0xa
  801a71:	e8 01 ff ff ff       	call   801977 <syscall>
  801a76:	83 c4 18             	add    $0x18,%esp
}
  801a79:	c9                   	leave  
  801a7a:	c3                   	ret    

00801a7b <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801a7b:	55                   	push   %ebp
  801a7c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801a7e:	6a 00                	push   $0x0
  801a80:	6a 00                	push   $0x0
  801a82:	6a 00                	push   $0x0
  801a84:	ff 75 0c             	pushl  0xc(%ebp)
  801a87:	ff 75 08             	pushl  0x8(%ebp)
  801a8a:	6a 0b                	push   $0xb
  801a8c:	e8 e6 fe ff ff       	call   801977 <syscall>
  801a91:	83 c4 18             	add    $0x18,%esp
}
  801a94:	c9                   	leave  
  801a95:	c3                   	ret    

00801a96 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801a96:	55                   	push   %ebp
  801a97:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801a99:	6a 00                	push   $0x0
  801a9b:	6a 00                	push   $0x0
  801a9d:	6a 00                	push   $0x0
  801a9f:	6a 00                	push   $0x0
  801aa1:	6a 00                	push   $0x0
  801aa3:	6a 0c                	push   $0xc
  801aa5:	e8 cd fe ff ff       	call   801977 <syscall>
  801aaa:	83 c4 18             	add    $0x18,%esp
}
  801aad:	c9                   	leave  
  801aae:	c3                   	ret    

00801aaf <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801aaf:	55                   	push   %ebp
  801ab0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801ab2:	6a 00                	push   $0x0
  801ab4:	6a 00                	push   $0x0
  801ab6:	6a 00                	push   $0x0
  801ab8:	6a 00                	push   $0x0
  801aba:	6a 00                	push   $0x0
  801abc:	6a 0d                	push   $0xd
  801abe:	e8 b4 fe ff ff       	call   801977 <syscall>
  801ac3:	83 c4 18             	add    $0x18,%esp
}
  801ac6:	c9                   	leave  
  801ac7:	c3                   	ret    

00801ac8 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801ac8:	55                   	push   %ebp
  801ac9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801acb:	6a 00                	push   $0x0
  801acd:	6a 00                	push   $0x0
  801acf:	6a 00                	push   $0x0
  801ad1:	6a 00                	push   $0x0
  801ad3:	6a 00                	push   $0x0
  801ad5:	6a 0e                	push   $0xe
  801ad7:	e8 9b fe ff ff       	call   801977 <syscall>
  801adc:	83 c4 18             	add    $0x18,%esp
}
  801adf:	c9                   	leave  
  801ae0:	c3                   	ret    

00801ae1 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801ae1:	55                   	push   %ebp
  801ae2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801ae4:	6a 00                	push   $0x0
  801ae6:	6a 00                	push   $0x0
  801ae8:	6a 00                	push   $0x0
  801aea:	6a 00                	push   $0x0
  801aec:	6a 00                	push   $0x0
  801aee:	6a 0f                	push   $0xf
  801af0:	e8 82 fe ff ff       	call   801977 <syscall>
  801af5:	83 c4 18             	add    $0x18,%esp
}
  801af8:	c9                   	leave  
  801af9:	c3                   	ret    

00801afa <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801afa:	55                   	push   %ebp
  801afb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801afd:	6a 00                	push   $0x0
  801aff:	6a 00                	push   $0x0
  801b01:	6a 00                	push   $0x0
  801b03:	6a 00                	push   $0x0
  801b05:	ff 75 08             	pushl  0x8(%ebp)
  801b08:	6a 10                	push   $0x10
  801b0a:	e8 68 fe ff ff       	call   801977 <syscall>
  801b0f:	83 c4 18             	add    $0x18,%esp
}
  801b12:	c9                   	leave  
  801b13:	c3                   	ret    

00801b14 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801b14:	55                   	push   %ebp
  801b15:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801b17:	6a 00                	push   $0x0
  801b19:	6a 00                	push   $0x0
  801b1b:	6a 00                	push   $0x0
  801b1d:	6a 00                	push   $0x0
  801b1f:	6a 00                	push   $0x0
  801b21:	6a 11                	push   $0x11
  801b23:	e8 4f fe ff ff       	call   801977 <syscall>
  801b28:	83 c4 18             	add    $0x18,%esp
}
  801b2b:	90                   	nop
  801b2c:	c9                   	leave  
  801b2d:	c3                   	ret    

00801b2e <sys_cputc>:

void
sys_cputc(const char c)
{
  801b2e:	55                   	push   %ebp
  801b2f:	89 e5                	mov    %esp,%ebp
  801b31:	83 ec 04             	sub    $0x4,%esp
  801b34:	8b 45 08             	mov    0x8(%ebp),%eax
  801b37:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801b3a:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801b3e:	6a 00                	push   $0x0
  801b40:	6a 00                	push   $0x0
  801b42:	6a 00                	push   $0x0
  801b44:	6a 00                	push   $0x0
  801b46:	50                   	push   %eax
  801b47:	6a 01                	push   $0x1
  801b49:	e8 29 fe ff ff       	call   801977 <syscall>
  801b4e:	83 c4 18             	add    $0x18,%esp
}
  801b51:	90                   	nop
  801b52:	c9                   	leave  
  801b53:	c3                   	ret    

00801b54 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801b54:	55                   	push   %ebp
  801b55:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801b57:	6a 00                	push   $0x0
  801b59:	6a 00                	push   $0x0
  801b5b:	6a 00                	push   $0x0
  801b5d:	6a 00                	push   $0x0
  801b5f:	6a 00                	push   $0x0
  801b61:	6a 14                	push   $0x14
  801b63:	e8 0f fe ff ff       	call   801977 <syscall>
  801b68:	83 c4 18             	add    $0x18,%esp
}
  801b6b:	90                   	nop
  801b6c:	c9                   	leave  
  801b6d:	c3                   	ret    

00801b6e <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801b6e:	55                   	push   %ebp
  801b6f:	89 e5                	mov    %esp,%ebp
  801b71:	83 ec 04             	sub    $0x4,%esp
  801b74:	8b 45 10             	mov    0x10(%ebp),%eax
  801b77:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801b7a:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801b7d:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801b81:	8b 45 08             	mov    0x8(%ebp),%eax
  801b84:	6a 00                	push   $0x0
  801b86:	51                   	push   %ecx
  801b87:	52                   	push   %edx
  801b88:	ff 75 0c             	pushl  0xc(%ebp)
  801b8b:	50                   	push   %eax
  801b8c:	6a 15                	push   $0x15
  801b8e:	e8 e4 fd ff ff       	call   801977 <syscall>
  801b93:	83 c4 18             	add    $0x18,%esp
}
  801b96:	c9                   	leave  
  801b97:	c3                   	ret    

00801b98 <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  801b98:	55                   	push   %ebp
  801b99:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801b9b:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b9e:	8b 45 08             	mov    0x8(%ebp),%eax
  801ba1:	6a 00                	push   $0x0
  801ba3:	6a 00                	push   $0x0
  801ba5:	6a 00                	push   $0x0
  801ba7:	52                   	push   %edx
  801ba8:	50                   	push   %eax
  801ba9:	6a 16                	push   $0x16
  801bab:	e8 c7 fd ff ff       	call   801977 <syscall>
  801bb0:	83 c4 18             	add    $0x18,%esp
}
  801bb3:	c9                   	leave  
  801bb4:	c3                   	ret    

00801bb5 <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  801bb5:	55                   	push   %ebp
  801bb6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801bb8:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801bbb:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bbe:	8b 45 08             	mov    0x8(%ebp),%eax
  801bc1:	6a 00                	push   $0x0
  801bc3:	6a 00                	push   $0x0
  801bc5:	51                   	push   %ecx
  801bc6:	52                   	push   %edx
  801bc7:	50                   	push   %eax
  801bc8:	6a 17                	push   $0x17
  801bca:	e8 a8 fd ff ff       	call   801977 <syscall>
  801bcf:	83 c4 18             	add    $0x18,%esp
}
  801bd2:	c9                   	leave  
  801bd3:	c3                   	ret    

00801bd4 <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  801bd4:	55                   	push   %ebp
  801bd5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801bd7:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bda:	8b 45 08             	mov    0x8(%ebp),%eax
  801bdd:	6a 00                	push   $0x0
  801bdf:	6a 00                	push   $0x0
  801be1:	6a 00                	push   $0x0
  801be3:	52                   	push   %edx
  801be4:	50                   	push   %eax
  801be5:	6a 18                	push   $0x18
  801be7:	e8 8b fd ff ff       	call   801977 <syscall>
  801bec:	83 c4 18             	add    $0x18,%esp
}
  801bef:	c9                   	leave  
  801bf0:	c3                   	ret    

00801bf1 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801bf1:	55                   	push   %ebp
  801bf2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801bf4:	8b 45 08             	mov    0x8(%ebp),%eax
  801bf7:	6a 00                	push   $0x0
  801bf9:	ff 75 14             	pushl  0x14(%ebp)
  801bfc:	ff 75 10             	pushl  0x10(%ebp)
  801bff:	ff 75 0c             	pushl  0xc(%ebp)
  801c02:	50                   	push   %eax
  801c03:	6a 19                	push   $0x19
  801c05:	e8 6d fd ff ff       	call   801977 <syscall>
  801c0a:	83 c4 18             	add    $0x18,%esp
}
  801c0d:	c9                   	leave  
  801c0e:	c3                   	ret    

00801c0f <sys_run_env>:

void sys_run_env(int32 envId)
{
  801c0f:	55                   	push   %ebp
  801c10:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801c12:	8b 45 08             	mov    0x8(%ebp),%eax
  801c15:	6a 00                	push   $0x0
  801c17:	6a 00                	push   $0x0
  801c19:	6a 00                	push   $0x0
  801c1b:	6a 00                	push   $0x0
  801c1d:	50                   	push   %eax
  801c1e:	6a 1a                	push   $0x1a
  801c20:	e8 52 fd ff ff       	call   801977 <syscall>
  801c25:	83 c4 18             	add    $0x18,%esp
}
  801c28:	90                   	nop
  801c29:	c9                   	leave  
  801c2a:	c3                   	ret    

00801c2b <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801c2b:	55                   	push   %ebp
  801c2c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801c2e:	8b 45 08             	mov    0x8(%ebp),%eax
  801c31:	6a 00                	push   $0x0
  801c33:	6a 00                	push   $0x0
  801c35:	6a 00                	push   $0x0
  801c37:	6a 00                	push   $0x0
  801c39:	50                   	push   %eax
  801c3a:	6a 1b                	push   $0x1b
  801c3c:	e8 36 fd ff ff       	call   801977 <syscall>
  801c41:	83 c4 18             	add    $0x18,%esp
}
  801c44:	c9                   	leave  
  801c45:	c3                   	ret    

00801c46 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801c46:	55                   	push   %ebp
  801c47:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801c49:	6a 00                	push   $0x0
  801c4b:	6a 00                	push   $0x0
  801c4d:	6a 00                	push   $0x0
  801c4f:	6a 00                	push   $0x0
  801c51:	6a 00                	push   $0x0
  801c53:	6a 05                	push   $0x5
  801c55:	e8 1d fd ff ff       	call   801977 <syscall>
  801c5a:	83 c4 18             	add    $0x18,%esp
}
  801c5d:	c9                   	leave  
  801c5e:	c3                   	ret    

00801c5f <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801c5f:	55                   	push   %ebp
  801c60:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801c62:	6a 00                	push   $0x0
  801c64:	6a 00                	push   $0x0
  801c66:	6a 00                	push   $0x0
  801c68:	6a 00                	push   $0x0
  801c6a:	6a 00                	push   $0x0
  801c6c:	6a 06                	push   $0x6
  801c6e:	e8 04 fd ff ff       	call   801977 <syscall>
  801c73:	83 c4 18             	add    $0x18,%esp
}
  801c76:	c9                   	leave  
  801c77:	c3                   	ret    

00801c78 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801c78:	55                   	push   %ebp
  801c79:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801c7b:	6a 00                	push   $0x0
  801c7d:	6a 00                	push   $0x0
  801c7f:	6a 00                	push   $0x0
  801c81:	6a 00                	push   $0x0
  801c83:	6a 00                	push   $0x0
  801c85:	6a 07                	push   $0x7
  801c87:	e8 eb fc ff ff       	call   801977 <syscall>
  801c8c:	83 c4 18             	add    $0x18,%esp
}
  801c8f:	c9                   	leave  
  801c90:	c3                   	ret    

00801c91 <sys_exit_env>:


void sys_exit_env(void)
{
  801c91:	55                   	push   %ebp
  801c92:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801c94:	6a 00                	push   $0x0
  801c96:	6a 00                	push   $0x0
  801c98:	6a 00                	push   $0x0
  801c9a:	6a 00                	push   $0x0
  801c9c:	6a 00                	push   $0x0
  801c9e:	6a 1c                	push   $0x1c
  801ca0:	e8 d2 fc ff ff       	call   801977 <syscall>
  801ca5:	83 c4 18             	add    $0x18,%esp
}
  801ca8:	90                   	nop
  801ca9:	c9                   	leave  
  801caa:	c3                   	ret    

00801cab <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  801cab:	55                   	push   %ebp
  801cac:	89 e5                	mov    %esp,%ebp
  801cae:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801cb1:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801cb4:	8d 50 04             	lea    0x4(%eax),%edx
  801cb7:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801cba:	6a 00                	push   $0x0
  801cbc:	6a 00                	push   $0x0
  801cbe:	6a 00                	push   $0x0
  801cc0:	52                   	push   %edx
  801cc1:	50                   	push   %eax
  801cc2:	6a 1d                	push   $0x1d
  801cc4:	e8 ae fc ff ff       	call   801977 <syscall>
  801cc9:	83 c4 18             	add    $0x18,%esp
	return result;
  801ccc:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801ccf:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801cd2:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801cd5:	89 01                	mov    %eax,(%ecx)
  801cd7:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801cda:	8b 45 08             	mov    0x8(%ebp),%eax
  801cdd:	c9                   	leave  
  801cde:	c2 04 00             	ret    $0x4

00801ce1 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801ce1:	55                   	push   %ebp
  801ce2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801ce4:	6a 00                	push   $0x0
  801ce6:	6a 00                	push   $0x0
  801ce8:	ff 75 10             	pushl  0x10(%ebp)
  801ceb:	ff 75 0c             	pushl  0xc(%ebp)
  801cee:	ff 75 08             	pushl  0x8(%ebp)
  801cf1:	6a 13                	push   $0x13
  801cf3:	e8 7f fc ff ff       	call   801977 <syscall>
  801cf8:	83 c4 18             	add    $0x18,%esp
	return ;
  801cfb:	90                   	nop
}
  801cfc:	c9                   	leave  
  801cfd:	c3                   	ret    

00801cfe <sys_rcr2>:
uint32 sys_rcr2()
{
  801cfe:	55                   	push   %ebp
  801cff:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801d01:	6a 00                	push   $0x0
  801d03:	6a 00                	push   $0x0
  801d05:	6a 00                	push   $0x0
  801d07:	6a 00                	push   $0x0
  801d09:	6a 00                	push   $0x0
  801d0b:	6a 1e                	push   $0x1e
  801d0d:	e8 65 fc ff ff       	call   801977 <syscall>
  801d12:	83 c4 18             	add    $0x18,%esp
}
  801d15:	c9                   	leave  
  801d16:	c3                   	ret    

00801d17 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  801d17:	55                   	push   %ebp
  801d18:	89 e5                	mov    %esp,%ebp
  801d1a:	83 ec 04             	sub    $0x4,%esp
  801d1d:	8b 45 08             	mov    0x8(%ebp),%eax
  801d20:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801d23:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801d27:	6a 00                	push   $0x0
  801d29:	6a 00                	push   $0x0
  801d2b:	6a 00                	push   $0x0
  801d2d:	6a 00                	push   $0x0
  801d2f:	50                   	push   %eax
  801d30:	6a 1f                	push   $0x1f
  801d32:	e8 40 fc ff ff       	call   801977 <syscall>
  801d37:	83 c4 18             	add    $0x18,%esp
	return ;
  801d3a:	90                   	nop
}
  801d3b:	c9                   	leave  
  801d3c:	c3                   	ret    

00801d3d <rsttst>:
void rsttst()
{
  801d3d:	55                   	push   %ebp
  801d3e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801d40:	6a 00                	push   $0x0
  801d42:	6a 00                	push   $0x0
  801d44:	6a 00                	push   $0x0
  801d46:	6a 00                	push   $0x0
  801d48:	6a 00                	push   $0x0
  801d4a:	6a 21                	push   $0x21
  801d4c:	e8 26 fc ff ff       	call   801977 <syscall>
  801d51:	83 c4 18             	add    $0x18,%esp
	return ;
  801d54:	90                   	nop
}
  801d55:	c9                   	leave  
  801d56:	c3                   	ret    

00801d57 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801d57:	55                   	push   %ebp
  801d58:	89 e5                	mov    %esp,%ebp
  801d5a:	83 ec 04             	sub    $0x4,%esp
  801d5d:	8b 45 14             	mov    0x14(%ebp),%eax
  801d60:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801d63:	8b 55 18             	mov    0x18(%ebp),%edx
  801d66:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801d6a:	52                   	push   %edx
  801d6b:	50                   	push   %eax
  801d6c:	ff 75 10             	pushl  0x10(%ebp)
  801d6f:	ff 75 0c             	pushl  0xc(%ebp)
  801d72:	ff 75 08             	pushl  0x8(%ebp)
  801d75:	6a 20                	push   $0x20
  801d77:	e8 fb fb ff ff       	call   801977 <syscall>
  801d7c:	83 c4 18             	add    $0x18,%esp
	return ;
  801d7f:	90                   	nop
}
  801d80:	c9                   	leave  
  801d81:	c3                   	ret    

00801d82 <chktst>:
void chktst(uint32 n)
{
  801d82:	55                   	push   %ebp
  801d83:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801d85:	6a 00                	push   $0x0
  801d87:	6a 00                	push   $0x0
  801d89:	6a 00                	push   $0x0
  801d8b:	6a 00                	push   $0x0
  801d8d:	ff 75 08             	pushl  0x8(%ebp)
  801d90:	6a 22                	push   $0x22
  801d92:	e8 e0 fb ff ff       	call   801977 <syscall>
  801d97:	83 c4 18             	add    $0x18,%esp
	return ;
  801d9a:	90                   	nop
}
  801d9b:	c9                   	leave  
  801d9c:	c3                   	ret    

00801d9d <inctst>:

void inctst()
{
  801d9d:	55                   	push   %ebp
  801d9e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801da0:	6a 00                	push   $0x0
  801da2:	6a 00                	push   $0x0
  801da4:	6a 00                	push   $0x0
  801da6:	6a 00                	push   $0x0
  801da8:	6a 00                	push   $0x0
  801daa:	6a 23                	push   $0x23
  801dac:	e8 c6 fb ff ff       	call   801977 <syscall>
  801db1:	83 c4 18             	add    $0x18,%esp
	return ;
  801db4:	90                   	nop
}
  801db5:	c9                   	leave  
  801db6:	c3                   	ret    

00801db7 <gettst>:
uint32 gettst()
{
  801db7:	55                   	push   %ebp
  801db8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801dba:	6a 00                	push   $0x0
  801dbc:	6a 00                	push   $0x0
  801dbe:	6a 00                	push   $0x0
  801dc0:	6a 00                	push   $0x0
  801dc2:	6a 00                	push   $0x0
  801dc4:	6a 24                	push   $0x24
  801dc6:	e8 ac fb ff ff       	call   801977 <syscall>
  801dcb:	83 c4 18             	add    $0x18,%esp
}
  801dce:	c9                   	leave  
  801dcf:	c3                   	ret    

00801dd0 <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  801dd0:	55                   	push   %ebp
  801dd1:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801dd3:	6a 00                	push   $0x0
  801dd5:	6a 00                	push   $0x0
  801dd7:	6a 00                	push   $0x0
  801dd9:	6a 00                	push   $0x0
  801ddb:	6a 00                	push   $0x0
  801ddd:	6a 25                	push   $0x25
  801ddf:	e8 93 fb ff ff       	call   801977 <syscall>
  801de4:	83 c4 18             	add    $0x18,%esp
  801de7:	a3 a0 b0 81 00       	mov    %eax,0x81b0a0
	return uheapPlaceStrategy ;
  801dec:	a1 a0 b0 81 00       	mov    0x81b0a0,%eax
}
  801df1:	c9                   	leave  
  801df2:	c3                   	ret    

00801df3 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801df3:	55                   	push   %ebp
  801df4:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  801df6:	8b 45 08             	mov    0x8(%ebp),%eax
  801df9:	a3 a0 b0 81 00       	mov    %eax,0x81b0a0
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801dfe:	6a 00                	push   $0x0
  801e00:	6a 00                	push   $0x0
  801e02:	6a 00                	push   $0x0
  801e04:	6a 00                	push   $0x0
  801e06:	ff 75 08             	pushl  0x8(%ebp)
  801e09:	6a 26                	push   $0x26
  801e0b:	e8 67 fb ff ff       	call   801977 <syscall>
  801e10:	83 c4 18             	add    $0x18,%esp
	return ;
  801e13:	90                   	nop
}
  801e14:	c9                   	leave  
  801e15:	c3                   	ret    

00801e16 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801e16:	55                   	push   %ebp
  801e17:	89 e5                	mov    %esp,%ebp
  801e19:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801e1a:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801e1d:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801e20:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e23:	8b 45 08             	mov    0x8(%ebp),%eax
  801e26:	6a 00                	push   $0x0
  801e28:	53                   	push   %ebx
  801e29:	51                   	push   %ecx
  801e2a:	52                   	push   %edx
  801e2b:	50                   	push   %eax
  801e2c:	6a 27                	push   $0x27
  801e2e:	e8 44 fb ff ff       	call   801977 <syscall>
  801e33:	83 c4 18             	add    $0x18,%esp
}
  801e36:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801e39:	c9                   	leave  
  801e3a:	c3                   	ret    

00801e3b <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801e3b:	55                   	push   %ebp
  801e3c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801e3e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e41:	8b 45 08             	mov    0x8(%ebp),%eax
  801e44:	6a 00                	push   $0x0
  801e46:	6a 00                	push   $0x0
  801e48:	6a 00                	push   $0x0
  801e4a:	52                   	push   %edx
  801e4b:	50                   	push   %eax
  801e4c:	6a 28                	push   $0x28
  801e4e:	e8 24 fb ff ff       	call   801977 <syscall>
  801e53:	83 c4 18             	add    $0x18,%esp
}
  801e56:	c9                   	leave  
  801e57:	c3                   	ret    

00801e58 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801e58:	55                   	push   %ebp
  801e59:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801e5b:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801e5e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e61:	8b 45 08             	mov    0x8(%ebp),%eax
  801e64:	6a 00                	push   $0x0
  801e66:	51                   	push   %ecx
  801e67:	ff 75 10             	pushl  0x10(%ebp)
  801e6a:	52                   	push   %edx
  801e6b:	50                   	push   %eax
  801e6c:	6a 29                	push   $0x29
  801e6e:	e8 04 fb ff ff       	call   801977 <syscall>
  801e73:	83 c4 18             	add    $0x18,%esp
}
  801e76:	c9                   	leave  
  801e77:	c3                   	ret    

00801e78 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801e78:	55                   	push   %ebp
  801e79:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801e7b:	6a 00                	push   $0x0
  801e7d:	6a 00                	push   $0x0
  801e7f:	ff 75 10             	pushl  0x10(%ebp)
  801e82:	ff 75 0c             	pushl  0xc(%ebp)
  801e85:	ff 75 08             	pushl  0x8(%ebp)
  801e88:	6a 12                	push   $0x12
  801e8a:	e8 e8 fa ff ff       	call   801977 <syscall>
  801e8f:	83 c4 18             	add    $0x18,%esp
	return ;
  801e92:	90                   	nop
}
  801e93:	c9                   	leave  
  801e94:	c3                   	ret    

00801e95 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  801e95:	55                   	push   %ebp
  801e96:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  801e98:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e9b:	8b 45 08             	mov    0x8(%ebp),%eax
  801e9e:	6a 00                	push   $0x0
  801ea0:	6a 00                	push   $0x0
  801ea2:	6a 00                	push   $0x0
  801ea4:	52                   	push   %edx
  801ea5:	50                   	push   %eax
  801ea6:	6a 2a                	push   $0x2a
  801ea8:	e8 ca fa ff ff       	call   801977 <syscall>
  801ead:	83 c4 18             	add    $0x18,%esp
	return;
  801eb0:	90                   	nop
}
  801eb1:	c9                   	leave  
  801eb2:	c3                   	ret    

00801eb3 <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  801eb3:	55                   	push   %ebp
  801eb4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  801eb6:	6a 00                	push   $0x0
  801eb8:	6a 00                	push   $0x0
  801eba:	6a 00                	push   $0x0
  801ebc:	6a 00                	push   $0x0
  801ebe:	6a 00                	push   $0x0
  801ec0:	6a 2b                	push   $0x2b
  801ec2:	e8 b0 fa ff ff       	call   801977 <syscall>
  801ec7:	83 c4 18             	add    $0x18,%esp
}
  801eca:	c9                   	leave  
  801ecb:	c3                   	ret    

00801ecc <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801ecc:	55                   	push   %ebp
  801ecd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801ecf:	6a 00                	push   $0x0
  801ed1:	6a 00                	push   $0x0
  801ed3:	6a 00                	push   $0x0
  801ed5:	ff 75 0c             	pushl  0xc(%ebp)
  801ed8:	ff 75 08             	pushl  0x8(%ebp)
  801edb:	6a 2d                	push   $0x2d
  801edd:	e8 95 fa ff ff       	call   801977 <syscall>
  801ee2:	83 c4 18             	add    $0x18,%esp
	return;
  801ee5:	90                   	nop
}
  801ee6:	c9                   	leave  
  801ee7:	c3                   	ret    

00801ee8 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801ee8:	55                   	push   %ebp
  801ee9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801eeb:	6a 00                	push   $0x0
  801eed:	6a 00                	push   $0x0
  801eef:	6a 00                	push   $0x0
  801ef1:	ff 75 0c             	pushl  0xc(%ebp)
  801ef4:	ff 75 08             	pushl  0x8(%ebp)
  801ef7:	6a 2c                	push   $0x2c
  801ef9:	e8 79 fa ff ff       	call   801977 <syscall>
  801efe:	83 c4 18             	add    $0x18,%esp
	return ;
  801f01:	90                   	nop
}
  801f02:	c9                   	leave  
  801f03:	c3                   	ret    

00801f04 <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  801f04:	55                   	push   %ebp
  801f05:	89 e5                	mov    %esp,%ebp
	//TODO: [PROJECT'25.IM#4] CPU SCHEDULING - #1 System Calls - Add suitable code here
	//Your code is here
	//Comment the following line
	//panic("sys_env_set_priority() is not implemented yet...!!");
	syscall(SYS_env_set_priority, envID, priority, 0, 0, 0);
  801f07:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f0a:	8b 45 08             	mov    0x8(%ebp),%eax
  801f0d:	6a 00                	push   $0x0
  801f0f:	6a 00                	push   $0x0
  801f11:	6a 00                	push   $0x0
  801f13:	52                   	push   %edx
  801f14:	50                   	push   %eax
  801f15:	6a 2e                	push   $0x2e
  801f17:	e8 5b fa ff ff       	call   801977 <syscall>
  801f1c:	83 c4 18             	add    $0x18,%esp
	    return;
  801f1f:	90                   	nop
}
  801f20:	c9                   	leave  
  801f21:	c3                   	ret    
  801f22:	66 90                	xchg   %ax,%ax

00801f24 <__udivdi3>:
  801f24:	55                   	push   %ebp
  801f25:	57                   	push   %edi
  801f26:	56                   	push   %esi
  801f27:	53                   	push   %ebx
  801f28:	83 ec 1c             	sub    $0x1c,%esp
  801f2b:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801f2f:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801f33:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801f37:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801f3b:	89 ca                	mov    %ecx,%edx
  801f3d:	89 f8                	mov    %edi,%eax
  801f3f:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801f43:	85 f6                	test   %esi,%esi
  801f45:	75 2d                	jne    801f74 <__udivdi3+0x50>
  801f47:	39 cf                	cmp    %ecx,%edi
  801f49:	77 65                	ja     801fb0 <__udivdi3+0x8c>
  801f4b:	89 fd                	mov    %edi,%ebp
  801f4d:	85 ff                	test   %edi,%edi
  801f4f:	75 0b                	jne    801f5c <__udivdi3+0x38>
  801f51:	b8 01 00 00 00       	mov    $0x1,%eax
  801f56:	31 d2                	xor    %edx,%edx
  801f58:	f7 f7                	div    %edi
  801f5a:	89 c5                	mov    %eax,%ebp
  801f5c:	31 d2                	xor    %edx,%edx
  801f5e:	89 c8                	mov    %ecx,%eax
  801f60:	f7 f5                	div    %ebp
  801f62:	89 c1                	mov    %eax,%ecx
  801f64:	89 d8                	mov    %ebx,%eax
  801f66:	f7 f5                	div    %ebp
  801f68:	89 cf                	mov    %ecx,%edi
  801f6a:	89 fa                	mov    %edi,%edx
  801f6c:	83 c4 1c             	add    $0x1c,%esp
  801f6f:	5b                   	pop    %ebx
  801f70:	5e                   	pop    %esi
  801f71:	5f                   	pop    %edi
  801f72:	5d                   	pop    %ebp
  801f73:	c3                   	ret    
  801f74:	39 ce                	cmp    %ecx,%esi
  801f76:	77 28                	ja     801fa0 <__udivdi3+0x7c>
  801f78:	0f bd fe             	bsr    %esi,%edi
  801f7b:	83 f7 1f             	xor    $0x1f,%edi
  801f7e:	75 40                	jne    801fc0 <__udivdi3+0x9c>
  801f80:	39 ce                	cmp    %ecx,%esi
  801f82:	72 0a                	jb     801f8e <__udivdi3+0x6a>
  801f84:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801f88:	0f 87 9e 00 00 00    	ja     80202c <__udivdi3+0x108>
  801f8e:	b8 01 00 00 00       	mov    $0x1,%eax
  801f93:	89 fa                	mov    %edi,%edx
  801f95:	83 c4 1c             	add    $0x1c,%esp
  801f98:	5b                   	pop    %ebx
  801f99:	5e                   	pop    %esi
  801f9a:	5f                   	pop    %edi
  801f9b:	5d                   	pop    %ebp
  801f9c:	c3                   	ret    
  801f9d:	8d 76 00             	lea    0x0(%esi),%esi
  801fa0:	31 ff                	xor    %edi,%edi
  801fa2:	31 c0                	xor    %eax,%eax
  801fa4:	89 fa                	mov    %edi,%edx
  801fa6:	83 c4 1c             	add    $0x1c,%esp
  801fa9:	5b                   	pop    %ebx
  801faa:	5e                   	pop    %esi
  801fab:	5f                   	pop    %edi
  801fac:	5d                   	pop    %ebp
  801fad:	c3                   	ret    
  801fae:	66 90                	xchg   %ax,%ax
  801fb0:	89 d8                	mov    %ebx,%eax
  801fb2:	f7 f7                	div    %edi
  801fb4:	31 ff                	xor    %edi,%edi
  801fb6:	89 fa                	mov    %edi,%edx
  801fb8:	83 c4 1c             	add    $0x1c,%esp
  801fbb:	5b                   	pop    %ebx
  801fbc:	5e                   	pop    %esi
  801fbd:	5f                   	pop    %edi
  801fbe:	5d                   	pop    %ebp
  801fbf:	c3                   	ret    
  801fc0:	bd 20 00 00 00       	mov    $0x20,%ebp
  801fc5:	89 eb                	mov    %ebp,%ebx
  801fc7:	29 fb                	sub    %edi,%ebx
  801fc9:	89 f9                	mov    %edi,%ecx
  801fcb:	d3 e6                	shl    %cl,%esi
  801fcd:	89 c5                	mov    %eax,%ebp
  801fcf:	88 d9                	mov    %bl,%cl
  801fd1:	d3 ed                	shr    %cl,%ebp
  801fd3:	89 e9                	mov    %ebp,%ecx
  801fd5:	09 f1                	or     %esi,%ecx
  801fd7:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801fdb:	89 f9                	mov    %edi,%ecx
  801fdd:	d3 e0                	shl    %cl,%eax
  801fdf:	89 c5                	mov    %eax,%ebp
  801fe1:	89 d6                	mov    %edx,%esi
  801fe3:	88 d9                	mov    %bl,%cl
  801fe5:	d3 ee                	shr    %cl,%esi
  801fe7:	89 f9                	mov    %edi,%ecx
  801fe9:	d3 e2                	shl    %cl,%edx
  801feb:	8b 44 24 08          	mov    0x8(%esp),%eax
  801fef:	88 d9                	mov    %bl,%cl
  801ff1:	d3 e8                	shr    %cl,%eax
  801ff3:	09 c2                	or     %eax,%edx
  801ff5:	89 d0                	mov    %edx,%eax
  801ff7:	89 f2                	mov    %esi,%edx
  801ff9:	f7 74 24 0c          	divl   0xc(%esp)
  801ffd:	89 d6                	mov    %edx,%esi
  801fff:	89 c3                	mov    %eax,%ebx
  802001:	f7 e5                	mul    %ebp
  802003:	39 d6                	cmp    %edx,%esi
  802005:	72 19                	jb     802020 <__udivdi3+0xfc>
  802007:	74 0b                	je     802014 <__udivdi3+0xf0>
  802009:	89 d8                	mov    %ebx,%eax
  80200b:	31 ff                	xor    %edi,%edi
  80200d:	e9 58 ff ff ff       	jmp    801f6a <__udivdi3+0x46>
  802012:	66 90                	xchg   %ax,%ax
  802014:	8b 54 24 08          	mov    0x8(%esp),%edx
  802018:	89 f9                	mov    %edi,%ecx
  80201a:	d3 e2                	shl    %cl,%edx
  80201c:	39 c2                	cmp    %eax,%edx
  80201e:	73 e9                	jae    802009 <__udivdi3+0xe5>
  802020:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802023:	31 ff                	xor    %edi,%edi
  802025:	e9 40 ff ff ff       	jmp    801f6a <__udivdi3+0x46>
  80202a:	66 90                	xchg   %ax,%ax
  80202c:	31 c0                	xor    %eax,%eax
  80202e:	e9 37 ff ff ff       	jmp    801f6a <__udivdi3+0x46>
  802033:	90                   	nop

00802034 <__umoddi3>:
  802034:	55                   	push   %ebp
  802035:	57                   	push   %edi
  802036:	56                   	push   %esi
  802037:	53                   	push   %ebx
  802038:	83 ec 1c             	sub    $0x1c,%esp
  80203b:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80203f:	8b 74 24 34          	mov    0x34(%esp),%esi
  802043:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802047:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80204b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80204f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802053:	89 f3                	mov    %esi,%ebx
  802055:	89 fa                	mov    %edi,%edx
  802057:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80205b:	89 34 24             	mov    %esi,(%esp)
  80205e:	85 c0                	test   %eax,%eax
  802060:	75 1a                	jne    80207c <__umoddi3+0x48>
  802062:	39 f7                	cmp    %esi,%edi
  802064:	0f 86 a2 00 00 00    	jbe    80210c <__umoddi3+0xd8>
  80206a:	89 c8                	mov    %ecx,%eax
  80206c:	89 f2                	mov    %esi,%edx
  80206e:	f7 f7                	div    %edi
  802070:	89 d0                	mov    %edx,%eax
  802072:	31 d2                	xor    %edx,%edx
  802074:	83 c4 1c             	add    $0x1c,%esp
  802077:	5b                   	pop    %ebx
  802078:	5e                   	pop    %esi
  802079:	5f                   	pop    %edi
  80207a:	5d                   	pop    %ebp
  80207b:	c3                   	ret    
  80207c:	39 f0                	cmp    %esi,%eax
  80207e:	0f 87 ac 00 00 00    	ja     802130 <__umoddi3+0xfc>
  802084:	0f bd e8             	bsr    %eax,%ebp
  802087:	83 f5 1f             	xor    $0x1f,%ebp
  80208a:	0f 84 ac 00 00 00    	je     80213c <__umoddi3+0x108>
  802090:	bf 20 00 00 00       	mov    $0x20,%edi
  802095:	29 ef                	sub    %ebp,%edi
  802097:	89 fe                	mov    %edi,%esi
  802099:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80209d:	89 e9                	mov    %ebp,%ecx
  80209f:	d3 e0                	shl    %cl,%eax
  8020a1:	89 d7                	mov    %edx,%edi
  8020a3:	89 f1                	mov    %esi,%ecx
  8020a5:	d3 ef                	shr    %cl,%edi
  8020a7:	09 c7                	or     %eax,%edi
  8020a9:	89 e9                	mov    %ebp,%ecx
  8020ab:	d3 e2                	shl    %cl,%edx
  8020ad:	89 14 24             	mov    %edx,(%esp)
  8020b0:	89 d8                	mov    %ebx,%eax
  8020b2:	d3 e0                	shl    %cl,%eax
  8020b4:	89 c2                	mov    %eax,%edx
  8020b6:	8b 44 24 08          	mov    0x8(%esp),%eax
  8020ba:	d3 e0                	shl    %cl,%eax
  8020bc:	89 44 24 04          	mov    %eax,0x4(%esp)
  8020c0:	8b 44 24 08          	mov    0x8(%esp),%eax
  8020c4:	89 f1                	mov    %esi,%ecx
  8020c6:	d3 e8                	shr    %cl,%eax
  8020c8:	09 d0                	or     %edx,%eax
  8020ca:	d3 eb                	shr    %cl,%ebx
  8020cc:	89 da                	mov    %ebx,%edx
  8020ce:	f7 f7                	div    %edi
  8020d0:	89 d3                	mov    %edx,%ebx
  8020d2:	f7 24 24             	mull   (%esp)
  8020d5:	89 c6                	mov    %eax,%esi
  8020d7:	89 d1                	mov    %edx,%ecx
  8020d9:	39 d3                	cmp    %edx,%ebx
  8020db:	0f 82 87 00 00 00    	jb     802168 <__umoddi3+0x134>
  8020e1:	0f 84 91 00 00 00    	je     802178 <__umoddi3+0x144>
  8020e7:	8b 54 24 04          	mov    0x4(%esp),%edx
  8020eb:	29 f2                	sub    %esi,%edx
  8020ed:	19 cb                	sbb    %ecx,%ebx
  8020ef:	89 d8                	mov    %ebx,%eax
  8020f1:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8020f5:	d3 e0                	shl    %cl,%eax
  8020f7:	89 e9                	mov    %ebp,%ecx
  8020f9:	d3 ea                	shr    %cl,%edx
  8020fb:	09 d0                	or     %edx,%eax
  8020fd:	89 e9                	mov    %ebp,%ecx
  8020ff:	d3 eb                	shr    %cl,%ebx
  802101:	89 da                	mov    %ebx,%edx
  802103:	83 c4 1c             	add    $0x1c,%esp
  802106:	5b                   	pop    %ebx
  802107:	5e                   	pop    %esi
  802108:	5f                   	pop    %edi
  802109:	5d                   	pop    %ebp
  80210a:	c3                   	ret    
  80210b:	90                   	nop
  80210c:	89 fd                	mov    %edi,%ebp
  80210e:	85 ff                	test   %edi,%edi
  802110:	75 0b                	jne    80211d <__umoddi3+0xe9>
  802112:	b8 01 00 00 00       	mov    $0x1,%eax
  802117:	31 d2                	xor    %edx,%edx
  802119:	f7 f7                	div    %edi
  80211b:	89 c5                	mov    %eax,%ebp
  80211d:	89 f0                	mov    %esi,%eax
  80211f:	31 d2                	xor    %edx,%edx
  802121:	f7 f5                	div    %ebp
  802123:	89 c8                	mov    %ecx,%eax
  802125:	f7 f5                	div    %ebp
  802127:	89 d0                	mov    %edx,%eax
  802129:	e9 44 ff ff ff       	jmp    802072 <__umoddi3+0x3e>
  80212e:	66 90                	xchg   %ax,%ax
  802130:	89 c8                	mov    %ecx,%eax
  802132:	89 f2                	mov    %esi,%edx
  802134:	83 c4 1c             	add    $0x1c,%esp
  802137:	5b                   	pop    %ebx
  802138:	5e                   	pop    %esi
  802139:	5f                   	pop    %edi
  80213a:	5d                   	pop    %ebp
  80213b:	c3                   	ret    
  80213c:	3b 04 24             	cmp    (%esp),%eax
  80213f:	72 06                	jb     802147 <__umoddi3+0x113>
  802141:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  802145:	77 0f                	ja     802156 <__umoddi3+0x122>
  802147:	89 f2                	mov    %esi,%edx
  802149:	29 f9                	sub    %edi,%ecx
  80214b:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  80214f:	89 14 24             	mov    %edx,(%esp)
  802152:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802156:	8b 44 24 04          	mov    0x4(%esp),%eax
  80215a:	8b 14 24             	mov    (%esp),%edx
  80215d:	83 c4 1c             	add    $0x1c,%esp
  802160:	5b                   	pop    %ebx
  802161:	5e                   	pop    %esi
  802162:	5f                   	pop    %edi
  802163:	5d                   	pop    %ebp
  802164:	c3                   	ret    
  802165:	8d 76 00             	lea    0x0(%esi),%esi
  802168:	2b 04 24             	sub    (%esp),%eax
  80216b:	19 fa                	sbb    %edi,%edx
  80216d:	89 d1                	mov    %edx,%ecx
  80216f:	89 c6                	mov    %eax,%esi
  802171:	e9 71 ff ff ff       	jmp    8020e7 <__umoddi3+0xb3>
  802176:	66 90                	xchg   %ax,%ax
  802178:	39 44 24 04          	cmp    %eax,0x4(%esp)
  80217c:	72 ea                	jb     802168 <__umoddi3+0x134>
  80217e:	89 d9                	mov    %ebx,%ecx
  802180:	e9 62 ff ff ff       	jmp    8020e7 <__umoddi3+0xb3>
