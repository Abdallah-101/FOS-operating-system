
obj/user/mergesort_leakage:     file format elf32-i386


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
  800031:	e8 01 07 00 00       	call   800737 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
void Merge(int* A, int p, int q, int r);

uint32 CheckSorted(int *Elements, int NumOfElements);

void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	81 ec 18 01 00 00    	sub    $0x118,%esp
	{
		//2012: lock the interrupt
//		sys_lock_cons();
		int NumOfElements;
		int *Elements;
		sys_lock_cons();
  800041:	e8 3b 36 00 00       	call   803681 <sys_lock_cons>
		{
			cprintf("\n");
  800046:	83 ec 0c             	sub    $0xc,%esp
  800049:	68 a0 49 80 00       	push   $0x8049a0
  80004e:	e8 6b 0b 00 00       	call   800bbe <cprintf>
  800053:	83 c4 10             	add    $0x10,%esp
			cprintf("!!!!!!!!!!!!!!!!!!!!\n");
  800056:	83 ec 0c             	sub    $0xc,%esp
  800059:	68 a2 49 80 00       	push   $0x8049a2
  80005e:	e8 5b 0b 00 00       	call   800bbe <cprintf>
  800063:	83 c4 10             	add    $0x10,%esp
			cprintf("!!!! MERGE SORT !!!!\n");
  800066:	83 ec 0c             	sub    $0xc,%esp
  800069:	68 b8 49 80 00       	push   $0x8049b8
  80006e:	e8 4b 0b 00 00       	call   800bbe <cprintf>
  800073:	83 c4 10             	add    $0x10,%esp
			cprintf("!!!!!!!!!!!!!!!!!!!!\n");
  800076:	83 ec 0c             	sub    $0xc,%esp
  800079:	68 a2 49 80 00       	push   $0x8049a2
  80007e:	e8 3b 0b 00 00       	call   800bbe <cprintf>
  800083:	83 c4 10             	add    $0x10,%esp
			cprintf("\n");
  800086:	83 ec 0c             	sub    $0xc,%esp
  800089:	68 a0 49 80 00       	push   $0x8049a0
  80008e:	e8 2b 0b 00 00       	call   800bbe <cprintf>
  800093:	83 c4 10             	add    $0x10,%esp
			readline("Enter the number of elements: ", Line);
  800096:	83 ec 08             	sub    $0x8,%esp
  800099:	8d 85 e9 fe ff ff    	lea    -0x117(%ebp),%eax
  80009f:	50                   	push   %eax
  8000a0:	68 d0 49 80 00       	push   $0x8049d0
  8000a5:	e8 ed 11 00 00       	call   801297 <readline>
  8000aa:	83 c4 10             	add    $0x10,%esp
			NumOfElements = strtol(Line, NULL, 10) ;
  8000ad:	83 ec 04             	sub    $0x4,%esp
  8000b0:	6a 0a                	push   $0xa
  8000b2:	6a 00                	push   $0x0
  8000b4:	8d 85 e9 fe ff ff    	lea    -0x117(%ebp),%eax
  8000ba:	50                   	push   %eax
  8000bb:	e8 ee 17 00 00       	call   8018ae <strtol>
  8000c0:	83 c4 10             	add    $0x10,%esp
  8000c3:	89 45 f0             	mov    %eax,-0x10(%ebp)
			Elements = malloc(sizeof(int) * NumOfElements) ;
  8000c6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8000c9:	c1 e0 02             	shl    $0x2,%eax
  8000cc:	83 ec 0c             	sub    $0xc,%esp
  8000cf:	50                   	push   %eax
  8000d0:	e8 0a 1d 00 00       	call   801ddf <malloc>
  8000d5:	83 c4 10             	add    $0x10,%esp
  8000d8:	89 45 ec             	mov    %eax,-0x14(%ebp)
			cprintf("Chose the initialization method:\n") ;
  8000db:	83 ec 0c             	sub    $0xc,%esp
  8000de:	68 f0 49 80 00       	push   $0x8049f0
  8000e3:	e8 d6 0a 00 00       	call   800bbe <cprintf>
  8000e8:	83 c4 10             	add    $0x10,%esp
			cprintf("a) Ascending\n") ;
  8000eb:	83 ec 0c             	sub    $0xc,%esp
  8000ee:	68 12 4a 80 00       	push   $0x804a12
  8000f3:	e8 c6 0a 00 00       	call   800bbe <cprintf>
  8000f8:	83 c4 10             	add    $0x10,%esp
			cprintf("b) Descending\n") ;
  8000fb:	83 ec 0c             	sub    $0xc,%esp
  8000fe:	68 20 4a 80 00       	push   $0x804a20
  800103:	e8 b6 0a 00 00       	call   800bbe <cprintf>
  800108:	83 c4 10             	add    $0x10,%esp
			cprintf("c) Semi random\n");
  80010b:	83 ec 0c             	sub    $0xc,%esp
  80010e:	68 2f 4a 80 00       	push   $0x804a2f
  800113:	e8 a6 0a 00 00       	call   800bbe <cprintf>
  800118:	83 c4 10             	add    $0x10,%esp
			do
			{
				cprintf("Select: ") ;
  80011b:	83 ec 0c             	sub    $0xc,%esp
  80011e:	68 3f 4a 80 00       	push   $0x804a3f
  800123:	e8 96 0a 00 00       	call   800bbe <cprintf>
  800128:	83 c4 10             	add    $0x10,%esp
				Chose = getchar() ;
  80012b:	e8 ea 05 00 00       	call   80071a <getchar>
  800130:	88 45 f7             	mov    %al,-0x9(%ebp)
				cputchar(Chose);
  800133:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  800137:	83 ec 0c             	sub    $0xc,%esp
  80013a:	50                   	push   %eax
  80013b:	e8 bb 05 00 00       	call   8006fb <cputchar>
  800140:	83 c4 10             	add    $0x10,%esp
				cputchar('\n');
  800143:	83 ec 0c             	sub    $0xc,%esp
  800146:	6a 0a                	push   $0xa
  800148:	e8 ae 05 00 00       	call   8006fb <cputchar>
  80014d:	83 c4 10             	add    $0x10,%esp
			} while (Chose != 'a' && Chose != 'b' && Chose != 'c');
  800150:	80 7d f7 61          	cmpb   $0x61,-0x9(%ebp)
  800154:	74 0c                	je     800162 <_main+0x12a>
  800156:	80 7d f7 62          	cmpb   $0x62,-0x9(%ebp)
  80015a:	74 06                	je     800162 <_main+0x12a>
  80015c:	80 7d f7 63          	cmpb   $0x63,-0x9(%ebp)
  800160:	75 b9                	jne    80011b <_main+0xe3>
		}
		sys_unlock_cons();
  800162:	e8 34 35 00 00       	call   80369b <sys_unlock_cons>
//		sys_unlock_cons();

		int  i ;
		switch (Chose)
  800167:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  80016b:	83 f8 62             	cmp    $0x62,%eax
  80016e:	74 1d                	je     80018d <_main+0x155>
  800170:	83 f8 63             	cmp    $0x63,%eax
  800173:	74 2b                	je     8001a0 <_main+0x168>
  800175:	83 f8 61             	cmp    $0x61,%eax
  800178:	75 39                	jne    8001b3 <_main+0x17b>
		{
		case 'a':
			InitializeAscending(Elements, NumOfElements);
  80017a:	83 ec 08             	sub    $0x8,%esp
  80017d:	ff 75 f0             	pushl  -0x10(%ebp)
  800180:	ff 75 ec             	pushl  -0x14(%ebp)
  800183:	e8 e6 01 00 00       	call   80036e <InitializeAscending>
  800188:	83 c4 10             	add    $0x10,%esp
			break ;
  80018b:	eb 37                	jmp    8001c4 <_main+0x18c>
		case 'b':
			InitializeDescending(Elements, NumOfElements);
  80018d:	83 ec 08             	sub    $0x8,%esp
  800190:	ff 75 f0             	pushl  -0x10(%ebp)
  800193:	ff 75 ec             	pushl  -0x14(%ebp)
  800196:	e8 04 02 00 00       	call   80039f <InitializeDescending>
  80019b:	83 c4 10             	add    $0x10,%esp
			break ;
  80019e:	eb 24                	jmp    8001c4 <_main+0x18c>
		case 'c':
			InitializeSemiRandom(Elements, NumOfElements);
  8001a0:	83 ec 08             	sub    $0x8,%esp
  8001a3:	ff 75 f0             	pushl  -0x10(%ebp)
  8001a6:	ff 75 ec             	pushl  -0x14(%ebp)
  8001a9:	e8 26 02 00 00       	call   8003d4 <InitializeSemiRandom>
  8001ae:	83 c4 10             	add    $0x10,%esp
			break ;
  8001b1:	eb 11                	jmp    8001c4 <_main+0x18c>
		default:
			InitializeSemiRandom(Elements, NumOfElements);
  8001b3:	83 ec 08             	sub    $0x8,%esp
  8001b6:	ff 75 f0             	pushl  -0x10(%ebp)
  8001b9:	ff 75 ec             	pushl  -0x14(%ebp)
  8001bc:	e8 13 02 00 00       	call   8003d4 <InitializeSemiRandom>
  8001c1:	83 c4 10             	add    $0x10,%esp
		}

		MSort(Elements, 1, NumOfElements);
  8001c4:	83 ec 04             	sub    $0x4,%esp
  8001c7:	ff 75 f0             	pushl  -0x10(%ebp)
  8001ca:	6a 01                	push   $0x1
  8001cc:	ff 75 ec             	pushl  -0x14(%ebp)
  8001cf:	e8 d2 02 00 00       	call   8004a6 <MSort>
  8001d4:	83 c4 10             	add    $0x10,%esp

//		sys_lock_cons();
		sys_lock_cons();
  8001d7:	e8 a5 34 00 00       	call   803681 <sys_lock_cons>
		{
			cprintf("Sorting is Finished!!!!it'll be checked now....\n") ;
  8001dc:	83 ec 0c             	sub    $0xc,%esp
  8001df:	68 48 4a 80 00       	push   $0x804a48
  8001e4:	e8 d5 09 00 00       	call   800bbe <cprintf>
  8001e9:	83 c4 10             	add    $0x10,%esp
			//PrintElements(Elements, NumOfElements);
		}
		sys_unlock_cons();
  8001ec:	e8 aa 34 00 00       	call   80369b <sys_unlock_cons>
//		sys_unlock_cons();

		uint32 Sorted = CheckSorted(Elements, NumOfElements);
  8001f1:	83 ec 08             	sub    $0x8,%esp
  8001f4:	ff 75 f0             	pushl  -0x10(%ebp)
  8001f7:	ff 75 ec             	pushl  -0x14(%ebp)
  8001fa:	e8 c5 00 00 00       	call   8002c4 <CheckSorted>
  8001ff:	83 c4 10             	add    $0x10,%esp
  800202:	89 45 e8             	mov    %eax,-0x18(%ebp)

		if(Sorted == 0) panic("The array is NOT sorted correctly") ;
  800205:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  800209:	75 14                	jne    80021f <_main+0x1e7>
  80020b:	83 ec 04             	sub    $0x4,%esp
  80020e:	68 7c 4a 80 00       	push   $0x804a7c
  800213:	6a 51                	push   $0x51
  800215:	68 9e 4a 80 00       	push   $0x804a9e
  80021a:	e8 d1 06 00 00       	call   8008f0 <_panic>
		else
		{
//			sys_lock_cons();
			sys_lock_cons();
  80021f:	e8 5d 34 00 00       	call   803681 <sys_lock_cons>
			{
				cprintf("===============================================\n") ;
  800224:	83 ec 0c             	sub    $0xc,%esp
  800227:	68 b8 4a 80 00       	push   $0x804ab8
  80022c:	e8 8d 09 00 00       	call   800bbe <cprintf>
  800231:	83 c4 10             	add    $0x10,%esp
				cprintf("Congratulations!! The array is sorted correctly\n") ;
  800234:	83 ec 0c             	sub    $0xc,%esp
  800237:	68 ec 4a 80 00       	push   $0x804aec
  80023c:	e8 7d 09 00 00       	call   800bbe <cprintf>
  800241:	83 c4 10             	add    $0x10,%esp
				cprintf("===============================================\n\n") ;
  800244:	83 ec 0c             	sub    $0xc,%esp
  800247:	68 20 4b 80 00       	push   $0x804b20
  80024c:	e8 6d 09 00 00       	call   800bbe <cprintf>
  800251:	83 c4 10             	add    $0x10,%esp
			}
			sys_unlock_cons();
  800254:	e8 42 34 00 00       	call   80369b <sys_unlock_cons>
		}

		//free(Elements) ;

//		sys_lock_cons();
		sys_lock_cons();
  800259:	e8 23 34 00 00       	call   803681 <sys_lock_cons>
		{
			Chose = 0 ;
  80025e:	c6 45 f7 00          	movb   $0x0,-0x9(%ebp)
			while (Chose != 'y' && Chose != 'n')
  800262:	eb 42                	jmp    8002a6 <_main+0x26e>
			{
				cprintf("Do you want to repeat (y/n): ") ;
  800264:	83 ec 0c             	sub    $0xc,%esp
  800267:	68 52 4b 80 00       	push   $0x804b52
  80026c:	e8 4d 09 00 00       	call   800bbe <cprintf>
  800271:	83 c4 10             	add    $0x10,%esp
				Chose = getchar() ;
  800274:	e8 a1 04 00 00       	call   80071a <getchar>
  800279:	88 45 f7             	mov    %al,-0x9(%ebp)
				cputchar(Chose);
  80027c:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  800280:	83 ec 0c             	sub    $0xc,%esp
  800283:	50                   	push   %eax
  800284:	e8 72 04 00 00       	call   8006fb <cputchar>
  800289:	83 c4 10             	add    $0x10,%esp
				cputchar('\n');
  80028c:	83 ec 0c             	sub    $0xc,%esp
  80028f:	6a 0a                	push   $0xa
  800291:	e8 65 04 00 00       	call   8006fb <cputchar>
  800296:	83 c4 10             	add    $0x10,%esp
				cputchar('\n');
  800299:	83 ec 0c             	sub    $0xc,%esp
  80029c:	6a 0a                	push   $0xa
  80029e:	e8 58 04 00 00       	call   8006fb <cputchar>
  8002a3:	83 c4 10             	add    $0x10,%esp

//		sys_lock_cons();
		sys_lock_cons();
		{
			Chose = 0 ;
			while (Chose != 'y' && Chose != 'n')
  8002a6:	80 7d f7 79          	cmpb   $0x79,-0x9(%ebp)
  8002aa:	74 06                	je     8002b2 <_main+0x27a>
  8002ac:	80 7d f7 6e          	cmpb   $0x6e,-0x9(%ebp)
  8002b0:	75 b2                	jne    800264 <_main+0x22c>
				cputchar(Chose);
				cputchar('\n');
				cputchar('\n');
			}
		}
		sys_unlock_cons();
  8002b2:	e8 e4 33 00 00       	call   80369b <sys_unlock_cons>
//		sys_unlock_cons();

	} while (Chose == 'y');
  8002b7:	80 7d f7 79          	cmpb   $0x79,-0x9(%ebp)
  8002bb:	0f 84 80 fd ff ff    	je     800041 <_main+0x9>

}
  8002c1:	90                   	nop
  8002c2:	c9                   	leave  
  8002c3:	c3                   	ret    

008002c4 <CheckSorted>:


uint32 CheckSorted(int *Elements, int NumOfElements)
{
  8002c4:	55                   	push   %ebp
  8002c5:	89 e5                	mov    %esp,%ebp
  8002c7:	83 ec 10             	sub    $0x10,%esp
	uint32 Sorted = 1 ;
  8002ca:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
	int i ;
	for (i = 0 ; i < NumOfElements - 1; i++)
  8002d1:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8002d8:	eb 33                	jmp    80030d <CheckSorted+0x49>
	{
		if (Elements[i] > Elements[i+1])
  8002da:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8002dd:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8002e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8002e7:	01 d0                	add    %edx,%eax
  8002e9:	8b 10                	mov    (%eax),%edx
  8002eb:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8002ee:	40                   	inc    %eax
  8002ef:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8002f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8002f9:	01 c8                	add    %ecx,%eax
  8002fb:	8b 00                	mov    (%eax),%eax
  8002fd:	39 c2                	cmp    %eax,%edx
  8002ff:	7e 09                	jle    80030a <CheckSorted+0x46>
		{
			Sorted = 0 ;
  800301:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
			break;
  800308:	eb 0c                	jmp    800316 <CheckSorted+0x52>

uint32 CheckSorted(int *Elements, int NumOfElements)
{
	uint32 Sorted = 1 ;
	int i ;
	for (i = 0 ; i < NumOfElements - 1; i++)
  80030a:	ff 45 f8             	incl   -0x8(%ebp)
  80030d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800310:	48                   	dec    %eax
  800311:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800314:	7f c4                	jg     8002da <CheckSorted+0x16>
		{
			Sorted = 0 ;
			break;
		}
	}
	return Sorted ;
  800316:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800319:	c9                   	leave  
  80031a:	c3                   	ret    

0080031b <Swap>:

///Private Functions


void Swap(int *Elements, int First, int Second)
{
  80031b:	55                   	push   %ebp
  80031c:	89 e5                	mov    %esp,%ebp
  80031e:	83 ec 10             	sub    $0x10,%esp
	int Tmp = Elements[First] ;
  800321:	8b 45 0c             	mov    0xc(%ebp),%eax
  800324:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80032b:	8b 45 08             	mov    0x8(%ebp),%eax
  80032e:	01 d0                	add    %edx,%eax
  800330:	8b 00                	mov    (%eax),%eax
  800332:	89 45 fc             	mov    %eax,-0x4(%ebp)
	Elements[First] = Elements[Second] ;
  800335:	8b 45 0c             	mov    0xc(%ebp),%eax
  800338:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80033f:	8b 45 08             	mov    0x8(%ebp),%eax
  800342:	01 c2                	add    %eax,%edx
  800344:	8b 45 10             	mov    0x10(%ebp),%eax
  800347:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80034e:	8b 45 08             	mov    0x8(%ebp),%eax
  800351:	01 c8                	add    %ecx,%eax
  800353:	8b 00                	mov    (%eax),%eax
  800355:	89 02                	mov    %eax,(%edx)
	Elements[Second] = Tmp ;
  800357:	8b 45 10             	mov    0x10(%ebp),%eax
  80035a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800361:	8b 45 08             	mov    0x8(%ebp),%eax
  800364:	01 c2                	add    %eax,%edx
  800366:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800369:	89 02                	mov    %eax,(%edx)
}
  80036b:	90                   	nop
  80036c:	c9                   	leave  
  80036d:	c3                   	ret    

0080036e <InitializeAscending>:

void InitializeAscending(int *Elements, int NumOfElements)
{
  80036e:	55                   	push   %ebp
  80036f:	89 e5                	mov    %esp,%ebp
  800371:	83 ec 10             	sub    $0x10,%esp
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  800374:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80037b:	eb 17                	jmp    800394 <InitializeAscending+0x26>
	{
		(Elements)[i] = i ;
  80037d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800380:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800387:	8b 45 08             	mov    0x8(%ebp),%eax
  80038a:	01 c2                	add    %eax,%edx
  80038c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80038f:	89 02                	mov    %eax,(%edx)
}

void InitializeAscending(int *Elements, int NumOfElements)
{
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  800391:	ff 45 fc             	incl   -0x4(%ebp)
  800394:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800397:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80039a:	7c e1                	jl     80037d <InitializeAscending+0xf>
	{
		(Elements)[i] = i ;
	}

}
  80039c:	90                   	nop
  80039d:	c9                   	leave  
  80039e:	c3                   	ret    

0080039f <InitializeDescending>:

void InitializeDescending(int *Elements, int NumOfElements)
{
  80039f:	55                   	push   %ebp
  8003a0:	89 e5                	mov    %esp,%ebp
  8003a2:	83 ec 10             	sub    $0x10,%esp
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  8003a5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8003ac:	eb 1b                	jmp    8003c9 <InitializeDescending+0x2a>
	{
		Elements[i] = NumOfElements - i - 1 ;
  8003ae:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8003b1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8003bb:	01 c2                	add    %eax,%edx
  8003bd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003c0:	2b 45 fc             	sub    -0x4(%ebp),%eax
  8003c3:	48                   	dec    %eax
  8003c4:	89 02                	mov    %eax,(%edx)
}

void InitializeDescending(int *Elements, int NumOfElements)
{
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  8003c6:	ff 45 fc             	incl   -0x4(%ebp)
  8003c9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8003cc:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8003cf:	7c dd                	jl     8003ae <InitializeDescending+0xf>
	{
		Elements[i] = NumOfElements - i - 1 ;
	}

}
  8003d1:	90                   	nop
  8003d2:	c9                   	leave  
  8003d3:	c3                   	ret    

008003d4 <InitializeSemiRandom>:

void InitializeSemiRandom(int *Elements, int NumOfElements)
{
  8003d4:	55                   	push   %ebp
  8003d5:	89 e5                	mov    %esp,%ebp
  8003d7:	83 ec 10             	sub    $0x10,%esp
	int i ;
	int Repetition = NumOfElements / 3 ;
  8003da:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8003dd:	b8 56 55 55 55       	mov    $0x55555556,%eax
  8003e2:	f7 e9                	imul   %ecx
  8003e4:	c1 f9 1f             	sar    $0x1f,%ecx
  8003e7:	89 d0                	mov    %edx,%eax
  8003e9:	29 c8                	sub    %ecx,%eax
  8003eb:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0 ; i < NumOfElements ; i++)
  8003ee:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8003f5:	eb 1e                	jmp    800415 <InitializeSemiRandom+0x41>
	{
		Elements[i] = i % Repetition ;
  8003f7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8003fa:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800401:	8b 45 08             	mov    0x8(%ebp),%eax
  800404:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  800407:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80040a:	99                   	cltd   
  80040b:	f7 7d f8             	idivl  -0x8(%ebp)
  80040e:	89 d0                	mov    %edx,%eax
  800410:	89 01                	mov    %eax,(%ecx)

void InitializeSemiRandom(int *Elements, int NumOfElements)
{
	int i ;
	int Repetition = NumOfElements / 3 ;
	for (i = 0 ; i < NumOfElements ; i++)
  800412:	ff 45 fc             	incl   -0x4(%ebp)
  800415:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800418:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80041b:	7c da                	jl     8003f7 <InitializeSemiRandom+0x23>
	{
		Elements[i] = i % Repetition ;
		//	cprintf("i=%d\n",i);
	}

}
  80041d:	90                   	nop
  80041e:	c9                   	leave  
  80041f:	c3                   	ret    

00800420 <PrintElements>:

void PrintElements(int *Elements, int NumOfElements)
{
  800420:	55                   	push   %ebp
  800421:	89 e5                	mov    %esp,%ebp
  800423:	83 ec 18             	sub    $0x18,%esp
	int i ;
	int NumsPerLine = 20 ;
  800426:	c7 45 f0 14 00 00 00 	movl   $0x14,-0x10(%ebp)
	for (i = 0 ; i < NumOfElements-1 ; i++)
  80042d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800434:	eb 42                	jmp    800478 <PrintElements+0x58>
	{
		if (i%NumsPerLine == 0)
  800436:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800439:	99                   	cltd   
  80043a:	f7 7d f0             	idivl  -0x10(%ebp)
  80043d:	89 d0                	mov    %edx,%eax
  80043f:	85 c0                	test   %eax,%eax
  800441:	75 10                	jne    800453 <PrintElements+0x33>
			cprintf("\n");
  800443:	83 ec 0c             	sub    $0xc,%esp
  800446:	68 a0 49 80 00       	push   $0x8049a0
  80044b:	e8 6e 07 00 00       	call   800bbe <cprintf>
  800450:	83 c4 10             	add    $0x10,%esp
		cprintf("%d, ",Elements[i]);
  800453:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800456:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80045d:	8b 45 08             	mov    0x8(%ebp),%eax
  800460:	01 d0                	add    %edx,%eax
  800462:	8b 00                	mov    (%eax),%eax
  800464:	83 ec 08             	sub    $0x8,%esp
  800467:	50                   	push   %eax
  800468:	68 70 4b 80 00       	push   $0x804b70
  80046d:	e8 4c 07 00 00       	call   800bbe <cprintf>
  800472:	83 c4 10             	add    $0x10,%esp

void PrintElements(int *Elements, int NumOfElements)
{
	int i ;
	int NumsPerLine = 20 ;
	for (i = 0 ; i < NumOfElements-1 ; i++)
  800475:	ff 45 f4             	incl   -0xc(%ebp)
  800478:	8b 45 0c             	mov    0xc(%ebp),%eax
  80047b:	48                   	dec    %eax
  80047c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80047f:	7f b5                	jg     800436 <PrintElements+0x16>
	{
		if (i%NumsPerLine == 0)
			cprintf("\n");
		cprintf("%d, ",Elements[i]);
	}
	cprintf("%d\n",Elements[i]);
  800481:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800484:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80048b:	8b 45 08             	mov    0x8(%ebp),%eax
  80048e:	01 d0                	add    %edx,%eax
  800490:	8b 00                	mov    (%eax),%eax
  800492:	83 ec 08             	sub    $0x8,%esp
  800495:	50                   	push   %eax
  800496:	68 75 4b 80 00       	push   $0x804b75
  80049b:	e8 1e 07 00 00       	call   800bbe <cprintf>
  8004a0:	83 c4 10             	add    $0x10,%esp

}
  8004a3:	90                   	nop
  8004a4:	c9                   	leave  
  8004a5:	c3                   	ret    

008004a6 <MSort>:


void MSort(int* A, int p, int r)
{
  8004a6:	55                   	push   %ebp
  8004a7:	89 e5                	mov    %esp,%ebp
  8004a9:	83 ec 18             	sub    $0x18,%esp
	if (p >= r)
  8004ac:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004af:	3b 45 10             	cmp    0x10(%ebp),%eax
  8004b2:	7d 54                	jge    800508 <MSort+0x62>
	{
		return;
	}

	int q = (p + r) / 2;
  8004b4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004b7:	8b 45 10             	mov    0x10(%ebp),%eax
  8004ba:	01 d0                	add    %edx,%eax
  8004bc:	89 c2                	mov    %eax,%edx
  8004be:	c1 ea 1f             	shr    $0x1f,%edx
  8004c1:	01 d0                	add    %edx,%eax
  8004c3:	d1 f8                	sar    %eax
  8004c5:	89 45 f4             	mov    %eax,-0xc(%ebp)

	MSort(A, p, q);
  8004c8:	83 ec 04             	sub    $0x4,%esp
  8004cb:	ff 75 f4             	pushl  -0xc(%ebp)
  8004ce:	ff 75 0c             	pushl  0xc(%ebp)
  8004d1:	ff 75 08             	pushl  0x8(%ebp)
  8004d4:	e8 cd ff ff ff       	call   8004a6 <MSort>
  8004d9:	83 c4 10             	add    $0x10,%esp

	MSort(A, q + 1, r);
  8004dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8004df:	40                   	inc    %eax
  8004e0:	83 ec 04             	sub    $0x4,%esp
  8004e3:	ff 75 10             	pushl  0x10(%ebp)
  8004e6:	50                   	push   %eax
  8004e7:	ff 75 08             	pushl  0x8(%ebp)
  8004ea:	e8 b7 ff ff ff       	call   8004a6 <MSort>
  8004ef:	83 c4 10             	add    $0x10,%esp

	Merge(A, p, q, r);
  8004f2:	ff 75 10             	pushl  0x10(%ebp)
  8004f5:	ff 75 f4             	pushl  -0xc(%ebp)
  8004f8:	ff 75 0c             	pushl  0xc(%ebp)
  8004fb:	ff 75 08             	pushl  0x8(%ebp)
  8004fe:	e8 08 00 00 00       	call   80050b <Merge>
  800503:	83 c4 10             	add    $0x10,%esp
  800506:	eb 01                	jmp    800509 <MSort+0x63>

void MSort(int* A, int p, int r)
{
	if (p >= r)
	{
		return;
  800508:	90                   	nop

	MSort(A, q + 1, r);

	Merge(A, p, q, r);

}
  800509:	c9                   	leave  
  80050a:	c3                   	ret    

0080050b <Merge>:

void Merge(int* A, int p, int q, int r)
{
  80050b:	55                   	push   %ebp
  80050c:	89 e5                	mov    %esp,%ebp
  80050e:	83 ec 38             	sub    $0x38,%esp
	int leftCapacity = q - p + 1;
  800511:	8b 45 10             	mov    0x10(%ebp),%eax
  800514:	2b 45 0c             	sub    0xc(%ebp),%eax
  800517:	40                   	inc    %eax
  800518:	89 45 e0             	mov    %eax,-0x20(%ebp)

	int rightCapacity = r - q;
  80051b:	8b 45 14             	mov    0x14(%ebp),%eax
  80051e:	2b 45 10             	sub    0x10(%ebp),%eax
  800521:	89 45 dc             	mov    %eax,-0x24(%ebp)

	int leftIndex = 0;
  800524:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	int rightIndex = 0;
  80052b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	int* Left = malloc(sizeof(int) * leftCapacity);
  800532:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800535:	c1 e0 02             	shl    $0x2,%eax
  800538:	83 ec 0c             	sub    $0xc,%esp
  80053b:	50                   	push   %eax
  80053c:	e8 9e 18 00 00       	call   801ddf <malloc>
  800541:	83 c4 10             	add    $0x10,%esp
  800544:	89 45 d8             	mov    %eax,-0x28(%ebp)

	int* Right = malloc(sizeof(int) * rightCapacity);
  800547:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80054a:	c1 e0 02             	shl    $0x2,%eax
  80054d:	83 ec 0c             	sub    $0xc,%esp
  800550:	50                   	push   %eax
  800551:	e8 89 18 00 00       	call   801ddf <malloc>
  800556:	83 c4 10             	add    $0x10,%esp
  800559:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	//	int Left[5000] ;
	//	int Right[5000] ;

	int i, j, k;
	for (i = 0; i < leftCapacity; i++)
  80055c:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  800563:	eb 2f                	jmp    800594 <Merge+0x89>
	{
		Left[i] = A[p + i - 1];
  800565:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800568:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80056f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800572:	01 c2                	add    %eax,%edx
  800574:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800577:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80057a:	01 c8                	add    %ecx,%eax
  80057c:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  800581:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800588:	8b 45 08             	mov    0x8(%ebp),%eax
  80058b:	01 c8                	add    %ecx,%eax
  80058d:	8b 00                	mov    (%eax),%eax
  80058f:	89 02                	mov    %eax,(%edx)

	//	int Left[5000] ;
	//	int Right[5000] ;

	int i, j, k;
	for (i = 0; i < leftCapacity; i++)
  800591:	ff 45 ec             	incl   -0x14(%ebp)
  800594:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800597:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80059a:	7c c9                	jl     800565 <Merge+0x5a>
	{
		Left[i] = A[p + i - 1];
	}
	for (j = 0; j < rightCapacity; j++)
  80059c:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8005a3:	eb 2a                	jmp    8005cf <Merge+0xc4>
	{
		Right[j] = A[q + j];
  8005a5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8005a8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8005af:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8005b2:	01 c2                	add    %eax,%edx
  8005b4:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8005b7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8005ba:	01 c8                	add    %ecx,%eax
  8005bc:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8005c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8005c6:	01 c8                	add    %ecx,%eax
  8005c8:	8b 00                	mov    (%eax),%eax
  8005ca:	89 02                	mov    %eax,(%edx)
	int i, j, k;
	for (i = 0; i < leftCapacity; i++)
	{
		Left[i] = A[p + i - 1];
	}
	for (j = 0; j < rightCapacity; j++)
  8005cc:	ff 45 e8             	incl   -0x18(%ebp)
  8005cf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8005d2:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8005d5:	7c ce                	jl     8005a5 <Merge+0x9a>
	{
		Right[j] = A[q + j];
	}

	for ( k = p; k <= r; k++)
  8005d7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005da:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8005dd:	e9 0a 01 00 00       	jmp    8006ec <Merge+0x1e1>
	{
		if (leftIndex < leftCapacity && rightIndex < rightCapacity)
  8005e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8005e5:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8005e8:	0f 8d 95 00 00 00    	jge    800683 <Merge+0x178>
  8005ee:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8005f1:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8005f4:	0f 8d 89 00 00 00    	jge    800683 <Merge+0x178>
		{
			if (Left[leftIndex] < Right[rightIndex] )
  8005fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8005fd:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800604:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800607:	01 d0                	add    %edx,%eax
  800609:	8b 10                	mov    (%eax),%edx
  80060b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80060e:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800615:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800618:	01 c8                	add    %ecx,%eax
  80061a:	8b 00                	mov    (%eax),%eax
  80061c:	39 c2                	cmp    %eax,%edx
  80061e:	7d 33                	jge    800653 <Merge+0x148>
			{
				A[k - 1] = Left[leftIndex++];
  800620:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800623:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  800628:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80062f:	8b 45 08             	mov    0x8(%ebp),%eax
  800632:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  800635:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800638:	8d 50 01             	lea    0x1(%eax),%edx
  80063b:	89 55 f4             	mov    %edx,-0xc(%ebp)
  80063e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800645:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800648:	01 d0                	add    %edx,%eax
  80064a:	8b 00                	mov    (%eax),%eax
  80064c:	89 01                	mov    %eax,(%ecx)

	for ( k = p; k <= r; k++)
	{
		if (leftIndex < leftCapacity && rightIndex < rightCapacity)
		{
			if (Left[leftIndex] < Right[rightIndex] )
  80064e:	e9 96 00 00 00       	jmp    8006e9 <Merge+0x1de>
			{
				A[k - 1] = Left[leftIndex++];
			}
			else
			{
				A[k - 1] = Right[rightIndex++];
  800653:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800656:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  80065b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800662:	8b 45 08             	mov    0x8(%ebp),%eax
  800665:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  800668:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80066b:	8d 50 01             	lea    0x1(%eax),%edx
  80066e:	89 55 f0             	mov    %edx,-0x10(%ebp)
  800671:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800678:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80067b:	01 d0                	add    %edx,%eax
  80067d:	8b 00                	mov    (%eax),%eax
  80067f:	89 01                	mov    %eax,(%ecx)

	for ( k = p; k <= r; k++)
	{
		if (leftIndex < leftCapacity && rightIndex < rightCapacity)
		{
			if (Left[leftIndex] < Right[rightIndex] )
  800681:	eb 66                	jmp    8006e9 <Merge+0x1de>
			else
			{
				A[k - 1] = Right[rightIndex++];
			}
		}
		else if (leftIndex < leftCapacity)
  800683:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800686:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800689:	7d 30                	jge    8006bb <Merge+0x1b0>
		{
			A[k - 1] = Left[leftIndex++];
  80068b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80068e:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  800693:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80069a:	8b 45 08             	mov    0x8(%ebp),%eax
  80069d:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  8006a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8006a3:	8d 50 01             	lea    0x1(%eax),%edx
  8006a6:	89 55 f4             	mov    %edx,-0xc(%ebp)
  8006a9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8006b0:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8006b3:	01 d0                	add    %edx,%eax
  8006b5:	8b 00                	mov    (%eax),%eax
  8006b7:	89 01                	mov    %eax,(%ecx)
  8006b9:	eb 2e                	jmp    8006e9 <Merge+0x1de>
		}
		else
		{
			A[k - 1] = Right[rightIndex++];
  8006bb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8006be:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  8006c3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8006ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8006cd:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  8006d0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8006d3:	8d 50 01             	lea    0x1(%eax),%edx
  8006d6:	89 55 f0             	mov    %edx,-0x10(%ebp)
  8006d9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8006e0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8006e3:	01 d0                	add    %edx,%eax
  8006e5:	8b 00                	mov    (%eax),%eax
  8006e7:	89 01                	mov    %eax,(%ecx)
	for (j = 0; j < rightCapacity; j++)
	{
		Right[j] = A[q + j];
	}

	for ( k = p; k <= r; k++)
  8006e9:	ff 45 e4             	incl   -0x1c(%ebp)
  8006ec:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8006ef:	3b 45 14             	cmp    0x14(%ebp),%eax
  8006f2:	0f 8e ea fe ff ff    	jle    8005e2 <Merge+0xd7>
		{
			A[k - 1] = Right[rightIndex++];
		}
	}

}
  8006f8:	90                   	nop
  8006f9:	c9                   	leave  
  8006fa:	c3                   	ret    

008006fb <cputchar>:
#include <inc/lib.h>


void
cputchar(int ch)
{
  8006fb:	55                   	push   %ebp
  8006fc:	89 e5                	mov    %esp,%ebp
  8006fe:	83 ec 18             	sub    $0x18,%esp
	char c = ch;
  800701:	8b 45 08             	mov    0x8(%ebp),%eax
  800704:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  800707:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  80070b:	83 ec 0c             	sub    $0xc,%esp
  80070e:	50                   	push   %eax
  80070f:	e8 b5 30 00 00       	call   8037c9 <sys_cputc>
  800714:	83 c4 10             	add    $0x10,%esp
}
  800717:	90                   	nop
  800718:	c9                   	leave  
  800719:	c3                   	ret    

0080071a <getchar>:


int
getchar(void)
{
  80071a:	55                   	push   %ebp
  80071b:	89 e5                	mov    %esp,%ebp
  80071d:	83 ec 18             	sub    $0x18,%esp
	int c =sys_cgetc();
  800720:	e8 43 2f 00 00       	call   803668 <sys_cgetc>
  800725:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return c;
  800728:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80072b:	c9                   	leave  
  80072c:	c3                   	ret    

0080072d <iscons>:

int iscons(int fdnum)
{
  80072d:	55                   	push   %ebp
  80072e:	89 e5                	mov    %esp,%ebp
	// used by readline
	return 1;
  800730:	b8 01 00 00 00       	mov    $0x1,%eax
}
  800735:	5d                   	pop    %ebp
  800736:	c3                   	ret    

00800737 <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  800737:	55                   	push   %ebp
  800738:	89 e5                	mov    %esp,%ebp
  80073a:	57                   	push   %edi
  80073b:	56                   	push   %esi
  80073c:	53                   	push   %ebx
  80073d:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  800740:	e8 b5 31 00 00       	call   8038fa <sys_getenvindex>
  800745:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  800748:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80074b:	89 d0                	mov    %edx,%eax
  80074d:	c1 e0 02             	shl    $0x2,%eax
  800750:	01 d0                	add    %edx,%eax
  800752:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800759:	01 d0                	add    %edx,%eax
  80075b:	89 c2                	mov    %eax,%edx
  80075d:	c1 e2 04             	shl    $0x4,%edx
  800760:	29 c2                	sub    %eax,%edx
  800762:	8d 04 95 00 00 00 00 	lea    0x0(,%edx,4),%eax
  800769:	89 c2                	mov    %eax,%edx
  80076b:	8d 82 00 00 c0 ee    	lea    -0x11400000(%edx),%eax
  800771:	a3 24 60 80 00       	mov    %eax,0x806024

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800776:	a1 24 60 80 00       	mov    0x806024,%eax
  80077b:	8a 40 20             	mov    0x20(%eax),%al
  80077e:	84 c0                	test   %al,%al
  800780:	74 0d                	je     80078f <libmain+0x58>
		binaryname = myEnv->prog_name;
  800782:	a1 24 60 80 00       	mov    0x806024,%eax
  800787:	83 c0 20             	add    $0x20,%eax
  80078a:	a3 04 60 80 00       	mov    %eax,0x806004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80078f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800793:	7e 0a                	jle    80079f <libmain+0x68>
		binaryname = argv[0];
  800795:	8b 45 0c             	mov    0xc(%ebp),%eax
  800798:	8b 00                	mov    (%eax),%eax
  80079a:	a3 04 60 80 00       	mov    %eax,0x806004

	// call user main routine
	_main(argc, argv);
  80079f:	83 ec 08             	sub    $0x8,%esp
  8007a2:	ff 75 0c             	pushl  0xc(%ebp)
  8007a5:	ff 75 08             	pushl  0x8(%ebp)
  8007a8:	e8 8b f8 ff ff       	call   800038 <_main>
  8007ad:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  8007b0:	a1 00 60 80 00       	mov    0x806000,%eax
  8007b5:	85 c0                	test   %eax,%eax
  8007b7:	0f 84 01 01 00 00    	je     8008be <libmain+0x187>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  8007bd:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  8007c3:	bb 74 4c 80 00       	mov    $0x804c74,%ebx
  8007c8:	ba 0e 00 00 00       	mov    $0xe,%edx
  8007cd:	89 c7                	mov    %eax,%edi
  8007cf:	89 de                	mov    %ebx,%esi
  8007d1:	89 d1                	mov    %edx,%ecx
  8007d3:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  8007d5:	8d 55 8a             	lea    -0x76(%ebp),%edx
  8007d8:	b9 56 00 00 00       	mov    $0x56,%ecx
  8007dd:	b0 00                	mov    $0x0,%al
  8007df:	89 d7                	mov    %edx,%edi
  8007e1:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  8007e3:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  8007ea:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8007ed:	83 ec 08             	sub    $0x8,%esp
  8007f0:	50                   	push   %eax
  8007f1:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  8007f7:	50                   	push   %eax
  8007f8:	e8 33 33 00 00       	call   803b30 <sys_utilities>
  8007fd:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  800800:	e8 7c 2e 00 00       	call   803681 <sys_lock_cons>
		{
			cprintf("**************************************\n");
  800805:	83 ec 0c             	sub    $0xc,%esp
  800808:	68 94 4b 80 00       	push   $0x804b94
  80080d:	e8 ac 03 00 00       	call   800bbe <cprintf>
  800812:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  800815:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800818:	85 c0                	test   %eax,%eax
  80081a:	74 18                	je     800834 <libmain+0xfd>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  80081c:	e8 2d 33 00 00       	call   803b4e <sys_get_optimal_num_faults>
  800821:	83 ec 08             	sub    $0x8,%esp
  800824:	50                   	push   %eax
  800825:	68 bc 4b 80 00       	push   $0x804bbc
  80082a:	e8 8f 03 00 00       	call   800bbe <cprintf>
  80082f:	83 c4 10             	add    $0x10,%esp
  800832:	eb 59                	jmp    80088d <libmain+0x156>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800834:	a1 24 60 80 00       	mov    0x806024,%eax
  800839:	8b 90 bc 05 00 00    	mov    0x5bc(%eax),%edx
  80083f:	a1 24 60 80 00       	mov    0x806024,%eax
  800844:	8b 80 ac 05 00 00    	mov    0x5ac(%eax),%eax
  80084a:	83 ec 04             	sub    $0x4,%esp
  80084d:	52                   	push   %edx
  80084e:	50                   	push   %eax
  80084f:	68 e0 4b 80 00       	push   $0x804be0
  800854:	e8 65 03 00 00       	call   800bbe <cprintf>
  800859:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  80085c:	a1 24 60 80 00       	mov    0x806024,%eax
  800861:	8b 88 d0 05 00 00    	mov    0x5d0(%eax),%ecx
  800867:	a1 24 60 80 00       	mov    0x806024,%eax
  80086c:	8b 90 cc 05 00 00    	mov    0x5cc(%eax),%edx
  800872:	a1 24 60 80 00       	mov    0x806024,%eax
  800877:	8b 80 c8 05 00 00    	mov    0x5c8(%eax),%eax
  80087d:	51                   	push   %ecx
  80087e:	52                   	push   %edx
  80087f:	50                   	push   %eax
  800880:	68 08 4c 80 00       	push   $0x804c08
  800885:	e8 34 03 00 00       	call   800bbe <cprintf>
  80088a:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80088d:	a1 24 60 80 00       	mov    0x806024,%eax
  800892:	8b 80 d4 05 00 00    	mov    0x5d4(%eax),%eax
  800898:	83 ec 08             	sub    $0x8,%esp
  80089b:	50                   	push   %eax
  80089c:	68 60 4c 80 00       	push   $0x804c60
  8008a1:	e8 18 03 00 00       	call   800bbe <cprintf>
  8008a6:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  8008a9:	83 ec 0c             	sub    $0xc,%esp
  8008ac:	68 94 4b 80 00       	push   $0x804b94
  8008b1:	e8 08 03 00 00       	call   800bbe <cprintf>
  8008b6:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  8008b9:	e8 dd 2d 00 00       	call   80369b <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  8008be:	e8 1f 00 00 00       	call   8008e2 <exit>
}
  8008c3:	90                   	nop
  8008c4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8008c7:	5b                   	pop    %ebx
  8008c8:	5e                   	pop    %esi
  8008c9:	5f                   	pop    %edi
  8008ca:	5d                   	pop    %ebp
  8008cb:	c3                   	ret    

008008cc <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8008cc:	55                   	push   %ebp
  8008cd:	89 e5                	mov    %esp,%ebp
  8008cf:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8008d2:	83 ec 0c             	sub    $0xc,%esp
  8008d5:	6a 00                	push   $0x0
  8008d7:	e8 ea 2f 00 00       	call   8038c6 <sys_destroy_env>
  8008dc:	83 c4 10             	add    $0x10,%esp
}
  8008df:	90                   	nop
  8008e0:	c9                   	leave  
  8008e1:	c3                   	ret    

008008e2 <exit>:

void
exit(void)
{
  8008e2:	55                   	push   %ebp
  8008e3:	89 e5                	mov    %esp,%ebp
  8008e5:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8008e8:	e8 3f 30 00 00       	call   80392c <sys_exit_env>
}
  8008ed:	90                   	nop
  8008ee:	c9                   	leave  
  8008ef:	c3                   	ret    

008008f0 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8008f0:	55                   	push   %ebp
  8008f1:	89 e5                	mov    %esp,%ebp
  8008f3:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8008f6:	8d 45 10             	lea    0x10(%ebp),%eax
  8008f9:	83 c0 04             	add    $0x4,%eax
  8008fc:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8008ff:	a1 18 e1 81 00       	mov    0x81e118,%eax
  800904:	85 c0                	test   %eax,%eax
  800906:	74 16                	je     80091e <_panic+0x2e>
		cprintf("%s: ", argv0);
  800908:	a1 18 e1 81 00       	mov    0x81e118,%eax
  80090d:	83 ec 08             	sub    $0x8,%esp
  800910:	50                   	push   %eax
  800911:	68 d8 4c 80 00       	push   $0x804cd8
  800916:	e8 a3 02 00 00       	call   800bbe <cprintf>
  80091b:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  80091e:	a1 04 60 80 00       	mov    0x806004,%eax
  800923:	83 ec 0c             	sub    $0xc,%esp
  800926:	ff 75 0c             	pushl  0xc(%ebp)
  800929:	ff 75 08             	pushl  0x8(%ebp)
  80092c:	50                   	push   %eax
  80092d:	68 e0 4c 80 00       	push   $0x804ce0
  800932:	6a 74                	push   $0x74
  800934:	e8 b2 02 00 00       	call   800beb <cprintf_colored>
  800939:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  80093c:	8b 45 10             	mov    0x10(%ebp),%eax
  80093f:	83 ec 08             	sub    $0x8,%esp
  800942:	ff 75 f4             	pushl  -0xc(%ebp)
  800945:	50                   	push   %eax
  800946:	e8 04 02 00 00       	call   800b4f <vcprintf>
  80094b:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  80094e:	83 ec 08             	sub    $0x8,%esp
  800951:	6a 00                	push   $0x0
  800953:	68 08 4d 80 00       	push   $0x804d08
  800958:	e8 f2 01 00 00       	call   800b4f <vcprintf>
  80095d:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800960:	e8 7d ff ff ff       	call   8008e2 <exit>

	// should not return here
	while (1) ;
  800965:	eb fe                	jmp    800965 <_panic+0x75>

00800967 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800967:	55                   	push   %ebp
  800968:	89 e5                	mov    %esp,%ebp
  80096a:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  80096d:	a1 24 60 80 00       	mov    0x806024,%eax
  800972:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800978:	8b 45 0c             	mov    0xc(%ebp),%eax
  80097b:	39 c2                	cmp    %eax,%edx
  80097d:	74 14                	je     800993 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  80097f:	83 ec 04             	sub    $0x4,%esp
  800982:	68 0c 4d 80 00       	push   $0x804d0c
  800987:	6a 26                	push   $0x26
  800989:	68 58 4d 80 00       	push   $0x804d58
  80098e:	e8 5d ff ff ff       	call   8008f0 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800993:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  80099a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8009a1:	e9 c5 00 00 00       	jmp    800a6b <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  8009a6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009a9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8009b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8009b3:	01 d0                	add    %edx,%eax
  8009b5:	8b 00                	mov    (%eax),%eax
  8009b7:	85 c0                	test   %eax,%eax
  8009b9:	75 08                	jne    8009c3 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  8009bb:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8009be:	e9 a5 00 00 00       	jmp    800a68 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  8009c3:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8009ca:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8009d1:	eb 69                	jmp    800a3c <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8009d3:	a1 24 60 80 00       	mov    0x806024,%eax
  8009d8:	8b 88 a4 05 00 00    	mov    0x5a4(%eax),%ecx
  8009de:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8009e1:	89 d0                	mov    %edx,%eax
  8009e3:	01 c0                	add    %eax,%eax
  8009e5:	01 d0                	add    %edx,%eax
  8009e7:	c1 e0 03             	shl    $0x3,%eax
  8009ea:	01 c8                	add    %ecx,%eax
  8009ec:	8a 40 04             	mov    0x4(%eax),%al
  8009ef:	84 c0                	test   %al,%al
  8009f1:	75 46                	jne    800a39 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8009f3:	a1 24 60 80 00       	mov    0x806024,%eax
  8009f8:	8b 88 a4 05 00 00    	mov    0x5a4(%eax),%ecx
  8009fe:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800a01:	89 d0                	mov    %edx,%eax
  800a03:	01 c0                	add    %eax,%eax
  800a05:	01 d0                	add    %edx,%eax
  800a07:	c1 e0 03             	shl    $0x3,%eax
  800a0a:	01 c8                	add    %ecx,%eax
  800a0c:	8b 00                	mov    (%eax),%eax
  800a0e:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800a11:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800a14:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800a19:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800a1b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a1e:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800a25:	8b 45 08             	mov    0x8(%ebp),%eax
  800a28:	01 c8                	add    %ecx,%eax
  800a2a:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800a2c:	39 c2                	cmp    %eax,%edx
  800a2e:	75 09                	jne    800a39 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  800a30:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800a37:	eb 15                	jmp    800a4e <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800a39:	ff 45 e8             	incl   -0x18(%ebp)
  800a3c:	a1 24 60 80 00       	mov    0x806024,%eax
  800a41:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800a47:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800a4a:	39 c2                	cmp    %eax,%edx
  800a4c:	77 85                	ja     8009d3 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800a4e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800a52:	75 14                	jne    800a68 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  800a54:	83 ec 04             	sub    $0x4,%esp
  800a57:	68 64 4d 80 00       	push   $0x804d64
  800a5c:	6a 3a                	push   $0x3a
  800a5e:	68 58 4d 80 00       	push   $0x804d58
  800a63:	e8 88 fe ff ff       	call   8008f0 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800a68:	ff 45 f0             	incl   -0x10(%ebp)
  800a6b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a6e:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800a71:	0f 8c 2f ff ff ff    	jl     8009a6 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800a77:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800a7e:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800a85:	eb 26                	jmp    800aad <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800a87:	a1 24 60 80 00       	mov    0x806024,%eax
  800a8c:	8b 88 a4 05 00 00    	mov    0x5a4(%eax),%ecx
  800a92:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800a95:	89 d0                	mov    %edx,%eax
  800a97:	01 c0                	add    %eax,%eax
  800a99:	01 d0                	add    %edx,%eax
  800a9b:	c1 e0 03             	shl    $0x3,%eax
  800a9e:	01 c8                	add    %ecx,%eax
  800aa0:	8a 40 04             	mov    0x4(%eax),%al
  800aa3:	3c 01                	cmp    $0x1,%al
  800aa5:	75 03                	jne    800aaa <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  800aa7:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800aaa:	ff 45 e0             	incl   -0x20(%ebp)
  800aad:	a1 24 60 80 00       	mov    0x806024,%eax
  800ab2:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800ab8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800abb:	39 c2                	cmp    %eax,%edx
  800abd:	77 c8                	ja     800a87 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800abf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800ac2:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800ac5:	74 14                	je     800adb <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  800ac7:	83 ec 04             	sub    $0x4,%esp
  800aca:	68 b8 4d 80 00       	push   $0x804db8
  800acf:	6a 44                	push   $0x44
  800ad1:	68 58 4d 80 00       	push   $0x804d58
  800ad6:	e8 15 fe ff ff       	call   8008f0 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800adb:	90                   	nop
  800adc:	c9                   	leave  
  800add:	c3                   	ret    

00800ade <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  800ade:	55                   	push   %ebp
  800adf:	89 e5                	mov    %esp,%ebp
  800ae1:	53                   	push   %ebx
  800ae2:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  800ae5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ae8:	8b 00                	mov    (%eax),%eax
  800aea:	8d 48 01             	lea    0x1(%eax),%ecx
  800aed:	8b 55 0c             	mov    0xc(%ebp),%edx
  800af0:	89 0a                	mov    %ecx,(%edx)
  800af2:	8b 55 08             	mov    0x8(%ebp),%edx
  800af5:	88 d1                	mov    %dl,%cl
  800af7:	8b 55 0c             	mov    0xc(%ebp),%edx
  800afa:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800afe:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b01:	8b 00                	mov    (%eax),%eax
  800b03:	3d ff 00 00 00       	cmp    $0xff,%eax
  800b08:	75 30                	jne    800b3a <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  800b0a:	8b 15 1c e1 81 00    	mov    0x81e11c,%edx
  800b10:	a0 44 60 80 00       	mov    0x806044,%al
  800b15:	0f b6 c0             	movzbl %al,%eax
  800b18:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b1b:	8b 09                	mov    (%ecx),%ecx
  800b1d:	89 cb                	mov    %ecx,%ebx
  800b1f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b22:	83 c1 08             	add    $0x8,%ecx
  800b25:	52                   	push   %edx
  800b26:	50                   	push   %eax
  800b27:	53                   	push   %ebx
  800b28:	51                   	push   %ecx
  800b29:	e8 0f 2b 00 00       	call   80363d <sys_cputs>
  800b2e:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800b31:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b34:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800b3a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b3d:	8b 40 04             	mov    0x4(%eax),%eax
  800b40:	8d 50 01             	lea    0x1(%eax),%edx
  800b43:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b46:	89 50 04             	mov    %edx,0x4(%eax)
}
  800b49:	90                   	nop
  800b4a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800b4d:	c9                   	leave  
  800b4e:	c3                   	ret    

00800b4f <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800b4f:	55                   	push   %ebp
  800b50:	89 e5                	mov    %esp,%ebp
  800b52:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800b58:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800b5f:	00 00 00 
	b.cnt = 0;
  800b62:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800b69:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800b6c:	ff 75 0c             	pushl  0xc(%ebp)
  800b6f:	ff 75 08             	pushl  0x8(%ebp)
  800b72:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800b78:	50                   	push   %eax
  800b79:	68 de 0a 80 00       	push   $0x800ade
  800b7e:	e8 5a 02 00 00       	call   800ddd <vprintfmt>
  800b83:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  800b86:	8b 15 1c e1 81 00    	mov    0x81e11c,%edx
  800b8c:	a0 44 60 80 00       	mov    0x806044,%al
  800b91:	0f b6 c0             	movzbl %al,%eax
  800b94:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  800b9a:	52                   	push   %edx
  800b9b:	50                   	push   %eax
  800b9c:	51                   	push   %ecx
  800b9d:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800ba3:	83 c0 08             	add    $0x8,%eax
  800ba6:	50                   	push   %eax
  800ba7:	e8 91 2a 00 00       	call   80363d <sys_cputs>
  800bac:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800baf:	c6 05 44 60 80 00 00 	movb   $0x0,0x806044
	return b.cnt;
  800bb6:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800bbc:	c9                   	leave  
  800bbd:	c3                   	ret    

00800bbe <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  800bbe:	55                   	push   %ebp
  800bbf:	89 e5                	mov    %esp,%ebp
  800bc1:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800bc4:	c6 05 44 60 80 00 01 	movb   $0x1,0x806044
	va_start(ap, fmt);
  800bcb:	8d 45 0c             	lea    0xc(%ebp),%eax
  800bce:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800bd1:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd4:	83 ec 08             	sub    $0x8,%esp
  800bd7:	ff 75 f4             	pushl  -0xc(%ebp)
  800bda:	50                   	push   %eax
  800bdb:	e8 6f ff ff ff       	call   800b4f <vcprintf>
  800be0:	83 c4 10             	add    $0x10,%esp
  800be3:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800be6:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800be9:	c9                   	leave  
  800bea:	c3                   	ret    

00800beb <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  800beb:	55                   	push   %ebp
  800bec:	89 e5                	mov    %esp,%ebp
  800bee:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800bf1:	c6 05 44 60 80 00 01 	movb   $0x1,0x806044
	curTextClr = (textClr << 8) ; //set text color by the given value
  800bf8:	8b 45 08             	mov    0x8(%ebp),%eax
  800bfb:	c1 e0 08             	shl    $0x8,%eax
  800bfe:	a3 1c e1 81 00       	mov    %eax,0x81e11c
	va_start(ap, fmt);
  800c03:	8d 45 0c             	lea    0xc(%ebp),%eax
  800c06:	83 c0 04             	add    $0x4,%eax
  800c09:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800c0c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c0f:	83 ec 08             	sub    $0x8,%esp
  800c12:	ff 75 f4             	pushl  -0xc(%ebp)
  800c15:	50                   	push   %eax
  800c16:	e8 34 ff ff ff       	call   800b4f <vcprintf>
  800c1b:	83 c4 10             	add    $0x10,%esp
  800c1e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  800c21:	c7 05 1c e1 81 00 00 	movl   $0x700,0x81e11c
  800c28:	07 00 00 

	return cnt;
  800c2b:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800c2e:	c9                   	leave  
  800c2f:	c3                   	ret    

00800c30 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  800c30:	55                   	push   %ebp
  800c31:	89 e5                	mov    %esp,%ebp
  800c33:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  800c36:	e8 46 2a 00 00       	call   803681 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  800c3b:	8d 45 0c             	lea    0xc(%ebp),%eax
  800c3e:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  800c41:	8b 45 08             	mov    0x8(%ebp),%eax
  800c44:	83 ec 08             	sub    $0x8,%esp
  800c47:	ff 75 f4             	pushl  -0xc(%ebp)
  800c4a:	50                   	push   %eax
  800c4b:	e8 ff fe ff ff       	call   800b4f <vcprintf>
  800c50:	83 c4 10             	add    $0x10,%esp
  800c53:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  800c56:	e8 40 2a 00 00       	call   80369b <sys_unlock_cons>
	return cnt;
  800c5b:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800c5e:	c9                   	leave  
  800c5f:	c3                   	ret    

00800c60 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800c60:	55                   	push   %ebp
  800c61:	89 e5                	mov    %esp,%ebp
  800c63:	53                   	push   %ebx
  800c64:	83 ec 14             	sub    $0x14,%esp
  800c67:	8b 45 10             	mov    0x10(%ebp),%eax
  800c6a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c6d:	8b 45 14             	mov    0x14(%ebp),%eax
  800c70:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800c73:	8b 45 18             	mov    0x18(%ebp),%eax
  800c76:	ba 00 00 00 00       	mov    $0x0,%edx
  800c7b:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800c7e:	77 55                	ja     800cd5 <printnum+0x75>
  800c80:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800c83:	72 05                	jb     800c8a <printnum+0x2a>
  800c85:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800c88:	77 4b                	ja     800cd5 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800c8a:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800c8d:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800c90:	8b 45 18             	mov    0x18(%ebp),%eax
  800c93:	ba 00 00 00 00       	mov    $0x0,%edx
  800c98:	52                   	push   %edx
  800c99:	50                   	push   %eax
  800c9a:	ff 75 f4             	pushl  -0xc(%ebp)
  800c9d:	ff 75 f0             	pushl  -0x10(%ebp)
  800ca0:	e8 87 3a 00 00       	call   80472c <__udivdi3>
  800ca5:	83 c4 10             	add    $0x10,%esp
  800ca8:	83 ec 04             	sub    $0x4,%esp
  800cab:	ff 75 20             	pushl  0x20(%ebp)
  800cae:	53                   	push   %ebx
  800caf:	ff 75 18             	pushl  0x18(%ebp)
  800cb2:	52                   	push   %edx
  800cb3:	50                   	push   %eax
  800cb4:	ff 75 0c             	pushl  0xc(%ebp)
  800cb7:	ff 75 08             	pushl  0x8(%ebp)
  800cba:	e8 a1 ff ff ff       	call   800c60 <printnum>
  800cbf:	83 c4 20             	add    $0x20,%esp
  800cc2:	eb 1a                	jmp    800cde <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800cc4:	83 ec 08             	sub    $0x8,%esp
  800cc7:	ff 75 0c             	pushl  0xc(%ebp)
  800cca:	ff 75 20             	pushl  0x20(%ebp)
  800ccd:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd0:	ff d0                	call   *%eax
  800cd2:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800cd5:	ff 4d 1c             	decl   0x1c(%ebp)
  800cd8:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800cdc:	7f e6                	jg     800cc4 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800cde:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800ce1:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ce6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ce9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800cec:	53                   	push   %ebx
  800ced:	51                   	push   %ecx
  800cee:	52                   	push   %edx
  800cef:	50                   	push   %eax
  800cf0:	e8 47 3b 00 00       	call   80483c <__umoddi3>
  800cf5:	83 c4 10             	add    $0x10,%esp
  800cf8:	05 34 50 80 00       	add    $0x805034,%eax
  800cfd:	8a 00                	mov    (%eax),%al
  800cff:	0f be c0             	movsbl %al,%eax
  800d02:	83 ec 08             	sub    $0x8,%esp
  800d05:	ff 75 0c             	pushl  0xc(%ebp)
  800d08:	50                   	push   %eax
  800d09:	8b 45 08             	mov    0x8(%ebp),%eax
  800d0c:	ff d0                	call   *%eax
  800d0e:	83 c4 10             	add    $0x10,%esp
}
  800d11:	90                   	nop
  800d12:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800d15:	c9                   	leave  
  800d16:	c3                   	ret    

00800d17 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800d17:	55                   	push   %ebp
  800d18:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800d1a:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800d1e:	7e 1c                	jle    800d3c <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800d20:	8b 45 08             	mov    0x8(%ebp),%eax
  800d23:	8b 00                	mov    (%eax),%eax
  800d25:	8d 50 08             	lea    0x8(%eax),%edx
  800d28:	8b 45 08             	mov    0x8(%ebp),%eax
  800d2b:	89 10                	mov    %edx,(%eax)
  800d2d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d30:	8b 00                	mov    (%eax),%eax
  800d32:	83 e8 08             	sub    $0x8,%eax
  800d35:	8b 50 04             	mov    0x4(%eax),%edx
  800d38:	8b 00                	mov    (%eax),%eax
  800d3a:	eb 40                	jmp    800d7c <getuint+0x65>
	else if (lflag)
  800d3c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d40:	74 1e                	je     800d60 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800d42:	8b 45 08             	mov    0x8(%ebp),%eax
  800d45:	8b 00                	mov    (%eax),%eax
  800d47:	8d 50 04             	lea    0x4(%eax),%edx
  800d4a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d4d:	89 10                	mov    %edx,(%eax)
  800d4f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d52:	8b 00                	mov    (%eax),%eax
  800d54:	83 e8 04             	sub    $0x4,%eax
  800d57:	8b 00                	mov    (%eax),%eax
  800d59:	ba 00 00 00 00       	mov    $0x0,%edx
  800d5e:	eb 1c                	jmp    800d7c <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800d60:	8b 45 08             	mov    0x8(%ebp),%eax
  800d63:	8b 00                	mov    (%eax),%eax
  800d65:	8d 50 04             	lea    0x4(%eax),%edx
  800d68:	8b 45 08             	mov    0x8(%ebp),%eax
  800d6b:	89 10                	mov    %edx,(%eax)
  800d6d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d70:	8b 00                	mov    (%eax),%eax
  800d72:	83 e8 04             	sub    $0x4,%eax
  800d75:	8b 00                	mov    (%eax),%eax
  800d77:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800d7c:	5d                   	pop    %ebp
  800d7d:	c3                   	ret    

00800d7e <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800d7e:	55                   	push   %ebp
  800d7f:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800d81:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800d85:	7e 1c                	jle    800da3 <getint+0x25>
		return va_arg(*ap, long long);
  800d87:	8b 45 08             	mov    0x8(%ebp),%eax
  800d8a:	8b 00                	mov    (%eax),%eax
  800d8c:	8d 50 08             	lea    0x8(%eax),%edx
  800d8f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d92:	89 10                	mov    %edx,(%eax)
  800d94:	8b 45 08             	mov    0x8(%ebp),%eax
  800d97:	8b 00                	mov    (%eax),%eax
  800d99:	83 e8 08             	sub    $0x8,%eax
  800d9c:	8b 50 04             	mov    0x4(%eax),%edx
  800d9f:	8b 00                	mov    (%eax),%eax
  800da1:	eb 38                	jmp    800ddb <getint+0x5d>
	else if (lflag)
  800da3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800da7:	74 1a                	je     800dc3 <getint+0x45>
		return va_arg(*ap, long);
  800da9:	8b 45 08             	mov    0x8(%ebp),%eax
  800dac:	8b 00                	mov    (%eax),%eax
  800dae:	8d 50 04             	lea    0x4(%eax),%edx
  800db1:	8b 45 08             	mov    0x8(%ebp),%eax
  800db4:	89 10                	mov    %edx,(%eax)
  800db6:	8b 45 08             	mov    0x8(%ebp),%eax
  800db9:	8b 00                	mov    (%eax),%eax
  800dbb:	83 e8 04             	sub    $0x4,%eax
  800dbe:	8b 00                	mov    (%eax),%eax
  800dc0:	99                   	cltd   
  800dc1:	eb 18                	jmp    800ddb <getint+0x5d>
	else
		return va_arg(*ap, int);
  800dc3:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc6:	8b 00                	mov    (%eax),%eax
  800dc8:	8d 50 04             	lea    0x4(%eax),%edx
  800dcb:	8b 45 08             	mov    0x8(%ebp),%eax
  800dce:	89 10                	mov    %edx,(%eax)
  800dd0:	8b 45 08             	mov    0x8(%ebp),%eax
  800dd3:	8b 00                	mov    (%eax),%eax
  800dd5:	83 e8 04             	sub    $0x4,%eax
  800dd8:	8b 00                	mov    (%eax),%eax
  800dda:	99                   	cltd   
}
  800ddb:	5d                   	pop    %ebp
  800ddc:	c3                   	ret    

00800ddd <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800ddd:	55                   	push   %ebp
  800dde:	89 e5                	mov    %esp,%ebp
  800de0:	56                   	push   %esi
  800de1:	53                   	push   %ebx
  800de2:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800de5:	eb 17                	jmp    800dfe <vprintfmt+0x21>
			if (ch == '\0')
  800de7:	85 db                	test   %ebx,%ebx
  800de9:	0f 84 c1 03 00 00    	je     8011b0 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  800def:	83 ec 08             	sub    $0x8,%esp
  800df2:	ff 75 0c             	pushl  0xc(%ebp)
  800df5:	53                   	push   %ebx
  800df6:	8b 45 08             	mov    0x8(%ebp),%eax
  800df9:	ff d0                	call   *%eax
  800dfb:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800dfe:	8b 45 10             	mov    0x10(%ebp),%eax
  800e01:	8d 50 01             	lea    0x1(%eax),%edx
  800e04:	89 55 10             	mov    %edx,0x10(%ebp)
  800e07:	8a 00                	mov    (%eax),%al
  800e09:	0f b6 d8             	movzbl %al,%ebx
  800e0c:	83 fb 25             	cmp    $0x25,%ebx
  800e0f:	75 d6                	jne    800de7 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800e11:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800e15:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800e1c:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800e23:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800e2a:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800e31:	8b 45 10             	mov    0x10(%ebp),%eax
  800e34:	8d 50 01             	lea    0x1(%eax),%edx
  800e37:	89 55 10             	mov    %edx,0x10(%ebp)
  800e3a:	8a 00                	mov    (%eax),%al
  800e3c:	0f b6 d8             	movzbl %al,%ebx
  800e3f:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800e42:	83 f8 5b             	cmp    $0x5b,%eax
  800e45:	0f 87 3d 03 00 00    	ja     801188 <vprintfmt+0x3ab>
  800e4b:	8b 04 85 58 50 80 00 	mov    0x805058(,%eax,4),%eax
  800e52:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800e54:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800e58:	eb d7                	jmp    800e31 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800e5a:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800e5e:	eb d1                	jmp    800e31 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800e60:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800e67:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800e6a:	89 d0                	mov    %edx,%eax
  800e6c:	c1 e0 02             	shl    $0x2,%eax
  800e6f:	01 d0                	add    %edx,%eax
  800e71:	01 c0                	add    %eax,%eax
  800e73:	01 d8                	add    %ebx,%eax
  800e75:	83 e8 30             	sub    $0x30,%eax
  800e78:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800e7b:	8b 45 10             	mov    0x10(%ebp),%eax
  800e7e:	8a 00                	mov    (%eax),%al
  800e80:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800e83:	83 fb 2f             	cmp    $0x2f,%ebx
  800e86:	7e 3e                	jle    800ec6 <vprintfmt+0xe9>
  800e88:	83 fb 39             	cmp    $0x39,%ebx
  800e8b:	7f 39                	jg     800ec6 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800e8d:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800e90:	eb d5                	jmp    800e67 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800e92:	8b 45 14             	mov    0x14(%ebp),%eax
  800e95:	83 c0 04             	add    $0x4,%eax
  800e98:	89 45 14             	mov    %eax,0x14(%ebp)
  800e9b:	8b 45 14             	mov    0x14(%ebp),%eax
  800e9e:	83 e8 04             	sub    $0x4,%eax
  800ea1:	8b 00                	mov    (%eax),%eax
  800ea3:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800ea6:	eb 1f                	jmp    800ec7 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800ea8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800eac:	79 83                	jns    800e31 <vprintfmt+0x54>
				width = 0;
  800eae:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800eb5:	e9 77 ff ff ff       	jmp    800e31 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800eba:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800ec1:	e9 6b ff ff ff       	jmp    800e31 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800ec6:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800ec7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800ecb:	0f 89 60 ff ff ff    	jns    800e31 <vprintfmt+0x54>
				width = precision, precision = -1;
  800ed1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800ed4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800ed7:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800ede:	e9 4e ff ff ff       	jmp    800e31 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800ee3:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800ee6:	e9 46 ff ff ff       	jmp    800e31 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800eeb:	8b 45 14             	mov    0x14(%ebp),%eax
  800eee:	83 c0 04             	add    $0x4,%eax
  800ef1:	89 45 14             	mov    %eax,0x14(%ebp)
  800ef4:	8b 45 14             	mov    0x14(%ebp),%eax
  800ef7:	83 e8 04             	sub    $0x4,%eax
  800efa:	8b 00                	mov    (%eax),%eax
  800efc:	83 ec 08             	sub    $0x8,%esp
  800eff:	ff 75 0c             	pushl  0xc(%ebp)
  800f02:	50                   	push   %eax
  800f03:	8b 45 08             	mov    0x8(%ebp),%eax
  800f06:	ff d0                	call   *%eax
  800f08:	83 c4 10             	add    $0x10,%esp
			break;
  800f0b:	e9 9b 02 00 00       	jmp    8011ab <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800f10:	8b 45 14             	mov    0x14(%ebp),%eax
  800f13:	83 c0 04             	add    $0x4,%eax
  800f16:	89 45 14             	mov    %eax,0x14(%ebp)
  800f19:	8b 45 14             	mov    0x14(%ebp),%eax
  800f1c:	83 e8 04             	sub    $0x4,%eax
  800f1f:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800f21:	85 db                	test   %ebx,%ebx
  800f23:	79 02                	jns    800f27 <vprintfmt+0x14a>
				err = -err;
  800f25:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800f27:	83 fb 64             	cmp    $0x64,%ebx
  800f2a:	7f 0b                	jg     800f37 <vprintfmt+0x15a>
  800f2c:	8b 34 9d a0 4e 80 00 	mov    0x804ea0(,%ebx,4),%esi
  800f33:	85 f6                	test   %esi,%esi
  800f35:	75 19                	jne    800f50 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800f37:	53                   	push   %ebx
  800f38:	68 45 50 80 00       	push   $0x805045
  800f3d:	ff 75 0c             	pushl  0xc(%ebp)
  800f40:	ff 75 08             	pushl  0x8(%ebp)
  800f43:	e8 70 02 00 00       	call   8011b8 <printfmt>
  800f48:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800f4b:	e9 5b 02 00 00       	jmp    8011ab <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800f50:	56                   	push   %esi
  800f51:	68 4e 50 80 00       	push   $0x80504e
  800f56:	ff 75 0c             	pushl  0xc(%ebp)
  800f59:	ff 75 08             	pushl  0x8(%ebp)
  800f5c:	e8 57 02 00 00       	call   8011b8 <printfmt>
  800f61:	83 c4 10             	add    $0x10,%esp
			break;
  800f64:	e9 42 02 00 00       	jmp    8011ab <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800f69:	8b 45 14             	mov    0x14(%ebp),%eax
  800f6c:	83 c0 04             	add    $0x4,%eax
  800f6f:	89 45 14             	mov    %eax,0x14(%ebp)
  800f72:	8b 45 14             	mov    0x14(%ebp),%eax
  800f75:	83 e8 04             	sub    $0x4,%eax
  800f78:	8b 30                	mov    (%eax),%esi
  800f7a:	85 f6                	test   %esi,%esi
  800f7c:	75 05                	jne    800f83 <vprintfmt+0x1a6>
				p = "(null)";
  800f7e:	be 51 50 80 00       	mov    $0x805051,%esi
			if (width > 0 && padc != '-')
  800f83:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800f87:	7e 6d                	jle    800ff6 <vprintfmt+0x219>
  800f89:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800f8d:	74 67                	je     800ff6 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800f8f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800f92:	83 ec 08             	sub    $0x8,%esp
  800f95:	50                   	push   %eax
  800f96:	56                   	push   %esi
  800f97:	e8 26 05 00 00       	call   8014c2 <strnlen>
  800f9c:	83 c4 10             	add    $0x10,%esp
  800f9f:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800fa2:	eb 16                	jmp    800fba <vprintfmt+0x1dd>
					putch(padc, putdat);
  800fa4:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800fa8:	83 ec 08             	sub    $0x8,%esp
  800fab:	ff 75 0c             	pushl  0xc(%ebp)
  800fae:	50                   	push   %eax
  800faf:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb2:	ff d0                	call   *%eax
  800fb4:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800fb7:	ff 4d e4             	decl   -0x1c(%ebp)
  800fba:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800fbe:	7f e4                	jg     800fa4 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800fc0:	eb 34                	jmp    800ff6 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800fc2:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800fc6:	74 1c                	je     800fe4 <vprintfmt+0x207>
  800fc8:	83 fb 1f             	cmp    $0x1f,%ebx
  800fcb:	7e 05                	jle    800fd2 <vprintfmt+0x1f5>
  800fcd:	83 fb 7e             	cmp    $0x7e,%ebx
  800fd0:	7e 12                	jle    800fe4 <vprintfmt+0x207>
					putch('?', putdat);
  800fd2:	83 ec 08             	sub    $0x8,%esp
  800fd5:	ff 75 0c             	pushl  0xc(%ebp)
  800fd8:	6a 3f                	push   $0x3f
  800fda:	8b 45 08             	mov    0x8(%ebp),%eax
  800fdd:	ff d0                	call   *%eax
  800fdf:	83 c4 10             	add    $0x10,%esp
  800fe2:	eb 0f                	jmp    800ff3 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800fe4:	83 ec 08             	sub    $0x8,%esp
  800fe7:	ff 75 0c             	pushl  0xc(%ebp)
  800fea:	53                   	push   %ebx
  800feb:	8b 45 08             	mov    0x8(%ebp),%eax
  800fee:	ff d0                	call   *%eax
  800ff0:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800ff3:	ff 4d e4             	decl   -0x1c(%ebp)
  800ff6:	89 f0                	mov    %esi,%eax
  800ff8:	8d 70 01             	lea    0x1(%eax),%esi
  800ffb:	8a 00                	mov    (%eax),%al
  800ffd:	0f be d8             	movsbl %al,%ebx
  801000:	85 db                	test   %ebx,%ebx
  801002:	74 24                	je     801028 <vprintfmt+0x24b>
  801004:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801008:	78 b8                	js     800fc2 <vprintfmt+0x1e5>
  80100a:	ff 4d e0             	decl   -0x20(%ebp)
  80100d:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801011:	79 af                	jns    800fc2 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801013:	eb 13                	jmp    801028 <vprintfmt+0x24b>
				putch(' ', putdat);
  801015:	83 ec 08             	sub    $0x8,%esp
  801018:	ff 75 0c             	pushl  0xc(%ebp)
  80101b:	6a 20                	push   $0x20
  80101d:	8b 45 08             	mov    0x8(%ebp),%eax
  801020:	ff d0                	call   *%eax
  801022:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801025:	ff 4d e4             	decl   -0x1c(%ebp)
  801028:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80102c:	7f e7                	jg     801015 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  80102e:	e9 78 01 00 00       	jmp    8011ab <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  801033:	83 ec 08             	sub    $0x8,%esp
  801036:	ff 75 e8             	pushl  -0x18(%ebp)
  801039:	8d 45 14             	lea    0x14(%ebp),%eax
  80103c:	50                   	push   %eax
  80103d:	e8 3c fd ff ff       	call   800d7e <getint>
  801042:	83 c4 10             	add    $0x10,%esp
  801045:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801048:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  80104b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80104e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801051:	85 d2                	test   %edx,%edx
  801053:	79 23                	jns    801078 <vprintfmt+0x29b>
				putch('-', putdat);
  801055:	83 ec 08             	sub    $0x8,%esp
  801058:	ff 75 0c             	pushl  0xc(%ebp)
  80105b:	6a 2d                	push   $0x2d
  80105d:	8b 45 08             	mov    0x8(%ebp),%eax
  801060:	ff d0                	call   *%eax
  801062:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  801065:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801068:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80106b:	f7 d8                	neg    %eax
  80106d:	83 d2 00             	adc    $0x0,%edx
  801070:	f7 da                	neg    %edx
  801072:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801075:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  801078:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  80107f:	e9 bc 00 00 00       	jmp    801140 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  801084:	83 ec 08             	sub    $0x8,%esp
  801087:	ff 75 e8             	pushl  -0x18(%ebp)
  80108a:	8d 45 14             	lea    0x14(%ebp),%eax
  80108d:	50                   	push   %eax
  80108e:	e8 84 fc ff ff       	call   800d17 <getuint>
  801093:	83 c4 10             	add    $0x10,%esp
  801096:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801099:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  80109c:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8010a3:	e9 98 00 00 00       	jmp    801140 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  8010a8:	83 ec 08             	sub    $0x8,%esp
  8010ab:	ff 75 0c             	pushl  0xc(%ebp)
  8010ae:	6a 58                	push   $0x58
  8010b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b3:	ff d0                	call   *%eax
  8010b5:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8010b8:	83 ec 08             	sub    $0x8,%esp
  8010bb:	ff 75 0c             	pushl  0xc(%ebp)
  8010be:	6a 58                	push   $0x58
  8010c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c3:	ff d0                	call   *%eax
  8010c5:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8010c8:	83 ec 08             	sub    $0x8,%esp
  8010cb:	ff 75 0c             	pushl  0xc(%ebp)
  8010ce:	6a 58                	push   $0x58
  8010d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8010d3:	ff d0                	call   *%eax
  8010d5:	83 c4 10             	add    $0x10,%esp
			break;
  8010d8:	e9 ce 00 00 00       	jmp    8011ab <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  8010dd:	83 ec 08             	sub    $0x8,%esp
  8010e0:	ff 75 0c             	pushl  0xc(%ebp)
  8010e3:	6a 30                	push   $0x30
  8010e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8010e8:	ff d0                	call   *%eax
  8010ea:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  8010ed:	83 ec 08             	sub    $0x8,%esp
  8010f0:	ff 75 0c             	pushl  0xc(%ebp)
  8010f3:	6a 78                	push   $0x78
  8010f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8010f8:	ff d0                	call   *%eax
  8010fa:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  8010fd:	8b 45 14             	mov    0x14(%ebp),%eax
  801100:	83 c0 04             	add    $0x4,%eax
  801103:	89 45 14             	mov    %eax,0x14(%ebp)
  801106:	8b 45 14             	mov    0x14(%ebp),%eax
  801109:	83 e8 04             	sub    $0x4,%eax
  80110c:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  80110e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801111:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  801118:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  80111f:	eb 1f                	jmp    801140 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  801121:	83 ec 08             	sub    $0x8,%esp
  801124:	ff 75 e8             	pushl  -0x18(%ebp)
  801127:	8d 45 14             	lea    0x14(%ebp),%eax
  80112a:	50                   	push   %eax
  80112b:	e8 e7 fb ff ff       	call   800d17 <getuint>
  801130:	83 c4 10             	add    $0x10,%esp
  801133:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801136:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  801139:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  801140:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  801144:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801147:	83 ec 04             	sub    $0x4,%esp
  80114a:	52                   	push   %edx
  80114b:	ff 75 e4             	pushl  -0x1c(%ebp)
  80114e:	50                   	push   %eax
  80114f:	ff 75 f4             	pushl  -0xc(%ebp)
  801152:	ff 75 f0             	pushl  -0x10(%ebp)
  801155:	ff 75 0c             	pushl  0xc(%ebp)
  801158:	ff 75 08             	pushl  0x8(%ebp)
  80115b:	e8 00 fb ff ff       	call   800c60 <printnum>
  801160:	83 c4 20             	add    $0x20,%esp
			break;
  801163:	eb 46                	jmp    8011ab <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  801165:	83 ec 08             	sub    $0x8,%esp
  801168:	ff 75 0c             	pushl  0xc(%ebp)
  80116b:	53                   	push   %ebx
  80116c:	8b 45 08             	mov    0x8(%ebp),%eax
  80116f:	ff d0                	call   *%eax
  801171:	83 c4 10             	add    $0x10,%esp
			break;
  801174:	eb 35                	jmp    8011ab <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  801176:	c6 05 44 60 80 00 00 	movb   $0x0,0x806044
			break;
  80117d:	eb 2c                	jmp    8011ab <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  80117f:	c6 05 44 60 80 00 01 	movb   $0x1,0x806044
			break;
  801186:	eb 23                	jmp    8011ab <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  801188:	83 ec 08             	sub    $0x8,%esp
  80118b:	ff 75 0c             	pushl  0xc(%ebp)
  80118e:	6a 25                	push   $0x25
  801190:	8b 45 08             	mov    0x8(%ebp),%eax
  801193:	ff d0                	call   *%eax
  801195:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  801198:	ff 4d 10             	decl   0x10(%ebp)
  80119b:	eb 03                	jmp    8011a0 <vprintfmt+0x3c3>
  80119d:	ff 4d 10             	decl   0x10(%ebp)
  8011a0:	8b 45 10             	mov    0x10(%ebp),%eax
  8011a3:	48                   	dec    %eax
  8011a4:	8a 00                	mov    (%eax),%al
  8011a6:	3c 25                	cmp    $0x25,%al
  8011a8:	75 f3                	jne    80119d <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  8011aa:	90                   	nop
		}
	}
  8011ab:	e9 35 fc ff ff       	jmp    800de5 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  8011b0:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  8011b1:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8011b4:	5b                   	pop    %ebx
  8011b5:	5e                   	pop    %esi
  8011b6:	5d                   	pop    %ebp
  8011b7:	c3                   	ret    

008011b8 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8011b8:	55                   	push   %ebp
  8011b9:	89 e5                	mov    %esp,%ebp
  8011bb:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  8011be:	8d 45 10             	lea    0x10(%ebp),%eax
  8011c1:	83 c0 04             	add    $0x4,%eax
  8011c4:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  8011c7:	8b 45 10             	mov    0x10(%ebp),%eax
  8011ca:	ff 75 f4             	pushl  -0xc(%ebp)
  8011cd:	50                   	push   %eax
  8011ce:	ff 75 0c             	pushl  0xc(%ebp)
  8011d1:	ff 75 08             	pushl  0x8(%ebp)
  8011d4:	e8 04 fc ff ff       	call   800ddd <vprintfmt>
  8011d9:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  8011dc:	90                   	nop
  8011dd:	c9                   	leave  
  8011de:	c3                   	ret    

008011df <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8011df:	55                   	push   %ebp
  8011e0:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  8011e2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011e5:	8b 40 08             	mov    0x8(%eax),%eax
  8011e8:	8d 50 01             	lea    0x1(%eax),%edx
  8011eb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011ee:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  8011f1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011f4:	8b 10                	mov    (%eax),%edx
  8011f6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011f9:	8b 40 04             	mov    0x4(%eax),%eax
  8011fc:	39 c2                	cmp    %eax,%edx
  8011fe:	73 12                	jae    801212 <sprintputch+0x33>
		*b->buf++ = ch;
  801200:	8b 45 0c             	mov    0xc(%ebp),%eax
  801203:	8b 00                	mov    (%eax),%eax
  801205:	8d 48 01             	lea    0x1(%eax),%ecx
  801208:	8b 55 0c             	mov    0xc(%ebp),%edx
  80120b:	89 0a                	mov    %ecx,(%edx)
  80120d:	8b 55 08             	mov    0x8(%ebp),%edx
  801210:	88 10                	mov    %dl,(%eax)
}
  801212:	90                   	nop
  801213:	5d                   	pop    %ebp
  801214:	c3                   	ret    

00801215 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801215:	55                   	push   %ebp
  801216:	89 e5                	mov    %esp,%ebp
  801218:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  80121b:	8b 45 08             	mov    0x8(%ebp),%eax
  80121e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801221:	8b 45 0c             	mov    0xc(%ebp),%eax
  801224:	8d 50 ff             	lea    -0x1(%eax),%edx
  801227:	8b 45 08             	mov    0x8(%ebp),%eax
  80122a:	01 d0                	add    %edx,%eax
  80122c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80122f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  801236:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80123a:	74 06                	je     801242 <vsnprintf+0x2d>
  80123c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801240:	7f 07                	jg     801249 <vsnprintf+0x34>
		return -E_INVAL;
  801242:	b8 03 00 00 00       	mov    $0x3,%eax
  801247:	eb 20                	jmp    801269 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  801249:	ff 75 14             	pushl  0x14(%ebp)
  80124c:	ff 75 10             	pushl  0x10(%ebp)
  80124f:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801252:	50                   	push   %eax
  801253:	68 df 11 80 00       	push   $0x8011df
  801258:	e8 80 fb ff ff       	call   800ddd <vprintfmt>
  80125d:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  801260:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801263:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  801266:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801269:	c9                   	leave  
  80126a:	c3                   	ret    

0080126b <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80126b:	55                   	push   %ebp
  80126c:	89 e5                	mov    %esp,%ebp
  80126e:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801271:	8d 45 10             	lea    0x10(%ebp),%eax
  801274:	83 c0 04             	add    $0x4,%eax
  801277:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  80127a:	8b 45 10             	mov    0x10(%ebp),%eax
  80127d:	ff 75 f4             	pushl  -0xc(%ebp)
  801280:	50                   	push   %eax
  801281:	ff 75 0c             	pushl  0xc(%ebp)
  801284:	ff 75 08             	pushl  0x8(%ebp)
  801287:	e8 89 ff ff ff       	call   801215 <vsnprintf>
  80128c:	83 c4 10             	add    $0x10,%esp
  80128f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  801292:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801295:	c9                   	leave  
  801296:	c3                   	ret    

00801297 <readline>:
#include <inc/lib.h>

//static char buf[BUFLEN];

void readline(const char *prompt, char* buf)
{
  801297:	55                   	push   %ebp
  801298:	89 e5                	mov    %esp,%ebp
  80129a:	83 ec 18             	sub    $0x18,%esp
	int i, c, echoing;

	if (prompt != NULL)
  80129d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8012a1:	74 13                	je     8012b6 <readline+0x1f>
		cprintf("%s", prompt);
  8012a3:	83 ec 08             	sub    $0x8,%esp
  8012a6:	ff 75 08             	pushl  0x8(%ebp)
  8012a9:	68 c8 51 80 00       	push   $0x8051c8
  8012ae:	e8 0b f9 ff ff       	call   800bbe <cprintf>
  8012b3:	83 c4 10             	add    $0x10,%esp

	i = 0;
  8012b6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  8012bd:	83 ec 0c             	sub    $0xc,%esp
  8012c0:	6a 00                	push   $0x0
  8012c2:	e8 66 f4 ff ff       	call   80072d <iscons>
  8012c7:	83 c4 10             	add    $0x10,%esp
  8012ca:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  8012cd:	e8 48 f4 ff ff       	call   80071a <getchar>
  8012d2:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (c < 0) {
  8012d5:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8012d9:	79 22                	jns    8012fd <readline+0x66>
			if (c != -E_EOF)
  8012db:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  8012df:	0f 84 ad 00 00 00    	je     801392 <readline+0xfb>
				cprintf("read error: %e\n", c);
  8012e5:	83 ec 08             	sub    $0x8,%esp
  8012e8:	ff 75 ec             	pushl  -0x14(%ebp)
  8012eb:	68 cb 51 80 00       	push   $0x8051cb
  8012f0:	e8 c9 f8 ff ff       	call   800bbe <cprintf>
  8012f5:	83 c4 10             	add    $0x10,%esp
			break;
  8012f8:	e9 95 00 00 00       	jmp    801392 <readline+0xfb>
		} else if (c >= ' ' && i < BUFLEN-1) {
  8012fd:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  801301:	7e 34                	jle    801337 <readline+0xa0>
  801303:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  80130a:	7f 2b                	jg     801337 <readline+0xa0>
			if (echoing)
  80130c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801310:	74 0e                	je     801320 <readline+0x89>
				cputchar(c);
  801312:	83 ec 0c             	sub    $0xc,%esp
  801315:	ff 75 ec             	pushl  -0x14(%ebp)
  801318:	e8 de f3 ff ff       	call   8006fb <cputchar>
  80131d:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  801320:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801323:	8d 50 01             	lea    0x1(%eax),%edx
  801326:	89 55 f4             	mov    %edx,-0xc(%ebp)
  801329:	89 c2                	mov    %eax,%edx
  80132b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80132e:	01 d0                	add    %edx,%eax
  801330:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801333:	88 10                	mov    %dl,(%eax)
  801335:	eb 56                	jmp    80138d <readline+0xf6>
		} else if (c == '\b' && i > 0) {
  801337:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  80133b:	75 1f                	jne    80135c <readline+0xc5>
  80133d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801341:	7e 19                	jle    80135c <readline+0xc5>
			if (echoing)
  801343:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801347:	74 0e                	je     801357 <readline+0xc0>
				cputchar(c);
  801349:	83 ec 0c             	sub    $0xc,%esp
  80134c:	ff 75 ec             	pushl  -0x14(%ebp)
  80134f:	e8 a7 f3 ff ff       	call   8006fb <cputchar>
  801354:	83 c4 10             	add    $0x10,%esp

			i--;
  801357:	ff 4d f4             	decl   -0xc(%ebp)
  80135a:	eb 31                	jmp    80138d <readline+0xf6>
		} else if (c == '\n' || c == '\r') {
  80135c:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  801360:	74 0a                	je     80136c <readline+0xd5>
  801362:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  801366:	0f 85 61 ff ff ff    	jne    8012cd <readline+0x36>
			if (echoing)
  80136c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801370:	74 0e                	je     801380 <readline+0xe9>
				cputchar(c);
  801372:	83 ec 0c             	sub    $0xc,%esp
  801375:	ff 75 ec             	pushl  -0x14(%ebp)
  801378:	e8 7e f3 ff ff       	call   8006fb <cputchar>
  80137d:	83 c4 10             	add    $0x10,%esp

			buf[i] = 0;
  801380:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801383:	8b 45 0c             	mov    0xc(%ebp),%eax
  801386:	01 d0                	add    %edx,%eax
  801388:	c6 00 00             	movb   $0x0,(%eax)
			break;
  80138b:	eb 06                	jmp    801393 <readline+0xfc>
		}
	}
  80138d:	e9 3b ff ff ff       	jmp    8012cd <readline+0x36>
	while (1) {
		c = getchar();
		if (c < 0) {
			if (c != -E_EOF)
				cprintf("read error: %e\n", c);
			break;
  801392:	90                   	nop

			buf[i] = 0;
			break;
		}
	}
}
  801393:	90                   	nop
  801394:	c9                   	leave  
  801395:	c3                   	ret    

00801396 <atomic_readline>:

void atomic_readline(const char *prompt, char* buf)
{
  801396:	55                   	push   %ebp
  801397:	89 e5                	mov    %esp,%ebp
  801399:	83 ec 18             	sub    $0x18,%esp
	sys_lock_cons();
  80139c:	e8 e0 22 00 00       	call   803681 <sys_lock_cons>
	{
		int i, c, echoing;

		if (prompt != NULL)
  8013a1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8013a5:	74 13                	je     8013ba <atomic_readline+0x24>
			cprintf("%s", prompt);
  8013a7:	83 ec 08             	sub    $0x8,%esp
  8013aa:	ff 75 08             	pushl  0x8(%ebp)
  8013ad:	68 c8 51 80 00       	push   $0x8051c8
  8013b2:	e8 07 f8 ff ff       	call   800bbe <cprintf>
  8013b7:	83 c4 10             	add    $0x10,%esp

		i = 0;
  8013ba:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
		echoing = iscons(0);
  8013c1:	83 ec 0c             	sub    $0xc,%esp
  8013c4:	6a 00                	push   $0x0
  8013c6:	e8 62 f3 ff ff       	call   80072d <iscons>
  8013cb:	83 c4 10             	add    $0x10,%esp
  8013ce:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (1) {
			c = getchar();
  8013d1:	e8 44 f3 ff ff       	call   80071a <getchar>
  8013d6:	89 45 ec             	mov    %eax,-0x14(%ebp)
			if (c < 0) {
  8013d9:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8013dd:	79 22                	jns    801401 <atomic_readline+0x6b>
				if (c != -E_EOF)
  8013df:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  8013e3:	0f 84 ad 00 00 00    	je     801496 <atomic_readline+0x100>
					cprintf("read error: %e\n", c);
  8013e9:	83 ec 08             	sub    $0x8,%esp
  8013ec:	ff 75 ec             	pushl  -0x14(%ebp)
  8013ef:	68 cb 51 80 00       	push   $0x8051cb
  8013f4:	e8 c5 f7 ff ff       	call   800bbe <cprintf>
  8013f9:	83 c4 10             	add    $0x10,%esp
				break;
  8013fc:	e9 95 00 00 00       	jmp    801496 <atomic_readline+0x100>
			} else if (c >= ' ' && i < BUFLEN-1) {
  801401:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  801405:	7e 34                	jle    80143b <atomic_readline+0xa5>
  801407:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  80140e:	7f 2b                	jg     80143b <atomic_readline+0xa5>
				if (echoing)
  801410:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801414:	74 0e                	je     801424 <atomic_readline+0x8e>
					cputchar(c);
  801416:	83 ec 0c             	sub    $0xc,%esp
  801419:	ff 75 ec             	pushl  -0x14(%ebp)
  80141c:	e8 da f2 ff ff       	call   8006fb <cputchar>
  801421:	83 c4 10             	add    $0x10,%esp
				buf[i++] = c;
  801424:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801427:	8d 50 01             	lea    0x1(%eax),%edx
  80142a:	89 55 f4             	mov    %edx,-0xc(%ebp)
  80142d:	89 c2                	mov    %eax,%edx
  80142f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801432:	01 d0                	add    %edx,%eax
  801434:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801437:	88 10                	mov    %dl,(%eax)
  801439:	eb 56                	jmp    801491 <atomic_readline+0xfb>
			} else if (c == '\b' && i > 0) {
  80143b:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  80143f:	75 1f                	jne    801460 <atomic_readline+0xca>
  801441:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801445:	7e 19                	jle    801460 <atomic_readline+0xca>
				if (echoing)
  801447:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80144b:	74 0e                	je     80145b <atomic_readline+0xc5>
					cputchar(c);
  80144d:	83 ec 0c             	sub    $0xc,%esp
  801450:	ff 75 ec             	pushl  -0x14(%ebp)
  801453:	e8 a3 f2 ff ff       	call   8006fb <cputchar>
  801458:	83 c4 10             	add    $0x10,%esp
				i--;
  80145b:	ff 4d f4             	decl   -0xc(%ebp)
  80145e:	eb 31                	jmp    801491 <atomic_readline+0xfb>
			} else if (c == '\n' || c == '\r') {
  801460:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  801464:	74 0a                	je     801470 <atomic_readline+0xda>
  801466:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  80146a:	0f 85 61 ff ff ff    	jne    8013d1 <atomic_readline+0x3b>
				if (echoing)
  801470:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801474:	74 0e                	je     801484 <atomic_readline+0xee>
					cputchar(c);
  801476:	83 ec 0c             	sub    $0xc,%esp
  801479:	ff 75 ec             	pushl  -0x14(%ebp)
  80147c:	e8 7a f2 ff ff       	call   8006fb <cputchar>
  801481:	83 c4 10             	add    $0x10,%esp
				buf[i] = 0;
  801484:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801487:	8b 45 0c             	mov    0xc(%ebp),%eax
  80148a:	01 d0                	add    %edx,%eax
  80148c:	c6 00 00             	movb   $0x0,(%eax)
				break;
  80148f:	eb 06                	jmp    801497 <atomic_readline+0x101>
			}
		}
  801491:	e9 3b ff ff ff       	jmp    8013d1 <atomic_readline+0x3b>
		while (1) {
			c = getchar();
			if (c < 0) {
				if (c != -E_EOF)
					cprintf("read error: %e\n", c);
				break;
  801496:	90                   	nop
				buf[i] = 0;
				break;
			}
		}
	}
	sys_unlock_cons();
  801497:	e8 ff 21 00 00       	call   80369b <sys_unlock_cons>
}
  80149c:	90                   	nop
  80149d:	c9                   	leave  
  80149e:	c3                   	ret    

0080149f <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  80149f:	55                   	push   %ebp
  8014a0:	89 e5                	mov    %esp,%ebp
  8014a2:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  8014a5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8014ac:	eb 06                	jmp    8014b4 <strlen+0x15>
		n++;
  8014ae:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8014b1:	ff 45 08             	incl   0x8(%ebp)
  8014b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8014b7:	8a 00                	mov    (%eax),%al
  8014b9:	84 c0                	test   %al,%al
  8014bb:	75 f1                	jne    8014ae <strlen+0xf>
		n++;
	return n;
  8014bd:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8014c0:	c9                   	leave  
  8014c1:	c3                   	ret    

008014c2 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  8014c2:	55                   	push   %ebp
  8014c3:	89 e5                	mov    %esp,%ebp
  8014c5:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8014c8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8014cf:	eb 09                	jmp    8014da <strnlen+0x18>
		n++;
  8014d1:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8014d4:	ff 45 08             	incl   0x8(%ebp)
  8014d7:	ff 4d 0c             	decl   0xc(%ebp)
  8014da:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8014de:	74 09                	je     8014e9 <strnlen+0x27>
  8014e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8014e3:	8a 00                	mov    (%eax),%al
  8014e5:	84 c0                	test   %al,%al
  8014e7:	75 e8                	jne    8014d1 <strnlen+0xf>
		n++;
	return n;
  8014e9:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8014ec:	c9                   	leave  
  8014ed:	c3                   	ret    

008014ee <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8014ee:	55                   	push   %ebp
  8014ef:	89 e5                	mov    %esp,%ebp
  8014f1:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  8014f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8014f7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  8014fa:	90                   	nop
  8014fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8014fe:	8d 50 01             	lea    0x1(%eax),%edx
  801501:	89 55 08             	mov    %edx,0x8(%ebp)
  801504:	8b 55 0c             	mov    0xc(%ebp),%edx
  801507:	8d 4a 01             	lea    0x1(%edx),%ecx
  80150a:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  80150d:	8a 12                	mov    (%edx),%dl
  80150f:	88 10                	mov    %dl,(%eax)
  801511:	8a 00                	mov    (%eax),%al
  801513:	84 c0                	test   %al,%al
  801515:	75 e4                	jne    8014fb <strcpy+0xd>
		/* do nothing */;
	return ret;
  801517:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80151a:	c9                   	leave  
  80151b:	c3                   	ret    

0080151c <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  80151c:	55                   	push   %ebp
  80151d:	89 e5                	mov    %esp,%ebp
  80151f:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  801522:	8b 45 08             	mov    0x8(%ebp),%eax
  801525:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  801528:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80152f:	eb 1f                	jmp    801550 <strncpy+0x34>
		*dst++ = *src;
  801531:	8b 45 08             	mov    0x8(%ebp),%eax
  801534:	8d 50 01             	lea    0x1(%eax),%edx
  801537:	89 55 08             	mov    %edx,0x8(%ebp)
  80153a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80153d:	8a 12                	mov    (%edx),%dl
  80153f:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801541:	8b 45 0c             	mov    0xc(%ebp),%eax
  801544:	8a 00                	mov    (%eax),%al
  801546:	84 c0                	test   %al,%al
  801548:	74 03                	je     80154d <strncpy+0x31>
			src++;
  80154a:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80154d:	ff 45 fc             	incl   -0x4(%ebp)
  801550:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801553:	3b 45 10             	cmp    0x10(%ebp),%eax
  801556:	72 d9                	jb     801531 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801558:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80155b:	c9                   	leave  
  80155c:	c3                   	ret    

0080155d <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  80155d:	55                   	push   %ebp
  80155e:	89 e5                	mov    %esp,%ebp
  801560:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  801563:	8b 45 08             	mov    0x8(%ebp),%eax
  801566:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  801569:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80156d:	74 30                	je     80159f <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  80156f:	eb 16                	jmp    801587 <strlcpy+0x2a>
			*dst++ = *src++;
  801571:	8b 45 08             	mov    0x8(%ebp),%eax
  801574:	8d 50 01             	lea    0x1(%eax),%edx
  801577:	89 55 08             	mov    %edx,0x8(%ebp)
  80157a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80157d:	8d 4a 01             	lea    0x1(%edx),%ecx
  801580:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801583:	8a 12                	mov    (%edx),%dl
  801585:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801587:	ff 4d 10             	decl   0x10(%ebp)
  80158a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80158e:	74 09                	je     801599 <strlcpy+0x3c>
  801590:	8b 45 0c             	mov    0xc(%ebp),%eax
  801593:	8a 00                	mov    (%eax),%al
  801595:	84 c0                	test   %al,%al
  801597:	75 d8                	jne    801571 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  801599:	8b 45 08             	mov    0x8(%ebp),%eax
  80159c:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  80159f:	8b 55 08             	mov    0x8(%ebp),%edx
  8015a2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8015a5:	29 c2                	sub    %eax,%edx
  8015a7:	89 d0                	mov    %edx,%eax
}
  8015a9:	c9                   	leave  
  8015aa:	c3                   	ret    

008015ab <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8015ab:	55                   	push   %ebp
  8015ac:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  8015ae:	eb 06                	jmp    8015b6 <strcmp+0xb>
		p++, q++;
  8015b0:	ff 45 08             	incl   0x8(%ebp)
  8015b3:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8015b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8015b9:	8a 00                	mov    (%eax),%al
  8015bb:	84 c0                	test   %al,%al
  8015bd:	74 0e                	je     8015cd <strcmp+0x22>
  8015bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8015c2:	8a 10                	mov    (%eax),%dl
  8015c4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015c7:	8a 00                	mov    (%eax),%al
  8015c9:	38 c2                	cmp    %al,%dl
  8015cb:	74 e3                	je     8015b0 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8015cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8015d0:	8a 00                	mov    (%eax),%al
  8015d2:	0f b6 d0             	movzbl %al,%edx
  8015d5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015d8:	8a 00                	mov    (%eax),%al
  8015da:	0f b6 c0             	movzbl %al,%eax
  8015dd:	29 c2                	sub    %eax,%edx
  8015df:	89 d0                	mov    %edx,%eax
}
  8015e1:	5d                   	pop    %ebp
  8015e2:	c3                   	ret    

008015e3 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  8015e3:	55                   	push   %ebp
  8015e4:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  8015e6:	eb 09                	jmp    8015f1 <strncmp+0xe>
		n--, p++, q++;
  8015e8:	ff 4d 10             	decl   0x10(%ebp)
  8015eb:	ff 45 08             	incl   0x8(%ebp)
  8015ee:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  8015f1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8015f5:	74 17                	je     80160e <strncmp+0x2b>
  8015f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8015fa:	8a 00                	mov    (%eax),%al
  8015fc:	84 c0                	test   %al,%al
  8015fe:	74 0e                	je     80160e <strncmp+0x2b>
  801600:	8b 45 08             	mov    0x8(%ebp),%eax
  801603:	8a 10                	mov    (%eax),%dl
  801605:	8b 45 0c             	mov    0xc(%ebp),%eax
  801608:	8a 00                	mov    (%eax),%al
  80160a:	38 c2                	cmp    %al,%dl
  80160c:	74 da                	je     8015e8 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  80160e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801612:	75 07                	jne    80161b <strncmp+0x38>
		return 0;
  801614:	b8 00 00 00 00       	mov    $0x0,%eax
  801619:	eb 14                	jmp    80162f <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80161b:	8b 45 08             	mov    0x8(%ebp),%eax
  80161e:	8a 00                	mov    (%eax),%al
  801620:	0f b6 d0             	movzbl %al,%edx
  801623:	8b 45 0c             	mov    0xc(%ebp),%eax
  801626:	8a 00                	mov    (%eax),%al
  801628:	0f b6 c0             	movzbl %al,%eax
  80162b:	29 c2                	sub    %eax,%edx
  80162d:	89 d0                	mov    %edx,%eax
}
  80162f:	5d                   	pop    %ebp
  801630:	c3                   	ret    

00801631 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801631:	55                   	push   %ebp
  801632:	89 e5                	mov    %esp,%ebp
  801634:	83 ec 04             	sub    $0x4,%esp
  801637:	8b 45 0c             	mov    0xc(%ebp),%eax
  80163a:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  80163d:	eb 12                	jmp    801651 <strchr+0x20>
		if (*s == c)
  80163f:	8b 45 08             	mov    0x8(%ebp),%eax
  801642:	8a 00                	mov    (%eax),%al
  801644:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801647:	75 05                	jne    80164e <strchr+0x1d>
			return (char *) s;
  801649:	8b 45 08             	mov    0x8(%ebp),%eax
  80164c:	eb 11                	jmp    80165f <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  80164e:	ff 45 08             	incl   0x8(%ebp)
  801651:	8b 45 08             	mov    0x8(%ebp),%eax
  801654:	8a 00                	mov    (%eax),%al
  801656:	84 c0                	test   %al,%al
  801658:	75 e5                	jne    80163f <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  80165a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80165f:	c9                   	leave  
  801660:	c3                   	ret    

00801661 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801661:	55                   	push   %ebp
  801662:	89 e5                	mov    %esp,%ebp
  801664:	83 ec 04             	sub    $0x4,%esp
  801667:	8b 45 0c             	mov    0xc(%ebp),%eax
  80166a:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  80166d:	eb 0d                	jmp    80167c <strfind+0x1b>
		if (*s == c)
  80166f:	8b 45 08             	mov    0x8(%ebp),%eax
  801672:	8a 00                	mov    (%eax),%al
  801674:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801677:	74 0e                	je     801687 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801679:	ff 45 08             	incl   0x8(%ebp)
  80167c:	8b 45 08             	mov    0x8(%ebp),%eax
  80167f:	8a 00                	mov    (%eax),%al
  801681:	84 c0                	test   %al,%al
  801683:	75 ea                	jne    80166f <strfind+0xe>
  801685:	eb 01                	jmp    801688 <strfind+0x27>
		if (*s == c)
			break;
  801687:	90                   	nop
	return (char *) s;
  801688:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80168b:	c9                   	leave  
  80168c:	c3                   	ret    

0080168d <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  80168d:	55                   	push   %ebp
  80168e:	89 e5                	mov    %esp,%ebp
  801690:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  801693:	8b 45 08             	mov    0x8(%ebp),%eax
  801696:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  801699:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  80169d:	76 63                	jbe    801702 <memset+0x75>
		uint64 data_block = c;
  80169f:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016a2:	99                   	cltd   
  8016a3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8016a6:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  8016a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016ac:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8016af:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  8016b3:	c1 e0 08             	shl    $0x8,%eax
  8016b6:	09 45 f0             	or     %eax,-0x10(%ebp)
  8016b9:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  8016bc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016bf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8016c2:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  8016c6:	c1 e0 10             	shl    $0x10,%eax
  8016c9:	09 45 f0             	or     %eax,-0x10(%ebp)
  8016cc:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  8016cf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016d2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8016d5:	89 c2                	mov    %eax,%edx
  8016d7:	b8 00 00 00 00       	mov    $0x0,%eax
  8016dc:	09 45 f0             	or     %eax,-0x10(%ebp)
  8016df:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  8016e2:	eb 18                	jmp    8016fc <memset+0x6f>
			*p64++ = data_block, n -= 8;
  8016e4:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8016e7:	8d 41 08             	lea    0x8(%ecx),%eax
  8016ea:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8016ed:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016f0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8016f3:	89 01                	mov    %eax,(%ecx)
  8016f5:	89 51 04             	mov    %edx,0x4(%ecx)
  8016f8:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  8016fc:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801700:	77 e2                	ja     8016e4 <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  801702:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801706:	74 23                	je     80172b <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  801708:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80170b:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  80170e:	eb 0e                	jmp    80171e <memset+0x91>
			*p8++ = (uint8)c;
  801710:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801713:	8d 50 01             	lea    0x1(%eax),%edx
  801716:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801719:	8b 55 0c             	mov    0xc(%ebp),%edx
  80171c:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  80171e:	8b 45 10             	mov    0x10(%ebp),%eax
  801721:	8d 50 ff             	lea    -0x1(%eax),%edx
  801724:	89 55 10             	mov    %edx,0x10(%ebp)
  801727:	85 c0                	test   %eax,%eax
  801729:	75 e5                	jne    801710 <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  80172b:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80172e:	c9                   	leave  
  80172f:	c3                   	ret    

00801730 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  801730:	55                   	push   %ebp
  801731:	89 e5                	mov    %esp,%ebp
  801733:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  801736:	8b 45 0c             	mov    0xc(%ebp),%eax
  801739:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  80173c:	8b 45 08             	mov    0x8(%ebp),%eax
  80173f:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  801742:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801746:	76 24                	jbe    80176c <memcpy+0x3c>
		while(n >= 8){
  801748:	eb 1c                	jmp    801766 <memcpy+0x36>
			*d64 = *s64;
  80174a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80174d:	8b 50 04             	mov    0x4(%eax),%edx
  801750:	8b 00                	mov    (%eax),%eax
  801752:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801755:	89 01                	mov    %eax,(%ecx)
  801757:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  80175a:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  80175e:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  801762:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  801766:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  80176a:	77 de                	ja     80174a <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  80176c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801770:	74 31                	je     8017a3 <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  801772:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801775:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  801778:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80177b:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  80177e:	eb 16                	jmp    801796 <memcpy+0x66>
			*d8++ = *s8++;
  801780:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801783:	8d 50 01             	lea    0x1(%eax),%edx
  801786:	89 55 f0             	mov    %edx,-0x10(%ebp)
  801789:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80178c:	8d 4a 01             	lea    0x1(%edx),%ecx
  80178f:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  801792:	8a 12                	mov    (%edx),%dl
  801794:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  801796:	8b 45 10             	mov    0x10(%ebp),%eax
  801799:	8d 50 ff             	lea    -0x1(%eax),%edx
  80179c:	89 55 10             	mov    %edx,0x10(%ebp)
  80179f:	85 c0                	test   %eax,%eax
  8017a1:	75 dd                	jne    801780 <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  8017a3:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8017a6:	c9                   	leave  
  8017a7:	c3                   	ret    

008017a8 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  8017a8:	55                   	push   %ebp
  8017a9:	89 e5                	mov    %esp,%ebp
  8017ab:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8017ae:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017b1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8017b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8017b7:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  8017ba:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8017bd:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8017c0:	73 50                	jae    801812 <memmove+0x6a>
  8017c2:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8017c5:	8b 45 10             	mov    0x10(%ebp),%eax
  8017c8:	01 d0                	add    %edx,%eax
  8017ca:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8017cd:	76 43                	jbe    801812 <memmove+0x6a>
		s += n;
  8017cf:	8b 45 10             	mov    0x10(%ebp),%eax
  8017d2:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  8017d5:	8b 45 10             	mov    0x10(%ebp),%eax
  8017d8:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  8017db:	eb 10                	jmp    8017ed <memmove+0x45>
			*--d = *--s;
  8017dd:	ff 4d f8             	decl   -0x8(%ebp)
  8017e0:	ff 4d fc             	decl   -0x4(%ebp)
  8017e3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8017e6:	8a 10                	mov    (%eax),%dl
  8017e8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8017eb:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  8017ed:	8b 45 10             	mov    0x10(%ebp),%eax
  8017f0:	8d 50 ff             	lea    -0x1(%eax),%edx
  8017f3:	89 55 10             	mov    %edx,0x10(%ebp)
  8017f6:	85 c0                	test   %eax,%eax
  8017f8:	75 e3                	jne    8017dd <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8017fa:	eb 23                	jmp    80181f <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  8017fc:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8017ff:	8d 50 01             	lea    0x1(%eax),%edx
  801802:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801805:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801808:	8d 4a 01             	lea    0x1(%edx),%ecx
  80180b:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  80180e:	8a 12                	mov    (%edx),%dl
  801810:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801812:	8b 45 10             	mov    0x10(%ebp),%eax
  801815:	8d 50 ff             	lea    -0x1(%eax),%edx
  801818:	89 55 10             	mov    %edx,0x10(%ebp)
  80181b:	85 c0                	test   %eax,%eax
  80181d:	75 dd                	jne    8017fc <memmove+0x54>
			*d++ = *s++;

	return dst;
  80181f:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801822:	c9                   	leave  
  801823:	c3                   	ret    

00801824 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  801824:	55                   	push   %ebp
  801825:	89 e5                	mov    %esp,%ebp
  801827:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  80182a:	8b 45 08             	mov    0x8(%ebp),%eax
  80182d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  801830:	8b 45 0c             	mov    0xc(%ebp),%eax
  801833:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  801836:	eb 2a                	jmp    801862 <memcmp+0x3e>
		if (*s1 != *s2)
  801838:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80183b:	8a 10                	mov    (%eax),%dl
  80183d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801840:	8a 00                	mov    (%eax),%al
  801842:	38 c2                	cmp    %al,%dl
  801844:	74 16                	je     80185c <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801846:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801849:	8a 00                	mov    (%eax),%al
  80184b:	0f b6 d0             	movzbl %al,%edx
  80184e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801851:	8a 00                	mov    (%eax),%al
  801853:	0f b6 c0             	movzbl %al,%eax
  801856:	29 c2                	sub    %eax,%edx
  801858:	89 d0                	mov    %edx,%eax
  80185a:	eb 18                	jmp    801874 <memcmp+0x50>
		s1++, s2++;
  80185c:	ff 45 fc             	incl   -0x4(%ebp)
  80185f:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801862:	8b 45 10             	mov    0x10(%ebp),%eax
  801865:	8d 50 ff             	lea    -0x1(%eax),%edx
  801868:	89 55 10             	mov    %edx,0x10(%ebp)
  80186b:	85 c0                	test   %eax,%eax
  80186d:	75 c9                	jne    801838 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  80186f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801874:	c9                   	leave  
  801875:	c3                   	ret    

00801876 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801876:	55                   	push   %ebp
  801877:	89 e5                	mov    %esp,%ebp
  801879:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  80187c:	8b 55 08             	mov    0x8(%ebp),%edx
  80187f:	8b 45 10             	mov    0x10(%ebp),%eax
  801882:	01 d0                	add    %edx,%eax
  801884:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801887:	eb 15                	jmp    80189e <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801889:	8b 45 08             	mov    0x8(%ebp),%eax
  80188c:	8a 00                	mov    (%eax),%al
  80188e:	0f b6 d0             	movzbl %al,%edx
  801891:	8b 45 0c             	mov    0xc(%ebp),%eax
  801894:	0f b6 c0             	movzbl %al,%eax
  801897:	39 c2                	cmp    %eax,%edx
  801899:	74 0d                	je     8018a8 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80189b:	ff 45 08             	incl   0x8(%ebp)
  80189e:	8b 45 08             	mov    0x8(%ebp),%eax
  8018a1:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8018a4:	72 e3                	jb     801889 <memfind+0x13>
  8018a6:	eb 01                	jmp    8018a9 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  8018a8:	90                   	nop
	return (void *) s;
  8018a9:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8018ac:	c9                   	leave  
  8018ad:	c3                   	ret    

008018ae <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8018ae:	55                   	push   %ebp
  8018af:	89 e5                	mov    %esp,%ebp
  8018b1:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  8018b4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  8018bb:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8018c2:	eb 03                	jmp    8018c7 <strtol+0x19>
		s++;
  8018c4:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8018c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8018ca:	8a 00                	mov    (%eax),%al
  8018cc:	3c 20                	cmp    $0x20,%al
  8018ce:	74 f4                	je     8018c4 <strtol+0x16>
  8018d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8018d3:	8a 00                	mov    (%eax),%al
  8018d5:	3c 09                	cmp    $0x9,%al
  8018d7:	74 eb                	je     8018c4 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  8018d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8018dc:	8a 00                	mov    (%eax),%al
  8018de:	3c 2b                	cmp    $0x2b,%al
  8018e0:	75 05                	jne    8018e7 <strtol+0x39>
		s++;
  8018e2:	ff 45 08             	incl   0x8(%ebp)
  8018e5:	eb 13                	jmp    8018fa <strtol+0x4c>
	else if (*s == '-')
  8018e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8018ea:	8a 00                	mov    (%eax),%al
  8018ec:	3c 2d                	cmp    $0x2d,%al
  8018ee:	75 0a                	jne    8018fa <strtol+0x4c>
		s++, neg = 1;
  8018f0:	ff 45 08             	incl   0x8(%ebp)
  8018f3:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8018fa:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8018fe:	74 06                	je     801906 <strtol+0x58>
  801900:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801904:	75 20                	jne    801926 <strtol+0x78>
  801906:	8b 45 08             	mov    0x8(%ebp),%eax
  801909:	8a 00                	mov    (%eax),%al
  80190b:	3c 30                	cmp    $0x30,%al
  80190d:	75 17                	jne    801926 <strtol+0x78>
  80190f:	8b 45 08             	mov    0x8(%ebp),%eax
  801912:	40                   	inc    %eax
  801913:	8a 00                	mov    (%eax),%al
  801915:	3c 78                	cmp    $0x78,%al
  801917:	75 0d                	jne    801926 <strtol+0x78>
		s += 2, base = 16;
  801919:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  80191d:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801924:	eb 28                	jmp    80194e <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801926:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80192a:	75 15                	jne    801941 <strtol+0x93>
  80192c:	8b 45 08             	mov    0x8(%ebp),%eax
  80192f:	8a 00                	mov    (%eax),%al
  801931:	3c 30                	cmp    $0x30,%al
  801933:	75 0c                	jne    801941 <strtol+0x93>
		s++, base = 8;
  801935:	ff 45 08             	incl   0x8(%ebp)
  801938:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  80193f:	eb 0d                	jmp    80194e <strtol+0xa0>
	else if (base == 0)
  801941:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801945:	75 07                	jne    80194e <strtol+0xa0>
		base = 10;
  801947:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  80194e:	8b 45 08             	mov    0x8(%ebp),%eax
  801951:	8a 00                	mov    (%eax),%al
  801953:	3c 2f                	cmp    $0x2f,%al
  801955:	7e 19                	jle    801970 <strtol+0xc2>
  801957:	8b 45 08             	mov    0x8(%ebp),%eax
  80195a:	8a 00                	mov    (%eax),%al
  80195c:	3c 39                	cmp    $0x39,%al
  80195e:	7f 10                	jg     801970 <strtol+0xc2>
			dig = *s - '0';
  801960:	8b 45 08             	mov    0x8(%ebp),%eax
  801963:	8a 00                	mov    (%eax),%al
  801965:	0f be c0             	movsbl %al,%eax
  801968:	83 e8 30             	sub    $0x30,%eax
  80196b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80196e:	eb 42                	jmp    8019b2 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801970:	8b 45 08             	mov    0x8(%ebp),%eax
  801973:	8a 00                	mov    (%eax),%al
  801975:	3c 60                	cmp    $0x60,%al
  801977:	7e 19                	jle    801992 <strtol+0xe4>
  801979:	8b 45 08             	mov    0x8(%ebp),%eax
  80197c:	8a 00                	mov    (%eax),%al
  80197e:	3c 7a                	cmp    $0x7a,%al
  801980:	7f 10                	jg     801992 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801982:	8b 45 08             	mov    0x8(%ebp),%eax
  801985:	8a 00                	mov    (%eax),%al
  801987:	0f be c0             	movsbl %al,%eax
  80198a:	83 e8 57             	sub    $0x57,%eax
  80198d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801990:	eb 20                	jmp    8019b2 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801992:	8b 45 08             	mov    0x8(%ebp),%eax
  801995:	8a 00                	mov    (%eax),%al
  801997:	3c 40                	cmp    $0x40,%al
  801999:	7e 39                	jle    8019d4 <strtol+0x126>
  80199b:	8b 45 08             	mov    0x8(%ebp),%eax
  80199e:	8a 00                	mov    (%eax),%al
  8019a0:	3c 5a                	cmp    $0x5a,%al
  8019a2:	7f 30                	jg     8019d4 <strtol+0x126>
			dig = *s - 'A' + 10;
  8019a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8019a7:	8a 00                	mov    (%eax),%al
  8019a9:	0f be c0             	movsbl %al,%eax
  8019ac:	83 e8 37             	sub    $0x37,%eax
  8019af:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  8019b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019b5:	3b 45 10             	cmp    0x10(%ebp),%eax
  8019b8:	7d 19                	jge    8019d3 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  8019ba:	ff 45 08             	incl   0x8(%ebp)
  8019bd:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8019c0:	0f af 45 10          	imul   0x10(%ebp),%eax
  8019c4:	89 c2                	mov    %eax,%edx
  8019c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019c9:	01 d0                	add    %edx,%eax
  8019cb:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8019ce:	e9 7b ff ff ff       	jmp    80194e <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8019d3:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8019d4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8019d8:	74 08                	je     8019e2 <strtol+0x134>
		*endptr = (char *) s;
  8019da:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019dd:	8b 55 08             	mov    0x8(%ebp),%edx
  8019e0:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8019e2:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8019e6:	74 07                	je     8019ef <strtol+0x141>
  8019e8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8019eb:	f7 d8                	neg    %eax
  8019ed:	eb 03                	jmp    8019f2 <strtol+0x144>
  8019ef:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8019f2:	c9                   	leave  
  8019f3:	c3                   	ret    

008019f4 <ltostr>:

void
ltostr(long value, char *str)
{
  8019f4:	55                   	push   %ebp
  8019f5:	89 e5                	mov    %esp,%ebp
  8019f7:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8019fa:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801a01:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801a08:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801a0c:	79 13                	jns    801a21 <ltostr+0x2d>
	{
		neg = 1;
  801a0e:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801a15:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a18:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801a1b:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801a1e:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801a21:	8b 45 08             	mov    0x8(%ebp),%eax
  801a24:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801a29:	99                   	cltd   
  801a2a:	f7 f9                	idiv   %ecx
  801a2c:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801a2f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801a32:	8d 50 01             	lea    0x1(%eax),%edx
  801a35:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801a38:	89 c2                	mov    %eax,%edx
  801a3a:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a3d:	01 d0                	add    %edx,%eax
  801a3f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801a42:	83 c2 30             	add    $0x30,%edx
  801a45:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801a47:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801a4a:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801a4f:	f7 e9                	imul   %ecx
  801a51:	c1 fa 02             	sar    $0x2,%edx
  801a54:	89 c8                	mov    %ecx,%eax
  801a56:	c1 f8 1f             	sar    $0x1f,%eax
  801a59:	29 c2                	sub    %eax,%edx
  801a5b:	89 d0                	mov    %edx,%eax
  801a5d:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  801a60:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801a64:	75 bb                	jne    801a21 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801a66:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801a6d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801a70:	48                   	dec    %eax
  801a71:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801a74:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801a78:	74 3d                	je     801ab7 <ltostr+0xc3>
		start = 1 ;
  801a7a:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801a81:	eb 34                	jmp    801ab7 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  801a83:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801a86:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a89:	01 d0                	add    %edx,%eax
  801a8b:	8a 00                	mov    (%eax),%al
  801a8d:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801a90:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801a93:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a96:	01 c2                	add    %eax,%edx
  801a98:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801a9b:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a9e:	01 c8                	add    %ecx,%eax
  801aa0:	8a 00                	mov    (%eax),%al
  801aa2:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801aa4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801aa7:	8b 45 0c             	mov    0xc(%ebp),%eax
  801aaa:	01 c2                	add    %eax,%edx
  801aac:	8a 45 eb             	mov    -0x15(%ebp),%al
  801aaf:	88 02                	mov    %al,(%edx)
		start++ ;
  801ab1:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801ab4:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801ab7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801aba:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801abd:	7c c4                	jl     801a83 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801abf:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801ac2:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ac5:	01 d0                	add    %edx,%eax
  801ac7:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801aca:	90                   	nop
  801acb:	c9                   	leave  
  801acc:	c3                   	ret    

00801acd <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801acd:	55                   	push   %ebp
  801ace:	89 e5                	mov    %esp,%ebp
  801ad0:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801ad3:	ff 75 08             	pushl  0x8(%ebp)
  801ad6:	e8 c4 f9 ff ff       	call   80149f <strlen>
  801adb:	83 c4 04             	add    $0x4,%esp
  801ade:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801ae1:	ff 75 0c             	pushl  0xc(%ebp)
  801ae4:	e8 b6 f9 ff ff       	call   80149f <strlen>
  801ae9:	83 c4 04             	add    $0x4,%esp
  801aec:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801aef:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801af6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801afd:	eb 17                	jmp    801b16 <strcconcat+0x49>
		final[s] = str1[s] ;
  801aff:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801b02:	8b 45 10             	mov    0x10(%ebp),%eax
  801b05:	01 c2                	add    %eax,%edx
  801b07:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801b0a:	8b 45 08             	mov    0x8(%ebp),%eax
  801b0d:	01 c8                	add    %ecx,%eax
  801b0f:	8a 00                	mov    (%eax),%al
  801b11:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801b13:	ff 45 fc             	incl   -0x4(%ebp)
  801b16:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801b19:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801b1c:	7c e1                	jl     801aff <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801b1e:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801b25:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801b2c:	eb 1f                	jmp    801b4d <strcconcat+0x80>
		final[s++] = str2[i] ;
  801b2e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801b31:	8d 50 01             	lea    0x1(%eax),%edx
  801b34:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801b37:	89 c2                	mov    %eax,%edx
  801b39:	8b 45 10             	mov    0x10(%ebp),%eax
  801b3c:	01 c2                	add    %eax,%edx
  801b3e:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801b41:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b44:	01 c8                	add    %ecx,%eax
  801b46:	8a 00                	mov    (%eax),%al
  801b48:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801b4a:	ff 45 f8             	incl   -0x8(%ebp)
  801b4d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801b50:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801b53:	7c d9                	jl     801b2e <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801b55:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801b58:	8b 45 10             	mov    0x10(%ebp),%eax
  801b5b:	01 d0                	add    %edx,%eax
  801b5d:	c6 00 00             	movb   $0x0,(%eax)
}
  801b60:	90                   	nop
  801b61:	c9                   	leave  
  801b62:	c3                   	ret    

00801b63 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801b63:	55                   	push   %ebp
  801b64:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801b66:	8b 45 14             	mov    0x14(%ebp),%eax
  801b69:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801b6f:	8b 45 14             	mov    0x14(%ebp),%eax
  801b72:	8b 00                	mov    (%eax),%eax
  801b74:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801b7b:	8b 45 10             	mov    0x10(%ebp),%eax
  801b7e:	01 d0                	add    %edx,%eax
  801b80:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801b86:	eb 0c                	jmp    801b94 <strsplit+0x31>
			*string++ = 0;
  801b88:	8b 45 08             	mov    0x8(%ebp),%eax
  801b8b:	8d 50 01             	lea    0x1(%eax),%edx
  801b8e:	89 55 08             	mov    %edx,0x8(%ebp)
  801b91:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801b94:	8b 45 08             	mov    0x8(%ebp),%eax
  801b97:	8a 00                	mov    (%eax),%al
  801b99:	84 c0                	test   %al,%al
  801b9b:	74 18                	je     801bb5 <strsplit+0x52>
  801b9d:	8b 45 08             	mov    0x8(%ebp),%eax
  801ba0:	8a 00                	mov    (%eax),%al
  801ba2:	0f be c0             	movsbl %al,%eax
  801ba5:	50                   	push   %eax
  801ba6:	ff 75 0c             	pushl  0xc(%ebp)
  801ba9:	e8 83 fa ff ff       	call   801631 <strchr>
  801bae:	83 c4 08             	add    $0x8,%esp
  801bb1:	85 c0                	test   %eax,%eax
  801bb3:	75 d3                	jne    801b88 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801bb5:	8b 45 08             	mov    0x8(%ebp),%eax
  801bb8:	8a 00                	mov    (%eax),%al
  801bba:	84 c0                	test   %al,%al
  801bbc:	74 5a                	je     801c18 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801bbe:	8b 45 14             	mov    0x14(%ebp),%eax
  801bc1:	8b 00                	mov    (%eax),%eax
  801bc3:	83 f8 0f             	cmp    $0xf,%eax
  801bc6:	75 07                	jne    801bcf <strsplit+0x6c>
		{
			return 0;
  801bc8:	b8 00 00 00 00       	mov    $0x0,%eax
  801bcd:	eb 66                	jmp    801c35 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801bcf:	8b 45 14             	mov    0x14(%ebp),%eax
  801bd2:	8b 00                	mov    (%eax),%eax
  801bd4:	8d 48 01             	lea    0x1(%eax),%ecx
  801bd7:	8b 55 14             	mov    0x14(%ebp),%edx
  801bda:	89 0a                	mov    %ecx,(%edx)
  801bdc:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801be3:	8b 45 10             	mov    0x10(%ebp),%eax
  801be6:	01 c2                	add    %eax,%edx
  801be8:	8b 45 08             	mov    0x8(%ebp),%eax
  801beb:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801bed:	eb 03                	jmp    801bf2 <strsplit+0x8f>
			string++;
  801bef:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801bf2:	8b 45 08             	mov    0x8(%ebp),%eax
  801bf5:	8a 00                	mov    (%eax),%al
  801bf7:	84 c0                	test   %al,%al
  801bf9:	74 8b                	je     801b86 <strsplit+0x23>
  801bfb:	8b 45 08             	mov    0x8(%ebp),%eax
  801bfe:	8a 00                	mov    (%eax),%al
  801c00:	0f be c0             	movsbl %al,%eax
  801c03:	50                   	push   %eax
  801c04:	ff 75 0c             	pushl  0xc(%ebp)
  801c07:	e8 25 fa ff ff       	call   801631 <strchr>
  801c0c:	83 c4 08             	add    $0x8,%esp
  801c0f:	85 c0                	test   %eax,%eax
  801c11:	74 dc                	je     801bef <strsplit+0x8c>
			string++;
	}
  801c13:	e9 6e ff ff ff       	jmp    801b86 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801c18:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801c19:	8b 45 14             	mov    0x14(%ebp),%eax
  801c1c:	8b 00                	mov    (%eax),%eax
  801c1e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801c25:	8b 45 10             	mov    0x10(%ebp),%eax
  801c28:	01 d0                	add    %edx,%eax
  801c2a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801c30:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801c35:	c9                   	leave  
  801c36:	c3                   	ret    

00801c37 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  801c37:	55                   	push   %ebp
  801c38:	89 e5                	mov    %esp,%ebp
  801c3a:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  801c3d:	8b 45 08             	mov    0x8(%ebp),%eax
  801c40:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  801c43:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801c4a:	eb 4a                	jmp    801c96 <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  801c4c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801c4f:	8b 45 08             	mov    0x8(%ebp),%eax
  801c52:	01 c2                	add    %eax,%edx
  801c54:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801c57:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c5a:	01 c8                	add    %ecx,%eax
  801c5c:	8a 00                	mov    (%eax),%al
  801c5e:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  801c60:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801c63:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c66:	01 d0                	add    %edx,%eax
  801c68:	8a 00                	mov    (%eax),%al
  801c6a:	3c 40                	cmp    $0x40,%al
  801c6c:	7e 25                	jle    801c93 <str2lower+0x5c>
  801c6e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801c71:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c74:	01 d0                	add    %edx,%eax
  801c76:	8a 00                	mov    (%eax),%al
  801c78:	3c 5a                	cmp    $0x5a,%al
  801c7a:	7f 17                	jg     801c93 <str2lower+0x5c>
		{
			dst[i] += 32 ;
  801c7c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801c7f:	8b 45 08             	mov    0x8(%ebp),%eax
  801c82:	01 d0                	add    %edx,%eax
  801c84:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801c87:	8b 55 08             	mov    0x8(%ebp),%edx
  801c8a:	01 ca                	add    %ecx,%edx
  801c8c:	8a 12                	mov    (%edx),%dl
  801c8e:	83 c2 20             	add    $0x20,%edx
  801c91:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  801c93:	ff 45 fc             	incl   -0x4(%ebp)
  801c96:	ff 75 0c             	pushl  0xc(%ebp)
  801c99:	e8 01 f8 ff ff       	call   80149f <strlen>
  801c9e:	83 c4 04             	add    $0x4,%esp
  801ca1:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801ca4:	7f a6                	jg     801c4c <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  801ca6:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801ca9:	c9                   	leave  
  801caa:	c3                   	ret    

00801cab <uheap_init>:
//==============================================
// [1] INITIALIZE USER HEAP:
//==============================================
int __firstTimeFlag = 1;
void uheap_init()
{
  801cab:	55                   	push   %ebp
  801cac:	89 e5                	mov    %esp,%ebp
  801cae:	83 ec 08             	sub    $0x8,%esp
	if(__firstTimeFlag)
  801cb1:	a1 08 60 80 00       	mov    0x806008,%eax
  801cb6:	85 c0                	test   %eax,%eax
  801cb8:	0f 84 95 00 00 00    	je     801d53 <uheap_init+0xa8>
	{
		initialize_dynamic_allocator(USER_HEAP_START, USER_HEAP_START + DYN_ALLOC_MAX_SIZE);
  801cbe:	83 ec 08             	sub    $0x8,%esp
  801cc1:	68 00 00 00 82       	push   $0x82000000
  801cc6:	68 00 00 00 80       	push   $0x80000000
  801ccb:	e8 59 1f 00 00       	call   803c29 <initialize_dynamic_allocator>
  801cd0:	83 c4 10             	add    $0x10,%esp
		uheapPlaceStrategy = sys_get_uheap_strategy();
  801cd3:	e8 93 1d 00 00       	call   803a6b <sys_get_uheap_strategy>
  801cd8:	a3 60 e0 81 00       	mov    %eax,0x81e060
		uheapPageAllocStart = dynAllocEnd + PAGE_SIZE;
  801cdd:	a1 40 60 80 00       	mov    0x806040,%eax
  801ce2:	05 00 10 00 00       	add    $0x1000,%eax
  801ce7:	a3 10 e1 81 00       	mov    %eax,0x81e110
		uheapPageAllocBreak = uheapPageAllocStart;
  801cec:	a1 10 e1 81 00       	mov    0x81e110,%eax
  801cf1:	a3 68 e0 81 00       	mov    %eax,0x81e068
		init_uspinlock(&ulock,"malloc",1);
  801cf6:	83 ec 04             	sub    $0x4,%esp
  801cf9:	6a 01                	push   $0x1
  801cfb:	68 dc 51 80 00       	push   $0x8051dc
  801d00:	68 40 e1 81 00       	push   $0x81e140
  801d05:	e8 1a 29 00 00       	call   804624 <init_uspinlock>
  801d0a:	83 c4 10             	add    $0x10,%esp
		LIST_INIT(&u_freelist);
  801d0d:	c7 05 20 e1 81 00 00 	movl   $0x0,0x81e120
  801d14:	00 00 00 
  801d17:	c7 05 24 e1 81 00 00 	movl   $0x0,0x81e124
  801d1e:	00 00 00 
  801d21:	c7 05 2c e1 81 00 00 	movl   $0x0,0x81e12c
  801d28:	00 00 00 
		LIST_INIT(&u_allocatedlist);
  801d2b:	c7 05 30 e1 81 00 00 	movl   $0x0,0x81e130
  801d32:	00 00 00 
  801d35:	c7 05 34 e1 81 00 00 	movl   $0x0,0x81e134
  801d3c:	00 00 00 
  801d3f:	c7 05 3c e1 81 00 00 	movl   $0x0,0x81e13c
  801d46:	00 00 00 
		__firstTimeFlag = 0;
  801d49:	c7 05 08 60 80 00 00 	movl   $0x0,0x806008
  801d50:	00 00 00 
	}
}
  801d53:	90                   	nop
  801d54:	c9                   	leave  
  801d55:	c3                   	ret    

00801d56 <get_page>:

//==============================================
// [2] GET A PAGE FROM THE KERNEL FOR DA:
//==============================================
int get_page(void* va)
{
  801d56:	55                   	push   %ebp
  801d57:	89 e5                	mov    %esp,%ebp
  801d59:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_allocate_page(ROUNDDOWN(va, PAGE_SIZE), PERM_USER|PERM_WRITEABLE|PERM_UHPAGE);
  801d5c:	8b 45 08             	mov    0x8(%ebp),%eax
  801d5f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801d62:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d65:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801d6a:	83 ec 08             	sub    $0x8,%esp
  801d6d:	68 06 04 00 00       	push   $0x406
  801d72:	50                   	push   %eax
  801d73:	e8 3d 19 00 00       	call   8036b5 <__sys_allocate_page>
  801d78:	83 c4 10             	add    $0x10,%esp
  801d7b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  801d7e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801d82:	79 14                	jns    801d98 <get_page+0x42>
		panic("get_page() in user: failed to allocate page from the kernel");
  801d84:	83 ec 04             	sub    $0x4,%esp
  801d87:	68 e4 51 80 00       	push   $0x8051e4
  801d8c:	6a 2d                	push   $0x2d
  801d8e:	68 20 52 80 00       	push   $0x805220
  801d93:	e8 58 eb ff ff       	call   8008f0 <_panic>
	return 0;
  801d98:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d9d:	c9                   	leave  
  801d9e:	c3                   	ret    

00801d9f <return_page>:

//==============================================
// [3] RETURN A PAGE FROM THE DA TO KERNEL:
//==============================================
void return_page(void* va)
{
  801d9f:	55                   	push   %ebp
  801da0:	89 e5                	mov    %esp,%ebp
  801da2:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_unmap_frame(ROUNDDOWN((uint32)va, PAGE_SIZE));
  801da5:	8b 45 08             	mov    0x8(%ebp),%eax
  801da8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801dab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dae:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801db3:	83 ec 0c             	sub    $0xc,%esp
  801db6:	50                   	push   %eax
  801db7:	e8 40 19 00 00       	call   8036fc <__sys_unmap_frame>
  801dbc:	83 c4 10             	add    $0x10,%esp
  801dbf:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  801dc2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801dc6:	79 14                	jns    801ddc <return_page+0x3d>
		panic("return_page() in user: failed to return a page to the kernel");
  801dc8:	83 ec 04             	sub    $0x4,%esp
  801dcb:	68 2c 52 80 00       	push   $0x80522c
  801dd0:	6a 38                	push   $0x38
  801dd2:	68 20 52 80 00       	push   $0x805220
  801dd7:	e8 14 eb ff ff       	call   8008f0 <_panic>
}
  801ddc:	90                   	nop
  801ddd:	c9                   	leave  
  801dde:	c3                   	ret    

00801ddf <malloc>:

//=================================
// [1] ALLOCATE SPACE IN USER HEAP:
//=================================
void* malloc(uint32 size)
{
  801ddf:	55                   	push   %ebp
  801de0:	89 e5                	mov    %esp,%ebp
  801de2:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  801de5:	e8 c1 fe ff ff       	call   801cab <uheap_init>
	if (size == 0) return NULL ;
  801dea:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801dee:	75 0a                	jne    801dfa <malloc+0x1b>
  801df0:	b8 00 00 00 00       	mov    $0x0,%eax
  801df5:	e9 e1 04 00 00       	jmp    8022db <malloc+0x4fc>
	//==============================================================

	acquire_uspinlock(&ulock);
  801dfa:	83 ec 0c             	sub    $0xc,%esp
  801dfd:	68 40 e1 81 00       	push   $0x81e140
  801e02:	e8 6c 28 00 00       	call   804673 <acquire_uspinlock>
  801e07:	83 c4 10             	add    $0x10,%esp
	if(size <  DYN_ALLOC_MAX_BLOCK_SIZE){
  801e0a:	81 7d 08 ff 07 00 00 	cmpl   $0x7ff,0x8(%ebp)
  801e11:	77 23                	ja     801e36 <malloc+0x57>
		release_uspinlock(&ulock);
  801e13:	83 ec 0c             	sub    $0xc,%esp
  801e16:	68 40 e1 81 00       	push   $0x81e140
  801e1b:	e8 ab 28 00 00       	call   8046cb <release_uspinlock>
  801e20:	83 c4 10             	add    $0x10,%esp
		return alloc_block(size);
  801e23:	83 ec 0c             	sub    $0xc,%esp
  801e26:	ff 75 08             	pushl  0x8(%ebp)
  801e29:	e8 dd 1f 00 00       	call   803e0b <alloc_block>
  801e2e:	83 c4 10             	add    $0x10,%esp
  801e31:	e9 a5 04 00 00       	jmp    8022db <malloc+0x4fc>
	}

	struct UserHeapStruct* allocblock= (struct UserHeapStruct*) alloc_block(sizeof(struct UserHeapStruct));
  801e36:	83 ec 0c             	sub    $0xc,%esp
  801e39:	6a 10                	push   $0x10
  801e3b:	e8 cb 1f 00 00       	call   803e0b <alloc_block>
  801e40:	83 c4 10             	add    $0x10,%esp
  801e43:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (allocblock == NULL){
  801e46:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801e4a:	75 0a                	jne    801e56 <malloc+0x77>
			return NULL;
  801e4c:	b8 00 00 00 00       	mov    $0x0,%eax
  801e51:	e9 85 04 00 00       	jmp    8022db <malloc+0x4fc>
	}

	size = ROUNDUP(size,PAGE_SIZE);
  801e56:	c7 45 e8 00 10 00 00 	movl   $0x1000,-0x18(%ebp)
  801e5d:	8b 55 08             	mov    0x8(%ebp),%edx
  801e60:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801e63:	01 d0                	add    %edx,%eax
  801e65:	48                   	dec    %eax
  801e66:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801e69:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801e6c:	ba 00 00 00 00       	mov    $0x0,%edx
  801e71:	f7 75 e8             	divl   -0x18(%ebp)
  801e74:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801e77:	29 d0                	sub    %edx,%eax
  801e79:	89 45 08             	mov    %eax,0x8(%ebp)
	struct UserHeapStruct* lastfreeelement = LIST_LAST(&u_freelist);
  801e7c:	a1 24 e1 81 00       	mov    0x81e124,%eax
  801e81:	89 45 e0             	mov    %eax,-0x20(%ebp)

	if(LIST_SIZE(&u_freelist)==0 || size>lastfreeelement->size){
  801e84:	a1 2c e1 81 00       	mov    0x81e12c,%eax
  801e89:	85 c0                	test   %eax,%eax
  801e8b:	74 0f                	je     801e9c <malloc+0xbd>
  801e8d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801e90:	8b 40 04             	mov    0x4(%eax),%eax
  801e93:	3b 45 08             	cmp    0x8(%ebp),%eax
  801e96:	0f 83 ea 00 00 00    	jae    801f86 <malloc+0x1a7>
			if(uheapPageAllocBreak < USER_HEAP_MAX - size){
  801e9c:	b8 00 00 00 a0       	mov    $0xa0000000,%eax
  801ea1:	2b 45 08             	sub    0x8(%ebp),%eax
  801ea4:	89 c2                	mov    %eax,%edx
  801ea6:	a1 68 e0 81 00       	mov    0x81e068,%eax
  801eab:	39 c2                	cmp    %eax,%edx
  801ead:	0f 86 b9 00 00 00    	jbe    801f6c <malloc+0x18d>
					uint32 requestedblockva = uheapPageAllocBreak;
  801eb3:	a1 68 e0 81 00       	mov    0x81e068,%eax
  801eb8:	89 45 dc             	mov    %eax,-0x24(%ebp)
					uheapPageAllocBreak+=size;
  801ebb:	8b 15 68 e0 81 00    	mov    0x81e068,%edx
  801ec1:	8b 45 08             	mov    0x8(%ebp),%eax
  801ec4:	01 d0                	add    %edx,%eax
  801ec6:	a3 68 e0 81 00       	mov    %eax,0x81e068
					allocblock->startva = requestedblockva;
  801ecb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801ece:	8b 55 dc             	mov    -0x24(%ebp),%edx
  801ed1:	89 10                	mov    %edx,(%eax)
					allocblock->size = size;
  801ed3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801ed6:	8b 55 08             	mov    0x8(%ebp),%edx
  801ed9:	89 50 04             	mov    %edx,0x4(%eax)

					LIST_INSERT_TAIL(&u_allocatedlist, allocblock);
  801edc:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801ee0:	75 14                	jne    801ef6 <malloc+0x117>
  801ee2:	83 ec 04             	sub    $0x4,%esp
  801ee5:	68 6c 52 80 00       	push   $0x80526c
  801eea:	6a 60                	push   $0x60
  801eec:	68 20 52 80 00       	push   $0x805220
  801ef1:	e8 fa e9 ff ff       	call   8008f0 <_panic>
  801ef6:	8b 15 34 e1 81 00    	mov    0x81e134,%edx
  801efc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801eff:	89 50 0c             	mov    %edx,0xc(%eax)
  801f02:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f05:	8b 40 0c             	mov    0xc(%eax),%eax
  801f08:	85 c0                	test   %eax,%eax
  801f0a:	74 0d                	je     801f19 <malloc+0x13a>
  801f0c:	a1 34 e1 81 00       	mov    0x81e134,%eax
  801f11:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801f14:	89 50 08             	mov    %edx,0x8(%eax)
  801f17:	eb 08                	jmp    801f21 <malloc+0x142>
  801f19:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f1c:	a3 30 e1 81 00       	mov    %eax,0x81e130
  801f21:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f24:	a3 34 e1 81 00       	mov    %eax,0x81e134
  801f29:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f2c:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  801f33:	a1 3c e1 81 00       	mov    0x81e13c,%eax
  801f38:	40                   	inc    %eax
  801f39:	a3 3c e1 81 00       	mov    %eax,0x81e13c


					sys_allocate_user_mem(allocblock->startva ,size);
  801f3e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f41:	8b 00                	mov    (%eax),%eax
  801f43:	83 ec 08             	sub    $0x8,%esp
  801f46:	ff 75 08             	pushl  0x8(%ebp)
  801f49:	50                   	push   %eax
  801f4a:	e8 34 1c 00 00       	call   803b83 <sys_allocate_user_mem>
  801f4f:	83 c4 10             	add    $0x10,%esp
					release_uspinlock(&ulock);
  801f52:	83 ec 0c             	sub    $0xc,%esp
  801f55:	68 40 e1 81 00       	push   $0x81e140
  801f5a:	e8 6c 27 00 00       	call   8046cb <release_uspinlock>
  801f5f:	83 c4 10             	add    $0x10,%esp
					return (void*)allocblock->startva;
  801f62:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f65:	8b 00                	mov    (%eax),%eax
  801f67:	e9 6f 03 00 00       	jmp    8022db <malloc+0x4fc>
			}else{
					release_uspinlock(&ulock);
  801f6c:	83 ec 0c             	sub    $0xc,%esp
  801f6f:	68 40 e1 81 00       	push   $0x81e140
  801f74:	e8 52 27 00 00       	call   8046cb <release_uspinlock>
  801f79:	83 c4 10             	add    $0x10,%esp
					return NULL;
  801f7c:	b8 00 00 00 00       	mov    $0x0,%eax
  801f81:	e9 55 03 00 00       	jmp    8022db <malloc+0x4fc>
				}
	}else{
		//custom fit
		struct UserHeapStruct* currentfreeelement = LIST_FIRST(&u_freelist);
  801f86:	a1 20 e1 81 00       	mov    0x81e120,%eax
  801f8b:	89 45 f4             	mov    %eax,-0xc(%ebp)
		//worst fit
		while(currentfreeelement != NULL){
  801f8e:	e9 39 03 00 00       	jmp    8022cc <malloc+0x4ed>
			if(size<currentfreeelement->size){
  801f93:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f96:	8b 40 04             	mov    0x4(%eax),%eax
  801f99:	3b 45 08             	cmp    0x8(%ebp),%eax
  801f9c:	0f 86 e7 01 00 00    	jbe    802189 <malloc+0x3aa>
				allocblock->startva = lastfreeelement->startva;
  801fa2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801fa5:	8b 10                	mov    (%eax),%edx
  801fa7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801faa:	89 10                	mov    %edx,(%eax)
                allocblock->size = size;
  801fac:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801faf:	8b 55 08             	mov    0x8(%ebp),%edx
  801fb2:	89 50 04             	mov    %edx,0x4(%eax)
                LIST_INSERT_TAIL(&u_allocatedlist,allocblock);
  801fb5:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801fb9:	75 14                	jne    801fcf <malloc+0x1f0>
  801fbb:	83 ec 04             	sub    $0x4,%esp
  801fbe:	68 6c 52 80 00       	push   $0x80526c
  801fc3:	6a 72                	push   $0x72
  801fc5:	68 20 52 80 00       	push   $0x805220
  801fca:	e8 21 e9 ff ff       	call   8008f0 <_panic>
  801fcf:	8b 15 34 e1 81 00    	mov    0x81e134,%edx
  801fd5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801fd8:	89 50 0c             	mov    %edx,0xc(%eax)
  801fdb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801fde:	8b 40 0c             	mov    0xc(%eax),%eax
  801fe1:	85 c0                	test   %eax,%eax
  801fe3:	74 0d                	je     801ff2 <malloc+0x213>
  801fe5:	a1 34 e1 81 00       	mov    0x81e134,%eax
  801fea:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801fed:	89 50 08             	mov    %edx,0x8(%eax)
  801ff0:	eb 08                	jmp    801ffa <malloc+0x21b>
  801ff2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801ff5:	a3 30 e1 81 00       	mov    %eax,0x81e130
  801ffa:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801ffd:	a3 34 e1 81 00       	mov    %eax,0x81e134
  802002:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802005:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  80200c:	a1 3c e1 81 00       	mov    0x81e13c,%eax
  802011:	40                   	inc    %eax
  802012:	a3 3c e1 81 00       	mov    %eax,0x81e13c
                lastfreeelement->startva += size;
  802017:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80201a:	8b 10                	mov    (%eax),%edx
  80201c:	8b 45 08             	mov    0x8(%ebp),%eax
  80201f:	01 c2                	add    %eax,%edx
  802021:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802024:	89 10                	mov    %edx,(%eax)
                lastfreeelement->size -= size;
  802026:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802029:	8b 40 04             	mov    0x4(%eax),%eax
  80202c:	2b 45 08             	sub    0x8(%ebp),%eax
  80202f:	89 c2                	mov    %eax,%edx
  802031:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802034:	89 50 04             	mov    %edx,0x4(%eax)
                struct UserHeapStruct* currentfree2 = LIST_FIRST(&u_freelist);
  802037:	a1 20 e1 81 00       	mov    0x81e120,%eax
  80203c:	89 45 f0             	mov    %eax,-0x10(%ebp)
                //check order of last element

                while (currentfree2 != NULL){
  80203f:	e9 0d 01 00 00       	jmp    802151 <malloc+0x372>
                	if(lastfreeelement->size <currentfree2->size){
  802044:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802047:	8b 50 04             	mov    0x4(%eax),%edx
  80204a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80204d:	8b 40 04             	mov    0x4(%eax),%eax
  802050:	39 c2                	cmp    %eax,%edx
  802052:	0f 83 f0 00 00 00    	jae    802148 <malloc+0x369>
                		LIST_REMOVE(&u_freelist ,lastfreeelement);
  802058:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80205c:	75 14                	jne    802072 <malloc+0x293>
  80205e:	83 ec 04             	sub    $0x4,%esp
  802061:	68 8f 52 80 00       	push   $0x80528f
  802066:	6a 7a                	push   $0x7a
  802068:	68 20 52 80 00       	push   $0x805220
  80206d:	e8 7e e8 ff ff       	call   8008f0 <_panic>
  802072:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802075:	8b 40 08             	mov    0x8(%eax),%eax
  802078:	85 c0                	test   %eax,%eax
  80207a:	74 11                	je     80208d <malloc+0x2ae>
  80207c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80207f:	8b 40 08             	mov    0x8(%eax),%eax
  802082:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802085:	8b 52 0c             	mov    0xc(%edx),%edx
  802088:	89 50 0c             	mov    %edx,0xc(%eax)
  80208b:	eb 0b                	jmp    802098 <malloc+0x2b9>
  80208d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802090:	8b 40 0c             	mov    0xc(%eax),%eax
  802093:	a3 24 e1 81 00       	mov    %eax,0x81e124
  802098:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80209b:	8b 40 0c             	mov    0xc(%eax),%eax
  80209e:	85 c0                	test   %eax,%eax
  8020a0:	74 11                	je     8020b3 <malloc+0x2d4>
  8020a2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8020a5:	8b 40 0c             	mov    0xc(%eax),%eax
  8020a8:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8020ab:	8b 52 08             	mov    0x8(%edx),%edx
  8020ae:	89 50 08             	mov    %edx,0x8(%eax)
  8020b1:	eb 0b                	jmp    8020be <malloc+0x2df>
  8020b3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8020b6:	8b 40 08             	mov    0x8(%eax),%eax
  8020b9:	a3 20 e1 81 00       	mov    %eax,0x81e120
  8020be:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8020c1:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  8020c8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8020cb:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  8020d2:	a1 2c e1 81 00       	mov    0x81e12c,%eax
  8020d7:	48                   	dec    %eax
  8020d8:	a3 2c e1 81 00       	mov    %eax,0x81e12c
                		LIST_INSERT_BEFORE(&u_freelist ,currentfree2 ,lastfreeelement);
  8020dd:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8020e1:	74 06                	je     8020e9 <malloc+0x30a>
  8020e3:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8020e7:	75 14                	jne    8020fd <malloc+0x31e>
  8020e9:	83 ec 04             	sub    $0x4,%esp
  8020ec:	68 b0 52 80 00       	push   $0x8052b0
  8020f1:	6a 7b                	push   $0x7b
  8020f3:	68 20 52 80 00       	push   $0x805220
  8020f8:	e8 f3 e7 ff ff       	call   8008f0 <_panic>
  8020fd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802100:	8b 50 0c             	mov    0xc(%eax),%edx
  802103:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802106:	89 50 0c             	mov    %edx,0xc(%eax)
  802109:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80210c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80210f:	89 50 08             	mov    %edx,0x8(%eax)
  802112:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802115:	8b 40 0c             	mov    0xc(%eax),%eax
  802118:	85 c0                	test   %eax,%eax
  80211a:	74 0e                	je     80212a <malloc+0x34b>
  80211c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80211f:	8b 40 0c             	mov    0xc(%eax),%eax
  802122:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802125:	89 50 08             	mov    %edx,0x8(%eax)
  802128:	eb 08                	jmp    802132 <malloc+0x353>
  80212a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80212d:	a3 20 e1 81 00       	mov    %eax,0x81e120
  802132:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802135:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802138:	89 50 0c             	mov    %edx,0xc(%eax)
  80213b:	a1 2c e1 81 00       	mov    0x81e12c,%eax
  802140:	40                   	inc    %eax
  802141:	a3 2c e1 81 00       	mov    %eax,0x81e12c
                		break;
  802146:	eb 13                	jmp    80215b <malloc+0x37c>
                	}
                	currentfree2 = currentfree2->prev_next_info.le_next;
  802148:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80214b:	8b 40 08             	mov    0x8(%eax),%eax
  80214e:	89 45 f0             	mov    %eax,-0x10(%ebp)
                lastfreeelement->startva += size;
                lastfreeelement->size -= size;
                struct UserHeapStruct* currentfree2 = LIST_FIRST(&u_freelist);
                //check order of last element

                while (currentfree2 != NULL){
  802151:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802155:	0f 85 e9 fe ff ff    	jne    802044 <malloc+0x265>
                	}
                	currentfree2 = currentfree2->prev_next_info.le_next;
                }


                sys_allocate_user_mem(allocblock->startva ,size);
  80215b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80215e:	8b 00                	mov    (%eax),%eax
  802160:	83 ec 08             	sub    $0x8,%esp
  802163:	ff 75 08             	pushl  0x8(%ebp)
  802166:	50                   	push   %eax
  802167:	e8 17 1a 00 00       	call   803b83 <sys_allocate_user_mem>
  80216c:	83 c4 10             	add    $0x10,%esp
                release_uspinlock(&ulock);
  80216f:	83 ec 0c             	sub    $0xc,%esp
  802172:	68 40 e1 81 00       	push   $0x81e140
  802177:	e8 4f 25 00 00       	call   8046cb <release_uspinlock>
  80217c:	83 c4 10             	add    $0x10,%esp
                return (void*)allocblock->startva;
  80217f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802182:	8b 00                	mov    (%eax),%eax
  802184:	e9 52 01 00 00       	jmp    8022db <malloc+0x4fc>
                //exact fit
			}else if(size == currentfreeelement->size){
  802189:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80218c:	8b 40 04             	mov    0x4(%eax),%eax
  80218f:	3b 45 08             	cmp    0x8(%ebp),%eax
  802192:	0f 85 2b 01 00 00    	jne    8022c3 <malloc+0x4e4>
				allocblock->startva = currentfreeelement->startva;
  802198:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80219b:	8b 10                	mov    (%eax),%edx
  80219d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8021a0:	89 10                	mov    %edx,(%eax)
				allocblock->size = size;
  8021a2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8021a5:	8b 55 08             	mov    0x8(%ebp),%edx
  8021a8:	89 50 04             	mov    %edx,0x4(%eax)
				LIST_INSERT_TAIL(&u_allocatedlist ,allocblock);
  8021ab:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8021af:	75 17                	jne    8021c8 <malloc+0x3e9>
  8021b1:	83 ec 04             	sub    $0x4,%esp
  8021b4:	68 6c 52 80 00       	push   $0x80526c
  8021b9:	68 89 00 00 00       	push   $0x89
  8021be:	68 20 52 80 00       	push   $0x805220
  8021c3:	e8 28 e7 ff ff       	call   8008f0 <_panic>
  8021c8:	8b 15 34 e1 81 00    	mov    0x81e134,%edx
  8021ce:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8021d1:	89 50 0c             	mov    %edx,0xc(%eax)
  8021d4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8021d7:	8b 40 0c             	mov    0xc(%eax),%eax
  8021da:	85 c0                	test   %eax,%eax
  8021dc:	74 0d                	je     8021eb <malloc+0x40c>
  8021de:	a1 34 e1 81 00       	mov    0x81e134,%eax
  8021e3:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8021e6:	89 50 08             	mov    %edx,0x8(%eax)
  8021e9:	eb 08                	jmp    8021f3 <malloc+0x414>
  8021eb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8021ee:	a3 30 e1 81 00       	mov    %eax,0x81e130
  8021f3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8021f6:	a3 34 e1 81 00       	mov    %eax,0x81e134
  8021fb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8021fe:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802205:	a1 3c e1 81 00       	mov    0x81e13c,%eax
  80220a:	40                   	inc    %eax
  80220b:	a3 3c e1 81 00       	mov    %eax,0x81e13c
				LIST_REMOVE(&u_freelist ,currentfreeelement);
  802210:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802214:	75 17                	jne    80222d <malloc+0x44e>
  802216:	83 ec 04             	sub    $0x4,%esp
  802219:	68 8f 52 80 00       	push   $0x80528f
  80221e:	68 8a 00 00 00       	push   $0x8a
  802223:	68 20 52 80 00       	push   $0x805220
  802228:	e8 c3 e6 ff ff       	call   8008f0 <_panic>
  80222d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802230:	8b 40 08             	mov    0x8(%eax),%eax
  802233:	85 c0                	test   %eax,%eax
  802235:	74 11                	je     802248 <malloc+0x469>
  802237:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80223a:	8b 40 08             	mov    0x8(%eax),%eax
  80223d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802240:	8b 52 0c             	mov    0xc(%edx),%edx
  802243:	89 50 0c             	mov    %edx,0xc(%eax)
  802246:	eb 0b                	jmp    802253 <malloc+0x474>
  802248:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80224b:	8b 40 0c             	mov    0xc(%eax),%eax
  80224e:	a3 24 e1 81 00       	mov    %eax,0x81e124
  802253:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802256:	8b 40 0c             	mov    0xc(%eax),%eax
  802259:	85 c0                	test   %eax,%eax
  80225b:	74 11                	je     80226e <malloc+0x48f>
  80225d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802260:	8b 40 0c             	mov    0xc(%eax),%eax
  802263:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802266:	8b 52 08             	mov    0x8(%edx),%edx
  802269:	89 50 08             	mov    %edx,0x8(%eax)
  80226c:	eb 0b                	jmp    802279 <malloc+0x49a>
  80226e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802271:	8b 40 08             	mov    0x8(%eax),%eax
  802274:	a3 20 e1 81 00       	mov    %eax,0x81e120
  802279:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80227c:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802283:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802286:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  80228d:	a1 2c e1 81 00       	mov    0x81e12c,%eax
  802292:	48                   	dec    %eax
  802293:	a3 2c e1 81 00       	mov    %eax,0x81e12c
				sys_allocate_user_mem(allocblock->startva ,size);
  802298:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80229b:	8b 00                	mov    (%eax),%eax
  80229d:	83 ec 08             	sub    $0x8,%esp
  8022a0:	ff 75 08             	pushl  0x8(%ebp)
  8022a3:	50                   	push   %eax
  8022a4:	e8 da 18 00 00       	call   803b83 <sys_allocate_user_mem>
  8022a9:	83 c4 10             	add    $0x10,%esp
				release_uspinlock(&ulock);
  8022ac:	83 ec 0c             	sub    $0xc,%esp
  8022af:	68 40 e1 81 00       	push   $0x81e140
  8022b4:	e8 12 24 00 00       	call   8046cb <release_uspinlock>
  8022b9:	83 c4 10             	add    $0x10,%esp
				return (void*)allocblock->startva;
  8022bc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8022bf:	8b 00                	mov    (%eax),%eax
  8022c1:	eb 18                	jmp    8022db <malloc+0x4fc>
			}
			currentfreeelement = currentfreeelement->prev_next_info.le_next;
  8022c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022c6:	8b 40 08             	mov    0x8(%eax),%eax
  8022c9:	89 45 f4             	mov    %eax,-0xc(%ebp)
				}
	}else{
		//custom fit
		struct UserHeapStruct* currentfreeelement = LIST_FIRST(&u_freelist);
		//worst fit
		while(currentfreeelement != NULL){
  8022cc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8022d0:	0f 85 bd fc ff ff    	jne    801f93 <malloc+0x1b4>
				return (void*)allocblock->startva;
			}
			currentfreeelement = currentfreeelement->prev_next_info.le_next;
		}
	}
	 return NULL;
  8022d6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8022db:	c9                   	leave  
  8022dc:	c3                   	ret    

008022dd <free>:

//=================================
// [2] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
  8022dd:	55                   	push   %ebp
  8022de:	89 e5                	mov    %esp,%ebp
  8022e0:	83 ec 38             	sub    $0x38,%esp
	uint32  VA = ROUNDDOWN(((uint32 ) virtual_address), PAGE_SIZE);
  8022e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8022e6:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8022e9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8022ec:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8022f1:	89 45 d8             	mov    %eax,-0x28(%ebp)


		uheap_init();
  8022f4:	e8 b2 f9 ff ff       	call   801cab <uheap_init>
		acquire_uspinlock(&ulock);
  8022f9:	83 ec 0c             	sub    $0xc,%esp
  8022fc:	68 40 e1 81 00       	push   $0x81e140
  802301:	e8 6d 23 00 00       	call   804673 <acquire_uspinlock>
  802306:	83 c4 10             	add    $0x10,%esp
		if (VA < uheapPageAllocStart){
  802309:	a1 10 e1 81 00       	mov    0x81e110,%eax
  80230e:	39 45 d8             	cmp    %eax,-0x28(%ebp)
  802311:	73 23                	jae    802336 <free+0x59>
			free_block(virtual_address);
  802313:	83 ec 0c             	sub    $0xc,%esp
  802316:	ff 75 08             	pushl  0x8(%ebp)
  802319:	e8 89 1f 00 00       	call   8042a7 <free_block>
  80231e:	83 c4 10             	add    $0x10,%esp
			release_uspinlock(&ulock);
  802321:	83 ec 0c             	sub    $0xc,%esp
  802324:	68 40 e1 81 00       	push   $0x81e140
  802329:	e8 9d 23 00 00       	call   8046cb <release_uspinlock>
  80232e:	83 c4 10             	add    $0x10,%esp
			return;
  802331:	e9 35 07 00 00       	jmp    802a6b <free+0x78e>
		}
		if (VA >= uheapPageAllocBreak){
  802336:	a1 68 e0 81 00       	mov    0x81e068,%eax
  80233b:	39 45 d8             	cmp    %eax,-0x28(%ebp)
  80233e:	72 30                	jb     802370 <free+0x93>
			cprintf("%d\n %d\n", VA, uheapPageAllocBreak);
  802340:	a1 68 e0 81 00       	mov    0x81e068,%eax
  802345:	83 ec 04             	sub    $0x4,%esp
  802348:	50                   	push   %eax
  802349:	ff 75 d8             	pushl  -0x28(%ebp)
  80234c:	68 e5 52 80 00       	push   $0x8052e5
  802351:	e8 68 e8 ff ff       	call   800bbe <cprintf>
  802356:	83 c4 10             	add    $0x10,%esp

			panic("freeing from restricted area");
  802359:	83 ec 04             	sub    $0x4,%esp
  80235c:	68 ed 52 80 00       	push   $0x8052ed
  802361:	68 a7 00 00 00       	push   $0xa7
  802366:	68 20 52 80 00       	push   $0x805220
  80236b:	e8 80 e5 ff ff       	call   8008f0 <_panic>
			release_uspinlock(&ulock);
			return;
		}

		struct UserHeapStruct* newfree = (struct UserHeapStruct*) alloc_block(sizeof(struct UserHeapStruct));
  802370:	83 ec 0c             	sub    $0xc,%esp
  802373:	6a 10                	push   $0x10
  802375:	e8 91 1a 00 00       	call   803e0b <alloc_block>
  80237a:	83 c4 10             	add    $0x10,%esp
  80237d:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		struct UserHeapStruct* MergedBlock  = ( struct UserHeapStruct*)alloc_block(sizeof(struct UserHeapStruct));
  802380:	83 ec 0c             	sub    $0xc,%esp
  802383:	6a 10                	push   $0x10
  802385:	e8 81 1a 00 00       	call   803e0b <alloc_block>
  80238a:	83 c4 10             	add    $0x10,%esp
  80238d:	89 45 d0             	mov    %eax,-0x30(%ebp)

		struct UserHeapStruct* ToBefreed = LIST_FIRST(&u_allocatedlist);
  802390:	a1 30 e1 81 00       	mov    0x81e130,%eax
  802395:	89 45 f4             	mov    %eax,-0xc(%ebp)
		bool foundVA = 0;
  802398:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

		//find the allocated block
		while(ToBefreed !=NULL ){
  80239f:	eb 1c                	jmp    8023bd <free+0xe0>

			if (VA ==ToBefreed->startva ){
  8023a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023a4:	8b 00                	mov    (%eax),%eax
  8023a6:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  8023a9:	75 09                	jne    8023b4 <free+0xd7>
				foundVA = 1;
  8023ab:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
				break;
  8023b2:	eb 0f                	jmp    8023c3 <free+0xe6>
			}
				ToBefreed = ToBefreed->prev_next_info.le_next;
  8023b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023b7:	8b 40 08             	mov    0x8(%eax),%eax
  8023ba:	89 45 f4             	mov    %eax,-0xc(%ebp)

		struct UserHeapStruct* ToBefreed = LIST_FIRST(&u_allocatedlist);
		bool foundVA = 0;

		//find the allocated block
		while(ToBefreed !=NULL ){
  8023bd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023c1:	75 de                	jne    8023a1 <free+0xc4>
			}
				ToBefreed = ToBefreed->prev_next_info.le_next;
		}


		if(!foundVA){
  8023c3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8023c7:	75 17                	jne    8023e0 <free+0x103>
				panic("INVALID ADDRESS!");
  8023c9:	83 ec 04             	sub    $0x4,%esp
  8023cc:	68 0a 53 80 00       	push   $0x80530a
  8023d1:	68 be 00 00 00       	push   $0xbe
  8023d6:	68 20 52 80 00       	push   $0x805220
  8023db:	e8 10 e5 ff ff       	call   8008f0 <_panic>
				release_uspinlock(&ulock);
				return;
			}


		newfree->startva = ToBefreed->startva;
  8023e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023e3:	8b 10                	mov    (%eax),%edx
  8023e5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8023e8:	89 10                	mov    %edx,(%eax)
		newfree->size = ToBefreed->size;
  8023ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023ed:	8b 50 04             	mov    0x4(%eax),%edx
  8023f0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8023f3:	89 50 04             	mov    %edx,0x4(%eax)

		//remove allocated block from alloclist
		LIST_REMOVE(&u_allocatedlist, ToBefreed);
  8023f6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023fa:	75 17                	jne    802413 <free+0x136>
  8023fc:	83 ec 04             	sub    $0x4,%esp
  8023ff:	68 8f 52 80 00       	push   $0x80528f
  802404:	68 c8 00 00 00       	push   $0xc8
  802409:	68 20 52 80 00       	push   $0x805220
  80240e:	e8 dd e4 ff ff       	call   8008f0 <_panic>
  802413:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802416:	8b 40 08             	mov    0x8(%eax),%eax
  802419:	85 c0                	test   %eax,%eax
  80241b:	74 11                	je     80242e <free+0x151>
  80241d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802420:	8b 40 08             	mov    0x8(%eax),%eax
  802423:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802426:	8b 52 0c             	mov    0xc(%edx),%edx
  802429:	89 50 0c             	mov    %edx,0xc(%eax)
  80242c:	eb 0b                	jmp    802439 <free+0x15c>
  80242e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802431:	8b 40 0c             	mov    0xc(%eax),%eax
  802434:	a3 34 e1 81 00       	mov    %eax,0x81e134
  802439:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80243c:	8b 40 0c             	mov    0xc(%eax),%eax
  80243f:	85 c0                	test   %eax,%eax
  802441:	74 11                	je     802454 <free+0x177>
  802443:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802446:	8b 40 0c             	mov    0xc(%eax),%eax
  802449:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80244c:	8b 52 08             	mov    0x8(%edx),%edx
  80244f:	89 50 08             	mov    %edx,0x8(%eax)
  802452:	eb 0b                	jmp    80245f <free+0x182>
  802454:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802457:	8b 40 08             	mov    0x8(%eax),%eax
  80245a:	a3 30 e1 81 00       	mov    %eax,0x81e130
  80245f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802462:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802469:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80246c:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  802473:	a1 3c e1 81 00       	mov    0x81e13c,%eax
  802478:	48                   	dec    %eax
  802479:	a3 3c e1 81 00       	mov    %eax,0x81e13c

		sys_free_user_mem(ToBefreed->startva, ToBefreed->size);
  80247e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802481:	8b 50 04             	mov    0x4(%eax),%edx
  802484:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802487:	8b 00                	mov    (%eax),%eax
  802489:	83 ec 08             	sub    $0x8,%esp
  80248c:	52                   	push   %edx
  80248d:	50                   	push   %eax
  80248e:	e8 d4 16 00 00       	call   803b67 <sys_free_user_mem>
  802493:	83 c4 10             	add    $0x10,%esp




		if(LIST_SIZE(&u_freelist) == 0){
  802496:	a1 2c e1 81 00       	mov    0x81e12c,%eax
  80249b:	85 c0                	test   %eax,%eax
  80249d:	75 7a                	jne    802519 <free+0x23c>
			LIST_INSERT_HEAD(&u_freelist,newfree);
  80249f:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8024a3:	75 17                	jne    8024bc <free+0x1df>
  8024a5:	83 ec 04             	sub    $0x4,%esp
  8024a8:	68 1c 53 80 00       	push   $0x80531c
  8024ad:	68 d0 00 00 00       	push   $0xd0
  8024b2:	68 20 52 80 00       	push   $0x805220
  8024b7:	e8 34 e4 ff ff       	call   8008f0 <_panic>
  8024bc:	8b 15 20 e1 81 00    	mov    0x81e120,%edx
  8024c2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8024c5:	89 50 08             	mov    %edx,0x8(%eax)
  8024c8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8024cb:	8b 40 08             	mov    0x8(%eax),%eax
  8024ce:	85 c0                	test   %eax,%eax
  8024d0:	74 0d                	je     8024df <free+0x202>
  8024d2:	a1 20 e1 81 00       	mov    0x81e120,%eax
  8024d7:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8024da:	89 50 0c             	mov    %edx,0xc(%eax)
  8024dd:	eb 08                	jmp    8024e7 <free+0x20a>
  8024df:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8024e2:	a3 24 e1 81 00       	mov    %eax,0x81e124
  8024e7:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8024ea:	a3 20 e1 81 00       	mov    %eax,0x81e120
  8024ef:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8024f2:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  8024f9:	a1 2c e1 81 00       	mov    0x81e12c,%eax
  8024fe:	40                   	inc    %eax
  8024ff:	a3 2c e1 81 00       	mov    %eax,0x81e12c
			release_uspinlock(&ulock);
  802504:	83 ec 0c             	sub    $0xc,%esp
  802507:	68 40 e1 81 00       	push   $0x81e140
  80250c:	e8 ba 21 00 00       	call   8046cb <release_uspinlock>
  802511:	83 c4 10             	add    $0x10,%esp
			return;
  802514:	e9 52 05 00 00       	jmp    802a6b <free+0x78e>
		}


		struct UserHeapStruct* ToBeMerged = LIST_FIRST(&u_freelist);
  802519:	a1 20 e1 81 00       	mov    0x81e120,%eax
  80251e:	89 45 ec             	mov    %eax,-0x14(%ebp)
		// merge with prev if possible
		bool mergeprev = 0;
  802521:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		bool mergenext = 0;
  802528:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
		while(ToBeMerged != NULL){
  80252f:	e9 d2 00 00 00       	jmp    802606 <free+0x329>
			if((ToBeMerged->startva +ToBeMerged->size) == newfree->startva){
  802534:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802537:	8b 10                	mov    (%eax),%edx
  802539:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80253c:	8b 40 04             	mov    0x4(%eax),%eax
  80253f:	01 c2                	add    %eax,%edx
  802541:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802544:	8b 00                	mov    (%eax),%eax
  802546:	39 c2                	cmp    %eax,%edx
  802548:	0f 85 af 00 00 00    	jne    8025fd <free+0x320>

				MergedBlock->startva = ToBeMerged->startva;
  80254e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802551:	8b 10                	mov    (%eax),%edx
  802553:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802556:	89 10                	mov    %edx,(%eax)
				MergedBlock->size = ToBeMerged->size + newfree->size;
  802558:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80255b:	8b 50 04             	mov    0x4(%eax),%edx
  80255e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802561:	8b 40 04             	mov    0x4(%eax),%eax
  802564:	01 c2                	add    %eax,%edx
  802566:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802569:	89 50 04             	mov    %edx,0x4(%eax)
				LIST_REMOVE(&u_freelist, ToBeMerged);
  80256c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802570:	75 17                	jne    802589 <free+0x2ac>
  802572:	83 ec 04             	sub    $0x4,%esp
  802575:	68 8f 52 80 00       	push   $0x80528f
  80257a:	68 df 00 00 00       	push   $0xdf
  80257f:	68 20 52 80 00       	push   $0x805220
  802584:	e8 67 e3 ff ff       	call   8008f0 <_panic>
  802589:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80258c:	8b 40 08             	mov    0x8(%eax),%eax
  80258f:	85 c0                	test   %eax,%eax
  802591:	74 11                	je     8025a4 <free+0x2c7>
  802593:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802596:	8b 40 08             	mov    0x8(%eax),%eax
  802599:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80259c:	8b 52 0c             	mov    0xc(%edx),%edx
  80259f:	89 50 0c             	mov    %edx,0xc(%eax)
  8025a2:	eb 0b                	jmp    8025af <free+0x2d2>
  8025a4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025a7:	8b 40 0c             	mov    0xc(%eax),%eax
  8025aa:	a3 24 e1 81 00       	mov    %eax,0x81e124
  8025af:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025b2:	8b 40 0c             	mov    0xc(%eax),%eax
  8025b5:	85 c0                	test   %eax,%eax
  8025b7:	74 11                	je     8025ca <free+0x2ed>
  8025b9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025bc:	8b 40 0c             	mov    0xc(%eax),%eax
  8025bf:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8025c2:	8b 52 08             	mov    0x8(%edx),%edx
  8025c5:	89 50 08             	mov    %edx,0x8(%eax)
  8025c8:	eb 0b                	jmp    8025d5 <free+0x2f8>
  8025ca:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025cd:	8b 40 08             	mov    0x8(%eax),%eax
  8025d0:	a3 20 e1 81 00       	mov    %eax,0x81e120
  8025d5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025d8:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  8025df:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025e2:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  8025e9:	a1 2c e1 81 00       	mov    0x81e12c,%eax
  8025ee:	48                   	dec    %eax
  8025ef:	a3 2c e1 81 00       	mov    %eax,0x81e12c
				mergeprev = 1;
  8025f4:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
				break;
  8025fb:	eb 13                	jmp    802610 <free+0x333>
			}
				ToBeMerged = ToBeMerged->prev_next_info.le_next;
  8025fd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802600:	8b 40 08             	mov    0x8(%eax),%eax
  802603:	89 45 ec             	mov    %eax,-0x14(%ebp)

		struct UserHeapStruct* ToBeMerged = LIST_FIRST(&u_freelist);
		// merge with prev if possible
		bool mergeprev = 0;
		bool mergenext = 0;
		while(ToBeMerged != NULL){
  802606:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80260a:	0f 85 24 ff ff ff    	jne    802534 <free+0x257>
//									uheapPageAllocBreak = newfree->startva;
//						}
//					}


		if ( newfree ->startva + newfree->size == uheapPageAllocBreak){
  802610:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802613:	8b 10                	mov    (%eax),%edx
  802615:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802618:	8b 40 04             	mov    0x4(%eax),%eax
  80261b:	01 c2                	add    %eax,%edx
  80261d:	a1 68 e0 81 00       	mov    0x81e068,%eax
  802622:	39 c2                	cmp    %eax,%edx
  802624:	75 44                	jne    80266a <free+0x38d>

			if(mergeprev){
  802626:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80262a:	74 1f                	je     80264b <free+0x36e>
				uheapPageAllocBreak = MergedBlock->startva;
  80262c:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80262f:	8b 00                	mov    (%eax),%eax
  802631:	a3 68 e0 81 00       	mov    %eax,0x81e068
				release_uspinlock(&ulock);
  802636:	83 ec 0c             	sub    $0xc,%esp
  802639:	68 40 e1 81 00       	push   $0x81e140
  80263e:	e8 88 20 00 00       	call   8046cb <release_uspinlock>
  802643:	83 c4 10             	add    $0x10,%esp
				return;
  802646:	e9 20 04 00 00       	jmp    802a6b <free+0x78e>

			}else{
				uheapPageAllocBreak = newfree->startva;
  80264b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80264e:	8b 00                	mov    (%eax),%eax
  802650:	a3 68 e0 81 00       	mov    %eax,0x81e068
				release_uspinlock(&ulock);
  802655:	83 ec 0c             	sub    $0xc,%esp
  802658:	68 40 e1 81 00       	push   $0x81e140
  80265d:	e8 69 20 00 00       	call   8046cb <release_uspinlock>
  802662:	83 c4 10             	add    $0x10,%esp
				return;
  802665:	e9 01 04 00 00       	jmp    802a6b <free+0x78e>

		}


		//check if block is merged with prev ,and find possible merge with next
		ToBeMerged = LIST_FIRST(&u_freelist);
  80266a:	a1 20 e1 81 00       	mov    0x81e120,%eax
  80266f:	89 45 ec             	mov    %eax,-0x14(%ebp)
		while(ToBeMerged != NULL){
  802672:	e9 7d 01 00 00       	jmp    8027f4 <free+0x517>
			if ((newfree->startva + newfree->size) == ToBeMerged->startva ){
  802677:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80267a:	8b 10                	mov    (%eax),%edx
  80267c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80267f:	8b 40 04             	mov    0x4(%eax),%eax
  802682:	01 c2                	add    %eax,%edx
  802684:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802687:	8b 00                	mov    (%eax),%eax
  802689:	39 c2                	cmp    %eax,%edx
  80268b:	0f 85 5a 01 00 00    	jne    8027eb <free+0x50e>
				if (mergeprev){
  802691:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802695:	0f 84 a1 00 00 00    	je     80273c <free+0x45f>
					MergedBlock->size += ToBeMerged->size;
  80269b:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80269e:	8b 50 04             	mov    0x4(%eax),%edx
  8026a1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026a4:	8b 40 04             	mov    0x4(%eax),%eax
  8026a7:	01 c2                	add    %eax,%edx
  8026a9:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8026ac:	89 50 04             	mov    %edx,0x4(%eax)
					LIST_REMOVE(&u_freelist, ToBeMerged);
  8026af:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8026b3:	75 17                	jne    8026cc <free+0x3ef>
  8026b5:	83 ec 04             	sub    $0x4,%esp
  8026b8:	68 8f 52 80 00       	push   $0x80528f
  8026bd:	68 0a 01 00 00       	push   $0x10a
  8026c2:	68 20 52 80 00       	push   $0x805220
  8026c7:	e8 24 e2 ff ff       	call   8008f0 <_panic>
  8026cc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026cf:	8b 40 08             	mov    0x8(%eax),%eax
  8026d2:	85 c0                	test   %eax,%eax
  8026d4:	74 11                	je     8026e7 <free+0x40a>
  8026d6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026d9:	8b 40 08             	mov    0x8(%eax),%eax
  8026dc:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8026df:	8b 52 0c             	mov    0xc(%edx),%edx
  8026e2:	89 50 0c             	mov    %edx,0xc(%eax)
  8026e5:	eb 0b                	jmp    8026f2 <free+0x415>
  8026e7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026ea:	8b 40 0c             	mov    0xc(%eax),%eax
  8026ed:	a3 24 e1 81 00       	mov    %eax,0x81e124
  8026f2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026f5:	8b 40 0c             	mov    0xc(%eax),%eax
  8026f8:	85 c0                	test   %eax,%eax
  8026fa:	74 11                	je     80270d <free+0x430>
  8026fc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026ff:	8b 40 0c             	mov    0xc(%eax),%eax
  802702:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802705:	8b 52 08             	mov    0x8(%edx),%edx
  802708:	89 50 08             	mov    %edx,0x8(%eax)
  80270b:	eb 0b                	jmp    802718 <free+0x43b>
  80270d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802710:	8b 40 08             	mov    0x8(%eax),%eax
  802713:	a3 20 e1 81 00       	mov    %eax,0x81e120
  802718:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80271b:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802722:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802725:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  80272c:	a1 2c e1 81 00       	mov    0x81e12c,%eax
  802731:	48                   	dec    %eax
  802732:	a3 2c e1 81 00       	mov    %eax,0x81e12c
					break;
  802737:	e9 c2 00 00 00       	jmp    8027fe <free+0x521>
		//if not merged find possible merge with next
				}else{
					MergedBlock->startva = newfree->startva;
  80273c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80273f:	8b 10                	mov    (%eax),%edx
  802741:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802744:	89 10                	mov    %edx,(%eax)
					MergedBlock->size  = newfree->size + ToBeMerged->size;
  802746:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802749:	8b 50 04             	mov    0x4(%eax),%edx
  80274c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80274f:	8b 40 04             	mov    0x4(%eax),%eax
  802752:	01 c2                	add    %eax,%edx
  802754:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802757:	89 50 04             	mov    %edx,0x4(%eax)
					LIST_REMOVE(&u_freelist, ToBeMerged);
  80275a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80275e:	75 17                	jne    802777 <free+0x49a>
  802760:	83 ec 04             	sub    $0x4,%esp
  802763:	68 8f 52 80 00       	push   $0x80528f
  802768:	68 10 01 00 00       	push   $0x110
  80276d:	68 20 52 80 00       	push   $0x805220
  802772:	e8 79 e1 ff ff       	call   8008f0 <_panic>
  802777:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80277a:	8b 40 08             	mov    0x8(%eax),%eax
  80277d:	85 c0                	test   %eax,%eax
  80277f:	74 11                	je     802792 <free+0x4b5>
  802781:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802784:	8b 40 08             	mov    0x8(%eax),%eax
  802787:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80278a:	8b 52 0c             	mov    0xc(%edx),%edx
  80278d:	89 50 0c             	mov    %edx,0xc(%eax)
  802790:	eb 0b                	jmp    80279d <free+0x4c0>
  802792:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802795:	8b 40 0c             	mov    0xc(%eax),%eax
  802798:	a3 24 e1 81 00       	mov    %eax,0x81e124
  80279d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027a0:	8b 40 0c             	mov    0xc(%eax),%eax
  8027a3:	85 c0                	test   %eax,%eax
  8027a5:	74 11                	je     8027b8 <free+0x4db>
  8027a7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027aa:	8b 40 0c             	mov    0xc(%eax),%eax
  8027ad:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8027b0:	8b 52 08             	mov    0x8(%edx),%edx
  8027b3:	89 50 08             	mov    %edx,0x8(%eax)
  8027b6:	eb 0b                	jmp    8027c3 <free+0x4e6>
  8027b8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027bb:	8b 40 08             	mov    0x8(%eax),%eax
  8027be:	a3 20 e1 81 00       	mov    %eax,0x81e120
  8027c3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027c6:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  8027cd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027d0:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  8027d7:	a1 2c e1 81 00       	mov    0x81e12c,%eax
  8027dc:	48                   	dec    %eax
  8027dd:	a3 2c e1 81 00       	mov    %eax,0x81e12c
					mergenext = 1;
  8027e2:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
					break;
  8027e9:	eb 13                	jmp    8027fe <free+0x521>
				}
			}
			ToBeMerged = ToBeMerged->prev_next_info.le_next;
  8027eb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027ee:	8b 40 08             	mov    0x8(%eax),%eax
  8027f1:	89 45 ec             	mov    %eax,-0x14(%ebp)
		}


		//check if block is merged with prev ,and find possible merge with next
		ToBeMerged = LIST_FIRST(&u_freelist);
		while(ToBeMerged != NULL){
  8027f4:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8027f8:	0f 85 79 fe ff ff    	jne    802677 <free+0x39a>




			// insertion
			struct UserHeapStruct* currentfree = LIST_FIRST(&u_freelist);
  8027fe:	a1 20 e1 81 00       	mov    0x81e120,%eax
  802803:	89 45 e0             	mov    %eax,-0x20(%ebp)

			if(mergeprev || mergenext){
  802806:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80280a:	0f 85 ad 00 00 00    	jne    8028bd <free+0x5e0>
  802810:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802814:	0f 84 c3 01 00 00    	je     8029dd <free+0x700>
				while(currentfree != NULL){
  80281a:	e9 9e 00 00 00       	jmp    8028bd <free+0x5e0>
					if(MergedBlock->size < currentfree->size){
  80281f:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802822:	8b 50 04             	mov    0x4(%eax),%edx
  802825:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802828:	8b 40 04             	mov    0x4(%eax),%eax
  80282b:	39 c2                	cmp    %eax,%edx
  80282d:	0f 83 81 00 00 00    	jae    8028b4 <free+0x5d7>

							LIST_INSERT_BEFORE(&u_freelist,currentfree,MergedBlock);
  802833:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802837:	74 06                	je     80283f <free+0x562>
  802839:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  80283d:	75 17                	jne    802856 <free+0x579>
  80283f:	83 ec 04             	sub    $0x4,%esp
  802842:	68 b0 52 80 00       	push   $0x8052b0
  802847:	68 23 01 00 00       	push   $0x123
  80284c:	68 20 52 80 00       	push   $0x805220
  802851:	e8 9a e0 ff ff       	call   8008f0 <_panic>
  802856:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802859:	8b 50 0c             	mov    0xc(%eax),%edx
  80285c:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80285f:	89 50 0c             	mov    %edx,0xc(%eax)
  802862:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802865:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802868:	89 50 08             	mov    %edx,0x8(%eax)
  80286b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80286e:	8b 40 0c             	mov    0xc(%eax),%eax
  802871:	85 c0                	test   %eax,%eax
  802873:	74 0e                	je     802883 <free+0x5a6>
  802875:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802878:	8b 40 0c             	mov    0xc(%eax),%eax
  80287b:	8b 55 d0             	mov    -0x30(%ebp),%edx
  80287e:	89 50 08             	mov    %edx,0x8(%eax)
  802881:	eb 08                	jmp    80288b <free+0x5ae>
  802883:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802886:	a3 20 e1 81 00       	mov    %eax,0x81e120
  80288b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80288e:	8b 55 d0             	mov    -0x30(%ebp),%edx
  802891:	89 50 0c             	mov    %edx,0xc(%eax)
  802894:	a1 2c e1 81 00       	mov    0x81e12c,%eax
  802899:	40                   	inc    %eax
  80289a:	a3 2c e1 81 00       	mov    %eax,0x81e12c
							release_uspinlock(&ulock);
  80289f:	83 ec 0c             	sub    $0xc,%esp
  8028a2:	68 40 e1 81 00       	push   $0x81e140
  8028a7:	e8 1f 1e 00 00       	call   8046cb <release_uspinlock>
  8028ac:	83 c4 10             	add    $0x10,%esp
							return;
  8028af:	e9 b7 01 00 00       	jmp    802a6b <free+0x78e>
					}
							currentfree = currentfree->prev_next_info.le_next;
  8028b4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8028b7:	8b 40 08             	mov    0x8(%eax),%eax
  8028ba:	89 45 e0             	mov    %eax,-0x20(%ebp)

			// insertion
			struct UserHeapStruct* currentfree = LIST_FIRST(&u_freelist);

			if(mergeprev || mergenext){
				while(currentfree != NULL){
  8028bd:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8028c1:	0f 85 58 ff ff ff    	jne    80281f <free+0x542>
							release_uspinlock(&ulock);
							return;
					}
							currentfree = currentfree->prev_next_info.le_next;
				}
				free_block(newfree);
  8028c7:	83 ec 0c             	sub    $0xc,%esp
  8028ca:	ff 75 d4             	pushl  -0x2c(%ebp)
  8028cd:	e8 d5 19 00 00       	call   8042a7 <free_block>
  8028d2:	83 c4 10             	add    $0x10,%esp
				LIST_INSERT_TAIL(&u_freelist,MergedBlock);
  8028d5:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  8028d9:	75 17                	jne    8028f2 <free+0x615>
  8028db:	83 ec 04             	sub    $0x4,%esp
  8028de:	68 6c 52 80 00       	push   $0x80526c
  8028e3:	68 2a 01 00 00       	push   $0x12a
  8028e8:	68 20 52 80 00       	push   $0x805220
  8028ed:	e8 fe df ff ff       	call   8008f0 <_panic>
  8028f2:	8b 15 24 e1 81 00    	mov    0x81e124,%edx
  8028f8:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8028fb:	89 50 0c             	mov    %edx,0xc(%eax)
  8028fe:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802901:	8b 40 0c             	mov    0xc(%eax),%eax
  802904:	85 c0                	test   %eax,%eax
  802906:	74 0d                	je     802915 <free+0x638>
  802908:	a1 24 e1 81 00       	mov    0x81e124,%eax
  80290d:	8b 55 d0             	mov    -0x30(%ebp),%edx
  802910:	89 50 08             	mov    %edx,0x8(%eax)
  802913:	eb 08                	jmp    80291d <free+0x640>
  802915:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802918:	a3 20 e1 81 00       	mov    %eax,0x81e120
  80291d:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802920:	a3 24 e1 81 00       	mov    %eax,0x81e124
  802925:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802928:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  80292f:	a1 2c e1 81 00       	mov    0x81e12c,%eax
  802934:	40                   	inc    %eax
  802935:	a3 2c e1 81 00       	mov    %eax,0x81e12c
  80293a:	e9 1b 01 00 00       	jmp    802a5a <free+0x77d>

			}else{
				while(currentfree != NULL){
					if(newfree->size < currentfree->size){
  80293f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802942:	8b 50 04             	mov    0x4(%eax),%edx
  802945:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802948:	8b 40 04             	mov    0x4(%eax),%eax
  80294b:	39 c2                	cmp    %eax,%edx
  80294d:	0f 83 81 00 00 00    	jae    8029d4 <free+0x6f7>

							LIST_INSERT_BEFORE(&u_freelist,currentfree,newfree);
  802953:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802957:	74 06                	je     80295f <free+0x682>
  802959:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80295d:	75 17                	jne    802976 <free+0x699>
  80295f:	83 ec 04             	sub    $0x4,%esp
  802962:	68 b0 52 80 00       	push   $0x8052b0
  802967:	68 30 01 00 00       	push   $0x130
  80296c:	68 20 52 80 00       	push   $0x805220
  802971:	e8 7a df ff ff       	call   8008f0 <_panic>
  802976:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802979:	8b 50 0c             	mov    0xc(%eax),%edx
  80297c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80297f:	89 50 0c             	mov    %edx,0xc(%eax)
  802982:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802985:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802988:	89 50 08             	mov    %edx,0x8(%eax)
  80298b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80298e:	8b 40 0c             	mov    0xc(%eax),%eax
  802991:	85 c0                	test   %eax,%eax
  802993:	74 0e                	je     8029a3 <free+0x6c6>
  802995:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802998:	8b 40 0c             	mov    0xc(%eax),%eax
  80299b:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80299e:	89 50 08             	mov    %edx,0x8(%eax)
  8029a1:	eb 08                	jmp    8029ab <free+0x6ce>
  8029a3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8029a6:	a3 20 e1 81 00       	mov    %eax,0x81e120
  8029ab:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8029ae:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8029b1:	89 50 0c             	mov    %edx,0xc(%eax)
  8029b4:	a1 2c e1 81 00       	mov    0x81e12c,%eax
  8029b9:	40                   	inc    %eax
  8029ba:	a3 2c e1 81 00       	mov    %eax,0x81e12c
							release_uspinlock(&ulock);
  8029bf:	83 ec 0c             	sub    $0xc,%esp
  8029c2:	68 40 e1 81 00       	push   $0x81e140
  8029c7:	e8 ff 1c 00 00       	call   8046cb <release_uspinlock>
  8029cc:	83 c4 10             	add    $0x10,%esp
							return;
  8029cf:	e9 97 00 00 00       	jmp    802a6b <free+0x78e>
					}
							currentfree = currentfree->prev_next_info.le_next;
  8029d4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8029d7:	8b 40 08             	mov    0x8(%eax),%eax
  8029da:	89 45 e0             	mov    %eax,-0x20(%ebp)
				}
				free_block(newfree);
				LIST_INSERT_TAIL(&u_freelist,MergedBlock);

			}else{
				while(currentfree != NULL){
  8029dd:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8029e1:	0f 85 58 ff ff ff    	jne    80293f <free+0x662>
							release_uspinlock(&ulock);
							return;
					}
							currentfree = currentfree->prev_next_info.le_next;
				}
				free_block(MergedBlock);
  8029e7:	83 ec 0c             	sub    $0xc,%esp
  8029ea:	ff 75 d0             	pushl  -0x30(%ebp)
  8029ed:	e8 b5 18 00 00       	call   8042a7 <free_block>
  8029f2:	83 c4 10             	add    $0x10,%esp
				LIST_INSERT_TAIL(&u_freelist,newfree);
  8029f5:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8029f9:	75 17                	jne    802a12 <free+0x735>
  8029fb:	83 ec 04             	sub    $0x4,%esp
  8029fe:	68 6c 52 80 00       	push   $0x80526c
  802a03:	68 37 01 00 00       	push   $0x137
  802a08:	68 20 52 80 00       	push   $0x805220
  802a0d:	e8 de de ff ff       	call   8008f0 <_panic>
  802a12:	8b 15 24 e1 81 00    	mov    0x81e124,%edx
  802a18:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802a1b:	89 50 0c             	mov    %edx,0xc(%eax)
  802a1e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802a21:	8b 40 0c             	mov    0xc(%eax),%eax
  802a24:	85 c0                	test   %eax,%eax
  802a26:	74 0d                	je     802a35 <free+0x758>
  802a28:	a1 24 e1 81 00       	mov    0x81e124,%eax
  802a2d:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802a30:	89 50 08             	mov    %edx,0x8(%eax)
  802a33:	eb 08                	jmp    802a3d <free+0x760>
  802a35:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802a38:	a3 20 e1 81 00       	mov    %eax,0x81e120
  802a3d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802a40:	a3 24 e1 81 00       	mov    %eax,0x81e124
  802a45:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802a48:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802a4f:	a1 2c e1 81 00       	mov    0x81e12c,%eax
  802a54:	40                   	inc    %eax
  802a55:	a3 2c e1 81 00       	mov    %eax,0x81e12c
			}
		release_uspinlock(&ulock);
  802a5a:	83 ec 0c             	sub    $0xc,%esp
  802a5d:	68 40 e1 81 00       	push   $0x81e140
  802a62:	e8 64 1c 00 00       	call   8046cb <release_uspinlock>
  802a67:	83 c4 10             	add    $0x10,%esp
		return;
  802a6a:	90                   	nop
}
  802a6b:	c9                   	leave  
  802a6c:	c3                   	ret    

00802a6d <smalloc>:

//=================================
// [3] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  802a6d:	55                   	push   %ebp
  802a6e:	89 e5                	mov    %esp,%ebp
  802a70:	83 ec 48             	sub    $0x48,%esp
  802a73:	8b 45 10             	mov    0x10(%ebp),%eax
  802a76:	88 45 c4             	mov    %al,-0x3c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  802a79:	e8 2d f2 ff ff       	call   801cab <uheap_init>
	if (size == 0) return NULL;
  802a7e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802a82:	75 0a                	jne    802a8e <smalloc+0x21>
  802a84:	b8 00 00 00 00       	mov    $0x0,%eax
  802a89:	e9 84 05 00 00       	jmp    803012 <smalloc+0x5a5>
	//==============================================================
	acquire_uspinlock(&ulock);
  802a8e:	83 ec 0c             	sub    $0xc,%esp
  802a91:	68 40 e1 81 00       	push   $0x81e140
  802a96:	e8 d8 1b 00 00       	call   804673 <acquire_uspinlock>
  802a9b:	83 c4 10             	add    $0x10,%esp

	struct UserHeapStruct* allocblock = (struct UserHeapStruct*) alloc_block(sizeof(struct UserHeapStruct));
  802a9e:	83 ec 0c             	sub    $0xc,%esp
  802aa1:	6a 10                	push   $0x10
  802aa3:	e8 63 13 00 00       	call   803e0b <alloc_block>
  802aa8:	83 c4 10             	add    $0x10,%esp
  802aab:	89 45 ec             	mov    %eax,-0x14(%ebp)
	if (allocblock == NULL){
  802aae:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802ab2:	75 0a                	jne    802abe <smalloc+0x51>
				return NULL;
  802ab4:	b8 00 00 00 00       	mov    $0x0,%eax
  802ab9:	e9 54 05 00 00       	jmp    803012 <smalloc+0x5a5>
	}
		size = ROUNDUP(size,PAGE_SIZE);
  802abe:	c7 45 e8 00 10 00 00 	movl   $0x1000,-0x18(%ebp)
  802ac5:	8b 55 0c             	mov    0xc(%ebp),%edx
  802ac8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802acb:	01 d0                	add    %edx,%eax
  802acd:	48                   	dec    %eax
  802ace:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  802ad1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802ad4:	ba 00 00 00 00       	mov    $0x0,%edx
  802ad9:	f7 75 e8             	divl   -0x18(%ebp)
  802adc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802adf:	29 d0                	sub    %edx,%eax
  802ae1:	89 45 0c             	mov    %eax,0xc(%ebp)
		struct UserHeapStruct* lastfreeelement = LIST_LAST(&u_freelist);
  802ae4:	a1 24 e1 81 00       	mov    0x81e124,%eax
  802ae9:	89 45 e0             	mov    %eax,-0x20(%ebp)

		if(LIST_SIZE(&u_freelist)==0 || size>lastfreeelement->size){
  802aec:	a1 2c e1 81 00       	mov    0x81e12c,%eax
  802af1:	85 c0                	test   %eax,%eax
  802af3:	74 0f                	je     802b04 <smalloc+0x97>
  802af5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802af8:	8b 40 04             	mov    0x4(%eax),%eax
  802afb:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802afe:	0f 83 25 01 00 00    	jae    802c29 <smalloc+0x1bc>
				if(uheapPageAllocBreak <= USER_HEAP_MAX - size){
  802b04:	b8 00 00 00 a0       	mov    $0xa0000000,%eax
  802b09:	2b 45 0c             	sub    0xc(%ebp),%eax
  802b0c:	89 c2                	mov    %eax,%edx
  802b0e:	a1 68 e0 81 00       	mov    0x81e068,%eax
  802b13:	39 c2                	cmp    %eax,%edx
  802b15:	0f 82 f4 00 00 00    	jb     802c0f <smalloc+0x1a2>
						uint32 requestedblockva = uheapPageAllocBreak;
  802b1b:	a1 68 e0 81 00       	mov    0x81e068,%eax
  802b20:	89 45 d4             	mov    %eax,-0x2c(%ebp)
						uheapPageAllocBreak+=size;
  802b23:	8b 15 68 e0 81 00    	mov    0x81e068,%edx
  802b29:	8b 45 0c             	mov    0xc(%ebp),%eax
  802b2c:	01 d0                	add    %edx,%eax
  802b2e:	a3 68 e0 81 00       	mov    %eax,0x81e068
						allocblock->startva = requestedblockva;
  802b33:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b36:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802b39:	89 10                	mov    %edx,(%eax)
						allocblock->size = size;
  802b3b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b3e:	8b 55 0c             	mov    0xc(%ebp),%edx
  802b41:	89 50 04             	mov    %edx,0x4(%eax)

						LIST_INSERT_TAIL(&u_allocatedlist, allocblock);
  802b44:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802b48:	75 17                	jne    802b61 <smalloc+0xf4>
  802b4a:	83 ec 04             	sub    $0x4,%esp
  802b4d:	68 6c 52 80 00       	push   $0x80526c
  802b52:	68 57 01 00 00       	push   $0x157
  802b57:	68 20 52 80 00       	push   $0x805220
  802b5c:	e8 8f dd ff ff       	call   8008f0 <_panic>
  802b61:	8b 15 34 e1 81 00    	mov    0x81e134,%edx
  802b67:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b6a:	89 50 0c             	mov    %edx,0xc(%eax)
  802b6d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b70:	8b 40 0c             	mov    0xc(%eax),%eax
  802b73:	85 c0                	test   %eax,%eax
  802b75:	74 0d                	je     802b84 <smalloc+0x117>
  802b77:	a1 34 e1 81 00       	mov    0x81e134,%eax
  802b7c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802b7f:	89 50 08             	mov    %edx,0x8(%eax)
  802b82:	eb 08                	jmp    802b8c <smalloc+0x11f>
  802b84:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b87:	a3 30 e1 81 00       	mov    %eax,0x81e130
  802b8c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b8f:	a3 34 e1 81 00       	mov    %eax,0x81e134
  802b94:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b97:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802b9e:	a1 3c e1 81 00       	mov    0x81e13c,%eax
  802ba3:	40                   	inc    %eax
  802ba4:	a3 3c e1 81 00       	mov    %eax,0x81e13c


						int result = sys_create_shared_object(sharedVarName ,size ,isWritable ,(void*)allocblock->startva);
  802ba9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bac:	8b 00                	mov    (%eax),%eax
  802bae:	89 c2                	mov    %eax,%edx
  802bb0:	0f b6 45 c4          	movzbl -0x3c(%ebp),%eax
  802bb4:	52                   	push   %edx
  802bb5:	50                   	push   %eax
  802bb6:	ff 75 0c             	pushl  0xc(%ebp)
  802bb9:	ff 75 08             	pushl  0x8(%ebp)
  802bbc:	e8 48 0c 00 00       	call   803809 <sys_create_shared_object>
  802bc1:	83 c4 10             	add    $0x10,%esp
  802bc4:	89 45 d0             	mov    %eax,-0x30(%ebp)

						if(result <0){
  802bc7:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  802bcb:	79 28                	jns    802bf5 <smalloc+0x188>
							free_block(allocblock);
  802bcd:	83 ec 0c             	sub    $0xc,%esp
  802bd0:	ff 75 ec             	pushl  -0x14(%ebp)
  802bd3:	e8 cf 16 00 00       	call   8042a7 <free_block>
  802bd8:	83 c4 10             	add    $0x10,%esp
							release_uspinlock(&ulock);
  802bdb:	83 ec 0c             	sub    $0xc,%esp
  802bde:	68 40 e1 81 00       	push   $0x81e140
  802be3:	e8 e3 1a 00 00       	call   8046cb <release_uspinlock>
  802be8:	83 c4 10             	add    $0x10,%esp
							return NULL;
  802beb:	b8 00 00 00 00       	mov    $0x0,%eax
  802bf0:	e9 1d 04 00 00       	jmp    803012 <smalloc+0x5a5>
						}
						release_uspinlock(&ulock);
  802bf5:	83 ec 0c             	sub    $0xc,%esp
  802bf8:	68 40 e1 81 00       	push   $0x81e140
  802bfd:	e8 c9 1a 00 00       	call   8046cb <release_uspinlock>
  802c02:	83 c4 10             	add    $0x10,%esp
						return (void*)allocblock -> startva;
  802c05:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c08:	8b 00                	mov    (%eax),%eax
  802c0a:	e9 03 04 00 00       	jmp    803012 <smalloc+0x5a5>
				}else{
						release_uspinlock(&ulock);
  802c0f:	83 ec 0c             	sub    $0xc,%esp
  802c12:	68 40 e1 81 00       	push   $0x81e140
  802c17:	e8 af 1a 00 00       	call   8046cb <release_uspinlock>
  802c1c:	83 c4 10             	add    $0x10,%esp
						return NULL;
  802c1f:	b8 00 00 00 00       	mov    $0x0,%eax
  802c24:	e9 e9 03 00 00       	jmp    803012 <smalloc+0x5a5>
					 }
		}else{
			//custom fit
			struct UserHeapStruct* currentfreeelement = LIST_FIRST(&u_freelist);
  802c29:	a1 20 e1 81 00       	mov    0x81e120,%eax
  802c2e:	89 45 f4             	mov    %eax,-0xc(%ebp)
			//worst fit
			while(currentfreeelement != NULL){
  802c31:	e9 af 03 00 00       	jmp    802fe5 <smalloc+0x578>
				if(size<currentfreeelement->size){
  802c36:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c39:	8b 40 04             	mov    0x4(%eax),%eax
  802c3c:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802c3f:	0f 86 28 02 00 00    	jbe    802e6d <smalloc+0x400>
					allocblock->startva = lastfreeelement->startva;
  802c45:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802c48:	8b 10                	mov    (%eax),%edx
  802c4a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c4d:	89 10                	mov    %edx,(%eax)
	                allocblock->size = size;
  802c4f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c52:	8b 55 0c             	mov    0xc(%ebp),%edx
  802c55:	89 50 04             	mov    %edx,0x4(%eax)
	                LIST_INSERT_TAIL(&u_allocatedlist,allocblock);
  802c58:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802c5c:	75 17                	jne    802c75 <smalloc+0x208>
  802c5e:	83 ec 04             	sub    $0x4,%esp
  802c61:	68 6c 52 80 00       	push   $0x80526c
  802c66:	68 6f 01 00 00       	push   $0x16f
  802c6b:	68 20 52 80 00       	push   $0x805220
  802c70:	e8 7b dc ff ff       	call   8008f0 <_panic>
  802c75:	8b 15 34 e1 81 00    	mov    0x81e134,%edx
  802c7b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c7e:	89 50 0c             	mov    %edx,0xc(%eax)
  802c81:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c84:	8b 40 0c             	mov    0xc(%eax),%eax
  802c87:	85 c0                	test   %eax,%eax
  802c89:	74 0d                	je     802c98 <smalloc+0x22b>
  802c8b:	a1 34 e1 81 00       	mov    0x81e134,%eax
  802c90:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802c93:	89 50 08             	mov    %edx,0x8(%eax)
  802c96:	eb 08                	jmp    802ca0 <smalloc+0x233>
  802c98:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c9b:	a3 30 e1 81 00       	mov    %eax,0x81e130
  802ca0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ca3:	a3 34 e1 81 00       	mov    %eax,0x81e134
  802ca8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cab:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802cb2:	a1 3c e1 81 00       	mov    0x81e13c,%eax
  802cb7:	40                   	inc    %eax
  802cb8:	a3 3c e1 81 00       	mov    %eax,0x81e13c
	                lastfreeelement->startva += size;
  802cbd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802cc0:	8b 10                	mov    (%eax),%edx
  802cc2:	8b 45 0c             	mov    0xc(%ebp),%eax
  802cc5:	01 c2                	add    %eax,%edx
  802cc7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802cca:	89 10                	mov    %edx,(%eax)
	                lastfreeelement->size -= size;
  802ccc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802ccf:	8b 40 04             	mov    0x4(%eax),%eax
  802cd2:	2b 45 0c             	sub    0xc(%ebp),%eax
  802cd5:	89 c2                	mov    %eax,%edx
  802cd7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802cda:	89 50 04             	mov    %edx,0x4(%eax)
	                struct UserHeapStruct* currentfree2 = LIST_FIRST(&u_freelist);
  802cdd:	a1 20 e1 81 00       	mov    0x81e120,%eax
  802ce2:	89 45 f0             	mov    %eax,-0x10(%ebp)
	                //check order of last element

	                while (currentfree2 != NULL){
  802ce5:	e9 13 01 00 00       	jmp    802dfd <smalloc+0x390>
	                	if(lastfreeelement->size <currentfree2->size){
  802cea:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802ced:	8b 50 04             	mov    0x4(%eax),%edx
  802cf0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cf3:	8b 40 04             	mov    0x4(%eax),%eax
  802cf6:	39 c2                	cmp    %eax,%edx
  802cf8:	0f 83 f6 00 00 00    	jae    802df4 <smalloc+0x387>
	                		LIST_REMOVE(&u_freelist ,lastfreeelement);
  802cfe:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802d02:	75 17                	jne    802d1b <smalloc+0x2ae>
  802d04:	83 ec 04             	sub    $0x4,%esp
  802d07:	68 8f 52 80 00       	push   $0x80528f
  802d0c:	68 77 01 00 00       	push   $0x177
  802d11:	68 20 52 80 00       	push   $0x805220
  802d16:	e8 d5 db ff ff       	call   8008f0 <_panic>
  802d1b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802d1e:	8b 40 08             	mov    0x8(%eax),%eax
  802d21:	85 c0                	test   %eax,%eax
  802d23:	74 11                	je     802d36 <smalloc+0x2c9>
  802d25:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802d28:	8b 40 08             	mov    0x8(%eax),%eax
  802d2b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802d2e:	8b 52 0c             	mov    0xc(%edx),%edx
  802d31:	89 50 0c             	mov    %edx,0xc(%eax)
  802d34:	eb 0b                	jmp    802d41 <smalloc+0x2d4>
  802d36:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802d39:	8b 40 0c             	mov    0xc(%eax),%eax
  802d3c:	a3 24 e1 81 00       	mov    %eax,0x81e124
  802d41:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802d44:	8b 40 0c             	mov    0xc(%eax),%eax
  802d47:	85 c0                	test   %eax,%eax
  802d49:	74 11                	je     802d5c <smalloc+0x2ef>
  802d4b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802d4e:	8b 40 0c             	mov    0xc(%eax),%eax
  802d51:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802d54:	8b 52 08             	mov    0x8(%edx),%edx
  802d57:	89 50 08             	mov    %edx,0x8(%eax)
  802d5a:	eb 0b                	jmp    802d67 <smalloc+0x2fa>
  802d5c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802d5f:	8b 40 08             	mov    0x8(%eax),%eax
  802d62:	a3 20 e1 81 00       	mov    %eax,0x81e120
  802d67:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802d6a:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802d71:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802d74:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  802d7b:	a1 2c e1 81 00       	mov    0x81e12c,%eax
  802d80:	48                   	dec    %eax
  802d81:	a3 2c e1 81 00       	mov    %eax,0x81e12c
	                		LIST_INSERT_BEFORE(&u_freelist ,currentfree2 ,lastfreeelement);
  802d86:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802d8a:	74 06                	je     802d92 <smalloc+0x325>
  802d8c:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802d90:	75 17                	jne    802da9 <smalloc+0x33c>
  802d92:	83 ec 04             	sub    $0x4,%esp
  802d95:	68 b0 52 80 00       	push   $0x8052b0
  802d9a:	68 78 01 00 00       	push   $0x178
  802d9f:	68 20 52 80 00       	push   $0x805220
  802da4:	e8 47 db ff ff       	call   8008f0 <_panic>
  802da9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dac:	8b 50 0c             	mov    0xc(%eax),%edx
  802daf:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802db2:	89 50 0c             	mov    %edx,0xc(%eax)
  802db5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802db8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802dbb:	89 50 08             	mov    %edx,0x8(%eax)
  802dbe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dc1:	8b 40 0c             	mov    0xc(%eax),%eax
  802dc4:	85 c0                	test   %eax,%eax
  802dc6:	74 0e                	je     802dd6 <smalloc+0x369>
  802dc8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dcb:	8b 40 0c             	mov    0xc(%eax),%eax
  802dce:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802dd1:	89 50 08             	mov    %edx,0x8(%eax)
  802dd4:	eb 08                	jmp    802dde <smalloc+0x371>
  802dd6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802dd9:	a3 20 e1 81 00       	mov    %eax,0x81e120
  802dde:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802de1:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802de4:	89 50 0c             	mov    %edx,0xc(%eax)
  802de7:	a1 2c e1 81 00       	mov    0x81e12c,%eax
  802dec:	40                   	inc    %eax
  802ded:	a3 2c e1 81 00       	mov    %eax,0x81e12c
	                		break;
  802df2:	eb 13                	jmp    802e07 <smalloc+0x39a>
	                	}
	                	currentfree2 = currentfree2->prev_next_info.le_next;
  802df4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802df7:	8b 40 08             	mov    0x8(%eax),%eax
  802dfa:	89 45 f0             	mov    %eax,-0x10(%ebp)
	                lastfreeelement->startva += size;
	                lastfreeelement->size -= size;
	                struct UserHeapStruct* currentfree2 = LIST_FIRST(&u_freelist);
	                //check order of last element

	                while (currentfree2 != NULL){
  802dfd:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802e01:	0f 85 e3 fe ff ff    	jne    802cea <smalloc+0x27d>
	                	}
	                	currentfree2 = currentfree2->prev_next_info.le_next;
	                }


	                int result = sys_create_shared_object(sharedVarName ,size ,isWritable ,(void*)allocblock->startva);
  802e07:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e0a:	8b 00                	mov    (%eax),%eax
  802e0c:	89 c2                	mov    %eax,%edx
  802e0e:	0f b6 45 c4          	movzbl -0x3c(%ebp),%eax
  802e12:	52                   	push   %edx
  802e13:	50                   	push   %eax
  802e14:	ff 75 0c             	pushl  0xc(%ebp)
  802e17:	ff 75 08             	pushl  0x8(%ebp)
  802e1a:	e8 ea 09 00 00       	call   803809 <sys_create_shared_object>
  802e1f:	83 c4 10             	add    $0x10,%esp
  802e22:	89 45 d8             	mov    %eax,-0x28(%ebp)

	                if(result <0){
  802e25:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  802e29:	79 28                	jns    802e53 <smalloc+0x3e6>
	                	free_block(allocblock);
  802e2b:	83 ec 0c             	sub    $0xc,%esp
  802e2e:	ff 75 ec             	pushl  -0x14(%ebp)
  802e31:	e8 71 14 00 00       	call   8042a7 <free_block>
  802e36:	83 c4 10             	add    $0x10,%esp
	                	release_uspinlock(&ulock);
  802e39:	83 ec 0c             	sub    $0xc,%esp
  802e3c:	68 40 e1 81 00       	push   $0x81e140
  802e41:	e8 85 18 00 00       	call   8046cb <release_uspinlock>
  802e46:	83 c4 10             	add    $0x10,%esp
	                	return NULL;
  802e49:	b8 00 00 00 00       	mov    $0x0,%eax
  802e4e:	e9 bf 01 00 00       	jmp    803012 <smalloc+0x5a5>
	                }
	                release_uspinlock(&ulock);
  802e53:	83 ec 0c             	sub    $0xc,%esp
  802e56:	68 40 e1 81 00       	push   $0x81e140
  802e5b:	e8 6b 18 00 00       	call   8046cb <release_uspinlock>
  802e60:	83 c4 10             	add    $0x10,%esp
	                return (void*)allocblock->startva;
  802e63:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e66:	8b 00                	mov    (%eax),%eax
  802e68:	e9 a5 01 00 00       	jmp    803012 <smalloc+0x5a5>
	                //exact fit
				}else if(size == currentfreeelement->size){
  802e6d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e70:	8b 40 04             	mov    0x4(%eax),%eax
  802e73:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802e76:	0f 85 60 01 00 00    	jne    802fdc <smalloc+0x56f>
					allocblock->startva = currentfreeelement->startva;
  802e7c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e7f:	8b 10                	mov    (%eax),%edx
  802e81:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e84:	89 10                	mov    %edx,(%eax)
					allocblock->size = size;
  802e86:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e89:	8b 55 0c             	mov    0xc(%ebp),%edx
  802e8c:	89 50 04             	mov    %edx,0x4(%eax)
					LIST_INSERT_TAIL(&u_allocatedlist ,allocblock);
  802e8f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802e93:	75 17                	jne    802eac <smalloc+0x43f>
  802e95:	83 ec 04             	sub    $0x4,%esp
  802e98:	68 6c 52 80 00       	push   $0x80526c
  802e9d:	68 8c 01 00 00       	push   $0x18c
  802ea2:	68 20 52 80 00       	push   $0x805220
  802ea7:	e8 44 da ff ff       	call   8008f0 <_panic>
  802eac:	8b 15 34 e1 81 00    	mov    0x81e134,%edx
  802eb2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802eb5:	89 50 0c             	mov    %edx,0xc(%eax)
  802eb8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ebb:	8b 40 0c             	mov    0xc(%eax),%eax
  802ebe:	85 c0                	test   %eax,%eax
  802ec0:	74 0d                	je     802ecf <smalloc+0x462>
  802ec2:	a1 34 e1 81 00       	mov    0x81e134,%eax
  802ec7:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802eca:	89 50 08             	mov    %edx,0x8(%eax)
  802ecd:	eb 08                	jmp    802ed7 <smalloc+0x46a>
  802ecf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ed2:	a3 30 e1 81 00       	mov    %eax,0x81e130
  802ed7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802eda:	a3 34 e1 81 00       	mov    %eax,0x81e134
  802edf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ee2:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802ee9:	a1 3c e1 81 00       	mov    0x81e13c,%eax
  802eee:	40                   	inc    %eax
  802eef:	a3 3c e1 81 00       	mov    %eax,0x81e13c
					LIST_REMOVE(&u_freelist ,currentfreeelement);
  802ef4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ef8:	75 17                	jne    802f11 <smalloc+0x4a4>
  802efa:	83 ec 04             	sub    $0x4,%esp
  802efd:	68 8f 52 80 00       	push   $0x80528f
  802f02:	68 8d 01 00 00       	push   $0x18d
  802f07:	68 20 52 80 00       	push   $0x805220
  802f0c:	e8 df d9 ff ff       	call   8008f0 <_panic>
  802f11:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f14:	8b 40 08             	mov    0x8(%eax),%eax
  802f17:	85 c0                	test   %eax,%eax
  802f19:	74 11                	je     802f2c <smalloc+0x4bf>
  802f1b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f1e:	8b 40 08             	mov    0x8(%eax),%eax
  802f21:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802f24:	8b 52 0c             	mov    0xc(%edx),%edx
  802f27:	89 50 0c             	mov    %edx,0xc(%eax)
  802f2a:	eb 0b                	jmp    802f37 <smalloc+0x4ca>
  802f2c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f2f:	8b 40 0c             	mov    0xc(%eax),%eax
  802f32:	a3 24 e1 81 00       	mov    %eax,0x81e124
  802f37:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f3a:	8b 40 0c             	mov    0xc(%eax),%eax
  802f3d:	85 c0                	test   %eax,%eax
  802f3f:	74 11                	je     802f52 <smalloc+0x4e5>
  802f41:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f44:	8b 40 0c             	mov    0xc(%eax),%eax
  802f47:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802f4a:	8b 52 08             	mov    0x8(%edx),%edx
  802f4d:	89 50 08             	mov    %edx,0x8(%eax)
  802f50:	eb 0b                	jmp    802f5d <smalloc+0x4f0>
  802f52:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f55:	8b 40 08             	mov    0x8(%eax),%eax
  802f58:	a3 20 e1 81 00       	mov    %eax,0x81e120
  802f5d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f60:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802f67:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f6a:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  802f71:	a1 2c e1 81 00       	mov    0x81e12c,%eax
  802f76:	48                   	dec    %eax
  802f77:	a3 2c e1 81 00       	mov    %eax,0x81e12c
					int result = sys_create_shared_object(sharedVarName ,size ,isWritable ,(void*)allocblock->startva);
  802f7c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f7f:	8b 00                	mov    (%eax),%eax
  802f81:	89 c2                	mov    %eax,%edx
  802f83:	0f b6 45 c4          	movzbl -0x3c(%ebp),%eax
  802f87:	52                   	push   %edx
  802f88:	50                   	push   %eax
  802f89:	ff 75 0c             	pushl  0xc(%ebp)
  802f8c:	ff 75 08             	pushl  0x8(%ebp)
  802f8f:	e8 75 08 00 00       	call   803809 <sys_create_shared_object>
  802f94:	83 c4 10             	add    $0x10,%esp
  802f97:	89 45 dc             	mov    %eax,-0x24(%ebp)

					if(result <0){
  802f9a:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802f9e:	79 25                	jns    802fc5 <smalloc+0x558>
						free_block(allocblock);
  802fa0:	83 ec 0c             	sub    $0xc,%esp
  802fa3:	ff 75 ec             	pushl  -0x14(%ebp)
  802fa6:	e8 fc 12 00 00       	call   8042a7 <free_block>
  802fab:	83 c4 10             	add    $0x10,%esp
						release_uspinlock(&ulock);
  802fae:	83 ec 0c             	sub    $0xc,%esp
  802fb1:	68 40 e1 81 00       	push   $0x81e140
  802fb6:	e8 10 17 00 00       	call   8046cb <release_uspinlock>
  802fbb:	83 c4 10             	add    $0x10,%esp
						return NULL;
  802fbe:	b8 00 00 00 00       	mov    $0x0,%eax
  802fc3:	eb 4d                	jmp    803012 <smalloc+0x5a5>
					}
					release_uspinlock(&ulock);
  802fc5:	83 ec 0c             	sub    $0xc,%esp
  802fc8:	68 40 e1 81 00       	push   $0x81e140
  802fcd:	e8 f9 16 00 00       	call   8046cb <release_uspinlock>
  802fd2:	83 c4 10             	add    $0x10,%esp
					return (void*)allocblock->startva;
  802fd5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802fd8:	8b 00                	mov    (%eax),%eax
  802fda:	eb 36                	jmp    803012 <smalloc+0x5a5>
				}
				currentfreeelement = currentfreeelement->prev_next_info.le_next;
  802fdc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fdf:	8b 40 08             	mov    0x8(%eax),%eax
  802fe2:	89 45 f4             	mov    %eax,-0xc(%ebp)
					 }
		}else{
			//custom fit
			struct UserHeapStruct* currentfreeelement = LIST_FIRST(&u_freelist);
			//worst fit
			while(currentfreeelement != NULL){
  802fe5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802fe9:	0f 85 47 fc ff ff    	jne    802c36 <smalloc+0x1c9>
					return (void*)allocblock->startva;
				}
				currentfreeelement = currentfreeelement->prev_next_info.le_next;
			}
		}
		free_block(allocblock);
  802fef:	83 ec 0c             	sub    $0xc,%esp
  802ff2:	ff 75 ec             	pushl  -0x14(%ebp)
  802ff5:	e8 ad 12 00 00       	call   8042a7 <free_block>
  802ffa:	83 c4 10             	add    $0x10,%esp
		release_uspinlock(&ulock);
  802ffd:	83 ec 0c             	sub    $0xc,%esp
  803000:	68 40 e1 81 00       	push   $0x81e140
  803005:	e8 c1 16 00 00       	call   8046cb <release_uspinlock>
  80300a:	83 c4 10             	add    $0x10,%esp
		return NULL;
  80300d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803012:	c9                   	leave  
  803013:	c3                   	ret    

00803014 <sget>:

//========================================
// [4] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  803014:	55                   	push   %ebp
  803015:	89 e5                	mov    %esp,%ebp
  803017:	83 ec 38             	sub    $0x38,%esp


	 //==============================================================
	 // DON'T CHANGE THIS CODE
	    uheap_init();
  80301a:	e8 8c ec ff ff       	call   801cab <uheap_init>
	 //==============================================================
	 // Get size of the shared variable from kernel
	acquire_uspinlock(&ulock);
  80301f:	83 ec 0c             	sub    $0xc,%esp
  803022:	68 40 e1 81 00       	push   $0x81e140
  803027:	e8 47 16 00 00       	call   804673 <acquire_uspinlock>
  80302c:	83 c4 10             	add    $0x10,%esp


	int size = sys_size_of_shared_object(ownerEnvID ,sharedVarName);
  80302f:	83 ec 08             	sub    $0x8,%esp
  803032:	ff 75 0c             	pushl  0xc(%ebp)
  803035:	ff 75 08             	pushl  0x8(%ebp)
  803038:	e8 f6 07 00 00       	call   803833 <sys_size_of_shared_object>
  80303d:	83 c4 10             	add    $0x10,%esp
  803040:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if ( size < 0 ){
  803043:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803047:	79 1a                	jns    803063 <sget+0x4f>
			release_uspinlock(&ulock);
  803049:	83 ec 0c             	sub    $0xc,%esp
  80304c:	68 40 e1 81 00       	push   $0x81e140
  803051:	e8 75 16 00 00       	call   8046cb <release_uspinlock>
  803056:	83 c4 10             	add    $0x10,%esp
			return NULL;
  803059:	b8 00 00 00 00       	mov    $0x0,%eax
  80305e:	e9 6e 05 00 00       	jmp    8035d1 <sget+0x5bd>
		}
		size = ROUNDUP(size,PAGE_SIZE);
  803063:	c7 45 e8 00 10 00 00 	movl   $0x1000,-0x18(%ebp)
  80306a:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80306d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803070:	01 d0                	add    %edx,%eax
  803072:	48                   	dec    %eax
  803073:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  803076:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803079:	ba 00 00 00 00       	mov    $0x0,%edx
  80307e:	f7 75 e8             	divl   -0x18(%ebp)
  803081:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803084:	29 d0                	sub    %edx,%eax
  803086:	89 45 ec             	mov    %eax,-0x14(%ebp)

		struct UserHeapStruct* allocblock = (struct UserHeapStruct*) alloc_block(sizeof(struct UserHeapStruct));
  803089:	83 ec 0c             	sub    $0xc,%esp
  80308c:	6a 10                	push   $0x10
  80308e:	e8 78 0d 00 00       	call   803e0b <alloc_block>
  803093:	83 c4 10             	add    $0x10,%esp
  803096:	89 45 e0             	mov    %eax,-0x20(%ebp)

		if (allocblock == NULL){
  803099:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80309d:	75 0a                	jne    8030a9 <sget+0x95>
			return NULL;
  80309f:	b8 00 00 00 00       	mov    $0x0,%eax
  8030a4:	e9 28 05 00 00       	jmp    8035d1 <sget+0x5bd>
		}
		struct UserHeapStruct* lastfreeelement = LIST_LAST(&u_freelist);
  8030a9:	a1 24 e1 81 00       	mov    0x81e124,%eax
  8030ae:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if(LIST_SIZE(&u_freelist)==0 || size>lastfreeelement->size){
  8030b1:	a1 2c e1 81 00       	mov    0x81e12c,%eax
  8030b6:	85 c0                	test   %eax,%eax
  8030b8:	74 11                	je     8030cb <sget+0xb7>
  8030ba:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8030bd:	8b 50 04             	mov    0x4(%eax),%edx
  8030c0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030c3:	39 c2                	cmp    %eax,%edx
  8030c5:	0f 83 21 01 00 00    	jae    8031ec <sget+0x1d8>
				if(uheapPageAllocBreak <= USER_HEAP_MAX - size){
  8030cb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030ce:	ba 00 00 00 a0       	mov    $0xa0000000,%edx
  8030d3:	29 c2                	sub    %eax,%edx
  8030d5:	a1 68 e0 81 00       	mov    0x81e068,%eax
  8030da:	39 c2                	cmp    %eax,%edx
  8030dc:	0f 82 f0 00 00 00    	jb     8031d2 <sget+0x1be>

						uint32 requestedblockva = uheapPageAllocBreak;
  8030e2:	a1 68 e0 81 00       	mov    0x81e068,%eax
  8030e7:	89 45 d0             	mov    %eax,-0x30(%ebp)
						uheapPageAllocBreak+=size;
  8030ea:	8b 15 68 e0 81 00    	mov    0x81e068,%edx
  8030f0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030f3:	01 d0                	add    %edx,%eax
  8030f5:	a3 68 e0 81 00       	mov    %eax,0x81e068
						allocblock->startva = requestedblockva;
  8030fa:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8030fd:	8b 55 d0             	mov    -0x30(%ebp),%edx
  803100:	89 10                	mov    %edx,(%eax)
						allocblock->size = size;
  803102:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803105:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803108:	89 50 04             	mov    %edx,0x4(%eax)

						LIST_INSERT_TAIL(&u_allocatedlist, allocblock);
  80310b:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80310f:	75 17                	jne    803128 <sget+0x114>
  803111:	83 ec 04             	sub    $0x4,%esp
  803114:	68 6c 52 80 00       	push   $0x80526c
  803119:	68 c8 01 00 00       	push   $0x1c8
  80311e:	68 20 52 80 00       	push   $0x805220
  803123:	e8 c8 d7 ff ff       	call   8008f0 <_panic>
  803128:	8b 15 34 e1 81 00    	mov    0x81e134,%edx
  80312e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803131:	89 50 0c             	mov    %edx,0xc(%eax)
  803134:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803137:	8b 40 0c             	mov    0xc(%eax),%eax
  80313a:	85 c0                	test   %eax,%eax
  80313c:	74 0d                	je     80314b <sget+0x137>
  80313e:	a1 34 e1 81 00       	mov    0x81e134,%eax
  803143:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803146:	89 50 08             	mov    %edx,0x8(%eax)
  803149:	eb 08                	jmp    803153 <sget+0x13f>
  80314b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80314e:	a3 30 e1 81 00       	mov    %eax,0x81e130
  803153:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803156:	a3 34 e1 81 00       	mov    %eax,0x81e134
  80315b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80315e:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  803165:	a1 3c e1 81 00       	mov    0x81e13c,%eax
  80316a:	40                   	inc    %eax
  80316b:	a3 3c e1 81 00       	mov    %eax,0x81e13c


						int result = sys_get_shared_object(ownerEnvID ,sharedVarName ,(void*)allocblock->startva);
  803170:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803173:	8b 00                	mov    (%eax),%eax
  803175:	83 ec 04             	sub    $0x4,%esp
  803178:	50                   	push   %eax
  803179:	ff 75 0c             	pushl  0xc(%ebp)
  80317c:	ff 75 08             	pushl  0x8(%ebp)
  80317f:	e8 cc 06 00 00       	call   803850 <sys_get_shared_object>
  803184:	83 c4 10             	add    $0x10,%esp
  803187:	89 45 cc             	mov    %eax,-0x34(%ebp)

						if(result <0){
  80318a:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  80318e:	79 28                	jns    8031b8 <sget+0x1a4>
							free_block(allocblock);
  803190:	83 ec 0c             	sub    $0xc,%esp
  803193:	ff 75 e0             	pushl  -0x20(%ebp)
  803196:	e8 0c 11 00 00       	call   8042a7 <free_block>
  80319b:	83 c4 10             	add    $0x10,%esp
							release_uspinlock(&ulock);
  80319e:	83 ec 0c             	sub    $0xc,%esp
  8031a1:	68 40 e1 81 00       	push   $0x81e140
  8031a6:	e8 20 15 00 00       	call   8046cb <release_uspinlock>
  8031ab:	83 c4 10             	add    $0x10,%esp
							return NULL;
  8031ae:	b8 00 00 00 00       	mov    $0x0,%eax
  8031b3:	e9 19 04 00 00       	jmp    8035d1 <sget+0x5bd>
						}
						release_uspinlock(&ulock);
  8031b8:	83 ec 0c             	sub    $0xc,%esp
  8031bb:	68 40 e1 81 00       	push   $0x81e140
  8031c0:	e8 06 15 00 00       	call   8046cb <release_uspinlock>
  8031c5:	83 c4 10             	add    $0x10,%esp
						return (void*)allocblock -> startva;
  8031c8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8031cb:	8b 00                	mov    (%eax),%eax
  8031cd:	e9 ff 03 00 00       	jmp    8035d1 <sget+0x5bd>
				}else{
						release_uspinlock(&ulock);
  8031d2:	83 ec 0c             	sub    $0xc,%esp
  8031d5:	68 40 e1 81 00       	push   $0x81e140
  8031da:	e8 ec 14 00 00       	call   8046cb <release_uspinlock>
  8031df:	83 c4 10             	add    $0x10,%esp
						return NULL;
  8031e2:	b8 00 00 00 00       	mov    $0x0,%eax
  8031e7:	e9 e5 03 00 00       	jmp    8035d1 <sget+0x5bd>
					 }
		}else{
			//custom fit
			struct UserHeapStruct* currentfreeelement = LIST_FIRST(&u_freelist);
  8031ec:	a1 20 e1 81 00       	mov    0x81e120,%eax
  8031f1:	89 45 f4             	mov    %eax,-0xc(%ebp)
			//worst fit
			while(currentfreeelement != NULL){
  8031f4:	e9 ab 03 00 00       	jmp    8035a4 <sget+0x590>
				if(size<currentfreeelement->size){
  8031f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031fc:	8b 50 04             	mov    0x4(%eax),%edx
  8031ff:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803202:	39 c2                	cmp    %eax,%edx
  803204:	0f 86 24 02 00 00    	jbe    80342e <sget+0x41a>
					allocblock->startva = lastfreeelement->startva;
  80320a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80320d:	8b 10                	mov    (%eax),%edx
  80320f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803212:	89 10                	mov    %edx,(%eax)
					allocblock->size = size;
  803214:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803217:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80321a:	89 50 04             	mov    %edx,0x4(%eax)
					LIST_INSERT_TAIL(&u_allocatedlist,allocblock);
  80321d:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  803221:	75 17                	jne    80323a <sget+0x226>
  803223:	83 ec 04             	sub    $0x4,%esp
  803226:	68 6c 52 80 00       	push   $0x80526c
  80322b:	68 e0 01 00 00       	push   $0x1e0
  803230:	68 20 52 80 00       	push   $0x805220
  803235:	e8 b6 d6 ff ff       	call   8008f0 <_panic>
  80323a:	8b 15 34 e1 81 00    	mov    0x81e134,%edx
  803240:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803243:	89 50 0c             	mov    %edx,0xc(%eax)
  803246:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803249:	8b 40 0c             	mov    0xc(%eax),%eax
  80324c:	85 c0                	test   %eax,%eax
  80324e:	74 0d                	je     80325d <sget+0x249>
  803250:	a1 34 e1 81 00       	mov    0x81e134,%eax
  803255:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803258:	89 50 08             	mov    %edx,0x8(%eax)
  80325b:	eb 08                	jmp    803265 <sget+0x251>
  80325d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803260:	a3 30 e1 81 00       	mov    %eax,0x81e130
  803265:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803268:	a3 34 e1 81 00       	mov    %eax,0x81e134
  80326d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803270:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  803277:	a1 3c e1 81 00       	mov    0x81e13c,%eax
  80327c:	40                   	inc    %eax
  80327d:	a3 3c e1 81 00       	mov    %eax,0x81e13c
					lastfreeelement->startva += size;
  803282:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803285:	8b 10                	mov    (%eax),%edx
  803287:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80328a:	01 c2                	add    %eax,%edx
  80328c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80328f:	89 10                	mov    %edx,(%eax)
					lastfreeelement->size -= size;
  803291:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803294:	8b 50 04             	mov    0x4(%eax),%edx
  803297:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80329a:	29 c2                	sub    %eax,%edx
  80329c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80329f:	89 50 04             	mov    %edx,0x4(%eax)
					struct UserHeapStruct* currentfree2 = LIST_FIRST(&u_freelist);
  8032a2:	a1 20 e1 81 00       	mov    0x81e120,%eax
  8032a7:	89 45 f0             	mov    %eax,-0x10(%ebp)
					//check order of last element

					while (currentfree2 != NULL){
  8032aa:	e9 13 01 00 00       	jmp    8033c2 <sget+0x3ae>
						if(lastfreeelement->size <currentfree2->size){
  8032af:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8032b2:	8b 50 04             	mov    0x4(%eax),%edx
  8032b5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032b8:	8b 40 04             	mov    0x4(%eax),%eax
  8032bb:	39 c2                	cmp    %eax,%edx
  8032bd:	0f 83 f6 00 00 00    	jae    8033b9 <sget+0x3a5>
							LIST_REMOVE(&u_freelist ,lastfreeelement);
  8032c3:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8032c7:	75 17                	jne    8032e0 <sget+0x2cc>
  8032c9:	83 ec 04             	sub    $0x4,%esp
  8032cc:	68 8f 52 80 00       	push   $0x80528f
  8032d1:	68 e8 01 00 00       	push   $0x1e8
  8032d6:	68 20 52 80 00       	push   $0x805220
  8032db:	e8 10 d6 ff ff       	call   8008f0 <_panic>
  8032e0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8032e3:	8b 40 08             	mov    0x8(%eax),%eax
  8032e6:	85 c0                	test   %eax,%eax
  8032e8:	74 11                	je     8032fb <sget+0x2e7>
  8032ea:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8032ed:	8b 40 08             	mov    0x8(%eax),%eax
  8032f0:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8032f3:	8b 52 0c             	mov    0xc(%edx),%edx
  8032f6:	89 50 0c             	mov    %edx,0xc(%eax)
  8032f9:	eb 0b                	jmp    803306 <sget+0x2f2>
  8032fb:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8032fe:	8b 40 0c             	mov    0xc(%eax),%eax
  803301:	a3 24 e1 81 00       	mov    %eax,0x81e124
  803306:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803309:	8b 40 0c             	mov    0xc(%eax),%eax
  80330c:	85 c0                	test   %eax,%eax
  80330e:	74 11                	je     803321 <sget+0x30d>
  803310:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803313:	8b 40 0c             	mov    0xc(%eax),%eax
  803316:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803319:	8b 52 08             	mov    0x8(%edx),%edx
  80331c:	89 50 08             	mov    %edx,0x8(%eax)
  80331f:	eb 0b                	jmp    80332c <sget+0x318>
  803321:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803324:	8b 40 08             	mov    0x8(%eax),%eax
  803327:	a3 20 e1 81 00       	mov    %eax,0x81e120
  80332c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80332f:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  803336:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803339:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  803340:	a1 2c e1 81 00       	mov    0x81e12c,%eax
  803345:	48                   	dec    %eax
  803346:	a3 2c e1 81 00       	mov    %eax,0x81e12c
							LIST_INSERT_BEFORE(&u_freelist ,currentfree2 ,lastfreeelement);
  80334b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80334f:	74 06                	je     803357 <sget+0x343>
  803351:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803355:	75 17                	jne    80336e <sget+0x35a>
  803357:	83 ec 04             	sub    $0x4,%esp
  80335a:	68 b0 52 80 00       	push   $0x8052b0
  80335f:	68 e9 01 00 00       	push   $0x1e9
  803364:	68 20 52 80 00       	push   $0x805220
  803369:	e8 82 d5 ff ff       	call   8008f0 <_panic>
  80336e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803371:	8b 50 0c             	mov    0xc(%eax),%edx
  803374:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803377:	89 50 0c             	mov    %edx,0xc(%eax)
  80337a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80337d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803380:	89 50 08             	mov    %edx,0x8(%eax)
  803383:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803386:	8b 40 0c             	mov    0xc(%eax),%eax
  803389:	85 c0                	test   %eax,%eax
  80338b:	74 0e                	je     80339b <sget+0x387>
  80338d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803390:	8b 40 0c             	mov    0xc(%eax),%eax
  803393:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803396:	89 50 08             	mov    %edx,0x8(%eax)
  803399:	eb 08                	jmp    8033a3 <sget+0x38f>
  80339b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80339e:	a3 20 e1 81 00       	mov    %eax,0x81e120
  8033a3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033a6:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8033a9:	89 50 0c             	mov    %edx,0xc(%eax)
  8033ac:	a1 2c e1 81 00       	mov    0x81e12c,%eax
  8033b1:	40                   	inc    %eax
  8033b2:	a3 2c e1 81 00       	mov    %eax,0x81e12c
							break;
  8033b7:	eb 13                	jmp    8033cc <sget+0x3b8>
						}
						currentfree2 = currentfree2->prev_next_info.le_next;
  8033b9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033bc:	8b 40 08             	mov    0x8(%eax),%eax
  8033bf:	89 45 f0             	mov    %eax,-0x10(%ebp)
					lastfreeelement->startva += size;
					lastfreeelement->size -= size;
					struct UserHeapStruct* currentfree2 = LIST_FIRST(&u_freelist);
					//check order of last element

					while (currentfree2 != NULL){
  8033c2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8033c6:	0f 85 e3 fe ff ff    	jne    8032af <sget+0x29b>
						}
						currentfree2 = currentfree2->prev_next_info.le_next;
					}


					int result = sys_get_shared_object(ownerEnvID ,sharedVarName ,(void*)allocblock->startva);
  8033cc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8033cf:	8b 00                	mov    (%eax),%eax
  8033d1:	83 ec 04             	sub    $0x4,%esp
  8033d4:	50                   	push   %eax
  8033d5:	ff 75 0c             	pushl  0xc(%ebp)
  8033d8:	ff 75 08             	pushl  0x8(%ebp)
  8033db:	e8 70 04 00 00       	call   803850 <sys_get_shared_object>
  8033e0:	83 c4 10             	add    $0x10,%esp
  8033e3:	89 45 d4             	mov    %eax,-0x2c(%ebp)

					if(result <0){
  8033e6:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8033ea:	79 28                	jns    803414 <sget+0x400>
						free_block(allocblock);
  8033ec:	83 ec 0c             	sub    $0xc,%esp
  8033ef:	ff 75 e0             	pushl  -0x20(%ebp)
  8033f2:	e8 b0 0e 00 00       	call   8042a7 <free_block>
  8033f7:	83 c4 10             	add    $0x10,%esp
						release_uspinlock(&ulock);
  8033fa:	83 ec 0c             	sub    $0xc,%esp
  8033fd:	68 40 e1 81 00       	push   $0x81e140
  803402:	e8 c4 12 00 00       	call   8046cb <release_uspinlock>
  803407:	83 c4 10             	add    $0x10,%esp
						return NULL;
  80340a:	b8 00 00 00 00       	mov    $0x0,%eax
  80340f:	e9 bd 01 00 00       	jmp    8035d1 <sget+0x5bd>
					}
					release_uspinlock(&ulock);
  803414:	83 ec 0c             	sub    $0xc,%esp
  803417:	68 40 e1 81 00       	push   $0x81e140
  80341c:	e8 aa 12 00 00       	call   8046cb <release_uspinlock>
  803421:	83 c4 10             	add    $0x10,%esp
					return (void*)allocblock->startva;
  803424:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803427:	8b 00                	mov    (%eax),%eax
  803429:	e9 a3 01 00 00       	jmp    8035d1 <sget+0x5bd>
					//exact fit
				}else if(size == currentfreeelement->size){
  80342e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803431:	8b 50 04             	mov    0x4(%eax),%edx
  803434:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803437:	39 c2                	cmp    %eax,%edx
  803439:	0f 85 5c 01 00 00    	jne    80359b <sget+0x587>

					allocblock->startva = currentfreeelement->startva;
  80343f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803442:	8b 10                	mov    (%eax),%edx
  803444:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803447:	89 10                	mov    %edx,(%eax)
					allocblock->size = size;
  803449:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80344c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80344f:	89 50 04             	mov    %edx,0x4(%eax)
					LIST_INSERT_TAIL(&u_allocatedlist ,allocblock);
  803452:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  803456:	75 17                	jne    80346f <sget+0x45b>
  803458:	83 ec 04             	sub    $0x4,%esp
  80345b:	68 6c 52 80 00       	push   $0x80526c
  803460:	68 fe 01 00 00       	push   $0x1fe
  803465:	68 20 52 80 00       	push   $0x805220
  80346a:	e8 81 d4 ff ff       	call   8008f0 <_panic>
  80346f:	8b 15 34 e1 81 00    	mov    0x81e134,%edx
  803475:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803478:	89 50 0c             	mov    %edx,0xc(%eax)
  80347b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80347e:	8b 40 0c             	mov    0xc(%eax),%eax
  803481:	85 c0                	test   %eax,%eax
  803483:	74 0d                	je     803492 <sget+0x47e>
  803485:	a1 34 e1 81 00       	mov    0x81e134,%eax
  80348a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80348d:	89 50 08             	mov    %edx,0x8(%eax)
  803490:	eb 08                	jmp    80349a <sget+0x486>
  803492:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803495:	a3 30 e1 81 00       	mov    %eax,0x81e130
  80349a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80349d:	a3 34 e1 81 00       	mov    %eax,0x81e134
  8034a2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8034a5:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  8034ac:	a1 3c e1 81 00       	mov    0x81e13c,%eax
  8034b1:	40                   	inc    %eax
  8034b2:	a3 3c e1 81 00       	mov    %eax,0x81e13c
					LIST_REMOVE(&u_freelist ,currentfreeelement);
  8034b7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8034bb:	75 17                	jne    8034d4 <sget+0x4c0>
  8034bd:	83 ec 04             	sub    $0x4,%esp
  8034c0:	68 8f 52 80 00       	push   $0x80528f
  8034c5:	68 ff 01 00 00       	push   $0x1ff
  8034ca:	68 20 52 80 00       	push   $0x805220
  8034cf:	e8 1c d4 ff ff       	call   8008f0 <_panic>
  8034d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034d7:	8b 40 08             	mov    0x8(%eax),%eax
  8034da:	85 c0                	test   %eax,%eax
  8034dc:	74 11                	je     8034ef <sget+0x4db>
  8034de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034e1:	8b 40 08             	mov    0x8(%eax),%eax
  8034e4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8034e7:	8b 52 0c             	mov    0xc(%edx),%edx
  8034ea:	89 50 0c             	mov    %edx,0xc(%eax)
  8034ed:	eb 0b                	jmp    8034fa <sget+0x4e6>
  8034ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034f2:	8b 40 0c             	mov    0xc(%eax),%eax
  8034f5:	a3 24 e1 81 00       	mov    %eax,0x81e124
  8034fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034fd:	8b 40 0c             	mov    0xc(%eax),%eax
  803500:	85 c0                	test   %eax,%eax
  803502:	74 11                	je     803515 <sget+0x501>
  803504:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803507:	8b 40 0c             	mov    0xc(%eax),%eax
  80350a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80350d:	8b 52 08             	mov    0x8(%edx),%edx
  803510:	89 50 08             	mov    %edx,0x8(%eax)
  803513:	eb 0b                	jmp    803520 <sget+0x50c>
  803515:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803518:	8b 40 08             	mov    0x8(%eax),%eax
  80351b:	a3 20 e1 81 00       	mov    %eax,0x81e120
  803520:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803523:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  80352a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80352d:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  803534:	a1 2c e1 81 00       	mov    0x81e12c,%eax
  803539:	48                   	dec    %eax
  80353a:	a3 2c e1 81 00       	mov    %eax,0x81e12c

					int result = sys_get_shared_object(ownerEnvID ,sharedVarName ,(void*)allocblock->startva);
  80353f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803542:	8b 00                	mov    (%eax),%eax
  803544:	83 ec 04             	sub    $0x4,%esp
  803547:	50                   	push   %eax
  803548:	ff 75 0c             	pushl  0xc(%ebp)
  80354b:	ff 75 08             	pushl  0x8(%ebp)
  80354e:	e8 fd 02 00 00       	call   803850 <sys_get_shared_object>
  803553:	83 c4 10             	add    $0x10,%esp
  803556:	89 45 d8             	mov    %eax,-0x28(%ebp)
					if(result <0){
  803559:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  80355d:	79 25                	jns    803584 <sget+0x570>
						free_block(allocblock);
  80355f:	83 ec 0c             	sub    $0xc,%esp
  803562:	ff 75 e0             	pushl  -0x20(%ebp)
  803565:	e8 3d 0d 00 00       	call   8042a7 <free_block>
  80356a:	83 c4 10             	add    $0x10,%esp
						release_uspinlock(&ulock);
  80356d:	83 ec 0c             	sub    $0xc,%esp
  803570:	68 40 e1 81 00       	push   $0x81e140
  803575:	e8 51 11 00 00       	call   8046cb <release_uspinlock>
  80357a:	83 c4 10             	add    $0x10,%esp
						return NULL;
  80357d:	b8 00 00 00 00       	mov    $0x0,%eax
  803582:	eb 4d                	jmp    8035d1 <sget+0x5bd>
					}

					release_uspinlock(&ulock);
  803584:	83 ec 0c             	sub    $0xc,%esp
  803587:	68 40 e1 81 00       	push   $0x81e140
  80358c:	e8 3a 11 00 00       	call   8046cb <release_uspinlock>
  803591:	83 c4 10             	add    $0x10,%esp
					return (void*)allocblock->startva;
  803594:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803597:	8b 00                	mov    (%eax),%eax
  803599:	eb 36                	jmp    8035d1 <sget+0x5bd>
				}
				currentfreeelement = currentfreeelement->prev_next_info.le_next;
  80359b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80359e:	8b 40 08             	mov    0x8(%eax),%eax
  8035a1:	89 45 f4             	mov    %eax,-0xc(%ebp)
					 }
		}else{
			//custom fit
			struct UserHeapStruct* currentfreeelement = LIST_FIRST(&u_freelist);
			//worst fit
			while(currentfreeelement != NULL){
  8035a4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8035a8:	0f 85 4b fc ff ff    	jne    8031f9 <sget+0x1e5>
					return (void*)allocblock->startva;
				}
				currentfreeelement = currentfreeelement->prev_next_info.le_next;
			}
		}
		free_block(allocblock);
  8035ae:	83 ec 0c             	sub    $0xc,%esp
  8035b1:	ff 75 e0             	pushl  -0x20(%ebp)
  8035b4:	e8 ee 0c 00 00       	call   8042a7 <free_block>
  8035b9:	83 c4 10             	add    $0x10,%esp
		release_uspinlock(&ulock);
  8035bc:	83 ec 0c             	sub    $0xc,%esp
  8035bf:	68 40 e1 81 00       	push   $0x81e140
  8035c4:	e8 02 11 00 00       	call   8046cb <release_uspinlock>
  8035c9:	83 c4 10             	add    $0x10,%esp
		return NULL;
  8035cc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8035d1:	c9                   	leave  
  8035d2:	c3                   	ret    

008035d3 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  8035d3:	55                   	push   %ebp
  8035d4:	89 e5                	mov    %esp,%ebp
  8035d6:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  8035d9:	e8 cd e6 ff ff       	call   801cab <uheap_init>
	//==============================================================
	panic("realloc() is not implemented yet...!!");
  8035de:	83 ec 04             	sub    $0x4,%esp
  8035e1:	68 40 53 80 00       	push   $0x805340
  8035e6:	68 2d 02 00 00       	push   $0x22d
  8035eb:	68 20 52 80 00       	push   $0x805220
  8035f0:	e8 fb d2 ff ff       	call   8008f0 <_panic>

008035f5 <sfree>:
//
//	use sys_delete_shared_object(...); which switches to the kernel mode,
//	calls delete_shared_object(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the delete_shared_object() function is empty, make sure to implement it.
void sfree(void* virtual_address)
{
  8035f5:	55                   	push   %ebp
  8035f6:	89 e5                	mov    %esp,%ebp
  8035f8:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.BONUS#5] EXIT #2 - sfree
	//Your code is here
	//Comment the following line
	panic("sfree() is not implemented yet...!!");
  8035fb:	83 ec 04             	sub    $0x4,%esp
  8035fe:	68 68 53 80 00       	push   $0x805368
  803603:	68 40 02 00 00       	push   $0x240
  803608:	68 20 52 80 00       	push   $0x805220
  80360d:	e8 de d2 ff ff       	call   8008f0 <_panic>

00803612 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  803612:	55                   	push   %ebp
  803613:	89 e5                	mov    %esp,%ebp
  803615:	57                   	push   %edi
  803616:	56                   	push   %esi
  803617:	53                   	push   %ebx
  803618:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80361b:	8b 45 08             	mov    0x8(%ebp),%eax
  80361e:	8b 55 0c             	mov    0xc(%ebp),%edx
  803621:	8b 4d 10             	mov    0x10(%ebp),%ecx
  803624:	8b 5d 14             	mov    0x14(%ebp),%ebx
  803627:	8b 7d 18             	mov    0x18(%ebp),%edi
  80362a:	8b 75 1c             	mov    0x1c(%ebp),%esi
  80362d:	cd 30                	int    $0x30
  80362f:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  803632:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  803635:	83 c4 10             	add    $0x10,%esp
  803638:	5b                   	pop    %ebx
  803639:	5e                   	pop    %esi
  80363a:	5f                   	pop    %edi
  80363b:	5d                   	pop    %ebp
  80363c:	c3                   	ret    

0080363d <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  80363d:	55                   	push   %ebp
  80363e:	89 e5                	mov    %esp,%ebp
  803640:	83 ec 04             	sub    $0x4,%esp
  803643:	8b 45 10             	mov    0x10(%ebp),%eax
  803646:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  803649:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80364c:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  803650:	8b 45 08             	mov    0x8(%ebp),%eax
  803653:	6a 00                	push   $0x0
  803655:	51                   	push   %ecx
  803656:	52                   	push   %edx
  803657:	ff 75 0c             	pushl  0xc(%ebp)
  80365a:	50                   	push   %eax
  80365b:	6a 00                	push   $0x0
  80365d:	e8 b0 ff ff ff       	call   803612 <syscall>
  803662:	83 c4 18             	add    $0x18,%esp
}
  803665:	90                   	nop
  803666:	c9                   	leave  
  803667:	c3                   	ret    

00803668 <sys_cgetc>:

int
sys_cgetc(void)
{
  803668:	55                   	push   %ebp
  803669:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  80366b:	6a 00                	push   $0x0
  80366d:	6a 00                	push   $0x0
  80366f:	6a 00                	push   $0x0
  803671:	6a 00                	push   $0x0
  803673:	6a 00                	push   $0x0
  803675:	6a 02                	push   $0x2
  803677:	e8 96 ff ff ff       	call   803612 <syscall>
  80367c:	83 c4 18             	add    $0x18,%esp
}
  80367f:	c9                   	leave  
  803680:	c3                   	ret    

00803681 <sys_lock_cons>:

void sys_lock_cons(void)
{
  803681:	55                   	push   %ebp
  803682:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  803684:	6a 00                	push   $0x0
  803686:	6a 00                	push   $0x0
  803688:	6a 00                	push   $0x0
  80368a:	6a 00                	push   $0x0
  80368c:	6a 00                	push   $0x0
  80368e:	6a 03                	push   $0x3
  803690:	e8 7d ff ff ff       	call   803612 <syscall>
  803695:	83 c4 18             	add    $0x18,%esp
}
  803698:	90                   	nop
  803699:	c9                   	leave  
  80369a:	c3                   	ret    

0080369b <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  80369b:	55                   	push   %ebp
  80369c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  80369e:	6a 00                	push   $0x0
  8036a0:	6a 00                	push   $0x0
  8036a2:	6a 00                	push   $0x0
  8036a4:	6a 00                	push   $0x0
  8036a6:	6a 00                	push   $0x0
  8036a8:	6a 04                	push   $0x4
  8036aa:	e8 63 ff ff ff       	call   803612 <syscall>
  8036af:	83 c4 18             	add    $0x18,%esp
}
  8036b2:	90                   	nop
  8036b3:	c9                   	leave  
  8036b4:	c3                   	ret    

008036b5 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8036b5:	55                   	push   %ebp
  8036b6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8036b8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8036bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8036be:	6a 00                	push   $0x0
  8036c0:	6a 00                	push   $0x0
  8036c2:	6a 00                	push   $0x0
  8036c4:	52                   	push   %edx
  8036c5:	50                   	push   %eax
  8036c6:	6a 08                	push   $0x8
  8036c8:	e8 45 ff ff ff       	call   803612 <syscall>
  8036cd:	83 c4 18             	add    $0x18,%esp
}
  8036d0:	c9                   	leave  
  8036d1:	c3                   	ret    

008036d2 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8036d2:	55                   	push   %ebp
  8036d3:	89 e5                	mov    %esp,%ebp
  8036d5:	56                   	push   %esi
  8036d6:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8036d7:	8b 75 18             	mov    0x18(%ebp),%esi
  8036da:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8036dd:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8036e0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8036e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8036e6:	56                   	push   %esi
  8036e7:	53                   	push   %ebx
  8036e8:	51                   	push   %ecx
  8036e9:	52                   	push   %edx
  8036ea:	50                   	push   %eax
  8036eb:	6a 09                	push   $0x9
  8036ed:	e8 20 ff ff ff       	call   803612 <syscall>
  8036f2:	83 c4 18             	add    $0x18,%esp
}
  8036f5:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8036f8:	5b                   	pop    %ebx
  8036f9:	5e                   	pop    %esi
  8036fa:	5d                   	pop    %ebp
  8036fb:	c3                   	ret    

008036fc <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  8036fc:	55                   	push   %ebp
  8036fd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  8036ff:	6a 00                	push   $0x0
  803701:	6a 00                	push   $0x0
  803703:	6a 00                	push   $0x0
  803705:	6a 00                	push   $0x0
  803707:	ff 75 08             	pushl  0x8(%ebp)
  80370a:	6a 0a                	push   $0xa
  80370c:	e8 01 ff ff ff       	call   803612 <syscall>
  803711:	83 c4 18             	add    $0x18,%esp
}
  803714:	c9                   	leave  
  803715:	c3                   	ret    

00803716 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  803716:	55                   	push   %ebp
  803717:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  803719:	6a 00                	push   $0x0
  80371b:	6a 00                	push   $0x0
  80371d:	6a 00                	push   $0x0
  80371f:	ff 75 0c             	pushl  0xc(%ebp)
  803722:	ff 75 08             	pushl  0x8(%ebp)
  803725:	6a 0b                	push   $0xb
  803727:	e8 e6 fe ff ff       	call   803612 <syscall>
  80372c:	83 c4 18             	add    $0x18,%esp
}
  80372f:	c9                   	leave  
  803730:	c3                   	ret    

00803731 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  803731:	55                   	push   %ebp
  803732:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  803734:	6a 00                	push   $0x0
  803736:	6a 00                	push   $0x0
  803738:	6a 00                	push   $0x0
  80373a:	6a 00                	push   $0x0
  80373c:	6a 00                	push   $0x0
  80373e:	6a 0c                	push   $0xc
  803740:	e8 cd fe ff ff       	call   803612 <syscall>
  803745:	83 c4 18             	add    $0x18,%esp
}
  803748:	c9                   	leave  
  803749:	c3                   	ret    

0080374a <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  80374a:	55                   	push   %ebp
  80374b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  80374d:	6a 00                	push   $0x0
  80374f:	6a 00                	push   $0x0
  803751:	6a 00                	push   $0x0
  803753:	6a 00                	push   $0x0
  803755:	6a 00                	push   $0x0
  803757:	6a 0d                	push   $0xd
  803759:	e8 b4 fe ff ff       	call   803612 <syscall>
  80375e:	83 c4 18             	add    $0x18,%esp
}
  803761:	c9                   	leave  
  803762:	c3                   	ret    

00803763 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  803763:	55                   	push   %ebp
  803764:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  803766:	6a 00                	push   $0x0
  803768:	6a 00                	push   $0x0
  80376a:	6a 00                	push   $0x0
  80376c:	6a 00                	push   $0x0
  80376e:	6a 00                	push   $0x0
  803770:	6a 0e                	push   $0xe
  803772:	e8 9b fe ff ff       	call   803612 <syscall>
  803777:	83 c4 18             	add    $0x18,%esp
}
  80377a:	c9                   	leave  
  80377b:	c3                   	ret    

0080377c <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  80377c:	55                   	push   %ebp
  80377d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  80377f:	6a 00                	push   $0x0
  803781:	6a 00                	push   $0x0
  803783:	6a 00                	push   $0x0
  803785:	6a 00                	push   $0x0
  803787:	6a 00                	push   $0x0
  803789:	6a 0f                	push   $0xf
  80378b:	e8 82 fe ff ff       	call   803612 <syscall>
  803790:	83 c4 18             	add    $0x18,%esp
}
  803793:	c9                   	leave  
  803794:	c3                   	ret    

00803795 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  803795:	55                   	push   %ebp
  803796:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  803798:	6a 00                	push   $0x0
  80379a:	6a 00                	push   $0x0
  80379c:	6a 00                	push   $0x0
  80379e:	6a 00                	push   $0x0
  8037a0:	ff 75 08             	pushl  0x8(%ebp)
  8037a3:	6a 10                	push   $0x10
  8037a5:	e8 68 fe ff ff       	call   803612 <syscall>
  8037aa:	83 c4 18             	add    $0x18,%esp
}
  8037ad:	c9                   	leave  
  8037ae:	c3                   	ret    

008037af <sys_scarce_memory>:

void sys_scarce_memory()
{
  8037af:	55                   	push   %ebp
  8037b0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8037b2:	6a 00                	push   $0x0
  8037b4:	6a 00                	push   $0x0
  8037b6:	6a 00                	push   $0x0
  8037b8:	6a 00                	push   $0x0
  8037ba:	6a 00                	push   $0x0
  8037bc:	6a 11                	push   $0x11
  8037be:	e8 4f fe ff ff       	call   803612 <syscall>
  8037c3:	83 c4 18             	add    $0x18,%esp
}
  8037c6:	90                   	nop
  8037c7:	c9                   	leave  
  8037c8:	c3                   	ret    

008037c9 <sys_cputc>:

void
sys_cputc(const char c)
{
  8037c9:	55                   	push   %ebp
  8037ca:	89 e5                	mov    %esp,%ebp
  8037cc:	83 ec 04             	sub    $0x4,%esp
  8037cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8037d2:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8037d5:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8037d9:	6a 00                	push   $0x0
  8037db:	6a 00                	push   $0x0
  8037dd:	6a 00                	push   $0x0
  8037df:	6a 00                	push   $0x0
  8037e1:	50                   	push   %eax
  8037e2:	6a 01                	push   $0x1
  8037e4:	e8 29 fe ff ff       	call   803612 <syscall>
  8037e9:	83 c4 18             	add    $0x18,%esp
}
  8037ec:	90                   	nop
  8037ed:	c9                   	leave  
  8037ee:	c3                   	ret    

008037ef <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8037ef:	55                   	push   %ebp
  8037f0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8037f2:	6a 00                	push   $0x0
  8037f4:	6a 00                	push   $0x0
  8037f6:	6a 00                	push   $0x0
  8037f8:	6a 00                	push   $0x0
  8037fa:	6a 00                	push   $0x0
  8037fc:	6a 14                	push   $0x14
  8037fe:	e8 0f fe ff ff       	call   803612 <syscall>
  803803:	83 c4 18             	add    $0x18,%esp
}
  803806:	90                   	nop
  803807:	c9                   	leave  
  803808:	c3                   	ret    

00803809 <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  803809:	55                   	push   %ebp
  80380a:	89 e5                	mov    %esp,%ebp
  80380c:	83 ec 04             	sub    $0x4,%esp
  80380f:	8b 45 10             	mov    0x10(%ebp),%eax
  803812:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  803815:	8b 4d 14             	mov    0x14(%ebp),%ecx
  803818:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80381c:	8b 45 08             	mov    0x8(%ebp),%eax
  80381f:	6a 00                	push   $0x0
  803821:	51                   	push   %ecx
  803822:	52                   	push   %edx
  803823:	ff 75 0c             	pushl  0xc(%ebp)
  803826:	50                   	push   %eax
  803827:	6a 15                	push   $0x15
  803829:	e8 e4 fd ff ff       	call   803612 <syscall>
  80382e:	83 c4 18             	add    $0x18,%esp
}
  803831:	c9                   	leave  
  803832:	c3                   	ret    

00803833 <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  803833:	55                   	push   %ebp
  803834:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  803836:	8b 55 0c             	mov    0xc(%ebp),%edx
  803839:	8b 45 08             	mov    0x8(%ebp),%eax
  80383c:	6a 00                	push   $0x0
  80383e:	6a 00                	push   $0x0
  803840:	6a 00                	push   $0x0
  803842:	52                   	push   %edx
  803843:	50                   	push   %eax
  803844:	6a 16                	push   $0x16
  803846:	e8 c7 fd ff ff       	call   803612 <syscall>
  80384b:	83 c4 18             	add    $0x18,%esp
}
  80384e:	c9                   	leave  
  80384f:	c3                   	ret    

00803850 <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  803850:	55                   	push   %ebp
  803851:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  803853:	8b 4d 10             	mov    0x10(%ebp),%ecx
  803856:	8b 55 0c             	mov    0xc(%ebp),%edx
  803859:	8b 45 08             	mov    0x8(%ebp),%eax
  80385c:	6a 00                	push   $0x0
  80385e:	6a 00                	push   $0x0
  803860:	51                   	push   %ecx
  803861:	52                   	push   %edx
  803862:	50                   	push   %eax
  803863:	6a 17                	push   $0x17
  803865:	e8 a8 fd ff ff       	call   803612 <syscall>
  80386a:	83 c4 18             	add    $0x18,%esp
}
  80386d:	c9                   	leave  
  80386e:	c3                   	ret    

0080386f <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  80386f:	55                   	push   %ebp
  803870:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  803872:	8b 55 0c             	mov    0xc(%ebp),%edx
  803875:	8b 45 08             	mov    0x8(%ebp),%eax
  803878:	6a 00                	push   $0x0
  80387a:	6a 00                	push   $0x0
  80387c:	6a 00                	push   $0x0
  80387e:	52                   	push   %edx
  80387f:	50                   	push   %eax
  803880:	6a 18                	push   $0x18
  803882:	e8 8b fd ff ff       	call   803612 <syscall>
  803887:	83 c4 18             	add    $0x18,%esp
}
  80388a:	c9                   	leave  
  80388b:	c3                   	ret    

0080388c <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  80388c:	55                   	push   %ebp
  80388d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  80388f:	8b 45 08             	mov    0x8(%ebp),%eax
  803892:	6a 00                	push   $0x0
  803894:	ff 75 14             	pushl  0x14(%ebp)
  803897:	ff 75 10             	pushl  0x10(%ebp)
  80389a:	ff 75 0c             	pushl  0xc(%ebp)
  80389d:	50                   	push   %eax
  80389e:	6a 19                	push   $0x19
  8038a0:	e8 6d fd ff ff       	call   803612 <syscall>
  8038a5:	83 c4 18             	add    $0x18,%esp
}
  8038a8:	c9                   	leave  
  8038a9:	c3                   	ret    

008038aa <sys_run_env>:

void sys_run_env(int32 envId)
{
  8038aa:	55                   	push   %ebp
  8038ab:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8038ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8038b0:	6a 00                	push   $0x0
  8038b2:	6a 00                	push   $0x0
  8038b4:	6a 00                	push   $0x0
  8038b6:	6a 00                	push   $0x0
  8038b8:	50                   	push   %eax
  8038b9:	6a 1a                	push   $0x1a
  8038bb:	e8 52 fd ff ff       	call   803612 <syscall>
  8038c0:	83 c4 18             	add    $0x18,%esp
}
  8038c3:	90                   	nop
  8038c4:	c9                   	leave  
  8038c5:	c3                   	ret    

008038c6 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8038c6:	55                   	push   %ebp
  8038c7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8038c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8038cc:	6a 00                	push   $0x0
  8038ce:	6a 00                	push   $0x0
  8038d0:	6a 00                	push   $0x0
  8038d2:	6a 00                	push   $0x0
  8038d4:	50                   	push   %eax
  8038d5:	6a 1b                	push   $0x1b
  8038d7:	e8 36 fd ff ff       	call   803612 <syscall>
  8038dc:	83 c4 18             	add    $0x18,%esp
}
  8038df:	c9                   	leave  
  8038e0:	c3                   	ret    

008038e1 <sys_getenvid>:

int32 sys_getenvid(void)
{
  8038e1:	55                   	push   %ebp
  8038e2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8038e4:	6a 00                	push   $0x0
  8038e6:	6a 00                	push   $0x0
  8038e8:	6a 00                	push   $0x0
  8038ea:	6a 00                	push   $0x0
  8038ec:	6a 00                	push   $0x0
  8038ee:	6a 05                	push   $0x5
  8038f0:	e8 1d fd ff ff       	call   803612 <syscall>
  8038f5:	83 c4 18             	add    $0x18,%esp
}
  8038f8:	c9                   	leave  
  8038f9:	c3                   	ret    

008038fa <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8038fa:	55                   	push   %ebp
  8038fb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8038fd:	6a 00                	push   $0x0
  8038ff:	6a 00                	push   $0x0
  803901:	6a 00                	push   $0x0
  803903:	6a 00                	push   $0x0
  803905:	6a 00                	push   $0x0
  803907:	6a 06                	push   $0x6
  803909:	e8 04 fd ff ff       	call   803612 <syscall>
  80390e:	83 c4 18             	add    $0x18,%esp
}
  803911:	c9                   	leave  
  803912:	c3                   	ret    

00803913 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  803913:	55                   	push   %ebp
  803914:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  803916:	6a 00                	push   $0x0
  803918:	6a 00                	push   $0x0
  80391a:	6a 00                	push   $0x0
  80391c:	6a 00                	push   $0x0
  80391e:	6a 00                	push   $0x0
  803920:	6a 07                	push   $0x7
  803922:	e8 eb fc ff ff       	call   803612 <syscall>
  803927:	83 c4 18             	add    $0x18,%esp
}
  80392a:	c9                   	leave  
  80392b:	c3                   	ret    

0080392c <sys_exit_env>:


void sys_exit_env(void)
{
  80392c:	55                   	push   %ebp
  80392d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  80392f:	6a 00                	push   $0x0
  803931:	6a 00                	push   $0x0
  803933:	6a 00                	push   $0x0
  803935:	6a 00                	push   $0x0
  803937:	6a 00                	push   $0x0
  803939:	6a 1c                	push   $0x1c
  80393b:	e8 d2 fc ff ff       	call   803612 <syscall>
  803940:	83 c4 18             	add    $0x18,%esp
}
  803943:	90                   	nop
  803944:	c9                   	leave  
  803945:	c3                   	ret    

00803946 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  803946:	55                   	push   %ebp
  803947:	89 e5                	mov    %esp,%ebp
  803949:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  80394c:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80394f:	8d 50 04             	lea    0x4(%eax),%edx
  803952:	8d 45 f8             	lea    -0x8(%ebp),%eax
  803955:	6a 00                	push   $0x0
  803957:	6a 00                	push   $0x0
  803959:	6a 00                	push   $0x0
  80395b:	52                   	push   %edx
  80395c:	50                   	push   %eax
  80395d:	6a 1d                	push   $0x1d
  80395f:	e8 ae fc ff ff       	call   803612 <syscall>
  803964:	83 c4 18             	add    $0x18,%esp
	return result;
  803967:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80396a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80396d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  803970:	89 01                	mov    %eax,(%ecx)
  803972:	89 51 04             	mov    %edx,0x4(%ecx)
}
  803975:	8b 45 08             	mov    0x8(%ebp),%eax
  803978:	c9                   	leave  
  803979:	c2 04 00             	ret    $0x4

0080397c <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  80397c:	55                   	push   %ebp
  80397d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  80397f:	6a 00                	push   $0x0
  803981:	6a 00                	push   $0x0
  803983:	ff 75 10             	pushl  0x10(%ebp)
  803986:	ff 75 0c             	pushl  0xc(%ebp)
  803989:	ff 75 08             	pushl  0x8(%ebp)
  80398c:	6a 13                	push   $0x13
  80398e:	e8 7f fc ff ff       	call   803612 <syscall>
  803993:	83 c4 18             	add    $0x18,%esp
	return ;
  803996:	90                   	nop
}
  803997:	c9                   	leave  
  803998:	c3                   	ret    

00803999 <sys_rcr2>:
uint32 sys_rcr2()
{
  803999:	55                   	push   %ebp
  80399a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  80399c:	6a 00                	push   $0x0
  80399e:	6a 00                	push   $0x0
  8039a0:	6a 00                	push   $0x0
  8039a2:	6a 00                	push   $0x0
  8039a4:	6a 00                	push   $0x0
  8039a6:	6a 1e                	push   $0x1e
  8039a8:	e8 65 fc ff ff       	call   803612 <syscall>
  8039ad:	83 c4 18             	add    $0x18,%esp
}
  8039b0:	c9                   	leave  
  8039b1:	c3                   	ret    

008039b2 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  8039b2:	55                   	push   %ebp
  8039b3:	89 e5                	mov    %esp,%ebp
  8039b5:	83 ec 04             	sub    $0x4,%esp
  8039b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8039bb:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8039be:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8039c2:	6a 00                	push   $0x0
  8039c4:	6a 00                	push   $0x0
  8039c6:	6a 00                	push   $0x0
  8039c8:	6a 00                	push   $0x0
  8039ca:	50                   	push   %eax
  8039cb:	6a 1f                	push   $0x1f
  8039cd:	e8 40 fc ff ff       	call   803612 <syscall>
  8039d2:	83 c4 18             	add    $0x18,%esp
	return ;
  8039d5:	90                   	nop
}
  8039d6:	c9                   	leave  
  8039d7:	c3                   	ret    

008039d8 <rsttst>:
void rsttst()
{
  8039d8:	55                   	push   %ebp
  8039d9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8039db:	6a 00                	push   $0x0
  8039dd:	6a 00                	push   $0x0
  8039df:	6a 00                	push   $0x0
  8039e1:	6a 00                	push   $0x0
  8039e3:	6a 00                	push   $0x0
  8039e5:	6a 21                	push   $0x21
  8039e7:	e8 26 fc ff ff       	call   803612 <syscall>
  8039ec:	83 c4 18             	add    $0x18,%esp
	return ;
  8039ef:	90                   	nop
}
  8039f0:	c9                   	leave  
  8039f1:	c3                   	ret    

008039f2 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8039f2:	55                   	push   %ebp
  8039f3:	89 e5                	mov    %esp,%ebp
  8039f5:	83 ec 04             	sub    $0x4,%esp
  8039f8:	8b 45 14             	mov    0x14(%ebp),%eax
  8039fb:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8039fe:	8b 55 18             	mov    0x18(%ebp),%edx
  803a01:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  803a05:	52                   	push   %edx
  803a06:	50                   	push   %eax
  803a07:	ff 75 10             	pushl  0x10(%ebp)
  803a0a:	ff 75 0c             	pushl  0xc(%ebp)
  803a0d:	ff 75 08             	pushl  0x8(%ebp)
  803a10:	6a 20                	push   $0x20
  803a12:	e8 fb fb ff ff       	call   803612 <syscall>
  803a17:	83 c4 18             	add    $0x18,%esp
	return ;
  803a1a:	90                   	nop
}
  803a1b:	c9                   	leave  
  803a1c:	c3                   	ret    

00803a1d <chktst>:
void chktst(uint32 n)
{
  803a1d:	55                   	push   %ebp
  803a1e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  803a20:	6a 00                	push   $0x0
  803a22:	6a 00                	push   $0x0
  803a24:	6a 00                	push   $0x0
  803a26:	6a 00                	push   $0x0
  803a28:	ff 75 08             	pushl  0x8(%ebp)
  803a2b:	6a 22                	push   $0x22
  803a2d:	e8 e0 fb ff ff       	call   803612 <syscall>
  803a32:	83 c4 18             	add    $0x18,%esp
	return ;
  803a35:	90                   	nop
}
  803a36:	c9                   	leave  
  803a37:	c3                   	ret    

00803a38 <inctst>:

void inctst()
{
  803a38:	55                   	push   %ebp
  803a39:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  803a3b:	6a 00                	push   $0x0
  803a3d:	6a 00                	push   $0x0
  803a3f:	6a 00                	push   $0x0
  803a41:	6a 00                	push   $0x0
  803a43:	6a 00                	push   $0x0
  803a45:	6a 23                	push   $0x23
  803a47:	e8 c6 fb ff ff       	call   803612 <syscall>
  803a4c:	83 c4 18             	add    $0x18,%esp
	return ;
  803a4f:	90                   	nop
}
  803a50:	c9                   	leave  
  803a51:	c3                   	ret    

00803a52 <gettst>:
uint32 gettst()
{
  803a52:	55                   	push   %ebp
  803a53:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  803a55:	6a 00                	push   $0x0
  803a57:	6a 00                	push   $0x0
  803a59:	6a 00                	push   $0x0
  803a5b:	6a 00                	push   $0x0
  803a5d:	6a 00                	push   $0x0
  803a5f:	6a 24                	push   $0x24
  803a61:	e8 ac fb ff ff       	call   803612 <syscall>
  803a66:	83 c4 18             	add    $0x18,%esp
}
  803a69:	c9                   	leave  
  803a6a:	c3                   	ret    

00803a6b <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  803a6b:	55                   	push   %ebp
  803a6c:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  803a6e:	6a 00                	push   $0x0
  803a70:	6a 00                	push   $0x0
  803a72:	6a 00                	push   $0x0
  803a74:	6a 00                	push   $0x0
  803a76:	6a 00                	push   $0x0
  803a78:	6a 25                	push   $0x25
  803a7a:	e8 93 fb ff ff       	call   803612 <syscall>
  803a7f:	83 c4 18             	add    $0x18,%esp
  803a82:	a3 60 e0 81 00       	mov    %eax,0x81e060
	return uheapPlaceStrategy ;
  803a87:	a1 60 e0 81 00       	mov    0x81e060,%eax
}
  803a8c:	c9                   	leave  
  803a8d:	c3                   	ret    

00803a8e <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  803a8e:	55                   	push   %ebp
  803a8f:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  803a91:	8b 45 08             	mov    0x8(%ebp),%eax
  803a94:	a3 60 e0 81 00       	mov    %eax,0x81e060
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  803a99:	6a 00                	push   $0x0
  803a9b:	6a 00                	push   $0x0
  803a9d:	6a 00                	push   $0x0
  803a9f:	6a 00                	push   $0x0
  803aa1:	ff 75 08             	pushl  0x8(%ebp)
  803aa4:	6a 26                	push   $0x26
  803aa6:	e8 67 fb ff ff       	call   803612 <syscall>
  803aab:	83 c4 18             	add    $0x18,%esp
	return ;
  803aae:	90                   	nop
}
  803aaf:	c9                   	leave  
  803ab0:	c3                   	ret    

00803ab1 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  803ab1:	55                   	push   %ebp
  803ab2:	89 e5                	mov    %esp,%ebp
  803ab4:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  803ab5:	8b 5d 14             	mov    0x14(%ebp),%ebx
  803ab8:	8b 4d 10             	mov    0x10(%ebp),%ecx
  803abb:	8b 55 0c             	mov    0xc(%ebp),%edx
  803abe:	8b 45 08             	mov    0x8(%ebp),%eax
  803ac1:	6a 00                	push   $0x0
  803ac3:	53                   	push   %ebx
  803ac4:	51                   	push   %ecx
  803ac5:	52                   	push   %edx
  803ac6:	50                   	push   %eax
  803ac7:	6a 27                	push   $0x27
  803ac9:	e8 44 fb ff ff       	call   803612 <syscall>
  803ace:	83 c4 18             	add    $0x18,%esp
}
  803ad1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  803ad4:	c9                   	leave  
  803ad5:	c3                   	ret    

00803ad6 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  803ad6:	55                   	push   %ebp
  803ad7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  803ad9:	8b 55 0c             	mov    0xc(%ebp),%edx
  803adc:	8b 45 08             	mov    0x8(%ebp),%eax
  803adf:	6a 00                	push   $0x0
  803ae1:	6a 00                	push   $0x0
  803ae3:	6a 00                	push   $0x0
  803ae5:	52                   	push   %edx
  803ae6:	50                   	push   %eax
  803ae7:	6a 28                	push   $0x28
  803ae9:	e8 24 fb ff ff       	call   803612 <syscall>
  803aee:	83 c4 18             	add    $0x18,%esp
}
  803af1:	c9                   	leave  
  803af2:	c3                   	ret    

00803af3 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  803af3:	55                   	push   %ebp
  803af4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  803af6:	8b 4d 14             	mov    0x14(%ebp),%ecx
  803af9:	8b 55 0c             	mov    0xc(%ebp),%edx
  803afc:	8b 45 08             	mov    0x8(%ebp),%eax
  803aff:	6a 00                	push   $0x0
  803b01:	51                   	push   %ecx
  803b02:	ff 75 10             	pushl  0x10(%ebp)
  803b05:	52                   	push   %edx
  803b06:	50                   	push   %eax
  803b07:	6a 29                	push   $0x29
  803b09:	e8 04 fb ff ff       	call   803612 <syscall>
  803b0e:	83 c4 18             	add    $0x18,%esp
}
  803b11:	c9                   	leave  
  803b12:	c3                   	ret    

00803b13 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  803b13:	55                   	push   %ebp
  803b14:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  803b16:	6a 00                	push   $0x0
  803b18:	6a 00                	push   $0x0
  803b1a:	ff 75 10             	pushl  0x10(%ebp)
  803b1d:	ff 75 0c             	pushl  0xc(%ebp)
  803b20:	ff 75 08             	pushl  0x8(%ebp)
  803b23:	6a 12                	push   $0x12
  803b25:	e8 e8 fa ff ff       	call   803612 <syscall>
  803b2a:	83 c4 18             	add    $0x18,%esp
	return ;
  803b2d:	90                   	nop
}
  803b2e:	c9                   	leave  
  803b2f:	c3                   	ret    

00803b30 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  803b30:	55                   	push   %ebp
  803b31:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  803b33:	8b 55 0c             	mov    0xc(%ebp),%edx
  803b36:	8b 45 08             	mov    0x8(%ebp),%eax
  803b39:	6a 00                	push   $0x0
  803b3b:	6a 00                	push   $0x0
  803b3d:	6a 00                	push   $0x0
  803b3f:	52                   	push   %edx
  803b40:	50                   	push   %eax
  803b41:	6a 2a                	push   $0x2a
  803b43:	e8 ca fa ff ff       	call   803612 <syscall>
  803b48:	83 c4 18             	add    $0x18,%esp
	return;
  803b4b:	90                   	nop
}
  803b4c:	c9                   	leave  
  803b4d:	c3                   	ret    

00803b4e <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  803b4e:	55                   	push   %ebp
  803b4f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  803b51:	6a 00                	push   $0x0
  803b53:	6a 00                	push   $0x0
  803b55:	6a 00                	push   $0x0
  803b57:	6a 00                	push   $0x0
  803b59:	6a 00                	push   $0x0
  803b5b:	6a 2b                	push   $0x2b
  803b5d:	e8 b0 fa ff ff       	call   803612 <syscall>
  803b62:	83 c4 18             	add    $0x18,%esp
}
  803b65:	c9                   	leave  
  803b66:	c3                   	ret    

00803b67 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  803b67:	55                   	push   %ebp
  803b68:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  803b6a:	6a 00                	push   $0x0
  803b6c:	6a 00                	push   $0x0
  803b6e:	6a 00                	push   $0x0
  803b70:	ff 75 0c             	pushl  0xc(%ebp)
  803b73:	ff 75 08             	pushl  0x8(%ebp)
  803b76:	6a 2d                	push   $0x2d
  803b78:	e8 95 fa ff ff       	call   803612 <syscall>
  803b7d:	83 c4 18             	add    $0x18,%esp
	return;
  803b80:	90                   	nop
}
  803b81:	c9                   	leave  
  803b82:	c3                   	ret    

00803b83 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  803b83:	55                   	push   %ebp
  803b84:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  803b86:	6a 00                	push   $0x0
  803b88:	6a 00                	push   $0x0
  803b8a:	6a 00                	push   $0x0
  803b8c:	ff 75 0c             	pushl  0xc(%ebp)
  803b8f:	ff 75 08             	pushl  0x8(%ebp)
  803b92:	6a 2c                	push   $0x2c
  803b94:	e8 79 fa ff ff       	call   803612 <syscall>
  803b99:	83 c4 18             	add    $0x18,%esp
	return ;
  803b9c:	90                   	nop
}
  803b9d:	c9                   	leave  
  803b9e:	c3                   	ret    

00803b9f <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  803b9f:	55                   	push   %ebp
  803ba0:	89 e5                	mov    %esp,%ebp
	//TODO: [PROJECT'25.IM#4] CPU SCHEDULING - #1 System Calls - Add suitable code here
	//Your code is here
	//Comment the following line
	//panic("sys_env_set_priority() is not implemented yet...!!");
	syscall(SYS_env_set_priority, envID, priority, 0, 0, 0);
  803ba2:	8b 55 0c             	mov    0xc(%ebp),%edx
  803ba5:	8b 45 08             	mov    0x8(%ebp),%eax
  803ba8:	6a 00                	push   $0x0
  803baa:	6a 00                	push   $0x0
  803bac:	6a 00                	push   $0x0
  803bae:	52                   	push   %edx
  803baf:	50                   	push   %eax
  803bb0:	6a 2e                	push   $0x2e
  803bb2:	e8 5b fa ff ff       	call   803612 <syscall>
  803bb7:	83 c4 18             	add    $0x18,%esp
	    return;
  803bba:	90                   	nop
}
  803bbb:	c9                   	leave  
  803bbc:	c3                   	ret    

00803bbd <to_page_va>:
//==================================================================================//
//==================================
// [1] GET PAGE VA:
//==================================
__inline__ uint32 to_page_va(struct PageInfoElement *ptrPageInfo)
{
  803bbd:	55                   	push   %ebp
  803bbe:	89 e5                	mov    %esp,%ebp
  803bc0:	83 ec 10             	sub    $0x10,%esp
	//Get start VA of the page from the corresponding Page Info pointer
	int idxInPageInfoArr = (ptrPageInfo - pageBlockInfoArr);
  803bc3:	8b 45 08             	mov    0x8(%ebp),%eax
  803bc6:	ba 60 60 80 00       	mov    $0x806060,%edx
  803bcb:	29 d0                	sub    %edx,%eax
  803bcd:	c1 f8 02             	sar    $0x2,%eax
  803bd0:	89 c2                	mov    %eax,%edx
  803bd2:	89 d0                	mov    %edx,%eax
  803bd4:	c1 e0 02             	shl    $0x2,%eax
  803bd7:	01 d0                	add    %edx,%eax
  803bd9:	c1 e0 02             	shl    $0x2,%eax
  803bdc:	01 d0                	add    %edx,%eax
  803bde:	c1 e0 02             	shl    $0x2,%eax
  803be1:	01 d0                	add    %edx,%eax
  803be3:	89 c1                	mov    %eax,%ecx
  803be5:	c1 e1 08             	shl    $0x8,%ecx
  803be8:	01 c8                	add    %ecx,%eax
  803bea:	89 c1                	mov    %eax,%ecx
  803bec:	c1 e1 10             	shl    $0x10,%ecx
  803bef:	01 c8                	add    %ecx,%eax
  803bf1:	01 c0                	add    %eax,%eax
  803bf3:	01 d0                	add    %edx,%eax
  803bf5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return dynAllocStart + (idxInPageInfoArr << PGSHIFT);
  803bf8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  803bfb:	c1 e0 0c             	shl    $0xc,%eax
  803bfe:	89 c2                	mov    %eax,%edx
  803c00:	a1 64 e0 81 00       	mov    0x81e064,%eax
  803c05:	01 d0                	add    %edx,%eax
}
  803c07:	c9                   	leave  
  803c08:	c3                   	ret    

00803c09 <log2>:

//==================================================================================//
//============================ REQUIRED FUNCTIONS ==================================//
//==================================================================================//
__inline__ int log2(uint32 n)
	{
  803c09:	55                   	push   %ebp
  803c0a:	89 e5                	mov    %esp,%ebp
  803c0c:	83 ec 10             	sub    $0x10,%esp
		int result = 0;
  803c0f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
		while( n > 1){
  803c16:	eb 06                	jmp    803c1e <log2+0x15>
			n >>=1;
  803c18:	d1 6d 08             	shrl   0x8(%ebp)
			result++;
  803c1b:	ff 45 fc             	incl   -0x4(%ebp)
//============================ REQUIRED FUNCTIONS ==================================//
//==================================================================================//
__inline__ int log2(uint32 n)
	{
		int result = 0;
		while( n > 1){
  803c1e:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
  803c22:	77 f4                	ja     803c18 <log2+0xf>
			n >>=1;
			result++;
		}
		return result;
  803c24:	8b 45 fc             	mov    -0x4(%ebp),%eax
	}
  803c27:	c9                   	leave  
  803c28:	c3                   	ret    

00803c29 <initialize_dynamic_allocator>:
//==================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================
bool is_initialized = 0;
void initialize_dynamic_allocator(uint32 daStart, uint32 daEnd)
{
  803c29:	55                   	push   %ebp
  803c2a:	89 e5                	mov    %esp,%ebp
  803c2c:	83 ec 18             	sub    $0x18,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(daEnd <= daStart + DYN_ALLOC_MAX_SIZE);
  803c2f:	8b 45 08             	mov    0x8(%ebp),%eax
  803c32:	05 00 00 00 02       	add    $0x2000000,%eax
  803c37:	3b 45 0c             	cmp    0xc(%ebp),%eax
  803c3a:	73 16                	jae    803c52 <initialize_dynamic_allocator+0x29>
  803c3c:	68 8c 53 80 00       	push   $0x80538c
  803c41:	68 b2 53 80 00       	push   $0x8053b2
  803c46:	6a 2d                	push   $0x2d
  803c48:	68 c7 53 80 00       	push   $0x8053c7
  803c4d:	e8 9e cc ff ff       	call   8008f0 <_panic>
		is_initialized = 1;
  803c52:	c7 05 28 60 80 00 01 	movl   $0x1,0x806028
  803c59:	00 00 00 
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #1 initialize_dynamic_allocator
	//Your code is here


	dynAllocStart = daStart;
  803c5c:	8b 45 08             	mov    0x8(%ebp),%eax
  803c5f:	a3 64 e0 81 00       	mov    %eax,0x81e064
	dynAllocEnd= daEnd;
  803c64:	8b 45 0c             	mov    0xc(%ebp),%eax
  803c67:	a3 40 60 80 00       	mov    %eax,0x806040
	int numOfPages = (dynAllocEnd - dynAllocStart)/PAGE_SIZE;
  803c6c:	8b 15 40 60 80 00    	mov    0x806040,%edx
  803c72:	a1 64 e0 81 00       	mov    0x81e064,%eax
  803c77:	29 c2                	sub    %eax,%edx
  803c79:	89 d0                	mov    %edx,%eax
  803c7b:	c1 e8 0c             	shr    $0xc,%eax
  803c7e:	89 45 e8             	mov    %eax,-0x18(%ebp)


	for(int i=0; i< numOfPages; i++){
  803c81:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  803c88:	eb 2f                	jmp    803cb9 <initialize_dynamic_allocator+0x90>
	    pageBlockInfoArr[i].block_size=0;
  803c8a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803c8d:	89 d0                	mov    %edx,%eax
  803c8f:	01 c0                	add    %eax,%eax
  803c91:	01 d0                	add    %edx,%eax
  803c93:	c1 e0 02             	shl    $0x2,%eax
  803c96:	05 68 60 80 00       	add    $0x806068,%eax
  803c9b:	66 c7 00 00 00       	movw   $0x0,(%eax)
	    pageBlockInfoArr[i].num_of_free_blocks=0;
  803ca0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803ca3:	89 d0                	mov    %edx,%eax
  803ca5:	01 c0                	add    %eax,%eax
  803ca7:	01 d0                	add    %edx,%eax
  803ca9:	c1 e0 02             	shl    $0x2,%eax
  803cac:	05 6a 60 80 00       	add    $0x80606a,%eax
  803cb1:	66 c7 00 00 00       	movw   $0x0,(%eax)
	dynAllocStart = daStart;
	dynAllocEnd= daEnd;
	int numOfPages = (dynAllocEnd - dynAllocStart)/PAGE_SIZE;


	for(int i=0; i< numOfPages; i++){
  803cb6:	ff 45 f4             	incl   -0xc(%ebp)
  803cb9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803cbc:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803cbf:	7c c9                	jl     803c8a <initialize_dynamic_allocator+0x61>
	    pageBlockInfoArr[i].block_size=0;
	    pageBlockInfoArr[i].num_of_free_blocks=0;
	}


	LIST_INIT(&freePagesList);
  803cc1:	c7 05 48 60 80 00 00 	movl   $0x0,0x806048
  803cc8:	00 00 00 
  803ccb:	c7 05 4c 60 80 00 00 	movl   $0x0,0x80604c
  803cd2:	00 00 00 
  803cd5:	c7 05 54 60 80 00 00 	movl   $0x0,0x806054
  803cdc:	00 00 00 
	for(int i=0; i<numOfPages; i++){
  803cdf:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  803ce6:	e9 9c 00 00 00       	jmp    803d87 <initialize_dynamic_allocator+0x15e>
		LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
  803ceb:	8b 15 4c 60 80 00    	mov    0x80604c,%edx
  803cf1:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  803cf4:	89 c8                	mov    %ecx,%eax
  803cf6:	01 c0                	add    %eax,%eax
  803cf8:	01 c8                	add    %ecx,%eax
  803cfa:	c1 e0 02             	shl    $0x2,%eax
  803cfd:	05 64 60 80 00       	add    $0x806064,%eax
  803d02:	89 10                	mov    %edx,(%eax)
  803d04:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803d07:	89 d0                	mov    %edx,%eax
  803d09:	01 c0                	add    %eax,%eax
  803d0b:	01 d0                	add    %edx,%eax
  803d0d:	c1 e0 02             	shl    $0x2,%eax
  803d10:	05 64 60 80 00       	add    $0x806064,%eax
  803d15:	8b 00                	mov    (%eax),%eax
  803d17:	85 c0                	test   %eax,%eax
  803d19:	74 1b                	je     803d36 <initialize_dynamic_allocator+0x10d>
  803d1b:	8b 15 4c 60 80 00    	mov    0x80604c,%edx
  803d21:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  803d24:	89 c8                	mov    %ecx,%eax
  803d26:	01 c0                	add    %eax,%eax
  803d28:	01 c8                	add    %ecx,%eax
  803d2a:	c1 e0 02             	shl    $0x2,%eax
  803d2d:	05 60 60 80 00       	add    $0x806060,%eax
  803d32:	89 02                	mov    %eax,(%edx)
  803d34:	eb 16                	jmp    803d4c <initialize_dynamic_allocator+0x123>
  803d36:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803d39:	89 d0                	mov    %edx,%eax
  803d3b:	01 c0                	add    %eax,%eax
  803d3d:	01 d0                	add    %edx,%eax
  803d3f:	c1 e0 02             	shl    $0x2,%eax
  803d42:	05 60 60 80 00       	add    $0x806060,%eax
  803d47:	a3 48 60 80 00       	mov    %eax,0x806048
  803d4c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803d4f:	89 d0                	mov    %edx,%eax
  803d51:	01 c0                	add    %eax,%eax
  803d53:	01 d0                	add    %edx,%eax
  803d55:	c1 e0 02             	shl    $0x2,%eax
  803d58:	05 60 60 80 00       	add    $0x806060,%eax
  803d5d:	a3 4c 60 80 00       	mov    %eax,0x80604c
  803d62:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803d65:	89 d0                	mov    %edx,%eax
  803d67:	01 c0                	add    %eax,%eax
  803d69:	01 d0                	add    %edx,%eax
  803d6b:	c1 e0 02             	shl    $0x2,%eax
  803d6e:	05 60 60 80 00       	add    $0x806060,%eax
  803d73:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803d79:	a1 54 60 80 00       	mov    0x806054,%eax
  803d7e:	40                   	inc    %eax
  803d7f:	a3 54 60 80 00       	mov    %eax,0x806054
	    pageBlockInfoArr[i].num_of_free_blocks=0;
	}


	LIST_INIT(&freePagesList);
	for(int i=0; i<numOfPages; i++){
  803d84:	ff 45 f0             	incl   -0x10(%ebp)
  803d87:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803d8a:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803d8d:	0f 8c 58 ff ff ff    	jl     803ceb <initialize_dynamic_allocator+0xc2>
		LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
	}



	for (int i = 0; i < LOG2_MAX_SIZE - LOG2_MIN_SIZE + 1; i++) {
  803d93:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  803d9a:	eb 36                	jmp    803dd2 <initialize_dynamic_allocator+0x1a9>
	    LIST_INIT(&freeBlockLists[i]);
  803d9c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803d9f:	c1 e0 04             	shl    $0x4,%eax
  803da2:	05 80 e0 81 00       	add    $0x81e080,%eax
  803da7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803dad:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803db0:	c1 e0 04             	shl    $0x4,%eax
  803db3:	05 84 e0 81 00       	add    $0x81e084,%eax
  803db8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803dbe:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803dc1:	c1 e0 04             	shl    $0x4,%eax
  803dc4:	05 8c e0 81 00       	add    $0x81e08c,%eax
  803dc9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
	}



	for (int i = 0; i < LOG2_MAX_SIZE - LOG2_MIN_SIZE + 1; i++) {
  803dcf:	ff 45 ec             	incl   -0x14(%ebp)
  803dd2:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  803dd6:	7e c4                	jle    803d9c <initialize_dynamic_allocator+0x173>


	//Comment the following line
	//panic("initialize_dynamic_allocator() Not implemented yet");

}
  803dd8:	90                   	nop
  803dd9:	c9                   	leave  
  803dda:	c3                   	ret    

00803ddb <get_block_size>:
// [2] GET BLOCK SIZE:
//===========================


__inline__ uint32 get_block_size(void *va)
{
  803ddb:	55                   	push   %ebp
  803ddc:	89 e5                	mov    %esp,%ebp
  803dde:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #2 get_block_size
	//Your code is here

	uint32 page_index = ((uint32)va - dynAllocStart)/ PAGE_SIZE;
  803de1:	8b 55 08             	mov    0x8(%ebp),%edx
  803de4:	a1 64 e0 81 00       	mov    0x81e064,%eax
  803de9:	29 c2                	sub    %eax,%edx
  803deb:	89 d0                	mov    %edx,%eax
  803ded:	c1 e8 0c             	shr    $0xc,%eax
  803df0:	89 45 fc             	mov    %eax,-0x4(%ebp)
    return pageBlockInfoArr[page_index].block_size;
  803df3:	8b 55 fc             	mov    -0x4(%ebp),%edx
  803df6:	89 d0                	mov    %edx,%eax
  803df8:	01 c0                	add    %eax,%eax
  803dfa:	01 d0                	add    %edx,%eax
  803dfc:	c1 e0 02             	shl    $0x2,%eax
  803dff:	05 68 60 80 00       	add    $0x806068,%eax
  803e04:	8b 00                	mov    (%eax),%eax
  803e06:	0f b7 c0             	movzwl %ax,%eax
	//Comment the following line
	//panic("get_block_size() Not implemented yet");
}
  803e09:	c9                   	leave  
  803e0a:	c3                   	ret    

00803e0b <alloc_block>:

//===========================
// 3) ALLOCATE BLOCK:
//===========================
void *alloc_block(uint32 size)
{
  803e0b:	55                   	push   %ebp
  803e0c:	89 e5                	mov    %esp,%ebp
  803e0e:	83 ec 48             	sub    $0x48,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(size <= DYN_ALLOC_MAX_BLOCK_SIZE);
  803e11:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  803e18:	76 16                	jbe    803e30 <alloc_block+0x25>
  803e1a:	68 e0 53 80 00       	push   $0x8053e0
  803e1f:	68 b2 53 80 00       	push   $0x8053b2
  803e24:	6a 6c                	push   $0x6c
  803e26:	68 c7 53 80 00       	push   $0x8053c7
  803e2b:	e8 c0 ca ff ff       	call   8008f0 <_panic>
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #3 alloc_block
	//Your code is here


	if(size == 0){
  803e30:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803e34:	75 0a                	jne    803e40 <alloc_block+0x35>
		return NULL;
  803e36:	b8 00 00 00 00       	mov    $0x0,%eax
  803e3b:	e9 65 04 00 00       	jmp    8042a5 <alloc_block+0x49a>
	}
	else if(size<=8){
  803e40:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  803e44:	77 09                	ja     803e4f <alloc_block+0x44>
		size=8;
  803e46:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
  803e4d:	eb 1f                	jmp    803e6e <alloc_block+0x63>
	}
	else{
		uint32 reqsize=8;
  803e4f:	c7 45 f4 08 00 00 00 	movl   $0x8,-0xc(%ebp)
		while(reqsize < size){
  803e56:	eb 08                	jmp    803e60 <alloc_block+0x55>
			reqsize*=2;
  803e58:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e5b:	01 c0                	add    %eax,%eax
  803e5d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	else if(size<=8){
		size=8;
	}
	else{
		uint32 reqsize=8;
		while(reqsize < size){
  803e60:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e63:	3b 45 08             	cmp    0x8(%ebp),%eax
  803e66:	72 f0                	jb     803e58 <alloc_block+0x4d>
			reqsize*=2;
		}
		size= reqsize;
  803e68:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e6b:	89 45 08             	mov    %eax,0x8(%ebp)
	}

	int list_index = log2(size)- LOG2_MIN_SIZE;
  803e6e:	83 ec 0c             	sub    $0xc,%esp
  803e71:	ff 75 08             	pushl  0x8(%ebp)
  803e74:	e8 90 fd ff ff       	call   803c09 <log2>
  803e79:	83 c4 10             	add    $0x10,%esp
  803e7c:	83 e8 03             	sub    $0x3,%eax
  803e7f:	89 45 e8             	mov    %eax,-0x18(%ebp)

	if(!LIST_EMPTY(&freeBlockLists[list_index])){
  803e82:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803e85:	c1 e0 04             	shl    $0x4,%eax
  803e88:	05 80 e0 81 00       	add    $0x81e080,%eax
  803e8d:	8b 00                	mov    (%eax),%eax
  803e8f:	85 c0                	test   %eax,%eax
  803e91:	0f 84 fb 00 00 00    	je     803f92 <alloc_block+0x187>
		struct BlockElement *block = LIST_FIRST(&freeBlockLists[list_index]);
  803e97:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803e9a:	c1 e0 04             	shl    $0x4,%eax
  803e9d:	05 80 e0 81 00       	add    $0x81e080,%eax
  803ea2:	8b 00                	mov    (%eax),%eax
  803ea4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		LIST_REMOVE(&freeBlockLists[list_index], block);
  803ea7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803eab:	75 17                	jne    803ec4 <alloc_block+0xb9>
  803ead:	83 ec 04             	sub    $0x4,%esp
  803eb0:	68 01 54 80 00       	push   $0x805401
  803eb5:	68 86 00 00 00       	push   $0x86
  803eba:	68 c7 53 80 00       	push   $0x8053c7
  803ebf:	e8 2c ca ff ff       	call   8008f0 <_panic>
  803ec4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803ec7:	8b 00                	mov    (%eax),%eax
  803ec9:	85 c0                	test   %eax,%eax
  803ecb:	74 10                	je     803edd <alloc_block+0xd2>
  803ecd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803ed0:	8b 00                	mov    (%eax),%eax
  803ed2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803ed5:	8b 52 04             	mov    0x4(%edx),%edx
  803ed8:	89 50 04             	mov    %edx,0x4(%eax)
  803edb:	eb 14                	jmp    803ef1 <alloc_block+0xe6>
  803edd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803ee0:	8b 40 04             	mov    0x4(%eax),%eax
  803ee3:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803ee6:	c1 e2 04             	shl    $0x4,%edx
  803ee9:	81 c2 84 e0 81 00    	add    $0x81e084,%edx
  803eef:	89 02                	mov    %eax,(%edx)
  803ef1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803ef4:	8b 40 04             	mov    0x4(%eax),%eax
  803ef7:	85 c0                	test   %eax,%eax
  803ef9:	74 0f                	je     803f0a <alloc_block+0xff>
  803efb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803efe:	8b 40 04             	mov    0x4(%eax),%eax
  803f01:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803f04:	8b 12                	mov    (%edx),%edx
  803f06:	89 10                	mov    %edx,(%eax)
  803f08:	eb 13                	jmp    803f1d <alloc_block+0x112>
  803f0a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803f0d:	8b 00                	mov    (%eax),%eax
  803f0f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803f12:	c1 e2 04             	shl    $0x4,%edx
  803f15:	81 c2 80 e0 81 00    	add    $0x81e080,%edx
  803f1b:	89 02                	mov    %eax,(%edx)
  803f1d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803f20:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803f26:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803f29:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803f30:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803f33:	c1 e0 04             	shl    $0x4,%eax
  803f36:	05 8c e0 81 00       	add    $0x81e08c,%eax
  803f3b:	8b 00                	mov    (%eax),%eax
  803f3d:	8d 50 ff             	lea    -0x1(%eax),%edx
  803f40:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803f43:	c1 e0 04             	shl    $0x4,%eax
  803f46:	05 8c e0 81 00       	add    $0x81e08c,%eax
  803f4b:	89 10                	mov    %edx,(%eax)
		uint32 page_index = ((uint32)block - dynAllocStart)/ PAGE_SIZE;
  803f4d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803f50:	a1 64 e0 81 00       	mov    0x81e064,%eax
  803f55:	29 c2                	sub    %eax,%edx
  803f57:	89 d0                	mov    %edx,%eax
  803f59:	c1 e8 0c             	shr    $0xc,%eax
  803f5c:	89 45 e0             	mov    %eax,-0x20(%ebp)
		pageBlockInfoArr[page_index].num_of_free_blocks--;
  803f5f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803f62:	89 d0                	mov    %edx,%eax
  803f64:	01 c0                	add    %eax,%eax
  803f66:	01 d0                	add    %edx,%eax
  803f68:	c1 e0 02             	shl    $0x2,%eax
  803f6b:	05 6a 60 80 00       	add    $0x80606a,%eax
  803f70:	66 8b 00             	mov    (%eax),%ax
  803f73:	8d 50 ff             	lea    -0x1(%eax),%edx
  803f76:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  803f79:	89 c8                	mov    %ecx,%eax
  803f7b:	01 c0                	add    %eax,%eax
  803f7d:	01 c8                	add    %ecx,%eax
  803f7f:	c1 e0 02             	shl    $0x2,%eax
  803f82:	05 6a 60 80 00       	add    $0x80606a,%eax
  803f87:	66 89 10             	mov    %dx,(%eax)
		return (void*)block;
  803f8a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803f8d:	e9 13 03 00 00       	jmp    8042a5 <alloc_block+0x49a>
	}

	if(!LIST_EMPTY(&freePagesList)){
  803f92:	a1 48 60 80 00       	mov    0x806048,%eax
  803f97:	85 c0                	test   %eax,%eax
  803f99:	0f 84 c9 01 00 00    	je     804168 <alloc_block+0x35d>

		struct PageInfoElement *page_info = LIST_FIRST(&freePagesList);
  803f9f:	a1 48 60 80 00       	mov    0x806048,%eax
  803fa4:	89 45 dc             	mov    %eax,-0x24(%ebp)
		LIST_REMOVE(&freePagesList, page_info);
  803fa7:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803fab:	75 17                	jne    803fc4 <alloc_block+0x1b9>
  803fad:	83 ec 04             	sub    $0x4,%esp
  803fb0:	68 01 54 80 00       	push   $0x805401
  803fb5:	68 8f 00 00 00       	push   $0x8f
  803fba:	68 c7 53 80 00       	push   $0x8053c7
  803fbf:	e8 2c c9 ff ff       	call   8008f0 <_panic>
  803fc4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803fc7:	8b 00                	mov    (%eax),%eax
  803fc9:	85 c0                	test   %eax,%eax
  803fcb:	74 10                	je     803fdd <alloc_block+0x1d2>
  803fcd:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803fd0:	8b 00                	mov    (%eax),%eax
  803fd2:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803fd5:	8b 52 04             	mov    0x4(%edx),%edx
  803fd8:	89 50 04             	mov    %edx,0x4(%eax)
  803fdb:	eb 0b                	jmp    803fe8 <alloc_block+0x1dd>
  803fdd:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803fe0:	8b 40 04             	mov    0x4(%eax),%eax
  803fe3:	a3 4c 60 80 00       	mov    %eax,0x80604c
  803fe8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803feb:	8b 40 04             	mov    0x4(%eax),%eax
  803fee:	85 c0                	test   %eax,%eax
  803ff0:	74 0f                	je     804001 <alloc_block+0x1f6>
  803ff2:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803ff5:	8b 40 04             	mov    0x4(%eax),%eax
  803ff8:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803ffb:	8b 12                	mov    (%edx),%edx
  803ffd:	89 10                	mov    %edx,(%eax)
  803fff:	eb 0a                	jmp    80400b <alloc_block+0x200>
  804001:	8b 45 dc             	mov    -0x24(%ebp),%eax
  804004:	8b 00                	mov    (%eax),%eax
  804006:	a3 48 60 80 00       	mov    %eax,0x806048
  80400b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80400e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  804014:	8b 45 dc             	mov    -0x24(%ebp),%eax
  804017:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80401e:	a1 54 60 80 00       	mov    0x806054,%eax
  804023:	48                   	dec    %eax
  804024:	a3 54 60 80 00       	mov    %eax,0x806054
		uint32 page_va = to_page_va(page_info);
  804029:	83 ec 0c             	sub    $0xc,%esp
  80402c:	ff 75 dc             	pushl  -0x24(%ebp)
  80402f:	e8 89 fb ff ff       	call   803bbd <to_page_va>
  804034:	83 c4 10             	add    $0x10,%esp
  804037:	89 45 d8             	mov    %eax,-0x28(%ebp)

		uint32 page_index = (page_va - dynAllocStart)/ PAGE_SIZE;
  80403a:	a1 64 e0 81 00       	mov    0x81e064,%eax
  80403f:	8b 55 d8             	mov    -0x28(%ebp),%edx
  804042:	29 c2                	sub    %eax,%edx
  804044:	89 d0                	mov    %edx,%eax
  804046:	c1 e8 0c             	shr    $0xc,%eax
  804049:	89 45 d4             	mov    %eax,-0x2c(%ebp)

		get_page((void*)page_va);
  80404c:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80404f:	83 ec 0c             	sub    $0xc,%esp
  804052:	50                   	push   %eax
  804053:	e8 fe dc ff ff       	call   801d56 <get_page>
  804058:	83 c4 10             	add    $0x10,%esp


		pageBlockInfoArr[page_index].block_size = size;
  80405b:	8b 45 08             	mov    0x8(%ebp),%eax
  80405e:	89 c2                	mov    %eax,%edx
  804060:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  804063:	89 c8                	mov    %ecx,%eax
  804065:	01 c0                	add    %eax,%eax
  804067:	01 c8                	add    %ecx,%eax
  804069:	c1 e0 02             	shl    $0x2,%eax
  80406c:	05 68 60 80 00       	add    $0x806068,%eax
  804071:	66 89 10             	mov    %dx,(%eax)
		int num_blocks = PAGE_SIZE / size ;
  804074:	b8 00 10 00 00       	mov    $0x1000,%eax
  804079:	ba 00 00 00 00       	mov    $0x0,%edx
  80407e:	f7 75 08             	divl   0x8(%ebp)
  804081:	89 45 d0             	mov    %eax,-0x30(%ebp)
		pageBlockInfoArr[page_index].num_of_free_blocks= num_blocks - 1 ;
  804084:	8b 45 d0             	mov    -0x30(%ebp),%eax
  804087:	8d 50 ff             	lea    -0x1(%eax),%edx
  80408a:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  80408d:	89 c8                	mov    %ecx,%eax
  80408f:	01 c0                	add    %eax,%eax
  804091:	01 c8                	add    %ecx,%eax
  804093:	c1 e0 02             	shl    $0x2,%eax
  804096:	05 6a 60 80 00       	add    $0x80606a,%eax
  80409b:	66 89 10             	mov    %dx,(%eax)

		for(int i=1; i< num_blocks; i++){
  80409e:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
  8040a5:	e9 aa 00 00 00       	jmp    804154 <alloc_block+0x349>
			struct BlockElement *new_block = (struct BlockElement*)(page_va + i *size);
  8040aa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8040ad:	0f af 45 08          	imul   0x8(%ebp),%eax
  8040b1:	89 c2                	mov    %eax,%edx
  8040b3:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8040b6:	01 d0                	add    %edx,%eax
  8040b8:	89 45 cc             	mov    %eax,-0x34(%ebp)
			LIST_INSERT_TAIL(&freeBlockLists[list_index], new_block);
  8040bb:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  8040bf:	75 17                	jne    8040d8 <alloc_block+0x2cd>
  8040c1:	83 ec 04             	sub    $0x4,%esp
  8040c4:	68 20 54 80 00       	push   $0x805420
  8040c9:	68 9d 00 00 00       	push   $0x9d
  8040ce:	68 c7 53 80 00       	push   $0x8053c7
  8040d3:	e8 18 c8 ff ff       	call   8008f0 <_panic>
  8040d8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8040db:	c1 e0 04             	shl    $0x4,%eax
  8040de:	05 84 e0 81 00       	add    $0x81e084,%eax
  8040e3:	8b 10                	mov    (%eax),%edx
  8040e5:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8040e8:	89 50 04             	mov    %edx,0x4(%eax)
  8040eb:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8040ee:	8b 40 04             	mov    0x4(%eax),%eax
  8040f1:	85 c0                	test   %eax,%eax
  8040f3:	74 14                	je     804109 <alloc_block+0x2fe>
  8040f5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8040f8:	c1 e0 04             	shl    $0x4,%eax
  8040fb:	05 84 e0 81 00       	add    $0x81e084,%eax
  804100:	8b 00                	mov    (%eax),%eax
  804102:	8b 55 cc             	mov    -0x34(%ebp),%edx
  804105:	89 10                	mov    %edx,(%eax)
  804107:	eb 11                	jmp    80411a <alloc_block+0x30f>
  804109:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80410c:	c1 e0 04             	shl    $0x4,%eax
  80410f:	8d 90 80 e0 81 00    	lea    0x81e080(%eax),%edx
  804115:	8b 45 cc             	mov    -0x34(%ebp),%eax
  804118:	89 02                	mov    %eax,(%edx)
  80411a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80411d:	c1 e0 04             	shl    $0x4,%eax
  804120:	8d 90 84 e0 81 00    	lea    0x81e084(%eax),%edx
  804126:	8b 45 cc             	mov    -0x34(%ebp),%eax
  804129:	89 02                	mov    %eax,(%edx)
  80412b:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80412e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  804134:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804137:	c1 e0 04             	shl    $0x4,%eax
  80413a:	05 8c e0 81 00       	add    $0x81e08c,%eax
  80413f:	8b 00                	mov    (%eax),%eax
  804141:	8d 50 01             	lea    0x1(%eax),%edx
  804144:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804147:	c1 e0 04             	shl    $0x4,%eax
  80414a:	05 8c e0 81 00       	add    $0x81e08c,%eax
  80414f:	89 10                	mov    %edx,(%eax)

		pageBlockInfoArr[page_index].block_size = size;
		int num_blocks = PAGE_SIZE / size ;
		pageBlockInfoArr[page_index].num_of_free_blocks= num_blocks - 1 ;

		for(int i=1; i< num_blocks; i++){
  804151:	ff 45 f0             	incl   -0x10(%ebp)
  804154:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804157:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  80415a:	0f 8c 4a ff ff ff    	jl     8040aa <alloc_block+0x29f>
			struct BlockElement *new_block = (struct BlockElement*)(page_va + i *size);
			LIST_INSERT_TAIL(&freeBlockLists[list_index], new_block);
		}
		return(void*)page_va;
  804160:	8b 45 d8             	mov    -0x28(%ebp),%eax
  804163:	e9 3d 01 00 00       	jmp    8042a5 <alloc_block+0x49a>
	}


	for(int i =list_index+1; i<= LOG2_MAX_SIZE - LOG2_MIN_SIZE; i++){
  804168:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80416b:	40                   	inc    %eax
  80416c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80416f:	e9 10 01 00 00       	jmp    804284 <alloc_block+0x479>

		if(!LIST_EMPTY(&freeBlockLists[i])){
  804174:	8b 45 ec             	mov    -0x14(%ebp),%eax
  804177:	c1 e0 04             	shl    $0x4,%eax
  80417a:	05 80 e0 81 00       	add    $0x81e080,%eax
  80417f:	8b 00                	mov    (%eax),%eax
  804181:	85 c0                	test   %eax,%eax
  804183:	0f 84 f8 00 00 00    	je     804281 <alloc_block+0x476>

			struct BlockElement *block = LIST_FIRST(&freeBlockLists[i]);
  804189:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80418c:	c1 e0 04             	shl    $0x4,%eax
  80418f:	05 80 e0 81 00       	add    $0x81e080,%eax
  804194:	8b 00                	mov    (%eax),%eax
  804196:	89 45 c8             	mov    %eax,-0x38(%ebp)
			LIST_REMOVE( &freeBlockLists[i], block);
  804199:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  80419d:	75 17                	jne    8041b6 <alloc_block+0x3ab>
  80419f:	83 ec 04             	sub    $0x4,%esp
  8041a2:	68 01 54 80 00       	push   $0x805401
  8041a7:	68 a8 00 00 00       	push   $0xa8
  8041ac:	68 c7 53 80 00       	push   $0x8053c7
  8041b1:	e8 3a c7 ff ff       	call   8008f0 <_panic>
  8041b6:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8041b9:	8b 00                	mov    (%eax),%eax
  8041bb:	85 c0                	test   %eax,%eax
  8041bd:	74 10                	je     8041cf <alloc_block+0x3c4>
  8041bf:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8041c2:	8b 00                	mov    (%eax),%eax
  8041c4:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8041c7:	8b 52 04             	mov    0x4(%edx),%edx
  8041ca:	89 50 04             	mov    %edx,0x4(%eax)
  8041cd:	eb 14                	jmp    8041e3 <alloc_block+0x3d8>
  8041cf:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8041d2:	8b 40 04             	mov    0x4(%eax),%eax
  8041d5:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8041d8:	c1 e2 04             	shl    $0x4,%edx
  8041db:	81 c2 84 e0 81 00    	add    $0x81e084,%edx
  8041e1:	89 02                	mov    %eax,(%edx)
  8041e3:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8041e6:	8b 40 04             	mov    0x4(%eax),%eax
  8041e9:	85 c0                	test   %eax,%eax
  8041eb:	74 0f                	je     8041fc <alloc_block+0x3f1>
  8041ed:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8041f0:	8b 40 04             	mov    0x4(%eax),%eax
  8041f3:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8041f6:	8b 12                	mov    (%edx),%edx
  8041f8:	89 10                	mov    %edx,(%eax)
  8041fa:	eb 13                	jmp    80420f <alloc_block+0x404>
  8041fc:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8041ff:	8b 00                	mov    (%eax),%eax
  804201:	8b 55 ec             	mov    -0x14(%ebp),%edx
  804204:	c1 e2 04             	shl    $0x4,%edx
  804207:	81 c2 80 e0 81 00    	add    $0x81e080,%edx
  80420d:	89 02                	mov    %eax,(%edx)
  80420f:	8b 45 c8             	mov    -0x38(%ebp),%eax
  804212:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  804218:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80421b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  804222:	8b 45 ec             	mov    -0x14(%ebp),%eax
  804225:	c1 e0 04             	shl    $0x4,%eax
  804228:	05 8c e0 81 00       	add    $0x81e08c,%eax
  80422d:	8b 00                	mov    (%eax),%eax
  80422f:	8d 50 ff             	lea    -0x1(%eax),%edx
  804232:	8b 45 ec             	mov    -0x14(%ebp),%eax
  804235:	c1 e0 04             	shl    $0x4,%eax
  804238:	05 8c e0 81 00       	add    $0x81e08c,%eax
  80423d:	89 10                	mov    %edx,(%eax)

			uint32 page_index = ((uint32)block - dynAllocStart)/ PAGE_SIZE;
  80423f:	8b 55 c8             	mov    -0x38(%ebp),%edx
  804242:	a1 64 e0 81 00       	mov    0x81e064,%eax
  804247:	29 c2                	sub    %eax,%edx
  804249:	89 d0                	mov    %edx,%eax
  80424b:	c1 e8 0c             	shr    $0xc,%eax
  80424e:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			pageBlockInfoArr[page_index].num_of_free_blocks-- ;
  804251:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  804254:	89 d0                	mov    %edx,%eax
  804256:	01 c0                	add    %eax,%eax
  804258:	01 d0                	add    %edx,%eax
  80425a:	c1 e0 02             	shl    $0x2,%eax
  80425d:	05 6a 60 80 00       	add    $0x80606a,%eax
  804262:	66 8b 00             	mov    (%eax),%ax
  804265:	8d 50 ff             	lea    -0x1(%eax),%edx
  804268:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  80426b:	89 c8                	mov    %ecx,%eax
  80426d:	01 c0                	add    %eax,%eax
  80426f:	01 c8                	add    %ecx,%eax
  804271:	c1 e0 02             	shl    $0x2,%eax
  804274:	05 6a 60 80 00       	add    $0x80606a,%eax
  804279:	66 89 10             	mov    %dx,(%eax)

			return (void*)block;
  80427c:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80427f:	eb 24                	jmp    8042a5 <alloc_block+0x49a>
		}
		return(void*)page_va;
	}


	for(int i =list_index+1; i<= LOG2_MAX_SIZE - LOG2_MIN_SIZE; i++){
  804281:	ff 45 ec             	incl   -0x14(%ebp)
  804284:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  804288:	0f 8e e6 fe ff ff    	jle    804174 <alloc_block+0x369>

			return (void*)block;
		}
	}

	panic("alloc_block: out of memory! ");
  80428e:	83 ec 04             	sub    $0x4,%esp
  804291:	68 43 54 80 00       	push   $0x805443
  804296:	68 b1 00 00 00       	push   $0xb1
  80429b:	68 c7 53 80 00       	push   $0x8053c7
  8042a0:	e8 4b c6 ff ff       	call   8008f0 <_panic>

	//Comment the following line
	//panic("alloc_block() Not implemented yet");

	//TODO: [PROJECT'25.BONUS#1] DYNAMIC ALLOCATOR - block if no free block
}
  8042a5:	c9                   	leave  
  8042a6:	c3                   	ret    

008042a7 <free_block>:

//===========================
// [4] FREE BLOCK:
//===========================
void free_block(void *va)
{
  8042a7:	55                   	push   %ebp
  8042a8:	89 e5                	mov    %esp,%ebp
  8042aa:	83 ec 38             	sub    $0x38,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert((uint32)va >= dynAllocStart && (uint32)va < dynAllocEnd);
  8042ad:	8b 55 08             	mov    0x8(%ebp),%edx
  8042b0:	a1 64 e0 81 00       	mov    0x81e064,%eax
  8042b5:	39 c2                	cmp    %eax,%edx
  8042b7:	72 0c                	jb     8042c5 <free_block+0x1e>
  8042b9:	8b 55 08             	mov    0x8(%ebp),%edx
  8042bc:	a1 40 60 80 00       	mov    0x806040,%eax
  8042c1:	39 c2                	cmp    %eax,%edx
  8042c3:	72 19                	jb     8042de <free_block+0x37>
  8042c5:	68 60 54 80 00       	push   $0x805460
  8042ca:	68 b2 53 80 00       	push   $0x8053b2
  8042cf:	68 c3 00 00 00       	push   $0xc3
  8042d4:	68 c7 53 80 00       	push   $0x8053c7
  8042d9:	e8 12 c6 ff ff       	call   8008f0 <_panic>
	//==================================================================================

	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #4 free_block
	//Your code is here

	uint32 page_index=((uint32)va - dynAllocStart)/ PAGE_SIZE;
  8042de:	8b 55 08             	mov    0x8(%ebp),%edx
  8042e1:	a1 64 e0 81 00       	mov    0x81e064,%eax
  8042e6:	29 c2                	sub    %eax,%edx
  8042e8:	89 d0                	mov    %edx,%eax
  8042ea:	c1 e8 0c             	shr    $0xc,%eax
  8042ed:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 block_size = pageBlockInfoArr[page_index].block_size;
  8042f0:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8042f3:	89 d0                	mov    %edx,%eax
  8042f5:	01 c0                	add    %eax,%eax
  8042f7:	01 d0                	add    %edx,%eax
  8042f9:	c1 e0 02             	shl    $0x2,%eax
  8042fc:	05 68 60 80 00       	add    $0x806068,%eax
  804301:	8b 00                	mov    (%eax),%eax
  804303:	0f b7 c0             	movzwl %ax,%eax
  804306:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if(block_size == 0){
  804309:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80430d:	75 17                	jne    804326 <free_block+0x7f>
		panic("page is empty(already not allocated)");
  80430f:	83 ec 04             	sub    $0x4,%esp
  804312:	68 98 54 80 00       	push   $0x805498
  804317:	68 cf 00 00 00       	push   $0xcf
  80431c:	68 c7 53 80 00       	push   $0x8053c7
  804321:	e8 ca c5 ff ff       	call   8008f0 <_panic>
	}

	int list_index = log2(block_size) - LOG2_MIN_SIZE;
  804326:	83 ec 0c             	sub    $0xc,%esp
  804329:	ff 75 ec             	pushl  -0x14(%ebp)
  80432c:	e8 d8 f8 ff ff       	call   803c09 <log2>
  804331:	83 c4 10             	add    $0x10,%esp
  804334:	83 e8 03             	sub    $0x3,%eax
  804337:	89 45 e8             	mov    %eax,-0x18(%ebp)
	// mn va l block "elta7weel mn virtual l phy hna"
	struct BlockElement *block = (struct BlockElement *)va;
  80433a:	8b 45 08             	mov    0x8(%ebp),%eax
  80433d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	LIST_INSERT_TAIL(&freeBlockLists[list_index], block);
  804340:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  804344:	75 17                	jne    80435d <free_block+0xb6>
  804346:	83 ec 04             	sub    $0x4,%esp
  804349:	68 20 54 80 00       	push   $0x805420
  80434e:	68 d5 00 00 00       	push   $0xd5
  804353:	68 c7 53 80 00       	push   $0x8053c7
  804358:	e8 93 c5 ff ff       	call   8008f0 <_panic>
  80435d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804360:	c1 e0 04             	shl    $0x4,%eax
  804363:	05 84 e0 81 00       	add    $0x81e084,%eax
  804368:	8b 10                	mov    (%eax),%edx
  80436a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80436d:	89 50 04             	mov    %edx,0x4(%eax)
  804370:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804373:	8b 40 04             	mov    0x4(%eax),%eax
  804376:	85 c0                	test   %eax,%eax
  804378:	74 14                	je     80438e <free_block+0xe7>
  80437a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80437d:	c1 e0 04             	shl    $0x4,%eax
  804380:	05 84 e0 81 00       	add    $0x81e084,%eax
  804385:	8b 00                	mov    (%eax),%eax
  804387:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80438a:	89 10                	mov    %edx,(%eax)
  80438c:	eb 11                	jmp    80439f <free_block+0xf8>
  80438e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804391:	c1 e0 04             	shl    $0x4,%eax
  804394:	8d 90 80 e0 81 00    	lea    0x81e080(%eax),%edx
  80439a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80439d:	89 02                	mov    %eax,(%edx)
  80439f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8043a2:	c1 e0 04             	shl    $0x4,%eax
  8043a5:	8d 90 84 e0 81 00    	lea    0x81e084(%eax),%edx
  8043ab:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8043ae:	89 02                	mov    %eax,(%edx)
  8043b0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8043b3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8043b9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8043bc:	c1 e0 04             	shl    $0x4,%eax
  8043bf:	05 8c e0 81 00       	add    $0x81e08c,%eax
  8043c4:	8b 00                	mov    (%eax),%eax
  8043c6:	8d 50 01             	lea    0x1(%eax),%edx
  8043c9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8043cc:	c1 e0 04             	shl    $0x4,%eax
  8043cf:	05 8c e0 81 00       	add    $0x81e08c,%eax
  8043d4:	89 10                	mov    %edx,(%eax)
	// b3d ma wdytha fy el freeBlockLists hzwed elfree elly fy el array 1
	pageBlockInfoArr[page_index].num_of_free_blocks++;
  8043d6:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8043d9:	89 d0                	mov    %edx,%eax
  8043db:	01 c0                	add    %eax,%eax
  8043dd:	01 d0                	add    %edx,%eax
  8043df:	c1 e0 02             	shl    $0x2,%eax
  8043e2:	05 6a 60 80 00       	add    $0x80606a,%eax
  8043e7:	66 8b 00             	mov    (%eax),%ax
  8043ea:	8d 50 01             	lea    0x1(%eax),%edx
  8043ed:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8043f0:	89 c8                	mov    %ecx,%eax
  8043f2:	01 c0                	add    %eax,%eax
  8043f4:	01 c8                	add    %ecx,%eax
  8043f6:	c1 e0 02             	shl    $0x2,%eax
  8043f9:	05 6a 60 80 00       	add    $0x80606a,%eax
  8043fe:	66 89 10             	mov    %dx,(%eax)
	int blocks_number = PAGE_SIZE / block_size;
  804401:	b8 00 10 00 00       	mov    $0x1000,%eax
  804406:	ba 00 00 00 00       	mov    $0x0,%edx
  80440b:	f7 75 ec             	divl   -0x14(%ebp)
  80440e:	89 45 e0             	mov    %eax,-0x20(%ebp)
	if(pageBlockInfoArr[page_index].num_of_free_blocks == blocks_number){
  804411:	8b 55 f0             	mov    -0x10(%ebp),%edx
  804414:	89 d0                	mov    %edx,%eax
  804416:	01 c0                	add    %eax,%eax
  804418:	01 d0                	add    %edx,%eax
  80441a:	c1 e0 02             	shl    $0x2,%eax
  80441d:	05 6a 60 80 00       	add    $0x80606a,%eax
  804422:	66 8b 00             	mov    (%eax),%ax
  804425:	0f b7 c0             	movzwl %ax,%eax
  804428:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80442b:	0f 85 d3 01 00 00    	jne    804604 <free_block+0x35d>
		struct BlockElement *itr = LIST_FIRST(&freeBlockLists[list_index]);
  804431:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804434:	c1 e0 04             	shl    $0x4,%eax
  804437:	05 80 e0 81 00       	add    $0x81e080,%eax
  80443c:	8b 00                	mov    (%eax),%eax
  80443e:	89 45 f4             	mov    %eax,-0xc(%ebp)
		while(itr != NULL){
  804441:	e9 f1 00 00 00       	jmp    804537 <free_block+0x290>
			//lw ms7to el pointer mydy34 ->
			struct BlockElement *next = LIST_NEXT(itr);
  804446:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804449:	8b 00                	mov    (%eax),%eax
  80444b:	89 45 dc             	mov    %eax,-0x24(%ebp)
			uint32 page_beginning_address= dynAllocStart + page_index * PAGE_SIZE;
  80444e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804451:	c1 e0 0c             	shl    $0xc,%eax
  804454:	89 c2                	mov    %eax,%edx
  804456:	a1 64 e0 81 00       	mov    0x81e064,%eax
  80445b:	01 d0                	add    %edx,%eax
  80445d:	89 45 d8             	mov    %eax,-0x28(%ebp)
			uint32 page_end_address = dynAllocStart + (page_index +1 )* PAGE_SIZE;
  804460:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804463:	40                   	inc    %eax
  804464:	c1 e0 0c             	shl    $0xc,%eax
  804467:	89 c2                	mov    %eax,%edx
  804469:	a1 64 e0 81 00       	mov    0x81e064,%eax
  80446e:	01 d0                	add    %edx,%eax
  804470:	89 45 d4             	mov    %eax,-0x2c(%ebp)

			if((uint32)itr >= page_beginning_address && (uint32)itr < page_end_address){
  804473:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804476:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  804479:	0f 82 b8 00 00 00    	jb     804537 <free_block+0x290>
  80447f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804482:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  804485:	0f 83 ac 00 00 00    	jae    804537 <free_block+0x290>
				LIST_REMOVE(&freeBlockLists[list_index], itr);
  80448b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80448f:	75 17                	jne    8044a8 <free_block+0x201>
  804491:	83 ec 04             	sub    $0x4,%esp
  804494:	68 01 54 80 00       	push   $0x805401
  804499:	68 e2 00 00 00       	push   $0xe2
  80449e:	68 c7 53 80 00       	push   $0x8053c7
  8044a3:	e8 48 c4 ff ff       	call   8008f0 <_panic>
  8044a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8044ab:	8b 00                	mov    (%eax),%eax
  8044ad:	85 c0                	test   %eax,%eax
  8044af:	74 10                	je     8044c1 <free_block+0x21a>
  8044b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8044b4:	8b 00                	mov    (%eax),%eax
  8044b6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8044b9:	8b 52 04             	mov    0x4(%edx),%edx
  8044bc:	89 50 04             	mov    %edx,0x4(%eax)
  8044bf:	eb 14                	jmp    8044d5 <free_block+0x22e>
  8044c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8044c4:	8b 40 04             	mov    0x4(%eax),%eax
  8044c7:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8044ca:	c1 e2 04             	shl    $0x4,%edx
  8044cd:	81 c2 84 e0 81 00    	add    $0x81e084,%edx
  8044d3:	89 02                	mov    %eax,(%edx)
  8044d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8044d8:	8b 40 04             	mov    0x4(%eax),%eax
  8044db:	85 c0                	test   %eax,%eax
  8044dd:	74 0f                	je     8044ee <free_block+0x247>
  8044df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8044e2:	8b 40 04             	mov    0x4(%eax),%eax
  8044e5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8044e8:	8b 12                	mov    (%edx),%edx
  8044ea:	89 10                	mov    %edx,(%eax)
  8044ec:	eb 13                	jmp    804501 <free_block+0x25a>
  8044ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8044f1:	8b 00                	mov    (%eax),%eax
  8044f3:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8044f6:	c1 e2 04             	shl    $0x4,%edx
  8044f9:	81 c2 80 e0 81 00    	add    $0x81e080,%edx
  8044ff:	89 02                	mov    %eax,(%edx)
  804501:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804504:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80450a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80450d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  804514:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804517:	c1 e0 04             	shl    $0x4,%eax
  80451a:	05 8c e0 81 00       	add    $0x81e08c,%eax
  80451f:	8b 00                	mov    (%eax),%eax
  804521:	8d 50 ff             	lea    -0x1(%eax),%edx
  804524:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804527:	c1 e0 04             	shl    $0x4,%eax
  80452a:	05 8c e0 81 00       	add    $0x81e08c,%eax
  80452f:	89 10                	mov    %edx,(%eax)
				//y5o4 3la elly b3do
				itr = next;
  804531:	8b 45 dc             	mov    -0x24(%ebp),%eax
  804534:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// b3d ma wdytha fy el freeBlockLists hzwed elfree elly fy el array 1
	pageBlockInfoArr[page_index].num_of_free_blocks++;
	int blocks_number = PAGE_SIZE / block_size;
	if(pageBlockInfoArr[page_index].num_of_free_blocks == blocks_number){
		struct BlockElement *itr = LIST_FIRST(&freeBlockLists[list_index]);
		while(itr != NULL){
  804537:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80453b:	0f 85 05 ff ff ff    	jne    804446 <free_block+0x19f>
				LIST_REMOVE(&freeBlockLists[list_index], itr);
				//y5o4 3la elly b3do
				itr = next;
			}
		}
		pageBlockInfoArr[page_index].block_size=0;
  804541:	8b 55 f0             	mov    -0x10(%ebp),%edx
  804544:	89 d0                	mov    %edx,%eax
  804546:	01 c0                	add    %eax,%eax
  804548:	01 d0                	add    %edx,%eax
  80454a:	c1 e0 02             	shl    $0x2,%eax
  80454d:	05 68 60 80 00       	add    $0x806068,%eax
  804552:	66 c7 00 00 00       	movw   $0x0,(%eax)
		pageBlockInfoArr[page_index].num_of_free_blocks=0;
  804557:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80455a:	89 d0                	mov    %edx,%eax
  80455c:	01 c0                	add    %eax,%eax
  80455e:	01 d0                	add    %edx,%eax
  804560:	c1 e0 02             	shl    $0x2,%eax
  804563:	05 6a 60 80 00       	add    $0x80606a,%eax
  804568:	66 c7 00 00 00       	movw   $0x0,(%eax)

		struct PageInfoElement *page_info = &pageBlockInfoArr[page_index];
  80456d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  804570:	89 d0                	mov    %edx,%eax
  804572:	01 c0                	add    %eax,%eax
  804574:	01 d0                	add    %edx,%eax
  804576:	c1 e0 02             	shl    $0x2,%eax
  804579:	05 60 60 80 00       	add    $0x806060,%eax
  80457e:	89 45 d0             	mov    %eax,-0x30(%ebp)
		LIST_INSERT_TAIL(&freePagesList, page_info);
  804581:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  804585:	75 17                	jne    80459e <free_block+0x2f7>
  804587:	83 ec 04             	sub    $0x4,%esp
  80458a:	68 20 54 80 00       	push   $0x805420
  80458f:	68 eb 00 00 00       	push   $0xeb
  804594:	68 c7 53 80 00       	push   $0x8053c7
  804599:	e8 52 c3 ff ff       	call   8008f0 <_panic>
  80459e:	8b 15 4c 60 80 00    	mov    0x80604c,%edx
  8045a4:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8045a7:	89 50 04             	mov    %edx,0x4(%eax)
  8045aa:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8045ad:	8b 40 04             	mov    0x4(%eax),%eax
  8045b0:	85 c0                	test   %eax,%eax
  8045b2:	74 0c                	je     8045c0 <free_block+0x319>
  8045b4:	a1 4c 60 80 00       	mov    0x80604c,%eax
  8045b9:	8b 55 d0             	mov    -0x30(%ebp),%edx
  8045bc:	89 10                	mov    %edx,(%eax)
  8045be:	eb 08                	jmp    8045c8 <free_block+0x321>
  8045c0:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8045c3:	a3 48 60 80 00       	mov    %eax,0x806048
  8045c8:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8045cb:	a3 4c 60 80 00       	mov    %eax,0x80604c
  8045d0:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8045d3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8045d9:	a1 54 60 80 00       	mov    0x806054,%eax
  8045de:	40                   	inc    %eax
  8045df:	a3 54 60 80 00       	mov    %eax,0x806054
		uint32 page_va = to_page_va(page_info);
  8045e4:	83 ec 0c             	sub    $0xc,%esp
  8045e7:	ff 75 d0             	pushl  -0x30(%ebp)
  8045ea:	e8 ce f5 ff ff       	call   803bbd <to_page_va>
  8045ef:	83 c4 10             	add    $0x10,%esp
  8045f2:	89 45 cc             	mov    %eax,-0x34(%ebp)
		return_page((void *)page_va);
  8045f5:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8045f8:	83 ec 0c             	sub    $0xc,%esp
  8045fb:	50                   	push   %eax
  8045fc:	e8 9e d7 ff ff       	call   801d9f <return_page>
  804601:	83 c4 10             	add    $0x10,%esp
	}


	//Comment the following line
	//panic("free_block() Not implemented yet");
}
  804604:	90                   	nop
  804605:	c9                   	leave  
  804606:	c3                   	ret    

00804607 <realloc_block>:

//===========================
// [1] REALLOCATE BLOCK:
//===========================
void *realloc_block(void* va, uint32 new_size)
{
  804607:	55                   	push   %ebp
  804608:	89 e5                	mov    %esp,%ebp
  80460a:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.BONUS#2] KERNEL REALLOC - realloc_block
	//Your code is here
	//Comment the following line
	panic("realloc_block() Not implemented yet");
  80460d:	83 ec 04             	sub    $0x4,%esp
  804610:	68 c0 54 80 00       	push   $0x8054c0
  804615:	68 01 01 00 00       	push   $0x101
  80461a:	68 c7 53 80 00       	push   $0x8053c7
  80461f:	e8 cc c2 ff ff       	call   8008f0 <_panic>

00804624 <init_uspinlock>:
#include "inc/uspinlock.h"

extern volatile struct Env *myEnv;

void init_uspinlock(struct uspinlock *lk, char *name, bool isOpened)
{
  804624:	55                   	push   %ebp
  804625:	89 e5                	mov    %esp,%ebp
  804627:	83 ec 08             	sub    $0x8,%esp
	assert(isOpened == 0 || isOpened == 1);
  80462a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80462e:	74 1c                	je     80464c <init_uspinlock+0x28>
  804630:	83 7d 10 01          	cmpl   $0x1,0x10(%ebp)
  804634:	74 16                	je     80464c <init_uspinlock+0x28>
  804636:	68 e4 54 80 00       	push   $0x8054e4
  80463b:	68 03 55 80 00       	push   $0x805503
  804640:	6a 10                	push   $0x10
  804642:	68 18 55 80 00       	push   $0x805518
  804647:	e8 a4 c2 ff ff       	call   8008f0 <_panic>
	strcpy(lk->name, name);
  80464c:	8b 45 08             	mov    0x8(%ebp),%eax
  80464f:	83 c0 04             	add    $0x4,%eax
  804652:	83 ec 08             	sub    $0x8,%esp
  804655:	ff 75 0c             	pushl  0xc(%ebp)
  804658:	50                   	push   %eax
  804659:	e8 90 ce ff ff       	call   8014ee <strcpy>
  80465e:	83 c4 10             	add    $0x10,%esp
	lk->locked = (1 - isOpened);
  804661:	b8 01 00 00 00       	mov    $0x1,%eax
  804666:	2b 45 10             	sub    0x10(%ebp),%eax
  804669:	89 c2                	mov    %eax,%edx
  80466b:	8b 45 08             	mov    0x8(%ebp),%eax
  80466e:	89 10                	mov    %edx,(%eax)
}
  804670:	90                   	nop
  804671:	c9                   	leave  
  804672:	c3                   	ret    

00804673 <acquire_uspinlock>:
// Acquire the lock.
// Loops (spins) until the lock is acquired.
// Holding a lock for a long time may cause
// other CPUs to waste time spinning to acquire it.
void acquire_uspinlock(struct uspinlock *lk)
{
  804673:	55                   	push   %ebp
  804674:	89 e5                	mov    %esp,%ebp
  804676:	83 ec 18             	sub    $0x18,%esp
	// The xchg is atomic.
	while(xchg(&lk->locked, 1) != 0) ;
  804679:	90                   	nop
  80467a:	8b 45 08             	mov    0x8(%ebp),%eax
  80467d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  804680:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
xchg(volatile uint32 *addr, uint32 newval)
{
  uint32 result;

  // The + in "+m" denotes a read-modify-write operand.
  __asm __volatile("lock; xchgl %0, %1" :
  804687:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80468a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80468d:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  804690:	f0 87 02             	lock xchg %eax,(%edx)
  804693:	89 45 ec             	mov    %eax,-0x14(%ebp)
               "+m" (*addr), "=a" (result) :
               "1" (newval) :
               "cc");
  return result;
  804696:	8b 45 ec             	mov    -0x14(%ebp),%eax
  804699:	85 c0                	test   %eax,%eax
  80469b:	75 dd                	jne    80467a <acquire_uspinlock+0x7>

	cprintf("[%d: %s] ACQUIRED spinlock [%s]\n", myEnv->env_id, myEnv->prog_name, lk->name);
  80469d:	8b 45 08             	mov    0x8(%ebp),%eax
  8046a0:	8d 48 04             	lea    0x4(%eax),%ecx
  8046a3:	a1 24 60 80 00       	mov    0x806024,%eax
  8046a8:	8d 50 20             	lea    0x20(%eax),%edx
  8046ab:	a1 24 60 80 00       	mov    0x806024,%eax
  8046b0:	8b 40 10             	mov    0x10(%eax),%eax
  8046b3:	51                   	push   %ecx
  8046b4:	52                   	push   %edx
  8046b5:	50                   	push   %eax
  8046b6:	68 28 55 80 00       	push   $0x805528
  8046bb:	e8 fe c4 ff ff       	call   800bbe <cprintf>
  8046c0:	83 c4 10             	add    $0x10,%esp

	// Tell the C compiler and the processor to not move loads or stores
	// past this point, to ensure that the critical section's memory
	// references happen after the lock is acquired.
	__sync_synchronize();
  8046c3:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
}
  8046c8:	90                   	nop
  8046c9:	c9                   	leave  
  8046ca:	c3                   	ret    

008046cb <release_uspinlock>:

// Release the lock.
void release_uspinlock(struct uspinlock *lk)
{
  8046cb:	55                   	push   %ebp
  8046cc:	89 e5                	mov    %esp,%ebp
  8046ce:	83 ec 08             	sub    $0x8,%esp
	if(!(lk->locked))
  8046d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8046d4:	8b 00                	mov    (%eax),%eax
  8046d6:	85 c0                	test   %eax,%eax
  8046d8:	75 18                	jne    8046f2 <release_uspinlock+0x27>
	{
		panic("release: lock \"%s\" is not held!", lk->name);
  8046da:	8b 45 08             	mov    0x8(%ebp),%eax
  8046dd:	83 c0 04             	add    $0x4,%eax
  8046e0:	50                   	push   %eax
  8046e1:	68 4c 55 80 00       	push   $0x80554c
  8046e6:	6a 2b                	push   $0x2b
  8046e8:	68 18 55 80 00       	push   $0x805518
  8046ed:	e8 fe c1 ff ff       	call   8008f0 <_panic>
	// Tell the C compiler and the processor to not move loads or stores
	// past this point, to ensure that all the stores in the critical
	// section are visible to other cores before the lock is released.
	// Both the C compiler and the hardware may re-order loads and
	// stores; __sync_synchronize() tells them both not to.
	__sync_synchronize();
  8046f2:	f0 83 0c 24 00       	lock orl $0x0,(%esp)

	// Release the lock, equivalent to lk->locked = 0.
	// This code can't use a C assignment, since it might
	// not be atomic. A real OS would use C atomics here.
	asm volatile("movl $0, %0" : "+m" (lk->locked) : );
  8046f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8046fa:	8b 55 08             	mov    0x8(%ebp),%edx
  8046fd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	cprintf("[%d: %s] RELEASED spinlock [%s]\n", myEnv->env_id, myEnv->prog_name, lk->name);
  804703:	8b 45 08             	mov    0x8(%ebp),%eax
  804706:	8d 48 04             	lea    0x4(%eax),%ecx
  804709:	a1 24 60 80 00       	mov    0x806024,%eax
  80470e:	8d 50 20             	lea    0x20(%eax),%edx
  804711:	a1 24 60 80 00       	mov    0x806024,%eax
  804716:	8b 40 10             	mov    0x10(%eax),%eax
  804719:	51                   	push   %ecx
  80471a:	52                   	push   %edx
  80471b:	50                   	push   %eax
  80471c:	68 6c 55 80 00       	push   $0x80556c
  804721:	e8 98 c4 ff ff       	call   800bbe <cprintf>
  804726:	83 c4 10             	add    $0x10,%esp
}
  804729:	90                   	nop
  80472a:	c9                   	leave  
  80472b:	c3                   	ret    

0080472c <__udivdi3>:
  80472c:	55                   	push   %ebp
  80472d:	57                   	push   %edi
  80472e:	56                   	push   %esi
  80472f:	53                   	push   %ebx
  804730:	83 ec 1c             	sub    $0x1c,%esp
  804733:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  804737:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80473b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80473f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  804743:	89 ca                	mov    %ecx,%edx
  804745:	89 f8                	mov    %edi,%eax
  804747:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80474b:	85 f6                	test   %esi,%esi
  80474d:	75 2d                	jne    80477c <__udivdi3+0x50>
  80474f:	39 cf                	cmp    %ecx,%edi
  804751:	77 65                	ja     8047b8 <__udivdi3+0x8c>
  804753:	89 fd                	mov    %edi,%ebp
  804755:	85 ff                	test   %edi,%edi
  804757:	75 0b                	jne    804764 <__udivdi3+0x38>
  804759:	b8 01 00 00 00       	mov    $0x1,%eax
  80475e:	31 d2                	xor    %edx,%edx
  804760:	f7 f7                	div    %edi
  804762:	89 c5                	mov    %eax,%ebp
  804764:	31 d2                	xor    %edx,%edx
  804766:	89 c8                	mov    %ecx,%eax
  804768:	f7 f5                	div    %ebp
  80476a:	89 c1                	mov    %eax,%ecx
  80476c:	89 d8                	mov    %ebx,%eax
  80476e:	f7 f5                	div    %ebp
  804770:	89 cf                	mov    %ecx,%edi
  804772:	89 fa                	mov    %edi,%edx
  804774:	83 c4 1c             	add    $0x1c,%esp
  804777:	5b                   	pop    %ebx
  804778:	5e                   	pop    %esi
  804779:	5f                   	pop    %edi
  80477a:	5d                   	pop    %ebp
  80477b:	c3                   	ret    
  80477c:	39 ce                	cmp    %ecx,%esi
  80477e:	77 28                	ja     8047a8 <__udivdi3+0x7c>
  804780:	0f bd fe             	bsr    %esi,%edi
  804783:	83 f7 1f             	xor    $0x1f,%edi
  804786:	75 40                	jne    8047c8 <__udivdi3+0x9c>
  804788:	39 ce                	cmp    %ecx,%esi
  80478a:	72 0a                	jb     804796 <__udivdi3+0x6a>
  80478c:	3b 44 24 08          	cmp    0x8(%esp),%eax
  804790:	0f 87 9e 00 00 00    	ja     804834 <__udivdi3+0x108>
  804796:	b8 01 00 00 00       	mov    $0x1,%eax
  80479b:	89 fa                	mov    %edi,%edx
  80479d:	83 c4 1c             	add    $0x1c,%esp
  8047a0:	5b                   	pop    %ebx
  8047a1:	5e                   	pop    %esi
  8047a2:	5f                   	pop    %edi
  8047a3:	5d                   	pop    %ebp
  8047a4:	c3                   	ret    
  8047a5:	8d 76 00             	lea    0x0(%esi),%esi
  8047a8:	31 ff                	xor    %edi,%edi
  8047aa:	31 c0                	xor    %eax,%eax
  8047ac:	89 fa                	mov    %edi,%edx
  8047ae:	83 c4 1c             	add    $0x1c,%esp
  8047b1:	5b                   	pop    %ebx
  8047b2:	5e                   	pop    %esi
  8047b3:	5f                   	pop    %edi
  8047b4:	5d                   	pop    %ebp
  8047b5:	c3                   	ret    
  8047b6:	66 90                	xchg   %ax,%ax
  8047b8:	89 d8                	mov    %ebx,%eax
  8047ba:	f7 f7                	div    %edi
  8047bc:	31 ff                	xor    %edi,%edi
  8047be:	89 fa                	mov    %edi,%edx
  8047c0:	83 c4 1c             	add    $0x1c,%esp
  8047c3:	5b                   	pop    %ebx
  8047c4:	5e                   	pop    %esi
  8047c5:	5f                   	pop    %edi
  8047c6:	5d                   	pop    %ebp
  8047c7:	c3                   	ret    
  8047c8:	bd 20 00 00 00       	mov    $0x20,%ebp
  8047cd:	89 eb                	mov    %ebp,%ebx
  8047cf:	29 fb                	sub    %edi,%ebx
  8047d1:	89 f9                	mov    %edi,%ecx
  8047d3:	d3 e6                	shl    %cl,%esi
  8047d5:	89 c5                	mov    %eax,%ebp
  8047d7:	88 d9                	mov    %bl,%cl
  8047d9:	d3 ed                	shr    %cl,%ebp
  8047db:	89 e9                	mov    %ebp,%ecx
  8047dd:	09 f1                	or     %esi,%ecx
  8047df:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8047e3:	89 f9                	mov    %edi,%ecx
  8047e5:	d3 e0                	shl    %cl,%eax
  8047e7:	89 c5                	mov    %eax,%ebp
  8047e9:	89 d6                	mov    %edx,%esi
  8047eb:	88 d9                	mov    %bl,%cl
  8047ed:	d3 ee                	shr    %cl,%esi
  8047ef:	89 f9                	mov    %edi,%ecx
  8047f1:	d3 e2                	shl    %cl,%edx
  8047f3:	8b 44 24 08          	mov    0x8(%esp),%eax
  8047f7:	88 d9                	mov    %bl,%cl
  8047f9:	d3 e8                	shr    %cl,%eax
  8047fb:	09 c2                	or     %eax,%edx
  8047fd:	89 d0                	mov    %edx,%eax
  8047ff:	89 f2                	mov    %esi,%edx
  804801:	f7 74 24 0c          	divl   0xc(%esp)
  804805:	89 d6                	mov    %edx,%esi
  804807:	89 c3                	mov    %eax,%ebx
  804809:	f7 e5                	mul    %ebp
  80480b:	39 d6                	cmp    %edx,%esi
  80480d:	72 19                	jb     804828 <__udivdi3+0xfc>
  80480f:	74 0b                	je     80481c <__udivdi3+0xf0>
  804811:	89 d8                	mov    %ebx,%eax
  804813:	31 ff                	xor    %edi,%edi
  804815:	e9 58 ff ff ff       	jmp    804772 <__udivdi3+0x46>
  80481a:	66 90                	xchg   %ax,%ax
  80481c:	8b 54 24 08          	mov    0x8(%esp),%edx
  804820:	89 f9                	mov    %edi,%ecx
  804822:	d3 e2                	shl    %cl,%edx
  804824:	39 c2                	cmp    %eax,%edx
  804826:	73 e9                	jae    804811 <__udivdi3+0xe5>
  804828:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80482b:	31 ff                	xor    %edi,%edi
  80482d:	e9 40 ff ff ff       	jmp    804772 <__udivdi3+0x46>
  804832:	66 90                	xchg   %ax,%ax
  804834:	31 c0                	xor    %eax,%eax
  804836:	e9 37 ff ff ff       	jmp    804772 <__udivdi3+0x46>
  80483b:	90                   	nop

0080483c <__umoddi3>:
  80483c:	55                   	push   %ebp
  80483d:	57                   	push   %edi
  80483e:	56                   	push   %esi
  80483f:	53                   	push   %ebx
  804840:	83 ec 1c             	sub    $0x1c,%esp
  804843:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  804847:	8b 74 24 34          	mov    0x34(%esp),%esi
  80484b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80484f:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  804853:	89 44 24 0c          	mov    %eax,0xc(%esp)
  804857:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80485b:	89 f3                	mov    %esi,%ebx
  80485d:	89 fa                	mov    %edi,%edx
  80485f:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  804863:	89 34 24             	mov    %esi,(%esp)
  804866:	85 c0                	test   %eax,%eax
  804868:	75 1a                	jne    804884 <__umoddi3+0x48>
  80486a:	39 f7                	cmp    %esi,%edi
  80486c:	0f 86 a2 00 00 00    	jbe    804914 <__umoddi3+0xd8>
  804872:	89 c8                	mov    %ecx,%eax
  804874:	89 f2                	mov    %esi,%edx
  804876:	f7 f7                	div    %edi
  804878:	89 d0                	mov    %edx,%eax
  80487a:	31 d2                	xor    %edx,%edx
  80487c:	83 c4 1c             	add    $0x1c,%esp
  80487f:	5b                   	pop    %ebx
  804880:	5e                   	pop    %esi
  804881:	5f                   	pop    %edi
  804882:	5d                   	pop    %ebp
  804883:	c3                   	ret    
  804884:	39 f0                	cmp    %esi,%eax
  804886:	0f 87 ac 00 00 00    	ja     804938 <__umoddi3+0xfc>
  80488c:	0f bd e8             	bsr    %eax,%ebp
  80488f:	83 f5 1f             	xor    $0x1f,%ebp
  804892:	0f 84 ac 00 00 00    	je     804944 <__umoddi3+0x108>
  804898:	bf 20 00 00 00       	mov    $0x20,%edi
  80489d:	29 ef                	sub    %ebp,%edi
  80489f:	89 fe                	mov    %edi,%esi
  8048a1:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8048a5:	89 e9                	mov    %ebp,%ecx
  8048a7:	d3 e0                	shl    %cl,%eax
  8048a9:	89 d7                	mov    %edx,%edi
  8048ab:	89 f1                	mov    %esi,%ecx
  8048ad:	d3 ef                	shr    %cl,%edi
  8048af:	09 c7                	or     %eax,%edi
  8048b1:	89 e9                	mov    %ebp,%ecx
  8048b3:	d3 e2                	shl    %cl,%edx
  8048b5:	89 14 24             	mov    %edx,(%esp)
  8048b8:	89 d8                	mov    %ebx,%eax
  8048ba:	d3 e0                	shl    %cl,%eax
  8048bc:	89 c2                	mov    %eax,%edx
  8048be:	8b 44 24 08          	mov    0x8(%esp),%eax
  8048c2:	d3 e0                	shl    %cl,%eax
  8048c4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8048c8:	8b 44 24 08          	mov    0x8(%esp),%eax
  8048cc:	89 f1                	mov    %esi,%ecx
  8048ce:	d3 e8                	shr    %cl,%eax
  8048d0:	09 d0                	or     %edx,%eax
  8048d2:	d3 eb                	shr    %cl,%ebx
  8048d4:	89 da                	mov    %ebx,%edx
  8048d6:	f7 f7                	div    %edi
  8048d8:	89 d3                	mov    %edx,%ebx
  8048da:	f7 24 24             	mull   (%esp)
  8048dd:	89 c6                	mov    %eax,%esi
  8048df:	89 d1                	mov    %edx,%ecx
  8048e1:	39 d3                	cmp    %edx,%ebx
  8048e3:	0f 82 87 00 00 00    	jb     804970 <__umoddi3+0x134>
  8048e9:	0f 84 91 00 00 00    	je     804980 <__umoddi3+0x144>
  8048ef:	8b 54 24 04          	mov    0x4(%esp),%edx
  8048f3:	29 f2                	sub    %esi,%edx
  8048f5:	19 cb                	sbb    %ecx,%ebx
  8048f7:	89 d8                	mov    %ebx,%eax
  8048f9:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8048fd:	d3 e0                	shl    %cl,%eax
  8048ff:	89 e9                	mov    %ebp,%ecx
  804901:	d3 ea                	shr    %cl,%edx
  804903:	09 d0                	or     %edx,%eax
  804905:	89 e9                	mov    %ebp,%ecx
  804907:	d3 eb                	shr    %cl,%ebx
  804909:	89 da                	mov    %ebx,%edx
  80490b:	83 c4 1c             	add    $0x1c,%esp
  80490e:	5b                   	pop    %ebx
  80490f:	5e                   	pop    %esi
  804910:	5f                   	pop    %edi
  804911:	5d                   	pop    %ebp
  804912:	c3                   	ret    
  804913:	90                   	nop
  804914:	89 fd                	mov    %edi,%ebp
  804916:	85 ff                	test   %edi,%edi
  804918:	75 0b                	jne    804925 <__umoddi3+0xe9>
  80491a:	b8 01 00 00 00       	mov    $0x1,%eax
  80491f:	31 d2                	xor    %edx,%edx
  804921:	f7 f7                	div    %edi
  804923:	89 c5                	mov    %eax,%ebp
  804925:	89 f0                	mov    %esi,%eax
  804927:	31 d2                	xor    %edx,%edx
  804929:	f7 f5                	div    %ebp
  80492b:	89 c8                	mov    %ecx,%eax
  80492d:	f7 f5                	div    %ebp
  80492f:	89 d0                	mov    %edx,%eax
  804931:	e9 44 ff ff ff       	jmp    80487a <__umoddi3+0x3e>
  804936:	66 90                	xchg   %ax,%ax
  804938:	89 c8                	mov    %ecx,%eax
  80493a:	89 f2                	mov    %esi,%edx
  80493c:	83 c4 1c             	add    $0x1c,%esp
  80493f:	5b                   	pop    %ebx
  804940:	5e                   	pop    %esi
  804941:	5f                   	pop    %edi
  804942:	5d                   	pop    %ebp
  804943:	c3                   	ret    
  804944:	3b 04 24             	cmp    (%esp),%eax
  804947:	72 06                	jb     80494f <__umoddi3+0x113>
  804949:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  80494d:	77 0f                	ja     80495e <__umoddi3+0x122>
  80494f:	89 f2                	mov    %esi,%edx
  804951:	29 f9                	sub    %edi,%ecx
  804953:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  804957:	89 14 24             	mov    %edx,(%esp)
  80495a:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80495e:	8b 44 24 04          	mov    0x4(%esp),%eax
  804962:	8b 14 24             	mov    (%esp),%edx
  804965:	83 c4 1c             	add    $0x1c,%esp
  804968:	5b                   	pop    %ebx
  804969:	5e                   	pop    %esi
  80496a:	5f                   	pop    %edi
  80496b:	5d                   	pop    %ebp
  80496c:	c3                   	ret    
  80496d:	8d 76 00             	lea    0x0(%esi),%esi
  804970:	2b 04 24             	sub    (%esp),%eax
  804973:	19 fa                	sbb    %edi,%edx
  804975:	89 d1                	mov    %edx,%ecx
  804977:	89 c6                	mov    %eax,%esi
  804979:	e9 71 ff ff ff       	jmp    8048ef <__umoddi3+0xb3>
  80497e:	66 90                	xchg   %ax,%ax
  804980:	39 44 24 04          	cmp    %eax,0x4(%esp)
  804984:	72 ea                	jb     804970 <__umoddi3+0x134>
  804986:	89 d9                	mov    %ebx,%ecx
  804988:	e9 62 ff ff ff       	jmp    8048ef <__umoddi3+0xb3>
