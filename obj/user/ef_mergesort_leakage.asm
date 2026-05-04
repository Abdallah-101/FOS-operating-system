
obj/user/ef_mergesort_leakage:     file format elf32-i386


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
  800031:	e8 48 07 00 00       	call   80077e <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
void Merge(int* A, int p, int q, int r);

uint32 CheckSorted(int *Elements, int NumOfElements);

void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	81 ec 28 01 00 00    	sub    $0x128,%esp
	char Line[255] ;
	char Chose ;
	int numOfRep = 0;
  800041:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	do
	{
		numOfRep++ ;
  800048:	ff 45 f0             	incl   -0x10(%ebp)
		//2012: lock the interrupt
		sys_lock_cons();
  80004b:	e8 70 34 00 00       	call   8034c0 <sys_lock_cons>

		cprintf("\n");
  800050:	83 ec 0c             	sub    $0xc,%esp
  800053:	68 e0 47 80 00       	push   $0x8047e0
  800058:	e8 a8 0b 00 00       	call   800c05 <cprintf>
  80005d:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!!!!!!!!!!!!!!!!!!\n");
  800060:	83 ec 0c             	sub    $0xc,%esp
  800063:	68 e2 47 80 00       	push   $0x8047e2
  800068:	e8 98 0b 00 00       	call   800c05 <cprintf>
  80006d:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!! MERGE SORT !!!!\n");
  800070:	83 ec 0c             	sub    $0xc,%esp
  800073:	68 f8 47 80 00       	push   $0x8047f8
  800078:	e8 88 0b 00 00       	call   800c05 <cprintf>
  80007d:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!!!!!!!!!!!!!!!!!!\n");
  800080:	83 ec 0c             	sub    $0xc,%esp
  800083:	68 e2 47 80 00       	push   $0x8047e2
  800088:	e8 78 0b 00 00       	call   800c05 <cprintf>
  80008d:	83 c4 10             	add    $0x10,%esp
		cprintf("\n");
  800090:	83 ec 0c             	sub    $0xc,%esp
  800093:	68 e0 47 80 00       	push   $0x8047e0
  800098:	e8 68 0b 00 00       	call   800c05 <cprintf>
  80009d:	83 c4 10             	add    $0x10,%esp
		cprintf("Enter the number of elements: ");
  8000a0:	83 ec 0c             	sub    $0xc,%esp
  8000a3:	68 10 48 80 00       	push   $0x804810
  8000a8:	e8 58 0b 00 00       	call   800c05 <cprintf>
  8000ad:	83 c4 10             	add    $0x10,%esp

		int NumOfElements ;

		if (numOfRep == 1)
  8000b0:	83 7d f0 01          	cmpl   $0x1,-0x10(%ebp)
  8000b4:	75 09                	jne    8000bf <_main+0x87>
			NumOfElements = 32;
  8000b6:	c7 45 ec 20 00 00 00 	movl   $0x20,-0x14(%ebp)
  8000bd:	eb 0d                	jmp    8000cc <_main+0x94>
		else if (numOfRep == 2)
  8000bf:	83 7d f0 02          	cmpl   $0x2,-0x10(%ebp)
  8000c3:	75 07                	jne    8000cc <_main+0x94>
			NumOfElements = 32;
  8000c5:	c7 45 ec 20 00 00 00 	movl   $0x20,-0x14(%ebp)

		cprintf("%d\n", NumOfElements) ;
  8000cc:	83 ec 08             	sub    $0x8,%esp
  8000cf:	ff 75 ec             	pushl  -0x14(%ebp)
  8000d2:	68 2f 48 80 00       	push   $0x80482f
  8000d7:	e8 29 0b 00 00       	call   800c05 <cprintf>
  8000dc:	83 c4 10             	add    $0x10,%esp

		int *Elements = malloc(sizeof(int) * NumOfElements) ;
  8000df:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8000e2:	c1 e0 02             	shl    $0x2,%eax
  8000e5:	83 ec 0c             	sub    $0xc,%esp
  8000e8:	50                   	push   %eax
  8000e9:	e8 30 1b 00 00       	call   801c1e <malloc>
  8000ee:	83 c4 10             	add    $0x10,%esp
  8000f1:	89 45 e8             	mov    %eax,-0x18(%ebp)
		cprintf("Chose the initialization method:\n") ;
  8000f4:	83 ec 0c             	sub    $0xc,%esp
  8000f7:	68 34 48 80 00       	push   $0x804834
  8000fc:	e8 04 0b 00 00       	call   800c05 <cprintf>
  800101:	83 c4 10             	add    $0x10,%esp
		cprintf("a) Ascending\n") ;
  800104:	83 ec 0c             	sub    $0xc,%esp
  800107:	68 56 48 80 00       	push   $0x804856
  80010c:	e8 f4 0a 00 00       	call   800c05 <cprintf>
  800111:	83 c4 10             	add    $0x10,%esp
		cprintf("b) Descending\n") ;
  800114:	83 ec 0c             	sub    $0xc,%esp
  800117:	68 64 48 80 00       	push   $0x804864
  80011c:	e8 e4 0a 00 00       	call   800c05 <cprintf>
  800121:	83 c4 10             	add    $0x10,%esp
		cprintf("c) Semi random\n");
  800124:	83 ec 0c             	sub    $0xc,%esp
  800127:	68 73 48 80 00       	push   $0x804873
  80012c:	e8 d4 0a 00 00       	call   800c05 <cprintf>
  800131:	83 c4 10             	add    $0x10,%esp
		do
		{
			cprintf("Select: ") ;
  800134:	83 ec 0c             	sub    $0xc,%esp
  800137:	68 83 48 80 00       	push   $0x804883
  80013c:	e8 c4 0a 00 00       	call   800c05 <cprintf>
  800141:	83 c4 10             	add    $0x10,%esp
			if (numOfRep == 1)
  800144:	83 7d f0 01          	cmpl   $0x1,-0x10(%ebp)
  800148:	75 06                	jne    800150 <_main+0x118>
				Chose = 'a' ;
  80014a:	c6 45 f7 61          	movb   $0x61,-0x9(%ebp)
  80014e:	eb 0a                	jmp    80015a <_main+0x122>
			else if (numOfRep == 2)
  800150:	83 7d f0 02          	cmpl   $0x2,-0x10(%ebp)
  800154:	75 04                	jne    80015a <_main+0x122>
				Chose = 'c' ;
  800156:	c6 45 f7 63          	movb   $0x63,-0x9(%ebp)
			cputchar(Chose);
  80015a:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  80015e:	83 ec 0c             	sub    $0xc,%esp
  800161:	50                   	push   %eax
  800162:	e8 db 05 00 00       	call   800742 <cputchar>
  800167:	83 c4 10             	add    $0x10,%esp
			cputchar('\n');
  80016a:	83 ec 0c             	sub    $0xc,%esp
  80016d:	6a 0a                	push   $0xa
  80016f:	e8 ce 05 00 00       	call   800742 <cputchar>
  800174:	83 c4 10             	add    $0x10,%esp
		} while (Chose != 'a' && Chose != 'b' && Chose != 'c');
  800177:	80 7d f7 61          	cmpb   $0x61,-0x9(%ebp)
  80017b:	74 0c                	je     800189 <_main+0x151>
  80017d:	80 7d f7 62          	cmpb   $0x62,-0x9(%ebp)
  800181:	74 06                	je     800189 <_main+0x151>
  800183:	80 7d f7 63          	cmpb   $0x63,-0x9(%ebp)
  800187:	75 ab                	jne    800134 <_main+0xfc>

		//2012: lock the interrupt
		sys_unlock_cons();
  800189:	e8 4c 33 00 00       	call   8034da <sys_unlock_cons>

		int  i ;
		switch (Chose)
  80018e:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  800192:	83 f8 62             	cmp    $0x62,%eax
  800195:	74 1d                	je     8001b4 <_main+0x17c>
  800197:	83 f8 63             	cmp    $0x63,%eax
  80019a:	74 2b                	je     8001c7 <_main+0x18f>
  80019c:	83 f8 61             	cmp    $0x61,%eax
  80019f:	75 39                	jne    8001da <_main+0x1a2>
		{
		case 'a':
			InitializeAscending(Elements, NumOfElements);
  8001a1:	83 ec 08             	sub    $0x8,%esp
  8001a4:	ff 75 ec             	pushl  -0x14(%ebp)
  8001a7:	ff 75 e8             	pushl  -0x18(%ebp)
  8001aa:	e8 f9 01 00 00       	call   8003a8 <InitializeAscending>
  8001af:	83 c4 10             	add    $0x10,%esp
			break ;
  8001b2:	eb 37                	jmp    8001eb <_main+0x1b3>
		case 'b':
			InitializeIdentical(Elements, NumOfElements);
  8001b4:	83 ec 08             	sub    $0x8,%esp
  8001b7:	ff 75 ec             	pushl  -0x14(%ebp)
  8001ba:	ff 75 e8             	pushl  -0x18(%ebp)
  8001bd:	e8 17 02 00 00       	call   8003d9 <InitializeIdentical>
  8001c2:	83 c4 10             	add    $0x10,%esp
			break ;
  8001c5:	eb 24                	jmp    8001eb <_main+0x1b3>
		case 'c':
			InitializeSemiRandom(Elements, NumOfElements);
  8001c7:	83 ec 08             	sub    $0x8,%esp
  8001ca:	ff 75 ec             	pushl  -0x14(%ebp)
  8001cd:	ff 75 e8             	pushl  -0x18(%ebp)
  8001d0:	e8 39 02 00 00       	call   80040e <InitializeSemiRandom>
  8001d5:	83 c4 10             	add    $0x10,%esp
			break ;
  8001d8:	eb 11                	jmp    8001eb <_main+0x1b3>
		default:
			InitializeSemiRandom(Elements, NumOfElements);
  8001da:	83 ec 08             	sub    $0x8,%esp
  8001dd:	ff 75 ec             	pushl  -0x14(%ebp)
  8001e0:	ff 75 e8             	pushl  -0x18(%ebp)
  8001e3:	e8 26 02 00 00       	call   80040e <InitializeSemiRandom>
  8001e8:	83 c4 10             	add    $0x10,%esp
		}

		MSort(Elements, 1, NumOfElements);
  8001eb:	83 ec 04             	sub    $0x4,%esp
  8001ee:	ff 75 ec             	pushl  -0x14(%ebp)
  8001f1:	6a 01                	push   $0x1
  8001f3:	ff 75 e8             	pushl  -0x18(%ebp)
  8001f6:	e8 f2 02 00 00       	call   8004ed <MSort>
  8001fb:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  8001fe:	e8 bd 32 00 00       	call   8034c0 <sys_lock_cons>
		cprintf("Sorting is Finished!!!!it'll be checked now....\n") ;
  800203:	83 ec 0c             	sub    $0xc,%esp
  800206:	68 8c 48 80 00       	push   $0x80488c
  80020b:	e8 f5 09 00 00       	call   800c05 <cprintf>
  800210:	83 c4 10             	add    $0x10,%esp
		//PrintElements(Elements, NumOfElements);
		sys_unlock_cons();
  800213:	e8 c2 32 00 00       	call   8034da <sys_unlock_cons>

		uint32 Sorted = CheckSorted(Elements, NumOfElements);
  800218:	83 ec 08             	sub    $0x8,%esp
  80021b:	ff 75 ec             	pushl  -0x14(%ebp)
  80021e:	ff 75 e8             	pushl  -0x18(%ebp)
  800221:	e8 d8 00 00 00       	call   8002fe <CheckSorted>
  800226:	83 c4 10             	add    $0x10,%esp
  800229:	89 45 e4             	mov    %eax,-0x1c(%ebp)

		if(Sorted == 0) panic("The array is NOT sorted correctly") ;
  80022c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800230:	75 14                	jne    800246 <_main+0x20e>
  800232:	83 ec 04             	sub    $0x4,%esp
  800235:	68 c0 48 80 00       	push   $0x8048c0
  80023a:	6a 58                	push   $0x58
  80023c:	68 e2 48 80 00       	push   $0x8048e2
  800241:	e8 f1 06 00 00       	call   800937 <_panic>
		else
		{
			sys_lock_cons();
  800246:	e8 75 32 00 00       	call   8034c0 <sys_lock_cons>
			cprintf("===============================================\n") ;
  80024b:	83 ec 0c             	sub    $0xc,%esp
  80024e:	68 00 49 80 00       	push   $0x804900
  800253:	e8 ad 09 00 00       	call   800c05 <cprintf>
  800258:	83 c4 10             	add    $0x10,%esp
			cprintf("Congratulations!! The array is sorted correctly\n") ;
  80025b:	83 ec 0c             	sub    $0xc,%esp
  80025e:	68 34 49 80 00       	push   $0x804934
  800263:	e8 9d 09 00 00       	call   800c05 <cprintf>
  800268:	83 c4 10             	add    $0x10,%esp
			cprintf("===============================================\n\n") ;
  80026b:	83 ec 0c             	sub    $0xc,%esp
  80026e:	68 68 49 80 00       	push   $0x804968
  800273:	e8 8d 09 00 00       	call   800c05 <cprintf>
  800278:	83 c4 10             	add    $0x10,%esp
			sys_unlock_cons();
  80027b:	e8 5a 32 00 00       	call   8034da <sys_unlock_cons>
		}

		//free(Elements) ;

		sys_lock_cons();
  800280:	e8 3b 32 00 00       	call   8034c0 <sys_lock_cons>
		Chose = 0 ;
  800285:	c6 45 f7 00          	movb   $0x0,-0x9(%ebp)
		while (Chose != 'y' && Chose != 'n')
  800289:	eb 50                	jmp    8002db <_main+0x2a3>
		{
			cprintf("Do you want to repeat (y/n): ") ;
  80028b:	83 ec 0c             	sub    $0xc,%esp
  80028e:	68 9a 49 80 00       	push   $0x80499a
  800293:	e8 6d 09 00 00       	call   800c05 <cprintf>
  800298:	83 c4 10             	add    $0x10,%esp
			if (numOfRep == 1)
  80029b:	83 7d f0 01          	cmpl   $0x1,-0x10(%ebp)
  80029f:	75 06                	jne    8002a7 <_main+0x26f>
				Chose = 'y' ;
  8002a1:	c6 45 f7 79          	movb   $0x79,-0x9(%ebp)
  8002a5:	eb 0a                	jmp    8002b1 <_main+0x279>
			else if (numOfRep == 2)
  8002a7:	83 7d f0 02          	cmpl   $0x2,-0x10(%ebp)
  8002ab:	75 04                	jne    8002b1 <_main+0x279>
				Chose = 'n' ;
  8002ad:	c6 45 f7 6e          	movb   $0x6e,-0x9(%ebp)
			cputchar(Chose);
  8002b1:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  8002b5:	83 ec 0c             	sub    $0xc,%esp
  8002b8:	50                   	push   %eax
  8002b9:	e8 84 04 00 00       	call   800742 <cputchar>
  8002be:	83 c4 10             	add    $0x10,%esp
			cputchar('\n');
  8002c1:	83 ec 0c             	sub    $0xc,%esp
  8002c4:	6a 0a                	push   $0xa
  8002c6:	e8 77 04 00 00       	call   800742 <cputchar>
  8002cb:	83 c4 10             	add    $0x10,%esp
			cputchar('\n');
  8002ce:	83 ec 0c             	sub    $0xc,%esp
  8002d1:	6a 0a                	push   $0xa
  8002d3:	e8 6a 04 00 00       	call   800742 <cputchar>
  8002d8:	83 c4 10             	add    $0x10,%esp

		//free(Elements) ;

		sys_lock_cons();
		Chose = 0 ;
		while (Chose != 'y' && Chose != 'n')
  8002db:	80 7d f7 79          	cmpb   $0x79,-0x9(%ebp)
  8002df:	74 06                	je     8002e7 <_main+0x2af>
  8002e1:	80 7d f7 6e          	cmpb   $0x6e,-0x9(%ebp)
  8002e5:	75 a4                	jne    80028b <_main+0x253>
				Chose = 'n' ;
			cputchar(Chose);
			cputchar('\n');
			cputchar('\n');
		}
		sys_unlock_cons();
  8002e7:	e8 ee 31 00 00       	call   8034da <sys_unlock_cons>

	} while (Chose == 'y');
  8002ec:	80 7d f7 79          	cmpb   $0x79,-0x9(%ebp)
  8002f0:	0f 84 52 fd ff ff    	je     800048 <_main+0x10>

	//To indicate that it's completed successfully
	inctst();
  8002f6:	e8 7c 35 00 00       	call   803877 <inctst>

}
  8002fb:	90                   	nop
  8002fc:	c9                   	leave  
  8002fd:	c3                   	ret    

008002fe <CheckSorted>:


uint32 CheckSorted(int *Elements, int NumOfElements)
{
  8002fe:	55                   	push   %ebp
  8002ff:	89 e5                	mov    %esp,%ebp
  800301:	83 ec 10             	sub    $0x10,%esp
	uint32 Sorted = 1 ;
  800304:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
	int i ;
	for (i = 0 ; i < NumOfElements - 1; i++)
  80030b:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  800312:	eb 33                	jmp    800347 <CheckSorted+0x49>
	{
		if (Elements[i] > Elements[i+1])
  800314:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800317:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80031e:	8b 45 08             	mov    0x8(%ebp),%eax
  800321:	01 d0                	add    %edx,%eax
  800323:	8b 10                	mov    (%eax),%edx
  800325:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800328:	40                   	inc    %eax
  800329:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800330:	8b 45 08             	mov    0x8(%ebp),%eax
  800333:	01 c8                	add    %ecx,%eax
  800335:	8b 00                	mov    (%eax),%eax
  800337:	39 c2                	cmp    %eax,%edx
  800339:	7e 09                	jle    800344 <CheckSorted+0x46>
		{
			Sorted = 0 ;
  80033b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
			break;
  800342:	eb 0c                	jmp    800350 <CheckSorted+0x52>

uint32 CheckSorted(int *Elements, int NumOfElements)
{
	uint32 Sorted = 1 ;
	int i ;
	for (i = 0 ; i < NumOfElements - 1; i++)
  800344:	ff 45 f8             	incl   -0x8(%ebp)
  800347:	8b 45 0c             	mov    0xc(%ebp),%eax
  80034a:	48                   	dec    %eax
  80034b:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80034e:	7f c4                	jg     800314 <CheckSorted+0x16>
		{
			Sorted = 0 ;
			break;
		}
	}
	return Sorted ;
  800350:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800353:	c9                   	leave  
  800354:	c3                   	ret    

00800355 <Swap>:

///Private Functions


void Swap(int *Elements, int First, int Second)
{
  800355:	55                   	push   %ebp
  800356:	89 e5                	mov    %esp,%ebp
  800358:	83 ec 10             	sub    $0x10,%esp
	int Tmp = Elements[First] ;
  80035b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80035e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800365:	8b 45 08             	mov    0x8(%ebp),%eax
  800368:	01 d0                	add    %edx,%eax
  80036a:	8b 00                	mov    (%eax),%eax
  80036c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	Elements[First] = Elements[Second] ;
  80036f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800372:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800379:	8b 45 08             	mov    0x8(%ebp),%eax
  80037c:	01 c2                	add    %eax,%edx
  80037e:	8b 45 10             	mov    0x10(%ebp),%eax
  800381:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800388:	8b 45 08             	mov    0x8(%ebp),%eax
  80038b:	01 c8                	add    %ecx,%eax
  80038d:	8b 00                	mov    (%eax),%eax
  80038f:	89 02                	mov    %eax,(%edx)
	Elements[Second] = Tmp ;
  800391:	8b 45 10             	mov    0x10(%ebp),%eax
  800394:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80039b:	8b 45 08             	mov    0x8(%ebp),%eax
  80039e:	01 c2                	add    %eax,%edx
  8003a0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8003a3:	89 02                	mov    %eax,(%edx)
}
  8003a5:	90                   	nop
  8003a6:	c9                   	leave  
  8003a7:	c3                   	ret    

008003a8 <InitializeAscending>:

void InitializeAscending(int *Elements, int NumOfElements)
{
  8003a8:	55                   	push   %ebp
  8003a9:	89 e5                	mov    %esp,%ebp
  8003ab:	83 ec 10             	sub    $0x10,%esp
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  8003ae:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8003b5:	eb 17                	jmp    8003ce <InitializeAscending+0x26>
	{
		(Elements)[i] = i ;
  8003b7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8003ba:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8003c4:	01 c2                	add    %eax,%edx
  8003c6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8003c9:	89 02                	mov    %eax,(%edx)
}

void InitializeAscending(int *Elements, int NumOfElements)
{
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  8003cb:	ff 45 fc             	incl   -0x4(%ebp)
  8003ce:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8003d1:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8003d4:	7c e1                	jl     8003b7 <InitializeAscending+0xf>
	{
		(Elements)[i] = i ;
	}

}
  8003d6:	90                   	nop
  8003d7:	c9                   	leave  
  8003d8:	c3                   	ret    

008003d9 <InitializeIdentical>:

void InitializeIdentical(int *Elements, int NumOfElements)
{
  8003d9:	55                   	push   %ebp
  8003da:	89 e5                	mov    %esp,%ebp
  8003dc:	83 ec 10             	sub    $0x10,%esp
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  8003df:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8003e6:	eb 1b                	jmp    800403 <InitializeIdentical+0x2a>
	{
		Elements[i] = NumOfElements - i - 1 ;
  8003e8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8003eb:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8003f5:	01 c2                	add    %eax,%edx
  8003f7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003fa:	2b 45 fc             	sub    -0x4(%ebp),%eax
  8003fd:	48                   	dec    %eax
  8003fe:	89 02                	mov    %eax,(%edx)
}

void InitializeIdentical(int *Elements, int NumOfElements)
{
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  800400:	ff 45 fc             	incl   -0x4(%ebp)
  800403:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800406:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800409:	7c dd                	jl     8003e8 <InitializeIdentical+0xf>
	{
		Elements[i] = NumOfElements - i - 1 ;
	}

}
  80040b:	90                   	nop
  80040c:	c9                   	leave  
  80040d:	c3                   	ret    

0080040e <InitializeSemiRandom>:

void InitializeSemiRandom(int *Elements, int NumOfElements)
{
  80040e:	55                   	push   %ebp
  80040f:	89 e5                	mov    %esp,%ebp
  800411:	83 ec 10             	sub    $0x10,%esp
	int i ;
	int Repetition = NumOfElements / 3 ;
  800414:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800417:	b8 56 55 55 55       	mov    $0x55555556,%eax
  80041c:	f7 e9                	imul   %ecx
  80041e:	c1 f9 1f             	sar    $0x1f,%ecx
  800421:	89 d0                	mov    %edx,%eax
  800423:	29 c8                	sub    %ecx,%eax
  800425:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (Repetition == 0)
  800428:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  80042c:	75 07                	jne    800435 <InitializeSemiRandom+0x27>
			Repetition = 3;
  80042e:	c7 45 f8 03 00 00 00 	movl   $0x3,-0x8(%ebp)
	for (i = 0 ; i < NumOfElements ; i++)
  800435:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80043c:	eb 1e                	jmp    80045c <InitializeSemiRandom+0x4e>
	{
		Elements[i] = i % Repetition ;
  80043e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800441:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800448:	8b 45 08             	mov    0x8(%ebp),%eax
  80044b:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  80044e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800451:	99                   	cltd   
  800452:	f7 7d f8             	idivl  -0x8(%ebp)
  800455:	89 d0                	mov    %edx,%eax
  800457:	89 01                	mov    %eax,(%ecx)
{
	int i ;
	int Repetition = NumOfElements / 3 ;
	if (Repetition == 0)
			Repetition = 3;
	for (i = 0 ; i < NumOfElements ; i++)
  800459:	ff 45 fc             	incl   -0x4(%ebp)
  80045c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80045f:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800462:	7c da                	jl     80043e <InitializeSemiRandom+0x30>
	{
		Elements[i] = i % Repetition ;
		//	cprintf("i=%d\n",i);
	}

}
  800464:	90                   	nop
  800465:	c9                   	leave  
  800466:	c3                   	ret    

00800467 <PrintElements>:

void PrintElements(int *Elements, int NumOfElements)
{
  800467:	55                   	push   %ebp
  800468:	89 e5                	mov    %esp,%ebp
  80046a:	83 ec 18             	sub    $0x18,%esp
	int i ;
	int NumsPerLine = 20 ;
  80046d:	c7 45 f0 14 00 00 00 	movl   $0x14,-0x10(%ebp)
	for (i = 0 ; i < NumOfElements-1 ; i++)
  800474:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80047b:	eb 42                	jmp    8004bf <PrintElements+0x58>
	{
		if (i%NumsPerLine == 0)
  80047d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800480:	99                   	cltd   
  800481:	f7 7d f0             	idivl  -0x10(%ebp)
  800484:	89 d0                	mov    %edx,%eax
  800486:	85 c0                	test   %eax,%eax
  800488:	75 10                	jne    80049a <PrintElements+0x33>
			cprintf("\n");
  80048a:	83 ec 0c             	sub    $0xc,%esp
  80048d:	68 e0 47 80 00       	push   $0x8047e0
  800492:	e8 6e 07 00 00       	call   800c05 <cprintf>
  800497:	83 c4 10             	add    $0x10,%esp
		cprintf("%d, ",Elements[i]);
  80049a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80049d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8004a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8004a7:	01 d0                	add    %edx,%eax
  8004a9:	8b 00                	mov    (%eax),%eax
  8004ab:	83 ec 08             	sub    $0x8,%esp
  8004ae:	50                   	push   %eax
  8004af:	68 b8 49 80 00       	push   $0x8049b8
  8004b4:	e8 4c 07 00 00       	call   800c05 <cprintf>
  8004b9:	83 c4 10             	add    $0x10,%esp

void PrintElements(int *Elements, int NumOfElements)
{
	int i ;
	int NumsPerLine = 20 ;
	for (i = 0 ; i < NumOfElements-1 ; i++)
  8004bc:	ff 45 f4             	incl   -0xc(%ebp)
  8004bf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004c2:	48                   	dec    %eax
  8004c3:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8004c6:	7f b5                	jg     80047d <PrintElements+0x16>
	{
		if (i%NumsPerLine == 0)
			cprintf("\n");
		cprintf("%d, ",Elements[i]);
	}
	cprintf("%d\n",Elements[i]);
  8004c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8004cb:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8004d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8004d5:	01 d0                	add    %edx,%eax
  8004d7:	8b 00                	mov    (%eax),%eax
  8004d9:	83 ec 08             	sub    $0x8,%esp
  8004dc:	50                   	push   %eax
  8004dd:	68 2f 48 80 00       	push   $0x80482f
  8004e2:	e8 1e 07 00 00       	call   800c05 <cprintf>
  8004e7:	83 c4 10             	add    $0x10,%esp

}
  8004ea:	90                   	nop
  8004eb:	c9                   	leave  
  8004ec:	c3                   	ret    

008004ed <MSort>:


void MSort(int* A, int p, int r)
{
  8004ed:	55                   	push   %ebp
  8004ee:	89 e5                	mov    %esp,%ebp
  8004f0:	83 ec 18             	sub    $0x18,%esp
	if (p >= r)
  8004f3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004f6:	3b 45 10             	cmp    0x10(%ebp),%eax
  8004f9:	7d 54                	jge    80054f <MSort+0x62>
	{
		return;
	}

	int q = (p + r) / 2;
  8004fb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004fe:	8b 45 10             	mov    0x10(%ebp),%eax
  800501:	01 d0                	add    %edx,%eax
  800503:	89 c2                	mov    %eax,%edx
  800505:	c1 ea 1f             	shr    $0x1f,%edx
  800508:	01 d0                	add    %edx,%eax
  80050a:	d1 f8                	sar    %eax
  80050c:	89 45 f4             	mov    %eax,-0xc(%ebp)

	MSort(A, p, q);
  80050f:	83 ec 04             	sub    $0x4,%esp
  800512:	ff 75 f4             	pushl  -0xc(%ebp)
  800515:	ff 75 0c             	pushl  0xc(%ebp)
  800518:	ff 75 08             	pushl  0x8(%ebp)
  80051b:	e8 cd ff ff ff       	call   8004ed <MSort>
  800520:	83 c4 10             	add    $0x10,%esp

	MSort(A, q + 1, r);
  800523:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800526:	40                   	inc    %eax
  800527:	83 ec 04             	sub    $0x4,%esp
  80052a:	ff 75 10             	pushl  0x10(%ebp)
  80052d:	50                   	push   %eax
  80052e:	ff 75 08             	pushl  0x8(%ebp)
  800531:	e8 b7 ff ff ff       	call   8004ed <MSort>
  800536:	83 c4 10             	add    $0x10,%esp

	Merge(A, p, q, r);
  800539:	ff 75 10             	pushl  0x10(%ebp)
  80053c:	ff 75 f4             	pushl  -0xc(%ebp)
  80053f:	ff 75 0c             	pushl  0xc(%ebp)
  800542:	ff 75 08             	pushl  0x8(%ebp)
  800545:	e8 08 00 00 00       	call   800552 <Merge>
  80054a:	83 c4 10             	add    $0x10,%esp
  80054d:	eb 01                	jmp    800550 <MSort+0x63>

void MSort(int* A, int p, int r)
{
	if (p >= r)
	{
		return;
  80054f:	90                   	nop

	MSort(A, q + 1, r);

	Merge(A, p, q, r);

}
  800550:	c9                   	leave  
  800551:	c3                   	ret    

00800552 <Merge>:

void Merge(int* A, int p, int q, int r)
{
  800552:	55                   	push   %ebp
  800553:	89 e5                	mov    %esp,%ebp
  800555:	83 ec 38             	sub    $0x38,%esp
	int leftCapacity = q - p + 1;
  800558:	8b 45 10             	mov    0x10(%ebp),%eax
  80055b:	2b 45 0c             	sub    0xc(%ebp),%eax
  80055e:	40                   	inc    %eax
  80055f:	89 45 e0             	mov    %eax,-0x20(%ebp)

	int rightCapacity = r - q;
  800562:	8b 45 14             	mov    0x14(%ebp),%eax
  800565:	2b 45 10             	sub    0x10(%ebp),%eax
  800568:	89 45 dc             	mov    %eax,-0x24(%ebp)

	int leftIndex = 0;
  80056b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	int rightIndex = 0;
  800572:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	int* Left = malloc(sizeof(int) * leftCapacity);
  800579:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80057c:	c1 e0 02             	shl    $0x2,%eax
  80057f:	83 ec 0c             	sub    $0xc,%esp
  800582:	50                   	push   %eax
  800583:	e8 96 16 00 00       	call   801c1e <malloc>
  800588:	83 c4 10             	add    $0x10,%esp
  80058b:	89 45 d8             	mov    %eax,-0x28(%ebp)

	int* Right = malloc(sizeof(int) * rightCapacity);
  80058e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800591:	c1 e0 02             	shl    $0x2,%eax
  800594:	83 ec 0c             	sub    $0xc,%esp
  800597:	50                   	push   %eax
  800598:	e8 81 16 00 00       	call   801c1e <malloc>
  80059d:	83 c4 10             	add    $0x10,%esp
  8005a0:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	//	int Left[5000] ;
	//	int Right[5000] ;

	int i, j, k;
	for (i = 0; i < leftCapacity; i++)
  8005a3:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  8005aa:	eb 2f                	jmp    8005db <Merge+0x89>
	{
		Left[i] = A[p + i - 1];
  8005ac:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8005af:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8005b6:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8005b9:	01 c2                	add    %eax,%edx
  8005bb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8005be:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8005c1:	01 c8                	add    %ecx,%eax
  8005c3:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  8005c8:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8005cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8005d2:	01 c8                	add    %ecx,%eax
  8005d4:	8b 00                	mov    (%eax),%eax
  8005d6:	89 02                	mov    %eax,(%edx)

	//	int Left[5000] ;
	//	int Right[5000] ;

	int i, j, k;
	for (i = 0; i < leftCapacity; i++)
  8005d8:	ff 45 ec             	incl   -0x14(%ebp)
  8005db:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8005de:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8005e1:	7c c9                	jl     8005ac <Merge+0x5a>
	{
		Left[i] = A[p + i - 1];
	}
	for (j = 0; j < rightCapacity; j++)
  8005e3:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8005ea:	eb 2a                	jmp    800616 <Merge+0xc4>
	{
		Right[j] = A[q + j];
  8005ec:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8005ef:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8005f6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8005f9:	01 c2                	add    %eax,%edx
  8005fb:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8005fe:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800601:	01 c8                	add    %ecx,%eax
  800603:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80060a:	8b 45 08             	mov    0x8(%ebp),%eax
  80060d:	01 c8                	add    %ecx,%eax
  80060f:	8b 00                	mov    (%eax),%eax
  800611:	89 02                	mov    %eax,(%edx)
	int i, j, k;
	for (i = 0; i < leftCapacity; i++)
	{
		Left[i] = A[p + i - 1];
	}
	for (j = 0; j < rightCapacity; j++)
  800613:	ff 45 e8             	incl   -0x18(%ebp)
  800616:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800619:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  80061c:	7c ce                	jl     8005ec <Merge+0x9a>
	{
		Right[j] = A[q + j];
	}

	for ( k = p; k <= r; k++)
  80061e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800621:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800624:	e9 0a 01 00 00       	jmp    800733 <Merge+0x1e1>
	{
		if (leftIndex < leftCapacity && rightIndex < rightCapacity)
  800629:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80062c:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80062f:	0f 8d 95 00 00 00    	jge    8006ca <Merge+0x178>
  800635:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800638:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  80063b:	0f 8d 89 00 00 00    	jge    8006ca <Merge+0x178>
		{
			if (Left[leftIndex] < Right[rightIndex] )
  800641:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800644:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80064b:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80064e:	01 d0                	add    %edx,%eax
  800650:	8b 10                	mov    (%eax),%edx
  800652:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800655:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80065c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80065f:	01 c8                	add    %ecx,%eax
  800661:	8b 00                	mov    (%eax),%eax
  800663:	39 c2                	cmp    %eax,%edx
  800665:	7d 33                	jge    80069a <Merge+0x148>
			{
				A[k - 1] = Left[leftIndex++];
  800667:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80066a:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  80066f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800676:	8b 45 08             	mov    0x8(%ebp),%eax
  800679:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  80067c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80067f:	8d 50 01             	lea    0x1(%eax),%edx
  800682:	89 55 f4             	mov    %edx,-0xc(%ebp)
  800685:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80068c:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80068f:	01 d0                	add    %edx,%eax
  800691:	8b 00                	mov    (%eax),%eax
  800693:	89 01                	mov    %eax,(%ecx)

	for ( k = p; k <= r; k++)
	{
		if (leftIndex < leftCapacity && rightIndex < rightCapacity)
		{
			if (Left[leftIndex] < Right[rightIndex] )
  800695:	e9 96 00 00 00       	jmp    800730 <Merge+0x1de>
			{
				A[k - 1] = Left[leftIndex++];
			}
			else
			{
				A[k - 1] = Right[rightIndex++];
  80069a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80069d:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  8006a2:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8006a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ac:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  8006af:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8006b2:	8d 50 01             	lea    0x1(%eax),%edx
  8006b5:	89 55 f0             	mov    %edx,-0x10(%ebp)
  8006b8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8006bf:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8006c2:	01 d0                	add    %edx,%eax
  8006c4:	8b 00                	mov    (%eax),%eax
  8006c6:	89 01                	mov    %eax,(%ecx)

	for ( k = p; k <= r; k++)
	{
		if (leftIndex < leftCapacity && rightIndex < rightCapacity)
		{
			if (Left[leftIndex] < Right[rightIndex] )
  8006c8:	eb 66                	jmp    800730 <Merge+0x1de>
			else
			{
				A[k - 1] = Right[rightIndex++];
			}
		}
		else if (leftIndex < leftCapacity)
  8006ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8006cd:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8006d0:	7d 30                	jge    800702 <Merge+0x1b0>
		{
			A[k - 1] = Left[leftIndex++];
  8006d2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8006d5:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  8006da:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8006e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8006e4:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  8006e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8006ea:	8d 50 01             	lea    0x1(%eax),%edx
  8006ed:	89 55 f4             	mov    %edx,-0xc(%ebp)
  8006f0:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8006f7:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8006fa:	01 d0                	add    %edx,%eax
  8006fc:	8b 00                	mov    (%eax),%eax
  8006fe:	89 01                	mov    %eax,(%ecx)
  800700:	eb 2e                	jmp    800730 <Merge+0x1de>
		}
		else
		{
			A[k - 1] = Right[rightIndex++];
  800702:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800705:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  80070a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800711:	8b 45 08             	mov    0x8(%ebp),%eax
  800714:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  800717:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80071a:	8d 50 01             	lea    0x1(%eax),%edx
  80071d:	89 55 f0             	mov    %edx,-0x10(%ebp)
  800720:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800727:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80072a:	01 d0                	add    %edx,%eax
  80072c:	8b 00                	mov    (%eax),%eax
  80072e:	89 01                	mov    %eax,(%ecx)
	for (j = 0; j < rightCapacity; j++)
	{
		Right[j] = A[q + j];
	}

	for ( k = p; k <= r; k++)
  800730:	ff 45 e4             	incl   -0x1c(%ebp)
  800733:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800736:	3b 45 14             	cmp    0x14(%ebp),%eax
  800739:	0f 8e ea fe ff ff    	jle    800629 <Merge+0xd7>
		{
			A[k - 1] = Right[rightIndex++];
		}
	}

}
  80073f:	90                   	nop
  800740:	c9                   	leave  
  800741:	c3                   	ret    

00800742 <cputchar>:
#include <inc/lib.h>


void
cputchar(int ch)
{
  800742:	55                   	push   %ebp
  800743:	89 e5                	mov    %esp,%ebp
  800745:	83 ec 18             	sub    $0x18,%esp
	char c = ch;
  800748:	8b 45 08             	mov    0x8(%ebp),%eax
  80074b:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  80074e:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  800752:	83 ec 0c             	sub    $0xc,%esp
  800755:	50                   	push   %eax
  800756:	e8 ad 2e 00 00       	call   803608 <sys_cputc>
  80075b:	83 c4 10             	add    $0x10,%esp
}
  80075e:	90                   	nop
  80075f:	c9                   	leave  
  800760:	c3                   	ret    

00800761 <getchar>:


int
getchar(void)
{
  800761:	55                   	push   %ebp
  800762:	89 e5                	mov    %esp,%ebp
  800764:	83 ec 18             	sub    $0x18,%esp
	int c =sys_cgetc();
  800767:	e8 3b 2d 00 00       	call   8034a7 <sys_cgetc>
  80076c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return c;
  80076f:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800772:	c9                   	leave  
  800773:	c3                   	ret    

00800774 <iscons>:

int iscons(int fdnum)
{
  800774:	55                   	push   %ebp
  800775:	89 e5                	mov    %esp,%ebp
	// used by readline
	return 1;
  800777:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80077c:	5d                   	pop    %ebp
  80077d:	c3                   	ret    

0080077e <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  80077e:	55                   	push   %ebp
  80077f:	89 e5                	mov    %esp,%ebp
  800781:	57                   	push   %edi
  800782:	56                   	push   %esi
  800783:	53                   	push   %ebx
  800784:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  800787:	e8 ad 2f 00 00       	call   803739 <sys_getenvindex>
  80078c:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  80078f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800792:	89 d0                	mov    %edx,%eax
  800794:	c1 e0 02             	shl    $0x2,%eax
  800797:	01 d0                	add    %edx,%eax
  800799:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8007a0:	01 d0                	add    %edx,%eax
  8007a2:	89 c2                	mov    %eax,%edx
  8007a4:	c1 e2 04             	shl    $0x4,%edx
  8007a7:	29 c2                	sub    %eax,%edx
  8007a9:	8d 04 95 00 00 00 00 	lea    0x0(,%edx,4),%eax
  8007b0:	89 c2                	mov    %eax,%edx
  8007b2:	8d 82 00 00 c0 ee    	lea    -0x11400000(%edx),%eax
  8007b8:	a3 24 60 80 00       	mov    %eax,0x806024

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8007bd:	a1 24 60 80 00       	mov    0x806024,%eax
  8007c2:	8a 40 20             	mov    0x20(%eax),%al
  8007c5:	84 c0                	test   %al,%al
  8007c7:	74 0d                	je     8007d6 <libmain+0x58>
		binaryname = myEnv->prog_name;
  8007c9:	a1 24 60 80 00       	mov    0x806024,%eax
  8007ce:	83 c0 20             	add    $0x20,%eax
  8007d1:	a3 04 60 80 00       	mov    %eax,0x806004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8007d6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8007da:	7e 0a                	jle    8007e6 <libmain+0x68>
		binaryname = argv[0];
  8007dc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007df:	8b 00                	mov    (%eax),%eax
  8007e1:	a3 04 60 80 00       	mov    %eax,0x806004

	// call user main routine
	_main(argc, argv);
  8007e6:	83 ec 08             	sub    $0x8,%esp
  8007e9:	ff 75 0c             	pushl  0xc(%ebp)
  8007ec:	ff 75 08             	pushl  0x8(%ebp)
  8007ef:	e8 44 f8 ff ff       	call   800038 <_main>
  8007f4:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  8007f7:	a1 00 60 80 00       	mov    0x806000,%eax
  8007fc:	85 c0                	test   %eax,%eax
  8007fe:	0f 84 01 01 00 00    	je     800905 <libmain+0x187>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  800804:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  80080a:	bb b8 4a 80 00       	mov    $0x804ab8,%ebx
  80080f:	ba 0e 00 00 00       	mov    $0xe,%edx
  800814:	89 c7                	mov    %eax,%edi
  800816:	89 de                	mov    %ebx,%esi
  800818:	89 d1                	mov    %edx,%ecx
  80081a:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  80081c:	8d 55 8a             	lea    -0x76(%ebp),%edx
  80081f:	b9 56 00 00 00       	mov    $0x56,%ecx
  800824:	b0 00                	mov    $0x0,%al
  800826:	89 d7                	mov    %edx,%edi
  800828:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  80082a:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  800831:	8d 45 e0             	lea    -0x20(%ebp),%eax
  800834:	83 ec 08             	sub    $0x8,%esp
  800837:	50                   	push   %eax
  800838:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  80083e:	50                   	push   %eax
  80083f:	e8 2b 31 00 00       	call   80396f <sys_utilities>
  800844:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  800847:	e8 74 2c 00 00       	call   8034c0 <sys_lock_cons>
		{
			cprintf("**************************************\n");
  80084c:	83 ec 0c             	sub    $0xc,%esp
  80084f:	68 d8 49 80 00       	push   $0x8049d8
  800854:	e8 ac 03 00 00       	call   800c05 <cprintf>
  800859:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  80085c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80085f:	85 c0                	test   %eax,%eax
  800861:	74 18                	je     80087b <libmain+0xfd>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  800863:	e8 25 31 00 00       	call   80398d <sys_get_optimal_num_faults>
  800868:	83 ec 08             	sub    $0x8,%esp
  80086b:	50                   	push   %eax
  80086c:	68 00 4a 80 00       	push   $0x804a00
  800871:	e8 8f 03 00 00       	call   800c05 <cprintf>
  800876:	83 c4 10             	add    $0x10,%esp
  800879:	eb 59                	jmp    8008d4 <libmain+0x156>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  80087b:	a1 24 60 80 00       	mov    0x806024,%eax
  800880:	8b 90 bc 05 00 00    	mov    0x5bc(%eax),%edx
  800886:	a1 24 60 80 00       	mov    0x806024,%eax
  80088b:	8b 80 ac 05 00 00    	mov    0x5ac(%eax),%eax
  800891:	83 ec 04             	sub    $0x4,%esp
  800894:	52                   	push   %edx
  800895:	50                   	push   %eax
  800896:	68 24 4a 80 00       	push   $0x804a24
  80089b:	e8 65 03 00 00       	call   800c05 <cprintf>
  8008a0:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8008a3:	a1 24 60 80 00       	mov    0x806024,%eax
  8008a8:	8b 88 d0 05 00 00    	mov    0x5d0(%eax),%ecx
  8008ae:	a1 24 60 80 00       	mov    0x806024,%eax
  8008b3:	8b 90 cc 05 00 00    	mov    0x5cc(%eax),%edx
  8008b9:	a1 24 60 80 00       	mov    0x806024,%eax
  8008be:	8b 80 c8 05 00 00    	mov    0x5c8(%eax),%eax
  8008c4:	51                   	push   %ecx
  8008c5:	52                   	push   %edx
  8008c6:	50                   	push   %eax
  8008c7:	68 4c 4a 80 00       	push   $0x804a4c
  8008cc:	e8 34 03 00 00       	call   800c05 <cprintf>
  8008d1:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8008d4:	a1 24 60 80 00       	mov    0x806024,%eax
  8008d9:	8b 80 d4 05 00 00    	mov    0x5d4(%eax),%eax
  8008df:	83 ec 08             	sub    $0x8,%esp
  8008e2:	50                   	push   %eax
  8008e3:	68 a4 4a 80 00       	push   $0x804aa4
  8008e8:	e8 18 03 00 00       	call   800c05 <cprintf>
  8008ed:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  8008f0:	83 ec 0c             	sub    $0xc,%esp
  8008f3:	68 d8 49 80 00       	push   $0x8049d8
  8008f8:	e8 08 03 00 00       	call   800c05 <cprintf>
  8008fd:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  800900:	e8 d5 2b 00 00       	call   8034da <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  800905:	e8 1f 00 00 00       	call   800929 <exit>
}
  80090a:	90                   	nop
  80090b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80090e:	5b                   	pop    %ebx
  80090f:	5e                   	pop    %esi
  800910:	5f                   	pop    %edi
  800911:	5d                   	pop    %ebp
  800912:	c3                   	ret    

00800913 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800913:	55                   	push   %ebp
  800914:	89 e5                	mov    %esp,%ebp
  800916:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800919:	83 ec 0c             	sub    $0xc,%esp
  80091c:	6a 00                	push   $0x0
  80091e:	e8 e2 2d 00 00       	call   803705 <sys_destroy_env>
  800923:	83 c4 10             	add    $0x10,%esp
}
  800926:	90                   	nop
  800927:	c9                   	leave  
  800928:	c3                   	ret    

00800929 <exit>:

void
exit(void)
{
  800929:	55                   	push   %ebp
  80092a:	89 e5                	mov    %esp,%ebp
  80092c:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  80092f:	e8 37 2e 00 00       	call   80376b <sys_exit_env>
}
  800934:	90                   	nop
  800935:	c9                   	leave  
  800936:	c3                   	ret    

00800937 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800937:	55                   	push   %ebp
  800938:	89 e5                	mov    %esp,%ebp
  80093a:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  80093d:	8d 45 10             	lea    0x10(%ebp),%eax
  800940:	83 c0 04             	add    $0x4,%eax
  800943:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800946:	a1 18 e1 81 00       	mov    0x81e118,%eax
  80094b:	85 c0                	test   %eax,%eax
  80094d:	74 16                	je     800965 <_panic+0x2e>
		cprintf("%s: ", argv0);
  80094f:	a1 18 e1 81 00       	mov    0x81e118,%eax
  800954:	83 ec 08             	sub    $0x8,%esp
  800957:	50                   	push   %eax
  800958:	68 1c 4b 80 00       	push   $0x804b1c
  80095d:	e8 a3 02 00 00       	call   800c05 <cprintf>
  800962:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  800965:	a1 04 60 80 00       	mov    0x806004,%eax
  80096a:	83 ec 0c             	sub    $0xc,%esp
  80096d:	ff 75 0c             	pushl  0xc(%ebp)
  800970:	ff 75 08             	pushl  0x8(%ebp)
  800973:	50                   	push   %eax
  800974:	68 24 4b 80 00       	push   $0x804b24
  800979:	6a 74                	push   $0x74
  80097b:	e8 b2 02 00 00       	call   800c32 <cprintf_colored>
  800980:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  800983:	8b 45 10             	mov    0x10(%ebp),%eax
  800986:	83 ec 08             	sub    $0x8,%esp
  800989:	ff 75 f4             	pushl  -0xc(%ebp)
  80098c:	50                   	push   %eax
  80098d:	e8 04 02 00 00       	call   800b96 <vcprintf>
  800992:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800995:	83 ec 08             	sub    $0x8,%esp
  800998:	6a 00                	push   $0x0
  80099a:	68 4c 4b 80 00       	push   $0x804b4c
  80099f:	e8 f2 01 00 00       	call   800b96 <vcprintf>
  8009a4:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8009a7:	e8 7d ff ff ff       	call   800929 <exit>

	// should not return here
	while (1) ;
  8009ac:	eb fe                	jmp    8009ac <_panic+0x75>

008009ae <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8009ae:	55                   	push   %ebp
  8009af:	89 e5                	mov    %esp,%ebp
  8009b1:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8009b4:	a1 24 60 80 00       	mov    0x806024,%eax
  8009b9:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8009bf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009c2:	39 c2                	cmp    %eax,%edx
  8009c4:	74 14                	je     8009da <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8009c6:	83 ec 04             	sub    $0x4,%esp
  8009c9:	68 50 4b 80 00       	push   $0x804b50
  8009ce:	6a 26                	push   $0x26
  8009d0:	68 9c 4b 80 00       	push   $0x804b9c
  8009d5:	e8 5d ff ff ff       	call   800937 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8009da:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8009e1:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8009e8:	e9 c5 00 00 00       	jmp    800ab2 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  8009ed:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009f0:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8009f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8009fa:	01 d0                	add    %edx,%eax
  8009fc:	8b 00                	mov    (%eax),%eax
  8009fe:	85 c0                	test   %eax,%eax
  800a00:	75 08                	jne    800a0a <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  800a02:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800a05:	e9 a5 00 00 00       	jmp    800aaf <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  800a0a:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800a11:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800a18:	eb 69                	jmp    800a83 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800a1a:	a1 24 60 80 00       	mov    0x806024,%eax
  800a1f:	8b 88 a4 05 00 00    	mov    0x5a4(%eax),%ecx
  800a25:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800a28:	89 d0                	mov    %edx,%eax
  800a2a:	01 c0                	add    %eax,%eax
  800a2c:	01 d0                	add    %edx,%eax
  800a2e:	c1 e0 03             	shl    $0x3,%eax
  800a31:	01 c8                	add    %ecx,%eax
  800a33:	8a 40 04             	mov    0x4(%eax),%al
  800a36:	84 c0                	test   %al,%al
  800a38:	75 46                	jne    800a80 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800a3a:	a1 24 60 80 00       	mov    0x806024,%eax
  800a3f:	8b 88 a4 05 00 00    	mov    0x5a4(%eax),%ecx
  800a45:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800a48:	89 d0                	mov    %edx,%eax
  800a4a:	01 c0                	add    %eax,%eax
  800a4c:	01 d0                	add    %edx,%eax
  800a4e:	c1 e0 03             	shl    $0x3,%eax
  800a51:	01 c8                	add    %ecx,%eax
  800a53:	8b 00                	mov    (%eax),%eax
  800a55:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800a58:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800a5b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800a60:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800a62:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a65:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800a6c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a6f:	01 c8                	add    %ecx,%eax
  800a71:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800a73:	39 c2                	cmp    %eax,%edx
  800a75:	75 09                	jne    800a80 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  800a77:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800a7e:	eb 15                	jmp    800a95 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800a80:	ff 45 e8             	incl   -0x18(%ebp)
  800a83:	a1 24 60 80 00       	mov    0x806024,%eax
  800a88:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800a8e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800a91:	39 c2                	cmp    %eax,%edx
  800a93:	77 85                	ja     800a1a <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800a95:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800a99:	75 14                	jne    800aaf <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  800a9b:	83 ec 04             	sub    $0x4,%esp
  800a9e:	68 a8 4b 80 00       	push   $0x804ba8
  800aa3:	6a 3a                	push   $0x3a
  800aa5:	68 9c 4b 80 00       	push   $0x804b9c
  800aaa:	e8 88 fe ff ff       	call   800937 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800aaf:	ff 45 f0             	incl   -0x10(%ebp)
  800ab2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ab5:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800ab8:	0f 8c 2f ff ff ff    	jl     8009ed <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800abe:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800ac5:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800acc:	eb 26                	jmp    800af4 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800ace:	a1 24 60 80 00       	mov    0x806024,%eax
  800ad3:	8b 88 a4 05 00 00    	mov    0x5a4(%eax),%ecx
  800ad9:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800adc:	89 d0                	mov    %edx,%eax
  800ade:	01 c0                	add    %eax,%eax
  800ae0:	01 d0                	add    %edx,%eax
  800ae2:	c1 e0 03             	shl    $0x3,%eax
  800ae5:	01 c8                	add    %ecx,%eax
  800ae7:	8a 40 04             	mov    0x4(%eax),%al
  800aea:	3c 01                	cmp    $0x1,%al
  800aec:	75 03                	jne    800af1 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  800aee:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800af1:	ff 45 e0             	incl   -0x20(%ebp)
  800af4:	a1 24 60 80 00       	mov    0x806024,%eax
  800af9:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800aff:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800b02:	39 c2                	cmp    %eax,%edx
  800b04:	77 c8                	ja     800ace <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800b06:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800b09:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800b0c:	74 14                	je     800b22 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  800b0e:	83 ec 04             	sub    $0x4,%esp
  800b11:	68 fc 4b 80 00       	push   $0x804bfc
  800b16:	6a 44                	push   $0x44
  800b18:	68 9c 4b 80 00       	push   $0x804b9c
  800b1d:	e8 15 fe ff ff       	call   800937 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800b22:	90                   	nop
  800b23:	c9                   	leave  
  800b24:	c3                   	ret    

00800b25 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  800b25:	55                   	push   %ebp
  800b26:	89 e5                	mov    %esp,%ebp
  800b28:	53                   	push   %ebx
  800b29:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  800b2c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b2f:	8b 00                	mov    (%eax),%eax
  800b31:	8d 48 01             	lea    0x1(%eax),%ecx
  800b34:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b37:	89 0a                	mov    %ecx,(%edx)
  800b39:	8b 55 08             	mov    0x8(%ebp),%edx
  800b3c:	88 d1                	mov    %dl,%cl
  800b3e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b41:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800b45:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b48:	8b 00                	mov    (%eax),%eax
  800b4a:	3d ff 00 00 00       	cmp    $0xff,%eax
  800b4f:	75 30                	jne    800b81 <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  800b51:	8b 15 1c e1 81 00    	mov    0x81e11c,%edx
  800b57:	a0 44 60 80 00       	mov    0x806044,%al
  800b5c:	0f b6 c0             	movzbl %al,%eax
  800b5f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b62:	8b 09                	mov    (%ecx),%ecx
  800b64:	89 cb                	mov    %ecx,%ebx
  800b66:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b69:	83 c1 08             	add    $0x8,%ecx
  800b6c:	52                   	push   %edx
  800b6d:	50                   	push   %eax
  800b6e:	53                   	push   %ebx
  800b6f:	51                   	push   %ecx
  800b70:	e8 07 29 00 00       	call   80347c <sys_cputs>
  800b75:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800b78:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b7b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800b81:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b84:	8b 40 04             	mov    0x4(%eax),%eax
  800b87:	8d 50 01             	lea    0x1(%eax),%edx
  800b8a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b8d:	89 50 04             	mov    %edx,0x4(%eax)
}
  800b90:	90                   	nop
  800b91:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800b94:	c9                   	leave  
  800b95:	c3                   	ret    

00800b96 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800b96:	55                   	push   %ebp
  800b97:	89 e5                	mov    %esp,%ebp
  800b99:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800b9f:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800ba6:	00 00 00 
	b.cnt = 0;
  800ba9:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800bb0:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800bb3:	ff 75 0c             	pushl  0xc(%ebp)
  800bb6:	ff 75 08             	pushl  0x8(%ebp)
  800bb9:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800bbf:	50                   	push   %eax
  800bc0:	68 25 0b 80 00       	push   $0x800b25
  800bc5:	e8 5a 02 00 00       	call   800e24 <vprintfmt>
  800bca:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  800bcd:	8b 15 1c e1 81 00    	mov    0x81e11c,%edx
  800bd3:	a0 44 60 80 00       	mov    0x806044,%al
  800bd8:	0f b6 c0             	movzbl %al,%eax
  800bdb:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  800be1:	52                   	push   %edx
  800be2:	50                   	push   %eax
  800be3:	51                   	push   %ecx
  800be4:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800bea:	83 c0 08             	add    $0x8,%eax
  800bed:	50                   	push   %eax
  800bee:	e8 89 28 00 00       	call   80347c <sys_cputs>
  800bf3:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800bf6:	c6 05 44 60 80 00 00 	movb   $0x0,0x806044
	return b.cnt;
  800bfd:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800c03:	c9                   	leave  
  800c04:	c3                   	ret    

00800c05 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  800c05:	55                   	push   %ebp
  800c06:	89 e5                	mov    %esp,%ebp
  800c08:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800c0b:	c6 05 44 60 80 00 01 	movb   $0x1,0x806044
	va_start(ap, fmt);
  800c12:	8d 45 0c             	lea    0xc(%ebp),%eax
  800c15:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800c18:	8b 45 08             	mov    0x8(%ebp),%eax
  800c1b:	83 ec 08             	sub    $0x8,%esp
  800c1e:	ff 75 f4             	pushl  -0xc(%ebp)
  800c21:	50                   	push   %eax
  800c22:	e8 6f ff ff ff       	call   800b96 <vcprintf>
  800c27:	83 c4 10             	add    $0x10,%esp
  800c2a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800c2d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800c30:	c9                   	leave  
  800c31:	c3                   	ret    

00800c32 <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  800c32:	55                   	push   %ebp
  800c33:	89 e5                	mov    %esp,%ebp
  800c35:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800c38:	c6 05 44 60 80 00 01 	movb   $0x1,0x806044
	curTextClr = (textClr << 8) ; //set text color by the given value
  800c3f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c42:	c1 e0 08             	shl    $0x8,%eax
  800c45:	a3 1c e1 81 00       	mov    %eax,0x81e11c
	va_start(ap, fmt);
  800c4a:	8d 45 0c             	lea    0xc(%ebp),%eax
  800c4d:	83 c0 04             	add    $0x4,%eax
  800c50:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800c53:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c56:	83 ec 08             	sub    $0x8,%esp
  800c59:	ff 75 f4             	pushl  -0xc(%ebp)
  800c5c:	50                   	push   %eax
  800c5d:	e8 34 ff ff ff       	call   800b96 <vcprintf>
  800c62:	83 c4 10             	add    $0x10,%esp
  800c65:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  800c68:	c7 05 1c e1 81 00 00 	movl   $0x700,0x81e11c
  800c6f:	07 00 00 

	return cnt;
  800c72:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800c75:	c9                   	leave  
  800c76:	c3                   	ret    

00800c77 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  800c77:	55                   	push   %ebp
  800c78:	89 e5                	mov    %esp,%ebp
  800c7a:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  800c7d:	e8 3e 28 00 00       	call   8034c0 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  800c82:	8d 45 0c             	lea    0xc(%ebp),%eax
  800c85:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  800c88:	8b 45 08             	mov    0x8(%ebp),%eax
  800c8b:	83 ec 08             	sub    $0x8,%esp
  800c8e:	ff 75 f4             	pushl  -0xc(%ebp)
  800c91:	50                   	push   %eax
  800c92:	e8 ff fe ff ff       	call   800b96 <vcprintf>
  800c97:	83 c4 10             	add    $0x10,%esp
  800c9a:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  800c9d:	e8 38 28 00 00       	call   8034da <sys_unlock_cons>
	return cnt;
  800ca2:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800ca5:	c9                   	leave  
  800ca6:	c3                   	ret    

00800ca7 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800ca7:	55                   	push   %ebp
  800ca8:	89 e5                	mov    %esp,%ebp
  800caa:	53                   	push   %ebx
  800cab:	83 ec 14             	sub    $0x14,%esp
  800cae:	8b 45 10             	mov    0x10(%ebp),%eax
  800cb1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800cb4:	8b 45 14             	mov    0x14(%ebp),%eax
  800cb7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800cba:	8b 45 18             	mov    0x18(%ebp),%eax
  800cbd:	ba 00 00 00 00       	mov    $0x0,%edx
  800cc2:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800cc5:	77 55                	ja     800d1c <printnum+0x75>
  800cc7:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800cca:	72 05                	jb     800cd1 <printnum+0x2a>
  800ccc:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800ccf:	77 4b                	ja     800d1c <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800cd1:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800cd4:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800cd7:	8b 45 18             	mov    0x18(%ebp),%eax
  800cda:	ba 00 00 00 00       	mov    $0x0,%edx
  800cdf:	52                   	push   %edx
  800ce0:	50                   	push   %eax
  800ce1:	ff 75 f4             	pushl  -0xc(%ebp)
  800ce4:	ff 75 f0             	pushl  -0x10(%ebp)
  800ce7:	e8 80 38 00 00       	call   80456c <__udivdi3>
  800cec:	83 c4 10             	add    $0x10,%esp
  800cef:	83 ec 04             	sub    $0x4,%esp
  800cf2:	ff 75 20             	pushl  0x20(%ebp)
  800cf5:	53                   	push   %ebx
  800cf6:	ff 75 18             	pushl  0x18(%ebp)
  800cf9:	52                   	push   %edx
  800cfa:	50                   	push   %eax
  800cfb:	ff 75 0c             	pushl  0xc(%ebp)
  800cfe:	ff 75 08             	pushl  0x8(%ebp)
  800d01:	e8 a1 ff ff ff       	call   800ca7 <printnum>
  800d06:	83 c4 20             	add    $0x20,%esp
  800d09:	eb 1a                	jmp    800d25 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800d0b:	83 ec 08             	sub    $0x8,%esp
  800d0e:	ff 75 0c             	pushl  0xc(%ebp)
  800d11:	ff 75 20             	pushl  0x20(%ebp)
  800d14:	8b 45 08             	mov    0x8(%ebp),%eax
  800d17:	ff d0                	call   *%eax
  800d19:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800d1c:	ff 4d 1c             	decl   0x1c(%ebp)
  800d1f:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800d23:	7f e6                	jg     800d0b <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800d25:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800d28:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d2d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800d30:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800d33:	53                   	push   %ebx
  800d34:	51                   	push   %ecx
  800d35:	52                   	push   %edx
  800d36:	50                   	push   %eax
  800d37:	e8 40 39 00 00       	call   80467c <__umoddi3>
  800d3c:	83 c4 10             	add    $0x10,%esp
  800d3f:	05 74 4e 80 00       	add    $0x804e74,%eax
  800d44:	8a 00                	mov    (%eax),%al
  800d46:	0f be c0             	movsbl %al,%eax
  800d49:	83 ec 08             	sub    $0x8,%esp
  800d4c:	ff 75 0c             	pushl  0xc(%ebp)
  800d4f:	50                   	push   %eax
  800d50:	8b 45 08             	mov    0x8(%ebp),%eax
  800d53:	ff d0                	call   *%eax
  800d55:	83 c4 10             	add    $0x10,%esp
}
  800d58:	90                   	nop
  800d59:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800d5c:	c9                   	leave  
  800d5d:	c3                   	ret    

00800d5e <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800d5e:	55                   	push   %ebp
  800d5f:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800d61:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800d65:	7e 1c                	jle    800d83 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800d67:	8b 45 08             	mov    0x8(%ebp),%eax
  800d6a:	8b 00                	mov    (%eax),%eax
  800d6c:	8d 50 08             	lea    0x8(%eax),%edx
  800d6f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d72:	89 10                	mov    %edx,(%eax)
  800d74:	8b 45 08             	mov    0x8(%ebp),%eax
  800d77:	8b 00                	mov    (%eax),%eax
  800d79:	83 e8 08             	sub    $0x8,%eax
  800d7c:	8b 50 04             	mov    0x4(%eax),%edx
  800d7f:	8b 00                	mov    (%eax),%eax
  800d81:	eb 40                	jmp    800dc3 <getuint+0x65>
	else if (lflag)
  800d83:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d87:	74 1e                	je     800da7 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800d89:	8b 45 08             	mov    0x8(%ebp),%eax
  800d8c:	8b 00                	mov    (%eax),%eax
  800d8e:	8d 50 04             	lea    0x4(%eax),%edx
  800d91:	8b 45 08             	mov    0x8(%ebp),%eax
  800d94:	89 10                	mov    %edx,(%eax)
  800d96:	8b 45 08             	mov    0x8(%ebp),%eax
  800d99:	8b 00                	mov    (%eax),%eax
  800d9b:	83 e8 04             	sub    $0x4,%eax
  800d9e:	8b 00                	mov    (%eax),%eax
  800da0:	ba 00 00 00 00       	mov    $0x0,%edx
  800da5:	eb 1c                	jmp    800dc3 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800da7:	8b 45 08             	mov    0x8(%ebp),%eax
  800daa:	8b 00                	mov    (%eax),%eax
  800dac:	8d 50 04             	lea    0x4(%eax),%edx
  800daf:	8b 45 08             	mov    0x8(%ebp),%eax
  800db2:	89 10                	mov    %edx,(%eax)
  800db4:	8b 45 08             	mov    0x8(%ebp),%eax
  800db7:	8b 00                	mov    (%eax),%eax
  800db9:	83 e8 04             	sub    $0x4,%eax
  800dbc:	8b 00                	mov    (%eax),%eax
  800dbe:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800dc3:	5d                   	pop    %ebp
  800dc4:	c3                   	ret    

00800dc5 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800dc5:	55                   	push   %ebp
  800dc6:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800dc8:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800dcc:	7e 1c                	jle    800dea <getint+0x25>
		return va_arg(*ap, long long);
  800dce:	8b 45 08             	mov    0x8(%ebp),%eax
  800dd1:	8b 00                	mov    (%eax),%eax
  800dd3:	8d 50 08             	lea    0x8(%eax),%edx
  800dd6:	8b 45 08             	mov    0x8(%ebp),%eax
  800dd9:	89 10                	mov    %edx,(%eax)
  800ddb:	8b 45 08             	mov    0x8(%ebp),%eax
  800dde:	8b 00                	mov    (%eax),%eax
  800de0:	83 e8 08             	sub    $0x8,%eax
  800de3:	8b 50 04             	mov    0x4(%eax),%edx
  800de6:	8b 00                	mov    (%eax),%eax
  800de8:	eb 38                	jmp    800e22 <getint+0x5d>
	else if (lflag)
  800dea:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800dee:	74 1a                	je     800e0a <getint+0x45>
		return va_arg(*ap, long);
  800df0:	8b 45 08             	mov    0x8(%ebp),%eax
  800df3:	8b 00                	mov    (%eax),%eax
  800df5:	8d 50 04             	lea    0x4(%eax),%edx
  800df8:	8b 45 08             	mov    0x8(%ebp),%eax
  800dfb:	89 10                	mov    %edx,(%eax)
  800dfd:	8b 45 08             	mov    0x8(%ebp),%eax
  800e00:	8b 00                	mov    (%eax),%eax
  800e02:	83 e8 04             	sub    $0x4,%eax
  800e05:	8b 00                	mov    (%eax),%eax
  800e07:	99                   	cltd   
  800e08:	eb 18                	jmp    800e22 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800e0a:	8b 45 08             	mov    0x8(%ebp),%eax
  800e0d:	8b 00                	mov    (%eax),%eax
  800e0f:	8d 50 04             	lea    0x4(%eax),%edx
  800e12:	8b 45 08             	mov    0x8(%ebp),%eax
  800e15:	89 10                	mov    %edx,(%eax)
  800e17:	8b 45 08             	mov    0x8(%ebp),%eax
  800e1a:	8b 00                	mov    (%eax),%eax
  800e1c:	83 e8 04             	sub    $0x4,%eax
  800e1f:	8b 00                	mov    (%eax),%eax
  800e21:	99                   	cltd   
}
  800e22:	5d                   	pop    %ebp
  800e23:	c3                   	ret    

00800e24 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800e24:	55                   	push   %ebp
  800e25:	89 e5                	mov    %esp,%ebp
  800e27:	56                   	push   %esi
  800e28:	53                   	push   %ebx
  800e29:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800e2c:	eb 17                	jmp    800e45 <vprintfmt+0x21>
			if (ch == '\0')
  800e2e:	85 db                	test   %ebx,%ebx
  800e30:	0f 84 c1 03 00 00    	je     8011f7 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  800e36:	83 ec 08             	sub    $0x8,%esp
  800e39:	ff 75 0c             	pushl  0xc(%ebp)
  800e3c:	53                   	push   %ebx
  800e3d:	8b 45 08             	mov    0x8(%ebp),%eax
  800e40:	ff d0                	call   *%eax
  800e42:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800e45:	8b 45 10             	mov    0x10(%ebp),%eax
  800e48:	8d 50 01             	lea    0x1(%eax),%edx
  800e4b:	89 55 10             	mov    %edx,0x10(%ebp)
  800e4e:	8a 00                	mov    (%eax),%al
  800e50:	0f b6 d8             	movzbl %al,%ebx
  800e53:	83 fb 25             	cmp    $0x25,%ebx
  800e56:	75 d6                	jne    800e2e <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800e58:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800e5c:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800e63:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800e6a:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800e71:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800e78:	8b 45 10             	mov    0x10(%ebp),%eax
  800e7b:	8d 50 01             	lea    0x1(%eax),%edx
  800e7e:	89 55 10             	mov    %edx,0x10(%ebp)
  800e81:	8a 00                	mov    (%eax),%al
  800e83:	0f b6 d8             	movzbl %al,%ebx
  800e86:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800e89:	83 f8 5b             	cmp    $0x5b,%eax
  800e8c:	0f 87 3d 03 00 00    	ja     8011cf <vprintfmt+0x3ab>
  800e92:	8b 04 85 98 4e 80 00 	mov    0x804e98(,%eax,4),%eax
  800e99:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800e9b:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800e9f:	eb d7                	jmp    800e78 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800ea1:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800ea5:	eb d1                	jmp    800e78 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800ea7:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800eae:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800eb1:	89 d0                	mov    %edx,%eax
  800eb3:	c1 e0 02             	shl    $0x2,%eax
  800eb6:	01 d0                	add    %edx,%eax
  800eb8:	01 c0                	add    %eax,%eax
  800eba:	01 d8                	add    %ebx,%eax
  800ebc:	83 e8 30             	sub    $0x30,%eax
  800ebf:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800ec2:	8b 45 10             	mov    0x10(%ebp),%eax
  800ec5:	8a 00                	mov    (%eax),%al
  800ec7:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800eca:	83 fb 2f             	cmp    $0x2f,%ebx
  800ecd:	7e 3e                	jle    800f0d <vprintfmt+0xe9>
  800ecf:	83 fb 39             	cmp    $0x39,%ebx
  800ed2:	7f 39                	jg     800f0d <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800ed4:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800ed7:	eb d5                	jmp    800eae <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800ed9:	8b 45 14             	mov    0x14(%ebp),%eax
  800edc:	83 c0 04             	add    $0x4,%eax
  800edf:	89 45 14             	mov    %eax,0x14(%ebp)
  800ee2:	8b 45 14             	mov    0x14(%ebp),%eax
  800ee5:	83 e8 04             	sub    $0x4,%eax
  800ee8:	8b 00                	mov    (%eax),%eax
  800eea:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800eed:	eb 1f                	jmp    800f0e <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800eef:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800ef3:	79 83                	jns    800e78 <vprintfmt+0x54>
				width = 0;
  800ef5:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800efc:	e9 77 ff ff ff       	jmp    800e78 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800f01:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800f08:	e9 6b ff ff ff       	jmp    800e78 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800f0d:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800f0e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800f12:	0f 89 60 ff ff ff    	jns    800e78 <vprintfmt+0x54>
				width = precision, precision = -1;
  800f18:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800f1b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800f1e:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800f25:	e9 4e ff ff ff       	jmp    800e78 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800f2a:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800f2d:	e9 46 ff ff ff       	jmp    800e78 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800f32:	8b 45 14             	mov    0x14(%ebp),%eax
  800f35:	83 c0 04             	add    $0x4,%eax
  800f38:	89 45 14             	mov    %eax,0x14(%ebp)
  800f3b:	8b 45 14             	mov    0x14(%ebp),%eax
  800f3e:	83 e8 04             	sub    $0x4,%eax
  800f41:	8b 00                	mov    (%eax),%eax
  800f43:	83 ec 08             	sub    $0x8,%esp
  800f46:	ff 75 0c             	pushl  0xc(%ebp)
  800f49:	50                   	push   %eax
  800f4a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f4d:	ff d0                	call   *%eax
  800f4f:	83 c4 10             	add    $0x10,%esp
			break;
  800f52:	e9 9b 02 00 00       	jmp    8011f2 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800f57:	8b 45 14             	mov    0x14(%ebp),%eax
  800f5a:	83 c0 04             	add    $0x4,%eax
  800f5d:	89 45 14             	mov    %eax,0x14(%ebp)
  800f60:	8b 45 14             	mov    0x14(%ebp),%eax
  800f63:	83 e8 04             	sub    $0x4,%eax
  800f66:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800f68:	85 db                	test   %ebx,%ebx
  800f6a:	79 02                	jns    800f6e <vprintfmt+0x14a>
				err = -err;
  800f6c:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800f6e:	83 fb 64             	cmp    $0x64,%ebx
  800f71:	7f 0b                	jg     800f7e <vprintfmt+0x15a>
  800f73:	8b 34 9d e0 4c 80 00 	mov    0x804ce0(,%ebx,4),%esi
  800f7a:	85 f6                	test   %esi,%esi
  800f7c:	75 19                	jne    800f97 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800f7e:	53                   	push   %ebx
  800f7f:	68 85 4e 80 00       	push   $0x804e85
  800f84:	ff 75 0c             	pushl  0xc(%ebp)
  800f87:	ff 75 08             	pushl  0x8(%ebp)
  800f8a:	e8 70 02 00 00       	call   8011ff <printfmt>
  800f8f:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800f92:	e9 5b 02 00 00       	jmp    8011f2 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800f97:	56                   	push   %esi
  800f98:	68 8e 4e 80 00       	push   $0x804e8e
  800f9d:	ff 75 0c             	pushl  0xc(%ebp)
  800fa0:	ff 75 08             	pushl  0x8(%ebp)
  800fa3:	e8 57 02 00 00       	call   8011ff <printfmt>
  800fa8:	83 c4 10             	add    $0x10,%esp
			break;
  800fab:	e9 42 02 00 00       	jmp    8011f2 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800fb0:	8b 45 14             	mov    0x14(%ebp),%eax
  800fb3:	83 c0 04             	add    $0x4,%eax
  800fb6:	89 45 14             	mov    %eax,0x14(%ebp)
  800fb9:	8b 45 14             	mov    0x14(%ebp),%eax
  800fbc:	83 e8 04             	sub    $0x4,%eax
  800fbf:	8b 30                	mov    (%eax),%esi
  800fc1:	85 f6                	test   %esi,%esi
  800fc3:	75 05                	jne    800fca <vprintfmt+0x1a6>
				p = "(null)";
  800fc5:	be 91 4e 80 00       	mov    $0x804e91,%esi
			if (width > 0 && padc != '-')
  800fca:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800fce:	7e 6d                	jle    80103d <vprintfmt+0x219>
  800fd0:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800fd4:	74 67                	je     80103d <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800fd6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800fd9:	83 ec 08             	sub    $0x8,%esp
  800fdc:	50                   	push   %eax
  800fdd:	56                   	push   %esi
  800fde:	e8 1e 03 00 00       	call   801301 <strnlen>
  800fe3:	83 c4 10             	add    $0x10,%esp
  800fe6:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800fe9:	eb 16                	jmp    801001 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800feb:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800fef:	83 ec 08             	sub    $0x8,%esp
  800ff2:	ff 75 0c             	pushl  0xc(%ebp)
  800ff5:	50                   	push   %eax
  800ff6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff9:	ff d0                	call   *%eax
  800ffb:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800ffe:	ff 4d e4             	decl   -0x1c(%ebp)
  801001:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801005:	7f e4                	jg     800feb <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801007:	eb 34                	jmp    80103d <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  801009:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80100d:	74 1c                	je     80102b <vprintfmt+0x207>
  80100f:	83 fb 1f             	cmp    $0x1f,%ebx
  801012:	7e 05                	jle    801019 <vprintfmt+0x1f5>
  801014:	83 fb 7e             	cmp    $0x7e,%ebx
  801017:	7e 12                	jle    80102b <vprintfmt+0x207>
					putch('?', putdat);
  801019:	83 ec 08             	sub    $0x8,%esp
  80101c:	ff 75 0c             	pushl  0xc(%ebp)
  80101f:	6a 3f                	push   $0x3f
  801021:	8b 45 08             	mov    0x8(%ebp),%eax
  801024:	ff d0                	call   *%eax
  801026:	83 c4 10             	add    $0x10,%esp
  801029:	eb 0f                	jmp    80103a <vprintfmt+0x216>
				else
					putch(ch, putdat);
  80102b:	83 ec 08             	sub    $0x8,%esp
  80102e:	ff 75 0c             	pushl  0xc(%ebp)
  801031:	53                   	push   %ebx
  801032:	8b 45 08             	mov    0x8(%ebp),%eax
  801035:	ff d0                	call   *%eax
  801037:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80103a:	ff 4d e4             	decl   -0x1c(%ebp)
  80103d:	89 f0                	mov    %esi,%eax
  80103f:	8d 70 01             	lea    0x1(%eax),%esi
  801042:	8a 00                	mov    (%eax),%al
  801044:	0f be d8             	movsbl %al,%ebx
  801047:	85 db                	test   %ebx,%ebx
  801049:	74 24                	je     80106f <vprintfmt+0x24b>
  80104b:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80104f:	78 b8                	js     801009 <vprintfmt+0x1e5>
  801051:	ff 4d e0             	decl   -0x20(%ebp)
  801054:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801058:	79 af                	jns    801009 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80105a:	eb 13                	jmp    80106f <vprintfmt+0x24b>
				putch(' ', putdat);
  80105c:	83 ec 08             	sub    $0x8,%esp
  80105f:	ff 75 0c             	pushl  0xc(%ebp)
  801062:	6a 20                	push   $0x20
  801064:	8b 45 08             	mov    0x8(%ebp),%eax
  801067:	ff d0                	call   *%eax
  801069:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80106c:	ff 4d e4             	decl   -0x1c(%ebp)
  80106f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801073:	7f e7                	jg     80105c <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  801075:	e9 78 01 00 00       	jmp    8011f2 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  80107a:	83 ec 08             	sub    $0x8,%esp
  80107d:	ff 75 e8             	pushl  -0x18(%ebp)
  801080:	8d 45 14             	lea    0x14(%ebp),%eax
  801083:	50                   	push   %eax
  801084:	e8 3c fd ff ff       	call   800dc5 <getint>
  801089:	83 c4 10             	add    $0x10,%esp
  80108c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80108f:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  801092:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801095:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801098:	85 d2                	test   %edx,%edx
  80109a:	79 23                	jns    8010bf <vprintfmt+0x29b>
				putch('-', putdat);
  80109c:	83 ec 08             	sub    $0x8,%esp
  80109f:	ff 75 0c             	pushl  0xc(%ebp)
  8010a2:	6a 2d                	push   $0x2d
  8010a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a7:	ff d0                	call   *%eax
  8010a9:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  8010ac:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8010af:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8010b2:	f7 d8                	neg    %eax
  8010b4:	83 d2 00             	adc    $0x0,%edx
  8010b7:	f7 da                	neg    %edx
  8010b9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8010bc:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8010bf:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8010c6:	e9 bc 00 00 00       	jmp    801187 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8010cb:	83 ec 08             	sub    $0x8,%esp
  8010ce:	ff 75 e8             	pushl  -0x18(%ebp)
  8010d1:	8d 45 14             	lea    0x14(%ebp),%eax
  8010d4:	50                   	push   %eax
  8010d5:	e8 84 fc ff ff       	call   800d5e <getuint>
  8010da:	83 c4 10             	add    $0x10,%esp
  8010dd:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8010e0:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  8010e3:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8010ea:	e9 98 00 00 00       	jmp    801187 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  8010ef:	83 ec 08             	sub    $0x8,%esp
  8010f2:	ff 75 0c             	pushl  0xc(%ebp)
  8010f5:	6a 58                	push   $0x58
  8010f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8010fa:	ff d0                	call   *%eax
  8010fc:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8010ff:	83 ec 08             	sub    $0x8,%esp
  801102:	ff 75 0c             	pushl  0xc(%ebp)
  801105:	6a 58                	push   $0x58
  801107:	8b 45 08             	mov    0x8(%ebp),%eax
  80110a:	ff d0                	call   *%eax
  80110c:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  80110f:	83 ec 08             	sub    $0x8,%esp
  801112:	ff 75 0c             	pushl  0xc(%ebp)
  801115:	6a 58                	push   $0x58
  801117:	8b 45 08             	mov    0x8(%ebp),%eax
  80111a:	ff d0                	call   *%eax
  80111c:	83 c4 10             	add    $0x10,%esp
			break;
  80111f:	e9 ce 00 00 00       	jmp    8011f2 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  801124:	83 ec 08             	sub    $0x8,%esp
  801127:	ff 75 0c             	pushl  0xc(%ebp)
  80112a:	6a 30                	push   $0x30
  80112c:	8b 45 08             	mov    0x8(%ebp),%eax
  80112f:	ff d0                	call   *%eax
  801131:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  801134:	83 ec 08             	sub    $0x8,%esp
  801137:	ff 75 0c             	pushl  0xc(%ebp)
  80113a:	6a 78                	push   $0x78
  80113c:	8b 45 08             	mov    0x8(%ebp),%eax
  80113f:	ff d0                	call   *%eax
  801141:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  801144:	8b 45 14             	mov    0x14(%ebp),%eax
  801147:	83 c0 04             	add    $0x4,%eax
  80114a:	89 45 14             	mov    %eax,0x14(%ebp)
  80114d:	8b 45 14             	mov    0x14(%ebp),%eax
  801150:	83 e8 04             	sub    $0x4,%eax
  801153:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801155:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801158:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  80115f:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  801166:	eb 1f                	jmp    801187 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  801168:	83 ec 08             	sub    $0x8,%esp
  80116b:	ff 75 e8             	pushl  -0x18(%ebp)
  80116e:	8d 45 14             	lea    0x14(%ebp),%eax
  801171:	50                   	push   %eax
  801172:	e8 e7 fb ff ff       	call   800d5e <getuint>
  801177:	83 c4 10             	add    $0x10,%esp
  80117a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80117d:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  801180:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  801187:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  80118b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80118e:	83 ec 04             	sub    $0x4,%esp
  801191:	52                   	push   %edx
  801192:	ff 75 e4             	pushl  -0x1c(%ebp)
  801195:	50                   	push   %eax
  801196:	ff 75 f4             	pushl  -0xc(%ebp)
  801199:	ff 75 f0             	pushl  -0x10(%ebp)
  80119c:	ff 75 0c             	pushl  0xc(%ebp)
  80119f:	ff 75 08             	pushl  0x8(%ebp)
  8011a2:	e8 00 fb ff ff       	call   800ca7 <printnum>
  8011a7:	83 c4 20             	add    $0x20,%esp
			break;
  8011aa:	eb 46                	jmp    8011f2 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8011ac:	83 ec 08             	sub    $0x8,%esp
  8011af:	ff 75 0c             	pushl  0xc(%ebp)
  8011b2:	53                   	push   %ebx
  8011b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8011b6:	ff d0                	call   *%eax
  8011b8:	83 c4 10             	add    $0x10,%esp
			break;
  8011bb:	eb 35                	jmp    8011f2 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  8011bd:	c6 05 44 60 80 00 00 	movb   $0x0,0x806044
			break;
  8011c4:	eb 2c                	jmp    8011f2 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  8011c6:	c6 05 44 60 80 00 01 	movb   $0x1,0x806044
			break;
  8011cd:	eb 23                	jmp    8011f2 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8011cf:	83 ec 08             	sub    $0x8,%esp
  8011d2:	ff 75 0c             	pushl  0xc(%ebp)
  8011d5:	6a 25                	push   $0x25
  8011d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8011da:	ff d0                	call   *%eax
  8011dc:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  8011df:	ff 4d 10             	decl   0x10(%ebp)
  8011e2:	eb 03                	jmp    8011e7 <vprintfmt+0x3c3>
  8011e4:	ff 4d 10             	decl   0x10(%ebp)
  8011e7:	8b 45 10             	mov    0x10(%ebp),%eax
  8011ea:	48                   	dec    %eax
  8011eb:	8a 00                	mov    (%eax),%al
  8011ed:	3c 25                	cmp    $0x25,%al
  8011ef:	75 f3                	jne    8011e4 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  8011f1:	90                   	nop
		}
	}
  8011f2:	e9 35 fc ff ff       	jmp    800e2c <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  8011f7:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  8011f8:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8011fb:	5b                   	pop    %ebx
  8011fc:	5e                   	pop    %esi
  8011fd:	5d                   	pop    %ebp
  8011fe:	c3                   	ret    

008011ff <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8011ff:	55                   	push   %ebp
  801200:	89 e5                	mov    %esp,%ebp
  801202:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  801205:	8d 45 10             	lea    0x10(%ebp),%eax
  801208:	83 c0 04             	add    $0x4,%eax
  80120b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  80120e:	8b 45 10             	mov    0x10(%ebp),%eax
  801211:	ff 75 f4             	pushl  -0xc(%ebp)
  801214:	50                   	push   %eax
  801215:	ff 75 0c             	pushl  0xc(%ebp)
  801218:	ff 75 08             	pushl  0x8(%ebp)
  80121b:	e8 04 fc ff ff       	call   800e24 <vprintfmt>
  801220:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  801223:	90                   	nop
  801224:	c9                   	leave  
  801225:	c3                   	ret    

00801226 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801226:	55                   	push   %ebp
  801227:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  801229:	8b 45 0c             	mov    0xc(%ebp),%eax
  80122c:	8b 40 08             	mov    0x8(%eax),%eax
  80122f:	8d 50 01             	lea    0x1(%eax),%edx
  801232:	8b 45 0c             	mov    0xc(%ebp),%eax
  801235:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  801238:	8b 45 0c             	mov    0xc(%ebp),%eax
  80123b:	8b 10                	mov    (%eax),%edx
  80123d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801240:	8b 40 04             	mov    0x4(%eax),%eax
  801243:	39 c2                	cmp    %eax,%edx
  801245:	73 12                	jae    801259 <sprintputch+0x33>
		*b->buf++ = ch;
  801247:	8b 45 0c             	mov    0xc(%ebp),%eax
  80124a:	8b 00                	mov    (%eax),%eax
  80124c:	8d 48 01             	lea    0x1(%eax),%ecx
  80124f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801252:	89 0a                	mov    %ecx,(%edx)
  801254:	8b 55 08             	mov    0x8(%ebp),%edx
  801257:	88 10                	mov    %dl,(%eax)
}
  801259:	90                   	nop
  80125a:	5d                   	pop    %ebp
  80125b:	c3                   	ret    

0080125c <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80125c:	55                   	push   %ebp
  80125d:	89 e5                	mov    %esp,%ebp
  80125f:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  801262:	8b 45 08             	mov    0x8(%ebp),%eax
  801265:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801268:	8b 45 0c             	mov    0xc(%ebp),%eax
  80126b:	8d 50 ff             	lea    -0x1(%eax),%edx
  80126e:	8b 45 08             	mov    0x8(%ebp),%eax
  801271:	01 d0                	add    %edx,%eax
  801273:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801276:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80127d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801281:	74 06                	je     801289 <vsnprintf+0x2d>
  801283:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801287:	7f 07                	jg     801290 <vsnprintf+0x34>
		return -E_INVAL;
  801289:	b8 03 00 00 00       	mov    $0x3,%eax
  80128e:	eb 20                	jmp    8012b0 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  801290:	ff 75 14             	pushl  0x14(%ebp)
  801293:	ff 75 10             	pushl  0x10(%ebp)
  801296:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801299:	50                   	push   %eax
  80129a:	68 26 12 80 00       	push   $0x801226
  80129f:	e8 80 fb ff ff       	call   800e24 <vprintfmt>
  8012a4:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  8012a7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8012aa:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8012ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8012b0:	c9                   	leave  
  8012b1:	c3                   	ret    

008012b2 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8012b2:	55                   	push   %ebp
  8012b3:	89 e5                	mov    %esp,%ebp
  8012b5:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8012b8:	8d 45 10             	lea    0x10(%ebp),%eax
  8012bb:	83 c0 04             	add    $0x4,%eax
  8012be:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  8012c1:	8b 45 10             	mov    0x10(%ebp),%eax
  8012c4:	ff 75 f4             	pushl  -0xc(%ebp)
  8012c7:	50                   	push   %eax
  8012c8:	ff 75 0c             	pushl  0xc(%ebp)
  8012cb:	ff 75 08             	pushl  0x8(%ebp)
  8012ce:	e8 89 ff ff ff       	call   80125c <vsnprintf>
  8012d3:	83 c4 10             	add    $0x10,%esp
  8012d6:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  8012d9:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8012dc:	c9                   	leave  
  8012dd:	c3                   	ret    

008012de <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  8012de:	55                   	push   %ebp
  8012df:	89 e5                	mov    %esp,%ebp
  8012e1:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  8012e4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8012eb:	eb 06                	jmp    8012f3 <strlen+0x15>
		n++;
  8012ed:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8012f0:	ff 45 08             	incl   0x8(%ebp)
  8012f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8012f6:	8a 00                	mov    (%eax),%al
  8012f8:	84 c0                	test   %al,%al
  8012fa:	75 f1                	jne    8012ed <strlen+0xf>
		n++;
	return n;
  8012fc:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8012ff:	c9                   	leave  
  801300:	c3                   	ret    

00801301 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  801301:	55                   	push   %ebp
  801302:	89 e5                	mov    %esp,%ebp
  801304:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801307:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80130e:	eb 09                	jmp    801319 <strnlen+0x18>
		n++;
  801310:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801313:	ff 45 08             	incl   0x8(%ebp)
  801316:	ff 4d 0c             	decl   0xc(%ebp)
  801319:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80131d:	74 09                	je     801328 <strnlen+0x27>
  80131f:	8b 45 08             	mov    0x8(%ebp),%eax
  801322:	8a 00                	mov    (%eax),%al
  801324:	84 c0                	test   %al,%al
  801326:	75 e8                	jne    801310 <strnlen+0xf>
		n++;
	return n;
  801328:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80132b:	c9                   	leave  
  80132c:	c3                   	ret    

0080132d <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80132d:	55                   	push   %ebp
  80132e:	89 e5                	mov    %esp,%ebp
  801330:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  801333:	8b 45 08             	mov    0x8(%ebp),%eax
  801336:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  801339:	90                   	nop
  80133a:	8b 45 08             	mov    0x8(%ebp),%eax
  80133d:	8d 50 01             	lea    0x1(%eax),%edx
  801340:	89 55 08             	mov    %edx,0x8(%ebp)
  801343:	8b 55 0c             	mov    0xc(%ebp),%edx
  801346:	8d 4a 01             	lea    0x1(%edx),%ecx
  801349:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  80134c:	8a 12                	mov    (%edx),%dl
  80134e:	88 10                	mov    %dl,(%eax)
  801350:	8a 00                	mov    (%eax),%al
  801352:	84 c0                	test   %al,%al
  801354:	75 e4                	jne    80133a <strcpy+0xd>
		/* do nothing */;
	return ret;
  801356:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801359:	c9                   	leave  
  80135a:	c3                   	ret    

0080135b <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  80135b:	55                   	push   %ebp
  80135c:	89 e5                	mov    %esp,%ebp
  80135e:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  801361:	8b 45 08             	mov    0x8(%ebp),%eax
  801364:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  801367:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80136e:	eb 1f                	jmp    80138f <strncpy+0x34>
		*dst++ = *src;
  801370:	8b 45 08             	mov    0x8(%ebp),%eax
  801373:	8d 50 01             	lea    0x1(%eax),%edx
  801376:	89 55 08             	mov    %edx,0x8(%ebp)
  801379:	8b 55 0c             	mov    0xc(%ebp),%edx
  80137c:	8a 12                	mov    (%edx),%dl
  80137e:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801380:	8b 45 0c             	mov    0xc(%ebp),%eax
  801383:	8a 00                	mov    (%eax),%al
  801385:	84 c0                	test   %al,%al
  801387:	74 03                	je     80138c <strncpy+0x31>
			src++;
  801389:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80138c:	ff 45 fc             	incl   -0x4(%ebp)
  80138f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801392:	3b 45 10             	cmp    0x10(%ebp),%eax
  801395:	72 d9                	jb     801370 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801397:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80139a:	c9                   	leave  
  80139b:	c3                   	ret    

0080139c <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  80139c:	55                   	push   %ebp
  80139d:	89 e5                	mov    %esp,%ebp
  80139f:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  8013a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8013a5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  8013a8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8013ac:	74 30                	je     8013de <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  8013ae:	eb 16                	jmp    8013c6 <strlcpy+0x2a>
			*dst++ = *src++;
  8013b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8013b3:	8d 50 01             	lea    0x1(%eax),%edx
  8013b6:	89 55 08             	mov    %edx,0x8(%ebp)
  8013b9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8013bc:	8d 4a 01             	lea    0x1(%edx),%ecx
  8013bf:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8013c2:	8a 12                	mov    (%edx),%dl
  8013c4:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8013c6:	ff 4d 10             	decl   0x10(%ebp)
  8013c9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8013cd:	74 09                	je     8013d8 <strlcpy+0x3c>
  8013cf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013d2:	8a 00                	mov    (%eax),%al
  8013d4:	84 c0                	test   %al,%al
  8013d6:	75 d8                	jne    8013b0 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  8013d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8013db:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8013de:	8b 55 08             	mov    0x8(%ebp),%edx
  8013e1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8013e4:	29 c2                	sub    %eax,%edx
  8013e6:	89 d0                	mov    %edx,%eax
}
  8013e8:	c9                   	leave  
  8013e9:	c3                   	ret    

008013ea <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8013ea:	55                   	push   %ebp
  8013eb:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  8013ed:	eb 06                	jmp    8013f5 <strcmp+0xb>
		p++, q++;
  8013ef:	ff 45 08             	incl   0x8(%ebp)
  8013f2:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8013f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8013f8:	8a 00                	mov    (%eax),%al
  8013fa:	84 c0                	test   %al,%al
  8013fc:	74 0e                	je     80140c <strcmp+0x22>
  8013fe:	8b 45 08             	mov    0x8(%ebp),%eax
  801401:	8a 10                	mov    (%eax),%dl
  801403:	8b 45 0c             	mov    0xc(%ebp),%eax
  801406:	8a 00                	mov    (%eax),%al
  801408:	38 c2                	cmp    %al,%dl
  80140a:	74 e3                	je     8013ef <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80140c:	8b 45 08             	mov    0x8(%ebp),%eax
  80140f:	8a 00                	mov    (%eax),%al
  801411:	0f b6 d0             	movzbl %al,%edx
  801414:	8b 45 0c             	mov    0xc(%ebp),%eax
  801417:	8a 00                	mov    (%eax),%al
  801419:	0f b6 c0             	movzbl %al,%eax
  80141c:	29 c2                	sub    %eax,%edx
  80141e:	89 d0                	mov    %edx,%eax
}
  801420:	5d                   	pop    %ebp
  801421:	c3                   	ret    

00801422 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  801422:	55                   	push   %ebp
  801423:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  801425:	eb 09                	jmp    801430 <strncmp+0xe>
		n--, p++, q++;
  801427:	ff 4d 10             	decl   0x10(%ebp)
  80142a:	ff 45 08             	incl   0x8(%ebp)
  80142d:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  801430:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801434:	74 17                	je     80144d <strncmp+0x2b>
  801436:	8b 45 08             	mov    0x8(%ebp),%eax
  801439:	8a 00                	mov    (%eax),%al
  80143b:	84 c0                	test   %al,%al
  80143d:	74 0e                	je     80144d <strncmp+0x2b>
  80143f:	8b 45 08             	mov    0x8(%ebp),%eax
  801442:	8a 10                	mov    (%eax),%dl
  801444:	8b 45 0c             	mov    0xc(%ebp),%eax
  801447:	8a 00                	mov    (%eax),%al
  801449:	38 c2                	cmp    %al,%dl
  80144b:	74 da                	je     801427 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  80144d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801451:	75 07                	jne    80145a <strncmp+0x38>
		return 0;
  801453:	b8 00 00 00 00       	mov    $0x0,%eax
  801458:	eb 14                	jmp    80146e <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80145a:	8b 45 08             	mov    0x8(%ebp),%eax
  80145d:	8a 00                	mov    (%eax),%al
  80145f:	0f b6 d0             	movzbl %al,%edx
  801462:	8b 45 0c             	mov    0xc(%ebp),%eax
  801465:	8a 00                	mov    (%eax),%al
  801467:	0f b6 c0             	movzbl %al,%eax
  80146a:	29 c2                	sub    %eax,%edx
  80146c:	89 d0                	mov    %edx,%eax
}
  80146e:	5d                   	pop    %ebp
  80146f:	c3                   	ret    

00801470 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801470:	55                   	push   %ebp
  801471:	89 e5                	mov    %esp,%ebp
  801473:	83 ec 04             	sub    $0x4,%esp
  801476:	8b 45 0c             	mov    0xc(%ebp),%eax
  801479:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  80147c:	eb 12                	jmp    801490 <strchr+0x20>
		if (*s == c)
  80147e:	8b 45 08             	mov    0x8(%ebp),%eax
  801481:	8a 00                	mov    (%eax),%al
  801483:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801486:	75 05                	jne    80148d <strchr+0x1d>
			return (char *) s;
  801488:	8b 45 08             	mov    0x8(%ebp),%eax
  80148b:	eb 11                	jmp    80149e <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  80148d:	ff 45 08             	incl   0x8(%ebp)
  801490:	8b 45 08             	mov    0x8(%ebp),%eax
  801493:	8a 00                	mov    (%eax),%al
  801495:	84 c0                	test   %al,%al
  801497:	75 e5                	jne    80147e <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  801499:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80149e:	c9                   	leave  
  80149f:	c3                   	ret    

008014a0 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8014a0:	55                   	push   %ebp
  8014a1:	89 e5                	mov    %esp,%ebp
  8014a3:	83 ec 04             	sub    $0x4,%esp
  8014a6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014a9:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8014ac:	eb 0d                	jmp    8014bb <strfind+0x1b>
		if (*s == c)
  8014ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8014b1:	8a 00                	mov    (%eax),%al
  8014b3:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8014b6:	74 0e                	je     8014c6 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8014b8:	ff 45 08             	incl   0x8(%ebp)
  8014bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8014be:	8a 00                	mov    (%eax),%al
  8014c0:	84 c0                	test   %al,%al
  8014c2:	75 ea                	jne    8014ae <strfind+0xe>
  8014c4:	eb 01                	jmp    8014c7 <strfind+0x27>
		if (*s == c)
			break;
  8014c6:	90                   	nop
	return (char *) s;
  8014c7:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8014ca:	c9                   	leave  
  8014cb:	c3                   	ret    

008014cc <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  8014cc:	55                   	push   %ebp
  8014cd:	89 e5                	mov    %esp,%ebp
  8014cf:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  8014d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8014d5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  8014d8:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  8014dc:	76 63                	jbe    801541 <memset+0x75>
		uint64 data_block = c;
  8014de:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014e1:	99                   	cltd   
  8014e2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8014e5:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  8014e8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014eb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8014ee:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  8014f2:	c1 e0 08             	shl    $0x8,%eax
  8014f5:	09 45 f0             	or     %eax,-0x10(%ebp)
  8014f8:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  8014fb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014fe:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801501:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  801505:	c1 e0 10             	shl    $0x10,%eax
  801508:	09 45 f0             	or     %eax,-0x10(%ebp)
  80150b:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  80150e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801511:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801514:	89 c2                	mov    %eax,%edx
  801516:	b8 00 00 00 00       	mov    $0x0,%eax
  80151b:	09 45 f0             	or     %eax,-0x10(%ebp)
  80151e:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  801521:	eb 18                	jmp    80153b <memset+0x6f>
			*p64++ = data_block, n -= 8;
  801523:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801526:	8d 41 08             	lea    0x8(%ecx),%eax
  801529:	89 45 fc             	mov    %eax,-0x4(%ebp)
  80152c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80152f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801532:	89 01                	mov    %eax,(%ecx)
  801534:	89 51 04             	mov    %edx,0x4(%ecx)
  801537:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  80153b:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  80153f:	77 e2                	ja     801523 <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  801541:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801545:	74 23                	je     80156a <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  801547:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80154a:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  80154d:	eb 0e                	jmp    80155d <memset+0x91>
			*p8++ = (uint8)c;
  80154f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801552:	8d 50 01             	lea    0x1(%eax),%edx
  801555:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801558:	8b 55 0c             	mov    0xc(%ebp),%edx
  80155b:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  80155d:	8b 45 10             	mov    0x10(%ebp),%eax
  801560:	8d 50 ff             	lea    -0x1(%eax),%edx
  801563:	89 55 10             	mov    %edx,0x10(%ebp)
  801566:	85 c0                	test   %eax,%eax
  801568:	75 e5                	jne    80154f <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  80156a:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80156d:	c9                   	leave  
  80156e:	c3                   	ret    

0080156f <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  80156f:	55                   	push   %ebp
  801570:	89 e5                	mov    %esp,%ebp
  801572:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  801575:	8b 45 0c             	mov    0xc(%ebp),%eax
  801578:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  80157b:	8b 45 08             	mov    0x8(%ebp),%eax
  80157e:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  801581:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801585:	76 24                	jbe    8015ab <memcpy+0x3c>
		while(n >= 8){
  801587:	eb 1c                	jmp    8015a5 <memcpy+0x36>
			*d64 = *s64;
  801589:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80158c:	8b 50 04             	mov    0x4(%eax),%edx
  80158f:	8b 00                	mov    (%eax),%eax
  801591:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801594:	89 01                	mov    %eax,(%ecx)
  801596:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  801599:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  80159d:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  8015a1:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  8015a5:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  8015a9:	77 de                	ja     801589 <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  8015ab:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8015af:	74 31                	je     8015e2 <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  8015b1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8015b4:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  8015b7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8015ba:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  8015bd:	eb 16                	jmp    8015d5 <memcpy+0x66>
			*d8++ = *s8++;
  8015bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015c2:	8d 50 01             	lea    0x1(%eax),%edx
  8015c5:	89 55 f0             	mov    %edx,-0x10(%ebp)
  8015c8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8015cb:	8d 4a 01             	lea    0x1(%edx),%ecx
  8015ce:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  8015d1:	8a 12                	mov    (%edx),%dl
  8015d3:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  8015d5:	8b 45 10             	mov    0x10(%ebp),%eax
  8015d8:	8d 50 ff             	lea    -0x1(%eax),%edx
  8015db:	89 55 10             	mov    %edx,0x10(%ebp)
  8015de:	85 c0                	test   %eax,%eax
  8015e0:	75 dd                	jne    8015bf <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  8015e2:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8015e5:	c9                   	leave  
  8015e6:	c3                   	ret    

008015e7 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  8015e7:	55                   	push   %ebp
  8015e8:	89 e5                	mov    %esp,%ebp
  8015ea:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8015ed:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015f0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8015f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8015f6:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  8015f9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8015fc:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8015ff:	73 50                	jae    801651 <memmove+0x6a>
  801601:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801604:	8b 45 10             	mov    0x10(%ebp),%eax
  801607:	01 d0                	add    %edx,%eax
  801609:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80160c:	76 43                	jbe    801651 <memmove+0x6a>
		s += n;
  80160e:	8b 45 10             	mov    0x10(%ebp),%eax
  801611:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801614:	8b 45 10             	mov    0x10(%ebp),%eax
  801617:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  80161a:	eb 10                	jmp    80162c <memmove+0x45>
			*--d = *--s;
  80161c:	ff 4d f8             	decl   -0x8(%ebp)
  80161f:	ff 4d fc             	decl   -0x4(%ebp)
  801622:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801625:	8a 10                	mov    (%eax),%dl
  801627:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80162a:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  80162c:	8b 45 10             	mov    0x10(%ebp),%eax
  80162f:	8d 50 ff             	lea    -0x1(%eax),%edx
  801632:	89 55 10             	mov    %edx,0x10(%ebp)
  801635:	85 c0                	test   %eax,%eax
  801637:	75 e3                	jne    80161c <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801639:	eb 23                	jmp    80165e <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  80163b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80163e:	8d 50 01             	lea    0x1(%eax),%edx
  801641:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801644:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801647:	8d 4a 01             	lea    0x1(%edx),%ecx
  80164a:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  80164d:	8a 12                	mov    (%edx),%dl
  80164f:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801651:	8b 45 10             	mov    0x10(%ebp),%eax
  801654:	8d 50 ff             	lea    -0x1(%eax),%edx
  801657:	89 55 10             	mov    %edx,0x10(%ebp)
  80165a:	85 c0                	test   %eax,%eax
  80165c:	75 dd                	jne    80163b <memmove+0x54>
			*d++ = *s++;

	return dst;
  80165e:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801661:	c9                   	leave  
  801662:	c3                   	ret    

00801663 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  801663:	55                   	push   %ebp
  801664:	89 e5                	mov    %esp,%ebp
  801666:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  801669:	8b 45 08             	mov    0x8(%ebp),%eax
  80166c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  80166f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801672:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  801675:	eb 2a                	jmp    8016a1 <memcmp+0x3e>
		if (*s1 != *s2)
  801677:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80167a:	8a 10                	mov    (%eax),%dl
  80167c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80167f:	8a 00                	mov    (%eax),%al
  801681:	38 c2                	cmp    %al,%dl
  801683:	74 16                	je     80169b <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801685:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801688:	8a 00                	mov    (%eax),%al
  80168a:	0f b6 d0             	movzbl %al,%edx
  80168d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801690:	8a 00                	mov    (%eax),%al
  801692:	0f b6 c0             	movzbl %al,%eax
  801695:	29 c2                	sub    %eax,%edx
  801697:	89 d0                	mov    %edx,%eax
  801699:	eb 18                	jmp    8016b3 <memcmp+0x50>
		s1++, s2++;
  80169b:	ff 45 fc             	incl   -0x4(%ebp)
  80169e:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  8016a1:	8b 45 10             	mov    0x10(%ebp),%eax
  8016a4:	8d 50 ff             	lea    -0x1(%eax),%edx
  8016a7:	89 55 10             	mov    %edx,0x10(%ebp)
  8016aa:	85 c0                	test   %eax,%eax
  8016ac:	75 c9                	jne    801677 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8016ae:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8016b3:	c9                   	leave  
  8016b4:	c3                   	ret    

008016b5 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  8016b5:	55                   	push   %ebp
  8016b6:	89 e5                	mov    %esp,%ebp
  8016b8:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  8016bb:	8b 55 08             	mov    0x8(%ebp),%edx
  8016be:	8b 45 10             	mov    0x10(%ebp),%eax
  8016c1:	01 d0                	add    %edx,%eax
  8016c3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  8016c6:	eb 15                	jmp    8016dd <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  8016c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8016cb:	8a 00                	mov    (%eax),%al
  8016cd:	0f b6 d0             	movzbl %al,%edx
  8016d0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016d3:	0f b6 c0             	movzbl %al,%eax
  8016d6:	39 c2                	cmp    %eax,%edx
  8016d8:	74 0d                	je     8016e7 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8016da:	ff 45 08             	incl   0x8(%ebp)
  8016dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8016e0:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8016e3:	72 e3                	jb     8016c8 <memfind+0x13>
  8016e5:	eb 01                	jmp    8016e8 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  8016e7:	90                   	nop
	return (void *) s;
  8016e8:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8016eb:	c9                   	leave  
  8016ec:	c3                   	ret    

008016ed <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8016ed:	55                   	push   %ebp
  8016ee:	89 e5                	mov    %esp,%ebp
  8016f0:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  8016f3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  8016fa:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801701:	eb 03                	jmp    801706 <strtol+0x19>
		s++;
  801703:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801706:	8b 45 08             	mov    0x8(%ebp),%eax
  801709:	8a 00                	mov    (%eax),%al
  80170b:	3c 20                	cmp    $0x20,%al
  80170d:	74 f4                	je     801703 <strtol+0x16>
  80170f:	8b 45 08             	mov    0x8(%ebp),%eax
  801712:	8a 00                	mov    (%eax),%al
  801714:	3c 09                	cmp    $0x9,%al
  801716:	74 eb                	je     801703 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801718:	8b 45 08             	mov    0x8(%ebp),%eax
  80171b:	8a 00                	mov    (%eax),%al
  80171d:	3c 2b                	cmp    $0x2b,%al
  80171f:	75 05                	jne    801726 <strtol+0x39>
		s++;
  801721:	ff 45 08             	incl   0x8(%ebp)
  801724:	eb 13                	jmp    801739 <strtol+0x4c>
	else if (*s == '-')
  801726:	8b 45 08             	mov    0x8(%ebp),%eax
  801729:	8a 00                	mov    (%eax),%al
  80172b:	3c 2d                	cmp    $0x2d,%al
  80172d:	75 0a                	jne    801739 <strtol+0x4c>
		s++, neg = 1;
  80172f:	ff 45 08             	incl   0x8(%ebp)
  801732:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801739:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80173d:	74 06                	je     801745 <strtol+0x58>
  80173f:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801743:	75 20                	jne    801765 <strtol+0x78>
  801745:	8b 45 08             	mov    0x8(%ebp),%eax
  801748:	8a 00                	mov    (%eax),%al
  80174a:	3c 30                	cmp    $0x30,%al
  80174c:	75 17                	jne    801765 <strtol+0x78>
  80174e:	8b 45 08             	mov    0x8(%ebp),%eax
  801751:	40                   	inc    %eax
  801752:	8a 00                	mov    (%eax),%al
  801754:	3c 78                	cmp    $0x78,%al
  801756:	75 0d                	jne    801765 <strtol+0x78>
		s += 2, base = 16;
  801758:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  80175c:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801763:	eb 28                	jmp    80178d <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801765:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801769:	75 15                	jne    801780 <strtol+0x93>
  80176b:	8b 45 08             	mov    0x8(%ebp),%eax
  80176e:	8a 00                	mov    (%eax),%al
  801770:	3c 30                	cmp    $0x30,%al
  801772:	75 0c                	jne    801780 <strtol+0x93>
		s++, base = 8;
  801774:	ff 45 08             	incl   0x8(%ebp)
  801777:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  80177e:	eb 0d                	jmp    80178d <strtol+0xa0>
	else if (base == 0)
  801780:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801784:	75 07                	jne    80178d <strtol+0xa0>
		base = 10;
  801786:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  80178d:	8b 45 08             	mov    0x8(%ebp),%eax
  801790:	8a 00                	mov    (%eax),%al
  801792:	3c 2f                	cmp    $0x2f,%al
  801794:	7e 19                	jle    8017af <strtol+0xc2>
  801796:	8b 45 08             	mov    0x8(%ebp),%eax
  801799:	8a 00                	mov    (%eax),%al
  80179b:	3c 39                	cmp    $0x39,%al
  80179d:	7f 10                	jg     8017af <strtol+0xc2>
			dig = *s - '0';
  80179f:	8b 45 08             	mov    0x8(%ebp),%eax
  8017a2:	8a 00                	mov    (%eax),%al
  8017a4:	0f be c0             	movsbl %al,%eax
  8017a7:	83 e8 30             	sub    $0x30,%eax
  8017aa:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8017ad:	eb 42                	jmp    8017f1 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  8017af:	8b 45 08             	mov    0x8(%ebp),%eax
  8017b2:	8a 00                	mov    (%eax),%al
  8017b4:	3c 60                	cmp    $0x60,%al
  8017b6:	7e 19                	jle    8017d1 <strtol+0xe4>
  8017b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8017bb:	8a 00                	mov    (%eax),%al
  8017bd:	3c 7a                	cmp    $0x7a,%al
  8017bf:	7f 10                	jg     8017d1 <strtol+0xe4>
			dig = *s - 'a' + 10;
  8017c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8017c4:	8a 00                	mov    (%eax),%al
  8017c6:	0f be c0             	movsbl %al,%eax
  8017c9:	83 e8 57             	sub    $0x57,%eax
  8017cc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8017cf:	eb 20                	jmp    8017f1 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  8017d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8017d4:	8a 00                	mov    (%eax),%al
  8017d6:	3c 40                	cmp    $0x40,%al
  8017d8:	7e 39                	jle    801813 <strtol+0x126>
  8017da:	8b 45 08             	mov    0x8(%ebp),%eax
  8017dd:	8a 00                	mov    (%eax),%al
  8017df:	3c 5a                	cmp    $0x5a,%al
  8017e1:	7f 30                	jg     801813 <strtol+0x126>
			dig = *s - 'A' + 10;
  8017e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8017e6:	8a 00                	mov    (%eax),%al
  8017e8:	0f be c0             	movsbl %al,%eax
  8017eb:	83 e8 37             	sub    $0x37,%eax
  8017ee:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  8017f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017f4:	3b 45 10             	cmp    0x10(%ebp),%eax
  8017f7:	7d 19                	jge    801812 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  8017f9:	ff 45 08             	incl   0x8(%ebp)
  8017fc:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8017ff:	0f af 45 10          	imul   0x10(%ebp),%eax
  801803:	89 c2                	mov    %eax,%edx
  801805:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801808:	01 d0                	add    %edx,%eax
  80180a:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  80180d:	e9 7b ff ff ff       	jmp    80178d <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801812:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801813:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801817:	74 08                	je     801821 <strtol+0x134>
		*endptr = (char *) s;
  801819:	8b 45 0c             	mov    0xc(%ebp),%eax
  80181c:	8b 55 08             	mov    0x8(%ebp),%edx
  80181f:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801821:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801825:	74 07                	je     80182e <strtol+0x141>
  801827:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80182a:	f7 d8                	neg    %eax
  80182c:	eb 03                	jmp    801831 <strtol+0x144>
  80182e:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801831:	c9                   	leave  
  801832:	c3                   	ret    

00801833 <ltostr>:

void
ltostr(long value, char *str)
{
  801833:	55                   	push   %ebp
  801834:	89 e5                	mov    %esp,%ebp
  801836:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801839:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801840:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801847:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80184b:	79 13                	jns    801860 <ltostr+0x2d>
	{
		neg = 1;
  80184d:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801854:	8b 45 0c             	mov    0xc(%ebp),%eax
  801857:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  80185a:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  80185d:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801860:	8b 45 08             	mov    0x8(%ebp),%eax
  801863:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801868:	99                   	cltd   
  801869:	f7 f9                	idiv   %ecx
  80186b:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  80186e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801871:	8d 50 01             	lea    0x1(%eax),%edx
  801874:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801877:	89 c2                	mov    %eax,%edx
  801879:	8b 45 0c             	mov    0xc(%ebp),%eax
  80187c:	01 d0                	add    %edx,%eax
  80187e:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801881:	83 c2 30             	add    $0x30,%edx
  801884:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801886:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801889:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80188e:	f7 e9                	imul   %ecx
  801890:	c1 fa 02             	sar    $0x2,%edx
  801893:	89 c8                	mov    %ecx,%eax
  801895:	c1 f8 1f             	sar    $0x1f,%eax
  801898:	29 c2                	sub    %eax,%edx
  80189a:	89 d0                	mov    %edx,%eax
  80189c:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  80189f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8018a3:	75 bb                	jne    801860 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8018a5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8018ac:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8018af:	48                   	dec    %eax
  8018b0:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8018b3:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8018b7:	74 3d                	je     8018f6 <ltostr+0xc3>
		start = 1 ;
  8018b9:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8018c0:	eb 34                	jmp    8018f6 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  8018c2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8018c5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018c8:	01 d0                	add    %edx,%eax
  8018ca:	8a 00                	mov    (%eax),%al
  8018cc:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8018cf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8018d2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018d5:	01 c2                	add    %eax,%edx
  8018d7:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8018da:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018dd:	01 c8                	add    %ecx,%eax
  8018df:	8a 00                	mov    (%eax),%al
  8018e1:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8018e3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8018e6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018e9:	01 c2                	add    %eax,%edx
  8018eb:	8a 45 eb             	mov    -0x15(%ebp),%al
  8018ee:	88 02                	mov    %al,(%edx)
		start++ ;
  8018f0:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8018f3:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8018f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018f9:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8018fc:	7c c4                	jl     8018c2 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8018fe:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801901:	8b 45 0c             	mov    0xc(%ebp),%eax
  801904:	01 d0                	add    %edx,%eax
  801906:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801909:	90                   	nop
  80190a:	c9                   	leave  
  80190b:	c3                   	ret    

0080190c <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  80190c:	55                   	push   %ebp
  80190d:	89 e5                	mov    %esp,%ebp
  80190f:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801912:	ff 75 08             	pushl  0x8(%ebp)
  801915:	e8 c4 f9 ff ff       	call   8012de <strlen>
  80191a:	83 c4 04             	add    $0x4,%esp
  80191d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801920:	ff 75 0c             	pushl  0xc(%ebp)
  801923:	e8 b6 f9 ff ff       	call   8012de <strlen>
  801928:	83 c4 04             	add    $0x4,%esp
  80192b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  80192e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801935:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80193c:	eb 17                	jmp    801955 <strcconcat+0x49>
		final[s] = str1[s] ;
  80193e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801941:	8b 45 10             	mov    0x10(%ebp),%eax
  801944:	01 c2                	add    %eax,%edx
  801946:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801949:	8b 45 08             	mov    0x8(%ebp),%eax
  80194c:	01 c8                	add    %ecx,%eax
  80194e:	8a 00                	mov    (%eax),%al
  801950:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801952:	ff 45 fc             	incl   -0x4(%ebp)
  801955:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801958:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80195b:	7c e1                	jl     80193e <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  80195d:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801964:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  80196b:	eb 1f                	jmp    80198c <strcconcat+0x80>
		final[s++] = str2[i] ;
  80196d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801970:	8d 50 01             	lea    0x1(%eax),%edx
  801973:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801976:	89 c2                	mov    %eax,%edx
  801978:	8b 45 10             	mov    0x10(%ebp),%eax
  80197b:	01 c2                	add    %eax,%edx
  80197d:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801980:	8b 45 0c             	mov    0xc(%ebp),%eax
  801983:	01 c8                	add    %ecx,%eax
  801985:	8a 00                	mov    (%eax),%al
  801987:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801989:	ff 45 f8             	incl   -0x8(%ebp)
  80198c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80198f:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801992:	7c d9                	jl     80196d <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801994:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801997:	8b 45 10             	mov    0x10(%ebp),%eax
  80199a:	01 d0                	add    %edx,%eax
  80199c:	c6 00 00             	movb   $0x0,(%eax)
}
  80199f:	90                   	nop
  8019a0:	c9                   	leave  
  8019a1:	c3                   	ret    

008019a2 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8019a2:	55                   	push   %ebp
  8019a3:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8019a5:	8b 45 14             	mov    0x14(%ebp),%eax
  8019a8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8019ae:	8b 45 14             	mov    0x14(%ebp),%eax
  8019b1:	8b 00                	mov    (%eax),%eax
  8019b3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8019ba:	8b 45 10             	mov    0x10(%ebp),%eax
  8019bd:	01 d0                	add    %edx,%eax
  8019bf:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8019c5:	eb 0c                	jmp    8019d3 <strsplit+0x31>
			*string++ = 0;
  8019c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ca:	8d 50 01             	lea    0x1(%eax),%edx
  8019cd:	89 55 08             	mov    %edx,0x8(%ebp)
  8019d0:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8019d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8019d6:	8a 00                	mov    (%eax),%al
  8019d8:	84 c0                	test   %al,%al
  8019da:	74 18                	je     8019f4 <strsplit+0x52>
  8019dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8019df:	8a 00                	mov    (%eax),%al
  8019e1:	0f be c0             	movsbl %al,%eax
  8019e4:	50                   	push   %eax
  8019e5:	ff 75 0c             	pushl  0xc(%ebp)
  8019e8:	e8 83 fa ff ff       	call   801470 <strchr>
  8019ed:	83 c4 08             	add    $0x8,%esp
  8019f0:	85 c0                	test   %eax,%eax
  8019f2:	75 d3                	jne    8019c7 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8019f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8019f7:	8a 00                	mov    (%eax),%al
  8019f9:	84 c0                	test   %al,%al
  8019fb:	74 5a                	je     801a57 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8019fd:	8b 45 14             	mov    0x14(%ebp),%eax
  801a00:	8b 00                	mov    (%eax),%eax
  801a02:	83 f8 0f             	cmp    $0xf,%eax
  801a05:	75 07                	jne    801a0e <strsplit+0x6c>
		{
			return 0;
  801a07:	b8 00 00 00 00       	mov    $0x0,%eax
  801a0c:	eb 66                	jmp    801a74 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801a0e:	8b 45 14             	mov    0x14(%ebp),%eax
  801a11:	8b 00                	mov    (%eax),%eax
  801a13:	8d 48 01             	lea    0x1(%eax),%ecx
  801a16:	8b 55 14             	mov    0x14(%ebp),%edx
  801a19:	89 0a                	mov    %ecx,(%edx)
  801a1b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801a22:	8b 45 10             	mov    0x10(%ebp),%eax
  801a25:	01 c2                	add    %eax,%edx
  801a27:	8b 45 08             	mov    0x8(%ebp),%eax
  801a2a:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801a2c:	eb 03                	jmp    801a31 <strsplit+0x8f>
			string++;
  801a2e:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801a31:	8b 45 08             	mov    0x8(%ebp),%eax
  801a34:	8a 00                	mov    (%eax),%al
  801a36:	84 c0                	test   %al,%al
  801a38:	74 8b                	je     8019c5 <strsplit+0x23>
  801a3a:	8b 45 08             	mov    0x8(%ebp),%eax
  801a3d:	8a 00                	mov    (%eax),%al
  801a3f:	0f be c0             	movsbl %al,%eax
  801a42:	50                   	push   %eax
  801a43:	ff 75 0c             	pushl  0xc(%ebp)
  801a46:	e8 25 fa ff ff       	call   801470 <strchr>
  801a4b:	83 c4 08             	add    $0x8,%esp
  801a4e:	85 c0                	test   %eax,%eax
  801a50:	74 dc                	je     801a2e <strsplit+0x8c>
			string++;
	}
  801a52:	e9 6e ff ff ff       	jmp    8019c5 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801a57:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801a58:	8b 45 14             	mov    0x14(%ebp),%eax
  801a5b:	8b 00                	mov    (%eax),%eax
  801a5d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801a64:	8b 45 10             	mov    0x10(%ebp),%eax
  801a67:	01 d0                	add    %edx,%eax
  801a69:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801a6f:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801a74:	c9                   	leave  
  801a75:	c3                   	ret    

00801a76 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  801a76:	55                   	push   %ebp
  801a77:	89 e5                	mov    %esp,%ebp
  801a79:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  801a7c:	8b 45 08             	mov    0x8(%ebp),%eax
  801a7f:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  801a82:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801a89:	eb 4a                	jmp    801ad5 <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  801a8b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801a8e:	8b 45 08             	mov    0x8(%ebp),%eax
  801a91:	01 c2                	add    %eax,%edx
  801a93:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801a96:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a99:	01 c8                	add    %ecx,%eax
  801a9b:	8a 00                	mov    (%eax),%al
  801a9d:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  801a9f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801aa2:	8b 45 0c             	mov    0xc(%ebp),%eax
  801aa5:	01 d0                	add    %edx,%eax
  801aa7:	8a 00                	mov    (%eax),%al
  801aa9:	3c 40                	cmp    $0x40,%al
  801aab:	7e 25                	jle    801ad2 <str2lower+0x5c>
  801aad:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801ab0:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ab3:	01 d0                	add    %edx,%eax
  801ab5:	8a 00                	mov    (%eax),%al
  801ab7:	3c 5a                	cmp    $0x5a,%al
  801ab9:	7f 17                	jg     801ad2 <str2lower+0x5c>
		{
			dst[i] += 32 ;
  801abb:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801abe:	8b 45 08             	mov    0x8(%ebp),%eax
  801ac1:	01 d0                	add    %edx,%eax
  801ac3:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801ac6:	8b 55 08             	mov    0x8(%ebp),%edx
  801ac9:	01 ca                	add    %ecx,%edx
  801acb:	8a 12                	mov    (%edx),%dl
  801acd:	83 c2 20             	add    $0x20,%edx
  801ad0:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  801ad2:	ff 45 fc             	incl   -0x4(%ebp)
  801ad5:	ff 75 0c             	pushl  0xc(%ebp)
  801ad8:	e8 01 f8 ff ff       	call   8012de <strlen>
  801add:	83 c4 04             	add    $0x4,%esp
  801ae0:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801ae3:	7f a6                	jg     801a8b <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  801ae5:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801ae8:	c9                   	leave  
  801ae9:	c3                   	ret    

00801aea <uheap_init>:
//==============================================
// [1] INITIALIZE USER HEAP:
//==============================================
int __firstTimeFlag = 1;
void uheap_init()
{
  801aea:	55                   	push   %ebp
  801aeb:	89 e5                	mov    %esp,%ebp
  801aed:	83 ec 08             	sub    $0x8,%esp
	if(__firstTimeFlag)
  801af0:	a1 08 60 80 00       	mov    0x806008,%eax
  801af5:	85 c0                	test   %eax,%eax
  801af7:	0f 84 95 00 00 00    	je     801b92 <uheap_init+0xa8>
	{
		initialize_dynamic_allocator(USER_HEAP_START, USER_HEAP_START + DYN_ALLOC_MAX_SIZE);
  801afd:	83 ec 08             	sub    $0x8,%esp
  801b00:	68 00 00 00 82       	push   $0x82000000
  801b05:	68 00 00 00 80       	push   $0x80000000
  801b0a:	e8 59 1f 00 00       	call   803a68 <initialize_dynamic_allocator>
  801b0f:	83 c4 10             	add    $0x10,%esp
		uheapPlaceStrategy = sys_get_uheap_strategy();
  801b12:	e8 93 1d 00 00       	call   8038aa <sys_get_uheap_strategy>
  801b17:	a3 60 e0 81 00       	mov    %eax,0x81e060
		uheapPageAllocStart = dynAllocEnd + PAGE_SIZE;
  801b1c:	a1 40 60 80 00       	mov    0x806040,%eax
  801b21:	05 00 10 00 00       	add    $0x1000,%eax
  801b26:	a3 10 e1 81 00       	mov    %eax,0x81e110
		uheapPageAllocBreak = uheapPageAllocStart;
  801b2b:	a1 10 e1 81 00       	mov    0x81e110,%eax
  801b30:	a3 68 e0 81 00       	mov    %eax,0x81e068
		init_uspinlock(&ulock,"malloc",1);
  801b35:	83 ec 04             	sub    $0x4,%esp
  801b38:	6a 01                	push   $0x1
  801b3a:	68 08 50 80 00       	push   $0x805008
  801b3f:	68 40 e1 81 00       	push   $0x81e140
  801b44:	e8 1a 29 00 00       	call   804463 <init_uspinlock>
  801b49:	83 c4 10             	add    $0x10,%esp
		LIST_INIT(&u_freelist);
  801b4c:	c7 05 20 e1 81 00 00 	movl   $0x0,0x81e120
  801b53:	00 00 00 
  801b56:	c7 05 24 e1 81 00 00 	movl   $0x0,0x81e124
  801b5d:	00 00 00 
  801b60:	c7 05 2c e1 81 00 00 	movl   $0x0,0x81e12c
  801b67:	00 00 00 
		LIST_INIT(&u_allocatedlist);
  801b6a:	c7 05 30 e1 81 00 00 	movl   $0x0,0x81e130
  801b71:	00 00 00 
  801b74:	c7 05 34 e1 81 00 00 	movl   $0x0,0x81e134
  801b7b:	00 00 00 
  801b7e:	c7 05 3c e1 81 00 00 	movl   $0x0,0x81e13c
  801b85:	00 00 00 
		__firstTimeFlag = 0;
  801b88:	c7 05 08 60 80 00 00 	movl   $0x0,0x806008
  801b8f:	00 00 00 
	}
}
  801b92:	90                   	nop
  801b93:	c9                   	leave  
  801b94:	c3                   	ret    

00801b95 <get_page>:

//==============================================
// [2] GET A PAGE FROM THE KERNEL FOR DA:
//==============================================
int get_page(void* va)
{
  801b95:	55                   	push   %ebp
  801b96:	89 e5                	mov    %esp,%ebp
  801b98:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_allocate_page(ROUNDDOWN(va, PAGE_SIZE), PERM_USER|PERM_WRITEABLE|PERM_UHPAGE);
  801b9b:	8b 45 08             	mov    0x8(%ebp),%eax
  801b9e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801ba1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ba4:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801ba9:	83 ec 08             	sub    $0x8,%esp
  801bac:	68 06 04 00 00       	push   $0x406
  801bb1:	50                   	push   %eax
  801bb2:	e8 3d 19 00 00       	call   8034f4 <__sys_allocate_page>
  801bb7:	83 c4 10             	add    $0x10,%esp
  801bba:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  801bbd:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801bc1:	79 14                	jns    801bd7 <get_page+0x42>
		panic("get_page() in user: failed to allocate page from the kernel");
  801bc3:	83 ec 04             	sub    $0x4,%esp
  801bc6:	68 10 50 80 00       	push   $0x805010
  801bcb:	6a 2d                	push   $0x2d
  801bcd:	68 4c 50 80 00       	push   $0x80504c
  801bd2:	e8 60 ed ff ff       	call   800937 <_panic>
	return 0;
  801bd7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801bdc:	c9                   	leave  
  801bdd:	c3                   	ret    

00801bde <return_page>:

//==============================================
// [3] RETURN A PAGE FROM THE DA TO KERNEL:
//==============================================
void return_page(void* va)
{
  801bde:	55                   	push   %ebp
  801bdf:	89 e5                	mov    %esp,%ebp
  801be1:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_unmap_frame(ROUNDDOWN((uint32)va, PAGE_SIZE));
  801be4:	8b 45 08             	mov    0x8(%ebp),%eax
  801be7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801bea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bed:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801bf2:	83 ec 0c             	sub    $0xc,%esp
  801bf5:	50                   	push   %eax
  801bf6:	e8 40 19 00 00       	call   80353b <__sys_unmap_frame>
  801bfb:	83 c4 10             	add    $0x10,%esp
  801bfe:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  801c01:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801c05:	79 14                	jns    801c1b <return_page+0x3d>
		panic("return_page() in user: failed to return a page to the kernel");
  801c07:	83 ec 04             	sub    $0x4,%esp
  801c0a:	68 58 50 80 00       	push   $0x805058
  801c0f:	6a 38                	push   $0x38
  801c11:	68 4c 50 80 00       	push   $0x80504c
  801c16:	e8 1c ed ff ff       	call   800937 <_panic>
}
  801c1b:	90                   	nop
  801c1c:	c9                   	leave  
  801c1d:	c3                   	ret    

00801c1e <malloc>:

//=================================
// [1] ALLOCATE SPACE IN USER HEAP:
//=================================
void* malloc(uint32 size)
{
  801c1e:	55                   	push   %ebp
  801c1f:	89 e5                	mov    %esp,%ebp
  801c21:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  801c24:	e8 c1 fe ff ff       	call   801aea <uheap_init>
	if (size == 0) return NULL ;
  801c29:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801c2d:	75 0a                	jne    801c39 <malloc+0x1b>
  801c2f:	b8 00 00 00 00       	mov    $0x0,%eax
  801c34:	e9 e1 04 00 00       	jmp    80211a <malloc+0x4fc>
	//==============================================================

	acquire_uspinlock(&ulock);
  801c39:	83 ec 0c             	sub    $0xc,%esp
  801c3c:	68 40 e1 81 00       	push   $0x81e140
  801c41:	e8 6c 28 00 00       	call   8044b2 <acquire_uspinlock>
  801c46:	83 c4 10             	add    $0x10,%esp
	if(size <  DYN_ALLOC_MAX_BLOCK_SIZE){
  801c49:	81 7d 08 ff 07 00 00 	cmpl   $0x7ff,0x8(%ebp)
  801c50:	77 23                	ja     801c75 <malloc+0x57>
		release_uspinlock(&ulock);
  801c52:	83 ec 0c             	sub    $0xc,%esp
  801c55:	68 40 e1 81 00       	push   $0x81e140
  801c5a:	e8 ab 28 00 00       	call   80450a <release_uspinlock>
  801c5f:	83 c4 10             	add    $0x10,%esp
		return alloc_block(size);
  801c62:	83 ec 0c             	sub    $0xc,%esp
  801c65:	ff 75 08             	pushl  0x8(%ebp)
  801c68:	e8 dd 1f 00 00       	call   803c4a <alloc_block>
  801c6d:	83 c4 10             	add    $0x10,%esp
  801c70:	e9 a5 04 00 00       	jmp    80211a <malloc+0x4fc>
	}

	struct UserHeapStruct* allocblock= (struct UserHeapStruct*) alloc_block(sizeof(struct UserHeapStruct));
  801c75:	83 ec 0c             	sub    $0xc,%esp
  801c78:	6a 10                	push   $0x10
  801c7a:	e8 cb 1f 00 00       	call   803c4a <alloc_block>
  801c7f:	83 c4 10             	add    $0x10,%esp
  801c82:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (allocblock == NULL){
  801c85:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801c89:	75 0a                	jne    801c95 <malloc+0x77>
			return NULL;
  801c8b:	b8 00 00 00 00       	mov    $0x0,%eax
  801c90:	e9 85 04 00 00       	jmp    80211a <malloc+0x4fc>
	}

	size = ROUNDUP(size,PAGE_SIZE);
  801c95:	c7 45 e8 00 10 00 00 	movl   $0x1000,-0x18(%ebp)
  801c9c:	8b 55 08             	mov    0x8(%ebp),%edx
  801c9f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801ca2:	01 d0                	add    %edx,%eax
  801ca4:	48                   	dec    %eax
  801ca5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801ca8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801cab:	ba 00 00 00 00       	mov    $0x0,%edx
  801cb0:	f7 75 e8             	divl   -0x18(%ebp)
  801cb3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801cb6:	29 d0                	sub    %edx,%eax
  801cb8:	89 45 08             	mov    %eax,0x8(%ebp)
	struct UserHeapStruct* lastfreeelement = LIST_LAST(&u_freelist);
  801cbb:	a1 24 e1 81 00       	mov    0x81e124,%eax
  801cc0:	89 45 e0             	mov    %eax,-0x20(%ebp)

	if(LIST_SIZE(&u_freelist)==0 || size>lastfreeelement->size){
  801cc3:	a1 2c e1 81 00       	mov    0x81e12c,%eax
  801cc8:	85 c0                	test   %eax,%eax
  801cca:	74 0f                	je     801cdb <malloc+0xbd>
  801ccc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801ccf:	8b 40 04             	mov    0x4(%eax),%eax
  801cd2:	3b 45 08             	cmp    0x8(%ebp),%eax
  801cd5:	0f 83 ea 00 00 00    	jae    801dc5 <malloc+0x1a7>
			if(uheapPageAllocBreak < USER_HEAP_MAX - size){
  801cdb:	b8 00 00 00 a0       	mov    $0xa0000000,%eax
  801ce0:	2b 45 08             	sub    0x8(%ebp),%eax
  801ce3:	89 c2                	mov    %eax,%edx
  801ce5:	a1 68 e0 81 00       	mov    0x81e068,%eax
  801cea:	39 c2                	cmp    %eax,%edx
  801cec:	0f 86 b9 00 00 00    	jbe    801dab <malloc+0x18d>
					uint32 requestedblockva = uheapPageAllocBreak;
  801cf2:	a1 68 e0 81 00       	mov    0x81e068,%eax
  801cf7:	89 45 dc             	mov    %eax,-0x24(%ebp)
					uheapPageAllocBreak+=size;
  801cfa:	8b 15 68 e0 81 00    	mov    0x81e068,%edx
  801d00:	8b 45 08             	mov    0x8(%ebp),%eax
  801d03:	01 d0                	add    %edx,%eax
  801d05:	a3 68 e0 81 00       	mov    %eax,0x81e068
					allocblock->startva = requestedblockva;
  801d0a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801d0d:	8b 55 dc             	mov    -0x24(%ebp),%edx
  801d10:	89 10                	mov    %edx,(%eax)
					allocblock->size = size;
  801d12:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801d15:	8b 55 08             	mov    0x8(%ebp),%edx
  801d18:	89 50 04             	mov    %edx,0x4(%eax)

					LIST_INSERT_TAIL(&u_allocatedlist, allocblock);
  801d1b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801d1f:	75 14                	jne    801d35 <malloc+0x117>
  801d21:	83 ec 04             	sub    $0x4,%esp
  801d24:	68 98 50 80 00       	push   $0x805098
  801d29:	6a 60                	push   $0x60
  801d2b:	68 4c 50 80 00       	push   $0x80504c
  801d30:	e8 02 ec ff ff       	call   800937 <_panic>
  801d35:	8b 15 34 e1 81 00    	mov    0x81e134,%edx
  801d3b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801d3e:	89 50 0c             	mov    %edx,0xc(%eax)
  801d41:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801d44:	8b 40 0c             	mov    0xc(%eax),%eax
  801d47:	85 c0                	test   %eax,%eax
  801d49:	74 0d                	je     801d58 <malloc+0x13a>
  801d4b:	a1 34 e1 81 00       	mov    0x81e134,%eax
  801d50:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801d53:	89 50 08             	mov    %edx,0x8(%eax)
  801d56:	eb 08                	jmp    801d60 <malloc+0x142>
  801d58:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801d5b:	a3 30 e1 81 00       	mov    %eax,0x81e130
  801d60:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801d63:	a3 34 e1 81 00       	mov    %eax,0x81e134
  801d68:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801d6b:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  801d72:	a1 3c e1 81 00       	mov    0x81e13c,%eax
  801d77:	40                   	inc    %eax
  801d78:	a3 3c e1 81 00       	mov    %eax,0x81e13c


					sys_allocate_user_mem(allocblock->startva ,size);
  801d7d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801d80:	8b 00                	mov    (%eax),%eax
  801d82:	83 ec 08             	sub    $0x8,%esp
  801d85:	ff 75 08             	pushl  0x8(%ebp)
  801d88:	50                   	push   %eax
  801d89:	e8 34 1c 00 00       	call   8039c2 <sys_allocate_user_mem>
  801d8e:	83 c4 10             	add    $0x10,%esp
					release_uspinlock(&ulock);
  801d91:	83 ec 0c             	sub    $0xc,%esp
  801d94:	68 40 e1 81 00       	push   $0x81e140
  801d99:	e8 6c 27 00 00       	call   80450a <release_uspinlock>
  801d9e:	83 c4 10             	add    $0x10,%esp
					return (void*)allocblock->startva;
  801da1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801da4:	8b 00                	mov    (%eax),%eax
  801da6:	e9 6f 03 00 00       	jmp    80211a <malloc+0x4fc>
			}else{
					release_uspinlock(&ulock);
  801dab:	83 ec 0c             	sub    $0xc,%esp
  801dae:	68 40 e1 81 00       	push   $0x81e140
  801db3:	e8 52 27 00 00       	call   80450a <release_uspinlock>
  801db8:	83 c4 10             	add    $0x10,%esp
					return NULL;
  801dbb:	b8 00 00 00 00       	mov    $0x0,%eax
  801dc0:	e9 55 03 00 00       	jmp    80211a <malloc+0x4fc>
				}
	}else{
		//custom fit
		struct UserHeapStruct* currentfreeelement = LIST_FIRST(&u_freelist);
  801dc5:	a1 20 e1 81 00       	mov    0x81e120,%eax
  801dca:	89 45 f4             	mov    %eax,-0xc(%ebp)
		//worst fit
		while(currentfreeelement != NULL){
  801dcd:	e9 39 03 00 00       	jmp    80210b <malloc+0x4ed>
			if(size<currentfreeelement->size){
  801dd2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dd5:	8b 40 04             	mov    0x4(%eax),%eax
  801dd8:	3b 45 08             	cmp    0x8(%ebp),%eax
  801ddb:	0f 86 e7 01 00 00    	jbe    801fc8 <malloc+0x3aa>
				allocblock->startva = lastfreeelement->startva;
  801de1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801de4:	8b 10                	mov    (%eax),%edx
  801de6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801de9:	89 10                	mov    %edx,(%eax)
                allocblock->size = size;
  801deb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801dee:	8b 55 08             	mov    0x8(%ebp),%edx
  801df1:	89 50 04             	mov    %edx,0x4(%eax)
                LIST_INSERT_TAIL(&u_allocatedlist,allocblock);
  801df4:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801df8:	75 14                	jne    801e0e <malloc+0x1f0>
  801dfa:	83 ec 04             	sub    $0x4,%esp
  801dfd:	68 98 50 80 00       	push   $0x805098
  801e02:	6a 72                	push   $0x72
  801e04:	68 4c 50 80 00       	push   $0x80504c
  801e09:	e8 29 eb ff ff       	call   800937 <_panic>
  801e0e:	8b 15 34 e1 81 00    	mov    0x81e134,%edx
  801e14:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801e17:	89 50 0c             	mov    %edx,0xc(%eax)
  801e1a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801e1d:	8b 40 0c             	mov    0xc(%eax),%eax
  801e20:	85 c0                	test   %eax,%eax
  801e22:	74 0d                	je     801e31 <malloc+0x213>
  801e24:	a1 34 e1 81 00       	mov    0x81e134,%eax
  801e29:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801e2c:	89 50 08             	mov    %edx,0x8(%eax)
  801e2f:	eb 08                	jmp    801e39 <malloc+0x21b>
  801e31:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801e34:	a3 30 e1 81 00       	mov    %eax,0x81e130
  801e39:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801e3c:	a3 34 e1 81 00       	mov    %eax,0x81e134
  801e41:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801e44:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  801e4b:	a1 3c e1 81 00       	mov    0x81e13c,%eax
  801e50:	40                   	inc    %eax
  801e51:	a3 3c e1 81 00       	mov    %eax,0x81e13c
                lastfreeelement->startva += size;
  801e56:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801e59:	8b 10                	mov    (%eax),%edx
  801e5b:	8b 45 08             	mov    0x8(%ebp),%eax
  801e5e:	01 c2                	add    %eax,%edx
  801e60:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801e63:	89 10                	mov    %edx,(%eax)
                lastfreeelement->size -= size;
  801e65:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801e68:	8b 40 04             	mov    0x4(%eax),%eax
  801e6b:	2b 45 08             	sub    0x8(%ebp),%eax
  801e6e:	89 c2                	mov    %eax,%edx
  801e70:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801e73:	89 50 04             	mov    %edx,0x4(%eax)
                struct UserHeapStruct* currentfree2 = LIST_FIRST(&u_freelist);
  801e76:	a1 20 e1 81 00       	mov    0x81e120,%eax
  801e7b:	89 45 f0             	mov    %eax,-0x10(%ebp)
                //check order of last element

                while (currentfree2 != NULL){
  801e7e:	e9 0d 01 00 00       	jmp    801f90 <malloc+0x372>
                	if(lastfreeelement->size <currentfree2->size){
  801e83:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801e86:	8b 50 04             	mov    0x4(%eax),%edx
  801e89:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e8c:	8b 40 04             	mov    0x4(%eax),%eax
  801e8f:	39 c2                	cmp    %eax,%edx
  801e91:	0f 83 f0 00 00 00    	jae    801f87 <malloc+0x369>
                		LIST_REMOVE(&u_freelist ,lastfreeelement);
  801e97:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801e9b:	75 14                	jne    801eb1 <malloc+0x293>
  801e9d:	83 ec 04             	sub    $0x4,%esp
  801ea0:	68 bb 50 80 00       	push   $0x8050bb
  801ea5:	6a 7a                	push   $0x7a
  801ea7:	68 4c 50 80 00       	push   $0x80504c
  801eac:	e8 86 ea ff ff       	call   800937 <_panic>
  801eb1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801eb4:	8b 40 08             	mov    0x8(%eax),%eax
  801eb7:	85 c0                	test   %eax,%eax
  801eb9:	74 11                	je     801ecc <malloc+0x2ae>
  801ebb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801ebe:	8b 40 08             	mov    0x8(%eax),%eax
  801ec1:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801ec4:	8b 52 0c             	mov    0xc(%edx),%edx
  801ec7:	89 50 0c             	mov    %edx,0xc(%eax)
  801eca:	eb 0b                	jmp    801ed7 <malloc+0x2b9>
  801ecc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801ecf:	8b 40 0c             	mov    0xc(%eax),%eax
  801ed2:	a3 24 e1 81 00       	mov    %eax,0x81e124
  801ed7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801eda:	8b 40 0c             	mov    0xc(%eax),%eax
  801edd:	85 c0                	test   %eax,%eax
  801edf:	74 11                	je     801ef2 <malloc+0x2d4>
  801ee1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801ee4:	8b 40 0c             	mov    0xc(%eax),%eax
  801ee7:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801eea:	8b 52 08             	mov    0x8(%edx),%edx
  801eed:	89 50 08             	mov    %edx,0x8(%eax)
  801ef0:	eb 0b                	jmp    801efd <malloc+0x2df>
  801ef2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801ef5:	8b 40 08             	mov    0x8(%eax),%eax
  801ef8:	a3 20 e1 81 00       	mov    %eax,0x81e120
  801efd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801f00:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  801f07:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801f0a:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  801f11:	a1 2c e1 81 00       	mov    0x81e12c,%eax
  801f16:	48                   	dec    %eax
  801f17:	a3 2c e1 81 00       	mov    %eax,0x81e12c
                		LIST_INSERT_BEFORE(&u_freelist ,currentfree2 ,lastfreeelement);
  801f1c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801f20:	74 06                	je     801f28 <malloc+0x30a>
  801f22:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801f26:	75 14                	jne    801f3c <malloc+0x31e>
  801f28:	83 ec 04             	sub    $0x4,%esp
  801f2b:	68 dc 50 80 00       	push   $0x8050dc
  801f30:	6a 7b                	push   $0x7b
  801f32:	68 4c 50 80 00       	push   $0x80504c
  801f37:	e8 fb e9 ff ff       	call   800937 <_panic>
  801f3c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f3f:	8b 50 0c             	mov    0xc(%eax),%edx
  801f42:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801f45:	89 50 0c             	mov    %edx,0xc(%eax)
  801f48:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801f4b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801f4e:	89 50 08             	mov    %edx,0x8(%eax)
  801f51:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f54:	8b 40 0c             	mov    0xc(%eax),%eax
  801f57:	85 c0                	test   %eax,%eax
  801f59:	74 0e                	je     801f69 <malloc+0x34b>
  801f5b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f5e:	8b 40 0c             	mov    0xc(%eax),%eax
  801f61:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801f64:	89 50 08             	mov    %edx,0x8(%eax)
  801f67:	eb 08                	jmp    801f71 <malloc+0x353>
  801f69:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801f6c:	a3 20 e1 81 00       	mov    %eax,0x81e120
  801f71:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f74:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801f77:	89 50 0c             	mov    %edx,0xc(%eax)
  801f7a:	a1 2c e1 81 00       	mov    0x81e12c,%eax
  801f7f:	40                   	inc    %eax
  801f80:	a3 2c e1 81 00       	mov    %eax,0x81e12c
                		break;
  801f85:	eb 13                	jmp    801f9a <malloc+0x37c>
                	}
                	currentfree2 = currentfree2->prev_next_info.le_next;
  801f87:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f8a:	8b 40 08             	mov    0x8(%eax),%eax
  801f8d:	89 45 f0             	mov    %eax,-0x10(%ebp)
                lastfreeelement->startva += size;
                lastfreeelement->size -= size;
                struct UserHeapStruct* currentfree2 = LIST_FIRST(&u_freelist);
                //check order of last element

                while (currentfree2 != NULL){
  801f90:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801f94:	0f 85 e9 fe ff ff    	jne    801e83 <malloc+0x265>
                	}
                	currentfree2 = currentfree2->prev_next_info.le_next;
                }


                sys_allocate_user_mem(allocblock->startva ,size);
  801f9a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f9d:	8b 00                	mov    (%eax),%eax
  801f9f:	83 ec 08             	sub    $0x8,%esp
  801fa2:	ff 75 08             	pushl  0x8(%ebp)
  801fa5:	50                   	push   %eax
  801fa6:	e8 17 1a 00 00       	call   8039c2 <sys_allocate_user_mem>
  801fab:	83 c4 10             	add    $0x10,%esp
                release_uspinlock(&ulock);
  801fae:	83 ec 0c             	sub    $0xc,%esp
  801fb1:	68 40 e1 81 00       	push   $0x81e140
  801fb6:	e8 4f 25 00 00       	call   80450a <release_uspinlock>
  801fbb:	83 c4 10             	add    $0x10,%esp
                return (void*)allocblock->startva;
  801fbe:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801fc1:	8b 00                	mov    (%eax),%eax
  801fc3:	e9 52 01 00 00       	jmp    80211a <malloc+0x4fc>
                //exact fit
			}else if(size == currentfreeelement->size){
  801fc8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fcb:	8b 40 04             	mov    0x4(%eax),%eax
  801fce:	3b 45 08             	cmp    0x8(%ebp),%eax
  801fd1:	0f 85 2b 01 00 00    	jne    802102 <malloc+0x4e4>
				allocblock->startva = currentfreeelement->startva;
  801fd7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fda:	8b 10                	mov    (%eax),%edx
  801fdc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801fdf:	89 10                	mov    %edx,(%eax)
				allocblock->size = size;
  801fe1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801fe4:	8b 55 08             	mov    0x8(%ebp),%edx
  801fe7:	89 50 04             	mov    %edx,0x4(%eax)
				LIST_INSERT_TAIL(&u_allocatedlist ,allocblock);
  801fea:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801fee:	75 17                	jne    802007 <malloc+0x3e9>
  801ff0:	83 ec 04             	sub    $0x4,%esp
  801ff3:	68 98 50 80 00       	push   $0x805098
  801ff8:	68 89 00 00 00       	push   $0x89
  801ffd:	68 4c 50 80 00       	push   $0x80504c
  802002:	e8 30 e9 ff ff       	call   800937 <_panic>
  802007:	8b 15 34 e1 81 00    	mov    0x81e134,%edx
  80200d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802010:	89 50 0c             	mov    %edx,0xc(%eax)
  802013:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802016:	8b 40 0c             	mov    0xc(%eax),%eax
  802019:	85 c0                	test   %eax,%eax
  80201b:	74 0d                	je     80202a <malloc+0x40c>
  80201d:	a1 34 e1 81 00       	mov    0x81e134,%eax
  802022:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802025:	89 50 08             	mov    %edx,0x8(%eax)
  802028:	eb 08                	jmp    802032 <malloc+0x414>
  80202a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80202d:	a3 30 e1 81 00       	mov    %eax,0x81e130
  802032:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802035:	a3 34 e1 81 00       	mov    %eax,0x81e134
  80203a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80203d:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802044:	a1 3c e1 81 00       	mov    0x81e13c,%eax
  802049:	40                   	inc    %eax
  80204a:	a3 3c e1 81 00       	mov    %eax,0x81e13c
				LIST_REMOVE(&u_freelist ,currentfreeelement);
  80204f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802053:	75 17                	jne    80206c <malloc+0x44e>
  802055:	83 ec 04             	sub    $0x4,%esp
  802058:	68 bb 50 80 00       	push   $0x8050bb
  80205d:	68 8a 00 00 00       	push   $0x8a
  802062:	68 4c 50 80 00       	push   $0x80504c
  802067:	e8 cb e8 ff ff       	call   800937 <_panic>
  80206c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80206f:	8b 40 08             	mov    0x8(%eax),%eax
  802072:	85 c0                	test   %eax,%eax
  802074:	74 11                	je     802087 <malloc+0x469>
  802076:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802079:	8b 40 08             	mov    0x8(%eax),%eax
  80207c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80207f:	8b 52 0c             	mov    0xc(%edx),%edx
  802082:	89 50 0c             	mov    %edx,0xc(%eax)
  802085:	eb 0b                	jmp    802092 <malloc+0x474>
  802087:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80208a:	8b 40 0c             	mov    0xc(%eax),%eax
  80208d:	a3 24 e1 81 00       	mov    %eax,0x81e124
  802092:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802095:	8b 40 0c             	mov    0xc(%eax),%eax
  802098:	85 c0                	test   %eax,%eax
  80209a:	74 11                	je     8020ad <malloc+0x48f>
  80209c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80209f:	8b 40 0c             	mov    0xc(%eax),%eax
  8020a2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020a5:	8b 52 08             	mov    0x8(%edx),%edx
  8020a8:	89 50 08             	mov    %edx,0x8(%eax)
  8020ab:	eb 0b                	jmp    8020b8 <malloc+0x49a>
  8020ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020b0:	8b 40 08             	mov    0x8(%eax),%eax
  8020b3:	a3 20 e1 81 00       	mov    %eax,0x81e120
  8020b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020bb:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  8020c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020c5:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  8020cc:	a1 2c e1 81 00       	mov    0x81e12c,%eax
  8020d1:	48                   	dec    %eax
  8020d2:	a3 2c e1 81 00       	mov    %eax,0x81e12c
				sys_allocate_user_mem(allocblock->startva ,size);
  8020d7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8020da:	8b 00                	mov    (%eax),%eax
  8020dc:	83 ec 08             	sub    $0x8,%esp
  8020df:	ff 75 08             	pushl  0x8(%ebp)
  8020e2:	50                   	push   %eax
  8020e3:	e8 da 18 00 00       	call   8039c2 <sys_allocate_user_mem>
  8020e8:	83 c4 10             	add    $0x10,%esp
				release_uspinlock(&ulock);
  8020eb:	83 ec 0c             	sub    $0xc,%esp
  8020ee:	68 40 e1 81 00       	push   $0x81e140
  8020f3:	e8 12 24 00 00       	call   80450a <release_uspinlock>
  8020f8:	83 c4 10             	add    $0x10,%esp
				return (void*)allocblock->startva;
  8020fb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8020fe:	8b 00                	mov    (%eax),%eax
  802100:	eb 18                	jmp    80211a <malloc+0x4fc>
			}
			currentfreeelement = currentfreeelement->prev_next_info.le_next;
  802102:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802105:	8b 40 08             	mov    0x8(%eax),%eax
  802108:	89 45 f4             	mov    %eax,-0xc(%ebp)
				}
	}else{
		//custom fit
		struct UserHeapStruct* currentfreeelement = LIST_FIRST(&u_freelist);
		//worst fit
		while(currentfreeelement != NULL){
  80210b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80210f:	0f 85 bd fc ff ff    	jne    801dd2 <malloc+0x1b4>
				return (void*)allocblock->startva;
			}
			currentfreeelement = currentfreeelement->prev_next_info.le_next;
		}
	}
	 return NULL;
  802115:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80211a:	c9                   	leave  
  80211b:	c3                   	ret    

0080211c <free>:

//=================================
// [2] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
  80211c:	55                   	push   %ebp
  80211d:	89 e5                	mov    %esp,%ebp
  80211f:	83 ec 38             	sub    $0x38,%esp
	uint32  VA = ROUNDDOWN(((uint32 ) virtual_address), PAGE_SIZE);
  802122:	8b 45 08             	mov    0x8(%ebp),%eax
  802125:	89 45 dc             	mov    %eax,-0x24(%ebp)
  802128:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80212b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  802130:	89 45 d8             	mov    %eax,-0x28(%ebp)


		uheap_init();
  802133:	e8 b2 f9 ff ff       	call   801aea <uheap_init>
		acquire_uspinlock(&ulock);
  802138:	83 ec 0c             	sub    $0xc,%esp
  80213b:	68 40 e1 81 00       	push   $0x81e140
  802140:	e8 6d 23 00 00       	call   8044b2 <acquire_uspinlock>
  802145:	83 c4 10             	add    $0x10,%esp
		if (VA < uheapPageAllocStart){
  802148:	a1 10 e1 81 00       	mov    0x81e110,%eax
  80214d:	39 45 d8             	cmp    %eax,-0x28(%ebp)
  802150:	73 23                	jae    802175 <free+0x59>
			free_block(virtual_address);
  802152:	83 ec 0c             	sub    $0xc,%esp
  802155:	ff 75 08             	pushl  0x8(%ebp)
  802158:	e8 89 1f 00 00       	call   8040e6 <free_block>
  80215d:	83 c4 10             	add    $0x10,%esp
			release_uspinlock(&ulock);
  802160:	83 ec 0c             	sub    $0xc,%esp
  802163:	68 40 e1 81 00       	push   $0x81e140
  802168:	e8 9d 23 00 00       	call   80450a <release_uspinlock>
  80216d:	83 c4 10             	add    $0x10,%esp
			return;
  802170:	e9 35 07 00 00       	jmp    8028aa <free+0x78e>
		}
		if (VA >= uheapPageAllocBreak){
  802175:	a1 68 e0 81 00       	mov    0x81e068,%eax
  80217a:	39 45 d8             	cmp    %eax,-0x28(%ebp)
  80217d:	72 30                	jb     8021af <free+0x93>
			cprintf("%d\n %d\n", VA, uheapPageAllocBreak);
  80217f:	a1 68 e0 81 00       	mov    0x81e068,%eax
  802184:	83 ec 04             	sub    $0x4,%esp
  802187:	50                   	push   %eax
  802188:	ff 75 d8             	pushl  -0x28(%ebp)
  80218b:	68 11 51 80 00       	push   $0x805111
  802190:	e8 70 ea ff ff       	call   800c05 <cprintf>
  802195:	83 c4 10             	add    $0x10,%esp

			panic("freeing from restricted area");
  802198:	83 ec 04             	sub    $0x4,%esp
  80219b:	68 19 51 80 00       	push   $0x805119
  8021a0:	68 a7 00 00 00       	push   $0xa7
  8021a5:	68 4c 50 80 00       	push   $0x80504c
  8021aa:	e8 88 e7 ff ff       	call   800937 <_panic>
			release_uspinlock(&ulock);
			return;
		}

		struct UserHeapStruct* newfree = (struct UserHeapStruct*) alloc_block(sizeof(struct UserHeapStruct));
  8021af:	83 ec 0c             	sub    $0xc,%esp
  8021b2:	6a 10                	push   $0x10
  8021b4:	e8 91 1a 00 00       	call   803c4a <alloc_block>
  8021b9:	83 c4 10             	add    $0x10,%esp
  8021bc:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		struct UserHeapStruct* MergedBlock  = ( struct UserHeapStruct*)alloc_block(sizeof(struct UserHeapStruct));
  8021bf:	83 ec 0c             	sub    $0xc,%esp
  8021c2:	6a 10                	push   $0x10
  8021c4:	e8 81 1a 00 00       	call   803c4a <alloc_block>
  8021c9:	83 c4 10             	add    $0x10,%esp
  8021cc:	89 45 d0             	mov    %eax,-0x30(%ebp)

		struct UserHeapStruct* ToBefreed = LIST_FIRST(&u_allocatedlist);
  8021cf:	a1 30 e1 81 00       	mov    0x81e130,%eax
  8021d4:	89 45 f4             	mov    %eax,-0xc(%ebp)
		bool foundVA = 0;
  8021d7:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

		//find the allocated block
		while(ToBefreed !=NULL ){
  8021de:	eb 1c                	jmp    8021fc <free+0xe0>

			if (VA ==ToBefreed->startva ){
  8021e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021e3:	8b 00                	mov    (%eax),%eax
  8021e5:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  8021e8:	75 09                	jne    8021f3 <free+0xd7>
				foundVA = 1;
  8021ea:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
				break;
  8021f1:	eb 0f                	jmp    802202 <free+0xe6>
			}
				ToBefreed = ToBefreed->prev_next_info.le_next;
  8021f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021f6:	8b 40 08             	mov    0x8(%eax),%eax
  8021f9:	89 45 f4             	mov    %eax,-0xc(%ebp)

		struct UserHeapStruct* ToBefreed = LIST_FIRST(&u_allocatedlist);
		bool foundVA = 0;

		//find the allocated block
		while(ToBefreed !=NULL ){
  8021fc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802200:	75 de                	jne    8021e0 <free+0xc4>
			}
				ToBefreed = ToBefreed->prev_next_info.le_next;
		}


		if(!foundVA){
  802202:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802206:	75 17                	jne    80221f <free+0x103>
				panic("INVALID ADDRESS!");
  802208:	83 ec 04             	sub    $0x4,%esp
  80220b:	68 36 51 80 00       	push   $0x805136
  802210:	68 be 00 00 00       	push   $0xbe
  802215:	68 4c 50 80 00       	push   $0x80504c
  80221a:	e8 18 e7 ff ff       	call   800937 <_panic>
				release_uspinlock(&ulock);
				return;
			}


		newfree->startva = ToBefreed->startva;
  80221f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802222:	8b 10                	mov    (%eax),%edx
  802224:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802227:	89 10                	mov    %edx,(%eax)
		newfree->size = ToBefreed->size;
  802229:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80222c:	8b 50 04             	mov    0x4(%eax),%edx
  80222f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802232:	89 50 04             	mov    %edx,0x4(%eax)

		//remove allocated block from alloclist
		LIST_REMOVE(&u_allocatedlist, ToBefreed);
  802235:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802239:	75 17                	jne    802252 <free+0x136>
  80223b:	83 ec 04             	sub    $0x4,%esp
  80223e:	68 bb 50 80 00       	push   $0x8050bb
  802243:	68 c8 00 00 00       	push   $0xc8
  802248:	68 4c 50 80 00       	push   $0x80504c
  80224d:	e8 e5 e6 ff ff       	call   800937 <_panic>
  802252:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802255:	8b 40 08             	mov    0x8(%eax),%eax
  802258:	85 c0                	test   %eax,%eax
  80225a:	74 11                	je     80226d <free+0x151>
  80225c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80225f:	8b 40 08             	mov    0x8(%eax),%eax
  802262:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802265:	8b 52 0c             	mov    0xc(%edx),%edx
  802268:	89 50 0c             	mov    %edx,0xc(%eax)
  80226b:	eb 0b                	jmp    802278 <free+0x15c>
  80226d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802270:	8b 40 0c             	mov    0xc(%eax),%eax
  802273:	a3 34 e1 81 00       	mov    %eax,0x81e134
  802278:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80227b:	8b 40 0c             	mov    0xc(%eax),%eax
  80227e:	85 c0                	test   %eax,%eax
  802280:	74 11                	je     802293 <free+0x177>
  802282:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802285:	8b 40 0c             	mov    0xc(%eax),%eax
  802288:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80228b:	8b 52 08             	mov    0x8(%edx),%edx
  80228e:	89 50 08             	mov    %edx,0x8(%eax)
  802291:	eb 0b                	jmp    80229e <free+0x182>
  802293:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802296:	8b 40 08             	mov    0x8(%eax),%eax
  802299:	a3 30 e1 81 00       	mov    %eax,0x81e130
  80229e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022a1:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  8022a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022ab:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  8022b2:	a1 3c e1 81 00       	mov    0x81e13c,%eax
  8022b7:	48                   	dec    %eax
  8022b8:	a3 3c e1 81 00       	mov    %eax,0x81e13c

		sys_free_user_mem(ToBefreed->startva, ToBefreed->size);
  8022bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022c0:	8b 50 04             	mov    0x4(%eax),%edx
  8022c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022c6:	8b 00                	mov    (%eax),%eax
  8022c8:	83 ec 08             	sub    $0x8,%esp
  8022cb:	52                   	push   %edx
  8022cc:	50                   	push   %eax
  8022cd:	e8 d4 16 00 00       	call   8039a6 <sys_free_user_mem>
  8022d2:	83 c4 10             	add    $0x10,%esp




		if(LIST_SIZE(&u_freelist) == 0){
  8022d5:	a1 2c e1 81 00       	mov    0x81e12c,%eax
  8022da:	85 c0                	test   %eax,%eax
  8022dc:	75 7a                	jne    802358 <free+0x23c>
			LIST_INSERT_HEAD(&u_freelist,newfree);
  8022de:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8022e2:	75 17                	jne    8022fb <free+0x1df>
  8022e4:	83 ec 04             	sub    $0x4,%esp
  8022e7:	68 48 51 80 00       	push   $0x805148
  8022ec:	68 d0 00 00 00       	push   $0xd0
  8022f1:	68 4c 50 80 00       	push   $0x80504c
  8022f6:	e8 3c e6 ff ff       	call   800937 <_panic>
  8022fb:	8b 15 20 e1 81 00    	mov    0x81e120,%edx
  802301:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802304:	89 50 08             	mov    %edx,0x8(%eax)
  802307:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80230a:	8b 40 08             	mov    0x8(%eax),%eax
  80230d:	85 c0                	test   %eax,%eax
  80230f:	74 0d                	je     80231e <free+0x202>
  802311:	a1 20 e1 81 00       	mov    0x81e120,%eax
  802316:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802319:	89 50 0c             	mov    %edx,0xc(%eax)
  80231c:	eb 08                	jmp    802326 <free+0x20a>
  80231e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802321:	a3 24 e1 81 00       	mov    %eax,0x81e124
  802326:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802329:	a3 20 e1 81 00       	mov    %eax,0x81e120
  80232e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802331:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  802338:	a1 2c e1 81 00       	mov    0x81e12c,%eax
  80233d:	40                   	inc    %eax
  80233e:	a3 2c e1 81 00       	mov    %eax,0x81e12c
			release_uspinlock(&ulock);
  802343:	83 ec 0c             	sub    $0xc,%esp
  802346:	68 40 e1 81 00       	push   $0x81e140
  80234b:	e8 ba 21 00 00       	call   80450a <release_uspinlock>
  802350:	83 c4 10             	add    $0x10,%esp
			return;
  802353:	e9 52 05 00 00       	jmp    8028aa <free+0x78e>
		}


		struct UserHeapStruct* ToBeMerged = LIST_FIRST(&u_freelist);
  802358:	a1 20 e1 81 00       	mov    0x81e120,%eax
  80235d:	89 45 ec             	mov    %eax,-0x14(%ebp)
		// merge with prev if possible
		bool mergeprev = 0;
  802360:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		bool mergenext = 0;
  802367:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
		while(ToBeMerged != NULL){
  80236e:	e9 d2 00 00 00       	jmp    802445 <free+0x329>
			if((ToBeMerged->startva +ToBeMerged->size) == newfree->startva){
  802373:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802376:	8b 10                	mov    (%eax),%edx
  802378:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80237b:	8b 40 04             	mov    0x4(%eax),%eax
  80237e:	01 c2                	add    %eax,%edx
  802380:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802383:	8b 00                	mov    (%eax),%eax
  802385:	39 c2                	cmp    %eax,%edx
  802387:	0f 85 af 00 00 00    	jne    80243c <free+0x320>

				MergedBlock->startva = ToBeMerged->startva;
  80238d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802390:	8b 10                	mov    (%eax),%edx
  802392:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802395:	89 10                	mov    %edx,(%eax)
				MergedBlock->size = ToBeMerged->size + newfree->size;
  802397:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80239a:	8b 50 04             	mov    0x4(%eax),%edx
  80239d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8023a0:	8b 40 04             	mov    0x4(%eax),%eax
  8023a3:	01 c2                	add    %eax,%edx
  8023a5:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8023a8:	89 50 04             	mov    %edx,0x4(%eax)
				LIST_REMOVE(&u_freelist, ToBeMerged);
  8023ab:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8023af:	75 17                	jne    8023c8 <free+0x2ac>
  8023b1:	83 ec 04             	sub    $0x4,%esp
  8023b4:	68 bb 50 80 00       	push   $0x8050bb
  8023b9:	68 df 00 00 00       	push   $0xdf
  8023be:	68 4c 50 80 00       	push   $0x80504c
  8023c3:	e8 6f e5 ff ff       	call   800937 <_panic>
  8023c8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8023cb:	8b 40 08             	mov    0x8(%eax),%eax
  8023ce:	85 c0                	test   %eax,%eax
  8023d0:	74 11                	je     8023e3 <free+0x2c7>
  8023d2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8023d5:	8b 40 08             	mov    0x8(%eax),%eax
  8023d8:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8023db:	8b 52 0c             	mov    0xc(%edx),%edx
  8023de:	89 50 0c             	mov    %edx,0xc(%eax)
  8023e1:	eb 0b                	jmp    8023ee <free+0x2d2>
  8023e3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8023e6:	8b 40 0c             	mov    0xc(%eax),%eax
  8023e9:	a3 24 e1 81 00       	mov    %eax,0x81e124
  8023ee:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8023f1:	8b 40 0c             	mov    0xc(%eax),%eax
  8023f4:	85 c0                	test   %eax,%eax
  8023f6:	74 11                	je     802409 <free+0x2ed>
  8023f8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8023fb:	8b 40 0c             	mov    0xc(%eax),%eax
  8023fe:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802401:	8b 52 08             	mov    0x8(%edx),%edx
  802404:	89 50 08             	mov    %edx,0x8(%eax)
  802407:	eb 0b                	jmp    802414 <free+0x2f8>
  802409:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80240c:	8b 40 08             	mov    0x8(%eax),%eax
  80240f:	a3 20 e1 81 00       	mov    %eax,0x81e120
  802414:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802417:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  80241e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802421:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  802428:	a1 2c e1 81 00       	mov    0x81e12c,%eax
  80242d:	48                   	dec    %eax
  80242e:	a3 2c e1 81 00       	mov    %eax,0x81e12c
				mergeprev = 1;
  802433:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
				break;
  80243a:	eb 13                	jmp    80244f <free+0x333>
			}
				ToBeMerged = ToBeMerged->prev_next_info.le_next;
  80243c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80243f:	8b 40 08             	mov    0x8(%eax),%eax
  802442:	89 45 ec             	mov    %eax,-0x14(%ebp)

		struct UserHeapStruct* ToBeMerged = LIST_FIRST(&u_freelist);
		// merge with prev if possible
		bool mergeprev = 0;
		bool mergenext = 0;
		while(ToBeMerged != NULL){
  802445:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802449:	0f 85 24 ff ff ff    	jne    802373 <free+0x257>
//									uheapPageAllocBreak = newfree->startva;
//						}
//					}


		if ( newfree ->startva + newfree->size == uheapPageAllocBreak){
  80244f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802452:	8b 10                	mov    (%eax),%edx
  802454:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802457:	8b 40 04             	mov    0x4(%eax),%eax
  80245a:	01 c2                	add    %eax,%edx
  80245c:	a1 68 e0 81 00       	mov    0x81e068,%eax
  802461:	39 c2                	cmp    %eax,%edx
  802463:	75 44                	jne    8024a9 <free+0x38d>

			if(mergeprev){
  802465:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802469:	74 1f                	je     80248a <free+0x36e>
				uheapPageAllocBreak = MergedBlock->startva;
  80246b:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80246e:	8b 00                	mov    (%eax),%eax
  802470:	a3 68 e0 81 00       	mov    %eax,0x81e068
				release_uspinlock(&ulock);
  802475:	83 ec 0c             	sub    $0xc,%esp
  802478:	68 40 e1 81 00       	push   $0x81e140
  80247d:	e8 88 20 00 00       	call   80450a <release_uspinlock>
  802482:	83 c4 10             	add    $0x10,%esp
				return;
  802485:	e9 20 04 00 00       	jmp    8028aa <free+0x78e>

			}else{
				uheapPageAllocBreak = newfree->startva;
  80248a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80248d:	8b 00                	mov    (%eax),%eax
  80248f:	a3 68 e0 81 00       	mov    %eax,0x81e068
				release_uspinlock(&ulock);
  802494:	83 ec 0c             	sub    $0xc,%esp
  802497:	68 40 e1 81 00       	push   $0x81e140
  80249c:	e8 69 20 00 00       	call   80450a <release_uspinlock>
  8024a1:	83 c4 10             	add    $0x10,%esp
				return;
  8024a4:	e9 01 04 00 00       	jmp    8028aa <free+0x78e>

		}


		//check if block is merged with prev ,and find possible merge with next
		ToBeMerged = LIST_FIRST(&u_freelist);
  8024a9:	a1 20 e1 81 00       	mov    0x81e120,%eax
  8024ae:	89 45 ec             	mov    %eax,-0x14(%ebp)
		while(ToBeMerged != NULL){
  8024b1:	e9 7d 01 00 00       	jmp    802633 <free+0x517>
			if ((newfree->startva + newfree->size) == ToBeMerged->startva ){
  8024b6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8024b9:	8b 10                	mov    (%eax),%edx
  8024bb:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8024be:	8b 40 04             	mov    0x4(%eax),%eax
  8024c1:	01 c2                	add    %eax,%edx
  8024c3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8024c6:	8b 00                	mov    (%eax),%eax
  8024c8:	39 c2                	cmp    %eax,%edx
  8024ca:	0f 85 5a 01 00 00    	jne    80262a <free+0x50e>
				if (mergeprev){
  8024d0:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8024d4:	0f 84 a1 00 00 00    	je     80257b <free+0x45f>
					MergedBlock->size += ToBeMerged->size;
  8024da:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8024dd:	8b 50 04             	mov    0x4(%eax),%edx
  8024e0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8024e3:	8b 40 04             	mov    0x4(%eax),%eax
  8024e6:	01 c2                	add    %eax,%edx
  8024e8:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8024eb:	89 50 04             	mov    %edx,0x4(%eax)
					LIST_REMOVE(&u_freelist, ToBeMerged);
  8024ee:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8024f2:	75 17                	jne    80250b <free+0x3ef>
  8024f4:	83 ec 04             	sub    $0x4,%esp
  8024f7:	68 bb 50 80 00       	push   $0x8050bb
  8024fc:	68 0a 01 00 00       	push   $0x10a
  802501:	68 4c 50 80 00       	push   $0x80504c
  802506:	e8 2c e4 ff ff       	call   800937 <_panic>
  80250b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80250e:	8b 40 08             	mov    0x8(%eax),%eax
  802511:	85 c0                	test   %eax,%eax
  802513:	74 11                	je     802526 <free+0x40a>
  802515:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802518:	8b 40 08             	mov    0x8(%eax),%eax
  80251b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80251e:	8b 52 0c             	mov    0xc(%edx),%edx
  802521:	89 50 0c             	mov    %edx,0xc(%eax)
  802524:	eb 0b                	jmp    802531 <free+0x415>
  802526:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802529:	8b 40 0c             	mov    0xc(%eax),%eax
  80252c:	a3 24 e1 81 00       	mov    %eax,0x81e124
  802531:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802534:	8b 40 0c             	mov    0xc(%eax),%eax
  802537:	85 c0                	test   %eax,%eax
  802539:	74 11                	je     80254c <free+0x430>
  80253b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80253e:	8b 40 0c             	mov    0xc(%eax),%eax
  802541:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802544:	8b 52 08             	mov    0x8(%edx),%edx
  802547:	89 50 08             	mov    %edx,0x8(%eax)
  80254a:	eb 0b                	jmp    802557 <free+0x43b>
  80254c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80254f:	8b 40 08             	mov    0x8(%eax),%eax
  802552:	a3 20 e1 81 00       	mov    %eax,0x81e120
  802557:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80255a:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802561:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802564:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  80256b:	a1 2c e1 81 00       	mov    0x81e12c,%eax
  802570:	48                   	dec    %eax
  802571:	a3 2c e1 81 00       	mov    %eax,0x81e12c
					break;
  802576:	e9 c2 00 00 00       	jmp    80263d <free+0x521>
		//if not merged find possible merge with next
				}else{
					MergedBlock->startva = newfree->startva;
  80257b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80257e:	8b 10                	mov    (%eax),%edx
  802580:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802583:	89 10                	mov    %edx,(%eax)
					MergedBlock->size  = newfree->size + ToBeMerged->size;
  802585:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802588:	8b 50 04             	mov    0x4(%eax),%edx
  80258b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80258e:	8b 40 04             	mov    0x4(%eax),%eax
  802591:	01 c2                	add    %eax,%edx
  802593:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802596:	89 50 04             	mov    %edx,0x4(%eax)
					LIST_REMOVE(&u_freelist, ToBeMerged);
  802599:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80259d:	75 17                	jne    8025b6 <free+0x49a>
  80259f:	83 ec 04             	sub    $0x4,%esp
  8025a2:	68 bb 50 80 00       	push   $0x8050bb
  8025a7:	68 10 01 00 00       	push   $0x110
  8025ac:	68 4c 50 80 00       	push   $0x80504c
  8025b1:	e8 81 e3 ff ff       	call   800937 <_panic>
  8025b6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025b9:	8b 40 08             	mov    0x8(%eax),%eax
  8025bc:	85 c0                	test   %eax,%eax
  8025be:	74 11                	je     8025d1 <free+0x4b5>
  8025c0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025c3:	8b 40 08             	mov    0x8(%eax),%eax
  8025c6:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8025c9:	8b 52 0c             	mov    0xc(%edx),%edx
  8025cc:	89 50 0c             	mov    %edx,0xc(%eax)
  8025cf:	eb 0b                	jmp    8025dc <free+0x4c0>
  8025d1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025d4:	8b 40 0c             	mov    0xc(%eax),%eax
  8025d7:	a3 24 e1 81 00       	mov    %eax,0x81e124
  8025dc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025df:	8b 40 0c             	mov    0xc(%eax),%eax
  8025e2:	85 c0                	test   %eax,%eax
  8025e4:	74 11                	je     8025f7 <free+0x4db>
  8025e6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025e9:	8b 40 0c             	mov    0xc(%eax),%eax
  8025ec:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8025ef:	8b 52 08             	mov    0x8(%edx),%edx
  8025f2:	89 50 08             	mov    %edx,0x8(%eax)
  8025f5:	eb 0b                	jmp    802602 <free+0x4e6>
  8025f7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025fa:	8b 40 08             	mov    0x8(%eax),%eax
  8025fd:	a3 20 e1 81 00       	mov    %eax,0x81e120
  802602:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802605:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  80260c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80260f:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  802616:	a1 2c e1 81 00       	mov    0x81e12c,%eax
  80261b:	48                   	dec    %eax
  80261c:	a3 2c e1 81 00       	mov    %eax,0x81e12c
					mergenext = 1;
  802621:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
					break;
  802628:	eb 13                	jmp    80263d <free+0x521>
				}
			}
			ToBeMerged = ToBeMerged->prev_next_info.le_next;
  80262a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80262d:	8b 40 08             	mov    0x8(%eax),%eax
  802630:	89 45 ec             	mov    %eax,-0x14(%ebp)
		}


		//check if block is merged with prev ,and find possible merge with next
		ToBeMerged = LIST_FIRST(&u_freelist);
		while(ToBeMerged != NULL){
  802633:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802637:	0f 85 79 fe ff ff    	jne    8024b6 <free+0x39a>




			// insertion
			struct UserHeapStruct* currentfree = LIST_FIRST(&u_freelist);
  80263d:	a1 20 e1 81 00       	mov    0x81e120,%eax
  802642:	89 45 e0             	mov    %eax,-0x20(%ebp)

			if(mergeprev || mergenext){
  802645:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802649:	0f 85 ad 00 00 00    	jne    8026fc <free+0x5e0>
  80264f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802653:	0f 84 c3 01 00 00    	je     80281c <free+0x700>
				while(currentfree != NULL){
  802659:	e9 9e 00 00 00       	jmp    8026fc <free+0x5e0>
					if(MergedBlock->size < currentfree->size){
  80265e:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802661:	8b 50 04             	mov    0x4(%eax),%edx
  802664:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802667:	8b 40 04             	mov    0x4(%eax),%eax
  80266a:	39 c2                	cmp    %eax,%edx
  80266c:	0f 83 81 00 00 00    	jae    8026f3 <free+0x5d7>

							LIST_INSERT_BEFORE(&u_freelist,currentfree,MergedBlock);
  802672:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802676:	74 06                	je     80267e <free+0x562>
  802678:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  80267c:	75 17                	jne    802695 <free+0x579>
  80267e:	83 ec 04             	sub    $0x4,%esp
  802681:	68 dc 50 80 00       	push   $0x8050dc
  802686:	68 23 01 00 00       	push   $0x123
  80268b:	68 4c 50 80 00       	push   $0x80504c
  802690:	e8 a2 e2 ff ff       	call   800937 <_panic>
  802695:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802698:	8b 50 0c             	mov    0xc(%eax),%edx
  80269b:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80269e:	89 50 0c             	mov    %edx,0xc(%eax)
  8026a1:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8026a4:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8026a7:	89 50 08             	mov    %edx,0x8(%eax)
  8026aa:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8026ad:	8b 40 0c             	mov    0xc(%eax),%eax
  8026b0:	85 c0                	test   %eax,%eax
  8026b2:	74 0e                	je     8026c2 <free+0x5a6>
  8026b4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8026b7:	8b 40 0c             	mov    0xc(%eax),%eax
  8026ba:	8b 55 d0             	mov    -0x30(%ebp),%edx
  8026bd:	89 50 08             	mov    %edx,0x8(%eax)
  8026c0:	eb 08                	jmp    8026ca <free+0x5ae>
  8026c2:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8026c5:	a3 20 e1 81 00       	mov    %eax,0x81e120
  8026ca:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8026cd:	8b 55 d0             	mov    -0x30(%ebp),%edx
  8026d0:	89 50 0c             	mov    %edx,0xc(%eax)
  8026d3:	a1 2c e1 81 00       	mov    0x81e12c,%eax
  8026d8:	40                   	inc    %eax
  8026d9:	a3 2c e1 81 00       	mov    %eax,0x81e12c
							release_uspinlock(&ulock);
  8026de:	83 ec 0c             	sub    $0xc,%esp
  8026e1:	68 40 e1 81 00       	push   $0x81e140
  8026e6:	e8 1f 1e 00 00       	call   80450a <release_uspinlock>
  8026eb:	83 c4 10             	add    $0x10,%esp
							return;
  8026ee:	e9 b7 01 00 00       	jmp    8028aa <free+0x78e>
					}
							currentfree = currentfree->prev_next_info.le_next;
  8026f3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8026f6:	8b 40 08             	mov    0x8(%eax),%eax
  8026f9:	89 45 e0             	mov    %eax,-0x20(%ebp)

			// insertion
			struct UserHeapStruct* currentfree = LIST_FIRST(&u_freelist);

			if(mergeprev || mergenext){
				while(currentfree != NULL){
  8026fc:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802700:	0f 85 58 ff ff ff    	jne    80265e <free+0x542>
							release_uspinlock(&ulock);
							return;
					}
							currentfree = currentfree->prev_next_info.le_next;
				}
				free_block(newfree);
  802706:	83 ec 0c             	sub    $0xc,%esp
  802709:	ff 75 d4             	pushl  -0x2c(%ebp)
  80270c:	e8 d5 19 00 00       	call   8040e6 <free_block>
  802711:	83 c4 10             	add    $0x10,%esp
				LIST_INSERT_TAIL(&u_freelist,MergedBlock);
  802714:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  802718:	75 17                	jne    802731 <free+0x615>
  80271a:	83 ec 04             	sub    $0x4,%esp
  80271d:	68 98 50 80 00       	push   $0x805098
  802722:	68 2a 01 00 00       	push   $0x12a
  802727:	68 4c 50 80 00       	push   $0x80504c
  80272c:	e8 06 e2 ff ff       	call   800937 <_panic>
  802731:	8b 15 24 e1 81 00    	mov    0x81e124,%edx
  802737:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80273a:	89 50 0c             	mov    %edx,0xc(%eax)
  80273d:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802740:	8b 40 0c             	mov    0xc(%eax),%eax
  802743:	85 c0                	test   %eax,%eax
  802745:	74 0d                	je     802754 <free+0x638>
  802747:	a1 24 e1 81 00       	mov    0x81e124,%eax
  80274c:	8b 55 d0             	mov    -0x30(%ebp),%edx
  80274f:	89 50 08             	mov    %edx,0x8(%eax)
  802752:	eb 08                	jmp    80275c <free+0x640>
  802754:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802757:	a3 20 e1 81 00       	mov    %eax,0x81e120
  80275c:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80275f:	a3 24 e1 81 00       	mov    %eax,0x81e124
  802764:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802767:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  80276e:	a1 2c e1 81 00       	mov    0x81e12c,%eax
  802773:	40                   	inc    %eax
  802774:	a3 2c e1 81 00       	mov    %eax,0x81e12c
  802779:	e9 1b 01 00 00       	jmp    802899 <free+0x77d>

			}else{
				while(currentfree != NULL){
					if(newfree->size < currentfree->size){
  80277e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802781:	8b 50 04             	mov    0x4(%eax),%edx
  802784:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802787:	8b 40 04             	mov    0x4(%eax),%eax
  80278a:	39 c2                	cmp    %eax,%edx
  80278c:	0f 83 81 00 00 00    	jae    802813 <free+0x6f7>

							LIST_INSERT_BEFORE(&u_freelist,currentfree,newfree);
  802792:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802796:	74 06                	je     80279e <free+0x682>
  802798:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80279c:	75 17                	jne    8027b5 <free+0x699>
  80279e:	83 ec 04             	sub    $0x4,%esp
  8027a1:	68 dc 50 80 00       	push   $0x8050dc
  8027a6:	68 30 01 00 00       	push   $0x130
  8027ab:	68 4c 50 80 00       	push   $0x80504c
  8027b0:	e8 82 e1 ff ff       	call   800937 <_panic>
  8027b5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8027b8:	8b 50 0c             	mov    0xc(%eax),%edx
  8027bb:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8027be:	89 50 0c             	mov    %edx,0xc(%eax)
  8027c1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8027c4:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8027c7:	89 50 08             	mov    %edx,0x8(%eax)
  8027ca:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8027cd:	8b 40 0c             	mov    0xc(%eax),%eax
  8027d0:	85 c0                	test   %eax,%eax
  8027d2:	74 0e                	je     8027e2 <free+0x6c6>
  8027d4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8027d7:	8b 40 0c             	mov    0xc(%eax),%eax
  8027da:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8027dd:	89 50 08             	mov    %edx,0x8(%eax)
  8027e0:	eb 08                	jmp    8027ea <free+0x6ce>
  8027e2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8027e5:	a3 20 e1 81 00       	mov    %eax,0x81e120
  8027ea:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8027ed:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8027f0:	89 50 0c             	mov    %edx,0xc(%eax)
  8027f3:	a1 2c e1 81 00       	mov    0x81e12c,%eax
  8027f8:	40                   	inc    %eax
  8027f9:	a3 2c e1 81 00       	mov    %eax,0x81e12c
							release_uspinlock(&ulock);
  8027fe:	83 ec 0c             	sub    $0xc,%esp
  802801:	68 40 e1 81 00       	push   $0x81e140
  802806:	e8 ff 1c 00 00       	call   80450a <release_uspinlock>
  80280b:	83 c4 10             	add    $0x10,%esp
							return;
  80280e:	e9 97 00 00 00       	jmp    8028aa <free+0x78e>
					}
							currentfree = currentfree->prev_next_info.le_next;
  802813:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802816:	8b 40 08             	mov    0x8(%eax),%eax
  802819:	89 45 e0             	mov    %eax,-0x20(%ebp)
				}
				free_block(newfree);
				LIST_INSERT_TAIL(&u_freelist,MergedBlock);

			}else{
				while(currentfree != NULL){
  80281c:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802820:	0f 85 58 ff ff ff    	jne    80277e <free+0x662>
							release_uspinlock(&ulock);
							return;
					}
							currentfree = currentfree->prev_next_info.le_next;
				}
				free_block(MergedBlock);
  802826:	83 ec 0c             	sub    $0xc,%esp
  802829:	ff 75 d0             	pushl  -0x30(%ebp)
  80282c:	e8 b5 18 00 00       	call   8040e6 <free_block>
  802831:	83 c4 10             	add    $0x10,%esp
				LIST_INSERT_TAIL(&u_freelist,newfree);
  802834:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  802838:	75 17                	jne    802851 <free+0x735>
  80283a:	83 ec 04             	sub    $0x4,%esp
  80283d:	68 98 50 80 00       	push   $0x805098
  802842:	68 37 01 00 00       	push   $0x137
  802847:	68 4c 50 80 00       	push   $0x80504c
  80284c:	e8 e6 e0 ff ff       	call   800937 <_panic>
  802851:	8b 15 24 e1 81 00    	mov    0x81e124,%edx
  802857:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80285a:	89 50 0c             	mov    %edx,0xc(%eax)
  80285d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802860:	8b 40 0c             	mov    0xc(%eax),%eax
  802863:	85 c0                	test   %eax,%eax
  802865:	74 0d                	je     802874 <free+0x758>
  802867:	a1 24 e1 81 00       	mov    0x81e124,%eax
  80286c:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80286f:	89 50 08             	mov    %edx,0x8(%eax)
  802872:	eb 08                	jmp    80287c <free+0x760>
  802874:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802877:	a3 20 e1 81 00       	mov    %eax,0x81e120
  80287c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80287f:	a3 24 e1 81 00       	mov    %eax,0x81e124
  802884:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802887:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  80288e:	a1 2c e1 81 00       	mov    0x81e12c,%eax
  802893:	40                   	inc    %eax
  802894:	a3 2c e1 81 00       	mov    %eax,0x81e12c
			}
		release_uspinlock(&ulock);
  802899:	83 ec 0c             	sub    $0xc,%esp
  80289c:	68 40 e1 81 00       	push   $0x81e140
  8028a1:	e8 64 1c 00 00       	call   80450a <release_uspinlock>
  8028a6:	83 c4 10             	add    $0x10,%esp
		return;
  8028a9:	90                   	nop
}
  8028aa:	c9                   	leave  
  8028ab:	c3                   	ret    

008028ac <smalloc>:

//=================================
// [3] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  8028ac:	55                   	push   %ebp
  8028ad:	89 e5                	mov    %esp,%ebp
  8028af:	83 ec 48             	sub    $0x48,%esp
  8028b2:	8b 45 10             	mov    0x10(%ebp),%eax
  8028b5:	88 45 c4             	mov    %al,-0x3c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  8028b8:	e8 2d f2 ff ff       	call   801aea <uheap_init>
	if (size == 0) return NULL;
  8028bd:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8028c1:	75 0a                	jne    8028cd <smalloc+0x21>
  8028c3:	b8 00 00 00 00       	mov    $0x0,%eax
  8028c8:	e9 84 05 00 00       	jmp    802e51 <smalloc+0x5a5>
	//==============================================================
	acquire_uspinlock(&ulock);
  8028cd:	83 ec 0c             	sub    $0xc,%esp
  8028d0:	68 40 e1 81 00       	push   $0x81e140
  8028d5:	e8 d8 1b 00 00       	call   8044b2 <acquire_uspinlock>
  8028da:	83 c4 10             	add    $0x10,%esp

	struct UserHeapStruct* allocblock = (struct UserHeapStruct*) alloc_block(sizeof(struct UserHeapStruct));
  8028dd:	83 ec 0c             	sub    $0xc,%esp
  8028e0:	6a 10                	push   $0x10
  8028e2:	e8 63 13 00 00       	call   803c4a <alloc_block>
  8028e7:	83 c4 10             	add    $0x10,%esp
  8028ea:	89 45 ec             	mov    %eax,-0x14(%ebp)
	if (allocblock == NULL){
  8028ed:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8028f1:	75 0a                	jne    8028fd <smalloc+0x51>
				return NULL;
  8028f3:	b8 00 00 00 00       	mov    $0x0,%eax
  8028f8:	e9 54 05 00 00       	jmp    802e51 <smalloc+0x5a5>
	}
		size = ROUNDUP(size,PAGE_SIZE);
  8028fd:	c7 45 e8 00 10 00 00 	movl   $0x1000,-0x18(%ebp)
  802904:	8b 55 0c             	mov    0xc(%ebp),%edx
  802907:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80290a:	01 d0                	add    %edx,%eax
  80290c:	48                   	dec    %eax
  80290d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  802910:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802913:	ba 00 00 00 00       	mov    $0x0,%edx
  802918:	f7 75 e8             	divl   -0x18(%ebp)
  80291b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80291e:	29 d0                	sub    %edx,%eax
  802920:	89 45 0c             	mov    %eax,0xc(%ebp)
		struct UserHeapStruct* lastfreeelement = LIST_LAST(&u_freelist);
  802923:	a1 24 e1 81 00       	mov    0x81e124,%eax
  802928:	89 45 e0             	mov    %eax,-0x20(%ebp)

		if(LIST_SIZE(&u_freelist)==0 || size>lastfreeelement->size){
  80292b:	a1 2c e1 81 00       	mov    0x81e12c,%eax
  802930:	85 c0                	test   %eax,%eax
  802932:	74 0f                	je     802943 <smalloc+0x97>
  802934:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802937:	8b 40 04             	mov    0x4(%eax),%eax
  80293a:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80293d:	0f 83 25 01 00 00    	jae    802a68 <smalloc+0x1bc>
				if(uheapPageAllocBreak <= USER_HEAP_MAX - size){
  802943:	b8 00 00 00 a0       	mov    $0xa0000000,%eax
  802948:	2b 45 0c             	sub    0xc(%ebp),%eax
  80294b:	89 c2                	mov    %eax,%edx
  80294d:	a1 68 e0 81 00       	mov    0x81e068,%eax
  802952:	39 c2                	cmp    %eax,%edx
  802954:	0f 82 f4 00 00 00    	jb     802a4e <smalloc+0x1a2>
						uint32 requestedblockva = uheapPageAllocBreak;
  80295a:	a1 68 e0 81 00       	mov    0x81e068,%eax
  80295f:	89 45 d4             	mov    %eax,-0x2c(%ebp)
						uheapPageAllocBreak+=size;
  802962:	8b 15 68 e0 81 00    	mov    0x81e068,%edx
  802968:	8b 45 0c             	mov    0xc(%ebp),%eax
  80296b:	01 d0                	add    %edx,%eax
  80296d:	a3 68 e0 81 00       	mov    %eax,0x81e068
						allocblock->startva = requestedblockva;
  802972:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802975:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802978:	89 10                	mov    %edx,(%eax)
						allocblock->size = size;
  80297a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80297d:	8b 55 0c             	mov    0xc(%ebp),%edx
  802980:	89 50 04             	mov    %edx,0x4(%eax)

						LIST_INSERT_TAIL(&u_allocatedlist, allocblock);
  802983:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802987:	75 17                	jne    8029a0 <smalloc+0xf4>
  802989:	83 ec 04             	sub    $0x4,%esp
  80298c:	68 98 50 80 00       	push   $0x805098
  802991:	68 57 01 00 00       	push   $0x157
  802996:	68 4c 50 80 00       	push   $0x80504c
  80299b:	e8 97 df ff ff       	call   800937 <_panic>
  8029a0:	8b 15 34 e1 81 00    	mov    0x81e134,%edx
  8029a6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029a9:	89 50 0c             	mov    %edx,0xc(%eax)
  8029ac:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029af:	8b 40 0c             	mov    0xc(%eax),%eax
  8029b2:	85 c0                	test   %eax,%eax
  8029b4:	74 0d                	je     8029c3 <smalloc+0x117>
  8029b6:	a1 34 e1 81 00       	mov    0x81e134,%eax
  8029bb:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8029be:	89 50 08             	mov    %edx,0x8(%eax)
  8029c1:	eb 08                	jmp    8029cb <smalloc+0x11f>
  8029c3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029c6:	a3 30 e1 81 00       	mov    %eax,0x81e130
  8029cb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029ce:	a3 34 e1 81 00       	mov    %eax,0x81e134
  8029d3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029d6:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  8029dd:	a1 3c e1 81 00       	mov    0x81e13c,%eax
  8029e2:	40                   	inc    %eax
  8029e3:	a3 3c e1 81 00       	mov    %eax,0x81e13c


						int result = sys_create_shared_object(sharedVarName ,size ,isWritable ,(void*)allocblock->startva);
  8029e8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029eb:	8b 00                	mov    (%eax),%eax
  8029ed:	89 c2                	mov    %eax,%edx
  8029ef:	0f b6 45 c4          	movzbl -0x3c(%ebp),%eax
  8029f3:	52                   	push   %edx
  8029f4:	50                   	push   %eax
  8029f5:	ff 75 0c             	pushl  0xc(%ebp)
  8029f8:	ff 75 08             	pushl  0x8(%ebp)
  8029fb:	e8 48 0c 00 00       	call   803648 <sys_create_shared_object>
  802a00:	83 c4 10             	add    $0x10,%esp
  802a03:	89 45 d0             	mov    %eax,-0x30(%ebp)

						if(result <0){
  802a06:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  802a0a:	79 28                	jns    802a34 <smalloc+0x188>
							free_block(allocblock);
  802a0c:	83 ec 0c             	sub    $0xc,%esp
  802a0f:	ff 75 ec             	pushl  -0x14(%ebp)
  802a12:	e8 cf 16 00 00       	call   8040e6 <free_block>
  802a17:	83 c4 10             	add    $0x10,%esp
							release_uspinlock(&ulock);
  802a1a:	83 ec 0c             	sub    $0xc,%esp
  802a1d:	68 40 e1 81 00       	push   $0x81e140
  802a22:	e8 e3 1a 00 00       	call   80450a <release_uspinlock>
  802a27:	83 c4 10             	add    $0x10,%esp
							return NULL;
  802a2a:	b8 00 00 00 00       	mov    $0x0,%eax
  802a2f:	e9 1d 04 00 00       	jmp    802e51 <smalloc+0x5a5>
						}
						release_uspinlock(&ulock);
  802a34:	83 ec 0c             	sub    $0xc,%esp
  802a37:	68 40 e1 81 00       	push   $0x81e140
  802a3c:	e8 c9 1a 00 00       	call   80450a <release_uspinlock>
  802a41:	83 c4 10             	add    $0x10,%esp
						return (void*)allocblock -> startva;
  802a44:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a47:	8b 00                	mov    (%eax),%eax
  802a49:	e9 03 04 00 00       	jmp    802e51 <smalloc+0x5a5>
				}else{
						release_uspinlock(&ulock);
  802a4e:	83 ec 0c             	sub    $0xc,%esp
  802a51:	68 40 e1 81 00       	push   $0x81e140
  802a56:	e8 af 1a 00 00       	call   80450a <release_uspinlock>
  802a5b:	83 c4 10             	add    $0x10,%esp
						return NULL;
  802a5e:	b8 00 00 00 00       	mov    $0x0,%eax
  802a63:	e9 e9 03 00 00       	jmp    802e51 <smalloc+0x5a5>
					 }
		}else{
			//custom fit
			struct UserHeapStruct* currentfreeelement = LIST_FIRST(&u_freelist);
  802a68:	a1 20 e1 81 00       	mov    0x81e120,%eax
  802a6d:	89 45 f4             	mov    %eax,-0xc(%ebp)
			//worst fit
			while(currentfreeelement != NULL){
  802a70:	e9 af 03 00 00       	jmp    802e24 <smalloc+0x578>
				if(size<currentfreeelement->size){
  802a75:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a78:	8b 40 04             	mov    0x4(%eax),%eax
  802a7b:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802a7e:	0f 86 28 02 00 00    	jbe    802cac <smalloc+0x400>
					allocblock->startva = lastfreeelement->startva;
  802a84:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802a87:	8b 10                	mov    (%eax),%edx
  802a89:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a8c:	89 10                	mov    %edx,(%eax)
	                allocblock->size = size;
  802a8e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a91:	8b 55 0c             	mov    0xc(%ebp),%edx
  802a94:	89 50 04             	mov    %edx,0x4(%eax)
	                LIST_INSERT_TAIL(&u_allocatedlist,allocblock);
  802a97:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802a9b:	75 17                	jne    802ab4 <smalloc+0x208>
  802a9d:	83 ec 04             	sub    $0x4,%esp
  802aa0:	68 98 50 80 00       	push   $0x805098
  802aa5:	68 6f 01 00 00       	push   $0x16f
  802aaa:	68 4c 50 80 00       	push   $0x80504c
  802aaf:	e8 83 de ff ff       	call   800937 <_panic>
  802ab4:	8b 15 34 e1 81 00    	mov    0x81e134,%edx
  802aba:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802abd:	89 50 0c             	mov    %edx,0xc(%eax)
  802ac0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ac3:	8b 40 0c             	mov    0xc(%eax),%eax
  802ac6:	85 c0                	test   %eax,%eax
  802ac8:	74 0d                	je     802ad7 <smalloc+0x22b>
  802aca:	a1 34 e1 81 00       	mov    0x81e134,%eax
  802acf:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802ad2:	89 50 08             	mov    %edx,0x8(%eax)
  802ad5:	eb 08                	jmp    802adf <smalloc+0x233>
  802ad7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ada:	a3 30 e1 81 00       	mov    %eax,0x81e130
  802adf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ae2:	a3 34 e1 81 00       	mov    %eax,0x81e134
  802ae7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802aea:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802af1:	a1 3c e1 81 00       	mov    0x81e13c,%eax
  802af6:	40                   	inc    %eax
  802af7:	a3 3c e1 81 00       	mov    %eax,0x81e13c
	                lastfreeelement->startva += size;
  802afc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802aff:	8b 10                	mov    (%eax),%edx
  802b01:	8b 45 0c             	mov    0xc(%ebp),%eax
  802b04:	01 c2                	add    %eax,%edx
  802b06:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802b09:	89 10                	mov    %edx,(%eax)
	                lastfreeelement->size -= size;
  802b0b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802b0e:	8b 40 04             	mov    0x4(%eax),%eax
  802b11:	2b 45 0c             	sub    0xc(%ebp),%eax
  802b14:	89 c2                	mov    %eax,%edx
  802b16:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802b19:	89 50 04             	mov    %edx,0x4(%eax)
	                struct UserHeapStruct* currentfree2 = LIST_FIRST(&u_freelist);
  802b1c:	a1 20 e1 81 00       	mov    0x81e120,%eax
  802b21:	89 45 f0             	mov    %eax,-0x10(%ebp)
	                //check order of last element

	                while (currentfree2 != NULL){
  802b24:	e9 13 01 00 00       	jmp    802c3c <smalloc+0x390>
	                	if(lastfreeelement->size <currentfree2->size){
  802b29:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802b2c:	8b 50 04             	mov    0x4(%eax),%edx
  802b2f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b32:	8b 40 04             	mov    0x4(%eax),%eax
  802b35:	39 c2                	cmp    %eax,%edx
  802b37:	0f 83 f6 00 00 00    	jae    802c33 <smalloc+0x387>
	                		LIST_REMOVE(&u_freelist ,lastfreeelement);
  802b3d:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802b41:	75 17                	jne    802b5a <smalloc+0x2ae>
  802b43:	83 ec 04             	sub    $0x4,%esp
  802b46:	68 bb 50 80 00       	push   $0x8050bb
  802b4b:	68 77 01 00 00       	push   $0x177
  802b50:	68 4c 50 80 00       	push   $0x80504c
  802b55:	e8 dd dd ff ff       	call   800937 <_panic>
  802b5a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802b5d:	8b 40 08             	mov    0x8(%eax),%eax
  802b60:	85 c0                	test   %eax,%eax
  802b62:	74 11                	je     802b75 <smalloc+0x2c9>
  802b64:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802b67:	8b 40 08             	mov    0x8(%eax),%eax
  802b6a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802b6d:	8b 52 0c             	mov    0xc(%edx),%edx
  802b70:	89 50 0c             	mov    %edx,0xc(%eax)
  802b73:	eb 0b                	jmp    802b80 <smalloc+0x2d4>
  802b75:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802b78:	8b 40 0c             	mov    0xc(%eax),%eax
  802b7b:	a3 24 e1 81 00       	mov    %eax,0x81e124
  802b80:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802b83:	8b 40 0c             	mov    0xc(%eax),%eax
  802b86:	85 c0                	test   %eax,%eax
  802b88:	74 11                	je     802b9b <smalloc+0x2ef>
  802b8a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802b8d:	8b 40 0c             	mov    0xc(%eax),%eax
  802b90:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802b93:	8b 52 08             	mov    0x8(%edx),%edx
  802b96:	89 50 08             	mov    %edx,0x8(%eax)
  802b99:	eb 0b                	jmp    802ba6 <smalloc+0x2fa>
  802b9b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802b9e:	8b 40 08             	mov    0x8(%eax),%eax
  802ba1:	a3 20 e1 81 00       	mov    %eax,0x81e120
  802ba6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802ba9:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802bb0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802bb3:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  802bba:	a1 2c e1 81 00       	mov    0x81e12c,%eax
  802bbf:	48                   	dec    %eax
  802bc0:	a3 2c e1 81 00       	mov    %eax,0x81e12c
	                		LIST_INSERT_BEFORE(&u_freelist ,currentfree2 ,lastfreeelement);
  802bc5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802bc9:	74 06                	je     802bd1 <smalloc+0x325>
  802bcb:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802bcf:	75 17                	jne    802be8 <smalloc+0x33c>
  802bd1:	83 ec 04             	sub    $0x4,%esp
  802bd4:	68 dc 50 80 00       	push   $0x8050dc
  802bd9:	68 78 01 00 00       	push   $0x178
  802bde:	68 4c 50 80 00       	push   $0x80504c
  802be3:	e8 4f dd ff ff       	call   800937 <_panic>
  802be8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802beb:	8b 50 0c             	mov    0xc(%eax),%edx
  802bee:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802bf1:	89 50 0c             	mov    %edx,0xc(%eax)
  802bf4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802bf7:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802bfa:	89 50 08             	mov    %edx,0x8(%eax)
  802bfd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c00:	8b 40 0c             	mov    0xc(%eax),%eax
  802c03:	85 c0                	test   %eax,%eax
  802c05:	74 0e                	je     802c15 <smalloc+0x369>
  802c07:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c0a:	8b 40 0c             	mov    0xc(%eax),%eax
  802c0d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802c10:	89 50 08             	mov    %edx,0x8(%eax)
  802c13:	eb 08                	jmp    802c1d <smalloc+0x371>
  802c15:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802c18:	a3 20 e1 81 00       	mov    %eax,0x81e120
  802c1d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c20:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802c23:	89 50 0c             	mov    %edx,0xc(%eax)
  802c26:	a1 2c e1 81 00       	mov    0x81e12c,%eax
  802c2b:	40                   	inc    %eax
  802c2c:	a3 2c e1 81 00       	mov    %eax,0x81e12c
	                		break;
  802c31:	eb 13                	jmp    802c46 <smalloc+0x39a>
	                	}
	                	currentfree2 = currentfree2->prev_next_info.le_next;
  802c33:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c36:	8b 40 08             	mov    0x8(%eax),%eax
  802c39:	89 45 f0             	mov    %eax,-0x10(%ebp)
	                lastfreeelement->startva += size;
	                lastfreeelement->size -= size;
	                struct UserHeapStruct* currentfree2 = LIST_FIRST(&u_freelist);
	                //check order of last element

	                while (currentfree2 != NULL){
  802c3c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802c40:	0f 85 e3 fe ff ff    	jne    802b29 <smalloc+0x27d>
	                	}
	                	currentfree2 = currentfree2->prev_next_info.le_next;
	                }


	                int result = sys_create_shared_object(sharedVarName ,size ,isWritable ,(void*)allocblock->startva);
  802c46:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c49:	8b 00                	mov    (%eax),%eax
  802c4b:	89 c2                	mov    %eax,%edx
  802c4d:	0f b6 45 c4          	movzbl -0x3c(%ebp),%eax
  802c51:	52                   	push   %edx
  802c52:	50                   	push   %eax
  802c53:	ff 75 0c             	pushl  0xc(%ebp)
  802c56:	ff 75 08             	pushl  0x8(%ebp)
  802c59:	e8 ea 09 00 00       	call   803648 <sys_create_shared_object>
  802c5e:	83 c4 10             	add    $0x10,%esp
  802c61:	89 45 d8             	mov    %eax,-0x28(%ebp)

	                if(result <0){
  802c64:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  802c68:	79 28                	jns    802c92 <smalloc+0x3e6>
	                	free_block(allocblock);
  802c6a:	83 ec 0c             	sub    $0xc,%esp
  802c6d:	ff 75 ec             	pushl  -0x14(%ebp)
  802c70:	e8 71 14 00 00       	call   8040e6 <free_block>
  802c75:	83 c4 10             	add    $0x10,%esp
	                	release_uspinlock(&ulock);
  802c78:	83 ec 0c             	sub    $0xc,%esp
  802c7b:	68 40 e1 81 00       	push   $0x81e140
  802c80:	e8 85 18 00 00       	call   80450a <release_uspinlock>
  802c85:	83 c4 10             	add    $0x10,%esp
	                	return NULL;
  802c88:	b8 00 00 00 00       	mov    $0x0,%eax
  802c8d:	e9 bf 01 00 00       	jmp    802e51 <smalloc+0x5a5>
	                }
	                release_uspinlock(&ulock);
  802c92:	83 ec 0c             	sub    $0xc,%esp
  802c95:	68 40 e1 81 00       	push   $0x81e140
  802c9a:	e8 6b 18 00 00       	call   80450a <release_uspinlock>
  802c9f:	83 c4 10             	add    $0x10,%esp
	                return (void*)allocblock->startva;
  802ca2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ca5:	8b 00                	mov    (%eax),%eax
  802ca7:	e9 a5 01 00 00       	jmp    802e51 <smalloc+0x5a5>
	                //exact fit
				}else if(size == currentfreeelement->size){
  802cac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802caf:	8b 40 04             	mov    0x4(%eax),%eax
  802cb2:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802cb5:	0f 85 60 01 00 00    	jne    802e1b <smalloc+0x56f>
					allocblock->startva = currentfreeelement->startva;
  802cbb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cbe:	8b 10                	mov    (%eax),%edx
  802cc0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cc3:	89 10                	mov    %edx,(%eax)
					allocblock->size = size;
  802cc5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cc8:	8b 55 0c             	mov    0xc(%ebp),%edx
  802ccb:	89 50 04             	mov    %edx,0x4(%eax)
					LIST_INSERT_TAIL(&u_allocatedlist ,allocblock);
  802cce:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802cd2:	75 17                	jne    802ceb <smalloc+0x43f>
  802cd4:	83 ec 04             	sub    $0x4,%esp
  802cd7:	68 98 50 80 00       	push   $0x805098
  802cdc:	68 8c 01 00 00       	push   $0x18c
  802ce1:	68 4c 50 80 00       	push   $0x80504c
  802ce6:	e8 4c dc ff ff       	call   800937 <_panic>
  802ceb:	8b 15 34 e1 81 00    	mov    0x81e134,%edx
  802cf1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cf4:	89 50 0c             	mov    %edx,0xc(%eax)
  802cf7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cfa:	8b 40 0c             	mov    0xc(%eax),%eax
  802cfd:	85 c0                	test   %eax,%eax
  802cff:	74 0d                	je     802d0e <smalloc+0x462>
  802d01:	a1 34 e1 81 00       	mov    0x81e134,%eax
  802d06:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802d09:	89 50 08             	mov    %edx,0x8(%eax)
  802d0c:	eb 08                	jmp    802d16 <smalloc+0x46a>
  802d0e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d11:	a3 30 e1 81 00       	mov    %eax,0x81e130
  802d16:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d19:	a3 34 e1 81 00       	mov    %eax,0x81e134
  802d1e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d21:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802d28:	a1 3c e1 81 00       	mov    0x81e13c,%eax
  802d2d:	40                   	inc    %eax
  802d2e:	a3 3c e1 81 00       	mov    %eax,0x81e13c
					LIST_REMOVE(&u_freelist ,currentfreeelement);
  802d33:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d37:	75 17                	jne    802d50 <smalloc+0x4a4>
  802d39:	83 ec 04             	sub    $0x4,%esp
  802d3c:	68 bb 50 80 00       	push   $0x8050bb
  802d41:	68 8d 01 00 00       	push   $0x18d
  802d46:	68 4c 50 80 00       	push   $0x80504c
  802d4b:	e8 e7 db ff ff       	call   800937 <_panic>
  802d50:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d53:	8b 40 08             	mov    0x8(%eax),%eax
  802d56:	85 c0                	test   %eax,%eax
  802d58:	74 11                	je     802d6b <smalloc+0x4bf>
  802d5a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d5d:	8b 40 08             	mov    0x8(%eax),%eax
  802d60:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d63:	8b 52 0c             	mov    0xc(%edx),%edx
  802d66:	89 50 0c             	mov    %edx,0xc(%eax)
  802d69:	eb 0b                	jmp    802d76 <smalloc+0x4ca>
  802d6b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d6e:	8b 40 0c             	mov    0xc(%eax),%eax
  802d71:	a3 24 e1 81 00       	mov    %eax,0x81e124
  802d76:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d79:	8b 40 0c             	mov    0xc(%eax),%eax
  802d7c:	85 c0                	test   %eax,%eax
  802d7e:	74 11                	je     802d91 <smalloc+0x4e5>
  802d80:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d83:	8b 40 0c             	mov    0xc(%eax),%eax
  802d86:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d89:	8b 52 08             	mov    0x8(%edx),%edx
  802d8c:	89 50 08             	mov    %edx,0x8(%eax)
  802d8f:	eb 0b                	jmp    802d9c <smalloc+0x4f0>
  802d91:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d94:	8b 40 08             	mov    0x8(%eax),%eax
  802d97:	a3 20 e1 81 00       	mov    %eax,0x81e120
  802d9c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d9f:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802da6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802da9:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  802db0:	a1 2c e1 81 00       	mov    0x81e12c,%eax
  802db5:	48                   	dec    %eax
  802db6:	a3 2c e1 81 00       	mov    %eax,0x81e12c
					int result = sys_create_shared_object(sharedVarName ,size ,isWritable ,(void*)allocblock->startva);
  802dbb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802dbe:	8b 00                	mov    (%eax),%eax
  802dc0:	89 c2                	mov    %eax,%edx
  802dc2:	0f b6 45 c4          	movzbl -0x3c(%ebp),%eax
  802dc6:	52                   	push   %edx
  802dc7:	50                   	push   %eax
  802dc8:	ff 75 0c             	pushl  0xc(%ebp)
  802dcb:	ff 75 08             	pushl  0x8(%ebp)
  802dce:	e8 75 08 00 00       	call   803648 <sys_create_shared_object>
  802dd3:	83 c4 10             	add    $0x10,%esp
  802dd6:	89 45 dc             	mov    %eax,-0x24(%ebp)

					if(result <0){
  802dd9:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802ddd:	79 25                	jns    802e04 <smalloc+0x558>
						free_block(allocblock);
  802ddf:	83 ec 0c             	sub    $0xc,%esp
  802de2:	ff 75 ec             	pushl  -0x14(%ebp)
  802de5:	e8 fc 12 00 00       	call   8040e6 <free_block>
  802dea:	83 c4 10             	add    $0x10,%esp
						release_uspinlock(&ulock);
  802ded:	83 ec 0c             	sub    $0xc,%esp
  802df0:	68 40 e1 81 00       	push   $0x81e140
  802df5:	e8 10 17 00 00       	call   80450a <release_uspinlock>
  802dfa:	83 c4 10             	add    $0x10,%esp
						return NULL;
  802dfd:	b8 00 00 00 00       	mov    $0x0,%eax
  802e02:	eb 4d                	jmp    802e51 <smalloc+0x5a5>
					}
					release_uspinlock(&ulock);
  802e04:	83 ec 0c             	sub    $0xc,%esp
  802e07:	68 40 e1 81 00       	push   $0x81e140
  802e0c:	e8 f9 16 00 00       	call   80450a <release_uspinlock>
  802e11:	83 c4 10             	add    $0x10,%esp
					return (void*)allocblock->startva;
  802e14:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e17:	8b 00                	mov    (%eax),%eax
  802e19:	eb 36                	jmp    802e51 <smalloc+0x5a5>
				}
				currentfreeelement = currentfreeelement->prev_next_info.le_next;
  802e1b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e1e:	8b 40 08             	mov    0x8(%eax),%eax
  802e21:	89 45 f4             	mov    %eax,-0xc(%ebp)
					 }
		}else{
			//custom fit
			struct UserHeapStruct* currentfreeelement = LIST_FIRST(&u_freelist);
			//worst fit
			while(currentfreeelement != NULL){
  802e24:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e28:	0f 85 47 fc ff ff    	jne    802a75 <smalloc+0x1c9>
					return (void*)allocblock->startva;
				}
				currentfreeelement = currentfreeelement->prev_next_info.le_next;
			}
		}
		free_block(allocblock);
  802e2e:	83 ec 0c             	sub    $0xc,%esp
  802e31:	ff 75 ec             	pushl  -0x14(%ebp)
  802e34:	e8 ad 12 00 00       	call   8040e6 <free_block>
  802e39:	83 c4 10             	add    $0x10,%esp
		release_uspinlock(&ulock);
  802e3c:	83 ec 0c             	sub    $0xc,%esp
  802e3f:	68 40 e1 81 00       	push   $0x81e140
  802e44:	e8 c1 16 00 00       	call   80450a <release_uspinlock>
  802e49:	83 c4 10             	add    $0x10,%esp
		return NULL;
  802e4c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802e51:	c9                   	leave  
  802e52:	c3                   	ret    

00802e53 <sget>:

//========================================
// [4] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  802e53:	55                   	push   %ebp
  802e54:	89 e5                	mov    %esp,%ebp
  802e56:	83 ec 38             	sub    $0x38,%esp


	 //==============================================================
	 // DON'T CHANGE THIS CODE
	    uheap_init();
  802e59:	e8 8c ec ff ff       	call   801aea <uheap_init>
	 //==============================================================
	 // Get size of the shared variable from kernel
	acquire_uspinlock(&ulock);
  802e5e:	83 ec 0c             	sub    $0xc,%esp
  802e61:	68 40 e1 81 00       	push   $0x81e140
  802e66:	e8 47 16 00 00       	call   8044b2 <acquire_uspinlock>
  802e6b:	83 c4 10             	add    $0x10,%esp


	int size = sys_size_of_shared_object(ownerEnvID ,sharedVarName);
  802e6e:	83 ec 08             	sub    $0x8,%esp
  802e71:	ff 75 0c             	pushl  0xc(%ebp)
  802e74:	ff 75 08             	pushl  0x8(%ebp)
  802e77:	e8 f6 07 00 00       	call   803672 <sys_size_of_shared_object>
  802e7c:	83 c4 10             	add    $0x10,%esp
  802e7f:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if ( size < 0 ){
  802e82:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802e86:	79 1a                	jns    802ea2 <sget+0x4f>
			release_uspinlock(&ulock);
  802e88:	83 ec 0c             	sub    $0xc,%esp
  802e8b:	68 40 e1 81 00       	push   $0x81e140
  802e90:	e8 75 16 00 00       	call   80450a <release_uspinlock>
  802e95:	83 c4 10             	add    $0x10,%esp
			return NULL;
  802e98:	b8 00 00 00 00       	mov    $0x0,%eax
  802e9d:	e9 6e 05 00 00       	jmp    803410 <sget+0x5bd>
		}
		size = ROUNDUP(size,PAGE_SIZE);
  802ea2:	c7 45 e8 00 10 00 00 	movl   $0x1000,-0x18(%ebp)
  802ea9:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802eac:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802eaf:	01 d0                	add    %edx,%eax
  802eb1:	48                   	dec    %eax
  802eb2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  802eb5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802eb8:	ba 00 00 00 00       	mov    $0x0,%edx
  802ebd:	f7 75 e8             	divl   -0x18(%ebp)
  802ec0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802ec3:	29 d0                	sub    %edx,%eax
  802ec5:	89 45 ec             	mov    %eax,-0x14(%ebp)

		struct UserHeapStruct* allocblock = (struct UserHeapStruct*) alloc_block(sizeof(struct UserHeapStruct));
  802ec8:	83 ec 0c             	sub    $0xc,%esp
  802ecb:	6a 10                	push   $0x10
  802ecd:	e8 78 0d 00 00       	call   803c4a <alloc_block>
  802ed2:	83 c4 10             	add    $0x10,%esp
  802ed5:	89 45 e0             	mov    %eax,-0x20(%ebp)

		if (allocblock == NULL){
  802ed8:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802edc:	75 0a                	jne    802ee8 <sget+0x95>
			return NULL;
  802ede:	b8 00 00 00 00       	mov    $0x0,%eax
  802ee3:	e9 28 05 00 00       	jmp    803410 <sget+0x5bd>
		}
		struct UserHeapStruct* lastfreeelement = LIST_LAST(&u_freelist);
  802ee8:	a1 24 e1 81 00       	mov    0x81e124,%eax
  802eed:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if(LIST_SIZE(&u_freelist)==0 || size>lastfreeelement->size){
  802ef0:	a1 2c e1 81 00       	mov    0x81e12c,%eax
  802ef5:	85 c0                	test   %eax,%eax
  802ef7:	74 11                	je     802f0a <sget+0xb7>
  802ef9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802efc:	8b 50 04             	mov    0x4(%eax),%edx
  802eff:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f02:	39 c2                	cmp    %eax,%edx
  802f04:	0f 83 21 01 00 00    	jae    80302b <sget+0x1d8>
				if(uheapPageAllocBreak <= USER_HEAP_MAX - size){
  802f0a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f0d:	ba 00 00 00 a0       	mov    $0xa0000000,%edx
  802f12:	29 c2                	sub    %eax,%edx
  802f14:	a1 68 e0 81 00       	mov    0x81e068,%eax
  802f19:	39 c2                	cmp    %eax,%edx
  802f1b:	0f 82 f0 00 00 00    	jb     803011 <sget+0x1be>

						uint32 requestedblockva = uheapPageAllocBreak;
  802f21:	a1 68 e0 81 00       	mov    0x81e068,%eax
  802f26:	89 45 d0             	mov    %eax,-0x30(%ebp)
						uheapPageAllocBreak+=size;
  802f29:	8b 15 68 e0 81 00    	mov    0x81e068,%edx
  802f2f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f32:	01 d0                	add    %edx,%eax
  802f34:	a3 68 e0 81 00       	mov    %eax,0x81e068
						allocblock->startva = requestedblockva;
  802f39:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802f3c:	8b 55 d0             	mov    -0x30(%ebp),%edx
  802f3f:	89 10                	mov    %edx,(%eax)
						allocblock->size = size;
  802f41:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802f44:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802f47:	89 50 04             	mov    %edx,0x4(%eax)

						LIST_INSERT_TAIL(&u_allocatedlist, allocblock);
  802f4a:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802f4e:	75 17                	jne    802f67 <sget+0x114>
  802f50:	83 ec 04             	sub    $0x4,%esp
  802f53:	68 98 50 80 00       	push   $0x805098
  802f58:	68 c8 01 00 00       	push   $0x1c8
  802f5d:	68 4c 50 80 00       	push   $0x80504c
  802f62:	e8 d0 d9 ff ff       	call   800937 <_panic>
  802f67:	8b 15 34 e1 81 00    	mov    0x81e134,%edx
  802f6d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802f70:	89 50 0c             	mov    %edx,0xc(%eax)
  802f73:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802f76:	8b 40 0c             	mov    0xc(%eax),%eax
  802f79:	85 c0                	test   %eax,%eax
  802f7b:	74 0d                	je     802f8a <sget+0x137>
  802f7d:	a1 34 e1 81 00       	mov    0x81e134,%eax
  802f82:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802f85:	89 50 08             	mov    %edx,0x8(%eax)
  802f88:	eb 08                	jmp    802f92 <sget+0x13f>
  802f8a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802f8d:	a3 30 e1 81 00       	mov    %eax,0x81e130
  802f92:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802f95:	a3 34 e1 81 00       	mov    %eax,0x81e134
  802f9a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802f9d:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802fa4:	a1 3c e1 81 00       	mov    0x81e13c,%eax
  802fa9:	40                   	inc    %eax
  802faa:	a3 3c e1 81 00       	mov    %eax,0x81e13c


						int result = sys_get_shared_object(ownerEnvID ,sharedVarName ,(void*)allocblock->startva);
  802faf:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802fb2:	8b 00                	mov    (%eax),%eax
  802fb4:	83 ec 04             	sub    $0x4,%esp
  802fb7:	50                   	push   %eax
  802fb8:	ff 75 0c             	pushl  0xc(%ebp)
  802fbb:	ff 75 08             	pushl  0x8(%ebp)
  802fbe:	e8 cc 06 00 00       	call   80368f <sys_get_shared_object>
  802fc3:	83 c4 10             	add    $0x10,%esp
  802fc6:	89 45 cc             	mov    %eax,-0x34(%ebp)

						if(result <0){
  802fc9:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802fcd:	79 28                	jns    802ff7 <sget+0x1a4>
							free_block(allocblock);
  802fcf:	83 ec 0c             	sub    $0xc,%esp
  802fd2:	ff 75 e0             	pushl  -0x20(%ebp)
  802fd5:	e8 0c 11 00 00       	call   8040e6 <free_block>
  802fda:	83 c4 10             	add    $0x10,%esp
							release_uspinlock(&ulock);
  802fdd:	83 ec 0c             	sub    $0xc,%esp
  802fe0:	68 40 e1 81 00       	push   $0x81e140
  802fe5:	e8 20 15 00 00       	call   80450a <release_uspinlock>
  802fea:	83 c4 10             	add    $0x10,%esp
							return NULL;
  802fed:	b8 00 00 00 00       	mov    $0x0,%eax
  802ff2:	e9 19 04 00 00       	jmp    803410 <sget+0x5bd>
						}
						release_uspinlock(&ulock);
  802ff7:	83 ec 0c             	sub    $0xc,%esp
  802ffa:	68 40 e1 81 00       	push   $0x81e140
  802fff:	e8 06 15 00 00       	call   80450a <release_uspinlock>
  803004:	83 c4 10             	add    $0x10,%esp
						return (void*)allocblock -> startva;
  803007:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80300a:	8b 00                	mov    (%eax),%eax
  80300c:	e9 ff 03 00 00       	jmp    803410 <sget+0x5bd>
				}else{
						release_uspinlock(&ulock);
  803011:	83 ec 0c             	sub    $0xc,%esp
  803014:	68 40 e1 81 00       	push   $0x81e140
  803019:	e8 ec 14 00 00       	call   80450a <release_uspinlock>
  80301e:	83 c4 10             	add    $0x10,%esp
						return NULL;
  803021:	b8 00 00 00 00       	mov    $0x0,%eax
  803026:	e9 e5 03 00 00       	jmp    803410 <sget+0x5bd>
					 }
		}else{
			//custom fit
			struct UserHeapStruct* currentfreeelement = LIST_FIRST(&u_freelist);
  80302b:	a1 20 e1 81 00       	mov    0x81e120,%eax
  803030:	89 45 f4             	mov    %eax,-0xc(%ebp)
			//worst fit
			while(currentfreeelement != NULL){
  803033:	e9 ab 03 00 00       	jmp    8033e3 <sget+0x590>
				if(size<currentfreeelement->size){
  803038:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80303b:	8b 50 04             	mov    0x4(%eax),%edx
  80303e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803041:	39 c2                	cmp    %eax,%edx
  803043:	0f 86 24 02 00 00    	jbe    80326d <sget+0x41a>
					allocblock->startva = lastfreeelement->startva;
  803049:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80304c:	8b 10                	mov    (%eax),%edx
  80304e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803051:	89 10                	mov    %edx,(%eax)
					allocblock->size = size;
  803053:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803056:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803059:	89 50 04             	mov    %edx,0x4(%eax)
					LIST_INSERT_TAIL(&u_allocatedlist,allocblock);
  80305c:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  803060:	75 17                	jne    803079 <sget+0x226>
  803062:	83 ec 04             	sub    $0x4,%esp
  803065:	68 98 50 80 00       	push   $0x805098
  80306a:	68 e0 01 00 00       	push   $0x1e0
  80306f:	68 4c 50 80 00       	push   $0x80504c
  803074:	e8 be d8 ff ff       	call   800937 <_panic>
  803079:	8b 15 34 e1 81 00    	mov    0x81e134,%edx
  80307f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803082:	89 50 0c             	mov    %edx,0xc(%eax)
  803085:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803088:	8b 40 0c             	mov    0xc(%eax),%eax
  80308b:	85 c0                	test   %eax,%eax
  80308d:	74 0d                	je     80309c <sget+0x249>
  80308f:	a1 34 e1 81 00       	mov    0x81e134,%eax
  803094:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803097:	89 50 08             	mov    %edx,0x8(%eax)
  80309a:	eb 08                	jmp    8030a4 <sget+0x251>
  80309c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80309f:	a3 30 e1 81 00       	mov    %eax,0x81e130
  8030a4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8030a7:	a3 34 e1 81 00       	mov    %eax,0x81e134
  8030ac:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8030af:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  8030b6:	a1 3c e1 81 00       	mov    0x81e13c,%eax
  8030bb:	40                   	inc    %eax
  8030bc:	a3 3c e1 81 00       	mov    %eax,0x81e13c
					lastfreeelement->startva += size;
  8030c1:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8030c4:	8b 10                	mov    (%eax),%edx
  8030c6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030c9:	01 c2                	add    %eax,%edx
  8030cb:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8030ce:	89 10                	mov    %edx,(%eax)
					lastfreeelement->size -= size;
  8030d0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8030d3:	8b 50 04             	mov    0x4(%eax),%edx
  8030d6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030d9:	29 c2                	sub    %eax,%edx
  8030db:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8030de:	89 50 04             	mov    %edx,0x4(%eax)
					struct UserHeapStruct* currentfree2 = LIST_FIRST(&u_freelist);
  8030e1:	a1 20 e1 81 00       	mov    0x81e120,%eax
  8030e6:	89 45 f0             	mov    %eax,-0x10(%ebp)
					//check order of last element

					while (currentfree2 != NULL){
  8030e9:	e9 13 01 00 00       	jmp    803201 <sget+0x3ae>
						if(lastfreeelement->size <currentfree2->size){
  8030ee:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8030f1:	8b 50 04             	mov    0x4(%eax),%edx
  8030f4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030f7:	8b 40 04             	mov    0x4(%eax),%eax
  8030fa:	39 c2                	cmp    %eax,%edx
  8030fc:	0f 83 f6 00 00 00    	jae    8031f8 <sget+0x3a5>
							LIST_REMOVE(&u_freelist ,lastfreeelement);
  803102:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803106:	75 17                	jne    80311f <sget+0x2cc>
  803108:	83 ec 04             	sub    $0x4,%esp
  80310b:	68 bb 50 80 00       	push   $0x8050bb
  803110:	68 e8 01 00 00       	push   $0x1e8
  803115:	68 4c 50 80 00       	push   $0x80504c
  80311a:	e8 18 d8 ff ff       	call   800937 <_panic>
  80311f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803122:	8b 40 08             	mov    0x8(%eax),%eax
  803125:	85 c0                	test   %eax,%eax
  803127:	74 11                	je     80313a <sget+0x2e7>
  803129:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80312c:	8b 40 08             	mov    0x8(%eax),%eax
  80312f:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803132:	8b 52 0c             	mov    0xc(%edx),%edx
  803135:	89 50 0c             	mov    %edx,0xc(%eax)
  803138:	eb 0b                	jmp    803145 <sget+0x2f2>
  80313a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80313d:	8b 40 0c             	mov    0xc(%eax),%eax
  803140:	a3 24 e1 81 00       	mov    %eax,0x81e124
  803145:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803148:	8b 40 0c             	mov    0xc(%eax),%eax
  80314b:	85 c0                	test   %eax,%eax
  80314d:	74 11                	je     803160 <sget+0x30d>
  80314f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803152:	8b 40 0c             	mov    0xc(%eax),%eax
  803155:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803158:	8b 52 08             	mov    0x8(%edx),%edx
  80315b:	89 50 08             	mov    %edx,0x8(%eax)
  80315e:	eb 0b                	jmp    80316b <sget+0x318>
  803160:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803163:	8b 40 08             	mov    0x8(%eax),%eax
  803166:	a3 20 e1 81 00       	mov    %eax,0x81e120
  80316b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80316e:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  803175:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803178:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  80317f:	a1 2c e1 81 00       	mov    0x81e12c,%eax
  803184:	48                   	dec    %eax
  803185:	a3 2c e1 81 00       	mov    %eax,0x81e12c
							LIST_INSERT_BEFORE(&u_freelist ,currentfree2 ,lastfreeelement);
  80318a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80318e:	74 06                	je     803196 <sget+0x343>
  803190:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803194:	75 17                	jne    8031ad <sget+0x35a>
  803196:	83 ec 04             	sub    $0x4,%esp
  803199:	68 dc 50 80 00       	push   $0x8050dc
  80319e:	68 e9 01 00 00       	push   $0x1e9
  8031a3:	68 4c 50 80 00       	push   $0x80504c
  8031a8:	e8 8a d7 ff ff       	call   800937 <_panic>
  8031ad:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031b0:	8b 50 0c             	mov    0xc(%eax),%edx
  8031b3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8031b6:	89 50 0c             	mov    %edx,0xc(%eax)
  8031b9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8031bc:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8031bf:	89 50 08             	mov    %edx,0x8(%eax)
  8031c2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031c5:	8b 40 0c             	mov    0xc(%eax),%eax
  8031c8:	85 c0                	test   %eax,%eax
  8031ca:	74 0e                	je     8031da <sget+0x387>
  8031cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031cf:	8b 40 0c             	mov    0xc(%eax),%eax
  8031d2:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8031d5:	89 50 08             	mov    %edx,0x8(%eax)
  8031d8:	eb 08                	jmp    8031e2 <sget+0x38f>
  8031da:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8031dd:	a3 20 e1 81 00       	mov    %eax,0x81e120
  8031e2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031e5:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8031e8:	89 50 0c             	mov    %edx,0xc(%eax)
  8031eb:	a1 2c e1 81 00       	mov    0x81e12c,%eax
  8031f0:	40                   	inc    %eax
  8031f1:	a3 2c e1 81 00       	mov    %eax,0x81e12c
							break;
  8031f6:	eb 13                	jmp    80320b <sget+0x3b8>
						}
						currentfree2 = currentfree2->prev_next_info.le_next;
  8031f8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031fb:	8b 40 08             	mov    0x8(%eax),%eax
  8031fe:	89 45 f0             	mov    %eax,-0x10(%ebp)
					lastfreeelement->startva += size;
					lastfreeelement->size -= size;
					struct UserHeapStruct* currentfree2 = LIST_FIRST(&u_freelist);
					//check order of last element

					while (currentfree2 != NULL){
  803201:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803205:	0f 85 e3 fe ff ff    	jne    8030ee <sget+0x29b>
						}
						currentfree2 = currentfree2->prev_next_info.le_next;
					}


					int result = sys_get_shared_object(ownerEnvID ,sharedVarName ,(void*)allocblock->startva);
  80320b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80320e:	8b 00                	mov    (%eax),%eax
  803210:	83 ec 04             	sub    $0x4,%esp
  803213:	50                   	push   %eax
  803214:	ff 75 0c             	pushl  0xc(%ebp)
  803217:	ff 75 08             	pushl  0x8(%ebp)
  80321a:	e8 70 04 00 00       	call   80368f <sys_get_shared_object>
  80321f:	83 c4 10             	add    $0x10,%esp
  803222:	89 45 d4             	mov    %eax,-0x2c(%ebp)

					if(result <0){
  803225:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803229:	79 28                	jns    803253 <sget+0x400>
						free_block(allocblock);
  80322b:	83 ec 0c             	sub    $0xc,%esp
  80322e:	ff 75 e0             	pushl  -0x20(%ebp)
  803231:	e8 b0 0e 00 00       	call   8040e6 <free_block>
  803236:	83 c4 10             	add    $0x10,%esp
						release_uspinlock(&ulock);
  803239:	83 ec 0c             	sub    $0xc,%esp
  80323c:	68 40 e1 81 00       	push   $0x81e140
  803241:	e8 c4 12 00 00       	call   80450a <release_uspinlock>
  803246:	83 c4 10             	add    $0x10,%esp
						return NULL;
  803249:	b8 00 00 00 00       	mov    $0x0,%eax
  80324e:	e9 bd 01 00 00       	jmp    803410 <sget+0x5bd>
					}
					release_uspinlock(&ulock);
  803253:	83 ec 0c             	sub    $0xc,%esp
  803256:	68 40 e1 81 00       	push   $0x81e140
  80325b:	e8 aa 12 00 00       	call   80450a <release_uspinlock>
  803260:	83 c4 10             	add    $0x10,%esp
					return (void*)allocblock->startva;
  803263:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803266:	8b 00                	mov    (%eax),%eax
  803268:	e9 a3 01 00 00       	jmp    803410 <sget+0x5bd>
					//exact fit
				}else if(size == currentfreeelement->size){
  80326d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803270:	8b 50 04             	mov    0x4(%eax),%edx
  803273:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803276:	39 c2                	cmp    %eax,%edx
  803278:	0f 85 5c 01 00 00    	jne    8033da <sget+0x587>

					allocblock->startva = currentfreeelement->startva;
  80327e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803281:	8b 10                	mov    (%eax),%edx
  803283:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803286:	89 10                	mov    %edx,(%eax)
					allocblock->size = size;
  803288:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80328b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80328e:	89 50 04             	mov    %edx,0x4(%eax)
					LIST_INSERT_TAIL(&u_allocatedlist ,allocblock);
  803291:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  803295:	75 17                	jne    8032ae <sget+0x45b>
  803297:	83 ec 04             	sub    $0x4,%esp
  80329a:	68 98 50 80 00       	push   $0x805098
  80329f:	68 fe 01 00 00       	push   $0x1fe
  8032a4:	68 4c 50 80 00       	push   $0x80504c
  8032a9:	e8 89 d6 ff ff       	call   800937 <_panic>
  8032ae:	8b 15 34 e1 81 00    	mov    0x81e134,%edx
  8032b4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8032b7:	89 50 0c             	mov    %edx,0xc(%eax)
  8032ba:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8032bd:	8b 40 0c             	mov    0xc(%eax),%eax
  8032c0:	85 c0                	test   %eax,%eax
  8032c2:	74 0d                	je     8032d1 <sget+0x47e>
  8032c4:	a1 34 e1 81 00       	mov    0x81e134,%eax
  8032c9:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8032cc:	89 50 08             	mov    %edx,0x8(%eax)
  8032cf:	eb 08                	jmp    8032d9 <sget+0x486>
  8032d1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8032d4:	a3 30 e1 81 00       	mov    %eax,0x81e130
  8032d9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8032dc:	a3 34 e1 81 00       	mov    %eax,0x81e134
  8032e1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8032e4:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  8032eb:	a1 3c e1 81 00       	mov    0x81e13c,%eax
  8032f0:	40                   	inc    %eax
  8032f1:	a3 3c e1 81 00       	mov    %eax,0x81e13c
					LIST_REMOVE(&u_freelist ,currentfreeelement);
  8032f6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8032fa:	75 17                	jne    803313 <sget+0x4c0>
  8032fc:	83 ec 04             	sub    $0x4,%esp
  8032ff:	68 bb 50 80 00       	push   $0x8050bb
  803304:	68 ff 01 00 00       	push   $0x1ff
  803309:	68 4c 50 80 00       	push   $0x80504c
  80330e:	e8 24 d6 ff ff       	call   800937 <_panic>
  803313:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803316:	8b 40 08             	mov    0x8(%eax),%eax
  803319:	85 c0                	test   %eax,%eax
  80331b:	74 11                	je     80332e <sget+0x4db>
  80331d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803320:	8b 40 08             	mov    0x8(%eax),%eax
  803323:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803326:	8b 52 0c             	mov    0xc(%edx),%edx
  803329:	89 50 0c             	mov    %edx,0xc(%eax)
  80332c:	eb 0b                	jmp    803339 <sget+0x4e6>
  80332e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803331:	8b 40 0c             	mov    0xc(%eax),%eax
  803334:	a3 24 e1 81 00       	mov    %eax,0x81e124
  803339:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80333c:	8b 40 0c             	mov    0xc(%eax),%eax
  80333f:	85 c0                	test   %eax,%eax
  803341:	74 11                	je     803354 <sget+0x501>
  803343:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803346:	8b 40 0c             	mov    0xc(%eax),%eax
  803349:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80334c:	8b 52 08             	mov    0x8(%edx),%edx
  80334f:	89 50 08             	mov    %edx,0x8(%eax)
  803352:	eb 0b                	jmp    80335f <sget+0x50c>
  803354:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803357:	8b 40 08             	mov    0x8(%eax),%eax
  80335a:	a3 20 e1 81 00       	mov    %eax,0x81e120
  80335f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803362:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  803369:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80336c:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  803373:	a1 2c e1 81 00       	mov    0x81e12c,%eax
  803378:	48                   	dec    %eax
  803379:	a3 2c e1 81 00       	mov    %eax,0x81e12c

					int result = sys_get_shared_object(ownerEnvID ,sharedVarName ,(void*)allocblock->startva);
  80337e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803381:	8b 00                	mov    (%eax),%eax
  803383:	83 ec 04             	sub    $0x4,%esp
  803386:	50                   	push   %eax
  803387:	ff 75 0c             	pushl  0xc(%ebp)
  80338a:	ff 75 08             	pushl  0x8(%ebp)
  80338d:	e8 fd 02 00 00       	call   80368f <sys_get_shared_object>
  803392:	83 c4 10             	add    $0x10,%esp
  803395:	89 45 d8             	mov    %eax,-0x28(%ebp)
					if(result <0){
  803398:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  80339c:	79 25                	jns    8033c3 <sget+0x570>
						free_block(allocblock);
  80339e:	83 ec 0c             	sub    $0xc,%esp
  8033a1:	ff 75 e0             	pushl  -0x20(%ebp)
  8033a4:	e8 3d 0d 00 00       	call   8040e6 <free_block>
  8033a9:	83 c4 10             	add    $0x10,%esp
						release_uspinlock(&ulock);
  8033ac:	83 ec 0c             	sub    $0xc,%esp
  8033af:	68 40 e1 81 00       	push   $0x81e140
  8033b4:	e8 51 11 00 00       	call   80450a <release_uspinlock>
  8033b9:	83 c4 10             	add    $0x10,%esp
						return NULL;
  8033bc:	b8 00 00 00 00       	mov    $0x0,%eax
  8033c1:	eb 4d                	jmp    803410 <sget+0x5bd>
					}

					release_uspinlock(&ulock);
  8033c3:	83 ec 0c             	sub    $0xc,%esp
  8033c6:	68 40 e1 81 00       	push   $0x81e140
  8033cb:	e8 3a 11 00 00       	call   80450a <release_uspinlock>
  8033d0:	83 c4 10             	add    $0x10,%esp
					return (void*)allocblock->startva;
  8033d3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8033d6:	8b 00                	mov    (%eax),%eax
  8033d8:	eb 36                	jmp    803410 <sget+0x5bd>
				}
				currentfreeelement = currentfreeelement->prev_next_info.le_next;
  8033da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033dd:	8b 40 08             	mov    0x8(%eax),%eax
  8033e0:	89 45 f4             	mov    %eax,-0xc(%ebp)
					 }
		}else{
			//custom fit
			struct UserHeapStruct* currentfreeelement = LIST_FIRST(&u_freelist);
			//worst fit
			while(currentfreeelement != NULL){
  8033e3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8033e7:	0f 85 4b fc ff ff    	jne    803038 <sget+0x1e5>
					return (void*)allocblock->startva;
				}
				currentfreeelement = currentfreeelement->prev_next_info.le_next;
			}
		}
		free_block(allocblock);
  8033ed:	83 ec 0c             	sub    $0xc,%esp
  8033f0:	ff 75 e0             	pushl  -0x20(%ebp)
  8033f3:	e8 ee 0c 00 00       	call   8040e6 <free_block>
  8033f8:	83 c4 10             	add    $0x10,%esp
		release_uspinlock(&ulock);
  8033fb:	83 ec 0c             	sub    $0xc,%esp
  8033fe:	68 40 e1 81 00       	push   $0x81e140
  803403:	e8 02 11 00 00       	call   80450a <release_uspinlock>
  803408:	83 c4 10             	add    $0x10,%esp
		return NULL;
  80340b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803410:	c9                   	leave  
  803411:	c3                   	ret    

00803412 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  803412:	55                   	push   %ebp
  803413:	89 e5                	mov    %esp,%ebp
  803415:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  803418:	e8 cd e6 ff ff       	call   801aea <uheap_init>
	//==============================================================
	panic("realloc() is not implemented yet...!!");
  80341d:	83 ec 04             	sub    $0x4,%esp
  803420:	68 6c 51 80 00       	push   $0x80516c
  803425:	68 2d 02 00 00       	push   $0x22d
  80342a:	68 4c 50 80 00       	push   $0x80504c
  80342f:	e8 03 d5 ff ff       	call   800937 <_panic>

00803434 <sfree>:
//
//	use sys_delete_shared_object(...); which switches to the kernel mode,
//	calls delete_shared_object(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the delete_shared_object() function is empty, make sure to implement it.
void sfree(void* virtual_address)
{
  803434:	55                   	push   %ebp
  803435:	89 e5                	mov    %esp,%ebp
  803437:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.BONUS#5] EXIT #2 - sfree
	//Your code is here
	//Comment the following line
	panic("sfree() is not implemented yet...!!");
  80343a:	83 ec 04             	sub    $0x4,%esp
  80343d:	68 94 51 80 00       	push   $0x805194
  803442:	68 40 02 00 00       	push   $0x240
  803447:	68 4c 50 80 00       	push   $0x80504c
  80344c:	e8 e6 d4 ff ff       	call   800937 <_panic>

00803451 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  803451:	55                   	push   %ebp
  803452:	89 e5                	mov    %esp,%ebp
  803454:	57                   	push   %edi
  803455:	56                   	push   %esi
  803456:	53                   	push   %ebx
  803457:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80345a:	8b 45 08             	mov    0x8(%ebp),%eax
  80345d:	8b 55 0c             	mov    0xc(%ebp),%edx
  803460:	8b 4d 10             	mov    0x10(%ebp),%ecx
  803463:	8b 5d 14             	mov    0x14(%ebp),%ebx
  803466:	8b 7d 18             	mov    0x18(%ebp),%edi
  803469:	8b 75 1c             	mov    0x1c(%ebp),%esi
  80346c:	cd 30                	int    $0x30
  80346e:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  803471:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  803474:	83 c4 10             	add    $0x10,%esp
  803477:	5b                   	pop    %ebx
  803478:	5e                   	pop    %esi
  803479:	5f                   	pop    %edi
  80347a:	5d                   	pop    %ebp
  80347b:	c3                   	ret    

0080347c <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  80347c:	55                   	push   %ebp
  80347d:	89 e5                	mov    %esp,%ebp
  80347f:	83 ec 04             	sub    $0x4,%esp
  803482:	8b 45 10             	mov    0x10(%ebp),%eax
  803485:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  803488:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80348b:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80348f:	8b 45 08             	mov    0x8(%ebp),%eax
  803492:	6a 00                	push   $0x0
  803494:	51                   	push   %ecx
  803495:	52                   	push   %edx
  803496:	ff 75 0c             	pushl  0xc(%ebp)
  803499:	50                   	push   %eax
  80349a:	6a 00                	push   $0x0
  80349c:	e8 b0 ff ff ff       	call   803451 <syscall>
  8034a1:	83 c4 18             	add    $0x18,%esp
}
  8034a4:	90                   	nop
  8034a5:	c9                   	leave  
  8034a6:	c3                   	ret    

008034a7 <sys_cgetc>:

int
sys_cgetc(void)
{
  8034a7:	55                   	push   %ebp
  8034a8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8034aa:	6a 00                	push   $0x0
  8034ac:	6a 00                	push   $0x0
  8034ae:	6a 00                	push   $0x0
  8034b0:	6a 00                	push   $0x0
  8034b2:	6a 00                	push   $0x0
  8034b4:	6a 02                	push   $0x2
  8034b6:	e8 96 ff ff ff       	call   803451 <syscall>
  8034bb:	83 c4 18             	add    $0x18,%esp
}
  8034be:	c9                   	leave  
  8034bf:	c3                   	ret    

008034c0 <sys_lock_cons>:

void sys_lock_cons(void)
{
  8034c0:	55                   	push   %ebp
  8034c1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  8034c3:	6a 00                	push   $0x0
  8034c5:	6a 00                	push   $0x0
  8034c7:	6a 00                	push   $0x0
  8034c9:	6a 00                	push   $0x0
  8034cb:	6a 00                	push   $0x0
  8034cd:	6a 03                	push   $0x3
  8034cf:	e8 7d ff ff ff       	call   803451 <syscall>
  8034d4:	83 c4 18             	add    $0x18,%esp
}
  8034d7:	90                   	nop
  8034d8:	c9                   	leave  
  8034d9:	c3                   	ret    

008034da <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  8034da:	55                   	push   %ebp
  8034db:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  8034dd:	6a 00                	push   $0x0
  8034df:	6a 00                	push   $0x0
  8034e1:	6a 00                	push   $0x0
  8034e3:	6a 00                	push   $0x0
  8034e5:	6a 00                	push   $0x0
  8034e7:	6a 04                	push   $0x4
  8034e9:	e8 63 ff ff ff       	call   803451 <syscall>
  8034ee:	83 c4 18             	add    $0x18,%esp
}
  8034f1:	90                   	nop
  8034f2:	c9                   	leave  
  8034f3:	c3                   	ret    

008034f4 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8034f4:	55                   	push   %ebp
  8034f5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8034f7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8034fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8034fd:	6a 00                	push   $0x0
  8034ff:	6a 00                	push   $0x0
  803501:	6a 00                	push   $0x0
  803503:	52                   	push   %edx
  803504:	50                   	push   %eax
  803505:	6a 08                	push   $0x8
  803507:	e8 45 ff ff ff       	call   803451 <syscall>
  80350c:	83 c4 18             	add    $0x18,%esp
}
  80350f:	c9                   	leave  
  803510:	c3                   	ret    

00803511 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  803511:	55                   	push   %ebp
  803512:	89 e5                	mov    %esp,%ebp
  803514:	56                   	push   %esi
  803515:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  803516:	8b 75 18             	mov    0x18(%ebp),%esi
  803519:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80351c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80351f:	8b 55 0c             	mov    0xc(%ebp),%edx
  803522:	8b 45 08             	mov    0x8(%ebp),%eax
  803525:	56                   	push   %esi
  803526:	53                   	push   %ebx
  803527:	51                   	push   %ecx
  803528:	52                   	push   %edx
  803529:	50                   	push   %eax
  80352a:	6a 09                	push   $0x9
  80352c:	e8 20 ff ff ff       	call   803451 <syscall>
  803531:	83 c4 18             	add    $0x18,%esp
}
  803534:	8d 65 f8             	lea    -0x8(%ebp),%esp
  803537:	5b                   	pop    %ebx
  803538:	5e                   	pop    %esi
  803539:	5d                   	pop    %ebp
  80353a:	c3                   	ret    

0080353b <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  80353b:	55                   	push   %ebp
  80353c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  80353e:	6a 00                	push   $0x0
  803540:	6a 00                	push   $0x0
  803542:	6a 00                	push   $0x0
  803544:	6a 00                	push   $0x0
  803546:	ff 75 08             	pushl  0x8(%ebp)
  803549:	6a 0a                	push   $0xa
  80354b:	e8 01 ff ff ff       	call   803451 <syscall>
  803550:	83 c4 18             	add    $0x18,%esp
}
  803553:	c9                   	leave  
  803554:	c3                   	ret    

00803555 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  803555:	55                   	push   %ebp
  803556:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  803558:	6a 00                	push   $0x0
  80355a:	6a 00                	push   $0x0
  80355c:	6a 00                	push   $0x0
  80355e:	ff 75 0c             	pushl  0xc(%ebp)
  803561:	ff 75 08             	pushl  0x8(%ebp)
  803564:	6a 0b                	push   $0xb
  803566:	e8 e6 fe ff ff       	call   803451 <syscall>
  80356b:	83 c4 18             	add    $0x18,%esp
}
  80356e:	c9                   	leave  
  80356f:	c3                   	ret    

00803570 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  803570:	55                   	push   %ebp
  803571:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  803573:	6a 00                	push   $0x0
  803575:	6a 00                	push   $0x0
  803577:	6a 00                	push   $0x0
  803579:	6a 00                	push   $0x0
  80357b:	6a 00                	push   $0x0
  80357d:	6a 0c                	push   $0xc
  80357f:	e8 cd fe ff ff       	call   803451 <syscall>
  803584:	83 c4 18             	add    $0x18,%esp
}
  803587:	c9                   	leave  
  803588:	c3                   	ret    

00803589 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  803589:	55                   	push   %ebp
  80358a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  80358c:	6a 00                	push   $0x0
  80358e:	6a 00                	push   $0x0
  803590:	6a 00                	push   $0x0
  803592:	6a 00                	push   $0x0
  803594:	6a 00                	push   $0x0
  803596:	6a 0d                	push   $0xd
  803598:	e8 b4 fe ff ff       	call   803451 <syscall>
  80359d:	83 c4 18             	add    $0x18,%esp
}
  8035a0:	c9                   	leave  
  8035a1:	c3                   	ret    

008035a2 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8035a2:	55                   	push   %ebp
  8035a3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8035a5:	6a 00                	push   $0x0
  8035a7:	6a 00                	push   $0x0
  8035a9:	6a 00                	push   $0x0
  8035ab:	6a 00                	push   $0x0
  8035ad:	6a 00                	push   $0x0
  8035af:	6a 0e                	push   $0xe
  8035b1:	e8 9b fe ff ff       	call   803451 <syscall>
  8035b6:	83 c4 18             	add    $0x18,%esp
}
  8035b9:	c9                   	leave  
  8035ba:	c3                   	ret    

008035bb <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8035bb:	55                   	push   %ebp
  8035bc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8035be:	6a 00                	push   $0x0
  8035c0:	6a 00                	push   $0x0
  8035c2:	6a 00                	push   $0x0
  8035c4:	6a 00                	push   $0x0
  8035c6:	6a 00                	push   $0x0
  8035c8:	6a 0f                	push   $0xf
  8035ca:	e8 82 fe ff ff       	call   803451 <syscall>
  8035cf:	83 c4 18             	add    $0x18,%esp
}
  8035d2:	c9                   	leave  
  8035d3:	c3                   	ret    

008035d4 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8035d4:	55                   	push   %ebp
  8035d5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8035d7:	6a 00                	push   $0x0
  8035d9:	6a 00                	push   $0x0
  8035db:	6a 00                	push   $0x0
  8035dd:	6a 00                	push   $0x0
  8035df:	ff 75 08             	pushl  0x8(%ebp)
  8035e2:	6a 10                	push   $0x10
  8035e4:	e8 68 fe ff ff       	call   803451 <syscall>
  8035e9:	83 c4 18             	add    $0x18,%esp
}
  8035ec:	c9                   	leave  
  8035ed:	c3                   	ret    

008035ee <sys_scarce_memory>:

void sys_scarce_memory()
{
  8035ee:	55                   	push   %ebp
  8035ef:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8035f1:	6a 00                	push   $0x0
  8035f3:	6a 00                	push   $0x0
  8035f5:	6a 00                	push   $0x0
  8035f7:	6a 00                	push   $0x0
  8035f9:	6a 00                	push   $0x0
  8035fb:	6a 11                	push   $0x11
  8035fd:	e8 4f fe ff ff       	call   803451 <syscall>
  803602:	83 c4 18             	add    $0x18,%esp
}
  803605:	90                   	nop
  803606:	c9                   	leave  
  803607:	c3                   	ret    

00803608 <sys_cputc>:

void
sys_cputc(const char c)
{
  803608:	55                   	push   %ebp
  803609:	89 e5                	mov    %esp,%ebp
  80360b:	83 ec 04             	sub    $0x4,%esp
  80360e:	8b 45 08             	mov    0x8(%ebp),%eax
  803611:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  803614:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  803618:	6a 00                	push   $0x0
  80361a:	6a 00                	push   $0x0
  80361c:	6a 00                	push   $0x0
  80361e:	6a 00                	push   $0x0
  803620:	50                   	push   %eax
  803621:	6a 01                	push   $0x1
  803623:	e8 29 fe ff ff       	call   803451 <syscall>
  803628:	83 c4 18             	add    $0x18,%esp
}
  80362b:	90                   	nop
  80362c:	c9                   	leave  
  80362d:	c3                   	ret    

0080362e <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  80362e:	55                   	push   %ebp
  80362f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  803631:	6a 00                	push   $0x0
  803633:	6a 00                	push   $0x0
  803635:	6a 00                	push   $0x0
  803637:	6a 00                	push   $0x0
  803639:	6a 00                	push   $0x0
  80363b:	6a 14                	push   $0x14
  80363d:	e8 0f fe ff ff       	call   803451 <syscall>
  803642:	83 c4 18             	add    $0x18,%esp
}
  803645:	90                   	nop
  803646:	c9                   	leave  
  803647:	c3                   	ret    

00803648 <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  803648:	55                   	push   %ebp
  803649:	89 e5                	mov    %esp,%ebp
  80364b:	83 ec 04             	sub    $0x4,%esp
  80364e:	8b 45 10             	mov    0x10(%ebp),%eax
  803651:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  803654:	8b 4d 14             	mov    0x14(%ebp),%ecx
  803657:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80365b:	8b 45 08             	mov    0x8(%ebp),%eax
  80365e:	6a 00                	push   $0x0
  803660:	51                   	push   %ecx
  803661:	52                   	push   %edx
  803662:	ff 75 0c             	pushl  0xc(%ebp)
  803665:	50                   	push   %eax
  803666:	6a 15                	push   $0x15
  803668:	e8 e4 fd ff ff       	call   803451 <syscall>
  80366d:	83 c4 18             	add    $0x18,%esp
}
  803670:	c9                   	leave  
  803671:	c3                   	ret    

00803672 <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  803672:	55                   	push   %ebp
  803673:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  803675:	8b 55 0c             	mov    0xc(%ebp),%edx
  803678:	8b 45 08             	mov    0x8(%ebp),%eax
  80367b:	6a 00                	push   $0x0
  80367d:	6a 00                	push   $0x0
  80367f:	6a 00                	push   $0x0
  803681:	52                   	push   %edx
  803682:	50                   	push   %eax
  803683:	6a 16                	push   $0x16
  803685:	e8 c7 fd ff ff       	call   803451 <syscall>
  80368a:	83 c4 18             	add    $0x18,%esp
}
  80368d:	c9                   	leave  
  80368e:	c3                   	ret    

0080368f <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  80368f:	55                   	push   %ebp
  803690:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  803692:	8b 4d 10             	mov    0x10(%ebp),%ecx
  803695:	8b 55 0c             	mov    0xc(%ebp),%edx
  803698:	8b 45 08             	mov    0x8(%ebp),%eax
  80369b:	6a 00                	push   $0x0
  80369d:	6a 00                	push   $0x0
  80369f:	51                   	push   %ecx
  8036a0:	52                   	push   %edx
  8036a1:	50                   	push   %eax
  8036a2:	6a 17                	push   $0x17
  8036a4:	e8 a8 fd ff ff       	call   803451 <syscall>
  8036a9:	83 c4 18             	add    $0x18,%esp
}
  8036ac:	c9                   	leave  
  8036ad:	c3                   	ret    

008036ae <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  8036ae:	55                   	push   %ebp
  8036af:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8036b1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8036b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8036b7:	6a 00                	push   $0x0
  8036b9:	6a 00                	push   $0x0
  8036bb:	6a 00                	push   $0x0
  8036bd:	52                   	push   %edx
  8036be:	50                   	push   %eax
  8036bf:	6a 18                	push   $0x18
  8036c1:	e8 8b fd ff ff       	call   803451 <syscall>
  8036c6:	83 c4 18             	add    $0x18,%esp
}
  8036c9:	c9                   	leave  
  8036ca:	c3                   	ret    

008036cb <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8036cb:	55                   	push   %ebp
  8036cc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8036ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8036d1:	6a 00                	push   $0x0
  8036d3:	ff 75 14             	pushl  0x14(%ebp)
  8036d6:	ff 75 10             	pushl  0x10(%ebp)
  8036d9:	ff 75 0c             	pushl  0xc(%ebp)
  8036dc:	50                   	push   %eax
  8036dd:	6a 19                	push   $0x19
  8036df:	e8 6d fd ff ff       	call   803451 <syscall>
  8036e4:	83 c4 18             	add    $0x18,%esp
}
  8036e7:	c9                   	leave  
  8036e8:	c3                   	ret    

008036e9 <sys_run_env>:

void sys_run_env(int32 envId)
{
  8036e9:	55                   	push   %ebp
  8036ea:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8036ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8036ef:	6a 00                	push   $0x0
  8036f1:	6a 00                	push   $0x0
  8036f3:	6a 00                	push   $0x0
  8036f5:	6a 00                	push   $0x0
  8036f7:	50                   	push   %eax
  8036f8:	6a 1a                	push   $0x1a
  8036fa:	e8 52 fd ff ff       	call   803451 <syscall>
  8036ff:	83 c4 18             	add    $0x18,%esp
}
  803702:	90                   	nop
  803703:	c9                   	leave  
  803704:	c3                   	ret    

00803705 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  803705:	55                   	push   %ebp
  803706:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  803708:	8b 45 08             	mov    0x8(%ebp),%eax
  80370b:	6a 00                	push   $0x0
  80370d:	6a 00                	push   $0x0
  80370f:	6a 00                	push   $0x0
  803711:	6a 00                	push   $0x0
  803713:	50                   	push   %eax
  803714:	6a 1b                	push   $0x1b
  803716:	e8 36 fd ff ff       	call   803451 <syscall>
  80371b:	83 c4 18             	add    $0x18,%esp
}
  80371e:	c9                   	leave  
  80371f:	c3                   	ret    

00803720 <sys_getenvid>:

int32 sys_getenvid(void)
{
  803720:	55                   	push   %ebp
  803721:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  803723:	6a 00                	push   $0x0
  803725:	6a 00                	push   $0x0
  803727:	6a 00                	push   $0x0
  803729:	6a 00                	push   $0x0
  80372b:	6a 00                	push   $0x0
  80372d:	6a 05                	push   $0x5
  80372f:	e8 1d fd ff ff       	call   803451 <syscall>
  803734:	83 c4 18             	add    $0x18,%esp
}
  803737:	c9                   	leave  
  803738:	c3                   	ret    

00803739 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  803739:	55                   	push   %ebp
  80373a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  80373c:	6a 00                	push   $0x0
  80373e:	6a 00                	push   $0x0
  803740:	6a 00                	push   $0x0
  803742:	6a 00                	push   $0x0
  803744:	6a 00                	push   $0x0
  803746:	6a 06                	push   $0x6
  803748:	e8 04 fd ff ff       	call   803451 <syscall>
  80374d:	83 c4 18             	add    $0x18,%esp
}
  803750:	c9                   	leave  
  803751:	c3                   	ret    

00803752 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  803752:	55                   	push   %ebp
  803753:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  803755:	6a 00                	push   $0x0
  803757:	6a 00                	push   $0x0
  803759:	6a 00                	push   $0x0
  80375b:	6a 00                	push   $0x0
  80375d:	6a 00                	push   $0x0
  80375f:	6a 07                	push   $0x7
  803761:	e8 eb fc ff ff       	call   803451 <syscall>
  803766:	83 c4 18             	add    $0x18,%esp
}
  803769:	c9                   	leave  
  80376a:	c3                   	ret    

0080376b <sys_exit_env>:


void sys_exit_env(void)
{
  80376b:	55                   	push   %ebp
  80376c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  80376e:	6a 00                	push   $0x0
  803770:	6a 00                	push   $0x0
  803772:	6a 00                	push   $0x0
  803774:	6a 00                	push   $0x0
  803776:	6a 00                	push   $0x0
  803778:	6a 1c                	push   $0x1c
  80377a:	e8 d2 fc ff ff       	call   803451 <syscall>
  80377f:	83 c4 18             	add    $0x18,%esp
}
  803782:	90                   	nop
  803783:	c9                   	leave  
  803784:	c3                   	ret    

00803785 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  803785:	55                   	push   %ebp
  803786:	89 e5                	mov    %esp,%ebp
  803788:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  80378b:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80378e:	8d 50 04             	lea    0x4(%eax),%edx
  803791:	8d 45 f8             	lea    -0x8(%ebp),%eax
  803794:	6a 00                	push   $0x0
  803796:	6a 00                	push   $0x0
  803798:	6a 00                	push   $0x0
  80379a:	52                   	push   %edx
  80379b:	50                   	push   %eax
  80379c:	6a 1d                	push   $0x1d
  80379e:	e8 ae fc ff ff       	call   803451 <syscall>
  8037a3:	83 c4 18             	add    $0x18,%esp
	return result;
  8037a6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8037a9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8037ac:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8037af:	89 01                	mov    %eax,(%ecx)
  8037b1:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8037b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8037b7:	c9                   	leave  
  8037b8:	c2 04 00             	ret    $0x4

008037bb <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8037bb:	55                   	push   %ebp
  8037bc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8037be:	6a 00                	push   $0x0
  8037c0:	6a 00                	push   $0x0
  8037c2:	ff 75 10             	pushl  0x10(%ebp)
  8037c5:	ff 75 0c             	pushl  0xc(%ebp)
  8037c8:	ff 75 08             	pushl  0x8(%ebp)
  8037cb:	6a 13                	push   $0x13
  8037cd:	e8 7f fc ff ff       	call   803451 <syscall>
  8037d2:	83 c4 18             	add    $0x18,%esp
	return ;
  8037d5:	90                   	nop
}
  8037d6:	c9                   	leave  
  8037d7:	c3                   	ret    

008037d8 <sys_rcr2>:
uint32 sys_rcr2()
{
  8037d8:	55                   	push   %ebp
  8037d9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8037db:	6a 00                	push   $0x0
  8037dd:	6a 00                	push   $0x0
  8037df:	6a 00                	push   $0x0
  8037e1:	6a 00                	push   $0x0
  8037e3:	6a 00                	push   $0x0
  8037e5:	6a 1e                	push   $0x1e
  8037e7:	e8 65 fc ff ff       	call   803451 <syscall>
  8037ec:	83 c4 18             	add    $0x18,%esp
}
  8037ef:	c9                   	leave  
  8037f0:	c3                   	ret    

008037f1 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  8037f1:	55                   	push   %ebp
  8037f2:	89 e5                	mov    %esp,%ebp
  8037f4:	83 ec 04             	sub    $0x4,%esp
  8037f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8037fa:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8037fd:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  803801:	6a 00                	push   $0x0
  803803:	6a 00                	push   $0x0
  803805:	6a 00                	push   $0x0
  803807:	6a 00                	push   $0x0
  803809:	50                   	push   %eax
  80380a:	6a 1f                	push   $0x1f
  80380c:	e8 40 fc ff ff       	call   803451 <syscall>
  803811:	83 c4 18             	add    $0x18,%esp
	return ;
  803814:	90                   	nop
}
  803815:	c9                   	leave  
  803816:	c3                   	ret    

00803817 <rsttst>:
void rsttst()
{
  803817:	55                   	push   %ebp
  803818:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  80381a:	6a 00                	push   $0x0
  80381c:	6a 00                	push   $0x0
  80381e:	6a 00                	push   $0x0
  803820:	6a 00                	push   $0x0
  803822:	6a 00                	push   $0x0
  803824:	6a 21                	push   $0x21
  803826:	e8 26 fc ff ff       	call   803451 <syscall>
  80382b:	83 c4 18             	add    $0x18,%esp
	return ;
  80382e:	90                   	nop
}
  80382f:	c9                   	leave  
  803830:	c3                   	ret    

00803831 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  803831:	55                   	push   %ebp
  803832:	89 e5                	mov    %esp,%ebp
  803834:	83 ec 04             	sub    $0x4,%esp
  803837:	8b 45 14             	mov    0x14(%ebp),%eax
  80383a:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  80383d:	8b 55 18             	mov    0x18(%ebp),%edx
  803840:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  803844:	52                   	push   %edx
  803845:	50                   	push   %eax
  803846:	ff 75 10             	pushl  0x10(%ebp)
  803849:	ff 75 0c             	pushl  0xc(%ebp)
  80384c:	ff 75 08             	pushl  0x8(%ebp)
  80384f:	6a 20                	push   $0x20
  803851:	e8 fb fb ff ff       	call   803451 <syscall>
  803856:	83 c4 18             	add    $0x18,%esp
	return ;
  803859:	90                   	nop
}
  80385a:	c9                   	leave  
  80385b:	c3                   	ret    

0080385c <chktst>:
void chktst(uint32 n)
{
  80385c:	55                   	push   %ebp
  80385d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  80385f:	6a 00                	push   $0x0
  803861:	6a 00                	push   $0x0
  803863:	6a 00                	push   $0x0
  803865:	6a 00                	push   $0x0
  803867:	ff 75 08             	pushl  0x8(%ebp)
  80386a:	6a 22                	push   $0x22
  80386c:	e8 e0 fb ff ff       	call   803451 <syscall>
  803871:	83 c4 18             	add    $0x18,%esp
	return ;
  803874:	90                   	nop
}
  803875:	c9                   	leave  
  803876:	c3                   	ret    

00803877 <inctst>:

void inctst()
{
  803877:	55                   	push   %ebp
  803878:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  80387a:	6a 00                	push   $0x0
  80387c:	6a 00                	push   $0x0
  80387e:	6a 00                	push   $0x0
  803880:	6a 00                	push   $0x0
  803882:	6a 00                	push   $0x0
  803884:	6a 23                	push   $0x23
  803886:	e8 c6 fb ff ff       	call   803451 <syscall>
  80388b:	83 c4 18             	add    $0x18,%esp
	return ;
  80388e:	90                   	nop
}
  80388f:	c9                   	leave  
  803890:	c3                   	ret    

00803891 <gettst>:
uint32 gettst()
{
  803891:	55                   	push   %ebp
  803892:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  803894:	6a 00                	push   $0x0
  803896:	6a 00                	push   $0x0
  803898:	6a 00                	push   $0x0
  80389a:	6a 00                	push   $0x0
  80389c:	6a 00                	push   $0x0
  80389e:	6a 24                	push   $0x24
  8038a0:	e8 ac fb ff ff       	call   803451 <syscall>
  8038a5:	83 c4 18             	add    $0x18,%esp
}
  8038a8:	c9                   	leave  
  8038a9:	c3                   	ret    

008038aa <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  8038aa:	55                   	push   %ebp
  8038ab:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8038ad:	6a 00                	push   $0x0
  8038af:	6a 00                	push   $0x0
  8038b1:	6a 00                	push   $0x0
  8038b3:	6a 00                	push   $0x0
  8038b5:	6a 00                	push   $0x0
  8038b7:	6a 25                	push   $0x25
  8038b9:	e8 93 fb ff ff       	call   803451 <syscall>
  8038be:	83 c4 18             	add    $0x18,%esp
  8038c1:	a3 60 e0 81 00       	mov    %eax,0x81e060
	return uheapPlaceStrategy ;
  8038c6:	a1 60 e0 81 00       	mov    0x81e060,%eax
}
  8038cb:	c9                   	leave  
  8038cc:	c3                   	ret    

008038cd <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  8038cd:	55                   	push   %ebp
  8038ce:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  8038d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8038d3:	a3 60 e0 81 00       	mov    %eax,0x81e060
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  8038d8:	6a 00                	push   $0x0
  8038da:	6a 00                	push   $0x0
  8038dc:	6a 00                	push   $0x0
  8038de:	6a 00                	push   $0x0
  8038e0:	ff 75 08             	pushl  0x8(%ebp)
  8038e3:	6a 26                	push   $0x26
  8038e5:	e8 67 fb ff ff       	call   803451 <syscall>
  8038ea:	83 c4 18             	add    $0x18,%esp
	return ;
  8038ed:	90                   	nop
}
  8038ee:	c9                   	leave  
  8038ef:	c3                   	ret    

008038f0 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  8038f0:	55                   	push   %ebp
  8038f1:	89 e5                	mov    %esp,%ebp
  8038f3:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  8038f4:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8038f7:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8038fa:	8b 55 0c             	mov    0xc(%ebp),%edx
  8038fd:	8b 45 08             	mov    0x8(%ebp),%eax
  803900:	6a 00                	push   $0x0
  803902:	53                   	push   %ebx
  803903:	51                   	push   %ecx
  803904:	52                   	push   %edx
  803905:	50                   	push   %eax
  803906:	6a 27                	push   $0x27
  803908:	e8 44 fb ff ff       	call   803451 <syscall>
  80390d:	83 c4 18             	add    $0x18,%esp
}
  803910:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  803913:	c9                   	leave  
  803914:	c3                   	ret    

00803915 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  803915:	55                   	push   %ebp
  803916:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  803918:	8b 55 0c             	mov    0xc(%ebp),%edx
  80391b:	8b 45 08             	mov    0x8(%ebp),%eax
  80391e:	6a 00                	push   $0x0
  803920:	6a 00                	push   $0x0
  803922:	6a 00                	push   $0x0
  803924:	52                   	push   %edx
  803925:	50                   	push   %eax
  803926:	6a 28                	push   $0x28
  803928:	e8 24 fb ff ff       	call   803451 <syscall>
  80392d:	83 c4 18             	add    $0x18,%esp
}
  803930:	c9                   	leave  
  803931:	c3                   	ret    

00803932 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  803932:	55                   	push   %ebp
  803933:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  803935:	8b 4d 14             	mov    0x14(%ebp),%ecx
  803938:	8b 55 0c             	mov    0xc(%ebp),%edx
  80393b:	8b 45 08             	mov    0x8(%ebp),%eax
  80393e:	6a 00                	push   $0x0
  803940:	51                   	push   %ecx
  803941:	ff 75 10             	pushl  0x10(%ebp)
  803944:	52                   	push   %edx
  803945:	50                   	push   %eax
  803946:	6a 29                	push   $0x29
  803948:	e8 04 fb ff ff       	call   803451 <syscall>
  80394d:	83 c4 18             	add    $0x18,%esp
}
  803950:	c9                   	leave  
  803951:	c3                   	ret    

00803952 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  803952:	55                   	push   %ebp
  803953:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  803955:	6a 00                	push   $0x0
  803957:	6a 00                	push   $0x0
  803959:	ff 75 10             	pushl  0x10(%ebp)
  80395c:	ff 75 0c             	pushl  0xc(%ebp)
  80395f:	ff 75 08             	pushl  0x8(%ebp)
  803962:	6a 12                	push   $0x12
  803964:	e8 e8 fa ff ff       	call   803451 <syscall>
  803969:	83 c4 18             	add    $0x18,%esp
	return ;
  80396c:	90                   	nop
}
  80396d:	c9                   	leave  
  80396e:	c3                   	ret    

0080396f <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  80396f:	55                   	push   %ebp
  803970:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  803972:	8b 55 0c             	mov    0xc(%ebp),%edx
  803975:	8b 45 08             	mov    0x8(%ebp),%eax
  803978:	6a 00                	push   $0x0
  80397a:	6a 00                	push   $0x0
  80397c:	6a 00                	push   $0x0
  80397e:	52                   	push   %edx
  80397f:	50                   	push   %eax
  803980:	6a 2a                	push   $0x2a
  803982:	e8 ca fa ff ff       	call   803451 <syscall>
  803987:	83 c4 18             	add    $0x18,%esp
	return;
  80398a:	90                   	nop
}
  80398b:	c9                   	leave  
  80398c:	c3                   	ret    

0080398d <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  80398d:	55                   	push   %ebp
  80398e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  803990:	6a 00                	push   $0x0
  803992:	6a 00                	push   $0x0
  803994:	6a 00                	push   $0x0
  803996:	6a 00                	push   $0x0
  803998:	6a 00                	push   $0x0
  80399a:	6a 2b                	push   $0x2b
  80399c:	e8 b0 fa ff ff       	call   803451 <syscall>
  8039a1:	83 c4 18             	add    $0x18,%esp
}
  8039a4:	c9                   	leave  
  8039a5:	c3                   	ret    

008039a6 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8039a6:	55                   	push   %ebp
  8039a7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  8039a9:	6a 00                	push   $0x0
  8039ab:	6a 00                	push   $0x0
  8039ad:	6a 00                	push   $0x0
  8039af:	ff 75 0c             	pushl  0xc(%ebp)
  8039b2:	ff 75 08             	pushl  0x8(%ebp)
  8039b5:	6a 2d                	push   $0x2d
  8039b7:	e8 95 fa ff ff       	call   803451 <syscall>
  8039bc:	83 c4 18             	add    $0x18,%esp
	return;
  8039bf:	90                   	nop
}
  8039c0:	c9                   	leave  
  8039c1:	c3                   	ret    

008039c2 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8039c2:	55                   	push   %ebp
  8039c3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  8039c5:	6a 00                	push   $0x0
  8039c7:	6a 00                	push   $0x0
  8039c9:	6a 00                	push   $0x0
  8039cb:	ff 75 0c             	pushl  0xc(%ebp)
  8039ce:	ff 75 08             	pushl  0x8(%ebp)
  8039d1:	6a 2c                	push   $0x2c
  8039d3:	e8 79 fa ff ff       	call   803451 <syscall>
  8039d8:	83 c4 18             	add    $0x18,%esp
	return ;
  8039db:	90                   	nop
}
  8039dc:	c9                   	leave  
  8039dd:	c3                   	ret    

008039de <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  8039de:	55                   	push   %ebp
  8039df:	89 e5                	mov    %esp,%ebp
	//TODO: [PROJECT'25.IM#4] CPU SCHEDULING - #1 System Calls - Add suitable code here
	//Your code is here
	//Comment the following line
	//panic("sys_env_set_priority() is not implemented yet...!!");
	syscall(SYS_env_set_priority, envID, priority, 0, 0, 0);
  8039e1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8039e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8039e7:	6a 00                	push   $0x0
  8039e9:	6a 00                	push   $0x0
  8039eb:	6a 00                	push   $0x0
  8039ed:	52                   	push   %edx
  8039ee:	50                   	push   %eax
  8039ef:	6a 2e                	push   $0x2e
  8039f1:	e8 5b fa ff ff       	call   803451 <syscall>
  8039f6:	83 c4 18             	add    $0x18,%esp
	    return;
  8039f9:	90                   	nop
}
  8039fa:	c9                   	leave  
  8039fb:	c3                   	ret    

008039fc <to_page_va>:
//==================================================================================//
//==================================
// [1] GET PAGE VA:
//==================================
__inline__ uint32 to_page_va(struct PageInfoElement *ptrPageInfo)
{
  8039fc:	55                   	push   %ebp
  8039fd:	89 e5                	mov    %esp,%ebp
  8039ff:	83 ec 10             	sub    $0x10,%esp
	//Get start VA of the page from the corresponding Page Info pointer
	int idxInPageInfoArr = (ptrPageInfo - pageBlockInfoArr);
  803a02:	8b 45 08             	mov    0x8(%ebp),%eax
  803a05:	ba 60 60 80 00       	mov    $0x806060,%edx
  803a0a:	29 d0                	sub    %edx,%eax
  803a0c:	c1 f8 02             	sar    $0x2,%eax
  803a0f:	89 c2                	mov    %eax,%edx
  803a11:	89 d0                	mov    %edx,%eax
  803a13:	c1 e0 02             	shl    $0x2,%eax
  803a16:	01 d0                	add    %edx,%eax
  803a18:	c1 e0 02             	shl    $0x2,%eax
  803a1b:	01 d0                	add    %edx,%eax
  803a1d:	c1 e0 02             	shl    $0x2,%eax
  803a20:	01 d0                	add    %edx,%eax
  803a22:	89 c1                	mov    %eax,%ecx
  803a24:	c1 e1 08             	shl    $0x8,%ecx
  803a27:	01 c8                	add    %ecx,%eax
  803a29:	89 c1                	mov    %eax,%ecx
  803a2b:	c1 e1 10             	shl    $0x10,%ecx
  803a2e:	01 c8                	add    %ecx,%eax
  803a30:	01 c0                	add    %eax,%eax
  803a32:	01 d0                	add    %edx,%eax
  803a34:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return dynAllocStart + (idxInPageInfoArr << PGSHIFT);
  803a37:	8b 45 fc             	mov    -0x4(%ebp),%eax
  803a3a:	c1 e0 0c             	shl    $0xc,%eax
  803a3d:	89 c2                	mov    %eax,%edx
  803a3f:	a1 64 e0 81 00       	mov    0x81e064,%eax
  803a44:	01 d0                	add    %edx,%eax
}
  803a46:	c9                   	leave  
  803a47:	c3                   	ret    

00803a48 <log2>:

//==================================================================================//
//============================ REQUIRED FUNCTIONS ==================================//
//==================================================================================//
__inline__ int log2(uint32 n)
	{
  803a48:	55                   	push   %ebp
  803a49:	89 e5                	mov    %esp,%ebp
  803a4b:	83 ec 10             	sub    $0x10,%esp
		int result = 0;
  803a4e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
		while( n > 1){
  803a55:	eb 06                	jmp    803a5d <log2+0x15>
			n >>=1;
  803a57:	d1 6d 08             	shrl   0x8(%ebp)
			result++;
  803a5a:	ff 45 fc             	incl   -0x4(%ebp)
//============================ REQUIRED FUNCTIONS ==================================//
//==================================================================================//
__inline__ int log2(uint32 n)
	{
		int result = 0;
		while( n > 1){
  803a5d:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
  803a61:	77 f4                	ja     803a57 <log2+0xf>
			n >>=1;
			result++;
		}
		return result;
  803a63:	8b 45 fc             	mov    -0x4(%ebp),%eax
	}
  803a66:	c9                   	leave  
  803a67:	c3                   	ret    

00803a68 <initialize_dynamic_allocator>:
//==================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================
bool is_initialized = 0;
void initialize_dynamic_allocator(uint32 daStart, uint32 daEnd)
{
  803a68:	55                   	push   %ebp
  803a69:	89 e5                	mov    %esp,%ebp
  803a6b:	83 ec 18             	sub    $0x18,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(daEnd <= daStart + DYN_ALLOC_MAX_SIZE);
  803a6e:	8b 45 08             	mov    0x8(%ebp),%eax
  803a71:	05 00 00 00 02       	add    $0x2000000,%eax
  803a76:	3b 45 0c             	cmp    0xc(%ebp),%eax
  803a79:	73 16                	jae    803a91 <initialize_dynamic_allocator+0x29>
  803a7b:	68 b8 51 80 00       	push   $0x8051b8
  803a80:	68 de 51 80 00       	push   $0x8051de
  803a85:	6a 2d                	push   $0x2d
  803a87:	68 f3 51 80 00       	push   $0x8051f3
  803a8c:	e8 a6 ce ff ff       	call   800937 <_panic>
		is_initialized = 1;
  803a91:	c7 05 28 60 80 00 01 	movl   $0x1,0x806028
  803a98:	00 00 00 
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #1 initialize_dynamic_allocator
	//Your code is here


	dynAllocStart = daStart;
  803a9b:	8b 45 08             	mov    0x8(%ebp),%eax
  803a9e:	a3 64 e0 81 00       	mov    %eax,0x81e064
	dynAllocEnd= daEnd;
  803aa3:	8b 45 0c             	mov    0xc(%ebp),%eax
  803aa6:	a3 40 60 80 00       	mov    %eax,0x806040
	int numOfPages = (dynAllocEnd - dynAllocStart)/PAGE_SIZE;
  803aab:	8b 15 40 60 80 00    	mov    0x806040,%edx
  803ab1:	a1 64 e0 81 00       	mov    0x81e064,%eax
  803ab6:	29 c2                	sub    %eax,%edx
  803ab8:	89 d0                	mov    %edx,%eax
  803aba:	c1 e8 0c             	shr    $0xc,%eax
  803abd:	89 45 e8             	mov    %eax,-0x18(%ebp)


	for(int i=0; i< numOfPages; i++){
  803ac0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  803ac7:	eb 2f                	jmp    803af8 <initialize_dynamic_allocator+0x90>
	    pageBlockInfoArr[i].block_size=0;
  803ac9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803acc:	89 d0                	mov    %edx,%eax
  803ace:	01 c0                	add    %eax,%eax
  803ad0:	01 d0                	add    %edx,%eax
  803ad2:	c1 e0 02             	shl    $0x2,%eax
  803ad5:	05 68 60 80 00       	add    $0x806068,%eax
  803ada:	66 c7 00 00 00       	movw   $0x0,(%eax)
	    pageBlockInfoArr[i].num_of_free_blocks=0;
  803adf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803ae2:	89 d0                	mov    %edx,%eax
  803ae4:	01 c0                	add    %eax,%eax
  803ae6:	01 d0                	add    %edx,%eax
  803ae8:	c1 e0 02             	shl    $0x2,%eax
  803aeb:	05 6a 60 80 00       	add    $0x80606a,%eax
  803af0:	66 c7 00 00 00       	movw   $0x0,(%eax)
	dynAllocStart = daStart;
	dynAllocEnd= daEnd;
	int numOfPages = (dynAllocEnd - dynAllocStart)/PAGE_SIZE;


	for(int i=0; i< numOfPages; i++){
  803af5:	ff 45 f4             	incl   -0xc(%ebp)
  803af8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803afb:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803afe:	7c c9                	jl     803ac9 <initialize_dynamic_allocator+0x61>
	    pageBlockInfoArr[i].block_size=0;
	    pageBlockInfoArr[i].num_of_free_blocks=0;
	}


	LIST_INIT(&freePagesList);
  803b00:	c7 05 48 60 80 00 00 	movl   $0x0,0x806048
  803b07:	00 00 00 
  803b0a:	c7 05 4c 60 80 00 00 	movl   $0x0,0x80604c
  803b11:	00 00 00 
  803b14:	c7 05 54 60 80 00 00 	movl   $0x0,0x806054
  803b1b:	00 00 00 
	for(int i=0; i<numOfPages; i++){
  803b1e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  803b25:	e9 9c 00 00 00       	jmp    803bc6 <initialize_dynamic_allocator+0x15e>
		LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
  803b2a:	8b 15 4c 60 80 00    	mov    0x80604c,%edx
  803b30:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  803b33:	89 c8                	mov    %ecx,%eax
  803b35:	01 c0                	add    %eax,%eax
  803b37:	01 c8                	add    %ecx,%eax
  803b39:	c1 e0 02             	shl    $0x2,%eax
  803b3c:	05 64 60 80 00       	add    $0x806064,%eax
  803b41:	89 10                	mov    %edx,(%eax)
  803b43:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803b46:	89 d0                	mov    %edx,%eax
  803b48:	01 c0                	add    %eax,%eax
  803b4a:	01 d0                	add    %edx,%eax
  803b4c:	c1 e0 02             	shl    $0x2,%eax
  803b4f:	05 64 60 80 00       	add    $0x806064,%eax
  803b54:	8b 00                	mov    (%eax),%eax
  803b56:	85 c0                	test   %eax,%eax
  803b58:	74 1b                	je     803b75 <initialize_dynamic_allocator+0x10d>
  803b5a:	8b 15 4c 60 80 00    	mov    0x80604c,%edx
  803b60:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  803b63:	89 c8                	mov    %ecx,%eax
  803b65:	01 c0                	add    %eax,%eax
  803b67:	01 c8                	add    %ecx,%eax
  803b69:	c1 e0 02             	shl    $0x2,%eax
  803b6c:	05 60 60 80 00       	add    $0x806060,%eax
  803b71:	89 02                	mov    %eax,(%edx)
  803b73:	eb 16                	jmp    803b8b <initialize_dynamic_allocator+0x123>
  803b75:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803b78:	89 d0                	mov    %edx,%eax
  803b7a:	01 c0                	add    %eax,%eax
  803b7c:	01 d0                	add    %edx,%eax
  803b7e:	c1 e0 02             	shl    $0x2,%eax
  803b81:	05 60 60 80 00       	add    $0x806060,%eax
  803b86:	a3 48 60 80 00       	mov    %eax,0x806048
  803b8b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803b8e:	89 d0                	mov    %edx,%eax
  803b90:	01 c0                	add    %eax,%eax
  803b92:	01 d0                	add    %edx,%eax
  803b94:	c1 e0 02             	shl    $0x2,%eax
  803b97:	05 60 60 80 00       	add    $0x806060,%eax
  803b9c:	a3 4c 60 80 00       	mov    %eax,0x80604c
  803ba1:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803ba4:	89 d0                	mov    %edx,%eax
  803ba6:	01 c0                	add    %eax,%eax
  803ba8:	01 d0                	add    %edx,%eax
  803baa:	c1 e0 02             	shl    $0x2,%eax
  803bad:	05 60 60 80 00       	add    $0x806060,%eax
  803bb2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803bb8:	a1 54 60 80 00       	mov    0x806054,%eax
  803bbd:	40                   	inc    %eax
  803bbe:	a3 54 60 80 00       	mov    %eax,0x806054
	    pageBlockInfoArr[i].num_of_free_blocks=0;
	}


	LIST_INIT(&freePagesList);
	for(int i=0; i<numOfPages; i++){
  803bc3:	ff 45 f0             	incl   -0x10(%ebp)
  803bc6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803bc9:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803bcc:	0f 8c 58 ff ff ff    	jl     803b2a <initialize_dynamic_allocator+0xc2>
		LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
	}



	for (int i = 0; i < LOG2_MAX_SIZE - LOG2_MIN_SIZE + 1; i++) {
  803bd2:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  803bd9:	eb 36                	jmp    803c11 <initialize_dynamic_allocator+0x1a9>
	    LIST_INIT(&freeBlockLists[i]);
  803bdb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803bde:	c1 e0 04             	shl    $0x4,%eax
  803be1:	05 80 e0 81 00       	add    $0x81e080,%eax
  803be6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803bec:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803bef:	c1 e0 04             	shl    $0x4,%eax
  803bf2:	05 84 e0 81 00       	add    $0x81e084,%eax
  803bf7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803bfd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803c00:	c1 e0 04             	shl    $0x4,%eax
  803c03:	05 8c e0 81 00       	add    $0x81e08c,%eax
  803c08:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
	}



	for (int i = 0; i < LOG2_MAX_SIZE - LOG2_MIN_SIZE + 1; i++) {
  803c0e:	ff 45 ec             	incl   -0x14(%ebp)
  803c11:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  803c15:	7e c4                	jle    803bdb <initialize_dynamic_allocator+0x173>


	//Comment the following line
	//panic("initialize_dynamic_allocator() Not implemented yet");

}
  803c17:	90                   	nop
  803c18:	c9                   	leave  
  803c19:	c3                   	ret    

00803c1a <get_block_size>:
// [2] GET BLOCK SIZE:
//===========================


__inline__ uint32 get_block_size(void *va)
{
  803c1a:	55                   	push   %ebp
  803c1b:	89 e5                	mov    %esp,%ebp
  803c1d:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #2 get_block_size
	//Your code is here

	uint32 page_index = ((uint32)va - dynAllocStart)/ PAGE_SIZE;
  803c20:	8b 55 08             	mov    0x8(%ebp),%edx
  803c23:	a1 64 e0 81 00       	mov    0x81e064,%eax
  803c28:	29 c2                	sub    %eax,%edx
  803c2a:	89 d0                	mov    %edx,%eax
  803c2c:	c1 e8 0c             	shr    $0xc,%eax
  803c2f:	89 45 fc             	mov    %eax,-0x4(%ebp)
    return pageBlockInfoArr[page_index].block_size;
  803c32:	8b 55 fc             	mov    -0x4(%ebp),%edx
  803c35:	89 d0                	mov    %edx,%eax
  803c37:	01 c0                	add    %eax,%eax
  803c39:	01 d0                	add    %edx,%eax
  803c3b:	c1 e0 02             	shl    $0x2,%eax
  803c3e:	05 68 60 80 00       	add    $0x806068,%eax
  803c43:	8b 00                	mov    (%eax),%eax
  803c45:	0f b7 c0             	movzwl %ax,%eax
	//Comment the following line
	//panic("get_block_size() Not implemented yet");
}
  803c48:	c9                   	leave  
  803c49:	c3                   	ret    

00803c4a <alloc_block>:

//===========================
// 3) ALLOCATE BLOCK:
//===========================
void *alloc_block(uint32 size)
{
  803c4a:	55                   	push   %ebp
  803c4b:	89 e5                	mov    %esp,%ebp
  803c4d:	83 ec 48             	sub    $0x48,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(size <= DYN_ALLOC_MAX_BLOCK_SIZE);
  803c50:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  803c57:	76 16                	jbe    803c6f <alloc_block+0x25>
  803c59:	68 0c 52 80 00       	push   $0x80520c
  803c5e:	68 de 51 80 00       	push   $0x8051de
  803c63:	6a 6c                	push   $0x6c
  803c65:	68 f3 51 80 00       	push   $0x8051f3
  803c6a:	e8 c8 cc ff ff       	call   800937 <_panic>
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #3 alloc_block
	//Your code is here


	if(size == 0){
  803c6f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803c73:	75 0a                	jne    803c7f <alloc_block+0x35>
		return NULL;
  803c75:	b8 00 00 00 00       	mov    $0x0,%eax
  803c7a:	e9 65 04 00 00       	jmp    8040e4 <alloc_block+0x49a>
	}
	else if(size<=8){
  803c7f:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  803c83:	77 09                	ja     803c8e <alloc_block+0x44>
		size=8;
  803c85:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
  803c8c:	eb 1f                	jmp    803cad <alloc_block+0x63>
	}
	else{
		uint32 reqsize=8;
  803c8e:	c7 45 f4 08 00 00 00 	movl   $0x8,-0xc(%ebp)
		while(reqsize < size){
  803c95:	eb 08                	jmp    803c9f <alloc_block+0x55>
			reqsize*=2;
  803c97:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c9a:	01 c0                	add    %eax,%eax
  803c9c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	else if(size<=8){
		size=8;
	}
	else{
		uint32 reqsize=8;
		while(reqsize < size){
  803c9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ca2:	3b 45 08             	cmp    0x8(%ebp),%eax
  803ca5:	72 f0                	jb     803c97 <alloc_block+0x4d>
			reqsize*=2;
		}
		size= reqsize;
  803ca7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803caa:	89 45 08             	mov    %eax,0x8(%ebp)
	}

	int list_index = log2(size)- LOG2_MIN_SIZE;
  803cad:	83 ec 0c             	sub    $0xc,%esp
  803cb0:	ff 75 08             	pushl  0x8(%ebp)
  803cb3:	e8 90 fd ff ff       	call   803a48 <log2>
  803cb8:	83 c4 10             	add    $0x10,%esp
  803cbb:	83 e8 03             	sub    $0x3,%eax
  803cbe:	89 45 e8             	mov    %eax,-0x18(%ebp)

	if(!LIST_EMPTY(&freeBlockLists[list_index])){
  803cc1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803cc4:	c1 e0 04             	shl    $0x4,%eax
  803cc7:	05 80 e0 81 00       	add    $0x81e080,%eax
  803ccc:	8b 00                	mov    (%eax),%eax
  803cce:	85 c0                	test   %eax,%eax
  803cd0:	0f 84 fb 00 00 00    	je     803dd1 <alloc_block+0x187>
		struct BlockElement *block = LIST_FIRST(&freeBlockLists[list_index]);
  803cd6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803cd9:	c1 e0 04             	shl    $0x4,%eax
  803cdc:	05 80 e0 81 00       	add    $0x81e080,%eax
  803ce1:	8b 00                	mov    (%eax),%eax
  803ce3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		LIST_REMOVE(&freeBlockLists[list_index], block);
  803ce6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803cea:	75 17                	jne    803d03 <alloc_block+0xb9>
  803cec:	83 ec 04             	sub    $0x4,%esp
  803cef:	68 2d 52 80 00       	push   $0x80522d
  803cf4:	68 86 00 00 00       	push   $0x86
  803cf9:	68 f3 51 80 00       	push   $0x8051f3
  803cfe:	e8 34 cc ff ff       	call   800937 <_panic>
  803d03:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803d06:	8b 00                	mov    (%eax),%eax
  803d08:	85 c0                	test   %eax,%eax
  803d0a:	74 10                	je     803d1c <alloc_block+0xd2>
  803d0c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803d0f:	8b 00                	mov    (%eax),%eax
  803d11:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803d14:	8b 52 04             	mov    0x4(%edx),%edx
  803d17:	89 50 04             	mov    %edx,0x4(%eax)
  803d1a:	eb 14                	jmp    803d30 <alloc_block+0xe6>
  803d1c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803d1f:	8b 40 04             	mov    0x4(%eax),%eax
  803d22:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803d25:	c1 e2 04             	shl    $0x4,%edx
  803d28:	81 c2 84 e0 81 00    	add    $0x81e084,%edx
  803d2e:	89 02                	mov    %eax,(%edx)
  803d30:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803d33:	8b 40 04             	mov    0x4(%eax),%eax
  803d36:	85 c0                	test   %eax,%eax
  803d38:	74 0f                	je     803d49 <alloc_block+0xff>
  803d3a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803d3d:	8b 40 04             	mov    0x4(%eax),%eax
  803d40:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803d43:	8b 12                	mov    (%edx),%edx
  803d45:	89 10                	mov    %edx,(%eax)
  803d47:	eb 13                	jmp    803d5c <alloc_block+0x112>
  803d49:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803d4c:	8b 00                	mov    (%eax),%eax
  803d4e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803d51:	c1 e2 04             	shl    $0x4,%edx
  803d54:	81 c2 80 e0 81 00    	add    $0x81e080,%edx
  803d5a:	89 02                	mov    %eax,(%edx)
  803d5c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803d5f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803d65:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803d68:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803d6f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803d72:	c1 e0 04             	shl    $0x4,%eax
  803d75:	05 8c e0 81 00       	add    $0x81e08c,%eax
  803d7a:	8b 00                	mov    (%eax),%eax
  803d7c:	8d 50 ff             	lea    -0x1(%eax),%edx
  803d7f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803d82:	c1 e0 04             	shl    $0x4,%eax
  803d85:	05 8c e0 81 00       	add    $0x81e08c,%eax
  803d8a:	89 10                	mov    %edx,(%eax)
		uint32 page_index = ((uint32)block - dynAllocStart)/ PAGE_SIZE;
  803d8c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803d8f:	a1 64 e0 81 00       	mov    0x81e064,%eax
  803d94:	29 c2                	sub    %eax,%edx
  803d96:	89 d0                	mov    %edx,%eax
  803d98:	c1 e8 0c             	shr    $0xc,%eax
  803d9b:	89 45 e0             	mov    %eax,-0x20(%ebp)
		pageBlockInfoArr[page_index].num_of_free_blocks--;
  803d9e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803da1:	89 d0                	mov    %edx,%eax
  803da3:	01 c0                	add    %eax,%eax
  803da5:	01 d0                	add    %edx,%eax
  803da7:	c1 e0 02             	shl    $0x2,%eax
  803daa:	05 6a 60 80 00       	add    $0x80606a,%eax
  803daf:	66 8b 00             	mov    (%eax),%ax
  803db2:	8d 50 ff             	lea    -0x1(%eax),%edx
  803db5:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  803db8:	89 c8                	mov    %ecx,%eax
  803dba:	01 c0                	add    %eax,%eax
  803dbc:	01 c8                	add    %ecx,%eax
  803dbe:	c1 e0 02             	shl    $0x2,%eax
  803dc1:	05 6a 60 80 00       	add    $0x80606a,%eax
  803dc6:	66 89 10             	mov    %dx,(%eax)
		return (void*)block;
  803dc9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803dcc:	e9 13 03 00 00       	jmp    8040e4 <alloc_block+0x49a>
	}

	if(!LIST_EMPTY(&freePagesList)){
  803dd1:	a1 48 60 80 00       	mov    0x806048,%eax
  803dd6:	85 c0                	test   %eax,%eax
  803dd8:	0f 84 c9 01 00 00    	je     803fa7 <alloc_block+0x35d>

		struct PageInfoElement *page_info = LIST_FIRST(&freePagesList);
  803dde:	a1 48 60 80 00       	mov    0x806048,%eax
  803de3:	89 45 dc             	mov    %eax,-0x24(%ebp)
		LIST_REMOVE(&freePagesList, page_info);
  803de6:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803dea:	75 17                	jne    803e03 <alloc_block+0x1b9>
  803dec:	83 ec 04             	sub    $0x4,%esp
  803def:	68 2d 52 80 00       	push   $0x80522d
  803df4:	68 8f 00 00 00       	push   $0x8f
  803df9:	68 f3 51 80 00       	push   $0x8051f3
  803dfe:	e8 34 cb ff ff       	call   800937 <_panic>
  803e03:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803e06:	8b 00                	mov    (%eax),%eax
  803e08:	85 c0                	test   %eax,%eax
  803e0a:	74 10                	je     803e1c <alloc_block+0x1d2>
  803e0c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803e0f:	8b 00                	mov    (%eax),%eax
  803e11:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803e14:	8b 52 04             	mov    0x4(%edx),%edx
  803e17:	89 50 04             	mov    %edx,0x4(%eax)
  803e1a:	eb 0b                	jmp    803e27 <alloc_block+0x1dd>
  803e1c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803e1f:	8b 40 04             	mov    0x4(%eax),%eax
  803e22:	a3 4c 60 80 00       	mov    %eax,0x80604c
  803e27:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803e2a:	8b 40 04             	mov    0x4(%eax),%eax
  803e2d:	85 c0                	test   %eax,%eax
  803e2f:	74 0f                	je     803e40 <alloc_block+0x1f6>
  803e31:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803e34:	8b 40 04             	mov    0x4(%eax),%eax
  803e37:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803e3a:	8b 12                	mov    (%edx),%edx
  803e3c:	89 10                	mov    %edx,(%eax)
  803e3e:	eb 0a                	jmp    803e4a <alloc_block+0x200>
  803e40:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803e43:	8b 00                	mov    (%eax),%eax
  803e45:	a3 48 60 80 00       	mov    %eax,0x806048
  803e4a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803e4d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803e53:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803e56:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803e5d:	a1 54 60 80 00       	mov    0x806054,%eax
  803e62:	48                   	dec    %eax
  803e63:	a3 54 60 80 00       	mov    %eax,0x806054
		uint32 page_va = to_page_va(page_info);
  803e68:	83 ec 0c             	sub    $0xc,%esp
  803e6b:	ff 75 dc             	pushl  -0x24(%ebp)
  803e6e:	e8 89 fb ff ff       	call   8039fc <to_page_va>
  803e73:	83 c4 10             	add    $0x10,%esp
  803e76:	89 45 d8             	mov    %eax,-0x28(%ebp)

		uint32 page_index = (page_va - dynAllocStart)/ PAGE_SIZE;
  803e79:	a1 64 e0 81 00       	mov    0x81e064,%eax
  803e7e:	8b 55 d8             	mov    -0x28(%ebp),%edx
  803e81:	29 c2                	sub    %eax,%edx
  803e83:	89 d0                	mov    %edx,%eax
  803e85:	c1 e8 0c             	shr    $0xc,%eax
  803e88:	89 45 d4             	mov    %eax,-0x2c(%ebp)

		get_page((void*)page_va);
  803e8b:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803e8e:	83 ec 0c             	sub    $0xc,%esp
  803e91:	50                   	push   %eax
  803e92:	e8 fe dc ff ff       	call   801b95 <get_page>
  803e97:	83 c4 10             	add    $0x10,%esp


		pageBlockInfoArr[page_index].block_size = size;
  803e9a:	8b 45 08             	mov    0x8(%ebp),%eax
  803e9d:	89 c2                	mov    %eax,%edx
  803e9f:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  803ea2:	89 c8                	mov    %ecx,%eax
  803ea4:	01 c0                	add    %eax,%eax
  803ea6:	01 c8                	add    %ecx,%eax
  803ea8:	c1 e0 02             	shl    $0x2,%eax
  803eab:	05 68 60 80 00       	add    $0x806068,%eax
  803eb0:	66 89 10             	mov    %dx,(%eax)
		int num_blocks = PAGE_SIZE / size ;
  803eb3:	b8 00 10 00 00       	mov    $0x1000,%eax
  803eb8:	ba 00 00 00 00       	mov    $0x0,%edx
  803ebd:	f7 75 08             	divl   0x8(%ebp)
  803ec0:	89 45 d0             	mov    %eax,-0x30(%ebp)
		pageBlockInfoArr[page_index].num_of_free_blocks= num_blocks - 1 ;
  803ec3:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803ec6:	8d 50 ff             	lea    -0x1(%eax),%edx
  803ec9:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  803ecc:	89 c8                	mov    %ecx,%eax
  803ece:	01 c0                	add    %eax,%eax
  803ed0:	01 c8                	add    %ecx,%eax
  803ed2:	c1 e0 02             	shl    $0x2,%eax
  803ed5:	05 6a 60 80 00       	add    $0x80606a,%eax
  803eda:	66 89 10             	mov    %dx,(%eax)

		for(int i=1; i< num_blocks; i++){
  803edd:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
  803ee4:	e9 aa 00 00 00       	jmp    803f93 <alloc_block+0x349>
			struct BlockElement *new_block = (struct BlockElement*)(page_va + i *size);
  803ee9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803eec:	0f af 45 08          	imul   0x8(%ebp),%eax
  803ef0:	89 c2                	mov    %eax,%edx
  803ef2:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803ef5:	01 d0                	add    %edx,%eax
  803ef7:	89 45 cc             	mov    %eax,-0x34(%ebp)
			LIST_INSERT_TAIL(&freeBlockLists[list_index], new_block);
  803efa:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  803efe:	75 17                	jne    803f17 <alloc_block+0x2cd>
  803f00:	83 ec 04             	sub    $0x4,%esp
  803f03:	68 4c 52 80 00       	push   $0x80524c
  803f08:	68 9d 00 00 00       	push   $0x9d
  803f0d:	68 f3 51 80 00       	push   $0x8051f3
  803f12:	e8 20 ca ff ff       	call   800937 <_panic>
  803f17:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803f1a:	c1 e0 04             	shl    $0x4,%eax
  803f1d:	05 84 e0 81 00       	add    $0x81e084,%eax
  803f22:	8b 10                	mov    (%eax),%edx
  803f24:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803f27:	89 50 04             	mov    %edx,0x4(%eax)
  803f2a:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803f2d:	8b 40 04             	mov    0x4(%eax),%eax
  803f30:	85 c0                	test   %eax,%eax
  803f32:	74 14                	je     803f48 <alloc_block+0x2fe>
  803f34:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803f37:	c1 e0 04             	shl    $0x4,%eax
  803f3a:	05 84 e0 81 00       	add    $0x81e084,%eax
  803f3f:	8b 00                	mov    (%eax),%eax
  803f41:	8b 55 cc             	mov    -0x34(%ebp),%edx
  803f44:	89 10                	mov    %edx,(%eax)
  803f46:	eb 11                	jmp    803f59 <alloc_block+0x30f>
  803f48:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803f4b:	c1 e0 04             	shl    $0x4,%eax
  803f4e:	8d 90 80 e0 81 00    	lea    0x81e080(%eax),%edx
  803f54:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803f57:	89 02                	mov    %eax,(%edx)
  803f59:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803f5c:	c1 e0 04             	shl    $0x4,%eax
  803f5f:	8d 90 84 e0 81 00    	lea    0x81e084(%eax),%edx
  803f65:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803f68:	89 02                	mov    %eax,(%edx)
  803f6a:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803f6d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803f73:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803f76:	c1 e0 04             	shl    $0x4,%eax
  803f79:	05 8c e0 81 00       	add    $0x81e08c,%eax
  803f7e:	8b 00                	mov    (%eax),%eax
  803f80:	8d 50 01             	lea    0x1(%eax),%edx
  803f83:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803f86:	c1 e0 04             	shl    $0x4,%eax
  803f89:	05 8c e0 81 00       	add    $0x81e08c,%eax
  803f8e:	89 10                	mov    %edx,(%eax)

		pageBlockInfoArr[page_index].block_size = size;
		int num_blocks = PAGE_SIZE / size ;
		pageBlockInfoArr[page_index].num_of_free_blocks= num_blocks - 1 ;

		for(int i=1; i< num_blocks; i++){
  803f90:	ff 45 f0             	incl   -0x10(%ebp)
  803f93:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803f96:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  803f99:	0f 8c 4a ff ff ff    	jl     803ee9 <alloc_block+0x29f>
			struct BlockElement *new_block = (struct BlockElement*)(page_va + i *size);
			LIST_INSERT_TAIL(&freeBlockLists[list_index], new_block);
		}
		return(void*)page_va;
  803f9f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803fa2:	e9 3d 01 00 00       	jmp    8040e4 <alloc_block+0x49a>
	}


	for(int i =list_index+1; i<= LOG2_MAX_SIZE - LOG2_MIN_SIZE; i++){
  803fa7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803faa:	40                   	inc    %eax
  803fab:	89 45 ec             	mov    %eax,-0x14(%ebp)
  803fae:	e9 10 01 00 00       	jmp    8040c3 <alloc_block+0x479>

		if(!LIST_EMPTY(&freeBlockLists[i])){
  803fb3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803fb6:	c1 e0 04             	shl    $0x4,%eax
  803fb9:	05 80 e0 81 00       	add    $0x81e080,%eax
  803fbe:	8b 00                	mov    (%eax),%eax
  803fc0:	85 c0                	test   %eax,%eax
  803fc2:	0f 84 f8 00 00 00    	je     8040c0 <alloc_block+0x476>

			struct BlockElement *block = LIST_FIRST(&freeBlockLists[i]);
  803fc8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803fcb:	c1 e0 04             	shl    $0x4,%eax
  803fce:	05 80 e0 81 00       	add    $0x81e080,%eax
  803fd3:	8b 00                	mov    (%eax),%eax
  803fd5:	89 45 c8             	mov    %eax,-0x38(%ebp)
			LIST_REMOVE( &freeBlockLists[i], block);
  803fd8:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  803fdc:	75 17                	jne    803ff5 <alloc_block+0x3ab>
  803fde:	83 ec 04             	sub    $0x4,%esp
  803fe1:	68 2d 52 80 00       	push   $0x80522d
  803fe6:	68 a8 00 00 00       	push   $0xa8
  803feb:	68 f3 51 80 00       	push   $0x8051f3
  803ff0:	e8 42 c9 ff ff       	call   800937 <_panic>
  803ff5:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803ff8:	8b 00                	mov    (%eax),%eax
  803ffa:	85 c0                	test   %eax,%eax
  803ffc:	74 10                	je     80400e <alloc_block+0x3c4>
  803ffe:	8b 45 c8             	mov    -0x38(%ebp),%eax
  804001:	8b 00                	mov    (%eax),%eax
  804003:	8b 55 c8             	mov    -0x38(%ebp),%edx
  804006:	8b 52 04             	mov    0x4(%edx),%edx
  804009:	89 50 04             	mov    %edx,0x4(%eax)
  80400c:	eb 14                	jmp    804022 <alloc_block+0x3d8>
  80400e:	8b 45 c8             	mov    -0x38(%ebp),%eax
  804011:	8b 40 04             	mov    0x4(%eax),%eax
  804014:	8b 55 ec             	mov    -0x14(%ebp),%edx
  804017:	c1 e2 04             	shl    $0x4,%edx
  80401a:	81 c2 84 e0 81 00    	add    $0x81e084,%edx
  804020:	89 02                	mov    %eax,(%edx)
  804022:	8b 45 c8             	mov    -0x38(%ebp),%eax
  804025:	8b 40 04             	mov    0x4(%eax),%eax
  804028:	85 c0                	test   %eax,%eax
  80402a:	74 0f                	je     80403b <alloc_block+0x3f1>
  80402c:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80402f:	8b 40 04             	mov    0x4(%eax),%eax
  804032:	8b 55 c8             	mov    -0x38(%ebp),%edx
  804035:	8b 12                	mov    (%edx),%edx
  804037:	89 10                	mov    %edx,(%eax)
  804039:	eb 13                	jmp    80404e <alloc_block+0x404>
  80403b:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80403e:	8b 00                	mov    (%eax),%eax
  804040:	8b 55 ec             	mov    -0x14(%ebp),%edx
  804043:	c1 e2 04             	shl    $0x4,%edx
  804046:	81 c2 80 e0 81 00    	add    $0x81e080,%edx
  80404c:	89 02                	mov    %eax,(%edx)
  80404e:	8b 45 c8             	mov    -0x38(%ebp),%eax
  804051:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  804057:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80405a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  804061:	8b 45 ec             	mov    -0x14(%ebp),%eax
  804064:	c1 e0 04             	shl    $0x4,%eax
  804067:	05 8c e0 81 00       	add    $0x81e08c,%eax
  80406c:	8b 00                	mov    (%eax),%eax
  80406e:	8d 50 ff             	lea    -0x1(%eax),%edx
  804071:	8b 45 ec             	mov    -0x14(%ebp),%eax
  804074:	c1 e0 04             	shl    $0x4,%eax
  804077:	05 8c e0 81 00       	add    $0x81e08c,%eax
  80407c:	89 10                	mov    %edx,(%eax)

			uint32 page_index = ((uint32)block - dynAllocStart)/ PAGE_SIZE;
  80407e:	8b 55 c8             	mov    -0x38(%ebp),%edx
  804081:	a1 64 e0 81 00       	mov    0x81e064,%eax
  804086:	29 c2                	sub    %eax,%edx
  804088:	89 d0                	mov    %edx,%eax
  80408a:	c1 e8 0c             	shr    $0xc,%eax
  80408d:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			pageBlockInfoArr[page_index].num_of_free_blocks-- ;
  804090:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  804093:	89 d0                	mov    %edx,%eax
  804095:	01 c0                	add    %eax,%eax
  804097:	01 d0                	add    %edx,%eax
  804099:	c1 e0 02             	shl    $0x2,%eax
  80409c:	05 6a 60 80 00       	add    $0x80606a,%eax
  8040a1:	66 8b 00             	mov    (%eax),%ax
  8040a4:	8d 50 ff             	lea    -0x1(%eax),%edx
  8040a7:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  8040aa:	89 c8                	mov    %ecx,%eax
  8040ac:	01 c0                	add    %eax,%eax
  8040ae:	01 c8                	add    %ecx,%eax
  8040b0:	c1 e0 02             	shl    $0x2,%eax
  8040b3:	05 6a 60 80 00       	add    $0x80606a,%eax
  8040b8:	66 89 10             	mov    %dx,(%eax)

			return (void*)block;
  8040bb:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8040be:	eb 24                	jmp    8040e4 <alloc_block+0x49a>
		}
		return(void*)page_va;
	}


	for(int i =list_index+1; i<= LOG2_MAX_SIZE - LOG2_MIN_SIZE; i++){
  8040c0:	ff 45 ec             	incl   -0x14(%ebp)
  8040c3:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  8040c7:	0f 8e e6 fe ff ff    	jle    803fb3 <alloc_block+0x369>

			return (void*)block;
		}
	}

	panic("alloc_block: out of memory! ");
  8040cd:	83 ec 04             	sub    $0x4,%esp
  8040d0:	68 6f 52 80 00       	push   $0x80526f
  8040d5:	68 b1 00 00 00       	push   $0xb1
  8040da:	68 f3 51 80 00       	push   $0x8051f3
  8040df:	e8 53 c8 ff ff       	call   800937 <_panic>

	//Comment the following line
	//panic("alloc_block() Not implemented yet");

	//TODO: [PROJECT'25.BONUS#1] DYNAMIC ALLOCATOR - block if no free block
}
  8040e4:	c9                   	leave  
  8040e5:	c3                   	ret    

008040e6 <free_block>:

//===========================
// [4] FREE BLOCK:
//===========================
void free_block(void *va)
{
  8040e6:	55                   	push   %ebp
  8040e7:	89 e5                	mov    %esp,%ebp
  8040e9:	83 ec 38             	sub    $0x38,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert((uint32)va >= dynAllocStart && (uint32)va < dynAllocEnd);
  8040ec:	8b 55 08             	mov    0x8(%ebp),%edx
  8040ef:	a1 64 e0 81 00       	mov    0x81e064,%eax
  8040f4:	39 c2                	cmp    %eax,%edx
  8040f6:	72 0c                	jb     804104 <free_block+0x1e>
  8040f8:	8b 55 08             	mov    0x8(%ebp),%edx
  8040fb:	a1 40 60 80 00       	mov    0x806040,%eax
  804100:	39 c2                	cmp    %eax,%edx
  804102:	72 19                	jb     80411d <free_block+0x37>
  804104:	68 8c 52 80 00       	push   $0x80528c
  804109:	68 de 51 80 00       	push   $0x8051de
  80410e:	68 c3 00 00 00       	push   $0xc3
  804113:	68 f3 51 80 00       	push   $0x8051f3
  804118:	e8 1a c8 ff ff       	call   800937 <_panic>
	//==================================================================================

	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #4 free_block
	//Your code is here

	uint32 page_index=((uint32)va - dynAllocStart)/ PAGE_SIZE;
  80411d:	8b 55 08             	mov    0x8(%ebp),%edx
  804120:	a1 64 e0 81 00       	mov    0x81e064,%eax
  804125:	29 c2                	sub    %eax,%edx
  804127:	89 d0                	mov    %edx,%eax
  804129:	c1 e8 0c             	shr    $0xc,%eax
  80412c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 block_size = pageBlockInfoArr[page_index].block_size;
  80412f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  804132:	89 d0                	mov    %edx,%eax
  804134:	01 c0                	add    %eax,%eax
  804136:	01 d0                	add    %edx,%eax
  804138:	c1 e0 02             	shl    $0x2,%eax
  80413b:	05 68 60 80 00       	add    $0x806068,%eax
  804140:	8b 00                	mov    (%eax),%eax
  804142:	0f b7 c0             	movzwl %ax,%eax
  804145:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if(block_size == 0){
  804148:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80414c:	75 17                	jne    804165 <free_block+0x7f>
		panic("page is empty(already not allocated)");
  80414e:	83 ec 04             	sub    $0x4,%esp
  804151:	68 c4 52 80 00       	push   $0x8052c4
  804156:	68 cf 00 00 00       	push   $0xcf
  80415b:	68 f3 51 80 00       	push   $0x8051f3
  804160:	e8 d2 c7 ff ff       	call   800937 <_panic>
	}

	int list_index = log2(block_size) - LOG2_MIN_SIZE;
  804165:	83 ec 0c             	sub    $0xc,%esp
  804168:	ff 75 ec             	pushl  -0x14(%ebp)
  80416b:	e8 d8 f8 ff ff       	call   803a48 <log2>
  804170:	83 c4 10             	add    $0x10,%esp
  804173:	83 e8 03             	sub    $0x3,%eax
  804176:	89 45 e8             	mov    %eax,-0x18(%ebp)
	// mn va l block "elta7weel mn virtual l phy hna"
	struct BlockElement *block = (struct BlockElement *)va;
  804179:	8b 45 08             	mov    0x8(%ebp),%eax
  80417c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	LIST_INSERT_TAIL(&freeBlockLists[list_index], block);
  80417f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  804183:	75 17                	jne    80419c <free_block+0xb6>
  804185:	83 ec 04             	sub    $0x4,%esp
  804188:	68 4c 52 80 00       	push   $0x80524c
  80418d:	68 d5 00 00 00       	push   $0xd5
  804192:	68 f3 51 80 00       	push   $0x8051f3
  804197:	e8 9b c7 ff ff       	call   800937 <_panic>
  80419c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80419f:	c1 e0 04             	shl    $0x4,%eax
  8041a2:	05 84 e0 81 00       	add    $0x81e084,%eax
  8041a7:	8b 10                	mov    (%eax),%edx
  8041a9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8041ac:	89 50 04             	mov    %edx,0x4(%eax)
  8041af:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8041b2:	8b 40 04             	mov    0x4(%eax),%eax
  8041b5:	85 c0                	test   %eax,%eax
  8041b7:	74 14                	je     8041cd <free_block+0xe7>
  8041b9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8041bc:	c1 e0 04             	shl    $0x4,%eax
  8041bf:	05 84 e0 81 00       	add    $0x81e084,%eax
  8041c4:	8b 00                	mov    (%eax),%eax
  8041c6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8041c9:	89 10                	mov    %edx,(%eax)
  8041cb:	eb 11                	jmp    8041de <free_block+0xf8>
  8041cd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8041d0:	c1 e0 04             	shl    $0x4,%eax
  8041d3:	8d 90 80 e0 81 00    	lea    0x81e080(%eax),%edx
  8041d9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8041dc:	89 02                	mov    %eax,(%edx)
  8041de:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8041e1:	c1 e0 04             	shl    $0x4,%eax
  8041e4:	8d 90 84 e0 81 00    	lea    0x81e084(%eax),%edx
  8041ea:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8041ed:	89 02                	mov    %eax,(%edx)
  8041ef:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8041f2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8041f8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8041fb:	c1 e0 04             	shl    $0x4,%eax
  8041fe:	05 8c e0 81 00       	add    $0x81e08c,%eax
  804203:	8b 00                	mov    (%eax),%eax
  804205:	8d 50 01             	lea    0x1(%eax),%edx
  804208:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80420b:	c1 e0 04             	shl    $0x4,%eax
  80420e:	05 8c e0 81 00       	add    $0x81e08c,%eax
  804213:	89 10                	mov    %edx,(%eax)
	// b3d ma wdytha fy el freeBlockLists hzwed elfree elly fy el array 1
	pageBlockInfoArr[page_index].num_of_free_blocks++;
  804215:	8b 55 f0             	mov    -0x10(%ebp),%edx
  804218:	89 d0                	mov    %edx,%eax
  80421a:	01 c0                	add    %eax,%eax
  80421c:	01 d0                	add    %edx,%eax
  80421e:	c1 e0 02             	shl    $0x2,%eax
  804221:	05 6a 60 80 00       	add    $0x80606a,%eax
  804226:	66 8b 00             	mov    (%eax),%ax
  804229:	8d 50 01             	lea    0x1(%eax),%edx
  80422c:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80422f:	89 c8                	mov    %ecx,%eax
  804231:	01 c0                	add    %eax,%eax
  804233:	01 c8                	add    %ecx,%eax
  804235:	c1 e0 02             	shl    $0x2,%eax
  804238:	05 6a 60 80 00       	add    $0x80606a,%eax
  80423d:	66 89 10             	mov    %dx,(%eax)
	int blocks_number = PAGE_SIZE / block_size;
  804240:	b8 00 10 00 00       	mov    $0x1000,%eax
  804245:	ba 00 00 00 00       	mov    $0x0,%edx
  80424a:	f7 75 ec             	divl   -0x14(%ebp)
  80424d:	89 45 e0             	mov    %eax,-0x20(%ebp)
	if(pageBlockInfoArr[page_index].num_of_free_blocks == blocks_number){
  804250:	8b 55 f0             	mov    -0x10(%ebp),%edx
  804253:	89 d0                	mov    %edx,%eax
  804255:	01 c0                	add    %eax,%eax
  804257:	01 d0                	add    %edx,%eax
  804259:	c1 e0 02             	shl    $0x2,%eax
  80425c:	05 6a 60 80 00       	add    $0x80606a,%eax
  804261:	66 8b 00             	mov    (%eax),%ax
  804264:	0f b7 c0             	movzwl %ax,%eax
  804267:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80426a:	0f 85 d3 01 00 00    	jne    804443 <free_block+0x35d>
		struct BlockElement *itr = LIST_FIRST(&freeBlockLists[list_index]);
  804270:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804273:	c1 e0 04             	shl    $0x4,%eax
  804276:	05 80 e0 81 00       	add    $0x81e080,%eax
  80427b:	8b 00                	mov    (%eax),%eax
  80427d:	89 45 f4             	mov    %eax,-0xc(%ebp)
		while(itr != NULL){
  804280:	e9 f1 00 00 00       	jmp    804376 <free_block+0x290>
			//lw ms7to el pointer mydy34 ->
			struct BlockElement *next = LIST_NEXT(itr);
  804285:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804288:	8b 00                	mov    (%eax),%eax
  80428a:	89 45 dc             	mov    %eax,-0x24(%ebp)
			uint32 page_beginning_address= dynAllocStart + page_index * PAGE_SIZE;
  80428d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804290:	c1 e0 0c             	shl    $0xc,%eax
  804293:	89 c2                	mov    %eax,%edx
  804295:	a1 64 e0 81 00       	mov    0x81e064,%eax
  80429a:	01 d0                	add    %edx,%eax
  80429c:	89 45 d8             	mov    %eax,-0x28(%ebp)
			uint32 page_end_address = dynAllocStart + (page_index +1 )* PAGE_SIZE;
  80429f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8042a2:	40                   	inc    %eax
  8042a3:	c1 e0 0c             	shl    $0xc,%eax
  8042a6:	89 c2                	mov    %eax,%edx
  8042a8:	a1 64 e0 81 00       	mov    0x81e064,%eax
  8042ad:	01 d0                	add    %edx,%eax
  8042af:	89 45 d4             	mov    %eax,-0x2c(%ebp)

			if((uint32)itr >= page_beginning_address && (uint32)itr < page_end_address){
  8042b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8042b5:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  8042b8:	0f 82 b8 00 00 00    	jb     804376 <free_block+0x290>
  8042be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8042c1:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8042c4:	0f 83 ac 00 00 00    	jae    804376 <free_block+0x290>
				LIST_REMOVE(&freeBlockLists[list_index], itr);
  8042ca:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8042ce:	75 17                	jne    8042e7 <free_block+0x201>
  8042d0:	83 ec 04             	sub    $0x4,%esp
  8042d3:	68 2d 52 80 00       	push   $0x80522d
  8042d8:	68 e2 00 00 00       	push   $0xe2
  8042dd:	68 f3 51 80 00       	push   $0x8051f3
  8042e2:	e8 50 c6 ff ff       	call   800937 <_panic>
  8042e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8042ea:	8b 00                	mov    (%eax),%eax
  8042ec:	85 c0                	test   %eax,%eax
  8042ee:	74 10                	je     804300 <free_block+0x21a>
  8042f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8042f3:	8b 00                	mov    (%eax),%eax
  8042f5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8042f8:	8b 52 04             	mov    0x4(%edx),%edx
  8042fb:	89 50 04             	mov    %edx,0x4(%eax)
  8042fe:	eb 14                	jmp    804314 <free_block+0x22e>
  804300:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804303:	8b 40 04             	mov    0x4(%eax),%eax
  804306:	8b 55 e8             	mov    -0x18(%ebp),%edx
  804309:	c1 e2 04             	shl    $0x4,%edx
  80430c:	81 c2 84 e0 81 00    	add    $0x81e084,%edx
  804312:	89 02                	mov    %eax,(%edx)
  804314:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804317:	8b 40 04             	mov    0x4(%eax),%eax
  80431a:	85 c0                	test   %eax,%eax
  80431c:	74 0f                	je     80432d <free_block+0x247>
  80431e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804321:	8b 40 04             	mov    0x4(%eax),%eax
  804324:	8b 55 f4             	mov    -0xc(%ebp),%edx
  804327:	8b 12                	mov    (%edx),%edx
  804329:	89 10                	mov    %edx,(%eax)
  80432b:	eb 13                	jmp    804340 <free_block+0x25a>
  80432d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804330:	8b 00                	mov    (%eax),%eax
  804332:	8b 55 e8             	mov    -0x18(%ebp),%edx
  804335:	c1 e2 04             	shl    $0x4,%edx
  804338:	81 c2 80 e0 81 00    	add    $0x81e080,%edx
  80433e:	89 02                	mov    %eax,(%edx)
  804340:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804343:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  804349:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80434c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  804353:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804356:	c1 e0 04             	shl    $0x4,%eax
  804359:	05 8c e0 81 00       	add    $0x81e08c,%eax
  80435e:	8b 00                	mov    (%eax),%eax
  804360:	8d 50 ff             	lea    -0x1(%eax),%edx
  804363:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804366:	c1 e0 04             	shl    $0x4,%eax
  804369:	05 8c e0 81 00       	add    $0x81e08c,%eax
  80436e:	89 10                	mov    %edx,(%eax)
				//y5o4 3la elly b3do
				itr = next;
  804370:	8b 45 dc             	mov    -0x24(%ebp),%eax
  804373:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// b3d ma wdytha fy el freeBlockLists hzwed elfree elly fy el array 1
	pageBlockInfoArr[page_index].num_of_free_blocks++;
	int blocks_number = PAGE_SIZE / block_size;
	if(pageBlockInfoArr[page_index].num_of_free_blocks == blocks_number){
		struct BlockElement *itr = LIST_FIRST(&freeBlockLists[list_index]);
		while(itr != NULL){
  804376:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80437a:	0f 85 05 ff ff ff    	jne    804285 <free_block+0x19f>
				LIST_REMOVE(&freeBlockLists[list_index], itr);
				//y5o4 3la elly b3do
				itr = next;
			}
		}
		pageBlockInfoArr[page_index].block_size=0;
  804380:	8b 55 f0             	mov    -0x10(%ebp),%edx
  804383:	89 d0                	mov    %edx,%eax
  804385:	01 c0                	add    %eax,%eax
  804387:	01 d0                	add    %edx,%eax
  804389:	c1 e0 02             	shl    $0x2,%eax
  80438c:	05 68 60 80 00       	add    $0x806068,%eax
  804391:	66 c7 00 00 00       	movw   $0x0,(%eax)
		pageBlockInfoArr[page_index].num_of_free_blocks=0;
  804396:	8b 55 f0             	mov    -0x10(%ebp),%edx
  804399:	89 d0                	mov    %edx,%eax
  80439b:	01 c0                	add    %eax,%eax
  80439d:	01 d0                	add    %edx,%eax
  80439f:	c1 e0 02             	shl    $0x2,%eax
  8043a2:	05 6a 60 80 00       	add    $0x80606a,%eax
  8043a7:	66 c7 00 00 00       	movw   $0x0,(%eax)

		struct PageInfoElement *page_info = &pageBlockInfoArr[page_index];
  8043ac:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8043af:	89 d0                	mov    %edx,%eax
  8043b1:	01 c0                	add    %eax,%eax
  8043b3:	01 d0                	add    %edx,%eax
  8043b5:	c1 e0 02             	shl    $0x2,%eax
  8043b8:	05 60 60 80 00       	add    $0x806060,%eax
  8043bd:	89 45 d0             	mov    %eax,-0x30(%ebp)
		LIST_INSERT_TAIL(&freePagesList, page_info);
  8043c0:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  8043c4:	75 17                	jne    8043dd <free_block+0x2f7>
  8043c6:	83 ec 04             	sub    $0x4,%esp
  8043c9:	68 4c 52 80 00       	push   $0x80524c
  8043ce:	68 eb 00 00 00       	push   $0xeb
  8043d3:	68 f3 51 80 00       	push   $0x8051f3
  8043d8:	e8 5a c5 ff ff       	call   800937 <_panic>
  8043dd:	8b 15 4c 60 80 00    	mov    0x80604c,%edx
  8043e3:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8043e6:	89 50 04             	mov    %edx,0x4(%eax)
  8043e9:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8043ec:	8b 40 04             	mov    0x4(%eax),%eax
  8043ef:	85 c0                	test   %eax,%eax
  8043f1:	74 0c                	je     8043ff <free_block+0x319>
  8043f3:	a1 4c 60 80 00       	mov    0x80604c,%eax
  8043f8:	8b 55 d0             	mov    -0x30(%ebp),%edx
  8043fb:	89 10                	mov    %edx,(%eax)
  8043fd:	eb 08                	jmp    804407 <free_block+0x321>
  8043ff:	8b 45 d0             	mov    -0x30(%ebp),%eax
  804402:	a3 48 60 80 00       	mov    %eax,0x806048
  804407:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80440a:	a3 4c 60 80 00       	mov    %eax,0x80604c
  80440f:	8b 45 d0             	mov    -0x30(%ebp),%eax
  804412:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  804418:	a1 54 60 80 00       	mov    0x806054,%eax
  80441d:	40                   	inc    %eax
  80441e:	a3 54 60 80 00       	mov    %eax,0x806054
		uint32 page_va = to_page_va(page_info);
  804423:	83 ec 0c             	sub    $0xc,%esp
  804426:	ff 75 d0             	pushl  -0x30(%ebp)
  804429:	e8 ce f5 ff ff       	call   8039fc <to_page_va>
  80442e:	83 c4 10             	add    $0x10,%esp
  804431:	89 45 cc             	mov    %eax,-0x34(%ebp)
		return_page((void *)page_va);
  804434:	8b 45 cc             	mov    -0x34(%ebp),%eax
  804437:	83 ec 0c             	sub    $0xc,%esp
  80443a:	50                   	push   %eax
  80443b:	e8 9e d7 ff ff       	call   801bde <return_page>
  804440:	83 c4 10             	add    $0x10,%esp
	}


	//Comment the following line
	//panic("free_block() Not implemented yet");
}
  804443:	90                   	nop
  804444:	c9                   	leave  
  804445:	c3                   	ret    

00804446 <realloc_block>:

//===========================
// [1] REALLOCATE BLOCK:
//===========================
void *realloc_block(void* va, uint32 new_size)
{
  804446:	55                   	push   %ebp
  804447:	89 e5                	mov    %esp,%ebp
  804449:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.BONUS#2] KERNEL REALLOC - realloc_block
	//Your code is here
	//Comment the following line
	panic("realloc_block() Not implemented yet");
  80444c:	83 ec 04             	sub    $0x4,%esp
  80444f:	68 ec 52 80 00       	push   $0x8052ec
  804454:	68 01 01 00 00       	push   $0x101
  804459:	68 f3 51 80 00       	push   $0x8051f3
  80445e:	e8 d4 c4 ff ff       	call   800937 <_panic>

00804463 <init_uspinlock>:
#include "inc/uspinlock.h"

extern volatile struct Env *myEnv;

void init_uspinlock(struct uspinlock *lk, char *name, bool isOpened)
{
  804463:	55                   	push   %ebp
  804464:	89 e5                	mov    %esp,%ebp
  804466:	83 ec 08             	sub    $0x8,%esp
	assert(isOpened == 0 || isOpened == 1);
  804469:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80446d:	74 1c                	je     80448b <init_uspinlock+0x28>
  80446f:	83 7d 10 01          	cmpl   $0x1,0x10(%ebp)
  804473:	74 16                	je     80448b <init_uspinlock+0x28>
  804475:	68 10 53 80 00       	push   $0x805310
  80447a:	68 2f 53 80 00       	push   $0x80532f
  80447f:	6a 10                	push   $0x10
  804481:	68 44 53 80 00       	push   $0x805344
  804486:	e8 ac c4 ff ff       	call   800937 <_panic>
	strcpy(lk->name, name);
  80448b:	8b 45 08             	mov    0x8(%ebp),%eax
  80448e:	83 c0 04             	add    $0x4,%eax
  804491:	83 ec 08             	sub    $0x8,%esp
  804494:	ff 75 0c             	pushl  0xc(%ebp)
  804497:	50                   	push   %eax
  804498:	e8 90 ce ff ff       	call   80132d <strcpy>
  80449d:	83 c4 10             	add    $0x10,%esp
	lk->locked = (1 - isOpened);
  8044a0:	b8 01 00 00 00       	mov    $0x1,%eax
  8044a5:	2b 45 10             	sub    0x10(%ebp),%eax
  8044a8:	89 c2                	mov    %eax,%edx
  8044aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8044ad:	89 10                	mov    %edx,(%eax)
}
  8044af:	90                   	nop
  8044b0:	c9                   	leave  
  8044b1:	c3                   	ret    

008044b2 <acquire_uspinlock>:
// Acquire the lock.
// Loops (spins) until the lock is acquired.
// Holding a lock for a long time may cause
// other CPUs to waste time spinning to acquire it.
void acquire_uspinlock(struct uspinlock *lk)
{
  8044b2:	55                   	push   %ebp
  8044b3:	89 e5                	mov    %esp,%ebp
  8044b5:	83 ec 18             	sub    $0x18,%esp
	// The xchg is atomic.
	while(xchg(&lk->locked, 1) != 0) ;
  8044b8:	90                   	nop
  8044b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8044bc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8044bf:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
xchg(volatile uint32 *addr, uint32 newval)
{
  uint32 result;

  // The + in "+m" denotes a read-modify-write operand.
  __asm __volatile("lock; xchgl %0, %1" :
  8044c6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8044c9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8044cc:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  8044cf:	f0 87 02             	lock xchg %eax,(%edx)
  8044d2:	89 45 ec             	mov    %eax,-0x14(%ebp)
               "+m" (*addr), "=a" (result) :
               "1" (newval) :
               "cc");
  return result;
  8044d5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8044d8:	85 c0                	test   %eax,%eax
  8044da:	75 dd                	jne    8044b9 <acquire_uspinlock+0x7>

	cprintf("[%d: %s] ACQUIRED spinlock [%s]\n", myEnv->env_id, myEnv->prog_name, lk->name);
  8044dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8044df:	8d 48 04             	lea    0x4(%eax),%ecx
  8044e2:	a1 24 60 80 00       	mov    0x806024,%eax
  8044e7:	8d 50 20             	lea    0x20(%eax),%edx
  8044ea:	a1 24 60 80 00       	mov    0x806024,%eax
  8044ef:	8b 40 10             	mov    0x10(%eax),%eax
  8044f2:	51                   	push   %ecx
  8044f3:	52                   	push   %edx
  8044f4:	50                   	push   %eax
  8044f5:	68 54 53 80 00       	push   $0x805354
  8044fa:	e8 06 c7 ff ff       	call   800c05 <cprintf>
  8044ff:	83 c4 10             	add    $0x10,%esp

	// Tell the C compiler and the processor to not move loads or stores
	// past this point, to ensure that the critical section's memory
	// references happen after the lock is acquired.
	__sync_synchronize();
  804502:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
}
  804507:	90                   	nop
  804508:	c9                   	leave  
  804509:	c3                   	ret    

0080450a <release_uspinlock>:

// Release the lock.
void release_uspinlock(struct uspinlock *lk)
{
  80450a:	55                   	push   %ebp
  80450b:	89 e5                	mov    %esp,%ebp
  80450d:	83 ec 08             	sub    $0x8,%esp
	if(!(lk->locked))
  804510:	8b 45 08             	mov    0x8(%ebp),%eax
  804513:	8b 00                	mov    (%eax),%eax
  804515:	85 c0                	test   %eax,%eax
  804517:	75 18                	jne    804531 <release_uspinlock+0x27>
	{
		panic("release: lock \"%s\" is not held!", lk->name);
  804519:	8b 45 08             	mov    0x8(%ebp),%eax
  80451c:	83 c0 04             	add    $0x4,%eax
  80451f:	50                   	push   %eax
  804520:	68 78 53 80 00       	push   $0x805378
  804525:	6a 2b                	push   $0x2b
  804527:	68 44 53 80 00       	push   $0x805344
  80452c:	e8 06 c4 ff ff       	call   800937 <_panic>
	// Tell the C compiler and the processor to not move loads or stores
	// past this point, to ensure that all the stores in the critical
	// section are visible to other cores before the lock is released.
	// Both the C compiler and the hardware may re-order loads and
	// stores; __sync_synchronize() tells them both not to.
	__sync_synchronize();
  804531:	f0 83 0c 24 00       	lock orl $0x0,(%esp)

	// Release the lock, equivalent to lk->locked = 0.
	// This code can't use a C assignment, since it might
	// not be atomic. A real OS would use C atomics here.
	asm volatile("movl $0, %0" : "+m" (lk->locked) : );
  804536:	8b 45 08             	mov    0x8(%ebp),%eax
  804539:	8b 55 08             	mov    0x8(%ebp),%edx
  80453c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	cprintf("[%d: %s] RELEASED spinlock [%s]\n", myEnv->env_id, myEnv->prog_name, lk->name);
  804542:	8b 45 08             	mov    0x8(%ebp),%eax
  804545:	8d 48 04             	lea    0x4(%eax),%ecx
  804548:	a1 24 60 80 00       	mov    0x806024,%eax
  80454d:	8d 50 20             	lea    0x20(%eax),%edx
  804550:	a1 24 60 80 00       	mov    0x806024,%eax
  804555:	8b 40 10             	mov    0x10(%eax),%eax
  804558:	51                   	push   %ecx
  804559:	52                   	push   %edx
  80455a:	50                   	push   %eax
  80455b:	68 98 53 80 00       	push   $0x805398
  804560:	e8 a0 c6 ff ff       	call   800c05 <cprintf>
  804565:	83 c4 10             	add    $0x10,%esp
}
  804568:	90                   	nop
  804569:	c9                   	leave  
  80456a:	c3                   	ret    
  80456b:	90                   	nop

0080456c <__udivdi3>:
  80456c:	55                   	push   %ebp
  80456d:	57                   	push   %edi
  80456e:	56                   	push   %esi
  80456f:	53                   	push   %ebx
  804570:	83 ec 1c             	sub    $0x1c,%esp
  804573:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  804577:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80457b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80457f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  804583:	89 ca                	mov    %ecx,%edx
  804585:	89 f8                	mov    %edi,%eax
  804587:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80458b:	85 f6                	test   %esi,%esi
  80458d:	75 2d                	jne    8045bc <__udivdi3+0x50>
  80458f:	39 cf                	cmp    %ecx,%edi
  804591:	77 65                	ja     8045f8 <__udivdi3+0x8c>
  804593:	89 fd                	mov    %edi,%ebp
  804595:	85 ff                	test   %edi,%edi
  804597:	75 0b                	jne    8045a4 <__udivdi3+0x38>
  804599:	b8 01 00 00 00       	mov    $0x1,%eax
  80459e:	31 d2                	xor    %edx,%edx
  8045a0:	f7 f7                	div    %edi
  8045a2:	89 c5                	mov    %eax,%ebp
  8045a4:	31 d2                	xor    %edx,%edx
  8045a6:	89 c8                	mov    %ecx,%eax
  8045a8:	f7 f5                	div    %ebp
  8045aa:	89 c1                	mov    %eax,%ecx
  8045ac:	89 d8                	mov    %ebx,%eax
  8045ae:	f7 f5                	div    %ebp
  8045b0:	89 cf                	mov    %ecx,%edi
  8045b2:	89 fa                	mov    %edi,%edx
  8045b4:	83 c4 1c             	add    $0x1c,%esp
  8045b7:	5b                   	pop    %ebx
  8045b8:	5e                   	pop    %esi
  8045b9:	5f                   	pop    %edi
  8045ba:	5d                   	pop    %ebp
  8045bb:	c3                   	ret    
  8045bc:	39 ce                	cmp    %ecx,%esi
  8045be:	77 28                	ja     8045e8 <__udivdi3+0x7c>
  8045c0:	0f bd fe             	bsr    %esi,%edi
  8045c3:	83 f7 1f             	xor    $0x1f,%edi
  8045c6:	75 40                	jne    804608 <__udivdi3+0x9c>
  8045c8:	39 ce                	cmp    %ecx,%esi
  8045ca:	72 0a                	jb     8045d6 <__udivdi3+0x6a>
  8045cc:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8045d0:	0f 87 9e 00 00 00    	ja     804674 <__udivdi3+0x108>
  8045d6:	b8 01 00 00 00       	mov    $0x1,%eax
  8045db:	89 fa                	mov    %edi,%edx
  8045dd:	83 c4 1c             	add    $0x1c,%esp
  8045e0:	5b                   	pop    %ebx
  8045e1:	5e                   	pop    %esi
  8045e2:	5f                   	pop    %edi
  8045e3:	5d                   	pop    %ebp
  8045e4:	c3                   	ret    
  8045e5:	8d 76 00             	lea    0x0(%esi),%esi
  8045e8:	31 ff                	xor    %edi,%edi
  8045ea:	31 c0                	xor    %eax,%eax
  8045ec:	89 fa                	mov    %edi,%edx
  8045ee:	83 c4 1c             	add    $0x1c,%esp
  8045f1:	5b                   	pop    %ebx
  8045f2:	5e                   	pop    %esi
  8045f3:	5f                   	pop    %edi
  8045f4:	5d                   	pop    %ebp
  8045f5:	c3                   	ret    
  8045f6:	66 90                	xchg   %ax,%ax
  8045f8:	89 d8                	mov    %ebx,%eax
  8045fa:	f7 f7                	div    %edi
  8045fc:	31 ff                	xor    %edi,%edi
  8045fe:	89 fa                	mov    %edi,%edx
  804600:	83 c4 1c             	add    $0x1c,%esp
  804603:	5b                   	pop    %ebx
  804604:	5e                   	pop    %esi
  804605:	5f                   	pop    %edi
  804606:	5d                   	pop    %ebp
  804607:	c3                   	ret    
  804608:	bd 20 00 00 00       	mov    $0x20,%ebp
  80460d:	89 eb                	mov    %ebp,%ebx
  80460f:	29 fb                	sub    %edi,%ebx
  804611:	89 f9                	mov    %edi,%ecx
  804613:	d3 e6                	shl    %cl,%esi
  804615:	89 c5                	mov    %eax,%ebp
  804617:	88 d9                	mov    %bl,%cl
  804619:	d3 ed                	shr    %cl,%ebp
  80461b:	89 e9                	mov    %ebp,%ecx
  80461d:	09 f1                	or     %esi,%ecx
  80461f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  804623:	89 f9                	mov    %edi,%ecx
  804625:	d3 e0                	shl    %cl,%eax
  804627:	89 c5                	mov    %eax,%ebp
  804629:	89 d6                	mov    %edx,%esi
  80462b:	88 d9                	mov    %bl,%cl
  80462d:	d3 ee                	shr    %cl,%esi
  80462f:	89 f9                	mov    %edi,%ecx
  804631:	d3 e2                	shl    %cl,%edx
  804633:	8b 44 24 08          	mov    0x8(%esp),%eax
  804637:	88 d9                	mov    %bl,%cl
  804639:	d3 e8                	shr    %cl,%eax
  80463b:	09 c2                	or     %eax,%edx
  80463d:	89 d0                	mov    %edx,%eax
  80463f:	89 f2                	mov    %esi,%edx
  804641:	f7 74 24 0c          	divl   0xc(%esp)
  804645:	89 d6                	mov    %edx,%esi
  804647:	89 c3                	mov    %eax,%ebx
  804649:	f7 e5                	mul    %ebp
  80464b:	39 d6                	cmp    %edx,%esi
  80464d:	72 19                	jb     804668 <__udivdi3+0xfc>
  80464f:	74 0b                	je     80465c <__udivdi3+0xf0>
  804651:	89 d8                	mov    %ebx,%eax
  804653:	31 ff                	xor    %edi,%edi
  804655:	e9 58 ff ff ff       	jmp    8045b2 <__udivdi3+0x46>
  80465a:	66 90                	xchg   %ax,%ax
  80465c:	8b 54 24 08          	mov    0x8(%esp),%edx
  804660:	89 f9                	mov    %edi,%ecx
  804662:	d3 e2                	shl    %cl,%edx
  804664:	39 c2                	cmp    %eax,%edx
  804666:	73 e9                	jae    804651 <__udivdi3+0xe5>
  804668:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80466b:	31 ff                	xor    %edi,%edi
  80466d:	e9 40 ff ff ff       	jmp    8045b2 <__udivdi3+0x46>
  804672:	66 90                	xchg   %ax,%ax
  804674:	31 c0                	xor    %eax,%eax
  804676:	e9 37 ff ff ff       	jmp    8045b2 <__udivdi3+0x46>
  80467b:	90                   	nop

0080467c <__umoddi3>:
  80467c:	55                   	push   %ebp
  80467d:	57                   	push   %edi
  80467e:	56                   	push   %esi
  80467f:	53                   	push   %ebx
  804680:	83 ec 1c             	sub    $0x1c,%esp
  804683:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  804687:	8b 74 24 34          	mov    0x34(%esp),%esi
  80468b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80468f:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  804693:	89 44 24 0c          	mov    %eax,0xc(%esp)
  804697:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80469b:	89 f3                	mov    %esi,%ebx
  80469d:	89 fa                	mov    %edi,%edx
  80469f:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8046a3:	89 34 24             	mov    %esi,(%esp)
  8046a6:	85 c0                	test   %eax,%eax
  8046a8:	75 1a                	jne    8046c4 <__umoddi3+0x48>
  8046aa:	39 f7                	cmp    %esi,%edi
  8046ac:	0f 86 a2 00 00 00    	jbe    804754 <__umoddi3+0xd8>
  8046b2:	89 c8                	mov    %ecx,%eax
  8046b4:	89 f2                	mov    %esi,%edx
  8046b6:	f7 f7                	div    %edi
  8046b8:	89 d0                	mov    %edx,%eax
  8046ba:	31 d2                	xor    %edx,%edx
  8046bc:	83 c4 1c             	add    $0x1c,%esp
  8046bf:	5b                   	pop    %ebx
  8046c0:	5e                   	pop    %esi
  8046c1:	5f                   	pop    %edi
  8046c2:	5d                   	pop    %ebp
  8046c3:	c3                   	ret    
  8046c4:	39 f0                	cmp    %esi,%eax
  8046c6:	0f 87 ac 00 00 00    	ja     804778 <__umoddi3+0xfc>
  8046cc:	0f bd e8             	bsr    %eax,%ebp
  8046cf:	83 f5 1f             	xor    $0x1f,%ebp
  8046d2:	0f 84 ac 00 00 00    	je     804784 <__umoddi3+0x108>
  8046d8:	bf 20 00 00 00       	mov    $0x20,%edi
  8046dd:	29 ef                	sub    %ebp,%edi
  8046df:	89 fe                	mov    %edi,%esi
  8046e1:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8046e5:	89 e9                	mov    %ebp,%ecx
  8046e7:	d3 e0                	shl    %cl,%eax
  8046e9:	89 d7                	mov    %edx,%edi
  8046eb:	89 f1                	mov    %esi,%ecx
  8046ed:	d3 ef                	shr    %cl,%edi
  8046ef:	09 c7                	or     %eax,%edi
  8046f1:	89 e9                	mov    %ebp,%ecx
  8046f3:	d3 e2                	shl    %cl,%edx
  8046f5:	89 14 24             	mov    %edx,(%esp)
  8046f8:	89 d8                	mov    %ebx,%eax
  8046fa:	d3 e0                	shl    %cl,%eax
  8046fc:	89 c2                	mov    %eax,%edx
  8046fe:	8b 44 24 08          	mov    0x8(%esp),%eax
  804702:	d3 e0                	shl    %cl,%eax
  804704:	89 44 24 04          	mov    %eax,0x4(%esp)
  804708:	8b 44 24 08          	mov    0x8(%esp),%eax
  80470c:	89 f1                	mov    %esi,%ecx
  80470e:	d3 e8                	shr    %cl,%eax
  804710:	09 d0                	or     %edx,%eax
  804712:	d3 eb                	shr    %cl,%ebx
  804714:	89 da                	mov    %ebx,%edx
  804716:	f7 f7                	div    %edi
  804718:	89 d3                	mov    %edx,%ebx
  80471a:	f7 24 24             	mull   (%esp)
  80471d:	89 c6                	mov    %eax,%esi
  80471f:	89 d1                	mov    %edx,%ecx
  804721:	39 d3                	cmp    %edx,%ebx
  804723:	0f 82 87 00 00 00    	jb     8047b0 <__umoddi3+0x134>
  804729:	0f 84 91 00 00 00    	je     8047c0 <__umoddi3+0x144>
  80472f:	8b 54 24 04          	mov    0x4(%esp),%edx
  804733:	29 f2                	sub    %esi,%edx
  804735:	19 cb                	sbb    %ecx,%ebx
  804737:	89 d8                	mov    %ebx,%eax
  804739:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  80473d:	d3 e0                	shl    %cl,%eax
  80473f:	89 e9                	mov    %ebp,%ecx
  804741:	d3 ea                	shr    %cl,%edx
  804743:	09 d0                	or     %edx,%eax
  804745:	89 e9                	mov    %ebp,%ecx
  804747:	d3 eb                	shr    %cl,%ebx
  804749:	89 da                	mov    %ebx,%edx
  80474b:	83 c4 1c             	add    $0x1c,%esp
  80474e:	5b                   	pop    %ebx
  80474f:	5e                   	pop    %esi
  804750:	5f                   	pop    %edi
  804751:	5d                   	pop    %ebp
  804752:	c3                   	ret    
  804753:	90                   	nop
  804754:	89 fd                	mov    %edi,%ebp
  804756:	85 ff                	test   %edi,%edi
  804758:	75 0b                	jne    804765 <__umoddi3+0xe9>
  80475a:	b8 01 00 00 00       	mov    $0x1,%eax
  80475f:	31 d2                	xor    %edx,%edx
  804761:	f7 f7                	div    %edi
  804763:	89 c5                	mov    %eax,%ebp
  804765:	89 f0                	mov    %esi,%eax
  804767:	31 d2                	xor    %edx,%edx
  804769:	f7 f5                	div    %ebp
  80476b:	89 c8                	mov    %ecx,%eax
  80476d:	f7 f5                	div    %ebp
  80476f:	89 d0                	mov    %edx,%eax
  804771:	e9 44 ff ff ff       	jmp    8046ba <__umoddi3+0x3e>
  804776:	66 90                	xchg   %ax,%ax
  804778:	89 c8                	mov    %ecx,%eax
  80477a:	89 f2                	mov    %esi,%edx
  80477c:	83 c4 1c             	add    $0x1c,%esp
  80477f:	5b                   	pop    %ebx
  804780:	5e                   	pop    %esi
  804781:	5f                   	pop    %edi
  804782:	5d                   	pop    %ebp
  804783:	c3                   	ret    
  804784:	3b 04 24             	cmp    (%esp),%eax
  804787:	72 06                	jb     80478f <__umoddi3+0x113>
  804789:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  80478d:	77 0f                	ja     80479e <__umoddi3+0x122>
  80478f:	89 f2                	mov    %esi,%edx
  804791:	29 f9                	sub    %edi,%ecx
  804793:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  804797:	89 14 24             	mov    %edx,(%esp)
  80479a:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80479e:	8b 44 24 04          	mov    0x4(%esp),%eax
  8047a2:	8b 14 24             	mov    (%esp),%edx
  8047a5:	83 c4 1c             	add    $0x1c,%esp
  8047a8:	5b                   	pop    %ebx
  8047a9:	5e                   	pop    %esi
  8047aa:	5f                   	pop    %edi
  8047ab:	5d                   	pop    %ebp
  8047ac:	c3                   	ret    
  8047ad:	8d 76 00             	lea    0x0(%esi),%esi
  8047b0:	2b 04 24             	sub    (%esp),%eax
  8047b3:	19 fa                	sbb    %edi,%edx
  8047b5:	89 d1                	mov    %edx,%ecx
  8047b7:	89 c6                	mov    %eax,%esi
  8047b9:	e9 71 ff ff ff       	jmp    80472f <__umoddi3+0xb3>
  8047be:	66 90                	xchg   %ax,%ax
  8047c0:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8047c4:	72 ea                	jb     8047b0 <__umoddi3+0x134>
  8047c6:	89 d9                	mov    %ebx,%ecx
  8047c8:	e9 62 ff ff ff       	jmp    80472f <__umoddi3+0xb3>
