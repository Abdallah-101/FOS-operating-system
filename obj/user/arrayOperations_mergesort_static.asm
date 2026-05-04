
obj/user/arrayOperations_mergesort_static:     file format elf32-i386


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
  800031:	e8 91 04 00 00       	call   8004c7 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:

//int *Left;
//int *Right;

void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	83 ec 38             	sub    $0x38,%esp
	int32 parentenvID = sys_getparentenvid();
  80003e:	e8 6a 32 00 00       	call   8032ad <sys_getparentenvid>
  800043:	89 45 f0             	mov    %eax,-0x10(%ebp)

	int ret;

	/*[1] GET SEMAPHORES*/
	struct semaphore ready = get_semaphore(parentenvID, "Ready");
  800046:	8d 45 dc             	lea    -0x24(%ebp),%eax
  800049:	83 ec 04             	sub    $0x4,%esp
  80004c:	68 a0 45 80 00       	push   $0x8045a0
  800051:	ff 75 f0             	pushl  -0x10(%ebp)
  800054:	50                   	push   %eax
  800055:	e8 7e 3f 00 00       	call   803fd8 <get_semaphore>
  80005a:	83 c4 0c             	add    $0xc,%esp
	struct semaphore finished = get_semaphore(parentenvID, "Finished");
  80005d:	8d 45 d8             	lea    -0x28(%ebp),%eax
  800060:	83 ec 04             	sub    $0x4,%esp
  800063:	68 a6 45 80 00       	push   $0x8045a6
  800068:	ff 75 f0             	pushl  -0x10(%ebp)
  80006b:	50                   	push   %eax
  80006c:	e8 67 3f 00 00       	call   803fd8 <get_semaphore>
  800071:	83 c4 0c             	add    $0xc,%esp

	/*[2] WAIT A READY SIGNAL FROM THE MASTER*/
	wait_semaphore(ready);
  800074:	83 ec 0c             	sub    $0xc,%esp
  800077:	ff 75 dc             	pushl  -0x24(%ebp)
  80007a:	e8 73 3f 00 00       	call   803ff2 <wait_semaphore>
  80007f:	83 c4 10             	add    $0x10,%esp

	/*[3] GET SHARED VARs*/
	//Get the cons_mutex ownerID
	int* consMutexOwnerID = sget(parentenvID, "cons_mutex ownerID") ;
  800082:	83 ec 08             	sub    $0x8,%esp
  800085:	68 af 45 80 00       	push   $0x8045af
  80008a:	ff 75 f0             	pushl  -0x10(%ebp)
  80008d:	e8 1c 29 00 00       	call   8029ae <sget>
  800092:	83 c4 10             	add    $0x10,%esp
  800095:	89 45 ec             	mov    %eax,-0x14(%ebp)
	struct semaphore cons_mutex = get_semaphore(*consMutexOwnerID, "Console Mutex");
  800098:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80009b:	8b 10                	mov    (%eax),%edx
  80009d:	8d 45 d4             	lea    -0x2c(%ebp),%eax
  8000a0:	83 ec 04             	sub    $0x4,%esp
  8000a3:	68 c2 45 80 00       	push   $0x8045c2
  8000a8:	52                   	push   %edx
  8000a9:	50                   	push   %eax
  8000aa:	e8 29 3f 00 00       	call   803fd8 <get_semaphore>
  8000af:	83 c4 0c             	add    $0xc,%esp

	//Get the shared array & its size
	int *numOfElements = NULL;
  8000b2:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	int *sharedArray = NULL;
  8000b9:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	sharedArray = sget(parentenvID, "arr") ;
  8000c0:	83 ec 08             	sub    $0x8,%esp
  8000c3:	68 d0 45 80 00       	push   $0x8045d0
  8000c8:	ff 75 f0             	pushl  -0x10(%ebp)
  8000cb:	e8 de 28 00 00       	call   8029ae <sget>
  8000d0:	83 c4 10             	add    $0x10,%esp
  8000d3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	numOfElements = sget(parentenvID, "arrSize") ;
  8000d6:	83 ec 08             	sub    $0x8,%esp
  8000d9:	68 d4 45 80 00       	push   $0x8045d4
  8000de:	ff 75 f0             	pushl  -0x10(%ebp)
  8000e1:	e8 c8 28 00 00       	call   8029ae <sget>
  8000e6:	83 c4 10             	add    $0x10,%esp
  8000e9:	89 45 e8             	mov    %eax,-0x18(%ebp)

	/*[4] DO THE JOB*/
	//take a copy from the original array
	int *sortedArray;

	sortedArray = smalloc("mergesortedArr", sizeof(int) * *numOfElements, 0) ;
  8000ec:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8000ef:	8b 00                	mov    (%eax),%eax
  8000f1:	c1 e0 02             	shl    $0x2,%eax
  8000f4:	83 ec 04             	sub    $0x4,%esp
  8000f7:	6a 00                	push   $0x0
  8000f9:	50                   	push   %eax
  8000fa:	68 dc 45 80 00       	push   $0x8045dc
  8000ff:	e8 03 23 00 00       	call   802407 <smalloc>
  800104:	83 c4 10             	add    $0x10,%esp
  800107:	89 45 e0             	mov    %eax,-0x20(%ebp)
	int i ;
	for (i = 0 ; i < *numOfElements ; i++)
  80010a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800111:	eb 25                	jmp    800138 <_main+0x100>
	{
		sortedArray[i] = sharedArray[i];
  800113:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800116:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80011d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800120:	01 c2                	add    %eax,%edx
  800122:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800125:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80012c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80012f:	01 c8                	add    %ecx,%eax
  800131:	8b 00                	mov    (%eax),%eax
  800133:	89 02                	mov    %eax,(%edx)
	//take a copy from the original array
	int *sortedArray;

	sortedArray = smalloc("mergesortedArr", sizeof(int) * *numOfElements, 0) ;
	int i ;
	for (i = 0 ; i < *numOfElements ; i++)
  800135:	ff 45 f4             	incl   -0xc(%ebp)
  800138:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80013b:	8b 00                	mov    (%eax),%eax
  80013d:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800140:	7f d1                	jg     800113 <_main+0xdb>
	}
//	//Create two temps array for "left" & "right"
//	Left = smalloc("mergesortLeftArr", sizeof(int) * (*numOfElements), 1) ;
//	Right = smalloc("mergesortRightArr", sizeof(int) * (*numOfElements), 1) ;

	MSort(sortedArray, 1, *numOfElements);
  800142:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800145:	8b 00                	mov    (%eax),%eax
  800147:	83 ec 04             	sub    $0x4,%esp
  80014a:	50                   	push   %eax
  80014b:	6a 01                	push   $0x1
  80014d:	ff 75 e0             	pushl  -0x20(%ebp)
  800150:	e8 39 01 00 00       	call   80028e <MSort>
  800155:	83 c4 10             	add    $0x10,%esp

	wait_semaphore(cons_mutex);
  800158:	83 ec 0c             	sub    $0xc,%esp
  80015b:	ff 75 d4             	pushl  -0x2c(%ebp)
  80015e:	e8 8f 3e 00 00       	call   803ff2 <wait_semaphore>
  800163:	83 c4 10             	add    $0x10,%esp
	{
		cprintf("Merge sort is Finished!!!!\n") ;
  800166:	83 ec 0c             	sub    $0xc,%esp
  800169:	68 eb 45 80 00       	push   $0x8045eb
  80016e:	e8 ed 05 00 00       	call   800760 <cprintf>
  800173:	83 c4 10             	add    $0x10,%esp
		cprintf("will notify the master now...\n");
  800176:	83 ec 0c             	sub    $0xc,%esp
  800179:	68 08 46 80 00       	push   $0x804608
  80017e:	e8 dd 05 00 00       	call   800760 <cprintf>
  800183:	83 c4 10             	add    $0x10,%esp
		cprintf("Merge sort says GOOD BYE :)\n") ;
  800186:	83 ec 0c             	sub    $0xc,%esp
  800189:	68 27 46 80 00       	push   $0x804627
  80018e:	e8 cd 05 00 00       	call   800760 <cprintf>
  800193:	83 c4 10             	add    $0x10,%esp
	}
	signal_semaphore(cons_mutex);
  800196:	83 ec 0c             	sub    $0xc,%esp
  800199:	ff 75 d4             	pushl  -0x2c(%ebp)
  80019c:	e8 6b 3e 00 00       	call   80400c <signal_semaphore>
  8001a1:	83 c4 10             	add    $0x10,%esp

	/*[5] DECLARE FINISHING*/
	signal_semaphore(finished);
  8001a4:	83 ec 0c             	sub    $0xc,%esp
  8001a7:	ff 75 d8             	pushl  -0x28(%ebp)
  8001aa:	e8 5d 3e 00 00       	call   80400c <signal_semaphore>
  8001af:	83 c4 10             	add    $0x10,%esp
}
  8001b2:	90                   	nop
  8001b3:	c9                   	leave  
  8001b4:	c3                   	ret    

008001b5 <Swap>:

void Swap(int *Elements, int First, int Second)
{
  8001b5:	55                   	push   %ebp
  8001b6:	89 e5                	mov    %esp,%ebp
  8001b8:	83 ec 10             	sub    $0x10,%esp
	int Tmp = Elements[First] ;
  8001bb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001be:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8001c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8001c8:	01 d0                	add    %edx,%eax
  8001ca:	8b 00                	mov    (%eax),%eax
  8001cc:	89 45 fc             	mov    %eax,-0x4(%ebp)
	Elements[First] = Elements[Second] ;
  8001cf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001d2:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8001d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8001dc:	01 c2                	add    %eax,%edx
  8001de:	8b 45 10             	mov    0x10(%ebp),%eax
  8001e1:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8001e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8001eb:	01 c8                	add    %ecx,%eax
  8001ed:	8b 00                	mov    (%eax),%eax
  8001ef:	89 02                	mov    %eax,(%edx)
	Elements[Second] = Tmp ;
  8001f1:	8b 45 10             	mov    0x10(%ebp),%eax
  8001f4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8001fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8001fe:	01 c2                	add    %eax,%edx
  800200:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800203:	89 02                	mov    %eax,(%edx)
}
  800205:	90                   	nop
  800206:	c9                   	leave  
  800207:	c3                   	ret    

00800208 <PrintElements>:


void PrintElements(int *Elements, int NumOfElements)
{
  800208:	55                   	push   %ebp
  800209:	89 e5                	mov    %esp,%ebp
  80020b:	83 ec 18             	sub    $0x18,%esp
	int i ;
	int NumsPerLine = 20 ;
  80020e:	c7 45 f0 14 00 00 00 	movl   $0x14,-0x10(%ebp)
	for (i = 0 ; i < NumOfElements-1 ; i++)
  800215:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80021c:	eb 42                	jmp    800260 <PrintElements+0x58>
	{
		if (i%NumsPerLine == 0)
  80021e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800221:	99                   	cltd   
  800222:	f7 7d f0             	idivl  -0x10(%ebp)
  800225:	89 d0                	mov    %edx,%eax
  800227:	85 c0                	test   %eax,%eax
  800229:	75 10                	jne    80023b <PrintElements+0x33>
			cprintf("\n");
  80022b:	83 ec 0c             	sub    $0xc,%esp
  80022e:	68 44 46 80 00       	push   $0x804644
  800233:	e8 28 05 00 00       	call   800760 <cprintf>
  800238:	83 c4 10             	add    $0x10,%esp
		cprintf("%d, ",Elements[i]);
  80023b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80023e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800245:	8b 45 08             	mov    0x8(%ebp),%eax
  800248:	01 d0                	add    %edx,%eax
  80024a:	8b 00                	mov    (%eax),%eax
  80024c:	83 ec 08             	sub    $0x8,%esp
  80024f:	50                   	push   %eax
  800250:	68 46 46 80 00       	push   $0x804646
  800255:	e8 06 05 00 00       	call   800760 <cprintf>
  80025a:	83 c4 10             	add    $0x10,%esp

void PrintElements(int *Elements, int NumOfElements)
{
	int i ;
	int NumsPerLine = 20 ;
	for (i = 0 ; i < NumOfElements-1 ; i++)
  80025d:	ff 45 f4             	incl   -0xc(%ebp)
  800260:	8b 45 0c             	mov    0xc(%ebp),%eax
  800263:	48                   	dec    %eax
  800264:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800267:	7f b5                	jg     80021e <PrintElements+0x16>
	{
		if (i%NumsPerLine == 0)
			cprintf("\n");
		cprintf("%d, ",Elements[i]);
	}
	cprintf("%d\n",Elements[i]);
  800269:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80026c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800273:	8b 45 08             	mov    0x8(%ebp),%eax
  800276:	01 d0                	add    %edx,%eax
  800278:	8b 00                	mov    (%eax),%eax
  80027a:	83 ec 08             	sub    $0x8,%esp
  80027d:	50                   	push   %eax
  80027e:	68 4b 46 80 00       	push   $0x80464b
  800283:	e8 d8 04 00 00       	call   800760 <cprintf>
  800288:	83 c4 10             	add    $0x10,%esp

}
  80028b:	90                   	nop
  80028c:	c9                   	leave  
  80028d:	c3                   	ret    

0080028e <MSort>:


void MSort(int* A, int p, int r)
{
  80028e:	55                   	push   %ebp
  80028f:	89 e5                	mov    %esp,%ebp
  800291:	83 ec 18             	sub    $0x18,%esp
	if (p >= r)
  800294:	8b 45 0c             	mov    0xc(%ebp),%eax
  800297:	3b 45 10             	cmp    0x10(%ebp),%eax
  80029a:	7d 54                	jge    8002f0 <MSort+0x62>
	{
		return;
	}

	int q = (p + r) / 2;
  80029c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80029f:	8b 45 10             	mov    0x10(%ebp),%eax
  8002a2:	01 d0                	add    %edx,%eax
  8002a4:	89 c2                	mov    %eax,%edx
  8002a6:	c1 ea 1f             	shr    $0x1f,%edx
  8002a9:	01 d0                	add    %edx,%eax
  8002ab:	d1 f8                	sar    %eax
  8002ad:	89 45 f4             	mov    %eax,-0xc(%ebp)

	MSort(A, p, q);
  8002b0:	83 ec 04             	sub    $0x4,%esp
  8002b3:	ff 75 f4             	pushl  -0xc(%ebp)
  8002b6:	ff 75 0c             	pushl  0xc(%ebp)
  8002b9:	ff 75 08             	pushl  0x8(%ebp)
  8002bc:	e8 cd ff ff ff       	call   80028e <MSort>
  8002c1:	83 c4 10             	add    $0x10,%esp
//	cprintf("LEFT is sorted: from %d to %d\n", p, q);

	MSort(A, q + 1, r);
  8002c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8002c7:	40                   	inc    %eax
  8002c8:	83 ec 04             	sub    $0x4,%esp
  8002cb:	ff 75 10             	pushl  0x10(%ebp)
  8002ce:	50                   	push   %eax
  8002cf:	ff 75 08             	pushl  0x8(%ebp)
  8002d2:	e8 b7 ff ff ff       	call   80028e <MSort>
  8002d7:	83 c4 10             	add    $0x10,%esp
//	cprintf("RIGHT is sorted: from %d to %d\n", q+1, r);

	Merge(A, p, q, r);
  8002da:	ff 75 10             	pushl  0x10(%ebp)
  8002dd:	ff 75 f4             	pushl  -0xc(%ebp)
  8002e0:	ff 75 0c             	pushl  0xc(%ebp)
  8002e3:	ff 75 08             	pushl  0x8(%ebp)
  8002e6:	e8 08 00 00 00       	call   8002f3 <Merge>
  8002eb:	83 c4 10             	add    $0x10,%esp
  8002ee:	eb 01                	jmp    8002f1 <MSort+0x63>

void MSort(int* A, int p, int r)
{
	if (p >= r)
	{
		return;
  8002f0:	90                   	nop
//	cprintf("RIGHT is sorted: from %d to %d\n", q+1, r);

	Merge(A, p, q, r);
	//cprintf("[%d %d] + [%d %d] = [%d %d]\n", p, q, q+1, r, p, r);

}
  8002f1:	c9                   	leave  
  8002f2:	c3                   	ret    

008002f3 <Merge>:

void Merge(int* A, int p, int q, int r)
{
  8002f3:	55                   	push   %ebp
  8002f4:	89 e5                	mov    %esp,%ebp
  8002f6:	83 ec 30             	sub    $0x30,%esp
	int leftCapacity = q - p + 1;
  8002f9:	8b 45 10             	mov    0x10(%ebp),%eax
  8002fc:	2b 45 0c             	sub    0xc(%ebp),%eax
  8002ff:	40                   	inc    %eax
  800300:	89 45 e8             	mov    %eax,-0x18(%ebp)

	int rightCapacity = r - q;
  800303:	8b 45 14             	mov    0x14(%ebp),%eax
  800306:	2b 45 10             	sub    0x10(%ebp),%eax
  800309:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	int leftIndex = 0;
  80030c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)

	int rightIndex = 0;
  800313:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	//int* Left = malloc(sizeof(int) * leftCapacity);
	int* Left = __Left ;
  80031a:	c7 45 e0 60 60 80 00 	movl   $0x806060,-0x20(%ebp)
	int* Right = __Right;
  800321:	c7 45 dc c0 fb 87 00 	movl   $0x87fbc0,-0x24(%ebp)
	//int* Right = malloc(sizeof(int) * rightCapacity);

	int i, j, k;
	for (i = 0; i < leftCapacity; i++)
  800328:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80032f:	eb 2f                	jmp    800360 <Merge+0x6d>
	{
		Left[i] = A[p + i - 1];
  800331:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800334:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80033b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80033e:	01 c2                	add    %eax,%edx
  800340:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800343:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800346:	01 c8                	add    %ecx,%eax
  800348:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  80034d:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800354:	8b 45 08             	mov    0x8(%ebp),%eax
  800357:	01 c8                	add    %ecx,%eax
  800359:	8b 00                	mov    (%eax),%eax
  80035b:	89 02                	mov    %eax,(%edx)
	int* Left = __Left ;
	int* Right = __Right;
	//int* Right = malloc(sizeof(int) * rightCapacity);

	int i, j, k;
	for (i = 0; i < leftCapacity; i++)
  80035d:	ff 45 f4             	incl   -0xc(%ebp)
  800360:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800363:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  800366:	7c c9                	jl     800331 <Merge+0x3e>
	{
		Left[i] = A[p + i - 1];
	}
	for (j = 0; j < rightCapacity; j++)
  800368:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80036f:	eb 2a                	jmp    80039b <Merge+0xa8>
	{
		Right[j] = A[q + j];
  800371:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800374:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80037b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80037e:	01 c2                	add    %eax,%edx
  800380:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800383:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800386:	01 c8                	add    %ecx,%eax
  800388:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80038f:	8b 45 08             	mov    0x8(%ebp),%eax
  800392:	01 c8                	add    %ecx,%eax
  800394:	8b 00                	mov    (%eax),%eax
  800396:	89 02                	mov    %eax,(%edx)
	int i, j, k;
	for (i = 0; i < leftCapacity; i++)
	{
		Left[i] = A[p + i - 1];
	}
	for (j = 0; j < rightCapacity; j++)
  800398:	ff 45 f0             	incl   -0x10(%ebp)
  80039b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80039e:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8003a1:	7c ce                	jl     800371 <Merge+0x7e>
	{
		Right[j] = A[q + j];
	}

	for ( k = p; k <= r; k++)
  8003a3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003a6:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8003a9:	e9 0a 01 00 00       	jmp    8004b8 <Merge+0x1c5>
	{
		if (leftIndex < leftCapacity && rightIndex < rightCapacity)
  8003ae:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8003b1:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8003b4:	0f 8d 95 00 00 00    	jge    80044f <Merge+0x15c>
  8003ba:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8003bd:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8003c0:	0f 8d 89 00 00 00    	jge    80044f <Merge+0x15c>
		{
			if (Left[leftIndex] < Right[rightIndex] )
  8003c6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8003c9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003d0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8003d3:	01 d0                	add    %edx,%eax
  8003d5:	8b 10                	mov    (%eax),%edx
  8003d7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8003da:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8003e1:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8003e4:	01 c8                	add    %ecx,%eax
  8003e6:	8b 00                	mov    (%eax),%eax
  8003e8:	39 c2                	cmp    %eax,%edx
  8003ea:	7d 33                	jge    80041f <Merge+0x12c>
			{
				A[k - 1] = Left[leftIndex++];
  8003ec:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8003ef:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  8003f4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8003fe:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  800401:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800404:	8d 50 01             	lea    0x1(%eax),%edx
  800407:	89 55 fc             	mov    %edx,-0x4(%ebp)
  80040a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800411:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800414:	01 d0                	add    %edx,%eax
  800416:	8b 00                	mov    (%eax),%eax
  800418:	89 01                	mov    %eax,(%ecx)

	for ( k = p; k <= r; k++)
	{
		if (leftIndex < leftCapacity && rightIndex < rightCapacity)
		{
			if (Left[leftIndex] < Right[rightIndex] )
  80041a:	e9 96 00 00 00       	jmp    8004b5 <Merge+0x1c2>
			{
				A[k - 1] = Left[leftIndex++];
			}
			else
			{
				A[k - 1] = Right[rightIndex++];
  80041f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800422:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  800427:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80042e:	8b 45 08             	mov    0x8(%ebp),%eax
  800431:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  800434:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800437:	8d 50 01             	lea    0x1(%eax),%edx
  80043a:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80043d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800444:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800447:	01 d0                	add    %edx,%eax
  800449:	8b 00                	mov    (%eax),%eax
  80044b:	89 01                	mov    %eax,(%ecx)

	for ( k = p; k <= r; k++)
	{
		if (leftIndex < leftCapacity && rightIndex < rightCapacity)
		{
			if (Left[leftIndex] < Right[rightIndex] )
  80044d:	eb 66                	jmp    8004b5 <Merge+0x1c2>
			else
			{
				A[k - 1] = Right[rightIndex++];
			}
		}
		else if (leftIndex < leftCapacity)
  80044f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800452:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  800455:	7d 30                	jge    800487 <Merge+0x194>
		{
			A[k - 1] = Left[leftIndex++];
  800457:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80045a:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  80045f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800466:	8b 45 08             	mov    0x8(%ebp),%eax
  800469:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  80046c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80046f:	8d 50 01             	lea    0x1(%eax),%edx
  800472:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800475:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80047c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80047f:	01 d0                	add    %edx,%eax
  800481:	8b 00                	mov    (%eax),%eax
  800483:	89 01                	mov    %eax,(%ecx)
  800485:	eb 2e                	jmp    8004b5 <Merge+0x1c2>
		}
		else
		{
			A[k - 1] = Right[rightIndex++];
  800487:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80048a:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  80048f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800496:	8b 45 08             	mov    0x8(%ebp),%eax
  800499:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  80049c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80049f:	8d 50 01             	lea    0x1(%eax),%edx
  8004a2:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8004a5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8004ac:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8004af:	01 d0                	add    %edx,%eax
  8004b1:	8b 00                	mov    (%eax),%eax
  8004b3:	89 01                	mov    %eax,(%ecx)
	for (j = 0; j < rightCapacity; j++)
	{
		Right[j] = A[q + j];
	}

	for ( k = p; k <= r; k++)
  8004b5:	ff 45 ec             	incl   -0x14(%ebp)
  8004b8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8004bb:	3b 45 14             	cmp    0x14(%ebp),%eax
  8004be:	0f 8e ea fe ff ff    	jle    8003ae <Merge+0xbb>
		{
			A[k - 1] = Right[rightIndex++];
		}
	}

}
  8004c4:	90                   	nop
  8004c5:	c9                   	leave  
  8004c6:	c3                   	ret    

008004c7 <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  8004c7:	55                   	push   %ebp
  8004c8:	89 e5                	mov    %esp,%ebp
  8004ca:	57                   	push   %edi
  8004cb:	56                   	push   %esi
  8004cc:	53                   	push   %ebx
  8004cd:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  8004d0:	e8 bf 2d 00 00       	call   803294 <sys_getenvindex>
  8004d5:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  8004d8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8004db:	89 d0                	mov    %edx,%eax
  8004dd:	c1 e0 02             	shl    $0x2,%eax
  8004e0:	01 d0                	add    %edx,%eax
  8004e2:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8004e9:	01 d0                	add    %edx,%eax
  8004eb:	89 c2                	mov    %eax,%edx
  8004ed:	c1 e2 04             	shl    $0x4,%edx
  8004f0:	29 c2                	sub    %eax,%edx
  8004f2:	8d 04 95 00 00 00 00 	lea    0x0(,%edx,4),%eax
  8004f9:	89 c2                	mov    %eax,%edx
  8004fb:	8d 82 00 00 c0 ee    	lea    -0x11400000(%edx),%eax
  800501:	a3 20 60 80 00       	mov    %eax,0x806020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800506:	a1 20 60 80 00       	mov    0x806020,%eax
  80050b:	8a 40 20             	mov    0x20(%eax),%al
  80050e:	84 c0                	test   %al,%al
  800510:	74 0d                	je     80051f <libmain+0x58>
		binaryname = myEnv->prog_name;
  800512:	a1 20 60 80 00       	mov    0x806020,%eax
  800517:	83 c0 20             	add    $0x20,%eax
  80051a:	a3 04 60 80 00       	mov    %eax,0x806004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80051f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800523:	7e 0a                	jle    80052f <libmain+0x68>
		binaryname = argv[0];
  800525:	8b 45 0c             	mov    0xc(%ebp),%eax
  800528:	8b 00                	mov    (%eax),%eax
  80052a:	a3 04 60 80 00       	mov    %eax,0x806004

	// call user main routine
	_main(argc, argv);
  80052f:	83 ec 08             	sub    $0x8,%esp
  800532:	ff 75 0c             	pushl  0xc(%ebp)
  800535:	ff 75 08             	pushl  0x8(%ebp)
  800538:	e8 fb fa ff ff       	call   800038 <_main>
  80053d:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  800540:	a1 00 60 80 00       	mov    0x806000,%eax
  800545:	85 c0                	test   %eax,%eax
  800547:	0f 84 01 01 00 00    	je     80064e <libmain+0x187>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  80054d:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  800553:	bb 48 47 80 00       	mov    $0x804748,%ebx
  800558:	ba 0e 00 00 00       	mov    $0xe,%edx
  80055d:	89 c7                	mov    %eax,%edi
  80055f:	89 de                	mov    %ebx,%esi
  800561:	89 d1                	mov    %edx,%ecx
  800563:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  800565:	8d 55 8a             	lea    -0x76(%ebp),%edx
  800568:	b9 56 00 00 00       	mov    $0x56,%ecx
  80056d:	b0 00                	mov    $0x0,%al
  80056f:	89 d7                	mov    %edx,%edi
  800571:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  800573:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  80057a:	8d 45 e0             	lea    -0x20(%ebp),%eax
  80057d:	83 ec 08             	sub    $0x8,%esp
  800580:	50                   	push   %eax
  800581:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  800587:	50                   	push   %eax
  800588:	e8 3d 2f 00 00       	call   8034ca <sys_utilities>
  80058d:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  800590:	e8 86 2a 00 00       	call   80301b <sys_lock_cons>
		{
			cprintf("**************************************\n");
  800595:	83 ec 0c             	sub    $0xc,%esp
  800598:	68 68 46 80 00       	push   $0x804668
  80059d:	e8 be 01 00 00       	call   800760 <cprintf>
  8005a2:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  8005a5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8005a8:	85 c0                	test   %eax,%eax
  8005aa:	74 18                	je     8005c4 <libmain+0xfd>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  8005ac:	e8 37 2f 00 00       	call   8034e8 <sys_get_optimal_num_faults>
  8005b1:	83 ec 08             	sub    $0x8,%esp
  8005b4:	50                   	push   %eax
  8005b5:	68 90 46 80 00       	push   $0x804690
  8005ba:	e8 a1 01 00 00       	call   800760 <cprintf>
  8005bf:	83 c4 10             	add    $0x10,%esp
  8005c2:	eb 59                	jmp    80061d <libmain+0x156>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8005c4:	a1 20 60 80 00       	mov    0x806020,%eax
  8005c9:	8b 90 bc 05 00 00    	mov    0x5bc(%eax),%edx
  8005cf:	a1 20 60 80 00       	mov    0x806020,%eax
  8005d4:	8b 80 ac 05 00 00    	mov    0x5ac(%eax),%eax
  8005da:	83 ec 04             	sub    $0x4,%esp
  8005dd:	52                   	push   %edx
  8005de:	50                   	push   %eax
  8005df:	68 b4 46 80 00       	push   $0x8046b4
  8005e4:	e8 77 01 00 00       	call   800760 <cprintf>
  8005e9:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8005ec:	a1 20 60 80 00       	mov    0x806020,%eax
  8005f1:	8b 88 d0 05 00 00    	mov    0x5d0(%eax),%ecx
  8005f7:	a1 20 60 80 00       	mov    0x806020,%eax
  8005fc:	8b 90 cc 05 00 00    	mov    0x5cc(%eax),%edx
  800602:	a1 20 60 80 00       	mov    0x806020,%eax
  800607:	8b 80 c8 05 00 00    	mov    0x5c8(%eax),%eax
  80060d:	51                   	push   %ecx
  80060e:	52                   	push   %edx
  80060f:	50                   	push   %eax
  800610:	68 dc 46 80 00       	push   $0x8046dc
  800615:	e8 46 01 00 00       	call   800760 <cprintf>
  80061a:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80061d:	a1 20 60 80 00       	mov    0x806020,%eax
  800622:	8b 80 d4 05 00 00    	mov    0x5d4(%eax),%eax
  800628:	83 ec 08             	sub    $0x8,%esp
  80062b:	50                   	push   %eax
  80062c:	68 34 47 80 00       	push   $0x804734
  800631:	e8 2a 01 00 00       	call   800760 <cprintf>
  800636:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  800639:	83 ec 0c             	sub    $0xc,%esp
  80063c:	68 68 46 80 00       	push   $0x804668
  800641:	e8 1a 01 00 00       	call   800760 <cprintf>
  800646:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  800649:	e8 e7 29 00 00       	call   803035 <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  80064e:	e8 1f 00 00 00       	call   800672 <exit>
}
  800653:	90                   	nop
  800654:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800657:	5b                   	pop    %ebx
  800658:	5e                   	pop    %esi
  800659:	5f                   	pop    %edi
  80065a:	5d                   	pop    %ebp
  80065b:	c3                   	ret    

0080065c <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  80065c:	55                   	push   %ebp
  80065d:	89 e5                	mov    %esp,%ebp
  80065f:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800662:	83 ec 0c             	sub    $0xc,%esp
  800665:	6a 00                	push   $0x0
  800667:	e8 f4 2b 00 00       	call   803260 <sys_destroy_env>
  80066c:	83 c4 10             	add    $0x10,%esp
}
  80066f:	90                   	nop
  800670:	c9                   	leave  
  800671:	c3                   	ret    

00800672 <exit>:

void
exit(void)
{
  800672:	55                   	push   %ebp
  800673:	89 e5                	mov    %esp,%ebp
  800675:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800678:	e8 49 2c 00 00       	call   8032c6 <sys_exit_env>
}
  80067d:	90                   	nop
  80067e:	c9                   	leave  
  80067f:	c3                   	ret    

00800680 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  800680:	55                   	push   %ebp
  800681:	89 e5                	mov    %esp,%ebp
  800683:	53                   	push   %ebx
  800684:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  800687:	8b 45 0c             	mov    0xc(%ebp),%eax
  80068a:	8b 00                	mov    (%eax),%eax
  80068c:	8d 48 01             	lea    0x1(%eax),%ecx
  80068f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800692:	89 0a                	mov    %ecx,(%edx)
  800694:	8b 55 08             	mov    0x8(%ebp),%edx
  800697:	88 d1                	mov    %dl,%cl
  800699:	8b 55 0c             	mov    0xc(%ebp),%edx
  80069c:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8006a0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006a3:	8b 00                	mov    (%eax),%eax
  8006a5:	3d ff 00 00 00       	cmp    $0xff,%eax
  8006aa:	75 30                	jne    8006dc <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  8006ac:	8b 15 44 16 8e 00    	mov    0x8e1644,%edx
  8006b2:	a0 e0 7a 86 00       	mov    0x867ae0,%al
  8006b7:	0f b6 c0             	movzbl %al,%eax
  8006ba:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8006bd:	8b 09                	mov    (%ecx),%ecx
  8006bf:	89 cb                	mov    %ecx,%ebx
  8006c1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8006c4:	83 c1 08             	add    $0x8,%ecx
  8006c7:	52                   	push   %edx
  8006c8:	50                   	push   %eax
  8006c9:	53                   	push   %ebx
  8006ca:	51                   	push   %ecx
  8006cb:	e8 07 29 00 00       	call   802fd7 <sys_cputs>
  8006d0:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8006d3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006d6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8006dc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006df:	8b 40 04             	mov    0x4(%eax),%eax
  8006e2:	8d 50 01             	lea    0x1(%eax),%edx
  8006e5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006e8:	89 50 04             	mov    %edx,0x4(%eax)
}
  8006eb:	90                   	nop
  8006ec:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8006ef:	c9                   	leave  
  8006f0:	c3                   	ret    

008006f1 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8006f1:	55                   	push   %ebp
  8006f2:	89 e5                	mov    %esp,%ebp
  8006f4:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8006fa:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800701:	00 00 00 
	b.cnt = 0;
  800704:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80070b:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  80070e:	ff 75 0c             	pushl  0xc(%ebp)
  800711:	ff 75 08             	pushl  0x8(%ebp)
  800714:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80071a:	50                   	push   %eax
  80071b:	68 80 06 80 00       	push   $0x800680
  800720:	e8 5a 02 00 00       	call   80097f <vprintfmt>
  800725:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  800728:	8b 15 44 16 8e 00    	mov    0x8e1644,%edx
  80072e:	a0 e0 7a 86 00       	mov    0x867ae0,%al
  800733:	0f b6 c0             	movzbl %al,%eax
  800736:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  80073c:	52                   	push   %edx
  80073d:	50                   	push   %eax
  80073e:	51                   	push   %ecx
  80073f:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800745:	83 c0 08             	add    $0x8,%eax
  800748:	50                   	push   %eax
  800749:	e8 89 28 00 00       	call   802fd7 <sys_cputs>
  80074e:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800751:	c6 05 e0 7a 86 00 00 	movb   $0x0,0x867ae0
	return b.cnt;
  800758:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  80075e:	c9                   	leave  
  80075f:	c3                   	ret    

00800760 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  800760:	55                   	push   %ebp
  800761:	89 e5                	mov    %esp,%ebp
  800763:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800766:	c6 05 e0 7a 86 00 01 	movb   $0x1,0x867ae0
	va_start(ap, fmt);
  80076d:	8d 45 0c             	lea    0xc(%ebp),%eax
  800770:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800773:	8b 45 08             	mov    0x8(%ebp),%eax
  800776:	83 ec 08             	sub    $0x8,%esp
  800779:	ff 75 f4             	pushl  -0xc(%ebp)
  80077c:	50                   	push   %eax
  80077d:	e8 6f ff ff ff       	call   8006f1 <vcprintf>
  800782:	83 c4 10             	add    $0x10,%esp
  800785:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800788:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80078b:	c9                   	leave  
  80078c:	c3                   	ret    

0080078d <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  80078d:	55                   	push   %ebp
  80078e:	89 e5                	mov    %esp,%ebp
  800790:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800793:	c6 05 e0 7a 86 00 01 	movb   $0x1,0x867ae0
	curTextClr = (textClr << 8) ; //set text color by the given value
  80079a:	8b 45 08             	mov    0x8(%ebp),%eax
  80079d:	c1 e0 08             	shl    $0x8,%eax
  8007a0:	a3 44 16 8e 00       	mov    %eax,0x8e1644
	va_start(ap, fmt);
  8007a5:	8d 45 0c             	lea    0xc(%ebp),%eax
  8007a8:	83 c0 04             	add    $0x4,%eax
  8007ab:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8007ae:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007b1:	83 ec 08             	sub    $0x8,%esp
  8007b4:	ff 75 f4             	pushl  -0xc(%ebp)
  8007b7:	50                   	push   %eax
  8007b8:	e8 34 ff ff ff       	call   8006f1 <vcprintf>
  8007bd:	83 c4 10             	add    $0x10,%esp
  8007c0:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  8007c3:	c7 05 44 16 8e 00 00 	movl   $0x700,0x8e1644
  8007ca:	07 00 00 

	return cnt;
  8007cd:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8007d0:	c9                   	leave  
  8007d1:	c3                   	ret    

008007d2 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  8007d2:	55                   	push   %ebp
  8007d3:	89 e5                	mov    %esp,%ebp
  8007d5:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  8007d8:	e8 3e 28 00 00       	call   80301b <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  8007dd:	8d 45 0c             	lea    0xc(%ebp),%eax
  8007e0:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  8007e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8007e6:	83 ec 08             	sub    $0x8,%esp
  8007e9:	ff 75 f4             	pushl  -0xc(%ebp)
  8007ec:	50                   	push   %eax
  8007ed:	e8 ff fe ff ff       	call   8006f1 <vcprintf>
  8007f2:	83 c4 10             	add    $0x10,%esp
  8007f5:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  8007f8:	e8 38 28 00 00       	call   803035 <sys_unlock_cons>
	return cnt;
  8007fd:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800800:	c9                   	leave  
  800801:	c3                   	ret    

00800802 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800802:	55                   	push   %ebp
  800803:	89 e5                	mov    %esp,%ebp
  800805:	53                   	push   %ebx
  800806:	83 ec 14             	sub    $0x14,%esp
  800809:	8b 45 10             	mov    0x10(%ebp),%eax
  80080c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80080f:	8b 45 14             	mov    0x14(%ebp),%eax
  800812:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800815:	8b 45 18             	mov    0x18(%ebp),%eax
  800818:	ba 00 00 00 00       	mov    $0x0,%edx
  80081d:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800820:	77 55                	ja     800877 <printnum+0x75>
  800822:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800825:	72 05                	jb     80082c <printnum+0x2a>
  800827:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80082a:	77 4b                	ja     800877 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80082c:	8b 45 1c             	mov    0x1c(%ebp),%eax
  80082f:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800832:	8b 45 18             	mov    0x18(%ebp),%eax
  800835:	ba 00 00 00 00       	mov    $0x0,%edx
  80083a:	52                   	push   %edx
  80083b:	50                   	push   %eax
  80083c:	ff 75 f4             	pushl  -0xc(%ebp)
  80083f:	ff 75 f0             	pushl  -0x10(%ebp)
  800842:	e8 e1 3a 00 00       	call   804328 <__udivdi3>
  800847:	83 c4 10             	add    $0x10,%esp
  80084a:	83 ec 04             	sub    $0x4,%esp
  80084d:	ff 75 20             	pushl  0x20(%ebp)
  800850:	53                   	push   %ebx
  800851:	ff 75 18             	pushl  0x18(%ebp)
  800854:	52                   	push   %edx
  800855:	50                   	push   %eax
  800856:	ff 75 0c             	pushl  0xc(%ebp)
  800859:	ff 75 08             	pushl  0x8(%ebp)
  80085c:	e8 a1 ff ff ff       	call   800802 <printnum>
  800861:	83 c4 20             	add    $0x20,%esp
  800864:	eb 1a                	jmp    800880 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800866:	83 ec 08             	sub    $0x8,%esp
  800869:	ff 75 0c             	pushl  0xc(%ebp)
  80086c:	ff 75 20             	pushl  0x20(%ebp)
  80086f:	8b 45 08             	mov    0x8(%ebp),%eax
  800872:	ff d0                	call   *%eax
  800874:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800877:	ff 4d 1c             	decl   0x1c(%ebp)
  80087a:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  80087e:	7f e6                	jg     800866 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800880:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800883:	bb 00 00 00 00       	mov    $0x0,%ebx
  800888:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80088b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80088e:	53                   	push   %ebx
  80088f:	51                   	push   %ecx
  800890:	52                   	push   %edx
  800891:	50                   	push   %eax
  800892:	e8 a1 3b 00 00       	call   804438 <__umoddi3>
  800897:	83 c4 10             	add    $0x10,%esp
  80089a:	05 d4 49 80 00       	add    $0x8049d4,%eax
  80089f:	8a 00                	mov    (%eax),%al
  8008a1:	0f be c0             	movsbl %al,%eax
  8008a4:	83 ec 08             	sub    $0x8,%esp
  8008a7:	ff 75 0c             	pushl  0xc(%ebp)
  8008aa:	50                   	push   %eax
  8008ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ae:	ff d0                	call   *%eax
  8008b0:	83 c4 10             	add    $0x10,%esp
}
  8008b3:	90                   	nop
  8008b4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8008b7:	c9                   	leave  
  8008b8:	c3                   	ret    

008008b9 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8008b9:	55                   	push   %ebp
  8008ba:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8008bc:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8008c0:	7e 1c                	jle    8008de <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8008c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8008c5:	8b 00                	mov    (%eax),%eax
  8008c7:	8d 50 08             	lea    0x8(%eax),%edx
  8008ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8008cd:	89 10                	mov    %edx,(%eax)
  8008cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8008d2:	8b 00                	mov    (%eax),%eax
  8008d4:	83 e8 08             	sub    $0x8,%eax
  8008d7:	8b 50 04             	mov    0x4(%eax),%edx
  8008da:	8b 00                	mov    (%eax),%eax
  8008dc:	eb 40                	jmp    80091e <getuint+0x65>
	else if (lflag)
  8008de:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8008e2:	74 1e                	je     800902 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8008e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8008e7:	8b 00                	mov    (%eax),%eax
  8008e9:	8d 50 04             	lea    0x4(%eax),%edx
  8008ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ef:	89 10                	mov    %edx,(%eax)
  8008f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8008f4:	8b 00                	mov    (%eax),%eax
  8008f6:	83 e8 04             	sub    $0x4,%eax
  8008f9:	8b 00                	mov    (%eax),%eax
  8008fb:	ba 00 00 00 00       	mov    $0x0,%edx
  800900:	eb 1c                	jmp    80091e <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800902:	8b 45 08             	mov    0x8(%ebp),%eax
  800905:	8b 00                	mov    (%eax),%eax
  800907:	8d 50 04             	lea    0x4(%eax),%edx
  80090a:	8b 45 08             	mov    0x8(%ebp),%eax
  80090d:	89 10                	mov    %edx,(%eax)
  80090f:	8b 45 08             	mov    0x8(%ebp),%eax
  800912:	8b 00                	mov    (%eax),%eax
  800914:	83 e8 04             	sub    $0x4,%eax
  800917:	8b 00                	mov    (%eax),%eax
  800919:	ba 00 00 00 00       	mov    $0x0,%edx
}
  80091e:	5d                   	pop    %ebp
  80091f:	c3                   	ret    

00800920 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800920:	55                   	push   %ebp
  800921:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800923:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800927:	7e 1c                	jle    800945 <getint+0x25>
		return va_arg(*ap, long long);
  800929:	8b 45 08             	mov    0x8(%ebp),%eax
  80092c:	8b 00                	mov    (%eax),%eax
  80092e:	8d 50 08             	lea    0x8(%eax),%edx
  800931:	8b 45 08             	mov    0x8(%ebp),%eax
  800934:	89 10                	mov    %edx,(%eax)
  800936:	8b 45 08             	mov    0x8(%ebp),%eax
  800939:	8b 00                	mov    (%eax),%eax
  80093b:	83 e8 08             	sub    $0x8,%eax
  80093e:	8b 50 04             	mov    0x4(%eax),%edx
  800941:	8b 00                	mov    (%eax),%eax
  800943:	eb 38                	jmp    80097d <getint+0x5d>
	else if (lflag)
  800945:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800949:	74 1a                	je     800965 <getint+0x45>
		return va_arg(*ap, long);
  80094b:	8b 45 08             	mov    0x8(%ebp),%eax
  80094e:	8b 00                	mov    (%eax),%eax
  800950:	8d 50 04             	lea    0x4(%eax),%edx
  800953:	8b 45 08             	mov    0x8(%ebp),%eax
  800956:	89 10                	mov    %edx,(%eax)
  800958:	8b 45 08             	mov    0x8(%ebp),%eax
  80095b:	8b 00                	mov    (%eax),%eax
  80095d:	83 e8 04             	sub    $0x4,%eax
  800960:	8b 00                	mov    (%eax),%eax
  800962:	99                   	cltd   
  800963:	eb 18                	jmp    80097d <getint+0x5d>
	else
		return va_arg(*ap, int);
  800965:	8b 45 08             	mov    0x8(%ebp),%eax
  800968:	8b 00                	mov    (%eax),%eax
  80096a:	8d 50 04             	lea    0x4(%eax),%edx
  80096d:	8b 45 08             	mov    0x8(%ebp),%eax
  800970:	89 10                	mov    %edx,(%eax)
  800972:	8b 45 08             	mov    0x8(%ebp),%eax
  800975:	8b 00                	mov    (%eax),%eax
  800977:	83 e8 04             	sub    $0x4,%eax
  80097a:	8b 00                	mov    (%eax),%eax
  80097c:	99                   	cltd   
}
  80097d:	5d                   	pop    %ebp
  80097e:	c3                   	ret    

0080097f <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80097f:	55                   	push   %ebp
  800980:	89 e5                	mov    %esp,%ebp
  800982:	56                   	push   %esi
  800983:	53                   	push   %ebx
  800984:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800987:	eb 17                	jmp    8009a0 <vprintfmt+0x21>
			if (ch == '\0')
  800989:	85 db                	test   %ebx,%ebx
  80098b:	0f 84 c1 03 00 00    	je     800d52 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  800991:	83 ec 08             	sub    $0x8,%esp
  800994:	ff 75 0c             	pushl  0xc(%ebp)
  800997:	53                   	push   %ebx
  800998:	8b 45 08             	mov    0x8(%ebp),%eax
  80099b:	ff d0                	call   *%eax
  80099d:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8009a0:	8b 45 10             	mov    0x10(%ebp),%eax
  8009a3:	8d 50 01             	lea    0x1(%eax),%edx
  8009a6:	89 55 10             	mov    %edx,0x10(%ebp)
  8009a9:	8a 00                	mov    (%eax),%al
  8009ab:	0f b6 d8             	movzbl %al,%ebx
  8009ae:	83 fb 25             	cmp    $0x25,%ebx
  8009b1:	75 d6                	jne    800989 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8009b3:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  8009b7:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  8009be:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8009c5:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8009cc:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8009d3:	8b 45 10             	mov    0x10(%ebp),%eax
  8009d6:	8d 50 01             	lea    0x1(%eax),%edx
  8009d9:	89 55 10             	mov    %edx,0x10(%ebp)
  8009dc:	8a 00                	mov    (%eax),%al
  8009de:	0f b6 d8             	movzbl %al,%ebx
  8009e1:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8009e4:	83 f8 5b             	cmp    $0x5b,%eax
  8009e7:	0f 87 3d 03 00 00    	ja     800d2a <vprintfmt+0x3ab>
  8009ed:	8b 04 85 f8 49 80 00 	mov    0x8049f8(,%eax,4),%eax
  8009f4:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8009f6:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8009fa:	eb d7                	jmp    8009d3 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8009fc:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800a00:	eb d1                	jmp    8009d3 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800a02:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800a09:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800a0c:	89 d0                	mov    %edx,%eax
  800a0e:	c1 e0 02             	shl    $0x2,%eax
  800a11:	01 d0                	add    %edx,%eax
  800a13:	01 c0                	add    %eax,%eax
  800a15:	01 d8                	add    %ebx,%eax
  800a17:	83 e8 30             	sub    $0x30,%eax
  800a1a:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800a1d:	8b 45 10             	mov    0x10(%ebp),%eax
  800a20:	8a 00                	mov    (%eax),%al
  800a22:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800a25:	83 fb 2f             	cmp    $0x2f,%ebx
  800a28:	7e 3e                	jle    800a68 <vprintfmt+0xe9>
  800a2a:	83 fb 39             	cmp    $0x39,%ebx
  800a2d:	7f 39                	jg     800a68 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800a2f:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800a32:	eb d5                	jmp    800a09 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800a34:	8b 45 14             	mov    0x14(%ebp),%eax
  800a37:	83 c0 04             	add    $0x4,%eax
  800a3a:	89 45 14             	mov    %eax,0x14(%ebp)
  800a3d:	8b 45 14             	mov    0x14(%ebp),%eax
  800a40:	83 e8 04             	sub    $0x4,%eax
  800a43:	8b 00                	mov    (%eax),%eax
  800a45:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800a48:	eb 1f                	jmp    800a69 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800a4a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a4e:	79 83                	jns    8009d3 <vprintfmt+0x54>
				width = 0;
  800a50:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800a57:	e9 77 ff ff ff       	jmp    8009d3 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800a5c:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800a63:	e9 6b ff ff ff       	jmp    8009d3 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800a68:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800a69:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a6d:	0f 89 60 ff ff ff    	jns    8009d3 <vprintfmt+0x54>
				width = precision, precision = -1;
  800a73:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800a76:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800a79:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800a80:	e9 4e ff ff ff       	jmp    8009d3 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800a85:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800a88:	e9 46 ff ff ff       	jmp    8009d3 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800a8d:	8b 45 14             	mov    0x14(%ebp),%eax
  800a90:	83 c0 04             	add    $0x4,%eax
  800a93:	89 45 14             	mov    %eax,0x14(%ebp)
  800a96:	8b 45 14             	mov    0x14(%ebp),%eax
  800a99:	83 e8 04             	sub    $0x4,%eax
  800a9c:	8b 00                	mov    (%eax),%eax
  800a9e:	83 ec 08             	sub    $0x8,%esp
  800aa1:	ff 75 0c             	pushl  0xc(%ebp)
  800aa4:	50                   	push   %eax
  800aa5:	8b 45 08             	mov    0x8(%ebp),%eax
  800aa8:	ff d0                	call   *%eax
  800aaa:	83 c4 10             	add    $0x10,%esp
			break;
  800aad:	e9 9b 02 00 00       	jmp    800d4d <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800ab2:	8b 45 14             	mov    0x14(%ebp),%eax
  800ab5:	83 c0 04             	add    $0x4,%eax
  800ab8:	89 45 14             	mov    %eax,0x14(%ebp)
  800abb:	8b 45 14             	mov    0x14(%ebp),%eax
  800abe:	83 e8 04             	sub    $0x4,%eax
  800ac1:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800ac3:	85 db                	test   %ebx,%ebx
  800ac5:	79 02                	jns    800ac9 <vprintfmt+0x14a>
				err = -err;
  800ac7:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800ac9:	83 fb 64             	cmp    $0x64,%ebx
  800acc:	7f 0b                	jg     800ad9 <vprintfmt+0x15a>
  800ace:	8b 34 9d 40 48 80 00 	mov    0x804840(,%ebx,4),%esi
  800ad5:	85 f6                	test   %esi,%esi
  800ad7:	75 19                	jne    800af2 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800ad9:	53                   	push   %ebx
  800ada:	68 e5 49 80 00       	push   $0x8049e5
  800adf:	ff 75 0c             	pushl  0xc(%ebp)
  800ae2:	ff 75 08             	pushl  0x8(%ebp)
  800ae5:	e8 70 02 00 00       	call   800d5a <printfmt>
  800aea:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800aed:	e9 5b 02 00 00       	jmp    800d4d <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800af2:	56                   	push   %esi
  800af3:	68 ee 49 80 00       	push   $0x8049ee
  800af8:	ff 75 0c             	pushl  0xc(%ebp)
  800afb:	ff 75 08             	pushl  0x8(%ebp)
  800afe:	e8 57 02 00 00       	call   800d5a <printfmt>
  800b03:	83 c4 10             	add    $0x10,%esp
			break;
  800b06:	e9 42 02 00 00       	jmp    800d4d <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800b0b:	8b 45 14             	mov    0x14(%ebp),%eax
  800b0e:	83 c0 04             	add    $0x4,%eax
  800b11:	89 45 14             	mov    %eax,0x14(%ebp)
  800b14:	8b 45 14             	mov    0x14(%ebp),%eax
  800b17:	83 e8 04             	sub    $0x4,%eax
  800b1a:	8b 30                	mov    (%eax),%esi
  800b1c:	85 f6                	test   %esi,%esi
  800b1e:	75 05                	jne    800b25 <vprintfmt+0x1a6>
				p = "(null)";
  800b20:	be f1 49 80 00       	mov    $0x8049f1,%esi
			if (width > 0 && padc != '-')
  800b25:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b29:	7e 6d                	jle    800b98 <vprintfmt+0x219>
  800b2b:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800b2f:	74 67                	je     800b98 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800b31:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800b34:	83 ec 08             	sub    $0x8,%esp
  800b37:	50                   	push   %eax
  800b38:	56                   	push   %esi
  800b39:	e8 1e 03 00 00       	call   800e5c <strnlen>
  800b3e:	83 c4 10             	add    $0x10,%esp
  800b41:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800b44:	eb 16                	jmp    800b5c <vprintfmt+0x1dd>
					putch(padc, putdat);
  800b46:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800b4a:	83 ec 08             	sub    $0x8,%esp
  800b4d:	ff 75 0c             	pushl  0xc(%ebp)
  800b50:	50                   	push   %eax
  800b51:	8b 45 08             	mov    0x8(%ebp),%eax
  800b54:	ff d0                	call   *%eax
  800b56:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800b59:	ff 4d e4             	decl   -0x1c(%ebp)
  800b5c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b60:	7f e4                	jg     800b46 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b62:	eb 34                	jmp    800b98 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800b64:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800b68:	74 1c                	je     800b86 <vprintfmt+0x207>
  800b6a:	83 fb 1f             	cmp    $0x1f,%ebx
  800b6d:	7e 05                	jle    800b74 <vprintfmt+0x1f5>
  800b6f:	83 fb 7e             	cmp    $0x7e,%ebx
  800b72:	7e 12                	jle    800b86 <vprintfmt+0x207>
					putch('?', putdat);
  800b74:	83 ec 08             	sub    $0x8,%esp
  800b77:	ff 75 0c             	pushl  0xc(%ebp)
  800b7a:	6a 3f                	push   $0x3f
  800b7c:	8b 45 08             	mov    0x8(%ebp),%eax
  800b7f:	ff d0                	call   *%eax
  800b81:	83 c4 10             	add    $0x10,%esp
  800b84:	eb 0f                	jmp    800b95 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800b86:	83 ec 08             	sub    $0x8,%esp
  800b89:	ff 75 0c             	pushl  0xc(%ebp)
  800b8c:	53                   	push   %ebx
  800b8d:	8b 45 08             	mov    0x8(%ebp),%eax
  800b90:	ff d0                	call   *%eax
  800b92:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b95:	ff 4d e4             	decl   -0x1c(%ebp)
  800b98:	89 f0                	mov    %esi,%eax
  800b9a:	8d 70 01             	lea    0x1(%eax),%esi
  800b9d:	8a 00                	mov    (%eax),%al
  800b9f:	0f be d8             	movsbl %al,%ebx
  800ba2:	85 db                	test   %ebx,%ebx
  800ba4:	74 24                	je     800bca <vprintfmt+0x24b>
  800ba6:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800baa:	78 b8                	js     800b64 <vprintfmt+0x1e5>
  800bac:	ff 4d e0             	decl   -0x20(%ebp)
  800baf:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800bb3:	79 af                	jns    800b64 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800bb5:	eb 13                	jmp    800bca <vprintfmt+0x24b>
				putch(' ', putdat);
  800bb7:	83 ec 08             	sub    $0x8,%esp
  800bba:	ff 75 0c             	pushl  0xc(%ebp)
  800bbd:	6a 20                	push   $0x20
  800bbf:	8b 45 08             	mov    0x8(%ebp),%eax
  800bc2:	ff d0                	call   *%eax
  800bc4:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800bc7:	ff 4d e4             	decl   -0x1c(%ebp)
  800bca:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800bce:	7f e7                	jg     800bb7 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800bd0:	e9 78 01 00 00       	jmp    800d4d <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800bd5:	83 ec 08             	sub    $0x8,%esp
  800bd8:	ff 75 e8             	pushl  -0x18(%ebp)
  800bdb:	8d 45 14             	lea    0x14(%ebp),%eax
  800bde:	50                   	push   %eax
  800bdf:	e8 3c fd ff ff       	call   800920 <getint>
  800be4:	83 c4 10             	add    $0x10,%esp
  800be7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bea:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800bed:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800bf0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800bf3:	85 d2                	test   %edx,%edx
  800bf5:	79 23                	jns    800c1a <vprintfmt+0x29b>
				putch('-', putdat);
  800bf7:	83 ec 08             	sub    $0x8,%esp
  800bfa:	ff 75 0c             	pushl  0xc(%ebp)
  800bfd:	6a 2d                	push   $0x2d
  800bff:	8b 45 08             	mov    0x8(%ebp),%eax
  800c02:	ff d0                	call   *%eax
  800c04:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800c07:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c0a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800c0d:	f7 d8                	neg    %eax
  800c0f:	83 d2 00             	adc    $0x0,%edx
  800c12:	f7 da                	neg    %edx
  800c14:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c17:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800c1a:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800c21:	e9 bc 00 00 00       	jmp    800ce2 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800c26:	83 ec 08             	sub    $0x8,%esp
  800c29:	ff 75 e8             	pushl  -0x18(%ebp)
  800c2c:	8d 45 14             	lea    0x14(%ebp),%eax
  800c2f:	50                   	push   %eax
  800c30:	e8 84 fc ff ff       	call   8008b9 <getuint>
  800c35:	83 c4 10             	add    $0x10,%esp
  800c38:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c3b:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800c3e:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800c45:	e9 98 00 00 00       	jmp    800ce2 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800c4a:	83 ec 08             	sub    $0x8,%esp
  800c4d:	ff 75 0c             	pushl  0xc(%ebp)
  800c50:	6a 58                	push   $0x58
  800c52:	8b 45 08             	mov    0x8(%ebp),%eax
  800c55:	ff d0                	call   *%eax
  800c57:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800c5a:	83 ec 08             	sub    $0x8,%esp
  800c5d:	ff 75 0c             	pushl  0xc(%ebp)
  800c60:	6a 58                	push   $0x58
  800c62:	8b 45 08             	mov    0x8(%ebp),%eax
  800c65:	ff d0                	call   *%eax
  800c67:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800c6a:	83 ec 08             	sub    $0x8,%esp
  800c6d:	ff 75 0c             	pushl  0xc(%ebp)
  800c70:	6a 58                	push   $0x58
  800c72:	8b 45 08             	mov    0x8(%ebp),%eax
  800c75:	ff d0                	call   *%eax
  800c77:	83 c4 10             	add    $0x10,%esp
			break;
  800c7a:	e9 ce 00 00 00       	jmp    800d4d <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800c7f:	83 ec 08             	sub    $0x8,%esp
  800c82:	ff 75 0c             	pushl  0xc(%ebp)
  800c85:	6a 30                	push   $0x30
  800c87:	8b 45 08             	mov    0x8(%ebp),%eax
  800c8a:	ff d0                	call   *%eax
  800c8c:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800c8f:	83 ec 08             	sub    $0x8,%esp
  800c92:	ff 75 0c             	pushl  0xc(%ebp)
  800c95:	6a 78                	push   $0x78
  800c97:	8b 45 08             	mov    0x8(%ebp),%eax
  800c9a:	ff d0                	call   *%eax
  800c9c:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800c9f:	8b 45 14             	mov    0x14(%ebp),%eax
  800ca2:	83 c0 04             	add    $0x4,%eax
  800ca5:	89 45 14             	mov    %eax,0x14(%ebp)
  800ca8:	8b 45 14             	mov    0x14(%ebp),%eax
  800cab:	83 e8 04             	sub    $0x4,%eax
  800cae:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800cb0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800cb3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800cba:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800cc1:	eb 1f                	jmp    800ce2 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800cc3:	83 ec 08             	sub    $0x8,%esp
  800cc6:	ff 75 e8             	pushl  -0x18(%ebp)
  800cc9:	8d 45 14             	lea    0x14(%ebp),%eax
  800ccc:	50                   	push   %eax
  800ccd:	e8 e7 fb ff ff       	call   8008b9 <getuint>
  800cd2:	83 c4 10             	add    $0x10,%esp
  800cd5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800cd8:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800cdb:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800ce2:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800ce6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800ce9:	83 ec 04             	sub    $0x4,%esp
  800cec:	52                   	push   %edx
  800ced:	ff 75 e4             	pushl  -0x1c(%ebp)
  800cf0:	50                   	push   %eax
  800cf1:	ff 75 f4             	pushl  -0xc(%ebp)
  800cf4:	ff 75 f0             	pushl  -0x10(%ebp)
  800cf7:	ff 75 0c             	pushl  0xc(%ebp)
  800cfa:	ff 75 08             	pushl  0x8(%ebp)
  800cfd:	e8 00 fb ff ff       	call   800802 <printnum>
  800d02:	83 c4 20             	add    $0x20,%esp
			break;
  800d05:	eb 46                	jmp    800d4d <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800d07:	83 ec 08             	sub    $0x8,%esp
  800d0a:	ff 75 0c             	pushl  0xc(%ebp)
  800d0d:	53                   	push   %ebx
  800d0e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d11:	ff d0                	call   *%eax
  800d13:	83 c4 10             	add    $0x10,%esp
			break;
  800d16:	eb 35                	jmp    800d4d <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800d18:	c6 05 e0 7a 86 00 00 	movb   $0x0,0x867ae0
			break;
  800d1f:	eb 2c                	jmp    800d4d <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800d21:	c6 05 e0 7a 86 00 01 	movb   $0x1,0x867ae0
			break;
  800d28:	eb 23                	jmp    800d4d <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800d2a:	83 ec 08             	sub    $0x8,%esp
  800d2d:	ff 75 0c             	pushl  0xc(%ebp)
  800d30:	6a 25                	push   $0x25
  800d32:	8b 45 08             	mov    0x8(%ebp),%eax
  800d35:	ff d0                	call   *%eax
  800d37:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800d3a:	ff 4d 10             	decl   0x10(%ebp)
  800d3d:	eb 03                	jmp    800d42 <vprintfmt+0x3c3>
  800d3f:	ff 4d 10             	decl   0x10(%ebp)
  800d42:	8b 45 10             	mov    0x10(%ebp),%eax
  800d45:	48                   	dec    %eax
  800d46:	8a 00                	mov    (%eax),%al
  800d48:	3c 25                	cmp    $0x25,%al
  800d4a:	75 f3                	jne    800d3f <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800d4c:	90                   	nop
		}
	}
  800d4d:	e9 35 fc ff ff       	jmp    800987 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800d52:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800d53:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800d56:	5b                   	pop    %ebx
  800d57:	5e                   	pop    %esi
  800d58:	5d                   	pop    %ebp
  800d59:	c3                   	ret    

00800d5a <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800d5a:	55                   	push   %ebp
  800d5b:	89 e5                	mov    %esp,%ebp
  800d5d:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800d60:	8d 45 10             	lea    0x10(%ebp),%eax
  800d63:	83 c0 04             	add    $0x4,%eax
  800d66:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800d69:	8b 45 10             	mov    0x10(%ebp),%eax
  800d6c:	ff 75 f4             	pushl  -0xc(%ebp)
  800d6f:	50                   	push   %eax
  800d70:	ff 75 0c             	pushl  0xc(%ebp)
  800d73:	ff 75 08             	pushl  0x8(%ebp)
  800d76:	e8 04 fc ff ff       	call   80097f <vprintfmt>
  800d7b:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800d7e:	90                   	nop
  800d7f:	c9                   	leave  
  800d80:	c3                   	ret    

00800d81 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800d81:	55                   	push   %ebp
  800d82:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800d84:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d87:	8b 40 08             	mov    0x8(%eax),%eax
  800d8a:	8d 50 01             	lea    0x1(%eax),%edx
  800d8d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d90:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800d93:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d96:	8b 10                	mov    (%eax),%edx
  800d98:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d9b:	8b 40 04             	mov    0x4(%eax),%eax
  800d9e:	39 c2                	cmp    %eax,%edx
  800da0:	73 12                	jae    800db4 <sprintputch+0x33>
		*b->buf++ = ch;
  800da2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800da5:	8b 00                	mov    (%eax),%eax
  800da7:	8d 48 01             	lea    0x1(%eax),%ecx
  800daa:	8b 55 0c             	mov    0xc(%ebp),%edx
  800dad:	89 0a                	mov    %ecx,(%edx)
  800daf:	8b 55 08             	mov    0x8(%ebp),%edx
  800db2:	88 10                	mov    %dl,(%eax)
}
  800db4:	90                   	nop
  800db5:	5d                   	pop    %ebp
  800db6:	c3                   	ret    

00800db7 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800db7:	55                   	push   %ebp
  800db8:	89 e5                	mov    %esp,%ebp
  800dba:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800dbd:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc0:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800dc3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dc6:	8d 50 ff             	lea    -0x1(%eax),%edx
  800dc9:	8b 45 08             	mov    0x8(%ebp),%eax
  800dcc:	01 d0                	add    %edx,%eax
  800dce:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800dd1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800dd8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800ddc:	74 06                	je     800de4 <vsnprintf+0x2d>
  800dde:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800de2:	7f 07                	jg     800deb <vsnprintf+0x34>
		return -E_INVAL;
  800de4:	b8 03 00 00 00       	mov    $0x3,%eax
  800de9:	eb 20                	jmp    800e0b <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800deb:	ff 75 14             	pushl  0x14(%ebp)
  800dee:	ff 75 10             	pushl  0x10(%ebp)
  800df1:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800df4:	50                   	push   %eax
  800df5:	68 81 0d 80 00       	push   $0x800d81
  800dfa:	e8 80 fb ff ff       	call   80097f <vprintfmt>
  800dff:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800e02:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800e05:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800e08:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800e0b:	c9                   	leave  
  800e0c:	c3                   	ret    

00800e0d <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800e0d:	55                   	push   %ebp
  800e0e:	89 e5                	mov    %esp,%ebp
  800e10:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800e13:	8d 45 10             	lea    0x10(%ebp),%eax
  800e16:	83 c0 04             	add    $0x4,%eax
  800e19:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800e1c:	8b 45 10             	mov    0x10(%ebp),%eax
  800e1f:	ff 75 f4             	pushl  -0xc(%ebp)
  800e22:	50                   	push   %eax
  800e23:	ff 75 0c             	pushl  0xc(%ebp)
  800e26:	ff 75 08             	pushl  0x8(%ebp)
  800e29:	e8 89 ff ff ff       	call   800db7 <vsnprintf>
  800e2e:	83 c4 10             	add    $0x10,%esp
  800e31:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800e34:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800e37:	c9                   	leave  
  800e38:	c3                   	ret    

00800e39 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800e39:	55                   	push   %ebp
  800e3a:	89 e5                	mov    %esp,%ebp
  800e3c:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800e3f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800e46:	eb 06                	jmp    800e4e <strlen+0x15>
		n++;
  800e48:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800e4b:	ff 45 08             	incl   0x8(%ebp)
  800e4e:	8b 45 08             	mov    0x8(%ebp),%eax
  800e51:	8a 00                	mov    (%eax),%al
  800e53:	84 c0                	test   %al,%al
  800e55:	75 f1                	jne    800e48 <strlen+0xf>
		n++;
	return n;
  800e57:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e5a:	c9                   	leave  
  800e5b:	c3                   	ret    

00800e5c <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800e5c:	55                   	push   %ebp
  800e5d:	89 e5                	mov    %esp,%ebp
  800e5f:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800e62:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800e69:	eb 09                	jmp    800e74 <strnlen+0x18>
		n++;
  800e6b:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800e6e:	ff 45 08             	incl   0x8(%ebp)
  800e71:	ff 4d 0c             	decl   0xc(%ebp)
  800e74:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e78:	74 09                	je     800e83 <strnlen+0x27>
  800e7a:	8b 45 08             	mov    0x8(%ebp),%eax
  800e7d:	8a 00                	mov    (%eax),%al
  800e7f:	84 c0                	test   %al,%al
  800e81:	75 e8                	jne    800e6b <strnlen+0xf>
		n++;
	return n;
  800e83:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e86:	c9                   	leave  
  800e87:	c3                   	ret    

00800e88 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800e88:	55                   	push   %ebp
  800e89:	89 e5                	mov    %esp,%ebp
  800e8b:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800e8e:	8b 45 08             	mov    0x8(%ebp),%eax
  800e91:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800e94:	90                   	nop
  800e95:	8b 45 08             	mov    0x8(%ebp),%eax
  800e98:	8d 50 01             	lea    0x1(%eax),%edx
  800e9b:	89 55 08             	mov    %edx,0x8(%ebp)
  800e9e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ea1:	8d 4a 01             	lea    0x1(%edx),%ecx
  800ea4:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800ea7:	8a 12                	mov    (%edx),%dl
  800ea9:	88 10                	mov    %dl,(%eax)
  800eab:	8a 00                	mov    (%eax),%al
  800ead:	84 c0                	test   %al,%al
  800eaf:	75 e4                	jne    800e95 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800eb1:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800eb4:	c9                   	leave  
  800eb5:	c3                   	ret    

00800eb6 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800eb6:	55                   	push   %ebp
  800eb7:	89 e5                	mov    %esp,%ebp
  800eb9:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800ebc:	8b 45 08             	mov    0x8(%ebp),%eax
  800ebf:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800ec2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800ec9:	eb 1f                	jmp    800eea <strncpy+0x34>
		*dst++ = *src;
  800ecb:	8b 45 08             	mov    0x8(%ebp),%eax
  800ece:	8d 50 01             	lea    0x1(%eax),%edx
  800ed1:	89 55 08             	mov    %edx,0x8(%ebp)
  800ed4:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ed7:	8a 12                	mov    (%edx),%dl
  800ed9:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800edb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ede:	8a 00                	mov    (%eax),%al
  800ee0:	84 c0                	test   %al,%al
  800ee2:	74 03                	je     800ee7 <strncpy+0x31>
			src++;
  800ee4:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800ee7:	ff 45 fc             	incl   -0x4(%ebp)
  800eea:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800eed:	3b 45 10             	cmp    0x10(%ebp),%eax
  800ef0:	72 d9                	jb     800ecb <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800ef2:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800ef5:	c9                   	leave  
  800ef6:	c3                   	ret    

00800ef7 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800ef7:	55                   	push   %ebp
  800ef8:	89 e5                	mov    %esp,%ebp
  800efa:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800efd:	8b 45 08             	mov    0x8(%ebp),%eax
  800f00:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800f03:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f07:	74 30                	je     800f39 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800f09:	eb 16                	jmp    800f21 <strlcpy+0x2a>
			*dst++ = *src++;
  800f0b:	8b 45 08             	mov    0x8(%ebp),%eax
  800f0e:	8d 50 01             	lea    0x1(%eax),%edx
  800f11:	89 55 08             	mov    %edx,0x8(%ebp)
  800f14:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f17:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f1a:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800f1d:	8a 12                	mov    (%edx),%dl
  800f1f:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800f21:	ff 4d 10             	decl   0x10(%ebp)
  800f24:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f28:	74 09                	je     800f33 <strlcpy+0x3c>
  800f2a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f2d:	8a 00                	mov    (%eax),%al
  800f2f:	84 c0                	test   %al,%al
  800f31:	75 d8                	jne    800f0b <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800f33:	8b 45 08             	mov    0x8(%ebp),%eax
  800f36:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800f39:	8b 55 08             	mov    0x8(%ebp),%edx
  800f3c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f3f:	29 c2                	sub    %eax,%edx
  800f41:	89 d0                	mov    %edx,%eax
}
  800f43:	c9                   	leave  
  800f44:	c3                   	ret    

00800f45 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800f45:	55                   	push   %ebp
  800f46:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800f48:	eb 06                	jmp    800f50 <strcmp+0xb>
		p++, q++;
  800f4a:	ff 45 08             	incl   0x8(%ebp)
  800f4d:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800f50:	8b 45 08             	mov    0x8(%ebp),%eax
  800f53:	8a 00                	mov    (%eax),%al
  800f55:	84 c0                	test   %al,%al
  800f57:	74 0e                	je     800f67 <strcmp+0x22>
  800f59:	8b 45 08             	mov    0x8(%ebp),%eax
  800f5c:	8a 10                	mov    (%eax),%dl
  800f5e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f61:	8a 00                	mov    (%eax),%al
  800f63:	38 c2                	cmp    %al,%dl
  800f65:	74 e3                	je     800f4a <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800f67:	8b 45 08             	mov    0x8(%ebp),%eax
  800f6a:	8a 00                	mov    (%eax),%al
  800f6c:	0f b6 d0             	movzbl %al,%edx
  800f6f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f72:	8a 00                	mov    (%eax),%al
  800f74:	0f b6 c0             	movzbl %al,%eax
  800f77:	29 c2                	sub    %eax,%edx
  800f79:	89 d0                	mov    %edx,%eax
}
  800f7b:	5d                   	pop    %ebp
  800f7c:	c3                   	ret    

00800f7d <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800f7d:	55                   	push   %ebp
  800f7e:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800f80:	eb 09                	jmp    800f8b <strncmp+0xe>
		n--, p++, q++;
  800f82:	ff 4d 10             	decl   0x10(%ebp)
  800f85:	ff 45 08             	incl   0x8(%ebp)
  800f88:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800f8b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f8f:	74 17                	je     800fa8 <strncmp+0x2b>
  800f91:	8b 45 08             	mov    0x8(%ebp),%eax
  800f94:	8a 00                	mov    (%eax),%al
  800f96:	84 c0                	test   %al,%al
  800f98:	74 0e                	je     800fa8 <strncmp+0x2b>
  800f9a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f9d:	8a 10                	mov    (%eax),%dl
  800f9f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fa2:	8a 00                	mov    (%eax),%al
  800fa4:	38 c2                	cmp    %al,%dl
  800fa6:	74 da                	je     800f82 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800fa8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fac:	75 07                	jne    800fb5 <strncmp+0x38>
		return 0;
  800fae:	b8 00 00 00 00       	mov    $0x0,%eax
  800fb3:	eb 14                	jmp    800fc9 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800fb5:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb8:	8a 00                	mov    (%eax),%al
  800fba:	0f b6 d0             	movzbl %al,%edx
  800fbd:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fc0:	8a 00                	mov    (%eax),%al
  800fc2:	0f b6 c0             	movzbl %al,%eax
  800fc5:	29 c2                	sub    %eax,%edx
  800fc7:	89 d0                	mov    %edx,%eax
}
  800fc9:	5d                   	pop    %ebp
  800fca:	c3                   	ret    

00800fcb <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800fcb:	55                   	push   %ebp
  800fcc:	89 e5                	mov    %esp,%ebp
  800fce:	83 ec 04             	sub    $0x4,%esp
  800fd1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fd4:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800fd7:	eb 12                	jmp    800feb <strchr+0x20>
		if (*s == c)
  800fd9:	8b 45 08             	mov    0x8(%ebp),%eax
  800fdc:	8a 00                	mov    (%eax),%al
  800fde:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800fe1:	75 05                	jne    800fe8 <strchr+0x1d>
			return (char *) s;
  800fe3:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe6:	eb 11                	jmp    800ff9 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800fe8:	ff 45 08             	incl   0x8(%ebp)
  800feb:	8b 45 08             	mov    0x8(%ebp),%eax
  800fee:	8a 00                	mov    (%eax),%al
  800ff0:	84 c0                	test   %al,%al
  800ff2:	75 e5                	jne    800fd9 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800ff4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ff9:	c9                   	leave  
  800ffa:	c3                   	ret    

00800ffb <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800ffb:	55                   	push   %ebp
  800ffc:	89 e5                	mov    %esp,%ebp
  800ffe:	83 ec 04             	sub    $0x4,%esp
  801001:	8b 45 0c             	mov    0xc(%ebp),%eax
  801004:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801007:	eb 0d                	jmp    801016 <strfind+0x1b>
		if (*s == c)
  801009:	8b 45 08             	mov    0x8(%ebp),%eax
  80100c:	8a 00                	mov    (%eax),%al
  80100e:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801011:	74 0e                	je     801021 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801013:	ff 45 08             	incl   0x8(%ebp)
  801016:	8b 45 08             	mov    0x8(%ebp),%eax
  801019:	8a 00                	mov    (%eax),%al
  80101b:	84 c0                	test   %al,%al
  80101d:	75 ea                	jne    801009 <strfind+0xe>
  80101f:	eb 01                	jmp    801022 <strfind+0x27>
		if (*s == c)
			break;
  801021:	90                   	nop
	return (char *) s;
  801022:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801025:	c9                   	leave  
  801026:	c3                   	ret    

00801027 <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  801027:	55                   	push   %ebp
  801028:	89 e5                	mov    %esp,%ebp
  80102a:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  80102d:	8b 45 08             	mov    0x8(%ebp),%eax
  801030:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  801033:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801037:	76 63                	jbe    80109c <memset+0x75>
		uint64 data_block = c;
  801039:	8b 45 0c             	mov    0xc(%ebp),%eax
  80103c:	99                   	cltd   
  80103d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801040:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  801043:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801046:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801049:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  80104d:	c1 e0 08             	shl    $0x8,%eax
  801050:	09 45 f0             	or     %eax,-0x10(%ebp)
  801053:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  801056:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801059:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80105c:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  801060:	c1 e0 10             	shl    $0x10,%eax
  801063:	09 45 f0             	or     %eax,-0x10(%ebp)
  801066:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  801069:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80106c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80106f:	89 c2                	mov    %eax,%edx
  801071:	b8 00 00 00 00       	mov    $0x0,%eax
  801076:	09 45 f0             	or     %eax,-0x10(%ebp)
  801079:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  80107c:	eb 18                	jmp    801096 <memset+0x6f>
			*p64++ = data_block, n -= 8;
  80107e:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801081:	8d 41 08             	lea    0x8(%ecx),%eax
  801084:	89 45 fc             	mov    %eax,-0x4(%ebp)
  801087:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80108a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80108d:	89 01                	mov    %eax,(%ecx)
  80108f:	89 51 04             	mov    %edx,0x4(%ecx)
  801092:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  801096:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  80109a:	77 e2                	ja     80107e <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  80109c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010a0:	74 23                	je     8010c5 <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  8010a2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010a5:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  8010a8:	eb 0e                	jmp    8010b8 <memset+0x91>
			*p8++ = (uint8)c;
  8010aa:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010ad:	8d 50 01             	lea    0x1(%eax),%edx
  8010b0:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8010b3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010b6:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  8010b8:	8b 45 10             	mov    0x10(%ebp),%eax
  8010bb:	8d 50 ff             	lea    -0x1(%eax),%edx
  8010be:	89 55 10             	mov    %edx,0x10(%ebp)
  8010c1:	85 c0                	test   %eax,%eax
  8010c3:	75 e5                	jne    8010aa <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  8010c5:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8010c8:	c9                   	leave  
  8010c9:	c3                   	ret    

008010ca <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  8010ca:	55                   	push   %ebp
  8010cb:	89 e5                	mov    %esp,%ebp
  8010cd:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  8010d0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010d3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  8010d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8010d9:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  8010dc:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  8010e0:	76 24                	jbe    801106 <memcpy+0x3c>
		while(n >= 8){
  8010e2:	eb 1c                	jmp    801100 <memcpy+0x36>
			*d64 = *s64;
  8010e4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010e7:	8b 50 04             	mov    0x4(%eax),%edx
  8010ea:	8b 00                	mov    (%eax),%eax
  8010ec:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8010ef:	89 01                	mov    %eax,(%ecx)
  8010f1:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  8010f4:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  8010f8:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  8010fc:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  801100:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801104:	77 de                	ja     8010e4 <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  801106:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80110a:	74 31                	je     80113d <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  80110c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80110f:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  801112:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801115:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  801118:	eb 16                	jmp    801130 <memcpy+0x66>
			*d8++ = *s8++;
  80111a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80111d:	8d 50 01             	lea    0x1(%eax),%edx
  801120:	89 55 f0             	mov    %edx,-0x10(%ebp)
  801123:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801126:	8d 4a 01             	lea    0x1(%edx),%ecx
  801129:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  80112c:	8a 12                	mov    (%edx),%dl
  80112e:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  801130:	8b 45 10             	mov    0x10(%ebp),%eax
  801133:	8d 50 ff             	lea    -0x1(%eax),%edx
  801136:	89 55 10             	mov    %edx,0x10(%ebp)
  801139:	85 c0                	test   %eax,%eax
  80113b:	75 dd                	jne    80111a <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  80113d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801140:	c9                   	leave  
  801141:	c3                   	ret    

00801142 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801142:	55                   	push   %ebp
  801143:	89 e5                	mov    %esp,%ebp
  801145:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801148:	8b 45 0c             	mov    0xc(%ebp),%eax
  80114b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  80114e:	8b 45 08             	mov    0x8(%ebp),%eax
  801151:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801154:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801157:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80115a:	73 50                	jae    8011ac <memmove+0x6a>
  80115c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80115f:	8b 45 10             	mov    0x10(%ebp),%eax
  801162:	01 d0                	add    %edx,%eax
  801164:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801167:	76 43                	jbe    8011ac <memmove+0x6a>
		s += n;
  801169:	8b 45 10             	mov    0x10(%ebp),%eax
  80116c:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  80116f:	8b 45 10             	mov    0x10(%ebp),%eax
  801172:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  801175:	eb 10                	jmp    801187 <memmove+0x45>
			*--d = *--s;
  801177:	ff 4d f8             	decl   -0x8(%ebp)
  80117a:	ff 4d fc             	decl   -0x4(%ebp)
  80117d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801180:	8a 10                	mov    (%eax),%dl
  801182:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801185:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  801187:	8b 45 10             	mov    0x10(%ebp),%eax
  80118a:	8d 50 ff             	lea    -0x1(%eax),%edx
  80118d:	89 55 10             	mov    %edx,0x10(%ebp)
  801190:	85 c0                	test   %eax,%eax
  801192:	75 e3                	jne    801177 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801194:	eb 23                	jmp    8011b9 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  801196:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801199:	8d 50 01             	lea    0x1(%eax),%edx
  80119c:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80119f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8011a2:	8d 4a 01             	lea    0x1(%edx),%ecx
  8011a5:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8011a8:	8a 12                	mov    (%edx),%dl
  8011aa:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  8011ac:	8b 45 10             	mov    0x10(%ebp),%eax
  8011af:	8d 50 ff             	lea    -0x1(%eax),%edx
  8011b2:	89 55 10             	mov    %edx,0x10(%ebp)
  8011b5:	85 c0                	test   %eax,%eax
  8011b7:	75 dd                	jne    801196 <memmove+0x54>
			*d++ = *s++;

	return dst;
  8011b9:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8011bc:	c9                   	leave  
  8011bd:	c3                   	ret    

008011be <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8011be:	55                   	push   %ebp
  8011bf:	89 e5                	mov    %esp,%ebp
  8011c1:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  8011c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8011c7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  8011ca:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011cd:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8011d0:	eb 2a                	jmp    8011fc <memcmp+0x3e>
		if (*s1 != *s2)
  8011d2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011d5:	8a 10                	mov    (%eax),%dl
  8011d7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011da:	8a 00                	mov    (%eax),%al
  8011dc:	38 c2                	cmp    %al,%dl
  8011de:	74 16                	je     8011f6 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  8011e0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011e3:	8a 00                	mov    (%eax),%al
  8011e5:	0f b6 d0             	movzbl %al,%edx
  8011e8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011eb:	8a 00                	mov    (%eax),%al
  8011ed:	0f b6 c0             	movzbl %al,%eax
  8011f0:	29 c2                	sub    %eax,%edx
  8011f2:	89 d0                	mov    %edx,%eax
  8011f4:	eb 18                	jmp    80120e <memcmp+0x50>
		s1++, s2++;
  8011f6:	ff 45 fc             	incl   -0x4(%ebp)
  8011f9:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  8011fc:	8b 45 10             	mov    0x10(%ebp),%eax
  8011ff:	8d 50 ff             	lea    -0x1(%eax),%edx
  801202:	89 55 10             	mov    %edx,0x10(%ebp)
  801205:	85 c0                	test   %eax,%eax
  801207:	75 c9                	jne    8011d2 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801209:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80120e:	c9                   	leave  
  80120f:	c3                   	ret    

00801210 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801210:	55                   	push   %ebp
  801211:	89 e5                	mov    %esp,%ebp
  801213:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801216:	8b 55 08             	mov    0x8(%ebp),%edx
  801219:	8b 45 10             	mov    0x10(%ebp),%eax
  80121c:	01 d0                	add    %edx,%eax
  80121e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801221:	eb 15                	jmp    801238 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801223:	8b 45 08             	mov    0x8(%ebp),%eax
  801226:	8a 00                	mov    (%eax),%al
  801228:	0f b6 d0             	movzbl %al,%edx
  80122b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80122e:	0f b6 c0             	movzbl %al,%eax
  801231:	39 c2                	cmp    %eax,%edx
  801233:	74 0d                	je     801242 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801235:	ff 45 08             	incl   0x8(%ebp)
  801238:	8b 45 08             	mov    0x8(%ebp),%eax
  80123b:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80123e:	72 e3                	jb     801223 <memfind+0x13>
  801240:	eb 01                	jmp    801243 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801242:	90                   	nop
	return (void *) s;
  801243:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801246:	c9                   	leave  
  801247:	c3                   	ret    

00801248 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801248:	55                   	push   %ebp
  801249:	89 e5                	mov    %esp,%ebp
  80124b:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  80124e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801255:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80125c:	eb 03                	jmp    801261 <strtol+0x19>
		s++;
  80125e:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801261:	8b 45 08             	mov    0x8(%ebp),%eax
  801264:	8a 00                	mov    (%eax),%al
  801266:	3c 20                	cmp    $0x20,%al
  801268:	74 f4                	je     80125e <strtol+0x16>
  80126a:	8b 45 08             	mov    0x8(%ebp),%eax
  80126d:	8a 00                	mov    (%eax),%al
  80126f:	3c 09                	cmp    $0x9,%al
  801271:	74 eb                	je     80125e <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801273:	8b 45 08             	mov    0x8(%ebp),%eax
  801276:	8a 00                	mov    (%eax),%al
  801278:	3c 2b                	cmp    $0x2b,%al
  80127a:	75 05                	jne    801281 <strtol+0x39>
		s++;
  80127c:	ff 45 08             	incl   0x8(%ebp)
  80127f:	eb 13                	jmp    801294 <strtol+0x4c>
	else if (*s == '-')
  801281:	8b 45 08             	mov    0x8(%ebp),%eax
  801284:	8a 00                	mov    (%eax),%al
  801286:	3c 2d                	cmp    $0x2d,%al
  801288:	75 0a                	jne    801294 <strtol+0x4c>
		s++, neg = 1;
  80128a:	ff 45 08             	incl   0x8(%ebp)
  80128d:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801294:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801298:	74 06                	je     8012a0 <strtol+0x58>
  80129a:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  80129e:	75 20                	jne    8012c0 <strtol+0x78>
  8012a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a3:	8a 00                	mov    (%eax),%al
  8012a5:	3c 30                	cmp    $0x30,%al
  8012a7:	75 17                	jne    8012c0 <strtol+0x78>
  8012a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8012ac:	40                   	inc    %eax
  8012ad:	8a 00                	mov    (%eax),%al
  8012af:	3c 78                	cmp    $0x78,%al
  8012b1:	75 0d                	jne    8012c0 <strtol+0x78>
		s += 2, base = 16;
  8012b3:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8012b7:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8012be:	eb 28                	jmp    8012e8 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8012c0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8012c4:	75 15                	jne    8012db <strtol+0x93>
  8012c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8012c9:	8a 00                	mov    (%eax),%al
  8012cb:	3c 30                	cmp    $0x30,%al
  8012cd:	75 0c                	jne    8012db <strtol+0x93>
		s++, base = 8;
  8012cf:	ff 45 08             	incl   0x8(%ebp)
  8012d2:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8012d9:	eb 0d                	jmp    8012e8 <strtol+0xa0>
	else if (base == 0)
  8012db:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8012df:	75 07                	jne    8012e8 <strtol+0xa0>
		base = 10;
  8012e1:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8012e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8012eb:	8a 00                	mov    (%eax),%al
  8012ed:	3c 2f                	cmp    $0x2f,%al
  8012ef:	7e 19                	jle    80130a <strtol+0xc2>
  8012f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8012f4:	8a 00                	mov    (%eax),%al
  8012f6:	3c 39                	cmp    $0x39,%al
  8012f8:	7f 10                	jg     80130a <strtol+0xc2>
			dig = *s - '0';
  8012fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8012fd:	8a 00                	mov    (%eax),%al
  8012ff:	0f be c0             	movsbl %al,%eax
  801302:	83 e8 30             	sub    $0x30,%eax
  801305:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801308:	eb 42                	jmp    80134c <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  80130a:	8b 45 08             	mov    0x8(%ebp),%eax
  80130d:	8a 00                	mov    (%eax),%al
  80130f:	3c 60                	cmp    $0x60,%al
  801311:	7e 19                	jle    80132c <strtol+0xe4>
  801313:	8b 45 08             	mov    0x8(%ebp),%eax
  801316:	8a 00                	mov    (%eax),%al
  801318:	3c 7a                	cmp    $0x7a,%al
  80131a:	7f 10                	jg     80132c <strtol+0xe4>
			dig = *s - 'a' + 10;
  80131c:	8b 45 08             	mov    0x8(%ebp),%eax
  80131f:	8a 00                	mov    (%eax),%al
  801321:	0f be c0             	movsbl %al,%eax
  801324:	83 e8 57             	sub    $0x57,%eax
  801327:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80132a:	eb 20                	jmp    80134c <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  80132c:	8b 45 08             	mov    0x8(%ebp),%eax
  80132f:	8a 00                	mov    (%eax),%al
  801331:	3c 40                	cmp    $0x40,%al
  801333:	7e 39                	jle    80136e <strtol+0x126>
  801335:	8b 45 08             	mov    0x8(%ebp),%eax
  801338:	8a 00                	mov    (%eax),%al
  80133a:	3c 5a                	cmp    $0x5a,%al
  80133c:	7f 30                	jg     80136e <strtol+0x126>
			dig = *s - 'A' + 10;
  80133e:	8b 45 08             	mov    0x8(%ebp),%eax
  801341:	8a 00                	mov    (%eax),%al
  801343:	0f be c0             	movsbl %al,%eax
  801346:	83 e8 37             	sub    $0x37,%eax
  801349:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  80134c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80134f:	3b 45 10             	cmp    0x10(%ebp),%eax
  801352:	7d 19                	jge    80136d <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801354:	ff 45 08             	incl   0x8(%ebp)
  801357:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80135a:	0f af 45 10          	imul   0x10(%ebp),%eax
  80135e:	89 c2                	mov    %eax,%edx
  801360:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801363:	01 d0                	add    %edx,%eax
  801365:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801368:	e9 7b ff ff ff       	jmp    8012e8 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  80136d:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  80136e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801372:	74 08                	je     80137c <strtol+0x134>
		*endptr = (char *) s;
  801374:	8b 45 0c             	mov    0xc(%ebp),%eax
  801377:	8b 55 08             	mov    0x8(%ebp),%edx
  80137a:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  80137c:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801380:	74 07                	je     801389 <strtol+0x141>
  801382:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801385:	f7 d8                	neg    %eax
  801387:	eb 03                	jmp    80138c <strtol+0x144>
  801389:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80138c:	c9                   	leave  
  80138d:	c3                   	ret    

0080138e <ltostr>:

void
ltostr(long value, char *str)
{
  80138e:	55                   	push   %ebp
  80138f:	89 e5                	mov    %esp,%ebp
  801391:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801394:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  80139b:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8013a2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8013a6:	79 13                	jns    8013bb <ltostr+0x2d>
	{
		neg = 1;
  8013a8:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8013af:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013b2:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8013b5:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8013b8:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8013bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8013be:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8013c3:	99                   	cltd   
  8013c4:	f7 f9                	idiv   %ecx
  8013c6:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8013c9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8013cc:	8d 50 01             	lea    0x1(%eax),%edx
  8013cf:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8013d2:	89 c2                	mov    %eax,%edx
  8013d4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013d7:	01 d0                	add    %edx,%eax
  8013d9:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8013dc:	83 c2 30             	add    $0x30,%edx
  8013df:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8013e1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8013e4:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8013e9:	f7 e9                	imul   %ecx
  8013eb:	c1 fa 02             	sar    $0x2,%edx
  8013ee:	89 c8                	mov    %ecx,%eax
  8013f0:	c1 f8 1f             	sar    $0x1f,%eax
  8013f3:	29 c2                	sub    %eax,%edx
  8013f5:	89 d0                	mov    %edx,%eax
  8013f7:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  8013fa:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8013fe:	75 bb                	jne    8013bb <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801400:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801407:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80140a:	48                   	dec    %eax
  80140b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  80140e:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801412:	74 3d                	je     801451 <ltostr+0xc3>
		start = 1 ;
  801414:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  80141b:	eb 34                	jmp    801451 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  80141d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801420:	8b 45 0c             	mov    0xc(%ebp),%eax
  801423:	01 d0                	add    %edx,%eax
  801425:	8a 00                	mov    (%eax),%al
  801427:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  80142a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80142d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801430:	01 c2                	add    %eax,%edx
  801432:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801435:	8b 45 0c             	mov    0xc(%ebp),%eax
  801438:	01 c8                	add    %ecx,%eax
  80143a:	8a 00                	mov    (%eax),%al
  80143c:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  80143e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801441:	8b 45 0c             	mov    0xc(%ebp),%eax
  801444:	01 c2                	add    %eax,%edx
  801446:	8a 45 eb             	mov    -0x15(%ebp),%al
  801449:	88 02                	mov    %al,(%edx)
		start++ ;
  80144b:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  80144e:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801451:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801454:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801457:	7c c4                	jl     80141d <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801459:	8b 55 f8             	mov    -0x8(%ebp),%edx
  80145c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80145f:	01 d0                	add    %edx,%eax
  801461:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801464:	90                   	nop
  801465:	c9                   	leave  
  801466:	c3                   	ret    

00801467 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801467:	55                   	push   %ebp
  801468:	89 e5                	mov    %esp,%ebp
  80146a:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  80146d:	ff 75 08             	pushl  0x8(%ebp)
  801470:	e8 c4 f9 ff ff       	call   800e39 <strlen>
  801475:	83 c4 04             	add    $0x4,%esp
  801478:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  80147b:	ff 75 0c             	pushl  0xc(%ebp)
  80147e:	e8 b6 f9 ff ff       	call   800e39 <strlen>
  801483:	83 c4 04             	add    $0x4,%esp
  801486:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801489:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801490:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801497:	eb 17                	jmp    8014b0 <strcconcat+0x49>
		final[s] = str1[s] ;
  801499:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80149c:	8b 45 10             	mov    0x10(%ebp),%eax
  80149f:	01 c2                	add    %eax,%edx
  8014a1:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8014a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8014a7:	01 c8                	add    %ecx,%eax
  8014a9:	8a 00                	mov    (%eax),%al
  8014ab:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8014ad:	ff 45 fc             	incl   -0x4(%ebp)
  8014b0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8014b3:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8014b6:	7c e1                	jl     801499 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8014b8:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8014bf:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8014c6:	eb 1f                	jmp    8014e7 <strcconcat+0x80>
		final[s++] = str2[i] ;
  8014c8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8014cb:	8d 50 01             	lea    0x1(%eax),%edx
  8014ce:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8014d1:	89 c2                	mov    %eax,%edx
  8014d3:	8b 45 10             	mov    0x10(%ebp),%eax
  8014d6:	01 c2                	add    %eax,%edx
  8014d8:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8014db:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014de:	01 c8                	add    %ecx,%eax
  8014e0:	8a 00                	mov    (%eax),%al
  8014e2:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8014e4:	ff 45 f8             	incl   -0x8(%ebp)
  8014e7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8014ea:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8014ed:	7c d9                	jl     8014c8 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8014ef:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8014f2:	8b 45 10             	mov    0x10(%ebp),%eax
  8014f5:	01 d0                	add    %edx,%eax
  8014f7:	c6 00 00             	movb   $0x0,(%eax)
}
  8014fa:	90                   	nop
  8014fb:	c9                   	leave  
  8014fc:	c3                   	ret    

008014fd <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8014fd:	55                   	push   %ebp
  8014fe:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801500:	8b 45 14             	mov    0x14(%ebp),%eax
  801503:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801509:	8b 45 14             	mov    0x14(%ebp),%eax
  80150c:	8b 00                	mov    (%eax),%eax
  80150e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801515:	8b 45 10             	mov    0x10(%ebp),%eax
  801518:	01 d0                	add    %edx,%eax
  80151a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801520:	eb 0c                	jmp    80152e <strsplit+0x31>
			*string++ = 0;
  801522:	8b 45 08             	mov    0x8(%ebp),%eax
  801525:	8d 50 01             	lea    0x1(%eax),%edx
  801528:	89 55 08             	mov    %edx,0x8(%ebp)
  80152b:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80152e:	8b 45 08             	mov    0x8(%ebp),%eax
  801531:	8a 00                	mov    (%eax),%al
  801533:	84 c0                	test   %al,%al
  801535:	74 18                	je     80154f <strsplit+0x52>
  801537:	8b 45 08             	mov    0x8(%ebp),%eax
  80153a:	8a 00                	mov    (%eax),%al
  80153c:	0f be c0             	movsbl %al,%eax
  80153f:	50                   	push   %eax
  801540:	ff 75 0c             	pushl  0xc(%ebp)
  801543:	e8 83 fa ff ff       	call   800fcb <strchr>
  801548:	83 c4 08             	add    $0x8,%esp
  80154b:	85 c0                	test   %eax,%eax
  80154d:	75 d3                	jne    801522 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  80154f:	8b 45 08             	mov    0x8(%ebp),%eax
  801552:	8a 00                	mov    (%eax),%al
  801554:	84 c0                	test   %al,%al
  801556:	74 5a                	je     8015b2 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801558:	8b 45 14             	mov    0x14(%ebp),%eax
  80155b:	8b 00                	mov    (%eax),%eax
  80155d:	83 f8 0f             	cmp    $0xf,%eax
  801560:	75 07                	jne    801569 <strsplit+0x6c>
		{
			return 0;
  801562:	b8 00 00 00 00       	mov    $0x0,%eax
  801567:	eb 66                	jmp    8015cf <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801569:	8b 45 14             	mov    0x14(%ebp),%eax
  80156c:	8b 00                	mov    (%eax),%eax
  80156e:	8d 48 01             	lea    0x1(%eax),%ecx
  801571:	8b 55 14             	mov    0x14(%ebp),%edx
  801574:	89 0a                	mov    %ecx,(%edx)
  801576:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80157d:	8b 45 10             	mov    0x10(%ebp),%eax
  801580:	01 c2                	add    %eax,%edx
  801582:	8b 45 08             	mov    0x8(%ebp),%eax
  801585:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801587:	eb 03                	jmp    80158c <strsplit+0x8f>
			string++;
  801589:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  80158c:	8b 45 08             	mov    0x8(%ebp),%eax
  80158f:	8a 00                	mov    (%eax),%al
  801591:	84 c0                	test   %al,%al
  801593:	74 8b                	je     801520 <strsplit+0x23>
  801595:	8b 45 08             	mov    0x8(%ebp),%eax
  801598:	8a 00                	mov    (%eax),%al
  80159a:	0f be c0             	movsbl %al,%eax
  80159d:	50                   	push   %eax
  80159e:	ff 75 0c             	pushl  0xc(%ebp)
  8015a1:	e8 25 fa ff ff       	call   800fcb <strchr>
  8015a6:	83 c4 08             	add    $0x8,%esp
  8015a9:	85 c0                	test   %eax,%eax
  8015ab:	74 dc                	je     801589 <strsplit+0x8c>
			string++;
	}
  8015ad:	e9 6e ff ff ff       	jmp    801520 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8015b2:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8015b3:	8b 45 14             	mov    0x14(%ebp),%eax
  8015b6:	8b 00                	mov    (%eax),%eax
  8015b8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8015bf:	8b 45 10             	mov    0x10(%ebp),%eax
  8015c2:	01 d0                	add    %edx,%eax
  8015c4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8015ca:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8015cf:	c9                   	leave  
  8015d0:	c3                   	ret    

008015d1 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  8015d1:	55                   	push   %ebp
  8015d2:	89 e5                	mov    %esp,%ebp
  8015d4:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  8015d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8015da:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  8015dd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8015e4:	eb 4a                	jmp    801630 <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  8015e6:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8015e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8015ec:	01 c2                	add    %eax,%edx
  8015ee:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8015f1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015f4:	01 c8                	add    %ecx,%eax
  8015f6:	8a 00                	mov    (%eax),%al
  8015f8:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  8015fa:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8015fd:	8b 45 0c             	mov    0xc(%ebp),%eax
  801600:	01 d0                	add    %edx,%eax
  801602:	8a 00                	mov    (%eax),%al
  801604:	3c 40                	cmp    $0x40,%al
  801606:	7e 25                	jle    80162d <str2lower+0x5c>
  801608:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80160b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80160e:	01 d0                	add    %edx,%eax
  801610:	8a 00                	mov    (%eax),%al
  801612:	3c 5a                	cmp    $0x5a,%al
  801614:	7f 17                	jg     80162d <str2lower+0x5c>
		{
			dst[i] += 32 ;
  801616:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801619:	8b 45 08             	mov    0x8(%ebp),%eax
  80161c:	01 d0                	add    %edx,%eax
  80161e:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801621:	8b 55 08             	mov    0x8(%ebp),%edx
  801624:	01 ca                	add    %ecx,%edx
  801626:	8a 12                	mov    (%edx),%dl
  801628:	83 c2 20             	add    $0x20,%edx
  80162b:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  80162d:	ff 45 fc             	incl   -0x4(%ebp)
  801630:	ff 75 0c             	pushl  0xc(%ebp)
  801633:	e8 01 f8 ff ff       	call   800e39 <strlen>
  801638:	83 c4 04             	add    $0x4,%esp
  80163b:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80163e:	7f a6                	jg     8015e6 <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  801640:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801643:	c9                   	leave  
  801644:	c3                   	ret    

00801645 <uheap_init>:
//==============================================
// [1] INITIALIZE USER HEAP:
//==============================================
int __firstTimeFlag = 1;
void uheap_init()
{
  801645:	55                   	push   %ebp
  801646:	89 e5                	mov    %esp,%ebp
  801648:	83 ec 08             	sub    $0x8,%esp
	if(__firstTimeFlag)
  80164b:	a1 08 60 80 00       	mov    0x806008,%eax
  801650:	85 c0                	test   %eax,%eax
  801652:	0f 84 95 00 00 00    	je     8016ed <uheap_init+0xa8>
	{
		initialize_dynamic_allocator(USER_HEAP_START, USER_HEAP_START + DYN_ALLOC_MAX_SIZE);
  801658:	83 ec 08             	sub    $0x8,%esp
  80165b:	68 00 00 00 82       	push   $0x82000000
  801660:	68 00 00 00 80       	push   $0x80000000
  801665:	e8 59 1f 00 00       	call   8035c3 <initialize_dynamic_allocator>
  80166a:	83 c4 10             	add    $0x10,%esp
		uheapPlaceStrategy = sys_get_uheap_strategy();
  80166d:	e8 93 1d 00 00       	call   803405 <sys_get_uheap_strategy>
  801672:	a3 00 fb 87 00       	mov    %eax,0x87fb00
		uheapPageAllocStart = dynAllocEnd + PAGE_SIZE;
  801677:	a1 40 60 80 00       	mov    0x806040,%eax
  80167c:	05 00 10 00 00       	add    $0x1000,%eax
  801681:	a3 b0 fb 87 00       	mov    %eax,0x87fbb0
		uheapPageAllocBreak = uheapPageAllocStart;
  801686:	a1 b0 fb 87 00       	mov    0x87fbb0,%eax
  80168b:	a3 08 fb 87 00       	mov    %eax,0x87fb08
		init_uspinlock(&ulock,"malloc",1);
  801690:	83 ec 04             	sub    $0x4,%esp
  801693:	6a 01                	push   $0x1
  801695:	68 68 4b 80 00       	push   $0x804b68
  80169a:	68 80 16 8e 00       	push   $0x8e1680
  80169f:	e8 8d 29 00 00       	call   804031 <init_uspinlock>
  8016a4:	83 c4 10             	add    $0x10,%esp
		LIST_INIT(&u_freelist);
  8016a7:	c7 05 60 16 8e 00 00 	movl   $0x0,0x8e1660
  8016ae:	00 00 00 
  8016b1:	c7 05 64 16 8e 00 00 	movl   $0x0,0x8e1664
  8016b8:	00 00 00 
  8016bb:	c7 05 6c 16 8e 00 00 	movl   $0x0,0x8e166c
  8016c2:	00 00 00 
		LIST_INIT(&u_allocatedlist);
  8016c5:	c7 05 70 16 8e 00 00 	movl   $0x0,0x8e1670
  8016cc:	00 00 00 
  8016cf:	c7 05 74 16 8e 00 00 	movl   $0x0,0x8e1674
  8016d6:	00 00 00 
  8016d9:	c7 05 7c 16 8e 00 00 	movl   $0x0,0x8e167c
  8016e0:	00 00 00 
		__firstTimeFlag = 0;
  8016e3:	c7 05 08 60 80 00 00 	movl   $0x0,0x806008
  8016ea:	00 00 00 
	}
}
  8016ed:	90                   	nop
  8016ee:	c9                   	leave  
  8016ef:	c3                   	ret    

008016f0 <get_page>:

//==============================================
// [2] GET A PAGE FROM THE KERNEL FOR DA:
//==============================================
int get_page(void* va)
{
  8016f0:	55                   	push   %ebp
  8016f1:	89 e5                	mov    %esp,%ebp
  8016f3:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_allocate_page(ROUNDDOWN(va, PAGE_SIZE), PERM_USER|PERM_WRITEABLE|PERM_UHPAGE);
  8016f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8016f9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8016fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016ff:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801704:	83 ec 08             	sub    $0x8,%esp
  801707:	68 06 04 00 00       	push   $0x406
  80170c:	50                   	push   %eax
  80170d:	e8 3d 19 00 00       	call   80304f <__sys_allocate_page>
  801712:	83 c4 10             	add    $0x10,%esp
  801715:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  801718:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80171c:	79 14                	jns    801732 <get_page+0x42>
		panic("get_page() in user: failed to allocate page from the kernel");
  80171e:	83 ec 04             	sub    $0x4,%esp
  801721:	68 70 4b 80 00       	push   $0x804b70
  801726:	6a 2d                	push   $0x2d
  801728:	68 ac 4b 80 00       	push   $0x804bac
  80172d:	e8 07 2a 00 00       	call   804139 <_panic>
	return 0;
  801732:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801737:	c9                   	leave  
  801738:	c3                   	ret    

00801739 <return_page>:

//==============================================
// [3] RETURN A PAGE FROM THE DA TO KERNEL:
//==============================================
void return_page(void* va)
{
  801739:	55                   	push   %ebp
  80173a:	89 e5                	mov    %esp,%ebp
  80173c:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_unmap_frame(ROUNDDOWN((uint32)va, PAGE_SIZE));
  80173f:	8b 45 08             	mov    0x8(%ebp),%eax
  801742:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801745:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801748:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80174d:	83 ec 0c             	sub    $0xc,%esp
  801750:	50                   	push   %eax
  801751:	e8 40 19 00 00       	call   803096 <__sys_unmap_frame>
  801756:	83 c4 10             	add    $0x10,%esp
  801759:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  80175c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801760:	79 14                	jns    801776 <return_page+0x3d>
		panic("return_page() in user: failed to return a page to the kernel");
  801762:	83 ec 04             	sub    $0x4,%esp
  801765:	68 b8 4b 80 00       	push   $0x804bb8
  80176a:	6a 38                	push   $0x38
  80176c:	68 ac 4b 80 00       	push   $0x804bac
  801771:	e8 c3 29 00 00       	call   804139 <_panic>
}
  801776:	90                   	nop
  801777:	c9                   	leave  
  801778:	c3                   	ret    

00801779 <malloc>:

//=================================
// [1] ALLOCATE SPACE IN USER HEAP:
//=================================
void* malloc(uint32 size)
{
  801779:	55                   	push   %ebp
  80177a:	89 e5                	mov    %esp,%ebp
  80177c:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  80177f:	e8 c1 fe ff ff       	call   801645 <uheap_init>
	if (size == 0) return NULL ;
  801784:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801788:	75 0a                	jne    801794 <malloc+0x1b>
  80178a:	b8 00 00 00 00       	mov    $0x0,%eax
  80178f:	e9 e1 04 00 00       	jmp    801c75 <malloc+0x4fc>
	//==============================================================

	acquire_uspinlock(&ulock);
  801794:	83 ec 0c             	sub    $0xc,%esp
  801797:	68 80 16 8e 00       	push   $0x8e1680
  80179c:	e8 df 28 00 00       	call   804080 <acquire_uspinlock>
  8017a1:	83 c4 10             	add    $0x10,%esp
	if(size <  DYN_ALLOC_MAX_BLOCK_SIZE){
  8017a4:	81 7d 08 ff 07 00 00 	cmpl   $0x7ff,0x8(%ebp)
  8017ab:	77 23                	ja     8017d0 <malloc+0x57>
		release_uspinlock(&ulock);
  8017ad:	83 ec 0c             	sub    $0xc,%esp
  8017b0:	68 80 16 8e 00       	push   $0x8e1680
  8017b5:	e8 1e 29 00 00       	call   8040d8 <release_uspinlock>
  8017ba:	83 c4 10             	add    $0x10,%esp
		return alloc_block(size);
  8017bd:	83 ec 0c             	sub    $0xc,%esp
  8017c0:	ff 75 08             	pushl  0x8(%ebp)
  8017c3:	e8 dd 1f 00 00       	call   8037a5 <alloc_block>
  8017c8:	83 c4 10             	add    $0x10,%esp
  8017cb:	e9 a5 04 00 00       	jmp    801c75 <malloc+0x4fc>
	}

	struct UserHeapStruct* allocblock= (struct UserHeapStruct*) alloc_block(sizeof(struct UserHeapStruct));
  8017d0:	83 ec 0c             	sub    $0xc,%esp
  8017d3:	6a 10                	push   $0x10
  8017d5:	e8 cb 1f 00 00       	call   8037a5 <alloc_block>
  8017da:	83 c4 10             	add    $0x10,%esp
  8017dd:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (allocblock == NULL){
  8017e0:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8017e4:	75 0a                	jne    8017f0 <malloc+0x77>
			return NULL;
  8017e6:	b8 00 00 00 00       	mov    $0x0,%eax
  8017eb:	e9 85 04 00 00       	jmp    801c75 <malloc+0x4fc>
	}

	size = ROUNDUP(size,PAGE_SIZE);
  8017f0:	c7 45 e8 00 10 00 00 	movl   $0x1000,-0x18(%ebp)
  8017f7:	8b 55 08             	mov    0x8(%ebp),%edx
  8017fa:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8017fd:	01 d0                	add    %edx,%eax
  8017ff:	48                   	dec    %eax
  801800:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801803:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801806:	ba 00 00 00 00       	mov    $0x0,%edx
  80180b:	f7 75 e8             	divl   -0x18(%ebp)
  80180e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801811:	29 d0                	sub    %edx,%eax
  801813:	89 45 08             	mov    %eax,0x8(%ebp)
	struct UserHeapStruct* lastfreeelement = LIST_LAST(&u_freelist);
  801816:	a1 64 16 8e 00       	mov    0x8e1664,%eax
  80181b:	89 45 e0             	mov    %eax,-0x20(%ebp)

	if(LIST_SIZE(&u_freelist)==0 || size>lastfreeelement->size){
  80181e:	a1 6c 16 8e 00       	mov    0x8e166c,%eax
  801823:	85 c0                	test   %eax,%eax
  801825:	74 0f                	je     801836 <malloc+0xbd>
  801827:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80182a:	8b 40 04             	mov    0x4(%eax),%eax
  80182d:	3b 45 08             	cmp    0x8(%ebp),%eax
  801830:	0f 83 ea 00 00 00    	jae    801920 <malloc+0x1a7>
			if(uheapPageAllocBreak < USER_HEAP_MAX - size){
  801836:	b8 00 00 00 a0       	mov    $0xa0000000,%eax
  80183b:	2b 45 08             	sub    0x8(%ebp),%eax
  80183e:	89 c2                	mov    %eax,%edx
  801840:	a1 08 fb 87 00       	mov    0x87fb08,%eax
  801845:	39 c2                	cmp    %eax,%edx
  801847:	0f 86 b9 00 00 00    	jbe    801906 <malloc+0x18d>
					uint32 requestedblockva = uheapPageAllocBreak;
  80184d:	a1 08 fb 87 00       	mov    0x87fb08,%eax
  801852:	89 45 dc             	mov    %eax,-0x24(%ebp)
					uheapPageAllocBreak+=size;
  801855:	8b 15 08 fb 87 00    	mov    0x87fb08,%edx
  80185b:	8b 45 08             	mov    0x8(%ebp),%eax
  80185e:	01 d0                	add    %edx,%eax
  801860:	a3 08 fb 87 00       	mov    %eax,0x87fb08
					allocblock->startva = requestedblockva;
  801865:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801868:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80186b:	89 10                	mov    %edx,(%eax)
					allocblock->size = size;
  80186d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801870:	8b 55 08             	mov    0x8(%ebp),%edx
  801873:	89 50 04             	mov    %edx,0x4(%eax)

					LIST_INSERT_TAIL(&u_allocatedlist, allocblock);
  801876:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80187a:	75 14                	jne    801890 <malloc+0x117>
  80187c:	83 ec 04             	sub    $0x4,%esp
  80187f:	68 f8 4b 80 00       	push   $0x804bf8
  801884:	6a 60                	push   $0x60
  801886:	68 ac 4b 80 00       	push   $0x804bac
  80188b:	e8 a9 28 00 00       	call   804139 <_panic>
  801890:	8b 15 74 16 8e 00    	mov    0x8e1674,%edx
  801896:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801899:	89 50 0c             	mov    %edx,0xc(%eax)
  80189c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80189f:	8b 40 0c             	mov    0xc(%eax),%eax
  8018a2:	85 c0                	test   %eax,%eax
  8018a4:	74 0d                	je     8018b3 <malloc+0x13a>
  8018a6:	a1 74 16 8e 00       	mov    0x8e1674,%eax
  8018ab:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8018ae:	89 50 08             	mov    %edx,0x8(%eax)
  8018b1:	eb 08                	jmp    8018bb <malloc+0x142>
  8018b3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8018b6:	a3 70 16 8e 00       	mov    %eax,0x8e1670
  8018bb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8018be:	a3 74 16 8e 00       	mov    %eax,0x8e1674
  8018c3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8018c6:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  8018cd:	a1 7c 16 8e 00       	mov    0x8e167c,%eax
  8018d2:	40                   	inc    %eax
  8018d3:	a3 7c 16 8e 00       	mov    %eax,0x8e167c


					sys_allocate_user_mem(allocblock->startva ,size);
  8018d8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8018db:	8b 00                	mov    (%eax),%eax
  8018dd:	83 ec 08             	sub    $0x8,%esp
  8018e0:	ff 75 08             	pushl  0x8(%ebp)
  8018e3:	50                   	push   %eax
  8018e4:	e8 34 1c 00 00       	call   80351d <sys_allocate_user_mem>
  8018e9:	83 c4 10             	add    $0x10,%esp
					release_uspinlock(&ulock);
  8018ec:	83 ec 0c             	sub    $0xc,%esp
  8018ef:	68 80 16 8e 00       	push   $0x8e1680
  8018f4:	e8 df 27 00 00       	call   8040d8 <release_uspinlock>
  8018f9:	83 c4 10             	add    $0x10,%esp
					return (void*)allocblock->startva;
  8018fc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8018ff:	8b 00                	mov    (%eax),%eax
  801901:	e9 6f 03 00 00       	jmp    801c75 <malloc+0x4fc>
			}else{
					release_uspinlock(&ulock);
  801906:	83 ec 0c             	sub    $0xc,%esp
  801909:	68 80 16 8e 00       	push   $0x8e1680
  80190e:	e8 c5 27 00 00       	call   8040d8 <release_uspinlock>
  801913:	83 c4 10             	add    $0x10,%esp
					return NULL;
  801916:	b8 00 00 00 00       	mov    $0x0,%eax
  80191b:	e9 55 03 00 00       	jmp    801c75 <malloc+0x4fc>
				}
	}else{
		//custom fit
		struct UserHeapStruct* currentfreeelement = LIST_FIRST(&u_freelist);
  801920:	a1 60 16 8e 00       	mov    0x8e1660,%eax
  801925:	89 45 f4             	mov    %eax,-0xc(%ebp)
		//worst fit
		while(currentfreeelement != NULL){
  801928:	e9 39 03 00 00       	jmp    801c66 <malloc+0x4ed>
			if(size<currentfreeelement->size){
  80192d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801930:	8b 40 04             	mov    0x4(%eax),%eax
  801933:	3b 45 08             	cmp    0x8(%ebp),%eax
  801936:	0f 86 e7 01 00 00    	jbe    801b23 <malloc+0x3aa>
				allocblock->startva = lastfreeelement->startva;
  80193c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80193f:	8b 10                	mov    (%eax),%edx
  801941:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801944:	89 10                	mov    %edx,(%eax)
                allocblock->size = size;
  801946:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801949:	8b 55 08             	mov    0x8(%ebp),%edx
  80194c:	89 50 04             	mov    %edx,0x4(%eax)
                LIST_INSERT_TAIL(&u_allocatedlist,allocblock);
  80194f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801953:	75 14                	jne    801969 <malloc+0x1f0>
  801955:	83 ec 04             	sub    $0x4,%esp
  801958:	68 f8 4b 80 00       	push   $0x804bf8
  80195d:	6a 72                	push   $0x72
  80195f:	68 ac 4b 80 00       	push   $0x804bac
  801964:	e8 d0 27 00 00       	call   804139 <_panic>
  801969:	8b 15 74 16 8e 00    	mov    0x8e1674,%edx
  80196f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801972:	89 50 0c             	mov    %edx,0xc(%eax)
  801975:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801978:	8b 40 0c             	mov    0xc(%eax),%eax
  80197b:	85 c0                	test   %eax,%eax
  80197d:	74 0d                	je     80198c <malloc+0x213>
  80197f:	a1 74 16 8e 00       	mov    0x8e1674,%eax
  801984:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801987:	89 50 08             	mov    %edx,0x8(%eax)
  80198a:	eb 08                	jmp    801994 <malloc+0x21b>
  80198c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80198f:	a3 70 16 8e 00       	mov    %eax,0x8e1670
  801994:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801997:	a3 74 16 8e 00       	mov    %eax,0x8e1674
  80199c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80199f:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  8019a6:	a1 7c 16 8e 00       	mov    0x8e167c,%eax
  8019ab:	40                   	inc    %eax
  8019ac:	a3 7c 16 8e 00       	mov    %eax,0x8e167c
                lastfreeelement->startva += size;
  8019b1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8019b4:	8b 10                	mov    (%eax),%edx
  8019b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8019b9:	01 c2                	add    %eax,%edx
  8019bb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8019be:	89 10                	mov    %edx,(%eax)
                lastfreeelement->size -= size;
  8019c0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8019c3:	8b 40 04             	mov    0x4(%eax),%eax
  8019c6:	2b 45 08             	sub    0x8(%ebp),%eax
  8019c9:	89 c2                	mov    %eax,%edx
  8019cb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8019ce:	89 50 04             	mov    %edx,0x4(%eax)
                struct UserHeapStruct* currentfree2 = LIST_FIRST(&u_freelist);
  8019d1:	a1 60 16 8e 00       	mov    0x8e1660,%eax
  8019d6:	89 45 f0             	mov    %eax,-0x10(%ebp)
                //check order of last element

                while (currentfree2 != NULL){
  8019d9:	e9 0d 01 00 00       	jmp    801aeb <malloc+0x372>
                	if(lastfreeelement->size <currentfree2->size){
  8019de:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8019e1:	8b 50 04             	mov    0x4(%eax),%edx
  8019e4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019e7:	8b 40 04             	mov    0x4(%eax),%eax
  8019ea:	39 c2                	cmp    %eax,%edx
  8019ec:	0f 83 f0 00 00 00    	jae    801ae2 <malloc+0x369>
                		LIST_REMOVE(&u_freelist ,lastfreeelement);
  8019f2:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8019f6:	75 14                	jne    801a0c <malloc+0x293>
  8019f8:	83 ec 04             	sub    $0x4,%esp
  8019fb:	68 1b 4c 80 00       	push   $0x804c1b
  801a00:	6a 7a                	push   $0x7a
  801a02:	68 ac 4b 80 00       	push   $0x804bac
  801a07:	e8 2d 27 00 00       	call   804139 <_panic>
  801a0c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801a0f:	8b 40 08             	mov    0x8(%eax),%eax
  801a12:	85 c0                	test   %eax,%eax
  801a14:	74 11                	je     801a27 <malloc+0x2ae>
  801a16:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801a19:	8b 40 08             	mov    0x8(%eax),%eax
  801a1c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801a1f:	8b 52 0c             	mov    0xc(%edx),%edx
  801a22:	89 50 0c             	mov    %edx,0xc(%eax)
  801a25:	eb 0b                	jmp    801a32 <malloc+0x2b9>
  801a27:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801a2a:	8b 40 0c             	mov    0xc(%eax),%eax
  801a2d:	a3 64 16 8e 00       	mov    %eax,0x8e1664
  801a32:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801a35:	8b 40 0c             	mov    0xc(%eax),%eax
  801a38:	85 c0                	test   %eax,%eax
  801a3a:	74 11                	je     801a4d <malloc+0x2d4>
  801a3c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801a3f:	8b 40 0c             	mov    0xc(%eax),%eax
  801a42:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801a45:	8b 52 08             	mov    0x8(%edx),%edx
  801a48:	89 50 08             	mov    %edx,0x8(%eax)
  801a4b:	eb 0b                	jmp    801a58 <malloc+0x2df>
  801a4d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801a50:	8b 40 08             	mov    0x8(%eax),%eax
  801a53:	a3 60 16 8e 00       	mov    %eax,0x8e1660
  801a58:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801a5b:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  801a62:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801a65:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  801a6c:	a1 6c 16 8e 00       	mov    0x8e166c,%eax
  801a71:	48                   	dec    %eax
  801a72:	a3 6c 16 8e 00       	mov    %eax,0x8e166c
                		LIST_INSERT_BEFORE(&u_freelist ,currentfree2 ,lastfreeelement);
  801a77:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801a7b:	74 06                	je     801a83 <malloc+0x30a>
  801a7d:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801a81:	75 14                	jne    801a97 <malloc+0x31e>
  801a83:	83 ec 04             	sub    $0x4,%esp
  801a86:	68 3c 4c 80 00       	push   $0x804c3c
  801a8b:	6a 7b                	push   $0x7b
  801a8d:	68 ac 4b 80 00       	push   $0x804bac
  801a92:	e8 a2 26 00 00       	call   804139 <_panic>
  801a97:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a9a:	8b 50 0c             	mov    0xc(%eax),%edx
  801a9d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801aa0:	89 50 0c             	mov    %edx,0xc(%eax)
  801aa3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801aa6:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801aa9:	89 50 08             	mov    %edx,0x8(%eax)
  801aac:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801aaf:	8b 40 0c             	mov    0xc(%eax),%eax
  801ab2:	85 c0                	test   %eax,%eax
  801ab4:	74 0e                	je     801ac4 <malloc+0x34b>
  801ab6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ab9:	8b 40 0c             	mov    0xc(%eax),%eax
  801abc:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801abf:	89 50 08             	mov    %edx,0x8(%eax)
  801ac2:	eb 08                	jmp    801acc <malloc+0x353>
  801ac4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801ac7:	a3 60 16 8e 00       	mov    %eax,0x8e1660
  801acc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801acf:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801ad2:	89 50 0c             	mov    %edx,0xc(%eax)
  801ad5:	a1 6c 16 8e 00       	mov    0x8e166c,%eax
  801ada:	40                   	inc    %eax
  801adb:	a3 6c 16 8e 00       	mov    %eax,0x8e166c
                		break;
  801ae0:	eb 13                	jmp    801af5 <malloc+0x37c>
                	}
                	currentfree2 = currentfree2->prev_next_info.le_next;
  801ae2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ae5:	8b 40 08             	mov    0x8(%eax),%eax
  801ae8:	89 45 f0             	mov    %eax,-0x10(%ebp)
                lastfreeelement->startva += size;
                lastfreeelement->size -= size;
                struct UserHeapStruct* currentfree2 = LIST_FIRST(&u_freelist);
                //check order of last element

                while (currentfree2 != NULL){
  801aeb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801aef:	0f 85 e9 fe ff ff    	jne    8019de <malloc+0x265>
                	}
                	currentfree2 = currentfree2->prev_next_info.le_next;
                }


                sys_allocate_user_mem(allocblock->startva ,size);
  801af5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801af8:	8b 00                	mov    (%eax),%eax
  801afa:	83 ec 08             	sub    $0x8,%esp
  801afd:	ff 75 08             	pushl  0x8(%ebp)
  801b00:	50                   	push   %eax
  801b01:	e8 17 1a 00 00       	call   80351d <sys_allocate_user_mem>
  801b06:	83 c4 10             	add    $0x10,%esp
                release_uspinlock(&ulock);
  801b09:	83 ec 0c             	sub    $0xc,%esp
  801b0c:	68 80 16 8e 00       	push   $0x8e1680
  801b11:	e8 c2 25 00 00       	call   8040d8 <release_uspinlock>
  801b16:	83 c4 10             	add    $0x10,%esp
                return (void*)allocblock->startva;
  801b19:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801b1c:	8b 00                	mov    (%eax),%eax
  801b1e:	e9 52 01 00 00       	jmp    801c75 <malloc+0x4fc>
                //exact fit
			}else if(size == currentfreeelement->size){
  801b23:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b26:	8b 40 04             	mov    0x4(%eax),%eax
  801b29:	3b 45 08             	cmp    0x8(%ebp),%eax
  801b2c:	0f 85 2b 01 00 00    	jne    801c5d <malloc+0x4e4>
				allocblock->startva = currentfreeelement->startva;
  801b32:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b35:	8b 10                	mov    (%eax),%edx
  801b37:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801b3a:	89 10                	mov    %edx,(%eax)
				allocblock->size = size;
  801b3c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801b3f:	8b 55 08             	mov    0x8(%ebp),%edx
  801b42:	89 50 04             	mov    %edx,0x4(%eax)
				LIST_INSERT_TAIL(&u_allocatedlist ,allocblock);
  801b45:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801b49:	75 17                	jne    801b62 <malloc+0x3e9>
  801b4b:	83 ec 04             	sub    $0x4,%esp
  801b4e:	68 f8 4b 80 00       	push   $0x804bf8
  801b53:	68 89 00 00 00       	push   $0x89
  801b58:	68 ac 4b 80 00       	push   $0x804bac
  801b5d:	e8 d7 25 00 00       	call   804139 <_panic>
  801b62:	8b 15 74 16 8e 00    	mov    0x8e1674,%edx
  801b68:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801b6b:	89 50 0c             	mov    %edx,0xc(%eax)
  801b6e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801b71:	8b 40 0c             	mov    0xc(%eax),%eax
  801b74:	85 c0                	test   %eax,%eax
  801b76:	74 0d                	je     801b85 <malloc+0x40c>
  801b78:	a1 74 16 8e 00       	mov    0x8e1674,%eax
  801b7d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801b80:	89 50 08             	mov    %edx,0x8(%eax)
  801b83:	eb 08                	jmp    801b8d <malloc+0x414>
  801b85:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801b88:	a3 70 16 8e 00       	mov    %eax,0x8e1670
  801b8d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801b90:	a3 74 16 8e 00       	mov    %eax,0x8e1674
  801b95:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801b98:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  801b9f:	a1 7c 16 8e 00       	mov    0x8e167c,%eax
  801ba4:	40                   	inc    %eax
  801ba5:	a3 7c 16 8e 00       	mov    %eax,0x8e167c
				LIST_REMOVE(&u_freelist ,currentfreeelement);
  801baa:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801bae:	75 17                	jne    801bc7 <malloc+0x44e>
  801bb0:	83 ec 04             	sub    $0x4,%esp
  801bb3:	68 1b 4c 80 00       	push   $0x804c1b
  801bb8:	68 8a 00 00 00       	push   $0x8a
  801bbd:	68 ac 4b 80 00       	push   $0x804bac
  801bc2:	e8 72 25 00 00       	call   804139 <_panic>
  801bc7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bca:	8b 40 08             	mov    0x8(%eax),%eax
  801bcd:	85 c0                	test   %eax,%eax
  801bcf:	74 11                	je     801be2 <malloc+0x469>
  801bd1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bd4:	8b 40 08             	mov    0x8(%eax),%eax
  801bd7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801bda:	8b 52 0c             	mov    0xc(%edx),%edx
  801bdd:	89 50 0c             	mov    %edx,0xc(%eax)
  801be0:	eb 0b                	jmp    801bed <malloc+0x474>
  801be2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801be5:	8b 40 0c             	mov    0xc(%eax),%eax
  801be8:	a3 64 16 8e 00       	mov    %eax,0x8e1664
  801bed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bf0:	8b 40 0c             	mov    0xc(%eax),%eax
  801bf3:	85 c0                	test   %eax,%eax
  801bf5:	74 11                	je     801c08 <malloc+0x48f>
  801bf7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bfa:	8b 40 0c             	mov    0xc(%eax),%eax
  801bfd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801c00:	8b 52 08             	mov    0x8(%edx),%edx
  801c03:	89 50 08             	mov    %edx,0x8(%eax)
  801c06:	eb 0b                	jmp    801c13 <malloc+0x49a>
  801c08:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c0b:	8b 40 08             	mov    0x8(%eax),%eax
  801c0e:	a3 60 16 8e 00       	mov    %eax,0x8e1660
  801c13:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c16:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  801c1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c20:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  801c27:	a1 6c 16 8e 00       	mov    0x8e166c,%eax
  801c2c:	48                   	dec    %eax
  801c2d:	a3 6c 16 8e 00       	mov    %eax,0x8e166c
				sys_allocate_user_mem(allocblock->startva ,size);
  801c32:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801c35:	8b 00                	mov    (%eax),%eax
  801c37:	83 ec 08             	sub    $0x8,%esp
  801c3a:	ff 75 08             	pushl  0x8(%ebp)
  801c3d:	50                   	push   %eax
  801c3e:	e8 da 18 00 00       	call   80351d <sys_allocate_user_mem>
  801c43:	83 c4 10             	add    $0x10,%esp
				release_uspinlock(&ulock);
  801c46:	83 ec 0c             	sub    $0xc,%esp
  801c49:	68 80 16 8e 00       	push   $0x8e1680
  801c4e:	e8 85 24 00 00       	call   8040d8 <release_uspinlock>
  801c53:	83 c4 10             	add    $0x10,%esp
				return (void*)allocblock->startva;
  801c56:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801c59:	8b 00                	mov    (%eax),%eax
  801c5b:	eb 18                	jmp    801c75 <malloc+0x4fc>
			}
			currentfreeelement = currentfreeelement->prev_next_info.le_next;
  801c5d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c60:	8b 40 08             	mov    0x8(%eax),%eax
  801c63:	89 45 f4             	mov    %eax,-0xc(%ebp)
				}
	}else{
		//custom fit
		struct UserHeapStruct* currentfreeelement = LIST_FIRST(&u_freelist);
		//worst fit
		while(currentfreeelement != NULL){
  801c66:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801c6a:	0f 85 bd fc ff ff    	jne    80192d <malloc+0x1b4>
				return (void*)allocblock->startva;
			}
			currentfreeelement = currentfreeelement->prev_next_info.le_next;
		}
	}
	 return NULL;
  801c70:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c75:	c9                   	leave  
  801c76:	c3                   	ret    

00801c77 <free>:

//=================================
// [2] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
  801c77:	55                   	push   %ebp
  801c78:	89 e5                	mov    %esp,%ebp
  801c7a:	83 ec 38             	sub    $0x38,%esp
	uint32  VA = ROUNDDOWN(((uint32 ) virtual_address), PAGE_SIZE);
  801c7d:	8b 45 08             	mov    0x8(%ebp),%eax
  801c80:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801c83:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801c86:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801c8b:	89 45 d8             	mov    %eax,-0x28(%ebp)


		uheap_init();
  801c8e:	e8 b2 f9 ff ff       	call   801645 <uheap_init>
		acquire_uspinlock(&ulock);
  801c93:	83 ec 0c             	sub    $0xc,%esp
  801c96:	68 80 16 8e 00       	push   $0x8e1680
  801c9b:	e8 e0 23 00 00       	call   804080 <acquire_uspinlock>
  801ca0:	83 c4 10             	add    $0x10,%esp
		if (VA < uheapPageAllocStart){
  801ca3:	a1 b0 fb 87 00       	mov    0x87fbb0,%eax
  801ca8:	39 45 d8             	cmp    %eax,-0x28(%ebp)
  801cab:	73 23                	jae    801cd0 <free+0x59>
			free_block(virtual_address);
  801cad:	83 ec 0c             	sub    $0xc,%esp
  801cb0:	ff 75 08             	pushl  0x8(%ebp)
  801cb3:	e8 89 1f 00 00       	call   803c41 <free_block>
  801cb8:	83 c4 10             	add    $0x10,%esp
			release_uspinlock(&ulock);
  801cbb:	83 ec 0c             	sub    $0xc,%esp
  801cbe:	68 80 16 8e 00       	push   $0x8e1680
  801cc3:	e8 10 24 00 00       	call   8040d8 <release_uspinlock>
  801cc8:	83 c4 10             	add    $0x10,%esp
			return;
  801ccb:	e9 35 07 00 00       	jmp    802405 <free+0x78e>
		}
		if (VA >= uheapPageAllocBreak){
  801cd0:	a1 08 fb 87 00       	mov    0x87fb08,%eax
  801cd5:	39 45 d8             	cmp    %eax,-0x28(%ebp)
  801cd8:	72 30                	jb     801d0a <free+0x93>
			cprintf("%d\n %d\n", VA, uheapPageAllocBreak);
  801cda:	a1 08 fb 87 00       	mov    0x87fb08,%eax
  801cdf:	83 ec 04             	sub    $0x4,%esp
  801ce2:	50                   	push   %eax
  801ce3:	ff 75 d8             	pushl  -0x28(%ebp)
  801ce6:	68 71 4c 80 00       	push   $0x804c71
  801ceb:	e8 70 ea ff ff       	call   800760 <cprintf>
  801cf0:	83 c4 10             	add    $0x10,%esp

			panic("freeing from restricted area");
  801cf3:	83 ec 04             	sub    $0x4,%esp
  801cf6:	68 79 4c 80 00       	push   $0x804c79
  801cfb:	68 a7 00 00 00       	push   $0xa7
  801d00:	68 ac 4b 80 00       	push   $0x804bac
  801d05:	e8 2f 24 00 00       	call   804139 <_panic>
			release_uspinlock(&ulock);
			return;
		}

		struct UserHeapStruct* newfree = (struct UserHeapStruct*) alloc_block(sizeof(struct UserHeapStruct));
  801d0a:	83 ec 0c             	sub    $0xc,%esp
  801d0d:	6a 10                	push   $0x10
  801d0f:	e8 91 1a 00 00       	call   8037a5 <alloc_block>
  801d14:	83 c4 10             	add    $0x10,%esp
  801d17:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		struct UserHeapStruct* MergedBlock  = ( struct UserHeapStruct*)alloc_block(sizeof(struct UserHeapStruct));
  801d1a:	83 ec 0c             	sub    $0xc,%esp
  801d1d:	6a 10                	push   $0x10
  801d1f:	e8 81 1a 00 00       	call   8037a5 <alloc_block>
  801d24:	83 c4 10             	add    $0x10,%esp
  801d27:	89 45 d0             	mov    %eax,-0x30(%ebp)

		struct UserHeapStruct* ToBefreed = LIST_FIRST(&u_allocatedlist);
  801d2a:	a1 70 16 8e 00       	mov    0x8e1670,%eax
  801d2f:	89 45 f4             	mov    %eax,-0xc(%ebp)
		bool foundVA = 0;
  801d32:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

		//find the allocated block
		while(ToBefreed !=NULL ){
  801d39:	eb 1c                	jmp    801d57 <free+0xe0>

			if (VA ==ToBefreed->startva ){
  801d3b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d3e:	8b 00                	mov    (%eax),%eax
  801d40:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  801d43:	75 09                	jne    801d4e <free+0xd7>
				foundVA = 1;
  801d45:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
				break;
  801d4c:	eb 0f                	jmp    801d5d <free+0xe6>
			}
				ToBefreed = ToBefreed->prev_next_info.le_next;
  801d4e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d51:	8b 40 08             	mov    0x8(%eax),%eax
  801d54:	89 45 f4             	mov    %eax,-0xc(%ebp)

		struct UserHeapStruct* ToBefreed = LIST_FIRST(&u_allocatedlist);
		bool foundVA = 0;

		//find the allocated block
		while(ToBefreed !=NULL ){
  801d57:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801d5b:	75 de                	jne    801d3b <free+0xc4>
			}
				ToBefreed = ToBefreed->prev_next_info.le_next;
		}


		if(!foundVA){
  801d5d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801d61:	75 17                	jne    801d7a <free+0x103>
				panic("INVALID ADDRESS!");
  801d63:	83 ec 04             	sub    $0x4,%esp
  801d66:	68 96 4c 80 00       	push   $0x804c96
  801d6b:	68 be 00 00 00       	push   $0xbe
  801d70:	68 ac 4b 80 00       	push   $0x804bac
  801d75:	e8 bf 23 00 00       	call   804139 <_panic>
				release_uspinlock(&ulock);
				return;
			}


		newfree->startva = ToBefreed->startva;
  801d7a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d7d:	8b 10                	mov    (%eax),%edx
  801d7f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801d82:	89 10                	mov    %edx,(%eax)
		newfree->size = ToBefreed->size;
  801d84:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d87:	8b 50 04             	mov    0x4(%eax),%edx
  801d8a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801d8d:	89 50 04             	mov    %edx,0x4(%eax)

		//remove allocated block from alloclist
		LIST_REMOVE(&u_allocatedlist, ToBefreed);
  801d90:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801d94:	75 17                	jne    801dad <free+0x136>
  801d96:	83 ec 04             	sub    $0x4,%esp
  801d99:	68 1b 4c 80 00       	push   $0x804c1b
  801d9e:	68 c8 00 00 00       	push   $0xc8
  801da3:	68 ac 4b 80 00       	push   $0x804bac
  801da8:	e8 8c 23 00 00       	call   804139 <_panic>
  801dad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801db0:	8b 40 08             	mov    0x8(%eax),%eax
  801db3:	85 c0                	test   %eax,%eax
  801db5:	74 11                	je     801dc8 <free+0x151>
  801db7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dba:	8b 40 08             	mov    0x8(%eax),%eax
  801dbd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801dc0:	8b 52 0c             	mov    0xc(%edx),%edx
  801dc3:	89 50 0c             	mov    %edx,0xc(%eax)
  801dc6:	eb 0b                	jmp    801dd3 <free+0x15c>
  801dc8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dcb:	8b 40 0c             	mov    0xc(%eax),%eax
  801dce:	a3 74 16 8e 00       	mov    %eax,0x8e1674
  801dd3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dd6:	8b 40 0c             	mov    0xc(%eax),%eax
  801dd9:	85 c0                	test   %eax,%eax
  801ddb:	74 11                	je     801dee <free+0x177>
  801ddd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801de0:	8b 40 0c             	mov    0xc(%eax),%eax
  801de3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801de6:	8b 52 08             	mov    0x8(%edx),%edx
  801de9:	89 50 08             	mov    %edx,0x8(%eax)
  801dec:	eb 0b                	jmp    801df9 <free+0x182>
  801dee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801df1:	8b 40 08             	mov    0x8(%eax),%eax
  801df4:	a3 70 16 8e 00       	mov    %eax,0x8e1670
  801df9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dfc:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  801e03:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e06:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  801e0d:	a1 7c 16 8e 00       	mov    0x8e167c,%eax
  801e12:	48                   	dec    %eax
  801e13:	a3 7c 16 8e 00       	mov    %eax,0x8e167c

		sys_free_user_mem(ToBefreed->startva, ToBefreed->size);
  801e18:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e1b:	8b 50 04             	mov    0x4(%eax),%edx
  801e1e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e21:	8b 00                	mov    (%eax),%eax
  801e23:	83 ec 08             	sub    $0x8,%esp
  801e26:	52                   	push   %edx
  801e27:	50                   	push   %eax
  801e28:	e8 d4 16 00 00       	call   803501 <sys_free_user_mem>
  801e2d:	83 c4 10             	add    $0x10,%esp




		if(LIST_SIZE(&u_freelist) == 0){
  801e30:	a1 6c 16 8e 00       	mov    0x8e166c,%eax
  801e35:	85 c0                	test   %eax,%eax
  801e37:	75 7a                	jne    801eb3 <free+0x23c>
			LIST_INSERT_HEAD(&u_freelist,newfree);
  801e39:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  801e3d:	75 17                	jne    801e56 <free+0x1df>
  801e3f:	83 ec 04             	sub    $0x4,%esp
  801e42:	68 a8 4c 80 00       	push   $0x804ca8
  801e47:	68 d0 00 00 00       	push   $0xd0
  801e4c:	68 ac 4b 80 00       	push   $0x804bac
  801e51:	e8 e3 22 00 00       	call   804139 <_panic>
  801e56:	8b 15 60 16 8e 00    	mov    0x8e1660,%edx
  801e5c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801e5f:	89 50 08             	mov    %edx,0x8(%eax)
  801e62:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801e65:	8b 40 08             	mov    0x8(%eax),%eax
  801e68:	85 c0                	test   %eax,%eax
  801e6a:	74 0d                	je     801e79 <free+0x202>
  801e6c:	a1 60 16 8e 00       	mov    0x8e1660,%eax
  801e71:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  801e74:	89 50 0c             	mov    %edx,0xc(%eax)
  801e77:	eb 08                	jmp    801e81 <free+0x20a>
  801e79:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801e7c:	a3 64 16 8e 00       	mov    %eax,0x8e1664
  801e81:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801e84:	a3 60 16 8e 00       	mov    %eax,0x8e1660
  801e89:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801e8c:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  801e93:	a1 6c 16 8e 00       	mov    0x8e166c,%eax
  801e98:	40                   	inc    %eax
  801e99:	a3 6c 16 8e 00       	mov    %eax,0x8e166c
			release_uspinlock(&ulock);
  801e9e:	83 ec 0c             	sub    $0xc,%esp
  801ea1:	68 80 16 8e 00       	push   $0x8e1680
  801ea6:	e8 2d 22 00 00       	call   8040d8 <release_uspinlock>
  801eab:	83 c4 10             	add    $0x10,%esp
			return;
  801eae:	e9 52 05 00 00       	jmp    802405 <free+0x78e>
		}


		struct UserHeapStruct* ToBeMerged = LIST_FIRST(&u_freelist);
  801eb3:	a1 60 16 8e 00       	mov    0x8e1660,%eax
  801eb8:	89 45 ec             	mov    %eax,-0x14(%ebp)
		// merge with prev if possible
		bool mergeprev = 0;
  801ebb:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		bool mergenext = 0;
  801ec2:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
		while(ToBeMerged != NULL){
  801ec9:	e9 d2 00 00 00       	jmp    801fa0 <free+0x329>
			if((ToBeMerged->startva +ToBeMerged->size) == newfree->startva){
  801ece:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801ed1:	8b 10                	mov    (%eax),%edx
  801ed3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801ed6:	8b 40 04             	mov    0x4(%eax),%eax
  801ed9:	01 c2                	add    %eax,%edx
  801edb:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801ede:	8b 00                	mov    (%eax),%eax
  801ee0:	39 c2                	cmp    %eax,%edx
  801ee2:	0f 85 af 00 00 00    	jne    801f97 <free+0x320>

				MergedBlock->startva = ToBeMerged->startva;
  801ee8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801eeb:	8b 10                	mov    (%eax),%edx
  801eed:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801ef0:	89 10                	mov    %edx,(%eax)
				MergedBlock->size = ToBeMerged->size + newfree->size;
  801ef2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801ef5:	8b 50 04             	mov    0x4(%eax),%edx
  801ef8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801efb:	8b 40 04             	mov    0x4(%eax),%eax
  801efe:	01 c2                	add    %eax,%edx
  801f00:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801f03:	89 50 04             	mov    %edx,0x4(%eax)
				LIST_REMOVE(&u_freelist, ToBeMerged);
  801f06:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801f0a:	75 17                	jne    801f23 <free+0x2ac>
  801f0c:	83 ec 04             	sub    $0x4,%esp
  801f0f:	68 1b 4c 80 00       	push   $0x804c1b
  801f14:	68 df 00 00 00       	push   $0xdf
  801f19:	68 ac 4b 80 00       	push   $0x804bac
  801f1e:	e8 16 22 00 00       	call   804139 <_panic>
  801f23:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f26:	8b 40 08             	mov    0x8(%eax),%eax
  801f29:	85 c0                	test   %eax,%eax
  801f2b:	74 11                	je     801f3e <free+0x2c7>
  801f2d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f30:	8b 40 08             	mov    0x8(%eax),%eax
  801f33:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801f36:	8b 52 0c             	mov    0xc(%edx),%edx
  801f39:	89 50 0c             	mov    %edx,0xc(%eax)
  801f3c:	eb 0b                	jmp    801f49 <free+0x2d2>
  801f3e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f41:	8b 40 0c             	mov    0xc(%eax),%eax
  801f44:	a3 64 16 8e 00       	mov    %eax,0x8e1664
  801f49:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f4c:	8b 40 0c             	mov    0xc(%eax),%eax
  801f4f:	85 c0                	test   %eax,%eax
  801f51:	74 11                	je     801f64 <free+0x2ed>
  801f53:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f56:	8b 40 0c             	mov    0xc(%eax),%eax
  801f59:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801f5c:	8b 52 08             	mov    0x8(%edx),%edx
  801f5f:	89 50 08             	mov    %edx,0x8(%eax)
  801f62:	eb 0b                	jmp    801f6f <free+0x2f8>
  801f64:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f67:	8b 40 08             	mov    0x8(%eax),%eax
  801f6a:	a3 60 16 8e 00       	mov    %eax,0x8e1660
  801f6f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f72:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  801f79:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f7c:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  801f83:	a1 6c 16 8e 00       	mov    0x8e166c,%eax
  801f88:	48                   	dec    %eax
  801f89:	a3 6c 16 8e 00       	mov    %eax,0x8e166c
				mergeprev = 1;
  801f8e:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
				break;
  801f95:	eb 13                	jmp    801faa <free+0x333>
			}
				ToBeMerged = ToBeMerged->prev_next_info.le_next;
  801f97:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f9a:	8b 40 08             	mov    0x8(%eax),%eax
  801f9d:	89 45 ec             	mov    %eax,-0x14(%ebp)

		struct UserHeapStruct* ToBeMerged = LIST_FIRST(&u_freelist);
		// merge with prev if possible
		bool mergeprev = 0;
		bool mergenext = 0;
		while(ToBeMerged != NULL){
  801fa0:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801fa4:	0f 85 24 ff ff ff    	jne    801ece <free+0x257>
//									uheapPageAllocBreak = newfree->startva;
//						}
//					}


		if ( newfree ->startva + newfree->size == uheapPageAllocBreak){
  801faa:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801fad:	8b 10                	mov    (%eax),%edx
  801faf:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801fb2:	8b 40 04             	mov    0x4(%eax),%eax
  801fb5:	01 c2                	add    %eax,%edx
  801fb7:	a1 08 fb 87 00       	mov    0x87fb08,%eax
  801fbc:	39 c2                	cmp    %eax,%edx
  801fbe:	75 44                	jne    802004 <free+0x38d>

			if(mergeprev){
  801fc0:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  801fc4:	74 1f                	je     801fe5 <free+0x36e>
				uheapPageAllocBreak = MergedBlock->startva;
  801fc6:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801fc9:	8b 00                	mov    (%eax),%eax
  801fcb:	a3 08 fb 87 00       	mov    %eax,0x87fb08
				release_uspinlock(&ulock);
  801fd0:	83 ec 0c             	sub    $0xc,%esp
  801fd3:	68 80 16 8e 00       	push   $0x8e1680
  801fd8:	e8 fb 20 00 00       	call   8040d8 <release_uspinlock>
  801fdd:	83 c4 10             	add    $0x10,%esp
				return;
  801fe0:	e9 20 04 00 00       	jmp    802405 <free+0x78e>

			}else{
				uheapPageAllocBreak = newfree->startva;
  801fe5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801fe8:	8b 00                	mov    (%eax),%eax
  801fea:	a3 08 fb 87 00       	mov    %eax,0x87fb08
				release_uspinlock(&ulock);
  801fef:	83 ec 0c             	sub    $0xc,%esp
  801ff2:	68 80 16 8e 00       	push   $0x8e1680
  801ff7:	e8 dc 20 00 00       	call   8040d8 <release_uspinlock>
  801ffc:	83 c4 10             	add    $0x10,%esp
				return;
  801fff:	e9 01 04 00 00       	jmp    802405 <free+0x78e>

		}


		//check if block is merged with prev ,and find possible merge with next
		ToBeMerged = LIST_FIRST(&u_freelist);
  802004:	a1 60 16 8e 00       	mov    0x8e1660,%eax
  802009:	89 45 ec             	mov    %eax,-0x14(%ebp)
		while(ToBeMerged != NULL){
  80200c:	e9 7d 01 00 00       	jmp    80218e <free+0x517>
			if ((newfree->startva + newfree->size) == ToBeMerged->startva ){
  802011:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802014:	8b 10                	mov    (%eax),%edx
  802016:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802019:	8b 40 04             	mov    0x4(%eax),%eax
  80201c:	01 c2                	add    %eax,%edx
  80201e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802021:	8b 00                	mov    (%eax),%eax
  802023:	39 c2                	cmp    %eax,%edx
  802025:	0f 85 5a 01 00 00    	jne    802185 <free+0x50e>
				if (mergeprev){
  80202b:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80202f:	0f 84 a1 00 00 00    	je     8020d6 <free+0x45f>
					MergedBlock->size += ToBeMerged->size;
  802035:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802038:	8b 50 04             	mov    0x4(%eax),%edx
  80203b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80203e:	8b 40 04             	mov    0x4(%eax),%eax
  802041:	01 c2                	add    %eax,%edx
  802043:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802046:	89 50 04             	mov    %edx,0x4(%eax)
					LIST_REMOVE(&u_freelist, ToBeMerged);
  802049:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80204d:	75 17                	jne    802066 <free+0x3ef>
  80204f:	83 ec 04             	sub    $0x4,%esp
  802052:	68 1b 4c 80 00       	push   $0x804c1b
  802057:	68 0a 01 00 00       	push   $0x10a
  80205c:	68 ac 4b 80 00       	push   $0x804bac
  802061:	e8 d3 20 00 00       	call   804139 <_panic>
  802066:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802069:	8b 40 08             	mov    0x8(%eax),%eax
  80206c:	85 c0                	test   %eax,%eax
  80206e:	74 11                	je     802081 <free+0x40a>
  802070:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802073:	8b 40 08             	mov    0x8(%eax),%eax
  802076:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802079:	8b 52 0c             	mov    0xc(%edx),%edx
  80207c:	89 50 0c             	mov    %edx,0xc(%eax)
  80207f:	eb 0b                	jmp    80208c <free+0x415>
  802081:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802084:	8b 40 0c             	mov    0xc(%eax),%eax
  802087:	a3 64 16 8e 00       	mov    %eax,0x8e1664
  80208c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80208f:	8b 40 0c             	mov    0xc(%eax),%eax
  802092:	85 c0                	test   %eax,%eax
  802094:	74 11                	je     8020a7 <free+0x430>
  802096:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802099:	8b 40 0c             	mov    0xc(%eax),%eax
  80209c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80209f:	8b 52 08             	mov    0x8(%edx),%edx
  8020a2:	89 50 08             	mov    %edx,0x8(%eax)
  8020a5:	eb 0b                	jmp    8020b2 <free+0x43b>
  8020a7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8020aa:	8b 40 08             	mov    0x8(%eax),%eax
  8020ad:	a3 60 16 8e 00       	mov    %eax,0x8e1660
  8020b2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8020b5:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  8020bc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8020bf:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  8020c6:	a1 6c 16 8e 00       	mov    0x8e166c,%eax
  8020cb:	48                   	dec    %eax
  8020cc:	a3 6c 16 8e 00       	mov    %eax,0x8e166c
					break;
  8020d1:	e9 c2 00 00 00       	jmp    802198 <free+0x521>
		//if not merged find possible merge with next
				}else{
					MergedBlock->startva = newfree->startva;
  8020d6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8020d9:	8b 10                	mov    (%eax),%edx
  8020db:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8020de:	89 10                	mov    %edx,(%eax)
					MergedBlock->size  = newfree->size + ToBeMerged->size;
  8020e0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8020e3:	8b 50 04             	mov    0x4(%eax),%edx
  8020e6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8020e9:	8b 40 04             	mov    0x4(%eax),%eax
  8020ec:	01 c2                	add    %eax,%edx
  8020ee:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8020f1:	89 50 04             	mov    %edx,0x4(%eax)
					LIST_REMOVE(&u_freelist, ToBeMerged);
  8020f4:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8020f8:	75 17                	jne    802111 <free+0x49a>
  8020fa:	83 ec 04             	sub    $0x4,%esp
  8020fd:	68 1b 4c 80 00       	push   $0x804c1b
  802102:	68 10 01 00 00       	push   $0x110
  802107:	68 ac 4b 80 00       	push   $0x804bac
  80210c:	e8 28 20 00 00       	call   804139 <_panic>
  802111:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802114:	8b 40 08             	mov    0x8(%eax),%eax
  802117:	85 c0                	test   %eax,%eax
  802119:	74 11                	je     80212c <free+0x4b5>
  80211b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80211e:	8b 40 08             	mov    0x8(%eax),%eax
  802121:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802124:	8b 52 0c             	mov    0xc(%edx),%edx
  802127:	89 50 0c             	mov    %edx,0xc(%eax)
  80212a:	eb 0b                	jmp    802137 <free+0x4c0>
  80212c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80212f:	8b 40 0c             	mov    0xc(%eax),%eax
  802132:	a3 64 16 8e 00       	mov    %eax,0x8e1664
  802137:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80213a:	8b 40 0c             	mov    0xc(%eax),%eax
  80213d:	85 c0                	test   %eax,%eax
  80213f:	74 11                	je     802152 <free+0x4db>
  802141:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802144:	8b 40 0c             	mov    0xc(%eax),%eax
  802147:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80214a:	8b 52 08             	mov    0x8(%edx),%edx
  80214d:	89 50 08             	mov    %edx,0x8(%eax)
  802150:	eb 0b                	jmp    80215d <free+0x4e6>
  802152:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802155:	8b 40 08             	mov    0x8(%eax),%eax
  802158:	a3 60 16 8e 00       	mov    %eax,0x8e1660
  80215d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802160:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802167:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80216a:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  802171:	a1 6c 16 8e 00       	mov    0x8e166c,%eax
  802176:	48                   	dec    %eax
  802177:	a3 6c 16 8e 00       	mov    %eax,0x8e166c
					mergenext = 1;
  80217c:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
					break;
  802183:	eb 13                	jmp    802198 <free+0x521>
				}
			}
			ToBeMerged = ToBeMerged->prev_next_info.le_next;
  802185:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802188:	8b 40 08             	mov    0x8(%eax),%eax
  80218b:	89 45 ec             	mov    %eax,-0x14(%ebp)
		}


		//check if block is merged with prev ,and find possible merge with next
		ToBeMerged = LIST_FIRST(&u_freelist);
		while(ToBeMerged != NULL){
  80218e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802192:	0f 85 79 fe ff ff    	jne    802011 <free+0x39a>




			// insertion
			struct UserHeapStruct* currentfree = LIST_FIRST(&u_freelist);
  802198:	a1 60 16 8e 00       	mov    0x8e1660,%eax
  80219d:	89 45 e0             	mov    %eax,-0x20(%ebp)

			if(mergeprev || mergenext){
  8021a0:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8021a4:	0f 85 ad 00 00 00    	jne    802257 <free+0x5e0>
  8021aa:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8021ae:	0f 84 c3 01 00 00    	je     802377 <free+0x700>
				while(currentfree != NULL){
  8021b4:	e9 9e 00 00 00       	jmp    802257 <free+0x5e0>
					if(MergedBlock->size < currentfree->size){
  8021b9:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8021bc:	8b 50 04             	mov    0x4(%eax),%edx
  8021bf:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8021c2:	8b 40 04             	mov    0x4(%eax),%eax
  8021c5:	39 c2                	cmp    %eax,%edx
  8021c7:	0f 83 81 00 00 00    	jae    80224e <free+0x5d7>

							LIST_INSERT_BEFORE(&u_freelist,currentfree,MergedBlock);
  8021cd:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8021d1:	74 06                	je     8021d9 <free+0x562>
  8021d3:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  8021d7:	75 17                	jne    8021f0 <free+0x579>
  8021d9:	83 ec 04             	sub    $0x4,%esp
  8021dc:	68 3c 4c 80 00       	push   $0x804c3c
  8021e1:	68 23 01 00 00       	push   $0x123
  8021e6:	68 ac 4b 80 00       	push   $0x804bac
  8021eb:	e8 49 1f 00 00       	call   804139 <_panic>
  8021f0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8021f3:	8b 50 0c             	mov    0xc(%eax),%edx
  8021f6:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8021f9:	89 50 0c             	mov    %edx,0xc(%eax)
  8021fc:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8021ff:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802202:	89 50 08             	mov    %edx,0x8(%eax)
  802205:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802208:	8b 40 0c             	mov    0xc(%eax),%eax
  80220b:	85 c0                	test   %eax,%eax
  80220d:	74 0e                	je     80221d <free+0x5a6>
  80220f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802212:	8b 40 0c             	mov    0xc(%eax),%eax
  802215:	8b 55 d0             	mov    -0x30(%ebp),%edx
  802218:	89 50 08             	mov    %edx,0x8(%eax)
  80221b:	eb 08                	jmp    802225 <free+0x5ae>
  80221d:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802220:	a3 60 16 8e 00       	mov    %eax,0x8e1660
  802225:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802228:	8b 55 d0             	mov    -0x30(%ebp),%edx
  80222b:	89 50 0c             	mov    %edx,0xc(%eax)
  80222e:	a1 6c 16 8e 00       	mov    0x8e166c,%eax
  802233:	40                   	inc    %eax
  802234:	a3 6c 16 8e 00       	mov    %eax,0x8e166c
							release_uspinlock(&ulock);
  802239:	83 ec 0c             	sub    $0xc,%esp
  80223c:	68 80 16 8e 00       	push   $0x8e1680
  802241:	e8 92 1e 00 00       	call   8040d8 <release_uspinlock>
  802246:	83 c4 10             	add    $0x10,%esp
							return;
  802249:	e9 b7 01 00 00       	jmp    802405 <free+0x78e>
					}
							currentfree = currentfree->prev_next_info.le_next;
  80224e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802251:	8b 40 08             	mov    0x8(%eax),%eax
  802254:	89 45 e0             	mov    %eax,-0x20(%ebp)

			// insertion
			struct UserHeapStruct* currentfree = LIST_FIRST(&u_freelist);

			if(mergeprev || mergenext){
				while(currentfree != NULL){
  802257:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80225b:	0f 85 58 ff ff ff    	jne    8021b9 <free+0x542>
							release_uspinlock(&ulock);
							return;
					}
							currentfree = currentfree->prev_next_info.le_next;
				}
				free_block(newfree);
  802261:	83 ec 0c             	sub    $0xc,%esp
  802264:	ff 75 d4             	pushl  -0x2c(%ebp)
  802267:	e8 d5 19 00 00       	call   803c41 <free_block>
  80226c:	83 c4 10             	add    $0x10,%esp
				LIST_INSERT_TAIL(&u_freelist,MergedBlock);
  80226f:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  802273:	75 17                	jne    80228c <free+0x615>
  802275:	83 ec 04             	sub    $0x4,%esp
  802278:	68 f8 4b 80 00       	push   $0x804bf8
  80227d:	68 2a 01 00 00       	push   $0x12a
  802282:	68 ac 4b 80 00       	push   $0x804bac
  802287:	e8 ad 1e 00 00       	call   804139 <_panic>
  80228c:	8b 15 64 16 8e 00    	mov    0x8e1664,%edx
  802292:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802295:	89 50 0c             	mov    %edx,0xc(%eax)
  802298:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80229b:	8b 40 0c             	mov    0xc(%eax),%eax
  80229e:	85 c0                	test   %eax,%eax
  8022a0:	74 0d                	je     8022af <free+0x638>
  8022a2:	a1 64 16 8e 00       	mov    0x8e1664,%eax
  8022a7:	8b 55 d0             	mov    -0x30(%ebp),%edx
  8022aa:	89 50 08             	mov    %edx,0x8(%eax)
  8022ad:	eb 08                	jmp    8022b7 <free+0x640>
  8022af:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8022b2:	a3 60 16 8e 00       	mov    %eax,0x8e1660
  8022b7:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8022ba:	a3 64 16 8e 00       	mov    %eax,0x8e1664
  8022bf:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8022c2:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  8022c9:	a1 6c 16 8e 00       	mov    0x8e166c,%eax
  8022ce:	40                   	inc    %eax
  8022cf:	a3 6c 16 8e 00       	mov    %eax,0x8e166c
  8022d4:	e9 1b 01 00 00       	jmp    8023f4 <free+0x77d>

			}else{
				while(currentfree != NULL){
					if(newfree->size < currentfree->size){
  8022d9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8022dc:	8b 50 04             	mov    0x4(%eax),%edx
  8022df:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8022e2:	8b 40 04             	mov    0x4(%eax),%eax
  8022e5:	39 c2                	cmp    %eax,%edx
  8022e7:	0f 83 81 00 00 00    	jae    80236e <free+0x6f7>

							LIST_INSERT_BEFORE(&u_freelist,currentfree,newfree);
  8022ed:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8022f1:	74 06                	je     8022f9 <free+0x682>
  8022f3:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8022f7:	75 17                	jne    802310 <free+0x699>
  8022f9:	83 ec 04             	sub    $0x4,%esp
  8022fc:	68 3c 4c 80 00       	push   $0x804c3c
  802301:	68 30 01 00 00       	push   $0x130
  802306:	68 ac 4b 80 00       	push   $0x804bac
  80230b:	e8 29 1e 00 00       	call   804139 <_panic>
  802310:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802313:	8b 50 0c             	mov    0xc(%eax),%edx
  802316:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802319:	89 50 0c             	mov    %edx,0xc(%eax)
  80231c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80231f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802322:	89 50 08             	mov    %edx,0x8(%eax)
  802325:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802328:	8b 40 0c             	mov    0xc(%eax),%eax
  80232b:	85 c0                	test   %eax,%eax
  80232d:	74 0e                	je     80233d <free+0x6c6>
  80232f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802332:	8b 40 0c             	mov    0xc(%eax),%eax
  802335:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802338:	89 50 08             	mov    %edx,0x8(%eax)
  80233b:	eb 08                	jmp    802345 <free+0x6ce>
  80233d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802340:	a3 60 16 8e 00       	mov    %eax,0x8e1660
  802345:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802348:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80234b:	89 50 0c             	mov    %edx,0xc(%eax)
  80234e:	a1 6c 16 8e 00       	mov    0x8e166c,%eax
  802353:	40                   	inc    %eax
  802354:	a3 6c 16 8e 00       	mov    %eax,0x8e166c
							release_uspinlock(&ulock);
  802359:	83 ec 0c             	sub    $0xc,%esp
  80235c:	68 80 16 8e 00       	push   $0x8e1680
  802361:	e8 72 1d 00 00       	call   8040d8 <release_uspinlock>
  802366:	83 c4 10             	add    $0x10,%esp
							return;
  802369:	e9 97 00 00 00       	jmp    802405 <free+0x78e>
					}
							currentfree = currentfree->prev_next_info.le_next;
  80236e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802371:	8b 40 08             	mov    0x8(%eax),%eax
  802374:	89 45 e0             	mov    %eax,-0x20(%ebp)
				}
				free_block(newfree);
				LIST_INSERT_TAIL(&u_freelist,MergedBlock);

			}else{
				while(currentfree != NULL){
  802377:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80237b:	0f 85 58 ff ff ff    	jne    8022d9 <free+0x662>
							release_uspinlock(&ulock);
							return;
					}
							currentfree = currentfree->prev_next_info.le_next;
				}
				free_block(MergedBlock);
  802381:	83 ec 0c             	sub    $0xc,%esp
  802384:	ff 75 d0             	pushl  -0x30(%ebp)
  802387:	e8 b5 18 00 00       	call   803c41 <free_block>
  80238c:	83 c4 10             	add    $0x10,%esp
				LIST_INSERT_TAIL(&u_freelist,newfree);
  80238f:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  802393:	75 17                	jne    8023ac <free+0x735>
  802395:	83 ec 04             	sub    $0x4,%esp
  802398:	68 f8 4b 80 00       	push   $0x804bf8
  80239d:	68 37 01 00 00       	push   $0x137
  8023a2:	68 ac 4b 80 00       	push   $0x804bac
  8023a7:	e8 8d 1d 00 00       	call   804139 <_panic>
  8023ac:	8b 15 64 16 8e 00    	mov    0x8e1664,%edx
  8023b2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8023b5:	89 50 0c             	mov    %edx,0xc(%eax)
  8023b8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8023bb:	8b 40 0c             	mov    0xc(%eax),%eax
  8023be:	85 c0                	test   %eax,%eax
  8023c0:	74 0d                	je     8023cf <free+0x758>
  8023c2:	a1 64 16 8e 00       	mov    0x8e1664,%eax
  8023c7:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8023ca:	89 50 08             	mov    %edx,0x8(%eax)
  8023cd:	eb 08                	jmp    8023d7 <free+0x760>
  8023cf:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8023d2:	a3 60 16 8e 00       	mov    %eax,0x8e1660
  8023d7:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8023da:	a3 64 16 8e 00       	mov    %eax,0x8e1664
  8023df:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8023e2:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  8023e9:	a1 6c 16 8e 00       	mov    0x8e166c,%eax
  8023ee:	40                   	inc    %eax
  8023ef:	a3 6c 16 8e 00       	mov    %eax,0x8e166c
			}
		release_uspinlock(&ulock);
  8023f4:	83 ec 0c             	sub    $0xc,%esp
  8023f7:	68 80 16 8e 00       	push   $0x8e1680
  8023fc:	e8 d7 1c 00 00       	call   8040d8 <release_uspinlock>
  802401:	83 c4 10             	add    $0x10,%esp
		return;
  802404:	90                   	nop
}
  802405:	c9                   	leave  
  802406:	c3                   	ret    

00802407 <smalloc>:

//=================================
// [3] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  802407:	55                   	push   %ebp
  802408:	89 e5                	mov    %esp,%ebp
  80240a:	83 ec 48             	sub    $0x48,%esp
  80240d:	8b 45 10             	mov    0x10(%ebp),%eax
  802410:	88 45 c4             	mov    %al,-0x3c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  802413:	e8 2d f2 ff ff       	call   801645 <uheap_init>
	if (size == 0) return NULL;
  802418:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80241c:	75 0a                	jne    802428 <smalloc+0x21>
  80241e:	b8 00 00 00 00       	mov    $0x0,%eax
  802423:	e9 84 05 00 00       	jmp    8029ac <smalloc+0x5a5>
	//==============================================================
	acquire_uspinlock(&ulock);
  802428:	83 ec 0c             	sub    $0xc,%esp
  80242b:	68 80 16 8e 00       	push   $0x8e1680
  802430:	e8 4b 1c 00 00       	call   804080 <acquire_uspinlock>
  802435:	83 c4 10             	add    $0x10,%esp

	struct UserHeapStruct* allocblock = (struct UserHeapStruct*) alloc_block(sizeof(struct UserHeapStruct));
  802438:	83 ec 0c             	sub    $0xc,%esp
  80243b:	6a 10                	push   $0x10
  80243d:	e8 63 13 00 00       	call   8037a5 <alloc_block>
  802442:	83 c4 10             	add    $0x10,%esp
  802445:	89 45 ec             	mov    %eax,-0x14(%ebp)
	if (allocblock == NULL){
  802448:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80244c:	75 0a                	jne    802458 <smalloc+0x51>
				return NULL;
  80244e:	b8 00 00 00 00       	mov    $0x0,%eax
  802453:	e9 54 05 00 00       	jmp    8029ac <smalloc+0x5a5>
	}
		size = ROUNDUP(size,PAGE_SIZE);
  802458:	c7 45 e8 00 10 00 00 	movl   $0x1000,-0x18(%ebp)
  80245f:	8b 55 0c             	mov    0xc(%ebp),%edx
  802462:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802465:	01 d0                	add    %edx,%eax
  802467:	48                   	dec    %eax
  802468:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80246b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80246e:	ba 00 00 00 00       	mov    $0x0,%edx
  802473:	f7 75 e8             	divl   -0x18(%ebp)
  802476:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802479:	29 d0                	sub    %edx,%eax
  80247b:	89 45 0c             	mov    %eax,0xc(%ebp)
		struct UserHeapStruct* lastfreeelement = LIST_LAST(&u_freelist);
  80247e:	a1 64 16 8e 00       	mov    0x8e1664,%eax
  802483:	89 45 e0             	mov    %eax,-0x20(%ebp)

		if(LIST_SIZE(&u_freelist)==0 || size>lastfreeelement->size){
  802486:	a1 6c 16 8e 00       	mov    0x8e166c,%eax
  80248b:	85 c0                	test   %eax,%eax
  80248d:	74 0f                	je     80249e <smalloc+0x97>
  80248f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802492:	8b 40 04             	mov    0x4(%eax),%eax
  802495:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802498:	0f 83 25 01 00 00    	jae    8025c3 <smalloc+0x1bc>
				if(uheapPageAllocBreak <= USER_HEAP_MAX - size){
  80249e:	b8 00 00 00 a0       	mov    $0xa0000000,%eax
  8024a3:	2b 45 0c             	sub    0xc(%ebp),%eax
  8024a6:	89 c2                	mov    %eax,%edx
  8024a8:	a1 08 fb 87 00       	mov    0x87fb08,%eax
  8024ad:	39 c2                	cmp    %eax,%edx
  8024af:	0f 82 f4 00 00 00    	jb     8025a9 <smalloc+0x1a2>
						uint32 requestedblockva = uheapPageAllocBreak;
  8024b5:	a1 08 fb 87 00       	mov    0x87fb08,%eax
  8024ba:	89 45 d4             	mov    %eax,-0x2c(%ebp)
						uheapPageAllocBreak+=size;
  8024bd:	8b 15 08 fb 87 00    	mov    0x87fb08,%edx
  8024c3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8024c6:	01 d0                	add    %edx,%eax
  8024c8:	a3 08 fb 87 00       	mov    %eax,0x87fb08
						allocblock->startva = requestedblockva;
  8024cd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8024d0:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8024d3:	89 10                	mov    %edx,(%eax)
						allocblock->size = size;
  8024d5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8024d8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8024db:	89 50 04             	mov    %edx,0x4(%eax)

						LIST_INSERT_TAIL(&u_allocatedlist, allocblock);
  8024de:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8024e2:	75 17                	jne    8024fb <smalloc+0xf4>
  8024e4:	83 ec 04             	sub    $0x4,%esp
  8024e7:	68 f8 4b 80 00       	push   $0x804bf8
  8024ec:	68 57 01 00 00       	push   $0x157
  8024f1:	68 ac 4b 80 00       	push   $0x804bac
  8024f6:	e8 3e 1c 00 00       	call   804139 <_panic>
  8024fb:	8b 15 74 16 8e 00    	mov    0x8e1674,%edx
  802501:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802504:	89 50 0c             	mov    %edx,0xc(%eax)
  802507:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80250a:	8b 40 0c             	mov    0xc(%eax),%eax
  80250d:	85 c0                	test   %eax,%eax
  80250f:	74 0d                	je     80251e <smalloc+0x117>
  802511:	a1 74 16 8e 00       	mov    0x8e1674,%eax
  802516:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802519:	89 50 08             	mov    %edx,0x8(%eax)
  80251c:	eb 08                	jmp    802526 <smalloc+0x11f>
  80251e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802521:	a3 70 16 8e 00       	mov    %eax,0x8e1670
  802526:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802529:	a3 74 16 8e 00       	mov    %eax,0x8e1674
  80252e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802531:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802538:	a1 7c 16 8e 00       	mov    0x8e167c,%eax
  80253d:	40                   	inc    %eax
  80253e:	a3 7c 16 8e 00       	mov    %eax,0x8e167c


						int result = sys_create_shared_object(sharedVarName ,size ,isWritable ,(void*)allocblock->startva);
  802543:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802546:	8b 00                	mov    (%eax),%eax
  802548:	89 c2                	mov    %eax,%edx
  80254a:	0f b6 45 c4          	movzbl -0x3c(%ebp),%eax
  80254e:	52                   	push   %edx
  80254f:	50                   	push   %eax
  802550:	ff 75 0c             	pushl  0xc(%ebp)
  802553:	ff 75 08             	pushl  0x8(%ebp)
  802556:	e8 48 0c 00 00       	call   8031a3 <sys_create_shared_object>
  80255b:	83 c4 10             	add    $0x10,%esp
  80255e:	89 45 d0             	mov    %eax,-0x30(%ebp)

						if(result <0){
  802561:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  802565:	79 28                	jns    80258f <smalloc+0x188>
							free_block(allocblock);
  802567:	83 ec 0c             	sub    $0xc,%esp
  80256a:	ff 75 ec             	pushl  -0x14(%ebp)
  80256d:	e8 cf 16 00 00       	call   803c41 <free_block>
  802572:	83 c4 10             	add    $0x10,%esp
							release_uspinlock(&ulock);
  802575:	83 ec 0c             	sub    $0xc,%esp
  802578:	68 80 16 8e 00       	push   $0x8e1680
  80257d:	e8 56 1b 00 00       	call   8040d8 <release_uspinlock>
  802582:	83 c4 10             	add    $0x10,%esp
							return NULL;
  802585:	b8 00 00 00 00       	mov    $0x0,%eax
  80258a:	e9 1d 04 00 00       	jmp    8029ac <smalloc+0x5a5>
						}
						release_uspinlock(&ulock);
  80258f:	83 ec 0c             	sub    $0xc,%esp
  802592:	68 80 16 8e 00       	push   $0x8e1680
  802597:	e8 3c 1b 00 00       	call   8040d8 <release_uspinlock>
  80259c:	83 c4 10             	add    $0x10,%esp
						return (void*)allocblock -> startva;
  80259f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025a2:	8b 00                	mov    (%eax),%eax
  8025a4:	e9 03 04 00 00       	jmp    8029ac <smalloc+0x5a5>
				}else{
						release_uspinlock(&ulock);
  8025a9:	83 ec 0c             	sub    $0xc,%esp
  8025ac:	68 80 16 8e 00       	push   $0x8e1680
  8025b1:	e8 22 1b 00 00       	call   8040d8 <release_uspinlock>
  8025b6:	83 c4 10             	add    $0x10,%esp
						return NULL;
  8025b9:	b8 00 00 00 00       	mov    $0x0,%eax
  8025be:	e9 e9 03 00 00       	jmp    8029ac <smalloc+0x5a5>
					 }
		}else{
			//custom fit
			struct UserHeapStruct* currentfreeelement = LIST_FIRST(&u_freelist);
  8025c3:	a1 60 16 8e 00       	mov    0x8e1660,%eax
  8025c8:	89 45 f4             	mov    %eax,-0xc(%ebp)
			//worst fit
			while(currentfreeelement != NULL){
  8025cb:	e9 af 03 00 00       	jmp    80297f <smalloc+0x578>
				if(size<currentfreeelement->size){
  8025d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025d3:	8b 40 04             	mov    0x4(%eax),%eax
  8025d6:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8025d9:	0f 86 28 02 00 00    	jbe    802807 <smalloc+0x400>
					allocblock->startva = lastfreeelement->startva;
  8025df:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8025e2:	8b 10                	mov    (%eax),%edx
  8025e4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025e7:	89 10                	mov    %edx,(%eax)
	                allocblock->size = size;
  8025e9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025ec:	8b 55 0c             	mov    0xc(%ebp),%edx
  8025ef:	89 50 04             	mov    %edx,0x4(%eax)
	                LIST_INSERT_TAIL(&u_allocatedlist,allocblock);
  8025f2:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8025f6:	75 17                	jne    80260f <smalloc+0x208>
  8025f8:	83 ec 04             	sub    $0x4,%esp
  8025fb:	68 f8 4b 80 00       	push   $0x804bf8
  802600:	68 6f 01 00 00       	push   $0x16f
  802605:	68 ac 4b 80 00       	push   $0x804bac
  80260a:	e8 2a 1b 00 00       	call   804139 <_panic>
  80260f:	8b 15 74 16 8e 00    	mov    0x8e1674,%edx
  802615:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802618:	89 50 0c             	mov    %edx,0xc(%eax)
  80261b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80261e:	8b 40 0c             	mov    0xc(%eax),%eax
  802621:	85 c0                	test   %eax,%eax
  802623:	74 0d                	je     802632 <smalloc+0x22b>
  802625:	a1 74 16 8e 00       	mov    0x8e1674,%eax
  80262a:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80262d:	89 50 08             	mov    %edx,0x8(%eax)
  802630:	eb 08                	jmp    80263a <smalloc+0x233>
  802632:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802635:	a3 70 16 8e 00       	mov    %eax,0x8e1670
  80263a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80263d:	a3 74 16 8e 00       	mov    %eax,0x8e1674
  802642:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802645:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  80264c:	a1 7c 16 8e 00       	mov    0x8e167c,%eax
  802651:	40                   	inc    %eax
  802652:	a3 7c 16 8e 00       	mov    %eax,0x8e167c
	                lastfreeelement->startva += size;
  802657:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80265a:	8b 10                	mov    (%eax),%edx
  80265c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80265f:	01 c2                	add    %eax,%edx
  802661:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802664:	89 10                	mov    %edx,(%eax)
	                lastfreeelement->size -= size;
  802666:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802669:	8b 40 04             	mov    0x4(%eax),%eax
  80266c:	2b 45 0c             	sub    0xc(%ebp),%eax
  80266f:	89 c2                	mov    %eax,%edx
  802671:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802674:	89 50 04             	mov    %edx,0x4(%eax)
	                struct UserHeapStruct* currentfree2 = LIST_FIRST(&u_freelist);
  802677:	a1 60 16 8e 00       	mov    0x8e1660,%eax
  80267c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	                //check order of last element

	                while (currentfree2 != NULL){
  80267f:	e9 13 01 00 00       	jmp    802797 <smalloc+0x390>
	                	if(lastfreeelement->size <currentfree2->size){
  802684:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802687:	8b 50 04             	mov    0x4(%eax),%edx
  80268a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80268d:	8b 40 04             	mov    0x4(%eax),%eax
  802690:	39 c2                	cmp    %eax,%edx
  802692:	0f 83 f6 00 00 00    	jae    80278e <smalloc+0x387>
	                		LIST_REMOVE(&u_freelist ,lastfreeelement);
  802698:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80269c:	75 17                	jne    8026b5 <smalloc+0x2ae>
  80269e:	83 ec 04             	sub    $0x4,%esp
  8026a1:	68 1b 4c 80 00       	push   $0x804c1b
  8026a6:	68 77 01 00 00       	push   $0x177
  8026ab:	68 ac 4b 80 00       	push   $0x804bac
  8026b0:	e8 84 1a 00 00       	call   804139 <_panic>
  8026b5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8026b8:	8b 40 08             	mov    0x8(%eax),%eax
  8026bb:	85 c0                	test   %eax,%eax
  8026bd:	74 11                	je     8026d0 <smalloc+0x2c9>
  8026bf:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8026c2:	8b 40 08             	mov    0x8(%eax),%eax
  8026c5:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8026c8:	8b 52 0c             	mov    0xc(%edx),%edx
  8026cb:	89 50 0c             	mov    %edx,0xc(%eax)
  8026ce:	eb 0b                	jmp    8026db <smalloc+0x2d4>
  8026d0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8026d3:	8b 40 0c             	mov    0xc(%eax),%eax
  8026d6:	a3 64 16 8e 00       	mov    %eax,0x8e1664
  8026db:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8026de:	8b 40 0c             	mov    0xc(%eax),%eax
  8026e1:	85 c0                	test   %eax,%eax
  8026e3:	74 11                	je     8026f6 <smalloc+0x2ef>
  8026e5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8026e8:	8b 40 0c             	mov    0xc(%eax),%eax
  8026eb:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8026ee:	8b 52 08             	mov    0x8(%edx),%edx
  8026f1:	89 50 08             	mov    %edx,0x8(%eax)
  8026f4:	eb 0b                	jmp    802701 <smalloc+0x2fa>
  8026f6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8026f9:	8b 40 08             	mov    0x8(%eax),%eax
  8026fc:	a3 60 16 8e 00       	mov    %eax,0x8e1660
  802701:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802704:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  80270b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80270e:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  802715:	a1 6c 16 8e 00       	mov    0x8e166c,%eax
  80271a:	48                   	dec    %eax
  80271b:	a3 6c 16 8e 00       	mov    %eax,0x8e166c
	                		LIST_INSERT_BEFORE(&u_freelist ,currentfree2 ,lastfreeelement);
  802720:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802724:	74 06                	je     80272c <smalloc+0x325>
  802726:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80272a:	75 17                	jne    802743 <smalloc+0x33c>
  80272c:	83 ec 04             	sub    $0x4,%esp
  80272f:	68 3c 4c 80 00       	push   $0x804c3c
  802734:	68 78 01 00 00       	push   $0x178
  802739:	68 ac 4b 80 00       	push   $0x804bac
  80273e:	e8 f6 19 00 00       	call   804139 <_panic>
  802743:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802746:	8b 50 0c             	mov    0xc(%eax),%edx
  802749:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80274c:	89 50 0c             	mov    %edx,0xc(%eax)
  80274f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802752:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802755:	89 50 08             	mov    %edx,0x8(%eax)
  802758:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80275b:	8b 40 0c             	mov    0xc(%eax),%eax
  80275e:	85 c0                	test   %eax,%eax
  802760:	74 0e                	je     802770 <smalloc+0x369>
  802762:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802765:	8b 40 0c             	mov    0xc(%eax),%eax
  802768:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80276b:	89 50 08             	mov    %edx,0x8(%eax)
  80276e:	eb 08                	jmp    802778 <smalloc+0x371>
  802770:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802773:	a3 60 16 8e 00       	mov    %eax,0x8e1660
  802778:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80277b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80277e:	89 50 0c             	mov    %edx,0xc(%eax)
  802781:	a1 6c 16 8e 00       	mov    0x8e166c,%eax
  802786:	40                   	inc    %eax
  802787:	a3 6c 16 8e 00       	mov    %eax,0x8e166c
	                		break;
  80278c:	eb 13                	jmp    8027a1 <smalloc+0x39a>
	                	}
	                	currentfree2 = currentfree2->prev_next_info.le_next;
  80278e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802791:	8b 40 08             	mov    0x8(%eax),%eax
  802794:	89 45 f0             	mov    %eax,-0x10(%ebp)
	                lastfreeelement->startva += size;
	                lastfreeelement->size -= size;
	                struct UserHeapStruct* currentfree2 = LIST_FIRST(&u_freelist);
	                //check order of last element

	                while (currentfree2 != NULL){
  802797:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80279b:	0f 85 e3 fe ff ff    	jne    802684 <smalloc+0x27d>
	                	}
	                	currentfree2 = currentfree2->prev_next_info.le_next;
	                }


	                int result = sys_create_shared_object(sharedVarName ,size ,isWritable ,(void*)allocblock->startva);
  8027a1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027a4:	8b 00                	mov    (%eax),%eax
  8027a6:	89 c2                	mov    %eax,%edx
  8027a8:	0f b6 45 c4          	movzbl -0x3c(%ebp),%eax
  8027ac:	52                   	push   %edx
  8027ad:	50                   	push   %eax
  8027ae:	ff 75 0c             	pushl  0xc(%ebp)
  8027b1:	ff 75 08             	pushl  0x8(%ebp)
  8027b4:	e8 ea 09 00 00       	call   8031a3 <sys_create_shared_object>
  8027b9:	83 c4 10             	add    $0x10,%esp
  8027bc:	89 45 d8             	mov    %eax,-0x28(%ebp)

	                if(result <0){
  8027bf:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8027c3:	79 28                	jns    8027ed <smalloc+0x3e6>
	                	free_block(allocblock);
  8027c5:	83 ec 0c             	sub    $0xc,%esp
  8027c8:	ff 75 ec             	pushl  -0x14(%ebp)
  8027cb:	e8 71 14 00 00       	call   803c41 <free_block>
  8027d0:	83 c4 10             	add    $0x10,%esp
	                	release_uspinlock(&ulock);
  8027d3:	83 ec 0c             	sub    $0xc,%esp
  8027d6:	68 80 16 8e 00       	push   $0x8e1680
  8027db:	e8 f8 18 00 00       	call   8040d8 <release_uspinlock>
  8027e0:	83 c4 10             	add    $0x10,%esp
	                	return NULL;
  8027e3:	b8 00 00 00 00       	mov    $0x0,%eax
  8027e8:	e9 bf 01 00 00       	jmp    8029ac <smalloc+0x5a5>
	                }
	                release_uspinlock(&ulock);
  8027ed:	83 ec 0c             	sub    $0xc,%esp
  8027f0:	68 80 16 8e 00       	push   $0x8e1680
  8027f5:	e8 de 18 00 00       	call   8040d8 <release_uspinlock>
  8027fa:	83 c4 10             	add    $0x10,%esp
	                return (void*)allocblock->startva;
  8027fd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802800:	8b 00                	mov    (%eax),%eax
  802802:	e9 a5 01 00 00       	jmp    8029ac <smalloc+0x5a5>
	                //exact fit
				}else if(size == currentfreeelement->size){
  802807:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80280a:	8b 40 04             	mov    0x4(%eax),%eax
  80280d:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802810:	0f 85 60 01 00 00    	jne    802976 <smalloc+0x56f>
					allocblock->startva = currentfreeelement->startva;
  802816:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802819:	8b 10                	mov    (%eax),%edx
  80281b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80281e:	89 10                	mov    %edx,(%eax)
					allocblock->size = size;
  802820:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802823:	8b 55 0c             	mov    0xc(%ebp),%edx
  802826:	89 50 04             	mov    %edx,0x4(%eax)
					LIST_INSERT_TAIL(&u_allocatedlist ,allocblock);
  802829:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80282d:	75 17                	jne    802846 <smalloc+0x43f>
  80282f:	83 ec 04             	sub    $0x4,%esp
  802832:	68 f8 4b 80 00       	push   $0x804bf8
  802837:	68 8c 01 00 00       	push   $0x18c
  80283c:	68 ac 4b 80 00       	push   $0x804bac
  802841:	e8 f3 18 00 00       	call   804139 <_panic>
  802846:	8b 15 74 16 8e 00    	mov    0x8e1674,%edx
  80284c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80284f:	89 50 0c             	mov    %edx,0xc(%eax)
  802852:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802855:	8b 40 0c             	mov    0xc(%eax),%eax
  802858:	85 c0                	test   %eax,%eax
  80285a:	74 0d                	je     802869 <smalloc+0x462>
  80285c:	a1 74 16 8e 00       	mov    0x8e1674,%eax
  802861:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802864:	89 50 08             	mov    %edx,0x8(%eax)
  802867:	eb 08                	jmp    802871 <smalloc+0x46a>
  802869:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80286c:	a3 70 16 8e 00       	mov    %eax,0x8e1670
  802871:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802874:	a3 74 16 8e 00       	mov    %eax,0x8e1674
  802879:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80287c:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802883:	a1 7c 16 8e 00       	mov    0x8e167c,%eax
  802888:	40                   	inc    %eax
  802889:	a3 7c 16 8e 00       	mov    %eax,0x8e167c
					LIST_REMOVE(&u_freelist ,currentfreeelement);
  80288e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802892:	75 17                	jne    8028ab <smalloc+0x4a4>
  802894:	83 ec 04             	sub    $0x4,%esp
  802897:	68 1b 4c 80 00       	push   $0x804c1b
  80289c:	68 8d 01 00 00       	push   $0x18d
  8028a1:	68 ac 4b 80 00       	push   $0x804bac
  8028a6:	e8 8e 18 00 00       	call   804139 <_panic>
  8028ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028ae:	8b 40 08             	mov    0x8(%eax),%eax
  8028b1:	85 c0                	test   %eax,%eax
  8028b3:	74 11                	je     8028c6 <smalloc+0x4bf>
  8028b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028b8:	8b 40 08             	mov    0x8(%eax),%eax
  8028bb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028be:	8b 52 0c             	mov    0xc(%edx),%edx
  8028c1:	89 50 0c             	mov    %edx,0xc(%eax)
  8028c4:	eb 0b                	jmp    8028d1 <smalloc+0x4ca>
  8028c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028c9:	8b 40 0c             	mov    0xc(%eax),%eax
  8028cc:	a3 64 16 8e 00       	mov    %eax,0x8e1664
  8028d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028d4:	8b 40 0c             	mov    0xc(%eax),%eax
  8028d7:	85 c0                	test   %eax,%eax
  8028d9:	74 11                	je     8028ec <smalloc+0x4e5>
  8028db:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028de:	8b 40 0c             	mov    0xc(%eax),%eax
  8028e1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028e4:	8b 52 08             	mov    0x8(%edx),%edx
  8028e7:	89 50 08             	mov    %edx,0x8(%eax)
  8028ea:	eb 0b                	jmp    8028f7 <smalloc+0x4f0>
  8028ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028ef:	8b 40 08             	mov    0x8(%eax),%eax
  8028f2:	a3 60 16 8e 00       	mov    %eax,0x8e1660
  8028f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028fa:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802901:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802904:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  80290b:	a1 6c 16 8e 00       	mov    0x8e166c,%eax
  802910:	48                   	dec    %eax
  802911:	a3 6c 16 8e 00       	mov    %eax,0x8e166c
					int result = sys_create_shared_object(sharedVarName ,size ,isWritable ,(void*)allocblock->startva);
  802916:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802919:	8b 00                	mov    (%eax),%eax
  80291b:	89 c2                	mov    %eax,%edx
  80291d:	0f b6 45 c4          	movzbl -0x3c(%ebp),%eax
  802921:	52                   	push   %edx
  802922:	50                   	push   %eax
  802923:	ff 75 0c             	pushl  0xc(%ebp)
  802926:	ff 75 08             	pushl  0x8(%ebp)
  802929:	e8 75 08 00 00       	call   8031a3 <sys_create_shared_object>
  80292e:	83 c4 10             	add    $0x10,%esp
  802931:	89 45 dc             	mov    %eax,-0x24(%ebp)

					if(result <0){
  802934:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802938:	79 25                	jns    80295f <smalloc+0x558>
						free_block(allocblock);
  80293a:	83 ec 0c             	sub    $0xc,%esp
  80293d:	ff 75 ec             	pushl  -0x14(%ebp)
  802940:	e8 fc 12 00 00       	call   803c41 <free_block>
  802945:	83 c4 10             	add    $0x10,%esp
						release_uspinlock(&ulock);
  802948:	83 ec 0c             	sub    $0xc,%esp
  80294b:	68 80 16 8e 00       	push   $0x8e1680
  802950:	e8 83 17 00 00       	call   8040d8 <release_uspinlock>
  802955:	83 c4 10             	add    $0x10,%esp
						return NULL;
  802958:	b8 00 00 00 00       	mov    $0x0,%eax
  80295d:	eb 4d                	jmp    8029ac <smalloc+0x5a5>
					}
					release_uspinlock(&ulock);
  80295f:	83 ec 0c             	sub    $0xc,%esp
  802962:	68 80 16 8e 00       	push   $0x8e1680
  802967:	e8 6c 17 00 00       	call   8040d8 <release_uspinlock>
  80296c:	83 c4 10             	add    $0x10,%esp
					return (void*)allocblock->startva;
  80296f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802972:	8b 00                	mov    (%eax),%eax
  802974:	eb 36                	jmp    8029ac <smalloc+0x5a5>
				}
				currentfreeelement = currentfreeelement->prev_next_info.le_next;
  802976:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802979:	8b 40 08             	mov    0x8(%eax),%eax
  80297c:	89 45 f4             	mov    %eax,-0xc(%ebp)
					 }
		}else{
			//custom fit
			struct UserHeapStruct* currentfreeelement = LIST_FIRST(&u_freelist);
			//worst fit
			while(currentfreeelement != NULL){
  80297f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802983:	0f 85 47 fc ff ff    	jne    8025d0 <smalloc+0x1c9>
					return (void*)allocblock->startva;
				}
				currentfreeelement = currentfreeelement->prev_next_info.le_next;
			}
		}
		free_block(allocblock);
  802989:	83 ec 0c             	sub    $0xc,%esp
  80298c:	ff 75 ec             	pushl  -0x14(%ebp)
  80298f:	e8 ad 12 00 00       	call   803c41 <free_block>
  802994:	83 c4 10             	add    $0x10,%esp
		release_uspinlock(&ulock);
  802997:	83 ec 0c             	sub    $0xc,%esp
  80299a:	68 80 16 8e 00       	push   $0x8e1680
  80299f:	e8 34 17 00 00       	call   8040d8 <release_uspinlock>
  8029a4:	83 c4 10             	add    $0x10,%esp
		return NULL;
  8029a7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8029ac:	c9                   	leave  
  8029ad:	c3                   	ret    

008029ae <sget>:

//========================================
// [4] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8029ae:	55                   	push   %ebp
  8029af:	89 e5                	mov    %esp,%ebp
  8029b1:	83 ec 38             	sub    $0x38,%esp


	 //==============================================================
	 // DON'T CHANGE THIS CODE
	    uheap_init();
  8029b4:	e8 8c ec ff ff       	call   801645 <uheap_init>
	 //==============================================================
	 // Get size of the shared variable from kernel
	acquire_uspinlock(&ulock);
  8029b9:	83 ec 0c             	sub    $0xc,%esp
  8029bc:	68 80 16 8e 00       	push   $0x8e1680
  8029c1:	e8 ba 16 00 00       	call   804080 <acquire_uspinlock>
  8029c6:	83 c4 10             	add    $0x10,%esp


	int size = sys_size_of_shared_object(ownerEnvID ,sharedVarName);
  8029c9:	83 ec 08             	sub    $0x8,%esp
  8029cc:	ff 75 0c             	pushl  0xc(%ebp)
  8029cf:	ff 75 08             	pushl  0x8(%ebp)
  8029d2:	e8 f6 07 00 00       	call   8031cd <sys_size_of_shared_object>
  8029d7:	83 c4 10             	add    $0x10,%esp
  8029da:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if ( size < 0 ){
  8029dd:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8029e1:	79 1a                	jns    8029fd <sget+0x4f>
			release_uspinlock(&ulock);
  8029e3:	83 ec 0c             	sub    $0xc,%esp
  8029e6:	68 80 16 8e 00       	push   $0x8e1680
  8029eb:	e8 e8 16 00 00       	call   8040d8 <release_uspinlock>
  8029f0:	83 c4 10             	add    $0x10,%esp
			return NULL;
  8029f3:	b8 00 00 00 00       	mov    $0x0,%eax
  8029f8:	e9 6e 05 00 00       	jmp    802f6b <sget+0x5bd>
		}
		size = ROUNDUP(size,PAGE_SIZE);
  8029fd:	c7 45 e8 00 10 00 00 	movl   $0x1000,-0x18(%ebp)
  802a04:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802a07:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a0a:	01 d0                	add    %edx,%eax
  802a0c:	48                   	dec    %eax
  802a0d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  802a10:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802a13:	ba 00 00 00 00       	mov    $0x0,%edx
  802a18:	f7 75 e8             	divl   -0x18(%ebp)
  802a1b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802a1e:	29 d0                	sub    %edx,%eax
  802a20:	89 45 ec             	mov    %eax,-0x14(%ebp)

		struct UserHeapStruct* allocblock = (struct UserHeapStruct*) alloc_block(sizeof(struct UserHeapStruct));
  802a23:	83 ec 0c             	sub    $0xc,%esp
  802a26:	6a 10                	push   $0x10
  802a28:	e8 78 0d 00 00       	call   8037a5 <alloc_block>
  802a2d:	83 c4 10             	add    $0x10,%esp
  802a30:	89 45 e0             	mov    %eax,-0x20(%ebp)

		if (allocblock == NULL){
  802a33:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802a37:	75 0a                	jne    802a43 <sget+0x95>
			return NULL;
  802a39:	b8 00 00 00 00       	mov    $0x0,%eax
  802a3e:	e9 28 05 00 00       	jmp    802f6b <sget+0x5bd>
		}
		struct UserHeapStruct* lastfreeelement = LIST_LAST(&u_freelist);
  802a43:	a1 64 16 8e 00       	mov    0x8e1664,%eax
  802a48:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if(LIST_SIZE(&u_freelist)==0 || size>lastfreeelement->size){
  802a4b:	a1 6c 16 8e 00       	mov    0x8e166c,%eax
  802a50:	85 c0                	test   %eax,%eax
  802a52:	74 11                	je     802a65 <sget+0xb7>
  802a54:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802a57:	8b 50 04             	mov    0x4(%eax),%edx
  802a5a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a5d:	39 c2                	cmp    %eax,%edx
  802a5f:	0f 83 21 01 00 00    	jae    802b86 <sget+0x1d8>
				if(uheapPageAllocBreak <= USER_HEAP_MAX - size){
  802a65:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a68:	ba 00 00 00 a0       	mov    $0xa0000000,%edx
  802a6d:	29 c2                	sub    %eax,%edx
  802a6f:	a1 08 fb 87 00       	mov    0x87fb08,%eax
  802a74:	39 c2                	cmp    %eax,%edx
  802a76:	0f 82 f0 00 00 00    	jb     802b6c <sget+0x1be>

						uint32 requestedblockva = uheapPageAllocBreak;
  802a7c:	a1 08 fb 87 00       	mov    0x87fb08,%eax
  802a81:	89 45 d0             	mov    %eax,-0x30(%ebp)
						uheapPageAllocBreak+=size;
  802a84:	8b 15 08 fb 87 00    	mov    0x87fb08,%edx
  802a8a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a8d:	01 d0                	add    %edx,%eax
  802a8f:	a3 08 fb 87 00       	mov    %eax,0x87fb08
						allocblock->startva = requestedblockva;
  802a94:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802a97:	8b 55 d0             	mov    -0x30(%ebp),%edx
  802a9a:	89 10                	mov    %edx,(%eax)
						allocblock->size = size;
  802a9c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802a9f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802aa2:	89 50 04             	mov    %edx,0x4(%eax)

						LIST_INSERT_TAIL(&u_allocatedlist, allocblock);
  802aa5:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802aa9:	75 17                	jne    802ac2 <sget+0x114>
  802aab:	83 ec 04             	sub    $0x4,%esp
  802aae:	68 f8 4b 80 00       	push   $0x804bf8
  802ab3:	68 c8 01 00 00       	push   $0x1c8
  802ab8:	68 ac 4b 80 00       	push   $0x804bac
  802abd:	e8 77 16 00 00       	call   804139 <_panic>
  802ac2:	8b 15 74 16 8e 00    	mov    0x8e1674,%edx
  802ac8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802acb:	89 50 0c             	mov    %edx,0xc(%eax)
  802ace:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802ad1:	8b 40 0c             	mov    0xc(%eax),%eax
  802ad4:	85 c0                	test   %eax,%eax
  802ad6:	74 0d                	je     802ae5 <sget+0x137>
  802ad8:	a1 74 16 8e 00       	mov    0x8e1674,%eax
  802add:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802ae0:	89 50 08             	mov    %edx,0x8(%eax)
  802ae3:	eb 08                	jmp    802aed <sget+0x13f>
  802ae5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802ae8:	a3 70 16 8e 00       	mov    %eax,0x8e1670
  802aed:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802af0:	a3 74 16 8e 00       	mov    %eax,0x8e1674
  802af5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802af8:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802aff:	a1 7c 16 8e 00       	mov    0x8e167c,%eax
  802b04:	40                   	inc    %eax
  802b05:	a3 7c 16 8e 00       	mov    %eax,0x8e167c


						int result = sys_get_shared_object(ownerEnvID ,sharedVarName ,(void*)allocblock->startva);
  802b0a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802b0d:	8b 00                	mov    (%eax),%eax
  802b0f:	83 ec 04             	sub    $0x4,%esp
  802b12:	50                   	push   %eax
  802b13:	ff 75 0c             	pushl  0xc(%ebp)
  802b16:	ff 75 08             	pushl  0x8(%ebp)
  802b19:	e8 cc 06 00 00       	call   8031ea <sys_get_shared_object>
  802b1e:	83 c4 10             	add    $0x10,%esp
  802b21:	89 45 cc             	mov    %eax,-0x34(%ebp)

						if(result <0){
  802b24:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802b28:	79 28                	jns    802b52 <sget+0x1a4>
							free_block(allocblock);
  802b2a:	83 ec 0c             	sub    $0xc,%esp
  802b2d:	ff 75 e0             	pushl  -0x20(%ebp)
  802b30:	e8 0c 11 00 00       	call   803c41 <free_block>
  802b35:	83 c4 10             	add    $0x10,%esp
							release_uspinlock(&ulock);
  802b38:	83 ec 0c             	sub    $0xc,%esp
  802b3b:	68 80 16 8e 00       	push   $0x8e1680
  802b40:	e8 93 15 00 00       	call   8040d8 <release_uspinlock>
  802b45:	83 c4 10             	add    $0x10,%esp
							return NULL;
  802b48:	b8 00 00 00 00       	mov    $0x0,%eax
  802b4d:	e9 19 04 00 00       	jmp    802f6b <sget+0x5bd>
						}
						release_uspinlock(&ulock);
  802b52:	83 ec 0c             	sub    $0xc,%esp
  802b55:	68 80 16 8e 00       	push   $0x8e1680
  802b5a:	e8 79 15 00 00       	call   8040d8 <release_uspinlock>
  802b5f:	83 c4 10             	add    $0x10,%esp
						return (void*)allocblock -> startva;
  802b62:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802b65:	8b 00                	mov    (%eax),%eax
  802b67:	e9 ff 03 00 00       	jmp    802f6b <sget+0x5bd>
				}else{
						release_uspinlock(&ulock);
  802b6c:	83 ec 0c             	sub    $0xc,%esp
  802b6f:	68 80 16 8e 00       	push   $0x8e1680
  802b74:	e8 5f 15 00 00       	call   8040d8 <release_uspinlock>
  802b79:	83 c4 10             	add    $0x10,%esp
						return NULL;
  802b7c:	b8 00 00 00 00       	mov    $0x0,%eax
  802b81:	e9 e5 03 00 00       	jmp    802f6b <sget+0x5bd>
					 }
		}else{
			//custom fit
			struct UserHeapStruct* currentfreeelement = LIST_FIRST(&u_freelist);
  802b86:	a1 60 16 8e 00       	mov    0x8e1660,%eax
  802b8b:	89 45 f4             	mov    %eax,-0xc(%ebp)
			//worst fit
			while(currentfreeelement != NULL){
  802b8e:	e9 ab 03 00 00       	jmp    802f3e <sget+0x590>
				if(size<currentfreeelement->size){
  802b93:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b96:	8b 50 04             	mov    0x4(%eax),%edx
  802b99:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b9c:	39 c2                	cmp    %eax,%edx
  802b9e:	0f 86 24 02 00 00    	jbe    802dc8 <sget+0x41a>
					allocblock->startva = lastfreeelement->startva;
  802ba4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802ba7:	8b 10                	mov    (%eax),%edx
  802ba9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802bac:	89 10                	mov    %edx,(%eax)
					allocblock->size = size;
  802bae:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802bb1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802bb4:	89 50 04             	mov    %edx,0x4(%eax)
					LIST_INSERT_TAIL(&u_allocatedlist,allocblock);
  802bb7:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802bbb:	75 17                	jne    802bd4 <sget+0x226>
  802bbd:	83 ec 04             	sub    $0x4,%esp
  802bc0:	68 f8 4b 80 00       	push   $0x804bf8
  802bc5:	68 e0 01 00 00       	push   $0x1e0
  802bca:	68 ac 4b 80 00       	push   $0x804bac
  802bcf:	e8 65 15 00 00       	call   804139 <_panic>
  802bd4:	8b 15 74 16 8e 00    	mov    0x8e1674,%edx
  802bda:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802bdd:	89 50 0c             	mov    %edx,0xc(%eax)
  802be0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802be3:	8b 40 0c             	mov    0xc(%eax),%eax
  802be6:	85 c0                	test   %eax,%eax
  802be8:	74 0d                	je     802bf7 <sget+0x249>
  802bea:	a1 74 16 8e 00       	mov    0x8e1674,%eax
  802bef:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802bf2:	89 50 08             	mov    %edx,0x8(%eax)
  802bf5:	eb 08                	jmp    802bff <sget+0x251>
  802bf7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802bfa:	a3 70 16 8e 00       	mov    %eax,0x8e1670
  802bff:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802c02:	a3 74 16 8e 00       	mov    %eax,0x8e1674
  802c07:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802c0a:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802c11:	a1 7c 16 8e 00       	mov    0x8e167c,%eax
  802c16:	40                   	inc    %eax
  802c17:	a3 7c 16 8e 00       	mov    %eax,0x8e167c
					lastfreeelement->startva += size;
  802c1c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802c1f:	8b 10                	mov    (%eax),%edx
  802c21:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c24:	01 c2                	add    %eax,%edx
  802c26:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802c29:	89 10                	mov    %edx,(%eax)
					lastfreeelement->size -= size;
  802c2b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802c2e:	8b 50 04             	mov    0x4(%eax),%edx
  802c31:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c34:	29 c2                	sub    %eax,%edx
  802c36:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802c39:	89 50 04             	mov    %edx,0x4(%eax)
					struct UserHeapStruct* currentfree2 = LIST_FIRST(&u_freelist);
  802c3c:	a1 60 16 8e 00       	mov    0x8e1660,%eax
  802c41:	89 45 f0             	mov    %eax,-0x10(%ebp)
					//check order of last element

					while (currentfree2 != NULL){
  802c44:	e9 13 01 00 00       	jmp    802d5c <sget+0x3ae>
						if(lastfreeelement->size <currentfree2->size){
  802c49:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802c4c:	8b 50 04             	mov    0x4(%eax),%edx
  802c4f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c52:	8b 40 04             	mov    0x4(%eax),%eax
  802c55:	39 c2                	cmp    %eax,%edx
  802c57:	0f 83 f6 00 00 00    	jae    802d53 <sget+0x3a5>
							LIST_REMOVE(&u_freelist ,lastfreeelement);
  802c5d:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802c61:	75 17                	jne    802c7a <sget+0x2cc>
  802c63:	83 ec 04             	sub    $0x4,%esp
  802c66:	68 1b 4c 80 00       	push   $0x804c1b
  802c6b:	68 e8 01 00 00       	push   $0x1e8
  802c70:	68 ac 4b 80 00       	push   $0x804bac
  802c75:	e8 bf 14 00 00       	call   804139 <_panic>
  802c7a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802c7d:	8b 40 08             	mov    0x8(%eax),%eax
  802c80:	85 c0                	test   %eax,%eax
  802c82:	74 11                	je     802c95 <sget+0x2e7>
  802c84:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802c87:	8b 40 08             	mov    0x8(%eax),%eax
  802c8a:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802c8d:	8b 52 0c             	mov    0xc(%edx),%edx
  802c90:	89 50 0c             	mov    %edx,0xc(%eax)
  802c93:	eb 0b                	jmp    802ca0 <sget+0x2f2>
  802c95:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802c98:	8b 40 0c             	mov    0xc(%eax),%eax
  802c9b:	a3 64 16 8e 00       	mov    %eax,0x8e1664
  802ca0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802ca3:	8b 40 0c             	mov    0xc(%eax),%eax
  802ca6:	85 c0                	test   %eax,%eax
  802ca8:	74 11                	je     802cbb <sget+0x30d>
  802caa:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802cad:	8b 40 0c             	mov    0xc(%eax),%eax
  802cb0:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802cb3:	8b 52 08             	mov    0x8(%edx),%edx
  802cb6:	89 50 08             	mov    %edx,0x8(%eax)
  802cb9:	eb 0b                	jmp    802cc6 <sget+0x318>
  802cbb:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802cbe:	8b 40 08             	mov    0x8(%eax),%eax
  802cc1:	a3 60 16 8e 00       	mov    %eax,0x8e1660
  802cc6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802cc9:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802cd0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802cd3:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  802cda:	a1 6c 16 8e 00       	mov    0x8e166c,%eax
  802cdf:	48                   	dec    %eax
  802ce0:	a3 6c 16 8e 00       	mov    %eax,0x8e166c
							LIST_INSERT_BEFORE(&u_freelist ,currentfree2 ,lastfreeelement);
  802ce5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802ce9:	74 06                	je     802cf1 <sget+0x343>
  802ceb:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802cef:	75 17                	jne    802d08 <sget+0x35a>
  802cf1:	83 ec 04             	sub    $0x4,%esp
  802cf4:	68 3c 4c 80 00       	push   $0x804c3c
  802cf9:	68 e9 01 00 00       	push   $0x1e9
  802cfe:	68 ac 4b 80 00       	push   $0x804bac
  802d03:	e8 31 14 00 00       	call   804139 <_panic>
  802d08:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d0b:	8b 50 0c             	mov    0xc(%eax),%edx
  802d0e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802d11:	89 50 0c             	mov    %edx,0xc(%eax)
  802d14:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802d17:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802d1a:	89 50 08             	mov    %edx,0x8(%eax)
  802d1d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d20:	8b 40 0c             	mov    0xc(%eax),%eax
  802d23:	85 c0                	test   %eax,%eax
  802d25:	74 0e                	je     802d35 <sget+0x387>
  802d27:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d2a:	8b 40 0c             	mov    0xc(%eax),%eax
  802d2d:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802d30:	89 50 08             	mov    %edx,0x8(%eax)
  802d33:	eb 08                	jmp    802d3d <sget+0x38f>
  802d35:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802d38:	a3 60 16 8e 00       	mov    %eax,0x8e1660
  802d3d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d40:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802d43:	89 50 0c             	mov    %edx,0xc(%eax)
  802d46:	a1 6c 16 8e 00       	mov    0x8e166c,%eax
  802d4b:	40                   	inc    %eax
  802d4c:	a3 6c 16 8e 00       	mov    %eax,0x8e166c
							break;
  802d51:	eb 13                	jmp    802d66 <sget+0x3b8>
						}
						currentfree2 = currentfree2->prev_next_info.le_next;
  802d53:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d56:	8b 40 08             	mov    0x8(%eax),%eax
  802d59:	89 45 f0             	mov    %eax,-0x10(%ebp)
					lastfreeelement->startva += size;
					lastfreeelement->size -= size;
					struct UserHeapStruct* currentfree2 = LIST_FIRST(&u_freelist);
					//check order of last element

					while (currentfree2 != NULL){
  802d5c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802d60:	0f 85 e3 fe ff ff    	jne    802c49 <sget+0x29b>
						}
						currentfree2 = currentfree2->prev_next_info.le_next;
					}


					int result = sys_get_shared_object(ownerEnvID ,sharedVarName ,(void*)allocblock->startva);
  802d66:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802d69:	8b 00                	mov    (%eax),%eax
  802d6b:	83 ec 04             	sub    $0x4,%esp
  802d6e:	50                   	push   %eax
  802d6f:	ff 75 0c             	pushl  0xc(%ebp)
  802d72:	ff 75 08             	pushl  0x8(%ebp)
  802d75:	e8 70 04 00 00       	call   8031ea <sys_get_shared_object>
  802d7a:	83 c4 10             	add    $0x10,%esp
  802d7d:	89 45 d4             	mov    %eax,-0x2c(%ebp)

					if(result <0){
  802d80:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  802d84:	79 28                	jns    802dae <sget+0x400>
						free_block(allocblock);
  802d86:	83 ec 0c             	sub    $0xc,%esp
  802d89:	ff 75 e0             	pushl  -0x20(%ebp)
  802d8c:	e8 b0 0e 00 00       	call   803c41 <free_block>
  802d91:	83 c4 10             	add    $0x10,%esp
						release_uspinlock(&ulock);
  802d94:	83 ec 0c             	sub    $0xc,%esp
  802d97:	68 80 16 8e 00       	push   $0x8e1680
  802d9c:	e8 37 13 00 00       	call   8040d8 <release_uspinlock>
  802da1:	83 c4 10             	add    $0x10,%esp
						return NULL;
  802da4:	b8 00 00 00 00       	mov    $0x0,%eax
  802da9:	e9 bd 01 00 00       	jmp    802f6b <sget+0x5bd>
					}
					release_uspinlock(&ulock);
  802dae:	83 ec 0c             	sub    $0xc,%esp
  802db1:	68 80 16 8e 00       	push   $0x8e1680
  802db6:	e8 1d 13 00 00       	call   8040d8 <release_uspinlock>
  802dbb:	83 c4 10             	add    $0x10,%esp
					return (void*)allocblock->startva;
  802dbe:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802dc1:	8b 00                	mov    (%eax),%eax
  802dc3:	e9 a3 01 00 00       	jmp    802f6b <sget+0x5bd>
					//exact fit
				}else if(size == currentfreeelement->size){
  802dc8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dcb:	8b 50 04             	mov    0x4(%eax),%edx
  802dce:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802dd1:	39 c2                	cmp    %eax,%edx
  802dd3:	0f 85 5c 01 00 00    	jne    802f35 <sget+0x587>

					allocblock->startva = currentfreeelement->startva;
  802dd9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ddc:	8b 10                	mov    (%eax),%edx
  802dde:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802de1:	89 10                	mov    %edx,(%eax)
					allocblock->size = size;
  802de3:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802de6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802de9:	89 50 04             	mov    %edx,0x4(%eax)
					LIST_INSERT_TAIL(&u_allocatedlist ,allocblock);
  802dec:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802df0:	75 17                	jne    802e09 <sget+0x45b>
  802df2:	83 ec 04             	sub    $0x4,%esp
  802df5:	68 f8 4b 80 00       	push   $0x804bf8
  802dfa:	68 fe 01 00 00       	push   $0x1fe
  802dff:	68 ac 4b 80 00       	push   $0x804bac
  802e04:	e8 30 13 00 00       	call   804139 <_panic>
  802e09:	8b 15 74 16 8e 00    	mov    0x8e1674,%edx
  802e0f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802e12:	89 50 0c             	mov    %edx,0xc(%eax)
  802e15:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802e18:	8b 40 0c             	mov    0xc(%eax),%eax
  802e1b:	85 c0                	test   %eax,%eax
  802e1d:	74 0d                	je     802e2c <sget+0x47e>
  802e1f:	a1 74 16 8e 00       	mov    0x8e1674,%eax
  802e24:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802e27:	89 50 08             	mov    %edx,0x8(%eax)
  802e2a:	eb 08                	jmp    802e34 <sget+0x486>
  802e2c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802e2f:	a3 70 16 8e 00       	mov    %eax,0x8e1670
  802e34:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802e37:	a3 74 16 8e 00       	mov    %eax,0x8e1674
  802e3c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802e3f:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802e46:	a1 7c 16 8e 00       	mov    0x8e167c,%eax
  802e4b:	40                   	inc    %eax
  802e4c:	a3 7c 16 8e 00       	mov    %eax,0x8e167c
					LIST_REMOVE(&u_freelist ,currentfreeelement);
  802e51:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e55:	75 17                	jne    802e6e <sget+0x4c0>
  802e57:	83 ec 04             	sub    $0x4,%esp
  802e5a:	68 1b 4c 80 00       	push   $0x804c1b
  802e5f:	68 ff 01 00 00       	push   $0x1ff
  802e64:	68 ac 4b 80 00       	push   $0x804bac
  802e69:	e8 cb 12 00 00       	call   804139 <_panic>
  802e6e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e71:	8b 40 08             	mov    0x8(%eax),%eax
  802e74:	85 c0                	test   %eax,%eax
  802e76:	74 11                	je     802e89 <sget+0x4db>
  802e78:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e7b:	8b 40 08             	mov    0x8(%eax),%eax
  802e7e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e81:	8b 52 0c             	mov    0xc(%edx),%edx
  802e84:	89 50 0c             	mov    %edx,0xc(%eax)
  802e87:	eb 0b                	jmp    802e94 <sget+0x4e6>
  802e89:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e8c:	8b 40 0c             	mov    0xc(%eax),%eax
  802e8f:	a3 64 16 8e 00       	mov    %eax,0x8e1664
  802e94:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e97:	8b 40 0c             	mov    0xc(%eax),%eax
  802e9a:	85 c0                	test   %eax,%eax
  802e9c:	74 11                	je     802eaf <sget+0x501>
  802e9e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ea1:	8b 40 0c             	mov    0xc(%eax),%eax
  802ea4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ea7:	8b 52 08             	mov    0x8(%edx),%edx
  802eaa:	89 50 08             	mov    %edx,0x8(%eax)
  802ead:	eb 0b                	jmp    802eba <sget+0x50c>
  802eaf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eb2:	8b 40 08             	mov    0x8(%eax),%eax
  802eb5:	a3 60 16 8e 00       	mov    %eax,0x8e1660
  802eba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ebd:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802ec4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ec7:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  802ece:	a1 6c 16 8e 00       	mov    0x8e166c,%eax
  802ed3:	48                   	dec    %eax
  802ed4:	a3 6c 16 8e 00       	mov    %eax,0x8e166c

					int result = sys_get_shared_object(ownerEnvID ,sharedVarName ,(void*)allocblock->startva);
  802ed9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802edc:	8b 00                	mov    (%eax),%eax
  802ede:	83 ec 04             	sub    $0x4,%esp
  802ee1:	50                   	push   %eax
  802ee2:	ff 75 0c             	pushl  0xc(%ebp)
  802ee5:	ff 75 08             	pushl  0x8(%ebp)
  802ee8:	e8 fd 02 00 00       	call   8031ea <sys_get_shared_object>
  802eed:	83 c4 10             	add    $0x10,%esp
  802ef0:	89 45 d8             	mov    %eax,-0x28(%ebp)
					if(result <0){
  802ef3:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  802ef7:	79 25                	jns    802f1e <sget+0x570>
						free_block(allocblock);
  802ef9:	83 ec 0c             	sub    $0xc,%esp
  802efc:	ff 75 e0             	pushl  -0x20(%ebp)
  802eff:	e8 3d 0d 00 00       	call   803c41 <free_block>
  802f04:	83 c4 10             	add    $0x10,%esp
						release_uspinlock(&ulock);
  802f07:	83 ec 0c             	sub    $0xc,%esp
  802f0a:	68 80 16 8e 00       	push   $0x8e1680
  802f0f:	e8 c4 11 00 00       	call   8040d8 <release_uspinlock>
  802f14:	83 c4 10             	add    $0x10,%esp
						return NULL;
  802f17:	b8 00 00 00 00       	mov    $0x0,%eax
  802f1c:	eb 4d                	jmp    802f6b <sget+0x5bd>
					}

					release_uspinlock(&ulock);
  802f1e:	83 ec 0c             	sub    $0xc,%esp
  802f21:	68 80 16 8e 00       	push   $0x8e1680
  802f26:	e8 ad 11 00 00       	call   8040d8 <release_uspinlock>
  802f2b:	83 c4 10             	add    $0x10,%esp
					return (void*)allocblock->startva;
  802f2e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802f31:	8b 00                	mov    (%eax),%eax
  802f33:	eb 36                	jmp    802f6b <sget+0x5bd>
				}
				currentfreeelement = currentfreeelement->prev_next_info.le_next;
  802f35:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f38:	8b 40 08             	mov    0x8(%eax),%eax
  802f3b:	89 45 f4             	mov    %eax,-0xc(%ebp)
					 }
		}else{
			//custom fit
			struct UserHeapStruct* currentfreeelement = LIST_FIRST(&u_freelist);
			//worst fit
			while(currentfreeelement != NULL){
  802f3e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f42:	0f 85 4b fc ff ff    	jne    802b93 <sget+0x1e5>
					return (void*)allocblock->startva;
				}
				currentfreeelement = currentfreeelement->prev_next_info.le_next;
			}
		}
		free_block(allocblock);
  802f48:	83 ec 0c             	sub    $0xc,%esp
  802f4b:	ff 75 e0             	pushl  -0x20(%ebp)
  802f4e:	e8 ee 0c 00 00       	call   803c41 <free_block>
  802f53:	83 c4 10             	add    $0x10,%esp
		release_uspinlock(&ulock);
  802f56:	83 ec 0c             	sub    $0xc,%esp
  802f59:	68 80 16 8e 00       	push   $0x8e1680
  802f5e:	e8 75 11 00 00       	call   8040d8 <release_uspinlock>
  802f63:	83 c4 10             	add    $0x10,%esp
		return NULL;
  802f66:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802f6b:	c9                   	leave  
  802f6c:	c3                   	ret    

00802f6d <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  802f6d:	55                   	push   %ebp
  802f6e:	89 e5                	mov    %esp,%ebp
  802f70:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  802f73:	e8 cd e6 ff ff       	call   801645 <uheap_init>
	//==============================================================
	panic("realloc() is not implemented yet...!!");
  802f78:	83 ec 04             	sub    $0x4,%esp
  802f7b:	68 cc 4c 80 00       	push   $0x804ccc
  802f80:	68 2d 02 00 00       	push   $0x22d
  802f85:	68 ac 4b 80 00       	push   $0x804bac
  802f8a:	e8 aa 11 00 00       	call   804139 <_panic>

00802f8f <sfree>:
//
//	use sys_delete_shared_object(...); which switches to the kernel mode,
//	calls delete_shared_object(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the delete_shared_object() function is empty, make sure to implement it.
void sfree(void* virtual_address)
{
  802f8f:	55                   	push   %ebp
  802f90:	89 e5                	mov    %esp,%ebp
  802f92:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.BONUS#5] EXIT #2 - sfree
	//Your code is here
	//Comment the following line
	panic("sfree() is not implemented yet...!!");
  802f95:	83 ec 04             	sub    $0x4,%esp
  802f98:	68 f4 4c 80 00       	push   $0x804cf4
  802f9d:	68 40 02 00 00       	push   $0x240
  802fa2:	68 ac 4b 80 00       	push   $0x804bac
  802fa7:	e8 8d 11 00 00       	call   804139 <_panic>

00802fac <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  802fac:	55                   	push   %ebp
  802fad:	89 e5                	mov    %esp,%ebp
  802faf:	57                   	push   %edi
  802fb0:	56                   	push   %esi
  802fb1:	53                   	push   %ebx
  802fb2:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  802fb5:	8b 45 08             	mov    0x8(%ebp),%eax
  802fb8:	8b 55 0c             	mov    0xc(%ebp),%edx
  802fbb:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802fbe:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802fc1:	8b 7d 18             	mov    0x18(%ebp),%edi
  802fc4:	8b 75 1c             	mov    0x1c(%ebp),%esi
  802fc7:	cd 30                	int    $0x30
  802fc9:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  802fcc:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  802fcf:	83 c4 10             	add    $0x10,%esp
  802fd2:	5b                   	pop    %ebx
  802fd3:	5e                   	pop    %esi
  802fd4:	5f                   	pop    %edi
  802fd5:	5d                   	pop    %ebp
  802fd6:	c3                   	ret    

00802fd7 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  802fd7:	55                   	push   %ebp
  802fd8:	89 e5                	mov    %esp,%ebp
  802fda:	83 ec 04             	sub    $0x4,%esp
  802fdd:	8b 45 10             	mov    0x10(%ebp),%eax
  802fe0:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  802fe3:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802fe6:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802fea:	8b 45 08             	mov    0x8(%ebp),%eax
  802fed:	6a 00                	push   $0x0
  802fef:	51                   	push   %ecx
  802ff0:	52                   	push   %edx
  802ff1:	ff 75 0c             	pushl  0xc(%ebp)
  802ff4:	50                   	push   %eax
  802ff5:	6a 00                	push   $0x0
  802ff7:	e8 b0 ff ff ff       	call   802fac <syscall>
  802ffc:	83 c4 18             	add    $0x18,%esp
}
  802fff:	90                   	nop
  803000:	c9                   	leave  
  803001:	c3                   	ret    

00803002 <sys_cgetc>:

int
sys_cgetc(void)
{
  803002:	55                   	push   %ebp
  803003:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  803005:	6a 00                	push   $0x0
  803007:	6a 00                	push   $0x0
  803009:	6a 00                	push   $0x0
  80300b:	6a 00                	push   $0x0
  80300d:	6a 00                	push   $0x0
  80300f:	6a 02                	push   $0x2
  803011:	e8 96 ff ff ff       	call   802fac <syscall>
  803016:	83 c4 18             	add    $0x18,%esp
}
  803019:	c9                   	leave  
  80301a:	c3                   	ret    

0080301b <sys_lock_cons>:

void sys_lock_cons(void)
{
  80301b:	55                   	push   %ebp
  80301c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  80301e:	6a 00                	push   $0x0
  803020:	6a 00                	push   $0x0
  803022:	6a 00                	push   $0x0
  803024:	6a 00                	push   $0x0
  803026:	6a 00                	push   $0x0
  803028:	6a 03                	push   $0x3
  80302a:	e8 7d ff ff ff       	call   802fac <syscall>
  80302f:	83 c4 18             	add    $0x18,%esp
}
  803032:	90                   	nop
  803033:	c9                   	leave  
  803034:	c3                   	ret    

00803035 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  803035:	55                   	push   %ebp
  803036:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  803038:	6a 00                	push   $0x0
  80303a:	6a 00                	push   $0x0
  80303c:	6a 00                	push   $0x0
  80303e:	6a 00                	push   $0x0
  803040:	6a 00                	push   $0x0
  803042:	6a 04                	push   $0x4
  803044:	e8 63 ff ff ff       	call   802fac <syscall>
  803049:	83 c4 18             	add    $0x18,%esp
}
  80304c:	90                   	nop
  80304d:	c9                   	leave  
  80304e:	c3                   	ret    

0080304f <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  80304f:	55                   	push   %ebp
  803050:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  803052:	8b 55 0c             	mov    0xc(%ebp),%edx
  803055:	8b 45 08             	mov    0x8(%ebp),%eax
  803058:	6a 00                	push   $0x0
  80305a:	6a 00                	push   $0x0
  80305c:	6a 00                	push   $0x0
  80305e:	52                   	push   %edx
  80305f:	50                   	push   %eax
  803060:	6a 08                	push   $0x8
  803062:	e8 45 ff ff ff       	call   802fac <syscall>
  803067:	83 c4 18             	add    $0x18,%esp
}
  80306a:	c9                   	leave  
  80306b:	c3                   	ret    

0080306c <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  80306c:	55                   	push   %ebp
  80306d:	89 e5                	mov    %esp,%ebp
  80306f:	56                   	push   %esi
  803070:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  803071:	8b 75 18             	mov    0x18(%ebp),%esi
  803074:	8b 5d 14             	mov    0x14(%ebp),%ebx
  803077:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80307a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80307d:	8b 45 08             	mov    0x8(%ebp),%eax
  803080:	56                   	push   %esi
  803081:	53                   	push   %ebx
  803082:	51                   	push   %ecx
  803083:	52                   	push   %edx
  803084:	50                   	push   %eax
  803085:	6a 09                	push   $0x9
  803087:	e8 20 ff ff ff       	call   802fac <syscall>
  80308c:	83 c4 18             	add    $0x18,%esp
}
  80308f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  803092:	5b                   	pop    %ebx
  803093:	5e                   	pop    %esi
  803094:	5d                   	pop    %ebp
  803095:	c3                   	ret    

00803096 <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  803096:	55                   	push   %ebp
  803097:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  803099:	6a 00                	push   $0x0
  80309b:	6a 00                	push   $0x0
  80309d:	6a 00                	push   $0x0
  80309f:	6a 00                	push   $0x0
  8030a1:	ff 75 08             	pushl  0x8(%ebp)
  8030a4:	6a 0a                	push   $0xa
  8030a6:	e8 01 ff ff ff       	call   802fac <syscall>
  8030ab:	83 c4 18             	add    $0x18,%esp
}
  8030ae:	c9                   	leave  
  8030af:	c3                   	ret    

008030b0 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8030b0:	55                   	push   %ebp
  8030b1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8030b3:	6a 00                	push   $0x0
  8030b5:	6a 00                	push   $0x0
  8030b7:	6a 00                	push   $0x0
  8030b9:	ff 75 0c             	pushl  0xc(%ebp)
  8030bc:	ff 75 08             	pushl  0x8(%ebp)
  8030bf:	6a 0b                	push   $0xb
  8030c1:	e8 e6 fe ff ff       	call   802fac <syscall>
  8030c6:	83 c4 18             	add    $0x18,%esp
}
  8030c9:	c9                   	leave  
  8030ca:	c3                   	ret    

008030cb <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8030cb:	55                   	push   %ebp
  8030cc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8030ce:	6a 00                	push   $0x0
  8030d0:	6a 00                	push   $0x0
  8030d2:	6a 00                	push   $0x0
  8030d4:	6a 00                	push   $0x0
  8030d6:	6a 00                	push   $0x0
  8030d8:	6a 0c                	push   $0xc
  8030da:	e8 cd fe ff ff       	call   802fac <syscall>
  8030df:	83 c4 18             	add    $0x18,%esp
}
  8030e2:	c9                   	leave  
  8030e3:	c3                   	ret    

008030e4 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8030e4:	55                   	push   %ebp
  8030e5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8030e7:	6a 00                	push   $0x0
  8030e9:	6a 00                	push   $0x0
  8030eb:	6a 00                	push   $0x0
  8030ed:	6a 00                	push   $0x0
  8030ef:	6a 00                	push   $0x0
  8030f1:	6a 0d                	push   $0xd
  8030f3:	e8 b4 fe ff ff       	call   802fac <syscall>
  8030f8:	83 c4 18             	add    $0x18,%esp
}
  8030fb:	c9                   	leave  
  8030fc:	c3                   	ret    

008030fd <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8030fd:	55                   	push   %ebp
  8030fe:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  803100:	6a 00                	push   $0x0
  803102:	6a 00                	push   $0x0
  803104:	6a 00                	push   $0x0
  803106:	6a 00                	push   $0x0
  803108:	6a 00                	push   $0x0
  80310a:	6a 0e                	push   $0xe
  80310c:	e8 9b fe ff ff       	call   802fac <syscall>
  803111:	83 c4 18             	add    $0x18,%esp
}
  803114:	c9                   	leave  
  803115:	c3                   	ret    

00803116 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  803116:	55                   	push   %ebp
  803117:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  803119:	6a 00                	push   $0x0
  80311b:	6a 00                	push   $0x0
  80311d:	6a 00                	push   $0x0
  80311f:	6a 00                	push   $0x0
  803121:	6a 00                	push   $0x0
  803123:	6a 0f                	push   $0xf
  803125:	e8 82 fe ff ff       	call   802fac <syscall>
  80312a:	83 c4 18             	add    $0x18,%esp
}
  80312d:	c9                   	leave  
  80312e:	c3                   	ret    

0080312f <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  80312f:	55                   	push   %ebp
  803130:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  803132:	6a 00                	push   $0x0
  803134:	6a 00                	push   $0x0
  803136:	6a 00                	push   $0x0
  803138:	6a 00                	push   $0x0
  80313a:	ff 75 08             	pushl  0x8(%ebp)
  80313d:	6a 10                	push   $0x10
  80313f:	e8 68 fe ff ff       	call   802fac <syscall>
  803144:	83 c4 18             	add    $0x18,%esp
}
  803147:	c9                   	leave  
  803148:	c3                   	ret    

00803149 <sys_scarce_memory>:

void sys_scarce_memory()
{
  803149:	55                   	push   %ebp
  80314a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  80314c:	6a 00                	push   $0x0
  80314e:	6a 00                	push   $0x0
  803150:	6a 00                	push   $0x0
  803152:	6a 00                	push   $0x0
  803154:	6a 00                	push   $0x0
  803156:	6a 11                	push   $0x11
  803158:	e8 4f fe ff ff       	call   802fac <syscall>
  80315d:	83 c4 18             	add    $0x18,%esp
}
  803160:	90                   	nop
  803161:	c9                   	leave  
  803162:	c3                   	ret    

00803163 <sys_cputc>:

void
sys_cputc(const char c)
{
  803163:	55                   	push   %ebp
  803164:	89 e5                	mov    %esp,%ebp
  803166:	83 ec 04             	sub    $0x4,%esp
  803169:	8b 45 08             	mov    0x8(%ebp),%eax
  80316c:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  80316f:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  803173:	6a 00                	push   $0x0
  803175:	6a 00                	push   $0x0
  803177:	6a 00                	push   $0x0
  803179:	6a 00                	push   $0x0
  80317b:	50                   	push   %eax
  80317c:	6a 01                	push   $0x1
  80317e:	e8 29 fe ff ff       	call   802fac <syscall>
  803183:	83 c4 18             	add    $0x18,%esp
}
  803186:	90                   	nop
  803187:	c9                   	leave  
  803188:	c3                   	ret    

00803189 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  803189:	55                   	push   %ebp
  80318a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  80318c:	6a 00                	push   $0x0
  80318e:	6a 00                	push   $0x0
  803190:	6a 00                	push   $0x0
  803192:	6a 00                	push   $0x0
  803194:	6a 00                	push   $0x0
  803196:	6a 14                	push   $0x14
  803198:	e8 0f fe ff ff       	call   802fac <syscall>
  80319d:	83 c4 18             	add    $0x18,%esp
}
  8031a0:	90                   	nop
  8031a1:	c9                   	leave  
  8031a2:	c3                   	ret    

008031a3 <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8031a3:	55                   	push   %ebp
  8031a4:	89 e5                	mov    %esp,%ebp
  8031a6:	83 ec 04             	sub    $0x4,%esp
  8031a9:	8b 45 10             	mov    0x10(%ebp),%eax
  8031ac:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8031af:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8031b2:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8031b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8031b9:	6a 00                	push   $0x0
  8031bb:	51                   	push   %ecx
  8031bc:	52                   	push   %edx
  8031bd:	ff 75 0c             	pushl  0xc(%ebp)
  8031c0:	50                   	push   %eax
  8031c1:	6a 15                	push   $0x15
  8031c3:	e8 e4 fd ff ff       	call   802fac <syscall>
  8031c8:	83 c4 18             	add    $0x18,%esp
}
  8031cb:	c9                   	leave  
  8031cc:	c3                   	ret    

008031cd <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  8031cd:	55                   	push   %ebp
  8031ce:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8031d0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8031d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8031d6:	6a 00                	push   $0x0
  8031d8:	6a 00                	push   $0x0
  8031da:	6a 00                	push   $0x0
  8031dc:	52                   	push   %edx
  8031dd:	50                   	push   %eax
  8031de:	6a 16                	push   $0x16
  8031e0:	e8 c7 fd ff ff       	call   802fac <syscall>
  8031e5:	83 c4 18             	add    $0x18,%esp
}
  8031e8:	c9                   	leave  
  8031e9:	c3                   	ret    

008031ea <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  8031ea:	55                   	push   %ebp
  8031eb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8031ed:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8031f0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8031f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8031f6:	6a 00                	push   $0x0
  8031f8:	6a 00                	push   $0x0
  8031fa:	51                   	push   %ecx
  8031fb:	52                   	push   %edx
  8031fc:	50                   	push   %eax
  8031fd:	6a 17                	push   $0x17
  8031ff:	e8 a8 fd ff ff       	call   802fac <syscall>
  803204:	83 c4 18             	add    $0x18,%esp
}
  803207:	c9                   	leave  
  803208:	c3                   	ret    

00803209 <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  803209:	55                   	push   %ebp
  80320a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  80320c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80320f:	8b 45 08             	mov    0x8(%ebp),%eax
  803212:	6a 00                	push   $0x0
  803214:	6a 00                	push   $0x0
  803216:	6a 00                	push   $0x0
  803218:	52                   	push   %edx
  803219:	50                   	push   %eax
  80321a:	6a 18                	push   $0x18
  80321c:	e8 8b fd ff ff       	call   802fac <syscall>
  803221:	83 c4 18             	add    $0x18,%esp
}
  803224:	c9                   	leave  
  803225:	c3                   	ret    

00803226 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  803226:	55                   	push   %ebp
  803227:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  803229:	8b 45 08             	mov    0x8(%ebp),%eax
  80322c:	6a 00                	push   $0x0
  80322e:	ff 75 14             	pushl  0x14(%ebp)
  803231:	ff 75 10             	pushl  0x10(%ebp)
  803234:	ff 75 0c             	pushl  0xc(%ebp)
  803237:	50                   	push   %eax
  803238:	6a 19                	push   $0x19
  80323a:	e8 6d fd ff ff       	call   802fac <syscall>
  80323f:	83 c4 18             	add    $0x18,%esp
}
  803242:	c9                   	leave  
  803243:	c3                   	ret    

00803244 <sys_run_env>:

void sys_run_env(int32 envId)
{
  803244:	55                   	push   %ebp
  803245:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  803247:	8b 45 08             	mov    0x8(%ebp),%eax
  80324a:	6a 00                	push   $0x0
  80324c:	6a 00                	push   $0x0
  80324e:	6a 00                	push   $0x0
  803250:	6a 00                	push   $0x0
  803252:	50                   	push   %eax
  803253:	6a 1a                	push   $0x1a
  803255:	e8 52 fd ff ff       	call   802fac <syscall>
  80325a:	83 c4 18             	add    $0x18,%esp
}
  80325d:	90                   	nop
  80325e:	c9                   	leave  
  80325f:	c3                   	ret    

00803260 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  803260:	55                   	push   %ebp
  803261:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  803263:	8b 45 08             	mov    0x8(%ebp),%eax
  803266:	6a 00                	push   $0x0
  803268:	6a 00                	push   $0x0
  80326a:	6a 00                	push   $0x0
  80326c:	6a 00                	push   $0x0
  80326e:	50                   	push   %eax
  80326f:	6a 1b                	push   $0x1b
  803271:	e8 36 fd ff ff       	call   802fac <syscall>
  803276:	83 c4 18             	add    $0x18,%esp
}
  803279:	c9                   	leave  
  80327a:	c3                   	ret    

0080327b <sys_getenvid>:

int32 sys_getenvid(void)
{
  80327b:	55                   	push   %ebp
  80327c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  80327e:	6a 00                	push   $0x0
  803280:	6a 00                	push   $0x0
  803282:	6a 00                	push   $0x0
  803284:	6a 00                	push   $0x0
  803286:	6a 00                	push   $0x0
  803288:	6a 05                	push   $0x5
  80328a:	e8 1d fd ff ff       	call   802fac <syscall>
  80328f:	83 c4 18             	add    $0x18,%esp
}
  803292:	c9                   	leave  
  803293:	c3                   	ret    

00803294 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  803294:	55                   	push   %ebp
  803295:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  803297:	6a 00                	push   $0x0
  803299:	6a 00                	push   $0x0
  80329b:	6a 00                	push   $0x0
  80329d:	6a 00                	push   $0x0
  80329f:	6a 00                	push   $0x0
  8032a1:	6a 06                	push   $0x6
  8032a3:	e8 04 fd ff ff       	call   802fac <syscall>
  8032a8:	83 c4 18             	add    $0x18,%esp
}
  8032ab:	c9                   	leave  
  8032ac:	c3                   	ret    

008032ad <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8032ad:	55                   	push   %ebp
  8032ae:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8032b0:	6a 00                	push   $0x0
  8032b2:	6a 00                	push   $0x0
  8032b4:	6a 00                	push   $0x0
  8032b6:	6a 00                	push   $0x0
  8032b8:	6a 00                	push   $0x0
  8032ba:	6a 07                	push   $0x7
  8032bc:	e8 eb fc ff ff       	call   802fac <syscall>
  8032c1:	83 c4 18             	add    $0x18,%esp
}
  8032c4:	c9                   	leave  
  8032c5:	c3                   	ret    

008032c6 <sys_exit_env>:


void sys_exit_env(void)
{
  8032c6:	55                   	push   %ebp
  8032c7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  8032c9:	6a 00                	push   $0x0
  8032cb:	6a 00                	push   $0x0
  8032cd:	6a 00                	push   $0x0
  8032cf:	6a 00                	push   $0x0
  8032d1:	6a 00                	push   $0x0
  8032d3:	6a 1c                	push   $0x1c
  8032d5:	e8 d2 fc ff ff       	call   802fac <syscall>
  8032da:	83 c4 18             	add    $0x18,%esp
}
  8032dd:	90                   	nop
  8032de:	c9                   	leave  
  8032df:	c3                   	ret    

008032e0 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  8032e0:	55                   	push   %ebp
  8032e1:	89 e5                	mov    %esp,%ebp
  8032e3:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8032e6:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8032e9:	8d 50 04             	lea    0x4(%eax),%edx
  8032ec:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8032ef:	6a 00                	push   $0x0
  8032f1:	6a 00                	push   $0x0
  8032f3:	6a 00                	push   $0x0
  8032f5:	52                   	push   %edx
  8032f6:	50                   	push   %eax
  8032f7:	6a 1d                	push   $0x1d
  8032f9:	e8 ae fc ff ff       	call   802fac <syscall>
  8032fe:	83 c4 18             	add    $0x18,%esp
	return result;
  803301:	8b 4d 08             	mov    0x8(%ebp),%ecx
  803304:	8b 45 f8             	mov    -0x8(%ebp),%eax
  803307:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80330a:	89 01                	mov    %eax,(%ecx)
  80330c:	89 51 04             	mov    %edx,0x4(%ecx)
}
  80330f:	8b 45 08             	mov    0x8(%ebp),%eax
  803312:	c9                   	leave  
  803313:	c2 04 00             	ret    $0x4

00803316 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  803316:	55                   	push   %ebp
  803317:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  803319:	6a 00                	push   $0x0
  80331b:	6a 00                	push   $0x0
  80331d:	ff 75 10             	pushl  0x10(%ebp)
  803320:	ff 75 0c             	pushl  0xc(%ebp)
  803323:	ff 75 08             	pushl  0x8(%ebp)
  803326:	6a 13                	push   $0x13
  803328:	e8 7f fc ff ff       	call   802fac <syscall>
  80332d:	83 c4 18             	add    $0x18,%esp
	return ;
  803330:	90                   	nop
}
  803331:	c9                   	leave  
  803332:	c3                   	ret    

00803333 <sys_rcr2>:
uint32 sys_rcr2()
{
  803333:	55                   	push   %ebp
  803334:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  803336:	6a 00                	push   $0x0
  803338:	6a 00                	push   $0x0
  80333a:	6a 00                	push   $0x0
  80333c:	6a 00                	push   $0x0
  80333e:	6a 00                	push   $0x0
  803340:	6a 1e                	push   $0x1e
  803342:	e8 65 fc ff ff       	call   802fac <syscall>
  803347:	83 c4 18             	add    $0x18,%esp
}
  80334a:	c9                   	leave  
  80334b:	c3                   	ret    

0080334c <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  80334c:	55                   	push   %ebp
  80334d:	89 e5                	mov    %esp,%ebp
  80334f:	83 ec 04             	sub    $0x4,%esp
  803352:	8b 45 08             	mov    0x8(%ebp),%eax
  803355:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  803358:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  80335c:	6a 00                	push   $0x0
  80335e:	6a 00                	push   $0x0
  803360:	6a 00                	push   $0x0
  803362:	6a 00                	push   $0x0
  803364:	50                   	push   %eax
  803365:	6a 1f                	push   $0x1f
  803367:	e8 40 fc ff ff       	call   802fac <syscall>
  80336c:	83 c4 18             	add    $0x18,%esp
	return ;
  80336f:	90                   	nop
}
  803370:	c9                   	leave  
  803371:	c3                   	ret    

00803372 <rsttst>:
void rsttst()
{
  803372:	55                   	push   %ebp
  803373:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  803375:	6a 00                	push   $0x0
  803377:	6a 00                	push   $0x0
  803379:	6a 00                	push   $0x0
  80337b:	6a 00                	push   $0x0
  80337d:	6a 00                	push   $0x0
  80337f:	6a 21                	push   $0x21
  803381:	e8 26 fc ff ff       	call   802fac <syscall>
  803386:	83 c4 18             	add    $0x18,%esp
	return ;
  803389:	90                   	nop
}
  80338a:	c9                   	leave  
  80338b:	c3                   	ret    

0080338c <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  80338c:	55                   	push   %ebp
  80338d:	89 e5                	mov    %esp,%ebp
  80338f:	83 ec 04             	sub    $0x4,%esp
  803392:	8b 45 14             	mov    0x14(%ebp),%eax
  803395:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  803398:	8b 55 18             	mov    0x18(%ebp),%edx
  80339b:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80339f:	52                   	push   %edx
  8033a0:	50                   	push   %eax
  8033a1:	ff 75 10             	pushl  0x10(%ebp)
  8033a4:	ff 75 0c             	pushl  0xc(%ebp)
  8033a7:	ff 75 08             	pushl  0x8(%ebp)
  8033aa:	6a 20                	push   $0x20
  8033ac:	e8 fb fb ff ff       	call   802fac <syscall>
  8033b1:	83 c4 18             	add    $0x18,%esp
	return ;
  8033b4:	90                   	nop
}
  8033b5:	c9                   	leave  
  8033b6:	c3                   	ret    

008033b7 <chktst>:
void chktst(uint32 n)
{
  8033b7:	55                   	push   %ebp
  8033b8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8033ba:	6a 00                	push   $0x0
  8033bc:	6a 00                	push   $0x0
  8033be:	6a 00                	push   $0x0
  8033c0:	6a 00                	push   $0x0
  8033c2:	ff 75 08             	pushl  0x8(%ebp)
  8033c5:	6a 22                	push   $0x22
  8033c7:	e8 e0 fb ff ff       	call   802fac <syscall>
  8033cc:	83 c4 18             	add    $0x18,%esp
	return ;
  8033cf:	90                   	nop
}
  8033d0:	c9                   	leave  
  8033d1:	c3                   	ret    

008033d2 <inctst>:

void inctst()
{
  8033d2:	55                   	push   %ebp
  8033d3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8033d5:	6a 00                	push   $0x0
  8033d7:	6a 00                	push   $0x0
  8033d9:	6a 00                	push   $0x0
  8033db:	6a 00                	push   $0x0
  8033dd:	6a 00                	push   $0x0
  8033df:	6a 23                	push   $0x23
  8033e1:	e8 c6 fb ff ff       	call   802fac <syscall>
  8033e6:	83 c4 18             	add    $0x18,%esp
	return ;
  8033e9:	90                   	nop
}
  8033ea:	c9                   	leave  
  8033eb:	c3                   	ret    

008033ec <gettst>:
uint32 gettst()
{
  8033ec:	55                   	push   %ebp
  8033ed:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8033ef:	6a 00                	push   $0x0
  8033f1:	6a 00                	push   $0x0
  8033f3:	6a 00                	push   $0x0
  8033f5:	6a 00                	push   $0x0
  8033f7:	6a 00                	push   $0x0
  8033f9:	6a 24                	push   $0x24
  8033fb:	e8 ac fb ff ff       	call   802fac <syscall>
  803400:	83 c4 18             	add    $0x18,%esp
}
  803403:	c9                   	leave  
  803404:	c3                   	ret    

00803405 <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  803405:	55                   	push   %ebp
  803406:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  803408:	6a 00                	push   $0x0
  80340a:	6a 00                	push   $0x0
  80340c:	6a 00                	push   $0x0
  80340e:	6a 00                	push   $0x0
  803410:	6a 00                	push   $0x0
  803412:	6a 25                	push   $0x25
  803414:	e8 93 fb ff ff       	call   802fac <syscall>
  803419:	83 c4 18             	add    $0x18,%esp
  80341c:	a3 00 fb 87 00       	mov    %eax,0x87fb00
	return uheapPlaceStrategy ;
  803421:	a1 00 fb 87 00       	mov    0x87fb00,%eax
}
  803426:	c9                   	leave  
  803427:	c3                   	ret    

00803428 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  803428:	55                   	push   %ebp
  803429:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  80342b:	8b 45 08             	mov    0x8(%ebp),%eax
  80342e:	a3 00 fb 87 00       	mov    %eax,0x87fb00
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  803433:	6a 00                	push   $0x0
  803435:	6a 00                	push   $0x0
  803437:	6a 00                	push   $0x0
  803439:	6a 00                	push   $0x0
  80343b:	ff 75 08             	pushl  0x8(%ebp)
  80343e:	6a 26                	push   $0x26
  803440:	e8 67 fb ff ff       	call   802fac <syscall>
  803445:	83 c4 18             	add    $0x18,%esp
	return ;
  803448:	90                   	nop
}
  803449:	c9                   	leave  
  80344a:	c3                   	ret    

0080344b <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  80344b:	55                   	push   %ebp
  80344c:	89 e5                	mov    %esp,%ebp
  80344e:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  80344f:	8b 5d 14             	mov    0x14(%ebp),%ebx
  803452:	8b 4d 10             	mov    0x10(%ebp),%ecx
  803455:	8b 55 0c             	mov    0xc(%ebp),%edx
  803458:	8b 45 08             	mov    0x8(%ebp),%eax
  80345b:	6a 00                	push   $0x0
  80345d:	53                   	push   %ebx
  80345e:	51                   	push   %ecx
  80345f:	52                   	push   %edx
  803460:	50                   	push   %eax
  803461:	6a 27                	push   $0x27
  803463:	e8 44 fb ff ff       	call   802fac <syscall>
  803468:	83 c4 18             	add    $0x18,%esp
}
  80346b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80346e:	c9                   	leave  
  80346f:	c3                   	ret    

00803470 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  803470:	55                   	push   %ebp
  803471:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  803473:	8b 55 0c             	mov    0xc(%ebp),%edx
  803476:	8b 45 08             	mov    0x8(%ebp),%eax
  803479:	6a 00                	push   $0x0
  80347b:	6a 00                	push   $0x0
  80347d:	6a 00                	push   $0x0
  80347f:	52                   	push   %edx
  803480:	50                   	push   %eax
  803481:	6a 28                	push   $0x28
  803483:	e8 24 fb ff ff       	call   802fac <syscall>
  803488:	83 c4 18             	add    $0x18,%esp
}
  80348b:	c9                   	leave  
  80348c:	c3                   	ret    

0080348d <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  80348d:	55                   	push   %ebp
  80348e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  803490:	8b 4d 14             	mov    0x14(%ebp),%ecx
  803493:	8b 55 0c             	mov    0xc(%ebp),%edx
  803496:	8b 45 08             	mov    0x8(%ebp),%eax
  803499:	6a 00                	push   $0x0
  80349b:	51                   	push   %ecx
  80349c:	ff 75 10             	pushl  0x10(%ebp)
  80349f:	52                   	push   %edx
  8034a0:	50                   	push   %eax
  8034a1:	6a 29                	push   $0x29
  8034a3:	e8 04 fb ff ff       	call   802fac <syscall>
  8034a8:	83 c4 18             	add    $0x18,%esp
}
  8034ab:	c9                   	leave  
  8034ac:	c3                   	ret    

008034ad <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8034ad:	55                   	push   %ebp
  8034ae:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8034b0:	6a 00                	push   $0x0
  8034b2:	6a 00                	push   $0x0
  8034b4:	ff 75 10             	pushl  0x10(%ebp)
  8034b7:	ff 75 0c             	pushl  0xc(%ebp)
  8034ba:	ff 75 08             	pushl  0x8(%ebp)
  8034bd:	6a 12                	push   $0x12
  8034bf:	e8 e8 fa ff ff       	call   802fac <syscall>
  8034c4:	83 c4 18             	add    $0x18,%esp
	return ;
  8034c7:	90                   	nop
}
  8034c8:	c9                   	leave  
  8034c9:	c3                   	ret    

008034ca <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  8034ca:	55                   	push   %ebp
  8034cb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  8034cd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8034d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8034d3:	6a 00                	push   $0x0
  8034d5:	6a 00                	push   $0x0
  8034d7:	6a 00                	push   $0x0
  8034d9:	52                   	push   %edx
  8034da:	50                   	push   %eax
  8034db:	6a 2a                	push   $0x2a
  8034dd:	e8 ca fa ff ff       	call   802fac <syscall>
  8034e2:	83 c4 18             	add    $0x18,%esp
	return;
  8034e5:	90                   	nop
}
  8034e6:	c9                   	leave  
  8034e7:	c3                   	ret    

008034e8 <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  8034e8:	55                   	push   %ebp
  8034e9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  8034eb:	6a 00                	push   $0x0
  8034ed:	6a 00                	push   $0x0
  8034ef:	6a 00                	push   $0x0
  8034f1:	6a 00                	push   $0x0
  8034f3:	6a 00                	push   $0x0
  8034f5:	6a 2b                	push   $0x2b
  8034f7:	e8 b0 fa ff ff       	call   802fac <syscall>
  8034fc:	83 c4 18             	add    $0x18,%esp
}
  8034ff:	c9                   	leave  
  803500:	c3                   	ret    

00803501 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  803501:	55                   	push   %ebp
  803502:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  803504:	6a 00                	push   $0x0
  803506:	6a 00                	push   $0x0
  803508:	6a 00                	push   $0x0
  80350a:	ff 75 0c             	pushl  0xc(%ebp)
  80350d:	ff 75 08             	pushl  0x8(%ebp)
  803510:	6a 2d                	push   $0x2d
  803512:	e8 95 fa ff ff       	call   802fac <syscall>
  803517:	83 c4 18             	add    $0x18,%esp
	return;
  80351a:	90                   	nop
}
  80351b:	c9                   	leave  
  80351c:	c3                   	ret    

0080351d <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  80351d:	55                   	push   %ebp
  80351e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  803520:	6a 00                	push   $0x0
  803522:	6a 00                	push   $0x0
  803524:	6a 00                	push   $0x0
  803526:	ff 75 0c             	pushl  0xc(%ebp)
  803529:	ff 75 08             	pushl  0x8(%ebp)
  80352c:	6a 2c                	push   $0x2c
  80352e:	e8 79 fa ff ff       	call   802fac <syscall>
  803533:	83 c4 18             	add    $0x18,%esp
	return ;
  803536:	90                   	nop
}
  803537:	c9                   	leave  
  803538:	c3                   	ret    

00803539 <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  803539:	55                   	push   %ebp
  80353a:	89 e5                	mov    %esp,%ebp
	//TODO: [PROJECT'25.IM#4] CPU SCHEDULING - #1 System Calls - Add suitable code here
	//Your code is here
	//Comment the following line
	//panic("sys_env_set_priority() is not implemented yet...!!");
	syscall(SYS_env_set_priority, envID, priority, 0, 0, 0);
  80353c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80353f:	8b 45 08             	mov    0x8(%ebp),%eax
  803542:	6a 00                	push   $0x0
  803544:	6a 00                	push   $0x0
  803546:	6a 00                	push   $0x0
  803548:	52                   	push   %edx
  803549:	50                   	push   %eax
  80354a:	6a 2e                	push   $0x2e
  80354c:	e8 5b fa ff ff       	call   802fac <syscall>
  803551:	83 c4 18             	add    $0x18,%esp
	    return;
  803554:	90                   	nop
}
  803555:	c9                   	leave  
  803556:	c3                   	ret    

00803557 <to_page_va>:
//==================================================================================//
//==================================
// [1] GET PAGE VA:
//==================================
__inline__ uint32 to_page_va(struct PageInfoElement *ptrPageInfo)
{
  803557:	55                   	push   %ebp
  803558:	89 e5                	mov    %esp,%ebp
  80355a:	83 ec 10             	sub    $0x10,%esp
	//Get start VA of the page from the corresponding Page Info pointer
	int idxInPageInfoArr = (ptrPageInfo - pageBlockInfoArr);
  80355d:	8b 45 08             	mov    0x8(%ebp),%eax
  803560:	ba 00 7b 86 00       	mov    $0x867b00,%edx
  803565:	29 d0                	sub    %edx,%eax
  803567:	c1 f8 02             	sar    $0x2,%eax
  80356a:	89 c2                	mov    %eax,%edx
  80356c:	89 d0                	mov    %edx,%eax
  80356e:	c1 e0 02             	shl    $0x2,%eax
  803571:	01 d0                	add    %edx,%eax
  803573:	c1 e0 02             	shl    $0x2,%eax
  803576:	01 d0                	add    %edx,%eax
  803578:	c1 e0 02             	shl    $0x2,%eax
  80357b:	01 d0                	add    %edx,%eax
  80357d:	89 c1                	mov    %eax,%ecx
  80357f:	c1 e1 08             	shl    $0x8,%ecx
  803582:	01 c8                	add    %ecx,%eax
  803584:	89 c1                	mov    %eax,%ecx
  803586:	c1 e1 10             	shl    $0x10,%ecx
  803589:	01 c8                	add    %ecx,%eax
  80358b:	01 c0                	add    %eax,%eax
  80358d:	01 d0                	add    %edx,%eax
  80358f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return dynAllocStart + (idxInPageInfoArr << PGSHIFT);
  803592:	8b 45 fc             	mov    -0x4(%ebp),%eax
  803595:	c1 e0 0c             	shl    $0xc,%eax
  803598:	89 c2                	mov    %eax,%edx
  80359a:	a1 04 fb 87 00       	mov    0x87fb04,%eax
  80359f:	01 d0                	add    %edx,%eax
}
  8035a1:	c9                   	leave  
  8035a2:	c3                   	ret    

008035a3 <log2>:

//==================================================================================//
//============================ REQUIRED FUNCTIONS ==================================//
//==================================================================================//
__inline__ int log2(uint32 n)
	{
  8035a3:	55                   	push   %ebp
  8035a4:	89 e5                	mov    %esp,%ebp
  8035a6:	83 ec 10             	sub    $0x10,%esp
		int result = 0;
  8035a9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
		while( n > 1){
  8035b0:	eb 06                	jmp    8035b8 <log2+0x15>
			n >>=1;
  8035b2:	d1 6d 08             	shrl   0x8(%ebp)
			result++;
  8035b5:	ff 45 fc             	incl   -0x4(%ebp)
//============================ REQUIRED FUNCTIONS ==================================//
//==================================================================================//
__inline__ int log2(uint32 n)
	{
		int result = 0;
		while( n > 1){
  8035b8:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
  8035bc:	77 f4                	ja     8035b2 <log2+0xf>
			n >>=1;
			result++;
		}
		return result;
  8035be:	8b 45 fc             	mov    -0x4(%ebp),%eax
	}
  8035c1:	c9                   	leave  
  8035c2:	c3                   	ret    

008035c3 <initialize_dynamic_allocator>:
//==================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================
bool is_initialized = 0;
void initialize_dynamic_allocator(uint32 daStart, uint32 daEnd)
{
  8035c3:	55                   	push   %ebp
  8035c4:	89 e5                	mov    %esp,%ebp
  8035c6:	83 ec 18             	sub    $0x18,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(daEnd <= daStart + DYN_ALLOC_MAX_SIZE);
  8035c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8035cc:	05 00 00 00 02       	add    $0x2000000,%eax
  8035d1:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8035d4:	73 16                	jae    8035ec <initialize_dynamic_allocator+0x29>
  8035d6:	68 18 4d 80 00       	push   $0x804d18
  8035db:	68 3e 4d 80 00       	push   $0x804d3e
  8035e0:	6a 2d                	push   $0x2d
  8035e2:	68 53 4d 80 00       	push   $0x804d53
  8035e7:	e8 4d 0b 00 00       	call   804139 <_panic>
		is_initialized = 1;
  8035ec:	c7 05 24 60 80 00 01 	movl   $0x1,0x806024
  8035f3:	00 00 00 
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #1 initialize_dynamic_allocator
	//Your code is here


	dynAllocStart = daStart;
  8035f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8035f9:	a3 04 fb 87 00       	mov    %eax,0x87fb04
	dynAllocEnd= daEnd;
  8035fe:	8b 45 0c             	mov    0xc(%ebp),%eax
  803601:	a3 40 60 80 00       	mov    %eax,0x806040
	int numOfPages = (dynAllocEnd - dynAllocStart)/PAGE_SIZE;
  803606:	8b 15 40 60 80 00    	mov    0x806040,%edx
  80360c:	a1 04 fb 87 00       	mov    0x87fb04,%eax
  803611:	29 c2                	sub    %eax,%edx
  803613:	89 d0                	mov    %edx,%eax
  803615:	c1 e8 0c             	shr    $0xc,%eax
  803618:	89 45 e8             	mov    %eax,-0x18(%ebp)


	for(int i=0; i< numOfPages; i++){
  80361b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  803622:	eb 2f                	jmp    803653 <initialize_dynamic_allocator+0x90>
	    pageBlockInfoArr[i].block_size=0;
  803624:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803627:	89 d0                	mov    %edx,%eax
  803629:	01 c0                	add    %eax,%eax
  80362b:	01 d0                	add    %edx,%eax
  80362d:	c1 e0 02             	shl    $0x2,%eax
  803630:	05 08 7b 86 00       	add    $0x867b08,%eax
  803635:	66 c7 00 00 00       	movw   $0x0,(%eax)
	    pageBlockInfoArr[i].num_of_free_blocks=0;
  80363a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80363d:	89 d0                	mov    %edx,%eax
  80363f:	01 c0                	add    %eax,%eax
  803641:	01 d0                	add    %edx,%eax
  803643:	c1 e0 02             	shl    $0x2,%eax
  803646:	05 0a 7b 86 00       	add    $0x867b0a,%eax
  80364b:	66 c7 00 00 00       	movw   $0x0,(%eax)
	dynAllocStart = daStart;
	dynAllocEnd= daEnd;
	int numOfPages = (dynAllocEnd - dynAllocStart)/PAGE_SIZE;


	for(int i=0; i< numOfPages; i++){
  803650:	ff 45 f4             	incl   -0xc(%ebp)
  803653:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803656:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803659:	7c c9                	jl     803624 <initialize_dynamic_allocator+0x61>
	    pageBlockInfoArr[i].block_size=0;
	    pageBlockInfoArr[i].num_of_free_blocks=0;
	}


	LIST_INIT(&freePagesList);
  80365b:	c7 05 e4 7a 86 00 00 	movl   $0x0,0x867ae4
  803662:	00 00 00 
  803665:	c7 05 e8 7a 86 00 00 	movl   $0x0,0x867ae8
  80366c:	00 00 00 
  80366f:	c7 05 f0 7a 86 00 00 	movl   $0x0,0x867af0
  803676:	00 00 00 
	for(int i=0; i<numOfPages; i++){
  803679:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  803680:	e9 9c 00 00 00       	jmp    803721 <initialize_dynamic_allocator+0x15e>
		LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
  803685:	8b 15 e8 7a 86 00    	mov    0x867ae8,%edx
  80368b:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80368e:	89 c8                	mov    %ecx,%eax
  803690:	01 c0                	add    %eax,%eax
  803692:	01 c8                	add    %ecx,%eax
  803694:	c1 e0 02             	shl    $0x2,%eax
  803697:	05 04 7b 86 00       	add    $0x867b04,%eax
  80369c:	89 10                	mov    %edx,(%eax)
  80369e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8036a1:	89 d0                	mov    %edx,%eax
  8036a3:	01 c0                	add    %eax,%eax
  8036a5:	01 d0                	add    %edx,%eax
  8036a7:	c1 e0 02             	shl    $0x2,%eax
  8036aa:	05 04 7b 86 00       	add    $0x867b04,%eax
  8036af:	8b 00                	mov    (%eax),%eax
  8036b1:	85 c0                	test   %eax,%eax
  8036b3:	74 1b                	je     8036d0 <initialize_dynamic_allocator+0x10d>
  8036b5:	8b 15 e8 7a 86 00    	mov    0x867ae8,%edx
  8036bb:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8036be:	89 c8                	mov    %ecx,%eax
  8036c0:	01 c0                	add    %eax,%eax
  8036c2:	01 c8                	add    %ecx,%eax
  8036c4:	c1 e0 02             	shl    $0x2,%eax
  8036c7:	05 00 7b 86 00       	add    $0x867b00,%eax
  8036cc:	89 02                	mov    %eax,(%edx)
  8036ce:	eb 16                	jmp    8036e6 <initialize_dynamic_allocator+0x123>
  8036d0:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8036d3:	89 d0                	mov    %edx,%eax
  8036d5:	01 c0                	add    %eax,%eax
  8036d7:	01 d0                	add    %edx,%eax
  8036d9:	c1 e0 02             	shl    $0x2,%eax
  8036dc:	05 00 7b 86 00       	add    $0x867b00,%eax
  8036e1:	a3 e4 7a 86 00       	mov    %eax,0x867ae4
  8036e6:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8036e9:	89 d0                	mov    %edx,%eax
  8036eb:	01 c0                	add    %eax,%eax
  8036ed:	01 d0                	add    %edx,%eax
  8036ef:	c1 e0 02             	shl    $0x2,%eax
  8036f2:	05 00 7b 86 00       	add    $0x867b00,%eax
  8036f7:	a3 e8 7a 86 00       	mov    %eax,0x867ae8
  8036fc:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8036ff:	89 d0                	mov    %edx,%eax
  803701:	01 c0                	add    %eax,%eax
  803703:	01 d0                	add    %edx,%eax
  803705:	c1 e0 02             	shl    $0x2,%eax
  803708:	05 00 7b 86 00       	add    $0x867b00,%eax
  80370d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803713:	a1 f0 7a 86 00       	mov    0x867af0,%eax
  803718:	40                   	inc    %eax
  803719:	a3 f0 7a 86 00       	mov    %eax,0x867af0
	    pageBlockInfoArr[i].num_of_free_blocks=0;
	}


	LIST_INIT(&freePagesList);
	for(int i=0; i<numOfPages; i++){
  80371e:	ff 45 f0             	incl   -0x10(%ebp)
  803721:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803724:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803727:	0f 8c 58 ff ff ff    	jl     803685 <initialize_dynamic_allocator+0xc2>
		LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
	}



	for (int i = 0; i < LOG2_MAX_SIZE - LOG2_MIN_SIZE + 1; i++) {
  80372d:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  803734:	eb 36                	jmp    80376c <initialize_dynamic_allocator+0x1a9>
	    LIST_INIT(&freeBlockLists[i]);
  803736:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803739:	c1 e0 04             	shl    $0x4,%eax
  80373c:	05 20 fb 87 00       	add    $0x87fb20,%eax
  803741:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803747:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80374a:	c1 e0 04             	shl    $0x4,%eax
  80374d:	05 24 fb 87 00       	add    $0x87fb24,%eax
  803752:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803758:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80375b:	c1 e0 04             	shl    $0x4,%eax
  80375e:	05 2c fb 87 00       	add    $0x87fb2c,%eax
  803763:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
	}



	for (int i = 0; i < LOG2_MAX_SIZE - LOG2_MIN_SIZE + 1; i++) {
  803769:	ff 45 ec             	incl   -0x14(%ebp)
  80376c:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  803770:	7e c4                	jle    803736 <initialize_dynamic_allocator+0x173>


	//Comment the following line
	//panic("initialize_dynamic_allocator() Not implemented yet");

}
  803772:	90                   	nop
  803773:	c9                   	leave  
  803774:	c3                   	ret    

00803775 <get_block_size>:
// [2] GET BLOCK SIZE:
//===========================


__inline__ uint32 get_block_size(void *va)
{
  803775:	55                   	push   %ebp
  803776:	89 e5                	mov    %esp,%ebp
  803778:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #2 get_block_size
	//Your code is here

	uint32 page_index = ((uint32)va - dynAllocStart)/ PAGE_SIZE;
  80377b:	8b 55 08             	mov    0x8(%ebp),%edx
  80377e:	a1 04 fb 87 00       	mov    0x87fb04,%eax
  803783:	29 c2                	sub    %eax,%edx
  803785:	89 d0                	mov    %edx,%eax
  803787:	c1 e8 0c             	shr    $0xc,%eax
  80378a:	89 45 fc             	mov    %eax,-0x4(%ebp)
    return pageBlockInfoArr[page_index].block_size;
  80378d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  803790:	89 d0                	mov    %edx,%eax
  803792:	01 c0                	add    %eax,%eax
  803794:	01 d0                	add    %edx,%eax
  803796:	c1 e0 02             	shl    $0x2,%eax
  803799:	05 08 7b 86 00       	add    $0x867b08,%eax
  80379e:	8b 00                	mov    (%eax),%eax
  8037a0:	0f b7 c0             	movzwl %ax,%eax
	//Comment the following line
	//panic("get_block_size() Not implemented yet");
}
  8037a3:	c9                   	leave  
  8037a4:	c3                   	ret    

008037a5 <alloc_block>:

//===========================
// 3) ALLOCATE BLOCK:
//===========================
void *alloc_block(uint32 size)
{
  8037a5:	55                   	push   %ebp
  8037a6:	89 e5                	mov    %esp,%ebp
  8037a8:	83 ec 48             	sub    $0x48,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(size <= DYN_ALLOC_MAX_BLOCK_SIZE);
  8037ab:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  8037b2:	76 16                	jbe    8037ca <alloc_block+0x25>
  8037b4:	68 6c 4d 80 00       	push   $0x804d6c
  8037b9:	68 3e 4d 80 00       	push   $0x804d3e
  8037be:	6a 6c                	push   $0x6c
  8037c0:	68 53 4d 80 00       	push   $0x804d53
  8037c5:	e8 6f 09 00 00       	call   804139 <_panic>
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #3 alloc_block
	//Your code is here


	if(size == 0){
  8037ca:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8037ce:	75 0a                	jne    8037da <alloc_block+0x35>
		return NULL;
  8037d0:	b8 00 00 00 00       	mov    $0x0,%eax
  8037d5:	e9 65 04 00 00       	jmp    803c3f <alloc_block+0x49a>
	}
	else if(size<=8){
  8037da:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  8037de:	77 09                	ja     8037e9 <alloc_block+0x44>
		size=8;
  8037e0:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
  8037e7:	eb 1f                	jmp    803808 <alloc_block+0x63>
	}
	else{
		uint32 reqsize=8;
  8037e9:	c7 45 f4 08 00 00 00 	movl   $0x8,-0xc(%ebp)
		while(reqsize < size){
  8037f0:	eb 08                	jmp    8037fa <alloc_block+0x55>
			reqsize*=2;
  8037f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037f5:	01 c0                	add    %eax,%eax
  8037f7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	else if(size<=8){
		size=8;
	}
	else{
		uint32 reqsize=8;
		while(reqsize < size){
  8037fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037fd:	3b 45 08             	cmp    0x8(%ebp),%eax
  803800:	72 f0                	jb     8037f2 <alloc_block+0x4d>
			reqsize*=2;
		}
		size= reqsize;
  803802:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803805:	89 45 08             	mov    %eax,0x8(%ebp)
	}

	int list_index = log2(size)- LOG2_MIN_SIZE;
  803808:	83 ec 0c             	sub    $0xc,%esp
  80380b:	ff 75 08             	pushl  0x8(%ebp)
  80380e:	e8 90 fd ff ff       	call   8035a3 <log2>
  803813:	83 c4 10             	add    $0x10,%esp
  803816:	83 e8 03             	sub    $0x3,%eax
  803819:	89 45 e8             	mov    %eax,-0x18(%ebp)

	if(!LIST_EMPTY(&freeBlockLists[list_index])){
  80381c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80381f:	c1 e0 04             	shl    $0x4,%eax
  803822:	05 20 fb 87 00       	add    $0x87fb20,%eax
  803827:	8b 00                	mov    (%eax),%eax
  803829:	85 c0                	test   %eax,%eax
  80382b:	0f 84 fb 00 00 00    	je     80392c <alloc_block+0x187>
		struct BlockElement *block = LIST_FIRST(&freeBlockLists[list_index]);
  803831:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803834:	c1 e0 04             	shl    $0x4,%eax
  803837:	05 20 fb 87 00       	add    $0x87fb20,%eax
  80383c:	8b 00                	mov    (%eax),%eax
  80383e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		LIST_REMOVE(&freeBlockLists[list_index], block);
  803841:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803845:	75 17                	jne    80385e <alloc_block+0xb9>
  803847:	83 ec 04             	sub    $0x4,%esp
  80384a:	68 8d 4d 80 00       	push   $0x804d8d
  80384f:	68 86 00 00 00       	push   $0x86
  803854:	68 53 4d 80 00       	push   $0x804d53
  803859:	e8 db 08 00 00       	call   804139 <_panic>
  80385e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803861:	8b 00                	mov    (%eax),%eax
  803863:	85 c0                	test   %eax,%eax
  803865:	74 10                	je     803877 <alloc_block+0xd2>
  803867:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80386a:	8b 00                	mov    (%eax),%eax
  80386c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80386f:	8b 52 04             	mov    0x4(%edx),%edx
  803872:	89 50 04             	mov    %edx,0x4(%eax)
  803875:	eb 14                	jmp    80388b <alloc_block+0xe6>
  803877:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80387a:	8b 40 04             	mov    0x4(%eax),%eax
  80387d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803880:	c1 e2 04             	shl    $0x4,%edx
  803883:	81 c2 24 fb 87 00    	add    $0x87fb24,%edx
  803889:	89 02                	mov    %eax,(%edx)
  80388b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80388e:	8b 40 04             	mov    0x4(%eax),%eax
  803891:	85 c0                	test   %eax,%eax
  803893:	74 0f                	je     8038a4 <alloc_block+0xff>
  803895:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803898:	8b 40 04             	mov    0x4(%eax),%eax
  80389b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80389e:	8b 12                	mov    (%edx),%edx
  8038a0:	89 10                	mov    %edx,(%eax)
  8038a2:	eb 13                	jmp    8038b7 <alloc_block+0x112>
  8038a4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038a7:	8b 00                	mov    (%eax),%eax
  8038a9:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8038ac:	c1 e2 04             	shl    $0x4,%edx
  8038af:	81 c2 20 fb 87 00    	add    $0x87fb20,%edx
  8038b5:	89 02                	mov    %eax,(%edx)
  8038b7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038ba:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8038c0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038c3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8038ca:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8038cd:	c1 e0 04             	shl    $0x4,%eax
  8038d0:	05 2c fb 87 00       	add    $0x87fb2c,%eax
  8038d5:	8b 00                	mov    (%eax),%eax
  8038d7:	8d 50 ff             	lea    -0x1(%eax),%edx
  8038da:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8038dd:	c1 e0 04             	shl    $0x4,%eax
  8038e0:	05 2c fb 87 00       	add    $0x87fb2c,%eax
  8038e5:	89 10                	mov    %edx,(%eax)
		uint32 page_index = ((uint32)block - dynAllocStart)/ PAGE_SIZE;
  8038e7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8038ea:	a1 04 fb 87 00       	mov    0x87fb04,%eax
  8038ef:	29 c2                	sub    %eax,%edx
  8038f1:	89 d0                	mov    %edx,%eax
  8038f3:	c1 e8 0c             	shr    $0xc,%eax
  8038f6:	89 45 e0             	mov    %eax,-0x20(%ebp)
		pageBlockInfoArr[page_index].num_of_free_blocks--;
  8038f9:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8038fc:	89 d0                	mov    %edx,%eax
  8038fe:	01 c0                	add    %eax,%eax
  803900:	01 d0                	add    %edx,%eax
  803902:	c1 e0 02             	shl    $0x2,%eax
  803905:	05 0a 7b 86 00       	add    $0x867b0a,%eax
  80390a:	66 8b 00             	mov    (%eax),%ax
  80390d:	8d 50 ff             	lea    -0x1(%eax),%edx
  803910:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  803913:	89 c8                	mov    %ecx,%eax
  803915:	01 c0                	add    %eax,%eax
  803917:	01 c8                	add    %ecx,%eax
  803919:	c1 e0 02             	shl    $0x2,%eax
  80391c:	05 0a 7b 86 00       	add    $0x867b0a,%eax
  803921:	66 89 10             	mov    %dx,(%eax)
		return (void*)block;
  803924:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803927:	e9 13 03 00 00       	jmp    803c3f <alloc_block+0x49a>
	}

	if(!LIST_EMPTY(&freePagesList)){
  80392c:	a1 e4 7a 86 00       	mov    0x867ae4,%eax
  803931:	85 c0                	test   %eax,%eax
  803933:	0f 84 c9 01 00 00    	je     803b02 <alloc_block+0x35d>

		struct PageInfoElement *page_info = LIST_FIRST(&freePagesList);
  803939:	a1 e4 7a 86 00       	mov    0x867ae4,%eax
  80393e:	89 45 dc             	mov    %eax,-0x24(%ebp)
		LIST_REMOVE(&freePagesList, page_info);
  803941:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803945:	75 17                	jne    80395e <alloc_block+0x1b9>
  803947:	83 ec 04             	sub    $0x4,%esp
  80394a:	68 8d 4d 80 00       	push   $0x804d8d
  80394f:	68 8f 00 00 00       	push   $0x8f
  803954:	68 53 4d 80 00       	push   $0x804d53
  803959:	e8 db 07 00 00       	call   804139 <_panic>
  80395e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803961:	8b 00                	mov    (%eax),%eax
  803963:	85 c0                	test   %eax,%eax
  803965:	74 10                	je     803977 <alloc_block+0x1d2>
  803967:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80396a:	8b 00                	mov    (%eax),%eax
  80396c:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80396f:	8b 52 04             	mov    0x4(%edx),%edx
  803972:	89 50 04             	mov    %edx,0x4(%eax)
  803975:	eb 0b                	jmp    803982 <alloc_block+0x1dd>
  803977:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80397a:	8b 40 04             	mov    0x4(%eax),%eax
  80397d:	a3 e8 7a 86 00       	mov    %eax,0x867ae8
  803982:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803985:	8b 40 04             	mov    0x4(%eax),%eax
  803988:	85 c0                	test   %eax,%eax
  80398a:	74 0f                	je     80399b <alloc_block+0x1f6>
  80398c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80398f:	8b 40 04             	mov    0x4(%eax),%eax
  803992:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803995:	8b 12                	mov    (%edx),%edx
  803997:	89 10                	mov    %edx,(%eax)
  803999:	eb 0a                	jmp    8039a5 <alloc_block+0x200>
  80399b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80399e:	8b 00                	mov    (%eax),%eax
  8039a0:	a3 e4 7a 86 00       	mov    %eax,0x867ae4
  8039a5:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8039a8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8039ae:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8039b1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8039b8:	a1 f0 7a 86 00       	mov    0x867af0,%eax
  8039bd:	48                   	dec    %eax
  8039be:	a3 f0 7a 86 00       	mov    %eax,0x867af0
		uint32 page_va = to_page_va(page_info);
  8039c3:	83 ec 0c             	sub    $0xc,%esp
  8039c6:	ff 75 dc             	pushl  -0x24(%ebp)
  8039c9:	e8 89 fb ff ff       	call   803557 <to_page_va>
  8039ce:	83 c4 10             	add    $0x10,%esp
  8039d1:	89 45 d8             	mov    %eax,-0x28(%ebp)

		uint32 page_index = (page_va - dynAllocStart)/ PAGE_SIZE;
  8039d4:	a1 04 fb 87 00       	mov    0x87fb04,%eax
  8039d9:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8039dc:	29 c2                	sub    %eax,%edx
  8039de:	89 d0                	mov    %edx,%eax
  8039e0:	c1 e8 0c             	shr    $0xc,%eax
  8039e3:	89 45 d4             	mov    %eax,-0x2c(%ebp)

		get_page((void*)page_va);
  8039e6:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8039e9:	83 ec 0c             	sub    $0xc,%esp
  8039ec:	50                   	push   %eax
  8039ed:	e8 fe dc ff ff       	call   8016f0 <get_page>
  8039f2:	83 c4 10             	add    $0x10,%esp


		pageBlockInfoArr[page_index].block_size = size;
  8039f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8039f8:	89 c2                	mov    %eax,%edx
  8039fa:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  8039fd:	89 c8                	mov    %ecx,%eax
  8039ff:	01 c0                	add    %eax,%eax
  803a01:	01 c8                	add    %ecx,%eax
  803a03:	c1 e0 02             	shl    $0x2,%eax
  803a06:	05 08 7b 86 00       	add    $0x867b08,%eax
  803a0b:	66 89 10             	mov    %dx,(%eax)
		int num_blocks = PAGE_SIZE / size ;
  803a0e:	b8 00 10 00 00       	mov    $0x1000,%eax
  803a13:	ba 00 00 00 00       	mov    $0x0,%edx
  803a18:	f7 75 08             	divl   0x8(%ebp)
  803a1b:	89 45 d0             	mov    %eax,-0x30(%ebp)
		pageBlockInfoArr[page_index].num_of_free_blocks= num_blocks - 1 ;
  803a1e:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803a21:	8d 50 ff             	lea    -0x1(%eax),%edx
  803a24:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  803a27:	89 c8                	mov    %ecx,%eax
  803a29:	01 c0                	add    %eax,%eax
  803a2b:	01 c8                	add    %ecx,%eax
  803a2d:	c1 e0 02             	shl    $0x2,%eax
  803a30:	05 0a 7b 86 00       	add    $0x867b0a,%eax
  803a35:	66 89 10             	mov    %dx,(%eax)

		for(int i=1; i< num_blocks; i++){
  803a38:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
  803a3f:	e9 aa 00 00 00       	jmp    803aee <alloc_block+0x349>
			struct BlockElement *new_block = (struct BlockElement*)(page_va + i *size);
  803a44:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803a47:	0f af 45 08          	imul   0x8(%ebp),%eax
  803a4b:	89 c2                	mov    %eax,%edx
  803a4d:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803a50:	01 d0                	add    %edx,%eax
  803a52:	89 45 cc             	mov    %eax,-0x34(%ebp)
			LIST_INSERT_TAIL(&freeBlockLists[list_index], new_block);
  803a55:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  803a59:	75 17                	jne    803a72 <alloc_block+0x2cd>
  803a5b:	83 ec 04             	sub    $0x4,%esp
  803a5e:	68 ac 4d 80 00       	push   $0x804dac
  803a63:	68 9d 00 00 00       	push   $0x9d
  803a68:	68 53 4d 80 00       	push   $0x804d53
  803a6d:	e8 c7 06 00 00       	call   804139 <_panic>
  803a72:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a75:	c1 e0 04             	shl    $0x4,%eax
  803a78:	05 24 fb 87 00       	add    $0x87fb24,%eax
  803a7d:	8b 10                	mov    (%eax),%edx
  803a7f:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803a82:	89 50 04             	mov    %edx,0x4(%eax)
  803a85:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803a88:	8b 40 04             	mov    0x4(%eax),%eax
  803a8b:	85 c0                	test   %eax,%eax
  803a8d:	74 14                	je     803aa3 <alloc_block+0x2fe>
  803a8f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a92:	c1 e0 04             	shl    $0x4,%eax
  803a95:	05 24 fb 87 00       	add    $0x87fb24,%eax
  803a9a:	8b 00                	mov    (%eax),%eax
  803a9c:	8b 55 cc             	mov    -0x34(%ebp),%edx
  803a9f:	89 10                	mov    %edx,(%eax)
  803aa1:	eb 11                	jmp    803ab4 <alloc_block+0x30f>
  803aa3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803aa6:	c1 e0 04             	shl    $0x4,%eax
  803aa9:	8d 90 20 fb 87 00    	lea    0x87fb20(%eax),%edx
  803aaf:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803ab2:	89 02                	mov    %eax,(%edx)
  803ab4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803ab7:	c1 e0 04             	shl    $0x4,%eax
  803aba:	8d 90 24 fb 87 00    	lea    0x87fb24(%eax),%edx
  803ac0:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803ac3:	89 02                	mov    %eax,(%edx)
  803ac5:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803ac8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803ace:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803ad1:	c1 e0 04             	shl    $0x4,%eax
  803ad4:	05 2c fb 87 00       	add    $0x87fb2c,%eax
  803ad9:	8b 00                	mov    (%eax),%eax
  803adb:	8d 50 01             	lea    0x1(%eax),%edx
  803ade:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803ae1:	c1 e0 04             	shl    $0x4,%eax
  803ae4:	05 2c fb 87 00       	add    $0x87fb2c,%eax
  803ae9:	89 10                	mov    %edx,(%eax)

		pageBlockInfoArr[page_index].block_size = size;
		int num_blocks = PAGE_SIZE / size ;
		pageBlockInfoArr[page_index].num_of_free_blocks= num_blocks - 1 ;

		for(int i=1; i< num_blocks; i++){
  803aeb:	ff 45 f0             	incl   -0x10(%ebp)
  803aee:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803af1:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  803af4:	0f 8c 4a ff ff ff    	jl     803a44 <alloc_block+0x29f>
			struct BlockElement *new_block = (struct BlockElement*)(page_va + i *size);
			LIST_INSERT_TAIL(&freeBlockLists[list_index], new_block);
		}
		return(void*)page_va;
  803afa:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803afd:	e9 3d 01 00 00       	jmp    803c3f <alloc_block+0x49a>
	}


	for(int i =list_index+1; i<= LOG2_MAX_SIZE - LOG2_MIN_SIZE; i++){
  803b02:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803b05:	40                   	inc    %eax
  803b06:	89 45 ec             	mov    %eax,-0x14(%ebp)
  803b09:	e9 10 01 00 00       	jmp    803c1e <alloc_block+0x479>

		if(!LIST_EMPTY(&freeBlockLists[i])){
  803b0e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803b11:	c1 e0 04             	shl    $0x4,%eax
  803b14:	05 20 fb 87 00       	add    $0x87fb20,%eax
  803b19:	8b 00                	mov    (%eax),%eax
  803b1b:	85 c0                	test   %eax,%eax
  803b1d:	0f 84 f8 00 00 00    	je     803c1b <alloc_block+0x476>

			struct BlockElement *block = LIST_FIRST(&freeBlockLists[i]);
  803b23:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803b26:	c1 e0 04             	shl    $0x4,%eax
  803b29:	05 20 fb 87 00       	add    $0x87fb20,%eax
  803b2e:	8b 00                	mov    (%eax),%eax
  803b30:	89 45 c8             	mov    %eax,-0x38(%ebp)
			LIST_REMOVE( &freeBlockLists[i], block);
  803b33:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  803b37:	75 17                	jne    803b50 <alloc_block+0x3ab>
  803b39:	83 ec 04             	sub    $0x4,%esp
  803b3c:	68 8d 4d 80 00       	push   $0x804d8d
  803b41:	68 a8 00 00 00       	push   $0xa8
  803b46:	68 53 4d 80 00       	push   $0x804d53
  803b4b:	e8 e9 05 00 00       	call   804139 <_panic>
  803b50:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803b53:	8b 00                	mov    (%eax),%eax
  803b55:	85 c0                	test   %eax,%eax
  803b57:	74 10                	je     803b69 <alloc_block+0x3c4>
  803b59:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803b5c:	8b 00                	mov    (%eax),%eax
  803b5e:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803b61:	8b 52 04             	mov    0x4(%edx),%edx
  803b64:	89 50 04             	mov    %edx,0x4(%eax)
  803b67:	eb 14                	jmp    803b7d <alloc_block+0x3d8>
  803b69:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803b6c:	8b 40 04             	mov    0x4(%eax),%eax
  803b6f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803b72:	c1 e2 04             	shl    $0x4,%edx
  803b75:	81 c2 24 fb 87 00    	add    $0x87fb24,%edx
  803b7b:	89 02                	mov    %eax,(%edx)
  803b7d:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803b80:	8b 40 04             	mov    0x4(%eax),%eax
  803b83:	85 c0                	test   %eax,%eax
  803b85:	74 0f                	je     803b96 <alloc_block+0x3f1>
  803b87:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803b8a:	8b 40 04             	mov    0x4(%eax),%eax
  803b8d:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803b90:	8b 12                	mov    (%edx),%edx
  803b92:	89 10                	mov    %edx,(%eax)
  803b94:	eb 13                	jmp    803ba9 <alloc_block+0x404>
  803b96:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803b99:	8b 00                	mov    (%eax),%eax
  803b9b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803b9e:	c1 e2 04             	shl    $0x4,%edx
  803ba1:	81 c2 20 fb 87 00    	add    $0x87fb20,%edx
  803ba7:	89 02                	mov    %eax,(%edx)
  803ba9:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803bac:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803bb2:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803bb5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803bbc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803bbf:	c1 e0 04             	shl    $0x4,%eax
  803bc2:	05 2c fb 87 00       	add    $0x87fb2c,%eax
  803bc7:	8b 00                	mov    (%eax),%eax
  803bc9:	8d 50 ff             	lea    -0x1(%eax),%edx
  803bcc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803bcf:	c1 e0 04             	shl    $0x4,%eax
  803bd2:	05 2c fb 87 00       	add    $0x87fb2c,%eax
  803bd7:	89 10                	mov    %edx,(%eax)

			uint32 page_index = ((uint32)block - dynAllocStart)/ PAGE_SIZE;
  803bd9:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803bdc:	a1 04 fb 87 00       	mov    0x87fb04,%eax
  803be1:	29 c2                	sub    %eax,%edx
  803be3:	89 d0                	mov    %edx,%eax
  803be5:	c1 e8 0c             	shr    $0xc,%eax
  803be8:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			pageBlockInfoArr[page_index].num_of_free_blocks-- ;
  803beb:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  803bee:	89 d0                	mov    %edx,%eax
  803bf0:	01 c0                	add    %eax,%eax
  803bf2:	01 d0                	add    %edx,%eax
  803bf4:	c1 e0 02             	shl    $0x2,%eax
  803bf7:	05 0a 7b 86 00       	add    $0x867b0a,%eax
  803bfc:	66 8b 00             	mov    (%eax),%ax
  803bff:	8d 50 ff             	lea    -0x1(%eax),%edx
  803c02:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  803c05:	89 c8                	mov    %ecx,%eax
  803c07:	01 c0                	add    %eax,%eax
  803c09:	01 c8                	add    %ecx,%eax
  803c0b:	c1 e0 02             	shl    $0x2,%eax
  803c0e:	05 0a 7b 86 00       	add    $0x867b0a,%eax
  803c13:	66 89 10             	mov    %dx,(%eax)

			return (void*)block;
  803c16:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803c19:	eb 24                	jmp    803c3f <alloc_block+0x49a>
		}
		return(void*)page_va;
	}


	for(int i =list_index+1; i<= LOG2_MAX_SIZE - LOG2_MIN_SIZE; i++){
  803c1b:	ff 45 ec             	incl   -0x14(%ebp)
  803c1e:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  803c22:	0f 8e e6 fe ff ff    	jle    803b0e <alloc_block+0x369>

			return (void*)block;
		}
	}

	panic("alloc_block: out of memory! ");
  803c28:	83 ec 04             	sub    $0x4,%esp
  803c2b:	68 cf 4d 80 00       	push   $0x804dcf
  803c30:	68 b1 00 00 00       	push   $0xb1
  803c35:	68 53 4d 80 00       	push   $0x804d53
  803c3a:	e8 fa 04 00 00       	call   804139 <_panic>

	//Comment the following line
	//panic("alloc_block() Not implemented yet");

	//TODO: [PROJECT'25.BONUS#1] DYNAMIC ALLOCATOR - block if no free block
}
  803c3f:	c9                   	leave  
  803c40:	c3                   	ret    

00803c41 <free_block>:

//===========================
// [4] FREE BLOCK:
//===========================
void free_block(void *va)
{
  803c41:	55                   	push   %ebp
  803c42:	89 e5                	mov    %esp,%ebp
  803c44:	83 ec 38             	sub    $0x38,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert((uint32)va >= dynAllocStart && (uint32)va < dynAllocEnd);
  803c47:	8b 55 08             	mov    0x8(%ebp),%edx
  803c4a:	a1 04 fb 87 00       	mov    0x87fb04,%eax
  803c4f:	39 c2                	cmp    %eax,%edx
  803c51:	72 0c                	jb     803c5f <free_block+0x1e>
  803c53:	8b 55 08             	mov    0x8(%ebp),%edx
  803c56:	a1 40 60 80 00       	mov    0x806040,%eax
  803c5b:	39 c2                	cmp    %eax,%edx
  803c5d:	72 19                	jb     803c78 <free_block+0x37>
  803c5f:	68 ec 4d 80 00       	push   $0x804dec
  803c64:	68 3e 4d 80 00       	push   $0x804d3e
  803c69:	68 c3 00 00 00       	push   $0xc3
  803c6e:	68 53 4d 80 00       	push   $0x804d53
  803c73:	e8 c1 04 00 00       	call   804139 <_panic>
	//==================================================================================

	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #4 free_block
	//Your code is here

	uint32 page_index=((uint32)va - dynAllocStart)/ PAGE_SIZE;
  803c78:	8b 55 08             	mov    0x8(%ebp),%edx
  803c7b:	a1 04 fb 87 00       	mov    0x87fb04,%eax
  803c80:	29 c2                	sub    %eax,%edx
  803c82:	89 d0                	mov    %edx,%eax
  803c84:	c1 e8 0c             	shr    $0xc,%eax
  803c87:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 block_size = pageBlockInfoArr[page_index].block_size;
  803c8a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803c8d:	89 d0                	mov    %edx,%eax
  803c8f:	01 c0                	add    %eax,%eax
  803c91:	01 d0                	add    %edx,%eax
  803c93:	c1 e0 02             	shl    $0x2,%eax
  803c96:	05 08 7b 86 00       	add    $0x867b08,%eax
  803c9b:	8b 00                	mov    (%eax),%eax
  803c9d:	0f b7 c0             	movzwl %ax,%eax
  803ca0:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if(block_size == 0){
  803ca3:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803ca7:	75 17                	jne    803cc0 <free_block+0x7f>
		panic("page is empty(already not allocated)");
  803ca9:	83 ec 04             	sub    $0x4,%esp
  803cac:	68 24 4e 80 00       	push   $0x804e24
  803cb1:	68 cf 00 00 00       	push   $0xcf
  803cb6:	68 53 4d 80 00       	push   $0x804d53
  803cbb:	e8 79 04 00 00       	call   804139 <_panic>
	}

	int list_index = log2(block_size) - LOG2_MIN_SIZE;
  803cc0:	83 ec 0c             	sub    $0xc,%esp
  803cc3:	ff 75 ec             	pushl  -0x14(%ebp)
  803cc6:	e8 d8 f8 ff ff       	call   8035a3 <log2>
  803ccb:	83 c4 10             	add    $0x10,%esp
  803cce:	83 e8 03             	sub    $0x3,%eax
  803cd1:	89 45 e8             	mov    %eax,-0x18(%ebp)
	// mn va l block "elta7weel mn virtual l phy hna"
	struct BlockElement *block = (struct BlockElement *)va;
  803cd4:	8b 45 08             	mov    0x8(%ebp),%eax
  803cd7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	LIST_INSERT_TAIL(&freeBlockLists[list_index], block);
  803cda:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803cde:	75 17                	jne    803cf7 <free_block+0xb6>
  803ce0:	83 ec 04             	sub    $0x4,%esp
  803ce3:	68 ac 4d 80 00       	push   $0x804dac
  803ce8:	68 d5 00 00 00       	push   $0xd5
  803ced:	68 53 4d 80 00       	push   $0x804d53
  803cf2:	e8 42 04 00 00       	call   804139 <_panic>
  803cf7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803cfa:	c1 e0 04             	shl    $0x4,%eax
  803cfd:	05 24 fb 87 00       	add    $0x87fb24,%eax
  803d02:	8b 10                	mov    (%eax),%edx
  803d04:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803d07:	89 50 04             	mov    %edx,0x4(%eax)
  803d0a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803d0d:	8b 40 04             	mov    0x4(%eax),%eax
  803d10:	85 c0                	test   %eax,%eax
  803d12:	74 14                	je     803d28 <free_block+0xe7>
  803d14:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803d17:	c1 e0 04             	shl    $0x4,%eax
  803d1a:	05 24 fb 87 00       	add    $0x87fb24,%eax
  803d1f:	8b 00                	mov    (%eax),%eax
  803d21:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803d24:	89 10                	mov    %edx,(%eax)
  803d26:	eb 11                	jmp    803d39 <free_block+0xf8>
  803d28:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803d2b:	c1 e0 04             	shl    $0x4,%eax
  803d2e:	8d 90 20 fb 87 00    	lea    0x87fb20(%eax),%edx
  803d34:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803d37:	89 02                	mov    %eax,(%edx)
  803d39:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803d3c:	c1 e0 04             	shl    $0x4,%eax
  803d3f:	8d 90 24 fb 87 00    	lea    0x87fb24(%eax),%edx
  803d45:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803d48:	89 02                	mov    %eax,(%edx)
  803d4a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803d4d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803d53:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803d56:	c1 e0 04             	shl    $0x4,%eax
  803d59:	05 2c fb 87 00       	add    $0x87fb2c,%eax
  803d5e:	8b 00                	mov    (%eax),%eax
  803d60:	8d 50 01             	lea    0x1(%eax),%edx
  803d63:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803d66:	c1 e0 04             	shl    $0x4,%eax
  803d69:	05 2c fb 87 00       	add    $0x87fb2c,%eax
  803d6e:	89 10                	mov    %edx,(%eax)
	// b3d ma wdytha fy el freeBlockLists hzwed elfree elly fy el array 1
	pageBlockInfoArr[page_index].num_of_free_blocks++;
  803d70:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803d73:	89 d0                	mov    %edx,%eax
  803d75:	01 c0                	add    %eax,%eax
  803d77:	01 d0                	add    %edx,%eax
  803d79:	c1 e0 02             	shl    $0x2,%eax
  803d7c:	05 0a 7b 86 00       	add    $0x867b0a,%eax
  803d81:	66 8b 00             	mov    (%eax),%ax
  803d84:	8d 50 01             	lea    0x1(%eax),%edx
  803d87:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  803d8a:	89 c8                	mov    %ecx,%eax
  803d8c:	01 c0                	add    %eax,%eax
  803d8e:	01 c8                	add    %ecx,%eax
  803d90:	c1 e0 02             	shl    $0x2,%eax
  803d93:	05 0a 7b 86 00       	add    $0x867b0a,%eax
  803d98:	66 89 10             	mov    %dx,(%eax)
	int blocks_number = PAGE_SIZE / block_size;
  803d9b:	b8 00 10 00 00       	mov    $0x1000,%eax
  803da0:	ba 00 00 00 00       	mov    $0x0,%edx
  803da5:	f7 75 ec             	divl   -0x14(%ebp)
  803da8:	89 45 e0             	mov    %eax,-0x20(%ebp)
	if(pageBlockInfoArr[page_index].num_of_free_blocks == blocks_number){
  803dab:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803dae:	89 d0                	mov    %edx,%eax
  803db0:	01 c0                	add    %eax,%eax
  803db2:	01 d0                	add    %edx,%eax
  803db4:	c1 e0 02             	shl    $0x2,%eax
  803db7:	05 0a 7b 86 00       	add    $0x867b0a,%eax
  803dbc:	66 8b 00             	mov    (%eax),%ax
  803dbf:	0f b7 c0             	movzwl %ax,%eax
  803dc2:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  803dc5:	0f 85 d3 01 00 00    	jne    803f9e <free_block+0x35d>
		struct BlockElement *itr = LIST_FIRST(&freeBlockLists[list_index]);
  803dcb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803dce:	c1 e0 04             	shl    $0x4,%eax
  803dd1:	05 20 fb 87 00       	add    $0x87fb20,%eax
  803dd6:	8b 00                	mov    (%eax),%eax
  803dd8:	89 45 f4             	mov    %eax,-0xc(%ebp)
		while(itr != NULL){
  803ddb:	e9 f1 00 00 00       	jmp    803ed1 <free_block+0x290>
			//lw ms7to el pointer mydy34 ->
			struct BlockElement *next = LIST_NEXT(itr);
  803de0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803de3:	8b 00                	mov    (%eax),%eax
  803de5:	89 45 dc             	mov    %eax,-0x24(%ebp)
			uint32 page_beginning_address= dynAllocStart + page_index * PAGE_SIZE;
  803de8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803deb:	c1 e0 0c             	shl    $0xc,%eax
  803dee:	89 c2                	mov    %eax,%edx
  803df0:	a1 04 fb 87 00       	mov    0x87fb04,%eax
  803df5:	01 d0                	add    %edx,%eax
  803df7:	89 45 d8             	mov    %eax,-0x28(%ebp)
			uint32 page_end_address = dynAllocStart + (page_index +1 )* PAGE_SIZE;
  803dfa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803dfd:	40                   	inc    %eax
  803dfe:	c1 e0 0c             	shl    $0xc,%eax
  803e01:	89 c2                	mov    %eax,%edx
  803e03:	a1 04 fb 87 00       	mov    0x87fb04,%eax
  803e08:	01 d0                	add    %edx,%eax
  803e0a:	89 45 d4             	mov    %eax,-0x2c(%ebp)

			if((uint32)itr >= page_beginning_address && (uint32)itr < page_end_address){
  803e0d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e10:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  803e13:	0f 82 b8 00 00 00    	jb     803ed1 <free_block+0x290>
  803e19:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e1c:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803e1f:	0f 83 ac 00 00 00    	jae    803ed1 <free_block+0x290>
				LIST_REMOVE(&freeBlockLists[list_index], itr);
  803e25:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803e29:	75 17                	jne    803e42 <free_block+0x201>
  803e2b:	83 ec 04             	sub    $0x4,%esp
  803e2e:	68 8d 4d 80 00       	push   $0x804d8d
  803e33:	68 e2 00 00 00       	push   $0xe2
  803e38:	68 53 4d 80 00       	push   $0x804d53
  803e3d:	e8 f7 02 00 00       	call   804139 <_panic>
  803e42:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e45:	8b 00                	mov    (%eax),%eax
  803e47:	85 c0                	test   %eax,%eax
  803e49:	74 10                	je     803e5b <free_block+0x21a>
  803e4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e4e:	8b 00                	mov    (%eax),%eax
  803e50:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803e53:	8b 52 04             	mov    0x4(%edx),%edx
  803e56:	89 50 04             	mov    %edx,0x4(%eax)
  803e59:	eb 14                	jmp    803e6f <free_block+0x22e>
  803e5b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e5e:	8b 40 04             	mov    0x4(%eax),%eax
  803e61:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803e64:	c1 e2 04             	shl    $0x4,%edx
  803e67:	81 c2 24 fb 87 00    	add    $0x87fb24,%edx
  803e6d:	89 02                	mov    %eax,(%edx)
  803e6f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e72:	8b 40 04             	mov    0x4(%eax),%eax
  803e75:	85 c0                	test   %eax,%eax
  803e77:	74 0f                	je     803e88 <free_block+0x247>
  803e79:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e7c:	8b 40 04             	mov    0x4(%eax),%eax
  803e7f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803e82:	8b 12                	mov    (%edx),%edx
  803e84:	89 10                	mov    %edx,(%eax)
  803e86:	eb 13                	jmp    803e9b <free_block+0x25a>
  803e88:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e8b:	8b 00                	mov    (%eax),%eax
  803e8d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803e90:	c1 e2 04             	shl    $0x4,%edx
  803e93:	81 c2 20 fb 87 00    	add    $0x87fb20,%edx
  803e99:	89 02                	mov    %eax,(%edx)
  803e9b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e9e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803ea4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ea7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803eae:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803eb1:	c1 e0 04             	shl    $0x4,%eax
  803eb4:	05 2c fb 87 00       	add    $0x87fb2c,%eax
  803eb9:	8b 00                	mov    (%eax),%eax
  803ebb:	8d 50 ff             	lea    -0x1(%eax),%edx
  803ebe:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803ec1:	c1 e0 04             	shl    $0x4,%eax
  803ec4:	05 2c fb 87 00       	add    $0x87fb2c,%eax
  803ec9:	89 10                	mov    %edx,(%eax)
				//y5o4 3la elly b3do
				itr = next;
  803ecb:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803ece:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// b3d ma wdytha fy el freeBlockLists hzwed elfree elly fy el array 1
	pageBlockInfoArr[page_index].num_of_free_blocks++;
	int blocks_number = PAGE_SIZE / block_size;
	if(pageBlockInfoArr[page_index].num_of_free_blocks == blocks_number){
		struct BlockElement *itr = LIST_FIRST(&freeBlockLists[list_index]);
		while(itr != NULL){
  803ed1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803ed5:	0f 85 05 ff ff ff    	jne    803de0 <free_block+0x19f>
				LIST_REMOVE(&freeBlockLists[list_index], itr);
				//y5o4 3la elly b3do
				itr = next;
			}
		}
		pageBlockInfoArr[page_index].block_size=0;
  803edb:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803ede:	89 d0                	mov    %edx,%eax
  803ee0:	01 c0                	add    %eax,%eax
  803ee2:	01 d0                	add    %edx,%eax
  803ee4:	c1 e0 02             	shl    $0x2,%eax
  803ee7:	05 08 7b 86 00       	add    $0x867b08,%eax
  803eec:	66 c7 00 00 00       	movw   $0x0,(%eax)
		pageBlockInfoArr[page_index].num_of_free_blocks=0;
  803ef1:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803ef4:	89 d0                	mov    %edx,%eax
  803ef6:	01 c0                	add    %eax,%eax
  803ef8:	01 d0                	add    %edx,%eax
  803efa:	c1 e0 02             	shl    $0x2,%eax
  803efd:	05 0a 7b 86 00       	add    $0x867b0a,%eax
  803f02:	66 c7 00 00 00       	movw   $0x0,(%eax)

		struct PageInfoElement *page_info = &pageBlockInfoArr[page_index];
  803f07:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803f0a:	89 d0                	mov    %edx,%eax
  803f0c:	01 c0                	add    %eax,%eax
  803f0e:	01 d0                	add    %edx,%eax
  803f10:	c1 e0 02             	shl    $0x2,%eax
  803f13:	05 00 7b 86 00       	add    $0x867b00,%eax
  803f18:	89 45 d0             	mov    %eax,-0x30(%ebp)
		LIST_INSERT_TAIL(&freePagesList, page_info);
  803f1b:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  803f1f:	75 17                	jne    803f38 <free_block+0x2f7>
  803f21:	83 ec 04             	sub    $0x4,%esp
  803f24:	68 ac 4d 80 00       	push   $0x804dac
  803f29:	68 eb 00 00 00       	push   $0xeb
  803f2e:	68 53 4d 80 00       	push   $0x804d53
  803f33:	e8 01 02 00 00       	call   804139 <_panic>
  803f38:	8b 15 e8 7a 86 00    	mov    0x867ae8,%edx
  803f3e:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803f41:	89 50 04             	mov    %edx,0x4(%eax)
  803f44:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803f47:	8b 40 04             	mov    0x4(%eax),%eax
  803f4a:	85 c0                	test   %eax,%eax
  803f4c:	74 0c                	je     803f5a <free_block+0x319>
  803f4e:	a1 e8 7a 86 00       	mov    0x867ae8,%eax
  803f53:	8b 55 d0             	mov    -0x30(%ebp),%edx
  803f56:	89 10                	mov    %edx,(%eax)
  803f58:	eb 08                	jmp    803f62 <free_block+0x321>
  803f5a:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803f5d:	a3 e4 7a 86 00       	mov    %eax,0x867ae4
  803f62:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803f65:	a3 e8 7a 86 00       	mov    %eax,0x867ae8
  803f6a:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803f6d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803f73:	a1 f0 7a 86 00       	mov    0x867af0,%eax
  803f78:	40                   	inc    %eax
  803f79:	a3 f0 7a 86 00       	mov    %eax,0x867af0
		uint32 page_va = to_page_va(page_info);
  803f7e:	83 ec 0c             	sub    $0xc,%esp
  803f81:	ff 75 d0             	pushl  -0x30(%ebp)
  803f84:	e8 ce f5 ff ff       	call   803557 <to_page_va>
  803f89:	83 c4 10             	add    $0x10,%esp
  803f8c:	89 45 cc             	mov    %eax,-0x34(%ebp)
		return_page((void *)page_va);
  803f8f:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803f92:	83 ec 0c             	sub    $0xc,%esp
  803f95:	50                   	push   %eax
  803f96:	e8 9e d7 ff ff       	call   801739 <return_page>
  803f9b:	83 c4 10             	add    $0x10,%esp
	}


	//Comment the following line
	//panic("free_block() Not implemented yet");
}
  803f9e:	90                   	nop
  803f9f:	c9                   	leave  
  803fa0:	c3                   	ret    

00803fa1 <realloc_block>:

//===========================
// [1] REALLOCATE BLOCK:
//===========================
void *realloc_block(void* va, uint32 new_size)
{
  803fa1:	55                   	push   %ebp
  803fa2:	89 e5                	mov    %esp,%ebp
  803fa4:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.BONUS#2] KERNEL REALLOC - realloc_block
	//Your code is here
	//Comment the following line
	panic("realloc_block() Not implemented yet");
  803fa7:	83 ec 04             	sub    $0x4,%esp
  803faa:	68 4c 4e 80 00       	push   $0x804e4c
  803faf:	68 01 01 00 00       	push   $0x101
  803fb4:	68 53 4d 80 00       	push   $0x804d53
  803fb9:	e8 7b 01 00 00       	call   804139 <_panic>

00803fbe <create_semaphore>:
// User-level Semaphore

#include "inc/lib.h"

struct semaphore create_semaphore(char *semaphoreName, uint32 value)
{
  803fbe:	55                   	push   %ebp
  803fbf:	89 e5                	mov    %esp,%ebp
  803fc1:	83 ec 08             	sub    $0x8,%esp
	panic("create_semaphore() is not implemented yet...!!");
  803fc4:	83 ec 04             	sub    $0x4,%esp
  803fc7:	68 70 4e 80 00       	push   $0x804e70
  803fcc:	6a 07                	push   $0x7
  803fce:	68 9f 4e 80 00       	push   $0x804e9f
  803fd3:	e8 61 01 00 00       	call   804139 <_panic>

00803fd8 <get_semaphore>:
}
struct semaphore get_semaphore(int32 ownerEnvID, char* semaphoreName)
{
  803fd8:	55                   	push   %ebp
  803fd9:	89 e5                	mov    %esp,%ebp
  803fdb:	83 ec 08             	sub    $0x8,%esp
	panic("get_semaphore() is not implemented yet...!!");
  803fde:	83 ec 04             	sub    $0x4,%esp
  803fe1:	68 b0 4e 80 00       	push   $0x804eb0
  803fe6:	6a 0b                	push   $0xb
  803fe8:	68 9f 4e 80 00       	push   $0x804e9f
  803fed:	e8 47 01 00 00       	call   804139 <_panic>

00803ff2 <wait_semaphore>:
}

void wait_semaphore(struct semaphore sem)
{
  803ff2:	55                   	push   %ebp
  803ff3:	89 e5                	mov    %esp,%ebp
  803ff5:	83 ec 08             	sub    $0x8,%esp
	panic("wait_semaphore() is not implemented yet...!!");
  803ff8:	83 ec 04             	sub    $0x4,%esp
  803ffb:	68 dc 4e 80 00       	push   $0x804edc
  804000:	6a 10                	push   $0x10
  804002:	68 9f 4e 80 00       	push   $0x804e9f
  804007:	e8 2d 01 00 00       	call   804139 <_panic>

0080400c <signal_semaphore>:
}

void signal_semaphore(struct semaphore sem)
{
  80400c:	55                   	push   %ebp
  80400d:	89 e5                	mov    %esp,%ebp
  80400f:	83 ec 08             	sub    $0x8,%esp
	panic("signal_semaphore() is not implemented yet...!!");
  804012:	83 ec 04             	sub    $0x4,%esp
  804015:	68 0c 4f 80 00       	push   $0x804f0c
  80401a:	6a 15                	push   $0x15
  80401c:	68 9f 4e 80 00       	push   $0x804e9f
  804021:	e8 13 01 00 00       	call   804139 <_panic>

00804026 <semaphore_count>:
}

int semaphore_count(struct semaphore sem)
{
  804026:	55                   	push   %ebp
  804027:	89 e5                	mov    %esp,%ebp
	return sem.semdata->count;
  804029:	8b 45 08             	mov    0x8(%ebp),%eax
  80402c:	8b 40 10             	mov    0x10(%eax),%eax
}
  80402f:	5d                   	pop    %ebp
  804030:	c3                   	ret    

00804031 <init_uspinlock>:
#include "inc/uspinlock.h"

extern volatile struct Env *myEnv;

void init_uspinlock(struct uspinlock *lk, char *name, bool isOpened)
{
  804031:	55                   	push   %ebp
  804032:	89 e5                	mov    %esp,%ebp
  804034:	83 ec 08             	sub    $0x8,%esp
	assert(isOpened == 0 || isOpened == 1);
  804037:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80403b:	74 1c                	je     804059 <init_uspinlock+0x28>
  80403d:	83 7d 10 01          	cmpl   $0x1,0x10(%ebp)
  804041:	74 16                	je     804059 <init_uspinlock+0x28>
  804043:	68 3c 4f 80 00       	push   $0x804f3c
  804048:	68 5b 4f 80 00       	push   $0x804f5b
  80404d:	6a 10                	push   $0x10
  80404f:	68 70 4f 80 00       	push   $0x804f70
  804054:	e8 e0 00 00 00       	call   804139 <_panic>
	strcpy(lk->name, name);
  804059:	8b 45 08             	mov    0x8(%ebp),%eax
  80405c:	83 c0 04             	add    $0x4,%eax
  80405f:	83 ec 08             	sub    $0x8,%esp
  804062:	ff 75 0c             	pushl  0xc(%ebp)
  804065:	50                   	push   %eax
  804066:	e8 1d ce ff ff       	call   800e88 <strcpy>
  80406b:	83 c4 10             	add    $0x10,%esp
	lk->locked = (1 - isOpened);
  80406e:	b8 01 00 00 00       	mov    $0x1,%eax
  804073:	2b 45 10             	sub    0x10(%ebp),%eax
  804076:	89 c2                	mov    %eax,%edx
  804078:	8b 45 08             	mov    0x8(%ebp),%eax
  80407b:	89 10                	mov    %edx,(%eax)
}
  80407d:	90                   	nop
  80407e:	c9                   	leave  
  80407f:	c3                   	ret    

00804080 <acquire_uspinlock>:
// Acquire the lock.
// Loops (spins) until the lock is acquired.
// Holding a lock for a long time may cause
// other CPUs to waste time spinning to acquire it.
void acquire_uspinlock(struct uspinlock *lk)
{
  804080:	55                   	push   %ebp
  804081:	89 e5                	mov    %esp,%ebp
  804083:	83 ec 18             	sub    $0x18,%esp
	// The xchg is atomic.
	while(xchg(&lk->locked, 1) != 0) ;
  804086:	90                   	nop
  804087:	8b 45 08             	mov    0x8(%ebp),%eax
  80408a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80408d:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
xchg(volatile uint32 *addr, uint32 newval)
{
  uint32 result;

  // The + in "+m" denotes a read-modify-write operand.
  __asm __volatile("lock; xchgl %0, %1" :
  804094:	8b 55 f4             	mov    -0xc(%ebp),%edx
  804097:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80409a:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  80409d:	f0 87 02             	lock xchg %eax,(%edx)
  8040a0:	89 45 ec             	mov    %eax,-0x14(%ebp)
               "+m" (*addr), "=a" (result) :
               "1" (newval) :
               "cc");
  return result;
  8040a3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8040a6:	85 c0                	test   %eax,%eax
  8040a8:	75 dd                	jne    804087 <acquire_uspinlock+0x7>

	cprintf("[%d: %s] ACQUIRED spinlock [%s]\n", myEnv->env_id, myEnv->prog_name, lk->name);
  8040aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8040ad:	8d 48 04             	lea    0x4(%eax),%ecx
  8040b0:	a1 20 60 80 00       	mov    0x806020,%eax
  8040b5:	8d 50 20             	lea    0x20(%eax),%edx
  8040b8:	a1 20 60 80 00       	mov    0x806020,%eax
  8040bd:	8b 40 10             	mov    0x10(%eax),%eax
  8040c0:	51                   	push   %ecx
  8040c1:	52                   	push   %edx
  8040c2:	50                   	push   %eax
  8040c3:	68 80 4f 80 00       	push   $0x804f80
  8040c8:	e8 93 c6 ff ff       	call   800760 <cprintf>
  8040cd:	83 c4 10             	add    $0x10,%esp

	// Tell the C compiler and the processor to not move loads or stores
	// past this point, to ensure that the critical section's memory
	// references happen after the lock is acquired.
	__sync_synchronize();
  8040d0:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
}
  8040d5:	90                   	nop
  8040d6:	c9                   	leave  
  8040d7:	c3                   	ret    

008040d8 <release_uspinlock>:

// Release the lock.
void release_uspinlock(struct uspinlock *lk)
{
  8040d8:	55                   	push   %ebp
  8040d9:	89 e5                	mov    %esp,%ebp
  8040db:	83 ec 08             	sub    $0x8,%esp
	if(!(lk->locked))
  8040de:	8b 45 08             	mov    0x8(%ebp),%eax
  8040e1:	8b 00                	mov    (%eax),%eax
  8040e3:	85 c0                	test   %eax,%eax
  8040e5:	75 18                	jne    8040ff <release_uspinlock+0x27>
	{
		panic("release: lock \"%s\" is not held!", lk->name);
  8040e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8040ea:	83 c0 04             	add    $0x4,%eax
  8040ed:	50                   	push   %eax
  8040ee:	68 a4 4f 80 00       	push   $0x804fa4
  8040f3:	6a 2b                	push   $0x2b
  8040f5:	68 70 4f 80 00       	push   $0x804f70
  8040fa:	e8 3a 00 00 00       	call   804139 <_panic>
	// Tell the C compiler and the processor to not move loads or stores
	// past this point, to ensure that all the stores in the critical
	// section are visible to other cores before the lock is released.
	// Both the C compiler and the hardware may re-order loads and
	// stores; __sync_synchronize() tells them both not to.
	__sync_synchronize();
  8040ff:	f0 83 0c 24 00       	lock orl $0x0,(%esp)

	// Release the lock, equivalent to lk->locked = 0.
	// This code can't use a C assignment, since it might
	// not be atomic. A real OS would use C atomics here.
	asm volatile("movl $0, %0" : "+m" (lk->locked) : );
  804104:	8b 45 08             	mov    0x8(%ebp),%eax
  804107:	8b 55 08             	mov    0x8(%ebp),%edx
  80410a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	cprintf("[%d: %s] RELEASED spinlock [%s]\n", myEnv->env_id, myEnv->prog_name, lk->name);
  804110:	8b 45 08             	mov    0x8(%ebp),%eax
  804113:	8d 48 04             	lea    0x4(%eax),%ecx
  804116:	a1 20 60 80 00       	mov    0x806020,%eax
  80411b:	8d 50 20             	lea    0x20(%eax),%edx
  80411e:	a1 20 60 80 00       	mov    0x806020,%eax
  804123:	8b 40 10             	mov    0x10(%eax),%eax
  804126:	51                   	push   %ecx
  804127:	52                   	push   %edx
  804128:	50                   	push   %eax
  804129:	68 c4 4f 80 00       	push   $0x804fc4
  80412e:	e8 2d c6 ff ff       	call   800760 <cprintf>
  804133:	83 c4 10             	add    $0x10,%esp
}
  804136:	90                   	nop
  804137:	c9                   	leave  
  804138:	c3                   	ret    

00804139 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  804139:	55                   	push   %ebp
  80413a:	89 e5                	mov    %esp,%ebp
  80413c:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  80413f:	8d 45 10             	lea    0x10(%ebp),%eax
  804142:	83 c0 04             	add    $0x4,%eax
  804145:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  804148:	a1 c4 16 8e 00       	mov    0x8e16c4,%eax
  80414d:	85 c0                	test   %eax,%eax
  80414f:	74 16                	je     804167 <_panic+0x2e>
		cprintf("%s: ", argv0);
  804151:	a1 c4 16 8e 00       	mov    0x8e16c4,%eax
  804156:	83 ec 08             	sub    $0x8,%esp
  804159:	50                   	push   %eax
  80415a:	68 e8 4f 80 00       	push   $0x804fe8
  80415f:	e8 fc c5 ff ff       	call   800760 <cprintf>
  804164:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  804167:	a1 04 60 80 00       	mov    0x806004,%eax
  80416c:	83 ec 0c             	sub    $0xc,%esp
  80416f:	ff 75 0c             	pushl  0xc(%ebp)
  804172:	ff 75 08             	pushl  0x8(%ebp)
  804175:	50                   	push   %eax
  804176:	68 f0 4f 80 00       	push   $0x804ff0
  80417b:	6a 74                	push   $0x74
  80417d:	e8 0b c6 ff ff       	call   80078d <cprintf_colored>
  804182:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  804185:	8b 45 10             	mov    0x10(%ebp),%eax
  804188:	83 ec 08             	sub    $0x8,%esp
  80418b:	ff 75 f4             	pushl  -0xc(%ebp)
  80418e:	50                   	push   %eax
  80418f:	e8 5d c5 ff ff       	call   8006f1 <vcprintf>
  804194:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  804197:	83 ec 08             	sub    $0x8,%esp
  80419a:	6a 00                	push   $0x0
  80419c:	68 18 50 80 00       	push   $0x805018
  8041a1:	e8 4b c5 ff ff       	call   8006f1 <vcprintf>
  8041a6:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8041a9:	e8 c4 c4 ff ff       	call   800672 <exit>

	// should not return here
	while (1) ;
  8041ae:	eb fe                	jmp    8041ae <_panic+0x75>

008041b0 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8041b0:	55                   	push   %ebp
  8041b1:	89 e5                	mov    %esp,%ebp
  8041b3:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8041b6:	a1 20 60 80 00       	mov    0x806020,%eax
  8041bb:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8041c1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8041c4:	39 c2                	cmp    %eax,%edx
  8041c6:	74 14                	je     8041dc <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8041c8:	83 ec 04             	sub    $0x4,%esp
  8041cb:	68 1c 50 80 00       	push   $0x80501c
  8041d0:	6a 26                	push   $0x26
  8041d2:	68 68 50 80 00       	push   $0x805068
  8041d7:	e8 5d ff ff ff       	call   804139 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8041dc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8041e3:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8041ea:	e9 c5 00 00 00       	jmp    8042b4 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  8041ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8041f2:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8041f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8041fc:	01 d0                	add    %edx,%eax
  8041fe:	8b 00                	mov    (%eax),%eax
  804200:	85 c0                	test   %eax,%eax
  804202:	75 08                	jne    80420c <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  804204:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  804207:	e9 a5 00 00 00       	jmp    8042b1 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  80420c:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  804213:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  80421a:	eb 69                	jmp    804285 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  80421c:	a1 20 60 80 00       	mov    0x806020,%eax
  804221:	8b 88 a4 05 00 00    	mov    0x5a4(%eax),%ecx
  804227:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80422a:	89 d0                	mov    %edx,%eax
  80422c:	01 c0                	add    %eax,%eax
  80422e:	01 d0                	add    %edx,%eax
  804230:	c1 e0 03             	shl    $0x3,%eax
  804233:	01 c8                	add    %ecx,%eax
  804235:	8a 40 04             	mov    0x4(%eax),%al
  804238:	84 c0                	test   %al,%al
  80423a:	75 46                	jne    804282 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80423c:	a1 20 60 80 00       	mov    0x806020,%eax
  804241:	8b 88 a4 05 00 00    	mov    0x5a4(%eax),%ecx
  804247:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80424a:	89 d0                	mov    %edx,%eax
  80424c:	01 c0                	add    %eax,%eax
  80424e:	01 d0                	add    %edx,%eax
  804250:	c1 e0 03             	shl    $0x3,%eax
  804253:	01 c8                	add    %ecx,%eax
  804255:	8b 00                	mov    (%eax),%eax
  804257:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80425a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80425d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  804262:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  804264:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804267:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80426e:	8b 45 08             	mov    0x8(%ebp),%eax
  804271:	01 c8                	add    %ecx,%eax
  804273:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  804275:	39 c2                	cmp    %eax,%edx
  804277:	75 09                	jne    804282 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  804279:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  804280:	eb 15                	jmp    804297 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  804282:	ff 45 e8             	incl   -0x18(%ebp)
  804285:	a1 20 60 80 00       	mov    0x806020,%eax
  80428a:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  804290:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804293:	39 c2                	cmp    %eax,%edx
  804295:	77 85                	ja     80421c <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  804297:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80429b:	75 14                	jne    8042b1 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  80429d:	83 ec 04             	sub    $0x4,%esp
  8042a0:	68 74 50 80 00       	push   $0x805074
  8042a5:	6a 3a                	push   $0x3a
  8042a7:	68 68 50 80 00       	push   $0x805068
  8042ac:	e8 88 fe ff ff       	call   804139 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8042b1:	ff 45 f0             	incl   -0x10(%ebp)
  8042b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8042b7:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8042ba:	0f 8c 2f ff ff ff    	jl     8041ef <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8042c0:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8042c7:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8042ce:	eb 26                	jmp    8042f6 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  8042d0:	a1 20 60 80 00       	mov    0x806020,%eax
  8042d5:	8b 88 a4 05 00 00    	mov    0x5a4(%eax),%ecx
  8042db:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8042de:	89 d0                	mov    %edx,%eax
  8042e0:	01 c0                	add    %eax,%eax
  8042e2:	01 d0                	add    %edx,%eax
  8042e4:	c1 e0 03             	shl    $0x3,%eax
  8042e7:	01 c8                	add    %ecx,%eax
  8042e9:	8a 40 04             	mov    0x4(%eax),%al
  8042ec:	3c 01                	cmp    $0x1,%al
  8042ee:	75 03                	jne    8042f3 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  8042f0:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8042f3:	ff 45 e0             	incl   -0x20(%ebp)
  8042f6:	a1 20 60 80 00       	mov    0x806020,%eax
  8042fb:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  804301:	8b 45 e0             	mov    -0x20(%ebp),%eax
  804304:	39 c2                	cmp    %eax,%edx
  804306:	77 c8                	ja     8042d0 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  804308:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80430b:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80430e:	74 14                	je     804324 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  804310:	83 ec 04             	sub    $0x4,%esp
  804313:	68 c8 50 80 00       	push   $0x8050c8
  804318:	6a 44                	push   $0x44
  80431a:	68 68 50 80 00       	push   $0x805068
  80431f:	e8 15 fe ff ff       	call   804139 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  804324:	90                   	nop
  804325:	c9                   	leave  
  804326:	c3                   	ret    
  804327:	90                   	nop

00804328 <__udivdi3>:
  804328:	55                   	push   %ebp
  804329:	57                   	push   %edi
  80432a:	56                   	push   %esi
  80432b:	53                   	push   %ebx
  80432c:	83 ec 1c             	sub    $0x1c,%esp
  80432f:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  804333:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  804337:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80433b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80433f:	89 ca                	mov    %ecx,%edx
  804341:	89 f8                	mov    %edi,%eax
  804343:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  804347:	85 f6                	test   %esi,%esi
  804349:	75 2d                	jne    804378 <__udivdi3+0x50>
  80434b:	39 cf                	cmp    %ecx,%edi
  80434d:	77 65                	ja     8043b4 <__udivdi3+0x8c>
  80434f:	89 fd                	mov    %edi,%ebp
  804351:	85 ff                	test   %edi,%edi
  804353:	75 0b                	jne    804360 <__udivdi3+0x38>
  804355:	b8 01 00 00 00       	mov    $0x1,%eax
  80435a:	31 d2                	xor    %edx,%edx
  80435c:	f7 f7                	div    %edi
  80435e:	89 c5                	mov    %eax,%ebp
  804360:	31 d2                	xor    %edx,%edx
  804362:	89 c8                	mov    %ecx,%eax
  804364:	f7 f5                	div    %ebp
  804366:	89 c1                	mov    %eax,%ecx
  804368:	89 d8                	mov    %ebx,%eax
  80436a:	f7 f5                	div    %ebp
  80436c:	89 cf                	mov    %ecx,%edi
  80436e:	89 fa                	mov    %edi,%edx
  804370:	83 c4 1c             	add    $0x1c,%esp
  804373:	5b                   	pop    %ebx
  804374:	5e                   	pop    %esi
  804375:	5f                   	pop    %edi
  804376:	5d                   	pop    %ebp
  804377:	c3                   	ret    
  804378:	39 ce                	cmp    %ecx,%esi
  80437a:	77 28                	ja     8043a4 <__udivdi3+0x7c>
  80437c:	0f bd fe             	bsr    %esi,%edi
  80437f:	83 f7 1f             	xor    $0x1f,%edi
  804382:	75 40                	jne    8043c4 <__udivdi3+0x9c>
  804384:	39 ce                	cmp    %ecx,%esi
  804386:	72 0a                	jb     804392 <__udivdi3+0x6a>
  804388:	3b 44 24 08          	cmp    0x8(%esp),%eax
  80438c:	0f 87 9e 00 00 00    	ja     804430 <__udivdi3+0x108>
  804392:	b8 01 00 00 00       	mov    $0x1,%eax
  804397:	89 fa                	mov    %edi,%edx
  804399:	83 c4 1c             	add    $0x1c,%esp
  80439c:	5b                   	pop    %ebx
  80439d:	5e                   	pop    %esi
  80439e:	5f                   	pop    %edi
  80439f:	5d                   	pop    %ebp
  8043a0:	c3                   	ret    
  8043a1:	8d 76 00             	lea    0x0(%esi),%esi
  8043a4:	31 ff                	xor    %edi,%edi
  8043a6:	31 c0                	xor    %eax,%eax
  8043a8:	89 fa                	mov    %edi,%edx
  8043aa:	83 c4 1c             	add    $0x1c,%esp
  8043ad:	5b                   	pop    %ebx
  8043ae:	5e                   	pop    %esi
  8043af:	5f                   	pop    %edi
  8043b0:	5d                   	pop    %ebp
  8043b1:	c3                   	ret    
  8043b2:	66 90                	xchg   %ax,%ax
  8043b4:	89 d8                	mov    %ebx,%eax
  8043b6:	f7 f7                	div    %edi
  8043b8:	31 ff                	xor    %edi,%edi
  8043ba:	89 fa                	mov    %edi,%edx
  8043bc:	83 c4 1c             	add    $0x1c,%esp
  8043bf:	5b                   	pop    %ebx
  8043c0:	5e                   	pop    %esi
  8043c1:	5f                   	pop    %edi
  8043c2:	5d                   	pop    %ebp
  8043c3:	c3                   	ret    
  8043c4:	bd 20 00 00 00       	mov    $0x20,%ebp
  8043c9:	89 eb                	mov    %ebp,%ebx
  8043cb:	29 fb                	sub    %edi,%ebx
  8043cd:	89 f9                	mov    %edi,%ecx
  8043cf:	d3 e6                	shl    %cl,%esi
  8043d1:	89 c5                	mov    %eax,%ebp
  8043d3:	88 d9                	mov    %bl,%cl
  8043d5:	d3 ed                	shr    %cl,%ebp
  8043d7:	89 e9                	mov    %ebp,%ecx
  8043d9:	09 f1                	or     %esi,%ecx
  8043db:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8043df:	89 f9                	mov    %edi,%ecx
  8043e1:	d3 e0                	shl    %cl,%eax
  8043e3:	89 c5                	mov    %eax,%ebp
  8043e5:	89 d6                	mov    %edx,%esi
  8043e7:	88 d9                	mov    %bl,%cl
  8043e9:	d3 ee                	shr    %cl,%esi
  8043eb:	89 f9                	mov    %edi,%ecx
  8043ed:	d3 e2                	shl    %cl,%edx
  8043ef:	8b 44 24 08          	mov    0x8(%esp),%eax
  8043f3:	88 d9                	mov    %bl,%cl
  8043f5:	d3 e8                	shr    %cl,%eax
  8043f7:	09 c2                	or     %eax,%edx
  8043f9:	89 d0                	mov    %edx,%eax
  8043fb:	89 f2                	mov    %esi,%edx
  8043fd:	f7 74 24 0c          	divl   0xc(%esp)
  804401:	89 d6                	mov    %edx,%esi
  804403:	89 c3                	mov    %eax,%ebx
  804405:	f7 e5                	mul    %ebp
  804407:	39 d6                	cmp    %edx,%esi
  804409:	72 19                	jb     804424 <__udivdi3+0xfc>
  80440b:	74 0b                	je     804418 <__udivdi3+0xf0>
  80440d:	89 d8                	mov    %ebx,%eax
  80440f:	31 ff                	xor    %edi,%edi
  804411:	e9 58 ff ff ff       	jmp    80436e <__udivdi3+0x46>
  804416:	66 90                	xchg   %ax,%ax
  804418:	8b 54 24 08          	mov    0x8(%esp),%edx
  80441c:	89 f9                	mov    %edi,%ecx
  80441e:	d3 e2                	shl    %cl,%edx
  804420:	39 c2                	cmp    %eax,%edx
  804422:	73 e9                	jae    80440d <__udivdi3+0xe5>
  804424:	8d 43 ff             	lea    -0x1(%ebx),%eax
  804427:	31 ff                	xor    %edi,%edi
  804429:	e9 40 ff ff ff       	jmp    80436e <__udivdi3+0x46>
  80442e:	66 90                	xchg   %ax,%ax
  804430:	31 c0                	xor    %eax,%eax
  804432:	e9 37 ff ff ff       	jmp    80436e <__udivdi3+0x46>
  804437:	90                   	nop

00804438 <__umoddi3>:
  804438:	55                   	push   %ebp
  804439:	57                   	push   %edi
  80443a:	56                   	push   %esi
  80443b:	53                   	push   %ebx
  80443c:	83 ec 1c             	sub    $0x1c,%esp
  80443f:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  804443:	8b 74 24 34          	mov    0x34(%esp),%esi
  804447:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80444b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80444f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  804453:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  804457:	89 f3                	mov    %esi,%ebx
  804459:	89 fa                	mov    %edi,%edx
  80445b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80445f:	89 34 24             	mov    %esi,(%esp)
  804462:	85 c0                	test   %eax,%eax
  804464:	75 1a                	jne    804480 <__umoddi3+0x48>
  804466:	39 f7                	cmp    %esi,%edi
  804468:	0f 86 a2 00 00 00    	jbe    804510 <__umoddi3+0xd8>
  80446e:	89 c8                	mov    %ecx,%eax
  804470:	89 f2                	mov    %esi,%edx
  804472:	f7 f7                	div    %edi
  804474:	89 d0                	mov    %edx,%eax
  804476:	31 d2                	xor    %edx,%edx
  804478:	83 c4 1c             	add    $0x1c,%esp
  80447b:	5b                   	pop    %ebx
  80447c:	5e                   	pop    %esi
  80447d:	5f                   	pop    %edi
  80447e:	5d                   	pop    %ebp
  80447f:	c3                   	ret    
  804480:	39 f0                	cmp    %esi,%eax
  804482:	0f 87 ac 00 00 00    	ja     804534 <__umoddi3+0xfc>
  804488:	0f bd e8             	bsr    %eax,%ebp
  80448b:	83 f5 1f             	xor    $0x1f,%ebp
  80448e:	0f 84 ac 00 00 00    	je     804540 <__umoddi3+0x108>
  804494:	bf 20 00 00 00       	mov    $0x20,%edi
  804499:	29 ef                	sub    %ebp,%edi
  80449b:	89 fe                	mov    %edi,%esi
  80449d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8044a1:	89 e9                	mov    %ebp,%ecx
  8044a3:	d3 e0                	shl    %cl,%eax
  8044a5:	89 d7                	mov    %edx,%edi
  8044a7:	89 f1                	mov    %esi,%ecx
  8044a9:	d3 ef                	shr    %cl,%edi
  8044ab:	09 c7                	or     %eax,%edi
  8044ad:	89 e9                	mov    %ebp,%ecx
  8044af:	d3 e2                	shl    %cl,%edx
  8044b1:	89 14 24             	mov    %edx,(%esp)
  8044b4:	89 d8                	mov    %ebx,%eax
  8044b6:	d3 e0                	shl    %cl,%eax
  8044b8:	89 c2                	mov    %eax,%edx
  8044ba:	8b 44 24 08          	mov    0x8(%esp),%eax
  8044be:	d3 e0                	shl    %cl,%eax
  8044c0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8044c4:	8b 44 24 08          	mov    0x8(%esp),%eax
  8044c8:	89 f1                	mov    %esi,%ecx
  8044ca:	d3 e8                	shr    %cl,%eax
  8044cc:	09 d0                	or     %edx,%eax
  8044ce:	d3 eb                	shr    %cl,%ebx
  8044d0:	89 da                	mov    %ebx,%edx
  8044d2:	f7 f7                	div    %edi
  8044d4:	89 d3                	mov    %edx,%ebx
  8044d6:	f7 24 24             	mull   (%esp)
  8044d9:	89 c6                	mov    %eax,%esi
  8044db:	89 d1                	mov    %edx,%ecx
  8044dd:	39 d3                	cmp    %edx,%ebx
  8044df:	0f 82 87 00 00 00    	jb     80456c <__umoddi3+0x134>
  8044e5:	0f 84 91 00 00 00    	je     80457c <__umoddi3+0x144>
  8044eb:	8b 54 24 04          	mov    0x4(%esp),%edx
  8044ef:	29 f2                	sub    %esi,%edx
  8044f1:	19 cb                	sbb    %ecx,%ebx
  8044f3:	89 d8                	mov    %ebx,%eax
  8044f5:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8044f9:	d3 e0                	shl    %cl,%eax
  8044fb:	89 e9                	mov    %ebp,%ecx
  8044fd:	d3 ea                	shr    %cl,%edx
  8044ff:	09 d0                	or     %edx,%eax
  804501:	89 e9                	mov    %ebp,%ecx
  804503:	d3 eb                	shr    %cl,%ebx
  804505:	89 da                	mov    %ebx,%edx
  804507:	83 c4 1c             	add    $0x1c,%esp
  80450a:	5b                   	pop    %ebx
  80450b:	5e                   	pop    %esi
  80450c:	5f                   	pop    %edi
  80450d:	5d                   	pop    %ebp
  80450e:	c3                   	ret    
  80450f:	90                   	nop
  804510:	89 fd                	mov    %edi,%ebp
  804512:	85 ff                	test   %edi,%edi
  804514:	75 0b                	jne    804521 <__umoddi3+0xe9>
  804516:	b8 01 00 00 00       	mov    $0x1,%eax
  80451b:	31 d2                	xor    %edx,%edx
  80451d:	f7 f7                	div    %edi
  80451f:	89 c5                	mov    %eax,%ebp
  804521:	89 f0                	mov    %esi,%eax
  804523:	31 d2                	xor    %edx,%edx
  804525:	f7 f5                	div    %ebp
  804527:	89 c8                	mov    %ecx,%eax
  804529:	f7 f5                	div    %ebp
  80452b:	89 d0                	mov    %edx,%eax
  80452d:	e9 44 ff ff ff       	jmp    804476 <__umoddi3+0x3e>
  804532:	66 90                	xchg   %ax,%ax
  804534:	89 c8                	mov    %ecx,%eax
  804536:	89 f2                	mov    %esi,%edx
  804538:	83 c4 1c             	add    $0x1c,%esp
  80453b:	5b                   	pop    %ebx
  80453c:	5e                   	pop    %esi
  80453d:	5f                   	pop    %edi
  80453e:	5d                   	pop    %ebp
  80453f:	c3                   	ret    
  804540:	3b 04 24             	cmp    (%esp),%eax
  804543:	72 06                	jb     80454b <__umoddi3+0x113>
  804545:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  804549:	77 0f                	ja     80455a <__umoddi3+0x122>
  80454b:	89 f2                	mov    %esi,%edx
  80454d:	29 f9                	sub    %edi,%ecx
  80454f:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  804553:	89 14 24             	mov    %edx,(%esp)
  804556:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80455a:	8b 44 24 04          	mov    0x4(%esp),%eax
  80455e:	8b 14 24             	mov    (%esp),%edx
  804561:	83 c4 1c             	add    $0x1c,%esp
  804564:	5b                   	pop    %ebx
  804565:	5e                   	pop    %esi
  804566:	5f                   	pop    %edi
  804567:	5d                   	pop    %ebp
  804568:	c3                   	ret    
  804569:	8d 76 00             	lea    0x0(%esi),%esi
  80456c:	2b 04 24             	sub    (%esp),%eax
  80456f:	19 fa                	sbb    %edi,%edx
  804571:	89 d1                	mov    %edx,%ecx
  804573:	89 c6                	mov    %eax,%esi
  804575:	e9 71 ff ff ff       	jmp    8044eb <__umoddi3+0xb3>
  80457a:	66 90                	xchg   %ax,%ax
  80457c:	39 44 24 04          	cmp    %eax,0x4(%esp)
  804580:	72 ea                	jb     80456c <__umoddi3+0x134>
  804582:	89 d9                	mov    %ebx,%ecx
  804584:	e9 62 ff ff ff       	jmp    8044eb <__umoddi3+0xb3>
