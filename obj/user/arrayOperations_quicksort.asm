
obj/user/arrayOperations_quicksort:     file format elf32-i386


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
  800031:	e8 22 04 00 00       	call   800458 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <Swap>:
//Functions Declarations
void Swap(int *Elements, int First, int Second);
void PrintElements(int *Elements, int NumOfElements);

void Swap(int *Elements, int First, int Second)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	83 ec 10             	sub    $0x10,%esp
	int Tmp = Elements[First] ;
  80003e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800041:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800048:	8b 45 08             	mov    0x8(%ebp),%eax
  80004b:	01 d0                	add    %edx,%eax
  80004d:	8b 00                	mov    (%eax),%eax
  80004f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	Elements[First] = Elements[Second] ;
  800052:	8b 45 0c             	mov    0xc(%ebp),%eax
  800055:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80005c:	8b 45 08             	mov    0x8(%ebp),%eax
  80005f:	01 c2                	add    %eax,%edx
  800061:	8b 45 10             	mov    0x10(%ebp),%eax
  800064:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80006b:	8b 45 08             	mov    0x8(%ebp),%eax
  80006e:	01 c8                	add    %ecx,%eax
  800070:	8b 00                	mov    (%eax),%eax
  800072:	89 02                	mov    %eax,(%edx)
	Elements[Second] = Tmp ;
  800074:	8b 45 10             	mov    0x10(%ebp),%eax
  800077:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80007e:	8b 45 08             	mov    0x8(%ebp),%eax
  800081:	01 c2                	add    %eax,%edx
  800083:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800086:	89 02                	mov    %eax,(%edx)
}
  800088:	90                   	nop
  800089:	c9                   	leave  
  80008a:	c3                   	ret    

0080008b <PrintElements>:

void PrintElements(int *Elements, int NumOfElements)
{
  80008b:	55                   	push   %ebp
  80008c:	89 e5                	mov    %esp,%ebp
  80008e:	83 ec 18             	sub    $0x18,%esp
	int i ;
	int NumsPerLine = 20 ;
  800091:	c7 45 f0 14 00 00 00 	movl   $0x14,-0x10(%ebp)
	for (i = 0 ; i < NumOfElements-1 ; i++)
  800098:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80009f:	eb 42                	jmp    8000e3 <PrintElements+0x58>
	{
		if (i%NumsPerLine == 0)
  8000a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8000a4:	99                   	cltd   
  8000a5:	f7 7d f0             	idivl  -0x10(%ebp)
  8000a8:	89 d0                	mov    %edx,%eax
  8000aa:	85 c0                	test   %eax,%eax
  8000ac:	75 10                	jne    8000be <PrintElements+0x33>
			cprintf("\n");
  8000ae:	83 ec 0c             	sub    $0xc,%esp
  8000b1:	68 c0 44 80 00       	push   $0x8044c0
  8000b6:	e8 36 06 00 00       	call   8006f1 <cprintf>
  8000bb:	83 c4 10             	add    $0x10,%esp
		cprintf("%d, ",Elements[i]);
  8000be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8000c1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8000c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8000cb:	01 d0                	add    %edx,%eax
  8000cd:	8b 00                	mov    (%eax),%eax
  8000cf:	83 ec 08             	sub    $0x8,%esp
  8000d2:	50                   	push   %eax
  8000d3:	68 c2 44 80 00       	push   $0x8044c2
  8000d8:	e8 14 06 00 00       	call   8006f1 <cprintf>
  8000dd:	83 c4 10             	add    $0x10,%esp

void PrintElements(int *Elements, int NumOfElements)
{
	int i ;
	int NumsPerLine = 20 ;
	for (i = 0 ; i < NumOfElements-1 ; i++)
  8000e0:	ff 45 f4             	incl   -0xc(%ebp)
  8000e3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8000e6:	48                   	dec    %eax
  8000e7:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8000ea:	7f b5                	jg     8000a1 <PrintElements+0x16>
	{
		if (i%NumsPerLine == 0)
			cprintf("\n");
		cprintf("%d, ",Elements[i]);
	}
	cprintf("%d\n",Elements[i]);
  8000ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8000ef:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8000f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8000f9:	01 d0                	add    %edx,%eax
  8000fb:	8b 00                	mov    (%eax),%eax
  8000fd:	83 ec 08             	sub    $0x8,%esp
  800100:	50                   	push   %eax
  800101:	68 c7 44 80 00       	push   $0x8044c7
  800106:	e8 e6 05 00 00       	call   8006f1 <cprintf>
  80010b:	83 c4 10             	add    $0x10,%esp

}
  80010e:	90                   	nop
  80010f:	c9                   	leave  
  800110:	c3                   	ret    

00800111 <_main>:

void QuickSort(int *Elements, int NumOfElements);
void QSort(int *Elements,int NumOfElements, int startIndex, int finalIndex);

void _main(void)
{
  800111:	55                   	push   %ebp
  800112:	89 e5                	mov    %esp,%ebp
  800114:	57                   	push   %edi
  800115:	56                   	push   %esi
  800116:	53                   	push   %ebx
  800117:	81 ec 2c 01 00 00    	sub    $0x12c,%esp
	int32 envID = sys_getenvid();
  80011d:	e8 ea 30 00 00       	call   80320c <sys_getenvid>
  800122:	89 45 e0             	mov    %eax,-0x20(%ebp)
	int32 parentenvID = sys_getparentenvid();
  800125:	e8 14 31 00 00       	call   80323e <sys_getparentenvid>
  80012a:	89 45 dc             	mov    %eax,-0x24(%ebp)
	struct semaphore finished = get_semaphore(parentenvID, "Finished");
#endif

	/*[2] WAIT A READY SIGNAL FROM THE MASTER*/
#if USE_KERN_SEMAPHORE
	char waitCmd1[64] = "__KSem@0@Wait";
  80012d:	8d 45 8c             	lea    -0x74(%ebp),%eax
  800130:	bb 54 45 80 00       	mov    $0x804554,%ebx
  800135:	ba 0e 00 00 00       	mov    $0xe,%edx
  80013a:	89 c7                	mov    %eax,%edi
  80013c:	89 de                	mov    %ebx,%esi
  80013e:	89 d1                	mov    %edx,%ecx
  800140:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  800142:	8d 55 9a             	lea    -0x66(%ebp),%edx
  800145:	b9 32 00 00 00       	mov    $0x32,%ecx
  80014a:	b0 00                	mov    $0x0,%al
  80014c:	89 d7                	mov    %edx,%edi
  80014e:	f3 aa                	rep stos %al,%es:(%edi)
	sys_utilities(waitCmd1, 0);
  800150:	83 ec 08             	sub    $0x8,%esp
  800153:	6a 00                	push   $0x0
  800155:	8d 45 8c             	lea    -0x74(%ebp),%eax
  800158:	50                   	push   %eax
  800159:	e8 fd 32 00 00       	call   80345b <sys_utilities>
  80015e:	83 c4 10             	add    $0x10,%esp
	wait_semaphore(ready);
#endif

	/*[3] GET SHARED VARs*/
	//Get the cons_mutex ownerID
	int* consMutexOwnerID = sget(parentenvID, "cons_mutex ownerID") ;
  800161:	83 ec 08             	sub    $0x8,%esp
  800164:	68 cb 44 80 00       	push   $0x8044cb
  800169:	ff 75 dc             	pushl  -0x24(%ebp)
  80016c:	e8 ce 27 00 00       	call   80293f <sget>
  800171:	83 c4 10             	add    $0x10,%esp
  800174:	89 45 d8             	mov    %eax,-0x28(%ebp)
#else
	struct semaphore cons_mutex = get_semaphore(*consMutexOwnerID, "Console Mutex");
#endif

	//Get the shared array & its size
	int *numOfElements = NULL;
  800177:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
	int *sharedArray = NULL;
  80017e:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
	sharedArray = sget(parentenvID,"arr") ;
  800185:	83 ec 08             	sub    $0x8,%esp
  800188:	68 de 44 80 00       	push   $0x8044de
  80018d:	ff 75 dc             	pushl  -0x24(%ebp)
  800190:	e8 aa 27 00 00       	call   80293f <sget>
  800195:	83 c4 10             	add    $0x10,%esp
  800198:	89 45 d0             	mov    %eax,-0x30(%ebp)
	numOfElements = sget(parentenvID,"arrSize") ;
  80019b:	83 ec 08             	sub    $0x8,%esp
  80019e:	68 e2 44 80 00       	push   $0x8044e2
  8001a3:	ff 75 dc             	pushl  -0x24(%ebp)
  8001a6:	e8 94 27 00 00       	call   80293f <sget>
  8001ab:	83 c4 10             	add    $0x10,%esp
  8001ae:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	/*[4] DO THE JOB*/
	//take a copy from the original array
	int *sortedArray;
	sortedArray = smalloc("quicksortedArr", sizeof(int) * *numOfElements, 0) ;
  8001b1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8001b4:	8b 00                	mov    (%eax),%eax
  8001b6:	c1 e0 02             	shl    $0x2,%eax
  8001b9:	83 ec 04             	sub    $0x4,%esp
  8001bc:	6a 00                	push   $0x0
  8001be:	50                   	push   %eax
  8001bf:	68 ea 44 80 00       	push   $0x8044ea
  8001c4:	e8 cf 21 00 00       	call   802398 <smalloc>
  8001c9:	83 c4 10             	add    $0x10,%esp
  8001cc:	89 45 cc             	mov    %eax,-0x34(%ebp)
	int i ;
	for (i = 0 ; i < *numOfElements ; i++)
  8001cf:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  8001d6:	eb 25                	jmp    8001fd <_main+0xec>
	{
		sortedArray[i] = sharedArray[i];
  8001d8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8001db:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8001e2:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8001e5:	01 c2                	add    %eax,%edx
  8001e7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8001ea:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8001f1:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8001f4:	01 c8                	add    %ecx,%eax
  8001f6:	8b 00                	mov    (%eax),%eax
  8001f8:	89 02                	mov    %eax,(%edx)
	/*[4] DO THE JOB*/
	//take a copy from the original array
	int *sortedArray;
	sortedArray = smalloc("quicksortedArr", sizeof(int) * *numOfElements, 0) ;
	int i ;
	for (i = 0 ; i < *numOfElements ; i++)
  8001fa:	ff 45 e4             	incl   -0x1c(%ebp)
  8001fd:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800200:	8b 00                	mov    (%eax),%eax
  800202:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800205:	7f d1                	jg     8001d8 <_main+0xc7>
	{
		sortedArray[i] = sharedArray[i];
	}
	QuickSort(sortedArray, *numOfElements);
  800207:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80020a:	8b 00                	mov    (%eax),%eax
  80020c:	83 ec 08             	sub    $0x8,%esp
  80020f:	50                   	push   %eax
  800210:	ff 75 cc             	pushl  -0x34(%ebp)
  800213:	e8 f9 00 00 00       	call   800311 <QuickSort>
  800218:	83 c4 10             	add    $0x10,%esp

#if USE_KERN_SEMAPHORE
	char waitCmd2[64] = "__KSem@2@Wait";
  80021b:	8d 85 4c ff ff ff    	lea    -0xb4(%ebp),%eax
  800221:	bb 94 45 80 00       	mov    $0x804594,%ebx
  800226:	ba 0e 00 00 00       	mov    $0xe,%edx
  80022b:	89 c7                	mov    %eax,%edi
  80022d:	89 de                	mov    %ebx,%esi
  80022f:	89 d1                	mov    %edx,%ecx
  800231:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  800233:	8d 95 5a ff ff ff    	lea    -0xa6(%ebp),%edx
  800239:	b9 32 00 00 00       	mov    $0x32,%ecx
  80023e:	b0 00                	mov    $0x0,%al
  800240:	89 d7                	mov    %edx,%edi
  800242:	f3 aa                	rep stos %al,%es:(%edi)
	sys_utilities(waitCmd2, 0);
  800244:	83 ec 08             	sub    $0x8,%esp
  800247:	6a 00                	push   $0x0
  800249:	8d 85 4c ff ff ff    	lea    -0xb4(%ebp),%eax
  80024f:	50                   	push   %eax
  800250:	e8 06 32 00 00       	call   80345b <sys_utilities>
  800255:	83 c4 10             	add    $0x10,%esp
#else
	wait_semaphore(cons_mutex);
#endif
	{
		cprintf("Quick sort is Finished!!!!\n") ;
  800258:	83 ec 0c             	sub    $0xc,%esp
  80025b:	68 f9 44 80 00       	push   $0x8044f9
  800260:	e8 8c 04 00 00       	call   8006f1 <cprintf>
  800265:	83 c4 10             	add    $0x10,%esp
		cprintf("will notify the master now...\n");
  800268:	83 ec 0c             	sub    $0xc,%esp
  80026b:	68 18 45 80 00       	push   $0x804518
  800270:	e8 7c 04 00 00       	call   8006f1 <cprintf>
  800275:	83 c4 10             	add    $0x10,%esp
		cprintf("Quick sort says GOOD BYE :)\n") ;
  800278:	83 ec 0c             	sub    $0xc,%esp
  80027b:	68 37 45 80 00       	push   $0x804537
  800280:	e8 6c 04 00 00       	call   8006f1 <cprintf>
  800285:	83 c4 10             	add    $0x10,%esp
	}
#if USE_KERN_SEMAPHORE
	char signalCmd1[64] = "__KSem@2@Signal";
  800288:	8d 85 0c ff ff ff    	lea    -0xf4(%ebp),%eax
  80028e:	bb d4 45 80 00       	mov    $0x8045d4,%ebx
  800293:	ba 04 00 00 00       	mov    $0x4,%edx
  800298:	89 c7                	mov    %eax,%edi
  80029a:	89 de                	mov    %ebx,%esi
  80029c:	89 d1                	mov    %edx,%ecx
  80029e:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8002a0:	8d 95 1c ff ff ff    	lea    -0xe4(%ebp),%edx
  8002a6:	b9 0c 00 00 00       	mov    $0xc,%ecx
  8002ab:	b8 00 00 00 00       	mov    $0x0,%eax
  8002b0:	89 d7                	mov    %edx,%edi
  8002b2:	f3 ab                	rep stos %eax,%es:(%edi)
	sys_utilities(signalCmd1, 0);
  8002b4:	83 ec 08             	sub    $0x8,%esp
  8002b7:	6a 00                	push   $0x0
  8002b9:	8d 85 0c ff ff ff    	lea    -0xf4(%ebp),%eax
  8002bf:	50                   	push   %eax
  8002c0:	e8 96 31 00 00       	call   80345b <sys_utilities>
  8002c5:	83 c4 10             	add    $0x10,%esp
	signal_semaphore(cons_mutex);
#endif

	/*[5] DECLARE FINISHING*/
#if USE_KERN_SEMAPHORE
	char signalCmd2[64] = "__KSem@1@Signal";
  8002c8:	8d 85 cc fe ff ff    	lea    -0x134(%ebp),%eax
  8002ce:	bb 14 46 80 00       	mov    $0x804614,%ebx
  8002d3:	ba 04 00 00 00       	mov    $0x4,%edx
  8002d8:	89 c7                	mov    %eax,%edi
  8002da:	89 de                	mov    %ebx,%esi
  8002dc:	89 d1                	mov    %edx,%ecx
  8002de:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8002e0:	8d 95 dc fe ff ff    	lea    -0x124(%ebp),%edx
  8002e6:	b9 0c 00 00 00       	mov    $0xc,%ecx
  8002eb:	b8 00 00 00 00       	mov    $0x0,%eax
  8002f0:	89 d7                	mov    %edx,%edi
  8002f2:	f3 ab                	rep stos %eax,%es:(%edi)
	sys_utilities(signalCmd2, 0);
  8002f4:	83 ec 08             	sub    $0x8,%esp
  8002f7:	6a 00                	push   $0x0
  8002f9:	8d 85 cc fe ff ff    	lea    -0x134(%ebp),%eax
  8002ff:	50                   	push   %eax
  800300:	e8 56 31 00 00       	call   80345b <sys_utilities>
  800305:	83 c4 10             	add    $0x10,%esp
#else
	signal_semaphore(finished);
#endif
}
  800308:	90                   	nop
  800309:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80030c:	5b                   	pop    %ebx
  80030d:	5e                   	pop    %esi
  80030e:	5f                   	pop    %edi
  80030f:	5d                   	pop    %ebp
  800310:	c3                   	ret    

00800311 <QuickSort>:

///Quick sort
void QuickSort(int *Elements, int NumOfElements)
{
  800311:	55                   	push   %ebp
  800312:	89 e5                	mov    %esp,%ebp
  800314:	83 ec 08             	sub    $0x8,%esp
	QSort(Elements, NumOfElements, 0, NumOfElements-1) ;
  800317:	8b 45 0c             	mov    0xc(%ebp),%eax
  80031a:	48                   	dec    %eax
  80031b:	50                   	push   %eax
  80031c:	6a 00                	push   $0x0
  80031e:	ff 75 0c             	pushl  0xc(%ebp)
  800321:	ff 75 08             	pushl  0x8(%ebp)
  800324:	e8 06 00 00 00       	call   80032f <QSort>
  800329:	83 c4 10             	add    $0x10,%esp
}
  80032c:	90                   	nop
  80032d:	c9                   	leave  
  80032e:	c3                   	ret    

0080032f <QSort>:


void QSort(int *Elements,int NumOfElements, int startIndex, int finalIndex)
{
  80032f:	55                   	push   %ebp
  800330:	89 e5                	mov    %esp,%ebp
  800332:	83 ec 28             	sub    $0x28,%esp
	if (startIndex >= finalIndex) return;
  800335:	8b 45 10             	mov    0x10(%ebp),%eax
  800338:	3b 45 14             	cmp    0x14(%ebp),%eax
  80033b:	0f 8d 14 01 00 00    	jge    800455 <QSort+0x126>

static inline __attribute__((always_inline)) struct uint64 get_virtual_time_user()
{
	struct uint64 result;

	__asm __volatile("rdtsc\n"
  800341:	0f 31                	rdtsc  
  800343:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800346:	89 55 e0             	mov    %edx,-0x20(%ebp)
	: "=a" (result.low), "=d" (result.hi)
	);

	return result;
  800349:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80034c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80034f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800352:	89 55 e8             	mov    %edx,-0x18(%ebp)
	int pvtIndex = RANDU(startIndex, finalIndex) ;
  800355:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800358:	8b 55 14             	mov    0x14(%ebp),%edx
  80035b:	2b 55 10             	sub    0x10(%ebp),%edx
  80035e:	89 d1                	mov    %edx,%ecx
  800360:	ba 00 00 00 00       	mov    $0x0,%edx
  800365:	f7 f1                	div    %ecx
  800367:	8b 45 10             	mov    0x10(%ebp),%eax
  80036a:	01 d0                	add    %edx,%eax
  80036c:	89 45 ec             	mov    %eax,-0x14(%ebp)
	Swap(Elements, startIndex, pvtIndex);
  80036f:	ff 75 ec             	pushl  -0x14(%ebp)
  800372:	ff 75 10             	pushl  0x10(%ebp)
  800375:	ff 75 08             	pushl  0x8(%ebp)
  800378:	e8 bb fc ff ff       	call   800038 <Swap>
  80037d:	83 c4 0c             	add    $0xc,%esp

	int i = startIndex+1, j = finalIndex;
  800380:	8b 45 10             	mov    0x10(%ebp),%eax
  800383:	40                   	inc    %eax
  800384:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800387:	8b 45 14             	mov    0x14(%ebp),%eax
  80038a:	89 45 f0             	mov    %eax,-0x10(%ebp)

	while (i <= j)
  80038d:	eb 7d                	jmp    80040c <QSort+0xdd>
	{
		while (i <= finalIndex && Elements[startIndex] >= Elements[i]) i++;
  80038f:	ff 45 f4             	incl   -0xc(%ebp)
  800392:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800395:	3b 45 14             	cmp    0x14(%ebp),%eax
  800398:	7f 2b                	jg     8003c5 <QSort+0x96>
  80039a:	8b 45 10             	mov    0x10(%ebp),%eax
  80039d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8003a7:	01 d0                	add    %edx,%eax
  8003a9:	8b 10                	mov    (%eax),%edx
  8003ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8003ae:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8003b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8003b8:	01 c8                	add    %ecx,%eax
  8003ba:	8b 00                	mov    (%eax),%eax
  8003bc:	39 c2                	cmp    %eax,%edx
  8003be:	7d cf                	jge    80038f <QSort+0x60>
		while (j > startIndex && Elements[startIndex] <= Elements[j]) j--;
  8003c0:	eb 03                	jmp    8003c5 <QSort+0x96>
  8003c2:	ff 4d f0             	decl   -0x10(%ebp)
  8003c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003c8:	3b 45 10             	cmp    0x10(%ebp),%eax
  8003cb:	7e 26                	jle    8003f3 <QSort+0xc4>
  8003cd:	8b 45 10             	mov    0x10(%ebp),%eax
  8003d0:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8003da:	01 d0                	add    %edx,%eax
  8003dc:	8b 10                	mov    (%eax),%edx
  8003de:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003e1:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8003e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8003eb:	01 c8                	add    %ecx,%eax
  8003ed:	8b 00                	mov    (%eax),%eax
  8003ef:	39 c2                	cmp    %eax,%edx
  8003f1:	7e cf                	jle    8003c2 <QSort+0x93>

		if (i <= j)
  8003f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8003f6:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8003f9:	7f 11                	jg     80040c <QSort+0xdd>
		{
			Swap(Elements, i, j);
  8003fb:	ff 75 f0             	pushl  -0x10(%ebp)
  8003fe:	ff 75 f4             	pushl  -0xc(%ebp)
  800401:	ff 75 08             	pushl  0x8(%ebp)
  800404:	e8 2f fc ff ff       	call   800038 <Swap>
  800409:	83 c4 0c             	add    $0xc,%esp
	int pvtIndex = RANDU(startIndex, finalIndex) ;
	Swap(Elements, startIndex, pvtIndex);

	int i = startIndex+1, j = finalIndex;

	while (i <= j)
  80040c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80040f:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800412:	0f 8e 7a ff ff ff    	jle    800392 <QSort+0x63>
		{
			Swap(Elements, i, j);
		}
	}

	Swap( Elements, startIndex, j);
  800418:	ff 75 f0             	pushl  -0x10(%ebp)
  80041b:	ff 75 10             	pushl  0x10(%ebp)
  80041e:	ff 75 08             	pushl  0x8(%ebp)
  800421:	e8 12 fc ff ff       	call   800038 <Swap>
  800426:	83 c4 0c             	add    $0xc,%esp

	QSort(Elements, NumOfElements, startIndex, j - 1);
  800429:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80042c:	48                   	dec    %eax
  80042d:	50                   	push   %eax
  80042e:	ff 75 10             	pushl  0x10(%ebp)
  800431:	ff 75 0c             	pushl  0xc(%ebp)
  800434:	ff 75 08             	pushl  0x8(%ebp)
  800437:	e8 f3 fe ff ff       	call   80032f <QSort>
  80043c:	83 c4 10             	add    $0x10,%esp
	QSort(Elements, NumOfElements, i, finalIndex);
  80043f:	ff 75 14             	pushl  0x14(%ebp)
  800442:	ff 75 f4             	pushl  -0xc(%ebp)
  800445:	ff 75 0c             	pushl  0xc(%ebp)
  800448:	ff 75 08             	pushl  0x8(%ebp)
  80044b:	e8 df fe ff ff       	call   80032f <QSort>
  800450:	83 c4 10             	add    $0x10,%esp
  800453:	eb 01                	jmp    800456 <QSort+0x127>
}


void QSort(int *Elements,int NumOfElements, int startIndex, int finalIndex)
{
	if (startIndex >= finalIndex) return;
  800455:	90                   	nop
	QSort(Elements, NumOfElements, startIndex, j - 1);
	QSort(Elements, NumOfElements, i, finalIndex);

	//cprintf("qs,after sorting: start = %d, end = %d\n", startIndex, finalIndex);

}
  800456:	c9                   	leave  
  800457:	c3                   	ret    

00800458 <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  800458:	55                   	push   %ebp
  800459:	89 e5                	mov    %esp,%ebp
  80045b:	57                   	push   %edi
  80045c:	56                   	push   %esi
  80045d:	53                   	push   %ebx
  80045e:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  800461:	e8 bf 2d 00 00       	call   803225 <sys_getenvindex>
  800466:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  800469:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80046c:	89 d0                	mov    %edx,%eax
  80046e:	c1 e0 02             	shl    $0x2,%eax
  800471:	01 d0                	add    %edx,%eax
  800473:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80047a:	01 d0                	add    %edx,%eax
  80047c:	89 c2                	mov    %eax,%edx
  80047e:	c1 e2 04             	shl    $0x4,%edx
  800481:	29 c2                	sub    %eax,%edx
  800483:	8d 04 95 00 00 00 00 	lea    0x0(,%edx,4),%eax
  80048a:	89 c2                	mov    %eax,%edx
  80048c:	8d 82 00 00 c0 ee    	lea    -0x11400000(%edx),%eax
  800492:	a3 20 60 80 00       	mov    %eax,0x806020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800497:	a1 20 60 80 00       	mov    0x806020,%eax
  80049c:	8a 40 20             	mov    0x20(%eax),%al
  80049f:	84 c0                	test   %al,%al
  8004a1:	74 0d                	je     8004b0 <libmain+0x58>
		binaryname = myEnv->prog_name;
  8004a3:	a1 20 60 80 00       	mov    0x806020,%eax
  8004a8:	83 c0 20             	add    $0x20,%eax
  8004ab:	a3 04 60 80 00       	mov    %eax,0x806004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8004b0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8004b4:	7e 0a                	jle    8004c0 <libmain+0x68>
		binaryname = argv[0];
  8004b6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004b9:	8b 00                	mov    (%eax),%eax
  8004bb:	a3 04 60 80 00       	mov    %eax,0x806004

	// call user main routine
	_main(argc, argv);
  8004c0:	83 ec 08             	sub    $0x8,%esp
  8004c3:	ff 75 0c             	pushl  0xc(%ebp)
  8004c6:	ff 75 08             	pushl  0x8(%ebp)
  8004c9:	e8 43 fc ff ff       	call   800111 <_main>
  8004ce:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  8004d1:	a1 00 60 80 00       	mov    0x806000,%eax
  8004d6:	85 c0                	test   %eax,%eax
  8004d8:	0f 84 01 01 00 00    	je     8005df <libmain+0x187>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  8004de:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  8004e4:	bb 4c 47 80 00       	mov    $0x80474c,%ebx
  8004e9:	ba 0e 00 00 00       	mov    $0xe,%edx
  8004ee:	89 c7                	mov    %eax,%edi
  8004f0:	89 de                	mov    %ebx,%esi
  8004f2:	89 d1                	mov    %edx,%ecx
  8004f4:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  8004f6:	8d 55 8a             	lea    -0x76(%ebp),%edx
  8004f9:	b9 56 00 00 00       	mov    $0x56,%ecx
  8004fe:	b0 00                	mov    $0x0,%al
  800500:	89 d7                	mov    %edx,%edi
  800502:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  800504:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  80050b:	8d 45 e0             	lea    -0x20(%ebp),%eax
  80050e:	83 ec 08             	sub    $0x8,%esp
  800511:	50                   	push   %eax
  800512:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  800518:	50                   	push   %eax
  800519:	e8 3d 2f 00 00       	call   80345b <sys_utilities>
  80051e:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  800521:	e8 86 2a 00 00       	call   802fac <sys_lock_cons>
		{
			cprintf("**************************************\n");
  800526:	83 ec 0c             	sub    $0xc,%esp
  800529:	68 6c 46 80 00       	push   $0x80466c
  80052e:	e8 be 01 00 00       	call   8006f1 <cprintf>
  800533:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  800536:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800539:	85 c0                	test   %eax,%eax
  80053b:	74 18                	je     800555 <libmain+0xfd>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  80053d:	e8 37 2f 00 00       	call   803479 <sys_get_optimal_num_faults>
  800542:	83 ec 08             	sub    $0x8,%esp
  800545:	50                   	push   %eax
  800546:	68 94 46 80 00       	push   $0x804694
  80054b:	e8 a1 01 00 00       	call   8006f1 <cprintf>
  800550:	83 c4 10             	add    $0x10,%esp
  800553:	eb 59                	jmp    8005ae <libmain+0x156>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800555:	a1 20 60 80 00       	mov    0x806020,%eax
  80055a:	8b 90 bc 05 00 00    	mov    0x5bc(%eax),%edx
  800560:	a1 20 60 80 00       	mov    0x806020,%eax
  800565:	8b 80 ac 05 00 00    	mov    0x5ac(%eax),%eax
  80056b:	83 ec 04             	sub    $0x4,%esp
  80056e:	52                   	push   %edx
  80056f:	50                   	push   %eax
  800570:	68 b8 46 80 00       	push   $0x8046b8
  800575:	e8 77 01 00 00       	call   8006f1 <cprintf>
  80057a:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  80057d:	a1 20 60 80 00       	mov    0x806020,%eax
  800582:	8b 88 d0 05 00 00    	mov    0x5d0(%eax),%ecx
  800588:	a1 20 60 80 00       	mov    0x806020,%eax
  80058d:	8b 90 cc 05 00 00    	mov    0x5cc(%eax),%edx
  800593:	a1 20 60 80 00       	mov    0x806020,%eax
  800598:	8b 80 c8 05 00 00    	mov    0x5c8(%eax),%eax
  80059e:	51                   	push   %ecx
  80059f:	52                   	push   %edx
  8005a0:	50                   	push   %eax
  8005a1:	68 e0 46 80 00       	push   $0x8046e0
  8005a6:	e8 46 01 00 00       	call   8006f1 <cprintf>
  8005ab:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8005ae:	a1 20 60 80 00       	mov    0x806020,%eax
  8005b3:	8b 80 d4 05 00 00    	mov    0x5d4(%eax),%eax
  8005b9:	83 ec 08             	sub    $0x8,%esp
  8005bc:	50                   	push   %eax
  8005bd:	68 38 47 80 00       	push   $0x804738
  8005c2:	e8 2a 01 00 00       	call   8006f1 <cprintf>
  8005c7:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  8005ca:	83 ec 0c             	sub    $0xc,%esp
  8005cd:	68 6c 46 80 00       	push   $0x80466c
  8005d2:	e8 1a 01 00 00       	call   8006f1 <cprintf>
  8005d7:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  8005da:	e8 e7 29 00 00       	call   802fc6 <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  8005df:	e8 1f 00 00 00       	call   800603 <exit>
}
  8005e4:	90                   	nop
  8005e5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8005e8:	5b                   	pop    %ebx
  8005e9:	5e                   	pop    %esi
  8005ea:	5f                   	pop    %edi
  8005eb:	5d                   	pop    %ebp
  8005ec:	c3                   	ret    

008005ed <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8005ed:	55                   	push   %ebp
  8005ee:	89 e5                	mov    %esp,%ebp
  8005f0:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8005f3:	83 ec 0c             	sub    $0xc,%esp
  8005f6:	6a 00                	push   $0x0
  8005f8:	e8 f4 2b 00 00       	call   8031f1 <sys_destroy_env>
  8005fd:	83 c4 10             	add    $0x10,%esp
}
  800600:	90                   	nop
  800601:	c9                   	leave  
  800602:	c3                   	ret    

00800603 <exit>:

void
exit(void)
{
  800603:	55                   	push   %ebp
  800604:	89 e5                	mov    %esp,%ebp
  800606:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800609:	e8 49 2c 00 00       	call   803257 <sys_exit_env>
}
  80060e:	90                   	nop
  80060f:	c9                   	leave  
  800610:	c3                   	ret    

00800611 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  800611:	55                   	push   %ebp
  800612:	89 e5                	mov    %esp,%ebp
  800614:	53                   	push   %ebx
  800615:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  800618:	8b 45 0c             	mov    0xc(%ebp),%eax
  80061b:	8b 00                	mov    (%eax),%eax
  80061d:	8d 48 01             	lea    0x1(%eax),%ecx
  800620:	8b 55 0c             	mov    0xc(%ebp),%edx
  800623:	89 0a                	mov    %ecx,(%edx)
  800625:	8b 55 08             	mov    0x8(%ebp),%edx
  800628:	88 d1                	mov    %dl,%cl
  80062a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80062d:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800631:	8b 45 0c             	mov    0xc(%ebp),%eax
  800634:	8b 00                	mov    (%eax),%eax
  800636:	3d ff 00 00 00       	cmp    $0xff,%eax
  80063b:	75 30                	jne    80066d <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  80063d:	8b 15 18 e1 81 00    	mov    0x81e118,%edx
  800643:	a0 44 60 80 00       	mov    0x806044,%al
  800648:	0f b6 c0             	movzbl %al,%eax
  80064b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80064e:	8b 09                	mov    (%ecx),%ecx
  800650:	89 cb                	mov    %ecx,%ebx
  800652:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800655:	83 c1 08             	add    $0x8,%ecx
  800658:	52                   	push   %edx
  800659:	50                   	push   %eax
  80065a:	53                   	push   %ebx
  80065b:	51                   	push   %ecx
  80065c:	e8 07 29 00 00       	call   802f68 <sys_cputs>
  800661:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800664:	8b 45 0c             	mov    0xc(%ebp),%eax
  800667:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  80066d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800670:	8b 40 04             	mov    0x4(%eax),%eax
  800673:	8d 50 01             	lea    0x1(%eax),%edx
  800676:	8b 45 0c             	mov    0xc(%ebp),%eax
  800679:	89 50 04             	mov    %edx,0x4(%eax)
}
  80067c:	90                   	nop
  80067d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800680:	c9                   	leave  
  800681:	c3                   	ret    

00800682 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800682:	55                   	push   %ebp
  800683:	89 e5                	mov    %esp,%ebp
  800685:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80068b:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800692:	00 00 00 
	b.cnt = 0;
  800695:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80069c:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  80069f:	ff 75 0c             	pushl  0xc(%ebp)
  8006a2:	ff 75 08             	pushl  0x8(%ebp)
  8006a5:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8006ab:	50                   	push   %eax
  8006ac:	68 11 06 80 00       	push   $0x800611
  8006b1:	e8 5a 02 00 00       	call   800910 <vprintfmt>
  8006b6:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  8006b9:	8b 15 18 e1 81 00    	mov    0x81e118,%edx
  8006bf:	a0 44 60 80 00       	mov    0x806044,%al
  8006c4:	0f b6 c0             	movzbl %al,%eax
  8006c7:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  8006cd:	52                   	push   %edx
  8006ce:	50                   	push   %eax
  8006cf:	51                   	push   %ecx
  8006d0:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8006d6:	83 c0 08             	add    $0x8,%eax
  8006d9:	50                   	push   %eax
  8006da:	e8 89 28 00 00       	call   802f68 <sys_cputs>
  8006df:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8006e2:	c6 05 44 60 80 00 00 	movb   $0x0,0x806044
	return b.cnt;
  8006e9:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8006ef:	c9                   	leave  
  8006f0:	c3                   	ret    

008006f1 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  8006f1:	55                   	push   %ebp
  8006f2:	89 e5                	mov    %esp,%ebp
  8006f4:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8006f7:	c6 05 44 60 80 00 01 	movb   $0x1,0x806044
	va_start(ap, fmt);
  8006fe:	8d 45 0c             	lea    0xc(%ebp),%eax
  800701:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800704:	8b 45 08             	mov    0x8(%ebp),%eax
  800707:	83 ec 08             	sub    $0x8,%esp
  80070a:	ff 75 f4             	pushl  -0xc(%ebp)
  80070d:	50                   	push   %eax
  80070e:	e8 6f ff ff ff       	call   800682 <vcprintf>
  800713:	83 c4 10             	add    $0x10,%esp
  800716:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800719:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80071c:	c9                   	leave  
  80071d:	c3                   	ret    

0080071e <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  80071e:	55                   	push   %ebp
  80071f:	89 e5                	mov    %esp,%ebp
  800721:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800724:	c6 05 44 60 80 00 01 	movb   $0x1,0x806044
	curTextClr = (textClr << 8) ; //set text color by the given value
  80072b:	8b 45 08             	mov    0x8(%ebp),%eax
  80072e:	c1 e0 08             	shl    $0x8,%eax
  800731:	a3 18 e1 81 00       	mov    %eax,0x81e118
	va_start(ap, fmt);
  800736:	8d 45 0c             	lea    0xc(%ebp),%eax
  800739:	83 c0 04             	add    $0x4,%eax
  80073c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80073f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800742:	83 ec 08             	sub    $0x8,%esp
  800745:	ff 75 f4             	pushl  -0xc(%ebp)
  800748:	50                   	push   %eax
  800749:	e8 34 ff ff ff       	call   800682 <vcprintf>
  80074e:	83 c4 10             	add    $0x10,%esp
  800751:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  800754:	c7 05 18 e1 81 00 00 	movl   $0x700,0x81e118
  80075b:	07 00 00 

	return cnt;
  80075e:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800761:	c9                   	leave  
  800762:	c3                   	ret    

00800763 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  800763:	55                   	push   %ebp
  800764:	89 e5                	mov    %esp,%ebp
  800766:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  800769:	e8 3e 28 00 00       	call   802fac <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  80076e:	8d 45 0c             	lea    0xc(%ebp),%eax
  800771:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  800774:	8b 45 08             	mov    0x8(%ebp),%eax
  800777:	83 ec 08             	sub    $0x8,%esp
  80077a:	ff 75 f4             	pushl  -0xc(%ebp)
  80077d:	50                   	push   %eax
  80077e:	e8 ff fe ff ff       	call   800682 <vcprintf>
  800783:	83 c4 10             	add    $0x10,%esp
  800786:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  800789:	e8 38 28 00 00       	call   802fc6 <sys_unlock_cons>
	return cnt;
  80078e:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800791:	c9                   	leave  
  800792:	c3                   	ret    

00800793 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800793:	55                   	push   %ebp
  800794:	89 e5                	mov    %esp,%ebp
  800796:	53                   	push   %ebx
  800797:	83 ec 14             	sub    $0x14,%esp
  80079a:	8b 45 10             	mov    0x10(%ebp),%eax
  80079d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8007a0:	8b 45 14             	mov    0x14(%ebp),%eax
  8007a3:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8007a6:	8b 45 18             	mov    0x18(%ebp),%eax
  8007a9:	ba 00 00 00 00       	mov    $0x0,%edx
  8007ae:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8007b1:	77 55                	ja     800808 <printnum+0x75>
  8007b3:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8007b6:	72 05                	jb     8007bd <printnum+0x2a>
  8007b8:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8007bb:	77 4b                	ja     800808 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8007bd:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8007c0:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8007c3:	8b 45 18             	mov    0x18(%ebp),%eax
  8007c6:	ba 00 00 00 00       	mov    $0x0,%edx
  8007cb:	52                   	push   %edx
  8007cc:	50                   	push   %eax
  8007cd:	ff 75 f4             	pushl  -0xc(%ebp)
  8007d0:	ff 75 f0             	pushl  -0x10(%ebp)
  8007d3:	e8 70 3a 00 00       	call   804248 <__udivdi3>
  8007d8:	83 c4 10             	add    $0x10,%esp
  8007db:	83 ec 04             	sub    $0x4,%esp
  8007de:	ff 75 20             	pushl  0x20(%ebp)
  8007e1:	53                   	push   %ebx
  8007e2:	ff 75 18             	pushl  0x18(%ebp)
  8007e5:	52                   	push   %edx
  8007e6:	50                   	push   %eax
  8007e7:	ff 75 0c             	pushl  0xc(%ebp)
  8007ea:	ff 75 08             	pushl  0x8(%ebp)
  8007ed:	e8 a1 ff ff ff       	call   800793 <printnum>
  8007f2:	83 c4 20             	add    $0x20,%esp
  8007f5:	eb 1a                	jmp    800811 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8007f7:	83 ec 08             	sub    $0x8,%esp
  8007fa:	ff 75 0c             	pushl  0xc(%ebp)
  8007fd:	ff 75 20             	pushl  0x20(%ebp)
  800800:	8b 45 08             	mov    0x8(%ebp),%eax
  800803:	ff d0                	call   *%eax
  800805:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800808:	ff 4d 1c             	decl   0x1c(%ebp)
  80080b:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  80080f:	7f e6                	jg     8007f7 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800811:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800814:	bb 00 00 00 00       	mov    $0x0,%ebx
  800819:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80081c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80081f:	53                   	push   %ebx
  800820:	51                   	push   %ecx
  800821:	52                   	push   %edx
  800822:	50                   	push   %eax
  800823:	e8 30 3b 00 00       	call   804358 <__umoddi3>
  800828:	83 c4 10             	add    $0x10,%esp
  80082b:	05 d4 49 80 00       	add    $0x8049d4,%eax
  800830:	8a 00                	mov    (%eax),%al
  800832:	0f be c0             	movsbl %al,%eax
  800835:	83 ec 08             	sub    $0x8,%esp
  800838:	ff 75 0c             	pushl  0xc(%ebp)
  80083b:	50                   	push   %eax
  80083c:	8b 45 08             	mov    0x8(%ebp),%eax
  80083f:	ff d0                	call   *%eax
  800841:	83 c4 10             	add    $0x10,%esp
}
  800844:	90                   	nop
  800845:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800848:	c9                   	leave  
  800849:	c3                   	ret    

0080084a <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80084a:	55                   	push   %ebp
  80084b:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80084d:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800851:	7e 1c                	jle    80086f <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800853:	8b 45 08             	mov    0x8(%ebp),%eax
  800856:	8b 00                	mov    (%eax),%eax
  800858:	8d 50 08             	lea    0x8(%eax),%edx
  80085b:	8b 45 08             	mov    0x8(%ebp),%eax
  80085e:	89 10                	mov    %edx,(%eax)
  800860:	8b 45 08             	mov    0x8(%ebp),%eax
  800863:	8b 00                	mov    (%eax),%eax
  800865:	83 e8 08             	sub    $0x8,%eax
  800868:	8b 50 04             	mov    0x4(%eax),%edx
  80086b:	8b 00                	mov    (%eax),%eax
  80086d:	eb 40                	jmp    8008af <getuint+0x65>
	else if (lflag)
  80086f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800873:	74 1e                	je     800893 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800875:	8b 45 08             	mov    0x8(%ebp),%eax
  800878:	8b 00                	mov    (%eax),%eax
  80087a:	8d 50 04             	lea    0x4(%eax),%edx
  80087d:	8b 45 08             	mov    0x8(%ebp),%eax
  800880:	89 10                	mov    %edx,(%eax)
  800882:	8b 45 08             	mov    0x8(%ebp),%eax
  800885:	8b 00                	mov    (%eax),%eax
  800887:	83 e8 04             	sub    $0x4,%eax
  80088a:	8b 00                	mov    (%eax),%eax
  80088c:	ba 00 00 00 00       	mov    $0x0,%edx
  800891:	eb 1c                	jmp    8008af <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800893:	8b 45 08             	mov    0x8(%ebp),%eax
  800896:	8b 00                	mov    (%eax),%eax
  800898:	8d 50 04             	lea    0x4(%eax),%edx
  80089b:	8b 45 08             	mov    0x8(%ebp),%eax
  80089e:	89 10                	mov    %edx,(%eax)
  8008a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8008a3:	8b 00                	mov    (%eax),%eax
  8008a5:	83 e8 04             	sub    $0x4,%eax
  8008a8:	8b 00                	mov    (%eax),%eax
  8008aa:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8008af:	5d                   	pop    %ebp
  8008b0:	c3                   	ret    

008008b1 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8008b1:	55                   	push   %ebp
  8008b2:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8008b4:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8008b8:	7e 1c                	jle    8008d6 <getint+0x25>
		return va_arg(*ap, long long);
  8008ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8008bd:	8b 00                	mov    (%eax),%eax
  8008bf:	8d 50 08             	lea    0x8(%eax),%edx
  8008c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8008c5:	89 10                	mov    %edx,(%eax)
  8008c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ca:	8b 00                	mov    (%eax),%eax
  8008cc:	83 e8 08             	sub    $0x8,%eax
  8008cf:	8b 50 04             	mov    0x4(%eax),%edx
  8008d2:	8b 00                	mov    (%eax),%eax
  8008d4:	eb 38                	jmp    80090e <getint+0x5d>
	else if (lflag)
  8008d6:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8008da:	74 1a                	je     8008f6 <getint+0x45>
		return va_arg(*ap, long);
  8008dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8008df:	8b 00                	mov    (%eax),%eax
  8008e1:	8d 50 04             	lea    0x4(%eax),%edx
  8008e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8008e7:	89 10                	mov    %edx,(%eax)
  8008e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ec:	8b 00                	mov    (%eax),%eax
  8008ee:	83 e8 04             	sub    $0x4,%eax
  8008f1:	8b 00                	mov    (%eax),%eax
  8008f3:	99                   	cltd   
  8008f4:	eb 18                	jmp    80090e <getint+0x5d>
	else
		return va_arg(*ap, int);
  8008f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8008f9:	8b 00                	mov    (%eax),%eax
  8008fb:	8d 50 04             	lea    0x4(%eax),%edx
  8008fe:	8b 45 08             	mov    0x8(%ebp),%eax
  800901:	89 10                	mov    %edx,(%eax)
  800903:	8b 45 08             	mov    0x8(%ebp),%eax
  800906:	8b 00                	mov    (%eax),%eax
  800908:	83 e8 04             	sub    $0x4,%eax
  80090b:	8b 00                	mov    (%eax),%eax
  80090d:	99                   	cltd   
}
  80090e:	5d                   	pop    %ebp
  80090f:	c3                   	ret    

00800910 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800910:	55                   	push   %ebp
  800911:	89 e5                	mov    %esp,%ebp
  800913:	56                   	push   %esi
  800914:	53                   	push   %ebx
  800915:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800918:	eb 17                	jmp    800931 <vprintfmt+0x21>
			if (ch == '\0')
  80091a:	85 db                	test   %ebx,%ebx
  80091c:	0f 84 c1 03 00 00    	je     800ce3 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  800922:	83 ec 08             	sub    $0x8,%esp
  800925:	ff 75 0c             	pushl  0xc(%ebp)
  800928:	53                   	push   %ebx
  800929:	8b 45 08             	mov    0x8(%ebp),%eax
  80092c:	ff d0                	call   *%eax
  80092e:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800931:	8b 45 10             	mov    0x10(%ebp),%eax
  800934:	8d 50 01             	lea    0x1(%eax),%edx
  800937:	89 55 10             	mov    %edx,0x10(%ebp)
  80093a:	8a 00                	mov    (%eax),%al
  80093c:	0f b6 d8             	movzbl %al,%ebx
  80093f:	83 fb 25             	cmp    $0x25,%ebx
  800942:	75 d6                	jne    80091a <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800944:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800948:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  80094f:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800956:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  80095d:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800964:	8b 45 10             	mov    0x10(%ebp),%eax
  800967:	8d 50 01             	lea    0x1(%eax),%edx
  80096a:	89 55 10             	mov    %edx,0x10(%ebp)
  80096d:	8a 00                	mov    (%eax),%al
  80096f:	0f b6 d8             	movzbl %al,%ebx
  800972:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800975:	83 f8 5b             	cmp    $0x5b,%eax
  800978:	0f 87 3d 03 00 00    	ja     800cbb <vprintfmt+0x3ab>
  80097e:	8b 04 85 f8 49 80 00 	mov    0x8049f8(,%eax,4),%eax
  800985:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800987:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  80098b:	eb d7                	jmp    800964 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  80098d:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800991:	eb d1                	jmp    800964 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800993:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  80099a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80099d:	89 d0                	mov    %edx,%eax
  80099f:	c1 e0 02             	shl    $0x2,%eax
  8009a2:	01 d0                	add    %edx,%eax
  8009a4:	01 c0                	add    %eax,%eax
  8009a6:	01 d8                	add    %ebx,%eax
  8009a8:	83 e8 30             	sub    $0x30,%eax
  8009ab:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8009ae:	8b 45 10             	mov    0x10(%ebp),%eax
  8009b1:	8a 00                	mov    (%eax),%al
  8009b3:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8009b6:	83 fb 2f             	cmp    $0x2f,%ebx
  8009b9:	7e 3e                	jle    8009f9 <vprintfmt+0xe9>
  8009bb:	83 fb 39             	cmp    $0x39,%ebx
  8009be:	7f 39                	jg     8009f9 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8009c0:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8009c3:	eb d5                	jmp    80099a <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8009c5:	8b 45 14             	mov    0x14(%ebp),%eax
  8009c8:	83 c0 04             	add    $0x4,%eax
  8009cb:	89 45 14             	mov    %eax,0x14(%ebp)
  8009ce:	8b 45 14             	mov    0x14(%ebp),%eax
  8009d1:	83 e8 04             	sub    $0x4,%eax
  8009d4:	8b 00                	mov    (%eax),%eax
  8009d6:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8009d9:	eb 1f                	jmp    8009fa <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8009db:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8009df:	79 83                	jns    800964 <vprintfmt+0x54>
				width = 0;
  8009e1:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8009e8:	e9 77 ff ff ff       	jmp    800964 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  8009ed:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  8009f4:	e9 6b ff ff ff       	jmp    800964 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  8009f9:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8009fa:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8009fe:	0f 89 60 ff ff ff    	jns    800964 <vprintfmt+0x54>
				width = precision, precision = -1;
  800a04:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800a07:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800a0a:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800a11:	e9 4e ff ff ff       	jmp    800964 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800a16:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800a19:	e9 46 ff ff ff       	jmp    800964 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800a1e:	8b 45 14             	mov    0x14(%ebp),%eax
  800a21:	83 c0 04             	add    $0x4,%eax
  800a24:	89 45 14             	mov    %eax,0x14(%ebp)
  800a27:	8b 45 14             	mov    0x14(%ebp),%eax
  800a2a:	83 e8 04             	sub    $0x4,%eax
  800a2d:	8b 00                	mov    (%eax),%eax
  800a2f:	83 ec 08             	sub    $0x8,%esp
  800a32:	ff 75 0c             	pushl  0xc(%ebp)
  800a35:	50                   	push   %eax
  800a36:	8b 45 08             	mov    0x8(%ebp),%eax
  800a39:	ff d0                	call   *%eax
  800a3b:	83 c4 10             	add    $0x10,%esp
			break;
  800a3e:	e9 9b 02 00 00       	jmp    800cde <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800a43:	8b 45 14             	mov    0x14(%ebp),%eax
  800a46:	83 c0 04             	add    $0x4,%eax
  800a49:	89 45 14             	mov    %eax,0x14(%ebp)
  800a4c:	8b 45 14             	mov    0x14(%ebp),%eax
  800a4f:	83 e8 04             	sub    $0x4,%eax
  800a52:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800a54:	85 db                	test   %ebx,%ebx
  800a56:	79 02                	jns    800a5a <vprintfmt+0x14a>
				err = -err;
  800a58:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800a5a:	83 fb 64             	cmp    $0x64,%ebx
  800a5d:	7f 0b                	jg     800a6a <vprintfmt+0x15a>
  800a5f:	8b 34 9d 40 48 80 00 	mov    0x804840(,%ebx,4),%esi
  800a66:	85 f6                	test   %esi,%esi
  800a68:	75 19                	jne    800a83 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800a6a:	53                   	push   %ebx
  800a6b:	68 e5 49 80 00       	push   $0x8049e5
  800a70:	ff 75 0c             	pushl  0xc(%ebp)
  800a73:	ff 75 08             	pushl  0x8(%ebp)
  800a76:	e8 70 02 00 00       	call   800ceb <printfmt>
  800a7b:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800a7e:	e9 5b 02 00 00       	jmp    800cde <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800a83:	56                   	push   %esi
  800a84:	68 ee 49 80 00       	push   $0x8049ee
  800a89:	ff 75 0c             	pushl  0xc(%ebp)
  800a8c:	ff 75 08             	pushl  0x8(%ebp)
  800a8f:	e8 57 02 00 00       	call   800ceb <printfmt>
  800a94:	83 c4 10             	add    $0x10,%esp
			break;
  800a97:	e9 42 02 00 00       	jmp    800cde <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800a9c:	8b 45 14             	mov    0x14(%ebp),%eax
  800a9f:	83 c0 04             	add    $0x4,%eax
  800aa2:	89 45 14             	mov    %eax,0x14(%ebp)
  800aa5:	8b 45 14             	mov    0x14(%ebp),%eax
  800aa8:	83 e8 04             	sub    $0x4,%eax
  800aab:	8b 30                	mov    (%eax),%esi
  800aad:	85 f6                	test   %esi,%esi
  800aaf:	75 05                	jne    800ab6 <vprintfmt+0x1a6>
				p = "(null)";
  800ab1:	be f1 49 80 00       	mov    $0x8049f1,%esi
			if (width > 0 && padc != '-')
  800ab6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800aba:	7e 6d                	jle    800b29 <vprintfmt+0x219>
  800abc:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800ac0:	74 67                	je     800b29 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800ac2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800ac5:	83 ec 08             	sub    $0x8,%esp
  800ac8:	50                   	push   %eax
  800ac9:	56                   	push   %esi
  800aca:	e8 1e 03 00 00       	call   800ded <strnlen>
  800acf:	83 c4 10             	add    $0x10,%esp
  800ad2:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800ad5:	eb 16                	jmp    800aed <vprintfmt+0x1dd>
					putch(padc, putdat);
  800ad7:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800adb:	83 ec 08             	sub    $0x8,%esp
  800ade:	ff 75 0c             	pushl  0xc(%ebp)
  800ae1:	50                   	push   %eax
  800ae2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ae5:	ff d0                	call   *%eax
  800ae7:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800aea:	ff 4d e4             	decl   -0x1c(%ebp)
  800aed:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800af1:	7f e4                	jg     800ad7 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800af3:	eb 34                	jmp    800b29 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800af5:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800af9:	74 1c                	je     800b17 <vprintfmt+0x207>
  800afb:	83 fb 1f             	cmp    $0x1f,%ebx
  800afe:	7e 05                	jle    800b05 <vprintfmt+0x1f5>
  800b00:	83 fb 7e             	cmp    $0x7e,%ebx
  800b03:	7e 12                	jle    800b17 <vprintfmt+0x207>
					putch('?', putdat);
  800b05:	83 ec 08             	sub    $0x8,%esp
  800b08:	ff 75 0c             	pushl  0xc(%ebp)
  800b0b:	6a 3f                	push   $0x3f
  800b0d:	8b 45 08             	mov    0x8(%ebp),%eax
  800b10:	ff d0                	call   *%eax
  800b12:	83 c4 10             	add    $0x10,%esp
  800b15:	eb 0f                	jmp    800b26 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800b17:	83 ec 08             	sub    $0x8,%esp
  800b1a:	ff 75 0c             	pushl  0xc(%ebp)
  800b1d:	53                   	push   %ebx
  800b1e:	8b 45 08             	mov    0x8(%ebp),%eax
  800b21:	ff d0                	call   *%eax
  800b23:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b26:	ff 4d e4             	decl   -0x1c(%ebp)
  800b29:	89 f0                	mov    %esi,%eax
  800b2b:	8d 70 01             	lea    0x1(%eax),%esi
  800b2e:	8a 00                	mov    (%eax),%al
  800b30:	0f be d8             	movsbl %al,%ebx
  800b33:	85 db                	test   %ebx,%ebx
  800b35:	74 24                	je     800b5b <vprintfmt+0x24b>
  800b37:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800b3b:	78 b8                	js     800af5 <vprintfmt+0x1e5>
  800b3d:	ff 4d e0             	decl   -0x20(%ebp)
  800b40:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800b44:	79 af                	jns    800af5 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800b46:	eb 13                	jmp    800b5b <vprintfmt+0x24b>
				putch(' ', putdat);
  800b48:	83 ec 08             	sub    $0x8,%esp
  800b4b:	ff 75 0c             	pushl  0xc(%ebp)
  800b4e:	6a 20                	push   $0x20
  800b50:	8b 45 08             	mov    0x8(%ebp),%eax
  800b53:	ff d0                	call   *%eax
  800b55:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800b58:	ff 4d e4             	decl   -0x1c(%ebp)
  800b5b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b5f:	7f e7                	jg     800b48 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800b61:	e9 78 01 00 00       	jmp    800cde <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800b66:	83 ec 08             	sub    $0x8,%esp
  800b69:	ff 75 e8             	pushl  -0x18(%ebp)
  800b6c:	8d 45 14             	lea    0x14(%ebp),%eax
  800b6f:	50                   	push   %eax
  800b70:	e8 3c fd ff ff       	call   8008b1 <getint>
  800b75:	83 c4 10             	add    $0x10,%esp
  800b78:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b7b:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800b7e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b81:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b84:	85 d2                	test   %edx,%edx
  800b86:	79 23                	jns    800bab <vprintfmt+0x29b>
				putch('-', putdat);
  800b88:	83 ec 08             	sub    $0x8,%esp
  800b8b:	ff 75 0c             	pushl  0xc(%ebp)
  800b8e:	6a 2d                	push   $0x2d
  800b90:	8b 45 08             	mov    0x8(%ebp),%eax
  800b93:	ff d0                	call   *%eax
  800b95:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800b98:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b9b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b9e:	f7 d8                	neg    %eax
  800ba0:	83 d2 00             	adc    $0x0,%edx
  800ba3:	f7 da                	neg    %edx
  800ba5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ba8:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800bab:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800bb2:	e9 bc 00 00 00       	jmp    800c73 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800bb7:	83 ec 08             	sub    $0x8,%esp
  800bba:	ff 75 e8             	pushl  -0x18(%ebp)
  800bbd:	8d 45 14             	lea    0x14(%ebp),%eax
  800bc0:	50                   	push   %eax
  800bc1:	e8 84 fc ff ff       	call   80084a <getuint>
  800bc6:	83 c4 10             	add    $0x10,%esp
  800bc9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bcc:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800bcf:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800bd6:	e9 98 00 00 00       	jmp    800c73 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800bdb:	83 ec 08             	sub    $0x8,%esp
  800bde:	ff 75 0c             	pushl  0xc(%ebp)
  800be1:	6a 58                	push   $0x58
  800be3:	8b 45 08             	mov    0x8(%ebp),%eax
  800be6:	ff d0                	call   *%eax
  800be8:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800beb:	83 ec 08             	sub    $0x8,%esp
  800bee:	ff 75 0c             	pushl  0xc(%ebp)
  800bf1:	6a 58                	push   $0x58
  800bf3:	8b 45 08             	mov    0x8(%ebp),%eax
  800bf6:	ff d0                	call   *%eax
  800bf8:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800bfb:	83 ec 08             	sub    $0x8,%esp
  800bfe:	ff 75 0c             	pushl  0xc(%ebp)
  800c01:	6a 58                	push   $0x58
  800c03:	8b 45 08             	mov    0x8(%ebp),%eax
  800c06:	ff d0                	call   *%eax
  800c08:	83 c4 10             	add    $0x10,%esp
			break;
  800c0b:	e9 ce 00 00 00       	jmp    800cde <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800c10:	83 ec 08             	sub    $0x8,%esp
  800c13:	ff 75 0c             	pushl  0xc(%ebp)
  800c16:	6a 30                	push   $0x30
  800c18:	8b 45 08             	mov    0x8(%ebp),%eax
  800c1b:	ff d0                	call   *%eax
  800c1d:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800c20:	83 ec 08             	sub    $0x8,%esp
  800c23:	ff 75 0c             	pushl  0xc(%ebp)
  800c26:	6a 78                	push   $0x78
  800c28:	8b 45 08             	mov    0x8(%ebp),%eax
  800c2b:	ff d0                	call   *%eax
  800c2d:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800c30:	8b 45 14             	mov    0x14(%ebp),%eax
  800c33:	83 c0 04             	add    $0x4,%eax
  800c36:	89 45 14             	mov    %eax,0x14(%ebp)
  800c39:	8b 45 14             	mov    0x14(%ebp),%eax
  800c3c:	83 e8 04             	sub    $0x4,%eax
  800c3f:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800c41:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c44:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800c4b:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800c52:	eb 1f                	jmp    800c73 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800c54:	83 ec 08             	sub    $0x8,%esp
  800c57:	ff 75 e8             	pushl  -0x18(%ebp)
  800c5a:	8d 45 14             	lea    0x14(%ebp),%eax
  800c5d:	50                   	push   %eax
  800c5e:	e8 e7 fb ff ff       	call   80084a <getuint>
  800c63:	83 c4 10             	add    $0x10,%esp
  800c66:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c69:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800c6c:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800c73:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800c77:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800c7a:	83 ec 04             	sub    $0x4,%esp
  800c7d:	52                   	push   %edx
  800c7e:	ff 75 e4             	pushl  -0x1c(%ebp)
  800c81:	50                   	push   %eax
  800c82:	ff 75 f4             	pushl  -0xc(%ebp)
  800c85:	ff 75 f0             	pushl  -0x10(%ebp)
  800c88:	ff 75 0c             	pushl  0xc(%ebp)
  800c8b:	ff 75 08             	pushl  0x8(%ebp)
  800c8e:	e8 00 fb ff ff       	call   800793 <printnum>
  800c93:	83 c4 20             	add    $0x20,%esp
			break;
  800c96:	eb 46                	jmp    800cde <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800c98:	83 ec 08             	sub    $0x8,%esp
  800c9b:	ff 75 0c             	pushl  0xc(%ebp)
  800c9e:	53                   	push   %ebx
  800c9f:	8b 45 08             	mov    0x8(%ebp),%eax
  800ca2:	ff d0                	call   *%eax
  800ca4:	83 c4 10             	add    $0x10,%esp
			break;
  800ca7:	eb 35                	jmp    800cde <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800ca9:	c6 05 44 60 80 00 00 	movb   $0x0,0x806044
			break;
  800cb0:	eb 2c                	jmp    800cde <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800cb2:	c6 05 44 60 80 00 01 	movb   $0x1,0x806044
			break;
  800cb9:	eb 23                	jmp    800cde <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800cbb:	83 ec 08             	sub    $0x8,%esp
  800cbe:	ff 75 0c             	pushl  0xc(%ebp)
  800cc1:	6a 25                	push   $0x25
  800cc3:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc6:	ff d0                	call   *%eax
  800cc8:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800ccb:	ff 4d 10             	decl   0x10(%ebp)
  800cce:	eb 03                	jmp    800cd3 <vprintfmt+0x3c3>
  800cd0:	ff 4d 10             	decl   0x10(%ebp)
  800cd3:	8b 45 10             	mov    0x10(%ebp),%eax
  800cd6:	48                   	dec    %eax
  800cd7:	8a 00                	mov    (%eax),%al
  800cd9:	3c 25                	cmp    $0x25,%al
  800cdb:	75 f3                	jne    800cd0 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800cdd:	90                   	nop
		}
	}
  800cde:	e9 35 fc ff ff       	jmp    800918 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800ce3:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800ce4:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800ce7:	5b                   	pop    %ebx
  800ce8:	5e                   	pop    %esi
  800ce9:	5d                   	pop    %ebp
  800cea:	c3                   	ret    

00800ceb <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800ceb:	55                   	push   %ebp
  800cec:	89 e5                	mov    %esp,%ebp
  800cee:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800cf1:	8d 45 10             	lea    0x10(%ebp),%eax
  800cf4:	83 c0 04             	add    $0x4,%eax
  800cf7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800cfa:	8b 45 10             	mov    0x10(%ebp),%eax
  800cfd:	ff 75 f4             	pushl  -0xc(%ebp)
  800d00:	50                   	push   %eax
  800d01:	ff 75 0c             	pushl  0xc(%ebp)
  800d04:	ff 75 08             	pushl  0x8(%ebp)
  800d07:	e8 04 fc ff ff       	call   800910 <vprintfmt>
  800d0c:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800d0f:	90                   	nop
  800d10:	c9                   	leave  
  800d11:	c3                   	ret    

00800d12 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800d12:	55                   	push   %ebp
  800d13:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800d15:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d18:	8b 40 08             	mov    0x8(%eax),%eax
  800d1b:	8d 50 01             	lea    0x1(%eax),%edx
  800d1e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d21:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800d24:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d27:	8b 10                	mov    (%eax),%edx
  800d29:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d2c:	8b 40 04             	mov    0x4(%eax),%eax
  800d2f:	39 c2                	cmp    %eax,%edx
  800d31:	73 12                	jae    800d45 <sprintputch+0x33>
		*b->buf++ = ch;
  800d33:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d36:	8b 00                	mov    (%eax),%eax
  800d38:	8d 48 01             	lea    0x1(%eax),%ecx
  800d3b:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d3e:	89 0a                	mov    %ecx,(%edx)
  800d40:	8b 55 08             	mov    0x8(%ebp),%edx
  800d43:	88 10                	mov    %dl,(%eax)
}
  800d45:	90                   	nop
  800d46:	5d                   	pop    %ebp
  800d47:	c3                   	ret    

00800d48 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800d48:	55                   	push   %ebp
  800d49:	89 e5                	mov    %esp,%ebp
  800d4b:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800d4e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d51:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800d54:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d57:	8d 50 ff             	lea    -0x1(%eax),%edx
  800d5a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d5d:	01 d0                	add    %edx,%eax
  800d5f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800d62:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800d69:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800d6d:	74 06                	je     800d75 <vsnprintf+0x2d>
  800d6f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d73:	7f 07                	jg     800d7c <vsnprintf+0x34>
		return -E_INVAL;
  800d75:	b8 03 00 00 00       	mov    $0x3,%eax
  800d7a:	eb 20                	jmp    800d9c <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800d7c:	ff 75 14             	pushl  0x14(%ebp)
  800d7f:	ff 75 10             	pushl  0x10(%ebp)
  800d82:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800d85:	50                   	push   %eax
  800d86:	68 12 0d 80 00       	push   $0x800d12
  800d8b:	e8 80 fb ff ff       	call   800910 <vprintfmt>
  800d90:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800d93:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800d96:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800d99:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800d9c:	c9                   	leave  
  800d9d:	c3                   	ret    

00800d9e <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800d9e:	55                   	push   %ebp
  800d9f:	89 e5                	mov    %esp,%ebp
  800da1:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800da4:	8d 45 10             	lea    0x10(%ebp),%eax
  800da7:	83 c0 04             	add    $0x4,%eax
  800daa:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800dad:	8b 45 10             	mov    0x10(%ebp),%eax
  800db0:	ff 75 f4             	pushl  -0xc(%ebp)
  800db3:	50                   	push   %eax
  800db4:	ff 75 0c             	pushl  0xc(%ebp)
  800db7:	ff 75 08             	pushl  0x8(%ebp)
  800dba:	e8 89 ff ff ff       	call   800d48 <vsnprintf>
  800dbf:	83 c4 10             	add    $0x10,%esp
  800dc2:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800dc5:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800dc8:	c9                   	leave  
  800dc9:	c3                   	ret    

00800dca <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800dca:	55                   	push   %ebp
  800dcb:	89 e5                	mov    %esp,%ebp
  800dcd:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800dd0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800dd7:	eb 06                	jmp    800ddf <strlen+0x15>
		n++;
  800dd9:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800ddc:	ff 45 08             	incl   0x8(%ebp)
  800ddf:	8b 45 08             	mov    0x8(%ebp),%eax
  800de2:	8a 00                	mov    (%eax),%al
  800de4:	84 c0                	test   %al,%al
  800de6:	75 f1                	jne    800dd9 <strlen+0xf>
		n++;
	return n;
  800de8:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800deb:	c9                   	leave  
  800dec:	c3                   	ret    

00800ded <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800ded:	55                   	push   %ebp
  800dee:	89 e5                	mov    %esp,%ebp
  800df0:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800df3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800dfa:	eb 09                	jmp    800e05 <strnlen+0x18>
		n++;
  800dfc:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800dff:	ff 45 08             	incl   0x8(%ebp)
  800e02:	ff 4d 0c             	decl   0xc(%ebp)
  800e05:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e09:	74 09                	je     800e14 <strnlen+0x27>
  800e0b:	8b 45 08             	mov    0x8(%ebp),%eax
  800e0e:	8a 00                	mov    (%eax),%al
  800e10:	84 c0                	test   %al,%al
  800e12:	75 e8                	jne    800dfc <strnlen+0xf>
		n++;
	return n;
  800e14:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e17:	c9                   	leave  
  800e18:	c3                   	ret    

00800e19 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800e19:	55                   	push   %ebp
  800e1a:	89 e5                	mov    %esp,%ebp
  800e1c:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800e1f:	8b 45 08             	mov    0x8(%ebp),%eax
  800e22:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800e25:	90                   	nop
  800e26:	8b 45 08             	mov    0x8(%ebp),%eax
  800e29:	8d 50 01             	lea    0x1(%eax),%edx
  800e2c:	89 55 08             	mov    %edx,0x8(%ebp)
  800e2f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e32:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e35:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800e38:	8a 12                	mov    (%edx),%dl
  800e3a:	88 10                	mov    %dl,(%eax)
  800e3c:	8a 00                	mov    (%eax),%al
  800e3e:	84 c0                	test   %al,%al
  800e40:	75 e4                	jne    800e26 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800e42:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e45:	c9                   	leave  
  800e46:	c3                   	ret    

00800e47 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800e47:	55                   	push   %ebp
  800e48:	89 e5                	mov    %esp,%ebp
  800e4a:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800e4d:	8b 45 08             	mov    0x8(%ebp),%eax
  800e50:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800e53:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800e5a:	eb 1f                	jmp    800e7b <strncpy+0x34>
		*dst++ = *src;
  800e5c:	8b 45 08             	mov    0x8(%ebp),%eax
  800e5f:	8d 50 01             	lea    0x1(%eax),%edx
  800e62:	89 55 08             	mov    %edx,0x8(%ebp)
  800e65:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e68:	8a 12                	mov    (%edx),%dl
  800e6a:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800e6c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e6f:	8a 00                	mov    (%eax),%al
  800e71:	84 c0                	test   %al,%al
  800e73:	74 03                	je     800e78 <strncpy+0x31>
			src++;
  800e75:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800e78:	ff 45 fc             	incl   -0x4(%ebp)
  800e7b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e7e:	3b 45 10             	cmp    0x10(%ebp),%eax
  800e81:	72 d9                	jb     800e5c <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800e83:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800e86:	c9                   	leave  
  800e87:	c3                   	ret    

00800e88 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800e88:	55                   	push   %ebp
  800e89:	89 e5                	mov    %esp,%ebp
  800e8b:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800e8e:	8b 45 08             	mov    0x8(%ebp),%eax
  800e91:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800e94:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e98:	74 30                	je     800eca <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800e9a:	eb 16                	jmp    800eb2 <strlcpy+0x2a>
			*dst++ = *src++;
  800e9c:	8b 45 08             	mov    0x8(%ebp),%eax
  800e9f:	8d 50 01             	lea    0x1(%eax),%edx
  800ea2:	89 55 08             	mov    %edx,0x8(%ebp)
  800ea5:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ea8:	8d 4a 01             	lea    0x1(%edx),%ecx
  800eab:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800eae:	8a 12                	mov    (%edx),%dl
  800eb0:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800eb2:	ff 4d 10             	decl   0x10(%ebp)
  800eb5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800eb9:	74 09                	je     800ec4 <strlcpy+0x3c>
  800ebb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ebe:	8a 00                	mov    (%eax),%al
  800ec0:	84 c0                	test   %al,%al
  800ec2:	75 d8                	jne    800e9c <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800ec4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ec7:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800eca:	8b 55 08             	mov    0x8(%ebp),%edx
  800ecd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ed0:	29 c2                	sub    %eax,%edx
  800ed2:	89 d0                	mov    %edx,%eax
}
  800ed4:	c9                   	leave  
  800ed5:	c3                   	ret    

00800ed6 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800ed6:	55                   	push   %ebp
  800ed7:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800ed9:	eb 06                	jmp    800ee1 <strcmp+0xb>
		p++, q++;
  800edb:	ff 45 08             	incl   0x8(%ebp)
  800ede:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800ee1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ee4:	8a 00                	mov    (%eax),%al
  800ee6:	84 c0                	test   %al,%al
  800ee8:	74 0e                	je     800ef8 <strcmp+0x22>
  800eea:	8b 45 08             	mov    0x8(%ebp),%eax
  800eed:	8a 10                	mov    (%eax),%dl
  800eef:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ef2:	8a 00                	mov    (%eax),%al
  800ef4:	38 c2                	cmp    %al,%dl
  800ef6:	74 e3                	je     800edb <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800ef8:	8b 45 08             	mov    0x8(%ebp),%eax
  800efb:	8a 00                	mov    (%eax),%al
  800efd:	0f b6 d0             	movzbl %al,%edx
  800f00:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f03:	8a 00                	mov    (%eax),%al
  800f05:	0f b6 c0             	movzbl %al,%eax
  800f08:	29 c2                	sub    %eax,%edx
  800f0a:	89 d0                	mov    %edx,%eax
}
  800f0c:	5d                   	pop    %ebp
  800f0d:	c3                   	ret    

00800f0e <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800f0e:	55                   	push   %ebp
  800f0f:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800f11:	eb 09                	jmp    800f1c <strncmp+0xe>
		n--, p++, q++;
  800f13:	ff 4d 10             	decl   0x10(%ebp)
  800f16:	ff 45 08             	incl   0x8(%ebp)
  800f19:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800f1c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f20:	74 17                	je     800f39 <strncmp+0x2b>
  800f22:	8b 45 08             	mov    0x8(%ebp),%eax
  800f25:	8a 00                	mov    (%eax),%al
  800f27:	84 c0                	test   %al,%al
  800f29:	74 0e                	je     800f39 <strncmp+0x2b>
  800f2b:	8b 45 08             	mov    0x8(%ebp),%eax
  800f2e:	8a 10                	mov    (%eax),%dl
  800f30:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f33:	8a 00                	mov    (%eax),%al
  800f35:	38 c2                	cmp    %al,%dl
  800f37:	74 da                	je     800f13 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800f39:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f3d:	75 07                	jne    800f46 <strncmp+0x38>
		return 0;
  800f3f:	b8 00 00 00 00       	mov    $0x0,%eax
  800f44:	eb 14                	jmp    800f5a <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800f46:	8b 45 08             	mov    0x8(%ebp),%eax
  800f49:	8a 00                	mov    (%eax),%al
  800f4b:	0f b6 d0             	movzbl %al,%edx
  800f4e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f51:	8a 00                	mov    (%eax),%al
  800f53:	0f b6 c0             	movzbl %al,%eax
  800f56:	29 c2                	sub    %eax,%edx
  800f58:	89 d0                	mov    %edx,%eax
}
  800f5a:	5d                   	pop    %ebp
  800f5b:	c3                   	ret    

00800f5c <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800f5c:	55                   	push   %ebp
  800f5d:	89 e5                	mov    %esp,%ebp
  800f5f:	83 ec 04             	sub    $0x4,%esp
  800f62:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f65:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800f68:	eb 12                	jmp    800f7c <strchr+0x20>
		if (*s == c)
  800f6a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f6d:	8a 00                	mov    (%eax),%al
  800f6f:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800f72:	75 05                	jne    800f79 <strchr+0x1d>
			return (char *) s;
  800f74:	8b 45 08             	mov    0x8(%ebp),%eax
  800f77:	eb 11                	jmp    800f8a <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800f79:	ff 45 08             	incl   0x8(%ebp)
  800f7c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f7f:	8a 00                	mov    (%eax),%al
  800f81:	84 c0                	test   %al,%al
  800f83:	75 e5                	jne    800f6a <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800f85:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f8a:	c9                   	leave  
  800f8b:	c3                   	ret    

00800f8c <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800f8c:	55                   	push   %ebp
  800f8d:	89 e5                	mov    %esp,%ebp
  800f8f:	83 ec 04             	sub    $0x4,%esp
  800f92:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f95:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800f98:	eb 0d                	jmp    800fa7 <strfind+0x1b>
		if (*s == c)
  800f9a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f9d:	8a 00                	mov    (%eax),%al
  800f9f:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800fa2:	74 0e                	je     800fb2 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800fa4:	ff 45 08             	incl   0x8(%ebp)
  800fa7:	8b 45 08             	mov    0x8(%ebp),%eax
  800faa:	8a 00                	mov    (%eax),%al
  800fac:	84 c0                	test   %al,%al
  800fae:	75 ea                	jne    800f9a <strfind+0xe>
  800fb0:	eb 01                	jmp    800fb3 <strfind+0x27>
		if (*s == c)
			break;
  800fb2:	90                   	nop
	return (char *) s;
  800fb3:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800fb6:	c9                   	leave  
  800fb7:	c3                   	ret    

00800fb8 <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  800fb8:	55                   	push   %ebp
  800fb9:	89 e5                	mov    %esp,%ebp
  800fbb:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  800fbe:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  800fc4:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800fc8:	76 63                	jbe    80102d <memset+0x75>
		uint64 data_block = c;
  800fca:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fcd:	99                   	cltd   
  800fce:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800fd1:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  800fd4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800fd7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800fda:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  800fde:	c1 e0 08             	shl    $0x8,%eax
  800fe1:	09 45 f0             	or     %eax,-0x10(%ebp)
  800fe4:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  800fe7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800fea:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800fed:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  800ff1:	c1 e0 10             	shl    $0x10,%eax
  800ff4:	09 45 f0             	or     %eax,-0x10(%ebp)
  800ff7:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  800ffa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ffd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801000:	89 c2                	mov    %eax,%edx
  801002:	b8 00 00 00 00       	mov    $0x0,%eax
  801007:	09 45 f0             	or     %eax,-0x10(%ebp)
  80100a:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  80100d:	eb 18                	jmp    801027 <memset+0x6f>
			*p64++ = data_block, n -= 8;
  80100f:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801012:	8d 41 08             	lea    0x8(%ecx),%eax
  801015:	89 45 fc             	mov    %eax,-0x4(%ebp)
  801018:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80101b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80101e:	89 01                	mov    %eax,(%ecx)
  801020:	89 51 04             	mov    %edx,0x4(%ecx)
  801023:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  801027:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  80102b:	77 e2                	ja     80100f <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  80102d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801031:	74 23                	je     801056 <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  801033:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801036:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  801039:	eb 0e                	jmp    801049 <memset+0x91>
			*p8++ = (uint8)c;
  80103b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80103e:	8d 50 01             	lea    0x1(%eax),%edx
  801041:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801044:	8b 55 0c             	mov    0xc(%ebp),%edx
  801047:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  801049:	8b 45 10             	mov    0x10(%ebp),%eax
  80104c:	8d 50 ff             	lea    -0x1(%eax),%edx
  80104f:	89 55 10             	mov    %edx,0x10(%ebp)
  801052:	85 c0                	test   %eax,%eax
  801054:	75 e5                	jne    80103b <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  801056:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801059:	c9                   	leave  
  80105a:	c3                   	ret    

0080105b <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  80105b:	55                   	push   %ebp
  80105c:	89 e5                	mov    %esp,%ebp
  80105e:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  801061:	8b 45 0c             	mov    0xc(%ebp),%eax
  801064:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  801067:	8b 45 08             	mov    0x8(%ebp),%eax
  80106a:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  80106d:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801071:	76 24                	jbe    801097 <memcpy+0x3c>
		while(n >= 8){
  801073:	eb 1c                	jmp    801091 <memcpy+0x36>
			*d64 = *s64;
  801075:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801078:	8b 50 04             	mov    0x4(%eax),%edx
  80107b:	8b 00                	mov    (%eax),%eax
  80107d:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801080:	89 01                	mov    %eax,(%ecx)
  801082:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  801085:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  801089:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  80108d:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  801091:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801095:	77 de                	ja     801075 <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  801097:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80109b:	74 31                	je     8010ce <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  80109d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010a0:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  8010a3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010a6:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  8010a9:	eb 16                	jmp    8010c1 <memcpy+0x66>
			*d8++ = *s8++;
  8010ab:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8010ae:	8d 50 01             	lea    0x1(%eax),%edx
  8010b1:	89 55 f0             	mov    %edx,-0x10(%ebp)
  8010b4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8010b7:	8d 4a 01             	lea    0x1(%edx),%ecx
  8010ba:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  8010bd:	8a 12                	mov    (%edx),%dl
  8010bf:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  8010c1:	8b 45 10             	mov    0x10(%ebp),%eax
  8010c4:	8d 50 ff             	lea    -0x1(%eax),%edx
  8010c7:	89 55 10             	mov    %edx,0x10(%ebp)
  8010ca:	85 c0                	test   %eax,%eax
  8010cc:	75 dd                	jne    8010ab <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  8010ce:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8010d1:	c9                   	leave  
  8010d2:	c3                   	ret    

008010d3 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  8010d3:	55                   	push   %ebp
  8010d4:	89 e5                	mov    %esp,%ebp
  8010d6:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8010d9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010dc:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8010df:	8b 45 08             	mov    0x8(%ebp),%eax
  8010e2:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  8010e5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010e8:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8010eb:	73 50                	jae    80113d <memmove+0x6a>
  8010ed:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8010f0:	8b 45 10             	mov    0x10(%ebp),%eax
  8010f3:	01 d0                	add    %edx,%eax
  8010f5:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8010f8:	76 43                	jbe    80113d <memmove+0x6a>
		s += n;
  8010fa:	8b 45 10             	mov    0x10(%ebp),%eax
  8010fd:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801100:	8b 45 10             	mov    0x10(%ebp),%eax
  801103:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  801106:	eb 10                	jmp    801118 <memmove+0x45>
			*--d = *--s;
  801108:	ff 4d f8             	decl   -0x8(%ebp)
  80110b:	ff 4d fc             	decl   -0x4(%ebp)
  80110e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801111:	8a 10                	mov    (%eax),%dl
  801113:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801116:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  801118:	8b 45 10             	mov    0x10(%ebp),%eax
  80111b:	8d 50 ff             	lea    -0x1(%eax),%edx
  80111e:	89 55 10             	mov    %edx,0x10(%ebp)
  801121:	85 c0                	test   %eax,%eax
  801123:	75 e3                	jne    801108 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801125:	eb 23                	jmp    80114a <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  801127:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80112a:	8d 50 01             	lea    0x1(%eax),%edx
  80112d:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801130:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801133:	8d 4a 01             	lea    0x1(%edx),%ecx
  801136:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801139:	8a 12                	mov    (%edx),%dl
  80113b:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  80113d:	8b 45 10             	mov    0x10(%ebp),%eax
  801140:	8d 50 ff             	lea    -0x1(%eax),%edx
  801143:	89 55 10             	mov    %edx,0x10(%ebp)
  801146:	85 c0                	test   %eax,%eax
  801148:	75 dd                	jne    801127 <memmove+0x54>
			*d++ = *s++;

	return dst;
  80114a:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80114d:	c9                   	leave  
  80114e:	c3                   	ret    

0080114f <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  80114f:	55                   	push   %ebp
  801150:	89 e5                	mov    %esp,%ebp
  801152:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  801155:	8b 45 08             	mov    0x8(%ebp),%eax
  801158:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  80115b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80115e:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  801161:	eb 2a                	jmp    80118d <memcmp+0x3e>
		if (*s1 != *s2)
  801163:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801166:	8a 10                	mov    (%eax),%dl
  801168:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80116b:	8a 00                	mov    (%eax),%al
  80116d:	38 c2                	cmp    %al,%dl
  80116f:	74 16                	je     801187 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801171:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801174:	8a 00                	mov    (%eax),%al
  801176:	0f b6 d0             	movzbl %al,%edx
  801179:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80117c:	8a 00                	mov    (%eax),%al
  80117e:	0f b6 c0             	movzbl %al,%eax
  801181:	29 c2                	sub    %eax,%edx
  801183:	89 d0                	mov    %edx,%eax
  801185:	eb 18                	jmp    80119f <memcmp+0x50>
		s1++, s2++;
  801187:	ff 45 fc             	incl   -0x4(%ebp)
  80118a:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  80118d:	8b 45 10             	mov    0x10(%ebp),%eax
  801190:	8d 50 ff             	lea    -0x1(%eax),%edx
  801193:	89 55 10             	mov    %edx,0x10(%ebp)
  801196:	85 c0                	test   %eax,%eax
  801198:	75 c9                	jne    801163 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  80119a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80119f:	c9                   	leave  
  8011a0:	c3                   	ret    

008011a1 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  8011a1:	55                   	push   %ebp
  8011a2:	89 e5                	mov    %esp,%ebp
  8011a4:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  8011a7:	8b 55 08             	mov    0x8(%ebp),%edx
  8011aa:	8b 45 10             	mov    0x10(%ebp),%eax
  8011ad:	01 d0                	add    %edx,%eax
  8011af:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  8011b2:	eb 15                	jmp    8011c9 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  8011b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8011b7:	8a 00                	mov    (%eax),%al
  8011b9:	0f b6 d0             	movzbl %al,%edx
  8011bc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011bf:	0f b6 c0             	movzbl %al,%eax
  8011c2:	39 c2                	cmp    %eax,%edx
  8011c4:	74 0d                	je     8011d3 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8011c6:	ff 45 08             	incl   0x8(%ebp)
  8011c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8011cc:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8011cf:	72 e3                	jb     8011b4 <memfind+0x13>
  8011d1:	eb 01                	jmp    8011d4 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  8011d3:	90                   	nop
	return (void *) s;
  8011d4:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8011d7:	c9                   	leave  
  8011d8:	c3                   	ret    

008011d9 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8011d9:	55                   	push   %ebp
  8011da:	89 e5                	mov    %esp,%ebp
  8011dc:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  8011df:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  8011e6:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8011ed:	eb 03                	jmp    8011f2 <strtol+0x19>
		s++;
  8011ef:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8011f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8011f5:	8a 00                	mov    (%eax),%al
  8011f7:	3c 20                	cmp    $0x20,%al
  8011f9:	74 f4                	je     8011ef <strtol+0x16>
  8011fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8011fe:	8a 00                	mov    (%eax),%al
  801200:	3c 09                	cmp    $0x9,%al
  801202:	74 eb                	je     8011ef <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801204:	8b 45 08             	mov    0x8(%ebp),%eax
  801207:	8a 00                	mov    (%eax),%al
  801209:	3c 2b                	cmp    $0x2b,%al
  80120b:	75 05                	jne    801212 <strtol+0x39>
		s++;
  80120d:	ff 45 08             	incl   0x8(%ebp)
  801210:	eb 13                	jmp    801225 <strtol+0x4c>
	else if (*s == '-')
  801212:	8b 45 08             	mov    0x8(%ebp),%eax
  801215:	8a 00                	mov    (%eax),%al
  801217:	3c 2d                	cmp    $0x2d,%al
  801219:	75 0a                	jne    801225 <strtol+0x4c>
		s++, neg = 1;
  80121b:	ff 45 08             	incl   0x8(%ebp)
  80121e:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801225:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801229:	74 06                	je     801231 <strtol+0x58>
  80122b:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  80122f:	75 20                	jne    801251 <strtol+0x78>
  801231:	8b 45 08             	mov    0x8(%ebp),%eax
  801234:	8a 00                	mov    (%eax),%al
  801236:	3c 30                	cmp    $0x30,%al
  801238:	75 17                	jne    801251 <strtol+0x78>
  80123a:	8b 45 08             	mov    0x8(%ebp),%eax
  80123d:	40                   	inc    %eax
  80123e:	8a 00                	mov    (%eax),%al
  801240:	3c 78                	cmp    $0x78,%al
  801242:	75 0d                	jne    801251 <strtol+0x78>
		s += 2, base = 16;
  801244:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801248:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  80124f:	eb 28                	jmp    801279 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801251:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801255:	75 15                	jne    80126c <strtol+0x93>
  801257:	8b 45 08             	mov    0x8(%ebp),%eax
  80125a:	8a 00                	mov    (%eax),%al
  80125c:	3c 30                	cmp    $0x30,%al
  80125e:	75 0c                	jne    80126c <strtol+0x93>
		s++, base = 8;
  801260:	ff 45 08             	incl   0x8(%ebp)
  801263:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  80126a:	eb 0d                	jmp    801279 <strtol+0xa0>
	else if (base == 0)
  80126c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801270:	75 07                	jne    801279 <strtol+0xa0>
		base = 10;
  801272:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801279:	8b 45 08             	mov    0x8(%ebp),%eax
  80127c:	8a 00                	mov    (%eax),%al
  80127e:	3c 2f                	cmp    $0x2f,%al
  801280:	7e 19                	jle    80129b <strtol+0xc2>
  801282:	8b 45 08             	mov    0x8(%ebp),%eax
  801285:	8a 00                	mov    (%eax),%al
  801287:	3c 39                	cmp    $0x39,%al
  801289:	7f 10                	jg     80129b <strtol+0xc2>
			dig = *s - '0';
  80128b:	8b 45 08             	mov    0x8(%ebp),%eax
  80128e:	8a 00                	mov    (%eax),%al
  801290:	0f be c0             	movsbl %al,%eax
  801293:	83 e8 30             	sub    $0x30,%eax
  801296:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801299:	eb 42                	jmp    8012dd <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  80129b:	8b 45 08             	mov    0x8(%ebp),%eax
  80129e:	8a 00                	mov    (%eax),%al
  8012a0:	3c 60                	cmp    $0x60,%al
  8012a2:	7e 19                	jle    8012bd <strtol+0xe4>
  8012a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a7:	8a 00                	mov    (%eax),%al
  8012a9:	3c 7a                	cmp    $0x7a,%al
  8012ab:	7f 10                	jg     8012bd <strtol+0xe4>
			dig = *s - 'a' + 10;
  8012ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8012b0:	8a 00                	mov    (%eax),%al
  8012b2:	0f be c0             	movsbl %al,%eax
  8012b5:	83 e8 57             	sub    $0x57,%eax
  8012b8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8012bb:	eb 20                	jmp    8012dd <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  8012bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8012c0:	8a 00                	mov    (%eax),%al
  8012c2:	3c 40                	cmp    $0x40,%al
  8012c4:	7e 39                	jle    8012ff <strtol+0x126>
  8012c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8012c9:	8a 00                	mov    (%eax),%al
  8012cb:	3c 5a                	cmp    $0x5a,%al
  8012cd:	7f 30                	jg     8012ff <strtol+0x126>
			dig = *s - 'A' + 10;
  8012cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8012d2:	8a 00                	mov    (%eax),%al
  8012d4:	0f be c0             	movsbl %al,%eax
  8012d7:	83 e8 37             	sub    $0x37,%eax
  8012da:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  8012dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8012e0:	3b 45 10             	cmp    0x10(%ebp),%eax
  8012e3:	7d 19                	jge    8012fe <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  8012e5:	ff 45 08             	incl   0x8(%ebp)
  8012e8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012eb:	0f af 45 10          	imul   0x10(%ebp),%eax
  8012ef:	89 c2                	mov    %eax,%edx
  8012f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8012f4:	01 d0                	add    %edx,%eax
  8012f6:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8012f9:	e9 7b ff ff ff       	jmp    801279 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8012fe:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8012ff:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801303:	74 08                	je     80130d <strtol+0x134>
		*endptr = (char *) s;
  801305:	8b 45 0c             	mov    0xc(%ebp),%eax
  801308:	8b 55 08             	mov    0x8(%ebp),%edx
  80130b:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  80130d:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801311:	74 07                	je     80131a <strtol+0x141>
  801313:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801316:	f7 d8                	neg    %eax
  801318:	eb 03                	jmp    80131d <strtol+0x144>
  80131a:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80131d:	c9                   	leave  
  80131e:	c3                   	ret    

0080131f <ltostr>:

void
ltostr(long value, char *str)
{
  80131f:	55                   	push   %ebp
  801320:	89 e5                	mov    %esp,%ebp
  801322:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801325:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  80132c:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801333:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801337:	79 13                	jns    80134c <ltostr+0x2d>
	{
		neg = 1;
  801339:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801340:	8b 45 0c             	mov    0xc(%ebp),%eax
  801343:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801346:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801349:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  80134c:	8b 45 08             	mov    0x8(%ebp),%eax
  80134f:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801354:	99                   	cltd   
  801355:	f7 f9                	idiv   %ecx
  801357:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  80135a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80135d:	8d 50 01             	lea    0x1(%eax),%edx
  801360:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801363:	89 c2                	mov    %eax,%edx
  801365:	8b 45 0c             	mov    0xc(%ebp),%eax
  801368:	01 d0                	add    %edx,%eax
  80136a:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80136d:	83 c2 30             	add    $0x30,%edx
  801370:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801372:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801375:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80137a:	f7 e9                	imul   %ecx
  80137c:	c1 fa 02             	sar    $0x2,%edx
  80137f:	89 c8                	mov    %ecx,%eax
  801381:	c1 f8 1f             	sar    $0x1f,%eax
  801384:	29 c2                	sub    %eax,%edx
  801386:	89 d0                	mov    %edx,%eax
  801388:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  80138b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80138f:	75 bb                	jne    80134c <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801391:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801398:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80139b:	48                   	dec    %eax
  80139c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  80139f:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8013a3:	74 3d                	je     8013e2 <ltostr+0xc3>
		start = 1 ;
  8013a5:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8013ac:	eb 34                	jmp    8013e2 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  8013ae:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8013b1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013b4:	01 d0                	add    %edx,%eax
  8013b6:	8a 00                	mov    (%eax),%al
  8013b8:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8013bb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8013be:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013c1:	01 c2                	add    %eax,%edx
  8013c3:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8013c6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013c9:	01 c8                	add    %ecx,%eax
  8013cb:	8a 00                	mov    (%eax),%al
  8013cd:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8013cf:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8013d2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013d5:	01 c2                	add    %eax,%edx
  8013d7:	8a 45 eb             	mov    -0x15(%ebp),%al
  8013da:	88 02                	mov    %al,(%edx)
		start++ ;
  8013dc:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8013df:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8013e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8013e5:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8013e8:	7c c4                	jl     8013ae <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8013ea:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8013ed:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013f0:	01 d0                	add    %edx,%eax
  8013f2:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8013f5:	90                   	nop
  8013f6:	c9                   	leave  
  8013f7:	c3                   	ret    

008013f8 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8013f8:	55                   	push   %ebp
  8013f9:	89 e5                	mov    %esp,%ebp
  8013fb:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8013fe:	ff 75 08             	pushl  0x8(%ebp)
  801401:	e8 c4 f9 ff ff       	call   800dca <strlen>
  801406:	83 c4 04             	add    $0x4,%esp
  801409:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  80140c:	ff 75 0c             	pushl  0xc(%ebp)
  80140f:	e8 b6 f9 ff ff       	call   800dca <strlen>
  801414:	83 c4 04             	add    $0x4,%esp
  801417:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  80141a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801421:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801428:	eb 17                	jmp    801441 <strcconcat+0x49>
		final[s] = str1[s] ;
  80142a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80142d:	8b 45 10             	mov    0x10(%ebp),%eax
  801430:	01 c2                	add    %eax,%edx
  801432:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801435:	8b 45 08             	mov    0x8(%ebp),%eax
  801438:	01 c8                	add    %ecx,%eax
  80143a:	8a 00                	mov    (%eax),%al
  80143c:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  80143e:	ff 45 fc             	incl   -0x4(%ebp)
  801441:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801444:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801447:	7c e1                	jl     80142a <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801449:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801450:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801457:	eb 1f                	jmp    801478 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801459:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80145c:	8d 50 01             	lea    0x1(%eax),%edx
  80145f:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801462:	89 c2                	mov    %eax,%edx
  801464:	8b 45 10             	mov    0x10(%ebp),%eax
  801467:	01 c2                	add    %eax,%edx
  801469:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  80146c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80146f:	01 c8                	add    %ecx,%eax
  801471:	8a 00                	mov    (%eax),%al
  801473:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801475:	ff 45 f8             	incl   -0x8(%ebp)
  801478:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80147b:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80147e:	7c d9                	jl     801459 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801480:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801483:	8b 45 10             	mov    0x10(%ebp),%eax
  801486:	01 d0                	add    %edx,%eax
  801488:	c6 00 00             	movb   $0x0,(%eax)
}
  80148b:	90                   	nop
  80148c:	c9                   	leave  
  80148d:	c3                   	ret    

0080148e <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  80148e:	55                   	push   %ebp
  80148f:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801491:	8b 45 14             	mov    0x14(%ebp),%eax
  801494:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  80149a:	8b 45 14             	mov    0x14(%ebp),%eax
  80149d:	8b 00                	mov    (%eax),%eax
  80149f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8014a6:	8b 45 10             	mov    0x10(%ebp),%eax
  8014a9:	01 d0                	add    %edx,%eax
  8014ab:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8014b1:	eb 0c                	jmp    8014bf <strsplit+0x31>
			*string++ = 0;
  8014b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8014b6:	8d 50 01             	lea    0x1(%eax),%edx
  8014b9:	89 55 08             	mov    %edx,0x8(%ebp)
  8014bc:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8014bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8014c2:	8a 00                	mov    (%eax),%al
  8014c4:	84 c0                	test   %al,%al
  8014c6:	74 18                	je     8014e0 <strsplit+0x52>
  8014c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8014cb:	8a 00                	mov    (%eax),%al
  8014cd:	0f be c0             	movsbl %al,%eax
  8014d0:	50                   	push   %eax
  8014d1:	ff 75 0c             	pushl  0xc(%ebp)
  8014d4:	e8 83 fa ff ff       	call   800f5c <strchr>
  8014d9:	83 c4 08             	add    $0x8,%esp
  8014dc:	85 c0                	test   %eax,%eax
  8014de:	75 d3                	jne    8014b3 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8014e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8014e3:	8a 00                	mov    (%eax),%al
  8014e5:	84 c0                	test   %al,%al
  8014e7:	74 5a                	je     801543 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8014e9:	8b 45 14             	mov    0x14(%ebp),%eax
  8014ec:	8b 00                	mov    (%eax),%eax
  8014ee:	83 f8 0f             	cmp    $0xf,%eax
  8014f1:	75 07                	jne    8014fa <strsplit+0x6c>
		{
			return 0;
  8014f3:	b8 00 00 00 00       	mov    $0x0,%eax
  8014f8:	eb 66                	jmp    801560 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8014fa:	8b 45 14             	mov    0x14(%ebp),%eax
  8014fd:	8b 00                	mov    (%eax),%eax
  8014ff:	8d 48 01             	lea    0x1(%eax),%ecx
  801502:	8b 55 14             	mov    0x14(%ebp),%edx
  801505:	89 0a                	mov    %ecx,(%edx)
  801507:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80150e:	8b 45 10             	mov    0x10(%ebp),%eax
  801511:	01 c2                	add    %eax,%edx
  801513:	8b 45 08             	mov    0x8(%ebp),%eax
  801516:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801518:	eb 03                	jmp    80151d <strsplit+0x8f>
			string++;
  80151a:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  80151d:	8b 45 08             	mov    0x8(%ebp),%eax
  801520:	8a 00                	mov    (%eax),%al
  801522:	84 c0                	test   %al,%al
  801524:	74 8b                	je     8014b1 <strsplit+0x23>
  801526:	8b 45 08             	mov    0x8(%ebp),%eax
  801529:	8a 00                	mov    (%eax),%al
  80152b:	0f be c0             	movsbl %al,%eax
  80152e:	50                   	push   %eax
  80152f:	ff 75 0c             	pushl  0xc(%ebp)
  801532:	e8 25 fa ff ff       	call   800f5c <strchr>
  801537:	83 c4 08             	add    $0x8,%esp
  80153a:	85 c0                	test   %eax,%eax
  80153c:	74 dc                	je     80151a <strsplit+0x8c>
			string++;
	}
  80153e:	e9 6e ff ff ff       	jmp    8014b1 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801543:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801544:	8b 45 14             	mov    0x14(%ebp),%eax
  801547:	8b 00                	mov    (%eax),%eax
  801549:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801550:	8b 45 10             	mov    0x10(%ebp),%eax
  801553:	01 d0                	add    %edx,%eax
  801555:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  80155b:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801560:	c9                   	leave  
  801561:	c3                   	ret    

00801562 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  801562:	55                   	push   %ebp
  801563:	89 e5                	mov    %esp,%ebp
  801565:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  801568:	8b 45 08             	mov    0x8(%ebp),%eax
  80156b:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  80156e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801575:	eb 4a                	jmp    8015c1 <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  801577:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80157a:	8b 45 08             	mov    0x8(%ebp),%eax
  80157d:	01 c2                	add    %eax,%edx
  80157f:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801582:	8b 45 0c             	mov    0xc(%ebp),%eax
  801585:	01 c8                	add    %ecx,%eax
  801587:	8a 00                	mov    (%eax),%al
  801589:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  80158b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80158e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801591:	01 d0                	add    %edx,%eax
  801593:	8a 00                	mov    (%eax),%al
  801595:	3c 40                	cmp    $0x40,%al
  801597:	7e 25                	jle    8015be <str2lower+0x5c>
  801599:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80159c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80159f:	01 d0                	add    %edx,%eax
  8015a1:	8a 00                	mov    (%eax),%al
  8015a3:	3c 5a                	cmp    $0x5a,%al
  8015a5:	7f 17                	jg     8015be <str2lower+0x5c>
		{
			dst[i] += 32 ;
  8015a7:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8015aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8015ad:	01 d0                	add    %edx,%eax
  8015af:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8015b2:	8b 55 08             	mov    0x8(%ebp),%edx
  8015b5:	01 ca                	add    %ecx,%edx
  8015b7:	8a 12                	mov    (%edx),%dl
  8015b9:	83 c2 20             	add    $0x20,%edx
  8015bc:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  8015be:	ff 45 fc             	incl   -0x4(%ebp)
  8015c1:	ff 75 0c             	pushl  0xc(%ebp)
  8015c4:	e8 01 f8 ff ff       	call   800dca <strlen>
  8015c9:	83 c4 04             	add    $0x4,%esp
  8015cc:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8015cf:	7f a6                	jg     801577 <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  8015d1:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8015d4:	c9                   	leave  
  8015d5:	c3                   	ret    

008015d6 <uheap_init>:
//==============================================
// [1] INITIALIZE USER HEAP:
//==============================================
int __firstTimeFlag = 1;
void uheap_init()
{
  8015d6:	55                   	push   %ebp
  8015d7:	89 e5                	mov    %esp,%ebp
  8015d9:	83 ec 08             	sub    $0x8,%esp
	if(__firstTimeFlag)
  8015dc:	a1 08 60 80 00       	mov    0x806008,%eax
  8015e1:	85 c0                	test   %eax,%eax
  8015e3:	0f 84 95 00 00 00    	je     80167e <uheap_init+0xa8>
	{
		initialize_dynamic_allocator(USER_HEAP_START, USER_HEAP_START + DYN_ALLOC_MAX_SIZE);
  8015e9:	83 ec 08             	sub    $0x8,%esp
  8015ec:	68 00 00 00 82       	push   $0x82000000
  8015f1:	68 00 00 00 80       	push   $0x80000000
  8015f6:	e8 59 1f 00 00       	call   803554 <initialize_dynamic_allocator>
  8015fb:	83 c4 10             	add    $0x10,%esp
		uheapPlaceStrategy = sys_get_uheap_strategy();
  8015fe:	e8 93 1d 00 00       	call   803396 <sys_get_uheap_strategy>
  801603:	a3 60 e0 81 00       	mov    %eax,0x81e060
		uheapPageAllocStart = dynAllocEnd + PAGE_SIZE;
  801608:	a1 40 60 80 00       	mov    0x806040,%eax
  80160d:	05 00 10 00 00       	add    $0x1000,%eax
  801612:	a3 10 e1 81 00       	mov    %eax,0x81e110
		uheapPageAllocBreak = uheapPageAllocStart;
  801617:	a1 10 e1 81 00       	mov    0x81e110,%eax
  80161c:	a3 68 e0 81 00       	mov    %eax,0x81e068
		init_uspinlock(&ulock,"malloc",1);
  801621:	83 ec 04             	sub    $0x4,%esp
  801624:	6a 01                	push   $0x1
  801626:	68 68 4b 80 00       	push   $0x804b68
  80162b:	68 40 e1 81 00       	push   $0x81e140
  801630:	e8 1a 29 00 00       	call   803f4f <init_uspinlock>
  801635:	83 c4 10             	add    $0x10,%esp
		LIST_INIT(&u_freelist);
  801638:	c7 05 20 e1 81 00 00 	movl   $0x0,0x81e120
  80163f:	00 00 00 
  801642:	c7 05 24 e1 81 00 00 	movl   $0x0,0x81e124
  801649:	00 00 00 
  80164c:	c7 05 2c e1 81 00 00 	movl   $0x0,0x81e12c
  801653:	00 00 00 
		LIST_INIT(&u_allocatedlist);
  801656:	c7 05 30 e1 81 00 00 	movl   $0x0,0x81e130
  80165d:	00 00 00 
  801660:	c7 05 34 e1 81 00 00 	movl   $0x0,0x81e134
  801667:	00 00 00 
  80166a:	c7 05 3c e1 81 00 00 	movl   $0x0,0x81e13c
  801671:	00 00 00 
		__firstTimeFlag = 0;
  801674:	c7 05 08 60 80 00 00 	movl   $0x0,0x806008
  80167b:	00 00 00 
	}
}
  80167e:	90                   	nop
  80167f:	c9                   	leave  
  801680:	c3                   	ret    

00801681 <get_page>:

//==============================================
// [2] GET A PAGE FROM THE KERNEL FOR DA:
//==============================================
int get_page(void* va)
{
  801681:	55                   	push   %ebp
  801682:	89 e5                	mov    %esp,%ebp
  801684:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_allocate_page(ROUNDDOWN(va, PAGE_SIZE), PERM_USER|PERM_WRITEABLE|PERM_UHPAGE);
  801687:	8b 45 08             	mov    0x8(%ebp),%eax
  80168a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80168d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801690:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801695:	83 ec 08             	sub    $0x8,%esp
  801698:	68 06 04 00 00       	push   $0x406
  80169d:	50                   	push   %eax
  80169e:	e8 3d 19 00 00       	call   802fe0 <__sys_allocate_page>
  8016a3:	83 c4 10             	add    $0x10,%esp
  8016a6:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  8016a9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8016ad:	79 14                	jns    8016c3 <get_page+0x42>
		panic("get_page() in user: failed to allocate page from the kernel");
  8016af:	83 ec 04             	sub    $0x4,%esp
  8016b2:	68 70 4b 80 00       	push   $0x804b70
  8016b7:	6a 2d                	push   $0x2d
  8016b9:	68 ac 4b 80 00       	push   $0x804bac
  8016be:	e8 94 29 00 00       	call   804057 <_panic>
	return 0;
  8016c3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8016c8:	c9                   	leave  
  8016c9:	c3                   	ret    

008016ca <return_page>:

//==============================================
// [3] RETURN A PAGE FROM THE DA TO KERNEL:
//==============================================
void return_page(void* va)
{
  8016ca:	55                   	push   %ebp
  8016cb:	89 e5                	mov    %esp,%ebp
  8016cd:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_unmap_frame(ROUNDDOWN((uint32)va, PAGE_SIZE));
  8016d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8016d3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8016d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016d9:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8016de:	83 ec 0c             	sub    $0xc,%esp
  8016e1:	50                   	push   %eax
  8016e2:	e8 40 19 00 00       	call   803027 <__sys_unmap_frame>
  8016e7:	83 c4 10             	add    $0x10,%esp
  8016ea:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  8016ed:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8016f1:	79 14                	jns    801707 <return_page+0x3d>
		panic("return_page() in user: failed to return a page to the kernel");
  8016f3:	83 ec 04             	sub    $0x4,%esp
  8016f6:	68 b8 4b 80 00       	push   $0x804bb8
  8016fb:	6a 38                	push   $0x38
  8016fd:	68 ac 4b 80 00       	push   $0x804bac
  801702:	e8 50 29 00 00       	call   804057 <_panic>
}
  801707:	90                   	nop
  801708:	c9                   	leave  
  801709:	c3                   	ret    

0080170a <malloc>:

//=================================
// [1] ALLOCATE SPACE IN USER HEAP:
//=================================
void* malloc(uint32 size)
{
  80170a:	55                   	push   %ebp
  80170b:	89 e5                	mov    %esp,%ebp
  80170d:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  801710:	e8 c1 fe ff ff       	call   8015d6 <uheap_init>
	if (size == 0) return NULL ;
  801715:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801719:	75 0a                	jne    801725 <malloc+0x1b>
  80171b:	b8 00 00 00 00       	mov    $0x0,%eax
  801720:	e9 e1 04 00 00       	jmp    801c06 <malloc+0x4fc>
	//==============================================================

	acquire_uspinlock(&ulock);
  801725:	83 ec 0c             	sub    $0xc,%esp
  801728:	68 40 e1 81 00       	push   $0x81e140
  80172d:	e8 6c 28 00 00       	call   803f9e <acquire_uspinlock>
  801732:	83 c4 10             	add    $0x10,%esp
	if(size <  DYN_ALLOC_MAX_BLOCK_SIZE){
  801735:	81 7d 08 ff 07 00 00 	cmpl   $0x7ff,0x8(%ebp)
  80173c:	77 23                	ja     801761 <malloc+0x57>
		release_uspinlock(&ulock);
  80173e:	83 ec 0c             	sub    $0xc,%esp
  801741:	68 40 e1 81 00       	push   $0x81e140
  801746:	e8 ab 28 00 00       	call   803ff6 <release_uspinlock>
  80174b:	83 c4 10             	add    $0x10,%esp
		return alloc_block(size);
  80174e:	83 ec 0c             	sub    $0xc,%esp
  801751:	ff 75 08             	pushl  0x8(%ebp)
  801754:	e8 dd 1f 00 00       	call   803736 <alloc_block>
  801759:	83 c4 10             	add    $0x10,%esp
  80175c:	e9 a5 04 00 00       	jmp    801c06 <malloc+0x4fc>
	}

	struct UserHeapStruct* allocblock= (struct UserHeapStruct*) alloc_block(sizeof(struct UserHeapStruct));
  801761:	83 ec 0c             	sub    $0xc,%esp
  801764:	6a 10                	push   $0x10
  801766:	e8 cb 1f 00 00       	call   803736 <alloc_block>
  80176b:	83 c4 10             	add    $0x10,%esp
  80176e:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (allocblock == NULL){
  801771:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801775:	75 0a                	jne    801781 <malloc+0x77>
			return NULL;
  801777:	b8 00 00 00 00       	mov    $0x0,%eax
  80177c:	e9 85 04 00 00       	jmp    801c06 <malloc+0x4fc>
	}

	size = ROUNDUP(size,PAGE_SIZE);
  801781:	c7 45 e8 00 10 00 00 	movl   $0x1000,-0x18(%ebp)
  801788:	8b 55 08             	mov    0x8(%ebp),%edx
  80178b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80178e:	01 d0                	add    %edx,%eax
  801790:	48                   	dec    %eax
  801791:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801794:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801797:	ba 00 00 00 00       	mov    $0x0,%edx
  80179c:	f7 75 e8             	divl   -0x18(%ebp)
  80179f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8017a2:	29 d0                	sub    %edx,%eax
  8017a4:	89 45 08             	mov    %eax,0x8(%ebp)
	struct UserHeapStruct* lastfreeelement = LIST_LAST(&u_freelist);
  8017a7:	a1 24 e1 81 00       	mov    0x81e124,%eax
  8017ac:	89 45 e0             	mov    %eax,-0x20(%ebp)

	if(LIST_SIZE(&u_freelist)==0 || size>lastfreeelement->size){
  8017af:	a1 2c e1 81 00       	mov    0x81e12c,%eax
  8017b4:	85 c0                	test   %eax,%eax
  8017b6:	74 0f                	je     8017c7 <malloc+0xbd>
  8017b8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8017bb:	8b 40 04             	mov    0x4(%eax),%eax
  8017be:	3b 45 08             	cmp    0x8(%ebp),%eax
  8017c1:	0f 83 ea 00 00 00    	jae    8018b1 <malloc+0x1a7>
			if(uheapPageAllocBreak < USER_HEAP_MAX - size){
  8017c7:	b8 00 00 00 a0       	mov    $0xa0000000,%eax
  8017cc:	2b 45 08             	sub    0x8(%ebp),%eax
  8017cf:	89 c2                	mov    %eax,%edx
  8017d1:	a1 68 e0 81 00       	mov    0x81e068,%eax
  8017d6:	39 c2                	cmp    %eax,%edx
  8017d8:	0f 86 b9 00 00 00    	jbe    801897 <malloc+0x18d>
					uint32 requestedblockva = uheapPageAllocBreak;
  8017de:	a1 68 e0 81 00       	mov    0x81e068,%eax
  8017e3:	89 45 dc             	mov    %eax,-0x24(%ebp)
					uheapPageAllocBreak+=size;
  8017e6:	8b 15 68 e0 81 00    	mov    0x81e068,%edx
  8017ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8017ef:	01 d0                	add    %edx,%eax
  8017f1:	a3 68 e0 81 00       	mov    %eax,0x81e068
					allocblock->startva = requestedblockva;
  8017f6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8017f9:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8017fc:	89 10                	mov    %edx,(%eax)
					allocblock->size = size;
  8017fe:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801801:	8b 55 08             	mov    0x8(%ebp),%edx
  801804:	89 50 04             	mov    %edx,0x4(%eax)

					LIST_INSERT_TAIL(&u_allocatedlist, allocblock);
  801807:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80180b:	75 14                	jne    801821 <malloc+0x117>
  80180d:	83 ec 04             	sub    $0x4,%esp
  801810:	68 f8 4b 80 00       	push   $0x804bf8
  801815:	6a 60                	push   $0x60
  801817:	68 ac 4b 80 00       	push   $0x804bac
  80181c:	e8 36 28 00 00       	call   804057 <_panic>
  801821:	8b 15 34 e1 81 00    	mov    0x81e134,%edx
  801827:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80182a:	89 50 0c             	mov    %edx,0xc(%eax)
  80182d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801830:	8b 40 0c             	mov    0xc(%eax),%eax
  801833:	85 c0                	test   %eax,%eax
  801835:	74 0d                	je     801844 <malloc+0x13a>
  801837:	a1 34 e1 81 00       	mov    0x81e134,%eax
  80183c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80183f:	89 50 08             	mov    %edx,0x8(%eax)
  801842:	eb 08                	jmp    80184c <malloc+0x142>
  801844:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801847:	a3 30 e1 81 00       	mov    %eax,0x81e130
  80184c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80184f:	a3 34 e1 81 00       	mov    %eax,0x81e134
  801854:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801857:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  80185e:	a1 3c e1 81 00       	mov    0x81e13c,%eax
  801863:	40                   	inc    %eax
  801864:	a3 3c e1 81 00       	mov    %eax,0x81e13c


					sys_allocate_user_mem(allocblock->startva ,size);
  801869:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80186c:	8b 00                	mov    (%eax),%eax
  80186e:	83 ec 08             	sub    $0x8,%esp
  801871:	ff 75 08             	pushl  0x8(%ebp)
  801874:	50                   	push   %eax
  801875:	e8 34 1c 00 00       	call   8034ae <sys_allocate_user_mem>
  80187a:	83 c4 10             	add    $0x10,%esp
					release_uspinlock(&ulock);
  80187d:	83 ec 0c             	sub    $0xc,%esp
  801880:	68 40 e1 81 00       	push   $0x81e140
  801885:	e8 6c 27 00 00       	call   803ff6 <release_uspinlock>
  80188a:	83 c4 10             	add    $0x10,%esp
					return (void*)allocblock->startva;
  80188d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801890:	8b 00                	mov    (%eax),%eax
  801892:	e9 6f 03 00 00       	jmp    801c06 <malloc+0x4fc>
			}else{
					release_uspinlock(&ulock);
  801897:	83 ec 0c             	sub    $0xc,%esp
  80189a:	68 40 e1 81 00       	push   $0x81e140
  80189f:	e8 52 27 00 00       	call   803ff6 <release_uspinlock>
  8018a4:	83 c4 10             	add    $0x10,%esp
					return NULL;
  8018a7:	b8 00 00 00 00       	mov    $0x0,%eax
  8018ac:	e9 55 03 00 00       	jmp    801c06 <malloc+0x4fc>
				}
	}else{
		//custom fit
		struct UserHeapStruct* currentfreeelement = LIST_FIRST(&u_freelist);
  8018b1:	a1 20 e1 81 00       	mov    0x81e120,%eax
  8018b6:	89 45 f4             	mov    %eax,-0xc(%ebp)
		//worst fit
		while(currentfreeelement != NULL){
  8018b9:	e9 39 03 00 00       	jmp    801bf7 <malloc+0x4ed>
			if(size<currentfreeelement->size){
  8018be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018c1:	8b 40 04             	mov    0x4(%eax),%eax
  8018c4:	3b 45 08             	cmp    0x8(%ebp),%eax
  8018c7:	0f 86 e7 01 00 00    	jbe    801ab4 <malloc+0x3aa>
				allocblock->startva = lastfreeelement->startva;
  8018cd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8018d0:	8b 10                	mov    (%eax),%edx
  8018d2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8018d5:	89 10                	mov    %edx,(%eax)
                allocblock->size = size;
  8018d7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8018da:	8b 55 08             	mov    0x8(%ebp),%edx
  8018dd:	89 50 04             	mov    %edx,0x4(%eax)
                LIST_INSERT_TAIL(&u_allocatedlist,allocblock);
  8018e0:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8018e4:	75 14                	jne    8018fa <malloc+0x1f0>
  8018e6:	83 ec 04             	sub    $0x4,%esp
  8018e9:	68 f8 4b 80 00       	push   $0x804bf8
  8018ee:	6a 72                	push   $0x72
  8018f0:	68 ac 4b 80 00       	push   $0x804bac
  8018f5:	e8 5d 27 00 00       	call   804057 <_panic>
  8018fa:	8b 15 34 e1 81 00    	mov    0x81e134,%edx
  801900:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801903:	89 50 0c             	mov    %edx,0xc(%eax)
  801906:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801909:	8b 40 0c             	mov    0xc(%eax),%eax
  80190c:	85 c0                	test   %eax,%eax
  80190e:	74 0d                	je     80191d <malloc+0x213>
  801910:	a1 34 e1 81 00       	mov    0x81e134,%eax
  801915:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801918:	89 50 08             	mov    %edx,0x8(%eax)
  80191b:	eb 08                	jmp    801925 <malloc+0x21b>
  80191d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801920:	a3 30 e1 81 00       	mov    %eax,0x81e130
  801925:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801928:	a3 34 e1 81 00       	mov    %eax,0x81e134
  80192d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801930:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  801937:	a1 3c e1 81 00       	mov    0x81e13c,%eax
  80193c:	40                   	inc    %eax
  80193d:	a3 3c e1 81 00       	mov    %eax,0x81e13c
                lastfreeelement->startva += size;
  801942:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801945:	8b 10                	mov    (%eax),%edx
  801947:	8b 45 08             	mov    0x8(%ebp),%eax
  80194a:	01 c2                	add    %eax,%edx
  80194c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80194f:	89 10                	mov    %edx,(%eax)
                lastfreeelement->size -= size;
  801951:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801954:	8b 40 04             	mov    0x4(%eax),%eax
  801957:	2b 45 08             	sub    0x8(%ebp),%eax
  80195a:	89 c2                	mov    %eax,%edx
  80195c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80195f:	89 50 04             	mov    %edx,0x4(%eax)
                struct UserHeapStruct* currentfree2 = LIST_FIRST(&u_freelist);
  801962:	a1 20 e1 81 00       	mov    0x81e120,%eax
  801967:	89 45 f0             	mov    %eax,-0x10(%ebp)
                //check order of last element

                while (currentfree2 != NULL){
  80196a:	e9 0d 01 00 00       	jmp    801a7c <malloc+0x372>
                	if(lastfreeelement->size <currentfree2->size){
  80196f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801972:	8b 50 04             	mov    0x4(%eax),%edx
  801975:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801978:	8b 40 04             	mov    0x4(%eax),%eax
  80197b:	39 c2                	cmp    %eax,%edx
  80197d:	0f 83 f0 00 00 00    	jae    801a73 <malloc+0x369>
                		LIST_REMOVE(&u_freelist ,lastfreeelement);
  801983:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801987:	75 14                	jne    80199d <malloc+0x293>
  801989:	83 ec 04             	sub    $0x4,%esp
  80198c:	68 1b 4c 80 00       	push   $0x804c1b
  801991:	6a 7a                	push   $0x7a
  801993:	68 ac 4b 80 00       	push   $0x804bac
  801998:	e8 ba 26 00 00       	call   804057 <_panic>
  80199d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8019a0:	8b 40 08             	mov    0x8(%eax),%eax
  8019a3:	85 c0                	test   %eax,%eax
  8019a5:	74 11                	je     8019b8 <malloc+0x2ae>
  8019a7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8019aa:	8b 40 08             	mov    0x8(%eax),%eax
  8019ad:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8019b0:	8b 52 0c             	mov    0xc(%edx),%edx
  8019b3:	89 50 0c             	mov    %edx,0xc(%eax)
  8019b6:	eb 0b                	jmp    8019c3 <malloc+0x2b9>
  8019b8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8019bb:	8b 40 0c             	mov    0xc(%eax),%eax
  8019be:	a3 24 e1 81 00       	mov    %eax,0x81e124
  8019c3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8019c6:	8b 40 0c             	mov    0xc(%eax),%eax
  8019c9:	85 c0                	test   %eax,%eax
  8019cb:	74 11                	je     8019de <malloc+0x2d4>
  8019cd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8019d0:	8b 40 0c             	mov    0xc(%eax),%eax
  8019d3:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8019d6:	8b 52 08             	mov    0x8(%edx),%edx
  8019d9:	89 50 08             	mov    %edx,0x8(%eax)
  8019dc:	eb 0b                	jmp    8019e9 <malloc+0x2df>
  8019de:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8019e1:	8b 40 08             	mov    0x8(%eax),%eax
  8019e4:	a3 20 e1 81 00       	mov    %eax,0x81e120
  8019e9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8019ec:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  8019f3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8019f6:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  8019fd:	a1 2c e1 81 00       	mov    0x81e12c,%eax
  801a02:	48                   	dec    %eax
  801a03:	a3 2c e1 81 00       	mov    %eax,0x81e12c
                		LIST_INSERT_BEFORE(&u_freelist ,currentfree2 ,lastfreeelement);
  801a08:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801a0c:	74 06                	je     801a14 <malloc+0x30a>
  801a0e:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801a12:	75 14                	jne    801a28 <malloc+0x31e>
  801a14:	83 ec 04             	sub    $0x4,%esp
  801a17:	68 3c 4c 80 00       	push   $0x804c3c
  801a1c:	6a 7b                	push   $0x7b
  801a1e:	68 ac 4b 80 00       	push   $0x804bac
  801a23:	e8 2f 26 00 00       	call   804057 <_panic>
  801a28:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a2b:	8b 50 0c             	mov    0xc(%eax),%edx
  801a2e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801a31:	89 50 0c             	mov    %edx,0xc(%eax)
  801a34:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801a37:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801a3a:	89 50 08             	mov    %edx,0x8(%eax)
  801a3d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a40:	8b 40 0c             	mov    0xc(%eax),%eax
  801a43:	85 c0                	test   %eax,%eax
  801a45:	74 0e                	je     801a55 <malloc+0x34b>
  801a47:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a4a:	8b 40 0c             	mov    0xc(%eax),%eax
  801a4d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801a50:	89 50 08             	mov    %edx,0x8(%eax)
  801a53:	eb 08                	jmp    801a5d <malloc+0x353>
  801a55:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801a58:	a3 20 e1 81 00       	mov    %eax,0x81e120
  801a5d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a60:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801a63:	89 50 0c             	mov    %edx,0xc(%eax)
  801a66:	a1 2c e1 81 00       	mov    0x81e12c,%eax
  801a6b:	40                   	inc    %eax
  801a6c:	a3 2c e1 81 00       	mov    %eax,0x81e12c
                		break;
  801a71:	eb 13                	jmp    801a86 <malloc+0x37c>
                	}
                	currentfree2 = currentfree2->prev_next_info.le_next;
  801a73:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a76:	8b 40 08             	mov    0x8(%eax),%eax
  801a79:	89 45 f0             	mov    %eax,-0x10(%ebp)
                lastfreeelement->startva += size;
                lastfreeelement->size -= size;
                struct UserHeapStruct* currentfree2 = LIST_FIRST(&u_freelist);
                //check order of last element

                while (currentfree2 != NULL){
  801a7c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801a80:	0f 85 e9 fe ff ff    	jne    80196f <malloc+0x265>
                	}
                	currentfree2 = currentfree2->prev_next_info.le_next;
                }


                sys_allocate_user_mem(allocblock->startva ,size);
  801a86:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801a89:	8b 00                	mov    (%eax),%eax
  801a8b:	83 ec 08             	sub    $0x8,%esp
  801a8e:	ff 75 08             	pushl  0x8(%ebp)
  801a91:	50                   	push   %eax
  801a92:	e8 17 1a 00 00       	call   8034ae <sys_allocate_user_mem>
  801a97:	83 c4 10             	add    $0x10,%esp
                release_uspinlock(&ulock);
  801a9a:	83 ec 0c             	sub    $0xc,%esp
  801a9d:	68 40 e1 81 00       	push   $0x81e140
  801aa2:	e8 4f 25 00 00       	call   803ff6 <release_uspinlock>
  801aa7:	83 c4 10             	add    $0x10,%esp
                return (void*)allocblock->startva;
  801aaa:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801aad:	8b 00                	mov    (%eax),%eax
  801aaf:	e9 52 01 00 00       	jmp    801c06 <malloc+0x4fc>
                //exact fit
			}else if(size == currentfreeelement->size){
  801ab4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ab7:	8b 40 04             	mov    0x4(%eax),%eax
  801aba:	3b 45 08             	cmp    0x8(%ebp),%eax
  801abd:	0f 85 2b 01 00 00    	jne    801bee <malloc+0x4e4>
				allocblock->startva = currentfreeelement->startva;
  801ac3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ac6:	8b 10                	mov    (%eax),%edx
  801ac8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801acb:	89 10                	mov    %edx,(%eax)
				allocblock->size = size;
  801acd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801ad0:	8b 55 08             	mov    0x8(%ebp),%edx
  801ad3:	89 50 04             	mov    %edx,0x4(%eax)
				LIST_INSERT_TAIL(&u_allocatedlist ,allocblock);
  801ad6:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801ada:	75 17                	jne    801af3 <malloc+0x3e9>
  801adc:	83 ec 04             	sub    $0x4,%esp
  801adf:	68 f8 4b 80 00       	push   $0x804bf8
  801ae4:	68 89 00 00 00       	push   $0x89
  801ae9:	68 ac 4b 80 00       	push   $0x804bac
  801aee:	e8 64 25 00 00       	call   804057 <_panic>
  801af3:	8b 15 34 e1 81 00    	mov    0x81e134,%edx
  801af9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801afc:	89 50 0c             	mov    %edx,0xc(%eax)
  801aff:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801b02:	8b 40 0c             	mov    0xc(%eax),%eax
  801b05:	85 c0                	test   %eax,%eax
  801b07:	74 0d                	je     801b16 <malloc+0x40c>
  801b09:	a1 34 e1 81 00       	mov    0x81e134,%eax
  801b0e:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801b11:	89 50 08             	mov    %edx,0x8(%eax)
  801b14:	eb 08                	jmp    801b1e <malloc+0x414>
  801b16:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801b19:	a3 30 e1 81 00       	mov    %eax,0x81e130
  801b1e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801b21:	a3 34 e1 81 00       	mov    %eax,0x81e134
  801b26:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801b29:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  801b30:	a1 3c e1 81 00       	mov    0x81e13c,%eax
  801b35:	40                   	inc    %eax
  801b36:	a3 3c e1 81 00       	mov    %eax,0x81e13c
				LIST_REMOVE(&u_freelist ,currentfreeelement);
  801b3b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801b3f:	75 17                	jne    801b58 <malloc+0x44e>
  801b41:	83 ec 04             	sub    $0x4,%esp
  801b44:	68 1b 4c 80 00       	push   $0x804c1b
  801b49:	68 8a 00 00 00       	push   $0x8a
  801b4e:	68 ac 4b 80 00       	push   $0x804bac
  801b53:	e8 ff 24 00 00       	call   804057 <_panic>
  801b58:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b5b:	8b 40 08             	mov    0x8(%eax),%eax
  801b5e:	85 c0                	test   %eax,%eax
  801b60:	74 11                	je     801b73 <malloc+0x469>
  801b62:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b65:	8b 40 08             	mov    0x8(%eax),%eax
  801b68:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801b6b:	8b 52 0c             	mov    0xc(%edx),%edx
  801b6e:	89 50 0c             	mov    %edx,0xc(%eax)
  801b71:	eb 0b                	jmp    801b7e <malloc+0x474>
  801b73:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b76:	8b 40 0c             	mov    0xc(%eax),%eax
  801b79:	a3 24 e1 81 00       	mov    %eax,0x81e124
  801b7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b81:	8b 40 0c             	mov    0xc(%eax),%eax
  801b84:	85 c0                	test   %eax,%eax
  801b86:	74 11                	je     801b99 <malloc+0x48f>
  801b88:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b8b:	8b 40 0c             	mov    0xc(%eax),%eax
  801b8e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801b91:	8b 52 08             	mov    0x8(%edx),%edx
  801b94:	89 50 08             	mov    %edx,0x8(%eax)
  801b97:	eb 0b                	jmp    801ba4 <malloc+0x49a>
  801b99:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b9c:	8b 40 08             	mov    0x8(%eax),%eax
  801b9f:	a3 20 e1 81 00       	mov    %eax,0x81e120
  801ba4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ba7:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  801bae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bb1:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  801bb8:	a1 2c e1 81 00       	mov    0x81e12c,%eax
  801bbd:	48                   	dec    %eax
  801bbe:	a3 2c e1 81 00       	mov    %eax,0x81e12c
				sys_allocate_user_mem(allocblock->startva ,size);
  801bc3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801bc6:	8b 00                	mov    (%eax),%eax
  801bc8:	83 ec 08             	sub    $0x8,%esp
  801bcb:	ff 75 08             	pushl  0x8(%ebp)
  801bce:	50                   	push   %eax
  801bcf:	e8 da 18 00 00       	call   8034ae <sys_allocate_user_mem>
  801bd4:	83 c4 10             	add    $0x10,%esp
				release_uspinlock(&ulock);
  801bd7:	83 ec 0c             	sub    $0xc,%esp
  801bda:	68 40 e1 81 00       	push   $0x81e140
  801bdf:	e8 12 24 00 00       	call   803ff6 <release_uspinlock>
  801be4:	83 c4 10             	add    $0x10,%esp
				return (void*)allocblock->startva;
  801be7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801bea:	8b 00                	mov    (%eax),%eax
  801bec:	eb 18                	jmp    801c06 <malloc+0x4fc>
			}
			currentfreeelement = currentfreeelement->prev_next_info.le_next;
  801bee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bf1:	8b 40 08             	mov    0x8(%eax),%eax
  801bf4:	89 45 f4             	mov    %eax,-0xc(%ebp)
				}
	}else{
		//custom fit
		struct UserHeapStruct* currentfreeelement = LIST_FIRST(&u_freelist);
		//worst fit
		while(currentfreeelement != NULL){
  801bf7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801bfb:	0f 85 bd fc ff ff    	jne    8018be <malloc+0x1b4>
				return (void*)allocblock->startva;
			}
			currentfreeelement = currentfreeelement->prev_next_info.le_next;
		}
	}
	 return NULL;
  801c01:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c06:	c9                   	leave  
  801c07:	c3                   	ret    

00801c08 <free>:

//=================================
// [2] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
  801c08:	55                   	push   %ebp
  801c09:	89 e5                	mov    %esp,%ebp
  801c0b:	83 ec 38             	sub    $0x38,%esp
	uint32  VA = ROUNDDOWN(((uint32 ) virtual_address), PAGE_SIZE);
  801c0e:	8b 45 08             	mov    0x8(%ebp),%eax
  801c11:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801c14:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801c17:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801c1c:	89 45 d8             	mov    %eax,-0x28(%ebp)


		uheap_init();
  801c1f:	e8 b2 f9 ff ff       	call   8015d6 <uheap_init>
		acquire_uspinlock(&ulock);
  801c24:	83 ec 0c             	sub    $0xc,%esp
  801c27:	68 40 e1 81 00       	push   $0x81e140
  801c2c:	e8 6d 23 00 00       	call   803f9e <acquire_uspinlock>
  801c31:	83 c4 10             	add    $0x10,%esp
		if (VA < uheapPageAllocStart){
  801c34:	a1 10 e1 81 00       	mov    0x81e110,%eax
  801c39:	39 45 d8             	cmp    %eax,-0x28(%ebp)
  801c3c:	73 23                	jae    801c61 <free+0x59>
			free_block(virtual_address);
  801c3e:	83 ec 0c             	sub    $0xc,%esp
  801c41:	ff 75 08             	pushl  0x8(%ebp)
  801c44:	e8 89 1f 00 00       	call   803bd2 <free_block>
  801c49:	83 c4 10             	add    $0x10,%esp
			release_uspinlock(&ulock);
  801c4c:	83 ec 0c             	sub    $0xc,%esp
  801c4f:	68 40 e1 81 00       	push   $0x81e140
  801c54:	e8 9d 23 00 00       	call   803ff6 <release_uspinlock>
  801c59:	83 c4 10             	add    $0x10,%esp
			return;
  801c5c:	e9 35 07 00 00       	jmp    802396 <free+0x78e>
		}
		if (VA >= uheapPageAllocBreak){
  801c61:	a1 68 e0 81 00       	mov    0x81e068,%eax
  801c66:	39 45 d8             	cmp    %eax,-0x28(%ebp)
  801c69:	72 30                	jb     801c9b <free+0x93>
			cprintf("%d\n %d\n", VA, uheapPageAllocBreak);
  801c6b:	a1 68 e0 81 00       	mov    0x81e068,%eax
  801c70:	83 ec 04             	sub    $0x4,%esp
  801c73:	50                   	push   %eax
  801c74:	ff 75 d8             	pushl  -0x28(%ebp)
  801c77:	68 71 4c 80 00       	push   $0x804c71
  801c7c:	e8 70 ea ff ff       	call   8006f1 <cprintf>
  801c81:	83 c4 10             	add    $0x10,%esp

			panic("freeing from restricted area");
  801c84:	83 ec 04             	sub    $0x4,%esp
  801c87:	68 79 4c 80 00       	push   $0x804c79
  801c8c:	68 a7 00 00 00       	push   $0xa7
  801c91:	68 ac 4b 80 00       	push   $0x804bac
  801c96:	e8 bc 23 00 00       	call   804057 <_panic>
			release_uspinlock(&ulock);
			return;
		}

		struct UserHeapStruct* newfree = (struct UserHeapStruct*) alloc_block(sizeof(struct UserHeapStruct));
  801c9b:	83 ec 0c             	sub    $0xc,%esp
  801c9e:	6a 10                	push   $0x10
  801ca0:	e8 91 1a 00 00       	call   803736 <alloc_block>
  801ca5:	83 c4 10             	add    $0x10,%esp
  801ca8:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		struct UserHeapStruct* MergedBlock  = ( struct UserHeapStruct*)alloc_block(sizeof(struct UserHeapStruct));
  801cab:	83 ec 0c             	sub    $0xc,%esp
  801cae:	6a 10                	push   $0x10
  801cb0:	e8 81 1a 00 00       	call   803736 <alloc_block>
  801cb5:	83 c4 10             	add    $0x10,%esp
  801cb8:	89 45 d0             	mov    %eax,-0x30(%ebp)

		struct UserHeapStruct* ToBefreed = LIST_FIRST(&u_allocatedlist);
  801cbb:	a1 30 e1 81 00       	mov    0x81e130,%eax
  801cc0:	89 45 f4             	mov    %eax,-0xc(%ebp)
		bool foundVA = 0;
  801cc3:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

		//find the allocated block
		while(ToBefreed !=NULL ){
  801cca:	eb 1c                	jmp    801ce8 <free+0xe0>

			if (VA ==ToBefreed->startva ){
  801ccc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ccf:	8b 00                	mov    (%eax),%eax
  801cd1:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  801cd4:	75 09                	jne    801cdf <free+0xd7>
				foundVA = 1;
  801cd6:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
				break;
  801cdd:	eb 0f                	jmp    801cee <free+0xe6>
			}
				ToBefreed = ToBefreed->prev_next_info.le_next;
  801cdf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ce2:	8b 40 08             	mov    0x8(%eax),%eax
  801ce5:	89 45 f4             	mov    %eax,-0xc(%ebp)

		struct UserHeapStruct* ToBefreed = LIST_FIRST(&u_allocatedlist);
		bool foundVA = 0;

		//find the allocated block
		while(ToBefreed !=NULL ){
  801ce8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801cec:	75 de                	jne    801ccc <free+0xc4>
			}
				ToBefreed = ToBefreed->prev_next_info.le_next;
		}


		if(!foundVA){
  801cee:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801cf2:	75 17                	jne    801d0b <free+0x103>
				panic("INVALID ADDRESS!");
  801cf4:	83 ec 04             	sub    $0x4,%esp
  801cf7:	68 96 4c 80 00       	push   $0x804c96
  801cfc:	68 be 00 00 00       	push   $0xbe
  801d01:	68 ac 4b 80 00       	push   $0x804bac
  801d06:	e8 4c 23 00 00       	call   804057 <_panic>
				release_uspinlock(&ulock);
				return;
			}


		newfree->startva = ToBefreed->startva;
  801d0b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d0e:	8b 10                	mov    (%eax),%edx
  801d10:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801d13:	89 10                	mov    %edx,(%eax)
		newfree->size = ToBefreed->size;
  801d15:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d18:	8b 50 04             	mov    0x4(%eax),%edx
  801d1b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801d1e:	89 50 04             	mov    %edx,0x4(%eax)

		//remove allocated block from alloclist
		LIST_REMOVE(&u_allocatedlist, ToBefreed);
  801d21:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801d25:	75 17                	jne    801d3e <free+0x136>
  801d27:	83 ec 04             	sub    $0x4,%esp
  801d2a:	68 1b 4c 80 00       	push   $0x804c1b
  801d2f:	68 c8 00 00 00       	push   $0xc8
  801d34:	68 ac 4b 80 00       	push   $0x804bac
  801d39:	e8 19 23 00 00       	call   804057 <_panic>
  801d3e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d41:	8b 40 08             	mov    0x8(%eax),%eax
  801d44:	85 c0                	test   %eax,%eax
  801d46:	74 11                	je     801d59 <free+0x151>
  801d48:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d4b:	8b 40 08             	mov    0x8(%eax),%eax
  801d4e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801d51:	8b 52 0c             	mov    0xc(%edx),%edx
  801d54:	89 50 0c             	mov    %edx,0xc(%eax)
  801d57:	eb 0b                	jmp    801d64 <free+0x15c>
  801d59:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d5c:	8b 40 0c             	mov    0xc(%eax),%eax
  801d5f:	a3 34 e1 81 00       	mov    %eax,0x81e134
  801d64:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d67:	8b 40 0c             	mov    0xc(%eax),%eax
  801d6a:	85 c0                	test   %eax,%eax
  801d6c:	74 11                	je     801d7f <free+0x177>
  801d6e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d71:	8b 40 0c             	mov    0xc(%eax),%eax
  801d74:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801d77:	8b 52 08             	mov    0x8(%edx),%edx
  801d7a:	89 50 08             	mov    %edx,0x8(%eax)
  801d7d:	eb 0b                	jmp    801d8a <free+0x182>
  801d7f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d82:	8b 40 08             	mov    0x8(%eax),%eax
  801d85:	a3 30 e1 81 00       	mov    %eax,0x81e130
  801d8a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d8d:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  801d94:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d97:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  801d9e:	a1 3c e1 81 00       	mov    0x81e13c,%eax
  801da3:	48                   	dec    %eax
  801da4:	a3 3c e1 81 00       	mov    %eax,0x81e13c

		sys_free_user_mem(ToBefreed->startva, ToBefreed->size);
  801da9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dac:	8b 50 04             	mov    0x4(%eax),%edx
  801daf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801db2:	8b 00                	mov    (%eax),%eax
  801db4:	83 ec 08             	sub    $0x8,%esp
  801db7:	52                   	push   %edx
  801db8:	50                   	push   %eax
  801db9:	e8 d4 16 00 00       	call   803492 <sys_free_user_mem>
  801dbe:	83 c4 10             	add    $0x10,%esp




		if(LIST_SIZE(&u_freelist) == 0){
  801dc1:	a1 2c e1 81 00       	mov    0x81e12c,%eax
  801dc6:	85 c0                	test   %eax,%eax
  801dc8:	75 7a                	jne    801e44 <free+0x23c>
			LIST_INSERT_HEAD(&u_freelist,newfree);
  801dca:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  801dce:	75 17                	jne    801de7 <free+0x1df>
  801dd0:	83 ec 04             	sub    $0x4,%esp
  801dd3:	68 a8 4c 80 00       	push   $0x804ca8
  801dd8:	68 d0 00 00 00       	push   $0xd0
  801ddd:	68 ac 4b 80 00       	push   $0x804bac
  801de2:	e8 70 22 00 00       	call   804057 <_panic>
  801de7:	8b 15 20 e1 81 00    	mov    0x81e120,%edx
  801ded:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801df0:	89 50 08             	mov    %edx,0x8(%eax)
  801df3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801df6:	8b 40 08             	mov    0x8(%eax),%eax
  801df9:	85 c0                	test   %eax,%eax
  801dfb:	74 0d                	je     801e0a <free+0x202>
  801dfd:	a1 20 e1 81 00       	mov    0x81e120,%eax
  801e02:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  801e05:	89 50 0c             	mov    %edx,0xc(%eax)
  801e08:	eb 08                	jmp    801e12 <free+0x20a>
  801e0a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801e0d:	a3 24 e1 81 00       	mov    %eax,0x81e124
  801e12:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801e15:	a3 20 e1 81 00       	mov    %eax,0x81e120
  801e1a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801e1d:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  801e24:	a1 2c e1 81 00       	mov    0x81e12c,%eax
  801e29:	40                   	inc    %eax
  801e2a:	a3 2c e1 81 00       	mov    %eax,0x81e12c
			release_uspinlock(&ulock);
  801e2f:	83 ec 0c             	sub    $0xc,%esp
  801e32:	68 40 e1 81 00       	push   $0x81e140
  801e37:	e8 ba 21 00 00       	call   803ff6 <release_uspinlock>
  801e3c:	83 c4 10             	add    $0x10,%esp
			return;
  801e3f:	e9 52 05 00 00       	jmp    802396 <free+0x78e>
		}


		struct UserHeapStruct* ToBeMerged = LIST_FIRST(&u_freelist);
  801e44:	a1 20 e1 81 00       	mov    0x81e120,%eax
  801e49:	89 45 ec             	mov    %eax,-0x14(%ebp)
		// merge with prev if possible
		bool mergeprev = 0;
  801e4c:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		bool mergenext = 0;
  801e53:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
		while(ToBeMerged != NULL){
  801e5a:	e9 d2 00 00 00       	jmp    801f31 <free+0x329>
			if((ToBeMerged->startva +ToBeMerged->size) == newfree->startva){
  801e5f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801e62:	8b 10                	mov    (%eax),%edx
  801e64:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801e67:	8b 40 04             	mov    0x4(%eax),%eax
  801e6a:	01 c2                	add    %eax,%edx
  801e6c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801e6f:	8b 00                	mov    (%eax),%eax
  801e71:	39 c2                	cmp    %eax,%edx
  801e73:	0f 85 af 00 00 00    	jne    801f28 <free+0x320>

				MergedBlock->startva = ToBeMerged->startva;
  801e79:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801e7c:	8b 10                	mov    (%eax),%edx
  801e7e:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801e81:	89 10                	mov    %edx,(%eax)
				MergedBlock->size = ToBeMerged->size + newfree->size;
  801e83:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801e86:	8b 50 04             	mov    0x4(%eax),%edx
  801e89:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801e8c:	8b 40 04             	mov    0x4(%eax),%eax
  801e8f:	01 c2                	add    %eax,%edx
  801e91:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801e94:	89 50 04             	mov    %edx,0x4(%eax)
				LIST_REMOVE(&u_freelist, ToBeMerged);
  801e97:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801e9b:	75 17                	jne    801eb4 <free+0x2ac>
  801e9d:	83 ec 04             	sub    $0x4,%esp
  801ea0:	68 1b 4c 80 00       	push   $0x804c1b
  801ea5:	68 df 00 00 00       	push   $0xdf
  801eaa:	68 ac 4b 80 00       	push   $0x804bac
  801eaf:	e8 a3 21 00 00       	call   804057 <_panic>
  801eb4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801eb7:	8b 40 08             	mov    0x8(%eax),%eax
  801eba:	85 c0                	test   %eax,%eax
  801ebc:	74 11                	je     801ecf <free+0x2c7>
  801ebe:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801ec1:	8b 40 08             	mov    0x8(%eax),%eax
  801ec4:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801ec7:	8b 52 0c             	mov    0xc(%edx),%edx
  801eca:	89 50 0c             	mov    %edx,0xc(%eax)
  801ecd:	eb 0b                	jmp    801eda <free+0x2d2>
  801ecf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801ed2:	8b 40 0c             	mov    0xc(%eax),%eax
  801ed5:	a3 24 e1 81 00       	mov    %eax,0x81e124
  801eda:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801edd:	8b 40 0c             	mov    0xc(%eax),%eax
  801ee0:	85 c0                	test   %eax,%eax
  801ee2:	74 11                	je     801ef5 <free+0x2ed>
  801ee4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801ee7:	8b 40 0c             	mov    0xc(%eax),%eax
  801eea:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801eed:	8b 52 08             	mov    0x8(%edx),%edx
  801ef0:	89 50 08             	mov    %edx,0x8(%eax)
  801ef3:	eb 0b                	jmp    801f00 <free+0x2f8>
  801ef5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801ef8:	8b 40 08             	mov    0x8(%eax),%eax
  801efb:	a3 20 e1 81 00       	mov    %eax,0x81e120
  801f00:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f03:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  801f0a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f0d:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  801f14:	a1 2c e1 81 00       	mov    0x81e12c,%eax
  801f19:	48                   	dec    %eax
  801f1a:	a3 2c e1 81 00       	mov    %eax,0x81e12c
				mergeprev = 1;
  801f1f:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
				break;
  801f26:	eb 13                	jmp    801f3b <free+0x333>
			}
				ToBeMerged = ToBeMerged->prev_next_info.le_next;
  801f28:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f2b:	8b 40 08             	mov    0x8(%eax),%eax
  801f2e:	89 45 ec             	mov    %eax,-0x14(%ebp)

		struct UserHeapStruct* ToBeMerged = LIST_FIRST(&u_freelist);
		// merge with prev if possible
		bool mergeprev = 0;
		bool mergenext = 0;
		while(ToBeMerged != NULL){
  801f31:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801f35:	0f 85 24 ff ff ff    	jne    801e5f <free+0x257>
//									uheapPageAllocBreak = newfree->startva;
//						}
//					}


		if ( newfree ->startva + newfree->size == uheapPageAllocBreak){
  801f3b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801f3e:	8b 10                	mov    (%eax),%edx
  801f40:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801f43:	8b 40 04             	mov    0x4(%eax),%eax
  801f46:	01 c2                	add    %eax,%edx
  801f48:	a1 68 e0 81 00       	mov    0x81e068,%eax
  801f4d:	39 c2                	cmp    %eax,%edx
  801f4f:	75 44                	jne    801f95 <free+0x38d>

			if(mergeprev){
  801f51:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  801f55:	74 1f                	je     801f76 <free+0x36e>
				uheapPageAllocBreak = MergedBlock->startva;
  801f57:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801f5a:	8b 00                	mov    (%eax),%eax
  801f5c:	a3 68 e0 81 00       	mov    %eax,0x81e068
				release_uspinlock(&ulock);
  801f61:	83 ec 0c             	sub    $0xc,%esp
  801f64:	68 40 e1 81 00       	push   $0x81e140
  801f69:	e8 88 20 00 00       	call   803ff6 <release_uspinlock>
  801f6e:	83 c4 10             	add    $0x10,%esp
				return;
  801f71:	e9 20 04 00 00       	jmp    802396 <free+0x78e>

			}else{
				uheapPageAllocBreak = newfree->startva;
  801f76:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801f79:	8b 00                	mov    (%eax),%eax
  801f7b:	a3 68 e0 81 00       	mov    %eax,0x81e068
				release_uspinlock(&ulock);
  801f80:	83 ec 0c             	sub    $0xc,%esp
  801f83:	68 40 e1 81 00       	push   $0x81e140
  801f88:	e8 69 20 00 00       	call   803ff6 <release_uspinlock>
  801f8d:	83 c4 10             	add    $0x10,%esp
				return;
  801f90:	e9 01 04 00 00       	jmp    802396 <free+0x78e>

		}


		//check if block is merged with prev ,and find possible merge with next
		ToBeMerged = LIST_FIRST(&u_freelist);
  801f95:	a1 20 e1 81 00       	mov    0x81e120,%eax
  801f9a:	89 45 ec             	mov    %eax,-0x14(%ebp)
		while(ToBeMerged != NULL){
  801f9d:	e9 7d 01 00 00       	jmp    80211f <free+0x517>
			if ((newfree->startva + newfree->size) == ToBeMerged->startva ){
  801fa2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801fa5:	8b 10                	mov    (%eax),%edx
  801fa7:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801faa:	8b 40 04             	mov    0x4(%eax),%eax
  801fad:	01 c2                	add    %eax,%edx
  801faf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801fb2:	8b 00                	mov    (%eax),%eax
  801fb4:	39 c2                	cmp    %eax,%edx
  801fb6:	0f 85 5a 01 00 00    	jne    802116 <free+0x50e>
				if (mergeprev){
  801fbc:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  801fc0:	0f 84 a1 00 00 00    	je     802067 <free+0x45f>
					MergedBlock->size += ToBeMerged->size;
  801fc6:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801fc9:	8b 50 04             	mov    0x4(%eax),%edx
  801fcc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801fcf:	8b 40 04             	mov    0x4(%eax),%eax
  801fd2:	01 c2                	add    %eax,%edx
  801fd4:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801fd7:	89 50 04             	mov    %edx,0x4(%eax)
					LIST_REMOVE(&u_freelist, ToBeMerged);
  801fda:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801fde:	75 17                	jne    801ff7 <free+0x3ef>
  801fe0:	83 ec 04             	sub    $0x4,%esp
  801fe3:	68 1b 4c 80 00       	push   $0x804c1b
  801fe8:	68 0a 01 00 00       	push   $0x10a
  801fed:	68 ac 4b 80 00       	push   $0x804bac
  801ff2:	e8 60 20 00 00       	call   804057 <_panic>
  801ff7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801ffa:	8b 40 08             	mov    0x8(%eax),%eax
  801ffd:	85 c0                	test   %eax,%eax
  801fff:	74 11                	je     802012 <free+0x40a>
  802001:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802004:	8b 40 08             	mov    0x8(%eax),%eax
  802007:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80200a:	8b 52 0c             	mov    0xc(%edx),%edx
  80200d:	89 50 0c             	mov    %edx,0xc(%eax)
  802010:	eb 0b                	jmp    80201d <free+0x415>
  802012:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802015:	8b 40 0c             	mov    0xc(%eax),%eax
  802018:	a3 24 e1 81 00       	mov    %eax,0x81e124
  80201d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802020:	8b 40 0c             	mov    0xc(%eax),%eax
  802023:	85 c0                	test   %eax,%eax
  802025:	74 11                	je     802038 <free+0x430>
  802027:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80202a:	8b 40 0c             	mov    0xc(%eax),%eax
  80202d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802030:	8b 52 08             	mov    0x8(%edx),%edx
  802033:	89 50 08             	mov    %edx,0x8(%eax)
  802036:	eb 0b                	jmp    802043 <free+0x43b>
  802038:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80203b:	8b 40 08             	mov    0x8(%eax),%eax
  80203e:	a3 20 e1 81 00       	mov    %eax,0x81e120
  802043:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802046:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  80204d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802050:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  802057:	a1 2c e1 81 00       	mov    0x81e12c,%eax
  80205c:	48                   	dec    %eax
  80205d:	a3 2c e1 81 00       	mov    %eax,0x81e12c
					break;
  802062:	e9 c2 00 00 00       	jmp    802129 <free+0x521>
		//if not merged find possible merge with next
				}else{
					MergedBlock->startva = newfree->startva;
  802067:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80206a:	8b 10                	mov    (%eax),%edx
  80206c:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80206f:	89 10                	mov    %edx,(%eax)
					MergedBlock->size  = newfree->size + ToBeMerged->size;
  802071:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802074:	8b 50 04             	mov    0x4(%eax),%edx
  802077:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80207a:	8b 40 04             	mov    0x4(%eax),%eax
  80207d:	01 c2                	add    %eax,%edx
  80207f:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802082:	89 50 04             	mov    %edx,0x4(%eax)
					LIST_REMOVE(&u_freelist, ToBeMerged);
  802085:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802089:	75 17                	jne    8020a2 <free+0x49a>
  80208b:	83 ec 04             	sub    $0x4,%esp
  80208e:	68 1b 4c 80 00       	push   $0x804c1b
  802093:	68 10 01 00 00       	push   $0x110
  802098:	68 ac 4b 80 00       	push   $0x804bac
  80209d:	e8 b5 1f 00 00       	call   804057 <_panic>
  8020a2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8020a5:	8b 40 08             	mov    0x8(%eax),%eax
  8020a8:	85 c0                	test   %eax,%eax
  8020aa:	74 11                	je     8020bd <free+0x4b5>
  8020ac:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8020af:	8b 40 08             	mov    0x8(%eax),%eax
  8020b2:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8020b5:	8b 52 0c             	mov    0xc(%edx),%edx
  8020b8:	89 50 0c             	mov    %edx,0xc(%eax)
  8020bb:	eb 0b                	jmp    8020c8 <free+0x4c0>
  8020bd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8020c0:	8b 40 0c             	mov    0xc(%eax),%eax
  8020c3:	a3 24 e1 81 00       	mov    %eax,0x81e124
  8020c8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8020cb:	8b 40 0c             	mov    0xc(%eax),%eax
  8020ce:	85 c0                	test   %eax,%eax
  8020d0:	74 11                	je     8020e3 <free+0x4db>
  8020d2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8020d5:	8b 40 0c             	mov    0xc(%eax),%eax
  8020d8:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8020db:	8b 52 08             	mov    0x8(%edx),%edx
  8020de:	89 50 08             	mov    %edx,0x8(%eax)
  8020e1:	eb 0b                	jmp    8020ee <free+0x4e6>
  8020e3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8020e6:	8b 40 08             	mov    0x8(%eax),%eax
  8020e9:	a3 20 e1 81 00       	mov    %eax,0x81e120
  8020ee:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8020f1:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  8020f8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8020fb:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  802102:	a1 2c e1 81 00       	mov    0x81e12c,%eax
  802107:	48                   	dec    %eax
  802108:	a3 2c e1 81 00       	mov    %eax,0x81e12c
					mergenext = 1;
  80210d:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
					break;
  802114:	eb 13                	jmp    802129 <free+0x521>
				}
			}
			ToBeMerged = ToBeMerged->prev_next_info.le_next;
  802116:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802119:	8b 40 08             	mov    0x8(%eax),%eax
  80211c:	89 45 ec             	mov    %eax,-0x14(%ebp)
		}


		//check if block is merged with prev ,and find possible merge with next
		ToBeMerged = LIST_FIRST(&u_freelist);
		while(ToBeMerged != NULL){
  80211f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802123:	0f 85 79 fe ff ff    	jne    801fa2 <free+0x39a>




			// insertion
			struct UserHeapStruct* currentfree = LIST_FIRST(&u_freelist);
  802129:	a1 20 e1 81 00       	mov    0x81e120,%eax
  80212e:	89 45 e0             	mov    %eax,-0x20(%ebp)

			if(mergeprev || mergenext){
  802131:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802135:	0f 85 ad 00 00 00    	jne    8021e8 <free+0x5e0>
  80213b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80213f:	0f 84 c3 01 00 00    	je     802308 <free+0x700>
				while(currentfree != NULL){
  802145:	e9 9e 00 00 00       	jmp    8021e8 <free+0x5e0>
					if(MergedBlock->size < currentfree->size){
  80214a:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80214d:	8b 50 04             	mov    0x4(%eax),%edx
  802150:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802153:	8b 40 04             	mov    0x4(%eax),%eax
  802156:	39 c2                	cmp    %eax,%edx
  802158:	0f 83 81 00 00 00    	jae    8021df <free+0x5d7>

							LIST_INSERT_BEFORE(&u_freelist,currentfree,MergedBlock);
  80215e:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802162:	74 06                	je     80216a <free+0x562>
  802164:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  802168:	75 17                	jne    802181 <free+0x579>
  80216a:	83 ec 04             	sub    $0x4,%esp
  80216d:	68 3c 4c 80 00       	push   $0x804c3c
  802172:	68 23 01 00 00       	push   $0x123
  802177:	68 ac 4b 80 00       	push   $0x804bac
  80217c:	e8 d6 1e 00 00       	call   804057 <_panic>
  802181:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802184:	8b 50 0c             	mov    0xc(%eax),%edx
  802187:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80218a:	89 50 0c             	mov    %edx,0xc(%eax)
  80218d:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802190:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802193:	89 50 08             	mov    %edx,0x8(%eax)
  802196:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802199:	8b 40 0c             	mov    0xc(%eax),%eax
  80219c:	85 c0                	test   %eax,%eax
  80219e:	74 0e                	je     8021ae <free+0x5a6>
  8021a0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8021a3:	8b 40 0c             	mov    0xc(%eax),%eax
  8021a6:	8b 55 d0             	mov    -0x30(%ebp),%edx
  8021a9:	89 50 08             	mov    %edx,0x8(%eax)
  8021ac:	eb 08                	jmp    8021b6 <free+0x5ae>
  8021ae:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8021b1:	a3 20 e1 81 00       	mov    %eax,0x81e120
  8021b6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8021b9:	8b 55 d0             	mov    -0x30(%ebp),%edx
  8021bc:	89 50 0c             	mov    %edx,0xc(%eax)
  8021bf:	a1 2c e1 81 00       	mov    0x81e12c,%eax
  8021c4:	40                   	inc    %eax
  8021c5:	a3 2c e1 81 00       	mov    %eax,0x81e12c
							release_uspinlock(&ulock);
  8021ca:	83 ec 0c             	sub    $0xc,%esp
  8021cd:	68 40 e1 81 00       	push   $0x81e140
  8021d2:	e8 1f 1e 00 00       	call   803ff6 <release_uspinlock>
  8021d7:	83 c4 10             	add    $0x10,%esp
							return;
  8021da:	e9 b7 01 00 00       	jmp    802396 <free+0x78e>
					}
							currentfree = currentfree->prev_next_info.le_next;
  8021df:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8021e2:	8b 40 08             	mov    0x8(%eax),%eax
  8021e5:	89 45 e0             	mov    %eax,-0x20(%ebp)

			// insertion
			struct UserHeapStruct* currentfree = LIST_FIRST(&u_freelist);

			if(mergeprev || mergenext){
				while(currentfree != NULL){
  8021e8:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8021ec:	0f 85 58 ff ff ff    	jne    80214a <free+0x542>
							release_uspinlock(&ulock);
							return;
					}
							currentfree = currentfree->prev_next_info.le_next;
				}
				free_block(newfree);
  8021f2:	83 ec 0c             	sub    $0xc,%esp
  8021f5:	ff 75 d4             	pushl  -0x2c(%ebp)
  8021f8:	e8 d5 19 00 00       	call   803bd2 <free_block>
  8021fd:	83 c4 10             	add    $0x10,%esp
				LIST_INSERT_TAIL(&u_freelist,MergedBlock);
  802200:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  802204:	75 17                	jne    80221d <free+0x615>
  802206:	83 ec 04             	sub    $0x4,%esp
  802209:	68 f8 4b 80 00       	push   $0x804bf8
  80220e:	68 2a 01 00 00       	push   $0x12a
  802213:	68 ac 4b 80 00       	push   $0x804bac
  802218:	e8 3a 1e 00 00       	call   804057 <_panic>
  80221d:	8b 15 24 e1 81 00    	mov    0x81e124,%edx
  802223:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802226:	89 50 0c             	mov    %edx,0xc(%eax)
  802229:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80222c:	8b 40 0c             	mov    0xc(%eax),%eax
  80222f:	85 c0                	test   %eax,%eax
  802231:	74 0d                	je     802240 <free+0x638>
  802233:	a1 24 e1 81 00       	mov    0x81e124,%eax
  802238:	8b 55 d0             	mov    -0x30(%ebp),%edx
  80223b:	89 50 08             	mov    %edx,0x8(%eax)
  80223e:	eb 08                	jmp    802248 <free+0x640>
  802240:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802243:	a3 20 e1 81 00       	mov    %eax,0x81e120
  802248:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80224b:	a3 24 e1 81 00       	mov    %eax,0x81e124
  802250:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802253:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  80225a:	a1 2c e1 81 00       	mov    0x81e12c,%eax
  80225f:	40                   	inc    %eax
  802260:	a3 2c e1 81 00       	mov    %eax,0x81e12c
  802265:	e9 1b 01 00 00       	jmp    802385 <free+0x77d>

			}else{
				while(currentfree != NULL){
					if(newfree->size < currentfree->size){
  80226a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80226d:	8b 50 04             	mov    0x4(%eax),%edx
  802270:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802273:	8b 40 04             	mov    0x4(%eax),%eax
  802276:	39 c2                	cmp    %eax,%edx
  802278:	0f 83 81 00 00 00    	jae    8022ff <free+0x6f7>

							LIST_INSERT_BEFORE(&u_freelist,currentfree,newfree);
  80227e:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802282:	74 06                	je     80228a <free+0x682>
  802284:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  802288:	75 17                	jne    8022a1 <free+0x699>
  80228a:	83 ec 04             	sub    $0x4,%esp
  80228d:	68 3c 4c 80 00       	push   $0x804c3c
  802292:	68 30 01 00 00       	push   $0x130
  802297:	68 ac 4b 80 00       	push   $0x804bac
  80229c:	e8 b6 1d 00 00       	call   804057 <_panic>
  8022a1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8022a4:	8b 50 0c             	mov    0xc(%eax),%edx
  8022a7:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8022aa:	89 50 0c             	mov    %edx,0xc(%eax)
  8022ad:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8022b0:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8022b3:	89 50 08             	mov    %edx,0x8(%eax)
  8022b6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8022b9:	8b 40 0c             	mov    0xc(%eax),%eax
  8022bc:	85 c0                	test   %eax,%eax
  8022be:	74 0e                	je     8022ce <free+0x6c6>
  8022c0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8022c3:	8b 40 0c             	mov    0xc(%eax),%eax
  8022c6:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8022c9:	89 50 08             	mov    %edx,0x8(%eax)
  8022cc:	eb 08                	jmp    8022d6 <free+0x6ce>
  8022ce:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8022d1:	a3 20 e1 81 00       	mov    %eax,0x81e120
  8022d6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8022d9:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8022dc:	89 50 0c             	mov    %edx,0xc(%eax)
  8022df:	a1 2c e1 81 00       	mov    0x81e12c,%eax
  8022e4:	40                   	inc    %eax
  8022e5:	a3 2c e1 81 00       	mov    %eax,0x81e12c
							release_uspinlock(&ulock);
  8022ea:	83 ec 0c             	sub    $0xc,%esp
  8022ed:	68 40 e1 81 00       	push   $0x81e140
  8022f2:	e8 ff 1c 00 00       	call   803ff6 <release_uspinlock>
  8022f7:	83 c4 10             	add    $0x10,%esp
							return;
  8022fa:	e9 97 00 00 00       	jmp    802396 <free+0x78e>
					}
							currentfree = currentfree->prev_next_info.le_next;
  8022ff:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802302:	8b 40 08             	mov    0x8(%eax),%eax
  802305:	89 45 e0             	mov    %eax,-0x20(%ebp)
				}
				free_block(newfree);
				LIST_INSERT_TAIL(&u_freelist,MergedBlock);

			}else{
				while(currentfree != NULL){
  802308:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80230c:	0f 85 58 ff ff ff    	jne    80226a <free+0x662>
							release_uspinlock(&ulock);
							return;
					}
							currentfree = currentfree->prev_next_info.le_next;
				}
				free_block(MergedBlock);
  802312:	83 ec 0c             	sub    $0xc,%esp
  802315:	ff 75 d0             	pushl  -0x30(%ebp)
  802318:	e8 b5 18 00 00       	call   803bd2 <free_block>
  80231d:	83 c4 10             	add    $0x10,%esp
				LIST_INSERT_TAIL(&u_freelist,newfree);
  802320:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  802324:	75 17                	jne    80233d <free+0x735>
  802326:	83 ec 04             	sub    $0x4,%esp
  802329:	68 f8 4b 80 00       	push   $0x804bf8
  80232e:	68 37 01 00 00       	push   $0x137
  802333:	68 ac 4b 80 00       	push   $0x804bac
  802338:	e8 1a 1d 00 00       	call   804057 <_panic>
  80233d:	8b 15 24 e1 81 00    	mov    0x81e124,%edx
  802343:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802346:	89 50 0c             	mov    %edx,0xc(%eax)
  802349:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80234c:	8b 40 0c             	mov    0xc(%eax),%eax
  80234f:	85 c0                	test   %eax,%eax
  802351:	74 0d                	je     802360 <free+0x758>
  802353:	a1 24 e1 81 00       	mov    0x81e124,%eax
  802358:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80235b:	89 50 08             	mov    %edx,0x8(%eax)
  80235e:	eb 08                	jmp    802368 <free+0x760>
  802360:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802363:	a3 20 e1 81 00       	mov    %eax,0x81e120
  802368:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80236b:	a3 24 e1 81 00       	mov    %eax,0x81e124
  802370:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802373:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  80237a:	a1 2c e1 81 00       	mov    0x81e12c,%eax
  80237f:	40                   	inc    %eax
  802380:	a3 2c e1 81 00       	mov    %eax,0x81e12c
			}
		release_uspinlock(&ulock);
  802385:	83 ec 0c             	sub    $0xc,%esp
  802388:	68 40 e1 81 00       	push   $0x81e140
  80238d:	e8 64 1c 00 00       	call   803ff6 <release_uspinlock>
  802392:	83 c4 10             	add    $0x10,%esp
		return;
  802395:	90                   	nop
}
  802396:	c9                   	leave  
  802397:	c3                   	ret    

00802398 <smalloc>:

//=================================
// [3] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  802398:	55                   	push   %ebp
  802399:	89 e5                	mov    %esp,%ebp
  80239b:	83 ec 48             	sub    $0x48,%esp
  80239e:	8b 45 10             	mov    0x10(%ebp),%eax
  8023a1:	88 45 c4             	mov    %al,-0x3c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  8023a4:	e8 2d f2 ff ff       	call   8015d6 <uheap_init>
	if (size == 0) return NULL;
  8023a9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8023ad:	75 0a                	jne    8023b9 <smalloc+0x21>
  8023af:	b8 00 00 00 00       	mov    $0x0,%eax
  8023b4:	e9 84 05 00 00       	jmp    80293d <smalloc+0x5a5>
	//==============================================================
	acquire_uspinlock(&ulock);
  8023b9:	83 ec 0c             	sub    $0xc,%esp
  8023bc:	68 40 e1 81 00       	push   $0x81e140
  8023c1:	e8 d8 1b 00 00       	call   803f9e <acquire_uspinlock>
  8023c6:	83 c4 10             	add    $0x10,%esp

	struct UserHeapStruct* allocblock = (struct UserHeapStruct*) alloc_block(sizeof(struct UserHeapStruct));
  8023c9:	83 ec 0c             	sub    $0xc,%esp
  8023cc:	6a 10                	push   $0x10
  8023ce:	e8 63 13 00 00       	call   803736 <alloc_block>
  8023d3:	83 c4 10             	add    $0x10,%esp
  8023d6:	89 45 ec             	mov    %eax,-0x14(%ebp)
	if (allocblock == NULL){
  8023d9:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8023dd:	75 0a                	jne    8023e9 <smalloc+0x51>
				return NULL;
  8023df:	b8 00 00 00 00       	mov    $0x0,%eax
  8023e4:	e9 54 05 00 00       	jmp    80293d <smalloc+0x5a5>
	}
		size = ROUNDUP(size,PAGE_SIZE);
  8023e9:	c7 45 e8 00 10 00 00 	movl   $0x1000,-0x18(%ebp)
  8023f0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8023f3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8023f6:	01 d0                	add    %edx,%eax
  8023f8:	48                   	dec    %eax
  8023f9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8023fc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8023ff:	ba 00 00 00 00       	mov    $0x0,%edx
  802404:	f7 75 e8             	divl   -0x18(%ebp)
  802407:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80240a:	29 d0                	sub    %edx,%eax
  80240c:	89 45 0c             	mov    %eax,0xc(%ebp)
		struct UserHeapStruct* lastfreeelement = LIST_LAST(&u_freelist);
  80240f:	a1 24 e1 81 00       	mov    0x81e124,%eax
  802414:	89 45 e0             	mov    %eax,-0x20(%ebp)

		if(LIST_SIZE(&u_freelist)==0 || size>lastfreeelement->size){
  802417:	a1 2c e1 81 00       	mov    0x81e12c,%eax
  80241c:	85 c0                	test   %eax,%eax
  80241e:	74 0f                	je     80242f <smalloc+0x97>
  802420:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802423:	8b 40 04             	mov    0x4(%eax),%eax
  802426:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802429:	0f 83 25 01 00 00    	jae    802554 <smalloc+0x1bc>
				if(uheapPageAllocBreak <= USER_HEAP_MAX - size){
  80242f:	b8 00 00 00 a0       	mov    $0xa0000000,%eax
  802434:	2b 45 0c             	sub    0xc(%ebp),%eax
  802437:	89 c2                	mov    %eax,%edx
  802439:	a1 68 e0 81 00       	mov    0x81e068,%eax
  80243e:	39 c2                	cmp    %eax,%edx
  802440:	0f 82 f4 00 00 00    	jb     80253a <smalloc+0x1a2>
						uint32 requestedblockva = uheapPageAllocBreak;
  802446:	a1 68 e0 81 00       	mov    0x81e068,%eax
  80244b:	89 45 d4             	mov    %eax,-0x2c(%ebp)
						uheapPageAllocBreak+=size;
  80244e:	8b 15 68 e0 81 00    	mov    0x81e068,%edx
  802454:	8b 45 0c             	mov    0xc(%ebp),%eax
  802457:	01 d0                	add    %edx,%eax
  802459:	a3 68 e0 81 00       	mov    %eax,0x81e068
						allocblock->startva = requestedblockva;
  80245e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802461:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802464:	89 10                	mov    %edx,(%eax)
						allocblock->size = size;
  802466:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802469:	8b 55 0c             	mov    0xc(%ebp),%edx
  80246c:	89 50 04             	mov    %edx,0x4(%eax)

						LIST_INSERT_TAIL(&u_allocatedlist, allocblock);
  80246f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802473:	75 17                	jne    80248c <smalloc+0xf4>
  802475:	83 ec 04             	sub    $0x4,%esp
  802478:	68 f8 4b 80 00       	push   $0x804bf8
  80247d:	68 57 01 00 00       	push   $0x157
  802482:	68 ac 4b 80 00       	push   $0x804bac
  802487:	e8 cb 1b 00 00       	call   804057 <_panic>
  80248c:	8b 15 34 e1 81 00    	mov    0x81e134,%edx
  802492:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802495:	89 50 0c             	mov    %edx,0xc(%eax)
  802498:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80249b:	8b 40 0c             	mov    0xc(%eax),%eax
  80249e:	85 c0                	test   %eax,%eax
  8024a0:	74 0d                	je     8024af <smalloc+0x117>
  8024a2:	a1 34 e1 81 00       	mov    0x81e134,%eax
  8024a7:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8024aa:	89 50 08             	mov    %edx,0x8(%eax)
  8024ad:	eb 08                	jmp    8024b7 <smalloc+0x11f>
  8024af:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8024b2:	a3 30 e1 81 00       	mov    %eax,0x81e130
  8024b7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8024ba:	a3 34 e1 81 00       	mov    %eax,0x81e134
  8024bf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8024c2:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  8024c9:	a1 3c e1 81 00       	mov    0x81e13c,%eax
  8024ce:	40                   	inc    %eax
  8024cf:	a3 3c e1 81 00       	mov    %eax,0x81e13c


						int result = sys_create_shared_object(sharedVarName ,size ,isWritable ,(void*)allocblock->startva);
  8024d4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8024d7:	8b 00                	mov    (%eax),%eax
  8024d9:	89 c2                	mov    %eax,%edx
  8024db:	0f b6 45 c4          	movzbl -0x3c(%ebp),%eax
  8024df:	52                   	push   %edx
  8024e0:	50                   	push   %eax
  8024e1:	ff 75 0c             	pushl  0xc(%ebp)
  8024e4:	ff 75 08             	pushl  0x8(%ebp)
  8024e7:	e8 48 0c 00 00       	call   803134 <sys_create_shared_object>
  8024ec:	83 c4 10             	add    $0x10,%esp
  8024ef:	89 45 d0             	mov    %eax,-0x30(%ebp)

						if(result <0){
  8024f2:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  8024f6:	79 28                	jns    802520 <smalloc+0x188>
							free_block(allocblock);
  8024f8:	83 ec 0c             	sub    $0xc,%esp
  8024fb:	ff 75 ec             	pushl  -0x14(%ebp)
  8024fe:	e8 cf 16 00 00       	call   803bd2 <free_block>
  802503:	83 c4 10             	add    $0x10,%esp
							release_uspinlock(&ulock);
  802506:	83 ec 0c             	sub    $0xc,%esp
  802509:	68 40 e1 81 00       	push   $0x81e140
  80250e:	e8 e3 1a 00 00       	call   803ff6 <release_uspinlock>
  802513:	83 c4 10             	add    $0x10,%esp
							return NULL;
  802516:	b8 00 00 00 00       	mov    $0x0,%eax
  80251b:	e9 1d 04 00 00       	jmp    80293d <smalloc+0x5a5>
						}
						release_uspinlock(&ulock);
  802520:	83 ec 0c             	sub    $0xc,%esp
  802523:	68 40 e1 81 00       	push   $0x81e140
  802528:	e8 c9 1a 00 00       	call   803ff6 <release_uspinlock>
  80252d:	83 c4 10             	add    $0x10,%esp
						return (void*)allocblock -> startva;
  802530:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802533:	8b 00                	mov    (%eax),%eax
  802535:	e9 03 04 00 00       	jmp    80293d <smalloc+0x5a5>
				}else{
						release_uspinlock(&ulock);
  80253a:	83 ec 0c             	sub    $0xc,%esp
  80253d:	68 40 e1 81 00       	push   $0x81e140
  802542:	e8 af 1a 00 00       	call   803ff6 <release_uspinlock>
  802547:	83 c4 10             	add    $0x10,%esp
						return NULL;
  80254a:	b8 00 00 00 00       	mov    $0x0,%eax
  80254f:	e9 e9 03 00 00       	jmp    80293d <smalloc+0x5a5>
					 }
		}else{
			//custom fit
			struct UserHeapStruct* currentfreeelement = LIST_FIRST(&u_freelist);
  802554:	a1 20 e1 81 00       	mov    0x81e120,%eax
  802559:	89 45 f4             	mov    %eax,-0xc(%ebp)
			//worst fit
			while(currentfreeelement != NULL){
  80255c:	e9 af 03 00 00       	jmp    802910 <smalloc+0x578>
				if(size<currentfreeelement->size){
  802561:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802564:	8b 40 04             	mov    0x4(%eax),%eax
  802567:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80256a:	0f 86 28 02 00 00    	jbe    802798 <smalloc+0x400>
					allocblock->startva = lastfreeelement->startva;
  802570:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802573:	8b 10                	mov    (%eax),%edx
  802575:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802578:	89 10                	mov    %edx,(%eax)
	                allocblock->size = size;
  80257a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80257d:	8b 55 0c             	mov    0xc(%ebp),%edx
  802580:	89 50 04             	mov    %edx,0x4(%eax)
	                LIST_INSERT_TAIL(&u_allocatedlist,allocblock);
  802583:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802587:	75 17                	jne    8025a0 <smalloc+0x208>
  802589:	83 ec 04             	sub    $0x4,%esp
  80258c:	68 f8 4b 80 00       	push   $0x804bf8
  802591:	68 6f 01 00 00       	push   $0x16f
  802596:	68 ac 4b 80 00       	push   $0x804bac
  80259b:	e8 b7 1a 00 00       	call   804057 <_panic>
  8025a0:	8b 15 34 e1 81 00    	mov    0x81e134,%edx
  8025a6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025a9:	89 50 0c             	mov    %edx,0xc(%eax)
  8025ac:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025af:	8b 40 0c             	mov    0xc(%eax),%eax
  8025b2:	85 c0                	test   %eax,%eax
  8025b4:	74 0d                	je     8025c3 <smalloc+0x22b>
  8025b6:	a1 34 e1 81 00       	mov    0x81e134,%eax
  8025bb:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8025be:	89 50 08             	mov    %edx,0x8(%eax)
  8025c1:	eb 08                	jmp    8025cb <smalloc+0x233>
  8025c3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025c6:	a3 30 e1 81 00       	mov    %eax,0x81e130
  8025cb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025ce:	a3 34 e1 81 00       	mov    %eax,0x81e134
  8025d3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025d6:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  8025dd:	a1 3c e1 81 00       	mov    0x81e13c,%eax
  8025e2:	40                   	inc    %eax
  8025e3:	a3 3c e1 81 00       	mov    %eax,0x81e13c
	                lastfreeelement->startva += size;
  8025e8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8025eb:	8b 10                	mov    (%eax),%edx
  8025ed:	8b 45 0c             	mov    0xc(%ebp),%eax
  8025f0:	01 c2                	add    %eax,%edx
  8025f2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8025f5:	89 10                	mov    %edx,(%eax)
	                lastfreeelement->size -= size;
  8025f7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8025fa:	8b 40 04             	mov    0x4(%eax),%eax
  8025fd:	2b 45 0c             	sub    0xc(%ebp),%eax
  802600:	89 c2                	mov    %eax,%edx
  802602:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802605:	89 50 04             	mov    %edx,0x4(%eax)
	                struct UserHeapStruct* currentfree2 = LIST_FIRST(&u_freelist);
  802608:	a1 20 e1 81 00       	mov    0x81e120,%eax
  80260d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	                //check order of last element

	                while (currentfree2 != NULL){
  802610:	e9 13 01 00 00       	jmp    802728 <smalloc+0x390>
	                	if(lastfreeelement->size <currentfree2->size){
  802615:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802618:	8b 50 04             	mov    0x4(%eax),%edx
  80261b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80261e:	8b 40 04             	mov    0x4(%eax),%eax
  802621:	39 c2                	cmp    %eax,%edx
  802623:	0f 83 f6 00 00 00    	jae    80271f <smalloc+0x387>
	                		LIST_REMOVE(&u_freelist ,lastfreeelement);
  802629:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80262d:	75 17                	jne    802646 <smalloc+0x2ae>
  80262f:	83 ec 04             	sub    $0x4,%esp
  802632:	68 1b 4c 80 00       	push   $0x804c1b
  802637:	68 77 01 00 00       	push   $0x177
  80263c:	68 ac 4b 80 00       	push   $0x804bac
  802641:	e8 11 1a 00 00       	call   804057 <_panic>
  802646:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802649:	8b 40 08             	mov    0x8(%eax),%eax
  80264c:	85 c0                	test   %eax,%eax
  80264e:	74 11                	je     802661 <smalloc+0x2c9>
  802650:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802653:	8b 40 08             	mov    0x8(%eax),%eax
  802656:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802659:	8b 52 0c             	mov    0xc(%edx),%edx
  80265c:	89 50 0c             	mov    %edx,0xc(%eax)
  80265f:	eb 0b                	jmp    80266c <smalloc+0x2d4>
  802661:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802664:	8b 40 0c             	mov    0xc(%eax),%eax
  802667:	a3 24 e1 81 00       	mov    %eax,0x81e124
  80266c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80266f:	8b 40 0c             	mov    0xc(%eax),%eax
  802672:	85 c0                	test   %eax,%eax
  802674:	74 11                	je     802687 <smalloc+0x2ef>
  802676:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802679:	8b 40 0c             	mov    0xc(%eax),%eax
  80267c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80267f:	8b 52 08             	mov    0x8(%edx),%edx
  802682:	89 50 08             	mov    %edx,0x8(%eax)
  802685:	eb 0b                	jmp    802692 <smalloc+0x2fa>
  802687:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80268a:	8b 40 08             	mov    0x8(%eax),%eax
  80268d:	a3 20 e1 81 00       	mov    %eax,0x81e120
  802692:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802695:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  80269c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80269f:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  8026a6:	a1 2c e1 81 00       	mov    0x81e12c,%eax
  8026ab:	48                   	dec    %eax
  8026ac:	a3 2c e1 81 00       	mov    %eax,0x81e12c
	                		LIST_INSERT_BEFORE(&u_freelist ,currentfree2 ,lastfreeelement);
  8026b1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8026b5:	74 06                	je     8026bd <smalloc+0x325>
  8026b7:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8026bb:	75 17                	jne    8026d4 <smalloc+0x33c>
  8026bd:	83 ec 04             	sub    $0x4,%esp
  8026c0:	68 3c 4c 80 00       	push   $0x804c3c
  8026c5:	68 78 01 00 00       	push   $0x178
  8026ca:	68 ac 4b 80 00       	push   $0x804bac
  8026cf:	e8 83 19 00 00       	call   804057 <_panic>
  8026d4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026d7:	8b 50 0c             	mov    0xc(%eax),%edx
  8026da:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8026dd:	89 50 0c             	mov    %edx,0xc(%eax)
  8026e0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8026e3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8026e6:	89 50 08             	mov    %edx,0x8(%eax)
  8026e9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026ec:	8b 40 0c             	mov    0xc(%eax),%eax
  8026ef:	85 c0                	test   %eax,%eax
  8026f1:	74 0e                	je     802701 <smalloc+0x369>
  8026f3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026f6:	8b 40 0c             	mov    0xc(%eax),%eax
  8026f9:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8026fc:	89 50 08             	mov    %edx,0x8(%eax)
  8026ff:	eb 08                	jmp    802709 <smalloc+0x371>
  802701:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802704:	a3 20 e1 81 00       	mov    %eax,0x81e120
  802709:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80270c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80270f:	89 50 0c             	mov    %edx,0xc(%eax)
  802712:	a1 2c e1 81 00       	mov    0x81e12c,%eax
  802717:	40                   	inc    %eax
  802718:	a3 2c e1 81 00       	mov    %eax,0x81e12c
	                		break;
  80271d:	eb 13                	jmp    802732 <smalloc+0x39a>
	                	}
	                	currentfree2 = currentfree2->prev_next_info.le_next;
  80271f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802722:	8b 40 08             	mov    0x8(%eax),%eax
  802725:	89 45 f0             	mov    %eax,-0x10(%ebp)
	                lastfreeelement->startva += size;
	                lastfreeelement->size -= size;
	                struct UserHeapStruct* currentfree2 = LIST_FIRST(&u_freelist);
	                //check order of last element

	                while (currentfree2 != NULL){
  802728:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80272c:	0f 85 e3 fe ff ff    	jne    802615 <smalloc+0x27d>
	                	}
	                	currentfree2 = currentfree2->prev_next_info.le_next;
	                }


	                int result = sys_create_shared_object(sharedVarName ,size ,isWritable ,(void*)allocblock->startva);
  802732:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802735:	8b 00                	mov    (%eax),%eax
  802737:	89 c2                	mov    %eax,%edx
  802739:	0f b6 45 c4          	movzbl -0x3c(%ebp),%eax
  80273d:	52                   	push   %edx
  80273e:	50                   	push   %eax
  80273f:	ff 75 0c             	pushl  0xc(%ebp)
  802742:	ff 75 08             	pushl  0x8(%ebp)
  802745:	e8 ea 09 00 00       	call   803134 <sys_create_shared_object>
  80274a:	83 c4 10             	add    $0x10,%esp
  80274d:	89 45 d8             	mov    %eax,-0x28(%ebp)

	                if(result <0){
  802750:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  802754:	79 28                	jns    80277e <smalloc+0x3e6>
	                	free_block(allocblock);
  802756:	83 ec 0c             	sub    $0xc,%esp
  802759:	ff 75 ec             	pushl  -0x14(%ebp)
  80275c:	e8 71 14 00 00       	call   803bd2 <free_block>
  802761:	83 c4 10             	add    $0x10,%esp
	                	release_uspinlock(&ulock);
  802764:	83 ec 0c             	sub    $0xc,%esp
  802767:	68 40 e1 81 00       	push   $0x81e140
  80276c:	e8 85 18 00 00       	call   803ff6 <release_uspinlock>
  802771:	83 c4 10             	add    $0x10,%esp
	                	return NULL;
  802774:	b8 00 00 00 00       	mov    $0x0,%eax
  802779:	e9 bf 01 00 00       	jmp    80293d <smalloc+0x5a5>
	                }
	                release_uspinlock(&ulock);
  80277e:	83 ec 0c             	sub    $0xc,%esp
  802781:	68 40 e1 81 00       	push   $0x81e140
  802786:	e8 6b 18 00 00       	call   803ff6 <release_uspinlock>
  80278b:	83 c4 10             	add    $0x10,%esp
	                return (void*)allocblock->startva;
  80278e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802791:	8b 00                	mov    (%eax),%eax
  802793:	e9 a5 01 00 00       	jmp    80293d <smalloc+0x5a5>
	                //exact fit
				}else if(size == currentfreeelement->size){
  802798:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80279b:	8b 40 04             	mov    0x4(%eax),%eax
  80279e:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8027a1:	0f 85 60 01 00 00    	jne    802907 <smalloc+0x56f>
					allocblock->startva = currentfreeelement->startva;
  8027a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027aa:	8b 10                	mov    (%eax),%edx
  8027ac:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027af:	89 10                	mov    %edx,(%eax)
					allocblock->size = size;
  8027b1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027b4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8027b7:	89 50 04             	mov    %edx,0x4(%eax)
					LIST_INSERT_TAIL(&u_allocatedlist ,allocblock);
  8027ba:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8027be:	75 17                	jne    8027d7 <smalloc+0x43f>
  8027c0:	83 ec 04             	sub    $0x4,%esp
  8027c3:	68 f8 4b 80 00       	push   $0x804bf8
  8027c8:	68 8c 01 00 00       	push   $0x18c
  8027cd:	68 ac 4b 80 00       	push   $0x804bac
  8027d2:	e8 80 18 00 00       	call   804057 <_panic>
  8027d7:	8b 15 34 e1 81 00    	mov    0x81e134,%edx
  8027dd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027e0:	89 50 0c             	mov    %edx,0xc(%eax)
  8027e3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027e6:	8b 40 0c             	mov    0xc(%eax),%eax
  8027e9:	85 c0                	test   %eax,%eax
  8027eb:	74 0d                	je     8027fa <smalloc+0x462>
  8027ed:	a1 34 e1 81 00       	mov    0x81e134,%eax
  8027f2:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8027f5:	89 50 08             	mov    %edx,0x8(%eax)
  8027f8:	eb 08                	jmp    802802 <smalloc+0x46a>
  8027fa:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027fd:	a3 30 e1 81 00       	mov    %eax,0x81e130
  802802:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802805:	a3 34 e1 81 00       	mov    %eax,0x81e134
  80280a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80280d:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802814:	a1 3c e1 81 00       	mov    0x81e13c,%eax
  802819:	40                   	inc    %eax
  80281a:	a3 3c e1 81 00       	mov    %eax,0x81e13c
					LIST_REMOVE(&u_freelist ,currentfreeelement);
  80281f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802823:	75 17                	jne    80283c <smalloc+0x4a4>
  802825:	83 ec 04             	sub    $0x4,%esp
  802828:	68 1b 4c 80 00       	push   $0x804c1b
  80282d:	68 8d 01 00 00       	push   $0x18d
  802832:	68 ac 4b 80 00       	push   $0x804bac
  802837:	e8 1b 18 00 00       	call   804057 <_panic>
  80283c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80283f:	8b 40 08             	mov    0x8(%eax),%eax
  802842:	85 c0                	test   %eax,%eax
  802844:	74 11                	je     802857 <smalloc+0x4bf>
  802846:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802849:	8b 40 08             	mov    0x8(%eax),%eax
  80284c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80284f:	8b 52 0c             	mov    0xc(%edx),%edx
  802852:	89 50 0c             	mov    %edx,0xc(%eax)
  802855:	eb 0b                	jmp    802862 <smalloc+0x4ca>
  802857:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80285a:	8b 40 0c             	mov    0xc(%eax),%eax
  80285d:	a3 24 e1 81 00       	mov    %eax,0x81e124
  802862:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802865:	8b 40 0c             	mov    0xc(%eax),%eax
  802868:	85 c0                	test   %eax,%eax
  80286a:	74 11                	je     80287d <smalloc+0x4e5>
  80286c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80286f:	8b 40 0c             	mov    0xc(%eax),%eax
  802872:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802875:	8b 52 08             	mov    0x8(%edx),%edx
  802878:	89 50 08             	mov    %edx,0x8(%eax)
  80287b:	eb 0b                	jmp    802888 <smalloc+0x4f0>
  80287d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802880:	8b 40 08             	mov    0x8(%eax),%eax
  802883:	a3 20 e1 81 00       	mov    %eax,0x81e120
  802888:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80288b:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802892:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802895:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  80289c:	a1 2c e1 81 00       	mov    0x81e12c,%eax
  8028a1:	48                   	dec    %eax
  8028a2:	a3 2c e1 81 00       	mov    %eax,0x81e12c
					int result = sys_create_shared_object(sharedVarName ,size ,isWritable ,(void*)allocblock->startva);
  8028a7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028aa:	8b 00                	mov    (%eax),%eax
  8028ac:	89 c2                	mov    %eax,%edx
  8028ae:	0f b6 45 c4          	movzbl -0x3c(%ebp),%eax
  8028b2:	52                   	push   %edx
  8028b3:	50                   	push   %eax
  8028b4:	ff 75 0c             	pushl  0xc(%ebp)
  8028b7:	ff 75 08             	pushl  0x8(%ebp)
  8028ba:	e8 75 08 00 00       	call   803134 <sys_create_shared_object>
  8028bf:	83 c4 10             	add    $0x10,%esp
  8028c2:	89 45 dc             	mov    %eax,-0x24(%ebp)

					if(result <0){
  8028c5:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8028c9:	79 25                	jns    8028f0 <smalloc+0x558>
						free_block(allocblock);
  8028cb:	83 ec 0c             	sub    $0xc,%esp
  8028ce:	ff 75 ec             	pushl  -0x14(%ebp)
  8028d1:	e8 fc 12 00 00       	call   803bd2 <free_block>
  8028d6:	83 c4 10             	add    $0x10,%esp
						release_uspinlock(&ulock);
  8028d9:	83 ec 0c             	sub    $0xc,%esp
  8028dc:	68 40 e1 81 00       	push   $0x81e140
  8028e1:	e8 10 17 00 00       	call   803ff6 <release_uspinlock>
  8028e6:	83 c4 10             	add    $0x10,%esp
						return NULL;
  8028e9:	b8 00 00 00 00       	mov    $0x0,%eax
  8028ee:	eb 4d                	jmp    80293d <smalloc+0x5a5>
					}
					release_uspinlock(&ulock);
  8028f0:	83 ec 0c             	sub    $0xc,%esp
  8028f3:	68 40 e1 81 00       	push   $0x81e140
  8028f8:	e8 f9 16 00 00       	call   803ff6 <release_uspinlock>
  8028fd:	83 c4 10             	add    $0x10,%esp
					return (void*)allocblock->startva;
  802900:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802903:	8b 00                	mov    (%eax),%eax
  802905:	eb 36                	jmp    80293d <smalloc+0x5a5>
				}
				currentfreeelement = currentfreeelement->prev_next_info.le_next;
  802907:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80290a:	8b 40 08             	mov    0x8(%eax),%eax
  80290d:	89 45 f4             	mov    %eax,-0xc(%ebp)
					 }
		}else{
			//custom fit
			struct UserHeapStruct* currentfreeelement = LIST_FIRST(&u_freelist);
			//worst fit
			while(currentfreeelement != NULL){
  802910:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802914:	0f 85 47 fc ff ff    	jne    802561 <smalloc+0x1c9>
					return (void*)allocblock->startva;
				}
				currentfreeelement = currentfreeelement->prev_next_info.le_next;
			}
		}
		free_block(allocblock);
  80291a:	83 ec 0c             	sub    $0xc,%esp
  80291d:	ff 75 ec             	pushl  -0x14(%ebp)
  802920:	e8 ad 12 00 00       	call   803bd2 <free_block>
  802925:	83 c4 10             	add    $0x10,%esp
		release_uspinlock(&ulock);
  802928:	83 ec 0c             	sub    $0xc,%esp
  80292b:	68 40 e1 81 00       	push   $0x81e140
  802930:	e8 c1 16 00 00       	call   803ff6 <release_uspinlock>
  802935:	83 c4 10             	add    $0x10,%esp
		return NULL;
  802938:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80293d:	c9                   	leave  
  80293e:	c3                   	ret    

0080293f <sget>:

//========================================
// [4] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  80293f:	55                   	push   %ebp
  802940:	89 e5                	mov    %esp,%ebp
  802942:	83 ec 38             	sub    $0x38,%esp


	 //==============================================================
	 // DON'T CHANGE THIS CODE
	    uheap_init();
  802945:	e8 8c ec ff ff       	call   8015d6 <uheap_init>
	 //==============================================================
	 // Get size of the shared variable from kernel
	acquire_uspinlock(&ulock);
  80294a:	83 ec 0c             	sub    $0xc,%esp
  80294d:	68 40 e1 81 00       	push   $0x81e140
  802952:	e8 47 16 00 00       	call   803f9e <acquire_uspinlock>
  802957:	83 c4 10             	add    $0x10,%esp


	int size = sys_size_of_shared_object(ownerEnvID ,sharedVarName);
  80295a:	83 ec 08             	sub    $0x8,%esp
  80295d:	ff 75 0c             	pushl  0xc(%ebp)
  802960:	ff 75 08             	pushl  0x8(%ebp)
  802963:	e8 f6 07 00 00       	call   80315e <sys_size_of_shared_object>
  802968:	83 c4 10             	add    $0x10,%esp
  80296b:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if ( size < 0 ){
  80296e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802972:	79 1a                	jns    80298e <sget+0x4f>
			release_uspinlock(&ulock);
  802974:	83 ec 0c             	sub    $0xc,%esp
  802977:	68 40 e1 81 00       	push   $0x81e140
  80297c:	e8 75 16 00 00       	call   803ff6 <release_uspinlock>
  802981:	83 c4 10             	add    $0x10,%esp
			return NULL;
  802984:	b8 00 00 00 00       	mov    $0x0,%eax
  802989:	e9 6e 05 00 00       	jmp    802efc <sget+0x5bd>
		}
		size = ROUNDUP(size,PAGE_SIZE);
  80298e:	c7 45 e8 00 10 00 00 	movl   $0x1000,-0x18(%ebp)
  802995:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802998:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80299b:	01 d0                	add    %edx,%eax
  80299d:	48                   	dec    %eax
  80299e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8029a1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8029a4:	ba 00 00 00 00       	mov    $0x0,%edx
  8029a9:	f7 75 e8             	divl   -0x18(%ebp)
  8029ac:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8029af:	29 d0                	sub    %edx,%eax
  8029b1:	89 45 ec             	mov    %eax,-0x14(%ebp)

		struct UserHeapStruct* allocblock = (struct UserHeapStruct*) alloc_block(sizeof(struct UserHeapStruct));
  8029b4:	83 ec 0c             	sub    $0xc,%esp
  8029b7:	6a 10                	push   $0x10
  8029b9:	e8 78 0d 00 00       	call   803736 <alloc_block>
  8029be:	83 c4 10             	add    $0x10,%esp
  8029c1:	89 45 e0             	mov    %eax,-0x20(%ebp)

		if (allocblock == NULL){
  8029c4:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8029c8:	75 0a                	jne    8029d4 <sget+0x95>
			return NULL;
  8029ca:	b8 00 00 00 00       	mov    $0x0,%eax
  8029cf:	e9 28 05 00 00       	jmp    802efc <sget+0x5bd>
		}
		struct UserHeapStruct* lastfreeelement = LIST_LAST(&u_freelist);
  8029d4:	a1 24 e1 81 00       	mov    0x81e124,%eax
  8029d9:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if(LIST_SIZE(&u_freelist)==0 || size>lastfreeelement->size){
  8029dc:	a1 2c e1 81 00       	mov    0x81e12c,%eax
  8029e1:	85 c0                	test   %eax,%eax
  8029e3:	74 11                	je     8029f6 <sget+0xb7>
  8029e5:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8029e8:	8b 50 04             	mov    0x4(%eax),%edx
  8029eb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029ee:	39 c2                	cmp    %eax,%edx
  8029f0:	0f 83 21 01 00 00    	jae    802b17 <sget+0x1d8>
				if(uheapPageAllocBreak <= USER_HEAP_MAX - size){
  8029f6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029f9:	ba 00 00 00 a0       	mov    $0xa0000000,%edx
  8029fe:	29 c2                	sub    %eax,%edx
  802a00:	a1 68 e0 81 00       	mov    0x81e068,%eax
  802a05:	39 c2                	cmp    %eax,%edx
  802a07:	0f 82 f0 00 00 00    	jb     802afd <sget+0x1be>

						uint32 requestedblockva = uheapPageAllocBreak;
  802a0d:	a1 68 e0 81 00       	mov    0x81e068,%eax
  802a12:	89 45 d0             	mov    %eax,-0x30(%ebp)
						uheapPageAllocBreak+=size;
  802a15:	8b 15 68 e0 81 00    	mov    0x81e068,%edx
  802a1b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a1e:	01 d0                	add    %edx,%eax
  802a20:	a3 68 e0 81 00       	mov    %eax,0x81e068
						allocblock->startva = requestedblockva;
  802a25:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802a28:	8b 55 d0             	mov    -0x30(%ebp),%edx
  802a2b:	89 10                	mov    %edx,(%eax)
						allocblock->size = size;
  802a2d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802a30:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802a33:	89 50 04             	mov    %edx,0x4(%eax)

						LIST_INSERT_TAIL(&u_allocatedlist, allocblock);
  802a36:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802a3a:	75 17                	jne    802a53 <sget+0x114>
  802a3c:	83 ec 04             	sub    $0x4,%esp
  802a3f:	68 f8 4b 80 00       	push   $0x804bf8
  802a44:	68 c8 01 00 00       	push   $0x1c8
  802a49:	68 ac 4b 80 00       	push   $0x804bac
  802a4e:	e8 04 16 00 00       	call   804057 <_panic>
  802a53:	8b 15 34 e1 81 00    	mov    0x81e134,%edx
  802a59:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802a5c:	89 50 0c             	mov    %edx,0xc(%eax)
  802a5f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802a62:	8b 40 0c             	mov    0xc(%eax),%eax
  802a65:	85 c0                	test   %eax,%eax
  802a67:	74 0d                	je     802a76 <sget+0x137>
  802a69:	a1 34 e1 81 00       	mov    0x81e134,%eax
  802a6e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802a71:	89 50 08             	mov    %edx,0x8(%eax)
  802a74:	eb 08                	jmp    802a7e <sget+0x13f>
  802a76:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802a79:	a3 30 e1 81 00       	mov    %eax,0x81e130
  802a7e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802a81:	a3 34 e1 81 00       	mov    %eax,0x81e134
  802a86:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802a89:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802a90:	a1 3c e1 81 00       	mov    0x81e13c,%eax
  802a95:	40                   	inc    %eax
  802a96:	a3 3c e1 81 00       	mov    %eax,0x81e13c


						int result = sys_get_shared_object(ownerEnvID ,sharedVarName ,(void*)allocblock->startva);
  802a9b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802a9e:	8b 00                	mov    (%eax),%eax
  802aa0:	83 ec 04             	sub    $0x4,%esp
  802aa3:	50                   	push   %eax
  802aa4:	ff 75 0c             	pushl  0xc(%ebp)
  802aa7:	ff 75 08             	pushl  0x8(%ebp)
  802aaa:	e8 cc 06 00 00       	call   80317b <sys_get_shared_object>
  802aaf:	83 c4 10             	add    $0x10,%esp
  802ab2:	89 45 cc             	mov    %eax,-0x34(%ebp)

						if(result <0){
  802ab5:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802ab9:	79 28                	jns    802ae3 <sget+0x1a4>
							free_block(allocblock);
  802abb:	83 ec 0c             	sub    $0xc,%esp
  802abe:	ff 75 e0             	pushl  -0x20(%ebp)
  802ac1:	e8 0c 11 00 00       	call   803bd2 <free_block>
  802ac6:	83 c4 10             	add    $0x10,%esp
							release_uspinlock(&ulock);
  802ac9:	83 ec 0c             	sub    $0xc,%esp
  802acc:	68 40 e1 81 00       	push   $0x81e140
  802ad1:	e8 20 15 00 00       	call   803ff6 <release_uspinlock>
  802ad6:	83 c4 10             	add    $0x10,%esp
							return NULL;
  802ad9:	b8 00 00 00 00       	mov    $0x0,%eax
  802ade:	e9 19 04 00 00       	jmp    802efc <sget+0x5bd>
						}
						release_uspinlock(&ulock);
  802ae3:	83 ec 0c             	sub    $0xc,%esp
  802ae6:	68 40 e1 81 00       	push   $0x81e140
  802aeb:	e8 06 15 00 00       	call   803ff6 <release_uspinlock>
  802af0:	83 c4 10             	add    $0x10,%esp
						return (void*)allocblock -> startva;
  802af3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802af6:	8b 00                	mov    (%eax),%eax
  802af8:	e9 ff 03 00 00       	jmp    802efc <sget+0x5bd>
				}else{
						release_uspinlock(&ulock);
  802afd:	83 ec 0c             	sub    $0xc,%esp
  802b00:	68 40 e1 81 00       	push   $0x81e140
  802b05:	e8 ec 14 00 00       	call   803ff6 <release_uspinlock>
  802b0a:	83 c4 10             	add    $0x10,%esp
						return NULL;
  802b0d:	b8 00 00 00 00       	mov    $0x0,%eax
  802b12:	e9 e5 03 00 00       	jmp    802efc <sget+0x5bd>
					 }
		}else{
			//custom fit
			struct UserHeapStruct* currentfreeelement = LIST_FIRST(&u_freelist);
  802b17:	a1 20 e1 81 00       	mov    0x81e120,%eax
  802b1c:	89 45 f4             	mov    %eax,-0xc(%ebp)
			//worst fit
			while(currentfreeelement != NULL){
  802b1f:	e9 ab 03 00 00       	jmp    802ecf <sget+0x590>
				if(size<currentfreeelement->size){
  802b24:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b27:	8b 50 04             	mov    0x4(%eax),%edx
  802b2a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b2d:	39 c2                	cmp    %eax,%edx
  802b2f:	0f 86 24 02 00 00    	jbe    802d59 <sget+0x41a>
					allocblock->startva = lastfreeelement->startva;
  802b35:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802b38:	8b 10                	mov    (%eax),%edx
  802b3a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802b3d:	89 10                	mov    %edx,(%eax)
					allocblock->size = size;
  802b3f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802b42:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802b45:	89 50 04             	mov    %edx,0x4(%eax)
					LIST_INSERT_TAIL(&u_allocatedlist,allocblock);
  802b48:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802b4c:	75 17                	jne    802b65 <sget+0x226>
  802b4e:	83 ec 04             	sub    $0x4,%esp
  802b51:	68 f8 4b 80 00       	push   $0x804bf8
  802b56:	68 e0 01 00 00       	push   $0x1e0
  802b5b:	68 ac 4b 80 00       	push   $0x804bac
  802b60:	e8 f2 14 00 00       	call   804057 <_panic>
  802b65:	8b 15 34 e1 81 00    	mov    0x81e134,%edx
  802b6b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802b6e:	89 50 0c             	mov    %edx,0xc(%eax)
  802b71:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802b74:	8b 40 0c             	mov    0xc(%eax),%eax
  802b77:	85 c0                	test   %eax,%eax
  802b79:	74 0d                	je     802b88 <sget+0x249>
  802b7b:	a1 34 e1 81 00       	mov    0x81e134,%eax
  802b80:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802b83:	89 50 08             	mov    %edx,0x8(%eax)
  802b86:	eb 08                	jmp    802b90 <sget+0x251>
  802b88:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802b8b:	a3 30 e1 81 00       	mov    %eax,0x81e130
  802b90:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802b93:	a3 34 e1 81 00       	mov    %eax,0x81e134
  802b98:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802b9b:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802ba2:	a1 3c e1 81 00       	mov    0x81e13c,%eax
  802ba7:	40                   	inc    %eax
  802ba8:	a3 3c e1 81 00       	mov    %eax,0x81e13c
					lastfreeelement->startva += size;
  802bad:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802bb0:	8b 10                	mov    (%eax),%edx
  802bb2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bb5:	01 c2                	add    %eax,%edx
  802bb7:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802bba:	89 10                	mov    %edx,(%eax)
					lastfreeelement->size -= size;
  802bbc:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802bbf:	8b 50 04             	mov    0x4(%eax),%edx
  802bc2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bc5:	29 c2                	sub    %eax,%edx
  802bc7:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802bca:	89 50 04             	mov    %edx,0x4(%eax)
					struct UserHeapStruct* currentfree2 = LIST_FIRST(&u_freelist);
  802bcd:	a1 20 e1 81 00       	mov    0x81e120,%eax
  802bd2:	89 45 f0             	mov    %eax,-0x10(%ebp)
					//check order of last element

					while (currentfree2 != NULL){
  802bd5:	e9 13 01 00 00       	jmp    802ced <sget+0x3ae>
						if(lastfreeelement->size <currentfree2->size){
  802bda:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802bdd:	8b 50 04             	mov    0x4(%eax),%edx
  802be0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802be3:	8b 40 04             	mov    0x4(%eax),%eax
  802be6:	39 c2                	cmp    %eax,%edx
  802be8:	0f 83 f6 00 00 00    	jae    802ce4 <sget+0x3a5>
							LIST_REMOVE(&u_freelist ,lastfreeelement);
  802bee:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802bf2:	75 17                	jne    802c0b <sget+0x2cc>
  802bf4:	83 ec 04             	sub    $0x4,%esp
  802bf7:	68 1b 4c 80 00       	push   $0x804c1b
  802bfc:	68 e8 01 00 00       	push   $0x1e8
  802c01:	68 ac 4b 80 00       	push   $0x804bac
  802c06:	e8 4c 14 00 00       	call   804057 <_panic>
  802c0b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802c0e:	8b 40 08             	mov    0x8(%eax),%eax
  802c11:	85 c0                	test   %eax,%eax
  802c13:	74 11                	je     802c26 <sget+0x2e7>
  802c15:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802c18:	8b 40 08             	mov    0x8(%eax),%eax
  802c1b:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802c1e:	8b 52 0c             	mov    0xc(%edx),%edx
  802c21:	89 50 0c             	mov    %edx,0xc(%eax)
  802c24:	eb 0b                	jmp    802c31 <sget+0x2f2>
  802c26:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802c29:	8b 40 0c             	mov    0xc(%eax),%eax
  802c2c:	a3 24 e1 81 00       	mov    %eax,0x81e124
  802c31:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802c34:	8b 40 0c             	mov    0xc(%eax),%eax
  802c37:	85 c0                	test   %eax,%eax
  802c39:	74 11                	je     802c4c <sget+0x30d>
  802c3b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802c3e:	8b 40 0c             	mov    0xc(%eax),%eax
  802c41:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802c44:	8b 52 08             	mov    0x8(%edx),%edx
  802c47:	89 50 08             	mov    %edx,0x8(%eax)
  802c4a:	eb 0b                	jmp    802c57 <sget+0x318>
  802c4c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802c4f:	8b 40 08             	mov    0x8(%eax),%eax
  802c52:	a3 20 e1 81 00       	mov    %eax,0x81e120
  802c57:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802c5a:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802c61:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802c64:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  802c6b:	a1 2c e1 81 00       	mov    0x81e12c,%eax
  802c70:	48                   	dec    %eax
  802c71:	a3 2c e1 81 00       	mov    %eax,0x81e12c
							LIST_INSERT_BEFORE(&u_freelist ,currentfree2 ,lastfreeelement);
  802c76:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802c7a:	74 06                	je     802c82 <sget+0x343>
  802c7c:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802c80:	75 17                	jne    802c99 <sget+0x35a>
  802c82:	83 ec 04             	sub    $0x4,%esp
  802c85:	68 3c 4c 80 00       	push   $0x804c3c
  802c8a:	68 e9 01 00 00       	push   $0x1e9
  802c8f:	68 ac 4b 80 00       	push   $0x804bac
  802c94:	e8 be 13 00 00       	call   804057 <_panic>
  802c99:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c9c:	8b 50 0c             	mov    0xc(%eax),%edx
  802c9f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802ca2:	89 50 0c             	mov    %edx,0xc(%eax)
  802ca5:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802ca8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802cab:	89 50 08             	mov    %edx,0x8(%eax)
  802cae:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cb1:	8b 40 0c             	mov    0xc(%eax),%eax
  802cb4:	85 c0                	test   %eax,%eax
  802cb6:	74 0e                	je     802cc6 <sget+0x387>
  802cb8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cbb:	8b 40 0c             	mov    0xc(%eax),%eax
  802cbe:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802cc1:	89 50 08             	mov    %edx,0x8(%eax)
  802cc4:	eb 08                	jmp    802cce <sget+0x38f>
  802cc6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802cc9:	a3 20 e1 81 00       	mov    %eax,0x81e120
  802cce:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cd1:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802cd4:	89 50 0c             	mov    %edx,0xc(%eax)
  802cd7:	a1 2c e1 81 00       	mov    0x81e12c,%eax
  802cdc:	40                   	inc    %eax
  802cdd:	a3 2c e1 81 00       	mov    %eax,0x81e12c
							break;
  802ce2:	eb 13                	jmp    802cf7 <sget+0x3b8>
						}
						currentfree2 = currentfree2->prev_next_info.le_next;
  802ce4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ce7:	8b 40 08             	mov    0x8(%eax),%eax
  802cea:	89 45 f0             	mov    %eax,-0x10(%ebp)
					lastfreeelement->startva += size;
					lastfreeelement->size -= size;
					struct UserHeapStruct* currentfree2 = LIST_FIRST(&u_freelist);
					//check order of last element

					while (currentfree2 != NULL){
  802ced:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802cf1:	0f 85 e3 fe ff ff    	jne    802bda <sget+0x29b>
						}
						currentfree2 = currentfree2->prev_next_info.le_next;
					}


					int result = sys_get_shared_object(ownerEnvID ,sharedVarName ,(void*)allocblock->startva);
  802cf7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802cfa:	8b 00                	mov    (%eax),%eax
  802cfc:	83 ec 04             	sub    $0x4,%esp
  802cff:	50                   	push   %eax
  802d00:	ff 75 0c             	pushl  0xc(%ebp)
  802d03:	ff 75 08             	pushl  0x8(%ebp)
  802d06:	e8 70 04 00 00       	call   80317b <sys_get_shared_object>
  802d0b:	83 c4 10             	add    $0x10,%esp
  802d0e:	89 45 d4             	mov    %eax,-0x2c(%ebp)

					if(result <0){
  802d11:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  802d15:	79 28                	jns    802d3f <sget+0x400>
						free_block(allocblock);
  802d17:	83 ec 0c             	sub    $0xc,%esp
  802d1a:	ff 75 e0             	pushl  -0x20(%ebp)
  802d1d:	e8 b0 0e 00 00       	call   803bd2 <free_block>
  802d22:	83 c4 10             	add    $0x10,%esp
						release_uspinlock(&ulock);
  802d25:	83 ec 0c             	sub    $0xc,%esp
  802d28:	68 40 e1 81 00       	push   $0x81e140
  802d2d:	e8 c4 12 00 00       	call   803ff6 <release_uspinlock>
  802d32:	83 c4 10             	add    $0x10,%esp
						return NULL;
  802d35:	b8 00 00 00 00       	mov    $0x0,%eax
  802d3a:	e9 bd 01 00 00       	jmp    802efc <sget+0x5bd>
					}
					release_uspinlock(&ulock);
  802d3f:	83 ec 0c             	sub    $0xc,%esp
  802d42:	68 40 e1 81 00       	push   $0x81e140
  802d47:	e8 aa 12 00 00       	call   803ff6 <release_uspinlock>
  802d4c:	83 c4 10             	add    $0x10,%esp
					return (void*)allocblock->startva;
  802d4f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802d52:	8b 00                	mov    (%eax),%eax
  802d54:	e9 a3 01 00 00       	jmp    802efc <sget+0x5bd>
					//exact fit
				}else if(size == currentfreeelement->size){
  802d59:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d5c:	8b 50 04             	mov    0x4(%eax),%edx
  802d5f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d62:	39 c2                	cmp    %eax,%edx
  802d64:	0f 85 5c 01 00 00    	jne    802ec6 <sget+0x587>

					allocblock->startva = currentfreeelement->startva;
  802d6a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d6d:	8b 10                	mov    (%eax),%edx
  802d6f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802d72:	89 10                	mov    %edx,(%eax)
					allocblock->size = size;
  802d74:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802d77:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802d7a:	89 50 04             	mov    %edx,0x4(%eax)
					LIST_INSERT_TAIL(&u_allocatedlist ,allocblock);
  802d7d:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802d81:	75 17                	jne    802d9a <sget+0x45b>
  802d83:	83 ec 04             	sub    $0x4,%esp
  802d86:	68 f8 4b 80 00       	push   $0x804bf8
  802d8b:	68 fe 01 00 00       	push   $0x1fe
  802d90:	68 ac 4b 80 00       	push   $0x804bac
  802d95:	e8 bd 12 00 00       	call   804057 <_panic>
  802d9a:	8b 15 34 e1 81 00    	mov    0x81e134,%edx
  802da0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802da3:	89 50 0c             	mov    %edx,0xc(%eax)
  802da6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802da9:	8b 40 0c             	mov    0xc(%eax),%eax
  802dac:	85 c0                	test   %eax,%eax
  802dae:	74 0d                	je     802dbd <sget+0x47e>
  802db0:	a1 34 e1 81 00       	mov    0x81e134,%eax
  802db5:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802db8:	89 50 08             	mov    %edx,0x8(%eax)
  802dbb:	eb 08                	jmp    802dc5 <sget+0x486>
  802dbd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802dc0:	a3 30 e1 81 00       	mov    %eax,0x81e130
  802dc5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802dc8:	a3 34 e1 81 00       	mov    %eax,0x81e134
  802dcd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802dd0:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802dd7:	a1 3c e1 81 00       	mov    0x81e13c,%eax
  802ddc:	40                   	inc    %eax
  802ddd:	a3 3c e1 81 00       	mov    %eax,0x81e13c
					LIST_REMOVE(&u_freelist ,currentfreeelement);
  802de2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802de6:	75 17                	jne    802dff <sget+0x4c0>
  802de8:	83 ec 04             	sub    $0x4,%esp
  802deb:	68 1b 4c 80 00       	push   $0x804c1b
  802df0:	68 ff 01 00 00       	push   $0x1ff
  802df5:	68 ac 4b 80 00       	push   $0x804bac
  802dfa:	e8 58 12 00 00       	call   804057 <_panic>
  802dff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e02:	8b 40 08             	mov    0x8(%eax),%eax
  802e05:	85 c0                	test   %eax,%eax
  802e07:	74 11                	je     802e1a <sget+0x4db>
  802e09:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e0c:	8b 40 08             	mov    0x8(%eax),%eax
  802e0f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e12:	8b 52 0c             	mov    0xc(%edx),%edx
  802e15:	89 50 0c             	mov    %edx,0xc(%eax)
  802e18:	eb 0b                	jmp    802e25 <sget+0x4e6>
  802e1a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e1d:	8b 40 0c             	mov    0xc(%eax),%eax
  802e20:	a3 24 e1 81 00       	mov    %eax,0x81e124
  802e25:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e28:	8b 40 0c             	mov    0xc(%eax),%eax
  802e2b:	85 c0                	test   %eax,%eax
  802e2d:	74 11                	je     802e40 <sget+0x501>
  802e2f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e32:	8b 40 0c             	mov    0xc(%eax),%eax
  802e35:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e38:	8b 52 08             	mov    0x8(%edx),%edx
  802e3b:	89 50 08             	mov    %edx,0x8(%eax)
  802e3e:	eb 0b                	jmp    802e4b <sget+0x50c>
  802e40:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e43:	8b 40 08             	mov    0x8(%eax),%eax
  802e46:	a3 20 e1 81 00       	mov    %eax,0x81e120
  802e4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e4e:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802e55:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e58:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  802e5f:	a1 2c e1 81 00       	mov    0x81e12c,%eax
  802e64:	48                   	dec    %eax
  802e65:	a3 2c e1 81 00       	mov    %eax,0x81e12c

					int result = sys_get_shared_object(ownerEnvID ,sharedVarName ,(void*)allocblock->startva);
  802e6a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802e6d:	8b 00                	mov    (%eax),%eax
  802e6f:	83 ec 04             	sub    $0x4,%esp
  802e72:	50                   	push   %eax
  802e73:	ff 75 0c             	pushl  0xc(%ebp)
  802e76:	ff 75 08             	pushl  0x8(%ebp)
  802e79:	e8 fd 02 00 00       	call   80317b <sys_get_shared_object>
  802e7e:	83 c4 10             	add    $0x10,%esp
  802e81:	89 45 d8             	mov    %eax,-0x28(%ebp)
					if(result <0){
  802e84:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  802e88:	79 25                	jns    802eaf <sget+0x570>
						free_block(allocblock);
  802e8a:	83 ec 0c             	sub    $0xc,%esp
  802e8d:	ff 75 e0             	pushl  -0x20(%ebp)
  802e90:	e8 3d 0d 00 00       	call   803bd2 <free_block>
  802e95:	83 c4 10             	add    $0x10,%esp
						release_uspinlock(&ulock);
  802e98:	83 ec 0c             	sub    $0xc,%esp
  802e9b:	68 40 e1 81 00       	push   $0x81e140
  802ea0:	e8 51 11 00 00       	call   803ff6 <release_uspinlock>
  802ea5:	83 c4 10             	add    $0x10,%esp
						return NULL;
  802ea8:	b8 00 00 00 00       	mov    $0x0,%eax
  802ead:	eb 4d                	jmp    802efc <sget+0x5bd>
					}

					release_uspinlock(&ulock);
  802eaf:	83 ec 0c             	sub    $0xc,%esp
  802eb2:	68 40 e1 81 00       	push   $0x81e140
  802eb7:	e8 3a 11 00 00       	call   803ff6 <release_uspinlock>
  802ebc:	83 c4 10             	add    $0x10,%esp
					return (void*)allocblock->startva;
  802ebf:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802ec2:	8b 00                	mov    (%eax),%eax
  802ec4:	eb 36                	jmp    802efc <sget+0x5bd>
				}
				currentfreeelement = currentfreeelement->prev_next_info.le_next;
  802ec6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ec9:	8b 40 08             	mov    0x8(%eax),%eax
  802ecc:	89 45 f4             	mov    %eax,-0xc(%ebp)
					 }
		}else{
			//custom fit
			struct UserHeapStruct* currentfreeelement = LIST_FIRST(&u_freelist);
			//worst fit
			while(currentfreeelement != NULL){
  802ecf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ed3:	0f 85 4b fc ff ff    	jne    802b24 <sget+0x1e5>
					return (void*)allocblock->startva;
				}
				currentfreeelement = currentfreeelement->prev_next_info.le_next;
			}
		}
		free_block(allocblock);
  802ed9:	83 ec 0c             	sub    $0xc,%esp
  802edc:	ff 75 e0             	pushl  -0x20(%ebp)
  802edf:	e8 ee 0c 00 00       	call   803bd2 <free_block>
  802ee4:	83 c4 10             	add    $0x10,%esp
		release_uspinlock(&ulock);
  802ee7:	83 ec 0c             	sub    $0xc,%esp
  802eea:	68 40 e1 81 00       	push   $0x81e140
  802eef:	e8 02 11 00 00       	call   803ff6 <release_uspinlock>
  802ef4:	83 c4 10             	add    $0x10,%esp
		return NULL;
  802ef7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802efc:	c9                   	leave  
  802efd:	c3                   	ret    

00802efe <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  802efe:	55                   	push   %ebp
  802eff:	89 e5                	mov    %esp,%ebp
  802f01:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  802f04:	e8 cd e6 ff ff       	call   8015d6 <uheap_init>
	//==============================================================
	panic("realloc() is not implemented yet...!!");
  802f09:	83 ec 04             	sub    $0x4,%esp
  802f0c:	68 cc 4c 80 00       	push   $0x804ccc
  802f11:	68 2d 02 00 00       	push   $0x22d
  802f16:	68 ac 4b 80 00       	push   $0x804bac
  802f1b:	e8 37 11 00 00       	call   804057 <_panic>

00802f20 <sfree>:
//
//	use sys_delete_shared_object(...); which switches to the kernel mode,
//	calls delete_shared_object(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the delete_shared_object() function is empty, make sure to implement it.
void sfree(void* virtual_address)
{
  802f20:	55                   	push   %ebp
  802f21:	89 e5                	mov    %esp,%ebp
  802f23:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.BONUS#5] EXIT #2 - sfree
	//Your code is here
	//Comment the following line
	panic("sfree() is not implemented yet...!!");
  802f26:	83 ec 04             	sub    $0x4,%esp
  802f29:	68 f4 4c 80 00       	push   $0x804cf4
  802f2e:	68 40 02 00 00       	push   $0x240
  802f33:	68 ac 4b 80 00       	push   $0x804bac
  802f38:	e8 1a 11 00 00       	call   804057 <_panic>

00802f3d <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  802f3d:	55                   	push   %ebp
  802f3e:	89 e5                	mov    %esp,%ebp
  802f40:	57                   	push   %edi
  802f41:	56                   	push   %esi
  802f42:	53                   	push   %ebx
  802f43:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  802f46:	8b 45 08             	mov    0x8(%ebp),%eax
  802f49:	8b 55 0c             	mov    0xc(%ebp),%edx
  802f4c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802f4f:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802f52:	8b 7d 18             	mov    0x18(%ebp),%edi
  802f55:	8b 75 1c             	mov    0x1c(%ebp),%esi
  802f58:	cd 30                	int    $0x30
  802f5a:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  802f5d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  802f60:	83 c4 10             	add    $0x10,%esp
  802f63:	5b                   	pop    %ebx
  802f64:	5e                   	pop    %esi
  802f65:	5f                   	pop    %edi
  802f66:	5d                   	pop    %ebp
  802f67:	c3                   	ret    

00802f68 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  802f68:	55                   	push   %ebp
  802f69:	89 e5                	mov    %esp,%ebp
  802f6b:	83 ec 04             	sub    $0x4,%esp
  802f6e:	8b 45 10             	mov    0x10(%ebp),%eax
  802f71:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  802f74:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802f77:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802f7b:	8b 45 08             	mov    0x8(%ebp),%eax
  802f7e:	6a 00                	push   $0x0
  802f80:	51                   	push   %ecx
  802f81:	52                   	push   %edx
  802f82:	ff 75 0c             	pushl  0xc(%ebp)
  802f85:	50                   	push   %eax
  802f86:	6a 00                	push   $0x0
  802f88:	e8 b0 ff ff ff       	call   802f3d <syscall>
  802f8d:	83 c4 18             	add    $0x18,%esp
}
  802f90:	90                   	nop
  802f91:	c9                   	leave  
  802f92:	c3                   	ret    

00802f93 <sys_cgetc>:

int
sys_cgetc(void)
{
  802f93:	55                   	push   %ebp
  802f94:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  802f96:	6a 00                	push   $0x0
  802f98:	6a 00                	push   $0x0
  802f9a:	6a 00                	push   $0x0
  802f9c:	6a 00                	push   $0x0
  802f9e:	6a 00                	push   $0x0
  802fa0:	6a 02                	push   $0x2
  802fa2:	e8 96 ff ff ff       	call   802f3d <syscall>
  802fa7:	83 c4 18             	add    $0x18,%esp
}
  802faa:	c9                   	leave  
  802fab:	c3                   	ret    

00802fac <sys_lock_cons>:

void sys_lock_cons(void)
{
  802fac:	55                   	push   %ebp
  802fad:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  802faf:	6a 00                	push   $0x0
  802fb1:	6a 00                	push   $0x0
  802fb3:	6a 00                	push   $0x0
  802fb5:	6a 00                	push   $0x0
  802fb7:	6a 00                	push   $0x0
  802fb9:	6a 03                	push   $0x3
  802fbb:	e8 7d ff ff ff       	call   802f3d <syscall>
  802fc0:	83 c4 18             	add    $0x18,%esp
}
  802fc3:	90                   	nop
  802fc4:	c9                   	leave  
  802fc5:	c3                   	ret    

00802fc6 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  802fc6:	55                   	push   %ebp
  802fc7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  802fc9:	6a 00                	push   $0x0
  802fcb:	6a 00                	push   $0x0
  802fcd:	6a 00                	push   $0x0
  802fcf:	6a 00                	push   $0x0
  802fd1:	6a 00                	push   $0x0
  802fd3:	6a 04                	push   $0x4
  802fd5:	e8 63 ff ff ff       	call   802f3d <syscall>
  802fda:	83 c4 18             	add    $0x18,%esp
}
  802fdd:	90                   	nop
  802fde:	c9                   	leave  
  802fdf:	c3                   	ret    

00802fe0 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  802fe0:	55                   	push   %ebp
  802fe1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  802fe3:	8b 55 0c             	mov    0xc(%ebp),%edx
  802fe6:	8b 45 08             	mov    0x8(%ebp),%eax
  802fe9:	6a 00                	push   $0x0
  802feb:	6a 00                	push   $0x0
  802fed:	6a 00                	push   $0x0
  802fef:	52                   	push   %edx
  802ff0:	50                   	push   %eax
  802ff1:	6a 08                	push   $0x8
  802ff3:	e8 45 ff ff ff       	call   802f3d <syscall>
  802ff8:	83 c4 18             	add    $0x18,%esp
}
  802ffb:	c9                   	leave  
  802ffc:	c3                   	ret    

00802ffd <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  802ffd:	55                   	push   %ebp
  802ffe:	89 e5                	mov    %esp,%ebp
  803000:	56                   	push   %esi
  803001:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  803002:	8b 75 18             	mov    0x18(%ebp),%esi
  803005:	8b 5d 14             	mov    0x14(%ebp),%ebx
  803008:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80300b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80300e:	8b 45 08             	mov    0x8(%ebp),%eax
  803011:	56                   	push   %esi
  803012:	53                   	push   %ebx
  803013:	51                   	push   %ecx
  803014:	52                   	push   %edx
  803015:	50                   	push   %eax
  803016:	6a 09                	push   $0x9
  803018:	e8 20 ff ff ff       	call   802f3d <syscall>
  80301d:	83 c4 18             	add    $0x18,%esp
}
  803020:	8d 65 f8             	lea    -0x8(%ebp),%esp
  803023:	5b                   	pop    %ebx
  803024:	5e                   	pop    %esi
  803025:	5d                   	pop    %ebp
  803026:	c3                   	ret    

00803027 <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  803027:	55                   	push   %ebp
  803028:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  80302a:	6a 00                	push   $0x0
  80302c:	6a 00                	push   $0x0
  80302e:	6a 00                	push   $0x0
  803030:	6a 00                	push   $0x0
  803032:	ff 75 08             	pushl  0x8(%ebp)
  803035:	6a 0a                	push   $0xa
  803037:	e8 01 ff ff ff       	call   802f3d <syscall>
  80303c:	83 c4 18             	add    $0x18,%esp
}
  80303f:	c9                   	leave  
  803040:	c3                   	ret    

00803041 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  803041:	55                   	push   %ebp
  803042:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  803044:	6a 00                	push   $0x0
  803046:	6a 00                	push   $0x0
  803048:	6a 00                	push   $0x0
  80304a:	ff 75 0c             	pushl  0xc(%ebp)
  80304d:	ff 75 08             	pushl  0x8(%ebp)
  803050:	6a 0b                	push   $0xb
  803052:	e8 e6 fe ff ff       	call   802f3d <syscall>
  803057:	83 c4 18             	add    $0x18,%esp
}
  80305a:	c9                   	leave  
  80305b:	c3                   	ret    

0080305c <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  80305c:	55                   	push   %ebp
  80305d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  80305f:	6a 00                	push   $0x0
  803061:	6a 00                	push   $0x0
  803063:	6a 00                	push   $0x0
  803065:	6a 00                	push   $0x0
  803067:	6a 00                	push   $0x0
  803069:	6a 0c                	push   $0xc
  80306b:	e8 cd fe ff ff       	call   802f3d <syscall>
  803070:	83 c4 18             	add    $0x18,%esp
}
  803073:	c9                   	leave  
  803074:	c3                   	ret    

00803075 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  803075:	55                   	push   %ebp
  803076:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  803078:	6a 00                	push   $0x0
  80307a:	6a 00                	push   $0x0
  80307c:	6a 00                	push   $0x0
  80307e:	6a 00                	push   $0x0
  803080:	6a 00                	push   $0x0
  803082:	6a 0d                	push   $0xd
  803084:	e8 b4 fe ff ff       	call   802f3d <syscall>
  803089:	83 c4 18             	add    $0x18,%esp
}
  80308c:	c9                   	leave  
  80308d:	c3                   	ret    

0080308e <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  80308e:	55                   	push   %ebp
  80308f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  803091:	6a 00                	push   $0x0
  803093:	6a 00                	push   $0x0
  803095:	6a 00                	push   $0x0
  803097:	6a 00                	push   $0x0
  803099:	6a 00                	push   $0x0
  80309b:	6a 0e                	push   $0xe
  80309d:	e8 9b fe ff ff       	call   802f3d <syscall>
  8030a2:	83 c4 18             	add    $0x18,%esp
}
  8030a5:	c9                   	leave  
  8030a6:	c3                   	ret    

008030a7 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8030a7:	55                   	push   %ebp
  8030a8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8030aa:	6a 00                	push   $0x0
  8030ac:	6a 00                	push   $0x0
  8030ae:	6a 00                	push   $0x0
  8030b0:	6a 00                	push   $0x0
  8030b2:	6a 00                	push   $0x0
  8030b4:	6a 0f                	push   $0xf
  8030b6:	e8 82 fe ff ff       	call   802f3d <syscall>
  8030bb:	83 c4 18             	add    $0x18,%esp
}
  8030be:	c9                   	leave  
  8030bf:	c3                   	ret    

008030c0 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8030c0:	55                   	push   %ebp
  8030c1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8030c3:	6a 00                	push   $0x0
  8030c5:	6a 00                	push   $0x0
  8030c7:	6a 00                	push   $0x0
  8030c9:	6a 00                	push   $0x0
  8030cb:	ff 75 08             	pushl  0x8(%ebp)
  8030ce:	6a 10                	push   $0x10
  8030d0:	e8 68 fe ff ff       	call   802f3d <syscall>
  8030d5:	83 c4 18             	add    $0x18,%esp
}
  8030d8:	c9                   	leave  
  8030d9:	c3                   	ret    

008030da <sys_scarce_memory>:

void sys_scarce_memory()
{
  8030da:	55                   	push   %ebp
  8030db:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8030dd:	6a 00                	push   $0x0
  8030df:	6a 00                	push   $0x0
  8030e1:	6a 00                	push   $0x0
  8030e3:	6a 00                	push   $0x0
  8030e5:	6a 00                	push   $0x0
  8030e7:	6a 11                	push   $0x11
  8030e9:	e8 4f fe ff ff       	call   802f3d <syscall>
  8030ee:	83 c4 18             	add    $0x18,%esp
}
  8030f1:	90                   	nop
  8030f2:	c9                   	leave  
  8030f3:	c3                   	ret    

008030f4 <sys_cputc>:

void
sys_cputc(const char c)
{
  8030f4:	55                   	push   %ebp
  8030f5:	89 e5                	mov    %esp,%ebp
  8030f7:	83 ec 04             	sub    $0x4,%esp
  8030fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8030fd:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  803100:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  803104:	6a 00                	push   $0x0
  803106:	6a 00                	push   $0x0
  803108:	6a 00                	push   $0x0
  80310a:	6a 00                	push   $0x0
  80310c:	50                   	push   %eax
  80310d:	6a 01                	push   $0x1
  80310f:	e8 29 fe ff ff       	call   802f3d <syscall>
  803114:	83 c4 18             	add    $0x18,%esp
}
  803117:	90                   	nop
  803118:	c9                   	leave  
  803119:	c3                   	ret    

0080311a <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  80311a:	55                   	push   %ebp
  80311b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  80311d:	6a 00                	push   $0x0
  80311f:	6a 00                	push   $0x0
  803121:	6a 00                	push   $0x0
  803123:	6a 00                	push   $0x0
  803125:	6a 00                	push   $0x0
  803127:	6a 14                	push   $0x14
  803129:	e8 0f fe ff ff       	call   802f3d <syscall>
  80312e:	83 c4 18             	add    $0x18,%esp
}
  803131:	90                   	nop
  803132:	c9                   	leave  
  803133:	c3                   	ret    

00803134 <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  803134:	55                   	push   %ebp
  803135:	89 e5                	mov    %esp,%ebp
  803137:	83 ec 04             	sub    $0x4,%esp
  80313a:	8b 45 10             	mov    0x10(%ebp),%eax
  80313d:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  803140:	8b 4d 14             	mov    0x14(%ebp),%ecx
  803143:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  803147:	8b 45 08             	mov    0x8(%ebp),%eax
  80314a:	6a 00                	push   $0x0
  80314c:	51                   	push   %ecx
  80314d:	52                   	push   %edx
  80314e:	ff 75 0c             	pushl  0xc(%ebp)
  803151:	50                   	push   %eax
  803152:	6a 15                	push   $0x15
  803154:	e8 e4 fd ff ff       	call   802f3d <syscall>
  803159:	83 c4 18             	add    $0x18,%esp
}
  80315c:	c9                   	leave  
  80315d:	c3                   	ret    

0080315e <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  80315e:	55                   	push   %ebp
  80315f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  803161:	8b 55 0c             	mov    0xc(%ebp),%edx
  803164:	8b 45 08             	mov    0x8(%ebp),%eax
  803167:	6a 00                	push   $0x0
  803169:	6a 00                	push   $0x0
  80316b:	6a 00                	push   $0x0
  80316d:	52                   	push   %edx
  80316e:	50                   	push   %eax
  80316f:	6a 16                	push   $0x16
  803171:	e8 c7 fd ff ff       	call   802f3d <syscall>
  803176:	83 c4 18             	add    $0x18,%esp
}
  803179:	c9                   	leave  
  80317a:	c3                   	ret    

0080317b <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  80317b:	55                   	push   %ebp
  80317c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  80317e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  803181:	8b 55 0c             	mov    0xc(%ebp),%edx
  803184:	8b 45 08             	mov    0x8(%ebp),%eax
  803187:	6a 00                	push   $0x0
  803189:	6a 00                	push   $0x0
  80318b:	51                   	push   %ecx
  80318c:	52                   	push   %edx
  80318d:	50                   	push   %eax
  80318e:	6a 17                	push   $0x17
  803190:	e8 a8 fd ff ff       	call   802f3d <syscall>
  803195:	83 c4 18             	add    $0x18,%esp
}
  803198:	c9                   	leave  
  803199:	c3                   	ret    

0080319a <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  80319a:	55                   	push   %ebp
  80319b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  80319d:	8b 55 0c             	mov    0xc(%ebp),%edx
  8031a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8031a3:	6a 00                	push   $0x0
  8031a5:	6a 00                	push   $0x0
  8031a7:	6a 00                	push   $0x0
  8031a9:	52                   	push   %edx
  8031aa:	50                   	push   %eax
  8031ab:	6a 18                	push   $0x18
  8031ad:	e8 8b fd ff ff       	call   802f3d <syscall>
  8031b2:	83 c4 18             	add    $0x18,%esp
}
  8031b5:	c9                   	leave  
  8031b6:	c3                   	ret    

008031b7 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8031b7:	55                   	push   %ebp
  8031b8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8031ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8031bd:	6a 00                	push   $0x0
  8031bf:	ff 75 14             	pushl  0x14(%ebp)
  8031c2:	ff 75 10             	pushl  0x10(%ebp)
  8031c5:	ff 75 0c             	pushl  0xc(%ebp)
  8031c8:	50                   	push   %eax
  8031c9:	6a 19                	push   $0x19
  8031cb:	e8 6d fd ff ff       	call   802f3d <syscall>
  8031d0:	83 c4 18             	add    $0x18,%esp
}
  8031d3:	c9                   	leave  
  8031d4:	c3                   	ret    

008031d5 <sys_run_env>:

void sys_run_env(int32 envId)
{
  8031d5:	55                   	push   %ebp
  8031d6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8031d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8031db:	6a 00                	push   $0x0
  8031dd:	6a 00                	push   $0x0
  8031df:	6a 00                	push   $0x0
  8031e1:	6a 00                	push   $0x0
  8031e3:	50                   	push   %eax
  8031e4:	6a 1a                	push   $0x1a
  8031e6:	e8 52 fd ff ff       	call   802f3d <syscall>
  8031eb:	83 c4 18             	add    $0x18,%esp
}
  8031ee:	90                   	nop
  8031ef:	c9                   	leave  
  8031f0:	c3                   	ret    

008031f1 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8031f1:	55                   	push   %ebp
  8031f2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8031f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8031f7:	6a 00                	push   $0x0
  8031f9:	6a 00                	push   $0x0
  8031fb:	6a 00                	push   $0x0
  8031fd:	6a 00                	push   $0x0
  8031ff:	50                   	push   %eax
  803200:	6a 1b                	push   $0x1b
  803202:	e8 36 fd ff ff       	call   802f3d <syscall>
  803207:	83 c4 18             	add    $0x18,%esp
}
  80320a:	c9                   	leave  
  80320b:	c3                   	ret    

0080320c <sys_getenvid>:

int32 sys_getenvid(void)
{
  80320c:	55                   	push   %ebp
  80320d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  80320f:	6a 00                	push   $0x0
  803211:	6a 00                	push   $0x0
  803213:	6a 00                	push   $0x0
  803215:	6a 00                	push   $0x0
  803217:	6a 00                	push   $0x0
  803219:	6a 05                	push   $0x5
  80321b:	e8 1d fd ff ff       	call   802f3d <syscall>
  803220:	83 c4 18             	add    $0x18,%esp
}
  803223:	c9                   	leave  
  803224:	c3                   	ret    

00803225 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  803225:	55                   	push   %ebp
  803226:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  803228:	6a 00                	push   $0x0
  80322a:	6a 00                	push   $0x0
  80322c:	6a 00                	push   $0x0
  80322e:	6a 00                	push   $0x0
  803230:	6a 00                	push   $0x0
  803232:	6a 06                	push   $0x6
  803234:	e8 04 fd ff ff       	call   802f3d <syscall>
  803239:	83 c4 18             	add    $0x18,%esp
}
  80323c:	c9                   	leave  
  80323d:	c3                   	ret    

0080323e <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  80323e:	55                   	push   %ebp
  80323f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  803241:	6a 00                	push   $0x0
  803243:	6a 00                	push   $0x0
  803245:	6a 00                	push   $0x0
  803247:	6a 00                	push   $0x0
  803249:	6a 00                	push   $0x0
  80324b:	6a 07                	push   $0x7
  80324d:	e8 eb fc ff ff       	call   802f3d <syscall>
  803252:	83 c4 18             	add    $0x18,%esp
}
  803255:	c9                   	leave  
  803256:	c3                   	ret    

00803257 <sys_exit_env>:


void sys_exit_env(void)
{
  803257:	55                   	push   %ebp
  803258:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  80325a:	6a 00                	push   $0x0
  80325c:	6a 00                	push   $0x0
  80325e:	6a 00                	push   $0x0
  803260:	6a 00                	push   $0x0
  803262:	6a 00                	push   $0x0
  803264:	6a 1c                	push   $0x1c
  803266:	e8 d2 fc ff ff       	call   802f3d <syscall>
  80326b:	83 c4 18             	add    $0x18,%esp
}
  80326e:	90                   	nop
  80326f:	c9                   	leave  
  803270:	c3                   	ret    

00803271 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  803271:	55                   	push   %ebp
  803272:	89 e5                	mov    %esp,%ebp
  803274:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  803277:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80327a:	8d 50 04             	lea    0x4(%eax),%edx
  80327d:	8d 45 f8             	lea    -0x8(%ebp),%eax
  803280:	6a 00                	push   $0x0
  803282:	6a 00                	push   $0x0
  803284:	6a 00                	push   $0x0
  803286:	52                   	push   %edx
  803287:	50                   	push   %eax
  803288:	6a 1d                	push   $0x1d
  80328a:	e8 ae fc ff ff       	call   802f3d <syscall>
  80328f:	83 c4 18             	add    $0x18,%esp
	return result;
  803292:	8b 4d 08             	mov    0x8(%ebp),%ecx
  803295:	8b 45 f8             	mov    -0x8(%ebp),%eax
  803298:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80329b:	89 01                	mov    %eax,(%ecx)
  80329d:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8032a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8032a3:	c9                   	leave  
  8032a4:	c2 04 00             	ret    $0x4

008032a7 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8032a7:	55                   	push   %ebp
  8032a8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8032aa:	6a 00                	push   $0x0
  8032ac:	6a 00                	push   $0x0
  8032ae:	ff 75 10             	pushl  0x10(%ebp)
  8032b1:	ff 75 0c             	pushl  0xc(%ebp)
  8032b4:	ff 75 08             	pushl  0x8(%ebp)
  8032b7:	6a 13                	push   $0x13
  8032b9:	e8 7f fc ff ff       	call   802f3d <syscall>
  8032be:	83 c4 18             	add    $0x18,%esp
	return ;
  8032c1:	90                   	nop
}
  8032c2:	c9                   	leave  
  8032c3:	c3                   	ret    

008032c4 <sys_rcr2>:
uint32 sys_rcr2()
{
  8032c4:	55                   	push   %ebp
  8032c5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8032c7:	6a 00                	push   $0x0
  8032c9:	6a 00                	push   $0x0
  8032cb:	6a 00                	push   $0x0
  8032cd:	6a 00                	push   $0x0
  8032cf:	6a 00                	push   $0x0
  8032d1:	6a 1e                	push   $0x1e
  8032d3:	e8 65 fc ff ff       	call   802f3d <syscall>
  8032d8:	83 c4 18             	add    $0x18,%esp
}
  8032db:	c9                   	leave  
  8032dc:	c3                   	ret    

008032dd <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  8032dd:	55                   	push   %ebp
  8032de:	89 e5                	mov    %esp,%ebp
  8032e0:	83 ec 04             	sub    $0x4,%esp
  8032e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8032e6:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8032e9:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8032ed:	6a 00                	push   $0x0
  8032ef:	6a 00                	push   $0x0
  8032f1:	6a 00                	push   $0x0
  8032f3:	6a 00                	push   $0x0
  8032f5:	50                   	push   %eax
  8032f6:	6a 1f                	push   $0x1f
  8032f8:	e8 40 fc ff ff       	call   802f3d <syscall>
  8032fd:	83 c4 18             	add    $0x18,%esp
	return ;
  803300:	90                   	nop
}
  803301:	c9                   	leave  
  803302:	c3                   	ret    

00803303 <rsttst>:
void rsttst()
{
  803303:	55                   	push   %ebp
  803304:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  803306:	6a 00                	push   $0x0
  803308:	6a 00                	push   $0x0
  80330a:	6a 00                	push   $0x0
  80330c:	6a 00                	push   $0x0
  80330e:	6a 00                	push   $0x0
  803310:	6a 21                	push   $0x21
  803312:	e8 26 fc ff ff       	call   802f3d <syscall>
  803317:	83 c4 18             	add    $0x18,%esp
	return ;
  80331a:	90                   	nop
}
  80331b:	c9                   	leave  
  80331c:	c3                   	ret    

0080331d <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  80331d:	55                   	push   %ebp
  80331e:	89 e5                	mov    %esp,%ebp
  803320:	83 ec 04             	sub    $0x4,%esp
  803323:	8b 45 14             	mov    0x14(%ebp),%eax
  803326:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  803329:	8b 55 18             	mov    0x18(%ebp),%edx
  80332c:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  803330:	52                   	push   %edx
  803331:	50                   	push   %eax
  803332:	ff 75 10             	pushl  0x10(%ebp)
  803335:	ff 75 0c             	pushl  0xc(%ebp)
  803338:	ff 75 08             	pushl  0x8(%ebp)
  80333b:	6a 20                	push   $0x20
  80333d:	e8 fb fb ff ff       	call   802f3d <syscall>
  803342:	83 c4 18             	add    $0x18,%esp
	return ;
  803345:	90                   	nop
}
  803346:	c9                   	leave  
  803347:	c3                   	ret    

00803348 <chktst>:
void chktst(uint32 n)
{
  803348:	55                   	push   %ebp
  803349:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  80334b:	6a 00                	push   $0x0
  80334d:	6a 00                	push   $0x0
  80334f:	6a 00                	push   $0x0
  803351:	6a 00                	push   $0x0
  803353:	ff 75 08             	pushl  0x8(%ebp)
  803356:	6a 22                	push   $0x22
  803358:	e8 e0 fb ff ff       	call   802f3d <syscall>
  80335d:	83 c4 18             	add    $0x18,%esp
	return ;
  803360:	90                   	nop
}
  803361:	c9                   	leave  
  803362:	c3                   	ret    

00803363 <inctst>:

void inctst()
{
  803363:	55                   	push   %ebp
  803364:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  803366:	6a 00                	push   $0x0
  803368:	6a 00                	push   $0x0
  80336a:	6a 00                	push   $0x0
  80336c:	6a 00                	push   $0x0
  80336e:	6a 00                	push   $0x0
  803370:	6a 23                	push   $0x23
  803372:	e8 c6 fb ff ff       	call   802f3d <syscall>
  803377:	83 c4 18             	add    $0x18,%esp
	return ;
  80337a:	90                   	nop
}
  80337b:	c9                   	leave  
  80337c:	c3                   	ret    

0080337d <gettst>:
uint32 gettst()
{
  80337d:	55                   	push   %ebp
  80337e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  803380:	6a 00                	push   $0x0
  803382:	6a 00                	push   $0x0
  803384:	6a 00                	push   $0x0
  803386:	6a 00                	push   $0x0
  803388:	6a 00                	push   $0x0
  80338a:	6a 24                	push   $0x24
  80338c:	e8 ac fb ff ff       	call   802f3d <syscall>
  803391:	83 c4 18             	add    $0x18,%esp
}
  803394:	c9                   	leave  
  803395:	c3                   	ret    

00803396 <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  803396:	55                   	push   %ebp
  803397:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  803399:	6a 00                	push   $0x0
  80339b:	6a 00                	push   $0x0
  80339d:	6a 00                	push   $0x0
  80339f:	6a 00                	push   $0x0
  8033a1:	6a 00                	push   $0x0
  8033a3:	6a 25                	push   $0x25
  8033a5:	e8 93 fb ff ff       	call   802f3d <syscall>
  8033aa:	83 c4 18             	add    $0x18,%esp
  8033ad:	a3 60 e0 81 00       	mov    %eax,0x81e060
	return uheapPlaceStrategy ;
  8033b2:	a1 60 e0 81 00       	mov    0x81e060,%eax
}
  8033b7:	c9                   	leave  
  8033b8:	c3                   	ret    

008033b9 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  8033b9:	55                   	push   %ebp
  8033ba:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  8033bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8033bf:	a3 60 e0 81 00       	mov    %eax,0x81e060
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  8033c4:	6a 00                	push   $0x0
  8033c6:	6a 00                	push   $0x0
  8033c8:	6a 00                	push   $0x0
  8033ca:	6a 00                	push   $0x0
  8033cc:	ff 75 08             	pushl  0x8(%ebp)
  8033cf:	6a 26                	push   $0x26
  8033d1:	e8 67 fb ff ff       	call   802f3d <syscall>
  8033d6:	83 c4 18             	add    $0x18,%esp
	return ;
  8033d9:	90                   	nop
}
  8033da:	c9                   	leave  
  8033db:	c3                   	ret    

008033dc <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  8033dc:	55                   	push   %ebp
  8033dd:	89 e5                	mov    %esp,%ebp
  8033df:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  8033e0:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8033e3:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8033e6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8033e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8033ec:	6a 00                	push   $0x0
  8033ee:	53                   	push   %ebx
  8033ef:	51                   	push   %ecx
  8033f0:	52                   	push   %edx
  8033f1:	50                   	push   %eax
  8033f2:	6a 27                	push   $0x27
  8033f4:	e8 44 fb ff ff       	call   802f3d <syscall>
  8033f9:	83 c4 18             	add    $0x18,%esp
}
  8033fc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8033ff:	c9                   	leave  
  803400:	c3                   	ret    

00803401 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  803401:	55                   	push   %ebp
  803402:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  803404:	8b 55 0c             	mov    0xc(%ebp),%edx
  803407:	8b 45 08             	mov    0x8(%ebp),%eax
  80340a:	6a 00                	push   $0x0
  80340c:	6a 00                	push   $0x0
  80340e:	6a 00                	push   $0x0
  803410:	52                   	push   %edx
  803411:	50                   	push   %eax
  803412:	6a 28                	push   $0x28
  803414:	e8 24 fb ff ff       	call   802f3d <syscall>
  803419:	83 c4 18             	add    $0x18,%esp
}
  80341c:	c9                   	leave  
  80341d:	c3                   	ret    

0080341e <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  80341e:	55                   	push   %ebp
  80341f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  803421:	8b 4d 14             	mov    0x14(%ebp),%ecx
  803424:	8b 55 0c             	mov    0xc(%ebp),%edx
  803427:	8b 45 08             	mov    0x8(%ebp),%eax
  80342a:	6a 00                	push   $0x0
  80342c:	51                   	push   %ecx
  80342d:	ff 75 10             	pushl  0x10(%ebp)
  803430:	52                   	push   %edx
  803431:	50                   	push   %eax
  803432:	6a 29                	push   $0x29
  803434:	e8 04 fb ff ff       	call   802f3d <syscall>
  803439:	83 c4 18             	add    $0x18,%esp
}
  80343c:	c9                   	leave  
  80343d:	c3                   	ret    

0080343e <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  80343e:	55                   	push   %ebp
  80343f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  803441:	6a 00                	push   $0x0
  803443:	6a 00                	push   $0x0
  803445:	ff 75 10             	pushl  0x10(%ebp)
  803448:	ff 75 0c             	pushl  0xc(%ebp)
  80344b:	ff 75 08             	pushl  0x8(%ebp)
  80344e:	6a 12                	push   $0x12
  803450:	e8 e8 fa ff ff       	call   802f3d <syscall>
  803455:	83 c4 18             	add    $0x18,%esp
	return ;
  803458:	90                   	nop
}
  803459:	c9                   	leave  
  80345a:	c3                   	ret    

0080345b <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  80345b:	55                   	push   %ebp
  80345c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  80345e:	8b 55 0c             	mov    0xc(%ebp),%edx
  803461:	8b 45 08             	mov    0x8(%ebp),%eax
  803464:	6a 00                	push   $0x0
  803466:	6a 00                	push   $0x0
  803468:	6a 00                	push   $0x0
  80346a:	52                   	push   %edx
  80346b:	50                   	push   %eax
  80346c:	6a 2a                	push   $0x2a
  80346e:	e8 ca fa ff ff       	call   802f3d <syscall>
  803473:	83 c4 18             	add    $0x18,%esp
	return;
  803476:	90                   	nop
}
  803477:	c9                   	leave  
  803478:	c3                   	ret    

00803479 <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  803479:	55                   	push   %ebp
  80347a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  80347c:	6a 00                	push   $0x0
  80347e:	6a 00                	push   $0x0
  803480:	6a 00                	push   $0x0
  803482:	6a 00                	push   $0x0
  803484:	6a 00                	push   $0x0
  803486:	6a 2b                	push   $0x2b
  803488:	e8 b0 fa ff ff       	call   802f3d <syscall>
  80348d:	83 c4 18             	add    $0x18,%esp
}
  803490:	c9                   	leave  
  803491:	c3                   	ret    

00803492 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  803492:	55                   	push   %ebp
  803493:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  803495:	6a 00                	push   $0x0
  803497:	6a 00                	push   $0x0
  803499:	6a 00                	push   $0x0
  80349b:	ff 75 0c             	pushl  0xc(%ebp)
  80349e:	ff 75 08             	pushl  0x8(%ebp)
  8034a1:	6a 2d                	push   $0x2d
  8034a3:	e8 95 fa ff ff       	call   802f3d <syscall>
  8034a8:	83 c4 18             	add    $0x18,%esp
	return;
  8034ab:	90                   	nop
}
  8034ac:	c9                   	leave  
  8034ad:	c3                   	ret    

008034ae <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8034ae:	55                   	push   %ebp
  8034af:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  8034b1:	6a 00                	push   $0x0
  8034b3:	6a 00                	push   $0x0
  8034b5:	6a 00                	push   $0x0
  8034b7:	ff 75 0c             	pushl  0xc(%ebp)
  8034ba:	ff 75 08             	pushl  0x8(%ebp)
  8034bd:	6a 2c                	push   $0x2c
  8034bf:	e8 79 fa ff ff       	call   802f3d <syscall>
  8034c4:	83 c4 18             	add    $0x18,%esp
	return ;
  8034c7:	90                   	nop
}
  8034c8:	c9                   	leave  
  8034c9:	c3                   	ret    

008034ca <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  8034ca:	55                   	push   %ebp
  8034cb:	89 e5                	mov    %esp,%ebp
	//TODO: [PROJECT'25.IM#4] CPU SCHEDULING - #1 System Calls - Add suitable code here
	//Your code is here
	//Comment the following line
	//panic("sys_env_set_priority() is not implemented yet...!!");
	syscall(SYS_env_set_priority, envID, priority, 0, 0, 0);
  8034cd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8034d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8034d3:	6a 00                	push   $0x0
  8034d5:	6a 00                	push   $0x0
  8034d7:	6a 00                	push   $0x0
  8034d9:	52                   	push   %edx
  8034da:	50                   	push   %eax
  8034db:	6a 2e                	push   $0x2e
  8034dd:	e8 5b fa ff ff       	call   802f3d <syscall>
  8034e2:	83 c4 18             	add    $0x18,%esp
	    return;
  8034e5:	90                   	nop
}
  8034e6:	c9                   	leave  
  8034e7:	c3                   	ret    

008034e8 <to_page_va>:
//==================================================================================//
//==================================
// [1] GET PAGE VA:
//==================================
__inline__ uint32 to_page_va(struct PageInfoElement *ptrPageInfo)
{
  8034e8:	55                   	push   %ebp
  8034e9:	89 e5                	mov    %esp,%ebp
  8034eb:	83 ec 10             	sub    $0x10,%esp
	//Get start VA of the page from the corresponding Page Info pointer
	int idxInPageInfoArr = (ptrPageInfo - pageBlockInfoArr);
  8034ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8034f1:	ba 60 60 80 00       	mov    $0x806060,%edx
  8034f6:	29 d0                	sub    %edx,%eax
  8034f8:	c1 f8 02             	sar    $0x2,%eax
  8034fb:	89 c2                	mov    %eax,%edx
  8034fd:	89 d0                	mov    %edx,%eax
  8034ff:	c1 e0 02             	shl    $0x2,%eax
  803502:	01 d0                	add    %edx,%eax
  803504:	c1 e0 02             	shl    $0x2,%eax
  803507:	01 d0                	add    %edx,%eax
  803509:	c1 e0 02             	shl    $0x2,%eax
  80350c:	01 d0                	add    %edx,%eax
  80350e:	89 c1                	mov    %eax,%ecx
  803510:	c1 e1 08             	shl    $0x8,%ecx
  803513:	01 c8                	add    %ecx,%eax
  803515:	89 c1                	mov    %eax,%ecx
  803517:	c1 e1 10             	shl    $0x10,%ecx
  80351a:	01 c8                	add    %ecx,%eax
  80351c:	01 c0                	add    %eax,%eax
  80351e:	01 d0                	add    %edx,%eax
  803520:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return dynAllocStart + (idxInPageInfoArr << PGSHIFT);
  803523:	8b 45 fc             	mov    -0x4(%ebp),%eax
  803526:	c1 e0 0c             	shl    $0xc,%eax
  803529:	89 c2                	mov    %eax,%edx
  80352b:	a1 64 e0 81 00       	mov    0x81e064,%eax
  803530:	01 d0                	add    %edx,%eax
}
  803532:	c9                   	leave  
  803533:	c3                   	ret    

00803534 <log2>:

//==================================================================================//
//============================ REQUIRED FUNCTIONS ==================================//
//==================================================================================//
__inline__ int log2(uint32 n)
	{
  803534:	55                   	push   %ebp
  803535:	89 e5                	mov    %esp,%ebp
  803537:	83 ec 10             	sub    $0x10,%esp
		int result = 0;
  80353a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
		while( n > 1){
  803541:	eb 06                	jmp    803549 <log2+0x15>
			n >>=1;
  803543:	d1 6d 08             	shrl   0x8(%ebp)
			result++;
  803546:	ff 45 fc             	incl   -0x4(%ebp)
//============================ REQUIRED FUNCTIONS ==================================//
//==================================================================================//
__inline__ int log2(uint32 n)
	{
		int result = 0;
		while( n > 1){
  803549:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
  80354d:	77 f4                	ja     803543 <log2+0xf>
			n >>=1;
			result++;
		}
		return result;
  80354f:	8b 45 fc             	mov    -0x4(%ebp),%eax
	}
  803552:	c9                   	leave  
  803553:	c3                   	ret    

00803554 <initialize_dynamic_allocator>:
//==================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================
bool is_initialized = 0;
void initialize_dynamic_allocator(uint32 daStart, uint32 daEnd)
{
  803554:	55                   	push   %ebp
  803555:	89 e5                	mov    %esp,%ebp
  803557:	83 ec 18             	sub    $0x18,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(daEnd <= daStart + DYN_ALLOC_MAX_SIZE);
  80355a:	8b 45 08             	mov    0x8(%ebp),%eax
  80355d:	05 00 00 00 02       	add    $0x2000000,%eax
  803562:	3b 45 0c             	cmp    0xc(%ebp),%eax
  803565:	73 16                	jae    80357d <initialize_dynamic_allocator+0x29>
  803567:	68 18 4d 80 00       	push   $0x804d18
  80356c:	68 3e 4d 80 00       	push   $0x804d3e
  803571:	6a 2d                	push   $0x2d
  803573:	68 53 4d 80 00       	push   $0x804d53
  803578:	e8 da 0a 00 00       	call   804057 <_panic>
		is_initialized = 1;
  80357d:	c7 05 24 60 80 00 01 	movl   $0x1,0x806024
  803584:	00 00 00 
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #1 initialize_dynamic_allocator
	//Your code is here


	dynAllocStart = daStart;
  803587:	8b 45 08             	mov    0x8(%ebp),%eax
  80358a:	a3 64 e0 81 00       	mov    %eax,0x81e064
	dynAllocEnd= daEnd;
  80358f:	8b 45 0c             	mov    0xc(%ebp),%eax
  803592:	a3 40 60 80 00       	mov    %eax,0x806040
	int numOfPages = (dynAllocEnd - dynAllocStart)/PAGE_SIZE;
  803597:	8b 15 40 60 80 00    	mov    0x806040,%edx
  80359d:	a1 64 e0 81 00       	mov    0x81e064,%eax
  8035a2:	29 c2                	sub    %eax,%edx
  8035a4:	89 d0                	mov    %edx,%eax
  8035a6:	c1 e8 0c             	shr    $0xc,%eax
  8035a9:	89 45 e8             	mov    %eax,-0x18(%ebp)


	for(int i=0; i< numOfPages; i++){
  8035ac:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8035b3:	eb 2f                	jmp    8035e4 <initialize_dynamic_allocator+0x90>
	    pageBlockInfoArr[i].block_size=0;
  8035b5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8035b8:	89 d0                	mov    %edx,%eax
  8035ba:	01 c0                	add    %eax,%eax
  8035bc:	01 d0                	add    %edx,%eax
  8035be:	c1 e0 02             	shl    $0x2,%eax
  8035c1:	05 68 60 80 00       	add    $0x806068,%eax
  8035c6:	66 c7 00 00 00       	movw   $0x0,(%eax)
	    pageBlockInfoArr[i].num_of_free_blocks=0;
  8035cb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8035ce:	89 d0                	mov    %edx,%eax
  8035d0:	01 c0                	add    %eax,%eax
  8035d2:	01 d0                	add    %edx,%eax
  8035d4:	c1 e0 02             	shl    $0x2,%eax
  8035d7:	05 6a 60 80 00       	add    $0x80606a,%eax
  8035dc:	66 c7 00 00 00       	movw   $0x0,(%eax)
	dynAllocStart = daStart;
	dynAllocEnd= daEnd;
	int numOfPages = (dynAllocEnd - dynAllocStart)/PAGE_SIZE;


	for(int i=0; i< numOfPages; i++){
  8035e1:	ff 45 f4             	incl   -0xc(%ebp)
  8035e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035e7:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8035ea:	7c c9                	jl     8035b5 <initialize_dynamic_allocator+0x61>
	    pageBlockInfoArr[i].block_size=0;
	    pageBlockInfoArr[i].num_of_free_blocks=0;
	}


	LIST_INIT(&freePagesList);
  8035ec:	c7 05 48 60 80 00 00 	movl   $0x0,0x806048
  8035f3:	00 00 00 
  8035f6:	c7 05 4c 60 80 00 00 	movl   $0x0,0x80604c
  8035fd:	00 00 00 
  803600:	c7 05 54 60 80 00 00 	movl   $0x0,0x806054
  803607:	00 00 00 
	for(int i=0; i<numOfPages; i++){
  80360a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  803611:	e9 9c 00 00 00       	jmp    8036b2 <initialize_dynamic_allocator+0x15e>
		LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
  803616:	8b 15 4c 60 80 00    	mov    0x80604c,%edx
  80361c:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80361f:	89 c8                	mov    %ecx,%eax
  803621:	01 c0                	add    %eax,%eax
  803623:	01 c8                	add    %ecx,%eax
  803625:	c1 e0 02             	shl    $0x2,%eax
  803628:	05 64 60 80 00       	add    $0x806064,%eax
  80362d:	89 10                	mov    %edx,(%eax)
  80362f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803632:	89 d0                	mov    %edx,%eax
  803634:	01 c0                	add    %eax,%eax
  803636:	01 d0                	add    %edx,%eax
  803638:	c1 e0 02             	shl    $0x2,%eax
  80363b:	05 64 60 80 00       	add    $0x806064,%eax
  803640:	8b 00                	mov    (%eax),%eax
  803642:	85 c0                	test   %eax,%eax
  803644:	74 1b                	je     803661 <initialize_dynamic_allocator+0x10d>
  803646:	8b 15 4c 60 80 00    	mov    0x80604c,%edx
  80364c:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80364f:	89 c8                	mov    %ecx,%eax
  803651:	01 c0                	add    %eax,%eax
  803653:	01 c8                	add    %ecx,%eax
  803655:	c1 e0 02             	shl    $0x2,%eax
  803658:	05 60 60 80 00       	add    $0x806060,%eax
  80365d:	89 02                	mov    %eax,(%edx)
  80365f:	eb 16                	jmp    803677 <initialize_dynamic_allocator+0x123>
  803661:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803664:	89 d0                	mov    %edx,%eax
  803666:	01 c0                	add    %eax,%eax
  803668:	01 d0                	add    %edx,%eax
  80366a:	c1 e0 02             	shl    $0x2,%eax
  80366d:	05 60 60 80 00       	add    $0x806060,%eax
  803672:	a3 48 60 80 00       	mov    %eax,0x806048
  803677:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80367a:	89 d0                	mov    %edx,%eax
  80367c:	01 c0                	add    %eax,%eax
  80367e:	01 d0                	add    %edx,%eax
  803680:	c1 e0 02             	shl    $0x2,%eax
  803683:	05 60 60 80 00       	add    $0x806060,%eax
  803688:	a3 4c 60 80 00       	mov    %eax,0x80604c
  80368d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803690:	89 d0                	mov    %edx,%eax
  803692:	01 c0                	add    %eax,%eax
  803694:	01 d0                	add    %edx,%eax
  803696:	c1 e0 02             	shl    $0x2,%eax
  803699:	05 60 60 80 00       	add    $0x806060,%eax
  80369e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8036a4:	a1 54 60 80 00       	mov    0x806054,%eax
  8036a9:	40                   	inc    %eax
  8036aa:	a3 54 60 80 00       	mov    %eax,0x806054
	    pageBlockInfoArr[i].num_of_free_blocks=0;
	}


	LIST_INIT(&freePagesList);
	for(int i=0; i<numOfPages; i++){
  8036af:	ff 45 f0             	incl   -0x10(%ebp)
  8036b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8036b5:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8036b8:	0f 8c 58 ff ff ff    	jl     803616 <initialize_dynamic_allocator+0xc2>
		LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
	}



	for (int i = 0; i < LOG2_MAX_SIZE - LOG2_MIN_SIZE + 1; i++) {
  8036be:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  8036c5:	eb 36                	jmp    8036fd <initialize_dynamic_allocator+0x1a9>
	    LIST_INIT(&freeBlockLists[i]);
  8036c7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8036ca:	c1 e0 04             	shl    $0x4,%eax
  8036cd:	05 80 e0 81 00       	add    $0x81e080,%eax
  8036d2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8036d8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8036db:	c1 e0 04             	shl    $0x4,%eax
  8036de:	05 84 e0 81 00       	add    $0x81e084,%eax
  8036e3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8036e9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8036ec:	c1 e0 04             	shl    $0x4,%eax
  8036ef:	05 8c e0 81 00       	add    $0x81e08c,%eax
  8036f4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
	}



	for (int i = 0; i < LOG2_MAX_SIZE - LOG2_MIN_SIZE + 1; i++) {
  8036fa:	ff 45 ec             	incl   -0x14(%ebp)
  8036fd:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  803701:	7e c4                	jle    8036c7 <initialize_dynamic_allocator+0x173>


	//Comment the following line
	//panic("initialize_dynamic_allocator() Not implemented yet");

}
  803703:	90                   	nop
  803704:	c9                   	leave  
  803705:	c3                   	ret    

00803706 <get_block_size>:
// [2] GET BLOCK SIZE:
//===========================


__inline__ uint32 get_block_size(void *va)
{
  803706:	55                   	push   %ebp
  803707:	89 e5                	mov    %esp,%ebp
  803709:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #2 get_block_size
	//Your code is here

	uint32 page_index = ((uint32)va - dynAllocStart)/ PAGE_SIZE;
  80370c:	8b 55 08             	mov    0x8(%ebp),%edx
  80370f:	a1 64 e0 81 00       	mov    0x81e064,%eax
  803714:	29 c2                	sub    %eax,%edx
  803716:	89 d0                	mov    %edx,%eax
  803718:	c1 e8 0c             	shr    $0xc,%eax
  80371b:	89 45 fc             	mov    %eax,-0x4(%ebp)
    return pageBlockInfoArr[page_index].block_size;
  80371e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  803721:	89 d0                	mov    %edx,%eax
  803723:	01 c0                	add    %eax,%eax
  803725:	01 d0                	add    %edx,%eax
  803727:	c1 e0 02             	shl    $0x2,%eax
  80372a:	05 68 60 80 00       	add    $0x806068,%eax
  80372f:	8b 00                	mov    (%eax),%eax
  803731:	0f b7 c0             	movzwl %ax,%eax
	//Comment the following line
	//panic("get_block_size() Not implemented yet");
}
  803734:	c9                   	leave  
  803735:	c3                   	ret    

00803736 <alloc_block>:

//===========================
// 3) ALLOCATE BLOCK:
//===========================
void *alloc_block(uint32 size)
{
  803736:	55                   	push   %ebp
  803737:	89 e5                	mov    %esp,%ebp
  803739:	83 ec 48             	sub    $0x48,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(size <= DYN_ALLOC_MAX_BLOCK_SIZE);
  80373c:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  803743:	76 16                	jbe    80375b <alloc_block+0x25>
  803745:	68 6c 4d 80 00       	push   $0x804d6c
  80374a:	68 3e 4d 80 00       	push   $0x804d3e
  80374f:	6a 6c                	push   $0x6c
  803751:	68 53 4d 80 00       	push   $0x804d53
  803756:	e8 fc 08 00 00       	call   804057 <_panic>
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #3 alloc_block
	//Your code is here


	if(size == 0){
  80375b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80375f:	75 0a                	jne    80376b <alloc_block+0x35>
		return NULL;
  803761:	b8 00 00 00 00       	mov    $0x0,%eax
  803766:	e9 65 04 00 00       	jmp    803bd0 <alloc_block+0x49a>
	}
	else if(size<=8){
  80376b:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  80376f:	77 09                	ja     80377a <alloc_block+0x44>
		size=8;
  803771:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
  803778:	eb 1f                	jmp    803799 <alloc_block+0x63>
	}
	else{
		uint32 reqsize=8;
  80377a:	c7 45 f4 08 00 00 00 	movl   $0x8,-0xc(%ebp)
		while(reqsize < size){
  803781:	eb 08                	jmp    80378b <alloc_block+0x55>
			reqsize*=2;
  803783:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803786:	01 c0                	add    %eax,%eax
  803788:	89 45 f4             	mov    %eax,-0xc(%ebp)
	else if(size<=8){
		size=8;
	}
	else{
		uint32 reqsize=8;
		while(reqsize < size){
  80378b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80378e:	3b 45 08             	cmp    0x8(%ebp),%eax
  803791:	72 f0                	jb     803783 <alloc_block+0x4d>
			reqsize*=2;
		}
		size= reqsize;
  803793:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803796:	89 45 08             	mov    %eax,0x8(%ebp)
	}

	int list_index = log2(size)- LOG2_MIN_SIZE;
  803799:	83 ec 0c             	sub    $0xc,%esp
  80379c:	ff 75 08             	pushl  0x8(%ebp)
  80379f:	e8 90 fd ff ff       	call   803534 <log2>
  8037a4:	83 c4 10             	add    $0x10,%esp
  8037a7:	83 e8 03             	sub    $0x3,%eax
  8037aa:	89 45 e8             	mov    %eax,-0x18(%ebp)

	if(!LIST_EMPTY(&freeBlockLists[list_index])){
  8037ad:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8037b0:	c1 e0 04             	shl    $0x4,%eax
  8037b3:	05 80 e0 81 00       	add    $0x81e080,%eax
  8037b8:	8b 00                	mov    (%eax),%eax
  8037ba:	85 c0                	test   %eax,%eax
  8037bc:	0f 84 fb 00 00 00    	je     8038bd <alloc_block+0x187>
		struct BlockElement *block = LIST_FIRST(&freeBlockLists[list_index]);
  8037c2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8037c5:	c1 e0 04             	shl    $0x4,%eax
  8037c8:	05 80 e0 81 00       	add    $0x81e080,%eax
  8037cd:	8b 00                	mov    (%eax),%eax
  8037cf:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		LIST_REMOVE(&freeBlockLists[list_index], block);
  8037d2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8037d6:	75 17                	jne    8037ef <alloc_block+0xb9>
  8037d8:	83 ec 04             	sub    $0x4,%esp
  8037db:	68 8d 4d 80 00       	push   $0x804d8d
  8037e0:	68 86 00 00 00       	push   $0x86
  8037e5:	68 53 4d 80 00       	push   $0x804d53
  8037ea:	e8 68 08 00 00       	call   804057 <_panic>
  8037ef:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037f2:	8b 00                	mov    (%eax),%eax
  8037f4:	85 c0                	test   %eax,%eax
  8037f6:	74 10                	je     803808 <alloc_block+0xd2>
  8037f8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037fb:	8b 00                	mov    (%eax),%eax
  8037fd:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803800:	8b 52 04             	mov    0x4(%edx),%edx
  803803:	89 50 04             	mov    %edx,0x4(%eax)
  803806:	eb 14                	jmp    80381c <alloc_block+0xe6>
  803808:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80380b:	8b 40 04             	mov    0x4(%eax),%eax
  80380e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803811:	c1 e2 04             	shl    $0x4,%edx
  803814:	81 c2 84 e0 81 00    	add    $0x81e084,%edx
  80381a:	89 02                	mov    %eax,(%edx)
  80381c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80381f:	8b 40 04             	mov    0x4(%eax),%eax
  803822:	85 c0                	test   %eax,%eax
  803824:	74 0f                	je     803835 <alloc_block+0xff>
  803826:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803829:	8b 40 04             	mov    0x4(%eax),%eax
  80382c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80382f:	8b 12                	mov    (%edx),%edx
  803831:	89 10                	mov    %edx,(%eax)
  803833:	eb 13                	jmp    803848 <alloc_block+0x112>
  803835:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803838:	8b 00                	mov    (%eax),%eax
  80383a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80383d:	c1 e2 04             	shl    $0x4,%edx
  803840:	81 c2 80 e0 81 00    	add    $0x81e080,%edx
  803846:	89 02                	mov    %eax,(%edx)
  803848:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80384b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803851:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803854:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80385b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80385e:	c1 e0 04             	shl    $0x4,%eax
  803861:	05 8c e0 81 00       	add    $0x81e08c,%eax
  803866:	8b 00                	mov    (%eax),%eax
  803868:	8d 50 ff             	lea    -0x1(%eax),%edx
  80386b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80386e:	c1 e0 04             	shl    $0x4,%eax
  803871:	05 8c e0 81 00       	add    $0x81e08c,%eax
  803876:	89 10                	mov    %edx,(%eax)
		uint32 page_index = ((uint32)block - dynAllocStart)/ PAGE_SIZE;
  803878:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80387b:	a1 64 e0 81 00       	mov    0x81e064,%eax
  803880:	29 c2                	sub    %eax,%edx
  803882:	89 d0                	mov    %edx,%eax
  803884:	c1 e8 0c             	shr    $0xc,%eax
  803887:	89 45 e0             	mov    %eax,-0x20(%ebp)
		pageBlockInfoArr[page_index].num_of_free_blocks--;
  80388a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80388d:	89 d0                	mov    %edx,%eax
  80388f:	01 c0                	add    %eax,%eax
  803891:	01 d0                	add    %edx,%eax
  803893:	c1 e0 02             	shl    $0x2,%eax
  803896:	05 6a 60 80 00       	add    $0x80606a,%eax
  80389b:	66 8b 00             	mov    (%eax),%ax
  80389e:	8d 50 ff             	lea    -0x1(%eax),%edx
  8038a1:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8038a4:	89 c8                	mov    %ecx,%eax
  8038a6:	01 c0                	add    %eax,%eax
  8038a8:	01 c8                	add    %ecx,%eax
  8038aa:	c1 e0 02             	shl    $0x2,%eax
  8038ad:	05 6a 60 80 00       	add    $0x80606a,%eax
  8038b2:	66 89 10             	mov    %dx,(%eax)
		return (void*)block;
  8038b5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038b8:	e9 13 03 00 00       	jmp    803bd0 <alloc_block+0x49a>
	}

	if(!LIST_EMPTY(&freePagesList)){
  8038bd:	a1 48 60 80 00       	mov    0x806048,%eax
  8038c2:	85 c0                	test   %eax,%eax
  8038c4:	0f 84 c9 01 00 00    	je     803a93 <alloc_block+0x35d>

		struct PageInfoElement *page_info = LIST_FIRST(&freePagesList);
  8038ca:	a1 48 60 80 00       	mov    0x806048,%eax
  8038cf:	89 45 dc             	mov    %eax,-0x24(%ebp)
		LIST_REMOVE(&freePagesList, page_info);
  8038d2:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8038d6:	75 17                	jne    8038ef <alloc_block+0x1b9>
  8038d8:	83 ec 04             	sub    $0x4,%esp
  8038db:	68 8d 4d 80 00       	push   $0x804d8d
  8038e0:	68 8f 00 00 00       	push   $0x8f
  8038e5:	68 53 4d 80 00       	push   $0x804d53
  8038ea:	e8 68 07 00 00       	call   804057 <_panic>
  8038ef:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8038f2:	8b 00                	mov    (%eax),%eax
  8038f4:	85 c0                	test   %eax,%eax
  8038f6:	74 10                	je     803908 <alloc_block+0x1d2>
  8038f8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8038fb:	8b 00                	mov    (%eax),%eax
  8038fd:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803900:	8b 52 04             	mov    0x4(%edx),%edx
  803903:	89 50 04             	mov    %edx,0x4(%eax)
  803906:	eb 0b                	jmp    803913 <alloc_block+0x1dd>
  803908:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80390b:	8b 40 04             	mov    0x4(%eax),%eax
  80390e:	a3 4c 60 80 00       	mov    %eax,0x80604c
  803913:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803916:	8b 40 04             	mov    0x4(%eax),%eax
  803919:	85 c0                	test   %eax,%eax
  80391b:	74 0f                	je     80392c <alloc_block+0x1f6>
  80391d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803920:	8b 40 04             	mov    0x4(%eax),%eax
  803923:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803926:	8b 12                	mov    (%edx),%edx
  803928:	89 10                	mov    %edx,(%eax)
  80392a:	eb 0a                	jmp    803936 <alloc_block+0x200>
  80392c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80392f:	8b 00                	mov    (%eax),%eax
  803931:	a3 48 60 80 00       	mov    %eax,0x806048
  803936:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803939:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80393f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803942:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803949:	a1 54 60 80 00       	mov    0x806054,%eax
  80394e:	48                   	dec    %eax
  80394f:	a3 54 60 80 00       	mov    %eax,0x806054
		uint32 page_va = to_page_va(page_info);
  803954:	83 ec 0c             	sub    $0xc,%esp
  803957:	ff 75 dc             	pushl  -0x24(%ebp)
  80395a:	e8 89 fb ff ff       	call   8034e8 <to_page_va>
  80395f:	83 c4 10             	add    $0x10,%esp
  803962:	89 45 d8             	mov    %eax,-0x28(%ebp)

		uint32 page_index = (page_va - dynAllocStart)/ PAGE_SIZE;
  803965:	a1 64 e0 81 00       	mov    0x81e064,%eax
  80396a:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80396d:	29 c2                	sub    %eax,%edx
  80396f:	89 d0                	mov    %edx,%eax
  803971:	c1 e8 0c             	shr    $0xc,%eax
  803974:	89 45 d4             	mov    %eax,-0x2c(%ebp)

		get_page((void*)page_va);
  803977:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80397a:	83 ec 0c             	sub    $0xc,%esp
  80397d:	50                   	push   %eax
  80397e:	e8 fe dc ff ff       	call   801681 <get_page>
  803983:	83 c4 10             	add    $0x10,%esp


		pageBlockInfoArr[page_index].block_size = size;
  803986:	8b 45 08             	mov    0x8(%ebp),%eax
  803989:	89 c2                	mov    %eax,%edx
  80398b:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  80398e:	89 c8                	mov    %ecx,%eax
  803990:	01 c0                	add    %eax,%eax
  803992:	01 c8                	add    %ecx,%eax
  803994:	c1 e0 02             	shl    $0x2,%eax
  803997:	05 68 60 80 00       	add    $0x806068,%eax
  80399c:	66 89 10             	mov    %dx,(%eax)
		int num_blocks = PAGE_SIZE / size ;
  80399f:	b8 00 10 00 00       	mov    $0x1000,%eax
  8039a4:	ba 00 00 00 00       	mov    $0x0,%edx
  8039a9:	f7 75 08             	divl   0x8(%ebp)
  8039ac:	89 45 d0             	mov    %eax,-0x30(%ebp)
		pageBlockInfoArr[page_index].num_of_free_blocks= num_blocks - 1 ;
  8039af:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8039b2:	8d 50 ff             	lea    -0x1(%eax),%edx
  8039b5:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  8039b8:	89 c8                	mov    %ecx,%eax
  8039ba:	01 c0                	add    %eax,%eax
  8039bc:	01 c8                	add    %ecx,%eax
  8039be:	c1 e0 02             	shl    $0x2,%eax
  8039c1:	05 6a 60 80 00       	add    $0x80606a,%eax
  8039c6:	66 89 10             	mov    %dx,(%eax)

		for(int i=1; i< num_blocks; i++){
  8039c9:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
  8039d0:	e9 aa 00 00 00       	jmp    803a7f <alloc_block+0x349>
			struct BlockElement *new_block = (struct BlockElement*)(page_va + i *size);
  8039d5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8039d8:	0f af 45 08          	imul   0x8(%ebp),%eax
  8039dc:	89 c2                	mov    %eax,%edx
  8039de:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8039e1:	01 d0                	add    %edx,%eax
  8039e3:	89 45 cc             	mov    %eax,-0x34(%ebp)
			LIST_INSERT_TAIL(&freeBlockLists[list_index], new_block);
  8039e6:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  8039ea:	75 17                	jne    803a03 <alloc_block+0x2cd>
  8039ec:	83 ec 04             	sub    $0x4,%esp
  8039ef:	68 ac 4d 80 00       	push   $0x804dac
  8039f4:	68 9d 00 00 00       	push   $0x9d
  8039f9:	68 53 4d 80 00       	push   $0x804d53
  8039fe:	e8 54 06 00 00       	call   804057 <_panic>
  803a03:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a06:	c1 e0 04             	shl    $0x4,%eax
  803a09:	05 84 e0 81 00       	add    $0x81e084,%eax
  803a0e:	8b 10                	mov    (%eax),%edx
  803a10:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803a13:	89 50 04             	mov    %edx,0x4(%eax)
  803a16:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803a19:	8b 40 04             	mov    0x4(%eax),%eax
  803a1c:	85 c0                	test   %eax,%eax
  803a1e:	74 14                	je     803a34 <alloc_block+0x2fe>
  803a20:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a23:	c1 e0 04             	shl    $0x4,%eax
  803a26:	05 84 e0 81 00       	add    $0x81e084,%eax
  803a2b:	8b 00                	mov    (%eax),%eax
  803a2d:	8b 55 cc             	mov    -0x34(%ebp),%edx
  803a30:	89 10                	mov    %edx,(%eax)
  803a32:	eb 11                	jmp    803a45 <alloc_block+0x30f>
  803a34:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a37:	c1 e0 04             	shl    $0x4,%eax
  803a3a:	8d 90 80 e0 81 00    	lea    0x81e080(%eax),%edx
  803a40:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803a43:	89 02                	mov    %eax,(%edx)
  803a45:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a48:	c1 e0 04             	shl    $0x4,%eax
  803a4b:	8d 90 84 e0 81 00    	lea    0x81e084(%eax),%edx
  803a51:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803a54:	89 02                	mov    %eax,(%edx)
  803a56:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803a59:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803a5f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a62:	c1 e0 04             	shl    $0x4,%eax
  803a65:	05 8c e0 81 00       	add    $0x81e08c,%eax
  803a6a:	8b 00                	mov    (%eax),%eax
  803a6c:	8d 50 01             	lea    0x1(%eax),%edx
  803a6f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a72:	c1 e0 04             	shl    $0x4,%eax
  803a75:	05 8c e0 81 00       	add    $0x81e08c,%eax
  803a7a:	89 10                	mov    %edx,(%eax)

		pageBlockInfoArr[page_index].block_size = size;
		int num_blocks = PAGE_SIZE / size ;
		pageBlockInfoArr[page_index].num_of_free_blocks= num_blocks - 1 ;

		for(int i=1; i< num_blocks; i++){
  803a7c:	ff 45 f0             	incl   -0x10(%ebp)
  803a7f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803a82:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  803a85:	0f 8c 4a ff ff ff    	jl     8039d5 <alloc_block+0x29f>
			struct BlockElement *new_block = (struct BlockElement*)(page_va + i *size);
			LIST_INSERT_TAIL(&freeBlockLists[list_index], new_block);
		}
		return(void*)page_va;
  803a8b:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803a8e:	e9 3d 01 00 00       	jmp    803bd0 <alloc_block+0x49a>
	}


	for(int i =list_index+1; i<= LOG2_MAX_SIZE - LOG2_MIN_SIZE; i++){
  803a93:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a96:	40                   	inc    %eax
  803a97:	89 45 ec             	mov    %eax,-0x14(%ebp)
  803a9a:	e9 10 01 00 00       	jmp    803baf <alloc_block+0x479>

		if(!LIST_EMPTY(&freeBlockLists[i])){
  803a9f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803aa2:	c1 e0 04             	shl    $0x4,%eax
  803aa5:	05 80 e0 81 00       	add    $0x81e080,%eax
  803aaa:	8b 00                	mov    (%eax),%eax
  803aac:	85 c0                	test   %eax,%eax
  803aae:	0f 84 f8 00 00 00    	je     803bac <alloc_block+0x476>

			struct BlockElement *block = LIST_FIRST(&freeBlockLists[i]);
  803ab4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803ab7:	c1 e0 04             	shl    $0x4,%eax
  803aba:	05 80 e0 81 00       	add    $0x81e080,%eax
  803abf:	8b 00                	mov    (%eax),%eax
  803ac1:	89 45 c8             	mov    %eax,-0x38(%ebp)
			LIST_REMOVE( &freeBlockLists[i], block);
  803ac4:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  803ac8:	75 17                	jne    803ae1 <alloc_block+0x3ab>
  803aca:	83 ec 04             	sub    $0x4,%esp
  803acd:	68 8d 4d 80 00       	push   $0x804d8d
  803ad2:	68 a8 00 00 00       	push   $0xa8
  803ad7:	68 53 4d 80 00       	push   $0x804d53
  803adc:	e8 76 05 00 00       	call   804057 <_panic>
  803ae1:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803ae4:	8b 00                	mov    (%eax),%eax
  803ae6:	85 c0                	test   %eax,%eax
  803ae8:	74 10                	je     803afa <alloc_block+0x3c4>
  803aea:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803aed:	8b 00                	mov    (%eax),%eax
  803aef:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803af2:	8b 52 04             	mov    0x4(%edx),%edx
  803af5:	89 50 04             	mov    %edx,0x4(%eax)
  803af8:	eb 14                	jmp    803b0e <alloc_block+0x3d8>
  803afa:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803afd:	8b 40 04             	mov    0x4(%eax),%eax
  803b00:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803b03:	c1 e2 04             	shl    $0x4,%edx
  803b06:	81 c2 84 e0 81 00    	add    $0x81e084,%edx
  803b0c:	89 02                	mov    %eax,(%edx)
  803b0e:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803b11:	8b 40 04             	mov    0x4(%eax),%eax
  803b14:	85 c0                	test   %eax,%eax
  803b16:	74 0f                	je     803b27 <alloc_block+0x3f1>
  803b18:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803b1b:	8b 40 04             	mov    0x4(%eax),%eax
  803b1e:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803b21:	8b 12                	mov    (%edx),%edx
  803b23:	89 10                	mov    %edx,(%eax)
  803b25:	eb 13                	jmp    803b3a <alloc_block+0x404>
  803b27:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803b2a:	8b 00                	mov    (%eax),%eax
  803b2c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803b2f:	c1 e2 04             	shl    $0x4,%edx
  803b32:	81 c2 80 e0 81 00    	add    $0x81e080,%edx
  803b38:	89 02                	mov    %eax,(%edx)
  803b3a:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803b3d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803b43:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803b46:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803b4d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803b50:	c1 e0 04             	shl    $0x4,%eax
  803b53:	05 8c e0 81 00       	add    $0x81e08c,%eax
  803b58:	8b 00                	mov    (%eax),%eax
  803b5a:	8d 50 ff             	lea    -0x1(%eax),%edx
  803b5d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803b60:	c1 e0 04             	shl    $0x4,%eax
  803b63:	05 8c e0 81 00       	add    $0x81e08c,%eax
  803b68:	89 10                	mov    %edx,(%eax)

			uint32 page_index = ((uint32)block - dynAllocStart)/ PAGE_SIZE;
  803b6a:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803b6d:	a1 64 e0 81 00       	mov    0x81e064,%eax
  803b72:	29 c2                	sub    %eax,%edx
  803b74:	89 d0                	mov    %edx,%eax
  803b76:	c1 e8 0c             	shr    $0xc,%eax
  803b79:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			pageBlockInfoArr[page_index].num_of_free_blocks-- ;
  803b7c:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  803b7f:	89 d0                	mov    %edx,%eax
  803b81:	01 c0                	add    %eax,%eax
  803b83:	01 d0                	add    %edx,%eax
  803b85:	c1 e0 02             	shl    $0x2,%eax
  803b88:	05 6a 60 80 00       	add    $0x80606a,%eax
  803b8d:	66 8b 00             	mov    (%eax),%ax
  803b90:	8d 50 ff             	lea    -0x1(%eax),%edx
  803b93:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  803b96:	89 c8                	mov    %ecx,%eax
  803b98:	01 c0                	add    %eax,%eax
  803b9a:	01 c8                	add    %ecx,%eax
  803b9c:	c1 e0 02             	shl    $0x2,%eax
  803b9f:	05 6a 60 80 00       	add    $0x80606a,%eax
  803ba4:	66 89 10             	mov    %dx,(%eax)

			return (void*)block;
  803ba7:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803baa:	eb 24                	jmp    803bd0 <alloc_block+0x49a>
		}
		return(void*)page_va;
	}


	for(int i =list_index+1; i<= LOG2_MAX_SIZE - LOG2_MIN_SIZE; i++){
  803bac:	ff 45 ec             	incl   -0x14(%ebp)
  803baf:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  803bb3:	0f 8e e6 fe ff ff    	jle    803a9f <alloc_block+0x369>

			return (void*)block;
		}
	}

	panic("alloc_block: out of memory! ");
  803bb9:	83 ec 04             	sub    $0x4,%esp
  803bbc:	68 cf 4d 80 00       	push   $0x804dcf
  803bc1:	68 b1 00 00 00       	push   $0xb1
  803bc6:	68 53 4d 80 00       	push   $0x804d53
  803bcb:	e8 87 04 00 00       	call   804057 <_panic>

	//Comment the following line
	//panic("alloc_block() Not implemented yet");

	//TODO: [PROJECT'25.BONUS#1] DYNAMIC ALLOCATOR - block if no free block
}
  803bd0:	c9                   	leave  
  803bd1:	c3                   	ret    

00803bd2 <free_block>:

//===========================
// [4] FREE BLOCK:
//===========================
void free_block(void *va)
{
  803bd2:	55                   	push   %ebp
  803bd3:	89 e5                	mov    %esp,%ebp
  803bd5:	83 ec 38             	sub    $0x38,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert((uint32)va >= dynAllocStart && (uint32)va < dynAllocEnd);
  803bd8:	8b 55 08             	mov    0x8(%ebp),%edx
  803bdb:	a1 64 e0 81 00       	mov    0x81e064,%eax
  803be0:	39 c2                	cmp    %eax,%edx
  803be2:	72 0c                	jb     803bf0 <free_block+0x1e>
  803be4:	8b 55 08             	mov    0x8(%ebp),%edx
  803be7:	a1 40 60 80 00       	mov    0x806040,%eax
  803bec:	39 c2                	cmp    %eax,%edx
  803bee:	72 19                	jb     803c09 <free_block+0x37>
  803bf0:	68 ec 4d 80 00       	push   $0x804dec
  803bf5:	68 3e 4d 80 00       	push   $0x804d3e
  803bfa:	68 c3 00 00 00       	push   $0xc3
  803bff:	68 53 4d 80 00       	push   $0x804d53
  803c04:	e8 4e 04 00 00       	call   804057 <_panic>
	//==================================================================================

	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #4 free_block
	//Your code is here

	uint32 page_index=((uint32)va - dynAllocStart)/ PAGE_SIZE;
  803c09:	8b 55 08             	mov    0x8(%ebp),%edx
  803c0c:	a1 64 e0 81 00       	mov    0x81e064,%eax
  803c11:	29 c2                	sub    %eax,%edx
  803c13:	89 d0                	mov    %edx,%eax
  803c15:	c1 e8 0c             	shr    $0xc,%eax
  803c18:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 block_size = pageBlockInfoArr[page_index].block_size;
  803c1b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803c1e:	89 d0                	mov    %edx,%eax
  803c20:	01 c0                	add    %eax,%eax
  803c22:	01 d0                	add    %edx,%eax
  803c24:	c1 e0 02             	shl    $0x2,%eax
  803c27:	05 68 60 80 00       	add    $0x806068,%eax
  803c2c:	8b 00                	mov    (%eax),%eax
  803c2e:	0f b7 c0             	movzwl %ax,%eax
  803c31:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if(block_size == 0){
  803c34:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803c38:	75 17                	jne    803c51 <free_block+0x7f>
		panic("page is empty(already not allocated)");
  803c3a:	83 ec 04             	sub    $0x4,%esp
  803c3d:	68 24 4e 80 00       	push   $0x804e24
  803c42:	68 cf 00 00 00       	push   $0xcf
  803c47:	68 53 4d 80 00       	push   $0x804d53
  803c4c:	e8 06 04 00 00       	call   804057 <_panic>
	}

	int list_index = log2(block_size) - LOG2_MIN_SIZE;
  803c51:	83 ec 0c             	sub    $0xc,%esp
  803c54:	ff 75 ec             	pushl  -0x14(%ebp)
  803c57:	e8 d8 f8 ff ff       	call   803534 <log2>
  803c5c:	83 c4 10             	add    $0x10,%esp
  803c5f:	83 e8 03             	sub    $0x3,%eax
  803c62:	89 45 e8             	mov    %eax,-0x18(%ebp)
	// mn va l block "elta7weel mn virtual l phy hna"
	struct BlockElement *block = (struct BlockElement *)va;
  803c65:	8b 45 08             	mov    0x8(%ebp),%eax
  803c68:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	LIST_INSERT_TAIL(&freeBlockLists[list_index], block);
  803c6b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803c6f:	75 17                	jne    803c88 <free_block+0xb6>
  803c71:	83 ec 04             	sub    $0x4,%esp
  803c74:	68 ac 4d 80 00       	push   $0x804dac
  803c79:	68 d5 00 00 00       	push   $0xd5
  803c7e:	68 53 4d 80 00       	push   $0x804d53
  803c83:	e8 cf 03 00 00       	call   804057 <_panic>
  803c88:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803c8b:	c1 e0 04             	shl    $0x4,%eax
  803c8e:	05 84 e0 81 00       	add    $0x81e084,%eax
  803c93:	8b 10                	mov    (%eax),%edx
  803c95:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803c98:	89 50 04             	mov    %edx,0x4(%eax)
  803c9b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803c9e:	8b 40 04             	mov    0x4(%eax),%eax
  803ca1:	85 c0                	test   %eax,%eax
  803ca3:	74 14                	je     803cb9 <free_block+0xe7>
  803ca5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803ca8:	c1 e0 04             	shl    $0x4,%eax
  803cab:	05 84 e0 81 00       	add    $0x81e084,%eax
  803cb0:	8b 00                	mov    (%eax),%eax
  803cb2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803cb5:	89 10                	mov    %edx,(%eax)
  803cb7:	eb 11                	jmp    803cca <free_block+0xf8>
  803cb9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803cbc:	c1 e0 04             	shl    $0x4,%eax
  803cbf:	8d 90 80 e0 81 00    	lea    0x81e080(%eax),%edx
  803cc5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803cc8:	89 02                	mov    %eax,(%edx)
  803cca:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803ccd:	c1 e0 04             	shl    $0x4,%eax
  803cd0:	8d 90 84 e0 81 00    	lea    0x81e084(%eax),%edx
  803cd6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803cd9:	89 02                	mov    %eax,(%edx)
  803cdb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803cde:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803ce4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803ce7:	c1 e0 04             	shl    $0x4,%eax
  803cea:	05 8c e0 81 00       	add    $0x81e08c,%eax
  803cef:	8b 00                	mov    (%eax),%eax
  803cf1:	8d 50 01             	lea    0x1(%eax),%edx
  803cf4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803cf7:	c1 e0 04             	shl    $0x4,%eax
  803cfa:	05 8c e0 81 00       	add    $0x81e08c,%eax
  803cff:	89 10                	mov    %edx,(%eax)
	// b3d ma wdytha fy el freeBlockLists hzwed elfree elly fy el array 1
	pageBlockInfoArr[page_index].num_of_free_blocks++;
  803d01:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803d04:	89 d0                	mov    %edx,%eax
  803d06:	01 c0                	add    %eax,%eax
  803d08:	01 d0                	add    %edx,%eax
  803d0a:	c1 e0 02             	shl    $0x2,%eax
  803d0d:	05 6a 60 80 00       	add    $0x80606a,%eax
  803d12:	66 8b 00             	mov    (%eax),%ax
  803d15:	8d 50 01             	lea    0x1(%eax),%edx
  803d18:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  803d1b:	89 c8                	mov    %ecx,%eax
  803d1d:	01 c0                	add    %eax,%eax
  803d1f:	01 c8                	add    %ecx,%eax
  803d21:	c1 e0 02             	shl    $0x2,%eax
  803d24:	05 6a 60 80 00       	add    $0x80606a,%eax
  803d29:	66 89 10             	mov    %dx,(%eax)
	int blocks_number = PAGE_SIZE / block_size;
  803d2c:	b8 00 10 00 00       	mov    $0x1000,%eax
  803d31:	ba 00 00 00 00       	mov    $0x0,%edx
  803d36:	f7 75 ec             	divl   -0x14(%ebp)
  803d39:	89 45 e0             	mov    %eax,-0x20(%ebp)
	if(pageBlockInfoArr[page_index].num_of_free_blocks == blocks_number){
  803d3c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803d3f:	89 d0                	mov    %edx,%eax
  803d41:	01 c0                	add    %eax,%eax
  803d43:	01 d0                	add    %edx,%eax
  803d45:	c1 e0 02             	shl    $0x2,%eax
  803d48:	05 6a 60 80 00       	add    $0x80606a,%eax
  803d4d:	66 8b 00             	mov    (%eax),%ax
  803d50:	0f b7 c0             	movzwl %ax,%eax
  803d53:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  803d56:	0f 85 d3 01 00 00    	jne    803f2f <free_block+0x35d>
		struct BlockElement *itr = LIST_FIRST(&freeBlockLists[list_index]);
  803d5c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803d5f:	c1 e0 04             	shl    $0x4,%eax
  803d62:	05 80 e0 81 00       	add    $0x81e080,%eax
  803d67:	8b 00                	mov    (%eax),%eax
  803d69:	89 45 f4             	mov    %eax,-0xc(%ebp)
		while(itr != NULL){
  803d6c:	e9 f1 00 00 00       	jmp    803e62 <free_block+0x290>
			//lw ms7to el pointer mydy34 ->
			struct BlockElement *next = LIST_NEXT(itr);
  803d71:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d74:	8b 00                	mov    (%eax),%eax
  803d76:	89 45 dc             	mov    %eax,-0x24(%ebp)
			uint32 page_beginning_address= dynAllocStart + page_index * PAGE_SIZE;
  803d79:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803d7c:	c1 e0 0c             	shl    $0xc,%eax
  803d7f:	89 c2                	mov    %eax,%edx
  803d81:	a1 64 e0 81 00       	mov    0x81e064,%eax
  803d86:	01 d0                	add    %edx,%eax
  803d88:	89 45 d8             	mov    %eax,-0x28(%ebp)
			uint32 page_end_address = dynAllocStart + (page_index +1 )* PAGE_SIZE;
  803d8b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803d8e:	40                   	inc    %eax
  803d8f:	c1 e0 0c             	shl    $0xc,%eax
  803d92:	89 c2                	mov    %eax,%edx
  803d94:	a1 64 e0 81 00       	mov    0x81e064,%eax
  803d99:	01 d0                	add    %edx,%eax
  803d9b:	89 45 d4             	mov    %eax,-0x2c(%ebp)

			if((uint32)itr >= page_beginning_address && (uint32)itr < page_end_address){
  803d9e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803da1:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  803da4:	0f 82 b8 00 00 00    	jb     803e62 <free_block+0x290>
  803daa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803dad:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803db0:	0f 83 ac 00 00 00    	jae    803e62 <free_block+0x290>
				LIST_REMOVE(&freeBlockLists[list_index], itr);
  803db6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803dba:	75 17                	jne    803dd3 <free_block+0x201>
  803dbc:	83 ec 04             	sub    $0x4,%esp
  803dbf:	68 8d 4d 80 00       	push   $0x804d8d
  803dc4:	68 e2 00 00 00       	push   $0xe2
  803dc9:	68 53 4d 80 00       	push   $0x804d53
  803dce:	e8 84 02 00 00       	call   804057 <_panic>
  803dd3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803dd6:	8b 00                	mov    (%eax),%eax
  803dd8:	85 c0                	test   %eax,%eax
  803dda:	74 10                	je     803dec <free_block+0x21a>
  803ddc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ddf:	8b 00                	mov    (%eax),%eax
  803de1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803de4:	8b 52 04             	mov    0x4(%edx),%edx
  803de7:	89 50 04             	mov    %edx,0x4(%eax)
  803dea:	eb 14                	jmp    803e00 <free_block+0x22e>
  803dec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803def:	8b 40 04             	mov    0x4(%eax),%eax
  803df2:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803df5:	c1 e2 04             	shl    $0x4,%edx
  803df8:	81 c2 84 e0 81 00    	add    $0x81e084,%edx
  803dfe:	89 02                	mov    %eax,(%edx)
  803e00:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e03:	8b 40 04             	mov    0x4(%eax),%eax
  803e06:	85 c0                	test   %eax,%eax
  803e08:	74 0f                	je     803e19 <free_block+0x247>
  803e0a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e0d:	8b 40 04             	mov    0x4(%eax),%eax
  803e10:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803e13:	8b 12                	mov    (%edx),%edx
  803e15:	89 10                	mov    %edx,(%eax)
  803e17:	eb 13                	jmp    803e2c <free_block+0x25a>
  803e19:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e1c:	8b 00                	mov    (%eax),%eax
  803e1e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803e21:	c1 e2 04             	shl    $0x4,%edx
  803e24:	81 c2 80 e0 81 00    	add    $0x81e080,%edx
  803e2a:	89 02                	mov    %eax,(%edx)
  803e2c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e2f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803e35:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e38:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803e3f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803e42:	c1 e0 04             	shl    $0x4,%eax
  803e45:	05 8c e0 81 00       	add    $0x81e08c,%eax
  803e4a:	8b 00                	mov    (%eax),%eax
  803e4c:	8d 50 ff             	lea    -0x1(%eax),%edx
  803e4f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803e52:	c1 e0 04             	shl    $0x4,%eax
  803e55:	05 8c e0 81 00       	add    $0x81e08c,%eax
  803e5a:	89 10                	mov    %edx,(%eax)
				//y5o4 3la elly b3do
				itr = next;
  803e5c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803e5f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// b3d ma wdytha fy el freeBlockLists hzwed elfree elly fy el array 1
	pageBlockInfoArr[page_index].num_of_free_blocks++;
	int blocks_number = PAGE_SIZE / block_size;
	if(pageBlockInfoArr[page_index].num_of_free_blocks == blocks_number){
		struct BlockElement *itr = LIST_FIRST(&freeBlockLists[list_index]);
		while(itr != NULL){
  803e62:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803e66:	0f 85 05 ff ff ff    	jne    803d71 <free_block+0x19f>
				LIST_REMOVE(&freeBlockLists[list_index], itr);
				//y5o4 3la elly b3do
				itr = next;
			}
		}
		pageBlockInfoArr[page_index].block_size=0;
  803e6c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803e6f:	89 d0                	mov    %edx,%eax
  803e71:	01 c0                	add    %eax,%eax
  803e73:	01 d0                	add    %edx,%eax
  803e75:	c1 e0 02             	shl    $0x2,%eax
  803e78:	05 68 60 80 00       	add    $0x806068,%eax
  803e7d:	66 c7 00 00 00       	movw   $0x0,(%eax)
		pageBlockInfoArr[page_index].num_of_free_blocks=0;
  803e82:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803e85:	89 d0                	mov    %edx,%eax
  803e87:	01 c0                	add    %eax,%eax
  803e89:	01 d0                	add    %edx,%eax
  803e8b:	c1 e0 02             	shl    $0x2,%eax
  803e8e:	05 6a 60 80 00       	add    $0x80606a,%eax
  803e93:	66 c7 00 00 00       	movw   $0x0,(%eax)

		struct PageInfoElement *page_info = &pageBlockInfoArr[page_index];
  803e98:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803e9b:	89 d0                	mov    %edx,%eax
  803e9d:	01 c0                	add    %eax,%eax
  803e9f:	01 d0                	add    %edx,%eax
  803ea1:	c1 e0 02             	shl    $0x2,%eax
  803ea4:	05 60 60 80 00       	add    $0x806060,%eax
  803ea9:	89 45 d0             	mov    %eax,-0x30(%ebp)
		LIST_INSERT_TAIL(&freePagesList, page_info);
  803eac:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  803eb0:	75 17                	jne    803ec9 <free_block+0x2f7>
  803eb2:	83 ec 04             	sub    $0x4,%esp
  803eb5:	68 ac 4d 80 00       	push   $0x804dac
  803eba:	68 eb 00 00 00       	push   $0xeb
  803ebf:	68 53 4d 80 00       	push   $0x804d53
  803ec4:	e8 8e 01 00 00       	call   804057 <_panic>
  803ec9:	8b 15 4c 60 80 00    	mov    0x80604c,%edx
  803ecf:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803ed2:	89 50 04             	mov    %edx,0x4(%eax)
  803ed5:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803ed8:	8b 40 04             	mov    0x4(%eax),%eax
  803edb:	85 c0                	test   %eax,%eax
  803edd:	74 0c                	je     803eeb <free_block+0x319>
  803edf:	a1 4c 60 80 00       	mov    0x80604c,%eax
  803ee4:	8b 55 d0             	mov    -0x30(%ebp),%edx
  803ee7:	89 10                	mov    %edx,(%eax)
  803ee9:	eb 08                	jmp    803ef3 <free_block+0x321>
  803eeb:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803eee:	a3 48 60 80 00       	mov    %eax,0x806048
  803ef3:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803ef6:	a3 4c 60 80 00       	mov    %eax,0x80604c
  803efb:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803efe:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803f04:	a1 54 60 80 00       	mov    0x806054,%eax
  803f09:	40                   	inc    %eax
  803f0a:	a3 54 60 80 00       	mov    %eax,0x806054
		uint32 page_va = to_page_va(page_info);
  803f0f:	83 ec 0c             	sub    $0xc,%esp
  803f12:	ff 75 d0             	pushl  -0x30(%ebp)
  803f15:	e8 ce f5 ff ff       	call   8034e8 <to_page_va>
  803f1a:	83 c4 10             	add    $0x10,%esp
  803f1d:	89 45 cc             	mov    %eax,-0x34(%ebp)
		return_page((void *)page_va);
  803f20:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803f23:	83 ec 0c             	sub    $0xc,%esp
  803f26:	50                   	push   %eax
  803f27:	e8 9e d7 ff ff       	call   8016ca <return_page>
  803f2c:	83 c4 10             	add    $0x10,%esp
	}


	//Comment the following line
	//panic("free_block() Not implemented yet");
}
  803f2f:	90                   	nop
  803f30:	c9                   	leave  
  803f31:	c3                   	ret    

00803f32 <realloc_block>:

//===========================
// [1] REALLOCATE BLOCK:
//===========================
void *realloc_block(void* va, uint32 new_size)
{
  803f32:	55                   	push   %ebp
  803f33:	89 e5                	mov    %esp,%ebp
  803f35:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.BONUS#2] KERNEL REALLOC - realloc_block
	//Your code is here
	//Comment the following line
	panic("realloc_block() Not implemented yet");
  803f38:	83 ec 04             	sub    $0x4,%esp
  803f3b:	68 4c 4e 80 00       	push   $0x804e4c
  803f40:	68 01 01 00 00       	push   $0x101
  803f45:	68 53 4d 80 00       	push   $0x804d53
  803f4a:	e8 08 01 00 00       	call   804057 <_panic>

00803f4f <init_uspinlock>:
#include "inc/uspinlock.h"

extern volatile struct Env *myEnv;

void init_uspinlock(struct uspinlock *lk, char *name, bool isOpened)
{
  803f4f:	55                   	push   %ebp
  803f50:	89 e5                	mov    %esp,%ebp
  803f52:	83 ec 08             	sub    $0x8,%esp
	assert(isOpened == 0 || isOpened == 1);
  803f55:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  803f59:	74 1c                	je     803f77 <init_uspinlock+0x28>
  803f5b:	83 7d 10 01          	cmpl   $0x1,0x10(%ebp)
  803f5f:	74 16                	je     803f77 <init_uspinlock+0x28>
  803f61:	68 70 4e 80 00       	push   $0x804e70
  803f66:	68 8f 4e 80 00       	push   $0x804e8f
  803f6b:	6a 10                	push   $0x10
  803f6d:	68 a4 4e 80 00       	push   $0x804ea4
  803f72:	e8 e0 00 00 00       	call   804057 <_panic>
	strcpy(lk->name, name);
  803f77:	8b 45 08             	mov    0x8(%ebp),%eax
  803f7a:	83 c0 04             	add    $0x4,%eax
  803f7d:	83 ec 08             	sub    $0x8,%esp
  803f80:	ff 75 0c             	pushl  0xc(%ebp)
  803f83:	50                   	push   %eax
  803f84:	e8 90 ce ff ff       	call   800e19 <strcpy>
  803f89:	83 c4 10             	add    $0x10,%esp
	lk->locked = (1 - isOpened);
  803f8c:	b8 01 00 00 00       	mov    $0x1,%eax
  803f91:	2b 45 10             	sub    0x10(%ebp),%eax
  803f94:	89 c2                	mov    %eax,%edx
  803f96:	8b 45 08             	mov    0x8(%ebp),%eax
  803f99:	89 10                	mov    %edx,(%eax)
}
  803f9b:	90                   	nop
  803f9c:	c9                   	leave  
  803f9d:	c3                   	ret    

00803f9e <acquire_uspinlock>:
// Acquire the lock.
// Loops (spins) until the lock is acquired.
// Holding a lock for a long time may cause
// other CPUs to waste time spinning to acquire it.
void acquire_uspinlock(struct uspinlock *lk)
{
  803f9e:	55                   	push   %ebp
  803f9f:	89 e5                	mov    %esp,%ebp
  803fa1:	83 ec 18             	sub    $0x18,%esp
	// The xchg is atomic.
	while(xchg(&lk->locked, 1) != 0) ;
  803fa4:	90                   	nop
  803fa5:	8b 45 08             	mov    0x8(%ebp),%eax
  803fa8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803fab:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
xchg(volatile uint32 *addr, uint32 newval)
{
  uint32 result;

  // The + in "+m" denotes a read-modify-write operand.
  __asm __volatile("lock; xchgl %0, %1" :
  803fb2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803fb5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803fb8:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  803fbb:	f0 87 02             	lock xchg %eax,(%edx)
  803fbe:	89 45 ec             	mov    %eax,-0x14(%ebp)
               "+m" (*addr), "=a" (result) :
               "1" (newval) :
               "cc");
  return result;
  803fc1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803fc4:	85 c0                	test   %eax,%eax
  803fc6:	75 dd                	jne    803fa5 <acquire_uspinlock+0x7>

	cprintf("[%d: %s] ACQUIRED spinlock [%s]\n", myEnv->env_id, myEnv->prog_name, lk->name);
  803fc8:	8b 45 08             	mov    0x8(%ebp),%eax
  803fcb:	8d 48 04             	lea    0x4(%eax),%ecx
  803fce:	a1 20 60 80 00       	mov    0x806020,%eax
  803fd3:	8d 50 20             	lea    0x20(%eax),%edx
  803fd6:	a1 20 60 80 00       	mov    0x806020,%eax
  803fdb:	8b 40 10             	mov    0x10(%eax),%eax
  803fde:	51                   	push   %ecx
  803fdf:	52                   	push   %edx
  803fe0:	50                   	push   %eax
  803fe1:	68 b4 4e 80 00       	push   $0x804eb4
  803fe6:	e8 06 c7 ff ff       	call   8006f1 <cprintf>
  803feb:	83 c4 10             	add    $0x10,%esp

	// Tell the C compiler and the processor to not move loads or stores
	// past this point, to ensure that the critical section's memory
	// references happen after the lock is acquired.
	__sync_synchronize();
  803fee:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
}
  803ff3:	90                   	nop
  803ff4:	c9                   	leave  
  803ff5:	c3                   	ret    

00803ff6 <release_uspinlock>:

// Release the lock.
void release_uspinlock(struct uspinlock *lk)
{
  803ff6:	55                   	push   %ebp
  803ff7:	89 e5                	mov    %esp,%ebp
  803ff9:	83 ec 08             	sub    $0x8,%esp
	if(!(lk->locked))
  803ffc:	8b 45 08             	mov    0x8(%ebp),%eax
  803fff:	8b 00                	mov    (%eax),%eax
  804001:	85 c0                	test   %eax,%eax
  804003:	75 18                	jne    80401d <release_uspinlock+0x27>
	{
		panic("release: lock \"%s\" is not held!", lk->name);
  804005:	8b 45 08             	mov    0x8(%ebp),%eax
  804008:	83 c0 04             	add    $0x4,%eax
  80400b:	50                   	push   %eax
  80400c:	68 d8 4e 80 00       	push   $0x804ed8
  804011:	6a 2b                	push   $0x2b
  804013:	68 a4 4e 80 00       	push   $0x804ea4
  804018:	e8 3a 00 00 00       	call   804057 <_panic>
	// Tell the C compiler and the processor to not move loads or stores
	// past this point, to ensure that all the stores in the critical
	// section are visible to other cores before the lock is released.
	// Both the C compiler and the hardware may re-order loads and
	// stores; __sync_synchronize() tells them both not to.
	__sync_synchronize();
  80401d:	f0 83 0c 24 00       	lock orl $0x0,(%esp)

	// Release the lock, equivalent to lk->locked = 0.
	// This code can't use a C assignment, since it might
	// not be atomic. A real OS would use C atomics here.
	asm volatile("movl $0, %0" : "+m" (lk->locked) : );
  804022:	8b 45 08             	mov    0x8(%ebp),%eax
  804025:	8b 55 08             	mov    0x8(%ebp),%edx
  804028:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	cprintf("[%d: %s] RELEASED spinlock [%s]\n", myEnv->env_id, myEnv->prog_name, lk->name);
  80402e:	8b 45 08             	mov    0x8(%ebp),%eax
  804031:	8d 48 04             	lea    0x4(%eax),%ecx
  804034:	a1 20 60 80 00       	mov    0x806020,%eax
  804039:	8d 50 20             	lea    0x20(%eax),%edx
  80403c:	a1 20 60 80 00       	mov    0x806020,%eax
  804041:	8b 40 10             	mov    0x10(%eax),%eax
  804044:	51                   	push   %ecx
  804045:	52                   	push   %edx
  804046:	50                   	push   %eax
  804047:	68 f8 4e 80 00       	push   $0x804ef8
  80404c:	e8 a0 c6 ff ff       	call   8006f1 <cprintf>
  804051:	83 c4 10             	add    $0x10,%esp
}
  804054:	90                   	nop
  804055:	c9                   	leave  
  804056:	c3                   	ret    

00804057 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  804057:	55                   	push   %ebp
  804058:	89 e5                	mov    %esp,%ebp
  80405a:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  80405d:	8d 45 10             	lea    0x10(%ebp),%eax
  804060:	83 c0 04             	add    $0x4,%eax
  804063:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  804066:	a1 84 e1 81 00       	mov    0x81e184,%eax
  80406b:	85 c0                	test   %eax,%eax
  80406d:	74 16                	je     804085 <_panic+0x2e>
		cprintf("%s: ", argv0);
  80406f:	a1 84 e1 81 00       	mov    0x81e184,%eax
  804074:	83 ec 08             	sub    $0x8,%esp
  804077:	50                   	push   %eax
  804078:	68 1c 4f 80 00       	push   $0x804f1c
  80407d:	e8 6f c6 ff ff       	call   8006f1 <cprintf>
  804082:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  804085:	a1 04 60 80 00       	mov    0x806004,%eax
  80408a:	83 ec 0c             	sub    $0xc,%esp
  80408d:	ff 75 0c             	pushl  0xc(%ebp)
  804090:	ff 75 08             	pushl  0x8(%ebp)
  804093:	50                   	push   %eax
  804094:	68 24 4f 80 00       	push   $0x804f24
  804099:	6a 74                	push   $0x74
  80409b:	e8 7e c6 ff ff       	call   80071e <cprintf_colored>
  8040a0:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  8040a3:	8b 45 10             	mov    0x10(%ebp),%eax
  8040a6:	83 ec 08             	sub    $0x8,%esp
  8040a9:	ff 75 f4             	pushl  -0xc(%ebp)
  8040ac:	50                   	push   %eax
  8040ad:	e8 d0 c5 ff ff       	call   800682 <vcprintf>
  8040b2:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8040b5:	83 ec 08             	sub    $0x8,%esp
  8040b8:	6a 00                	push   $0x0
  8040ba:	68 4c 4f 80 00       	push   $0x804f4c
  8040bf:	e8 be c5 ff ff       	call   800682 <vcprintf>
  8040c4:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8040c7:	e8 37 c5 ff ff       	call   800603 <exit>

	// should not return here
	while (1) ;
  8040cc:	eb fe                	jmp    8040cc <_panic+0x75>

008040ce <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8040ce:	55                   	push   %ebp
  8040cf:	89 e5                	mov    %esp,%ebp
  8040d1:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8040d4:	a1 20 60 80 00       	mov    0x806020,%eax
  8040d9:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8040df:	8b 45 0c             	mov    0xc(%ebp),%eax
  8040e2:	39 c2                	cmp    %eax,%edx
  8040e4:	74 14                	je     8040fa <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8040e6:	83 ec 04             	sub    $0x4,%esp
  8040e9:	68 50 4f 80 00       	push   $0x804f50
  8040ee:	6a 26                	push   $0x26
  8040f0:	68 9c 4f 80 00       	push   $0x804f9c
  8040f5:	e8 5d ff ff ff       	call   804057 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8040fa:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  804101:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  804108:	e9 c5 00 00 00       	jmp    8041d2 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  80410d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804110:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  804117:	8b 45 08             	mov    0x8(%ebp),%eax
  80411a:	01 d0                	add    %edx,%eax
  80411c:	8b 00                	mov    (%eax),%eax
  80411e:	85 c0                	test   %eax,%eax
  804120:	75 08                	jne    80412a <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  804122:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  804125:	e9 a5 00 00 00       	jmp    8041cf <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  80412a:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  804131:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  804138:	eb 69                	jmp    8041a3 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  80413a:	a1 20 60 80 00       	mov    0x806020,%eax
  80413f:	8b 88 a4 05 00 00    	mov    0x5a4(%eax),%ecx
  804145:	8b 55 e8             	mov    -0x18(%ebp),%edx
  804148:	89 d0                	mov    %edx,%eax
  80414a:	01 c0                	add    %eax,%eax
  80414c:	01 d0                	add    %edx,%eax
  80414e:	c1 e0 03             	shl    $0x3,%eax
  804151:	01 c8                	add    %ecx,%eax
  804153:	8a 40 04             	mov    0x4(%eax),%al
  804156:	84 c0                	test   %al,%al
  804158:	75 46                	jne    8041a0 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80415a:	a1 20 60 80 00       	mov    0x806020,%eax
  80415f:	8b 88 a4 05 00 00    	mov    0x5a4(%eax),%ecx
  804165:	8b 55 e8             	mov    -0x18(%ebp),%edx
  804168:	89 d0                	mov    %edx,%eax
  80416a:	01 c0                	add    %eax,%eax
  80416c:	01 d0                	add    %edx,%eax
  80416e:	c1 e0 03             	shl    $0x3,%eax
  804171:	01 c8                	add    %ecx,%eax
  804173:	8b 00                	mov    (%eax),%eax
  804175:	89 45 dc             	mov    %eax,-0x24(%ebp)
  804178:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80417b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  804180:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  804182:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804185:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80418c:	8b 45 08             	mov    0x8(%ebp),%eax
  80418f:	01 c8                	add    %ecx,%eax
  804191:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  804193:	39 c2                	cmp    %eax,%edx
  804195:	75 09                	jne    8041a0 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  804197:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  80419e:	eb 15                	jmp    8041b5 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8041a0:	ff 45 e8             	incl   -0x18(%ebp)
  8041a3:	a1 20 60 80 00       	mov    0x806020,%eax
  8041a8:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8041ae:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8041b1:	39 c2                	cmp    %eax,%edx
  8041b3:	77 85                	ja     80413a <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8041b5:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8041b9:	75 14                	jne    8041cf <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  8041bb:	83 ec 04             	sub    $0x4,%esp
  8041be:	68 a8 4f 80 00       	push   $0x804fa8
  8041c3:	6a 3a                	push   $0x3a
  8041c5:	68 9c 4f 80 00       	push   $0x804f9c
  8041ca:	e8 88 fe ff ff       	call   804057 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8041cf:	ff 45 f0             	incl   -0x10(%ebp)
  8041d2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8041d5:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8041d8:	0f 8c 2f ff ff ff    	jl     80410d <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8041de:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8041e5:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8041ec:	eb 26                	jmp    804214 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  8041ee:	a1 20 60 80 00       	mov    0x806020,%eax
  8041f3:	8b 88 a4 05 00 00    	mov    0x5a4(%eax),%ecx
  8041f9:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8041fc:	89 d0                	mov    %edx,%eax
  8041fe:	01 c0                	add    %eax,%eax
  804200:	01 d0                	add    %edx,%eax
  804202:	c1 e0 03             	shl    $0x3,%eax
  804205:	01 c8                	add    %ecx,%eax
  804207:	8a 40 04             	mov    0x4(%eax),%al
  80420a:	3c 01                	cmp    $0x1,%al
  80420c:	75 03                	jne    804211 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  80420e:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  804211:	ff 45 e0             	incl   -0x20(%ebp)
  804214:	a1 20 60 80 00       	mov    0x806020,%eax
  804219:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  80421f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  804222:	39 c2                	cmp    %eax,%edx
  804224:	77 c8                	ja     8041ee <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  804226:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804229:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80422c:	74 14                	je     804242 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  80422e:	83 ec 04             	sub    $0x4,%esp
  804231:	68 fc 4f 80 00       	push   $0x804ffc
  804236:	6a 44                	push   $0x44
  804238:	68 9c 4f 80 00       	push   $0x804f9c
  80423d:	e8 15 fe ff ff       	call   804057 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  804242:	90                   	nop
  804243:	c9                   	leave  
  804244:	c3                   	ret    
  804245:	66 90                	xchg   %ax,%ax
  804247:	90                   	nop

00804248 <__udivdi3>:
  804248:	55                   	push   %ebp
  804249:	57                   	push   %edi
  80424a:	56                   	push   %esi
  80424b:	53                   	push   %ebx
  80424c:	83 ec 1c             	sub    $0x1c,%esp
  80424f:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  804253:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  804257:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80425b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80425f:	89 ca                	mov    %ecx,%edx
  804261:	89 f8                	mov    %edi,%eax
  804263:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  804267:	85 f6                	test   %esi,%esi
  804269:	75 2d                	jne    804298 <__udivdi3+0x50>
  80426b:	39 cf                	cmp    %ecx,%edi
  80426d:	77 65                	ja     8042d4 <__udivdi3+0x8c>
  80426f:	89 fd                	mov    %edi,%ebp
  804271:	85 ff                	test   %edi,%edi
  804273:	75 0b                	jne    804280 <__udivdi3+0x38>
  804275:	b8 01 00 00 00       	mov    $0x1,%eax
  80427a:	31 d2                	xor    %edx,%edx
  80427c:	f7 f7                	div    %edi
  80427e:	89 c5                	mov    %eax,%ebp
  804280:	31 d2                	xor    %edx,%edx
  804282:	89 c8                	mov    %ecx,%eax
  804284:	f7 f5                	div    %ebp
  804286:	89 c1                	mov    %eax,%ecx
  804288:	89 d8                	mov    %ebx,%eax
  80428a:	f7 f5                	div    %ebp
  80428c:	89 cf                	mov    %ecx,%edi
  80428e:	89 fa                	mov    %edi,%edx
  804290:	83 c4 1c             	add    $0x1c,%esp
  804293:	5b                   	pop    %ebx
  804294:	5e                   	pop    %esi
  804295:	5f                   	pop    %edi
  804296:	5d                   	pop    %ebp
  804297:	c3                   	ret    
  804298:	39 ce                	cmp    %ecx,%esi
  80429a:	77 28                	ja     8042c4 <__udivdi3+0x7c>
  80429c:	0f bd fe             	bsr    %esi,%edi
  80429f:	83 f7 1f             	xor    $0x1f,%edi
  8042a2:	75 40                	jne    8042e4 <__udivdi3+0x9c>
  8042a4:	39 ce                	cmp    %ecx,%esi
  8042a6:	72 0a                	jb     8042b2 <__udivdi3+0x6a>
  8042a8:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8042ac:	0f 87 9e 00 00 00    	ja     804350 <__udivdi3+0x108>
  8042b2:	b8 01 00 00 00       	mov    $0x1,%eax
  8042b7:	89 fa                	mov    %edi,%edx
  8042b9:	83 c4 1c             	add    $0x1c,%esp
  8042bc:	5b                   	pop    %ebx
  8042bd:	5e                   	pop    %esi
  8042be:	5f                   	pop    %edi
  8042bf:	5d                   	pop    %ebp
  8042c0:	c3                   	ret    
  8042c1:	8d 76 00             	lea    0x0(%esi),%esi
  8042c4:	31 ff                	xor    %edi,%edi
  8042c6:	31 c0                	xor    %eax,%eax
  8042c8:	89 fa                	mov    %edi,%edx
  8042ca:	83 c4 1c             	add    $0x1c,%esp
  8042cd:	5b                   	pop    %ebx
  8042ce:	5e                   	pop    %esi
  8042cf:	5f                   	pop    %edi
  8042d0:	5d                   	pop    %ebp
  8042d1:	c3                   	ret    
  8042d2:	66 90                	xchg   %ax,%ax
  8042d4:	89 d8                	mov    %ebx,%eax
  8042d6:	f7 f7                	div    %edi
  8042d8:	31 ff                	xor    %edi,%edi
  8042da:	89 fa                	mov    %edi,%edx
  8042dc:	83 c4 1c             	add    $0x1c,%esp
  8042df:	5b                   	pop    %ebx
  8042e0:	5e                   	pop    %esi
  8042e1:	5f                   	pop    %edi
  8042e2:	5d                   	pop    %ebp
  8042e3:	c3                   	ret    
  8042e4:	bd 20 00 00 00       	mov    $0x20,%ebp
  8042e9:	89 eb                	mov    %ebp,%ebx
  8042eb:	29 fb                	sub    %edi,%ebx
  8042ed:	89 f9                	mov    %edi,%ecx
  8042ef:	d3 e6                	shl    %cl,%esi
  8042f1:	89 c5                	mov    %eax,%ebp
  8042f3:	88 d9                	mov    %bl,%cl
  8042f5:	d3 ed                	shr    %cl,%ebp
  8042f7:	89 e9                	mov    %ebp,%ecx
  8042f9:	09 f1                	or     %esi,%ecx
  8042fb:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8042ff:	89 f9                	mov    %edi,%ecx
  804301:	d3 e0                	shl    %cl,%eax
  804303:	89 c5                	mov    %eax,%ebp
  804305:	89 d6                	mov    %edx,%esi
  804307:	88 d9                	mov    %bl,%cl
  804309:	d3 ee                	shr    %cl,%esi
  80430b:	89 f9                	mov    %edi,%ecx
  80430d:	d3 e2                	shl    %cl,%edx
  80430f:	8b 44 24 08          	mov    0x8(%esp),%eax
  804313:	88 d9                	mov    %bl,%cl
  804315:	d3 e8                	shr    %cl,%eax
  804317:	09 c2                	or     %eax,%edx
  804319:	89 d0                	mov    %edx,%eax
  80431b:	89 f2                	mov    %esi,%edx
  80431d:	f7 74 24 0c          	divl   0xc(%esp)
  804321:	89 d6                	mov    %edx,%esi
  804323:	89 c3                	mov    %eax,%ebx
  804325:	f7 e5                	mul    %ebp
  804327:	39 d6                	cmp    %edx,%esi
  804329:	72 19                	jb     804344 <__udivdi3+0xfc>
  80432b:	74 0b                	je     804338 <__udivdi3+0xf0>
  80432d:	89 d8                	mov    %ebx,%eax
  80432f:	31 ff                	xor    %edi,%edi
  804331:	e9 58 ff ff ff       	jmp    80428e <__udivdi3+0x46>
  804336:	66 90                	xchg   %ax,%ax
  804338:	8b 54 24 08          	mov    0x8(%esp),%edx
  80433c:	89 f9                	mov    %edi,%ecx
  80433e:	d3 e2                	shl    %cl,%edx
  804340:	39 c2                	cmp    %eax,%edx
  804342:	73 e9                	jae    80432d <__udivdi3+0xe5>
  804344:	8d 43 ff             	lea    -0x1(%ebx),%eax
  804347:	31 ff                	xor    %edi,%edi
  804349:	e9 40 ff ff ff       	jmp    80428e <__udivdi3+0x46>
  80434e:	66 90                	xchg   %ax,%ax
  804350:	31 c0                	xor    %eax,%eax
  804352:	e9 37 ff ff ff       	jmp    80428e <__udivdi3+0x46>
  804357:	90                   	nop

00804358 <__umoddi3>:
  804358:	55                   	push   %ebp
  804359:	57                   	push   %edi
  80435a:	56                   	push   %esi
  80435b:	53                   	push   %ebx
  80435c:	83 ec 1c             	sub    $0x1c,%esp
  80435f:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  804363:	8b 74 24 34          	mov    0x34(%esp),%esi
  804367:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80436b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80436f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  804373:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  804377:	89 f3                	mov    %esi,%ebx
  804379:	89 fa                	mov    %edi,%edx
  80437b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80437f:	89 34 24             	mov    %esi,(%esp)
  804382:	85 c0                	test   %eax,%eax
  804384:	75 1a                	jne    8043a0 <__umoddi3+0x48>
  804386:	39 f7                	cmp    %esi,%edi
  804388:	0f 86 a2 00 00 00    	jbe    804430 <__umoddi3+0xd8>
  80438e:	89 c8                	mov    %ecx,%eax
  804390:	89 f2                	mov    %esi,%edx
  804392:	f7 f7                	div    %edi
  804394:	89 d0                	mov    %edx,%eax
  804396:	31 d2                	xor    %edx,%edx
  804398:	83 c4 1c             	add    $0x1c,%esp
  80439b:	5b                   	pop    %ebx
  80439c:	5e                   	pop    %esi
  80439d:	5f                   	pop    %edi
  80439e:	5d                   	pop    %ebp
  80439f:	c3                   	ret    
  8043a0:	39 f0                	cmp    %esi,%eax
  8043a2:	0f 87 ac 00 00 00    	ja     804454 <__umoddi3+0xfc>
  8043a8:	0f bd e8             	bsr    %eax,%ebp
  8043ab:	83 f5 1f             	xor    $0x1f,%ebp
  8043ae:	0f 84 ac 00 00 00    	je     804460 <__umoddi3+0x108>
  8043b4:	bf 20 00 00 00       	mov    $0x20,%edi
  8043b9:	29 ef                	sub    %ebp,%edi
  8043bb:	89 fe                	mov    %edi,%esi
  8043bd:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8043c1:	89 e9                	mov    %ebp,%ecx
  8043c3:	d3 e0                	shl    %cl,%eax
  8043c5:	89 d7                	mov    %edx,%edi
  8043c7:	89 f1                	mov    %esi,%ecx
  8043c9:	d3 ef                	shr    %cl,%edi
  8043cb:	09 c7                	or     %eax,%edi
  8043cd:	89 e9                	mov    %ebp,%ecx
  8043cf:	d3 e2                	shl    %cl,%edx
  8043d1:	89 14 24             	mov    %edx,(%esp)
  8043d4:	89 d8                	mov    %ebx,%eax
  8043d6:	d3 e0                	shl    %cl,%eax
  8043d8:	89 c2                	mov    %eax,%edx
  8043da:	8b 44 24 08          	mov    0x8(%esp),%eax
  8043de:	d3 e0                	shl    %cl,%eax
  8043e0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8043e4:	8b 44 24 08          	mov    0x8(%esp),%eax
  8043e8:	89 f1                	mov    %esi,%ecx
  8043ea:	d3 e8                	shr    %cl,%eax
  8043ec:	09 d0                	or     %edx,%eax
  8043ee:	d3 eb                	shr    %cl,%ebx
  8043f0:	89 da                	mov    %ebx,%edx
  8043f2:	f7 f7                	div    %edi
  8043f4:	89 d3                	mov    %edx,%ebx
  8043f6:	f7 24 24             	mull   (%esp)
  8043f9:	89 c6                	mov    %eax,%esi
  8043fb:	89 d1                	mov    %edx,%ecx
  8043fd:	39 d3                	cmp    %edx,%ebx
  8043ff:	0f 82 87 00 00 00    	jb     80448c <__umoddi3+0x134>
  804405:	0f 84 91 00 00 00    	je     80449c <__umoddi3+0x144>
  80440b:	8b 54 24 04          	mov    0x4(%esp),%edx
  80440f:	29 f2                	sub    %esi,%edx
  804411:	19 cb                	sbb    %ecx,%ebx
  804413:	89 d8                	mov    %ebx,%eax
  804415:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  804419:	d3 e0                	shl    %cl,%eax
  80441b:	89 e9                	mov    %ebp,%ecx
  80441d:	d3 ea                	shr    %cl,%edx
  80441f:	09 d0                	or     %edx,%eax
  804421:	89 e9                	mov    %ebp,%ecx
  804423:	d3 eb                	shr    %cl,%ebx
  804425:	89 da                	mov    %ebx,%edx
  804427:	83 c4 1c             	add    $0x1c,%esp
  80442a:	5b                   	pop    %ebx
  80442b:	5e                   	pop    %esi
  80442c:	5f                   	pop    %edi
  80442d:	5d                   	pop    %ebp
  80442e:	c3                   	ret    
  80442f:	90                   	nop
  804430:	89 fd                	mov    %edi,%ebp
  804432:	85 ff                	test   %edi,%edi
  804434:	75 0b                	jne    804441 <__umoddi3+0xe9>
  804436:	b8 01 00 00 00       	mov    $0x1,%eax
  80443b:	31 d2                	xor    %edx,%edx
  80443d:	f7 f7                	div    %edi
  80443f:	89 c5                	mov    %eax,%ebp
  804441:	89 f0                	mov    %esi,%eax
  804443:	31 d2                	xor    %edx,%edx
  804445:	f7 f5                	div    %ebp
  804447:	89 c8                	mov    %ecx,%eax
  804449:	f7 f5                	div    %ebp
  80444b:	89 d0                	mov    %edx,%eax
  80444d:	e9 44 ff ff ff       	jmp    804396 <__umoddi3+0x3e>
  804452:	66 90                	xchg   %ax,%ax
  804454:	89 c8                	mov    %ecx,%eax
  804456:	89 f2                	mov    %esi,%edx
  804458:	83 c4 1c             	add    $0x1c,%esp
  80445b:	5b                   	pop    %ebx
  80445c:	5e                   	pop    %esi
  80445d:	5f                   	pop    %edi
  80445e:	5d                   	pop    %ebp
  80445f:	c3                   	ret    
  804460:	3b 04 24             	cmp    (%esp),%eax
  804463:	72 06                	jb     80446b <__umoddi3+0x113>
  804465:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  804469:	77 0f                	ja     80447a <__umoddi3+0x122>
  80446b:	89 f2                	mov    %esi,%edx
  80446d:	29 f9                	sub    %edi,%ecx
  80446f:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  804473:	89 14 24             	mov    %edx,(%esp)
  804476:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80447a:	8b 44 24 04          	mov    0x4(%esp),%eax
  80447e:	8b 14 24             	mov    (%esp),%edx
  804481:	83 c4 1c             	add    $0x1c,%esp
  804484:	5b                   	pop    %ebx
  804485:	5e                   	pop    %esi
  804486:	5f                   	pop    %edi
  804487:	5d                   	pop    %ebp
  804488:	c3                   	ret    
  804489:	8d 76 00             	lea    0x0(%esi),%esi
  80448c:	2b 04 24             	sub    (%esp),%eax
  80448f:	19 fa                	sbb    %edi,%edx
  804491:	89 d1                	mov    %edx,%ecx
  804493:	89 c6                	mov    %eax,%esi
  804495:	e9 71 ff ff ff       	jmp    80440b <__umoddi3+0xb3>
  80449a:	66 90                	xchg   %ax,%ax
  80449c:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8044a0:	72 ea                	jb     80448c <__umoddi3+0x134>
  8044a2:	89 d9                	mov    %ebx,%ecx
  8044a4:	e9 62 ff ff ff       	jmp    80440b <__umoddi3+0xb3>
