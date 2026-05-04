
obj/user/tst_quicksort_freeHeap:     file format elf32-i386


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
  800031:	e8 cf 07 00 00       	call   800805 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
uint32 CheckSorted(int *Elements, int NumOfElements);

int CheckAndCountEmptyLocInWS(volatile struct Env *myEnv);

void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	53                   	push   %ebx
  80003c:	81 ec 44 01 00 00    	sub    $0x144,%esp


	//int InitFreeFrames = sys_calculate_free_frames() ;
	char Line[255] ;
	char Chose ;
	int Iteration = 0 ;
  800042:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	do
	{

		Iteration++ ;
  800049:	ff 45 f0             	incl   -0x10(%ebp)
		//		cprintf("Free Frames Before Allocation = %d\n", sys_calculate_free_frames()) ;

	sys_lock_cons();
  80004c:	e8 fe 36 00 00       	call   80374f <sys_lock_cons>
		readline("Enter the number of elements: ", Line);
  800051:	83 ec 08             	sub    $0x8,%esp
  800054:	8d 85 c5 fe ff ff    	lea    -0x13b(%ebp),%eax
  80005a:	50                   	push   %eax
  80005b:	68 60 4a 80 00       	push   $0x804a60
  800060:	e8 00 13 00 00       	call   801365 <readline>
  800065:	83 c4 10             	add    $0x10,%esp
		int NumOfElements = strtol(Line, NULL, 10) ;
  800068:	83 ec 04             	sub    $0x4,%esp
  80006b:	6a 0a                	push   $0xa
  80006d:	6a 00                	push   $0x0
  80006f:	8d 85 c5 fe ff ff    	lea    -0x13b(%ebp),%eax
  800075:	50                   	push   %eax
  800076:	e8 01 19 00 00       	call   80197c <strtol>
  80007b:	83 c4 10             	add    $0x10,%esp
  80007e:	89 45 ec             	mov    %eax,-0x14(%ebp)

		int *Elements = malloc(sizeof(int) * NumOfElements) ;
  800081:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800084:	c1 e0 02             	shl    $0x2,%eax
  800087:	83 ec 0c             	sub    $0xc,%esp
  80008a:	50                   	push   %eax
  80008b:	e8 1d 1e 00 00       	call   801ead <malloc>
  800090:	83 c4 10             	add    $0x10,%esp
  800093:	89 45 e8             	mov    %eax,-0x18(%ebp)
		uint32 num_disk_tables = 1;  //Since it is created with the first array, so it will be decremented in the 1st case only
  800096:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
		int numOFEmptyLocInWS = CheckAndCountEmptyLocInWS(myEnv);
  80009d:	a1 24 60 80 00       	mov    0x806024,%eax
  8000a2:	83 ec 0c             	sub    $0xc,%esp
  8000a5:	50                   	push   %eax
  8000a6:	e8 88 03 00 00       	call   800433 <CheckAndCountEmptyLocInWS>
  8000ab:	83 c4 10             	add    $0x10,%esp
  8000ae:	89 45 e0             	mov    %eax,-0x20(%ebp)
		int InitFreeFrames = sys_calculate_free_frames() + sys_calculate_modified_frames() - numOFEmptyLocInWS;
  8000b1:	e8 49 37 00 00       	call   8037ff <sys_calculate_free_frames>
  8000b6:	89 c3                	mov    %eax,%ebx
  8000b8:	e8 5b 37 00 00       	call   803818 <sys_calculate_modified_frames>
  8000bd:	8d 14 03             	lea    (%ebx,%eax,1),%edx
  8000c0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8000c3:	29 c2                	sub    %eax,%edx
  8000c5:	89 d0                	mov    %edx,%eax
  8000c7:	89 45 dc             	mov    %eax,-0x24(%ebp)

		Elements[NumOfElements] = 10 ;
  8000ca:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8000cd:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8000d4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8000d7:	01 d0                	add    %edx,%eax
  8000d9:	c7 00 0a 00 00 00    	movl   $0xa,(%eax)
		//		cprintf("Free Frames After Allocation = %d\n", sys_calculate_free_frames()) ;
		cprintf("Choose the initialization method:\n") ;
  8000df:	83 ec 0c             	sub    $0xc,%esp
  8000e2:	68 80 4a 80 00       	push   $0x804a80
  8000e7:	e8 a0 0b 00 00       	call   800c8c <cprintf>
  8000ec:	83 c4 10             	add    $0x10,%esp
		cprintf("a) Ascending\n") ;
  8000ef:	83 ec 0c             	sub    $0xc,%esp
  8000f2:	68 a3 4a 80 00       	push   $0x804aa3
  8000f7:	e8 90 0b 00 00       	call   800c8c <cprintf>
  8000fc:	83 c4 10             	add    $0x10,%esp
		cprintf("b) Descending\n") ;
  8000ff:	83 ec 0c             	sub    $0xc,%esp
  800102:	68 b1 4a 80 00       	push   $0x804ab1
  800107:	e8 80 0b 00 00       	call   800c8c <cprintf>
  80010c:	83 c4 10             	add    $0x10,%esp
		cprintf("c) Semi random\n") ;
  80010f:	83 ec 0c             	sub    $0xc,%esp
  800112:	68 c0 4a 80 00       	push   $0x804ac0
  800117:	e8 70 0b 00 00       	call   800c8c <cprintf>
  80011c:	83 c4 10             	add    $0x10,%esp
		do
		{
			cprintf("Select: ") ;
  80011f:	83 ec 0c             	sub    $0xc,%esp
  800122:	68 d0 4a 80 00       	push   $0x804ad0
  800127:	e8 60 0b 00 00       	call   800c8c <cprintf>
  80012c:	83 c4 10             	add    $0x10,%esp
			Chose = getchar() ;
  80012f:	e8 b4 06 00 00       	call   8007e8 <getchar>
  800134:	88 45 f7             	mov    %al,-0x9(%ebp)
			cputchar(Chose);
  800137:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  80013b:	83 ec 0c             	sub    $0xc,%esp
  80013e:	50                   	push   %eax
  80013f:	e8 85 06 00 00       	call   8007c9 <cputchar>
  800144:	83 c4 10             	add    $0x10,%esp
			cputchar('\n');
  800147:	83 ec 0c             	sub    $0xc,%esp
  80014a:	6a 0a                	push   $0xa
  80014c:	e8 78 06 00 00       	call   8007c9 <cputchar>
  800151:	83 c4 10             	add    $0x10,%esp
		} while (Chose != 'a' && Chose != 'b' && Chose != 'c');
  800154:	80 7d f7 61          	cmpb   $0x61,-0x9(%ebp)
  800158:	74 0c                	je     800166 <_main+0x12e>
  80015a:	80 7d f7 62          	cmpb   $0x62,-0x9(%ebp)
  80015e:	74 06                	je     800166 <_main+0x12e>
  800160:	80 7d f7 63          	cmpb   $0x63,-0x9(%ebp)
  800164:	75 b9                	jne    80011f <_main+0xe7>
	sys_unlock_cons();
  800166:	e8 fe 35 00 00       	call   803769 <sys_unlock_cons>
		int  i ;
		switch (Chose)
  80016b:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  80016f:	83 f8 62             	cmp    $0x62,%eax
  800172:	74 1d                	je     800191 <_main+0x159>
  800174:	83 f8 63             	cmp    $0x63,%eax
  800177:	74 2b                	je     8001a4 <_main+0x16c>
  800179:	83 f8 61             	cmp    $0x61,%eax
  80017c:	75 39                	jne    8001b7 <_main+0x17f>
		{
		case 'a':
			InitializeAscending(Elements, NumOfElements);
  80017e:	83 ec 08             	sub    $0x8,%esp
  800181:	ff 75 ec             	pushl  -0x14(%ebp)
  800184:	ff 75 e8             	pushl  -0x18(%ebp)
  800187:	e8 05 05 00 00       	call   800691 <InitializeAscending>
  80018c:	83 c4 10             	add    $0x10,%esp
			break ;
  80018f:	eb 37                	jmp    8001c8 <_main+0x190>
		case 'b':
			InitializeIdentical(Elements, NumOfElements);
  800191:	83 ec 08             	sub    $0x8,%esp
  800194:	ff 75 ec             	pushl  -0x14(%ebp)
  800197:	ff 75 e8             	pushl  -0x18(%ebp)
  80019a:	e8 23 05 00 00       	call   8006c2 <InitializeIdentical>
  80019f:	83 c4 10             	add    $0x10,%esp
			break ;
  8001a2:	eb 24                	jmp    8001c8 <_main+0x190>
		case 'c':
			InitializeSemiRandom(Elements, NumOfElements);
  8001a4:	83 ec 08             	sub    $0x8,%esp
  8001a7:	ff 75 ec             	pushl  -0x14(%ebp)
  8001aa:	ff 75 e8             	pushl  -0x18(%ebp)
  8001ad:	e8 45 05 00 00       	call   8006f7 <InitializeSemiRandom>
  8001b2:	83 c4 10             	add    $0x10,%esp
			break ;
  8001b5:	eb 11                	jmp    8001c8 <_main+0x190>
		default:
			InitializeSemiRandom(Elements, NumOfElements);
  8001b7:	83 ec 08             	sub    $0x8,%esp
  8001ba:	ff 75 ec             	pushl  -0x14(%ebp)
  8001bd:	ff 75 e8             	pushl  -0x18(%ebp)
  8001c0:	e8 32 05 00 00       	call   8006f7 <InitializeSemiRandom>
  8001c5:	83 c4 10             	add    $0x10,%esp
		}

		QuickSort(Elements, NumOfElements);
  8001c8:	83 ec 08             	sub    $0x8,%esp
  8001cb:	ff 75 ec             	pushl  -0x14(%ebp)
  8001ce:	ff 75 e8             	pushl  -0x18(%ebp)
  8001d1:	e8 00 03 00 00       	call   8004d6 <QuickSort>
  8001d6:	83 c4 10             	add    $0x10,%esp

		//		PrintElements(Elements, NumOfElements);

		uint32 Sorted = CheckSorted(Elements, NumOfElements);
  8001d9:	83 ec 08             	sub    $0x8,%esp
  8001dc:	ff 75 ec             	pushl  -0x14(%ebp)
  8001df:	ff 75 e8             	pushl  -0x18(%ebp)
  8001e2:	e8 00 04 00 00       	call   8005e7 <CheckSorted>
  8001e7:	83 c4 10             	add    $0x10,%esp
  8001ea:	89 45 d8             	mov    %eax,-0x28(%ebp)

		if(Sorted == 0) panic("The array is NOT sorted correctly") ;
  8001ed:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8001f1:	75 14                	jne    800207 <_main+0x1cf>
  8001f3:	83 ec 04             	sub    $0x4,%esp
  8001f6:	68 dc 4a 80 00       	push   $0x804adc
  8001fb:	6a 57                	push   $0x57
  8001fd:	68 fe 4a 80 00       	push   $0x804afe
  800202:	e8 b7 07 00 00       	call   8009be <_panic>
		else
		{
			cprintf("===============================================\n") ;
  800207:	83 ec 0c             	sub    $0xc,%esp
  80020a:	68 1c 4b 80 00       	push   $0x804b1c
  80020f:	e8 78 0a 00 00       	call   800c8c <cprintf>
  800214:	83 c4 10             	add    $0x10,%esp
			cprintf("Congratulations!! The array is sorted correctly\n") ;
  800217:	83 ec 0c             	sub    $0xc,%esp
  80021a:	68 50 4b 80 00       	push   $0x804b50
  80021f:	e8 68 0a 00 00       	call   800c8c <cprintf>
  800224:	83 c4 10             	add    $0x10,%esp
			cprintf("===============================================\n\n") ;
  800227:	83 ec 0c             	sub    $0xc,%esp
  80022a:	68 84 4b 80 00       	push   $0x804b84
  80022f:	e8 58 0a 00 00       	call   800c8c <cprintf>
  800234:	83 c4 10             	add    $0x10,%esp
		}

		//		cprintf("Free Frames After Calculation = %d\n", sys_calculate_free_frames()) ;

		cprintf("Freeing the Heap...\n\n") ;
  800237:	83 ec 0c             	sub    $0xc,%esp
  80023a:	68 b6 4b 80 00       	push   $0x804bb6
  80023f:	e8 48 0a 00 00       	call   800c8c <cprintf>
  800244:	83 c4 10             	add    $0x10,%esp
		free(Elements) ;
  800247:	83 ec 0c             	sub    $0xc,%esp
  80024a:	ff 75 e8             	pushl  -0x18(%ebp)
  80024d:	e8 59 21 00 00       	call   8023ab <free>
  800252:	83 c4 10             	add    $0x10,%esp


		///Testing the freeHeap according to the specified scenario
		if (Iteration == 1)
  800255:	83 7d f0 01          	cmpl   $0x1,-0x10(%ebp)
  800259:	75 7b                	jne    8002d6 <_main+0x29e>
		{
			InitFreeFrames -= num_disk_tables;
  80025b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80025e:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  800261:	89 45 dc             	mov    %eax,-0x24(%ebp)
			if (!(NumOfElements == 1000 && Chose == 'a'))
  800264:	81 7d ec e8 03 00 00 	cmpl   $0x3e8,-0x14(%ebp)
  80026b:	75 06                	jne    800273 <_main+0x23b>
  80026d:	80 7d f7 61          	cmpb   $0x61,-0x9(%ebp)
  800271:	74 14                	je     800287 <_main+0x24f>
				panic("Please ensure the number of elements and the initialization method of this test");
  800273:	83 ec 04             	sub    $0x4,%esp
  800276:	68 cc 4b 80 00       	push   $0x804bcc
  80027b:	6a 6a                	push   $0x6a
  80027d:	68 fe 4a 80 00       	push   $0x804afe
  800282:	e8 37 07 00 00       	call   8009be <_panic>

			numOFEmptyLocInWS = CheckAndCountEmptyLocInWS(myEnv);
  800287:	a1 24 60 80 00       	mov    0x806024,%eax
  80028c:	83 ec 0c             	sub    $0xc,%esp
  80028f:	50                   	push   %eax
  800290:	e8 9e 01 00 00       	call   800433 <CheckAndCountEmptyLocInWS>
  800295:	83 c4 10             	add    $0x10,%esp
  800298:	89 45 e0             	mov    %eax,-0x20(%ebp)
			int CurrFreeFrames = sys_calculate_free_frames() + sys_calculate_modified_frames() - numOFEmptyLocInWS;
  80029b:	e8 5f 35 00 00       	call   8037ff <sys_calculate_free_frames>
  8002a0:	89 c3                	mov    %eax,%ebx
  8002a2:	e8 71 35 00 00       	call   803818 <sys_calculate_modified_frames>
  8002a7:	8d 14 03             	lea    (%ebx,%eax,1),%edx
  8002aa:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8002ad:	29 c2                	sub    %eax,%edx
  8002af:	89 d0                	mov    %edx,%eax
  8002b1:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			assert(CurrFreeFrames - InitFreeFrames == 0) ;
  8002b4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8002b7:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8002ba:	0f 84 05 01 00 00    	je     8003c5 <_main+0x38d>
  8002c0:	68 1c 4c 80 00       	push   $0x804c1c
  8002c5:	68 41 4c 80 00       	push   $0x804c41
  8002ca:	6a 6e                	push   $0x6e
  8002cc:	68 fe 4a 80 00       	push   $0x804afe
  8002d1:	e8 e8 06 00 00       	call   8009be <_panic>
		}
		else if (Iteration == 2 )
  8002d6:	83 7d f0 02          	cmpl   $0x2,-0x10(%ebp)
  8002da:	75 72                	jne    80034e <_main+0x316>
		{
			if (!(NumOfElements == 5000 && Chose == 'b'))
  8002dc:	81 7d ec 88 13 00 00 	cmpl   $0x1388,-0x14(%ebp)
  8002e3:	75 06                	jne    8002eb <_main+0x2b3>
  8002e5:	80 7d f7 62          	cmpb   $0x62,-0x9(%ebp)
  8002e9:	74 14                	je     8002ff <_main+0x2c7>
				panic("Please ensure the number of elements and the initialization method of this test");
  8002eb:	83 ec 04             	sub    $0x4,%esp
  8002ee:	68 cc 4b 80 00       	push   $0x804bcc
  8002f3:	6a 73                	push   $0x73
  8002f5:	68 fe 4a 80 00       	push   $0x804afe
  8002fa:	e8 bf 06 00 00       	call   8009be <_panic>

			int numOFEmptyLocInWS = CheckAndCountEmptyLocInWS(myEnv);
  8002ff:	a1 24 60 80 00       	mov    0x806024,%eax
  800304:	83 ec 0c             	sub    $0xc,%esp
  800307:	50                   	push   %eax
  800308:	e8 26 01 00 00       	call   800433 <CheckAndCountEmptyLocInWS>
  80030d:	83 c4 10             	add    $0x10,%esp
  800310:	89 45 d0             	mov    %eax,-0x30(%ebp)
			int CurrFreeFrames = sys_calculate_free_frames() + sys_calculate_modified_frames() - numOFEmptyLocInWS;
  800313:	e8 e7 34 00 00       	call   8037ff <sys_calculate_free_frames>
  800318:	89 c3                	mov    %eax,%ebx
  80031a:	e8 f9 34 00 00       	call   803818 <sys_calculate_modified_frames>
  80031f:	8d 14 03             	lea    (%ebx,%eax,1),%edx
  800322:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800325:	29 c2                	sub    %eax,%edx
  800327:	89 d0                	mov    %edx,%eax
  800329:	89 45 cc             	mov    %eax,-0x34(%ebp)
			assert(CurrFreeFrames - InitFreeFrames == 0) ;
  80032c:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80032f:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800332:	0f 84 8d 00 00 00    	je     8003c5 <_main+0x38d>
  800338:	68 1c 4c 80 00       	push   $0x804c1c
  80033d:	68 41 4c 80 00       	push   $0x804c41
  800342:	6a 77                	push   $0x77
  800344:	68 fe 4a 80 00       	push   $0x804afe
  800349:	e8 70 06 00 00       	call   8009be <_panic>
		}
		else if (Iteration == 3 )
  80034e:	83 7d f0 03          	cmpl   $0x3,-0x10(%ebp)
  800352:	75 71                	jne    8003c5 <_main+0x38d>
		{
			if (!(NumOfElements == 300000 && Chose == 'c'))
  800354:	81 7d ec e0 93 04 00 	cmpl   $0x493e0,-0x14(%ebp)
  80035b:	75 06                	jne    800363 <_main+0x32b>
  80035d:	80 7d f7 63          	cmpb   $0x63,-0x9(%ebp)
  800361:	74 14                	je     800377 <_main+0x33f>
				panic("Please ensure the number of elements and the initialization method of this test");
  800363:	83 ec 04             	sub    $0x4,%esp
  800366:	68 cc 4b 80 00       	push   $0x804bcc
  80036b:	6a 7c                	push   $0x7c
  80036d:	68 fe 4a 80 00       	push   $0x804afe
  800372:	e8 47 06 00 00       	call   8009be <_panic>

			int numOFEmptyLocInWS = CheckAndCountEmptyLocInWS(myEnv);
  800377:	a1 24 60 80 00       	mov    0x806024,%eax
  80037c:	83 ec 0c             	sub    $0xc,%esp
  80037f:	50                   	push   %eax
  800380:	e8 ae 00 00 00       	call   800433 <CheckAndCountEmptyLocInWS>
  800385:	83 c4 10             	add    $0x10,%esp
  800388:	89 45 c8             	mov    %eax,-0x38(%ebp)
			int CurrFreeFrames = sys_calculate_free_frames() + sys_calculate_modified_frames() - numOFEmptyLocInWS;
  80038b:	e8 6f 34 00 00       	call   8037ff <sys_calculate_free_frames>
  800390:	89 c3                	mov    %eax,%ebx
  800392:	e8 81 34 00 00       	call   803818 <sys_calculate_modified_frames>
  800397:	8d 14 03             	lea    (%ebx,%eax,1),%edx
  80039a:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80039d:	29 c2                	sub    %eax,%edx
  80039f:	89 d0                	mov    %edx,%eax
  8003a1:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			//cprintf("numOFEmptyLocInWS = %d\n", numOFEmptyLocInWS );
			assert(CurrFreeFrames - InitFreeFrames == 0) ;
  8003a4:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8003a7:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8003aa:	74 19                	je     8003c5 <_main+0x38d>
  8003ac:	68 1c 4c 80 00       	push   $0x804c1c
  8003b1:	68 41 4c 80 00       	push   $0x804c41
  8003b6:	68 81 00 00 00       	push   $0x81
  8003bb:	68 fe 4a 80 00       	push   $0x804afe
  8003c0:	e8 f9 05 00 00       	call   8009be <_panic>
		}
		///========================================================================
	sys_lock_cons();
  8003c5:	e8 85 33 00 00       	call   80374f <sys_lock_cons>
		Chose = 0 ;
  8003ca:	c6 45 f7 00          	movb   $0x0,-0x9(%ebp)
		while (Chose != 'y' && Chose != 'n')
  8003ce:	eb 42                	jmp    800412 <_main+0x3da>
		{
			cprintf("Do you want to repeat (y/n): ") ;
  8003d0:	83 ec 0c             	sub    $0xc,%esp
  8003d3:	68 56 4c 80 00       	push   $0x804c56
  8003d8:	e8 af 08 00 00       	call   800c8c <cprintf>
  8003dd:	83 c4 10             	add    $0x10,%esp
			Chose = getchar() ;
  8003e0:	e8 03 04 00 00       	call   8007e8 <getchar>
  8003e5:	88 45 f7             	mov    %al,-0x9(%ebp)
			cputchar(Chose);
  8003e8:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  8003ec:	83 ec 0c             	sub    $0xc,%esp
  8003ef:	50                   	push   %eax
  8003f0:	e8 d4 03 00 00       	call   8007c9 <cputchar>
  8003f5:	83 c4 10             	add    $0x10,%esp
			cputchar('\n');
  8003f8:	83 ec 0c             	sub    $0xc,%esp
  8003fb:	6a 0a                	push   $0xa
  8003fd:	e8 c7 03 00 00       	call   8007c9 <cputchar>
  800402:	83 c4 10             	add    $0x10,%esp
			cputchar('\n');
  800405:	83 ec 0c             	sub    $0xc,%esp
  800408:	6a 0a                	push   $0xa
  80040a:	e8 ba 03 00 00       	call   8007c9 <cputchar>
  80040f:	83 c4 10             	add    $0x10,%esp
			assert(CurrFreeFrames - InitFreeFrames == 0) ;
		}
		///========================================================================
	sys_lock_cons();
		Chose = 0 ;
		while (Chose != 'y' && Chose != 'n')
  800412:	80 7d f7 79          	cmpb   $0x79,-0x9(%ebp)
  800416:	74 06                	je     80041e <_main+0x3e6>
  800418:	80 7d f7 6e          	cmpb   $0x6e,-0x9(%ebp)
  80041c:	75 b2                	jne    8003d0 <_main+0x398>
			Chose = getchar() ;
			cputchar(Chose);
			cputchar('\n');
			cputchar('\n');
		}
	sys_unlock_cons();
  80041e:	e8 46 33 00 00       	call   803769 <sys_unlock_cons>

	} while (Chose == 'y');
  800423:	80 7d f7 79          	cmpb   $0x79,-0x9(%ebp)
  800427:	0f 84 1c fc ff ff    	je     800049 <_main+0x11>
}
  80042d:	90                   	nop
  80042e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800431:	c9                   	leave  
  800432:	c3                   	ret    

00800433 <CheckAndCountEmptyLocInWS>:

int CheckAndCountEmptyLocInWS(volatile struct Env *myEnv)
{
  800433:	55                   	push   %ebp
  800434:	89 e5                	mov    %esp,%ebp
  800436:	83 ec 18             	sub    $0x18,%esp
	int numOFEmptyLocInWS = 0, i;
  800439:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (i = 0 ; i < myEnv->page_WS_max_size; i++)
  800440:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800447:	eb 74                	jmp    8004bd <CheckAndCountEmptyLocInWS+0x8a>
	{
		if (myEnv->__uptr_pws[i].empty)
  800449:	8b 45 08             	mov    0x8(%ebp),%eax
  80044c:	8b 88 a4 05 00 00    	mov    0x5a4(%eax),%ecx
  800452:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800455:	89 d0                	mov    %edx,%eax
  800457:	01 c0                	add    %eax,%eax
  800459:	01 d0                	add    %edx,%eax
  80045b:	c1 e0 03             	shl    $0x3,%eax
  80045e:	01 c8                	add    %ecx,%eax
  800460:	8a 40 04             	mov    0x4(%eax),%al
  800463:	84 c0                	test   %al,%al
  800465:	74 05                	je     80046c <CheckAndCountEmptyLocInWS+0x39>
		{
			numOFEmptyLocInWS++;
  800467:	ff 45 f4             	incl   -0xc(%ebp)
  80046a:	eb 4e                	jmp    8004ba <CheckAndCountEmptyLocInWS+0x87>
		}
		else
		{
			uint32 va = ROUNDDOWN(myEnv->__uptr_pws[i].virtual_address,PAGE_SIZE) ;
  80046c:	8b 45 08             	mov    0x8(%ebp),%eax
  80046f:	8b 88 a4 05 00 00    	mov    0x5a4(%eax),%ecx
  800475:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800478:	89 d0                	mov    %edx,%eax
  80047a:	01 c0                	add    %eax,%eax
  80047c:	01 d0                	add    %edx,%eax
  80047e:	c1 e0 03             	shl    $0x3,%eax
  800481:	01 c8                	add    %ecx,%eax
  800483:	8b 00                	mov    (%eax),%eax
  800485:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800488:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80048b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800490:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if (va >= USER_HEAP_START && va < (USER_HEAP_MAX))
  800493:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800496:	85 c0                	test   %eax,%eax
  800498:	79 20                	jns    8004ba <CheckAndCountEmptyLocInWS+0x87>
  80049a:	81 7d e8 ff ff ff 9f 	cmpl   $0x9fffffff,-0x18(%ebp)
  8004a1:	77 17                	ja     8004ba <CheckAndCountEmptyLocInWS+0x87>
				panic("freeMem didn't remove its page(s) from the WS");
  8004a3:	83 ec 04             	sub    $0x4,%esp
  8004a6:	68 74 4c 80 00       	push   $0x804c74
  8004ab:	68 a0 00 00 00       	push   $0xa0
  8004b0:	68 fe 4a 80 00       	push   $0x804afe
  8004b5:	e8 04 05 00 00       	call   8009be <_panic>
}

int CheckAndCountEmptyLocInWS(volatile struct Env *myEnv)
{
	int numOFEmptyLocInWS = 0, i;
	for (i = 0 ; i < myEnv->page_WS_max_size; i++)
  8004ba:	ff 45 f0             	incl   -0x10(%ebp)
  8004bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8004c0:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8004c6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8004c9:	39 c2                	cmp    %eax,%edx
  8004cb:	0f 87 78 ff ff ff    	ja     800449 <CheckAndCountEmptyLocInWS+0x16>
			uint32 va = ROUNDDOWN(myEnv->__uptr_pws[i].virtual_address,PAGE_SIZE) ;
			if (va >= USER_HEAP_START && va < (USER_HEAP_MAX))
				panic("freeMem didn't remove its page(s) from the WS");
		}
	}
	return numOFEmptyLocInWS;
  8004d1:	8b 45 f4             	mov    -0xc(%ebp),%eax

}
  8004d4:	c9                   	leave  
  8004d5:	c3                   	ret    

008004d6 <QuickSort>:

///Quick sort
void QuickSort(int *Elements, int NumOfElements)
{
  8004d6:	55                   	push   %ebp
  8004d7:	89 e5                	mov    %esp,%ebp
  8004d9:	83 ec 08             	sub    $0x8,%esp
	QSort(Elements, NumOfElements, 0, NumOfElements-1) ;
  8004dc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004df:	48                   	dec    %eax
  8004e0:	50                   	push   %eax
  8004e1:	6a 00                	push   $0x0
  8004e3:	ff 75 0c             	pushl  0xc(%ebp)
  8004e6:	ff 75 08             	pushl  0x8(%ebp)
  8004e9:	e8 06 00 00 00       	call   8004f4 <QSort>
  8004ee:	83 c4 10             	add    $0x10,%esp
}
  8004f1:	90                   	nop
  8004f2:	c9                   	leave  
  8004f3:	c3                   	ret    

008004f4 <QSort>:


void QSort(int *Elements,int NumOfElements, int startIndex, int finalIndex)
{
  8004f4:	55                   	push   %ebp
  8004f5:	89 e5                	mov    %esp,%ebp
  8004f7:	83 ec 18             	sub    $0x18,%esp
	if (startIndex >= finalIndex) return;
  8004fa:	8b 45 10             	mov    0x10(%ebp),%eax
  8004fd:	3b 45 14             	cmp    0x14(%ebp),%eax
  800500:	0f 8d de 00 00 00    	jge    8005e4 <QSort+0xf0>

	int i = startIndex+1, j = finalIndex;
  800506:	8b 45 10             	mov    0x10(%ebp),%eax
  800509:	40                   	inc    %eax
  80050a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80050d:	8b 45 14             	mov    0x14(%ebp),%eax
  800510:	89 45 f0             	mov    %eax,-0x10(%ebp)

	while (i <= j)
  800513:	e9 80 00 00 00       	jmp    800598 <QSort+0xa4>
	{
		while (i <= finalIndex && Elements[startIndex] >= Elements[i]) i++;
  800518:	ff 45 f4             	incl   -0xc(%ebp)
  80051b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80051e:	3b 45 14             	cmp    0x14(%ebp),%eax
  800521:	7f 2b                	jg     80054e <QSort+0x5a>
  800523:	8b 45 10             	mov    0x10(%ebp),%eax
  800526:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80052d:	8b 45 08             	mov    0x8(%ebp),%eax
  800530:	01 d0                	add    %edx,%eax
  800532:	8b 10                	mov    (%eax),%edx
  800534:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800537:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80053e:	8b 45 08             	mov    0x8(%ebp),%eax
  800541:	01 c8                	add    %ecx,%eax
  800543:	8b 00                	mov    (%eax),%eax
  800545:	39 c2                	cmp    %eax,%edx
  800547:	7d cf                	jge    800518 <QSort+0x24>
		while (j > startIndex && Elements[startIndex] <= Elements[j]) j--;
  800549:	eb 03                	jmp    80054e <QSort+0x5a>
  80054b:	ff 4d f0             	decl   -0x10(%ebp)
  80054e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800551:	3b 45 10             	cmp    0x10(%ebp),%eax
  800554:	7e 26                	jle    80057c <QSort+0x88>
  800556:	8b 45 10             	mov    0x10(%ebp),%eax
  800559:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800560:	8b 45 08             	mov    0x8(%ebp),%eax
  800563:	01 d0                	add    %edx,%eax
  800565:	8b 10                	mov    (%eax),%edx
  800567:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80056a:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800571:	8b 45 08             	mov    0x8(%ebp),%eax
  800574:	01 c8                	add    %ecx,%eax
  800576:	8b 00                	mov    (%eax),%eax
  800578:	39 c2                	cmp    %eax,%edx
  80057a:	7e cf                	jle    80054b <QSort+0x57>

		if (i <= j)
  80057c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80057f:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800582:	7f 14                	jg     800598 <QSort+0xa4>
		{
			Swap(Elements, i, j);
  800584:	83 ec 04             	sub    $0x4,%esp
  800587:	ff 75 f0             	pushl  -0x10(%ebp)
  80058a:	ff 75 f4             	pushl  -0xc(%ebp)
  80058d:	ff 75 08             	pushl  0x8(%ebp)
  800590:	e8 a9 00 00 00       	call   80063e <Swap>
  800595:	83 c4 10             	add    $0x10,%esp
{
	if (startIndex >= finalIndex) return;

	int i = startIndex+1, j = finalIndex;

	while (i <= j)
  800598:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80059b:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80059e:	0f 8e 77 ff ff ff    	jle    80051b <QSort+0x27>
		{
			Swap(Elements, i, j);
		}
	}

	Swap( Elements, startIndex, j);
  8005a4:	83 ec 04             	sub    $0x4,%esp
  8005a7:	ff 75 f0             	pushl  -0x10(%ebp)
  8005aa:	ff 75 10             	pushl  0x10(%ebp)
  8005ad:	ff 75 08             	pushl  0x8(%ebp)
  8005b0:	e8 89 00 00 00       	call   80063e <Swap>
  8005b5:	83 c4 10             	add    $0x10,%esp

	QSort(Elements, NumOfElements, startIndex, j - 1);
  8005b8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8005bb:	48                   	dec    %eax
  8005bc:	50                   	push   %eax
  8005bd:	ff 75 10             	pushl  0x10(%ebp)
  8005c0:	ff 75 0c             	pushl  0xc(%ebp)
  8005c3:	ff 75 08             	pushl  0x8(%ebp)
  8005c6:	e8 29 ff ff ff       	call   8004f4 <QSort>
  8005cb:	83 c4 10             	add    $0x10,%esp
	QSort(Elements, NumOfElements, i, finalIndex);
  8005ce:	ff 75 14             	pushl  0x14(%ebp)
  8005d1:	ff 75 f4             	pushl  -0xc(%ebp)
  8005d4:	ff 75 0c             	pushl  0xc(%ebp)
  8005d7:	ff 75 08             	pushl  0x8(%ebp)
  8005da:	e8 15 ff ff ff       	call   8004f4 <QSort>
  8005df:	83 c4 10             	add    $0x10,%esp
  8005e2:	eb 01                	jmp    8005e5 <QSort+0xf1>
}


void QSort(int *Elements,int NumOfElements, int startIndex, int finalIndex)
{
	if (startIndex >= finalIndex) return;
  8005e4:	90                   	nop

	Swap( Elements, startIndex, j);

	QSort(Elements, NumOfElements, startIndex, j - 1);
	QSort(Elements, NumOfElements, i, finalIndex);
}
  8005e5:	c9                   	leave  
  8005e6:	c3                   	ret    

008005e7 <CheckSorted>:

uint32 CheckSorted(int *Elements, int NumOfElements)
{
  8005e7:	55                   	push   %ebp
  8005e8:	89 e5                	mov    %esp,%ebp
  8005ea:	83 ec 10             	sub    $0x10,%esp
	uint32 Sorted = 1 ;
  8005ed:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
	int i ;
	for (i = 0 ; i < NumOfElements - 1; i++)
  8005f4:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8005fb:	eb 33                	jmp    800630 <CheckSorted+0x49>
	{
		if (Elements[i] > Elements[i+1])
  8005fd:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800600:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800607:	8b 45 08             	mov    0x8(%ebp),%eax
  80060a:	01 d0                	add    %edx,%eax
  80060c:	8b 10                	mov    (%eax),%edx
  80060e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800611:	40                   	inc    %eax
  800612:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800619:	8b 45 08             	mov    0x8(%ebp),%eax
  80061c:	01 c8                	add    %ecx,%eax
  80061e:	8b 00                	mov    (%eax),%eax
  800620:	39 c2                	cmp    %eax,%edx
  800622:	7e 09                	jle    80062d <CheckSorted+0x46>
		{
			Sorted = 0 ;
  800624:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
			break;
  80062b:	eb 0c                	jmp    800639 <CheckSorted+0x52>

uint32 CheckSorted(int *Elements, int NumOfElements)
{
	uint32 Sorted = 1 ;
	int i ;
	for (i = 0 ; i < NumOfElements - 1; i++)
  80062d:	ff 45 f8             	incl   -0x8(%ebp)
  800630:	8b 45 0c             	mov    0xc(%ebp),%eax
  800633:	48                   	dec    %eax
  800634:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800637:	7f c4                	jg     8005fd <CheckSorted+0x16>
		{
			Sorted = 0 ;
			break;
		}
	}
	return Sorted ;
  800639:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80063c:	c9                   	leave  
  80063d:	c3                   	ret    

0080063e <Swap>:

///Private Functions


void Swap(int *Elements, int First, int Second)
{
  80063e:	55                   	push   %ebp
  80063f:	89 e5                	mov    %esp,%ebp
  800641:	83 ec 10             	sub    $0x10,%esp
	int Tmp = Elements[First] ;
  800644:	8b 45 0c             	mov    0xc(%ebp),%eax
  800647:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80064e:	8b 45 08             	mov    0x8(%ebp),%eax
  800651:	01 d0                	add    %edx,%eax
  800653:	8b 00                	mov    (%eax),%eax
  800655:	89 45 fc             	mov    %eax,-0x4(%ebp)
	Elements[First] = Elements[Second] ;
  800658:	8b 45 0c             	mov    0xc(%ebp),%eax
  80065b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800662:	8b 45 08             	mov    0x8(%ebp),%eax
  800665:	01 c2                	add    %eax,%edx
  800667:	8b 45 10             	mov    0x10(%ebp),%eax
  80066a:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800671:	8b 45 08             	mov    0x8(%ebp),%eax
  800674:	01 c8                	add    %ecx,%eax
  800676:	8b 00                	mov    (%eax),%eax
  800678:	89 02                	mov    %eax,(%edx)
	Elements[Second] = Tmp ;
  80067a:	8b 45 10             	mov    0x10(%ebp),%eax
  80067d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800684:	8b 45 08             	mov    0x8(%ebp),%eax
  800687:	01 c2                	add    %eax,%edx
  800689:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80068c:	89 02                	mov    %eax,(%edx)
}
  80068e:	90                   	nop
  80068f:	c9                   	leave  
  800690:	c3                   	ret    

00800691 <InitializeAscending>:

void InitializeAscending(int *Elements, int NumOfElements)
{
  800691:	55                   	push   %ebp
  800692:	89 e5                	mov    %esp,%ebp
  800694:	83 ec 10             	sub    $0x10,%esp
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  800697:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80069e:	eb 17                	jmp    8006b7 <InitializeAscending+0x26>
	{
		(Elements)[i] = i ;
  8006a0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8006a3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8006aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ad:	01 c2                	add    %eax,%edx
  8006af:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8006b2:	89 02                	mov    %eax,(%edx)
}

void InitializeAscending(int *Elements, int NumOfElements)
{
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  8006b4:	ff 45 fc             	incl   -0x4(%ebp)
  8006b7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8006ba:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8006bd:	7c e1                	jl     8006a0 <InitializeAscending+0xf>
	{
		(Elements)[i] = i ;
	}

}
  8006bf:	90                   	nop
  8006c0:	c9                   	leave  
  8006c1:	c3                   	ret    

008006c2 <InitializeIdentical>:

void InitializeIdentical(int *Elements, int NumOfElements)
{
  8006c2:	55                   	push   %ebp
  8006c3:	89 e5                	mov    %esp,%ebp
  8006c5:	83 ec 10             	sub    $0x10,%esp
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  8006c8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8006cf:	eb 1b                	jmp    8006ec <InitializeIdentical+0x2a>
	{
		Elements[i] = NumOfElements - i - 1 ;
  8006d1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8006d4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8006db:	8b 45 08             	mov    0x8(%ebp),%eax
  8006de:	01 c2                	add    %eax,%edx
  8006e0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006e3:	2b 45 fc             	sub    -0x4(%ebp),%eax
  8006e6:	48                   	dec    %eax
  8006e7:	89 02                	mov    %eax,(%edx)
}

void InitializeIdentical(int *Elements, int NumOfElements)
{
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  8006e9:	ff 45 fc             	incl   -0x4(%ebp)
  8006ec:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8006ef:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8006f2:	7c dd                	jl     8006d1 <InitializeIdentical+0xf>
	{
		Elements[i] = NumOfElements - i - 1 ;
	}

}
  8006f4:	90                   	nop
  8006f5:	c9                   	leave  
  8006f6:	c3                   	ret    

008006f7 <InitializeSemiRandom>:

void InitializeSemiRandom(int *Elements, int NumOfElements)
{
  8006f7:	55                   	push   %ebp
  8006f8:	89 e5                	mov    %esp,%ebp
  8006fa:	83 ec 10             	sub    $0x10,%esp
	int i ;
	int Repetition = NumOfElements / 3 ;
  8006fd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800700:	b8 56 55 55 55       	mov    $0x55555556,%eax
  800705:	f7 e9                	imul   %ecx
  800707:	c1 f9 1f             	sar    $0x1f,%ecx
  80070a:	89 d0                	mov    %edx,%eax
  80070c:	29 c8                	sub    %ecx,%eax
  80070e:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0 ; i < NumOfElements ; i++)
  800711:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800718:	eb 1e                	jmp    800738 <InitializeSemiRandom+0x41>
	{
		Elements[i] = i % Repetition ;
  80071a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80071d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800724:	8b 45 08             	mov    0x8(%ebp),%eax
  800727:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  80072a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80072d:	99                   	cltd   
  80072e:	f7 7d f8             	idivl  -0x8(%ebp)
  800731:	89 d0                	mov    %edx,%eax
  800733:	89 01                	mov    %eax,(%ecx)

void InitializeSemiRandom(int *Elements, int NumOfElements)
{
	int i ;
	int Repetition = NumOfElements / 3 ;
	for (i = 0 ; i < NumOfElements ; i++)
  800735:	ff 45 fc             	incl   -0x4(%ebp)
  800738:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80073b:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80073e:	7c da                	jl     80071a <InitializeSemiRandom+0x23>
	{
		Elements[i] = i % Repetition ;
	}

}
  800740:	90                   	nop
  800741:	c9                   	leave  
  800742:	c3                   	ret    

00800743 <PrintElements>:

void PrintElements(int *Elements, int NumOfElements)
{
  800743:	55                   	push   %ebp
  800744:	89 e5                	mov    %esp,%ebp
  800746:	83 ec 18             	sub    $0x18,%esp
	int i ;
	int NumsPerLine = 20 ;
  800749:	c7 45 f0 14 00 00 00 	movl   $0x14,-0x10(%ebp)
	for (i = 0 ; i < NumOfElements-1 ; i++)
  800750:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800757:	eb 42                	jmp    80079b <PrintElements+0x58>
	{
		if (i%NumsPerLine == 0)
  800759:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80075c:	99                   	cltd   
  80075d:	f7 7d f0             	idivl  -0x10(%ebp)
  800760:	89 d0                	mov    %edx,%eax
  800762:	85 c0                	test   %eax,%eax
  800764:	75 10                	jne    800776 <PrintElements+0x33>
			cprintf("\n");
  800766:	83 ec 0c             	sub    $0xc,%esp
  800769:	68 a2 4c 80 00       	push   $0x804ca2
  80076e:	e8 19 05 00 00       	call   800c8c <cprintf>
  800773:	83 c4 10             	add    $0x10,%esp
		cprintf("%d, ",Elements[i]);
  800776:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800779:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800780:	8b 45 08             	mov    0x8(%ebp),%eax
  800783:	01 d0                	add    %edx,%eax
  800785:	8b 00                	mov    (%eax),%eax
  800787:	83 ec 08             	sub    $0x8,%esp
  80078a:	50                   	push   %eax
  80078b:	68 a4 4c 80 00       	push   $0x804ca4
  800790:	e8 f7 04 00 00       	call   800c8c <cprintf>
  800795:	83 c4 10             	add    $0x10,%esp

void PrintElements(int *Elements, int NumOfElements)
{
	int i ;
	int NumsPerLine = 20 ;
	for (i = 0 ; i < NumOfElements-1 ; i++)
  800798:	ff 45 f4             	incl   -0xc(%ebp)
  80079b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80079e:	48                   	dec    %eax
  80079f:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8007a2:	7f b5                	jg     800759 <PrintElements+0x16>
	{
		if (i%NumsPerLine == 0)
			cprintf("\n");
		cprintf("%d, ",Elements[i]);
	}
	cprintf("%d\n",Elements[i]);
  8007a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8007a7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8007ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8007b1:	01 d0                	add    %edx,%eax
  8007b3:	8b 00                	mov    (%eax),%eax
  8007b5:	83 ec 08             	sub    $0x8,%esp
  8007b8:	50                   	push   %eax
  8007b9:	68 a9 4c 80 00       	push   $0x804ca9
  8007be:	e8 c9 04 00 00       	call   800c8c <cprintf>
  8007c3:	83 c4 10             	add    $0x10,%esp

}
  8007c6:	90                   	nop
  8007c7:	c9                   	leave  
  8007c8:	c3                   	ret    

008007c9 <cputchar>:
#include <inc/lib.h>


void
cputchar(int ch)
{
  8007c9:	55                   	push   %ebp
  8007ca:	89 e5                	mov    %esp,%ebp
  8007cc:	83 ec 18             	sub    $0x18,%esp
	char c = ch;
  8007cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8007d2:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  8007d5:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  8007d9:	83 ec 0c             	sub    $0xc,%esp
  8007dc:	50                   	push   %eax
  8007dd:	e8 b5 30 00 00       	call   803897 <sys_cputc>
  8007e2:	83 c4 10             	add    $0x10,%esp
}
  8007e5:	90                   	nop
  8007e6:	c9                   	leave  
  8007e7:	c3                   	ret    

008007e8 <getchar>:


int
getchar(void)
{
  8007e8:	55                   	push   %ebp
  8007e9:	89 e5                	mov    %esp,%ebp
  8007eb:	83 ec 18             	sub    $0x18,%esp
	int c =sys_cgetc();
  8007ee:	e8 43 2f 00 00       	call   803736 <sys_cgetc>
  8007f3:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return c;
  8007f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8007f9:	c9                   	leave  
  8007fa:	c3                   	ret    

008007fb <iscons>:

int iscons(int fdnum)
{
  8007fb:	55                   	push   %ebp
  8007fc:	89 e5                	mov    %esp,%ebp
	// used by readline
	return 1;
  8007fe:	b8 01 00 00 00       	mov    $0x1,%eax
}
  800803:	5d                   	pop    %ebp
  800804:	c3                   	ret    

00800805 <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  800805:	55                   	push   %ebp
  800806:	89 e5                	mov    %esp,%ebp
  800808:	57                   	push   %edi
  800809:	56                   	push   %esi
  80080a:	53                   	push   %ebx
  80080b:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  80080e:	e8 b5 31 00 00       	call   8039c8 <sys_getenvindex>
  800813:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  800816:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800819:	89 d0                	mov    %edx,%eax
  80081b:	c1 e0 02             	shl    $0x2,%eax
  80081e:	01 d0                	add    %edx,%eax
  800820:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800827:	01 d0                	add    %edx,%eax
  800829:	89 c2                	mov    %eax,%edx
  80082b:	c1 e2 04             	shl    $0x4,%edx
  80082e:	29 c2                	sub    %eax,%edx
  800830:	8d 04 95 00 00 00 00 	lea    0x0(,%edx,4),%eax
  800837:	89 c2                	mov    %eax,%edx
  800839:	8d 82 00 00 c0 ee    	lea    -0x11400000(%edx),%eax
  80083f:	a3 24 60 80 00       	mov    %eax,0x806024

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800844:	a1 24 60 80 00       	mov    0x806024,%eax
  800849:	8a 40 20             	mov    0x20(%eax),%al
  80084c:	84 c0                	test   %al,%al
  80084e:	74 0d                	je     80085d <libmain+0x58>
		binaryname = myEnv->prog_name;
  800850:	a1 24 60 80 00       	mov    0x806024,%eax
  800855:	83 c0 20             	add    $0x20,%eax
  800858:	a3 04 60 80 00       	mov    %eax,0x806004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80085d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800861:	7e 0a                	jle    80086d <libmain+0x68>
		binaryname = argv[0];
  800863:	8b 45 0c             	mov    0xc(%ebp),%eax
  800866:	8b 00                	mov    (%eax),%eax
  800868:	a3 04 60 80 00       	mov    %eax,0x806004

	// call user main routine
	_main(argc, argv);
  80086d:	83 ec 08             	sub    $0x8,%esp
  800870:	ff 75 0c             	pushl  0xc(%ebp)
  800873:	ff 75 08             	pushl  0x8(%ebp)
  800876:	e8 bd f7 ff ff       	call   800038 <_main>
  80087b:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  80087e:	a1 00 60 80 00       	mov    0x806000,%eax
  800883:	85 c0                	test   %eax,%eax
  800885:	0f 84 01 01 00 00    	je     80098c <libmain+0x187>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  80088b:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  800891:	bb a8 4d 80 00       	mov    $0x804da8,%ebx
  800896:	ba 0e 00 00 00       	mov    $0xe,%edx
  80089b:	89 c7                	mov    %eax,%edi
  80089d:	89 de                	mov    %ebx,%esi
  80089f:	89 d1                	mov    %edx,%ecx
  8008a1:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  8008a3:	8d 55 8a             	lea    -0x76(%ebp),%edx
  8008a6:	b9 56 00 00 00       	mov    $0x56,%ecx
  8008ab:	b0 00                	mov    $0x0,%al
  8008ad:	89 d7                	mov    %edx,%edi
  8008af:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  8008b1:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  8008b8:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8008bb:	83 ec 08             	sub    $0x8,%esp
  8008be:	50                   	push   %eax
  8008bf:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  8008c5:	50                   	push   %eax
  8008c6:	e8 33 33 00 00       	call   803bfe <sys_utilities>
  8008cb:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  8008ce:	e8 7c 2e 00 00       	call   80374f <sys_lock_cons>
		{
			cprintf("**************************************\n");
  8008d3:	83 ec 0c             	sub    $0xc,%esp
  8008d6:	68 c8 4c 80 00       	push   $0x804cc8
  8008db:	e8 ac 03 00 00       	call   800c8c <cprintf>
  8008e0:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  8008e3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8008e6:	85 c0                	test   %eax,%eax
  8008e8:	74 18                	je     800902 <libmain+0xfd>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  8008ea:	e8 2d 33 00 00       	call   803c1c <sys_get_optimal_num_faults>
  8008ef:	83 ec 08             	sub    $0x8,%esp
  8008f2:	50                   	push   %eax
  8008f3:	68 f0 4c 80 00       	push   $0x804cf0
  8008f8:	e8 8f 03 00 00       	call   800c8c <cprintf>
  8008fd:	83 c4 10             	add    $0x10,%esp
  800900:	eb 59                	jmp    80095b <libmain+0x156>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800902:	a1 24 60 80 00       	mov    0x806024,%eax
  800907:	8b 90 bc 05 00 00    	mov    0x5bc(%eax),%edx
  80090d:	a1 24 60 80 00       	mov    0x806024,%eax
  800912:	8b 80 ac 05 00 00    	mov    0x5ac(%eax),%eax
  800918:	83 ec 04             	sub    $0x4,%esp
  80091b:	52                   	push   %edx
  80091c:	50                   	push   %eax
  80091d:	68 14 4d 80 00       	push   $0x804d14
  800922:	e8 65 03 00 00       	call   800c8c <cprintf>
  800927:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  80092a:	a1 24 60 80 00       	mov    0x806024,%eax
  80092f:	8b 88 d0 05 00 00    	mov    0x5d0(%eax),%ecx
  800935:	a1 24 60 80 00       	mov    0x806024,%eax
  80093a:	8b 90 cc 05 00 00    	mov    0x5cc(%eax),%edx
  800940:	a1 24 60 80 00       	mov    0x806024,%eax
  800945:	8b 80 c8 05 00 00    	mov    0x5c8(%eax),%eax
  80094b:	51                   	push   %ecx
  80094c:	52                   	push   %edx
  80094d:	50                   	push   %eax
  80094e:	68 3c 4d 80 00       	push   $0x804d3c
  800953:	e8 34 03 00 00       	call   800c8c <cprintf>
  800958:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80095b:	a1 24 60 80 00       	mov    0x806024,%eax
  800960:	8b 80 d4 05 00 00    	mov    0x5d4(%eax),%eax
  800966:	83 ec 08             	sub    $0x8,%esp
  800969:	50                   	push   %eax
  80096a:	68 94 4d 80 00       	push   $0x804d94
  80096f:	e8 18 03 00 00       	call   800c8c <cprintf>
  800974:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  800977:	83 ec 0c             	sub    $0xc,%esp
  80097a:	68 c8 4c 80 00       	push   $0x804cc8
  80097f:	e8 08 03 00 00       	call   800c8c <cprintf>
  800984:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  800987:	e8 dd 2d 00 00       	call   803769 <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  80098c:	e8 1f 00 00 00       	call   8009b0 <exit>
}
  800991:	90                   	nop
  800992:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800995:	5b                   	pop    %ebx
  800996:	5e                   	pop    %esi
  800997:	5f                   	pop    %edi
  800998:	5d                   	pop    %ebp
  800999:	c3                   	ret    

0080099a <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  80099a:	55                   	push   %ebp
  80099b:	89 e5                	mov    %esp,%ebp
  80099d:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8009a0:	83 ec 0c             	sub    $0xc,%esp
  8009a3:	6a 00                	push   $0x0
  8009a5:	e8 ea 2f 00 00       	call   803994 <sys_destroy_env>
  8009aa:	83 c4 10             	add    $0x10,%esp
}
  8009ad:	90                   	nop
  8009ae:	c9                   	leave  
  8009af:	c3                   	ret    

008009b0 <exit>:

void
exit(void)
{
  8009b0:	55                   	push   %ebp
  8009b1:	89 e5                	mov    %esp,%ebp
  8009b3:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8009b6:	e8 3f 30 00 00       	call   8039fa <sys_exit_env>
}
  8009bb:	90                   	nop
  8009bc:	c9                   	leave  
  8009bd:	c3                   	ret    

008009be <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8009be:	55                   	push   %ebp
  8009bf:	89 e5                	mov    %esp,%ebp
  8009c1:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8009c4:	8d 45 10             	lea    0x10(%ebp),%eax
  8009c7:	83 c0 04             	add    $0x4,%eax
  8009ca:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8009cd:	a1 18 e1 81 00       	mov    0x81e118,%eax
  8009d2:	85 c0                	test   %eax,%eax
  8009d4:	74 16                	je     8009ec <_panic+0x2e>
		cprintf("%s: ", argv0);
  8009d6:	a1 18 e1 81 00       	mov    0x81e118,%eax
  8009db:	83 ec 08             	sub    $0x8,%esp
  8009de:	50                   	push   %eax
  8009df:	68 0c 4e 80 00       	push   $0x804e0c
  8009e4:	e8 a3 02 00 00       	call   800c8c <cprintf>
  8009e9:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  8009ec:	a1 04 60 80 00       	mov    0x806004,%eax
  8009f1:	83 ec 0c             	sub    $0xc,%esp
  8009f4:	ff 75 0c             	pushl  0xc(%ebp)
  8009f7:	ff 75 08             	pushl  0x8(%ebp)
  8009fa:	50                   	push   %eax
  8009fb:	68 14 4e 80 00       	push   $0x804e14
  800a00:	6a 74                	push   $0x74
  800a02:	e8 b2 02 00 00       	call   800cb9 <cprintf_colored>
  800a07:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  800a0a:	8b 45 10             	mov    0x10(%ebp),%eax
  800a0d:	83 ec 08             	sub    $0x8,%esp
  800a10:	ff 75 f4             	pushl  -0xc(%ebp)
  800a13:	50                   	push   %eax
  800a14:	e8 04 02 00 00       	call   800c1d <vcprintf>
  800a19:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800a1c:	83 ec 08             	sub    $0x8,%esp
  800a1f:	6a 00                	push   $0x0
  800a21:	68 3c 4e 80 00       	push   $0x804e3c
  800a26:	e8 f2 01 00 00       	call   800c1d <vcprintf>
  800a2b:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800a2e:	e8 7d ff ff ff       	call   8009b0 <exit>

	// should not return here
	while (1) ;
  800a33:	eb fe                	jmp    800a33 <_panic+0x75>

00800a35 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800a35:	55                   	push   %ebp
  800a36:	89 e5                	mov    %esp,%ebp
  800a38:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800a3b:	a1 24 60 80 00       	mov    0x806024,%eax
  800a40:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800a46:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a49:	39 c2                	cmp    %eax,%edx
  800a4b:	74 14                	je     800a61 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800a4d:	83 ec 04             	sub    $0x4,%esp
  800a50:	68 40 4e 80 00       	push   $0x804e40
  800a55:	6a 26                	push   $0x26
  800a57:	68 8c 4e 80 00       	push   $0x804e8c
  800a5c:	e8 5d ff ff ff       	call   8009be <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800a61:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800a68:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800a6f:	e9 c5 00 00 00       	jmp    800b39 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  800a74:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a77:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800a7e:	8b 45 08             	mov    0x8(%ebp),%eax
  800a81:	01 d0                	add    %edx,%eax
  800a83:	8b 00                	mov    (%eax),%eax
  800a85:	85 c0                	test   %eax,%eax
  800a87:	75 08                	jne    800a91 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  800a89:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800a8c:	e9 a5 00 00 00       	jmp    800b36 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  800a91:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800a98:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800a9f:	eb 69                	jmp    800b0a <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800aa1:	a1 24 60 80 00       	mov    0x806024,%eax
  800aa6:	8b 88 a4 05 00 00    	mov    0x5a4(%eax),%ecx
  800aac:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800aaf:	89 d0                	mov    %edx,%eax
  800ab1:	01 c0                	add    %eax,%eax
  800ab3:	01 d0                	add    %edx,%eax
  800ab5:	c1 e0 03             	shl    $0x3,%eax
  800ab8:	01 c8                	add    %ecx,%eax
  800aba:	8a 40 04             	mov    0x4(%eax),%al
  800abd:	84 c0                	test   %al,%al
  800abf:	75 46                	jne    800b07 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800ac1:	a1 24 60 80 00       	mov    0x806024,%eax
  800ac6:	8b 88 a4 05 00 00    	mov    0x5a4(%eax),%ecx
  800acc:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800acf:	89 d0                	mov    %edx,%eax
  800ad1:	01 c0                	add    %eax,%eax
  800ad3:	01 d0                	add    %edx,%eax
  800ad5:	c1 e0 03             	shl    $0x3,%eax
  800ad8:	01 c8                	add    %ecx,%eax
  800ada:	8b 00                	mov    (%eax),%eax
  800adc:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800adf:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800ae2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800ae7:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800ae9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800aec:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800af3:	8b 45 08             	mov    0x8(%ebp),%eax
  800af6:	01 c8                	add    %ecx,%eax
  800af8:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800afa:	39 c2                	cmp    %eax,%edx
  800afc:	75 09                	jne    800b07 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  800afe:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800b05:	eb 15                	jmp    800b1c <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800b07:	ff 45 e8             	incl   -0x18(%ebp)
  800b0a:	a1 24 60 80 00       	mov    0x806024,%eax
  800b0f:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800b15:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800b18:	39 c2                	cmp    %eax,%edx
  800b1a:	77 85                	ja     800aa1 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800b1c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800b20:	75 14                	jne    800b36 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  800b22:	83 ec 04             	sub    $0x4,%esp
  800b25:	68 98 4e 80 00       	push   $0x804e98
  800b2a:	6a 3a                	push   $0x3a
  800b2c:	68 8c 4e 80 00       	push   $0x804e8c
  800b31:	e8 88 fe ff ff       	call   8009be <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800b36:	ff 45 f0             	incl   -0x10(%ebp)
  800b39:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b3c:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800b3f:	0f 8c 2f ff ff ff    	jl     800a74 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800b45:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800b4c:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800b53:	eb 26                	jmp    800b7b <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800b55:	a1 24 60 80 00       	mov    0x806024,%eax
  800b5a:	8b 88 a4 05 00 00    	mov    0x5a4(%eax),%ecx
  800b60:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800b63:	89 d0                	mov    %edx,%eax
  800b65:	01 c0                	add    %eax,%eax
  800b67:	01 d0                	add    %edx,%eax
  800b69:	c1 e0 03             	shl    $0x3,%eax
  800b6c:	01 c8                	add    %ecx,%eax
  800b6e:	8a 40 04             	mov    0x4(%eax),%al
  800b71:	3c 01                	cmp    $0x1,%al
  800b73:	75 03                	jne    800b78 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  800b75:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800b78:	ff 45 e0             	incl   -0x20(%ebp)
  800b7b:	a1 24 60 80 00       	mov    0x806024,%eax
  800b80:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800b86:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800b89:	39 c2                	cmp    %eax,%edx
  800b8b:	77 c8                	ja     800b55 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800b8d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800b90:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800b93:	74 14                	je     800ba9 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  800b95:	83 ec 04             	sub    $0x4,%esp
  800b98:	68 ec 4e 80 00       	push   $0x804eec
  800b9d:	6a 44                	push   $0x44
  800b9f:	68 8c 4e 80 00       	push   $0x804e8c
  800ba4:	e8 15 fe ff ff       	call   8009be <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800ba9:	90                   	nop
  800baa:	c9                   	leave  
  800bab:	c3                   	ret    

00800bac <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  800bac:	55                   	push   %ebp
  800bad:	89 e5                	mov    %esp,%ebp
  800baf:	53                   	push   %ebx
  800bb0:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  800bb3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bb6:	8b 00                	mov    (%eax),%eax
  800bb8:	8d 48 01             	lea    0x1(%eax),%ecx
  800bbb:	8b 55 0c             	mov    0xc(%ebp),%edx
  800bbe:	89 0a                	mov    %ecx,(%edx)
  800bc0:	8b 55 08             	mov    0x8(%ebp),%edx
  800bc3:	88 d1                	mov    %dl,%cl
  800bc5:	8b 55 0c             	mov    0xc(%ebp),%edx
  800bc8:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800bcc:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bcf:	8b 00                	mov    (%eax),%eax
  800bd1:	3d ff 00 00 00       	cmp    $0xff,%eax
  800bd6:	75 30                	jne    800c08 <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  800bd8:	8b 15 1c e1 81 00    	mov    0x81e11c,%edx
  800bde:	a0 44 60 80 00       	mov    0x806044,%al
  800be3:	0f b6 c0             	movzbl %al,%eax
  800be6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800be9:	8b 09                	mov    (%ecx),%ecx
  800beb:	89 cb                	mov    %ecx,%ebx
  800bed:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800bf0:	83 c1 08             	add    $0x8,%ecx
  800bf3:	52                   	push   %edx
  800bf4:	50                   	push   %eax
  800bf5:	53                   	push   %ebx
  800bf6:	51                   	push   %ecx
  800bf7:	e8 0f 2b 00 00       	call   80370b <sys_cputs>
  800bfc:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800bff:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c02:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800c08:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c0b:	8b 40 04             	mov    0x4(%eax),%eax
  800c0e:	8d 50 01             	lea    0x1(%eax),%edx
  800c11:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c14:	89 50 04             	mov    %edx,0x4(%eax)
}
  800c17:	90                   	nop
  800c18:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800c1b:	c9                   	leave  
  800c1c:	c3                   	ret    

00800c1d <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800c1d:	55                   	push   %ebp
  800c1e:	89 e5                	mov    %esp,%ebp
  800c20:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800c26:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800c2d:	00 00 00 
	b.cnt = 0;
  800c30:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800c37:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800c3a:	ff 75 0c             	pushl  0xc(%ebp)
  800c3d:	ff 75 08             	pushl  0x8(%ebp)
  800c40:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800c46:	50                   	push   %eax
  800c47:	68 ac 0b 80 00       	push   $0x800bac
  800c4c:	e8 5a 02 00 00       	call   800eab <vprintfmt>
  800c51:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  800c54:	8b 15 1c e1 81 00    	mov    0x81e11c,%edx
  800c5a:	a0 44 60 80 00       	mov    0x806044,%al
  800c5f:	0f b6 c0             	movzbl %al,%eax
  800c62:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  800c68:	52                   	push   %edx
  800c69:	50                   	push   %eax
  800c6a:	51                   	push   %ecx
  800c6b:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800c71:	83 c0 08             	add    $0x8,%eax
  800c74:	50                   	push   %eax
  800c75:	e8 91 2a 00 00       	call   80370b <sys_cputs>
  800c7a:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800c7d:	c6 05 44 60 80 00 00 	movb   $0x0,0x806044
	return b.cnt;
  800c84:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800c8a:	c9                   	leave  
  800c8b:	c3                   	ret    

00800c8c <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  800c8c:	55                   	push   %ebp
  800c8d:	89 e5                	mov    %esp,%ebp
  800c8f:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800c92:	c6 05 44 60 80 00 01 	movb   $0x1,0x806044
	va_start(ap, fmt);
  800c99:	8d 45 0c             	lea    0xc(%ebp),%eax
  800c9c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800c9f:	8b 45 08             	mov    0x8(%ebp),%eax
  800ca2:	83 ec 08             	sub    $0x8,%esp
  800ca5:	ff 75 f4             	pushl  -0xc(%ebp)
  800ca8:	50                   	push   %eax
  800ca9:	e8 6f ff ff ff       	call   800c1d <vcprintf>
  800cae:	83 c4 10             	add    $0x10,%esp
  800cb1:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800cb4:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800cb7:	c9                   	leave  
  800cb8:	c3                   	ret    

00800cb9 <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  800cb9:	55                   	push   %ebp
  800cba:	89 e5                	mov    %esp,%ebp
  800cbc:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800cbf:	c6 05 44 60 80 00 01 	movb   $0x1,0x806044
	curTextClr = (textClr << 8) ; //set text color by the given value
  800cc6:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc9:	c1 e0 08             	shl    $0x8,%eax
  800ccc:	a3 1c e1 81 00       	mov    %eax,0x81e11c
	va_start(ap, fmt);
  800cd1:	8d 45 0c             	lea    0xc(%ebp),%eax
  800cd4:	83 c0 04             	add    $0x4,%eax
  800cd7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800cda:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cdd:	83 ec 08             	sub    $0x8,%esp
  800ce0:	ff 75 f4             	pushl  -0xc(%ebp)
  800ce3:	50                   	push   %eax
  800ce4:	e8 34 ff ff ff       	call   800c1d <vcprintf>
  800ce9:	83 c4 10             	add    $0x10,%esp
  800cec:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  800cef:	c7 05 1c e1 81 00 00 	movl   $0x700,0x81e11c
  800cf6:	07 00 00 

	return cnt;
  800cf9:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800cfc:	c9                   	leave  
  800cfd:	c3                   	ret    

00800cfe <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  800cfe:	55                   	push   %ebp
  800cff:	89 e5                	mov    %esp,%ebp
  800d01:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  800d04:	e8 46 2a 00 00       	call   80374f <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  800d09:	8d 45 0c             	lea    0xc(%ebp),%eax
  800d0c:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  800d0f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d12:	83 ec 08             	sub    $0x8,%esp
  800d15:	ff 75 f4             	pushl  -0xc(%ebp)
  800d18:	50                   	push   %eax
  800d19:	e8 ff fe ff ff       	call   800c1d <vcprintf>
  800d1e:	83 c4 10             	add    $0x10,%esp
  800d21:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  800d24:	e8 40 2a 00 00       	call   803769 <sys_unlock_cons>
	return cnt;
  800d29:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800d2c:	c9                   	leave  
  800d2d:	c3                   	ret    

00800d2e <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800d2e:	55                   	push   %ebp
  800d2f:	89 e5                	mov    %esp,%ebp
  800d31:	53                   	push   %ebx
  800d32:	83 ec 14             	sub    $0x14,%esp
  800d35:	8b 45 10             	mov    0x10(%ebp),%eax
  800d38:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800d3b:	8b 45 14             	mov    0x14(%ebp),%eax
  800d3e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800d41:	8b 45 18             	mov    0x18(%ebp),%eax
  800d44:	ba 00 00 00 00       	mov    $0x0,%edx
  800d49:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800d4c:	77 55                	ja     800da3 <printnum+0x75>
  800d4e:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800d51:	72 05                	jb     800d58 <printnum+0x2a>
  800d53:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800d56:	77 4b                	ja     800da3 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800d58:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800d5b:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800d5e:	8b 45 18             	mov    0x18(%ebp),%eax
  800d61:	ba 00 00 00 00       	mov    $0x0,%edx
  800d66:	52                   	push   %edx
  800d67:	50                   	push   %eax
  800d68:	ff 75 f4             	pushl  -0xc(%ebp)
  800d6b:	ff 75 f0             	pushl  -0x10(%ebp)
  800d6e:	e8 89 3a 00 00       	call   8047fc <__udivdi3>
  800d73:	83 c4 10             	add    $0x10,%esp
  800d76:	83 ec 04             	sub    $0x4,%esp
  800d79:	ff 75 20             	pushl  0x20(%ebp)
  800d7c:	53                   	push   %ebx
  800d7d:	ff 75 18             	pushl  0x18(%ebp)
  800d80:	52                   	push   %edx
  800d81:	50                   	push   %eax
  800d82:	ff 75 0c             	pushl  0xc(%ebp)
  800d85:	ff 75 08             	pushl  0x8(%ebp)
  800d88:	e8 a1 ff ff ff       	call   800d2e <printnum>
  800d8d:	83 c4 20             	add    $0x20,%esp
  800d90:	eb 1a                	jmp    800dac <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800d92:	83 ec 08             	sub    $0x8,%esp
  800d95:	ff 75 0c             	pushl  0xc(%ebp)
  800d98:	ff 75 20             	pushl  0x20(%ebp)
  800d9b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d9e:	ff d0                	call   *%eax
  800da0:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800da3:	ff 4d 1c             	decl   0x1c(%ebp)
  800da6:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800daa:	7f e6                	jg     800d92 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800dac:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800daf:	bb 00 00 00 00       	mov    $0x0,%ebx
  800db4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800db7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800dba:	53                   	push   %ebx
  800dbb:	51                   	push   %ecx
  800dbc:	52                   	push   %edx
  800dbd:	50                   	push   %eax
  800dbe:	e8 49 3b 00 00       	call   80490c <__umoddi3>
  800dc3:	83 c4 10             	add    $0x10,%esp
  800dc6:	05 54 51 80 00       	add    $0x805154,%eax
  800dcb:	8a 00                	mov    (%eax),%al
  800dcd:	0f be c0             	movsbl %al,%eax
  800dd0:	83 ec 08             	sub    $0x8,%esp
  800dd3:	ff 75 0c             	pushl  0xc(%ebp)
  800dd6:	50                   	push   %eax
  800dd7:	8b 45 08             	mov    0x8(%ebp),%eax
  800dda:	ff d0                	call   *%eax
  800ddc:	83 c4 10             	add    $0x10,%esp
}
  800ddf:	90                   	nop
  800de0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800de3:	c9                   	leave  
  800de4:	c3                   	ret    

00800de5 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800de5:	55                   	push   %ebp
  800de6:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800de8:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800dec:	7e 1c                	jle    800e0a <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800dee:	8b 45 08             	mov    0x8(%ebp),%eax
  800df1:	8b 00                	mov    (%eax),%eax
  800df3:	8d 50 08             	lea    0x8(%eax),%edx
  800df6:	8b 45 08             	mov    0x8(%ebp),%eax
  800df9:	89 10                	mov    %edx,(%eax)
  800dfb:	8b 45 08             	mov    0x8(%ebp),%eax
  800dfe:	8b 00                	mov    (%eax),%eax
  800e00:	83 e8 08             	sub    $0x8,%eax
  800e03:	8b 50 04             	mov    0x4(%eax),%edx
  800e06:	8b 00                	mov    (%eax),%eax
  800e08:	eb 40                	jmp    800e4a <getuint+0x65>
	else if (lflag)
  800e0a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e0e:	74 1e                	je     800e2e <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800e10:	8b 45 08             	mov    0x8(%ebp),%eax
  800e13:	8b 00                	mov    (%eax),%eax
  800e15:	8d 50 04             	lea    0x4(%eax),%edx
  800e18:	8b 45 08             	mov    0x8(%ebp),%eax
  800e1b:	89 10                	mov    %edx,(%eax)
  800e1d:	8b 45 08             	mov    0x8(%ebp),%eax
  800e20:	8b 00                	mov    (%eax),%eax
  800e22:	83 e8 04             	sub    $0x4,%eax
  800e25:	8b 00                	mov    (%eax),%eax
  800e27:	ba 00 00 00 00       	mov    $0x0,%edx
  800e2c:	eb 1c                	jmp    800e4a <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800e2e:	8b 45 08             	mov    0x8(%ebp),%eax
  800e31:	8b 00                	mov    (%eax),%eax
  800e33:	8d 50 04             	lea    0x4(%eax),%edx
  800e36:	8b 45 08             	mov    0x8(%ebp),%eax
  800e39:	89 10                	mov    %edx,(%eax)
  800e3b:	8b 45 08             	mov    0x8(%ebp),%eax
  800e3e:	8b 00                	mov    (%eax),%eax
  800e40:	83 e8 04             	sub    $0x4,%eax
  800e43:	8b 00                	mov    (%eax),%eax
  800e45:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800e4a:	5d                   	pop    %ebp
  800e4b:	c3                   	ret    

00800e4c <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800e4c:	55                   	push   %ebp
  800e4d:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800e4f:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800e53:	7e 1c                	jle    800e71 <getint+0x25>
		return va_arg(*ap, long long);
  800e55:	8b 45 08             	mov    0x8(%ebp),%eax
  800e58:	8b 00                	mov    (%eax),%eax
  800e5a:	8d 50 08             	lea    0x8(%eax),%edx
  800e5d:	8b 45 08             	mov    0x8(%ebp),%eax
  800e60:	89 10                	mov    %edx,(%eax)
  800e62:	8b 45 08             	mov    0x8(%ebp),%eax
  800e65:	8b 00                	mov    (%eax),%eax
  800e67:	83 e8 08             	sub    $0x8,%eax
  800e6a:	8b 50 04             	mov    0x4(%eax),%edx
  800e6d:	8b 00                	mov    (%eax),%eax
  800e6f:	eb 38                	jmp    800ea9 <getint+0x5d>
	else if (lflag)
  800e71:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e75:	74 1a                	je     800e91 <getint+0x45>
		return va_arg(*ap, long);
  800e77:	8b 45 08             	mov    0x8(%ebp),%eax
  800e7a:	8b 00                	mov    (%eax),%eax
  800e7c:	8d 50 04             	lea    0x4(%eax),%edx
  800e7f:	8b 45 08             	mov    0x8(%ebp),%eax
  800e82:	89 10                	mov    %edx,(%eax)
  800e84:	8b 45 08             	mov    0x8(%ebp),%eax
  800e87:	8b 00                	mov    (%eax),%eax
  800e89:	83 e8 04             	sub    $0x4,%eax
  800e8c:	8b 00                	mov    (%eax),%eax
  800e8e:	99                   	cltd   
  800e8f:	eb 18                	jmp    800ea9 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800e91:	8b 45 08             	mov    0x8(%ebp),%eax
  800e94:	8b 00                	mov    (%eax),%eax
  800e96:	8d 50 04             	lea    0x4(%eax),%edx
  800e99:	8b 45 08             	mov    0x8(%ebp),%eax
  800e9c:	89 10                	mov    %edx,(%eax)
  800e9e:	8b 45 08             	mov    0x8(%ebp),%eax
  800ea1:	8b 00                	mov    (%eax),%eax
  800ea3:	83 e8 04             	sub    $0x4,%eax
  800ea6:	8b 00                	mov    (%eax),%eax
  800ea8:	99                   	cltd   
}
  800ea9:	5d                   	pop    %ebp
  800eaa:	c3                   	ret    

00800eab <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800eab:	55                   	push   %ebp
  800eac:	89 e5                	mov    %esp,%ebp
  800eae:	56                   	push   %esi
  800eaf:	53                   	push   %ebx
  800eb0:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800eb3:	eb 17                	jmp    800ecc <vprintfmt+0x21>
			if (ch == '\0')
  800eb5:	85 db                	test   %ebx,%ebx
  800eb7:	0f 84 c1 03 00 00    	je     80127e <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  800ebd:	83 ec 08             	sub    $0x8,%esp
  800ec0:	ff 75 0c             	pushl  0xc(%ebp)
  800ec3:	53                   	push   %ebx
  800ec4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ec7:	ff d0                	call   *%eax
  800ec9:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800ecc:	8b 45 10             	mov    0x10(%ebp),%eax
  800ecf:	8d 50 01             	lea    0x1(%eax),%edx
  800ed2:	89 55 10             	mov    %edx,0x10(%ebp)
  800ed5:	8a 00                	mov    (%eax),%al
  800ed7:	0f b6 d8             	movzbl %al,%ebx
  800eda:	83 fb 25             	cmp    $0x25,%ebx
  800edd:	75 d6                	jne    800eb5 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800edf:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800ee3:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800eea:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800ef1:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800ef8:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800eff:	8b 45 10             	mov    0x10(%ebp),%eax
  800f02:	8d 50 01             	lea    0x1(%eax),%edx
  800f05:	89 55 10             	mov    %edx,0x10(%ebp)
  800f08:	8a 00                	mov    (%eax),%al
  800f0a:	0f b6 d8             	movzbl %al,%ebx
  800f0d:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800f10:	83 f8 5b             	cmp    $0x5b,%eax
  800f13:	0f 87 3d 03 00 00    	ja     801256 <vprintfmt+0x3ab>
  800f19:	8b 04 85 78 51 80 00 	mov    0x805178(,%eax,4),%eax
  800f20:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800f22:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800f26:	eb d7                	jmp    800eff <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800f28:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800f2c:	eb d1                	jmp    800eff <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800f2e:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800f35:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800f38:	89 d0                	mov    %edx,%eax
  800f3a:	c1 e0 02             	shl    $0x2,%eax
  800f3d:	01 d0                	add    %edx,%eax
  800f3f:	01 c0                	add    %eax,%eax
  800f41:	01 d8                	add    %ebx,%eax
  800f43:	83 e8 30             	sub    $0x30,%eax
  800f46:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800f49:	8b 45 10             	mov    0x10(%ebp),%eax
  800f4c:	8a 00                	mov    (%eax),%al
  800f4e:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800f51:	83 fb 2f             	cmp    $0x2f,%ebx
  800f54:	7e 3e                	jle    800f94 <vprintfmt+0xe9>
  800f56:	83 fb 39             	cmp    $0x39,%ebx
  800f59:	7f 39                	jg     800f94 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800f5b:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800f5e:	eb d5                	jmp    800f35 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800f60:	8b 45 14             	mov    0x14(%ebp),%eax
  800f63:	83 c0 04             	add    $0x4,%eax
  800f66:	89 45 14             	mov    %eax,0x14(%ebp)
  800f69:	8b 45 14             	mov    0x14(%ebp),%eax
  800f6c:	83 e8 04             	sub    $0x4,%eax
  800f6f:	8b 00                	mov    (%eax),%eax
  800f71:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800f74:	eb 1f                	jmp    800f95 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800f76:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800f7a:	79 83                	jns    800eff <vprintfmt+0x54>
				width = 0;
  800f7c:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800f83:	e9 77 ff ff ff       	jmp    800eff <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800f88:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800f8f:	e9 6b ff ff ff       	jmp    800eff <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800f94:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800f95:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800f99:	0f 89 60 ff ff ff    	jns    800eff <vprintfmt+0x54>
				width = precision, precision = -1;
  800f9f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800fa2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800fa5:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800fac:	e9 4e ff ff ff       	jmp    800eff <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800fb1:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800fb4:	e9 46 ff ff ff       	jmp    800eff <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800fb9:	8b 45 14             	mov    0x14(%ebp),%eax
  800fbc:	83 c0 04             	add    $0x4,%eax
  800fbf:	89 45 14             	mov    %eax,0x14(%ebp)
  800fc2:	8b 45 14             	mov    0x14(%ebp),%eax
  800fc5:	83 e8 04             	sub    $0x4,%eax
  800fc8:	8b 00                	mov    (%eax),%eax
  800fca:	83 ec 08             	sub    $0x8,%esp
  800fcd:	ff 75 0c             	pushl  0xc(%ebp)
  800fd0:	50                   	push   %eax
  800fd1:	8b 45 08             	mov    0x8(%ebp),%eax
  800fd4:	ff d0                	call   *%eax
  800fd6:	83 c4 10             	add    $0x10,%esp
			break;
  800fd9:	e9 9b 02 00 00       	jmp    801279 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800fde:	8b 45 14             	mov    0x14(%ebp),%eax
  800fe1:	83 c0 04             	add    $0x4,%eax
  800fe4:	89 45 14             	mov    %eax,0x14(%ebp)
  800fe7:	8b 45 14             	mov    0x14(%ebp),%eax
  800fea:	83 e8 04             	sub    $0x4,%eax
  800fed:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800fef:	85 db                	test   %ebx,%ebx
  800ff1:	79 02                	jns    800ff5 <vprintfmt+0x14a>
				err = -err;
  800ff3:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800ff5:	83 fb 64             	cmp    $0x64,%ebx
  800ff8:	7f 0b                	jg     801005 <vprintfmt+0x15a>
  800ffa:	8b 34 9d c0 4f 80 00 	mov    0x804fc0(,%ebx,4),%esi
  801001:	85 f6                	test   %esi,%esi
  801003:	75 19                	jne    80101e <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  801005:	53                   	push   %ebx
  801006:	68 65 51 80 00       	push   $0x805165
  80100b:	ff 75 0c             	pushl  0xc(%ebp)
  80100e:	ff 75 08             	pushl  0x8(%ebp)
  801011:	e8 70 02 00 00       	call   801286 <printfmt>
  801016:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  801019:	e9 5b 02 00 00       	jmp    801279 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  80101e:	56                   	push   %esi
  80101f:	68 6e 51 80 00       	push   $0x80516e
  801024:	ff 75 0c             	pushl  0xc(%ebp)
  801027:	ff 75 08             	pushl  0x8(%ebp)
  80102a:	e8 57 02 00 00       	call   801286 <printfmt>
  80102f:	83 c4 10             	add    $0x10,%esp
			break;
  801032:	e9 42 02 00 00       	jmp    801279 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  801037:	8b 45 14             	mov    0x14(%ebp),%eax
  80103a:	83 c0 04             	add    $0x4,%eax
  80103d:	89 45 14             	mov    %eax,0x14(%ebp)
  801040:	8b 45 14             	mov    0x14(%ebp),%eax
  801043:	83 e8 04             	sub    $0x4,%eax
  801046:	8b 30                	mov    (%eax),%esi
  801048:	85 f6                	test   %esi,%esi
  80104a:	75 05                	jne    801051 <vprintfmt+0x1a6>
				p = "(null)";
  80104c:	be 71 51 80 00       	mov    $0x805171,%esi
			if (width > 0 && padc != '-')
  801051:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801055:	7e 6d                	jle    8010c4 <vprintfmt+0x219>
  801057:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  80105b:	74 67                	je     8010c4 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  80105d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801060:	83 ec 08             	sub    $0x8,%esp
  801063:	50                   	push   %eax
  801064:	56                   	push   %esi
  801065:	e8 26 05 00 00       	call   801590 <strnlen>
  80106a:	83 c4 10             	add    $0x10,%esp
  80106d:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  801070:	eb 16                	jmp    801088 <vprintfmt+0x1dd>
					putch(padc, putdat);
  801072:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  801076:	83 ec 08             	sub    $0x8,%esp
  801079:	ff 75 0c             	pushl  0xc(%ebp)
  80107c:	50                   	push   %eax
  80107d:	8b 45 08             	mov    0x8(%ebp),%eax
  801080:	ff d0                	call   *%eax
  801082:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  801085:	ff 4d e4             	decl   -0x1c(%ebp)
  801088:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80108c:	7f e4                	jg     801072 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80108e:	eb 34                	jmp    8010c4 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  801090:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  801094:	74 1c                	je     8010b2 <vprintfmt+0x207>
  801096:	83 fb 1f             	cmp    $0x1f,%ebx
  801099:	7e 05                	jle    8010a0 <vprintfmt+0x1f5>
  80109b:	83 fb 7e             	cmp    $0x7e,%ebx
  80109e:	7e 12                	jle    8010b2 <vprintfmt+0x207>
					putch('?', putdat);
  8010a0:	83 ec 08             	sub    $0x8,%esp
  8010a3:	ff 75 0c             	pushl  0xc(%ebp)
  8010a6:	6a 3f                	push   $0x3f
  8010a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ab:	ff d0                	call   *%eax
  8010ad:	83 c4 10             	add    $0x10,%esp
  8010b0:	eb 0f                	jmp    8010c1 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  8010b2:	83 ec 08             	sub    $0x8,%esp
  8010b5:	ff 75 0c             	pushl  0xc(%ebp)
  8010b8:	53                   	push   %ebx
  8010b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8010bc:	ff d0                	call   *%eax
  8010be:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8010c1:	ff 4d e4             	decl   -0x1c(%ebp)
  8010c4:	89 f0                	mov    %esi,%eax
  8010c6:	8d 70 01             	lea    0x1(%eax),%esi
  8010c9:	8a 00                	mov    (%eax),%al
  8010cb:	0f be d8             	movsbl %al,%ebx
  8010ce:	85 db                	test   %ebx,%ebx
  8010d0:	74 24                	je     8010f6 <vprintfmt+0x24b>
  8010d2:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8010d6:	78 b8                	js     801090 <vprintfmt+0x1e5>
  8010d8:	ff 4d e0             	decl   -0x20(%ebp)
  8010db:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8010df:	79 af                	jns    801090 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8010e1:	eb 13                	jmp    8010f6 <vprintfmt+0x24b>
				putch(' ', putdat);
  8010e3:	83 ec 08             	sub    $0x8,%esp
  8010e6:	ff 75 0c             	pushl  0xc(%ebp)
  8010e9:	6a 20                	push   $0x20
  8010eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ee:	ff d0                	call   *%eax
  8010f0:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8010f3:	ff 4d e4             	decl   -0x1c(%ebp)
  8010f6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8010fa:	7f e7                	jg     8010e3 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  8010fc:	e9 78 01 00 00       	jmp    801279 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  801101:	83 ec 08             	sub    $0x8,%esp
  801104:	ff 75 e8             	pushl  -0x18(%ebp)
  801107:	8d 45 14             	lea    0x14(%ebp),%eax
  80110a:	50                   	push   %eax
  80110b:	e8 3c fd ff ff       	call   800e4c <getint>
  801110:	83 c4 10             	add    $0x10,%esp
  801113:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801116:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  801119:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80111c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80111f:	85 d2                	test   %edx,%edx
  801121:	79 23                	jns    801146 <vprintfmt+0x29b>
				putch('-', putdat);
  801123:	83 ec 08             	sub    $0x8,%esp
  801126:	ff 75 0c             	pushl  0xc(%ebp)
  801129:	6a 2d                	push   $0x2d
  80112b:	8b 45 08             	mov    0x8(%ebp),%eax
  80112e:	ff d0                	call   *%eax
  801130:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  801133:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801136:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801139:	f7 d8                	neg    %eax
  80113b:	83 d2 00             	adc    $0x0,%edx
  80113e:	f7 da                	neg    %edx
  801140:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801143:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  801146:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  80114d:	e9 bc 00 00 00       	jmp    80120e <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  801152:	83 ec 08             	sub    $0x8,%esp
  801155:	ff 75 e8             	pushl  -0x18(%ebp)
  801158:	8d 45 14             	lea    0x14(%ebp),%eax
  80115b:	50                   	push   %eax
  80115c:	e8 84 fc ff ff       	call   800de5 <getuint>
  801161:	83 c4 10             	add    $0x10,%esp
  801164:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801167:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  80116a:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  801171:	e9 98 00 00 00       	jmp    80120e <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  801176:	83 ec 08             	sub    $0x8,%esp
  801179:	ff 75 0c             	pushl  0xc(%ebp)
  80117c:	6a 58                	push   $0x58
  80117e:	8b 45 08             	mov    0x8(%ebp),%eax
  801181:	ff d0                	call   *%eax
  801183:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  801186:	83 ec 08             	sub    $0x8,%esp
  801189:	ff 75 0c             	pushl  0xc(%ebp)
  80118c:	6a 58                	push   $0x58
  80118e:	8b 45 08             	mov    0x8(%ebp),%eax
  801191:	ff d0                	call   *%eax
  801193:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  801196:	83 ec 08             	sub    $0x8,%esp
  801199:	ff 75 0c             	pushl  0xc(%ebp)
  80119c:	6a 58                	push   $0x58
  80119e:	8b 45 08             	mov    0x8(%ebp),%eax
  8011a1:	ff d0                	call   *%eax
  8011a3:	83 c4 10             	add    $0x10,%esp
			break;
  8011a6:	e9 ce 00 00 00       	jmp    801279 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  8011ab:	83 ec 08             	sub    $0x8,%esp
  8011ae:	ff 75 0c             	pushl  0xc(%ebp)
  8011b1:	6a 30                	push   $0x30
  8011b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8011b6:	ff d0                	call   *%eax
  8011b8:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  8011bb:	83 ec 08             	sub    $0x8,%esp
  8011be:	ff 75 0c             	pushl  0xc(%ebp)
  8011c1:	6a 78                	push   $0x78
  8011c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8011c6:	ff d0                	call   *%eax
  8011c8:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  8011cb:	8b 45 14             	mov    0x14(%ebp),%eax
  8011ce:	83 c0 04             	add    $0x4,%eax
  8011d1:	89 45 14             	mov    %eax,0x14(%ebp)
  8011d4:	8b 45 14             	mov    0x14(%ebp),%eax
  8011d7:	83 e8 04             	sub    $0x4,%eax
  8011da:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  8011dc:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8011df:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  8011e6:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  8011ed:	eb 1f                	jmp    80120e <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  8011ef:	83 ec 08             	sub    $0x8,%esp
  8011f2:	ff 75 e8             	pushl  -0x18(%ebp)
  8011f5:	8d 45 14             	lea    0x14(%ebp),%eax
  8011f8:	50                   	push   %eax
  8011f9:	e8 e7 fb ff ff       	call   800de5 <getuint>
  8011fe:	83 c4 10             	add    $0x10,%esp
  801201:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801204:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  801207:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  80120e:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  801212:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801215:	83 ec 04             	sub    $0x4,%esp
  801218:	52                   	push   %edx
  801219:	ff 75 e4             	pushl  -0x1c(%ebp)
  80121c:	50                   	push   %eax
  80121d:	ff 75 f4             	pushl  -0xc(%ebp)
  801220:	ff 75 f0             	pushl  -0x10(%ebp)
  801223:	ff 75 0c             	pushl  0xc(%ebp)
  801226:	ff 75 08             	pushl  0x8(%ebp)
  801229:	e8 00 fb ff ff       	call   800d2e <printnum>
  80122e:	83 c4 20             	add    $0x20,%esp
			break;
  801231:	eb 46                	jmp    801279 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  801233:	83 ec 08             	sub    $0x8,%esp
  801236:	ff 75 0c             	pushl  0xc(%ebp)
  801239:	53                   	push   %ebx
  80123a:	8b 45 08             	mov    0x8(%ebp),%eax
  80123d:	ff d0                	call   *%eax
  80123f:	83 c4 10             	add    $0x10,%esp
			break;
  801242:	eb 35                	jmp    801279 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  801244:	c6 05 44 60 80 00 00 	movb   $0x0,0x806044
			break;
  80124b:	eb 2c                	jmp    801279 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  80124d:	c6 05 44 60 80 00 01 	movb   $0x1,0x806044
			break;
  801254:	eb 23                	jmp    801279 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  801256:	83 ec 08             	sub    $0x8,%esp
  801259:	ff 75 0c             	pushl  0xc(%ebp)
  80125c:	6a 25                	push   $0x25
  80125e:	8b 45 08             	mov    0x8(%ebp),%eax
  801261:	ff d0                	call   *%eax
  801263:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  801266:	ff 4d 10             	decl   0x10(%ebp)
  801269:	eb 03                	jmp    80126e <vprintfmt+0x3c3>
  80126b:	ff 4d 10             	decl   0x10(%ebp)
  80126e:	8b 45 10             	mov    0x10(%ebp),%eax
  801271:	48                   	dec    %eax
  801272:	8a 00                	mov    (%eax),%al
  801274:	3c 25                	cmp    $0x25,%al
  801276:	75 f3                	jne    80126b <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  801278:	90                   	nop
		}
	}
  801279:	e9 35 fc ff ff       	jmp    800eb3 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  80127e:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  80127f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801282:	5b                   	pop    %ebx
  801283:	5e                   	pop    %esi
  801284:	5d                   	pop    %ebp
  801285:	c3                   	ret    

00801286 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  801286:	55                   	push   %ebp
  801287:	89 e5                	mov    %esp,%ebp
  801289:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  80128c:	8d 45 10             	lea    0x10(%ebp),%eax
  80128f:	83 c0 04             	add    $0x4,%eax
  801292:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  801295:	8b 45 10             	mov    0x10(%ebp),%eax
  801298:	ff 75 f4             	pushl  -0xc(%ebp)
  80129b:	50                   	push   %eax
  80129c:	ff 75 0c             	pushl  0xc(%ebp)
  80129f:	ff 75 08             	pushl  0x8(%ebp)
  8012a2:	e8 04 fc ff ff       	call   800eab <vprintfmt>
  8012a7:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  8012aa:	90                   	nop
  8012ab:	c9                   	leave  
  8012ac:	c3                   	ret    

008012ad <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8012ad:	55                   	push   %ebp
  8012ae:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  8012b0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012b3:	8b 40 08             	mov    0x8(%eax),%eax
  8012b6:	8d 50 01             	lea    0x1(%eax),%edx
  8012b9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012bc:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  8012bf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012c2:	8b 10                	mov    (%eax),%edx
  8012c4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012c7:	8b 40 04             	mov    0x4(%eax),%eax
  8012ca:	39 c2                	cmp    %eax,%edx
  8012cc:	73 12                	jae    8012e0 <sprintputch+0x33>
		*b->buf++ = ch;
  8012ce:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012d1:	8b 00                	mov    (%eax),%eax
  8012d3:	8d 48 01             	lea    0x1(%eax),%ecx
  8012d6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012d9:	89 0a                	mov    %ecx,(%edx)
  8012db:	8b 55 08             	mov    0x8(%ebp),%edx
  8012de:	88 10                	mov    %dl,(%eax)
}
  8012e0:	90                   	nop
  8012e1:	5d                   	pop    %ebp
  8012e2:	c3                   	ret    

008012e3 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8012e3:	55                   	push   %ebp
  8012e4:	89 e5                	mov    %esp,%ebp
  8012e6:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  8012e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8012ec:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8012ef:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012f2:	8d 50 ff             	lea    -0x1(%eax),%edx
  8012f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8012f8:	01 d0                	add    %edx,%eax
  8012fa:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8012fd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  801304:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801308:	74 06                	je     801310 <vsnprintf+0x2d>
  80130a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80130e:	7f 07                	jg     801317 <vsnprintf+0x34>
		return -E_INVAL;
  801310:	b8 03 00 00 00       	mov    $0x3,%eax
  801315:	eb 20                	jmp    801337 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  801317:	ff 75 14             	pushl  0x14(%ebp)
  80131a:	ff 75 10             	pushl  0x10(%ebp)
  80131d:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801320:	50                   	push   %eax
  801321:	68 ad 12 80 00       	push   $0x8012ad
  801326:	e8 80 fb ff ff       	call   800eab <vprintfmt>
  80132b:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  80132e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801331:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  801334:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801337:	c9                   	leave  
  801338:	c3                   	ret    

00801339 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801339:	55                   	push   %ebp
  80133a:	89 e5                	mov    %esp,%ebp
  80133c:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  80133f:	8d 45 10             	lea    0x10(%ebp),%eax
  801342:	83 c0 04             	add    $0x4,%eax
  801345:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  801348:	8b 45 10             	mov    0x10(%ebp),%eax
  80134b:	ff 75 f4             	pushl  -0xc(%ebp)
  80134e:	50                   	push   %eax
  80134f:	ff 75 0c             	pushl  0xc(%ebp)
  801352:	ff 75 08             	pushl  0x8(%ebp)
  801355:	e8 89 ff ff ff       	call   8012e3 <vsnprintf>
  80135a:	83 c4 10             	add    $0x10,%esp
  80135d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  801360:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801363:	c9                   	leave  
  801364:	c3                   	ret    

00801365 <readline>:
#include <inc/lib.h>

//static char buf[BUFLEN];

void readline(const char *prompt, char* buf)
{
  801365:	55                   	push   %ebp
  801366:	89 e5                	mov    %esp,%ebp
  801368:	83 ec 18             	sub    $0x18,%esp
	int i, c, echoing;

	if (prompt != NULL)
  80136b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80136f:	74 13                	je     801384 <readline+0x1f>
		cprintf("%s", prompt);
  801371:	83 ec 08             	sub    $0x8,%esp
  801374:	ff 75 08             	pushl  0x8(%ebp)
  801377:	68 e8 52 80 00       	push   $0x8052e8
  80137c:	e8 0b f9 ff ff       	call   800c8c <cprintf>
  801381:	83 c4 10             	add    $0x10,%esp

	i = 0;
  801384:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  80138b:	83 ec 0c             	sub    $0xc,%esp
  80138e:	6a 00                	push   $0x0
  801390:	e8 66 f4 ff ff       	call   8007fb <iscons>
  801395:	83 c4 10             	add    $0x10,%esp
  801398:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  80139b:	e8 48 f4 ff ff       	call   8007e8 <getchar>
  8013a0:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (c < 0) {
  8013a3:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8013a7:	79 22                	jns    8013cb <readline+0x66>
			if (c != -E_EOF)
  8013a9:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  8013ad:	0f 84 ad 00 00 00    	je     801460 <readline+0xfb>
				cprintf("read error: %e\n", c);
  8013b3:	83 ec 08             	sub    $0x8,%esp
  8013b6:	ff 75 ec             	pushl  -0x14(%ebp)
  8013b9:	68 eb 52 80 00       	push   $0x8052eb
  8013be:	e8 c9 f8 ff ff       	call   800c8c <cprintf>
  8013c3:	83 c4 10             	add    $0x10,%esp
			break;
  8013c6:	e9 95 00 00 00       	jmp    801460 <readline+0xfb>
		} else if (c >= ' ' && i < BUFLEN-1) {
  8013cb:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  8013cf:	7e 34                	jle    801405 <readline+0xa0>
  8013d1:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  8013d8:	7f 2b                	jg     801405 <readline+0xa0>
			if (echoing)
  8013da:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8013de:	74 0e                	je     8013ee <readline+0x89>
				cputchar(c);
  8013e0:	83 ec 0c             	sub    $0xc,%esp
  8013e3:	ff 75 ec             	pushl  -0x14(%ebp)
  8013e6:	e8 de f3 ff ff       	call   8007c9 <cputchar>
  8013eb:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  8013ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8013f1:	8d 50 01             	lea    0x1(%eax),%edx
  8013f4:	89 55 f4             	mov    %edx,-0xc(%ebp)
  8013f7:	89 c2                	mov    %eax,%edx
  8013f9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013fc:	01 d0                	add    %edx,%eax
  8013fe:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801401:	88 10                	mov    %dl,(%eax)
  801403:	eb 56                	jmp    80145b <readline+0xf6>
		} else if (c == '\b' && i > 0) {
  801405:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  801409:	75 1f                	jne    80142a <readline+0xc5>
  80140b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80140f:	7e 19                	jle    80142a <readline+0xc5>
			if (echoing)
  801411:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801415:	74 0e                	je     801425 <readline+0xc0>
				cputchar(c);
  801417:	83 ec 0c             	sub    $0xc,%esp
  80141a:	ff 75 ec             	pushl  -0x14(%ebp)
  80141d:	e8 a7 f3 ff ff       	call   8007c9 <cputchar>
  801422:	83 c4 10             	add    $0x10,%esp

			i--;
  801425:	ff 4d f4             	decl   -0xc(%ebp)
  801428:	eb 31                	jmp    80145b <readline+0xf6>
		} else if (c == '\n' || c == '\r') {
  80142a:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  80142e:	74 0a                	je     80143a <readline+0xd5>
  801430:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  801434:	0f 85 61 ff ff ff    	jne    80139b <readline+0x36>
			if (echoing)
  80143a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80143e:	74 0e                	je     80144e <readline+0xe9>
				cputchar(c);
  801440:	83 ec 0c             	sub    $0xc,%esp
  801443:	ff 75 ec             	pushl  -0x14(%ebp)
  801446:	e8 7e f3 ff ff       	call   8007c9 <cputchar>
  80144b:	83 c4 10             	add    $0x10,%esp

			buf[i] = 0;
  80144e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801451:	8b 45 0c             	mov    0xc(%ebp),%eax
  801454:	01 d0                	add    %edx,%eax
  801456:	c6 00 00             	movb   $0x0,(%eax)
			break;
  801459:	eb 06                	jmp    801461 <readline+0xfc>
		}
	}
  80145b:	e9 3b ff ff ff       	jmp    80139b <readline+0x36>
	while (1) {
		c = getchar();
		if (c < 0) {
			if (c != -E_EOF)
				cprintf("read error: %e\n", c);
			break;
  801460:	90                   	nop

			buf[i] = 0;
			break;
		}
	}
}
  801461:	90                   	nop
  801462:	c9                   	leave  
  801463:	c3                   	ret    

00801464 <atomic_readline>:

void atomic_readline(const char *prompt, char* buf)
{
  801464:	55                   	push   %ebp
  801465:	89 e5                	mov    %esp,%ebp
  801467:	83 ec 18             	sub    $0x18,%esp
	sys_lock_cons();
  80146a:	e8 e0 22 00 00       	call   80374f <sys_lock_cons>
	{
		int i, c, echoing;

		if (prompt != NULL)
  80146f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801473:	74 13                	je     801488 <atomic_readline+0x24>
			cprintf("%s", prompt);
  801475:	83 ec 08             	sub    $0x8,%esp
  801478:	ff 75 08             	pushl  0x8(%ebp)
  80147b:	68 e8 52 80 00       	push   $0x8052e8
  801480:	e8 07 f8 ff ff       	call   800c8c <cprintf>
  801485:	83 c4 10             	add    $0x10,%esp

		i = 0;
  801488:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
		echoing = iscons(0);
  80148f:	83 ec 0c             	sub    $0xc,%esp
  801492:	6a 00                	push   $0x0
  801494:	e8 62 f3 ff ff       	call   8007fb <iscons>
  801499:	83 c4 10             	add    $0x10,%esp
  80149c:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (1) {
			c = getchar();
  80149f:	e8 44 f3 ff ff       	call   8007e8 <getchar>
  8014a4:	89 45 ec             	mov    %eax,-0x14(%ebp)
			if (c < 0) {
  8014a7:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8014ab:	79 22                	jns    8014cf <atomic_readline+0x6b>
				if (c != -E_EOF)
  8014ad:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  8014b1:	0f 84 ad 00 00 00    	je     801564 <atomic_readline+0x100>
					cprintf("read error: %e\n", c);
  8014b7:	83 ec 08             	sub    $0x8,%esp
  8014ba:	ff 75 ec             	pushl  -0x14(%ebp)
  8014bd:	68 eb 52 80 00       	push   $0x8052eb
  8014c2:	e8 c5 f7 ff ff       	call   800c8c <cprintf>
  8014c7:	83 c4 10             	add    $0x10,%esp
				break;
  8014ca:	e9 95 00 00 00       	jmp    801564 <atomic_readline+0x100>
			} else if (c >= ' ' && i < BUFLEN-1) {
  8014cf:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  8014d3:	7e 34                	jle    801509 <atomic_readline+0xa5>
  8014d5:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  8014dc:	7f 2b                	jg     801509 <atomic_readline+0xa5>
				if (echoing)
  8014de:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8014e2:	74 0e                	je     8014f2 <atomic_readline+0x8e>
					cputchar(c);
  8014e4:	83 ec 0c             	sub    $0xc,%esp
  8014e7:	ff 75 ec             	pushl  -0x14(%ebp)
  8014ea:	e8 da f2 ff ff       	call   8007c9 <cputchar>
  8014ef:	83 c4 10             	add    $0x10,%esp
				buf[i++] = c;
  8014f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014f5:	8d 50 01             	lea    0x1(%eax),%edx
  8014f8:	89 55 f4             	mov    %edx,-0xc(%ebp)
  8014fb:	89 c2                	mov    %eax,%edx
  8014fd:	8b 45 0c             	mov    0xc(%ebp),%eax
  801500:	01 d0                	add    %edx,%eax
  801502:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801505:	88 10                	mov    %dl,(%eax)
  801507:	eb 56                	jmp    80155f <atomic_readline+0xfb>
			} else if (c == '\b' && i > 0) {
  801509:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  80150d:	75 1f                	jne    80152e <atomic_readline+0xca>
  80150f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801513:	7e 19                	jle    80152e <atomic_readline+0xca>
				if (echoing)
  801515:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801519:	74 0e                	je     801529 <atomic_readline+0xc5>
					cputchar(c);
  80151b:	83 ec 0c             	sub    $0xc,%esp
  80151e:	ff 75 ec             	pushl  -0x14(%ebp)
  801521:	e8 a3 f2 ff ff       	call   8007c9 <cputchar>
  801526:	83 c4 10             	add    $0x10,%esp
				i--;
  801529:	ff 4d f4             	decl   -0xc(%ebp)
  80152c:	eb 31                	jmp    80155f <atomic_readline+0xfb>
			} else if (c == '\n' || c == '\r') {
  80152e:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  801532:	74 0a                	je     80153e <atomic_readline+0xda>
  801534:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  801538:	0f 85 61 ff ff ff    	jne    80149f <atomic_readline+0x3b>
				if (echoing)
  80153e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801542:	74 0e                	je     801552 <atomic_readline+0xee>
					cputchar(c);
  801544:	83 ec 0c             	sub    $0xc,%esp
  801547:	ff 75 ec             	pushl  -0x14(%ebp)
  80154a:	e8 7a f2 ff ff       	call   8007c9 <cputchar>
  80154f:	83 c4 10             	add    $0x10,%esp
				buf[i] = 0;
  801552:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801555:	8b 45 0c             	mov    0xc(%ebp),%eax
  801558:	01 d0                	add    %edx,%eax
  80155a:	c6 00 00             	movb   $0x0,(%eax)
				break;
  80155d:	eb 06                	jmp    801565 <atomic_readline+0x101>
			}
		}
  80155f:	e9 3b ff ff ff       	jmp    80149f <atomic_readline+0x3b>
		while (1) {
			c = getchar();
			if (c < 0) {
				if (c != -E_EOF)
					cprintf("read error: %e\n", c);
				break;
  801564:	90                   	nop
				buf[i] = 0;
				break;
			}
		}
	}
	sys_unlock_cons();
  801565:	e8 ff 21 00 00       	call   803769 <sys_unlock_cons>
}
  80156a:	90                   	nop
  80156b:	c9                   	leave  
  80156c:	c3                   	ret    

0080156d <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  80156d:	55                   	push   %ebp
  80156e:	89 e5                	mov    %esp,%ebp
  801570:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  801573:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80157a:	eb 06                	jmp    801582 <strlen+0x15>
		n++;
  80157c:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  80157f:	ff 45 08             	incl   0x8(%ebp)
  801582:	8b 45 08             	mov    0x8(%ebp),%eax
  801585:	8a 00                	mov    (%eax),%al
  801587:	84 c0                	test   %al,%al
  801589:	75 f1                	jne    80157c <strlen+0xf>
		n++;
	return n;
  80158b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80158e:	c9                   	leave  
  80158f:	c3                   	ret    

00801590 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  801590:	55                   	push   %ebp
  801591:	89 e5                	mov    %esp,%ebp
  801593:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801596:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80159d:	eb 09                	jmp    8015a8 <strnlen+0x18>
		n++;
  80159f:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8015a2:	ff 45 08             	incl   0x8(%ebp)
  8015a5:	ff 4d 0c             	decl   0xc(%ebp)
  8015a8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8015ac:	74 09                	je     8015b7 <strnlen+0x27>
  8015ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8015b1:	8a 00                	mov    (%eax),%al
  8015b3:	84 c0                	test   %al,%al
  8015b5:	75 e8                	jne    80159f <strnlen+0xf>
		n++;
	return n;
  8015b7:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8015ba:	c9                   	leave  
  8015bb:	c3                   	ret    

008015bc <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8015bc:	55                   	push   %ebp
  8015bd:	89 e5                	mov    %esp,%ebp
  8015bf:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  8015c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8015c5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  8015c8:	90                   	nop
  8015c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8015cc:	8d 50 01             	lea    0x1(%eax),%edx
  8015cf:	89 55 08             	mov    %edx,0x8(%ebp)
  8015d2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015d5:	8d 4a 01             	lea    0x1(%edx),%ecx
  8015d8:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8015db:	8a 12                	mov    (%edx),%dl
  8015dd:	88 10                	mov    %dl,(%eax)
  8015df:	8a 00                	mov    (%eax),%al
  8015e1:	84 c0                	test   %al,%al
  8015e3:	75 e4                	jne    8015c9 <strcpy+0xd>
		/* do nothing */;
	return ret;
  8015e5:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8015e8:	c9                   	leave  
  8015e9:	c3                   	ret    

008015ea <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  8015ea:	55                   	push   %ebp
  8015eb:	89 e5                	mov    %esp,%ebp
  8015ed:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  8015f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8015f3:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  8015f6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8015fd:	eb 1f                	jmp    80161e <strncpy+0x34>
		*dst++ = *src;
  8015ff:	8b 45 08             	mov    0x8(%ebp),%eax
  801602:	8d 50 01             	lea    0x1(%eax),%edx
  801605:	89 55 08             	mov    %edx,0x8(%ebp)
  801608:	8b 55 0c             	mov    0xc(%ebp),%edx
  80160b:	8a 12                	mov    (%edx),%dl
  80160d:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  80160f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801612:	8a 00                	mov    (%eax),%al
  801614:	84 c0                	test   %al,%al
  801616:	74 03                	je     80161b <strncpy+0x31>
			src++;
  801618:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80161b:	ff 45 fc             	incl   -0x4(%ebp)
  80161e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801621:	3b 45 10             	cmp    0x10(%ebp),%eax
  801624:	72 d9                	jb     8015ff <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801626:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801629:	c9                   	leave  
  80162a:	c3                   	ret    

0080162b <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  80162b:	55                   	push   %ebp
  80162c:	89 e5                	mov    %esp,%ebp
  80162e:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  801631:	8b 45 08             	mov    0x8(%ebp),%eax
  801634:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  801637:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80163b:	74 30                	je     80166d <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  80163d:	eb 16                	jmp    801655 <strlcpy+0x2a>
			*dst++ = *src++;
  80163f:	8b 45 08             	mov    0x8(%ebp),%eax
  801642:	8d 50 01             	lea    0x1(%eax),%edx
  801645:	89 55 08             	mov    %edx,0x8(%ebp)
  801648:	8b 55 0c             	mov    0xc(%ebp),%edx
  80164b:	8d 4a 01             	lea    0x1(%edx),%ecx
  80164e:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801651:	8a 12                	mov    (%edx),%dl
  801653:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801655:	ff 4d 10             	decl   0x10(%ebp)
  801658:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80165c:	74 09                	je     801667 <strlcpy+0x3c>
  80165e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801661:	8a 00                	mov    (%eax),%al
  801663:	84 c0                	test   %al,%al
  801665:	75 d8                	jne    80163f <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  801667:	8b 45 08             	mov    0x8(%ebp),%eax
  80166a:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  80166d:	8b 55 08             	mov    0x8(%ebp),%edx
  801670:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801673:	29 c2                	sub    %eax,%edx
  801675:	89 d0                	mov    %edx,%eax
}
  801677:	c9                   	leave  
  801678:	c3                   	ret    

00801679 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801679:	55                   	push   %ebp
  80167a:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  80167c:	eb 06                	jmp    801684 <strcmp+0xb>
		p++, q++;
  80167e:	ff 45 08             	incl   0x8(%ebp)
  801681:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801684:	8b 45 08             	mov    0x8(%ebp),%eax
  801687:	8a 00                	mov    (%eax),%al
  801689:	84 c0                	test   %al,%al
  80168b:	74 0e                	je     80169b <strcmp+0x22>
  80168d:	8b 45 08             	mov    0x8(%ebp),%eax
  801690:	8a 10                	mov    (%eax),%dl
  801692:	8b 45 0c             	mov    0xc(%ebp),%eax
  801695:	8a 00                	mov    (%eax),%al
  801697:	38 c2                	cmp    %al,%dl
  801699:	74 e3                	je     80167e <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80169b:	8b 45 08             	mov    0x8(%ebp),%eax
  80169e:	8a 00                	mov    (%eax),%al
  8016a0:	0f b6 d0             	movzbl %al,%edx
  8016a3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016a6:	8a 00                	mov    (%eax),%al
  8016a8:	0f b6 c0             	movzbl %al,%eax
  8016ab:	29 c2                	sub    %eax,%edx
  8016ad:	89 d0                	mov    %edx,%eax
}
  8016af:	5d                   	pop    %ebp
  8016b0:	c3                   	ret    

008016b1 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  8016b1:	55                   	push   %ebp
  8016b2:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  8016b4:	eb 09                	jmp    8016bf <strncmp+0xe>
		n--, p++, q++;
  8016b6:	ff 4d 10             	decl   0x10(%ebp)
  8016b9:	ff 45 08             	incl   0x8(%ebp)
  8016bc:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  8016bf:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8016c3:	74 17                	je     8016dc <strncmp+0x2b>
  8016c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8016c8:	8a 00                	mov    (%eax),%al
  8016ca:	84 c0                	test   %al,%al
  8016cc:	74 0e                	je     8016dc <strncmp+0x2b>
  8016ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8016d1:	8a 10                	mov    (%eax),%dl
  8016d3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016d6:	8a 00                	mov    (%eax),%al
  8016d8:	38 c2                	cmp    %al,%dl
  8016da:	74 da                	je     8016b6 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  8016dc:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8016e0:	75 07                	jne    8016e9 <strncmp+0x38>
		return 0;
  8016e2:	b8 00 00 00 00       	mov    $0x0,%eax
  8016e7:	eb 14                	jmp    8016fd <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8016e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8016ec:	8a 00                	mov    (%eax),%al
  8016ee:	0f b6 d0             	movzbl %al,%edx
  8016f1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016f4:	8a 00                	mov    (%eax),%al
  8016f6:	0f b6 c0             	movzbl %al,%eax
  8016f9:	29 c2                	sub    %eax,%edx
  8016fb:	89 d0                	mov    %edx,%eax
}
  8016fd:	5d                   	pop    %ebp
  8016fe:	c3                   	ret    

008016ff <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8016ff:	55                   	push   %ebp
  801700:	89 e5                	mov    %esp,%ebp
  801702:	83 ec 04             	sub    $0x4,%esp
  801705:	8b 45 0c             	mov    0xc(%ebp),%eax
  801708:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  80170b:	eb 12                	jmp    80171f <strchr+0x20>
		if (*s == c)
  80170d:	8b 45 08             	mov    0x8(%ebp),%eax
  801710:	8a 00                	mov    (%eax),%al
  801712:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801715:	75 05                	jne    80171c <strchr+0x1d>
			return (char *) s;
  801717:	8b 45 08             	mov    0x8(%ebp),%eax
  80171a:	eb 11                	jmp    80172d <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  80171c:	ff 45 08             	incl   0x8(%ebp)
  80171f:	8b 45 08             	mov    0x8(%ebp),%eax
  801722:	8a 00                	mov    (%eax),%al
  801724:	84 c0                	test   %al,%al
  801726:	75 e5                	jne    80170d <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  801728:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80172d:	c9                   	leave  
  80172e:	c3                   	ret    

0080172f <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80172f:	55                   	push   %ebp
  801730:	89 e5                	mov    %esp,%ebp
  801732:	83 ec 04             	sub    $0x4,%esp
  801735:	8b 45 0c             	mov    0xc(%ebp),%eax
  801738:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  80173b:	eb 0d                	jmp    80174a <strfind+0x1b>
		if (*s == c)
  80173d:	8b 45 08             	mov    0x8(%ebp),%eax
  801740:	8a 00                	mov    (%eax),%al
  801742:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801745:	74 0e                	je     801755 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801747:	ff 45 08             	incl   0x8(%ebp)
  80174a:	8b 45 08             	mov    0x8(%ebp),%eax
  80174d:	8a 00                	mov    (%eax),%al
  80174f:	84 c0                	test   %al,%al
  801751:	75 ea                	jne    80173d <strfind+0xe>
  801753:	eb 01                	jmp    801756 <strfind+0x27>
		if (*s == c)
			break;
  801755:	90                   	nop
	return (char *) s;
  801756:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801759:	c9                   	leave  
  80175a:	c3                   	ret    

0080175b <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  80175b:	55                   	push   %ebp
  80175c:	89 e5                	mov    %esp,%ebp
  80175e:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  801761:	8b 45 08             	mov    0x8(%ebp),%eax
  801764:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  801767:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  80176b:	76 63                	jbe    8017d0 <memset+0x75>
		uint64 data_block = c;
  80176d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801770:	99                   	cltd   
  801771:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801774:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  801777:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80177a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80177d:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  801781:	c1 e0 08             	shl    $0x8,%eax
  801784:	09 45 f0             	or     %eax,-0x10(%ebp)
  801787:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  80178a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80178d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801790:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  801794:	c1 e0 10             	shl    $0x10,%eax
  801797:	09 45 f0             	or     %eax,-0x10(%ebp)
  80179a:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  80179d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017a0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8017a3:	89 c2                	mov    %eax,%edx
  8017a5:	b8 00 00 00 00       	mov    $0x0,%eax
  8017aa:	09 45 f0             	or     %eax,-0x10(%ebp)
  8017ad:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  8017b0:	eb 18                	jmp    8017ca <memset+0x6f>
			*p64++ = data_block, n -= 8;
  8017b2:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8017b5:	8d 41 08             	lea    0x8(%ecx),%eax
  8017b8:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8017bb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017be:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8017c1:	89 01                	mov    %eax,(%ecx)
  8017c3:	89 51 04             	mov    %edx,0x4(%ecx)
  8017c6:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  8017ca:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  8017ce:	77 e2                	ja     8017b2 <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  8017d0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8017d4:	74 23                	je     8017f9 <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  8017d6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8017d9:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  8017dc:	eb 0e                	jmp    8017ec <memset+0x91>
			*p8++ = (uint8)c;
  8017de:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8017e1:	8d 50 01             	lea    0x1(%eax),%edx
  8017e4:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8017e7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017ea:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  8017ec:	8b 45 10             	mov    0x10(%ebp),%eax
  8017ef:	8d 50 ff             	lea    -0x1(%eax),%edx
  8017f2:	89 55 10             	mov    %edx,0x10(%ebp)
  8017f5:	85 c0                	test   %eax,%eax
  8017f7:	75 e5                	jne    8017de <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  8017f9:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8017fc:	c9                   	leave  
  8017fd:	c3                   	ret    

008017fe <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  8017fe:	55                   	push   %ebp
  8017ff:	89 e5                	mov    %esp,%ebp
  801801:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  801804:	8b 45 0c             	mov    0xc(%ebp),%eax
  801807:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  80180a:	8b 45 08             	mov    0x8(%ebp),%eax
  80180d:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  801810:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801814:	76 24                	jbe    80183a <memcpy+0x3c>
		while(n >= 8){
  801816:	eb 1c                	jmp    801834 <memcpy+0x36>
			*d64 = *s64;
  801818:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80181b:	8b 50 04             	mov    0x4(%eax),%edx
  80181e:	8b 00                	mov    (%eax),%eax
  801820:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801823:	89 01                	mov    %eax,(%ecx)
  801825:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  801828:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  80182c:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  801830:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  801834:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801838:	77 de                	ja     801818 <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  80183a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80183e:	74 31                	je     801871 <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  801840:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801843:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  801846:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801849:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  80184c:	eb 16                	jmp    801864 <memcpy+0x66>
			*d8++ = *s8++;
  80184e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801851:	8d 50 01             	lea    0x1(%eax),%edx
  801854:	89 55 f0             	mov    %edx,-0x10(%ebp)
  801857:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80185a:	8d 4a 01             	lea    0x1(%edx),%ecx
  80185d:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  801860:	8a 12                	mov    (%edx),%dl
  801862:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  801864:	8b 45 10             	mov    0x10(%ebp),%eax
  801867:	8d 50 ff             	lea    -0x1(%eax),%edx
  80186a:	89 55 10             	mov    %edx,0x10(%ebp)
  80186d:	85 c0                	test   %eax,%eax
  80186f:	75 dd                	jne    80184e <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  801871:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801874:	c9                   	leave  
  801875:	c3                   	ret    

00801876 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801876:	55                   	push   %ebp
  801877:	89 e5                	mov    %esp,%ebp
  801879:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  80187c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80187f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801882:	8b 45 08             	mov    0x8(%ebp),%eax
  801885:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801888:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80188b:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80188e:	73 50                	jae    8018e0 <memmove+0x6a>
  801890:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801893:	8b 45 10             	mov    0x10(%ebp),%eax
  801896:	01 d0                	add    %edx,%eax
  801898:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80189b:	76 43                	jbe    8018e0 <memmove+0x6a>
		s += n;
  80189d:	8b 45 10             	mov    0x10(%ebp),%eax
  8018a0:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  8018a3:	8b 45 10             	mov    0x10(%ebp),%eax
  8018a6:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  8018a9:	eb 10                	jmp    8018bb <memmove+0x45>
			*--d = *--s;
  8018ab:	ff 4d f8             	decl   -0x8(%ebp)
  8018ae:	ff 4d fc             	decl   -0x4(%ebp)
  8018b1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8018b4:	8a 10                	mov    (%eax),%dl
  8018b6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8018b9:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  8018bb:	8b 45 10             	mov    0x10(%ebp),%eax
  8018be:	8d 50 ff             	lea    -0x1(%eax),%edx
  8018c1:	89 55 10             	mov    %edx,0x10(%ebp)
  8018c4:	85 c0                	test   %eax,%eax
  8018c6:	75 e3                	jne    8018ab <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8018c8:	eb 23                	jmp    8018ed <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  8018ca:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8018cd:	8d 50 01             	lea    0x1(%eax),%edx
  8018d0:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8018d3:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8018d6:	8d 4a 01             	lea    0x1(%edx),%ecx
  8018d9:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8018dc:	8a 12                	mov    (%edx),%dl
  8018de:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  8018e0:	8b 45 10             	mov    0x10(%ebp),%eax
  8018e3:	8d 50 ff             	lea    -0x1(%eax),%edx
  8018e6:	89 55 10             	mov    %edx,0x10(%ebp)
  8018e9:	85 c0                	test   %eax,%eax
  8018eb:	75 dd                	jne    8018ca <memmove+0x54>
			*d++ = *s++;

	return dst;
  8018ed:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8018f0:	c9                   	leave  
  8018f1:	c3                   	ret    

008018f2 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8018f2:	55                   	push   %ebp
  8018f3:	89 e5                	mov    %esp,%ebp
  8018f5:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  8018f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8018fb:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  8018fe:	8b 45 0c             	mov    0xc(%ebp),%eax
  801901:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  801904:	eb 2a                	jmp    801930 <memcmp+0x3e>
		if (*s1 != *s2)
  801906:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801909:	8a 10                	mov    (%eax),%dl
  80190b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80190e:	8a 00                	mov    (%eax),%al
  801910:	38 c2                	cmp    %al,%dl
  801912:	74 16                	je     80192a <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801914:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801917:	8a 00                	mov    (%eax),%al
  801919:	0f b6 d0             	movzbl %al,%edx
  80191c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80191f:	8a 00                	mov    (%eax),%al
  801921:	0f b6 c0             	movzbl %al,%eax
  801924:	29 c2                	sub    %eax,%edx
  801926:	89 d0                	mov    %edx,%eax
  801928:	eb 18                	jmp    801942 <memcmp+0x50>
		s1++, s2++;
  80192a:	ff 45 fc             	incl   -0x4(%ebp)
  80192d:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801930:	8b 45 10             	mov    0x10(%ebp),%eax
  801933:	8d 50 ff             	lea    -0x1(%eax),%edx
  801936:	89 55 10             	mov    %edx,0x10(%ebp)
  801939:	85 c0                	test   %eax,%eax
  80193b:	75 c9                	jne    801906 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  80193d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801942:	c9                   	leave  
  801943:	c3                   	ret    

00801944 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801944:	55                   	push   %ebp
  801945:	89 e5                	mov    %esp,%ebp
  801947:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  80194a:	8b 55 08             	mov    0x8(%ebp),%edx
  80194d:	8b 45 10             	mov    0x10(%ebp),%eax
  801950:	01 d0                	add    %edx,%eax
  801952:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801955:	eb 15                	jmp    80196c <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801957:	8b 45 08             	mov    0x8(%ebp),%eax
  80195a:	8a 00                	mov    (%eax),%al
  80195c:	0f b6 d0             	movzbl %al,%edx
  80195f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801962:	0f b6 c0             	movzbl %al,%eax
  801965:	39 c2                	cmp    %eax,%edx
  801967:	74 0d                	je     801976 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801969:	ff 45 08             	incl   0x8(%ebp)
  80196c:	8b 45 08             	mov    0x8(%ebp),%eax
  80196f:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801972:	72 e3                	jb     801957 <memfind+0x13>
  801974:	eb 01                	jmp    801977 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801976:	90                   	nop
	return (void *) s;
  801977:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80197a:	c9                   	leave  
  80197b:	c3                   	ret    

0080197c <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80197c:	55                   	push   %ebp
  80197d:	89 e5                	mov    %esp,%ebp
  80197f:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801982:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801989:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801990:	eb 03                	jmp    801995 <strtol+0x19>
		s++;
  801992:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801995:	8b 45 08             	mov    0x8(%ebp),%eax
  801998:	8a 00                	mov    (%eax),%al
  80199a:	3c 20                	cmp    $0x20,%al
  80199c:	74 f4                	je     801992 <strtol+0x16>
  80199e:	8b 45 08             	mov    0x8(%ebp),%eax
  8019a1:	8a 00                	mov    (%eax),%al
  8019a3:	3c 09                	cmp    $0x9,%al
  8019a5:	74 eb                	je     801992 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  8019a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8019aa:	8a 00                	mov    (%eax),%al
  8019ac:	3c 2b                	cmp    $0x2b,%al
  8019ae:	75 05                	jne    8019b5 <strtol+0x39>
		s++;
  8019b0:	ff 45 08             	incl   0x8(%ebp)
  8019b3:	eb 13                	jmp    8019c8 <strtol+0x4c>
	else if (*s == '-')
  8019b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8019b8:	8a 00                	mov    (%eax),%al
  8019ba:	3c 2d                	cmp    $0x2d,%al
  8019bc:	75 0a                	jne    8019c8 <strtol+0x4c>
		s++, neg = 1;
  8019be:	ff 45 08             	incl   0x8(%ebp)
  8019c1:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8019c8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8019cc:	74 06                	je     8019d4 <strtol+0x58>
  8019ce:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8019d2:	75 20                	jne    8019f4 <strtol+0x78>
  8019d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8019d7:	8a 00                	mov    (%eax),%al
  8019d9:	3c 30                	cmp    $0x30,%al
  8019db:	75 17                	jne    8019f4 <strtol+0x78>
  8019dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8019e0:	40                   	inc    %eax
  8019e1:	8a 00                	mov    (%eax),%al
  8019e3:	3c 78                	cmp    $0x78,%al
  8019e5:	75 0d                	jne    8019f4 <strtol+0x78>
		s += 2, base = 16;
  8019e7:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8019eb:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8019f2:	eb 28                	jmp    801a1c <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8019f4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8019f8:	75 15                	jne    801a0f <strtol+0x93>
  8019fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8019fd:	8a 00                	mov    (%eax),%al
  8019ff:	3c 30                	cmp    $0x30,%al
  801a01:	75 0c                	jne    801a0f <strtol+0x93>
		s++, base = 8;
  801a03:	ff 45 08             	incl   0x8(%ebp)
  801a06:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801a0d:	eb 0d                	jmp    801a1c <strtol+0xa0>
	else if (base == 0)
  801a0f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801a13:	75 07                	jne    801a1c <strtol+0xa0>
		base = 10;
  801a15:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801a1c:	8b 45 08             	mov    0x8(%ebp),%eax
  801a1f:	8a 00                	mov    (%eax),%al
  801a21:	3c 2f                	cmp    $0x2f,%al
  801a23:	7e 19                	jle    801a3e <strtol+0xc2>
  801a25:	8b 45 08             	mov    0x8(%ebp),%eax
  801a28:	8a 00                	mov    (%eax),%al
  801a2a:	3c 39                	cmp    $0x39,%al
  801a2c:	7f 10                	jg     801a3e <strtol+0xc2>
			dig = *s - '0';
  801a2e:	8b 45 08             	mov    0x8(%ebp),%eax
  801a31:	8a 00                	mov    (%eax),%al
  801a33:	0f be c0             	movsbl %al,%eax
  801a36:	83 e8 30             	sub    $0x30,%eax
  801a39:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801a3c:	eb 42                	jmp    801a80 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801a3e:	8b 45 08             	mov    0x8(%ebp),%eax
  801a41:	8a 00                	mov    (%eax),%al
  801a43:	3c 60                	cmp    $0x60,%al
  801a45:	7e 19                	jle    801a60 <strtol+0xe4>
  801a47:	8b 45 08             	mov    0x8(%ebp),%eax
  801a4a:	8a 00                	mov    (%eax),%al
  801a4c:	3c 7a                	cmp    $0x7a,%al
  801a4e:	7f 10                	jg     801a60 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801a50:	8b 45 08             	mov    0x8(%ebp),%eax
  801a53:	8a 00                	mov    (%eax),%al
  801a55:	0f be c0             	movsbl %al,%eax
  801a58:	83 e8 57             	sub    $0x57,%eax
  801a5b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801a5e:	eb 20                	jmp    801a80 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801a60:	8b 45 08             	mov    0x8(%ebp),%eax
  801a63:	8a 00                	mov    (%eax),%al
  801a65:	3c 40                	cmp    $0x40,%al
  801a67:	7e 39                	jle    801aa2 <strtol+0x126>
  801a69:	8b 45 08             	mov    0x8(%ebp),%eax
  801a6c:	8a 00                	mov    (%eax),%al
  801a6e:	3c 5a                	cmp    $0x5a,%al
  801a70:	7f 30                	jg     801aa2 <strtol+0x126>
			dig = *s - 'A' + 10;
  801a72:	8b 45 08             	mov    0x8(%ebp),%eax
  801a75:	8a 00                	mov    (%eax),%al
  801a77:	0f be c0             	movsbl %al,%eax
  801a7a:	83 e8 37             	sub    $0x37,%eax
  801a7d:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801a80:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a83:	3b 45 10             	cmp    0x10(%ebp),%eax
  801a86:	7d 19                	jge    801aa1 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801a88:	ff 45 08             	incl   0x8(%ebp)
  801a8b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801a8e:	0f af 45 10          	imul   0x10(%ebp),%eax
  801a92:	89 c2                	mov    %eax,%edx
  801a94:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a97:	01 d0                	add    %edx,%eax
  801a99:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801a9c:	e9 7b ff ff ff       	jmp    801a1c <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801aa1:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801aa2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801aa6:	74 08                	je     801ab0 <strtol+0x134>
		*endptr = (char *) s;
  801aa8:	8b 45 0c             	mov    0xc(%ebp),%eax
  801aab:	8b 55 08             	mov    0x8(%ebp),%edx
  801aae:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801ab0:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801ab4:	74 07                	je     801abd <strtol+0x141>
  801ab6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801ab9:	f7 d8                	neg    %eax
  801abb:	eb 03                	jmp    801ac0 <strtol+0x144>
  801abd:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801ac0:	c9                   	leave  
  801ac1:	c3                   	ret    

00801ac2 <ltostr>:

void
ltostr(long value, char *str)
{
  801ac2:	55                   	push   %ebp
  801ac3:	89 e5                	mov    %esp,%ebp
  801ac5:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801ac8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801acf:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801ad6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801ada:	79 13                	jns    801aef <ltostr+0x2d>
	{
		neg = 1;
  801adc:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801ae3:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ae6:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801ae9:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801aec:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801aef:	8b 45 08             	mov    0x8(%ebp),%eax
  801af2:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801af7:	99                   	cltd   
  801af8:	f7 f9                	idiv   %ecx
  801afa:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801afd:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801b00:	8d 50 01             	lea    0x1(%eax),%edx
  801b03:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801b06:	89 c2                	mov    %eax,%edx
  801b08:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b0b:	01 d0                	add    %edx,%eax
  801b0d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801b10:	83 c2 30             	add    $0x30,%edx
  801b13:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801b15:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801b18:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801b1d:	f7 e9                	imul   %ecx
  801b1f:	c1 fa 02             	sar    $0x2,%edx
  801b22:	89 c8                	mov    %ecx,%eax
  801b24:	c1 f8 1f             	sar    $0x1f,%eax
  801b27:	29 c2                	sub    %eax,%edx
  801b29:	89 d0                	mov    %edx,%eax
  801b2b:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  801b2e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801b32:	75 bb                	jne    801aef <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801b34:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801b3b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801b3e:	48                   	dec    %eax
  801b3f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801b42:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801b46:	74 3d                	je     801b85 <ltostr+0xc3>
		start = 1 ;
  801b48:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801b4f:	eb 34                	jmp    801b85 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  801b51:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801b54:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b57:	01 d0                	add    %edx,%eax
  801b59:	8a 00                	mov    (%eax),%al
  801b5b:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801b5e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801b61:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b64:	01 c2                	add    %eax,%edx
  801b66:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801b69:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b6c:	01 c8                	add    %ecx,%eax
  801b6e:	8a 00                	mov    (%eax),%al
  801b70:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801b72:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801b75:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b78:	01 c2                	add    %eax,%edx
  801b7a:	8a 45 eb             	mov    -0x15(%ebp),%al
  801b7d:	88 02                	mov    %al,(%edx)
		start++ ;
  801b7f:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801b82:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801b85:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b88:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801b8b:	7c c4                	jl     801b51 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801b8d:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801b90:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b93:	01 d0                	add    %edx,%eax
  801b95:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801b98:	90                   	nop
  801b99:	c9                   	leave  
  801b9a:	c3                   	ret    

00801b9b <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801b9b:	55                   	push   %ebp
  801b9c:	89 e5                	mov    %esp,%ebp
  801b9e:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801ba1:	ff 75 08             	pushl  0x8(%ebp)
  801ba4:	e8 c4 f9 ff ff       	call   80156d <strlen>
  801ba9:	83 c4 04             	add    $0x4,%esp
  801bac:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801baf:	ff 75 0c             	pushl  0xc(%ebp)
  801bb2:	e8 b6 f9 ff ff       	call   80156d <strlen>
  801bb7:	83 c4 04             	add    $0x4,%esp
  801bba:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801bbd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801bc4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801bcb:	eb 17                	jmp    801be4 <strcconcat+0x49>
		final[s] = str1[s] ;
  801bcd:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801bd0:	8b 45 10             	mov    0x10(%ebp),%eax
  801bd3:	01 c2                	add    %eax,%edx
  801bd5:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801bd8:	8b 45 08             	mov    0x8(%ebp),%eax
  801bdb:	01 c8                	add    %ecx,%eax
  801bdd:	8a 00                	mov    (%eax),%al
  801bdf:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801be1:	ff 45 fc             	incl   -0x4(%ebp)
  801be4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801be7:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801bea:	7c e1                	jl     801bcd <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801bec:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801bf3:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801bfa:	eb 1f                	jmp    801c1b <strcconcat+0x80>
		final[s++] = str2[i] ;
  801bfc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801bff:	8d 50 01             	lea    0x1(%eax),%edx
  801c02:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801c05:	89 c2                	mov    %eax,%edx
  801c07:	8b 45 10             	mov    0x10(%ebp),%eax
  801c0a:	01 c2                	add    %eax,%edx
  801c0c:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801c0f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c12:	01 c8                	add    %ecx,%eax
  801c14:	8a 00                	mov    (%eax),%al
  801c16:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801c18:	ff 45 f8             	incl   -0x8(%ebp)
  801c1b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801c1e:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801c21:	7c d9                	jl     801bfc <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801c23:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801c26:	8b 45 10             	mov    0x10(%ebp),%eax
  801c29:	01 d0                	add    %edx,%eax
  801c2b:	c6 00 00             	movb   $0x0,(%eax)
}
  801c2e:	90                   	nop
  801c2f:	c9                   	leave  
  801c30:	c3                   	ret    

00801c31 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801c31:	55                   	push   %ebp
  801c32:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801c34:	8b 45 14             	mov    0x14(%ebp),%eax
  801c37:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801c3d:	8b 45 14             	mov    0x14(%ebp),%eax
  801c40:	8b 00                	mov    (%eax),%eax
  801c42:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801c49:	8b 45 10             	mov    0x10(%ebp),%eax
  801c4c:	01 d0                	add    %edx,%eax
  801c4e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801c54:	eb 0c                	jmp    801c62 <strsplit+0x31>
			*string++ = 0;
  801c56:	8b 45 08             	mov    0x8(%ebp),%eax
  801c59:	8d 50 01             	lea    0x1(%eax),%edx
  801c5c:	89 55 08             	mov    %edx,0x8(%ebp)
  801c5f:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801c62:	8b 45 08             	mov    0x8(%ebp),%eax
  801c65:	8a 00                	mov    (%eax),%al
  801c67:	84 c0                	test   %al,%al
  801c69:	74 18                	je     801c83 <strsplit+0x52>
  801c6b:	8b 45 08             	mov    0x8(%ebp),%eax
  801c6e:	8a 00                	mov    (%eax),%al
  801c70:	0f be c0             	movsbl %al,%eax
  801c73:	50                   	push   %eax
  801c74:	ff 75 0c             	pushl  0xc(%ebp)
  801c77:	e8 83 fa ff ff       	call   8016ff <strchr>
  801c7c:	83 c4 08             	add    $0x8,%esp
  801c7f:	85 c0                	test   %eax,%eax
  801c81:	75 d3                	jne    801c56 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801c83:	8b 45 08             	mov    0x8(%ebp),%eax
  801c86:	8a 00                	mov    (%eax),%al
  801c88:	84 c0                	test   %al,%al
  801c8a:	74 5a                	je     801ce6 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801c8c:	8b 45 14             	mov    0x14(%ebp),%eax
  801c8f:	8b 00                	mov    (%eax),%eax
  801c91:	83 f8 0f             	cmp    $0xf,%eax
  801c94:	75 07                	jne    801c9d <strsplit+0x6c>
		{
			return 0;
  801c96:	b8 00 00 00 00       	mov    $0x0,%eax
  801c9b:	eb 66                	jmp    801d03 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801c9d:	8b 45 14             	mov    0x14(%ebp),%eax
  801ca0:	8b 00                	mov    (%eax),%eax
  801ca2:	8d 48 01             	lea    0x1(%eax),%ecx
  801ca5:	8b 55 14             	mov    0x14(%ebp),%edx
  801ca8:	89 0a                	mov    %ecx,(%edx)
  801caa:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801cb1:	8b 45 10             	mov    0x10(%ebp),%eax
  801cb4:	01 c2                	add    %eax,%edx
  801cb6:	8b 45 08             	mov    0x8(%ebp),%eax
  801cb9:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801cbb:	eb 03                	jmp    801cc0 <strsplit+0x8f>
			string++;
  801cbd:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801cc0:	8b 45 08             	mov    0x8(%ebp),%eax
  801cc3:	8a 00                	mov    (%eax),%al
  801cc5:	84 c0                	test   %al,%al
  801cc7:	74 8b                	je     801c54 <strsplit+0x23>
  801cc9:	8b 45 08             	mov    0x8(%ebp),%eax
  801ccc:	8a 00                	mov    (%eax),%al
  801cce:	0f be c0             	movsbl %al,%eax
  801cd1:	50                   	push   %eax
  801cd2:	ff 75 0c             	pushl  0xc(%ebp)
  801cd5:	e8 25 fa ff ff       	call   8016ff <strchr>
  801cda:	83 c4 08             	add    $0x8,%esp
  801cdd:	85 c0                	test   %eax,%eax
  801cdf:	74 dc                	je     801cbd <strsplit+0x8c>
			string++;
	}
  801ce1:	e9 6e ff ff ff       	jmp    801c54 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801ce6:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801ce7:	8b 45 14             	mov    0x14(%ebp),%eax
  801cea:	8b 00                	mov    (%eax),%eax
  801cec:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801cf3:	8b 45 10             	mov    0x10(%ebp),%eax
  801cf6:	01 d0                	add    %edx,%eax
  801cf8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801cfe:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801d03:	c9                   	leave  
  801d04:	c3                   	ret    

00801d05 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  801d05:	55                   	push   %ebp
  801d06:	89 e5                	mov    %esp,%ebp
  801d08:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  801d0b:	8b 45 08             	mov    0x8(%ebp),%eax
  801d0e:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  801d11:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801d18:	eb 4a                	jmp    801d64 <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  801d1a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801d1d:	8b 45 08             	mov    0x8(%ebp),%eax
  801d20:	01 c2                	add    %eax,%edx
  801d22:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801d25:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d28:	01 c8                	add    %ecx,%eax
  801d2a:	8a 00                	mov    (%eax),%al
  801d2c:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  801d2e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801d31:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d34:	01 d0                	add    %edx,%eax
  801d36:	8a 00                	mov    (%eax),%al
  801d38:	3c 40                	cmp    $0x40,%al
  801d3a:	7e 25                	jle    801d61 <str2lower+0x5c>
  801d3c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801d3f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d42:	01 d0                	add    %edx,%eax
  801d44:	8a 00                	mov    (%eax),%al
  801d46:	3c 5a                	cmp    $0x5a,%al
  801d48:	7f 17                	jg     801d61 <str2lower+0x5c>
		{
			dst[i] += 32 ;
  801d4a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801d4d:	8b 45 08             	mov    0x8(%ebp),%eax
  801d50:	01 d0                	add    %edx,%eax
  801d52:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801d55:	8b 55 08             	mov    0x8(%ebp),%edx
  801d58:	01 ca                	add    %ecx,%edx
  801d5a:	8a 12                	mov    (%edx),%dl
  801d5c:	83 c2 20             	add    $0x20,%edx
  801d5f:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  801d61:	ff 45 fc             	incl   -0x4(%ebp)
  801d64:	ff 75 0c             	pushl  0xc(%ebp)
  801d67:	e8 01 f8 ff ff       	call   80156d <strlen>
  801d6c:	83 c4 04             	add    $0x4,%esp
  801d6f:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801d72:	7f a6                	jg     801d1a <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  801d74:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801d77:	c9                   	leave  
  801d78:	c3                   	ret    

00801d79 <uheap_init>:
//==============================================
// [1] INITIALIZE USER HEAP:
//==============================================
int __firstTimeFlag = 1;
void uheap_init()
{
  801d79:	55                   	push   %ebp
  801d7a:	89 e5                	mov    %esp,%ebp
  801d7c:	83 ec 08             	sub    $0x8,%esp
	if(__firstTimeFlag)
  801d7f:	a1 08 60 80 00       	mov    0x806008,%eax
  801d84:	85 c0                	test   %eax,%eax
  801d86:	0f 84 95 00 00 00    	je     801e21 <uheap_init+0xa8>
	{
		initialize_dynamic_allocator(USER_HEAP_START, USER_HEAP_START + DYN_ALLOC_MAX_SIZE);
  801d8c:	83 ec 08             	sub    $0x8,%esp
  801d8f:	68 00 00 00 82       	push   $0x82000000
  801d94:	68 00 00 00 80       	push   $0x80000000
  801d99:	e8 59 1f 00 00       	call   803cf7 <initialize_dynamic_allocator>
  801d9e:	83 c4 10             	add    $0x10,%esp
		uheapPlaceStrategy = sys_get_uheap_strategy();
  801da1:	e8 93 1d 00 00       	call   803b39 <sys_get_uheap_strategy>
  801da6:	a3 60 e0 81 00       	mov    %eax,0x81e060
		uheapPageAllocStart = dynAllocEnd + PAGE_SIZE;
  801dab:	a1 40 60 80 00       	mov    0x806040,%eax
  801db0:	05 00 10 00 00       	add    $0x1000,%eax
  801db5:	a3 10 e1 81 00       	mov    %eax,0x81e110
		uheapPageAllocBreak = uheapPageAllocStart;
  801dba:	a1 10 e1 81 00       	mov    0x81e110,%eax
  801dbf:	a3 68 e0 81 00       	mov    %eax,0x81e068
		init_uspinlock(&ulock,"malloc",1);
  801dc4:	83 ec 04             	sub    $0x4,%esp
  801dc7:	6a 01                	push   $0x1
  801dc9:	68 fc 52 80 00       	push   $0x8052fc
  801dce:	68 40 e1 81 00       	push   $0x81e140
  801dd3:	e8 1a 29 00 00       	call   8046f2 <init_uspinlock>
  801dd8:	83 c4 10             	add    $0x10,%esp
		LIST_INIT(&u_freelist);
  801ddb:	c7 05 20 e1 81 00 00 	movl   $0x0,0x81e120
  801de2:	00 00 00 
  801de5:	c7 05 24 e1 81 00 00 	movl   $0x0,0x81e124
  801dec:	00 00 00 
  801def:	c7 05 2c e1 81 00 00 	movl   $0x0,0x81e12c
  801df6:	00 00 00 
		LIST_INIT(&u_allocatedlist);
  801df9:	c7 05 30 e1 81 00 00 	movl   $0x0,0x81e130
  801e00:	00 00 00 
  801e03:	c7 05 34 e1 81 00 00 	movl   $0x0,0x81e134
  801e0a:	00 00 00 
  801e0d:	c7 05 3c e1 81 00 00 	movl   $0x0,0x81e13c
  801e14:	00 00 00 
		__firstTimeFlag = 0;
  801e17:	c7 05 08 60 80 00 00 	movl   $0x0,0x806008
  801e1e:	00 00 00 
	}
}
  801e21:	90                   	nop
  801e22:	c9                   	leave  
  801e23:	c3                   	ret    

00801e24 <get_page>:

//==============================================
// [2] GET A PAGE FROM THE KERNEL FOR DA:
//==============================================
int get_page(void* va)
{
  801e24:	55                   	push   %ebp
  801e25:	89 e5                	mov    %esp,%ebp
  801e27:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_allocate_page(ROUNDDOWN(va, PAGE_SIZE), PERM_USER|PERM_WRITEABLE|PERM_UHPAGE);
  801e2a:	8b 45 08             	mov    0x8(%ebp),%eax
  801e2d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801e30:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e33:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801e38:	83 ec 08             	sub    $0x8,%esp
  801e3b:	68 06 04 00 00       	push   $0x406
  801e40:	50                   	push   %eax
  801e41:	e8 3d 19 00 00       	call   803783 <__sys_allocate_page>
  801e46:	83 c4 10             	add    $0x10,%esp
  801e49:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  801e4c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801e50:	79 14                	jns    801e66 <get_page+0x42>
		panic("get_page() in user: failed to allocate page from the kernel");
  801e52:	83 ec 04             	sub    $0x4,%esp
  801e55:	68 04 53 80 00       	push   $0x805304
  801e5a:	6a 2d                	push   $0x2d
  801e5c:	68 40 53 80 00       	push   $0x805340
  801e61:	e8 58 eb ff ff       	call   8009be <_panic>
	return 0;
  801e66:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e6b:	c9                   	leave  
  801e6c:	c3                   	ret    

00801e6d <return_page>:

//==============================================
// [3] RETURN A PAGE FROM THE DA TO KERNEL:
//==============================================
void return_page(void* va)
{
  801e6d:	55                   	push   %ebp
  801e6e:	89 e5                	mov    %esp,%ebp
  801e70:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_unmap_frame(ROUNDDOWN((uint32)va, PAGE_SIZE));
  801e73:	8b 45 08             	mov    0x8(%ebp),%eax
  801e76:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801e79:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e7c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801e81:	83 ec 0c             	sub    $0xc,%esp
  801e84:	50                   	push   %eax
  801e85:	e8 40 19 00 00       	call   8037ca <__sys_unmap_frame>
  801e8a:	83 c4 10             	add    $0x10,%esp
  801e8d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  801e90:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801e94:	79 14                	jns    801eaa <return_page+0x3d>
		panic("return_page() in user: failed to return a page to the kernel");
  801e96:	83 ec 04             	sub    $0x4,%esp
  801e99:	68 4c 53 80 00       	push   $0x80534c
  801e9e:	6a 38                	push   $0x38
  801ea0:	68 40 53 80 00       	push   $0x805340
  801ea5:	e8 14 eb ff ff       	call   8009be <_panic>
}
  801eaa:	90                   	nop
  801eab:	c9                   	leave  
  801eac:	c3                   	ret    

00801ead <malloc>:

//=================================
// [1] ALLOCATE SPACE IN USER HEAP:
//=================================
void* malloc(uint32 size)
{
  801ead:	55                   	push   %ebp
  801eae:	89 e5                	mov    %esp,%ebp
  801eb0:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  801eb3:	e8 c1 fe ff ff       	call   801d79 <uheap_init>
	if (size == 0) return NULL ;
  801eb8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801ebc:	75 0a                	jne    801ec8 <malloc+0x1b>
  801ebe:	b8 00 00 00 00       	mov    $0x0,%eax
  801ec3:	e9 e1 04 00 00       	jmp    8023a9 <malloc+0x4fc>
	//==============================================================

	acquire_uspinlock(&ulock);
  801ec8:	83 ec 0c             	sub    $0xc,%esp
  801ecb:	68 40 e1 81 00       	push   $0x81e140
  801ed0:	e8 6c 28 00 00       	call   804741 <acquire_uspinlock>
  801ed5:	83 c4 10             	add    $0x10,%esp
	if(size <  DYN_ALLOC_MAX_BLOCK_SIZE){
  801ed8:	81 7d 08 ff 07 00 00 	cmpl   $0x7ff,0x8(%ebp)
  801edf:	77 23                	ja     801f04 <malloc+0x57>
		release_uspinlock(&ulock);
  801ee1:	83 ec 0c             	sub    $0xc,%esp
  801ee4:	68 40 e1 81 00       	push   $0x81e140
  801ee9:	e8 ab 28 00 00       	call   804799 <release_uspinlock>
  801eee:	83 c4 10             	add    $0x10,%esp
		return alloc_block(size);
  801ef1:	83 ec 0c             	sub    $0xc,%esp
  801ef4:	ff 75 08             	pushl  0x8(%ebp)
  801ef7:	e8 dd 1f 00 00       	call   803ed9 <alloc_block>
  801efc:	83 c4 10             	add    $0x10,%esp
  801eff:	e9 a5 04 00 00       	jmp    8023a9 <malloc+0x4fc>
	}

	struct UserHeapStruct* allocblock= (struct UserHeapStruct*) alloc_block(sizeof(struct UserHeapStruct));
  801f04:	83 ec 0c             	sub    $0xc,%esp
  801f07:	6a 10                	push   $0x10
  801f09:	e8 cb 1f 00 00       	call   803ed9 <alloc_block>
  801f0e:	83 c4 10             	add    $0x10,%esp
  801f11:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (allocblock == NULL){
  801f14:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801f18:	75 0a                	jne    801f24 <malloc+0x77>
			return NULL;
  801f1a:	b8 00 00 00 00       	mov    $0x0,%eax
  801f1f:	e9 85 04 00 00       	jmp    8023a9 <malloc+0x4fc>
	}

	size = ROUNDUP(size,PAGE_SIZE);
  801f24:	c7 45 e8 00 10 00 00 	movl   $0x1000,-0x18(%ebp)
  801f2b:	8b 55 08             	mov    0x8(%ebp),%edx
  801f2e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801f31:	01 d0                	add    %edx,%eax
  801f33:	48                   	dec    %eax
  801f34:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801f37:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801f3a:	ba 00 00 00 00       	mov    $0x0,%edx
  801f3f:	f7 75 e8             	divl   -0x18(%ebp)
  801f42:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801f45:	29 d0                	sub    %edx,%eax
  801f47:	89 45 08             	mov    %eax,0x8(%ebp)
	struct UserHeapStruct* lastfreeelement = LIST_LAST(&u_freelist);
  801f4a:	a1 24 e1 81 00       	mov    0x81e124,%eax
  801f4f:	89 45 e0             	mov    %eax,-0x20(%ebp)

	if(LIST_SIZE(&u_freelist)==0 || size>lastfreeelement->size){
  801f52:	a1 2c e1 81 00       	mov    0x81e12c,%eax
  801f57:	85 c0                	test   %eax,%eax
  801f59:	74 0f                	je     801f6a <malloc+0xbd>
  801f5b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801f5e:	8b 40 04             	mov    0x4(%eax),%eax
  801f61:	3b 45 08             	cmp    0x8(%ebp),%eax
  801f64:	0f 83 ea 00 00 00    	jae    802054 <malloc+0x1a7>
			if(uheapPageAllocBreak < USER_HEAP_MAX - size){
  801f6a:	b8 00 00 00 a0       	mov    $0xa0000000,%eax
  801f6f:	2b 45 08             	sub    0x8(%ebp),%eax
  801f72:	89 c2                	mov    %eax,%edx
  801f74:	a1 68 e0 81 00       	mov    0x81e068,%eax
  801f79:	39 c2                	cmp    %eax,%edx
  801f7b:	0f 86 b9 00 00 00    	jbe    80203a <malloc+0x18d>
					uint32 requestedblockva = uheapPageAllocBreak;
  801f81:	a1 68 e0 81 00       	mov    0x81e068,%eax
  801f86:	89 45 dc             	mov    %eax,-0x24(%ebp)
					uheapPageAllocBreak+=size;
  801f89:	8b 15 68 e0 81 00    	mov    0x81e068,%edx
  801f8f:	8b 45 08             	mov    0x8(%ebp),%eax
  801f92:	01 d0                	add    %edx,%eax
  801f94:	a3 68 e0 81 00       	mov    %eax,0x81e068
					allocblock->startva = requestedblockva;
  801f99:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f9c:	8b 55 dc             	mov    -0x24(%ebp),%edx
  801f9f:	89 10                	mov    %edx,(%eax)
					allocblock->size = size;
  801fa1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801fa4:	8b 55 08             	mov    0x8(%ebp),%edx
  801fa7:	89 50 04             	mov    %edx,0x4(%eax)

					LIST_INSERT_TAIL(&u_allocatedlist, allocblock);
  801faa:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801fae:	75 14                	jne    801fc4 <malloc+0x117>
  801fb0:	83 ec 04             	sub    $0x4,%esp
  801fb3:	68 8c 53 80 00       	push   $0x80538c
  801fb8:	6a 60                	push   $0x60
  801fba:	68 40 53 80 00       	push   $0x805340
  801fbf:	e8 fa e9 ff ff       	call   8009be <_panic>
  801fc4:	8b 15 34 e1 81 00    	mov    0x81e134,%edx
  801fca:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801fcd:	89 50 0c             	mov    %edx,0xc(%eax)
  801fd0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801fd3:	8b 40 0c             	mov    0xc(%eax),%eax
  801fd6:	85 c0                	test   %eax,%eax
  801fd8:	74 0d                	je     801fe7 <malloc+0x13a>
  801fda:	a1 34 e1 81 00       	mov    0x81e134,%eax
  801fdf:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801fe2:	89 50 08             	mov    %edx,0x8(%eax)
  801fe5:	eb 08                	jmp    801fef <malloc+0x142>
  801fe7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801fea:	a3 30 e1 81 00       	mov    %eax,0x81e130
  801fef:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801ff2:	a3 34 e1 81 00       	mov    %eax,0x81e134
  801ff7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801ffa:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802001:	a1 3c e1 81 00       	mov    0x81e13c,%eax
  802006:	40                   	inc    %eax
  802007:	a3 3c e1 81 00       	mov    %eax,0x81e13c


					sys_allocate_user_mem(allocblock->startva ,size);
  80200c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80200f:	8b 00                	mov    (%eax),%eax
  802011:	83 ec 08             	sub    $0x8,%esp
  802014:	ff 75 08             	pushl  0x8(%ebp)
  802017:	50                   	push   %eax
  802018:	e8 34 1c 00 00       	call   803c51 <sys_allocate_user_mem>
  80201d:	83 c4 10             	add    $0x10,%esp
					release_uspinlock(&ulock);
  802020:	83 ec 0c             	sub    $0xc,%esp
  802023:	68 40 e1 81 00       	push   $0x81e140
  802028:	e8 6c 27 00 00       	call   804799 <release_uspinlock>
  80202d:	83 c4 10             	add    $0x10,%esp
					return (void*)allocblock->startva;
  802030:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802033:	8b 00                	mov    (%eax),%eax
  802035:	e9 6f 03 00 00       	jmp    8023a9 <malloc+0x4fc>
			}else{
					release_uspinlock(&ulock);
  80203a:	83 ec 0c             	sub    $0xc,%esp
  80203d:	68 40 e1 81 00       	push   $0x81e140
  802042:	e8 52 27 00 00       	call   804799 <release_uspinlock>
  802047:	83 c4 10             	add    $0x10,%esp
					return NULL;
  80204a:	b8 00 00 00 00       	mov    $0x0,%eax
  80204f:	e9 55 03 00 00       	jmp    8023a9 <malloc+0x4fc>
				}
	}else{
		//custom fit
		struct UserHeapStruct* currentfreeelement = LIST_FIRST(&u_freelist);
  802054:	a1 20 e1 81 00       	mov    0x81e120,%eax
  802059:	89 45 f4             	mov    %eax,-0xc(%ebp)
		//worst fit
		while(currentfreeelement != NULL){
  80205c:	e9 39 03 00 00       	jmp    80239a <malloc+0x4ed>
			if(size<currentfreeelement->size){
  802061:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802064:	8b 40 04             	mov    0x4(%eax),%eax
  802067:	3b 45 08             	cmp    0x8(%ebp),%eax
  80206a:	0f 86 e7 01 00 00    	jbe    802257 <malloc+0x3aa>
				allocblock->startva = lastfreeelement->startva;
  802070:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802073:	8b 10                	mov    (%eax),%edx
  802075:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802078:	89 10                	mov    %edx,(%eax)
                allocblock->size = size;
  80207a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80207d:	8b 55 08             	mov    0x8(%ebp),%edx
  802080:	89 50 04             	mov    %edx,0x4(%eax)
                LIST_INSERT_TAIL(&u_allocatedlist,allocblock);
  802083:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802087:	75 14                	jne    80209d <malloc+0x1f0>
  802089:	83 ec 04             	sub    $0x4,%esp
  80208c:	68 8c 53 80 00       	push   $0x80538c
  802091:	6a 72                	push   $0x72
  802093:	68 40 53 80 00       	push   $0x805340
  802098:	e8 21 e9 ff ff       	call   8009be <_panic>
  80209d:	8b 15 34 e1 81 00    	mov    0x81e134,%edx
  8020a3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8020a6:	89 50 0c             	mov    %edx,0xc(%eax)
  8020a9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8020ac:	8b 40 0c             	mov    0xc(%eax),%eax
  8020af:	85 c0                	test   %eax,%eax
  8020b1:	74 0d                	je     8020c0 <malloc+0x213>
  8020b3:	a1 34 e1 81 00       	mov    0x81e134,%eax
  8020b8:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8020bb:	89 50 08             	mov    %edx,0x8(%eax)
  8020be:	eb 08                	jmp    8020c8 <malloc+0x21b>
  8020c0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8020c3:	a3 30 e1 81 00       	mov    %eax,0x81e130
  8020c8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8020cb:	a3 34 e1 81 00       	mov    %eax,0x81e134
  8020d0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8020d3:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  8020da:	a1 3c e1 81 00       	mov    0x81e13c,%eax
  8020df:	40                   	inc    %eax
  8020e0:	a3 3c e1 81 00       	mov    %eax,0x81e13c
                lastfreeelement->startva += size;
  8020e5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8020e8:	8b 10                	mov    (%eax),%edx
  8020ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8020ed:	01 c2                	add    %eax,%edx
  8020ef:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8020f2:	89 10                	mov    %edx,(%eax)
                lastfreeelement->size -= size;
  8020f4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8020f7:	8b 40 04             	mov    0x4(%eax),%eax
  8020fa:	2b 45 08             	sub    0x8(%ebp),%eax
  8020fd:	89 c2                	mov    %eax,%edx
  8020ff:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802102:	89 50 04             	mov    %edx,0x4(%eax)
                struct UserHeapStruct* currentfree2 = LIST_FIRST(&u_freelist);
  802105:	a1 20 e1 81 00       	mov    0x81e120,%eax
  80210a:	89 45 f0             	mov    %eax,-0x10(%ebp)
                //check order of last element

                while (currentfree2 != NULL){
  80210d:	e9 0d 01 00 00       	jmp    80221f <malloc+0x372>
                	if(lastfreeelement->size <currentfree2->size){
  802112:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802115:	8b 50 04             	mov    0x4(%eax),%edx
  802118:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80211b:	8b 40 04             	mov    0x4(%eax),%eax
  80211e:	39 c2                	cmp    %eax,%edx
  802120:	0f 83 f0 00 00 00    	jae    802216 <malloc+0x369>
                		LIST_REMOVE(&u_freelist ,lastfreeelement);
  802126:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80212a:	75 14                	jne    802140 <malloc+0x293>
  80212c:	83 ec 04             	sub    $0x4,%esp
  80212f:	68 af 53 80 00       	push   $0x8053af
  802134:	6a 7a                	push   $0x7a
  802136:	68 40 53 80 00       	push   $0x805340
  80213b:	e8 7e e8 ff ff       	call   8009be <_panic>
  802140:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802143:	8b 40 08             	mov    0x8(%eax),%eax
  802146:	85 c0                	test   %eax,%eax
  802148:	74 11                	je     80215b <malloc+0x2ae>
  80214a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80214d:	8b 40 08             	mov    0x8(%eax),%eax
  802150:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802153:	8b 52 0c             	mov    0xc(%edx),%edx
  802156:	89 50 0c             	mov    %edx,0xc(%eax)
  802159:	eb 0b                	jmp    802166 <malloc+0x2b9>
  80215b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80215e:	8b 40 0c             	mov    0xc(%eax),%eax
  802161:	a3 24 e1 81 00       	mov    %eax,0x81e124
  802166:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802169:	8b 40 0c             	mov    0xc(%eax),%eax
  80216c:	85 c0                	test   %eax,%eax
  80216e:	74 11                	je     802181 <malloc+0x2d4>
  802170:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802173:	8b 40 0c             	mov    0xc(%eax),%eax
  802176:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802179:	8b 52 08             	mov    0x8(%edx),%edx
  80217c:	89 50 08             	mov    %edx,0x8(%eax)
  80217f:	eb 0b                	jmp    80218c <malloc+0x2df>
  802181:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802184:	8b 40 08             	mov    0x8(%eax),%eax
  802187:	a3 20 e1 81 00       	mov    %eax,0x81e120
  80218c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80218f:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802196:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802199:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  8021a0:	a1 2c e1 81 00       	mov    0x81e12c,%eax
  8021a5:	48                   	dec    %eax
  8021a6:	a3 2c e1 81 00       	mov    %eax,0x81e12c
                		LIST_INSERT_BEFORE(&u_freelist ,currentfree2 ,lastfreeelement);
  8021ab:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8021af:	74 06                	je     8021b7 <malloc+0x30a>
  8021b1:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8021b5:	75 14                	jne    8021cb <malloc+0x31e>
  8021b7:	83 ec 04             	sub    $0x4,%esp
  8021ba:	68 d0 53 80 00       	push   $0x8053d0
  8021bf:	6a 7b                	push   $0x7b
  8021c1:	68 40 53 80 00       	push   $0x805340
  8021c6:	e8 f3 e7 ff ff       	call   8009be <_panic>
  8021cb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021ce:	8b 50 0c             	mov    0xc(%eax),%edx
  8021d1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8021d4:	89 50 0c             	mov    %edx,0xc(%eax)
  8021d7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8021da:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8021dd:	89 50 08             	mov    %edx,0x8(%eax)
  8021e0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021e3:	8b 40 0c             	mov    0xc(%eax),%eax
  8021e6:	85 c0                	test   %eax,%eax
  8021e8:	74 0e                	je     8021f8 <malloc+0x34b>
  8021ea:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021ed:	8b 40 0c             	mov    0xc(%eax),%eax
  8021f0:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8021f3:	89 50 08             	mov    %edx,0x8(%eax)
  8021f6:	eb 08                	jmp    802200 <malloc+0x353>
  8021f8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8021fb:	a3 20 e1 81 00       	mov    %eax,0x81e120
  802200:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802203:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802206:	89 50 0c             	mov    %edx,0xc(%eax)
  802209:	a1 2c e1 81 00       	mov    0x81e12c,%eax
  80220e:	40                   	inc    %eax
  80220f:	a3 2c e1 81 00       	mov    %eax,0x81e12c
                		break;
  802214:	eb 13                	jmp    802229 <malloc+0x37c>
                	}
                	currentfree2 = currentfree2->prev_next_info.le_next;
  802216:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802219:	8b 40 08             	mov    0x8(%eax),%eax
  80221c:	89 45 f0             	mov    %eax,-0x10(%ebp)
                lastfreeelement->startva += size;
                lastfreeelement->size -= size;
                struct UserHeapStruct* currentfree2 = LIST_FIRST(&u_freelist);
                //check order of last element

                while (currentfree2 != NULL){
  80221f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802223:	0f 85 e9 fe ff ff    	jne    802112 <malloc+0x265>
                	}
                	currentfree2 = currentfree2->prev_next_info.le_next;
                }


                sys_allocate_user_mem(allocblock->startva ,size);
  802229:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80222c:	8b 00                	mov    (%eax),%eax
  80222e:	83 ec 08             	sub    $0x8,%esp
  802231:	ff 75 08             	pushl  0x8(%ebp)
  802234:	50                   	push   %eax
  802235:	e8 17 1a 00 00       	call   803c51 <sys_allocate_user_mem>
  80223a:	83 c4 10             	add    $0x10,%esp
                release_uspinlock(&ulock);
  80223d:	83 ec 0c             	sub    $0xc,%esp
  802240:	68 40 e1 81 00       	push   $0x81e140
  802245:	e8 4f 25 00 00       	call   804799 <release_uspinlock>
  80224a:	83 c4 10             	add    $0x10,%esp
                return (void*)allocblock->startva;
  80224d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802250:	8b 00                	mov    (%eax),%eax
  802252:	e9 52 01 00 00       	jmp    8023a9 <malloc+0x4fc>
                //exact fit
			}else if(size == currentfreeelement->size){
  802257:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80225a:	8b 40 04             	mov    0x4(%eax),%eax
  80225d:	3b 45 08             	cmp    0x8(%ebp),%eax
  802260:	0f 85 2b 01 00 00    	jne    802391 <malloc+0x4e4>
				allocblock->startva = currentfreeelement->startva;
  802266:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802269:	8b 10                	mov    (%eax),%edx
  80226b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80226e:	89 10                	mov    %edx,(%eax)
				allocblock->size = size;
  802270:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802273:	8b 55 08             	mov    0x8(%ebp),%edx
  802276:	89 50 04             	mov    %edx,0x4(%eax)
				LIST_INSERT_TAIL(&u_allocatedlist ,allocblock);
  802279:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80227d:	75 17                	jne    802296 <malloc+0x3e9>
  80227f:	83 ec 04             	sub    $0x4,%esp
  802282:	68 8c 53 80 00       	push   $0x80538c
  802287:	68 89 00 00 00       	push   $0x89
  80228c:	68 40 53 80 00       	push   $0x805340
  802291:	e8 28 e7 ff ff       	call   8009be <_panic>
  802296:	8b 15 34 e1 81 00    	mov    0x81e134,%edx
  80229c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80229f:	89 50 0c             	mov    %edx,0xc(%eax)
  8022a2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8022a5:	8b 40 0c             	mov    0xc(%eax),%eax
  8022a8:	85 c0                	test   %eax,%eax
  8022aa:	74 0d                	je     8022b9 <malloc+0x40c>
  8022ac:	a1 34 e1 81 00       	mov    0x81e134,%eax
  8022b1:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8022b4:	89 50 08             	mov    %edx,0x8(%eax)
  8022b7:	eb 08                	jmp    8022c1 <malloc+0x414>
  8022b9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8022bc:	a3 30 e1 81 00       	mov    %eax,0x81e130
  8022c1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8022c4:	a3 34 e1 81 00       	mov    %eax,0x81e134
  8022c9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8022cc:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  8022d3:	a1 3c e1 81 00       	mov    0x81e13c,%eax
  8022d8:	40                   	inc    %eax
  8022d9:	a3 3c e1 81 00       	mov    %eax,0x81e13c
				LIST_REMOVE(&u_freelist ,currentfreeelement);
  8022de:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8022e2:	75 17                	jne    8022fb <malloc+0x44e>
  8022e4:	83 ec 04             	sub    $0x4,%esp
  8022e7:	68 af 53 80 00       	push   $0x8053af
  8022ec:	68 8a 00 00 00       	push   $0x8a
  8022f1:	68 40 53 80 00       	push   $0x805340
  8022f6:	e8 c3 e6 ff ff       	call   8009be <_panic>
  8022fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022fe:	8b 40 08             	mov    0x8(%eax),%eax
  802301:	85 c0                	test   %eax,%eax
  802303:	74 11                	je     802316 <malloc+0x469>
  802305:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802308:	8b 40 08             	mov    0x8(%eax),%eax
  80230b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80230e:	8b 52 0c             	mov    0xc(%edx),%edx
  802311:	89 50 0c             	mov    %edx,0xc(%eax)
  802314:	eb 0b                	jmp    802321 <malloc+0x474>
  802316:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802319:	8b 40 0c             	mov    0xc(%eax),%eax
  80231c:	a3 24 e1 81 00       	mov    %eax,0x81e124
  802321:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802324:	8b 40 0c             	mov    0xc(%eax),%eax
  802327:	85 c0                	test   %eax,%eax
  802329:	74 11                	je     80233c <malloc+0x48f>
  80232b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80232e:	8b 40 0c             	mov    0xc(%eax),%eax
  802331:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802334:	8b 52 08             	mov    0x8(%edx),%edx
  802337:	89 50 08             	mov    %edx,0x8(%eax)
  80233a:	eb 0b                	jmp    802347 <malloc+0x49a>
  80233c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80233f:	8b 40 08             	mov    0x8(%eax),%eax
  802342:	a3 20 e1 81 00       	mov    %eax,0x81e120
  802347:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80234a:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802351:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802354:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  80235b:	a1 2c e1 81 00       	mov    0x81e12c,%eax
  802360:	48                   	dec    %eax
  802361:	a3 2c e1 81 00       	mov    %eax,0x81e12c
				sys_allocate_user_mem(allocblock->startva ,size);
  802366:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802369:	8b 00                	mov    (%eax),%eax
  80236b:	83 ec 08             	sub    $0x8,%esp
  80236e:	ff 75 08             	pushl  0x8(%ebp)
  802371:	50                   	push   %eax
  802372:	e8 da 18 00 00       	call   803c51 <sys_allocate_user_mem>
  802377:	83 c4 10             	add    $0x10,%esp
				release_uspinlock(&ulock);
  80237a:	83 ec 0c             	sub    $0xc,%esp
  80237d:	68 40 e1 81 00       	push   $0x81e140
  802382:	e8 12 24 00 00       	call   804799 <release_uspinlock>
  802387:	83 c4 10             	add    $0x10,%esp
				return (void*)allocblock->startva;
  80238a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80238d:	8b 00                	mov    (%eax),%eax
  80238f:	eb 18                	jmp    8023a9 <malloc+0x4fc>
			}
			currentfreeelement = currentfreeelement->prev_next_info.le_next;
  802391:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802394:	8b 40 08             	mov    0x8(%eax),%eax
  802397:	89 45 f4             	mov    %eax,-0xc(%ebp)
				}
	}else{
		//custom fit
		struct UserHeapStruct* currentfreeelement = LIST_FIRST(&u_freelist);
		//worst fit
		while(currentfreeelement != NULL){
  80239a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80239e:	0f 85 bd fc ff ff    	jne    802061 <malloc+0x1b4>
				return (void*)allocblock->startva;
			}
			currentfreeelement = currentfreeelement->prev_next_info.le_next;
		}
	}
	 return NULL;
  8023a4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8023a9:	c9                   	leave  
  8023aa:	c3                   	ret    

008023ab <free>:

//=================================
// [2] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
  8023ab:	55                   	push   %ebp
  8023ac:	89 e5                	mov    %esp,%ebp
  8023ae:	83 ec 38             	sub    $0x38,%esp
	uint32  VA = ROUNDDOWN(((uint32 ) virtual_address), PAGE_SIZE);
  8023b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8023b4:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8023b7:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8023ba:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8023bf:	89 45 d8             	mov    %eax,-0x28(%ebp)


		uheap_init();
  8023c2:	e8 b2 f9 ff ff       	call   801d79 <uheap_init>
		acquire_uspinlock(&ulock);
  8023c7:	83 ec 0c             	sub    $0xc,%esp
  8023ca:	68 40 e1 81 00       	push   $0x81e140
  8023cf:	e8 6d 23 00 00       	call   804741 <acquire_uspinlock>
  8023d4:	83 c4 10             	add    $0x10,%esp
		if (VA < uheapPageAllocStart){
  8023d7:	a1 10 e1 81 00       	mov    0x81e110,%eax
  8023dc:	39 45 d8             	cmp    %eax,-0x28(%ebp)
  8023df:	73 23                	jae    802404 <free+0x59>
			free_block(virtual_address);
  8023e1:	83 ec 0c             	sub    $0xc,%esp
  8023e4:	ff 75 08             	pushl  0x8(%ebp)
  8023e7:	e8 89 1f 00 00       	call   804375 <free_block>
  8023ec:	83 c4 10             	add    $0x10,%esp
			release_uspinlock(&ulock);
  8023ef:	83 ec 0c             	sub    $0xc,%esp
  8023f2:	68 40 e1 81 00       	push   $0x81e140
  8023f7:	e8 9d 23 00 00       	call   804799 <release_uspinlock>
  8023fc:	83 c4 10             	add    $0x10,%esp
			return;
  8023ff:	e9 35 07 00 00       	jmp    802b39 <free+0x78e>
		}
		if (VA >= uheapPageAllocBreak){
  802404:	a1 68 e0 81 00       	mov    0x81e068,%eax
  802409:	39 45 d8             	cmp    %eax,-0x28(%ebp)
  80240c:	72 30                	jb     80243e <free+0x93>
			cprintf("%d\n %d\n", VA, uheapPageAllocBreak);
  80240e:	a1 68 e0 81 00       	mov    0x81e068,%eax
  802413:	83 ec 04             	sub    $0x4,%esp
  802416:	50                   	push   %eax
  802417:	ff 75 d8             	pushl  -0x28(%ebp)
  80241a:	68 05 54 80 00       	push   $0x805405
  80241f:	e8 68 e8 ff ff       	call   800c8c <cprintf>
  802424:	83 c4 10             	add    $0x10,%esp

			panic("freeing from restricted area");
  802427:	83 ec 04             	sub    $0x4,%esp
  80242a:	68 0d 54 80 00       	push   $0x80540d
  80242f:	68 a7 00 00 00       	push   $0xa7
  802434:	68 40 53 80 00       	push   $0x805340
  802439:	e8 80 e5 ff ff       	call   8009be <_panic>
			release_uspinlock(&ulock);
			return;
		}

		struct UserHeapStruct* newfree = (struct UserHeapStruct*) alloc_block(sizeof(struct UserHeapStruct));
  80243e:	83 ec 0c             	sub    $0xc,%esp
  802441:	6a 10                	push   $0x10
  802443:	e8 91 1a 00 00       	call   803ed9 <alloc_block>
  802448:	83 c4 10             	add    $0x10,%esp
  80244b:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		struct UserHeapStruct* MergedBlock  = ( struct UserHeapStruct*)alloc_block(sizeof(struct UserHeapStruct));
  80244e:	83 ec 0c             	sub    $0xc,%esp
  802451:	6a 10                	push   $0x10
  802453:	e8 81 1a 00 00       	call   803ed9 <alloc_block>
  802458:	83 c4 10             	add    $0x10,%esp
  80245b:	89 45 d0             	mov    %eax,-0x30(%ebp)

		struct UserHeapStruct* ToBefreed = LIST_FIRST(&u_allocatedlist);
  80245e:	a1 30 e1 81 00       	mov    0x81e130,%eax
  802463:	89 45 f4             	mov    %eax,-0xc(%ebp)
		bool foundVA = 0;
  802466:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

		//find the allocated block
		while(ToBefreed !=NULL ){
  80246d:	eb 1c                	jmp    80248b <free+0xe0>

			if (VA ==ToBefreed->startva ){
  80246f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802472:	8b 00                	mov    (%eax),%eax
  802474:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  802477:	75 09                	jne    802482 <free+0xd7>
				foundVA = 1;
  802479:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
				break;
  802480:	eb 0f                	jmp    802491 <free+0xe6>
			}
				ToBefreed = ToBefreed->prev_next_info.le_next;
  802482:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802485:	8b 40 08             	mov    0x8(%eax),%eax
  802488:	89 45 f4             	mov    %eax,-0xc(%ebp)

		struct UserHeapStruct* ToBefreed = LIST_FIRST(&u_allocatedlist);
		bool foundVA = 0;

		//find the allocated block
		while(ToBefreed !=NULL ){
  80248b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80248f:	75 de                	jne    80246f <free+0xc4>
			}
				ToBefreed = ToBefreed->prev_next_info.le_next;
		}


		if(!foundVA){
  802491:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802495:	75 17                	jne    8024ae <free+0x103>
				panic("INVALID ADDRESS!");
  802497:	83 ec 04             	sub    $0x4,%esp
  80249a:	68 2a 54 80 00       	push   $0x80542a
  80249f:	68 be 00 00 00       	push   $0xbe
  8024a4:	68 40 53 80 00       	push   $0x805340
  8024a9:	e8 10 e5 ff ff       	call   8009be <_panic>
				release_uspinlock(&ulock);
				return;
			}


		newfree->startva = ToBefreed->startva;
  8024ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024b1:	8b 10                	mov    (%eax),%edx
  8024b3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8024b6:	89 10                	mov    %edx,(%eax)
		newfree->size = ToBefreed->size;
  8024b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024bb:	8b 50 04             	mov    0x4(%eax),%edx
  8024be:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8024c1:	89 50 04             	mov    %edx,0x4(%eax)

		//remove allocated block from alloclist
		LIST_REMOVE(&u_allocatedlist, ToBefreed);
  8024c4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024c8:	75 17                	jne    8024e1 <free+0x136>
  8024ca:	83 ec 04             	sub    $0x4,%esp
  8024cd:	68 af 53 80 00       	push   $0x8053af
  8024d2:	68 c8 00 00 00       	push   $0xc8
  8024d7:	68 40 53 80 00       	push   $0x805340
  8024dc:	e8 dd e4 ff ff       	call   8009be <_panic>
  8024e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024e4:	8b 40 08             	mov    0x8(%eax),%eax
  8024e7:	85 c0                	test   %eax,%eax
  8024e9:	74 11                	je     8024fc <free+0x151>
  8024eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024ee:	8b 40 08             	mov    0x8(%eax),%eax
  8024f1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024f4:	8b 52 0c             	mov    0xc(%edx),%edx
  8024f7:	89 50 0c             	mov    %edx,0xc(%eax)
  8024fa:	eb 0b                	jmp    802507 <free+0x15c>
  8024fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024ff:	8b 40 0c             	mov    0xc(%eax),%eax
  802502:	a3 34 e1 81 00       	mov    %eax,0x81e134
  802507:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80250a:	8b 40 0c             	mov    0xc(%eax),%eax
  80250d:	85 c0                	test   %eax,%eax
  80250f:	74 11                	je     802522 <free+0x177>
  802511:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802514:	8b 40 0c             	mov    0xc(%eax),%eax
  802517:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80251a:	8b 52 08             	mov    0x8(%edx),%edx
  80251d:	89 50 08             	mov    %edx,0x8(%eax)
  802520:	eb 0b                	jmp    80252d <free+0x182>
  802522:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802525:	8b 40 08             	mov    0x8(%eax),%eax
  802528:	a3 30 e1 81 00       	mov    %eax,0x81e130
  80252d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802530:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802537:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80253a:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  802541:	a1 3c e1 81 00       	mov    0x81e13c,%eax
  802546:	48                   	dec    %eax
  802547:	a3 3c e1 81 00       	mov    %eax,0x81e13c

		sys_free_user_mem(ToBefreed->startva, ToBefreed->size);
  80254c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80254f:	8b 50 04             	mov    0x4(%eax),%edx
  802552:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802555:	8b 00                	mov    (%eax),%eax
  802557:	83 ec 08             	sub    $0x8,%esp
  80255a:	52                   	push   %edx
  80255b:	50                   	push   %eax
  80255c:	e8 d4 16 00 00       	call   803c35 <sys_free_user_mem>
  802561:	83 c4 10             	add    $0x10,%esp




		if(LIST_SIZE(&u_freelist) == 0){
  802564:	a1 2c e1 81 00       	mov    0x81e12c,%eax
  802569:	85 c0                	test   %eax,%eax
  80256b:	75 7a                	jne    8025e7 <free+0x23c>
			LIST_INSERT_HEAD(&u_freelist,newfree);
  80256d:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  802571:	75 17                	jne    80258a <free+0x1df>
  802573:	83 ec 04             	sub    $0x4,%esp
  802576:	68 3c 54 80 00       	push   $0x80543c
  80257b:	68 d0 00 00 00       	push   $0xd0
  802580:	68 40 53 80 00       	push   $0x805340
  802585:	e8 34 e4 ff ff       	call   8009be <_panic>
  80258a:	8b 15 20 e1 81 00    	mov    0x81e120,%edx
  802590:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802593:	89 50 08             	mov    %edx,0x8(%eax)
  802596:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802599:	8b 40 08             	mov    0x8(%eax),%eax
  80259c:	85 c0                	test   %eax,%eax
  80259e:	74 0d                	je     8025ad <free+0x202>
  8025a0:	a1 20 e1 81 00       	mov    0x81e120,%eax
  8025a5:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8025a8:	89 50 0c             	mov    %edx,0xc(%eax)
  8025ab:	eb 08                	jmp    8025b5 <free+0x20a>
  8025ad:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8025b0:	a3 24 e1 81 00       	mov    %eax,0x81e124
  8025b5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8025b8:	a3 20 e1 81 00       	mov    %eax,0x81e120
  8025bd:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8025c0:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  8025c7:	a1 2c e1 81 00       	mov    0x81e12c,%eax
  8025cc:	40                   	inc    %eax
  8025cd:	a3 2c e1 81 00       	mov    %eax,0x81e12c
			release_uspinlock(&ulock);
  8025d2:	83 ec 0c             	sub    $0xc,%esp
  8025d5:	68 40 e1 81 00       	push   $0x81e140
  8025da:	e8 ba 21 00 00       	call   804799 <release_uspinlock>
  8025df:	83 c4 10             	add    $0x10,%esp
			return;
  8025e2:	e9 52 05 00 00       	jmp    802b39 <free+0x78e>
		}


		struct UserHeapStruct* ToBeMerged = LIST_FIRST(&u_freelist);
  8025e7:	a1 20 e1 81 00       	mov    0x81e120,%eax
  8025ec:	89 45 ec             	mov    %eax,-0x14(%ebp)
		// merge with prev if possible
		bool mergeprev = 0;
  8025ef:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		bool mergenext = 0;
  8025f6:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
		while(ToBeMerged != NULL){
  8025fd:	e9 d2 00 00 00       	jmp    8026d4 <free+0x329>
			if((ToBeMerged->startva +ToBeMerged->size) == newfree->startva){
  802602:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802605:	8b 10                	mov    (%eax),%edx
  802607:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80260a:	8b 40 04             	mov    0x4(%eax),%eax
  80260d:	01 c2                	add    %eax,%edx
  80260f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802612:	8b 00                	mov    (%eax),%eax
  802614:	39 c2                	cmp    %eax,%edx
  802616:	0f 85 af 00 00 00    	jne    8026cb <free+0x320>

				MergedBlock->startva = ToBeMerged->startva;
  80261c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80261f:	8b 10                	mov    (%eax),%edx
  802621:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802624:	89 10                	mov    %edx,(%eax)
				MergedBlock->size = ToBeMerged->size + newfree->size;
  802626:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802629:	8b 50 04             	mov    0x4(%eax),%edx
  80262c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80262f:	8b 40 04             	mov    0x4(%eax),%eax
  802632:	01 c2                	add    %eax,%edx
  802634:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802637:	89 50 04             	mov    %edx,0x4(%eax)
				LIST_REMOVE(&u_freelist, ToBeMerged);
  80263a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80263e:	75 17                	jne    802657 <free+0x2ac>
  802640:	83 ec 04             	sub    $0x4,%esp
  802643:	68 af 53 80 00       	push   $0x8053af
  802648:	68 df 00 00 00       	push   $0xdf
  80264d:	68 40 53 80 00       	push   $0x805340
  802652:	e8 67 e3 ff ff       	call   8009be <_panic>
  802657:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80265a:	8b 40 08             	mov    0x8(%eax),%eax
  80265d:	85 c0                	test   %eax,%eax
  80265f:	74 11                	je     802672 <free+0x2c7>
  802661:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802664:	8b 40 08             	mov    0x8(%eax),%eax
  802667:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80266a:	8b 52 0c             	mov    0xc(%edx),%edx
  80266d:	89 50 0c             	mov    %edx,0xc(%eax)
  802670:	eb 0b                	jmp    80267d <free+0x2d2>
  802672:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802675:	8b 40 0c             	mov    0xc(%eax),%eax
  802678:	a3 24 e1 81 00       	mov    %eax,0x81e124
  80267d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802680:	8b 40 0c             	mov    0xc(%eax),%eax
  802683:	85 c0                	test   %eax,%eax
  802685:	74 11                	je     802698 <free+0x2ed>
  802687:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80268a:	8b 40 0c             	mov    0xc(%eax),%eax
  80268d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802690:	8b 52 08             	mov    0x8(%edx),%edx
  802693:	89 50 08             	mov    %edx,0x8(%eax)
  802696:	eb 0b                	jmp    8026a3 <free+0x2f8>
  802698:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80269b:	8b 40 08             	mov    0x8(%eax),%eax
  80269e:	a3 20 e1 81 00       	mov    %eax,0x81e120
  8026a3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026a6:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  8026ad:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026b0:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  8026b7:	a1 2c e1 81 00       	mov    0x81e12c,%eax
  8026bc:	48                   	dec    %eax
  8026bd:	a3 2c e1 81 00       	mov    %eax,0x81e12c
				mergeprev = 1;
  8026c2:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
				break;
  8026c9:	eb 13                	jmp    8026de <free+0x333>
			}
				ToBeMerged = ToBeMerged->prev_next_info.le_next;
  8026cb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026ce:	8b 40 08             	mov    0x8(%eax),%eax
  8026d1:	89 45 ec             	mov    %eax,-0x14(%ebp)

		struct UserHeapStruct* ToBeMerged = LIST_FIRST(&u_freelist);
		// merge with prev if possible
		bool mergeprev = 0;
		bool mergenext = 0;
		while(ToBeMerged != NULL){
  8026d4:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8026d8:	0f 85 24 ff ff ff    	jne    802602 <free+0x257>
//									uheapPageAllocBreak = newfree->startva;
//						}
//					}


		if ( newfree ->startva + newfree->size == uheapPageAllocBreak){
  8026de:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8026e1:	8b 10                	mov    (%eax),%edx
  8026e3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8026e6:	8b 40 04             	mov    0x4(%eax),%eax
  8026e9:	01 c2                	add    %eax,%edx
  8026eb:	a1 68 e0 81 00       	mov    0x81e068,%eax
  8026f0:	39 c2                	cmp    %eax,%edx
  8026f2:	75 44                	jne    802738 <free+0x38d>

			if(mergeprev){
  8026f4:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8026f8:	74 1f                	je     802719 <free+0x36e>
				uheapPageAllocBreak = MergedBlock->startva;
  8026fa:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8026fd:	8b 00                	mov    (%eax),%eax
  8026ff:	a3 68 e0 81 00       	mov    %eax,0x81e068
				release_uspinlock(&ulock);
  802704:	83 ec 0c             	sub    $0xc,%esp
  802707:	68 40 e1 81 00       	push   $0x81e140
  80270c:	e8 88 20 00 00       	call   804799 <release_uspinlock>
  802711:	83 c4 10             	add    $0x10,%esp
				return;
  802714:	e9 20 04 00 00       	jmp    802b39 <free+0x78e>

			}else{
				uheapPageAllocBreak = newfree->startva;
  802719:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80271c:	8b 00                	mov    (%eax),%eax
  80271e:	a3 68 e0 81 00       	mov    %eax,0x81e068
				release_uspinlock(&ulock);
  802723:	83 ec 0c             	sub    $0xc,%esp
  802726:	68 40 e1 81 00       	push   $0x81e140
  80272b:	e8 69 20 00 00       	call   804799 <release_uspinlock>
  802730:	83 c4 10             	add    $0x10,%esp
				return;
  802733:	e9 01 04 00 00       	jmp    802b39 <free+0x78e>

		}


		//check if block is merged with prev ,and find possible merge with next
		ToBeMerged = LIST_FIRST(&u_freelist);
  802738:	a1 20 e1 81 00       	mov    0x81e120,%eax
  80273d:	89 45 ec             	mov    %eax,-0x14(%ebp)
		while(ToBeMerged != NULL){
  802740:	e9 7d 01 00 00       	jmp    8028c2 <free+0x517>
			if ((newfree->startva + newfree->size) == ToBeMerged->startva ){
  802745:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802748:	8b 10                	mov    (%eax),%edx
  80274a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80274d:	8b 40 04             	mov    0x4(%eax),%eax
  802750:	01 c2                	add    %eax,%edx
  802752:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802755:	8b 00                	mov    (%eax),%eax
  802757:	39 c2                	cmp    %eax,%edx
  802759:	0f 85 5a 01 00 00    	jne    8028b9 <free+0x50e>
				if (mergeprev){
  80275f:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802763:	0f 84 a1 00 00 00    	je     80280a <free+0x45f>
					MergedBlock->size += ToBeMerged->size;
  802769:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80276c:	8b 50 04             	mov    0x4(%eax),%edx
  80276f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802772:	8b 40 04             	mov    0x4(%eax),%eax
  802775:	01 c2                	add    %eax,%edx
  802777:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80277a:	89 50 04             	mov    %edx,0x4(%eax)
					LIST_REMOVE(&u_freelist, ToBeMerged);
  80277d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802781:	75 17                	jne    80279a <free+0x3ef>
  802783:	83 ec 04             	sub    $0x4,%esp
  802786:	68 af 53 80 00       	push   $0x8053af
  80278b:	68 0a 01 00 00       	push   $0x10a
  802790:	68 40 53 80 00       	push   $0x805340
  802795:	e8 24 e2 ff ff       	call   8009be <_panic>
  80279a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80279d:	8b 40 08             	mov    0x8(%eax),%eax
  8027a0:	85 c0                	test   %eax,%eax
  8027a2:	74 11                	je     8027b5 <free+0x40a>
  8027a4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027a7:	8b 40 08             	mov    0x8(%eax),%eax
  8027aa:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8027ad:	8b 52 0c             	mov    0xc(%edx),%edx
  8027b0:	89 50 0c             	mov    %edx,0xc(%eax)
  8027b3:	eb 0b                	jmp    8027c0 <free+0x415>
  8027b5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027b8:	8b 40 0c             	mov    0xc(%eax),%eax
  8027bb:	a3 24 e1 81 00       	mov    %eax,0x81e124
  8027c0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027c3:	8b 40 0c             	mov    0xc(%eax),%eax
  8027c6:	85 c0                	test   %eax,%eax
  8027c8:	74 11                	je     8027db <free+0x430>
  8027ca:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027cd:	8b 40 0c             	mov    0xc(%eax),%eax
  8027d0:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8027d3:	8b 52 08             	mov    0x8(%edx),%edx
  8027d6:	89 50 08             	mov    %edx,0x8(%eax)
  8027d9:	eb 0b                	jmp    8027e6 <free+0x43b>
  8027db:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027de:	8b 40 08             	mov    0x8(%eax),%eax
  8027e1:	a3 20 e1 81 00       	mov    %eax,0x81e120
  8027e6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027e9:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  8027f0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027f3:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  8027fa:	a1 2c e1 81 00       	mov    0x81e12c,%eax
  8027ff:	48                   	dec    %eax
  802800:	a3 2c e1 81 00       	mov    %eax,0x81e12c
					break;
  802805:	e9 c2 00 00 00       	jmp    8028cc <free+0x521>
		//if not merged find possible merge with next
				}else{
					MergedBlock->startva = newfree->startva;
  80280a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80280d:	8b 10                	mov    (%eax),%edx
  80280f:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802812:	89 10                	mov    %edx,(%eax)
					MergedBlock->size  = newfree->size + ToBeMerged->size;
  802814:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802817:	8b 50 04             	mov    0x4(%eax),%edx
  80281a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80281d:	8b 40 04             	mov    0x4(%eax),%eax
  802820:	01 c2                	add    %eax,%edx
  802822:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802825:	89 50 04             	mov    %edx,0x4(%eax)
					LIST_REMOVE(&u_freelist, ToBeMerged);
  802828:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80282c:	75 17                	jne    802845 <free+0x49a>
  80282e:	83 ec 04             	sub    $0x4,%esp
  802831:	68 af 53 80 00       	push   $0x8053af
  802836:	68 10 01 00 00       	push   $0x110
  80283b:	68 40 53 80 00       	push   $0x805340
  802840:	e8 79 e1 ff ff       	call   8009be <_panic>
  802845:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802848:	8b 40 08             	mov    0x8(%eax),%eax
  80284b:	85 c0                	test   %eax,%eax
  80284d:	74 11                	je     802860 <free+0x4b5>
  80284f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802852:	8b 40 08             	mov    0x8(%eax),%eax
  802855:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802858:	8b 52 0c             	mov    0xc(%edx),%edx
  80285b:	89 50 0c             	mov    %edx,0xc(%eax)
  80285e:	eb 0b                	jmp    80286b <free+0x4c0>
  802860:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802863:	8b 40 0c             	mov    0xc(%eax),%eax
  802866:	a3 24 e1 81 00       	mov    %eax,0x81e124
  80286b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80286e:	8b 40 0c             	mov    0xc(%eax),%eax
  802871:	85 c0                	test   %eax,%eax
  802873:	74 11                	je     802886 <free+0x4db>
  802875:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802878:	8b 40 0c             	mov    0xc(%eax),%eax
  80287b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80287e:	8b 52 08             	mov    0x8(%edx),%edx
  802881:	89 50 08             	mov    %edx,0x8(%eax)
  802884:	eb 0b                	jmp    802891 <free+0x4e6>
  802886:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802889:	8b 40 08             	mov    0x8(%eax),%eax
  80288c:	a3 20 e1 81 00       	mov    %eax,0x81e120
  802891:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802894:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  80289b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80289e:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  8028a5:	a1 2c e1 81 00       	mov    0x81e12c,%eax
  8028aa:	48                   	dec    %eax
  8028ab:	a3 2c e1 81 00       	mov    %eax,0x81e12c
					mergenext = 1;
  8028b0:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
					break;
  8028b7:	eb 13                	jmp    8028cc <free+0x521>
				}
			}
			ToBeMerged = ToBeMerged->prev_next_info.le_next;
  8028b9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028bc:	8b 40 08             	mov    0x8(%eax),%eax
  8028bf:	89 45 ec             	mov    %eax,-0x14(%ebp)
		}


		//check if block is merged with prev ,and find possible merge with next
		ToBeMerged = LIST_FIRST(&u_freelist);
		while(ToBeMerged != NULL){
  8028c2:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8028c6:	0f 85 79 fe ff ff    	jne    802745 <free+0x39a>




			// insertion
			struct UserHeapStruct* currentfree = LIST_FIRST(&u_freelist);
  8028cc:	a1 20 e1 81 00       	mov    0x81e120,%eax
  8028d1:	89 45 e0             	mov    %eax,-0x20(%ebp)

			if(mergeprev || mergenext){
  8028d4:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8028d8:	0f 85 ad 00 00 00    	jne    80298b <free+0x5e0>
  8028de:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8028e2:	0f 84 c3 01 00 00    	je     802aab <free+0x700>
				while(currentfree != NULL){
  8028e8:	e9 9e 00 00 00       	jmp    80298b <free+0x5e0>
					if(MergedBlock->size < currentfree->size){
  8028ed:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8028f0:	8b 50 04             	mov    0x4(%eax),%edx
  8028f3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8028f6:	8b 40 04             	mov    0x4(%eax),%eax
  8028f9:	39 c2                	cmp    %eax,%edx
  8028fb:	0f 83 81 00 00 00    	jae    802982 <free+0x5d7>

							LIST_INSERT_BEFORE(&u_freelist,currentfree,MergedBlock);
  802901:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802905:	74 06                	je     80290d <free+0x562>
  802907:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  80290b:	75 17                	jne    802924 <free+0x579>
  80290d:	83 ec 04             	sub    $0x4,%esp
  802910:	68 d0 53 80 00       	push   $0x8053d0
  802915:	68 23 01 00 00       	push   $0x123
  80291a:	68 40 53 80 00       	push   $0x805340
  80291f:	e8 9a e0 ff ff       	call   8009be <_panic>
  802924:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802927:	8b 50 0c             	mov    0xc(%eax),%edx
  80292a:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80292d:	89 50 0c             	mov    %edx,0xc(%eax)
  802930:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802933:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802936:	89 50 08             	mov    %edx,0x8(%eax)
  802939:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80293c:	8b 40 0c             	mov    0xc(%eax),%eax
  80293f:	85 c0                	test   %eax,%eax
  802941:	74 0e                	je     802951 <free+0x5a6>
  802943:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802946:	8b 40 0c             	mov    0xc(%eax),%eax
  802949:	8b 55 d0             	mov    -0x30(%ebp),%edx
  80294c:	89 50 08             	mov    %edx,0x8(%eax)
  80294f:	eb 08                	jmp    802959 <free+0x5ae>
  802951:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802954:	a3 20 e1 81 00       	mov    %eax,0x81e120
  802959:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80295c:	8b 55 d0             	mov    -0x30(%ebp),%edx
  80295f:	89 50 0c             	mov    %edx,0xc(%eax)
  802962:	a1 2c e1 81 00       	mov    0x81e12c,%eax
  802967:	40                   	inc    %eax
  802968:	a3 2c e1 81 00       	mov    %eax,0x81e12c
							release_uspinlock(&ulock);
  80296d:	83 ec 0c             	sub    $0xc,%esp
  802970:	68 40 e1 81 00       	push   $0x81e140
  802975:	e8 1f 1e 00 00       	call   804799 <release_uspinlock>
  80297a:	83 c4 10             	add    $0x10,%esp
							return;
  80297d:	e9 b7 01 00 00       	jmp    802b39 <free+0x78e>
					}
							currentfree = currentfree->prev_next_info.le_next;
  802982:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802985:	8b 40 08             	mov    0x8(%eax),%eax
  802988:	89 45 e0             	mov    %eax,-0x20(%ebp)

			// insertion
			struct UserHeapStruct* currentfree = LIST_FIRST(&u_freelist);

			if(mergeprev || mergenext){
				while(currentfree != NULL){
  80298b:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80298f:	0f 85 58 ff ff ff    	jne    8028ed <free+0x542>
							release_uspinlock(&ulock);
							return;
					}
							currentfree = currentfree->prev_next_info.le_next;
				}
				free_block(newfree);
  802995:	83 ec 0c             	sub    $0xc,%esp
  802998:	ff 75 d4             	pushl  -0x2c(%ebp)
  80299b:	e8 d5 19 00 00       	call   804375 <free_block>
  8029a0:	83 c4 10             	add    $0x10,%esp
				LIST_INSERT_TAIL(&u_freelist,MergedBlock);
  8029a3:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  8029a7:	75 17                	jne    8029c0 <free+0x615>
  8029a9:	83 ec 04             	sub    $0x4,%esp
  8029ac:	68 8c 53 80 00       	push   $0x80538c
  8029b1:	68 2a 01 00 00       	push   $0x12a
  8029b6:	68 40 53 80 00       	push   $0x805340
  8029bb:	e8 fe df ff ff       	call   8009be <_panic>
  8029c0:	8b 15 24 e1 81 00    	mov    0x81e124,%edx
  8029c6:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8029c9:	89 50 0c             	mov    %edx,0xc(%eax)
  8029cc:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8029cf:	8b 40 0c             	mov    0xc(%eax),%eax
  8029d2:	85 c0                	test   %eax,%eax
  8029d4:	74 0d                	je     8029e3 <free+0x638>
  8029d6:	a1 24 e1 81 00       	mov    0x81e124,%eax
  8029db:	8b 55 d0             	mov    -0x30(%ebp),%edx
  8029de:	89 50 08             	mov    %edx,0x8(%eax)
  8029e1:	eb 08                	jmp    8029eb <free+0x640>
  8029e3:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8029e6:	a3 20 e1 81 00       	mov    %eax,0x81e120
  8029eb:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8029ee:	a3 24 e1 81 00       	mov    %eax,0x81e124
  8029f3:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8029f6:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  8029fd:	a1 2c e1 81 00       	mov    0x81e12c,%eax
  802a02:	40                   	inc    %eax
  802a03:	a3 2c e1 81 00       	mov    %eax,0x81e12c
  802a08:	e9 1b 01 00 00       	jmp    802b28 <free+0x77d>

			}else{
				while(currentfree != NULL){
					if(newfree->size < currentfree->size){
  802a0d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802a10:	8b 50 04             	mov    0x4(%eax),%edx
  802a13:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802a16:	8b 40 04             	mov    0x4(%eax),%eax
  802a19:	39 c2                	cmp    %eax,%edx
  802a1b:	0f 83 81 00 00 00    	jae    802aa2 <free+0x6f7>

							LIST_INSERT_BEFORE(&u_freelist,currentfree,newfree);
  802a21:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802a25:	74 06                	je     802a2d <free+0x682>
  802a27:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  802a2b:	75 17                	jne    802a44 <free+0x699>
  802a2d:	83 ec 04             	sub    $0x4,%esp
  802a30:	68 d0 53 80 00       	push   $0x8053d0
  802a35:	68 30 01 00 00       	push   $0x130
  802a3a:	68 40 53 80 00       	push   $0x805340
  802a3f:	e8 7a df ff ff       	call   8009be <_panic>
  802a44:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802a47:	8b 50 0c             	mov    0xc(%eax),%edx
  802a4a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802a4d:	89 50 0c             	mov    %edx,0xc(%eax)
  802a50:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802a53:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802a56:	89 50 08             	mov    %edx,0x8(%eax)
  802a59:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802a5c:	8b 40 0c             	mov    0xc(%eax),%eax
  802a5f:	85 c0                	test   %eax,%eax
  802a61:	74 0e                	je     802a71 <free+0x6c6>
  802a63:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802a66:	8b 40 0c             	mov    0xc(%eax),%eax
  802a69:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802a6c:	89 50 08             	mov    %edx,0x8(%eax)
  802a6f:	eb 08                	jmp    802a79 <free+0x6ce>
  802a71:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802a74:	a3 20 e1 81 00       	mov    %eax,0x81e120
  802a79:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802a7c:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802a7f:	89 50 0c             	mov    %edx,0xc(%eax)
  802a82:	a1 2c e1 81 00       	mov    0x81e12c,%eax
  802a87:	40                   	inc    %eax
  802a88:	a3 2c e1 81 00       	mov    %eax,0x81e12c
							release_uspinlock(&ulock);
  802a8d:	83 ec 0c             	sub    $0xc,%esp
  802a90:	68 40 e1 81 00       	push   $0x81e140
  802a95:	e8 ff 1c 00 00       	call   804799 <release_uspinlock>
  802a9a:	83 c4 10             	add    $0x10,%esp
							return;
  802a9d:	e9 97 00 00 00       	jmp    802b39 <free+0x78e>
					}
							currentfree = currentfree->prev_next_info.le_next;
  802aa2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802aa5:	8b 40 08             	mov    0x8(%eax),%eax
  802aa8:	89 45 e0             	mov    %eax,-0x20(%ebp)
				}
				free_block(newfree);
				LIST_INSERT_TAIL(&u_freelist,MergedBlock);

			}else{
				while(currentfree != NULL){
  802aab:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802aaf:	0f 85 58 ff ff ff    	jne    802a0d <free+0x662>
							release_uspinlock(&ulock);
							return;
					}
							currentfree = currentfree->prev_next_info.le_next;
				}
				free_block(MergedBlock);
  802ab5:	83 ec 0c             	sub    $0xc,%esp
  802ab8:	ff 75 d0             	pushl  -0x30(%ebp)
  802abb:	e8 b5 18 00 00       	call   804375 <free_block>
  802ac0:	83 c4 10             	add    $0x10,%esp
				LIST_INSERT_TAIL(&u_freelist,newfree);
  802ac3:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  802ac7:	75 17                	jne    802ae0 <free+0x735>
  802ac9:	83 ec 04             	sub    $0x4,%esp
  802acc:	68 8c 53 80 00       	push   $0x80538c
  802ad1:	68 37 01 00 00       	push   $0x137
  802ad6:	68 40 53 80 00       	push   $0x805340
  802adb:	e8 de de ff ff       	call   8009be <_panic>
  802ae0:	8b 15 24 e1 81 00    	mov    0x81e124,%edx
  802ae6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802ae9:	89 50 0c             	mov    %edx,0xc(%eax)
  802aec:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802aef:	8b 40 0c             	mov    0xc(%eax),%eax
  802af2:	85 c0                	test   %eax,%eax
  802af4:	74 0d                	je     802b03 <free+0x758>
  802af6:	a1 24 e1 81 00       	mov    0x81e124,%eax
  802afb:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802afe:	89 50 08             	mov    %edx,0x8(%eax)
  802b01:	eb 08                	jmp    802b0b <free+0x760>
  802b03:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802b06:	a3 20 e1 81 00       	mov    %eax,0x81e120
  802b0b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802b0e:	a3 24 e1 81 00       	mov    %eax,0x81e124
  802b13:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802b16:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802b1d:	a1 2c e1 81 00       	mov    0x81e12c,%eax
  802b22:	40                   	inc    %eax
  802b23:	a3 2c e1 81 00       	mov    %eax,0x81e12c
			}
		release_uspinlock(&ulock);
  802b28:	83 ec 0c             	sub    $0xc,%esp
  802b2b:	68 40 e1 81 00       	push   $0x81e140
  802b30:	e8 64 1c 00 00       	call   804799 <release_uspinlock>
  802b35:	83 c4 10             	add    $0x10,%esp
		return;
  802b38:	90                   	nop
}
  802b39:	c9                   	leave  
  802b3a:	c3                   	ret    

00802b3b <smalloc>:

//=================================
// [3] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  802b3b:	55                   	push   %ebp
  802b3c:	89 e5                	mov    %esp,%ebp
  802b3e:	83 ec 48             	sub    $0x48,%esp
  802b41:	8b 45 10             	mov    0x10(%ebp),%eax
  802b44:	88 45 c4             	mov    %al,-0x3c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  802b47:	e8 2d f2 ff ff       	call   801d79 <uheap_init>
	if (size == 0) return NULL;
  802b4c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802b50:	75 0a                	jne    802b5c <smalloc+0x21>
  802b52:	b8 00 00 00 00       	mov    $0x0,%eax
  802b57:	e9 84 05 00 00       	jmp    8030e0 <smalloc+0x5a5>
	//==============================================================
	acquire_uspinlock(&ulock);
  802b5c:	83 ec 0c             	sub    $0xc,%esp
  802b5f:	68 40 e1 81 00       	push   $0x81e140
  802b64:	e8 d8 1b 00 00       	call   804741 <acquire_uspinlock>
  802b69:	83 c4 10             	add    $0x10,%esp

	struct UserHeapStruct* allocblock = (struct UserHeapStruct*) alloc_block(sizeof(struct UserHeapStruct));
  802b6c:	83 ec 0c             	sub    $0xc,%esp
  802b6f:	6a 10                	push   $0x10
  802b71:	e8 63 13 00 00       	call   803ed9 <alloc_block>
  802b76:	83 c4 10             	add    $0x10,%esp
  802b79:	89 45 ec             	mov    %eax,-0x14(%ebp)
	if (allocblock == NULL){
  802b7c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802b80:	75 0a                	jne    802b8c <smalloc+0x51>
				return NULL;
  802b82:	b8 00 00 00 00       	mov    $0x0,%eax
  802b87:	e9 54 05 00 00       	jmp    8030e0 <smalloc+0x5a5>
	}
		size = ROUNDUP(size,PAGE_SIZE);
  802b8c:	c7 45 e8 00 10 00 00 	movl   $0x1000,-0x18(%ebp)
  802b93:	8b 55 0c             	mov    0xc(%ebp),%edx
  802b96:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b99:	01 d0                	add    %edx,%eax
  802b9b:	48                   	dec    %eax
  802b9c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  802b9f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802ba2:	ba 00 00 00 00       	mov    $0x0,%edx
  802ba7:	f7 75 e8             	divl   -0x18(%ebp)
  802baa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802bad:	29 d0                	sub    %edx,%eax
  802baf:	89 45 0c             	mov    %eax,0xc(%ebp)
		struct UserHeapStruct* lastfreeelement = LIST_LAST(&u_freelist);
  802bb2:	a1 24 e1 81 00       	mov    0x81e124,%eax
  802bb7:	89 45 e0             	mov    %eax,-0x20(%ebp)

		if(LIST_SIZE(&u_freelist)==0 || size>lastfreeelement->size){
  802bba:	a1 2c e1 81 00       	mov    0x81e12c,%eax
  802bbf:	85 c0                	test   %eax,%eax
  802bc1:	74 0f                	je     802bd2 <smalloc+0x97>
  802bc3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802bc6:	8b 40 04             	mov    0x4(%eax),%eax
  802bc9:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802bcc:	0f 83 25 01 00 00    	jae    802cf7 <smalloc+0x1bc>
				if(uheapPageAllocBreak <= USER_HEAP_MAX - size){
  802bd2:	b8 00 00 00 a0       	mov    $0xa0000000,%eax
  802bd7:	2b 45 0c             	sub    0xc(%ebp),%eax
  802bda:	89 c2                	mov    %eax,%edx
  802bdc:	a1 68 e0 81 00       	mov    0x81e068,%eax
  802be1:	39 c2                	cmp    %eax,%edx
  802be3:	0f 82 f4 00 00 00    	jb     802cdd <smalloc+0x1a2>
						uint32 requestedblockva = uheapPageAllocBreak;
  802be9:	a1 68 e0 81 00       	mov    0x81e068,%eax
  802bee:	89 45 d4             	mov    %eax,-0x2c(%ebp)
						uheapPageAllocBreak+=size;
  802bf1:	8b 15 68 e0 81 00    	mov    0x81e068,%edx
  802bf7:	8b 45 0c             	mov    0xc(%ebp),%eax
  802bfa:	01 d0                	add    %edx,%eax
  802bfc:	a3 68 e0 81 00       	mov    %eax,0x81e068
						allocblock->startva = requestedblockva;
  802c01:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c04:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802c07:	89 10                	mov    %edx,(%eax)
						allocblock->size = size;
  802c09:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c0c:	8b 55 0c             	mov    0xc(%ebp),%edx
  802c0f:	89 50 04             	mov    %edx,0x4(%eax)

						LIST_INSERT_TAIL(&u_allocatedlist, allocblock);
  802c12:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802c16:	75 17                	jne    802c2f <smalloc+0xf4>
  802c18:	83 ec 04             	sub    $0x4,%esp
  802c1b:	68 8c 53 80 00       	push   $0x80538c
  802c20:	68 57 01 00 00       	push   $0x157
  802c25:	68 40 53 80 00       	push   $0x805340
  802c2a:	e8 8f dd ff ff       	call   8009be <_panic>
  802c2f:	8b 15 34 e1 81 00    	mov    0x81e134,%edx
  802c35:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c38:	89 50 0c             	mov    %edx,0xc(%eax)
  802c3b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c3e:	8b 40 0c             	mov    0xc(%eax),%eax
  802c41:	85 c0                	test   %eax,%eax
  802c43:	74 0d                	je     802c52 <smalloc+0x117>
  802c45:	a1 34 e1 81 00       	mov    0x81e134,%eax
  802c4a:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802c4d:	89 50 08             	mov    %edx,0x8(%eax)
  802c50:	eb 08                	jmp    802c5a <smalloc+0x11f>
  802c52:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c55:	a3 30 e1 81 00       	mov    %eax,0x81e130
  802c5a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c5d:	a3 34 e1 81 00       	mov    %eax,0x81e134
  802c62:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c65:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802c6c:	a1 3c e1 81 00       	mov    0x81e13c,%eax
  802c71:	40                   	inc    %eax
  802c72:	a3 3c e1 81 00       	mov    %eax,0x81e13c


						int result = sys_create_shared_object(sharedVarName ,size ,isWritable ,(void*)allocblock->startva);
  802c77:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c7a:	8b 00                	mov    (%eax),%eax
  802c7c:	89 c2                	mov    %eax,%edx
  802c7e:	0f b6 45 c4          	movzbl -0x3c(%ebp),%eax
  802c82:	52                   	push   %edx
  802c83:	50                   	push   %eax
  802c84:	ff 75 0c             	pushl  0xc(%ebp)
  802c87:	ff 75 08             	pushl  0x8(%ebp)
  802c8a:	e8 48 0c 00 00       	call   8038d7 <sys_create_shared_object>
  802c8f:	83 c4 10             	add    $0x10,%esp
  802c92:	89 45 d0             	mov    %eax,-0x30(%ebp)

						if(result <0){
  802c95:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  802c99:	79 28                	jns    802cc3 <smalloc+0x188>
							free_block(allocblock);
  802c9b:	83 ec 0c             	sub    $0xc,%esp
  802c9e:	ff 75 ec             	pushl  -0x14(%ebp)
  802ca1:	e8 cf 16 00 00       	call   804375 <free_block>
  802ca6:	83 c4 10             	add    $0x10,%esp
							release_uspinlock(&ulock);
  802ca9:	83 ec 0c             	sub    $0xc,%esp
  802cac:	68 40 e1 81 00       	push   $0x81e140
  802cb1:	e8 e3 1a 00 00       	call   804799 <release_uspinlock>
  802cb6:	83 c4 10             	add    $0x10,%esp
							return NULL;
  802cb9:	b8 00 00 00 00       	mov    $0x0,%eax
  802cbe:	e9 1d 04 00 00       	jmp    8030e0 <smalloc+0x5a5>
						}
						release_uspinlock(&ulock);
  802cc3:	83 ec 0c             	sub    $0xc,%esp
  802cc6:	68 40 e1 81 00       	push   $0x81e140
  802ccb:	e8 c9 1a 00 00       	call   804799 <release_uspinlock>
  802cd0:	83 c4 10             	add    $0x10,%esp
						return (void*)allocblock -> startva;
  802cd3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cd6:	8b 00                	mov    (%eax),%eax
  802cd8:	e9 03 04 00 00       	jmp    8030e0 <smalloc+0x5a5>
				}else{
						release_uspinlock(&ulock);
  802cdd:	83 ec 0c             	sub    $0xc,%esp
  802ce0:	68 40 e1 81 00       	push   $0x81e140
  802ce5:	e8 af 1a 00 00       	call   804799 <release_uspinlock>
  802cea:	83 c4 10             	add    $0x10,%esp
						return NULL;
  802ced:	b8 00 00 00 00       	mov    $0x0,%eax
  802cf2:	e9 e9 03 00 00       	jmp    8030e0 <smalloc+0x5a5>
					 }
		}else{
			//custom fit
			struct UserHeapStruct* currentfreeelement = LIST_FIRST(&u_freelist);
  802cf7:	a1 20 e1 81 00       	mov    0x81e120,%eax
  802cfc:	89 45 f4             	mov    %eax,-0xc(%ebp)
			//worst fit
			while(currentfreeelement != NULL){
  802cff:	e9 af 03 00 00       	jmp    8030b3 <smalloc+0x578>
				if(size<currentfreeelement->size){
  802d04:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d07:	8b 40 04             	mov    0x4(%eax),%eax
  802d0a:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802d0d:	0f 86 28 02 00 00    	jbe    802f3b <smalloc+0x400>
					allocblock->startva = lastfreeelement->startva;
  802d13:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802d16:	8b 10                	mov    (%eax),%edx
  802d18:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d1b:	89 10                	mov    %edx,(%eax)
	                allocblock->size = size;
  802d1d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d20:	8b 55 0c             	mov    0xc(%ebp),%edx
  802d23:	89 50 04             	mov    %edx,0x4(%eax)
	                LIST_INSERT_TAIL(&u_allocatedlist,allocblock);
  802d26:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802d2a:	75 17                	jne    802d43 <smalloc+0x208>
  802d2c:	83 ec 04             	sub    $0x4,%esp
  802d2f:	68 8c 53 80 00       	push   $0x80538c
  802d34:	68 6f 01 00 00       	push   $0x16f
  802d39:	68 40 53 80 00       	push   $0x805340
  802d3e:	e8 7b dc ff ff       	call   8009be <_panic>
  802d43:	8b 15 34 e1 81 00    	mov    0x81e134,%edx
  802d49:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d4c:	89 50 0c             	mov    %edx,0xc(%eax)
  802d4f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d52:	8b 40 0c             	mov    0xc(%eax),%eax
  802d55:	85 c0                	test   %eax,%eax
  802d57:	74 0d                	je     802d66 <smalloc+0x22b>
  802d59:	a1 34 e1 81 00       	mov    0x81e134,%eax
  802d5e:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802d61:	89 50 08             	mov    %edx,0x8(%eax)
  802d64:	eb 08                	jmp    802d6e <smalloc+0x233>
  802d66:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d69:	a3 30 e1 81 00       	mov    %eax,0x81e130
  802d6e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d71:	a3 34 e1 81 00       	mov    %eax,0x81e134
  802d76:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d79:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802d80:	a1 3c e1 81 00       	mov    0x81e13c,%eax
  802d85:	40                   	inc    %eax
  802d86:	a3 3c e1 81 00       	mov    %eax,0x81e13c
	                lastfreeelement->startva += size;
  802d8b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802d8e:	8b 10                	mov    (%eax),%edx
  802d90:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d93:	01 c2                	add    %eax,%edx
  802d95:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802d98:	89 10                	mov    %edx,(%eax)
	                lastfreeelement->size -= size;
  802d9a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802d9d:	8b 40 04             	mov    0x4(%eax),%eax
  802da0:	2b 45 0c             	sub    0xc(%ebp),%eax
  802da3:	89 c2                	mov    %eax,%edx
  802da5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802da8:	89 50 04             	mov    %edx,0x4(%eax)
	                struct UserHeapStruct* currentfree2 = LIST_FIRST(&u_freelist);
  802dab:	a1 20 e1 81 00       	mov    0x81e120,%eax
  802db0:	89 45 f0             	mov    %eax,-0x10(%ebp)
	                //check order of last element

	                while (currentfree2 != NULL){
  802db3:	e9 13 01 00 00       	jmp    802ecb <smalloc+0x390>
	                	if(lastfreeelement->size <currentfree2->size){
  802db8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802dbb:	8b 50 04             	mov    0x4(%eax),%edx
  802dbe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dc1:	8b 40 04             	mov    0x4(%eax),%eax
  802dc4:	39 c2                	cmp    %eax,%edx
  802dc6:	0f 83 f6 00 00 00    	jae    802ec2 <smalloc+0x387>
	                		LIST_REMOVE(&u_freelist ,lastfreeelement);
  802dcc:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802dd0:	75 17                	jne    802de9 <smalloc+0x2ae>
  802dd2:	83 ec 04             	sub    $0x4,%esp
  802dd5:	68 af 53 80 00       	push   $0x8053af
  802dda:	68 77 01 00 00       	push   $0x177
  802ddf:	68 40 53 80 00       	push   $0x805340
  802de4:	e8 d5 db ff ff       	call   8009be <_panic>
  802de9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802dec:	8b 40 08             	mov    0x8(%eax),%eax
  802def:	85 c0                	test   %eax,%eax
  802df1:	74 11                	je     802e04 <smalloc+0x2c9>
  802df3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802df6:	8b 40 08             	mov    0x8(%eax),%eax
  802df9:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802dfc:	8b 52 0c             	mov    0xc(%edx),%edx
  802dff:	89 50 0c             	mov    %edx,0xc(%eax)
  802e02:	eb 0b                	jmp    802e0f <smalloc+0x2d4>
  802e04:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802e07:	8b 40 0c             	mov    0xc(%eax),%eax
  802e0a:	a3 24 e1 81 00       	mov    %eax,0x81e124
  802e0f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802e12:	8b 40 0c             	mov    0xc(%eax),%eax
  802e15:	85 c0                	test   %eax,%eax
  802e17:	74 11                	je     802e2a <smalloc+0x2ef>
  802e19:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802e1c:	8b 40 0c             	mov    0xc(%eax),%eax
  802e1f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802e22:	8b 52 08             	mov    0x8(%edx),%edx
  802e25:	89 50 08             	mov    %edx,0x8(%eax)
  802e28:	eb 0b                	jmp    802e35 <smalloc+0x2fa>
  802e2a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802e2d:	8b 40 08             	mov    0x8(%eax),%eax
  802e30:	a3 20 e1 81 00       	mov    %eax,0x81e120
  802e35:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802e38:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802e3f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802e42:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  802e49:	a1 2c e1 81 00       	mov    0x81e12c,%eax
  802e4e:	48                   	dec    %eax
  802e4f:	a3 2c e1 81 00       	mov    %eax,0x81e12c
	                		LIST_INSERT_BEFORE(&u_freelist ,currentfree2 ,lastfreeelement);
  802e54:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802e58:	74 06                	je     802e60 <smalloc+0x325>
  802e5a:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802e5e:	75 17                	jne    802e77 <smalloc+0x33c>
  802e60:	83 ec 04             	sub    $0x4,%esp
  802e63:	68 d0 53 80 00       	push   $0x8053d0
  802e68:	68 78 01 00 00       	push   $0x178
  802e6d:	68 40 53 80 00       	push   $0x805340
  802e72:	e8 47 db ff ff       	call   8009be <_panic>
  802e77:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e7a:	8b 50 0c             	mov    0xc(%eax),%edx
  802e7d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802e80:	89 50 0c             	mov    %edx,0xc(%eax)
  802e83:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802e86:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802e89:	89 50 08             	mov    %edx,0x8(%eax)
  802e8c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e8f:	8b 40 0c             	mov    0xc(%eax),%eax
  802e92:	85 c0                	test   %eax,%eax
  802e94:	74 0e                	je     802ea4 <smalloc+0x369>
  802e96:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e99:	8b 40 0c             	mov    0xc(%eax),%eax
  802e9c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802e9f:	89 50 08             	mov    %edx,0x8(%eax)
  802ea2:	eb 08                	jmp    802eac <smalloc+0x371>
  802ea4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802ea7:	a3 20 e1 81 00       	mov    %eax,0x81e120
  802eac:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802eaf:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802eb2:	89 50 0c             	mov    %edx,0xc(%eax)
  802eb5:	a1 2c e1 81 00       	mov    0x81e12c,%eax
  802eba:	40                   	inc    %eax
  802ebb:	a3 2c e1 81 00       	mov    %eax,0x81e12c
	                		break;
  802ec0:	eb 13                	jmp    802ed5 <smalloc+0x39a>
	                	}
	                	currentfree2 = currentfree2->prev_next_info.le_next;
  802ec2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ec5:	8b 40 08             	mov    0x8(%eax),%eax
  802ec8:	89 45 f0             	mov    %eax,-0x10(%ebp)
	                lastfreeelement->startva += size;
	                lastfreeelement->size -= size;
	                struct UserHeapStruct* currentfree2 = LIST_FIRST(&u_freelist);
	                //check order of last element

	                while (currentfree2 != NULL){
  802ecb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802ecf:	0f 85 e3 fe ff ff    	jne    802db8 <smalloc+0x27d>
	                	}
	                	currentfree2 = currentfree2->prev_next_info.le_next;
	                }


	                int result = sys_create_shared_object(sharedVarName ,size ,isWritable ,(void*)allocblock->startva);
  802ed5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ed8:	8b 00                	mov    (%eax),%eax
  802eda:	89 c2                	mov    %eax,%edx
  802edc:	0f b6 45 c4          	movzbl -0x3c(%ebp),%eax
  802ee0:	52                   	push   %edx
  802ee1:	50                   	push   %eax
  802ee2:	ff 75 0c             	pushl  0xc(%ebp)
  802ee5:	ff 75 08             	pushl  0x8(%ebp)
  802ee8:	e8 ea 09 00 00       	call   8038d7 <sys_create_shared_object>
  802eed:	83 c4 10             	add    $0x10,%esp
  802ef0:	89 45 d8             	mov    %eax,-0x28(%ebp)

	                if(result <0){
  802ef3:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  802ef7:	79 28                	jns    802f21 <smalloc+0x3e6>
	                	free_block(allocblock);
  802ef9:	83 ec 0c             	sub    $0xc,%esp
  802efc:	ff 75 ec             	pushl  -0x14(%ebp)
  802eff:	e8 71 14 00 00       	call   804375 <free_block>
  802f04:	83 c4 10             	add    $0x10,%esp
	                	release_uspinlock(&ulock);
  802f07:	83 ec 0c             	sub    $0xc,%esp
  802f0a:	68 40 e1 81 00       	push   $0x81e140
  802f0f:	e8 85 18 00 00       	call   804799 <release_uspinlock>
  802f14:	83 c4 10             	add    $0x10,%esp
	                	return NULL;
  802f17:	b8 00 00 00 00       	mov    $0x0,%eax
  802f1c:	e9 bf 01 00 00       	jmp    8030e0 <smalloc+0x5a5>
	                }
	                release_uspinlock(&ulock);
  802f21:	83 ec 0c             	sub    $0xc,%esp
  802f24:	68 40 e1 81 00       	push   $0x81e140
  802f29:	e8 6b 18 00 00       	call   804799 <release_uspinlock>
  802f2e:	83 c4 10             	add    $0x10,%esp
	                return (void*)allocblock->startva;
  802f31:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f34:	8b 00                	mov    (%eax),%eax
  802f36:	e9 a5 01 00 00       	jmp    8030e0 <smalloc+0x5a5>
	                //exact fit
				}else if(size == currentfreeelement->size){
  802f3b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f3e:	8b 40 04             	mov    0x4(%eax),%eax
  802f41:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802f44:	0f 85 60 01 00 00    	jne    8030aa <smalloc+0x56f>
					allocblock->startva = currentfreeelement->startva;
  802f4a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f4d:	8b 10                	mov    (%eax),%edx
  802f4f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f52:	89 10                	mov    %edx,(%eax)
					allocblock->size = size;
  802f54:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f57:	8b 55 0c             	mov    0xc(%ebp),%edx
  802f5a:	89 50 04             	mov    %edx,0x4(%eax)
					LIST_INSERT_TAIL(&u_allocatedlist ,allocblock);
  802f5d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802f61:	75 17                	jne    802f7a <smalloc+0x43f>
  802f63:	83 ec 04             	sub    $0x4,%esp
  802f66:	68 8c 53 80 00       	push   $0x80538c
  802f6b:	68 8c 01 00 00       	push   $0x18c
  802f70:	68 40 53 80 00       	push   $0x805340
  802f75:	e8 44 da ff ff       	call   8009be <_panic>
  802f7a:	8b 15 34 e1 81 00    	mov    0x81e134,%edx
  802f80:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f83:	89 50 0c             	mov    %edx,0xc(%eax)
  802f86:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f89:	8b 40 0c             	mov    0xc(%eax),%eax
  802f8c:	85 c0                	test   %eax,%eax
  802f8e:	74 0d                	je     802f9d <smalloc+0x462>
  802f90:	a1 34 e1 81 00       	mov    0x81e134,%eax
  802f95:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802f98:	89 50 08             	mov    %edx,0x8(%eax)
  802f9b:	eb 08                	jmp    802fa5 <smalloc+0x46a>
  802f9d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802fa0:	a3 30 e1 81 00       	mov    %eax,0x81e130
  802fa5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802fa8:	a3 34 e1 81 00       	mov    %eax,0x81e134
  802fad:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802fb0:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802fb7:	a1 3c e1 81 00       	mov    0x81e13c,%eax
  802fbc:	40                   	inc    %eax
  802fbd:	a3 3c e1 81 00       	mov    %eax,0x81e13c
					LIST_REMOVE(&u_freelist ,currentfreeelement);
  802fc2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802fc6:	75 17                	jne    802fdf <smalloc+0x4a4>
  802fc8:	83 ec 04             	sub    $0x4,%esp
  802fcb:	68 af 53 80 00       	push   $0x8053af
  802fd0:	68 8d 01 00 00       	push   $0x18d
  802fd5:	68 40 53 80 00       	push   $0x805340
  802fda:	e8 df d9 ff ff       	call   8009be <_panic>
  802fdf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fe2:	8b 40 08             	mov    0x8(%eax),%eax
  802fe5:	85 c0                	test   %eax,%eax
  802fe7:	74 11                	je     802ffa <smalloc+0x4bf>
  802fe9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fec:	8b 40 08             	mov    0x8(%eax),%eax
  802fef:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ff2:	8b 52 0c             	mov    0xc(%edx),%edx
  802ff5:	89 50 0c             	mov    %edx,0xc(%eax)
  802ff8:	eb 0b                	jmp    803005 <smalloc+0x4ca>
  802ffa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ffd:	8b 40 0c             	mov    0xc(%eax),%eax
  803000:	a3 24 e1 81 00       	mov    %eax,0x81e124
  803005:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803008:	8b 40 0c             	mov    0xc(%eax),%eax
  80300b:	85 c0                	test   %eax,%eax
  80300d:	74 11                	je     803020 <smalloc+0x4e5>
  80300f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803012:	8b 40 0c             	mov    0xc(%eax),%eax
  803015:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803018:	8b 52 08             	mov    0x8(%edx),%edx
  80301b:	89 50 08             	mov    %edx,0x8(%eax)
  80301e:	eb 0b                	jmp    80302b <smalloc+0x4f0>
  803020:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803023:	8b 40 08             	mov    0x8(%eax),%eax
  803026:	a3 20 e1 81 00       	mov    %eax,0x81e120
  80302b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80302e:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  803035:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803038:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  80303f:	a1 2c e1 81 00       	mov    0x81e12c,%eax
  803044:	48                   	dec    %eax
  803045:	a3 2c e1 81 00       	mov    %eax,0x81e12c
					int result = sys_create_shared_object(sharedVarName ,size ,isWritable ,(void*)allocblock->startva);
  80304a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80304d:	8b 00                	mov    (%eax),%eax
  80304f:	89 c2                	mov    %eax,%edx
  803051:	0f b6 45 c4          	movzbl -0x3c(%ebp),%eax
  803055:	52                   	push   %edx
  803056:	50                   	push   %eax
  803057:	ff 75 0c             	pushl  0xc(%ebp)
  80305a:	ff 75 08             	pushl  0x8(%ebp)
  80305d:	e8 75 08 00 00       	call   8038d7 <sys_create_shared_object>
  803062:	83 c4 10             	add    $0x10,%esp
  803065:	89 45 dc             	mov    %eax,-0x24(%ebp)

					if(result <0){
  803068:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80306c:	79 25                	jns    803093 <smalloc+0x558>
						free_block(allocblock);
  80306e:	83 ec 0c             	sub    $0xc,%esp
  803071:	ff 75 ec             	pushl  -0x14(%ebp)
  803074:	e8 fc 12 00 00       	call   804375 <free_block>
  803079:	83 c4 10             	add    $0x10,%esp
						release_uspinlock(&ulock);
  80307c:	83 ec 0c             	sub    $0xc,%esp
  80307f:	68 40 e1 81 00       	push   $0x81e140
  803084:	e8 10 17 00 00       	call   804799 <release_uspinlock>
  803089:	83 c4 10             	add    $0x10,%esp
						return NULL;
  80308c:	b8 00 00 00 00       	mov    $0x0,%eax
  803091:	eb 4d                	jmp    8030e0 <smalloc+0x5a5>
					}
					release_uspinlock(&ulock);
  803093:	83 ec 0c             	sub    $0xc,%esp
  803096:	68 40 e1 81 00       	push   $0x81e140
  80309b:	e8 f9 16 00 00       	call   804799 <release_uspinlock>
  8030a0:	83 c4 10             	add    $0x10,%esp
					return (void*)allocblock->startva;
  8030a3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030a6:	8b 00                	mov    (%eax),%eax
  8030a8:	eb 36                	jmp    8030e0 <smalloc+0x5a5>
				}
				currentfreeelement = currentfreeelement->prev_next_info.le_next;
  8030aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030ad:	8b 40 08             	mov    0x8(%eax),%eax
  8030b0:	89 45 f4             	mov    %eax,-0xc(%ebp)
					 }
		}else{
			//custom fit
			struct UserHeapStruct* currentfreeelement = LIST_FIRST(&u_freelist);
			//worst fit
			while(currentfreeelement != NULL){
  8030b3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8030b7:	0f 85 47 fc ff ff    	jne    802d04 <smalloc+0x1c9>
					return (void*)allocblock->startva;
				}
				currentfreeelement = currentfreeelement->prev_next_info.le_next;
			}
		}
		free_block(allocblock);
  8030bd:	83 ec 0c             	sub    $0xc,%esp
  8030c0:	ff 75 ec             	pushl  -0x14(%ebp)
  8030c3:	e8 ad 12 00 00       	call   804375 <free_block>
  8030c8:	83 c4 10             	add    $0x10,%esp
		release_uspinlock(&ulock);
  8030cb:	83 ec 0c             	sub    $0xc,%esp
  8030ce:	68 40 e1 81 00       	push   $0x81e140
  8030d3:	e8 c1 16 00 00       	call   804799 <release_uspinlock>
  8030d8:	83 c4 10             	add    $0x10,%esp
		return NULL;
  8030db:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8030e0:	c9                   	leave  
  8030e1:	c3                   	ret    

008030e2 <sget>:

//========================================
// [4] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8030e2:	55                   	push   %ebp
  8030e3:	89 e5                	mov    %esp,%ebp
  8030e5:	83 ec 38             	sub    $0x38,%esp


	 //==============================================================
	 // DON'T CHANGE THIS CODE
	    uheap_init();
  8030e8:	e8 8c ec ff ff       	call   801d79 <uheap_init>
	 //==============================================================
	 // Get size of the shared variable from kernel
	acquire_uspinlock(&ulock);
  8030ed:	83 ec 0c             	sub    $0xc,%esp
  8030f0:	68 40 e1 81 00       	push   $0x81e140
  8030f5:	e8 47 16 00 00       	call   804741 <acquire_uspinlock>
  8030fa:	83 c4 10             	add    $0x10,%esp


	int size = sys_size_of_shared_object(ownerEnvID ,sharedVarName);
  8030fd:	83 ec 08             	sub    $0x8,%esp
  803100:	ff 75 0c             	pushl  0xc(%ebp)
  803103:	ff 75 08             	pushl  0x8(%ebp)
  803106:	e8 f6 07 00 00       	call   803901 <sys_size_of_shared_object>
  80310b:	83 c4 10             	add    $0x10,%esp
  80310e:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if ( size < 0 ){
  803111:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803115:	79 1a                	jns    803131 <sget+0x4f>
			release_uspinlock(&ulock);
  803117:	83 ec 0c             	sub    $0xc,%esp
  80311a:	68 40 e1 81 00       	push   $0x81e140
  80311f:	e8 75 16 00 00       	call   804799 <release_uspinlock>
  803124:	83 c4 10             	add    $0x10,%esp
			return NULL;
  803127:	b8 00 00 00 00       	mov    $0x0,%eax
  80312c:	e9 6e 05 00 00       	jmp    80369f <sget+0x5bd>
		}
		size = ROUNDUP(size,PAGE_SIZE);
  803131:	c7 45 e8 00 10 00 00 	movl   $0x1000,-0x18(%ebp)
  803138:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80313b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80313e:	01 d0                	add    %edx,%eax
  803140:	48                   	dec    %eax
  803141:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  803144:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803147:	ba 00 00 00 00       	mov    $0x0,%edx
  80314c:	f7 75 e8             	divl   -0x18(%ebp)
  80314f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803152:	29 d0                	sub    %edx,%eax
  803154:	89 45 ec             	mov    %eax,-0x14(%ebp)

		struct UserHeapStruct* allocblock = (struct UserHeapStruct*) alloc_block(sizeof(struct UserHeapStruct));
  803157:	83 ec 0c             	sub    $0xc,%esp
  80315a:	6a 10                	push   $0x10
  80315c:	e8 78 0d 00 00       	call   803ed9 <alloc_block>
  803161:	83 c4 10             	add    $0x10,%esp
  803164:	89 45 e0             	mov    %eax,-0x20(%ebp)

		if (allocblock == NULL){
  803167:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80316b:	75 0a                	jne    803177 <sget+0x95>
			return NULL;
  80316d:	b8 00 00 00 00       	mov    $0x0,%eax
  803172:	e9 28 05 00 00       	jmp    80369f <sget+0x5bd>
		}
		struct UserHeapStruct* lastfreeelement = LIST_LAST(&u_freelist);
  803177:	a1 24 e1 81 00       	mov    0x81e124,%eax
  80317c:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if(LIST_SIZE(&u_freelist)==0 || size>lastfreeelement->size){
  80317f:	a1 2c e1 81 00       	mov    0x81e12c,%eax
  803184:	85 c0                	test   %eax,%eax
  803186:	74 11                	je     803199 <sget+0xb7>
  803188:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80318b:	8b 50 04             	mov    0x4(%eax),%edx
  80318e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803191:	39 c2                	cmp    %eax,%edx
  803193:	0f 83 21 01 00 00    	jae    8032ba <sget+0x1d8>
				if(uheapPageAllocBreak <= USER_HEAP_MAX - size){
  803199:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80319c:	ba 00 00 00 a0       	mov    $0xa0000000,%edx
  8031a1:	29 c2                	sub    %eax,%edx
  8031a3:	a1 68 e0 81 00       	mov    0x81e068,%eax
  8031a8:	39 c2                	cmp    %eax,%edx
  8031aa:	0f 82 f0 00 00 00    	jb     8032a0 <sget+0x1be>

						uint32 requestedblockva = uheapPageAllocBreak;
  8031b0:	a1 68 e0 81 00       	mov    0x81e068,%eax
  8031b5:	89 45 d0             	mov    %eax,-0x30(%ebp)
						uheapPageAllocBreak+=size;
  8031b8:	8b 15 68 e0 81 00    	mov    0x81e068,%edx
  8031be:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8031c1:	01 d0                	add    %edx,%eax
  8031c3:	a3 68 e0 81 00       	mov    %eax,0x81e068
						allocblock->startva = requestedblockva;
  8031c8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8031cb:	8b 55 d0             	mov    -0x30(%ebp),%edx
  8031ce:	89 10                	mov    %edx,(%eax)
						allocblock->size = size;
  8031d0:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8031d3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8031d6:	89 50 04             	mov    %edx,0x4(%eax)

						LIST_INSERT_TAIL(&u_allocatedlist, allocblock);
  8031d9:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8031dd:	75 17                	jne    8031f6 <sget+0x114>
  8031df:	83 ec 04             	sub    $0x4,%esp
  8031e2:	68 8c 53 80 00       	push   $0x80538c
  8031e7:	68 c8 01 00 00       	push   $0x1c8
  8031ec:	68 40 53 80 00       	push   $0x805340
  8031f1:	e8 c8 d7 ff ff       	call   8009be <_panic>
  8031f6:	8b 15 34 e1 81 00    	mov    0x81e134,%edx
  8031fc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8031ff:	89 50 0c             	mov    %edx,0xc(%eax)
  803202:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803205:	8b 40 0c             	mov    0xc(%eax),%eax
  803208:	85 c0                	test   %eax,%eax
  80320a:	74 0d                	je     803219 <sget+0x137>
  80320c:	a1 34 e1 81 00       	mov    0x81e134,%eax
  803211:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803214:	89 50 08             	mov    %edx,0x8(%eax)
  803217:	eb 08                	jmp    803221 <sget+0x13f>
  803219:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80321c:	a3 30 e1 81 00       	mov    %eax,0x81e130
  803221:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803224:	a3 34 e1 81 00       	mov    %eax,0x81e134
  803229:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80322c:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  803233:	a1 3c e1 81 00       	mov    0x81e13c,%eax
  803238:	40                   	inc    %eax
  803239:	a3 3c e1 81 00       	mov    %eax,0x81e13c


						int result = sys_get_shared_object(ownerEnvID ,sharedVarName ,(void*)allocblock->startva);
  80323e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803241:	8b 00                	mov    (%eax),%eax
  803243:	83 ec 04             	sub    $0x4,%esp
  803246:	50                   	push   %eax
  803247:	ff 75 0c             	pushl  0xc(%ebp)
  80324a:	ff 75 08             	pushl  0x8(%ebp)
  80324d:	e8 cc 06 00 00       	call   80391e <sys_get_shared_object>
  803252:	83 c4 10             	add    $0x10,%esp
  803255:	89 45 cc             	mov    %eax,-0x34(%ebp)

						if(result <0){
  803258:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  80325c:	79 28                	jns    803286 <sget+0x1a4>
							free_block(allocblock);
  80325e:	83 ec 0c             	sub    $0xc,%esp
  803261:	ff 75 e0             	pushl  -0x20(%ebp)
  803264:	e8 0c 11 00 00       	call   804375 <free_block>
  803269:	83 c4 10             	add    $0x10,%esp
							release_uspinlock(&ulock);
  80326c:	83 ec 0c             	sub    $0xc,%esp
  80326f:	68 40 e1 81 00       	push   $0x81e140
  803274:	e8 20 15 00 00       	call   804799 <release_uspinlock>
  803279:	83 c4 10             	add    $0x10,%esp
							return NULL;
  80327c:	b8 00 00 00 00       	mov    $0x0,%eax
  803281:	e9 19 04 00 00       	jmp    80369f <sget+0x5bd>
						}
						release_uspinlock(&ulock);
  803286:	83 ec 0c             	sub    $0xc,%esp
  803289:	68 40 e1 81 00       	push   $0x81e140
  80328e:	e8 06 15 00 00       	call   804799 <release_uspinlock>
  803293:	83 c4 10             	add    $0x10,%esp
						return (void*)allocblock -> startva;
  803296:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803299:	8b 00                	mov    (%eax),%eax
  80329b:	e9 ff 03 00 00       	jmp    80369f <sget+0x5bd>
				}else{
						release_uspinlock(&ulock);
  8032a0:	83 ec 0c             	sub    $0xc,%esp
  8032a3:	68 40 e1 81 00       	push   $0x81e140
  8032a8:	e8 ec 14 00 00       	call   804799 <release_uspinlock>
  8032ad:	83 c4 10             	add    $0x10,%esp
						return NULL;
  8032b0:	b8 00 00 00 00       	mov    $0x0,%eax
  8032b5:	e9 e5 03 00 00       	jmp    80369f <sget+0x5bd>
					 }
		}else{
			//custom fit
			struct UserHeapStruct* currentfreeelement = LIST_FIRST(&u_freelist);
  8032ba:	a1 20 e1 81 00       	mov    0x81e120,%eax
  8032bf:	89 45 f4             	mov    %eax,-0xc(%ebp)
			//worst fit
			while(currentfreeelement != NULL){
  8032c2:	e9 ab 03 00 00       	jmp    803672 <sget+0x590>
				if(size<currentfreeelement->size){
  8032c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032ca:	8b 50 04             	mov    0x4(%eax),%edx
  8032cd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8032d0:	39 c2                	cmp    %eax,%edx
  8032d2:	0f 86 24 02 00 00    	jbe    8034fc <sget+0x41a>
					allocblock->startva = lastfreeelement->startva;
  8032d8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8032db:	8b 10                	mov    (%eax),%edx
  8032dd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8032e0:	89 10                	mov    %edx,(%eax)
					allocblock->size = size;
  8032e2:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8032e5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8032e8:	89 50 04             	mov    %edx,0x4(%eax)
					LIST_INSERT_TAIL(&u_allocatedlist,allocblock);
  8032eb:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8032ef:	75 17                	jne    803308 <sget+0x226>
  8032f1:	83 ec 04             	sub    $0x4,%esp
  8032f4:	68 8c 53 80 00       	push   $0x80538c
  8032f9:	68 e0 01 00 00       	push   $0x1e0
  8032fe:	68 40 53 80 00       	push   $0x805340
  803303:	e8 b6 d6 ff ff       	call   8009be <_panic>
  803308:	8b 15 34 e1 81 00    	mov    0x81e134,%edx
  80330e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803311:	89 50 0c             	mov    %edx,0xc(%eax)
  803314:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803317:	8b 40 0c             	mov    0xc(%eax),%eax
  80331a:	85 c0                	test   %eax,%eax
  80331c:	74 0d                	je     80332b <sget+0x249>
  80331e:	a1 34 e1 81 00       	mov    0x81e134,%eax
  803323:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803326:	89 50 08             	mov    %edx,0x8(%eax)
  803329:	eb 08                	jmp    803333 <sget+0x251>
  80332b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80332e:	a3 30 e1 81 00       	mov    %eax,0x81e130
  803333:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803336:	a3 34 e1 81 00       	mov    %eax,0x81e134
  80333b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80333e:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  803345:	a1 3c e1 81 00       	mov    0x81e13c,%eax
  80334a:	40                   	inc    %eax
  80334b:	a3 3c e1 81 00       	mov    %eax,0x81e13c
					lastfreeelement->startva += size;
  803350:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803353:	8b 10                	mov    (%eax),%edx
  803355:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803358:	01 c2                	add    %eax,%edx
  80335a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80335d:	89 10                	mov    %edx,(%eax)
					lastfreeelement->size -= size;
  80335f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803362:	8b 50 04             	mov    0x4(%eax),%edx
  803365:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803368:	29 c2                	sub    %eax,%edx
  80336a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80336d:	89 50 04             	mov    %edx,0x4(%eax)
					struct UserHeapStruct* currentfree2 = LIST_FIRST(&u_freelist);
  803370:	a1 20 e1 81 00       	mov    0x81e120,%eax
  803375:	89 45 f0             	mov    %eax,-0x10(%ebp)
					//check order of last element

					while (currentfree2 != NULL){
  803378:	e9 13 01 00 00       	jmp    803490 <sget+0x3ae>
						if(lastfreeelement->size <currentfree2->size){
  80337d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803380:	8b 50 04             	mov    0x4(%eax),%edx
  803383:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803386:	8b 40 04             	mov    0x4(%eax),%eax
  803389:	39 c2                	cmp    %eax,%edx
  80338b:	0f 83 f6 00 00 00    	jae    803487 <sget+0x3a5>
							LIST_REMOVE(&u_freelist ,lastfreeelement);
  803391:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803395:	75 17                	jne    8033ae <sget+0x2cc>
  803397:	83 ec 04             	sub    $0x4,%esp
  80339a:	68 af 53 80 00       	push   $0x8053af
  80339f:	68 e8 01 00 00       	push   $0x1e8
  8033a4:	68 40 53 80 00       	push   $0x805340
  8033a9:	e8 10 d6 ff ff       	call   8009be <_panic>
  8033ae:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8033b1:	8b 40 08             	mov    0x8(%eax),%eax
  8033b4:	85 c0                	test   %eax,%eax
  8033b6:	74 11                	je     8033c9 <sget+0x2e7>
  8033b8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8033bb:	8b 40 08             	mov    0x8(%eax),%eax
  8033be:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8033c1:	8b 52 0c             	mov    0xc(%edx),%edx
  8033c4:	89 50 0c             	mov    %edx,0xc(%eax)
  8033c7:	eb 0b                	jmp    8033d4 <sget+0x2f2>
  8033c9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8033cc:	8b 40 0c             	mov    0xc(%eax),%eax
  8033cf:	a3 24 e1 81 00       	mov    %eax,0x81e124
  8033d4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8033d7:	8b 40 0c             	mov    0xc(%eax),%eax
  8033da:	85 c0                	test   %eax,%eax
  8033dc:	74 11                	je     8033ef <sget+0x30d>
  8033de:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8033e1:	8b 40 0c             	mov    0xc(%eax),%eax
  8033e4:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8033e7:	8b 52 08             	mov    0x8(%edx),%edx
  8033ea:	89 50 08             	mov    %edx,0x8(%eax)
  8033ed:	eb 0b                	jmp    8033fa <sget+0x318>
  8033ef:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8033f2:	8b 40 08             	mov    0x8(%eax),%eax
  8033f5:	a3 20 e1 81 00       	mov    %eax,0x81e120
  8033fa:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8033fd:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  803404:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803407:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  80340e:	a1 2c e1 81 00       	mov    0x81e12c,%eax
  803413:	48                   	dec    %eax
  803414:	a3 2c e1 81 00       	mov    %eax,0x81e12c
							LIST_INSERT_BEFORE(&u_freelist ,currentfree2 ,lastfreeelement);
  803419:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80341d:	74 06                	je     803425 <sget+0x343>
  80341f:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803423:	75 17                	jne    80343c <sget+0x35a>
  803425:	83 ec 04             	sub    $0x4,%esp
  803428:	68 d0 53 80 00       	push   $0x8053d0
  80342d:	68 e9 01 00 00       	push   $0x1e9
  803432:	68 40 53 80 00       	push   $0x805340
  803437:	e8 82 d5 ff ff       	call   8009be <_panic>
  80343c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80343f:	8b 50 0c             	mov    0xc(%eax),%edx
  803442:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803445:	89 50 0c             	mov    %edx,0xc(%eax)
  803448:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80344b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80344e:	89 50 08             	mov    %edx,0x8(%eax)
  803451:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803454:	8b 40 0c             	mov    0xc(%eax),%eax
  803457:	85 c0                	test   %eax,%eax
  803459:	74 0e                	je     803469 <sget+0x387>
  80345b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80345e:	8b 40 0c             	mov    0xc(%eax),%eax
  803461:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803464:	89 50 08             	mov    %edx,0x8(%eax)
  803467:	eb 08                	jmp    803471 <sget+0x38f>
  803469:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80346c:	a3 20 e1 81 00       	mov    %eax,0x81e120
  803471:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803474:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803477:	89 50 0c             	mov    %edx,0xc(%eax)
  80347a:	a1 2c e1 81 00       	mov    0x81e12c,%eax
  80347f:	40                   	inc    %eax
  803480:	a3 2c e1 81 00       	mov    %eax,0x81e12c
							break;
  803485:	eb 13                	jmp    80349a <sget+0x3b8>
						}
						currentfree2 = currentfree2->prev_next_info.le_next;
  803487:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80348a:	8b 40 08             	mov    0x8(%eax),%eax
  80348d:	89 45 f0             	mov    %eax,-0x10(%ebp)
					lastfreeelement->startva += size;
					lastfreeelement->size -= size;
					struct UserHeapStruct* currentfree2 = LIST_FIRST(&u_freelist);
					//check order of last element

					while (currentfree2 != NULL){
  803490:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803494:	0f 85 e3 fe ff ff    	jne    80337d <sget+0x29b>
						}
						currentfree2 = currentfree2->prev_next_info.le_next;
					}


					int result = sys_get_shared_object(ownerEnvID ,sharedVarName ,(void*)allocblock->startva);
  80349a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80349d:	8b 00                	mov    (%eax),%eax
  80349f:	83 ec 04             	sub    $0x4,%esp
  8034a2:	50                   	push   %eax
  8034a3:	ff 75 0c             	pushl  0xc(%ebp)
  8034a6:	ff 75 08             	pushl  0x8(%ebp)
  8034a9:	e8 70 04 00 00       	call   80391e <sys_get_shared_object>
  8034ae:	83 c4 10             	add    $0x10,%esp
  8034b1:	89 45 d4             	mov    %eax,-0x2c(%ebp)

					if(result <0){
  8034b4:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8034b8:	79 28                	jns    8034e2 <sget+0x400>
						free_block(allocblock);
  8034ba:	83 ec 0c             	sub    $0xc,%esp
  8034bd:	ff 75 e0             	pushl  -0x20(%ebp)
  8034c0:	e8 b0 0e 00 00       	call   804375 <free_block>
  8034c5:	83 c4 10             	add    $0x10,%esp
						release_uspinlock(&ulock);
  8034c8:	83 ec 0c             	sub    $0xc,%esp
  8034cb:	68 40 e1 81 00       	push   $0x81e140
  8034d0:	e8 c4 12 00 00       	call   804799 <release_uspinlock>
  8034d5:	83 c4 10             	add    $0x10,%esp
						return NULL;
  8034d8:	b8 00 00 00 00       	mov    $0x0,%eax
  8034dd:	e9 bd 01 00 00       	jmp    80369f <sget+0x5bd>
					}
					release_uspinlock(&ulock);
  8034e2:	83 ec 0c             	sub    $0xc,%esp
  8034e5:	68 40 e1 81 00       	push   $0x81e140
  8034ea:	e8 aa 12 00 00       	call   804799 <release_uspinlock>
  8034ef:	83 c4 10             	add    $0x10,%esp
					return (void*)allocblock->startva;
  8034f2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8034f5:	8b 00                	mov    (%eax),%eax
  8034f7:	e9 a3 01 00 00       	jmp    80369f <sget+0x5bd>
					//exact fit
				}else if(size == currentfreeelement->size){
  8034fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034ff:	8b 50 04             	mov    0x4(%eax),%edx
  803502:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803505:	39 c2                	cmp    %eax,%edx
  803507:	0f 85 5c 01 00 00    	jne    803669 <sget+0x587>

					allocblock->startva = currentfreeelement->startva;
  80350d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803510:	8b 10                	mov    (%eax),%edx
  803512:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803515:	89 10                	mov    %edx,(%eax)
					allocblock->size = size;
  803517:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80351a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80351d:	89 50 04             	mov    %edx,0x4(%eax)
					LIST_INSERT_TAIL(&u_allocatedlist ,allocblock);
  803520:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  803524:	75 17                	jne    80353d <sget+0x45b>
  803526:	83 ec 04             	sub    $0x4,%esp
  803529:	68 8c 53 80 00       	push   $0x80538c
  80352e:	68 fe 01 00 00       	push   $0x1fe
  803533:	68 40 53 80 00       	push   $0x805340
  803538:	e8 81 d4 ff ff       	call   8009be <_panic>
  80353d:	8b 15 34 e1 81 00    	mov    0x81e134,%edx
  803543:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803546:	89 50 0c             	mov    %edx,0xc(%eax)
  803549:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80354c:	8b 40 0c             	mov    0xc(%eax),%eax
  80354f:	85 c0                	test   %eax,%eax
  803551:	74 0d                	je     803560 <sget+0x47e>
  803553:	a1 34 e1 81 00       	mov    0x81e134,%eax
  803558:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80355b:	89 50 08             	mov    %edx,0x8(%eax)
  80355e:	eb 08                	jmp    803568 <sget+0x486>
  803560:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803563:	a3 30 e1 81 00       	mov    %eax,0x81e130
  803568:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80356b:	a3 34 e1 81 00       	mov    %eax,0x81e134
  803570:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803573:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  80357a:	a1 3c e1 81 00       	mov    0x81e13c,%eax
  80357f:	40                   	inc    %eax
  803580:	a3 3c e1 81 00       	mov    %eax,0x81e13c
					LIST_REMOVE(&u_freelist ,currentfreeelement);
  803585:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803589:	75 17                	jne    8035a2 <sget+0x4c0>
  80358b:	83 ec 04             	sub    $0x4,%esp
  80358e:	68 af 53 80 00       	push   $0x8053af
  803593:	68 ff 01 00 00       	push   $0x1ff
  803598:	68 40 53 80 00       	push   $0x805340
  80359d:	e8 1c d4 ff ff       	call   8009be <_panic>
  8035a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035a5:	8b 40 08             	mov    0x8(%eax),%eax
  8035a8:	85 c0                	test   %eax,%eax
  8035aa:	74 11                	je     8035bd <sget+0x4db>
  8035ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035af:	8b 40 08             	mov    0x8(%eax),%eax
  8035b2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8035b5:	8b 52 0c             	mov    0xc(%edx),%edx
  8035b8:	89 50 0c             	mov    %edx,0xc(%eax)
  8035bb:	eb 0b                	jmp    8035c8 <sget+0x4e6>
  8035bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035c0:	8b 40 0c             	mov    0xc(%eax),%eax
  8035c3:	a3 24 e1 81 00       	mov    %eax,0x81e124
  8035c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035cb:	8b 40 0c             	mov    0xc(%eax),%eax
  8035ce:	85 c0                	test   %eax,%eax
  8035d0:	74 11                	je     8035e3 <sget+0x501>
  8035d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035d5:	8b 40 0c             	mov    0xc(%eax),%eax
  8035d8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8035db:	8b 52 08             	mov    0x8(%edx),%edx
  8035de:	89 50 08             	mov    %edx,0x8(%eax)
  8035e1:	eb 0b                	jmp    8035ee <sget+0x50c>
  8035e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035e6:	8b 40 08             	mov    0x8(%eax),%eax
  8035e9:	a3 20 e1 81 00       	mov    %eax,0x81e120
  8035ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035f1:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  8035f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035fb:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  803602:	a1 2c e1 81 00       	mov    0x81e12c,%eax
  803607:	48                   	dec    %eax
  803608:	a3 2c e1 81 00       	mov    %eax,0x81e12c

					int result = sys_get_shared_object(ownerEnvID ,sharedVarName ,(void*)allocblock->startva);
  80360d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803610:	8b 00                	mov    (%eax),%eax
  803612:	83 ec 04             	sub    $0x4,%esp
  803615:	50                   	push   %eax
  803616:	ff 75 0c             	pushl  0xc(%ebp)
  803619:	ff 75 08             	pushl  0x8(%ebp)
  80361c:	e8 fd 02 00 00       	call   80391e <sys_get_shared_object>
  803621:	83 c4 10             	add    $0x10,%esp
  803624:	89 45 d8             	mov    %eax,-0x28(%ebp)
					if(result <0){
  803627:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  80362b:	79 25                	jns    803652 <sget+0x570>
						free_block(allocblock);
  80362d:	83 ec 0c             	sub    $0xc,%esp
  803630:	ff 75 e0             	pushl  -0x20(%ebp)
  803633:	e8 3d 0d 00 00       	call   804375 <free_block>
  803638:	83 c4 10             	add    $0x10,%esp
						release_uspinlock(&ulock);
  80363b:	83 ec 0c             	sub    $0xc,%esp
  80363e:	68 40 e1 81 00       	push   $0x81e140
  803643:	e8 51 11 00 00       	call   804799 <release_uspinlock>
  803648:	83 c4 10             	add    $0x10,%esp
						return NULL;
  80364b:	b8 00 00 00 00       	mov    $0x0,%eax
  803650:	eb 4d                	jmp    80369f <sget+0x5bd>
					}

					release_uspinlock(&ulock);
  803652:	83 ec 0c             	sub    $0xc,%esp
  803655:	68 40 e1 81 00       	push   $0x81e140
  80365a:	e8 3a 11 00 00       	call   804799 <release_uspinlock>
  80365f:	83 c4 10             	add    $0x10,%esp
					return (void*)allocblock->startva;
  803662:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803665:	8b 00                	mov    (%eax),%eax
  803667:	eb 36                	jmp    80369f <sget+0x5bd>
				}
				currentfreeelement = currentfreeelement->prev_next_info.le_next;
  803669:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80366c:	8b 40 08             	mov    0x8(%eax),%eax
  80366f:	89 45 f4             	mov    %eax,-0xc(%ebp)
					 }
		}else{
			//custom fit
			struct UserHeapStruct* currentfreeelement = LIST_FIRST(&u_freelist);
			//worst fit
			while(currentfreeelement != NULL){
  803672:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803676:	0f 85 4b fc ff ff    	jne    8032c7 <sget+0x1e5>
					return (void*)allocblock->startva;
				}
				currentfreeelement = currentfreeelement->prev_next_info.le_next;
			}
		}
		free_block(allocblock);
  80367c:	83 ec 0c             	sub    $0xc,%esp
  80367f:	ff 75 e0             	pushl  -0x20(%ebp)
  803682:	e8 ee 0c 00 00       	call   804375 <free_block>
  803687:	83 c4 10             	add    $0x10,%esp
		release_uspinlock(&ulock);
  80368a:	83 ec 0c             	sub    $0xc,%esp
  80368d:	68 40 e1 81 00       	push   $0x81e140
  803692:	e8 02 11 00 00       	call   804799 <release_uspinlock>
  803697:	83 c4 10             	add    $0x10,%esp
		return NULL;
  80369a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80369f:	c9                   	leave  
  8036a0:	c3                   	ret    

008036a1 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  8036a1:	55                   	push   %ebp
  8036a2:	89 e5                	mov    %esp,%ebp
  8036a4:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  8036a7:	e8 cd e6 ff ff       	call   801d79 <uheap_init>
	//==============================================================
	panic("realloc() is not implemented yet...!!");
  8036ac:	83 ec 04             	sub    $0x4,%esp
  8036af:	68 60 54 80 00       	push   $0x805460
  8036b4:	68 2d 02 00 00       	push   $0x22d
  8036b9:	68 40 53 80 00       	push   $0x805340
  8036be:	e8 fb d2 ff ff       	call   8009be <_panic>

008036c3 <sfree>:
//
//	use sys_delete_shared_object(...); which switches to the kernel mode,
//	calls delete_shared_object(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the delete_shared_object() function is empty, make sure to implement it.
void sfree(void* virtual_address)
{
  8036c3:	55                   	push   %ebp
  8036c4:	89 e5                	mov    %esp,%ebp
  8036c6:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.BONUS#5] EXIT #2 - sfree
	//Your code is here
	//Comment the following line
	panic("sfree() is not implemented yet...!!");
  8036c9:	83 ec 04             	sub    $0x4,%esp
  8036cc:	68 88 54 80 00       	push   $0x805488
  8036d1:	68 40 02 00 00       	push   $0x240
  8036d6:	68 40 53 80 00       	push   $0x805340
  8036db:	e8 de d2 ff ff       	call   8009be <_panic>

008036e0 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8036e0:	55                   	push   %ebp
  8036e1:	89 e5                	mov    %esp,%ebp
  8036e3:	57                   	push   %edi
  8036e4:	56                   	push   %esi
  8036e5:	53                   	push   %ebx
  8036e6:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8036e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8036ec:	8b 55 0c             	mov    0xc(%ebp),%edx
  8036ef:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8036f2:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8036f5:	8b 7d 18             	mov    0x18(%ebp),%edi
  8036f8:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8036fb:	cd 30                	int    $0x30
  8036fd:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  803700:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  803703:	83 c4 10             	add    $0x10,%esp
  803706:	5b                   	pop    %ebx
  803707:	5e                   	pop    %esi
  803708:	5f                   	pop    %edi
  803709:	5d                   	pop    %ebp
  80370a:	c3                   	ret    

0080370b <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  80370b:	55                   	push   %ebp
  80370c:	89 e5                	mov    %esp,%ebp
  80370e:	83 ec 04             	sub    $0x4,%esp
  803711:	8b 45 10             	mov    0x10(%ebp),%eax
  803714:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  803717:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80371a:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80371e:	8b 45 08             	mov    0x8(%ebp),%eax
  803721:	6a 00                	push   $0x0
  803723:	51                   	push   %ecx
  803724:	52                   	push   %edx
  803725:	ff 75 0c             	pushl  0xc(%ebp)
  803728:	50                   	push   %eax
  803729:	6a 00                	push   $0x0
  80372b:	e8 b0 ff ff ff       	call   8036e0 <syscall>
  803730:	83 c4 18             	add    $0x18,%esp
}
  803733:	90                   	nop
  803734:	c9                   	leave  
  803735:	c3                   	ret    

00803736 <sys_cgetc>:

int
sys_cgetc(void)
{
  803736:	55                   	push   %ebp
  803737:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  803739:	6a 00                	push   $0x0
  80373b:	6a 00                	push   $0x0
  80373d:	6a 00                	push   $0x0
  80373f:	6a 00                	push   $0x0
  803741:	6a 00                	push   $0x0
  803743:	6a 02                	push   $0x2
  803745:	e8 96 ff ff ff       	call   8036e0 <syscall>
  80374a:	83 c4 18             	add    $0x18,%esp
}
  80374d:	c9                   	leave  
  80374e:	c3                   	ret    

0080374f <sys_lock_cons>:

void sys_lock_cons(void)
{
  80374f:	55                   	push   %ebp
  803750:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  803752:	6a 00                	push   $0x0
  803754:	6a 00                	push   $0x0
  803756:	6a 00                	push   $0x0
  803758:	6a 00                	push   $0x0
  80375a:	6a 00                	push   $0x0
  80375c:	6a 03                	push   $0x3
  80375e:	e8 7d ff ff ff       	call   8036e0 <syscall>
  803763:	83 c4 18             	add    $0x18,%esp
}
  803766:	90                   	nop
  803767:	c9                   	leave  
  803768:	c3                   	ret    

00803769 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  803769:	55                   	push   %ebp
  80376a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  80376c:	6a 00                	push   $0x0
  80376e:	6a 00                	push   $0x0
  803770:	6a 00                	push   $0x0
  803772:	6a 00                	push   $0x0
  803774:	6a 00                	push   $0x0
  803776:	6a 04                	push   $0x4
  803778:	e8 63 ff ff ff       	call   8036e0 <syscall>
  80377d:	83 c4 18             	add    $0x18,%esp
}
  803780:	90                   	nop
  803781:	c9                   	leave  
  803782:	c3                   	ret    

00803783 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  803783:	55                   	push   %ebp
  803784:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  803786:	8b 55 0c             	mov    0xc(%ebp),%edx
  803789:	8b 45 08             	mov    0x8(%ebp),%eax
  80378c:	6a 00                	push   $0x0
  80378e:	6a 00                	push   $0x0
  803790:	6a 00                	push   $0x0
  803792:	52                   	push   %edx
  803793:	50                   	push   %eax
  803794:	6a 08                	push   $0x8
  803796:	e8 45 ff ff ff       	call   8036e0 <syscall>
  80379b:	83 c4 18             	add    $0x18,%esp
}
  80379e:	c9                   	leave  
  80379f:	c3                   	ret    

008037a0 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8037a0:	55                   	push   %ebp
  8037a1:	89 e5                	mov    %esp,%ebp
  8037a3:	56                   	push   %esi
  8037a4:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8037a5:	8b 75 18             	mov    0x18(%ebp),%esi
  8037a8:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8037ab:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8037ae:	8b 55 0c             	mov    0xc(%ebp),%edx
  8037b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8037b4:	56                   	push   %esi
  8037b5:	53                   	push   %ebx
  8037b6:	51                   	push   %ecx
  8037b7:	52                   	push   %edx
  8037b8:	50                   	push   %eax
  8037b9:	6a 09                	push   $0x9
  8037bb:	e8 20 ff ff ff       	call   8036e0 <syscall>
  8037c0:	83 c4 18             	add    $0x18,%esp
}
  8037c3:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8037c6:	5b                   	pop    %ebx
  8037c7:	5e                   	pop    %esi
  8037c8:	5d                   	pop    %ebp
  8037c9:	c3                   	ret    

008037ca <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  8037ca:	55                   	push   %ebp
  8037cb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  8037cd:	6a 00                	push   $0x0
  8037cf:	6a 00                	push   $0x0
  8037d1:	6a 00                	push   $0x0
  8037d3:	6a 00                	push   $0x0
  8037d5:	ff 75 08             	pushl  0x8(%ebp)
  8037d8:	6a 0a                	push   $0xa
  8037da:	e8 01 ff ff ff       	call   8036e0 <syscall>
  8037df:	83 c4 18             	add    $0x18,%esp
}
  8037e2:	c9                   	leave  
  8037e3:	c3                   	ret    

008037e4 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8037e4:	55                   	push   %ebp
  8037e5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8037e7:	6a 00                	push   $0x0
  8037e9:	6a 00                	push   $0x0
  8037eb:	6a 00                	push   $0x0
  8037ed:	ff 75 0c             	pushl  0xc(%ebp)
  8037f0:	ff 75 08             	pushl  0x8(%ebp)
  8037f3:	6a 0b                	push   $0xb
  8037f5:	e8 e6 fe ff ff       	call   8036e0 <syscall>
  8037fa:	83 c4 18             	add    $0x18,%esp
}
  8037fd:	c9                   	leave  
  8037fe:	c3                   	ret    

008037ff <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8037ff:	55                   	push   %ebp
  803800:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  803802:	6a 00                	push   $0x0
  803804:	6a 00                	push   $0x0
  803806:	6a 00                	push   $0x0
  803808:	6a 00                	push   $0x0
  80380a:	6a 00                	push   $0x0
  80380c:	6a 0c                	push   $0xc
  80380e:	e8 cd fe ff ff       	call   8036e0 <syscall>
  803813:	83 c4 18             	add    $0x18,%esp
}
  803816:	c9                   	leave  
  803817:	c3                   	ret    

00803818 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  803818:	55                   	push   %ebp
  803819:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  80381b:	6a 00                	push   $0x0
  80381d:	6a 00                	push   $0x0
  80381f:	6a 00                	push   $0x0
  803821:	6a 00                	push   $0x0
  803823:	6a 00                	push   $0x0
  803825:	6a 0d                	push   $0xd
  803827:	e8 b4 fe ff ff       	call   8036e0 <syscall>
  80382c:	83 c4 18             	add    $0x18,%esp
}
  80382f:	c9                   	leave  
  803830:	c3                   	ret    

00803831 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  803831:	55                   	push   %ebp
  803832:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  803834:	6a 00                	push   $0x0
  803836:	6a 00                	push   $0x0
  803838:	6a 00                	push   $0x0
  80383a:	6a 00                	push   $0x0
  80383c:	6a 00                	push   $0x0
  80383e:	6a 0e                	push   $0xe
  803840:	e8 9b fe ff ff       	call   8036e0 <syscall>
  803845:	83 c4 18             	add    $0x18,%esp
}
  803848:	c9                   	leave  
  803849:	c3                   	ret    

0080384a <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  80384a:	55                   	push   %ebp
  80384b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  80384d:	6a 00                	push   $0x0
  80384f:	6a 00                	push   $0x0
  803851:	6a 00                	push   $0x0
  803853:	6a 00                	push   $0x0
  803855:	6a 00                	push   $0x0
  803857:	6a 0f                	push   $0xf
  803859:	e8 82 fe ff ff       	call   8036e0 <syscall>
  80385e:	83 c4 18             	add    $0x18,%esp
}
  803861:	c9                   	leave  
  803862:	c3                   	ret    

00803863 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  803863:	55                   	push   %ebp
  803864:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  803866:	6a 00                	push   $0x0
  803868:	6a 00                	push   $0x0
  80386a:	6a 00                	push   $0x0
  80386c:	6a 00                	push   $0x0
  80386e:	ff 75 08             	pushl  0x8(%ebp)
  803871:	6a 10                	push   $0x10
  803873:	e8 68 fe ff ff       	call   8036e0 <syscall>
  803878:	83 c4 18             	add    $0x18,%esp
}
  80387b:	c9                   	leave  
  80387c:	c3                   	ret    

0080387d <sys_scarce_memory>:

void sys_scarce_memory()
{
  80387d:	55                   	push   %ebp
  80387e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  803880:	6a 00                	push   $0x0
  803882:	6a 00                	push   $0x0
  803884:	6a 00                	push   $0x0
  803886:	6a 00                	push   $0x0
  803888:	6a 00                	push   $0x0
  80388a:	6a 11                	push   $0x11
  80388c:	e8 4f fe ff ff       	call   8036e0 <syscall>
  803891:	83 c4 18             	add    $0x18,%esp
}
  803894:	90                   	nop
  803895:	c9                   	leave  
  803896:	c3                   	ret    

00803897 <sys_cputc>:

void
sys_cputc(const char c)
{
  803897:	55                   	push   %ebp
  803898:	89 e5                	mov    %esp,%ebp
  80389a:	83 ec 04             	sub    $0x4,%esp
  80389d:	8b 45 08             	mov    0x8(%ebp),%eax
  8038a0:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8038a3:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8038a7:	6a 00                	push   $0x0
  8038a9:	6a 00                	push   $0x0
  8038ab:	6a 00                	push   $0x0
  8038ad:	6a 00                	push   $0x0
  8038af:	50                   	push   %eax
  8038b0:	6a 01                	push   $0x1
  8038b2:	e8 29 fe ff ff       	call   8036e0 <syscall>
  8038b7:	83 c4 18             	add    $0x18,%esp
}
  8038ba:	90                   	nop
  8038bb:	c9                   	leave  
  8038bc:	c3                   	ret    

008038bd <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8038bd:	55                   	push   %ebp
  8038be:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8038c0:	6a 00                	push   $0x0
  8038c2:	6a 00                	push   $0x0
  8038c4:	6a 00                	push   $0x0
  8038c6:	6a 00                	push   $0x0
  8038c8:	6a 00                	push   $0x0
  8038ca:	6a 14                	push   $0x14
  8038cc:	e8 0f fe ff ff       	call   8036e0 <syscall>
  8038d1:	83 c4 18             	add    $0x18,%esp
}
  8038d4:	90                   	nop
  8038d5:	c9                   	leave  
  8038d6:	c3                   	ret    

008038d7 <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8038d7:	55                   	push   %ebp
  8038d8:	89 e5                	mov    %esp,%ebp
  8038da:	83 ec 04             	sub    $0x4,%esp
  8038dd:	8b 45 10             	mov    0x10(%ebp),%eax
  8038e0:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8038e3:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8038e6:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8038ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8038ed:	6a 00                	push   $0x0
  8038ef:	51                   	push   %ecx
  8038f0:	52                   	push   %edx
  8038f1:	ff 75 0c             	pushl  0xc(%ebp)
  8038f4:	50                   	push   %eax
  8038f5:	6a 15                	push   $0x15
  8038f7:	e8 e4 fd ff ff       	call   8036e0 <syscall>
  8038fc:	83 c4 18             	add    $0x18,%esp
}
  8038ff:	c9                   	leave  
  803900:	c3                   	ret    

00803901 <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  803901:	55                   	push   %ebp
  803902:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  803904:	8b 55 0c             	mov    0xc(%ebp),%edx
  803907:	8b 45 08             	mov    0x8(%ebp),%eax
  80390a:	6a 00                	push   $0x0
  80390c:	6a 00                	push   $0x0
  80390e:	6a 00                	push   $0x0
  803910:	52                   	push   %edx
  803911:	50                   	push   %eax
  803912:	6a 16                	push   $0x16
  803914:	e8 c7 fd ff ff       	call   8036e0 <syscall>
  803919:	83 c4 18             	add    $0x18,%esp
}
  80391c:	c9                   	leave  
  80391d:	c3                   	ret    

0080391e <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  80391e:	55                   	push   %ebp
  80391f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  803921:	8b 4d 10             	mov    0x10(%ebp),%ecx
  803924:	8b 55 0c             	mov    0xc(%ebp),%edx
  803927:	8b 45 08             	mov    0x8(%ebp),%eax
  80392a:	6a 00                	push   $0x0
  80392c:	6a 00                	push   $0x0
  80392e:	51                   	push   %ecx
  80392f:	52                   	push   %edx
  803930:	50                   	push   %eax
  803931:	6a 17                	push   $0x17
  803933:	e8 a8 fd ff ff       	call   8036e0 <syscall>
  803938:	83 c4 18             	add    $0x18,%esp
}
  80393b:	c9                   	leave  
  80393c:	c3                   	ret    

0080393d <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  80393d:	55                   	push   %ebp
  80393e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  803940:	8b 55 0c             	mov    0xc(%ebp),%edx
  803943:	8b 45 08             	mov    0x8(%ebp),%eax
  803946:	6a 00                	push   $0x0
  803948:	6a 00                	push   $0x0
  80394a:	6a 00                	push   $0x0
  80394c:	52                   	push   %edx
  80394d:	50                   	push   %eax
  80394e:	6a 18                	push   $0x18
  803950:	e8 8b fd ff ff       	call   8036e0 <syscall>
  803955:	83 c4 18             	add    $0x18,%esp
}
  803958:	c9                   	leave  
  803959:	c3                   	ret    

0080395a <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  80395a:	55                   	push   %ebp
  80395b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  80395d:	8b 45 08             	mov    0x8(%ebp),%eax
  803960:	6a 00                	push   $0x0
  803962:	ff 75 14             	pushl  0x14(%ebp)
  803965:	ff 75 10             	pushl  0x10(%ebp)
  803968:	ff 75 0c             	pushl  0xc(%ebp)
  80396b:	50                   	push   %eax
  80396c:	6a 19                	push   $0x19
  80396e:	e8 6d fd ff ff       	call   8036e0 <syscall>
  803973:	83 c4 18             	add    $0x18,%esp
}
  803976:	c9                   	leave  
  803977:	c3                   	ret    

00803978 <sys_run_env>:

void sys_run_env(int32 envId)
{
  803978:	55                   	push   %ebp
  803979:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  80397b:	8b 45 08             	mov    0x8(%ebp),%eax
  80397e:	6a 00                	push   $0x0
  803980:	6a 00                	push   $0x0
  803982:	6a 00                	push   $0x0
  803984:	6a 00                	push   $0x0
  803986:	50                   	push   %eax
  803987:	6a 1a                	push   $0x1a
  803989:	e8 52 fd ff ff       	call   8036e0 <syscall>
  80398e:	83 c4 18             	add    $0x18,%esp
}
  803991:	90                   	nop
  803992:	c9                   	leave  
  803993:	c3                   	ret    

00803994 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  803994:	55                   	push   %ebp
  803995:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  803997:	8b 45 08             	mov    0x8(%ebp),%eax
  80399a:	6a 00                	push   $0x0
  80399c:	6a 00                	push   $0x0
  80399e:	6a 00                	push   $0x0
  8039a0:	6a 00                	push   $0x0
  8039a2:	50                   	push   %eax
  8039a3:	6a 1b                	push   $0x1b
  8039a5:	e8 36 fd ff ff       	call   8036e0 <syscall>
  8039aa:	83 c4 18             	add    $0x18,%esp
}
  8039ad:	c9                   	leave  
  8039ae:	c3                   	ret    

008039af <sys_getenvid>:

int32 sys_getenvid(void)
{
  8039af:	55                   	push   %ebp
  8039b0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8039b2:	6a 00                	push   $0x0
  8039b4:	6a 00                	push   $0x0
  8039b6:	6a 00                	push   $0x0
  8039b8:	6a 00                	push   $0x0
  8039ba:	6a 00                	push   $0x0
  8039bc:	6a 05                	push   $0x5
  8039be:	e8 1d fd ff ff       	call   8036e0 <syscall>
  8039c3:	83 c4 18             	add    $0x18,%esp
}
  8039c6:	c9                   	leave  
  8039c7:	c3                   	ret    

008039c8 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8039c8:	55                   	push   %ebp
  8039c9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8039cb:	6a 00                	push   $0x0
  8039cd:	6a 00                	push   $0x0
  8039cf:	6a 00                	push   $0x0
  8039d1:	6a 00                	push   $0x0
  8039d3:	6a 00                	push   $0x0
  8039d5:	6a 06                	push   $0x6
  8039d7:	e8 04 fd ff ff       	call   8036e0 <syscall>
  8039dc:	83 c4 18             	add    $0x18,%esp
}
  8039df:	c9                   	leave  
  8039e0:	c3                   	ret    

008039e1 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8039e1:	55                   	push   %ebp
  8039e2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8039e4:	6a 00                	push   $0x0
  8039e6:	6a 00                	push   $0x0
  8039e8:	6a 00                	push   $0x0
  8039ea:	6a 00                	push   $0x0
  8039ec:	6a 00                	push   $0x0
  8039ee:	6a 07                	push   $0x7
  8039f0:	e8 eb fc ff ff       	call   8036e0 <syscall>
  8039f5:	83 c4 18             	add    $0x18,%esp
}
  8039f8:	c9                   	leave  
  8039f9:	c3                   	ret    

008039fa <sys_exit_env>:


void sys_exit_env(void)
{
  8039fa:	55                   	push   %ebp
  8039fb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  8039fd:	6a 00                	push   $0x0
  8039ff:	6a 00                	push   $0x0
  803a01:	6a 00                	push   $0x0
  803a03:	6a 00                	push   $0x0
  803a05:	6a 00                	push   $0x0
  803a07:	6a 1c                	push   $0x1c
  803a09:	e8 d2 fc ff ff       	call   8036e0 <syscall>
  803a0e:	83 c4 18             	add    $0x18,%esp
}
  803a11:	90                   	nop
  803a12:	c9                   	leave  
  803a13:	c3                   	ret    

00803a14 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  803a14:	55                   	push   %ebp
  803a15:	89 e5                	mov    %esp,%ebp
  803a17:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  803a1a:	8d 45 f8             	lea    -0x8(%ebp),%eax
  803a1d:	8d 50 04             	lea    0x4(%eax),%edx
  803a20:	8d 45 f8             	lea    -0x8(%ebp),%eax
  803a23:	6a 00                	push   $0x0
  803a25:	6a 00                	push   $0x0
  803a27:	6a 00                	push   $0x0
  803a29:	52                   	push   %edx
  803a2a:	50                   	push   %eax
  803a2b:	6a 1d                	push   $0x1d
  803a2d:	e8 ae fc ff ff       	call   8036e0 <syscall>
  803a32:	83 c4 18             	add    $0x18,%esp
	return result;
  803a35:	8b 4d 08             	mov    0x8(%ebp),%ecx
  803a38:	8b 45 f8             	mov    -0x8(%ebp),%eax
  803a3b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  803a3e:	89 01                	mov    %eax,(%ecx)
  803a40:	89 51 04             	mov    %edx,0x4(%ecx)
}
  803a43:	8b 45 08             	mov    0x8(%ebp),%eax
  803a46:	c9                   	leave  
  803a47:	c2 04 00             	ret    $0x4

00803a4a <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  803a4a:	55                   	push   %ebp
  803a4b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  803a4d:	6a 00                	push   $0x0
  803a4f:	6a 00                	push   $0x0
  803a51:	ff 75 10             	pushl  0x10(%ebp)
  803a54:	ff 75 0c             	pushl  0xc(%ebp)
  803a57:	ff 75 08             	pushl  0x8(%ebp)
  803a5a:	6a 13                	push   $0x13
  803a5c:	e8 7f fc ff ff       	call   8036e0 <syscall>
  803a61:	83 c4 18             	add    $0x18,%esp
	return ;
  803a64:	90                   	nop
}
  803a65:	c9                   	leave  
  803a66:	c3                   	ret    

00803a67 <sys_rcr2>:
uint32 sys_rcr2()
{
  803a67:	55                   	push   %ebp
  803a68:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  803a6a:	6a 00                	push   $0x0
  803a6c:	6a 00                	push   $0x0
  803a6e:	6a 00                	push   $0x0
  803a70:	6a 00                	push   $0x0
  803a72:	6a 00                	push   $0x0
  803a74:	6a 1e                	push   $0x1e
  803a76:	e8 65 fc ff ff       	call   8036e0 <syscall>
  803a7b:	83 c4 18             	add    $0x18,%esp
}
  803a7e:	c9                   	leave  
  803a7f:	c3                   	ret    

00803a80 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  803a80:	55                   	push   %ebp
  803a81:	89 e5                	mov    %esp,%ebp
  803a83:	83 ec 04             	sub    $0x4,%esp
  803a86:	8b 45 08             	mov    0x8(%ebp),%eax
  803a89:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  803a8c:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  803a90:	6a 00                	push   $0x0
  803a92:	6a 00                	push   $0x0
  803a94:	6a 00                	push   $0x0
  803a96:	6a 00                	push   $0x0
  803a98:	50                   	push   %eax
  803a99:	6a 1f                	push   $0x1f
  803a9b:	e8 40 fc ff ff       	call   8036e0 <syscall>
  803aa0:	83 c4 18             	add    $0x18,%esp
	return ;
  803aa3:	90                   	nop
}
  803aa4:	c9                   	leave  
  803aa5:	c3                   	ret    

00803aa6 <rsttst>:
void rsttst()
{
  803aa6:	55                   	push   %ebp
  803aa7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  803aa9:	6a 00                	push   $0x0
  803aab:	6a 00                	push   $0x0
  803aad:	6a 00                	push   $0x0
  803aaf:	6a 00                	push   $0x0
  803ab1:	6a 00                	push   $0x0
  803ab3:	6a 21                	push   $0x21
  803ab5:	e8 26 fc ff ff       	call   8036e0 <syscall>
  803aba:	83 c4 18             	add    $0x18,%esp
	return ;
  803abd:	90                   	nop
}
  803abe:	c9                   	leave  
  803abf:	c3                   	ret    

00803ac0 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  803ac0:	55                   	push   %ebp
  803ac1:	89 e5                	mov    %esp,%ebp
  803ac3:	83 ec 04             	sub    $0x4,%esp
  803ac6:	8b 45 14             	mov    0x14(%ebp),%eax
  803ac9:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  803acc:	8b 55 18             	mov    0x18(%ebp),%edx
  803acf:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  803ad3:	52                   	push   %edx
  803ad4:	50                   	push   %eax
  803ad5:	ff 75 10             	pushl  0x10(%ebp)
  803ad8:	ff 75 0c             	pushl  0xc(%ebp)
  803adb:	ff 75 08             	pushl  0x8(%ebp)
  803ade:	6a 20                	push   $0x20
  803ae0:	e8 fb fb ff ff       	call   8036e0 <syscall>
  803ae5:	83 c4 18             	add    $0x18,%esp
	return ;
  803ae8:	90                   	nop
}
  803ae9:	c9                   	leave  
  803aea:	c3                   	ret    

00803aeb <chktst>:
void chktst(uint32 n)
{
  803aeb:	55                   	push   %ebp
  803aec:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  803aee:	6a 00                	push   $0x0
  803af0:	6a 00                	push   $0x0
  803af2:	6a 00                	push   $0x0
  803af4:	6a 00                	push   $0x0
  803af6:	ff 75 08             	pushl  0x8(%ebp)
  803af9:	6a 22                	push   $0x22
  803afb:	e8 e0 fb ff ff       	call   8036e0 <syscall>
  803b00:	83 c4 18             	add    $0x18,%esp
	return ;
  803b03:	90                   	nop
}
  803b04:	c9                   	leave  
  803b05:	c3                   	ret    

00803b06 <inctst>:

void inctst()
{
  803b06:	55                   	push   %ebp
  803b07:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  803b09:	6a 00                	push   $0x0
  803b0b:	6a 00                	push   $0x0
  803b0d:	6a 00                	push   $0x0
  803b0f:	6a 00                	push   $0x0
  803b11:	6a 00                	push   $0x0
  803b13:	6a 23                	push   $0x23
  803b15:	e8 c6 fb ff ff       	call   8036e0 <syscall>
  803b1a:	83 c4 18             	add    $0x18,%esp
	return ;
  803b1d:	90                   	nop
}
  803b1e:	c9                   	leave  
  803b1f:	c3                   	ret    

00803b20 <gettst>:
uint32 gettst()
{
  803b20:	55                   	push   %ebp
  803b21:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  803b23:	6a 00                	push   $0x0
  803b25:	6a 00                	push   $0x0
  803b27:	6a 00                	push   $0x0
  803b29:	6a 00                	push   $0x0
  803b2b:	6a 00                	push   $0x0
  803b2d:	6a 24                	push   $0x24
  803b2f:	e8 ac fb ff ff       	call   8036e0 <syscall>
  803b34:	83 c4 18             	add    $0x18,%esp
}
  803b37:	c9                   	leave  
  803b38:	c3                   	ret    

00803b39 <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  803b39:	55                   	push   %ebp
  803b3a:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  803b3c:	6a 00                	push   $0x0
  803b3e:	6a 00                	push   $0x0
  803b40:	6a 00                	push   $0x0
  803b42:	6a 00                	push   $0x0
  803b44:	6a 00                	push   $0x0
  803b46:	6a 25                	push   $0x25
  803b48:	e8 93 fb ff ff       	call   8036e0 <syscall>
  803b4d:	83 c4 18             	add    $0x18,%esp
  803b50:	a3 60 e0 81 00       	mov    %eax,0x81e060
	return uheapPlaceStrategy ;
  803b55:	a1 60 e0 81 00       	mov    0x81e060,%eax
}
  803b5a:	c9                   	leave  
  803b5b:	c3                   	ret    

00803b5c <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  803b5c:	55                   	push   %ebp
  803b5d:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  803b5f:	8b 45 08             	mov    0x8(%ebp),%eax
  803b62:	a3 60 e0 81 00       	mov    %eax,0x81e060
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  803b67:	6a 00                	push   $0x0
  803b69:	6a 00                	push   $0x0
  803b6b:	6a 00                	push   $0x0
  803b6d:	6a 00                	push   $0x0
  803b6f:	ff 75 08             	pushl  0x8(%ebp)
  803b72:	6a 26                	push   $0x26
  803b74:	e8 67 fb ff ff       	call   8036e0 <syscall>
  803b79:	83 c4 18             	add    $0x18,%esp
	return ;
  803b7c:	90                   	nop
}
  803b7d:	c9                   	leave  
  803b7e:	c3                   	ret    

00803b7f <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  803b7f:	55                   	push   %ebp
  803b80:	89 e5                	mov    %esp,%ebp
  803b82:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  803b83:	8b 5d 14             	mov    0x14(%ebp),%ebx
  803b86:	8b 4d 10             	mov    0x10(%ebp),%ecx
  803b89:	8b 55 0c             	mov    0xc(%ebp),%edx
  803b8c:	8b 45 08             	mov    0x8(%ebp),%eax
  803b8f:	6a 00                	push   $0x0
  803b91:	53                   	push   %ebx
  803b92:	51                   	push   %ecx
  803b93:	52                   	push   %edx
  803b94:	50                   	push   %eax
  803b95:	6a 27                	push   $0x27
  803b97:	e8 44 fb ff ff       	call   8036e0 <syscall>
  803b9c:	83 c4 18             	add    $0x18,%esp
}
  803b9f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  803ba2:	c9                   	leave  
  803ba3:	c3                   	ret    

00803ba4 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  803ba4:	55                   	push   %ebp
  803ba5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  803ba7:	8b 55 0c             	mov    0xc(%ebp),%edx
  803baa:	8b 45 08             	mov    0x8(%ebp),%eax
  803bad:	6a 00                	push   $0x0
  803baf:	6a 00                	push   $0x0
  803bb1:	6a 00                	push   $0x0
  803bb3:	52                   	push   %edx
  803bb4:	50                   	push   %eax
  803bb5:	6a 28                	push   $0x28
  803bb7:	e8 24 fb ff ff       	call   8036e0 <syscall>
  803bbc:	83 c4 18             	add    $0x18,%esp
}
  803bbf:	c9                   	leave  
  803bc0:	c3                   	ret    

00803bc1 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  803bc1:	55                   	push   %ebp
  803bc2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  803bc4:	8b 4d 14             	mov    0x14(%ebp),%ecx
  803bc7:	8b 55 0c             	mov    0xc(%ebp),%edx
  803bca:	8b 45 08             	mov    0x8(%ebp),%eax
  803bcd:	6a 00                	push   $0x0
  803bcf:	51                   	push   %ecx
  803bd0:	ff 75 10             	pushl  0x10(%ebp)
  803bd3:	52                   	push   %edx
  803bd4:	50                   	push   %eax
  803bd5:	6a 29                	push   $0x29
  803bd7:	e8 04 fb ff ff       	call   8036e0 <syscall>
  803bdc:	83 c4 18             	add    $0x18,%esp
}
  803bdf:	c9                   	leave  
  803be0:	c3                   	ret    

00803be1 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  803be1:	55                   	push   %ebp
  803be2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  803be4:	6a 00                	push   $0x0
  803be6:	6a 00                	push   $0x0
  803be8:	ff 75 10             	pushl  0x10(%ebp)
  803beb:	ff 75 0c             	pushl  0xc(%ebp)
  803bee:	ff 75 08             	pushl  0x8(%ebp)
  803bf1:	6a 12                	push   $0x12
  803bf3:	e8 e8 fa ff ff       	call   8036e0 <syscall>
  803bf8:	83 c4 18             	add    $0x18,%esp
	return ;
  803bfb:	90                   	nop
}
  803bfc:	c9                   	leave  
  803bfd:	c3                   	ret    

00803bfe <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  803bfe:	55                   	push   %ebp
  803bff:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  803c01:	8b 55 0c             	mov    0xc(%ebp),%edx
  803c04:	8b 45 08             	mov    0x8(%ebp),%eax
  803c07:	6a 00                	push   $0x0
  803c09:	6a 00                	push   $0x0
  803c0b:	6a 00                	push   $0x0
  803c0d:	52                   	push   %edx
  803c0e:	50                   	push   %eax
  803c0f:	6a 2a                	push   $0x2a
  803c11:	e8 ca fa ff ff       	call   8036e0 <syscall>
  803c16:	83 c4 18             	add    $0x18,%esp
	return;
  803c19:	90                   	nop
}
  803c1a:	c9                   	leave  
  803c1b:	c3                   	ret    

00803c1c <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  803c1c:	55                   	push   %ebp
  803c1d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  803c1f:	6a 00                	push   $0x0
  803c21:	6a 00                	push   $0x0
  803c23:	6a 00                	push   $0x0
  803c25:	6a 00                	push   $0x0
  803c27:	6a 00                	push   $0x0
  803c29:	6a 2b                	push   $0x2b
  803c2b:	e8 b0 fa ff ff       	call   8036e0 <syscall>
  803c30:	83 c4 18             	add    $0x18,%esp
}
  803c33:	c9                   	leave  
  803c34:	c3                   	ret    

00803c35 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  803c35:	55                   	push   %ebp
  803c36:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  803c38:	6a 00                	push   $0x0
  803c3a:	6a 00                	push   $0x0
  803c3c:	6a 00                	push   $0x0
  803c3e:	ff 75 0c             	pushl  0xc(%ebp)
  803c41:	ff 75 08             	pushl  0x8(%ebp)
  803c44:	6a 2d                	push   $0x2d
  803c46:	e8 95 fa ff ff       	call   8036e0 <syscall>
  803c4b:	83 c4 18             	add    $0x18,%esp
	return;
  803c4e:	90                   	nop
}
  803c4f:	c9                   	leave  
  803c50:	c3                   	ret    

00803c51 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  803c51:	55                   	push   %ebp
  803c52:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  803c54:	6a 00                	push   $0x0
  803c56:	6a 00                	push   $0x0
  803c58:	6a 00                	push   $0x0
  803c5a:	ff 75 0c             	pushl  0xc(%ebp)
  803c5d:	ff 75 08             	pushl  0x8(%ebp)
  803c60:	6a 2c                	push   $0x2c
  803c62:	e8 79 fa ff ff       	call   8036e0 <syscall>
  803c67:	83 c4 18             	add    $0x18,%esp
	return ;
  803c6a:	90                   	nop
}
  803c6b:	c9                   	leave  
  803c6c:	c3                   	ret    

00803c6d <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  803c6d:	55                   	push   %ebp
  803c6e:	89 e5                	mov    %esp,%ebp
	//TODO: [PROJECT'25.IM#4] CPU SCHEDULING - #1 System Calls - Add suitable code here
	//Your code is here
	//Comment the following line
	//panic("sys_env_set_priority() is not implemented yet...!!");
	syscall(SYS_env_set_priority, envID, priority, 0, 0, 0);
  803c70:	8b 55 0c             	mov    0xc(%ebp),%edx
  803c73:	8b 45 08             	mov    0x8(%ebp),%eax
  803c76:	6a 00                	push   $0x0
  803c78:	6a 00                	push   $0x0
  803c7a:	6a 00                	push   $0x0
  803c7c:	52                   	push   %edx
  803c7d:	50                   	push   %eax
  803c7e:	6a 2e                	push   $0x2e
  803c80:	e8 5b fa ff ff       	call   8036e0 <syscall>
  803c85:	83 c4 18             	add    $0x18,%esp
	    return;
  803c88:	90                   	nop
}
  803c89:	c9                   	leave  
  803c8a:	c3                   	ret    

00803c8b <to_page_va>:
//==================================================================================//
//==================================
// [1] GET PAGE VA:
//==================================
__inline__ uint32 to_page_va(struct PageInfoElement *ptrPageInfo)
{
  803c8b:	55                   	push   %ebp
  803c8c:	89 e5                	mov    %esp,%ebp
  803c8e:	83 ec 10             	sub    $0x10,%esp
	//Get start VA of the page from the corresponding Page Info pointer
	int idxInPageInfoArr = (ptrPageInfo - pageBlockInfoArr);
  803c91:	8b 45 08             	mov    0x8(%ebp),%eax
  803c94:	ba 60 60 80 00       	mov    $0x806060,%edx
  803c99:	29 d0                	sub    %edx,%eax
  803c9b:	c1 f8 02             	sar    $0x2,%eax
  803c9e:	89 c2                	mov    %eax,%edx
  803ca0:	89 d0                	mov    %edx,%eax
  803ca2:	c1 e0 02             	shl    $0x2,%eax
  803ca5:	01 d0                	add    %edx,%eax
  803ca7:	c1 e0 02             	shl    $0x2,%eax
  803caa:	01 d0                	add    %edx,%eax
  803cac:	c1 e0 02             	shl    $0x2,%eax
  803caf:	01 d0                	add    %edx,%eax
  803cb1:	89 c1                	mov    %eax,%ecx
  803cb3:	c1 e1 08             	shl    $0x8,%ecx
  803cb6:	01 c8                	add    %ecx,%eax
  803cb8:	89 c1                	mov    %eax,%ecx
  803cba:	c1 e1 10             	shl    $0x10,%ecx
  803cbd:	01 c8                	add    %ecx,%eax
  803cbf:	01 c0                	add    %eax,%eax
  803cc1:	01 d0                	add    %edx,%eax
  803cc3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return dynAllocStart + (idxInPageInfoArr << PGSHIFT);
  803cc6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  803cc9:	c1 e0 0c             	shl    $0xc,%eax
  803ccc:	89 c2                	mov    %eax,%edx
  803cce:	a1 64 e0 81 00       	mov    0x81e064,%eax
  803cd3:	01 d0                	add    %edx,%eax
}
  803cd5:	c9                   	leave  
  803cd6:	c3                   	ret    

00803cd7 <log2>:

//==================================================================================//
//============================ REQUIRED FUNCTIONS ==================================//
//==================================================================================//
__inline__ int log2(uint32 n)
	{
  803cd7:	55                   	push   %ebp
  803cd8:	89 e5                	mov    %esp,%ebp
  803cda:	83 ec 10             	sub    $0x10,%esp
		int result = 0;
  803cdd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
		while( n > 1){
  803ce4:	eb 06                	jmp    803cec <log2+0x15>
			n >>=1;
  803ce6:	d1 6d 08             	shrl   0x8(%ebp)
			result++;
  803ce9:	ff 45 fc             	incl   -0x4(%ebp)
//============================ REQUIRED FUNCTIONS ==================================//
//==================================================================================//
__inline__ int log2(uint32 n)
	{
		int result = 0;
		while( n > 1){
  803cec:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
  803cf0:	77 f4                	ja     803ce6 <log2+0xf>
			n >>=1;
			result++;
		}
		return result;
  803cf2:	8b 45 fc             	mov    -0x4(%ebp),%eax
	}
  803cf5:	c9                   	leave  
  803cf6:	c3                   	ret    

00803cf7 <initialize_dynamic_allocator>:
//==================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================
bool is_initialized = 0;
void initialize_dynamic_allocator(uint32 daStart, uint32 daEnd)
{
  803cf7:	55                   	push   %ebp
  803cf8:	89 e5                	mov    %esp,%ebp
  803cfa:	83 ec 18             	sub    $0x18,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(daEnd <= daStart + DYN_ALLOC_MAX_SIZE);
  803cfd:	8b 45 08             	mov    0x8(%ebp),%eax
  803d00:	05 00 00 00 02       	add    $0x2000000,%eax
  803d05:	3b 45 0c             	cmp    0xc(%ebp),%eax
  803d08:	73 16                	jae    803d20 <initialize_dynamic_allocator+0x29>
  803d0a:	68 ac 54 80 00       	push   $0x8054ac
  803d0f:	68 d2 54 80 00       	push   $0x8054d2
  803d14:	6a 2d                	push   $0x2d
  803d16:	68 e7 54 80 00       	push   $0x8054e7
  803d1b:	e8 9e cc ff ff       	call   8009be <_panic>
		is_initialized = 1;
  803d20:	c7 05 28 60 80 00 01 	movl   $0x1,0x806028
  803d27:	00 00 00 
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #1 initialize_dynamic_allocator
	//Your code is here


	dynAllocStart = daStart;
  803d2a:	8b 45 08             	mov    0x8(%ebp),%eax
  803d2d:	a3 64 e0 81 00       	mov    %eax,0x81e064
	dynAllocEnd= daEnd;
  803d32:	8b 45 0c             	mov    0xc(%ebp),%eax
  803d35:	a3 40 60 80 00       	mov    %eax,0x806040
	int numOfPages = (dynAllocEnd - dynAllocStart)/PAGE_SIZE;
  803d3a:	8b 15 40 60 80 00    	mov    0x806040,%edx
  803d40:	a1 64 e0 81 00       	mov    0x81e064,%eax
  803d45:	29 c2                	sub    %eax,%edx
  803d47:	89 d0                	mov    %edx,%eax
  803d49:	c1 e8 0c             	shr    $0xc,%eax
  803d4c:	89 45 e8             	mov    %eax,-0x18(%ebp)


	for(int i=0; i< numOfPages; i++){
  803d4f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  803d56:	eb 2f                	jmp    803d87 <initialize_dynamic_allocator+0x90>
	    pageBlockInfoArr[i].block_size=0;
  803d58:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803d5b:	89 d0                	mov    %edx,%eax
  803d5d:	01 c0                	add    %eax,%eax
  803d5f:	01 d0                	add    %edx,%eax
  803d61:	c1 e0 02             	shl    $0x2,%eax
  803d64:	05 68 60 80 00       	add    $0x806068,%eax
  803d69:	66 c7 00 00 00       	movw   $0x0,(%eax)
	    pageBlockInfoArr[i].num_of_free_blocks=0;
  803d6e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803d71:	89 d0                	mov    %edx,%eax
  803d73:	01 c0                	add    %eax,%eax
  803d75:	01 d0                	add    %edx,%eax
  803d77:	c1 e0 02             	shl    $0x2,%eax
  803d7a:	05 6a 60 80 00       	add    $0x80606a,%eax
  803d7f:	66 c7 00 00 00       	movw   $0x0,(%eax)
	dynAllocStart = daStart;
	dynAllocEnd= daEnd;
	int numOfPages = (dynAllocEnd - dynAllocStart)/PAGE_SIZE;


	for(int i=0; i< numOfPages; i++){
  803d84:	ff 45 f4             	incl   -0xc(%ebp)
  803d87:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d8a:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803d8d:	7c c9                	jl     803d58 <initialize_dynamic_allocator+0x61>
	    pageBlockInfoArr[i].block_size=0;
	    pageBlockInfoArr[i].num_of_free_blocks=0;
	}


	LIST_INIT(&freePagesList);
  803d8f:	c7 05 48 60 80 00 00 	movl   $0x0,0x806048
  803d96:	00 00 00 
  803d99:	c7 05 4c 60 80 00 00 	movl   $0x0,0x80604c
  803da0:	00 00 00 
  803da3:	c7 05 54 60 80 00 00 	movl   $0x0,0x806054
  803daa:	00 00 00 
	for(int i=0; i<numOfPages; i++){
  803dad:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  803db4:	e9 9c 00 00 00       	jmp    803e55 <initialize_dynamic_allocator+0x15e>
		LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
  803db9:	8b 15 4c 60 80 00    	mov    0x80604c,%edx
  803dbf:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  803dc2:	89 c8                	mov    %ecx,%eax
  803dc4:	01 c0                	add    %eax,%eax
  803dc6:	01 c8                	add    %ecx,%eax
  803dc8:	c1 e0 02             	shl    $0x2,%eax
  803dcb:	05 64 60 80 00       	add    $0x806064,%eax
  803dd0:	89 10                	mov    %edx,(%eax)
  803dd2:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803dd5:	89 d0                	mov    %edx,%eax
  803dd7:	01 c0                	add    %eax,%eax
  803dd9:	01 d0                	add    %edx,%eax
  803ddb:	c1 e0 02             	shl    $0x2,%eax
  803dde:	05 64 60 80 00       	add    $0x806064,%eax
  803de3:	8b 00                	mov    (%eax),%eax
  803de5:	85 c0                	test   %eax,%eax
  803de7:	74 1b                	je     803e04 <initialize_dynamic_allocator+0x10d>
  803de9:	8b 15 4c 60 80 00    	mov    0x80604c,%edx
  803def:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  803df2:	89 c8                	mov    %ecx,%eax
  803df4:	01 c0                	add    %eax,%eax
  803df6:	01 c8                	add    %ecx,%eax
  803df8:	c1 e0 02             	shl    $0x2,%eax
  803dfb:	05 60 60 80 00       	add    $0x806060,%eax
  803e00:	89 02                	mov    %eax,(%edx)
  803e02:	eb 16                	jmp    803e1a <initialize_dynamic_allocator+0x123>
  803e04:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803e07:	89 d0                	mov    %edx,%eax
  803e09:	01 c0                	add    %eax,%eax
  803e0b:	01 d0                	add    %edx,%eax
  803e0d:	c1 e0 02             	shl    $0x2,%eax
  803e10:	05 60 60 80 00       	add    $0x806060,%eax
  803e15:	a3 48 60 80 00       	mov    %eax,0x806048
  803e1a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803e1d:	89 d0                	mov    %edx,%eax
  803e1f:	01 c0                	add    %eax,%eax
  803e21:	01 d0                	add    %edx,%eax
  803e23:	c1 e0 02             	shl    $0x2,%eax
  803e26:	05 60 60 80 00       	add    $0x806060,%eax
  803e2b:	a3 4c 60 80 00       	mov    %eax,0x80604c
  803e30:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803e33:	89 d0                	mov    %edx,%eax
  803e35:	01 c0                	add    %eax,%eax
  803e37:	01 d0                	add    %edx,%eax
  803e39:	c1 e0 02             	shl    $0x2,%eax
  803e3c:	05 60 60 80 00       	add    $0x806060,%eax
  803e41:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803e47:	a1 54 60 80 00       	mov    0x806054,%eax
  803e4c:	40                   	inc    %eax
  803e4d:	a3 54 60 80 00       	mov    %eax,0x806054
	    pageBlockInfoArr[i].num_of_free_blocks=0;
	}


	LIST_INIT(&freePagesList);
	for(int i=0; i<numOfPages; i++){
  803e52:	ff 45 f0             	incl   -0x10(%ebp)
  803e55:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803e58:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803e5b:	0f 8c 58 ff ff ff    	jl     803db9 <initialize_dynamic_allocator+0xc2>
		LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
	}



	for (int i = 0; i < LOG2_MAX_SIZE - LOG2_MIN_SIZE + 1; i++) {
  803e61:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  803e68:	eb 36                	jmp    803ea0 <initialize_dynamic_allocator+0x1a9>
	    LIST_INIT(&freeBlockLists[i]);
  803e6a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803e6d:	c1 e0 04             	shl    $0x4,%eax
  803e70:	05 80 e0 81 00       	add    $0x81e080,%eax
  803e75:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803e7b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803e7e:	c1 e0 04             	shl    $0x4,%eax
  803e81:	05 84 e0 81 00       	add    $0x81e084,%eax
  803e86:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803e8c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803e8f:	c1 e0 04             	shl    $0x4,%eax
  803e92:	05 8c e0 81 00       	add    $0x81e08c,%eax
  803e97:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
	}



	for (int i = 0; i < LOG2_MAX_SIZE - LOG2_MIN_SIZE + 1; i++) {
  803e9d:	ff 45 ec             	incl   -0x14(%ebp)
  803ea0:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  803ea4:	7e c4                	jle    803e6a <initialize_dynamic_allocator+0x173>


	//Comment the following line
	//panic("initialize_dynamic_allocator() Not implemented yet");

}
  803ea6:	90                   	nop
  803ea7:	c9                   	leave  
  803ea8:	c3                   	ret    

00803ea9 <get_block_size>:
// [2] GET BLOCK SIZE:
//===========================


__inline__ uint32 get_block_size(void *va)
{
  803ea9:	55                   	push   %ebp
  803eaa:	89 e5                	mov    %esp,%ebp
  803eac:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #2 get_block_size
	//Your code is here

	uint32 page_index = ((uint32)va - dynAllocStart)/ PAGE_SIZE;
  803eaf:	8b 55 08             	mov    0x8(%ebp),%edx
  803eb2:	a1 64 e0 81 00       	mov    0x81e064,%eax
  803eb7:	29 c2                	sub    %eax,%edx
  803eb9:	89 d0                	mov    %edx,%eax
  803ebb:	c1 e8 0c             	shr    $0xc,%eax
  803ebe:	89 45 fc             	mov    %eax,-0x4(%ebp)
    return pageBlockInfoArr[page_index].block_size;
  803ec1:	8b 55 fc             	mov    -0x4(%ebp),%edx
  803ec4:	89 d0                	mov    %edx,%eax
  803ec6:	01 c0                	add    %eax,%eax
  803ec8:	01 d0                	add    %edx,%eax
  803eca:	c1 e0 02             	shl    $0x2,%eax
  803ecd:	05 68 60 80 00       	add    $0x806068,%eax
  803ed2:	8b 00                	mov    (%eax),%eax
  803ed4:	0f b7 c0             	movzwl %ax,%eax
	//Comment the following line
	//panic("get_block_size() Not implemented yet");
}
  803ed7:	c9                   	leave  
  803ed8:	c3                   	ret    

00803ed9 <alloc_block>:

//===========================
// 3) ALLOCATE BLOCK:
//===========================
void *alloc_block(uint32 size)
{
  803ed9:	55                   	push   %ebp
  803eda:	89 e5                	mov    %esp,%ebp
  803edc:	83 ec 48             	sub    $0x48,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(size <= DYN_ALLOC_MAX_BLOCK_SIZE);
  803edf:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  803ee6:	76 16                	jbe    803efe <alloc_block+0x25>
  803ee8:	68 00 55 80 00       	push   $0x805500
  803eed:	68 d2 54 80 00       	push   $0x8054d2
  803ef2:	6a 6c                	push   $0x6c
  803ef4:	68 e7 54 80 00       	push   $0x8054e7
  803ef9:	e8 c0 ca ff ff       	call   8009be <_panic>
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #3 alloc_block
	//Your code is here


	if(size == 0){
  803efe:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803f02:	75 0a                	jne    803f0e <alloc_block+0x35>
		return NULL;
  803f04:	b8 00 00 00 00       	mov    $0x0,%eax
  803f09:	e9 65 04 00 00       	jmp    804373 <alloc_block+0x49a>
	}
	else if(size<=8){
  803f0e:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  803f12:	77 09                	ja     803f1d <alloc_block+0x44>
		size=8;
  803f14:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
  803f1b:	eb 1f                	jmp    803f3c <alloc_block+0x63>
	}
	else{
		uint32 reqsize=8;
  803f1d:	c7 45 f4 08 00 00 00 	movl   $0x8,-0xc(%ebp)
		while(reqsize < size){
  803f24:	eb 08                	jmp    803f2e <alloc_block+0x55>
			reqsize*=2;
  803f26:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803f29:	01 c0                	add    %eax,%eax
  803f2b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	else if(size<=8){
		size=8;
	}
	else{
		uint32 reqsize=8;
		while(reqsize < size){
  803f2e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803f31:	3b 45 08             	cmp    0x8(%ebp),%eax
  803f34:	72 f0                	jb     803f26 <alloc_block+0x4d>
			reqsize*=2;
		}
		size= reqsize;
  803f36:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803f39:	89 45 08             	mov    %eax,0x8(%ebp)
	}

	int list_index = log2(size)- LOG2_MIN_SIZE;
  803f3c:	83 ec 0c             	sub    $0xc,%esp
  803f3f:	ff 75 08             	pushl  0x8(%ebp)
  803f42:	e8 90 fd ff ff       	call   803cd7 <log2>
  803f47:	83 c4 10             	add    $0x10,%esp
  803f4a:	83 e8 03             	sub    $0x3,%eax
  803f4d:	89 45 e8             	mov    %eax,-0x18(%ebp)

	if(!LIST_EMPTY(&freeBlockLists[list_index])){
  803f50:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803f53:	c1 e0 04             	shl    $0x4,%eax
  803f56:	05 80 e0 81 00       	add    $0x81e080,%eax
  803f5b:	8b 00                	mov    (%eax),%eax
  803f5d:	85 c0                	test   %eax,%eax
  803f5f:	0f 84 fb 00 00 00    	je     804060 <alloc_block+0x187>
		struct BlockElement *block = LIST_FIRST(&freeBlockLists[list_index]);
  803f65:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803f68:	c1 e0 04             	shl    $0x4,%eax
  803f6b:	05 80 e0 81 00       	add    $0x81e080,%eax
  803f70:	8b 00                	mov    (%eax),%eax
  803f72:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		LIST_REMOVE(&freeBlockLists[list_index], block);
  803f75:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803f79:	75 17                	jne    803f92 <alloc_block+0xb9>
  803f7b:	83 ec 04             	sub    $0x4,%esp
  803f7e:	68 21 55 80 00       	push   $0x805521
  803f83:	68 86 00 00 00       	push   $0x86
  803f88:	68 e7 54 80 00       	push   $0x8054e7
  803f8d:	e8 2c ca ff ff       	call   8009be <_panic>
  803f92:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803f95:	8b 00                	mov    (%eax),%eax
  803f97:	85 c0                	test   %eax,%eax
  803f99:	74 10                	je     803fab <alloc_block+0xd2>
  803f9b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803f9e:	8b 00                	mov    (%eax),%eax
  803fa0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803fa3:	8b 52 04             	mov    0x4(%edx),%edx
  803fa6:	89 50 04             	mov    %edx,0x4(%eax)
  803fa9:	eb 14                	jmp    803fbf <alloc_block+0xe6>
  803fab:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803fae:	8b 40 04             	mov    0x4(%eax),%eax
  803fb1:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803fb4:	c1 e2 04             	shl    $0x4,%edx
  803fb7:	81 c2 84 e0 81 00    	add    $0x81e084,%edx
  803fbd:	89 02                	mov    %eax,(%edx)
  803fbf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803fc2:	8b 40 04             	mov    0x4(%eax),%eax
  803fc5:	85 c0                	test   %eax,%eax
  803fc7:	74 0f                	je     803fd8 <alloc_block+0xff>
  803fc9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803fcc:	8b 40 04             	mov    0x4(%eax),%eax
  803fcf:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803fd2:	8b 12                	mov    (%edx),%edx
  803fd4:	89 10                	mov    %edx,(%eax)
  803fd6:	eb 13                	jmp    803feb <alloc_block+0x112>
  803fd8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803fdb:	8b 00                	mov    (%eax),%eax
  803fdd:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803fe0:	c1 e2 04             	shl    $0x4,%edx
  803fe3:	81 c2 80 e0 81 00    	add    $0x81e080,%edx
  803fe9:	89 02                	mov    %eax,(%edx)
  803feb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803fee:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803ff4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803ff7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803ffe:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804001:	c1 e0 04             	shl    $0x4,%eax
  804004:	05 8c e0 81 00       	add    $0x81e08c,%eax
  804009:	8b 00                	mov    (%eax),%eax
  80400b:	8d 50 ff             	lea    -0x1(%eax),%edx
  80400e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804011:	c1 e0 04             	shl    $0x4,%eax
  804014:	05 8c e0 81 00       	add    $0x81e08c,%eax
  804019:	89 10                	mov    %edx,(%eax)
		uint32 page_index = ((uint32)block - dynAllocStart)/ PAGE_SIZE;
  80401b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80401e:	a1 64 e0 81 00       	mov    0x81e064,%eax
  804023:	29 c2                	sub    %eax,%edx
  804025:	89 d0                	mov    %edx,%eax
  804027:	c1 e8 0c             	shr    $0xc,%eax
  80402a:	89 45 e0             	mov    %eax,-0x20(%ebp)
		pageBlockInfoArr[page_index].num_of_free_blocks--;
  80402d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  804030:	89 d0                	mov    %edx,%eax
  804032:	01 c0                	add    %eax,%eax
  804034:	01 d0                	add    %edx,%eax
  804036:	c1 e0 02             	shl    $0x2,%eax
  804039:	05 6a 60 80 00       	add    $0x80606a,%eax
  80403e:	66 8b 00             	mov    (%eax),%ax
  804041:	8d 50 ff             	lea    -0x1(%eax),%edx
  804044:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  804047:	89 c8                	mov    %ecx,%eax
  804049:	01 c0                	add    %eax,%eax
  80404b:	01 c8                	add    %ecx,%eax
  80404d:	c1 e0 02             	shl    $0x2,%eax
  804050:	05 6a 60 80 00       	add    $0x80606a,%eax
  804055:	66 89 10             	mov    %dx,(%eax)
		return (void*)block;
  804058:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80405b:	e9 13 03 00 00       	jmp    804373 <alloc_block+0x49a>
	}

	if(!LIST_EMPTY(&freePagesList)){
  804060:	a1 48 60 80 00       	mov    0x806048,%eax
  804065:	85 c0                	test   %eax,%eax
  804067:	0f 84 c9 01 00 00    	je     804236 <alloc_block+0x35d>

		struct PageInfoElement *page_info = LIST_FIRST(&freePagesList);
  80406d:	a1 48 60 80 00       	mov    0x806048,%eax
  804072:	89 45 dc             	mov    %eax,-0x24(%ebp)
		LIST_REMOVE(&freePagesList, page_info);
  804075:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  804079:	75 17                	jne    804092 <alloc_block+0x1b9>
  80407b:	83 ec 04             	sub    $0x4,%esp
  80407e:	68 21 55 80 00       	push   $0x805521
  804083:	68 8f 00 00 00       	push   $0x8f
  804088:	68 e7 54 80 00       	push   $0x8054e7
  80408d:	e8 2c c9 ff ff       	call   8009be <_panic>
  804092:	8b 45 dc             	mov    -0x24(%ebp),%eax
  804095:	8b 00                	mov    (%eax),%eax
  804097:	85 c0                	test   %eax,%eax
  804099:	74 10                	je     8040ab <alloc_block+0x1d2>
  80409b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80409e:	8b 00                	mov    (%eax),%eax
  8040a0:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8040a3:	8b 52 04             	mov    0x4(%edx),%edx
  8040a6:	89 50 04             	mov    %edx,0x4(%eax)
  8040a9:	eb 0b                	jmp    8040b6 <alloc_block+0x1dd>
  8040ab:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8040ae:	8b 40 04             	mov    0x4(%eax),%eax
  8040b1:	a3 4c 60 80 00       	mov    %eax,0x80604c
  8040b6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8040b9:	8b 40 04             	mov    0x4(%eax),%eax
  8040bc:	85 c0                	test   %eax,%eax
  8040be:	74 0f                	je     8040cf <alloc_block+0x1f6>
  8040c0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8040c3:	8b 40 04             	mov    0x4(%eax),%eax
  8040c6:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8040c9:	8b 12                	mov    (%edx),%edx
  8040cb:	89 10                	mov    %edx,(%eax)
  8040cd:	eb 0a                	jmp    8040d9 <alloc_block+0x200>
  8040cf:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8040d2:	8b 00                	mov    (%eax),%eax
  8040d4:	a3 48 60 80 00       	mov    %eax,0x806048
  8040d9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8040dc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8040e2:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8040e5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8040ec:	a1 54 60 80 00       	mov    0x806054,%eax
  8040f1:	48                   	dec    %eax
  8040f2:	a3 54 60 80 00       	mov    %eax,0x806054
		uint32 page_va = to_page_va(page_info);
  8040f7:	83 ec 0c             	sub    $0xc,%esp
  8040fa:	ff 75 dc             	pushl  -0x24(%ebp)
  8040fd:	e8 89 fb ff ff       	call   803c8b <to_page_va>
  804102:	83 c4 10             	add    $0x10,%esp
  804105:	89 45 d8             	mov    %eax,-0x28(%ebp)

		uint32 page_index = (page_va - dynAllocStart)/ PAGE_SIZE;
  804108:	a1 64 e0 81 00       	mov    0x81e064,%eax
  80410d:	8b 55 d8             	mov    -0x28(%ebp),%edx
  804110:	29 c2                	sub    %eax,%edx
  804112:	89 d0                	mov    %edx,%eax
  804114:	c1 e8 0c             	shr    $0xc,%eax
  804117:	89 45 d4             	mov    %eax,-0x2c(%ebp)

		get_page((void*)page_va);
  80411a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80411d:	83 ec 0c             	sub    $0xc,%esp
  804120:	50                   	push   %eax
  804121:	e8 fe dc ff ff       	call   801e24 <get_page>
  804126:	83 c4 10             	add    $0x10,%esp


		pageBlockInfoArr[page_index].block_size = size;
  804129:	8b 45 08             	mov    0x8(%ebp),%eax
  80412c:	89 c2                	mov    %eax,%edx
  80412e:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  804131:	89 c8                	mov    %ecx,%eax
  804133:	01 c0                	add    %eax,%eax
  804135:	01 c8                	add    %ecx,%eax
  804137:	c1 e0 02             	shl    $0x2,%eax
  80413a:	05 68 60 80 00       	add    $0x806068,%eax
  80413f:	66 89 10             	mov    %dx,(%eax)
		int num_blocks = PAGE_SIZE / size ;
  804142:	b8 00 10 00 00       	mov    $0x1000,%eax
  804147:	ba 00 00 00 00       	mov    $0x0,%edx
  80414c:	f7 75 08             	divl   0x8(%ebp)
  80414f:	89 45 d0             	mov    %eax,-0x30(%ebp)
		pageBlockInfoArr[page_index].num_of_free_blocks= num_blocks - 1 ;
  804152:	8b 45 d0             	mov    -0x30(%ebp),%eax
  804155:	8d 50 ff             	lea    -0x1(%eax),%edx
  804158:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  80415b:	89 c8                	mov    %ecx,%eax
  80415d:	01 c0                	add    %eax,%eax
  80415f:	01 c8                	add    %ecx,%eax
  804161:	c1 e0 02             	shl    $0x2,%eax
  804164:	05 6a 60 80 00       	add    $0x80606a,%eax
  804169:	66 89 10             	mov    %dx,(%eax)

		for(int i=1; i< num_blocks; i++){
  80416c:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
  804173:	e9 aa 00 00 00       	jmp    804222 <alloc_block+0x349>
			struct BlockElement *new_block = (struct BlockElement*)(page_va + i *size);
  804178:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80417b:	0f af 45 08          	imul   0x8(%ebp),%eax
  80417f:	89 c2                	mov    %eax,%edx
  804181:	8b 45 d8             	mov    -0x28(%ebp),%eax
  804184:	01 d0                	add    %edx,%eax
  804186:	89 45 cc             	mov    %eax,-0x34(%ebp)
			LIST_INSERT_TAIL(&freeBlockLists[list_index], new_block);
  804189:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  80418d:	75 17                	jne    8041a6 <alloc_block+0x2cd>
  80418f:	83 ec 04             	sub    $0x4,%esp
  804192:	68 40 55 80 00       	push   $0x805540
  804197:	68 9d 00 00 00       	push   $0x9d
  80419c:	68 e7 54 80 00       	push   $0x8054e7
  8041a1:	e8 18 c8 ff ff       	call   8009be <_panic>
  8041a6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8041a9:	c1 e0 04             	shl    $0x4,%eax
  8041ac:	05 84 e0 81 00       	add    $0x81e084,%eax
  8041b1:	8b 10                	mov    (%eax),%edx
  8041b3:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8041b6:	89 50 04             	mov    %edx,0x4(%eax)
  8041b9:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8041bc:	8b 40 04             	mov    0x4(%eax),%eax
  8041bf:	85 c0                	test   %eax,%eax
  8041c1:	74 14                	je     8041d7 <alloc_block+0x2fe>
  8041c3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8041c6:	c1 e0 04             	shl    $0x4,%eax
  8041c9:	05 84 e0 81 00       	add    $0x81e084,%eax
  8041ce:	8b 00                	mov    (%eax),%eax
  8041d0:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8041d3:	89 10                	mov    %edx,(%eax)
  8041d5:	eb 11                	jmp    8041e8 <alloc_block+0x30f>
  8041d7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8041da:	c1 e0 04             	shl    $0x4,%eax
  8041dd:	8d 90 80 e0 81 00    	lea    0x81e080(%eax),%edx
  8041e3:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8041e6:	89 02                	mov    %eax,(%edx)
  8041e8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8041eb:	c1 e0 04             	shl    $0x4,%eax
  8041ee:	8d 90 84 e0 81 00    	lea    0x81e084(%eax),%edx
  8041f4:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8041f7:	89 02                	mov    %eax,(%edx)
  8041f9:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8041fc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  804202:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804205:	c1 e0 04             	shl    $0x4,%eax
  804208:	05 8c e0 81 00       	add    $0x81e08c,%eax
  80420d:	8b 00                	mov    (%eax),%eax
  80420f:	8d 50 01             	lea    0x1(%eax),%edx
  804212:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804215:	c1 e0 04             	shl    $0x4,%eax
  804218:	05 8c e0 81 00       	add    $0x81e08c,%eax
  80421d:	89 10                	mov    %edx,(%eax)

		pageBlockInfoArr[page_index].block_size = size;
		int num_blocks = PAGE_SIZE / size ;
		pageBlockInfoArr[page_index].num_of_free_blocks= num_blocks - 1 ;

		for(int i=1; i< num_blocks; i++){
  80421f:	ff 45 f0             	incl   -0x10(%ebp)
  804222:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804225:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  804228:	0f 8c 4a ff ff ff    	jl     804178 <alloc_block+0x29f>
			struct BlockElement *new_block = (struct BlockElement*)(page_va + i *size);
			LIST_INSERT_TAIL(&freeBlockLists[list_index], new_block);
		}
		return(void*)page_va;
  80422e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  804231:	e9 3d 01 00 00       	jmp    804373 <alloc_block+0x49a>
	}


	for(int i =list_index+1; i<= LOG2_MAX_SIZE - LOG2_MIN_SIZE; i++){
  804236:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804239:	40                   	inc    %eax
  80423a:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80423d:	e9 10 01 00 00       	jmp    804352 <alloc_block+0x479>

		if(!LIST_EMPTY(&freeBlockLists[i])){
  804242:	8b 45 ec             	mov    -0x14(%ebp),%eax
  804245:	c1 e0 04             	shl    $0x4,%eax
  804248:	05 80 e0 81 00       	add    $0x81e080,%eax
  80424d:	8b 00                	mov    (%eax),%eax
  80424f:	85 c0                	test   %eax,%eax
  804251:	0f 84 f8 00 00 00    	je     80434f <alloc_block+0x476>

			struct BlockElement *block = LIST_FIRST(&freeBlockLists[i]);
  804257:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80425a:	c1 e0 04             	shl    $0x4,%eax
  80425d:	05 80 e0 81 00       	add    $0x81e080,%eax
  804262:	8b 00                	mov    (%eax),%eax
  804264:	89 45 c8             	mov    %eax,-0x38(%ebp)
			LIST_REMOVE( &freeBlockLists[i], block);
  804267:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  80426b:	75 17                	jne    804284 <alloc_block+0x3ab>
  80426d:	83 ec 04             	sub    $0x4,%esp
  804270:	68 21 55 80 00       	push   $0x805521
  804275:	68 a8 00 00 00       	push   $0xa8
  80427a:	68 e7 54 80 00       	push   $0x8054e7
  80427f:	e8 3a c7 ff ff       	call   8009be <_panic>
  804284:	8b 45 c8             	mov    -0x38(%ebp),%eax
  804287:	8b 00                	mov    (%eax),%eax
  804289:	85 c0                	test   %eax,%eax
  80428b:	74 10                	je     80429d <alloc_block+0x3c4>
  80428d:	8b 45 c8             	mov    -0x38(%ebp),%eax
  804290:	8b 00                	mov    (%eax),%eax
  804292:	8b 55 c8             	mov    -0x38(%ebp),%edx
  804295:	8b 52 04             	mov    0x4(%edx),%edx
  804298:	89 50 04             	mov    %edx,0x4(%eax)
  80429b:	eb 14                	jmp    8042b1 <alloc_block+0x3d8>
  80429d:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8042a0:	8b 40 04             	mov    0x4(%eax),%eax
  8042a3:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8042a6:	c1 e2 04             	shl    $0x4,%edx
  8042a9:	81 c2 84 e0 81 00    	add    $0x81e084,%edx
  8042af:	89 02                	mov    %eax,(%edx)
  8042b1:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8042b4:	8b 40 04             	mov    0x4(%eax),%eax
  8042b7:	85 c0                	test   %eax,%eax
  8042b9:	74 0f                	je     8042ca <alloc_block+0x3f1>
  8042bb:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8042be:	8b 40 04             	mov    0x4(%eax),%eax
  8042c1:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8042c4:	8b 12                	mov    (%edx),%edx
  8042c6:	89 10                	mov    %edx,(%eax)
  8042c8:	eb 13                	jmp    8042dd <alloc_block+0x404>
  8042ca:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8042cd:	8b 00                	mov    (%eax),%eax
  8042cf:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8042d2:	c1 e2 04             	shl    $0x4,%edx
  8042d5:	81 c2 80 e0 81 00    	add    $0x81e080,%edx
  8042db:	89 02                	mov    %eax,(%edx)
  8042dd:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8042e0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8042e6:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8042e9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8042f0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8042f3:	c1 e0 04             	shl    $0x4,%eax
  8042f6:	05 8c e0 81 00       	add    $0x81e08c,%eax
  8042fb:	8b 00                	mov    (%eax),%eax
  8042fd:	8d 50 ff             	lea    -0x1(%eax),%edx
  804300:	8b 45 ec             	mov    -0x14(%ebp),%eax
  804303:	c1 e0 04             	shl    $0x4,%eax
  804306:	05 8c e0 81 00       	add    $0x81e08c,%eax
  80430b:	89 10                	mov    %edx,(%eax)

			uint32 page_index = ((uint32)block - dynAllocStart)/ PAGE_SIZE;
  80430d:	8b 55 c8             	mov    -0x38(%ebp),%edx
  804310:	a1 64 e0 81 00       	mov    0x81e064,%eax
  804315:	29 c2                	sub    %eax,%edx
  804317:	89 d0                	mov    %edx,%eax
  804319:	c1 e8 0c             	shr    $0xc,%eax
  80431c:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			pageBlockInfoArr[page_index].num_of_free_blocks-- ;
  80431f:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  804322:	89 d0                	mov    %edx,%eax
  804324:	01 c0                	add    %eax,%eax
  804326:	01 d0                	add    %edx,%eax
  804328:	c1 e0 02             	shl    $0x2,%eax
  80432b:	05 6a 60 80 00       	add    $0x80606a,%eax
  804330:	66 8b 00             	mov    (%eax),%ax
  804333:	8d 50 ff             	lea    -0x1(%eax),%edx
  804336:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  804339:	89 c8                	mov    %ecx,%eax
  80433b:	01 c0                	add    %eax,%eax
  80433d:	01 c8                	add    %ecx,%eax
  80433f:	c1 e0 02             	shl    $0x2,%eax
  804342:	05 6a 60 80 00       	add    $0x80606a,%eax
  804347:	66 89 10             	mov    %dx,(%eax)

			return (void*)block;
  80434a:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80434d:	eb 24                	jmp    804373 <alloc_block+0x49a>
		}
		return(void*)page_va;
	}


	for(int i =list_index+1; i<= LOG2_MAX_SIZE - LOG2_MIN_SIZE; i++){
  80434f:	ff 45 ec             	incl   -0x14(%ebp)
  804352:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  804356:	0f 8e e6 fe ff ff    	jle    804242 <alloc_block+0x369>

			return (void*)block;
		}
	}

	panic("alloc_block: out of memory! ");
  80435c:	83 ec 04             	sub    $0x4,%esp
  80435f:	68 63 55 80 00       	push   $0x805563
  804364:	68 b1 00 00 00       	push   $0xb1
  804369:	68 e7 54 80 00       	push   $0x8054e7
  80436e:	e8 4b c6 ff ff       	call   8009be <_panic>

	//Comment the following line
	//panic("alloc_block() Not implemented yet");

	//TODO: [PROJECT'25.BONUS#1] DYNAMIC ALLOCATOR - block if no free block
}
  804373:	c9                   	leave  
  804374:	c3                   	ret    

00804375 <free_block>:

//===========================
// [4] FREE BLOCK:
//===========================
void free_block(void *va)
{
  804375:	55                   	push   %ebp
  804376:	89 e5                	mov    %esp,%ebp
  804378:	83 ec 38             	sub    $0x38,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert((uint32)va >= dynAllocStart && (uint32)va < dynAllocEnd);
  80437b:	8b 55 08             	mov    0x8(%ebp),%edx
  80437e:	a1 64 e0 81 00       	mov    0x81e064,%eax
  804383:	39 c2                	cmp    %eax,%edx
  804385:	72 0c                	jb     804393 <free_block+0x1e>
  804387:	8b 55 08             	mov    0x8(%ebp),%edx
  80438a:	a1 40 60 80 00       	mov    0x806040,%eax
  80438f:	39 c2                	cmp    %eax,%edx
  804391:	72 19                	jb     8043ac <free_block+0x37>
  804393:	68 80 55 80 00       	push   $0x805580
  804398:	68 d2 54 80 00       	push   $0x8054d2
  80439d:	68 c3 00 00 00       	push   $0xc3
  8043a2:	68 e7 54 80 00       	push   $0x8054e7
  8043a7:	e8 12 c6 ff ff       	call   8009be <_panic>
	//==================================================================================

	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #4 free_block
	//Your code is here

	uint32 page_index=((uint32)va - dynAllocStart)/ PAGE_SIZE;
  8043ac:	8b 55 08             	mov    0x8(%ebp),%edx
  8043af:	a1 64 e0 81 00       	mov    0x81e064,%eax
  8043b4:	29 c2                	sub    %eax,%edx
  8043b6:	89 d0                	mov    %edx,%eax
  8043b8:	c1 e8 0c             	shr    $0xc,%eax
  8043bb:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 block_size = pageBlockInfoArr[page_index].block_size;
  8043be:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8043c1:	89 d0                	mov    %edx,%eax
  8043c3:	01 c0                	add    %eax,%eax
  8043c5:	01 d0                	add    %edx,%eax
  8043c7:	c1 e0 02             	shl    $0x2,%eax
  8043ca:	05 68 60 80 00       	add    $0x806068,%eax
  8043cf:	8b 00                	mov    (%eax),%eax
  8043d1:	0f b7 c0             	movzwl %ax,%eax
  8043d4:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if(block_size == 0){
  8043d7:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8043db:	75 17                	jne    8043f4 <free_block+0x7f>
		panic("page is empty(already not allocated)");
  8043dd:	83 ec 04             	sub    $0x4,%esp
  8043e0:	68 b8 55 80 00       	push   $0x8055b8
  8043e5:	68 cf 00 00 00       	push   $0xcf
  8043ea:	68 e7 54 80 00       	push   $0x8054e7
  8043ef:	e8 ca c5 ff ff       	call   8009be <_panic>
	}

	int list_index = log2(block_size) - LOG2_MIN_SIZE;
  8043f4:	83 ec 0c             	sub    $0xc,%esp
  8043f7:	ff 75 ec             	pushl  -0x14(%ebp)
  8043fa:	e8 d8 f8 ff ff       	call   803cd7 <log2>
  8043ff:	83 c4 10             	add    $0x10,%esp
  804402:	83 e8 03             	sub    $0x3,%eax
  804405:	89 45 e8             	mov    %eax,-0x18(%ebp)
	// mn va l block "elta7weel mn virtual l phy hna"
	struct BlockElement *block = (struct BlockElement *)va;
  804408:	8b 45 08             	mov    0x8(%ebp),%eax
  80440b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	LIST_INSERT_TAIL(&freeBlockLists[list_index], block);
  80440e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  804412:	75 17                	jne    80442b <free_block+0xb6>
  804414:	83 ec 04             	sub    $0x4,%esp
  804417:	68 40 55 80 00       	push   $0x805540
  80441c:	68 d5 00 00 00       	push   $0xd5
  804421:	68 e7 54 80 00       	push   $0x8054e7
  804426:	e8 93 c5 ff ff       	call   8009be <_panic>
  80442b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80442e:	c1 e0 04             	shl    $0x4,%eax
  804431:	05 84 e0 81 00       	add    $0x81e084,%eax
  804436:	8b 10                	mov    (%eax),%edx
  804438:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80443b:	89 50 04             	mov    %edx,0x4(%eax)
  80443e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804441:	8b 40 04             	mov    0x4(%eax),%eax
  804444:	85 c0                	test   %eax,%eax
  804446:	74 14                	je     80445c <free_block+0xe7>
  804448:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80444b:	c1 e0 04             	shl    $0x4,%eax
  80444e:	05 84 e0 81 00       	add    $0x81e084,%eax
  804453:	8b 00                	mov    (%eax),%eax
  804455:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  804458:	89 10                	mov    %edx,(%eax)
  80445a:	eb 11                	jmp    80446d <free_block+0xf8>
  80445c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80445f:	c1 e0 04             	shl    $0x4,%eax
  804462:	8d 90 80 e0 81 00    	lea    0x81e080(%eax),%edx
  804468:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80446b:	89 02                	mov    %eax,(%edx)
  80446d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804470:	c1 e0 04             	shl    $0x4,%eax
  804473:	8d 90 84 e0 81 00    	lea    0x81e084(%eax),%edx
  804479:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80447c:	89 02                	mov    %eax,(%edx)
  80447e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804481:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  804487:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80448a:	c1 e0 04             	shl    $0x4,%eax
  80448d:	05 8c e0 81 00       	add    $0x81e08c,%eax
  804492:	8b 00                	mov    (%eax),%eax
  804494:	8d 50 01             	lea    0x1(%eax),%edx
  804497:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80449a:	c1 e0 04             	shl    $0x4,%eax
  80449d:	05 8c e0 81 00       	add    $0x81e08c,%eax
  8044a2:	89 10                	mov    %edx,(%eax)
	// b3d ma wdytha fy el freeBlockLists hzwed elfree elly fy el array 1
	pageBlockInfoArr[page_index].num_of_free_blocks++;
  8044a4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8044a7:	89 d0                	mov    %edx,%eax
  8044a9:	01 c0                	add    %eax,%eax
  8044ab:	01 d0                	add    %edx,%eax
  8044ad:	c1 e0 02             	shl    $0x2,%eax
  8044b0:	05 6a 60 80 00       	add    $0x80606a,%eax
  8044b5:	66 8b 00             	mov    (%eax),%ax
  8044b8:	8d 50 01             	lea    0x1(%eax),%edx
  8044bb:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8044be:	89 c8                	mov    %ecx,%eax
  8044c0:	01 c0                	add    %eax,%eax
  8044c2:	01 c8                	add    %ecx,%eax
  8044c4:	c1 e0 02             	shl    $0x2,%eax
  8044c7:	05 6a 60 80 00       	add    $0x80606a,%eax
  8044cc:	66 89 10             	mov    %dx,(%eax)
	int blocks_number = PAGE_SIZE / block_size;
  8044cf:	b8 00 10 00 00       	mov    $0x1000,%eax
  8044d4:	ba 00 00 00 00       	mov    $0x0,%edx
  8044d9:	f7 75 ec             	divl   -0x14(%ebp)
  8044dc:	89 45 e0             	mov    %eax,-0x20(%ebp)
	if(pageBlockInfoArr[page_index].num_of_free_blocks == blocks_number){
  8044df:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8044e2:	89 d0                	mov    %edx,%eax
  8044e4:	01 c0                	add    %eax,%eax
  8044e6:	01 d0                	add    %edx,%eax
  8044e8:	c1 e0 02             	shl    $0x2,%eax
  8044eb:	05 6a 60 80 00       	add    $0x80606a,%eax
  8044f0:	66 8b 00             	mov    (%eax),%ax
  8044f3:	0f b7 c0             	movzwl %ax,%eax
  8044f6:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8044f9:	0f 85 d3 01 00 00    	jne    8046d2 <free_block+0x35d>
		struct BlockElement *itr = LIST_FIRST(&freeBlockLists[list_index]);
  8044ff:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804502:	c1 e0 04             	shl    $0x4,%eax
  804505:	05 80 e0 81 00       	add    $0x81e080,%eax
  80450a:	8b 00                	mov    (%eax),%eax
  80450c:	89 45 f4             	mov    %eax,-0xc(%ebp)
		while(itr != NULL){
  80450f:	e9 f1 00 00 00       	jmp    804605 <free_block+0x290>
			//lw ms7to el pointer mydy34 ->
			struct BlockElement *next = LIST_NEXT(itr);
  804514:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804517:	8b 00                	mov    (%eax),%eax
  804519:	89 45 dc             	mov    %eax,-0x24(%ebp)
			uint32 page_beginning_address= dynAllocStart + page_index * PAGE_SIZE;
  80451c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80451f:	c1 e0 0c             	shl    $0xc,%eax
  804522:	89 c2                	mov    %eax,%edx
  804524:	a1 64 e0 81 00       	mov    0x81e064,%eax
  804529:	01 d0                	add    %edx,%eax
  80452b:	89 45 d8             	mov    %eax,-0x28(%ebp)
			uint32 page_end_address = dynAllocStart + (page_index +1 )* PAGE_SIZE;
  80452e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804531:	40                   	inc    %eax
  804532:	c1 e0 0c             	shl    $0xc,%eax
  804535:	89 c2                	mov    %eax,%edx
  804537:	a1 64 e0 81 00       	mov    0x81e064,%eax
  80453c:	01 d0                	add    %edx,%eax
  80453e:	89 45 d4             	mov    %eax,-0x2c(%ebp)

			if((uint32)itr >= page_beginning_address && (uint32)itr < page_end_address){
  804541:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804544:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  804547:	0f 82 b8 00 00 00    	jb     804605 <free_block+0x290>
  80454d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804550:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  804553:	0f 83 ac 00 00 00    	jae    804605 <free_block+0x290>
				LIST_REMOVE(&freeBlockLists[list_index], itr);
  804559:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80455d:	75 17                	jne    804576 <free_block+0x201>
  80455f:	83 ec 04             	sub    $0x4,%esp
  804562:	68 21 55 80 00       	push   $0x805521
  804567:	68 e2 00 00 00       	push   $0xe2
  80456c:	68 e7 54 80 00       	push   $0x8054e7
  804571:	e8 48 c4 ff ff       	call   8009be <_panic>
  804576:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804579:	8b 00                	mov    (%eax),%eax
  80457b:	85 c0                	test   %eax,%eax
  80457d:	74 10                	je     80458f <free_block+0x21a>
  80457f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804582:	8b 00                	mov    (%eax),%eax
  804584:	8b 55 f4             	mov    -0xc(%ebp),%edx
  804587:	8b 52 04             	mov    0x4(%edx),%edx
  80458a:	89 50 04             	mov    %edx,0x4(%eax)
  80458d:	eb 14                	jmp    8045a3 <free_block+0x22e>
  80458f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804592:	8b 40 04             	mov    0x4(%eax),%eax
  804595:	8b 55 e8             	mov    -0x18(%ebp),%edx
  804598:	c1 e2 04             	shl    $0x4,%edx
  80459b:	81 c2 84 e0 81 00    	add    $0x81e084,%edx
  8045a1:	89 02                	mov    %eax,(%edx)
  8045a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8045a6:	8b 40 04             	mov    0x4(%eax),%eax
  8045a9:	85 c0                	test   %eax,%eax
  8045ab:	74 0f                	je     8045bc <free_block+0x247>
  8045ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8045b0:	8b 40 04             	mov    0x4(%eax),%eax
  8045b3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8045b6:	8b 12                	mov    (%edx),%edx
  8045b8:	89 10                	mov    %edx,(%eax)
  8045ba:	eb 13                	jmp    8045cf <free_block+0x25a>
  8045bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8045bf:	8b 00                	mov    (%eax),%eax
  8045c1:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8045c4:	c1 e2 04             	shl    $0x4,%edx
  8045c7:	81 c2 80 e0 81 00    	add    $0x81e080,%edx
  8045cd:	89 02                	mov    %eax,(%edx)
  8045cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8045d2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8045d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8045db:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8045e2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8045e5:	c1 e0 04             	shl    $0x4,%eax
  8045e8:	05 8c e0 81 00       	add    $0x81e08c,%eax
  8045ed:	8b 00                	mov    (%eax),%eax
  8045ef:	8d 50 ff             	lea    -0x1(%eax),%edx
  8045f2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8045f5:	c1 e0 04             	shl    $0x4,%eax
  8045f8:	05 8c e0 81 00       	add    $0x81e08c,%eax
  8045fd:	89 10                	mov    %edx,(%eax)
				//y5o4 3la elly b3do
				itr = next;
  8045ff:	8b 45 dc             	mov    -0x24(%ebp),%eax
  804602:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// b3d ma wdytha fy el freeBlockLists hzwed elfree elly fy el array 1
	pageBlockInfoArr[page_index].num_of_free_blocks++;
	int blocks_number = PAGE_SIZE / block_size;
	if(pageBlockInfoArr[page_index].num_of_free_blocks == blocks_number){
		struct BlockElement *itr = LIST_FIRST(&freeBlockLists[list_index]);
		while(itr != NULL){
  804605:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  804609:	0f 85 05 ff ff ff    	jne    804514 <free_block+0x19f>
				LIST_REMOVE(&freeBlockLists[list_index], itr);
				//y5o4 3la elly b3do
				itr = next;
			}
		}
		pageBlockInfoArr[page_index].block_size=0;
  80460f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  804612:	89 d0                	mov    %edx,%eax
  804614:	01 c0                	add    %eax,%eax
  804616:	01 d0                	add    %edx,%eax
  804618:	c1 e0 02             	shl    $0x2,%eax
  80461b:	05 68 60 80 00       	add    $0x806068,%eax
  804620:	66 c7 00 00 00       	movw   $0x0,(%eax)
		pageBlockInfoArr[page_index].num_of_free_blocks=0;
  804625:	8b 55 f0             	mov    -0x10(%ebp),%edx
  804628:	89 d0                	mov    %edx,%eax
  80462a:	01 c0                	add    %eax,%eax
  80462c:	01 d0                	add    %edx,%eax
  80462e:	c1 e0 02             	shl    $0x2,%eax
  804631:	05 6a 60 80 00       	add    $0x80606a,%eax
  804636:	66 c7 00 00 00       	movw   $0x0,(%eax)

		struct PageInfoElement *page_info = &pageBlockInfoArr[page_index];
  80463b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80463e:	89 d0                	mov    %edx,%eax
  804640:	01 c0                	add    %eax,%eax
  804642:	01 d0                	add    %edx,%eax
  804644:	c1 e0 02             	shl    $0x2,%eax
  804647:	05 60 60 80 00       	add    $0x806060,%eax
  80464c:	89 45 d0             	mov    %eax,-0x30(%ebp)
		LIST_INSERT_TAIL(&freePagesList, page_info);
  80464f:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  804653:	75 17                	jne    80466c <free_block+0x2f7>
  804655:	83 ec 04             	sub    $0x4,%esp
  804658:	68 40 55 80 00       	push   $0x805540
  80465d:	68 eb 00 00 00       	push   $0xeb
  804662:	68 e7 54 80 00       	push   $0x8054e7
  804667:	e8 52 c3 ff ff       	call   8009be <_panic>
  80466c:	8b 15 4c 60 80 00    	mov    0x80604c,%edx
  804672:	8b 45 d0             	mov    -0x30(%ebp),%eax
  804675:	89 50 04             	mov    %edx,0x4(%eax)
  804678:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80467b:	8b 40 04             	mov    0x4(%eax),%eax
  80467e:	85 c0                	test   %eax,%eax
  804680:	74 0c                	je     80468e <free_block+0x319>
  804682:	a1 4c 60 80 00       	mov    0x80604c,%eax
  804687:	8b 55 d0             	mov    -0x30(%ebp),%edx
  80468a:	89 10                	mov    %edx,(%eax)
  80468c:	eb 08                	jmp    804696 <free_block+0x321>
  80468e:	8b 45 d0             	mov    -0x30(%ebp),%eax
  804691:	a3 48 60 80 00       	mov    %eax,0x806048
  804696:	8b 45 d0             	mov    -0x30(%ebp),%eax
  804699:	a3 4c 60 80 00       	mov    %eax,0x80604c
  80469e:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8046a1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8046a7:	a1 54 60 80 00       	mov    0x806054,%eax
  8046ac:	40                   	inc    %eax
  8046ad:	a3 54 60 80 00       	mov    %eax,0x806054
		uint32 page_va = to_page_va(page_info);
  8046b2:	83 ec 0c             	sub    $0xc,%esp
  8046b5:	ff 75 d0             	pushl  -0x30(%ebp)
  8046b8:	e8 ce f5 ff ff       	call   803c8b <to_page_va>
  8046bd:	83 c4 10             	add    $0x10,%esp
  8046c0:	89 45 cc             	mov    %eax,-0x34(%ebp)
		return_page((void *)page_va);
  8046c3:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8046c6:	83 ec 0c             	sub    $0xc,%esp
  8046c9:	50                   	push   %eax
  8046ca:	e8 9e d7 ff ff       	call   801e6d <return_page>
  8046cf:	83 c4 10             	add    $0x10,%esp
	}


	//Comment the following line
	//panic("free_block() Not implemented yet");
}
  8046d2:	90                   	nop
  8046d3:	c9                   	leave  
  8046d4:	c3                   	ret    

008046d5 <realloc_block>:

//===========================
// [1] REALLOCATE BLOCK:
//===========================
void *realloc_block(void* va, uint32 new_size)
{
  8046d5:	55                   	push   %ebp
  8046d6:	89 e5                	mov    %esp,%ebp
  8046d8:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.BONUS#2] KERNEL REALLOC - realloc_block
	//Your code is here
	//Comment the following line
	panic("realloc_block() Not implemented yet");
  8046db:	83 ec 04             	sub    $0x4,%esp
  8046de:	68 e0 55 80 00       	push   $0x8055e0
  8046e3:	68 01 01 00 00       	push   $0x101
  8046e8:	68 e7 54 80 00       	push   $0x8054e7
  8046ed:	e8 cc c2 ff ff       	call   8009be <_panic>

008046f2 <init_uspinlock>:
#include "inc/uspinlock.h"

extern volatile struct Env *myEnv;

void init_uspinlock(struct uspinlock *lk, char *name, bool isOpened)
{
  8046f2:	55                   	push   %ebp
  8046f3:	89 e5                	mov    %esp,%ebp
  8046f5:	83 ec 08             	sub    $0x8,%esp
	assert(isOpened == 0 || isOpened == 1);
  8046f8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8046fc:	74 1c                	je     80471a <init_uspinlock+0x28>
  8046fe:	83 7d 10 01          	cmpl   $0x1,0x10(%ebp)
  804702:	74 16                	je     80471a <init_uspinlock+0x28>
  804704:	68 04 56 80 00       	push   $0x805604
  804709:	68 23 56 80 00       	push   $0x805623
  80470e:	6a 10                	push   $0x10
  804710:	68 38 56 80 00       	push   $0x805638
  804715:	e8 a4 c2 ff ff       	call   8009be <_panic>
	strcpy(lk->name, name);
  80471a:	8b 45 08             	mov    0x8(%ebp),%eax
  80471d:	83 c0 04             	add    $0x4,%eax
  804720:	83 ec 08             	sub    $0x8,%esp
  804723:	ff 75 0c             	pushl  0xc(%ebp)
  804726:	50                   	push   %eax
  804727:	e8 90 ce ff ff       	call   8015bc <strcpy>
  80472c:	83 c4 10             	add    $0x10,%esp
	lk->locked = (1 - isOpened);
  80472f:	b8 01 00 00 00       	mov    $0x1,%eax
  804734:	2b 45 10             	sub    0x10(%ebp),%eax
  804737:	89 c2                	mov    %eax,%edx
  804739:	8b 45 08             	mov    0x8(%ebp),%eax
  80473c:	89 10                	mov    %edx,(%eax)
}
  80473e:	90                   	nop
  80473f:	c9                   	leave  
  804740:	c3                   	ret    

00804741 <acquire_uspinlock>:
// Acquire the lock.
// Loops (spins) until the lock is acquired.
// Holding a lock for a long time may cause
// other CPUs to waste time spinning to acquire it.
void acquire_uspinlock(struct uspinlock *lk)
{
  804741:	55                   	push   %ebp
  804742:	89 e5                	mov    %esp,%ebp
  804744:	83 ec 18             	sub    $0x18,%esp
	// The xchg is atomic.
	while(xchg(&lk->locked, 1) != 0) ;
  804747:	90                   	nop
  804748:	8b 45 08             	mov    0x8(%ebp),%eax
  80474b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80474e:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
xchg(volatile uint32 *addr, uint32 newval)
{
  uint32 result;

  // The + in "+m" denotes a read-modify-write operand.
  __asm __volatile("lock; xchgl %0, %1" :
  804755:	8b 55 f4             	mov    -0xc(%ebp),%edx
  804758:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80475b:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  80475e:	f0 87 02             	lock xchg %eax,(%edx)
  804761:	89 45 ec             	mov    %eax,-0x14(%ebp)
               "+m" (*addr), "=a" (result) :
               "1" (newval) :
               "cc");
  return result;
  804764:	8b 45 ec             	mov    -0x14(%ebp),%eax
  804767:	85 c0                	test   %eax,%eax
  804769:	75 dd                	jne    804748 <acquire_uspinlock+0x7>

	cprintf("[%d: %s] ACQUIRED spinlock [%s]\n", myEnv->env_id, myEnv->prog_name, lk->name);
  80476b:	8b 45 08             	mov    0x8(%ebp),%eax
  80476e:	8d 48 04             	lea    0x4(%eax),%ecx
  804771:	a1 24 60 80 00       	mov    0x806024,%eax
  804776:	8d 50 20             	lea    0x20(%eax),%edx
  804779:	a1 24 60 80 00       	mov    0x806024,%eax
  80477e:	8b 40 10             	mov    0x10(%eax),%eax
  804781:	51                   	push   %ecx
  804782:	52                   	push   %edx
  804783:	50                   	push   %eax
  804784:	68 48 56 80 00       	push   $0x805648
  804789:	e8 fe c4 ff ff       	call   800c8c <cprintf>
  80478e:	83 c4 10             	add    $0x10,%esp

	// Tell the C compiler and the processor to not move loads or stores
	// past this point, to ensure that the critical section's memory
	// references happen after the lock is acquired.
	__sync_synchronize();
  804791:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
}
  804796:	90                   	nop
  804797:	c9                   	leave  
  804798:	c3                   	ret    

00804799 <release_uspinlock>:

// Release the lock.
void release_uspinlock(struct uspinlock *lk)
{
  804799:	55                   	push   %ebp
  80479a:	89 e5                	mov    %esp,%ebp
  80479c:	83 ec 08             	sub    $0x8,%esp
	if(!(lk->locked))
  80479f:	8b 45 08             	mov    0x8(%ebp),%eax
  8047a2:	8b 00                	mov    (%eax),%eax
  8047a4:	85 c0                	test   %eax,%eax
  8047a6:	75 18                	jne    8047c0 <release_uspinlock+0x27>
	{
		panic("release: lock \"%s\" is not held!", lk->name);
  8047a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8047ab:	83 c0 04             	add    $0x4,%eax
  8047ae:	50                   	push   %eax
  8047af:	68 6c 56 80 00       	push   $0x80566c
  8047b4:	6a 2b                	push   $0x2b
  8047b6:	68 38 56 80 00       	push   $0x805638
  8047bb:	e8 fe c1 ff ff       	call   8009be <_panic>
	// Tell the C compiler and the processor to not move loads or stores
	// past this point, to ensure that all the stores in the critical
	// section are visible to other cores before the lock is released.
	// Both the C compiler and the hardware may re-order loads and
	// stores; __sync_synchronize() tells them both not to.
	__sync_synchronize();
  8047c0:	f0 83 0c 24 00       	lock orl $0x0,(%esp)

	// Release the lock, equivalent to lk->locked = 0.
	// This code can't use a C assignment, since it might
	// not be atomic. A real OS would use C atomics here.
	asm volatile("movl $0, %0" : "+m" (lk->locked) : );
  8047c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8047c8:	8b 55 08             	mov    0x8(%ebp),%edx
  8047cb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	cprintf("[%d: %s] RELEASED spinlock [%s]\n", myEnv->env_id, myEnv->prog_name, lk->name);
  8047d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8047d4:	8d 48 04             	lea    0x4(%eax),%ecx
  8047d7:	a1 24 60 80 00       	mov    0x806024,%eax
  8047dc:	8d 50 20             	lea    0x20(%eax),%edx
  8047df:	a1 24 60 80 00       	mov    0x806024,%eax
  8047e4:	8b 40 10             	mov    0x10(%eax),%eax
  8047e7:	51                   	push   %ecx
  8047e8:	52                   	push   %edx
  8047e9:	50                   	push   %eax
  8047ea:	68 8c 56 80 00       	push   $0x80568c
  8047ef:	e8 98 c4 ff ff       	call   800c8c <cprintf>
  8047f4:	83 c4 10             	add    $0x10,%esp
}
  8047f7:	90                   	nop
  8047f8:	c9                   	leave  
  8047f9:	c3                   	ret    
  8047fa:	66 90                	xchg   %ax,%ax

008047fc <__udivdi3>:
  8047fc:	55                   	push   %ebp
  8047fd:	57                   	push   %edi
  8047fe:	56                   	push   %esi
  8047ff:	53                   	push   %ebx
  804800:	83 ec 1c             	sub    $0x1c,%esp
  804803:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  804807:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80480b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80480f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  804813:	89 ca                	mov    %ecx,%edx
  804815:	89 f8                	mov    %edi,%eax
  804817:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80481b:	85 f6                	test   %esi,%esi
  80481d:	75 2d                	jne    80484c <__udivdi3+0x50>
  80481f:	39 cf                	cmp    %ecx,%edi
  804821:	77 65                	ja     804888 <__udivdi3+0x8c>
  804823:	89 fd                	mov    %edi,%ebp
  804825:	85 ff                	test   %edi,%edi
  804827:	75 0b                	jne    804834 <__udivdi3+0x38>
  804829:	b8 01 00 00 00       	mov    $0x1,%eax
  80482e:	31 d2                	xor    %edx,%edx
  804830:	f7 f7                	div    %edi
  804832:	89 c5                	mov    %eax,%ebp
  804834:	31 d2                	xor    %edx,%edx
  804836:	89 c8                	mov    %ecx,%eax
  804838:	f7 f5                	div    %ebp
  80483a:	89 c1                	mov    %eax,%ecx
  80483c:	89 d8                	mov    %ebx,%eax
  80483e:	f7 f5                	div    %ebp
  804840:	89 cf                	mov    %ecx,%edi
  804842:	89 fa                	mov    %edi,%edx
  804844:	83 c4 1c             	add    $0x1c,%esp
  804847:	5b                   	pop    %ebx
  804848:	5e                   	pop    %esi
  804849:	5f                   	pop    %edi
  80484a:	5d                   	pop    %ebp
  80484b:	c3                   	ret    
  80484c:	39 ce                	cmp    %ecx,%esi
  80484e:	77 28                	ja     804878 <__udivdi3+0x7c>
  804850:	0f bd fe             	bsr    %esi,%edi
  804853:	83 f7 1f             	xor    $0x1f,%edi
  804856:	75 40                	jne    804898 <__udivdi3+0x9c>
  804858:	39 ce                	cmp    %ecx,%esi
  80485a:	72 0a                	jb     804866 <__udivdi3+0x6a>
  80485c:	3b 44 24 08          	cmp    0x8(%esp),%eax
  804860:	0f 87 9e 00 00 00    	ja     804904 <__udivdi3+0x108>
  804866:	b8 01 00 00 00       	mov    $0x1,%eax
  80486b:	89 fa                	mov    %edi,%edx
  80486d:	83 c4 1c             	add    $0x1c,%esp
  804870:	5b                   	pop    %ebx
  804871:	5e                   	pop    %esi
  804872:	5f                   	pop    %edi
  804873:	5d                   	pop    %ebp
  804874:	c3                   	ret    
  804875:	8d 76 00             	lea    0x0(%esi),%esi
  804878:	31 ff                	xor    %edi,%edi
  80487a:	31 c0                	xor    %eax,%eax
  80487c:	89 fa                	mov    %edi,%edx
  80487e:	83 c4 1c             	add    $0x1c,%esp
  804881:	5b                   	pop    %ebx
  804882:	5e                   	pop    %esi
  804883:	5f                   	pop    %edi
  804884:	5d                   	pop    %ebp
  804885:	c3                   	ret    
  804886:	66 90                	xchg   %ax,%ax
  804888:	89 d8                	mov    %ebx,%eax
  80488a:	f7 f7                	div    %edi
  80488c:	31 ff                	xor    %edi,%edi
  80488e:	89 fa                	mov    %edi,%edx
  804890:	83 c4 1c             	add    $0x1c,%esp
  804893:	5b                   	pop    %ebx
  804894:	5e                   	pop    %esi
  804895:	5f                   	pop    %edi
  804896:	5d                   	pop    %ebp
  804897:	c3                   	ret    
  804898:	bd 20 00 00 00       	mov    $0x20,%ebp
  80489d:	89 eb                	mov    %ebp,%ebx
  80489f:	29 fb                	sub    %edi,%ebx
  8048a1:	89 f9                	mov    %edi,%ecx
  8048a3:	d3 e6                	shl    %cl,%esi
  8048a5:	89 c5                	mov    %eax,%ebp
  8048a7:	88 d9                	mov    %bl,%cl
  8048a9:	d3 ed                	shr    %cl,%ebp
  8048ab:	89 e9                	mov    %ebp,%ecx
  8048ad:	09 f1                	or     %esi,%ecx
  8048af:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8048b3:	89 f9                	mov    %edi,%ecx
  8048b5:	d3 e0                	shl    %cl,%eax
  8048b7:	89 c5                	mov    %eax,%ebp
  8048b9:	89 d6                	mov    %edx,%esi
  8048bb:	88 d9                	mov    %bl,%cl
  8048bd:	d3 ee                	shr    %cl,%esi
  8048bf:	89 f9                	mov    %edi,%ecx
  8048c1:	d3 e2                	shl    %cl,%edx
  8048c3:	8b 44 24 08          	mov    0x8(%esp),%eax
  8048c7:	88 d9                	mov    %bl,%cl
  8048c9:	d3 e8                	shr    %cl,%eax
  8048cb:	09 c2                	or     %eax,%edx
  8048cd:	89 d0                	mov    %edx,%eax
  8048cf:	89 f2                	mov    %esi,%edx
  8048d1:	f7 74 24 0c          	divl   0xc(%esp)
  8048d5:	89 d6                	mov    %edx,%esi
  8048d7:	89 c3                	mov    %eax,%ebx
  8048d9:	f7 e5                	mul    %ebp
  8048db:	39 d6                	cmp    %edx,%esi
  8048dd:	72 19                	jb     8048f8 <__udivdi3+0xfc>
  8048df:	74 0b                	je     8048ec <__udivdi3+0xf0>
  8048e1:	89 d8                	mov    %ebx,%eax
  8048e3:	31 ff                	xor    %edi,%edi
  8048e5:	e9 58 ff ff ff       	jmp    804842 <__udivdi3+0x46>
  8048ea:	66 90                	xchg   %ax,%ax
  8048ec:	8b 54 24 08          	mov    0x8(%esp),%edx
  8048f0:	89 f9                	mov    %edi,%ecx
  8048f2:	d3 e2                	shl    %cl,%edx
  8048f4:	39 c2                	cmp    %eax,%edx
  8048f6:	73 e9                	jae    8048e1 <__udivdi3+0xe5>
  8048f8:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8048fb:	31 ff                	xor    %edi,%edi
  8048fd:	e9 40 ff ff ff       	jmp    804842 <__udivdi3+0x46>
  804902:	66 90                	xchg   %ax,%ax
  804904:	31 c0                	xor    %eax,%eax
  804906:	e9 37 ff ff ff       	jmp    804842 <__udivdi3+0x46>
  80490b:	90                   	nop

0080490c <__umoddi3>:
  80490c:	55                   	push   %ebp
  80490d:	57                   	push   %edi
  80490e:	56                   	push   %esi
  80490f:	53                   	push   %ebx
  804910:	83 ec 1c             	sub    $0x1c,%esp
  804913:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  804917:	8b 74 24 34          	mov    0x34(%esp),%esi
  80491b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80491f:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  804923:	89 44 24 0c          	mov    %eax,0xc(%esp)
  804927:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80492b:	89 f3                	mov    %esi,%ebx
  80492d:	89 fa                	mov    %edi,%edx
  80492f:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  804933:	89 34 24             	mov    %esi,(%esp)
  804936:	85 c0                	test   %eax,%eax
  804938:	75 1a                	jne    804954 <__umoddi3+0x48>
  80493a:	39 f7                	cmp    %esi,%edi
  80493c:	0f 86 a2 00 00 00    	jbe    8049e4 <__umoddi3+0xd8>
  804942:	89 c8                	mov    %ecx,%eax
  804944:	89 f2                	mov    %esi,%edx
  804946:	f7 f7                	div    %edi
  804948:	89 d0                	mov    %edx,%eax
  80494a:	31 d2                	xor    %edx,%edx
  80494c:	83 c4 1c             	add    $0x1c,%esp
  80494f:	5b                   	pop    %ebx
  804950:	5e                   	pop    %esi
  804951:	5f                   	pop    %edi
  804952:	5d                   	pop    %ebp
  804953:	c3                   	ret    
  804954:	39 f0                	cmp    %esi,%eax
  804956:	0f 87 ac 00 00 00    	ja     804a08 <__umoddi3+0xfc>
  80495c:	0f bd e8             	bsr    %eax,%ebp
  80495f:	83 f5 1f             	xor    $0x1f,%ebp
  804962:	0f 84 ac 00 00 00    	je     804a14 <__umoddi3+0x108>
  804968:	bf 20 00 00 00       	mov    $0x20,%edi
  80496d:	29 ef                	sub    %ebp,%edi
  80496f:	89 fe                	mov    %edi,%esi
  804971:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  804975:	89 e9                	mov    %ebp,%ecx
  804977:	d3 e0                	shl    %cl,%eax
  804979:	89 d7                	mov    %edx,%edi
  80497b:	89 f1                	mov    %esi,%ecx
  80497d:	d3 ef                	shr    %cl,%edi
  80497f:	09 c7                	or     %eax,%edi
  804981:	89 e9                	mov    %ebp,%ecx
  804983:	d3 e2                	shl    %cl,%edx
  804985:	89 14 24             	mov    %edx,(%esp)
  804988:	89 d8                	mov    %ebx,%eax
  80498a:	d3 e0                	shl    %cl,%eax
  80498c:	89 c2                	mov    %eax,%edx
  80498e:	8b 44 24 08          	mov    0x8(%esp),%eax
  804992:	d3 e0                	shl    %cl,%eax
  804994:	89 44 24 04          	mov    %eax,0x4(%esp)
  804998:	8b 44 24 08          	mov    0x8(%esp),%eax
  80499c:	89 f1                	mov    %esi,%ecx
  80499e:	d3 e8                	shr    %cl,%eax
  8049a0:	09 d0                	or     %edx,%eax
  8049a2:	d3 eb                	shr    %cl,%ebx
  8049a4:	89 da                	mov    %ebx,%edx
  8049a6:	f7 f7                	div    %edi
  8049a8:	89 d3                	mov    %edx,%ebx
  8049aa:	f7 24 24             	mull   (%esp)
  8049ad:	89 c6                	mov    %eax,%esi
  8049af:	89 d1                	mov    %edx,%ecx
  8049b1:	39 d3                	cmp    %edx,%ebx
  8049b3:	0f 82 87 00 00 00    	jb     804a40 <__umoddi3+0x134>
  8049b9:	0f 84 91 00 00 00    	je     804a50 <__umoddi3+0x144>
  8049bf:	8b 54 24 04          	mov    0x4(%esp),%edx
  8049c3:	29 f2                	sub    %esi,%edx
  8049c5:	19 cb                	sbb    %ecx,%ebx
  8049c7:	89 d8                	mov    %ebx,%eax
  8049c9:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8049cd:	d3 e0                	shl    %cl,%eax
  8049cf:	89 e9                	mov    %ebp,%ecx
  8049d1:	d3 ea                	shr    %cl,%edx
  8049d3:	09 d0                	or     %edx,%eax
  8049d5:	89 e9                	mov    %ebp,%ecx
  8049d7:	d3 eb                	shr    %cl,%ebx
  8049d9:	89 da                	mov    %ebx,%edx
  8049db:	83 c4 1c             	add    $0x1c,%esp
  8049de:	5b                   	pop    %ebx
  8049df:	5e                   	pop    %esi
  8049e0:	5f                   	pop    %edi
  8049e1:	5d                   	pop    %ebp
  8049e2:	c3                   	ret    
  8049e3:	90                   	nop
  8049e4:	89 fd                	mov    %edi,%ebp
  8049e6:	85 ff                	test   %edi,%edi
  8049e8:	75 0b                	jne    8049f5 <__umoddi3+0xe9>
  8049ea:	b8 01 00 00 00       	mov    $0x1,%eax
  8049ef:	31 d2                	xor    %edx,%edx
  8049f1:	f7 f7                	div    %edi
  8049f3:	89 c5                	mov    %eax,%ebp
  8049f5:	89 f0                	mov    %esi,%eax
  8049f7:	31 d2                	xor    %edx,%edx
  8049f9:	f7 f5                	div    %ebp
  8049fb:	89 c8                	mov    %ecx,%eax
  8049fd:	f7 f5                	div    %ebp
  8049ff:	89 d0                	mov    %edx,%eax
  804a01:	e9 44 ff ff ff       	jmp    80494a <__umoddi3+0x3e>
  804a06:	66 90                	xchg   %ax,%ax
  804a08:	89 c8                	mov    %ecx,%eax
  804a0a:	89 f2                	mov    %esi,%edx
  804a0c:	83 c4 1c             	add    $0x1c,%esp
  804a0f:	5b                   	pop    %ebx
  804a10:	5e                   	pop    %esi
  804a11:	5f                   	pop    %edi
  804a12:	5d                   	pop    %ebp
  804a13:	c3                   	ret    
  804a14:	3b 04 24             	cmp    (%esp),%eax
  804a17:	72 06                	jb     804a1f <__umoddi3+0x113>
  804a19:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  804a1d:	77 0f                	ja     804a2e <__umoddi3+0x122>
  804a1f:	89 f2                	mov    %esi,%edx
  804a21:	29 f9                	sub    %edi,%ecx
  804a23:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  804a27:	89 14 24             	mov    %edx,(%esp)
  804a2a:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  804a2e:	8b 44 24 04          	mov    0x4(%esp),%eax
  804a32:	8b 14 24             	mov    (%esp),%edx
  804a35:	83 c4 1c             	add    $0x1c,%esp
  804a38:	5b                   	pop    %ebx
  804a39:	5e                   	pop    %esi
  804a3a:	5f                   	pop    %edi
  804a3b:	5d                   	pop    %ebp
  804a3c:	c3                   	ret    
  804a3d:	8d 76 00             	lea    0x0(%esi),%esi
  804a40:	2b 04 24             	sub    (%esp),%eax
  804a43:	19 fa                	sbb    %edi,%edx
  804a45:	89 d1                	mov    %edx,%ecx
  804a47:	89 c6                	mov    %eax,%esi
  804a49:	e9 71 ff ff ff       	jmp    8049bf <__umoddi3+0xb3>
  804a4e:	66 90                	xchg   %ax,%ax
  804a50:	39 44 24 04          	cmp    %eax,0x4(%esp)
  804a54:	72 ea                	jb     804a40 <__umoddi3+0x134>
  804a56:	89 d9                	mov    %ebx,%ecx
  804a58:	e9 62 ff ff ff       	jmp    8049bf <__umoddi3+0xb3>
