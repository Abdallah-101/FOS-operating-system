
obj/user/quicksort_leakage:     file format elf32-i386


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
  800031:	e8 c8 05 00 00       	call   8005fe <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
void QuickSort(int *Elements, int NumOfElements);
void QSort(int *Elements,int NumOfElements, int startIndex, int finalIndex);
uint32 CheckSorted(int *Elements, int NumOfElements);

void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	81 ec 18 01 00 00    	sub    $0x118,%esp
		//2012: lock the interrupt
		//sys_lock_cons();
		//2024: lock the console only using a sleepLock
		int NumOfElements;
		int *Elements;
		sys_lock_cons();
  800041:	e8 02 35 00 00       	call   803548 <sys_lock_cons>
		{
			cprintf("\n");
  800046:	83 ec 0c             	sub    $0xc,%esp
  800049:	68 60 48 80 00       	push   $0x804860
  80004e:	e8 32 0a 00 00       	call   800a85 <cprintf>
  800053:	83 c4 10             	add    $0x10,%esp
			cprintf("!!!!!!!!!!!!!!!!!!!!!!!\n");
  800056:	83 ec 0c             	sub    $0xc,%esp
  800059:	68 62 48 80 00       	push   $0x804862
  80005e:	e8 22 0a 00 00       	call   800a85 <cprintf>
  800063:	83 c4 10             	add    $0x10,%esp
			cprintf("!!!   QUICK SORT    !!!\n");
  800066:	83 ec 0c             	sub    $0xc,%esp
  800069:	68 7b 48 80 00       	push   $0x80487b
  80006e:	e8 12 0a 00 00       	call   800a85 <cprintf>
  800073:	83 c4 10             	add    $0x10,%esp
			cprintf("!!!!!!!!!!!!!!!!!!!!!!!\n");
  800076:	83 ec 0c             	sub    $0xc,%esp
  800079:	68 62 48 80 00       	push   $0x804862
  80007e:	e8 02 0a 00 00       	call   800a85 <cprintf>
  800083:	83 c4 10             	add    $0x10,%esp
			cprintf("\n");
  800086:	83 ec 0c             	sub    $0xc,%esp
  800089:	68 60 48 80 00       	push   $0x804860
  80008e:	e8 f2 09 00 00       	call   800a85 <cprintf>
  800093:	83 c4 10             	add    $0x10,%esp

			readline("Enter the number of elements: ", Line);
  800096:	83 ec 08             	sub    $0x8,%esp
  800099:	8d 85 e9 fe ff ff    	lea    -0x117(%ebp),%eax
  80009f:	50                   	push   %eax
  8000a0:	68 94 48 80 00       	push   $0x804894
  8000a5:	e8 b4 10 00 00       	call   80115e <readline>
  8000aa:	83 c4 10             	add    $0x10,%esp
			NumOfElements = strtol(Line, NULL, 10) ;
  8000ad:	83 ec 04             	sub    $0x4,%esp
  8000b0:	6a 0a                	push   $0xa
  8000b2:	6a 00                	push   $0x0
  8000b4:	8d 85 e9 fe ff ff    	lea    -0x117(%ebp),%eax
  8000ba:	50                   	push   %eax
  8000bb:	e8 b5 16 00 00       	call   801775 <strtol>
  8000c0:	83 c4 10             	add    $0x10,%esp
  8000c3:	89 45 f0             	mov    %eax,-0x10(%ebp)
			cprintf("Chose the initialization method:\n") ;
  8000c6:	83 ec 0c             	sub    $0xc,%esp
  8000c9:	68 b4 48 80 00       	push   $0x8048b4
  8000ce:	e8 b2 09 00 00       	call   800a85 <cprintf>
  8000d3:	83 c4 10             	add    $0x10,%esp
			cprintf("a) Ascending\n") ;
  8000d6:	83 ec 0c             	sub    $0xc,%esp
  8000d9:	68 d6 48 80 00       	push   $0x8048d6
  8000de:	e8 a2 09 00 00       	call   800a85 <cprintf>
  8000e3:	83 c4 10             	add    $0x10,%esp
			cprintf("b) Descending\n") ;
  8000e6:	83 ec 0c             	sub    $0xc,%esp
  8000e9:	68 e4 48 80 00       	push   $0x8048e4
  8000ee:	e8 92 09 00 00       	call   800a85 <cprintf>
  8000f3:	83 c4 10             	add    $0x10,%esp
			cprintf("c) Semi random\n");
  8000f6:	83 ec 0c             	sub    $0xc,%esp
  8000f9:	68 f3 48 80 00       	push   $0x8048f3
  8000fe:	e8 82 09 00 00       	call   800a85 <cprintf>
  800103:	83 c4 10             	add    $0x10,%esp
			do
			{
				cprintf("Select: ") ;
  800106:	83 ec 0c             	sub    $0xc,%esp
  800109:	68 03 49 80 00       	push   $0x804903
  80010e:	e8 72 09 00 00       	call   800a85 <cprintf>
  800113:	83 c4 10             	add    $0x10,%esp
				Chose = getchar() ;
  800116:	e8 c6 04 00 00       	call   8005e1 <getchar>
  80011b:	88 45 f7             	mov    %al,-0x9(%ebp)
				cputchar(Chose);
  80011e:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  800122:	83 ec 0c             	sub    $0xc,%esp
  800125:	50                   	push   %eax
  800126:	e8 97 04 00 00       	call   8005c2 <cputchar>
  80012b:	83 c4 10             	add    $0x10,%esp
				cputchar('\n');
  80012e:	83 ec 0c             	sub    $0xc,%esp
  800131:	6a 0a                	push   $0xa
  800133:	e8 8a 04 00 00       	call   8005c2 <cputchar>
  800138:	83 c4 10             	add    $0x10,%esp
			} while (Chose != 'a' && Chose != 'b' && Chose != 'c');
  80013b:	80 7d f7 61          	cmpb   $0x61,-0x9(%ebp)
  80013f:	74 0c                	je     80014d <_main+0x115>
  800141:	80 7d f7 62          	cmpb   $0x62,-0x9(%ebp)
  800145:	74 06                	je     80014d <_main+0x115>
  800147:	80 7d f7 63          	cmpb   $0x63,-0x9(%ebp)
  80014b:	75 b9                	jne    800106 <_main+0xce>
		}
		//2012: unlock
		sys_unlock_cons();
  80014d:	e8 10 34 00 00       	call   803562 <sys_unlock_cons>

		Elements = malloc(sizeof(int) * NumOfElements) ;
  800152:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800155:	c1 e0 02             	shl    $0x2,%eax
  800158:	83 ec 0c             	sub    $0xc,%esp
  80015b:	50                   	push   %eax
  80015c:	e8 45 1b 00 00       	call   801ca6 <malloc>
  800161:	83 c4 10             	add    $0x10,%esp
  800164:	89 45 ec             	mov    %eax,-0x14(%ebp)

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
  800183:	e8 f5 02 00 00       	call   80047d <InitializeAscending>
  800188:	83 c4 10             	add    $0x10,%esp
			break ;
  80018b:	eb 37                	jmp    8001c4 <_main+0x18c>
		case 'b':
			InitializeDescending(Elements, NumOfElements);
  80018d:	83 ec 08             	sub    $0x8,%esp
  800190:	ff 75 f0             	pushl  -0x10(%ebp)
  800193:	ff 75 ec             	pushl  -0x14(%ebp)
  800196:	e8 13 03 00 00       	call   8004ae <InitializeDescending>
  80019b:	83 c4 10             	add    $0x10,%esp
			break ;
  80019e:	eb 24                	jmp    8001c4 <_main+0x18c>
		case 'c':
			InitializeSemiRandom(Elements, NumOfElements);
  8001a0:	83 ec 08             	sub    $0x8,%esp
  8001a3:	ff 75 f0             	pushl  -0x10(%ebp)
  8001a6:	ff 75 ec             	pushl  -0x14(%ebp)
  8001a9:	e8 35 03 00 00       	call   8004e3 <InitializeSemiRandom>
  8001ae:	83 c4 10             	add    $0x10,%esp
			break ;
  8001b1:	eb 11                	jmp    8001c4 <_main+0x18c>
		default:
			InitializeSemiRandom(Elements, NumOfElements);
  8001b3:	83 ec 08             	sub    $0x8,%esp
  8001b6:	ff 75 f0             	pushl  -0x10(%ebp)
  8001b9:	ff 75 ec             	pushl  -0x14(%ebp)
  8001bc:	e8 22 03 00 00       	call   8004e3 <InitializeSemiRandom>
  8001c1:	83 c4 10             	add    $0x10,%esp
		}

		QuickSort(Elements, NumOfElements);
  8001c4:	83 ec 08             	sub    $0x8,%esp
  8001c7:	ff 75 f0             	pushl  -0x10(%ebp)
  8001ca:	ff 75 ec             	pushl  -0x14(%ebp)
  8001cd:	e8 f0 00 00 00       	call   8002c2 <QuickSort>
  8001d2:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  8001d5:	e8 6e 33 00 00       	call   803548 <sys_lock_cons>
		{
			cprintf("Sorting is Finished!!!!it'll be checked now....\n") ;
  8001da:	83 ec 0c             	sub    $0xc,%esp
  8001dd:	68 0c 49 80 00       	push   $0x80490c
  8001e2:	e8 9e 08 00 00       	call   800a85 <cprintf>
  8001e7:	83 c4 10             	add    $0x10,%esp
			//		PrintElements(Elements, NumOfElements);
		}
		sys_unlock_cons();
  8001ea:	e8 73 33 00 00       	call   803562 <sys_unlock_cons>

		uint32 Sorted = CheckSorted(Elements, NumOfElements);
  8001ef:	83 ec 08             	sub    $0x8,%esp
  8001f2:	ff 75 f0             	pushl  -0x10(%ebp)
  8001f5:	ff 75 ec             	pushl  -0x14(%ebp)
  8001f8:	e8 d6 01 00 00       	call   8003d3 <CheckSorted>
  8001fd:	83 c4 10             	add    $0x10,%esp
  800200:	89 45 e8             	mov    %eax,-0x18(%ebp)

		if(Sorted == 0) panic("The array is NOT sorted correctly") ;
  800203:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  800207:	75 14                	jne    80021d <_main+0x1e5>
  800209:	83 ec 04             	sub    $0x4,%esp
  80020c:	68 40 49 80 00       	push   $0x804940
  800211:	6a 51                	push   $0x51
  800213:	68 62 49 80 00       	push   $0x804962
  800218:	e8 9a 05 00 00       	call   8007b7 <_panic>
		else
		{
			sys_lock_cons();
  80021d:	e8 26 33 00 00       	call   803548 <sys_lock_cons>
			{
				cprintf("===============================================\n") ;
  800222:	83 ec 0c             	sub    $0xc,%esp
  800225:	68 7c 49 80 00       	push   $0x80497c
  80022a:	e8 56 08 00 00       	call   800a85 <cprintf>
  80022f:	83 c4 10             	add    $0x10,%esp
				cprintf("Congratulations!! The array is sorted correctly\n") ;
  800232:	83 ec 0c             	sub    $0xc,%esp
  800235:	68 b0 49 80 00       	push   $0x8049b0
  80023a:	e8 46 08 00 00       	call   800a85 <cprintf>
  80023f:	83 c4 10             	add    $0x10,%esp
				cprintf("===============================================\n\n") ;
  800242:	83 ec 0c             	sub    $0xc,%esp
  800245:	68 e4 49 80 00       	push   $0x8049e4
  80024a:	e8 36 08 00 00       	call   800a85 <cprintf>
  80024f:	83 c4 10             	add    $0x10,%esp
			}
			sys_unlock_cons();
  800252:	e8 0b 33 00 00       	call   803562 <sys_unlock_cons>
		}

		sys_lock_cons();
  800257:	e8 ec 32 00 00       	call   803548 <sys_lock_cons>
		{
			Chose = 0 ;
  80025c:	c6 45 f7 00          	movb   $0x0,-0x9(%ebp)
			while (Chose != 'y' && Chose != 'n')
  800260:	eb 42                	jmp    8002a4 <_main+0x26c>
			{
				cprintf("Do you want to repeat (y/n): ") ;
  800262:	83 ec 0c             	sub    $0xc,%esp
  800265:	68 16 4a 80 00       	push   $0x804a16
  80026a:	e8 16 08 00 00       	call   800a85 <cprintf>
  80026f:	83 c4 10             	add    $0x10,%esp
				Chose = getchar() ;
  800272:	e8 6a 03 00 00       	call   8005e1 <getchar>
  800277:	88 45 f7             	mov    %al,-0x9(%ebp)
				cputchar(Chose);
  80027a:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  80027e:	83 ec 0c             	sub    $0xc,%esp
  800281:	50                   	push   %eax
  800282:	e8 3b 03 00 00       	call   8005c2 <cputchar>
  800287:	83 c4 10             	add    $0x10,%esp
				cputchar('\n');
  80028a:	83 ec 0c             	sub    $0xc,%esp
  80028d:	6a 0a                	push   $0xa
  80028f:	e8 2e 03 00 00       	call   8005c2 <cputchar>
  800294:	83 c4 10             	add    $0x10,%esp
				cputchar('\n');
  800297:	83 ec 0c             	sub    $0xc,%esp
  80029a:	6a 0a                	push   $0xa
  80029c:	e8 21 03 00 00       	call   8005c2 <cputchar>
  8002a1:	83 c4 10             	add    $0x10,%esp
		}

		sys_lock_cons();
		{
			Chose = 0 ;
			while (Chose != 'y' && Chose != 'n')
  8002a4:	80 7d f7 79          	cmpb   $0x79,-0x9(%ebp)
  8002a8:	74 06                	je     8002b0 <_main+0x278>
  8002aa:	80 7d f7 6e          	cmpb   $0x6e,-0x9(%ebp)
  8002ae:	75 b2                	jne    800262 <_main+0x22a>
				cputchar(Chose);
				cputchar('\n');
				cputchar('\n');
			}
		}
		sys_unlock_cons();
  8002b0:	e8 ad 32 00 00       	call   803562 <sys_unlock_cons>

	} while (Chose == 'y');
  8002b5:	80 7d f7 79          	cmpb   $0x79,-0x9(%ebp)
  8002b9:	0f 84 82 fd ff ff    	je     800041 <_main+0x9>

}
  8002bf:	90                   	nop
  8002c0:	c9                   	leave  
  8002c1:	c3                   	ret    

008002c2 <QuickSort>:

///Quick sort
void QuickSort(int *Elements, int NumOfElements)
{
  8002c2:	55                   	push   %ebp
  8002c3:	89 e5                	mov    %esp,%ebp
  8002c5:	83 ec 08             	sub    $0x8,%esp
	QSort(Elements, NumOfElements, 0, NumOfElements-1) ;
  8002c8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002cb:	48                   	dec    %eax
  8002cc:	50                   	push   %eax
  8002cd:	6a 00                	push   $0x0
  8002cf:	ff 75 0c             	pushl  0xc(%ebp)
  8002d2:	ff 75 08             	pushl  0x8(%ebp)
  8002d5:	e8 06 00 00 00       	call   8002e0 <QSort>
  8002da:	83 c4 10             	add    $0x10,%esp
}
  8002dd:	90                   	nop
  8002de:	c9                   	leave  
  8002df:	c3                   	ret    

008002e0 <QSort>:


void QSort(int *Elements,int NumOfElements, int startIndex, int finalIndex)
{
  8002e0:	55                   	push   %ebp
  8002e1:	89 e5                	mov    %esp,%ebp
  8002e3:	83 ec 18             	sub    $0x18,%esp
	if (startIndex >= finalIndex) return;
  8002e6:	8b 45 10             	mov    0x10(%ebp),%eax
  8002e9:	3b 45 14             	cmp    0x14(%ebp),%eax
  8002ec:	0f 8d de 00 00 00    	jge    8003d0 <QSort+0xf0>

	int i = startIndex+1, j = finalIndex;
  8002f2:	8b 45 10             	mov    0x10(%ebp),%eax
  8002f5:	40                   	inc    %eax
  8002f6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8002f9:	8b 45 14             	mov    0x14(%ebp),%eax
  8002fc:	89 45 f0             	mov    %eax,-0x10(%ebp)

	while (i <= j)
  8002ff:	e9 80 00 00 00       	jmp    800384 <QSort+0xa4>
	{
		while (i <= finalIndex && Elements[startIndex] >= Elements[i]) i++;
  800304:	ff 45 f4             	incl   -0xc(%ebp)
  800307:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80030a:	3b 45 14             	cmp    0x14(%ebp),%eax
  80030d:	7f 2b                	jg     80033a <QSort+0x5a>
  80030f:	8b 45 10             	mov    0x10(%ebp),%eax
  800312:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800319:	8b 45 08             	mov    0x8(%ebp),%eax
  80031c:	01 d0                	add    %edx,%eax
  80031e:	8b 10                	mov    (%eax),%edx
  800320:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800323:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80032a:	8b 45 08             	mov    0x8(%ebp),%eax
  80032d:	01 c8                	add    %ecx,%eax
  80032f:	8b 00                	mov    (%eax),%eax
  800331:	39 c2                	cmp    %eax,%edx
  800333:	7d cf                	jge    800304 <QSort+0x24>
		while (j > startIndex && Elements[startIndex] <= Elements[j]) j--;
  800335:	eb 03                	jmp    80033a <QSort+0x5a>
  800337:	ff 4d f0             	decl   -0x10(%ebp)
  80033a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80033d:	3b 45 10             	cmp    0x10(%ebp),%eax
  800340:	7e 26                	jle    800368 <QSort+0x88>
  800342:	8b 45 10             	mov    0x10(%ebp),%eax
  800345:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80034c:	8b 45 08             	mov    0x8(%ebp),%eax
  80034f:	01 d0                	add    %edx,%eax
  800351:	8b 10                	mov    (%eax),%edx
  800353:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800356:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80035d:	8b 45 08             	mov    0x8(%ebp),%eax
  800360:	01 c8                	add    %ecx,%eax
  800362:	8b 00                	mov    (%eax),%eax
  800364:	39 c2                	cmp    %eax,%edx
  800366:	7e cf                	jle    800337 <QSort+0x57>

		if (i <= j)
  800368:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80036b:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80036e:	7f 14                	jg     800384 <QSort+0xa4>
		{
			Swap(Elements, i, j);
  800370:	83 ec 04             	sub    $0x4,%esp
  800373:	ff 75 f0             	pushl  -0x10(%ebp)
  800376:	ff 75 f4             	pushl  -0xc(%ebp)
  800379:	ff 75 08             	pushl  0x8(%ebp)
  80037c:	e8 a9 00 00 00       	call   80042a <Swap>
  800381:	83 c4 10             	add    $0x10,%esp
{
	if (startIndex >= finalIndex) return;

	int i = startIndex+1, j = finalIndex;

	while (i <= j)
  800384:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800387:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80038a:	0f 8e 77 ff ff ff    	jle    800307 <QSort+0x27>
		{
			Swap(Elements, i, j);
		}
	}

	Swap( Elements, startIndex, j);
  800390:	83 ec 04             	sub    $0x4,%esp
  800393:	ff 75 f0             	pushl  -0x10(%ebp)
  800396:	ff 75 10             	pushl  0x10(%ebp)
  800399:	ff 75 08             	pushl  0x8(%ebp)
  80039c:	e8 89 00 00 00       	call   80042a <Swap>
  8003a1:	83 c4 10             	add    $0x10,%esp

	QSort(Elements, NumOfElements, startIndex, j - 1);
  8003a4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003a7:	48                   	dec    %eax
  8003a8:	50                   	push   %eax
  8003a9:	ff 75 10             	pushl  0x10(%ebp)
  8003ac:	ff 75 0c             	pushl  0xc(%ebp)
  8003af:	ff 75 08             	pushl  0x8(%ebp)
  8003b2:	e8 29 ff ff ff       	call   8002e0 <QSort>
  8003b7:	83 c4 10             	add    $0x10,%esp
	QSort(Elements, NumOfElements, i, finalIndex);
  8003ba:	ff 75 14             	pushl  0x14(%ebp)
  8003bd:	ff 75 f4             	pushl  -0xc(%ebp)
  8003c0:	ff 75 0c             	pushl  0xc(%ebp)
  8003c3:	ff 75 08             	pushl  0x8(%ebp)
  8003c6:	e8 15 ff ff ff       	call   8002e0 <QSort>
  8003cb:	83 c4 10             	add    $0x10,%esp
  8003ce:	eb 01                	jmp    8003d1 <QSort+0xf1>
}


void QSort(int *Elements,int NumOfElements, int startIndex, int finalIndex)
{
	if (startIndex >= finalIndex) return;
  8003d0:	90                   	nop
	QSort(Elements, NumOfElements, startIndex, j - 1);
	QSort(Elements, NumOfElements, i, finalIndex);

	//cprintf("qs,after sorting: start = %d, end = %d\n", startIndex, finalIndex);

}
  8003d1:	c9                   	leave  
  8003d2:	c3                   	ret    

008003d3 <CheckSorted>:

uint32 CheckSorted(int *Elements, int NumOfElements)
{
  8003d3:	55                   	push   %ebp
  8003d4:	89 e5                	mov    %esp,%ebp
  8003d6:	83 ec 10             	sub    $0x10,%esp
	uint32 Sorted = 1 ;
  8003d9:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
	int i ;
	for (i = 0 ; i < NumOfElements - 1; i++)
  8003e0:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8003e7:	eb 33                	jmp    80041c <CheckSorted+0x49>
	{
		if (Elements[i] > Elements[i+1])
  8003e9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8003ec:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8003f6:	01 d0                	add    %edx,%eax
  8003f8:	8b 10                	mov    (%eax),%edx
  8003fa:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8003fd:	40                   	inc    %eax
  8003fe:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800405:	8b 45 08             	mov    0x8(%ebp),%eax
  800408:	01 c8                	add    %ecx,%eax
  80040a:	8b 00                	mov    (%eax),%eax
  80040c:	39 c2                	cmp    %eax,%edx
  80040e:	7e 09                	jle    800419 <CheckSorted+0x46>
		{
			Sorted = 0 ;
  800410:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
			break;
  800417:	eb 0c                	jmp    800425 <CheckSorted+0x52>

uint32 CheckSorted(int *Elements, int NumOfElements)
{
	uint32 Sorted = 1 ;
	int i ;
	for (i = 0 ; i < NumOfElements - 1; i++)
  800419:	ff 45 f8             	incl   -0x8(%ebp)
  80041c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80041f:	48                   	dec    %eax
  800420:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800423:	7f c4                	jg     8003e9 <CheckSorted+0x16>
		{
			Sorted = 0 ;
			break;
		}
	}
	return Sorted ;
  800425:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800428:	c9                   	leave  
  800429:	c3                   	ret    

0080042a <Swap>:

///Private Functions


void Swap(int *Elements, int First, int Second)
{
  80042a:	55                   	push   %ebp
  80042b:	89 e5                	mov    %esp,%ebp
  80042d:	83 ec 10             	sub    $0x10,%esp
	int Tmp = Elements[First] ;
  800430:	8b 45 0c             	mov    0xc(%ebp),%eax
  800433:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80043a:	8b 45 08             	mov    0x8(%ebp),%eax
  80043d:	01 d0                	add    %edx,%eax
  80043f:	8b 00                	mov    (%eax),%eax
  800441:	89 45 fc             	mov    %eax,-0x4(%ebp)
	Elements[First] = Elements[Second] ;
  800444:	8b 45 0c             	mov    0xc(%ebp),%eax
  800447:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80044e:	8b 45 08             	mov    0x8(%ebp),%eax
  800451:	01 c2                	add    %eax,%edx
  800453:	8b 45 10             	mov    0x10(%ebp),%eax
  800456:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80045d:	8b 45 08             	mov    0x8(%ebp),%eax
  800460:	01 c8                	add    %ecx,%eax
  800462:	8b 00                	mov    (%eax),%eax
  800464:	89 02                	mov    %eax,(%edx)
	Elements[Second] = Tmp ;
  800466:	8b 45 10             	mov    0x10(%ebp),%eax
  800469:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800470:	8b 45 08             	mov    0x8(%ebp),%eax
  800473:	01 c2                	add    %eax,%edx
  800475:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800478:	89 02                	mov    %eax,(%edx)
}
  80047a:	90                   	nop
  80047b:	c9                   	leave  
  80047c:	c3                   	ret    

0080047d <InitializeAscending>:

void InitializeAscending(int *Elements, int NumOfElements)
{
  80047d:	55                   	push   %ebp
  80047e:	89 e5                	mov    %esp,%ebp
  800480:	83 ec 10             	sub    $0x10,%esp
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  800483:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80048a:	eb 17                	jmp    8004a3 <InitializeAscending+0x26>
	{
		(Elements)[i] = i ;
  80048c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80048f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800496:	8b 45 08             	mov    0x8(%ebp),%eax
  800499:	01 c2                	add    %eax,%edx
  80049b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80049e:	89 02                	mov    %eax,(%edx)
}

void InitializeAscending(int *Elements, int NumOfElements)
{
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  8004a0:	ff 45 fc             	incl   -0x4(%ebp)
  8004a3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8004a6:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8004a9:	7c e1                	jl     80048c <InitializeAscending+0xf>
	{
		(Elements)[i] = i ;
	}

}
  8004ab:	90                   	nop
  8004ac:	c9                   	leave  
  8004ad:	c3                   	ret    

008004ae <InitializeDescending>:

void InitializeDescending(int *Elements, int NumOfElements)
{
  8004ae:	55                   	push   %ebp
  8004af:	89 e5                	mov    %esp,%ebp
  8004b1:	83 ec 10             	sub    $0x10,%esp
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  8004b4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8004bb:	eb 1b                	jmp    8004d8 <InitializeDescending+0x2a>
	{
		Elements[i] = NumOfElements - i - 1 ;
  8004bd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8004c0:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8004c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8004ca:	01 c2                	add    %eax,%edx
  8004cc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004cf:	2b 45 fc             	sub    -0x4(%ebp),%eax
  8004d2:	48                   	dec    %eax
  8004d3:	89 02                	mov    %eax,(%edx)
}

void InitializeDescending(int *Elements, int NumOfElements)
{
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  8004d5:	ff 45 fc             	incl   -0x4(%ebp)
  8004d8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8004db:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8004de:	7c dd                	jl     8004bd <InitializeDescending+0xf>
	{
		Elements[i] = NumOfElements - i - 1 ;
	}

}
  8004e0:	90                   	nop
  8004e1:	c9                   	leave  
  8004e2:	c3                   	ret    

008004e3 <InitializeSemiRandom>:

void InitializeSemiRandom(int *Elements, int NumOfElements)
{
  8004e3:	55                   	push   %ebp
  8004e4:	89 e5                	mov    %esp,%ebp
  8004e6:	83 ec 10             	sub    $0x10,%esp
	int i ;
	int Repetition = NumOfElements / 3 ;
  8004e9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8004ec:	b8 56 55 55 55       	mov    $0x55555556,%eax
  8004f1:	f7 e9                	imul   %ecx
  8004f3:	c1 f9 1f             	sar    $0x1f,%ecx
  8004f6:	89 d0                	mov    %edx,%eax
  8004f8:	29 c8                	sub    %ecx,%eax
  8004fa:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (Repetition == 0)
  8004fd:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800501:	75 07                	jne    80050a <InitializeSemiRandom+0x27>
			Repetition = 3;
  800503:	c7 45 f8 03 00 00 00 	movl   $0x3,-0x8(%ebp)
	for (i = 0 ; i < NumOfElements ; i++)
  80050a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800511:	eb 1e                	jmp    800531 <InitializeSemiRandom+0x4e>
	{
		Elements[i] = i % Repetition ;
  800513:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800516:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80051d:	8b 45 08             	mov    0x8(%ebp),%eax
  800520:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  800523:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800526:	99                   	cltd   
  800527:	f7 7d f8             	idivl  -0x8(%ebp)
  80052a:	89 d0                	mov    %edx,%eax
  80052c:	89 01                	mov    %eax,(%ecx)
{
	int i ;
	int Repetition = NumOfElements / 3 ;
	if (Repetition == 0)
			Repetition = 3;
	for (i = 0 ; i < NumOfElements ; i++)
  80052e:	ff 45 fc             	incl   -0x4(%ebp)
  800531:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800534:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800537:	7c da                	jl     800513 <InitializeSemiRandom+0x30>
	{
		Elements[i] = i % Repetition ;
		//	cprintf("i=%d\n",i);
	}

}
  800539:	90                   	nop
  80053a:	c9                   	leave  
  80053b:	c3                   	ret    

0080053c <PrintElements>:

void PrintElements(int *Elements, int NumOfElements)
{
  80053c:	55                   	push   %ebp
  80053d:	89 e5                	mov    %esp,%ebp
  80053f:	83 ec 18             	sub    $0x18,%esp
	int i ;
	int NumsPerLine = 20 ;
  800542:	c7 45 f0 14 00 00 00 	movl   $0x14,-0x10(%ebp)
	for (i = 0 ; i < NumOfElements-1 ; i++)
  800549:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800550:	eb 42                	jmp    800594 <PrintElements+0x58>
	{
		if (i%NumsPerLine == 0)
  800552:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800555:	99                   	cltd   
  800556:	f7 7d f0             	idivl  -0x10(%ebp)
  800559:	89 d0                	mov    %edx,%eax
  80055b:	85 c0                	test   %eax,%eax
  80055d:	75 10                	jne    80056f <PrintElements+0x33>
			cprintf("\n");
  80055f:	83 ec 0c             	sub    $0xc,%esp
  800562:	68 60 48 80 00       	push   $0x804860
  800567:	e8 19 05 00 00       	call   800a85 <cprintf>
  80056c:	83 c4 10             	add    $0x10,%esp
		cprintf("%d, ",Elements[i]);
  80056f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800572:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800579:	8b 45 08             	mov    0x8(%ebp),%eax
  80057c:	01 d0                	add    %edx,%eax
  80057e:	8b 00                	mov    (%eax),%eax
  800580:	83 ec 08             	sub    $0x8,%esp
  800583:	50                   	push   %eax
  800584:	68 34 4a 80 00       	push   $0x804a34
  800589:	e8 f7 04 00 00       	call   800a85 <cprintf>
  80058e:	83 c4 10             	add    $0x10,%esp

void PrintElements(int *Elements, int NumOfElements)
{
	int i ;
	int NumsPerLine = 20 ;
	for (i = 0 ; i < NumOfElements-1 ; i++)
  800591:	ff 45 f4             	incl   -0xc(%ebp)
  800594:	8b 45 0c             	mov    0xc(%ebp),%eax
  800597:	48                   	dec    %eax
  800598:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80059b:	7f b5                	jg     800552 <PrintElements+0x16>
	{
		if (i%NumsPerLine == 0)
			cprintf("\n");
		cprintf("%d, ",Elements[i]);
	}
	cprintf("%d\n",Elements[i]);
  80059d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8005a0:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8005a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8005aa:	01 d0                	add    %edx,%eax
  8005ac:	8b 00                	mov    (%eax),%eax
  8005ae:	83 ec 08             	sub    $0x8,%esp
  8005b1:	50                   	push   %eax
  8005b2:	68 39 4a 80 00       	push   $0x804a39
  8005b7:	e8 c9 04 00 00       	call   800a85 <cprintf>
  8005bc:	83 c4 10             	add    $0x10,%esp

}
  8005bf:	90                   	nop
  8005c0:	c9                   	leave  
  8005c1:	c3                   	ret    

008005c2 <cputchar>:
#include <inc/lib.h>


void
cputchar(int ch)
{
  8005c2:	55                   	push   %ebp
  8005c3:	89 e5                	mov    %esp,%ebp
  8005c5:	83 ec 18             	sub    $0x18,%esp
	char c = ch;
  8005c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8005cb:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  8005ce:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  8005d2:	83 ec 0c             	sub    $0xc,%esp
  8005d5:	50                   	push   %eax
  8005d6:	e8 b5 30 00 00       	call   803690 <sys_cputc>
  8005db:	83 c4 10             	add    $0x10,%esp
}
  8005de:	90                   	nop
  8005df:	c9                   	leave  
  8005e0:	c3                   	ret    

008005e1 <getchar>:


int
getchar(void)
{
  8005e1:	55                   	push   %ebp
  8005e2:	89 e5                	mov    %esp,%ebp
  8005e4:	83 ec 18             	sub    $0x18,%esp
	int c =sys_cgetc();
  8005e7:	e8 43 2f 00 00       	call   80352f <sys_cgetc>
  8005ec:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return c;
  8005ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8005f2:	c9                   	leave  
  8005f3:	c3                   	ret    

008005f4 <iscons>:

int iscons(int fdnum)
{
  8005f4:	55                   	push   %ebp
  8005f5:	89 e5                	mov    %esp,%ebp
	// used by readline
	return 1;
  8005f7:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8005fc:	5d                   	pop    %ebp
  8005fd:	c3                   	ret    

008005fe <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  8005fe:	55                   	push   %ebp
  8005ff:	89 e5                	mov    %esp,%ebp
  800601:	57                   	push   %edi
  800602:	56                   	push   %esi
  800603:	53                   	push   %ebx
  800604:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  800607:	e8 b5 31 00 00       	call   8037c1 <sys_getenvindex>
  80060c:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  80060f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800612:	89 d0                	mov    %edx,%eax
  800614:	c1 e0 02             	shl    $0x2,%eax
  800617:	01 d0                	add    %edx,%eax
  800619:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800620:	01 d0                	add    %edx,%eax
  800622:	89 c2                	mov    %eax,%edx
  800624:	c1 e2 04             	shl    $0x4,%edx
  800627:	29 c2                	sub    %eax,%edx
  800629:	8d 04 95 00 00 00 00 	lea    0x0(,%edx,4),%eax
  800630:	89 c2                	mov    %eax,%edx
  800632:	8d 82 00 00 c0 ee    	lea    -0x11400000(%edx),%eax
  800638:	a3 24 60 80 00       	mov    %eax,0x806024

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  80063d:	a1 24 60 80 00       	mov    0x806024,%eax
  800642:	8a 40 20             	mov    0x20(%eax),%al
  800645:	84 c0                	test   %al,%al
  800647:	74 0d                	je     800656 <libmain+0x58>
		binaryname = myEnv->prog_name;
  800649:	a1 24 60 80 00       	mov    0x806024,%eax
  80064e:	83 c0 20             	add    $0x20,%eax
  800651:	a3 04 60 80 00       	mov    %eax,0x806004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800656:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80065a:	7e 0a                	jle    800666 <libmain+0x68>
		binaryname = argv[0];
  80065c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80065f:	8b 00                	mov    (%eax),%eax
  800661:	a3 04 60 80 00       	mov    %eax,0x806004

	// call user main routine
	_main(argc, argv);
  800666:	83 ec 08             	sub    $0x8,%esp
  800669:	ff 75 0c             	pushl  0xc(%ebp)
  80066c:	ff 75 08             	pushl  0x8(%ebp)
  80066f:	e8 c4 f9 ff ff       	call   800038 <_main>
  800674:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  800677:	a1 00 60 80 00       	mov    0x806000,%eax
  80067c:	85 c0                	test   %eax,%eax
  80067e:	0f 84 01 01 00 00    	je     800785 <libmain+0x187>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  800684:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  80068a:	bb 38 4b 80 00       	mov    $0x804b38,%ebx
  80068f:	ba 0e 00 00 00       	mov    $0xe,%edx
  800694:	89 c7                	mov    %eax,%edi
  800696:	89 de                	mov    %ebx,%esi
  800698:	89 d1                	mov    %edx,%ecx
  80069a:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  80069c:	8d 55 8a             	lea    -0x76(%ebp),%edx
  80069f:	b9 56 00 00 00       	mov    $0x56,%ecx
  8006a4:	b0 00                	mov    $0x0,%al
  8006a6:	89 d7                	mov    %edx,%edi
  8006a8:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  8006aa:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  8006b1:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8006b4:	83 ec 08             	sub    $0x8,%esp
  8006b7:	50                   	push   %eax
  8006b8:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  8006be:	50                   	push   %eax
  8006bf:	e8 33 33 00 00       	call   8039f7 <sys_utilities>
  8006c4:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  8006c7:	e8 7c 2e 00 00       	call   803548 <sys_lock_cons>
		{
			cprintf("**************************************\n");
  8006cc:	83 ec 0c             	sub    $0xc,%esp
  8006cf:	68 58 4a 80 00       	push   $0x804a58
  8006d4:	e8 ac 03 00 00       	call   800a85 <cprintf>
  8006d9:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  8006dc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8006df:	85 c0                	test   %eax,%eax
  8006e1:	74 18                	je     8006fb <libmain+0xfd>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  8006e3:	e8 2d 33 00 00       	call   803a15 <sys_get_optimal_num_faults>
  8006e8:	83 ec 08             	sub    $0x8,%esp
  8006eb:	50                   	push   %eax
  8006ec:	68 80 4a 80 00       	push   $0x804a80
  8006f1:	e8 8f 03 00 00       	call   800a85 <cprintf>
  8006f6:	83 c4 10             	add    $0x10,%esp
  8006f9:	eb 59                	jmp    800754 <libmain+0x156>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8006fb:	a1 24 60 80 00       	mov    0x806024,%eax
  800700:	8b 90 bc 05 00 00    	mov    0x5bc(%eax),%edx
  800706:	a1 24 60 80 00       	mov    0x806024,%eax
  80070b:	8b 80 ac 05 00 00    	mov    0x5ac(%eax),%eax
  800711:	83 ec 04             	sub    $0x4,%esp
  800714:	52                   	push   %edx
  800715:	50                   	push   %eax
  800716:	68 a4 4a 80 00       	push   $0x804aa4
  80071b:	e8 65 03 00 00       	call   800a85 <cprintf>
  800720:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800723:	a1 24 60 80 00       	mov    0x806024,%eax
  800728:	8b 88 d0 05 00 00    	mov    0x5d0(%eax),%ecx
  80072e:	a1 24 60 80 00       	mov    0x806024,%eax
  800733:	8b 90 cc 05 00 00    	mov    0x5cc(%eax),%edx
  800739:	a1 24 60 80 00       	mov    0x806024,%eax
  80073e:	8b 80 c8 05 00 00    	mov    0x5c8(%eax),%eax
  800744:	51                   	push   %ecx
  800745:	52                   	push   %edx
  800746:	50                   	push   %eax
  800747:	68 cc 4a 80 00       	push   $0x804acc
  80074c:	e8 34 03 00 00       	call   800a85 <cprintf>
  800751:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800754:	a1 24 60 80 00       	mov    0x806024,%eax
  800759:	8b 80 d4 05 00 00    	mov    0x5d4(%eax),%eax
  80075f:	83 ec 08             	sub    $0x8,%esp
  800762:	50                   	push   %eax
  800763:	68 24 4b 80 00       	push   $0x804b24
  800768:	e8 18 03 00 00       	call   800a85 <cprintf>
  80076d:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  800770:	83 ec 0c             	sub    $0xc,%esp
  800773:	68 58 4a 80 00       	push   $0x804a58
  800778:	e8 08 03 00 00       	call   800a85 <cprintf>
  80077d:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  800780:	e8 dd 2d 00 00       	call   803562 <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  800785:	e8 1f 00 00 00       	call   8007a9 <exit>
}
  80078a:	90                   	nop
  80078b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80078e:	5b                   	pop    %ebx
  80078f:	5e                   	pop    %esi
  800790:	5f                   	pop    %edi
  800791:	5d                   	pop    %ebp
  800792:	c3                   	ret    

00800793 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800793:	55                   	push   %ebp
  800794:	89 e5                	mov    %esp,%ebp
  800796:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800799:	83 ec 0c             	sub    $0xc,%esp
  80079c:	6a 00                	push   $0x0
  80079e:	e8 ea 2f 00 00       	call   80378d <sys_destroy_env>
  8007a3:	83 c4 10             	add    $0x10,%esp
}
  8007a6:	90                   	nop
  8007a7:	c9                   	leave  
  8007a8:	c3                   	ret    

008007a9 <exit>:

void
exit(void)
{
  8007a9:	55                   	push   %ebp
  8007aa:	89 e5                	mov    %esp,%ebp
  8007ac:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8007af:	e8 3f 30 00 00       	call   8037f3 <sys_exit_env>
}
  8007b4:	90                   	nop
  8007b5:	c9                   	leave  
  8007b6:	c3                   	ret    

008007b7 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8007b7:	55                   	push   %ebp
  8007b8:	89 e5                	mov    %esp,%ebp
  8007ba:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8007bd:	8d 45 10             	lea    0x10(%ebp),%eax
  8007c0:	83 c0 04             	add    $0x4,%eax
  8007c3:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8007c6:	a1 18 e1 81 00       	mov    0x81e118,%eax
  8007cb:	85 c0                	test   %eax,%eax
  8007cd:	74 16                	je     8007e5 <_panic+0x2e>
		cprintf("%s: ", argv0);
  8007cf:	a1 18 e1 81 00       	mov    0x81e118,%eax
  8007d4:	83 ec 08             	sub    $0x8,%esp
  8007d7:	50                   	push   %eax
  8007d8:	68 9c 4b 80 00       	push   $0x804b9c
  8007dd:	e8 a3 02 00 00       	call   800a85 <cprintf>
  8007e2:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  8007e5:	a1 04 60 80 00       	mov    0x806004,%eax
  8007ea:	83 ec 0c             	sub    $0xc,%esp
  8007ed:	ff 75 0c             	pushl  0xc(%ebp)
  8007f0:	ff 75 08             	pushl  0x8(%ebp)
  8007f3:	50                   	push   %eax
  8007f4:	68 a4 4b 80 00       	push   $0x804ba4
  8007f9:	6a 74                	push   $0x74
  8007fb:	e8 b2 02 00 00       	call   800ab2 <cprintf_colored>
  800800:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  800803:	8b 45 10             	mov    0x10(%ebp),%eax
  800806:	83 ec 08             	sub    $0x8,%esp
  800809:	ff 75 f4             	pushl  -0xc(%ebp)
  80080c:	50                   	push   %eax
  80080d:	e8 04 02 00 00       	call   800a16 <vcprintf>
  800812:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800815:	83 ec 08             	sub    $0x8,%esp
  800818:	6a 00                	push   $0x0
  80081a:	68 cc 4b 80 00       	push   $0x804bcc
  80081f:	e8 f2 01 00 00       	call   800a16 <vcprintf>
  800824:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800827:	e8 7d ff ff ff       	call   8007a9 <exit>

	// should not return here
	while (1) ;
  80082c:	eb fe                	jmp    80082c <_panic+0x75>

0080082e <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  80082e:	55                   	push   %ebp
  80082f:	89 e5                	mov    %esp,%ebp
  800831:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800834:	a1 24 60 80 00       	mov    0x806024,%eax
  800839:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  80083f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800842:	39 c2                	cmp    %eax,%edx
  800844:	74 14                	je     80085a <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800846:	83 ec 04             	sub    $0x4,%esp
  800849:	68 d0 4b 80 00       	push   $0x804bd0
  80084e:	6a 26                	push   $0x26
  800850:	68 1c 4c 80 00       	push   $0x804c1c
  800855:	e8 5d ff ff ff       	call   8007b7 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  80085a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800861:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800868:	e9 c5 00 00 00       	jmp    800932 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  80086d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800870:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800877:	8b 45 08             	mov    0x8(%ebp),%eax
  80087a:	01 d0                	add    %edx,%eax
  80087c:	8b 00                	mov    (%eax),%eax
  80087e:	85 c0                	test   %eax,%eax
  800880:	75 08                	jne    80088a <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  800882:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800885:	e9 a5 00 00 00       	jmp    80092f <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  80088a:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800891:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800898:	eb 69                	jmp    800903 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  80089a:	a1 24 60 80 00       	mov    0x806024,%eax
  80089f:	8b 88 a4 05 00 00    	mov    0x5a4(%eax),%ecx
  8008a5:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8008a8:	89 d0                	mov    %edx,%eax
  8008aa:	01 c0                	add    %eax,%eax
  8008ac:	01 d0                	add    %edx,%eax
  8008ae:	c1 e0 03             	shl    $0x3,%eax
  8008b1:	01 c8                	add    %ecx,%eax
  8008b3:	8a 40 04             	mov    0x4(%eax),%al
  8008b6:	84 c0                	test   %al,%al
  8008b8:	75 46                	jne    800900 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8008ba:	a1 24 60 80 00       	mov    0x806024,%eax
  8008bf:	8b 88 a4 05 00 00    	mov    0x5a4(%eax),%ecx
  8008c5:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8008c8:	89 d0                	mov    %edx,%eax
  8008ca:	01 c0                	add    %eax,%eax
  8008cc:	01 d0                	add    %edx,%eax
  8008ce:	c1 e0 03             	shl    $0x3,%eax
  8008d1:	01 c8                	add    %ecx,%eax
  8008d3:	8b 00                	mov    (%eax),%eax
  8008d5:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8008d8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8008db:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8008e0:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8008e2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8008e5:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8008ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ef:	01 c8                	add    %ecx,%eax
  8008f1:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8008f3:	39 c2                	cmp    %eax,%edx
  8008f5:	75 09                	jne    800900 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  8008f7:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8008fe:	eb 15                	jmp    800915 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800900:	ff 45 e8             	incl   -0x18(%ebp)
  800903:	a1 24 60 80 00       	mov    0x806024,%eax
  800908:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  80090e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800911:	39 c2                	cmp    %eax,%edx
  800913:	77 85                	ja     80089a <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800915:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800919:	75 14                	jne    80092f <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  80091b:	83 ec 04             	sub    $0x4,%esp
  80091e:	68 28 4c 80 00       	push   $0x804c28
  800923:	6a 3a                	push   $0x3a
  800925:	68 1c 4c 80 00       	push   $0x804c1c
  80092a:	e8 88 fe ff ff       	call   8007b7 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  80092f:	ff 45 f0             	incl   -0x10(%ebp)
  800932:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800935:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800938:	0f 8c 2f ff ff ff    	jl     80086d <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  80093e:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800945:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80094c:	eb 26                	jmp    800974 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  80094e:	a1 24 60 80 00       	mov    0x806024,%eax
  800953:	8b 88 a4 05 00 00    	mov    0x5a4(%eax),%ecx
  800959:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80095c:	89 d0                	mov    %edx,%eax
  80095e:	01 c0                	add    %eax,%eax
  800960:	01 d0                	add    %edx,%eax
  800962:	c1 e0 03             	shl    $0x3,%eax
  800965:	01 c8                	add    %ecx,%eax
  800967:	8a 40 04             	mov    0x4(%eax),%al
  80096a:	3c 01                	cmp    $0x1,%al
  80096c:	75 03                	jne    800971 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  80096e:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800971:	ff 45 e0             	incl   -0x20(%ebp)
  800974:	a1 24 60 80 00       	mov    0x806024,%eax
  800979:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  80097f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800982:	39 c2                	cmp    %eax,%edx
  800984:	77 c8                	ja     80094e <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800986:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800989:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80098c:	74 14                	je     8009a2 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  80098e:	83 ec 04             	sub    $0x4,%esp
  800991:	68 7c 4c 80 00       	push   $0x804c7c
  800996:	6a 44                	push   $0x44
  800998:	68 1c 4c 80 00       	push   $0x804c1c
  80099d:	e8 15 fe ff ff       	call   8007b7 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8009a2:	90                   	nop
  8009a3:	c9                   	leave  
  8009a4:	c3                   	ret    

008009a5 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  8009a5:	55                   	push   %ebp
  8009a6:	89 e5                	mov    %esp,%ebp
  8009a8:	53                   	push   %ebx
  8009a9:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  8009ac:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009af:	8b 00                	mov    (%eax),%eax
  8009b1:	8d 48 01             	lea    0x1(%eax),%ecx
  8009b4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009b7:	89 0a                	mov    %ecx,(%edx)
  8009b9:	8b 55 08             	mov    0x8(%ebp),%edx
  8009bc:	88 d1                	mov    %dl,%cl
  8009be:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009c1:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8009c5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009c8:	8b 00                	mov    (%eax),%eax
  8009ca:	3d ff 00 00 00       	cmp    $0xff,%eax
  8009cf:	75 30                	jne    800a01 <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  8009d1:	8b 15 1c e1 81 00    	mov    0x81e11c,%edx
  8009d7:	a0 44 60 80 00       	mov    0x806044,%al
  8009dc:	0f b6 c0             	movzbl %al,%eax
  8009df:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8009e2:	8b 09                	mov    (%ecx),%ecx
  8009e4:	89 cb                	mov    %ecx,%ebx
  8009e6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8009e9:	83 c1 08             	add    $0x8,%ecx
  8009ec:	52                   	push   %edx
  8009ed:	50                   	push   %eax
  8009ee:	53                   	push   %ebx
  8009ef:	51                   	push   %ecx
  8009f0:	e8 0f 2b 00 00       	call   803504 <sys_cputs>
  8009f5:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8009f8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009fb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800a01:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a04:	8b 40 04             	mov    0x4(%eax),%eax
  800a07:	8d 50 01             	lea    0x1(%eax),%edx
  800a0a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a0d:	89 50 04             	mov    %edx,0x4(%eax)
}
  800a10:	90                   	nop
  800a11:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800a14:	c9                   	leave  
  800a15:	c3                   	ret    

00800a16 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800a16:	55                   	push   %ebp
  800a17:	89 e5                	mov    %esp,%ebp
  800a19:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800a1f:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800a26:	00 00 00 
	b.cnt = 0;
  800a29:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800a30:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800a33:	ff 75 0c             	pushl  0xc(%ebp)
  800a36:	ff 75 08             	pushl  0x8(%ebp)
  800a39:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800a3f:	50                   	push   %eax
  800a40:	68 a5 09 80 00       	push   $0x8009a5
  800a45:	e8 5a 02 00 00       	call   800ca4 <vprintfmt>
  800a4a:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  800a4d:	8b 15 1c e1 81 00    	mov    0x81e11c,%edx
  800a53:	a0 44 60 80 00       	mov    0x806044,%al
  800a58:	0f b6 c0             	movzbl %al,%eax
  800a5b:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  800a61:	52                   	push   %edx
  800a62:	50                   	push   %eax
  800a63:	51                   	push   %ecx
  800a64:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800a6a:	83 c0 08             	add    $0x8,%eax
  800a6d:	50                   	push   %eax
  800a6e:	e8 91 2a 00 00       	call   803504 <sys_cputs>
  800a73:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800a76:	c6 05 44 60 80 00 00 	movb   $0x0,0x806044
	return b.cnt;
  800a7d:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800a83:	c9                   	leave  
  800a84:	c3                   	ret    

00800a85 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  800a85:	55                   	push   %ebp
  800a86:	89 e5                	mov    %esp,%ebp
  800a88:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800a8b:	c6 05 44 60 80 00 01 	movb   $0x1,0x806044
	va_start(ap, fmt);
  800a92:	8d 45 0c             	lea    0xc(%ebp),%eax
  800a95:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800a98:	8b 45 08             	mov    0x8(%ebp),%eax
  800a9b:	83 ec 08             	sub    $0x8,%esp
  800a9e:	ff 75 f4             	pushl  -0xc(%ebp)
  800aa1:	50                   	push   %eax
  800aa2:	e8 6f ff ff ff       	call   800a16 <vcprintf>
  800aa7:	83 c4 10             	add    $0x10,%esp
  800aaa:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800aad:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800ab0:	c9                   	leave  
  800ab1:	c3                   	ret    

00800ab2 <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  800ab2:	55                   	push   %ebp
  800ab3:	89 e5                	mov    %esp,%ebp
  800ab5:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800ab8:	c6 05 44 60 80 00 01 	movb   $0x1,0x806044
	curTextClr = (textClr << 8) ; //set text color by the given value
  800abf:	8b 45 08             	mov    0x8(%ebp),%eax
  800ac2:	c1 e0 08             	shl    $0x8,%eax
  800ac5:	a3 1c e1 81 00       	mov    %eax,0x81e11c
	va_start(ap, fmt);
  800aca:	8d 45 0c             	lea    0xc(%ebp),%eax
  800acd:	83 c0 04             	add    $0x4,%eax
  800ad0:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800ad3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ad6:	83 ec 08             	sub    $0x8,%esp
  800ad9:	ff 75 f4             	pushl  -0xc(%ebp)
  800adc:	50                   	push   %eax
  800add:	e8 34 ff ff ff       	call   800a16 <vcprintf>
  800ae2:	83 c4 10             	add    $0x10,%esp
  800ae5:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  800ae8:	c7 05 1c e1 81 00 00 	movl   $0x700,0x81e11c
  800aef:	07 00 00 

	return cnt;
  800af2:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800af5:	c9                   	leave  
  800af6:	c3                   	ret    

00800af7 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  800af7:	55                   	push   %ebp
  800af8:	89 e5                	mov    %esp,%ebp
  800afa:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  800afd:	e8 46 2a 00 00       	call   803548 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  800b02:	8d 45 0c             	lea    0xc(%ebp),%eax
  800b05:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  800b08:	8b 45 08             	mov    0x8(%ebp),%eax
  800b0b:	83 ec 08             	sub    $0x8,%esp
  800b0e:	ff 75 f4             	pushl  -0xc(%ebp)
  800b11:	50                   	push   %eax
  800b12:	e8 ff fe ff ff       	call   800a16 <vcprintf>
  800b17:	83 c4 10             	add    $0x10,%esp
  800b1a:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  800b1d:	e8 40 2a 00 00       	call   803562 <sys_unlock_cons>
	return cnt;
  800b22:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800b25:	c9                   	leave  
  800b26:	c3                   	ret    

00800b27 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800b27:	55                   	push   %ebp
  800b28:	89 e5                	mov    %esp,%ebp
  800b2a:	53                   	push   %ebx
  800b2b:	83 ec 14             	sub    $0x14,%esp
  800b2e:	8b 45 10             	mov    0x10(%ebp),%eax
  800b31:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b34:	8b 45 14             	mov    0x14(%ebp),%eax
  800b37:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800b3a:	8b 45 18             	mov    0x18(%ebp),%eax
  800b3d:	ba 00 00 00 00       	mov    $0x0,%edx
  800b42:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800b45:	77 55                	ja     800b9c <printnum+0x75>
  800b47:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800b4a:	72 05                	jb     800b51 <printnum+0x2a>
  800b4c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800b4f:	77 4b                	ja     800b9c <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800b51:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800b54:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800b57:	8b 45 18             	mov    0x18(%ebp),%eax
  800b5a:	ba 00 00 00 00       	mov    $0x0,%edx
  800b5f:	52                   	push   %edx
  800b60:	50                   	push   %eax
  800b61:	ff 75 f4             	pushl  -0xc(%ebp)
  800b64:	ff 75 f0             	pushl  -0x10(%ebp)
  800b67:	e8 88 3a 00 00       	call   8045f4 <__udivdi3>
  800b6c:	83 c4 10             	add    $0x10,%esp
  800b6f:	83 ec 04             	sub    $0x4,%esp
  800b72:	ff 75 20             	pushl  0x20(%ebp)
  800b75:	53                   	push   %ebx
  800b76:	ff 75 18             	pushl  0x18(%ebp)
  800b79:	52                   	push   %edx
  800b7a:	50                   	push   %eax
  800b7b:	ff 75 0c             	pushl  0xc(%ebp)
  800b7e:	ff 75 08             	pushl  0x8(%ebp)
  800b81:	e8 a1 ff ff ff       	call   800b27 <printnum>
  800b86:	83 c4 20             	add    $0x20,%esp
  800b89:	eb 1a                	jmp    800ba5 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800b8b:	83 ec 08             	sub    $0x8,%esp
  800b8e:	ff 75 0c             	pushl  0xc(%ebp)
  800b91:	ff 75 20             	pushl  0x20(%ebp)
  800b94:	8b 45 08             	mov    0x8(%ebp),%eax
  800b97:	ff d0                	call   *%eax
  800b99:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800b9c:	ff 4d 1c             	decl   0x1c(%ebp)
  800b9f:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800ba3:	7f e6                	jg     800b8b <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800ba5:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800ba8:	bb 00 00 00 00       	mov    $0x0,%ebx
  800bad:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800bb0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800bb3:	53                   	push   %ebx
  800bb4:	51                   	push   %ecx
  800bb5:	52                   	push   %edx
  800bb6:	50                   	push   %eax
  800bb7:	e8 48 3b 00 00       	call   804704 <__umoddi3>
  800bbc:	83 c4 10             	add    $0x10,%esp
  800bbf:	05 f4 4e 80 00       	add    $0x804ef4,%eax
  800bc4:	8a 00                	mov    (%eax),%al
  800bc6:	0f be c0             	movsbl %al,%eax
  800bc9:	83 ec 08             	sub    $0x8,%esp
  800bcc:	ff 75 0c             	pushl  0xc(%ebp)
  800bcf:	50                   	push   %eax
  800bd0:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd3:	ff d0                	call   *%eax
  800bd5:	83 c4 10             	add    $0x10,%esp
}
  800bd8:	90                   	nop
  800bd9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800bdc:	c9                   	leave  
  800bdd:	c3                   	ret    

00800bde <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800bde:	55                   	push   %ebp
  800bdf:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800be1:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800be5:	7e 1c                	jle    800c03 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800be7:	8b 45 08             	mov    0x8(%ebp),%eax
  800bea:	8b 00                	mov    (%eax),%eax
  800bec:	8d 50 08             	lea    0x8(%eax),%edx
  800bef:	8b 45 08             	mov    0x8(%ebp),%eax
  800bf2:	89 10                	mov    %edx,(%eax)
  800bf4:	8b 45 08             	mov    0x8(%ebp),%eax
  800bf7:	8b 00                	mov    (%eax),%eax
  800bf9:	83 e8 08             	sub    $0x8,%eax
  800bfc:	8b 50 04             	mov    0x4(%eax),%edx
  800bff:	8b 00                	mov    (%eax),%eax
  800c01:	eb 40                	jmp    800c43 <getuint+0x65>
	else if (lflag)
  800c03:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c07:	74 1e                	je     800c27 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800c09:	8b 45 08             	mov    0x8(%ebp),%eax
  800c0c:	8b 00                	mov    (%eax),%eax
  800c0e:	8d 50 04             	lea    0x4(%eax),%edx
  800c11:	8b 45 08             	mov    0x8(%ebp),%eax
  800c14:	89 10                	mov    %edx,(%eax)
  800c16:	8b 45 08             	mov    0x8(%ebp),%eax
  800c19:	8b 00                	mov    (%eax),%eax
  800c1b:	83 e8 04             	sub    $0x4,%eax
  800c1e:	8b 00                	mov    (%eax),%eax
  800c20:	ba 00 00 00 00       	mov    $0x0,%edx
  800c25:	eb 1c                	jmp    800c43 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800c27:	8b 45 08             	mov    0x8(%ebp),%eax
  800c2a:	8b 00                	mov    (%eax),%eax
  800c2c:	8d 50 04             	lea    0x4(%eax),%edx
  800c2f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c32:	89 10                	mov    %edx,(%eax)
  800c34:	8b 45 08             	mov    0x8(%ebp),%eax
  800c37:	8b 00                	mov    (%eax),%eax
  800c39:	83 e8 04             	sub    $0x4,%eax
  800c3c:	8b 00                	mov    (%eax),%eax
  800c3e:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800c43:	5d                   	pop    %ebp
  800c44:	c3                   	ret    

00800c45 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800c45:	55                   	push   %ebp
  800c46:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800c48:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800c4c:	7e 1c                	jle    800c6a <getint+0x25>
		return va_arg(*ap, long long);
  800c4e:	8b 45 08             	mov    0x8(%ebp),%eax
  800c51:	8b 00                	mov    (%eax),%eax
  800c53:	8d 50 08             	lea    0x8(%eax),%edx
  800c56:	8b 45 08             	mov    0x8(%ebp),%eax
  800c59:	89 10                	mov    %edx,(%eax)
  800c5b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c5e:	8b 00                	mov    (%eax),%eax
  800c60:	83 e8 08             	sub    $0x8,%eax
  800c63:	8b 50 04             	mov    0x4(%eax),%edx
  800c66:	8b 00                	mov    (%eax),%eax
  800c68:	eb 38                	jmp    800ca2 <getint+0x5d>
	else if (lflag)
  800c6a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c6e:	74 1a                	je     800c8a <getint+0x45>
		return va_arg(*ap, long);
  800c70:	8b 45 08             	mov    0x8(%ebp),%eax
  800c73:	8b 00                	mov    (%eax),%eax
  800c75:	8d 50 04             	lea    0x4(%eax),%edx
  800c78:	8b 45 08             	mov    0x8(%ebp),%eax
  800c7b:	89 10                	mov    %edx,(%eax)
  800c7d:	8b 45 08             	mov    0x8(%ebp),%eax
  800c80:	8b 00                	mov    (%eax),%eax
  800c82:	83 e8 04             	sub    $0x4,%eax
  800c85:	8b 00                	mov    (%eax),%eax
  800c87:	99                   	cltd   
  800c88:	eb 18                	jmp    800ca2 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800c8a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c8d:	8b 00                	mov    (%eax),%eax
  800c8f:	8d 50 04             	lea    0x4(%eax),%edx
  800c92:	8b 45 08             	mov    0x8(%ebp),%eax
  800c95:	89 10                	mov    %edx,(%eax)
  800c97:	8b 45 08             	mov    0x8(%ebp),%eax
  800c9a:	8b 00                	mov    (%eax),%eax
  800c9c:	83 e8 04             	sub    $0x4,%eax
  800c9f:	8b 00                	mov    (%eax),%eax
  800ca1:	99                   	cltd   
}
  800ca2:	5d                   	pop    %ebp
  800ca3:	c3                   	ret    

00800ca4 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800ca4:	55                   	push   %ebp
  800ca5:	89 e5                	mov    %esp,%ebp
  800ca7:	56                   	push   %esi
  800ca8:	53                   	push   %ebx
  800ca9:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800cac:	eb 17                	jmp    800cc5 <vprintfmt+0x21>
			if (ch == '\0')
  800cae:	85 db                	test   %ebx,%ebx
  800cb0:	0f 84 c1 03 00 00    	je     801077 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  800cb6:	83 ec 08             	sub    $0x8,%esp
  800cb9:	ff 75 0c             	pushl  0xc(%ebp)
  800cbc:	53                   	push   %ebx
  800cbd:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc0:	ff d0                	call   *%eax
  800cc2:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800cc5:	8b 45 10             	mov    0x10(%ebp),%eax
  800cc8:	8d 50 01             	lea    0x1(%eax),%edx
  800ccb:	89 55 10             	mov    %edx,0x10(%ebp)
  800cce:	8a 00                	mov    (%eax),%al
  800cd0:	0f b6 d8             	movzbl %al,%ebx
  800cd3:	83 fb 25             	cmp    $0x25,%ebx
  800cd6:	75 d6                	jne    800cae <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800cd8:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800cdc:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800ce3:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800cea:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800cf1:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800cf8:	8b 45 10             	mov    0x10(%ebp),%eax
  800cfb:	8d 50 01             	lea    0x1(%eax),%edx
  800cfe:	89 55 10             	mov    %edx,0x10(%ebp)
  800d01:	8a 00                	mov    (%eax),%al
  800d03:	0f b6 d8             	movzbl %al,%ebx
  800d06:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800d09:	83 f8 5b             	cmp    $0x5b,%eax
  800d0c:	0f 87 3d 03 00 00    	ja     80104f <vprintfmt+0x3ab>
  800d12:	8b 04 85 18 4f 80 00 	mov    0x804f18(,%eax,4),%eax
  800d19:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800d1b:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800d1f:	eb d7                	jmp    800cf8 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800d21:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800d25:	eb d1                	jmp    800cf8 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800d27:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800d2e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800d31:	89 d0                	mov    %edx,%eax
  800d33:	c1 e0 02             	shl    $0x2,%eax
  800d36:	01 d0                	add    %edx,%eax
  800d38:	01 c0                	add    %eax,%eax
  800d3a:	01 d8                	add    %ebx,%eax
  800d3c:	83 e8 30             	sub    $0x30,%eax
  800d3f:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800d42:	8b 45 10             	mov    0x10(%ebp),%eax
  800d45:	8a 00                	mov    (%eax),%al
  800d47:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800d4a:	83 fb 2f             	cmp    $0x2f,%ebx
  800d4d:	7e 3e                	jle    800d8d <vprintfmt+0xe9>
  800d4f:	83 fb 39             	cmp    $0x39,%ebx
  800d52:	7f 39                	jg     800d8d <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800d54:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800d57:	eb d5                	jmp    800d2e <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800d59:	8b 45 14             	mov    0x14(%ebp),%eax
  800d5c:	83 c0 04             	add    $0x4,%eax
  800d5f:	89 45 14             	mov    %eax,0x14(%ebp)
  800d62:	8b 45 14             	mov    0x14(%ebp),%eax
  800d65:	83 e8 04             	sub    $0x4,%eax
  800d68:	8b 00                	mov    (%eax),%eax
  800d6a:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800d6d:	eb 1f                	jmp    800d8e <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800d6f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800d73:	79 83                	jns    800cf8 <vprintfmt+0x54>
				width = 0;
  800d75:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800d7c:	e9 77 ff ff ff       	jmp    800cf8 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800d81:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800d88:	e9 6b ff ff ff       	jmp    800cf8 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800d8d:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800d8e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800d92:	0f 89 60 ff ff ff    	jns    800cf8 <vprintfmt+0x54>
				width = precision, precision = -1;
  800d98:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800d9b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800d9e:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800da5:	e9 4e ff ff ff       	jmp    800cf8 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800daa:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800dad:	e9 46 ff ff ff       	jmp    800cf8 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800db2:	8b 45 14             	mov    0x14(%ebp),%eax
  800db5:	83 c0 04             	add    $0x4,%eax
  800db8:	89 45 14             	mov    %eax,0x14(%ebp)
  800dbb:	8b 45 14             	mov    0x14(%ebp),%eax
  800dbe:	83 e8 04             	sub    $0x4,%eax
  800dc1:	8b 00                	mov    (%eax),%eax
  800dc3:	83 ec 08             	sub    $0x8,%esp
  800dc6:	ff 75 0c             	pushl  0xc(%ebp)
  800dc9:	50                   	push   %eax
  800dca:	8b 45 08             	mov    0x8(%ebp),%eax
  800dcd:	ff d0                	call   *%eax
  800dcf:	83 c4 10             	add    $0x10,%esp
			break;
  800dd2:	e9 9b 02 00 00       	jmp    801072 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800dd7:	8b 45 14             	mov    0x14(%ebp),%eax
  800dda:	83 c0 04             	add    $0x4,%eax
  800ddd:	89 45 14             	mov    %eax,0x14(%ebp)
  800de0:	8b 45 14             	mov    0x14(%ebp),%eax
  800de3:	83 e8 04             	sub    $0x4,%eax
  800de6:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800de8:	85 db                	test   %ebx,%ebx
  800dea:	79 02                	jns    800dee <vprintfmt+0x14a>
				err = -err;
  800dec:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800dee:	83 fb 64             	cmp    $0x64,%ebx
  800df1:	7f 0b                	jg     800dfe <vprintfmt+0x15a>
  800df3:	8b 34 9d 60 4d 80 00 	mov    0x804d60(,%ebx,4),%esi
  800dfa:	85 f6                	test   %esi,%esi
  800dfc:	75 19                	jne    800e17 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800dfe:	53                   	push   %ebx
  800dff:	68 05 4f 80 00       	push   $0x804f05
  800e04:	ff 75 0c             	pushl  0xc(%ebp)
  800e07:	ff 75 08             	pushl  0x8(%ebp)
  800e0a:	e8 70 02 00 00       	call   80107f <printfmt>
  800e0f:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800e12:	e9 5b 02 00 00       	jmp    801072 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800e17:	56                   	push   %esi
  800e18:	68 0e 4f 80 00       	push   $0x804f0e
  800e1d:	ff 75 0c             	pushl  0xc(%ebp)
  800e20:	ff 75 08             	pushl  0x8(%ebp)
  800e23:	e8 57 02 00 00       	call   80107f <printfmt>
  800e28:	83 c4 10             	add    $0x10,%esp
			break;
  800e2b:	e9 42 02 00 00       	jmp    801072 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800e30:	8b 45 14             	mov    0x14(%ebp),%eax
  800e33:	83 c0 04             	add    $0x4,%eax
  800e36:	89 45 14             	mov    %eax,0x14(%ebp)
  800e39:	8b 45 14             	mov    0x14(%ebp),%eax
  800e3c:	83 e8 04             	sub    $0x4,%eax
  800e3f:	8b 30                	mov    (%eax),%esi
  800e41:	85 f6                	test   %esi,%esi
  800e43:	75 05                	jne    800e4a <vprintfmt+0x1a6>
				p = "(null)";
  800e45:	be 11 4f 80 00       	mov    $0x804f11,%esi
			if (width > 0 && padc != '-')
  800e4a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800e4e:	7e 6d                	jle    800ebd <vprintfmt+0x219>
  800e50:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800e54:	74 67                	je     800ebd <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800e56:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800e59:	83 ec 08             	sub    $0x8,%esp
  800e5c:	50                   	push   %eax
  800e5d:	56                   	push   %esi
  800e5e:	e8 26 05 00 00       	call   801389 <strnlen>
  800e63:	83 c4 10             	add    $0x10,%esp
  800e66:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800e69:	eb 16                	jmp    800e81 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800e6b:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800e6f:	83 ec 08             	sub    $0x8,%esp
  800e72:	ff 75 0c             	pushl  0xc(%ebp)
  800e75:	50                   	push   %eax
  800e76:	8b 45 08             	mov    0x8(%ebp),%eax
  800e79:	ff d0                	call   *%eax
  800e7b:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800e7e:	ff 4d e4             	decl   -0x1c(%ebp)
  800e81:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800e85:	7f e4                	jg     800e6b <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800e87:	eb 34                	jmp    800ebd <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800e89:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800e8d:	74 1c                	je     800eab <vprintfmt+0x207>
  800e8f:	83 fb 1f             	cmp    $0x1f,%ebx
  800e92:	7e 05                	jle    800e99 <vprintfmt+0x1f5>
  800e94:	83 fb 7e             	cmp    $0x7e,%ebx
  800e97:	7e 12                	jle    800eab <vprintfmt+0x207>
					putch('?', putdat);
  800e99:	83 ec 08             	sub    $0x8,%esp
  800e9c:	ff 75 0c             	pushl  0xc(%ebp)
  800e9f:	6a 3f                	push   $0x3f
  800ea1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ea4:	ff d0                	call   *%eax
  800ea6:	83 c4 10             	add    $0x10,%esp
  800ea9:	eb 0f                	jmp    800eba <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800eab:	83 ec 08             	sub    $0x8,%esp
  800eae:	ff 75 0c             	pushl  0xc(%ebp)
  800eb1:	53                   	push   %ebx
  800eb2:	8b 45 08             	mov    0x8(%ebp),%eax
  800eb5:	ff d0                	call   *%eax
  800eb7:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800eba:	ff 4d e4             	decl   -0x1c(%ebp)
  800ebd:	89 f0                	mov    %esi,%eax
  800ebf:	8d 70 01             	lea    0x1(%eax),%esi
  800ec2:	8a 00                	mov    (%eax),%al
  800ec4:	0f be d8             	movsbl %al,%ebx
  800ec7:	85 db                	test   %ebx,%ebx
  800ec9:	74 24                	je     800eef <vprintfmt+0x24b>
  800ecb:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800ecf:	78 b8                	js     800e89 <vprintfmt+0x1e5>
  800ed1:	ff 4d e0             	decl   -0x20(%ebp)
  800ed4:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800ed8:	79 af                	jns    800e89 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800eda:	eb 13                	jmp    800eef <vprintfmt+0x24b>
				putch(' ', putdat);
  800edc:	83 ec 08             	sub    $0x8,%esp
  800edf:	ff 75 0c             	pushl  0xc(%ebp)
  800ee2:	6a 20                	push   $0x20
  800ee4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ee7:	ff d0                	call   *%eax
  800ee9:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800eec:	ff 4d e4             	decl   -0x1c(%ebp)
  800eef:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800ef3:	7f e7                	jg     800edc <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800ef5:	e9 78 01 00 00       	jmp    801072 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800efa:	83 ec 08             	sub    $0x8,%esp
  800efd:	ff 75 e8             	pushl  -0x18(%ebp)
  800f00:	8d 45 14             	lea    0x14(%ebp),%eax
  800f03:	50                   	push   %eax
  800f04:	e8 3c fd ff ff       	call   800c45 <getint>
  800f09:	83 c4 10             	add    $0x10,%esp
  800f0c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f0f:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800f12:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800f15:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f18:	85 d2                	test   %edx,%edx
  800f1a:	79 23                	jns    800f3f <vprintfmt+0x29b>
				putch('-', putdat);
  800f1c:	83 ec 08             	sub    $0x8,%esp
  800f1f:	ff 75 0c             	pushl  0xc(%ebp)
  800f22:	6a 2d                	push   $0x2d
  800f24:	8b 45 08             	mov    0x8(%ebp),%eax
  800f27:	ff d0                	call   *%eax
  800f29:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800f2c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800f2f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f32:	f7 d8                	neg    %eax
  800f34:	83 d2 00             	adc    $0x0,%edx
  800f37:	f7 da                	neg    %edx
  800f39:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f3c:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800f3f:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800f46:	e9 bc 00 00 00       	jmp    801007 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800f4b:	83 ec 08             	sub    $0x8,%esp
  800f4e:	ff 75 e8             	pushl  -0x18(%ebp)
  800f51:	8d 45 14             	lea    0x14(%ebp),%eax
  800f54:	50                   	push   %eax
  800f55:	e8 84 fc ff ff       	call   800bde <getuint>
  800f5a:	83 c4 10             	add    $0x10,%esp
  800f5d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f60:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800f63:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800f6a:	e9 98 00 00 00       	jmp    801007 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800f6f:	83 ec 08             	sub    $0x8,%esp
  800f72:	ff 75 0c             	pushl  0xc(%ebp)
  800f75:	6a 58                	push   $0x58
  800f77:	8b 45 08             	mov    0x8(%ebp),%eax
  800f7a:	ff d0                	call   *%eax
  800f7c:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800f7f:	83 ec 08             	sub    $0x8,%esp
  800f82:	ff 75 0c             	pushl  0xc(%ebp)
  800f85:	6a 58                	push   $0x58
  800f87:	8b 45 08             	mov    0x8(%ebp),%eax
  800f8a:	ff d0                	call   *%eax
  800f8c:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800f8f:	83 ec 08             	sub    $0x8,%esp
  800f92:	ff 75 0c             	pushl  0xc(%ebp)
  800f95:	6a 58                	push   $0x58
  800f97:	8b 45 08             	mov    0x8(%ebp),%eax
  800f9a:	ff d0                	call   *%eax
  800f9c:	83 c4 10             	add    $0x10,%esp
			break;
  800f9f:	e9 ce 00 00 00       	jmp    801072 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800fa4:	83 ec 08             	sub    $0x8,%esp
  800fa7:	ff 75 0c             	pushl  0xc(%ebp)
  800faa:	6a 30                	push   $0x30
  800fac:	8b 45 08             	mov    0x8(%ebp),%eax
  800faf:	ff d0                	call   *%eax
  800fb1:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800fb4:	83 ec 08             	sub    $0x8,%esp
  800fb7:	ff 75 0c             	pushl  0xc(%ebp)
  800fba:	6a 78                	push   $0x78
  800fbc:	8b 45 08             	mov    0x8(%ebp),%eax
  800fbf:	ff d0                	call   *%eax
  800fc1:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800fc4:	8b 45 14             	mov    0x14(%ebp),%eax
  800fc7:	83 c0 04             	add    $0x4,%eax
  800fca:	89 45 14             	mov    %eax,0x14(%ebp)
  800fcd:	8b 45 14             	mov    0x14(%ebp),%eax
  800fd0:	83 e8 04             	sub    $0x4,%eax
  800fd3:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800fd5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800fd8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800fdf:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800fe6:	eb 1f                	jmp    801007 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800fe8:	83 ec 08             	sub    $0x8,%esp
  800feb:	ff 75 e8             	pushl  -0x18(%ebp)
  800fee:	8d 45 14             	lea    0x14(%ebp),%eax
  800ff1:	50                   	push   %eax
  800ff2:	e8 e7 fb ff ff       	call   800bde <getuint>
  800ff7:	83 c4 10             	add    $0x10,%esp
  800ffa:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ffd:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  801000:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  801007:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  80100b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80100e:	83 ec 04             	sub    $0x4,%esp
  801011:	52                   	push   %edx
  801012:	ff 75 e4             	pushl  -0x1c(%ebp)
  801015:	50                   	push   %eax
  801016:	ff 75 f4             	pushl  -0xc(%ebp)
  801019:	ff 75 f0             	pushl  -0x10(%ebp)
  80101c:	ff 75 0c             	pushl  0xc(%ebp)
  80101f:	ff 75 08             	pushl  0x8(%ebp)
  801022:	e8 00 fb ff ff       	call   800b27 <printnum>
  801027:	83 c4 20             	add    $0x20,%esp
			break;
  80102a:	eb 46                	jmp    801072 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  80102c:	83 ec 08             	sub    $0x8,%esp
  80102f:	ff 75 0c             	pushl  0xc(%ebp)
  801032:	53                   	push   %ebx
  801033:	8b 45 08             	mov    0x8(%ebp),%eax
  801036:	ff d0                	call   *%eax
  801038:	83 c4 10             	add    $0x10,%esp
			break;
  80103b:	eb 35                	jmp    801072 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  80103d:	c6 05 44 60 80 00 00 	movb   $0x0,0x806044
			break;
  801044:	eb 2c                	jmp    801072 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  801046:	c6 05 44 60 80 00 01 	movb   $0x1,0x806044
			break;
  80104d:	eb 23                	jmp    801072 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  80104f:	83 ec 08             	sub    $0x8,%esp
  801052:	ff 75 0c             	pushl  0xc(%ebp)
  801055:	6a 25                	push   $0x25
  801057:	8b 45 08             	mov    0x8(%ebp),%eax
  80105a:	ff d0                	call   *%eax
  80105c:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  80105f:	ff 4d 10             	decl   0x10(%ebp)
  801062:	eb 03                	jmp    801067 <vprintfmt+0x3c3>
  801064:	ff 4d 10             	decl   0x10(%ebp)
  801067:	8b 45 10             	mov    0x10(%ebp),%eax
  80106a:	48                   	dec    %eax
  80106b:	8a 00                	mov    (%eax),%al
  80106d:	3c 25                	cmp    $0x25,%al
  80106f:	75 f3                	jne    801064 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  801071:	90                   	nop
		}
	}
  801072:	e9 35 fc ff ff       	jmp    800cac <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  801077:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  801078:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80107b:	5b                   	pop    %ebx
  80107c:	5e                   	pop    %esi
  80107d:	5d                   	pop    %ebp
  80107e:	c3                   	ret    

0080107f <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  80107f:	55                   	push   %ebp
  801080:	89 e5                	mov    %esp,%ebp
  801082:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  801085:	8d 45 10             	lea    0x10(%ebp),%eax
  801088:	83 c0 04             	add    $0x4,%eax
  80108b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  80108e:	8b 45 10             	mov    0x10(%ebp),%eax
  801091:	ff 75 f4             	pushl  -0xc(%ebp)
  801094:	50                   	push   %eax
  801095:	ff 75 0c             	pushl  0xc(%ebp)
  801098:	ff 75 08             	pushl  0x8(%ebp)
  80109b:	e8 04 fc ff ff       	call   800ca4 <vprintfmt>
  8010a0:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  8010a3:	90                   	nop
  8010a4:	c9                   	leave  
  8010a5:	c3                   	ret    

008010a6 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8010a6:	55                   	push   %ebp
  8010a7:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  8010a9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010ac:	8b 40 08             	mov    0x8(%eax),%eax
  8010af:	8d 50 01             	lea    0x1(%eax),%edx
  8010b2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010b5:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  8010b8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010bb:	8b 10                	mov    (%eax),%edx
  8010bd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010c0:	8b 40 04             	mov    0x4(%eax),%eax
  8010c3:	39 c2                	cmp    %eax,%edx
  8010c5:	73 12                	jae    8010d9 <sprintputch+0x33>
		*b->buf++ = ch;
  8010c7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010ca:	8b 00                	mov    (%eax),%eax
  8010cc:	8d 48 01             	lea    0x1(%eax),%ecx
  8010cf:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010d2:	89 0a                	mov    %ecx,(%edx)
  8010d4:	8b 55 08             	mov    0x8(%ebp),%edx
  8010d7:	88 10                	mov    %dl,(%eax)
}
  8010d9:	90                   	nop
  8010da:	5d                   	pop    %ebp
  8010db:	c3                   	ret    

008010dc <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8010dc:	55                   	push   %ebp
  8010dd:	89 e5                	mov    %esp,%ebp
  8010df:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  8010e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8010e5:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8010e8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010eb:	8d 50 ff             	lea    -0x1(%eax),%edx
  8010ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8010f1:	01 d0                	add    %edx,%eax
  8010f3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8010f6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8010fd:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801101:	74 06                	je     801109 <vsnprintf+0x2d>
  801103:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801107:	7f 07                	jg     801110 <vsnprintf+0x34>
		return -E_INVAL;
  801109:	b8 03 00 00 00       	mov    $0x3,%eax
  80110e:	eb 20                	jmp    801130 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  801110:	ff 75 14             	pushl  0x14(%ebp)
  801113:	ff 75 10             	pushl  0x10(%ebp)
  801116:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801119:	50                   	push   %eax
  80111a:	68 a6 10 80 00       	push   $0x8010a6
  80111f:	e8 80 fb ff ff       	call   800ca4 <vprintfmt>
  801124:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  801127:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80112a:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  80112d:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801130:	c9                   	leave  
  801131:	c3                   	ret    

00801132 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801132:	55                   	push   %ebp
  801133:	89 e5                	mov    %esp,%ebp
  801135:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801138:	8d 45 10             	lea    0x10(%ebp),%eax
  80113b:	83 c0 04             	add    $0x4,%eax
  80113e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  801141:	8b 45 10             	mov    0x10(%ebp),%eax
  801144:	ff 75 f4             	pushl  -0xc(%ebp)
  801147:	50                   	push   %eax
  801148:	ff 75 0c             	pushl  0xc(%ebp)
  80114b:	ff 75 08             	pushl  0x8(%ebp)
  80114e:	e8 89 ff ff ff       	call   8010dc <vsnprintf>
  801153:	83 c4 10             	add    $0x10,%esp
  801156:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  801159:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80115c:	c9                   	leave  
  80115d:	c3                   	ret    

0080115e <readline>:
#include <inc/lib.h>

//static char buf[BUFLEN];

void readline(const char *prompt, char* buf)
{
  80115e:	55                   	push   %ebp
  80115f:	89 e5                	mov    %esp,%ebp
  801161:	83 ec 18             	sub    $0x18,%esp
	int i, c, echoing;

	if (prompt != NULL)
  801164:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801168:	74 13                	je     80117d <readline+0x1f>
		cprintf("%s", prompt);
  80116a:	83 ec 08             	sub    $0x8,%esp
  80116d:	ff 75 08             	pushl  0x8(%ebp)
  801170:	68 88 50 80 00       	push   $0x805088
  801175:	e8 0b f9 ff ff       	call   800a85 <cprintf>
  80117a:	83 c4 10             	add    $0x10,%esp

	i = 0;
  80117d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  801184:	83 ec 0c             	sub    $0xc,%esp
  801187:	6a 00                	push   $0x0
  801189:	e8 66 f4 ff ff       	call   8005f4 <iscons>
  80118e:	83 c4 10             	add    $0x10,%esp
  801191:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  801194:	e8 48 f4 ff ff       	call   8005e1 <getchar>
  801199:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (c < 0) {
  80119c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8011a0:	79 22                	jns    8011c4 <readline+0x66>
			if (c != -E_EOF)
  8011a2:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  8011a6:	0f 84 ad 00 00 00    	je     801259 <readline+0xfb>
				cprintf("read error: %e\n", c);
  8011ac:	83 ec 08             	sub    $0x8,%esp
  8011af:	ff 75 ec             	pushl  -0x14(%ebp)
  8011b2:	68 8b 50 80 00       	push   $0x80508b
  8011b7:	e8 c9 f8 ff ff       	call   800a85 <cprintf>
  8011bc:	83 c4 10             	add    $0x10,%esp
			break;
  8011bf:	e9 95 00 00 00       	jmp    801259 <readline+0xfb>
		} else if (c >= ' ' && i < BUFLEN-1) {
  8011c4:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  8011c8:	7e 34                	jle    8011fe <readline+0xa0>
  8011ca:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  8011d1:	7f 2b                	jg     8011fe <readline+0xa0>
			if (echoing)
  8011d3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8011d7:	74 0e                	je     8011e7 <readline+0x89>
				cputchar(c);
  8011d9:	83 ec 0c             	sub    $0xc,%esp
  8011dc:	ff 75 ec             	pushl  -0x14(%ebp)
  8011df:	e8 de f3 ff ff       	call   8005c2 <cputchar>
  8011e4:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  8011e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8011ea:	8d 50 01             	lea    0x1(%eax),%edx
  8011ed:	89 55 f4             	mov    %edx,-0xc(%ebp)
  8011f0:	89 c2                	mov    %eax,%edx
  8011f2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011f5:	01 d0                	add    %edx,%eax
  8011f7:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8011fa:	88 10                	mov    %dl,(%eax)
  8011fc:	eb 56                	jmp    801254 <readline+0xf6>
		} else if (c == '\b' && i > 0) {
  8011fe:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  801202:	75 1f                	jne    801223 <readline+0xc5>
  801204:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801208:	7e 19                	jle    801223 <readline+0xc5>
			if (echoing)
  80120a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80120e:	74 0e                	je     80121e <readline+0xc0>
				cputchar(c);
  801210:	83 ec 0c             	sub    $0xc,%esp
  801213:	ff 75 ec             	pushl  -0x14(%ebp)
  801216:	e8 a7 f3 ff ff       	call   8005c2 <cputchar>
  80121b:	83 c4 10             	add    $0x10,%esp

			i--;
  80121e:	ff 4d f4             	decl   -0xc(%ebp)
  801221:	eb 31                	jmp    801254 <readline+0xf6>
		} else if (c == '\n' || c == '\r') {
  801223:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  801227:	74 0a                	je     801233 <readline+0xd5>
  801229:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  80122d:	0f 85 61 ff ff ff    	jne    801194 <readline+0x36>
			if (echoing)
  801233:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801237:	74 0e                	je     801247 <readline+0xe9>
				cputchar(c);
  801239:	83 ec 0c             	sub    $0xc,%esp
  80123c:	ff 75 ec             	pushl  -0x14(%ebp)
  80123f:	e8 7e f3 ff ff       	call   8005c2 <cputchar>
  801244:	83 c4 10             	add    $0x10,%esp

			buf[i] = 0;
  801247:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80124a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80124d:	01 d0                	add    %edx,%eax
  80124f:	c6 00 00             	movb   $0x0,(%eax)
			break;
  801252:	eb 06                	jmp    80125a <readline+0xfc>
		}
	}
  801254:	e9 3b ff ff ff       	jmp    801194 <readline+0x36>
	while (1) {
		c = getchar();
		if (c < 0) {
			if (c != -E_EOF)
				cprintf("read error: %e\n", c);
			break;
  801259:	90                   	nop

			buf[i] = 0;
			break;
		}
	}
}
  80125a:	90                   	nop
  80125b:	c9                   	leave  
  80125c:	c3                   	ret    

0080125d <atomic_readline>:

void atomic_readline(const char *prompt, char* buf)
{
  80125d:	55                   	push   %ebp
  80125e:	89 e5                	mov    %esp,%ebp
  801260:	83 ec 18             	sub    $0x18,%esp
	sys_lock_cons();
  801263:	e8 e0 22 00 00       	call   803548 <sys_lock_cons>
	{
		int i, c, echoing;

		if (prompt != NULL)
  801268:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80126c:	74 13                	je     801281 <atomic_readline+0x24>
			cprintf("%s", prompt);
  80126e:	83 ec 08             	sub    $0x8,%esp
  801271:	ff 75 08             	pushl  0x8(%ebp)
  801274:	68 88 50 80 00       	push   $0x805088
  801279:	e8 07 f8 ff ff       	call   800a85 <cprintf>
  80127e:	83 c4 10             	add    $0x10,%esp

		i = 0;
  801281:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
		echoing = iscons(0);
  801288:	83 ec 0c             	sub    $0xc,%esp
  80128b:	6a 00                	push   $0x0
  80128d:	e8 62 f3 ff ff       	call   8005f4 <iscons>
  801292:	83 c4 10             	add    $0x10,%esp
  801295:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (1) {
			c = getchar();
  801298:	e8 44 f3 ff ff       	call   8005e1 <getchar>
  80129d:	89 45 ec             	mov    %eax,-0x14(%ebp)
			if (c < 0) {
  8012a0:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8012a4:	79 22                	jns    8012c8 <atomic_readline+0x6b>
				if (c != -E_EOF)
  8012a6:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  8012aa:	0f 84 ad 00 00 00    	je     80135d <atomic_readline+0x100>
					cprintf("read error: %e\n", c);
  8012b0:	83 ec 08             	sub    $0x8,%esp
  8012b3:	ff 75 ec             	pushl  -0x14(%ebp)
  8012b6:	68 8b 50 80 00       	push   $0x80508b
  8012bb:	e8 c5 f7 ff ff       	call   800a85 <cprintf>
  8012c0:	83 c4 10             	add    $0x10,%esp
				break;
  8012c3:	e9 95 00 00 00       	jmp    80135d <atomic_readline+0x100>
			} else if (c >= ' ' && i < BUFLEN-1) {
  8012c8:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  8012cc:	7e 34                	jle    801302 <atomic_readline+0xa5>
  8012ce:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  8012d5:	7f 2b                	jg     801302 <atomic_readline+0xa5>
				if (echoing)
  8012d7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8012db:	74 0e                	je     8012eb <atomic_readline+0x8e>
					cputchar(c);
  8012dd:	83 ec 0c             	sub    $0xc,%esp
  8012e0:	ff 75 ec             	pushl  -0x14(%ebp)
  8012e3:	e8 da f2 ff ff       	call   8005c2 <cputchar>
  8012e8:	83 c4 10             	add    $0x10,%esp
				buf[i++] = c;
  8012eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8012ee:	8d 50 01             	lea    0x1(%eax),%edx
  8012f1:	89 55 f4             	mov    %edx,-0xc(%ebp)
  8012f4:	89 c2                	mov    %eax,%edx
  8012f6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012f9:	01 d0                	add    %edx,%eax
  8012fb:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8012fe:	88 10                	mov    %dl,(%eax)
  801300:	eb 56                	jmp    801358 <atomic_readline+0xfb>
			} else if (c == '\b' && i > 0) {
  801302:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  801306:	75 1f                	jne    801327 <atomic_readline+0xca>
  801308:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80130c:	7e 19                	jle    801327 <atomic_readline+0xca>
				if (echoing)
  80130e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801312:	74 0e                	je     801322 <atomic_readline+0xc5>
					cputchar(c);
  801314:	83 ec 0c             	sub    $0xc,%esp
  801317:	ff 75 ec             	pushl  -0x14(%ebp)
  80131a:	e8 a3 f2 ff ff       	call   8005c2 <cputchar>
  80131f:	83 c4 10             	add    $0x10,%esp
				i--;
  801322:	ff 4d f4             	decl   -0xc(%ebp)
  801325:	eb 31                	jmp    801358 <atomic_readline+0xfb>
			} else if (c == '\n' || c == '\r') {
  801327:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  80132b:	74 0a                	je     801337 <atomic_readline+0xda>
  80132d:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  801331:	0f 85 61 ff ff ff    	jne    801298 <atomic_readline+0x3b>
				if (echoing)
  801337:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80133b:	74 0e                	je     80134b <atomic_readline+0xee>
					cputchar(c);
  80133d:	83 ec 0c             	sub    $0xc,%esp
  801340:	ff 75 ec             	pushl  -0x14(%ebp)
  801343:	e8 7a f2 ff ff       	call   8005c2 <cputchar>
  801348:	83 c4 10             	add    $0x10,%esp
				buf[i] = 0;
  80134b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80134e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801351:	01 d0                	add    %edx,%eax
  801353:	c6 00 00             	movb   $0x0,(%eax)
				break;
  801356:	eb 06                	jmp    80135e <atomic_readline+0x101>
			}
		}
  801358:	e9 3b ff ff ff       	jmp    801298 <atomic_readline+0x3b>
		while (1) {
			c = getchar();
			if (c < 0) {
				if (c != -E_EOF)
					cprintf("read error: %e\n", c);
				break;
  80135d:	90                   	nop
				buf[i] = 0;
				break;
			}
		}
	}
	sys_unlock_cons();
  80135e:	e8 ff 21 00 00       	call   803562 <sys_unlock_cons>
}
  801363:	90                   	nop
  801364:	c9                   	leave  
  801365:	c3                   	ret    

00801366 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  801366:	55                   	push   %ebp
  801367:	89 e5                	mov    %esp,%ebp
  801369:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  80136c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801373:	eb 06                	jmp    80137b <strlen+0x15>
		n++;
  801375:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801378:	ff 45 08             	incl   0x8(%ebp)
  80137b:	8b 45 08             	mov    0x8(%ebp),%eax
  80137e:	8a 00                	mov    (%eax),%al
  801380:	84 c0                	test   %al,%al
  801382:	75 f1                	jne    801375 <strlen+0xf>
		n++;
	return n;
  801384:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801387:	c9                   	leave  
  801388:	c3                   	ret    

00801389 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  801389:	55                   	push   %ebp
  80138a:	89 e5                	mov    %esp,%ebp
  80138c:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80138f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801396:	eb 09                	jmp    8013a1 <strnlen+0x18>
		n++;
  801398:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80139b:	ff 45 08             	incl   0x8(%ebp)
  80139e:	ff 4d 0c             	decl   0xc(%ebp)
  8013a1:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8013a5:	74 09                	je     8013b0 <strnlen+0x27>
  8013a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8013aa:	8a 00                	mov    (%eax),%al
  8013ac:	84 c0                	test   %al,%al
  8013ae:	75 e8                	jne    801398 <strnlen+0xf>
		n++;
	return n;
  8013b0:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8013b3:	c9                   	leave  
  8013b4:	c3                   	ret    

008013b5 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8013b5:	55                   	push   %ebp
  8013b6:	89 e5                	mov    %esp,%ebp
  8013b8:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  8013bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8013be:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  8013c1:	90                   	nop
  8013c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8013c5:	8d 50 01             	lea    0x1(%eax),%edx
  8013c8:	89 55 08             	mov    %edx,0x8(%ebp)
  8013cb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8013ce:	8d 4a 01             	lea    0x1(%edx),%ecx
  8013d1:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8013d4:	8a 12                	mov    (%edx),%dl
  8013d6:	88 10                	mov    %dl,(%eax)
  8013d8:	8a 00                	mov    (%eax),%al
  8013da:	84 c0                	test   %al,%al
  8013dc:	75 e4                	jne    8013c2 <strcpy+0xd>
		/* do nothing */;
	return ret;
  8013de:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8013e1:	c9                   	leave  
  8013e2:	c3                   	ret    

008013e3 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  8013e3:	55                   	push   %ebp
  8013e4:	89 e5                	mov    %esp,%ebp
  8013e6:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  8013e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8013ec:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  8013ef:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8013f6:	eb 1f                	jmp    801417 <strncpy+0x34>
		*dst++ = *src;
  8013f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8013fb:	8d 50 01             	lea    0x1(%eax),%edx
  8013fe:	89 55 08             	mov    %edx,0x8(%ebp)
  801401:	8b 55 0c             	mov    0xc(%ebp),%edx
  801404:	8a 12                	mov    (%edx),%dl
  801406:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801408:	8b 45 0c             	mov    0xc(%ebp),%eax
  80140b:	8a 00                	mov    (%eax),%al
  80140d:	84 c0                	test   %al,%al
  80140f:	74 03                	je     801414 <strncpy+0x31>
			src++;
  801411:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801414:	ff 45 fc             	incl   -0x4(%ebp)
  801417:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80141a:	3b 45 10             	cmp    0x10(%ebp),%eax
  80141d:	72 d9                	jb     8013f8 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  80141f:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801422:	c9                   	leave  
  801423:	c3                   	ret    

00801424 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  801424:	55                   	push   %ebp
  801425:	89 e5                	mov    %esp,%ebp
  801427:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  80142a:	8b 45 08             	mov    0x8(%ebp),%eax
  80142d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  801430:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801434:	74 30                	je     801466 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  801436:	eb 16                	jmp    80144e <strlcpy+0x2a>
			*dst++ = *src++;
  801438:	8b 45 08             	mov    0x8(%ebp),%eax
  80143b:	8d 50 01             	lea    0x1(%eax),%edx
  80143e:	89 55 08             	mov    %edx,0x8(%ebp)
  801441:	8b 55 0c             	mov    0xc(%ebp),%edx
  801444:	8d 4a 01             	lea    0x1(%edx),%ecx
  801447:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  80144a:	8a 12                	mov    (%edx),%dl
  80144c:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  80144e:	ff 4d 10             	decl   0x10(%ebp)
  801451:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801455:	74 09                	je     801460 <strlcpy+0x3c>
  801457:	8b 45 0c             	mov    0xc(%ebp),%eax
  80145a:	8a 00                	mov    (%eax),%al
  80145c:	84 c0                	test   %al,%al
  80145e:	75 d8                	jne    801438 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  801460:	8b 45 08             	mov    0x8(%ebp),%eax
  801463:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  801466:	8b 55 08             	mov    0x8(%ebp),%edx
  801469:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80146c:	29 c2                	sub    %eax,%edx
  80146e:	89 d0                	mov    %edx,%eax
}
  801470:	c9                   	leave  
  801471:	c3                   	ret    

00801472 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801472:	55                   	push   %ebp
  801473:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  801475:	eb 06                	jmp    80147d <strcmp+0xb>
		p++, q++;
  801477:	ff 45 08             	incl   0x8(%ebp)
  80147a:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  80147d:	8b 45 08             	mov    0x8(%ebp),%eax
  801480:	8a 00                	mov    (%eax),%al
  801482:	84 c0                	test   %al,%al
  801484:	74 0e                	je     801494 <strcmp+0x22>
  801486:	8b 45 08             	mov    0x8(%ebp),%eax
  801489:	8a 10                	mov    (%eax),%dl
  80148b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80148e:	8a 00                	mov    (%eax),%al
  801490:	38 c2                	cmp    %al,%dl
  801492:	74 e3                	je     801477 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801494:	8b 45 08             	mov    0x8(%ebp),%eax
  801497:	8a 00                	mov    (%eax),%al
  801499:	0f b6 d0             	movzbl %al,%edx
  80149c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80149f:	8a 00                	mov    (%eax),%al
  8014a1:	0f b6 c0             	movzbl %al,%eax
  8014a4:	29 c2                	sub    %eax,%edx
  8014a6:	89 d0                	mov    %edx,%eax
}
  8014a8:	5d                   	pop    %ebp
  8014a9:	c3                   	ret    

008014aa <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  8014aa:	55                   	push   %ebp
  8014ab:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  8014ad:	eb 09                	jmp    8014b8 <strncmp+0xe>
		n--, p++, q++;
  8014af:	ff 4d 10             	decl   0x10(%ebp)
  8014b2:	ff 45 08             	incl   0x8(%ebp)
  8014b5:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  8014b8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8014bc:	74 17                	je     8014d5 <strncmp+0x2b>
  8014be:	8b 45 08             	mov    0x8(%ebp),%eax
  8014c1:	8a 00                	mov    (%eax),%al
  8014c3:	84 c0                	test   %al,%al
  8014c5:	74 0e                	je     8014d5 <strncmp+0x2b>
  8014c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ca:	8a 10                	mov    (%eax),%dl
  8014cc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014cf:	8a 00                	mov    (%eax),%al
  8014d1:	38 c2                	cmp    %al,%dl
  8014d3:	74 da                	je     8014af <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  8014d5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8014d9:	75 07                	jne    8014e2 <strncmp+0x38>
		return 0;
  8014db:	b8 00 00 00 00       	mov    $0x0,%eax
  8014e0:	eb 14                	jmp    8014f6 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8014e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8014e5:	8a 00                	mov    (%eax),%al
  8014e7:	0f b6 d0             	movzbl %al,%edx
  8014ea:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014ed:	8a 00                	mov    (%eax),%al
  8014ef:	0f b6 c0             	movzbl %al,%eax
  8014f2:	29 c2                	sub    %eax,%edx
  8014f4:	89 d0                	mov    %edx,%eax
}
  8014f6:	5d                   	pop    %ebp
  8014f7:	c3                   	ret    

008014f8 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8014f8:	55                   	push   %ebp
  8014f9:	89 e5                	mov    %esp,%ebp
  8014fb:	83 ec 04             	sub    $0x4,%esp
  8014fe:	8b 45 0c             	mov    0xc(%ebp),%eax
  801501:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801504:	eb 12                	jmp    801518 <strchr+0x20>
		if (*s == c)
  801506:	8b 45 08             	mov    0x8(%ebp),%eax
  801509:	8a 00                	mov    (%eax),%al
  80150b:	3a 45 fc             	cmp    -0x4(%ebp),%al
  80150e:	75 05                	jne    801515 <strchr+0x1d>
			return (char *) s;
  801510:	8b 45 08             	mov    0x8(%ebp),%eax
  801513:	eb 11                	jmp    801526 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801515:	ff 45 08             	incl   0x8(%ebp)
  801518:	8b 45 08             	mov    0x8(%ebp),%eax
  80151b:	8a 00                	mov    (%eax),%al
  80151d:	84 c0                	test   %al,%al
  80151f:	75 e5                	jne    801506 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  801521:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801526:	c9                   	leave  
  801527:	c3                   	ret    

00801528 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801528:	55                   	push   %ebp
  801529:	89 e5                	mov    %esp,%ebp
  80152b:	83 ec 04             	sub    $0x4,%esp
  80152e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801531:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801534:	eb 0d                	jmp    801543 <strfind+0x1b>
		if (*s == c)
  801536:	8b 45 08             	mov    0x8(%ebp),%eax
  801539:	8a 00                	mov    (%eax),%al
  80153b:	3a 45 fc             	cmp    -0x4(%ebp),%al
  80153e:	74 0e                	je     80154e <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801540:	ff 45 08             	incl   0x8(%ebp)
  801543:	8b 45 08             	mov    0x8(%ebp),%eax
  801546:	8a 00                	mov    (%eax),%al
  801548:	84 c0                	test   %al,%al
  80154a:	75 ea                	jne    801536 <strfind+0xe>
  80154c:	eb 01                	jmp    80154f <strfind+0x27>
		if (*s == c)
			break;
  80154e:	90                   	nop
	return (char *) s;
  80154f:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801552:	c9                   	leave  
  801553:	c3                   	ret    

00801554 <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  801554:	55                   	push   %ebp
  801555:	89 e5                	mov    %esp,%ebp
  801557:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  80155a:	8b 45 08             	mov    0x8(%ebp),%eax
  80155d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  801560:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801564:	76 63                	jbe    8015c9 <memset+0x75>
		uint64 data_block = c;
  801566:	8b 45 0c             	mov    0xc(%ebp),%eax
  801569:	99                   	cltd   
  80156a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80156d:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  801570:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801573:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801576:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  80157a:	c1 e0 08             	shl    $0x8,%eax
  80157d:	09 45 f0             	or     %eax,-0x10(%ebp)
  801580:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  801583:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801586:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801589:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  80158d:	c1 e0 10             	shl    $0x10,%eax
  801590:	09 45 f0             	or     %eax,-0x10(%ebp)
  801593:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  801596:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801599:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80159c:	89 c2                	mov    %eax,%edx
  80159e:	b8 00 00 00 00       	mov    $0x0,%eax
  8015a3:	09 45 f0             	or     %eax,-0x10(%ebp)
  8015a6:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  8015a9:	eb 18                	jmp    8015c3 <memset+0x6f>
			*p64++ = data_block, n -= 8;
  8015ab:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8015ae:	8d 41 08             	lea    0x8(%ecx),%eax
  8015b1:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8015b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015b7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8015ba:	89 01                	mov    %eax,(%ecx)
  8015bc:	89 51 04             	mov    %edx,0x4(%ecx)
  8015bf:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  8015c3:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  8015c7:	77 e2                	ja     8015ab <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  8015c9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8015cd:	74 23                	je     8015f2 <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  8015cf:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8015d2:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  8015d5:	eb 0e                	jmp    8015e5 <memset+0x91>
			*p8++ = (uint8)c;
  8015d7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8015da:	8d 50 01             	lea    0x1(%eax),%edx
  8015dd:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8015e0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015e3:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  8015e5:	8b 45 10             	mov    0x10(%ebp),%eax
  8015e8:	8d 50 ff             	lea    -0x1(%eax),%edx
  8015eb:	89 55 10             	mov    %edx,0x10(%ebp)
  8015ee:	85 c0                	test   %eax,%eax
  8015f0:	75 e5                	jne    8015d7 <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  8015f2:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8015f5:	c9                   	leave  
  8015f6:	c3                   	ret    

008015f7 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  8015f7:	55                   	push   %ebp
  8015f8:	89 e5                	mov    %esp,%ebp
  8015fa:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  8015fd:	8b 45 0c             	mov    0xc(%ebp),%eax
  801600:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  801603:	8b 45 08             	mov    0x8(%ebp),%eax
  801606:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  801609:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  80160d:	76 24                	jbe    801633 <memcpy+0x3c>
		while(n >= 8){
  80160f:	eb 1c                	jmp    80162d <memcpy+0x36>
			*d64 = *s64;
  801611:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801614:	8b 50 04             	mov    0x4(%eax),%edx
  801617:	8b 00                	mov    (%eax),%eax
  801619:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  80161c:	89 01                	mov    %eax,(%ecx)
  80161e:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  801621:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  801625:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  801629:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  80162d:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801631:	77 de                	ja     801611 <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  801633:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801637:	74 31                	je     80166a <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  801639:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80163c:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  80163f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801642:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  801645:	eb 16                	jmp    80165d <memcpy+0x66>
			*d8++ = *s8++;
  801647:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80164a:	8d 50 01             	lea    0x1(%eax),%edx
  80164d:	89 55 f0             	mov    %edx,-0x10(%ebp)
  801650:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801653:	8d 4a 01             	lea    0x1(%edx),%ecx
  801656:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  801659:	8a 12                	mov    (%edx),%dl
  80165b:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  80165d:	8b 45 10             	mov    0x10(%ebp),%eax
  801660:	8d 50 ff             	lea    -0x1(%eax),%edx
  801663:	89 55 10             	mov    %edx,0x10(%ebp)
  801666:	85 c0                	test   %eax,%eax
  801668:	75 dd                	jne    801647 <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  80166a:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80166d:	c9                   	leave  
  80166e:	c3                   	ret    

0080166f <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  80166f:	55                   	push   %ebp
  801670:	89 e5                	mov    %esp,%ebp
  801672:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801675:	8b 45 0c             	mov    0xc(%ebp),%eax
  801678:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  80167b:	8b 45 08             	mov    0x8(%ebp),%eax
  80167e:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801681:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801684:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801687:	73 50                	jae    8016d9 <memmove+0x6a>
  801689:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80168c:	8b 45 10             	mov    0x10(%ebp),%eax
  80168f:	01 d0                	add    %edx,%eax
  801691:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801694:	76 43                	jbe    8016d9 <memmove+0x6a>
		s += n;
  801696:	8b 45 10             	mov    0x10(%ebp),%eax
  801699:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  80169c:	8b 45 10             	mov    0x10(%ebp),%eax
  80169f:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  8016a2:	eb 10                	jmp    8016b4 <memmove+0x45>
			*--d = *--s;
  8016a4:	ff 4d f8             	decl   -0x8(%ebp)
  8016a7:	ff 4d fc             	decl   -0x4(%ebp)
  8016aa:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8016ad:	8a 10                	mov    (%eax),%dl
  8016af:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8016b2:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  8016b4:	8b 45 10             	mov    0x10(%ebp),%eax
  8016b7:	8d 50 ff             	lea    -0x1(%eax),%edx
  8016ba:	89 55 10             	mov    %edx,0x10(%ebp)
  8016bd:	85 c0                	test   %eax,%eax
  8016bf:	75 e3                	jne    8016a4 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8016c1:	eb 23                	jmp    8016e6 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  8016c3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8016c6:	8d 50 01             	lea    0x1(%eax),%edx
  8016c9:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8016cc:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8016cf:	8d 4a 01             	lea    0x1(%edx),%ecx
  8016d2:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8016d5:	8a 12                	mov    (%edx),%dl
  8016d7:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  8016d9:	8b 45 10             	mov    0x10(%ebp),%eax
  8016dc:	8d 50 ff             	lea    -0x1(%eax),%edx
  8016df:	89 55 10             	mov    %edx,0x10(%ebp)
  8016e2:	85 c0                	test   %eax,%eax
  8016e4:	75 dd                	jne    8016c3 <memmove+0x54>
			*d++ = *s++;

	return dst;
  8016e6:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8016e9:	c9                   	leave  
  8016ea:	c3                   	ret    

008016eb <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8016eb:	55                   	push   %ebp
  8016ec:	89 e5                	mov    %esp,%ebp
  8016ee:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  8016f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8016f4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  8016f7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016fa:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8016fd:	eb 2a                	jmp    801729 <memcmp+0x3e>
		if (*s1 != *s2)
  8016ff:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801702:	8a 10                	mov    (%eax),%dl
  801704:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801707:	8a 00                	mov    (%eax),%al
  801709:	38 c2                	cmp    %al,%dl
  80170b:	74 16                	je     801723 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  80170d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801710:	8a 00                	mov    (%eax),%al
  801712:	0f b6 d0             	movzbl %al,%edx
  801715:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801718:	8a 00                	mov    (%eax),%al
  80171a:	0f b6 c0             	movzbl %al,%eax
  80171d:	29 c2                	sub    %eax,%edx
  80171f:	89 d0                	mov    %edx,%eax
  801721:	eb 18                	jmp    80173b <memcmp+0x50>
		s1++, s2++;
  801723:	ff 45 fc             	incl   -0x4(%ebp)
  801726:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801729:	8b 45 10             	mov    0x10(%ebp),%eax
  80172c:	8d 50 ff             	lea    -0x1(%eax),%edx
  80172f:	89 55 10             	mov    %edx,0x10(%ebp)
  801732:	85 c0                	test   %eax,%eax
  801734:	75 c9                	jne    8016ff <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801736:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80173b:	c9                   	leave  
  80173c:	c3                   	ret    

0080173d <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  80173d:	55                   	push   %ebp
  80173e:	89 e5                	mov    %esp,%ebp
  801740:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801743:	8b 55 08             	mov    0x8(%ebp),%edx
  801746:	8b 45 10             	mov    0x10(%ebp),%eax
  801749:	01 d0                	add    %edx,%eax
  80174b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  80174e:	eb 15                	jmp    801765 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801750:	8b 45 08             	mov    0x8(%ebp),%eax
  801753:	8a 00                	mov    (%eax),%al
  801755:	0f b6 d0             	movzbl %al,%edx
  801758:	8b 45 0c             	mov    0xc(%ebp),%eax
  80175b:	0f b6 c0             	movzbl %al,%eax
  80175e:	39 c2                	cmp    %eax,%edx
  801760:	74 0d                	je     80176f <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801762:	ff 45 08             	incl   0x8(%ebp)
  801765:	8b 45 08             	mov    0x8(%ebp),%eax
  801768:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80176b:	72 e3                	jb     801750 <memfind+0x13>
  80176d:	eb 01                	jmp    801770 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  80176f:	90                   	nop
	return (void *) s;
  801770:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801773:	c9                   	leave  
  801774:	c3                   	ret    

00801775 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801775:	55                   	push   %ebp
  801776:	89 e5                	mov    %esp,%ebp
  801778:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  80177b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801782:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801789:	eb 03                	jmp    80178e <strtol+0x19>
		s++;
  80178b:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80178e:	8b 45 08             	mov    0x8(%ebp),%eax
  801791:	8a 00                	mov    (%eax),%al
  801793:	3c 20                	cmp    $0x20,%al
  801795:	74 f4                	je     80178b <strtol+0x16>
  801797:	8b 45 08             	mov    0x8(%ebp),%eax
  80179a:	8a 00                	mov    (%eax),%al
  80179c:	3c 09                	cmp    $0x9,%al
  80179e:	74 eb                	je     80178b <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  8017a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8017a3:	8a 00                	mov    (%eax),%al
  8017a5:	3c 2b                	cmp    $0x2b,%al
  8017a7:	75 05                	jne    8017ae <strtol+0x39>
		s++;
  8017a9:	ff 45 08             	incl   0x8(%ebp)
  8017ac:	eb 13                	jmp    8017c1 <strtol+0x4c>
	else if (*s == '-')
  8017ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8017b1:	8a 00                	mov    (%eax),%al
  8017b3:	3c 2d                	cmp    $0x2d,%al
  8017b5:	75 0a                	jne    8017c1 <strtol+0x4c>
		s++, neg = 1;
  8017b7:	ff 45 08             	incl   0x8(%ebp)
  8017ba:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8017c1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8017c5:	74 06                	je     8017cd <strtol+0x58>
  8017c7:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8017cb:	75 20                	jne    8017ed <strtol+0x78>
  8017cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8017d0:	8a 00                	mov    (%eax),%al
  8017d2:	3c 30                	cmp    $0x30,%al
  8017d4:	75 17                	jne    8017ed <strtol+0x78>
  8017d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8017d9:	40                   	inc    %eax
  8017da:	8a 00                	mov    (%eax),%al
  8017dc:	3c 78                	cmp    $0x78,%al
  8017de:	75 0d                	jne    8017ed <strtol+0x78>
		s += 2, base = 16;
  8017e0:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8017e4:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8017eb:	eb 28                	jmp    801815 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8017ed:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8017f1:	75 15                	jne    801808 <strtol+0x93>
  8017f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8017f6:	8a 00                	mov    (%eax),%al
  8017f8:	3c 30                	cmp    $0x30,%al
  8017fa:	75 0c                	jne    801808 <strtol+0x93>
		s++, base = 8;
  8017fc:	ff 45 08             	incl   0x8(%ebp)
  8017ff:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801806:	eb 0d                	jmp    801815 <strtol+0xa0>
	else if (base == 0)
  801808:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80180c:	75 07                	jne    801815 <strtol+0xa0>
		base = 10;
  80180e:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801815:	8b 45 08             	mov    0x8(%ebp),%eax
  801818:	8a 00                	mov    (%eax),%al
  80181a:	3c 2f                	cmp    $0x2f,%al
  80181c:	7e 19                	jle    801837 <strtol+0xc2>
  80181e:	8b 45 08             	mov    0x8(%ebp),%eax
  801821:	8a 00                	mov    (%eax),%al
  801823:	3c 39                	cmp    $0x39,%al
  801825:	7f 10                	jg     801837 <strtol+0xc2>
			dig = *s - '0';
  801827:	8b 45 08             	mov    0x8(%ebp),%eax
  80182a:	8a 00                	mov    (%eax),%al
  80182c:	0f be c0             	movsbl %al,%eax
  80182f:	83 e8 30             	sub    $0x30,%eax
  801832:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801835:	eb 42                	jmp    801879 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801837:	8b 45 08             	mov    0x8(%ebp),%eax
  80183a:	8a 00                	mov    (%eax),%al
  80183c:	3c 60                	cmp    $0x60,%al
  80183e:	7e 19                	jle    801859 <strtol+0xe4>
  801840:	8b 45 08             	mov    0x8(%ebp),%eax
  801843:	8a 00                	mov    (%eax),%al
  801845:	3c 7a                	cmp    $0x7a,%al
  801847:	7f 10                	jg     801859 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801849:	8b 45 08             	mov    0x8(%ebp),%eax
  80184c:	8a 00                	mov    (%eax),%al
  80184e:	0f be c0             	movsbl %al,%eax
  801851:	83 e8 57             	sub    $0x57,%eax
  801854:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801857:	eb 20                	jmp    801879 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801859:	8b 45 08             	mov    0x8(%ebp),%eax
  80185c:	8a 00                	mov    (%eax),%al
  80185e:	3c 40                	cmp    $0x40,%al
  801860:	7e 39                	jle    80189b <strtol+0x126>
  801862:	8b 45 08             	mov    0x8(%ebp),%eax
  801865:	8a 00                	mov    (%eax),%al
  801867:	3c 5a                	cmp    $0x5a,%al
  801869:	7f 30                	jg     80189b <strtol+0x126>
			dig = *s - 'A' + 10;
  80186b:	8b 45 08             	mov    0x8(%ebp),%eax
  80186e:	8a 00                	mov    (%eax),%al
  801870:	0f be c0             	movsbl %al,%eax
  801873:	83 e8 37             	sub    $0x37,%eax
  801876:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801879:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80187c:	3b 45 10             	cmp    0x10(%ebp),%eax
  80187f:	7d 19                	jge    80189a <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801881:	ff 45 08             	incl   0x8(%ebp)
  801884:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801887:	0f af 45 10          	imul   0x10(%ebp),%eax
  80188b:	89 c2                	mov    %eax,%edx
  80188d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801890:	01 d0                	add    %edx,%eax
  801892:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801895:	e9 7b ff ff ff       	jmp    801815 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  80189a:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  80189b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80189f:	74 08                	je     8018a9 <strtol+0x134>
		*endptr = (char *) s;
  8018a1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018a4:	8b 55 08             	mov    0x8(%ebp),%edx
  8018a7:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8018a9:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8018ad:	74 07                	je     8018b6 <strtol+0x141>
  8018af:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8018b2:	f7 d8                	neg    %eax
  8018b4:	eb 03                	jmp    8018b9 <strtol+0x144>
  8018b6:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8018b9:	c9                   	leave  
  8018ba:	c3                   	ret    

008018bb <ltostr>:

void
ltostr(long value, char *str)
{
  8018bb:	55                   	push   %ebp
  8018bc:	89 e5                	mov    %esp,%ebp
  8018be:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8018c1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8018c8:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8018cf:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8018d3:	79 13                	jns    8018e8 <ltostr+0x2d>
	{
		neg = 1;
  8018d5:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8018dc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018df:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8018e2:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8018e5:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8018e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8018eb:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8018f0:	99                   	cltd   
  8018f1:	f7 f9                	idiv   %ecx
  8018f3:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8018f6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8018f9:	8d 50 01             	lea    0x1(%eax),%edx
  8018fc:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8018ff:	89 c2                	mov    %eax,%edx
  801901:	8b 45 0c             	mov    0xc(%ebp),%eax
  801904:	01 d0                	add    %edx,%eax
  801906:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801909:	83 c2 30             	add    $0x30,%edx
  80190c:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  80190e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801911:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801916:	f7 e9                	imul   %ecx
  801918:	c1 fa 02             	sar    $0x2,%edx
  80191b:	89 c8                	mov    %ecx,%eax
  80191d:	c1 f8 1f             	sar    $0x1f,%eax
  801920:	29 c2                	sub    %eax,%edx
  801922:	89 d0                	mov    %edx,%eax
  801924:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  801927:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80192b:	75 bb                	jne    8018e8 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  80192d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801934:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801937:	48                   	dec    %eax
  801938:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  80193b:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80193f:	74 3d                	je     80197e <ltostr+0xc3>
		start = 1 ;
  801941:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801948:	eb 34                	jmp    80197e <ltostr+0xc3>
	{
		char tmp = str[start] ;
  80194a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80194d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801950:	01 d0                	add    %edx,%eax
  801952:	8a 00                	mov    (%eax),%al
  801954:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801957:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80195a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80195d:	01 c2                	add    %eax,%edx
  80195f:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801962:	8b 45 0c             	mov    0xc(%ebp),%eax
  801965:	01 c8                	add    %ecx,%eax
  801967:	8a 00                	mov    (%eax),%al
  801969:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  80196b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80196e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801971:	01 c2                	add    %eax,%edx
  801973:	8a 45 eb             	mov    -0x15(%ebp),%al
  801976:	88 02                	mov    %al,(%edx)
		start++ ;
  801978:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  80197b:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  80197e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801981:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801984:	7c c4                	jl     80194a <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801986:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801989:	8b 45 0c             	mov    0xc(%ebp),%eax
  80198c:	01 d0                	add    %edx,%eax
  80198e:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801991:	90                   	nop
  801992:	c9                   	leave  
  801993:	c3                   	ret    

00801994 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801994:	55                   	push   %ebp
  801995:	89 e5                	mov    %esp,%ebp
  801997:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  80199a:	ff 75 08             	pushl  0x8(%ebp)
  80199d:	e8 c4 f9 ff ff       	call   801366 <strlen>
  8019a2:	83 c4 04             	add    $0x4,%esp
  8019a5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8019a8:	ff 75 0c             	pushl  0xc(%ebp)
  8019ab:	e8 b6 f9 ff ff       	call   801366 <strlen>
  8019b0:	83 c4 04             	add    $0x4,%esp
  8019b3:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8019b6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8019bd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8019c4:	eb 17                	jmp    8019dd <strcconcat+0x49>
		final[s] = str1[s] ;
  8019c6:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8019c9:	8b 45 10             	mov    0x10(%ebp),%eax
  8019cc:	01 c2                	add    %eax,%edx
  8019ce:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8019d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8019d4:	01 c8                	add    %ecx,%eax
  8019d6:	8a 00                	mov    (%eax),%al
  8019d8:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8019da:	ff 45 fc             	incl   -0x4(%ebp)
  8019dd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8019e0:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8019e3:	7c e1                	jl     8019c6 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8019e5:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8019ec:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8019f3:	eb 1f                	jmp    801a14 <strcconcat+0x80>
		final[s++] = str2[i] ;
  8019f5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8019f8:	8d 50 01             	lea    0x1(%eax),%edx
  8019fb:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8019fe:	89 c2                	mov    %eax,%edx
  801a00:	8b 45 10             	mov    0x10(%ebp),%eax
  801a03:	01 c2                	add    %eax,%edx
  801a05:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801a08:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a0b:	01 c8                	add    %ecx,%eax
  801a0d:	8a 00                	mov    (%eax),%al
  801a0f:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801a11:	ff 45 f8             	incl   -0x8(%ebp)
  801a14:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801a17:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801a1a:	7c d9                	jl     8019f5 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801a1c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801a1f:	8b 45 10             	mov    0x10(%ebp),%eax
  801a22:	01 d0                	add    %edx,%eax
  801a24:	c6 00 00             	movb   $0x0,(%eax)
}
  801a27:	90                   	nop
  801a28:	c9                   	leave  
  801a29:	c3                   	ret    

00801a2a <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801a2a:	55                   	push   %ebp
  801a2b:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801a2d:	8b 45 14             	mov    0x14(%ebp),%eax
  801a30:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801a36:	8b 45 14             	mov    0x14(%ebp),%eax
  801a39:	8b 00                	mov    (%eax),%eax
  801a3b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801a42:	8b 45 10             	mov    0x10(%ebp),%eax
  801a45:	01 d0                	add    %edx,%eax
  801a47:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801a4d:	eb 0c                	jmp    801a5b <strsplit+0x31>
			*string++ = 0;
  801a4f:	8b 45 08             	mov    0x8(%ebp),%eax
  801a52:	8d 50 01             	lea    0x1(%eax),%edx
  801a55:	89 55 08             	mov    %edx,0x8(%ebp)
  801a58:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801a5b:	8b 45 08             	mov    0x8(%ebp),%eax
  801a5e:	8a 00                	mov    (%eax),%al
  801a60:	84 c0                	test   %al,%al
  801a62:	74 18                	je     801a7c <strsplit+0x52>
  801a64:	8b 45 08             	mov    0x8(%ebp),%eax
  801a67:	8a 00                	mov    (%eax),%al
  801a69:	0f be c0             	movsbl %al,%eax
  801a6c:	50                   	push   %eax
  801a6d:	ff 75 0c             	pushl  0xc(%ebp)
  801a70:	e8 83 fa ff ff       	call   8014f8 <strchr>
  801a75:	83 c4 08             	add    $0x8,%esp
  801a78:	85 c0                	test   %eax,%eax
  801a7a:	75 d3                	jne    801a4f <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801a7c:	8b 45 08             	mov    0x8(%ebp),%eax
  801a7f:	8a 00                	mov    (%eax),%al
  801a81:	84 c0                	test   %al,%al
  801a83:	74 5a                	je     801adf <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801a85:	8b 45 14             	mov    0x14(%ebp),%eax
  801a88:	8b 00                	mov    (%eax),%eax
  801a8a:	83 f8 0f             	cmp    $0xf,%eax
  801a8d:	75 07                	jne    801a96 <strsplit+0x6c>
		{
			return 0;
  801a8f:	b8 00 00 00 00       	mov    $0x0,%eax
  801a94:	eb 66                	jmp    801afc <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801a96:	8b 45 14             	mov    0x14(%ebp),%eax
  801a99:	8b 00                	mov    (%eax),%eax
  801a9b:	8d 48 01             	lea    0x1(%eax),%ecx
  801a9e:	8b 55 14             	mov    0x14(%ebp),%edx
  801aa1:	89 0a                	mov    %ecx,(%edx)
  801aa3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801aaa:	8b 45 10             	mov    0x10(%ebp),%eax
  801aad:	01 c2                	add    %eax,%edx
  801aaf:	8b 45 08             	mov    0x8(%ebp),%eax
  801ab2:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801ab4:	eb 03                	jmp    801ab9 <strsplit+0x8f>
			string++;
  801ab6:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801ab9:	8b 45 08             	mov    0x8(%ebp),%eax
  801abc:	8a 00                	mov    (%eax),%al
  801abe:	84 c0                	test   %al,%al
  801ac0:	74 8b                	je     801a4d <strsplit+0x23>
  801ac2:	8b 45 08             	mov    0x8(%ebp),%eax
  801ac5:	8a 00                	mov    (%eax),%al
  801ac7:	0f be c0             	movsbl %al,%eax
  801aca:	50                   	push   %eax
  801acb:	ff 75 0c             	pushl  0xc(%ebp)
  801ace:	e8 25 fa ff ff       	call   8014f8 <strchr>
  801ad3:	83 c4 08             	add    $0x8,%esp
  801ad6:	85 c0                	test   %eax,%eax
  801ad8:	74 dc                	je     801ab6 <strsplit+0x8c>
			string++;
	}
  801ada:	e9 6e ff ff ff       	jmp    801a4d <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801adf:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801ae0:	8b 45 14             	mov    0x14(%ebp),%eax
  801ae3:	8b 00                	mov    (%eax),%eax
  801ae5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801aec:	8b 45 10             	mov    0x10(%ebp),%eax
  801aef:	01 d0                	add    %edx,%eax
  801af1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801af7:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801afc:	c9                   	leave  
  801afd:	c3                   	ret    

00801afe <str2lower>:


char* str2lower(char *dst, const char *src)
{
  801afe:	55                   	push   %ebp
  801aff:	89 e5                	mov    %esp,%ebp
  801b01:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  801b04:	8b 45 08             	mov    0x8(%ebp),%eax
  801b07:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  801b0a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801b11:	eb 4a                	jmp    801b5d <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  801b13:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801b16:	8b 45 08             	mov    0x8(%ebp),%eax
  801b19:	01 c2                	add    %eax,%edx
  801b1b:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801b1e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b21:	01 c8                	add    %ecx,%eax
  801b23:	8a 00                	mov    (%eax),%al
  801b25:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  801b27:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801b2a:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b2d:	01 d0                	add    %edx,%eax
  801b2f:	8a 00                	mov    (%eax),%al
  801b31:	3c 40                	cmp    $0x40,%al
  801b33:	7e 25                	jle    801b5a <str2lower+0x5c>
  801b35:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801b38:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b3b:	01 d0                	add    %edx,%eax
  801b3d:	8a 00                	mov    (%eax),%al
  801b3f:	3c 5a                	cmp    $0x5a,%al
  801b41:	7f 17                	jg     801b5a <str2lower+0x5c>
		{
			dst[i] += 32 ;
  801b43:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801b46:	8b 45 08             	mov    0x8(%ebp),%eax
  801b49:	01 d0                	add    %edx,%eax
  801b4b:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801b4e:	8b 55 08             	mov    0x8(%ebp),%edx
  801b51:	01 ca                	add    %ecx,%edx
  801b53:	8a 12                	mov    (%edx),%dl
  801b55:	83 c2 20             	add    $0x20,%edx
  801b58:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  801b5a:	ff 45 fc             	incl   -0x4(%ebp)
  801b5d:	ff 75 0c             	pushl  0xc(%ebp)
  801b60:	e8 01 f8 ff ff       	call   801366 <strlen>
  801b65:	83 c4 04             	add    $0x4,%esp
  801b68:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801b6b:	7f a6                	jg     801b13 <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  801b6d:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801b70:	c9                   	leave  
  801b71:	c3                   	ret    

00801b72 <uheap_init>:
//==============================================
// [1] INITIALIZE USER HEAP:
//==============================================
int __firstTimeFlag = 1;
void uheap_init()
{
  801b72:	55                   	push   %ebp
  801b73:	89 e5                	mov    %esp,%ebp
  801b75:	83 ec 08             	sub    $0x8,%esp
	if(__firstTimeFlag)
  801b78:	a1 08 60 80 00       	mov    0x806008,%eax
  801b7d:	85 c0                	test   %eax,%eax
  801b7f:	0f 84 95 00 00 00    	je     801c1a <uheap_init+0xa8>
	{
		initialize_dynamic_allocator(USER_HEAP_START, USER_HEAP_START + DYN_ALLOC_MAX_SIZE);
  801b85:	83 ec 08             	sub    $0x8,%esp
  801b88:	68 00 00 00 82       	push   $0x82000000
  801b8d:	68 00 00 00 80       	push   $0x80000000
  801b92:	e8 59 1f 00 00       	call   803af0 <initialize_dynamic_allocator>
  801b97:	83 c4 10             	add    $0x10,%esp
		uheapPlaceStrategy = sys_get_uheap_strategy();
  801b9a:	e8 93 1d 00 00       	call   803932 <sys_get_uheap_strategy>
  801b9f:	a3 60 e0 81 00       	mov    %eax,0x81e060
		uheapPageAllocStart = dynAllocEnd + PAGE_SIZE;
  801ba4:	a1 40 60 80 00       	mov    0x806040,%eax
  801ba9:	05 00 10 00 00       	add    $0x1000,%eax
  801bae:	a3 10 e1 81 00       	mov    %eax,0x81e110
		uheapPageAllocBreak = uheapPageAllocStart;
  801bb3:	a1 10 e1 81 00       	mov    0x81e110,%eax
  801bb8:	a3 68 e0 81 00       	mov    %eax,0x81e068
		init_uspinlock(&ulock,"malloc",1);
  801bbd:	83 ec 04             	sub    $0x4,%esp
  801bc0:	6a 01                	push   $0x1
  801bc2:	68 9c 50 80 00       	push   $0x80509c
  801bc7:	68 40 e1 81 00       	push   $0x81e140
  801bcc:	e8 1a 29 00 00       	call   8044eb <init_uspinlock>
  801bd1:	83 c4 10             	add    $0x10,%esp
		LIST_INIT(&u_freelist);
  801bd4:	c7 05 20 e1 81 00 00 	movl   $0x0,0x81e120
  801bdb:	00 00 00 
  801bde:	c7 05 24 e1 81 00 00 	movl   $0x0,0x81e124
  801be5:	00 00 00 
  801be8:	c7 05 2c e1 81 00 00 	movl   $0x0,0x81e12c
  801bef:	00 00 00 
		LIST_INIT(&u_allocatedlist);
  801bf2:	c7 05 30 e1 81 00 00 	movl   $0x0,0x81e130
  801bf9:	00 00 00 
  801bfc:	c7 05 34 e1 81 00 00 	movl   $0x0,0x81e134
  801c03:	00 00 00 
  801c06:	c7 05 3c e1 81 00 00 	movl   $0x0,0x81e13c
  801c0d:	00 00 00 
		__firstTimeFlag = 0;
  801c10:	c7 05 08 60 80 00 00 	movl   $0x0,0x806008
  801c17:	00 00 00 
	}
}
  801c1a:	90                   	nop
  801c1b:	c9                   	leave  
  801c1c:	c3                   	ret    

00801c1d <get_page>:

//==============================================
// [2] GET A PAGE FROM THE KERNEL FOR DA:
//==============================================
int get_page(void* va)
{
  801c1d:	55                   	push   %ebp
  801c1e:	89 e5                	mov    %esp,%ebp
  801c20:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_allocate_page(ROUNDDOWN(va, PAGE_SIZE), PERM_USER|PERM_WRITEABLE|PERM_UHPAGE);
  801c23:	8b 45 08             	mov    0x8(%ebp),%eax
  801c26:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801c29:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c2c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801c31:	83 ec 08             	sub    $0x8,%esp
  801c34:	68 06 04 00 00       	push   $0x406
  801c39:	50                   	push   %eax
  801c3a:	e8 3d 19 00 00       	call   80357c <__sys_allocate_page>
  801c3f:	83 c4 10             	add    $0x10,%esp
  801c42:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  801c45:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801c49:	79 14                	jns    801c5f <get_page+0x42>
		panic("get_page() in user: failed to allocate page from the kernel");
  801c4b:	83 ec 04             	sub    $0x4,%esp
  801c4e:	68 a4 50 80 00       	push   $0x8050a4
  801c53:	6a 2d                	push   $0x2d
  801c55:	68 e0 50 80 00       	push   $0x8050e0
  801c5a:	e8 58 eb ff ff       	call   8007b7 <_panic>
	return 0;
  801c5f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c64:	c9                   	leave  
  801c65:	c3                   	ret    

00801c66 <return_page>:

//==============================================
// [3] RETURN A PAGE FROM THE DA TO KERNEL:
//==============================================
void return_page(void* va)
{
  801c66:	55                   	push   %ebp
  801c67:	89 e5                	mov    %esp,%ebp
  801c69:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_unmap_frame(ROUNDDOWN((uint32)va, PAGE_SIZE));
  801c6c:	8b 45 08             	mov    0x8(%ebp),%eax
  801c6f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801c72:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c75:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801c7a:	83 ec 0c             	sub    $0xc,%esp
  801c7d:	50                   	push   %eax
  801c7e:	e8 40 19 00 00       	call   8035c3 <__sys_unmap_frame>
  801c83:	83 c4 10             	add    $0x10,%esp
  801c86:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  801c89:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801c8d:	79 14                	jns    801ca3 <return_page+0x3d>
		panic("return_page() in user: failed to return a page to the kernel");
  801c8f:	83 ec 04             	sub    $0x4,%esp
  801c92:	68 ec 50 80 00       	push   $0x8050ec
  801c97:	6a 38                	push   $0x38
  801c99:	68 e0 50 80 00       	push   $0x8050e0
  801c9e:	e8 14 eb ff ff       	call   8007b7 <_panic>
}
  801ca3:	90                   	nop
  801ca4:	c9                   	leave  
  801ca5:	c3                   	ret    

00801ca6 <malloc>:

//=================================
// [1] ALLOCATE SPACE IN USER HEAP:
//=================================
void* malloc(uint32 size)
{
  801ca6:	55                   	push   %ebp
  801ca7:	89 e5                	mov    %esp,%ebp
  801ca9:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  801cac:	e8 c1 fe ff ff       	call   801b72 <uheap_init>
	if (size == 0) return NULL ;
  801cb1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801cb5:	75 0a                	jne    801cc1 <malloc+0x1b>
  801cb7:	b8 00 00 00 00       	mov    $0x0,%eax
  801cbc:	e9 e1 04 00 00       	jmp    8021a2 <malloc+0x4fc>
	//==============================================================

	acquire_uspinlock(&ulock);
  801cc1:	83 ec 0c             	sub    $0xc,%esp
  801cc4:	68 40 e1 81 00       	push   $0x81e140
  801cc9:	e8 6c 28 00 00       	call   80453a <acquire_uspinlock>
  801cce:	83 c4 10             	add    $0x10,%esp
	if(size <  DYN_ALLOC_MAX_BLOCK_SIZE){
  801cd1:	81 7d 08 ff 07 00 00 	cmpl   $0x7ff,0x8(%ebp)
  801cd8:	77 23                	ja     801cfd <malloc+0x57>
		release_uspinlock(&ulock);
  801cda:	83 ec 0c             	sub    $0xc,%esp
  801cdd:	68 40 e1 81 00       	push   $0x81e140
  801ce2:	e8 ab 28 00 00       	call   804592 <release_uspinlock>
  801ce7:	83 c4 10             	add    $0x10,%esp
		return alloc_block(size);
  801cea:	83 ec 0c             	sub    $0xc,%esp
  801ced:	ff 75 08             	pushl  0x8(%ebp)
  801cf0:	e8 dd 1f 00 00       	call   803cd2 <alloc_block>
  801cf5:	83 c4 10             	add    $0x10,%esp
  801cf8:	e9 a5 04 00 00       	jmp    8021a2 <malloc+0x4fc>
	}

	struct UserHeapStruct* allocblock= (struct UserHeapStruct*) alloc_block(sizeof(struct UserHeapStruct));
  801cfd:	83 ec 0c             	sub    $0xc,%esp
  801d00:	6a 10                	push   $0x10
  801d02:	e8 cb 1f 00 00       	call   803cd2 <alloc_block>
  801d07:	83 c4 10             	add    $0x10,%esp
  801d0a:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (allocblock == NULL){
  801d0d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801d11:	75 0a                	jne    801d1d <malloc+0x77>
			return NULL;
  801d13:	b8 00 00 00 00       	mov    $0x0,%eax
  801d18:	e9 85 04 00 00       	jmp    8021a2 <malloc+0x4fc>
	}

	size = ROUNDUP(size,PAGE_SIZE);
  801d1d:	c7 45 e8 00 10 00 00 	movl   $0x1000,-0x18(%ebp)
  801d24:	8b 55 08             	mov    0x8(%ebp),%edx
  801d27:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801d2a:	01 d0                	add    %edx,%eax
  801d2c:	48                   	dec    %eax
  801d2d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801d30:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801d33:	ba 00 00 00 00       	mov    $0x0,%edx
  801d38:	f7 75 e8             	divl   -0x18(%ebp)
  801d3b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801d3e:	29 d0                	sub    %edx,%eax
  801d40:	89 45 08             	mov    %eax,0x8(%ebp)
	struct UserHeapStruct* lastfreeelement = LIST_LAST(&u_freelist);
  801d43:	a1 24 e1 81 00       	mov    0x81e124,%eax
  801d48:	89 45 e0             	mov    %eax,-0x20(%ebp)

	if(LIST_SIZE(&u_freelist)==0 || size>lastfreeelement->size){
  801d4b:	a1 2c e1 81 00       	mov    0x81e12c,%eax
  801d50:	85 c0                	test   %eax,%eax
  801d52:	74 0f                	je     801d63 <malloc+0xbd>
  801d54:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801d57:	8b 40 04             	mov    0x4(%eax),%eax
  801d5a:	3b 45 08             	cmp    0x8(%ebp),%eax
  801d5d:	0f 83 ea 00 00 00    	jae    801e4d <malloc+0x1a7>
			if(uheapPageAllocBreak < USER_HEAP_MAX - size){
  801d63:	b8 00 00 00 a0       	mov    $0xa0000000,%eax
  801d68:	2b 45 08             	sub    0x8(%ebp),%eax
  801d6b:	89 c2                	mov    %eax,%edx
  801d6d:	a1 68 e0 81 00       	mov    0x81e068,%eax
  801d72:	39 c2                	cmp    %eax,%edx
  801d74:	0f 86 b9 00 00 00    	jbe    801e33 <malloc+0x18d>
					uint32 requestedblockva = uheapPageAllocBreak;
  801d7a:	a1 68 e0 81 00       	mov    0x81e068,%eax
  801d7f:	89 45 dc             	mov    %eax,-0x24(%ebp)
					uheapPageAllocBreak+=size;
  801d82:	8b 15 68 e0 81 00    	mov    0x81e068,%edx
  801d88:	8b 45 08             	mov    0x8(%ebp),%eax
  801d8b:	01 d0                	add    %edx,%eax
  801d8d:	a3 68 e0 81 00       	mov    %eax,0x81e068
					allocblock->startva = requestedblockva;
  801d92:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801d95:	8b 55 dc             	mov    -0x24(%ebp),%edx
  801d98:	89 10                	mov    %edx,(%eax)
					allocblock->size = size;
  801d9a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801d9d:	8b 55 08             	mov    0x8(%ebp),%edx
  801da0:	89 50 04             	mov    %edx,0x4(%eax)

					LIST_INSERT_TAIL(&u_allocatedlist, allocblock);
  801da3:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801da7:	75 14                	jne    801dbd <malloc+0x117>
  801da9:	83 ec 04             	sub    $0x4,%esp
  801dac:	68 2c 51 80 00       	push   $0x80512c
  801db1:	6a 60                	push   $0x60
  801db3:	68 e0 50 80 00       	push   $0x8050e0
  801db8:	e8 fa e9 ff ff       	call   8007b7 <_panic>
  801dbd:	8b 15 34 e1 81 00    	mov    0x81e134,%edx
  801dc3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801dc6:	89 50 0c             	mov    %edx,0xc(%eax)
  801dc9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801dcc:	8b 40 0c             	mov    0xc(%eax),%eax
  801dcf:	85 c0                	test   %eax,%eax
  801dd1:	74 0d                	je     801de0 <malloc+0x13a>
  801dd3:	a1 34 e1 81 00       	mov    0x81e134,%eax
  801dd8:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801ddb:	89 50 08             	mov    %edx,0x8(%eax)
  801dde:	eb 08                	jmp    801de8 <malloc+0x142>
  801de0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801de3:	a3 30 e1 81 00       	mov    %eax,0x81e130
  801de8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801deb:	a3 34 e1 81 00       	mov    %eax,0x81e134
  801df0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801df3:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  801dfa:	a1 3c e1 81 00       	mov    0x81e13c,%eax
  801dff:	40                   	inc    %eax
  801e00:	a3 3c e1 81 00       	mov    %eax,0x81e13c


					sys_allocate_user_mem(allocblock->startva ,size);
  801e05:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801e08:	8b 00                	mov    (%eax),%eax
  801e0a:	83 ec 08             	sub    $0x8,%esp
  801e0d:	ff 75 08             	pushl  0x8(%ebp)
  801e10:	50                   	push   %eax
  801e11:	e8 34 1c 00 00       	call   803a4a <sys_allocate_user_mem>
  801e16:	83 c4 10             	add    $0x10,%esp
					release_uspinlock(&ulock);
  801e19:	83 ec 0c             	sub    $0xc,%esp
  801e1c:	68 40 e1 81 00       	push   $0x81e140
  801e21:	e8 6c 27 00 00       	call   804592 <release_uspinlock>
  801e26:	83 c4 10             	add    $0x10,%esp
					return (void*)allocblock->startva;
  801e29:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801e2c:	8b 00                	mov    (%eax),%eax
  801e2e:	e9 6f 03 00 00       	jmp    8021a2 <malloc+0x4fc>
			}else{
					release_uspinlock(&ulock);
  801e33:	83 ec 0c             	sub    $0xc,%esp
  801e36:	68 40 e1 81 00       	push   $0x81e140
  801e3b:	e8 52 27 00 00       	call   804592 <release_uspinlock>
  801e40:	83 c4 10             	add    $0x10,%esp
					return NULL;
  801e43:	b8 00 00 00 00       	mov    $0x0,%eax
  801e48:	e9 55 03 00 00       	jmp    8021a2 <malloc+0x4fc>
				}
	}else{
		//custom fit
		struct UserHeapStruct* currentfreeelement = LIST_FIRST(&u_freelist);
  801e4d:	a1 20 e1 81 00       	mov    0x81e120,%eax
  801e52:	89 45 f4             	mov    %eax,-0xc(%ebp)
		//worst fit
		while(currentfreeelement != NULL){
  801e55:	e9 39 03 00 00       	jmp    802193 <malloc+0x4ed>
			if(size<currentfreeelement->size){
  801e5a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e5d:	8b 40 04             	mov    0x4(%eax),%eax
  801e60:	3b 45 08             	cmp    0x8(%ebp),%eax
  801e63:	0f 86 e7 01 00 00    	jbe    802050 <malloc+0x3aa>
				allocblock->startva = lastfreeelement->startva;
  801e69:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801e6c:	8b 10                	mov    (%eax),%edx
  801e6e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801e71:	89 10                	mov    %edx,(%eax)
                allocblock->size = size;
  801e73:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801e76:	8b 55 08             	mov    0x8(%ebp),%edx
  801e79:	89 50 04             	mov    %edx,0x4(%eax)
                LIST_INSERT_TAIL(&u_allocatedlist,allocblock);
  801e7c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801e80:	75 14                	jne    801e96 <malloc+0x1f0>
  801e82:	83 ec 04             	sub    $0x4,%esp
  801e85:	68 2c 51 80 00       	push   $0x80512c
  801e8a:	6a 72                	push   $0x72
  801e8c:	68 e0 50 80 00       	push   $0x8050e0
  801e91:	e8 21 e9 ff ff       	call   8007b7 <_panic>
  801e96:	8b 15 34 e1 81 00    	mov    0x81e134,%edx
  801e9c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801e9f:	89 50 0c             	mov    %edx,0xc(%eax)
  801ea2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801ea5:	8b 40 0c             	mov    0xc(%eax),%eax
  801ea8:	85 c0                	test   %eax,%eax
  801eaa:	74 0d                	je     801eb9 <malloc+0x213>
  801eac:	a1 34 e1 81 00       	mov    0x81e134,%eax
  801eb1:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801eb4:	89 50 08             	mov    %edx,0x8(%eax)
  801eb7:	eb 08                	jmp    801ec1 <malloc+0x21b>
  801eb9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801ebc:	a3 30 e1 81 00       	mov    %eax,0x81e130
  801ec1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801ec4:	a3 34 e1 81 00       	mov    %eax,0x81e134
  801ec9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801ecc:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  801ed3:	a1 3c e1 81 00       	mov    0x81e13c,%eax
  801ed8:	40                   	inc    %eax
  801ed9:	a3 3c e1 81 00       	mov    %eax,0x81e13c
                lastfreeelement->startva += size;
  801ede:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801ee1:	8b 10                	mov    (%eax),%edx
  801ee3:	8b 45 08             	mov    0x8(%ebp),%eax
  801ee6:	01 c2                	add    %eax,%edx
  801ee8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801eeb:	89 10                	mov    %edx,(%eax)
                lastfreeelement->size -= size;
  801eed:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801ef0:	8b 40 04             	mov    0x4(%eax),%eax
  801ef3:	2b 45 08             	sub    0x8(%ebp),%eax
  801ef6:	89 c2                	mov    %eax,%edx
  801ef8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801efb:	89 50 04             	mov    %edx,0x4(%eax)
                struct UserHeapStruct* currentfree2 = LIST_FIRST(&u_freelist);
  801efe:	a1 20 e1 81 00       	mov    0x81e120,%eax
  801f03:	89 45 f0             	mov    %eax,-0x10(%ebp)
                //check order of last element

                while (currentfree2 != NULL){
  801f06:	e9 0d 01 00 00       	jmp    802018 <malloc+0x372>
                	if(lastfreeelement->size <currentfree2->size){
  801f0b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801f0e:	8b 50 04             	mov    0x4(%eax),%edx
  801f11:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f14:	8b 40 04             	mov    0x4(%eax),%eax
  801f17:	39 c2                	cmp    %eax,%edx
  801f19:	0f 83 f0 00 00 00    	jae    80200f <malloc+0x369>
                		LIST_REMOVE(&u_freelist ,lastfreeelement);
  801f1f:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801f23:	75 14                	jne    801f39 <malloc+0x293>
  801f25:	83 ec 04             	sub    $0x4,%esp
  801f28:	68 4f 51 80 00       	push   $0x80514f
  801f2d:	6a 7a                	push   $0x7a
  801f2f:	68 e0 50 80 00       	push   $0x8050e0
  801f34:	e8 7e e8 ff ff       	call   8007b7 <_panic>
  801f39:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801f3c:	8b 40 08             	mov    0x8(%eax),%eax
  801f3f:	85 c0                	test   %eax,%eax
  801f41:	74 11                	je     801f54 <malloc+0x2ae>
  801f43:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801f46:	8b 40 08             	mov    0x8(%eax),%eax
  801f49:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801f4c:	8b 52 0c             	mov    0xc(%edx),%edx
  801f4f:	89 50 0c             	mov    %edx,0xc(%eax)
  801f52:	eb 0b                	jmp    801f5f <malloc+0x2b9>
  801f54:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801f57:	8b 40 0c             	mov    0xc(%eax),%eax
  801f5a:	a3 24 e1 81 00       	mov    %eax,0x81e124
  801f5f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801f62:	8b 40 0c             	mov    0xc(%eax),%eax
  801f65:	85 c0                	test   %eax,%eax
  801f67:	74 11                	je     801f7a <malloc+0x2d4>
  801f69:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801f6c:	8b 40 0c             	mov    0xc(%eax),%eax
  801f6f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801f72:	8b 52 08             	mov    0x8(%edx),%edx
  801f75:	89 50 08             	mov    %edx,0x8(%eax)
  801f78:	eb 0b                	jmp    801f85 <malloc+0x2df>
  801f7a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801f7d:	8b 40 08             	mov    0x8(%eax),%eax
  801f80:	a3 20 e1 81 00       	mov    %eax,0x81e120
  801f85:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801f88:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  801f8f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801f92:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  801f99:	a1 2c e1 81 00       	mov    0x81e12c,%eax
  801f9e:	48                   	dec    %eax
  801f9f:	a3 2c e1 81 00       	mov    %eax,0x81e12c
                		LIST_INSERT_BEFORE(&u_freelist ,currentfree2 ,lastfreeelement);
  801fa4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801fa8:	74 06                	je     801fb0 <malloc+0x30a>
  801faa:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801fae:	75 14                	jne    801fc4 <malloc+0x31e>
  801fb0:	83 ec 04             	sub    $0x4,%esp
  801fb3:	68 70 51 80 00       	push   $0x805170
  801fb8:	6a 7b                	push   $0x7b
  801fba:	68 e0 50 80 00       	push   $0x8050e0
  801fbf:	e8 f3 e7 ff ff       	call   8007b7 <_panic>
  801fc4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fc7:	8b 50 0c             	mov    0xc(%eax),%edx
  801fca:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801fcd:	89 50 0c             	mov    %edx,0xc(%eax)
  801fd0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801fd3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801fd6:	89 50 08             	mov    %edx,0x8(%eax)
  801fd9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fdc:	8b 40 0c             	mov    0xc(%eax),%eax
  801fdf:	85 c0                	test   %eax,%eax
  801fe1:	74 0e                	je     801ff1 <malloc+0x34b>
  801fe3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fe6:	8b 40 0c             	mov    0xc(%eax),%eax
  801fe9:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801fec:	89 50 08             	mov    %edx,0x8(%eax)
  801fef:	eb 08                	jmp    801ff9 <malloc+0x353>
  801ff1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801ff4:	a3 20 e1 81 00       	mov    %eax,0x81e120
  801ff9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ffc:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801fff:	89 50 0c             	mov    %edx,0xc(%eax)
  802002:	a1 2c e1 81 00       	mov    0x81e12c,%eax
  802007:	40                   	inc    %eax
  802008:	a3 2c e1 81 00       	mov    %eax,0x81e12c
                		break;
  80200d:	eb 13                	jmp    802022 <malloc+0x37c>
                	}
                	currentfree2 = currentfree2->prev_next_info.le_next;
  80200f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802012:	8b 40 08             	mov    0x8(%eax),%eax
  802015:	89 45 f0             	mov    %eax,-0x10(%ebp)
                lastfreeelement->startva += size;
                lastfreeelement->size -= size;
                struct UserHeapStruct* currentfree2 = LIST_FIRST(&u_freelist);
                //check order of last element

                while (currentfree2 != NULL){
  802018:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80201c:	0f 85 e9 fe ff ff    	jne    801f0b <malloc+0x265>
                	}
                	currentfree2 = currentfree2->prev_next_info.le_next;
                }


                sys_allocate_user_mem(allocblock->startva ,size);
  802022:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802025:	8b 00                	mov    (%eax),%eax
  802027:	83 ec 08             	sub    $0x8,%esp
  80202a:	ff 75 08             	pushl  0x8(%ebp)
  80202d:	50                   	push   %eax
  80202e:	e8 17 1a 00 00       	call   803a4a <sys_allocate_user_mem>
  802033:	83 c4 10             	add    $0x10,%esp
                release_uspinlock(&ulock);
  802036:	83 ec 0c             	sub    $0xc,%esp
  802039:	68 40 e1 81 00       	push   $0x81e140
  80203e:	e8 4f 25 00 00       	call   804592 <release_uspinlock>
  802043:	83 c4 10             	add    $0x10,%esp
                return (void*)allocblock->startva;
  802046:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802049:	8b 00                	mov    (%eax),%eax
  80204b:	e9 52 01 00 00       	jmp    8021a2 <malloc+0x4fc>
                //exact fit
			}else if(size == currentfreeelement->size){
  802050:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802053:	8b 40 04             	mov    0x4(%eax),%eax
  802056:	3b 45 08             	cmp    0x8(%ebp),%eax
  802059:	0f 85 2b 01 00 00    	jne    80218a <malloc+0x4e4>
				allocblock->startva = currentfreeelement->startva;
  80205f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802062:	8b 10                	mov    (%eax),%edx
  802064:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802067:	89 10                	mov    %edx,(%eax)
				allocblock->size = size;
  802069:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80206c:	8b 55 08             	mov    0x8(%ebp),%edx
  80206f:	89 50 04             	mov    %edx,0x4(%eax)
				LIST_INSERT_TAIL(&u_allocatedlist ,allocblock);
  802072:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802076:	75 17                	jne    80208f <malloc+0x3e9>
  802078:	83 ec 04             	sub    $0x4,%esp
  80207b:	68 2c 51 80 00       	push   $0x80512c
  802080:	68 89 00 00 00       	push   $0x89
  802085:	68 e0 50 80 00       	push   $0x8050e0
  80208a:	e8 28 e7 ff ff       	call   8007b7 <_panic>
  80208f:	8b 15 34 e1 81 00    	mov    0x81e134,%edx
  802095:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802098:	89 50 0c             	mov    %edx,0xc(%eax)
  80209b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80209e:	8b 40 0c             	mov    0xc(%eax),%eax
  8020a1:	85 c0                	test   %eax,%eax
  8020a3:	74 0d                	je     8020b2 <malloc+0x40c>
  8020a5:	a1 34 e1 81 00       	mov    0x81e134,%eax
  8020aa:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8020ad:	89 50 08             	mov    %edx,0x8(%eax)
  8020b0:	eb 08                	jmp    8020ba <malloc+0x414>
  8020b2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8020b5:	a3 30 e1 81 00       	mov    %eax,0x81e130
  8020ba:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8020bd:	a3 34 e1 81 00       	mov    %eax,0x81e134
  8020c2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8020c5:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  8020cc:	a1 3c e1 81 00       	mov    0x81e13c,%eax
  8020d1:	40                   	inc    %eax
  8020d2:	a3 3c e1 81 00       	mov    %eax,0x81e13c
				LIST_REMOVE(&u_freelist ,currentfreeelement);
  8020d7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8020db:	75 17                	jne    8020f4 <malloc+0x44e>
  8020dd:	83 ec 04             	sub    $0x4,%esp
  8020e0:	68 4f 51 80 00       	push   $0x80514f
  8020e5:	68 8a 00 00 00       	push   $0x8a
  8020ea:	68 e0 50 80 00       	push   $0x8050e0
  8020ef:	e8 c3 e6 ff ff       	call   8007b7 <_panic>
  8020f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020f7:	8b 40 08             	mov    0x8(%eax),%eax
  8020fa:	85 c0                	test   %eax,%eax
  8020fc:	74 11                	je     80210f <malloc+0x469>
  8020fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802101:	8b 40 08             	mov    0x8(%eax),%eax
  802104:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802107:	8b 52 0c             	mov    0xc(%edx),%edx
  80210a:	89 50 0c             	mov    %edx,0xc(%eax)
  80210d:	eb 0b                	jmp    80211a <malloc+0x474>
  80210f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802112:	8b 40 0c             	mov    0xc(%eax),%eax
  802115:	a3 24 e1 81 00       	mov    %eax,0x81e124
  80211a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80211d:	8b 40 0c             	mov    0xc(%eax),%eax
  802120:	85 c0                	test   %eax,%eax
  802122:	74 11                	je     802135 <malloc+0x48f>
  802124:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802127:	8b 40 0c             	mov    0xc(%eax),%eax
  80212a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80212d:	8b 52 08             	mov    0x8(%edx),%edx
  802130:	89 50 08             	mov    %edx,0x8(%eax)
  802133:	eb 0b                	jmp    802140 <malloc+0x49a>
  802135:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802138:	8b 40 08             	mov    0x8(%eax),%eax
  80213b:	a3 20 e1 81 00       	mov    %eax,0x81e120
  802140:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802143:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  80214a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80214d:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  802154:	a1 2c e1 81 00       	mov    0x81e12c,%eax
  802159:	48                   	dec    %eax
  80215a:	a3 2c e1 81 00       	mov    %eax,0x81e12c
				sys_allocate_user_mem(allocblock->startva ,size);
  80215f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802162:	8b 00                	mov    (%eax),%eax
  802164:	83 ec 08             	sub    $0x8,%esp
  802167:	ff 75 08             	pushl  0x8(%ebp)
  80216a:	50                   	push   %eax
  80216b:	e8 da 18 00 00       	call   803a4a <sys_allocate_user_mem>
  802170:	83 c4 10             	add    $0x10,%esp
				release_uspinlock(&ulock);
  802173:	83 ec 0c             	sub    $0xc,%esp
  802176:	68 40 e1 81 00       	push   $0x81e140
  80217b:	e8 12 24 00 00       	call   804592 <release_uspinlock>
  802180:	83 c4 10             	add    $0x10,%esp
				return (void*)allocblock->startva;
  802183:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802186:	8b 00                	mov    (%eax),%eax
  802188:	eb 18                	jmp    8021a2 <malloc+0x4fc>
			}
			currentfreeelement = currentfreeelement->prev_next_info.le_next;
  80218a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80218d:	8b 40 08             	mov    0x8(%eax),%eax
  802190:	89 45 f4             	mov    %eax,-0xc(%ebp)
				}
	}else{
		//custom fit
		struct UserHeapStruct* currentfreeelement = LIST_FIRST(&u_freelist);
		//worst fit
		while(currentfreeelement != NULL){
  802193:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802197:	0f 85 bd fc ff ff    	jne    801e5a <malloc+0x1b4>
				return (void*)allocblock->startva;
			}
			currentfreeelement = currentfreeelement->prev_next_info.le_next;
		}
	}
	 return NULL;
  80219d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8021a2:	c9                   	leave  
  8021a3:	c3                   	ret    

008021a4 <free>:

//=================================
// [2] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
  8021a4:	55                   	push   %ebp
  8021a5:	89 e5                	mov    %esp,%ebp
  8021a7:	83 ec 38             	sub    $0x38,%esp
	uint32  VA = ROUNDDOWN(((uint32 ) virtual_address), PAGE_SIZE);
  8021aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8021ad:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8021b0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8021b3:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8021b8:	89 45 d8             	mov    %eax,-0x28(%ebp)


		uheap_init();
  8021bb:	e8 b2 f9 ff ff       	call   801b72 <uheap_init>
		acquire_uspinlock(&ulock);
  8021c0:	83 ec 0c             	sub    $0xc,%esp
  8021c3:	68 40 e1 81 00       	push   $0x81e140
  8021c8:	e8 6d 23 00 00       	call   80453a <acquire_uspinlock>
  8021cd:	83 c4 10             	add    $0x10,%esp
		if (VA < uheapPageAllocStart){
  8021d0:	a1 10 e1 81 00       	mov    0x81e110,%eax
  8021d5:	39 45 d8             	cmp    %eax,-0x28(%ebp)
  8021d8:	73 23                	jae    8021fd <free+0x59>
			free_block(virtual_address);
  8021da:	83 ec 0c             	sub    $0xc,%esp
  8021dd:	ff 75 08             	pushl  0x8(%ebp)
  8021e0:	e8 89 1f 00 00       	call   80416e <free_block>
  8021e5:	83 c4 10             	add    $0x10,%esp
			release_uspinlock(&ulock);
  8021e8:	83 ec 0c             	sub    $0xc,%esp
  8021eb:	68 40 e1 81 00       	push   $0x81e140
  8021f0:	e8 9d 23 00 00       	call   804592 <release_uspinlock>
  8021f5:	83 c4 10             	add    $0x10,%esp
			return;
  8021f8:	e9 35 07 00 00       	jmp    802932 <free+0x78e>
		}
		if (VA >= uheapPageAllocBreak){
  8021fd:	a1 68 e0 81 00       	mov    0x81e068,%eax
  802202:	39 45 d8             	cmp    %eax,-0x28(%ebp)
  802205:	72 30                	jb     802237 <free+0x93>
			cprintf("%d\n %d\n", VA, uheapPageAllocBreak);
  802207:	a1 68 e0 81 00       	mov    0x81e068,%eax
  80220c:	83 ec 04             	sub    $0x4,%esp
  80220f:	50                   	push   %eax
  802210:	ff 75 d8             	pushl  -0x28(%ebp)
  802213:	68 a5 51 80 00       	push   $0x8051a5
  802218:	e8 68 e8 ff ff       	call   800a85 <cprintf>
  80221d:	83 c4 10             	add    $0x10,%esp

			panic("freeing from restricted area");
  802220:	83 ec 04             	sub    $0x4,%esp
  802223:	68 ad 51 80 00       	push   $0x8051ad
  802228:	68 a7 00 00 00       	push   $0xa7
  80222d:	68 e0 50 80 00       	push   $0x8050e0
  802232:	e8 80 e5 ff ff       	call   8007b7 <_panic>
			release_uspinlock(&ulock);
			return;
		}

		struct UserHeapStruct* newfree = (struct UserHeapStruct*) alloc_block(sizeof(struct UserHeapStruct));
  802237:	83 ec 0c             	sub    $0xc,%esp
  80223a:	6a 10                	push   $0x10
  80223c:	e8 91 1a 00 00       	call   803cd2 <alloc_block>
  802241:	83 c4 10             	add    $0x10,%esp
  802244:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		struct UserHeapStruct* MergedBlock  = ( struct UserHeapStruct*)alloc_block(sizeof(struct UserHeapStruct));
  802247:	83 ec 0c             	sub    $0xc,%esp
  80224a:	6a 10                	push   $0x10
  80224c:	e8 81 1a 00 00       	call   803cd2 <alloc_block>
  802251:	83 c4 10             	add    $0x10,%esp
  802254:	89 45 d0             	mov    %eax,-0x30(%ebp)

		struct UserHeapStruct* ToBefreed = LIST_FIRST(&u_allocatedlist);
  802257:	a1 30 e1 81 00       	mov    0x81e130,%eax
  80225c:	89 45 f4             	mov    %eax,-0xc(%ebp)
		bool foundVA = 0;
  80225f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

		//find the allocated block
		while(ToBefreed !=NULL ){
  802266:	eb 1c                	jmp    802284 <free+0xe0>

			if (VA ==ToBefreed->startva ){
  802268:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80226b:	8b 00                	mov    (%eax),%eax
  80226d:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  802270:	75 09                	jne    80227b <free+0xd7>
				foundVA = 1;
  802272:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
				break;
  802279:	eb 0f                	jmp    80228a <free+0xe6>
			}
				ToBefreed = ToBefreed->prev_next_info.le_next;
  80227b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80227e:	8b 40 08             	mov    0x8(%eax),%eax
  802281:	89 45 f4             	mov    %eax,-0xc(%ebp)

		struct UserHeapStruct* ToBefreed = LIST_FIRST(&u_allocatedlist);
		bool foundVA = 0;

		//find the allocated block
		while(ToBefreed !=NULL ){
  802284:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802288:	75 de                	jne    802268 <free+0xc4>
			}
				ToBefreed = ToBefreed->prev_next_info.le_next;
		}


		if(!foundVA){
  80228a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80228e:	75 17                	jne    8022a7 <free+0x103>
				panic("INVALID ADDRESS!");
  802290:	83 ec 04             	sub    $0x4,%esp
  802293:	68 ca 51 80 00       	push   $0x8051ca
  802298:	68 be 00 00 00       	push   $0xbe
  80229d:	68 e0 50 80 00       	push   $0x8050e0
  8022a2:	e8 10 e5 ff ff       	call   8007b7 <_panic>
				release_uspinlock(&ulock);
				return;
			}


		newfree->startva = ToBefreed->startva;
  8022a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022aa:	8b 10                	mov    (%eax),%edx
  8022ac:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8022af:	89 10                	mov    %edx,(%eax)
		newfree->size = ToBefreed->size;
  8022b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022b4:	8b 50 04             	mov    0x4(%eax),%edx
  8022b7:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8022ba:	89 50 04             	mov    %edx,0x4(%eax)

		//remove allocated block from alloclist
		LIST_REMOVE(&u_allocatedlist, ToBefreed);
  8022bd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8022c1:	75 17                	jne    8022da <free+0x136>
  8022c3:	83 ec 04             	sub    $0x4,%esp
  8022c6:	68 4f 51 80 00       	push   $0x80514f
  8022cb:	68 c8 00 00 00       	push   $0xc8
  8022d0:	68 e0 50 80 00       	push   $0x8050e0
  8022d5:	e8 dd e4 ff ff       	call   8007b7 <_panic>
  8022da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022dd:	8b 40 08             	mov    0x8(%eax),%eax
  8022e0:	85 c0                	test   %eax,%eax
  8022e2:	74 11                	je     8022f5 <free+0x151>
  8022e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022e7:	8b 40 08             	mov    0x8(%eax),%eax
  8022ea:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022ed:	8b 52 0c             	mov    0xc(%edx),%edx
  8022f0:	89 50 0c             	mov    %edx,0xc(%eax)
  8022f3:	eb 0b                	jmp    802300 <free+0x15c>
  8022f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022f8:	8b 40 0c             	mov    0xc(%eax),%eax
  8022fb:	a3 34 e1 81 00       	mov    %eax,0x81e134
  802300:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802303:	8b 40 0c             	mov    0xc(%eax),%eax
  802306:	85 c0                	test   %eax,%eax
  802308:	74 11                	je     80231b <free+0x177>
  80230a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80230d:	8b 40 0c             	mov    0xc(%eax),%eax
  802310:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802313:	8b 52 08             	mov    0x8(%edx),%edx
  802316:	89 50 08             	mov    %edx,0x8(%eax)
  802319:	eb 0b                	jmp    802326 <free+0x182>
  80231b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80231e:	8b 40 08             	mov    0x8(%eax),%eax
  802321:	a3 30 e1 81 00       	mov    %eax,0x81e130
  802326:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802329:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802330:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802333:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  80233a:	a1 3c e1 81 00       	mov    0x81e13c,%eax
  80233f:	48                   	dec    %eax
  802340:	a3 3c e1 81 00       	mov    %eax,0x81e13c

		sys_free_user_mem(ToBefreed->startva, ToBefreed->size);
  802345:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802348:	8b 50 04             	mov    0x4(%eax),%edx
  80234b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80234e:	8b 00                	mov    (%eax),%eax
  802350:	83 ec 08             	sub    $0x8,%esp
  802353:	52                   	push   %edx
  802354:	50                   	push   %eax
  802355:	e8 d4 16 00 00       	call   803a2e <sys_free_user_mem>
  80235a:	83 c4 10             	add    $0x10,%esp




		if(LIST_SIZE(&u_freelist) == 0){
  80235d:	a1 2c e1 81 00       	mov    0x81e12c,%eax
  802362:	85 c0                	test   %eax,%eax
  802364:	75 7a                	jne    8023e0 <free+0x23c>
			LIST_INSERT_HEAD(&u_freelist,newfree);
  802366:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80236a:	75 17                	jne    802383 <free+0x1df>
  80236c:	83 ec 04             	sub    $0x4,%esp
  80236f:	68 dc 51 80 00       	push   $0x8051dc
  802374:	68 d0 00 00 00       	push   $0xd0
  802379:	68 e0 50 80 00       	push   $0x8050e0
  80237e:	e8 34 e4 ff ff       	call   8007b7 <_panic>
  802383:	8b 15 20 e1 81 00    	mov    0x81e120,%edx
  802389:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80238c:	89 50 08             	mov    %edx,0x8(%eax)
  80238f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802392:	8b 40 08             	mov    0x8(%eax),%eax
  802395:	85 c0                	test   %eax,%eax
  802397:	74 0d                	je     8023a6 <free+0x202>
  802399:	a1 20 e1 81 00       	mov    0x81e120,%eax
  80239e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8023a1:	89 50 0c             	mov    %edx,0xc(%eax)
  8023a4:	eb 08                	jmp    8023ae <free+0x20a>
  8023a6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8023a9:	a3 24 e1 81 00       	mov    %eax,0x81e124
  8023ae:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8023b1:	a3 20 e1 81 00       	mov    %eax,0x81e120
  8023b6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8023b9:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  8023c0:	a1 2c e1 81 00       	mov    0x81e12c,%eax
  8023c5:	40                   	inc    %eax
  8023c6:	a3 2c e1 81 00       	mov    %eax,0x81e12c
			release_uspinlock(&ulock);
  8023cb:	83 ec 0c             	sub    $0xc,%esp
  8023ce:	68 40 e1 81 00       	push   $0x81e140
  8023d3:	e8 ba 21 00 00       	call   804592 <release_uspinlock>
  8023d8:	83 c4 10             	add    $0x10,%esp
			return;
  8023db:	e9 52 05 00 00       	jmp    802932 <free+0x78e>
		}


		struct UserHeapStruct* ToBeMerged = LIST_FIRST(&u_freelist);
  8023e0:	a1 20 e1 81 00       	mov    0x81e120,%eax
  8023e5:	89 45 ec             	mov    %eax,-0x14(%ebp)
		// merge with prev if possible
		bool mergeprev = 0;
  8023e8:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		bool mergenext = 0;
  8023ef:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
		while(ToBeMerged != NULL){
  8023f6:	e9 d2 00 00 00       	jmp    8024cd <free+0x329>
			if((ToBeMerged->startva +ToBeMerged->size) == newfree->startva){
  8023fb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8023fe:	8b 10                	mov    (%eax),%edx
  802400:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802403:	8b 40 04             	mov    0x4(%eax),%eax
  802406:	01 c2                	add    %eax,%edx
  802408:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80240b:	8b 00                	mov    (%eax),%eax
  80240d:	39 c2                	cmp    %eax,%edx
  80240f:	0f 85 af 00 00 00    	jne    8024c4 <free+0x320>

				MergedBlock->startva = ToBeMerged->startva;
  802415:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802418:	8b 10                	mov    (%eax),%edx
  80241a:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80241d:	89 10                	mov    %edx,(%eax)
				MergedBlock->size = ToBeMerged->size + newfree->size;
  80241f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802422:	8b 50 04             	mov    0x4(%eax),%edx
  802425:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802428:	8b 40 04             	mov    0x4(%eax),%eax
  80242b:	01 c2                	add    %eax,%edx
  80242d:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802430:	89 50 04             	mov    %edx,0x4(%eax)
				LIST_REMOVE(&u_freelist, ToBeMerged);
  802433:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802437:	75 17                	jne    802450 <free+0x2ac>
  802439:	83 ec 04             	sub    $0x4,%esp
  80243c:	68 4f 51 80 00       	push   $0x80514f
  802441:	68 df 00 00 00       	push   $0xdf
  802446:	68 e0 50 80 00       	push   $0x8050e0
  80244b:	e8 67 e3 ff ff       	call   8007b7 <_panic>
  802450:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802453:	8b 40 08             	mov    0x8(%eax),%eax
  802456:	85 c0                	test   %eax,%eax
  802458:	74 11                	je     80246b <free+0x2c7>
  80245a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80245d:	8b 40 08             	mov    0x8(%eax),%eax
  802460:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802463:	8b 52 0c             	mov    0xc(%edx),%edx
  802466:	89 50 0c             	mov    %edx,0xc(%eax)
  802469:	eb 0b                	jmp    802476 <free+0x2d2>
  80246b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80246e:	8b 40 0c             	mov    0xc(%eax),%eax
  802471:	a3 24 e1 81 00       	mov    %eax,0x81e124
  802476:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802479:	8b 40 0c             	mov    0xc(%eax),%eax
  80247c:	85 c0                	test   %eax,%eax
  80247e:	74 11                	je     802491 <free+0x2ed>
  802480:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802483:	8b 40 0c             	mov    0xc(%eax),%eax
  802486:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802489:	8b 52 08             	mov    0x8(%edx),%edx
  80248c:	89 50 08             	mov    %edx,0x8(%eax)
  80248f:	eb 0b                	jmp    80249c <free+0x2f8>
  802491:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802494:	8b 40 08             	mov    0x8(%eax),%eax
  802497:	a3 20 e1 81 00       	mov    %eax,0x81e120
  80249c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80249f:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  8024a6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8024a9:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  8024b0:	a1 2c e1 81 00       	mov    0x81e12c,%eax
  8024b5:	48                   	dec    %eax
  8024b6:	a3 2c e1 81 00       	mov    %eax,0x81e12c
				mergeprev = 1;
  8024bb:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
				break;
  8024c2:	eb 13                	jmp    8024d7 <free+0x333>
			}
				ToBeMerged = ToBeMerged->prev_next_info.le_next;
  8024c4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8024c7:	8b 40 08             	mov    0x8(%eax),%eax
  8024ca:	89 45 ec             	mov    %eax,-0x14(%ebp)

		struct UserHeapStruct* ToBeMerged = LIST_FIRST(&u_freelist);
		// merge with prev if possible
		bool mergeprev = 0;
		bool mergenext = 0;
		while(ToBeMerged != NULL){
  8024cd:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8024d1:	0f 85 24 ff ff ff    	jne    8023fb <free+0x257>
//									uheapPageAllocBreak = newfree->startva;
//						}
//					}


		if ( newfree ->startva + newfree->size == uheapPageAllocBreak){
  8024d7:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8024da:	8b 10                	mov    (%eax),%edx
  8024dc:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8024df:	8b 40 04             	mov    0x4(%eax),%eax
  8024e2:	01 c2                	add    %eax,%edx
  8024e4:	a1 68 e0 81 00       	mov    0x81e068,%eax
  8024e9:	39 c2                	cmp    %eax,%edx
  8024eb:	75 44                	jne    802531 <free+0x38d>

			if(mergeprev){
  8024ed:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8024f1:	74 1f                	je     802512 <free+0x36e>
				uheapPageAllocBreak = MergedBlock->startva;
  8024f3:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8024f6:	8b 00                	mov    (%eax),%eax
  8024f8:	a3 68 e0 81 00       	mov    %eax,0x81e068
				release_uspinlock(&ulock);
  8024fd:	83 ec 0c             	sub    $0xc,%esp
  802500:	68 40 e1 81 00       	push   $0x81e140
  802505:	e8 88 20 00 00       	call   804592 <release_uspinlock>
  80250a:	83 c4 10             	add    $0x10,%esp
				return;
  80250d:	e9 20 04 00 00       	jmp    802932 <free+0x78e>

			}else{
				uheapPageAllocBreak = newfree->startva;
  802512:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802515:	8b 00                	mov    (%eax),%eax
  802517:	a3 68 e0 81 00       	mov    %eax,0x81e068
				release_uspinlock(&ulock);
  80251c:	83 ec 0c             	sub    $0xc,%esp
  80251f:	68 40 e1 81 00       	push   $0x81e140
  802524:	e8 69 20 00 00       	call   804592 <release_uspinlock>
  802529:	83 c4 10             	add    $0x10,%esp
				return;
  80252c:	e9 01 04 00 00       	jmp    802932 <free+0x78e>

		}


		//check if block is merged with prev ,and find possible merge with next
		ToBeMerged = LIST_FIRST(&u_freelist);
  802531:	a1 20 e1 81 00       	mov    0x81e120,%eax
  802536:	89 45 ec             	mov    %eax,-0x14(%ebp)
		while(ToBeMerged != NULL){
  802539:	e9 7d 01 00 00       	jmp    8026bb <free+0x517>
			if ((newfree->startva + newfree->size) == ToBeMerged->startva ){
  80253e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802541:	8b 10                	mov    (%eax),%edx
  802543:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802546:	8b 40 04             	mov    0x4(%eax),%eax
  802549:	01 c2                	add    %eax,%edx
  80254b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80254e:	8b 00                	mov    (%eax),%eax
  802550:	39 c2                	cmp    %eax,%edx
  802552:	0f 85 5a 01 00 00    	jne    8026b2 <free+0x50e>
				if (mergeprev){
  802558:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80255c:	0f 84 a1 00 00 00    	je     802603 <free+0x45f>
					MergedBlock->size += ToBeMerged->size;
  802562:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802565:	8b 50 04             	mov    0x4(%eax),%edx
  802568:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80256b:	8b 40 04             	mov    0x4(%eax),%eax
  80256e:	01 c2                	add    %eax,%edx
  802570:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802573:	89 50 04             	mov    %edx,0x4(%eax)
					LIST_REMOVE(&u_freelist, ToBeMerged);
  802576:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80257a:	75 17                	jne    802593 <free+0x3ef>
  80257c:	83 ec 04             	sub    $0x4,%esp
  80257f:	68 4f 51 80 00       	push   $0x80514f
  802584:	68 0a 01 00 00       	push   $0x10a
  802589:	68 e0 50 80 00       	push   $0x8050e0
  80258e:	e8 24 e2 ff ff       	call   8007b7 <_panic>
  802593:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802596:	8b 40 08             	mov    0x8(%eax),%eax
  802599:	85 c0                	test   %eax,%eax
  80259b:	74 11                	je     8025ae <free+0x40a>
  80259d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025a0:	8b 40 08             	mov    0x8(%eax),%eax
  8025a3:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8025a6:	8b 52 0c             	mov    0xc(%edx),%edx
  8025a9:	89 50 0c             	mov    %edx,0xc(%eax)
  8025ac:	eb 0b                	jmp    8025b9 <free+0x415>
  8025ae:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025b1:	8b 40 0c             	mov    0xc(%eax),%eax
  8025b4:	a3 24 e1 81 00       	mov    %eax,0x81e124
  8025b9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025bc:	8b 40 0c             	mov    0xc(%eax),%eax
  8025bf:	85 c0                	test   %eax,%eax
  8025c1:	74 11                	je     8025d4 <free+0x430>
  8025c3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025c6:	8b 40 0c             	mov    0xc(%eax),%eax
  8025c9:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8025cc:	8b 52 08             	mov    0x8(%edx),%edx
  8025cf:	89 50 08             	mov    %edx,0x8(%eax)
  8025d2:	eb 0b                	jmp    8025df <free+0x43b>
  8025d4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025d7:	8b 40 08             	mov    0x8(%eax),%eax
  8025da:	a3 20 e1 81 00       	mov    %eax,0x81e120
  8025df:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025e2:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  8025e9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025ec:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  8025f3:	a1 2c e1 81 00       	mov    0x81e12c,%eax
  8025f8:	48                   	dec    %eax
  8025f9:	a3 2c e1 81 00       	mov    %eax,0x81e12c
					break;
  8025fe:	e9 c2 00 00 00       	jmp    8026c5 <free+0x521>
		//if not merged find possible merge with next
				}else{
					MergedBlock->startva = newfree->startva;
  802603:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802606:	8b 10                	mov    (%eax),%edx
  802608:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80260b:	89 10                	mov    %edx,(%eax)
					MergedBlock->size  = newfree->size + ToBeMerged->size;
  80260d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802610:	8b 50 04             	mov    0x4(%eax),%edx
  802613:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802616:	8b 40 04             	mov    0x4(%eax),%eax
  802619:	01 c2                	add    %eax,%edx
  80261b:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80261e:	89 50 04             	mov    %edx,0x4(%eax)
					LIST_REMOVE(&u_freelist, ToBeMerged);
  802621:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802625:	75 17                	jne    80263e <free+0x49a>
  802627:	83 ec 04             	sub    $0x4,%esp
  80262a:	68 4f 51 80 00       	push   $0x80514f
  80262f:	68 10 01 00 00       	push   $0x110
  802634:	68 e0 50 80 00       	push   $0x8050e0
  802639:	e8 79 e1 ff ff       	call   8007b7 <_panic>
  80263e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802641:	8b 40 08             	mov    0x8(%eax),%eax
  802644:	85 c0                	test   %eax,%eax
  802646:	74 11                	je     802659 <free+0x4b5>
  802648:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80264b:	8b 40 08             	mov    0x8(%eax),%eax
  80264e:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802651:	8b 52 0c             	mov    0xc(%edx),%edx
  802654:	89 50 0c             	mov    %edx,0xc(%eax)
  802657:	eb 0b                	jmp    802664 <free+0x4c0>
  802659:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80265c:	8b 40 0c             	mov    0xc(%eax),%eax
  80265f:	a3 24 e1 81 00       	mov    %eax,0x81e124
  802664:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802667:	8b 40 0c             	mov    0xc(%eax),%eax
  80266a:	85 c0                	test   %eax,%eax
  80266c:	74 11                	je     80267f <free+0x4db>
  80266e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802671:	8b 40 0c             	mov    0xc(%eax),%eax
  802674:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802677:	8b 52 08             	mov    0x8(%edx),%edx
  80267a:	89 50 08             	mov    %edx,0x8(%eax)
  80267d:	eb 0b                	jmp    80268a <free+0x4e6>
  80267f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802682:	8b 40 08             	mov    0x8(%eax),%eax
  802685:	a3 20 e1 81 00       	mov    %eax,0x81e120
  80268a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80268d:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802694:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802697:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  80269e:	a1 2c e1 81 00       	mov    0x81e12c,%eax
  8026a3:	48                   	dec    %eax
  8026a4:	a3 2c e1 81 00       	mov    %eax,0x81e12c
					mergenext = 1;
  8026a9:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
					break;
  8026b0:	eb 13                	jmp    8026c5 <free+0x521>
				}
			}
			ToBeMerged = ToBeMerged->prev_next_info.le_next;
  8026b2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026b5:	8b 40 08             	mov    0x8(%eax),%eax
  8026b8:	89 45 ec             	mov    %eax,-0x14(%ebp)
		}


		//check if block is merged with prev ,and find possible merge with next
		ToBeMerged = LIST_FIRST(&u_freelist);
		while(ToBeMerged != NULL){
  8026bb:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8026bf:	0f 85 79 fe ff ff    	jne    80253e <free+0x39a>




			// insertion
			struct UserHeapStruct* currentfree = LIST_FIRST(&u_freelist);
  8026c5:	a1 20 e1 81 00       	mov    0x81e120,%eax
  8026ca:	89 45 e0             	mov    %eax,-0x20(%ebp)

			if(mergeprev || mergenext){
  8026cd:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8026d1:	0f 85 ad 00 00 00    	jne    802784 <free+0x5e0>
  8026d7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8026db:	0f 84 c3 01 00 00    	je     8028a4 <free+0x700>
				while(currentfree != NULL){
  8026e1:	e9 9e 00 00 00       	jmp    802784 <free+0x5e0>
					if(MergedBlock->size < currentfree->size){
  8026e6:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8026e9:	8b 50 04             	mov    0x4(%eax),%edx
  8026ec:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8026ef:	8b 40 04             	mov    0x4(%eax),%eax
  8026f2:	39 c2                	cmp    %eax,%edx
  8026f4:	0f 83 81 00 00 00    	jae    80277b <free+0x5d7>

							LIST_INSERT_BEFORE(&u_freelist,currentfree,MergedBlock);
  8026fa:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8026fe:	74 06                	je     802706 <free+0x562>
  802700:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  802704:	75 17                	jne    80271d <free+0x579>
  802706:	83 ec 04             	sub    $0x4,%esp
  802709:	68 70 51 80 00       	push   $0x805170
  80270e:	68 23 01 00 00       	push   $0x123
  802713:	68 e0 50 80 00       	push   $0x8050e0
  802718:	e8 9a e0 ff ff       	call   8007b7 <_panic>
  80271d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802720:	8b 50 0c             	mov    0xc(%eax),%edx
  802723:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802726:	89 50 0c             	mov    %edx,0xc(%eax)
  802729:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80272c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80272f:	89 50 08             	mov    %edx,0x8(%eax)
  802732:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802735:	8b 40 0c             	mov    0xc(%eax),%eax
  802738:	85 c0                	test   %eax,%eax
  80273a:	74 0e                	je     80274a <free+0x5a6>
  80273c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80273f:	8b 40 0c             	mov    0xc(%eax),%eax
  802742:	8b 55 d0             	mov    -0x30(%ebp),%edx
  802745:	89 50 08             	mov    %edx,0x8(%eax)
  802748:	eb 08                	jmp    802752 <free+0x5ae>
  80274a:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80274d:	a3 20 e1 81 00       	mov    %eax,0x81e120
  802752:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802755:	8b 55 d0             	mov    -0x30(%ebp),%edx
  802758:	89 50 0c             	mov    %edx,0xc(%eax)
  80275b:	a1 2c e1 81 00       	mov    0x81e12c,%eax
  802760:	40                   	inc    %eax
  802761:	a3 2c e1 81 00       	mov    %eax,0x81e12c
							release_uspinlock(&ulock);
  802766:	83 ec 0c             	sub    $0xc,%esp
  802769:	68 40 e1 81 00       	push   $0x81e140
  80276e:	e8 1f 1e 00 00       	call   804592 <release_uspinlock>
  802773:	83 c4 10             	add    $0x10,%esp
							return;
  802776:	e9 b7 01 00 00       	jmp    802932 <free+0x78e>
					}
							currentfree = currentfree->prev_next_info.le_next;
  80277b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80277e:	8b 40 08             	mov    0x8(%eax),%eax
  802781:	89 45 e0             	mov    %eax,-0x20(%ebp)

			// insertion
			struct UserHeapStruct* currentfree = LIST_FIRST(&u_freelist);

			if(mergeprev || mergenext){
				while(currentfree != NULL){
  802784:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802788:	0f 85 58 ff ff ff    	jne    8026e6 <free+0x542>
							release_uspinlock(&ulock);
							return;
					}
							currentfree = currentfree->prev_next_info.le_next;
				}
				free_block(newfree);
  80278e:	83 ec 0c             	sub    $0xc,%esp
  802791:	ff 75 d4             	pushl  -0x2c(%ebp)
  802794:	e8 d5 19 00 00       	call   80416e <free_block>
  802799:	83 c4 10             	add    $0x10,%esp
				LIST_INSERT_TAIL(&u_freelist,MergedBlock);
  80279c:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  8027a0:	75 17                	jne    8027b9 <free+0x615>
  8027a2:	83 ec 04             	sub    $0x4,%esp
  8027a5:	68 2c 51 80 00       	push   $0x80512c
  8027aa:	68 2a 01 00 00       	push   $0x12a
  8027af:	68 e0 50 80 00       	push   $0x8050e0
  8027b4:	e8 fe df ff ff       	call   8007b7 <_panic>
  8027b9:	8b 15 24 e1 81 00    	mov    0x81e124,%edx
  8027bf:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8027c2:	89 50 0c             	mov    %edx,0xc(%eax)
  8027c5:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8027c8:	8b 40 0c             	mov    0xc(%eax),%eax
  8027cb:	85 c0                	test   %eax,%eax
  8027cd:	74 0d                	je     8027dc <free+0x638>
  8027cf:	a1 24 e1 81 00       	mov    0x81e124,%eax
  8027d4:	8b 55 d0             	mov    -0x30(%ebp),%edx
  8027d7:	89 50 08             	mov    %edx,0x8(%eax)
  8027da:	eb 08                	jmp    8027e4 <free+0x640>
  8027dc:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8027df:	a3 20 e1 81 00       	mov    %eax,0x81e120
  8027e4:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8027e7:	a3 24 e1 81 00       	mov    %eax,0x81e124
  8027ec:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8027ef:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  8027f6:	a1 2c e1 81 00       	mov    0x81e12c,%eax
  8027fb:	40                   	inc    %eax
  8027fc:	a3 2c e1 81 00       	mov    %eax,0x81e12c
  802801:	e9 1b 01 00 00       	jmp    802921 <free+0x77d>

			}else{
				while(currentfree != NULL){
					if(newfree->size < currentfree->size){
  802806:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802809:	8b 50 04             	mov    0x4(%eax),%edx
  80280c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80280f:	8b 40 04             	mov    0x4(%eax),%eax
  802812:	39 c2                	cmp    %eax,%edx
  802814:	0f 83 81 00 00 00    	jae    80289b <free+0x6f7>

							LIST_INSERT_BEFORE(&u_freelist,currentfree,newfree);
  80281a:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80281e:	74 06                	je     802826 <free+0x682>
  802820:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  802824:	75 17                	jne    80283d <free+0x699>
  802826:	83 ec 04             	sub    $0x4,%esp
  802829:	68 70 51 80 00       	push   $0x805170
  80282e:	68 30 01 00 00       	push   $0x130
  802833:	68 e0 50 80 00       	push   $0x8050e0
  802838:	e8 7a df ff ff       	call   8007b7 <_panic>
  80283d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802840:	8b 50 0c             	mov    0xc(%eax),%edx
  802843:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802846:	89 50 0c             	mov    %edx,0xc(%eax)
  802849:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80284c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80284f:	89 50 08             	mov    %edx,0x8(%eax)
  802852:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802855:	8b 40 0c             	mov    0xc(%eax),%eax
  802858:	85 c0                	test   %eax,%eax
  80285a:	74 0e                	je     80286a <free+0x6c6>
  80285c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80285f:	8b 40 0c             	mov    0xc(%eax),%eax
  802862:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802865:	89 50 08             	mov    %edx,0x8(%eax)
  802868:	eb 08                	jmp    802872 <free+0x6ce>
  80286a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80286d:	a3 20 e1 81 00       	mov    %eax,0x81e120
  802872:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802875:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802878:	89 50 0c             	mov    %edx,0xc(%eax)
  80287b:	a1 2c e1 81 00       	mov    0x81e12c,%eax
  802880:	40                   	inc    %eax
  802881:	a3 2c e1 81 00       	mov    %eax,0x81e12c
							release_uspinlock(&ulock);
  802886:	83 ec 0c             	sub    $0xc,%esp
  802889:	68 40 e1 81 00       	push   $0x81e140
  80288e:	e8 ff 1c 00 00       	call   804592 <release_uspinlock>
  802893:	83 c4 10             	add    $0x10,%esp
							return;
  802896:	e9 97 00 00 00       	jmp    802932 <free+0x78e>
					}
							currentfree = currentfree->prev_next_info.le_next;
  80289b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80289e:	8b 40 08             	mov    0x8(%eax),%eax
  8028a1:	89 45 e0             	mov    %eax,-0x20(%ebp)
				}
				free_block(newfree);
				LIST_INSERT_TAIL(&u_freelist,MergedBlock);

			}else{
				while(currentfree != NULL){
  8028a4:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8028a8:	0f 85 58 ff ff ff    	jne    802806 <free+0x662>
							release_uspinlock(&ulock);
							return;
					}
							currentfree = currentfree->prev_next_info.le_next;
				}
				free_block(MergedBlock);
  8028ae:	83 ec 0c             	sub    $0xc,%esp
  8028b1:	ff 75 d0             	pushl  -0x30(%ebp)
  8028b4:	e8 b5 18 00 00       	call   80416e <free_block>
  8028b9:	83 c4 10             	add    $0x10,%esp
				LIST_INSERT_TAIL(&u_freelist,newfree);
  8028bc:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8028c0:	75 17                	jne    8028d9 <free+0x735>
  8028c2:	83 ec 04             	sub    $0x4,%esp
  8028c5:	68 2c 51 80 00       	push   $0x80512c
  8028ca:	68 37 01 00 00       	push   $0x137
  8028cf:	68 e0 50 80 00       	push   $0x8050e0
  8028d4:	e8 de de ff ff       	call   8007b7 <_panic>
  8028d9:	8b 15 24 e1 81 00    	mov    0x81e124,%edx
  8028df:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8028e2:	89 50 0c             	mov    %edx,0xc(%eax)
  8028e5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8028e8:	8b 40 0c             	mov    0xc(%eax),%eax
  8028eb:	85 c0                	test   %eax,%eax
  8028ed:	74 0d                	je     8028fc <free+0x758>
  8028ef:	a1 24 e1 81 00       	mov    0x81e124,%eax
  8028f4:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8028f7:	89 50 08             	mov    %edx,0x8(%eax)
  8028fa:	eb 08                	jmp    802904 <free+0x760>
  8028fc:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8028ff:	a3 20 e1 81 00       	mov    %eax,0x81e120
  802904:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802907:	a3 24 e1 81 00       	mov    %eax,0x81e124
  80290c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80290f:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802916:	a1 2c e1 81 00       	mov    0x81e12c,%eax
  80291b:	40                   	inc    %eax
  80291c:	a3 2c e1 81 00       	mov    %eax,0x81e12c
			}
		release_uspinlock(&ulock);
  802921:	83 ec 0c             	sub    $0xc,%esp
  802924:	68 40 e1 81 00       	push   $0x81e140
  802929:	e8 64 1c 00 00       	call   804592 <release_uspinlock>
  80292e:	83 c4 10             	add    $0x10,%esp
		return;
  802931:	90                   	nop
}
  802932:	c9                   	leave  
  802933:	c3                   	ret    

00802934 <smalloc>:

//=================================
// [3] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  802934:	55                   	push   %ebp
  802935:	89 e5                	mov    %esp,%ebp
  802937:	83 ec 48             	sub    $0x48,%esp
  80293a:	8b 45 10             	mov    0x10(%ebp),%eax
  80293d:	88 45 c4             	mov    %al,-0x3c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  802940:	e8 2d f2 ff ff       	call   801b72 <uheap_init>
	if (size == 0) return NULL;
  802945:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802949:	75 0a                	jne    802955 <smalloc+0x21>
  80294b:	b8 00 00 00 00       	mov    $0x0,%eax
  802950:	e9 84 05 00 00       	jmp    802ed9 <smalloc+0x5a5>
	//==============================================================
	acquire_uspinlock(&ulock);
  802955:	83 ec 0c             	sub    $0xc,%esp
  802958:	68 40 e1 81 00       	push   $0x81e140
  80295d:	e8 d8 1b 00 00       	call   80453a <acquire_uspinlock>
  802962:	83 c4 10             	add    $0x10,%esp

	struct UserHeapStruct* allocblock = (struct UserHeapStruct*) alloc_block(sizeof(struct UserHeapStruct));
  802965:	83 ec 0c             	sub    $0xc,%esp
  802968:	6a 10                	push   $0x10
  80296a:	e8 63 13 00 00       	call   803cd2 <alloc_block>
  80296f:	83 c4 10             	add    $0x10,%esp
  802972:	89 45 ec             	mov    %eax,-0x14(%ebp)
	if (allocblock == NULL){
  802975:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802979:	75 0a                	jne    802985 <smalloc+0x51>
				return NULL;
  80297b:	b8 00 00 00 00       	mov    $0x0,%eax
  802980:	e9 54 05 00 00       	jmp    802ed9 <smalloc+0x5a5>
	}
		size = ROUNDUP(size,PAGE_SIZE);
  802985:	c7 45 e8 00 10 00 00 	movl   $0x1000,-0x18(%ebp)
  80298c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80298f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802992:	01 d0                	add    %edx,%eax
  802994:	48                   	dec    %eax
  802995:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  802998:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80299b:	ba 00 00 00 00       	mov    $0x0,%edx
  8029a0:	f7 75 e8             	divl   -0x18(%ebp)
  8029a3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8029a6:	29 d0                	sub    %edx,%eax
  8029a8:	89 45 0c             	mov    %eax,0xc(%ebp)
		struct UserHeapStruct* lastfreeelement = LIST_LAST(&u_freelist);
  8029ab:	a1 24 e1 81 00       	mov    0x81e124,%eax
  8029b0:	89 45 e0             	mov    %eax,-0x20(%ebp)

		if(LIST_SIZE(&u_freelist)==0 || size>lastfreeelement->size){
  8029b3:	a1 2c e1 81 00       	mov    0x81e12c,%eax
  8029b8:	85 c0                	test   %eax,%eax
  8029ba:	74 0f                	je     8029cb <smalloc+0x97>
  8029bc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8029bf:	8b 40 04             	mov    0x4(%eax),%eax
  8029c2:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8029c5:	0f 83 25 01 00 00    	jae    802af0 <smalloc+0x1bc>
				if(uheapPageAllocBreak <= USER_HEAP_MAX - size){
  8029cb:	b8 00 00 00 a0       	mov    $0xa0000000,%eax
  8029d0:	2b 45 0c             	sub    0xc(%ebp),%eax
  8029d3:	89 c2                	mov    %eax,%edx
  8029d5:	a1 68 e0 81 00       	mov    0x81e068,%eax
  8029da:	39 c2                	cmp    %eax,%edx
  8029dc:	0f 82 f4 00 00 00    	jb     802ad6 <smalloc+0x1a2>
						uint32 requestedblockva = uheapPageAllocBreak;
  8029e2:	a1 68 e0 81 00       	mov    0x81e068,%eax
  8029e7:	89 45 d4             	mov    %eax,-0x2c(%ebp)
						uheapPageAllocBreak+=size;
  8029ea:	8b 15 68 e0 81 00    	mov    0x81e068,%edx
  8029f0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8029f3:	01 d0                	add    %edx,%eax
  8029f5:	a3 68 e0 81 00       	mov    %eax,0x81e068
						allocblock->startva = requestedblockva;
  8029fa:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029fd:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802a00:	89 10                	mov    %edx,(%eax)
						allocblock->size = size;
  802a02:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a05:	8b 55 0c             	mov    0xc(%ebp),%edx
  802a08:	89 50 04             	mov    %edx,0x4(%eax)

						LIST_INSERT_TAIL(&u_allocatedlist, allocblock);
  802a0b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802a0f:	75 17                	jne    802a28 <smalloc+0xf4>
  802a11:	83 ec 04             	sub    $0x4,%esp
  802a14:	68 2c 51 80 00       	push   $0x80512c
  802a19:	68 57 01 00 00       	push   $0x157
  802a1e:	68 e0 50 80 00       	push   $0x8050e0
  802a23:	e8 8f dd ff ff       	call   8007b7 <_panic>
  802a28:	8b 15 34 e1 81 00    	mov    0x81e134,%edx
  802a2e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a31:	89 50 0c             	mov    %edx,0xc(%eax)
  802a34:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a37:	8b 40 0c             	mov    0xc(%eax),%eax
  802a3a:	85 c0                	test   %eax,%eax
  802a3c:	74 0d                	je     802a4b <smalloc+0x117>
  802a3e:	a1 34 e1 81 00       	mov    0x81e134,%eax
  802a43:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802a46:	89 50 08             	mov    %edx,0x8(%eax)
  802a49:	eb 08                	jmp    802a53 <smalloc+0x11f>
  802a4b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a4e:	a3 30 e1 81 00       	mov    %eax,0x81e130
  802a53:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a56:	a3 34 e1 81 00       	mov    %eax,0x81e134
  802a5b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a5e:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802a65:	a1 3c e1 81 00       	mov    0x81e13c,%eax
  802a6a:	40                   	inc    %eax
  802a6b:	a3 3c e1 81 00       	mov    %eax,0x81e13c


						int result = sys_create_shared_object(sharedVarName ,size ,isWritable ,(void*)allocblock->startva);
  802a70:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a73:	8b 00                	mov    (%eax),%eax
  802a75:	89 c2                	mov    %eax,%edx
  802a77:	0f b6 45 c4          	movzbl -0x3c(%ebp),%eax
  802a7b:	52                   	push   %edx
  802a7c:	50                   	push   %eax
  802a7d:	ff 75 0c             	pushl  0xc(%ebp)
  802a80:	ff 75 08             	pushl  0x8(%ebp)
  802a83:	e8 48 0c 00 00       	call   8036d0 <sys_create_shared_object>
  802a88:	83 c4 10             	add    $0x10,%esp
  802a8b:	89 45 d0             	mov    %eax,-0x30(%ebp)

						if(result <0){
  802a8e:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  802a92:	79 28                	jns    802abc <smalloc+0x188>
							free_block(allocblock);
  802a94:	83 ec 0c             	sub    $0xc,%esp
  802a97:	ff 75 ec             	pushl  -0x14(%ebp)
  802a9a:	e8 cf 16 00 00       	call   80416e <free_block>
  802a9f:	83 c4 10             	add    $0x10,%esp
							release_uspinlock(&ulock);
  802aa2:	83 ec 0c             	sub    $0xc,%esp
  802aa5:	68 40 e1 81 00       	push   $0x81e140
  802aaa:	e8 e3 1a 00 00       	call   804592 <release_uspinlock>
  802aaf:	83 c4 10             	add    $0x10,%esp
							return NULL;
  802ab2:	b8 00 00 00 00       	mov    $0x0,%eax
  802ab7:	e9 1d 04 00 00       	jmp    802ed9 <smalloc+0x5a5>
						}
						release_uspinlock(&ulock);
  802abc:	83 ec 0c             	sub    $0xc,%esp
  802abf:	68 40 e1 81 00       	push   $0x81e140
  802ac4:	e8 c9 1a 00 00       	call   804592 <release_uspinlock>
  802ac9:	83 c4 10             	add    $0x10,%esp
						return (void*)allocblock -> startva;
  802acc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802acf:	8b 00                	mov    (%eax),%eax
  802ad1:	e9 03 04 00 00       	jmp    802ed9 <smalloc+0x5a5>
				}else{
						release_uspinlock(&ulock);
  802ad6:	83 ec 0c             	sub    $0xc,%esp
  802ad9:	68 40 e1 81 00       	push   $0x81e140
  802ade:	e8 af 1a 00 00       	call   804592 <release_uspinlock>
  802ae3:	83 c4 10             	add    $0x10,%esp
						return NULL;
  802ae6:	b8 00 00 00 00       	mov    $0x0,%eax
  802aeb:	e9 e9 03 00 00       	jmp    802ed9 <smalloc+0x5a5>
					 }
		}else{
			//custom fit
			struct UserHeapStruct* currentfreeelement = LIST_FIRST(&u_freelist);
  802af0:	a1 20 e1 81 00       	mov    0x81e120,%eax
  802af5:	89 45 f4             	mov    %eax,-0xc(%ebp)
			//worst fit
			while(currentfreeelement != NULL){
  802af8:	e9 af 03 00 00       	jmp    802eac <smalloc+0x578>
				if(size<currentfreeelement->size){
  802afd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b00:	8b 40 04             	mov    0x4(%eax),%eax
  802b03:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802b06:	0f 86 28 02 00 00    	jbe    802d34 <smalloc+0x400>
					allocblock->startva = lastfreeelement->startva;
  802b0c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802b0f:	8b 10                	mov    (%eax),%edx
  802b11:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b14:	89 10                	mov    %edx,(%eax)
	                allocblock->size = size;
  802b16:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b19:	8b 55 0c             	mov    0xc(%ebp),%edx
  802b1c:	89 50 04             	mov    %edx,0x4(%eax)
	                LIST_INSERT_TAIL(&u_allocatedlist,allocblock);
  802b1f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802b23:	75 17                	jne    802b3c <smalloc+0x208>
  802b25:	83 ec 04             	sub    $0x4,%esp
  802b28:	68 2c 51 80 00       	push   $0x80512c
  802b2d:	68 6f 01 00 00       	push   $0x16f
  802b32:	68 e0 50 80 00       	push   $0x8050e0
  802b37:	e8 7b dc ff ff       	call   8007b7 <_panic>
  802b3c:	8b 15 34 e1 81 00    	mov    0x81e134,%edx
  802b42:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b45:	89 50 0c             	mov    %edx,0xc(%eax)
  802b48:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b4b:	8b 40 0c             	mov    0xc(%eax),%eax
  802b4e:	85 c0                	test   %eax,%eax
  802b50:	74 0d                	je     802b5f <smalloc+0x22b>
  802b52:	a1 34 e1 81 00       	mov    0x81e134,%eax
  802b57:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802b5a:	89 50 08             	mov    %edx,0x8(%eax)
  802b5d:	eb 08                	jmp    802b67 <smalloc+0x233>
  802b5f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b62:	a3 30 e1 81 00       	mov    %eax,0x81e130
  802b67:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b6a:	a3 34 e1 81 00       	mov    %eax,0x81e134
  802b6f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b72:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802b79:	a1 3c e1 81 00       	mov    0x81e13c,%eax
  802b7e:	40                   	inc    %eax
  802b7f:	a3 3c e1 81 00       	mov    %eax,0x81e13c
	                lastfreeelement->startva += size;
  802b84:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802b87:	8b 10                	mov    (%eax),%edx
  802b89:	8b 45 0c             	mov    0xc(%ebp),%eax
  802b8c:	01 c2                	add    %eax,%edx
  802b8e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802b91:	89 10                	mov    %edx,(%eax)
	                lastfreeelement->size -= size;
  802b93:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802b96:	8b 40 04             	mov    0x4(%eax),%eax
  802b99:	2b 45 0c             	sub    0xc(%ebp),%eax
  802b9c:	89 c2                	mov    %eax,%edx
  802b9e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802ba1:	89 50 04             	mov    %edx,0x4(%eax)
	                struct UserHeapStruct* currentfree2 = LIST_FIRST(&u_freelist);
  802ba4:	a1 20 e1 81 00       	mov    0x81e120,%eax
  802ba9:	89 45 f0             	mov    %eax,-0x10(%ebp)
	                //check order of last element

	                while (currentfree2 != NULL){
  802bac:	e9 13 01 00 00       	jmp    802cc4 <smalloc+0x390>
	                	if(lastfreeelement->size <currentfree2->size){
  802bb1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802bb4:	8b 50 04             	mov    0x4(%eax),%edx
  802bb7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bba:	8b 40 04             	mov    0x4(%eax),%eax
  802bbd:	39 c2                	cmp    %eax,%edx
  802bbf:	0f 83 f6 00 00 00    	jae    802cbb <smalloc+0x387>
	                		LIST_REMOVE(&u_freelist ,lastfreeelement);
  802bc5:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802bc9:	75 17                	jne    802be2 <smalloc+0x2ae>
  802bcb:	83 ec 04             	sub    $0x4,%esp
  802bce:	68 4f 51 80 00       	push   $0x80514f
  802bd3:	68 77 01 00 00       	push   $0x177
  802bd8:	68 e0 50 80 00       	push   $0x8050e0
  802bdd:	e8 d5 db ff ff       	call   8007b7 <_panic>
  802be2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802be5:	8b 40 08             	mov    0x8(%eax),%eax
  802be8:	85 c0                	test   %eax,%eax
  802bea:	74 11                	je     802bfd <smalloc+0x2c9>
  802bec:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802bef:	8b 40 08             	mov    0x8(%eax),%eax
  802bf2:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802bf5:	8b 52 0c             	mov    0xc(%edx),%edx
  802bf8:	89 50 0c             	mov    %edx,0xc(%eax)
  802bfb:	eb 0b                	jmp    802c08 <smalloc+0x2d4>
  802bfd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802c00:	8b 40 0c             	mov    0xc(%eax),%eax
  802c03:	a3 24 e1 81 00       	mov    %eax,0x81e124
  802c08:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802c0b:	8b 40 0c             	mov    0xc(%eax),%eax
  802c0e:	85 c0                	test   %eax,%eax
  802c10:	74 11                	je     802c23 <smalloc+0x2ef>
  802c12:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802c15:	8b 40 0c             	mov    0xc(%eax),%eax
  802c18:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802c1b:	8b 52 08             	mov    0x8(%edx),%edx
  802c1e:	89 50 08             	mov    %edx,0x8(%eax)
  802c21:	eb 0b                	jmp    802c2e <smalloc+0x2fa>
  802c23:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802c26:	8b 40 08             	mov    0x8(%eax),%eax
  802c29:	a3 20 e1 81 00       	mov    %eax,0x81e120
  802c2e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802c31:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802c38:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802c3b:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  802c42:	a1 2c e1 81 00       	mov    0x81e12c,%eax
  802c47:	48                   	dec    %eax
  802c48:	a3 2c e1 81 00       	mov    %eax,0x81e12c
	                		LIST_INSERT_BEFORE(&u_freelist ,currentfree2 ,lastfreeelement);
  802c4d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802c51:	74 06                	je     802c59 <smalloc+0x325>
  802c53:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802c57:	75 17                	jne    802c70 <smalloc+0x33c>
  802c59:	83 ec 04             	sub    $0x4,%esp
  802c5c:	68 70 51 80 00       	push   $0x805170
  802c61:	68 78 01 00 00       	push   $0x178
  802c66:	68 e0 50 80 00       	push   $0x8050e0
  802c6b:	e8 47 db ff ff       	call   8007b7 <_panic>
  802c70:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c73:	8b 50 0c             	mov    0xc(%eax),%edx
  802c76:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802c79:	89 50 0c             	mov    %edx,0xc(%eax)
  802c7c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802c7f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802c82:	89 50 08             	mov    %edx,0x8(%eax)
  802c85:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c88:	8b 40 0c             	mov    0xc(%eax),%eax
  802c8b:	85 c0                	test   %eax,%eax
  802c8d:	74 0e                	je     802c9d <smalloc+0x369>
  802c8f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c92:	8b 40 0c             	mov    0xc(%eax),%eax
  802c95:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802c98:	89 50 08             	mov    %edx,0x8(%eax)
  802c9b:	eb 08                	jmp    802ca5 <smalloc+0x371>
  802c9d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802ca0:	a3 20 e1 81 00       	mov    %eax,0x81e120
  802ca5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ca8:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802cab:	89 50 0c             	mov    %edx,0xc(%eax)
  802cae:	a1 2c e1 81 00       	mov    0x81e12c,%eax
  802cb3:	40                   	inc    %eax
  802cb4:	a3 2c e1 81 00       	mov    %eax,0x81e12c
	                		break;
  802cb9:	eb 13                	jmp    802cce <smalloc+0x39a>
	                	}
	                	currentfree2 = currentfree2->prev_next_info.le_next;
  802cbb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cbe:	8b 40 08             	mov    0x8(%eax),%eax
  802cc1:	89 45 f0             	mov    %eax,-0x10(%ebp)
	                lastfreeelement->startva += size;
	                lastfreeelement->size -= size;
	                struct UserHeapStruct* currentfree2 = LIST_FIRST(&u_freelist);
	                //check order of last element

	                while (currentfree2 != NULL){
  802cc4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802cc8:	0f 85 e3 fe ff ff    	jne    802bb1 <smalloc+0x27d>
	                	}
	                	currentfree2 = currentfree2->prev_next_info.le_next;
	                }


	                int result = sys_create_shared_object(sharedVarName ,size ,isWritable ,(void*)allocblock->startva);
  802cce:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cd1:	8b 00                	mov    (%eax),%eax
  802cd3:	89 c2                	mov    %eax,%edx
  802cd5:	0f b6 45 c4          	movzbl -0x3c(%ebp),%eax
  802cd9:	52                   	push   %edx
  802cda:	50                   	push   %eax
  802cdb:	ff 75 0c             	pushl  0xc(%ebp)
  802cde:	ff 75 08             	pushl  0x8(%ebp)
  802ce1:	e8 ea 09 00 00       	call   8036d0 <sys_create_shared_object>
  802ce6:	83 c4 10             	add    $0x10,%esp
  802ce9:	89 45 d8             	mov    %eax,-0x28(%ebp)

	                if(result <0){
  802cec:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  802cf0:	79 28                	jns    802d1a <smalloc+0x3e6>
	                	free_block(allocblock);
  802cf2:	83 ec 0c             	sub    $0xc,%esp
  802cf5:	ff 75 ec             	pushl  -0x14(%ebp)
  802cf8:	e8 71 14 00 00       	call   80416e <free_block>
  802cfd:	83 c4 10             	add    $0x10,%esp
	                	release_uspinlock(&ulock);
  802d00:	83 ec 0c             	sub    $0xc,%esp
  802d03:	68 40 e1 81 00       	push   $0x81e140
  802d08:	e8 85 18 00 00       	call   804592 <release_uspinlock>
  802d0d:	83 c4 10             	add    $0x10,%esp
	                	return NULL;
  802d10:	b8 00 00 00 00       	mov    $0x0,%eax
  802d15:	e9 bf 01 00 00       	jmp    802ed9 <smalloc+0x5a5>
	                }
	                release_uspinlock(&ulock);
  802d1a:	83 ec 0c             	sub    $0xc,%esp
  802d1d:	68 40 e1 81 00       	push   $0x81e140
  802d22:	e8 6b 18 00 00       	call   804592 <release_uspinlock>
  802d27:	83 c4 10             	add    $0x10,%esp
	                return (void*)allocblock->startva;
  802d2a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d2d:	8b 00                	mov    (%eax),%eax
  802d2f:	e9 a5 01 00 00       	jmp    802ed9 <smalloc+0x5a5>
	                //exact fit
				}else if(size == currentfreeelement->size){
  802d34:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d37:	8b 40 04             	mov    0x4(%eax),%eax
  802d3a:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802d3d:	0f 85 60 01 00 00    	jne    802ea3 <smalloc+0x56f>
					allocblock->startva = currentfreeelement->startva;
  802d43:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d46:	8b 10                	mov    (%eax),%edx
  802d48:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d4b:	89 10                	mov    %edx,(%eax)
					allocblock->size = size;
  802d4d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d50:	8b 55 0c             	mov    0xc(%ebp),%edx
  802d53:	89 50 04             	mov    %edx,0x4(%eax)
					LIST_INSERT_TAIL(&u_allocatedlist ,allocblock);
  802d56:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802d5a:	75 17                	jne    802d73 <smalloc+0x43f>
  802d5c:	83 ec 04             	sub    $0x4,%esp
  802d5f:	68 2c 51 80 00       	push   $0x80512c
  802d64:	68 8c 01 00 00       	push   $0x18c
  802d69:	68 e0 50 80 00       	push   $0x8050e0
  802d6e:	e8 44 da ff ff       	call   8007b7 <_panic>
  802d73:	8b 15 34 e1 81 00    	mov    0x81e134,%edx
  802d79:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d7c:	89 50 0c             	mov    %edx,0xc(%eax)
  802d7f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d82:	8b 40 0c             	mov    0xc(%eax),%eax
  802d85:	85 c0                	test   %eax,%eax
  802d87:	74 0d                	je     802d96 <smalloc+0x462>
  802d89:	a1 34 e1 81 00       	mov    0x81e134,%eax
  802d8e:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802d91:	89 50 08             	mov    %edx,0x8(%eax)
  802d94:	eb 08                	jmp    802d9e <smalloc+0x46a>
  802d96:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d99:	a3 30 e1 81 00       	mov    %eax,0x81e130
  802d9e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802da1:	a3 34 e1 81 00       	mov    %eax,0x81e134
  802da6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802da9:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802db0:	a1 3c e1 81 00       	mov    0x81e13c,%eax
  802db5:	40                   	inc    %eax
  802db6:	a3 3c e1 81 00       	mov    %eax,0x81e13c
					LIST_REMOVE(&u_freelist ,currentfreeelement);
  802dbb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802dbf:	75 17                	jne    802dd8 <smalloc+0x4a4>
  802dc1:	83 ec 04             	sub    $0x4,%esp
  802dc4:	68 4f 51 80 00       	push   $0x80514f
  802dc9:	68 8d 01 00 00       	push   $0x18d
  802dce:	68 e0 50 80 00       	push   $0x8050e0
  802dd3:	e8 df d9 ff ff       	call   8007b7 <_panic>
  802dd8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ddb:	8b 40 08             	mov    0x8(%eax),%eax
  802dde:	85 c0                	test   %eax,%eax
  802de0:	74 11                	je     802df3 <smalloc+0x4bf>
  802de2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802de5:	8b 40 08             	mov    0x8(%eax),%eax
  802de8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802deb:	8b 52 0c             	mov    0xc(%edx),%edx
  802dee:	89 50 0c             	mov    %edx,0xc(%eax)
  802df1:	eb 0b                	jmp    802dfe <smalloc+0x4ca>
  802df3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802df6:	8b 40 0c             	mov    0xc(%eax),%eax
  802df9:	a3 24 e1 81 00       	mov    %eax,0x81e124
  802dfe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e01:	8b 40 0c             	mov    0xc(%eax),%eax
  802e04:	85 c0                	test   %eax,%eax
  802e06:	74 11                	je     802e19 <smalloc+0x4e5>
  802e08:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e0b:	8b 40 0c             	mov    0xc(%eax),%eax
  802e0e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e11:	8b 52 08             	mov    0x8(%edx),%edx
  802e14:	89 50 08             	mov    %edx,0x8(%eax)
  802e17:	eb 0b                	jmp    802e24 <smalloc+0x4f0>
  802e19:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e1c:	8b 40 08             	mov    0x8(%eax),%eax
  802e1f:	a3 20 e1 81 00       	mov    %eax,0x81e120
  802e24:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e27:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802e2e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e31:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  802e38:	a1 2c e1 81 00       	mov    0x81e12c,%eax
  802e3d:	48                   	dec    %eax
  802e3e:	a3 2c e1 81 00       	mov    %eax,0x81e12c
					int result = sys_create_shared_object(sharedVarName ,size ,isWritable ,(void*)allocblock->startva);
  802e43:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e46:	8b 00                	mov    (%eax),%eax
  802e48:	89 c2                	mov    %eax,%edx
  802e4a:	0f b6 45 c4          	movzbl -0x3c(%ebp),%eax
  802e4e:	52                   	push   %edx
  802e4f:	50                   	push   %eax
  802e50:	ff 75 0c             	pushl  0xc(%ebp)
  802e53:	ff 75 08             	pushl  0x8(%ebp)
  802e56:	e8 75 08 00 00       	call   8036d0 <sys_create_shared_object>
  802e5b:	83 c4 10             	add    $0x10,%esp
  802e5e:	89 45 dc             	mov    %eax,-0x24(%ebp)

					if(result <0){
  802e61:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802e65:	79 25                	jns    802e8c <smalloc+0x558>
						free_block(allocblock);
  802e67:	83 ec 0c             	sub    $0xc,%esp
  802e6a:	ff 75 ec             	pushl  -0x14(%ebp)
  802e6d:	e8 fc 12 00 00       	call   80416e <free_block>
  802e72:	83 c4 10             	add    $0x10,%esp
						release_uspinlock(&ulock);
  802e75:	83 ec 0c             	sub    $0xc,%esp
  802e78:	68 40 e1 81 00       	push   $0x81e140
  802e7d:	e8 10 17 00 00       	call   804592 <release_uspinlock>
  802e82:	83 c4 10             	add    $0x10,%esp
						return NULL;
  802e85:	b8 00 00 00 00       	mov    $0x0,%eax
  802e8a:	eb 4d                	jmp    802ed9 <smalloc+0x5a5>
					}
					release_uspinlock(&ulock);
  802e8c:	83 ec 0c             	sub    $0xc,%esp
  802e8f:	68 40 e1 81 00       	push   $0x81e140
  802e94:	e8 f9 16 00 00       	call   804592 <release_uspinlock>
  802e99:	83 c4 10             	add    $0x10,%esp
					return (void*)allocblock->startva;
  802e9c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e9f:	8b 00                	mov    (%eax),%eax
  802ea1:	eb 36                	jmp    802ed9 <smalloc+0x5a5>
				}
				currentfreeelement = currentfreeelement->prev_next_info.le_next;
  802ea3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ea6:	8b 40 08             	mov    0x8(%eax),%eax
  802ea9:	89 45 f4             	mov    %eax,-0xc(%ebp)
					 }
		}else{
			//custom fit
			struct UserHeapStruct* currentfreeelement = LIST_FIRST(&u_freelist);
			//worst fit
			while(currentfreeelement != NULL){
  802eac:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802eb0:	0f 85 47 fc ff ff    	jne    802afd <smalloc+0x1c9>
					return (void*)allocblock->startva;
				}
				currentfreeelement = currentfreeelement->prev_next_info.le_next;
			}
		}
		free_block(allocblock);
  802eb6:	83 ec 0c             	sub    $0xc,%esp
  802eb9:	ff 75 ec             	pushl  -0x14(%ebp)
  802ebc:	e8 ad 12 00 00       	call   80416e <free_block>
  802ec1:	83 c4 10             	add    $0x10,%esp
		release_uspinlock(&ulock);
  802ec4:	83 ec 0c             	sub    $0xc,%esp
  802ec7:	68 40 e1 81 00       	push   $0x81e140
  802ecc:	e8 c1 16 00 00       	call   804592 <release_uspinlock>
  802ed1:	83 c4 10             	add    $0x10,%esp
		return NULL;
  802ed4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802ed9:	c9                   	leave  
  802eda:	c3                   	ret    

00802edb <sget>:

//========================================
// [4] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  802edb:	55                   	push   %ebp
  802edc:	89 e5                	mov    %esp,%ebp
  802ede:	83 ec 38             	sub    $0x38,%esp


	 //==============================================================
	 // DON'T CHANGE THIS CODE
	    uheap_init();
  802ee1:	e8 8c ec ff ff       	call   801b72 <uheap_init>
	 //==============================================================
	 // Get size of the shared variable from kernel
	acquire_uspinlock(&ulock);
  802ee6:	83 ec 0c             	sub    $0xc,%esp
  802ee9:	68 40 e1 81 00       	push   $0x81e140
  802eee:	e8 47 16 00 00       	call   80453a <acquire_uspinlock>
  802ef3:	83 c4 10             	add    $0x10,%esp


	int size = sys_size_of_shared_object(ownerEnvID ,sharedVarName);
  802ef6:	83 ec 08             	sub    $0x8,%esp
  802ef9:	ff 75 0c             	pushl  0xc(%ebp)
  802efc:	ff 75 08             	pushl  0x8(%ebp)
  802eff:	e8 f6 07 00 00       	call   8036fa <sys_size_of_shared_object>
  802f04:	83 c4 10             	add    $0x10,%esp
  802f07:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if ( size < 0 ){
  802f0a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802f0e:	79 1a                	jns    802f2a <sget+0x4f>
			release_uspinlock(&ulock);
  802f10:	83 ec 0c             	sub    $0xc,%esp
  802f13:	68 40 e1 81 00       	push   $0x81e140
  802f18:	e8 75 16 00 00       	call   804592 <release_uspinlock>
  802f1d:	83 c4 10             	add    $0x10,%esp
			return NULL;
  802f20:	b8 00 00 00 00       	mov    $0x0,%eax
  802f25:	e9 6e 05 00 00       	jmp    803498 <sget+0x5bd>
		}
		size = ROUNDUP(size,PAGE_SIZE);
  802f2a:	c7 45 e8 00 10 00 00 	movl   $0x1000,-0x18(%ebp)
  802f31:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802f34:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f37:	01 d0                	add    %edx,%eax
  802f39:	48                   	dec    %eax
  802f3a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  802f3d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f40:	ba 00 00 00 00       	mov    $0x0,%edx
  802f45:	f7 75 e8             	divl   -0x18(%ebp)
  802f48:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f4b:	29 d0                	sub    %edx,%eax
  802f4d:	89 45 ec             	mov    %eax,-0x14(%ebp)

		struct UserHeapStruct* allocblock = (struct UserHeapStruct*) alloc_block(sizeof(struct UserHeapStruct));
  802f50:	83 ec 0c             	sub    $0xc,%esp
  802f53:	6a 10                	push   $0x10
  802f55:	e8 78 0d 00 00       	call   803cd2 <alloc_block>
  802f5a:	83 c4 10             	add    $0x10,%esp
  802f5d:	89 45 e0             	mov    %eax,-0x20(%ebp)

		if (allocblock == NULL){
  802f60:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802f64:	75 0a                	jne    802f70 <sget+0x95>
			return NULL;
  802f66:	b8 00 00 00 00       	mov    $0x0,%eax
  802f6b:	e9 28 05 00 00       	jmp    803498 <sget+0x5bd>
		}
		struct UserHeapStruct* lastfreeelement = LIST_LAST(&u_freelist);
  802f70:	a1 24 e1 81 00       	mov    0x81e124,%eax
  802f75:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if(LIST_SIZE(&u_freelist)==0 || size>lastfreeelement->size){
  802f78:	a1 2c e1 81 00       	mov    0x81e12c,%eax
  802f7d:	85 c0                	test   %eax,%eax
  802f7f:	74 11                	je     802f92 <sget+0xb7>
  802f81:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802f84:	8b 50 04             	mov    0x4(%eax),%edx
  802f87:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f8a:	39 c2                	cmp    %eax,%edx
  802f8c:	0f 83 21 01 00 00    	jae    8030b3 <sget+0x1d8>
				if(uheapPageAllocBreak <= USER_HEAP_MAX - size){
  802f92:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f95:	ba 00 00 00 a0       	mov    $0xa0000000,%edx
  802f9a:	29 c2                	sub    %eax,%edx
  802f9c:	a1 68 e0 81 00       	mov    0x81e068,%eax
  802fa1:	39 c2                	cmp    %eax,%edx
  802fa3:	0f 82 f0 00 00 00    	jb     803099 <sget+0x1be>

						uint32 requestedblockva = uheapPageAllocBreak;
  802fa9:	a1 68 e0 81 00       	mov    0x81e068,%eax
  802fae:	89 45 d0             	mov    %eax,-0x30(%ebp)
						uheapPageAllocBreak+=size;
  802fb1:	8b 15 68 e0 81 00    	mov    0x81e068,%edx
  802fb7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802fba:	01 d0                	add    %edx,%eax
  802fbc:	a3 68 e0 81 00       	mov    %eax,0x81e068
						allocblock->startva = requestedblockva;
  802fc1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802fc4:	8b 55 d0             	mov    -0x30(%ebp),%edx
  802fc7:	89 10                	mov    %edx,(%eax)
						allocblock->size = size;
  802fc9:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802fcc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802fcf:	89 50 04             	mov    %edx,0x4(%eax)

						LIST_INSERT_TAIL(&u_allocatedlist, allocblock);
  802fd2:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802fd6:	75 17                	jne    802fef <sget+0x114>
  802fd8:	83 ec 04             	sub    $0x4,%esp
  802fdb:	68 2c 51 80 00       	push   $0x80512c
  802fe0:	68 c8 01 00 00       	push   $0x1c8
  802fe5:	68 e0 50 80 00       	push   $0x8050e0
  802fea:	e8 c8 d7 ff ff       	call   8007b7 <_panic>
  802fef:	8b 15 34 e1 81 00    	mov    0x81e134,%edx
  802ff5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802ff8:	89 50 0c             	mov    %edx,0xc(%eax)
  802ffb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802ffe:	8b 40 0c             	mov    0xc(%eax),%eax
  803001:	85 c0                	test   %eax,%eax
  803003:	74 0d                	je     803012 <sget+0x137>
  803005:	a1 34 e1 81 00       	mov    0x81e134,%eax
  80300a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80300d:	89 50 08             	mov    %edx,0x8(%eax)
  803010:	eb 08                	jmp    80301a <sget+0x13f>
  803012:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803015:	a3 30 e1 81 00       	mov    %eax,0x81e130
  80301a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80301d:	a3 34 e1 81 00       	mov    %eax,0x81e134
  803022:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803025:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  80302c:	a1 3c e1 81 00       	mov    0x81e13c,%eax
  803031:	40                   	inc    %eax
  803032:	a3 3c e1 81 00       	mov    %eax,0x81e13c


						int result = sys_get_shared_object(ownerEnvID ,sharedVarName ,(void*)allocblock->startva);
  803037:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80303a:	8b 00                	mov    (%eax),%eax
  80303c:	83 ec 04             	sub    $0x4,%esp
  80303f:	50                   	push   %eax
  803040:	ff 75 0c             	pushl  0xc(%ebp)
  803043:	ff 75 08             	pushl  0x8(%ebp)
  803046:	e8 cc 06 00 00       	call   803717 <sys_get_shared_object>
  80304b:	83 c4 10             	add    $0x10,%esp
  80304e:	89 45 cc             	mov    %eax,-0x34(%ebp)

						if(result <0){
  803051:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  803055:	79 28                	jns    80307f <sget+0x1a4>
							free_block(allocblock);
  803057:	83 ec 0c             	sub    $0xc,%esp
  80305a:	ff 75 e0             	pushl  -0x20(%ebp)
  80305d:	e8 0c 11 00 00       	call   80416e <free_block>
  803062:	83 c4 10             	add    $0x10,%esp
							release_uspinlock(&ulock);
  803065:	83 ec 0c             	sub    $0xc,%esp
  803068:	68 40 e1 81 00       	push   $0x81e140
  80306d:	e8 20 15 00 00       	call   804592 <release_uspinlock>
  803072:	83 c4 10             	add    $0x10,%esp
							return NULL;
  803075:	b8 00 00 00 00       	mov    $0x0,%eax
  80307a:	e9 19 04 00 00       	jmp    803498 <sget+0x5bd>
						}
						release_uspinlock(&ulock);
  80307f:	83 ec 0c             	sub    $0xc,%esp
  803082:	68 40 e1 81 00       	push   $0x81e140
  803087:	e8 06 15 00 00       	call   804592 <release_uspinlock>
  80308c:	83 c4 10             	add    $0x10,%esp
						return (void*)allocblock -> startva;
  80308f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803092:	8b 00                	mov    (%eax),%eax
  803094:	e9 ff 03 00 00       	jmp    803498 <sget+0x5bd>
				}else{
						release_uspinlock(&ulock);
  803099:	83 ec 0c             	sub    $0xc,%esp
  80309c:	68 40 e1 81 00       	push   $0x81e140
  8030a1:	e8 ec 14 00 00       	call   804592 <release_uspinlock>
  8030a6:	83 c4 10             	add    $0x10,%esp
						return NULL;
  8030a9:	b8 00 00 00 00       	mov    $0x0,%eax
  8030ae:	e9 e5 03 00 00       	jmp    803498 <sget+0x5bd>
					 }
		}else{
			//custom fit
			struct UserHeapStruct* currentfreeelement = LIST_FIRST(&u_freelist);
  8030b3:	a1 20 e1 81 00       	mov    0x81e120,%eax
  8030b8:	89 45 f4             	mov    %eax,-0xc(%ebp)
			//worst fit
			while(currentfreeelement != NULL){
  8030bb:	e9 ab 03 00 00       	jmp    80346b <sget+0x590>
				if(size<currentfreeelement->size){
  8030c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030c3:	8b 50 04             	mov    0x4(%eax),%edx
  8030c6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030c9:	39 c2                	cmp    %eax,%edx
  8030cb:	0f 86 24 02 00 00    	jbe    8032f5 <sget+0x41a>
					allocblock->startva = lastfreeelement->startva;
  8030d1:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8030d4:	8b 10                	mov    (%eax),%edx
  8030d6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8030d9:	89 10                	mov    %edx,(%eax)
					allocblock->size = size;
  8030db:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8030de:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8030e1:	89 50 04             	mov    %edx,0x4(%eax)
					LIST_INSERT_TAIL(&u_allocatedlist,allocblock);
  8030e4:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8030e8:	75 17                	jne    803101 <sget+0x226>
  8030ea:	83 ec 04             	sub    $0x4,%esp
  8030ed:	68 2c 51 80 00       	push   $0x80512c
  8030f2:	68 e0 01 00 00       	push   $0x1e0
  8030f7:	68 e0 50 80 00       	push   $0x8050e0
  8030fc:	e8 b6 d6 ff ff       	call   8007b7 <_panic>
  803101:	8b 15 34 e1 81 00    	mov    0x81e134,%edx
  803107:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80310a:	89 50 0c             	mov    %edx,0xc(%eax)
  80310d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803110:	8b 40 0c             	mov    0xc(%eax),%eax
  803113:	85 c0                	test   %eax,%eax
  803115:	74 0d                	je     803124 <sget+0x249>
  803117:	a1 34 e1 81 00       	mov    0x81e134,%eax
  80311c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80311f:	89 50 08             	mov    %edx,0x8(%eax)
  803122:	eb 08                	jmp    80312c <sget+0x251>
  803124:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803127:	a3 30 e1 81 00       	mov    %eax,0x81e130
  80312c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80312f:	a3 34 e1 81 00       	mov    %eax,0x81e134
  803134:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803137:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  80313e:	a1 3c e1 81 00       	mov    0x81e13c,%eax
  803143:	40                   	inc    %eax
  803144:	a3 3c e1 81 00       	mov    %eax,0x81e13c
					lastfreeelement->startva += size;
  803149:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80314c:	8b 10                	mov    (%eax),%edx
  80314e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803151:	01 c2                	add    %eax,%edx
  803153:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803156:	89 10                	mov    %edx,(%eax)
					lastfreeelement->size -= size;
  803158:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80315b:	8b 50 04             	mov    0x4(%eax),%edx
  80315e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803161:	29 c2                	sub    %eax,%edx
  803163:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803166:	89 50 04             	mov    %edx,0x4(%eax)
					struct UserHeapStruct* currentfree2 = LIST_FIRST(&u_freelist);
  803169:	a1 20 e1 81 00       	mov    0x81e120,%eax
  80316e:	89 45 f0             	mov    %eax,-0x10(%ebp)
					//check order of last element

					while (currentfree2 != NULL){
  803171:	e9 13 01 00 00       	jmp    803289 <sget+0x3ae>
						if(lastfreeelement->size <currentfree2->size){
  803176:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803179:	8b 50 04             	mov    0x4(%eax),%edx
  80317c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80317f:	8b 40 04             	mov    0x4(%eax),%eax
  803182:	39 c2                	cmp    %eax,%edx
  803184:	0f 83 f6 00 00 00    	jae    803280 <sget+0x3a5>
							LIST_REMOVE(&u_freelist ,lastfreeelement);
  80318a:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80318e:	75 17                	jne    8031a7 <sget+0x2cc>
  803190:	83 ec 04             	sub    $0x4,%esp
  803193:	68 4f 51 80 00       	push   $0x80514f
  803198:	68 e8 01 00 00       	push   $0x1e8
  80319d:	68 e0 50 80 00       	push   $0x8050e0
  8031a2:	e8 10 d6 ff ff       	call   8007b7 <_panic>
  8031a7:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8031aa:	8b 40 08             	mov    0x8(%eax),%eax
  8031ad:	85 c0                	test   %eax,%eax
  8031af:	74 11                	je     8031c2 <sget+0x2e7>
  8031b1:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8031b4:	8b 40 08             	mov    0x8(%eax),%eax
  8031b7:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8031ba:	8b 52 0c             	mov    0xc(%edx),%edx
  8031bd:	89 50 0c             	mov    %edx,0xc(%eax)
  8031c0:	eb 0b                	jmp    8031cd <sget+0x2f2>
  8031c2:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8031c5:	8b 40 0c             	mov    0xc(%eax),%eax
  8031c8:	a3 24 e1 81 00       	mov    %eax,0x81e124
  8031cd:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8031d0:	8b 40 0c             	mov    0xc(%eax),%eax
  8031d3:	85 c0                	test   %eax,%eax
  8031d5:	74 11                	je     8031e8 <sget+0x30d>
  8031d7:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8031da:	8b 40 0c             	mov    0xc(%eax),%eax
  8031dd:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8031e0:	8b 52 08             	mov    0x8(%edx),%edx
  8031e3:	89 50 08             	mov    %edx,0x8(%eax)
  8031e6:	eb 0b                	jmp    8031f3 <sget+0x318>
  8031e8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8031eb:	8b 40 08             	mov    0x8(%eax),%eax
  8031ee:	a3 20 e1 81 00       	mov    %eax,0x81e120
  8031f3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8031f6:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  8031fd:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803200:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  803207:	a1 2c e1 81 00       	mov    0x81e12c,%eax
  80320c:	48                   	dec    %eax
  80320d:	a3 2c e1 81 00       	mov    %eax,0x81e12c
							LIST_INSERT_BEFORE(&u_freelist ,currentfree2 ,lastfreeelement);
  803212:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803216:	74 06                	je     80321e <sget+0x343>
  803218:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80321c:	75 17                	jne    803235 <sget+0x35a>
  80321e:	83 ec 04             	sub    $0x4,%esp
  803221:	68 70 51 80 00       	push   $0x805170
  803226:	68 e9 01 00 00       	push   $0x1e9
  80322b:	68 e0 50 80 00       	push   $0x8050e0
  803230:	e8 82 d5 ff ff       	call   8007b7 <_panic>
  803235:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803238:	8b 50 0c             	mov    0xc(%eax),%edx
  80323b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80323e:	89 50 0c             	mov    %edx,0xc(%eax)
  803241:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803244:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803247:	89 50 08             	mov    %edx,0x8(%eax)
  80324a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80324d:	8b 40 0c             	mov    0xc(%eax),%eax
  803250:	85 c0                	test   %eax,%eax
  803252:	74 0e                	je     803262 <sget+0x387>
  803254:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803257:	8b 40 0c             	mov    0xc(%eax),%eax
  80325a:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80325d:	89 50 08             	mov    %edx,0x8(%eax)
  803260:	eb 08                	jmp    80326a <sget+0x38f>
  803262:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803265:	a3 20 e1 81 00       	mov    %eax,0x81e120
  80326a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80326d:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803270:	89 50 0c             	mov    %edx,0xc(%eax)
  803273:	a1 2c e1 81 00       	mov    0x81e12c,%eax
  803278:	40                   	inc    %eax
  803279:	a3 2c e1 81 00       	mov    %eax,0x81e12c
							break;
  80327e:	eb 13                	jmp    803293 <sget+0x3b8>
						}
						currentfree2 = currentfree2->prev_next_info.le_next;
  803280:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803283:	8b 40 08             	mov    0x8(%eax),%eax
  803286:	89 45 f0             	mov    %eax,-0x10(%ebp)
					lastfreeelement->startva += size;
					lastfreeelement->size -= size;
					struct UserHeapStruct* currentfree2 = LIST_FIRST(&u_freelist);
					//check order of last element

					while (currentfree2 != NULL){
  803289:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80328d:	0f 85 e3 fe ff ff    	jne    803176 <sget+0x29b>
						}
						currentfree2 = currentfree2->prev_next_info.le_next;
					}


					int result = sys_get_shared_object(ownerEnvID ,sharedVarName ,(void*)allocblock->startva);
  803293:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803296:	8b 00                	mov    (%eax),%eax
  803298:	83 ec 04             	sub    $0x4,%esp
  80329b:	50                   	push   %eax
  80329c:	ff 75 0c             	pushl  0xc(%ebp)
  80329f:	ff 75 08             	pushl  0x8(%ebp)
  8032a2:	e8 70 04 00 00       	call   803717 <sys_get_shared_object>
  8032a7:	83 c4 10             	add    $0x10,%esp
  8032aa:	89 45 d4             	mov    %eax,-0x2c(%ebp)

					if(result <0){
  8032ad:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8032b1:	79 28                	jns    8032db <sget+0x400>
						free_block(allocblock);
  8032b3:	83 ec 0c             	sub    $0xc,%esp
  8032b6:	ff 75 e0             	pushl  -0x20(%ebp)
  8032b9:	e8 b0 0e 00 00       	call   80416e <free_block>
  8032be:	83 c4 10             	add    $0x10,%esp
						release_uspinlock(&ulock);
  8032c1:	83 ec 0c             	sub    $0xc,%esp
  8032c4:	68 40 e1 81 00       	push   $0x81e140
  8032c9:	e8 c4 12 00 00       	call   804592 <release_uspinlock>
  8032ce:	83 c4 10             	add    $0x10,%esp
						return NULL;
  8032d1:	b8 00 00 00 00       	mov    $0x0,%eax
  8032d6:	e9 bd 01 00 00       	jmp    803498 <sget+0x5bd>
					}
					release_uspinlock(&ulock);
  8032db:	83 ec 0c             	sub    $0xc,%esp
  8032de:	68 40 e1 81 00       	push   $0x81e140
  8032e3:	e8 aa 12 00 00       	call   804592 <release_uspinlock>
  8032e8:	83 c4 10             	add    $0x10,%esp
					return (void*)allocblock->startva;
  8032eb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8032ee:	8b 00                	mov    (%eax),%eax
  8032f0:	e9 a3 01 00 00       	jmp    803498 <sget+0x5bd>
					//exact fit
				}else if(size == currentfreeelement->size){
  8032f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032f8:	8b 50 04             	mov    0x4(%eax),%edx
  8032fb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8032fe:	39 c2                	cmp    %eax,%edx
  803300:	0f 85 5c 01 00 00    	jne    803462 <sget+0x587>

					allocblock->startva = currentfreeelement->startva;
  803306:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803309:	8b 10                	mov    (%eax),%edx
  80330b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80330e:	89 10                	mov    %edx,(%eax)
					allocblock->size = size;
  803310:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803313:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803316:	89 50 04             	mov    %edx,0x4(%eax)
					LIST_INSERT_TAIL(&u_allocatedlist ,allocblock);
  803319:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80331d:	75 17                	jne    803336 <sget+0x45b>
  80331f:	83 ec 04             	sub    $0x4,%esp
  803322:	68 2c 51 80 00       	push   $0x80512c
  803327:	68 fe 01 00 00       	push   $0x1fe
  80332c:	68 e0 50 80 00       	push   $0x8050e0
  803331:	e8 81 d4 ff ff       	call   8007b7 <_panic>
  803336:	8b 15 34 e1 81 00    	mov    0x81e134,%edx
  80333c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80333f:	89 50 0c             	mov    %edx,0xc(%eax)
  803342:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803345:	8b 40 0c             	mov    0xc(%eax),%eax
  803348:	85 c0                	test   %eax,%eax
  80334a:	74 0d                	je     803359 <sget+0x47e>
  80334c:	a1 34 e1 81 00       	mov    0x81e134,%eax
  803351:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803354:	89 50 08             	mov    %edx,0x8(%eax)
  803357:	eb 08                	jmp    803361 <sget+0x486>
  803359:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80335c:	a3 30 e1 81 00       	mov    %eax,0x81e130
  803361:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803364:	a3 34 e1 81 00       	mov    %eax,0x81e134
  803369:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80336c:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  803373:	a1 3c e1 81 00       	mov    0x81e13c,%eax
  803378:	40                   	inc    %eax
  803379:	a3 3c e1 81 00       	mov    %eax,0x81e13c
					LIST_REMOVE(&u_freelist ,currentfreeelement);
  80337e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803382:	75 17                	jne    80339b <sget+0x4c0>
  803384:	83 ec 04             	sub    $0x4,%esp
  803387:	68 4f 51 80 00       	push   $0x80514f
  80338c:	68 ff 01 00 00       	push   $0x1ff
  803391:	68 e0 50 80 00       	push   $0x8050e0
  803396:	e8 1c d4 ff ff       	call   8007b7 <_panic>
  80339b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80339e:	8b 40 08             	mov    0x8(%eax),%eax
  8033a1:	85 c0                	test   %eax,%eax
  8033a3:	74 11                	je     8033b6 <sget+0x4db>
  8033a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033a8:	8b 40 08             	mov    0x8(%eax),%eax
  8033ab:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8033ae:	8b 52 0c             	mov    0xc(%edx),%edx
  8033b1:	89 50 0c             	mov    %edx,0xc(%eax)
  8033b4:	eb 0b                	jmp    8033c1 <sget+0x4e6>
  8033b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033b9:	8b 40 0c             	mov    0xc(%eax),%eax
  8033bc:	a3 24 e1 81 00       	mov    %eax,0x81e124
  8033c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033c4:	8b 40 0c             	mov    0xc(%eax),%eax
  8033c7:	85 c0                	test   %eax,%eax
  8033c9:	74 11                	je     8033dc <sget+0x501>
  8033cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033ce:	8b 40 0c             	mov    0xc(%eax),%eax
  8033d1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8033d4:	8b 52 08             	mov    0x8(%edx),%edx
  8033d7:	89 50 08             	mov    %edx,0x8(%eax)
  8033da:	eb 0b                	jmp    8033e7 <sget+0x50c>
  8033dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033df:	8b 40 08             	mov    0x8(%eax),%eax
  8033e2:	a3 20 e1 81 00       	mov    %eax,0x81e120
  8033e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033ea:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  8033f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033f4:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  8033fb:	a1 2c e1 81 00       	mov    0x81e12c,%eax
  803400:	48                   	dec    %eax
  803401:	a3 2c e1 81 00       	mov    %eax,0x81e12c

					int result = sys_get_shared_object(ownerEnvID ,sharedVarName ,(void*)allocblock->startva);
  803406:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803409:	8b 00                	mov    (%eax),%eax
  80340b:	83 ec 04             	sub    $0x4,%esp
  80340e:	50                   	push   %eax
  80340f:	ff 75 0c             	pushl  0xc(%ebp)
  803412:	ff 75 08             	pushl  0x8(%ebp)
  803415:	e8 fd 02 00 00       	call   803717 <sys_get_shared_object>
  80341a:	83 c4 10             	add    $0x10,%esp
  80341d:	89 45 d8             	mov    %eax,-0x28(%ebp)
					if(result <0){
  803420:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  803424:	79 25                	jns    80344b <sget+0x570>
						free_block(allocblock);
  803426:	83 ec 0c             	sub    $0xc,%esp
  803429:	ff 75 e0             	pushl  -0x20(%ebp)
  80342c:	e8 3d 0d 00 00       	call   80416e <free_block>
  803431:	83 c4 10             	add    $0x10,%esp
						release_uspinlock(&ulock);
  803434:	83 ec 0c             	sub    $0xc,%esp
  803437:	68 40 e1 81 00       	push   $0x81e140
  80343c:	e8 51 11 00 00       	call   804592 <release_uspinlock>
  803441:	83 c4 10             	add    $0x10,%esp
						return NULL;
  803444:	b8 00 00 00 00       	mov    $0x0,%eax
  803449:	eb 4d                	jmp    803498 <sget+0x5bd>
					}

					release_uspinlock(&ulock);
  80344b:	83 ec 0c             	sub    $0xc,%esp
  80344e:	68 40 e1 81 00       	push   $0x81e140
  803453:	e8 3a 11 00 00       	call   804592 <release_uspinlock>
  803458:	83 c4 10             	add    $0x10,%esp
					return (void*)allocblock->startva;
  80345b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80345e:	8b 00                	mov    (%eax),%eax
  803460:	eb 36                	jmp    803498 <sget+0x5bd>
				}
				currentfreeelement = currentfreeelement->prev_next_info.le_next;
  803462:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803465:	8b 40 08             	mov    0x8(%eax),%eax
  803468:	89 45 f4             	mov    %eax,-0xc(%ebp)
					 }
		}else{
			//custom fit
			struct UserHeapStruct* currentfreeelement = LIST_FIRST(&u_freelist);
			//worst fit
			while(currentfreeelement != NULL){
  80346b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80346f:	0f 85 4b fc ff ff    	jne    8030c0 <sget+0x1e5>
					return (void*)allocblock->startva;
				}
				currentfreeelement = currentfreeelement->prev_next_info.le_next;
			}
		}
		free_block(allocblock);
  803475:	83 ec 0c             	sub    $0xc,%esp
  803478:	ff 75 e0             	pushl  -0x20(%ebp)
  80347b:	e8 ee 0c 00 00       	call   80416e <free_block>
  803480:	83 c4 10             	add    $0x10,%esp
		release_uspinlock(&ulock);
  803483:	83 ec 0c             	sub    $0xc,%esp
  803486:	68 40 e1 81 00       	push   $0x81e140
  80348b:	e8 02 11 00 00       	call   804592 <release_uspinlock>
  803490:	83 c4 10             	add    $0x10,%esp
		return NULL;
  803493:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803498:	c9                   	leave  
  803499:	c3                   	ret    

0080349a <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  80349a:	55                   	push   %ebp
  80349b:	89 e5                	mov    %esp,%ebp
  80349d:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  8034a0:	e8 cd e6 ff ff       	call   801b72 <uheap_init>
	//==============================================================
	panic("realloc() is not implemented yet...!!");
  8034a5:	83 ec 04             	sub    $0x4,%esp
  8034a8:	68 00 52 80 00       	push   $0x805200
  8034ad:	68 2d 02 00 00       	push   $0x22d
  8034b2:	68 e0 50 80 00       	push   $0x8050e0
  8034b7:	e8 fb d2 ff ff       	call   8007b7 <_panic>

008034bc <sfree>:
//
//	use sys_delete_shared_object(...); which switches to the kernel mode,
//	calls delete_shared_object(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the delete_shared_object() function is empty, make sure to implement it.
void sfree(void* virtual_address)
{
  8034bc:	55                   	push   %ebp
  8034bd:	89 e5                	mov    %esp,%ebp
  8034bf:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.BONUS#5] EXIT #2 - sfree
	//Your code is here
	//Comment the following line
	panic("sfree() is not implemented yet...!!");
  8034c2:	83 ec 04             	sub    $0x4,%esp
  8034c5:	68 28 52 80 00       	push   $0x805228
  8034ca:	68 40 02 00 00       	push   $0x240
  8034cf:	68 e0 50 80 00       	push   $0x8050e0
  8034d4:	e8 de d2 ff ff       	call   8007b7 <_panic>

008034d9 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8034d9:	55                   	push   %ebp
  8034da:	89 e5                	mov    %esp,%ebp
  8034dc:	57                   	push   %edi
  8034dd:	56                   	push   %esi
  8034de:	53                   	push   %ebx
  8034df:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8034e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8034e5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8034e8:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8034eb:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8034ee:	8b 7d 18             	mov    0x18(%ebp),%edi
  8034f1:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8034f4:	cd 30                	int    $0x30
  8034f6:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  8034f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8034fc:	83 c4 10             	add    $0x10,%esp
  8034ff:	5b                   	pop    %ebx
  803500:	5e                   	pop    %esi
  803501:	5f                   	pop    %edi
  803502:	5d                   	pop    %ebp
  803503:	c3                   	ret    

00803504 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  803504:	55                   	push   %ebp
  803505:	89 e5                	mov    %esp,%ebp
  803507:	83 ec 04             	sub    $0x4,%esp
  80350a:	8b 45 10             	mov    0x10(%ebp),%eax
  80350d:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  803510:	8b 4d 14             	mov    0x14(%ebp),%ecx
  803513:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  803517:	8b 45 08             	mov    0x8(%ebp),%eax
  80351a:	6a 00                	push   $0x0
  80351c:	51                   	push   %ecx
  80351d:	52                   	push   %edx
  80351e:	ff 75 0c             	pushl  0xc(%ebp)
  803521:	50                   	push   %eax
  803522:	6a 00                	push   $0x0
  803524:	e8 b0 ff ff ff       	call   8034d9 <syscall>
  803529:	83 c4 18             	add    $0x18,%esp
}
  80352c:	90                   	nop
  80352d:	c9                   	leave  
  80352e:	c3                   	ret    

0080352f <sys_cgetc>:

int
sys_cgetc(void)
{
  80352f:	55                   	push   %ebp
  803530:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  803532:	6a 00                	push   $0x0
  803534:	6a 00                	push   $0x0
  803536:	6a 00                	push   $0x0
  803538:	6a 00                	push   $0x0
  80353a:	6a 00                	push   $0x0
  80353c:	6a 02                	push   $0x2
  80353e:	e8 96 ff ff ff       	call   8034d9 <syscall>
  803543:	83 c4 18             	add    $0x18,%esp
}
  803546:	c9                   	leave  
  803547:	c3                   	ret    

00803548 <sys_lock_cons>:

void sys_lock_cons(void)
{
  803548:	55                   	push   %ebp
  803549:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  80354b:	6a 00                	push   $0x0
  80354d:	6a 00                	push   $0x0
  80354f:	6a 00                	push   $0x0
  803551:	6a 00                	push   $0x0
  803553:	6a 00                	push   $0x0
  803555:	6a 03                	push   $0x3
  803557:	e8 7d ff ff ff       	call   8034d9 <syscall>
  80355c:	83 c4 18             	add    $0x18,%esp
}
  80355f:	90                   	nop
  803560:	c9                   	leave  
  803561:	c3                   	ret    

00803562 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  803562:	55                   	push   %ebp
  803563:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  803565:	6a 00                	push   $0x0
  803567:	6a 00                	push   $0x0
  803569:	6a 00                	push   $0x0
  80356b:	6a 00                	push   $0x0
  80356d:	6a 00                	push   $0x0
  80356f:	6a 04                	push   $0x4
  803571:	e8 63 ff ff ff       	call   8034d9 <syscall>
  803576:	83 c4 18             	add    $0x18,%esp
}
  803579:	90                   	nop
  80357a:	c9                   	leave  
  80357b:	c3                   	ret    

0080357c <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  80357c:	55                   	push   %ebp
  80357d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  80357f:	8b 55 0c             	mov    0xc(%ebp),%edx
  803582:	8b 45 08             	mov    0x8(%ebp),%eax
  803585:	6a 00                	push   $0x0
  803587:	6a 00                	push   $0x0
  803589:	6a 00                	push   $0x0
  80358b:	52                   	push   %edx
  80358c:	50                   	push   %eax
  80358d:	6a 08                	push   $0x8
  80358f:	e8 45 ff ff ff       	call   8034d9 <syscall>
  803594:	83 c4 18             	add    $0x18,%esp
}
  803597:	c9                   	leave  
  803598:	c3                   	ret    

00803599 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  803599:	55                   	push   %ebp
  80359a:	89 e5                	mov    %esp,%ebp
  80359c:	56                   	push   %esi
  80359d:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  80359e:	8b 75 18             	mov    0x18(%ebp),%esi
  8035a1:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8035a4:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8035a7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8035aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8035ad:	56                   	push   %esi
  8035ae:	53                   	push   %ebx
  8035af:	51                   	push   %ecx
  8035b0:	52                   	push   %edx
  8035b1:	50                   	push   %eax
  8035b2:	6a 09                	push   $0x9
  8035b4:	e8 20 ff ff ff       	call   8034d9 <syscall>
  8035b9:	83 c4 18             	add    $0x18,%esp
}
  8035bc:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8035bf:	5b                   	pop    %ebx
  8035c0:	5e                   	pop    %esi
  8035c1:	5d                   	pop    %ebp
  8035c2:	c3                   	ret    

008035c3 <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  8035c3:	55                   	push   %ebp
  8035c4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  8035c6:	6a 00                	push   $0x0
  8035c8:	6a 00                	push   $0x0
  8035ca:	6a 00                	push   $0x0
  8035cc:	6a 00                	push   $0x0
  8035ce:	ff 75 08             	pushl  0x8(%ebp)
  8035d1:	6a 0a                	push   $0xa
  8035d3:	e8 01 ff ff ff       	call   8034d9 <syscall>
  8035d8:	83 c4 18             	add    $0x18,%esp
}
  8035db:	c9                   	leave  
  8035dc:	c3                   	ret    

008035dd <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8035dd:	55                   	push   %ebp
  8035de:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8035e0:	6a 00                	push   $0x0
  8035e2:	6a 00                	push   $0x0
  8035e4:	6a 00                	push   $0x0
  8035e6:	ff 75 0c             	pushl  0xc(%ebp)
  8035e9:	ff 75 08             	pushl  0x8(%ebp)
  8035ec:	6a 0b                	push   $0xb
  8035ee:	e8 e6 fe ff ff       	call   8034d9 <syscall>
  8035f3:	83 c4 18             	add    $0x18,%esp
}
  8035f6:	c9                   	leave  
  8035f7:	c3                   	ret    

008035f8 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8035f8:	55                   	push   %ebp
  8035f9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8035fb:	6a 00                	push   $0x0
  8035fd:	6a 00                	push   $0x0
  8035ff:	6a 00                	push   $0x0
  803601:	6a 00                	push   $0x0
  803603:	6a 00                	push   $0x0
  803605:	6a 0c                	push   $0xc
  803607:	e8 cd fe ff ff       	call   8034d9 <syscall>
  80360c:	83 c4 18             	add    $0x18,%esp
}
  80360f:	c9                   	leave  
  803610:	c3                   	ret    

00803611 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  803611:	55                   	push   %ebp
  803612:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  803614:	6a 00                	push   $0x0
  803616:	6a 00                	push   $0x0
  803618:	6a 00                	push   $0x0
  80361a:	6a 00                	push   $0x0
  80361c:	6a 00                	push   $0x0
  80361e:	6a 0d                	push   $0xd
  803620:	e8 b4 fe ff ff       	call   8034d9 <syscall>
  803625:	83 c4 18             	add    $0x18,%esp
}
  803628:	c9                   	leave  
  803629:	c3                   	ret    

0080362a <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  80362a:	55                   	push   %ebp
  80362b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  80362d:	6a 00                	push   $0x0
  80362f:	6a 00                	push   $0x0
  803631:	6a 00                	push   $0x0
  803633:	6a 00                	push   $0x0
  803635:	6a 00                	push   $0x0
  803637:	6a 0e                	push   $0xe
  803639:	e8 9b fe ff ff       	call   8034d9 <syscall>
  80363e:	83 c4 18             	add    $0x18,%esp
}
  803641:	c9                   	leave  
  803642:	c3                   	ret    

00803643 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  803643:	55                   	push   %ebp
  803644:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  803646:	6a 00                	push   $0x0
  803648:	6a 00                	push   $0x0
  80364a:	6a 00                	push   $0x0
  80364c:	6a 00                	push   $0x0
  80364e:	6a 00                	push   $0x0
  803650:	6a 0f                	push   $0xf
  803652:	e8 82 fe ff ff       	call   8034d9 <syscall>
  803657:	83 c4 18             	add    $0x18,%esp
}
  80365a:	c9                   	leave  
  80365b:	c3                   	ret    

0080365c <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  80365c:	55                   	push   %ebp
  80365d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  80365f:	6a 00                	push   $0x0
  803661:	6a 00                	push   $0x0
  803663:	6a 00                	push   $0x0
  803665:	6a 00                	push   $0x0
  803667:	ff 75 08             	pushl  0x8(%ebp)
  80366a:	6a 10                	push   $0x10
  80366c:	e8 68 fe ff ff       	call   8034d9 <syscall>
  803671:	83 c4 18             	add    $0x18,%esp
}
  803674:	c9                   	leave  
  803675:	c3                   	ret    

00803676 <sys_scarce_memory>:

void sys_scarce_memory()
{
  803676:	55                   	push   %ebp
  803677:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  803679:	6a 00                	push   $0x0
  80367b:	6a 00                	push   $0x0
  80367d:	6a 00                	push   $0x0
  80367f:	6a 00                	push   $0x0
  803681:	6a 00                	push   $0x0
  803683:	6a 11                	push   $0x11
  803685:	e8 4f fe ff ff       	call   8034d9 <syscall>
  80368a:	83 c4 18             	add    $0x18,%esp
}
  80368d:	90                   	nop
  80368e:	c9                   	leave  
  80368f:	c3                   	ret    

00803690 <sys_cputc>:

void
sys_cputc(const char c)
{
  803690:	55                   	push   %ebp
  803691:	89 e5                	mov    %esp,%ebp
  803693:	83 ec 04             	sub    $0x4,%esp
  803696:	8b 45 08             	mov    0x8(%ebp),%eax
  803699:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  80369c:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8036a0:	6a 00                	push   $0x0
  8036a2:	6a 00                	push   $0x0
  8036a4:	6a 00                	push   $0x0
  8036a6:	6a 00                	push   $0x0
  8036a8:	50                   	push   %eax
  8036a9:	6a 01                	push   $0x1
  8036ab:	e8 29 fe ff ff       	call   8034d9 <syscall>
  8036b0:	83 c4 18             	add    $0x18,%esp
}
  8036b3:	90                   	nop
  8036b4:	c9                   	leave  
  8036b5:	c3                   	ret    

008036b6 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8036b6:	55                   	push   %ebp
  8036b7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8036b9:	6a 00                	push   $0x0
  8036bb:	6a 00                	push   $0x0
  8036bd:	6a 00                	push   $0x0
  8036bf:	6a 00                	push   $0x0
  8036c1:	6a 00                	push   $0x0
  8036c3:	6a 14                	push   $0x14
  8036c5:	e8 0f fe ff ff       	call   8034d9 <syscall>
  8036ca:	83 c4 18             	add    $0x18,%esp
}
  8036cd:	90                   	nop
  8036ce:	c9                   	leave  
  8036cf:	c3                   	ret    

008036d0 <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8036d0:	55                   	push   %ebp
  8036d1:	89 e5                	mov    %esp,%ebp
  8036d3:	83 ec 04             	sub    $0x4,%esp
  8036d6:	8b 45 10             	mov    0x10(%ebp),%eax
  8036d9:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8036dc:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8036df:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8036e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8036e6:	6a 00                	push   $0x0
  8036e8:	51                   	push   %ecx
  8036e9:	52                   	push   %edx
  8036ea:	ff 75 0c             	pushl  0xc(%ebp)
  8036ed:	50                   	push   %eax
  8036ee:	6a 15                	push   $0x15
  8036f0:	e8 e4 fd ff ff       	call   8034d9 <syscall>
  8036f5:	83 c4 18             	add    $0x18,%esp
}
  8036f8:	c9                   	leave  
  8036f9:	c3                   	ret    

008036fa <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  8036fa:	55                   	push   %ebp
  8036fb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8036fd:	8b 55 0c             	mov    0xc(%ebp),%edx
  803700:	8b 45 08             	mov    0x8(%ebp),%eax
  803703:	6a 00                	push   $0x0
  803705:	6a 00                	push   $0x0
  803707:	6a 00                	push   $0x0
  803709:	52                   	push   %edx
  80370a:	50                   	push   %eax
  80370b:	6a 16                	push   $0x16
  80370d:	e8 c7 fd ff ff       	call   8034d9 <syscall>
  803712:	83 c4 18             	add    $0x18,%esp
}
  803715:	c9                   	leave  
  803716:	c3                   	ret    

00803717 <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  803717:	55                   	push   %ebp
  803718:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  80371a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80371d:	8b 55 0c             	mov    0xc(%ebp),%edx
  803720:	8b 45 08             	mov    0x8(%ebp),%eax
  803723:	6a 00                	push   $0x0
  803725:	6a 00                	push   $0x0
  803727:	51                   	push   %ecx
  803728:	52                   	push   %edx
  803729:	50                   	push   %eax
  80372a:	6a 17                	push   $0x17
  80372c:	e8 a8 fd ff ff       	call   8034d9 <syscall>
  803731:	83 c4 18             	add    $0x18,%esp
}
  803734:	c9                   	leave  
  803735:	c3                   	ret    

00803736 <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  803736:	55                   	push   %ebp
  803737:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  803739:	8b 55 0c             	mov    0xc(%ebp),%edx
  80373c:	8b 45 08             	mov    0x8(%ebp),%eax
  80373f:	6a 00                	push   $0x0
  803741:	6a 00                	push   $0x0
  803743:	6a 00                	push   $0x0
  803745:	52                   	push   %edx
  803746:	50                   	push   %eax
  803747:	6a 18                	push   $0x18
  803749:	e8 8b fd ff ff       	call   8034d9 <syscall>
  80374e:	83 c4 18             	add    $0x18,%esp
}
  803751:	c9                   	leave  
  803752:	c3                   	ret    

00803753 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  803753:	55                   	push   %ebp
  803754:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  803756:	8b 45 08             	mov    0x8(%ebp),%eax
  803759:	6a 00                	push   $0x0
  80375b:	ff 75 14             	pushl  0x14(%ebp)
  80375e:	ff 75 10             	pushl  0x10(%ebp)
  803761:	ff 75 0c             	pushl  0xc(%ebp)
  803764:	50                   	push   %eax
  803765:	6a 19                	push   $0x19
  803767:	e8 6d fd ff ff       	call   8034d9 <syscall>
  80376c:	83 c4 18             	add    $0x18,%esp
}
  80376f:	c9                   	leave  
  803770:	c3                   	ret    

00803771 <sys_run_env>:

void sys_run_env(int32 envId)
{
  803771:	55                   	push   %ebp
  803772:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  803774:	8b 45 08             	mov    0x8(%ebp),%eax
  803777:	6a 00                	push   $0x0
  803779:	6a 00                	push   $0x0
  80377b:	6a 00                	push   $0x0
  80377d:	6a 00                	push   $0x0
  80377f:	50                   	push   %eax
  803780:	6a 1a                	push   $0x1a
  803782:	e8 52 fd ff ff       	call   8034d9 <syscall>
  803787:	83 c4 18             	add    $0x18,%esp
}
  80378a:	90                   	nop
  80378b:	c9                   	leave  
  80378c:	c3                   	ret    

0080378d <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  80378d:	55                   	push   %ebp
  80378e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  803790:	8b 45 08             	mov    0x8(%ebp),%eax
  803793:	6a 00                	push   $0x0
  803795:	6a 00                	push   $0x0
  803797:	6a 00                	push   $0x0
  803799:	6a 00                	push   $0x0
  80379b:	50                   	push   %eax
  80379c:	6a 1b                	push   $0x1b
  80379e:	e8 36 fd ff ff       	call   8034d9 <syscall>
  8037a3:	83 c4 18             	add    $0x18,%esp
}
  8037a6:	c9                   	leave  
  8037a7:	c3                   	ret    

008037a8 <sys_getenvid>:

int32 sys_getenvid(void)
{
  8037a8:	55                   	push   %ebp
  8037a9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8037ab:	6a 00                	push   $0x0
  8037ad:	6a 00                	push   $0x0
  8037af:	6a 00                	push   $0x0
  8037b1:	6a 00                	push   $0x0
  8037b3:	6a 00                	push   $0x0
  8037b5:	6a 05                	push   $0x5
  8037b7:	e8 1d fd ff ff       	call   8034d9 <syscall>
  8037bc:	83 c4 18             	add    $0x18,%esp
}
  8037bf:	c9                   	leave  
  8037c0:	c3                   	ret    

008037c1 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8037c1:	55                   	push   %ebp
  8037c2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8037c4:	6a 00                	push   $0x0
  8037c6:	6a 00                	push   $0x0
  8037c8:	6a 00                	push   $0x0
  8037ca:	6a 00                	push   $0x0
  8037cc:	6a 00                	push   $0x0
  8037ce:	6a 06                	push   $0x6
  8037d0:	e8 04 fd ff ff       	call   8034d9 <syscall>
  8037d5:	83 c4 18             	add    $0x18,%esp
}
  8037d8:	c9                   	leave  
  8037d9:	c3                   	ret    

008037da <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8037da:	55                   	push   %ebp
  8037db:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8037dd:	6a 00                	push   $0x0
  8037df:	6a 00                	push   $0x0
  8037e1:	6a 00                	push   $0x0
  8037e3:	6a 00                	push   $0x0
  8037e5:	6a 00                	push   $0x0
  8037e7:	6a 07                	push   $0x7
  8037e9:	e8 eb fc ff ff       	call   8034d9 <syscall>
  8037ee:	83 c4 18             	add    $0x18,%esp
}
  8037f1:	c9                   	leave  
  8037f2:	c3                   	ret    

008037f3 <sys_exit_env>:


void sys_exit_env(void)
{
  8037f3:	55                   	push   %ebp
  8037f4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  8037f6:	6a 00                	push   $0x0
  8037f8:	6a 00                	push   $0x0
  8037fa:	6a 00                	push   $0x0
  8037fc:	6a 00                	push   $0x0
  8037fe:	6a 00                	push   $0x0
  803800:	6a 1c                	push   $0x1c
  803802:	e8 d2 fc ff ff       	call   8034d9 <syscall>
  803807:	83 c4 18             	add    $0x18,%esp
}
  80380a:	90                   	nop
  80380b:	c9                   	leave  
  80380c:	c3                   	ret    

0080380d <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  80380d:	55                   	push   %ebp
  80380e:	89 e5                	mov    %esp,%ebp
  803810:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  803813:	8d 45 f8             	lea    -0x8(%ebp),%eax
  803816:	8d 50 04             	lea    0x4(%eax),%edx
  803819:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80381c:	6a 00                	push   $0x0
  80381e:	6a 00                	push   $0x0
  803820:	6a 00                	push   $0x0
  803822:	52                   	push   %edx
  803823:	50                   	push   %eax
  803824:	6a 1d                	push   $0x1d
  803826:	e8 ae fc ff ff       	call   8034d9 <syscall>
  80382b:	83 c4 18             	add    $0x18,%esp
	return result;
  80382e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  803831:	8b 45 f8             	mov    -0x8(%ebp),%eax
  803834:	8b 55 fc             	mov    -0x4(%ebp),%edx
  803837:	89 01                	mov    %eax,(%ecx)
  803839:	89 51 04             	mov    %edx,0x4(%ecx)
}
  80383c:	8b 45 08             	mov    0x8(%ebp),%eax
  80383f:	c9                   	leave  
  803840:	c2 04 00             	ret    $0x4

00803843 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  803843:	55                   	push   %ebp
  803844:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  803846:	6a 00                	push   $0x0
  803848:	6a 00                	push   $0x0
  80384a:	ff 75 10             	pushl  0x10(%ebp)
  80384d:	ff 75 0c             	pushl  0xc(%ebp)
  803850:	ff 75 08             	pushl  0x8(%ebp)
  803853:	6a 13                	push   $0x13
  803855:	e8 7f fc ff ff       	call   8034d9 <syscall>
  80385a:	83 c4 18             	add    $0x18,%esp
	return ;
  80385d:	90                   	nop
}
  80385e:	c9                   	leave  
  80385f:	c3                   	ret    

00803860 <sys_rcr2>:
uint32 sys_rcr2()
{
  803860:	55                   	push   %ebp
  803861:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  803863:	6a 00                	push   $0x0
  803865:	6a 00                	push   $0x0
  803867:	6a 00                	push   $0x0
  803869:	6a 00                	push   $0x0
  80386b:	6a 00                	push   $0x0
  80386d:	6a 1e                	push   $0x1e
  80386f:	e8 65 fc ff ff       	call   8034d9 <syscall>
  803874:	83 c4 18             	add    $0x18,%esp
}
  803877:	c9                   	leave  
  803878:	c3                   	ret    

00803879 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  803879:	55                   	push   %ebp
  80387a:	89 e5                	mov    %esp,%ebp
  80387c:	83 ec 04             	sub    $0x4,%esp
  80387f:	8b 45 08             	mov    0x8(%ebp),%eax
  803882:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  803885:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  803889:	6a 00                	push   $0x0
  80388b:	6a 00                	push   $0x0
  80388d:	6a 00                	push   $0x0
  80388f:	6a 00                	push   $0x0
  803891:	50                   	push   %eax
  803892:	6a 1f                	push   $0x1f
  803894:	e8 40 fc ff ff       	call   8034d9 <syscall>
  803899:	83 c4 18             	add    $0x18,%esp
	return ;
  80389c:	90                   	nop
}
  80389d:	c9                   	leave  
  80389e:	c3                   	ret    

0080389f <rsttst>:
void rsttst()
{
  80389f:	55                   	push   %ebp
  8038a0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8038a2:	6a 00                	push   $0x0
  8038a4:	6a 00                	push   $0x0
  8038a6:	6a 00                	push   $0x0
  8038a8:	6a 00                	push   $0x0
  8038aa:	6a 00                	push   $0x0
  8038ac:	6a 21                	push   $0x21
  8038ae:	e8 26 fc ff ff       	call   8034d9 <syscall>
  8038b3:	83 c4 18             	add    $0x18,%esp
	return ;
  8038b6:	90                   	nop
}
  8038b7:	c9                   	leave  
  8038b8:	c3                   	ret    

008038b9 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8038b9:	55                   	push   %ebp
  8038ba:	89 e5                	mov    %esp,%ebp
  8038bc:	83 ec 04             	sub    $0x4,%esp
  8038bf:	8b 45 14             	mov    0x14(%ebp),%eax
  8038c2:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8038c5:	8b 55 18             	mov    0x18(%ebp),%edx
  8038c8:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8038cc:	52                   	push   %edx
  8038cd:	50                   	push   %eax
  8038ce:	ff 75 10             	pushl  0x10(%ebp)
  8038d1:	ff 75 0c             	pushl  0xc(%ebp)
  8038d4:	ff 75 08             	pushl  0x8(%ebp)
  8038d7:	6a 20                	push   $0x20
  8038d9:	e8 fb fb ff ff       	call   8034d9 <syscall>
  8038de:	83 c4 18             	add    $0x18,%esp
	return ;
  8038e1:	90                   	nop
}
  8038e2:	c9                   	leave  
  8038e3:	c3                   	ret    

008038e4 <chktst>:
void chktst(uint32 n)
{
  8038e4:	55                   	push   %ebp
  8038e5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8038e7:	6a 00                	push   $0x0
  8038e9:	6a 00                	push   $0x0
  8038eb:	6a 00                	push   $0x0
  8038ed:	6a 00                	push   $0x0
  8038ef:	ff 75 08             	pushl  0x8(%ebp)
  8038f2:	6a 22                	push   $0x22
  8038f4:	e8 e0 fb ff ff       	call   8034d9 <syscall>
  8038f9:	83 c4 18             	add    $0x18,%esp
	return ;
  8038fc:	90                   	nop
}
  8038fd:	c9                   	leave  
  8038fe:	c3                   	ret    

008038ff <inctst>:

void inctst()
{
  8038ff:	55                   	push   %ebp
  803900:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  803902:	6a 00                	push   $0x0
  803904:	6a 00                	push   $0x0
  803906:	6a 00                	push   $0x0
  803908:	6a 00                	push   $0x0
  80390a:	6a 00                	push   $0x0
  80390c:	6a 23                	push   $0x23
  80390e:	e8 c6 fb ff ff       	call   8034d9 <syscall>
  803913:	83 c4 18             	add    $0x18,%esp
	return ;
  803916:	90                   	nop
}
  803917:	c9                   	leave  
  803918:	c3                   	ret    

00803919 <gettst>:
uint32 gettst()
{
  803919:	55                   	push   %ebp
  80391a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  80391c:	6a 00                	push   $0x0
  80391e:	6a 00                	push   $0x0
  803920:	6a 00                	push   $0x0
  803922:	6a 00                	push   $0x0
  803924:	6a 00                	push   $0x0
  803926:	6a 24                	push   $0x24
  803928:	e8 ac fb ff ff       	call   8034d9 <syscall>
  80392d:	83 c4 18             	add    $0x18,%esp
}
  803930:	c9                   	leave  
  803931:	c3                   	ret    

00803932 <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  803932:	55                   	push   %ebp
  803933:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  803935:	6a 00                	push   $0x0
  803937:	6a 00                	push   $0x0
  803939:	6a 00                	push   $0x0
  80393b:	6a 00                	push   $0x0
  80393d:	6a 00                	push   $0x0
  80393f:	6a 25                	push   $0x25
  803941:	e8 93 fb ff ff       	call   8034d9 <syscall>
  803946:	83 c4 18             	add    $0x18,%esp
  803949:	a3 60 e0 81 00       	mov    %eax,0x81e060
	return uheapPlaceStrategy ;
  80394e:	a1 60 e0 81 00       	mov    0x81e060,%eax
}
  803953:	c9                   	leave  
  803954:	c3                   	ret    

00803955 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  803955:	55                   	push   %ebp
  803956:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  803958:	8b 45 08             	mov    0x8(%ebp),%eax
  80395b:	a3 60 e0 81 00       	mov    %eax,0x81e060
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  803960:	6a 00                	push   $0x0
  803962:	6a 00                	push   $0x0
  803964:	6a 00                	push   $0x0
  803966:	6a 00                	push   $0x0
  803968:	ff 75 08             	pushl  0x8(%ebp)
  80396b:	6a 26                	push   $0x26
  80396d:	e8 67 fb ff ff       	call   8034d9 <syscall>
  803972:	83 c4 18             	add    $0x18,%esp
	return ;
  803975:	90                   	nop
}
  803976:	c9                   	leave  
  803977:	c3                   	ret    

00803978 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  803978:	55                   	push   %ebp
  803979:	89 e5                	mov    %esp,%ebp
  80397b:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  80397c:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80397f:	8b 4d 10             	mov    0x10(%ebp),%ecx
  803982:	8b 55 0c             	mov    0xc(%ebp),%edx
  803985:	8b 45 08             	mov    0x8(%ebp),%eax
  803988:	6a 00                	push   $0x0
  80398a:	53                   	push   %ebx
  80398b:	51                   	push   %ecx
  80398c:	52                   	push   %edx
  80398d:	50                   	push   %eax
  80398e:	6a 27                	push   $0x27
  803990:	e8 44 fb ff ff       	call   8034d9 <syscall>
  803995:	83 c4 18             	add    $0x18,%esp
}
  803998:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80399b:	c9                   	leave  
  80399c:	c3                   	ret    

0080399d <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  80399d:	55                   	push   %ebp
  80399e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  8039a0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8039a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8039a6:	6a 00                	push   $0x0
  8039a8:	6a 00                	push   $0x0
  8039aa:	6a 00                	push   $0x0
  8039ac:	52                   	push   %edx
  8039ad:	50                   	push   %eax
  8039ae:	6a 28                	push   $0x28
  8039b0:	e8 24 fb ff ff       	call   8034d9 <syscall>
  8039b5:	83 c4 18             	add    $0x18,%esp
}
  8039b8:	c9                   	leave  
  8039b9:	c3                   	ret    

008039ba <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  8039ba:	55                   	push   %ebp
  8039bb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  8039bd:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8039c0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8039c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8039c6:	6a 00                	push   $0x0
  8039c8:	51                   	push   %ecx
  8039c9:	ff 75 10             	pushl  0x10(%ebp)
  8039cc:	52                   	push   %edx
  8039cd:	50                   	push   %eax
  8039ce:	6a 29                	push   $0x29
  8039d0:	e8 04 fb ff ff       	call   8034d9 <syscall>
  8039d5:	83 c4 18             	add    $0x18,%esp
}
  8039d8:	c9                   	leave  
  8039d9:	c3                   	ret    

008039da <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8039da:	55                   	push   %ebp
  8039db:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8039dd:	6a 00                	push   $0x0
  8039df:	6a 00                	push   $0x0
  8039e1:	ff 75 10             	pushl  0x10(%ebp)
  8039e4:	ff 75 0c             	pushl  0xc(%ebp)
  8039e7:	ff 75 08             	pushl  0x8(%ebp)
  8039ea:	6a 12                	push   $0x12
  8039ec:	e8 e8 fa ff ff       	call   8034d9 <syscall>
  8039f1:	83 c4 18             	add    $0x18,%esp
	return ;
  8039f4:	90                   	nop
}
  8039f5:	c9                   	leave  
  8039f6:	c3                   	ret    

008039f7 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  8039f7:	55                   	push   %ebp
  8039f8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  8039fa:	8b 55 0c             	mov    0xc(%ebp),%edx
  8039fd:	8b 45 08             	mov    0x8(%ebp),%eax
  803a00:	6a 00                	push   $0x0
  803a02:	6a 00                	push   $0x0
  803a04:	6a 00                	push   $0x0
  803a06:	52                   	push   %edx
  803a07:	50                   	push   %eax
  803a08:	6a 2a                	push   $0x2a
  803a0a:	e8 ca fa ff ff       	call   8034d9 <syscall>
  803a0f:	83 c4 18             	add    $0x18,%esp
	return;
  803a12:	90                   	nop
}
  803a13:	c9                   	leave  
  803a14:	c3                   	ret    

00803a15 <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  803a15:	55                   	push   %ebp
  803a16:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  803a18:	6a 00                	push   $0x0
  803a1a:	6a 00                	push   $0x0
  803a1c:	6a 00                	push   $0x0
  803a1e:	6a 00                	push   $0x0
  803a20:	6a 00                	push   $0x0
  803a22:	6a 2b                	push   $0x2b
  803a24:	e8 b0 fa ff ff       	call   8034d9 <syscall>
  803a29:	83 c4 18             	add    $0x18,%esp
}
  803a2c:	c9                   	leave  
  803a2d:	c3                   	ret    

00803a2e <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  803a2e:	55                   	push   %ebp
  803a2f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  803a31:	6a 00                	push   $0x0
  803a33:	6a 00                	push   $0x0
  803a35:	6a 00                	push   $0x0
  803a37:	ff 75 0c             	pushl  0xc(%ebp)
  803a3a:	ff 75 08             	pushl  0x8(%ebp)
  803a3d:	6a 2d                	push   $0x2d
  803a3f:	e8 95 fa ff ff       	call   8034d9 <syscall>
  803a44:	83 c4 18             	add    $0x18,%esp
	return;
  803a47:	90                   	nop
}
  803a48:	c9                   	leave  
  803a49:	c3                   	ret    

00803a4a <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  803a4a:	55                   	push   %ebp
  803a4b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  803a4d:	6a 00                	push   $0x0
  803a4f:	6a 00                	push   $0x0
  803a51:	6a 00                	push   $0x0
  803a53:	ff 75 0c             	pushl  0xc(%ebp)
  803a56:	ff 75 08             	pushl  0x8(%ebp)
  803a59:	6a 2c                	push   $0x2c
  803a5b:	e8 79 fa ff ff       	call   8034d9 <syscall>
  803a60:	83 c4 18             	add    $0x18,%esp
	return ;
  803a63:	90                   	nop
}
  803a64:	c9                   	leave  
  803a65:	c3                   	ret    

00803a66 <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  803a66:	55                   	push   %ebp
  803a67:	89 e5                	mov    %esp,%ebp
	//TODO: [PROJECT'25.IM#4] CPU SCHEDULING - #1 System Calls - Add suitable code here
	//Your code is here
	//Comment the following line
	//panic("sys_env_set_priority() is not implemented yet...!!");
	syscall(SYS_env_set_priority, envID, priority, 0, 0, 0);
  803a69:	8b 55 0c             	mov    0xc(%ebp),%edx
  803a6c:	8b 45 08             	mov    0x8(%ebp),%eax
  803a6f:	6a 00                	push   $0x0
  803a71:	6a 00                	push   $0x0
  803a73:	6a 00                	push   $0x0
  803a75:	52                   	push   %edx
  803a76:	50                   	push   %eax
  803a77:	6a 2e                	push   $0x2e
  803a79:	e8 5b fa ff ff       	call   8034d9 <syscall>
  803a7e:	83 c4 18             	add    $0x18,%esp
	    return;
  803a81:	90                   	nop
}
  803a82:	c9                   	leave  
  803a83:	c3                   	ret    

00803a84 <to_page_va>:
//==================================================================================//
//==================================
// [1] GET PAGE VA:
//==================================
__inline__ uint32 to_page_va(struct PageInfoElement *ptrPageInfo)
{
  803a84:	55                   	push   %ebp
  803a85:	89 e5                	mov    %esp,%ebp
  803a87:	83 ec 10             	sub    $0x10,%esp
	//Get start VA of the page from the corresponding Page Info pointer
	int idxInPageInfoArr = (ptrPageInfo - pageBlockInfoArr);
  803a8a:	8b 45 08             	mov    0x8(%ebp),%eax
  803a8d:	ba 60 60 80 00       	mov    $0x806060,%edx
  803a92:	29 d0                	sub    %edx,%eax
  803a94:	c1 f8 02             	sar    $0x2,%eax
  803a97:	89 c2                	mov    %eax,%edx
  803a99:	89 d0                	mov    %edx,%eax
  803a9b:	c1 e0 02             	shl    $0x2,%eax
  803a9e:	01 d0                	add    %edx,%eax
  803aa0:	c1 e0 02             	shl    $0x2,%eax
  803aa3:	01 d0                	add    %edx,%eax
  803aa5:	c1 e0 02             	shl    $0x2,%eax
  803aa8:	01 d0                	add    %edx,%eax
  803aaa:	89 c1                	mov    %eax,%ecx
  803aac:	c1 e1 08             	shl    $0x8,%ecx
  803aaf:	01 c8                	add    %ecx,%eax
  803ab1:	89 c1                	mov    %eax,%ecx
  803ab3:	c1 e1 10             	shl    $0x10,%ecx
  803ab6:	01 c8                	add    %ecx,%eax
  803ab8:	01 c0                	add    %eax,%eax
  803aba:	01 d0                	add    %edx,%eax
  803abc:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return dynAllocStart + (idxInPageInfoArr << PGSHIFT);
  803abf:	8b 45 fc             	mov    -0x4(%ebp),%eax
  803ac2:	c1 e0 0c             	shl    $0xc,%eax
  803ac5:	89 c2                	mov    %eax,%edx
  803ac7:	a1 64 e0 81 00       	mov    0x81e064,%eax
  803acc:	01 d0                	add    %edx,%eax
}
  803ace:	c9                   	leave  
  803acf:	c3                   	ret    

00803ad0 <log2>:

//==================================================================================//
//============================ REQUIRED FUNCTIONS ==================================//
//==================================================================================//
__inline__ int log2(uint32 n)
	{
  803ad0:	55                   	push   %ebp
  803ad1:	89 e5                	mov    %esp,%ebp
  803ad3:	83 ec 10             	sub    $0x10,%esp
		int result = 0;
  803ad6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
		while( n > 1){
  803add:	eb 06                	jmp    803ae5 <log2+0x15>
			n >>=1;
  803adf:	d1 6d 08             	shrl   0x8(%ebp)
			result++;
  803ae2:	ff 45 fc             	incl   -0x4(%ebp)
//============================ REQUIRED FUNCTIONS ==================================//
//==================================================================================//
__inline__ int log2(uint32 n)
	{
		int result = 0;
		while( n > 1){
  803ae5:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
  803ae9:	77 f4                	ja     803adf <log2+0xf>
			n >>=1;
			result++;
		}
		return result;
  803aeb:	8b 45 fc             	mov    -0x4(%ebp),%eax
	}
  803aee:	c9                   	leave  
  803aef:	c3                   	ret    

00803af0 <initialize_dynamic_allocator>:
//==================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================
bool is_initialized = 0;
void initialize_dynamic_allocator(uint32 daStart, uint32 daEnd)
{
  803af0:	55                   	push   %ebp
  803af1:	89 e5                	mov    %esp,%ebp
  803af3:	83 ec 18             	sub    $0x18,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(daEnd <= daStart + DYN_ALLOC_MAX_SIZE);
  803af6:	8b 45 08             	mov    0x8(%ebp),%eax
  803af9:	05 00 00 00 02       	add    $0x2000000,%eax
  803afe:	3b 45 0c             	cmp    0xc(%ebp),%eax
  803b01:	73 16                	jae    803b19 <initialize_dynamic_allocator+0x29>
  803b03:	68 4c 52 80 00       	push   $0x80524c
  803b08:	68 72 52 80 00       	push   $0x805272
  803b0d:	6a 2d                	push   $0x2d
  803b0f:	68 87 52 80 00       	push   $0x805287
  803b14:	e8 9e cc ff ff       	call   8007b7 <_panic>
		is_initialized = 1;
  803b19:	c7 05 28 60 80 00 01 	movl   $0x1,0x806028
  803b20:	00 00 00 
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #1 initialize_dynamic_allocator
	//Your code is here


	dynAllocStart = daStart;
  803b23:	8b 45 08             	mov    0x8(%ebp),%eax
  803b26:	a3 64 e0 81 00       	mov    %eax,0x81e064
	dynAllocEnd= daEnd;
  803b2b:	8b 45 0c             	mov    0xc(%ebp),%eax
  803b2e:	a3 40 60 80 00       	mov    %eax,0x806040
	int numOfPages = (dynAllocEnd - dynAllocStart)/PAGE_SIZE;
  803b33:	8b 15 40 60 80 00    	mov    0x806040,%edx
  803b39:	a1 64 e0 81 00       	mov    0x81e064,%eax
  803b3e:	29 c2                	sub    %eax,%edx
  803b40:	89 d0                	mov    %edx,%eax
  803b42:	c1 e8 0c             	shr    $0xc,%eax
  803b45:	89 45 e8             	mov    %eax,-0x18(%ebp)


	for(int i=0; i< numOfPages; i++){
  803b48:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  803b4f:	eb 2f                	jmp    803b80 <initialize_dynamic_allocator+0x90>
	    pageBlockInfoArr[i].block_size=0;
  803b51:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803b54:	89 d0                	mov    %edx,%eax
  803b56:	01 c0                	add    %eax,%eax
  803b58:	01 d0                	add    %edx,%eax
  803b5a:	c1 e0 02             	shl    $0x2,%eax
  803b5d:	05 68 60 80 00       	add    $0x806068,%eax
  803b62:	66 c7 00 00 00       	movw   $0x0,(%eax)
	    pageBlockInfoArr[i].num_of_free_blocks=0;
  803b67:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803b6a:	89 d0                	mov    %edx,%eax
  803b6c:	01 c0                	add    %eax,%eax
  803b6e:	01 d0                	add    %edx,%eax
  803b70:	c1 e0 02             	shl    $0x2,%eax
  803b73:	05 6a 60 80 00       	add    $0x80606a,%eax
  803b78:	66 c7 00 00 00       	movw   $0x0,(%eax)
	dynAllocStart = daStart;
	dynAllocEnd= daEnd;
	int numOfPages = (dynAllocEnd - dynAllocStart)/PAGE_SIZE;


	for(int i=0; i< numOfPages; i++){
  803b7d:	ff 45 f4             	incl   -0xc(%ebp)
  803b80:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b83:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803b86:	7c c9                	jl     803b51 <initialize_dynamic_allocator+0x61>
	    pageBlockInfoArr[i].block_size=0;
	    pageBlockInfoArr[i].num_of_free_blocks=0;
	}


	LIST_INIT(&freePagesList);
  803b88:	c7 05 48 60 80 00 00 	movl   $0x0,0x806048
  803b8f:	00 00 00 
  803b92:	c7 05 4c 60 80 00 00 	movl   $0x0,0x80604c
  803b99:	00 00 00 
  803b9c:	c7 05 54 60 80 00 00 	movl   $0x0,0x806054
  803ba3:	00 00 00 
	for(int i=0; i<numOfPages; i++){
  803ba6:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  803bad:	e9 9c 00 00 00       	jmp    803c4e <initialize_dynamic_allocator+0x15e>
		LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
  803bb2:	8b 15 4c 60 80 00    	mov    0x80604c,%edx
  803bb8:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  803bbb:	89 c8                	mov    %ecx,%eax
  803bbd:	01 c0                	add    %eax,%eax
  803bbf:	01 c8                	add    %ecx,%eax
  803bc1:	c1 e0 02             	shl    $0x2,%eax
  803bc4:	05 64 60 80 00       	add    $0x806064,%eax
  803bc9:	89 10                	mov    %edx,(%eax)
  803bcb:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803bce:	89 d0                	mov    %edx,%eax
  803bd0:	01 c0                	add    %eax,%eax
  803bd2:	01 d0                	add    %edx,%eax
  803bd4:	c1 e0 02             	shl    $0x2,%eax
  803bd7:	05 64 60 80 00       	add    $0x806064,%eax
  803bdc:	8b 00                	mov    (%eax),%eax
  803bde:	85 c0                	test   %eax,%eax
  803be0:	74 1b                	je     803bfd <initialize_dynamic_allocator+0x10d>
  803be2:	8b 15 4c 60 80 00    	mov    0x80604c,%edx
  803be8:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  803beb:	89 c8                	mov    %ecx,%eax
  803bed:	01 c0                	add    %eax,%eax
  803bef:	01 c8                	add    %ecx,%eax
  803bf1:	c1 e0 02             	shl    $0x2,%eax
  803bf4:	05 60 60 80 00       	add    $0x806060,%eax
  803bf9:	89 02                	mov    %eax,(%edx)
  803bfb:	eb 16                	jmp    803c13 <initialize_dynamic_allocator+0x123>
  803bfd:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803c00:	89 d0                	mov    %edx,%eax
  803c02:	01 c0                	add    %eax,%eax
  803c04:	01 d0                	add    %edx,%eax
  803c06:	c1 e0 02             	shl    $0x2,%eax
  803c09:	05 60 60 80 00       	add    $0x806060,%eax
  803c0e:	a3 48 60 80 00       	mov    %eax,0x806048
  803c13:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803c16:	89 d0                	mov    %edx,%eax
  803c18:	01 c0                	add    %eax,%eax
  803c1a:	01 d0                	add    %edx,%eax
  803c1c:	c1 e0 02             	shl    $0x2,%eax
  803c1f:	05 60 60 80 00       	add    $0x806060,%eax
  803c24:	a3 4c 60 80 00       	mov    %eax,0x80604c
  803c29:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803c2c:	89 d0                	mov    %edx,%eax
  803c2e:	01 c0                	add    %eax,%eax
  803c30:	01 d0                	add    %edx,%eax
  803c32:	c1 e0 02             	shl    $0x2,%eax
  803c35:	05 60 60 80 00       	add    $0x806060,%eax
  803c3a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803c40:	a1 54 60 80 00       	mov    0x806054,%eax
  803c45:	40                   	inc    %eax
  803c46:	a3 54 60 80 00       	mov    %eax,0x806054
	    pageBlockInfoArr[i].num_of_free_blocks=0;
	}


	LIST_INIT(&freePagesList);
	for(int i=0; i<numOfPages; i++){
  803c4b:	ff 45 f0             	incl   -0x10(%ebp)
  803c4e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803c51:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803c54:	0f 8c 58 ff ff ff    	jl     803bb2 <initialize_dynamic_allocator+0xc2>
		LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
	}



	for (int i = 0; i < LOG2_MAX_SIZE - LOG2_MIN_SIZE + 1; i++) {
  803c5a:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  803c61:	eb 36                	jmp    803c99 <initialize_dynamic_allocator+0x1a9>
	    LIST_INIT(&freeBlockLists[i]);
  803c63:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803c66:	c1 e0 04             	shl    $0x4,%eax
  803c69:	05 80 e0 81 00       	add    $0x81e080,%eax
  803c6e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803c74:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803c77:	c1 e0 04             	shl    $0x4,%eax
  803c7a:	05 84 e0 81 00       	add    $0x81e084,%eax
  803c7f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803c85:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803c88:	c1 e0 04             	shl    $0x4,%eax
  803c8b:	05 8c e0 81 00       	add    $0x81e08c,%eax
  803c90:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
	}



	for (int i = 0; i < LOG2_MAX_SIZE - LOG2_MIN_SIZE + 1; i++) {
  803c96:	ff 45 ec             	incl   -0x14(%ebp)
  803c99:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  803c9d:	7e c4                	jle    803c63 <initialize_dynamic_allocator+0x173>


	//Comment the following line
	//panic("initialize_dynamic_allocator() Not implemented yet");

}
  803c9f:	90                   	nop
  803ca0:	c9                   	leave  
  803ca1:	c3                   	ret    

00803ca2 <get_block_size>:
// [2] GET BLOCK SIZE:
//===========================


__inline__ uint32 get_block_size(void *va)
{
  803ca2:	55                   	push   %ebp
  803ca3:	89 e5                	mov    %esp,%ebp
  803ca5:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #2 get_block_size
	//Your code is here

	uint32 page_index = ((uint32)va - dynAllocStart)/ PAGE_SIZE;
  803ca8:	8b 55 08             	mov    0x8(%ebp),%edx
  803cab:	a1 64 e0 81 00       	mov    0x81e064,%eax
  803cb0:	29 c2                	sub    %eax,%edx
  803cb2:	89 d0                	mov    %edx,%eax
  803cb4:	c1 e8 0c             	shr    $0xc,%eax
  803cb7:	89 45 fc             	mov    %eax,-0x4(%ebp)
    return pageBlockInfoArr[page_index].block_size;
  803cba:	8b 55 fc             	mov    -0x4(%ebp),%edx
  803cbd:	89 d0                	mov    %edx,%eax
  803cbf:	01 c0                	add    %eax,%eax
  803cc1:	01 d0                	add    %edx,%eax
  803cc3:	c1 e0 02             	shl    $0x2,%eax
  803cc6:	05 68 60 80 00       	add    $0x806068,%eax
  803ccb:	8b 00                	mov    (%eax),%eax
  803ccd:	0f b7 c0             	movzwl %ax,%eax
	//Comment the following line
	//panic("get_block_size() Not implemented yet");
}
  803cd0:	c9                   	leave  
  803cd1:	c3                   	ret    

00803cd2 <alloc_block>:

//===========================
// 3) ALLOCATE BLOCK:
//===========================
void *alloc_block(uint32 size)
{
  803cd2:	55                   	push   %ebp
  803cd3:	89 e5                	mov    %esp,%ebp
  803cd5:	83 ec 48             	sub    $0x48,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(size <= DYN_ALLOC_MAX_BLOCK_SIZE);
  803cd8:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  803cdf:	76 16                	jbe    803cf7 <alloc_block+0x25>
  803ce1:	68 a0 52 80 00       	push   $0x8052a0
  803ce6:	68 72 52 80 00       	push   $0x805272
  803ceb:	6a 6c                	push   $0x6c
  803ced:	68 87 52 80 00       	push   $0x805287
  803cf2:	e8 c0 ca ff ff       	call   8007b7 <_panic>
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #3 alloc_block
	//Your code is here


	if(size == 0){
  803cf7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803cfb:	75 0a                	jne    803d07 <alloc_block+0x35>
		return NULL;
  803cfd:	b8 00 00 00 00       	mov    $0x0,%eax
  803d02:	e9 65 04 00 00       	jmp    80416c <alloc_block+0x49a>
	}
	else if(size<=8){
  803d07:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  803d0b:	77 09                	ja     803d16 <alloc_block+0x44>
		size=8;
  803d0d:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
  803d14:	eb 1f                	jmp    803d35 <alloc_block+0x63>
	}
	else{
		uint32 reqsize=8;
  803d16:	c7 45 f4 08 00 00 00 	movl   $0x8,-0xc(%ebp)
		while(reqsize < size){
  803d1d:	eb 08                	jmp    803d27 <alloc_block+0x55>
			reqsize*=2;
  803d1f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d22:	01 c0                	add    %eax,%eax
  803d24:	89 45 f4             	mov    %eax,-0xc(%ebp)
	else if(size<=8){
		size=8;
	}
	else{
		uint32 reqsize=8;
		while(reqsize < size){
  803d27:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d2a:	3b 45 08             	cmp    0x8(%ebp),%eax
  803d2d:	72 f0                	jb     803d1f <alloc_block+0x4d>
			reqsize*=2;
		}
		size= reqsize;
  803d2f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d32:	89 45 08             	mov    %eax,0x8(%ebp)
	}

	int list_index = log2(size)- LOG2_MIN_SIZE;
  803d35:	83 ec 0c             	sub    $0xc,%esp
  803d38:	ff 75 08             	pushl  0x8(%ebp)
  803d3b:	e8 90 fd ff ff       	call   803ad0 <log2>
  803d40:	83 c4 10             	add    $0x10,%esp
  803d43:	83 e8 03             	sub    $0x3,%eax
  803d46:	89 45 e8             	mov    %eax,-0x18(%ebp)

	if(!LIST_EMPTY(&freeBlockLists[list_index])){
  803d49:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803d4c:	c1 e0 04             	shl    $0x4,%eax
  803d4f:	05 80 e0 81 00       	add    $0x81e080,%eax
  803d54:	8b 00                	mov    (%eax),%eax
  803d56:	85 c0                	test   %eax,%eax
  803d58:	0f 84 fb 00 00 00    	je     803e59 <alloc_block+0x187>
		struct BlockElement *block = LIST_FIRST(&freeBlockLists[list_index]);
  803d5e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803d61:	c1 e0 04             	shl    $0x4,%eax
  803d64:	05 80 e0 81 00       	add    $0x81e080,%eax
  803d69:	8b 00                	mov    (%eax),%eax
  803d6b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		LIST_REMOVE(&freeBlockLists[list_index], block);
  803d6e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803d72:	75 17                	jne    803d8b <alloc_block+0xb9>
  803d74:	83 ec 04             	sub    $0x4,%esp
  803d77:	68 c1 52 80 00       	push   $0x8052c1
  803d7c:	68 86 00 00 00       	push   $0x86
  803d81:	68 87 52 80 00       	push   $0x805287
  803d86:	e8 2c ca ff ff       	call   8007b7 <_panic>
  803d8b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803d8e:	8b 00                	mov    (%eax),%eax
  803d90:	85 c0                	test   %eax,%eax
  803d92:	74 10                	je     803da4 <alloc_block+0xd2>
  803d94:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803d97:	8b 00                	mov    (%eax),%eax
  803d99:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803d9c:	8b 52 04             	mov    0x4(%edx),%edx
  803d9f:	89 50 04             	mov    %edx,0x4(%eax)
  803da2:	eb 14                	jmp    803db8 <alloc_block+0xe6>
  803da4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803da7:	8b 40 04             	mov    0x4(%eax),%eax
  803daa:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803dad:	c1 e2 04             	shl    $0x4,%edx
  803db0:	81 c2 84 e0 81 00    	add    $0x81e084,%edx
  803db6:	89 02                	mov    %eax,(%edx)
  803db8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803dbb:	8b 40 04             	mov    0x4(%eax),%eax
  803dbe:	85 c0                	test   %eax,%eax
  803dc0:	74 0f                	je     803dd1 <alloc_block+0xff>
  803dc2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803dc5:	8b 40 04             	mov    0x4(%eax),%eax
  803dc8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803dcb:	8b 12                	mov    (%edx),%edx
  803dcd:	89 10                	mov    %edx,(%eax)
  803dcf:	eb 13                	jmp    803de4 <alloc_block+0x112>
  803dd1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803dd4:	8b 00                	mov    (%eax),%eax
  803dd6:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803dd9:	c1 e2 04             	shl    $0x4,%edx
  803ddc:	81 c2 80 e0 81 00    	add    $0x81e080,%edx
  803de2:	89 02                	mov    %eax,(%edx)
  803de4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803de7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803ded:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803df0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803df7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803dfa:	c1 e0 04             	shl    $0x4,%eax
  803dfd:	05 8c e0 81 00       	add    $0x81e08c,%eax
  803e02:	8b 00                	mov    (%eax),%eax
  803e04:	8d 50 ff             	lea    -0x1(%eax),%edx
  803e07:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803e0a:	c1 e0 04             	shl    $0x4,%eax
  803e0d:	05 8c e0 81 00       	add    $0x81e08c,%eax
  803e12:	89 10                	mov    %edx,(%eax)
		uint32 page_index = ((uint32)block - dynAllocStart)/ PAGE_SIZE;
  803e14:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803e17:	a1 64 e0 81 00       	mov    0x81e064,%eax
  803e1c:	29 c2                	sub    %eax,%edx
  803e1e:	89 d0                	mov    %edx,%eax
  803e20:	c1 e8 0c             	shr    $0xc,%eax
  803e23:	89 45 e0             	mov    %eax,-0x20(%ebp)
		pageBlockInfoArr[page_index].num_of_free_blocks--;
  803e26:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803e29:	89 d0                	mov    %edx,%eax
  803e2b:	01 c0                	add    %eax,%eax
  803e2d:	01 d0                	add    %edx,%eax
  803e2f:	c1 e0 02             	shl    $0x2,%eax
  803e32:	05 6a 60 80 00       	add    $0x80606a,%eax
  803e37:	66 8b 00             	mov    (%eax),%ax
  803e3a:	8d 50 ff             	lea    -0x1(%eax),%edx
  803e3d:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  803e40:	89 c8                	mov    %ecx,%eax
  803e42:	01 c0                	add    %eax,%eax
  803e44:	01 c8                	add    %ecx,%eax
  803e46:	c1 e0 02             	shl    $0x2,%eax
  803e49:	05 6a 60 80 00       	add    $0x80606a,%eax
  803e4e:	66 89 10             	mov    %dx,(%eax)
		return (void*)block;
  803e51:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803e54:	e9 13 03 00 00       	jmp    80416c <alloc_block+0x49a>
	}

	if(!LIST_EMPTY(&freePagesList)){
  803e59:	a1 48 60 80 00       	mov    0x806048,%eax
  803e5e:	85 c0                	test   %eax,%eax
  803e60:	0f 84 c9 01 00 00    	je     80402f <alloc_block+0x35d>

		struct PageInfoElement *page_info = LIST_FIRST(&freePagesList);
  803e66:	a1 48 60 80 00       	mov    0x806048,%eax
  803e6b:	89 45 dc             	mov    %eax,-0x24(%ebp)
		LIST_REMOVE(&freePagesList, page_info);
  803e6e:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803e72:	75 17                	jne    803e8b <alloc_block+0x1b9>
  803e74:	83 ec 04             	sub    $0x4,%esp
  803e77:	68 c1 52 80 00       	push   $0x8052c1
  803e7c:	68 8f 00 00 00       	push   $0x8f
  803e81:	68 87 52 80 00       	push   $0x805287
  803e86:	e8 2c c9 ff ff       	call   8007b7 <_panic>
  803e8b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803e8e:	8b 00                	mov    (%eax),%eax
  803e90:	85 c0                	test   %eax,%eax
  803e92:	74 10                	je     803ea4 <alloc_block+0x1d2>
  803e94:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803e97:	8b 00                	mov    (%eax),%eax
  803e99:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803e9c:	8b 52 04             	mov    0x4(%edx),%edx
  803e9f:	89 50 04             	mov    %edx,0x4(%eax)
  803ea2:	eb 0b                	jmp    803eaf <alloc_block+0x1dd>
  803ea4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803ea7:	8b 40 04             	mov    0x4(%eax),%eax
  803eaa:	a3 4c 60 80 00       	mov    %eax,0x80604c
  803eaf:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803eb2:	8b 40 04             	mov    0x4(%eax),%eax
  803eb5:	85 c0                	test   %eax,%eax
  803eb7:	74 0f                	je     803ec8 <alloc_block+0x1f6>
  803eb9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803ebc:	8b 40 04             	mov    0x4(%eax),%eax
  803ebf:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803ec2:	8b 12                	mov    (%edx),%edx
  803ec4:	89 10                	mov    %edx,(%eax)
  803ec6:	eb 0a                	jmp    803ed2 <alloc_block+0x200>
  803ec8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803ecb:	8b 00                	mov    (%eax),%eax
  803ecd:	a3 48 60 80 00       	mov    %eax,0x806048
  803ed2:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803ed5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803edb:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803ede:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803ee5:	a1 54 60 80 00       	mov    0x806054,%eax
  803eea:	48                   	dec    %eax
  803eeb:	a3 54 60 80 00       	mov    %eax,0x806054
		uint32 page_va = to_page_va(page_info);
  803ef0:	83 ec 0c             	sub    $0xc,%esp
  803ef3:	ff 75 dc             	pushl  -0x24(%ebp)
  803ef6:	e8 89 fb ff ff       	call   803a84 <to_page_va>
  803efb:	83 c4 10             	add    $0x10,%esp
  803efe:	89 45 d8             	mov    %eax,-0x28(%ebp)

		uint32 page_index = (page_va - dynAllocStart)/ PAGE_SIZE;
  803f01:	a1 64 e0 81 00       	mov    0x81e064,%eax
  803f06:	8b 55 d8             	mov    -0x28(%ebp),%edx
  803f09:	29 c2                	sub    %eax,%edx
  803f0b:	89 d0                	mov    %edx,%eax
  803f0d:	c1 e8 0c             	shr    $0xc,%eax
  803f10:	89 45 d4             	mov    %eax,-0x2c(%ebp)

		get_page((void*)page_va);
  803f13:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803f16:	83 ec 0c             	sub    $0xc,%esp
  803f19:	50                   	push   %eax
  803f1a:	e8 fe dc ff ff       	call   801c1d <get_page>
  803f1f:	83 c4 10             	add    $0x10,%esp


		pageBlockInfoArr[page_index].block_size = size;
  803f22:	8b 45 08             	mov    0x8(%ebp),%eax
  803f25:	89 c2                	mov    %eax,%edx
  803f27:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  803f2a:	89 c8                	mov    %ecx,%eax
  803f2c:	01 c0                	add    %eax,%eax
  803f2e:	01 c8                	add    %ecx,%eax
  803f30:	c1 e0 02             	shl    $0x2,%eax
  803f33:	05 68 60 80 00       	add    $0x806068,%eax
  803f38:	66 89 10             	mov    %dx,(%eax)
		int num_blocks = PAGE_SIZE / size ;
  803f3b:	b8 00 10 00 00       	mov    $0x1000,%eax
  803f40:	ba 00 00 00 00       	mov    $0x0,%edx
  803f45:	f7 75 08             	divl   0x8(%ebp)
  803f48:	89 45 d0             	mov    %eax,-0x30(%ebp)
		pageBlockInfoArr[page_index].num_of_free_blocks= num_blocks - 1 ;
  803f4b:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803f4e:	8d 50 ff             	lea    -0x1(%eax),%edx
  803f51:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  803f54:	89 c8                	mov    %ecx,%eax
  803f56:	01 c0                	add    %eax,%eax
  803f58:	01 c8                	add    %ecx,%eax
  803f5a:	c1 e0 02             	shl    $0x2,%eax
  803f5d:	05 6a 60 80 00       	add    $0x80606a,%eax
  803f62:	66 89 10             	mov    %dx,(%eax)

		for(int i=1; i< num_blocks; i++){
  803f65:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
  803f6c:	e9 aa 00 00 00       	jmp    80401b <alloc_block+0x349>
			struct BlockElement *new_block = (struct BlockElement*)(page_va + i *size);
  803f71:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803f74:	0f af 45 08          	imul   0x8(%ebp),%eax
  803f78:	89 c2                	mov    %eax,%edx
  803f7a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803f7d:	01 d0                	add    %edx,%eax
  803f7f:	89 45 cc             	mov    %eax,-0x34(%ebp)
			LIST_INSERT_TAIL(&freeBlockLists[list_index], new_block);
  803f82:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  803f86:	75 17                	jne    803f9f <alloc_block+0x2cd>
  803f88:	83 ec 04             	sub    $0x4,%esp
  803f8b:	68 e0 52 80 00       	push   $0x8052e0
  803f90:	68 9d 00 00 00       	push   $0x9d
  803f95:	68 87 52 80 00       	push   $0x805287
  803f9a:	e8 18 c8 ff ff       	call   8007b7 <_panic>
  803f9f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803fa2:	c1 e0 04             	shl    $0x4,%eax
  803fa5:	05 84 e0 81 00       	add    $0x81e084,%eax
  803faa:	8b 10                	mov    (%eax),%edx
  803fac:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803faf:	89 50 04             	mov    %edx,0x4(%eax)
  803fb2:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803fb5:	8b 40 04             	mov    0x4(%eax),%eax
  803fb8:	85 c0                	test   %eax,%eax
  803fba:	74 14                	je     803fd0 <alloc_block+0x2fe>
  803fbc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803fbf:	c1 e0 04             	shl    $0x4,%eax
  803fc2:	05 84 e0 81 00       	add    $0x81e084,%eax
  803fc7:	8b 00                	mov    (%eax),%eax
  803fc9:	8b 55 cc             	mov    -0x34(%ebp),%edx
  803fcc:	89 10                	mov    %edx,(%eax)
  803fce:	eb 11                	jmp    803fe1 <alloc_block+0x30f>
  803fd0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803fd3:	c1 e0 04             	shl    $0x4,%eax
  803fd6:	8d 90 80 e0 81 00    	lea    0x81e080(%eax),%edx
  803fdc:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803fdf:	89 02                	mov    %eax,(%edx)
  803fe1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803fe4:	c1 e0 04             	shl    $0x4,%eax
  803fe7:	8d 90 84 e0 81 00    	lea    0x81e084(%eax),%edx
  803fed:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803ff0:	89 02                	mov    %eax,(%edx)
  803ff2:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803ff5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803ffb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803ffe:	c1 e0 04             	shl    $0x4,%eax
  804001:	05 8c e0 81 00       	add    $0x81e08c,%eax
  804006:	8b 00                	mov    (%eax),%eax
  804008:	8d 50 01             	lea    0x1(%eax),%edx
  80400b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80400e:	c1 e0 04             	shl    $0x4,%eax
  804011:	05 8c e0 81 00       	add    $0x81e08c,%eax
  804016:	89 10                	mov    %edx,(%eax)

		pageBlockInfoArr[page_index].block_size = size;
		int num_blocks = PAGE_SIZE / size ;
		pageBlockInfoArr[page_index].num_of_free_blocks= num_blocks - 1 ;

		for(int i=1; i< num_blocks; i++){
  804018:	ff 45 f0             	incl   -0x10(%ebp)
  80401b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80401e:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  804021:	0f 8c 4a ff ff ff    	jl     803f71 <alloc_block+0x29f>
			struct BlockElement *new_block = (struct BlockElement*)(page_va + i *size);
			LIST_INSERT_TAIL(&freeBlockLists[list_index], new_block);
		}
		return(void*)page_va;
  804027:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80402a:	e9 3d 01 00 00       	jmp    80416c <alloc_block+0x49a>
	}


	for(int i =list_index+1; i<= LOG2_MAX_SIZE - LOG2_MIN_SIZE; i++){
  80402f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804032:	40                   	inc    %eax
  804033:	89 45 ec             	mov    %eax,-0x14(%ebp)
  804036:	e9 10 01 00 00       	jmp    80414b <alloc_block+0x479>

		if(!LIST_EMPTY(&freeBlockLists[i])){
  80403b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80403e:	c1 e0 04             	shl    $0x4,%eax
  804041:	05 80 e0 81 00       	add    $0x81e080,%eax
  804046:	8b 00                	mov    (%eax),%eax
  804048:	85 c0                	test   %eax,%eax
  80404a:	0f 84 f8 00 00 00    	je     804148 <alloc_block+0x476>

			struct BlockElement *block = LIST_FIRST(&freeBlockLists[i]);
  804050:	8b 45 ec             	mov    -0x14(%ebp),%eax
  804053:	c1 e0 04             	shl    $0x4,%eax
  804056:	05 80 e0 81 00       	add    $0x81e080,%eax
  80405b:	8b 00                	mov    (%eax),%eax
  80405d:	89 45 c8             	mov    %eax,-0x38(%ebp)
			LIST_REMOVE( &freeBlockLists[i], block);
  804060:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  804064:	75 17                	jne    80407d <alloc_block+0x3ab>
  804066:	83 ec 04             	sub    $0x4,%esp
  804069:	68 c1 52 80 00       	push   $0x8052c1
  80406e:	68 a8 00 00 00       	push   $0xa8
  804073:	68 87 52 80 00       	push   $0x805287
  804078:	e8 3a c7 ff ff       	call   8007b7 <_panic>
  80407d:	8b 45 c8             	mov    -0x38(%ebp),%eax
  804080:	8b 00                	mov    (%eax),%eax
  804082:	85 c0                	test   %eax,%eax
  804084:	74 10                	je     804096 <alloc_block+0x3c4>
  804086:	8b 45 c8             	mov    -0x38(%ebp),%eax
  804089:	8b 00                	mov    (%eax),%eax
  80408b:	8b 55 c8             	mov    -0x38(%ebp),%edx
  80408e:	8b 52 04             	mov    0x4(%edx),%edx
  804091:	89 50 04             	mov    %edx,0x4(%eax)
  804094:	eb 14                	jmp    8040aa <alloc_block+0x3d8>
  804096:	8b 45 c8             	mov    -0x38(%ebp),%eax
  804099:	8b 40 04             	mov    0x4(%eax),%eax
  80409c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80409f:	c1 e2 04             	shl    $0x4,%edx
  8040a2:	81 c2 84 e0 81 00    	add    $0x81e084,%edx
  8040a8:	89 02                	mov    %eax,(%edx)
  8040aa:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8040ad:	8b 40 04             	mov    0x4(%eax),%eax
  8040b0:	85 c0                	test   %eax,%eax
  8040b2:	74 0f                	je     8040c3 <alloc_block+0x3f1>
  8040b4:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8040b7:	8b 40 04             	mov    0x4(%eax),%eax
  8040ba:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8040bd:	8b 12                	mov    (%edx),%edx
  8040bf:	89 10                	mov    %edx,(%eax)
  8040c1:	eb 13                	jmp    8040d6 <alloc_block+0x404>
  8040c3:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8040c6:	8b 00                	mov    (%eax),%eax
  8040c8:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8040cb:	c1 e2 04             	shl    $0x4,%edx
  8040ce:	81 c2 80 e0 81 00    	add    $0x81e080,%edx
  8040d4:	89 02                	mov    %eax,(%edx)
  8040d6:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8040d9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8040df:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8040e2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8040e9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8040ec:	c1 e0 04             	shl    $0x4,%eax
  8040ef:	05 8c e0 81 00       	add    $0x81e08c,%eax
  8040f4:	8b 00                	mov    (%eax),%eax
  8040f6:	8d 50 ff             	lea    -0x1(%eax),%edx
  8040f9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8040fc:	c1 e0 04             	shl    $0x4,%eax
  8040ff:	05 8c e0 81 00       	add    $0x81e08c,%eax
  804104:	89 10                	mov    %edx,(%eax)

			uint32 page_index = ((uint32)block - dynAllocStart)/ PAGE_SIZE;
  804106:	8b 55 c8             	mov    -0x38(%ebp),%edx
  804109:	a1 64 e0 81 00       	mov    0x81e064,%eax
  80410e:	29 c2                	sub    %eax,%edx
  804110:	89 d0                	mov    %edx,%eax
  804112:	c1 e8 0c             	shr    $0xc,%eax
  804115:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			pageBlockInfoArr[page_index].num_of_free_blocks-- ;
  804118:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  80411b:	89 d0                	mov    %edx,%eax
  80411d:	01 c0                	add    %eax,%eax
  80411f:	01 d0                	add    %edx,%eax
  804121:	c1 e0 02             	shl    $0x2,%eax
  804124:	05 6a 60 80 00       	add    $0x80606a,%eax
  804129:	66 8b 00             	mov    (%eax),%ax
  80412c:	8d 50 ff             	lea    -0x1(%eax),%edx
  80412f:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  804132:	89 c8                	mov    %ecx,%eax
  804134:	01 c0                	add    %eax,%eax
  804136:	01 c8                	add    %ecx,%eax
  804138:	c1 e0 02             	shl    $0x2,%eax
  80413b:	05 6a 60 80 00       	add    $0x80606a,%eax
  804140:	66 89 10             	mov    %dx,(%eax)

			return (void*)block;
  804143:	8b 45 c8             	mov    -0x38(%ebp),%eax
  804146:	eb 24                	jmp    80416c <alloc_block+0x49a>
		}
		return(void*)page_va;
	}


	for(int i =list_index+1; i<= LOG2_MAX_SIZE - LOG2_MIN_SIZE; i++){
  804148:	ff 45 ec             	incl   -0x14(%ebp)
  80414b:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  80414f:	0f 8e e6 fe ff ff    	jle    80403b <alloc_block+0x369>

			return (void*)block;
		}
	}

	panic("alloc_block: out of memory! ");
  804155:	83 ec 04             	sub    $0x4,%esp
  804158:	68 03 53 80 00       	push   $0x805303
  80415d:	68 b1 00 00 00       	push   $0xb1
  804162:	68 87 52 80 00       	push   $0x805287
  804167:	e8 4b c6 ff ff       	call   8007b7 <_panic>

	//Comment the following line
	//panic("alloc_block() Not implemented yet");

	//TODO: [PROJECT'25.BONUS#1] DYNAMIC ALLOCATOR - block if no free block
}
  80416c:	c9                   	leave  
  80416d:	c3                   	ret    

0080416e <free_block>:

//===========================
// [4] FREE BLOCK:
//===========================
void free_block(void *va)
{
  80416e:	55                   	push   %ebp
  80416f:	89 e5                	mov    %esp,%ebp
  804171:	83 ec 38             	sub    $0x38,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert((uint32)va >= dynAllocStart && (uint32)va < dynAllocEnd);
  804174:	8b 55 08             	mov    0x8(%ebp),%edx
  804177:	a1 64 e0 81 00       	mov    0x81e064,%eax
  80417c:	39 c2                	cmp    %eax,%edx
  80417e:	72 0c                	jb     80418c <free_block+0x1e>
  804180:	8b 55 08             	mov    0x8(%ebp),%edx
  804183:	a1 40 60 80 00       	mov    0x806040,%eax
  804188:	39 c2                	cmp    %eax,%edx
  80418a:	72 19                	jb     8041a5 <free_block+0x37>
  80418c:	68 20 53 80 00       	push   $0x805320
  804191:	68 72 52 80 00       	push   $0x805272
  804196:	68 c3 00 00 00       	push   $0xc3
  80419b:	68 87 52 80 00       	push   $0x805287
  8041a0:	e8 12 c6 ff ff       	call   8007b7 <_panic>
	//==================================================================================

	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #4 free_block
	//Your code is here

	uint32 page_index=((uint32)va - dynAllocStart)/ PAGE_SIZE;
  8041a5:	8b 55 08             	mov    0x8(%ebp),%edx
  8041a8:	a1 64 e0 81 00       	mov    0x81e064,%eax
  8041ad:	29 c2                	sub    %eax,%edx
  8041af:	89 d0                	mov    %edx,%eax
  8041b1:	c1 e8 0c             	shr    $0xc,%eax
  8041b4:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 block_size = pageBlockInfoArr[page_index].block_size;
  8041b7:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8041ba:	89 d0                	mov    %edx,%eax
  8041bc:	01 c0                	add    %eax,%eax
  8041be:	01 d0                	add    %edx,%eax
  8041c0:	c1 e0 02             	shl    $0x2,%eax
  8041c3:	05 68 60 80 00       	add    $0x806068,%eax
  8041c8:	8b 00                	mov    (%eax),%eax
  8041ca:	0f b7 c0             	movzwl %ax,%eax
  8041cd:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if(block_size == 0){
  8041d0:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8041d4:	75 17                	jne    8041ed <free_block+0x7f>
		panic("page is empty(already not allocated)");
  8041d6:	83 ec 04             	sub    $0x4,%esp
  8041d9:	68 58 53 80 00       	push   $0x805358
  8041de:	68 cf 00 00 00       	push   $0xcf
  8041e3:	68 87 52 80 00       	push   $0x805287
  8041e8:	e8 ca c5 ff ff       	call   8007b7 <_panic>
	}

	int list_index = log2(block_size) - LOG2_MIN_SIZE;
  8041ed:	83 ec 0c             	sub    $0xc,%esp
  8041f0:	ff 75 ec             	pushl  -0x14(%ebp)
  8041f3:	e8 d8 f8 ff ff       	call   803ad0 <log2>
  8041f8:	83 c4 10             	add    $0x10,%esp
  8041fb:	83 e8 03             	sub    $0x3,%eax
  8041fe:	89 45 e8             	mov    %eax,-0x18(%ebp)
	// mn va l block "elta7weel mn virtual l phy hna"
	struct BlockElement *block = (struct BlockElement *)va;
  804201:	8b 45 08             	mov    0x8(%ebp),%eax
  804204:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	LIST_INSERT_TAIL(&freeBlockLists[list_index], block);
  804207:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80420b:	75 17                	jne    804224 <free_block+0xb6>
  80420d:	83 ec 04             	sub    $0x4,%esp
  804210:	68 e0 52 80 00       	push   $0x8052e0
  804215:	68 d5 00 00 00       	push   $0xd5
  80421a:	68 87 52 80 00       	push   $0x805287
  80421f:	e8 93 c5 ff ff       	call   8007b7 <_panic>
  804224:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804227:	c1 e0 04             	shl    $0x4,%eax
  80422a:	05 84 e0 81 00       	add    $0x81e084,%eax
  80422f:	8b 10                	mov    (%eax),%edx
  804231:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804234:	89 50 04             	mov    %edx,0x4(%eax)
  804237:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80423a:	8b 40 04             	mov    0x4(%eax),%eax
  80423d:	85 c0                	test   %eax,%eax
  80423f:	74 14                	je     804255 <free_block+0xe7>
  804241:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804244:	c1 e0 04             	shl    $0x4,%eax
  804247:	05 84 e0 81 00       	add    $0x81e084,%eax
  80424c:	8b 00                	mov    (%eax),%eax
  80424e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  804251:	89 10                	mov    %edx,(%eax)
  804253:	eb 11                	jmp    804266 <free_block+0xf8>
  804255:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804258:	c1 e0 04             	shl    $0x4,%eax
  80425b:	8d 90 80 e0 81 00    	lea    0x81e080(%eax),%edx
  804261:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804264:	89 02                	mov    %eax,(%edx)
  804266:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804269:	c1 e0 04             	shl    $0x4,%eax
  80426c:	8d 90 84 e0 81 00    	lea    0x81e084(%eax),%edx
  804272:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804275:	89 02                	mov    %eax,(%edx)
  804277:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80427a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  804280:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804283:	c1 e0 04             	shl    $0x4,%eax
  804286:	05 8c e0 81 00       	add    $0x81e08c,%eax
  80428b:	8b 00                	mov    (%eax),%eax
  80428d:	8d 50 01             	lea    0x1(%eax),%edx
  804290:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804293:	c1 e0 04             	shl    $0x4,%eax
  804296:	05 8c e0 81 00       	add    $0x81e08c,%eax
  80429b:	89 10                	mov    %edx,(%eax)
	// b3d ma wdytha fy el freeBlockLists hzwed elfree elly fy el array 1
	pageBlockInfoArr[page_index].num_of_free_blocks++;
  80429d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8042a0:	89 d0                	mov    %edx,%eax
  8042a2:	01 c0                	add    %eax,%eax
  8042a4:	01 d0                	add    %edx,%eax
  8042a6:	c1 e0 02             	shl    $0x2,%eax
  8042a9:	05 6a 60 80 00       	add    $0x80606a,%eax
  8042ae:	66 8b 00             	mov    (%eax),%ax
  8042b1:	8d 50 01             	lea    0x1(%eax),%edx
  8042b4:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8042b7:	89 c8                	mov    %ecx,%eax
  8042b9:	01 c0                	add    %eax,%eax
  8042bb:	01 c8                	add    %ecx,%eax
  8042bd:	c1 e0 02             	shl    $0x2,%eax
  8042c0:	05 6a 60 80 00       	add    $0x80606a,%eax
  8042c5:	66 89 10             	mov    %dx,(%eax)
	int blocks_number = PAGE_SIZE / block_size;
  8042c8:	b8 00 10 00 00       	mov    $0x1000,%eax
  8042cd:	ba 00 00 00 00       	mov    $0x0,%edx
  8042d2:	f7 75 ec             	divl   -0x14(%ebp)
  8042d5:	89 45 e0             	mov    %eax,-0x20(%ebp)
	if(pageBlockInfoArr[page_index].num_of_free_blocks == blocks_number){
  8042d8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8042db:	89 d0                	mov    %edx,%eax
  8042dd:	01 c0                	add    %eax,%eax
  8042df:	01 d0                	add    %edx,%eax
  8042e1:	c1 e0 02             	shl    $0x2,%eax
  8042e4:	05 6a 60 80 00       	add    $0x80606a,%eax
  8042e9:	66 8b 00             	mov    (%eax),%ax
  8042ec:	0f b7 c0             	movzwl %ax,%eax
  8042ef:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8042f2:	0f 85 d3 01 00 00    	jne    8044cb <free_block+0x35d>
		struct BlockElement *itr = LIST_FIRST(&freeBlockLists[list_index]);
  8042f8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8042fb:	c1 e0 04             	shl    $0x4,%eax
  8042fe:	05 80 e0 81 00       	add    $0x81e080,%eax
  804303:	8b 00                	mov    (%eax),%eax
  804305:	89 45 f4             	mov    %eax,-0xc(%ebp)
		while(itr != NULL){
  804308:	e9 f1 00 00 00       	jmp    8043fe <free_block+0x290>
			//lw ms7to el pointer mydy34 ->
			struct BlockElement *next = LIST_NEXT(itr);
  80430d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804310:	8b 00                	mov    (%eax),%eax
  804312:	89 45 dc             	mov    %eax,-0x24(%ebp)
			uint32 page_beginning_address= dynAllocStart + page_index * PAGE_SIZE;
  804315:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804318:	c1 e0 0c             	shl    $0xc,%eax
  80431b:	89 c2                	mov    %eax,%edx
  80431d:	a1 64 e0 81 00       	mov    0x81e064,%eax
  804322:	01 d0                	add    %edx,%eax
  804324:	89 45 d8             	mov    %eax,-0x28(%ebp)
			uint32 page_end_address = dynAllocStart + (page_index +1 )* PAGE_SIZE;
  804327:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80432a:	40                   	inc    %eax
  80432b:	c1 e0 0c             	shl    $0xc,%eax
  80432e:	89 c2                	mov    %eax,%edx
  804330:	a1 64 e0 81 00       	mov    0x81e064,%eax
  804335:	01 d0                	add    %edx,%eax
  804337:	89 45 d4             	mov    %eax,-0x2c(%ebp)

			if((uint32)itr >= page_beginning_address && (uint32)itr < page_end_address){
  80433a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80433d:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  804340:	0f 82 b8 00 00 00    	jb     8043fe <free_block+0x290>
  804346:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804349:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  80434c:	0f 83 ac 00 00 00    	jae    8043fe <free_block+0x290>
				LIST_REMOVE(&freeBlockLists[list_index], itr);
  804352:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  804356:	75 17                	jne    80436f <free_block+0x201>
  804358:	83 ec 04             	sub    $0x4,%esp
  80435b:	68 c1 52 80 00       	push   $0x8052c1
  804360:	68 e2 00 00 00       	push   $0xe2
  804365:	68 87 52 80 00       	push   $0x805287
  80436a:	e8 48 c4 ff ff       	call   8007b7 <_panic>
  80436f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804372:	8b 00                	mov    (%eax),%eax
  804374:	85 c0                	test   %eax,%eax
  804376:	74 10                	je     804388 <free_block+0x21a>
  804378:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80437b:	8b 00                	mov    (%eax),%eax
  80437d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  804380:	8b 52 04             	mov    0x4(%edx),%edx
  804383:	89 50 04             	mov    %edx,0x4(%eax)
  804386:	eb 14                	jmp    80439c <free_block+0x22e>
  804388:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80438b:	8b 40 04             	mov    0x4(%eax),%eax
  80438e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  804391:	c1 e2 04             	shl    $0x4,%edx
  804394:	81 c2 84 e0 81 00    	add    $0x81e084,%edx
  80439a:	89 02                	mov    %eax,(%edx)
  80439c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80439f:	8b 40 04             	mov    0x4(%eax),%eax
  8043a2:	85 c0                	test   %eax,%eax
  8043a4:	74 0f                	je     8043b5 <free_block+0x247>
  8043a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8043a9:	8b 40 04             	mov    0x4(%eax),%eax
  8043ac:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8043af:	8b 12                	mov    (%edx),%edx
  8043b1:	89 10                	mov    %edx,(%eax)
  8043b3:	eb 13                	jmp    8043c8 <free_block+0x25a>
  8043b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8043b8:	8b 00                	mov    (%eax),%eax
  8043ba:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8043bd:	c1 e2 04             	shl    $0x4,%edx
  8043c0:	81 c2 80 e0 81 00    	add    $0x81e080,%edx
  8043c6:	89 02                	mov    %eax,(%edx)
  8043c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8043cb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8043d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8043d4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8043db:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8043de:	c1 e0 04             	shl    $0x4,%eax
  8043e1:	05 8c e0 81 00       	add    $0x81e08c,%eax
  8043e6:	8b 00                	mov    (%eax),%eax
  8043e8:	8d 50 ff             	lea    -0x1(%eax),%edx
  8043eb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8043ee:	c1 e0 04             	shl    $0x4,%eax
  8043f1:	05 8c e0 81 00       	add    $0x81e08c,%eax
  8043f6:	89 10                	mov    %edx,(%eax)
				//y5o4 3la elly b3do
				itr = next;
  8043f8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8043fb:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// b3d ma wdytha fy el freeBlockLists hzwed elfree elly fy el array 1
	pageBlockInfoArr[page_index].num_of_free_blocks++;
	int blocks_number = PAGE_SIZE / block_size;
	if(pageBlockInfoArr[page_index].num_of_free_blocks == blocks_number){
		struct BlockElement *itr = LIST_FIRST(&freeBlockLists[list_index]);
		while(itr != NULL){
  8043fe:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  804402:	0f 85 05 ff ff ff    	jne    80430d <free_block+0x19f>
				LIST_REMOVE(&freeBlockLists[list_index], itr);
				//y5o4 3la elly b3do
				itr = next;
			}
		}
		pageBlockInfoArr[page_index].block_size=0;
  804408:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80440b:	89 d0                	mov    %edx,%eax
  80440d:	01 c0                	add    %eax,%eax
  80440f:	01 d0                	add    %edx,%eax
  804411:	c1 e0 02             	shl    $0x2,%eax
  804414:	05 68 60 80 00       	add    $0x806068,%eax
  804419:	66 c7 00 00 00       	movw   $0x0,(%eax)
		pageBlockInfoArr[page_index].num_of_free_blocks=0;
  80441e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  804421:	89 d0                	mov    %edx,%eax
  804423:	01 c0                	add    %eax,%eax
  804425:	01 d0                	add    %edx,%eax
  804427:	c1 e0 02             	shl    $0x2,%eax
  80442a:	05 6a 60 80 00       	add    $0x80606a,%eax
  80442f:	66 c7 00 00 00       	movw   $0x0,(%eax)

		struct PageInfoElement *page_info = &pageBlockInfoArr[page_index];
  804434:	8b 55 f0             	mov    -0x10(%ebp),%edx
  804437:	89 d0                	mov    %edx,%eax
  804439:	01 c0                	add    %eax,%eax
  80443b:	01 d0                	add    %edx,%eax
  80443d:	c1 e0 02             	shl    $0x2,%eax
  804440:	05 60 60 80 00       	add    $0x806060,%eax
  804445:	89 45 d0             	mov    %eax,-0x30(%ebp)
		LIST_INSERT_TAIL(&freePagesList, page_info);
  804448:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  80444c:	75 17                	jne    804465 <free_block+0x2f7>
  80444e:	83 ec 04             	sub    $0x4,%esp
  804451:	68 e0 52 80 00       	push   $0x8052e0
  804456:	68 eb 00 00 00       	push   $0xeb
  80445b:	68 87 52 80 00       	push   $0x805287
  804460:	e8 52 c3 ff ff       	call   8007b7 <_panic>
  804465:	8b 15 4c 60 80 00    	mov    0x80604c,%edx
  80446b:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80446e:	89 50 04             	mov    %edx,0x4(%eax)
  804471:	8b 45 d0             	mov    -0x30(%ebp),%eax
  804474:	8b 40 04             	mov    0x4(%eax),%eax
  804477:	85 c0                	test   %eax,%eax
  804479:	74 0c                	je     804487 <free_block+0x319>
  80447b:	a1 4c 60 80 00       	mov    0x80604c,%eax
  804480:	8b 55 d0             	mov    -0x30(%ebp),%edx
  804483:	89 10                	mov    %edx,(%eax)
  804485:	eb 08                	jmp    80448f <free_block+0x321>
  804487:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80448a:	a3 48 60 80 00       	mov    %eax,0x806048
  80448f:	8b 45 d0             	mov    -0x30(%ebp),%eax
  804492:	a3 4c 60 80 00       	mov    %eax,0x80604c
  804497:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80449a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8044a0:	a1 54 60 80 00       	mov    0x806054,%eax
  8044a5:	40                   	inc    %eax
  8044a6:	a3 54 60 80 00       	mov    %eax,0x806054
		uint32 page_va = to_page_va(page_info);
  8044ab:	83 ec 0c             	sub    $0xc,%esp
  8044ae:	ff 75 d0             	pushl  -0x30(%ebp)
  8044b1:	e8 ce f5 ff ff       	call   803a84 <to_page_va>
  8044b6:	83 c4 10             	add    $0x10,%esp
  8044b9:	89 45 cc             	mov    %eax,-0x34(%ebp)
		return_page((void *)page_va);
  8044bc:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8044bf:	83 ec 0c             	sub    $0xc,%esp
  8044c2:	50                   	push   %eax
  8044c3:	e8 9e d7 ff ff       	call   801c66 <return_page>
  8044c8:	83 c4 10             	add    $0x10,%esp
	}


	//Comment the following line
	//panic("free_block() Not implemented yet");
}
  8044cb:	90                   	nop
  8044cc:	c9                   	leave  
  8044cd:	c3                   	ret    

008044ce <realloc_block>:

//===========================
// [1] REALLOCATE BLOCK:
//===========================
void *realloc_block(void* va, uint32 new_size)
{
  8044ce:	55                   	push   %ebp
  8044cf:	89 e5                	mov    %esp,%ebp
  8044d1:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.BONUS#2] KERNEL REALLOC - realloc_block
	//Your code is here
	//Comment the following line
	panic("realloc_block() Not implemented yet");
  8044d4:	83 ec 04             	sub    $0x4,%esp
  8044d7:	68 80 53 80 00       	push   $0x805380
  8044dc:	68 01 01 00 00       	push   $0x101
  8044e1:	68 87 52 80 00       	push   $0x805287
  8044e6:	e8 cc c2 ff ff       	call   8007b7 <_panic>

008044eb <init_uspinlock>:
#include "inc/uspinlock.h"

extern volatile struct Env *myEnv;

void init_uspinlock(struct uspinlock *lk, char *name, bool isOpened)
{
  8044eb:	55                   	push   %ebp
  8044ec:	89 e5                	mov    %esp,%ebp
  8044ee:	83 ec 08             	sub    $0x8,%esp
	assert(isOpened == 0 || isOpened == 1);
  8044f1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8044f5:	74 1c                	je     804513 <init_uspinlock+0x28>
  8044f7:	83 7d 10 01          	cmpl   $0x1,0x10(%ebp)
  8044fb:	74 16                	je     804513 <init_uspinlock+0x28>
  8044fd:	68 a4 53 80 00       	push   $0x8053a4
  804502:	68 c3 53 80 00       	push   $0x8053c3
  804507:	6a 10                	push   $0x10
  804509:	68 d8 53 80 00       	push   $0x8053d8
  80450e:	e8 a4 c2 ff ff       	call   8007b7 <_panic>
	strcpy(lk->name, name);
  804513:	8b 45 08             	mov    0x8(%ebp),%eax
  804516:	83 c0 04             	add    $0x4,%eax
  804519:	83 ec 08             	sub    $0x8,%esp
  80451c:	ff 75 0c             	pushl  0xc(%ebp)
  80451f:	50                   	push   %eax
  804520:	e8 90 ce ff ff       	call   8013b5 <strcpy>
  804525:	83 c4 10             	add    $0x10,%esp
	lk->locked = (1 - isOpened);
  804528:	b8 01 00 00 00       	mov    $0x1,%eax
  80452d:	2b 45 10             	sub    0x10(%ebp),%eax
  804530:	89 c2                	mov    %eax,%edx
  804532:	8b 45 08             	mov    0x8(%ebp),%eax
  804535:	89 10                	mov    %edx,(%eax)
}
  804537:	90                   	nop
  804538:	c9                   	leave  
  804539:	c3                   	ret    

0080453a <acquire_uspinlock>:
// Acquire the lock.
// Loops (spins) until the lock is acquired.
// Holding a lock for a long time may cause
// other CPUs to waste time spinning to acquire it.
void acquire_uspinlock(struct uspinlock *lk)
{
  80453a:	55                   	push   %ebp
  80453b:	89 e5                	mov    %esp,%ebp
  80453d:	83 ec 18             	sub    $0x18,%esp
	// The xchg is atomic.
	while(xchg(&lk->locked, 1) != 0) ;
  804540:	90                   	nop
  804541:	8b 45 08             	mov    0x8(%ebp),%eax
  804544:	89 45 f4             	mov    %eax,-0xc(%ebp)
  804547:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
xchg(volatile uint32 *addr, uint32 newval)
{
  uint32 result;

  // The + in "+m" denotes a read-modify-write operand.
  __asm __volatile("lock; xchgl %0, %1" :
  80454e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  804551:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804554:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  804557:	f0 87 02             	lock xchg %eax,(%edx)
  80455a:	89 45 ec             	mov    %eax,-0x14(%ebp)
               "+m" (*addr), "=a" (result) :
               "1" (newval) :
               "cc");
  return result;
  80455d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  804560:	85 c0                	test   %eax,%eax
  804562:	75 dd                	jne    804541 <acquire_uspinlock+0x7>

	cprintf("[%d: %s] ACQUIRED spinlock [%s]\n", myEnv->env_id, myEnv->prog_name, lk->name);
  804564:	8b 45 08             	mov    0x8(%ebp),%eax
  804567:	8d 48 04             	lea    0x4(%eax),%ecx
  80456a:	a1 24 60 80 00       	mov    0x806024,%eax
  80456f:	8d 50 20             	lea    0x20(%eax),%edx
  804572:	a1 24 60 80 00       	mov    0x806024,%eax
  804577:	8b 40 10             	mov    0x10(%eax),%eax
  80457a:	51                   	push   %ecx
  80457b:	52                   	push   %edx
  80457c:	50                   	push   %eax
  80457d:	68 e8 53 80 00       	push   $0x8053e8
  804582:	e8 fe c4 ff ff       	call   800a85 <cprintf>
  804587:	83 c4 10             	add    $0x10,%esp

	// Tell the C compiler and the processor to not move loads or stores
	// past this point, to ensure that the critical section's memory
	// references happen after the lock is acquired.
	__sync_synchronize();
  80458a:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
}
  80458f:	90                   	nop
  804590:	c9                   	leave  
  804591:	c3                   	ret    

00804592 <release_uspinlock>:

// Release the lock.
void release_uspinlock(struct uspinlock *lk)
{
  804592:	55                   	push   %ebp
  804593:	89 e5                	mov    %esp,%ebp
  804595:	83 ec 08             	sub    $0x8,%esp
	if(!(lk->locked))
  804598:	8b 45 08             	mov    0x8(%ebp),%eax
  80459b:	8b 00                	mov    (%eax),%eax
  80459d:	85 c0                	test   %eax,%eax
  80459f:	75 18                	jne    8045b9 <release_uspinlock+0x27>
	{
		panic("release: lock \"%s\" is not held!", lk->name);
  8045a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8045a4:	83 c0 04             	add    $0x4,%eax
  8045a7:	50                   	push   %eax
  8045a8:	68 0c 54 80 00       	push   $0x80540c
  8045ad:	6a 2b                	push   $0x2b
  8045af:	68 d8 53 80 00       	push   $0x8053d8
  8045b4:	e8 fe c1 ff ff       	call   8007b7 <_panic>
	// Tell the C compiler and the processor to not move loads or stores
	// past this point, to ensure that all the stores in the critical
	// section are visible to other cores before the lock is released.
	// Both the C compiler and the hardware may re-order loads and
	// stores; __sync_synchronize() tells them both not to.
	__sync_synchronize();
  8045b9:	f0 83 0c 24 00       	lock orl $0x0,(%esp)

	// Release the lock, equivalent to lk->locked = 0.
	// This code can't use a C assignment, since it might
	// not be atomic. A real OS would use C atomics here.
	asm volatile("movl $0, %0" : "+m" (lk->locked) : );
  8045be:	8b 45 08             	mov    0x8(%ebp),%eax
  8045c1:	8b 55 08             	mov    0x8(%ebp),%edx
  8045c4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	cprintf("[%d: %s] RELEASED spinlock [%s]\n", myEnv->env_id, myEnv->prog_name, lk->name);
  8045ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8045cd:	8d 48 04             	lea    0x4(%eax),%ecx
  8045d0:	a1 24 60 80 00       	mov    0x806024,%eax
  8045d5:	8d 50 20             	lea    0x20(%eax),%edx
  8045d8:	a1 24 60 80 00       	mov    0x806024,%eax
  8045dd:	8b 40 10             	mov    0x10(%eax),%eax
  8045e0:	51                   	push   %ecx
  8045e1:	52                   	push   %edx
  8045e2:	50                   	push   %eax
  8045e3:	68 2c 54 80 00       	push   $0x80542c
  8045e8:	e8 98 c4 ff ff       	call   800a85 <cprintf>
  8045ed:	83 c4 10             	add    $0x10,%esp
}
  8045f0:	90                   	nop
  8045f1:	c9                   	leave  
  8045f2:	c3                   	ret    
  8045f3:	90                   	nop

008045f4 <__udivdi3>:
  8045f4:	55                   	push   %ebp
  8045f5:	57                   	push   %edi
  8045f6:	56                   	push   %esi
  8045f7:	53                   	push   %ebx
  8045f8:	83 ec 1c             	sub    $0x1c,%esp
  8045fb:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8045ff:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  804603:	8b 7c 24 38          	mov    0x38(%esp),%edi
  804607:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80460b:	89 ca                	mov    %ecx,%edx
  80460d:	89 f8                	mov    %edi,%eax
  80460f:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  804613:	85 f6                	test   %esi,%esi
  804615:	75 2d                	jne    804644 <__udivdi3+0x50>
  804617:	39 cf                	cmp    %ecx,%edi
  804619:	77 65                	ja     804680 <__udivdi3+0x8c>
  80461b:	89 fd                	mov    %edi,%ebp
  80461d:	85 ff                	test   %edi,%edi
  80461f:	75 0b                	jne    80462c <__udivdi3+0x38>
  804621:	b8 01 00 00 00       	mov    $0x1,%eax
  804626:	31 d2                	xor    %edx,%edx
  804628:	f7 f7                	div    %edi
  80462a:	89 c5                	mov    %eax,%ebp
  80462c:	31 d2                	xor    %edx,%edx
  80462e:	89 c8                	mov    %ecx,%eax
  804630:	f7 f5                	div    %ebp
  804632:	89 c1                	mov    %eax,%ecx
  804634:	89 d8                	mov    %ebx,%eax
  804636:	f7 f5                	div    %ebp
  804638:	89 cf                	mov    %ecx,%edi
  80463a:	89 fa                	mov    %edi,%edx
  80463c:	83 c4 1c             	add    $0x1c,%esp
  80463f:	5b                   	pop    %ebx
  804640:	5e                   	pop    %esi
  804641:	5f                   	pop    %edi
  804642:	5d                   	pop    %ebp
  804643:	c3                   	ret    
  804644:	39 ce                	cmp    %ecx,%esi
  804646:	77 28                	ja     804670 <__udivdi3+0x7c>
  804648:	0f bd fe             	bsr    %esi,%edi
  80464b:	83 f7 1f             	xor    $0x1f,%edi
  80464e:	75 40                	jne    804690 <__udivdi3+0x9c>
  804650:	39 ce                	cmp    %ecx,%esi
  804652:	72 0a                	jb     80465e <__udivdi3+0x6a>
  804654:	3b 44 24 08          	cmp    0x8(%esp),%eax
  804658:	0f 87 9e 00 00 00    	ja     8046fc <__udivdi3+0x108>
  80465e:	b8 01 00 00 00       	mov    $0x1,%eax
  804663:	89 fa                	mov    %edi,%edx
  804665:	83 c4 1c             	add    $0x1c,%esp
  804668:	5b                   	pop    %ebx
  804669:	5e                   	pop    %esi
  80466a:	5f                   	pop    %edi
  80466b:	5d                   	pop    %ebp
  80466c:	c3                   	ret    
  80466d:	8d 76 00             	lea    0x0(%esi),%esi
  804670:	31 ff                	xor    %edi,%edi
  804672:	31 c0                	xor    %eax,%eax
  804674:	89 fa                	mov    %edi,%edx
  804676:	83 c4 1c             	add    $0x1c,%esp
  804679:	5b                   	pop    %ebx
  80467a:	5e                   	pop    %esi
  80467b:	5f                   	pop    %edi
  80467c:	5d                   	pop    %ebp
  80467d:	c3                   	ret    
  80467e:	66 90                	xchg   %ax,%ax
  804680:	89 d8                	mov    %ebx,%eax
  804682:	f7 f7                	div    %edi
  804684:	31 ff                	xor    %edi,%edi
  804686:	89 fa                	mov    %edi,%edx
  804688:	83 c4 1c             	add    $0x1c,%esp
  80468b:	5b                   	pop    %ebx
  80468c:	5e                   	pop    %esi
  80468d:	5f                   	pop    %edi
  80468e:	5d                   	pop    %ebp
  80468f:	c3                   	ret    
  804690:	bd 20 00 00 00       	mov    $0x20,%ebp
  804695:	89 eb                	mov    %ebp,%ebx
  804697:	29 fb                	sub    %edi,%ebx
  804699:	89 f9                	mov    %edi,%ecx
  80469b:	d3 e6                	shl    %cl,%esi
  80469d:	89 c5                	mov    %eax,%ebp
  80469f:	88 d9                	mov    %bl,%cl
  8046a1:	d3 ed                	shr    %cl,%ebp
  8046a3:	89 e9                	mov    %ebp,%ecx
  8046a5:	09 f1                	or     %esi,%ecx
  8046a7:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8046ab:	89 f9                	mov    %edi,%ecx
  8046ad:	d3 e0                	shl    %cl,%eax
  8046af:	89 c5                	mov    %eax,%ebp
  8046b1:	89 d6                	mov    %edx,%esi
  8046b3:	88 d9                	mov    %bl,%cl
  8046b5:	d3 ee                	shr    %cl,%esi
  8046b7:	89 f9                	mov    %edi,%ecx
  8046b9:	d3 e2                	shl    %cl,%edx
  8046bb:	8b 44 24 08          	mov    0x8(%esp),%eax
  8046bf:	88 d9                	mov    %bl,%cl
  8046c1:	d3 e8                	shr    %cl,%eax
  8046c3:	09 c2                	or     %eax,%edx
  8046c5:	89 d0                	mov    %edx,%eax
  8046c7:	89 f2                	mov    %esi,%edx
  8046c9:	f7 74 24 0c          	divl   0xc(%esp)
  8046cd:	89 d6                	mov    %edx,%esi
  8046cf:	89 c3                	mov    %eax,%ebx
  8046d1:	f7 e5                	mul    %ebp
  8046d3:	39 d6                	cmp    %edx,%esi
  8046d5:	72 19                	jb     8046f0 <__udivdi3+0xfc>
  8046d7:	74 0b                	je     8046e4 <__udivdi3+0xf0>
  8046d9:	89 d8                	mov    %ebx,%eax
  8046db:	31 ff                	xor    %edi,%edi
  8046dd:	e9 58 ff ff ff       	jmp    80463a <__udivdi3+0x46>
  8046e2:	66 90                	xchg   %ax,%ax
  8046e4:	8b 54 24 08          	mov    0x8(%esp),%edx
  8046e8:	89 f9                	mov    %edi,%ecx
  8046ea:	d3 e2                	shl    %cl,%edx
  8046ec:	39 c2                	cmp    %eax,%edx
  8046ee:	73 e9                	jae    8046d9 <__udivdi3+0xe5>
  8046f0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8046f3:	31 ff                	xor    %edi,%edi
  8046f5:	e9 40 ff ff ff       	jmp    80463a <__udivdi3+0x46>
  8046fa:	66 90                	xchg   %ax,%ax
  8046fc:	31 c0                	xor    %eax,%eax
  8046fe:	e9 37 ff ff ff       	jmp    80463a <__udivdi3+0x46>
  804703:	90                   	nop

00804704 <__umoddi3>:
  804704:	55                   	push   %ebp
  804705:	57                   	push   %edi
  804706:	56                   	push   %esi
  804707:	53                   	push   %ebx
  804708:	83 ec 1c             	sub    $0x1c,%esp
  80470b:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80470f:	8b 74 24 34          	mov    0x34(%esp),%esi
  804713:	8b 7c 24 38          	mov    0x38(%esp),%edi
  804717:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80471b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80471f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  804723:	89 f3                	mov    %esi,%ebx
  804725:	89 fa                	mov    %edi,%edx
  804727:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80472b:	89 34 24             	mov    %esi,(%esp)
  80472e:	85 c0                	test   %eax,%eax
  804730:	75 1a                	jne    80474c <__umoddi3+0x48>
  804732:	39 f7                	cmp    %esi,%edi
  804734:	0f 86 a2 00 00 00    	jbe    8047dc <__umoddi3+0xd8>
  80473a:	89 c8                	mov    %ecx,%eax
  80473c:	89 f2                	mov    %esi,%edx
  80473e:	f7 f7                	div    %edi
  804740:	89 d0                	mov    %edx,%eax
  804742:	31 d2                	xor    %edx,%edx
  804744:	83 c4 1c             	add    $0x1c,%esp
  804747:	5b                   	pop    %ebx
  804748:	5e                   	pop    %esi
  804749:	5f                   	pop    %edi
  80474a:	5d                   	pop    %ebp
  80474b:	c3                   	ret    
  80474c:	39 f0                	cmp    %esi,%eax
  80474e:	0f 87 ac 00 00 00    	ja     804800 <__umoddi3+0xfc>
  804754:	0f bd e8             	bsr    %eax,%ebp
  804757:	83 f5 1f             	xor    $0x1f,%ebp
  80475a:	0f 84 ac 00 00 00    	je     80480c <__umoddi3+0x108>
  804760:	bf 20 00 00 00       	mov    $0x20,%edi
  804765:	29 ef                	sub    %ebp,%edi
  804767:	89 fe                	mov    %edi,%esi
  804769:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80476d:	89 e9                	mov    %ebp,%ecx
  80476f:	d3 e0                	shl    %cl,%eax
  804771:	89 d7                	mov    %edx,%edi
  804773:	89 f1                	mov    %esi,%ecx
  804775:	d3 ef                	shr    %cl,%edi
  804777:	09 c7                	or     %eax,%edi
  804779:	89 e9                	mov    %ebp,%ecx
  80477b:	d3 e2                	shl    %cl,%edx
  80477d:	89 14 24             	mov    %edx,(%esp)
  804780:	89 d8                	mov    %ebx,%eax
  804782:	d3 e0                	shl    %cl,%eax
  804784:	89 c2                	mov    %eax,%edx
  804786:	8b 44 24 08          	mov    0x8(%esp),%eax
  80478a:	d3 e0                	shl    %cl,%eax
  80478c:	89 44 24 04          	mov    %eax,0x4(%esp)
  804790:	8b 44 24 08          	mov    0x8(%esp),%eax
  804794:	89 f1                	mov    %esi,%ecx
  804796:	d3 e8                	shr    %cl,%eax
  804798:	09 d0                	or     %edx,%eax
  80479a:	d3 eb                	shr    %cl,%ebx
  80479c:	89 da                	mov    %ebx,%edx
  80479e:	f7 f7                	div    %edi
  8047a0:	89 d3                	mov    %edx,%ebx
  8047a2:	f7 24 24             	mull   (%esp)
  8047a5:	89 c6                	mov    %eax,%esi
  8047a7:	89 d1                	mov    %edx,%ecx
  8047a9:	39 d3                	cmp    %edx,%ebx
  8047ab:	0f 82 87 00 00 00    	jb     804838 <__umoddi3+0x134>
  8047b1:	0f 84 91 00 00 00    	je     804848 <__umoddi3+0x144>
  8047b7:	8b 54 24 04          	mov    0x4(%esp),%edx
  8047bb:	29 f2                	sub    %esi,%edx
  8047bd:	19 cb                	sbb    %ecx,%ebx
  8047bf:	89 d8                	mov    %ebx,%eax
  8047c1:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8047c5:	d3 e0                	shl    %cl,%eax
  8047c7:	89 e9                	mov    %ebp,%ecx
  8047c9:	d3 ea                	shr    %cl,%edx
  8047cb:	09 d0                	or     %edx,%eax
  8047cd:	89 e9                	mov    %ebp,%ecx
  8047cf:	d3 eb                	shr    %cl,%ebx
  8047d1:	89 da                	mov    %ebx,%edx
  8047d3:	83 c4 1c             	add    $0x1c,%esp
  8047d6:	5b                   	pop    %ebx
  8047d7:	5e                   	pop    %esi
  8047d8:	5f                   	pop    %edi
  8047d9:	5d                   	pop    %ebp
  8047da:	c3                   	ret    
  8047db:	90                   	nop
  8047dc:	89 fd                	mov    %edi,%ebp
  8047de:	85 ff                	test   %edi,%edi
  8047e0:	75 0b                	jne    8047ed <__umoddi3+0xe9>
  8047e2:	b8 01 00 00 00       	mov    $0x1,%eax
  8047e7:	31 d2                	xor    %edx,%edx
  8047e9:	f7 f7                	div    %edi
  8047eb:	89 c5                	mov    %eax,%ebp
  8047ed:	89 f0                	mov    %esi,%eax
  8047ef:	31 d2                	xor    %edx,%edx
  8047f1:	f7 f5                	div    %ebp
  8047f3:	89 c8                	mov    %ecx,%eax
  8047f5:	f7 f5                	div    %ebp
  8047f7:	89 d0                	mov    %edx,%eax
  8047f9:	e9 44 ff ff ff       	jmp    804742 <__umoddi3+0x3e>
  8047fe:	66 90                	xchg   %ax,%ax
  804800:	89 c8                	mov    %ecx,%eax
  804802:	89 f2                	mov    %esi,%edx
  804804:	83 c4 1c             	add    $0x1c,%esp
  804807:	5b                   	pop    %ebx
  804808:	5e                   	pop    %esi
  804809:	5f                   	pop    %edi
  80480a:	5d                   	pop    %ebp
  80480b:	c3                   	ret    
  80480c:	3b 04 24             	cmp    (%esp),%eax
  80480f:	72 06                	jb     804817 <__umoddi3+0x113>
  804811:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  804815:	77 0f                	ja     804826 <__umoddi3+0x122>
  804817:	89 f2                	mov    %esi,%edx
  804819:	29 f9                	sub    %edi,%ecx
  80481b:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  80481f:	89 14 24             	mov    %edx,(%esp)
  804822:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  804826:	8b 44 24 04          	mov    0x4(%esp),%eax
  80482a:	8b 14 24             	mov    (%esp),%edx
  80482d:	83 c4 1c             	add    $0x1c,%esp
  804830:	5b                   	pop    %ebx
  804831:	5e                   	pop    %esi
  804832:	5f                   	pop    %edi
  804833:	5d                   	pop    %ebp
  804834:	c3                   	ret    
  804835:	8d 76 00             	lea    0x0(%esi),%esi
  804838:	2b 04 24             	sub    (%esp),%eax
  80483b:	19 fa                	sbb    %edi,%edx
  80483d:	89 d1                	mov    %edx,%ecx
  80483f:	89 c6                	mov    %eax,%esi
  804841:	e9 71 ff ff ff       	jmp    8047b7 <__umoddi3+0xb3>
  804846:	66 90                	xchg   %ax,%ax
  804848:	39 44 24 04          	cmp    %eax,0x4(%esp)
  80484c:	72 ea                	jb     804838 <__umoddi3+0x134>
  80484e:	89 d9                	mov    %ebx,%ecx
  804850:	e9 62 ff ff ff       	jmp    8047b7 <__umoddi3+0xb3>
