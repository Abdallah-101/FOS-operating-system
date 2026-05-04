
obj/user/ef_mergesort_noleakage:     file format elf32-i386


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
  800031:	e8 2f 07 00 00       	call   800765 <libmain>
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
	char Line[255] ;
	char Chose ;
	do
	{
		//2012: lock the interrupt
		sys_lock_cons();
  800041:	e8 61 34 00 00       	call   8034a7 <sys_lock_cons>

		cprintf("\n");
  800046:	83 ec 0c             	sub    $0xc,%esp
  800049:	68 c0 47 80 00       	push   $0x8047c0
  80004e:	e8 99 0b 00 00       	call   800bec <cprintf>
  800053:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!!!!!!!!!!!!!!!!!!\n");
  800056:	83 ec 0c             	sub    $0xc,%esp
  800059:	68 c2 47 80 00       	push   $0x8047c2
  80005e:	e8 89 0b 00 00       	call   800bec <cprintf>
  800063:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!! MERGE SORT !!!!\n");
  800066:	83 ec 0c             	sub    $0xc,%esp
  800069:	68 d8 47 80 00       	push   $0x8047d8
  80006e:	e8 79 0b 00 00       	call   800bec <cprintf>
  800073:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!!!!!!!!!!!!!!!!!!\n");
  800076:	83 ec 0c             	sub    $0xc,%esp
  800079:	68 c2 47 80 00       	push   $0x8047c2
  80007e:	e8 69 0b 00 00       	call   800bec <cprintf>
  800083:	83 c4 10             	add    $0x10,%esp
		cprintf("\n");
  800086:	83 ec 0c             	sub    $0xc,%esp
  800089:	68 c0 47 80 00       	push   $0x8047c0
  80008e:	e8 59 0b 00 00       	call   800bec <cprintf>
  800093:	83 c4 10             	add    $0x10,%esp
		//readline("Enter the number of elements: ", Line);
		cprintf("Enter the number of elements: ");
  800096:	83 ec 0c             	sub    $0xc,%esp
  800099:	68 f0 47 80 00       	push   $0x8047f0
  80009e:	e8 49 0b 00 00       	call   800bec <cprintf>
  8000a3:	83 c4 10             	add    $0x10,%esp
		int NumOfElements = 2000 ;
  8000a6:	c7 45 f0 d0 07 00 00 	movl   $0x7d0,-0x10(%ebp)
		cprintf("%d\n", NumOfElements) ;
  8000ad:	83 ec 08             	sub    $0x8,%esp
  8000b0:	ff 75 f0             	pushl  -0x10(%ebp)
  8000b3:	68 0f 48 80 00       	push   $0x80480f
  8000b8:	e8 2f 0b 00 00       	call   800bec <cprintf>
  8000bd:	83 c4 10             	add    $0x10,%esp

		int *Elements = malloc(sizeof(int) * NumOfElements) ;
  8000c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8000c3:	c1 e0 02             	shl    $0x2,%eax
  8000c6:	83 ec 0c             	sub    $0xc,%esp
  8000c9:	50                   	push   %eax
  8000ca:	e8 36 1b 00 00       	call   801c05 <malloc>
  8000cf:	83 c4 10             	add    $0x10,%esp
  8000d2:	89 45 ec             	mov    %eax,-0x14(%ebp)
		cprintf("Chose the initialization method:\n") ;
  8000d5:	83 ec 0c             	sub    $0xc,%esp
  8000d8:	68 14 48 80 00       	push   $0x804814
  8000dd:	e8 0a 0b 00 00       	call   800bec <cprintf>
  8000e2:	83 c4 10             	add    $0x10,%esp
		cprintf("a) Ascending\n") ;
  8000e5:	83 ec 0c             	sub    $0xc,%esp
  8000e8:	68 36 48 80 00       	push   $0x804836
  8000ed:	e8 fa 0a 00 00       	call   800bec <cprintf>
  8000f2:	83 c4 10             	add    $0x10,%esp
		cprintf("b) Descending\n") ;
  8000f5:	83 ec 0c             	sub    $0xc,%esp
  8000f8:	68 44 48 80 00       	push   $0x804844
  8000fd:	e8 ea 0a 00 00       	call   800bec <cprintf>
  800102:	83 c4 10             	add    $0x10,%esp
		cprintf("c) Semi random\n");
  800105:	83 ec 0c             	sub    $0xc,%esp
  800108:	68 53 48 80 00       	push   $0x804853
  80010d:	e8 da 0a 00 00       	call   800bec <cprintf>
  800112:	83 c4 10             	add    $0x10,%esp
		do
		{
			cprintf("Select: ") ;
  800115:	83 ec 0c             	sub    $0xc,%esp
  800118:	68 63 48 80 00       	push   $0x804863
  80011d:	e8 ca 0a 00 00       	call   800bec <cprintf>
  800122:	83 c4 10             	add    $0x10,%esp
			//Chose = getchar() ;
			Chose = 'a';
  800125:	c6 45 f7 61          	movb   $0x61,-0x9(%ebp)
			cputchar(Chose);
  800129:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  80012d:	83 ec 0c             	sub    $0xc,%esp
  800130:	50                   	push   %eax
  800131:	e8 f3 05 00 00       	call   800729 <cputchar>
  800136:	83 c4 10             	add    $0x10,%esp
			cputchar('\n');
  800139:	83 ec 0c             	sub    $0xc,%esp
  80013c:	6a 0a                	push   $0xa
  80013e:	e8 e6 05 00 00       	call   800729 <cputchar>
  800143:	83 c4 10             	add    $0x10,%esp
		} while (Chose != 'a' && Chose != 'b' && Chose != 'c');
  800146:	80 7d f7 61          	cmpb   $0x61,-0x9(%ebp)
  80014a:	74 0c                	je     800158 <_main+0x120>
  80014c:	80 7d f7 62          	cmpb   $0x62,-0x9(%ebp)
  800150:	74 06                	je     800158 <_main+0x120>
  800152:	80 7d f7 63          	cmpb   $0x63,-0x9(%ebp)
  800156:	75 bd                	jne    800115 <_main+0xdd>

		//2012: lock the interrupt
		sys_unlock_cons();
  800158:	e8 64 33 00 00       	call   8034c1 <sys_unlock_cons>

		int  i ;
		switch (Chose)
  80015d:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  800161:	83 f8 62             	cmp    $0x62,%eax
  800164:	74 1d                	je     800183 <_main+0x14b>
  800166:	83 f8 63             	cmp    $0x63,%eax
  800169:	74 2b                	je     800196 <_main+0x15e>
  80016b:	83 f8 61             	cmp    $0x61,%eax
  80016e:	75 39                	jne    8001a9 <_main+0x171>
		{
		case 'a':
			InitializeAscending(Elements, NumOfElements);
  800170:	83 ec 08             	sub    $0x8,%esp
  800173:	ff 75 f0             	pushl  -0x10(%ebp)
  800176:	ff 75 ec             	pushl  -0x14(%ebp)
  800179:	e8 f5 01 00 00       	call   800373 <InitializeAscending>
  80017e:	83 c4 10             	add    $0x10,%esp
			break ;
  800181:	eb 37                	jmp    8001ba <_main+0x182>
		case 'b':
			InitializeIdentical(Elements, NumOfElements);
  800183:	83 ec 08             	sub    $0x8,%esp
  800186:	ff 75 f0             	pushl  -0x10(%ebp)
  800189:	ff 75 ec             	pushl  -0x14(%ebp)
  80018c:	e8 13 02 00 00       	call   8003a4 <InitializeIdentical>
  800191:	83 c4 10             	add    $0x10,%esp
			break ;
  800194:	eb 24                	jmp    8001ba <_main+0x182>
		case 'c':
			InitializeSemiRandom(Elements, NumOfElements);
  800196:	83 ec 08             	sub    $0x8,%esp
  800199:	ff 75 f0             	pushl  -0x10(%ebp)
  80019c:	ff 75 ec             	pushl  -0x14(%ebp)
  80019f:	e8 35 02 00 00       	call   8003d9 <InitializeSemiRandom>
  8001a4:	83 c4 10             	add    $0x10,%esp
			break ;
  8001a7:	eb 11                	jmp    8001ba <_main+0x182>
		default:
			InitializeSemiRandom(Elements, NumOfElements);
  8001a9:	83 ec 08             	sub    $0x8,%esp
  8001ac:	ff 75 f0             	pushl  -0x10(%ebp)
  8001af:	ff 75 ec             	pushl  -0x14(%ebp)
  8001b2:	e8 22 02 00 00       	call   8003d9 <InitializeSemiRandom>
  8001b7:	83 c4 10             	add    $0x10,%esp
		}

		MSort(Elements, 1, NumOfElements);
  8001ba:	83 ec 04             	sub    $0x4,%esp
  8001bd:	ff 75 f0             	pushl  -0x10(%ebp)
  8001c0:	6a 01                	push   $0x1
  8001c2:	ff 75 ec             	pushl  -0x14(%ebp)
  8001c5:	e8 ee 02 00 00       	call   8004b8 <MSort>
  8001ca:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  8001cd:	e8 d5 32 00 00       	call   8034a7 <sys_lock_cons>
		cprintf("Sorting is Finished!!!!it'll be checked now....\n") ;
  8001d2:	83 ec 0c             	sub    $0xc,%esp
  8001d5:	68 6c 48 80 00       	push   $0x80486c
  8001da:	e8 0d 0a 00 00       	call   800bec <cprintf>
  8001df:	83 c4 10             	add    $0x10,%esp
		//PrintElements(Elements, NumOfElements);
		sys_unlock_cons();
  8001e2:	e8 da 32 00 00       	call   8034c1 <sys_unlock_cons>

		uint32 Sorted = CheckSorted(Elements, NumOfElements);
  8001e7:	83 ec 08             	sub    $0x8,%esp
  8001ea:	ff 75 f0             	pushl  -0x10(%ebp)
  8001ed:	ff 75 ec             	pushl  -0x14(%ebp)
  8001f0:	e8 d4 00 00 00       	call   8002c9 <CheckSorted>
  8001f5:	83 c4 10             	add    $0x10,%esp
  8001f8:	89 45 e8             	mov    %eax,-0x18(%ebp)

		if(Sorted == 0) panic("The array is NOT sorted correctly") ;
  8001fb:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8001ff:	75 14                	jne    800215 <_main+0x1dd>
  800201:	83 ec 04             	sub    $0x4,%esp
  800204:	68 a0 48 80 00       	push   $0x8048a0
  800209:	6a 4e                	push   $0x4e
  80020b:	68 c2 48 80 00       	push   $0x8048c2
  800210:	e8 09 07 00 00       	call   80091e <_panic>
		else
		{
			sys_lock_cons();
  800215:	e8 8d 32 00 00       	call   8034a7 <sys_lock_cons>
			cprintf("===============================================\n") ;
  80021a:	83 ec 0c             	sub    $0xc,%esp
  80021d:	68 e0 48 80 00       	push   $0x8048e0
  800222:	e8 c5 09 00 00       	call   800bec <cprintf>
  800227:	83 c4 10             	add    $0x10,%esp
			cprintf("Congratulations!! The array is sorted correctly\n") ;
  80022a:	83 ec 0c             	sub    $0xc,%esp
  80022d:	68 14 49 80 00       	push   $0x804914
  800232:	e8 b5 09 00 00       	call   800bec <cprintf>
  800237:	83 c4 10             	add    $0x10,%esp
			cprintf("===============================================\n\n") ;
  80023a:	83 ec 0c             	sub    $0xc,%esp
  80023d:	68 48 49 80 00       	push   $0x804948
  800242:	e8 a5 09 00 00       	call   800bec <cprintf>
  800247:	83 c4 10             	add    $0x10,%esp
			sys_unlock_cons();
  80024a:	e8 72 32 00 00       	call   8034c1 <sys_unlock_cons>
		}

		free(Elements) ;
  80024f:	83 ec 0c             	sub    $0xc,%esp
  800252:	ff 75 ec             	pushl  -0x14(%ebp)
  800255:	e8 a9 1e 00 00       	call   802103 <free>
  80025a:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  80025d:	e8 45 32 00 00       	call   8034a7 <sys_lock_cons>
			Chose = 0 ;
  800262:	c6 45 f7 00          	movb   $0x0,-0x9(%ebp)
			while (Chose != 'y' && Chose != 'n')
  800266:	eb 3e                	jmp    8002a6 <_main+0x26e>
			{
				cprintf("Do you want to repeat (y/n): ") ;
  800268:	83 ec 0c             	sub    $0xc,%esp
  80026b:	68 7a 49 80 00       	push   $0x80497a
  800270:	e8 77 09 00 00       	call   800bec <cprintf>
  800275:	83 c4 10             	add    $0x10,%esp
				Chose = 'n' ;
  800278:	c6 45 f7 6e          	movb   $0x6e,-0x9(%ebp)
				cputchar(Chose);
  80027c:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  800280:	83 ec 0c             	sub    $0xc,%esp
  800283:	50                   	push   %eax
  800284:	e8 a0 04 00 00       	call   800729 <cputchar>
  800289:	83 c4 10             	add    $0x10,%esp
				cputchar('\n');
  80028c:	83 ec 0c             	sub    $0xc,%esp
  80028f:	6a 0a                	push   $0xa
  800291:	e8 93 04 00 00       	call   800729 <cputchar>
  800296:	83 c4 10             	add    $0x10,%esp
				cputchar('\n');
  800299:	83 ec 0c             	sub    $0xc,%esp
  80029c:	6a 0a                	push   $0xa
  80029e:	e8 86 04 00 00       	call   800729 <cputchar>
  8002a3:	83 c4 10             	add    $0x10,%esp

		free(Elements) ;

		sys_lock_cons();
			Chose = 0 ;
			while (Chose != 'y' && Chose != 'n')
  8002a6:	80 7d f7 79          	cmpb   $0x79,-0x9(%ebp)
  8002aa:	74 06                	je     8002b2 <_main+0x27a>
  8002ac:	80 7d f7 6e          	cmpb   $0x6e,-0x9(%ebp)
  8002b0:	75 b6                	jne    800268 <_main+0x230>
				Chose = 'n' ;
				cputchar(Chose);
				cputchar('\n');
				cputchar('\n');
			}
		sys_unlock_cons();
  8002b2:	e8 0a 32 00 00       	call   8034c1 <sys_unlock_cons>

	} while (Chose == 'y');
  8002b7:	80 7d f7 79          	cmpb   $0x79,-0x9(%ebp)
  8002bb:	0f 84 80 fd ff ff    	je     800041 <_main+0x9>

	//To indicate that it's completed successfully
	inctst();
  8002c1:	e8 98 35 00 00       	call   80385e <inctst>

}
  8002c6:	90                   	nop
  8002c7:	c9                   	leave  
  8002c8:	c3                   	ret    

008002c9 <CheckSorted>:


uint32 CheckSorted(int *Elements, int NumOfElements)
{
  8002c9:	55                   	push   %ebp
  8002ca:	89 e5                	mov    %esp,%ebp
  8002cc:	83 ec 10             	sub    $0x10,%esp
	uint32 Sorted = 1 ;
  8002cf:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
	int i ;
	for (i = 0 ; i < NumOfElements - 1; i++)
  8002d6:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8002dd:	eb 33                	jmp    800312 <CheckSorted+0x49>
	{
		if (Elements[i] > Elements[i+1])
  8002df:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8002e2:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8002e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8002ec:	01 d0                	add    %edx,%eax
  8002ee:	8b 10                	mov    (%eax),%edx
  8002f0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8002f3:	40                   	inc    %eax
  8002f4:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8002fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8002fe:	01 c8                	add    %ecx,%eax
  800300:	8b 00                	mov    (%eax),%eax
  800302:	39 c2                	cmp    %eax,%edx
  800304:	7e 09                	jle    80030f <CheckSorted+0x46>
		{
			Sorted = 0 ;
  800306:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
			break;
  80030d:	eb 0c                	jmp    80031b <CheckSorted+0x52>

uint32 CheckSorted(int *Elements, int NumOfElements)
{
	uint32 Sorted = 1 ;
	int i ;
	for (i = 0 ; i < NumOfElements - 1; i++)
  80030f:	ff 45 f8             	incl   -0x8(%ebp)
  800312:	8b 45 0c             	mov    0xc(%ebp),%eax
  800315:	48                   	dec    %eax
  800316:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800319:	7f c4                	jg     8002df <CheckSorted+0x16>
		{
			Sorted = 0 ;
			break;
		}
	}
	return Sorted ;
  80031b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80031e:	c9                   	leave  
  80031f:	c3                   	ret    

00800320 <Swap>:

///Private Functions


void Swap(int *Elements, int First, int Second)
{
  800320:	55                   	push   %ebp
  800321:	89 e5                	mov    %esp,%ebp
  800323:	83 ec 10             	sub    $0x10,%esp
	int Tmp = Elements[First] ;
  800326:	8b 45 0c             	mov    0xc(%ebp),%eax
  800329:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800330:	8b 45 08             	mov    0x8(%ebp),%eax
  800333:	01 d0                	add    %edx,%eax
  800335:	8b 00                	mov    (%eax),%eax
  800337:	89 45 fc             	mov    %eax,-0x4(%ebp)
	Elements[First] = Elements[Second] ;
  80033a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80033d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800344:	8b 45 08             	mov    0x8(%ebp),%eax
  800347:	01 c2                	add    %eax,%edx
  800349:	8b 45 10             	mov    0x10(%ebp),%eax
  80034c:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800353:	8b 45 08             	mov    0x8(%ebp),%eax
  800356:	01 c8                	add    %ecx,%eax
  800358:	8b 00                	mov    (%eax),%eax
  80035a:	89 02                	mov    %eax,(%edx)
	Elements[Second] = Tmp ;
  80035c:	8b 45 10             	mov    0x10(%ebp),%eax
  80035f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800366:	8b 45 08             	mov    0x8(%ebp),%eax
  800369:	01 c2                	add    %eax,%edx
  80036b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80036e:	89 02                	mov    %eax,(%edx)
}
  800370:	90                   	nop
  800371:	c9                   	leave  
  800372:	c3                   	ret    

00800373 <InitializeAscending>:

void InitializeAscending(int *Elements, int NumOfElements)
{
  800373:	55                   	push   %ebp
  800374:	89 e5                	mov    %esp,%ebp
  800376:	83 ec 10             	sub    $0x10,%esp
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  800379:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800380:	eb 17                	jmp    800399 <InitializeAscending+0x26>
	{
		(Elements)[i] = i ;
  800382:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800385:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80038c:	8b 45 08             	mov    0x8(%ebp),%eax
  80038f:	01 c2                	add    %eax,%edx
  800391:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800394:	89 02                	mov    %eax,(%edx)
}

void InitializeAscending(int *Elements, int NumOfElements)
{
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  800396:	ff 45 fc             	incl   -0x4(%ebp)
  800399:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80039c:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80039f:	7c e1                	jl     800382 <InitializeAscending+0xf>
	{
		(Elements)[i] = i ;
	}

}
  8003a1:	90                   	nop
  8003a2:	c9                   	leave  
  8003a3:	c3                   	ret    

008003a4 <InitializeIdentical>:

void InitializeIdentical(int *Elements, int NumOfElements)
{
  8003a4:	55                   	push   %ebp
  8003a5:	89 e5                	mov    %esp,%ebp
  8003a7:	83 ec 10             	sub    $0x10,%esp
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  8003aa:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8003b1:	eb 1b                	jmp    8003ce <InitializeIdentical+0x2a>
	{
		Elements[i] = NumOfElements - i - 1 ;
  8003b3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8003b6:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8003c0:	01 c2                	add    %eax,%edx
  8003c2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003c5:	2b 45 fc             	sub    -0x4(%ebp),%eax
  8003c8:	48                   	dec    %eax
  8003c9:	89 02                	mov    %eax,(%edx)
}

void InitializeIdentical(int *Elements, int NumOfElements)
{
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  8003cb:	ff 45 fc             	incl   -0x4(%ebp)
  8003ce:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8003d1:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8003d4:	7c dd                	jl     8003b3 <InitializeIdentical+0xf>
	{
		Elements[i] = NumOfElements - i - 1 ;
	}

}
  8003d6:	90                   	nop
  8003d7:	c9                   	leave  
  8003d8:	c3                   	ret    

008003d9 <InitializeSemiRandom>:

void InitializeSemiRandom(int *Elements, int NumOfElements)
{
  8003d9:	55                   	push   %ebp
  8003da:	89 e5                	mov    %esp,%ebp
  8003dc:	83 ec 10             	sub    $0x10,%esp
	int i ;
	int Repetition = NumOfElements / 3 ;
  8003df:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8003e2:	b8 56 55 55 55       	mov    $0x55555556,%eax
  8003e7:	f7 e9                	imul   %ecx
  8003e9:	c1 f9 1f             	sar    $0x1f,%ecx
  8003ec:	89 d0                	mov    %edx,%eax
  8003ee:	29 c8                	sub    %ecx,%eax
  8003f0:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (Repetition == 0)
  8003f3:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  8003f7:	75 07                	jne    800400 <InitializeSemiRandom+0x27>
			Repetition = 3;
  8003f9:	c7 45 f8 03 00 00 00 	movl   $0x3,-0x8(%ebp)
	for (i = 0 ; i < NumOfElements ; i++)
  800400:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800407:	eb 1e                	jmp    800427 <InitializeSemiRandom+0x4e>
	{
		Elements[i] = i % Repetition ;
  800409:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80040c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800413:	8b 45 08             	mov    0x8(%ebp),%eax
  800416:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  800419:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80041c:	99                   	cltd   
  80041d:	f7 7d f8             	idivl  -0x8(%ebp)
  800420:	89 d0                	mov    %edx,%eax
  800422:	89 01                	mov    %eax,(%ecx)
{
	int i ;
	int Repetition = NumOfElements / 3 ;
	if (Repetition == 0)
			Repetition = 3;
	for (i = 0 ; i < NumOfElements ; i++)
  800424:	ff 45 fc             	incl   -0x4(%ebp)
  800427:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80042a:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80042d:	7c da                	jl     800409 <InitializeSemiRandom+0x30>
	{
		Elements[i] = i % Repetition ;
		//	cprintf("i=%d\n",i);
	}

}
  80042f:	90                   	nop
  800430:	c9                   	leave  
  800431:	c3                   	ret    

00800432 <PrintElements>:

void PrintElements(int *Elements, int NumOfElements)
{
  800432:	55                   	push   %ebp
  800433:	89 e5                	mov    %esp,%ebp
  800435:	83 ec 18             	sub    $0x18,%esp
	int i ;
	int NumsPerLine = 20 ;
  800438:	c7 45 f0 14 00 00 00 	movl   $0x14,-0x10(%ebp)
	for (i = 0 ; i < NumOfElements-1 ; i++)
  80043f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800446:	eb 42                	jmp    80048a <PrintElements+0x58>
	{
		if (i%NumsPerLine == 0)
  800448:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80044b:	99                   	cltd   
  80044c:	f7 7d f0             	idivl  -0x10(%ebp)
  80044f:	89 d0                	mov    %edx,%eax
  800451:	85 c0                	test   %eax,%eax
  800453:	75 10                	jne    800465 <PrintElements+0x33>
			cprintf("\n");
  800455:	83 ec 0c             	sub    $0xc,%esp
  800458:	68 c0 47 80 00       	push   $0x8047c0
  80045d:	e8 8a 07 00 00       	call   800bec <cprintf>
  800462:	83 c4 10             	add    $0x10,%esp
		cprintf("%d, ",Elements[i]);
  800465:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800468:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80046f:	8b 45 08             	mov    0x8(%ebp),%eax
  800472:	01 d0                	add    %edx,%eax
  800474:	8b 00                	mov    (%eax),%eax
  800476:	83 ec 08             	sub    $0x8,%esp
  800479:	50                   	push   %eax
  80047a:	68 98 49 80 00       	push   $0x804998
  80047f:	e8 68 07 00 00       	call   800bec <cprintf>
  800484:	83 c4 10             	add    $0x10,%esp

void PrintElements(int *Elements, int NumOfElements)
{
	int i ;
	int NumsPerLine = 20 ;
	for (i = 0 ; i < NumOfElements-1 ; i++)
  800487:	ff 45 f4             	incl   -0xc(%ebp)
  80048a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80048d:	48                   	dec    %eax
  80048e:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800491:	7f b5                	jg     800448 <PrintElements+0x16>
	{
		if (i%NumsPerLine == 0)
			cprintf("\n");
		cprintf("%d, ",Elements[i]);
	}
	cprintf("%d\n",Elements[i]);
  800493:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800496:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80049d:	8b 45 08             	mov    0x8(%ebp),%eax
  8004a0:	01 d0                	add    %edx,%eax
  8004a2:	8b 00                	mov    (%eax),%eax
  8004a4:	83 ec 08             	sub    $0x8,%esp
  8004a7:	50                   	push   %eax
  8004a8:	68 0f 48 80 00       	push   $0x80480f
  8004ad:	e8 3a 07 00 00       	call   800bec <cprintf>
  8004b2:	83 c4 10             	add    $0x10,%esp

}
  8004b5:	90                   	nop
  8004b6:	c9                   	leave  
  8004b7:	c3                   	ret    

008004b8 <MSort>:


void MSort(int* A, int p, int r)
{
  8004b8:	55                   	push   %ebp
  8004b9:	89 e5                	mov    %esp,%ebp
  8004bb:	83 ec 18             	sub    $0x18,%esp
	if (p >= r)
  8004be:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004c1:	3b 45 10             	cmp    0x10(%ebp),%eax
  8004c4:	7d 54                	jge    80051a <MSort+0x62>
	{
		return;
	}

	int q = (p + r) / 2;
  8004c6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004c9:	8b 45 10             	mov    0x10(%ebp),%eax
  8004cc:	01 d0                	add    %edx,%eax
  8004ce:	89 c2                	mov    %eax,%edx
  8004d0:	c1 ea 1f             	shr    $0x1f,%edx
  8004d3:	01 d0                	add    %edx,%eax
  8004d5:	d1 f8                	sar    %eax
  8004d7:	89 45 f4             	mov    %eax,-0xc(%ebp)

	MSort(A, p, q);
  8004da:	83 ec 04             	sub    $0x4,%esp
  8004dd:	ff 75 f4             	pushl  -0xc(%ebp)
  8004e0:	ff 75 0c             	pushl  0xc(%ebp)
  8004e3:	ff 75 08             	pushl  0x8(%ebp)
  8004e6:	e8 cd ff ff ff       	call   8004b8 <MSort>
  8004eb:	83 c4 10             	add    $0x10,%esp

	MSort(A, q + 1, r);
  8004ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8004f1:	40                   	inc    %eax
  8004f2:	83 ec 04             	sub    $0x4,%esp
  8004f5:	ff 75 10             	pushl  0x10(%ebp)
  8004f8:	50                   	push   %eax
  8004f9:	ff 75 08             	pushl  0x8(%ebp)
  8004fc:	e8 b7 ff ff ff       	call   8004b8 <MSort>
  800501:	83 c4 10             	add    $0x10,%esp

	Merge(A, p, q, r);
  800504:	ff 75 10             	pushl  0x10(%ebp)
  800507:	ff 75 f4             	pushl  -0xc(%ebp)
  80050a:	ff 75 0c             	pushl  0xc(%ebp)
  80050d:	ff 75 08             	pushl  0x8(%ebp)
  800510:	e8 08 00 00 00       	call   80051d <Merge>
  800515:	83 c4 10             	add    $0x10,%esp
  800518:	eb 01                	jmp    80051b <MSort+0x63>

void MSort(int* A, int p, int r)
{
	if (p >= r)
	{
		return;
  80051a:	90                   	nop

	MSort(A, q + 1, r);

	Merge(A, p, q, r);

}
  80051b:	c9                   	leave  
  80051c:	c3                   	ret    

0080051d <Merge>:

void Merge(int* A, int p, int q, int r)
{
  80051d:	55                   	push   %ebp
  80051e:	89 e5                	mov    %esp,%ebp
  800520:	83 ec 38             	sub    $0x38,%esp
	int leftCapacity = q - p + 1;
  800523:	8b 45 10             	mov    0x10(%ebp),%eax
  800526:	2b 45 0c             	sub    0xc(%ebp),%eax
  800529:	40                   	inc    %eax
  80052a:	89 45 e0             	mov    %eax,-0x20(%ebp)

	int rightCapacity = r - q;
  80052d:	8b 45 14             	mov    0x14(%ebp),%eax
  800530:	2b 45 10             	sub    0x10(%ebp),%eax
  800533:	89 45 dc             	mov    %eax,-0x24(%ebp)

	int leftIndex = 0;
  800536:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	int rightIndex = 0;
  80053d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	int* Left = malloc(sizeof(int) * leftCapacity);
  800544:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800547:	c1 e0 02             	shl    $0x2,%eax
  80054a:	83 ec 0c             	sub    $0xc,%esp
  80054d:	50                   	push   %eax
  80054e:	e8 b2 16 00 00       	call   801c05 <malloc>
  800553:	83 c4 10             	add    $0x10,%esp
  800556:	89 45 d8             	mov    %eax,-0x28(%ebp)

	int* Right = malloc(sizeof(int) * rightCapacity);
  800559:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80055c:	c1 e0 02             	shl    $0x2,%eax
  80055f:	83 ec 0c             	sub    $0xc,%esp
  800562:	50                   	push   %eax
  800563:	e8 9d 16 00 00       	call   801c05 <malloc>
  800568:	83 c4 10             	add    $0x10,%esp
  80056b:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	int i, j, k;
	for (i = 0; i < leftCapacity; i++)
  80056e:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  800575:	eb 2f                	jmp    8005a6 <Merge+0x89>
	{
		Left[i] = A[p + i - 1];
  800577:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80057a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800581:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800584:	01 c2                	add    %eax,%edx
  800586:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800589:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80058c:	01 c8                	add    %ecx,%eax
  80058e:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  800593:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80059a:	8b 45 08             	mov    0x8(%ebp),%eax
  80059d:	01 c8                	add    %ecx,%eax
  80059f:	8b 00                	mov    (%eax),%eax
  8005a1:	89 02                	mov    %eax,(%edx)
	int* Left = malloc(sizeof(int) * leftCapacity);

	int* Right = malloc(sizeof(int) * rightCapacity);

	int i, j, k;
	for (i = 0; i < leftCapacity; i++)
  8005a3:	ff 45 ec             	incl   -0x14(%ebp)
  8005a6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8005a9:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8005ac:	7c c9                	jl     800577 <Merge+0x5a>
	{
		Left[i] = A[p + i - 1];
	}
	for (j = 0; j < rightCapacity; j++)
  8005ae:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8005b5:	eb 2a                	jmp    8005e1 <Merge+0xc4>
	{
		Right[j] = A[q + j];
  8005b7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8005ba:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8005c1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8005c4:	01 c2                	add    %eax,%edx
  8005c6:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8005c9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8005cc:	01 c8                	add    %ecx,%eax
  8005ce:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8005d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8005d8:	01 c8                	add    %ecx,%eax
  8005da:	8b 00                	mov    (%eax),%eax
  8005dc:	89 02                	mov    %eax,(%edx)
	int i, j, k;
	for (i = 0; i < leftCapacity; i++)
	{
		Left[i] = A[p + i - 1];
	}
	for (j = 0; j < rightCapacity; j++)
  8005de:	ff 45 e8             	incl   -0x18(%ebp)
  8005e1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8005e4:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8005e7:	7c ce                	jl     8005b7 <Merge+0x9a>
	{
		Right[j] = A[q + j];
	}

	for ( k = p; k <= r; k++)
  8005e9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005ec:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8005ef:	e9 0a 01 00 00       	jmp    8006fe <Merge+0x1e1>
	{
		if (leftIndex < leftCapacity && rightIndex < rightCapacity)
  8005f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8005f7:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8005fa:	0f 8d 95 00 00 00    	jge    800695 <Merge+0x178>
  800600:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800603:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800606:	0f 8d 89 00 00 00    	jge    800695 <Merge+0x178>
		{
			if (Left[leftIndex] < Right[rightIndex] )
  80060c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80060f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800616:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800619:	01 d0                	add    %edx,%eax
  80061b:	8b 10                	mov    (%eax),%edx
  80061d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800620:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800627:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80062a:	01 c8                	add    %ecx,%eax
  80062c:	8b 00                	mov    (%eax),%eax
  80062e:	39 c2                	cmp    %eax,%edx
  800630:	7d 33                	jge    800665 <Merge+0x148>
			{
				A[k - 1] = Left[leftIndex++];
  800632:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800635:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  80063a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800641:	8b 45 08             	mov    0x8(%ebp),%eax
  800644:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  800647:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80064a:	8d 50 01             	lea    0x1(%eax),%edx
  80064d:	89 55 f4             	mov    %edx,-0xc(%ebp)
  800650:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800657:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80065a:	01 d0                	add    %edx,%eax
  80065c:	8b 00                	mov    (%eax),%eax
  80065e:	89 01                	mov    %eax,(%ecx)

	for ( k = p; k <= r; k++)
	{
		if (leftIndex < leftCapacity && rightIndex < rightCapacity)
		{
			if (Left[leftIndex] < Right[rightIndex] )
  800660:	e9 96 00 00 00       	jmp    8006fb <Merge+0x1de>
			{
				A[k - 1] = Left[leftIndex++];
			}
			else
			{
				A[k - 1] = Right[rightIndex++];
  800665:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800668:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  80066d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800674:	8b 45 08             	mov    0x8(%ebp),%eax
  800677:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  80067a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80067d:	8d 50 01             	lea    0x1(%eax),%edx
  800680:	89 55 f0             	mov    %edx,-0x10(%ebp)
  800683:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80068a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80068d:	01 d0                	add    %edx,%eax
  80068f:	8b 00                	mov    (%eax),%eax
  800691:	89 01                	mov    %eax,(%ecx)

	for ( k = p; k <= r; k++)
	{
		if (leftIndex < leftCapacity && rightIndex < rightCapacity)
		{
			if (Left[leftIndex] < Right[rightIndex] )
  800693:	eb 66                	jmp    8006fb <Merge+0x1de>
			else
			{
				A[k - 1] = Right[rightIndex++];
			}
		}
		else if (leftIndex < leftCapacity)
  800695:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800698:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80069b:	7d 30                	jge    8006cd <Merge+0x1b0>
		{
			A[k - 1] = Left[leftIndex++];
  80069d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8006a0:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  8006a5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8006ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8006af:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  8006b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8006b5:	8d 50 01             	lea    0x1(%eax),%edx
  8006b8:	89 55 f4             	mov    %edx,-0xc(%ebp)
  8006bb:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8006c2:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8006c5:	01 d0                	add    %edx,%eax
  8006c7:	8b 00                	mov    (%eax),%eax
  8006c9:	89 01                	mov    %eax,(%ecx)
  8006cb:	eb 2e                	jmp    8006fb <Merge+0x1de>
		}
		else
		{
			A[k - 1] = Right[rightIndex++];
  8006cd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8006d0:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  8006d5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8006dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8006df:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  8006e2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8006e5:	8d 50 01             	lea    0x1(%eax),%edx
  8006e8:	89 55 f0             	mov    %edx,-0x10(%ebp)
  8006eb:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8006f2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8006f5:	01 d0                	add    %edx,%eax
  8006f7:	8b 00                	mov    (%eax),%eax
  8006f9:	89 01                	mov    %eax,(%ecx)
	for (j = 0; j < rightCapacity; j++)
	{
		Right[j] = A[q + j];
	}

	for ( k = p; k <= r; k++)
  8006fb:	ff 45 e4             	incl   -0x1c(%ebp)
  8006fe:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800701:	3b 45 14             	cmp    0x14(%ebp),%eax
  800704:	0f 8e ea fe ff ff    	jle    8005f4 <Merge+0xd7>
		{
			A[k - 1] = Right[rightIndex++];
		}
	}

	free(Left);
  80070a:	83 ec 0c             	sub    $0xc,%esp
  80070d:	ff 75 d8             	pushl  -0x28(%ebp)
  800710:	e8 ee 19 00 00       	call   802103 <free>
  800715:	83 c4 10             	add    $0x10,%esp
	free(Right);
  800718:	83 ec 0c             	sub    $0xc,%esp
  80071b:	ff 75 d4             	pushl  -0x2c(%ebp)
  80071e:	e8 e0 19 00 00       	call   802103 <free>
  800723:	83 c4 10             	add    $0x10,%esp

}
  800726:	90                   	nop
  800727:	c9                   	leave  
  800728:	c3                   	ret    

00800729 <cputchar>:
#include <inc/lib.h>


void
cputchar(int ch)
{
  800729:	55                   	push   %ebp
  80072a:	89 e5                	mov    %esp,%ebp
  80072c:	83 ec 18             	sub    $0x18,%esp
	char c = ch;
  80072f:	8b 45 08             	mov    0x8(%ebp),%eax
  800732:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  800735:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  800739:	83 ec 0c             	sub    $0xc,%esp
  80073c:	50                   	push   %eax
  80073d:	e8 ad 2e 00 00       	call   8035ef <sys_cputc>
  800742:	83 c4 10             	add    $0x10,%esp
}
  800745:	90                   	nop
  800746:	c9                   	leave  
  800747:	c3                   	ret    

00800748 <getchar>:


int
getchar(void)
{
  800748:	55                   	push   %ebp
  800749:	89 e5                	mov    %esp,%ebp
  80074b:	83 ec 18             	sub    $0x18,%esp
	int c =sys_cgetc();
  80074e:	e8 3b 2d 00 00       	call   80348e <sys_cgetc>
  800753:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return c;
  800756:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800759:	c9                   	leave  
  80075a:	c3                   	ret    

0080075b <iscons>:

int iscons(int fdnum)
{
  80075b:	55                   	push   %ebp
  80075c:	89 e5                	mov    %esp,%ebp
	// used by readline
	return 1;
  80075e:	b8 01 00 00 00       	mov    $0x1,%eax
}
  800763:	5d                   	pop    %ebp
  800764:	c3                   	ret    

00800765 <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  800765:	55                   	push   %ebp
  800766:	89 e5                	mov    %esp,%ebp
  800768:	57                   	push   %edi
  800769:	56                   	push   %esi
  80076a:	53                   	push   %ebx
  80076b:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  80076e:	e8 ad 2f 00 00       	call   803720 <sys_getenvindex>
  800773:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  800776:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800779:	89 d0                	mov    %edx,%eax
  80077b:	c1 e0 02             	shl    $0x2,%eax
  80077e:	01 d0                	add    %edx,%eax
  800780:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800787:	01 d0                	add    %edx,%eax
  800789:	89 c2                	mov    %eax,%edx
  80078b:	c1 e2 04             	shl    $0x4,%edx
  80078e:	29 c2                	sub    %eax,%edx
  800790:	8d 04 95 00 00 00 00 	lea    0x0(,%edx,4),%eax
  800797:	89 c2                	mov    %eax,%edx
  800799:	8d 82 00 00 c0 ee    	lea    -0x11400000(%edx),%eax
  80079f:	a3 24 60 80 00       	mov    %eax,0x806024

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8007a4:	a1 24 60 80 00       	mov    0x806024,%eax
  8007a9:	8a 40 20             	mov    0x20(%eax),%al
  8007ac:	84 c0                	test   %al,%al
  8007ae:	74 0d                	je     8007bd <libmain+0x58>
		binaryname = myEnv->prog_name;
  8007b0:	a1 24 60 80 00       	mov    0x806024,%eax
  8007b5:	83 c0 20             	add    $0x20,%eax
  8007b8:	a3 04 60 80 00       	mov    %eax,0x806004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8007bd:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8007c1:	7e 0a                	jle    8007cd <libmain+0x68>
		binaryname = argv[0];
  8007c3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007c6:	8b 00                	mov    (%eax),%eax
  8007c8:	a3 04 60 80 00       	mov    %eax,0x806004

	// call user main routine
	_main(argc, argv);
  8007cd:	83 ec 08             	sub    $0x8,%esp
  8007d0:	ff 75 0c             	pushl  0xc(%ebp)
  8007d3:	ff 75 08             	pushl  0x8(%ebp)
  8007d6:	e8 5d f8 ff ff       	call   800038 <_main>
  8007db:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  8007de:	a1 00 60 80 00       	mov    0x806000,%eax
  8007e3:	85 c0                	test   %eax,%eax
  8007e5:	0f 84 01 01 00 00    	je     8008ec <libmain+0x187>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  8007eb:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  8007f1:	bb 98 4a 80 00       	mov    $0x804a98,%ebx
  8007f6:	ba 0e 00 00 00       	mov    $0xe,%edx
  8007fb:	89 c7                	mov    %eax,%edi
  8007fd:	89 de                	mov    %ebx,%esi
  8007ff:	89 d1                	mov    %edx,%ecx
  800801:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  800803:	8d 55 8a             	lea    -0x76(%ebp),%edx
  800806:	b9 56 00 00 00       	mov    $0x56,%ecx
  80080b:	b0 00                	mov    $0x0,%al
  80080d:	89 d7                	mov    %edx,%edi
  80080f:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  800811:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  800818:	8d 45 e0             	lea    -0x20(%ebp),%eax
  80081b:	83 ec 08             	sub    $0x8,%esp
  80081e:	50                   	push   %eax
  80081f:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  800825:	50                   	push   %eax
  800826:	e8 2b 31 00 00       	call   803956 <sys_utilities>
  80082b:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  80082e:	e8 74 2c 00 00       	call   8034a7 <sys_lock_cons>
		{
			cprintf("**************************************\n");
  800833:	83 ec 0c             	sub    $0xc,%esp
  800836:	68 b8 49 80 00       	push   $0x8049b8
  80083b:	e8 ac 03 00 00       	call   800bec <cprintf>
  800840:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  800843:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800846:	85 c0                	test   %eax,%eax
  800848:	74 18                	je     800862 <libmain+0xfd>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  80084a:	e8 25 31 00 00       	call   803974 <sys_get_optimal_num_faults>
  80084f:	83 ec 08             	sub    $0x8,%esp
  800852:	50                   	push   %eax
  800853:	68 e0 49 80 00       	push   $0x8049e0
  800858:	e8 8f 03 00 00       	call   800bec <cprintf>
  80085d:	83 c4 10             	add    $0x10,%esp
  800860:	eb 59                	jmp    8008bb <libmain+0x156>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800862:	a1 24 60 80 00       	mov    0x806024,%eax
  800867:	8b 90 bc 05 00 00    	mov    0x5bc(%eax),%edx
  80086d:	a1 24 60 80 00       	mov    0x806024,%eax
  800872:	8b 80 ac 05 00 00    	mov    0x5ac(%eax),%eax
  800878:	83 ec 04             	sub    $0x4,%esp
  80087b:	52                   	push   %edx
  80087c:	50                   	push   %eax
  80087d:	68 04 4a 80 00       	push   $0x804a04
  800882:	e8 65 03 00 00       	call   800bec <cprintf>
  800887:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  80088a:	a1 24 60 80 00       	mov    0x806024,%eax
  80088f:	8b 88 d0 05 00 00    	mov    0x5d0(%eax),%ecx
  800895:	a1 24 60 80 00       	mov    0x806024,%eax
  80089a:	8b 90 cc 05 00 00    	mov    0x5cc(%eax),%edx
  8008a0:	a1 24 60 80 00       	mov    0x806024,%eax
  8008a5:	8b 80 c8 05 00 00    	mov    0x5c8(%eax),%eax
  8008ab:	51                   	push   %ecx
  8008ac:	52                   	push   %edx
  8008ad:	50                   	push   %eax
  8008ae:	68 2c 4a 80 00       	push   $0x804a2c
  8008b3:	e8 34 03 00 00       	call   800bec <cprintf>
  8008b8:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8008bb:	a1 24 60 80 00       	mov    0x806024,%eax
  8008c0:	8b 80 d4 05 00 00    	mov    0x5d4(%eax),%eax
  8008c6:	83 ec 08             	sub    $0x8,%esp
  8008c9:	50                   	push   %eax
  8008ca:	68 84 4a 80 00       	push   $0x804a84
  8008cf:	e8 18 03 00 00       	call   800bec <cprintf>
  8008d4:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  8008d7:	83 ec 0c             	sub    $0xc,%esp
  8008da:	68 b8 49 80 00       	push   $0x8049b8
  8008df:	e8 08 03 00 00       	call   800bec <cprintf>
  8008e4:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  8008e7:	e8 d5 2b 00 00       	call   8034c1 <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  8008ec:	e8 1f 00 00 00       	call   800910 <exit>
}
  8008f1:	90                   	nop
  8008f2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8008f5:	5b                   	pop    %ebx
  8008f6:	5e                   	pop    %esi
  8008f7:	5f                   	pop    %edi
  8008f8:	5d                   	pop    %ebp
  8008f9:	c3                   	ret    

008008fa <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8008fa:	55                   	push   %ebp
  8008fb:	89 e5                	mov    %esp,%ebp
  8008fd:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800900:	83 ec 0c             	sub    $0xc,%esp
  800903:	6a 00                	push   $0x0
  800905:	e8 e2 2d 00 00       	call   8036ec <sys_destroy_env>
  80090a:	83 c4 10             	add    $0x10,%esp
}
  80090d:	90                   	nop
  80090e:	c9                   	leave  
  80090f:	c3                   	ret    

00800910 <exit>:

void
exit(void)
{
  800910:	55                   	push   %ebp
  800911:	89 e5                	mov    %esp,%ebp
  800913:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800916:	e8 37 2e 00 00       	call   803752 <sys_exit_env>
}
  80091b:	90                   	nop
  80091c:	c9                   	leave  
  80091d:	c3                   	ret    

0080091e <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  80091e:	55                   	push   %ebp
  80091f:	89 e5                	mov    %esp,%ebp
  800921:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800924:	8d 45 10             	lea    0x10(%ebp),%eax
  800927:	83 c0 04             	add    $0x4,%eax
  80092a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  80092d:	a1 18 e1 81 00       	mov    0x81e118,%eax
  800932:	85 c0                	test   %eax,%eax
  800934:	74 16                	je     80094c <_panic+0x2e>
		cprintf("%s: ", argv0);
  800936:	a1 18 e1 81 00       	mov    0x81e118,%eax
  80093b:	83 ec 08             	sub    $0x8,%esp
  80093e:	50                   	push   %eax
  80093f:	68 fc 4a 80 00       	push   $0x804afc
  800944:	e8 a3 02 00 00       	call   800bec <cprintf>
  800949:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  80094c:	a1 04 60 80 00       	mov    0x806004,%eax
  800951:	83 ec 0c             	sub    $0xc,%esp
  800954:	ff 75 0c             	pushl  0xc(%ebp)
  800957:	ff 75 08             	pushl  0x8(%ebp)
  80095a:	50                   	push   %eax
  80095b:	68 04 4b 80 00       	push   $0x804b04
  800960:	6a 74                	push   $0x74
  800962:	e8 b2 02 00 00       	call   800c19 <cprintf_colored>
  800967:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  80096a:	8b 45 10             	mov    0x10(%ebp),%eax
  80096d:	83 ec 08             	sub    $0x8,%esp
  800970:	ff 75 f4             	pushl  -0xc(%ebp)
  800973:	50                   	push   %eax
  800974:	e8 04 02 00 00       	call   800b7d <vcprintf>
  800979:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  80097c:	83 ec 08             	sub    $0x8,%esp
  80097f:	6a 00                	push   $0x0
  800981:	68 2c 4b 80 00       	push   $0x804b2c
  800986:	e8 f2 01 00 00       	call   800b7d <vcprintf>
  80098b:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  80098e:	e8 7d ff ff ff       	call   800910 <exit>

	// should not return here
	while (1) ;
  800993:	eb fe                	jmp    800993 <_panic+0x75>

00800995 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800995:	55                   	push   %ebp
  800996:	89 e5                	mov    %esp,%ebp
  800998:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  80099b:	a1 24 60 80 00       	mov    0x806024,%eax
  8009a0:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8009a6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009a9:	39 c2                	cmp    %eax,%edx
  8009ab:	74 14                	je     8009c1 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8009ad:	83 ec 04             	sub    $0x4,%esp
  8009b0:	68 30 4b 80 00       	push   $0x804b30
  8009b5:	6a 26                	push   $0x26
  8009b7:	68 7c 4b 80 00       	push   $0x804b7c
  8009bc:	e8 5d ff ff ff       	call   80091e <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8009c1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8009c8:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8009cf:	e9 c5 00 00 00       	jmp    800a99 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  8009d4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009d7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8009de:	8b 45 08             	mov    0x8(%ebp),%eax
  8009e1:	01 d0                	add    %edx,%eax
  8009e3:	8b 00                	mov    (%eax),%eax
  8009e5:	85 c0                	test   %eax,%eax
  8009e7:	75 08                	jne    8009f1 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  8009e9:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8009ec:	e9 a5 00 00 00       	jmp    800a96 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  8009f1:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8009f8:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8009ff:	eb 69                	jmp    800a6a <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800a01:	a1 24 60 80 00       	mov    0x806024,%eax
  800a06:	8b 88 a4 05 00 00    	mov    0x5a4(%eax),%ecx
  800a0c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800a0f:	89 d0                	mov    %edx,%eax
  800a11:	01 c0                	add    %eax,%eax
  800a13:	01 d0                	add    %edx,%eax
  800a15:	c1 e0 03             	shl    $0x3,%eax
  800a18:	01 c8                	add    %ecx,%eax
  800a1a:	8a 40 04             	mov    0x4(%eax),%al
  800a1d:	84 c0                	test   %al,%al
  800a1f:	75 46                	jne    800a67 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800a21:	a1 24 60 80 00       	mov    0x806024,%eax
  800a26:	8b 88 a4 05 00 00    	mov    0x5a4(%eax),%ecx
  800a2c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800a2f:	89 d0                	mov    %edx,%eax
  800a31:	01 c0                	add    %eax,%eax
  800a33:	01 d0                	add    %edx,%eax
  800a35:	c1 e0 03             	shl    $0x3,%eax
  800a38:	01 c8                	add    %ecx,%eax
  800a3a:	8b 00                	mov    (%eax),%eax
  800a3c:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800a3f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800a42:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800a47:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800a49:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a4c:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800a53:	8b 45 08             	mov    0x8(%ebp),%eax
  800a56:	01 c8                	add    %ecx,%eax
  800a58:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800a5a:	39 c2                	cmp    %eax,%edx
  800a5c:	75 09                	jne    800a67 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  800a5e:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800a65:	eb 15                	jmp    800a7c <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800a67:	ff 45 e8             	incl   -0x18(%ebp)
  800a6a:	a1 24 60 80 00       	mov    0x806024,%eax
  800a6f:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800a75:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800a78:	39 c2                	cmp    %eax,%edx
  800a7a:	77 85                	ja     800a01 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800a7c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800a80:	75 14                	jne    800a96 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  800a82:	83 ec 04             	sub    $0x4,%esp
  800a85:	68 88 4b 80 00       	push   $0x804b88
  800a8a:	6a 3a                	push   $0x3a
  800a8c:	68 7c 4b 80 00       	push   $0x804b7c
  800a91:	e8 88 fe ff ff       	call   80091e <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800a96:	ff 45 f0             	incl   -0x10(%ebp)
  800a99:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a9c:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800a9f:	0f 8c 2f ff ff ff    	jl     8009d4 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800aa5:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800aac:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800ab3:	eb 26                	jmp    800adb <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800ab5:	a1 24 60 80 00       	mov    0x806024,%eax
  800aba:	8b 88 a4 05 00 00    	mov    0x5a4(%eax),%ecx
  800ac0:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800ac3:	89 d0                	mov    %edx,%eax
  800ac5:	01 c0                	add    %eax,%eax
  800ac7:	01 d0                	add    %edx,%eax
  800ac9:	c1 e0 03             	shl    $0x3,%eax
  800acc:	01 c8                	add    %ecx,%eax
  800ace:	8a 40 04             	mov    0x4(%eax),%al
  800ad1:	3c 01                	cmp    $0x1,%al
  800ad3:	75 03                	jne    800ad8 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  800ad5:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800ad8:	ff 45 e0             	incl   -0x20(%ebp)
  800adb:	a1 24 60 80 00       	mov    0x806024,%eax
  800ae0:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800ae6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800ae9:	39 c2                	cmp    %eax,%edx
  800aeb:	77 c8                	ja     800ab5 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800aed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800af0:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800af3:	74 14                	je     800b09 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  800af5:	83 ec 04             	sub    $0x4,%esp
  800af8:	68 dc 4b 80 00       	push   $0x804bdc
  800afd:	6a 44                	push   $0x44
  800aff:	68 7c 4b 80 00       	push   $0x804b7c
  800b04:	e8 15 fe ff ff       	call   80091e <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800b09:	90                   	nop
  800b0a:	c9                   	leave  
  800b0b:	c3                   	ret    

00800b0c <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  800b0c:	55                   	push   %ebp
  800b0d:	89 e5                	mov    %esp,%ebp
  800b0f:	53                   	push   %ebx
  800b10:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  800b13:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b16:	8b 00                	mov    (%eax),%eax
  800b18:	8d 48 01             	lea    0x1(%eax),%ecx
  800b1b:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b1e:	89 0a                	mov    %ecx,(%edx)
  800b20:	8b 55 08             	mov    0x8(%ebp),%edx
  800b23:	88 d1                	mov    %dl,%cl
  800b25:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b28:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800b2c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b2f:	8b 00                	mov    (%eax),%eax
  800b31:	3d ff 00 00 00       	cmp    $0xff,%eax
  800b36:	75 30                	jne    800b68 <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  800b38:	8b 15 1c e1 81 00    	mov    0x81e11c,%edx
  800b3e:	a0 44 60 80 00       	mov    0x806044,%al
  800b43:	0f b6 c0             	movzbl %al,%eax
  800b46:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b49:	8b 09                	mov    (%ecx),%ecx
  800b4b:	89 cb                	mov    %ecx,%ebx
  800b4d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b50:	83 c1 08             	add    $0x8,%ecx
  800b53:	52                   	push   %edx
  800b54:	50                   	push   %eax
  800b55:	53                   	push   %ebx
  800b56:	51                   	push   %ecx
  800b57:	e8 07 29 00 00       	call   803463 <sys_cputs>
  800b5c:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800b5f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b62:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800b68:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b6b:	8b 40 04             	mov    0x4(%eax),%eax
  800b6e:	8d 50 01             	lea    0x1(%eax),%edx
  800b71:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b74:	89 50 04             	mov    %edx,0x4(%eax)
}
  800b77:	90                   	nop
  800b78:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800b7b:	c9                   	leave  
  800b7c:	c3                   	ret    

00800b7d <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800b7d:	55                   	push   %ebp
  800b7e:	89 e5                	mov    %esp,%ebp
  800b80:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800b86:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800b8d:	00 00 00 
	b.cnt = 0;
  800b90:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800b97:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800b9a:	ff 75 0c             	pushl  0xc(%ebp)
  800b9d:	ff 75 08             	pushl  0x8(%ebp)
  800ba0:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800ba6:	50                   	push   %eax
  800ba7:	68 0c 0b 80 00       	push   $0x800b0c
  800bac:	e8 5a 02 00 00       	call   800e0b <vprintfmt>
  800bb1:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  800bb4:	8b 15 1c e1 81 00    	mov    0x81e11c,%edx
  800bba:	a0 44 60 80 00       	mov    0x806044,%al
  800bbf:	0f b6 c0             	movzbl %al,%eax
  800bc2:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  800bc8:	52                   	push   %edx
  800bc9:	50                   	push   %eax
  800bca:	51                   	push   %ecx
  800bcb:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800bd1:	83 c0 08             	add    $0x8,%eax
  800bd4:	50                   	push   %eax
  800bd5:	e8 89 28 00 00       	call   803463 <sys_cputs>
  800bda:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800bdd:	c6 05 44 60 80 00 00 	movb   $0x0,0x806044
	return b.cnt;
  800be4:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800bea:	c9                   	leave  
  800beb:	c3                   	ret    

00800bec <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  800bec:	55                   	push   %ebp
  800bed:	89 e5                	mov    %esp,%ebp
  800bef:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800bf2:	c6 05 44 60 80 00 01 	movb   $0x1,0x806044
	va_start(ap, fmt);
  800bf9:	8d 45 0c             	lea    0xc(%ebp),%eax
  800bfc:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800bff:	8b 45 08             	mov    0x8(%ebp),%eax
  800c02:	83 ec 08             	sub    $0x8,%esp
  800c05:	ff 75 f4             	pushl  -0xc(%ebp)
  800c08:	50                   	push   %eax
  800c09:	e8 6f ff ff ff       	call   800b7d <vcprintf>
  800c0e:	83 c4 10             	add    $0x10,%esp
  800c11:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800c14:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800c17:	c9                   	leave  
  800c18:	c3                   	ret    

00800c19 <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  800c19:	55                   	push   %ebp
  800c1a:	89 e5                	mov    %esp,%ebp
  800c1c:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800c1f:	c6 05 44 60 80 00 01 	movb   $0x1,0x806044
	curTextClr = (textClr << 8) ; //set text color by the given value
  800c26:	8b 45 08             	mov    0x8(%ebp),%eax
  800c29:	c1 e0 08             	shl    $0x8,%eax
  800c2c:	a3 1c e1 81 00       	mov    %eax,0x81e11c
	va_start(ap, fmt);
  800c31:	8d 45 0c             	lea    0xc(%ebp),%eax
  800c34:	83 c0 04             	add    $0x4,%eax
  800c37:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800c3a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c3d:	83 ec 08             	sub    $0x8,%esp
  800c40:	ff 75 f4             	pushl  -0xc(%ebp)
  800c43:	50                   	push   %eax
  800c44:	e8 34 ff ff ff       	call   800b7d <vcprintf>
  800c49:	83 c4 10             	add    $0x10,%esp
  800c4c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  800c4f:	c7 05 1c e1 81 00 00 	movl   $0x700,0x81e11c
  800c56:	07 00 00 

	return cnt;
  800c59:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800c5c:	c9                   	leave  
  800c5d:	c3                   	ret    

00800c5e <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  800c5e:	55                   	push   %ebp
  800c5f:	89 e5                	mov    %esp,%ebp
  800c61:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  800c64:	e8 3e 28 00 00       	call   8034a7 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  800c69:	8d 45 0c             	lea    0xc(%ebp),%eax
  800c6c:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  800c6f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c72:	83 ec 08             	sub    $0x8,%esp
  800c75:	ff 75 f4             	pushl  -0xc(%ebp)
  800c78:	50                   	push   %eax
  800c79:	e8 ff fe ff ff       	call   800b7d <vcprintf>
  800c7e:	83 c4 10             	add    $0x10,%esp
  800c81:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  800c84:	e8 38 28 00 00       	call   8034c1 <sys_unlock_cons>
	return cnt;
  800c89:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800c8c:	c9                   	leave  
  800c8d:	c3                   	ret    

00800c8e <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800c8e:	55                   	push   %ebp
  800c8f:	89 e5                	mov    %esp,%ebp
  800c91:	53                   	push   %ebx
  800c92:	83 ec 14             	sub    $0x14,%esp
  800c95:	8b 45 10             	mov    0x10(%ebp),%eax
  800c98:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c9b:	8b 45 14             	mov    0x14(%ebp),%eax
  800c9e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800ca1:	8b 45 18             	mov    0x18(%ebp),%eax
  800ca4:	ba 00 00 00 00       	mov    $0x0,%edx
  800ca9:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800cac:	77 55                	ja     800d03 <printnum+0x75>
  800cae:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800cb1:	72 05                	jb     800cb8 <printnum+0x2a>
  800cb3:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800cb6:	77 4b                	ja     800d03 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800cb8:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800cbb:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800cbe:	8b 45 18             	mov    0x18(%ebp),%eax
  800cc1:	ba 00 00 00 00       	mov    $0x0,%edx
  800cc6:	52                   	push   %edx
  800cc7:	50                   	push   %eax
  800cc8:	ff 75 f4             	pushl  -0xc(%ebp)
  800ccb:	ff 75 f0             	pushl  -0x10(%ebp)
  800cce:	e8 81 38 00 00       	call   804554 <__udivdi3>
  800cd3:	83 c4 10             	add    $0x10,%esp
  800cd6:	83 ec 04             	sub    $0x4,%esp
  800cd9:	ff 75 20             	pushl  0x20(%ebp)
  800cdc:	53                   	push   %ebx
  800cdd:	ff 75 18             	pushl  0x18(%ebp)
  800ce0:	52                   	push   %edx
  800ce1:	50                   	push   %eax
  800ce2:	ff 75 0c             	pushl  0xc(%ebp)
  800ce5:	ff 75 08             	pushl  0x8(%ebp)
  800ce8:	e8 a1 ff ff ff       	call   800c8e <printnum>
  800ced:	83 c4 20             	add    $0x20,%esp
  800cf0:	eb 1a                	jmp    800d0c <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800cf2:	83 ec 08             	sub    $0x8,%esp
  800cf5:	ff 75 0c             	pushl  0xc(%ebp)
  800cf8:	ff 75 20             	pushl  0x20(%ebp)
  800cfb:	8b 45 08             	mov    0x8(%ebp),%eax
  800cfe:	ff d0                	call   *%eax
  800d00:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800d03:	ff 4d 1c             	decl   0x1c(%ebp)
  800d06:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800d0a:	7f e6                	jg     800cf2 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800d0c:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800d0f:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d14:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800d17:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800d1a:	53                   	push   %ebx
  800d1b:	51                   	push   %ecx
  800d1c:	52                   	push   %edx
  800d1d:	50                   	push   %eax
  800d1e:	e8 41 39 00 00       	call   804664 <__umoddi3>
  800d23:	83 c4 10             	add    $0x10,%esp
  800d26:	05 54 4e 80 00       	add    $0x804e54,%eax
  800d2b:	8a 00                	mov    (%eax),%al
  800d2d:	0f be c0             	movsbl %al,%eax
  800d30:	83 ec 08             	sub    $0x8,%esp
  800d33:	ff 75 0c             	pushl  0xc(%ebp)
  800d36:	50                   	push   %eax
  800d37:	8b 45 08             	mov    0x8(%ebp),%eax
  800d3a:	ff d0                	call   *%eax
  800d3c:	83 c4 10             	add    $0x10,%esp
}
  800d3f:	90                   	nop
  800d40:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800d43:	c9                   	leave  
  800d44:	c3                   	ret    

00800d45 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800d45:	55                   	push   %ebp
  800d46:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800d48:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800d4c:	7e 1c                	jle    800d6a <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800d4e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d51:	8b 00                	mov    (%eax),%eax
  800d53:	8d 50 08             	lea    0x8(%eax),%edx
  800d56:	8b 45 08             	mov    0x8(%ebp),%eax
  800d59:	89 10                	mov    %edx,(%eax)
  800d5b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d5e:	8b 00                	mov    (%eax),%eax
  800d60:	83 e8 08             	sub    $0x8,%eax
  800d63:	8b 50 04             	mov    0x4(%eax),%edx
  800d66:	8b 00                	mov    (%eax),%eax
  800d68:	eb 40                	jmp    800daa <getuint+0x65>
	else if (lflag)
  800d6a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d6e:	74 1e                	je     800d8e <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800d70:	8b 45 08             	mov    0x8(%ebp),%eax
  800d73:	8b 00                	mov    (%eax),%eax
  800d75:	8d 50 04             	lea    0x4(%eax),%edx
  800d78:	8b 45 08             	mov    0x8(%ebp),%eax
  800d7b:	89 10                	mov    %edx,(%eax)
  800d7d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d80:	8b 00                	mov    (%eax),%eax
  800d82:	83 e8 04             	sub    $0x4,%eax
  800d85:	8b 00                	mov    (%eax),%eax
  800d87:	ba 00 00 00 00       	mov    $0x0,%edx
  800d8c:	eb 1c                	jmp    800daa <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800d8e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d91:	8b 00                	mov    (%eax),%eax
  800d93:	8d 50 04             	lea    0x4(%eax),%edx
  800d96:	8b 45 08             	mov    0x8(%ebp),%eax
  800d99:	89 10                	mov    %edx,(%eax)
  800d9b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d9e:	8b 00                	mov    (%eax),%eax
  800da0:	83 e8 04             	sub    $0x4,%eax
  800da3:	8b 00                	mov    (%eax),%eax
  800da5:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800daa:	5d                   	pop    %ebp
  800dab:	c3                   	ret    

00800dac <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800dac:	55                   	push   %ebp
  800dad:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800daf:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800db3:	7e 1c                	jle    800dd1 <getint+0x25>
		return va_arg(*ap, long long);
  800db5:	8b 45 08             	mov    0x8(%ebp),%eax
  800db8:	8b 00                	mov    (%eax),%eax
  800dba:	8d 50 08             	lea    0x8(%eax),%edx
  800dbd:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc0:	89 10                	mov    %edx,(%eax)
  800dc2:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc5:	8b 00                	mov    (%eax),%eax
  800dc7:	83 e8 08             	sub    $0x8,%eax
  800dca:	8b 50 04             	mov    0x4(%eax),%edx
  800dcd:	8b 00                	mov    (%eax),%eax
  800dcf:	eb 38                	jmp    800e09 <getint+0x5d>
	else if (lflag)
  800dd1:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800dd5:	74 1a                	je     800df1 <getint+0x45>
		return va_arg(*ap, long);
  800dd7:	8b 45 08             	mov    0x8(%ebp),%eax
  800dda:	8b 00                	mov    (%eax),%eax
  800ddc:	8d 50 04             	lea    0x4(%eax),%edx
  800ddf:	8b 45 08             	mov    0x8(%ebp),%eax
  800de2:	89 10                	mov    %edx,(%eax)
  800de4:	8b 45 08             	mov    0x8(%ebp),%eax
  800de7:	8b 00                	mov    (%eax),%eax
  800de9:	83 e8 04             	sub    $0x4,%eax
  800dec:	8b 00                	mov    (%eax),%eax
  800dee:	99                   	cltd   
  800def:	eb 18                	jmp    800e09 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800df1:	8b 45 08             	mov    0x8(%ebp),%eax
  800df4:	8b 00                	mov    (%eax),%eax
  800df6:	8d 50 04             	lea    0x4(%eax),%edx
  800df9:	8b 45 08             	mov    0x8(%ebp),%eax
  800dfc:	89 10                	mov    %edx,(%eax)
  800dfe:	8b 45 08             	mov    0x8(%ebp),%eax
  800e01:	8b 00                	mov    (%eax),%eax
  800e03:	83 e8 04             	sub    $0x4,%eax
  800e06:	8b 00                	mov    (%eax),%eax
  800e08:	99                   	cltd   
}
  800e09:	5d                   	pop    %ebp
  800e0a:	c3                   	ret    

00800e0b <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800e0b:	55                   	push   %ebp
  800e0c:	89 e5                	mov    %esp,%ebp
  800e0e:	56                   	push   %esi
  800e0f:	53                   	push   %ebx
  800e10:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800e13:	eb 17                	jmp    800e2c <vprintfmt+0x21>
			if (ch == '\0')
  800e15:	85 db                	test   %ebx,%ebx
  800e17:	0f 84 c1 03 00 00    	je     8011de <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  800e1d:	83 ec 08             	sub    $0x8,%esp
  800e20:	ff 75 0c             	pushl  0xc(%ebp)
  800e23:	53                   	push   %ebx
  800e24:	8b 45 08             	mov    0x8(%ebp),%eax
  800e27:	ff d0                	call   *%eax
  800e29:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800e2c:	8b 45 10             	mov    0x10(%ebp),%eax
  800e2f:	8d 50 01             	lea    0x1(%eax),%edx
  800e32:	89 55 10             	mov    %edx,0x10(%ebp)
  800e35:	8a 00                	mov    (%eax),%al
  800e37:	0f b6 d8             	movzbl %al,%ebx
  800e3a:	83 fb 25             	cmp    $0x25,%ebx
  800e3d:	75 d6                	jne    800e15 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800e3f:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800e43:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800e4a:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800e51:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800e58:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800e5f:	8b 45 10             	mov    0x10(%ebp),%eax
  800e62:	8d 50 01             	lea    0x1(%eax),%edx
  800e65:	89 55 10             	mov    %edx,0x10(%ebp)
  800e68:	8a 00                	mov    (%eax),%al
  800e6a:	0f b6 d8             	movzbl %al,%ebx
  800e6d:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800e70:	83 f8 5b             	cmp    $0x5b,%eax
  800e73:	0f 87 3d 03 00 00    	ja     8011b6 <vprintfmt+0x3ab>
  800e79:	8b 04 85 78 4e 80 00 	mov    0x804e78(,%eax,4),%eax
  800e80:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800e82:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800e86:	eb d7                	jmp    800e5f <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800e88:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800e8c:	eb d1                	jmp    800e5f <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800e8e:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800e95:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800e98:	89 d0                	mov    %edx,%eax
  800e9a:	c1 e0 02             	shl    $0x2,%eax
  800e9d:	01 d0                	add    %edx,%eax
  800e9f:	01 c0                	add    %eax,%eax
  800ea1:	01 d8                	add    %ebx,%eax
  800ea3:	83 e8 30             	sub    $0x30,%eax
  800ea6:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800ea9:	8b 45 10             	mov    0x10(%ebp),%eax
  800eac:	8a 00                	mov    (%eax),%al
  800eae:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800eb1:	83 fb 2f             	cmp    $0x2f,%ebx
  800eb4:	7e 3e                	jle    800ef4 <vprintfmt+0xe9>
  800eb6:	83 fb 39             	cmp    $0x39,%ebx
  800eb9:	7f 39                	jg     800ef4 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800ebb:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800ebe:	eb d5                	jmp    800e95 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800ec0:	8b 45 14             	mov    0x14(%ebp),%eax
  800ec3:	83 c0 04             	add    $0x4,%eax
  800ec6:	89 45 14             	mov    %eax,0x14(%ebp)
  800ec9:	8b 45 14             	mov    0x14(%ebp),%eax
  800ecc:	83 e8 04             	sub    $0x4,%eax
  800ecf:	8b 00                	mov    (%eax),%eax
  800ed1:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800ed4:	eb 1f                	jmp    800ef5 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800ed6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800eda:	79 83                	jns    800e5f <vprintfmt+0x54>
				width = 0;
  800edc:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800ee3:	e9 77 ff ff ff       	jmp    800e5f <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800ee8:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800eef:	e9 6b ff ff ff       	jmp    800e5f <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800ef4:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800ef5:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800ef9:	0f 89 60 ff ff ff    	jns    800e5f <vprintfmt+0x54>
				width = precision, precision = -1;
  800eff:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800f02:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800f05:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800f0c:	e9 4e ff ff ff       	jmp    800e5f <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800f11:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800f14:	e9 46 ff ff ff       	jmp    800e5f <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800f19:	8b 45 14             	mov    0x14(%ebp),%eax
  800f1c:	83 c0 04             	add    $0x4,%eax
  800f1f:	89 45 14             	mov    %eax,0x14(%ebp)
  800f22:	8b 45 14             	mov    0x14(%ebp),%eax
  800f25:	83 e8 04             	sub    $0x4,%eax
  800f28:	8b 00                	mov    (%eax),%eax
  800f2a:	83 ec 08             	sub    $0x8,%esp
  800f2d:	ff 75 0c             	pushl  0xc(%ebp)
  800f30:	50                   	push   %eax
  800f31:	8b 45 08             	mov    0x8(%ebp),%eax
  800f34:	ff d0                	call   *%eax
  800f36:	83 c4 10             	add    $0x10,%esp
			break;
  800f39:	e9 9b 02 00 00       	jmp    8011d9 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800f3e:	8b 45 14             	mov    0x14(%ebp),%eax
  800f41:	83 c0 04             	add    $0x4,%eax
  800f44:	89 45 14             	mov    %eax,0x14(%ebp)
  800f47:	8b 45 14             	mov    0x14(%ebp),%eax
  800f4a:	83 e8 04             	sub    $0x4,%eax
  800f4d:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800f4f:	85 db                	test   %ebx,%ebx
  800f51:	79 02                	jns    800f55 <vprintfmt+0x14a>
				err = -err;
  800f53:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800f55:	83 fb 64             	cmp    $0x64,%ebx
  800f58:	7f 0b                	jg     800f65 <vprintfmt+0x15a>
  800f5a:	8b 34 9d c0 4c 80 00 	mov    0x804cc0(,%ebx,4),%esi
  800f61:	85 f6                	test   %esi,%esi
  800f63:	75 19                	jne    800f7e <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800f65:	53                   	push   %ebx
  800f66:	68 65 4e 80 00       	push   $0x804e65
  800f6b:	ff 75 0c             	pushl  0xc(%ebp)
  800f6e:	ff 75 08             	pushl  0x8(%ebp)
  800f71:	e8 70 02 00 00       	call   8011e6 <printfmt>
  800f76:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800f79:	e9 5b 02 00 00       	jmp    8011d9 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800f7e:	56                   	push   %esi
  800f7f:	68 6e 4e 80 00       	push   $0x804e6e
  800f84:	ff 75 0c             	pushl  0xc(%ebp)
  800f87:	ff 75 08             	pushl  0x8(%ebp)
  800f8a:	e8 57 02 00 00       	call   8011e6 <printfmt>
  800f8f:	83 c4 10             	add    $0x10,%esp
			break;
  800f92:	e9 42 02 00 00       	jmp    8011d9 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800f97:	8b 45 14             	mov    0x14(%ebp),%eax
  800f9a:	83 c0 04             	add    $0x4,%eax
  800f9d:	89 45 14             	mov    %eax,0x14(%ebp)
  800fa0:	8b 45 14             	mov    0x14(%ebp),%eax
  800fa3:	83 e8 04             	sub    $0x4,%eax
  800fa6:	8b 30                	mov    (%eax),%esi
  800fa8:	85 f6                	test   %esi,%esi
  800faa:	75 05                	jne    800fb1 <vprintfmt+0x1a6>
				p = "(null)";
  800fac:	be 71 4e 80 00       	mov    $0x804e71,%esi
			if (width > 0 && padc != '-')
  800fb1:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800fb5:	7e 6d                	jle    801024 <vprintfmt+0x219>
  800fb7:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800fbb:	74 67                	je     801024 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800fbd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800fc0:	83 ec 08             	sub    $0x8,%esp
  800fc3:	50                   	push   %eax
  800fc4:	56                   	push   %esi
  800fc5:	e8 1e 03 00 00       	call   8012e8 <strnlen>
  800fca:	83 c4 10             	add    $0x10,%esp
  800fcd:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800fd0:	eb 16                	jmp    800fe8 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800fd2:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800fd6:	83 ec 08             	sub    $0x8,%esp
  800fd9:	ff 75 0c             	pushl  0xc(%ebp)
  800fdc:	50                   	push   %eax
  800fdd:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe0:	ff d0                	call   *%eax
  800fe2:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800fe5:	ff 4d e4             	decl   -0x1c(%ebp)
  800fe8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800fec:	7f e4                	jg     800fd2 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800fee:	eb 34                	jmp    801024 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800ff0:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800ff4:	74 1c                	je     801012 <vprintfmt+0x207>
  800ff6:	83 fb 1f             	cmp    $0x1f,%ebx
  800ff9:	7e 05                	jle    801000 <vprintfmt+0x1f5>
  800ffb:	83 fb 7e             	cmp    $0x7e,%ebx
  800ffe:	7e 12                	jle    801012 <vprintfmt+0x207>
					putch('?', putdat);
  801000:	83 ec 08             	sub    $0x8,%esp
  801003:	ff 75 0c             	pushl  0xc(%ebp)
  801006:	6a 3f                	push   $0x3f
  801008:	8b 45 08             	mov    0x8(%ebp),%eax
  80100b:	ff d0                	call   *%eax
  80100d:	83 c4 10             	add    $0x10,%esp
  801010:	eb 0f                	jmp    801021 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  801012:	83 ec 08             	sub    $0x8,%esp
  801015:	ff 75 0c             	pushl  0xc(%ebp)
  801018:	53                   	push   %ebx
  801019:	8b 45 08             	mov    0x8(%ebp),%eax
  80101c:	ff d0                	call   *%eax
  80101e:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801021:	ff 4d e4             	decl   -0x1c(%ebp)
  801024:	89 f0                	mov    %esi,%eax
  801026:	8d 70 01             	lea    0x1(%eax),%esi
  801029:	8a 00                	mov    (%eax),%al
  80102b:	0f be d8             	movsbl %al,%ebx
  80102e:	85 db                	test   %ebx,%ebx
  801030:	74 24                	je     801056 <vprintfmt+0x24b>
  801032:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801036:	78 b8                	js     800ff0 <vprintfmt+0x1e5>
  801038:	ff 4d e0             	decl   -0x20(%ebp)
  80103b:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80103f:	79 af                	jns    800ff0 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801041:	eb 13                	jmp    801056 <vprintfmt+0x24b>
				putch(' ', putdat);
  801043:	83 ec 08             	sub    $0x8,%esp
  801046:	ff 75 0c             	pushl  0xc(%ebp)
  801049:	6a 20                	push   $0x20
  80104b:	8b 45 08             	mov    0x8(%ebp),%eax
  80104e:	ff d0                	call   *%eax
  801050:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801053:	ff 4d e4             	decl   -0x1c(%ebp)
  801056:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80105a:	7f e7                	jg     801043 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  80105c:	e9 78 01 00 00       	jmp    8011d9 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  801061:	83 ec 08             	sub    $0x8,%esp
  801064:	ff 75 e8             	pushl  -0x18(%ebp)
  801067:	8d 45 14             	lea    0x14(%ebp),%eax
  80106a:	50                   	push   %eax
  80106b:	e8 3c fd ff ff       	call   800dac <getint>
  801070:	83 c4 10             	add    $0x10,%esp
  801073:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801076:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  801079:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80107c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80107f:	85 d2                	test   %edx,%edx
  801081:	79 23                	jns    8010a6 <vprintfmt+0x29b>
				putch('-', putdat);
  801083:	83 ec 08             	sub    $0x8,%esp
  801086:	ff 75 0c             	pushl  0xc(%ebp)
  801089:	6a 2d                	push   $0x2d
  80108b:	8b 45 08             	mov    0x8(%ebp),%eax
  80108e:	ff d0                	call   *%eax
  801090:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  801093:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801096:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801099:	f7 d8                	neg    %eax
  80109b:	83 d2 00             	adc    $0x0,%edx
  80109e:	f7 da                	neg    %edx
  8010a0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8010a3:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8010a6:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8010ad:	e9 bc 00 00 00       	jmp    80116e <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8010b2:	83 ec 08             	sub    $0x8,%esp
  8010b5:	ff 75 e8             	pushl  -0x18(%ebp)
  8010b8:	8d 45 14             	lea    0x14(%ebp),%eax
  8010bb:	50                   	push   %eax
  8010bc:	e8 84 fc ff ff       	call   800d45 <getuint>
  8010c1:	83 c4 10             	add    $0x10,%esp
  8010c4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8010c7:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  8010ca:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8010d1:	e9 98 00 00 00       	jmp    80116e <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  8010d6:	83 ec 08             	sub    $0x8,%esp
  8010d9:	ff 75 0c             	pushl  0xc(%ebp)
  8010dc:	6a 58                	push   $0x58
  8010de:	8b 45 08             	mov    0x8(%ebp),%eax
  8010e1:	ff d0                	call   *%eax
  8010e3:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8010e6:	83 ec 08             	sub    $0x8,%esp
  8010e9:	ff 75 0c             	pushl  0xc(%ebp)
  8010ec:	6a 58                	push   $0x58
  8010ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8010f1:	ff d0                	call   *%eax
  8010f3:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8010f6:	83 ec 08             	sub    $0x8,%esp
  8010f9:	ff 75 0c             	pushl  0xc(%ebp)
  8010fc:	6a 58                	push   $0x58
  8010fe:	8b 45 08             	mov    0x8(%ebp),%eax
  801101:	ff d0                	call   *%eax
  801103:	83 c4 10             	add    $0x10,%esp
			break;
  801106:	e9 ce 00 00 00       	jmp    8011d9 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  80110b:	83 ec 08             	sub    $0x8,%esp
  80110e:	ff 75 0c             	pushl  0xc(%ebp)
  801111:	6a 30                	push   $0x30
  801113:	8b 45 08             	mov    0x8(%ebp),%eax
  801116:	ff d0                	call   *%eax
  801118:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  80111b:	83 ec 08             	sub    $0x8,%esp
  80111e:	ff 75 0c             	pushl  0xc(%ebp)
  801121:	6a 78                	push   $0x78
  801123:	8b 45 08             	mov    0x8(%ebp),%eax
  801126:	ff d0                	call   *%eax
  801128:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  80112b:	8b 45 14             	mov    0x14(%ebp),%eax
  80112e:	83 c0 04             	add    $0x4,%eax
  801131:	89 45 14             	mov    %eax,0x14(%ebp)
  801134:	8b 45 14             	mov    0x14(%ebp),%eax
  801137:	83 e8 04             	sub    $0x4,%eax
  80113a:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  80113c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80113f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  801146:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  80114d:	eb 1f                	jmp    80116e <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  80114f:	83 ec 08             	sub    $0x8,%esp
  801152:	ff 75 e8             	pushl  -0x18(%ebp)
  801155:	8d 45 14             	lea    0x14(%ebp),%eax
  801158:	50                   	push   %eax
  801159:	e8 e7 fb ff ff       	call   800d45 <getuint>
  80115e:	83 c4 10             	add    $0x10,%esp
  801161:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801164:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  801167:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  80116e:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  801172:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801175:	83 ec 04             	sub    $0x4,%esp
  801178:	52                   	push   %edx
  801179:	ff 75 e4             	pushl  -0x1c(%ebp)
  80117c:	50                   	push   %eax
  80117d:	ff 75 f4             	pushl  -0xc(%ebp)
  801180:	ff 75 f0             	pushl  -0x10(%ebp)
  801183:	ff 75 0c             	pushl  0xc(%ebp)
  801186:	ff 75 08             	pushl  0x8(%ebp)
  801189:	e8 00 fb ff ff       	call   800c8e <printnum>
  80118e:	83 c4 20             	add    $0x20,%esp
			break;
  801191:	eb 46                	jmp    8011d9 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  801193:	83 ec 08             	sub    $0x8,%esp
  801196:	ff 75 0c             	pushl  0xc(%ebp)
  801199:	53                   	push   %ebx
  80119a:	8b 45 08             	mov    0x8(%ebp),%eax
  80119d:	ff d0                	call   *%eax
  80119f:	83 c4 10             	add    $0x10,%esp
			break;
  8011a2:	eb 35                	jmp    8011d9 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  8011a4:	c6 05 44 60 80 00 00 	movb   $0x0,0x806044
			break;
  8011ab:	eb 2c                	jmp    8011d9 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  8011ad:	c6 05 44 60 80 00 01 	movb   $0x1,0x806044
			break;
  8011b4:	eb 23                	jmp    8011d9 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8011b6:	83 ec 08             	sub    $0x8,%esp
  8011b9:	ff 75 0c             	pushl  0xc(%ebp)
  8011bc:	6a 25                	push   $0x25
  8011be:	8b 45 08             	mov    0x8(%ebp),%eax
  8011c1:	ff d0                	call   *%eax
  8011c3:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  8011c6:	ff 4d 10             	decl   0x10(%ebp)
  8011c9:	eb 03                	jmp    8011ce <vprintfmt+0x3c3>
  8011cb:	ff 4d 10             	decl   0x10(%ebp)
  8011ce:	8b 45 10             	mov    0x10(%ebp),%eax
  8011d1:	48                   	dec    %eax
  8011d2:	8a 00                	mov    (%eax),%al
  8011d4:	3c 25                	cmp    $0x25,%al
  8011d6:	75 f3                	jne    8011cb <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  8011d8:	90                   	nop
		}
	}
  8011d9:	e9 35 fc ff ff       	jmp    800e13 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  8011de:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  8011df:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8011e2:	5b                   	pop    %ebx
  8011e3:	5e                   	pop    %esi
  8011e4:	5d                   	pop    %ebp
  8011e5:	c3                   	ret    

008011e6 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8011e6:	55                   	push   %ebp
  8011e7:	89 e5                	mov    %esp,%ebp
  8011e9:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  8011ec:	8d 45 10             	lea    0x10(%ebp),%eax
  8011ef:	83 c0 04             	add    $0x4,%eax
  8011f2:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  8011f5:	8b 45 10             	mov    0x10(%ebp),%eax
  8011f8:	ff 75 f4             	pushl  -0xc(%ebp)
  8011fb:	50                   	push   %eax
  8011fc:	ff 75 0c             	pushl  0xc(%ebp)
  8011ff:	ff 75 08             	pushl  0x8(%ebp)
  801202:	e8 04 fc ff ff       	call   800e0b <vprintfmt>
  801207:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  80120a:	90                   	nop
  80120b:	c9                   	leave  
  80120c:	c3                   	ret    

0080120d <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80120d:	55                   	push   %ebp
  80120e:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  801210:	8b 45 0c             	mov    0xc(%ebp),%eax
  801213:	8b 40 08             	mov    0x8(%eax),%eax
  801216:	8d 50 01             	lea    0x1(%eax),%edx
  801219:	8b 45 0c             	mov    0xc(%ebp),%eax
  80121c:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  80121f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801222:	8b 10                	mov    (%eax),%edx
  801224:	8b 45 0c             	mov    0xc(%ebp),%eax
  801227:	8b 40 04             	mov    0x4(%eax),%eax
  80122a:	39 c2                	cmp    %eax,%edx
  80122c:	73 12                	jae    801240 <sprintputch+0x33>
		*b->buf++ = ch;
  80122e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801231:	8b 00                	mov    (%eax),%eax
  801233:	8d 48 01             	lea    0x1(%eax),%ecx
  801236:	8b 55 0c             	mov    0xc(%ebp),%edx
  801239:	89 0a                	mov    %ecx,(%edx)
  80123b:	8b 55 08             	mov    0x8(%ebp),%edx
  80123e:	88 10                	mov    %dl,(%eax)
}
  801240:	90                   	nop
  801241:	5d                   	pop    %ebp
  801242:	c3                   	ret    

00801243 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801243:	55                   	push   %ebp
  801244:	89 e5                	mov    %esp,%ebp
  801246:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  801249:	8b 45 08             	mov    0x8(%ebp),%eax
  80124c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80124f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801252:	8d 50 ff             	lea    -0x1(%eax),%edx
  801255:	8b 45 08             	mov    0x8(%ebp),%eax
  801258:	01 d0                	add    %edx,%eax
  80125a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80125d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  801264:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801268:	74 06                	je     801270 <vsnprintf+0x2d>
  80126a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80126e:	7f 07                	jg     801277 <vsnprintf+0x34>
		return -E_INVAL;
  801270:	b8 03 00 00 00       	mov    $0x3,%eax
  801275:	eb 20                	jmp    801297 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  801277:	ff 75 14             	pushl  0x14(%ebp)
  80127a:	ff 75 10             	pushl  0x10(%ebp)
  80127d:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801280:	50                   	push   %eax
  801281:	68 0d 12 80 00       	push   $0x80120d
  801286:	e8 80 fb ff ff       	call   800e0b <vprintfmt>
  80128b:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  80128e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801291:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  801294:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801297:	c9                   	leave  
  801298:	c3                   	ret    

00801299 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801299:	55                   	push   %ebp
  80129a:	89 e5                	mov    %esp,%ebp
  80129c:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  80129f:	8d 45 10             	lea    0x10(%ebp),%eax
  8012a2:	83 c0 04             	add    $0x4,%eax
  8012a5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  8012a8:	8b 45 10             	mov    0x10(%ebp),%eax
  8012ab:	ff 75 f4             	pushl  -0xc(%ebp)
  8012ae:	50                   	push   %eax
  8012af:	ff 75 0c             	pushl  0xc(%ebp)
  8012b2:	ff 75 08             	pushl  0x8(%ebp)
  8012b5:	e8 89 ff ff ff       	call   801243 <vsnprintf>
  8012ba:	83 c4 10             	add    $0x10,%esp
  8012bd:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  8012c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8012c3:	c9                   	leave  
  8012c4:	c3                   	ret    

008012c5 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  8012c5:	55                   	push   %ebp
  8012c6:	89 e5                	mov    %esp,%ebp
  8012c8:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  8012cb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8012d2:	eb 06                	jmp    8012da <strlen+0x15>
		n++;
  8012d4:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8012d7:	ff 45 08             	incl   0x8(%ebp)
  8012da:	8b 45 08             	mov    0x8(%ebp),%eax
  8012dd:	8a 00                	mov    (%eax),%al
  8012df:	84 c0                	test   %al,%al
  8012e1:	75 f1                	jne    8012d4 <strlen+0xf>
		n++;
	return n;
  8012e3:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8012e6:	c9                   	leave  
  8012e7:	c3                   	ret    

008012e8 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  8012e8:	55                   	push   %ebp
  8012e9:	89 e5                	mov    %esp,%ebp
  8012eb:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8012ee:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8012f5:	eb 09                	jmp    801300 <strnlen+0x18>
		n++;
  8012f7:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8012fa:	ff 45 08             	incl   0x8(%ebp)
  8012fd:	ff 4d 0c             	decl   0xc(%ebp)
  801300:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801304:	74 09                	je     80130f <strnlen+0x27>
  801306:	8b 45 08             	mov    0x8(%ebp),%eax
  801309:	8a 00                	mov    (%eax),%al
  80130b:	84 c0                	test   %al,%al
  80130d:	75 e8                	jne    8012f7 <strnlen+0xf>
		n++;
	return n;
  80130f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801312:	c9                   	leave  
  801313:	c3                   	ret    

00801314 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801314:	55                   	push   %ebp
  801315:	89 e5                	mov    %esp,%ebp
  801317:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  80131a:	8b 45 08             	mov    0x8(%ebp),%eax
  80131d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  801320:	90                   	nop
  801321:	8b 45 08             	mov    0x8(%ebp),%eax
  801324:	8d 50 01             	lea    0x1(%eax),%edx
  801327:	89 55 08             	mov    %edx,0x8(%ebp)
  80132a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80132d:	8d 4a 01             	lea    0x1(%edx),%ecx
  801330:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801333:	8a 12                	mov    (%edx),%dl
  801335:	88 10                	mov    %dl,(%eax)
  801337:	8a 00                	mov    (%eax),%al
  801339:	84 c0                	test   %al,%al
  80133b:	75 e4                	jne    801321 <strcpy+0xd>
		/* do nothing */;
	return ret;
  80133d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801340:	c9                   	leave  
  801341:	c3                   	ret    

00801342 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  801342:	55                   	push   %ebp
  801343:	89 e5                	mov    %esp,%ebp
  801345:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  801348:	8b 45 08             	mov    0x8(%ebp),%eax
  80134b:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  80134e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801355:	eb 1f                	jmp    801376 <strncpy+0x34>
		*dst++ = *src;
  801357:	8b 45 08             	mov    0x8(%ebp),%eax
  80135a:	8d 50 01             	lea    0x1(%eax),%edx
  80135d:	89 55 08             	mov    %edx,0x8(%ebp)
  801360:	8b 55 0c             	mov    0xc(%ebp),%edx
  801363:	8a 12                	mov    (%edx),%dl
  801365:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801367:	8b 45 0c             	mov    0xc(%ebp),%eax
  80136a:	8a 00                	mov    (%eax),%al
  80136c:	84 c0                	test   %al,%al
  80136e:	74 03                	je     801373 <strncpy+0x31>
			src++;
  801370:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801373:	ff 45 fc             	incl   -0x4(%ebp)
  801376:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801379:	3b 45 10             	cmp    0x10(%ebp),%eax
  80137c:	72 d9                	jb     801357 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  80137e:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801381:	c9                   	leave  
  801382:	c3                   	ret    

00801383 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  801383:	55                   	push   %ebp
  801384:	89 e5                	mov    %esp,%ebp
  801386:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  801389:	8b 45 08             	mov    0x8(%ebp),%eax
  80138c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  80138f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801393:	74 30                	je     8013c5 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  801395:	eb 16                	jmp    8013ad <strlcpy+0x2a>
			*dst++ = *src++;
  801397:	8b 45 08             	mov    0x8(%ebp),%eax
  80139a:	8d 50 01             	lea    0x1(%eax),%edx
  80139d:	89 55 08             	mov    %edx,0x8(%ebp)
  8013a0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8013a3:	8d 4a 01             	lea    0x1(%edx),%ecx
  8013a6:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8013a9:	8a 12                	mov    (%edx),%dl
  8013ab:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8013ad:	ff 4d 10             	decl   0x10(%ebp)
  8013b0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8013b4:	74 09                	je     8013bf <strlcpy+0x3c>
  8013b6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013b9:	8a 00                	mov    (%eax),%al
  8013bb:	84 c0                	test   %al,%al
  8013bd:	75 d8                	jne    801397 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  8013bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8013c2:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8013c5:	8b 55 08             	mov    0x8(%ebp),%edx
  8013c8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8013cb:	29 c2                	sub    %eax,%edx
  8013cd:	89 d0                	mov    %edx,%eax
}
  8013cf:	c9                   	leave  
  8013d0:	c3                   	ret    

008013d1 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8013d1:	55                   	push   %ebp
  8013d2:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  8013d4:	eb 06                	jmp    8013dc <strcmp+0xb>
		p++, q++;
  8013d6:	ff 45 08             	incl   0x8(%ebp)
  8013d9:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8013dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8013df:	8a 00                	mov    (%eax),%al
  8013e1:	84 c0                	test   %al,%al
  8013e3:	74 0e                	je     8013f3 <strcmp+0x22>
  8013e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8013e8:	8a 10                	mov    (%eax),%dl
  8013ea:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013ed:	8a 00                	mov    (%eax),%al
  8013ef:	38 c2                	cmp    %al,%dl
  8013f1:	74 e3                	je     8013d6 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8013f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8013f6:	8a 00                	mov    (%eax),%al
  8013f8:	0f b6 d0             	movzbl %al,%edx
  8013fb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013fe:	8a 00                	mov    (%eax),%al
  801400:	0f b6 c0             	movzbl %al,%eax
  801403:	29 c2                	sub    %eax,%edx
  801405:	89 d0                	mov    %edx,%eax
}
  801407:	5d                   	pop    %ebp
  801408:	c3                   	ret    

00801409 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  801409:	55                   	push   %ebp
  80140a:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  80140c:	eb 09                	jmp    801417 <strncmp+0xe>
		n--, p++, q++;
  80140e:	ff 4d 10             	decl   0x10(%ebp)
  801411:	ff 45 08             	incl   0x8(%ebp)
  801414:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  801417:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80141b:	74 17                	je     801434 <strncmp+0x2b>
  80141d:	8b 45 08             	mov    0x8(%ebp),%eax
  801420:	8a 00                	mov    (%eax),%al
  801422:	84 c0                	test   %al,%al
  801424:	74 0e                	je     801434 <strncmp+0x2b>
  801426:	8b 45 08             	mov    0x8(%ebp),%eax
  801429:	8a 10                	mov    (%eax),%dl
  80142b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80142e:	8a 00                	mov    (%eax),%al
  801430:	38 c2                	cmp    %al,%dl
  801432:	74 da                	je     80140e <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  801434:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801438:	75 07                	jne    801441 <strncmp+0x38>
		return 0;
  80143a:	b8 00 00 00 00       	mov    $0x0,%eax
  80143f:	eb 14                	jmp    801455 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801441:	8b 45 08             	mov    0x8(%ebp),%eax
  801444:	8a 00                	mov    (%eax),%al
  801446:	0f b6 d0             	movzbl %al,%edx
  801449:	8b 45 0c             	mov    0xc(%ebp),%eax
  80144c:	8a 00                	mov    (%eax),%al
  80144e:	0f b6 c0             	movzbl %al,%eax
  801451:	29 c2                	sub    %eax,%edx
  801453:	89 d0                	mov    %edx,%eax
}
  801455:	5d                   	pop    %ebp
  801456:	c3                   	ret    

00801457 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801457:	55                   	push   %ebp
  801458:	89 e5                	mov    %esp,%ebp
  80145a:	83 ec 04             	sub    $0x4,%esp
  80145d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801460:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801463:	eb 12                	jmp    801477 <strchr+0x20>
		if (*s == c)
  801465:	8b 45 08             	mov    0x8(%ebp),%eax
  801468:	8a 00                	mov    (%eax),%al
  80146a:	3a 45 fc             	cmp    -0x4(%ebp),%al
  80146d:	75 05                	jne    801474 <strchr+0x1d>
			return (char *) s;
  80146f:	8b 45 08             	mov    0x8(%ebp),%eax
  801472:	eb 11                	jmp    801485 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801474:	ff 45 08             	incl   0x8(%ebp)
  801477:	8b 45 08             	mov    0x8(%ebp),%eax
  80147a:	8a 00                	mov    (%eax),%al
  80147c:	84 c0                	test   %al,%al
  80147e:	75 e5                	jne    801465 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  801480:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801485:	c9                   	leave  
  801486:	c3                   	ret    

00801487 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801487:	55                   	push   %ebp
  801488:	89 e5                	mov    %esp,%ebp
  80148a:	83 ec 04             	sub    $0x4,%esp
  80148d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801490:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801493:	eb 0d                	jmp    8014a2 <strfind+0x1b>
		if (*s == c)
  801495:	8b 45 08             	mov    0x8(%ebp),%eax
  801498:	8a 00                	mov    (%eax),%al
  80149a:	3a 45 fc             	cmp    -0x4(%ebp),%al
  80149d:	74 0e                	je     8014ad <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  80149f:	ff 45 08             	incl   0x8(%ebp)
  8014a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8014a5:	8a 00                	mov    (%eax),%al
  8014a7:	84 c0                	test   %al,%al
  8014a9:	75 ea                	jne    801495 <strfind+0xe>
  8014ab:	eb 01                	jmp    8014ae <strfind+0x27>
		if (*s == c)
			break;
  8014ad:	90                   	nop
	return (char *) s;
  8014ae:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8014b1:	c9                   	leave  
  8014b2:	c3                   	ret    

008014b3 <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  8014b3:	55                   	push   %ebp
  8014b4:	89 e5                	mov    %esp,%ebp
  8014b6:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  8014b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8014bc:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  8014bf:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  8014c3:	76 63                	jbe    801528 <memset+0x75>
		uint64 data_block = c;
  8014c5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014c8:	99                   	cltd   
  8014c9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8014cc:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  8014cf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014d2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8014d5:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  8014d9:	c1 e0 08             	shl    $0x8,%eax
  8014dc:	09 45 f0             	or     %eax,-0x10(%ebp)
  8014df:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  8014e2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014e5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8014e8:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  8014ec:	c1 e0 10             	shl    $0x10,%eax
  8014ef:	09 45 f0             	or     %eax,-0x10(%ebp)
  8014f2:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  8014f5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014f8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8014fb:	89 c2                	mov    %eax,%edx
  8014fd:	b8 00 00 00 00       	mov    $0x0,%eax
  801502:	09 45 f0             	or     %eax,-0x10(%ebp)
  801505:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  801508:	eb 18                	jmp    801522 <memset+0x6f>
			*p64++ = data_block, n -= 8;
  80150a:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80150d:	8d 41 08             	lea    0x8(%ecx),%eax
  801510:	89 45 fc             	mov    %eax,-0x4(%ebp)
  801513:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801516:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801519:	89 01                	mov    %eax,(%ecx)
  80151b:	89 51 04             	mov    %edx,0x4(%ecx)
  80151e:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  801522:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801526:	77 e2                	ja     80150a <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  801528:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80152c:	74 23                	je     801551 <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  80152e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801531:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  801534:	eb 0e                	jmp    801544 <memset+0x91>
			*p8++ = (uint8)c;
  801536:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801539:	8d 50 01             	lea    0x1(%eax),%edx
  80153c:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80153f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801542:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  801544:	8b 45 10             	mov    0x10(%ebp),%eax
  801547:	8d 50 ff             	lea    -0x1(%eax),%edx
  80154a:	89 55 10             	mov    %edx,0x10(%ebp)
  80154d:	85 c0                	test   %eax,%eax
  80154f:	75 e5                	jne    801536 <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  801551:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801554:	c9                   	leave  
  801555:	c3                   	ret    

00801556 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  801556:	55                   	push   %ebp
  801557:	89 e5                	mov    %esp,%ebp
  801559:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  80155c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80155f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  801562:	8b 45 08             	mov    0x8(%ebp),%eax
  801565:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  801568:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  80156c:	76 24                	jbe    801592 <memcpy+0x3c>
		while(n >= 8){
  80156e:	eb 1c                	jmp    80158c <memcpy+0x36>
			*d64 = *s64;
  801570:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801573:	8b 50 04             	mov    0x4(%eax),%edx
  801576:	8b 00                	mov    (%eax),%eax
  801578:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  80157b:	89 01                	mov    %eax,(%ecx)
  80157d:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  801580:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  801584:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  801588:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  80158c:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801590:	77 de                	ja     801570 <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  801592:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801596:	74 31                	je     8015c9 <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  801598:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80159b:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  80159e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8015a1:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  8015a4:	eb 16                	jmp    8015bc <memcpy+0x66>
			*d8++ = *s8++;
  8015a6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015a9:	8d 50 01             	lea    0x1(%eax),%edx
  8015ac:	89 55 f0             	mov    %edx,-0x10(%ebp)
  8015af:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8015b2:	8d 4a 01             	lea    0x1(%edx),%ecx
  8015b5:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  8015b8:	8a 12                	mov    (%edx),%dl
  8015ba:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  8015bc:	8b 45 10             	mov    0x10(%ebp),%eax
  8015bf:	8d 50 ff             	lea    -0x1(%eax),%edx
  8015c2:	89 55 10             	mov    %edx,0x10(%ebp)
  8015c5:	85 c0                	test   %eax,%eax
  8015c7:	75 dd                	jne    8015a6 <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  8015c9:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8015cc:	c9                   	leave  
  8015cd:	c3                   	ret    

008015ce <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  8015ce:	55                   	push   %ebp
  8015cf:	89 e5                	mov    %esp,%ebp
  8015d1:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8015d4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015d7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8015da:	8b 45 08             	mov    0x8(%ebp),%eax
  8015dd:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  8015e0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8015e3:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8015e6:	73 50                	jae    801638 <memmove+0x6a>
  8015e8:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8015eb:	8b 45 10             	mov    0x10(%ebp),%eax
  8015ee:	01 d0                	add    %edx,%eax
  8015f0:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8015f3:	76 43                	jbe    801638 <memmove+0x6a>
		s += n;
  8015f5:	8b 45 10             	mov    0x10(%ebp),%eax
  8015f8:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  8015fb:	8b 45 10             	mov    0x10(%ebp),%eax
  8015fe:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  801601:	eb 10                	jmp    801613 <memmove+0x45>
			*--d = *--s;
  801603:	ff 4d f8             	decl   -0x8(%ebp)
  801606:	ff 4d fc             	decl   -0x4(%ebp)
  801609:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80160c:	8a 10                	mov    (%eax),%dl
  80160e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801611:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  801613:	8b 45 10             	mov    0x10(%ebp),%eax
  801616:	8d 50 ff             	lea    -0x1(%eax),%edx
  801619:	89 55 10             	mov    %edx,0x10(%ebp)
  80161c:	85 c0                	test   %eax,%eax
  80161e:	75 e3                	jne    801603 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801620:	eb 23                	jmp    801645 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  801622:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801625:	8d 50 01             	lea    0x1(%eax),%edx
  801628:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80162b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80162e:	8d 4a 01             	lea    0x1(%edx),%ecx
  801631:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801634:	8a 12                	mov    (%edx),%dl
  801636:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801638:	8b 45 10             	mov    0x10(%ebp),%eax
  80163b:	8d 50 ff             	lea    -0x1(%eax),%edx
  80163e:	89 55 10             	mov    %edx,0x10(%ebp)
  801641:	85 c0                	test   %eax,%eax
  801643:	75 dd                	jne    801622 <memmove+0x54>
			*d++ = *s++;

	return dst;
  801645:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801648:	c9                   	leave  
  801649:	c3                   	ret    

0080164a <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  80164a:	55                   	push   %ebp
  80164b:	89 e5                	mov    %esp,%ebp
  80164d:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  801650:	8b 45 08             	mov    0x8(%ebp),%eax
  801653:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  801656:	8b 45 0c             	mov    0xc(%ebp),%eax
  801659:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  80165c:	eb 2a                	jmp    801688 <memcmp+0x3e>
		if (*s1 != *s2)
  80165e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801661:	8a 10                	mov    (%eax),%dl
  801663:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801666:	8a 00                	mov    (%eax),%al
  801668:	38 c2                	cmp    %al,%dl
  80166a:	74 16                	je     801682 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  80166c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80166f:	8a 00                	mov    (%eax),%al
  801671:	0f b6 d0             	movzbl %al,%edx
  801674:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801677:	8a 00                	mov    (%eax),%al
  801679:	0f b6 c0             	movzbl %al,%eax
  80167c:	29 c2                	sub    %eax,%edx
  80167e:	89 d0                	mov    %edx,%eax
  801680:	eb 18                	jmp    80169a <memcmp+0x50>
		s1++, s2++;
  801682:	ff 45 fc             	incl   -0x4(%ebp)
  801685:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801688:	8b 45 10             	mov    0x10(%ebp),%eax
  80168b:	8d 50 ff             	lea    -0x1(%eax),%edx
  80168e:	89 55 10             	mov    %edx,0x10(%ebp)
  801691:	85 c0                	test   %eax,%eax
  801693:	75 c9                	jne    80165e <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801695:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80169a:	c9                   	leave  
  80169b:	c3                   	ret    

0080169c <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  80169c:	55                   	push   %ebp
  80169d:	89 e5                	mov    %esp,%ebp
  80169f:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  8016a2:	8b 55 08             	mov    0x8(%ebp),%edx
  8016a5:	8b 45 10             	mov    0x10(%ebp),%eax
  8016a8:	01 d0                	add    %edx,%eax
  8016aa:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  8016ad:	eb 15                	jmp    8016c4 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  8016af:	8b 45 08             	mov    0x8(%ebp),%eax
  8016b2:	8a 00                	mov    (%eax),%al
  8016b4:	0f b6 d0             	movzbl %al,%edx
  8016b7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016ba:	0f b6 c0             	movzbl %al,%eax
  8016bd:	39 c2                	cmp    %eax,%edx
  8016bf:	74 0d                	je     8016ce <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8016c1:	ff 45 08             	incl   0x8(%ebp)
  8016c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8016c7:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8016ca:	72 e3                	jb     8016af <memfind+0x13>
  8016cc:	eb 01                	jmp    8016cf <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  8016ce:	90                   	nop
	return (void *) s;
  8016cf:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8016d2:	c9                   	leave  
  8016d3:	c3                   	ret    

008016d4 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8016d4:	55                   	push   %ebp
  8016d5:	89 e5                	mov    %esp,%ebp
  8016d7:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  8016da:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  8016e1:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8016e8:	eb 03                	jmp    8016ed <strtol+0x19>
		s++;
  8016ea:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8016ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8016f0:	8a 00                	mov    (%eax),%al
  8016f2:	3c 20                	cmp    $0x20,%al
  8016f4:	74 f4                	je     8016ea <strtol+0x16>
  8016f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8016f9:	8a 00                	mov    (%eax),%al
  8016fb:	3c 09                	cmp    $0x9,%al
  8016fd:	74 eb                	je     8016ea <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  8016ff:	8b 45 08             	mov    0x8(%ebp),%eax
  801702:	8a 00                	mov    (%eax),%al
  801704:	3c 2b                	cmp    $0x2b,%al
  801706:	75 05                	jne    80170d <strtol+0x39>
		s++;
  801708:	ff 45 08             	incl   0x8(%ebp)
  80170b:	eb 13                	jmp    801720 <strtol+0x4c>
	else if (*s == '-')
  80170d:	8b 45 08             	mov    0x8(%ebp),%eax
  801710:	8a 00                	mov    (%eax),%al
  801712:	3c 2d                	cmp    $0x2d,%al
  801714:	75 0a                	jne    801720 <strtol+0x4c>
		s++, neg = 1;
  801716:	ff 45 08             	incl   0x8(%ebp)
  801719:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801720:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801724:	74 06                	je     80172c <strtol+0x58>
  801726:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  80172a:	75 20                	jne    80174c <strtol+0x78>
  80172c:	8b 45 08             	mov    0x8(%ebp),%eax
  80172f:	8a 00                	mov    (%eax),%al
  801731:	3c 30                	cmp    $0x30,%al
  801733:	75 17                	jne    80174c <strtol+0x78>
  801735:	8b 45 08             	mov    0x8(%ebp),%eax
  801738:	40                   	inc    %eax
  801739:	8a 00                	mov    (%eax),%al
  80173b:	3c 78                	cmp    $0x78,%al
  80173d:	75 0d                	jne    80174c <strtol+0x78>
		s += 2, base = 16;
  80173f:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801743:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  80174a:	eb 28                	jmp    801774 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  80174c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801750:	75 15                	jne    801767 <strtol+0x93>
  801752:	8b 45 08             	mov    0x8(%ebp),%eax
  801755:	8a 00                	mov    (%eax),%al
  801757:	3c 30                	cmp    $0x30,%al
  801759:	75 0c                	jne    801767 <strtol+0x93>
		s++, base = 8;
  80175b:	ff 45 08             	incl   0x8(%ebp)
  80175e:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801765:	eb 0d                	jmp    801774 <strtol+0xa0>
	else if (base == 0)
  801767:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80176b:	75 07                	jne    801774 <strtol+0xa0>
		base = 10;
  80176d:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801774:	8b 45 08             	mov    0x8(%ebp),%eax
  801777:	8a 00                	mov    (%eax),%al
  801779:	3c 2f                	cmp    $0x2f,%al
  80177b:	7e 19                	jle    801796 <strtol+0xc2>
  80177d:	8b 45 08             	mov    0x8(%ebp),%eax
  801780:	8a 00                	mov    (%eax),%al
  801782:	3c 39                	cmp    $0x39,%al
  801784:	7f 10                	jg     801796 <strtol+0xc2>
			dig = *s - '0';
  801786:	8b 45 08             	mov    0x8(%ebp),%eax
  801789:	8a 00                	mov    (%eax),%al
  80178b:	0f be c0             	movsbl %al,%eax
  80178e:	83 e8 30             	sub    $0x30,%eax
  801791:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801794:	eb 42                	jmp    8017d8 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801796:	8b 45 08             	mov    0x8(%ebp),%eax
  801799:	8a 00                	mov    (%eax),%al
  80179b:	3c 60                	cmp    $0x60,%al
  80179d:	7e 19                	jle    8017b8 <strtol+0xe4>
  80179f:	8b 45 08             	mov    0x8(%ebp),%eax
  8017a2:	8a 00                	mov    (%eax),%al
  8017a4:	3c 7a                	cmp    $0x7a,%al
  8017a6:	7f 10                	jg     8017b8 <strtol+0xe4>
			dig = *s - 'a' + 10;
  8017a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8017ab:	8a 00                	mov    (%eax),%al
  8017ad:	0f be c0             	movsbl %al,%eax
  8017b0:	83 e8 57             	sub    $0x57,%eax
  8017b3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8017b6:	eb 20                	jmp    8017d8 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  8017b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8017bb:	8a 00                	mov    (%eax),%al
  8017bd:	3c 40                	cmp    $0x40,%al
  8017bf:	7e 39                	jle    8017fa <strtol+0x126>
  8017c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8017c4:	8a 00                	mov    (%eax),%al
  8017c6:	3c 5a                	cmp    $0x5a,%al
  8017c8:	7f 30                	jg     8017fa <strtol+0x126>
			dig = *s - 'A' + 10;
  8017ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8017cd:	8a 00                	mov    (%eax),%al
  8017cf:	0f be c0             	movsbl %al,%eax
  8017d2:	83 e8 37             	sub    $0x37,%eax
  8017d5:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  8017d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017db:	3b 45 10             	cmp    0x10(%ebp),%eax
  8017de:	7d 19                	jge    8017f9 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  8017e0:	ff 45 08             	incl   0x8(%ebp)
  8017e3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8017e6:	0f af 45 10          	imul   0x10(%ebp),%eax
  8017ea:	89 c2                	mov    %eax,%edx
  8017ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017ef:	01 d0                	add    %edx,%eax
  8017f1:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8017f4:	e9 7b ff ff ff       	jmp    801774 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8017f9:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8017fa:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8017fe:	74 08                	je     801808 <strtol+0x134>
		*endptr = (char *) s;
  801800:	8b 45 0c             	mov    0xc(%ebp),%eax
  801803:	8b 55 08             	mov    0x8(%ebp),%edx
  801806:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801808:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80180c:	74 07                	je     801815 <strtol+0x141>
  80180e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801811:	f7 d8                	neg    %eax
  801813:	eb 03                	jmp    801818 <strtol+0x144>
  801815:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801818:	c9                   	leave  
  801819:	c3                   	ret    

0080181a <ltostr>:

void
ltostr(long value, char *str)
{
  80181a:	55                   	push   %ebp
  80181b:	89 e5                	mov    %esp,%ebp
  80181d:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801820:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801827:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  80182e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801832:	79 13                	jns    801847 <ltostr+0x2d>
	{
		neg = 1;
  801834:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  80183b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80183e:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801841:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801844:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801847:	8b 45 08             	mov    0x8(%ebp),%eax
  80184a:	b9 0a 00 00 00       	mov    $0xa,%ecx
  80184f:	99                   	cltd   
  801850:	f7 f9                	idiv   %ecx
  801852:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801855:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801858:	8d 50 01             	lea    0x1(%eax),%edx
  80185b:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80185e:	89 c2                	mov    %eax,%edx
  801860:	8b 45 0c             	mov    0xc(%ebp),%eax
  801863:	01 d0                	add    %edx,%eax
  801865:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801868:	83 c2 30             	add    $0x30,%edx
  80186b:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  80186d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801870:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801875:	f7 e9                	imul   %ecx
  801877:	c1 fa 02             	sar    $0x2,%edx
  80187a:	89 c8                	mov    %ecx,%eax
  80187c:	c1 f8 1f             	sar    $0x1f,%eax
  80187f:	29 c2                	sub    %eax,%edx
  801881:	89 d0                	mov    %edx,%eax
  801883:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  801886:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80188a:	75 bb                	jne    801847 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  80188c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801893:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801896:	48                   	dec    %eax
  801897:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  80189a:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80189e:	74 3d                	je     8018dd <ltostr+0xc3>
		start = 1 ;
  8018a0:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8018a7:	eb 34                	jmp    8018dd <ltostr+0xc3>
	{
		char tmp = str[start] ;
  8018a9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8018ac:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018af:	01 d0                	add    %edx,%eax
  8018b1:	8a 00                	mov    (%eax),%al
  8018b3:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8018b6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8018b9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018bc:	01 c2                	add    %eax,%edx
  8018be:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8018c1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018c4:	01 c8                	add    %ecx,%eax
  8018c6:	8a 00                	mov    (%eax),%al
  8018c8:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8018ca:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8018cd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018d0:	01 c2                	add    %eax,%edx
  8018d2:	8a 45 eb             	mov    -0x15(%ebp),%al
  8018d5:	88 02                	mov    %al,(%edx)
		start++ ;
  8018d7:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8018da:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8018dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018e0:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8018e3:	7c c4                	jl     8018a9 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8018e5:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8018e8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018eb:	01 d0                	add    %edx,%eax
  8018ed:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8018f0:	90                   	nop
  8018f1:	c9                   	leave  
  8018f2:	c3                   	ret    

008018f3 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8018f3:	55                   	push   %ebp
  8018f4:	89 e5                	mov    %esp,%ebp
  8018f6:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8018f9:	ff 75 08             	pushl  0x8(%ebp)
  8018fc:	e8 c4 f9 ff ff       	call   8012c5 <strlen>
  801901:	83 c4 04             	add    $0x4,%esp
  801904:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801907:	ff 75 0c             	pushl  0xc(%ebp)
  80190a:	e8 b6 f9 ff ff       	call   8012c5 <strlen>
  80190f:	83 c4 04             	add    $0x4,%esp
  801912:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801915:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  80191c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801923:	eb 17                	jmp    80193c <strcconcat+0x49>
		final[s] = str1[s] ;
  801925:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801928:	8b 45 10             	mov    0x10(%ebp),%eax
  80192b:	01 c2                	add    %eax,%edx
  80192d:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801930:	8b 45 08             	mov    0x8(%ebp),%eax
  801933:	01 c8                	add    %ecx,%eax
  801935:	8a 00                	mov    (%eax),%al
  801937:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801939:	ff 45 fc             	incl   -0x4(%ebp)
  80193c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80193f:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801942:	7c e1                	jl     801925 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801944:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  80194b:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801952:	eb 1f                	jmp    801973 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801954:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801957:	8d 50 01             	lea    0x1(%eax),%edx
  80195a:	89 55 fc             	mov    %edx,-0x4(%ebp)
  80195d:	89 c2                	mov    %eax,%edx
  80195f:	8b 45 10             	mov    0x10(%ebp),%eax
  801962:	01 c2                	add    %eax,%edx
  801964:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801967:	8b 45 0c             	mov    0xc(%ebp),%eax
  80196a:	01 c8                	add    %ecx,%eax
  80196c:	8a 00                	mov    (%eax),%al
  80196e:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801970:	ff 45 f8             	incl   -0x8(%ebp)
  801973:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801976:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801979:	7c d9                	jl     801954 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  80197b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80197e:	8b 45 10             	mov    0x10(%ebp),%eax
  801981:	01 d0                	add    %edx,%eax
  801983:	c6 00 00             	movb   $0x0,(%eax)
}
  801986:	90                   	nop
  801987:	c9                   	leave  
  801988:	c3                   	ret    

00801989 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801989:	55                   	push   %ebp
  80198a:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  80198c:	8b 45 14             	mov    0x14(%ebp),%eax
  80198f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801995:	8b 45 14             	mov    0x14(%ebp),%eax
  801998:	8b 00                	mov    (%eax),%eax
  80199a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8019a1:	8b 45 10             	mov    0x10(%ebp),%eax
  8019a4:	01 d0                	add    %edx,%eax
  8019a6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8019ac:	eb 0c                	jmp    8019ba <strsplit+0x31>
			*string++ = 0;
  8019ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8019b1:	8d 50 01             	lea    0x1(%eax),%edx
  8019b4:	89 55 08             	mov    %edx,0x8(%ebp)
  8019b7:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8019ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8019bd:	8a 00                	mov    (%eax),%al
  8019bf:	84 c0                	test   %al,%al
  8019c1:	74 18                	je     8019db <strsplit+0x52>
  8019c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8019c6:	8a 00                	mov    (%eax),%al
  8019c8:	0f be c0             	movsbl %al,%eax
  8019cb:	50                   	push   %eax
  8019cc:	ff 75 0c             	pushl  0xc(%ebp)
  8019cf:	e8 83 fa ff ff       	call   801457 <strchr>
  8019d4:	83 c4 08             	add    $0x8,%esp
  8019d7:	85 c0                	test   %eax,%eax
  8019d9:	75 d3                	jne    8019ae <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8019db:	8b 45 08             	mov    0x8(%ebp),%eax
  8019de:	8a 00                	mov    (%eax),%al
  8019e0:	84 c0                	test   %al,%al
  8019e2:	74 5a                	je     801a3e <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8019e4:	8b 45 14             	mov    0x14(%ebp),%eax
  8019e7:	8b 00                	mov    (%eax),%eax
  8019e9:	83 f8 0f             	cmp    $0xf,%eax
  8019ec:	75 07                	jne    8019f5 <strsplit+0x6c>
		{
			return 0;
  8019ee:	b8 00 00 00 00       	mov    $0x0,%eax
  8019f3:	eb 66                	jmp    801a5b <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8019f5:	8b 45 14             	mov    0x14(%ebp),%eax
  8019f8:	8b 00                	mov    (%eax),%eax
  8019fa:	8d 48 01             	lea    0x1(%eax),%ecx
  8019fd:	8b 55 14             	mov    0x14(%ebp),%edx
  801a00:	89 0a                	mov    %ecx,(%edx)
  801a02:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801a09:	8b 45 10             	mov    0x10(%ebp),%eax
  801a0c:	01 c2                	add    %eax,%edx
  801a0e:	8b 45 08             	mov    0x8(%ebp),%eax
  801a11:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801a13:	eb 03                	jmp    801a18 <strsplit+0x8f>
			string++;
  801a15:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801a18:	8b 45 08             	mov    0x8(%ebp),%eax
  801a1b:	8a 00                	mov    (%eax),%al
  801a1d:	84 c0                	test   %al,%al
  801a1f:	74 8b                	je     8019ac <strsplit+0x23>
  801a21:	8b 45 08             	mov    0x8(%ebp),%eax
  801a24:	8a 00                	mov    (%eax),%al
  801a26:	0f be c0             	movsbl %al,%eax
  801a29:	50                   	push   %eax
  801a2a:	ff 75 0c             	pushl  0xc(%ebp)
  801a2d:	e8 25 fa ff ff       	call   801457 <strchr>
  801a32:	83 c4 08             	add    $0x8,%esp
  801a35:	85 c0                	test   %eax,%eax
  801a37:	74 dc                	je     801a15 <strsplit+0x8c>
			string++;
	}
  801a39:	e9 6e ff ff ff       	jmp    8019ac <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801a3e:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801a3f:	8b 45 14             	mov    0x14(%ebp),%eax
  801a42:	8b 00                	mov    (%eax),%eax
  801a44:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801a4b:	8b 45 10             	mov    0x10(%ebp),%eax
  801a4e:	01 d0                	add    %edx,%eax
  801a50:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801a56:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801a5b:	c9                   	leave  
  801a5c:	c3                   	ret    

00801a5d <str2lower>:


char* str2lower(char *dst, const char *src)
{
  801a5d:	55                   	push   %ebp
  801a5e:	89 e5                	mov    %esp,%ebp
  801a60:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  801a63:	8b 45 08             	mov    0x8(%ebp),%eax
  801a66:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  801a69:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801a70:	eb 4a                	jmp    801abc <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  801a72:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801a75:	8b 45 08             	mov    0x8(%ebp),%eax
  801a78:	01 c2                	add    %eax,%edx
  801a7a:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801a7d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a80:	01 c8                	add    %ecx,%eax
  801a82:	8a 00                	mov    (%eax),%al
  801a84:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  801a86:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801a89:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a8c:	01 d0                	add    %edx,%eax
  801a8e:	8a 00                	mov    (%eax),%al
  801a90:	3c 40                	cmp    $0x40,%al
  801a92:	7e 25                	jle    801ab9 <str2lower+0x5c>
  801a94:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801a97:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a9a:	01 d0                	add    %edx,%eax
  801a9c:	8a 00                	mov    (%eax),%al
  801a9e:	3c 5a                	cmp    $0x5a,%al
  801aa0:	7f 17                	jg     801ab9 <str2lower+0x5c>
		{
			dst[i] += 32 ;
  801aa2:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801aa5:	8b 45 08             	mov    0x8(%ebp),%eax
  801aa8:	01 d0                	add    %edx,%eax
  801aaa:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801aad:	8b 55 08             	mov    0x8(%ebp),%edx
  801ab0:	01 ca                	add    %ecx,%edx
  801ab2:	8a 12                	mov    (%edx),%dl
  801ab4:	83 c2 20             	add    $0x20,%edx
  801ab7:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  801ab9:	ff 45 fc             	incl   -0x4(%ebp)
  801abc:	ff 75 0c             	pushl  0xc(%ebp)
  801abf:	e8 01 f8 ff ff       	call   8012c5 <strlen>
  801ac4:	83 c4 04             	add    $0x4,%esp
  801ac7:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801aca:	7f a6                	jg     801a72 <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  801acc:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801acf:	c9                   	leave  
  801ad0:	c3                   	ret    

00801ad1 <uheap_init>:
//==============================================
// [1] INITIALIZE USER HEAP:
//==============================================
int __firstTimeFlag = 1;
void uheap_init()
{
  801ad1:	55                   	push   %ebp
  801ad2:	89 e5                	mov    %esp,%ebp
  801ad4:	83 ec 08             	sub    $0x8,%esp
	if(__firstTimeFlag)
  801ad7:	a1 08 60 80 00       	mov    0x806008,%eax
  801adc:	85 c0                	test   %eax,%eax
  801ade:	0f 84 95 00 00 00    	je     801b79 <uheap_init+0xa8>
	{
		initialize_dynamic_allocator(USER_HEAP_START, USER_HEAP_START + DYN_ALLOC_MAX_SIZE);
  801ae4:	83 ec 08             	sub    $0x8,%esp
  801ae7:	68 00 00 00 82       	push   $0x82000000
  801aec:	68 00 00 00 80       	push   $0x80000000
  801af1:	e8 59 1f 00 00       	call   803a4f <initialize_dynamic_allocator>
  801af6:	83 c4 10             	add    $0x10,%esp
		uheapPlaceStrategy = sys_get_uheap_strategy();
  801af9:	e8 93 1d 00 00       	call   803891 <sys_get_uheap_strategy>
  801afe:	a3 60 e0 81 00       	mov    %eax,0x81e060
		uheapPageAllocStart = dynAllocEnd + PAGE_SIZE;
  801b03:	a1 40 60 80 00       	mov    0x806040,%eax
  801b08:	05 00 10 00 00       	add    $0x1000,%eax
  801b0d:	a3 10 e1 81 00       	mov    %eax,0x81e110
		uheapPageAllocBreak = uheapPageAllocStart;
  801b12:	a1 10 e1 81 00       	mov    0x81e110,%eax
  801b17:	a3 68 e0 81 00       	mov    %eax,0x81e068
		init_uspinlock(&ulock,"malloc",1);
  801b1c:	83 ec 04             	sub    $0x4,%esp
  801b1f:	6a 01                	push   $0x1
  801b21:	68 e8 4f 80 00       	push   $0x804fe8
  801b26:	68 40 e1 81 00       	push   $0x81e140
  801b2b:	e8 1a 29 00 00       	call   80444a <init_uspinlock>
  801b30:	83 c4 10             	add    $0x10,%esp
		LIST_INIT(&u_freelist);
  801b33:	c7 05 20 e1 81 00 00 	movl   $0x0,0x81e120
  801b3a:	00 00 00 
  801b3d:	c7 05 24 e1 81 00 00 	movl   $0x0,0x81e124
  801b44:	00 00 00 
  801b47:	c7 05 2c e1 81 00 00 	movl   $0x0,0x81e12c
  801b4e:	00 00 00 
		LIST_INIT(&u_allocatedlist);
  801b51:	c7 05 30 e1 81 00 00 	movl   $0x0,0x81e130
  801b58:	00 00 00 
  801b5b:	c7 05 34 e1 81 00 00 	movl   $0x0,0x81e134
  801b62:	00 00 00 
  801b65:	c7 05 3c e1 81 00 00 	movl   $0x0,0x81e13c
  801b6c:	00 00 00 
		__firstTimeFlag = 0;
  801b6f:	c7 05 08 60 80 00 00 	movl   $0x0,0x806008
  801b76:	00 00 00 
	}
}
  801b79:	90                   	nop
  801b7a:	c9                   	leave  
  801b7b:	c3                   	ret    

00801b7c <get_page>:

//==============================================
// [2] GET A PAGE FROM THE KERNEL FOR DA:
//==============================================
int get_page(void* va)
{
  801b7c:	55                   	push   %ebp
  801b7d:	89 e5                	mov    %esp,%ebp
  801b7f:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_allocate_page(ROUNDDOWN(va, PAGE_SIZE), PERM_USER|PERM_WRITEABLE|PERM_UHPAGE);
  801b82:	8b 45 08             	mov    0x8(%ebp),%eax
  801b85:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801b88:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b8b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801b90:	83 ec 08             	sub    $0x8,%esp
  801b93:	68 06 04 00 00       	push   $0x406
  801b98:	50                   	push   %eax
  801b99:	e8 3d 19 00 00       	call   8034db <__sys_allocate_page>
  801b9e:	83 c4 10             	add    $0x10,%esp
  801ba1:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  801ba4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801ba8:	79 14                	jns    801bbe <get_page+0x42>
		panic("get_page() in user: failed to allocate page from the kernel");
  801baa:	83 ec 04             	sub    $0x4,%esp
  801bad:	68 f0 4f 80 00       	push   $0x804ff0
  801bb2:	6a 2d                	push   $0x2d
  801bb4:	68 2c 50 80 00       	push   $0x80502c
  801bb9:	e8 60 ed ff ff       	call   80091e <_panic>
	return 0;
  801bbe:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801bc3:	c9                   	leave  
  801bc4:	c3                   	ret    

00801bc5 <return_page>:

//==============================================
// [3] RETURN A PAGE FROM THE DA TO KERNEL:
//==============================================
void return_page(void* va)
{
  801bc5:	55                   	push   %ebp
  801bc6:	89 e5                	mov    %esp,%ebp
  801bc8:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_unmap_frame(ROUNDDOWN((uint32)va, PAGE_SIZE));
  801bcb:	8b 45 08             	mov    0x8(%ebp),%eax
  801bce:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801bd1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bd4:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801bd9:	83 ec 0c             	sub    $0xc,%esp
  801bdc:	50                   	push   %eax
  801bdd:	e8 40 19 00 00       	call   803522 <__sys_unmap_frame>
  801be2:	83 c4 10             	add    $0x10,%esp
  801be5:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  801be8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801bec:	79 14                	jns    801c02 <return_page+0x3d>
		panic("return_page() in user: failed to return a page to the kernel");
  801bee:	83 ec 04             	sub    $0x4,%esp
  801bf1:	68 38 50 80 00       	push   $0x805038
  801bf6:	6a 38                	push   $0x38
  801bf8:	68 2c 50 80 00       	push   $0x80502c
  801bfd:	e8 1c ed ff ff       	call   80091e <_panic>
}
  801c02:	90                   	nop
  801c03:	c9                   	leave  
  801c04:	c3                   	ret    

00801c05 <malloc>:

//=================================
// [1] ALLOCATE SPACE IN USER HEAP:
//=================================
void* malloc(uint32 size)
{
  801c05:	55                   	push   %ebp
  801c06:	89 e5                	mov    %esp,%ebp
  801c08:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  801c0b:	e8 c1 fe ff ff       	call   801ad1 <uheap_init>
	if (size == 0) return NULL ;
  801c10:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801c14:	75 0a                	jne    801c20 <malloc+0x1b>
  801c16:	b8 00 00 00 00       	mov    $0x0,%eax
  801c1b:	e9 e1 04 00 00       	jmp    802101 <malloc+0x4fc>
	//==============================================================

	acquire_uspinlock(&ulock);
  801c20:	83 ec 0c             	sub    $0xc,%esp
  801c23:	68 40 e1 81 00       	push   $0x81e140
  801c28:	e8 6c 28 00 00       	call   804499 <acquire_uspinlock>
  801c2d:	83 c4 10             	add    $0x10,%esp
	if(size <  DYN_ALLOC_MAX_BLOCK_SIZE){
  801c30:	81 7d 08 ff 07 00 00 	cmpl   $0x7ff,0x8(%ebp)
  801c37:	77 23                	ja     801c5c <malloc+0x57>
		release_uspinlock(&ulock);
  801c39:	83 ec 0c             	sub    $0xc,%esp
  801c3c:	68 40 e1 81 00       	push   $0x81e140
  801c41:	e8 ab 28 00 00       	call   8044f1 <release_uspinlock>
  801c46:	83 c4 10             	add    $0x10,%esp
		return alloc_block(size);
  801c49:	83 ec 0c             	sub    $0xc,%esp
  801c4c:	ff 75 08             	pushl  0x8(%ebp)
  801c4f:	e8 dd 1f 00 00       	call   803c31 <alloc_block>
  801c54:	83 c4 10             	add    $0x10,%esp
  801c57:	e9 a5 04 00 00       	jmp    802101 <malloc+0x4fc>
	}

	struct UserHeapStruct* allocblock= (struct UserHeapStruct*) alloc_block(sizeof(struct UserHeapStruct));
  801c5c:	83 ec 0c             	sub    $0xc,%esp
  801c5f:	6a 10                	push   $0x10
  801c61:	e8 cb 1f 00 00       	call   803c31 <alloc_block>
  801c66:	83 c4 10             	add    $0x10,%esp
  801c69:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (allocblock == NULL){
  801c6c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801c70:	75 0a                	jne    801c7c <malloc+0x77>
			return NULL;
  801c72:	b8 00 00 00 00       	mov    $0x0,%eax
  801c77:	e9 85 04 00 00       	jmp    802101 <malloc+0x4fc>
	}

	size = ROUNDUP(size,PAGE_SIZE);
  801c7c:	c7 45 e8 00 10 00 00 	movl   $0x1000,-0x18(%ebp)
  801c83:	8b 55 08             	mov    0x8(%ebp),%edx
  801c86:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801c89:	01 d0                	add    %edx,%eax
  801c8b:	48                   	dec    %eax
  801c8c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801c8f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801c92:	ba 00 00 00 00       	mov    $0x0,%edx
  801c97:	f7 75 e8             	divl   -0x18(%ebp)
  801c9a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801c9d:	29 d0                	sub    %edx,%eax
  801c9f:	89 45 08             	mov    %eax,0x8(%ebp)
	struct UserHeapStruct* lastfreeelement = LIST_LAST(&u_freelist);
  801ca2:	a1 24 e1 81 00       	mov    0x81e124,%eax
  801ca7:	89 45 e0             	mov    %eax,-0x20(%ebp)

	if(LIST_SIZE(&u_freelist)==0 || size>lastfreeelement->size){
  801caa:	a1 2c e1 81 00       	mov    0x81e12c,%eax
  801caf:	85 c0                	test   %eax,%eax
  801cb1:	74 0f                	je     801cc2 <malloc+0xbd>
  801cb3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801cb6:	8b 40 04             	mov    0x4(%eax),%eax
  801cb9:	3b 45 08             	cmp    0x8(%ebp),%eax
  801cbc:	0f 83 ea 00 00 00    	jae    801dac <malloc+0x1a7>
			if(uheapPageAllocBreak < USER_HEAP_MAX - size){
  801cc2:	b8 00 00 00 a0       	mov    $0xa0000000,%eax
  801cc7:	2b 45 08             	sub    0x8(%ebp),%eax
  801cca:	89 c2                	mov    %eax,%edx
  801ccc:	a1 68 e0 81 00       	mov    0x81e068,%eax
  801cd1:	39 c2                	cmp    %eax,%edx
  801cd3:	0f 86 b9 00 00 00    	jbe    801d92 <malloc+0x18d>
					uint32 requestedblockva = uheapPageAllocBreak;
  801cd9:	a1 68 e0 81 00       	mov    0x81e068,%eax
  801cde:	89 45 dc             	mov    %eax,-0x24(%ebp)
					uheapPageAllocBreak+=size;
  801ce1:	8b 15 68 e0 81 00    	mov    0x81e068,%edx
  801ce7:	8b 45 08             	mov    0x8(%ebp),%eax
  801cea:	01 d0                	add    %edx,%eax
  801cec:	a3 68 e0 81 00       	mov    %eax,0x81e068
					allocblock->startva = requestedblockva;
  801cf1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801cf4:	8b 55 dc             	mov    -0x24(%ebp),%edx
  801cf7:	89 10                	mov    %edx,(%eax)
					allocblock->size = size;
  801cf9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801cfc:	8b 55 08             	mov    0x8(%ebp),%edx
  801cff:	89 50 04             	mov    %edx,0x4(%eax)

					LIST_INSERT_TAIL(&u_allocatedlist, allocblock);
  801d02:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801d06:	75 14                	jne    801d1c <malloc+0x117>
  801d08:	83 ec 04             	sub    $0x4,%esp
  801d0b:	68 78 50 80 00       	push   $0x805078
  801d10:	6a 60                	push   $0x60
  801d12:	68 2c 50 80 00       	push   $0x80502c
  801d17:	e8 02 ec ff ff       	call   80091e <_panic>
  801d1c:	8b 15 34 e1 81 00    	mov    0x81e134,%edx
  801d22:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801d25:	89 50 0c             	mov    %edx,0xc(%eax)
  801d28:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801d2b:	8b 40 0c             	mov    0xc(%eax),%eax
  801d2e:	85 c0                	test   %eax,%eax
  801d30:	74 0d                	je     801d3f <malloc+0x13a>
  801d32:	a1 34 e1 81 00       	mov    0x81e134,%eax
  801d37:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801d3a:	89 50 08             	mov    %edx,0x8(%eax)
  801d3d:	eb 08                	jmp    801d47 <malloc+0x142>
  801d3f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801d42:	a3 30 e1 81 00       	mov    %eax,0x81e130
  801d47:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801d4a:	a3 34 e1 81 00       	mov    %eax,0x81e134
  801d4f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801d52:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  801d59:	a1 3c e1 81 00       	mov    0x81e13c,%eax
  801d5e:	40                   	inc    %eax
  801d5f:	a3 3c e1 81 00       	mov    %eax,0x81e13c


					sys_allocate_user_mem(allocblock->startva ,size);
  801d64:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801d67:	8b 00                	mov    (%eax),%eax
  801d69:	83 ec 08             	sub    $0x8,%esp
  801d6c:	ff 75 08             	pushl  0x8(%ebp)
  801d6f:	50                   	push   %eax
  801d70:	e8 34 1c 00 00       	call   8039a9 <sys_allocate_user_mem>
  801d75:	83 c4 10             	add    $0x10,%esp
					release_uspinlock(&ulock);
  801d78:	83 ec 0c             	sub    $0xc,%esp
  801d7b:	68 40 e1 81 00       	push   $0x81e140
  801d80:	e8 6c 27 00 00       	call   8044f1 <release_uspinlock>
  801d85:	83 c4 10             	add    $0x10,%esp
					return (void*)allocblock->startva;
  801d88:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801d8b:	8b 00                	mov    (%eax),%eax
  801d8d:	e9 6f 03 00 00       	jmp    802101 <malloc+0x4fc>
			}else{
					release_uspinlock(&ulock);
  801d92:	83 ec 0c             	sub    $0xc,%esp
  801d95:	68 40 e1 81 00       	push   $0x81e140
  801d9a:	e8 52 27 00 00       	call   8044f1 <release_uspinlock>
  801d9f:	83 c4 10             	add    $0x10,%esp
					return NULL;
  801da2:	b8 00 00 00 00       	mov    $0x0,%eax
  801da7:	e9 55 03 00 00       	jmp    802101 <malloc+0x4fc>
				}
	}else{
		//custom fit
		struct UserHeapStruct* currentfreeelement = LIST_FIRST(&u_freelist);
  801dac:	a1 20 e1 81 00       	mov    0x81e120,%eax
  801db1:	89 45 f4             	mov    %eax,-0xc(%ebp)
		//worst fit
		while(currentfreeelement != NULL){
  801db4:	e9 39 03 00 00       	jmp    8020f2 <malloc+0x4ed>
			if(size<currentfreeelement->size){
  801db9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dbc:	8b 40 04             	mov    0x4(%eax),%eax
  801dbf:	3b 45 08             	cmp    0x8(%ebp),%eax
  801dc2:	0f 86 e7 01 00 00    	jbe    801faf <malloc+0x3aa>
				allocblock->startva = lastfreeelement->startva;
  801dc8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801dcb:	8b 10                	mov    (%eax),%edx
  801dcd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801dd0:	89 10                	mov    %edx,(%eax)
                allocblock->size = size;
  801dd2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801dd5:	8b 55 08             	mov    0x8(%ebp),%edx
  801dd8:	89 50 04             	mov    %edx,0x4(%eax)
                LIST_INSERT_TAIL(&u_allocatedlist,allocblock);
  801ddb:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801ddf:	75 14                	jne    801df5 <malloc+0x1f0>
  801de1:	83 ec 04             	sub    $0x4,%esp
  801de4:	68 78 50 80 00       	push   $0x805078
  801de9:	6a 72                	push   $0x72
  801deb:	68 2c 50 80 00       	push   $0x80502c
  801df0:	e8 29 eb ff ff       	call   80091e <_panic>
  801df5:	8b 15 34 e1 81 00    	mov    0x81e134,%edx
  801dfb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801dfe:	89 50 0c             	mov    %edx,0xc(%eax)
  801e01:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801e04:	8b 40 0c             	mov    0xc(%eax),%eax
  801e07:	85 c0                	test   %eax,%eax
  801e09:	74 0d                	je     801e18 <malloc+0x213>
  801e0b:	a1 34 e1 81 00       	mov    0x81e134,%eax
  801e10:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801e13:	89 50 08             	mov    %edx,0x8(%eax)
  801e16:	eb 08                	jmp    801e20 <malloc+0x21b>
  801e18:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801e1b:	a3 30 e1 81 00       	mov    %eax,0x81e130
  801e20:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801e23:	a3 34 e1 81 00       	mov    %eax,0x81e134
  801e28:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801e2b:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  801e32:	a1 3c e1 81 00       	mov    0x81e13c,%eax
  801e37:	40                   	inc    %eax
  801e38:	a3 3c e1 81 00       	mov    %eax,0x81e13c
                lastfreeelement->startva += size;
  801e3d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801e40:	8b 10                	mov    (%eax),%edx
  801e42:	8b 45 08             	mov    0x8(%ebp),%eax
  801e45:	01 c2                	add    %eax,%edx
  801e47:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801e4a:	89 10                	mov    %edx,(%eax)
                lastfreeelement->size -= size;
  801e4c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801e4f:	8b 40 04             	mov    0x4(%eax),%eax
  801e52:	2b 45 08             	sub    0x8(%ebp),%eax
  801e55:	89 c2                	mov    %eax,%edx
  801e57:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801e5a:	89 50 04             	mov    %edx,0x4(%eax)
                struct UserHeapStruct* currentfree2 = LIST_FIRST(&u_freelist);
  801e5d:	a1 20 e1 81 00       	mov    0x81e120,%eax
  801e62:	89 45 f0             	mov    %eax,-0x10(%ebp)
                //check order of last element

                while (currentfree2 != NULL){
  801e65:	e9 0d 01 00 00       	jmp    801f77 <malloc+0x372>
                	if(lastfreeelement->size <currentfree2->size){
  801e6a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801e6d:	8b 50 04             	mov    0x4(%eax),%edx
  801e70:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e73:	8b 40 04             	mov    0x4(%eax),%eax
  801e76:	39 c2                	cmp    %eax,%edx
  801e78:	0f 83 f0 00 00 00    	jae    801f6e <malloc+0x369>
                		LIST_REMOVE(&u_freelist ,lastfreeelement);
  801e7e:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801e82:	75 14                	jne    801e98 <malloc+0x293>
  801e84:	83 ec 04             	sub    $0x4,%esp
  801e87:	68 9b 50 80 00       	push   $0x80509b
  801e8c:	6a 7a                	push   $0x7a
  801e8e:	68 2c 50 80 00       	push   $0x80502c
  801e93:	e8 86 ea ff ff       	call   80091e <_panic>
  801e98:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801e9b:	8b 40 08             	mov    0x8(%eax),%eax
  801e9e:	85 c0                	test   %eax,%eax
  801ea0:	74 11                	je     801eb3 <malloc+0x2ae>
  801ea2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801ea5:	8b 40 08             	mov    0x8(%eax),%eax
  801ea8:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801eab:	8b 52 0c             	mov    0xc(%edx),%edx
  801eae:	89 50 0c             	mov    %edx,0xc(%eax)
  801eb1:	eb 0b                	jmp    801ebe <malloc+0x2b9>
  801eb3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801eb6:	8b 40 0c             	mov    0xc(%eax),%eax
  801eb9:	a3 24 e1 81 00       	mov    %eax,0x81e124
  801ebe:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801ec1:	8b 40 0c             	mov    0xc(%eax),%eax
  801ec4:	85 c0                	test   %eax,%eax
  801ec6:	74 11                	je     801ed9 <malloc+0x2d4>
  801ec8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801ecb:	8b 40 0c             	mov    0xc(%eax),%eax
  801ece:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801ed1:	8b 52 08             	mov    0x8(%edx),%edx
  801ed4:	89 50 08             	mov    %edx,0x8(%eax)
  801ed7:	eb 0b                	jmp    801ee4 <malloc+0x2df>
  801ed9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801edc:	8b 40 08             	mov    0x8(%eax),%eax
  801edf:	a3 20 e1 81 00       	mov    %eax,0x81e120
  801ee4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801ee7:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  801eee:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801ef1:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  801ef8:	a1 2c e1 81 00       	mov    0x81e12c,%eax
  801efd:	48                   	dec    %eax
  801efe:	a3 2c e1 81 00       	mov    %eax,0x81e12c
                		LIST_INSERT_BEFORE(&u_freelist ,currentfree2 ,lastfreeelement);
  801f03:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801f07:	74 06                	je     801f0f <malloc+0x30a>
  801f09:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801f0d:	75 14                	jne    801f23 <malloc+0x31e>
  801f0f:	83 ec 04             	sub    $0x4,%esp
  801f12:	68 bc 50 80 00       	push   $0x8050bc
  801f17:	6a 7b                	push   $0x7b
  801f19:	68 2c 50 80 00       	push   $0x80502c
  801f1e:	e8 fb e9 ff ff       	call   80091e <_panic>
  801f23:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f26:	8b 50 0c             	mov    0xc(%eax),%edx
  801f29:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801f2c:	89 50 0c             	mov    %edx,0xc(%eax)
  801f2f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801f32:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801f35:	89 50 08             	mov    %edx,0x8(%eax)
  801f38:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f3b:	8b 40 0c             	mov    0xc(%eax),%eax
  801f3e:	85 c0                	test   %eax,%eax
  801f40:	74 0e                	je     801f50 <malloc+0x34b>
  801f42:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f45:	8b 40 0c             	mov    0xc(%eax),%eax
  801f48:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801f4b:	89 50 08             	mov    %edx,0x8(%eax)
  801f4e:	eb 08                	jmp    801f58 <malloc+0x353>
  801f50:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801f53:	a3 20 e1 81 00       	mov    %eax,0x81e120
  801f58:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f5b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801f5e:	89 50 0c             	mov    %edx,0xc(%eax)
  801f61:	a1 2c e1 81 00       	mov    0x81e12c,%eax
  801f66:	40                   	inc    %eax
  801f67:	a3 2c e1 81 00       	mov    %eax,0x81e12c
                		break;
  801f6c:	eb 13                	jmp    801f81 <malloc+0x37c>
                	}
                	currentfree2 = currentfree2->prev_next_info.le_next;
  801f6e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f71:	8b 40 08             	mov    0x8(%eax),%eax
  801f74:	89 45 f0             	mov    %eax,-0x10(%ebp)
                lastfreeelement->startva += size;
                lastfreeelement->size -= size;
                struct UserHeapStruct* currentfree2 = LIST_FIRST(&u_freelist);
                //check order of last element

                while (currentfree2 != NULL){
  801f77:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801f7b:	0f 85 e9 fe ff ff    	jne    801e6a <malloc+0x265>
                	}
                	currentfree2 = currentfree2->prev_next_info.le_next;
                }


                sys_allocate_user_mem(allocblock->startva ,size);
  801f81:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f84:	8b 00                	mov    (%eax),%eax
  801f86:	83 ec 08             	sub    $0x8,%esp
  801f89:	ff 75 08             	pushl  0x8(%ebp)
  801f8c:	50                   	push   %eax
  801f8d:	e8 17 1a 00 00       	call   8039a9 <sys_allocate_user_mem>
  801f92:	83 c4 10             	add    $0x10,%esp
                release_uspinlock(&ulock);
  801f95:	83 ec 0c             	sub    $0xc,%esp
  801f98:	68 40 e1 81 00       	push   $0x81e140
  801f9d:	e8 4f 25 00 00       	call   8044f1 <release_uspinlock>
  801fa2:	83 c4 10             	add    $0x10,%esp
                return (void*)allocblock->startva;
  801fa5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801fa8:	8b 00                	mov    (%eax),%eax
  801faa:	e9 52 01 00 00       	jmp    802101 <malloc+0x4fc>
                //exact fit
			}else if(size == currentfreeelement->size){
  801faf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fb2:	8b 40 04             	mov    0x4(%eax),%eax
  801fb5:	3b 45 08             	cmp    0x8(%ebp),%eax
  801fb8:	0f 85 2b 01 00 00    	jne    8020e9 <malloc+0x4e4>
				allocblock->startva = currentfreeelement->startva;
  801fbe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fc1:	8b 10                	mov    (%eax),%edx
  801fc3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801fc6:	89 10                	mov    %edx,(%eax)
				allocblock->size = size;
  801fc8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801fcb:	8b 55 08             	mov    0x8(%ebp),%edx
  801fce:	89 50 04             	mov    %edx,0x4(%eax)
				LIST_INSERT_TAIL(&u_allocatedlist ,allocblock);
  801fd1:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801fd5:	75 17                	jne    801fee <malloc+0x3e9>
  801fd7:	83 ec 04             	sub    $0x4,%esp
  801fda:	68 78 50 80 00       	push   $0x805078
  801fdf:	68 89 00 00 00       	push   $0x89
  801fe4:	68 2c 50 80 00       	push   $0x80502c
  801fe9:	e8 30 e9 ff ff       	call   80091e <_panic>
  801fee:	8b 15 34 e1 81 00    	mov    0x81e134,%edx
  801ff4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801ff7:	89 50 0c             	mov    %edx,0xc(%eax)
  801ffa:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801ffd:	8b 40 0c             	mov    0xc(%eax),%eax
  802000:	85 c0                	test   %eax,%eax
  802002:	74 0d                	je     802011 <malloc+0x40c>
  802004:	a1 34 e1 81 00       	mov    0x81e134,%eax
  802009:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80200c:	89 50 08             	mov    %edx,0x8(%eax)
  80200f:	eb 08                	jmp    802019 <malloc+0x414>
  802011:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802014:	a3 30 e1 81 00       	mov    %eax,0x81e130
  802019:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80201c:	a3 34 e1 81 00       	mov    %eax,0x81e134
  802021:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802024:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  80202b:	a1 3c e1 81 00       	mov    0x81e13c,%eax
  802030:	40                   	inc    %eax
  802031:	a3 3c e1 81 00       	mov    %eax,0x81e13c
				LIST_REMOVE(&u_freelist ,currentfreeelement);
  802036:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80203a:	75 17                	jne    802053 <malloc+0x44e>
  80203c:	83 ec 04             	sub    $0x4,%esp
  80203f:	68 9b 50 80 00       	push   $0x80509b
  802044:	68 8a 00 00 00       	push   $0x8a
  802049:	68 2c 50 80 00       	push   $0x80502c
  80204e:	e8 cb e8 ff ff       	call   80091e <_panic>
  802053:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802056:	8b 40 08             	mov    0x8(%eax),%eax
  802059:	85 c0                	test   %eax,%eax
  80205b:	74 11                	je     80206e <malloc+0x469>
  80205d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802060:	8b 40 08             	mov    0x8(%eax),%eax
  802063:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802066:	8b 52 0c             	mov    0xc(%edx),%edx
  802069:	89 50 0c             	mov    %edx,0xc(%eax)
  80206c:	eb 0b                	jmp    802079 <malloc+0x474>
  80206e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802071:	8b 40 0c             	mov    0xc(%eax),%eax
  802074:	a3 24 e1 81 00       	mov    %eax,0x81e124
  802079:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80207c:	8b 40 0c             	mov    0xc(%eax),%eax
  80207f:	85 c0                	test   %eax,%eax
  802081:	74 11                	je     802094 <malloc+0x48f>
  802083:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802086:	8b 40 0c             	mov    0xc(%eax),%eax
  802089:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80208c:	8b 52 08             	mov    0x8(%edx),%edx
  80208f:	89 50 08             	mov    %edx,0x8(%eax)
  802092:	eb 0b                	jmp    80209f <malloc+0x49a>
  802094:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802097:	8b 40 08             	mov    0x8(%eax),%eax
  80209a:	a3 20 e1 81 00       	mov    %eax,0x81e120
  80209f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020a2:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  8020a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020ac:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  8020b3:	a1 2c e1 81 00       	mov    0x81e12c,%eax
  8020b8:	48                   	dec    %eax
  8020b9:	a3 2c e1 81 00       	mov    %eax,0x81e12c
				sys_allocate_user_mem(allocblock->startva ,size);
  8020be:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8020c1:	8b 00                	mov    (%eax),%eax
  8020c3:	83 ec 08             	sub    $0x8,%esp
  8020c6:	ff 75 08             	pushl  0x8(%ebp)
  8020c9:	50                   	push   %eax
  8020ca:	e8 da 18 00 00       	call   8039a9 <sys_allocate_user_mem>
  8020cf:	83 c4 10             	add    $0x10,%esp
				release_uspinlock(&ulock);
  8020d2:	83 ec 0c             	sub    $0xc,%esp
  8020d5:	68 40 e1 81 00       	push   $0x81e140
  8020da:	e8 12 24 00 00       	call   8044f1 <release_uspinlock>
  8020df:	83 c4 10             	add    $0x10,%esp
				return (void*)allocblock->startva;
  8020e2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8020e5:	8b 00                	mov    (%eax),%eax
  8020e7:	eb 18                	jmp    802101 <malloc+0x4fc>
			}
			currentfreeelement = currentfreeelement->prev_next_info.le_next;
  8020e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020ec:	8b 40 08             	mov    0x8(%eax),%eax
  8020ef:	89 45 f4             	mov    %eax,-0xc(%ebp)
				}
	}else{
		//custom fit
		struct UserHeapStruct* currentfreeelement = LIST_FIRST(&u_freelist);
		//worst fit
		while(currentfreeelement != NULL){
  8020f2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8020f6:	0f 85 bd fc ff ff    	jne    801db9 <malloc+0x1b4>
				return (void*)allocblock->startva;
			}
			currentfreeelement = currentfreeelement->prev_next_info.le_next;
		}
	}
	 return NULL;
  8020fc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802101:	c9                   	leave  
  802102:	c3                   	ret    

00802103 <free>:

//=================================
// [2] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
  802103:	55                   	push   %ebp
  802104:	89 e5                	mov    %esp,%ebp
  802106:	83 ec 38             	sub    $0x38,%esp
	uint32  VA = ROUNDDOWN(((uint32 ) virtual_address), PAGE_SIZE);
  802109:	8b 45 08             	mov    0x8(%ebp),%eax
  80210c:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80210f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802112:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  802117:	89 45 d8             	mov    %eax,-0x28(%ebp)


		uheap_init();
  80211a:	e8 b2 f9 ff ff       	call   801ad1 <uheap_init>
		acquire_uspinlock(&ulock);
  80211f:	83 ec 0c             	sub    $0xc,%esp
  802122:	68 40 e1 81 00       	push   $0x81e140
  802127:	e8 6d 23 00 00       	call   804499 <acquire_uspinlock>
  80212c:	83 c4 10             	add    $0x10,%esp
		if (VA < uheapPageAllocStart){
  80212f:	a1 10 e1 81 00       	mov    0x81e110,%eax
  802134:	39 45 d8             	cmp    %eax,-0x28(%ebp)
  802137:	73 23                	jae    80215c <free+0x59>
			free_block(virtual_address);
  802139:	83 ec 0c             	sub    $0xc,%esp
  80213c:	ff 75 08             	pushl  0x8(%ebp)
  80213f:	e8 89 1f 00 00       	call   8040cd <free_block>
  802144:	83 c4 10             	add    $0x10,%esp
			release_uspinlock(&ulock);
  802147:	83 ec 0c             	sub    $0xc,%esp
  80214a:	68 40 e1 81 00       	push   $0x81e140
  80214f:	e8 9d 23 00 00       	call   8044f1 <release_uspinlock>
  802154:	83 c4 10             	add    $0x10,%esp
			return;
  802157:	e9 35 07 00 00       	jmp    802891 <free+0x78e>
		}
		if (VA >= uheapPageAllocBreak){
  80215c:	a1 68 e0 81 00       	mov    0x81e068,%eax
  802161:	39 45 d8             	cmp    %eax,-0x28(%ebp)
  802164:	72 30                	jb     802196 <free+0x93>
			cprintf("%d\n %d\n", VA, uheapPageAllocBreak);
  802166:	a1 68 e0 81 00       	mov    0x81e068,%eax
  80216b:	83 ec 04             	sub    $0x4,%esp
  80216e:	50                   	push   %eax
  80216f:	ff 75 d8             	pushl  -0x28(%ebp)
  802172:	68 f1 50 80 00       	push   $0x8050f1
  802177:	e8 70 ea ff ff       	call   800bec <cprintf>
  80217c:	83 c4 10             	add    $0x10,%esp

			panic("freeing from restricted area");
  80217f:	83 ec 04             	sub    $0x4,%esp
  802182:	68 f9 50 80 00       	push   $0x8050f9
  802187:	68 a7 00 00 00       	push   $0xa7
  80218c:	68 2c 50 80 00       	push   $0x80502c
  802191:	e8 88 e7 ff ff       	call   80091e <_panic>
			release_uspinlock(&ulock);
			return;
		}

		struct UserHeapStruct* newfree = (struct UserHeapStruct*) alloc_block(sizeof(struct UserHeapStruct));
  802196:	83 ec 0c             	sub    $0xc,%esp
  802199:	6a 10                	push   $0x10
  80219b:	e8 91 1a 00 00       	call   803c31 <alloc_block>
  8021a0:	83 c4 10             	add    $0x10,%esp
  8021a3:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		struct UserHeapStruct* MergedBlock  = ( struct UserHeapStruct*)alloc_block(sizeof(struct UserHeapStruct));
  8021a6:	83 ec 0c             	sub    $0xc,%esp
  8021a9:	6a 10                	push   $0x10
  8021ab:	e8 81 1a 00 00       	call   803c31 <alloc_block>
  8021b0:	83 c4 10             	add    $0x10,%esp
  8021b3:	89 45 d0             	mov    %eax,-0x30(%ebp)

		struct UserHeapStruct* ToBefreed = LIST_FIRST(&u_allocatedlist);
  8021b6:	a1 30 e1 81 00       	mov    0x81e130,%eax
  8021bb:	89 45 f4             	mov    %eax,-0xc(%ebp)
		bool foundVA = 0;
  8021be:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

		//find the allocated block
		while(ToBefreed !=NULL ){
  8021c5:	eb 1c                	jmp    8021e3 <free+0xe0>

			if (VA ==ToBefreed->startva ){
  8021c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021ca:	8b 00                	mov    (%eax),%eax
  8021cc:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  8021cf:	75 09                	jne    8021da <free+0xd7>
				foundVA = 1;
  8021d1:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
				break;
  8021d8:	eb 0f                	jmp    8021e9 <free+0xe6>
			}
				ToBefreed = ToBefreed->prev_next_info.le_next;
  8021da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021dd:	8b 40 08             	mov    0x8(%eax),%eax
  8021e0:	89 45 f4             	mov    %eax,-0xc(%ebp)

		struct UserHeapStruct* ToBefreed = LIST_FIRST(&u_allocatedlist);
		bool foundVA = 0;

		//find the allocated block
		while(ToBefreed !=NULL ){
  8021e3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8021e7:	75 de                	jne    8021c7 <free+0xc4>
			}
				ToBefreed = ToBefreed->prev_next_info.le_next;
		}


		if(!foundVA){
  8021e9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8021ed:	75 17                	jne    802206 <free+0x103>
				panic("INVALID ADDRESS!");
  8021ef:	83 ec 04             	sub    $0x4,%esp
  8021f2:	68 16 51 80 00       	push   $0x805116
  8021f7:	68 be 00 00 00       	push   $0xbe
  8021fc:	68 2c 50 80 00       	push   $0x80502c
  802201:	e8 18 e7 ff ff       	call   80091e <_panic>
				release_uspinlock(&ulock);
				return;
			}


		newfree->startva = ToBefreed->startva;
  802206:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802209:	8b 10                	mov    (%eax),%edx
  80220b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80220e:	89 10                	mov    %edx,(%eax)
		newfree->size = ToBefreed->size;
  802210:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802213:	8b 50 04             	mov    0x4(%eax),%edx
  802216:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802219:	89 50 04             	mov    %edx,0x4(%eax)

		//remove allocated block from alloclist
		LIST_REMOVE(&u_allocatedlist, ToBefreed);
  80221c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802220:	75 17                	jne    802239 <free+0x136>
  802222:	83 ec 04             	sub    $0x4,%esp
  802225:	68 9b 50 80 00       	push   $0x80509b
  80222a:	68 c8 00 00 00       	push   $0xc8
  80222f:	68 2c 50 80 00       	push   $0x80502c
  802234:	e8 e5 e6 ff ff       	call   80091e <_panic>
  802239:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80223c:	8b 40 08             	mov    0x8(%eax),%eax
  80223f:	85 c0                	test   %eax,%eax
  802241:	74 11                	je     802254 <free+0x151>
  802243:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802246:	8b 40 08             	mov    0x8(%eax),%eax
  802249:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80224c:	8b 52 0c             	mov    0xc(%edx),%edx
  80224f:	89 50 0c             	mov    %edx,0xc(%eax)
  802252:	eb 0b                	jmp    80225f <free+0x15c>
  802254:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802257:	8b 40 0c             	mov    0xc(%eax),%eax
  80225a:	a3 34 e1 81 00       	mov    %eax,0x81e134
  80225f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802262:	8b 40 0c             	mov    0xc(%eax),%eax
  802265:	85 c0                	test   %eax,%eax
  802267:	74 11                	je     80227a <free+0x177>
  802269:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80226c:	8b 40 0c             	mov    0xc(%eax),%eax
  80226f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802272:	8b 52 08             	mov    0x8(%edx),%edx
  802275:	89 50 08             	mov    %edx,0x8(%eax)
  802278:	eb 0b                	jmp    802285 <free+0x182>
  80227a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80227d:	8b 40 08             	mov    0x8(%eax),%eax
  802280:	a3 30 e1 81 00       	mov    %eax,0x81e130
  802285:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802288:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  80228f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802292:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  802299:	a1 3c e1 81 00       	mov    0x81e13c,%eax
  80229e:	48                   	dec    %eax
  80229f:	a3 3c e1 81 00       	mov    %eax,0x81e13c

		sys_free_user_mem(ToBefreed->startva, ToBefreed->size);
  8022a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022a7:	8b 50 04             	mov    0x4(%eax),%edx
  8022aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022ad:	8b 00                	mov    (%eax),%eax
  8022af:	83 ec 08             	sub    $0x8,%esp
  8022b2:	52                   	push   %edx
  8022b3:	50                   	push   %eax
  8022b4:	e8 d4 16 00 00       	call   80398d <sys_free_user_mem>
  8022b9:	83 c4 10             	add    $0x10,%esp




		if(LIST_SIZE(&u_freelist) == 0){
  8022bc:	a1 2c e1 81 00       	mov    0x81e12c,%eax
  8022c1:	85 c0                	test   %eax,%eax
  8022c3:	75 7a                	jne    80233f <free+0x23c>
			LIST_INSERT_HEAD(&u_freelist,newfree);
  8022c5:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8022c9:	75 17                	jne    8022e2 <free+0x1df>
  8022cb:	83 ec 04             	sub    $0x4,%esp
  8022ce:	68 28 51 80 00       	push   $0x805128
  8022d3:	68 d0 00 00 00       	push   $0xd0
  8022d8:	68 2c 50 80 00       	push   $0x80502c
  8022dd:	e8 3c e6 ff ff       	call   80091e <_panic>
  8022e2:	8b 15 20 e1 81 00    	mov    0x81e120,%edx
  8022e8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8022eb:	89 50 08             	mov    %edx,0x8(%eax)
  8022ee:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8022f1:	8b 40 08             	mov    0x8(%eax),%eax
  8022f4:	85 c0                	test   %eax,%eax
  8022f6:	74 0d                	je     802305 <free+0x202>
  8022f8:	a1 20 e1 81 00       	mov    0x81e120,%eax
  8022fd:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802300:	89 50 0c             	mov    %edx,0xc(%eax)
  802303:	eb 08                	jmp    80230d <free+0x20a>
  802305:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802308:	a3 24 e1 81 00       	mov    %eax,0x81e124
  80230d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802310:	a3 20 e1 81 00       	mov    %eax,0x81e120
  802315:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802318:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  80231f:	a1 2c e1 81 00       	mov    0x81e12c,%eax
  802324:	40                   	inc    %eax
  802325:	a3 2c e1 81 00       	mov    %eax,0x81e12c
			release_uspinlock(&ulock);
  80232a:	83 ec 0c             	sub    $0xc,%esp
  80232d:	68 40 e1 81 00       	push   $0x81e140
  802332:	e8 ba 21 00 00       	call   8044f1 <release_uspinlock>
  802337:	83 c4 10             	add    $0x10,%esp
			return;
  80233a:	e9 52 05 00 00       	jmp    802891 <free+0x78e>
		}


		struct UserHeapStruct* ToBeMerged = LIST_FIRST(&u_freelist);
  80233f:	a1 20 e1 81 00       	mov    0x81e120,%eax
  802344:	89 45 ec             	mov    %eax,-0x14(%ebp)
		// merge with prev if possible
		bool mergeprev = 0;
  802347:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		bool mergenext = 0;
  80234e:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
		while(ToBeMerged != NULL){
  802355:	e9 d2 00 00 00       	jmp    80242c <free+0x329>
			if((ToBeMerged->startva +ToBeMerged->size) == newfree->startva){
  80235a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80235d:	8b 10                	mov    (%eax),%edx
  80235f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802362:	8b 40 04             	mov    0x4(%eax),%eax
  802365:	01 c2                	add    %eax,%edx
  802367:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80236a:	8b 00                	mov    (%eax),%eax
  80236c:	39 c2                	cmp    %eax,%edx
  80236e:	0f 85 af 00 00 00    	jne    802423 <free+0x320>

				MergedBlock->startva = ToBeMerged->startva;
  802374:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802377:	8b 10                	mov    (%eax),%edx
  802379:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80237c:	89 10                	mov    %edx,(%eax)
				MergedBlock->size = ToBeMerged->size + newfree->size;
  80237e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802381:	8b 50 04             	mov    0x4(%eax),%edx
  802384:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802387:	8b 40 04             	mov    0x4(%eax),%eax
  80238a:	01 c2                	add    %eax,%edx
  80238c:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80238f:	89 50 04             	mov    %edx,0x4(%eax)
				LIST_REMOVE(&u_freelist, ToBeMerged);
  802392:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802396:	75 17                	jne    8023af <free+0x2ac>
  802398:	83 ec 04             	sub    $0x4,%esp
  80239b:	68 9b 50 80 00       	push   $0x80509b
  8023a0:	68 df 00 00 00       	push   $0xdf
  8023a5:	68 2c 50 80 00       	push   $0x80502c
  8023aa:	e8 6f e5 ff ff       	call   80091e <_panic>
  8023af:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8023b2:	8b 40 08             	mov    0x8(%eax),%eax
  8023b5:	85 c0                	test   %eax,%eax
  8023b7:	74 11                	je     8023ca <free+0x2c7>
  8023b9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8023bc:	8b 40 08             	mov    0x8(%eax),%eax
  8023bf:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8023c2:	8b 52 0c             	mov    0xc(%edx),%edx
  8023c5:	89 50 0c             	mov    %edx,0xc(%eax)
  8023c8:	eb 0b                	jmp    8023d5 <free+0x2d2>
  8023ca:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8023cd:	8b 40 0c             	mov    0xc(%eax),%eax
  8023d0:	a3 24 e1 81 00       	mov    %eax,0x81e124
  8023d5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8023d8:	8b 40 0c             	mov    0xc(%eax),%eax
  8023db:	85 c0                	test   %eax,%eax
  8023dd:	74 11                	je     8023f0 <free+0x2ed>
  8023df:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8023e2:	8b 40 0c             	mov    0xc(%eax),%eax
  8023e5:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8023e8:	8b 52 08             	mov    0x8(%edx),%edx
  8023eb:	89 50 08             	mov    %edx,0x8(%eax)
  8023ee:	eb 0b                	jmp    8023fb <free+0x2f8>
  8023f0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8023f3:	8b 40 08             	mov    0x8(%eax),%eax
  8023f6:	a3 20 e1 81 00       	mov    %eax,0x81e120
  8023fb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8023fe:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802405:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802408:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  80240f:	a1 2c e1 81 00       	mov    0x81e12c,%eax
  802414:	48                   	dec    %eax
  802415:	a3 2c e1 81 00       	mov    %eax,0x81e12c
				mergeprev = 1;
  80241a:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
				break;
  802421:	eb 13                	jmp    802436 <free+0x333>
			}
				ToBeMerged = ToBeMerged->prev_next_info.le_next;
  802423:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802426:	8b 40 08             	mov    0x8(%eax),%eax
  802429:	89 45 ec             	mov    %eax,-0x14(%ebp)

		struct UserHeapStruct* ToBeMerged = LIST_FIRST(&u_freelist);
		// merge with prev if possible
		bool mergeprev = 0;
		bool mergenext = 0;
		while(ToBeMerged != NULL){
  80242c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802430:	0f 85 24 ff ff ff    	jne    80235a <free+0x257>
//									uheapPageAllocBreak = newfree->startva;
//						}
//					}


		if ( newfree ->startva + newfree->size == uheapPageAllocBreak){
  802436:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802439:	8b 10                	mov    (%eax),%edx
  80243b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80243e:	8b 40 04             	mov    0x4(%eax),%eax
  802441:	01 c2                	add    %eax,%edx
  802443:	a1 68 e0 81 00       	mov    0x81e068,%eax
  802448:	39 c2                	cmp    %eax,%edx
  80244a:	75 44                	jne    802490 <free+0x38d>

			if(mergeprev){
  80244c:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802450:	74 1f                	je     802471 <free+0x36e>
				uheapPageAllocBreak = MergedBlock->startva;
  802452:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802455:	8b 00                	mov    (%eax),%eax
  802457:	a3 68 e0 81 00       	mov    %eax,0x81e068
				release_uspinlock(&ulock);
  80245c:	83 ec 0c             	sub    $0xc,%esp
  80245f:	68 40 e1 81 00       	push   $0x81e140
  802464:	e8 88 20 00 00       	call   8044f1 <release_uspinlock>
  802469:	83 c4 10             	add    $0x10,%esp
				return;
  80246c:	e9 20 04 00 00       	jmp    802891 <free+0x78e>

			}else{
				uheapPageAllocBreak = newfree->startva;
  802471:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802474:	8b 00                	mov    (%eax),%eax
  802476:	a3 68 e0 81 00       	mov    %eax,0x81e068
				release_uspinlock(&ulock);
  80247b:	83 ec 0c             	sub    $0xc,%esp
  80247e:	68 40 e1 81 00       	push   $0x81e140
  802483:	e8 69 20 00 00       	call   8044f1 <release_uspinlock>
  802488:	83 c4 10             	add    $0x10,%esp
				return;
  80248b:	e9 01 04 00 00       	jmp    802891 <free+0x78e>

		}


		//check if block is merged with prev ,and find possible merge with next
		ToBeMerged = LIST_FIRST(&u_freelist);
  802490:	a1 20 e1 81 00       	mov    0x81e120,%eax
  802495:	89 45 ec             	mov    %eax,-0x14(%ebp)
		while(ToBeMerged != NULL){
  802498:	e9 7d 01 00 00       	jmp    80261a <free+0x517>
			if ((newfree->startva + newfree->size) == ToBeMerged->startva ){
  80249d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8024a0:	8b 10                	mov    (%eax),%edx
  8024a2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8024a5:	8b 40 04             	mov    0x4(%eax),%eax
  8024a8:	01 c2                	add    %eax,%edx
  8024aa:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8024ad:	8b 00                	mov    (%eax),%eax
  8024af:	39 c2                	cmp    %eax,%edx
  8024b1:	0f 85 5a 01 00 00    	jne    802611 <free+0x50e>
				if (mergeprev){
  8024b7:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8024bb:	0f 84 a1 00 00 00    	je     802562 <free+0x45f>
					MergedBlock->size += ToBeMerged->size;
  8024c1:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8024c4:	8b 50 04             	mov    0x4(%eax),%edx
  8024c7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8024ca:	8b 40 04             	mov    0x4(%eax),%eax
  8024cd:	01 c2                	add    %eax,%edx
  8024cf:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8024d2:	89 50 04             	mov    %edx,0x4(%eax)
					LIST_REMOVE(&u_freelist, ToBeMerged);
  8024d5:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8024d9:	75 17                	jne    8024f2 <free+0x3ef>
  8024db:	83 ec 04             	sub    $0x4,%esp
  8024de:	68 9b 50 80 00       	push   $0x80509b
  8024e3:	68 0a 01 00 00       	push   $0x10a
  8024e8:	68 2c 50 80 00       	push   $0x80502c
  8024ed:	e8 2c e4 ff ff       	call   80091e <_panic>
  8024f2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8024f5:	8b 40 08             	mov    0x8(%eax),%eax
  8024f8:	85 c0                	test   %eax,%eax
  8024fa:	74 11                	je     80250d <free+0x40a>
  8024fc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8024ff:	8b 40 08             	mov    0x8(%eax),%eax
  802502:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802505:	8b 52 0c             	mov    0xc(%edx),%edx
  802508:	89 50 0c             	mov    %edx,0xc(%eax)
  80250b:	eb 0b                	jmp    802518 <free+0x415>
  80250d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802510:	8b 40 0c             	mov    0xc(%eax),%eax
  802513:	a3 24 e1 81 00       	mov    %eax,0x81e124
  802518:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80251b:	8b 40 0c             	mov    0xc(%eax),%eax
  80251e:	85 c0                	test   %eax,%eax
  802520:	74 11                	je     802533 <free+0x430>
  802522:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802525:	8b 40 0c             	mov    0xc(%eax),%eax
  802528:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80252b:	8b 52 08             	mov    0x8(%edx),%edx
  80252e:	89 50 08             	mov    %edx,0x8(%eax)
  802531:	eb 0b                	jmp    80253e <free+0x43b>
  802533:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802536:	8b 40 08             	mov    0x8(%eax),%eax
  802539:	a3 20 e1 81 00       	mov    %eax,0x81e120
  80253e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802541:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802548:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80254b:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  802552:	a1 2c e1 81 00       	mov    0x81e12c,%eax
  802557:	48                   	dec    %eax
  802558:	a3 2c e1 81 00       	mov    %eax,0x81e12c
					break;
  80255d:	e9 c2 00 00 00       	jmp    802624 <free+0x521>
		//if not merged find possible merge with next
				}else{
					MergedBlock->startva = newfree->startva;
  802562:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802565:	8b 10                	mov    (%eax),%edx
  802567:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80256a:	89 10                	mov    %edx,(%eax)
					MergedBlock->size  = newfree->size + ToBeMerged->size;
  80256c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80256f:	8b 50 04             	mov    0x4(%eax),%edx
  802572:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802575:	8b 40 04             	mov    0x4(%eax),%eax
  802578:	01 c2                	add    %eax,%edx
  80257a:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80257d:	89 50 04             	mov    %edx,0x4(%eax)
					LIST_REMOVE(&u_freelist, ToBeMerged);
  802580:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802584:	75 17                	jne    80259d <free+0x49a>
  802586:	83 ec 04             	sub    $0x4,%esp
  802589:	68 9b 50 80 00       	push   $0x80509b
  80258e:	68 10 01 00 00       	push   $0x110
  802593:	68 2c 50 80 00       	push   $0x80502c
  802598:	e8 81 e3 ff ff       	call   80091e <_panic>
  80259d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025a0:	8b 40 08             	mov    0x8(%eax),%eax
  8025a3:	85 c0                	test   %eax,%eax
  8025a5:	74 11                	je     8025b8 <free+0x4b5>
  8025a7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025aa:	8b 40 08             	mov    0x8(%eax),%eax
  8025ad:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8025b0:	8b 52 0c             	mov    0xc(%edx),%edx
  8025b3:	89 50 0c             	mov    %edx,0xc(%eax)
  8025b6:	eb 0b                	jmp    8025c3 <free+0x4c0>
  8025b8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025bb:	8b 40 0c             	mov    0xc(%eax),%eax
  8025be:	a3 24 e1 81 00       	mov    %eax,0x81e124
  8025c3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025c6:	8b 40 0c             	mov    0xc(%eax),%eax
  8025c9:	85 c0                	test   %eax,%eax
  8025cb:	74 11                	je     8025de <free+0x4db>
  8025cd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025d0:	8b 40 0c             	mov    0xc(%eax),%eax
  8025d3:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8025d6:	8b 52 08             	mov    0x8(%edx),%edx
  8025d9:	89 50 08             	mov    %edx,0x8(%eax)
  8025dc:	eb 0b                	jmp    8025e9 <free+0x4e6>
  8025de:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025e1:	8b 40 08             	mov    0x8(%eax),%eax
  8025e4:	a3 20 e1 81 00       	mov    %eax,0x81e120
  8025e9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025ec:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  8025f3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025f6:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  8025fd:	a1 2c e1 81 00       	mov    0x81e12c,%eax
  802602:	48                   	dec    %eax
  802603:	a3 2c e1 81 00       	mov    %eax,0x81e12c
					mergenext = 1;
  802608:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
					break;
  80260f:	eb 13                	jmp    802624 <free+0x521>
				}
			}
			ToBeMerged = ToBeMerged->prev_next_info.le_next;
  802611:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802614:	8b 40 08             	mov    0x8(%eax),%eax
  802617:	89 45 ec             	mov    %eax,-0x14(%ebp)
		}


		//check if block is merged with prev ,and find possible merge with next
		ToBeMerged = LIST_FIRST(&u_freelist);
		while(ToBeMerged != NULL){
  80261a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80261e:	0f 85 79 fe ff ff    	jne    80249d <free+0x39a>




			// insertion
			struct UserHeapStruct* currentfree = LIST_FIRST(&u_freelist);
  802624:	a1 20 e1 81 00       	mov    0x81e120,%eax
  802629:	89 45 e0             	mov    %eax,-0x20(%ebp)

			if(mergeprev || mergenext){
  80262c:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802630:	0f 85 ad 00 00 00    	jne    8026e3 <free+0x5e0>
  802636:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80263a:	0f 84 c3 01 00 00    	je     802803 <free+0x700>
				while(currentfree != NULL){
  802640:	e9 9e 00 00 00       	jmp    8026e3 <free+0x5e0>
					if(MergedBlock->size < currentfree->size){
  802645:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802648:	8b 50 04             	mov    0x4(%eax),%edx
  80264b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80264e:	8b 40 04             	mov    0x4(%eax),%eax
  802651:	39 c2                	cmp    %eax,%edx
  802653:	0f 83 81 00 00 00    	jae    8026da <free+0x5d7>

							LIST_INSERT_BEFORE(&u_freelist,currentfree,MergedBlock);
  802659:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80265d:	74 06                	je     802665 <free+0x562>
  80265f:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  802663:	75 17                	jne    80267c <free+0x579>
  802665:	83 ec 04             	sub    $0x4,%esp
  802668:	68 bc 50 80 00       	push   $0x8050bc
  80266d:	68 23 01 00 00       	push   $0x123
  802672:	68 2c 50 80 00       	push   $0x80502c
  802677:	e8 a2 e2 ff ff       	call   80091e <_panic>
  80267c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80267f:	8b 50 0c             	mov    0xc(%eax),%edx
  802682:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802685:	89 50 0c             	mov    %edx,0xc(%eax)
  802688:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80268b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80268e:	89 50 08             	mov    %edx,0x8(%eax)
  802691:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802694:	8b 40 0c             	mov    0xc(%eax),%eax
  802697:	85 c0                	test   %eax,%eax
  802699:	74 0e                	je     8026a9 <free+0x5a6>
  80269b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80269e:	8b 40 0c             	mov    0xc(%eax),%eax
  8026a1:	8b 55 d0             	mov    -0x30(%ebp),%edx
  8026a4:	89 50 08             	mov    %edx,0x8(%eax)
  8026a7:	eb 08                	jmp    8026b1 <free+0x5ae>
  8026a9:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8026ac:	a3 20 e1 81 00       	mov    %eax,0x81e120
  8026b1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8026b4:	8b 55 d0             	mov    -0x30(%ebp),%edx
  8026b7:	89 50 0c             	mov    %edx,0xc(%eax)
  8026ba:	a1 2c e1 81 00       	mov    0x81e12c,%eax
  8026bf:	40                   	inc    %eax
  8026c0:	a3 2c e1 81 00       	mov    %eax,0x81e12c
							release_uspinlock(&ulock);
  8026c5:	83 ec 0c             	sub    $0xc,%esp
  8026c8:	68 40 e1 81 00       	push   $0x81e140
  8026cd:	e8 1f 1e 00 00       	call   8044f1 <release_uspinlock>
  8026d2:	83 c4 10             	add    $0x10,%esp
							return;
  8026d5:	e9 b7 01 00 00       	jmp    802891 <free+0x78e>
					}
							currentfree = currentfree->prev_next_info.le_next;
  8026da:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8026dd:	8b 40 08             	mov    0x8(%eax),%eax
  8026e0:	89 45 e0             	mov    %eax,-0x20(%ebp)

			// insertion
			struct UserHeapStruct* currentfree = LIST_FIRST(&u_freelist);

			if(mergeprev || mergenext){
				while(currentfree != NULL){
  8026e3:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8026e7:	0f 85 58 ff ff ff    	jne    802645 <free+0x542>
							release_uspinlock(&ulock);
							return;
					}
							currentfree = currentfree->prev_next_info.le_next;
				}
				free_block(newfree);
  8026ed:	83 ec 0c             	sub    $0xc,%esp
  8026f0:	ff 75 d4             	pushl  -0x2c(%ebp)
  8026f3:	e8 d5 19 00 00       	call   8040cd <free_block>
  8026f8:	83 c4 10             	add    $0x10,%esp
				LIST_INSERT_TAIL(&u_freelist,MergedBlock);
  8026fb:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  8026ff:	75 17                	jne    802718 <free+0x615>
  802701:	83 ec 04             	sub    $0x4,%esp
  802704:	68 78 50 80 00       	push   $0x805078
  802709:	68 2a 01 00 00       	push   $0x12a
  80270e:	68 2c 50 80 00       	push   $0x80502c
  802713:	e8 06 e2 ff ff       	call   80091e <_panic>
  802718:	8b 15 24 e1 81 00    	mov    0x81e124,%edx
  80271e:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802721:	89 50 0c             	mov    %edx,0xc(%eax)
  802724:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802727:	8b 40 0c             	mov    0xc(%eax),%eax
  80272a:	85 c0                	test   %eax,%eax
  80272c:	74 0d                	je     80273b <free+0x638>
  80272e:	a1 24 e1 81 00       	mov    0x81e124,%eax
  802733:	8b 55 d0             	mov    -0x30(%ebp),%edx
  802736:	89 50 08             	mov    %edx,0x8(%eax)
  802739:	eb 08                	jmp    802743 <free+0x640>
  80273b:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80273e:	a3 20 e1 81 00       	mov    %eax,0x81e120
  802743:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802746:	a3 24 e1 81 00       	mov    %eax,0x81e124
  80274b:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80274e:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802755:	a1 2c e1 81 00       	mov    0x81e12c,%eax
  80275a:	40                   	inc    %eax
  80275b:	a3 2c e1 81 00       	mov    %eax,0x81e12c
  802760:	e9 1b 01 00 00       	jmp    802880 <free+0x77d>

			}else{
				while(currentfree != NULL){
					if(newfree->size < currentfree->size){
  802765:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802768:	8b 50 04             	mov    0x4(%eax),%edx
  80276b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80276e:	8b 40 04             	mov    0x4(%eax),%eax
  802771:	39 c2                	cmp    %eax,%edx
  802773:	0f 83 81 00 00 00    	jae    8027fa <free+0x6f7>

							LIST_INSERT_BEFORE(&u_freelist,currentfree,newfree);
  802779:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80277d:	74 06                	je     802785 <free+0x682>
  80277f:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  802783:	75 17                	jne    80279c <free+0x699>
  802785:	83 ec 04             	sub    $0x4,%esp
  802788:	68 bc 50 80 00       	push   $0x8050bc
  80278d:	68 30 01 00 00       	push   $0x130
  802792:	68 2c 50 80 00       	push   $0x80502c
  802797:	e8 82 e1 ff ff       	call   80091e <_panic>
  80279c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80279f:	8b 50 0c             	mov    0xc(%eax),%edx
  8027a2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8027a5:	89 50 0c             	mov    %edx,0xc(%eax)
  8027a8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8027ab:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8027ae:	89 50 08             	mov    %edx,0x8(%eax)
  8027b1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8027b4:	8b 40 0c             	mov    0xc(%eax),%eax
  8027b7:	85 c0                	test   %eax,%eax
  8027b9:	74 0e                	je     8027c9 <free+0x6c6>
  8027bb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8027be:	8b 40 0c             	mov    0xc(%eax),%eax
  8027c1:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8027c4:	89 50 08             	mov    %edx,0x8(%eax)
  8027c7:	eb 08                	jmp    8027d1 <free+0x6ce>
  8027c9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8027cc:	a3 20 e1 81 00       	mov    %eax,0x81e120
  8027d1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8027d4:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8027d7:	89 50 0c             	mov    %edx,0xc(%eax)
  8027da:	a1 2c e1 81 00       	mov    0x81e12c,%eax
  8027df:	40                   	inc    %eax
  8027e0:	a3 2c e1 81 00       	mov    %eax,0x81e12c
							release_uspinlock(&ulock);
  8027e5:	83 ec 0c             	sub    $0xc,%esp
  8027e8:	68 40 e1 81 00       	push   $0x81e140
  8027ed:	e8 ff 1c 00 00       	call   8044f1 <release_uspinlock>
  8027f2:	83 c4 10             	add    $0x10,%esp
							return;
  8027f5:	e9 97 00 00 00       	jmp    802891 <free+0x78e>
					}
							currentfree = currentfree->prev_next_info.le_next;
  8027fa:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8027fd:	8b 40 08             	mov    0x8(%eax),%eax
  802800:	89 45 e0             	mov    %eax,-0x20(%ebp)
				}
				free_block(newfree);
				LIST_INSERT_TAIL(&u_freelist,MergedBlock);

			}else{
				while(currentfree != NULL){
  802803:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802807:	0f 85 58 ff ff ff    	jne    802765 <free+0x662>
							release_uspinlock(&ulock);
							return;
					}
							currentfree = currentfree->prev_next_info.le_next;
				}
				free_block(MergedBlock);
  80280d:	83 ec 0c             	sub    $0xc,%esp
  802810:	ff 75 d0             	pushl  -0x30(%ebp)
  802813:	e8 b5 18 00 00       	call   8040cd <free_block>
  802818:	83 c4 10             	add    $0x10,%esp
				LIST_INSERT_TAIL(&u_freelist,newfree);
  80281b:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80281f:	75 17                	jne    802838 <free+0x735>
  802821:	83 ec 04             	sub    $0x4,%esp
  802824:	68 78 50 80 00       	push   $0x805078
  802829:	68 37 01 00 00       	push   $0x137
  80282e:	68 2c 50 80 00       	push   $0x80502c
  802833:	e8 e6 e0 ff ff       	call   80091e <_panic>
  802838:	8b 15 24 e1 81 00    	mov    0x81e124,%edx
  80283e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802841:	89 50 0c             	mov    %edx,0xc(%eax)
  802844:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802847:	8b 40 0c             	mov    0xc(%eax),%eax
  80284a:	85 c0                	test   %eax,%eax
  80284c:	74 0d                	je     80285b <free+0x758>
  80284e:	a1 24 e1 81 00       	mov    0x81e124,%eax
  802853:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802856:	89 50 08             	mov    %edx,0x8(%eax)
  802859:	eb 08                	jmp    802863 <free+0x760>
  80285b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80285e:	a3 20 e1 81 00       	mov    %eax,0x81e120
  802863:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802866:	a3 24 e1 81 00       	mov    %eax,0x81e124
  80286b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80286e:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802875:	a1 2c e1 81 00       	mov    0x81e12c,%eax
  80287a:	40                   	inc    %eax
  80287b:	a3 2c e1 81 00       	mov    %eax,0x81e12c
			}
		release_uspinlock(&ulock);
  802880:	83 ec 0c             	sub    $0xc,%esp
  802883:	68 40 e1 81 00       	push   $0x81e140
  802888:	e8 64 1c 00 00       	call   8044f1 <release_uspinlock>
  80288d:	83 c4 10             	add    $0x10,%esp
		return;
  802890:	90                   	nop
}
  802891:	c9                   	leave  
  802892:	c3                   	ret    

00802893 <smalloc>:

//=================================
// [3] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  802893:	55                   	push   %ebp
  802894:	89 e5                	mov    %esp,%ebp
  802896:	83 ec 48             	sub    $0x48,%esp
  802899:	8b 45 10             	mov    0x10(%ebp),%eax
  80289c:	88 45 c4             	mov    %al,-0x3c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  80289f:	e8 2d f2 ff ff       	call   801ad1 <uheap_init>
	if (size == 0) return NULL;
  8028a4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8028a8:	75 0a                	jne    8028b4 <smalloc+0x21>
  8028aa:	b8 00 00 00 00       	mov    $0x0,%eax
  8028af:	e9 84 05 00 00       	jmp    802e38 <smalloc+0x5a5>
	//==============================================================
	acquire_uspinlock(&ulock);
  8028b4:	83 ec 0c             	sub    $0xc,%esp
  8028b7:	68 40 e1 81 00       	push   $0x81e140
  8028bc:	e8 d8 1b 00 00       	call   804499 <acquire_uspinlock>
  8028c1:	83 c4 10             	add    $0x10,%esp

	struct UserHeapStruct* allocblock = (struct UserHeapStruct*) alloc_block(sizeof(struct UserHeapStruct));
  8028c4:	83 ec 0c             	sub    $0xc,%esp
  8028c7:	6a 10                	push   $0x10
  8028c9:	e8 63 13 00 00       	call   803c31 <alloc_block>
  8028ce:	83 c4 10             	add    $0x10,%esp
  8028d1:	89 45 ec             	mov    %eax,-0x14(%ebp)
	if (allocblock == NULL){
  8028d4:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8028d8:	75 0a                	jne    8028e4 <smalloc+0x51>
				return NULL;
  8028da:	b8 00 00 00 00       	mov    $0x0,%eax
  8028df:	e9 54 05 00 00       	jmp    802e38 <smalloc+0x5a5>
	}
		size = ROUNDUP(size,PAGE_SIZE);
  8028e4:	c7 45 e8 00 10 00 00 	movl   $0x1000,-0x18(%ebp)
  8028eb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8028ee:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8028f1:	01 d0                	add    %edx,%eax
  8028f3:	48                   	dec    %eax
  8028f4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8028f7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8028fa:	ba 00 00 00 00       	mov    $0x0,%edx
  8028ff:	f7 75 e8             	divl   -0x18(%ebp)
  802902:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802905:	29 d0                	sub    %edx,%eax
  802907:	89 45 0c             	mov    %eax,0xc(%ebp)
		struct UserHeapStruct* lastfreeelement = LIST_LAST(&u_freelist);
  80290a:	a1 24 e1 81 00       	mov    0x81e124,%eax
  80290f:	89 45 e0             	mov    %eax,-0x20(%ebp)

		if(LIST_SIZE(&u_freelist)==0 || size>lastfreeelement->size){
  802912:	a1 2c e1 81 00       	mov    0x81e12c,%eax
  802917:	85 c0                	test   %eax,%eax
  802919:	74 0f                	je     80292a <smalloc+0x97>
  80291b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80291e:	8b 40 04             	mov    0x4(%eax),%eax
  802921:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802924:	0f 83 25 01 00 00    	jae    802a4f <smalloc+0x1bc>
				if(uheapPageAllocBreak <= USER_HEAP_MAX - size){
  80292a:	b8 00 00 00 a0       	mov    $0xa0000000,%eax
  80292f:	2b 45 0c             	sub    0xc(%ebp),%eax
  802932:	89 c2                	mov    %eax,%edx
  802934:	a1 68 e0 81 00       	mov    0x81e068,%eax
  802939:	39 c2                	cmp    %eax,%edx
  80293b:	0f 82 f4 00 00 00    	jb     802a35 <smalloc+0x1a2>
						uint32 requestedblockva = uheapPageAllocBreak;
  802941:	a1 68 e0 81 00       	mov    0x81e068,%eax
  802946:	89 45 d4             	mov    %eax,-0x2c(%ebp)
						uheapPageAllocBreak+=size;
  802949:	8b 15 68 e0 81 00    	mov    0x81e068,%edx
  80294f:	8b 45 0c             	mov    0xc(%ebp),%eax
  802952:	01 d0                	add    %edx,%eax
  802954:	a3 68 e0 81 00       	mov    %eax,0x81e068
						allocblock->startva = requestedblockva;
  802959:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80295c:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80295f:	89 10                	mov    %edx,(%eax)
						allocblock->size = size;
  802961:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802964:	8b 55 0c             	mov    0xc(%ebp),%edx
  802967:	89 50 04             	mov    %edx,0x4(%eax)

						LIST_INSERT_TAIL(&u_allocatedlist, allocblock);
  80296a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80296e:	75 17                	jne    802987 <smalloc+0xf4>
  802970:	83 ec 04             	sub    $0x4,%esp
  802973:	68 78 50 80 00       	push   $0x805078
  802978:	68 57 01 00 00       	push   $0x157
  80297d:	68 2c 50 80 00       	push   $0x80502c
  802982:	e8 97 df ff ff       	call   80091e <_panic>
  802987:	8b 15 34 e1 81 00    	mov    0x81e134,%edx
  80298d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802990:	89 50 0c             	mov    %edx,0xc(%eax)
  802993:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802996:	8b 40 0c             	mov    0xc(%eax),%eax
  802999:	85 c0                	test   %eax,%eax
  80299b:	74 0d                	je     8029aa <smalloc+0x117>
  80299d:	a1 34 e1 81 00       	mov    0x81e134,%eax
  8029a2:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8029a5:	89 50 08             	mov    %edx,0x8(%eax)
  8029a8:	eb 08                	jmp    8029b2 <smalloc+0x11f>
  8029aa:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029ad:	a3 30 e1 81 00       	mov    %eax,0x81e130
  8029b2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029b5:	a3 34 e1 81 00       	mov    %eax,0x81e134
  8029ba:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029bd:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  8029c4:	a1 3c e1 81 00       	mov    0x81e13c,%eax
  8029c9:	40                   	inc    %eax
  8029ca:	a3 3c e1 81 00       	mov    %eax,0x81e13c


						int result = sys_create_shared_object(sharedVarName ,size ,isWritable ,(void*)allocblock->startva);
  8029cf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029d2:	8b 00                	mov    (%eax),%eax
  8029d4:	89 c2                	mov    %eax,%edx
  8029d6:	0f b6 45 c4          	movzbl -0x3c(%ebp),%eax
  8029da:	52                   	push   %edx
  8029db:	50                   	push   %eax
  8029dc:	ff 75 0c             	pushl  0xc(%ebp)
  8029df:	ff 75 08             	pushl  0x8(%ebp)
  8029e2:	e8 48 0c 00 00       	call   80362f <sys_create_shared_object>
  8029e7:	83 c4 10             	add    $0x10,%esp
  8029ea:	89 45 d0             	mov    %eax,-0x30(%ebp)

						if(result <0){
  8029ed:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  8029f1:	79 28                	jns    802a1b <smalloc+0x188>
							free_block(allocblock);
  8029f3:	83 ec 0c             	sub    $0xc,%esp
  8029f6:	ff 75 ec             	pushl  -0x14(%ebp)
  8029f9:	e8 cf 16 00 00       	call   8040cd <free_block>
  8029fe:	83 c4 10             	add    $0x10,%esp
							release_uspinlock(&ulock);
  802a01:	83 ec 0c             	sub    $0xc,%esp
  802a04:	68 40 e1 81 00       	push   $0x81e140
  802a09:	e8 e3 1a 00 00       	call   8044f1 <release_uspinlock>
  802a0e:	83 c4 10             	add    $0x10,%esp
							return NULL;
  802a11:	b8 00 00 00 00       	mov    $0x0,%eax
  802a16:	e9 1d 04 00 00       	jmp    802e38 <smalloc+0x5a5>
						}
						release_uspinlock(&ulock);
  802a1b:	83 ec 0c             	sub    $0xc,%esp
  802a1e:	68 40 e1 81 00       	push   $0x81e140
  802a23:	e8 c9 1a 00 00       	call   8044f1 <release_uspinlock>
  802a28:	83 c4 10             	add    $0x10,%esp
						return (void*)allocblock -> startva;
  802a2b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a2e:	8b 00                	mov    (%eax),%eax
  802a30:	e9 03 04 00 00       	jmp    802e38 <smalloc+0x5a5>
				}else{
						release_uspinlock(&ulock);
  802a35:	83 ec 0c             	sub    $0xc,%esp
  802a38:	68 40 e1 81 00       	push   $0x81e140
  802a3d:	e8 af 1a 00 00       	call   8044f1 <release_uspinlock>
  802a42:	83 c4 10             	add    $0x10,%esp
						return NULL;
  802a45:	b8 00 00 00 00       	mov    $0x0,%eax
  802a4a:	e9 e9 03 00 00       	jmp    802e38 <smalloc+0x5a5>
					 }
		}else{
			//custom fit
			struct UserHeapStruct* currentfreeelement = LIST_FIRST(&u_freelist);
  802a4f:	a1 20 e1 81 00       	mov    0x81e120,%eax
  802a54:	89 45 f4             	mov    %eax,-0xc(%ebp)
			//worst fit
			while(currentfreeelement != NULL){
  802a57:	e9 af 03 00 00       	jmp    802e0b <smalloc+0x578>
				if(size<currentfreeelement->size){
  802a5c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a5f:	8b 40 04             	mov    0x4(%eax),%eax
  802a62:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802a65:	0f 86 28 02 00 00    	jbe    802c93 <smalloc+0x400>
					allocblock->startva = lastfreeelement->startva;
  802a6b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802a6e:	8b 10                	mov    (%eax),%edx
  802a70:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a73:	89 10                	mov    %edx,(%eax)
	                allocblock->size = size;
  802a75:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a78:	8b 55 0c             	mov    0xc(%ebp),%edx
  802a7b:	89 50 04             	mov    %edx,0x4(%eax)
	                LIST_INSERT_TAIL(&u_allocatedlist,allocblock);
  802a7e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802a82:	75 17                	jne    802a9b <smalloc+0x208>
  802a84:	83 ec 04             	sub    $0x4,%esp
  802a87:	68 78 50 80 00       	push   $0x805078
  802a8c:	68 6f 01 00 00       	push   $0x16f
  802a91:	68 2c 50 80 00       	push   $0x80502c
  802a96:	e8 83 de ff ff       	call   80091e <_panic>
  802a9b:	8b 15 34 e1 81 00    	mov    0x81e134,%edx
  802aa1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802aa4:	89 50 0c             	mov    %edx,0xc(%eax)
  802aa7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802aaa:	8b 40 0c             	mov    0xc(%eax),%eax
  802aad:	85 c0                	test   %eax,%eax
  802aaf:	74 0d                	je     802abe <smalloc+0x22b>
  802ab1:	a1 34 e1 81 00       	mov    0x81e134,%eax
  802ab6:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802ab9:	89 50 08             	mov    %edx,0x8(%eax)
  802abc:	eb 08                	jmp    802ac6 <smalloc+0x233>
  802abe:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ac1:	a3 30 e1 81 00       	mov    %eax,0x81e130
  802ac6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ac9:	a3 34 e1 81 00       	mov    %eax,0x81e134
  802ace:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ad1:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802ad8:	a1 3c e1 81 00       	mov    0x81e13c,%eax
  802add:	40                   	inc    %eax
  802ade:	a3 3c e1 81 00       	mov    %eax,0x81e13c
	                lastfreeelement->startva += size;
  802ae3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802ae6:	8b 10                	mov    (%eax),%edx
  802ae8:	8b 45 0c             	mov    0xc(%ebp),%eax
  802aeb:	01 c2                	add    %eax,%edx
  802aed:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802af0:	89 10                	mov    %edx,(%eax)
	                lastfreeelement->size -= size;
  802af2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802af5:	8b 40 04             	mov    0x4(%eax),%eax
  802af8:	2b 45 0c             	sub    0xc(%ebp),%eax
  802afb:	89 c2                	mov    %eax,%edx
  802afd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802b00:	89 50 04             	mov    %edx,0x4(%eax)
	                struct UserHeapStruct* currentfree2 = LIST_FIRST(&u_freelist);
  802b03:	a1 20 e1 81 00       	mov    0x81e120,%eax
  802b08:	89 45 f0             	mov    %eax,-0x10(%ebp)
	                //check order of last element

	                while (currentfree2 != NULL){
  802b0b:	e9 13 01 00 00       	jmp    802c23 <smalloc+0x390>
	                	if(lastfreeelement->size <currentfree2->size){
  802b10:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802b13:	8b 50 04             	mov    0x4(%eax),%edx
  802b16:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b19:	8b 40 04             	mov    0x4(%eax),%eax
  802b1c:	39 c2                	cmp    %eax,%edx
  802b1e:	0f 83 f6 00 00 00    	jae    802c1a <smalloc+0x387>
	                		LIST_REMOVE(&u_freelist ,lastfreeelement);
  802b24:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802b28:	75 17                	jne    802b41 <smalloc+0x2ae>
  802b2a:	83 ec 04             	sub    $0x4,%esp
  802b2d:	68 9b 50 80 00       	push   $0x80509b
  802b32:	68 77 01 00 00       	push   $0x177
  802b37:	68 2c 50 80 00       	push   $0x80502c
  802b3c:	e8 dd dd ff ff       	call   80091e <_panic>
  802b41:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802b44:	8b 40 08             	mov    0x8(%eax),%eax
  802b47:	85 c0                	test   %eax,%eax
  802b49:	74 11                	je     802b5c <smalloc+0x2c9>
  802b4b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802b4e:	8b 40 08             	mov    0x8(%eax),%eax
  802b51:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802b54:	8b 52 0c             	mov    0xc(%edx),%edx
  802b57:	89 50 0c             	mov    %edx,0xc(%eax)
  802b5a:	eb 0b                	jmp    802b67 <smalloc+0x2d4>
  802b5c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802b5f:	8b 40 0c             	mov    0xc(%eax),%eax
  802b62:	a3 24 e1 81 00       	mov    %eax,0x81e124
  802b67:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802b6a:	8b 40 0c             	mov    0xc(%eax),%eax
  802b6d:	85 c0                	test   %eax,%eax
  802b6f:	74 11                	je     802b82 <smalloc+0x2ef>
  802b71:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802b74:	8b 40 0c             	mov    0xc(%eax),%eax
  802b77:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802b7a:	8b 52 08             	mov    0x8(%edx),%edx
  802b7d:	89 50 08             	mov    %edx,0x8(%eax)
  802b80:	eb 0b                	jmp    802b8d <smalloc+0x2fa>
  802b82:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802b85:	8b 40 08             	mov    0x8(%eax),%eax
  802b88:	a3 20 e1 81 00       	mov    %eax,0x81e120
  802b8d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802b90:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802b97:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802b9a:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  802ba1:	a1 2c e1 81 00       	mov    0x81e12c,%eax
  802ba6:	48                   	dec    %eax
  802ba7:	a3 2c e1 81 00       	mov    %eax,0x81e12c
	                		LIST_INSERT_BEFORE(&u_freelist ,currentfree2 ,lastfreeelement);
  802bac:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802bb0:	74 06                	je     802bb8 <smalloc+0x325>
  802bb2:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802bb6:	75 17                	jne    802bcf <smalloc+0x33c>
  802bb8:	83 ec 04             	sub    $0x4,%esp
  802bbb:	68 bc 50 80 00       	push   $0x8050bc
  802bc0:	68 78 01 00 00       	push   $0x178
  802bc5:	68 2c 50 80 00       	push   $0x80502c
  802bca:	e8 4f dd ff ff       	call   80091e <_panic>
  802bcf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bd2:	8b 50 0c             	mov    0xc(%eax),%edx
  802bd5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802bd8:	89 50 0c             	mov    %edx,0xc(%eax)
  802bdb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802bde:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802be1:	89 50 08             	mov    %edx,0x8(%eax)
  802be4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802be7:	8b 40 0c             	mov    0xc(%eax),%eax
  802bea:	85 c0                	test   %eax,%eax
  802bec:	74 0e                	je     802bfc <smalloc+0x369>
  802bee:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bf1:	8b 40 0c             	mov    0xc(%eax),%eax
  802bf4:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802bf7:	89 50 08             	mov    %edx,0x8(%eax)
  802bfa:	eb 08                	jmp    802c04 <smalloc+0x371>
  802bfc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802bff:	a3 20 e1 81 00       	mov    %eax,0x81e120
  802c04:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c07:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802c0a:	89 50 0c             	mov    %edx,0xc(%eax)
  802c0d:	a1 2c e1 81 00       	mov    0x81e12c,%eax
  802c12:	40                   	inc    %eax
  802c13:	a3 2c e1 81 00       	mov    %eax,0x81e12c
	                		break;
  802c18:	eb 13                	jmp    802c2d <smalloc+0x39a>
	                	}
	                	currentfree2 = currentfree2->prev_next_info.le_next;
  802c1a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c1d:	8b 40 08             	mov    0x8(%eax),%eax
  802c20:	89 45 f0             	mov    %eax,-0x10(%ebp)
	                lastfreeelement->startva += size;
	                lastfreeelement->size -= size;
	                struct UserHeapStruct* currentfree2 = LIST_FIRST(&u_freelist);
	                //check order of last element

	                while (currentfree2 != NULL){
  802c23:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802c27:	0f 85 e3 fe ff ff    	jne    802b10 <smalloc+0x27d>
	                	}
	                	currentfree2 = currentfree2->prev_next_info.le_next;
	                }


	                int result = sys_create_shared_object(sharedVarName ,size ,isWritable ,(void*)allocblock->startva);
  802c2d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c30:	8b 00                	mov    (%eax),%eax
  802c32:	89 c2                	mov    %eax,%edx
  802c34:	0f b6 45 c4          	movzbl -0x3c(%ebp),%eax
  802c38:	52                   	push   %edx
  802c39:	50                   	push   %eax
  802c3a:	ff 75 0c             	pushl  0xc(%ebp)
  802c3d:	ff 75 08             	pushl  0x8(%ebp)
  802c40:	e8 ea 09 00 00       	call   80362f <sys_create_shared_object>
  802c45:	83 c4 10             	add    $0x10,%esp
  802c48:	89 45 d8             	mov    %eax,-0x28(%ebp)

	                if(result <0){
  802c4b:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  802c4f:	79 28                	jns    802c79 <smalloc+0x3e6>
	                	free_block(allocblock);
  802c51:	83 ec 0c             	sub    $0xc,%esp
  802c54:	ff 75 ec             	pushl  -0x14(%ebp)
  802c57:	e8 71 14 00 00       	call   8040cd <free_block>
  802c5c:	83 c4 10             	add    $0x10,%esp
	                	release_uspinlock(&ulock);
  802c5f:	83 ec 0c             	sub    $0xc,%esp
  802c62:	68 40 e1 81 00       	push   $0x81e140
  802c67:	e8 85 18 00 00       	call   8044f1 <release_uspinlock>
  802c6c:	83 c4 10             	add    $0x10,%esp
	                	return NULL;
  802c6f:	b8 00 00 00 00       	mov    $0x0,%eax
  802c74:	e9 bf 01 00 00       	jmp    802e38 <smalloc+0x5a5>
	                }
	                release_uspinlock(&ulock);
  802c79:	83 ec 0c             	sub    $0xc,%esp
  802c7c:	68 40 e1 81 00       	push   $0x81e140
  802c81:	e8 6b 18 00 00       	call   8044f1 <release_uspinlock>
  802c86:	83 c4 10             	add    $0x10,%esp
	                return (void*)allocblock->startva;
  802c89:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c8c:	8b 00                	mov    (%eax),%eax
  802c8e:	e9 a5 01 00 00       	jmp    802e38 <smalloc+0x5a5>
	                //exact fit
				}else if(size == currentfreeelement->size){
  802c93:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c96:	8b 40 04             	mov    0x4(%eax),%eax
  802c99:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802c9c:	0f 85 60 01 00 00    	jne    802e02 <smalloc+0x56f>
					allocblock->startva = currentfreeelement->startva;
  802ca2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ca5:	8b 10                	mov    (%eax),%edx
  802ca7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802caa:	89 10                	mov    %edx,(%eax)
					allocblock->size = size;
  802cac:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802caf:	8b 55 0c             	mov    0xc(%ebp),%edx
  802cb2:	89 50 04             	mov    %edx,0x4(%eax)
					LIST_INSERT_TAIL(&u_allocatedlist ,allocblock);
  802cb5:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802cb9:	75 17                	jne    802cd2 <smalloc+0x43f>
  802cbb:	83 ec 04             	sub    $0x4,%esp
  802cbe:	68 78 50 80 00       	push   $0x805078
  802cc3:	68 8c 01 00 00       	push   $0x18c
  802cc8:	68 2c 50 80 00       	push   $0x80502c
  802ccd:	e8 4c dc ff ff       	call   80091e <_panic>
  802cd2:	8b 15 34 e1 81 00    	mov    0x81e134,%edx
  802cd8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cdb:	89 50 0c             	mov    %edx,0xc(%eax)
  802cde:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ce1:	8b 40 0c             	mov    0xc(%eax),%eax
  802ce4:	85 c0                	test   %eax,%eax
  802ce6:	74 0d                	je     802cf5 <smalloc+0x462>
  802ce8:	a1 34 e1 81 00       	mov    0x81e134,%eax
  802ced:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802cf0:	89 50 08             	mov    %edx,0x8(%eax)
  802cf3:	eb 08                	jmp    802cfd <smalloc+0x46a>
  802cf5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cf8:	a3 30 e1 81 00       	mov    %eax,0x81e130
  802cfd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d00:	a3 34 e1 81 00       	mov    %eax,0x81e134
  802d05:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d08:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802d0f:	a1 3c e1 81 00       	mov    0x81e13c,%eax
  802d14:	40                   	inc    %eax
  802d15:	a3 3c e1 81 00       	mov    %eax,0x81e13c
					LIST_REMOVE(&u_freelist ,currentfreeelement);
  802d1a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d1e:	75 17                	jne    802d37 <smalloc+0x4a4>
  802d20:	83 ec 04             	sub    $0x4,%esp
  802d23:	68 9b 50 80 00       	push   $0x80509b
  802d28:	68 8d 01 00 00       	push   $0x18d
  802d2d:	68 2c 50 80 00       	push   $0x80502c
  802d32:	e8 e7 db ff ff       	call   80091e <_panic>
  802d37:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d3a:	8b 40 08             	mov    0x8(%eax),%eax
  802d3d:	85 c0                	test   %eax,%eax
  802d3f:	74 11                	je     802d52 <smalloc+0x4bf>
  802d41:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d44:	8b 40 08             	mov    0x8(%eax),%eax
  802d47:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d4a:	8b 52 0c             	mov    0xc(%edx),%edx
  802d4d:	89 50 0c             	mov    %edx,0xc(%eax)
  802d50:	eb 0b                	jmp    802d5d <smalloc+0x4ca>
  802d52:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d55:	8b 40 0c             	mov    0xc(%eax),%eax
  802d58:	a3 24 e1 81 00       	mov    %eax,0x81e124
  802d5d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d60:	8b 40 0c             	mov    0xc(%eax),%eax
  802d63:	85 c0                	test   %eax,%eax
  802d65:	74 11                	je     802d78 <smalloc+0x4e5>
  802d67:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d6a:	8b 40 0c             	mov    0xc(%eax),%eax
  802d6d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d70:	8b 52 08             	mov    0x8(%edx),%edx
  802d73:	89 50 08             	mov    %edx,0x8(%eax)
  802d76:	eb 0b                	jmp    802d83 <smalloc+0x4f0>
  802d78:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d7b:	8b 40 08             	mov    0x8(%eax),%eax
  802d7e:	a3 20 e1 81 00       	mov    %eax,0x81e120
  802d83:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d86:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802d8d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d90:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  802d97:	a1 2c e1 81 00       	mov    0x81e12c,%eax
  802d9c:	48                   	dec    %eax
  802d9d:	a3 2c e1 81 00       	mov    %eax,0x81e12c
					int result = sys_create_shared_object(sharedVarName ,size ,isWritable ,(void*)allocblock->startva);
  802da2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802da5:	8b 00                	mov    (%eax),%eax
  802da7:	89 c2                	mov    %eax,%edx
  802da9:	0f b6 45 c4          	movzbl -0x3c(%ebp),%eax
  802dad:	52                   	push   %edx
  802dae:	50                   	push   %eax
  802daf:	ff 75 0c             	pushl  0xc(%ebp)
  802db2:	ff 75 08             	pushl  0x8(%ebp)
  802db5:	e8 75 08 00 00       	call   80362f <sys_create_shared_object>
  802dba:	83 c4 10             	add    $0x10,%esp
  802dbd:	89 45 dc             	mov    %eax,-0x24(%ebp)

					if(result <0){
  802dc0:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802dc4:	79 25                	jns    802deb <smalloc+0x558>
						free_block(allocblock);
  802dc6:	83 ec 0c             	sub    $0xc,%esp
  802dc9:	ff 75 ec             	pushl  -0x14(%ebp)
  802dcc:	e8 fc 12 00 00       	call   8040cd <free_block>
  802dd1:	83 c4 10             	add    $0x10,%esp
						release_uspinlock(&ulock);
  802dd4:	83 ec 0c             	sub    $0xc,%esp
  802dd7:	68 40 e1 81 00       	push   $0x81e140
  802ddc:	e8 10 17 00 00       	call   8044f1 <release_uspinlock>
  802de1:	83 c4 10             	add    $0x10,%esp
						return NULL;
  802de4:	b8 00 00 00 00       	mov    $0x0,%eax
  802de9:	eb 4d                	jmp    802e38 <smalloc+0x5a5>
					}
					release_uspinlock(&ulock);
  802deb:	83 ec 0c             	sub    $0xc,%esp
  802dee:	68 40 e1 81 00       	push   $0x81e140
  802df3:	e8 f9 16 00 00       	call   8044f1 <release_uspinlock>
  802df8:	83 c4 10             	add    $0x10,%esp
					return (void*)allocblock->startva;
  802dfb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802dfe:	8b 00                	mov    (%eax),%eax
  802e00:	eb 36                	jmp    802e38 <smalloc+0x5a5>
				}
				currentfreeelement = currentfreeelement->prev_next_info.le_next;
  802e02:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e05:	8b 40 08             	mov    0x8(%eax),%eax
  802e08:	89 45 f4             	mov    %eax,-0xc(%ebp)
					 }
		}else{
			//custom fit
			struct UserHeapStruct* currentfreeelement = LIST_FIRST(&u_freelist);
			//worst fit
			while(currentfreeelement != NULL){
  802e0b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e0f:	0f 85 47 fc ff ff    	jne    802a5c <smalloc+0x1c9>
					return (void*)allocblock->startva;
				}
				currentfreeelement = currentfreeelement->prev_next_info.le_next;
			}
		}
		free_block(allocblock);
  802e15:	83 ec 0c             	sub    $0xc,%esp
  802e18:	ff 75 ec             	pushl  -0x14(%ebp)
  802e1b:	e8 ad 12 00 00       	call   8040cd <free_block>
  802e20:	83 c4 10             	add    $0x10,%esp
		release_uspinlock(&ulock);
  802e23:	83 ec 0c             	sub    $0xc,%esp
  802e26:	68 40 e1 81 00       	push   $0x81e140
  802e2b:	e8 c1 16 00 00       	call   8044f1 <release_uspinlock>
  802e30:	83 c4 10             	add    $0x10,%esp
		return NULL;
  802e33:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802e38:	c9                   	leave  
  802e39:	c3                   	ret    

00802e3a <sget>:

//========================================
// [4] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  802e3a:	55                   	push   %ebp
  802e3b:	89 e5                	mov    %esp,%ebp
  802e3d:	83 ec 38             	sub    $0x38,%esp


	 //==============================================================
	 // DON'T CHANGE THIS CODE
	    uheap_init();
  802e40:	e8 8c ec ff ff       	call   801ad1 <uheap_init>
	 //==============================================================
	 // Get size of the shared variable from kernel
	acquire_uspinlock(&ulock);
  802e45:	83 ec 0c             	sub    $0xc,%esp
  802e48:	68 40 e1 81 00       	push   $0x81e140
  802e4d:	e8 47 16 00 00       	call   804499 <acquire_uspinlock>
  802e52:	83 c4 10             	add    $0x10,%esp


	int size = sys_size_of_shared_object(ownerEnvID ,sharedVarName);
  802e55:	83 ec 08             	sub    $0x8,%esp
  802e58:	ff 75 0c             	pushl  0xc(%ebp)
  802e5b:	ff 75 08             	pushl  0x8(%ebp)
  802e5e:	e8 f6 07 00 00       	call   803659 <sys_size_of_shared_object>
  802e63:	83 c4 10             	add    $0x10,%esp
  802e66:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if ( size < 0 ){
  802e69:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802e6d:	79 1a                	jns    802e89 <sget+0x4f>
			release_uspinlock(&ulock);
  802e6f:	83 ec 0c             	sub    $0xc,%esp
  802e72:	68 40 e1 81 00       	push   $0x81e140
  802e77:	e8 75 16 00 00       	call   8044f1 <release_uspinlock>
  802e7c:	83 c4 10             	add    $0x10,%esp
			return NULL;
  802e7f:	b8 00 00 00 00       	mov    $0x0,%eax
  802e84:	e9 6e 05 00 00       	jmp    8033f7 <sget+0x5bd>
		}
		size = ROUNDUP(size,PAGE_SIZE);
  802e89:	c7 45 e8 00 10 00 00 	movl   $0x1000,-0x18(%ebp)
  802e90:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802e93:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e96:	01 d0                	add    %edx,%eax
  802e98:	48                   	dec    %eax
  802e99:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  802e9c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e9f:	ba 00 00 00 00       	mov    $0x0,%edx
  802ea4:	f7 75 e8             	divl   -0x18(%ebp)
  802ea7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802eaa:	29 d0                	sub    %edx,%eax
  802eac:	89 45 ec             	mov    %eax,-0x14(%ebp)

		struct UserHeapStruct* allocblock = (struct UserHeapStruct*) alloc_block(sizeof(struct UserHeapStruct));
  802eaf:	83 ec 0c             	sub    $0xc,%esp
  802eb2:	6a 10                	push   $0x10
  802eb4:	e8 78 0d 00 00       	call   803c31 <alloc_block>
  802eb9:	83 c4 10             	add    $0x10,%esp
  802ebc:	89 45 e0             	mov    %eax,-0x20(%ebp)

		if (allocblock == NULL){
  802ebf:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802ec3:	75 0a                	jne    802ecf <sget+0x95>
			return NULL;
  802ec5:	b8 00 00 00 00       	mov    $0x0,%eax
  802eca:	e9 28 05 00 00       	jmp    8033f7 <sget+0x5bd>
		}
		struct UserHeapStruct* lastfreeelement = LIST_LAST(&u_freelist);
  802ecf:	a1 24 e1 81 00       	mov    0x81e124,%eax
  802ed4:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if(LIST_SIZE(&u_freelist)==0 || size>lastfreeelement->size){
  802ed7:	a1 2c e1 81 00       	mov    0x81e12c,%eax
  802edc:	85 c0                	test   %eax,%eax
  802ede:	74 11                	je     802ef1 <sget+0xb7>
  802ee0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802ee3:	8b 50 04             	mov    0x4(%eax),%edx
  802ee6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ee9:	39 c2                	cmp    %eax,%edx
  802eeb:	0f 83 21 01 00 00    	jae    803012 <sget+0x1d8>
				if(uheapPageAllocBreak <= USER_HEAP_MAX - size){
  802ef1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ef4:	ba 00 00 00 a0       	mov    $0xa0000000,%edx
  802ef9:	29 c2                	sub    %eax,%edx
  802efb:	a1 68 e0 81 00       	mov    0x81e068,%eax
  802f00:	39 c2                	cmp    %eax,%edx
  802f02:	0f 82 f0 00 00 00    	jb     802ff8 <sget+0x1be>

						uint32 requestedblockva = uheapPageAllocBreak;
  802f08:	a1 68 e0 81 00       	mov    0x81e068,%eax
  802f0d:	89 45 d0             	mov    %eax,-0x30(%ebp)
						uheapPageAllocBreak+=size;
  802f10:	8b 15 68 e0 81 00    	mov    0x81e068,%edx
  802f16:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f19:	01 d0                	add    %edx,%eax
  802f1b:	a3 68 e0 81 00       	mov    %eax,0x81e068
						allocblock->startva = requestedblockva;
  802f20:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802f23:	8b 55 d0             	mov    -0x30(%ebp),%edx
  802f26:	89 10                	mov    %edx,(%eax)
						allocblock->size = size;
  802f28:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802f2b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802f2e:	89 50 04             	mov    %edx,0x4(%eax)

						LIST_INSERT_TAIL(&u_allocatedlist, allocblock);
  802f31:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802f35:	75 17                	jne    802f4e <sget+0x114>
  802f37:	83 ec 04             	sub    $0x4,%esp
  802f3a:	68 78 50 80 00       	push   $0x805078
  802f3f:	68 c8 01 00 00       	push   $0x1c8
  802f44:	68 2c 50 80 00       	push   $0x80502c
  802f49:	e8 d0 d9 ff ff       	call   80091e <_panic>
  802f4e:	8b 15 34 e1 81 00    	mov    0x81e134,%edx
  802f54:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802f57:	89 50 0c             	mov    %edx,0xc(%eax)
  802f5a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802f5d:	8b 40 0c             	mov    0xc(%eax),%eax
  802f60:	85 c0                	test   %eax,%eax
  802f62:	74 0d                	je     802f71 <sget+0x137>
  802f64:	a1 34 e1 81 00       	mov    0x81e134,%eax
  802f69:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802f6c:	89 50 08             	mov    %edx,0x8(%eax)
  802f6f:	eb 08                	jmp    802f79 <sget+0x13f>
  802f71:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802f74:	a3 30 e1 81 00       	mov    %eax,0x81e130
  802f79:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802f7c:	a3 34 e1 81 00       	mov    %eax,0x81e134
  802f81:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802f84:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802f8b:	a1 3c e1 81 00       	mov    0x81e13c,%eax
  802f90:	40                   	inc    %eax
  802f91:	a3 3c e1 81 00       	mov    %eax,0x81e13c


						int result = sys_get_shared_object(ownerEnvID ,sharedVarName ,(void*)allocblock->startva);
  802f96:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802f99:	8b 00                	mov    (%eax),%eax
  802f9b:	83 ec 04             	sub    $0x4,%esp
  802f9e:	50                   	push   %eax
  802f9f:	ff 75 0c             	pushl  0xc(%ebp)
  802fa2:	ff 75 08             	pushl  0x8(%ebp)
  802fa5:	e8 cc 06 00 00       	call   803676 <sys_get_shared_object>
  802faa:	83 c4 10             	add    $0x10,%esp
  802fad:	89 45 cc             	mov    %eax,-0x34(%ebp)

						if(result <0){
  802fb0:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802fb4:	79 28                	jns    802fde <sget+0x1a4>
							free_block(allocblock);
  802fb6:	83 ec 0c             	sub    $0xc,%esp
  802fb9:	ff 75 e0             	pushl  -0x20(%ebp)
  802fbc:	e8 0c 11 00 00       	call   8040cd <free_block>
  802fc1:	83 c4 10             	add    $0x10,%esp
							release_uspinlock(&ulock);
  802fc4:	83 ec 0c             	sub    $0xc,%esp
  802fc7:	68 40 e1 81 00       	push   $0x81e140
  802fcc:	e8 20 15 00 00       	call   8044f1 <release_uspinlock>
  802fd1:	83 c4 10             	add    $0x10,%esp
							return NULL;
  802fd4:	b8 00 00 00 00       	mov    $0x0,%eax
  802fd9:	e9 19 04 00 00       	jmp    8033f7 <sget+0x5bd>
						}
						release_uspinlock(&ulock);
  802fde:	83 ec 0c             	sub    $0xc,%esp
  802fe1:	68 40 e1 81 00       	push   $0x81e140
  802fe6:	e8 06 15 00 00       	call   8044f1 <release_uspinlock>
  802feb:	83 c4 10             	add    $0x10,%esp
						return (void*)allocblock -> startva;
  802fee:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802ff1:	8b 00                	mov    (%eax),%eax
  802ff3:	e9 ff 03 00 00       	jmp    8033f7 <sget+0x5bd>
				}else{
						release_uspinlock(&ulock);
  802ff8:	83 ec 0c             	sub    $0xc,%esp
  802ffb:	68 40 e1 81 00       	push   $0x81e140
  803000:	e8 ec 14 00 00       	call   8044f1 <release_uspinlock>
  803005:	83 c4 10             	add    $0x10,%esp
						return NULL;
  803008:	b8 00 00 00 00       	mov    $0x0,%eax
  80300d:	e9 e5 03 00 00       	jmp    8033f7 <sget+0x5bd>
					 }
		}else{
			//custom fit
			struct UserHeapStruct* currentfreeelement = LIST_FIRST(&u_freelist);
  803012:	a1 20 e1 81 00       	mov    0x81e120,%eax
  803017:	89 45 f4             	mov    %eax,-0xc(%ebp)
			//worst fit
			while(currentfreeelement != NULL){
  80301a:	e9 ab 03 00 00       	jmp    8033ca <sget+0x590>
				if(size<currentfreeelement->size){
  80301f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803022:	8b 50 04             	mov    0x4(%eax),%edx
  803025:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803028:	39 c2                	cmp    %eax,%edx
  80302a:	0f 86 24 02 00 00    	jbe    803254 <sget+0x41a>
					allocblock->startva = lastfreeelement->startva;
  803030:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803033:	8b 10                	mov    (%eax),%edx
  803035:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803038:	89 10                	mov    %edx,(%eax)
					allocblock->size = size;
  80303a:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80303d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803040:	89 50 04             	mov    %edx,0x4(%eax)
					LIST_INSERT_TAIL(&u_allocatedlist,allocblock);
  803043:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  803047:	75 17                	jne    803060 <sget+0x226>
  803049:	83 ec 04             	sub    $0x4,%esp
  80304c:	68 78 50 80 00       	push   $0x805078
  803051:	68 e0 01 00 00       	push   $0x1e0
  803056:	68 2c 50 80 00       	push   $0x80502c
  80305b:	e8 be d8 ff ff       	call   80091e <_panic>
  803060:	8b 15 34 e1 81 00    	mov    0x81e134,%edx
  803066:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803069:	89 50 0c             	mov    %edx,0xc(%eax)
  80306c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80306f:	8b 40 0c             	mov    0xc(%eax),%eax
  803072:	85 c0                	test   %eax,%eax
  803074:	74 0d                	je     803083 <sget+0x249>
  803076:	a1 34 e1 81 00       	mov    0x81e134,%eax
  80307b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80307e:	89 50 08             	mov    %edx,0x8(%eax)
  803081:	eb 08                	jmp    80308b <sget+0x251>
  803083:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803086:	a3 30 e1 81 00       	mov    %eax,0x81e130
  80308b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80308e:	a3 34 e1 81 00       	mov    %eax,0x81e134
  803093:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803096:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  80309d:	a1 3c e1 81 00       	mov    0x81e13c,%eax
  8030a2:	40                   	inc    %eax
  8030a3:	a3 3c e1 81 00       	mov    %eax,0x81e13c
					lastfreeelement->startva += size;
  8030a8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8030ab:	8b 10                	mov    (%eax),%edx
  8030ad:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030b0:	01 c2                	add    %eax,%edx
  8030b2:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8030b5:	89 10                	mov    %edx,(%eax)
					lastfreeelement->size -= size;
  8030b7:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8030ba:	8b 50 04             	mov    0x4(%eax),%edx
  8030bd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030c0:	29 c2                	sub    %eax,%edx
  8030c2:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8030c5:	89 50 04             	mov    %edx,0x4(%eax)
					struct UserHeapStruct* currentfree2 = LIST_FIRST(&u_freelist);
  8030c8:	a1 20 e1 81 00       	mov    0x81e120,%eax
  8030cd:	89 45 f0             	mov    %eax,-0x10(%ebp)
					//check order of last element

					while (currentfree2 != NULL){
  8030d0:	e9 13 01 00 00       	jmp    8031e8 <sget+0x3ae>
						if(lastfreeelement->size <currentfree2->size){
  8030d5:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8030d8:	8b 50 04             	mov    0x4(%eax),%edx
  8030db:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030de:	8b 40 04             	mov    0x4(%eax),%eax
  8030e1:	39 c2                	cmp    %eax,%edx
  8030e3:	0f 83 f6 00 00 00    	jae    8031df <sget+0x3a5>
							LIST_REMOVE(&u_freelist ,lastfreeelement);
  8030e9:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8030ed:	75 17                	jne    803106 <sget+0x2cc>
  8030ef:	83 ec 04             	sub    $0x4,%esp
  8030f2:	68 9b 50 80 00       	push   $0x80509b
  8030f7:	68 e8 01 00 00       	push   $0x1e8
  8030fc:	68 2c 50 80 00       	push   $0x80502c
  803101:	e8 18 d8 ff ff       	call   80091e <_panic>
  803106:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803109:	8b 40 08             	mov    0x8(%eax),%eax
  80310c:	85 c0                	test   %eax,%eax
  80310e:	74 11                	je     803121 <sget+0x2e7>
  803110:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803113:	8b 40 08             	mov    0x8(%eax),%eax
  803116:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803119:	8b 52 0c             	mov    0xc(%edx),%edx
  80311c:	89 50 0c             	mov    %edx,0xc(%eax)
  80311f:	eb 0b                	jmp    80312c <sget+0x2f2>
  803121:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803124:	8b 40 0c             	mov    0xc(%eax),%eax
  803127:	a3 24 e1 81 00       	mov    %eax,0x81e124
  80312c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80312f:	8b 40 0c             	mov    0xc(%eax),%eax
  803132:	85 c0                	test   %eax,%eax
  803134:	74 11                	je     803147 <sget+0x30d>
  803136:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803139:	8b 40 0c             	mov    0xc(%eax),%eax
  80313c:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80313f:	8b 52 08             	mov    0x8(%edx),%edx
  803142:	89 50 08             	mov    %edx,0x8(%eax)
  803145:	eb 0b                	jmp    803152 <sget+0x318>
  803147:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80314a:	8b 40 08             	mov    0x8(%eax),%eax
  80314d:	a3 20 e1 81 00       	mov    %eax,0x81e120
  803152:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803155:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  80315c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80315f:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  803166:	a1 2c e1 81 00       	mov    0x81e12c,%eax
  80316b:	48                   	dec    %eax
  80316c:	a3 2c e1 81 00       	mov    %eax,0x81e12c
							LIST_INSERT_BEFORE(&u_freelist ,currentfree2 ,lastfreeelement);
  803171:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803175:	74 06                	je     80317d <sget+0x343>
  803177:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80317b:	75 17                	jne    803194 <sget+0x35a>
  80317d:	83 ec 04             	sub    $0x4,%esp
  803180:	68 bc 50 80 00       	push   $0x8050bc
  803185:	68 e9 01 00 00       	push   $0x1e9
  80318a:	68 2c 50 80 00       	push   $0x80502c
  80318f:	e8 8a d7 ff ff       	call   80091e <_panic>
  803194:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803197:	8b 50 0c             	mov    0xc(%eax),%edx
  80319a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80319d:	89 50 0c             	mov    %edx,0xc(%eax)
  8031a0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8031a3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8031a6:	89 50 08             	mov    %edx,0x8(%eax)
  8031a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031ac:	8b 40 0c             	mov    0xc(%eax),%eax
  8031af:	85 c0                	test   %eax,%eax
  8031b1:	74 0e                	je     8031c1 <sget+0x387>
  8031b3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031b6:	8b 40 0c             	mov    0xc(%eax),%eax
  8031b9:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8031bc:	89 50 08             	mov    %edx,0x8(%eax)
  8031bf:	eb 08                	jmp    8031c9 <sget+0x38f>
  8031c1:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8031c4:	a3 20 e1 81 00       	mov    %eax,0x81e120
  8031c9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031cc:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8031cf:	89 50 0c             	mov    %edx,0xc(%eax)
  8031d2:	a1 2c e1 81 00       	mov    0x81e12c,%eax
  8031d7:	40                   	inc    %eax
  8031d8:	a3 2c e1 81 00       	mov    %eax,0x81e12c
							break;
  8031dd:	eb 13                	jmp    8031f2 <sget+0x3b8>
						}
						currentfree2 = currentfree2->prev_next_info.le_next;
  8031df:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031e2:	8b 40 08             	mov    0x8(%eax),%eax
  8031e5:	89 45 f0             	mov    %eax,-0x10(%ebp)
					lastfreeelement->startva += size;
					lastfreeelement->size -= size;
					struct UserHeapStruct* currentfree2 = LIST_FIRST(&u_freelist);
					//check order of last element

					while (currentfree2 != NULL){
  8031e8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8031ec:	0f 85 e3 fe ff ff    	jne    8030d5 <sget+0x29b>
						}
						currentfree2 = currentfree2->prev_next_info.le_next;
					}


					int result = sys_get_shared_object(ownerEnvID ,sharedVarName ,(void*)allocblock->startva);
  8031f2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8031f5:	8b 00                	mov    (%eax),%eax
  8031f7:	83 ec 04             	sub    $0x4,%esp
  8031fa:	50                   	push   %eax
  8031fb:	ff 75 0c             	pushl  0xc(%ebp)
  8031fe:	ff 75 08             	pushl  0x8(%ebp)
  803201:	e8 70 04 00 00       	call   803676 <sys_get_shared_object>
  803206:	83 c4 10             	add    $0x10,%esp
  803209:	89 45 d4             	mov    %eax,-0x2c(%ebp)

					if(result <0){
  80320c:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803210:	79 28                	jns    80323a <sget+0x400>
						free_block(allocblock);
  803212:	83 ec 0c             	sub    $0xc,%esp
  803215:	ff 75 e0             	pushl  -0x20(%ebp)
  803218:	e8 b0 0e 00 00       	call   8040cd <free_block>
  80321d:	83 c4 10             	add    $0x10,%esp
						release_uspinlock(&ulock);
  803220:	83 ec 0c             	sub    $0xc,%esp
  803223:	68 40 e1 81 00       	push   $0x81e140
  803228:	e8 c4 12 00 00       	call   8044f1 <release_uspinlock>
  80322d:	83 c4 10             	add    $0x10,%esp
						return NULL;
  803230:	b8 00 00 00 00       	mov    $0x0,%eax
  803235:	e9 bd 01 00 00       	jmp    8033f7 <sget+0x5bd>
					}
					release_uspinlock(&ulock);
  80323a:	83 ec 0c             	sub    $0xc,%esp
  80323d:	68 40 e1 81 00       	push   $0x81e140
  803242:	e8 aa 12 00 00       	call   8044f1 <release_uspinlock>
  803247:	83 c4 10             	add    $0x10,%esp
					return (void*)allocblock->startva;
  80324a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80324d:	8b 00                	mov    (%eax),%eax
  80324f:	e9 a3 01 00 00       	jmp    8033f7 <sget+0x5bd>
					//exact fit
				}else if(size == currentfreeelement->size){
  803254:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803257:	8b 50 04             	mov    0x4(%eax),%edx
  80325a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80325d:	39 c2                	cmp    %eax,%edx
  80325f:	0f 85 5c 01 00 00    	jne    8033c1 <sget+0x587>

					allocblock->startva = currentfreeelement->startva;
  803265:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803268:	8b 10                	mov    (%eax),%edx
  80326a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80326d:	89 10                	mov    %edx,(%eax)
					allocblock->size = size;
  80326f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803272:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803275:	89 50 04             	mov    %edx,0x4(%eax)
					LIST_INSERT_TAIL(&u_allocatedlist ,allocblock);
  803278:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80327c:	75 17                	jne    803295 <sget+0x45b>
  80327e:	83 ec 04             	sub    $0x4,%esp
  803281:	68 78 50 80 00       	push   $0x805078
  803286:	68 fe 01 00 00       	push   $0x1fe
  80328b:	68 2c 50 80 00       	push   $0x80502c
  803290:	e8 89 d6 ff ff       	call   80091e <_panic>
  803295:	8b 15 34 e1 81 00    	mov    0x81e134,%edx
  80329b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80329e:	89 50 0c             	mov    %edx,0xc(%eax)
  8032a1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8032a4:	8b 40 0c             	mov    0xc(%eax),%eax
  8032a7:	85 c0                	test   %eax,%eax
  8032a9:	74 0d                	je     8032b8 <sget+0x47e>
  8032ab:	a1 34 e1 81 00       	mov    0x81e134,%eax
  8032b0:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8032b3:	89 50 08             	mov    %edx,0x8(%eax)
  8032b6:	eb 08                	jmp    8032c0 <sget+0x486>
  8032b8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8032bb:	a3 30 e1 81 00       	mov    %eax,0x81e130
  8032c0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8032c3:	a3 34 e1 81 00       	mov    %eax,0x81e134
  8032c8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8032cb:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  8032d2:	a1 3c e1 81 00       	mov    0x81e13c,%eax
  8032d7:	40                   	inc    %eax
  8032d8:	a3 3c e1 81 00       	mov    %eax,0x81e13c
					LIST_REMOVE(&u_freelist ,currentfreeelement);
  8032dd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8032e1:	75 17                	jne    8032fa <sget+0x4c0>
  8032e3:	83 ec 04             	sub    $0x4,%esp
  8032e6:	68 9b 50 80 00       	push   $0x80509b
  8032eb:	68 ff 01 00 00       	push   $0x1ff
  8032f0:	68 2c 50 80 00       	push   $0x80502c
  8032f5:	e8 24 d6 ff ff       	call   80091e <_panic>
  8032fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032fd:	8b 40 08             	mov    0x8(%eax),%eax
  803300:	85 c0                	test   %eax,%eax
  803302:	74 11                	je     803315 <sget+0x4db>
  803304:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803307:	8b 40 08             	mov    0x8(%eax),%eax
  80330a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80330d:	8b 52 0c             	mov    0xc(%edx),%edx
  803310:	89 50 0c             	mov    %edx,0xc(%eax)
  803313:	eb 0b                	jmp    803320 <sget+0x4e6>
  803315:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803318:	8b 40 0c             	mov    0xc(%eax),%eax
  80331b:	a3 24 e1 81 00       	mov    %eax,0x81e124
  803320:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803323:	8b 40 0c             	mov    0xc(%eax),%eax
  803326:	85 c0                	test   %eax,%eax
  803328:	74 11                	je     80333b <sget+0x501>
  80332a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80332d:	8b 40 0c             	mov    0xc(%eax),%eax
  803330:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803333:	8b 52 08             	mov    0x8(%edx),%edx
  803336:	89 50 08             	mov    %edx,0x8(%eax)
  803339:	eb 0b                	jmp    803346 <sget+0x50c>
  80333b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80333e:	8b 40 08             	mov    0x8(%eax),%eax
  803341:	a3 20 e1 81 00       	mov    %eax,0x81e120
  803346:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803349:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  803350:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803353:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  80335a:	a1 2c e1 81 00       	mov    0x81e12c,%eax
  80335f:	48                   	dec    %eax
  803360:	a3 2c e1 81 00       	mov    %eax,0x81e12c

					int result = sys_get_shared_object(ownerEnvID ,sharedVarName ,(void*)allocblock->startva);
  803365:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803368:	8b 00                	mov    (%eax),%eax
  80336a:	83 ec 04             	sub    $0x4,%esp
  80336d:	50                   	push   %eax
  80336e:	ff 75 0c             	pushl  0xc(%ebp)
  803371:	ff 75 08             	pushl  0x8(%ebp)
  803374:	e8 fd 02 00 00       	call   803676 <sys_get_shared_object>
  803379:	83 c4 10             	add    $0x10,%esp
  80337c:	89 45 d8             	mov    %eax,-0x28(%ebp)
					if(result <0){
  80337f:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  803383:	79 25                	jns    8033aa <sget+0x570>
						free_block(allocblock);
  803385:	83 ec 0c             	sub    $0xc,%esp
  803388:	ff 75 e0             	pushl  -0x20(%ebp)
  80338b:	e8 3d 0d 00 00       	call   8040cd <free_block>
  803390:	83 c4 10             	add    $0x10,%esp
						release_uspinlock(&ulock);
  803393:	83 ec 0c             	sub    $0xc,%esp
  803396:	68 40 e1 81 00       	push   $0x81e140
  80339b:	e8 51 11 00 00       	call   8044f1 <release_uspinlock>
  8033a0:	83 c4 10             	add    $0x10,%esp
						return NULL;
  8033a3:	b8 00 00 00 00       	mov    $0x0,%eax
  8033a8:	eb 4d                	jmp    8033f7 <sget+0x5bd>
					}

					release_uspinlock(&ulock);
  8033aa:	83 ec 0c             	sub    $0xc,%esp
  8033ad:	68 40 e1 81 00       	push   $0x81e140
  8033b2:	e8 3a 11 00 00       	call   8044f1 <release_uspinlock>
  8033b7:	83 c4 10             	add    $0x10,%esp
					return (void*)allocblock->startva;
  8033ba:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8033bd:	8b 00                	mov    (%eax),%eax
  8033bf:	eb 36                	jmp    8033f7 <sget+0x5bd>
				}
				currentfreeelement = currentfreeelement->prev_next_info.le_next;
  8033c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033c4:	8b 40 08             	mov    0x8(%eax),%eax
  8033c7:	89 45 f4             	mov    %eax,-0xc(%ebp)
					 }
		}else{
			//custom fit
			struct UserHeapStruct* currentfreeelement = LIST_FIRST(&u_freelist);
			//worst fit
			while(currentfreeelement != NULL){
  8033ca:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8033ce:	0f 85 4b fc ff ff    	jne    80301f <sget+0x1e5>
					return (void*)allocblock->startva;
				}
				currentfreeelement = currentfreeelement->prev_next_info.le_next;
			}
		}
		free_block(allocblock);
  8033d4:	83 ec 0c             	sub    $0xc,%esp
  8033d7:	ff 75 e0             	pushl  -0x20(%ebp)
  8033da:	e8 ee 0c 00 00       	call   8040cd <free_block>
  8033df:	83 c4 10             	add    $0x10,%esp
		release_uspinlock(&ulock);
  8033e2:	83 ec 0c             	sub    $0xc,%esp
  8033e5:	68 40 e1 81 00       	push   $0x81e140
  8033ea:	e8 02 11 00 00       	call   8044f1 <release_uspinlock>
  8033ef:	83 c4 10             	add    $0x10,%esp
		return NULL;
  8033f2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8033f7:	c9                   	leave  
  8033f8:	c3                   	ret    

008033f9 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  8033f9:	55                   	push   %ebp
  8033fa:	89 e5                	mov    %esp,%ebp
  8033fc:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  8033ff:	e8 cd e6 ff ff       	call   801ad1 <uheap_init>
	//==============================================================
	panic("realloc() is not implemented yet...!!");
  803404:	83 ec 04             	sub    $0x4,%esp
  803407:	68 4c 51 80 00       	push   $0x80514c
  80340c:	68 2d 02 00 00       	push   $0x22d
  803411:	68 2c 50 80 00       	push   $0x80502c
  803416:	e8 03 d5 ff ff       	call   80091e <_panic>

0080341b <sfree>:
//
//	use sys_delete_shared_object(...); which switches to the kernel mode,
//	calls delete_shared_object(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the delete_shared_object() function is empty, make sure to implement it.
void sfree(void* virtual_address)
{
  80341b:	55                   	push   %ebp
  80341c:	89 e5                	mov    %esp,%ebp
  80341e:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.BONUS#5] EXIT #2 - sfree
	//Your code is here
	//Comment the following line
	panic("sfree() is not implemented yet...!!");
  803421:	83 ec 04             	sub    $0x4,%esp
  803424:	68 74 51 80 00       	push   $0x805174
  803429:	68 40 02 00 00       	push   $0x240
  80342e:	68 2c 50 80 00       	push   $0x80502c
  803433:	e8 e6 d4 ff ff       	call   80091e <_panic>

00803438 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  803438:	55                   	push   %ebp
  803439:	89 e5                	mov    %esp,%ebp
  80343b:	57                   	push   %edi
  80343c:	56                   	push   %esi
  80343d:	53                   	push   %ebx
  80343e:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  803441:	8b 45 08             	mov    0x8(%ebp),%eax
  803444:	8b 55 0c             	mov    0xc(%ebp),%edx
  803447:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80344a:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80344d:	8b 7d 18             	mov    0x18(%ebp),%edi
  803450:	8b 75 1c             	mov    0x1c(%ebp),%esi
  803453:	cd 30                	int    $0x30
  803455:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  803458:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80345b:	83 c4 10             	add    $0x10,%esp
  80345e:	5b                   	pop    %ebx
  80345f:	5e                   	pop    %esi
  803460:	5f                   	pop    %edi
  803461:	5d                   	pop    %ebp
  803462:	c3                   	ret    

00803463 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  803463:	55                   	push   %ebp
  803464:	89 e5                	mov    %esp,%ebp
  803466:	83 ec 04             	sub    $0x4,%esp
  803469:	8b 45 10             	mov    0x10(%ebp),%eax
  80346c:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  80346f:	8b 4d 14             	mov    0x14(%ebp),%ecx
  803472:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  803476:	8b 45 08             	mov    0x8(%ebp),%eax
  803479:	6a 00                	push   $0x0
  80347b:	51                   	push   %ecx
  80347c:	52                   	push   %edx
  80347d:	ff 75 0c             	pushl  0xc(%ebp)
  803480:	50                   	push   %eax
  803481:	6a 00                	push   $0x0
  803483:	e8 b0 ff ff ff       	call   803438 <syscall>
  803488:	83 c4 18             	add    $0x18,%esp
}
  80348b:	90                   	nop
  80348c:	c9                   	leave  
  80348d:	c3                   	ret    

0080348e <sys_cgetc>:

int
sys_cgetc(void)
{
  80348e:	55                   	push   %ebp
  80348f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  803491:	6a 00                	push   $0x0
  803493:	6a 00                	push   $0x0
  803495:	6a 00                	push   $0x0
  803497:	6a 00                	push   $0x0
  803499:	6a 00                	push   $0x0
  80349b:	6a 02                	push   $0x2
  80349d:	e8 96 ff ff ff       	call   803438 <syscall>
  8034a2:	83 c4 18             	add    $0x18,%esp
}
  8034a5:	c9                   	leave  
  8034a6:	c3                   	ret    

008034a7 <sys_lock_cons>:

void sys_lock_cons(void)
{
  8034a7:	55                   	push   %ebp
  8034a8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  8034aa:	6a 00                	push   $0x0
  8034ac:	6a 00                	push   $0x0
  8034ae:	6a 00                	push   $0x0
  8034b0:	6a 00                	push   $0x0
  8034b2:	6a 00                	push   $0x0
  8034b4:	6a 03                	push   $0x3
  8034b6:	e8 7d ff ff ff       	call   803438 <syscall>
  8034bb:	83 c4 18             	add    $0x18,%esp
}
  8034be:	90                   	nop
  8034bf:	c9                   	leave  
  8034c0:	c3                   	ret    

008034c1 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  8034c1:	55                   	push   %ebp
  8034c2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  8034c4:	6a 00                	push   $0x0
  8034c6:	6a 00                	push   $0x0
  8034c8:	6a 00                	push   $0x0
  8034ca:	6a 00                	push   $0x0
  8034cc:	6a 00                	push   $0x0
  8034ce:	6a 04                	push   $0x4
  8034d0:	e8 63 ff ff ff       	call   803438 <syscall>
  8034d5:	83 c4 18             	add    $0x18,%esp
}
  8034d8:	90                   	nop
  8034d9:	c9                   	leave  
  8034da:	c3                   	ret    

008034db <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8034db:	55                   	push   %ebp
  8034dc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8034de:	8b 55 0c             	mov    0xc(%ebp),%edx
  8034e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8034e4:	6a 00                	push   $0x0
  8034e6:	6a 00                	push   $0x0
  8034e8:	6a 00                	push   $0x0
  8034ea:	52                   	push   %edx
  8034eb:	50                   	push   %eax
  8034ec:	6a 08                	push   $0x8
  8034ee:	e8 45 ff ff ff       	call   803438 <syscall>
  8034f3:	83 c4 18             	add    $0x18,%esp
}
  8034f6:	c9                   	leave  
  8034f7:	c3                   	ret    

008034f8 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8034f8:	55                   	push   %ebp
  8034f9:	89 e5                	mov    %esp,%ebp
  8034fb:	56                   	push   %esi
  8034fc:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8034fd:	8b 75 18             	mov    0x18(%ebp),%esi
  803500:	8b 5d 14             	mov    0x14(%ebp),%ebx
  803503:	8b 4d 10             	mov    0x10(%ebp),%ecx
  803506:	8b 55 0c             	mov    0xc(%ebp),%edx
  803509:	8b 45 08             	mov    0x8(%ebp),%eax
  80350c:	56                   	push   %esi
  80350d:	53                   	push   %ebx
  80350e:	51                   	push   %ecx
  80350f:	52                   	push   %edx
  803510:	50                   	push   %eax
  803511:	6a 09                	push   $0x9
  803513:	e8 20 ff ff ff       	call   803438 <syscall>
  803518:	83 c4 18             	add    $0x18,%esp
}
  80351b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80351e:	5b                   	pop    %ebx
  80351f:	5e                   	pop    %esi
  803520:	5d                   	pop    %ebp
  803521:	c3                   	ret    

00803522 <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  803522:	55                   	push   %ebp
  803523:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  803525:	6a 00                	push   $0x0
  803527:	6a 00                	push   $0x0
  803529:	6a 00                	push   $0x0
  80352b:	6a 00                	push   $0x0
  80352d:	ff 75 08             	pushl  0x8(%ebp)
  803530:	6a 0a                	push   $0xa
  803532:	e8 01 ff ff ff       	call   803438 <syscall>
  803537:	83 c4 18             	add    $0x18,%esp
}
  80353a:	c9                   	leave  
  80353b:	c3                   	ret    

0080353c <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  80353c:	55                   	push   %ebp
  80353d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  80353f:	6a 00                	push   $0x0
  803541:	6a 00                	push   $0x0
  803543:	6a 00                	push   $0x0
  803545:	ff 75 0c             	pushl  0xc(%ebp)
  803548:	ff 75 08             	pushl  0x8(%ebp)
  80354b:	6a 0b                	push   $0xb
  80354d:	e8 e6 fe ff ff       	call   803438 <syscall>
  803552:	83 c4 18             	add    $0x18,%esp
}
  803555:	c9                   	leave  
  803556:	c3                   	ret    

00803557 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  803557:	55                   	push   %ebp
  803558:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  80355a:	6a 00                	push   $0x0
  80355c:	6a 00                	push   $0x0
  80355e:	6a 00                	push   $0x0
  803560:	6a 00                	push   $0x0
  803562:	6a 00                	push   $0x0
  803564:	6a 0c                	push   $0xc
  803566:	e8 cd fe ff ff       	call   803438 <syscall>
  80356b:	83 c4 18             	add    $0x18,%esp
}
  80356e:	c9                   	leave  
  80356f:	c3                   	ret    

00803570 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  803570:	55                   	push   %ebp
  803571:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  803573:	6a 00                	push   $0x0
  803575:	6a 00                	push   $0x0
  803577:	6a 00                	push   $0x0
  803579:	6a 00                	push   $0x0
  80357b:	6a 00                	push   $0x0
  80357d:	6a 0d                	push   $0xd
  80357f:	e8 b4 fe ff ff       	call   803438 <syscall>
  803584:	83 c4 18             	add    $0x18,%esp
}
  803587:	c9                   	leave  
  803588:	c3                   	ret    

00803589 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  803589:	55                   	push   %ebp
  80358a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  80358c:	6a 00                	push   $0x0
  80358e:	6a 00                	push   $0x0
  803590:	6a 00                	push   $0x0
  803592:	6a 00                	push   $0x0
  803594:	6a 00                	push   $0x0
  803596:	6a 0e                	push   $0xe
  803598:	e8 9b fe ff ff       	call   803438 <syscall>
  80359d:	83 c4 18             	add    $0x18,%esp
}
  8035a0:	c9                   	leave  
  8035a1:	c3                   	ret    

008035a2 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8035a2:	55                   	push   %ebp
  8035a3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8035a5:	6a 00                	push   $0x0
  8035a7:	6a 00                	push   $0x0
  8035a9:	6a 00                	push   $0x0
  8035ab:	6a 00                	push   $0x0
  8035ad:	6a 00                	push   $0x0
  8035af:	6a 0f                	push   $0xf
  8035b1:	e8 82 fe ff ff       	call   803438 <syscall>
  8035b6:	83 c4 18             	add    $0x18,%esp
}
  8035b9:	c9                   	leave  
  8035ba:	c3                   	ret    

008035bb <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8035bb:	55                   	push   %ebp
  8035bc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8035be:	6a 00                	push   $0x0
  8035c0:	6a 00                	push   $0x0
  8035c2:	6a 00                	push   $0x0
  8035c4:	6a 00                	push   $0x0
  8035c6:	ff 75 08             	pushl  0x8(%ebp)
  8035c9:	6a 10                	push   $0x10
  8035cb:	e8 68 fe ff ff       	call   803438 <syscall>
  8035d0:	83 c4 18             	add    $0x18,%esp
}
  8035d3:	c9                   	leave  
  8035d4:	c3                   	ret    

008035d5 <sys_scarce_memory>:

void sys_scarce_memory()
{
  8035d5:	55                   	push   %ebp
  8035d6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8035d8:	6a 00                	push   $0x0
  8035da:	6a 00                	push   $0x0
  8035dc:	6a 00                	push   $0x0
  8035de:	6a 00                	push   $0x0
  8035e0:	6a 00                	push   $0x0
  8035e2:	6a 11                	push   $0x11
  8035e4:	e8 4f fe ff ff       	call   803438 <syscall>
  8035e9:	83 c4 18             	add    $0x18,%esp
}
  8035ec:	90                   	nop
  8035ed:	c9                   	leave  
  8035ee:	c3                   	ret    

008035ef <sys_cputc>:

void
sys_cputc(const char c)
{
  8035ef:	55                   	push   %ebp
  8035f0:	89 e5                	mov    %esp,%ebp
  8035f2:	83 ec 04             	sub    $0x4,%esp
  8035f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8035f8:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8035fb:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8035ff:	6a 00                	push   $0x0
  803601:	6a 00                	push   $0x0
  803603:	6a 00                	push   $0x0
  803605:	6a 00                	push   $0x0
  803607:	50                   	push   %eax
  803608:	6a 01                	push   $0x1
  80360a:	e8 29 fe ff ff       	call   803438 <syscall>
  80360f:	83 c4 18             	add    $0x18,%esp
}
  803612:	90                   	nop
  803613:	c9                   	leave  
  803614:	c3                   	ret    

00803615 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  803615:	55                   	push   %ebp
  803616:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  803618:	6a 00                	push   $0x0
  80361a:	6a 00                	push   $0x0
  80361c:	6a 00                	push   $0x0
  80361e:	6a 00                	push   $0x0
  803620:	6a 00                	push   $0x0
  803622:	6a 14                	push   $0x14
  803624:	e8 0f fe ff ff       	call   803438 <syscall>
  803629:	83 c4 18             	add    $0x18,%esp
}
  80362c:	90                   	nop
  80362d:	c9                   	leave  
  80362e:	c3                   	ret    

0080362f <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  80362f:	55                   	push   %ebp
  803630:	89 e5                	mov    %esp,%ebp
  803632:	83 ec 04             	sub    $0x4,%esp
  803635:	8b 45 10             	mov    0x10(%ebp),%eax
  803638:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  80363b:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80363e:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  803642:	8b 45 08             	mov    0x8(%ebp),%eax
  803645:	6a 00                	push   $0x0
  803647:	51                   	push   %ecx
  803648:	52                   	push   %edx
  803649:	ff 75 0c             	pushl  0xc(%ebp)
  80364c:	50                   	push   %eax
  80364d:	6a 15                	push   $0x15
  80364f:	e8 e4 fd ff ff       	call   803438 <syscall>
  803654:	83 c4 18             	add    $0x18,%esp
}
  803657:	c9                   	leave  
  803658:	c3                   	ret    

00803659 <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  803659:	55                   	push   %ebp
  80365a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  80365c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80365f:	8b 45 08             	mov    0x8(%ebp),%eax
  803662:	6a 00                	push   $0x0
  803664:	6a 00                	push   $0x0
  803666:	6a 00                	push   $0x0
  803668:	52                   	push   %edx
  803669:	50                   	push   %eax
  80366a:	6a 16                	push   $0x16
  80366c:	e8 c7 fd ff ff       	call   803438 <syscall>
  803671:	83 c4 18             	add    $0x18,%esp
}
  803674:	c9                   	leave  
  803675:	c3                   	ret    

00803676 <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  803676:	55                   	push   %ebp
  803677:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  803679:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80367c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80367f:	8b 45 08             	mov    0x8(%ebp),%eax
  803682:	6a 00                	push   $0x0
  803684:	6a 00                	push   $0x0
  803686:	51                   	push   %ecx
  803687:	52                   	push   %edx
  803688:	50                   	push   %eax
  803689:	6a 17                	push   $0x17
  80368b:	e8 a8 fd ff ff       	call   803438 <syscall>
  803690:	83 c4 18             	add    $0x18,%esp
}
  803693:	c9                   	leave  
  803694:	c3                   	ret    

00803695 <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  803695:	55                   	push   %ebp
  803696:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  803698:	8b 55 0c             	mov    0xc(%ebp),%edx
  80369b:	8b 45 08             	mov    0x8(%ebp),%eax
  80369e:	6a 00                	push   $0x0
  8036a0:	6a 00                	push   $0x0
  8036a2:	6a 00                	push   $0x0
  8036a4:	52                   	push   %edx
  8036a5:	50                   	push   %eax
  8036a6:	6a 18                	push   $0x18
  8036a8:	e8 8b fd ff ff       	call   803438 <syscall>
  8036ad:	83 c4 18             	add    $0x18,%esp
}
  8036b0:	c9                   	leave  
  8036b1:	c3                   	ret    

008036b2 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8036b2:	55                   	push   %ebp
  8036b3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8036b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8036b8:	6a 00                	push   $0x0
  8036ba:	ff 75 14             	pushl  0x14(%ebp)
  8036bd:	ff 75 10             	pushl  0x10(%ebp)
  8036c0:	ff 75 0c             	pushl  0xc(%ebp)
  8036c3:	50                   	push   %eax
  8036c4:	6a 19                	push   $0x19
  8036c6:	e8 6d fd ff ff       	call   803438 <syscall>
  8036cb:	83 c4 18             	add    $0x18,%esp
}
  8036ce:	c9                   	leave  
  8036cf:	c3                   	ret    

008036d0 <sys_run_env>:

void sys_run_env(int32 envId)
{
  8036d0:	55                   	push   %ebp
  8036d1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8036d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8036d6:	6a 00                	push   $0x0
  8036d8:	6a 00                	push   $0x0
  8036da:	6a 00                	push   $0x0
  8036dc:	6a 00                	push   $0x0
  8036de:	50                   	push   %eax
  8036df:	6a 1a                	push   $0x1a
  8036e1:	e8 52 fd ff ff       	call   803438 <syscall>
  8036e6:	83 c4 18             	add    $0x18,%esp
}
  8036e9:	90                   	nop
  8036ea:	c9                   	leave  
  8036eb:	c3                   	ret    

008036ec <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8036ec:	55                   	push   %ebp
  8036ed:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8036ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8036f2:	6a 00                	push   $0x0
  8036f4:	6a 00                	push   $0x0
  8036f6:	6a 00                	push   $0x0
  8036f8:	6a 00                	push   $0x0
  8036fa:	50                   	push   %eax
  8036fb:	6a 1b                	push   $0x1b
  8036fd:	e8 36 fd ff ff       	call   803438 <syscall>
  803702:	83 c4 18             	add    $0x18,%esp
}
  803705:	c9                   	leave  
  803706:	c3                   	ret    

00803707 <sys_getenvid>:

int32 sys_getenvid(void)
{
  803707:	55                   	push   %ebp
  803708:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  80370a:	6a 00                	push   $0x0
  80370c:	6a 00                	push   $0x0
  80370e:	6a 00                	push   $0x0
  803710:	6a 00                	push   $0x0
  803712:	6a 00                	push   $0x0
  803714:	6a 05                	push   $0x5
  803716:	e8 1d fd ff ff       	call   803438 <syscall>
  80371b:	83 c4 18             	add    $0x18,%esp
}
  80371e:	c9                   	leave  
  80371f:	c3                   	ret    

00803720 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  803720:	55                   	push   %ebp
  803721:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  803723:	6a 00                	push   $0x0
  803725:	6a 00                	push   $0x0
  803727:	6a 00                	push   $0x0
  803729:	6a 00                	push   $0x0
  80372b:	6a 00                	push   $0x0
  80372d:	6a 06                	push   $0x6
  80372f:	e8 04 fd ff ff       	call   803438 <syscall>
  803734:	83 c4 18             	add    $0x18,%esp
}
  803737:	c9                   	leave  
  803738:	c3                   	ret    

00803739 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  803739:	55                   	push   %ebp
  80373a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  80373c:	6a 00                	push   $0x0
  80373e:	6a 00                	push   $0x0
  803740:	6a 00                	push   $0x0
  803742:	6a 00                	push   $0x0
  803744:	6a 00                	push   $0x0
  803746:	6a 07                	push   $0x7
  803748:	e8 eb fc ff ff       	call   803438 <syscall>
  80374d:	83 c4 18             	add    $0x18,%esp
}
  803750:	c9                   	leave  
  803751:	c3                   	ret    

00803752 <sys_exit_env>:


void sys_exit_env(void)
{
  803752:	55                   	push   %ebp
  803753:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  803755:	6a 00                	push   $0x0
  803757:	6a 00                	push   $0x0
  803759:	6a 00                	push   $0x0
  80375b:	6a 00                	push   $0x0
  80375d:	6a 00                	push   $0x0
  80375f:	6a 1c                	push   $0x1c
  803761:	e8 d2 fc ff ff       	call   803438 <syscall>
  803766:	83 c4 18             	add    $0x18,%esp
}
  803769:	90                   	nop
  80376a:	c9                   	leave  
  80376b:	c3                   	ret    

0080376c <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  80376c:	55                   	push   %ebp
  80376d:	89 e5                	mov    %esp,%ebp
  80376f:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  803772:	8d 45 f8             	lea    -0x8(%ebp),%eax
  803775:	8d 50 04             	lea    0x4(%eax),%edx
  803778:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80377b:	6a 00                	push   $0x0
  80377d:	6a 00                	push   $0x0
  80377f:	6a 00                	push   $0x0
  803781:	52                   	push   %edx
  803782:	50                   	push   %eax
  803783:	6a 1d                	push   $0x1d
  803785:	e8 ae fc ff ff       	call   803438 <syscall>
  80378a:	83 c4 18             	add    $0x18,%esp
	return result;
  80378d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  803790:	8b 45 f8             	mov    -0x8(%ebp),%eax
  803793:	8b 55 fc             	mov    -0x4(%ebp),%edx
  803796:	89 01                	mov    %eax,(%ecx)
  803798:	89 51 04             	mov    %edx,0x4(%ecx)
}
  80379b:	8b 45 08             	mov    0x8(%ebp),%eax
  80379e:	c9                   	leave  
  80379f:	c2 04 00             	ret    $0x4

008037a2 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8037a2:	55                   	push   %ebp
  8037a3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8037a5:	6a 00                	push   $0x0
  8037a7:	6a 00                	push   $0x0
  8037a9:	ff 75 10             	pushl  0x10(%ebp)
  8037ac:	ff 75 0c             	pushl  0xc(%ebp)
  8037af:	ff 75 08             	pushl  0x8(%ebp)
  8037b2:	6a 13                	push   $0x13
  8037b4:	e8 7f fc ff ff       	call   803438 <syscall>
  8037b9:	83 c4 18             	add    $0x18,%esp
	return ;
  8037bc:	90                   	nop
}
  8037bd:	c9                   	leave  
  8037be:	c3                   	ret    

008037bf <sys_rcr2>:
uint32 sys_rcr2()
{
  8037bf:	55                   	push   %ebp
  8037c0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8037c2:	6a 00                	push   $0x0
  8037c4:	6a 00                	push   $0x0
  8037c6:	6a 00                	push   $0x0
  8037c8:	6a 00                	push   $0x0
  8037ca:	6a 00                	push   $0x0
  8037cc:	6a 1e                	push   $0x1e
  8037ce:	e8 65 fc ff ff       	call   803438 <syscall>
  8037d3:	83 c4 18             	add    $0x18,%esp
}
  8037d6:	c9                   	leave  
  8037d7:	c3                   	ret    

008037d8 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  8037d8:	55                   	push   %ebp
  8037d9:	89 e5                	mov    %esp,%ebp
  8037db:	83 ec 04             	sub    $0x4,%esp
  8037de:	8b 45 08             	mov    0x8(%ebp),%eax
  8037e1:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8037e4:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8037e8:	6a 00                	push   $0x0
  8037ea:	6a 00                	push   $0x0
  8037ec:	6a 00                	push   $0x0
  8037ee:	6a 00                	push   $0x0
  8037f0:	50                   	push   %eax
  8037f1:	6a 1f                	push   $0x1f
  8037f3:	e8 40 fc ff ff       	call   803438 <syscall>
  8037f8:	83 c4 18             	add    $0x18,%esp
	return ;
  8037fb:	90                   	nop
}
  8037fc:	c9                   	leave  
  8037fd:	c3                   	ret    

008037fe <rsttst>:
void rsttst()
{
  8037fe:	55                   	push   %ebp
  8037ff:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  803801:	6a 00                	push   $0x0
  803803:	6a 00                	push   $0x0
  803805:	6a 00                	push   $0x0
  803807:	6a 00                	push   $0x0
  803809:	6a 00                	push   $0x0
  80380b:	6a 21                	push   $0x21
  80380d:	e8 26 fc ff ff       	call   803438 <syscall>
  803812:	83 c4 18             	add    $0x18,%esp
	return ;
  803815:	90                   	nop
}
  803816:	c9                   	leave  
  803817:	c3                   	ret    

00803818 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  803818:	55                   	push   %ebp
  803819:	89 e5                	mov    %esp,%ebp
  80381b:	83 ec 04             	sub    $0x4,%esp
  80381e:	8b 45 14             	mov    0x14(%ebp),%eax
  803821:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  803824:	8b 55 18             	mov    0x18(%ebp),%edx
  803827:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80382b:	52                   	push   %edx
  80382c:	50                   	push   %eax
  80382d:	ff 75 10             	pushl  0x10(%ebp)
  803830:	ff 75 0c             	pushl  0xc(%ebp)
  803833:	ff 75 08             	pushl  0x8(%ebp)
  803836:	6a 20                	push   $0x20
  803838:	e8 fb fb ff ff       	call   803438 <syscall>
  80383d:	83 c4 18             	add    $0x18,%esp
	return ;
  803840:	90                   	nop
}
  803841:	c9                   	leave  
  803842:	c3                   	ret    

00803843 <chktst>:
void chktst(uint32 n)
{
  803843:	55                   	push   %ebp
  803844:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  803846:	6a 00                	push   $0x0
  803848:	6a 00                	push   $0x0
  80384a:	6a 00                	push   $0x0
  80384c:	6a 00                	push   $0x0
  80384e:	ff 75 08             	pushl  0x8(%ebp)
  803851:	6a 22                	push   $0x22
  803853:	e8 e0 fb ff ff       	call   803438 <syscall>
  803858:	83 c4 18             	add    $0x18,%esp
	return ;
  80385b:	90                   	nop
}
  80385c:	c9                   	leave  
  80385d:	c3                   	ret    

0080385e <inctst>:

void inctst()
{
  80385e:	55                   	push   %ebp
  80385f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  803861:	6a 00                	push   $0x0
  803863:	6a 00                	push   $0x0
  803865:	6a 00                	push   $0x0
  803867:	6a 00                	push   $0x0
  803869:	6a 00                	push   $0x0
  80386b:	6a 23                	push   $0x23
  80386d:	e8 c6 fb ff ff       	call   803438 <syscall>
  803872:	83 c4 18             	add    $0x18,%esp
	return ;
  803875:	90                   	nop
}
  803876:	c9                   	leave  
  803877:	c3                   	ret    

00803878 <gettst>:
uint32 gettst()
{
  803878:	55                   	push   %ebp
  803879:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  80387b:	6a 00                	push   $0x0
  80387d:	6a 00                	push   $0x0
  80387f:	6a 00                	push   $0x0
  803881:	6a 00                	push   $0x0
  803883:	6a 00                	push   $0x0
  803885:	6a 24                	push   $0x24
  803887:	e8 ac fb ff ff       	call   803438 <syscall>
  80388c:	83 c4 18             	add    $0x18,%esp
}
  80388f:	c9                   	leave  
  803890:	c3                   	ret    

00803891 <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  803891:	55                   	push   %ebp
  803892:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  803894:	6a 00                	push   $0x0
  803896:	6a 00                	push   $0x0
  803898:	6a 00                	push   $0x0
  80389a:	6a 00                	push   $0x0
  80389c:	6a 00                	push   $0x0
  80389e:	6a 25                	push   $0x25
  8038a0:	e8 93 fb ff ff       	call   803438 <syscall>
  8038a5:	83 c4 18             	add    $0x18,%esp
  8038a8:	a3 60 e0 81 00       	mov    %eax,0x81e060
	return uheapPlaceStrategy ;
  8038ad:	a1 60 e0 81 00       	mov    0x81e060,%eax
}
  8038b2:	c9                   	leave  
  8038b3:	c3                   	ret    

008038b4 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  8038b4:	55                   	push   %ebp
  8038b5:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  8038b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8038ba:	a3 60 e0 81 00       	mov    %eax,0x81e060
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  8038bf:	6a 00                	push   $0x0
  8038c1:	6a 00                	push   $0x0
  8038c3:	6a 00                	push   $0x0
  8038c5:	6a 00                	push   $0x0
  8038c7:	ff 75 08             	pushl  0x8(%ebp)
  8038ca:	6a 26                	push   $0x26
  8038cc:	e8 67 fb ff ff       	call   803438 <syscall>
  8038d1:	83 c4 18             	add    $0x18,%esp
	return ;
  8038d4:	90                   	nop
}
  8038d5:	c9                   	leave  
  8038d6:	c3                   	ret    

008038d7 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  8038d7:	55                   	push   %ebp
  8038d8:	89 e5                	mov    %esp,%ebp
  8038da:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  8038db:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8038de:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8038e1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8038e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8038e7:	6a 00                	push   $0x0
  8038e9:	53                   	push   %ebx
  8038ea:	51                   	push   %ecx
  8038eb:	52                   	push   %edx
  8038ec:	50                   	push   %eax
  8038ed:	6a 27                	push   $0x27
  8038ef:	e8 44 fb ff ff       	call   803438 <syscall>
  8038f4:	83 c4 18             	add    $0x18,%esp
}
  8038f7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8038fa:	c9                   	leave  
  8038fb:	c3                   	ret    

008038fc <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  8038fc:	55                   	push   %ebp
  8038fd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  8038ff:	8b 55 0c             	mov    0xc(%ebp),%edx
  803902:	8b 45 08             	mov    0x8(%ebp),%eax
  803905:	6a 00                	push   $0x0
  803907:	6a 00                	push   $0x0
  803909:	6a 00                	push   $0x0
  80390b:	52                   	push   %edx
  80390c:	50                   	push   %eax
  80390d:	6a 28                	push   $0x28
  80390f:	e8 24 fb ff ff       	call   803438 <syscall>
  803914:	83 c4 18             	add    $0x18,%esp
}
  803917:	c9                   	leave  
  803918:	c3                   	ret    

00803919 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  803919:	55                   	push   %ebp
  80391a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  80391c:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80391f:	8b 55 0c             	mov    0xc(%ebp),%edx
  803922:	8b 45 08             	mov    0x8(%ebp),%eax
  803925:	6a 00                	push   $0x0
  803927:	51                   	push   %ecx
  803928:	ff 75 10             	pushl  0x10(%ebp)
  80392b:	52                   	push   %edx
  80392c:	50                   	push   %eax
  80392d:	6a 29                	push   $0x29
  80392f:	e8 04 fb ff ff       	call   803438 <syscall>
  803934:	83 c4 18             	add    $0x18,%esp
}
  803937:	c9                   	leave  
  803938:	c3                   	ret    

00803939 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  803939:	55                   	push   %ebp
  80393a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  80393c:	6a 00                	push   $0x0
  80393e:	6a 00                	push   $0x0
  803940:	ff 75 10             	pushl  0x10(%ebp)
  803943:	ff 75 0c             	pushl  0xc(%ebp)
  803946:	ff 75 08             	pushl  0x8(%ebp)
  803949:	6a 12                	push   $0x12
  80394b:	e8 e8 fa ff ff       	call   803438 <syscall>
  803950:	83 c4 18             	add    $0x18,%esp
	return ;
  803953:	90                   	nop
}
  803954:	c9                   	leave  
  803955:	c3                   	ret    

00803956 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  803956:	55                   	push   %ebp
  803957:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  803959:	8b 55 0c             	mov    0xc(%ebp),%edx
  80395c:	8b 45 08             	mov    0x8(%ebp),%eax
  80395f:	6a 00                	push   $0x0
  803961:	6a 00                	push   $0x0
  803963:	6a 00                	push   $0x0
  803965:	52                   	push   %edx
  803966:	50                   	push   %eax
  803967:	6a 2a                	push   $0x2a
  803969:	e8 ca fa ff ff       	call   803438 <syscall>
  80396e:	83 c4 18             	add    $0x18,%esp
	return;
  803971:	90                   	nop
}
  803972:	c9                   	leave  
  803973:	c3                   	ret    

00803974 <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  803974:	55                   	push   %ebp
  803975:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  803977:	6a 00                	push   $0x0
  803979:	6a 00                	push   $0x0
  80397b:	6a 00                	push   $0x0
  80397d:	6a 00                	push   $0x0
  80397f:	6a 00                	push   $0x0
  803981:	6a 2b                	push   $0x2b
  803983:	e8 b0 fa ff ff       	call   803438 <syscall>
  803988:	83 c4 18             	add    $0x18,%esp
}
  80398b:	c9                   	leave  
  80398c:	c3                   	ret    

0080398d <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  80398d:	55                   	push   %ebp
  80398e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  803990:	6a 00                	push   $0x0
  803992:	6a 00                	push   $0x0
  803994:	6a 00                	push   $0x0
  803996:	ff 75 0c             	pushl  0xc(%ebp)
  803999:	ff 75 08             	pushl  0x8(%ebp)
  80399c:	6a 2d                	push   $0x2d
  80399e:	e8 95 fa ff ff       	call   803438 <syscall>
  8039a3:	83 c4 18             	add    $0x18,%esp
	return;
  8039a6:	90                   	nop
}
  8039a7:	c9                   	leave  
  8039a8:	c3                   	ret    

008039a9 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8039a9:	55                   	push   %ebp
  8039aa:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  8039ac:	6a 00                	push   $0x0
  8039ae:	6a 00                	push   $0x0
  8039b0:	6a 00                	push   $0x0
  8039b2:	ff 75 0c             	pushl  0xc(%ebp)
  8039b5:	ff 75 08             	pushl  0x8(%ebp)
  8039b8:	6a 2c                	push   $0x2c
  8039ba:	e8 79 fa ff ff       	call   803438 <syscall>
  8039bf:	83 c4 18             	add    $0x18,%esp
	return ;
  8039c2:	90                   	nop
}
  8039c3:	c9                   	leave  
  8039c4:	c3                   	ret    

008039c5 <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  8039c5:	55                   	push   %ebp
  8039c6:	89 e5                	mov    %esp,%ebp
	//TODO: [PROJECT'25.IM#4] CPU SCHEDULING - #1 System Calls - Add suitable code here
	//Your code is here
	//Comment the following line
	//panic("sys_env_set_priority() is not implemented yet...!!");
	syscall(SYS_env_set_priority, envID, priority, 0, 0, 0);
  8039c8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8039cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8039ce:	6a 00                	push   $0x0
  8039d0:	6a 00                	push   $0x0
  8039d2:	6a 00                	push   $0x0
  8039d4:	52                   	push   %edx
  8039d5:	50                   	push   %eax
  8039d6:	6a 2e                	push   $0x2e
  8039d8:	e8 5b fa ff ff       	call   803438 <syscall>
  8039dd:	83 c4 18             	add    $0x18,%esp
	    return;
  8039e0:	90                   	nop
}
  8039e1:	c9                   	leave  
  8039e2:	c3                   	ret    

008039e3 <to_page_va>:
//==================================================================================//
//==================================
// [1] GET PAGE VA:
//==================================
__inline__ uint32 to_page_va(struct PageInfoElement *ptrPageInfo)
{
  8039e3:	55                   	push   %ebp
  8039e4:	89 e5                	mov    %esp,%ebp
  8039e6:	83 ec 10             	sub    $0x10,%esp
	//Get start VA of the page from the corresponding Page Info pointer
	int idxInPageInfoArr = (ptrPageInfo - pageBlockInfoArr);
  8039e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8039ec:	ba 60 60 80 00       	mov    $0x806060,%edx
  8039f1:	29 d0                	sub    %edx,%eax
  8039f3:	c1 f8 02             	sar    $0x2,%eax
  8039f6:	89 c2                	mov    %eax,%edx
  8039f8:	89 d0                	mov    %edx,%eax
  8039fa:	c1 e0 02             	shl    $0x2,%eax
  8039fd:	01 d0                	add    %edx,%eax
  8039ff:	c1 e0 02             	shl    $0x2,%eax
  803a02:	01 d0                	add    %edx,%eax
  803a04:	c1 e0 02             	shl    $0x2,%eax
  803a07:	01 d0                	add    %edx,%eax
  803a09:	89 c1                	mov    %eax,%ecx
  803a0b:	c1 e1 08             	shl    $0x8,%ecx
  803a0e:	01 c8                	add    %ecx,%eax
  803a10:	89 c1                	mov    %eax,%ecx
  803a12:	c1 e1 10             	shl    $0x10,%ecx
  803a15:	01 c8                	add    %ecx,%eax
  803a17:	01 c0                	add    %eax,%eax
  803a19:	01 d0                	add    %edx,%eax
  803a1b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return dynAllocStart + (idxInPageInfoArr << PGSHIFT);
  803a1e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  803a21:	c1 e0 0c             	shl    $0xc,%eax
  803a24:	89 c2                	mov    %eax,%edx
  803a26:	a1 64 e0 81 00       	mov    0x81e064,%eax
  803a2b:	01 d0                	add    %edx,%eax
}
  803a2d:	c9                   	leave  
  803a2e:	c3                   	ret    

00803a2f <log2>:

//==================================================================================//
//============================ REQUIRED FUNCTIONS ==================================//
//==================================================================================//
__inline__ int log2(uint32 n)
	{
  803a2f:	55                   	push   %ebp
  803a30:	89 e5                	mov    %esp,%ebp
  803a32:	83 ec 10             	sub    $0x10,%esp
		int result = 0;
  803a35:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
		while( n > 1){
  803a3c:	eb 06                	jmp    803a44 <log2+0x15>
			n >>=1;
  803a3e:	d1 6d 08             	shrl   0x8(%ebp)
			result++;
  803a41:	ff 45 fc             	incl   -0x4(%ebp)
//============================ REQUIRED FUNCTIONS ==================================//
//==================================================================================//
__inline__ int log2(uint32 n)
	{
		int result = 0;
		while( n > 1){
  803a44:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
  803a48:	77 f4                	ja     803a3e <log2+0xf>
			n >>=1;
			result++;
		}
		return result;
  803a4a:	8b 45 fc             	mov    -0x4(%ebp),%eax
	}
  803a4d:	c9                   	leave  
  803a4e:	c3                   	ret    

00803a4f <initialize_dynamic_allocator>:
//==================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================
bool is_initialized = 0;
void initialize_dynamic_allocator(uint32 daStart, uint32 daEnd)
{
  803a4f:	55                   	push   %ebp
  803a50:	89 e5                	mov    %esp,%ebp
  803a52:	83 ec 18             	sub    $0x18,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(daEnd <= daStart + DYN_ALLOC_MAX_SIZE);
  803a55:	8b 45 08             	mov    0x8(%ebp),%eax
  803a58:	05 00 00 00 02       	add    $0x2000000,%eax
  803a5d:	3b 45 0c             	cmp    0xc(%ebp),%eax
  803a60:	73 16                	jae    803a78 <initialize_dynamic_allocator+0x29>
  803a62:	68 98 51 80 00       	push   $0x805198
  803a67:	68 be 51 80 00       	push   $0x8051be
  803a6c:	6a 2d                	push   $0x2d
  803a6e:	68 d3 51 80 00       	push   $0x8051d3
  803a73:	e8 a6 ce ff ff       	call   80091e <_panic>
		is_initialized = 1;
  803a78:	c7 05 28 60 80 00 01 	movl   $0x1,0x806028
  803a7f:	00 00 00 
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #1 initialize_dynamic_allocator
	//Your code is here


	dynAllocStart = daStart;
  803a82:	8b 45 08             	mov    0x8(%ebp),%eax
  803a85:	a3 64 e0 81 00       	mov    %eax,0x81e064
	dynAllocEnd= daEnd;
  803a8a:	8b 45 0c             	mov    0xc(%ebp),%eax
  803a8d:	a3 40 60 80 00       	mov    %eax,0x806040
	int numOfPages = (dynAllocEnd - dynAllocStart)/PAGE_SIZE;
  803a92:	8b 15 40 60 80 00    	mov    0x806040,%edx
  803a98:	a1 64 e0 81 00       	mov    0x81e064,%eax
  803a9d:	29 c2                	sub    %eax,%edx
  803a9f:	89 d0                	mov    %edx,%eax
  803aa1:	c1 e8 0c             	shr    $0xc,%eax
  803aa4:	89 45 e8             	mov    %eax,-0x18(%ebp)


	for(int i=0; i< numOfPages; i++){
  803aa7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  803aae:	eb 2f                	jmp    803adf <initialize_dynamic_allocator+0x90>
	    pageBlockInfoArr[i].block_size=0;
  803ab0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803ab3:	89 d0                	mov    %edx,%eax
  803ab5:	01 c0                	add    %eax,%eax
  803ab7:	01 d0                	add    %edx,%eax
  803ab9:	c1 e0 02             	shl    $0x2,%eax
  803abc:	05 68 60 80 00       	add    $0x806068,%eax
  803ac1:	66 c7 00 00 00       	movw   $0x0,(%eax)
	    pageBlockInfoArr[i].num_of_free_blocks=0;
  803ac6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803ac9:	89 d0                	mov    %edx,%eax
  803acb:	01 c0                	add    %eax,%eax
  803acd:	01 d0                	add    %edx,%eax
  803acf:	c1 e0 02             	shl    $0x2,%eax
  803ad2:	05 6a 60 80 00       	add    $0x80606a,%eax
  803ad7:	66 c7 00 00 00       	movw   $0x0,(%eax)
	dynAllocStart = daStart;
	dynAllocEnd= daEnd;
	int numOfPages = (dynAllocEnd - dynAllocStart)/PAGE_SIZE;


	for(int i=0; i< numOfPages; i++){
  803adc:	ff 45 f4             	incl   -0xc(%ebp)
  803adf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ae2:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803ae5:	7c c9                	jl     803ab0 <initialize_dynamic_allocator+0x61>
	    pageBlockInfoArr[i].block_size=0;
	    pageBlockInfoArr[i].num_of_free_blocks=0;
	}


	LIST_INIT(&freePagesList);
  803ae7:	c7 05 48 60 80 00 00 	movl   $0x0,0x806048
  803aee:	00 00 00 
  803af1:	c7 05 4c 60 80 00 00 	movl   $0x0,0x80604c
  803af8:	00 00 00 
  803afb:	c7 05 54 60 80 00 00 	movl   $0x0,0x806054
  803b02:	00 00 00 
	for(int i=0; i<numOfPages; i++){
  803b05:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  803b0c:	e9 9c 00 00 00       	jmp    803bad <initialize_dynamic_allocator+0x15e>
		LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
  803b11:	8b 15 4c 60 80 00    	mov    0x80604c,%edx
  803b17:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  803b1a:	89 c8                	mov    %ecx,%eax
  803b1c:	01 c0                	add    %eax,%eax
  803b1e:	01 c8                	add    %ecx,%eax
  803b20:	c1 e0 02             	shl    $0x2,%eax
  803b23:	05 64 60 80 00       	add    $0x806064,%eax
  803b28:	89 10                	mov    %edx,(%eax)
  803b2a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803b2d:	89 d0                	mov    %edx,%eax
  803b2f:	01 c0                	add    %eax,%eax
  803b31:	01 d0                	add    %edx,%eax
  803b33:	c1 e0 02             	shl    $0x2,%eax
  803b36:	05 64 60 80 00       	add    $0x806064,%eax
  803b3b:	8b 00                	mov    (%eax),%eax
  803b3d:	85 c0                	test   %eax,%eax
  803b3f:	74 1b                	je     803b5c <initialize_dynamic_allocator+0x10d>
  803b41:	8b 15 4c 60 80 00    	mov    0x80604c,%edx
  803b47:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  803b4a:	89 c8                	mov    %ecx,%eax
  803b4c:	01 c0                	add    %eax,%eax
  803b4e:	01 c8                	add    %ecx,%eax
  803b50:	c1 e0 02             	shl    $0x2,%eax
  803b53:	05 60 60 80 00       	add    $0x806060,%eax
  803b58:	89 02                	mov    %eax,(%edx)
  803b5a:	eb 16                	jmp    803b72 <initialize_dynamic_allocator+0x123>
  803b5c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803b5f:	89 d0                	mov    %edx,%eax
  803b61:	01 c0                	add    %eax,%eax
  803b63:	01 d0                	add    %edx,%eax
  803b65:	c1 e0 02             	shl    $0x2,%eax
  803b68:	05 60 60 80 00       	add    $0x806060,%eax
  803b6d:	a3 48 60 80 00       	mov    %eax,0x806048
  803b72:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803b75:	89 d0                	mov    %edx,%eax
  803b77:	01 c0                	add    %eax,%eax
  803b79:	01 d0                	add    %edx,%eax
  803b7b:	c1 e0 02             	shl    $0x2,%eax
  803b7e:	05 60 60 80 00       	add    $0x806060,%eax
  803b83:	a3 4c 60 80 00       	mov    %eax,0x80604c
  803b88:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803b8b:	89 d0                	mov    %edx,%eax
  803b8d:	01 c0                	add    %eax,%eax
  803b8f:	01 d0                	add    %edx,%eax
  803b91:	c1 e0 02             	shl    $0x2,%eax
  803b94:	05 60 60 80 00       	add    $0x806060,%eax
  803b99:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803b9f:	a1 54 60 80 00       	mov    0x806054,%eax
  803ba4:	40                   	inc    %eax
  803ba5:	a3 54 60 80 00       	mov    %eax,0x806054
	    pageBlockInfoArr[i].num_of_free_blocks=0;
	}


	LIST_INIT(&freePagesList);
	for(int i=0; i<numOfPages; i++){
  803baa:	ff 45 f0             	incl   -0x10(%ebp)
  803bad:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803bb0:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803bb3:	0f 8c 58 ff ff ff    	jl     803b11 <initialize_dynamic_allocator+0xc2>
		LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
	}



	for (int i = 0; i < LOG2_MAX_SIZE - LOG2_MIN_SIZE + 1; i++) {
  803bb9:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  803bc0:	eb 36                	jmp    803bf8 <initialize_dynamic_allocator+0x1a9>
	    LIST_INIT(&freeBlockLists[i]);
  803bc2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803bc5:	c1 e0 04             	shl    $0x4,%eax
  803bc8:	05 80 e0 81 00       	add    $0x81e080,%eax
  803bcd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803bd3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803bd6:	c1 e0 04             	shl    $0x4,%eax
  803bd9:	05 84 e0 81 00       	add    $0x81e084,%eax
  803bde:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803be4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803be7:	c1 e0 04             	shl    $0x4,%eax
  803bea:	05 8c e0 81 00       	add    $0x81e08c,%eax
  803bef:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
	}



	for (int i = 0; i < LOG2_MAX_SIZE - LOG2_MIN_SIZE + 1; i++) {
  803bf5:	ff 45 ec             	incl   -0x14(%ebp)
  803bf8:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  803bfc:	7e c4                	jle    803bc2 <initialize_dynamic_allocator+0x173>


	//Comment the following line
	//panic("initialize_dynamic_allocator() Not implemented yet");

}
  803bfe:	90                   	nop
  803bff:	c9                   	leave  
  803c00:	c3                   	ret    

00803c01 <get_block_size>:
// [2] GET BLOCK SIZE:
//===========================


__inline__ uint32 get_block_size(void *va)
{
  803c01:	55                   	push   %ebp
  803c02:	89 e5                	mov    %esp,%ebp
  803c04:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #2 get_block_size
	//Your code is here

	uint32 page_index = ((uint32)va - dynAllocStart)/ PAGE_SIZE;
  803c07:	8b 55 08             	mov    0x8(%ebp),%edx
  803c0a:	a1 64 e0 81 00       	mov    0x81e064,%eax
  803c0f:	29 c2                	sub    %eax,%edx
  803c11:	89 d0                	mov    %edx,%eax
  803c13:	c1 e8 0c             	shr    $0xc,%eax
  803c16:	89 45 fc             	mov    %eax,-0x4(%ebp)
    return pageBlockInfoArr[page_index].block_size;
  803c19:	8b 55 fc             	mov    -0x4(%ebp),%edx
  803c1c:	89 d0                	mov    %edx,%eax
  803c1e:	01 c0                	add    %eax,%eax
  803c20:	01 d0                	add    %edx,%eax
  803c22:	c1 e0 02             	shl    $0x2,%eax
  803c25:	05 68 60 80 00       	add    $0x806068,%eax
  803c2a:	8b 00                	mov    (%eax),%eax
  803c2c:	0f b7 c0             	movzwl %ax,%eax
	//Comment the following line
	//panic("get_block_size() Not implemented yet");
}
  803c2f:	c9                   	leave  
  803c30:	c3                   	ret    

00803c31 <alloc_block>:

//===========================
// 3) ALLOCATE BLOCK:
//===========================
void *alloc_block(uint32 size)
{
  803c31:	55                   	push   %ebp
  803c32:	89 e5                	mov    %esp,%ebp
  803c34:	83 ec 48             	sub    $0x48,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(size <= DYN_ALLOC_MAX_BLOCK_SIZE);
  803c37:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  803c3e:	76 16                	jbe    803c56 <alloc_block+0x25>
  803c40:	68 ec 51 80 00       	push   $0x8051ec
  803c45:	68 be 51 80 00       	push   $0x8051be
  803c4a:	6a 6c                	push   $0x6c
  803c4c:	68 d3 51 80 00       	push   $0x8051d3
  803c51:	e8 c8 cc ff ff       	call   80091e <_panic>
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #3 alloc_block
	//Your code is here


	if(size == 0){
  803c56:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803c5a:	75 0a                	jne    803c66 <alloc_block+0x35>
		return NULL;
  803c5c:	b8 00 00 00 00       	mov    $0x0,%eax
  803c61:	e9 65 04 00 00       	jmp    8040cb <alloc_block+0x49a>
	}
	else if(size<=8){
  803c66:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  803c6a:	77 09                	ja     803c75 <alloc_block+0x44>
		size=8;
  803c6c:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
  803c73:	eb 1f                	jmp    803c94 <alloc_block+0x63>
	}
	else{
		uint32 reqsize=8;
  803c75:	c7 45 f4 08 00 00 00 	movl   $0x8,-0xc(%ebp)
		while(reqsize < size){
  803c7c:	eb 08                	jmp    803c86 <alloc_block+0x55>
			reqsize*=2;
  803c7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c81:	01 c0                	add    %eax,%eax
  803c83:	89 45 f4             	mov    %eax,-0xc(%ebp)
	else if(size<=8){
		size=8;
	}
	else{
		uint32 reqsize=8;
		while(reqsize < size){
  803c86:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c89:	3b 45 08             	cmp    0x8(%ebp),%eax
  803c8c:	72 f0                	jb     803c7e <alloc_block+0x4d>
			reqsize*=2;
		}
		size= reqsize;
  803c8e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c91:	89 45 08             	mov    %eax,0x8(%ebp)
	}

	int list_index = log2(size)- LOG2_MIN_SIZE;
  803c94:	83 ec 0c             	sub    $0xc,%esp
  803c97:	ff 75 08             	pushl  0x8(%ebp)
  803c9a:	e8 90 fd ff ff       	call   803a2f <log2>
  803c9f:	83 c4 10             	add    $0x10,%esp
  803ca2:	83 e8 03             	sub    $0x3,%eax
  803ca5:	89 45 e8             	mov    %eax,-0x18(%ebp)

	if(!LIST_EMPTY(&freeBlockLists[list_index])){
  803ca8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803cab:	c1 e0 04             	shl    $0x4,%eax
  803cae:	05 80 e0 81 00       	add    $0x81e080,%eax
  803cb3:	8b 00                	mov    (%eax),%eax
  803cb5:	85 c0                	test   %eax,%eax
  803cb7:	0f 84 fb 00 00 00    	je     803db8 <alloc_block+0x187>
		struct BlockElement *block = LIST_FIRST(&freeBlockLists[list_index]);
  803cbd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803cc0:	c1 e0 04             	shl    $0x4,%eax
  803cc3:	05 80 e0 81 00       	add    $0x81e080,%eax
  803cc8:	8b 00                	mov    (%eax),%eax
  803cca:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		LIST_REMOVE(&freeBlockLists[list_index], block);
  803ccd:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803cd1:	75 17                	jne    803cea <alloc_block+0xb9>
  803cd3:	83 ec 04             	sub    $0x4,%esp
  803cd6:	68 0d 52 80 00       	push   $0x80520d
  803cdb:	68 86 00 00 00       	push   $0x86
  803ce0:	68 d3 51 80 00       	push   $0x8051d3
  803ce5:	e8 34 cc ff ff       	call   80091e <_panic>
  803cea:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803ced:	8b 00                	mov    (%eax),%eax
  803cef:	85 c0                	test   %eax,%eax
  803cf1:	74 10                	je     803d03 <alloc_block+0xd2>
  803cf3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803cf6:	8b 00                	mov    (%eax),%eax
  803cf8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803cfb:	8b 52 04             	mov    0x4(%edx),%edx
  803cfe:	89 50 04             	mov    %edx,0x4(%eax)
  803d01:	eb 14                	jmp    803d17 <alloc_block+0xe6>
  803d03:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803d06:	8b 40 04             	mov    0x4(%eax),%eax
  803d09:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803d0c:	c1 e2 04             	shl    $0x4,%edx
  803d0f:	81 c2 84 e0 81 00    	add    $0x81e084,%edx
  803d15:	89 02                	mov    %eax,(%edx)
  803d17:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803d1a:	8b 40 04             	mov    0x4(%eax),%eax
  803d1d:	85 c0                	test   %eax,%eax
  803d1f:	74 0f                	je     803d30 <alloc_block+0xff>
  803d21:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803d24:	8b 40 04             	mov    0x4(%eax),%eax
  803d27:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803d2a:	8b 12                	mov    (%edx),%edx
  803d2c:	89 10                	mov    %edx,(%eax)
  803d2e:	eb 13                	jmp    803d43 <alloc_block+0x112>
  803d30:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803d33:	8b 00                	mov    (%eax),%eax
  803d35:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803d38:	c1 e2 04             	shl    $0x4,%edx
  803d3b:	81 c2 80 e0 81 00    	add    $0x81e080,%edx
  803d41:	89 02                	mov    %eax,(%edx)
  803d43:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803d46:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803d4c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803d4f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803d56:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803d59:	c1 e0 04             	shl    $0x4,%eax
  803d5c:	05 8c e0 81 00       	add    $0x81e08c,%eax
  803d61:	8b 00                	mov    (%eax),%eax
  803d63:	8d 50 ff             	lea    -0x1(%eax),%edx
  803d66:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803d69:	c1 e0 04             	shl    $0x4,%eax
  803d6c:	05 8c e0 81 00       	add    $0x81e08c,%eax
  803d71:	89 10                	mov    %edx,(%eax)
		uint32 page_index = ((uint32)block - dynAllocStart)/ PAGE_SIZE;
  803d73:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803d76:	a1 64 e0 81 00       	mov    0x81e064,%eax
  803d7b:	29 c2                	sub    %eax,%edx
  803d7d:	89 d0                	mov    %edx,%eax
  803d7f:	c1 e8 0c             	shr    $0xc,%eax
  803d82:	89 45 e0             	mov    %eax,-0x20(%ebp)
		pageBlockInfoArr[page_index].num_of_free_blocks--;
  803d85:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803d88:	89 d0                	mov    %edx,%eax
  803d8a:	01 c0                	add    %eax,%eax
  803d8c:	01 d0                	add    %edx,%eax
  803d8e:	c1 e0 02             	shl    $0x2,%eax
  803d91:	05 6a 60 80 00       	add    $0x80606a,%eax
  803d96:	66 8b 00             	mov    (%eax),%ax
  803d99:	8d 50 ff             	lea    -0x1(%eax),%edx
  803d9c:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  803d9f:	89 c8                	mov    %ecx,%eax
  803da1:	01 c0                	add    %eax,%eax
  803da3:	01 c8                	add    %ecx,%eax
  803da5:	c1 e0 02             	shl    $0x2,%eax
  803da8:	05 6a 60 80 00       	add    $0x80606a,%eax
  803dad:	66 89 10             	mov    %dx,(%eax)
		return (void*)block;
  803db0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803db3:	e9 13 03 00 00       	jmp    8040cb <alloc_block+0x49a>
	}

	if(!LIST_EMPTY(&freePagesList)){
  803db8:	a1 48 60 80 00       	mov    0x806048,%eax
  803dbd:	85 c0                	test   %eax,%eax
  803dbf:	0f 84 c9 01 00 00    	je     803f8e <alloc_block+0x35d>

		struct PageInfoElement *page_info = LIST_FIRST(&freePagesList);
  803dc5:	a1 48 60 80 00       	mov    0x806048,%eax
  803dca:	89 45 dc             	mov    %eax,-0x24(%ebp)
		LIST_REMOVE(&freePagesList, page_info);
  803dcd:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803dd1:	75 17                	jne    803dea <alloc_block+0x1b9>
  803dd3:	83 ec 04             	sub    $0x4,%esp
  803dd6:	68 0d 52 80 00       	push   $0x80520d
  803ddb:	68 8f 00 00 00       	push   $0x8f
  803de0:	68 d3 51 80 00       	push   $0x8051d3
  803de5:	e8 34 cb ff ff       	call   80091e <_panic>
  803dea:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803ded:	8b 00                	mov    (%eax),%eax
  803def:	85 c0                	test   %eax,%eax
  803df1:	74 10                	je     803e03 <alloc_block+0x1d2>
  803df3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803df6:	8b 00                	mov    (%eax),%eax
  803df8:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803dfb:	8b 52 04             	mov    0x4(%edx),%edx
  803dfe:	89 50 04             	mov    %edx,0x4(%eax)
  803e01:	eb 0b                	jmp    803e0e <alloc_block+0x1dd>
  803e03:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803e06:	8b 40 04             	mov    0x4(%eax),%eax
  803e09:	a3 4c 60 80 00       	mov    %eax,0x80604c
  803e0e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803e11:	8b 40 04             	mov    0x4(%eax),%eax
  803e14:	85 c0                	test   %eax,%eax
  803e16:	74 0f                	je     803e27 <alloc_block+0x1f6>
  803e18:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803e1b:	8b 40 04             	mov    0x4(%eax),%eax
  803e1e:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803e21:	8b 12                	mov    (%edx),%edx
  803e23:	89 10                	mov    %edx,(%eax)
  803e25:	eb 0a                	jmp    803e31 <alloc_block+0x200>
  803e27:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803e2a:	8b 00                	mov    (%eax),%eax
  803e2c:	a3 48 60 80 00       	mov    %eax,0x806048
  803e31:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803e34:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803e3a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803e3d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803e44:	a1 54 60 80 00       	mov    0x806054,%eax
  803e49:	48                   	dec    %eax
  803e4a:	a3 54 60 80 00       	mov    %eax,0x806054
		uint32 page_va = to_page_va(page_info);
  803e4f:	83 ec 0c             	sub    $0xc,%esp
  803e52:	ff 75 dc             	pushl  -0x24(%ebp)
  803e55:	e8 89 fb ff ff       	call   8039e3 <to_page_va>
  803e5a:	83 c4 10             	add    $0x10,%esp
  803e5d:	89 45 d8             	mov    %eax,-0x28(%ebp)

		uint32 page_index = (page_va - dynAllocStart)/ PAGE_SIZE;
  803e60:	a1 64 e0 81 00       	mov    0x81e064,%eax
  803e65:	8b 55 d8             	mov    -0x28(%ebp),%edx
  803e68:	29 c2                	sub    %eax,%edx
  803e6a:	89 d0                	mov    %edx,%eax
  803e6c:	c1 e8 0c             	shr    $0xc,%eax
  803e6f:	89 45 d4             	mov    %eax,-0x2c(%ebp)

		get_page((void*)page_va);
  803e72:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803e75:	83 ec 0c             	sub    $0xc,%esp
  803e78:	50                   	push   %eax
  803e79:	e8 fe dc ff ff       	call   801b7c <get_page>
  803e7e:	83 c4 10             	add    $0x10,%esp


		pageBlockInfoArr[page_index].block_size = size;
  803e81:	8b 45 08             	mov    0x8(%ebp),%eax
  803e84:	89 c2                	mov    %eax,%edx
  803e86:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  803e89:	89 c8                	mov    %ecx,%eax
  803e8b:	01 c0                	add    %eax,%eax
  803e8d:	01 c8                	add    %ecx,%eax
  803e8f:	c1 e0 02             	shl    $0x2,%eax
  803e92:	05 68 60 80 00       	add    $0x806068,%eax
  803e97:	66 89 10             	mov    %dx,(%eax)
		int num_blocks = PAGE_SIZE / size ;
  803e9a:	b8 00 10 00 00       	mov    $0x1000,%eax
  803e9f:	ba 00 00 00 00       	mov    $0x0,%edx
  803ea4:	f7 75 08             	divl   0x8(%ebp)
  803ea7:	89 45 d0             	mov    %eax,-0x30(%ebp)
		pageBlockInfoArr[page_index].num_of_free_blocks= num_blocks - 1 ;
  803eaa:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803ead:	8d 50 ff             	lea    -0x1(%eax),%edx
  803eb0:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  803eb3:	89 c8                	mov    %ecx,%eax
  803eb5:	01 c0                	add    %eax,%eax
  803eb7:	01 c8                	add    %ecx,%eax
  803eb9:	c1 e0 02             	shl    $0x2,%eax
  803ebc:	05 6a 60 80 00       	add    $0x80606a,%eax
  803ec1:	66 89 10             	mov    %dx,(%eax)

		for(int i=1; i< num_blocks; i++){
  803ec4:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
  803ecb:	e9 aa 00 00 00       	jmp    803f7a <alloc_block+0x349>
			struct BlockElement *new_block = (struct BlockElement*)(page_va + i *size);
  803ed0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803ed3:	0f af 45 08          	imul   0x8(%ebp),%eax
  803ed7:	89 c2                	mov    %eax,%edx
  803ed9:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803edc:	01 d0                	add    %edx,%eax
  803ede:	89 45 cc             	mov    %eax,-0x34(%ebp)
			LIST_INSERT_TAIL(&freeBlockLists[list_index], new_block);
  803ee1:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  803ee5:	75 17                	jne    803efe <alloc_block+0x2cd>
  803ee7:	83 ec 04             	sub    $0x4,%esp
  803eea:	68 2c 52 80 00       	push   $0x80522c
  803eef:	68 9d 00 00 00       	push   $0x9d
  803ef4:	68 d3 51 80 00       	push   $0x8051d3
  803ef9:	e8 20 ca ff ff       	call   80091e <_panic>
  803efe:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803f01:	c1 e0 04             	shl    $0x4,%eax
  803f04:	05 84 e0 81 00       	add    $0x81e084,%eax
  803f09:	8b 10                	mov    (%eax),%edx
  803f0b:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803f0e:	89 50 04             	mov    %edx,0x4(%eax)
  803f11:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803f14:	8b 40 04             	mov    0x4(%eax),%eax
  803f17:	85 c0                	test   %eax,%eax
  803f19:	74 14                	je     803f2f <alloc_block+0x2fe>
  803f1b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803f1e:	c1 e0 04             	shl    $0x4,%eax
  803f21:	05 84 e0 81 00       	add    $0x81e084,%eax
  803f26:	8b 00                	mov    (%eax),%eax
  803f28:	8b 55 cc             	mov    -0x34(%ebp),%edx
  803f2b:	89 10                	mov    %edx,(%eax)
  803f2d:	eb 11                	jmp    803f40 <alloc_block+0x30f>
  803f2f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803f32:	c1 e0 04             	shl    $0x4,%eax
  803f35:	8d 90 80 e0 81 00    	lea    0x81e080(%eax),%edx
  803f3b:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803f3e:	89 02                	mov    %eax,(%edx)
  803f40:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803f43:	c1 e0 04             	shl    $0x4,%eax
  803f46:	8d 90 84 e0 81 00    	lea    0x81e084(%eax),%edx
  803f4c:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803f4f:	89 02                	mov    %eax,(%edx)
  803f51:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803f54:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803f5a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803f5d:	c1 e0 04             	shl    $0x4,%eax
  803f60:	05 8c e0 81 00       	add    $0x81e08c,%eax
  803f65:	8b 00                	mov    (%eax),%eax
  803f67:	8d 50 01             	lea    0x1(%eax),%edx
  803f6a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803f6d:	c1 e0 04             	shl    $0x4,%eax
  803f70:	05 8c e0 81 00       	add    $0x81e08c,%eax
  803f75:	89 10                	mov    %edx,(%eax)

		pageBlockInfoArr[page_index].block_size = size;
		int num_blocks = PAGE_SIZE / size ;
		pageBlockInfoArr[page_index].num_of_free_blocks= num_blocks - 1 ;

		for(int i=1; i< num_blocks; i++){
  803f77:	ff 45 f0             	incl   -0x10(%ebp)
  803f7a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803f7d:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  803f80:	0f 8c 4a ff ff ff    	jl     803ed0 <alloc_block+0x29f>
			struct BlockElement *new_block = (struct BlockElement*)(page_va + i *size);
			LIST_INSERT_TAIL(&freeBlockLists[list_index], new_block);
		}
		return(void*)page_va;
  803f86:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803f89:	e9 3d 01 00 00       	jmp    8040cb <alloc_block+0x49a>
	}


	for(int i =list_index+1; i<= LOG2_MAX_SIZE - LOG2_MIN_SIZE; i++){
  803f8e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803f91:	40                   	inc    %eax
  803f92:	89 45 ec             	mov    %eax,-0x14(%ebp)
  803f95:	e9 10 01 00 00       	jmp    8040aa <alloc_block+0x479>

		if(!LIST_EMPTY(&freeBlockLists[i])){
  803f9a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803f9d:	c1 e0 04             	shl    $0x4,%eax
  803fa0:	05 80 e0 81 00       	add    $0x81e080,%eax
  803fa5:	8b 00                	mov    (%eax),%eax
  803fa7:	85 c0                	test   %eax,%eax
  803fa9:	0f 84 f8 00 00 00    	je     8040a7 <alloc_block+0x476>

			struct BlockElement *block = LIST_FIRST(&freeBlockLists[i]);
  803faf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803fb2:	c1 e0 04             	shl    $0x4,%eax
  803fb5:	05 80 e0 81 00       	add    $0x81e080,%eax
  803fba:	8b 00                	mov    (%eax),%eax
  803fbc:	89 45 c8             	mov    %eax,-0x38(%ebp)
			LIST_REMOVE( &freeBlockLists[i], block);
  803fbf:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  803fc3:	75 17                	jne    803fdc <alloc_block+0x3ab>
  803fc5:	83 ec 04             	sub    $0x4,%esp
  803fc8:	68 0d 52 80 00       	push   $0x80520d
  803fcd:	68 a8 00 00 00       	push   $0xa8
  803fd2:	68 d3 51 80 00       	push   $0x8051d3
  803fd7:	e8 42 c9 ff ff       	call   80091e <_panic>
  803fdc:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803fdf:	8b 00                	mov    (%eax),%eax
  803fe1:	85 c0                	test   %eax,%eax
  803fe3:	74 10                	je     803ff5 <alloc_block+0x3c4>
  803fe5:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803fe8:	8b 00                	mov    (%eax),%eax
  803fea:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803fed:	8b 52 04             	mov    0x4(%edx),%edx
  803ff0:	89 50 04             	mov    %edx,0x4(%eax)
  803ff3:	eb 14                	jmp    804009 <alloc_block+0x3d8>
  803ff5:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803ff8:	8b 40 04             	mov    0x4(%eax),%eax
  803ffb:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803ffe:	c1 e2 04             	shl    $0x4,%edx
  804001:	81 c2 84 e0 81 00    	add    $0x81e084,%edx
  804007:	89 02                	mov    %eax,(%edx)
  804009:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80400c:	8b 40 04             	mov    0x4(%eax),%eax
  80400f:	85 c0                	test   %eax,%eax
  804011:	74 0f                	je     804022 <alloc_block+0x3f1>
  804013:	8b 45 c8             	mov    -0x38(%ebp),%eax
  804016:	8b 40 04             	mov    0x4(%eax),%eax
  804019:	8b 55 c8             	mov    -0x38(%ebp),%edx
  80401c:	8b 12                	mov    (%edx),%edx
  80401e:	89 10                	mov    %edx,(%eax)
  804020:	eb 13                	jmp    804035 <alloc_block+0x404>
  804022:	8b 45 c8             	mov    -0x38(%ebp),%eax
  804025:	8b 00                	mov    (%eax),%eax
  804027:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80402a:	c1 e2 04             	shl    $0x4,%edx
  80402d:	81 c2 80 e0 81 00    	add    $0x81e080,%edx
  804033:	89 02                	mov    %eax,(%edx)
  804035:	8b 45 c8             	mov    -0x38(%ebp),%eax
  804038:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80403e:	8b 45 c8             	mov    -0x38(%ebp),%eax
  804041:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  804048:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80404b:	c1 e0 04             	shl    $0x4,%eax
  80404e:	05 8c e0 81 00       	add    $0x81e08c,%eax
  804053:	8b 00                	mov    (%eax),%eax
  804055:	8d 50 ff             	lea    -0x1(%eax),%edx
  804058:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80405b:	c1 e0 04             	shl    $0x4,%eax
  80405e:	05 8c e0 81 00       	add    $0x81e08c,%eax
  804063:	89 10                	mov    %edx,(%eax)

			uint32 page_index = ((uint32)block - dynAllocStart)/ PAGE_SIZE;
  804065:	8b 55 c8             	mov    -0x38(%ebp),%edx
  804068:	a1 64 e0 81 00       	mov    0x81e064,%eax
  80406d:	29 c2                	sub    %eax,%edx
  80406f:	89 d0                	mov    %edx,%eax
  804071:	c1 e8 0c             	shr    $0xc,%eax
  804074:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			pageBlockInfoArr[page_index].num_of_free_blocks-- ;
  804077:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  80407a:	89 d0                	mov    %edx,%eax
  80407c:	01 c0                	add    %eax,%eax
  80407e:	01 d0                	add    %edx,%eax
  804080:	c1 e0 02             	shl    $0x2,%eax
  804083:	05 6a 60 80 00       	add    $0x80606a,%eax
  804088:	66 8b 00             	mov    (%eax),%ax
  80408b:	8d 50 ff             	lea    -0x1(%eax),%edx
  80408e:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  804091:	89 c8                	mov    %ecx,%eax
  804093:	01 c0                	add    %eax,%eax
  804095:	01 c8                	add    %ecx,%eax
  804097:	c1 e0 02             	shl    $0x2,%eax
  80409a:	05 6a 60 80 00       	add    $0x80606a,%eax
  80409f:	66 89 10             	mov    %dx,(%eax)

			return (void*)block;
  8040a2:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8040a5:	eb 24                	jmp    8040cb <alloc_block+0x49a>
		}
		return(void*)page_va;
	}


	for(int i =list_index+1; i<= LOG2_MAX_SIZE - LOG2_MIN_SIZE; i++){
  8040a7:	ff 45 ec             	incl   -0x14(%ebp)
  8040aa:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  8040ae:	0f 8e e6 fe ff ff    	jle    803f9a <alloc_block+0x369>

			return (void*)block;
		}
	}

	panic("alloc_block: out of memory! ");
  8040b4:	83 ec 04             	sub    $0x4,%esp
  8040b7:	68 4f 52 80 00       	push   $0x80524f
  8040bc:	68 b1 00 00 00       	push   $0xb1
  8040c1:	68 d3 51 80 00       	push   $0x8051d3
  8040c6:	e8 53 c8 ff ff       	call   80091e <_panic>

	//Comment the following line
	//panic("alloc_block() Not implemented yet");

	//TODO: [PROJECT'25.BONUS#1] DYNAMIC ALLOCATOR - block if no free block
}
  8040cb:	c9                   	leave  
  8040cc:	c3                   	ret    

008040cd <free_block>:

//===========================
// [4] FREE BLOCK:
//===========================
void free_block(void *va)
{
  8040cd:	55                   	push   %ebp
  8040ce:	89 e5                	mov    %esp,%ebp
  8040d0:	83 ec 38             	sub    $0x38,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert((uint32)va >= dynAllocStart && (uint32)va < dynAllocEnd);
  8040d3:	8b 55 08             	mov    0x8(%ebp),%edx
  8040d6:	a1 64 e0 81 00       	mov    0x81e064,%eax
  8040db:	39 c2                	cmp    %eax,%edx
  8040dd:	72 0c                	jb     8040eb <free_block+0x1e>
  8040df:	8b 55 08             	mov    0x8(%ebp),%edx
  8040e2:	a1 40 60 80 00       	mov    0x806040,%eax
  8040e7:	39 c2                	cmp    %eax,%edx
  8040e9:	72 19                	jb     804104 <free_block+0x37>
  8040eb:	68 6c 52 80 00       	push   $0x80526c
  8040f0:	68 be 51 80 00       	push   $0x8051be
  8040f5:	68 c3 00 00 00       	push   $0xc3
  8040fa:	68 d3 51 80 00       	push   $0x8051d3
  8040ff:	e8 1a c8 ff ff       	call   80091e <_panic>
	//==================================================================================

	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #4 free_block
	//Your code is here

	uint32 page_index=((uint32)va - dynAllocStart)/ PAGE_SIZE;
  804104:	8b 55 08             	mov    0x8(%ebp),%edx
  804107:	a1 64 e0 81 00       	mov    0x81e064,%eax
  80410c:	29 c2                	sub    %eax,%edx
  80410e:	89 d0                	mov    %edx,%eax
  804110:	c1 e8 0c             	shr    $0xc,%eax
  804113:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 block_size = pageBlockInfoArr[page_index].block_size;
  804116:	8b 55 f0             	mov    -0x10(%ebp),%edx
  804119:	89 d0                	mov    %edx,%eax
  80411b:	01 c0                	add    %eax,%eax
  80411d:	01 d0                	add    %edx,%eax
  80411f:	c1 e0 02             	shl    $0x2,%eax
  804122:	05 68 60 80 00       	add    $0x806068,%eax
  804127:	8b 00                	mov    (%eax),%eax
  804129:	0f b7 c0             	movzwl %ax,%eax
  80412c:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if(block_size == 0){
  80412f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  804133:	75 17                	jne    80414c <free_block+0x7f>
		panic("page is empty(already not allocated)");
  804135:	83 ec 04             	sub    $0x4,%esp
  804138:	68 a4 52 80 00       	push   $0x8052a4
  80413d:	68 cf 00 00 00       	push   $0xcf
  804142:	68 d3 51 80 00       	push   $0x8051d3
  804147:	e8 d2 c7 ff ff       	call   80091e <_panic>
	}

	int list_index = log2(block_size) - LOG2_MIN_SIZE;
  80414c:	83 ec 0c             	sub    $0xc,%esp
  80414f:	ff 75 ec             	pushl  -0x14(%ebp)
  804152:	e8 d8 f8 ff ff       	call   803a2f <log2>
  804157:	83 c4 10             	add    $0x10,%esp
  80415a:	83 e8 03             	sub    $0x3,%eax
  80415d:	89 45 e8             	mov    %eax,-0x18(%ebp)
	// mn va l block "elta7weel mn virtual l phy hna"
	struct BlockElement *block = (struct BlockElement *)va;
  804160:	8b 45 08             	mov    0x8(%ebp),%eax
  804163:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	LIST_INSERT_TAIL(&freeBlockLists[list_index], block);
  804166:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80416a:	75 17                	jne    804183 <free_block+0xb6>
  80416c:	83 ec 04             	sub    $0x4,%esp
  80416f:	68 2c 52 80 00       	push   $0x80522c
  804174:	68 d5 00 00 00       	push   $0xd5
  804179:	68 d3 51 80 00       	push   $0x8051d3
  80417e:	e8 9b c7 ff ff       	call   80091e <_panic>
  804183:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804186:	c1 e0 04             	shl    $0x4,%eax
  804189:	05 84 e0 81 00       	add    $0x81e084,%eax
  80418e:	8b 10                	mov    (%eax),%edx
  804190:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804193:	89 50 04             	mov    %edx,0x4(%eax)
  804196:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804199:	8b 40 04             	mov    0x4(%eax),%eax
  80419c:	85 c0                	test   %eax,%eax
  80419e:	74 14                	je     8041b4 <free_block+0xe7>
  8041a0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8041a3:	c1 e0 04             	shl    $0x4,%eax
  8041a6:	05 84 e0 81 00       	add    $0x81e084,%eax
  8041ab:	8b 00                	mov    (%eax),%eax
  8041ad:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8041b0:	89 10                	mov    %edx,(%eax)
  8041b2:	eb 11                	jmp    8041c5 <free_block+0xf8>
  8041b4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8041b7:	c1 e0 04             	shl    $0x4,%eax
  8041ba:	8d 90 80 e0 81 00    	lea    0x81e080(%eax),%edx
  8041c0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8041c3:	89 02                	mov    %eax,(%edx)
  8041c5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8041c8:	c1 e0 04             	shl    $0x4,%eax
  8041cb:	8d 90 84 e0 81 00    	lea    0x81e084(%eax),%edx
  8041d1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8041d4:	89 02                	mov    %eax,(%edx)
  8041d6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8041d9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8041df:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8041e2:	c1 e0 04             	shl    $0x4,%eax
  8041e5:	05 8c e0 81 00       	add    $0x81e08c,%eax
  8041ea:	8b 00                	mov    (%eax),%eax
  8041ec:	8d 50 01             	lea    0x1(%eax),%edx
  8041ef:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8041f2:	c1 e0 04             	shl    $0x4,%eax
  8041f5:	05 8c e0 81 00       	add    $0x81e08c,%eax
  8041fa:	89 10                	mov    %edx,(%eax)
	// b3d ma wdytha fy el freeBlockLists hzwed elfree elly fy el array 1
	pageBlockInfoArr[page_index].num_of_free_blocks++;
  8041fc:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8041ff:	89 d0                	mov    %edx,%eax
  804201:	01 c0                	add    %eax,%eax
  804203:	01 d0                	add    %edx,%eax
  804205:	c1 e0 02             	shl    $0x2,%eax
  804208:	05 6a 60 80 00       	add    $0x80606a,%eax
  80420d:	66 8b 00             	mov    (%eax),%ax
  804210:	8d 50 01             	lea    0x1(%eax),%edx
  804213:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  804216:	89 c8                	mov    %ecx,%eax
  804218:	01 c0                	add    %eax,%eax
  80421a:	01 c8                	add    %ecx,%eax
  80421c:	c1 e0 02             	shl    $0x2,%eax
  80421f:	05 6a 60 80 00       	add    $0x80606a,%eax
  804224:	66 89 10             	mov    %dx,(%eax)
	int blocks_number = PAGE_SIZE / block_size;
  804227:	b8 00 10 00 00       	mov    $0x1000,%eax
  80422c:	ba 00 00 00 00       	mov    $0x0,%edx
  804231:	f7 75 ec             	divl   -0x14(%ebp)
  804234:	89 45 e0             	mov    %eax,-0x20(%ebp)
	if(pageBlockInfoArr[page_index].num_of_free_blocks == blocks_number){
  804237:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80423a:	89 d0                	mov    %edx,%eax
  80423c:	01 c0                	add    %eax,%eax
  80423e:	01 d0                	add    %edx,%eax
  804240:	c1 e0 02             	shl    $0x2,%eax
  804243:	05 6a 60 80 00       	add    $0x80606a,%eax
  804248:	66 8b 00             	mov    (%eax),%ax
  80424b:	0f b7 c0             	movzwl %ax,%eax
  80424e:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  804251:	0f 85 d3 01 00 00    	jne    80442a <free_block+0x35d>
		struct BlockElement *itr = LIST_FIRST(&freeBlockLists[list_index]);
  804257:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80425a:	c1 e0 04             	shl    $0x4,%eax
  80425d:	05 80 e0 81 00       	add    $0x81e080,%eax
  804262:	8b 00                	mov    (%eax),%eax
  804264:	89 45 f4             	mov    %eax,-0xc(%ebp)
		while(itr != NULL){
  804267:	e9 f1 00 00 00       	jmp    80435d <free_block+0x290>
			//lw ms7to el pointer mydy34 ->
			struct BlockElement *next = LIST_NEXT(itr);
  80426c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80426f:	8b 00                	mov    (%eax),%eax
  804271:	89 45 dc             	mov    %eax,-0x24(%ebp)
			uint32 page_beginning_address= dynAllocStart + page_index * PAGE_SIZE;
  804274:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804277:	c1 e0 0c             	shl    $0xc,%eax
  80427a:	89 c2                	mov    %eax,%edx
  80427c:	a1 64 e0 81 00       	mov    0x81e064,%eax
  804281:	01 d0                	add    %edx,%eax
  804283:	89 45 d8             	mov    %eax,-0x28(%ebp)
			uint32 page_end_address = dynAllocStart + (page_index +1 )* PAGE_SIZE;
  804286:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804289:	40                   	inc    %eax
  80428a:	c1 e0 0c             	shl    $0xc,%eax
  80428d:	89 c2                	mov    %eax,%edx
  80428f:	a1 64 e0 81 00       	mov    0x81e064,%eax
  804294:	01 d0                	add    %edx,%eax
  804296:	89 45 d4             	mov    %eax,-0x2c(%ebp)

			if((uint32)itr >= page_beginning_address && (uint32)itr < page_end_address){
  804299:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80429c:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  80429f:	0f 82 b8 00 00 00    	jb     80435d <free_block+0x290>
  8042a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8042a8:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8042ab:	0f 83 ac 00 00 00    	jae    80435d <free_block+0x290>
				LIST_REMOVE(&freeBlockLists[list_index], itr);
  8042b1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8042b5:	75 17                	jne    8042ce <free_block+0x201>
  8042b7:	83 ec 04             	sub    $0x4,%esp
  8042ba:	68 0d 52 80 00       	push   $0x80520d
  8042bf:	68 e2 00 00 00       	push   $0xe2
  8042c4:	68 d3 51 80 00       	push   $0x8051d3
  8042c9:	e8 50 c6 ff ff       	call   80091e <_panic>
  8042ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8042d1:	8b 00                	mov    (%eax),%eax
  8042d3:	85 c0                	test   %eax,%eax
  8042d5:	74 10                	je     8042e7 <free_block+0x21a>
  8042d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8042da:	8b 00                	mov    (%eax),%eax
  8042dc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8042df:	8b 52 04             	mov    0x4(%edx),%edx
  8042e2:	89 50 04             	mov    %edx,0x4(%eax)
  8042e5:	eb 14                	jmp    8042fb <free_block+0x22e>
  8042e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8042ea:	8b 40 04             	mov    0x4(%eax),%eax
  8042ed:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8042f0:	c1 e2 04             	shl    $0x4,%edx
  8042f3:	81 c2 84 e0 81 00    	add    $0x81e084,%edx
  8042f9:	89 02                	mov    %eax,(%edx)
  8042fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8042fe:	8b 40 04             	mov    0x4(%eax),%eax
  804301:	85 c0                	test   %eax,%eax
  804303:	74 0f                	je     804314 <free_block+0x247>
  804305:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804308:	8b 40 04             	mov    0x4(%eax),%eax
  80430b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80430e:	8b 12                	mov    (%edx),%edx
  804310:	89 10                	mov    %edx,(%eax)
  804312:	eb 13                	jmp    804327 <free_block+0x25a>
  804314:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804317:	8b 00                	mov    (%eax),%eax
  804319:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80431c:	c1 e2 04             	shl    $0x4,%edx
  80431f:	81 c2 80 e0 81 00    	add    $0x81e080,%edx
  804325:	89 02                	mov    %eax,(%edx)
  804327:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80432a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  804330:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804333:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80433a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80433d:	c1 e0 04             	shl    $0x4,%eax
  804340:	05 8c e0 81 00       	add    $0x81e08c,%eax
  804345:	8b 00                	mov    (%eax),%eax
  804347:	8d 50 ff             	lea    -0x1(%eax),%edx
  80434a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80434d:	c1 e0 04             	shl    $0x4,%eax
  804350:	05 8c e0 81 00       	add    $0x81e08c,%eax
  804355:	89 10                	mov    %edx,(%eax)
				//y5o4 3la elly b3do
				itr = next;
  804357:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80435a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// b3d ma wdytha fy el freeBlockLists hzwed elfree elly fy el array 1
	pageBlockInfoArr[page_index].num_of_free_blocks++;
	int blocks_number = PAGE_SIZE / block_size;
	if(pageBlockInfoArr[page_index].num_of_free_blocks == blocks_number){
		struct BlockElement *itr = LIST_FIRST(&freeBlockLists[list_index]);
		while(itr != NULL){
  80435d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  804361:	0f 85 05 ff ff ff    	jne    80426c <free_block+0x19f>
				LIST_REMOVE(&freeBlockLists[list_index], itr);
				//y5o4 3la elly b3do
				itr = next;
			}
		}
		pageBlockInfoArr[page_index].block_size=0;
  804367:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80436a:	89 d0                	mov    %edx,%eax
  80436c:	01 c0                	add    %eax,%eax
  80436e:	01 d0                	add    %edx,%eax
  804370:	c1 e0 02             	shl    $0x2,%eax
  804373:	05 68 60 80 00       	add    $0x806068,%eax
  804378:	66 c7 00 00 00       	movw   $0x0,(%eax)
		pageBlockInfoArr[page_index].num_of_free_blocks=0;
  80437d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  804380:	89 d0                	mov    %edx,%eax
  804382:	01 c0                	add    %eax,%eax
  804384:	01 d0                	add    %edx,%eax
  804386:	c1 e0 02             	shl    $0x2,%eax
  804389:	05 6a 60 80 00       	add    $0x80606a,%eax
  80438e:	66 c7 00 00 00       	movw   $0x0,(%eax)

		struct PageInfoElement *page_info = &pageBlockInfoArr[page_index];
  804393:	8b 55 f0             	mov    -0x10(%ebp),%edx
  804396:	89 d0                	mov    %edx,%eax
  804398:	01 c0                	add    %eax,%eax
  80439a:	01 d0                	add    %edx,%eax
  80439c:	c1 e0 02             	shl    $0x2,%eax
  80439f:	05 60 60 80 00       	add    $0x806060,%eax
  8043a4:	89 45 d0             	mov    %eax,-0x30(%ebp)
		LIST_INSERT_TAIL(&freePagesList, page_info);
  8043a7:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  8043ab:	75 17                	jne    8043c4 <free_block+0x2f7>
  8043ad:	83 ec 04             	sub    $0x4,%esp
  8043b0:	68 2c 52 80 00       	push   $0x80522c
  8043b5:	68 eb 00 00 00       	push   $0xeb
  8043ba:	68 d3 51 80 00       	push   $0x8051d3
  8043bf:	e8 5a c5 ff ff       	call   80091e <_panic>
  8043c4:	8b 15 4c 60 80 00    	mov    0x80604c,%edx
  8043ca:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8043cd:	89 50 04             	mov    %edx,0x4(%eax)
  8043d0:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8043d3:	8b 40 04             	mov    0x4(%eax),%eax
  8043d6:	85 c0                	test   %eax,%eax
  8043d8:	74 0c                	je     8043e6 <free_block+0x319>
  8043da:	a1 4c 60 80 00       	mov    0x80604c,%eax
  8043df:	8b 55 d0             	mov    -0x30(%ebp),%edx
  8043e2:	89 10                	mov    %edx,(%eax)
  8043e4:	eb 08                	jmp    8043ee <free_block+0x321>
  8043e6:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8043e9:	a3 48 60 80 00       	mov    %eax,0x806048
  8043ee:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8043f1:	a3 4c 60 80 00       	mov    %eax,0x80604c
  8043f6:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8043f9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8043ff:	a1 54 60 80 00       	mov    0x806054,%eax
  804404:	40                   	inc    %eax
  804405:	a3 54 60 80 00       	mov    %eax,0x806054
		uint32 page_va = to_page_va(page_info);
  80440a:	83 ec 0c             	sub    $0xc,%esp
  80440d:	ff 75 d0             	pushl  -0x30(%ebp)
  804410:	e8 ce f5 ff ff       	call   8039e3 <to_page_va>
  804415:	83 c4 10             	add    $0x10,%esp
  804418:	89 45 cc             	mov    %eax,-0x34(%ebp)
		return_page((void *)page_va);
  80441b:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80441e:	83 ec 0c             	sub    $0xc,%esp
  804421:	50                   	push   %eax
  804422:	e8 9e d7 ff ff       	call   801bc5 <return_page>
  804427:	83 c4 10             	add    $0x10,%esp
	}


	//Comment the following line
	//panic("free_block() Not implemented yet");
}
  80442a:	90                   	nop
  80442b:	c9                   	leave  
  80442c:	c3                   	ret    

0080442d <realloc_block>:

//===========================
// [1] REALLOCATE BLOCK:
//===========================
void *realloc_block(void* va, uint32 new_size)
{
  80442d:	55                   	push   %ebp
  80442e:	89 e5                	mov    %esp,%ebp
  804430:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.BONUS#2] KERNEL REALLOC - realloc_block
	//Your code is here
	//Comment the following line
	panic("realloc_block() Not implemented yet");
  804433:	83 ec 04             	sub    $0x4,%esp
  804436:	68 cc 52 80 00       	push   $0x8052cc
  80443b:	68 01 01 00 00       	push   $0x101
  804440:	68 d3 51 80 00       	push   $0x8051d3
  804445:	e8 d4 c4 ff ff       	call   80091e <_panic>

0080444a <init_uspinlock>:
#include "inc/uspinlock.h"

extern volatile struct Env *myEnv;

void init_uspinlock(struct uspinlock *lk, char *name, bool isOpened)
{
  80444a:	55                   	push   %ebp
  80444b:	89 e5                	mov    %esp,%ebp
  80444d:	83 ec 08             	sub    $0x8,%esp
	assert(isOpened == 0 || isOpened == 1);
  804450:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  804454:	74 1c                	je     804472 <init_uspinlock+0x28>
  804456:	83 7d 10 01          	cmpl   $0x1,0x10(%ebp)
  80445a:	74 16                	je     804472 <init_uspinlock+0x28>
  80445c:	68 f0 52 80 00       	push   $0x8052f0
  804461:	68 0f 53 80 00       	push   $0x80530f
  804466:	6a 10                	push   $0x10
  804468:	68 24 53 80 00       	push   $0x805324
  80446d:	e8 ac c4 ff ff       	call   80091e <_panic>
	strcpy(lk->name, name);
  804472:	8b 45 08             	mov    0x8(%ebp),%eax
  804475:	83 c0 04             	add    $0x4,%eax
  804478:	83 ec 08             	sub    $0x8,%esp
  80447b:	ff 75 0c             	pushl  0xc(%ebp)
  80447e:	50                   	push   %eax
  80447f:	e8 90 ce ff ff       	call   801314 <strcpy>
  804484:	83 c4 10             	add    $0x10,%esp
	lk->locked = (1 - isOpened);
  804487:	b8 01 00 00 00       	mov    $0x1,%eax
  80448c:	2b 45 10             	sub    0x10(%ebp),%eax
  80448f:	89 c2                	mov    %eax,%edx
  804491:	8b 45 08             	mov    0x8(%ebp),%eax
  804494:	89 10                	mov    %edx,(%eax)
}
  804496:	90                   	nop
  804497:	c9                   	leave  
  804498:	c3                   	ret    

00804499 <acquire_uspinlock>:
// Acquire the lock.
// Loops (spins) until the lock is acquired.
// Holding a lock for a long time may cause
// other CPUs to waste time spinning to acquire it.
void acquire_uspinlock(struct uspinlock *lk)
{
  804499:	55                   	push   %ebp
  80449a:	89 e5                	mov    %esp,%ebp
  80449c:	83 ec 18             	sub    $0x18,%esp
	// The xchg is atomic.
	while(xchg(&lk->locked, 1) != 0) ;
  80449f:	90                   	nop
  8044a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8044a3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8044a6:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
xchg(volatile uint32 *addr, uint32 newval)
{
  uint32 result;

  // The + in "+m" denotes a read-modify-write operand.
  __asm __volatile("lock; xchgl %0, %1" :
  8044ad:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8044b0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8044b3:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  8044b6:	f0 87 02             	lock xchg %eax,(%edx)
  8044b9:	89 45 ec             	mov    %eax,-0x14(%ebp)
               "+m" (*addr), "=a" (result) :
               "1" (newval) :
               "cc");
  return result;
  8044bc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8044bf:	85 c0                	test   %eax,%eax
  8044c1:	75 dd                	jne    8044a0 <acquire_uspinlock+0x7>

	cprintf("[%d: %s] ACQUIRED spinlock [%s]\n", myEnv->env_id, myEnv->prog_name, lk->name);
  8044c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8044c6:	8d 48 04             	lea    0x4(%eax),%ecx
  8044c9:	a1 24 60 80 00       	mov    0x806024,%eax
  8044ce:	8d 50 20             	lea    0x20(%eax),%edx
  8044d1:	a1 24 60 80 00       	mov    0x806024,%eax
  8044d6:	8b 40 10             	mov    0x10(%eax),%eax
  8044d9:	51                   	push   %ecx
  8044da:	52                   	push   %edx
  8044db:	50                   	push   %eax
  8044dc:	68 34 53 80 00       	push   $0x805334
  8044e1:	e8 06 c7 ff ff       	call   800bec <cprintf>
  8044e6:	83 c4 10             	add    $0x10,%esp

	// Tell the C compiler and the processor to not move loads or stores
	// past this point, to ensure that the critical section's memory
	// references happen after the lock is acquired.
	__sync_synchronize();
  8044e9:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
}
  8044ee:	90                   	nop
  8044ef:	c9                   	leave  
  8044f0:	c3                   	ret    

008044f1 <release_uspinlock>:

// Release the lock.
void release_uspinlock(struct uspinlock *lk)
{
  8044f1:	55                   	push   %ebp
  8044f2:	89 e5                	mov    %esp,%ebp
  8044f4:	83 ec 08             	sub    $0x8,%esp
	if(!(lk->locked))
  8044f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8044fa:	8b 00                	mov    (%eax),%eax
  8044fc:	85 c0                	test   %eax,%eax
  8044fe:	75 18                	jne    804518 <release_uspinlock+0x27>
	{
		panic("release: lock \"%s\" is not held!", lk->name);
  804500:	8b 45 08             	mov    0x8(%ebp),%eax
  804503:	83 c0 04             	add    $0x4,%eax
  804506:	50                   	push   %eax
  804507:	68 58 53 80 00       	push   $0x805358
  80450c:	6a 2b                	push   $0x2b
  80450e:	68 24 53 80 00       	push   $0x805324
  804513:	e8 06 c4 ff ff       	call   80091e <_panic>
	// Tell the C compiler and the processor to not move loads or stores
	// past this point, to ensure that all the stores in the critical
	// section are visible to other cores before the lock is released.
	// Both the C compiler and the hardware may re-order loads and
	// stores; __sync_synchronize() tells them both not to.
	__sync_synchronize();
  804518:	f0 83 0c 24 00       	lock orl $0x0,(%esp)

	// Release the lock, equivalent to lk->locked = 0.
	// This code can't use a C assignment, since it might
	// not be atomic. A real OS would use C atomics here.
	asm volatile("movl $0, %0" : "+m" (lk->locked) : );
  80451d:	8b 45 08             	mov    0x8(%ebp),%eax
  804520:	8b 55 08             	mov    0x8(%ebp),%edx
  804523:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	cprintf("[%d: %s] RELEASED spinlock [%s]\n", myEnv->env_id, myEnv->prog_name, lk->name);
  804529:	8b 45 08             	mov    0x8(%ebp),%eax
  80452c:	8d 48 04             	lea    0x4(%eax),%ecx
  80452f:	a1 24 60 80 00       	mov    0x806024,%eax
  804534:	8d 50 20             	lea    0x20(%eax),%edx
  804537:	a1 24 60 80 00       	mov    0x806024,%eax
  80453c:	8b 40 10             	mov    0x10(%eax),%eax
  80453f:	51                   	push   %ecx
  804540:	52                   	push   %edx
  804541:	50                   	push   %eax
  804542:	68 78 53 80 00       	push   $0x805378
  804547:	e8 a0 c6 ff ff       	call   800bec <cprintf>
  80454c:	83 c4 10             	add    $0x10,%esp
}
  80454f:	90                   	nop
  804550:	c9                   	leave  
  804551:	c3                   	ret    
  804552:	66 90                	xchg   %ax,%ax

00804554 <__udivdi3>:
  804554:	55                   	push   %ebp
  804555:	57                   	push   %edi
  804556:	56                   	push   %esi
  804557:	53                   	push   %ebx
  804558:	83 ec 1c             	sub    $0x1c,%esp
  80455b:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80455f:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  804563:	8b 7c 24 38          	mov    0x38(%esp),%edi
  804567:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80456b:	89 ca                	mov    %ecx,%edx
  80456d:	89 f8                	mov    %edi,%eax
  80456f:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  804573:	85 f6                	test   %esi,%esi
  804575:	75 2d                	jne    8045a4 <__udivdi3+0x50>
  804577:	39 cf                	cmp    %ecx,%edi
  804579:	77 65                	ja     8045e0 <__udivdi3+0x8c>
  80457b:	89 fd                	mov    %edi,%ebp
  80457d:	85 ff                	test   %edi,%edi
  80457f:	75 0b                	jne    80458c <__udivdi3+0x38>
  804581:	b8 01 00 00 00       	mov    $0x1,%eax
  804586:	31 d2                	xor    %edx,%edx
  804588:	f7 f7                	div    %edi
  80458a:	89 c5                	mov    %eax,%ebp
  80458c:	31 d2                	xor    %edx,%edx
  80458e:	89 c8                	mov    %ecx,%eax
  804590:	f7 f5                	div    %ebp
  804592:	89 c1                	mov    %eax,%ecx
  804594:	89 d8                	mov    %ebx,%eax
  804596:	f7 f5                	div    %ebp
  804598:	89 cf                	mov    %ecx,%edi
  80459a:	89 fa                	mov    %edi,%edx
  80459c:	83 c4 1c             	add    $0x1c,%esp
  80459f:	5b                   	pop    %ebx
  8045a0:	5e                   	pop    %esi
  8045a1:	5f                   	pop    %edi
  8045a2:	5d                   	pop    %ebp
  8045a3:	c3                   	ret    
  8045a4:	39 ce                	cmp    %ecx,%esi
  8045a6:	77 28                	ja     8045d0 <__udivdi3+0x7c>
  8045a8:	0f bd fe             	bsr    %esi,%edi
  8045ab:	83 f7 1f             	xor    $0x1f,%edi
  8045ae:	75 40                	jne    8045f0 <__udivdi3+0x9c>
  8045b0:	39 ce                	cmp    %ecx,%esi
  8045b2:	72 0a                	jb     8045be <__udivdi3+0x6a>
  8045b4:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8045b8:	0f 87 9e 00 00 00    	ja     80465c <__udivdi3+0x108>
  8045be:	b8 01 00 00 00       	mov    $0x1,%eax
  8045c3:	89 fa                	mov    %edi,%edx
  8045c5:	83 c4 1c             	add    $0x1c,%esp
  8045c8:	5b                   	pop    %ebx
  8045c9:	5e                   	pop    %esi
  8045ca:	5f                   	pop    %edi
  8045cb:	5d                   	pop    %ebp
  8045cc:	c3                   	ret    
  8045cd:	8d 76 00             	lea    0x0(%esi),%esi
  8045d0:	31 ff                	xor    %edi,%edi
  8045d2:	31 c0                	xor    %eax,%eax
  8045d4:	89 fa                	mov    %edi,%edx
  8045d6:	83 c4 1c             	add    $0x1c,%esp
  8045d9:	5b                   	pop    %ebx
  8045da:	5e                   	pop    %esi
  8045db:	5f                   	pop    %edi
  8045dc:	5d                   	pop    %ebp
  8045dd:	c3                   	ret    
  8045de:	66 90                	xchg   %ax,%ax
  8045e0:	89 d8                	mov    %ebx,%eax
  8045e2:	f7 f7                	div    %edi
  8045e4:	31 ff                	xor    %edi,%edi
  8045e6:	89 fa                	mov    %edi,%edx
  8045e8:	83 c4 1c             	add    $0x1c,%esp
  8045eb:	5b                   	pop    %ebx
  8045ec:	5e                   	pop    %esi
  8045ed:	5f                   	pop    %edi
  8045ee:	5d                   	pop    %ebp
  8045ef:	c3                   	ret    
  8045f0:	bd 20 00 00 00       	mov    $0x20,%ebp
  8045f5:	89 eb                	mov    %ebp,%ebx
  8045f7:	29 fb                	sub    %edi,%ebx
  8045f9:	89 f9                	mov    %edi,%ecx
  8045fb:	d3 e6                	shl    %cl,%esi
  8045fd:	89 c5                	mov    %eax,%ebp
  8045ff:	88 d9                	mov    %bl,%cl
  804601:	d3 ed                	shr    %cl,%ebp
  804603:	89 e9                	mov    %ebp,%ecx
  804605:	09 f1                	or     %esi,%ecx
  804607:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80460b:	89 f9                	mov    %edi,%ecx
  80460d:	d3 e0                	shl    %cl,%eax
  80460f:	89 c5                	mov    %eax,%ebp
  804611:	89 d6                	mov    %edx,%esi
  804613:	88 d9                	mov    %bl,%cl
  804615:	d3 ee                	shr    %cl,%esi
  804617:	89 f9                	mov    %edi,%ecx
  804619:	d3 e2                	shl    %cl,%edx
  80461b:	8b 44 24 08          	mov    0x8(%esp),%eax
  80461f:	88 d9                	mov    %bl,%cl
  804621:	d3 e8                	shr    %cl,%eax
  804623:	09 c2                	or     %eax,%edx
  804625:	89 d0                	mov    %edx,%eax
  804627:	89 f2                	mov    %esi,%edx
  804629:	f7 74 24 0c          	divl   0xc(%esp)
  80462d:	89 d6                	mov    %edx,%esi
  80462f:	89 c3                	mov    %eax,%ebx
  804631:	f7 e5                	mul    %ebp
  804633:	39 d6                	cmp    %edx,%esi
  804635:	72 19                	jb     804650 <__udivdi3+0xfc>
  804637:	74 0b                	je     804644 <__udivdi3+0xf0>
  804639:	89 d8                	mov    %ebx,%eax
  80463b:	31 ff                	xor    %edi,%edi
  80463d:	e9 58 ff ff ff       	jmp    80459a <__udivdi3+0x46>
  804642:	66 90                	xchg   %ax,%ax
  804644:	8b 54 24 08          	mov    0x8(%esp),%edx
  804648:	89 f9                	mov    %edi,%ecx
  80464a:	d3 e2                	shl    %cl,%edx
  80464c:	39 c2                	cmp    %eax,%edx
  80464e:	73 e9                	jae    804639 <__udivdi3+0xe5>
  804650:	8d 43 ff             	lea    -0x1(%ebx),%eax
  804653:	31 ff                	xor    %edi,%edi
  804655:	e9 40 ff ff ff       	jmp    80459a <__udivdi3+0x46>
  80465a:	66 90                	xchg   %ax,%ax
  80465c:	31 c0                	xor    %eax,%eax
  80465e:	e9 37 ff ff ff       	jmp    80459a <__udivdi3+0x46>
  804663:	90                   	nop

00804664 <__umoddi3>:
  804664:	55                   	push   %ebp
  804665:	57                   	push   %edi
  804666:	56                   	push   %esi
  804667:	53                   	push   %ebx
  804668:	83 ec 1c             	sub    $0x1c,%esp
  80466b:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80466f:	8b 74 24 34          	mov    0x34(%esp),%esi
  804673:	8b 7c 24 38          	mov    0x38(%esp),%edi
  804677:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80467b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80467f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  804683:	89 f3                	mov    %esi,%ebx
  804685:	89 fa                	mov    %edi,%edx
  804687:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80468b:	89 34 24             	mov    %esi,(%esp)
  80468e:	85 c0                	test   %eax,%eax
  804690:	75 1a                	jne    8046ac <__umoddi3+0x48>
  804692:	39 f7                	cmp    %esi,%edi
  804694:	0f 86 a2 00 00 00    	jbe    80473c <__umoddi3+0xd8>
  80469a:	89 c8                	mov    %ecx,%eax
  80469c:	89 f2                	mov    %esi,%edx
  80469e:	f7 f7                	div    %edi
  8046a0:	89 d0                	mov    %edx,%eax
  8046a2:	31 d2                	xor    %edx,%edx
  8046a4:	83 c4 1c             	add    $0x1c,%esp
  8046a7:	5b                   	pop    %ebx
  8046a8:	5e                   	pop    %esi
  8046a9:	5f                   	pop    %edi
  8046aa:	5d                   	pop    %ebp
  8046ab:	c3                   	ret    
  8046ac:	39 f0                	cmp    %esi,%eax
  8046ae:	0f 87 ac 00 00 00    	ja     804760 <__umoddi3+0xfc>
  8046b4:	0f bd e8             	bsr    %eax,%ebp
  8046b7:	83 f5 1f             	xor    $0x1f,%ebp
  8046ba:	0f 84 ac 00 00 00    	je     80476c <__umoddi3+0x108>
  8046c0:	bf 20 00 00 00       	mov    $0x20,%edi
  8046c5:	29 ef                	sub    %ebp,%edi
  8046c7:	89 fe                	mov    %edi,%esi
  8046c9:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8046cd:	89 e9                	mov    %ebp,%ecx
  8046cf:	d3 e0                	shl    %cl,%eax
  8046d1:	89 d7                	mov    %edx,%edi
  8046d3:	89 f1                	mov    %esi,%ecx
  8046d5:	d3 ef                	shr    %cl,%edi
  8046d7:	09 c7                	or     %eax,%edi
  8046d9:	89 e9                	mov    %ebp,%ecx
  8046db:	d3 e2                	shl    %cl,%edx
  8046dd:	89 14 24             	mov    %edx,(%esp)
  8046e0:	89 d8                	mov    %ebx,%eax
  8046e2:	d3 e0                	shl    %cl,%eax
  8046e4:	89 c2                	mov    %eax,%edx
  8046e6:	8b 44 24 08          	mov    0x8(%esp),%eax
  8046ea:	d3 e0                	shl    %cl,%eax
  8046ec:	89 44 24 04          	mov    %eax,0x4(%esp)
  8046f0:	8b 44 24 08          	mov    0x8(%esp),%eax
  8046f4:	89 f1                	mov    %esi,%ecx
  8046f6:	d3 e8                	shr    %cl,%eax
  8046f8:	09 d0                	or     %edx,%eax
  8046fa:	d3 eb                	shr    %cl,%ebx
  8046fc:	89 da                	mov    %ebx,%edx
  8046fe:	f7 f7                	div    %edi
  804700:	89 d3                	mov    %edx,%ebx
  804702:	f7 24 24             	mull   (%esp)
  804705:	89 c6                	mov    %eax,%esi
  804707:	89 d1                	mov    %edx,%ecx
  804709:	39 d3                	cmp    %edx,%ebx
  80470b:	0f 82 87 00 00 00    	jb     804798 <__umoddi3+0x134>
  804711:	0f 84 91 00 00 00    	je     8047a8 <__umoddi3+0x144>
  804717:	8b 54 24 04          	mov    0x4(%esp),%edx
  80471b:	29 f2                	sub    %esi,%edx
  80471d:	19 cb                	sbb    %ecx,%ebx
  80471f:	89 d8                	mov    %ebx,%eax
  804721:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  804725:	d3 e0                	shl    %cl,%eax
  804727:	89 e9                	mov    %ebp,%ecx
  804729:	d3 ea                	shr    %cl,%edx
  80472b:	09 d0                	or     %edx,%eax
  80472d:	89 e9                	mov    %ebp,%ecx
  80472f:	d3 eb                	shr    %cl,%ebx
  804731:	89 da                	mov    %ebx,%edx
  804733:	83 c4 1c             	add    $0x1c,%esp
  804736:	5b                   	pop    %ebx
  804737:	5e                   	pop    %esi
  804738:	5f                   	pop    %edi
  804739:	5d                   	pop    %ebp
  80473a:	c3                   	ret    
  80473b:	90                   	nop
  80473c:	89 fd                	mov    %edi,%ebp
  80473e:	85 ff                	test   %edi,%edi
  804740:	75 0b                	jne    80474d <__umoddi3+0xe9>
  804742:	b8 01 00 00 00       	mov    $0x1,%eax
  804747:	31 d2                	xor    %edx,%edx
  804749:	f7 f7                	div    %edi
  80474b:	89 c5                	mov    %eax,%ebp
  80474d:	89 f0                	mov    %esi,%eax
  80474f:	31 d2                	xor    %edx,%edx
  804751:	f7 f5                	div    %ebp
  804753:	89 c8                	mov    %ecx,%eax
  804755:	f7 f5                	div    %ebp
  804757:	89 d0                	mov    %edx,%eax
  804759:	e9 44 ff ff ff       	jmp    8046a2 <__umoddi3+0x3e>
  80475e:	66 90                	xchg   %ax,%ax
  804760:	89 c8                	mov    %ecx,%eax
  804762:	89 f2                	mov    %esi,%edx
  804764:	83 c4 1c             	add    $0x1c,%esp
  804767:	5b                   	pop    %ebx
  804768:	5e                   	pop    %esi
  804769:	5f                   	pop    %edi
  80476a:	5d                   	pop    %ebp
  80476b:	c3                   	ret    
  80476c:	3b 04 24             	cmp    (%esp),%eax
  80476f:	72 06                	jb     804777 <__umoddi3+0x113>
  804771:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  804775:	77 0f                	ja     804786 <__umoddi3+0x122>
  804777:	89 f2                	mov    %esi,%edx
  804779:	29 f9                	sub    %edi,%ecx
  80477b:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  80477f:	89 14 24             	mov    %edx,(%esp)
  804782:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  804786:	8b 44 24 04          	mov    0x4(%esp),%eax
  80478a:	8b 14 24             	mov    (%esp),%edx
  80478d:	83 c4 1c             	add    $0x1c,%esp
  804790:	5b                   	pop    %ebx
  804791:	5e                   	pop    %esi
  804792:	5f                   	pop    %edi
  804793:	5d                   	pop    %ebp
  804794:	c3                   	ret    
  804795:	8d 76 00             	lea    0x0(%esi),%esi
  804798:	2b 04 24             	sub    (%esp),%eax
  80479b:	19 fa                	sbb    %edi,%edx
  80479d:	89 d1                	mov    %edx,%ecx
  80479f:	89 c6                	mov    %eax,%esi
  8047a1:	e9 71 ff ff ff       	jmp    804717 <__umoddi3+0xb3>
  8047a6:	66 90                	xchg   %ax,%ax
  8047a8:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8047ac:	72 ea                	jb     804798 <__umoddi3+0x134>
  8047ae:	89 d9                	mov    %ebx,%ecx
  8047b0:	e9 62 ff ff ff       	jmp    804717 <__umoddi3+0xb3>
